declare variable $reads-per-second := 1000;
declare variable $simulation-duration := 1;

declare variable $iterations := $reads-per-second * $simulation-duration;
declare variable $uris := cts:uris();
declare variable $uri-count := fn:count($uris);

for $count in (1 to $iterations)
let $uri-no := xdmp:random($uri-count - 1) + 1
let $uri := $uris[$uri-no]
return
(
  xdmp:eval("declare variable $uri as xs:string external ; fn:doc($uri)",
    (xs:QName("uri"),$uri))[0],
  xdmp:sleep(1000 div $reads-per-second)
)  ,
let $time := xdmp:elapsed-time()
return
(
"Elapsed = "||$time,
"Expected = "||$simulation-duration,
"Average duration := "||($time div $iterations)
)