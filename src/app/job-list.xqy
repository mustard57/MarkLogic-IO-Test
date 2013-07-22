import module namespace util = "http://marklogic.com/io-test/util" at "/app/util.xqy";
import module namespace constants = "http://marklogic.com/io-test/constants" at "/app/constants.xqy";


xdmp:set-response-content-type("text/html"),

element html{
    element head{},
    element body{
        element table{
           element tr{
                let $field := "run-label"        
                return
                element th {util:element-name-to-title($field)}
                ,
                for $field in util:run-time-data-fields()
                return
                element th {util:element-name-to-title($field)} 
                ,
                for $field in fn:tokenize("inserts-per-second,duration,payload",",")        
                return
                element th {util:element-name-to-title($field)}
            },

            for $job in /job
            order by xs:int($job/id) ascending
            return
            element tr{
                let $field := "run-label"        
                return
                element td {$job/*[fn:node-name() = xs:QName($field)]}
                ,
                for $field in util:run-time-data-fields()
                return
                element td {$job/*[fn:node-name() = xs:QName($field)]}
                ,
                for $field in fn:tokenize("inserts-per-second,duration,payload",",")        
                return
                element td {$job/*[fn:node-name() = xs:QName($field)]}
                ,
                element td{element a{attribute href{"/app/delete-job.xqy?id="||$job/id},"Delete Job"}},
                element td{element a{attribute href{"/app/run-job.xqy?id="||$job/id},"Run Job"}}
            }
        },
        element p{element a{attribute href{"/app/config.xqy"},"Current Configuration"}},
        element p{element a{attribute href{"/app/status.xqy"},"Status"}},            
        element p{element a{attribute href{"/app/index.xqy"},"Home"}}        
        
    }
}

