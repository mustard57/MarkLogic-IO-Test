xquery version "1.0-ml"; 

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";
import module namespace constants = "http://marklogic.com/io-test/constants" at "/app/lib/constants.xqy";
import module namespace util = "http://marklogic.com/io-test/util" at "/app/lib/util.xqy";

declare variable $db-name as xs:string external;

let $map := map:map()

let $null := 
(
    map:put($map,$constants:BATCH-SIZE-FIELD-NAME,$constants:DEFAULT-BATCH-SIZE),  
    map:put($map,$constants:FOREST-COUNT-FIELD-NAME,$constants:DEFAULT-FOREST-COUNT),  
    map:put($map,$constants:IO-LIMIT-FIELD-NAME,$constants:DEFAULT-BACKGROUND-IO-LIMIT),
    map:put($map,$constants:TREE-SIZE-FIELD-NAME,admin:database-get-in-memory-tree-size(admin:get-configuration(),xdmp:database($db-name))),
    map:put($map,$constants:MERGE-RATIO-FIELD-NAME,admin:database-get-merge-min-ratio(admin:get-configuration(),xdmp:database($db-name))),
    map:put($map,$constants:FAST-INSERT-VALUE-FIELD-NAME,$constants:DEFAULT-FAST-INSERT-VALUE),    
    map:put($map,$constants:THREAD-COUNT-FIELD-NAME,$constants:DEFAULT-THREAD-COUNT),
    map:put($map,$constants:HOST-COUNT-FIELD-NAME,$constants:HOST-COUNT),
    map:put($map,$constants:HOST-TYPE-FIELD-NAME,$constants:HOST-TYPE),
    map:put($map,$constants:FILE-SYSTEM-FORMAT-FIELD-NAME,$constants:FILE-SYSTEM-FORMAT),
    map:put($map,$constants:DISK-TYPE-FIELD-NAME,$constants:DISK-TYPE),
    map:put($map,$constants:INSERTS-PER-SECOND-FIELD-NAME,$constants:inserts-per-second),
    map:put($map,$constants:DURATION-FIELD-NAME,$constants:duration),
    map:put($map,$constants:PAYLOAD-FIELD-NAME,$constants:payload),
    map:put($map,$constants:RUN-LABEL-FIELD-NAME,$constants:run-label),    
    map:put($map,$constants:FOREST-DIRECTORY-FIELD-NAME,$constants:DEFAULT-FOREST-DIRECTORY),
	map:put($map,$constants:DATA-DIRECTORY-FIELD-NAME,$constants:DEFAULT-DATA-DIRECTORY),
    map:put($map,$constants:RUN-MODE-FIELD-NAME,$constants:DEFAULT-RUN-MODE)    
     
)
let $null := util:sort-types($map)
return
xdmp:document-insert($constants:DEFAULT-VALUES-DOCUMENT,document{$map},
(xdmp:permission($constants:IO-TEST-ROLE,"update"),xdmp:permission($constants:IO-TEST-ROLE,"read"),xdmp:permission($constants:IO-TEST-ROLE,"insert")))



