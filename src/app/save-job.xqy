import module namespace util = "http://marklogic.com/io-test/util" at "/app/util.xqy";
import module namespace constants = "http://marklogic.com/io-test/constants" at "/app/constants.xqy";


let $job-id  := xdmp:eval("fn:max((xs:int(/job/id) + 1,1))") 
let $doc := element job{
    element id{$job-id},
    for $field in util:run-time-data-fields()
    return
    element {$field} {xdmp:get-request-field($field,util:getDefaultValue($field))},
    
    for $field in fn:tokenize("inserts-per-second,duration,payload,run-label",",")        
    return
    element {$field} {xdmp:get-request-field($field,util:getDefaultValue($field))}
}
let $uri := "/job/"||xdmp:md5(xdmp:quote($doc))||".xml"
let $null := xdmp:document-insert($uri,$doc)
return
(
xdmp:set-response-content-type("text/html"),"Job inserted",
        element p{element a{attribute href{"/app/job-list.xqy"},"Job List"}},        
        element p{element a{attribute href{"/app/index.xqy"},"Home"}}        

)
    