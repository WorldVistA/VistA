ZZLEXXDA ;SLC/KER - Import - ICD-10-CM Cat - Main ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^LEX(757.033,       SACC 1.3
 ;    ^ZZLEXX("ZZLEXXD"   SACC 1.3
 ;               
 ; External References
 ;    HOME^%ZIS           ICR  10088
 ;    ENDR^%ZISS          ICR  10088
 ;    KILL^%ZISS          ICR  10088
 ;    IX1^DIK             ICR  10013
 ;    IX2^DIK             ICR  10013
 ;    GET1^DIQ            ICR   2056
 ;    ^DIR                ICR  10026
 ;    $$DT^XLFDT          ICR  10103
 ;               
EN ; Main Entry Point 
 N ENV,RCLDH,OUT,CONT,MAXLEN S ENV=$$ENV Q:ENV'>0  S MAXLEN=$$MAX Q:+($G(MAXLEN))'>0  F  D  Q:'$L(OUT)  Q:OUT="^"  Q:$G(CONT)["^"
 . N DONE W:$L($G(IOF)) @IOF S (OUT,RCLDH)=$$RCLDH
 . I "^R^C^D^L^I^"'[("^"_RCLDH_"^") S CONT="^" Q
 . D:"^R^"[("^"_RCLDH_"^") READ D:"^C^"[("^"_RCLDH_"^") COMP
 . D:"^D^"[("^"_RCLDH_"^") DISP D:"^L^"[("^"_RCLDH_"^") LOAD
 . D:"^I^"[("^"_RCLDH_"^") INIT
 . S:'$D(DONE) CONT=$$CONT
 . W:$L($G(IOF)) @IOF
 Q
INIT ;   Initialize Lexicon Temporary Global
 K ^ZZLEXX("ZZLEXXD","CAT") W !!
 W ?3,"Lexicon temporary global has been deleted and ready",!
 W ?3,"to read/load ICD-10-CM Diagnosis Categories.",! H 2
 Q
READ ;   Read Files
 W:$L($G(IOF)) @IOF N FT,TB,TX,CM S FT="O" S MAXLEN=$$MAX Q:+($G(MAXLEN))'>0
 D ORD^ZZLEXXDB
 Q
COMP ;   Compile Changes
 S MAXLEN=$$MAX Q:+($G(MAXLEN))'>0
 W:$L($G(IOF)) @IOF W !!," Compiling Changes, please wait  ",!
 D CCHG^ZZLEXXDC W !
 Q
DISP ;   Display Findings
 I $$TC'>0 W !!,?3,"No changes to display",! Q
 S MAXLEN=$$MAX Q:+($G(MAXLEN))'>0  D EN^ZZLEXXDF
 Q
LOAD ;   Load Data (update with changes)
 I $$TC'>0 W !!,?3,"No changes to load",! Q
 S MAXLEN=$$MAX Q:+($G(MAXLEN))'>0  W:$L($G(IOF)) @IOF  N PC,CC,TC
 W !!," Load Changes into the Character Positions file 757.033 ",!
 W !,"   ICD-10-CM Diagnosis Changes" S (TC,CC)=$$LOAD^ZZLEXXDD("CM")
 W "   Done" S CC=+($G(CC)) D SEND^ZZLEXXDZ
 I CC>0 W ", ",CC," change",$S(CC>1:"s ",1:" "),"made"
 I +CC'>0 W ", no change"
 W ! H 2
 Q
 ;
BD(X) ; Brief/Detailed Display
 N DIR,DIROUT,DIRUT,DTOUT,DUOUT
 S DIR(0)="SAO^B:Brief Display;D:Detailed Display"
 S DIR("A")=" Select Display Type:  (B/D):  ",(DIR("?"),DIR("??"))="^D BDH^ZZLEXXDA"
 S DIR("PRE")="S OX=X S:$L(X)&(X'[""^"")&(""^B^D^""'[(""^""_$$UP^XLFSTR($E(X,1))_""^"")) X=""??"""
 D ^DIR Q:$D(DIROUT)!($D(DTOUT))!($D(DIRUT))!($D(DUOUT)) "^"  S (X,Y)=$E(Y,1)
 Q X
BDH ;   Sample Type Help
 W !,?6,"Enter 'B' for a brief display, 'D' for a detailed"
 W !,?6,"display or '^' to exit"
 Q
 ;
RCLDH(X) ; Read/Compare/Display/Load
 D ATTR N DIR,DIROUT,DIRUT,DTOUT,DUOUT,OX,Y,TXT
 S DIR(0)="SAO^R:Read Data Files;C:Compare and Record Changes;L:Load Changes to 757.033;D:Display Changes/Progress;I:Initialize Lexicon Temporary Global"
 N R1,R2,R3,RL,RC
 S (R1,R2,R3,RL)=$G(^ZZLEXX("ZZLEXXD","CAT","DT","CM","ON"))
 N C1,C2,CL,CC,CT
 S (C1,C2,CL)=$G(^ZZLEXX("ZZLEXXD","CAT","DT","CC","ON")) S CT=$$TC
 N L1,L2,LL,LC,LT
 S (L1,L2,LL)=$G(^ZZLEXX("ZZLEXXD","CAT","DT","LC","ON")) S LT=$$TL
 S RC="" S:'$L(R1) RC="Overdue" S:$L(R1) RC="Done"
 S CC="" S:'$L(R1)!('$L(C1)) CC="Overdue" S:RC="Done"&(CL'>RL) CC="Overdue" S:RC'="Done" CC=""
 S:RC="Done"&(+CL>0)&(CL>RL) CC="Done"
 S:CC="Done"&(+($G(CT))>0) CC=CC_"  ("_+($G(CT))_" changes found)"
 S:CC="Done"&(+($G(CT))'>0) CC=CC_"  (no changes found)"
 S LC="" S:'$L(LL) LC="Overdue" S:(+RL'>+LL)!(+CL'>+LL) LC="Overdue"
 S:RC="Done"&(CC["Done")&(LL'<RL)&(LL'<CL) LC="Done" S:CC'["Done" LC=""
 S:+($G(CT))'>0&($L($$TM(CC))) LC="N/A"
 S:LC["Done"&(+($G(LT))>0) LC=LC_"  ("_+($G(LT))_" changes loaded)"
 I CC["Done"&(+($G(CT))'>0) D
 . S:+($G(^ZZLEXX("ZZLEXXD","CAT","DT","CC","ON")))>0 (^ZZLEXX("ZZLEXXD","CAT","DT","LC","ON"))=+($G(^ZZLEXX("ZZLEXXD","CAT","DT","CC","ON")))
 W !," ICD-10-CM Diagnostic Categories",!
 S TXT="   R   Read Data File" S:$L($G(RC)) TXT=TXT_$J(" ",(45-$L(TXT)))_RC W !,TXT
 S TXT="   C   Compare and Record Changes" S:$L($G(CC)) TXT=TXT_$J(" ",(45-$L(TXT)))_CC W !,TXT
 S TXT="   L   Load Changes to 757.033   " S:$L($G(LC)) TXT=TXT_$J(" ",(45-$L(TXT)))_LC W !,TXT
 S TXT="   D   Display Changes/Warnings/Progress"
 S:$D(^ZZLEXX("ZZLEXXD","CAT","CHG","WARN")) TXT="   D   Display Changes/"_$G(BOLD)_"Warnings"_$G(NORM)_"/Progress"
 I CT'>0&($L($$TM(CC))) S TXT="   D   Display Changes/Warnings/Progress"  S TXT=TXT_$J(" ",(45-$L(TXT)))_"N/A"
 W !,TXT S TXT="   I   Initialize Lexicon Temporary Global" W !,TXT
 W !,"  "
 D KATTR
 S DIR("A")=" Select Action:  (R/C/L/D/I):  ",(DIR("?"),DIR("??"))="^D RCLDHH^ZZLEXXDA"
 S DIR("PRE")="S OX=X S:$L(X)&(X'[""^"")&(""^R^C^D^L^I^""'[(""^""_$$UP^XLFSTR($E(X,1))_""^"")) X=""??"""
 D ^DIR Q:$D(DIROUT)!($D(DTOUT))!($D(DIRUT))!($D(DUOUT)) "^"
 Q:"^R^C^D^L^I^"'[("^"_$E(Y,1)_"^") "^"  S X=Y
 Q X
RCLDHH ;   Read/Display/Load Help
 W !," Enter  To Select Hostfile Type:",!
 W !,"   R    Read data from hostfile"
 W !,"   C    Compare data read to data on file and record changes"
 W !,"   L    Load changes into the Character Positions file #757.033"
 W !,"   D    Display changes, warning/errors, or progress (summary/detailed)"
 W !,"   I    Initialize temporary global - Kill ^ZZLEXX(""ZZLEXXD"",""CAT"")"
 Q
 ;
 D KATTR
 Q
 ;
 ; Miscellaneous
ATTR ;   Screen Attributes
 N X,%,IOINHI,IOINORM S X="IOINHI;IOINORM" D ENDR^%ZISS S BOLD=$G(IOINHI),NORM=$G(IOINORM) Q
KATTR ;   Kill Screen Attributes
 D KILL^%ZISS K BOLD,NORM Q
TC(X) ;   Total Changes
 N TOT,SYS,TYP S TOT=0 S SYS="CM" S TYP="" F  S TYP=$O(^ZZLEXX("ZZLEXXD","CAT","CHG",SYS,TYP)) Q:'$L(TYP)  D
 . Q:TYP="TOT"  Q:TYP="DT"  Q:TYP="ON"  S TOT=TOT+$G(^ZZLEXX("ZZLEXXD","CAT","CHG",SYS,TYP))
 S X=TOT
 Q X
TL(X) ;   Total Load
 N TOT,SYS,TYP S TOT=0 S SYS="CM" S TYP="" F  S TYP=$O(^ZZLEXX("ZZLEXXD","CAT","LOAD","SYS",SYS,TYP)) Q:'$L(TYP)  D
 . Q:TYP="TOT"  Q:TYP="DT"  Q:TYP="ON"  S TOT=TOT+$G(^ZZLEXX("ZZLEXXD","CAT","LOAD","SYS",SYS,TYP))
 S X=TOT S:+X>0 ^ZZLEXX("ZZLEXXD","CAT","LOAD","TOT")=X
 Q X
CONT(X) ;   Continue
 Q:$G(CONT)["^" "^"  N DIR,DIROUT,DIRUT,DUOUT,DTOUT,Y S DIR(0)="FAO^1:30"
 S DIR("A")="    Press <Enter> to continue or '^' to exit  " S:$L($G(DIRA)) DIR("A")=$G(DIRA)
 S DIR("PRE")="S:X[""^^"" X=""^^"" S:X'[""^^""&(X[""^"") X=""^"" S:X[""?"" X=""??"" S:X'[""^""&(X'[""?"") X="""""
 S (DIR("?"),DIR("??"))="^D CONTH^ZZLEXXDA" D ^DIR K DIRA Q:$D(DIROUT) "^^"  Q:$D(DUOUT) "^"  Q:X["^" "^" Q ""
 Q ""
CONTH ;   Continue Help
 W !,"        Press <Enter> to continue or '^' to exit"
 Q
FIX ;   Fix Long Text
 S MAXLEN=$$MAX N IEN,PIEN S IEN=0 F  S IEN=$O(^LEX(757.033,IEN)) Q:+IEN'>0  D
 . S PIEN=0 F  S PIEN=$O(^LEX(757.033,+IEN,2,+PIEN)) Q:+PIEN'>0  D
 . . N TX S TX=$G(^LEX(757.033,+IEN,2,+PIEN,1)) Q:$L(TX)'>MAXLEN  N DA,DIK
 . . S DA=+IEN,DIK="^LEX(757.033," D IX2^DIK S ^LEX(757.033,+IEN,2,+PIEN,1)=$E(TX,1,MAXLEN) S DA=+IEN,DIK="^LEX(757.033," D IX1^DIK
 . S PIEN=0 F  S PIEN=$O(^LEX(757.033,+IEN,3,+PIEN)) Q:+PIEN'>0  D
 . . N TX S TX=$G(^LEX(757.033,+IEN,3,+PIEN,1)) Q:$L(TX)'>MAXLEN  N DA,DIK
 . . S DA=+IEN,DIK="^LEX(757.033," D IX2^DIK S ^LEX(757.033,+IEN,3,+PIEN,1)=$E(TX,1,MAXLEN) S DA=+IEN,DIK="^LEX(757.033," D IX1^DIK
 . S PIEN=0 F  S PIEN=$O(^LEX(757.033,+IEN,4,+PIEN)) Q:+PIEN'>0  D
 . . N TX S TX=$G(^LEX(757.033,+IEN,4,+PIEN,1)) Q:$L(TX)'>MAXLEN  N DA,DIK
 . . S DA=+IEN,DIK="^LEX(757.033," D IX2^DIK S ^LEX(757.033,+IEN,4,+PIEN,1)=$E(TX,1,MAXLEN) S DA=+IEN,DIK="^LEX(757.033," D IX1^DIK
 . S PIEN=0 F  S PIEN=$O(^LEX(757.033,+IEN,5,+PIEN)) Q:+PIEN'>0  D
 . . N SIEN S SIEN=0 F  S SIEN=$O(^LEX(757.033,+IEN,5,+PIEN,1,SIEN)) Q:+SIEN'>0  D
 . . . N TX S TX=$G(^LEX(757.033,+IEN,5,+PIEN,1,+SIEN,0)) Q:$L(TX)'>MAXLEN  N DA,DIK
 . . . S DA=+IEN,DIK="^LEX(757.033," D IX2^DIK S ^LEX(757.033,+IEN,5,+PIEN,1,+SIEN,0)=$E(TX,1,MAXLEN) S DA=+IEN,DIK="^LEX(757.033," D IX1^DIK
 Q
LONG ;   Long Text Fields
 S MAXLEN=$$MAX Q:+($G(MAXLEN))'>0  N SAB,TOT,TY,ORD,OC S TOT=0,SAB="" S SAB="CM",TY="ICD-10-CM Diagnosis"
 S OC=0,ORD="" F  S ORD=$O(^ZZLEXX("ZZLEXXD","CAT",SAB,ORD)) Q:'$L(ORD)  D
 . N ND,NT,TX,SI
 . S ND=2,NT="Name/Title (2)",TX=$G(^ZZLEXX("ZZLEXXD","CAT",SAB,ORD,2))
 . I $L(TX)>MAXLEN S OC=OC+1 W:OC=1 !!," ",TY,! W !,"   ",NT," exceeds ",MAXLEN," characters (""",$TR(ORD," ",""),""", length=",$L(TX),")" S TOT=TOT+1
 . S ND=3,NT="Description (3)",TX=$G(^ZZLEXX("ZZLEXXD","CAT",SAB,ORD,3))
 . I $L(TX)>MAXLEN S OC=OC+1 W:OC=1 !!," ",TY,! W !,"   ",NT," exceeds ",MAXLEN," characters (""",$TR(ORD," ",""),""", length=",$L(TX),")" S TOT=TOT+1
 . S ND=4,NT="Explanation (4)",TX=$G(^ZZLEXX("ZZLEXXD","CAT",SAB,ORD,4))
 . I $L(TX)>MAXLEN S OC=OC+1 W:OC=1 !!," ",TY,! W !,"   ",NT," exceeds ",MAXLEN," characters (""",$TR(ORD," ",""),""", length=",$L(TX),")" S TOT=TOT+1
 . S SI=0 F  S SI=$O(^ZZLEXX("ZZLEXXD","CAT",SAB,ORD,5,SI)) Q:+SI'>0  D
 . . S ND=5,NT="Includes (5,"_SI_")",TX=$G(^ZZLEXX("ZZLEXXD","CAT",SAB,ORD,5,SI))
 . . I $L(TX)>MAXLEN S OC=OC+1 W:OC=1 !!," ",TY,! W !,"   ",NT," exceeds ",MAXLEN," characters (""",$TR(ORD," ",""),""", length=",$L(TX),")" S TOT=TOT+1
 W ! I +($G(TOT))>0 W !," ",TOT," text strings exceed ",MAXLEN," characters",!
 Q
TM(X,Y) ;   Trim Character Y - Default " "
 S X=$G(X) Q:X="" X  S Y=$G(Y) S:'$L(Y) Y=" "
 F  Q:$E(X,1)'=Y  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=Y  S X=$E(X,1,($L(X)-1))
 Q X
MAX(X) ;   Maximum Length of Text
 Q 245
ENV(X) ;   Check environment
 N NM S DT=$$DT^XLFDT D HOME^%ZIS S U="^" I +($G(DUZ))=0 W !!,?5,"DUZ not defined" Q 0
 S NM=$$GET1^DIQ(200,(DUZ_","),.01) I '$L(NM) W !!,?5,"DUZ not valid" Q 0
 S:$G(DUZ(0))'["@" DUZ(0)=$G(DUZ(0))_"@"
 Q 1
