import module namespace util = "http://marklogic.com/io-test/util" at "/app/util.xqy";
import module namespace constants = "http://marklogic.com/io-test/constants" at "/app/constants.xqy";

declare variable $run-data-map := map:map();
declare variable $batch-data-map := map:map();


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
,
(: Need to set server field here, before spawning :)
xdmp:set-server-field($constants:RUN-DATA-MAP-SERVER-VARIABLE,$run-data-map)[0],
xdmp:set-server-field($constants:BATCH-DATA-MAP-SERVER-VARIABLE,$batch-data-map)[0],

xdmp:set-response-content-type("text-html"),
element html{
    element head{},
    element body{
        element h2{"Spawn run ..."},
        xdmp:spawn("/app/run.xqy",(xs:QName("input-map"),$run-data-map,xs:QName("batch-data-map"),$batch-data-map)),  
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
            
            
        },
        element p{"Your run has been spawned"},
        element p{element a{attribute href{"/app/config.xqy"},"Current Configuration"}},
        element p{element a{attribute href{"/app/status.xqy"},"Status"}},            
        element p{element a{attribute href{"/app/index.xqy"},"Home"}}        
    }
}

