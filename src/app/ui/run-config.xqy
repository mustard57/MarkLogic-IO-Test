import module namespace util  = "http://marklogic.com/io-test/util" at "/app/lib/util.xqy";

declare variable $batch-data-map := util:get-batch-data-map();
declare variable $run-data-map := util:get-run-data-map();

xdmp:set-response-content-type("text/html"),
element html{
    element head{
        element link{attribute rel{"stylesheet"}, attribute type{"text/css"}, attribute href{"/public/css/io.css"}},
        element title{"IO Test System Run Configuration Values"}    
    },
    element body{
        element h1{"IO Test System Run Configuration"},    
        element div{
            attribute style{"height 60%"},
            let $field := "run-label"
            return

            element h4{
                util:element-name-to-title($field)||" : "||
                map:get($batch-data-map,$field)
            },

            element h2{"DB Statistics"},
            for $field in fn:tokenize("inserts-per-second,duration,payload",",")
            return

            element h4{
                util:element-name-to-title($field)||" : "||
                map:get($batch-data-map,$field)
            },

            element h4{
                "Expected Document Count"||" : "||
                util:toShorthand(util:expected-document-count($batch-data-map))
            },

            element h4{
                "Document Volume"||" : "||
                util:toBytes(util:expected-document-volume($batch-data-map))
            },
            

            element h2{"Batch Configuration"},

            
            for $field in util:run-time-data-field-plurals() 
            return

            element h4{
                util:element-name-to-title($field)||" : "||
                map:get($run-data-map,util:de-pluralize($field))
            }
        }
        ,

        element div{
            attribute style{"clear:both"},
            element div{
                attribute style{"float:left;width : 33%"},            
                element p{element a {attribute href{"/app/index.xqy"},"Home"}}
            }
        }
        
    }
}

