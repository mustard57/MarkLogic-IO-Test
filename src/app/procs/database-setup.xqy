import module namespace admin  = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";
import module namespace util = "http://marklogic.com/io-test/util" at "/app/lib/util.xqy";

declare variable $db-name as xs:string external;
declare variable $forest-count as xs:int external;

if((util:request-count() + util:queue-size()) <= 1) then
(
	xdmp:invoke("/app/procs/remove-database.xqy",(xs:QName("db-name"),$db-name))
	,
	xdmp:sleep(5000),	
	xdmp:invoke("/app/procs/create-database.xqy",(xs:QName("db-name"),$db-name,xs:QName("forest-count"),$forest-count)),
	xdmp:sleep(5000)
)
else
(
	xdmp:sleep(10000),
	xdmp:invoke("/app/procs/database-setup.xqy",(xs:QName("db-name"),$db-name,xs:QName("forest-count"),$forest-count))
)
