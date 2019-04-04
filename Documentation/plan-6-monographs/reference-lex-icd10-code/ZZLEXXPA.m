ZZLEXXPA ;SLC/KER - Import - Changes ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^%ZOSF("TEST"       ICR  10096
 ;    ^DISV(              ICR    510
 ;    ^ZZLEXX("ZZLEXXP"   SACC 2.3.2.5.1
 ;               
 ; External References
 ;    HOME^%ZIS           ICR  10086
 ;    $$GET1^DIQ          ICR   2056
 ;    ^DIR                ICR  10026
 ;    $$DT^XLFDT          ICR  10103
 ;    $$UP^XLFSTR         ICR  10104
 ;               
EN ; Change Listing Main Entry Point
 N EFF,ENV,LN,LOC,REMOTE,STR,TODAY S ENV=$$ENV G:+ENV'>0 ENQ W:$L($G(IOF)) @IOF
 K ^ZZLEXX("ZZLEXXP",$J) S STR="Find ICD-10 Changes" S LOC=$$LOC S:$L(LOC) STR=STR_" in "_LOC
 S LN="",$P(LN,"=",$L(STR))="=" W !," ",STR,!," ",LN,!
 S REMOTE=$$REM I '$L(LOC)!('$L(REMOTE))!($G(REMOTE)="^") W !!,?6,"Namespace not Selected",! G ENQ
 D GET
 S TODAY=$$DT^XLFDT D PT^ZZLEXXPE,PD^ZZLEXXPE
 I '$D(^ZZLEXX("ZZLEXXP",$J,"OUT")) W !!,?6,"No changes found",! G ENQ
 D DSP^ZZLEXXPF
ENQ ;   Quit Main
 K ^ZZLEXX("ZZLEXXP",$J)
 Q
GET ;   Get Changes
 W !!,"   Finding changes",!
 W !,"      ICD-10-CM Diagnosis Changes" D DX^ZZLEXXPB
 W !,"      ICD-10-PCS Procedure Changes" D OP^ZZLEXXPC
 W !,"      ICD-10 Categories/Code Fragment Changes" D CP^ZZLEXXPD
 Q
REM(X) ; Get Remote Namespace
 N DIR,DIRB,DIROUT,DIRUT,DTOUT,DUOUT,LOUD,Y S LOUD=1
 S DIR(0)="FAO^3:10^K:+($$RNIT^ZZLEXXPA(X))'>0 X"
 S:$L($G(^DISV(.5,"REM^ZZLEXXPA"))) DIR("B")=$G(^DISV(.5,"REM^ZZLEXXPA"))
 S DIR("A")="   Select a Remote Namespace:  "
 S (DIR("?"),DIR("??"))="^D RNH^ZZLEXXPA"
 D ^DIR S X=$$UP^XLFSTR(Y) S:'$L(X) X="^" S:$D(DTOUT)!($D(DUOUT))!($D(DIRUT))!($D(DIROUT)) X="^"
 S:X'["^" ^DISV(.5,"REM^ZZLEXXPA")=X N PSUM
 Q X
RNH ;   Namespace Help   ? and ??
 N EX,LNS S EX="S LNS=$ZNSPACE" X EX
 W !,?8,"Response must be from 3 to 10 characters in length and the name"
 W !,?8,"of a valid Namespace, other than the current Namespace (",LNS,")."
 W !,?8,"This remote name space is used to gather data for the change"
 W !,?8,"listing."
 Q
RNIT(X) ;   Namespace Input
 N ENS,EX,LNS S ENS=$G(X),EX="S LNS=$ZNSPACE" X EX S X=$$UP^XLFSTR($G(X)),X=$TR($G(X),"""","")
 S X=$TR($G(X),"[",""),X=$TR($G(X),"]",""),X=$TR($G(X),"|","")
 I '$L(X) W:+($G(LOUD))>0 !!,?6,"No Namespace entered." Q 0
 I X'?1U.UN W:+($G(LOUD))>0 !!,?6,"Namespace must start with uppercase alpha character." Q 0
 I X=LNS W:+($G(LOUD))>0 !!,?6,"Namespace can not be the current namespace (",LNS,")" Q 0
 S EX="S X=$ZU(90,10,X)" X EX
 I +($G(X))'>0 W:+($G(LOUD))>0 !!,?6,ENS," is not a valid Namespace"
 Q X
 ;
LOC(X) ;   Local Namespace
 N EX,LNS S EX="S LNS=$ZNSPACE" X EX
 S X=$G(LNS)
 Q X
 ;
 ; Miscellaneous
END ;   Clean Up
 K ^ZZLEXX("ZZLEXXP",$J)
 Q
ROK(X) ;   Routine OK (in UCI)
 S X=$G(X) Q:'$L(X) 0  Q:$L(X)>8 0  X ^%ZOSF("TEST") Q:$T 1  Q 0
ENV(X) ; Environment
 D HOME^%ZIS S U="^",DT=$$DT^XLFDT,DTIME=300 K POP
 N NM S NM=$$GET1^DIQ(200,(DUZ_","),.01)
 I '$L(NM) W !!,?5,"Invalid/Missing DUZ" Q 0
 S:$G(DUZ(0))'["@" DUZ(0)=$G(DUZ(0))_"@"
 Q 1
