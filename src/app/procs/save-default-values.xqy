xquery version "1.0-ml"; 

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";
import module namespace constants = "http://marklogic.com/io-test/constants" at "/app/lib/constants.xqy";

declare variable $db-name as xs:string external;

let $map := map:map()

let $null := 
(
    map:put($map,"batch-size",$constants:DEFAULT-BATCH-SIZE),  
    map:put($map,"forest-count",$constants:DEFAULT-FOREST-COUNT),  
    map:put($map,"io-limit",$constants:DEFAULT-BACKGROUND-IO-LIMIT),
    map:put($map,"tree-size",admin:database-get-in-memory-tree-size(admin:get-configuration(),xdmp:database($db-name))),
    map:put($map,"merge-ratio",admin:database-get-merge-min-ratio(admin:get-configuration(),xdmp:database($db-name))),
    map:put($map,"fast-insert-value",$constants:DEFAULT-FAST-INSERT-VALUE),    
    map:put($map,"thread-count",$constants:DEFAULT-THREAD-COUNT),
    map:put($map,"host-count",$constants:HOST-COUNT),
    map:put($map,"host-type",$constants:HOST-TYPE),
    map:put($map,"file-system-format",$constants:FILE-SYSTEM-FORMAT),
    map:put($map,"disk-type",$constants:DISK-TYPE),
    map:put($map,"inserts-per-second",$constants:inserts-per-second),
    map:put($map,"duration",$constants:duration),
    map:put($map,"payload",$constants:payload),
    map:put($map,"run-label",$constants:run-label)     
     
)
return
xdmp:document-insert($constants:DEFAULT-VALUES-DOCUMENT,document{$map})


