ZZLEXXDZ ;SLC/KER - Import - ICD-10-CM Cat - MailMan ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^ZZLEXX("ZZLEXXDZ"  SACC 1.3
 ;               
 ; External References
 ;    $$FIND1^DIC         ICR   2051
 ;    $$GET1^DIQ          ICR   2056
 ;    $$FMDIFF^XLFDT      ICR  10103
 ;    $$FMTE^XLFDT        ICR  10103
 ;    $$NOW^XLFDT         ICR  10103
 ;    ^XMD                ICR  10070
 ;               
 ; Local Variables NEWed or KILLed Elsewhere
 ;     CNT,HFNAME,ZTQUEUED,ZTREQ
 ;               
 Q
SEND ; Send Message
 S FIL=$G(^ZZLEXX("ZZLEXXD","CAT","LOAD","HF1")) Q:'$L($G(FIL))
 S BEG=$G(^ZZLEXX("ZZLEXXD","CAT","LOAD","TIM","BEG")) Q:$P($G(BEG),".",1)'?7N
 S END=$G(^ZZLEXX("ZZLEXXD","CAT","LOAD","TIM","END")) Q:$P($G(END),".",1)'?7N
 S ELP=$G(^ZZLEXX("ZZLEXXD","CAT","LOAD","TIM","ELP")) Q:'$L($G(ELP))
 S ST1=$G(^ZZLEXX("ZZLEXXD","CAT","LOAD","TIM","ST1")) Q:$P($G(ST1),".",1)'?7N
 S ST2=$G(^ZZLEXX("ZZLEXXD","CAT","LOAD","TIM","ST2")) Q:$P($G(ST2),".",1)'?7N
 S ST3=$G(^ZZLEXX("ZZLEXXD","CAT","LOAD","TIM","ST3")) Q:$P($G(ST3),".",1)'?7N
 S TX=" Load ICD-10-CM Diagnosis Categories" S:$L(FIL) TX=TX_" from "_FIL D BL,TL(TX)
 S VAL=+($G(^ZZLEXX("ZZLEXXD","CAT","LOAD","TOT"))) I +VAL'>0 D  Q
 . N TX S TX=" Total changes made:" D TL(TX),BL S TX="   None" D TL(TX),BL
 D BL S TX=" Total changes made:" D TL(TX) S TX=$J(VAL,6) D AL(TX,33),BL
 S ACT="" F  S ACT=$O(^ZZLEXX("ZZLEXXD","CAT","LOAD","TYP",ACT)) Q:'$L(ACT)  D
 . N TX,VAL,TN S TN=$$TY(ACT) Q:'$L(TN)
 . S VAL=$G(^ZZLEXX("ZZLEXXD","CAT","LOAD","TYP",ACT)) Q:+VAL'>0
 . S TX="    "_TN D TL(TX) S TX=$J(VAL,6) D AL(TX,33)
 D END,MAIL
 Q
END ;   Timing
 Q:'$L($G(BEG))  Q:$P(BEG,".",1)'?7N  Q:'$L($G(END))  Q:$P(END,".",1)'?7N  Q:'$L(ELP)
 N EBEG,EEND,EDT,TX S EBEG=$$FMTE^XLFDT($G(BEG),"5ZS"),EBEG=$P(EBEG,"@",1)_"  "_$P(EBEG,"@",2)
 S EEND=$$FMTE^XLFDT($G(END),"5ZS"),EEND=$P(EEND,"@",1)_"  "_$P(EEND,"@",2) D BL
 I $L($G(FIL)),$$UP^XLFSTR($G(FIL))[".TXT" S TX=" Host File:    "_FIL D TL(TX),BL
 S TX=" Start:        "_EBEG D TL(TX)
 I $P($G(ST1),".",1)?7N D
 . N EDT,TX S EDT=$$FMTE^XLFDT($G(ST1),"5ZS"),EDT=$P(EDT,"@",1)_"  "_$P(EDT,"@",2)
 . S TX="   Read:       "_EDT D TL(TX)
 I $P($G(ST2),".",1)?7N D
 . N EDT,TX S EDT=$$FMTE^XLFDT($G(ST2),"5ZS"),EDT=$P(EDT,"@",1)_"  "_$P(EDT,"@",2)
 . S TX="   Compiled:   "_EDT D TL(TX)
 I $P($G(ST3),".",1)?7N D
 . N EDT,TX S EDT=$$FMTE^XLFDT($G(ST3),"5ZS"),EDT=$P(EDT,"@",1)_"  "_$P(EDT,"@",2)
 . S TX="   Loaded:     "_EDT D TL(TX)
 S TX=" Finish:       "_EEND D TL(TX)
 S TX=" Elapsed:                  "_ELP D TL(TX),BL
 Q
MAIL ;   Mail
 K XMZ N DIFROM,I,USER,TX,CT,OK,SP S U="^" S XMSUB="Load ICD-10-CM Diagnosis Categories"
 S USER=$$NAM(+($G(DUZ))) G:'$L(USER) MAILQ S XMY(USER)="" S XMY("G.LEXICON@DNS    .DOMAIN")=""
 S I=0 F  S I=$O(^ZZLEXX("ZZLEXXDZ",$J,"MSG",I)) Q:+I'>0  D
 . S ^ZZLEXX("ZZLEXXDZ",$J,"MSG",I)=$E($G(^ZZLEXX("ZZLEXXDZ",$J,"MSG",I)),1,79)
 S XMTEXT="^ZZLEXX(""ZZLEXXDZ"","_$J_",""MSG""," N MSG
 S XMDUZ=.5 D ^XMD
MAILQ ;   Mail Quit
 S:$D(ZTQUEUED) ZTREQ="@" K ^ZZLEXX("ZZLEXXDZ",$J,"MSG"),%,%Z,XCNP,XMSCR,XMDUZ,XMY,XMZ,XMSUB,XMY,XMTEXT,XMDUZ
 Q
 ; 
 ; Miscellaneous
TY(X)  ; Change Type
 N TY S TY=""
 S:X="AD" TY="Category Added"
 S:X="IA" TY="Category Inactivated"
 S:X="RA" TY="Category Re-Activated"
 S:X="IN" TY="Inclusion Added"
 S:X="IR" TY="Inclusion Revised"
 S:X="IN" TY="Inclusion Added"
 S:X="IR" TY="Inclusion Revised"
 S:X="LN" TY="Definition Added"
 S:X="LR" TY="Definition Revised"
 S:X="EN" TY="Explanation Added"
 S:X="ER" TY="Explanation Revised"
 S:X="SN" TY="Title/Name Added"
 S:X="SR" TY="Title/Name Revised"
 S:X="TT" TY="Total Changes"
 S X=TY
 Q X
NAM(X) ;   Name
 S X=+($G(X)) Q:X'>0 ""  S X=$$GET1^DIQ(200,(+X_","),.01)
 Q X
BL ;   Blank Line
 D TL("  ")
 Q
TL(X) ;   Text Line
 N C S C=$O(^ZZLEXX("ZZLEXXDZ",$J,"MSG"," "),-1)+1
 S ^ZZLEXX("ZZLEXXDZ",$J,"MSG",C)=$G(X)
 Q
AL(X,P) ;   Text Line
 N TX,PSN,OLD,NEW,C S NEW=$G(X),PSN=+($G(P)),C=$O(^ZZLEXX("ZZLEXXDZ",$J,"MSG"," "),-1)
 S OLD=$G(^ZZLEXX("ZZLEXXDZ",$J,"MSG",C)) S:+PSN>0 TX=OLD_$J(" ",(PSN-$L(OLD)))_NEW S:+PSN'>0 TX=OLD_NEW
 S ^ZZLEXX("ZZLEXXDZ",$J,"MSG",C)=TX
 Q
EACT(X) ;   External Action
 Q:$G(X)="AD" "Additions"  Q:$G(X)="SR" "Short Text Revisions"  Q:$G(X)="FR" "Long Text Revisions"  Q:$G(X)="BR" "Long/Short Text Revisions"
 Q:$G(X)="RA" "Re-Activations"  Q:$G(X)="RU" "Re-Used"  Q:$G(X)="IA" "Inactivations"  Q:$G(X)="NC" "Codes with No Change"
 Q " "
TM(X,Y) ;   Trim Character Y - Default " " Space
 S X=$G(X) Q:X="" X  S Y=$G(Y) S:'$L(Y) Y=" "
 F  Q:$E(X,1)'=Y  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=Y  S X=$E(X,1,($L(X)-1))
 Q X
