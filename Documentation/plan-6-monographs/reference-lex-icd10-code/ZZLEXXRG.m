ZZLEXXRG ;SLC/KER - Import - Rel Verify - 757.02 (SDO) ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^LEX(757.03         SACC 1.3
 ;               
 ; External References
 ;    $$IMPDATE^LEXU      N/A
 ;    $$DT^XLFDT          ICR  10103
 ;               
 ; Local Variables NEWed or KILLed Elsewhere
 ;     ARY,SO
 ;               
 Q
ICD9 ; ICD-9 Diagnosis
 D ICD(80,$G(SO),1) Q
ICD0 ; ICD-9 Procedures
 D ICD(80,$G(SO),2) Q
ICDXD ; ICD-10 Diagnosis
 D ICD(80,$G(SO),30) Q
ICDXP ; ICD-10 Procedures
 D ICD(80,$G(SO),31) Q
 Q
ICD(X,Y,Z) ; ICD Codes
 N AD,AIEN,AN,AS,CODE,COL,EFF,FILE,HIS,HIS2,ID,IEN,NAM,NC,ND,IMP
 N ND2,NN,PF,PFC,QIT,RD,RD2,ROOT,ROW,SAB,SDE,SDI,SDN,SDT,SYS,SIEN
 N SOC,SOS,SRC,SRS,STA,STA2,USE
 S FILE=$G(X) Q:"^80^80.1^"'[("^"_FILE_"^")
 S CODE=$G(Y) Q:'$L(CODE)  S SOS=CODE_" "
 S (SRC,SYS)=+($G(Z)) Q:"^1^2^30^31^"'[("^"_SYS_"^")  Q:SRC'>0
 S ROOT=$G(@("^DIC("_+FILE_",0,""GL"")")) Q:'$L(ROOT)
 Q:'$D(@(ROOT_"""ABA"","_SYS_","""_SOS_""")"))
 S SAB=$E($G(^LEX(757.03,+SRC,0)),1,3) Q:$L(SAB)'=3
 S IMP=$$IMPDATE^LEXU(30)
 S SDT=$$DT^XLFDT S:(SRC=30!(SRC=31))&(SDT<IMP) SDT=IMP
 S (SOC,PFC,SIEN)=0
 F  S SIEN=$O(@(ROOT_"""ABA"","_SYS_","""_SOS_""","_+SIEN_")")) Q:+SIEN=0  D
 . N SDE,SDI,SDN,NN,NC,AN S NN=ROOT_SIEN_")",NC=ROOT_SIEN_","
 . F  S NN=$Q(@NN) Q:NN=""!(NN'[NC)  D
 . . N ND1,ND2 S ND1=$P($P(NN,",",2),")",1),ND2=$P($P(NN,",",4),")",1)
 . . Q:ND1>1&(ND1<8)  Q:(ND1=68)&(ND2=2)
 . . Q:NN[(SIEN_",""DRG""")  Q:NN[(SIEN_",""N""")  Q:NN[(SIEN_",""R""")
 . . S AN=$P(NN,ROOT,2,299)
 . . S AN=$P(AN,")",1,($L(AN,")")-1))
 . . S AN="ARY("""_SAB_""","_AN_")"
 . . S @AN=@NN
 . S ARY(SAB,"SO",SIEN)=""
 . S ARY(SAB,SIEN)=$P($G(ARY(SAB,SIEN,0)),"^",3)
 . N RD,ND,AD,ID,IEN,HIS,QIT,STA S IEN=+($G(SIEN)) Q:+IEN'>0
 . S SDE=$O(ARY(SAB,IEN,67,"B",(SDT_".0001")),-1)
 . S:$L(SDE) SDE=$O(ARY(SAB,IEN,67,"B",(SDT_".0001"))) Q:'$L(SDE)
 . S SDI=$O(ARY(SAB,IEN,67,"B",SDE," "),-1)
 . S SDN=$P($G(ARY(SAB,IEN,67,SDI,0)),"^",2)
 . S:$L(SDN) ARY(SAB,SIEN)=SDN
 . S RD=0 F  S RD=$O(ARY(SAB,IEN,66,"B",RD)) Q:+RD=0  D
 . . S HIS=0 F  S HIS=$O(ARY(SAB,IEN,66,"B",RD,HIS)) Q:+HIS=0  D
 . . . S ND=$G(ARY(SAB,IEN,66,HIS,0)),AD=$P(ND,"^",1),STA=$P(ND,"^",2)
 . . . Q:+AD=0  Q:+STA=0  S ARY(SAB,"HIS",IEN,AD)=""
 . . . N RD2,HIS2,ND2,ID,STA2 S RD2=0
 . . . F  S RD2=$O(ARY(SAB,IEN,4,"B",RD2)) Q:+RD2=0  D
 . . . . S HIS2=0 F  S HIS2=$O(ARY(SAB,IEN,4,"B",RD2,HIS2)) Q:+HIS2=0  D
 . . . . . S ND2=$G(ARY(SAB,IEN,4,HIS2,0)),ID=$P(ND2,"^",1)
 . . . . . S STA2=$P(ND2,"^",2) Q:+ID=0  Q:+STA2=1  Q:ID<AD
 . . . . . S ARY(SAB,"HIS",IEN,AD)=ID K ARY(SAB,"HIS",IEN,AD)
 . . . . . S ARY(SAB,"HIS",IEN,AD,ID)=""
 . . . . . S ARY(SAB,"RHIS",IEN,ID,AD)=""
 S IEN=0 F  S IEN=$O(ARY(SAB,IEN)) Q:+IEN=0  D
 . S AIEN=0 F  S AIEN=$O(ARY(SAB,IEN,66,AIEN)) Q:+AIEN=0  D
 . . S AD=$G(ARY(SAB,IEN,66,AIEN,0)),AS=+($P(AD,"^",2)),AD=+($P(AD,"^",1)) Q:+AD'>0  S ARY(SAB,"ACT",IEN,AS,AD,AIEN)=""
 S ROW=0,IEN=0 F  S IEN=$O(ARY(SAB,IEN)) Q:+IEN=0  D
 . N HIS S HIS=0,ROW=ROW+1
 . F  S HIS=$O(ARY(SAB,IEN,66,HIS)) Q:+HIS=0  D
 . . N EFF,STA S EFF=$P($G(ARY(SAB,IEN,66,HIS,0)),"^",1) Q:+EFF=0
 . . S STA=$P($G(ARY(SAB,IEN,66,HIS,0)),"^",2)
 . . S ARY(SAB,"TL",+EFF,ROW)=IEN_"^"_STA_"^0"
 S COL=0,EFF=0
 F  S EFF=$O(ARY(SAB,"TL",EFF)) Q:+EFF=0  D
 . S COL=COL+1 S ROW=0
 . F  S ROW=$O(ARY(SAB,"TL",EFF,ROW)) Q:+ROW=0  D
 . . S ARY(SAB,"TL","RC",ROW,COL)=EFF_"^"_$G(ARY(SAB,"TL",EFF,ROW))
 S IEN=$O(ARY(SAB,0)) K ARY(SAB,+IEN,66,0),ARY(SAB,+IEN,66,"B")
 S ID=0 F  S ID=$O(ARY(SAB,+IEN,66,ID)) Q:+ID=0  K ARY(SAB,+IEN,66,ID,"DRG")
 Q
