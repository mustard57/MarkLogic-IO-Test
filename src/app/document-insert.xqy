declare variable $uri as xs:string external;
declare variable $node as element() external;

xdmp:document-insert($uri,$node)