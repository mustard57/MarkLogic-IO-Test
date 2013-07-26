import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";
import module namespace constants = "http://marklogic.com/io-test/constants" at "/app/lib/constants.xqy";
import module namespace util = "http://marklogic.com/io-test/util" at "/app/lib/util.xqy";

xdmp:set-response-content-type("text/html"),
element html{
    element head{
        element title{"Report List"},    
        element link{attribute rel{"stylesheet"}, attribute type{"text/css"}, attribute href{"/public/css/io.css"}}    
    },
    element body{
        element h1{"Report List"},
        element br{},
        element div{
            attribute style{"margin : 0 auto; width 100%; height 60%;"},
            element table{            
                attribute class{"newspaper-a"},
                attribute style {"margin:  0 auto ; "},
                element tr{
                    element th{"Run Label"},
                    element th{"Batch Start Time"},
                    element th{"Iterations"}
                },                
                for $run-label in fn:distinct-values(/io-stats/run-label/text())
                let $batch-start := fn:min(xs:dateTime(/io-stats[run-label = $run-label]/batch-start-time))
                let $count := fn:count(/io-stats[run-label = $run-label])
                order by $batch-start ascending
                return
                element tr{
                    element td{

                        element a{
                            attribute href{"/app/ui/report/report.xqy?run-label="||$run-label},
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
            }
        },
        element div{
            attribute style{"margin-top : 10%"},
           element div{
                attribute style{"float:left;width : 33%"},            
                element p{attribute style{"text-align : center ; width : 100%"}, element a{attribute href{"/app/ui/report/remove-all-reports.xqy"},"Remove All Reports"}}            
            },             
            element div{
                attribute style{"float:left;width : 33%"},            
                element p{attribute style{"text-align : center ; width : 100%"}, element a{attribute href{"/app/index.xqy"},"Home"}}            
            },
            element div{
                attribute style{"float:left;width : 33%"},            
                element p{attribute style{"text-align : center ; width : 100%"}, element a{attribute href{"/app/ui/status.xqy"},"Status"}}            
            }
                                    
        }               
    }
}