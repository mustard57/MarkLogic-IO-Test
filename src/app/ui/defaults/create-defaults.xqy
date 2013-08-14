import module namespace util  = "http://marklogic.com/io-test/util" at "/app/lib/util.xqy";
import module namespace constants = "http://marklogic.com/io-test/constants" at "/app/lib/constants.xqy";

xdmp:set-response-content-type("text/html"),
element html{
    element head{
        element title{"Save Defaults"},    
        element link{attribute rel{"stylesheet"}, attribute type{"text/css"}, attribute href{"/public/css/io.css"}},
        element script{attribute src{"/public/js/jquery-1.9.0.js"}," "},
        element script{attribute src{"/public/js/app.js"}," "},                
        element script{
            attribute type{"text/javascript"},
        
            '            
            $(document).ready(
                function(){
                    $("input").change(validate);
                }
            );            
            '
         }
            
    },
    element body{
        element h1{"Save Defaults"},
        element form{
            attribute method {"POST"},            
            attribute action {"/app/ui/defaults/save-defaults.xqy"},
            element br{},
            element table{
                attribute style {"margin:  0 auto ; "},
                attribute class {"newspaper-a"},
                element tr{element th{"Parameter"},element th{"Default Values"},element th{}},
                element tr{element td{"&nbsp;"},element td{"&nbsp;"},element td{"&nbsp;"}},
            
                for $field in ($constants:RUN-LABEL-FIELD-NAME,util:run-time-data-fields(), $constants:batch-data-fields,$constants:other-fields)
                where $field != $constants:read-only-fields                
                return
                element tr
                {
                    element td
                    {util:element-name-to-title($field)},
                    element td
                    {
                        element input{
                            attribute id{$field||"-default"},
                            attribute name{$field||"-default"},                            
                            attribute type{"text"},
                            attribute value{util:getDefaultValue($field)}
                        }
                    },                    
                    element td{
                        attribute id{$field||"-default_comment"}
                    }                    
                    
                },
                
                element tr
                {
                    element td
                    {
                        attribute colspan{"3"},
                        element div{
                            attribute style {"width 100% ; margin : auto 0 ; text-align : center"},
                            element input{
                                attribute type{"submit"},
                                attribute value{"Submit"}
                            }

                        }
                    }

                }
                
            }
        },
        element br{},
        element div{
            attribute style{"clear:both ;"},
            element div{
                attribute style{"float:left;width : 50% ;"},            
                element p{attribute style{"text-align : center ; width : 100%"}, element a{attribute href{"/app/ui/defaults/show-defaults.xqy"},"Show Defaults"}}            
            },
            element div{
                attribute style{"float:left;width : 50%"},            
                element p{attribute style{"text-align : center ; width : 100%"}, element a{attribute href{"/app/index.xqy"},"Home"}}            
            }                        
        }
        
    }
}

