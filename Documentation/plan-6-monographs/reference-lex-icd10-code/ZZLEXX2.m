ZZLEXX2 ;SLC/KER - Import - ICD-10 - Help ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^ZZLEXX("ZZLEXX2"   SACC 1.3
 ;               
 ; External References
 ;    ^%ZIS               ICR  10086
 ;    HOME^%ZIS           ICR  10086
 ;    ^%ZISC              ICR  10089
 ;    ENDR^%ZISS          ICR  10088
 ;    KILL^%ZISS          ICR  10088
 ;    ^%ZTLOAD            ICR  10063
 ;    $$GET1^DIQ          ICR   2056
 ;    $$DT^XLFDT          ICR  10103
 ;               
HELP ; Main Entry Point
 N %,%ZIS,BOLD,CNT,ENV,EXEC,I,IOINHI,IOINORM,IOP,LEXCONT,LEXCT,LEXEOP,LEXI,LEXLC,NM,NORM,POP,RTN
 N TAG,TXT,X,ZTDESC,ZTDTH,ZTIO,ZTQUEUED,ZTREQ,ZTRTN,ZTSAVE,ZTSK S ENV=$$ENV Q:ENV'>0
 K ^ZZLEXX("ZZLEXX2",$J) D GET I '$D(^ZZLEXX("ZZLEXX2",$J)) W !!," No help text found",! K ^ZZLEXX("ZZLEXX2",$J) Q
 D DSP
 Q
GET ; Get Help Text
 N TAG,RTN,BOLD,NORM,CNT,TXT,I  S TAG="HT",RTN="ZZLEXX2" D ATTR
 K ^ZZLEXX("ZZLEXX2",$J) S CNT=0,TXT=""  F I=1:1 D  Q:'$L(TXT)
 . N EXEC S TXT="" S EXEC="S TXT=$T("_TAG_"+"_I_"^"_RTN_")" X EXEC
 . S TXT=$P(TXT,";;",2,299) Q:TXT=""  Q:$TR(TXT,";","")=""
 . I TXT["~" F  Q:TXT'["~"  S TXT=$P(TXT,"~",1)_$G(BOLD)_$P(TXT,"~",2,299)
 . I TXT["|" F  Q:TXT'["|"  S TXT=$P(TXT,"|",1)_$G(NORM)_$P(TXT,"|",2,299)
 . S CNT=CNT+1 S ^ZZLEXX("ZZLEXX2",$J,CNT)=(" "_TXT)
 D KATTR
 D:$D(SHOW) SHOW K SHOW
 Q
 ; 
DSP ; Display ^ZZLEXX("ZZLEXX2",$J)
 N %,%ZIS,IOP,ZTRTN,ZTSAVE,ZTDESC,ZTDTH,ZTIO,ZTSK,ZTQUEUED,ZTREQ
 S ZTRTN="DSPI^ZZLEXX2",ZTDESC="Display/Print Help"
 S ZTIO=ION,ZTDTH=$H,%ZIS="PQ",ZTSAVE("^ZZLEXX(""ZZLEXX2"",$J,")=""
 S %ZIS("A")="   Device:  " W !!," Display Help",! D ^%ZIS
 K %ZIS Q:POP  S ZTIO=ION I $D(IO("Q")) D QUE,^%ZISC Q
 D NOQUE
 Q
NOQUE ;   Do not que task
 W @IOF W:IOST["P-" !,"< Not queued, printing Help >",! U:IOST["P-" IO D @ZTRTN,^%ZISC
 Q
QUE ;   Task queued 
 K IO("Q") D ^%ZTLOAD W !,$S($D(ZTSK):"Request Queued",1:"Request Cancelled"),! H 2 Q
 Q
DSPI ;   Display Code Lookup
 W:$L($G(IOF)) @IOF I '$D(ZTQUEUED),$G(IOST)'["P-" I '$D(^ZZLEXX("ZZLEXX2",$J)) W !,"Text not Found"
 U:IOST["P-" IO G:'$D(^ZZLEXX("ZZLEXX2",$J)) DSPQ N LEXCONT,LEXI,LEXLC,LEXEOP,LEXCT S LEXCT=0
 S LEXCONT="",(LEXLC,LEXI)=0,LEXEOP=+($G(IOSL)) S:LEXEOP=0 LEXEOP=24
 F  S LEXI=$O(^ZZLEXX("ZZLEXX2",$J,LEXI)) Q:+LEXI=0!(LEXCONT["^")  D
 . W !,^ZZLEXX("ZZLEXX2",$J,LEXI) S LEXCT=0 D LF Q:LEXCONT["^"
 S:$D(ZTQUEUED) ZTREQ="@" D:'LEXCT CONT K ^ZZLEXX("ZZLEXX2",$J) W:$G(IOST)["P-" @IOF
DSPQ ;   Quit Display
 Q
LF ;   Line Feed
 S LEXLC=LEXLC+1 D:IOST["P-"&(LEXLC>(LEXEOP-7)) CONT D:IOST'["P-"&(LEXLC>(LEXEOP-4)) CONT
 Q
CONT ;   Page/Form Feed
 S LEXCT=1 S LEXLC=0 W:IOST["P-" @IOF Q:IOST["P-"
 W !!,"  Press <Return> to continue  " R LEXCONT:300 W:$L($G(IOF)) @IOF S:'$T LEXCONT="^"
 S:LEXCONT["^" LEXCONT="^" S:LEXCONT'["^" LEXCONT=""
 Q
 ; 
 ; Miscellaneous
SHOW ;   Show ^ZZLEXX Global
 N I S I=0 F  S I=$O(^ZZLEXX("ZZLEXX2",$J,I)) Q:+I'>0  D
 . W !,$G(^ZZLEXX("ZZLEXX2",$J,I))
 Q
ATTR ;   Screen Attributes
 N X,%,IOINHI,IOINORM S X="IOINHI;IOINORM" D ENDR^%ZISS S BOLD=$G(IOINHI),NORM=$G(IOINORM) Q
KATTR ;   Kill Screen Attributes
 D KILL^%ZISS K BOLD,NORM Q
LR(X) ;   Local Routine
 S X=$T(+1),X=$P(X," ",1) Q X
ENV(X) ;   Environment
 D HOME^%ZIS S U="^",DT=$$DT^XLFDT,DTIME=300 K POP
 N NM S NM=$$GET1^DIQ(200,(DUZ_","),.01)
 I '$L(NM) W !!,?5,"Invalid/Missing DUZ" Q 0
 S:$G(DUZ(0))'["@" DUZ(0)=$G(DUZ(0))_"@"
 Q 1
 ;
 ; Help Text
HT ;   ICD-10-CM Diagnosis Terminology
 ;;Sequence of events:
 ;;  
 ;;  1) Retrieve the Data Files:
 ;;    
 ;;     Open the Center for Medicare/Medicaid Services (CMS) Web Site
 ;;   
 ;;          ~https://www.cms.gov/Medicare/Medicare.html|
 ;;   
 ;;     Under the heading "Coding" click on "ICD-10"
 ;;   
 ;;        Click on "ICD-10-CM and GEMs" for the fiscal year needed.  Save and
 ;;        unzip the file ~Code Descriptions in Tabular Order| on your local 
 ;;        machine.
 ;;  
 ;;        Click on "ICD-10-PCS and GEMs" for the fiscal year needed.  Save and
 ;;        unzip the files ~ICD-10-PCS Order File (Long and Abbreviated Titles)|
 ;;        and ~ICD-10-PCS Code Tables and Index| on your local machine.
 ;;   
 ;;  2) Copy and Rename XML files:
 ;;   
 ;;     Make copies of the following two XML files:
 ;;     
 ;;          ~icd10pcs_definitions_yyyy.xml|
 ;;          ~icd10pcs_tables_yyyy.xml|
 ;;          
 ;;     Rename the copied XML files as .txt files:
 ;;     
 ;;           From:  icd10pcs_definitions_yyyy~ - Copy.xml|
 ;;           To:    icd10pcs_definitions_yyyy.~txt|
 ;;           
 ;;           From:  icd10pcs_tables_yyyy~ - Copy.~xml|
 ;;           To:    icd10pcs_tables_yyyy.~txt|
 ;;  
 ;;  3) Make sure the following files are moved to the export directory:
 ;;    
 ;;       Required
 ;;       
 ;;           ~icd10cm_order_yyyy.txt|
 ;;           ~icd10pcs_order_yyyy.txt|
 ;;           ~icd10pcs_tables_yyyy.txt|
 ;;           ~icd10pcs_definitions_yyyy.txt|
 ;;           
 ;;       Optional
 ;;       
 ;;           icd10cm_order_addenda_yyyy.txt 
 ;;           icd10pcs_order_addenda_yyyy.txt
 ;;     
 ;;     SFTP these files from your local machine to the export directory:
 ;;  
 ;;       Salt Lake:   VA5$:[BETA]
 ;;       Bay Pines:   /home/sftp/patches/
 ;;  
 ;;  4) Load the ICD-10 Terminology:
 ;;   
 ;;     ICD-10-CM Diagnosis:
 ;;     
 ;;       Using the import utility:
 ;;   
 ;;         Select menu option      "Terminology"
 ;;         Then select             "Diagnosis"
 ;;         Then select             "Load ICD-10-CM Diagnosis"
 ;;        
 ;;     ICD-10-PCS Procedures:
 ;;     
 ;;       Using the import utility:
 ;;   
 ;;         Select menu option      "Terminology"
 ;;         Then select             "Procedures"
 ;;         Then select             "Load ICD-10-PCS Procedures"
 ;;  
 ;;  5) Load the ICD-10-CM Categories:
 ;;   
 ;;     Using the import utility:
 ;;     
 ;;         Select menu option      "Fragments and Categories"
 ;;         Then select             "Categories"
 ;;         Then select             "Load ICD-10-CM Categories"
 ;;         Then select             "Read Data File"
 ;;         Then select             "Compare and Record Changes"
 ;;         Then select             "Load Changes to 757.033"
 ;;  
 ;;  6) Load the ICD-10-PCS Code Fragments:
 ;;   
 ;;     Using the import utility:
 ;;     
 ;;         Select menu option      "Fragments and Categories"
 ;;         Then select             "Fragments"
 ;;         Then select             "Load ICD-10-PCS Code Fragments"
 ;;         Then select             "Read Data Files"
 ;;         Then select             "ICD-10-PCS Tabular File"
 ;;         Then select             "ICD-10-PCS Definition File"
 ;;         Then select             "Compare and Record Changes"
 ;;         Then select             "Load Changes to 757.033"
 ;;       
 ;;  7) Verify the Load
 ;;   
 ;;     Using the import utility:
 ;;     
 ;;         Select menu option      "Verify ICD Load Files"
 ;;     
 ;;     After about 6-12 minutes you will receive two email messages:
 ;;     
 ;;       ICD-10 Relationship Verify
 ;;       ICD-10 FileMan Verify
 ;;       
 ;;     These verification utilities look at ICD files 80 and 80.1 and
 ;;     the Lexicon files 757, 757.001, 757.01, 757.02, 757.033 and 757.1.
 ;;     For the Lexicon files, only the entries that are linked to an
 ;;     ICD code will be verified.  Do not use this utility to verify 
 ;;     any other coding system (i.e. CPT, HCPCS, DSM, etc.).
 ;;     
 ;;     Note:  Verifying the ICD files can be done at any time during
 ;;            the data load process.
 ;;  
 ;;;;;;
