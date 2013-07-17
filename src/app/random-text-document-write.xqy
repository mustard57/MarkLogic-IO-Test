import module namespace constants  = "http://marklogic.com/io-test/constants" at "/app/constants.xqy";

declare variable $document-length as xs:integer external;
declare variable $batch-size as xs:integer external;
declare variable $fast-insert-value as xs:boolean external;

declare variable $document-suffix := ".txt";

declare variable $source-word-count := local:source-word-count();
declare variable $source-words := local:source-words();
declare variable $forests := xdmp:database-forests(xdmp:database());

declare function local:unset-server-fields(){
  (
    xdmp:set-server-field($constants:SOURCE-DOCUMENT-WORDS-SERVER-VARIABLE,()),
    xdmp:set-server-field($constants:SOURCE-DOCUMENT-WORD-COUNT-SERVER-VARIABLE,()),
    xdmp:set-server-field($constants:SOURCE-DOCUMENT-LENGTH-SERVER-VARIABLE,())
  )[0]
};

declare function local:get-document-words(){
  let $doc := xdmp:document-get($constants:SOURCE-DOCUMENT)
  let $words := 
  for $token in cts:tokenize($doc)
  return
  typeswitch($token)
    case cts:word return $token
    default return ()
  return
  $words
};

declare function local:initialize(){
  (
    xdmp:set-server-field($constants:SOURCE-DOCUMENT-WORDS-SERVER-VARIABLE,local:get-document-words()),
    xdmp:set-server-field($constants:SOURCE-DOCUMENT-LENGTH-SERVER-VARIABLE,
		fn:string-length(fn:string-join(xdmp:get-server-field($constants:SOURCE-DOCUMENT-WORDS-SERVER-VARIABLE)," "))),
    xdmp:set-server-field($constants:SOURCE-DOCUMENT-WORD-COUNT-SERVER-VARIABLE,fn:count(xdmp:get-server-field($constants:SOURCE-DOCUMENT-WORDS-SERVER-VARIABLE)))
  )[0]
  
};
declare function local:source-doc-length() as xs:integer{
  if(xdmp:get-server-field($constants:SOURCE-DOCUMENT-LENGTH-SERVER-VARIABLE)) then ()
  else local:initialize(),
  xdmp:get-server-field($constants:SOURCE-DOCUMENT-LENGTH-SERVER-VARIABLE)
};

declare function local:source-words() as xs:string*{  
  if(xdmp:get-server-field($constants:SOURCE-DOCUMENT-WORDS-SERVER-VARIABLE)) then ()
  else
  local:initialize(),
  xdmp:get-server-field($constants:SOURCE-DOCUMENT-WORDS-SERVER-VARIABLE)
};

declare function local:source-word-count() as xs:integer{
  (
    if(xdmp:get-server-field($constants:SOURCE-DOCUMENT-WORD-COUNT-SERVER-VARIABLE)) then ()
    else
    local:initialize(),
    xdmp:get-server-field($constants:SOURCE-DOCUMENT-WORD-COUNT-SERVER-VARIABLE)
  )
};

declare function local:get-wordcount-for-document-length($doc-length as xs:integer) as xs:integer{
  xs:integer((local:source-word-count() * $doc-length) div  local:source-doc-length() )
};

declare function local:get-random-text-with-length($doc-length as xs:integer){
  fn:string-join(
    for $count in (1 to local:get-wordcount-for-document-length($doc-length))
    let $random := xdmp:random($source-word-count -1)+1 
    return
    $source-words[$random]
    ,
    " "
  )
};

for $count in (1 to $batch-size)
let $text := local:get-random-text-with-length($document-length)
let $uri := $constants:SAMPLE-CONTENT-URI-PREFIX||xdmp:md5(xs:string(fn:current-dateTime())||xs:string(xdmp:random(1000000)))||$document-suffix

return
(
	$uri,
	if($fast-insert-value) then
	    xdmp:document-insert($uri,text{$text},(),(),(),$forests[xdmp:document-assign($uri,fn:count($forests))])
	else
	    xdmp:document-insert($uri,text{$text})
)
