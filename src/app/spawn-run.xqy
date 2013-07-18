
import module namespace constants = "http://marklogic.com/io-test/constants" at "/app/constants.xqy";


xdmp:set-response-content-type("text-html"),
element html{
    element head{},
    element body{
        element h2{"Spawn run ..."},
        xdmp:spawn("/app/run.xqy"), 
        element p{"Your run has been spawned"},
        element p{element a{attribute href{"/app/config.xqy"},"Current Configuration"}},
        element p{element a{attribute href{"/app/status.xqy"},"Status"}},            
        element p{element a{attribute href{"/app/index.xqy"},"Home"}}        
    }
}

