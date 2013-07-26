import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";
import module namespace constants = "http://marklogic.com/io-test/constants" at "/app/lib/constants.xqy";
import module namespace util = "http://marklogic.com/io-test/util" at "/app/lib/util.xqy";


declare variable $run-label := xdmp:get-request-field($constants:RUN-LABEL-FIELD-NAME,util:get-run-label(util:get-batch-data-map()));
declare variable $stats := /io-stats[run-label = $run-label];

declare function local:write-mb($uri){
  let $doc := fn:doc($uri)
  return
  fn:sum(xs:int($doc/io-stats/merge-write-mb) + xs:int($doc/io-stats/save-write-mb) + xs:int($doc/io-stats/journal-write-mb))
};

declare function local:header-row($stats as node()*){
    element tr{
        for $title in 
        (
            for $field in util:get-multi-value-fields($stats) return util:element-name-to-title($field),
            fn:tokenize("Duration,Merge Write MB,Save Write MB,Journal Write MB,Total Write,On Disk Size,In Memory Size,Fragment Count,Stands Written",",")
        )
        return
    	element th{$title}    	
	}
};

declare function local:performance-table-from-stats($stats as node()*){
    let $singleton-values := util:get-singleton-values($stats)
    let $width := xs:int(100 div (1 + fn:count(map:keys($singleton-values)) - fn:count($constants:environment-fields)))
    return
    element div{
        element div{
            attribute style{"float : left; width:"||xs:string($width)||"%"},
            element p{"Fixed Values : "}
        },
                
        for $key in map:keys($singleton-values)
        where fn:not($key = $constants:environment-fields)        
        order by $key
        return
        element div{
            attribute style{"float : left; width:"||xs:string($width)||"%"},
            element p{util:element-name-to-title($key)||" : "||map:get($singleton-values,$key)}
        }
    },
	element table{
	    attribute class {"newspaper-a"},
		local:header-row($stats),
		for $doc in $stats
		order by xs:dayTimeDuration($doc/elapsed-time)
		return
		element tr{
			for $field-name in util:get-multi-value-fields($stats)
			return
			element td{$doc/*[fn:node-name() = xs:QName($field-name)]/text()},
            element td{fn:replace($doc/elapsed-time/text(),"PT","")},			
			element td{$doc/merge-write-mb/text()},
			element td{$doc/save-write-mb/text()},
			element td{$doc/journal-write-mb/text()},
			element td{local:write-mb(fn:base-uri($doc))},				
			element td{$doc/on-disk-size/text()},			
            element td{$doc/in-memory-size/text()},           
			element td{$doc/fragment-count/text()},
			element td{$doc/stands-written/text()}
		}
	}				
};

xdmp:set-response-content-type("text/html"),

element html{
	element head{
	    element link{attribute rel{"stylesheet"}, attribute type{"text/css"}, attribute href{"/public/css/io.css"}},
        element title{"IO Test Report"}
	},
		
	element body{
		element h1{"IO Test Report"},
		
		element h4{"Run label is "||$run-label},
		(: Show statistics ranked by elapsed time :)
        element h3{"Environment"},
		
        let $singleton-values := util:get-singleton-values($stats)
        let $width := xs:int(100 div fn:count($constants:environment-fields))

        return
        element div{
            for $key in $constants:environment-fields
            order by $key
            return
            element div{
                attribute style{"float : left; width:"||xs:string($width)||"%"},
                element p{util:element-name-to-title($key)||" : "||map:get($singleton-values,$key)}
            }
        },
                
				
		element h3{"Full Run Statistics"},
		local:performance-table-from-stats($stats),
		
		(: This section shows, for each qname below, the stats where all the other qnames are set to their optimum values :)
		let $qnames := util:run-time-data-fields()
		let $counts-map := map:map()
		let $null := for $qname in $qnames
						let $values := fn:distinct-values($stats/*[fn:node-name() = xs:QName($qname)])
						return
						map:put($counts-map,$qname,$values)						
		let $optimum := (for $doc in $stats order by xs:dayTimeDuration($doc/elapsed-time) return $doc)[1]
		let $varied-fields := fn:sum(for $qname in $qnames return if(fn:count(map:get($counts-map,$qname)) > 1) then 1 else 0)
		return
		if($varied-fields > 1) then
			for $qname in $qnames
			return
			(: So if we have something to optimize over ... :)
			if(fn:count(map:get($counts-map,$qname)) > 1) then
			(
				element h3{"Varying "||$qname||" with other values optimized"},
				(: Get the stats documents corresponding to the other qnames being set to the optimum values :)
				let $query := cts:and-query((
								cts:element-value-query(xs:QName($constants:RUN-LABEL-FIELD-NAME),$run-label),
								for $q in $qnames
								return
								if($q != $qname) then
									if($optimum/*[fn:node-name() = xs:QName($q)]) then
										cts:element-value-query(xs:QName($q),$optimum/*[fn:node-name() = xs:QName($q)]/text())
									else()
								else()))
				return
				local:performance-table-from-stats(cts:search(/io-stats,$query))				
			)
			else()
		else
		element h3{"No sub tables showing statistics when varying a single parameter vs optimum values as only one parameter varied for this dataset"}
		,

		(: This section shows, for each qname below, the stats where all the other qnames are set to their default values :)
		let $qnames := util:run-time-data-fields()
		let $counts-map := map:map()
		let $null := for $qname in $qnames
						let $values := fn:distinct-values($stats/*[fn:node-name() = xs:QName($qname)])
						return
						map:put($counts-map,$qname,$values)						
		let $varied-fields := fn:sum(for $qname in $qnames return if(fn:count(map:get($counts-map,$qname)) > 1) then 1 else 0)
		return
		if($varied-fields > 1) then
			for $qname in $qnames
			return
			(: So if we have something to optimize over ... :)
			if(fn:count(map:get($counts-map,$qname)) > 1) then
			(
				let $query := cts:and-query((
								cts:element-value-query(xs:QName($constants:RUN-LABEL-FIELD-NAME),$run-label),
								for $q in $qnames
								return
								if($q != $qname) then
									cts:element-value-query(xs:QName($q),util:getDefaultValue($q))
								else()))
				let $stats := cts:search(/io-stats,$query)
				return
				if($stats) then
				(
					element h3{"Varying "||$qname||" with other values set to defaults"},
					(: Get the stats documents corresponding to the other qnames being set to the default values :)
					local:performance-table-from-stats($stats)				
				)
				else
				(
				    element div{
                            attribute style{"clear : both;"},				    
                            element h3{"Can't vary "||$qname||" vs defaults - no data corresponding to "}
                    },				
				    let $width := xs:int(100 div (fn:count($qnames) - 1))
				    return				
				    element div{				    
    					for $q in $qnames
    					return
    					if($q != $qname) then
                        element div{
                            attribute style{"float : left; width:"||xs:string($width)||"%"},					
    						(: Show the default values for the other qnames :)
    						element p{$q||" : "||util:getDefaultValue($q)}
    					}
    					else
    					()              					
					}		
				)
			)
			else()
		else
		element h3{"No sub tables showing statistics when varying a single parameter vs default values as only one parameter varied for this dataset"},
        element div{
            attribute style{"clear:both"},
            element div{
                attribute style{"float:left;width : 20%"},            
                element p{element a{attribute href{"/app/ui/report/remove-report.xqy?"||$constants:RUN-LABEL-FIELD-NAME||"="||$run-label},"Delete Records"}}
            },
            element div{
                attribute style{"float:left;width : 20%"},            
                element p{element a{attribute href{"/app/ui/job/list-jobs.xqy"},"Job List"}}            
            },
            element div{
                attribute style{"float:left;width : 20%"},            
                element p{element a{attribute href{"/app/ui/run-config.xqy"},"Run Configuration"}}
            },
            element div{
                attribute style{"float:left;width : 20%"},            
                element p{element a{attribute href{"/app/ui/status.xqy"},"Status"}}            
            },
            element div{
                attribute style{"float:left;width : 20%"},            
                element p{element a{attribute href{"/app/index.xqy"},"Home"}}            
            }                        
        }
		
			
        

            
        
		
	}
}	