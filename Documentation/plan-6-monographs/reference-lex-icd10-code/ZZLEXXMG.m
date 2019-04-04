ZZLEXXMG ;SLC/KER - Import - Misc - SDO/DD Field Lengths ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    None
 ;               
 ; External References
 ;    None
 ;               
 Q
LEN ; SDO/DD Lengths
 N DXNAME,PRNAME S DXNAME=$$ICDF^ZZLEXXAA I +DXNAME'>0 D  Q
 . W !!,?4,"ICD Diagnosis Host File not found or not selected",!
 S:+DXNAME>0&($L($P($G(DXNAME),"^",2))>0) DXNAME=$P($G(DXNAME),"^",2)
 I DXNAME["^" W !!,?4,"ICD Diagnosis Host File not found or not selected",! Q
 S PRNAME=$$ICDF^ZZLEXXBA I +PRNAME'>0 D  Q
 . W !!,?4,"ICD Procedure Host File not found or not selected",!
 S:+PRNAME>0&($L($P($G(PRNAME),"^",2))>0) PRNAME=$P($G(PRNAME),"^",2)
 I PRNAME["^" W !!,?4,"ICD Procedure Host File not found or not selected",! Q
 D DX,PR
 Q
DX ; ICD-10-CM Diagnosis
 N CMAX,CMIN,CODE,EXC,EXIT,FLAG,LINE,LLTXT,LMAX,LMIN,LSTXT,OPEN,PATH,SMAX,SMIN
 ;   Open Host File
 S PATH=$$PATH^ZZLEXXAM,OPEN=$$OPEN^ZZLEXXAM(PATH,DXNAME,"DXCHK") I +OPEN'>0 D  Q
 . W:$L($P($G(OPEN),"^",2)) !!,?4,$L($P($G(OPEN),"^",2))
 ;   Check Host File
 S (SMIN,SMAX,LMIN,LMAX,CMIN,CMAX)=0
 S EXIT=0 F  D  S EXIT=$$EOF^ZZLEXXAM Q:EXIT>0
 . S EXC="U IO R LINE U IO(0)" X EXC U IO(0)
 . S LINE=$TR(LINE,$C(9)," ") Q:'$L($$TM(LINE))
 . ;     Flag                15      1
 . S FLAG=+($E(LINE,15)) Q:FLAG'>0
 . ;     Code                 7      7
 . S CODE=$E(LINE,7,14) I CODE["*" D  Q
 . . S CODE=$$TM($TR(CODE,"*.","")),CODE=$E(CODE,1,3)_"."_$E(CODE,4,$L(CODE))
 . S CODE=$$TM(CODE)
 . I '$L(CODE),$L($$TM(LINE)) Q
 . S CODE=$$TM($E(CODE,1,3)_"."_$E(CODE,4,$L(CODE)))
 . I $E(CODE,1)'?1U!($L($P(CODE,".",1))'=3) Q
 . S:CMIN'>0 CMIN=$L(CODE) S:$L(CODE)<CMIN CMIN=$L(CODE)
 . S:CMAX'>0 CMAX=$L(CODE) S:$L(CODE)>CMAX CMAX=$L(CODE)
 . ;     Short Description   17     60
 . S LSTXT=$$TM($E(LINE,17,77))
 . S:SMIN'>0 SMIN=$L(LSTXT) S:$L(LSTXT)<SMIN SMIN=$L(LSTXT)
 . S:SMAX'>0 SMAX=$L(LSTXT) S:$L(LSTXT)>SMAX SMAX=$L(LSTXT)
 . ;     Long Description    78     End
 . S LLTXT=$$TM($E(LINE,78,$L(LINE)))
 . S:LMIN'>0 LMIN=$L(LLTXT) S:$L(LLTXT)<LMIN LMIN=$L(LLTXT)
 . S:LMAX'>0 LMAX=$L(LLTXT) S:$L(LLTXT)>LMAX LMAX=$L(LLTXT)
 ;   Close Host File
 U IO(0) D CLOSE^ZZLEXXAM("DXCHK") W !
 W !," ICD-10-CM Diagnosis Data Lengths (SDO Lengths/DD Lengths)",!
 W !,?4,"Code",?26,+($G(CMIN)),"-",+($G(CMAX)),?40,"1-8"
 W !,?4,"Short Description",?26,+($G(SMIN)),"-",+($G(SMAX)),?40,"1-60"
 W !,?4,"Long Description",?26,+($G(LMIN)),"-",+($G(LMAX)),?40,"1-245"
 Q
PR ; ICD-10-PCS Procedures
 N CMAX,CMIN,CODE,EXC,EXIT,FLAG,LINE,LLTXT,LMAX,LMIN,LSTXT,OPEN,PATH,SMAX,SMIN
 ;   Open Host File
 S PATH=$$PATH^ZZLEXXBM,OPEN=$$OPEN^ZZLEXXBM(PATH,PRNAME,"PRCHK") I +OPEN'>0 D  Q
 . W:$L($P($G(OPEN),"^",2)) !!,?4,$L($P($G(OPEN),"^",2))
 ;   Check Host File
 S (SMIN,SMAX,LMIN,LMAX,CMIN,CMAX)=0
 S EXIT=0 F  D  S EXIT=$$EOF^ZZLEXXBM Q:EXIT>0
 . S EXC="U IO R LINE U IO(0)" X EXC U IO(0) S LINE=$TR(LINE,$C(9)," ") Q:'$L($$TM(LINE))
 . ;     Flag                15      1
 . S FLAG=+($E(LINE,15)) Q:FLAG'>0
 . ;     Code                 7      7
 . S CODE=$E(LINE,7,14) I CODE["*" S CODE=$$TM($TR(CODE,"*.","")) Q
 . S CODE=$$TM(CODE) I '$L(CODE),$L($$TM(LINE)) Q
 . S:CMIN'>0 CMIN=$L(CODE) S:$L(CODE)<CMIN CMIN=$L(CODE)
 . S:CMAX'>0 CMAX=$L(CODE) S:$L(CODE)>CMAX CMAX=$L(CODE)
 . ;     Short Description   17     60
 . S LSTXT=$$TM($E(LINE,17,77))
 . S:SMIN'>0 SMIN=$L(LSTXT) S:$L(LSTXT)<SMIN SMIN=$L(LSTXT)
 . S:SMAX'>0 SMAX=$L(LSTXT) S:$L(LSTXT)>SMAX SMAX=$L(LSTXT)
 . ;     Long Description    78     End
 . S LLTXT=$$TM($E(LINE,78,$L(LINE)))
 . S:LMIN'>0 LMIN=$L(LLTXT) S:$L(LLTXT)<LMIN LMIN=$L(LLTXT)
 . S:LMAX'>0 LMAX=$L(LLTXT) S:$L(LLTXT)>LMAX LMAX=$L(LLTXT)
 ;   Close Host File
 U IO(0) D CLOSE^ZZLEXXBM("PRCHK") W !
 W !," ICD-10-PCS Procedure Data Lengths (SDO lengths/DD lengths)",!
 W !,?4,"Code",?26,+($G(CMIN)),"-",+($G(CMAX)),?40,"1-7"
 W !,?4,"Short Description",?26,+($G(SMIN)),"-",+($G(SMAX)),?40,"1-60"
 W !,?4,"Long Description",?26,+($G(LMIN)),"-",+($G(LMAX)),?40,"1-245"
 Q
TM(X,Y) ;   Trim Character Y - Default " " Space
 S X=$G(X) Q:X="" X  S Y=$G(Y) S:'$L(Y) Y=" "
 F  Q:$E(X,1)'=Y  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=Y  S X=$E(X,1,($L(X)-1))
 Q X
 
