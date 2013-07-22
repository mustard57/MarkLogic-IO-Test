import module namespace util  = "http://marklogic.com/io-test/util" at "/app/util.xqy";

xdmp:set-response-content-type("text/html"),
element html{
    element head{},
    element body{
        element form{
            attribute method {"POST"},
            attribute action {"/app/save-job.xqy"},
            element table{
                let $field := "run-label"
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
                for $field in fn:tokenize("inserts-per-second,duration,payload",",")
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
                        element input{

                            attribute type{"submit"},
                            attribute value{"Submit"}

                        }
                    },
                    element td{}
                }
                
            }
        }
    }
}

