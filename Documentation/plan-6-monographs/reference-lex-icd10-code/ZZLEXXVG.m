ZZLEXXVG ;SLC/KER - Import - FileMan Verify (DI Calls) ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^DD(                None
 ;    ^DD("IX"            None
 ;    ^DI(                None
 ;    ^DIC(               None
 ;    ^TMP("DIKK"         None
 ;               
 ; External References
 ;    BLD^DIALOG          ICR   2050
 ;               
 Q
LABEL(F,D) ; $$LABEL^DIALOGZ     ZZLEXXVF
 ;
 ; Return the foreign-language FIELD NAME
 ; 
 N N,FILE,FIELD S FILE=$G(F),FIELD=$G(D),N=$P($G(^DD(FILE,FIELD,0)),"^") I N="" Q N
 I $P(^(0),"^",2)["W",$G(^DD(FILE,0,"UP")) Q $$LABEL(^("UP"),$O(^DD(^("UP"),"SB",FILE,0)))
 I $G(DUZ("LANG")),$D(^(.008,DUZ("LANG"),0))#2 Q ^(0)
 Q N
SETXARR(DIFILE,DIXR,DIKTMP,DINULL,DION,DI01) ; SETXARR^DIKC        ZZLEXXVE
 ;
 ; Loop through DIKTMP and set X array.
 ; If any values used as subscripts are null
 ; 
 ; Return arrays passed by reference:
 ; 
 ; DINULL=1
 ; DINULL(order#) = ""
 ;                  or file^field^levDiff (for field type subscripts)
 ; 
 ; DI01(order#) = "" if order # is .01 field
 ;
 N DIKCX,DIKF,DIKO,X1,X2 K X,DI01,DINULL
 S DINULL=0,(DIKF,DIKO)=$O(@DIKTMP@(DIFILE,DIXR,0)) Q:'DIKF
 S:$G(DION)="" DION=U F  D  S DIKO=$O(@DIKTMP@(DIFILE,DIXR,DIKO)) Q:'DIKO
 . K DIKCX M DIKCX=X X $G(@DIKTMP@(DIFILE,DIXR,DIKO))
 . I $G(X)]"",$D(@DIKTMP@(DIFILE,DIXR,DIKO,"T")) X @DIKTMP@(DIFILE,DIXR,DIKO,"T")
 . S:$D(X)#2 (DIKCX,DIKCX(DIKO))=X K X M X=DIKCX
 . S:$P($G(@DIKTMP@(DIFILE,DIXR,DIKO,"F")),U,2)=.01 DI01(DIKO)=""
 . I $G(X(DIKO))="",$G(@DIKTMP@(DIFILE,DIXR,DIKO,"SS")) S DINULL=1 S:$G(@DIKTMP@(DIFILE,DIXR,DIKO,"F")) DINULL(DIKO)=@DIKTMP@(DIFILE,DIXR,DIKO,"F")
 S:$D(X(DIKF))#2 X=$G(X(DIKF))
 Q
LOADFLD(FIL,FLD,LOG,ACT,VALRT,TMPF,TMPR,FLIST,RLIST,FLAG) ; LOADFLD^DIKC1       ZZLEXXVE
 ; 
 ; Get all xrefs for a field. Uses the "F" index on file/field.
 ; 
 ; Input:
 ; 
 ;   FIL   = File #
 ;   FLD   = Field #
 ;   LOG   [ K : load kill logic
 ;         [ S : load set logic
 ;         [ W : load entire kill logic (if LOG also [ "K")
 ;   ACT   = codes: IR
 ;            If ACT is not null, a xref is picked up only if ACT
 ;            and the Activity field (#.41) have codes in common.
 ;   VALRT = Array Ref where old/new values are located
 ;   TMPF  = Root to store field-level xref info
 ;   TMPR  = Root to store record-level xref info
 ;   FLAG  [ i : don't load index-type xrefs (only load whole file xrefs)
 ;         [ f : don't load field-type xrefs
 ;         [ r : don't load record-type xrefs
 ;         
 ; Output:
 ; 
 ;   .FLIST = ^-delimited list of field xrefs (overflow in FLIST(n))
 ;   .RLIST = ^-delimited list of record xrefs (overflow in RLIST(n))
 ;
 N EXECFLD,TMP,XR
 K FLIST,RLIST S (FLIST,RLIST)=0,(FLIST(0),RLIST(0))=""
 S:$G(TMPR)="" TMPR=TMPF
 S XR=0 F  S XR=$O(^DD("IX","F",FIL,FLD,XR)) Q:'XR  D
 . I $P($G(^DD("IX",XR,0)),U)="" K ^DD("IX","F",FIL,FLD,XR) Q
 . S EXECFLD=$P(^DD("IX",XR,0),U,6)
 . I $G(ACT)]"",$TR(ACT,$P(^DD("IX",XR,0),U,7),$TR($J("",$L($P(^(0),U,7)))," ","*"))'["*" Q
 . I $G(FLAG)["i",$P(^DD("IX",XR,0),U,8)="I" Q
 . I $G(FLAG)["f",$P(^DD("IX",XR,0),U,6)="F" Q
 . I $G(FLAG)["r",$P(^DD("IX",XR,0),U,6)="R" Q
 . I $G(FLAG)["x",$G(^DD("IX",XR,"NOREINDEX")) Q
 . K TMP
 . I EXECFLD="R" D
 .. S TMP=$G(TMPR)
 .. I $L(RLIST(RLIST))+$L(XR)+1>255 S RLIST=RLIST+1,RLIST(RLIST)=""
 .. S RLIST(RLIST)=RLIST(RLIST)_$E(U,RLIST(RLIST)]"")_XR
 . E  D
 .. S TMP=$G(TMPF)
 .. I $L(FLIST(FLIST))+$L(XR)+1>255 S FLIST=FLIST+1,FLIST(FLIST)=""
 .. S FLIST(FLIST)=FLIST(FLIST)_$E(U,FLIST(FLIST)]"")_XR
 . Q:$G(TMP)=""  Q:$D(@TMP@(FIL,XR))
 . D CRV(XR,$G(VALRT),TMP)
 . D:$G(LOG)]"" LOG(XR,LOG,TMP)
 . I $G(LOG)["K",$G(LOG)["W" D KW(XR,TMP)
 I FLIST(0)]"" S FLIST=FLIST(0) K FLIST(0)
 E  K FLIST S FLIST=""
 I RLIST(0)]"" S RLIST=RLIST(0) K RLIST(0)
 E  K RLIST S RLIST=""
 Q
FLEV(FIL,F) ; $$FLEV^DIKCU        ZZLEXXVE
 ;
 ; Return the level of File
 ; 
 ; Input:
 ; 
 ;   FIL = file#
 ;   F   [ "D" : generate Dialog
 ;   
 Q:$G(FIL)="" ""
 N LEV F LEV=0:1 Q:$G(^DD(FIL,0,"UP"))=""  S FIL=^("UP")
 I '$D(^DD(FIL)) D:$G(F)["D" ERR(402,FIL) Q ""
 Q LEV
FNUM(ROOT,F) ;  $$FNUM^DIKCU        ZZLEXXVE
 ;
 ; Given file root, return File # from 2nd piece of header node.
 ; Also check that that file has a DD entry and a non-wp .01 field.
 ; Return null if error.
 ; 
 ; Input:
 ; 
 ;   ROOT = file root
 ;   F    [ D : generate dialog
 ;
 Q:$G(ROOT)="" ""  N FIL S ROOT=$$CREF(ROOT)
 I $D(@ROOT@(0))[0 D:$G(F)["D" ERR(404,"","","",ROOT) Q ""
 S FIL=+$P(@ROOT@(0),U,2) I '$$VFNUM(FIL,$G(F)) Q ""
 Q FIL
FROOTDA(FIL,F,L,TROOT) ; $$FROOTDA^DIKCU     ZZLEXXVE,ZZLEXXVF
 ; 
 ; Return global root of File
 ; It may include DA(1), DA(2), ... for subfiles
 ; Examples: ^DIZ(9999) and ^DIZ(9999,DA(1),"MULT1")
 ; 
 ; Input:
 ; 
 ;   FIL  = file #
 ;   FLAG [ O : return open root
 ;        [ D : generate dialog
 ;        starts with number : indicates offset to use for DA array
 ;        
 ; Output:
 ; 
 ;   .L     = level of file
 ;   .TROOT = top level root
 ;
 I $G(FIL)="" S (L,TROOT)="" Q ""
 S F=$G(F)
 I $D(^DIC(FIL,0,"GL"))#2 D  Q TROOT
 . S L=0,TROOT=$S(F["O":^("GL"),1:$$CREF(^("GL")))
 N ERR,I,MFLD,ND,PAR,ROOT,SUB
 S SUB=FIL
 F L=0:1 S PAR=$G(^DD(SUB,0,"UP")) Q:'PAR  D  Q:$G(ERR)
 . S MFLD=$O(^DD(PAR,"SB",SUB,""))
 . S ND=$P($P($G(^DD(PAR,MFLD,0)),U,4),";")
 . I ND?." " S ERR=1 D:F["D" ERR(502,PAR,"",MFLD) Q
 . S:ND'=+$P(ND,"E") ND=""""_ND_""""
 . S ND(L+1)=ND
 . S SUB=PAR
 I $G(ERR) S (L,TROOT)="" Q ""
 S (ROOT,TROOT)=$G(^DIC(SUB,0,"GL"))
 I ROOT="" D:F["D" ERR(402,SUB) S L="" Q ""
 F I=L:-1:1 S ROOT=ROOT_"DA("_(I+F)_"),"_ND(I)_","
 S:F'["O" TROOT=$$CREF(TROOT)
 Q $S(F["O":ROOT,1:$$CREF(ROOT))
VDA(DA,F) ; $$VDA^DIKCU1        ZZLEXXVE
 ;
 ; Make sure elements DA array are positive canonic numbers.
 ;
 ; Input:
 ; 
 ;   [.]DA = DA array
 ;   F   [ R : DA can't be 0 or null
 ;       [ D : generate Dialog
 ;
 ; Output: 1 if valid; 0 if invalid
 ;
 N I,ERR Q:$D(DA)[0 0 I $G(F)["R" D:0[DA
 . S ERR=1 D:$G(F)["D" ERR(202,"","","","RECORD")
 I DA]"",DA<0!(DA'=+$P(DA,"E")) D
 . S ERR=1 D:$G(F)["D" ERR(202,"","","","RECORD")
 E  F I=1:1 Q:'$D(DA(I))  I DA(I)'>0!(DA(I)'=+$P(DA(I),"E")) D  Q
 . S ERR=1 D:$G(F)["D" ERR(202,"","","","RECORD")
 Q '$G(ERR)
VFLD(FIL,FLD,F) ; $$VFLD^DIKCU1       ZZLEXXVE
 ; 
 ; Check that the Fil/Fld exists in the ^DD
 ; 
 ; Input:
 ; 
 ;   FIL = File or subfile #
 ;   FLD = Field #
 ;   F   [ D : generate Dialog
 ;
 ; Output: 1 if valid; 0 if invalid
 ; 
 Q:$G(FIL)="" 0  Q:$G(FLD)="" 0
 I '$D(^DD(FIL,FLD)) D:$G(F)["D" ERR(501,FIL,"",FLD,FLD) Q 0
 Q 1
ERR(ERR,DIFILE,DIIENS,DIFIELD,DI1,DI2,DI3) ; ERR^DIKCU2          ZZLEXXVE
 ; Build an error message
 N P,I,V F I="FILE","IENS","FIELD",1,2,3 S V=$G(@("DI"_I)) S:V]"" P(I)=V
 D BLD^DIALOG(ERR,.P,.P)
 Q
WRAP(T,WID,WID1,COD) ; WRAP^DIKCU2         ZZLEXXVF
 ;
 ; Wrap the lines in array T
 ;
 ; Input:
 ; 
 ;   .T    = array of text; 1st line can be in T or T(0)
 ;             subsequent lines are in T(1),...,T(n)
 ;    WID  = maximum length of each line (default = IOM[or 80]-1)
 ;           if < 0 : IOM-1+WID
 ;    WID1 = maximum length of line 1 (optional)
 ;           if ""  : WID
 ;           if < 0 : IOM-1+WID1
 ;    COD  = 1, if lines should NOT wrap on word boundaries
 ;    
 Q:'$D(T)  N E,J,P,T0,W S WID=$G(WID)\1 S:WID<1 WID=$G(IOM,80)-1+WID S:WID<1 WID=79
 S W=$S($G(WID1):WID1\1,$G(WID1)=0:$G(IOM,80)-1,1:WID) S:W<1 W=$G(IOM,80)-1+W S:W<1 W=79
 I $D(T(0))[0 S T0=1,T(0)=T
 I '$G(COD) F J=0:1 Q:'$D(T(J))  D
 . S:J=1 W=WID S:J T(J)=$$LD(T(J))
 . I $L(T(J))>W D
 .. D DOWNT F P=$L(T(J)," "):-1:0 Q:$L($P(T(J)," ",1,P))'>W
 .. I 'P S T(J+1)=$E(T(J),W+1,999),T(J)=$E(T(J),1,W)
 .. E  S T(J+1)=$$LD($P(T(J)," ",P+1,999)),T(J)=$$TR($P(T(J)," ",1,P))
 . E  I $L(T(J))<W D
 .. Q:'$D(T(J+1))  I T(J)]"",T(J)'?.E1" " S T(J)=T(J)_" "
 .. S T(J+1)=$$LD(T(J+1)) F P=1:1:$L(T(J+1)," ")+1 Q:$L(T(J))+$L($P(T(J+1)," ",1,P))>W
 .. S T(J)=$$TR(T(J)_$P(T(J+1)," ",1,P-1))
 .. S T(J+1)=$$LD($P(T(J+1)," ",P,999))
 .. I T(J+1)="" D UPT S J=J-1
 E  F J=0:1 Q:'$D(T(J))  D
 . S:J=1 W=WID
 . I $L(T(J))>W D DOWNT S T(J+1)=$E(T(J),W+1,999),T(J)=$E(T(J),1,W)
 . E  I $L(T(J))<W D
 .. Q:'$D(T(J+1))  S E=W-$L(T(J)),T(J)=T(J)_$E(T(J+1),1,E)
 .. S T(J+1)=$E(T(J+1),E+1,999) I T(J+1)="" D UPT S J=J-1
 I $G(T0) S T=T(0) K T(0)
 Q
UNIQUE(DIFILE,DIUINDEX,X,DA,DITMP) ; $$UNIQUE^DIKK2      ZZLEXXVE
 ; 
 ; Check whether X values are unique
 ; 
 N DIIENSC,DIMAXL,DIORD,DISS,DIUIR,DIVAL,S
 I $G(DITMP)="" N DIKKTMP D
 . S DITMP="DIKKTMP"
 . D LOADXREF("","","",DIUINDEX,"",DITMP)
 D XRINFO(DIUINDEX,.DIUIR,"",.DIMAXL)
 S DIUIR=$NA(@DIUIR)
 Q:'$D(@DIUIR) 1
 S DIIENSC=$$IENS(.DA)
 S DIORD=0
 F  S DIORD=$O(DIMAXL(DIORD)) Q:'DIORD  D:$L(X(DIORD))'<DIMAXL(DIORD)
 . S S=+$G(@DITMP@(DIFILE,DIUINDEX,DIORD,"SS")) Q:'S
 . S DIVAL(S)=X(DIORD)
 . S DISS(S)=$G(@DITMP@(DIFILE,DIUINDEX,DIORD))
 Q $$UNIQIX(DIUIR,DIIENSC,.DA,.DIVAL,.DISS)
DATE(Y) ; $$DATE^DIUTL        ZZLEXXVF
 ;
 ; Return a Date
 ; 
 Q $$FMTE(Y,"1U")
IJ(N) ; IJ^DIUTL            ZZLEXXVF
 ;
 ; Build I & J arrays given subfile number N
 ; 
 N A K I,J
 S J(0)=N,N=0
0 I $D(^DIC(J(0),0,"GL")) S I(0)=^("GL") Q
 S A=$G(^DD(J(0),0,"UP")) Q:A=""
 S I=$O(^DD(A,"SB",J(0),0)) Q:'I
 S I=$P($P($G(^DD(A,I,0)),U,4),";") Q:I=""
 I +I'=I S I=""""_I_""""
 F J=N:-1:0 S J(J+1)=J(J) S:J I(J+1)=I(J)
 S J(0)=A,I(1)=I,N=N+1 G 0
DA(DAIEN,DATARG) ; DA^DILFL            ZZLEXXVE
 ; 
 ; Get DA
 K DATARG N I F I=1:1:$L(DAIEN,",")-1 S DATARG(I-1)=$P(DAIEN,",",I)
 I $D(DATARG(0)) S DATARG=DATARG(0) K DATARG(0)
 Q
 ;
 ; Miscellaneous
LOADXREF(RFIL,FLD,LOG,XREF,VALRT,TMP) ;   Load Cross-References
 N I,N,PC,RF,XR,XRLIST
 S N=0,XRLIST=$G(XREF) F  Q:XRLIST=""  D
 . F PC=1:1:$L(XRLIST,U) K XR S XR=$P(XRLIST,U,PC) D:XR]""
 .. I XR'=+$P(XR,"E") D  Q:$D(XR)<2
 ... S I=0 F  S I=$O(^DD("IX","AC",RFIL,I)) Q:'I  D
 .... S:$P($G(^DD("IX",I,0)),U,2)=XR XR(I)=""
 .. E  Q:$P($G(^DD("IX",XR,0)),U)=""  S XR(XR)=""
 .. S XR=0 F  S XR=$O(XR(XR)) Q:'XR  D
 ... S RF=$P(^DD("IX",XR,0),U,9)
 ... I $G(FLD) Q:'$D(^DD("IX","F",$S($G(RFIL):RFIL,1:RF),FLD,XR))
 ... E  I $G(RFIL) Q:RFIL'=RF
 ... D CRV(XR,$G(VALRT),TMP)
 ... D:$G(LOG)]"" LOG(XR,LOG,TMP)
 ... D:$G(LOG)["K" KW(XR,TMP)
 . S N=$O(XREF(N)),XRLIST=$S(N:$G(XREF(N)),1:"")
 Q
CRV(XR,VALRT,TMP) ;   Cross-Reference Values
 Q:'$G(XR)!($G(TMP)="")
 N CRV,CRV0,DEC,FIL,FLD,MAXL,ND,ORD,OROOT,RFIL,SBSC,TYPE
 S RFIL=$P($G(^DD("IX",XR,0)),U,9) Q:RFIL=""  Q:$D(@TMP@(RFIL,XR))
 S @TMP@(RFIL,XR)=$P(^DD("IX",XR,0),U,2)_U_$P(^(0),U)_U_$P(^(0),U,8)_U_$P(^(0),U,4)
 S OROOT=$$FROOTDA(RFIL,"O")_"DA," Q:OROOT="DA,"
 S CRV=0 F  S CRV=$O(^DD("IX",XR,11.1,CRV)) Q:'CRV  D
 . S CRV0=$G(^DD("IX",XR,11.1,CRV,0))
 . S ORD=$P(CRV0,U),TYPE=$P(CRV0,U,2),MAXL=$P(CRV0,U,5),SBSC=$P(CRV0,U,6)
 . Q:ORD=""!(TYPE="")
 . I TYPE="F" D
 .. S FIL=$P(CRV0,U,3),FLD=$P(CRV0,U,4) Q:(FIL="")!'FLD
 .. I FIL'=RFIL N OROOT,LDIF D  Q:$G(OROOT)=""
 ... S LDIF=$$FLEVDIFF(FIL,RFIL) Q:'LDIF
 ... S OROOT=$$FROOTDA(FIL,LDIF_"O") Q:OROOT=""
 ... S OROOT=OROOT_"DA("_LDIF_"),"
 .. S DEC=$$DEC(FIL,FLD,$G(VALRT),OROOT) Q:DEC=""
 .. S @TMP@(RFIL,XR,ORD)=DEC
 .. S @TMP@(RFIL,XR,ORD,"F")=FIL_U_FLD_$S($G(LDIF):U_LDIF,1:"")
 .. S:$G(^DD("IX",XR,11.1,CRV,2))'?."^" @TMP@(RFIL,XR,ORD,"T")=^(2)
 . E  I TYPE="C" S @TMP@(RFIL,XR,ORD)=$G(^DD("IX",XR,11.1,CRV,1.5))
 . S:SBSC @TMP@(RFIL,XR,ORD,"SS")=SBSC_$S(MAXL:U_MAXL,1:"")
 Q
LOG(XR,LOG,TMP) ;   Load Set and/or Kill logic into into @TMP
 Q:'$G(XR)  Q:$G(LOG)=""  Q:$G(TMP)=""
 N SL,KL,SC,KC,RFIL
 S RFIL=$P(^DD("IX",XR,0),U,9) Q:RFIL=""
 I LOG["S" D
 . S SL=$G(^DD("IX",XR,1)),SC=$G(^(1.4))
 . I "Q"'[SL,SL'?."^" S @TMP@(RFIL,XR,"S")=SL
 . I "Q"'[SC,SC'?."^" S @TMP@(RFIL,XR,"SC")=SC
 I LOG["K" D
 . S KL=$G(^DD("IX",XR,2)),KC=$G(^(2.4))
 . I "Q"'[KL,KL'?."^" S @TMP@(RFIL,XR,"K")=KL
 . I "Q"'[KC,KC'?."^" S @TMP@(RFIL,XR,"KC")=KC
 Q
CREF(X) ;   Return closed root of X
 N F,L S L=$E(X,$L(X)),F=$E(X,1,$L(X)-1) Q $S(L="(":F,L=",":F_")",1:X)
OREF(X) ;   Return open root of X
 N X1,X2 S X1=$P(X,"(")_"(",X2=$$OR2($P(X,"(",2,999)) Q:X2="" X1 Q X1_X2_","
OR2(%) ;   Return open root of X (cont)
 Q:%=")"!(%=",") "" Q:$L(%)=1 %  S:"),"[$E(%,$L(%)) %=$E(%,1,$L(%)-1) Q %
DEC(FIL,FLD,VALRT,OROOT) ;   Data Extraction Code
 Q:$P($G(^DD(FIL,FLD,0)),U)="" ""  N ND,PC,DEC S PC=$P($G(^DD(FIL,FLD,0)),U,4)
 S ND=$P(PC,";"),PC=$P(PC,";",2) Q:ND?." "!("0 "[PC) ""  S:ND'=+$P(ND,"E") ND=""""_ND_""""
 I $G(OROOT)="" S OROOT=$$FROOTDA(FIL,"O")_"DA," Q:OROOT="DA," ""
 I PC S DEC="$P($G("_OROOT_ND_")),U,"_PC_")"
 E  S DEC="$E($G("_OROOT_ND_")),"_+$E(PC,2,999)_","_$P(PC,",",2)_")"
 I $G(VALRT)]"" D
 . I $E(VALRT,$L(VALRT))="_" D  Q
 . . S VALRT=$E(VALRT,1,$L(VALRT)-3)
 . . S DEC="$G("_VALRT_FIL_""",DIIENS,"_FLD_",DION),"_DEC_")"
 . S:"(,"'[$E(VALRT,$L(VALRT)) VALRT=$$OREF(VALRT)
 . S DEC="$G("_VALRT_FIL_",DIIENS,"_FLD_",DION),"_DEC_")"
 S DEC="S X="_DEC
 Q DEC
KW(XR,TMP) ;   Get Kill Entire Index logic
 Q:'$G(XR)!($G(TMP)="")
 N FILE,KW,RFIL,TYPE
 S KW=$G(^DD("IX",XR,2.5)) Q:KW="Q"!(KW?."^")
 S FILE=$P($G(^DD("IX",XR,0)),U),TYPE=$P(^(0),U,8),RFIL=$P(^(0),U,9)
 Q:FILE=""!(RFIL="")
 S @TMP@("KW",FILE,XR)=KW
 S:RFIL'=FILE @TMP@("KW",FILE,XR,0)=TYPE_U_RFIL_U_$$FLEVDIFF(FILE,RFIL)
 Q
FLEVDIFF(FIL1,FIL2) ;   Difference in levels between File1 and File2.
 Q:$G(FIL1)=""!($G(FIL2)="") ""
 N DIFF,FIL
 S FIL=FIL2
 F DIFF=0:1 Q:FIL=FIL1  S FIL=$G(^DD(FIL,0,"UP")) Q:FIL=""
 Q $S(FIL=FIL1:DIFF,1:"")
VFNUM(FIL,F) ;   Check that File# exists and has a non-wp .01 field
 Q:$G(FIL)="" 0  I '$D(^DD(FIL)) D:$G(F)["D" ERR(401,FIL) Q 0
 I $P($G(^DD(FIL,.01,0)),U,2)="" D:$G(F)["D" ERR(406,FIL) Q 0
 I $P(^DD(FIL,.01,0),U,2)["W" D:$G(F)["D" ERR(407,FIL) Q 0
 Q 1
DOWNT ;   Push the T array from element J+1 down
 N K F K=$O(T(""),-1):-1:J+1 S T(K+1)=T(K)
 S T(J+1)=""
 Q
UPT ;   Pop the T array from element J+1 down
 N K F K=J+1:1:$O(T(""),-1)-1 S T(K)=T(K+1)
 K T($O(T(""),-1))
 Q
TR(X) ;   Strip trailing spaces
 Q:$G(X)="" X  N I F I=$L(X):-1:0 Q:$E(X,I)'=" "
 Q $E(X,1,I)
LD(X) ;   Strip leading spaces
 Q:$G(X)="" X  N I F I=1:1:$L(X)+1 Q:$E(X,I)'=" "
 Q $E(X,I,999)
UNIQIX(DIUIR,DIIENSC,DA,DIVAL,DISS,DIEVK) ;   Indexes
 N DIDASV,DIIENS,DINDX,DINS,DION,DIS,DIUNIQ,I,L,X
 M DIDASV=DA
 S DION="N"
 S DIUNIQ=1,DINS=$QL(DIUIR),DINDX=DIUIR
 F  S DINDX=$Q(@DINDX) Q:DINDX=""  Q:$NA(@DINDX,DINS)'=DIUIR  D  Q:'DIUNIQ
 . S DIIENS=$E(DINDX,$L(DIUIR)+1,$L(DINDX)-1),L=$L(DIIENS,",")
 . S DA=$P(DIIENS,",",L) F I=1:1:L-1 S DA(I)=$P(DIIENS,",",L-I)
 . S DIIENS=$$IENS(.DA) Q:DIIENS=DIIENSC
 . I $G(DIEVK) Q:$D(^TMP("DIKK",$J,"L",$P(DIEVK,U),$P(DIEVK,U,2),DIIENS))  Q:$D(^TMP("DIKK",$J,"F",$P(DIEVK,U),$P(DIEVK,U,2),DIIENS))
 . I '$D(DIVAL) S DIUNIQ=0 Q
 . S DIS=0 F  S DIS=$O(DIVAL(DIS)) Q:'DIS  X DISS(DIS) I X'=DIVAL(DIS) Q
 . S:'DIS DIUNIQ=0
 K DA M DA=DIDASV
 Q DIUNIQ
IENS(DA) ;   Return IENS from DA array
 N I,IENS
 S IENS=$G(DA)_"," F I=1:1:$O(DA(" "),-1) S IENS=IENS_DA(I)_","
 Q IENS
XRINFO(XR,UIR,LDIF,MAXL,RFILE,IROOT,SS) ;   Get info about an index
 K UIR,LDIF,MAXL,SS Q:$D(^DD("IX",XR,0))[0
 N CRV,FIL,FILE,FLD,ML,NAME,ORD,TYPE,S
 S FILE=$P(^DD("IX",XR,0),U),NAME=$P(^(0),U,2),TYPE=$P(^(0),U,8),RFILE=$P(^(0),U,9)
 Q:NAME=""!'FILE!'RFILE
 I FILE'=RFILE D
 . S LDIF=$$FLEVDIFF(FILE,RFILE) Q:LDIF=""
 . S UIR=$$FROOTDA(FILE,LDIF_"O") Q:UIR=""
 E  D
 . S LDIF=0
 . S UIR=$$FROOTDA(FILE,"O") Q:UIR=""
 Q:$G(UIR)=""
 S UIR=UIR_""""_NAME_"""",IROOT=UIR_")"
 S S=0 F  S S=$O(^DD("IX",XR,11.1,"AC",S)) Q:'S  S CRV=$O(^(S,0)) D:CRV
 . Q:$D(^DD("IX",XR,11.1,CRV,0))[0  S ORD=$P(^(0),U),FIL=$P(^(0),U,3),FLD=$P(^(0),U,4),ML=$P(^(0),U,5)
 . Q:'ORD
 . I ML S UIR=UIR_",$E(X("_ORD_"),1,"_ML_")",MAXL(ORD)=ML
 . E  S UIR=UIR_",X("_ORD_")"
 . I FIL,FLD S SS=$G(SS)+1,SS(S)=FIL_U_FLD_$S(ML:U_ML,1:"")
 S UIR=UIR_")"
 Q
 ;
FMTE(Y,%F) ; FM to external
 Q:'$G(Y) $G(Y) S %F=$G(%F) Q:($G(DUZ("LANG"))>1) $$OUT(Y,"FMTE",%F)
 N %T,%R
T2 ;   Time
 S %T="."_$E($P(Y,".",2)_"000000",1,7) D @("F"_$S(%F<1:1,%F>7:1,1:+%F\1)) Q %R
 Q
OUT(Y,LF,%F) ;   Convert to language dependant output format
 N DIALF S DIALF=$G(LF) I $D(Y)[0!($G(DIALF)="") Q ""
 N DINAKED,DIY S DINAKED=$NA(^(0))
 N DILANG S DILANG=+$G(DUZ("LANG")) S:DILANG<1 DILANG=1
 S DIY=$G(^DI(.85,DILANG,DIALF)) I DIY="" S:DILANG'=1 DIY=$G(^DI(.85,1,DIALF)) I DIY="" S Y="" G Q
 X DIY
Q ;   Quit Date
 D:DINAKED]""
 . I DINAKED["(" Q:$O(@(DINAKED))  Q
 . I $D(@(DINAKED))
 . Q
 Q Y
F5 ;   Date Format #5
F1 ;   Date Format #1
 S %R=$P($S(%F'["U":$T(M),1:$T(MU))," ",$S($E(Y,4,5):$E(Y,4,5)+2,1:0))_$S($E(Y,4,5):" ",1:"")_$S($E(Y,6,7):$S((%F\1'=5):$E(Y,6,7),1:+$E(Y,6,7))_$E(", ",1,1+(%F\1'=5)),1:"")_($E(Y,1,3)+1700)
TM ;   Time
 Q:%T'>0!(%F["D")
 I %F'["P" S %R=%R_$S(%F\1'=6:"@",1:" @ ")_$E(%T,2,3)_":"_$E(%T,4,5)_$S($E(%T,6,7)!(%F["S"):":"_$E(%T,6,7),1:$S(%F\1'=6:"",1:"   "))
 I %F["P" S %R=%R_" "_$S($E(%T,2,3)>12:$E(%T,2,3)-12,1:+$E(%T,2,3))_":"_$E(%T,4,5)_$S($E(%T,6,7)!(%F["S"):":"_$E(%T,6,7),1:"")_$S($E(%T,2,5)\1200=1:" pm",1:" am")
 Q
M ;; Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec
MU ;; JAN FEB MAR APR MAY JUN JUL AUG SEP OCT NOV DEC
F2 ;   Date Format #2
 S %R=+$E(Y,4,5)_"/"_(+$E(Y,6,7))_"/"_$E(Y,2,3)
 G TM
F3 ;   Date Format #3
 S %R=+$E(Y,6,7)_"/"_(+$E(Y,4,5))_"/"_$E(Y,2,3)
 G TM
F4 ;   Date Format #4
 S %R=$E(Y,2,3)_"/"_$E(Y,4,5)_"/"_$E(Y,6,7)
 G TM
F6 ;   Date Format #6
 S %R=$S($E(Y,4,5):$E(Y,4,5)_"-",1:"")_$S($E(Y,6,7):$E(Y,6,7)_"-",1:"")_(1700+$E(Y,1,3))
 G TM
F7 ;   Date Format #7
 S %R=$S($E(Y,4,5):+$E(Y,4,5)_"-",1:"")_$S($E(Y,6,7):+$E(Y,6,7)_"-",1:"")_(1700+$E(Y,1,3))
 G TM
