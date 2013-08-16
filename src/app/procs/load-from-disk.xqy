import module namespace util = "http://marklogic.com/io-test/util" at "/app/lib/util.xqy";
import module namespace constants = "http://marklogic.com/io-test/constants" at "/app/lib/constants.xqy";

declare namespace dir="http://marklogic.com/xdmp/directory";

declare variable $db-name as xs:string external;
declare variable $run-data-map as map:map external;
declare variable $batch-map as map:map external;

declare variable $fast-insert-value as xs:boolean := map:get($run-data-map,$constants:FAST-INSERT-VALUE-FIELD-NAME);  
declare variable $batch-size as xs:int := map:get($run-data-map,$constants:BATCH-SIZE-FIELD-NAME);
declare variable $data-directory as xs:string := map:get($run-data-map,$constants:DATA-DIRECTORY-FIELD-NAME);

declare variable $directory-listing := xdmp:filesystem-directory($data-directory)//dir:entry[dir:type = "file"]/dir:pathname/text();
declare variable $volume := fn:sum(xdmp:filesystem-directory($data-directory)//dir:entry[dir:type = "file"]/dir:content-length/text());

declare variable $iterations := fn:count($directory-listing);
declare variable $payload := xs:int($volume div $iterations);


declare variable $full-runs := xs:int($iterations div $batch-size);
declare variable $remainder := $iterations - ( $full-runs * $batch-size);

declare variable $eval-options := 
<options xmlns="xdmp:eval">
      <database>{xdmp:database($db-name)}</database>
</options>;

xdmp:log("Directory listing : "||fn:string-join($directory-listing[1 to 10],",")),

(: Need to do this stuff ... :)

map:put($run-data-map,$constants:DURATION-FIELD-NAME,$iterations div map:get($batch-map,$constants:INSERTS-PER-SECOND-FIELD-NAME)),
map:put($run-data-map,$constants:PAYLOAD-FIELD-NAME,$payload),
map:put($run-data-map,$constants:INSERTS-PER-SECOND-FIELD-NAME,util:inserts-per-second($batch-map)),
map:put($run-data-map,$constants:EXPECTED-FRAGMENT-COUNT-FIELD-NAME,$iterations),
util:set-batch-data-map($run-data-map),

for $count in (1 to $full-runs)
let $paths := $directory-listing[($count -1) * $batch-size + 1,$count * $batch-size]
return
(
	xdmp:spawn("/app/procs/batch-insert.xqy",
	    (xs:QName("paths"),$paths,xs:QName("fast-insert-value"),$fast-insert-value),$eval-options),
	xdmp:sleep(xs:int($batch-size * 1000 div util:inserts-per-second($batch-map)))
)
,
"Spawned "||xs:string($full-runs)||" jobs of size "||xs:string($batch-size),
if($remainder > 0) then
(
    let $paths := $directory-listing[$full-runs * $batch-size + 1,$iterations]
    return
    (
        xdmp:spawn("/app/procs/batch-insert.xqy",
            (xs:QName("paths"),$paths,xs:QName("fast-insert-value"),$fast-insert-value),$eval-options),
            "Spawned remaining "||xs:string($remainder)||" jobs"
    )
)
else()	


