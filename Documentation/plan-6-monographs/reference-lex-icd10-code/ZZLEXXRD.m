ZZLEXXRD ;SLC/KER - Import - Rel Verify - 757.01 ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^ICD9(              ICR   4485
 ;    ^ICD0(              ICR   4486
 ;    ^LEX(757            SACC 1.3
 ;    ^LEX(757.01         SACC 1.3
 ;    ^LEX(757.011        SACC 1.3
 ;    ^LEX(757.02         SACC 1.3
 ;    ^LEX(757.03         SACC 1.3
 ;    ^ZZLEXX("ZZLEXXR")  SACC 1.3
 ;               
 ; External References
 ;    HOME^%ZIS           ICR  10086
 ;    IX1^DIK             ICR  10013
 ;    IX2^DIK             ICR  10013
 ;    $$STATCHK^LEXSRC2   N/A
 ;    $$MIX^LEXXMC        N/A
 ;    $$DT^XLFDT          ICR  10103
 ;    $$FMADD^XLFDT       ICR  10103
 ;    $$UP^XLFSTR         ICR  10104
 ;               
 ; Local Variables NEWed or KILLed Elsewhere
 ;     TOTERR,ZTQUEUED
 ;               
 Q
EN ; Expressions - 757.01
 K ^ZZLEXX("ZZLEXXR",$J,"DUPES")
 S U="^" D HOME^%ZIS S DT=$$DT^XLFDT D INI,BL
 N DA,DXN,DXS,DPS,EXP,M1,MC,MCE,MCEE,N1,NTY,O1,ORD,OTY,OTYT,PAR
 N TDI,TDP,TXT,TYPE,STAT,INA S STAT=1
 S TXT="Expressions",TXT=TXT_$J("",30-$L(TXT))_"^LEX(757.01," D TL(TXT)
 S DT=$$DT^XLFDT,(DA,DXS,DXN,DPS)=0
 F  S DA=$O(^LEX(757.01,DA)) Q:+DA=0  D
 . N I10 S I10=$$I10^ZZLEXXRA(757.01,DA) Q:+($G(I10))'>0
 . S (TDP,EXP)=$G(^LEX(757.01,DA,0))
 . S TDI=$G(^LEX(757.01,DA,2))
 . S O1=$G(^LEX(757.01,DA,1))
 . S TYPE=$P(O1,"^",2),PAR=+($P(O1,"^",9)),ORD=+($P(O1,"^",10))
 . S OTY=$P(O1,"^",2)
 . S INA=$P(O1,U,5)
 . S MC=+($P($G(^LEX(757.01,DA,1)),"^",1))
 . S M1=$G(^LEX(757,+MC,0)),MCE=+($P(M1,"^",1))
 . S MCEE=$P($G(^LEX(757.01,+MCE,0)),"^",1)
 . S OTYT=$P($G(^LEX(757.011,+OTY,0)),"^",1)
 . S N1=$G(^LEX(757.01,+MCE,1)),NTY=$P(N1,"^",2)
 . D T1,T2,T3,T4,T5,T6
 D T30,T31
 K ^ZZLEXX("ZZLEXXR",$J,"DUPES"),SOS("ERR",757.01)
 D:+($G(STAT))>0 AP(" OK",70)
 N DETAIL,DUPES,ICD9,SOS
 Q
EN2 ; Expressions (one)
 N ONE,NOUPD,FULL S FULL="" S ONE=757.01,NOUPD="" D EN,OUT
 Q
T1 ;  1  Expression Input Transform in 757.01
 N CTL S CTL=$$CTL($G(EXP))
 I $L($G(EXP))>4000!(CTL>1) D
 . N INC,TXT S TXT=""
 . I $L($G(EXP))>4000 D
 . . S TXT="  Expression #"_DA_" exceeds 4000 characters"
 . I +CTL>0 D
 . . S TXT="  Expression #"_DA_" contains "_CTL_" control character"_$S(CTL>1:"s",1:"")
 . I $L(TXT) D
 . . D TL(TXT) S INC=$$INC(1),STAT=0 S TOTERR=+($G(TOTERR))+1
 . . S TXT="Expression"_$S(+INC>1:"s",1:"")_" failed FileMan's Input Transformation"
 . . S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.01,1,"T")=TXT
 Q
T2 ;  2  No Major Concept Pointer to file 757
 I $L($G(MC)),'$D(^LEX(757,MC,0)) D
 . N INC,TXT S TXT=""
 . I +MC'=MC D
 . . S TXT="  Expression #"_DA_" with invalid pointer to Major Concept Map file"
 . I +MC=MC,'$D(^LEX(757,MC,0)) D
 . . S TXT="  Expression #"_DA_" points to missing Major Concept Map entry"
 . I $L(TXT) D
 . . D TL(TXT) S INC=$$INC(2),SOS("ERR",757.01,2)="",STAT=0 S TOTERR=+($G(TOTERR))+1
 . . S TXT="Expression"_$S(+INC>1:"s have",1:" has")_" an invalid Major Concept Map pointer"
 . . S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.01,2,"T")=TXT
 Q
T3 ;  3  Major Concept Expression not pointed to by file 757
 Q:$D(SOS("ERR",757.01,2))
 I +($G(OTY))=1 D
 . ; change to next line [fjf]
 . I MCE'=DA,INA'=1 D
 . . N INC,TXT S INC=$$INC(3),STAT=0
 . . S TXT="Major Concept Expression"_$S(+INC>1:"s are",1:" is")_" not pointed to by file 757"
 . . S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.01,3,"T")=TXT
 . . S TXT="  Major Concept Expression #"_DA_" not pointed to by file 757"
 . . D TL(TXT) S TOTERR=+($G(TOTERR))+1
 Q
T4 ;  4  Major Concept Expression missing in file 757.01
 I '$L($G(MCEE)) D
 . N INC,TXT S INC=$$INC(4),STAT=0
 . S TXT="Expression"_$S(+INC>1:"s are",1:" is")_" missing the Major Concept Expression (text)"
 . S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.01,4,"T")=TXT
 . S TXT="  Expression #"_DA_" is missing the Major Concept Expression (text)"
 . D TL(TXT) S TOTERR=+($G(TOTERR))+1
 Q
T5 ;  5  Synonym/Lexical Variant does not have a Major Concept
 I +($G(NTY))'=1,$L($G(OTYT)) D
 . N INC,TXT S INC=$$INC(5),STAT=0
 . S TXT="Synonym"_$S(+INC>1:"s",1:"")_"/Variant"_$S(+INC>1:"s do",1:" does")_" not have a Major Concept expression"
 . S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.01,5,"T")=TXT
 . S TXT="  "_OTYT_" #"_DA_" does not have a Major Concept expression"
 . D TL(TXT) S TOTERR=+($G(TOTERR))+1
 Q
T6 ;  6  One Expression is a Duplicate of another Expression
 Q:'$D(DUPES)  N IEN2,IENS,IENB,EXP,UEXP,OEXP,TEXP,CEXP,TXT
 S DA=+($G(DA)),IEN2=0,EXP=$P($G(^LEX(757.01,+DA,0)),"^",1)
 Q:'$L(EXP)  Q:+($P($G(^LEX(757.01,+DA,1)),"^",2))'=1
 S UEXP=$$UP^XLFSTR(EXP)
 S:$L(UEXP)>63 OEXP=$E(UEXP,1,62)_$C($A($E(UEXP,63))-1)_"~",CEXP=$E(UEXP,1,63)
 S:$L(UEXP)'>63 OEXP=$E(UEXP,1,($L(UEXP)-1))_$C($A($E(UEXP,$L(UEXP)))-1)_"~",CEXP=$E(UEXP,1,63)
 Q:'$L(OEXP)  Q:$D(^ZZLEXX("ZZLEXXR",$J,"DUPES","C",CEXP))
 K IENS F  S OEXP=$O(^LEX(757.01,"B",OEXP)) Q:OEXP=""  Q:OEXP'[CEXP  D
 . S IEN2=0 F  S IEN2=$O(^LEX(757.01,"B",OEXP,IEN2)) Q:+IEN2=0  D
 . . Q:$D(IENS(IEN2))  Q:+IEN2=+DA
 . . Q:+($P($G(^LEX(757.01,+IEN2,1)),"^",2))'=1
 . . S TEXP=$$UP^XLFSTR($P($G(^LEX(757.01,+IEN2,0)),"^",1)) Q:'$L(TEXP)
 . . I TEXP=UEXP S IENS(0)=+($G(IENS(0)))+1,IENS(IEN2)=""
 S ^ZZLEXX("ZZLEXXR",$J,"DUPES","C",CEXP)=""
 S IENB="",IEN2=0 F  S IEN2=$O(IENS(IEN2)) Q:+IEN2=0  D
 . S:("/"_IENB_"/")'[("/"_IEN2_"/") IENB=IENB_"/"_IEN2
 F  Q:$E(IENB,1)'="/"  S IENB=$E(IENB,2,$L(IENB))
 F  Q:$E(IENB,$L(IENB))'="/"  S IENB=$E(IENB,1,($L(IENB)-1))
 I $L(IENB) D
 . N INC,TXT S INC=$$INC(6),STAT=0
 . S TXT="Expression"_$S(+INC>1:"s have duplicated entries",1:" has a duplicate entry")_" (duplicates not allowed)"
 . S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.01,6,"T")=TXT
 . S TXT="  Expression #"_DA_" duplicated by Expression"_$S(IENB["/":"s #",1:" #")_IENB
 . D TL(TXT) S TOTERR=+($G(TOTERR))+1
 I +($G(IENS(0)))>0 D
 . S ^ZZLEXX("ZZLEXXR",$J,"DUPES",DA)=UEXP
 . S ^ZZLEXX("ZZLEXXR",$J,"DUPES",0)=+($G(^ZZLEXX("ZZLEXXR",$J,"DUPES",0)))+1
 Q
T30 ; 30  ICD-10-CM Diagnosis Preferred Terms
 N ORD,CT,PS,CH S (CT,PS,CH)=0,ORD=""
 F  S ORD=$O(^ICD9("ABA",30,ORD)) Q:'$L(ORD)  D
 . N IIEN S IIEN=0 F  S IIEN=$O(^ICD9("ABA",30,ORD,IIEN)) Q:+IIEN'>0  D
 . . N CDT,SIEN,LIEN,LEXT,ICDT,HIEN,DEIN,INC,NUM,CODE,SAB,FD,FDT,TXT S CDT=9999999,SAB="10D"
 . . S CODE=$P($G(^ICD9(+IIEN,0)),"^",1) Q:'$L(CODE)
 . . S CDT=$O(^ICD9(+IIEN,68,"B",CDT),-1) Q:CDT'?7N
 . . S HIEN=$O(^ICD9(+IIEN,68,"B",+CDT," "),-1) Q:+HIEN'>0
 . . S ICDT=$G(^ICD9(+IIEN,68,+HIEN,1)) Q:'$L(ICDT)
 . . I $$UP^XLFSTR(ICDT)=ICDT D
 . . . N DA,DIK S ICDT=$$MIX^LEXXMC(ICDT)
 . . . S DA(1)=+IIEN,DA=+HIEN,DIK="^ICD9("_+IIEN_",68," D IX2^DIK
 . . . S ^ICD9(+IIEN,68,+HIEN,1)=ICDT
 . . . S DA(1)=+IIEN,DA=+HIEN,DIK="^ICD9("_+IIEN_",68," D IX1^DIK
 . . S FDT=$$FMADD^XLFDT(CDT,1)
 . . S STAT=$$STATCHK^LEXSRC2(CODE,FDT,,"10D")
 . . S SIEN=$P(STAT,"^",2) Q:+SIEN'>0
 . . S LIEN=+($G(^LEX(757.02,+SIEN,0))) Q:+LIEN'>0
 . . S LEXT=$G(^LEX(757.01,+LIEN,0)) Q:$$UP^XLFSTR(ICDT)=$$UP^XLFSTR(LEXT)
 . . S TXT="  ICD-10-CM Expression #"_LIEN_" does not match ICD-10-CM Description #"_IIEN
 . . D:'$D(FIX) TL(TXT) S INC=$$INC(30),STAT=0 S TOTERR=+($G(TOTERR))+1
 . . S TXT="ICD-10-CM Expression"_$S(INC>1:"s do",1:" does")_" not match the ICD-10-CM Description"
 . . S:'$D(FIX) ^ZZLEXX("ZZLEXXR",$J,"TOT",757.01,30,"T")=TXT
 . . W:'$D(ZTQUEUED)&('$D(FIX)) !,IIEN,?8,ICDT,!,LIEN,?8,LEXT,!
 . . W:$D(MIX)&('$D(RELVER))&('$D(FIX)) ?8,$$MIX^LEXXMC(ICDT),!
 . . S CT=CT+1
 . . Q:$$UP^XLFSTR(ICDT)=ICDT
 . . S PS=PS+1
 . . I $D(FIX) D
 . . . N TERM,UP S TERM=$G(ICDT),UP=0 S:$$UP^XLFSTR(TERM)=ICDT TERM=$$MIX^LEXXMC(TERM),UP=1
 . . . W !!,"- ",$G(^LEX(757.01,+LIEN,0))
 . . . W !,"- ",ICDT
 . . . W:UP>0 !,"- ",TERM
 . . . Q:'$D(FIX)  S:$D(COMMIT)&(+($G(LIEN))>0) ^LEX(757.01,+LIEN,0)=ICDT S CH=CH+1
 I $D(COUNT) W !! ZW CT,PS,CH N COUNT
 K:$D(FIX) ^ZZLEXX("ZZLEXXR",$J,"TOT") N FIX,MIX,RELVER,COMMIT
 Q
T31 ; 31  ICD-10-PCS Procedure Preferred Terms
 N ORD,CT,INC,NUM,PS,CH,TXT S (CT,PS,CH)=0,ORD=""
 S ORD="" F  S ORD=$O(^ICD0("ABA",31,ORD)) Q:'$L(ORD)  D
 . N IIEN S IIEN=0 F  S IIEN=$O(^ICD0("ABA",31,ORD,IIEN)) Q:+IIEN'>0  D
 . . N CDT,SIEN,LIEN,LEXT,ICDT,HIEN,DEIN,CODE,SAB,FD,FDT S CDT=9999999,SAB="10D"
 . . S CODE=$P($G(^ICD0(+IIEN,0)),"^",1) Q:'$L(CODE)
 . . S CDT=$O(^ICD0(+IIEN,68,"B",CDT),-1) Q:CDT'?7N
 . . S HIEN=$O(^ICD0(+IIEN,68,"B",+CDT," "),-1) Q:+HIEN'>0
 . . S ICDT=$G(^ICD0(+IIEN,68,+HIEN,1)) Q:'$L(ICDT)
 . . I $$UP^XLFSTR(ICDT)=ICDT D
 . . . N DA,DIK S ICDT=$$MIX^LEXXMC(ICDT)
 . . . S DA(1)=+IIEN,DA=+HIEN,DIK="^ICD0("_+IIEN_",68," D IX2^DIK
 . . . S ^ICD0(+IIEN,68,+HIEN,1)=ICDT
 . . . S DA(1)=+IIEN,DA=+HIEN,DIK="^ICD0("_+IIEN_",68," D IX1^DIK
 . . S FDT=$$FMADD^XLFDT(CDT,1)
 . . S STAT=$$STATCHK^LEXSRC2(CODE,FDT,,"10P")
 . . S SIEN=$P(STAT,"^",2) Q:+SIEN'>0
 . . S LIEN=+($G(^LEX(757.02,+SIEN,0))) Q:+LIEN'>0
 . . S LEXT=$G(^LEX(757.01,+LIEN,0))
 . . Q:$$UP^XLFSTR(ICDT)=$$UP^XLFSTR(LEXT)
 . . S TXT="  ICD-10-PCS Expression #"_LIEN_" does not match ICD-10-PCS Description #"_IIEN
 . . D:'$D(FIX) TL(TXT) S INC=$$INC(31),STAT=0 S TOTERR=+($G(TOTERR))+1
 . . S TXT="ICD-10-PCS Expression"_$S(INC>1:"s do",1:" does")_" not match the ICD-10-PCS Description"
 . . S:'$D(FIX) ^ZZLEXX("ZZLEXXR",$J,"TOT",757.01,31,"T")=TXT
 . . W:'$D(ZTQUEUED)&('$D(FIX)) !,IIEN,?8,ICDT,!,LIEN,?8,LEXT,!
 . . W:$D(MIX)&('$D(RELVER))&('$D(FIX)) ?8,$$MIX^LEXXMC(ICDT),!
 . . S CT=CT+1
 . . Q:$$UP^XLFSTR(ICDT)=ICDT
 . . S PS=PS+1
 . . I $D(FIX) D
 . . . N TERM,UP S TERM=$G(ICDT),UP=0 S:$$UP^XLFSTR(TERM)=ICDT TERM=$$MIX^LEXXMC(TERM),UP=1
 . . . W !!,"- ",$G(^LEX(757.01,+LIEN,0))
 . . . W !,"- ",ICDT
 . . . W:UP>0 !,"- ",TERM
 . . . Q:'$D(FIX)  S:$D(COMMIT)&(+($G(LIEN))>0) ^LEX(757.01,+LIEN,0)=ICDT S CH=CH+1
 I $D(COUNT) W !! ZW CT,PS,CH N COUNT
 K:$D(FIX) ^ZZLEXX("ZZLEXXR",$J,"TOT") N FIX,MIX,RELVER,COMMIT
 Q
INC(X) ; Increment Error
 N ID S ID=+($G(X)) Q:+ID'>0 ""  S X=+($G(^ZZLEXX("ZZLEXXR",$J,"TOT",757.01,ID)))+1 S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.01,ID)=+X
 Q X
INI ; Initialize Totals
 N TXT,I F I=1:1:12 K ^ZZLEXX("ZZLEXXR",$J,"TOT",757.01,I)
 S TXT="All Expressions pass the FileMan's Input Transformation" S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.01,1,"T")=TXT
 S TXT="All Expressions point to a Major Concept Map entry" S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.01,2,"T")=TXT
 S TXT="All Concepts have a Major Concept Map entry  (REQUIRED|ONE TO ONE)" S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.01,3,"T")=TXT
 S TXT="All Expressions have Major Concept Expressions (text)" S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.01,4,"T")=TXT
 S TXT="All Synonyms/Variants have a Major Concept   (REQUIRED|MANY TO ONE)" S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.01,5,"T")=TXT
 I $D(DUPES) D
 . S TXT="All Expression are unique (no duplicates)" S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.01,6,"T")=TXT
 S TXT="All ICD-10 Diagnosis Preferred Terms match the ICD-10-CM Descriptions" S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.01,30,"T")=TXT
 S TXT="All ICD-10 Procedure Preferred Terms match the ICD-10-PCS Descriptions" S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.01,31,"T")=TXT
 Q
CTL(X) ; Control Characters
 N TXT S TXT=$G(X) N I,CHR S X=0 F I=1:1 S CHR=$E($G(X),I) Q:'$L(CHR)  I $A(CHR)<32!($A(CHR)>126) S X=X+1
 Q X
ST ; Show Global
 W !,"  " N NN,NC,ND S NN="^ZZLEXX(""ZZLEXXR"","_$J_",""TOT"",757.01)",NC="^ZZLEXX(""ZZLEXXR"","_$J_",""TOT"",757.01,"
 F  S NN=$Q(@NN) Q:NN=""!(NN'[NC)  D
 . S ND=@NN  W ND W:+ND'>0 !,"  " W:+ND>0 " "
 Q
FIX ; Remove Spaces from Expression
 N IEN,EXP,TRM S IEN=0 F  S IEN=$O(^LEX(757.01,IEN)) Q:+IEN=0  D
 . S EXP=$P($G(^LEX(757.01,IEN,0)),"^",1),TRM=$E($$TRIM(EXP),1,4000) Q:EXP=TRM
 . S $P(^LEX(757.01,IEN,0),"^",1)=TRM
 Q
TRIM(X) ; Trim Spaces
 S X=$G(X) F  Q:$E(X,1)'=" "  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=" "  S X=$E(X,1,($L(X)-1))
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
 S ^ZZLEXX("ZZLEXXR",$J,"DRAFT",C)=T
 Q
OUT ;
 Q:'$D(ONE)  Q:ONE'="757.01"  N TST
 W !!,"  EXPRESSIONS                           ^LEX(757.01,     #757.01"
 S TST=0 F  S TST=$O(^ZZLEXX("ZZLEXXR",$J,"TOT",757.01,TST)) Q:+TST'>0  D
 . N CT,TX S CT=$G(^ZZLEXX("ZZLEXXR",$J,"TOT",757.01,TST)),TX=$G(^ZZLEXX("ZZLEXXR",$J,"TOT",757.01,TST,"T"))
 . W !,?5 W:+CT>0 +CT," " W TX
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",757.01)
 Q
TL(X) ; Text Line
 W:'$D(ZTQUEUED) !,$G(X) Q:'$D(ZTQUEUED)
 N C S C=+($G(^ZZLEXX("ZZLEXXR",$J,"DRAFT",0))),C=C+1
 S ^ZZLEXX("ZZLEXXR",$J,"DRAFT",C)=$G(X),^ZZLEXX("ZZLEXXR",$J,"DRAFT",0)=C
 N ZTQUEUES Q
OK(X,Y) ; Control
 N SI,SR,TD,ND,EF,HS,ST,PF S SI=+($G(X)) Q:+SI'>0 0  S:$G(DT)?7N TD=DT  S:$G(TD)'?7N TD=$$DT^XLFDT
 S ND=$G(^LEX(757.02,+SI,0)) Q:'$L(ND) 0  S SR=+($G(Y)) Q:SR'>0 0  Q:'$D(^LEX(757.03,SR,0)) 0
 Q:$P(ND,"^",3)'=SR 0  Q:$P(ND,"^",5)'>0 0  S EF=$O(^LEX(757.02,SI,4,"B",(TD+.001)),-1)
 S HS=$O(^LEX(757.02,SI,4,"B",+EF," "),-1),ST=$P($G(^LEX(757.02,+SI,4,+HS,0)),"^",2) Q:ST'>0 0
 Q 1
