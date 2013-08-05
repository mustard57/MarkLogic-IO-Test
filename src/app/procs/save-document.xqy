declare variable $uri as xs:string external;
declare variable $directory as xs:string external;

xdmp:save($directory||fn:tokenize($uri,"/")[last()],fn:doc($uri))
