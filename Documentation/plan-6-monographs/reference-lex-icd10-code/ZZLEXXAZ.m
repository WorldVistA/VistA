ZZLEXXAZ ;SLC/KER - Import - ICD-10-CM - MailMan ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^ZZLEXX("ZZLEXXAZ"  SACC 1.3
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
 ;     CNT,COMMIT,HFNAME,LEXBEG,ZTQUEUED,ZTREQ
 ;               
 Q
SEND ; Send Message
 Q:'$D(COMMIT)  N ACT,C,EBEG,EEND,HR,LEXELP,LEXEND,NEW,OLD,P,PSN,TC,TT,TTL,TX,VAL,X,Y
 S TX=" Load ICD-10-CM Diagnosis Terminology" S:$L($G(HFNAME)) TX=TX_" from "_$G(HFNAME) D BL,TL(TX)
 S TTL=$O(CNT("")) Q:'$L(TTL)  S (TT,TC)=0 F ACT="AD","IA","RA","RU","SR","FR","BR" D
 . N VAL S VAL=+($G(CNT(ACT))) Q:+VAL'>0  S TC=TC+1,TT=TT+VAL
 D BL S TX=" Total changes made:" D TL(TX) I TT'>0 D BL,TL("    None"),END,MAIL Q
 I TT>0,TC>1 D
 . N PSN,TX S PSN=33,TX=$J(TT,6) D AL(TX,PSN) D:TT>0 BL
 F ACT="AD","IA","RA","RU","SR","FR","BR","NC" D
 . N TX,TTL,VAL,PSN S TTL=$$EACT(ACT),VAL=+($G(CNT(ACT)))
 . I ACT'="NC" D
 . . N TX,PSN S TX="    "_TTL D TL(TX) S PSN=33,TX=$J(VAL,6) D AL(TX,PSN)
 . I ACT="NC" D
 . . N TX,PSN D BL S TX=" "_TTL D TL(TX) S PSN=33,TX=$J(VAL,6) D AL(TX,PSN) D BL
 D END,MAIL
 Q
END ;   Timing
 Q:'$L($G(LEXBEG))  Q:$P(LEXBEG,".",1)'?7N  N LEXEND,LEXELP,EBEG,EEND,HR
 S LEXEND=$$NOW^XLFDT S LEXELP=$$FMDIFF^XLFDT(LEXEND,$G(LEXBEG),3)
 S HR=$$TM($P(LEXELP,":",1)) S:$L(HR)'=2 HR="0"_HR S:$L(HR)'=2 HR="0"_HR S $P(LEXELP,":",1)=HR
 S EBEG=$$FMTE^XLFDT($G(LEXBEG),"5ZS"),EBEG=$P(EBEG,"@",1)_"  "_$P(EBEG,"@",2)
 S EEND=$$FMTE^XLFDT($G(LEXEND),"5ZS"),EEND=$P(EEND,"@",1)_"  "_$P(EEND,"@",2) D BL
 S TX=" Start:     "_EBEG D TL(TX)
 S TX=" Finish:    "_EEND D TL(TX)
 S TX=" Elapsed:               "_LEXELP D TL(TX),BL
 Q
MAIL ;   Mail
 K XMZ N DIFROM,I,USER,TX,CT,OK,SP S U="^" S XMSUB="Load ICD-10-CM Diagnosis Terminology"
 S USER=$$NAM(+($G(DUZ))) G:'$L(USER) MAILQ S XMY(USER)="" S XMY("G.LEXICON@DNS    .DOMAIN")=""
 S I=0 F  S I=$O(^ZZLEXX("ZZLEXXAZ",$J,"MSG",I)) Q:+I'>0  D
 . S ^ZZLEXX("ZZLEXXAZ",$J,"MSG",I)=$E($G(^ZZLEXX("ZZLEXXAZ",$J,"MSG",I)),1,79)
 S XMTEXT="^ZZLEXX(""ZZLEXXAZ"","_$J_",""MSG""," N MSG
 S XMDUZ=.5 D ^XMD
MAILQ ;   Mail Quit
 S:$D(ZTQUEUED) ZTREQ="@" K ^ZZLEXX("ZZLEXXAZ",$J,"MSG"),%,%Z,XCNP,XMSCR,XMDUZ,XMY,XMZ,XMSUB,XMY,XMTEXT,XMDUZ
 Q
 ; 
 ; Miscellaneous
TY(X)  ;   Change Type
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
 N C S C=$O(^ZZLEXX("ZZLEXXAZ",$J,"MSG"," "),-1)+1
 S ^ZZLEXX("ZZLEXXAZ",$J,"MSG",C)=$G(X)
 Q
AL(X,P) ;   Text Line
 N TX,PSN,OLD,NEW,C S NEW=$G(X),PSN=+($G(P)),C=$O(^ZZLEXX("ZZLEXXAZ",$J,"MSG"," "),-1)
 S OLD=$G(^ZZLEXX("ZZLEXXAZ",$J,"MSG",C)) S:+PSN>0 TX=OLD_$J(" ",(PSN-$L(OLD)))_NEW S:+PSN'>0 TX=OLD_NEW
 S ^ZZLEXX("ZZLEXXAZ",$J,"MSG",C)=TX
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
