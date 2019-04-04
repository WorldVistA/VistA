ZZLEXXRP ;SLC/KER - Import - Rel Verify - 80.1 (1-5) ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^ICD0(              ICR   4486
 ;    ^ICD9(              ICR   4485
 ;    ^LEX(757.02         SACC 1.3
 ;    ^ZZLEXX("ZZLEXXR")  SACC 1.3
 ;               
 ; External References
 ;    $$DT^XLFDT          ICR  10103
 ;    $$FMTE^XLFDT        ICR  10103
 ;               
 ; Documented Integration Agreements
 ;               
 ; Local Variables NEWed or KILLed Elsewhere
 ;     TOTERR
 ;               
 Q
EN ; ICD Procedures
 D INI D:$D(FULL) INI^ZZLEXXRQ D BL
 N CCS,DA,EF,TD,IN,INA,INC,IND,INO,INF,IN0,LD,LEX,SO,TY,ST,STAT,TXT S STAT=1,TD=$$DT^XLFDT
 S CSID=$S(+($G(SYS))=2:"ICD-9",+($G(SYS))=31:"ICD-10",1:"ICD")
 S TXT=CSID_" Operation/Procedure",TXT=TXT_$J("",30-$L(TXT))_"^ICD0(" D TL(TXT)
 S (DA,INA,IND)=0,LEX=2960923,INO=9999999
 N ZICD S ZICD=31 D
 . N CODE Q:+($G(SYS))>0&(+ZICD'=+($G(SYS)))  S (CODE,DA,INA,IND)=0
 . F  S CODE=$O(^ICD0("ABA",ZICD,CODE)) Q:CODE=""  F  S DA=$O(^ICD0("ABA",ZICD,CODE,DA)) Q:'+DA  D
 . . N CS,CSID S CS=+($G(^ICD0(+DA,1))),CSID=$$CSID(DA) Q:+($G(SYS))>0&(+CS'=+($G(SYS)))
 . . D T4,T5 D:$D(FULL) T^ZZLEXXRQ(DA)
 . . Q:CS'>2  S SO=$P($G(^ICD0(DA,0)),"^",1) Q:'$L(SO)
 . . S LD=$O(^ICD0(DA,66,"B"," "),-1) Q:+LD=0
 . . S EF=$O(^ICD0(DA,66,"B",LD," "),-1) Q:+EF=0
 . . S ST=$P($G(^ICD0(DA,66,EF,0)),"^",2)
 . . S IN=$$IN(SO,CS) Q:+IN>0
 . . I '$D(ALL) Q:LD<LEX
 . . I '$D(VER) Q:LD<3031001
 . . I +ST=0 S INA=INA+1 S:+LD>IND IND=+LD S:+LD<INO INO=+LD
 . . Q:+ST=0  I IN'>0  D T1
 D T2 D:+($G(STAT))>0 AP(" OK",70) N SYS,ALL,FULL
 Q
T1 ;  1  Active ICD codes not in the Lexicon
 N INC,TXT,CCS S INC=$$INC(1) Q:INC'>0  S STAT=0
 S TXT="Active "_CSID_"Procedure Code"_$S(+INC>1:"s were",1:" was")_" not found in the Lexicon"
 S ^ZZLEXX("ZZLEXXR",$J,"TOT",80,1,"T")=TXT
 S TXT="  Active "_CSID_"Procedure code "_SO_" was not found in the Lexicon"
 D TL(TXT) S TOTERR=+($G(TOTERR))+1
 Q
T2 ;  2  Inactive ICD codes not in the Lexicon
 I INA>0  D
 . N INC,TXT,CCS S STAT=0
 . S TXT="Inactive Procedure Code"_$S(+INA>1:"s were",1:" was")_" not found in the Lexicon"
 . S ^ZZLEXX("ZZLEXXR",$J,"TOT",80,2)=+INA,^ZZLEXX("ZZLEXXR",$J,"TOT",80,2,"T")=TXT
 . I +IND>0 D T3
 Q
T3 ;  3  Inactive Dates (part 2)
 Q  N INF S INF=LEX I $D(ALL),INO>0,INO'=9999999,INO<9999999 D
 . S INF=$S(INO<LEX:INO,1:LEX)
 S TXT=$E("                  ",1,$L(INA))
 S TXT=TXT_" (codes inactivated between "_$$FMTE^XLFDT(INF)
 S TXT=TXT_" and "_$$FMTE^XLFDT(IND)_")"
 S ^ZZLEXX("ZZLEXXR",$J,"TOT",80,3,"T")=TXT
 Q
T4 ;  4  Procedure
 N TXT I '$D(^ICD0(DA,67)) D  Q
 . S TXT="  "_CSID_"Proc #"_DA_" 'OPERATION/PROCEDURE' is missing"
 . D DTXT(4,TXT,"OPERATION/PROCEDURE")
 N VER S VER=0 F  S VER=$O(^ICD0(DA,67,VER)) Q:+VER=0  D
 . N VAL,TXT,CTL S TXT=""
 . S VAL=$P($G(^ICD0(DA,67,VER,0)),"^",2),CTL=$$CTL($G(VAL))
 . I $L(VAL)<1!($L(VAL)>60) D
 . . N TR S TR="" S:$L(VAL)<2 TR="< 2 characters in length"
 . . S:$L(VAL)'>0 TR="missing"
 . . S:$L(VAL)>60 TR="> 60 characters in length"
 . . S:$L(TR) TXT="  "_CSID_"Proc #"_DA_" 'OPERATION/PROCEDURE' is "_TR
 . I +CTL>0 D
 . . S TXT="  "_CSID_"Proc #"_DA_" 'OPERATION/PROCEDURE' contains "_CTL_" control character"_$S(CTL>1:"s",1:"")
 . I $L(TXT) D
 . . D TL(TXT) S INC=$$INC(4),STAT=0 S TOTERR=+($G(TOTERR))+1
 . . S TXT="'OPERATION/PROCEDURE' failed FileMan's Input Transformation"
 . . S ^ZZLEXX("ZZLEXXR",$J,"TOT",80.1,4,"T")=TXT
 Q
T5 ;  5  Description
 N TXT I '$D(^ICD0(DA,68)) D  Q
 . S TXT="  "_CSID_"Proc #"_DA_" 'DESCRIPTION' is missing"
 . D DTXT(5,TXT,"DESCRIPTION")
 N VER S VER=0 F  S VER=$O(^ICD0(DA,68,VER)) Q:+VER=0  D
 . N VAL,TXT,CTL S TXT=""
 . S VAL=$P($G(^ICD0(DA,68,VER,1)),"^",1),CTL=$$CTL($G(VAL))
 . I $L(VAL)<1!($L(VAL)>245) D
 . . N TR S TR=""
 . . S:$L(VAL)<2 TR="< 2 characters in length"
 . . S:$L(VAL)<1 TR="missing"
 . . S:$L(VAL)>245 TR="> 245 characters in length"
 . . S:$L(TR) TXT="  "_CSID_"Proc #"_DA_" 'DESCRIPTION' is "_TR
 . I +CTL>0 D
 . . S TXT="  "_CSID_"Proc #"_DA_" 'DESCRIPTION' contains "_CTL_" control character"_$S(CTL>1:"s",1:"")
 . I $L(TXT) D
 . . D TL(TXT) S INC=$$INC(5),STAT=0 S TOTERR=+($G(TOTERR))+1
 . . S TXT="'DESCRIPTION' failed FileMan's Input Transformation"
 . . S ^ZZLEXX("ZZLEXXR",$J,"TOT",80.1,5,"T")=TXT
 Q
 ;                       
DTXT(X,T,F) ; Display Text
 N ID,TXT,FLD S ID=+($G(X)) Q:+ID'>0  S TXT=$G(T) Q:'$L(TXT)  S FLD=$G(F) Q:'$L(FLD)
 D TL(TXT) S INC=$$INC(ID),STAT=0 S TOTERR=+($G(TOTERR))+1
 S TXT="'"_FLD_"' failed FileMan's Input Transformation"
 S ^ZZLEXX("ZZLEXXR",$J,"TOT",80.1,ID,"T")=TXT
 Q
FIX ; Fix file 80.1
 Q  N DA,EF,I,LA,LAD,LD,LID,LS,NTXT,TXT,STXT,FA,LDES,LDI,LDD,IDES
 S DA=0 F  S DA=$O(^ICD0(DA)) Q:+DA=0  D
 . S LDD=$O(^ICD0(DA,68,"B"," "),-1)
 . S LDES="",LDI=0 S:$L(LDD) LDI=$O(^ICD0(DA,68,"B",LDD," "),-1)
 . S:+LDI>0 LDES=$G(^ICD0(DA,68,LDI,1))
 . N I S I=0 F  S I=$O(^ICD0(DA,67,I)) Q:+I=0  D
 . . S $P(^ICD0(DA,67,I,0),"^",2)=$$TRIM($P($G(^ICD0(DA,67,I,0)),"^",2))
 . S I=0 F  S I=$O(^ICD0(DA,68,I)) Q:+I=0  D
 . . S $P(^ICD0(DA,68,I,1),"^",1)=$$TRIM($P($G(^ICD0(DA,68,I,1)),"^",1))
 . S LD=$O(^ICD0(DA,66,"B"," "),-1) I +LD>0 D
 . . S EF=$O(^ICD0(DA,66,"B",LD," "),-1) Q:+EF'>0
 . . S LS=$P($G(^ICD0(DA,66,+EF,0)),"^",2)
 . S FA=0,LD=0,LA="" F  S LD=$O(^ICD0(DA,66,"B",LD)) Q:+LD'>0  D
 . . S EF=0 F  S EF=$O(^ICD0(DA,66,"B",LD,EF)) Q:+EF'>0  D
 . . . S:$P($G(^ICD0(DA,66,+EF,0)),"^",2)>0&(+($P($G(^ICD0(DA,66,+EF,0)),"^",1))>0) LA=+($P($G(^ICD0(DA,66,+EF,0)),"^",1))
 . . . S:$P($G(^ICD0(DA,66,+EF,0)),"^",2)>0&(FA'>0) FA=+($P($G(^ICD0(DA,66,+EF,0)),"^",1))
 . I $L(STXT),+FA>0,'$D(^ICD0(DA,67,"B")) D
 . . S ^ICD0(DA,67,0)="^80.167D^1^1"
 . . S ^ICD0(DA,67,1,0)=FA_"^"_STXT
 . . S ^ICD0(DA,67,"B",FA,1)=""
 . I $L(LDES),+FA>0,'$D(^ICD0(DA,68,"B")) D
 . . S ^ICD0(DA,68,0)="^80.168D^1^1"
 . . S ^ICD0(DA,68,1,0)=FA
 . . S ^ICD0(DA,68,1,1)=LDES
 . . S ^ICD0(DA,68,"B",FA,1)=""
 Q
 ;                         
INC(X) ; Increment Error
 N ID S ID=+($G(X)) Q:+ID'>0 ""
 S X=+($G(^ZZLEXX("ZZLEXXR",$J,"TOT",80.1,ID)))+1
 S ^ZZLEXX("ZZLEXXR",$J,"TOT",80.1,ID)=+X
 Q X
INI ; Initialize Totals
 N TXT
 S TXT="All Active ICD Procedure codes are in the Lexicon"
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",80.1,1) S ^ZZLEXX("ZZLEXXR",$J,"TOT",80.1,1,"T")=TXT
 S TXT="All Inactive ICD Procedure codes are in the Lexicon"
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",80.1,2) S ^ZZLEXX("ZZLEXXR",$J,"TOT",80.1,2,"T")=TXT
 S TXT="All 'OPERATION/PROCEDURE' passed the FileMan's Input Transformation"
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",80.1,4) S ^ZZLEXX("ZZLEXXR",$J,"TOT",80.1,4,"T")=TXT
 S TXT="All 'DESCRIPTION' passed the FileMan's Input Transformation"
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",80.1,5) S ^ZZLEXX("ZZLEXXR",$J,"TOT",80.1,5,"T")=TXT
 Q
ST ; Show Global
 W !,"  " N NN,NC,ND S NN="^ZZLEXX(""ZZLEXXR"","_$J_",""TOT"",80.1)",NC="^ZZLEXX(""ZZLEXXR"","_$J_",""TOT"",80.1,"
 F  S NN=$Q(@NN) Q:NN=""!(NN'[NC)  D
 . S ND=@NN  W ND W:+ND'>0 !,"  " W:+ND>0 " "
 Q
CTL(X) ; Control Characters
 N TXT S TXT=$G(X)
 N I,CHR S X=0 F I=1:1 S CHR=$E($G(TXT),I) Q:'$L(CHR)  D
 . I $A(CHR)<32!($A(CHR)>126) S X=X+1
 Q X
IN(X,Y) ; Code is in Lexicon
 N SO,SR,SIEN,IN S IN=0
 S SO=$G(X) Q:'$L(SO) 0  S SR=+($G(Y)) Q:"^1^2^3^4^30^31^"'[("^"_SR_"^") 0
 S SIEN=0 F  S SIEN=$O(^LEX(757.02,"CODE",(SO_" "),SIEN)) Q:+SIEN=0  D
 . Q:$P($G(^LEX(757.02,SIEN,0)),"^",3)'=SR  S IN=1
 S X=IN Q X
TRIM(X) ; Trim Spaces
 S X=$G(X) F  Q:$E(X,1)'=" "  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=" "  S X=$E(X,1,($L(X)-1))
 Q X
CSID(X) ;
 N IEN,CS S IEN=+($G(X)),CS=+($G(^ICD9(+IEN,1)))
 Q:CS=1 "ICD-9"  Q:CS=30 "ICD-10"
 Q:CS=2 "ICD-9"  Q:CS=31 "ICD-10"
 Q ""
BL ; Blank Line
 D TL("") Q
AP(X,Y) ; Append Line at Y
 S X=$G(X),Y=+($G(Y)) S:Y'>0 Y=1
 I $G(ONE)>0 W ?Y,X Q
 W:'$D(ZTQUEUED) ?Y,$G(X),! Q:'$D(ZTQUEUED)
 N C,T S C=+($O(^ZZLEXX("ZZLEXXR",$J,"DRAFT"," "),-1)) Q:C'>0
 S T=$G(^ZZLEXX("ZZLEXXR",$J,"DRAFT",C))
 S:$L(T)'>Y T=T_$J(" ",(Y-$L(T))) S T=T_X
 S ^ZZLEXX("ZZLEXXR",$J,"DRAFT",C)=T N ZTQUEUED,ONE
 Q
TL(X) ; Text Line
 W:'$D(ZTQUEUED) !,$G(X) Q:'$D(ZTQUEUED)
 N C S C=+($G(^ZZLEXX("ZZLEXXR",$J,"DRAFT",0))),C=C+1
 S ^ZZLEXX("ZZLEXXR",$J,"DRAFT",C)=$G(X),^ZZLEXX("ZZLEXXR",$J,"DRAFT",0)=C Q
OUT ;
 Q:'$D(ONE)  Q:ONE'="80.1"  N TST
 W !!,"  ICD PROCEDURES                        ^ICD0(           #80.1"
 S TST=0 F  S TST=$O(^ZZLEXX("ZZLEXXR",$J,"TOT",80.1,TST)) Q:+TST'>0  D
 . N CT,TX S CT=$G(^ZZLEXX("ZZLEXXR",$J,"TOT",80.1,TST)),TX=$G(^ZZLEXX("ZZLEXXR",$J,"TOT",80.1,TST,"T"))
 . W !,?5 W:+CT>0 +CT," " W TX
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",80.1)
 Q
