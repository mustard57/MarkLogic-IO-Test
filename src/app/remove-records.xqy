import module namespace constants = "http://marklogic.com/io-test/constants" at "/app/constants.xqy";

declare variable $run-label as xs:string:= xdmp:get-request-field($constants:RUN-LABEL-FIELD-NAME);

xdmp:set-response-content-type("text-html"),
element html{
    element head{},
    element body{
        element h2{"Document Deletion"},

        for $doc in fn:doc()[/io-stats/run-label/text() = $run-label]
        return
        xdmp:document-delete(fn:base-uri($doc))
        ,
        element p{"Removed records with run label "||$run-label},
        element p{element a{attribute href{"/app/reports.xqy"},"Back To Reports"}}
    }
}
