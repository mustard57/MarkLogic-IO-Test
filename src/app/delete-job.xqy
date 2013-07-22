
declare variable $job-id := xdmp:get-request-field("id","NONE");

xdmp:set-response-content-type("text/html"),
element html{
    element head{},
    element body{
        if(/job[id = $job-id]) then
        (
            for $doc in /job[id = $job-id]
            return
            xdmp:document-delete(fn:base-uri($doc)),
            element p{"Documents Deleted"}
        )
        else
        element p{"No jobs with id = "||$job-id||" found"},
        element p{element a{attribute href{"/app/job-list.xqy"},"Job List"}},        
        element p{element a{attribute href{"/app/index.xqy"},"Home"}}        
        
    }
}