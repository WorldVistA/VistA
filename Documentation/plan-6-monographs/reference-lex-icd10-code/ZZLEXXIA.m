ZZLEXXIA ;SLC/KER - Import - ICD-10 Install Status ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^ICD0(              ICR   4486
 ;    ^ICD9(              ICR   4485
 ;    ^LEX(757.033,       SACC 1.3
 ;    ^ZZLEXX("ZZLEXXIA"  SACC 1.3
 ;               
 ; External References
 ;    ^%ZIS               ICR  10086
 ;    HOME^%ZIS           ICR  10086
 ;    ^%ZISC              ICR  10089
 ;    $$DEL^%ZISH         ICR   2320
 ;    CLOSE^%ZISH         ICR   2320
 ;    OPEN^%ZISH          ICR   2320
 ;    $$OS^%ZOSV          ICR   3522
 ;    ^%ZTLOAD            ICR  10063
 ;    $$GET1^DIQ          ICR   2056
 ;    $$DT^XLFDT          ICR  10103
 ;    $$FMTE^XLFDT        ICR  10103
 ;    $$UP^XLFSTR         ICR  10104
 ;               
EN ; Main Entry Point
 W:$L($G(IOF)) @IOF N TOT W !," Getting ICD-10 Status, please wait.",! K ^ZZLEXX("ZZLEXXIA",$J) D ICD,ICP,CAT,FRG,SAV,DSP K POP
 Q
ONE(X) ;
 N ONE,TOT S ONE=$G(X) Q:"^ICD^ICP^CAT^FRG^"'[("^"_ONE_"^")  K TOT D @ONE I $D(TOT) D SAV W ! D DSP K POP
 Q 
ICD ;   ICD-10-CM
 N ACT,DONE,EFF,FY,HIS,IEN,INA,LAST,LTX,NXT,OPEN,ORD,PATH,REV,STA,STX S LAST=""
 S ORD="" F  S ORD=$O(^ICD9("ABA",30,ORD)) Q:'$L(ORD)  D
 . N IEN S IEN=0 F  S IEN=$O(^ICD9("ABA",30,ORD,IEN)) Q:+IEN'>0  D
 . . N EFF,REV,HIS,STA S EFF=$O(^ICD9(IEN,66,"B",9999999),-1),HIS=$O(^ICD9(IEN,66,"B",+EFF," "),-1) S STA=$P($G(^ICD9(IEN,66,+HIS,0)),"^",2)
 . . S:EFF>LAST LAST=EFF S:STA="0"&(+EFF>+($G(INA))) INA=+EFF S:STA="1"&(+EFF>+($G(ACT))) ACT=+EFF
 . . S REV=$O(^ICD9(IEN,67,"B",9999999),-1) S:REV>LAST LAST=REV I STA>0,REV>EFF,REV>$G(STX) S STX=+REV
 . . S REV=$O(^ICD9(IEN,68,"B",9999999),-1) S:REV>LAST LAST=REV I STA>0,REV>EFF,REV>$G(LTX) S LTX=+REV
 S:+($G(INA))>0 TOT("DX","INA")=+($G(INA)),TOT("DX","INA","T")=$$TM(($$FMTE^XLFDT(+($G(INA)),"5Z")_"    "_$$FQ(+($G(INA)))))
 S:+($G(ACT))>0 TOT("DX","ACT")=+($G(ACT)),TOT("DX","ACT","T")=$$TM(($$FMTE^XLFDT(+($G(ACT)),"5Z")_"    "_$$FQ(+($G(ACT)))))
 S:+($G(STX))>0 TOT("DX","STX")=+($G(STX)),TOT("DX","STX","T")=$$TM(($$FMTE^XLFDT(+($G(STX)),"5Z")_"    "_$$FQ(+($G(STX)))))
 S:+($G(LTX))>0 TOT("DX","LTX")=+($G(LTX)),TOT("DX","LTX","T")=$$TM(($$FMTE^XLFDT(+($G(LTX)),"5Z")_"    "_$$FQ(+($G(LTX)))))
 S:+($G(LAST))>0 TOT("DX","LAST")=+($G(LAST))
 S FY=$$TM($TR($$FY(LAST),"FY",""))
 S NXT="icd10cm_order_"_(FY+1)_".txt"
 S PATH=$$PATH,OPEN=$$OPEN(PATH,NXT,"CHK") U IO(0) D CLOSE("CHK")
 I +OPEN>0 S TOT("DX","COM",1)="Install ICD-10-CM Diagnosis terminology from "_NXT
 Q
ICP ;   ICD-10-PCS
 N ACT,EFF,FY,HIS,IEN,INA,LAST,LTX,NXT,OPEN,ORD,PATH,REV,STA,STX S LAST=""
 S ORD="" F  S ORD=$O(^ICD0("ABA",31,ORD)) Q:'$L(ORD)  D
 . N IEN S IEN=0 F  S IEN=$O(^ICD0("ABA",31,ORD,IEN)) Q:+IEN'>0  D
 . . N EFF,REV,HIS,STA S EFF=$O(^ICD0(IEN,66,"B",9999999),-1),HIS=$O(^ICD0(IEN,66,"B",+EFF," "),-1) S STA=$P($G(^ICD0(IEN,66,+HIS,0)),"^",2)
 . . S:EFF>LAST LAST=EFF S:STA="0"&(+EFF>+($G(INA))) INA=+EFF S:STA="1"&(+EFF>+($G(ACT))) ACT=+EFF
 . . S REV=$O(^ICD0(IEN,67,"B",9999999),-1) S:REV>LAST LAST=REV I STA>0,REV>EFF,REV>$G(STX) S STX=+REV
 . . S REV=$O(^ICD0(IEN,68,"B",9999999),-1) S:REV>LAST LAST=REV I STA>0,REV>EFF,REV>$G(LTX) S LTX=+REV
 S:+($G(INA))>0 TOT("PR","INA")=+($G(INA)),TOT("PR","INA","T")=$$TM(($$FMTE^XLFDT(+($G(INA)),"5Z")_"    "_$$FQ(+($G(INA)))))
 S:+($G(ACT))>0 TOT("PR","ACT")=+($G(ACT)),TOT("PR","ACT","T")=$$TM(($$FMTE^XLFDT(+($G(ACT)),"5Z")_"    "_$$FQ(+($G(ACT)))))
 S:+($G(STX))>0 TOT("PR","STX")=+($G(STX)),TOT("PR","STX","T")=$$TM(($$FMTE^XLFDT(+($G(STX)),"5Z")_"    "_$$FQ(+($G(STX)))))
 S:+($G(LTX))>0 TOT("PR","LTX")=+($G(LTX)),TOT("PR","LTX","T")=$$TM(($$FMTE^XLFDT(+($G(LTX)),"5Z")_"    "_$$FQ(+($G(LTX)))))
 S:+($G(LAST))>0 TOT("PR","LAST")=+($G(LAST))
 S FY=$$TM($TR($$FY(LAST),"FY",""))
 S NXT="icd10pcs_order_"_(FY+1)_".txt"
 S PATH=$$PATH,OPEN=$$OPEN(PATH,NXT,"CHK") U IO(0) D CLOSE("CHK")
 I +OPEN>0 S TOT("PR","COM",1)="Install ICD-10-PCS Procedure terminology from "_NXT
 I +OPEN'>0 D
 . S NXT="order_"_(FY+1)_".txt"
 . S PATH=$$PATH,OPEN=$$OPEN(PATH,NXT,"CHK") U IO(0) D CLOSE("CHK")
 . I +OPEN>0 S TOT("PR","COM",1)="Install ICD-10-PCS Procedure terminology from "_NXT
 Q
CAT ;   ICD-10-CM Categories
 N ACT,EFF,FY,HIS,IEN,INA,LAST,LTX,NXT,OPEN,ORD,PATH,REV,STA,STX S LAST=""
 S ORD="10D" F  S ORD=$O(^LEX(757.033,"B",ORD)) Q:'$L(ORD)!($E(ORD,1,3)'="10D")  D
 . N IEN S IEN=0 F  S IEN=$O(^LEX(757.033,"B",ORD,IEN)) Q:+IEN'>0  D
 . . N EFF,REV,HIS,STA S EFF=$O(^LEX(757.033,IEN,1,"B",9999999),-1),HIS=$O(^LEX(757.033,IEN,1,"B",+EFF," "),-1) S STA=$P($G(^LEX(757.033,IEN,1,+HIS,0)),"^",2)
 . . S:EFF>LAST LAST=EFF S:STA="0"&(+EFF>+($G(INA))) INA=+EFF S:STA="1"&(+EFF>+($G(ACT))) ACT=+EFF
 . . S REV=$O(^LEX(757.033,IEN,2,"B",9999999),-1) S:REV>LAST LAST=REV I STA>0,REV>EFF,REV>$G(STX) S STX=+REV
 . . S REV=$O(^LEX(757.033,IEN,3,"B",9999999),-1) S:REV>LAST LAST=REV I STA>0,REV>EFF,REV>$G(LTX) S LTX=+REV
 S:+($G(INA))>0 TOT("CT","INA")=+($G(INA)),TOT("CT","INA","T")=$$TM(($$FMTE^XLFDT(+($G(INA)),"5Z")_"    "_$$FQ(+($G(INA)))))
 S:+($G(ACT))>0 TOT("CT","ACT")=+($G(ACT)),TOT("CT","ACT","T")=$$TM(($$FMTE^XLFDT(+($G(ACT)),"5Z")_"    "_$$FQ(+($G(ACT)))))
 S:+($G(STX))>0 TOT("CT","STX")=+($G(STX)),TOT("CT","STX","T")=$$TM(($$FMTE^XLFDT(+($G(STX)),"5Z")_"    "_$$FQ(+($G(STX)))))
 S:+($G(LTX))>0 TOT("CT","LTX")=+($G(LTX)),TOT("CT","LTX","T")=$$TM(($$FMTE^XLFDT(+($G(LTX)),"5Z")_"    "_$$FQ(+($G(LTX)))))
 S:+($G(LAST))>0 TOT("CT","LAST")=+($G(LAST))
 S FY=$$TM($TR($$FY(LAST),"FY",""))
 S NXT="icd10cm_order_"_(FY+1)_".txt"
 S PATH=$$PATH,OPEN=$$OPEN(PATH,NXT,"CHK") U IO(0) D CLOSE("CHK")
 I +OPEN>0 S TOT("CT","COM",1)="Install diagnostic categories from "_NXT
 Q
FRG ;   ICD-10-PCS Code Fragments
 N ACT,DEF,EFF,FY,HIS,IEN,INA,INC,LAST,LDEF,LTAB,LTX,NXT,OPEN,ORD,PATH,REV,STA,STX S (LAST,LTAB,LDEF)=""
 S ORD="10P" F  S ORD=$O(^LEX(757.033,"B",ORD)) Q:'$L(ORD)!($E(ORD,1,3)'="10P")  D
 . N IEN S IEN=0 F  S IEN=$O(^LEX(757.033,"B",ORD,IEN)) Q:+IEN'>0  D
 . . N EFF,REV,HIS,STA S EFF=$O(^LEX(757.033,IEN,1,"B",9999999),-1),HIS=$O(^LEX(757.033,IEN,1,"B",+EFF," "),-1) S STA=$P($G(^LEX(757.033,IEN,1,+HIS,0)),"^",2)
 . . S:EFF>LTAB LTAB=EFF S:STA="0"&(+EFF>+($G(INA))) INA=+EFF S:STA="1"&(+EFF>+($G(ACT))) ACT=+EFF
 . . S REV=$O(^LEX(757.033,IEN,2,"B",9999999),-1) S:REV>LTAB LTAB=REV I STA>0,REV>EFF,REV>$G(STX) S STX=+REV
 . . S REV=$O(^LEX(757.033,IEN,3,"B",9999999),-1) S:REV>LDEF LDEF=REV I STA>0,REV>EFF,REV>$G(LTX) S LTX=+REV
 . . S REV=$O(^LEX(757.033,IEN,4,"B",9999999),-1) S:REV>LDEF LDEF=REV I STA>0,REV>EFF,REV>$G(DEF) S DEF=+REV
 . . S REV=$O(^LEX(757.033,IEN,5,"B",9999999),-1) S:REV>LDEF LDEF=REV I STA>0,REV>EFF,REV>$G(INC) S INC=+REV
 S:+($G(INA))>0 TOT("FG","INA")=+($G(INA)),TOT("FG","INA","T")=$$TM(($$FMTE^XLFDT(+($G(INA)),"5Z")_"    "_$$FQ(+($G(INA)))))
 S:+($G(ACT))>0 TOT("FG","ACT")=+($G(ACT)),TOT("FG","ACT","T")=$$TM(($$FMTE^XLFDT(+($G(ACT)),"5Z")_"    "_$$FQ(+($G(ACT)))))
 S:+($G(STX))>0 TOT("FG","STX")=+($G(STX)),TOT("FG","STX","T")=$$TM(($$FMTE^XLFDT(+($G(STX)),"5Z")_"    "_$$FQ(+($G(STX)))))
 S:+($G(LTX))>0 TOT("FG","LTX")=+($G(LTX)),TOT("FG","LTX","T")=$$TM(($$FMTE^XLFDT(+($G(LTX)),"5Z")_"    "_$$FQ(+($G(LTX)))))
 S:+($G(DEF))>0 TOT("FG","DEF")=+($G(LTX)),TOT("FG","DEF","T")=$$TM(($$FMTE^XLFDT(+($G(LTX)),"5Z")_"    "_$$FQ(+($G(LTX)))))
 S:+($G(INC))>0 TOT("FG","INC")=+($G(LTX)),TOT("FG","INC","T")=$$TM(($$FMTE^XLFDT(+($G(LTX)),"5Z")_"    "_$$FQ(+($G(LTX)))))
 S:+($G(LAST))>0 TOT("FG","LAST")=+($G(LAST))
 S FY=$$TM($TR($$FY(LTAB),"FY",""))
 S NXT="icd10pcs_tables_"_(FY+1)_".txt"
 S PATH=$$PATH,OPEN=$$OPEN(PATH,NXT,"CHK") U IO(0) D CLOSE("CHK")
 I +OPEN>0 S TOT("FG","COM",1)="Install procedure code fragments from "_NXT
 I +OPEN'>0 D
 . S NXT="icd10pcs_tabular_"_(FY+1)_".txt"
 . S PATH=$$PATH,OPEN=$$OPEN(PATH,NXT,"CHK") U IO(0) D CLOSE("CHK")
 . I +OPEN>0 S TOT("FG","COM",1)="Install procedure code fragments from "_NXT
 S FY=$$TM($TR($$FY(LDEF),"FY",""))
 S NXT="icd10pcs_definitions_"_(FY+1)_".txt"
 S PATH=$$PATH,OPEN=$$OPEN(PATH,NXT,"CHK") U IO(0) D CLOSE("CHK")
 I +OPEN>0 S TOT("FG","COM",2)="Install procedure definitions from "_NXT
 Q
SAV ;   Save
 N TX,VAL K ^ZZLEXX("ZZLEXXIA",$J)
 I '$D(ONE)!($G(ONE)="ICD") D
 . S TX=" "_"ICD-10-CM Diagnosis" D TL(TX),BL
 . S VAL=$G(TOT("DX","ACT","T")) S:'$L(VAL) VAL="None" S TX="     "_"Last Activation",TX=TX_$J(" ",(45-$L(TX)))_VAL D TL(TX)
 . S VAL=$G(TOT("DX","INA","T")) S:'$L(VAL) VAL="None" S TX="     "_"Last Inactivation",TX=TX_$J(" ",(45-$L(TX)))_VAL D TL(TX)
 . S VAL=$G(TOT("DX","STX","T")) S:'$L(VAL) VAL="None" S TX="     "_"Last Name Revision",TX=TX_$J(" ",(45-$L(TX)))_VAL D TL(TX)
 . S VAL=$G(TOT("DX","LTX","T")) S:'$L(VAL) VAL="None" S TX="     "_"Last Description Revision",TX=TX_$J(" ",(45-$L(TX)))_VAL D TL(TX),BL
 . I $L($G(TOT("DX","COM",1))) S TX="     "_$G(TOT("DX","COM",1)) D TL(TX),BL
 I '$D(ONE)!($G(ONE)="ICP") D
 . S TX=" "_"ICD-10-PCS Procedures" D TL(TX),BL
 . S VAL=$G(TOT("PR","ACT","T")) S:'$L(VAL) VAL="None" S TX="     "_"Last Activation",TX=TX_$J(" ",(45-$L(TX)))_VAL D TL(TX)
 . S VAL=$G(TOT("PR","INA","T")) S:'$L(VAL) VAL="None" S TX="     "_"Last Inactivation",TX=TX_$J(" ",(45-$L(TX)))_VAL D TL(TX)
 . S VAL=$G(TOT("PR","STX","T")) S:'$L(VAL) VAL="None" S TX="     "_"Last Name Revision",TX=TX_$J(" ",(45-$L(TX)))_VAL D TL(TX)
 . S VAL=$G(TOT("PR","LTX","T")) S:'$L(VAL) VAL="None" S TX="     "_"Last Description Revision",TX=TX_$J(" ",(45-$L(TX)))_VAL D TL(TX),BL
 . I $L($G(TOT("PR","COM",1))) S TX="     "_$G(TOT("PR","COM",1)) D TL(TX),BL
 I '$D(ONE)!($G(ONE)="CAT") D
 . S TX=" "_"ICD-10-CM Diagnosis Categories" D TL(TX),BL
 . S VAL=$G(TOT("CT","ACT","T")) S:'$L(VAL) VAL="None" S TX="     "_"Last Activation",TX=TX_$J(" ",(45-$L(TX)))_VAL D TL(TX)
 . S VAL=$G(TOT("CT","INA","T")) S:'$L(VAL) VAL="None" S TX="     "_"Last Inactivation",TX=TX_$J(" ",(45-$L(TX)))_VAL D TL(TX)
 . S VAL=$G(TOT("CT","STX","T")) S:'$L(VAL) VAL="None" S TX="     "_"Last Name Revision",TX=TX_$J(" ",(45-$L(TX)))_VAL D TL(TX)
 . S VAL=$G(TOT("CT","LTX","T")) S:'$L(VAL) VAL="None" S TX="     "_"Last Description Revision",TX=TX_$J(" ",(45-$L(TX)))_VAL D TL(TX),BL
 . I $L($G(TOT("CT","COM",1))) S TX="     "_$G(TOT("CT","COM",1)) D TL(TX),BL
 I '$D(ONE)!($G(ONE)="FRG") D
 . S TX=" "_"ICD-10-PCS Procedure Code Fragments" D TL(TX),BL
 . S VAL=$G(TOT("FG","ACT","T")) S:'$L(VAL) VAL="None" S TX="     "_"Last Activation",TX=TX_$J(" ",(45-$L(TX)))_VAL D TL(TX)
 . S VAL=$G(TOT("FG","INA","T")) S:'$L(VAL) VAL="None" S TX="     "_"Last Inactivation",TX=TX_$J(" ",(45-$L(TX)))_VAL D TL(TX)
 . S VAL=$G(TOT("FG","STX","T")) S:'$L(VAL) VAL="None" S TX="     "_"Last Name Revision",TX=TX_$J(" ",(45-$L(TX)))_VAL D TL(TX)
 . S VAL=$G(TOT("FG","LTX","T")) S:'$L(VAL) VAL="None" S TX="     "_"Last Description Revision",TX=TX_$J(" ",(45-$L(TX)))_VAL D TL(TX)
 . S VAL=$G(TOT("FG","DEF","T")) S:'$L(VAL) VAL="None" S TX="     "_"Last Definition/Explanation Revision",TX=TX_$J(" ",(45-$L(TX)))_VAL D TL(TX)
 . S VAL=$G(TOT("FG","INC","T")) S:'$L(VAL) VAL="None" S TX="     "_"Last Includes/Synonym Revision",TX=TX_$J(" ",(45-$L(TX)))_VAL D TL(TX),BL
 . I $L($G(TOT("FG","COM",1))) S TX="     "_$G(TOT("FG","COM",1)) D TL(TX)
 . I $L($G(TOT("FG","COM",2))) S TX="     "_$G(TOT("FG","COM",2)) D TL(TX)
 . D:$L($G(TOT("FG","COM",1)))!($L($G(TOT("FG","COM",2)))) BL
 Q
 ;
DSP ; Display ^ZZLEXX("ZZLEXXIAT",$J)
 N %,%ZIS,IOP,ZTRTN,ZTSAVE,ZTDESC,ZTDTH,ZTIO,ZTSK,ZTQUEUED,ZTREQ
 S ZTRTN="DSPI^ZZLEXXIA",ZTDESC="Display/Print Help" I $D(ONE) D @ZTRTN Q
 S ZTIO=ION,ZTDTH=$H,%ZIS="PQ",ZTSAVE("^ZZLEXX(""ZZLEXIA"",$J,")=""
 S %ZIS("A")="   Device:  " W !," Display ICD-10 Status",! D ^%ZIS
 K %ZIS Q:POP  S ZTIO=ION I $D(IO("Q")) D QUE,^%ZISC Q
 D NOQUE
 Q
NOQUE ;   Do not que task
 W @IOF W:IOST["P-" !,"< Not queued, printing Help >",! U:IOST["P-" IO D @ZTRTN,^%ZISC
 Q
QUE ;   Task queued 
 K IO("Q") D ^%ZTLOAD W !,$S($D(ZTSK):"Request Queued",1:"Request Cancelled"),! H 2 Q
 Q
DSPI ;   Display Code Lookup
 W:$L($G(IOF)) @IOF I '$D(ZTQUEUED),$G(IOST)'["P-" I '$D(^ZZLEXX("ZZLEXXIA",$J)) W !,"Text not Found"
 U:IOST["P-" IO G:'$D(^ZZLEXX("ZZLEXXIA",$J)) DSPQ N CONT,LEXI,LC,EOP,CT S CT=0
 S CONT="",(LC,LEXI)=0,EOP=+($G(IOSL)) S:EOP=0 EOP=24
 F  S LEXI=$O(^ZZLEXX("ZZLEXXIA",$J,LEXI)) Q:+LEXI=0!(CONT["^")  D
 . W !,^ZZLEXX("ZZLEXXIA",$J,LEXI) S CT=0 D LF Q:CONT["^"
 S:$D(ZTQUEUED) ZTREQ="@" D:'CT CONT K ^ZZLEXX("ZZLEXXIA",$J) W:$G(IOST)["P-" @IOF
DSPQ ;   Quit Display
 Q
LF ;   Line Feed
 S LC=LC+1 D:IOST["P-"&(LC>(EOP-7)) CONT D:IOST'["P-"&(LC>(EOP-4)) CONT
 Q
CONT ;   Page/Form Feed
 S CT=1 S LC=0 W:IOST["P-" @IOF Q:IOST["P-"
 W !!,"  Press <Return> to continue  " R CONT:300 W:$L($G(IOF)) @IOF S:'$T CONT="^"
 S:CONT["^" CONT="^" S:CONT'["^" CONT=""
 Q
 ; 
 ; Host File
PATH(X,Y) ;   Path
 N UCI,SYS,PAT,PATH S UCI=$G(X) S:'$L(UCI) UCI=$$LOC S SYS=$G(Y)
 S:'$L(SYS) SYS=$$SYS S SYS=$E(SYS,1)
 S SYS=$$UP^XLFSTR(SYS),(PAT,UCI)=$$UP^XLFSTR(UCI) Q:'$L(UCI) ""  Q:'$L(SYS) ""  Q:"^U^V^"'[("^"_SYS_"^") ""
 S PATH="USER$:["_UCI_"]" S:SYS'="V" PATH="/home/sftp/patches/" S:UCI="DEVCUR"&(PATH["[") PATH="VA5$:[BETA]"
 S X=PATH
 Q X
PIT(X)  ;   Path - Input Transform
 N TP,TF,TFS,OUT,FILE,PATH,IOP S TP=$G(X),TF="ZZLEXXIA"_+($G(DUZ))_".DAT",TFS=TP_TF
 D HOME^%ZIS S IOP="HFS",%ZIS("HFSNAME")=TFS,%ZIS("HFSMODE")="W",%ZIS="0" D ^%ZIS S OUT=POP
 I OUT U:$L($G(IO(0))) IO(0) D ^%ZISC,HOME^%ZIS Q 0
 U IO W ! U:$L($G(IO(0))) IO(0) D ^%ZISC,HOME^%ZIS K FAR
 S PATH="" S:TP["]" PATH=$P(TP,"]",1)_"]",FILE=$P(TP,"]",2)
 S:TP["/" PATH=$P(TP,"/",1,($L(TP,"/")-1))_"/",FILE=$P(TP,"/",$L(TP,"/"))
 S FAR(TF)="",Y=$$DEL^%ZISH(TP,$NA(FAR)),X=1_"^"_Y K FAR
 D ^%ZISC,HOME^%ZIS K %ZIS
 Q X
OPEN(X,Y,Z) ;   Open Device
 N HFOK,HFP,HFN,HFH S HFP=$G(X)
 Q:'$L($G(HFP)) "0^Missing Host file Path"
 S HFN=$G(Y) Q:'$L($G(HFN)) "0^Missing Host file Name"
 S HFH=$$LR_$G(Z)
 D OPEN^%ZISH(HFH,HFP,HFN,"R")
 S HFOK=$G(POP) I HFOK D CLOSE Q ("0^Error opening"_HFN)
 I IO'[HFN D CLOSE Q ("0^Error opening Host file "_HFN)
 Q 1
CLOSE(X) ;   Close Device
 N HFH S HFH=$$LR_$G(X) D CLOSE^%ZISH(HFH)
 Q
 ; 
 ; Miscellaneous
BL ;   Blank Line
 D TL("  ")
 Q
TL(X) ;   Text Line
 N TX,LN S TX=$G(X) S LN=$O(^ZZLEXX("ZZLEXXIA",$J," "),-1)+1,^ZZLEXX("ZZLEXXIA",$J,+LN)=TX
 Q
FQ(X) ;   Fiscal Year and Quarter
 N FQ,FY,QT S FQ="",FY=$$FY($G(X)),QT=$$QT($G(X)) S:$L(FY)=6 FY=$E(FY,1,2)_$E(FY,5,6) S:$L(FY) FQ=FY S:$L(QT) FQ=FQ_" "_QT_" Qtr"
 S X=$$TM(FQ)
 Q X
FY(X) ;   Fiscal Year
 N INP,YR,MO,FY S INP=$G(X) Q:INP'?7N ""  S YR=+($E(INP,1,3))+1700,MO=+($E(INP,4,5)) Q:+YR'>0 ""  Q:+MO'>0 ""
 S FY="" S:"^1^2^3^4^5^6^7^8^9^"[("^"_+MO_"^") FY="FY"_YR S:"^10^11^12^"[("^"_+MO_"^") FY="FY"_(YR+1)
 S X=$$TM(FY)
 Q X
QT(X) ;   Quarter
 N INP,MO,QT S INP=$G(X) Q:INP'?7N ""  S MO=+($E(INP,4,5)) Q:+MO'>0 ""
 S QT="" S:"^10^11^12^"[("^"_+MO_"^") QT="1st" S:"^1^2^3^"[("^"_+MO_"^") QT="2nd"
 S:"^4^5^6^"[("^"_+MO_"^") QT="3rd" S:"^7^8^9^"[("^"_+MO_"^") QT="4th"
 S X=$$TM(QT)
 Q X
TM(X,Y) ;   Trim Character Y - Default " " Space
 S X=$G(X) Q:X="" X  S Y=$G(Y) S:'$L(Y) Y=" "
 F  Q:$E(X,1)'=Y  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=Y  S X=$E(X,1,($L(X)-1))
 Q X
SYS(X) ;   System
 S X="U" S:$$OS^%ZOSV'["UNIX" X="V"
 Q X
LOC(X) ;   Local Namespace
 X "S X=$ZNSPACE" Q X
LR(X) ;   Local Routine
 S X=$T(+1),X=$P(X," ",1) Q X
ENV(X) ;   Environment
 D HOME^%ZIS S U="^",DT=$$DT^XLFDT,DTIME=300 K POP
 N NM S NM=$$GET1^DIQ(200,(DUZ_","),.01)
 I '$L(NM) W !!,?5,"Invalid/Missing DUZ" Q 0
 S:$G(DUZ(0))'["@" DUZ(0)=$G(DUZ(0))_"@"
 N ALL,DA,DIK,EDIT,FULL,TEXT,TOT
 Q 1
