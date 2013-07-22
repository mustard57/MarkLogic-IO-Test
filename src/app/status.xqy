import module namespace admin  = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";
import module namespace constants = "http://marklogic.com/io-test/constants" at "/app/constants.xqy";
import module namespace util = "http://marklogic.com/io-test/util" at "/app/util.xqy";

declare namespace forest = "http://marklogic.com/xdmp/status/forest";

declare variable $db-name := $constants:DATA-DB-NAME;
declare variable $batch-data-map := util:get-batch-data-map();
declare variable $run-data-map := util:get-run-data-map();

xdmp:set-response-content-type("text/html"),
element html{
    element head{},
    element body{
    
        "Run Label is "||util:get-run-label($batch-data-map),element br{},
        element br{},
        "Queue Size is "||xs:string(util:queue-size()),element br{},
        "Request count is "||xs:string(util:request-count()),element br{},
        
        if(admin:database-exists(admin:get-configuration(),$db-name)) then
        	let $db-fragment-count := fn:sum(for $forest in xdmp:database-forests(xdmp:database($db-name)) return fn:sum(xs:int(xdmp:forest-counts($forest)/forest:stands-counts/forest:stand-counts/forest:active-fragment-count/text())))
        	return
        	"DB Size is "||xs:string($db-fragment-count)||" fragments"
        else
        	"DB "||$db-name||" is in the process of being created"
        ,
        element br{},
        "Expected db size is "||util:toShorthand(util:expected-document-count($batch-data-map))||" fragments",
        element br{},element br{},
        for $element in fn:doc($constants:RUN-CONFIG-DOCUMENT)/run-data/*
        return
        (util:element-name-to-title($element/fn:node-name())||" : "||xs:string($element),element br{}), 
        element br{},
        for $field in util:run-time-data-field-plurals()
        return
        (util:element-name-to-title($field)||" iterated through are "||map:get($run-data-map,util:de-pluralize($field)),element br{}),
        element br{},
        element a {attribute href{"/app/index.xqy"},"Home"}
        
    }
}