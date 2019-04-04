ZZLEXXDF ;SLC/KER - Import - ICD-10-CM Cat - Display ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^ZZLEXX("ZZLEXXD"   SACC 1.3
 ;               
 ; External References
 ;    ^DIM                ICR  10016
 ;    ^DIR                ICR  10026
 ;    $$FMTE^XLFDT        ICR  10103
 ;    $$UP^XLFSTR         ICR  10103
 ;               
EN ; Main Entry Point
 N BOLD,NORM,OUT,CONT F  D  Q:'$L(OUT)  Q:OUT="^"  Q:$G(CONT)["^"
 . W:$L($G(IOF)) @IOF S OUT=$$DIS^ZZLEXXDM
 . I $L($P(OUT,"^",1)),$L($P(OUT,"^",2)),$L($T(@OUT)) D  Q
 . . N DONE W:$L($G(IOF)) @IOF D @OUT S:'$D(NOCONT)&('$D(DONE)) CONT=$$CONT^ZZLEXXDA K DONE
 . . S:'$D(^ZZLEXX("ZZLEXXD","CAT","CHG")) CONT="^" K NOCONT
 . S CONT="^",DONE=""
 W:$L($G(IOF)) @IOF
 Q
CHG ;   Detail List of Changes
 N SYS,TYP,ENT,TTL,EXC,MET,OPD,X S SYS="CM"
 W ! S TYP=$$TY(SYS) S ENT=$P(TYP,"^",1),TTL=$P(TYP,"^",2)
 I '$L(ENT)!('$L(TTL))!('$L($T(@(ENT_"^ZZLEXXDG")))) S DONE="" Q
 W ! S OPD=$$SH I OPD["^" W !!," Output device not selected",! Q
 K HFNAME I OPD="H" S HFNAME=$$HFN^ZZLEXXDE(SYS,$P(TYP,"^",1))
 I OPD="S" W ! S MET=$$PS^ZZLEXXDM I MET["^" W !!," Display method not selected",! Q
 S (X,EXC)="D "_ENT_"^ZZLEXXDG("""_SYS_""")" D ^DIM W:$L(IOF)&($D(X)) @IOF X:$D(X) EXC W !
 S:$L($G(HFNAME)) NOCONT=""
 Q
SUM ;   Summary of Changes
 N SUB,PVAL,CVAL,IND,GTOT S IND="   ",GTOT=0
 S CVAL=0,SUB=$O(^ZZLEXX("ZZLEXXD","CAT","CHG","CM","")) S:$L(SUB) CVAL=$G(^ZZLEXX("ZZLEXXD","CAT","CHG","CM",SUB))
 S PVAL=0,SUB=$O(^ZZLEXX("ZZLEXXD","CAT","CHG",("PC"_"S"),"")) S:$L(SUB) PVAL=$G(^ZZLEXX("ZZLEXXD","CAT","CHG",("PC"_"S"),SUB))
 I CVAL>0 W !," ICD-10-CM Diagnosis Category Changes",! D CMSUM S IND="   "
 I CVAL'>0 W !," ICD-10-CM Diagnosis Category Changes",!,IND," None found"
 W !
 Q
CMSUM ;     Summary of CM Diagnosos Changes
 N VAL,TOT S IND=$G(IND),TOT=0
 S VAL=$G(^ZZLEXX("ZZLEXXD","CAT","CHG","CM","AD")),TOT=TOT+VAL W:+VAL>0 !,IND," Diagnosis Category Code Added",?55,$J(VAL,8)
 S VAL=$G(^ZZLEXX("ZZLEXXD","CAT","CHG","CM","SN")),TOT=TOT+VAL W:+VAL>0 !,IND," Diagnosis Category New Name/Title (short text)",?55,$J(VAL,8)
 S VAL=$G(^ZZLEXX("ZZLEXXD","CAT","CHG","CM","SR")),TOT=TOT+VAL W:+VAL>0 !,IND," Diagnosis Category Revised Name/Title (short text)",?55,$J(VAL,8)
 S VAL=$G(^ZZLEXX("ZZLEXXD","CAT","CHG","CM","LN")),TOT=TOT+VAL W:+VAL>0 !,IND," Diagnosis Category New Description (long text)",?55,$J(VAL,8)
 S VAL=$G(^ZZLEXX("ZZLEXXD","CAT","CHG","CM","LR")),TOT=TOT+VAL W:+VAL>0 !,IND," Diagnosis Category Revised Description (long text)",?55,$J(VAL,8)
 S VAL=$G(^ZZLEXX("ZZLEXXD","CAT","CHG","CM","EN")),TOT=TOT+VAL W:+VAL>0 !,IND," Diagnosis Category New Explanations",?55,$J(VAL,8)
 S VAL=$G(^ZZLEXX("ZZLEXXD","CAT","CHG","CM","ER")),TOT=TOT+VAL W:+VAL>0 !,IND," Diagnosis Category Revised Explanations",?55,$J(VAL,8)
 S VAL=$G(^ZZLEXX("ZZLEXXD","CAT","CHG","CM","IN")),TOT=TOT+VAL W:+VAL>0 !,IND," Diagnosis Category New Inclusions/Synonyms",?55,$J(VAL,8)
 S VAL=$G(^ZZLEXX("ZZLEXXD","CAT","CHG","CM","IR")),TOT=TOT+VAL W:+VAL>0 !,IND," Diagnosis Category Revised Inclusions/Synonyms",?55,$J(VAL,8)
 S VAL=$G(^ZZLEXX("ZZLEXXD","CAT","CHG","CM","IA")),TOT=TOT+VAL W:+VAL>0 !,IND," Diagnosis Category Code Inactivated",?55,$J(VAL,8)
 S VAL=$G(^ZZLEXX("ZZLEXXD","CAT","CHG","CM","RA")),TOT=TOT+VAL W:+VAL>0 !,IND," Diagnosis Category Code Reactivated Code",?55,$J(VAL,8)
 W:+TOT>0 !!,IND," Total ICD-10 Diagnosis Category Changes",?55,$J(TOT,8)
 I $D(GTOT) S GTOT=GTOT+TOT K IND
 Q
LOAD ;   List of Changes Loaded
 N TOT,VAL,SUB
 S TOT=$G(^ZZLEXX("ZZLEXXD","CAT","LOAD","SYS","CM","TOT")) I TOT>0 D
 . N SUB,VAL S SUB="ICD-10-CM Diagnosis Category "
 . W !," ",SUB,"Changes Loaded",!
 . S VAL=$G(^ZZLEXX("ZZLEXXD","CAT","LOAD","SYS","CM","AD")) I VAL>0 W !,?3,"Diagnosis Category Codes Added",?43,$J(VAL,8)
 . S VAL=$G(^ZZLEXX("ZZLEXXD","CAT","LOAD","SYS","CM","IA")) I VAL>0 W !,?3,"Diagnosis Category Codes Inactivated",?43,$J(VAL,8)
 . S VAL=$G(^ZZLEXX("ZZLEXXD","CAT","LOAD","SYS","CM","RA")) I VAL>0 W !,?3,"Diagnosis Category Codes Reactivated",?43,$J(VAL,8)
 . S VAL=$G(^ZZLEXX("ZZLEXXD","CAT","LOAD","SYS","CM","SN")) I VAL>0 W !,?3,"Diagnosis Category Name/Title Added",?43,$J(VAL,8)
 . S VAL=$G(^ZZLEXX("ZZLEXXD","CAT","LOAD","SYS","CM","SR")) I VAL>0 W !,?3,"Diagnosis Category Name/Title Revised",?43,$J(VAL,8)
 . S VAL=$G(^ZZLEXX("ZZLEXXD","CAT","LOAD","SYS","CM","LN")) I VAL>0 W !,?3,"Diagnosis Category Description Added",?43,$J(VAL,8)
 . S VAL=$G(^ZZLEXX("ZZLEXXD","CAT","LOAD","SYS","CM","LR")) I VAL>0 W !,?3,"Diagnosis Category Description Revised",?43,$J(VAL,8)
 . S VAL=$G(^ZZLEXX("ZZLEXXD","CAT","LOAD","SYS","CM","EN")) I VAL>0 W !,?3,"Diagnosis Category Explanation Added",?43,$J(VAL,8)
 . S VAL=$G(^ZZLEXX("ZZLEXXD","CAT","LOAD","SYS","CM","ER")) I VAL>0 W !,?3,"Diagnosis Category Explanation Revised",?43,$J(VAL,8)
 . S VAL=$G(^ZZLEXX("ZZLEXXD","CAT","LOAD","SYS","CM","IN")) I VAL>0 W !,?3,"Diagnosis Category Includes/Synonyms Added",?43,$J(VAL,8)
 . S VAL=$G(^ZZLEXX("ZZLEXXD","CAT","LOAD","SYS","CM","IR")) I VAL>0 W !,?3,"Diagnosis Category Includes/Synonyms Revised",?43,$J(VAL,8)
 . S VAL=$G(^ZZLEXX("ZZLEXXD","CAT","LOAD","SYS","CM","TOT")) I VAL>0 W !!,?3,"Total Diagnosis Category changes loaded",?43,$J(VAL,8)
 I $G(^ZZLEXX("ZZLEXXD","CAT","LOAD","SYS","CM","TOT"))>0 W !
 S VAL=$G(^ZZLEXX("ZZLEXXD","CAT","LOAD","SYS","CM","TOT")) S VAL=VAL+$G(^ZZLEXX("ZZLEXXD","CAT","LOAD","SYS",("PC"_"S"),"TOT"))
 Q
UPD ;   Progress (Date and Times of Updates)
 N UDT,SUB
 S SUB="CM" S:$P($G(^ZZLEXX("ZZLEXXD","CAT","DT",SUB,"ON")),".",1)?7N UDT(SUB)=$G(^ZZLEXX("ZZLEXXD","CAT","DT",SUB,"ON"))
 S SUB="CC" S:$P($G(^ZZLEXX("ZZLEXXD","CAT","DT",SUB,"ON")),".",1)?7N UDT(SUB)=$G(^ZZLEXX("ZZLEXXD","CAT","DT",SUB,"ON"))
 W:$D(UDT) !," Updates:",! W:'$D(UDT) !," No updates found",!
 D PCM I $P($G(^ZZLEXX("ZZLEXXD","CAT","DT","CM","ON")),".",1)?7N!($P($G(^ZZLEXX("ZZLEXXD","CAT","DT","CC","ON")),".",1)?7N) W !
 Q
PCM ;     Progress for CM Diagnosis
 N VAL,VER,TXT,TX2,UPD,UPDE,P1,P2
 S VAL=$G(^ZZLEXX("ZZLEXXD","CAT","DT","CM")),VER=$$VER(VAL),TXT="ICD-10-CM Order File "
 S UPD=$G(^ZZLEXX("ZZLEXXD","CAT","DT","CM","ON")),UPDE="" S:$P(UPD,".",1)?7N UPDE=$TR($$FMTE^XLFDT(UPD,"5ZS"),"@"," ")
 S:$L(VER)&(VER>2010) TXT=TXT_$J(" ",(30-$L(TXT)))_$S(VER?4N:"FY",1:"  ")_VER S TX2="not read" S:$P(UPD,".",1)?7N&($L(UPDE)) TX2=" read on "_UPDE
 W !,"   ",TXT,?43,$J(TX2,35)
 N VAL,VER,TXT,TX2,UPD,UPDE,P1,P2
 S VAL=$G(^ZZLEXX("ZZLEXXD","CAT","DT","CC")),VER=$$VER(VAL),TXT="ICD-10-CM Changes "
 S UPD=$G(^ZZLEXX("ZZLEXXD","CAT","DT","CC","ON")),UPDE="" S:$P(UPD,".",1)?7N UPDE=$TR($$FMTE^XLFDT(UPD,"5ZS"),"@"," ")
 S:$L(VER)&(VER>2010) TXT=TXT_$J(" ",(30-$L(TXT)))_$S(VER?4N:"FY",1:"  ")_VER S TX2="not calculated" S:$P(UPD,".",1)?7N&($L(UPDE)) TX2=" calculated on "_UPDE
 W !,"   ",TXT,?43,$J(TX2,35)
 S VAL="" S:$L($G(^ZZLEXX("ZZLEXXD","CAT","DT","LC","ON"))) VAL=$G(^ZZLEXX("ZZLEXXD","CAT","DT","CP")) I $L(VAL) D
 . S VER=$$VER(VAL),TXT="ICD-10-CM Load ",TX2=""
 . S UPD=$G(^ZZLEXX("ZZLEXXD","CAT","DT","LC","ON")),UPDE="" S:$P(UPD,".",1)?7N UPDE=$TR($$FMTE^XLFDT(UPD,"5ZS"),"@"," ")
 . S:$L(VER)&(VER>2010) TXT=TXT_$J(" ",(30-$L(TXT)))_$S(VER?4N:"FY",1:"  ")_VER S TX2="not saved" S:$P(UPD,".",1)?7N&($L(UPDE)) TX2=" saved on "_UPDE
 . W !,"   ",TXT,?43,$J(TX2,35)
 Q
VER(X) ;     Version
 S X=$P($G(X),".",1) Q:X'?7N ""  N YR,MD S YR=$E(X,1,3)+1700,MD=$E(X,4,5) S:+MD>9 YR=YR+1 S X=YR
 Q X
 ;
 ; Miscellaneous
SH(X) ;   Screen/Hostfile
 K LNCT N DIR,DIRB,DIROUT,DIRUT,DTOUT,DUOUT,MIN,MAX,NOW,LAT,DIRB,IN,TX
 S DIRB=$$RET^ZZLEXXDM("SH^ZZLEXXDB",DUZ,"Screen/Hostfile") S:$L(DIRB) DIR("B")=DIRB
 S DIR(0)="SAO^S:Screen;H:Hostfile"
 S DIR("A")=" Display to the Screen or write to Hostfile (S/H):  "
 S (DIR("?"),DIR("??"))="^D SHH^ZZLEXXDB"
 S DIR("PRE")="S:$L(X)&(X'[""^"")&(""^S^H^""'[(""^""_$$UP^XLFSTR($E(X,1))_""^"")) X=""??"""
 D ^DIR S:$D(DTOUT)!($D(DUOUT))!($D(DIROUT))!(Y'?4N) X="^" S X=$E($$UP^XLFSTR(Y),1)
 S TX="" S:Y="S" TX="Screen" S:Y="H" TX="Hostfile" Q:'$L(X) "^"
 D:$L(TX) SAV^ZZLEXXDM("SH^ZZLEXXDB",DUZ,"Screen/Hostfile",TX)
 Q X
SHH(X) ;   Screen/Hostfile Help
 N BOLD,NORM D ATTR^ZZLEXXDA W !,"    Enter '",$G(BOLD),"S",$G(NORM),"' to send the output to the ",$G(BOLD),"Screen",$G(NORM)
 W !,"       or '",$G(BOLD),"H",$G(NORM),"' to send the output to a ",$G(BOLD),"Hostfile",$G(NORM)
 D KATTR^ZZLEXXDA
 Q
TY(X) ;   Change Type
 N DIR,DIROUT,DIRUT,DUOUT,DTOUT,Y,ARY,MIN,MAX,CT,TY,I S CT=0,TY="CM"
 S DIR("A",1)=" ICD-10-CM Diagnosis Category Code Changes",DIR("A",2)=""
 I $L($O(^ZZLEXX("ZZLEXXD","CAT","CHG",TY,"AD",""))) D
 . N VAL,TX S VAL=$G(^ZZLEXX("ZZLEXXD","CAT","CHG",TY,"AD")),TX="AD^Diagnosis Category Code Added"
 . S:+VAL>0 TX=TX_$J(" ",(45-$L(TX)))_$J(VAL,6) S CT=CT+1 S ARY(CT)=TX
 I $L($O(^ZZLEXX("ZZLEXXD","CAT","CHG",TY,"SN",""))) D
 . N VAL,TX S VAL=$G(^ZZLEXX("ZZLEXXD","CAT","CHG",TY,"SN")),TX="SN^Diagnosis Category Name/Title Added"
 . S:+VAL>0 TX=TX_$J(" ",(45-$L(TX)))_$J(VAL,6) S CT=CT+1 S ARY(CT)=TX
 I $L($O(^ZZLEXX("ZZLEXXD","CAT","CHG",TY,"SR",""))) D
 . N VAL,TX S VAL=$G(^ZZLEXX("ZZLEXXD","CAT","CHG",TY,"SR")),TX="SR^Diagnosis Category Name/Title Revised"
 . S:+VAL>0 TX=TX_$J(" ",(45-$L(TX)))_$J(VAL,6) S CT=CT+1 S ARY(CT)=TX
 I $L($O(^ZZLEXX("ZZLEXXD","CAT","CHG",TY,"LN",""))) D
 . N VAL,TX S VAL=$G(^ZZLEXX("ZZLEXXD","CAT","CHG",TY,"LN")),TX="LN^Diagnosis Category Description Added"
 . S:+VAL>0 TX=TX_$J(" ",(45-$L(TX)))_$J(VAL,6) S CT=CT+1 S ARY(CT)=TX
 I $L($O(^ZZLEXX("ZZLEXXD","CAT","CHG",TY,"LR",""))) D
 . N VAL,TX S VAL=$G(^ZZLEXX("ZZLEXXD","CAT","CHG",TY,"LR")),TX="LR^Diagnosis Category Description Revised"
 . S:+VAL>0 TX=TX_$J(" ",(45-$L(TX)))_$J(VAL,6) S CT=CT+1 S ARY(CT)=TX
 S MIN=$O(ARY(0)),MAX=$O(ARY(" "),-1) Q:MIN'>0 "^"  I MIN=MAX S X=$G(ARY(MIN)) Q X
 S I=0 F  S I=$O(ARY(I)) Q:+I'>0  D
 . N ND,NM,CT S ND=$G(ARY(I)),NM=$P(ND,"^",2),CT=I+2,DIR("A",CT)="   "_$J(I,2)_".  "_NM
 S CT=$O(DIR("A"," "),-1)+1,DIR("A",CT)=" ",DIR(0)="NAO^"_MIN_":"_MAX_":0",DIR("A")=" Select changes to display:  "
 D ^DIR I +Y>0,$D(ARY(+Y)) S X=$G(ARY(+Y)) Q X
 Q "^"
