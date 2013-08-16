import module namespace util  = "http://marklogic.com/io-test/util" at "/app/lib/util.xqy";
import module namespace constants = "http://marklogic.com/io-test/constants" at "/app/lib/constants.xqy";


declare variable $directory := util:append-slash-to-directory(xdmp:get-request-field($constants:DIRECTORY-FIELD-NAME,()));
declare variable $file-name := xdmp:get-request-field($constants:FILENAME-FIELD-NAME,"io-stats");
declare variable $messages-map := map:map();

let $MESSAGES-KEY := "messages"
let $STATUS-KEY := "ok"
let $ZIP-FILE-KEY := "zipfile"

let $null := map:put($messages-map,$MESSAGES-KEY,())
let $null := map:put($messages-map,$STATUS-KEY,fn:true())
let $null := 
if(fn:empty($directory) or $directory = "") then
(
    map:put($messages-map,$MESSAGES-KEY,(map:get($messages-map,$MESSAGES-KEY),"You must supply a directory")),
    map:put($messages-map,$STATUS-KEY,fn:false())
)
else()
let $null := 
try
{
    let $null := xdmp:filesystem-directory($directory)
    return
    ()
}
catch($exception){
    map:put($messages-map,$MESSAGES-KEY,(map:get($messages-map,$MESSAGES-KEY),"Directory "||$directory||" does not exist")),
    map:put($messages-map,$STATUS-KEY,fn:false())
}
let $null := 
if(map:get($messages-map,$STATUS-KEY)) then

    for $uri in xdmp:eval("cts:uris()",(),$constants:CONTENT-DB-EVAL-OPTIONS)
    return
    xdmp:spawn("/app/procs/save-document.xqy",(xs:QName("uri"),$uri,xs:QName("directory"),$directory),$constants:CONTENT-DB-EVAL-OPTIONS)
else()        
     
return
(     
xdmp:set-response-content-type("text/html"),

element html{
    element head{
        element link{attribute rel{"stylesheet"}, attribute type{"text/css"}, attribute href{"/public/css/io.css"}},
        element title{"Content Exported"},
        element script{attribute src{"/public/js/jquery-1.9.0.js"}," "},
        element script{
            attribute type{"text/javascript"},
            'var timer;

             timer_func = function() {
                location.replace("'||(if(map:get($messages-map,$STATUS-KEY)) then "/app/index.xqy" else "/app/ui/export/export-content.xqy")||'");
             };

             timer = setTimeout(timer_func,3000);'
         }
        
    },
    element body{
        if(map:get($messages-map,$STATUS-KEY)) then
            element h1{"Content exported to "||$directory}
        else
        (
            element h1{"Content not exported"},
            element br{},
            element h2{"You have the following errors"},
            for $message in map:get($messages-map,$MESSAGES-KEY)
            return
            element h4{$message},
            element br{}
        )
        ,

        element br{},
        element div{
            attribute style{"clear:both ;"},
            element div{
                attribute style{"float:left;width : 100% ;"},            
                element p{attribute style{"text-align : center ; width : 100%"}, element a{attribute href{"/app/index.xqy"},"Home"}}            
            }
        }
    }
}
)
         