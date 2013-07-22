xdmp:set-response-content-type("text/html"),
element html{
    element head{},
    element body{
        element ul{
            element li{element a{attribute href{"/app/spawn-run.xqy"},"Spawn running process using defaults"}},
            element li{element a{attribute href{"/app/run-form.xqy"},"Configure then run"}},     
            element li{element a{attribute href{"/app/reports.xqy"},"Reports"}},
            element li{element a{attribute href{"/app/report.xqy"},"Current Report"}},
            element li{element a{attribute href{"/app/config.xqy"},"Current Configuration"}},
            element li{element a{attribute href{"/app/status.xqy"},"Status"}},            
            element li{element a{attribute href{"/app/defaults.xqy"},"Defaults"}},
            element li{element a{attribute href{"/app/job-form.xqy"},"Add job"}},                   
            element li{element a{attribute href{"/app/job-list.xqy"},"Job List"}}                 
                        
        }
    }
}