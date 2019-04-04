ZZLEXXRO ;SLC/KER - Import - Rel Verify - 80 (8-10) ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^ICD9(              ICR   4485
 ;    ^ZZLEXX("ZZLEXXR")  SACC 1.3
 ;               
 ; External References
 ;    $$FMTE^XLFDT        ICR  10103
 ;               
 ; Local Variables NEWed or KILLed Elsewhere
 ;     TOTERR
 ;               
 Q
T(X) ; Test T8-T10
 N SIEN S SIEN=+($G(X)) Q:+SIEN'>0  Q:'$D(^ICD9(+SIEN,66))  D T8(SIEN),T9(SIEN),T10(SIEN)
 Q
T8(X) ; 8  First Status is not Active
 N SIEN,INC,CO,FIRST,ERR S SIEN=+($G(X)) Q:+SIEN'>0  Q:'$D(^ICD9(+SIEN,66))
 S FIRST=$$FIRST(SIEN) I +FIRST=0 D
 . N INC,TXT,STAT,CO S INC=$$INC(8),SOS("ERR","T8")="",STAT=0,CO=$$CODE(+SIEN)
 . S TXT="Code"_$S(+INC>1:"s have histories that do ",1:" has a history that does ")_"not begin with an activation"
 . S ^ZZLEXX("ZZLEXXR",$J,"TOT",80,8,"T")=TXT
 . S TXT="  Code "_CO_" #"_+SIEN_" history does not begin with an activation"
 . D TL(TXT) S TOTERR=+($G(TOTERR))+1
 Q
T9(X) ; 9  Adjacent Active Status
 N EFF,EFI,STA,OSTA,SIEN,INC,STAT,ERR,CSS,CO,OK S SIEN=+($G(X)) Q:+SIEN'>0  Q:'$D(^ICD9(+SIEN,66))
 S OK=1,EFF=0,OSTA="" F  S EFF=$O(^ICD9(+SIEN,66,"B",EFF)) Q:+EFF'>0  D
 . S EFI=0 F  S EFI=$O(^ICD9(+SIEN,66,"B",EFF,EFI)) Q:+EFI'>0  D
 . . S STA=$P($G(^ICD9(+SIEN,66,EFI,0)),"^",2) S:STA=1&(STA=OSTA) OK=0 S OSTA=STA
 I 'OK D
 . S INC=$$INC(9),SOS("ERR","T9")="",STAT=0,CO=$$CODE(+SIEN)
 . S TXT="Code"_$S(+INC>1:"s have histories ",1:" has a history ")_"with adjacent activation dates"
 . S ^ZZLEXX("ZZLEXXR",$J,"TOT",80,9,"T")=TXT
 . S TXT="  Code "_CO_" #"_+SIEN_" history contains adjacent activation dates"
 . D TL(TXT) S TOTERR=+($G(TOTERR))+1
 Q
T10(X) ; 10  Adjance Inactive Status
 N EFF,EFI,STA,OSTA,SIEN,INC,STAT,ERR,CSS,CO,OK S SIEN=+($G(X)) Q:+SIEN'>0  Q:'$D(^ICD9(+SIEN,66))
 S OK=1,EFF=0,OSTA="" F  S EFF=$O(^ICD9(+SIEN,66,"B",EFF)) Q:+EFF'>0  D
 . S EFI=0 F  S EFI=$O(^ICD9(+SIEN,66,"B",EFF,EFI)) Q:+EFI'>0  D
 . . S STA=$P($G(^ICD9(+SIEN,66,EFI,0)),"^",2) S:STA=0&(STA=OSTA) OK=0 S OSTA=STA
 I 'OK D
 . S INC=$$INC(10),SOS("ERR","T10")="",STAT=0,CO=$$CODE(+SIEN)
 . S TXT="Code"_$S(+INC>1:"s have histories ",1:" has a history ")_"with adjacent inactivation dates"
 . S ^ZZLEXX("ZZLEXXR",$J,"TOT",80,10,"T")=TXT
 . S TXT="  Code "_CO_" #"_+SIEN_" history contains adjacent inactivation dates"
 . D TL(TXT) S TOTERR=+($G(TOTERR))+1
 Q
INC(X) ; Increment Error
 N ID S ID=+($G(X)) Q:+ID'>0 ""  S X=+($G(^ZZLEXX("ZZLEXXR",$J,"TOT",80,ID)))+1,^ZZLEXX("ZZLEXXR",$J,"TOT",80,ID)=+X
 Q X
INI ; Initialize Totals
 N TXT S TXT="All ICD Diagnosis code histories begin with an activation date"
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",80,8) S ^ZZLEXX("ZZLEXXR",$J,"TOT",80,8,"T")=TXT
 S TXT="No adjacent ICD Diagnosis activation dates were found"
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",80,9) S ^ZZLEXX("ZZLEXXR",$J,"TOT",80,9,"T")=TXT
 S TXT="No adjacent ICD Diagnosis inactivation dates were found"
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",80,10) S ^ZZLEXX("ZZLEXXR",$J,"TOT",80,10,"T")=TXT
 Q
FIRST(X) ; First Status
 N SIEN,STA,EFF,EFI S SIEN=+($G(X))
 S EFF=$O(^ICD9(SIEN,66,"B",0)) Q:'$L(EFF) -1
 S EFI=$O(^ICD9(SIEN,66,"B",EFF,"")) Q:'$L(EFI) -1
 S STA=$P($G(^ICD9(SIEN,66,EFI,0)),"^",2) Q:'$L(STA) -1
 S X=+STA_"^"_EFF
 Q X
LAST(X) ; Last Status
 N SIEN,STA,EFF,EFI S SIEN=+($G(X))
 S EFF=$O(^ICD9(SIEN,66,"B"," "),-1) Q:'$L(EFF) -1
 S EFI=$O(^ICD9(SIEN,66,"B",EFF," "),-1) Q:'$L(EFI) -1
 S STA=$P($G(^ICD9(SIEN,66,EFI,0)),"^",2) Q:'$L(STA) -1
 S X=+STA_"^"_EFF
 Q X
CODE(X) ; Code
 Q $P($G(^ICD9(+($G(X)),0)),"^",1)
ED(X) ; External Date
 Q $TR($$FMTE^XLFDT(+($G(X)),"5DZ"),"@"," ")
BL ; Blank Line
 D TL("") Q
AP(X,Y) ; Append Line at Y
 S X=$G(X),Y=+($G(Y)) S:Y'>0 Y=1
 W:'$D(ZTQUEUED) !,?Y,$G(X) Q:'$D(ZTQUEUED)
 N C,T S C=+($O(^ZZLEXX("ZZLEXXR",$J,"DRAFT"," "),-1)) Q:C'>0
 S T=$G(^ZZLEXX("ZZLEXXR",$J,"DRAFT",C))
 S:$L(T)'>Y T=T_$J(" ",(Y-$L(T))) S T=T_X
 S ^ZZLEXX("ZZLEXXR",$J,"DRAFT",C)=T N ZTQUEUED,SOS
 Q
TL(X) ; Text Line
 W:'$D(ZTQUEUED) !,$G(X) Q:'$D(ZTQUEUED)
 N C S C=+($G(^ZZLEXX("ZZLEXXR",$J,"DRAFT",0))),C=C+1
 S ^ZZLEXX("ZZLEXXR",$J,"DRAFT",C)=$G(X),^ZZLEXX("ZZLEXXR",$J,"DRAFT",0)=C Q
