ZZLEXXVD ;SLC/KER - Import - FileMan Verify (DIV) ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^%ZTSK              None
 ;    ^DD(                None
 ;    ^DIBT(              None
 ;    ^DIC(               None
 ;    ^ZZLEXX("ZZLEXXV"   SACC 1.3
 ;    ^UTILITY("DIVR"     None
 ;               
 ; External References
 ;    ^%ZIS               ICR  10086
 ;    ^%ZTLOAD            ICR  10063
 ;    ^DIC                ICR  10006
 ;    ^DIR                ICR  10026
 ;               
 ; Local Variables NEWed or KILLed Elsewhere
 ;     DIC,DIU,LEXFLE,LEXRES,Q,S,ZTDESC,ZTRTN,ZTSAVE
 ;               
 N DIUTIL,DIVDAT,DIVFIL,DIVMODE,DIVPG,POP S DIUTIL="VERIFY FIELDS" K J
 S V=0,P=0,I(0)=DIU,@("(A,J(0))=+$P("_DIU_"0),U,2)")
 I $O(^(0))'>0 W $C(7),"  NO ENTRIES ON FILE!" Q
DIC ; Lookup
 S DIC="^DD("_A_",",DIC(0)="QEZ",DIC("W")="W:$P(^(0),U,2) ""  (multiple)"""
 S DIC("S")="S %=$P(^(0),U,2) I %'[""C"",$S('%:1,1:$P(^DD(+%,.01,0),U,2)'[""W"")"
 W !,"VERIFY WHICH "_$P(^DD(A,0),U)_": " R X:DTIME Q:U[X
 I X="ALL" D ALL G Q:$D(DIRUT) I Y S DIVMODE="A" D DEVSEL G:$G(POP) Q D INIT,ALLFLDS(A) G Q^ZZLEXXVF:DQI'>0!$D(DIRUT)
 D ^DIC K DQI,^UTILITY("DIVR",$J)
 I Y<0 W:X?1."?" !?3,"You may enter ALL to verify every field at this level of the file.",! G DIC
 S DR=$P(Y(0),U,2) I DR S J(V)=A,P=+Y,V=V+1,A=+DR,I(V)=$P($P(Y(0),U,4),";") S:+I(V)'=I(V) I(V)=""""_I(V)_"""" G DIC
 D DEVSEL G:$G(POP) Q D INIT
 D EN^ZZLEXXVF(A,+Y)
Q ; Quit Lookup
 K DIR,DIRUT,N,P
 Q
ALL ; All Fields in the File?
 S DIR(0)="Y",DIR("??")="^D H^ZZLEXXVD"
 S DIR("A")="DO YOU MEAN ALL THE FIELDS IN THE FILE"
 D ^DIR K DIR S X="ALL"
 Q
ALLPOINT ; Pointers
 N A,DIRUT D DEVSEL Q:$G(POP)
 F A=1.9:0 S A=$O(^DIC(A)) Q:'A  D INIT,ALLFLDS(A,"PV") Q:$D(DIRUT)
 Q
ALLFLDS(A,DIVRTYPE) ; All Fields
 I $D(^DD(+($G(A)),0,"UP")),+($G(A))>0 S LEXRES("SFC",+A)=""
 N FLERR,TOTERR,FD S FLERR=0
 S DQI=0 F  S DQI=$O(^DD(A,DQI)) Q:DQI'>0  S Y=DQI,Y(0)=^(Y,0),DR=$P(Y(0),U,2) D  Q:$D(DIRUT)
 . S LEXRES("FDC",(A_" "_DQI))=""
 . I DR Q:$P(^DD(+DR,.01,0),U,2)["W"  D NEXTLVL Q
 . I $G(DIVRTYPE)]"",$TR(DR,DIVRTYPE)=DR Q
 . I DR["C" Q
 . N FDERR S FDERR=0 K ^UTILITY("DIVR",$J)
 . D EN^ZZLEXXVF(A,Y,1)
 . S:+FDERR>0 LEXFLE=1,LEXRES("FDE",(A_" "_DQI))=""
 . D:+FDERR'>0 OK
 Q
NEXTLVL ; Next Level (sub-file)
 N A,P,DE,DA,DQI,I,J,V S DQI=0
 S A=+DR,P=+Y N Y,DR D IJ^ZZLEXXVI(A)
 D ALLFLDS(A,$G(DIVRTYPE))
 Q
H ; Help
 W !!?5,"YES means that every field at this level in the file will"
 W !?5,"be checked to see if it conforms to the input transform."
 W !!?5,"NO means that ALL will be used to lookup a field in the"
 W !?5,"file which begins with the letters ALL, e.g., ALLERGIES."
 Q
FLH ; File Header
 N FI,GL,NM,TXT S FI=$G(X) Q:+FI'>0  Q:'$D(^DIC(+FI,0,"GL"))
 S NM=$P($G(^DIC(FI,0)),"^",1),GL=$G(^DIC(+FI,0,"GL"))
 S TXT=GL,TXT=TXT_$J(" ",(40-$L(TXT)))_NM_" (#"_FI_")" D TL(TXT)
 S TXT="" S $P(TXT,"-",79)="-" D TL(TXT)
 Q
DIVROUT ; DIVR Out
 I $G(DIVROUT)="" D X Q
 I $E($G(DIVROUT))="[" D  Q
 . N Y,COUNT,Z
 . D DIBT^ZZLEXXVI($G(DIVROUT),.Y,$G(DIVRFI0)) Q:Y'>0
 . K ^DIBT(+Y,1)
 . S (COUNT,Z)=0
 . F  S Z=$O(^TMP("DIVR1",$J,Z)) Q:Z=""  S COUNT=COUNT+1,^DIBT(+Y,1,Z)=""
 . I COUNT S ^DIBT(+Y,"QR")=DT_U_COUNT
 . D X
 M @DIVROUT@(1)=^TMP("DIVR1",$J)
X ; Kill ^TMP
 K ^TMP("DIVR1",$J)
 Q
INIT ; Get header info and print first header
 N DIVRFI0,DIVROUT K DIRUT I $D(^DIC(A,0))#2 S DIVFIL=$P(^(0),U)_" FILE (#"_A_")"
 E  I $D(^DD(A,0,"NM")) S DIVFIL=$O(^("NM",""))_" SUB-FILE (#"_A_")"
 E  S DIVFIL=""
 Q
DEVSEL ; Prompt for device
 D  Q:$G(POP)
 . N %ZIS,A,I,J,T,V,X,Y,Z
 . S %ZIS=$E("Q",$D(^%ZTSK)>0)
 . W ! D ^%ZIS
 I $D(IO("Q")),$D(^%ZTSK) D  S POP=1
 . S ZTRTN="ENQUEUE^ZZLEXXVD"
 . S ZTDESC="Verify Fields Report for File #"_A
 . N %,DIVA,DIVI,DIVJ,DIVT,DIVV,DIVY,DIVZ
 . M DIVA=A,DIVI=I,DIVJ=J,DIVT=T,DIVV=V,DIVY=Y,DIVZ=Z
 . F %="DIU","DIUTIL","DIVMODE","DIVA","DIVI","DIVI(","DIVJ","DIVJ(","DIVV","DIVZ" S ZTSAVE(%)=""
 . I $G(DIVMODE)'="A" F %="DIVY","DIVY(","DR" S ZTSAVE(%)=""
 . I $G(DIVMODE)="C" F %="DA","DDC","DIFLD","DIVT" S ZTSAVE(%)=""
 . D ^%ZTLOAD
 . I $D(ZTSK)#2 W !,"Report queued!",!,"Task number: "_$G(ZTSK),!
 . E  W !,"Report canceled!",!
 . K ZTSK
 . S IOP="HOME" D ^%ZIS
 Q
ENQUEUE ; Entry point for queued reports
 M A=DIVA,I=DIVI,J=DIVJ,T=DIVT,V=DIVV,Y=DIVY,Z=DIVZ
 K DIVA,DIVI,DIVJ,DIVT,DIVV,DIVY,DIVZ
 S Q="""",S=";"
 D INIT I $G(DIVMODE)="A" D ALLFLDS(A),Q^ZZLEXXVF Q
 I $G(DIVMODE)="C" D EN^ZZLEXXVF(A,DA) Q
 D EN^ZZLEXXVF(A,+Y)
 Q
BL ; Blank Line
 N REF X "S REF=$ZR" D TL(" ")
 S:$L(REF) REF=$D(@REF)
 Q
TL(LEX) ; Text Line
 N LEXX,LEXY,REF X "S REF=$ZR" S LEXX=$G(LEX) S LEXY=$O(^ZZLEXX("ZZLEXXV",$J,"VER"," "),-1)+1
 S ^ZZLEXX("ZZLEXXV",$J,"VER",+LEXY)=LEXX,^ZZLEXX("ZZLEXXV",$J,"VER",0)=+LEXY
 S:$L(REF) REF=$D(@REF)
 Q
OK ; Ok
 N LEXX,LEXY S LEXY=$O(^ZZLEXX("ZZLEXXV",$J,"VER"," "),-1) Q:+LEXY'>0
 S LEXX=$G(^ZZLEXX("ZZLEXXV",$J,"VER",+LEXY)) Q:$E(LEXX,1,2)'="  "
 S LEXX=$E(LEXX,1,75),LEXX=LEXX_$J(" ",(76-$L(LEXX)))_"OK"
 S ^ZZLEXX("ZZLEXXV",$J,"VER",+LEXY)=LEXX
 Q
