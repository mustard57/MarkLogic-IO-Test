import module namespace constants  = "http://marklogic.com/io-test/constants" at "/app/lib/constants.xqy";

declare variable $paths as xs:string* external;
declare variable $fast-insert-value as xs:boolean external;

declare variable $forests := xdmp:database-forests(xdmp:database());

for $path in $paths
let $uri := "/"||fn:tokenize($path,"/|\\")[fn:last()]

return
(
	$uri,
	if($fast-insert-value) then
	    xdmp:document-insert($uri,xdmp:document-get($path),(),(),(),$forests[xdmp:document-assign($uri,fn:count($forests))])
	else
	    xdmp:document-insert($uri,xdmp:document-get($path))
)
