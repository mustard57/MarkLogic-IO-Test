import module namespace admin  = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";
import module namespace constants = "http://marklogic.com/io-test/constants" at "/app/lib/constants.xqy";
import module namespace util = "http://marklogic.com/io-test/util" at "/app/lib/util.xqy";


xdmp:set-response-content-type("text/html"),
element html{
    element head{
        element link{attribute rel{"stylesheet"}, attribute type{"text/css"}, attribute href{"/public/css/io.css"}},
        element title{"IO Test System Default Configuration Values"}
    },
    element body{
        element h1{"IO Test System Default Configuration Values"},
        element div{
            attribute style{"height : 60%"},
            let $defaults := util:getDefaultValuesDoc()
            return
            if($defaults) then
                for $element in $defaults/default-values/*
                return
                element h4{
                    util:element-name-to-title($element/fn:node-name())||" : "||
                    xs:string($element)
                }
            else
                element h4{"Please refresh if you see this message"}
                
        }, 
        element div{
            attribute style{"clear:both"},
            element div{
                attribute style{"float:left;width : 33%"},            
                element p{element a {attribute href{"/app/index.xqy"},"Home"}}
            }
        }
         
    }
}