ZZLEXXPE ;SLC/KER - Import - Changes - Report ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^ZZLEXX("ZZLEXXP"   SACC 2.3.2.5.1
 ;               
 ; External References
 ;    $$DT^XLFDT          ICR  10103
 ;    $$FMDIFF^XLFDT      ICR  10103
 ;    $$FMTE^XLFDT        ICR  10103
 ;               
 ; Documented Integration Agreements
 ;               
 ; Local Variables NEWed or KILLed Elsewhere
 ;     LOC,PSUM,REMOTE,TYPE
 ;               
 Q
PD ; Display
 D BL,TL(" Change Details"),TL(" ==============") N SAB,TYPE F SAB="10D","10P","CAT","FRG" F TYPE=1:1:5 D PDST
 Q
PDST ; List by Source and Type
 Q:'$L($G(SAB))  Q:+($G(TYPE))'>0  Q:+($G(TYPE))>5
 N EFF,CT,LN,TOT,EXIT,LIM S (EFF,CT,LN,TOT,EXIT,LIM)=0 S (TOT,EFF)=0
 F  S EFF=$O(^ZZLEXX("ZZLEXXP",$J,SAB,TYPE,EFF)) Q:+EFF'>0  S:EFF'="0" TOT=TOT+($P($G(^ZZLEXX("ZZLEXXP",$J,SAB,TYPE,EFF,0)),"^",1))
 S EFF=0 F  S EFF=$O(^ZZLEXX("ZZLEXXP",$J,SAB,TYPE,EFF)) Q:+EFF'>0  D  Q:+($G(EXIT))>0
 . N PD,PDC,PDTL,PDE,PTTT,PDLN,PDEQ,PDTLE
 . S PD=$G(^ZZLEXX("ZZLEXXP",$J,SAB,TYPE,EFF,0))
 . S PDC=+PD,PDTL=$P(PD,"^",2) Q:+PDC'>0
 . S PDEQ=$G(^ZZLEXX("ZZLEXXP",$J,"TEMP","QTR",EFF,"PTD","FMT"))
 . S PDEQ=$G(^ZZLEXX("ZZLEXXP",$J,"TEMP","QTR",EFF,"QTR","FMT"))
 . S:+($G(TOT))>0 TOT="("_+($G(TOT))_" Code"_$S(+($G(TOT))>1:"s",1:"")_")"
 . S PDTLE="" Q:PDTL'[", Effective "  S PDTLE="       Effective "_$P(PDTL,", Effective ",2),PDTL=$P(PDTL,", Effective ",1)
 . S $P(PDLN,"-",$L(PDTL))="-",PDTL="     "_PDTL,PDLN="     "_PDLN
 . I $G(^ZZLEXX("ZZLEXXP",$J,SAB,TYPE,0))>1 D
 . . N FEFF,LEFF S FEFF=$O(^ZZLEXX("ZZLEXXP",$J,SAB,TYPE,0)),LEFF=$O(^ZZLEXX("ZZLEXXP",$J,SAB,TYPE," "),-1)
 . . I $L(FEFF),$L(LEFF),FEFF'=LEFF S:$G(TOT)["(" PDTL=PDTL_"  "_$G(TOT)
 . . S LN=LN+1 D:LN=1 BL,TL(PDTL),TL(PDLN) D PDSTE
 . I $G(^ZZLEXX("ZZLEXXP",$J,SAB,TYPE,0))'>1 D
 . . S:$G(TOT)["(" PDTLE=PDTLE_$J("",(58-$L(PDTLE)))_$J($G(TOT),12)
 . . S LN=LN+1 D:LN=1 BL,TL(PDTL),TL(PDLN) D PDSTO
 Q
PDSTO ;   By Source, Type (only)
 D BL,TL(PDTLE) D PDSTEC
 Q
PDSTE ;   By Source, Type and Effective Date
 Q:'$L(PD)  N PDC,PDE
 S PDC=+PD Q:+PDC'>0
 S PDE="" S:PD[", Effective " PDE="Effective "_$P(PD,", Effective ",2)
 S:PD[", Effective "&($L($G(PDEQ))) PDE=PDE_" "_PDEQ
 S PDE="       "_PDE
 S:+PDC>0 PDC="("_+PDC_" Code"_$S(+PDC>1:"s",1:"")_")"
 S:PDC["(" PDE=PDE_$J("",(58-$L(PDE)))_$J(PDC,12)
 D BL,TL(PDE)
 D PDSTEC
 Q
PDSTEC ;   By Source, Type, Effective Date and Code
 S SAB=$G(SAB) Q:'$L(SAB)  N SO,LN,LL,LC,CT,COL,LEN,LIM,EXIT S (EXIT,LIM)=0
 S LEN=8 S:"^10D^10P^"[("^"_SAB_"^") LEN=8
 S COL=8 S:"^10D^10P^"[("^"_SAB_"^") COL=7
 S (LC,CT)=0,LN="         ",SO=""
 F  S SO=$O(^ZZLEXX("ZZLEXXP",$J,SAB,TYPE,EFF,SO)) Q:'$L(SO)  D  Q:+($G(EXIT))>0
 . N SOC Q:SO'[" "  S SOC=$E(SO,1,LEN)
 . S LN=LN_SOC S:"^10D^10P^"[("^"_SAB_"^") LN=LN_" "
 . S CT=CT+1 I CT'<COL D TL($$TT(LN)) S LN="         ",CT=0,LC=LC+1
 . S LIM=LIM+1 I +($G(LIMIT))>0,LIM'<+($G(LIMIT)) S EXIT=1
 S LL=$$TM(LN),LN=$$TT(LN) D:$L(LL) TL(LN) N LIMIT
 Q
PT ;     Patch Tracker Summary
 N TAST,TODAY,SAB,LC,ELS,TADD,TINA,TRAC,TREU,TREV,TTOT S TODAY=$$DT^XLFDT,(ELS,LC)=0,(TADD,TINA,TREU,TREV,EFF)=0
 I '$L($G(NQ))!('$L($G(NQD)))!($G(NQD)'?7N) D
 . Q:'$L($P($G(QTR),"^",6))  Q:$P($G(QTR),"^",4)'?7N
 . S NQ=$P($G(QTR),"^",6),NQD=$P($G(QTR),"^",4)
 D BL,TL(" Change Summary"),TL(" =============="),BL D:$D(PSUM) PTSH
 F SAB="10D","10P","CAT","FRG" D PTSR
 D:+($G(ELS))>0 PTT
 I +($G(ELS))'>0 D
 . I '$L($G(LOC))!('$L($G(REMOTE))) D BL,TL("      No changes found") Q
 . D BL,TL(("      No changes found"_", "_LOC_" and "_REMOTE_" are the same")),BL
 I +($G(ELS))>0,$L($G(NQ)) D
 . D:$D(TAST("  * "))!($D(TAST(" ** "))) BL
 . D:$D(TAST("  * ")) TL("                  * Code Set update from a previous quarter")
 . D:$D(TAST(" ** ")) TL("                 ** Projected Code Set update for a future quarter")
 K NQ,NQD N QTR
 Q
PTSH ;     Header Lines
 I '$L($G(NQ)) D
 . D TL("   Code Set                Effective   Added  Inact  React  Re-Use  Rev  Total")
 . D TL("   ----------------------  ----------  -----  -----  -----  ------  ---  -----")
 I $L($G(NQ)) D
 . N NQDE,NQT S NQDE=$TR($$FMTE^XLFDT($G(NQD),"5DZ"),"@"," ") S NQT="   "_NQ
 . S:$L($G(NQDE)) NQT=NQT_" Effective "_NQDE D:$D(ONLY) TL(NQT),BL
 . D TL("   Code Set                  Effective   Added  Inact  React  Re-Use  Rev  Total")
 . D TL("   ----------------------    ----------  -----  -----  -----  ------  ---  -----")
 N ONLY
 Q
PTSR ;       By Source
 Q:'$L($G(SAB))  N EFF
 I $O(^ZZLEXX("ZZLEXXP",$J,"TEMP",SAB,""))'?7N D  Q
 . N SABF,STR
 . S:SAB="10D" SABF="ICD-10-CM Diagnosis    "
 . S:SAB="10P" SABF="ICD-10-PCS Procedures  "
 . S:SAB="CAT" SABF="ICD-10-CM Categories   "
 . S:SAB="FRG" SABF="ICD-10-PCS Fragments   "
 . S:'$L(SABF) SABF="                       "
 . Q:'$L(SABF)
 . S STR="   "_SABF,STR=STR_" No changes     --     --     --     --    --     --" D TL(STR)
 S EFF=0 F  S EFF=$O(^ZZLEXX("ZZLEXXP",$J,"TEMP",SAB,EFF)) Q:+EFF'>0  D PTSE
 Q
PTSE ;       By Source and Effective Date
 Q:'$L($G(SAB))  Q:'$L($G(EFF))  Q:+($G(EFF))'>0  N AST,EFFD,EFF1,EFF2,SABF,SADD,SINA,SREU,SRAC,SREV,STOT,STR,TTL,TL,LL,LS
 S EFFD=$TR($$FMTE^XLFDT(EFF,"5DZ"),"@"," ") Q:'$L(EFFD)  S AST="    "
 S:+($G(EFF))>0&(+($G(NQD))>0)&(+($G(EFF))=+($G(NQD))) AST="    "
 S:+($G(EFF))>0&(+($G(NQD))>0)&(+($G(EFF))>+($G(NQD))) AST=" ** "
 S:+($G(EFF))>0&(+($G(NQD))>0)&(+($G(EFF))<+($G(NQD))) AST="  * "
 S:$L(AST) TAST(AST)="" S EFF1=" "_EFFD,EFF2=$P($G(^ZZLEXX("ZZLEXXP",$J,"TEMP","QTR",+EFF,"PTM","FMT")),"^",1) S:$L(EFF2) EFF1=EFF2
 S:SAB="10D" SABF="ICD-10-CM Diagnosis    "
 S:SAB="10P" SABF="ICD-10-PCS Procedures  "
 S:SAB="CAT" SABF="ICD-10-CM Categories   "
 S:SAB="FRG" SABF="ICD-10-PCS Fragments   "
 S:'$L(SABF) SABF="                       "
 S SADD=$$PTTS(SAB,EFF,1),SINA=$$PTTS(SAB,EFF,2),SREU=$$PTTS(SAB,EFF,3),SREV=$$PTTS(SAB,EFF,4),SRAC=$$PTTS(SAB,EFF,5)
 S STOT=SADD+SINA+SREU+SREV+SRAC S:+SADD>0 TADD=+($G(TADD))+SADD S:+SINA>0 TINA=+($G(TINA))+SINA S:+SRAC>0 TRAC=+($G(TRAC))+SRAC
 S:+SREU>0 TREU=+($G(TREU))+SREU S:+SREV>0 TREV=+($G(TREV))+SREV S:+STOT>0 TTOT=+($G(TTOT))+STOT Q:+STOT'>0
 S:+SADD'>0 SADD="--" S:+SINA'>0 SINA="--" S:+SRAC'>0 SRAC="--" S:+SREU'>0 SREU="--" S:+SREV'>0 SREV="--"
 I '$L($G(NQ)) D
 . S STR="   "_SABF_EFF1 S STR=STR_$J("",(39-$L(STR))) S STR=STR_$J(SADD,5)_$J(SINA,7)_$J(SRAC,7)_$J(SREU,7)_$J(SREV,6)_$J(STOT,7)
 . S LC=+($G(LC))+1 D:LC=1&('$D(PSUM)) PTSH D TL(STR) S ELS=+($G(ELS))+1
 I $L($G(NQ)) D
 . S STR="   "_SABF_AST_EFFD S STR=STR_$J("",(41-$L(STR))) S STR=STR_$J(SADD,5)_$J(SINA,7)_$J(SRAC,7)_$J(SREU,7)_$J(SREV,6)_$J(STOT,7)
 . S LC=+($G(LC))+1 D:LC=1&('$D(PSUM)) PTSH D TL(STR) S ELS=+($G(ELS))+1
 Q
PTT ;     Totals
 D PTST N TTL
 S:+$G(TADD)'>0 TADD="--" S:+$G(TINA)'>0 TINA="--" S:+$G(TRAC)'>0 TRAC="--" S:+$G(TREU)'>0 TREU="--" S:+$G(TREV)'>0 TREV="--" S:+$G(TTOT)'>0 TTOT="--"
 S:$L($G(NQ)) TTL="                                        "_$J($G(TADD),6)_$J($G(TINA),7)_$J($G(TRAC),7)_$J($G(TREU),7)_$J($G(TREV),6)_$J($G(TTOT),7)
 S:'$L($G(NQ)) TTL="                                      "_$J($G(TADD),6)_$J($G(TINA),7)_$J($G(TRAC),7)_$J($G(TREU),7)_$J($G(TREV),6)_$J($G(TTOT),7)
 D TL(TTL)
 I '$L($G(NQ)),$D(^ZZLEXX("ZZLEXXP",$J,"TEMP","QTR","LEGEND")) D
 . D BL N I S I=0 F  S I=$O(^ZZLEXX("ZZLEXXP",$J,"TEMP","QTR","LEGEND",I)) Q:+I'>0  D
 . . N LG,LL S LG=$G(^ZZLEXX("ZZLEXXP",$J,"TEMP","QTR","LEGEND",I)) Q:'$L(LG)  S LL="                      "_LG D TL(LL)
 Q
PTST ;     Total Line
 D:'$L($G(NQ)) TL("                                       -----  -----  -----  ------  ---  -----")
 D:$L($G(NQ)) TL("                                         -----  -----  -----  ------  ---  -----")
 Q
PTTS(S,E,X) ;      Total for SAB/EFF/TYPE
 N TY,SAB,EFF,SO,TOT S TY=+($G(X)) Q:TY'>0 "--"  Q:TY>5 "--"  S SAB=$G(S) Q:'$L(SAB) "--"  S EFF=$G(E) Q:'$L(EFF) "--"  Q:EFF'?7N "--"
 S SO="",TOT=0 F  S SO=$O(^ZZLEXX("ZZLEXXP",$J,SAB,TY,EFF,SO)) Q:SO=""  S:SO'="0" TOT=TOT+1
 S X=TOT S:+X'>0 X="--"
 Q X
 ;                   
 ; Miscellaneous
NQ(X) ; Nearest Quarter
 N TD,FY,FM,FD,FF,PY,PM,PD,PF,ND,NQ,NY,NX S TD=$G(X) S:TD'?7N TD=$$DT^XLFDT S FY=$E(TD,1,3),FM=+($E(TD,4,5))
 S FM=$S(+FM>0&(+FM<4):4,+FM>3&(+FM<7):7,+FM>6&(+FM<10):10,+FM>9&(+FM<13):1,1:"") S:'$L(FM) FM=1 S:FM=1 FY=FY+1 S:$L(FM)<2 FM="0"_FM S FD=FY_FM_"01"
 S PY=$E(TD,1,3),PM=+($E(TD,4,5)) S PM=$S(+PM>0&(PM<4):1,+PM>3&(PM<7):4,+PM>6&(PM<10):7,+PM>9&(PM<13):10,1:"") S:'$L(PM) PM=1 S:$L(PM)<2 PM="0"_PM S PD=PY_PM_"01"
 S FF=$$FMDIFF^XLFDT(FD,TD),PF=$$FMDIFF^XLFDT(TD,PD) S:+PF<+FF ND=PD S:+PF'<+FF ND=FD S NQ=$S($E(ND,4,5)="01":"2nd",$E(ND,4,5)="04":"3rd",$E(ND,4,5)="07":"4th",$E(ND,4,5)="10":"1st",1:"")
 S FY=$E(ND,1,3),NY=+($E((FY+1700),3,4)) S NY=$S(+($E(ND,4,5))>9:(+NY+1),1:NY) S:$L(NY)<2 NY="0"_NY S NX="FY"_NY_" "_NQ_$S(NQ'["q"&(NQ'["Q"):" Qtr",1:"") S X=ND_"^"_NX
 Q X
TT(X) ;   Trailing Spaces
 F  Q:$E(X,$L(X))'=" "  S X=$E(X,1,($L(X)-1))
 Q X
BL ;   Blank Line
 D TL("  ")
 Q
TL(X) ;   Text Line
 N TX,C S TX=$G(X),C=$O(^ZZLEXX("ZZLEXXP",$J,"OUT"," "),-1)+1 S ^ZZLEXX("ZZLEXXP",$J,"OUT",C)=TX
 Q
TM(X) ;   All Spaces
 S X=$G(X) F  Q:$E(X,1)'=" "  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=" "  S X=$E(X,1,($L(X)-1))
 Q X
CLR ;
 Q  K ^ZZLEXX("ZZLEXXP",$J)
 Q
FND(X) ;   Changes Found
 N SPC S SPC=$J(" ",49)
 D:+($G(X))>0 TL((SPC_$J(+($G(X)),7)_" Change"_$S(+TOT>1:"s",1:"")_" found"))
 D:+($G(X))'>0 TL((SPC_$J("--",7)_" No changes found"))
 Q
