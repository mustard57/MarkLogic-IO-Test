import module namespace admin  = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";
import module namespace constants = "http://marklogic.com/io-test/constants" at "/app/constants.xqy";
import module namespace util = "http://marklogic.com/io-test/util" at "/app/util.xqy";

declare variable $run-time-data-fields := "forest-counts,batch-sizes,io-limits,merge-ratios,tree-sizes";
declare variable $db-name := $constants:DATA-DB-NAME;
declare variable $batch-start-time := fn:current-dateTime();

(: Create the appropriate for loops from the run data :)
declare function local:process-run-data-map($param-lists-map as map:map,$run-data-map as map:map){
  if(map:keys($param-lists-map)) then
    let $param-name := (for $key in map:keys($param-lists-map) order by $key return $key)[1]
    let $param-values := map:get($param-lists-map,$param-name)
    let $new-map := map:map()
    let $null := for $key in map:keys($param-lists-map) return if($key != $param-name) then map:put($new-map,$key,map:get($param-lists-map,$key)) else()
    return
    for $param-value in fn:tokenize($param-values,",")
    let $null := map:put($run-data-map,$param-name,$param-value)
    return
    local:process-run-data-map($new-map,$run-data-map)
  else
  let $run-data := 
  element run-data{  
    for $key in map:keys($run-data-map)
    order by $key
    return
    (: De-pluralize :)
    element {fn:replace($key,"s$","")} {map:get($run-data-map,$key)}
  }
  return
  local:process($run-data)
};

(: Retrieve run data from constants :)
declare function local:get-run-data-as-map(){
  let $map := map:map()
  return
  (
    for $param-name in util:run-time-data-field-plurals()
    return
    map:put($map,$param-name,util:get-constant($param-name))
    ,$map
  )[last()]
};

(: Carry out the test process for a given configuration :)
declare function local:process($run-data as element(run-data)){
    (: Add the run config as a document - this is used by status.xqy :)
    xdmp:invoke("/app/document-insert.xqy",(xs:QName("uri"),$constants:RUN-CONFIG-DOCUMENT,xs:QName("node"),$run-data)),
    (: Set up the database :)
    xdmp:invoke("/app/database-setup.xqy",(xs:QName("db-name"),$db-name,xs:QName("forest-count"),xs:int($run-data/forest-count))),
    (: Save default values if we don't already have a default values document :)
    util:getDefaultValuesDoc()[0],(: Make sure default values doc exists :) 
    (: Set up the admin level config :) 
    let $config :=     
    (
        admin:save-configuration(admin:group-set-background-io-limit(admin:get-configuration(),xdmp:group(),xs:int($run-data/io-limit))),
        admin:save-configuration(admin:database-set-in-memory-tree-size(admin:get-configuration(),xdmp:database($db-name),xs:int($run-data/tree-size))),
        admin:save-configuration(admin:database-set-merge-min-ratio(admin:get-configuration(),xdmp:database($db-name),xs:int($run-data/merge-ratio)))
    )   
    (: Start timing now :)
    let $run-start-time := xdmp:eval("fn:current-dateTime()")
    return
    (
        (: Start the simulation :)
        xdmp:invoke("/app/write-simulation.xqy",(xs:QName("db-name"),$db-name,xs:QName("run-data"),$run-data)), 
        (: Put this in place to make sure writes complete :)
        xdmp:sleep(5000),
        (: Record Statistics :)
        xdmp:spawn("/app/record-stats.xqy",
        (
            xs:QName("batch-start-time"),$batch-start-time,
            xs:QName("run-start-time"),$run-start-time,
            xs:QName("db-name"),$db-name,
            xs:QName("run-data"),$run-data)
        )
    )
};

local:process-run-data-map(local:get-run-data-as-map(),map:map())