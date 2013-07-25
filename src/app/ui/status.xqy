import module namespace admin  = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";
import module namespace constants = "http://marklogic.com/io-test/constants" at "/app/lib/constants.xqy";
import module namespace util = "http://marklogic.com/io-test/util" at "/app/lib/util.xqy";

declare namespace forest = "http://marklogic.com/xdmp/status/forest";

declare variable $db-name := $constants:DATA-DB-NAME;
declare variable $batch-data-map := util:get-batch-data-map();
declare variable $run-data-map := util:get-run-data-map();

xdmp:set-response-content-type("text/html"),
element html{
    element head{
        element link{attribute rel{"stylesheet"}, attribute type{"text/css"}, attribute href{"/public/css/io.css"}},
        element title{"MarkLogic IO Test System Status"}    
    },
    element body{
        element h1{"MarkLogic IO Test System Status"},
        element h4{"Run Label : "||util:get-run-label($batch-data-map)},        
        element div{
            element div{
            attribute style{"height : 60%; float:left;width : 33%"},            

                element h2{"Queue and Fragment Statistics"},
                element h4{"Queue Size : "||xs:string(util:queue-size())},
                element h4{"Request count : "||xs:string(util:request-count())},
                
                if(admin:database-exists(admin:get-configuration(),$db-name)) then
                	let $db-fragment-count := fn:sum(for $forest in xdmp:database-forests(xdmp:database($db-name)) return fn:sum(xs:int(xdmp:forest-counts($forest)/forest:stands-counts/forest:stand-counts/forest:active-fragment-count/text())))
                	return
                	element h4{"DB Size : "||xs:string($db-fragment-count)||" fragments"}
                else
                	element h4{"DB "||$db-name||" : in the process of being created"}
                ,
                element h4{"Expected db size : "||util:toShorthand(util:expected-document-count($batch-data-map))||" fragments"}
            },
            element div{
                attribute style{"float:left;width : 33%"},            
                element h2{"Current Iteration Configuration"},
                for $element in fn:doc($constants:RUN-CONFIG-DOCUMENT)/run-data/*
                return
                element h4{util:element-name-to-title($element/fn:node-name())||" : "||xs:string($element)}
            },
            element div{
                attribute style{"float:left;width : 33%"},            
                element h2{"Batch Configuration"},
                let $dont-show := fn:tokenize($constants:dont-show-in-jobs-table,",")
                return
                (                
                    for $field in util:run-time-data-field-plurals()
                    where fn:not($field = $dont-show)                
                    return
                    element h4{
                        util:element-name-to-title($field)||" iterated through are "||map:get($batch-data-map,util:de-pluralize($field))
                    }
                    ,                
                    for $field in util:run-time-data-field-plurals()
                    where $field = $dont-show                
                    return
                    element h4{
                        util:element-name-to-title(util:de-pluralize($field))||" : "||map:get($batch-data-map,util:de-pluralize($field))
                    }
                )    
            }
        }
        ,
        element div{
            attribute style{"clear:both ; margin-top : 10%"},
            element div{
                attribute style{"float:left;width : 33%"},            
                element p{attribute style{"text-align : center ; width : 100%"}, element a{attribute href{"/app/ui/job/list-jobs.xqy"},"Job List"}}            
            },                                    
            element div{
                attribute style{"float:left;width : 33%"},            
                element p{attribute style{"text-align : center ; width : 100%"}, element a {attribute href{"/app/ui/report/list-reports.xqy"},"Report List"}}
            },                       
            element div{
                attribute style{"float:left;width : 33%"},            
                element p{attribute style{"text-align : center ; width : 100%"}, element a{attribute href{"/app/index.xqy"},"Home"}}            
            }
 
        }               
    }
}