ZZLEXXRF ;SLC/KER - Import - Rel Verify - 757.02 (History) ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^ICD0(              ICR   4486
 ;    ^ICD9(              ICR   4485
 ;    ^LEX(757.01         SACC 1.3
 ;    ^LEX(757.02         SACC 1.3
 ;    ^LEX(757.03         SACC 1.3
 ;               
 ; External References
 ;    $$FMTE^XLFDT        ICR  10103
 ;               
 Q
ARY(X,Y,ARY) ; Get Array of Codes
 N SO,SR,TY S SO=$G(X) Q:'$L(SO)  S SR=+($G(Y)) Q:+SR'>0  Q:'$D(^LEX(757.03,+SR,0))
 S TY=$$TYCOD(SO,SR)
 Q:"^30^31^"'[("^"_TY_"^")
 D:+TY=30 ICDXD^ZZLEXXRG D:+TY=31 ICDXP^ZZLEXXRG
 Q:'$D(^LEX(757.02,"CODE",(SO_" ")))
 N RECI,SOC,PFC,SRS,SOS,SIEN,PF,SRN,LBL S SOS=SO_" ",(SOC,PFC,SIEN)=0
 S (LBL,SRN)=$P($G(^LEX(757.03,+SR,0)),"^",2) S:$L(LBL) LBL=LBL_" Code "
 S LBL=LBL_SO,ARY("NAM")=LBL_"^"_SRN_"^"_SO
 F  S SIEN=$O(^LEX(757.02,"CODE",SOS,SIEN)) Q:+SIEN=0  D
 . N SRS,CODE,RECI S SRS=$$SRC(SIEN),CODE=$$TRIM(SO) Q:+SRS'=+SR  Q:CODE'=SO
 . S RECI=$P($G(^LEX(757.02,+SIEN,0)),"^",1,4)
 . N NN,NC,AN S NN="^LEX(757.02,"_SIEN_")",NC="^LEX(757.02,"_SIEN_","
 . F  S NN=$Q(@NN) Q:NN=""!(NN'[NC)  D
 . . S AN=$P($P(NN,"^LEX(757.02,",2,299),")",1),AN="ARY("_AN_")",@AN=@NN
 . S SOC=+($G(SOC))+1,PF=$$DPF(+SIEN) S:+PF>0 PFC=+($G(PFC))+1
 . S ARY("SO",SIEN)="" S:+PF>0 ARY("PF",SIEN)="" S $P(ARY(0),"^",1)=SIEN,$P(ARY(0),"^",2)=SOC
 . S:+($G(ARY(SIEN,0)))>0 ARY(SIEN)=$P($G(^LEX(757.01,+($G(ARY(SIEN,0))),0)),"^",1)
 . D HIS,REC
 D ACT S X=+($G(SOC))_"^"_+($G(PFC))
 S ARY(0)=X,ARY("SO",0)=SOC,ARY("PF",0)=PFC
 D TL
 Q
HIS ; History
 N RD,ND,AD,ID,IEN,HIS,QIT,STA S IEN=+($G(SIEN)) Q:+IEN'>0
 S RD=0 F  S RD=$O(ARY(IEN,4,"B",RD)) Q:+RD=0  D
 . S HIS=0 F  S HIS=$O(ARY(IEN,4,"B",RD,HIS)) Q:+HIS=0  D
 . . S ND=$G(ARY(IEN,4,HIS,0)),AD=$P(ND,"^",1),STA=$P(ND,"^",2) Q:+AD=0  Q:+STA=0  S ARY("HIS",IEN,AD)=""
 . . N RD2,HIS2,ND2,ID,STA2 S RD2=0 F  S RD2=$O(ARY(IEN,4,"B",RD2)) Q:+RD2=0  D
 . . . S HIS2=0 F  S HIS2=$O(ARY(IEN,4,"B",RD2,HIS2)) Q:+HIS2=0  D
 . . . . S ND2=$G(ARY(IEN,4,HIS2,0)),ID=$P(ND2,"^",1)
 . . . . S STA2=$P(ND2,"^",2) Q:+ID=0  Q:+STA2=1  Q:ID<AD
 . . . . S ARY("HIS",IEN,AD)=ID K ARY("HIS",IEN,AD)
 . . . . S ARY("HIS",IEN,AD,ID)=""
 . . . . S ARY("RHIS",IEN,ID,AD)=""
 Q
REC ; Duplicate Records
 Q:'$L($G(RECI))  Q:$L(RECI,"^")'=4  N OCC S OCC=+($G(ARY("REC",RECI)))
 K ARY("REC","B",OCC,RECI) S OCC=OCC+1,ARY("REC",RECI)=OCC,ARY("REC",RECI,1,SIEN)="",ARY("REC","B",OCC,RECI)=""
 Q
ACT ; Activations
 N IEN,AIEN,AD,AS S IEN=0 F  S IEN=$O(ARY(IEN)) Q:+IEN=0  D
 . S AIEN=0 F  S AIEN=$O(ARY(IEN,4,AIEN)) Q:+AIEN=0  D
 . . S AD=$G(ARY(IEN,4,AIEN,0)),AS=+($P(AD,"^",2)),AD=+($P(AD,"^",1)) Q:+AD'>0  S ARY("ACT",IEN,AS,AD,AIEN)=""
 Q
TL ; Time Line
 N IEN,ROW,COL,USE S ROW=0
 S IEN=0 F  S IEN=$O(ARY("PF",IEN)) Q:+IEN=0  D
 . N HIS S HIS=0,ROW=ROW+1,USE(+IEN)=""
 . F  S HIS=$O(ARY(IEN,4,HIS)) Q:+HIS=0  D
 . . N EFF,STA S EFF=$P($G(ARY(IEN,4,HIS,0)),"^",1) Q:+EFF=0
 . . S STA=$P($G(ARY(IEN,4,HIS,0)),"^",2)
 . . S ARY("TL",+EFF,ROW)=IEN_"^"_STA_"^1"
 S IEN=0 F  S IEN=$O(ARY(IEN)) Q:+IEN=0  D
 . Q:$D(USE(+IEN))  N HIS S HIS=0,ROW=ROW+1,USE(+IEN)=""
 . F  S HIS=$O(ARY(IEN,4,HIS)) Q:+HIS=0  D
 . . N EFF,STA S EFF=$P($G(ARY(IEN,4,HIS,0)),"^",1) Q:+EFF=0
 . . S STA=$P($G(ARY(IEN,4,HIS,0)),"^",2)
 . . S ARY("TL",+EFF,ROW)=IEN_"^"_STA_"^0"
 S COL=0,EFF=0
 F  S EFF=$O(ARY("TL",EFF)) Q:+EFF=0  D
 . S COL=COL+1 S ROW=0
 . F  S ROW=$O(ARY("TL",EFF,ROW)) Q:+ROW=0  D
 . . S ARY("TL","RC",ROW,COL)=EFF_"^"_$G(ARY("TL",EFF,ROW))
 Q
DTL(ARY) ; Display Time Line Array
 W:'$D(NOTITLE) !,$P($G(ARY("NAM")),"^",1),!
 N ROW,COL,IEN,EFF,PF,TAB,PSN,STA,STN,PFN,INT,OFF,PFU,TXT1,TXT2
 S (PFU,ROW)=0 F  S ROW=$O(ARY("TL","RC",ROW)) Q:+ROW=0  D
 . S (INT,COL)=0 F  S COL=$O(ARY("TL","RC",ROW,COL)) Q:+COL=0  D
 . . S EFF=+($G(ARY("TL","RC",ROW,COL))),IEN=$P($G(ARY("TL","RC",ROW,COL)),"^",2)
 . . S STA=$P($G(ARY("TL","RC",ROW,COL)),"^",3),PF=$P($G(ARY("TL","RC",ROW,COL)),"^",4)
 . . S PFN=$S(+PF>0:"*",1:" ") S:PFN="*" PFU=1 S STN=$S(+STA>0:"Active",1:"Inactive")
 . . S TAB=$P("12^24^36^48^60^72","^",COL),OFF=COL-1,INT=INT+1
 . . S:INT=1 TXT1=" "_PFN_" "_IEN,PSN=12 S:INT=1 TXT1=TXT1_$J("",(12-$L(TXT1))) S:INT=1 TXT2=$J("",12)
 . . S TXT1=TXT1_$J("",(TAB-$L(TXT1)))_STN,TXT2=TXT2_$J("",(TAB-$L(TXT2)))_$$SD(EFF)
 . W !,TXT1,!,TXT2
 W ! W:+PFU>0 !," * Linked to Preferred Term",! N NOTITLE
 Q
TYCOD(X,Y) ; Code Type
 N SO,SR S SO=$G(X),SR=+($G(Y)) Q:SR=3!(SR=4) 0
 Q:+SR=1&(+$$ISICD($G(X))>0) 1
 Q:+SR=2&(+$$ISICP($G(X))>0) 2
 Q:+SR=30&(+$$ISD10($G(X))>0) 30
 Q:+SR=31&(+$$ISP10($G(X))>0) 31
 Q 0
ISCOD(X) ; Is Correct Format for ICD Code
 Q:+$$ISICD($G(X))>0 1  Q:+$$ISICP($G(X))>0 1
 Q:+$$ISD10($G(X))>0 1  Q:+$$ISP10($G(X))>0 1
 Q 0
ISICD(X) ; Is an ICD Diagnosis Code
 N SO S SO=$G(X) Q:$D(^ICD9("ABA",1,(SO_" "))) 1  Q 0
ISICP(X) ; Is an ICD Procedure Code
 N SO S SO=$G(X) Q:$D(^ICD9("ABA",2,(SO_" "))) 1  Q 0
ISD10(X) ; Is an ICD-10 Diagnosis Code
 N SO S SO=$G(X) Q:$D(^ICD9("ABA",30,(SO_" "))) 1  Q 0
ISP10(X) ; Is an ICD-10 Procedure Code
 N SO S SO=$G(X) Q:$D(^ICD0("ABA",31,(SO_" "))) 1  Q 0
 Q
SRC(X) ; Source
 N LEXA,LEXS,LEXT S (LEXS,LEXT)=""
 S LEXA=+($P($G(^LEX(757.02,+($G(X)),0)),"^",3))
 S:$D(^LEX(757.02,+LEXA,0)) LEXS=$P($G(^LEX(757.03,+LEXA,0)),"^",1),LEXT=$P($G(^LEX(757.03,+LEXA,0)),"^",2)
 S:$L(LEXS) $P(LEXA,"^",2)=LEXS S:$L(LEXT) $P(LEXA,"^",3)=LEXT
 S X=LEXA Q X
DPF(X) ; Default Preferred Term Flag
 N LEXD,LEXI,LEXT,LEXP S LEXD=0,LEXP=""
 I $D(@("^DD(757.28,2,0)")) D  S X=+($G(LEXP))_"^"_$S(+($G(LEXP))>0:"Preferred Term",1:"Other Term") Q X
 . S LEXP=0 F  S LEXD=$O(^LEX(757.02,+($G(X)),4,"B",LEXD)) Q:+LEXD=0  D
 . . S LEXI=0 F  S LEXI=$O(^LEX(757.02,+($G(X)),4,"B",LEXD,LEXI)) Q:+LEXI=0  D
 . . . S:+($P($G(^LEX(757.02,+($G(X)),4,LEXI,0)),"^",3))>0 LEXP=1 Q:+LEXP>0
 S LEXP=+($P($G(^LEX(757.02,+($G(X)),0)),"^",5))
 S:$D(^LEX(757.02,+($G(X)),0)) $P(^LEX(757.02,+($G(X)),0),"^",5)=+($G(LEXP))
 S LEXT=$S(+($P($G(^LEX(757.02,+($G(X)),0)),"^",5))>0:"Preferred Term",1:"Other Term")
 S X=LEXP_"^"_LEXT Q X
SD(X) ; Short Date
 Q $TR($$FMTE^XLFDT(+($G(X)),"5DZ"),"@"," ")
TRIM(X) ; Trim Spaces
 S X=$G(X) F  Q:$E(X,1)'=" "  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=" "  S X=$E(X,1,($L(X)-1))
 Q X
