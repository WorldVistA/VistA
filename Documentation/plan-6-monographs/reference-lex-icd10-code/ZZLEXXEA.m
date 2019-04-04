ZZLEXXEA ;SLC/KER - Import - ICD-10-PCS Frag - Main ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^LEX(757.033        SACC 1.3
 ;   ^ZZLEXX("ZZLEXXE"    SACC 1.3
 ;               
 ; External References
 ;    HOME^%ZIS           ICR  10086
 ;    ENDR^%ZISS          ICR  10088
 ;    KILL^%ZISS          ICR  10088
 ;    IX1^DIK             ICR  10013
 ;    IX2^DIK             ICR  10013
 ;    GET1^DIQ            ICR   2056
 ;    ^DIR                ICR  10026
 ;    $$DT^XLFDT          ICR  10103
 ;    $$FMTE^XLFDT        ICR  10103
 ;               
LOAD ; Main Entry Point 
 N ENV,RCDL,OUT,CONT,MAXLEN S ENV=$$ENV Q:ENV'>0  S MAXLEN=$$MAX Q:+($G(MAXLEN))'>0  F  D  Q:'$L(OUT)  Q:OUT="^"  Q:$G(CONT)["^"
 . N DONE W:$L($G(IOF)) @IOF S (OUT,RCDL)=$$RCDL
 . I "^R^C^L^D^I^"'[("^"_RCDL_"^") S CONT="^" Q
 . D:"^R^"[("^"_RCDL_"^") READ D:"^C^"[("^"_RCDL_"^") COMP
 . D:"^D^"[("^"_RCDL_"^") DISP D:"^L^"[("^"_RCDL_"^") UPDT
 . D:"^I^"[("^"_RCDL_"^") INIT
 . S:'$D(DONE) CONT=$$CONT
 . W:$L($G(IOF)) @IOF
 Q
INIT ;   Initialize Lexicon Temporary Global
 K ^ZZLEXX("ZZLEXXE","PCS") W !!
 W ?3,"Lexicon temporary global has been deleted and is",!
 W ?3,"ready to read/load ICD-10-PCS Code Fragments.",! H 2
 Q
READ ;   Read Files
 W:$L($G(IOF)) @IOF N FT,TB,TX S FT=$E($$FT,1) S MAXLEN=$$MAX Q:+($G(MAXLEN))'>0
 I "^T^D^"'[("^"_FT_"^") W !!," Hostfile type not selected",! Q
 D:FT="T" TAB^ZZLEXXEB D:FT="D" DEF^ZZLEXXEC
 S TB=$G(^ZZLEXX("ZZLEXXE","PCS","DT","TB","ON")) G:$P(TB,".",1)'?7N READ
 S TX=$G(^ZZLEXX("ZZLEXXE","PCS","DT","DF","ON")) G:$P(TX,".",1)'?7N READ G:+TX'>+TB READ
 Q
COMP ;   Compile Changes
 S MAXLEN=$$MAX Q:+($G(MAXLEN))'>0
 W:$L($G(IOF)) @IOF W !!," Compiling Changes, please wait  ",! D PCHG^ZZLEXXED W !
 Q
DISP ;   Display Findings
 S MAXLEN=$$MAX Q:+($G(MAXLEN))'>0  D EN^ZZLEXXEJ
 Q
UPDT ;   Load Data
 S MAXLEN=$$MAX Q:+($G(MAXLEN))'>0  W:$L($G(IOF)) @IOF  N PC,CC,TC
 W !,"   ICD-10-PCS Procedure Changes" S PC=$$LOAD^ZZLEXXEE("PCS"),TC=+($G(TC))+PC
 D SEND^ZZLEXXEZ W "   Done" S PC=+($G(PC))
 I +PC>0 W ", ",PC," change",$S(+PC>1:"s ",1:" "),"made"
 I +PC'>0 W ",  no change"
 i +TC>0 W !!,"   ",TC," Total change",$S(TC>1:"s ",1:" "),"made"
 W ! H 2
 Q
 ;
FT(X) ; File Type
 N DIR,DIROUT,DIRUT,DTOUT,DUOUT,OX,Y,TFD,PFD,TFDO,PFDO,TFDA,PFDA,TFDOA,PFDOA,TTX,PTX
 S (TFD,PFD)="" S TFD=$G(^ZZLEXX("ZZLEXXE","PCS","DT","TB")),PFD=$G(^ZZLEXX("ZZLEXXE","PCS","DT","DF"))
 S:$E(TFD,4,7)="1001" TFD=TFD+10000 S:$E(PFD,4,7)="1001" PFD=PFD+10000
 S (TFDO,PFDO)="" S TFDO=$G(^ZZLEXX("ZZLEXXE","PCS","DT","TB","ON")),PFDO=$G(^ZZLEXX("ZZLEXXE","PCS","DT","DF","ON"))
 S (TFDA,PFDA)="" S:TFD?7N TFDA=$$FMTE^XLFDT(TFD,"5ZS") S:PFD?7N PFDA=$$FMTE^XLFDT(PFD,"5ZS")
 S (TFDOA,PFDOA)="" S:$P(TFDO,".",1)?7N TFDOA=$TR($$FMTE^XLFDT(TFDO,"5ZS"),"@"," ")
 S:$P(PFDO,".",1)?7N PFDOA=$TR($$FMTE^XLFDT(PFDO,"5ZS"),"@"," ")
 S (TTX,PTX)=""
 S:$L(TFDA,"/")=3 TTX="v"_$P(TFDA,"/",3) S:$L(TFDOA)&$L(TTX) TTX=TTX_" updated "_TFDOA
 S:$L(PFDA,"/")=3 PTX="v"_$P(PFDA,"/",3) S:$L(PFDOA)&$L(PTX) PTX=PTX_" updated "_PFDOA
 S DIR(0)="SAO^T:ICD-10-PCS Tabular File;D:ICD-10-PCS Definition File"
 W !," Hostfile Types",!
 W !,"   T   ICD-10-PCS Tabular File      " W:$L($G(TTX)) TTX
 W !,"   D   ICD-10-PCS Definition File   " W:$L($G(PTX)) PTX
 W !,"  "
 S DIR("A")=" Select Hostfile Type:  (T/D):  ",(DIR("?"),DIR("??"))="^D FTH^ZZLEXXEA"
 S DIR("PRE")="S OX=X S:$L(X)&(X'[""^"")&(""^T^D^""'[(""^""_$$UP^XLFSTR($E(X,1))_""^"")) X=""??"""
 D ^DIR Q:$D(DIROUT)!($D(DTOUT))!($D(DIRUT))!($D(DUOUT)) "^"
 Q:"^T^D^"'[("^"_$E(Y,1)_"^") "^"  S X=Y
 Q X
FTH ;   Sample Type Help
 D ATTR
 W $G(NORM),!," Enter  To Select Hostfile Type:",!
 W $G(BOLD),!,"   T    ICD-10-PCS Tabular File",$G(NORM)
 I $G(OX)'["?" W ?37,"e.g., icd10pcs_tabular_yyyy.txt",!,?37,"      icd10pcs_tables_yyyy.txt"
 I $G(OX)["?" D
 . W !,"        e.g., icd10pcs_tabular_yyyy.txt, containing ICD-10-PCS code"
 . W !,"        fragment titles, and definitions.  " W:$L($G(TTX)) !,"        Tabular file ",TTX,!
 W $G(BOLD),!!,"   D    ICD-10-PCS Definition File ",$G(NORM)
 I $G(OX)'["?" W ?37,"e.g., icd10pcs_definitions_yyyy.txt"
 I $G(OX)["?" D
 . W !,"        e.g., icd10pcs_definitions_yyyy.txt, containing ICD-10-PCS"
 . W !,"        code fragment names, descriptions, explanations, included"
 . W !,"        items and synonyms.  " W:$L($G(PTX)) !,"        Definitions file ",PTX,!
 I $G(OX)'["?" W !!,?37,"      The fiscal year yyyy will change",!,?37,"      each year."
 I $G(OX)["?" W !!,"        The fiscal year yyyy will change each year."
 W $G(NORM)
 D KATTR
 Q
 ;
BD(X) ; Brief/Detailed Display
 N DIR,DIROUT,DIRUT,DTOUT,DUOUT
 S DIR(0)="SAO^B:Brief Display;D:Detailed Display"
 S DIR("A")=" Select Display Type:  (B/D):  ",(DIR("?"),DIR("??"))="^D BDH^ZZLEXXEA"
 S DIR("PRE")="S OX=X S:$L(X)&(X'[""^"")&(""^B^D^""'[(""^""_$$UP^XLFSTR($E(X,1))_""^"")) X=""??"""
 D ^DIR Q:$D(DIROUT)!($D(DTOUT))!($D(DIRUT))!($D(DUOUT)) "^"  S (X,Y)=$E(Y,1)
 Q X
BDH ;   Sample Type Help
 W !,?6,"Enter 'B' for a brief display, 'D' for a detailed"
 W !,?6,"display or '^' to exit"
 Q
 ;
RCDL(X) ; Read/Compare/Display/Load
 D ATTR N DIR,DIROUT,DIRUT,DTOUT,DUOUT,OX,Y,TXT
 S DIR(0)="SAO^R:Read Data Files;C:Compare and Record Changes;L:Load Changes to 757.033;D:Display Changes/Progress;I:Initialize Lexicon Temporary Global"
 N R1,R2,RL,RC
 S R1=$G(^ZZLEXX("ZZLEXXE","PCS","DT","TB","ON")),R2=$G(^ZZLEXX("ZZLEXXE","PCS","DT","DF","ON")),RL=R1 S:R2>RL RL=R2
 N C1,CL,CC,CT
 S C1=$G(^ZZLEXX("ZZLEXXE","PCS","DT","CP","ON")),CL=C1 S CT=$$TC
 N L1,L2,LL,LC,LT
 S L1=$G(^ZZLEXX("ZZLEXXE","PCS","DT","LP","ON")),LL=L1 S LT=$$TL
 S RC="" S:'$L(R1) RC="Overdue"
 S:$L(R1)&(('$L(R2))) RC="Incomplete"
 S:$L(R1)&($L(R2))&(R1>R2) RC="Incomplete"
 I R1>R2 K ^ZZLEXX("ZZLEXXE","PCS","DT","DF") S R2=""
 S:$L(R1)&($L(R2))&(+R2>R1) RC="Done"
 S CC="" S:'$L(R1)!('$L(C1)) CC="Overdue"
 S:RC'="Done" CC=""
 S:RC="Done"&(CL'>RL) CC="Overdue"
 S:RC="Done"&(+CL>0)&(CL>RL) CC="Done"
 S:CC="Done"&(+($G(CT))>0) CC=CC_"  ("_+($G(CT))_" changes found)"
 S:CC="Done"&(+($G(CT))'>0) CC=CC_"  (no changes found)"
 S LC="" S:'$L(L1)!('$L(LL)) LC="Overdue"
 S:(+RL'>+LL)!(+CL'>+LL) LC="Overdue"
 S:RC="Done"&(CC["Done")&(LL'<RL)&(LL'<CL) LC="Done"
 S:CC'["Done" LC=""
 S:+($G(CT))'>0&($L($$TM(CC))) LC="N/A"
 S:LC["Done"&(+($G(LT))>0) LC=LC_"  ("_+($G(LT))_" changes loaded)"
 I CC["Done"&(+($G(CT))'>0) D
 . S:+($G(^ZZLEXX("ZZLEXXE","PCS","DT","CP","ON")))>0 (^ZZLEXX("ZZLEXXE","PCS","DT","LC","ON"),^ZZLEXX("ZZLEXXE","PCS","DT","LD","ON"),^ZZLEXX("ZZLEXXE","PCS","DT","LP","ON"))=+($G(^ZZLEXX("ZZLEXXE","PCS","DT","CC","ON")))
 W !," ICD-10 PCS Code Fragments",!
 S TXT="   R   Read Data Files" S:$L($G(RC)) TXT=TXT_$J(" ",(45-$L(TXT)))_RC W !,TXT
 S TXT="   C   Compare and Record Changes" S:$L($G(CC)) TXT=TXT_$J(" ",(45-$L(TXT)))_CC W !,TXT
 S TXT="   L   Load Changes to 757.033   " S:$L($G(LC)) TXT=TXT_$J(" ",(45-$L(TXT)))_LC W !,TXT
 S TXT="   D   Display Changes/Warnings/Progress"
 S:$D(^ZZLEXX("ZZLEXXE","PCS","CHG","WARN")) TXT="   D   Display Changes/"_$G(BOLD)_"Warnings"_$G(NORM)_"/Progress"
 I CT'>0&($L($$TM(CC))) S TXT="   D   Display Changes/Warnings/Progress"  S TXT=TXT_$J(" ",(45-$L(TXT)))_"N/A"
 W !,TXT S TXT="   I   Initialize Lexicon Temporary Global" W !,TXT
 W !,"  "
 D KATTR
 S DIR("A")=" Select Action:  (R/C/L/D/I):  ",(DIR("?"),DIR("??"))="^D RCDLH^ZZLEXXEA"
 S DIR("PRE")="S OX=X S:$L(X)&(X'[""^"")&(""^R^C^L^D^I^^""'[(""^""_$$UP^XLFSTR($E(X,1))_""^"")) X=""??"""
 D ^DIR Q:$D(DIROUT)!($D(DTOUT))!($D(DIRUT))!($D(DUOUT)) "^"
 Q:"^R^C^L^D^I^^"'[("^"_$E(Y,1)_"^") "^"  S X=Y
 Q X
RCDLH ;   Read/Display/Load Help
 W !," Enter  To Select Hostfile Type:",!
 W !,"   R    Read data from hostfiles, e.g., icd10pcs_order_2015.txt"
 W !,"   C    Compare data read to data on file and Record Changes"
 W !,"   L    Load Changes into the Character Positions file #757.033"
 W !,"   D    Display Changes, Warning/Errors, or Progress (summary/detailed)"
 W !,"   I    Initialize Lexicon Temporary Global"
 Q
 D KATTR
 Q
 ;
 ; Miscellaneous
ATTR ;   Screen Attributes
 N X,%,IOINHI,IOINORM S X="IOINHI;IOINORM" D ENDR^%ZISS S BOLD=$G(IOINHI),NORM=$G(IOINORM) Q
KATTR ;   Kill Screen Attributes
 D KILL^%ZISS K BOLD,NORM Q
TC(X) ;   Total Changes
 N TOT,SYS,TYP S TOT=0 S SYS="PCS" S TYP="" F  S TYP=$O(^ZZLEXX("ZZLEXXE","PCS","CHG",SYS,TYP)) Q:'$L(TYP)  D
 . Q:TYP="TOT"  Q:TYP="DT"  Q:TYP="ON"  S TOT=TOT+$G(^ZZLEXX("ZZLEXXE","PCS","CHG",SYS,TYP))
 S X=TOT
 Q X
TL(X) ;   Total Load
 N TOT,SYS,TYP S TOT=0 S SYS="PCS" S TYP="" F  S TYP=$O(^ZZLEXX("ZZLEXXE","PCS","LOAD","SYS",SYS,TYP)) Q:'$L(TYP)  D
 . Q:TYP="TOT"  Q:TYP="DT"  Q:TYP="ON"  S TOT=TOT+$G(^ZZLEXX("ZZLEXXE","PCS","LOAD","SYS",SYS,TYP))
 S X=TOT S:+X>0 ^ZZLEXX("ZZLEXXE","PCS","LOAD","TOT")=X
 Q X
CONT(X) ;   Continue
 Q:$G(CONT)["^" "^"  N DIR,DIROUT,DIRUT,DUOUT,DTOUT,Y S DIR(0)="FAO^1:30"
 S DIR("A")="    Press <Enter> to continue or '^' to exit  " S:$L($G(DIRA)) DIR("A")=$G(DIRA)
 S DIR("PRE")="S:X[""^^"" X=""^^"" S:X'[""^^""&(X[""^"") X=""^"" S:X[""?"" X=""??"" S:X'[""^""&(X'[""?"") X="""""
 S (DIR("?"),DIR("??"))="^D CONTH^ZZLEXXEA" N DIRA D ^DIR Q:$D(DIROUT) "^^"  Q:$D(DUOUT) "^"  Q:X["^" "^" Q ""
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
 S MAXLEN=$$MAX Q:+($G(MAXLEN))'>0  N SAB,TOT,TY,ORD,OC S TOT=0,SAB="" S SAB="PCS",TY="ICD-10-PCS Procedures"
 S OC=0,ORD="" F  S ORD=$O(^ZZLEXX("ZZLEXXE","PCS",SAB,ORD)) Q:'$L(ORD)  D
 . N ND,NT,TX,SI
 . S ND=2,NT="Name/Title (2)",TX=$G(^ZZLEXX("ZZLEXXE","PCS",SAB,ORD,2))
 . I $L(TX)>MAXLEN S OC=OC+1 W:OC=1 !!," ",TY,! W !,"   ",NT," exceeds ",MAXLEN," characters (""",$TR(ORD," ",""),""", length=",$L(TX),")" S TOT=TOT+1
 . S ND=3,NT="Description (3)",TX=$G(^ZZLEXX("ZZLEXXE","PCS",SAB,ORD,3))
 . I $L(TX)>MAXLEN S OC=OC+1 W:OC=1 !!," ",TY,! W !,"   ",NT," exceeds ",MAXLEN," characters (""",$TR(ORD," ",""),""", length=",$L(TX),")" S TOT=TOT+1
 . S ND=4,NT="Explanation (4)",TX=$G(^ZZLEXX("ZZLEXXE","PCS",SAB,ORD,4))
 . I $L(TX)>MAXLEN S OC=OC+1 W:OC=1 !!," ",TY,! W !,"   ",NT," exceeds ",MAXLEN," characters (""",$TR(ORD," ",""),""", length=",$L(TX),")" S TOT=TOT+1
 . S SI=0 F  S SI=$O(^ZZLEXX("ZZLEXXE","PCS",SAB,ORD,5,SI)) Q:+SI'>0  D
 . . S ND=5,NT="Includes (5,"_SI_")",TX=$G(^ZZLEXX("ZZLEXXE","PCS",SAB,ORD,5,SI))
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
