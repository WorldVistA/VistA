ZZLEXXRJ ;SLC/KER - Import - Rel Verify - 757.02 (12-17) ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^LEX(757            SACC 1.3
 ;    ^LEX(757.01         SACC 1.3
 ;    ^LEX(757.02         SACC 1.3
 ;    ^LEX(757.03         SACC 1.3
 ;    ^ZZLEXX("ZZLEXXR")  SACC 1.3
 ;               
 ; External References
 ;    HOME^%ZIS           ICR  10086
 ;    $$STATCHK^ICDAPIU   ICR   3991
 ;    $$STATCHK^ICDEX     ICR   5747
 ;    $$STATCHK^LEXSRC2   N/A
 ;    $$IMPDATE^LEXU      N/A
 ;    $$DT^XLFDT          ICR  10103
 ;               
 ; Local Variables NEWed or KILLed Elsewhere
 ;     EMP,EXP,MCP,MEP,STAT,TOTERR,ZTQUEUED
 ;               
 Q
EN ; Codes - 757.02 (Test 12 to 17)
 D T12,T13,T15,T17
 Q
T12 ; 12  ACTIVE history Expression is NOT DEACTIVATED
 Q:"^1^2^3^4^30^31^"'[("^"_+($G(SRC))_"^")
 N AEXD,CCS,ED,ED,EIEN,IEN,INC,LEXC,PFT,SAB,SIEN,TXT
 S SAB=$E($G(^LEX(757.03,+SRC,0)),1,3) Q:'$L(SAB)
 S LEXC=$$STATCHK^LEXSRC2($G(CODE),$G(DT),,SAB)
 S CCS=$$CCS(+($G(SRC))),SIEN=$$SIEN(CODE,SRC)
 S EIEN=+($P($G(^LEX(757.02,+($G(SIEN)),0)),"^",1))
 S AEXD=$P($G(^LEX(757.01,+($G(EIEN)),1)),"^",5)
 I +LEXC>0,+EIEN>0,+AEXD>0 D
 . N INC,TXT,CCS S INC=$$INC(12),SOS("ERR","T12")="",CCS=$$CCS(+SRC),STAT=0
 . S TXT="Deactivated expression"_$S(+INC>1:"s are",1:" is")_" linked to an active code"
 . S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,12,"T")=TXT
 . S TXT="  Deactivated expression #"_+EIEN_" linked to active "_CCS_" code "_CODE
 . D TL(TXT) S TOTERR=+($G(TOTERR))+1
 Q
T13 ; 13  ICD 9 Dx     STATCHK^LEXSRC2 equals STATCHK^ICDAPIU
T14 ; 14  ICD 9 Proc   STATCHK^LEXSRC2 equals STATCHK^ICDAPIU
 Q  Q:"^1^2^"'[("^"_+($G(SRC))_"^")  N CCS,ICDC,INC,LEXC,TXT,SAB
 S SAB=$E($G(^LEX(757.03,+SRC,0)),1,3) Q:'$L(SAB)
 S LEXC=$$STATCHK^LEXSRC2($G(CODE),$G(DT),,SAB)
 S ICDC=$$STATCHK^ICDAPIU($G(CODE),$G(DT))
 I +($G(SRC))=1,+LEXC'=+ICDC D
 . N INC,TXT,CCS S INC=$$INC(13),SOS("ERR","T13")="",STAT=0
 . S TXT="ICD DX Code"_$S(+INC>1:"s have",1:" has")_" a Status in the Lexicon not equal to file 80"
 . S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,13,"T")=TXT,CCS=$$CCS(+SRC)
 . S TXT="  "_CCS_" Code "_CODE_" Status in the Lexicon ("_+LEXC_") not equal to SDO ("_+ICDC_")"
 . D TL(TXT) S TOTERR=+($G(TOTERR))+1
 I +($G(SRC))=2,+LEXC'=+ICDC D
 . N INC,TXT,CCS S INC=$$INC(14),SOS("ERR","T14")=""
 . S TXT="ICD Proc Code"_$S(+INC>1:"s have",1:" has")_" a Status in the Lexicon not equal to file 80.1"
 . S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,14,"T")=TXT,CCS=$$CCS(+SRC)
 . S TXT="  "_CCS_" Code "_CODE_" Status in the Lexicon ("_+LEXC_") not equal to SDO ("_+ICDC_")"
 . D TL(TXT) S TOTERR=+($G(TOTERR))+1
 Q
T15 ; 15  ICD 10 Dx    STATCHK^LEXSRC2 equals STATCHK^ICDEX
T16 ; 16  ICD 10 Proc  STATCHK^LEXSRC2 equals STATCHK^ICDEX
 Q:"^30^31^"'[("^"_+($G(SRC))_"^")  N LEXEXC,LEXTXT
 S LEXEXC="S LEXTXT=$L($T(STATCHK^ICDEX))" X LEXEXC  Q:'$L($G(LEXTXT))
 N CCS,ICDC,INC,LEXC,TXT,SAB,CDT,IMP S IMP=$$IMPDATE^LEXU(30)
 S SAB=$E($G(^LEX(757.03,+SRC,0)),1,3) Q:'$L(SAB)  S CDT=DT S:+CDT'>IMP CDT=IMP
 S LEXC=$$STATCHK^LEXSRC2($G(CODE),$G(CDT),,SAB)
 S ICDC=$$STATCHK^ICDEX(CODE,$G(CDT),+SRC) X LEXEXC
 I +($G(SRC))=30,+LEXC'=+ICDC D
 . N INC,TXT,CCS S INC=$$INC(13),SOS("ERR","T13")="",STAT=0
 . S TXT="ICD DX Code"_$S(+INC>1:"s have",1:" has")_" a Status in the Lexicon not equal to file 80"
 . S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,13,"T")=TXT,CCS=$$CCS(+SRC)
 . S TXT="  "_CCS_" Code "_CODE_" Status in the Lexicon ("_+LEXC_") not equal to SDO ("_+ICDC_")"
 . D TL(TXT) S TOTERR=+($G(TOTERR))+1
 I +($G(SRC))=31,+LEXC'=+ICDC D
 . N INC,TXT,CCS S INC=$$INC(14),SOS("ERR","T14")=""
 . S TXT="ICD Proc Code"_$S(+INC>1:"s have",1:" has")_" a Status in the Lexicon not equal to file 80.1"
 . S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,14,"T")=TXT,CCS=$$CCS(+SRC)
 . S TXT="  "_CCS_" Code "_CODE_" Status in the Lexicon ("_+LEXC_") not equal to SDO ("_+ICDC_")"
 . D TL(TXT) S TOTERR=+($G(TOTERR))+1
 Q
T17 ; 17  Expression point to the correct Major Concept
 N MCE,EMCE
 S EXP=$G(EXP),EMP=$G(EMP),MCP=$G(MCP),MEP=$G(MEP),EMCE=$G(EMCE),MCE=$G(MCE),SOI=$G(SOI),CODE=$G(CODE) Q:'$L(CODE)
 I +EMCE>0,+EMCE'=+MCE D  Q
 . N INC,TXT,CCS S INC=$$INC(19),SOS("ERR","T17")=""
 . S TXT="Code"_$S(+INC>1:"s have",1:" has")_" an Expression (.01) not pointed to by the Major Concept (3)"
 . S TXT="Expression #"_EXP_" for code "_CODE_" #"_SOI_" not pointed to by Concept #"_MCP
 . S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,19,"T")=TXT,CCS=$$CCS(+SRC)
 . S TXT="  Expression #"_EXP_" for code "_CODE_" #"_SOI_" does not pointed to by Concept #"_MCP
 . D TL(TXT) S TOTERR=+($G(TOTERR))+1
 Q
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
 ;                    
SOS ; Source Array SOS
 Q:$D(SOS)  Q:'$L($G(CODE))  Q:'$L($G(SRC))  Q:+($G(SRC))'>0
 K SOS D ARY^ZZLEXXRF(CODE,+SRC,.SOS)
 Q
INC(X) ; Increment Error
 N ID S ID=+($G(X)) Q:+ID'>0 ""  S X=+($G(^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,ID)))+1,^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,ID)=+X
 Q X
INI ; Initialize Totals
 N TXT S TXT="Each ACTIVE History has an Expression NOT flagged as DEACTIVATED"
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,12) S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,12,"T")=TXT
 S TXT="Each ICD DX code in the Lexicon has a status identical to file 80"
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,13) S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,13,"T")=TXT
 S TXT="Each ICD Proc code in the Lexicon has a status identical to file 80.1"
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,14) S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,14,"T")=TXT
 S TXT="Each Coded Expression points to the correct Coded Major Concept"
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,19) S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,19,"T")=TXT
 Q
FIX ; Remove Expression DEACTIVE flag for ACTIVE preferred term
 N LEXC,SIEN,EIEN,AEXD,CODE,SO,SOI,SRC S U="^",DT=$$DT^XLFDT D HOME^%ZIS
 S SO="" F  S SO=$O(^LEX(757.02,"CODE",SO)) Q:SO=""  D
 . K CS S SOI=0 F  S SOI=$O(^LEX(757.02,"CODE",SO,SOI)) Q:SOI=""  D
 . . N LEXC,SIEN,EIEN,AEXD,PREF S CODE=$$CODE(SOI),SRC=$$CTY(SOI) Q:'$L(CODE)  Q:+SRC'>0
 . . Q:"^1^2^3^4^30^31^"'[("^"_+($G(SRC))_"^")  Q:$D(CS(CODE,+SRC))  S CS(CODE,+SRC)=""
 . . S LEXC=$$STATCHK^LEXSRC2($G(CODE),$G(DT))
 . . S SIEN=$$SIEN(CODE,SRC),EIEN=+($P($G(^LEX(757.02,+($G(SIEN)),0)),"^",1))
 . . S PREF=+($P($G(^LEX(757.02,+($G(SIEN)),0)),"^",5))
 . . S AEXD=$P($G(^LEX(757.01,+($G(EIEN)),1)),"^",5)
 . . I +LEXC>0,+EIEN>0,+AEXD>0 S $P(^LEX(757.01,+($G(EIEN)),1),"^",5)=""
 Q
SIEN(X,Y) ; Preferred Active Internal Entry Number
 S CODE=$G(X) Q:'$L(CODE) ""  S SRC=+($G(Y)) Q:SRC'>0 ""
 N SIEN,LD,EF,ST,PF,IEN S (IEN,SIEN)=0
 F  S SIEN=$O(^LEX(757.02,"CODE",(CODE_" "),SIEN)) Q:+SIEN=0  D  Q:IEN>0
 . Q:$P($G(^LEX(757.02,SIEN,0)),"^",3)'=SRC
 . Q:$P($G(^LEX(757.02,SIEN,0)),"^",5)'>0
 . S LD=$O(^LEX(757.02,SIEN,4,"B"," "),-1) Q:'$L(LD)
 . S EF=$O(^LEX(757.02,SIEN,4,"B",LD," "),-1) Q:'$L(EF)
 . S ST=$P($G(^LEX(757.02,SIEN,4,EF,0)),"^",2) Q:+ST'>0
 . S IEN=SIEN
 S X=$S(+IEN>0:+IEN,1:"")
 Q X
CCS(X) ; Classification System
 Q $P($G(^LEX(757.03,+($G(X)),0)),"^",2)
CTY(X) ; Code Classification Type
 Q $P($G(^LEX(757.02,+($G(X)),0)),"^",3)
CODE(X) ; Code
 Q $P($G(^LEX(757.02,+($G(X)),0)),"^",2)
BL ; Blank Line
 D TL("") Q
TL(X) ; Text Line
 W:'$D(ZTQUEUED) !,$G(X) Q:'$D(ZTQUEUED)
 N C S C=+($G(^ZZLEXX("ZZLEXXR",$J,"DRAFT",0))),C=C+1
 S ^ZZLEXX("ZZLEXXR",$J,"DRAFT",C)=$G(X),^ZZLEXX("ZZLEXXR",$J,"DRAFT",0)=C Q
