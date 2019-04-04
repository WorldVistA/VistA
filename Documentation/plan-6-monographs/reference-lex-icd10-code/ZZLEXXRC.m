ZZLEXXRC ;SLC/KER - Import - Rel Verify - 757.001 (1) ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^LEX(757            SACC 1.3
 ;    ^LEX(757.001        SACC 1.3
 ;    ^LEX(757.01         SACC 1.3
 ;    ^LEX(757.02         SACC 1.3
 ;    ^LEX(757.1          SACC 1.3
 ;    ^ZZLEXX("ZZLEXXR")  SACC 1.3
 ;               
 ; External References
 ;    ^DIK                ICR  10013
 ;    IX1^DIK             ICR  10013
 ;    $$UP^XLFSTR         ICR  10104
 ;               
 ; Local Variables NEWed or KILLed Elsewhere
 ;     TOTERR
 ;               
 Q
EN ; Concept Usage - 757.001
 D INI N TXT,STAT D BL S STAT=1
 S TXT="Concept Usage",TXT=TXT_$J("",30-$L(TXT))_"^LEX(757.001," D TL(TXT)
 N DA S DA=0 F  S DA=$O(^LEX(757.001,DA)) Q:+DA=0  D
 . N I10 S I10=$$I10^ZZLEXXRA(757.001,DA) Q:+($G(I10))'>0
 . D T1
 D:+($G(STAT))>0 AP(" OK",70)
 Q
T1 ;  1  No Major Concept Map Entry in file 757
 I '$D(^LEX(757,DA,0)) D
 . N INC,TXT S INC=$$INC(1),STAT=0
 . S TXT="Concept Usage entr"_$S(+INC>1:"ies",1:"y")_" did not have a Major Concept Map entry"
 . S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.001,1,"T")=TXT
 . S TXT="  Major Concept Map entry not found in 757 for Concept Usage #"_DA
 . D TL(TXT) S TOTERR=+($G(TOTERR))+1
 Q
 ;                       
INC(X) ; Increment Error
 N ID S ID=+($G(X)) Q:+ID'>0 ""
 S X=+($G(^ZZLEXX("ZZLEXXR",$J,"TOT",757.001,ID)))+1
 S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.001,ID)=+X
 Q X
INI ; Initialize Totals
 N TXT
 S TXT="Every entry has a Major Concept Map entry     (REQUIRED|ONE TO ONE)"
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",757.001,1) S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.001,1,"T")=TXT
 Q
FIX N MC,MCI,FREQ,ORIG,COMP
 S MCI=0 F  S MCI=$O(^LEX(757,MCI)) Q:+MCI=0  D
 . S ORIG=$P($G(^LEX(757.001,MCI,0)),"^",2)
 . S FREQ=$P($G(^LEX(757.001,MCI,0)),"^",3) Q:ORIG>0&(FREQ>0)
 . S COMP=$$ORIG(MCI)
 . Q:COMP'>ORIG
 . W !!,"^LEX(757.001,",MCI,",0)=",MCI,"^",ORIG,"^",FREQ
 . W !,"^LEX(757.001,",MCI,",0)=",MCI,"^",COMP,"^",COMP
 . N DA,DIK S DA=MCI,DIK="^LEX(757.001," D ^DIK
 . S ^LEX(757.001,DA,0)=DA_"^"_COMP_"^"_COMP D IX1^DIK
 Q
ORIG(X) ;   Get frequency based on codes and semantics
 N LEXBD,LEXCL,LEXFS,LEXMIEN,LEXNOD,LEXSAB,LEXSCT,LEXSM,LEXSO,LEXTIEN,LEXTX S LEXMIEN=+($G(X)) Q:'$D(^LEX(757,LEXMIEN,0)) 0
 S (X,LEXFS,LEXSO,LEXSM)=0 S LEXTIEN=0 F  S LEXTIEN=$O(^LEX(757.02,"AMC",LEXMIEN,LEXTIEN)) Q:+LEXTIEN=0  D
 . N LEXNOD,LEXSAB,LEXCL S LEXNOD=$G(^LEX(757.02,LEXTIEN,0)),LEXSAB=+($P(LEXNOD,U,3)) Q:LEXSAB'>0
 . ;     Coding Systems
 . ;       ICD-10-CM                   6
 . ;       ICD-10-PCS                  5
 . S:LEXSAB=30 LEXCL=6 S:LEXSAB=31 LEXCL=5
 . ;       ICD-9-CM                    4
 . ;       DSM III/IV                  3
 . S:LEXSAB=6 LEXCL=3 S:LEXSAB=5 LEXCL=3
 . ;       ICD-9 Proc                  2
 . S:LEXSAB=1 LEXCL=4 S:LEXSAB=2 LEXCL=2
 . S:LEXSAB=3 LEXCL=2 S:LEXSAB=4 LEXCL=2
 . ;       Nursing                     1
 . S:LEXSAB>10&(LEXSAB<16) LEXCL=1
 . S:+($G(LEXCL))>LEXSO LEXSO=+($G(LEXCL))
 S LEXTIEN=0 F  S LEXTIEN=$O(^LEX(757.1,"B",LEXMIEN,LEXTIEN)) Q:+LEXTIEN=0  D
 . N LEXCL,LEXBD S LEXBD=+($P($G(^LEX(757.1,LEXTIEN,0)),U,2)),LEXCL=0
 . ;     Semantic Map
 . ;       Semantic Behavior           3
 . S:LEXBD=3&(+($G(LEXCL))'>0) LEXCL="3^Behavior"
 . ;       Semantic Disease/Disorder   3
 . S:LEXBD=6 LEXCL="3^Disease/Disorder" S:LEXCL>LEXSM LEXSM=LEXCL
 S LEXTIEN=0 F  S LEXTIEN=$O(^LEX(757.01,"AMC",+LEXMIEN,LEXTIEN)) Q:+LEXTIEN'>0  D
 . Q:$P($G(^LEX(757.01,+LEXTIEN,1)),"^",2)'=8  Q:$P($G(^LEX(757.01,+LEXTIEN,1)),"^",5)>0
 . N LEXTX,LEXSCT S LEXTX=$$UP^XLFSTR($G(^LEX(757.01,+LEXTIEN,0))),LEXSCT=0
 . ;     Hierarchy
 . ;       Disease/Disorder            4
 . S:LEXTX["(DISORDER" LEXSCT="4^Disorder" S:LEXTX["(FINDING" LEXSCT="4^Finding"
 . S:LEXTX["(MORPHOLOGIC ABNORMALITY" LEXSCT="4^Morphologic Abnormality"
 . S:LEXTX["(ORGANISM" LEXSCT="4^Organism"
 . ;       Procedure                   2
 . S:+($G(LEXSCT))'>0&(LEXTX["(PROCEDURE") LEXSCT="2^Procedure"
 . S:+LEXSCT>LEXFS LEXFS=LEXSCT
 S X=+LEXSO S:X'>0 X=+LEXSM S:+LEXFS>X X=+LEXFS
 Q X
 ;          
ST ; Show Totals Global
 W !,"  " N NN,NC,ND S NN="^ZZLEXX(""ZZLEXXR"","_$J_",""TOT"",757.001)",NC="^ZZLEXX(""ZZLEXXR"","_$J_",""TOT"",757.001,"
 F  S NN=$Q(@NN) Q:NN=""!(NN'[NC)  D
 . S ND=@NN  W ND W:+ND'>0 !,"  " W:+ND>0 " "
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
 S ^ZZLEXX("ZZLEXXR",$J,"DRAFT",C)=T N ONE
 Q
OUT ;
 Q:'$D(ONE)  Q:ONE'="757.001"  N TST
 W !!,"  CONCEPT USAGE                         ^LEX(757.001,    #757.001"
 S TST=0 F  S TST=$O(^ZZLEXX("ZZLEXXR",$J,"TOT",757.001,TST)) Q:+TST'>0  D
 . N CT,TX S CT=$G(^ZZLEXX("ZZLEXXR",$J,"TOT",757.001,TST)),TX=$G(^ZZLEXX("ZZLEXXR",$J,"TOT",757.001,TST,"T"))
 . W !,?5 W:+CT>0 +CT," " W TX
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",757.001)
 Q
TL(X) ; Text Line
 W:'$D(ZTQUEUED) !,$G(X) Q:'$D(ZTQUEUED)
 N C S C=+($G(^ZZLEXX("ZZLEXXR",$J,"DRAFT",0))),C=C+1
 S ^ZZLEXX("ZZLEXXR",$J,"DRAFT",C)=$G(X),^ZZLEXX("ZZLEXXR",$J,"DRAFT",0)=C
 N ZTQUEUED
 Q
