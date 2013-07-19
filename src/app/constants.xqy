module namespace constants = "http://marklogic.com/io-test/constants";

(: You might want to change this on a per run basis :)
declare variable $run-label := "batch-map-test";

declare variable $run-time-data-fields := "forest-counts,batch-sizes,io-limits,merge-ratios,tree-sizes,fast-insert-values";
declare variable $batch-data-fields := "inserts-per-second,duration,payload,run-label";

(: Paramaters iterated through during the simulation :)
declare variable $batch-sizes := "3";
declare variable $forest-counts := "1";
declare variable $io-limits := "0"; 
declare variable $merge-ratios := "2";
declare variable $tree-sizes := "16";
declare variable $fast-insert-values := "TRUE";

(: Parameters controlling the 'size' of the run :)
declare variable $inserts-per-second  := 100;
declare variable $duration := 10;
declare variable $payload  :=  10000;

(: Setup constants :)
declare variable $DATA-DB-FOREST-DIRECTORY := "c:\temp\";

(: The source for generating text documents :)
declare variable $SOURCE-DOCUMENT := "c:\users\ktune\io-test\data\on-liberty.txt";

(: Constants you might possibly wish to change, but really there's no need:)
declare variable $DATA-DB-NAME := "Sample";
declare variable $SAMPLE-CONTENT-URI-PREFIX := "/sample-content/";
declare variable $DEFAULT-VALUES-DOCUMENT := "/io-test/default-values.xml";
declare variable $RUN-CONFIG-DOCUMENT := "/io-test/run-config.xml";

(: Constants that shouldn't need to be changed :)
declare variable $SOURCE-DOCUMENT-WORDS-SERVER-VARIABLE := "source-words";
declare variable $SOURCE-DOCUMENT-WORD-COUNT-SERVER-VARIABLE := "source-words-count";
declare variable $SOURCE-DOCUMENT-LENGTH-SERVER-VARIABLE := "source-words-doc-length";
declare variable $BATCH-DATA-MAP-SERVER-VARIABLE := "batch-map";
declare variable $INSERTS-PER-SECOND-FIELD-NAME := "inserts-per-second";
declare variable $DURATION-FIELD-NAME := "duration";
declare variable $PAYLOAD-FIELD-NAME := "payload"; 
declare variable $FORESTS-SERVER-VARIABLE := "database-forests";
declare variable $RUN-LABEL-FIELD-NAME := "run-label";
declare variable $DEFAULT-BACKGROUND-IO-LIMIT := 0;
declare variable $DEFAULT-FOREST-COUNT := fn:count(xdmp:hosts());
declare variable $DEFAULT-BATCH-SIZE := 1;
declare variable $DEFAULT-FAST-INSERT-VALUE := "TRUE";


