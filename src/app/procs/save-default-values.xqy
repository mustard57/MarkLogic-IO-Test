xquery version "1.0-ml"; 

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";
import module namespace constants = "http://marklogic.com/io-test/constants" at "/app/lib/constants.xqy";

declare variable $db-name as xs:string external;

xdmp:document-insert($constants:DEFAULT-VALUES-DOCUMENT,
element default-values{
    element batch-size{$constants:DEFAULT-BATCH-SIZE},	
    element forest-count{$constants:DEFAULT-FOREST-COUNT},	
	element io-limit{$constants:DEFAULT-BACKGROUND-IO-LIMIT},
	element tree-size{admin:database-get-in-memory-tree-size(admin:get-configuration(),xdmp:database($db-name))},
	element merge-ratio{admin:database-get-merge-min-ratio(admin:get-configuration(),xdmp:database($db-name))},
	element fast-insert-value{$constants:DEFAULT-FAST-INSERT-VALUE},
	
	element thread-count{$constants:DEFAULT-THREAD-COUNT},
	element host-count{$constants:HOST-COUNT},
	element host-type{$constants:HOST-TYPE},
	element file-system-format{$constants:FILE-SYSTEM-FORMAT},
	element disk-type{$constants:DISK-TYPE}	
})


