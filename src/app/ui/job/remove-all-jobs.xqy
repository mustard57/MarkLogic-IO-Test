import module namespace constants = "http://marklogic.com/io-test/constants" at "/app/lib/constants.xqy";

xdmp:set-response-content-type("text-html"),
element html{
    element head{
        element link{attribute rel{"stylesheet"}, attribute type{"text/css"}, attribute href{"/public/css/io.css"}},
        element title{"Remove All Reports"}   ,
        element script{attribute src{"/public/js/jquery-1.9.0.js"}," "},
        element script{
            attribute type{"text/javascript"},
            'var timer;

             timer_func = function() {
                location.replace("/app/ui/job/list-jobs.xqy");
             };

             timer = setTimeout(timer_func,3000);'
         }
         
    },
    element body{
        element h1{"Full Job Deletion"},
        let $count := xdmp:estimate(xdmp:directory("/job/"))
        return
        (
            for $doc in xdmp:directory("/job/")
            return
            xdmp:document-delete(fn:base-uri($doc))            
            ,
            element p{attribute style{"text-align : center ; width : 100%"},"Removed all jobs ("||$count||")"}
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
