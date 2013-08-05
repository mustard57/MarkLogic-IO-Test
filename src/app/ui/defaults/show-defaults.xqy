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
            attribute style{"height : 80%"},
            let $defaults := util:getDefaultValuesMap()
            return
            if(map:keys($defaults)) then
                for $key in ($constants:RUN-LABEL-FIELD-NAME,util:run-time-data-fields(), $constants:batch-data-fields)
                return
                element h4{
                    util:element-name-to-title($key)||" : "||
                    xs:string(map:get($defaults,$key))
                }
            else
                element h4{"Please refresh if you see this message"}
                
        }, 
        element div{
            attribute style{"clear:both"},
            element div{
                attribute style{"float:left;width : 50% ;"},            
                element p{attribute style{"text-align : center ; width : 100%"}, element a {attribute href{"/app/index.xqy"},"Home"}}                        
            },
            element div{
                attribute style{"float:left;width : 50% ;"},            
                element p{attribute style{"text-align : center ; width : 100%"}, element a {attribute href{"/app/ui/defaults/create-defaults.xqy"},"Modify Defaults"}}                        
            }
            
            
        }
         
    }
}