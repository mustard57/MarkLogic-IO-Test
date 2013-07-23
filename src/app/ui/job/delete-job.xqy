
declare variable $job-id := xdmp:get-request-field("id","NONE");

xdmp:set-response-content-type("text/html"),
element html{
    element head{
        element link{attribute rel{"stylesheet"}, attribute type{"text/css"}, attribute href{"/public/css/io.css"}},
        element title {"Job deleted"}    
    },
    element body{
        element h1{"Job Deletion"},
        if(/job[id = $job-id]) then
        (
            let $count := xdmp:estimate(/job[id = $job-id])
            return
            (
                for $doc in /job[id = $job-id]
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