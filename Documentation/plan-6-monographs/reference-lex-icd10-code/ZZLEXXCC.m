ZZLEXXCC ;SLC/KER - Import - Conflicts - UPD ;10/26/2017
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
 ;     ABRT,ERR,ERRTOT,HFNAME,OPEN,PATH,QUIET,TEST,WASCOM
 ;               
 Q
UPD ; Unacceptable as Principal DX 
 N CODE,COL,CT,EFF,HDR,HIS,IEN,NEW,ORD,STA,UPD,UPDD,UPDS,RAN S ERR=0
 Q:'$L($G(HFNAME))  S PATH=$$PATH^ZZLEXXCM,TOT=0 S OPEN=$$OPEN^ZZLEXXCM(PATH,HFNAME,"CHK") I +OPEN'>0 D  Q
 . S ABRT=1 W:$L($P($G(OPEN),"^",2)) !!,?4,$L($P($G(OPEN),"^",2)) K COMMIT
 S EXIT=0 F  D  Q:EXIT>0  S EXIT=$$EOF^ZZLEXXCM Q:EXIT>0
 . N S1,EXC,LINE,ULINE,CODE,TIEN,TERM S EXC="U IO R LINE S ULINE=$$UP^XLFSTR(LINE) U IO(0)" X EXC U IO(0)
 . S S1="UNACCEPTABLE PRINCIPAL DIAGNOSIS CODES"
 . I ULINE=S1 D
 . . N CT,TOT,EXIT,SEG,SS,TAB,IEN
 . . S (EXIT,SEG)=0,TAB=$C(9),SS=S1
 . . F  U IO D  Q:EXIT>0  S EXIT=$$EOF^ZZLEXXCM Q:EXIT>0  Q:SEG>0
 . . . N EXC,LINE,ULINE S EXC="U IO R LINE S ULINE=$$UP^XLFSTR($G(LINE)) U IO(0)" X EXC U IO(0)
 . . . S CODE=$$TM($P(ULINE,TAB,1)),TERM=$$TM($P(LINE,TAB,2)) Q:CODE["*"  Q:CODE="Z5189"
 . . . I '$L(CODE)!'$L(TERM) S (EXIT,SEG)=1 Q
 . . . S CODE=$$DXC(CODE)
 . . . I $E(CODE,1)'?1U!($E(CODE,2)'?1N)!($E(CODE,3)'?1NU)!($E(CODE,4)'=".")!($L(CODE)'>3)!($L(CODE)>8) D  Q
 . . . . N TX S TX=">>>>> Error:  Invalid Diagnosis Code Format - "_$G(CODE) D ER(TX,TERM)
 . . . S IEN=$$CODEABA^ICDEX(CODE,80,30)
 . . . I +($G(IEN))'>0!('$D(^ICD9(+($G(IEN)),0))) D  Q
 . . . . N TX S TX=">>>>> Error:  Diagnosis Code not found in file 80 - "_$G(CODE) D ER(TX,TERM)
 . . . S:'$D(RAN(S1,"BEG")) RAN(S1,"BEG")=CODE S RAN(S1,"END")=CODE
 . . . S ^ZZLEXX("ZZLEXXC",$J,"UPD",(CODE_" "))=TERM
 U IO(0) D CLOSE^ZZLEXXCM("CHK") I +ERR>0 D  Q
 . W !!," Fix UPD errors in data host file then retry",! K COMMIT S ABRT=1
 . S ERRTOT=+($G(ERRTOT))+ERR
 I '$D(^ZZLEXX("ZZLEXXC",$J,"UPD")) D  Q
 . W !!," 'Unacceptable as Principal DX' not loaded",! K COMMIT S ABRT=1
 N CODE,COL,CT,EFF,HDR,HIS,IEN,NEW,ORD,STA,UPD,UPDD,UPDS
 S (UPDS,UPDD,CT)=0 K:$D(TEST) COMMIT
 S ORD="" F  S ORD=$O(^ICD9("ABA",30,ORD)) Q:'$L(ORD)  D
 . N CHR,IEN S CHR=$E(ORD,1) I $D(EXTCON),"^V^W^X^Y^"[("^"_CHR_"^") S ^ZZLEXX("ZZLEXXC",$J,"UPD",ORD)=""
 . S IEN=0 F  S IEN=$O(^ICD9("ABA",30,ORD,IEN)) Q:+IEN'>0  D
 . . N CODE,EFF,HIS,STA,UPD,NEW
 . . S CODE=$P($G(^ICD9(+IEN,0)),"^",1) Q:'$L(CODE)
 . . S EFF=$O(^ICD9(+IEN,66,"B",9999999),-1) Q:+EFF'?7N
 . . S HIS=$O(^ICD9(+IEN,66,"B",+EFF," "),-1) Q:+HIS'>0
 . . S STA=$P($G(^ICD9(+IEN,66,+HIS,0)),"^",2) Q:+STA'>0
 . . S UPD=$P($G(^ICD9(+IEN,1)),"^",3)
 . . S NEW=$S($D(^ZZLEXX("ZZLEXXC",$J,"UPD",(CODE_" "))):1,1:"")
 . . I $D(^ZZLEXX("ZZLEXXC",$J,"UPD",(CODE_" "))) D
 . . . Q:+($G(UPD))>0
 . . . S CT=CT+1 I CT=1 D
 . . . . I '$D(QUIET),$D(TEST) W !," Before",?9,"After",?18,"Code",?32,"IEN"
 . . . I '$D(QUIET),$D(TEST) W !," ","0",?9,1,?18,CODE,?32,IEN
 . . . S UPDS=+($G(UPDS))+1
 . . . S ^ZZLEXX("ZZLEXXC",$J,"ADD",(CODE_" "))=""
 . . . I $D(COMMIT) D UPDU^ZZLEXXCF(+IEN,1)
 . . I '$D(^ZZLEXX("ZZLEXXC",$J,"UPD",(CODE_" "))) D
 . . . Q:+($G(UPD))'>0
 . . . S CT=CT+1 I CT=1 D
 . . . . I '$D(QUIET),$D(TEST) W !," Before",?9,"After",?18,"Code",?32,"IEN"
 . . . I '$D(QUIET),$D(TEST) W !," ","1",?9,"0",?18,CODE,?32,IEN
 . . . S UPDD=+($G(UPDD))+1
 . . . S ^ZZLEXX("ZZLEXXC",$J,"DEL",(CODE_" "))=""
 . . . I $D(COMMIT) D UPDU^ZZLEXXCF(+IEN,"")
 S:(UPDS+UPDD)>0 WASCOM("UPD")="" D UPDTOT^ZZLEXXCF($G(UPDS),$G(UPDD))
 N EXTCON I $D(RANGE) W !! ZW RAN
 Q
 ; 
 ; Miscellaneous
DXC(X) ;   Diagnosis Code Format
 N CODE S CODE=$$TM($G(X)) Q:'$L(CODE) ""  S CODE=$TR(CODE,".","") S CODE=$E(CODE,1,3)_"."_$E(CODE,4,$L(CODE)),X=CODE
 Q X
ER(X,Y) ;   Write Error
 N ER,TM,I S ER=$$TM($G(X)),TM(1)=$$TM($G(Y)) W:+($G(ERR))'>0 !," Unacceptable as Principal Diagnosis Conflict errors:",!
 W !," ",ER D PR^ZZLEXXCM(.TM,63) W:$L($G(TM(1))) !,?15,$G(TM(1)) S I=1 F  S I=$O(TM(I)) Q:+I'>0  W:$L($G(TM(I))) !,?15,$G(TM(I))
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
