ZZLEXXHA ;SLC/KER - Import - Semantics ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^LEX(757,           SACC 1.3
 ;    ^LEX(757.01,        SACC 1.3
 ;    ^LEX(757.018,       SACC 1.3
 ;    ^LEX(757.02,        SACC 1.3
 ;    ^LEX(757.1,         SACC 1.3
 ;    ^LEX(757.11,        SACC 1.3
 ;    ^LEX(757.12,        SACC 1.3
 ;               
 ; External References
 ;    HOME^%ZIS           ICR  10086
 ;    $$GET1^DIQ          ICR   2056
 ;    $$DT^XLFDT          ICR  10103
 ;    $$UP^XLFSTR         ICR  10104
 ;               
 Q
SM(X,Y) ; Semantics
 ; 
 ; Input
 ; 
 ;   X          Code
 ;   Y          Coding System
 ; 
 ; Output
 ; 
 ;   $$SM       2 piece "^" delimited string
 ;    
 ;                  1  SC - Semantic Class (pointer 757.11)
 ;                  2  ST - Semantic Type (pointer 757.12)
 ;           
 ;                     ^LEX(757.1,DA,0)= MC ^ SC ^ ST
 ; 
 N CODE,CTL,DIRB,FND,MC,ORD,SI,SIEN,SM,SMP,SR,SRC,TRL S CODE=$G(X),SRC=$G(Y)
 S:SRC=1 DIRB="6^47" S:SRC=2 DIRB="14^61" S:SRC=3 DIRB="14^61" S:SRC=4 DIRB="10^74" S:SRC=30 DIRB="6^47"
 S:SRC=31 DIRB="14^61" S:SRC=56 DIRB="10^71" Q:'$L($G(DIRB)) "15^999" Q:SRC=56 "10^71"
 S TRL="" I (SRC="3"!(SRC=4)),"^T^F^"[("^"_$E(CODE,5)_"^") S TRL=$E(CODE,5)
 S (FND,SMP)="",CTL=CODE F  Q:$L(CTL)<2  Q:$L(SMP)  D  Q:$L(SMP)
 . N SIEN,ORD S ORD=$E(CTL,1,($L(CTL)-1))_$C($A($E(CTL,$L(CTL)))-1)_"~ "
 . F  S ORD=$O(^LEX(757.02,"CODE",ORD)) Q:'$L(ORD)!(ORD'[CTL)  Q:$L(SMP)  D  Q:$L(SMP)
 . . I $L($G(TRL)),$G(TRL)?1U,(SRC=3!(SRC=4)),$E(ORD,5)'=TRL Q
 . . N SIEN S SIEN=0 F  S SIEN=$O(^LEX(757.02,"CODE",ORD,SIEN)) Q:+SIEN'>0  Q:$L(SMP)  D  Q:$L(SMP)
 . . . N MC,SI,SM,SR S MC=$P($G(^LEX(757.02,+SIEN,0)),"^",4),SR=$P($G(^LEX(757.02,+SIEN,0)),"^",3) Q:SR'=SRC
 . . . S SI=$O(^LEX(757.1,"B",+MC,0)),SM=$P($G(^LEX(757.1,+SI,0)),"^",2,3)
 . . . Q:'$D(^LEX(757.11,+($P(SM,"^",1)),0))  Q:'$D(^LEX(757.12,+($P(SM,"^",2)),0))
 . . . S SMP=SM,FND=$P($G(^LEX(757.02,+SIEN,0)),"^",2)
 . S CTL=$E(CTL,1,($L(CTL)-1))
 S:'$L(SMP) SMP=DIRB S X=$G(SMP)
 Q X
GETH(X) ; Get Hierarchy/Semantics
 ;
 ; Input
 ; 
 ;   X          Major Concept (pointer to 757)
 ;   
 ; Output
 ; 
 ;   $$GETH     7 piece "^" dilimited string
 ;                  1  Major Concept (pointer to 757)
 ;                  2  Hierachy (pointer to 757.018)
 ;                  3  Semantic Class (pointer to 757.11)
 ;                  4  Semantic Type (pointer to 757.12)
 ;                  5  External Hierachy
 ;                  6  External Semantic Class
 ;                  7  External Semantic Type
 ;                     
 ;                     Pieces 2-7 can be null
 ;           
 N MC,EX,SY,TY,AR,OUT,SCT,EXT
 S MC=+($G(X)) Q:MC'>0 ""  Q:'$D(^LEX(757,+MC)) ""
 S SY=0 F  S SY=$O(^LEX(757.01,"AMC",MC,SY)) Q:+SY'>0  D
 . N TY,FL,ID,EN,HI S TY=$P($G(^LEX(757.01,+SY,1)),"^",2) Q:+TY'>0
 . S FL=$P($G(^LEX(757.01,+SY,1)),"^",5) Q:+FL>0
 . S ID=$O(^LEX(757.01,+SY,7,"C",56,"")) Q:'$L(ID)
 . S EN=$O(^LEX(757.01,+SY,7,"C",56,ID,0)) Q:+EN'>0
 . S HI=$P($G(^LEX(757.01,+SY,7,+EN,0)),"^",3) Q:+HI'>0
 . S:TY'=8 AR("E",HI)="" S:TY=8 AR("F",HI)=""
 S OUT=$O(AR("F",0)) S:+OUT'>0 OUT=$O(AR("E",0)) Q:OUT'>0 (MC_"^^^")
 S SCT=$$IHCT(OUT),EXT=$$EHCT(OUT)
 S X=MC S $P(X,"^",2)=$P(SCT,"^",1) S $P(X,"^",3)=$P(SCT,"^",2) S $P(X,"^",4)=$P(SCT,"^",3)
 S $P(X,"^",5)=$P(EXT,"^",1) S $P(X,"^",6)=$P(EXT,"^",2) S $P(X,"^",7)=$P(EXT,"^",3)
 Q X
IHCT(X) ; Internal Semantic Class and Type (Hierarchy)
 ; 
 ; Input
 ; 
 ;   X          Hierarchy
 ;   
 ; Output
 ; 
 ;   $$SCTSCT   3 piece "^" dilimited string
 ;                  1   Hierarchy (pointer to 757.018)
 ;                  2   Semantic Class (pointer to 757.11)
 ;                  3   Semantic Type (pointer to 757.12)
 N UX S X=$$TM($G(X)),UX=$$UP^XLFSTR(X)
 Q:UX="Disorder"!(UX="DISORDER")!(UX=1) "1^6^47"
 Q:UX="Procedure"!(UX="PROCEDURE")!(UX=2) "2^14^61"
 Q:UX="Finding"!(UX="FINDING")!(UX=3) "3^6^33"
 Q:UX="Organism"!(UX="ORGANISM")!(UX=4) "4^12^1"
 Q:UX="Body Structure"!(UX="BODY STRUCTURE")!(UX=5) "5^2^23"
 Q:UX="Substance"!(UX="SUBSTANCE")!(UX=6) "6^10^167"
 Q:UX="Product"!(UX="PRODUCT")!(UX=7) "7^4^121"
 Q:UX="Event"!(UX="EVENT")!(UX=8) "8^1^51"
 Q:UX="Situation"!(UX="SITUATION")!(UX=9) "9^6^33"
 Q:UX="Qualifier Value"!(UX="QUALIFIER VALUE")!(UX=10) "10^5^80"
 Q:UX="Observable Entity"!(UX="observable entity")!(UX="OBSERVABLE ENTITY")!(UX=11) "11^1^52"
 Q:UX="ConteUXt-Dependent Category"!(UX="ConteUXt Dependent Category")!(UX="CONTEUXT-DEPENDENT CATEGORY")!(UX="CONTEUXT DEPENDENT CATEGORY")!(UX=12) "12^5^58"
 Q:UX="Morphologic Abnormality"!(UX="MORPHOLOGIC ABNORMALITY")!(UX=13) "13^2^19"
 Q:UX="Physical Object"!(UX="PHYSICAL OBJECT")!(UX=14) "14^10^72"
 Q:UX="Regime/Therapy"!(UX="REGIME/THERAPY")!(UX=15) "15^14^61"
 Q:UX="Occupation"!(UX="OCCUPATION")!(UX=16) "16^11^90"
 Q:UX="Specimen"!(UX="SPECIMEN")!(UX=17) "17^2^31"
 Q:UX="Environment"!(UX="ENVIRONMENT")!(UX=18) "18^1^58"
 Q:UX="Navigational Concept"!(UX="NAVIGAIONAL CONCEPT")!(UX=19) "19^5^169"
 Q:UX="Assessment Scale"!(UX="ASSESSMENT SCALE")!(UX=20) "20^5^80"
 Q:UX="Attribute"!(UX="ATTRIBUTE")!(UX=21) "21^5^1001"
 Q:UX="Cell"!(UX="CELL")!(UX=22) "22^2^25"
 Q:UX="Geographic Location"!(UX="GEOGRAPHIC LOCATION")!(UX=23) "23^7^83"
 Q:UX="Record Artifact"!(UX="RECORD ARTIFACT")!(UX=24) "24^1^58"
 Q:UX="Cell Structure"!(UX="CELL STRUCTURE")!(UX=25) "25^2^26"
 Q:UX="Person"!(UX="PERSON")!(UX=26) "26^12^16"
 Q:UX="Tumor Staging"!(UX="TUMOR STAGING")!(UX=27) "27^6^46"
 Q:UX="Ethnic Group"!(UX="ETHNIC GROUP")!(UX=28) "28^8^98"
 Q:UX="Religion/Philosophy"!(UX="RELIGION/PHILOSOPHY")!(UX=29) "29^5^78"
 Q:UX="Physical Force"!(UX="PHYSICAL FORCE")!(UX=30) "30^1^70"
 Q:UX="Namespace Concept"!(UX="NAMESPACE CONCEPT")!(UX=31) "31^15^999"
 Q:UX="Administrative Concept"!(UX="ADMINISTRATIVE CONCEPT")!(UX=32) "32^5^77"
 Q:UX="Social Concept"!(UX="SOCIAL CONCEPT")!(UX=33) "33^5^102"
 Q:UX="Life Style"!(UX="LIFE STYLE")!(UX=34) "34^1^52"
 Q:UX="Staging Scale"!(UX="STAGING SCALE")!(UX=35) "35^5^80"
 Q:UX="Inactive Concept"!(UX="INACTIVE CONCEPT")!(UX=36) "36^15^999"
 Q:UX="Environment / Location"!(UX="Environment/Location")!(UX="ENVIRONMENT / LOCATION")!(UX="ENVIRONMENT/LOCATION")!(UX=37) "37^15^999"
 Q:UX="Special Concept"!(UX="SPECIAL CONCEPT")!(UX=38) "38^15^999"
 Q:UX["RT+CTV3"!(UX["RT+CTV3")!(UX=39) "39^15^999"
 Q:UX="Function"!(UX="FUNCTION")!(UX=40) "40^5^169"
 Q:UX="Linkage Concept"!(UX="LINKAGE CONCEPT")!(UX=41) "41^15^999"
 Q:UX="Racial Group"!(UX="RACIAL GROUP")!(UX=42) "42^8^98"
 Q:UX="Link Assertion"!(UX="LINK ASSERTION")!(UX=43) "43^15^999"
 Q "38^15^999"
 Q
 ; 
 ; Miscellaneous
EHCT(X) ;   External Semantic Class and Type (Hierarchy)
 N INP,HR,CL,TY S INP=$G(X) S:$L(INP,"^")=1 INP=$$IHCT(INP) Q:$L(INP,"^")'=3
 S HR=$P(INP,"^",1),HR=$P($G(^LEX(757.018,+HR,0)),"^",1)
 S CL=$P(INP,"^",2),CL=$P($G(^LEX(757.11,+CL,0)),"^",2)
 S TY=$P(INP,"^",3),TY=$P($G(^LEX(757.12,+TY,0)),"^",2)
 S X=HR_"^"_CL_"^"_TY
 Q X
TM(X,Y) ;   Trim Character Y - Default " " Space
 S X=$G(X) Q:X="" X  S Y=$G(Y) S:'$L(Y) Y=" "
 F  Q:$E(X,1)'=Y  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=Y  S X=$E(X,1,($L(X)-1))
 Q X
ENV(X) ;   Environment
 D HOME^%ZIS S U="^",DT=$$DT^XLFDT,DTIME=300 K POP
 N NM S NM=$$GET1^DIQ(200,(DUZ_","),.01)
 I '$L(NM) W !!,?5,"Invalid/Missing DUZ" Q 0
 S:$G(DUZ(0))'["@" DUZ(0)=$G(DUZ(0))_"@"
 N ALL,DA,DIK,EDIT,FULL,TEXT,TOT
 Q 1
