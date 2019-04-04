ZZLEXXRK ;SLC/KER - Import - Rel Verify - 757.02 (20-22) ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^LEX(757.02         SACC 1.3
 ;    ^LEX(757.03         SACC 1.3
 ;    ^ZZLEXX("ZZLEXXR")  SACC 1.3
 ;               
 ; External References
 ;    $$DT^XLFDT          ICR  10103
 ;    $$FMTE^XLFDT        ICR  10103
 ;               
 ; Local Variables NEWed or KILLed Elsewhere
 ;     SOS,TOTERR,ZTQUEUED
 ;               
 Q
EN ; Codes - 757.02 (Test 20 to 22)
 N IEN D INI S IEN=0 F  S IEN=$O(^LEX(757.02,IEN)) Q:+IEN=0  D
 . Q:$P($G(^LEX(757.02,IEN,0)),"^",3)=56&($D(NOCT))
 . D T(IEN) N NOCT
 Q
EN2 ; Codes - Histories only
 N TXT,TOT,STAT S TXT="",TOT=0,STAT=1 D BL S TXT="Codes",TXT=TXT_$J("",30-$L(TXT))_"^LEX(757.02," D TL(TXT),EN
 S TOT=+($G(^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,20)))+($G(^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,21)))+($G(^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,22))) W:+($G(STAT))>0 ?70," OK"
 W:+($G(STAT))'>0&(+($G(TOT))>0) !,?8,+($G(TOT))," code",$S(+TOT>1:"s have inconsistencies ",1:" has an inconsistency "),"in the activation history"
 Q
T(X) ; Test T20-T22
 N SIEN,CO,CCS S SIEN=+($G(X)) Q:+SIEN'>0  Q:'$D(^LEX(757.02,+SIEN,4))  D T20(SIEN),T21(SIEN),T22(SIEN)
 Q
T20(X) ; 20  First Status is not Active
 N SIEN,INC,CO,CCS,FIRST,ERR S SIEN=+($G(X)) Q:+SIEN'>0  Q:'$D(^LEX(757.02,+SIEN,4))
 S FIRST=$$FIRST(SIEN) I +FIRST=0 D
 . N INC,TXT,CCS,CO S INC=$$INC(20),SOS("ERR","T20")="",STAT=0,CO=$$CODE(+SIEN),CCS=$$CCS($$CTY(+SIEN))
 . S TXT="Code"_$S(+INC>1:"s",1:"")_" have histories that do not begin with an activation"
 . S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,20,"T")=TXT
 . S TXT="  "_CCS_" Code "_CO_" #"_+SIEN_" history does not begin with an activation"
 . D TL(TXT) S TOTERR=+($G(TOTERR))+1
 Q
T21(X) ; 21  Adjacent Active Status
 Q
 N EFF,EFI,STA,OSTA,SIEN,INC,ERR,CCS,CO,OK S SIEN=+($G(X)) Q:+SIEN'>0  Q:'$D(^LEX(757.02,+SIEN,4))
 S OK=1,EFF=0,OSTA="" F  S EFF=$O(^LEX(757.02,+SIEN,4,"B",EFF)) Q:+EFF'>0  D
 . S EFI=0 F  S EFI=$O(^LEX(757.02,+SIEN,4,"B",EFF,EFI)) Q:+EFI'>0  D
 . . S STA=$P($G(^LEX(757.02,+SIEN,4,EFI,0)),"^",2) S:STA=1&(STA=OSTA) OK=0 S OSTA=STA
 I 'OK D
 . S INC=$$INC(21),SOS("ERR","T21")="",STAT=0,CO=$$CODE(+SIEN),CCS=$$CCS($$CTY(+SIEN))
 . S TXT="Code"_$S(+INC>1:"s",1:"")_" have histories with adjacent activation dates"
 . S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,21,"T")=TXT
 . S TXT="  "_CCS_" Code "_CO_" #"_+SIEN_" history contains adjacent activation dates"
 . D TL(TXT) S TOTERR=+($G(TOTERR))+1
 Q
T22(X) ; 22  Adjacent Inactive Status
 Q
 N EFF,EFI,STA,OSTA,SIEN,INC,ERR,CCS,CO,OK S SIEN=+($G(X)) Q:+SIEN'>0  Q:'$D(^LEX(757.02,+SIEN,4))
 S OK=1,EFF=0,OSTA="" F  S EFF=$O(^LEX(757.02,+SIEN,4,"B",EFF)) Q:+EFF'>0  D
 . S EFI=0 F  S EFI=$O(^LEX(757.02,+SIEN,4,"B",EFF,EFI)) Q:+EFI'>0  D
 . . S STA=$P($G(^LEX(757.02,+SIEN,4,EFI,0)),"^",2) S:STA=0&(STA=OSTA) OK=0 S OSTA=STA
 I 'OK D
 . S INC=$$INC(22),SOS("ERR","T22")="",STAT=0,CO=$$CODE(+SIEN),CCS=$$CCS($$CTY(+SIEN))
 . S TXT="Code"_$S(+INC>1:"s",1:"")_" have histories with adjacent inactivation dates"
 . S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,22,"T")=TXT
 . S TXT="  "_CCS_" Code "_CO_" #"_+SIEN_" history contains adjacent inactivation dates"
 . D TL(TXT) S TOTERR=+($G(TOTERR))+1
 Q
INC(X) ; Increment Error
 N ID S ID=+($G(X)) Q:+ID'>0 ""  S X=+($G(^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,ID)))+1,^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,ID)=+X
 Q X
INI ; Initialize Totals
 N TXT S TXT="All code histories begin with an activation date"
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,20) S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,20,"T")=TXT
 S TXT="No adjacent activation dates were found"
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,21) S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,21,"T")=TXT
 S TXT="No adjacent inactivation dates were found"
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,22) S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.02,22,"T")=TXT
 Q
FIRST(X) ; First Status
 N SIEN,STA,EFF,EFI S SIEN=+($G(X))
 S EFF=$O(^LEX(757.02,SIEN,4,"B",0)) Q:'$L(EFF) -1
 S EFI=$O(^LEX(757.02,SIEN,4,"B",EFF,"")) Q:'$L(EFI) -1
 S STA=$P($G(^LEX(757.02,SIEN,4,EFI,0)),"^",2) Q:'$L(STA) -1
 S X=+STA_"^"_EFF
 Q X
LAST(X) ; Last Status
 N SIEN,STA,EFF,EFI S SIEN=+($G(X))
 S EFF=$O(^LEX(757.02,SIEN,4,"B"," "),-1) Q:'$L(EFF) -1
 S EFI=$O(^LEX(757.02,SIEN,4,"B",EFF," "),-1) Q:'$L(EFI) -1
 S STA=$P($G(^LEX(757.02,SIEN,4,EFI,0)),"^",2) Q:'$L(STA) -1
 S X=+STA_"^"_EFF
 Q X
CCS(X) ; Classification System
 Q $P($G(^LEX(757.03,+($G(X)),0)),"^",2)
CTY(X) ; Code Classification Type
 Q $P($G(^LEX(757.02,+($G(X)),0)),"^",3)
CODE(X) ; Code
 Q $P($G(^LEX(757.02,+($G(X)),0)),"^",2)
ED(X) ; External Date
 Q $TR($$FMTE^XLFDT(+($G(X)),"5DZ"),"@"," ")
BL ; Blank Line
 D TL("") Q
TL(X) ; Text Line
 W:'$D(ZTQUEUED) !,$G(X) Q:'$D(ZTQUEUED)
 N C S C=+($G(^ZZLEXX("ZZLEXXR",$J,"DRAFT",0))),C=C+1
 S ^ZZLEXX("ZZLEXXR",$J,"DRAFT",C)=$G(X),^ZZLEXX("ZZLEXXR",$J,"DRAFT",0)=C Q
CPTOK(X,Y) ; CPT/HCPC Code OK
 N SI,SR,TD,ND,EF,HS,ST,PF S SI=+($G(X)) Q:+SI'>0 0  S:$G(DT)?7N TD=DT  S:$G(TD)'?7N TD=$$DT^XLFDT
 S ND=$G(^LEX(757.02,+SI,0)) Q:'$L(ND) 0  S SR=+($G(Y)) Q:SR'>0 0  Q:'$D(^LEX(757.03,SR,0)) 0
 Q:$P(ND,"^",3)'=SR 0  Q:$P(ND,"^",5)'>0 0  S EF=$O(^LEX(757.02,SI,4,"B",(TD+.001)),-1)
 S HS=$O(^LEX(757.02,SI,4,"B",+EF," "),-1),ST=$P($G(^LEX(757.02,+SI,4,+HS,0)),"^",2) Q:ST'>0 0
 Q 1
