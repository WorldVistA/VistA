ZZLEXXDP ;SLC/KER - Import - ICD-10-CM Cat - Prompts ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^LEX(757.02,        SACC 1.3
 ;    ^LEX(757.033,       SACC 1.3
 ;    ^UTILITY($J         ICR  10011
 ;               
 ; External References
 ;    ENDR^%ZISS          ICR  10088
 ;    KILL^%ZISS          ICR  10088
 ;    ^DIR                ICR  10026
 ;    ^DIWP               ICR  10011
 ;    $$DT^XLFDT          ICR  10103
 ;    $$FMTE^XLFDT        ICR  10103
 ;    $$UP^XLFSTR         ICR  10103
 ;               
 Q
WAR(X) ; Warnings
 N VAL,GBLD,HF,ED,CURR,LAST S HF=$$UP^XLFSTR($G(X)),GBLD=$$GBLD(HF),ED=$P($$DEFF^ZZLEXXDP(HF),"^",1),CURR=$P(GBLD,"^",1),LAST=$P(GBLD,"^",2)
 Q:ED'?7N 0  Q:LAST?7N&(+ED>LAST) 1  Q:CURR'?7N 1
 S:ED?7N&(LAST?7N)&(CURR?7N)&(ED'<LAST) VAL=$$WARLP(HF,ED,GBLD)
 S:ED?7N&(LAST?7N)&(CURR?7N)&(ED<LAST) VAL=$$WARLE(HF,ED,GBLD)
 I $D(DIROUT)!($D(DIRUT))!($D(DTOUT))!($D(DUOUT))!($G(VAL)["^") Q "^"
 S X=0 S:+VAL>0 X=1
 Q X
WARLP(X,Y,Z) ;   Warning - Loaded Previously
 N HF,ED,LAST,CURR,NOM,TYP,TTL,DIR
 S HF=$$UP^XLFSTR($G(X)),ED=$G(Y),LAST=$G(Z),CURR=$P(LAST,"^",1),LAST=$P(LAST,"^",2) Q:HF'["CM"&(HF'["cm") 0
 S (NOM,TYP)="" S NOM="ICD-10-CM",TYP="Categories"
 S TTL=NOM S:$L($G(TYP)) TTL=TTL_" "_TYP
 S DIR("A")=" Do you want to continue?  (Y/N)  ",DIR("B")="No"
 S DIR("PRE")="S:X[""?"" X=""??""",(DIR("?"),DIR("??"))="^D WARLPH^ZZLEXXDP"
 D WARLPI,^DIR S X=Y
 Q X
WARLPI ;     Warning - Loaded Previously Intro
 D ATTR
 W !,?1,"Data from file ",$G(HF)," was already loaded.  "
 I $G(ED)?7N,$G(LAST)?7N W ! D
 . W !,?4,"Read host file data with effective:    ",$G(BOLD),$$FMTE^XLFDT($G(ED)),$G(NORM)
 . W !,?4,"on top of global data with effective:  ",$G(BOLD),$$FMTE^XLFDT($G(LAST)),$G(NORM),!
 W !,?4,"Reloading ",$G(TTL)," data of the same date "
 W !,?4,$G(BOLD),"may have no effect.",$G(NORM) W !
 D KATTR
 Q
WARLPH ;     Warning - Loaded Previously Help
 D ATTR
 W !,?4,"Answer """,$G(BOLD),"Yes",$G(NORM),""" to read the data in host file ",$G(HF),!
 W !,?8,"This is ",$G(BOLD),"not recommended",$G(NORM),".  Reading and loading this data is "
 W !,?8,"redundant since this data was previously loaded.  However, "
 W !,?8,"reading and loading the same data a second time may be useful"
 W !,?8,"to test the load since the second load should result in no "
 W !,?8,"changes made.",!
 W !,?4,"Answer """,$G(BOLD),"No",$G(NORM),""" to abort the load and exit.",!
 W !,?8,"This is ",$G(BOLD),"highly recommended",$G(NORM),"."
 D KATTR
 Q
WARLE(X,Y,Z) ;   Warning - Load Error
 N HF,ED,LAST,CURR,NOM,TYP,TTL,DIR
 S HF=$$UP^XLFSTR($G(X)),ED=$G(Y),LAST=$G(Z),CURR=$P(LAST,"^",1),LAST=$P(LAST,"^",2)
 S (NOM,TYP)="" S NOM="ICD-10-CM",TYP="Categories" Q:HF'["CM"&(HF'["cm") 0  S DIR(0)="YAO"
 S TTL=NOM S:$L($G(TYP)) TTL=TTL_" "_TYP
 S DIR("A")=" Do you want to continue?  (Y/N)  ",DIR("B")="No"
 S DIR("PRE")="S:X[""?"" X=""??""",(DIR("?"),DIR("??"))="^D WARLEH^ZZLEXXDP"
 D WARLEI,^DIR S X=Y
 Q X
WARLEI ;     Warning - Load Error Intro
 D ATTR
 W !,?1,"Data from file ",$G(HF)," was already loaded and data"
 W !,?1,"from a later host file was also loaded. "
 I $G(ED)?7N,$G(LAST)?7N W ! D
 . W !,?4,"Load host file data effective:    ",$G(BOLD),$$FMTE^XLFDT($G(ED)),$G(NORM)
 . W !,?4,"on top of global data effective:  ",$G(BOLD),$$FMTE^XLFDT($G(LAST)),$G(NORM),!
 W !,?4,"Reloading this file at this time ",$G(BOLD),"could cause irreparable",$G(NORM)
 W !,?4,$G(BOLD),"damage, creating the necessity to have the account restored",$G(NORM)
 W !,?4,$G(BOLD),"to a gold state.",$G(NORM) W !
 Q
 D KATTR
WARLEH ;     Warning - Load Error Help
 D ATTR
 W !,?4,"Answer """,$G(BOLD),"Yes",$G(NORM),""" to read the data in host file ",$G(HF),!
 W !,?8,"This is ",$G(BOLD),"not recommended",$G(NORM),"  Reading and loading older data will"
 W !,?8,"corrupt the data currently on file and require the account to "
 W !,?8,"be restored to gold.  There is no scenario where loading older "
 W !,?8,"data would produce meaningful results.",!
 W !,?4,"Answer """,$G(BOLD),"No",$G(NORM),""" to abort the load and exit. ",!
 W !,?8,"This is ",$G(BOLD),"highly recommended",$G(NORM),"."
 D KATTR
 Q
 ;
STOP(X) ; Stop, do not continue
 N CD,CONT,CY,EXIT,FD,FMT,FY,HF,I,LATER,NOM,STR1,STR2,TD,TX1,TX2,TY,TYP,UHF,Y,YR,YRS S (LATER,HF)=$G(X),UHF=$$UP^XLFSTR(HF) Q:UHF'["CM" 0
 S FY=$$FY(UHF),FD=$P(FY,"^",2),FY=$P(FY,"^",1)
 S TD=$$TI(UHF),TY=$P(TD,"^",1),TD=$P(TD,"^",2) Q:FY=TY 0
 S CD=$$FI(UHF),CY=$P(CD,"^",1),CD=$P(CD,"^",2)
 S (NOM,TYP,FMT,STR1,STR2)="" S NOM="ICD-10-CM",TYP="Diagnosis",FMT="Categories"
 S:$L(NOM) STR1=NOM S:$L($G(TYP)) STR1=STR1_" "_$G(TYP) S:$L($G(FMT)) STR1=STR1_" "_$G(FMT) S STR1=$$TM($G(STR1))
 S TYP="Diagnostic" S FMT="Terminology"
 S:$L(NOM) STR2=NOM S:$L($G(TYP)) STR2=STR2_" "_$G(TYP) S:$L($G(FMT)) STR2=STR2_" "_$G(FMT) S STR2=$$TM($G(STR2))
 I FY'=TY F  Q:LATER'[FY  S LATER=$P(LATER,FY,1)_TY_$P(LATER,FY,2,299)
 S YRS="" S:FY-TY=1 YRS=FY
 I (FY-TY)>0 D
 . N YR S YRS="" F YR=TY:1 Q:YR>FY  S:YR>TY&(YR'>FY) YRS=YRS_", "_YR
 . S:YRS[", " YRS=$P(YRS,", ",1,($L(YRS,", ")-1))_" and "_$P(YRS,", ",$L(YRS,", ")) S YRS=$$CS(YRS)
 . K TX1,TX2 S TX1(1)="Cannot install "_STR1_" (FY "_FY_") on top of "_STR2_" (FY "_TY_")."
 . S TX2(2)="Install the ICD terminology for FY "_YRS_" first, then retry installing the "_STR1_" for FY "_FY_"."
 I (FY-TY)<0 D
 . N YR S YRS="" F YR=TY:1 Q:YR>FY  S:YR>TY&(YR'>FY) YRS=YRS_", "_YR
 . S:YRS[", " YRS=$P(YRS,", ",1,($L(YRS,", ")-1))_" and "_$P(YRS,", ",$L(YRS,", ")) S YRS=$$CS(YRS)
 . K TX1,TX2 S TX1(1)="Cannot install "_STR1_" (FY "_FY_") on top of "_STR2_" (FY "_TY_")."
 . S TX2(2)="Select the host file "_LATER_" and install the "_STR1_" for FY "_TY_"."
 . Q
 D PR(.TX1,60),PR(.TX2,60)
 S I=0 F  S I=$O(TX1(I)) Q:+I'>0  W !,?4,$G(TX1(I))
 W ! S I=0 F  S I=$O(TX2(I)) Q:+I'>0  W !,?4,$G(TX2(I))
 S X=$$CONT
 Q 1
 ;
 ; Miscellaneous
FY(X) ;   File Fiscal Year and Date
 N HF,FY,FD S HF=$$UP^XLFSTR($G(X)) S X="" Q:'$L(HF) X  S FY=$P(HF,".",1),FY=$E(FY,($L(FY)-3),$L(FY)) Q:FY'?4N X
 S FD=((FY-1)-1700)_"1001" Q:FD'?7N X  S X=FY_"^"_FD
 Q X
FI(X) ;   Fragments Fiscal Year and Date
 N FY,IN,HF S HF=$$UP^XLFSTR($G(X)),IN=$$GBLD($G(HF)),IN=$P(IN,"^",2),FY=$E(IN,1,3)
 S X="" Q:IN'?7N X  Q:FY'?3N X  S FY=(FY+1700)+1 S X=FY_"^"_IN
 Q X
TI(X) ;   Terminology Fiscal Year and Date
 N FY,IN,HF,SAB S HF=$$UP^XLFSTR($G(X)) S (X,SAB)="" Q:HF'["CM"&(HF'["cm") X  S SAB="10D"
 S LAST=9999999 F  S LAST=$O(^LEX(757.02,"AUPD",SAB,LAST),-1) Q:+LAST'>0  Q:$E(LAST,4,7)="1001"
 Q:LAST'?7N X  S FY=$E(LAST,1,3) Q:FY'?3N X  S FY=(FY+1700)+1 S X=FY_"^"_LAST
 Q X
GBLD(X) ;   Global Dates
 N GBLD,HF,HFD,SRC,CURR,LAST,ORD,EFF S HF=$G(X),HFD=$P($$DEFF(HF),"^",1) Q:HF'["CM"&(HF'["cm") ""  S SRC=30
 S CURR="",LAST=0,ORD="" F  S ORD=$O(^LEX(757.033,"AFRAG",SRC,ORD)) Q:'$L(ORD)  D
 . S EFF="" F  S EFF=$O(^LEX(757.033,"AFRAG",SRC,ORD,EFF)) Q:'$L(EFF)  D
 . . Q:EFF'?7N  S:+EFF>LAST LAST=EFF S:EFF=HFD CURR=EFF
 S X=CURR_"^"_LAST
 Q X
DEFF(X) ;   Default Effective Date
 N DEF,TD,YR S TD=$$DT^XLFDT,YR=$$UP^XLFSTR($G(X)) I YR'?4N D
 . S YR=$P(YR,".TXT",1),YR=$E(YR,($L(YR)-3),$L(YR)) S:YR?4N YR=YR-1
 S DEF="" S:YR?4N DEF=(YR-1700)_"1001"
 S X="" S:DEF?7N X=DEF_"^"_$$FMTE^XLFDT(DEF,"5Z")
 Q X
SUB(X) ;   Subscript
 S X=$$LR_"T"
 Q X
LR(X) ;   Local Routine
 S X=$T(+1),X=$P(X," ",1)
 Q X
ATTR ;   Screen Attributes
 N X,%,IOINHI,IOINORM S X="IOINHI;IOINORM" D ENDR^%ZISS S BOLD=$G(IOINHI),NORM=$G(IOINORM) Q
KATTR ;   Kill Screen Attributes
 D KILL^%ZISS K IOINHI,IOINORM,BOLD,NORM
 Q
PR(LEX,X) ;   Parse Array using FileMan
 N %,DIW,DIWF,DIWI,DIWL,DIWR,DIWT,DIWTC,DIWX,DN,LEXC,LEXI,LEXL,Z
 K ^UTILITY($J,"W") Q:'$D(LEX)  S LEXL=+($G(X)) S:+LEXL'>0 LEXL=79
 S LEXC=+($G(LEX)) S:+($G(LEXC))'>0 LEXC=$O(LEX(" "),-1) Q:+LEXC'>0
 S DIWL=1,DIWF="C"_+LEXL S LEXI=0
 F  S LEXI=$O(LEX(LEXI)) Q:+LEXI=0  S X=$G(LEX(LEXI)) D ^DIWP
 K LEX S (LEXC,LEXI)=0
 F  S LEXI=$O(^UTILITY($J,"W",1,LEXI)) Q:+LEXI=0  D
 . S LEX(LEXI)=$$TM($G(^UTILITY($J,"W",1,LEXI,0))," "),LEXC=LEXC+1
 S:$L(LEXC) LEX=LEXC K ^UTILITY($J,"W")
 Q
CONT(X) ;   Continue
 Q:+($G(EXIT))>0 "^"  Q:$G(CONT)["^" "^"  N DIR,DIROUT,DIRUT,DUOUT,DTOUT,Y S DIR(0)="FAO^1:30"
 S DIR("A")="      Press <Enter> to continue or '^' to exit "
 S DIR("A")="        Press <Enter> to continue"
 S DIR("PRE")="S:X[""^^"" X=""^^"" S:X'[""^^""&(X[""^"") X=""^"" S:X[""?"" X=""??"" S:X'[""^""&(X'[""?"") X="""""
 S (DIR("?"),DIR("??"))="^D CONTH^ZZLEXXMF" W ! D ^DIR S:$D(DIROUT)!($D(DUOUT)) EXIT=1 Q:$D(DIROUT) "^^"  Q:$D(DUOUT) "^"  Q:X["^" "^" Q ""
 Q ""
CONTH ;   Continue Help
 W !,"        Press <Enter> to continue or '^' to exit"
 Q
CS(X) ;   Comma Space
 S X=$G(X) Q:X="" X
 F  Q:$E(X,1)'=","&($E(X,1)'=" ")  S X=$E(X,2,$L(X))
 F  Q:$E(X,1)'=","&($E(X,1)'=" ")  S X=$E(X,1,($L(X)-1))
 Q X
TM(X,Y) ;   Trim Character Y - Default " "
 S X=$G(X) Q:X="" X  S Y=$G(Y) S:'$L(Y) Y=" "
 F  Q:$E(X,1)'=Y  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=Y  S X=$E(X,1,($L(X)-1))
 Q X
