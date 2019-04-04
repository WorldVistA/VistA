ZZLEXXEJ ;SLC/KER - Import - ICD-10-PCS Frag - Display ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^ZZLEXX("ZZLEXXE"   SACC 1.3
 ;               
 ; External References
 ;    ^DIM                ICR  10016
 ;    ^DIR                ICR  10026
 ;    $$FMTE^XLFDT        ICR  10103
 ;    $$UP^XLFSTR         ICR  10103
 ;               
EN ; Main Entry Point
 N OUT,CONT F  D  Q:'$L(OUT)  Q:OUT="^"  Q:$G(CONT)["^"
 . W:$L($G(IOF)) @IOF S OUT=$$DIS^ZZLEXXEM
 . I $L($P(OUT,"^",1)),$L($P(OUT,"^",2)),$L($T(@OUT)) D  Q
 . . N DONE W:$L($G(IOF)) @IOF D @OUT S:'$D(NOCONT)&('$D(DONE)) CONT=$$CONT^ZZLEXXEA K DONE
 . . S:'$D(^ZZLEXX("ZZLEXXE","PCS","CHG")) CONT="^" K NOCONT
 . S CONT="^",DONE=""
 W:$L($G(IOF)) @IOF
 Q
CHG ;   Detail List of Changes
 N SYS,TYP,ENT,TTL,EXC,MET,OPD,X S SYS="PCS"
 W ! S TYP=$$TY(SYS) S ENT=$P(TYP,"^",1),TTL=$P(TYP,"^",2)
 I '$L(ENT)!('$L(TTL))!('$L($T(@(ENT_"^ZZLEXXEK")))) S DONE="" Q
 W ! S OPD=$$SH I OPD["^" W !!," Output device not selected",! Q
 K HFNAME I OPD="H" S HFNAME=$$HFN^ZZLEXXEF(SYS,$P(TYP,"^",1))
 I OPD="S" W ! S MET=$$PS^ZZLEXXEM I MET["^" W !!," Display method not selected",! Q
 S (X,EXC)="D "_ENT_"^ZZLEXXEK("""_SYS_""")" D ^DIM W:$L(IOF)&($D(X)) @IOF X:$D(X) EXC W !
 S:$L($G(HFNAME)) NOCONT=""
 Q
SUM ;   Summary of Changes
 N SUB,PVAL,CVAL,IND,GTOT S IND="   ",GTOT=0
 S PVAL=0,SUB=$O(^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","")) S:$L(SUB) PVAL=$G(^ZZLEXX("ZZLEXXE","PCS","CHG","PCS",SUB))
 W ! I PVAL>0 W !," ICD-10-PCS Procedure Code Fragment Changes",! D PCSUM S IND="   "
 I PVAL'>0 W !," ICD-10-PCS Procedure Changes",!,IND," None found"
 W !
 Q
PCSUM ;     Summary of PCS Procedure Changes
 N VAL,TOT S IND=$G(IND),TOT=0
 S VAL=$G(^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","AD")),TOT=TOT+VAL W:+VAL>0 !,IND," Procedure Fragment Code Added",?55,$J(VAL,8)
 S VAL=$G(^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","SN")),TOT=TOT+VAL W:+VAL>0 !,IND," Procedure Fragment New Name/Title (short text)",?55,$J(VAL,8)
 S VAL=$G(^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","SR")),TOT=TOT+VAL W:+VAL>0 !,IND," Procedure Fragment Revised Name/Title (short text)",?55,$J(VAL,8)
 S VAL=$G(^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","LN")),TOT=TOT+VAL W:+VAL>0 !,IND," Procedure Fragment New Description (long text)",?55,$J(VAL,8)
 S VAL=$G(^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","LR")),TOT=TOT+VAL W:+VAL>0 !,IND," Procedure Fragment Revised Description (long text)",?55,$J(VAL,8)
 S VAL=$G(^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","EN")),TOT=TOT+VAL W:+VAL>0 !,IND," Procedure Fragment New Explanations",?55,$J(VAL,8)
 S VAL=$G(^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","ER")),TOT=TOT+VAL W:+VAL>0 !,IND," Procedure Fragment Revised Explanations",?55,$J(VAL,8)
 S VAL=$G(^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","IN")),TOT=TOT+VAL W:+VAL>0 !,IND," Procedure Fragment New Inclusions/Synonyms",?55,$J(VAL,8)
 S VAL=$G(^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","IR")),TOT=TOT+VAL W:+VAL>0 !,IND," Procedure Fragment Revised Inclusions/Synonyms",?55,$J(VAL,8)
 S VAL=$G(^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","IA")),TOT=TOT+VAL W:+VAL>0 !,IND," Procedure Fragment Inactivated Code",?55,$J(VAL,8)
 S VAL=$G(^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","RA")),TOT=TOT+VAL W:+VAL>0 !,IND," Procedure Fragment Reactivated Code",?55,$J(VAL,8)
 W:+TOT>0 !!,IND," Total ICD-10-PCS Procedure Code Fragment Changes",?55,$J(TOT,8)
 I $D(GTOT) S GTOT=GTOT+TOT K IND
 K IND
 Q
LOAD ;   List of Changes Loaded
 N TOT,VAL,SUB
 S TOT=$G(^ZZLEXX("ZZLEXXE","PCS","LOAD","SYS","PCS","TOT")) I TOT>0 D
 . N SUB,VAL S SUB="ICD-10-PCS Procedures "
 . W !," ",SUB,"Changes Loaded",!
 . S VAL=$G(^ZZLEXX("ZZLEXXE","PCS","LOAD","SYS","PCS","AD")) I VAL>0 W !,?3,"Added",?43,$J(VAL,8)
 . S VAL=$G(^ZZLEXX("ZZLEXXE","PCS","LOAD","SYS","PCS","IA")) I VAL>0 W !,?3,"Inactivated",?43,$J(VAL,8)
 . S VAL=$G(^ZZLEXX("ZZLEXXE","PCS","LOAD","SYS","PCS","RA")) I VAL>0 W !,?3,"Reactivated",?43,$J(VAL,8)
 . S VAL=$G(^ZZLEXX("ZZLEXXE","PCS","LOAD","SYS","PCS","SN")) I VAL>0 W !,?3,"Name/Title Added",?43,$J(VAL,8)
 . S VAL=$G(^ZZLEXX("ZZLEXXE","PCS","LOAD","SYS","PCS","SR")) I VAL>0 W !,?3,"Name/Title Revised",?43,$J(VAL,8)
 . S VAL=$G(^ZZLEXX("ZZLEXXE","PCS","LOAD","SYS","PCS","LN")) I VAL>0 W !,?3,"Description Added",?43,$J(VAL,8)
 . S VAL=$G(^ZZLEXX("ZZLEXXE","PCS","LOAD","SYS","PCS","LR")) I VAL>0 W !,?3,"Description Revised",?43,$J(VAL,8)
 . S VAL=$G(^ZZLEXX("ZZLEXXE","PCS","LOAD","SYS","PCS","EN")) I VAL>0 W !,?3,"Explanation Added",?43,$J(VAL,8)
 . S VAL=$G(^ZZLEXX("ZZLEXXE","PCS","LOAD","SYS","PCS","ER")) I VAL>0 W !,?3,"Explanation Revised",?43,$J(VAL,8)
 . S VAL=$G(^ZZLEXX("ZZLEXXE","PCS","LOAD","SYS","PCS","IN")) I VAL>0 W !,?3,"Includes/Synonyms Added",?43,$J(VAL,8)
 . S VAL=$G(^ZZLEXX("ZZLEXXE","PCS","LOAD","SYS","PCS","IR")) I VAL>0 W !,?3,"Includes/Synonyms Revised",?43,$J(VAL,8)
 . S VAL=$G(^ZZLEXX("ZZLEXXE","PCS","LOAD","SYS","PCS","TOT")) I VAL>0 W !!,?3,"Total Procedure changes loaded",?43,$J(VAL,8)
 I $G(^ZZLEXX("ZZLEXXE","PCS","LOAD","SYS","PCS","TOT"))>0 W !
 S VAL=$G(^ZZLEXX("ZZLEXXE","PCS","LOAD","SYS",("C"_"M"),"TOT")) S VAL=VAL+$G(^ZZLEXX("ZZLEXXE","PCS","LOAD","SYS","PCS","TOT"))
 Q
UPD ;   Progress (Date and Times of Updates)
 N UDT,SUB
 S SUB="TB" S:$P($G(^ZZLEXX("ZZLEXXE","PCS","DT",SUB,"ON")),".",1)?7N UDT(SUB)=$G(^ZZLEXX("ZZLEXXE","PCS","DT",SUB,"ON"))
 S SUB="DF" S:$P($G(^ZZLEXX("ZZLEXXE","PCS","DT",SUB,"ON")),".",1)?7N UDT(SUB)=$G(^ZZLEXX("ZZLEXXE","PCS","DT",SUB,"ON"))
 S SUB="PC" S:$P($G(^ZZLEXX("ZZLEXXE","PCS","DT",SUB,"ON")),".",1)?7N UDT(SUB)=$G(^ZZLEXX("ZZLEXXE","PCS","DT",SUB,"ON"))
 S SUB="CP" S:$P($G(^ZZLEXX("ZZLEXXE","PCS","DT",SUB,"ON")),".",1)?7N UDT(SUB)=$G(^ZZLEXX("ZZLEXXE","PCS","DT",SUB,"ON"))
 S SUB=("C"_"M") S:$P($G(^ZZLEXX("ZZLEXXE","PCS","DT",SUB,"ON")),".",1)?7N UDT(SUB)=$G(^ZZLEXX("ZZLEXXE","PCS","DT",SUB,"ON"))
 S SUB="CC" S:$P($G(^ZZLEXX("ZZLEXXE","PCS","DT",SUB,"ON")),".",1)?7N UDT(SUB)=$G(^ZZLEXX("ZZLEXXE","PCS","DT",SUB,"ON"))
 W:$D(UDT) !," Updates:",! W:'$D(UDT) !," No updates found",!
 D PPCS W !
 Q
PPCS ;     Progress for PCS Procedures
 N P1,P2,VAL,TXT,TX2,UPD,UPDE,VER
 S VAL=$G(^ZZLEXX("ZZLEXXE","PCS","DT","TB")),VER=$$VER(VAL),TXT="ICD-10-PCS Tabular File ",TX2="Procedure Names/Titles"
 S (P2,UPD)=$G(^ZZLEXX("ZZLEXXE","PCS","DT","TB","ON")),UPDE="" S:$P(UPD,".",1)?7N UPDE=$TR($$FMTE^XLFDT(UPD,"5ZS"),"@"," ")
 S:$L(VER)&(VER>2010) TXT=TXT_$J(" ",(30-$L(TXT)))_$S(VER?4N:"FY",1:"  ")_VER S TX2="not read" S:$P(UPD,".",1)?7N&($L(UPDE)) TX2=" read on "_UPDE
 W !,"   ",TXT,?43,$J(TX2,35)
 S VAL=$G(^ZZLEXX("ZZLEXXE","PCS","DT","DF")),VER=$$VER(VAL),TXT="ICD-10-PCS Definition File ",TX2="Procedure Definitions/Explanations/Includes"
 S (P1,UPD)=$G(^ZZLEXX("ZZLEXXE","PCS","DT","DF","ON")),UPDE="" S:$P(UPD,".",1)?7N UPDE=$TR($$FMTE^XLFDT(UPD,"5ZS"),"@"," ")
 S:$L(VER)&(VER>2010) TXT=TXT_$J(" ",(30-$L(TXT)))_$S(VER?4N:"FY",1:"  ")_VER S TX2="not read" S:$P(UPD,".",1)?7N&($L(UPDE)) TX2=" read on "_UPDE
 W !,"   ",TXT,?43,$J(TX2,35)
 S VAL=$G(^ZZLEXX("ZZLEXXE","PCS","DT","PC")),VER=$$VER(VAL),TXT="ICD-10-PCS Combined "
 S UPD=$G(^ZZLEXX("ZZLEXXE","PCS","DT","PC","ON")),UPDE="" S:$P(UPD,".",1)?7N UPDE=$TR($$FMTE^XLFDT(UPD,"5ZS"),"@"," ")
 S:$L(VER)&(VER>2010) TXT=TXT_$J(" ",(30-$L(TXT)))_$S(VER?4N:"FY",1:"  ")_VER S TX2="not merged" S:$P(UPD,".",1)?7N&($L(UPDE)) TX2=" merged on "_UPDE
 I $P(P1,".",1)'?7N!($P(P2,".",1)'?7N) S TXT="ICD-10-PCS Combined ",TX2="not merged"
 W !,"   ",TXT,?43,$J(TX2,35)
 ;
 S VAL=$G(^ZZLEXX("ZZLEXXE","PCS","DT","CP")),VER=$$VER(VAL),TXT="ICD-10-PCS Changes ",TX2=""
 S UPD=$G(^ZZLEXX("ZZLEXXE","PCS","DT","CP","ON")),UPDE="" S:$P(UPD,".",1)?7N UPDE=$TR($$FMTE^XLFDT(UPD,"5ZS"),"@"," ")
 S:$L(VER)&(VER>2010) TXT=TXT_$J(" ",(30-$L(TXT)))_$S(VER?4N:"FY",1:"  ")_VER S TX2="not calculated" S:$P(UPD,".",1)?7N&($L(UPDE)) TX2=" calculated on "_UPDE
 I $P(P1,".",1)'?7N!($P(P2,".",1)'?7N) S TXT="ICD-10-PCS Changes ",TX2="not calculated"
 W !,"   ",TXT,?43,$J(TX2,35)
 ;
 S VAL="" S:$L($G(^ZZLEXX("ZZLEXXE","PCS","DT","LP","ON"))) VAL=$G(^ZZLEXX("ZZLEXXE","PCS","DT","CP")) I $L(VAL) D
 . S VER=$$VER(VAL),TXT="ICD-10-PCS Load ",TX2=""
 . S UPD=$G(^ZZLEXX("ZZLEXXE","PCS","DT","LP","ON")),UPDE="" S:$P(UPD,".",1)?7N UPDE=$TR($$FMTE^XLFDT(UPD,"5ZS"),"@"," ")
 . S:$L(VER)&(VER>2010) TXT=TXT_$J(" ",(30-$L(TXT)))_$S(VER?4N:"FY",1:"  ")_VER S TX2="not saved" S:$P(UPD,".",1)?7N&($L(UPDE)) TX2=" saved on "_UPDE
 . I $P(P1,".",1)'?7N!($P(P2,".",1)'?7N) S TXT="ICD-10-PCS Load ",TX2="not saved"
 . W !,"   ",TXT,?43,$J(TX2,35)
 Q
 ;
 ; Miscellaneous
VER(X) ;     Version
 S X=$P($G(X),".",1) Q:X'?7N ""  N YR,MD S YR=$E(X,1,3)+1700,MD=$E(X,4,5) S:+MD>9 YR=YR+1 S X=YR
 Q X
SH(X) ;   Screen/Hostfile
 K LNCT N DIR,DIRB,DIROUT,DIRUT,DTOUT,DUOUT,MIN,MAX,NOW,LAT,DIRB,IN,TX
 S DIRB=$$RET^ZZLEXXEM("SH^ZZLEXXEJ",DUZ,"Screen/Hostfile") S:$L(DIRB) DIR("B")=DIRB
 S DIR(0)="SAO^S:Screen;H:Hostfile"
 S DIR("A")=" Display to the Screen or write to Hostfile (S/H):  "
 S (DIR("?"),DIR("??"))="^D SHH^ZZLEXXEJ"
 S DIR("PRE")="S:$L(X)&(X'[""^"")&(""^S^H^""'[(""^""_$$UP^XLFSTR($E(X,1))_""^"")) X=""??"""
 D ^DIR S:$D(DTOUT)!($D(DUOUT))!($D(DIROUT))!(Y'?4N) X="^" S X=$E($$UP^XLFSTR(Y),1)
 S TX="" S:Y="S" TX="Screen" S:Y="H" TX="Hostfile" Q:'$L(X) "^"
 D:$L(TX) SAV^ZZLEXXEM("SH^ZZLEXXEJ",DUZ,"Screen/Hostfile",TX)
 Q X
SHH(X) ;   Page/Scroll Help
 N BOLD,NORM D ATTR^ZZLEXXEA
 W !,"    Enter '",$G(BOLD),"S",$G(NORM),"' to send the output to the ",$G(BOLD),"Screen",$G(NORM)
 W !,"       or '",$G(BOLD),"H",$G(NORM),"' to send the output to a ",$G(BOLD),"Hostfile",$G(NORM)
 D KATTR^ZZLEXXEA
 Q
TY(X) ;   Change Type
 N TY S TY=$G(X) N DIR,DIROUT,DIRUT,DUOUT,DTOUT,Y,ARY,MIN,MAX,CT,I S CT=0
 S DIR("A",1)=" ICD-10-PCS Procedure Code Fragment Changes",DIR("A",2)=" "
 I $L($O(^ZZLEXX("ZZLEXXE","PCS","CHG",TY,"AD",""))) D
 . N VAL,TX S VAL=$G(^ZZLEXX("ZZLEXXE","PCS","CHG",TY,"AD")),TX="AD^Procedure Fragment Code Added"
 . S:+VAL>0 TX=TX_$J(" ",(50-$L(TX)))_$J(VAL,6) S CT=CT+1 S ARY(CT)=TX
 I $L($O(^ZZLEXX("ZZLEXXE","PCS","CHG",TY,"SN",""))) D
 . N VAL,TX S VAL=$G(^ZZLEXX("ZZLEXXE","PCS","CHG",TY,"SN")),TX="SN^Procedure Fragment Name/Title Added"
 . S:+VAL>0 TX=TX_$J(" ",(50-$L(TX)))_$J(VAL,6) S CT=CT+1 S ARY(CT)=TX
 I $L($O(^ZZLEXX("ZZLEXXE","PCS","CHG",TY,"SR",""))) D
 . N VAL,TX S VAL=$G(^ZZLEXX("ZZLEXXE","PCS","CHG",TY,"SR")),TX="SR^Procedure Fragment Name/Title Revised"
 . S:+VAL>0 TX=TX_$J(" ",(50-$L(TX)))_$J(VAL,6) S CT=CT+1 S ARY(CT)=TX
 I $L($O(^ZZLEXX("ZZLEXXE","PCS","CHG",TY,"LN",""))) D
 . N VAL,TX S VAL=$G(^ZZLEXX("ZZLEXXE","PCS","CHG",TY,"LN")),TX="LN^Procedure Fragment Description Added"
 . S:+VAL>0 TX=TX_$J(" ",(50-$L(TX)))_$J(VAL,6) S CT=CT+1 S ARY(CT)=TX
 I $L($O(^ZZLEXX("ZZLEXXE","PCS","CHG",TY,"LR",""))) D
 . N VAL,TX S VAL=$G(^ZZLEXX("ZZLEXXE","PCS","CHG",TY,"LR")),TX="LR^Procedure Fragment Description Revised"
 . S:+VAL>0 TX=TX_$J(" ",(50-$L(TX)))_$J(VAL,6) S CT=CT+1 S ARY(CT)=TX
 I $L($O(^ZZLEXX("ZZLEXXE","PCS","CHG",TY,"EN",""))) D
 . N VAL,TX S VAL=$G(^ZZLEXX("ZZLEXXE","PCS","CHG",TY,"EN")),TX="EN^Procedure Fragment Explanation Added"
 . S:+VAL>0 TX=TX_$J(" ",(50-$L(TX)))_$J(VAL,6) S CT=CT+1 S ARY(CT)=TX
 I $L($O(^ZZLEXX("ZZLEXXE","PCS","CHG",TY,"ER",""))) D
 . N VAL,TX S VAL=$G(^ZZLEXX("ZZLEXXE","PCS","CHG",TY,"ER")),TX="ER^Procedure Fragment Explanation Revised"
 . S:+VAL>0 TX=TX_$J(" ",(50-$L(TX)))_$J(VAL,6) S CT=CT+1 S ARY(CT)=TX
 I $L($O(^ZZLEXX("ZZLEXXE","PCS","CHG",TY,"IN",""))) D
 . N VAL,TX S VAL=$G(^ZZLEXX("ZZLEXXE","PCS","CHG",TY,"IN")),TX="IN^Procedure Fragment Inclusion/Synonym Added"
 . S:+VAL>0 TX=TX_$J(" ",(50-$L(TX)))_$J(VAL,6) S CT=CT+1 S ARY(CT)=TX
 I $L($O(^ZZLEXX("ZZLEXXE","PCS","CHG",TY,"IR",""))) D
 . N VAL,TX S VAL=$G(^ZZLEXX("ZZLEXXE","PCS","CHG",TY,"IR")),TX="IR^Procedure Fragment Inclusion/Synonym Revised"
 . S:+VAL>0 TX=TX_$J(" ",(50-$L(TX)))_$J(VAL,6) S CT=CT+1 S ARY(CT)=TX
 S MIN=$O(ARY(0)),MAX=$O(ARY(" "),-1) Q:MIN'>0 "^"  I MIN=MAX S X=$G(ARY(MIN)) Q X
 S I=0 F  S I=$O(ARY(I)) Q:+I'>0  D
 . N ND,NM,CT S ND=$G(ARY(I)),NM=$P(ND,"^",2),CT=I+2,DIR("A",CT)="   "_$J(I,2)_".  "_NM
 S CT=$O(DIR("A"," "),-1)+1,DIR("A",CT)=" ",DIR(0)="NAO^"_MIN_":"_MAX_":0",DIR("A")=" Select changes to display:  "
 D ^DIR I +Y>0,$D(ARY(+Y)) S X=$G(ARY(+Y)) Q X
 Q "^"
