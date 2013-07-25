import module namespace constants = "http://marklogic.com/io-test/constants" at "/app/lib/constants.xqy";

import module namespace util = "http://marklogic.com/io-test/util" at "/app/lib/util.xqy";

(: Make Sure Default values doc gets instantiated at start-up :)
util:getDefaultValuesDoc()[0],
xdmp:set-response-content-type("text/html"),
element html{
    element head{
        element title{"MarkLogic IO Testing Home Page"},
        element link{attribute rel{"stylesheet"}, attribute type{"text/css"}, attribute href{"/public/css/io.css"}}    
    },
    element body{
            element h1{"MarkLogic IO Testing Home Page"},
            element h2{"Execution"},            
            element h4{element a{attribute href{"/app/ui/job/run-job.xqy"},"Spawn running process using defaults"}},
            element h4{element a{attribute href{"/app/run-form.xqy"},"Configure then run"}},     
            element h2{"Reports"},
            element h4{element a{attribute href{"/app/ui/report/list-reports.xqy"},"Report List"}},
            element h4{element a{attribute href{"/app/ui/report/report.xqy"},"Current Report"}},
            element h2{"Jobs"},
            element h4{element a{attribute href{"/app/ui/job/create-job.xqy"},"Create Job"}},                   
            element h4{element a{attribute href{"/app/ui/job/list-jobs.xqy"},"Job List"}},                 
            element h2{"Status and Configuration"},            
            element h4{element a{attribute href{"/app/ui/run-config.xqy"},"Run Configuration"}},
            element h4{element a{attribute href{"/app/ui/status.xqy"},"Status"}},            
            
            element h4{element a{attribute href{"/app/ui/show-defaults.xqy"},"Show Defaults"}},
 
            if(util:isTaskScheduled()) then 
            element h4{
                element a{
                    attribute href{"/app/procs/activate-job-queue-processing.xqy?"||$constants:MODE-FIELD-NAME||"="||$constants:DELETE-MODE},
                    "Scheduled Processing in Operation - click to stop"
                }
            }
            else
            element h4{
                element a{
                    attribute href{"/app/procs/activate-job-queue-processing.xqy?"||$constants:MODE-FIELD-NAME||"="||$constants:CREATE-MODE},
                    "Click to enable scheduled processing"
                }
            }                                               
    }
}