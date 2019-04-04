ZZLEXXCE ;SLC/KER - Import - Conflicts - Sex ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
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
SEX ; Sex
 N %,%D,A,ACT,AFT,AT,B,BEF,C,CODE,COL,CSEX,CT,CX,DA,DIERR,EFF,ERR,EXC,FDA,FDAI,FI,FILE,FND,HDR,HIS,I,IEN,IENS,ISEX,KEY,LC,LEFF,LINE
 N ND,OPEN,ORD,PATH,RAN,RT,S1,S2,S3,S4,SS,SEC,SEG,START,STOP,SAV,SEX,SF,SIEN,STA,SX,SY,TCX,TERM,TIEN,TOT,TSEX,TSX,TY,TYPE,X,Y,Z
 Q:'$L($G(HFNAME))  S ERR=0,PATH=$$PATH^ZZLEXXCM,TOT=0 S OPEN=$$OPEN^ZZLEXXCM(PATH,HFNAME,"CHK") I +OPEN'>0 D  Q
 . W:$L($P($G(OPEN),"^",2)) !!,?4,$L($P($G(OPEN),"^",2)) K COMMIT S ABRT=1
 S S1="DIAGNOSES FOR FEMALES ONLY",S2="PROCEDURES FOR FEMALES ONLY",S3="DIAGNOSES FOR MALES ONLY",S4="PROCEDURES FOR MALES ONLY"
 S SEG=0,STOP="MANIFESTATION CODE AS PRINCIPAL DIAGNOSIS",LEFF=$G(^ZZLEXX("ZZLEXXC",$J,"EFF")) Q:$G(LEFF)'?7N
 S (TYPE,SEX)="",EXIT=0 F  D  Q:EXIT>0  S EXIT=$$EOF^ZZLEXXCM Q:EXIT>0  Q:SEG>0
 . N EXC,FI,LINE,ULINE,SY,KEY,CODE,TIEN,TERM S EXC="U IO R LINE S ULINE=$$TM($$UP^XLFSTR(LINE)) U IO(0)" X EXC U IO(0)
 . S LINE=$TR(LINE,$C(9)," ") Q:'$L($$TM(LINE))
 . I ULINE=S1 D
 . . S TYPE="D",SEX="F",SS=S1
 . . N CT,TOT,EXIT,SS,TAB S EXIT=0,TAB=$C(9),SS=S1,SEC=1
 . . F  U IO D  Q:EXIT>0  S EXIT=$$EOF^ZZLEXXCM Q:EXIT>0  Q:SEG>0
 . . . N EXC,LINE,ULINE,FI,SY,RT S EXC="U IO R LINE S ULINE=$$UP^XLFSTR($G(LINE)) U IO(0)" X EXC U IO(0)
 . . . S CODE=$$TM($P(ULINE,TAB,1)),TERM=$$TM($TR($P(LINE,TAB,2),"""",""))
 . . . I $G(ULINE)[S2 S TYPE="P",SEX="F",SS=S2,SEC=SEC+1 Q
 . . . I $G(ULINE)[S3 S TYPE="D",SEX="M",SS=S3,SEC=SEC+1 Q
 . . . I $G(ULINE)[S4 S TYPE="P",SEX="M",SS=S4,SEC=SEC+1 Q
 . . . Q:"^D^P^"'[("^"_$G(TYPE)_"^")  Q:"^M^F^"'[("^"_SEX_"^")  Q:CODE["*"
 . . . S:'$L($G(ULINE))&(SEC=4) SEG=1 S:$G(ULINE)[STOP SEG=1 Q:SEG>0  Q:LINE'[TAB  Q:'$L(CODE)&($L($$TM(LINE)))
 . . . S:TYPE="D" CODE=$$DXC(CODE)
 . . . I $L(ULINE),TYPE="D" I $E(CODE,1)'?1U!($E(CODE,2)'?1N)!($E(CODE,3)'?1NU)!($E(CODE,4)'=".")!($L(CODE)'>3)!($L(CODE)>8) D  Q
 . . . . N TX S TX=">>>>> Error:  Invalid Diagnosis Code Format - "_$G(CODE) D ER(TX,TERM)
 . . . I $L(ULINE),TYPE="P",$L(CODE)'=7 D  Q
 . . . . N TX S TX=">>>>> Error:  Invalid Procedure Code Format - "_$G(CODE) D ER(TX,TERM)
 . . . S FI=$S(TYPE="D":80,1:80.1) S SY=$S(TYPE="D":30,1:31) S RT=$S(TYPE="D":"^ICD9(",1:"^ICD0(")
 . . . S IEN=$$CODEABA^ICDEX(CODE,FI,SY)
 . . . I +($G(IEN))'>0!('$D(@(RT_+($G(IEN))_",0)"))) D  Q
 . . . . N TX S:FI=80 TX=">>>>> Error:  Diagnostic code not found in file "_FI_" - "_$G(CODE)
 . . . . S:FI=80.1 TX=">>>>> Error:  Procedure code not found in file "_FI_" - "_$G(CODE)
 . . . . D ER(TX,TERM)
 . . . S:'$D(RAN(SS,"BEG")) RAN(SS,"BEG")=CODE S RAN(SS,"END")=CODE
 . . . S ^ZZLEXX("ZZLEXXC",$J,"SEX",TYPE,(CODE_" "))=SEX
 U IO(0) D CLOSE^ZZLEXXCM("CHK") I +ERR>0 D  Q
 . W !!," Fix Sex errors in data host file then retry",! K COMMIT S ABRT=1
 . S ERRTOT=+($G(ERRTOT))+ERR
 I '$D(^ZZLEXX("ZZLEXXC",$J,"SEX")) D  Q
 . W !!," 'Sex Conflicts' not loaded",! K COMMIT S ABRT=1
 I '$D(^ZZLEXX("ZZLEXXC",$J,"EFF")) D  Q
 . W !!," Effective date not found, re-check the host file and retry",! S ABRT=1 K COMMIT S ABRT=1
 N FI,TOT F FI=80,80.1 D
 . K:$D(TEST) COMMIT N ORD,CT,RT,SY,TY,LC,SF,LEFF
 . S RT=$S(+($G(FI))=80:"^ICD9(",1:"^ICD0(")
 . S SY=$S(+($G(FI))=80:30,1:31)
 . S TY=$S(+($G(FI))=80:"D",1:"P")
 . S LC=$S(+($G(FI))=80:5,1:3)
 . S SF=$S(+($G(FI))=80:"80.04D",1:"80.11D")
 . S LEFF=$G(^ZZLEXX("ZZLEXXC",$J,"EFF")) Q:LEFF'?7N
 . S CT=0,ORD="" F  S ORD=$O(@(RT_"""ABA"","_SY_","""_ORD_""")")) Q:'$L(ORD)  D
 . . N IEN S IEN=0 F  S IEN=$O(@(RT_"""ABA"","_SY_","""_ORD_""","_IEN_")")) Q:+IEN'>0  D
 . . . N CODE,TERM,EFF,HIS,STA,CSEX,TSEX,SEX,ISEX
 . . . S CODE=$P($G(@(RT_IEN_",0)")),"^",1) Q:'$L(CODE)
 . . . S EFF=$O(@(RT_+IEN_",66,""B"",9999999)"),-1) Q:+EFF'?7N
 . . . S HIS=$O(@(RT_+IEN_",66,""B"","_+EFF_","" "")"),-1) Q:+HIS'>0
 . . . S STA=$P($G(@(RT_+IEN_",66,"_+HIS_",0)")),"^",2) Q:+STA'>0
 . . . S EFF=$O(@(RT_+IEN_",68,""B"",9999999)"),-1) Q:+EFF'?7N
 . . . S HIS=$O(@(RT_+IEN_",68,""B"","_+EFF_","" "")"),-1) Q:+HIS'>0
 . . . S TERM=$G(@(RT_+IEN_",68,"_+HIS_",1)")) Q:'$L(TERM)
 . . . S EFF=$O(@(RT_+IEN_","_LC_",""B"",9999999)"),-1)
 . . . S HIS=$O(@(RT_+IEN_","_LC_",""B"","_+EFF_","" "")"),-1)
 . . . S (TSEX,CSEX)=$P($G(@(RT_+IEN_","_LC_","_+HIS_",0)")),"^",2) S:'$L(TSEX) TSEX="N"
 . . . S (ISEX,SEX)=$G(^ZZLEXX("ZZLEXXC",$J,"SEX",TY,(CODE_" "))) S:'$L(ISEX) ISEX="N"
 . . . I '$L(CSEX),SEX="",ISEX="N" Q
 . . . I $L(CSEX),CSEX=SEX,CSEX=ISEX Q
 . . . I $L(CSEX),CSEX="N",SEX="",ISEX="N" Q
 . . . I "^F^M^"[("^"_CSEX_"^"),'$L(SEX),ISEX="N" D
 . . . . D SEXW^ZZLEXXCF(CSEX,SEX,IEN,CODE,TERM)
 . . . . Q:"^D^P^"'[("^"_$G(TY)_"^")  Q:'$L($G(RT))  Q:"^5^3^"'[("^"_$G(LC)_"^")
 . . . . Q:'$L($G(SF))  Q:"^80.04D^80.11D^"'[("^"_$G(SF)_"^")  Q:'$L(TSEX)  N SIEN,SAV
 . . . . S SIEN=$O(@(RT_+IEN_","_LC_",""B"","_+LEFF_","" "")"),-1)
 . . . . Q:$G(@(RT_+IEN_","_LC_","_+SIEN_",0)"))=(LEFF_"^N")
 . . . . S SAV=$$SEXU^ZZLEXXCF(+($G(FI)),+($G(IEN)),$G(ISEX),LEFF)
 . . . . D:'$D(COMMIT)!($D(COMMIT)&(+SAV>0)) SEXT^ZZLEXXCF(TY,CSEX,"D")
 . . . I "^F^M^N^^"[("^"_CSEX_"^"),$L(ISEX),CSEX'=ISEX D
 . . . . Q:CSEX=""&(ISEX="N")  Q:"^F^M^"[("^"_CSEX_"^")&(ISEX="N")
 . . . . D SEXW^ZZLEXXCF(CSEX,SEX,IEN,CODE,TERM)
 . . . . Q:"^D^P^"'[("^"_$G(TY)_"^")  Q:'$L($G(RT))  Q:"^5^3^"'[("^"_$G(LC)_"^")
 . . . . Q:'$L($G(SF))  Q:"^80.04D^80.11D^"'[("^"_$G(SF)_"^")  Q:'$L(ISEX)  N SIEN,SAV
 . . . . S SIEN=$O(@(RT_+IEN_","_LC_",""B"","_+LEFF_","" "")"),-1)
 . . . . Q:$G(@(RT_+IEN_","_LC_","_+SIEN_",0)"))=(LEFF_"^"_ISEX)
 . . . . S SAV=$$SEXU^ZZLEXXCF(+($G(FI)),+($G(IEN)),$G(ISEX),LEFF)
 . . . . D:'$D(COMMIT)!($D(COMMIT)&(+SAV>0)) SEXT^ZZLEXXCF(TY,ISEX,"A")
 S:+($G(TOT))>0 WASCOM("SEX")="" D SEXTOT^ZZLEXXCF
 I $D(RANGE) W !! ZW RAN
 Q
 ; 
 ; Miscellaneous
DXC(X) ;   Diagnosis Code Format
 N CODE S CODE=$$TM($G(X)) Q:'$L(CODE) ""  S CODE=$TR(CODE,".","") S CODE=$E(CODE,1,3)_"."_$E(CODE,4,$L(CODE)),X=CODE
 Q X
ER(X,Y) ;   Write Error
 N ER,TM,I S ER=$$TM($G(X)),TM(1)=$$TM($G(Y)) W:+($G(ERR))'>0 !," Sex Conflict errors:",!
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
