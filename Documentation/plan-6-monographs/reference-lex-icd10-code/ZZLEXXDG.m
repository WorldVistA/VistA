ZZLEXXDG ;SLC/KER - Import - ICD-10-CM Cat - Display (2) ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^UTILITY($J         ICR  10011
 ;    ^ZZLEXX("ZZLEXXD","CAT"      SACC 1.3
 ;               
 ; External References
 ;    ^DIWP               ICR  10011
 ;    $$FMTE^XLFDT        ICR  10103
 ;    $$UP^XLFSTR         ICR  10103
 ;               
 Q
 ; Main Entry Points
AD(X) ;   Added Entries
 N HFTYPE,HFSTA S HFTYPE="AD",HFSTA=0
 S:$L($G(HFNAME)) HFSTA=$$OPEN^ZZLEXXDE(HFNAME) D DAD($G(X))
 D:$L($G(HFNAME))&(+($G(HFSTA))>0) CLOSE^ZZLEXXDE(HFNAME) N HFNAME
 Q
SN(X) ;   Name/Title (short text) Added
 N HFTYPE,HFSTA S HFTYPE="SN",HFSTA=0
 S:$L($G(HFNAME)) HFSTA=$$OPEN^ZZLEXXDE($G(HFNAME)) D DNT($G(X),HFTYPE)
 D:$L($G(HFNAME))&(+($G(HFSTA))>0) CLOSE^ZZLEXXDE($G(HFNAME)) N HFNAME
 Q
SR(X) ;   Name/Title (short text) Revised
 N HFTYPE,HFSTA S HFTYPE="SR",HFSTA=0
 S:$L($G(HFNAME)) HFSTA=$$OPEN^ZZLEXXDE($G(HFNAME)) D DRT($G(X),HFTYPE)
 D:$L($G(HFNAME))&(+($G(HFSTA))>0) CLOSE^ZZLEXXDE($G(HFNAME)) N HFNAME
 Q
LN(X) ;   Description (long text) Added
 N HFTYPE,HFSTA S HFTYPE="LN",HFSTA=0
 S:$L($G(HFNAME)) HFSTA=$$OPEN^ZZLEXXDE($G(HFNAME)) D DNT($G(X),HFTYPE)
 D:$L($G(HFNAME))&(+($G(HFSTA))>0) CLOSE^ZZLEXXDE($G(HFNAME)) N HFNAME
 Q
LR(X) ;   Description (long text) Revised
 N HFTYPE,HFSTA S HFTYPE="LR",HFSTA=0
 S:$L($G(HFNAME)) HFSTA=$$OPEN^ZZLEXXDE($G(HFNAME)) D DRT($G(X),HFTYPE)
 D:$L($G(HFNAME))&(+($G(HFSTA))>0) CLOSE^ZZLEXXDE($G(HFNAME)) N HFNAME
 Q
 ; 
 ; Displays
DAD(X) ;   Display Added Entry
 W:$L($G(IOF))&('$L($G(HFNAME))) @IOF S:$D(LNCT) $Y=0
 N ARY,CONT,FRG,I,ORD,SUB,TXT,TY,TT,TAB S TY="CM"
 S TAB=$C(9),(CONT,ORD)="" F  S ORD=$O(^ZZLEXX("ZZLEXXD","CAT","CHG",TY,"AD",ORD)) Q:'$L(ORD)  D  Q:$G(CONT)["^"
 . N COD,EFF,HDR,SPC,NAM,DES,EXP,INC,CT,I,II,TI,TXT,TX
 . S COD=$G(^ZZLEXX("ZZLEXXD","CAT","CHG",TY,"AD",ORD,0))
 . S EFF=$P($G(^ZZLEXX("ZZLEXXD","CAT","CHG",TY,"AD",ORD,1)),"^",2)
 . S NAM=$G(^ZZLEXX("ZZLEXXD","CAT","CHG",TY,"AD",ORD,2))
 . S DES=$G(^ZZLEXX("ZZLEXXD","CAT","CHG",TY,"AD",ORD,3))
 . S EXP=$G(^ZZLEXX("ZZLEXXD","CAT","CHG",TY,"AD",ORD,4))
 . I $L($G(HFNAME)) D  Q
 . . N TXT,II,CT S TXT=COD_TAB_"Effective" S:$L(EFF) TXT=TXT_TAB_$$FMTE^XLFDT(EFF,"5Z") D OP(TXT)
 . . S TXT=TAB_TAB_"Name" S:$L(NAM) TXT=TXT_TAB_NAM D OP(TXT)
 . . S TXT=TAB_TAB_"Description" S:$L(DES) TXT=TXT_TAB_DES D OP(TXT)
 . . I $L(EXP) S TXT=TAB_TAB_"Explanation"_TAB_EXP D OP(TXT)
 . . S (II,CT)=0 F  S II=$O(^ZZLEXX("ZZLEXXD","CAT","CHG",TY,"AD",ORD,5,II)) Q:+II'>0  D  Q:$G(CONT)["^"
 . . . S INC=$G(^ZZLEXX("ZZLEXXD","CAT","CHG",TY,"AD",ORD,5,II))
 . . . I $L(INC) S TXT=TAB_TAB_"Includes"_TAB_INC D OP(TXT)
 . S TXT=" "_COD,TXT=TXT_$J(" ",(10-$L(TXT)))_"Effective",TXT=TXT_$J(" ",(23-$L(TXT)))_$$FMTE^XLFDT(EFF,"5Z") D WL(TXT)
 . K TX S TX(1)=NAM D PR(.TX,55)
 . S TXT="",TXT=TXT_$J(" ",(10-$L(TXT)))_"Name",TXT=TXT_$J(" ",(23-$L(TXT)))_TX(1) D:$L(TX(1)) WL(TXT)
 . S I=1 F  S I=$O(TX(I)) Q:+I'>0  Q:$G(CONT)["^"  S TXT="",TXT=TXT_$J(" ",(23-$L(TXT)))_TX(I) D:$L(TX(I)) WL(TXT)
 . K TX S TX(1)=DES D PR(.TX,55)
 . S TXT="",TXT=TXT_$J(" ",(10-$L(TXT)))_"Description",TXT=TXT_$J(" ",(23-$L(TXT)))_TX(1) D:$L(TX(1)) WL(TXT)
 . S I=1 F  S I=$O(TX(I)) Q:+I'>0  Q:$G(CONT)["^"  S TXT="",TXT=TXT_$J(" ",(23-$L(TXT)))_TX(I) D:$L(TX(I)) WL(TXT)
 . K TX S TX(1)=EXP D PR(.TX,55)
 . S TXT="",TXT=TXT_$J(" ",(10-$L(TXT)))_"Explanation",TXT=TXT_$J(" ",(23-$L(TXT)))_TX(1) D:$L(TX(1)) WL(TXT)
 . S I=1 F  S I=$O(TX(I)) Q:+I'>0  Q:$G(CONT)["^"  S TXT="",TXT=TXT_$J(" ",(23-$L(TXT)))_TX(I) D:$L(TX(I)) WL(TXT)
 . S HDR="",HDR=HDR_$J(" ",(10-$L(HDR)))_"Includes"
 . S SPC="",SPC=SPC_$J(" ",(10-$L(SPC)))_"        "
 . S (II,CT)=0 F  S II=$O(^ZZLEXX("ZZLEXXD","CAT","CHG",TY,"AD",ORD,5,II)) Q:+II'>0  D  Q:$G(CONT)["^"
 . . S TX(1)=$G(^ZZLEXX("ZZLEXXD","CAT","CHG",TY,"AD",ORD,5,II)) D PR(.TX,48)
 . . I $L(TX(1)) D
 . . . N LDR,TRL,TI S CT=CT+1
 . . . S TRL=$J(CT,2),TRL=TRL_$J(" ",(4-$L(TRL)))_TX(1)
 . . . S LDR=SPC S:CT=1 LDR=HDR
 . . . S TXT=LDR,TXT=TXT_$J(" ",(23-$L(TXT)))_TRL D WL(TXT) Q:$G(CONT)["^"
 . . . S TI=1 F  S TI=$O(TX(TI)) Q:+TI'>0  D  Q:$G(CONT)["^"
 . . . . N TXT S TXT=SPC,TXT="",TXT=TXT_$J(" ",(27-$L(TXT)))_TX(TI) D WL(TXT)
 Q
DNT(X,Y) ;   Display New Text Added
 W:$L($G(IOF))&('$L($G(HFNAME))) @IOF S:$D(LNCT) $Y=0
 N ARY,CONT,FRG,I,ORD,SUB,TXT,TY,TT,TAB S TY="CM"
 S TAB=$C(9),TT=$G(Y) Q:"^SN^LN^EN^"'[("^"_$G(TT)_"^")  S CONT="",ORD="",SUB=TT
 F  S ORD=$O(^ZZLEXX("ZZLEXXD","CAT","CHG",TY,SUB,ORD)) Q:'$L(ORD)  D  Q:$G(CONT)["^"
 . N FRG,ARY,TXT,WRN,TND,I S FRG=$TR(ORD," ",""),TND=$G(^ZZLEXX("ZZLEXXD","CAT","CHG",TY,SUB,ORD,0))
 . I $L($G(HFNAME)),$L(TND) D  Q
 . . N TXT,TTL S TTL=$$TTL(TT),TXT=FRG_TAB_"New "_TTL_TAB_TND D OP(TXT)
 . S ARY(1)=TND,WRN=$G(^ZZLEXX("ZZLEXXD","CAT","CHG",TY,SUB,ORD,0,"W"))
 . D PR(.ARY,68)
 . S TXT=" "_FRG S TXT=TXT_$J(" ",(10-$L(TXT)))_$G(ARY(1))
 . D WL(TXT)
 . S I=1 F  S I=$O(ARY(I)) Q:+I'>0  D  Q:$G(CONT)["^"
 . . S TXT="",TXT=TXT_$J(" ",(10-$L(TXT)))_$G(ARY(I))
 . . D WL(TXT)
 . I $L(WRN) S TXT="" S TXT=TXT_$J(" ",(15-$L(TXT)))_WRN D WL(TXT)
 D WL(" ")
 Q 
DRT(X,Y) ;   Display Revised Text
 W:$L($G(IOF))&('$L($G(HFNAME))) @IOF S:$D(LNCT) $Y=0
 N BOLD,NORM D ATTR^ZZLEXXDA N ARY,CONT,FRG,I,ORD,TXT,TY,TT,TAB S TY="CM"
 S TAB=$C(9),TT=$G(Y) Q:"^SR^LR^ER^"'[("^"_$G(TT)_"^")
 S ORD="",SUB=TT
 F  S ORD=$O(^ZZLEXX("ZZLEXXD","CAT","CHG",TY,SUB,ORD)) Q:'$L(ORD)  D  Q:$G(CONT)["^"
 . N FRG,ARY,TXT,WRN,TND,I S FRG=$TR(ORD," ",""),TND=$G(^ZZLEXX("ZZLEXXD","CAT","CHG",TY,SUB,ORD,0))
 . I $L($G(HFNAME)),$L(TND) D  Q
 . . N TXT,TTL,TND
 . . S TND=$G(^ZZLEXX("ZZLEXXD","CAT","CHG",TY,SUB,ORD,0))
 . . I $L(TND) S TTL=$$TTL(TT),TXT=FRG_TAB_"Revised "_TTL_" (new)"_TAB_TND D OP(TXT)
 . . S TND=$G(^ZZLEXX("ZZLEXXD","CAT","CHG",TY,SUB,ORD,1))
 . . I $L(TND) S TTL=$$TTL(TT),TXT=FRG_TAB_"Revised "_TTL_" (old)"_TAB_TND D OP(TXT)
 . K ARY S ARY(1)=TND,WRN=$G(^ZZLEXX("ZZLEXXD","CAT","CHG",TY,SUB,ORD,0,"W")) D PR(.ARY,63)
 . S TXT=" "_FRG,TXT=TXT_$J(" ",(10-$L(TXT)))_"New",TXT=TXT_$J(" ",(15-$L(TXT)))_$G(ARY(1))
 . D WL(TXT) Q:$G(CONT)["^"
 . S I=1 F  S I=$O(ARY(I)) Q:+I'>0  D  Q:$G(CONT)["^"
 . . S TXT="",TXT=TXT_$J(" ",(15-$L(TXT)))_$G(ARY(I))
 . . D WL(TXT)
 . S TND=$G(^ZZLEXX("ZZLEXXD","CAT","CHG",TY,SUB,ORD,1)) K ARY S ARY(1)=TND D PR(.ARY,63)
 . S TXT="",TXT=TXT_$J(" ",(10-$L(TXT)))_"Old",TXT=TXT_$J(" ",(15-$L(TXT)))_$G(ARY(1))
 . D WL(TXT) Q:$G(CONT)["^"
 . S I=1 F  S I=$O(ARY(I)) Q:+I'>0  D  Q:$G(CONT)["^"
 . . S TXT="",TXT=TXT_$J(" ",(15-$L(TXT)))_$G(ARY(I))
 . . D WL(TXT)
 . I $L(WRN) D
 . . Q:'$D(WARNING)!(WRN'["WARNING:")
 . . S TXT="" S TXT=TXT_$J(" ",(15-$L(TXT)))_$G(BOLD)_"WARNING:"_$G(NORM)
 . . S TXT=TXT_$P(WRN,"WARNING:",2) D WL(TXT)
 D WL(" ")
 D KATTR^ZZLEXXDA
 Q 
 ;
WARN ; Display Warnings
 N MET,TOT W ! S MET=$$PS^ZZLEXXDM I MET["^" W !!," Display method not selected",! Q
 W:$L($G(IOF))&('$L($G(HFNAME))) @IOF S:$D(LNCT) $Y=0
 I '$D(^ZZLEXX("ZZLEXXD","CAT","CHG","WARN")) W !!," No warning to report" Q
 S TOT=0 D ATTR^ZZLEXXDA D WL(" ") N TY,CONT S CONT="" S TY="CM" Q:$G(CONT)["^"
 Q:'$D(^ZZLEXX("ZZLEXXD","CAT","CHG","WARN",TY))  N TXT S TXT=" ICD-10-CM Diagnosis Warnings"
 Q:'$L(TXT)  D WL(TXT),WL(" ")
 N ORD S ORD="" F  S ORD=$O(^ZZLEXX("ZZLEXXD","CAT","CHG","WARN",TY,ORD)) Q:'$L(ORD)  D  Q:$G(CONT)["^"
 . N NID,INC,ORC S ORC=0 F NID=2:1:4 D
 . . N TX,TXT,WAR,COD,I S COD=$TR(ORD," ","") Q:'$L(COD)
 . . K TX S TX(1)=$G(^ZZLEXX("ZZLEXXD","CAT","CHG","WARN",TY,ORD,NID,0))
 . . S WAR=$G(^ZZLEXX("ZZLEXXD","CAT","CHG","WARN",TY,ORD,NID,1)) Q:'$L(WAR)
 . . I $L(TX(1)) D
 . . . D PR(.TX,67) S ORC=+($G(ORC))+1
 . . . S TXT="   "_COD S:ORC'=1 TXT=""
 . . . S TXT=TXT_$J(" ",(11-$L(TXT)))_$G(TX(1)) D WL(TXT)
 . . . S I=1 F  S I=$O(TX(I)) Q:+I'>0  D  Q:$G(CONT)["^"
 . . . . S TXT="",TXT=TXT_$J(" ",(11-$L(TXT)))_$G(TX(I)) D WL(TXT)
 . . . S TXT="",TXT=TXT_$J(" ",(11-$L(TXT)))_WAR,TXT=$G(BOLD)_TXT_$G(NORM) D WL(TXT),WL(" ") S TOT=+($G(TOT))+1
 . . I '$L(TX(1)) D
 . . . S TXT="   "_COD,TXT=TXT_$J(" ",(11-$L(TXT)))_$G(BOLD)_WAR_$G(NORM) D WL(TXT),WL(" ") S TOT=+($G(TOT))+1
 . S NID=5,INC=0 F  S INC=$O(^ZZLEXX("ZZLEXXD","CAT","CHG","WARN",TY,ORD,NID,INC)) Q:+INC'>0  D  Q:$G(CONT)["^"
 . . N TX,TXT,WAR,COD S COD=$TR(ORD," ","") Q:'$L(COD)
 . . S TX(1)=$G(^ZZLEXX("ZZLEXXD","CAT","CHG","WARN",TY,ORD,NID,INC,0)) Q:'$L(TX(1))
 . . S WAR=$G(^ZZLEXX("ZZLEXXD","CAT","CHG","WARN",TY,ORD,NID,INC,1)) Q:'$L(WAR)
 . . D PR(.TX,67) S ORC=+($G(ORC))+1
 . . S TXT="   "_COD S:ORC'=1 TXT=""
 . . S TXT=TXT_$J(" ",(11-$L(TXT)))_$G(TX(1)) D WL(TXT)
 . . S I=1 F  S I=$O(TX(I)) Q:+I'>0  D  Q:$G(CONT)["^"
 . . . S TXT="",TXT=TXT_$J(" ",(11-$L(TXT)))_$G(TX(I)) D WL(TXT)
 . . S TXT="",TXT=TXT_$J(" ",(11-$L(TXT)))_WAR,TXT=$G(BOLD)_TXT_$G(NORM) D WL(TXT),WL(" ") S TOT=+($G(TOT))+1
 I +($G(TOT))>0 D
 . N TXT S TXT=+($G(TOT))_" error"_$S(+($G(TOT))>1:"s ",1:" ")_"found." D WL(TXT),WL(" ")
 D KATTR^ZZLEXXDA
 Q
 ;
 ; Miscellaneous
WL(X) ;   Write Line
 I '$D(LNCT) W !,$G(X) Q
 W !,$G(X) S LNCT=$Y I LNCT>19 D
 . Q:$L($G(HFNAME))  W ! S CONT=$$CONT^ZZLEXXDA W:$L($G(IOF)) @IOF S LNCT=0
 Q 
OP(X) ;   Output Line (no page breaks)
 U IO W !,$G(X) U:$L($G(IO(0))) IO(0)
 Q 
TTL(X) ;   Title
 S X=$E($$UP^XLFSTR($G(X)),1) Q:X=1 "Effective"  Q:X="S"!(X=2) "Name/Title"  Q:X="L"!(X=3) "Description"
 Q:X="E"!(X=4) "Explanation"  Q:X="I"!(X=5) "Includes"
 Q ""
PR(LEX,X) ;   Parse Array
 N DIW,DIWF,DIWI,DIWL,DIWR,DIWT,DIWTC,DIWX,DN,LEXC,LEXI,LEXL,Z
 K ^UTILITY($J,"W") Q:'$D(LEX)  S LEXL=+($G(X)) S:+LEXL'>0 LEXL=79
 S LEXC=+($G(LEX)) S:+($G(LEXC))'>0 LEXC=$O(LEX(" "),-1) Q:+LEXC'>0
 S DIWL=1,DIWF="C"_+LEXL S LEXI=0
 F  S LEXI=$O(LEX(LEXI)) Q:+LEXI=0  S X=$G(LEX(LEXI)) D ^DIWP
 K LEX S (LEXC,LEXI)=0
 F  S LEXI=$O(^UTILITY($J,"W",1,LEXI)) Q:+LEXI=0  D
 . S LEX(LEXI)=$$TM($G(^UTILITY($J,"W",1,LEXI,0))," "),LEXC=LEXC+1
 S:$L(LEXC) LEX=LEXC K ^UTILITY($J,"W") N LNCT,WARNING
 Q
TM(X,Y) ;   Trim Character Y - Default " "
 S X=$G(X) Q:X="" X  S Y=$G(Y) S:'$L(Y) Y=" "
 F  Q:$E(X,1)'=Y  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=Y  S X=$E(X,1,($L(X)-1))
 Q X
