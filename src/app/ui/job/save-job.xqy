import module namespace util = "http://marklogic.com/io-test/util" at "/app/lib/util.xqy";
import module namespace constants = "http://marklogic.com/io-test/constants" at "/app/lib/constants.xqy";


let $job-id  := xdmp:eval("fn:max((xs:int(/job/job-id) + 1,1))") 
let $doc := element job{
    element job-id{$job-id},
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
xdmp:set-response-content-type("text/html"),

element html{
    element head{
        element link{attribute rel{"stylesheet"}, attribute type{"text/css"}, attribute href{"/public/css/io.css"}},
        element title{"Job Saved"}
    },
    element body{
        element h1{"Job Saved"},
        element br{},
        element div{
            attribute style{"clear:both ;"},
            element div{
                attribute style{"float:left;width : 50% ;"},            
                element p{attribute style{"text-align : center ; width : 100%"}, element a{attribute href{"/app/ui/job/list-jobs.xqy"},"Job List"}}            
            },
            element div{
                attribute style{"float:left;width : 50%"},            
                element p{attribute style{"text-align : center ; width : 100%"}, element a{attribute href{"/app/index.xqy"},"Home"}}            
            }                        
        }
    }
}
)
    