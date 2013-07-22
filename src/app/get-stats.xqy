import module namespace constants = "http://marklogic.com/io-test/constants" at "/app/constants.xqy";
import module namespace util = "http://marklogic.com/io-test/util" at "/app/util.xqy";

import module namespace admin  = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

declare namespace forest = "http://marklogic.com/xdmp/status/forest";

declare variable $batch-start-time as xs:dateTime external;
declare variable $run-start-time as xs:dateTime external;
declare variable $db-name as xs:string external;
declare variable $run-data as element(run-data) external;
declare variable $batch-map as map:map external;

declare function local:to-mb($bytes as xs:long) as xs:int{
  xs:int($bytes div 1024 div 1024)
};

declare function local:database-sum($param as xs:QName,$db-name as xs:string){
  fn:sum(for $forest in xdmp:database-forests(xdmp:database($db-name)) return xdmp:forest-status($forest)/*[fn:node-name() = $param])
};

declare function local:database-max($param as xs:QName,$db-name as xs:string){
  fn:max(for $forest in xdmp:database-forests(xdmp:database($db-name)) return xdmp:forest-status($forest)/*[fn:node-name() = $param])
};

declare function local:database-sum($param as xs:string) as xs:string{
  xs:string(local:to-mb(local:database-sum(xs:QName("forest:"||$param),$db-name)))
};

declare function local:database-max($param as xs:string) as xs:string{
  xs:string(local:database-max(xs:QName("forest:"||$param),$db-name))
};

let $db-disk-size := fn:sum(for $forest in xdmp:database-forests(xdmp:database($db-name)) return fn:sum(xs:int(xdmp:forest-status($forest)/forest:stands/forest:stand/forest:disk-size/text())))
let $db-memory-size := fn:sum(for $forest in xdmp:database-forests(xdmp:database($db-name)) return fn:sum(xs:int(xdmp:forest-status($forest)/forest:stands/forest:stand/forest:memory-size/text())))

let $db-fragment-count := fn:sum(for $forest in xdmp:database-forests(xdmp:database($db-name)) return fn:sum(xs:int(xdmp:forest-counts($forest)/forest:stands-counts/forest:stand-counts/forest:active-fragment-count/text())))
let $duration := fn:current-dateTime() - $run-start-time
let $duration := xs:dayTimeDuration("PT"||xs:string(xs:integer($duration div xs:dayTimeDuration("PT1S") * 100) div 100)||"S")
return
element io-stats{
  element db-name{$db-name},
  element run-label{util:get-run-label($batch-map)},
  element batch-start-time{$batch-start-time},  
  element run-start-time{$run-start-time},
  element elapsed-time{$duration},
  element on-disk-size{$db-disk-size},
  element in-memory-size{$db-memory-size},  
  element fragment-count{$db-fragment-count},
  element stands-written{util:get-stands-written($db-name)},
  element query-read-mb{local:database-sum("query-read-bytes")},
  element save-write-mb{local:database-sum("save-write-bytes")},  
  element journal-write-mb{local:database-sum("journal-write-bytes")},
  element merge-read-mb{local:database-sum("merge-read-bytes")},  
  element merge-write-mb{local:database-sum("merge-write-bytes")},
  for $element in $run-data/*
  return
  $element,
  element expected-fragments{util:toBytes(util:expected-document-count($batch-map))},
  element expected-duration{util:get-duration($batch-map)},
  element expected-footprint{util:toBytes(util:expected-document-volume($batch-map))}  
}



