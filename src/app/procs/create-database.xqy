(: Create database with name $db-name and attach $forest-count forests :) 
(: local:getForestDirectory is used to determine forest location :)
xquery version "1.0-ml"; 

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";
import module namespace constants = "http://marklogic.com/io-test/constants" at "/app/lib/constants.xqy";

declare variable $db-name as xs:string external;
declare variable $forest-count as xs:int external;

declare variable $hosts := for $host in xdmp:hosts() order by xdmp:host-name($host) return $host;

declare function local:getForestDirectory($forest-index as xs:int){
  $constants:DATA-DB-FOREST-DIRECTORY
};

(: If database does not exist, create it :)
if(fn:not(admin:database-exists(admin:get-configuration(),$db-name))) then
  admin:save-configuration(admin:database-create(admin:get-configuration(),$db-name,xdmp:database("Security"),xdmp:database("Schemas")))
else(),  
(: Here we create the forests, round robinn-ing across all available hosts :)
for $count in (1 to $forest-count)
let $host := $hosts[(($count -1) mod fn:count($hosts))+1]
let $count-padded := if($count <10) then fn:concat("0",xs:string($count)) else xs:string($count)
let $forest-name := $db-name||"-"||$count-padded
return
(
if(fn:not(admin:forest-exists(admin:get-configuration(),$forest-name))) then
(
  admin:save-configuration(admin:forest-create(admin:get-configuration(),$forest-name,$host,local:getForestDirectory($count))),
  $forest-name||" created on "||xdmp:host-name($host)||" in directory "||local:getForestDirectory($count)
)  
else
  "Forest "||$forest-name||" already exists"
,
if(fn:not(admin:forest-get-database(admin:get-configuration(),xdmp:forest($forest-name)))) then
(
  admin:save-configuration(admin:database-attach-forest(admin:get-configuration(),xdmp:database($db-name),xdmp:forest($forest-name))),
  $forest-name||" attached to "||$db-name
)  
else
  $forest-name||" already attached to "||xdmp:database-name(xdmp:forest-databases(xdmp:forest($forest-name)))
),  
$db-name||" database set up"
