ZZLEXXCD ;SLC/KER - Import - Conflicts - Age ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^ICD9(              ICR   4485
 ;    ^ZZLEXX("ZZLEXXC"   SACC 1.3
 ;               
 ; External References
 ;    HOME^%ZIS           ICR  10086
 ;    $$GET1^DIQ          ICR   2056
 ;    $$CODEABA^ICDEX     ICR   5747
 ;    $$DT^XLFDT          ICR  10103
 ;               
 ; Local Variables NEWed or KILLed Elsewhere
 ;     ABRT,ERRTOT,HFNAME,TEST,WASCOM
 ;               
 Q
AGE ; Age Low/High
 N NEWH,NEWL,S1,S2,S3,S4,SS,RAN,START,STOP,ERR,PATH,TOT,OPEN,LEFF,START,STOP
 Q:'$L($G(HFNAME))  S PATH=$$PATH^ZZLEXXCM,TOT=0 S OPEN=$$OPEN^ZZLEXXCM(PATH,HFNAME,"CHK") I +OPEN'>0 D  Q
 . S ABRT=1 W:$L($P($G(OPEN),"^",2)) !!,?4,$L($P($G(OPEN),"^",2)) K COMMIT
 S S1="PERINATAL/NEWBORN DIAGNOSES",S2="PEDIATRIC DIAGNOSES",S3="MATERNITY DIAGNOSES",S4="ADULT DIAGNOSES"
 S LEFF=$G(^ZZLEXX("ZZLEXXC",$J,"EFF")) Q:$G(LEFF)'?7N  S ERR=0,START=S1,STOP="5. SEX CONFLICT"
 S EXIT=0 F  D  Q:EXIT>0  S EXIT=$$EOF^ZZLEXXCM Q:EXIT>0
 . N EXC,LINE,ULINE,CODE,TIEN,AGEL,AGEH,TERM S EXC="U IO R LINE S ULINE=$$UP^XLFSTR(LINE) U IO(0)" X EXC U IO(0)
 . I LINE="Perinatal/Newborn diagnoses"!(ULINE=S1) D
 . . N CT,ORD,AGELS,AGELD,AGEHS,AGEHD,COL,HDR,TOT,EXIT,SEG,SEC,AGEH,AGEL,SS,TAB
 . . S (EXIT,SEG,SEC,AGEH,AGEL)=0,TAB=$C(9),SS=S1,SEC=1
 . . F  U IO D  Q:EXIT>0  S EXIT=$$EOF^ZZLEXXCM Q:EXIT>0  Q:SEG>0
 . . . N EXC,LINE,ULINE,IEN S EXC="U IO R LINE S ULINE=$$UP^XLFSTR($G(LINE)) U IO(0)" X EXC U IO(0)
 . . . S CODE=$$TM($P(ULINE,TAB,1)),TERM=$$TM($P(LINE,TAB,2))
 . . . I CODE[S2 S AGEL=0,AGEH=17,SS=S2,SEC=SEC+1 Q
 . . . I CODE[S3 S AGEL=12,AGEH=55,SS=S3,SEC=SEC+1 Q
 . . . I CODE[S4 S AGEL=15,AGEH=124,SS=S4,SEC=SEC+1 Q
 . . . I SEC=4,$E(CODE,1)'?1U!($E(CODE,2)'?1N)!($L(CODE)<3)!($L(CODE)>8) S (EXIT,SEG)=1 Q
 . . . I SEC=4,'$L($G(ULINE)) S (EXIT,SEG)=1 Q
 . . . I '$L(CODE)!'$L(TERM) Q
 . . . Q:'$L(LINE)  S CODE=$$DXC(CODE)
 . . . I $E(CODE,1)'?1U!($E(CODE,2)'?1N)!($E(CODE,3)'?1NU)!($E(CODE,4)'=".")!($L(CODE)'>3)!($L(CODE)>8) D  Q
 . . . . N TX S TX=">>>>> Error:  Invalid Diagnosis Code Format - "_$G(CODE) D ER(TX,TERM)
 . . . I $E(CODE,1)'?1U!($E(CODE,2)'?1N)!($E(CODE,3)'?1NU) Q
 . . . S IEN=$$CODEABA^ICDEX(CODE,80,30)
 . . . I +($G(IEN))'>0!('$D(^ICD9(+($G(IEN)),0))) D  Q
 . . . . N TX S TX=">>>>> Error:  Diagnosis Code not found in file 80 - "_$G(CODE) D ER(TX,TERM)
 . . . I $L(SS) S:'$D(RAN(SS,"BEG")) RAN(SS,"BEG")=CODE S RAN(SS,"END")=CODE
 . . . S ^ZZLEXX("ZZLEXXC",$J,"AGE",(CODE_" "))=AGEL_"^"_AGEH_"^"_TERM
 U IO(0) D CLOSE^ZZLEXXCM("CHK") I +ERR>0 D  Q
 . W !!," Fix Age errors in data host file then retry",! K COMMIT S ABRT=1
 . S ERRTOT=+($G(ERRTOT))+ERR
 I '$D(^ZZLEXX("ZZLEXXC",$J,"AGE")) D  Q
 . W !!," 'Age Conflicts' not loaded",! K COMMIT S ABRT=1
 I '$D(^ZZLEXX("ZZLEXXC",$J,"EFF")) D  Q
 . W !!," Effective date not found, re-check the host file and retry",! K COMMIT S ABRT=1
 K:$D(TEST) COMMIT S (AGELS,AGELD,AGEHS,AGEHD)=0,CT=0 Q:'$D(^ZZLEXX("ZZLEXXC",$J))
 S ORD="" F  S ORD=$O(^ICD9("ABA",30,ORD)) Q:'$L(ORD)  D
 . N IEN S IEN=0 F  S IEN=$O(^ICD9("ABA",30,ORD,IEN)) Q:+IEN'>0  D
 . . N CODE,EFF,HIS,LEFF,STA,UPD,NEW
 . . S CODE=$P($G(^ICD9(+IEN,0)),"^",1) Q:'$L(CODE)
 . . S EFF=$O(^ICD9(+IEN,66,"B",9999999),-1) Q:+EFF'?7N
 . . S HIS=$O(^ICD9(+IEN,66,"B",+EFF," "),-1) Q:+HIS'>0
 . . S STA=$P($G(^ICD9(+IEN,66,+HIS,0)),"^",2) Q:+STA'>0
 . . S UPD=$P($G(^ICD9(+IEN,1)),"^",3)
 . . S LEFF=$G(^ZZLEXX("ZZLEXXC",$J,"EFF")) Q:$G(LEFF)'?7N
 . . S NEW=$G(^ZZLEXX("ZZLEXXC",$J,"AGE",(CODE_" ")))
 . . S NEWL=$P(NEW,"^",1)
 . . S NEWH=$P(NEW,"^",2)
 . . D AGEL^ZZLEXXCF(IEN,NEWL,LEFF)
 . . D AGEH^ZZLEXXCF(IEN,NEWH,LEFF)
 S:+($G(TOT))>0 WASCOM("AGE")="" D AGETOT^ZZLEXXCF
 I $D(RANGE) W !! ZW RAN
 Q
 ; 
 ; Miscellaneous
DXC(X) ;   Diagnosis Code Format
 N CODE S CODE=$$TM($G(X)) Q:'$L(CODE) ""  S CODE=$TR(CODE,".","") S CODE=$E(CODE,1,3)_"."_$E(CODE,4,$L(CODE)),X=CODE
 Q X
ER(X,Y) ;   Write Error
 N ER,TM,I S ER=$$TM($G(X)),TM(1)=$$TM($G(Y)) W:+($G(ERR))'>0 !," Age Low/Age High Conflict errors:",!
 W !," ",ER D PR^ZZLEXXCM(.TM,63) W:$L($G(TM(1))) !,?15,$G(TM(1))
 S I=1 F  S I=$O(TM(I)) Q:+I'>0  W:$L($G(TM(I))) !,?15,$G(TM(I))
 S ERR=+($G(ERR))+1 K COMMIT
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
