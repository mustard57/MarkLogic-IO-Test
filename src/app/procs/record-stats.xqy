import module namespace util  = "http://marklogic.com/io-test/util" at "/app/lib/util.xqy";

declare variable $run-start-time as xs:dateTime external;
declare variable $batch-start-time as xs:dateTime external;
declare variable $db-name as xs:string external;
declare variable $run-data-map as map:map external;
declare variable $batch-map as map:map external;

declare variable $queue-size := util:queue-size();

if((util:request-count() + util:queue-size()) <= 2) then
(
	let $uri:= "/io-stats/"||xdmp:md5(xs:string($run-start-time))||".xml"
	let $stats := xdmp:invoke("/app/procs/get-stats.xqy",
	(xs:QName("run-start-time"),$run-start-time,xs:QName("batch-start-time"),$batch-start-time,xs:QName("db-name"),$db-name,xs:QName("run-data-map"),$run-data-map,xs:QName("batch-map"),$batch-map))
	return 
	xdmp:document-insert($uri,$stats)
)	
else
(
	xdmp:sleep(100),
	xdmp:spawn("/app/procs/record-stats.xqy",
	(xs:QName("run-start-time"),$run-start-time,xs:QName("batch-start-time"),$batch-start-time,xs:QName("db-name"),$db-name,xs:QName("run-data-map"),$run-data-map,xs:QName("batch-map"),$batch-map))
)


	
	
