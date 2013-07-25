import module namespace util = "http://marklogic.com/io-test/util" at "/app/lib/util.xqy";
import module namespace constants = "http://marklogic.com/io-test/constants" at "/app/lib/constants.xqy";

declare variable $run-data-map := map:map();
declare variable $batch-data-map := map:map();

(: Get Job ID :)
(: If called with no arguments at all, assume job-id = 0 - a special case whihc will run the job with the lowest id :)
declare variable $job-id := if(xdmp:get-request-field-names()) then xdmp:get-request-field($constants:JOB-ID-FIELD-NAME) else "0";

declare function local:get-field-from-job($job-doc,$field-name){
    xs:string($job-doc/job/*[fn:node-name() = xs:QName($field-name)])
};

(: So if we have a job-id, run a job :)
if(fn:not(fn:empty($job-id))) then
(
    let $job-id := if($job-id != "0") then xs:int($job-id) else fn:min(xs:int(/job/job-id))
    let $job-doc := fn:doc(fn:base-uri((/job[job-id = $job-id])[1]))
    let $null := map:put($batch-data-map,$constants:JOB-ID-FIELD-NAME,$job-id) 
    return
    (
        for $field in util:run-time-data-fields()
        return
            map:put($run-data-map,$field,local:get-field-from-job($job-doc,$field))    
        ,
        for $field in fn:tokenize("inserts-per-second,duration,payload,run-label",",")
        return
        if($field != "run-label") then
            map:put($batch-data-map,$field,xs:int(local:get-field-from-job($job-doc,$field)))
        else
            map:put($batch-data-map,$field,local:get-field-from-job($job-doc,$field))
    )
)
else
(
    for $field in util:run-time-data-fields()
    return
    map:put($run-data-map,$field,xdmp:get-request-field($field,util:getDefaultValue($field)))
    ,
    for $field in fn:tokenize("inserts-per-second,duration,payload,run-label",",")
    return
    if($field != "run-label") then
        map:put($batch-data-map,$field,xs:int(xdmp:get-request-field($field,util:get-constant($field))))
    else
        map:put($batch-data-map,$field,xdmp:get-request-field($field,util:get-constant($field)))
)
,

(: Need to set server field here, before spawning :)
xdmp:set-server-field($constants:RUN-DATA-MAP-SERVER-VARIABLE,$run-data-map)[0],
util:set-batch-data-map($batch-data-map),

xdmp:set-response-content-type("text/html"),
element html{
    element head{
        element title{"Run Batch"},    
        element link{attribute rel{"stylesheet"}, attribute type{"text/css"}, attribute href{"/public/css/io.css"}}        
    },
    element body{
        if(map:keys($run-data-map)) then
        (
            xdmp:log("Queue Size is "||xs:string(util:queue-size())),
            xdmp:log("Request Count is "||xs:string(util:request-count())),
            xdmp:log("Job ID is "||xs:string($job-id)),
            xdmp:log("Run Label is "||map:get($batch-data-map,"run-label")),            
            if(util:queue-empty() or util:isScheduledTask()) then
            (
                element h1{"Job Running"},
                xdmp:spawn("/app/procs/run.xqy",(xs:QName("input-map"),$run-data-map,xs:QName("batch-data-map"),$batch-data-map)),   
                element h4{"Your job has been spawned"},
                element br{},
                element table{
                    attribute style {"margin:  0 auto ; "},
                    attribute class {"newspaper-a"},
                    element tr{element th{"Parameter"},element th{"Value"}},
                    element tr{element td{"&nbsp;"},element td{"&nbsp;"}}, 
                
                    for $key in map:keys($run-data-map)
                    return
                    element tr{
                        element td{
                            $key
                        },
                        element td{map:get($run-data-map,$key)}
                    },
                    for $key in map:keys($batch-data-map)
                    return
                    element tr{
                        element td{
                            $key
                        },
                        element td{map:get($batch-data-map,$key)}
                    }
                }
            )
            else
            (
                element h1{"Job Not Running"},            
                element h4{"Your run could not be spawned as not all previous jobs have completed"},
                xdmp:log("Your run could not be spawned as not all previous jobs have completed")
            )                
        )
        else
        (
            element h1{"Job Not Running"},        
            element h4{"No job found with id "||$job-id}
        )
        ,
        element br{},
        element div{
            attribute style{"clear:both ;"},
            element div{
                attribute style{"float:left;width : 25% ;"},            
                element p{attribute style{"text-align : center ; width : 100%"}, element a{attribute href{"/app/ui/job/list-jobs.xqy"},"Job List"}}            
            },
            element div{
                attribute style{"float:left;width : 25%"},            
                element p{attribute style{"text-align : center ; width : 100%"}, element a{attribute href{"/app/ui/run-config.xqy"},"Run Configuration"}}
            },
            element div{
                attribute style{"float:left;width : 25%"},            
                element p{attribute style{"text-align : center ; width : 100%"}, element a{attribute href{"/app/ui/status.xqy"},"Status"}}            
            },
            element div{
                attribute style{"float:left;width : 25%"},            
                element p{attribute style{"text-align : center ; width : 100%"}, element a{attribute href{"/app/index.xqy"},"Home"}}            
            }                        
        }
                    
        
    }
}

