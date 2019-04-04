ZZLEXXCB ;SLC/KER - Import - Conflicts - Load ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^ZZLEXX("ZZLEXXC"   SACC 1.3
 ;               
 ; External References
 ;    HOME^%ZIS           ICR  10086
 ;    $$GET1^DIQ          ICR   2056
 ;    $$DT^XLFDT          ICR  10103
 ;               
 ; Data Source
 ;               
 ;   CMS Medicare
 ;   > Acute Inpatient PPS
 ;     > FY2017 IPPS Final Rule HomePage
 ;       Note, year will change
 ;       > FY 2017 Final Rule and Correction Notice Data Files
 ;         Note, year will change
 ;         > Definition of Medicare Code Edits v34 
 ;           Note, version number will change
 ;           > I-10 MCE
 ;             > Definitions of Medicare Code Edits_v34_I10.txt
 ;               Note, version number will change
 ;               
 Q
LOAD ; Load Conflicts (Age High/Age Low/UPD/Sex Fields)
 N %,ABRT,AGE,AGEH,AGEHD,AGEHS,AGEL,AGELD,AGELS,CAP,CHR,CODE,COL,COMMIT,CT,DA,DEFF,DIERR,EFF,ENV,ERR,ERRTOT,EXC,EXIT,FDA,FDAI,FY,H1
 N H2,H3,H4,HAS,HDR,HFNAME,HFOK,HFV,HIS,I,IEN,IENS,LDES,LEFF,LI,LINE,NEW,NEWH,NEWL,NM,NOT,OLDH,OLDL,OPEN,ORD,PATH,POP,POST,QUIET,SEQ
 N SI,STA,TERM,TEST,TI,TIEN,TMP,TOT,TRL,TX,TXI,UPD,WASCOM,X,Y,Z D HOME^%ZIS W:$L($G(IOF)) @IOF
 S ENV=$$ENV Q:'ENV
 W !," Update ICD Conflicts:",!
 W !,"    File     Field      Field Name"
 W !,"    ----     -----      ----------------------------"
 W !,"     80       1.3       Unacceptable as Principal Dx"
 W !,"     80       10        Sex"
 W !,"     80.1     10        Sex"
 W !,"     80       11        Age Low"
 W !,"     80       12        Age High"
 S (ERR,TOT)=0 I $D(^ZZLEXX("ZZLEXXC",$J)) D  G LOADQ
 . W !!,?4,"Conflict update is already in progress"
 . W !,?4,"Temporary global ^ZZLEXX(""ZZLEXXC"",$J) exist",!
 K ^ZZLEXX("ZZLEXXC",$J) S HFNAME=$$HFILE I +HFNAME'>0 D  G LOADQ
 . W:$L($P($G(HFNAME),"^",2)) !!,?4,$P($G(HFNAME),"^",2),! K COMMIT
 S:+HFNAME>0&($L($P($G(HFNAME),"^",2))>0) HFNAME=$P($G(HFNAME),"^",2)
 I HFNAME["^" W !!,?4,"Host File not found or not selected",! K COMMIT G LOADQ
 S HFOK=$$HFOK(HFNAME) I +($G(HFOK))'>0 D  G LOADQ
 . I $L($P(HFOK,"^",2)) W !!,?4,$P(HFOK,"^",2),! Q
 . W !!,?4,"Selected Host file failed format check",! Q
 S DEFF=$$DEFF(HFNAME) S LEFF=$$EFF^ZZLEXXCM(DEFF) I LEFF'?7N W !!,?4,"Effective Date not selected",! K COMMIT G LOADQ
 S ^ZZLEXX("ZZLEXXC",$J,"EFF")=LEFF
 I '$D(TEST) S TMP=$$TL^ZZLEXXCM(HFNAME) S:TMP>0 TEST="" I TMP["^" W !!,?4,"Load Aborted",! K COMMIT G LOADQ
 I '$D(TEST),'$D(COMMIT) I TMP'>0,'$D(TEST) S TMP=$$CM^ZZLEXXCM(HFNAME) S:TMP>0 COMMIT="",WASCOM=1 I TMP["^" W !!,?4,"Load Aborted",! K COMMIT G LOADQ
 K QUIET I $D(TEST),'$D(COMMIT) S TMP=$$BD^ZZLEXXCM S:TMP="B" QUIET=1 I TMP["^" W !!,?4,"Test Load Aborted",! K TEST,COMMIT G LOADQ
 K:$D(TEST) COMMIT I '$D(TEST),'$D(COMMIT) W !!,?4,"Neither a ""Test"" load nor an ""Actual"" load was selected",! K COMMIT,TEST G LOADQ
 W !! S ERRTOT=0 S ABRT=0 D UPD^ZZLEXXCC,AGE^ZZLEXXCD,SEX^ZZLEXXCE W !
 I +($G(ERRTOT))>0 D
 . W !!," ",+($G(ERRTOT))," error",$S(+($G(ERRTOT))>1:"s",1:"")," found. Fix the error",$S(+($G(ERRTOT))>1:"s",1:"")," in the data host file and retry"
 . W:$L($G(HFNAME)) !," Data host file name:  ",$G(HFNAME) W !
 . I +($G(WASCOM))>0 D
 . . N UPD,NOT S (UPD,NOT)=""
 . . S:$D(WASCOM("UPD")) UPD="Unacceptable as Principal DX"
 . . S:$D(WASCOM("AGE")) UPD=UPD_", Age Conflicts"
 . . S:$D(WASCOM("SEX")) UPD=UPD_", Sex Conflicts"
 . . S UPD=$$CS^ZZLEXXCM(UPD)
 . . S:'$D(WASCOM("UPD")) NOT="Unacceptable as Principal DX"
 . . S:'$D(WASCOM("AGE")) NOT=NOT_", Age Conflicts"
 . . S:'$D(WASCOM("SEX")) NOT=NOT_", Sex Conflicts"
 . . S NOT=$$CS^ZZLEXXCM(NOT)
 . . I $L($TR(UPD,", ","")) W !,"   Updated:      ",UPD
 . . I $L($TR(NOT,", ","")) W !,"   Not Updated:  ",NOT
LOADQ ;   Load Quit
 K ^ZZLEXX("ZZLEXXC",$J),%,%D,COMMIT,DEFF,LEFF,QUIET,HFNAME,EXTCON,TEST
 Q
 ; 
 ; Miscellaneous
HFILE(X) ;   Host File
 N HAS,HFV,NOT,PATH,ASX K ^ZZLEXX("ZZLEXXCM",$J) S HAS="DEFINITION;MEDICARE;EDIT",ASX=1
 S NOT="",PATH=$$PATH^ZZLEXXCM D DIR^ZZLEXXCM(PATH,NOT,HAS) S X=$$SEL^ZZLEXXCM K ^ZZLEXX("ZZLEXXCM",$J)
 Q X
HFOK(X) ;   Host File is OK
 N BEGIN,CHECK,EXIT,FND,HFNAME,I,M1,M2,M3,OK,OK1,OK2,OPEN,PATH,POP,SEC,SEQ,STOP,TX S HFNAME=$G(X) Q:'$L(HFNAME) 0
 S (BEGIN,SEC(1))="PERINATAL/NEWBORN DIAGNOSES",SEC(2)="PEDIATRIC DIAGNOSES (AGE 0 THROUGH 17)"
 S SEC(3)="MATERNITY DIAGNOSES (AGE 12 THROUGH 55)",SEC(4)="ADULT DIAGNOSES (AGE 15 THROUGH 124)"
 S SEC(5)="5. SEX CONFLICT",SEC(6)="DIAGNOSES FOR FEMALES ONLY",SEC(7)="PROCEDURES FOR FEMALES ONLY"
 S SEC(8)="DIAGNOSES FOR MALES ONLY",SEC(9)="PROCEDURES FOR MALES ONLY",SEC(10)="6. MANIFESTATION CODE AS PRINCIPAL DIAGNOSIS"
 S SEC(11)="UNACCEPTABLE PRINCIPAL DIAGNOSIS CODES",(STOP,SEC(12))="10. EDIT DISCONTINUED"
 S PATH=$$PATH^ZZLEXXCM,OPEN=$$OPEN^ZZLEXXCM(PATH,HFNAME,"CHK") I +OPEN'>0 Q 0
 S CHECK=0,EXIT=0 F  D  Q:EXIT>0  S EXIT=$$EOF^ZZLEXXCM Q:EXIT>0
 . N EXC,LINE,ULINE,I,TX S EXC="U IO R LINE S ULINE=$$UP^XLFSTR(LINE) U IO(0)" X EXC U IO(0)
 . S:ULINE=BEGIN CHECK=1 I +($G(CHECK))>0 S I=0 F  S I=$O(SEC(I)) Q:+I'>0  S TX=$G(SEC(I)) I $L(TX) D
 . . N S I ULINE=TX S FND(TX)="" S S=$O(SEQ(" "),-1)+1,SEQ(S)=TX
 . S:ULINE=STOP CHECK=0 S:ULINE=STOP EXIT=1
 U IO(0) D CLOSE^ZZLEXXCM("CHK")
 S (OK1,I)=0 F  S I=$O(SEC(I)) Q:+I'>0  S TX=$G(SEC(I)) I $L(TX) S:$D(FND(TX)) OK1=OK1+1
 S (OK2,I)=0 F  S I=$O(SEC(I)) Q:+I'>0  S TX=$G(SEC(I)) I $L(TX) S:$G(SEC(I))=$G(SEQ(I)) OK2=OK2+1
 S CHECK=$O(SEC(" "),-1) Q:CHECK'>0 0
 S M1="0^Selected host file missing required data sections"
 S M2="0^Selected host file has data sections out of order"
 S M3="1^Selected host file is in the correct format"
 Q:CHECK'=OK1 M1
 Q:CHECK'=OK2 M2
 Q M3
DEFF(X) ;   Default Effective Date
 N HFNAME S HFNAME=$G(X) Q:'$L($G(HFNAME)) ""  N PATH,OPEN,EXIT,OCT,SEG S PATH=$$PATH^ZZLEXXCM,TOT=0 S OPEN=$$OPEN^ZZLEXXCM(PATH,HFNAME,"EFF") I +OPEN'>0 Q ""
 S (SEG,EXIT)=0,OCT="" F  D  Q:EXIT>0  S EXIT=$$EOF^ZZLEXXCM Q:EXIT>0  Q:SEG>0  Q:$L(OCT)
 . N EXC,LINE,CODE,TIEN,AGEL,AGEH,TERM S EXC="U IO R LINE U IO(0)" X EXC U IO(0) I LINE["October" S OCT=LINE S SEG=1
 U IO(0) D CLOSE^ZZLEXXCM("EFF") S:OCT["OCTOBER" OCT=$P(OCT,"OCTOBER ",2) S:OCT["October" OCT=$P(OCT,"October ",2) S OCT=$$TM(OCT) I OCT?4N Q OCT
 Q ""
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
 N RANGE D HOME^%ZIS S U="^",DT=$$DT^XLFDT,DTIME=300 K POP
 N NM S NM=$$GET1^DIQ(200,(DUZ_","),.01)
 I '$L(NM) W !!,?5,"Invalid/Missing DUZ" Q 0
 S:$G(DUZ(0))'["@" DUZ(0)=$G(DUZ(0))_"@"
 Q 1
