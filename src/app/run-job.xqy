import module namespace util = "http://marklogic.com/io-test/util" at "/app/util.xqy";
import module namespace constants = "http://marklogic.com/io-test/constants" at "/app/constants.xqy";

declare variable $run-data-map := map:map();
declare variable $batch-data-map := map:map();

declare variable $job-id := xdmp:get-request-field("id",xs:string(fn:min(xs:int(/job/id))));

declare variable $job-doc := fn:doc(fn:base-uri((/job[id = $job-id])[1]));

declare function local:get-field-from-job($job-doc,$field-name){
    xs:string($job-doc/job/*[fn:node-name() = xs:QName($field-name)])
};

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
,

(: Need to set server field here, before spawning :)
xdmp:set-server-field($constants:RUN-DATA-MAP-SERVER-VARIABLE,$run-data-map)[0],
xdmp:set-server-field($constants:BATCH-DATA-MAP-SERVER-VARIABLE,$batch-data-map)[0],

xdmp:set-response-content-type("text-html"),
element html{
    element head{},
    element body{
        if($job-doc) then
        (
            if(util:queue-size() = 0) then
            (
                element h2{"Spawn run ..."},
                xdmp:spawn("/app/run.xqy",(xs:QName("input-map"),$run-data-map,xs:QName("batch-data-map"),$batch-data-map)),  
                element p{"Your run has been spawned"},
                element table{
                
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
            element p{"Your run could not be spawned as not all previous jobs have completed"}                
        )
        else
            element p{"No job found with id "||$job-id}
        ,            
        element p{element a{attribute href{"/app/job-list.xqy"},"Job List"}},        
        element p{element a{attribute href{"/app/config.xqy"},"Current Configuration"}},
        element p{element a{attribute href{"/app/status.xqy"},"Status"}},            
        element p{element a{attribute href{"/app/index.xqy"},"Home"}}        
    }
}

