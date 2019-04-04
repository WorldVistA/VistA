ZZLEXX ;SLC/KER - Import - ICD-10 - Load (vendorless) ;2019-01-14  11:50 AM
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    None
 ;               
 ; External References
 ;    HOME^%ZIS           ICR  10086
 ;    ENDR^%ZISS          ICR  10088
 ;    KILL^%ZISS          ICR  10088
 ;    ^DIM                ICR  10016
 ;    $$GET1^DIQ          ICR   2056
 ;    ^DIR                ICR  10026
 ;    $$DT^XLFDT          ICR  10103
 ;    $$UP^XLFSTR         ICR  10104
 ;               
EN ; Main Entry Point
 N %,%D,%ZIS,AC,ACT,ASC,ASIZE,BEG,BOLD,BYTE,CDT,CHANGE,CHR,CNT,CODE,CODES,COMMIT,CON,CONT,CRE,CT,CTL,DA,DEFF,DHIS,DIEN,DIR
 N DIRB,DIROUT,DIRUT,DIW,DIWF,DIWI,DIWL,DIWR,DIWT,DIWTC,DIWX,DONE,DN,DSUP,DTOUT,DTXT,DUOUT,EACT,EBEG,EDAT,EDT,EEND,EFF,EFFD
 N EIEN,END,ENT,ENV,ERR,EX,EXC,EXCL,EXEC,EXIT,EXM,EXP,FAR,FD,FDA,FDAI,FDAT,FDES,FDTS,FEX,FI,FIL1,FIL2,FIL3,FILE,FILESPEC
 N FLAG,FLTXD,FLTXT,FN,FND,FOPEN,FOUT,FQ,FRE,FREQ,FSTAD,FSTAT,FSTXD,FSTXT,FSYS,FULL,FY,H,HAS,HDR,HF,HFH,HFN,HFNAME,HFOK
 N HFP,HFV,HIEN,HIS,HR,I,IC,ID,IDAT,IEN,IENS,IN,KEY,KEYS,KEYW,KIEN,LAS,LAST,LEFF,LEX,LEX2,LEXA,LEXBEG,LEXC,LEXCHK,LEXCONT
 N LEXCT,LEXCTL,LEXD,LEXDF,LEXE,LEXELP,LEXEND,LEXEOP,LEXEX,LEXEXP,LEXFN,LEXFSC,LEXFSM,LEXFST,LEXHF,LEXI,LEXIEN,LEXINC,LEXL
 N LEXLC,LEXLSC,LEXLSM,LEXLST,LEXMC,LEXMCO,LEXME,LEXN,LEXO,LEXORD,LEXORG,LEXR1,LEXR2,LEXS,LEXSC,LEXSID,LEXSRC,LEXST,LEXT
 N LEXTEFF,LEXTHIS,LEXTSTA,LEXTSTD,LEXW,LIEN,LIEN,LINE,LLTXD,LLTXT,LSTAD,LSTAT,LSTXD,LSTXT,LSUP,LTXT,MAX,MC,MIEN,MOD,N,ND
 N NM,NORM,NOT,ODAT,OF,OIEN,OK,OLDD,OLDE,OLDS,OPEN,ORD,OUT,PAT,PATH,PD,PEFF,PIEN,PLTX,POP,PSN,PSTA,PSTX,REP,RTN,S,SAB,SC
 N SCREEN,SEFF,SEG,SEL,SEQ,SF,SHOW,SI,SIEN,SIZE,SM,SMP,SO,SR,SRC,ST,STA,STAT,STXT,SUB,SYS,TA,TAG,TC,TD,TEFF,TERM,TEST
 N TESTK,TEXIEN,TFILE,TFSPEC,THIS,TI,TIEN,TMCIEN,TMP,TOT,TPATH,TRL,TSMIEN,TSOIEN,TSTA,TSTD,TT,TTL,TX,TYPE,UCI,UVN,VAL,WIT
 N X,Y,YR,Z,ZTDESC,ZTDTH,ZTIO,ZTQUEUED,ZTREQ,ZTRTN,ZTSAVE,ZTSK S ENV=$$ENV Q:+ENV'>0  S EXIT=0 D MAIN,KATTR
 Q
 ;   
MAIN ; Main Menu
 S CONT="" N DONE,BOTH
MAINR ;   Main Menu
 N SPC,DONE W ! W:$L($G(IOF)) @IOF N EXEC,MAIN,TXT,X,Y,HOME,OK S (MAIN,DONE)=0,HOME=$P($T(+1)," ",1),CONT="" S SPC=0 D HD("MAINH") W !
 D:'$D(CONFLICT) LO("MAINO1") D:$D(CONFLICT) LO("MAINO2") S (X,EXEC)=$$SEL Q:+($G(EXIT))>0  S OK=+($$M(X)) Q:'OK
 X EXEC Q:CONT["^^"  G:CONT["^" MAINR S:+($G(DONE))'>0 CONT=$$CONT W ! G:CONT'["^" MAINR
 Q
MAINH ;   Main Menu Header
 ;;ICD-10 Data Load/Help
 Q
MAINO1 ;   Main Menu Options
 ;;T;erminology;;D CS^ZZLEXX
 ;;F;ragments and Categories;;D CF^ZZLEXX
 ;;V;erify ICD Load Files;;S BOTH="" D EN^ZZLEXXMA S DONE=1
 ;;D;isplay ICD-10 Addenda's;;D EN^ZZLEXXSA
 ;;H;elp (general process sequence);;D HELP^ZZLEXX2 S DONE=1
 ;;M;iscellaneous (Utilities);;D MI^ZZLEXX
 ;;;;;;
MAINO2 ;   Main Menu Options (alternate)
 ;;T;erminology;;D CS^ZZLEXX
 ;;F;ragments and Categories;;D CF^ZZLEXX
 ;;C;onflicts;;D CO^ZZLEXX
 ;;V;erify ICD Load Files;;S BOTH="" D EN^ZZLEXXMA S DONE=1
 ;;D;isplay ICD-10 Addenda's;;D EN^ZZLEXXSA
 ;;S;tatus of ICD-10 Load;;D EN^ZZLEXXIA S DONE=1
 ;;C;hange Listing;;D EN^ZZLEXXPA
 ;;M;iscellaneous (Utilities);;D MI^ZZLEXX
 ;;;;;;
 ;
CS ; Code Set ICD Terminology
 S CONT=""
CSR ;   Code Set ICD Terminology
 N DONE,SPC W ! W:$L($G(IOF)) @IOF N EXEC,TXT,X,Y,HOME,OK S DONE=0,HOME=$P($T(+1)," ",1),CONT="" S SPC=1 D HD("CSH"),LO("CSO") S (X,EXEC)=$$SEL S:'$L(X) CONT="^" Q:'$L(X)
 S OK=+($$M(X)) Q:'OK  X EXEC Q:CONT["^^"  G:CONT["^" CSR S:CONT'["^"&(+($G(DONE))'>0) CONT=$$CONT W ! G:CONT'["^" CSR
 Q
CSH ;   Code Set ICD Terminology Header
 ;;Load Code Set ICD Terminology
CSO ;   Code Set ICD Terminology Options
 ;;D;iagnosis;;D DIA^ZZLEXX
 ;;P;rocedures;;D PRO^ZZLEXX
 ;;;;
 ;
CF ; Categories and Code Fragments
 S CONT=""
CFR ;   Categories and Code Fragments
 N DONE,SPC W ! W:$L($G(IOF)) @IOF N EXEC,TXT,X,Y,HOME,OK S DONE=0,HOME=$P($T(+1)," ",1),CONT="" S SPC=1 D HD("CFH"),LO("CFO") S (X,EXEC)=$$SEL S:'$L(X) CONT="^" Q:'$L(X)
 S OK=+($$M(X)) Q:'OK  X EXEC Q:CONT["^^"  G:CONT["^" CFR S:CONT'["^"&(+($G(DONE))'>0) CONT=$$CONT W ! G:CONT'["^" CFR
 Q
CFH ;   Categories and Code Fragments Header
 ;;Load ICD-10 Categories and Code Fragments
CFO ;   Categories and Code Fragments Options
 ;;C;ategories;;D CAT^ZZLEXX
 ;;F;ragments;;D FRG^ZZLEXX
 ;;;;
 ;
CO ; Conflicts (UPD/Sex/Age Lo/Age High)
 S CONT=""
COR ;   Conflicts (UPD/Sex/Age Lo/Age High)
 N DONE,SPC W ! W:$L($G(IOF)) @IOF N EXEC,TXT,X,Y,HOME,OK S DONE=0,HOME=$P($T(+1)," ",1),CONT="" S SPC=1 D HD("COH"),LO("COO") S (X,EXEC)=$$SEL S:'$L(X) CONT="^" Q:'$L(X)
 S OK=+($$M(X)) Q:'OK  X EXEC Q:CONT["^^"  G:CONT["^" COR S:CONT'["^"&(+($G(DONE))'>0) CONT=$$CONT W ! G:CONT'["^" COR
 Q
COH ;   Conflicts (UPD/Sex/Age Lo/Age High) Header
 ;;Load Conflicts (UPD/Sex/Age Lo/Age High)
COO ;   Conflicts (UPD/Sex/Age Lo/Age High) Options
 ;;H;elp Loading Conflicts;;D HELP^ZZLEXXCH S DONE=1
 ;;L;oad Conflicts;;D LOAD^ZZLEXXCB
 ;;;;
 ;
 Q
MI ; Miscellaneous
 N BOTH,DONE S CONT=""
MIR ;   Miscellaneous Menu
 N DONE,SPC W ! W:$L($G(IOF)) @IOF N EXEC,TXT,X,Y,HOME,OK S DONE=0,HOME=$P($T(+1)," ",1),CONT="" S SPC=1 D HD("MIH"),LO("MIO") S (X,EXEC)=$$SEL S:'$L(X) CONT="^" Q:'$L(X)
 S OK=+($$M(X)) Q:'OK  X EXEC Q:CONT["^^"  G:CONT["^" MIR S:CONT'["^"&(+($G(DONE))'>0) CONT=$$CONT W ! G:CONT'["^" MIR
 Q
MIH ;   Miscellaneous Header
 ;;Miscellaneous Task and Task Utilities
MIO ;   Miscellaneous Options
 ;;S;tatus of ICD-10 Load;;D EN^ZZLEXXIA
 ;;L;ist Changes;;D EN^ZZLEXXPA
 ;;C;alculate Code Count in File #757.03;;D EN^ZZLEXXMD S DONE=1
 ;;U;pdate Revision Number in Data Dictionary;;D UPD^ZZLEXXMF S DONE=1
 ;;R;e-Index ICD Load Files;;D EN^ZZLEXXME
 ;;M;onitor Running Task;;D MON^ZZLEXXMA S DONE=1
 ;;;;;;
 Q
 ;
DIA ; ICD-10-CM Diagnosis
 S CONT=""
DIAR ;   ICD-10-CM Diagnosis Menu
 N DONE,SPC W ! W:$L($G(IOF)) @IOF N EXEC,TXT,X,Y,HOME,OK S DONE=0,HOME=$P($T(+1)," ",1),CONT="" S SPC=1 D HD("DIAH"),LO("DIAO") S (X,EXEC)=$$SEL S:'$L(X) CONT="^" Q:'$L(X)
 S OK=+($$M(X)) Q:'OK  X EXEC Q:CONT["^^"  G:CONT["^" DIAR S:CONT'["^"&(+($G(DONE))'>0) CONT=$$CONT W ! G:CONT'["^" DIAR
 Q
DIAH ;   ICD-10-CM Diagnosis Header
 ;;ICD-10-CM Diagnosis
DIAO ;   ICD-10-CM Diagnosis Options
 ;;L;oad ICD-10-CM Diagnosis;;D LOAD^ZZLEXXAA
 ;;S;tatus of ICD-10-CM Diagnosis;;D ONE^ZZLEXXIA("ICD")
 ;;H;elp Loading ICD-10-CM Diagnosis;;D HELP^ZZLEXXAH S DONE=1
 ;;;;
 ;
PRO ; ICD=10-PCS Procedures
 S CONT=""
PROR ;   ICD=10-PCS Procedures Menu
 N DONE,SPC W ! W:$L($G(IOF)) @IOF N EXEC,TXT,X,Y,HOME,OK S DONE=0,HOME=$P($T(+1)," ",1),CONT="" S SPC=1 D HD("PROH"),LO("PROO") S (X,EXEC)=$$SEL S:'$L(X) CONT="^" Q:'$L(X)
 S OK=+($$M(X)) Q:'OK  X EXEC Q:CONT["^^"  G:CONT["^" PROR S:CONT'["^"&(+($G(DONE))'>0) CONT=$$CONT W ! G:CONT'["^" PROR
 Q
PROH ;   ICD=10-PCS Procedures Header
 ;;ICD-10-PCS Procedures
PROO ;   ICD=10-PCS Procedures Options
 ;;L;oad ICD-10-PCS Procedures;;D LOAD^ZZLEXXBA
 ;;S;tatus of ICD-10-PCS Procedures;;D ONE^ZZLEXXIA("ICP")
 ;;H;elp Loading ICD-10-PCS Procedures;;D HELP^ZZLEXXBH S DONE=1
 ;;;;
 ;
 ;
CAT ; ICD-10-CM Categories
 S CONT=""
CATR ;   ICD-10-CM Categories Menu
 N DONE,SPC W ! W:$L($G(IOF)) @IOF N EXEC,TXT,X,Y,HOME,OK S DONE=0,HOME=$P($T(+1)," ",1),CONT="" S SPC=1 D HD("CATH"),LO("CATO") S (X,EXEC)=$$SEL S:'$L(X) CONT="^" Q:'$L(X)
 S OK=+($$M(X)) Q:'OK  X EXEC Q:CONT["^^"  G:CONT["^" CATR S:CONT'["^"&(+($G(DONE))'>0) CONT=$$CONT W ! G:CONT'["^" CATR
 Q
CATH ;   ICD-10-CM Categories Header 
 ;;ICD-10-CM Categories
CATO ;   ICD-10-CM Diagnosis Options
 ;;L;oad ICD-10-CM Categories;;D EN^ZZLEXXDA
 ;;S;tatus of ICD-10-CM Categories;;D ONE^ZZLEXXIA("CAT")
 ;;H;elp Loading ICD-10-CM Categories;;D HELP^ZZLEXXDH S DONE=1
 ;;;;
 ;
FRG ; ICD-10-PCS Code Fragments
 S CONT=""
FRGR ;   ICD-10-CM Categories Menu
 N DONE,SPC W ! W:$L($G(IOF)) @IOF N EXEC,TXT,X,Y,HOME,OK S DONE=0,HOME=$P($T(+1)," ",1),CONT="" S SPC=1 D HD("FRGH"),LO("FRGO") S (X,EXEC)=$$SEL S:'$L(X) CONT="^" Q:'$L(X)
 S OK=+($$M(X)) Q:'OK  X EXEC Q:CONT["^^"  G:CONT["^" FRGR S:CONT'["^"&(+($G(DONE))'>0) CONT=$$CONT W ! G:CONT'["^" FRGR
 Q
FRGH ;   ICD-10-PCS Code Fragments
 ;;ICD-10-PCS Code Fragments
FRGO ;   ICD-10-PCS Code Fragments Options
 ;;L;oad ICD-10-PCS Code Fragments;;D LOAD^ZZLEXXEA
 ;;S;tatus of ICD-10-PCS Code Fragments;;D ONE^ZZLEXXIA("FRG")
 ;;H;elp Loading ICD-10-PCS Code Fragments;;D HELP^ZZLEXXEH S DONE=1
 ;;;;
 ;
 ; Menu Components
HD(X) ;   Menu Header
 N TAG,HOME S TAG=$G(X),HOME=$P($T(+1)," ",1) Q:'$L(TAG)  W:$L($G(IOF)) @IOF
 S EXEC="S TXT=$T("_TAG_"+1^"_HOME_")" X EXEC S TXT=$P(TXT,";;",2,299) W:$L(TXT) !," ",TXT W:+($G(SPC))>0 !
 Q
LO(X) ;   List Options
 N LOC,TAG,HOME,BOLD,NORM,CNT,MAX,TXT,KEY,NOUN,VERB,CALL,RTN,I
 S LOC=$$LOC S TAG=$G(X),HOME=$P($T(+1)," ",1) K SEL,MAX S MAX=0 Q:'$L(TAG)  D ATTR
 S (MAX,CNT)=0,TXT=""  F I=1:1 D  Q:'$L(TXT)
 . N KEY,NOUN,VERB,CALL,RTN,EXEC,RTNC,NEXT S TXT="" S EXEC="S TXT=$T("_TAG_"+"_I_"^"_HOME_")" X EXEC
 . S TXT=$P(TXT,";;",2,299) Q:TXT=""  Q:$TR(TXT,";","")=""
 . S KEY=$P(TXT,";",1),NOUN=$P(TXT,";",2) Q:'$L(NOUN)
 . W:'$L(KEY)&($L(NOUN)) !,"   ",NOUN,!
 . Q:$L(KEY)'=1  S VERB=$P(TXT,";",4) Q:'$L(VERB)  S CALL=$P(VERB," ",2) Q:'$L(CALL)  S RTN=$P(VERB,"^",2) Q:'$L(RTN)
 . S CNT=CNT+1 S:CNT>MAX MAX=CNT
 . I CNT>0 W !,$J(CNT,6),"   (",$G(BOLD),KEY,$G(NORM),")",NOUN I $L(LOC),NOUN["ist Changes" W " in ",$G(BOLD),LOC,$G(NORM)
 . S EXEC="S NEXT=$T("_TAG_"+"_(I+1)_"^"_HOME_")" X EXEC
 . I $L($P($P($G(NEXT),";;",2,299),";",2)),'$L($P($P($G(NEXT),";;",2,299),";",4)) W !
 . S SEL(CNT)=VERB S:$L(KEY) SEL(KEY)=VERB S SEL(0)=MAX
 D KATTR
 Q
SEL(X) ;   Selection
 N DIR,DIROUT,DIRUT,DUOUT,DTOUT,Y,MAX S MAX=+($G(SEL(0))),DIR(0)="FAO^1:30" S:MAX>1 DIR("A")=" Select 1-"_MAX_":  "
 S:MAX=1 DIR("A")="    Answer ""Yes"" or ""No"" or ""^"" to exit" S DIR("PRE")="S X=$$SELP^ZZLEXX(X)"
 S (DIR("?"),DIR("??"))="^D SELH^ZZLEXX" W ! D ^DIR S:$D(DIROUT)!($D(DUOUT))!($D(DTOUT))!($G(X)["^") EXIT=1
 Q:$D(DIROUT) "^^"  Q:$D(DUOUT) "^"  Q:X["^" "^" Q:'$L(X) ""  Q:$L($G(SEL(X))) $G(SEL(X))
 Q ""
SELP(X) ;     Selection Pre-process
 S X=$$UP^XLFSTR($G(X)) Q:$G(X)["?" "??" Q:$G(X)["^^" "^^"  Q:$G(X)["^" "^"  Q:'$L(X) ""  S X=$E(X,1)
 Q:$G(MAX)>1&($D(SEL(X))) X Q:$G(MAX)=1&("^Y^N^"[("^"_X_"^")) X
 Q "??"
SELH ;     Selection Help
 D ATTR I $G(MAX)>1 D
 . W !,"    Select 1-",$G(SEL(0))
 . W ", the single ",$G(BOLD),"(letter)",$G(NORM),", "
 . W:+($G(SPC))'>0 "<ENTER> or ""^"" to exit"
 . W:+($G(SPC))>0 "<ENTER> to exit this menu",!,"    or ""^"" to exit the program"
 I $G(MAX)=1 W !,"    Answer ""Yes"" or ""No"" or ""^"" to exit"
 D KATTR
 Q
 ; 
 ; Miscellaneous
TM(X,Y) ;   Trim Character Y - Default " " Space
 S X=$G(X) Q:X="" X  S Y=$G(Y) S:'$L(Y) Y=" "
 F  Q:$E(X,1)'=Y  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=Y  S X=$E(X,1,($L(X)-1))
 Q X
ATTR ;   Screen Attributes
 N X,%,IOINHI,IOINORM S X="IOINHI;IOINORM" D ENDR^%ZISS S BOLD=$G(IOINHI),NORM=$G(IOINORM) Q
KATTR ;   Kill Screen Attributes
 D KILL^%ZISS K BOLD,NORM Q
ROK(X) ;   Routine OK
 S X=$G(X) Q:'$L(X) 0 N EXEC,TXT S EXEC="S TXT=$T(+1^"_X_")" X EXEC
 Q:'$L(TXT) 0 Q 1
UP(X) ;   Uppercase
 Q $TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
M(X) ;   MUMPs OK
 S X=$G(X) Q:'$L(X) 0 D ^DIM Q:'$D(X) 0 Q 1
CONT(X) ;   Continue
 Q:+($G(EXIT))>0 "^"  Q:$G(CONT)["^" "^"  N DIR,DIROUT,DIRUT,DUOUT,DTOUT,Y
 S DIR(0)="FAO^1:30",DIR("A")="    Press <Enter> to continue or '^' to exit "
 S DIR("PRE")="S:X[""^^"" X=""^^"" S:X'[""^^""&(X[""^"") X=""^"" S:X[""?"" X=""??"" S:X'[""^""&(X'[""?"") X="""""
 S (DIR("?"),DIR("??"))="^D CONTH^ZZLEXX" W ! D ^DIR S:$D(DIROUT)!($D(DUOUT)) EXIT=1 Q:$D(DIROUT) "^^"  Q:$D(DUOUT) "^"  Q:X["^" "^" Q ""
 Q ""
CONTH ;   Continue Help
 W !,"        Press <Enter> to continue or '^' to exit"
 Q
DXPT ;   Fix ICD-10 Diagnosis Preferred Terms
 N FIX,COMMIT S (FIX,COMMIT)=1 D T30^ZZLEXXRD
 Q
PRPT ;   Fix ICD-10 Procedures Preferred Terms
 N FIX,COMMIT S (FIX,COMMIT)=1 D T31^ZZLEXXRD
 Q
LOC(X) ;   Local Namespace
 N EX,LNS S EX="S LNS=$ZGBLDIR" X EX
 S X=$G(LNS)
 Q X
USR(X) ;   User
 Q $$GET1^DIQ(200,(DUZ_","),.01)
ENV(X) ;   Check environment
 N USR S DT=$$DT^XLFDT D HOME^%ZIS S U="^" I +($G(DUZ))=0 W !!,?5,"DUZ not defined" Q 0
 S USR=$$GET1^DIQ(200,(DUZ_","),.01) I '$L(USR) W !!,?5,"DUZ not valid" Q 0
 S:$G(DUZ(0))'["@" DUZ(0)=$G(DUZ(0))_"@" N CONFLICT
 Q 1
