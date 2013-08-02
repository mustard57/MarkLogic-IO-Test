import module namespace util = "http://marklogic.com/io-test/util" at "/app/lib/util.xqy";
import module namespace constants = "http://marklogic.com/io-test/constants" at "/app/lib/constants.xqy";

let $map := map:map()
let $null := 
(
    for $field in xdmp:get-request-field-names()
    return
    map:put($map,$field,xdmp:get-request-field($field,util:getDefaultValue($field)))
)
let $checks := util:check-values($map)
let $ok as xs:boolean := fn:not(map:keys($checks))
let $map := map:map()
let $null := 
(
    for $field in xdmp:get-request-field-names()
    return
    map:put($map,fn:replace($field,"-default",""),xdmp:get-request-field($field,util:getDefaultValue($field)))
)
let $null := if($ok) then xdmp:document-insert($constants:DEFAULT-VALUES-DOCUMENT,document{$map}) else()
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
                location.replace("'||(if($ok) then "/app/ui/defaults/show-defaults.xqy" else "/app/ui/job/create-defaults.xqy")||'");
             };

             timer = setTimeout(timer_func,3000);'
         }
        
    },
    element body{
        if($ok) then
            element h1{"Defaults Saved"}
        else
        (
            element h1{"Defaults Not Saved"},
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
                element p{attribute style{"text-align : center ; width : 100%"}, element a{attribute href{"/app/ui/defaults/show-defaults.xqy"},"Show Defaults"}}            
            },
            element div{
                attribute style{"float:left;width : 50%"},            
                element p{attribute style{"text-align : center ; width : 100%"}, element a{attribute href{"/app/index.xqy"},"Home"}}            
            }                        
        }
    }
}
)
    