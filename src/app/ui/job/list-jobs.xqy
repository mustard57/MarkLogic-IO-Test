import module namespace util = "http://marklogic.com/io-test/util" at "/app/lib/util.xqy";
import module namespace constants = "http://marklogic.com/io-test/constants" at "/app/lib/constants.xqy";

xdmp:set-response-content-type("text/html"),

element html{
    element head{
        element link{attribute rel{"stylesheet"}, attribute type{"text/css"}, attribute href{"/public/css/io.css"}},
        element title{"Job List"}
    },
    element body{
        element h1{"Job List"},
        element br{},
        element div{
            attribute style {"height : 60%"},
            element table{
               attribute class{"newspaper-a"},
               element tr{
                    let $field := $constants:RUN-LABEL-FIELD-NAME        
                    return
                    element th {util:element-name-to-title($field)}
                    ,                    
                    for $field in util:run-time-data-fields()
                    where fn:not($field = $constants:environment-fields)
                    return
                    element th {util:element-name-to-title($field)} 
                    ,
                    for $field in $constants:batch-data-fields        
                    return
                    element th {util:element-name-to-title($field)},
                    element th{},
                    element th{}
                },
    
                for $doc in xdmp:directory("/job/")
                let $map as map:map := map:map($doc/*)  
                order by map:get($map,"job-id") ascending
                return
                element tr{
                    if(util:is-job-running($map)) then
                    attribute class{"green"}
                    else
                    ()
                    ,
                    let $field := $constants:RUN-LABEL-FIELD-NAME        
                    return
                    element td{map:get($map,$field)}
                    ,
                    for $field in util:run-time-data-fields()
                    where fn:not($field = $constants:environment-fields)
                    return
                    element td{map:get($map,$field)}
                    ,
                    for $field in $constants:batch-data-fields        
                    return
                    element td{map:get($map,$field)}
                    ,
                    if(util:is-job-running($map)) then
                    (
                        element td{"Job Running"},
                        element td{"&nbsp;"}
                    )
                    else
                    (                    
                        element td{element a{attribute href{"/app/ui/job/delete-job.xqy?job-id="||map:get($map,"job-id")},"Delete Job"}},
                        element td{element a{attribute href{"/app/ui/job/run-job.xqy?job-id="||map:get($map,"job-id")},"Run Job"}}
                    )
                }
            }
        }
        ,
        element div{
            attribute style{"clear:both"},
            element div{
                attribute style{"float:left;width : 16%"},            
                element p{attribute style{"text-align : center ; width : 100%"}, element a{attribute href{"/app/ui/run-config.xqy"},"Run Configuration"}}
            },
            element div{
                attribute style{"float:left;width : 16%"},            
                element p{attribute style{"text-align : center ; width : 100%"}, element a{attribute href{"/app/ui/status.xqy"},"Status"}}            
            },
            element div{
                attribute style{"float:left;width : 16%"},            
                element p{attribute style{"text-align : center ; width : 100%"}, element a {attribute href{"/app/ui/job/create-job.xqy"},"Create Job"}}
            },
            element div{
                attribute style{"float:left;width : 16%"},            
                element p{attribute style{"text-align : center ; width : 100%"}, element a {attribute href{"/app/delete-job.xqy"},"Delete Job"}}
            },           
            element div{
                attribute style{"float:left;width : 16%"},            
                element p{attribute style{"text-align : center ; width : 100%"}, element a {attribute href{"/app/ui/report/list-reports.xqy"},"Report List"}}
            },                       
            element div{
                attribute style{"float:left;width : 16%"},            
                element p{attribute style{"text-align : center ; width : 100%"}, element a {attribute href{"/app/index.xqy"},"Home"}}
            }
            
            
        }
    }
}

