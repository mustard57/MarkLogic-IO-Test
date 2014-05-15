import module namespace constants = "http://marklogic.com/io-test/constants" at "/app/lib/constants.xqy";

import module namespace util = "http://marklogic.com/io-test/util" at "/app/lib/util.xqy";

(: Make Sure Default values doc gets instantiated at start-up :)
util:getDefaultValuesMap()[0],
xdmp:set-response-content-type("text/html"),
element html{
    element head{
        element title{"MarkLogic IO Testing Home Page"},
        element link{attribute rel{"stylesheet"}, attribute type{"text/css"}, attribute href{"/public/css/io.css"}}    
    },
    element body{
            element h1{"MarkLogic IO Testing Home Page"},
			if(fn:not(xdmp:get-current-roles() = xdmp:role("admin"))) then
			element h1{"You do not have admin privileges, so the testing functions will not work. Expect Errors if you try to use these functions. Browsing Reports is OK. If you want to use this application to perform tests, log in as a user with admin privileges. Don't perform tests on shared environments without thought as tests generate high load."}
			else(),
            element h2{"Jobs"},
            element h4{element a{attribute href{"/app/ui/job/create-job.xqy"},"Create Job"}},  
            element h4{element a{attribute href{"/app/ui/job/create-study.xqy"},"Create Study"}},                               
            element h4{element a{attribute href{"/app/ui/job/list-jobs.xqy"},"Job List"}},                 
            element h2{"Status and Configuration"},            
            element h4{element a{attribute href{"/app/ui/status.xqy"},"Status"}},                        
            element h4{element a{attribute href{"/app/ui/defaults/show-defaults.xqy"},"Show Defaults"}},
            element h4{element a{attribute href{"/app/ui/defaults/create-defaults.xqy"},"Create Defaults"}},
            element h2{"Reports"},
            element h4{element a{attribute href{"/app/ui/report/list-reports.xqy"},"Report List"}},
            element h4{element a{attribute href{"/app/ui/report/report.xqy"},"Current Report"}},			
            element h2{"Export Data"},
            element h4{element a{attribute href{"/app/ui/export/export-statistics.xqy"},"Export Statistics"}},            
            element h4{element a{attribute href{"/app/ui/export/export-content.xqy"},"Export Content"}},            
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