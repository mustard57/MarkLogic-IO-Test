import module namespace util  = "http://marklogic.com/io-test/util" at "/app/lib/util.xqy"; 
import module namespace constants = "http://marklogic.com/io-test/constants" at "/app/lib/constants.xqy";

let $field-name := xdmp:get-request-field($constants:NAME-FIELD-NAME)
let $field-value := xdmp:get-request-field($constants:VALUE-FIELD-NAME)
return
if(fn:ends-with($field-name,"-values")) then
let $field-name := fn:replace($field-name,"-values","")
let $map := map:map()
let $null := map:put($map,$field-name,$field-value)
return
xdmp:to-json(util:check-values($map))
else if(fn:ends-with($field-name,"-default")) then
let $field-name := fn:replace($field-name,"-default","")
let $map := map:map()
let $null := map:put($map,$field-name,$field-value)
let $check := util:check-values($map)
let $null := if(map:keys($check)) then () else if(fn:count(fn:tokenize($field-value,",")) > 1) then map:put($check,$field-name,"Default should be a singleton") else () 
return
xdmp:to-json($check)
else
let $map := map:map()
let $null := map:put($map,$field-name,$field-value)
return
xdmp:to-json(util:check-values($map))