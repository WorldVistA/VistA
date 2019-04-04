ZZLEXXCH ;SLC/KER - Import - Conflicts - Help ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^ZZLEXX("ZZLEXXCH"  SACC 1.3
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
 Q
HELP ; Main Entry Point
 N %,%ZIS,BOLD,CNT,ENV,EXEC,I,IOINHI,IOINORM,IOP,LEXCONT,LEXCT,LEXEOP,LEXI,LEXLC,NM,NORM,POP,RTN,SUB,TAG
 N TXT,ZTDESC,ZTDTH,ZTIO,ZTQUEUED,ZTREQ,ZTRTN,ZTSAVE,ZTSK S TAG="SEX",ENV=$$ENV Q:ENV'>0
 Q:'$L($T(@(TAG_"^ZZLEXXCH")))  K ^ZZLEXX("ZZLEXXCH",$J) D GET(TAG)
 I '$D(^ZZLEXX("ZZLEXXCH",$J)) W !!," No help text found",! K ^ZZLEXX("ZZLEXXCH",$J) Q
 D DSP
 Q
GET(X) ; Get Help Text
 N TAG,RTN,BOLD,NORM,CNT,TXT,SUB,I  S TAG=$G(X) Q:'$L(TAG)  Q:'$L($T(@(TAG_"^ZZLEXXCH")))
 S SUB=$$SUB Q:'$L(SUB)  S RTN=$E(SUB,1,($L(SUB)-1)) Q:'$L(RTN)  D ATTR
 K ^ZZLEXX("ZZLEXXCH",$J) S CNT=0,TXT=""  F I=1:1 D  Q:'$L(TXT)
 . N EXEC S TXT="" S EXEC="S TXT=$T("_TAG_"+"_I_"^"_RTN_")" X EXEC
 . S TXT=$P(TXT,";;",2,299) Q:TXT=""  Q:$TR(TXT,";","")=""
 . I TXT["~" F  Q:TXT'["~"  S TXT=$P(TXT,"~",1)_$G(BOLD)_$P(TXT,"~",2,299)
 . I TXT["|" F  Q:TXT'["|"  S TXT=$P(TXT,"|",1)_$G(NORM)_$P(TXT,"|",2,299)
 . S CNT=CNT+1 S ^ZZLEXX("ZZLEXXCH",$J,CNT)=(" "_TXT)
 D KATTR
 D:$D(SHOW) SHOW K SHOW
 Q
 ; 
DSP(X) ; Display ^ZZLEXX(X,$J)
 N %,%ZIS,IOP,ZTRTN,ZTSAVE,ZTDESC,ZTDTH,ZTIO,ZTSK,ZTQUEUED,ZTREQ
 S ZTRTN="DSPI^ZZLEXXCH",ZTDESC="Display/Print Help"
 S ZTIO=ION,ZTDTH=$H,%ZIS="PQ",ZTSAVE("^ZZLEXX(""ZZLEXXCH"",$J,")=""
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
 N DONE S DONE=0 W:$L($G(IOF)) @IOF
 I '$D(ZTQUEUED),$G(IOST)'["P-" I '$D(^ZZLEXX("ZZLEXXCH",$J)) W !,"Text not Found"
 U:IOST["P-" IO G:'$D(^ZZLEXX("ZZLEXXCH",$J)) DSPQ N LEXCONT,LEXI,LEXLC,LEXEOP,LEXCT S LEXCT=0
 S LEXCONT="",(LEXLC,LEXI)=0,LEXEOP=+($G(IOSL)) S:LEXEOP=0 LEXEOP=24
 F  S LEXI=$O(^ZZLEXX("ZZLEXXCH",$J,LEXI)) Q:+LEXI=0!(LEXCONT["^")  D
 . W !,^ZZLEXX("ZZLEXXCH",$J,LEXI) S LEXCT=0 D LF
 . S:$O(^ZZLEXX("ZZLEXXCH",$J,LEXI))'>0 DONE=1  Q:LEXCONT["^"
 S:$D(ZTQUEUED) ZTREQ="@" D:'LEXCT CONT K ^ZZLEXX("ZZLEXXCH",$J) W:$G(IOST)["P-" @IOF
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
SHOW ;   Show ^ZZLEXXC Global
 N I,SUB S SUB=$$SUB Q:'$L(SUB)  S I=0 F  S I=$O(^ZZLEXX("ZZLEXXCH",$J,I)) Q:+I'>0  D
 . W !,$G(^ZZLEXX("ZZLEXXCH",$J,I))
 Q
ATTR ;   Screen Attributes
 N X,%,IOINHI,IOINORM S X="IOINHI;IOINORM" D ENDR^%ZISS S BOLD=$G(IOINHI),NORM=$G(IOINORM) Q
KATTR ;   Kill Screen Attributes
 D KILL^%ZISS K BOLD,NORM Q
SUB(X) ;   Subscript
 S X=$$LR_"T"
 Q X
KILL ;   Kill Global
 K ^ZZLEXX("ZZLEXXC",$J),^ZZLEXX("ZZLEXXCM",$J),^ZZLEXX("ZZLEXXCH",$J)
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
SEX ;   Sex Conflict
 ;;~1) Retrieve the data file:|
 ;;    
 ;;   Open the Center for Medicare/Medicaid Services (CMS) Web Site
 ;;   
 ;;        ~https://www.cms.gov/Medicare/Medicare.html|
 ;;    
 ;;   Under the heading "Medicare Fee-for-Service Payment" click on ~Acute|
 ;;   ~Inpatient PPS|
 ;;   
 ;;   On the left, click on ~IPPS Final Rule HomePage| for the fiscal year needed.
 ;;   
 ;;   On the right, click on ~Final Rule Data Files| for the fiscal year needed.
 ;;   
 ;;   Click on file ~Definition of Medicare Code Edits| (zip file) and open the
 ;;   file (note, the version number will change from year to year)
 ;;   
 ;;   Right click on ~Definitions of Medicare Code Edits_vnn.txt| and select
 ;;   Open.  Once opened, save it to the local machine.  (Note, the version  
 ;;   number will change).  Close the file.
 ;;  
 ;;~2) Move the Data File:|
 ;;    
 ;;   SFTP the file ~Definitions of Medicare Code Edits_vnn.txt| from the
 ;;   local machine to the export directory:
 ;;  
 ;;       Salt Lake:   VA5$:[BETA]
 ;;       Bay Pines:   /home/sftp/patches/
 ;;       
 ;;~3) Read and Test the Data File:|
 ;;   
 ;;   Using the import utility:
 ;;   
 ;;       Select menu option ~Conflicts|
 ;;       Select menu option ~Load Conflicts|
 ;;        
 ;;   When prompted for the file name make sure to select the host file for
 ;;   the fiscal year needed.
 ;;   
 ;;       Select the import host file:
 ;;       
 ;;         ~Definitions of Medicare Code Edits_vnn.txt|
 ;;         
 ;;       (note, the version number will change from year to year)
 ;;   
 ;;   When prompted for the effective date, make sure the date is correct for
 ;;   the quarter and fiscal year being loaded.
 ;;   
 ;;   It is recommended that "logging" be turned on to capture changes found.
 ;;   
 ;;   When prompted for "Test load the data" respond "~YES|."  
 ;;    
 ;;       Data changes will be displayed if there are any.
 ;;   
 ;;~4) Read and Load the Data File:|
 ;;   
 ;;   Using the import utility:
 ;;   
 ;;       Select menu option ~Conflicts|
 ;;       Select menu option ~Load Conflicts|
 ;;  
 ;;   When prompted for the file name make sure to select the host file for
 ;;   the fiscal year needed.
 ;;   
 ;;       Select the import host file:
 ;;       
 ;;         ~Definitions of Medicare Code Edits_vnn.txt|
 ;;         
 ;;       (note, the version number will change from year to year)
 ;;        
 ;;   When prompted for the effective date, make sure the date is correct for
 ;;   the quarter and fiscal year being loaded.
 ;;   
 ;;   When prompted for "Test load the data" respond "~NO|"
 ;;    
 ;;   When prompted for "Update the ICD Diagnosis/Procedure files:" respond "~YES|."
 ;;     
 ;;~5) (Optional) Test the Load Again:|
 ;;   
 ;;   Repeat ~Step 3|, Read and Test the Data File.  If the load was successful, 
 ;;   repeating Step 3 should result in no changes found.
 ;;   
 ;;;;;;
