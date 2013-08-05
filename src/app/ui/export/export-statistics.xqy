import module namespace util  = "http://marklogic.com/io-test/util" at "/app/lib/util.xqy";
import module namespace constants = "http://marklogic.com/io-test/constants" at "/app/lib/constants.xqy";

xdmp:set-response-content-type("text/html"),
element html{
    element head{
        element title{"Export Statistics"},    
        element link{attribute rel{"stylesheet"}, attribute type{"text/css"}, attribute href{"/public/css/io.css"}},
        element script{attribute src{"/public/js/jquery-1.9.0.js"}," "},
        element script{attribute src{"/public/js/app.js"}," "}
            
    },
    element body{
        element h1{"Export Statistics"},
        element form{
            attribute method {"POST"},            
            attribute action {"/app/procs/export-statistics.xqy"},
            element br{},
            element table{
                attribute style {"margin:  0 auto ; "},
                attribute class {"newspaper-a"},
                element tr{element th{"Parameter"},element th{"Value"}},
                element tr{element td{"&nbsp;"},element td{"&nbsp;"}},
                for $field in ($constants:DIRECTORY-FIELD-NAME,$constants:FILENAME-FIELD-NAME)
                return
                element tr
                {
                    element td
                    {util:element-name-to-title($field)},
                    element td
                    {
                        element input{
                            attribute id{$field},
                            attribute name{$field},                            
                            attribute type{"text"}
                        }                        
                    }                    
                },
                element tr
                {
                    element td
                    {
                        attribute colspan{"2"},
                        element div{
                            attribute style {"width 100% ; margin : auto 0 ; text-align : center"},
                            element input{
                                attribute type{"submit"},
                                attribute value{"Submit"}
                            }

                        }
                    }

                }
                
        },
        element br{},
        element div{
            attribute style{"clear:both ;"},
            element div{
                attribute style{"float:left;width : 100%"},            
                element p{attribute style{"text-align : center ; width : 100%"}, element a{attribute href{"/app/index.xqy"},"Home"}}            
            }                        
        }
        
    }
}
}
                                       
                            
