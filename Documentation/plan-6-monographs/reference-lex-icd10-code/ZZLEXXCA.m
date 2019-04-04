ZZLEXXCA ;SLC/KER - Import - Conflicts - Main ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    None
 ;               
 ; External References
 ;    HOME^%ZIS           ICR  10086
 ;    ^DIM                ICR  10016
 ;    $$GET1^DIQ          ICR   2056
 ;    ^DIR                ICR  10026
 ;    $$DT^XLFDT          ICR  10103
 ;               
EN ; Main Entry Point
 D HOME^%ZIS W:$L($G(IOF)) @IOF N COMMIT,ACT,ENV,EXC,RES,TEST,X S ENV=$$ENV Q:'ENV
 S ACT=$$ACT,EXC=$P(ACT,"^",2,299),RES=$P(ACT,"^",1)
 I (+RES'>0&(ACT["^"))!(ACT="^") W !!,?4,"ICD-10 Conflict Update (Help/Load) not selected",! Q
 K COMMIT,TEST S X=EXC D ^DIM X:$D(X) EXC
 Q
 ;
ACT(X) ; Select Action (Help/Load)
 N IND,DIR,DTOUT,DUOUT,DIRUT,DIROUT,Y S IND=5
 S DIR(0)="SAO^H:Help Loading Conflicts;L:Load Conflicts"
 D ATTR^ZZLEXXCM
 W !!," Update ICD-10 Conflict Fields",!
 W !,"   ",$G(BOLD),"H",$G(NORM),"  Help Loading Conflicts"
 W !,"   ",$G(BOLD),"L",$G(NORM),"  Load Conflicts"
 D KATTR^ZZLEXXCM
 S DIR("A")=" Select Conflict Update Action (Help/Load):  (H/L)  "
 S (DIR("?"),DIR("??"))="^D ACTH^ZZLEXXCA"
 S DIR("PRE")="S X=$$UP^XLFSTR(X) S:X[""?"" X=""??"" S:$L($$TM^ZZLEXXCA(X))&(X'[""^"")&(""^H^L^""'[(""^""_X_""^"")) X=""??"""
 W ! D ^DIR S X=0 S:Y="H" X="1^D HELP^ZZLEXXCH" S:Y="L" X="1^D LOAD^ZZLEXXCB"
 Q:+X'>0 "^"
 Q X
ACTH ;   Select Action (Help/Load) Help
 S IND=+($G(IND)) D ATTR^ZZLEXXCM
 W !,?(IND),"Enter",?(IND+6)
 W !,?(IND+2),$G(BOLD),"H",$G(NORM),?(IND+6),"Display Help on how to download the data, "
 W !,?(IND+6),"FTP the data and Load the data.",!
 W !,?(IND+2),$G(BOLD),"L",$G(NORM),?(IND+6),"Load the data.  Data includes:",!
 W !,?(IND+8)," Unacceptable as Principal Dx"
 W !,?(IND+8)," Age Low/Age High Conflicts"
 W !,?(IND+8)," Sex Conflicts"
 D KATTR^ZZLEXXCM
 Q
 ; 
 ; Miscellaneous
TM(X,Y) ;   Trim Character Y - Default " " Space
 S X=$G(X) Q:X="" X  S Y=$G(Y) S:'$L(Y) Y=" "
 F  Q:$E(X,1)'=Y  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=Y  S X=$E(X,1,($L(X)-1))
 Q X
KILL ;   Kill Global
 K ^ZZLEXX("ZZLEXXC",$J),^ZZLEXX("ZZLEXXCM",$J),^ZZLEXX("ZZLEXXCH",$J)
 Q
LR(X) ;   Local Routine
 S X=$T(+1),X=$P(X," ",1) Q X
ENV(X) ;   Environment
 N BOLD,NORM D HOME^%ZIS S U="^",DT=$$DT^XLFDT,DTIME=300 K POP
 N NM S NM=$$GET1^DIQ(200,(DUZ_","),.01)
 I '$L(NM) W !!,?5,"Invalid/Missing DUZ" Q 0
 S:$G(DUZ(0))'["@" DUZ(0)=$G(DUZ(0))_"@"
 Q 1
