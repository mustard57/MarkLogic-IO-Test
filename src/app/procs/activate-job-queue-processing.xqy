xquery version "1.0-ml";

import module namespace constants = "http://marklogic.com/io-test/constants" at "/app/lib/constants.xqy";

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

declare namespace group = "http://marklogic.com/xdmp/group";

declare variable $mode := xdmp:get-request-field($constants:MODE-FIELD-NAME);

xdmp:set-response-content-type("text/html"),
element html{
    element head{
        element link{attribute rel{"stylesheet"}, attribute type{"text/css"}, attribute href{"/public/css/io.css"}},
        element title {"Job deleted"}    
    },
    element body{
        element h1{"Activating / Deactivating Queue Processing"},
 
            let $task := admin:group-minutely-scheduled-task(
                  $constants:RUN-JOB-TASK,
                  admin:appserver-get-root(admin:get-configuration(),xdmp:server()),
                  5,
                  xdmp:database(),
                  0,
                  admin:appserver-get-modules-database(admin:get-configuration(),xdmp:server()), 
                  0)
            
            return
            if($mode = $constants:CREATE-MODE) then
            (
                admin:save-configuration(
                    admin:group-add-scheduled-task(admin:get-configuration(), xdmp:group(), $task)),
                element h4{"Job added"}        
            )
            else if($mode = $constants:DELETE-MODE) then
            (
                for $task in admin:group-get-scheduled-tasks(admin:get-configuration(),xdmp:group())
                where $task/group:task-path/text() = $constants:RUN-JOB-TASK
                return
                admin:save-configuration(
                    admin:group-delete-scheduled-task(admin:get-configuration(), xdmp:group(), $task))
                ,
                element h4{"Job removed"}        
            )
            else
            element h4{"Mode "||$mode||" not recognized"}
            ,

            element div{        
                attribute style{"clear:both ; margin-top : 10%"},
                element div{
                    attribute style{"float:left;width : 50%"},            
                    element p{attribute style{"text-align : center ; width : 100%"}, element a{attribute href{"/app/ui/job/list-jobs.xqy"},"Job List"}}            
                },
                element div{
                    attribute style{"float:left;width : 50%"},            
                    element p{attribute style{"text-align : center ; width : 100%"}, element a {attribute href{"/app/index.xqy"},"Home"}}
                }
            }
            
        }
                
    
}
