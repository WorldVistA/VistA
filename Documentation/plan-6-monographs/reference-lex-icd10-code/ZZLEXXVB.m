ZZLEXXVB ;SLC/KER - Import - FileMan Verify (Where) ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^%ZOSF("OS")        ICR  10096
 ;    ^LEX(757.02         SACC 1.3
 ;    ^ZZLEXX("ZZLEXXV"   SACC 1.3
 ;               
 ; External References
 ;    HOME^%ZIS           ICR  10086
 ;    ^%ZTLOAD            ICR  10063
 ;    IX1^DIK             ICR  10013
 ;    IX2^DIK             ICR  10013
 ;    $$GET1^DIQ          ICR   2056
 ;    $$DT^XLFDT          ICR  10103
 ;    $$FMDIFF^XLFDT      ICR  10103
 ;    $$FMTE^XLFDT        ICR  10103
 ;    $$NOW^XLFDT         ICR  10103
 ;               
 ; Results Array
 ; 
 ;     LEXRES("FLC",FI)         Files Checked
 ;     LEXRES("FDC",(FI_FD))    Fields Checked
 ;     LEXRES("SFC",SF)         Sub-Fields Checked
 ;     LEXRES("FLE",FI)         Erant Files
 ;     LEXRES("FDE",(FI_FD))    Erant Fields
 ;     LEXRES("ERR")            Errors
 ;     
EN ; ICD-10 Files
 N I,ENV S ENV=$$ENV Q:+ENV'>0  D KG
 N MTO,ZTRTN,ZTDTH,ZTSAVE,ZTSK,ZTQUEUED,ZTREQ
 S ZTRTN="ICD10^ZZLEXXVB",ZTDESC="Load ICD FileMan Field Verify",ZTIO="",ZTDTH=$H
 S MTO=$$NAM I '$L(MTO) W !!,"  Unknown User (DUZ)",! Q
 W:$L($G(IOF)) @IOF
 W !!," FileMan Field Verify",!," ====================",!
 W !,"   FileMan will now check the fields in the IC* and Lexicon files for data"
 W !,"   content (required v.s. optional) and format (input transforms)",!
 W !,"   This could take a long time.  The results of this FileMan Verify will be"
 W !,"   mailed to the local IN box for ",MTO S ZTSAVE("MTO")=""
 S:$D(SUM) ZTSAVE("SUM")="" S:$D(TOTALS) ZTSAVE("TOTALS")=""
 D:'$D(BOTH) CONT D ERRC D:$D(TEST) @ZTRTN D:'$D(TEST) ^%ZTLOAD
 D HOME^%ZIS K Y,ZTSK,ZTDESC,ZTDTH,ZTIO,ZTRTN N BOTH
 Q
EN2(X) ; ICD-10 Files
 N I,ENV S ENV=$$ENV Q:+ENV'>0 "" D KG
 N MTO,ZTRTN,ZTDTH,ZTSAVE,ZTSK,ZTQUEUED,ZTREQ,LEX
 S ZTRTN="ICD10^ZZLEXXVB",ZTDESC="Load ICD FileMan Field Verify",ZTIO="",ZTDTH=$H
 S MTO=$$NAM Q:'$L(MTO) ""  S:$D(SUM) ZTSAVE("SUM")="" S:$D(TOTALS) ZTSAVE("TOTALS")=""
 D:$D(TEST) @ZTRTN D:'$D(TEST) ^%ZTLOAD S LEX=+($G(ZTSK)) D HOME^%ZIS
 K Y,ZTSK,ZTDESC,ZTDTH,ZTIO,ZTRTN S X="" S:+LEX>0 X=LEX
 Q X
TEST ; Test
 D BK N LEXTEST S LEXTEST=1 K LEXXX
 D START D KG S ^ZZLEXX("ZZLEXXV",$J,"VER")="",^ZZLEXX("ZZLEXXV",$J,"VER",0)=0
 N LEXBEG,LEXEND,REDO,LEXBEG,LEXEND,LEXELP,LEXRES,LEXT,FI,GL,GT S LEXBEG=$$HACK K LEXRES
 S LEXT="FileMan Verify of all "_"Lexicon/ICD/CPT files"
 S REDO=0
 ;   Coding Systems
 S FI=757.02 D
 . N I,LEXFLE  Q:FI>757.89999  D:+($G(ZTSK))>0 UPD(("Load ICD FileMan Field Verify (#"_FI_")"))
 . S LEXRES("FLC",FI)="" D FLH(FI) S LEXFLE=0 D SETUP,ALLFLDS^ZZLEXXVD(A,DIVRTYPE)
 . S:+LEXFLE>0 LEXRES("FLE",FI)=""
 W !! ZW LEXXX
 D CLEAN
 D FX
 Q
BK ;
 N DA,DIK
 S DA=5000044,DIK="^LEX(757.02," D IX2^DIK
 S ^LEX(757.02,5000044,0)="50000350^A05.3^30^5000036^1^^1"
 S ^LEX(757.02,5000044,4,1,0)="3151001^2"
 S DA=5000044,DIK="^LEX(757.02," D IX1^DIK
 S DA=1,DIK="^LEX(757.02," D IX2^DIK
 S ^LEX(757.02,1,0)="11111111^799.9^1^1^0^^1"
 S ^LEX(757.02,1,4,1,0)="2781001^2"
 S DA=1,DIK="^LEX(757.02," D IX1^DIK
 Q
FX ;
 N DA,DIK
 S DA=5000044,DIK="^LEX(757.02," D IX2^DIK
 S ^LEX(757.02,5000044,0)="5000035^A05.3^30^5000036^1^^1"
 S ^LEX(757.02,5000044,4,1,0)="3151001^1"
 S DA=5000044,DIK="^LEX(757.02," D IX1^DIK
 S DA=1,DIK="^LEX(757.02," D IX2^DIK
 S ^LEX(757.02,1,0)="1^799.9^1^1^0^^1"
 S ^LEX(757.02,1,4,1,0)="2781001^1"
 S DA=1,DIK="^LEX(757.02," D IX1^DIK
 Q
 S LEXEND=$$HACK,LEXELP=$$ELAP(LEXBEG,LEXEND)
 S:$L(LEXELP,":")=3&(LEXELP[" ") LEXELP=$TR(LEXELP," ","0") D:+($G(LEXRES("ERR")))>0 ERR
 D CLEAN,END^ZZLEXXVC(LEXBEG,LEXEND,LEXELP,.LEXRES,LEXT)
 S:$D(ZTQUEUED) ZTREQ="@" D STOP
 D KG,CLEAN
 Q
ICD10 ;   ICD-10 Files Tasked
 D START D KG S ^ZZLEXX("ZZLEXXV",$J,"VER")="",^ZZLEXX("ZZLEXXV",$J,"VER",0)=0
 N LEXBEG,LEXEND,REDO,LEXBEG,LEXEND,LEXELP,LEXRES,LEXT,FI,GL,GT S LEXBEG=$$HACK K LEXRES
 S LEXT="Load ICD-10 FileMan Verify" S REDO=0
 ;   Check Lexicon Only
 F FI=757,757.001,757.01,757.02,757.1 D
 . N I,LEXFLE  Q:FI>757.89999  D:+($G(ZTSK))>0 UPD(("Load ICD FileMan Field Verify (#"_FI_")"))
 . S LEXRES("FLC",FI)="" D FLH(FI) S LEXFLE=0 D SETUP,ALLFLDS^ZZLEXXVD(A,DIVRTYPE)
 . S:+LEXFLE>0 LEXRES("FLE",FI)=""
 D CLEAN
 ;   Check ICD Only
 F FI=80,80.1 D
 . N I,LEXFLE D:+($G(ZTSK))>0 UPD(("Load ICD FileMan Field Verify (#"_FI_")"))
 . S LEXRES("FLC",FI)="" D FLH(FI) S LEXFLE=0 D SETUP,ALLFLDS^ZZLEXXVD(A,DIVRTYPE)
 . S:+LEXFLE>0 LEXRES("FLE",FI)=""
 D CLEAN
 S LEXEND=$$HACK,LEXELP=$$ELAP(LEXBEG,LEXEND)
 S:$L(LEXELP,":")=3&(LEXELP[" ") LEXELP=$TR(LEXELP," ","0") D:+($G(LEXRES("ERR")))>0 ERR
 D CLEAN,END^ZZLEXXVC(LEXBEG,LEXEND,LEXELP,.LEXRES,LEXT)
 S:$D(ZTQUEUED) ZTREQ="@" D STOP
 D KG,CLEAN
 Q
 ;            
 ; Miscellaneous
FLH(X) ;   File Header
 N TXT S TXT=$$GT($G(X)) Q:'$L(TXT)  D BL,TL(TXT)
 S TXT="" S $P(TXT,"-",78)="-" D TL(TXT)
 Q
SETUP ;   Setup Variables for Field Verify
 K J S U="^",%=10,%H=$H,A=FI,C="RF",DI=FI,DIC="^DD(A,",DIC(0)="EZ"
 S DIC("S")="S %=$P(^(0),U,2) I %'=[""C"",$S('%:1,1:$P(^DD(+%,.01,0),U,2)'[""W"")"
 S DIC("W")="D:$P(^(0),U,2) AL^ZZLEXXVA(""  (multiple)"")"
 S DISYS=$P($G(^%ZOSF("OS")),"^",2) S:+DISYS'>0 DISYS=16
 S DIU=$$GL(FI),DIU(0)="EDT",I(0)=$$GL(FI),J(0)=FI,DIVRTYPE=""
 S (N,P,V)=0,Q="""",S=";",X="ALL",Y=1,Y(0)="YES"
 Q 
SHO ;   Show Global
 N NN,NC,JB S JB=$J S:'$D(^ZZLEXX("ZZLEXXV",JB)) JB=$O(^ZZLEXX("ZZLEXXV",0)) Q:+JB'>0
 S NN="^ZZLEXX(""ZZLEXXV"","_JB_",""VER"")",NC="^ZZLEXX(""ZZLEXXV"","_JB_",""VER"","
 W !! F  S NN=$Q(@NN) Q:'$L(NN)!(NN'[NC)  W:$P(NN,",",3)'="0)" !,@NN
 Q
CLEAN ;   Clean up Field Verify Variables
 K %,%DT,%H,A,C,DD,D0,D1,DA,DI,DIC,DIU,DIVRTYPE,DQ,DQI,DR,GL,GT,I,J,K,N,P,Q,S,V,X,Y,Z
 Q 
HACK(X) ;   Get Curent Time (NOW)
 S X=$$NOW^XLFDT Q X
ELAP(X,E) ;   Get Elapsed Time (B)ginning/(E)nding
 N ELP,FD,HR,MN,SC S ELP=$$FMDIFF^XLFDT(+($G(E)),+($G(X)),2)
 S FD=ELP\(60*60*24),ELP=ELP-(FD*60*60*24) S:+FD'>0 FD=""
 S HR=ELP\(60*60),ELP=ELP-(HR*60*60) S HR=$J("",(2-$L(HR)))_HR,HR=$TR(HR," ","0")
 S MN=ELP\60,ELP=ELP-(MN*60) S MN=$J("",(2-$L(MN)))_MN,MN=$TR(MN," ","0")
 S SC=ELP S SC=$J("",(2-$L(SC)))_SC,SC=$TR(SC," ","0")
 S X="" S:$L(FD) X=FD_$S(+FD>1:"days ",1:"day ") S X=X_HR_":"_MN_":"_SC
 Q X
BL ;   Blank Line
 N REF X "S REF=$ZR" D TL(" ") S:$L(REF) REF=$D(@REF)
 Q
TL(LEX) ;   Text Line
 N LEXX,LEXY,REF X "S REF=$ZR" S LEXX=$G(LEX) S LEXY=$O(^ZZLEXX("ZZLEXXV",$J,"VER"," "),-1)+1
 S ^ZZLEXX("ZZLEXXV",$J,"VER",+LEXY)=LEXX,^ZZLEXX("ZZLEXXV",$J,"VER",0)=+LEXY
 S:$L(REF) REF=$D(@REF)
 Q
LD(X) ;   Long Date
 S X=$$FMTE^XLFDT($G(X),1),X=$P(X,"@",1)_"  "_$P(X,"@",2) Q X
LDTT(X) ;   Long Date and Time
 Q $TR($$FMTE^XLFDT($G(X),"5Z"),"@"," ")
TIM(X) ;   Short Date and Time
 W $TR($$FMTE^XLFDT(X,"5Z"),"@"," ")
 Q
GT(X) ;   Global Title
 N GL,GN,FI S FI=+($G(X)) Q:+FI'>0 ""  S X=$$GL(FI) Q:'$L(X) X
 S GN=$$GN(FI) Q:'$L(GN) X  F  Q:$L(X)>39  S X=X_" "
 S X=X_GN_" (#"_FI_")" Q X
GL(X) ;   Global Location
 Q $G(@("^DIC("_+($G(X))_",0,""GL"")"))
GN(X) ;   Global Name
 Q $P($G(@("^DIC("_+($G(X))_",0)")),"^",1)
START ;  Start FileMan Verify
 D KG,INIT
 Q
STOP ;  Stop FileMan Verify
 D KG S:$D(ZTQUEUED) ZTREQ="@"
 Q
ERRC ;   Error Clear
 Q
ERR ;   Error
 N LEXE S LEXE=+($G(LEXRES("ERR")))
 Q
TRIM(X) ;   Trim Spaces
 S X=$G(X) Q:X="" X F  Q:$E(X,1)'=" "  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=" "  S X=$E(X,1,($L(X)-1))
 F  Q:X'["  "  S X=$P(X,"  ",1)_" "_$P(X,"  ",2,229)
 Q X
CONT ;   Continue
 N ANS W !!,"    Press <Enter> to continue" R ANS:300 W # Q
CLR ;   Clear Environment
 K SOME,SUM,TOTALS,ZTQUEUED,ZTREQ,ZTSAVE N TEST
 Q
KG ;   Kill Temporary Globals
 N GBL S GBL="^UTILITY(""DIVR"","_$J_")" K @GBL
 K ^ZZLEXX("ZZLEXXV",$J,"VER"),^ZZLEXX("ZZLEXXV",$J,"MSG")
 K ^TMP("DIVR1",$J),^TMP("DIKK",$J)
 Q
ENV(X) ;   Environment
 D HOME^%ZIS S U="^",DT=$$DT^XLFDT,DTIME=300 K POP
 N NM S NM=$$GET1^DIQ(200,(DUZ_","),.01)
 I '$L(NM) W !!,?5,"Invalid/Missing DUZ" Q 0
 S:$G(DUZ(0))'["@" DUZ(0)=$G(DUZ(0))_"@"
 Q 1
NAM(X) ;   Name
 Q $$GET1^DIQ(200,(+($G(DUZ))_","),.01)
INIT ;   Initialize
 Q
UPD(X) ;   Update
 Q:'$D(ZTSK)  Q:+($G(ZTSK))'>0
 Q:'$L($G(@("^%ZTSK("_+($G(ZTSK))_",.03)")))
 S:'$L($G(X)) X="FileMan Field Verify IC*/Lexicon"
 S @("^%ZTSK("_+($G(ZTSK))_",.03)")=$G(X) N ZTSK,DISYS
 Q
