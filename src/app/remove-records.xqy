import module namespace constants = "http://marklogic.com/io-test/constants" at "/app/constants.xqy";

declare variable $run-label as xs:string external ;

for $doc in fn:doc()[/io-stats/run-label/text() = $run-label]
return
xdmp:document-delete(fn:base-uri($doc)),
"Removed records with run label "||$run-label
