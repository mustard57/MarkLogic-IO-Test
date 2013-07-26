import module namespace util  = "http://marklogic.com/io-test/util" at "/app/lib/util.xqy";
import module namespace constants = "http://marklogic.com/io-test/constants" at "/app/lib/constants.xqy";

xdmp:set-response-content-type("text/html"),
element html{
    element head{
        element title{"Run Batch"},    
        element link{attribute rel{"stylesheet"}, attribute type{"text/css"}, attribute href{"/public/css/io.css"}}    
    },

    element body{
        element h1{"Run Batch"},    
        element br{},
        element form{
            attribute method {"POST"},
            attribute action {"/app/ui/job/run-job.xqy"},
            element table{
                attribute style {"margin:  0 auto ; "},
                attribute class {"newspaper-a"},
                element tr{element th{"Parameter"},element th{"Value"}},
                element tr{element td{"&nbsp;"},element td{"&nbsp;"}},
            
                let $field := $constants:RUN-LABEL-FIELD-NAME
                return
                element tr
                {
                    element td
                    {util:element-name-to-title($field)},
                    element td
                    {
                        element input{
                            attribute name{$field},
                            attribute type{"text"},
                            attribute value{"Your label here"}

                        }
                    }
                },
            
                for $field in util:run-time-data-fields()
                return
                element tr
                {
                    element td
                    {util:element-name-to-title($field)},
                    element td
                    {
                        element input{
                            attribute name{$field},
                            attribute type{"text"},
                            attribute value{util:getDefaultValue($field)}
                        }
                    }
                },
                for $field in $constants:batch-data-fields
                return
                element tr
                {
                    element td
                    {util:element-name-to-title($field)},
                    element td
                    {
                        element input{
                            attribute name{$field},
                            attribute type{"text"},
                            attribute value{util:get-constant($field)}
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
                
            }
        },
        element br{},
        element div{
            attribute style{"clear:both ;"},
            element div{
                attribute style{"float:left;width : 25% ;"},            
                element p{attribute style{"text-align : center ; width : 100%"}, element a{attribute href{"/app/ui/job/list-jobs.xqy"},"Job List"}}            
            },
            element div{
                attribute style{"float:left;width : 25%"},            
                element p{attribute style{"text-align : center ; width : 100%"}, element a{attribute href{"/app/ui/run-config.xqy"},"Run Configuration"}}
            },
            element div{
                attribute style{"float:left;width : 25%"},            
                element p{attribute style{"text-align : center ; width : 100%"}, element a{attribute href{"/app/ui/status.xqy"},"Status"}}            
            },
            element div{
                attribute style{"float:left;width : 25%"},            
                element p{attribute style{"text-align : center ; width : 100%"}, element a{attribute href{"/app/index.xqy"},"Home"}}            
            }                        
        }            
    }
}

