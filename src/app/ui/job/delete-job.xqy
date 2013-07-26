import module namespace constants = "http://marklogic.com/io-test/constants" at "/app/lib/constants.xqy";

declare variable $job-id := xdmp:get-request-field($constants:JOB-ID-FIELD-NAME,"NONE");

xdmp:set-response-content-type("text/html"),
element html{
    element head{
        element link{attribute rel{"stylesheet"}, attribute type{"text/css"}, attribute href{"/public/css/io.css"}},
        element title {"Job deleted"},
        
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
        element h1{"Job Deletion"},
        if(/job[job-id = $job-id]) then
        (
            let $count := xdmp:estimate(/job[job-id = $job-id])
            return
            (
                for $doc in /job[job-id = $job-id]
                return
                xdmp:document-delete(fn:base-uri($doc)), 
                
                element p{attribute style{"text-align : center ; width : 100%"},"Job "||$job-id||" deleted"}
            )
        )
        else
        element p{attribute style{"text-align : center ; width : 100%"}, "No jobs with id = "||$job-id||" found"},
        element div{        
            attribute style{"clear:both ; margin-top : 10%"},
            element div{
                attribute style{"float:left;width : 50%"},            
                element p{attribute style{"text-align : center ; width : 100%"}, element a{attribute href{"/app/ui/job/list-jobs.xqy"},"Job List"}}            
            },
            element div{
                attribute style{"float:left;width : 50%"},            
                element p{attribute style{"text-align : center ; width : 100%"}, element a {attribute href{"/app/index.xqy"},"Home"}}
            }
            
            
        }
                
    }
}