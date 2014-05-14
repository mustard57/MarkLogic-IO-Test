import module namespace util = "http://marklogic.com/io-test/util" at "/app/lib/util.xqy";
import module namespace constants = "http://marklogic.com/io-test/constants" at "/app/lib/constants.xqy";

let $job-id  := 1 + fn:max((util:get-job-ids(),0))
let $map := map:map()
let $null := 
(
    map:put($map,$constants:JOB-ID-FIELD-NAME,$job-id), 
    for $field in util:run-time-data-fields()
    return
    map:put($map,$field,xdmp:get-request-field($field,xs:string(util:getDefaultValue($field)))),    
    for $field in ($constants:batch-data-fields,$constants:RUN-LABEL-FIELD-NAME)        
    return
    map:put($map,$field,xdmp:get-request-field($field,xs:string(util:getDefaultValue($field))))
)
let $null := 
for $field-name in $constants:read-only-fields
return
map:put($map,$field-name,xs:string(util:getDefaultValue($field-name)))

let $uri := "/job/"||xdmp:md5(xdmp:quote($map))||".xml"
let $checks := util:check-values($map)
let $ok as xs:boolean := fn:not(map:keys($checks))
let $null := if($ok) then xdmp:document-insert($uri,document{$map}) else()
return
(
xdmp:set-response-content-type("text/html"),

element html{
    element head{
        element link{attribute rel{"stylesheet"}, attribute type{"text/css"}, attribute href{"/public/css/io.css"}},
        element title{"Job Saved"},
        element script{attribute src{"/public/js/jquery-1.9.0.js"}," "},
        element script{
            attribute type{"text/javascript"},
            'var timer;

             timer_func = function() {
                location.replace("'||(if($ok) then "/app/ui/job/list-jobs.xqy" else "/app/ui/job/create-job.xqy")||'");
             };

             timer = setTimeout(timer_func,3000);'
         }
        
    },
    element body{
        if($ok) then
            element h1{"Job Saved"}
        else
        (
            element h1{"Job Not Saved"},
            element br{},
            element h2{"You have the following errors"},
            element br{},
            for $key in map:keys($checks)
            return
            element h4{map:get($checks,$key)}                    
        )
        ,

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
    