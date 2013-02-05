DMUFINI4 ; ; 10-JAN-2013
 ;;0.1;FILEMAN EXTENSIONS FILES;;JAN 10, 2013
 ;
 ;
EN S DA(1)=1,DIK="^ORD(100.99,1,5," I $D(^ORD(100.99,1,5,DA)) D ^DIK
 S %X="^UTILITY(U,$J,""OR"","_$O(^UTILITY(U,$J,"OR",""))_",",%Y=DIK_DA_","
 S:'$D(^ORD(100.99,1,5,0)) ^(0)="^100.995P^^" S $P(^(0),U,3,4)=DA_U_($P(^(0),U,4)+1)
 D %XY^%RCR S $P(^ORD(100.99,1,5,DA,0),U)=DA,%=$P(^(0),U,4)
 I %]"" S %=$O(^ORD(100.98,"B",%,0)) I %>0 S $P(^ORD(100.99,1,5,DA,0),U,4)=%
 D OR
 S DA(1)=1 D IX1^DIK
 Q
OR S (N,I)=0,X=""
 F  S N=$O(^ORD(100.99,1,5,DA,1,N)) Q:'N  S X=$P(^(N,0),U) I X]"" S %=$O(^ORD(101,"B",X,0)) D:'% ADDP S:% ^ORD(100.99,1,5,DA,1,N,0)=% S X=N,I=I+1,(R,J)=0,Y="" D OR1
 S:I $P(^ORD(100.99,1,5,DA,1,0),U,3,4)=X_U_I S (N,I)=0,X=""
 F  S N=$O(^ORD(100.99,1,5,DA,5,N)) Q:'N  S X=$P(^(N,0),U,3) I X]"" S %=$O(^ORD(101,"B",X,0)) D:'% ADDP S:% $P(^ORD(100.99,1,5,DA,5,N,0),U,3)=% S X=N,I=I+1
 S:I $P(^ORD(100.99,1,5,DA,5,0),U,3,4)=X_U_I K N,R,X,Y,I,J
 Q
OR1 N X F  S R=$O(^ORD(100.99,1,5,DA,1,N,1,R)) Q:'R  S X=$P(^(R,0),U) I X]"" S %=$O(^ORD(101,"B",X,0)) D:'% ADDP S:% ^ORD(100.99,1,5,DA,1,N,1,R,0)=% S Y=R,J=J+1
 S:J $P(^ORD(100.99,1,5,DA,1,N,1,0),U,3,4)=Y_U_J
 Q
ADDP N I,J,N,R,DA,DLAYGO,DO S %=""
 S DIC="^ORD(101,",DIC(0)="LX",DLAYGO=101 D FILE^DICN K DIC Q:Y=-1  S %=+Y Q
