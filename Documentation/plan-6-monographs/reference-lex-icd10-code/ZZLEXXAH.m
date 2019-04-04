ZZLEXXAH ;SLC/KER - Import - ICD-10-CM - Help ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^ZZLEXX("ZZLEXXAH"  SACC 1.3
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
 K ^ZZLEXX("ZZLEXXAH",$J) D GET I '$D(^ZZLEXX("ZZLEXXAH",$J)) W !!," No help text found",! K ^ZZLEXX("ZZLEXXAH",$J) Q
 D DSP
 Q
GET ; Get Help Text
 N TAG,RTN,BOLD,NORM,CNT,TXT,I  S TAG="HT",RTN="ZZLEXXAH" D ATTR
 K ^ZZLEXX("ZZLEXXAH",$J) S CNT=0,TXT=""  F I=1:1 D  Q:'$L(TXT)
 . N EXEC S TXT="" S EXEC="S TXT=$T("_TAG_"+"_I_"^"_RTN_")" X EXEC
 . S TXT=$P(TXT,";;",2,299) Q:TXT=""  Q:$TR(TXT,";","")=""
 . I TXT["~" F  Q:TXT'["~"  S TXT=$P(TXT,"~",1)_$G(BOLD)_$P(TXT,"~",2,299)
 . I TXT["|" F  Q:TXT'["|"  S TXT=$P(TXT,"|",1)_$G(NORM)_$P(TXT,"|",2,299)
 . S CNT=CNT+1 S ^ZZLEXX("ZZLEXXAH",$J,CNT)=(" "_TXT)
 D KATTR
 D:$D(SHOW) SHOW K SHOW
 Q
 ; 
DSP ; Display ^ZZLEXX("ZZLEXXAH",$J)
 N %,%ZIS,IOP,ZTRTN,ZTSAVE,ZTDESC,ZTDTH,ZTIO,ZTSK,ZTQUEUED,ZTREQ
 S ZTRTN="DSPI^ZZLEXXAH",ZTDESC="Display/Print Help"
 S ZTIO=ION,ZTDTH=$H,%ZIS="PQ",ZTSAVE("^ZZLEXX(""ZZLEXXAH"",$J,")=""
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
 W:$L($G(IOF)) @IOF I '$D(ZTQUEUED),$G(IOST)'["P-" I '$D(^ZZLEXX("ZZLEXXAH",$J)) W !,"Text not Found"
 U:IOST["P-" IO G:'$D(^ZZLEXX("ZZLEXXAH",$J)) DSPQ N LEXCONT,LEXI,LEXLC,LEXEOP,LEXCT S LEXCT=0
 S LEXCONT="",(LEXLC,LEXI)=0,LEXEOP=+($G(IOSL)) S:LEXEOP=0 LEXEOP=24
 F  S LEXI=$O(^ZZLEXX("ZZLEXXAH",$J,LEXI)) Q:+LEXI=0!(LEXCONT["^")  D
 . W !,^ZZLEXX("ZZLEXXAH",$J,LEXI) S LEXCT=0 D LF Q:LEXCONT["^"
 S:$D(ZTQUEUED) ZTREQ="@" D:'LEXCT CONT K ^ZZLEXX("ZZLEXXAH",$J) W:$G(IOST)["P-" @IOF
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
SHOW ;   Show ^ZZLEXXA Global
 N I S I=0 F  S I=$O(^ZZLEXX("ZZLEXXAH",$J,I)) Q:+I'>0  D
 . W !,$G(^ZZLEXX("ZZLEXXAH",$J,I))
 Q
ATTR ;   Screen Attributes
 N X,%,IOINHI,IOINORM S X="IOINHI;IOINORM" D ENDR^%ZISS S BOLD=$G(IOINHI),NORM=$G(IOINORM) Q
KATTR ;   Kill Screen Attributes
 D KILL^%ZISS K BOLD,NORM Q
KILL ;   Kill Global
 D KILL^ZZLEXXAA
 Q
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
 ;;~1) Retrieve the Data File:|
 ;;    
 ;;   Open the Center for Medicare/Medicaid Services (CMS) Web Site
 ;;   
 ;;        ~https://www.cms.gov/Medicare/Medicare.html|
 ;;   
 ;;   Under the heading "Coding" click on ~ICD-10|
 ;;   
 ;;   On the left, click on ~ICD-10-CM and GEMs| for the fiscal year needed.
 ;;   
 ;;   On the right, click on ~Code Descriptions in Tabular Order| (zip file)
 ;;   and open the file.
 ;;   
 ;;   Click on file ~icd10cm_order_yyyy.txt| and open the file (yyyy is the 
 ;;   fiscal year needed).
 ;;   
 ;;   The icd10cm_order_yyyy.txt file will be in the following format:
 ;;     
 ;;      Character
 ;;      Positions    Length     Contents
 ;;        1-5           5       Order number, right justified, zero filled.
 ;;        6             1       Blank
 ;;        7-13          7       ICD-10-CM code. Decimal is not included.
 ;;        14            1       Blank
 ;;        15            1       0   if the code is a "header" - not valid for 
 ;;                                  HIPAA-covered transactions.  This is an
 ;;                                  ICD-10-CM Diagnostic Category.  It will
 ;;                                  be loaded into the Character Positions
 ;;                                  file #757.033.
 ;;                              1   if the code is valid for submission for 
 ;;                                  HIPAA-covered transactions.
 ;;        16            1       Blank
 ;;        17-76        60       Short description
 ;;        77            1       Blank
 ;;        78-end      245       Long description
 ;;   
 ;;   Save the file icd10cm_order_yyyy.txt on the local machine.
 ;;   
 ;;~2) Move the Data File:|
 ;;    
 ;;   SFTP the file icd10cm_order_yyyy.txt from the local machine to the export
 ;;   directory:
 ;;  
 ;;       Salt Lake:   VA5$:[BETA]
 ;;       Bay Pines:   /home/sftp/patches/
 ;;       
 ;;~3) Read and Test the Data File:|
 ;;   
 ;;   Using the import utility:
 ;;   
 ;;       Select menu option ~Diagnosis|
 ;;       Select menu option ~Load ICD-10-CM Diagnosis|
 ;;        
 ;;   When prompted for the file name make sure to select the host file for the
 ;;   fiscal year needed.
 ;;   
 ;;       Select the import host file ~icd10cm_order_yyyy.txt|
 ;;       (where yyyy is the fiscal year)
 ;;        
 ;;   When prompted for the effective date, make sure the date is correct for the
 ;;   quarter and fiscal year being loaded.
 ;;   
 ;;   It is recommended that "logging" be turned on to capture any errors found.
 ;;   
 ;;   When prompted for "Test load the data" respond "~YES|."  
 ;;    
 ;;       Data errors will be displayed if there are any.
 ;;       Data changes will be displayed if there are any.
 ;;   
 ;;   If there are errors, fix the errors in the host file and re-test before 
 ;;   continuing.
 ;;   
 ;;   If there are no errors, continue to step 4.
 ;;   
 ;;~4) Read and Load the Data File:|
 ;;   
 ;;   If the data is ok, and there is data to be loaded, using the import 
 ;;   utility:
 ;;   
 ;;       Select menu option Diagnosis
 ;;       Select menu option Load ICD-10-CM Diagnosis
 ;;  
 ;;   When prompted for the file name make sure to select the host file for the
 ;;   fiscal year needed.
 ;;   
 ;;       Select the import host file ~icd10cm_order_yyyy.txt|
 ;;       (where yyyy is the fiscal year)
 ;;       
 ;;   When prompted for the effective date, make sure the date is correct for the
 ;;   quarter and fiscal year being loaded.
 ;;    
 ;;   When prompted for "Test load the data" respond "~NO|"
 ;;    
 ;;   When prompted for "Update the ICD Diagnosis file:" respond "~YES|."
 ;;     
 ;;~5) (Optional) Test the Load:|
 ;;   
 ;;   Repeat ~Step 3|, Read and Test the Data File.  If the load was successful, 
 ;;   repeating Step 3 should result in no changes found.
 ;;   
 ;;;;;;
