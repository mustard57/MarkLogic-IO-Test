import module namespace admin  = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";
import module namespace constants = "http://marklogic.com/io-test/constants" at "/app/constants.xqy";
import module namespace util = "http://marklogic.com/io-test/util" at "/app/util.xqy";


xdmp:set-response-content-type("text/html"),
element html{
    element head{},
    element body{
    
        for $element in util:getDefaultValuesDoc()/default-values/*
        return
        (util:element-name-to-title($element/fn:node-name())||" : "||xs:string($element),element br{}), 
        element br{},
        element a {attribute href{"/app/index.xqy"},"Home"}
        
    }
}