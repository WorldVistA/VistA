ZZLEXXRM ;SLC/KER - Import - Rel Verify - 757.1 (1-4) ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^LEX(757            SACC 1.3
 ;    ^LEX(757.01         SACC 1.3
 ;    ^LEX(757.02         SACC 1.3
 ;    ^LEX(757.1          SACC 1.3
 ;    ^LEX(757.11         SACC 1.3
 ;    ^LEX(757.12         SACC 1.3
 ;    ^ZZLEXX("ZZLEXXR")  SACC 1.3
 ;               
 ; External References
 ;    ^DIK                ICR  10013
 ;               
 ; Local Variables NEWed or KILLed Elsewhere
 ;     SOS,TOTERR
 ;               
 Q
EN ; Semantic Map - 757.1
 D INI N CT,TXT,STAT D BL S STAT=1,CT=0
 S TXT="Semantic Map",TXT=TXT_$J("",30-$L(TXT))_"^LEX(757.1,"
 D TL(TXT) N DA,CL,TY,CCT,CTT,TYT S DA=0
 F  S DA=$O(^LEX(757.1,DA)) Q:+DA=0  D
 . N I10 S I10=$$I10^ZZLEXXRA(757.1,DA) Q:+($G(I10))'>0
 . D T1,T2,T3,T4,T5
 K SOS("ERR",757.1)
 D:+($G(STAT))>0 AP(" OK",70)
 Q
EN2 ; Semantic Map (one)
 N ONE,NOUPD,TAB,FULL S FULL="" S ONE=757.1,NOUPD="",TAB="    " D EN,OUT
 Q
T1 ; 1  Semantic Map does not have an Semantic Class entry file 757.11
 N CCT,CL,INC,TXT S CL=$P($G(^LEX(757.1,DA,0)),"^",2)
 S CCT=$P($G(^LEX(757.11,+CL,0)),"^",1)
 I '$D(^LEX(757.11,+CL,0))!('$L(CCT)) D
 . N INC,TXT S INC=$$INC(1),SOS("ERR",757.1,1)="",STAT=0
 . S TXT="Semantic Map entr"_$S(+INC>1:"ies do",1:"y does")_" not have a Semantic Class"
 . S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.1,1,"T")=TXT
 . S TXT="  Semantic Map #"_DA_" has no Semantic Class"
 . D TL(TXT) S TOTERR=+($G(TOTERR))+1
 Q
T2 ; 2  Semantic Map does not have an Semantic Type entry file 757.12
 N INC,TY,TYT,TXT S TY=$P($G(^LEX(757.1,DA,0)),"^",3)
 S TYT=$$TRIM($P($G(^LEX(757.12,+TY,0)),"^",2))
 I '$D(^LEX(757.12,+TY,0))!('$L(TYT)) D
 . N INC,TXT S INC=$$INC(2),SOS("ERR",757.1,1)="",STAT=0
 . S TXT="Semantic Map entr"_$S(+INC>1:"ies do",1:"y does")_" not have a Semantic Type"
 . S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.1,2,"T")=TXT
 . S TXT="  Semantic Map #"_DA_" has no Semantic Type"
 . D TL(TXT) S TOTERR=+($G(TOTERR))+1
 Q
T3 ; 3  Semantic Map does not have an Major Concept entry file 757
 N INC,MC,TXT S MC=+($P($G(^LEX(757.1,DA,0)),"^",1))
 I '$D(^LEX(757,+MC,0)) D
 . N INC,TXT S INC=$$INC(3),STAT=0
 . S TXT="Semantic Map entr"_$S(+INC>1:"ies do",1:"y did")_" not have a Major Concept entry"
 . S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.1,3,"T")=TXT
 . S TXT="  No Major Concept Map found for Semantic Map #"_DA
 . D TL(TXT) S TOTERR=+($G(TOTERR))+1
 Q
T4 ; 4  Semantic Map does not have an Major Concept entry file 757
 N INC,MC,EX,TY,TXT S MC=+($P($G(^LEX(757.1,DA,0)),"^",1)),EX=+($G(^LEX(757,+MC,0)))
 S TY=+($P($G(^LEX(757.01,+EX,1)),"^",2))
 I TY'=1 D
 . N INC,TXT S INC=$$INC(4),STAT=0
 . S TXT="Semantic Map entr"_$S(+INC>1:"ies do",1:"y did")_" not have a Major Concept Expression"
 . S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.1,4,"T")=TXT
 . S TXT="  No Major Concept Expression found for Semantic Map #"_DA
 . D TL(TXT) S TOTERR=+($G(TOTERR))+1
 Q
T5 ; 5  Semantic Type does not match Semantic Class
 I $D(SOS("ERR",757.1,1)) K ^ZZLEXX("ZZLEXXR",$J,"TOT",757.1,5,"T") Q
 N CCT,CL,CTT,INC,TY,TYT,TXT S CL=$P($G(^LEX(757.1,DA,0)),"^",2)
 S CCT=$P($G(^LEX(757.11,+CL,0)),"^",1)
 S TY=$P($G(^LEX(757.1,DA,0)),"^",3)
 S CTT=$$TRIM($P($G(^LEX(757.12,+TY,0)),"^",3))
 S TYT=$$TRIM($P($G(^LEX(757.12,+TY,0)),"^",2))
 I CCT'=CTT D
 . N INC,TXT S INC=$$INC(5),STAT=0
 . S TXT="Semantic Type"_$S(+INC>1:"s do",1:" does")_" not match Semantic Class"
 . S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.1,5,"T")=TXT
 . S TXT="  Type '"_TYT_"' is not of Class '"_CCT_"'"
 . D TL(TXT) S TOTERR=+($G(TOTERR))+1
 Q
 ;                       
INC(X) ; Increment Error
 N ID S ID=+($G(X)) Q:+ID'>0 ""
 S X=+($G(^ZZLEXX("ZZLEXXR",$J,"TOT",757.1,ID)))+1
 S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.1,ID)=+X
 Q X
INI ; Initialize Totals
 N TXT S TXT="All Semantic Map entries have a Semantic Class entry"
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",757.1,1) S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.1,1,"T")=TXT
 S TXT="All Semantic Map entries have a Semantic Type entry"
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",757.1,2) S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.1,2,"T")=TXT
 S TXT="All Semantic Map entries have a Major Concept Map entry"
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",757.1,3) S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.1,3,"T")=TXT
 ;
 S TXT="All Semantic Map entries have a Major Concept Expression"
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",757.1,4) S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.1,4,"T")=TXT
 ;
 S TXT="All Semantic Types belong to one Class       (REQUIRED|MANY TO ONE)"
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",757.1,5) S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.1,5,"T")=TXT
 Q
ST ; Show Global
 W !,"  " N NN,NC,ND S NN="^ZZLEXX(""ZZLEXXR"","_$J_",""TOT"")",NC="^ZZLEXX(""ZZLEXXR"","_$J_",""TOT"","
 F  S NN=$Q(@NN) Q:NN=""!(NN'[NC)  D
 . S ND=@NN  W ND W:+ND'>0 !,"  " W:+ND>0 " "
 Q
FIX ; Fix Semantic Map
 N IEN,CT,FX S (CT,FX,IEN)=0 F  S IEN=$O(^LEX(757.1,IEN)) Q:+IEN'>0  D
 . N MC,EX,TY S MC=+($P($G(^LEX(757.1,IEN,0)),"^",1))
 . S EX=+($P($G(^LEX(757,+MC,0)),"^",1))
 . S TY=+($P($G(^LEX(757.01,+EX,1)),"^",2))
 . I TY'=1 S CT=CT+1
 . I TY'=1&($D(FIX)) D
 . . N DA,DIK S DA=IEN,DIK="^LEX(757.1," D ^DIK S FX=FX+1
 W !!
 W:'$D(FIX) +($G(CT))," Errors Found " W:'$D(FIX)&(+CT>0) "(Set the variable FIX to fix the entries)"
 W:$D(FIX) +($G(FX))," Fixed" K FIX
 Q
TRIM(X) ; Trim Spaces
 S X=$G(X) F  Q:$E(X,1)'=" "  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=" "  S X=$E(X,1,($L(X)-1))
 Q X
I10(X) ;   Is ICD-10 Concept
 N IEN,MIEN,SIEN S IEN=$G(X) Q:'$D(^LEX(757.1,+IEN,0)) 0
 S MIEN=+($G(^LEX(757.1,+IEN,0))) Q:'$D(^LEX(757,+MIEN,0)) 0
 S (X,SIEN)=0 F  S SIEN=$O(^LEX(757.02,"AMC",+MIEN,SIEN)) Q:+SIEN'>0  D
 . S:"^30^31^"[("^"_$P($G(^LEX(757.02,+SIEN,0)),"^",3)_"^") X=1
 Q X
BL ; Blank Line
 D TL("") Q
AP(X,Y) ; Append Line at Y
 S X=$G(X),Y=+($G(Y)) S:Y'>0 Y=1
 I $G(ONE)>0 W ?Y,X Q
 W:'$D(ZTQUEUED) ?Y,$G(X),! Q:'$D(ZTQUEUED)
 N C,T S C=+($O(^ZZLEXX("ZZLEXXR",$J,"DRAFT"," "),-1)) Q:C'>0
 S T=$G(^ZZLEXX("ZZLEXXR",$J,"DRAFT",C))
 S:$L(T)'>Y T=T_$J(" ",(Y-$L(T))) S T=T_X
 S ^ZZLEXX("ZZLEXXR",$J,"DRAFT",C)=T N ZTQUEUED
 Q
TL(X) ; Text Line
 W:'$D(ZTQUEUED) !,$G(X) Q:'$D(ZTQUEUED)
 N C S C=+($G(^ZZLEXX("ZZLEXXR",$J,"DRAFT",0))),C=C+1
 S ^ZZLEXX("ZZLEXXR",$J,"DRAFT",C)=$G(X),^ZZLEXX("ZZLEXXR",$J,"DRAFT",0)=C Q
OUT ;
 Q:'$D(ONE)  Q:ONE'="757.1"  N TST
 W !!,"  SEMANTIC MAP                          ^LEX(757.1,      #757.1"
 S TST=0 F  S TST=$O(^ZZLEXX("ZZLEXXR",$J,"TOT",757.1,TST)) Q:+TST'>0  D
 . N CT,TX S CT=$G(^ZZLEXX("ZZLEXXR",$J,"TOT",757.1,TST)),TX=$G(^ZZLEXX("ZZLEXXR",$J,"TOT",757.1,TST,"T"))
 . W !,?5 W:+CT>0 +CT," " W TX
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",757.1)
 Q
