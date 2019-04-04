ZZLEXXRR ;SLC/KER - Import - Rel Verify - Summary ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^ZZLEXX("ZZLEXXR")  SACC 1.3
 ;               
 ; External References
 ;    ^DIC                ICR  10063
 ;    $$GET1^DIQ          ICR   2056
 ;    $$FMDIFF^XLFDT      ICR  10103
 ;    $$FMTE^XLFDT        ICR  10103
 ;               
 Q
END(BEG,END,TIM,ERR,HDR) ; End FM Verify - Send Message
 ;
 ;  BEG       Begin Date and Time
 ;  END       End Date and Time
 ;  TIM       Time (elapsed)
 ;  ERR       Errors
 ;  HDR       Message Header
 ;          
 K ^ZZLEXX("ZZLEXXR",$J,"MAIN") S BEG=$G(BEG),END=$G(END),TIM=$G(TIM)
 S HDR=$G(HDR) S:'$L(HDR) HDR="ICD-10 Relationship Verify "
 S ERR=+($G(ERR))
 D BLM,TLM(HDR)
 S NS=$$LOC I $L($G(NS)) D BLM S TX="   Account Checked:    "_$G(NS) D TLM(TX)
 I +($G(ERR))>1000 D
 . D BLM,TLM("   WARNING:  Too many errors were found to send in a MailMan message.")
 . D TLM("             Please fix the problems identified in this message and ")
 . D TLM("             re-run FileMan Verify.")
 I +($G(ERR))'>0 D BLM,TLM("   No Errors to Report")
 I +($G(ERR))>0 S TX="   Total Errors Found:  "_+($G(ERR)) D BLM,TLM(TX)
 ;
 I $P($G(BEG),".",1)?7N,$P($G(END),".",1)?7N,'$L(TIM) S TIM=$$ELAP(BEG,END)
 I $P($G(BEG),".",1)?7N,$P($G(END),".",1)?7N,$L(TIM) D
 . S TX=$$STR($G(BEG)) D BLM,TLM(TX)
 . S TX=$$FIN($G(END)) D TLM(TX)
 . S TX=$$TIM($G(TIM)) D TLM(TX)
 Q
BUILD ; Report
 K ^ZZLEXX("ZZLEXXR",$J,"TEMP") N I,C S I=0 F  S I=$O(^ZZLEXX("ZZLEXXR",$J,"MAIN",I)) Q:+I'>0  D
 . N C S C=$O(^ZZLEXX("ZZLEXXR",$J,"TEMP"," "),-1)+1
 . S ^ZZLEXX("ZZLEXXR",$J,"TEMP",C)=$G(^ZZLEXX("ZZLEXXR",$J,"MAIN",I))
 S C=$O(^ZZLEXX("ZZLEXXR",$J,"TEMP"," "),-1)+1 S ^ZZLEXX("ZZLEXXR",$J,"TEMP",C)="   "
 S I=0 F  S I=$O(^ZZLEXX("ZZLEXXR",$J,"DRAFT",I)) Q:+I'>0  D
 . N C S C=$O(^ZZLEXX("ZZLEXXR",$J,"TEMP"," "),-1)+1
 . S ^ZZLEXX("ZZLEXXR",$J,"TEMP",C)=$G(^ZZLEXX("ZZLEXXR",$J,"DRAFT",I))
 S C=$O(^ZZLEXX("ZZLEXXR",$J,"TEMP"," "),-1)+1 S ^ZZLEXX("ZZLEXXR",$J,"TEMP",C)="   "
 K ^ZZLEXX("ZZLEXXR",$J,"DRAFT")
 S I=0 F  S I=$O(^ZZLEXX("ZZLEXXR",$J,"TEMP",I)) Q:+I'>0  D
 . N C S C=$O(^ZZLEXX("ZZLEXXR",$J,"DRAFT"," "),-1)+1
 . S ^ZZLEXX("ZZLEXXR",$J,"DRAFT",C)=$G(^ZZLEXX("ZZLEXXR",$J,"TEMP",I))
 K ^ZZLEXX("ZZLEXXR",$J,"TEMP"),^ZZLEXX("ZZLEXXR",$J,"MAIN")
 Q
SUM ; Summary
 N SUB F SUB="SUM","MAIN" D
 . N I,TX,NT,PT,CT I SUB="SUM",$O(^ZZLEXX("ZZLEXXR",$J,SUB,0))>0 D
 . . S TX="================================== FINDINGS ==================================="
 . . S TX=" --------------------------------- FINDINGS ------------------------------"
 . . S CT=$O(^ZZLEXX("ZZLEXXR",$J,"DRAFT"," "),-1)+1,^ZZLEXX("ZZLEXXR",$J,"DRAFT",CT)=""
 . . S CT=$O(^ZZLEXX("ZZLEXXR",$J,"DRAFT"," "),-1)+1,^ZZLEXX("ZZLEXXR",$J,"DRAFT",CT)=TX
 . . S CT=$O(^ZZLEXX("ZZLEXXR",$J,"DRAFT"," "),-1)+1,^ZZLEXX("ZZLEXXR",$J,"DRAFT",CT)=""
 . . ; ^ZZLEXX("ZZLEXXR",$J,"SUM"
 . S I=0 F  S I=$O(^ZZLEXX("ZZLEXXR",$J,SUB,I)) Q:+I'>0  D
 . . N CT,PT,NT S CT=$O(^ZZLEXX("ZZLEXXR",$J,"DRAFT"," "),-1)
 . . S PT=$G(^ZZLEXX("ZZLEXXR",$J,"DRAFT",CT)) S CT=CT+1
 . . S NT=$E($G(^ZZLEXX("ZZLEXXR",$J,SUB,I,0)),1,79)
 . . I CT>0,'$L($$TM(PT)),'$L($$TM(NT)) Q
 . . S ^ZZLEXX("ZZLEXXR",$J,"DRAFT",CT)=NT
 K ^ZZLEXX("ZZLEXXR",$J,"TEMP"),^ZZLEXX("ZZLEXXR",$J,"MAIN")
 Q
 ;
 ; Report Sections
TTL ;   Title
 N TTL,CT S TTL=$G(HDR) S:'$L(TTL) TTL="FileMan Field Verify "
 D BLM,TLM(TTL)
 Q
CHK ;   Checked
 N TX,NS S NS=$$LOC
 I +($G(FLC))>0!(+($G(FDC))>0)!($L(NS)) D BLM
 I $L($G(NS)) S TX="   Account Checked:    "_$G(NS) D TLM(TX)
 I +($G(FLC))>0 S TX="   Files Checked:      "_+($G(FLC)) D TLM(TX)
 I +($G(SFC))>0 S TX="   Sub-Files Checked:  "_+($G(SFC)) D TLM(TX)
 I +($G(FDC))>0 S TX="   Fields Checked:     "_+($G(FDC)) D TLM(TX)
 N FDC,FLC,SFC
 Q
BOD ;   Body of the Report
 N LN S LN=0 D:$O(^ZZLEXX("ZZLEXXR",$J,"TOT",0))>0 BLM F  S LN=$O(^ZZLEXX("ZZLEXXR",$J,"TOT",LN)) Q:+LN=0  D
 . N TX S TX=$G(^ZZLEXX("ZZLEXXR",$J,"TOT",LN)) D TLM(TX)
 Q
 ;                     
 ; Miscellaneous
STR(X) ;   Start
 N INP S INP=$G(X) Q:$P(INP,".",1)'?7N ""
 S X="   Start:              "_$TR($$FMTE^XLFDT($G(INP),"5Z"),"@"," ")
 Q X
FIN(X) ;   Finish
 N INP S INP=$G(X) Q:$P(INP,".",1)'?7N ""
 S X="   Finish:             "_$TR($$FMTE^XLFDT($G(INP),"5Z"),"@"," ")
 Q X
TIM(X) ;   Time
 N INP S INP=$G(X) Q:'$L(INP) ""
 I INP["day" S X="   Time:               "_$G(INP)
 I INP'["day" S X="   Time:                          "_$G(INP)
 Q X
BLM(T) ;   Blank Line in Message
 D TLM("  ") Q
TLM(X) ;   Text Line in Message
 N TXT,I S TXT=$G(X) S I=$O(^ZZLEXX("ZZLEXXR",$J,"MAIN"," "),-1)+1,^ZZLEXX("ZZLEXXR",$J,"MAIN",I)=TXT,^ZZLEXX("ZZLEXXR",$J,"MAIN",0)=I
 Q
NAM(X) ;   User Name
 Q $$GET1^DIQ(200,(+($G(DUZ))_","),.01)
UOK(X) ;   User Found
 N DIC,DTOUT,DUOUT,Y S X=$G(X) Q:'$L(X) -1  S DIC=200,DIC(0)="XB" D ^DIC S X=$S(+($G(Y))>0:1,1:0)
 Q X
LOC(X) ;   Local Namespace
 N LNS X "S LNS=$ZNSPACE" S X=$G(LNS)
 Q X
ELAP(X,E) ;   Get Elapsed Time (B)ginning/(E)nding
 N BEG,END,ELP S BEG=$G(X),END=$G(E) S ELP=$$FMDIFF^XLFDT(END,BEG,3)
 S:$L(ELP,":")=2&($L(ELP)=8) ELP=$TR(ELP," ","0")
 S:$L($P(ELP,":",1))=3&($E(ELP,1)="0") ELP=$E(ELP,2,$L(ELP))
 S X=ELP
 Q X
TM(X,Y) ;   Trim Character Y - Default " "
 S X=$G(X) Q:X="" X  S Y=$G(Y) S:'$L(Y) Y=" "
 F  Q:$E(X,1)'=Y  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=Y  S X=$E(X,1,($L(X)-1))
 Q X
ST(X) ;   Strip Spaces and Commas
 S X=$G(X) Q:X="" X  F  Q:$E(X,1)'=" "&($E(X,1)'=",")  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=" "&($E(X,$L(X))'=",")  S X=$E(X,1,($L(X)-1))
 Q X
