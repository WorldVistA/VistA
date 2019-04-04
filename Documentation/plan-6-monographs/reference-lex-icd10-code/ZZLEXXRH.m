ZZLEXXRH ;SLC/KER - Import - Rel Verify - 757.02 (1-7) ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^LEX(757.03         SACC 1.3
 ;    ^ZZLEXX("ZZLEXXR")  SACC 1.3
 ;               
 ; External References
 ;    None
 ;               
 ; Local Variables NEWed or KILLed Elsewhere
 ;     CODE,SRC,STAT,TOTERR,ZTQUEUED
 ;               
 Q
EN ; Codes - 757.02 (Test 1 to 9)
 D T1,T2,T3,T4,T5,T6,T7
 Q
T1 ;  1  Every code has 1 activation date
 D SOS N FLA S FLA=$$FA("") ZW SOS,FLA I +($G(FLA))'>0 D
 . N CCS,INC,TXT S INC=$$INC(1),SOS("ERR","T1")="",STAT=0
 . S TXT="Code"_$S(+INC>1:"s were",1:" was")_" found without an ACTIVE status/date"
 . S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,1,"T")=TXT,CCS=$$CCS(+SRC)
 . S TXT="  "_CCS_" code "_CODE_" does not have an activation date"
 . D TL(TXT) S TOTERR=+($G(TOTERR))+1
 Q
T2 ;  2  Every Code as 1 valid activation history
 Q:$D(SOS("ERR","T1"))  D SOS I '$D(SOS("HIS")) D
 . N CCS,INC,TXT S INC=$$INC(2),SOS("ERR","T2")="",STAT=0
 . S TXT="Code"_$S(+INC>1:"s",1:"")_" do"_$S(+INC=1:"es",1:"")_" not have a valid activation history"
 . S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,2,"T")=TXT,CCS=$$CCS(+SRC)
 . S TXT="  "_CCS_" code "_CODE_" does not have a valid activation history"
 . D TL(TXT) S TOTERR=+($G(TOTERR))+1
 Q
T3 ;  3  The first status/date must be an ACTIVATION
 D SOS N FLA,FLI S FLA=$$FA(""),FLI=$$FI("") I FLI>0,FLI<FLA D
 . N CCS,INC,TXT S INC=$$INC(3),SOS("ERR","T3")="",STAT=0
 . S TXT="Histor"_$S(+INC>1:"ies have",1:"y has")_" an INACTIVE status before the ACTIVE status"
 . S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,3,"T")=TXT,CCS=$$CCS(+SRC)
 . S TXT="  "_CCS_" code "_CODE_" History has an INACTIVE status before the ACTIVE status"
 . D TL(TXT) S TOTERR=+($G(TOTERR))+1
 Q
T4 ;  4  Initial Activation Date must match ICD-9 Diagnosis File
 Q  Q:$D(SOS("ERR","T1"))  D SOS Q:'$D(SOS("ICD"))  Q:+($G(SRC))'=1
 N FLA,FSA S FSA=$$FA("ICD"),FLA=$$AL(FSA)
 I +FSA>0,FLA'>0 D
 . N CCS,INC,TXT S INC=$$INC(4),SOS("ERR","T4")="",STAT=0
 . S TXT="ICD-9-CM initial activation date"_$S(+INC>1:"s do",1:" does")_" not match the Lexicon"
 . S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,4,"T")=TXT,CCS=$$CCS(+SRC)
 . S TXT="  "_CCS_" code "_CODE_" initial activation date does not match the Lexicon"
 . D TL(TXT) S TOTERR=+($G(TOTERR))+1
 Q
T5 ;  5  Initial Activation Date must match ICD-9 Procedure File
 Q  Q:$D(SOS("ERR","T1"))  D SOS Q:'$D(SOS("ICP"))  Q:+($G(SRC))'=2
 N FLA,FSA S FSA=$$FA("ICP"),FLA=$$AL(FSA)
 I +FSA>0,FLA'>0 D
 . N CCS,INC,TXT S INC=$$INC(5),SOS("ERR","T5")="",STAT=0
 . S TXT="ICD-9-OP initial activation date"_$S(+INC>1:"s do",1:" does")_" not match the Lexicon"
 . S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,5,"T")=TXT,CCS=$$CCS(+SRC)
 . S TXT="  "_CCS_" code "_CODE_" initial activation date does not match the Lexicon"
 . D TL(TXT) S TOTERR=+($G(TOTERR))+1
 Q
T6 ;  6  Initial Activation Date must match ICD-10-CM File
 Q:$D(SOS("ERR","T1"))  D SOS Q:'$D(SOS("10D"))  Q:+($G(SRC))'=30
 N FLA,FSA S FSA=$$FA("10D"),FLA=$$AL(FSA)
 I +FSA>0,FLA'>0 D
 . N CCS,INC,TXT S INC=$$INC(6),SOS("ERR","T6")="",STAT=0
 . S TXT="ICD-10-CM initial activation date"_$S(+INC>1:"s do",1:" does")_" not match the Lexicon"
 . S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,6,"T")=TXT,CCS=$$CCS(+SRC)
 . S TXT="  "_CCS_" code "_CODE_" initial activation date does not match the Lexicon"
 . D TL(TXT) S TOTERR=+($G(TOTERR))+1
 Q
T7 ;  7  Initial Activation Date must match ICD-10-PCS File
 Q:$D(SOS("ERR","T1"))  D SOS Q:'$D(SOS("10P"))  Q:+($G(SRC))'=31
 N FLA,FSA S FSA=$$FA("10P"),FLA=$$AL(FSA)
 I +FSA>0,FLA'>0 D
 . N CCS,INC,TXT S INC=$$INC(7),SOS("ERR","T7")="",STAT=0
 . S TXT="ICD-10-PCS initial activation date"_$S(+INC>1:"s do",1:" does")_" not match the Lexicon"
 . S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,7,"T")=TXT,CCS=$$CCS(+SRC)
 . S TXT="  "_CCS_" code "_CODE_" initial activation date does not match the Lexicon"
 . D TL(TXT) S TOTERR=+($G(TOTERR))+1
 Q
 ;                       
SOS ; Source Array SOS
 Q:$D(SOS)  Q:'$L($G(CODE))  Q:'$L($G(SRC))  Q:+($G(SRC))'>0
 K SOS D ARY^ZZLEXXRF(CODE,+SRC,.SOS)
 Q
FA(X) ; First Activation
 N AD,IEN,SRN S (IEN,AD)=0,SRN=$G(X),X="" I '$L(SRN) D  Q X
 . S X="" F  S IEN=$O(SOS("ACT",IEN)) Q:+IEN=0  D
 . . S AD=0 F  S AD=$O(SOS("ACT",+IEN,1,AD)) Q:+AD=0  S:+X=0 X=AD S:AD<X X=AD
 . . S AD=0 F  S AD=$O(SOS("ACT",+IEN,3,AD)) Q:+AD=0  S:+X=0 X=AD S:AD<X X=AD
 F  S IEN=$O(SOS(SRN,"ACT",IEN)) Q:+IEN=0  D
 . S AD=0 F  S AD=$O(SOS(SRN,"ACT",+IEN,1,AD)) Q:+AD=0  S:+X=0 X=AD S:AD<X X=AD
 Q X
FI(X) ; First Inactivation
 N AD,IEN,SRN S (IEN,AD)=0,SRN=$G(X),X="" I '$L(SRN) D  Q X
 . S X="" F  S IEN=$O(SOS("ACT",IEN)) Q:+IEN=0  D
 . . S AD=0 F  S AD=$O(SOS("ACT",+IEN,0,AD)) Q:+AD=0  S:+X=0 X=AD S:AD<X X=AD
 . . S AD=0 F  S AD=$O(SOS("ACT",+IEN,2,AD)) Q:+AD=0  S:+X=0 X=AD S:AD<X X=AD
 F  S IEN=$O(SOS(SRN,"ACT",IEN)) Q:+IEN=0  D
 . S AD=0 F  S AD=$O(SOS(SRN,"ACT",+IEN,0,AD)) Q:+AD=0  S:+X=0 X=AD S:AD<X X=AD
 Q X
LI(X) ; Last Inactivation
 N AD,IEN,SRN S (IEN,AD)=0,SRN=$G(X),X="" I '$L(SRN) D  Q X
 . S X="" F  S IEN=$O(SOS("ACT",IEN)) Q:+IEN=0  D
 . . S AD=0 F  S AD=$O(SOS("ACT",+IEN,0,AD)) Q:+AD=0  S:+X=0 X=AD S:AD>X X=AD
 . . S AD=0 F  S AD=$O(SOS("ACT",+IEN,2,AD)) Q:+AD=0  S:+X=0 X=AD S:AD>X X=AD
 F  S IEN=$O(SOS(SRN,"ACT",IEN)) Q:+IEN=0  D
 . S AD=0 F  S AD=$O(SOS(SRN,"ACT",+IEN,0,AD)) Q:+AD=0  S:+X=0 X=AD S:AD>X X=AD
 Q X
AL(X) ; Activation Date is in Lexicon
 N AD,IEN,OK S AD=+($G(X)) Q:AD'>0 0
 S (IEN,OK)=0  F  S IEN=$O(SOS("HIS",IEN)) Q:+IEN=0  D  Q:OK
 . S:$D(SOS("HIS",IEN,AD)) OK=1
 S X=OK Q X
INC(X) ; Increment Error
 N ID S ID=+($G(X)) Q:+ID'>0 ""  S X=+($G(^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,ID)))+1,^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,ID)=+X
 Q X
INI ; Initialize Totals
 N TXT S TXT="Each code has at least one ACTIVE status/date"
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,1) S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,1,"T")=TXT
 S TXT="Each code has at least one valid activation history"
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,2) S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,2,"T")=TXT
 S TXT="All valid histories have an ACTIVE status as the first status"
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,3) S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,3,"T")=TXT
 S TXT="All ICD-10-CM initial activation dates match the Lexicon"
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,6) S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,6,"T")=TXT
 S TXT="All ICD-10-PCS initial activation dates match the Lexicon"
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,7) S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,7,"T")=TXT
 Q
 S TXT="All ICD-9-CM initial activation dates match the Lexicon"
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,4) S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,4,"T")=TXT
 S TXT="All ICD-9-OP initial activation dates match the Lexicon"
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,5) S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,5,"T")=TXT
 S TXT="All CPT-4 initial activation dates match the Lexicon"
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,8) S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,8,"T")=TXT
 S TXT="All HCPCS initial activation dates match the Lexicon"
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,9) S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,9,"T")=TXT
 Q
CCS(X) ; Classification System
 Q $P($G(^LEX(757.03,+($G(X)),0)),"^",2)
BL ; Blank Line
 D TL("") Q
TL(X) ; Text Line
 W:'$D(ZTQUEUED) !,$G(X) Q:'$D(ZTQUEUED)
 N C S C=+($G(^ZZLEXX("ZZLEXXR",$J,"DRAFT",0))),C=C+1
 S ^ZZLEXX("ZZLEXXR",$J,"DRAFT",C)=$G(X),^ZZLEXX("ZZLEXXR",$J,"DRAFT",0)=C Q
