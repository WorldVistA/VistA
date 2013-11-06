DMUFINI3 ; ; 10-JAN-2013 ; 1/27/13 3:48pm
 ;;22.2;VA FILEMAN;;Mar 28, 2013
 ;Per VHA Directive 2004-038, this routine should not be modified.
 ;
 ;
 K ^UTILITY("DIFROM",$J) S DIC(0)="LX",(DIC,DLAYGO)=3.6,N="BUL" D ADD:$D(^XMB(3.6,0))
 S X=0 F R=0:0 S X=$O(^UTILITY("DIFROM",$J,N,X)) Q:X=""  W !,"'",X,"' BULLETIN FILED -- Remember to add mail groups for new bulletins."
 I $D(^DIC(9.4,0))#2,^(0)?1"PACK".E S N="PKG",(DIC,DLAYGO)=9.4 D ADD
 G NP:'$D(DA) S %=+$O(^DIC(9.4,DA,22,"B",DIFROM,0)) I $D(^DIC(9.4,DA,22,%,0)) S $P(^(0),U,3)=DT
 I $D(^DIC(9.4,DA,0))#2 S %=$P(^(0),U,4) I %]"" S %=$O(^DIC(9.2,"B",%,0)) S:%]"" $P(^DIC(9.4,DA,0),U,4)=%
OR I $D(^ORD(100.99))&$O(^UTILITY(U,$J,"OR","")) D EN^DMUFINI4
NP K DIC,^UTILITY("DIFROM",$J) S DIC(0)="LX" I $D(^DIC(19,0))#2,^(0)?1"OPTION".E S (DIC,DLAYGO)=19,N="OPT" D ADD,OP
 I $D(^DIC(19.1,0))#2,($P(^(0),U)?1"SECUR".E)!($P(^(0),U)="KEY") S (DIC,DLAYGO)=19.1,N="KEY" D ADD K ^UTILITY("DIFROM",$J)
 I $D(^DIC(9.8,0))#2,^(0)?1"ROUTINE^".E S (DIC,DLAYGO)=9.8,N="RTN" D ADD
 S DIC=.5,DLAYGO=0,N="FUN" D ADD
 I $P($G(^DIC(8994,0)),U)="REMOTE PROCEDURE" S (DIC,DLAYGO)=8994,N="REM" D ADD
 S DIC("S")="I $P(^(0),U,4)=DIFL" F N="DIPT","DIBT","DIE" S DIC=U_N_"(" D ADD
 K DIC("S") S N="DIST(.404,",DIC=U_N,DLAYGO=.404 D ADD
 S DIC("S")="I $P(^(0),U,8)=DIFL",N="DIST(.403,",DIC=U_N,DLAYGO=.403 D ADD
 K ^UTILITY(U,$J),DIC,DLAYGO F DIFR="DIE","DIPT" D DIEZ
 K ^UTILITY("DIFROM",$J) Q
DIEZ I ^DD("VERSION")>17.4,'$D(DISYS) D OS^DII
 E  S DISYS=^DD("OS")
 Q:'$D(^DD("OS",DISYS,"ZS"))
 S DIFR1=""
DZ1 S DIFR1=$O(^UTILITY("DIFROM",$J,DIFR,DIFR1)) Q:DIFR1=""
 F DIFR2=0:0 S DIFR2=$O(^UTILITY("DIFROM",$J,DIFR,DIFR1,DIFR2)) Q:'DIFR2  S Y=DIFR2 I $D(@(U_DIFR_"(Y,""ROU"")")) K ^("ROU") I $D(^("ROUOLD")) S X=^("ROUOLD"),DMAX=^DD("ROU") D:X]"" @("EN^DI"_$E(DIFR,3)_"Z")
 G DZ1
 ;
OP S R=$O(^UTILITY("DIFROM",$J,N,R)) I R="" K ^UTILITY("DIFROM",$J) G Q
 W !,"'"_R_"' Option Filed" S DA=+^UTILITY("DIFROM",$J,N,R) G:$P(^(R),U,2,3)="XUCORE^"!($P(^(R),U,2,3)="XUCOMMAND^") OP
 I $D(^DIC(19,DA,220)) S %=$P(^(220),U) S:%]"" %=$O(^XMB(3.6,"B",%,0)) S $P(^DIC(19,DA,220),U)=%,%=$P(^(220),U,3) S:%]"" %=$O(^XMB(3.8,"B",%,0)) S $P(^DIC(19,DA,220),U,3)=%
 S %=$P(^DIC(19,DA,0),U,12) S:%]"" %=$O(^DIC(9.4,"B",%,0))
 S $P(^DIC(19,DA,0),U,12)=%,%=$P(^(0),U,7),(DZ,DIX)=0
 D:$D(^DIC(19,DA,10,"B")) KAD(DA) S:%]"" %=$O(^DIC(9.2,"B",%,0)) S $P(^DIC(19,DA,0),U,7)=%,%=$P(^(0),U,4),%="MOQXL"[% K ^(10,"B"),^("C")
 F X=0:0 S X=$O(^DIC(19,DA,10,X)) Q:'X  S I=$S($D(^(X,0)):^(0),1:0),Y=$S($D(^(U)):^(U),1:"") K ^DIC(19,DA,10,X) I Y]"",% S D=$O(^DIC(19,"B",Y,0)) I D S ^DIC(19,DA,10,X,0)=D_U_$P(I,U,2,9),DZ=DZ+1,DIX=X
 S:% ^DIC(19,DA,10,0)="^19.01PI^"_DIX_U_DZ D IX1^DIK G OP
 ;
ADD F R=0:0 S R=$O(^UTILITY(U,$J,N,R)) Q:R=""  S X=$P(^(R,0),U),DIFL=$S(N="DIST(.403,":$P(^(0),U,8),N="DIST(.404,":$P(^(0),U,2),1:$P(^(0),U,4)) W "." K DA D ^DIC I Y>0,'$D(DIFQ($E(N,1,3)))!$P(Y,U,3) S Y=Y_U D A
Q Q
A I N="BUL" K % S %(0)=$G(@(DIC_"+Y,2,0)")) F %=0:0 S %=$O(@(DIC_"+Y,2,%)")) Q:'%  S %(%)=$G(^(%,0))
 K:N'="KEY"&(N'="OPT") @(DIC_"+Y)") S ^UTILITY("DIFROM",$J,N,X)=Y S:$E(N,1,2)="DI" ^(X,+Y)="" S:N="PKG" DIFROM(0)=+Y Q:$P(Y,U,2,3)="XUCORE^"!($P(Y,U,2,3)="XUCOMMAND^")
 I N="BUL",%(0)]"" S @(DIC_"+Y,2,0)")=%(0) F %=0:0 S %=$O(%(%)) Q:'%  S @(DIC_"+Y,2,%,0)")=%(%)
 I $E(N,1,2)="DI",('DIFL)!('$D(^DD(+DIFL))) D
 .W !,"**WARNING--"_$S(N="DIE":"INPUT",N="DIPT":"PRINT",N="DIBT":"SORT",1:"FORM or BLOCK")_$S(N'["DIST":" template ",1:" ")_$P(Y,U,2)_" has been installed,",!,"but associated file "_DIFL_" is not on your system!"
 .Q
 I N="OPT" S:$P(^DIC(19,+Y,0),U,6)]"" DIOPT=$P(^(0),U,6) I $O(^UTILITY(U,$J,N,R,1,0)) K ^DIC(19,+Y,1)
 I N="DIST(.403," D BLK
 S %X="^UTILITY(U,$J,N,R,",%Y=DIC_"+Y,",DA=+Y,DIK=DIC D %XY^%RCR
 D IX1^DIK:N'="OPT" I N="OPT",$D(DIOPT) S:$P(^DIC(19,DA,0),U,6)="" $P(^(0),U,6)=DIOPT K DIOPT
 I N="DIST(.403," D
 .N DIFRVAL S DIFRVAL=$$VAL^DIFROMSS(.403,DA)
 .I DIFRVAL W !,"Compiling form: ",$P(^DIST(.403,DA,0),U) D EN^DDSZ(DA) Q
 .W !,"ERROR: Form: ",$P(^DIST(.403,DA,0),U)," cannot be compiled"
 .Q
 Q
BLK F J=0:0 S J=$O(^UTILITY(U,$J,N,R,40,J)) Q:'J  I $D(^(J,0)) S %=$P(^(0),U,2) S:%]"" %=$O(^DIST(.404,"B",%,0)) S:% $P(^UTILITY(U,$J,N,R,40,J,0),U,2)=% D B1
 K A0,A1,A2,J,L Q
B1 F L=0:0 S L=$O(^UTILITY(U,$J,N,R,40,J,40,L)) Q:'L  S A0=$G(^(L,0)),%=$P(A0,U) I %]"" S %=$O(^DIST(.404,"B",%,0)) I % S $P(A0,U)=%,^UTILITY(U,$J,N,R,40,J,"BLK",%,0)=A0 D
 .N X S X=0
 .F  S X=$O(^UTILITY(U,$J,N,R,40,J,40,L,X)) Q:X=""  S ^UTILITY(U,$J,N,R,40,J,"BLK",%,X)=^(X)
 .Q
 S A0=$G(^UTILITY(U,$J,N,R,40,J,40,0)) Q:A0=""  K ^UTILITY(U,$J,N,R,40,J,40) S (A1,A2)=0
 F L=0:0 S L=$O(^UTILITY(U,$J,N,R,40,J,"BLK",L)) Q:'L  S ^UTILITY(U,$J,N,R,40,J,40,L,0)=^(L,0),A1=L,A2=A2+1 D
 .N X S X=0
 .F  S X=$O(^UTILITY(U,$J,N,R,40,J,"BLK",L,X)) Q:X=""  S ^UTILITY(U,$J,N,R,40,J,40,L,X)=^(X)
 .Q
 S $P(A0,U,3,4)=A1_U_A2,^UTILITY(U,$J,N,R,40,J,40,0)=A0 K ^UTILITY(U,$J,N,R,40,J,"BLK")
 Q
KAD(D0) N D1,X
 S X=0 F  S X=$O(^DIC(19,D0,10,"B",X)) Q:X'>0  S D1=0 F  S D1=$O(^DIC(19,D0,10,"B",X,D1)) Q:D1'>0  K ^DIC(19,"AD",X,D0,D1)
 Q
