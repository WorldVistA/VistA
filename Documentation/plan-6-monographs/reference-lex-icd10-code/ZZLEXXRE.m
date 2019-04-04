ZZLEXXRE ;SLC/KER - Import - Rel Verify - 757.02 ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^LEX(757            SACC 1.3
 ;    ^LEX(757.01         SACC 1.3
 ;    ^LEX(757.02         SACC 1.3
 ;    ^ZZLEXX("ZZLEXXR")  SACC 1.3
 ;               
 ; External References
 ;    HOME^%ZIS           ICR  10086
 ;    IX1^DIK             ICR  10013
 ;    IX2^DIK             ICR  10013
 ;    $$DT^XLFDT          ICR  10103
 ;               
 Q
EN ; Codes - 757.02
 K SOS D INI,BL
 N CODE,CS,SO,SOI,SOS,SRC,EXP,EMP,MCP,MEP,EMCE,MCE,STAT,TXT,TCT S TCT=0,STAT=1
 S TXT="Codes",TXT=TXT_$J("",30-$L(TXT))_"^LEX(757.02," D TL(TXT)
 S U="^",DT=$$DT^XLFDT D HOME^%ZIS
 S SO="" F  S SO=$O(^LEX(757.02,"CODE",SO)) Q:SO=""  D
 . K CS S SOI=0 F  S SOI=$O(^LEX(757.02,"CODE",SO,SOI)) Q:SOI=""  D
 . . N I10 S I10=$$I10^ZZLEXXRA(757.02,SOI) Q:+($G(I10))'>0
 . . S CODE=$$CODE(SOI),SRC=$$CTY(SOI) Q:'$L(CODE)  Q:+SRC'>0
 . . Q:"^30^31^"'[("^"_SRC_"^")  Q:+SRC=56&($D(NOCT))  Q:CODE="M-40000"
 . . S EXP=$$EXP(SOI),EMP=$$EMP(SOI),MCP=$$MCP(SOI),MEP=$$MEP(SOI),EMCE=$$EMCE(SOI),MCE=$$MCE(SOI)
 . . Q:$D(CS(CODE,+SRC))  S CS(CODE,+SRC)="" K SOS
 . . D ARY^ZZLEXXRF(CODE,+SRC,.SOS) S TCT=TCT+1
 . . D EN^ZZLEXXRH,EN^ZZLEXXRI,EN^ZZLEXXRJ,T^ZZLEXXRK(SOI) K SOS
 K SOS
 D:+($G(STAT))>0 AP(" OK",70) N NOCT
 Q
 ;                           
INI ; Initialize Totals
 D INI^ZZLEXXRH,INI^ZZLEXXRI,INI^ZZLEXXRJ,INI^ZZLEXXRK
 Q
ST ; Show Global
 W !,"  " N NN,NC,ND S NN="^ZZLEXX(""ZZLEXXR"","_$J_",""TOT"",757.02)",NC="^ZZLEXX(""ZZLEXXR"","_$J_",""TOT"",757.02,"
 F  S NN=$Q(@NN) Q:NN=""!(NN'[NC)  D
 . S ND=@NN  W ND W:+ND'>0 !,"  " W:+ND>0 " "
 Q
TRIM(X) ; Trim Spaces
 S X=$G(X) F  Q:$E(X,1)'=" "  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=" "  S X=$E(X,1,($L(X)-1))
 Q X
CTY(X) ; Code Classification Type
 Q $P($G(^LEX(757.02,+($G(X)),0)),"^",3)
CODE(X) ; Code
 Q $P($G(^LEX(757.02,+($G(X)),0)),"^",2)
EXP(X) ; Expression Pointer
 Q $P($G(^LEX(757.02,+($G(X)),0)),"^",1)
EMP(X) ; Expression's Major Concept Pointer
 Q $P($G(^LEX(757.01,+($P($G(^LEX(757.02,+($G(X)),0)),"^",1)),1)),"^",1)
MCP(X) ; Major Concept Pointer
 Q $P($G(^LEX(757.02,+($G(X)),0)),"^",4)
MEP(X) ; Major Concept's Expression Pointer
 Q $P($G(^LEX(757,+($P($G(^LEX(757.02,+($G(X)),0)),"^",4)),0)),"^",1)
EMCE(X) ; Expression's Major Concept's Expression (circular)
 Q $P($G(^LEX(757,+($P($G(^LEX(757.01,+($P($G(^LEX(757.02,+($G(X)),0)),"^",1)),1)),"^",1)),0)),"^",1)
MCE(X) ; Major Concept Expression
 Q $P($G(^LEX(757,+($P($G(^LEX(757.02,+($G(X)),0)),"^",4)),0)),"^",1)
BL ; Blank Line
 D TL("") Q
I10(X) ;   Is ICD-10 Concept
 N IEN S IEN=$G(X) Q:'$D(^LEX(757.02,+IEN,0)) 0
 S X=0 S:"^30^31^"[("^"_$P($G(^LEX(757.02,+IEN,0)),"^",3)_"^") X=1
 Q X
AP(X,Y) ; Append Line at Y
 S X=$G(X),Y=+($G(Y)) S:Y'>0 Y=1
 I $G(ONE)>0 W ?Y,X Q
 W:'$D(ZTQUEUED) ?Y,$G(X),! Q:'$D(ZTQUEUED)
 N C,T S C=+($O(^ZZLEXX("ZZLEXXR",$J,"DRAFT"," "),-1)) Q:C'>0
 S T=$G(^ZZLEXX("ZZLEXXR",$J,"DRAFT",C))
 S:$L(T)'>Y T=T_$J(" ",(Y-$L(T))) S T=T_X
 S ^ZZLEXX("ZZLEXXR",$J,"DRAFT",C)=T N ONE
 Q
FIXMC ; Fix MC broken pointer
 N IEN,TER,TFX S (IEN,TER,TFX)=0 F  S IEN=$O(^LEX(757.02,IEN)) Q:+IEN'>0  D
 . N ND,EX,MC,EXMC,EXMCE,EXMCET S ND=$G(^LEX(757.02,+IEN,0))
 . S EX=$P(ND,"^",1),MC=$P(ND,"^",4),EXMC=$P($G(^LEX(757.01,+EX,1)),"^",1) Q:EXMC=MC
 . S EXMCE=$P($G(^LEX(757,+EXMC,0)),"^",1),EXMCET=$P($G(^LEX(757.01,+EXMCE,1)),"^",2)
 . Q:EXMCET'=1  S TER=TER+1 I $D(FIX) D
 . . N DA,DIK S DA=IEN,DIK="^LEX(757.02," D IX2^DIK
 . . S $P(^LEX(757.02,IEN,0),"^",4)=EXMC S TFX=TFX+1
 . . N DA,DIK S DA=IEN,DIK="^LEX(757.02," D IX1^DIK
 I '$D(FIX) W:+TER>0 !,+TER," Errors found (set the variable FIX to fix these entries)" W:+TER'>0 !,"No errors found"
 I $D(FIX) W:+TFX>0 !,+TFX," Errors fixed" W:+TFX'>0 !,"No errors fixed"
 N FIX
 Q
TL(X) ; Text Line
 W:'$D(ZTQUEUED) !,$G(X) Q:'$D(ZTQUEUED)
 N C S C=+($G(^ZZLEXX("ZZLEXXR",$J,"DRAFT",0))),C=C+1
 S ^ZZLEXX("ZZLEXXR",$J,"DRAFT",C)=$G(X),^ZZLEXX("ZZLEXXR",$J,"DRAFT",0)=C
 N ZTQUEUED
 Q
OUT ;
 Q:'$D(ONE)  Q:ONE'="757.02"  N TST
 W !!,"  CODES                                 ^LEX(757.02,     #757.02"
 S TST=0 F  S TST=$O(^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,TST)) Q:+TST'>0  D
 . N CT,TX S CT=$G(^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,TST)),TX=$G(^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,TST,"T"))
 . W !,?5 W:+CT>0 +CT," " W TX
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02)
 Q
