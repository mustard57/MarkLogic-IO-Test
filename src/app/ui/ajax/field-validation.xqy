import module namespace util  = "http://marklogic.com/io-test/util" at "/app/lib/util.xqy"; 
import module namespace constants = "http://marklogic.com/io-test/constants" at "/app/lib/constants.xqy";

let $field-name := xdmp:get-request-field($constants:NAME-FIELD-NAME)
let $field-value := xdmp:get-request-field($constants:VALUE-FIELD-NAME)
let $map := map:map()
let $null := map:put($map,$field-name,$field-value)
return
xdmp:to-json(util:check-values($map))