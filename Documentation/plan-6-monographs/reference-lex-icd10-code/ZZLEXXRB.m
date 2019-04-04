ZZLEXXRB ;SLC/KER - Import - Rel Verify - 757 (1-6) ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^LEX(757            SACC 1.3
 ;    ^LEX(757.001        SACC 1.3
 ;    ^LEX(757.01         SACC 1.3
 ;    ^LEX(757.1          SACC 1.3
 ;    ^ZZLEXX("ZZLEXXR")  SACC 1.3
 ;               
 ; External References
 ;    $$UP^XLFSTR         ICR  10104
 ;               
 ; Local Variables NEWed or KILLed Elsewhere
 ;     TOTERR
 ;               
 Q
EN ; Concept Map - 757
 K ^ZZLEXX("ZZLEXXR",$J,"TOT","DUPES",757) D INI
 N TXT,EX,STAT D BL S STAT=1
 S TXT="Major Concept Map",TXT=TXT_$J("",30-$L(TXT))_"^LEX(757," D TL(TXT)
 N DA S DA=0 F  S DA=$O(^LEX(757,DA)) Q:+DA=0  D
 . N I10 S I10=$$I10^ZZLEXXRA(757,DA) Q:+($G(I10))'>0
 . D T1,T2,T3,T4,T5,T6
 K ^ZZLEXX("ZZLEXXR",$J,"TOT","DUPES",757)
 D:+($G(STAT))>0 AP(" OK",70)
 Q
T1 ;  1  No Frequency in Concept Usage file 757.001
 I '$D(^LEX(757.001,DA,0)) D
 . N INC,TXT S INC=$$INC(1),STAT=0
 . S TXT="Major Concept Map entr"_$S(+INC>1:"ies",1:"y")_" did not have a Concept Usage entry"
 . S ^ZZLEXX("ZZLEXXR",$J,"TOT",757,1,"T")=TXT
 . S TXT="  Concept frequency not found in 757.001 for Major Concept Map #"_DA
 . D TL(TXT) S TOTERR=+($G(TOTERR))+1
 Q
T2 ;  2  Invalid Expression Pointer to file 757.01
 N EX S EX=$P($G(^LEX(757,DA,0)),"^",1)
 I +EX'>0!(+EX'=EX) D
 . N INC,TXT S INC=$$INC(2),STAT=0
 . S TXT="Major Concept Map entr"_$S(+INC>1:"ies have",1:"y has")_" an invalid Expression pointer"
 . S ^ZZLEXX("ZZLEXXR",$J,"TOT",757,2,"T")=TXT
 . S TXT="  Invalid Expression pointer for Major Concept Map #"_DA
 . D TL(TXT) S TOTERR=+($G(TOTERR))+1
 Q
T3 ;  3  Invalid Major Concept Expression in file 757.01
 N EX,TY S EX=$P($G(^LEX(757,DA,0)),"^",1),TY=$P($G(^LEX(757.01,+EX,1)),"^",2)
 I +TY'=1 D
 . N INC,TXT S INC=$$INC(3),STAT=0
 . S TXT="Major Concept Map entr"_$S(+INC>1:"ies have",1:"y has")_" an invalid Concept Expression"_$S(+INC>1:"s",1:"")
 . S ^ZZLEXX("ZZLEXXR",$J,"TOT",757,3,"T")=TXT
 . S TXT="  Invalid Concept Expression for Major Concept Map #"_DA
 . D TL(TXT) S TOTERR=+($G(TOTERR))+1
 Q
T4 ;  4  Missing Expression Entry in file 757.01
 N EX S EX=$P($G(^LEX(757,DA,0)),"^",1)
 I '$D(^LEX(757.01,+EX,0)) D
 . N INC,TXT S INC=$$INC(4),STAT=0
 . S TXT="Major Concept Map entr"_$S(+INC>1:"ies do",1:"y does")_" not have an Expression entry"
 . S ^ZZLEXX("ZZLEXXR",$J,"TOT",757,4,"T")=TXT
 . S TXT="  Expression not found in 757.01 for Major Concept Map #"_DA
 . D TL(TXT) S TOTERR=+($G(TOTERR))+1
 Q
T5 ;  5  Missing Semantic Map Entry in file 757.1
 I '$D(^LEX(757.1,"B",DA)) D
 . N INC,TXT S INC=$$INC(5),STAT=0
 . S TXT="Major Concept Map entr"_$S(+INC>1:"ies do",1:"y does")_" not have an Semantic Map entry"
 . S ^ZZLEXX("ZZLEXXR",$J,"TOT",757,5,"T")=TXT
 . S TXT="  Semantics not found in 757.1 for Major Concept Map #"_DA
 . D TL(TXT) S TOTERR=+($G(TOTERR))+1
 Q
T6 ;  6  Multiple Concept Expressions in file 757.01
 ; changes (INA) in next 6 line [fjf]
 N EIEN,MCC
 S (EIEN,MCC)=0  F  S EIEN=$O(^LEX(757.01,"AMC",+DA,EIEN)) Q:+EIEN'>0  D
 . N MC,ET,INA
 . S MC=$G(^LEX(757.01,+EIEN,1)),ET=$P(MC,"^",2),INA=$P(MC,"^",5),MC=+MC
 . I +MC=+DA,ET="1",INA'=1 S MCC=MCC+1
 I MCC>1 D
 . N INC,TXT S INC=$$INC(6),STAT=0
 . S TXT="Major Concept Map entr"_$S(+INC>1:"ies have",1:"y has")_" multiple Concept Expressions"
 . S ^ZZLEXX("ZZLEXXR",$J,"TOT",757,6,"T")=TXT
 . S TXT="  Multiple Concept Expressions found in 757.01 for Major Concept Map #"_DA
 . D TL(TXT) S TOTERR=+($G(TOTERR))+1
 Q
DUP ;  7  Duplicate Concept Expressions
 N EXP,NEX,CTL,ORD,ARY,CT,KEY,EIEN,UPP
 S EXP=$G(^LEX(757.01,+($G(^LEX(757,+DA,0))),0)),UPP=$$UP^XLFSTR(EXP)
 S (CTL,ORD)=$E(UPP,1,63),KEY=$C(($A(($E(ORD,$L(ORD))))-1))_"~",ORD=$E(ORD,1,($L(ORD)-1))_KEY
 F  S ORD=$O(^LEX(757.01,"B",ORD)) Q:'$L(ORD)!(ORD'[CTL)  D
 . S EIEN=0 F  S EIEN=$O(^LEX(757.01,"B",ORD,+EIEN)) Q:+EIEN'>0  D
 . . N NEX,NUP,ND1 S NEX=$G(^LEX(757.01,+EIEN,0)),NUP=$$UP^XLFSTR(NEX),ND1=$G(^LEX(757.01,+EIEN,1))
 . . Q:NUP'=UPP
 . . Q:$P(ND1,"^",5)=1  Q:$P(ND1,"^",2)'=1
 . . Q:$D(ARY("B",+EIEN))
 . . S CT=+($O(ARY(" "),-1))+1
 . . S ARY(CT)=EIEN
 . . S ARY(CT,0)=$G(^LEX(757.01,+EIEN,0))
 . . S ARY(CT,1)=$G(^LEX(757.01,+EIEN,1))
 . . S ARY(0)=CT,ARY("B",+EIEN)=""
 I $G(ARY(0))>0  D
 . N CT,TT,EXS S (TT,CT)=0,EXS=""
 . F  S CT=$O(ARY(CT)) Q:+CT'>0  D
 . . N EIEN S EIEN=+($G(ARY(CT))) Q:+EIEN'>0  Q:$D(^ZZLEXX("ZZLEXXR",$J,"TOT","DUPES",757,+EIEN))
 . . S ^ZZLEXX("ZZLEXXR",$J,"TOT","DUPES",757,+EIEN)="" S TT=TT+1
 . . S EXS=$G(EXS)_", "_EIEN
 . S EXS=$$AND($$CS(EXS)) S EXS=$S(EXS[" and ":("Expressions "_EXS),1:"")
 . I +TT>1 D
 . . N INC,TXT S INC=$$INC(7)
 . . S TXT="Major Concept Map entr"_$S(+INC>1:"ies have",1:"y has")_" Duplicate Active Concepts"
 . . S ^ZZLEXX("ZZLEXXR",$J,"TOT",757,7,"T")=TXT
 . . S TXT="  Duplicate Active Concepts found in 757.01 for Major Concept Map #"_DA
 . . D TL(TXT) D:$L($G(EXS)) TL(("     See "_$G(EXS))) S TOTERR=+($G(TOTERR))+1
 Q
 ;                       
INC(X) ; Increment Error
 N ID S ID=+($G(X)) Q:+ID'>0 ""
 S X=+($G(^ZZLEXX("ZZLEXXR",$J,"TOT",757,ID)))+1,^ZZLEXX("ZZLEXXR",$J,"TOT",757,ID)=+X
 Q X
INI ; Initialize Totals
 ;
 ;       1  No Frequency in Concept Usage file 757.001
 ;       2  Invalid Expression Pointer to file 757.01
 ;       3  Invalid Major Concept Expression in file 757.01
 ;       4  Missing Expression Entry in file 757.01
 ;       5  Missing Semantic Map Entry in file 757.1
 ;       6  Multiple Concept Expressions in file 757.01
 ;       7  Duplicate Concept Expressions
 ;       
 N TXT S TXT="Every entry has a Concept Usage entry         (REQUIRED|ONE TO ONE)"
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",757,1) S ^ZZLEXX("ZZLEXXR",$J,"TOT",757,1,"T")=TXT
 ;
 S TXT="Every Major Concept Map entry has valid Expression pointer"
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",757,2) S ^ZZLEXX("ZZLEXXR",$J,"TOT",757,2,"T")=TXT
 ;
 S TXT="Every Major Concept Map entry has valid Major Concept Expression"
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",757,3) S ^ZZLEXX("ZZLEXXR",$J,"TOT",757,3,"T")=TXT
 ;
 S TXT="Every entry has an Expression entry           (REQUIRED|ONE TO MANY)"
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",757,4) S ^ZZLEXX("ZZLEXXR",$J,"TOT",757,4,"T")=TXT
 ;
 S TXT="Every entry has a Semantic Map entry          (REQUIRED|ONE TO MANY)"
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",757,5) S ^ZZLEXX("ZZLEXXR",$J,"TOT",757,5,"T")=TXT
 ;
 S TXT="Every entry has one Concept Expression        (REQUIRED|ONE TO ONE)"
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",757,6) S ^ZZLEXX("ZZLEXXR",$J,"TOT",757,6,"T")=TXT
 ;
 S TXT="Every entry has one Unique Active Concept     (REQUIRED|ONE TO ONE)"
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",757,7) S ^ZZLEXX("ZZLEXXR",$J,"TOT",757,7,"T")=TXT
 Q
ST ; Show Global
 W !,"  " N NN,NC,ND S NN="^ZZLEXX(""ZZLEXXR"","_$J_",""TOT"",757)",NC="^ZZLEXX(""ZZLEXXR"","_$J_",""TOT"",757,"
 F  S NN=$Q(@NN) Q:NN=""!(NN'[NC)  D
 . S ND=@NN  W ND W:+ND'>0 !,"  " W:+ND>0 " "
 Q
AND(X) ;   Substitute 'and'
 S X=$G(X) Q:$L(X,", ")'>1 X  S X=$P(X,", ",1,($L(X,", ")-1))_" and "_$P(X,", ",$L(X,", ")) Q X
CS(X) ;   Trim Comma/Space
 S X=$$TM($G(X),","),X=$$TM($G(X)," "),X=$$TM($G(X),","),X=$$TM($G(X)," ") Q X
TM(X,Y) ;   Trim Character Y - Default " "
 S X=$G(X) Q:X="" X  S Y=$G(Y) S:'$L(Y) Y=" " F  Q:$E(X,1)'=Y  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=Y  S X=$E(X,1,($L(X)-1))
 Q X
OUT ;
 Q:'$D(ONE)  Q:ONE'="757"  N TST
 W !!,"  MAJOR CONCEPT MAP                     ^LEX(757,        #757"
 S TST=0 F  S TST=$O(^ZZLEXX("ZZLEXXR",$J,"TOT",757,TST)) Q:+TST'>0  D
 . N CT,TX S CT=$G(^ZZLEXX("ZZLEXXR",$J,"TOT",757,TST)),TX=$G(^ZZLEXX("ZZLEXXR",$J,"TOT",757,TST,"T"))
 . W !,?5 W:+CT>0 +CT," " W TX
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",757) N ONE
 Q
BL ; Blank Line
 D TL("") Q
AP(X,Y) ; Append Line at Y
 S X=$G(X),Y=+($G(Y)) S:Y'>0 Y=1
 I $G(ONE)>0 W ?Y,X Q
 W:'$D(ZTQUEUED) ?Y,$G(X),! Q:'$D(ZTQUEUED)
 N C,T S C=+($O(^ZZLEXX("ZZLEXXR",$J,"DRAFT"," "),-1)) Q:C'>0
 S T=$G(^ZZLEXX("ZZLEXXR",$J,"DRAFT",C))
 S:$L(T)'>Y T=T_$J(" ",(Y-$L(T))) S T=T_X
 S ^ZZLEXX("ZZLEXXR",$J,"DRAFT",C)=T
 Q
TL(X) ; Text Line
 W:'$D(ZTQUEUED) !,$G(X) Q:'$D(ZTQUEUED)
 N C S C=+($G(^ZZLEXX("ZZLEXXR",$J,"DRAFT",0))),C=C+1
 S ^ZZLEXX("ZZLEXXR",$J,"DRAFT",C)=$G(X),^ZZLEXX("ZZLEXXR",$J,"DRAFT",0)=C
 N ZTQUEUED
 Q
