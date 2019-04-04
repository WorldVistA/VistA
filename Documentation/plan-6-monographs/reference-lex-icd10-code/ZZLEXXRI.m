ZZLEXXRI ;SLC/KER - Import - Rel Verify - 757.02 (10-11) ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^LEX(757.02         SACC 1.3
 ;    ^LEX(757.03         SACC 1.3
 ;    ^ZZLEXX("ZZLEXXR")  SACC 1.3
 ;               
 ; External References
 ;    IX1^DIK             ICR  10013
 ;    IX2^DIK             ICR  10013
 ;    $$DT^XLFDT          ICR  10103
 ;               
 ; Local Variables NEWed or KILLed Elsewhere
 ;     STAT,TOTERR,ZTQUEUED
 ;               
 Q
EN ; Codes - 757.02 (Test 10 to 11)
 D T10,T11
 Q
T10 ;  10  For each code's activation history, there is
 ;     one and only one preferred term
 D SOS N CCS,COC,COL,HIS,INC,OK,PFC,ROW,STA,TXT S STA="",OK=1,ROW=0
 F  S ROW=$O(SOS("TL","RC",ROW)) Q:+ROW=0  D
 . S COL=0 F  S COL=$O(SOS("TL","RC",ROW,COL)) Q:+COL=0  D
 . . S STA=$P($G(SOS("TL","RC",ROW,COL)),"^",3),PFC=+($P($G(SOS("TL","RC",ROW,COL)),"^",4))
 . . S:STA>0 HIS(+COL)=$G(HIS(+COL))+PFC S:STA'>0 HIS(+COL)=$G(HIS(+COL))-PFC
 S (PFC,COL,COC)=0 F  S COL=$O(HIS(COL)) Q:+COL=0  S COC=COC+1 S:+($G(HIS(COL)))>PFC PFC=+($G(HIS(COL)))
 I +PFC>1 D
 . N INC,TXT,CCS S INC=$$INC(10),SOS("ERR","T10")="",STAT=0
 . S TXT="Code"_$S(+INC>1:"s have",1:" has")_" multiple Preferred Terms for the same period"
 . S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,10,"T")=TXT,CCS=$$CCS(+SRC)
 . S TXT="  "_CCS_" code "_CODE_" has multiple Preferred Terms for the same period"
 . D TL(TXT) S TOTERR=+($G(TOTERR))+1
 Q
T11 ; 11  For each DSM code, the ICD status must match
 Q  Q:SRC'=5&(SRC'=6)  N CCS,ERR,INC,STA,TXT S STA=$$DI($G(CODE),$G(SRC)) Q:+STA=0  I +STA>0 D
 . N ERR,INC,TXT,CCS S ERR=$P(STA,"^",2) Q:'$L(ERR)
 . S INC=$$INC(11),SOS("ERR","T11")="",STAT=0
 . S TXT="DSM Code"_$S(+INC>1:"s have",1:" has")_" a status inconsistent with ICD-9"
 . S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,11,"T")=TXT,CCS=$$CCS(+SRC)
 . S TXT="  "_ERR D TL(TXT) S TOTERR=+($G(TOTERR))+1
 Q
 ;                       
FIX ; Fix Inactive Flag
 N CHG,CT,EF,IAF,IEN,LA,ST S (CHG,CT,IEN)=0
 F  S IEN=$O(^LEX(757.02,IEN)) Q:+IEN=0  D
 . S IAF=$P($G(^LEX(757.02,IEN,0)),"^",6)
 . S LA=$O(^LEX(757.02,IEN,4,"B"," "),-1) Q:+LA'>0
 . S EF=$O(^LEX(757.02,IEN,4,"B",LA," "),-1) Q:+EF'>0
 . S ST=$P($G(^LEX(757.02,IEN,4,EF,0)),"^",2)
 . I +ST'>0,IAF="" D
 . . N DA,DIK S DA=+IEN,DIK="^LEX(757.02," D IX2^DIK
 . . S $P(^LEX(757.02,IEN,0),"^",6)=1,CHG=CHG+1
 . . N DA,DIK S DA=+IEN,DIK="^LEX(757.02," D IX1^DIK
 . I +ST>0,IAF="1" D
 . . N DA,DIK S DA=+IEN,DIK="^LEX(757.02," D IX2^DIK
 . . S $P(^LEX(757.02,IEN,0),"^",6)="",CHG=CHG+1
 . . N DA,DIK S DA=+IEN,DIK="^LEX(757.02," D IX1^DIK
 W:+CHG>0 !!,CHG," change"_$S(+CHG>1:"s",1:"")," made"
 W:+CHG'>0 !!,"No changes made"
 Q
 ;                          
TT ;
 S CODE="250.01",SRC=1
 K SOS D ARY^ZZLEXXRF(CODE,+SRC,.SOS)
 Q
SOS ; Source Array SOS
 Q:$D(SOS)  Q:'$L($G(CODE))  Q:'$L($G(SRC))  Q:+($G(SRC))'>0
 K SOS D ARY^ZZLEXXRF(CODE,+SRC,.SOS)
 Q
CCS(X) ; Classification System
 Q $P($G(^LEX(757.03,+($G(X)),0)),"^",2)
INC(X) ; Increment Error
 N ID S ID=+($G(X)) Q:+ID'>0 ""  S X=+($G(^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,ID)))+1,^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,ID)=+X
 Q X
INI ; Initialize Totals
 N TXT
 S TXT="Each Activation History has one and only one Preferred Term"
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,10) S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,10,"T")=TXT
 Q
DI(X,SR) ; DSM-IIIR/DSM-IV/ICD Check
 N CODE,EF,I,IEN,INA,LD,SRC,ST,STA,TD S TD=$$DT^XLFDT
 S CODE=$G(X) Q:'$L(CODE) 0  S SR=+($G(SR)) Q:SR'=5&(SR'=6) 0
 S STA("CODE",CODE)="",STA("SRC",SR)="",INA=1,IEN=0
 F  S IEN=$O(^LEX(757.02,"CODE",(CODE_" "),IEN)) Q:+IEN=0  D
 . N SRC,LD,EF S SRC=$P($G(^LEX(757.02,IEN,0)),"^",3) Q:"^1^5^6^"'[("^"_SRC_"^")
 . S LD=$O(^LEX(757.02,IEN,4,"B",(TD+.001)),-1) Q:+LD'>0
 . S EF=$O(^LEX(757.02,IEN,4,"B",LD," "),-1) Q:+EF'>0
 . S ST=+($P($G(^LEX(757.02,IEN,4,EF,0)),"^",2))
 . S STA(SRC)=ST
 S X=0 Q:'$D(STA(1)) X
 I +SR=6,$L($G(STA(1))),$L($G(STA(6))),+($G(STA(1)))'=+($G(STA(6))) D
 . S X="1^DSM-IV Code "_CODE_" has a different activation status than ICD-9 Code "_CODE
 I +SR=5,$L($G(STA(1))),$L($G(STA(5))),+($G(STA(1)))'=+($G(STA(5))) D
 . S X="1^DSM-IIIR Code "_CODE_" has a different activation status than ICD-9 Code "_CODE
 Q X
BL ; Blank Line
 D TL("") Q
TL(X) ; Text Line
 W:'$D(ZTQUEUED) !,$G(X) Q:'$D(ZTQUEUED)
 N C S C=+($G(^ZZLEXX("ZZLEXXR",$J,"DRAFT",0))),C=C+1
 S ^ZZLEXX("ZZLEXXR",$J,"DRAFT",C)=$G(X),^ZZLEXX("ZZLEXXR",$J,"DRAFT",0)=C Q
