import module namespace admin  = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";
import module namespace constants = "http://marklogic.com/io-test/constants" at "/app/constants.xqy";
import module namespace util = "http://marklogic.com/io-test/util" at "/app/util.xqy";

declare namespace forest = "http://marklogic.com/xdmp/status/forest";

declare variable $db-name := $constants:DATA-DB-NAME;


"Queue Size is "||xs:string(util:queue-size()),
"Request count is "||xs:string(util:request-count()),
if(admin:database-exists(admin:get-configuration(),$db-name)) then
	let $db-fragment-count := fn:sum(for $forest in xdmp:database-forests(xdmp:database($db-name)) return fn:sum(xs:int(xdmp:forest-counts($forest)/forest:stands-counts/forest:stand-counts/forest:active-fragment-count/text())))
	return
	"DB Size is "||xs:string($db-fragment-count)||" fragments"
else
	"DB "||$db-name||" is in the process of being created"
,
"Expected db size is "||xs:string($constants:inserts-per-second * $constants:duration)||" fragments",
"",
for $element in fn:doc($constants:RUN-CONFIG-DOCUMENT)/run-data/*
return
util:element-name-to-title($element/fn:node-name())||" : "||xs:string($element),
"",
for $field in util:run-time-data-field-plurals()
return
util:element-name-to-title($field)||" iterated through are "||util:get-constant($field)