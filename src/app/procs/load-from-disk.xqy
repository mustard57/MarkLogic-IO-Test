import module namespace util = "http://marklogic.com/io-test/util" at "/app/lib/util.xqy";
import module namespace constants = "http://marklogic.com/io-test/constants" at "/app/lib/constants.xqy";

declare namespace dir="http://marklogic.com/xdmp/directory";

declare variable $db-name as xs:string external;
declare variable $run-data-map as map:map external;
declare variable $batch-map as map:map external;

declare variable $saved-batch-map as map:map := util:get-batch-data-map();

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

map:put($saved-batch-map,$constants:DURATION-FIELD-NAME,$iterations div map:get($batch-map,$constants:INSERTS-PER-SECOND-FIELD-NAME)),
map:put($saved-batch-map,$constants:PAYLOAD-FIELD-NAME,$payload),
map:put($saved-batch-map,$constants:INSERTS-PER-SECOND-FIELD-NAME,util:inserts-per-second($batch-map)),
map:put($saved-batch-map,$constants:EXPECTED-FRAGMENT-COUNT-FIELD-NAME,$iterations),
util:set-batch-data-map($saved-batch-map),

for $count in (1 to $full-runs)
let $paths := fn:string-join($directory-listing[((($count -1) * $batch-size) + 1) to ($count * $batch-size)],",")
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
    let $paths := fn:string-join($directory-listing[(($full-runs * $batch-size) + 1)  to $iterations],",")
    return
    (
        xdmp:spawn("/app/procs/batch-insert.xqy",
            (xs:QName("paths"),$paths,xs:QName("fast-insert-value"),$fast-insert-value),$eval-options),
            "Spawned remaining "||xs:string($remainder)||" jobs"
    )
)
else()	


