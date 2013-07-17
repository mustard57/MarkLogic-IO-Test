import module namespace constants = "http://marklogic.com/io-test/constants" at "/app/constants.xqy";

declare variable $db-name as xs:string external;
declare variable $run-data as element(run-data) external;

declare variable $fast-insert-value as xs:boolean := xs:boolean(fn:lower-case($run-data/fast-insert-value/text()));  
declare variable $batch-size := xs:int($run-data/batch-size);
declare variable $iterations := $constants:inserts-per-second * $constants:duration;
declare variable $full-runs := xs:int($iterations div $batch-size);
declare variable $remainder := $iterations - ( $full-runs * $batch-size);


declare variable $eval-options := 
<options xmlns="xdmp:eval">
      <database>{xdmp:database($db-name)}</database>
</options>;

for $count in (1 to $full-runs)
return
(
	xdmp:spawn("/app/random-text-document-write.xqy",
	    (xs:QName("document-length"),$constants:payload,xs:QName("batch-size"),$batch-size,xs:QName("fast-insert-value"),$fast-insert-value),$eval-options),
	xdmp:sleep($batch-size * 1000 div $constants:inserts-per-second)
)
,
"Spawned "||xs:string($full-runs)||" jobs of size "||xs:string($batch-size),
if($remainder > 0) then
(
	xdmp:spawn("/app/random-text-document-write.xqy",
	    (xs:QName("document-length"),$constants:payload,xs:QName("batch-size"),$remainder,xs:QName("fast-insert-value"),$fast-insert-value),$eval-options),
	"Spawned remaining "||xs:string($remainder)||" jobs"
)
else()	

