ZZLEXXCF ;SLC/KER - Import - Conflicts - Update/Totals ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^ICD0(              ICR   4486
 ;    ^ICD9(              ICR   4485
 ;    ^ZZLEXX("ZZLEXXC"   SACC 1.3
 ;               
 ; External References
 ;    HOME^%ZIS           ICR  10086
 ;    FILE^DIE            ICR   2053
 ;    UPDATE^DIE          ICR   2053
 ;    $$GET1^DIQ          ICR   2056
 ;    $$DT^XLFDT          ICR  10103
 ;               
 ; Local Variables NEWed or KILLed Elsewhere
 ;     QUIET,TOT
 ;               
 Q
 ; Unacceptable as Principal DX 
UPDU(X,Y) ;   Unacceptable as Principal DX Update
 N DA,DIERR,FDA,IENS,VAL K DIERR,FDA S DA=+($G(X)),VAL=$G(Y)
 Q:'$D(^ICD9(DA,1))  Q:"^^1^"'[("^"_VAL_"^")  S IENS=(DA_",")
 S FDA(80,IENS,1.3)=VAL D FILE^DIE(,"FDA","DIERR") D:$D(DIERR) ERR
 Q
UPDTOT(X,Y) ;   Unacceptable as Principal DX Totals
 W !!," Unacceptable as Principal Diagnosis (UPD)",!
 N UPDS,UPDD S UPDS=+($G(X)),UPDD=+($G(Y)),COL=27 S:$D(COMMIT) COL=16
 I (UPDS+UPDD)>0 D
 . S HDR=$S($D(COMMIT):"   UPD Added:",1:"   UPD Possible Additions:")
 . W !,HDR,?COL,$J(+($G(UPDS)),5) W:+($G(UPDS))'>0 " - None Found"
 . S HDR=$S($D(COMMIT):"   UPD Deleted:",1:"   UPD Possible Deletions:")
 . W !,HDR,?COL,$J(+($G(UPDD)),5) W:+($G(UPDD))'>0 " - None Found"
 I (UPDS+UPDD)'>0 D
 . S HDR=$S($D(COMMIT):"No Adds/Deletes found",1:"No Possible Additions/Deletions found") W !,"     ",HDR
 N COMMIT,TEST
 Q
 ;
 ; Age Low/High
AGEL(X,Y,Z) ;   Age Low Update
 N CODE,EFF,EXIT,HIS,IEN,LEFF,LI,NEWL,OLDL,SI,TMP
 S IEN=+($G(X)),NEWL=$G(Y)
 S LEFF=$G(Z) S:LEFF'?7N LEFF=$G(^ZZLEXX("ZZLEXXC",$J,"EFF")) Q:$G(LEFF)'?7N
 S CODE=$P($G(^ICD9(+IEN,0)),"^",1)
 S TMP=(LEFF_"^"_NEWL),HIS=0
 S EXIT=0 F  S HIS=$O(^ICD9(+IEN,6,HIS)) Q:+HIS'>0  D
 . S:$G(^ICD9(+IEN,6,HIS,0))=TMP EXIT=1
 Q:EXIT
 S EFF=$O(^ICD9(+IEN,6,"B",(LEFF+.0001)),-1)
 S HIS=$O(^ICD9(+IEN,6,"B",+EFF," "),-1)
 S OLDL=$P($G(^ICD9(+IEN,6,+HIS,0)),"^",2)
 Q:$L(OLDL)&(OLDL?1N.N)&(OLDL=NEWL)
 Q:'$L((OLDL_NEWL))  Q:$L(OLDL)&(OLDL?1N.N)&(OLDL=NEWL)
 I $D(COMMIT) D
 . N DIERR,DA,FDA,FDAI,IENS K DIERR,FDA
 . S DA(1)=+IEN
 . S DA=$O(^ICD9(+IEN,6," "),-1)+1
 . S IENS=("+1,"_DA(1)_",")
 . S FDA(80.011,IENS,.01)=$G(LEFF)
 . S FDA(80.011,IENS,1)=$G(NEWL)
 . S FDAI(1)=DA
 . D UPDATE^DIE(,"FDA","FDAI","DIERR")
 . D:$D(DIERR) ERR S:'$D(DIERR) X=1
 S TOT=+($G(TOT))+1
 S TOT("L")=+($G(TOT("L")))+1
 S:NEWL?1N.N TOT("L","A")=+($G(TOT("L","A")))+1
 S:NEWL="" TOT("L","D")=+($G(TOT("L","D")))+1
 S:NEWL?1N.N TOT("L","A",NEWL)=+($G(TOT("L","A",NEWL)))+1
 S:NEWL=""&(OLDL?1N.N) TOT("L","D",OLDL)=+($G(TOT("L","D",OLDL)))+1
 I $D(TEST) D
 . S CT=+($G(CT))+1 W:'$D(QUIET)&(CT=1) !!," Before   After     Code            IEN"
 . N TRL,POST S TRL="" S:NEWL?1N.N TRL="Change Age Low" S:NEWL="" TRL="Delete Age Low"
 . S POST=$S(NEWL?1N.N:NEWL,1:"null") W:'$D(QUIET) !," ",OLDL,?10,POST,?20,CODE,?36,IEN,?49,TRL
 Q
AGEH(X,Y,Z) ;   Age High  Update
 N CODE,EFF,EXIT,HIS,IEN,LEFF,LI,NEWH,OLDH,SI S IEN=+($G(X)),NEWH=$G(Y)
 S LEFF=$G(Z) S:LEFF'?7N LEFF=$G(^ZZLEXX("ZZLEXXC",$J,"EFF")) Q:$G(LEFF)'?7N
 S CODE=$P($G(^ICD9(+IEN,0)),"^",1)
 S TMP=(LEFF_"^"_NEWH),HIS=0
 S EXIT=0 F  S HIS=$O(^ICD9(+IEN,7,HIS)) Q:+HIS'>0  D
 . S:$G(^ICD9(+IEN,7,HIS,0))=TMP EXIT=1
 Q:EXIT
 S EFF=$O(^ICD9(+IEN,7,"B",(LEFF+.0001)),-1)
 S HIS=$O(^ICD9(+IEN,7,"B",+EFF," "),-1)
 S OLDH=$P($G(^ICD9(+IEN,7,+HIS,0)),"^",2)
 Q:'$L((OLDH_NEWH))  Q:$L(OLDH)&(OLDH?1N.N)&(OLDH=NEWH)
 I $D(COMMIT) D
 . N DIERR,DA,FDA,FDAI,IENS K DIERR,FDA
 . S DA(1)=+IEN
 . S DA=$O(^ICD9(+IEN,7," "),-1)+1
 . S IENS=("+1,"_DA(1)_",")
 . S FDA(80.012,IENS,.01)=$G(LEFF)
 . S FDA(80.012,IENS,1)=$G(NEWL)
 . S FDAI(1)=DA
 . D UPDATE^DIE(,"FDA","FDAI","DIERR")
 . D:$D(DIERR) ERR S:'$D(DIERR) X=1
 S TOT=+($G(TOT))+1
 S TOT("H")=+($G(TOT("H")))+1
 S:NEWH?1N.N TOT("H","A")=+($G(TOT("H","A")))+1
 S:NEWH="" TOT("H","D")=+($G(TOT("H","D")))+1
 S:NEWH?1N.N TOT("H","A",NEWH)=+($G(TOT("H","A",NEWH)))+1
 S:NEWH=""&(OLDH?1N.N) TOT("H","D",OLDH)=+($G(TOT("H","D",OLDH)))+1
 I $D(TEST) D
 . S CT=+($G(CT))+1 W:'$D(QUIET)&(CT=1) !!," Before   After     Code            IEN"
 . N TRL,POST S TRL="" S:NEWH?1N.N TRL="Change Age High" S:NEWH="" TRL="Delete Age High"
 . S POST=$S(NEWH?1N.N:NEWH,1:"null") W:'$D(QUIET) !," ",OLDH,?10,POST,?20,CODE,?36,IEN,?49,TRL
 Q
AGETOT ;   Age Low/High Totals
 N HDR,COL,AGE S COL=43 S:$D(COMMIT) COL=31 W !!," ICD-10 Age Low/Age High Conflicts"
 I +($G(TOT))'>0 D  Q
 . S HDR=$S($D(COMMIT):"No Adds/Deletes found",1:"No Possible Additions/Deletions found") W !!,"     ",HDR,!
 S HDR=$S($D(COMMIT):"   Total Changes:",1:"   Total Possible Changes:")
 W:+($G(TOT))>0 !!,HDR,?COL,$J(+($G(TOT)),5)
 S HDR=$S($D(COMMIT):"      Total Age Low Changes:",1:"      Total Possible Age Low Changes:")
 W:+($G(TOT("L")))>0 !,HDR,?COL,$J(+($G(TOT("L"))),5)
 S HDR=$S($D(COMMIT):"         Age Low Added:",1:"         Age Low Possible Additions:")
 W:+($G(TOT("L","A")))>0 !,HDR,?COL,$J(+($G(TOT("L","A"))),5)
 S AGE="" F  S AGE=$O(TOT("L","A",AGE)) Q:'$L(AGE)  D
 . N CT S CT=+($G(TOT("L","A",AGE))) Q:CT'>0
 . W !,"            Age Low - ",AGE,?COL,$J(CT,5)
 S HDR=$S($D(COMMIT):"         Age Low Deleted:",1:"         Age Low Possible Deletions:")
 W:+($G(TOT("L","D")))>0 !,HDR,?COL,$J(+($G(TOT("L","D"))),5)
 S AGE="" F  S AGE=$O(TOT("L","D",AGE)) Q:'$L(AGE)  D
 . N CT S CT=+($G(TOT("L","D",AGE))) Q:CT'>0
 . W !,"            Age Low - ",AGE,?COL,$J(CT,5)
 S HDR=$S($D(COMMIT):"      Total Age High Changes:",1:"      Total Possible Age High Changes:")
 W:+($G(TOT("H")))>0 !,HDR,?COL,$J(+($G(TOT("H"))),5)
 S HDR=$S($D(COMMIT):"         Age High Added:",1:"         Age High Possible Additions:")
 W:+($G(TOT("H","A")))>0 !,HDR,?COL,$J(+($G(TOT("H","A"))),5)
 S AGE="" F  S AGE=$O(TOT("H","A",AGE)) Q:'$L(AGE)  D
 . N CT S CT=+($G(TOT("H","A",AGE))) Q:CT'>0
 . W !,"            Age High - ",AGE,?COL,$J(CT,5)
 S HDR=$S($D(COMMIT):"         Age High Deleted:",1:"         Age High Possible Deletions:")
 W:+($G(TOT("H","D")))>0 !,HDR,?COL,$J(+($G(TOT("H","D"))),5)
 S AGE="" F  S AGE=$O(TOT("H","D",AGE)) Q:'$L(AGE)  D
 . N CT S CT=+($G(TOT("H","D",AGE))) Q:CT'>0
 . W !,"            Age High - ",AGE,?COL,$J(CT,5)
 N COMMIT,TEST
 Q
 ;
 ; Sex
SEXT(X,Y,Z) ;   Sex Total Update
 N TY,SEX,ACT,AT S TY=$G(X),SEX=$G(Y),AT=$G(Z)
 Q:"^D^P^"'[("^"_$G(TY)_"^")  Q:"^M^F^N^"'[("^"_$G(SEX)_"^")  Q:"^A^D^"'[("^"_$G(AT)_"^")
 S ACT=$S(AT="A":"ADD",AT="D":"DEL",1:"") Q:'$L(ACT)
 S TOT=+($G(TOT))+1
 S TOT(TY)=+($G(TOT(TY)))+1
 S TOT(TY,SEX)=+($G(TOT(TY,SEX)))+1
 S TOT(TY,SEX,AT)=+($G(TOT(TY,SEX,AT)))+1
 S ^ZZLEXX("ZZLEXXC",$J,ACT,TY,(CODE_" "))=SEX
 Q
SEXW(B,A,I,C,T) ;   Sex Write
 Q:$D(QUIET)  Q:'$D(TEST)  N CX,TCX,SX,TSX,IEN,CODE,TERM S (CX,TCX)=$G(B) S:'$L(TCX) TCX="N"
 S (SX,TSX)=$G(A) S:'$L(TSX) TSX="N" S IEN=+($G(I)),CODE=$G(C),TERM(1)=$G(T) I CX'=SX,CX'=TSX D
 . S CT=+($G(CT))+1 W:CT=1&(CODE'[".") ! W:'$D(QUIET)&(CT=1) !," Before   After     Code            IEN"
 . N BEF,AFT S BEF=CX S:'$L(BEF) BEF="null" S AFT=TSX
 . W:'$D(QUIET) !," ",BEF,?10,AFT,?20,CODE,?36,IEN
 . W:'$D(QUIET)&(AFT'="N") ?49,"Change" W:'$D(QUIET)&(AFT="N") ?49,"Delete"
 . I $L($G(TERM(1))) D
 . . D PR^ZZLEXXCM(.TERM,(79-49)) W:'$D(QUIET) !,?49,$G(TERM(1))
 . . N I S I=1 F  S I=$O(TERM(I)) Q:+I'>0  W:'$D(QUIET) !,?49,$G(TERM(I))
 Q
SEXU(X,I,Y,Z) ;   Sex Update
 N DA,EFF,DIERR,FDA,FDAI,FILE,FND,HIS,IEN,IENS,ND,RT,SEX S FILE=$G(X) Q:"^80^80.1^"'[("^"_FILE_"^") 0
 S IEN=+($G(I)) Q:IEN'>0 0  S SEX=$G(Y) Q:"^^N^M^F^"'[("^"_SEX_"^") 0  S EFF=$G(Z) Q:EFF'?7N 0  S X=0
 I FILE=80 D
 . N FND,HIS,DIERR,FDA,FDAI,IENS K DIERR,FDA
 . S FND=0,HIS=0 F  S HIS=$O(^ICD9(+IEN,5,HIS)) Q:+HIS'>0  D
 . . S:$G(^ICD9(+IEN,5,HIS,0))=(EFF_"^"_SEX) FND=1
 . Q:FND>0  Q:'$D(COMMIT)  K FDA,DIERR
 . S DA(1)=+IEN
 . S DA=$O(^ICD9(+IEN,5," "),-1)+1
 . S IENS=("+1,"_DA(1)_",")
 . S FDA(80.04,IENS,.01)=$G(EFF)
 . S FDA(80.04,IENS,1)=$G(SEX)
 . S FDAI(1)=DA
 . D UPDATE^DIE(,"FDA","FDAI","DIERR")
 . D:$D(DIERR) ERR S:'$D(DIERR) X=1
 I FILE=80.1 D
 . N FND,HIS,DIERR,FDA,FDAI,IENS K DIERR,FDA
 . S FND=0,HIS=0 F  S HIS=$O(^ICD0(+IEN,3,HIS)) Q:+HIS'>0  D
 . . S:$G(^ICD0(+IEN,3,HIS,0))=(EFF_"^"_SEX) FND=1
 . Q:FND>0  Q:'$D(COMMIT)  K FDA,DIERR
 . S DA(1)=+IEN
 . S DA=$O(^ICD0(+IEN,3," "),-1)+1
 . S IENS=("+1,"_DA(1)_",")
 . S FDA(80.11,IENS,.01)=$G(EFF)
 . S FDA(80.11,IENS,1)=$G(SEX)
 . S FDAI(1)=DA
 . D UPDATE^DIE(,"FDA","FDAI","DIERR")
 . D:$D(DIERR) ERR S:'$D(DIERR) X=1
 Q X
SEXTOT ;   Sex Totals
 N HDR,COL S COL=43 S:$D(COMMIT) COL=31 W !!," ICD-10 Sex Conflicts (M/F)"
 I +($G(TOT))'>0 D  Q
 . S HDR=$S($D(COMMIT):"No Adds/Deletes found",1:"No Possible Additions/Deletions found") W !!,"     ",HDR,!
 S HDR=$S($D(COMMIT):"   Total Changes:",1:"   Total Possible Changes:")
 W:+($G(TOT))>0 !!,HDR,?COL,$J(+($G(TOT)),5)
 S HDR=$S($D(COMMIT):"      Total Diagnosis Changes:",1:"      Total Possible Diagnosis Changes:")
 W:+($G(TOT("D")))>0 !,HDR,?COL,$J(+($G(TOT("D"))),5)
 S HDR=$S($D(COMMIT):"         Male Added:",1:"         Male Possible Additions:")
 W:+($G(TOT("D","M","A")))>0 !,HDR,?COL,$J(+($G(TOT("D","M","A"))),5)
 S HDR=$S($D(COMMIT):"         Male Deleted:",1:"         Male Possible Deletions:")
 W:+($G(TOT("D","M","D")))>0 !,HDR,?COL,$J(+($G(TOT("D","M","D"))),5)
 S HDR=$S($D(COMMIT):"         Female  Added:",1:"         Female Possible Additions:")
 W:+($G(TOT("D","F","A")))>0 !,HDR,?COL,$J(+($G(TOT("D","F","A"))),5)
 S HDR=$S($D(COMMIT):"         Female Deleted:",1:"         Female Possible Deletions:")
 W:+($G(TOT("D","F","D")))>0 !,HDR,?COL,$J(+($G(TOT("D","F","D"))),5)
 S HDR=$S($D(COMMIT):"      Total Procedure Changes:",1:"      Total Possible Procedure Changes:")
 W:+($G(TOT("P")))>0 !,HDR,?COL,$J(+($G(TOT("P"))),5)
 S HDR=$S($D(COMMIT):"         Male Added:",1:"         Male Possible Additions:")
 W:+($G(TOT("P","M","A")))>0 !,HDR,?COL,$J(+($G(TOT("P","M","A"))),5)
 S HDR=$S($D(COMMIT):"         Male Deleted:",1:"         Male Possible Deletions:")
 W:+($G(TOT("P","M","D")))>0 !,HDR,?COL,$J(+($G(TOT("P","M","D"))),5)
 S HDR=$S($D(COMMIT):"         Female Added:",1:"         Female Possible Additions:")
 W:+($G(TOT("P","F","A")))>0 !,HDR,?COL,$J(+($G(TOT("P","F","A"))),5)
 S HDR=$S($D(COMMIT):"         Female Deleted:",1:"         Female Possible Deletions:")
 W:+($G(TOT("P","F","D")))>0 !,HDR,?COL,$J(+($G(TOT("P","F","D"))),5)
 N COMMIT,TEST
 Q
 ; 
 ; Miscellaneous
ERR ;   FileMan Errors
 N SEQ S SEQ=0 F  S SEQ=$O(DIERR("DIERR",$J,SEQ)) Q:+SEQ'>0  D
 . N TI,TX S TI=0 F  S TI=$O(DIERR("DIERR",$J,SEQ,"TEXT",TI)) Q:+TI'>0  D
 . . N TMP,TXI S TMP=$G(DIERR("DIERR",$J,SEQ,"TEXT",TI)) Q:'$L(TMP)
 . . S TXI=$O(TX(" "),-1)+1,TX(TXI)=TMP
 . Q:$O(TX(0))'>0  D PR^ZZLEXXCM(.TX,50) S TX(1)="ERROR>>  "
 . W !,?2,$G(TX(1)) S TI=1 F  S TI=$O(TX(TI)) Q:+TI'>0  W !,?11,$G(TX(TI))
 Q
TM(X,Y) ;   Trim Character Y - Default " " Space
 S X=$G(X) Q:X="" X  S Y=$G(Y) S:'$L(Y) Y=" "
 F  Q:$E(X,1)'=Y  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=Y  S X=$E(X,1,($L(X)-1))
 Q X
KILL ;   Kill Global
 K ^ZZLEXX("ZZLEXXC",$J),^ZZLEXX("ZZLEXXCM",$J),^ZZLEXX("ZZLEXXCH",$J)
 Q
LR(X) ;   Local Routine
 S X=$$LR^ZZLEXXCB
 Q X
ENV(X) ;   Environment
 N RANGE D HOME^%ZIS S U="^",DT=$$DT^XLFDT,DTIME=300 K POP
 N NM S NM=$$GET1^DIQ(200,(DUZ_","),.01)
 I '$L(NM) W !!,?5,"Invalid/Missing DUZ" Q 0
 S:$G(DUZ(0))'["@" DUZ(0)=$G(DUZ(0))_"@"
 Q 1
