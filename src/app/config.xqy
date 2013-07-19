import module namespace util  = "http://marklogic.com/io-test/util" at "/app/util.xqy";

declare variable $batch-data-map := util:get-batch-data-map();

xdmp:set-response-content-type("text/html"),
element html{
    element head{},
    element body{
        element h3{"Run Configuration"},    
        element table{
            let $field := "run-label"
            return

            element tr{
                element td{util:element-name-to-title($field)},
                element td{util:get-constant($field)}
            },

            element tr{
                element td{"&nbsp;"},
                element td{"&nbsp;"}
            },
        
            for $field in fn:tokenize("inserts-per-second,duration,payload",",")
            return

            element tr{
                element td{util:element-name-to-title($field)},
                element td{util:get-constant($field)}
            },

            element tr{
                element td{"&nbsp;"},
                element td{"&nbsp;"}
            },

            element tr{
                element td{"Expected Document Count"},
                element td{util:toShorthand(util:expected-document-count($batch-data-map))}
            },

            element tr{
                element td{"Document Volume"},
                element td{util:toBytes(util:expected-document-volume($batch-data-map))}
            },
            element tr{
                element td{"&nbsp;"},
                element td{"&nbsp;"}
            },
            
            element tr{
                element th{"Field Name"},
                element th{"Field Value"}
            },

            element tr{
                element td{"&nbsp;"},
                element td{"&nbsp;"}
            },


            
            for $field in util:run-time-data-field-plurals() 
            return

            element tr{
                element td{util:element-name-to-title($field)},
                element td{util:get-constant($field)}
            }
            
        },
        element br{},
        element a {attribute href{"/app/index.xqy"},"Home"}
        
    }
}

