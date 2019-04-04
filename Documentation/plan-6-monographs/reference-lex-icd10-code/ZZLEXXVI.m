ZZLEXXVI ;SLC/KER - Import - FileMan Verify (DIVU) ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^DD(                None
 ;    ^DIBT(              None
 ;    ^DIBT("CANONIC"     None
 ;    ^DIBT("F"           None
 ;    ^DIC(               None
 ;               
 ; External References
 ;    NOW^%DTC            ICR  10000
 ;    ^DIC                ICR  10006
 ;    IX^DIC              ICR  10006
 ;    ^DIE                ICR  10018
 ;    ^DIR                ICR  10026
 ;               
 ; Local Variables NEWed or KILLed Elsewhere
 ;     DIBT,DISV
 ;               
 Q
DE(FI,FD,N,G,S) ; 
 Q:'$D(^DD($G(FI),0))  I $G(FD) Q:'$D(^(FD,0))
 I $G(G)']"" S G="DE"
 N Z,X,Y,%,H,D,I,J,V,K
 I $G(^DIC(FI,0))]"" S I(0)=^(0,"GL"),J(0)=+FI,V=0
 E  D IJ(FI)
 S Y=I(0),X=V,H="",Z=0
 I +$G(S),V S S=$S('$P(S,U,2):V,1:$P(S,U,2)) S Z=S,X=X-S F %=0:1 S Y=Y_"D"_%_","_I(%+1)_","  I %=(S-1) Q
L ; Level
 S D="D" S D=D_Z S Y=Y_D,H=H_"S "_D_"=0 F  ",%="S "_D_"=$O("_Y_"))" I V>1 S @G@(Z)=%,H=H_"X "_G_"("_(Z)_")"
 E  S H=H_%
 S H=H_" Q:"_D_"'>0  "
 S X=X-1,Z=Z+1
L1 ; Level 1
 I X<0 D  Q
 .I $G(N)]"",$G(FD)]"" D  S H=H_" X "_G_"(99)",@G=H,@G@(99)=Y Q
 . . N DN,%,%N,%P,%4,Q
 . . S Q=";",%=^DD(FI,FD,0),%(2)=$G(^(2)),%4=$P(%,U,4),%N=$P(%4,Q),%P=$P(%4,Q,2)
 . . I FD=.001,%P="" S Y="S "_N_"=D"_V Q
 . . I %P=" " D CAL Q
 . . I $G(%P)]"" S Y=Y_","_%N_")"
 . . I %P S DN="$P(",%P="),U,"_%P_")"
 . . I $E(%P)="E" S DN="$E(",%P="),"_$E(%P,2,9)_")"
 . . I $G(DN)="" Q
 . . S Y="S "_N_"="_DN_"$G("_Y_%P
 . . I %(2)]"",$P(%,U,2)["O",$P(%,U,2)'["D" S Y=Y_",Y="_N_" "_%(2)_" S "_N_"=Y"
 . . Q
 . S @G=H Q
 S Y=Y_","_I(V-X)_"," G L
 ;
CAL ;
 S Y=$P(%,U,5,99)_" S "_N_"=X" Q
 Q
IJ(FI) ; Set I( and J( and V=level
 Q:'$D(^DD($G(FI),0))
 N X,Y,S,Q,F S X=0,(S,Y)=FI,Q="""" F  Q:'$D(^DD(Y,0,"UP"))  S X=X+1,Y=^("UP")
 S V=X I X'=0 F X=X:-1 S Y=$G(^DD(S,0,"UP")) Q:'Y  S F=$O(^DD(Y,"SB",S,0)) Q:'F  S I(X)=$P($P($G(^DD(Y,F,0)),U,4),";"),K(X)=$O(^DD(S,0,"NM","")),J(X)=S,S=Y S:I(X)'=+I(X) I(X)=Q_I(X)_Q
 S I(0)=$G(^DIC(S,0,"GL")),J(0)=S
 Q
DA(Z) ; Convert D0,D1... to DA()
 N A,B,C,D K Z
 F A=0:1 S D="D"_A Q:'$D(@D)
 S C=0,A=A-1 F B=A:-1:0 S Z(B)=@("D"_C),C=C+1
 S Z=Z(0) K Z(0)
 Q
DIBT(X,%,S) ; Lookup sort template, return template's IEN
 N DIC,Y
 S X=$E(X,2,$L(X)-1),DIC="^DIBT(",DIC("S")="I $P(^(0),U,4)="_S,DIC(0)="ZM" D ^DIC
 S %=+Y
 Q
LABEL(FILE,FIELD) ; Called many places to return the foreign-language FIELD NAME
 N N
 S N=$P($G(^DD(FILE,FIELD,0)),"^") I N="" Q N
 I $P(^(0),"^",2)["W",$G(^DD(FILE,0,"UP")) Q $$LABEL(^("UP"),$O(^DD(^("UP"),"SB",FILE,0)))
 I $G(DUZ("LANG")),$D(^(.008,DUZ("LANG"),0))#2 Q ^(0)
 Q N
S2 ; Save #2
 K DIR S DIR(0)="O",DIR("A")="STORE THESE ENTRY ID'S IN TEMPLATE",DIR("?")="^D H2^DIBT1"
 D SAV Q:$D(DIRUT)  D MRG Q
SAV ; Save
 S DIR(0)="F"_DIR(0)_"^1,30"
 D ^DIR K DIR Q:$D(DIRUT)
 I $E(X)="[" S X=$P($E(X,2,99),"]",1)
 Q
MRG ; Merge
 S DIBT1=1
DIC ; Lookup Template
 K DIC S DIC="^DIBT(",DLAYGO=0,DIC(0)="QELSZ",DIOVRD=1,DIC("S")="I "_$S($D(DIAR)&('$D(DIARI)):"",1:"'")_"$P(^(0),U,8)"
 S DIC("S")=DIC("S")_",$P(^(0),U,4)=DK,$P(^(0),U,5)=DUZ!'$P(^(0),U,5)!$D(DIEDT)",D="F"_DK
 D IX^DIC S DIBTY=Y K DIC,DLAYGO,DIEDT,DIOVRD G QDIC:Y'>0
 N X,DIBTSEC S DIBTSEC="" I $O(^DIBT(+Y,0))]"" S DIBTSEC=Y(0) D ALR
 I $D(DIRUT)!(Y'>0) G QDIC
 D NOW^%DTC
 S ^DIBT("F"_DK,$P(Y,U,2),+Y)=1,^DIBT(+Y,0)=$P(Y,U,2)_U_+$J(%,0,4)_U_$S(DIBTSEC]"":$P(DIBTSEC,U,3),1:DUZ(0))_U_DK_U_DUZ_U_$S(DIBTSEC]"":$P(DIBTSEC,U,6),1:DUZ(0)) I $D(DIAR),'$D(DIARI) S $P(^(0),U,8)=1
 K DIBTSEC N DIE,DA,DI,DK,DR,Y S DIE="^DIBT(",DA=+DIBTY,DR=10,DIOVRD=1 D ^DIE K DUOUT,DIROUT,DIRUT N DIAR,DIARI
QDIC ; Quit DIC
 K DIBT1,DIBTY,DIOVRD,%,%X,%Y Q
ALR ; Alert
 W !,$C(7) I $D(DIBT),+Y=DIBT W "NO!! YOU ARE USING THAT TEMPLATE FOR YOUR LIST OF ENTRIES!" S Y=-1 Q
 I $D(DISV),+Y=DISV W "NO!! YOU ARE GOING TO STORE SEARCH RESULTS IN THAT TEMPLATE!" S Y=-1 Q
 N DIR S DIR(0)="Y",DIR("B")="NO",DIR("A")="DATA ALREADY STORED THERE....OK TO PURGE" D ^DIR Q:$D(DIRUT)
CLN ; Clean out the Template
 I Y=1 D  S Y=DIBTY Q
 .N F S %Y="",F=+$P($G(^DIBT(+DIBTY,0)),U,4) K ^DIBT("CANONIC",F,+DIBTY)
 .F  S %Y=$O(^DIBT(+DIBTY,%Y)) Q:%Y=""  I %Y'="%D",%Y'="ROU",%Y'="ROUOLD",%Y'="DIPT" K ^DIBT(+DIBTY,%Y)
 .Q
 S %Y=-1 I $O(^DIBT(+DIBTY,1,0))'>0!'$D(DIBT1) S Y=-1 Q
 F %=0:0 S %=$O(^(%)),%Y=%Y+1 Q:%'>0
 K DIR S DIR(0)="Y",DIR("B")="NO",DIR("A",1)="WANT TO MERGE THESE ENTRIES",DIR("A")="WITH THE "_%Y_" ALREADY IN '"_$P(DIBTY,U,2)_"' TEMPLATE"
 D ^DIR S Y=$S(Y=0:-1,1:DIBTY) W ! Q
