ZZLEXXVC ;SLC/KER - Import - FileMan Verify (Summary) ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^ZZLEXX("ZZLEXXV"   SACC 1.3
 ;               
 ; External References
 ;    ^DIC                ICR  10063
 ;    $$GET1^DIQ          ICR   2056
 ;    $$FMTE^XLFDT        ICR  10103
 ;    ^XMD                ICR  10070
 ;               
 ; Local Variables NEWed or KILLed Elsewhere
 ;     ERR
 ;               
 Q
END(BEG,END,TIM,RES,HDR) ; End FM Verify - Send Message
 ;
 ;  BEG       Begin Date and Time
 ;  END       End Date and Time
 ;  TIM       Time (elapsed)
 ;  RES       Results Array passed by reference
 ;              RES("FLC",FI)         Files Checked
 ;              RES("FDC",(FI_FD))    Fields Checked
 ;              RES("SFC",SF)         Sub-Fields Checked
 ;              RES("FLE",FI)         Erant Files
 ;              RES("FDE",(FI_FD))    Erant Fields
 ;              RES("ERR")            Errors
 ;  HDR       Message Header
 ;          
 N LAS,I,M,TTL,FLE,FDE,FLC,SFC,FDC,LSE
 S BEG=$G(BEG),END=$G(END),TIM=$G(TIM),HDR=$G(HDR)
 S FLE=$$FLE(.RES)
 S FDE=$$FDE(.RES)
 S FLC=$$FLC(.RES)
 S FDC=$$FDC(.RES)
 S SFC=$$SFC(.RES)
 S LSE=$$LSE(.RES)
 S ERR=+($G(RES("ERR")))
 ; Message
 ;   Title
 D TTL
 ;   Checked
 D CHK
 ;   Errors
 D ERR
 ;   Timing
 D HAC
 ;   Body
 D BOD
 ;   Send
 K XMZ N DIFROM,I,USER S U="^" S:$L(HDR) XMSUB=HDR S:'$L(HDR) XMSUB="Load ICD-10 FileMan Verify"
 S USER=$$NAM,XMY("G.LEXICON@DNS    .DOMAIN")="" S:$L(USER) XMY(USER)="" S XMTEXT="^ZZLEXX(""ZZLEXXV"","_$J_",""MSG"","
 S XMDUZ=.5 D ^XMD K ^ZZLEXX("ZZLEXXV",$J,"VER"),^ZZLEXX("ZZLEXXV",$J,"MSG")
 K %,%Z,XCNP,XMSCR,XMDUZ,XMY,XMZ,XMSUB,XMY,XMTEXT,XMDUZ
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
 Q
ERR ;   Errors
 N ERRST,ERRDT,ERRLT
 I +($G(ERR))>1000 D
 . D BLM,TLM("   WARNING:  Too many errors were found to send in a MailMan message.")
 . D TLM("             Please fix the problems identified in this message and ")
 . D TLM("             re-run FileMan Verify.")
 I +($G(ERR))'>0 D BLM,TLM("   No Errors to Report") Q
 I +($G(FLE))>0!(+($G(FDE))>0)!(+($G(ERR))>0) D BLM
 S ERRLT=$$FILL(+($G(FLE)),$G(LSE)) D:$L(ERRLT) TLM(ERRLT)
 S ERRDT=$$FLDE(+($G(FDE))) D:$L(ERRDT) TLM(ERRDT)
 S ERRST=$$TOTE(+($G(ERR))) D TLM(ERRST)
 Q
HAC ;   Time Hacks
 N BEGT,ENDT,TIMT
 S BEGT=$$STR($G(BEG)) Q:'$L(BEGT)
 S ENDT=$$FIN($G(END)) Q:'$L(ENDT)
 S TIMT=$$TIM($G(TIM)) Q:'$L(TIMT)
 D BLM,TLM(BEGT),TLM(ENDT),TLM(TIMT)
 Q
BOD ;   Body of the Report
 N LN S LN=0 D:$O(^ZZLEXX("ZZLEXXV",$J,"VER",0))>0 BLM F  S LN=$O(^ZZLEXX("ZZLEXXV",$J,"VER",LN)) Q:+LN=0  D
 . N TX S TX=$G(^ZZLEXX("ZZLEXXV",$J,"VER",LN)) D TLM(TX)
 Q
 ;                     
 ; Miscellaneous
FLE(RES) ;   Errant Files
 N I,C S (I,C)=0 F  S I=$O(RES("FLE",I)) Q:+I'>0  S C=C+1
 Q C
FDE(RES) ;   Errant Fields
 N I,C S (I,C)=0 F  S I=$O(RES("FDE",I)) Q:+I'>0  S C=C+1
 Q C
FLC(RES) ;   Files Checked
 N I,C S (I,C)=0 F  S I=$O(RES("FLC",I)) Q:+I'>0  S C=C+1
 Q C
FDC(RES) ;   Fields Checked
 N I,C S (I,C)=0 F  S I=$O(RES("FDC",I)) Q:+I'>0  S C=C+1
 Q C
SFC(RES) ;   Fields Checked
 N I,C S (I,C)=0 F  S I=$O(RES("SFC",I)) Q:+I'>0  S C=C+1
 Q C
LSE(RES) ;   Files List
 N STR,ORD,CT S CT=0,ORD="" F  S ORD=$O(RES("FLE",ORD)) Q:+ORD'>0  S:+ORD>0 STR=$G(STR)_", "_ORD,CT=CT+1
 Q:CT'>0 ""  S STR=$$STRIP(STR) S:STR[", " STR=$P(STR,", ",1,($L(STR,", ")-1))_" and "_$P(STR,", ",$L(STR,", "))
 S X="" S:$L(STR) X=STR
 Q X
STR(X) ;   Start
 N STR S STR=$G(X) Q:$P(STR,".",1)'?7N ""
 S X="   Start:              "_$TR($$FMTE^XLFDT($G(STR),"5Z"),"@"," ")
 Q X
FIN(X) ;   Finish
 N STR S STR=$G(X) Q:$P(STR,".",1)'?7N ""
 S X="   Finish:             "_$TR($$FMTE^XLFDT($G(STR),"5Z"),"@"," ")
 Q X
TIM(X) ;   Time
 N STR S STR=$G(X) Q:'$L(STR) ""
 I STR["day" S X="   Time:               "_$G(STR)
 I STR'["day" S X="   Time:                          "_$G(STR)
 Q X
TOTE(X) ;   Total Errors
 N CT S CT=$G(X) Q:CT'>0 "   No Errors Found"  S X="   Total Errors:       "_+($G(CT))
 Q X
FLDE(X) ;   Errant Fields
 N CT S CT=$G(X) Q:CT'>0 ""  S X="   Errant Fields:      "_+($G(CT))
 Q X
FILE(X) ;   Errant Files (no list)
 N CT S CT=$G(X) Q:CT'>0 ""  S X="   Errant Files:       "_+($G(CT))
 Q X
FILL(X,LSE) ;   Errant Files (w/List)
 N CT,LT S CT=+($G(X)),LT=$G(LSE) Q:CT'>0 ""
 S X="   Errant Files:       "_+($G(CT)) S:$L($G(LT)) X=X_"  ("_$G(LT)_")"
 Q X
BLM(T) ;   Blank Line in Message
 D TLM("  ") Q
TLM(X) ;   Text Line in Message
 N TXT,I S TXT=$G(X) S I=$O(^ZZLEXX("ZZLEXXV",$J,"MSG"," "),-1)+1,^ZZLEXX("ZZLEXXV",$J,"MSG",I)=TXT,^ZZLEXX("ZZLEXXV",$J,"MSG",0)=I
 Q
NAM(X) ;   User Name
 Q $$GET1^DIQ(200,(+($G(DUZ))_","),.01)
UOK(X) ;   User Found
 N DIC,DTOUT,DUOUT,Y S X=$G(X) Q:'$L(X) -1  S DIC=200,DIC(0)="XB" D ^DIC S X=$S(+($G(Y))>0:1,1:0)
 Q X
LOC(X) ;   Local Namespace
 N LNS X "S LNS=$ZNSPACE" S X=$G(LNS)
 Q X
TRIM(X,Y) ;   Trim Character Y - Default " "
 S X=$G(X) Q:X="" X  S Y=$G(Y) S:'$L(Y) Y=" "
 F  Q:$E(X,1)'=Y  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=Y  S X=$E(X,1,($L(X)-1))
 Q X
STRIP(X) ;   Strip Spaces and Commas
 S X=$G(X) Q:X="" X  F  Q:$E(X,1)'=" "&($E(X,1)'=",")  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=" "&($E(X,$L(X))'=",")  S X=$E(X,1,($L(X)-1))
 Q X
