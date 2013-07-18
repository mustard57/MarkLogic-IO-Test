module namespace util  = "http://marklogic.com/io-test/util";

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

import module namespace constants = "http://marklogic.com/io-test/constants" at "/app/constants.xqy";

declare namespace server-status = "http://marklogic.com/xdmp/status/server";
declare namespace forest = "http://marklogic.com/xdmp/status/forest";

declare function queue-size() as xs:int{    
    xs:int(xdmp:server-status(xdmp:host(),admin:group-get-taskserver-id(admin:get-configuration(),xdmp:group()))//server-status:queue-size/fn:number())
};

declare function request-count() as xs:int{
	fn:count(xdmp:server-status(xdmp:host(),admin:group-get-taskserver-id(admin:get-configuration(),xdmp:group()))//server-status:request-status)
};

declare function queue-empty() as xs:boolean{
	queue-size() + request-count() = 0
};

declare function get-defaults() as node(){
	fn:doc($constants:DEFAULT-VALUES-DOCUMENT)
};

declare function get-stands-written($db-name as xs:string) as xs:int{
	fn:sum(for $forest in xdmp:database-forests(xdmp:database($db-name))
	return
	(
	  fn:max(
		xdmp:hex-to-integer(

		  for $path in xdmp:forest-status($forest)/forest:stands/forest:stand/forest:path
		  return
		  fn:tokenize($path,"/|\\")[fn:last()]
		) +1  
	  )
	))
};

(: Capitalize a term :)
declare function util:capitalize($term) as xs:string{
  fn:upper-case(fn:substring($term,1,1))||
  fn:lower-case(fn:substring($term,2,fn:string-length($term) - 1))
};

(: Remove spaces and add caps to turn element names into titles :)
declare function util:element-name-to-title($element-name) as xs:string{
  fn:string-join(
    for $term in fn:tokenize(xs:string($element-name),"-")
    return
    util:capitalize($term),
    " ")
};

(: De-pluralize :)
declare function util:de-pluralize($field){
    fn:replace($field,"s$","")
};

(: All possible run-time fields, in their plural form :)
declare function util:run-time-data-field-plurals(){
    for $field in fn:tokenize($constants:run-time-data-fields,",")
    return
    $field
};

(: Get a specific constant :)
declare function util:get-constant($constant-name) as xs:string{
    let $constants-import-statement := "import module namespace constants = 'http://marklogic.com/io-test/constants' at '/app/constants.xqy';"
    return
    xs:string(xdmp:eval($constants-import-statement||"$constants:"||$constant-name))
};

(: All possible runtime fields as titles :)
declare function util:run-time-data-field-titles(){
    for $field in util:run-time-data-field-plurals()
    return
    util:element-name-to-title(fn:replace($field,"s$",""))
};    

(: All possible runtime fields, in singleton form :)
declare function util:run-time-data-fields(){
    for $field in util:run-time-data-field-plurals()
    return
    util:de-pluralize($field)
};    

(: For a given run, show those fields that were not varied :)
declare function util:get-singleton-fields($run-label as xs:string){
    let $qnames := util:run-time-data-fields()
    let $stats := /io-stats[run-label = $run-label]
    return
    for $qname in $qnames
    return
    if(fn:count(fn:distinct-values($stats/*[fn:node-name() = xs:QName($qname)])) = 1) then
    $qname
    else
    ()
};

(: For a given run, show those fields that were varied :)
declare function util:get-multi-value-fields($stats as node()*){
    let $qnames := util:run-time-data-fields()
    (: let $stats := /io-stats[run-label = $run-label] :)
    return
    for $qname in $qnames
    return
    if(fn:count(fn:distinct-values($stats/*[fn:node-name() = xs:QName($qname)])) > 1) then
    $qname
    else
    ()
};

(: For a given run, show those fields that were not varied :)
declare function util:get-singleton-values($stats as node()*) as map:map{
    let $qnames := util:run-time-data-fields()
    (: let $stats := /io-stats[run-label = $run-label] :)
    let $map := map:map()
    let $null := 
    for $qname in $qnames
    let $values := fn:distinct-values($stats/*[fn:node-name() = xs:QName($qname)])
    return
    if(fn:count($values) = 1) then
    map:put($map,$qname,$values[1])
    else
    ()
    return
    $map
};

declare function util:expected-document-count() as xs:long{
    $constants:inserts-per-second * $constants:duration    
};

declare function util:expected-document-volume() as xs:long{
    $constants:inserts-per-second * $constants:duration * $constants:payload    
};

declare function util:toBytes($size as xs:long) as xs:string{
    if($size < 1000) then
        xs:string($size)||" bytes"
    else if($size < 1000 * 1000) then
        util:round($size div 1000,3)||" kb"
    else if($size < 1000 * 1000 * 1000) then
        util:round($size div 1000 div 1000,3)||" mb"
    else
        util:round($size div 1000 div 1000,3)||" gb"    
};

declare function util:toShorthand($size as xs:long) as xs:string{
    if($size < 1000) then
        xs:string($size)||""
    else if($size < 1000 * 1000) then
        util:round($size div 1000,3)||"k"
    else if($size < 1000 * 1000 * 1000) then
        util:round($size div 1000 div 1000,3)||"m"
    else
        util:round($size div 1000 div 1000,3)||"bn"    
};

declare function util:date-format($date as xs:dateTime) as xs:string{
    fn:substring(fn:replace(xs:string($date),"T"," "),1,19)
};

declare function util:round($val as xs:double,$places as xs:int){
    xs:int($val * math:pow(10,$places)) div math:pow(10,$places)    
};

declare function util:getDefaultValuesDoc(){
    if(fn:doc($constants:DEFAULT-VALUES-DOCUMENT)/default-values[run-label = $constants:RUN-LABEL]) then () 
    else xdmp:invoke("/app/save-default-values.xqy",(xs:QName("db-name"),xdmp:database-name(xdmp:database()))),
    fn:doc($constants:DEFAULT-VALUES-DOCUMENT)
};    