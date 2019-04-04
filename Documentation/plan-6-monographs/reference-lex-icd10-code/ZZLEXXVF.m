ZZLEXXVF ;SLC/KER - Import - FileMan Verify (DIVR) ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^%ZIS("C"           None
 ;    ^DD(                None
 ;    ^DD("IX"            None
 ;    ^DD("KEY"           None
 ;    ^DIBT(              None
 ;    ^ZZLEXX("ZZLEXXV"   SACC 1.3
 ;    ^UTILITY("DIVR"     None
 ;    ^UTILITY("DIVRIX"   None
 ;               
 ; External References
 ;    ^%ZISC              ICR  10089
 ;               
 ; Local Variables NEWed or KILLed Elsewhere
 ;     %,DI,DIU,FDERR,FLERR,LEXRES,LEXTEST,LEXXX,TOTERR,ZTQUEUED
 ;     ZTREQ
 ;               
EN(A,DIFLD,DQI) ; Main Entry Point
 N LEXFI,LEXFL
 S LEXFI=$G(A),LEXFL=$G(DIFLD)
BEGIN ; Begin
 I $D(DIVFIL)[0 N DIVDAT,DIVFIL,DIVMODE,DIVPG,POP D  G:$G(POP) Q^ZZLEXXVD
 . S DIVMODE="C"
 . D INIT^ZZLEXXVD
 N I,J,V,DIVREQK,DIVTYPE,DIVTMP,DG,DIVRIX,T,TYP,E,DDC,DIVZ,DE,DR,P4,M,DIDANGL,DIVROUTT,CTNT,FLDT,FLDL,TTXT,ETXT,EHTXT,REF
 S TOTERR=+($G(TOTERR))+1,FLERR=+($G(FLERR)),FDERR=0
 S TYP=$P($G(^DD(A,DIFLD,0)),U,2) I TYP="" Q
 D IJ^ZZLEXXVG(A) S V=$O(J(""),-1)
 F T="N","D","P","S","V","F" Q:TYP[T
 F FLDT="FREE TEXT","SET OF CODES","DATE","NUMERIC","POINTER","VARIABLE POINTER","K" I TYP[$E(FLDT) S:FLDT="K" T=FLDT,FLDT="MUMPS" Q
 I TYP["C" Q
 X "S REF=$ZR" S FLDL="" I $D(^DD(+($G(A)),+($G(DIFLD)),0)) S FLDL=$P($G(^DD(+($G(A)),+($G(DIFLD)),0)),"^",4) I $D(@REF)
 D FDH Q:$D(DIRUT)  S T=$E(T),DIVZ=$P(^DD(A,DIFLD,0),U,3),DDC=$P(^(0),U,5,999),DR=$P(^(0),U,2),P4=$P(^(0),U,4)
OUTT ; End
 I $G(^DD(A,DIFLD,2))]"" S DIVROUTT=^(2)
 S DIVREQK=$D(^DD("KEY","F",A,DIFLD))>9
 I $D(^DD("IX","F",A,DIFLD)) D
 . S DIVTYPE=T,T="INDEX",DIVROOT=$$FROOTDA^ZZLEXXVG(A)
 . D LOADVER^ZZLEXXVE(A,DIFLD,"DIVTMP")
 F %=0:0 S %=$O(^DD(A,DIFLD,1,%)) Q:%'>0  I $D(^(%,1)) D
 . N X S X=$P(^(0),U,2,9) Q:X'?1.A
 . I ^(2)?1"K ^".E1")",^(1)?1"S ^".E D
 . . ; Only looks at top-level X-refs
 . . S DG(%)="I $D("_$E(^(2),3,99)_"),"_$E(^(1),3,99) I 'V S DIVRIX(X)=""
UNIQ ..I DR["U",DIFLD=.01,X="B" S DDC="K % M %="_DIU_"""B"",X) K %(DA) K:$O(%(0)) X I $D(X) "_DDC
 S TTXT="" I T'="INDEX",'$D(^(+$O(^DD(A,DIFLD,1,0)),1)) G E
 I $D(DIRUT) Q:$D(DQI)  G Q
 I $D(DG) D
 . I T="INDEX" S E=DIVTYPE,DIVTYPE="IX"
 . E  S E=T,T="IX"
E ; Take out "E"
 F Y=$F(DDC,"%DT="""):1 S X=$E(DDC,Y) Q:""""[X  I X="E" S $E(DDC,Y)="" Q
 I DR["*" S DDC="Q" I $D(^DD(A,DIFLD,12.1)) X ^(12.1) I $D(DIC("S")) S DDC(1)=DIC("S"),DDC="X DDC(1) E  K X"
 D 0 S X=P4,Y=$P(X,";",2),X=$P(X,";")
 I +X'=X S X=""""_X_"""" I Y="" S DE=DE_"S X=DA D R" G XEC
 S DIDANGL="S X=$S($D(^(DA,"_X_")):$"_$S(Y:"P(^("_X_"),U,"_Y,1:"E(^("_X_"),"_$E(Y,2,9))_"),1:"""")",M=DIDANGL_" D R"
 I $L(M)+$L(DE)>250 S DE=DE_"X DE(1)",DE(1)=M
 E  S DE=DE_M
XEC ; Execute Logic
 K DIC,M,Y XECUTE DE_"  Q:$G(DIRUT)" Q:$G(DIRUT)
DANGL ; Look for Bad Cross-References
 S DIVRIX="A" F  S DIVRIX=$O(DIVRIX(DIVRIX)) Q:DIVRIX=""  D  Q:$G(DIRUT)
 .N IX,SN,SX,DA
 .S IX=I(0)_""""_DIVRIX_""")",SN=$QL(IX)
 .K ^UTILITY("DIVRIX",$J)
 .F  S IX=$Q(@IX) Q:IX=""  Q:$QS(IX,SN)'=DIVRIX  D  Q:$G(DIRUT)
 ..I @IX]"" Q
 ..S DA=$QS(IX,SN+2),SX=" """_DIVRIX_""" Cross-Ref '"_$QS(IX,SN+1)_"'"
 ..I '$D(@(I(0)_DA_")")) S M="Dangling"_SX D X Q
 ..X DIDANGL I $E($QS(IX,SN+1),1,30)'=$E(X,1,30) S M="Wrong"_SX D X Q
 ..I $D(^UTILITY("DIVRIX",$J,DA)) S M="Duplicate"_SX D X
 ..S ^(DA)=""
 Q:$D(DQI)
 I '$D(M) D TL("No Problems")
Q ; Quit
 S M=$O(^UTILITY("DIVR",$J,0)),E=$O(^(M)),DK=J(0) I $D(ZTQUEUED) S ZTREQ="@"
 E  I $T(^%ZISC)]"" D
 . D ^%ZISC
 E  X $G(^%ZIS("C"))
 G:'E!$D(DIRUT)!$D(ZTQUEUED) QX K DIBT,DISV D
 . N C,D,I,J,L,O,Q,S,D0,DDA,DICL,DIFLD,DIU0
 S DDC=0 I '$D(DIRUT) G Q:Y<0 F E=0:0 S E=$O(^UTILITY("DIVR",$J,E)) Q:E=""  S DDC=DDC+1,^DIBT(+Y,1,E)=""
 S:DDC>0 ^DIBT(+Y,"QR")=DT_U_DDC
QX ; Clean up and Quit
 K DIVINDEX,DIVKEY,DIVREQK,DIVROOT,DIVTMP,DIVTYPE
 K ^UTILITY("DIVR",$J),^UTILITY("DIVRIX",$J),DIRUT,DIROUT,DTOUT,DUOUT,DK,DQ,P,DR
 Q
R ; Review every entry in the file
 Q:$D(DIRUT)
 ; Lexicon ICD-10 Screen
 N LEXICD,LEXLAS S (LEXICD,LEXLAS)=0
 S:+($G(DA))>0&(+($G(DA(1)))'>0) LEXLAS=+($G(DA)) S:+($G(DA))>0&(+($G(DA(1)))>0) LEXLAS=+($G(DA(1)))
 S:+LEXLAS>0&(+($G(DI))>0) LEXICD=$$I10^ZZLEXXVA(+($G(DI)),+($G(LEXLAS)))
 I $D(DA),'$D(DA(1)),LEXFL=.01 S LEXXX(1)=+($G(LEXXX(1)))+1 S:LEXICD>0 LEXXX(2)=+($G(LEXXX(2)))+1
 Q:+($G(LEXICD))'>0
 I X?." " Q:DR'["R"&'DIVREQK  D  G X
 . I X="" S M="Missing"_$S(DIVREQK:" key value",1:"")
 . E  S M="Equals only 1 or more spaces"
 GOTO @T ; T = N or F or S, etc
P ; Pointer
 I @("$D(^"_DIVZ_"X,0))") S Y=X G F
 S M="No '"_X_"' in pointed-to file" G X
S ; Screen
 S Y=X X DDC I '$D(X) S M="Fails screen: "_""""_Y_"""" G X
 Q:";"_DIVZ[(";"_X_":")  S M=""""_X_""" not in Set" G X
D ; Date
 S X=$$DATE^ZZLEXXVG(X)
N ; Called from R
K ; Called from R
F ; Fail Input Transform
 S DQ=X I X'?.ANP S M="Non-printing character" G X
 X DDC Q:$D(X)
 I $G(DIVROUTT)]"" D  Q:$D(X)
 .N Y S Y=DQ X DIVROUTT S X=Y X DDC
 S M="Fails input transform: """_DQ_""""
X ; Errors
 I $O(^UTILITY("DIVR",$J,0))="" D ERH
 S X=$S(V:DA(V),1:DA),^UTILITY("DIVR",$J,X)=""
 S X=V I @(I(0)_"0)")
DA ;   Record Errors
 I 'X D  Q
 . D:+($G(FDERR))'>1100 ERT
 . S LEXRES("ERR")=+($G(LEXRES("ERR")))+1
 . S FDERR=+($G(FDERR))+1,FLERR=+($G(FLERR))+1,TOTERR=+($G(TOTERR))+1
 Q:$D(DIRUT)  D:+($G(FDERR))'>1100 N0H S X=X-1,@("Y=$D(^("_I(V-X)_",0))") G DA
0 ; 0 Node
 S Y=I(0),DE="",X=V
L ; Loop
 S DA="DA" S:X DA=DA_"("_X_")" S Y=Y_DA,DE=DE_"F "_DA_"=0:0 ",%="S "_DA_"=$O("_Y_"))" I V>2 S DE(X+X)=%,DE=DE_"X DE("_(X+X)_")"
 E  S DE=DE_%
 S DE=DE_" Q:"_DA_"'>0  S D"_(V-X)_"="_DA_" "
 S X=X-1 Q:X<0  S Y=Y_","_I(V-X)_"," G L
IX ; Indexes
 F %=0:0 S %=$O(DG(%)) Q:+%'>0  X DG(%) I '$T S M="Not properly cross-referenced: """_X_"""" G X
 G @E
V ; Variable Pointers
 I $P(X,";",2)'?1A.AN1"(".ANP,$P(X,";",2)'?1"%".AN1"(".ANP S M=""""_X_""""_" incorrect format" G X
 S M=$S($D(@(U_$P(X,";",2)_"0)")):^(0),1:"")
 I '$D(^DD(A,DIFLD,"V","B",+$P(M,U,2))) S M=$P(M,U)_" file not in the DD" G X
 I '$D(@(U_$P(X,";",2)_+X_",0)")) S M=U_$P(X,";",2)_+X_",0) does not exist" G X
 G F
 ;
INDEX ; Check new indexes
 ;   Set DIVINDEX(indexName,index#) = "" for indexes aren't set
 ;   Set DIVKEY(file#,keyName,uiNumber) = 
 ;       "null" : if key field is null
 ;       "uniq" : if key is not unique
 K DIVKEY,DIINDEX
 D VER^ZZLEXXVE(A,DIVROOT,.DA,"DIVTMP",.DIVINDEX,.DIVKEY)
 ;   If some indexes aren't set properly, print index info
 I $D(DIVINDEX) D  K DIVINDEX Q:$D(DIRUT)
 . N DIVNAME,DIVNUM
 . S DIVNAME="" F  S DIVNAME=$O(DIVINDEX(DIVNAME)) Q:DIVNAME=""  D  Q:$D(DIRUT)
 .. S DIVNUM=0 F  S DIVNUM=$O(DIVINDEX(DIVNAME,DIVNUM)) Q:'DIVNUM  D  Q:$D(DIRUT)
 ... S M="Index not properly set: "_$S($L(DIVNAME):"""",1:"")_DIVNAME_$S($L(DIVNAME):""" index ",1:"")_"(#"_DIVNUM_") for value """_X_""""
 ... D IER
 ;   If keys integrity is violated, print key info
 I $D(DIVKEY) D  K DIVKEY Q:$D(DIRUT)
 . N DIVFILE,DIVKNM,DIVPROB,DIVXRNM
 . S DIVFILE="" F  S DIVFILE=$O(DIVKEY(DIVFILE)) Q:DIVFILE=""  D  Q:$D(DIRUT)
 .. S DIVKNM="" F  S DIVKNM=$O(DIVKEY(DIVFILE,DIVKNM)) Q:DIVKNM=""  D  Q:$D(DIRUT)
 ... S DIVXRNM="" F  S DIVXRNM=$O(DIVKEY(DIVFILE,DIVKNM,DIVXRNM)) Q:DIVXRNM=""  D  Q:$D(DIRUT)
 .... S DIVPROB=DIVKEY(DIVFILE,DIVKNM,DIVXRNM)
 .... S M=$S(DIVPROB="null":"Key values are missing: ",1:"Key is not unique: ")
 .... S M=M_" file #"_DIVFILE_", key "_DIVKNM_", index "_DIVXRNM_", value """_X_""""
 .... D IER
 ;   Continue checking traditional xrefs (if any) and data type
 G @DIVTYPE
 ;
IER ; Index Errors - Invalid indexes
 N DIVTXT,DIVI,X
 S DIVTXT(1)=M D WP(.DIVTXT,39)
 I $O(^UTILITY("DIVR",$J,0))="" D ERH
 S X=$S(V:DA(V),1:DA),^UTILITY("DIVR",$J,X)=""
 S X=V I @(I(0)_"0)")
IERO ; Index Errors - Output
 I 'X D  Q
 . Q:$D(DIRUT)  D IER1,IER2 S LEXRES("ERR")=+($G(LEXRES("ERR")))+1
 . S FDERR=+($G(FDERR))+1,FLERR=+($G(FLERR))+1,TOTERR=+($G(TOTERR))+1
 . D:V BL
 Q:$D(DIRUT)
 D IE0 S X=X-1,@("Y=$D(^("_I(V-X)_",0))")
 G IER1
 Q
 ;
 ; Headers
HDR ;   Print header (not used)
 Q
FDH ;   Field Header
 N TTXT,REF X "S REF=$ZR" S TTXT="  "_$E($$LABEL^ZZLEXXVG(A,DIFLD),1,25)_" "
 S TTXT=TTXT_$J(" ",(30-$L(TTXT)))_$G(A)_" "
 S TTXT=TTXT_$J(" ",(40-$L(TTXT)))
 S TTXT=TTXT_$J(DIFLD,5)_", "_FLDL
 S TTXT=TTXT_$J(" ",(54-$L(TTXT)))_FLDT
 D TL(TTXT)
 S:$L(REF) REF=$D(@REF)
 Q
ERH ;   Error Header
 N TTXT,REF X "S REF=$ZR"
 S TTXT="  >> ENTRY#"_$S(V:"'S",1:"")
 S TTXT=TTXT_$J(" ",(14-$L(TTXT)))_$$LABEL^ZZLEXXVG(A,.01)
 S TTXT=TTXT_$J(" ",(39-$L(TTXT)))_"ERROR"
 D TL(TTXT)
 S:$L(REF) REF=$D(@REF)
 Q
 ;
 ; Lines
IER1 ;   Index Error #1
 N TTXT,REF,ET,TD,TM,LEN X "S REF=$ZR" S LEN=39
 S TTXT=$J(DA,11)
 S TD=$S($D(^(DA,0)):$P(^(0),U),1:DA) S:$L(TD)>24 TD=$E(TD,1,24)
 S TM=$G(DIVTXT(1)) S:$L(TM)>LEN TM=$E(TM,1,LEN)
 S TTXT=TTXT_$J(" ",(14-$L(TTXT)))_TD
 S TTXT=TTXT_$J(" ",(39-$L(TTXT)))_TM
 D TL(TTXT)
 S:$L(REF) REF=$D(@REF)
 Q
IER2 ;   Index Error Wrap
 Q:'$L($G(M))  N TTXT,REF,LN,TM,LEN X "S REF=$ZR" S LEN=39
 F LN=2:1 Q:'$D(DIVTXT(LN))  D
 . S TM=$G(DIVTXT(LN))
 . S:$L(TM)>LEN TM=$E(TM,1,LEN)
 . S TTXT="" S TTXT=TTXT_$J(" ",(39-$L(TTXT)))_TM
 . D TL(TTXT)
 S:$L(REF) REF=$D(@REF)
 Q
IE0 ;   Index Error 0
 N TTXT,REF,TD,TM,LEN X "S REF=$ZR" S LEN=39
 S TTXT=$J(DA,11)
 S TD=$P(^(DA(X),0),U) S:$L(TD)>24 TD=$E(TD,1,24)
 S TTXT=TTXT_$J(" ",(14-$L(TTXT)))_TD
 D TL(TTXT)
 S:$L(REF) REF=$D(@REF)
 Q
ERT ;   Error Text
 N TTXT,TM,ET,LN,TD,LEN,REF X "S REF=$ZR"
 S TM(1)=$G(M),LEN=39 D WP(.TM,LEN)
 S ET=$G(TM(1)) S:$L(ET)>LEN ET=$E(ET,1,LEN)
 S TD=$S($D(^(DA,0)):$P(^(0),U),1:DA) S:$L(TD)>24 TD=$E(TD,1,21)_"..."
 S TTXT=$J(DA,11)
 S TTXT=TTXT_$J(" ",(14-$L(TTXT)))_TD
 S TTXT=TTXT_$J(" ",(39-$L(TTXT)))_ET
 D TL(TTXT)
 F LN=2:1 Q:'$D(TM(LN))  D
 . N ET,TTXT S ET=$G(TM(LN)) S:$L(ET)>LEN ET=$E(ET,1,LEN)
 . S TTXT="",TTXT=TTXT_$J(" ",(39-$L(TTXT)))_ET
 . D TL(TTXT)
 S:$L(REF) REF=$D(@REF)
 Q
N0H ;   Node 0 Header
 N TTXT,REF X "S REF=$ZR"
 S TTXT="     "_$G(DA(X))
 S TTXT=TTXT_$J(" ",(14-$L(TTXT)))
 S TTXT=TTXT_$S($G(^(DA(X),0))]"":$P(^(0),U),1:"***NO ZERO NODE***")
 D TL(TTXT)
 S:$L(REF) REF=$D(@REF)
 Q
WP(ARY,LEN) ;   Wrap Array X() in LEN strings
 ;
 ; Input    ARY  Array to be parsed passed by reference
 ;          LEN  Length of parsed strings
 ;          
 ; Output   ARY  Parsed Array
 ; 
 N LINE,REM,STO,OUT K OUT S LEN=$G(LEN) S LINE=1  S REM=$G(ARY(LINE)) F  Q:'$L(REM)  D
 . N I,PO1,PO2,PO3,PO4,PO5,POT,STO S REM=$G(REM) S:'$L(REM) REM=$G(ARY(LINE))
 . I $L(REM)<LEN&($L($G(ARY((LINE+1))))) D
 . . N NXT S NXT=$G(ARY((LINE+1))) S:$E(REM,$L(REM))="-" REM=REM_NXT
 . . S:$E(REM,$L(REM))'="-" REM=REM_" "_NXT S LINE=LINE+1
 . I $L(REM)'>LEN D  S REM="" Q
 . . N STO,I S STO=$$TM(REM) S:$L(STO) I=$O(OUT(" "),-1)+1,OUT(I)=STO
 . S (PO1,PO2,PO3,PO4,PO5,POT)=0 I $L(REM) D
 . . N POS,CHR S POS=0 F CHR=" ","-",")",",","/" D
 . . . N I,C S POS=POS+1 Q:REM'[CHR  F I=LEN:-1 Q:I'>0  S C=$E(REM,I) S:C=CHR @("PO"_POS)=I,I=0
 . S POT=PO1 S:PO2>POT POT=PO2 S:PO3>POT POT=PO3 S:PO4>POT POT=PO4 S:PO5>POT POT=PO5
 . ; Parse on Length Only
 . I POT'>0 D  Q
 . . N STO,I S STO=$$TM($E(REM,1,LEN)),REM=$E(REM,(LEN+1),$L(REM)) S:$L(STO) I=$O(OUT(" "),-1)+1,OUT(I)=STO
 . ; Parse on Space Character
 . I POT>0,PO1=POT D  Q
 . . N STO,I S STO=$$TM($E(REM,1,(POT-1))) S REM=$E(REM,(POT+1),$L(REM)) S:$L(STO) I=$O(OUT(" "),-1)+1,OUT(I)=STO
 . ; Parse on "-" ")" "," or "/"
 . I POT>0,PO1'=POT D
 . . N STO,I S STO=$$TM($E(REM,1,POT)) S REM=$E(REM,(POT+1),$L(REM)) S:$L(STO) I=$O(OUT(" "),-1)+1,OUT(I)=STO
 K ARY M ARY=OUT
 Q
TM(X,Y) ;   Trim Character Y - Default " "
 S X=$G(X) Q:X="" X  S Y=$G(Y) S:'$L(Y) Y=" "
 F  Q:$E(X,1)'=Y  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=Y  S X=$E(X,1,($L(X)-1))
 Q X
BL ;   Blank Line
 N REF X "S REF=$ZR" D TL(" ")
 S:$L(REF) REF=$D(@REF)
 Q
TL(LEX) ;   Text Line
 W:$D(LEXTEST)&('$D(ZTQUEUED)) !,$G(LEX)
 N LEXX,LEXY,REF X "S REF=$ZR" S LEXX=$G(LEX) S LEXY=$O(^ZZLEXX("ZZLEXXV",$J,"VER"," "),-1)+1
 S ^ZZLEXX("ZZLEXXV",$J,"VER",+LEXY)=LEXX,^ZZLEXX("ZZLEXXV",$J,"VER",0)=+LEXY
 S:$L(REF) REF=$D(@REF)
 Q
AL(LEX) ;   Append Line
 W:$D(LEXTEST)&('$D(ZTQUEUED)) $G(LEX)
 N LEXX,LEXY,REF X "S REF=$ZR" S LEXX=$G(LEX) S LEXY=$O(^ZZLEXX("ZZLEXXV",$J,"VER"," "),-1) Q:+LEXY'>0
 S ^ZZLEXX("ZZLEXXV",$J,"VER",+LEXY)=$G(^ZZLEXX("ZZLEXXV",$J,"VER",+LEXY))_LEXX
 S:$L(REF) REF=$D(@REF)
 Q
OK ;   Ok Line
 W:$D(LEXTEST)&('$D(ZTQUEUED)) ?76,"OK"
 N LEXX,LEXY,REF X "S REF=$ZR" S LEXY=$O(^ZZLEXX("ZZLEXXV",$J,"VER"," "),-1) Q:+LEXY'>0
 S LEXX=$G(^ZZLEXX("ZZLEXXV",$J,"VER",+LEXY)) Q:$E(LEXX,1,2)'="  "
 S LEXX=$E(LEXX,1,75),LEXX=LEXX_$J(" ",(76-$L(LEXX)))_"OK"
 S ^ZZLEXX("ZZLEXXV",$J,"VER",+LEXY)=LEXX
 S:$L(REF) REF=$D(@REF)
 Q
