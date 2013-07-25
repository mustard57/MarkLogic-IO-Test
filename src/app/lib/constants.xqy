module namespace constants = "http://marklogic.com/io-test/constants";

(: You might want to change this on a per run basis :)
declare variable $run-label := "batch-map-test";

declare variable $run-time-data-fields := "forest-counts,batch-sizes,io-limits,merge-ratios,tree-sizes,fast-insert-values,thread-counts,host-counts,host-types,file-system-formats,disk-types";
declare variable $batch-data-fields := "inserts-per-second,duration,payload,run-label";
declare variable $dont-show-in-jobs-table := "host-counts,host-types,file-system-formats,disk-types";

(: Parameters controlling the 'size' of the run :)
declare variable $inserts-per-second  := 10;
declare variable $duration := 10;
declare variable $payload  :=  10000;

(: Setup constants :)
declare variable $HOST-TYPE := "HP EliteBook 8460w";
declare variable $FILE-SYSTEM-FORMAT := "NTFS";
declare variable $DISK-TYPE := "SATA2-7200RPM"; 

declare variable $DATA-DB-FOREST-DIRECTORY := "c:\temp\";

(: The source for generating text documents :)
declare variable $SOURCE-DOCUMENT := "/on-liberty.txt";

(: Constants you might possibly wish to change, but really there's no need:)
declare variable $RECORDS-DB-NAME := "io-test-content";
declare variable $DATA-DB-NAME := "Sample";
declare variable $SAMPLE-CONTENT-URI-PREFIX := "/sample-content/";
declare variable $DEFAULT-VALUES-DOCUMENT := "/io-test/default-values.xml";
declare variable $RUN-CONFIG-DOCUMENT := "/io-test/run-config.xml";
declare variable $BATCH-CONFIG-DOCUMENT := "/io-test/batch-config.xml";
declare variable $RECORDS-DB-EVAL-OPTIONS := 
<options xmlns="xdmp:eval">
    <database>{xdmp:database($RECORDS-DB-NAME)}</database>
  </options>;
  
(: Constants that shouldn't need to be changed :)
declare variable $SOURCE-DOCUMENT-WORDS-SERVER-VARIABLE := "source-words";
declare variable $SOURCE-DOCUMENT-WORD-COUNT-SERVER-VARIABLE := "source-words-count";
declare variable $SOURCE-DOCUMENT-LENGTH-SERVER-VARIABLE := "source-words-doc-length";
declare variable $BATCH-DATA-MAP-SERVER-VARIABLE := "batch-map";
declare variable $RUN-DATA-MAP-SERVER-VARIABLE := "run-data-map"; 
declare variable $INSERTS-PER-SECOND-FIELD-NAME := "inserts-per-second";
declare variable $DURATION-FIELD-NAME := "duration";
declare variable $PAYLOAD-FIELD-NAME := "payload"; 
declare variable $RUN-LABEL-FIELD-NAME := "run-label";
declare variable $MODE-FIELD-NAME := "mode";
declare variable $JOB-ID-FIELD-NAME := "job-id";
declare variable $CREATE-MODE := "create";
declare variable $DELETE-MODE := "delete";
declare variable $FORESTS-SERVER-VARIABLE := "database-forests";
declare variable $DEFAULT-BACKGROUND-IO-LIMIT := 0;
declare variable $DEFAULT-FOREST-COUNT := fn:count(xdmp:hosts());
declare variable $DEFAULT-BATCH-SIZE := 1;
declare variable $DEFAULT-FAST-INSERT-VALUE := "TRUE";
declare variable $DEFAULT-THREAD-COUNT := 16;
declare variable $HOST-COUNT := fn:count(xdmp:hosts());
declare variable $RUN-JOB-TASK := "/app/ui/job/run-job.xqy";