module namespace constants = "http://marklogic.com/io-test/constants";

declare variable $run-time-data-fields := ($FOREST-COUNT-FIELD-NAME,$BATCH-SIZE-FIELD-NAME,$IO-LIMIT-FIELD-NAME,$MERGE-RATIO-FIELD-NAME,$TREE-SIZE-FIELD-NAME,
    $FAST-INSERT-VALUE-FIELD-NAME,$THREAD-COUNT-FIELD-NAME,$HOST-COUNT-FIELD-NAME,$HOST-TYPE-FIELD-NAME,$FILE-SYSTEM-FORMAT-FIELD-NAME,$DISK-TYPE-FIELD-NAME,$RUN-MODE-FIELD-NAME,$DATA-DIRECTORY-FIELD-NAME);
declare variable $batch-data-fields := ($INSERTS-PER-SECOND-FIELD-NAME,$DURATION-FIELD-NAME,$PAYLOAD-FIELD-NAME);
declare variable $environment-fields := ($HOST-COUNT-FIELD-NAME,$HOST-TYPE-FIELD-NAME,$FILE-SYSTEM-FORMAT-FIELD-NAME,$DISK-TYPE-FIELD-NAME,$DATA-DIRECTORY-FIELD-NAME);
declare variable $read-only-fields := ($HOST-COUNT-FIELD-NAME);
declare variable $other-fields := ($FOREST-DIRECTORY-FIELD-NAME);

declare variable $singleton-fields := ($THREAD-COUNT-FIELD-NAME,$HOST-COUNT-FIELD-NAME,$HOST-TYPE-FIELD-NAME,$FILE-SYSTEM-FORMAT-FIELD-NAME,
    $DISK-TYPE-FIELD-NAME,$INSERTS-PER-SECOND-FIELD-NAME,$DURATION-FIELD-NAME,$PAYLOAD-FIELD-NAME,$RUN-LABEL-FIELD-NAME,$RUN-MODE-FIELD-NAME,$DATA-DIRECTORY-FIELD-NAME);
declare variable $integer-fields := ($FOREST-COUNT-FIELD-NAME,$BATCH-SIZE-FIELD-NAME,$IO-LIMIT-FIELD-NAME,$MERGE-RATIO-FIELD-NAME,$TREE-SIZE-FIELD-NAME,
    $THREAD-COUNT-FIELD-NAME,$HOST-COUNT-FIELD-NAME,$INSERTS-PER-SECOND-FIELD-NAME,$DURATION-FIELD-NAME,$PAYLOAD-FIELD-NAME);
declare variable $boolean-fields := ($FAST-INSERT-VALUE-FIELD-NAME);     

(: Environment Values :)
declare variable $HOST-TYPE := "Add your host type e.g. EliteBook 8460w";
declare variable $HOST-COUNT := fn:count(xdmp:hosts());
declare variable $FILE-SYSTEM-FORMAT := "Add your file system e.g. NTFS";
declare variable $DISK-TYPE := "Add your disk type e.g SATA2-7200RPM"; 

(: The source for generating text documents :)
declare variable $SOURCE-DOCUMENT := "/on-liberty.txt";
  
(: Server Variable names relating to document insertion :)
declare variable $SOURCE-DOCUMENT-WORDS-SERVER-VARIABLE := "source-words";
declare variable $SOURCE-DOCUMENT-WORD-COUNT-SERVER-VARIABLE := "source-words-count";
declare variable $SOURCE-DOCUMENT-LENGTH-SERVER-VARIABLE := "source-words-doc-length";

(: Field names used for specifying jobs :)
declare variable $FOREST-COUNT-FIELD-NAME := "forest-count";
declare variable $BATCH-SIZE-FIELD-NAME := "batch-size";
declare variable $IO-LIMIT-FIELD-NAME := "io-limit";
declare variable $TREE-SIZE-FIELD-NAME := "tree-size";
declare variable $MERGE-RATIO-FIELD-NAME := "merge-ratio";
declare variable $FAST-INSERT-VALUE-FIELD-NAME := "fast-insert-value";
declare variable $THREAD-COUNT-FIELD-NAME := "thread-count";
declare variable $HOST-COUNT-FIELD-NAME := "host-count";
declare variable $HOST-TYPE-FIELD-NAME := "host-type";
declare variable $FILE-SYSTEM-FORMAT-FIELD-NAME := "file-system-format";
declare variable $DISK-TYPE-FIELD-NAME := "disk-type";
declare variable $INSERTS-PER-SECOND-FIELD-NAME := "inserts-per-second";
declare variable $DURATION-FIELD-NAME := "duration";
declare variable $PAYLOAD-FIELD-NAME := "payload"; 
declare variable $RUN-LABEL-FIELD-NAME := "run-label";
declare variable $RUN-MODE-FIELD-NAME := "run-mode";
declare variable $FOREST-DIRECTORY-FIELD-NAME := "forest-directory";
declare variable $DATA-DIRECTORY-FIELD-NAME := "data-directory";
declare variable $EXPECTED-FRAGMENT-COUNT-FIELD-NAME := "expected-fragment-count";

(: Page related field names and values :)
declare variable $MODE-FIELD-NAME := "mode";
declare variable $JOB-ID-FIELD-NAME := "job-id";
declare variable $CREATE-MODE := "create";
declare variable $DELETE-MODE := "delete";
declare variable $NAME-FIELD-NAME := "name";
declare variable $VALUE-FIELD-NAME := "value";
declare variable $PERMUTED-PREFIX := "permuted";
declare variable $DIRECTORY-FIELD-NAME := "directory";
declare variable $FILENAME-FIELD-NAME := "filename";

(: Defaults :)
declare variable $DEFAULT-BACKGROUND-IO-LIMIT := 0;
declare variable $DEFAULT-FOREST-COUNT := fn:count(xdmp:hosts());
declare variable $DEFAULT-BATCH-SIZE := 1;
declare variable $DEFAULT-FAST-INSERT-VALUE := "TRUE";
declare variable $DEFAULT-THREAD-COUNT := 16;
declare variable $DEFAULT-RUN-MODE := $GENERATE-AND-SAVE-MODE;
declare variable $run-label := "unnamed-test";
declare variable $inserts-per-second  := 10;
declare variable $duration := 10;
declare variable $payload  :=  10000;
declare variable $DEFAULT-FOREST-DIRECTORY := "";

(: Names of databases, key files, directories :)
declare variable $RECORDS-DB-NAME := "io-test-content";
declare variable $DATA-DB-NAME := "Sample";
declare variable $SAMPLE-CONTENT-URI-PREFIX := "/sample-content/";
declare variable $DEFAULT-VALUES-DOCUMENT := "/io-test/default-values.xml";
declare variable $RUN-CONFIG-DOCUMENT := "/io-test/run-config.xml";
declare variable $BATCH-CONFIG-DOCUMENT := "/io-test/batch-config.xml";

(: Miscellaneous :)
declare variable $RUN-JOB-TASK := "/app/ui/job/run-job.xqy";
declare variable $GENERATE-AND-SAVE-MODE := "generate-and-save";
declare variable $LOAD-FROM-DISK-MODE := "load-from-disk";
declare variable $RECORDS-DB-EVAL-OPTIONS := 
<options xmlns="xdmp:eval">
    <database>{xdmp:database($RECORDS-DB-NAME)}</database>
  </options>;
declare variable $CONTENT-DB-EVAL-OPTIONS := 
<options xmlns="xdmp:eval">
    <database>{xdmp:database($DATA-DB-NAME)}</database>
  </options>;
  
