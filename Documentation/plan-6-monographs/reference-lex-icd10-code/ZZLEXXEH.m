ZZLEXXEH ;SLC/KER - Import - ICD-10-PCS Frag - Help ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^ZZLEXX(           SACC 1.3
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
 N %,%ZIS,BOLD,CNT,ENV,EX,EXEC,I,IOINHI,IOINORM,IOP,LEXCONT,LEXCT,LEXEOP,LEXI,LEXLC,LEXSID,NM,NORM,POP,RTN
 N TAG,TXT,X,ZTDESC,ZTDTH,ZTIO,ZTQUEUED,ZTREQ,ZTRTN,ZTSAVE,ZTSK S ENV=$$ENV Q:ENV'>0
 K ^ZZLEXX("ZZLEXXEH",$J) D GET I '$D(^ZZLEXX("ZZLEXXEH",$J)) W !!," No help text found",! K ^ZZLEXX("ZZLEXXEH",$J) Q
 D DSP("ZZLEXXE")
 Q
GET ; Get Help Text
 N EX,TAG,RTN,BOLD,NORM,CNT,TXT,I  S TAG="HT",RTN="ZZLEXXEH"  D ATTR
 K ^ZZLEXX("ZZLEXXEH",$J) S CNT=0,TXT=""  F I=1:1 D  Q:'$L(TXT)
 . N EXEC S TXT="" S EXEC="S TXT=$T("_TAG_"+"_I_"^"_RTN_")" X EXEC
 . S TXT=$P(TXT,";;",2,299) Q:TXT=""  Q:$TR(TXT,";","")=""
 . I TXT["~" F  Q:TXT'["~"  S TXT=$P(TXT,"~",1)_$G(BOLD)_$P(TXT,"~",2,299)
 . I TXT["|" F  Q:TXT'["|"  S TXT=$P(TXT,"|",1)_$G(NORM)_$P(TXT,"|",2,299)
 . S CNT=CNT+1 S ^ZZLEXX("ZZLEXXEH",$J,CNT)=(" "_TXT)
 D KATTR
 D:$D(SHOW) SHOW K SHOW
 Q
 ; 
DSP(X) ; Display ^ZZLEXXE
 N LEXSID S LEXSID=$G(X) Q:'$L(LEXSID)  D DEV
 Q
DEV ;   Select a device
 N %,%ZIS,IOP,ZTRTN,ZTSAVE,ZTDESC,ZTDTH,ZTIO,ZTSK,ZTQUEUED,ZTREQ
 S ZTRTN="DSPI^ZZLEXXEH",ZTDESC="Display/Print Help"
 S ZTIO=ION,ZTDTH=$H,%ZIS="PQ",ZTSAVE(("^ZZLEXX(""ZZLEXXE"","))="",ZTSAVE("LEXSID")=""
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
 W:$L($G(IOF)) @IOF S LEXSID=$G(LEXSID) Q:'$L(LEXSID)
 I '$D(ZTQUEUED),$G(IOST)'["P-" I '$D(^ZZLEXX("ZZLEXXEH",$J)) W !,"Text not Found"
 U:IOST["P-" IO G:'$D(^ZZLEXX("ZZLEXXEH",$J)) DSPQ N EX,LEXCONT,LEXI,LEXLC,LEXEOP,LEXCT S LEXCT=0
 S LEXCONT="",(LEXLC,LEXI)=0,LEXEOP=+($G(IOSL)) S:LEXEOP=0 LEXEOP=24
 F  S LEXI=$O(^ZZLEXX("ZZLEXXEH",$J,LEXI)) Q:+LEXI=0!(LEXCONT["^")  D
 . W !,^ZZLEXX("ZZLEXXEH",$J,LEXI) S LEXCT=0 D LF Q:LEXCONT["^"
 S:$D(ZTQUEUED) ZTREQ="@" D:'LEXCT CONT K ^ZZLEXX("ZZLEXXEH",$J) W:$G(IOST)["P-" @IOF
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
SHOW ;   Show ^ZZLEXXE Global
 N I S I=0 F  S I=$O(^ZZLEXX("ZZLEXXEH",$J,I)) Q:+I'>0  W !,$G(^ZZLEXX("ZZLEXXEH",$J,I))
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
HT ;   ICD-10-PCS Code Fragment
 ;;~1) Retrieve the Data File:|
 ;;    
 ;;   Open the Center for Medicare/Medicaid Services (CMS) Web Site
 ;;   
 ;;        ~https://www.cms.gov/Medicare/Medicare.html|
 ;;   
 ;;   Under the heading "Coding" click on ~ICD-10|
 ;;   
 ;;   On the left, click on ~ICD-10-PCS and GEMs| for the fiscal
 ;;   year
 ;;   
 ;;   On the right, click on ~ICD-10-PCS Code Tables and Index|
 ;;   (zip file) for the fiscal year and open the file.
 ;;   
 ;;   Save the following XML files to your machine (yyyy is the 
 ;;   fiscal year):
 ;;  
 ;;      ~icd10pcs_definitions_yyyy.xml|
 ;;      ~icd10pcs_tables_yyyy.xml|
 ;;   
 ;;   Rename XML files to TXT files:
 ;;  
 ;;       From:  icd10pcs_definitions_yyyy.~xml|
 ;;       To:    icd10pcs_definitions_yyyy.~txt|
 ;;        
 ;;       From:  icd10pcs_tables_yyyy.~xml|
 ;;       To:    icd10pcs_tables_yyyy.~txt|
 ;;   
 ;;~2) Move the Data Files:|
 ;;    
 ;;   SFTP the following two files:
 ;;   
 ;;       ~icd10pcs_definitions_yyyy.txt|
 ;;       ~icd10pcs_tables_yyyy.txt|
 ;;       
 ;;   From your machine to the export directory:
 ;;  
 ;;       Salt Lake:   VA5$:[BETA]
 ;;       Bay Pines:   /home/sftp/patches/
 ;;   
 ;;~3) Initialize the Lexicon Temporary Global:|
 ;;  
 ;;   If this is the first time for the load for the fiscal year then:
 ;;   
 ;;       Select menu option ~Fragments|
 ;;       Select menu option ~Load ICD-10-PCS Fragments|
 ;;       Select menu option ~Initialize Lexicon Temporary Global|
 ;;   
 ;;~4) Read the Data File:|
 ;;   
 ;;   Read the data in the host file into a Lexicon temporary global
 ;;   
 ;;       Select menu option ~Fragments|
 ;;       Select menu option ~Load ICD-10-PCS Fragments|
 ;;       Select menu option menu option ~Read Data File|
 ;;       
 ;;   Select the Host file type:
 ;;   
 ;;       ICD-10-PCS Tabular File
 ;;       ICD-10-PCS Definition File
 ;;    
 ;;       NOTE:  To complete the read, both the tabular file and definition
 ;;              file must be read.
 ;;              
 ;;    Select the import host file;
 ;;    
 ;;       To read the Tabular file:       ~icd10pcs_definitions_yyyy.txt|
 ;;       To read the Definition file:    ~icd10pcs_tables_yyyy.txt|
 ;;   
 ;;~5) Calculate the Changes:|
 ;;   
 ;;   Compare the data read into the Lexicon temporary global to the
 ;;   data on file in the Character Position file #757.033 and record
 ;;   the changes.
 ;;   
 ;;       Select menu option ~Fragments|
 ;;       Select menu option ~Load ICD-10-PCS Fragments|
 ;;       Select menu option ~Compare and Record Changes|
 ;;       
 ;;~6) Display Changes, Errors and Warnings|
 ;;   
 ;;   You may display and inspect the changes before loading them into
 ;;   the Character Position file #757.03.
 ;;   
 ;;   If there are errors and warnings found, then you must display, 
 ;;   inspect and fix the errors and warnings in the host file.  After
 ;;   the errors are fixed, then initiate the Lexicon temporary global,
 ;;   re-read the host file, re-calculate the changes.  If the errors
 ;;   are fixed them proceed to load the changes into the Character
 ;;   Position file #757.03.
 ;;   
 ;;       Select menu option ~Fragments|
 ;;       Select menu option ~Load ICD-10-PCS Fragments|
 ;;       Select menu option ~Display Changes/Warnings/Progress|
 ;;       
 ;;~7) Load the Data|
 ;;   
 ;;   Load the changes saved in the Lexicon Temporary global into the
 ;;   Character Positions file #757.033.
 ;;   
 ;;       Select menu option ~Fragments|
 ;;       Select menu option ~Load ICD-10-PCS Fragments|
 ;;       Select menu option ~Load Changes to 757.033|
 ;;       
 ;;~8) (Optional) Test the Load:|
 ;;   
 ;;   Repeating Steps 4, 5, and 6 (Read, Calculate and Display).  If the load
 ;;   was successful, repeating these steps should result in no changes found.
 ;;   
 ;;;;;;
