xquery version "1.0-ml"; 
(: Remove database $db-name and attached forests :)
import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

declare variable $db-name as xs:string external;


if(admin:database-exists(admin:get-configuration(),$db-name)) then
(
for $server in xdmp:servers()
return
if($server != admin:group-get-taskserver-id(admin:get-configuration(),xdmp:group())) then
if(admin:appserver-get-database(admin:get-configuration(),$server) = xdmp:database($db-name)) then
(
"Deleting server "||xdmp:server-name($server),
admin:save-configuration-without-restart(admin:appserver-delete(admin:get-configuration(),$server))
)
else()  
else(),
for $forest in xdmp:database-forests(xdmp:database($db-name))
let $forest-name := xdmp:forest-name($forest)
order by $forest-name
return
(
admin:save-configuration(admin:database-detach-forest(admin:get-configuration(),xdmp:database($db-name),$forest)),
admin:save-configuration(admin:forest-delete(admin:get-configuration(),$forest,fn:true())),
"Forest "||$forest-name||" deleted"
),
admin:save-configuration-without-restart(admin:database-delete(admin:get-configuration(),(xdmp:database($db-name)))),
"Database "||$db-name||" deleted"
)
else
"Database "||$db-name||" does not exist"