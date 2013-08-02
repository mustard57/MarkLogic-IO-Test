import module namespace admin  = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";
import module namespace constants = "http://marklogic.com/io-test/constants" at "/app/lib/constants.xqy";
import module namespace util = "http://marklogic.com/io-test/util" at "/app/lib/util.xqy";

declare variable $db-name := $constants:DATA-DB-NAME;
declare variable $batch-start-time := fn:current-dateTime();

declare variable $input-map external;
declare variable $batch-data-map external;

(: Create the appropriate for loops from the run data :)
declare function local:process-run-data-map($batch-map as map:map,$param-lists-map as map:map,$run-data-map as map:map){
  if(map:keys($param-lists-map)) then
    let $param-name := (for $key in map:keys($param-lists-map) order by $key return $key)[1]
    let $param-values := map:get($param-lists-map,$param-name)
    let $new-map := map:map()
    let $null := for $key in map:keys($param-lists-map) return if($key != $param-name) then map:put($new-map,$key,map:get($param-lists-map,$key)) else()
    return
    for $param-value in fn:tokenize($param-values,",")
    let $null := map:put($run-data-map,$param-name,$param-value)
    return
    local:process-run-data-map($batch-map,$new-map,$run-data-map)
  else
  let $singleton-run-data-map := map:map()
  let $null := for $key in map:keys($run-data-map) return map:put($singleton-run-data-map,fn:replace($key,"s$",""),map:get($run-data-map,$key))
  let $null := util:sort-types($singleton-run-data-map)  
  return
  local:process($batch-map,$singleton-run-data-map)
};

(: Retrieve run data from constants :)
declare function local:get-run-data-as-map(){
  let $map := map:map()
  return
  (
    for $param-name in util:run-time-data-field-plurals()
    return
    map:put($map,$param-name,util:get-constant($param-name)),
    for $field in $constants:batch-data-fields
    return
    map:put($map,$field,util:get-constant($field))        
    ,$map
  )[last()]
};

(: Carry out the test process for a given configuration :)
declare function local:process($batch-map as map:map,$run-data-map as map:map){
    (: Add the run config as a document - this is used by status.xqy :)
    xdmp:invoke("/app/procs/document-insert.xqy",(xs:QName("uri"),$constants:RUN-CONFIG-DOCUMENT,xs:QName("node"),document{$run-data-map})),
    (: Set up the database :)
    xdmp:invoke("/app/procs/database-setup.xqy",(xs:QName("db-name"),$db-name,xs:QName("forest-count"),map:get($run-data-map,$constants:FOREST-COUNT-FIELD-NAME))),
    (: Save default values if we don't already have a default values document :)
    util:getDefaultValuesMap()[0],(: Make sure default values doc exists :) 
    (: Set up the admin level config :) 
    let $config :=     
    (
        admin:save-configuration(
            admin:group-set-background-io-limit(
                admin:get-configuration(),xdmp:group(),map:get($run-data-map,$constants:FOREST-COUNT-FIELD-NAME))),
        admin:save-configuration(
            admin:database-set-in-memory-tree-size(
                admin:get-configuration(),xdmp:database($db-name),map:get($run-data-map,$constants:TREE-SIZE-FIELD-NAME))),
        admin:save-configuration(
            admin:database-set-merge-min-ratio(
                admin:get-configuration(),xdmp:database($db-name),map:get($run-data-map,$constants:MERGE-RATIO-FIELD-NAME)))
    )   
    (: Start timing now :)
    let $run-start-time := xdmp:eval("fn:current-dateTime()")
    return
    (
        (: Start the simulation :)
        xdmp:invoke("/app/procs/write-simulation.xqy",(xs:QName("db-name"),$db-name,xs:QName("batch-map"),$batch-map,xs:QName("run-data-map"),$run-data-map)), 
        (: Put this in place to make sure writes complete :)
        xdmp:sleep(5000),
        (: Record Statistics :)
        xdmp:spawn("/app/procs/record-stats.xqy",
        (
            xs:QName("batch-start-time"),$batch-start-time,
            xs:QName("run-start-time"),$run-start-time,
            xs:QName("db-name"),$db-name,
            xs:QName("run-data-map"),$run-data-map,
            xs:QName("batch-map"),$batch-map)
        )
    )
};

if(util:restart-required($input-map)) then
(
    xdmp:log("Run configuration required server restart","info"),
    admin:save-configuration-without-restart(
        admin:taskserver-set-threads(
            admin:get-configuration(),xdmp:group(),xs:int(map:get($input-map,$constants:THREAD-COUNT-FIELD-NAME)))),
    xdmp:restart(xdmp:hosts(),"IO Testing Run Configuration required restart") 
)
else 
util:delete-job(map:get($batch-data-map,$constants:JOB-ID-FIELD-NAME)),

let $map1 := if(map:keys($input-map)) then $input-map else local:get-run-data-as-map()
let $map2 := if(map:keys($batch-data-map)) then $batch-data-map else util:getDefaultBatchDataFieldsAsMap()
let $null := util:set-batch-data-map($map1 + $map2)
let $null := if(util:restart-required($input-map)) then () else util:delete-job(map:get($batch-data-map,$constants:JOB-ID-FIELD-NAME))
return
local:process-run-data-map($map2,$map1,map:map())

