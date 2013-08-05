import module namespace util = "http://marklogic.com/io-test/util" at "/app/lib/util.xqy";
import module namespace constants = "http://marklogic.com/io-test/constants" at "/app/lib/constants.xqy";

declare variable $all-fields-map as map:map := map:map();
declare variable $defaults-map := map:map();
declare variable $values-map := map:map();

for $field-name in xdmp:get-request-field-names()
return
(
    if(fn:ends-with($field-name,"-values")) then
        let $modified-field-name := fn:replace($field-name,"-values","")
        return
        map:put($values-map,$modified-field-name,xdmp:get-request-field($field-name))
    else if(fn:ends-with($field-name,"-default")) then
        let $modified-field-name := fn:replace($field-name,"-default","")
        return
        map:put($defaults-map,$modified-field-name,xdmp:get-request-field($field-name))
    else()        
)
,
for $field-name in $constants:read-only-fields
return
map:put($defaults-map,$field-name,xs:string(util:getDefaultValue($field-name)))
,

let $checks := util:check-values(util:harmonize-maps($values-map,$defaults-map))
let $ok as xs:boolean := fn:not(map:keys($checks))
let $current-job-id  := xdmp:eval("fn:max((xs:int(/job/job-id),1))")
let $job-maps := util:create-job-maps(util:harmonize-maps($values-map,$defaults-map),$defaults-map)
let $null := xdmp:log("OK  = "||xs:string($ok))
let $null := xdmp:log("Job count : "||fn:count($job-maps))
let $null := if($ok) then 
                for $job-map at $count in $job-maps
                let $job-map := $job-maps[$count]
                let $null := map:put($job-map,$constants:JOB-ID-FIELD-NAME,$current-job-id + $count)
                let $null := map:put($job-map,$constants:RUN-LABEL-FIELD-NAME,map:get($defaults-map,$constants:RUN-LABEL-FIELD-NAME)||"-"||map:get($job-map,$constants:PERMUTED-PREFIX))
                let $null := map:delete($job-map,$constants:PERMUTED-PREFIX)
                let $uri := "/job/"||xdmp:md5(xdmp:quote($job-map))||".xml"
                return
                xdmp:document-insert($uri,document{$job-map}) 
            else()
return
(
xdmp:set-response-content-type("text/html"),
element html{
    element head{
        element link{attribute rel{"stylesheet"}, attribute type{"text/css"}, attribute href{"/public/css/io.css"}},
        element title{"Study Saved"},
        element script{attribute src{"/public/js/jquery-1.9.0.js"}," "},
        element script{
            attribute type{"text/javascript"},
            'var timer;

             timer_func = function() {
                location.replace("'||(if($ok) then "/app/ui/job/list-jobs.xqy" else "/app/ui/job/create-study.xqy")||'");
             };

             timer = setTimeout(timer_func,3000);'
         }
        
    },
    element body{
        if($ok) then
            element h1{"Study Saved"}
        else
        (
            element h1{" Not Saved"},
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
    