import module namespace util = "http://marklogic.com/io-test/util" at "/app/lib/util.xqy";

declare variable $db-name as xs:string external;
declare variable $run-data as element(run-data) external;
declare variable $batch-map as map:map external;

declare variable $fast-insert-value as xs:boolean := xs:boolean(fn:lower-case($run-data/fast-insert-value/text()));  
declare variable $batch-size := xs:int($run-data/batch-size);
declare variable $iterations := util:expected-document-count($batch-map);
declare variable $full-runs := xs:int($iterations div $batch-size);
declare variable $remainder := $iterations - ( $full-runs * $batch-size);


declare variable $eval-options := 
<options xmlns="xdmp:eval">
      <database>{xdmp:database($db-name)}</database>
</options>;

for $count in (1 to $full-runs)
return
(
	xdmp:spawn("/app/procs/random-text-document-write.xqy",
	    (xs:QName("document-length"),util:get-payload($batch-map),xs:QName("batch-size"),$batch-size,xs:QName("fast-insert-value"),$fast-insert-value),$eval-options),
	xdmp:sleep(xs:int($batch-size * 1000 div util:inserts-per-second($batch-map)))
)
,
"Spawned "||xs:string($full-runs)||" jobs of size "||xs:string($batch-size),
if($remainder > 0) then
(
	xdmp:spawn("/app/procs/random-text-document-write.xqy",
	    (xs:QName("document-length"),util:get-payload($batch-map),xs:QName("batch-size"),$remainder,xs:QName("fast-insert-value"),$fast-insert-value),$eval-options),
	"Spawned remaining "||xs:string($remainder)||" jobs"
)
else()	


