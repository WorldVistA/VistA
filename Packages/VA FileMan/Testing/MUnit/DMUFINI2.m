DMUFINI2 ; ; 10-JAN-2013 ; 1/27/13 3:48pm
 ;;22.2;VA FILEMAN;;Mar 28, 2013
 ;Per VHA Directive 2004-038, this routine should not be modified.
 ;
 ;
 K ^UTILITY("DIFROM",$J),DIC S DIDUZ=0 S:$D(DUZ)#2 DIDUZ=DUZ S DUZ=.5
 I $D(^DIC(9.2,0))#2,^(0)?1"HEL".E S (DIC,DLAYGO)=9.2,N="HEL",DIC(0)="LX" G ADD
 Q
 ;
ADD F R=0:0 S R=$O(^UTILITY(U,$J,N,R)) Q:R'>0  S X=$P(^(R,0),U,1) W "." K DA D ^DIC I Y>0,'$D(DIFQ(N))!$P(Y,U,3) S ^UTILITY("DIFROM",$J,N,X)=+Y K ^DIC(9.2,+Y,1),^(2),^(3),^(10) S %X="^UTILITY(U,$J,N,R,",%Y=DIC_"+Y,",DA=+Y D %XY^%RCR
 S DIK=DIC
HELP S R=$O(^UTILITY("DIFROM",$J,N,R)) Q:R=""  W !,"'"_R_"' Help Frame filed." S DA=^(R)
 F X=0:0 S X=$O(^DIC(9.2,DA,2,X)) Q:'X  S I=$S($D(^(X,0)):^(0),1:0),Y=$P(I,U,2) S:Y]"" Y=$O(^DIC(9.2,"B",Y,0)) S ^(0)=$P(^DIC(9.2,DA,2,X,0),U,1)_U_$S(Y>0:Y,1:"")_U_$P(^(0),U,3,99)
 S I=0 F X=0:0 S X=$O(^DIC(9.2,DA,10,X)) Q:'X  I $D(^(X,0)) S Y=$P(^(0),U),Y=$S(Y]"":$O(^MAG("B",Y,0)),1:0) S:Y $P(^DIC(9.2,DA,10,X,0),U)=Y,I=I+1,%=X I 'Y K ^DIC(9.2,DA,10,X,0)
 I I S $P(^DIC(9.2,DA,10,0),U,3,4)=%_U_I
IX D IX1^DIK G HELP
 ;
U I $D(DIRUT) S DIFQ=1
 W ! Q
REP S DIR(0)="Y",DIR("A")="Shall I change the NAME of the file to "_DIF
 S DIR("??")="^D REP^DIFROMH1",DIR("B")="NO" D ^DIR G U:$D(DIRUT)
 I Y S DIE=1,DIFQ=0,DA=N,DR=".01////"_DIF D ^DIE Q
 S DIR("A")="Shall I replace your file with mine"
 S DIR("??")="^D AG^DIFROMH1" D ^DIR G U:$D(DIRUT)!'Y
 S DIU(0)="E",DIR("A")="Do you want to keep the Data"
 S DIR("??")="^D CHG^DIFROMH1" D ^DIR G U:$D(DIRUT)
 S:'Y DIU(0)=DIU(0)_"D"
 S DIR("A")="Do you want to keep the Templates"
 S DIR("??")="^D TEMP^DIFROMH1" D ^DIR G U:$D(DIRUT) S:'Y DIU(0)=DIU(0)_"T"
 S DIFQ(N)=1,DIFKEP(N)=DIU(0) W !?15," (",DIF,") " Q
