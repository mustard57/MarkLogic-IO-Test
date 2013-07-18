import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";
import module namespace constants = "http://marklogic.com/io-test/constants" at "/app/constants.xqy";
import module namespace util = "http://marklogic.com/io-test/util" at "/app/util.xqy";

xdmp:set-response-content-type("text/html"),
element html{
    element head{},
    element body{
        element table{            
            for $run-label in fn:distinct-values(/io-stats/run-label/text())
            let $batch-start := fn:min(xs:dateTime(/io-stats[run-label = $run-label]/batch-start-time))
            let $count := fn:count(/io-stats[run-label = $run-label])
            order by $batch-start ascending
            return
            element tr{
                element td{
                    element a{
                        attribute href{"/app/report.xqy?run-label="||$run-label},
                        $run-label
                    }                    
                },
                element td{
                    util:date-format($batch-start)
                },
                element td{
                    $count
                }
                
                
            }
        },
        element br{},
        element a {attribute href{"/app/index.xqy"},"Home"}
        
    }
}