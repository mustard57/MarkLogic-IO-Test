import module namespace constants = "http://marklogic.com/io-test/constants" at "/app/lib/constants.xqy";

declare variable $run-label as xs:string:= xdmp:get-request-field($constants:RUN-LABEL-FIELD-NAME);

xdmp:set-response-content-type("text-html"),
element html{
    element head{
        element link{attribute rel{"stylesheet"}, attribute type{"text/css"}, attribute href{"/public/css/io.css"}},
        element title{"Remove Reports"}    
    },
    element body{
        element h1{"Report Deletion"},
        let $count := xdmp:estimate(/io-stats[run-label = $run-label])
        return
        (
            for $doc in /io-stats[run-label = $run-label]
            return
            xdmp:document-delete(fn:base-uri($doc)) 
            ,
            element p{attribute style{"text-align : center ; width : 100%"},"Removed records ("||$count||") with run label "||$run-label}
        )
        ,
            
        element div{
            attribute style{"margin-top : 10%"},
            element div{
                attribute style{"float:left;width : 50%"},            
                element p{attribute style{"text-align : center ; width : 100%"}, element a{attribute href{"/app/index.xqy"},"Home"}}            
            },
                                                element div{
                attribute style{"float:left;width : 50%"},            
                element p{attribute style{"text-align : center ; width : 100%"}, element a{attribute href{"/app/ui/report/list-reports.xqy"},"List Reports"}}            
            }
                                    
        }               
    }
}
