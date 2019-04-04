ZZLEXXRL ;SLC/KER - Import - Rel Verify - 757.033 (1-9) ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^LEX(757.02         SACC 1.3
 ;    ^LEX(757.033        SACC 1.3
 ;    ^ZZLEXX("ZZLEXXR")  SACC 1.3
 ;               
 ; External References
 ;    ^DIK                ICR  10013
 ;    $$STATCHK^LEXSRC2   N/A
 ;    $$IMPDATE^LEXU      N/A
 ;    $$DT^XLFDT          ICR  10103
 ;    $$FMADD^XLFDT       ICR  10103
 ;    $$FMTE^XLFDT        ICR  10103
 ;               
 ; Local Variables NEWed or KILLed Elsewhere
 ;     TOTERR
 ;               
 Q
EN ; Character Positions - 757.033
 D INI N TXT,EXT,STAT,TD,ED,CDT,IMP,TAB D BL S STAT=1,CT=0,TAB=""
 S TD=$$DT^XLFDT,IMP=$$IMPDATE^LEXU(30) S ED=TD S:ED'>IMP ED=IMP
 S TXT="Character Positions",TXT=TXT_$J("",30-$L(TXT))_"^LEX(757.033," D TL(TXT)
 D DX,OP
 D:+($G(STAT))>0 AP(" OK",70)
 K ^ZZLEXX("ZZLEXXR",$J,"FRAG","FRAG"),^ZZLEXX("ZZLEXXR",$J,"FRAG","FRAG") N TEST
 Q
EN2 ; Character Positions (one)
 N ONE,TAB,FULL S FULL="" S ONE=757.033,TAB="    " D EN,OUT
 Q
DX ;   Diagnosis Categories
 K ^ZZLEXX("ZZLEXXR",$J,"FRAG","FRAG")
 N CDT,ORD,IMP S CDT=$$QTR,IMP=$$IMPDATE^LEXU(30) S:CDT<IMP CDT=IMP
 S ORD="" F  S ORD=$O(^LEX(757.02,"ADX",ORD)) Q:'$L(ORD)  D
 . N CODE,CAT,TEF,HIS,STX,LTX,CDS,PSN,STA,EFF,SIEN,DA,FRAG,FGID,CAT
 . S CODE=$TR(ORD," ","") Q:'$L(CODE)  S STA=$$STATCHK^LEXSRC2(CODE,CDT,,"10D") Q:+STA'>0
 . S SIEN=$P(STA,"^",2),OVER=$$OVER(CODE,CDT) D T1,T2
 S ORD="10D" F  S ORD=$O(^LEX(757.033,"B",ORD)) Q:'$L(ORD)!($E(ORD,1,3)'="10D")  D
 . N DA S DA=0 F  S DA=$O(^LEX(757.033,"B",ORD,DA)) Q:+DA=0  D
 . . N CAT,EFF,TEF,HIS,STX,LTX,CDS
 . . S CAT=$P($G(^LEX(757.033,DA,0)),"^",2) Q:'$L(CAT)
 . . Q:$D(^ZZLEXX("ZZLEXXR",$J,"FRAG","FRAG",CAT))
 . . S ^ZZLEXX("ZZLEXXR",$J,"FRAG","FRAG",CAT)=""
 . . S TEF=$O(^LEX(757.033,DA,1,"B",(CDT+.9999)),-1)
 . . S HIS=$O(^LEX(757.033,DA,1,"B",+TEF," "),-1)
 . . S STA=$G(^LEX(757.033,DA,1,+HIS,0))
 . . S STA=$P(STA,"^",2) Q:STA'=1
 . . S TEF=$O(^LEX(757.033,DA,2,"B",(CDT+.9999)),-1)
 . . S HIS=$O(^LEX(757.033,DA,2,"B",+TEF," "),-1)
 . . S STX=$G(^LEX(757.033,DA,2,+HIS,1))
 . . S TEF=$O(^LEX(757.033,DA,3,"B",(CDT+.9999)),-1)
 . . S HIS=$O(^LEX(757.033,DA,3,"B",+TEF," "),-1)
 . . S LTX=$G(^LEX(757.033,DA,3,+HIS,1))
 . . S CDS=$$COADX(CAT,CDT)
 . . D T3,T4,T5
 K ^ZZLEXX("ZZLEXXR",$J,"FRAG","FRAG")
 Q
OP ;   Procedure Fragments
 K ^ZZLEXX("ZZLEXXR",$J,"FRAG","FRAG")
 N CDT,ORD,IMP S CDT=$$QTR,IMP=$$IMPDATE^LEXU(30) S:CDT<IMP CDT=IMP
 S ORD="" F  S ORD=$O(^LEX(757.02,"APR",ORD)) Q:'$L(ORD)  D
 . N CODE,PSN,STA S CODE=$TR(ORD," ","") Q:'$L(CODE)
 . S STA=$$STATCHK^LEXSRC2(CODE,CDT,,"10P") Q:+STA'>0
 . F PSN=1:1:$L(CODE) D
 . . N FRAG,FGID S FRAG=$E(CODE,1,PSN) Q:'$L(FRAG)
 . . Q:$D(^ZZLEXX("ZZLEXXR",$J,"FRAG","FRAG",FRAG))
 . . S ^ZZLEXX("ZZLEXXR",$J,"FRAG","FRAG",FRAG)=""
 . . S FGID="10P"_FRAG
 . . D T6,T7
 S ORD="10P" F  S ORD=$O(^LEX(757.033,"B",ORD)) Q:'$L(ORD)!($E(ORD,1,3)'="10P")  D
 . N DA S DA=0 F  S DA=$O(^LEX(757.033,"B",ORD,DA)) Q:+DA=0  D
 . . N CAT,EFF,TEF,HIS,STX,LTX,CDS,FTX
 . . S CAT=$P($G(^LEX(757.033,DA,0)),"^",2) Q:'$L(CAT)
 . . Q:$D(^ZZLEXX("ZZLEXXR",$J,"FRAG","FRAG",CAT))
 . . S ^ZZLEXX("ZZLEXXR",$J,"FRAG","FRAG",CAT)=""
 . . S FTX=$G(^LEX(757.033,DA,2,1,1))
 . . S TEF=$O(^LEX(757.033,DA,1,"B",(CDT+.9999)),-1)
 . . S HIS=$O(^LEX(757.033,DA,1,"B",+TEF," "),-1)
 . . S STA=$G(^LEX(757.033,DA,1,+HIS,0))
 . . S STA=$P(STA,"^",2) Q:STA'=1
 . . S TEF=$O(^LEX(757.033,DA,2,"B",(CDT+.9999)),-1)
 . . S HIS=$O(^LEX(757.033,DA,2,"B",+TEF," "),-1)
 . . S STX=$G(^LEX(757.033,DA,2,+HIS,1))
 . . S TEF=$O(^LEX(757.033,DA,3,"B",(CDT+.9999)),-1)
 . . S HIS=$O(^LEX(757.033,DA,3,"B",+TEF," "),-1)
 . . S LTX=$G(^LEX(757.033,DA,3,+HIS,1))
 . . S CDS=$$COAPR(CAT,CDT)
 . . D T8,T9
 K ^ZZLEXX("ZZLEXXR",$J,"FRAG","FRAG")
 Q
 ;
 ; Diagnosis Test
T1 ;   1  An active ICD-10-CM Code cannot also be an
 ;        active ICD-10-CM category (overlapping)
 I +($G(STA))>0,+($G(OVER))>0,+($G(SIEN))>0 D  Q
 . S EID=1,INC=$$INC(EID),STAT=0
 . S TXT="ICD-10-CM code"_$S(+INC>1:"s ",1:" ")_"in file 757.02 overlaps with categories in file 757.033"
 . S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.033,EID,"T")=TXT
 . S TXT="  ICD-10-CM code "_CODE_", #"_SIEN_" is also an active category in file 757.033"
 . D TL(TXT) S TOTERR=+($G(TOTERR))+1
 Q
T2 ;   2  Every active ICD-10-CM Code must belongs to 
 ;        an active ICD-10-CM category
 I +($G(STA))>0,+($G(SIEN))>0,$L($G(CODE)),$G(CDT)?7N D  Q
 . N P1,P2,OK,PSN,STR,INC,TXT,EID S OK=0,P1=$$TM($P(CODE,".",1)),P2=$$TM($P(CODE,".",2))
 . Q:$L(P1)=3&('$L(P2))  F PSN=1:1:$L(CODE)  D
 . . N STR,EFF,IEN,IIEN,STA S STR=$E(CODE,1,PSN)
 . . S EFF=$O(^LEX(757.033,"AFRAG",30,(STR_" ")," "),-1) Q:EFF'?7N
 . . S IEN=$O(^LEX(757.033,"AFRAG",30,(STR_" "),+EFF," "),-1) Q:+IEN'>0
 . . S IIEN=$O(^LEX(757.033,"AFRAG",30,(STR_" "),+EFF,+IEN," "),-1) Q:+IIEN'>0
 . . S STA=$P($G(^LEX(757.033,+IEN,1,+IIEN,0)),"^",2) Q:STA'>0  S OK=1
 . Q:OK  S EID=2,INC=$$INC(EID),STAT=0
 . S TXT="ICD-10-CM code"_$S(+INC>1:"s do",1:" does")_" not have an active category"
 . S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.033,EID,"T")=TXT
 . S TXT="  ICD-10-CM Code "_CODE_", #"_SIEN_" has no active categories in file 757.033"
 . D TL(TXT) S TOTERR=+($G(TOTERR))+1
 Q
T3 ;   3  Every active ICD-10-CM Category must have 
 ;        active ICD-10-CM Diagnosis codes assigned
 N LA,CD S LA=$P($G(CDS),"^",2),CD=+($P($G(CDS),"^",1))
 S:$L(CAT)&(+($G(DA))'>0) DA=$O(^LEX(757.033,"B",("10D"_CAT),0))
 I +($G(STA))>0,+($G(CD))'>0,$L($G(CAT)) D  Q
 . N INC,TXT,EID S EID=3,INC=$$INC(EID),STAT=0
 . S TXT="ICD-10-CM categor"_$S(+INC>1:"ies do",1:"y does")_" not have codes assigned in file 757.02"
 . S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.033,EID,"T")=TXT
 . S:$G(LA)'?7N TXT="  ICD-10-CM category "_CAT_", #"_DA_", does not have codes"
 . S:$G(LA)?7N TXT="  ICD-10-CM category "_CAT_", #"_DA_", does not have codes since "_$$FMTE^XLFDT($G(LA),"5Z")
 . D TL(TXT) S TOTERR=+($G(TOTERR))+1
 Q
T4 ;   4  Every active ICD-10-CM Category must have 
 ;        a title/name
 S:$L(CAT)&(+($G(DA))'>0) DA=$O(^LEX(757.033,"B",("10D"_CAT),0))
 I +($G(STA))>0,'$L($G(STX)),$L($G(CAT)) D  Q
 . N INC,TXT,EID S EID=4,INC=$$INC(EID),STAT=0
 . S TXT="ICD-10-CM categor"_$S(+INC>1:"ies do",1:"y does")_" not have a title"
 . S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.033,EID,"T")=TXT
 . S TXT="  ICD-10-CM Category "_CAT_", #"_DA_", does not have a title in file 757.033"
 . D TL(TXT) S TOTERR=+($G(TOTERR))+1
 Q
T5 ;   5  Every active ICD-10-CM Category must have 
 ;        a description
 S:$L(CAT)&(+($G(DA))'>0) DA=$O(^LEX(757.033,"B",("10D"_CAT),0))
 I +($G(STA))>0,'$L($G(LTX)),$L($G(CAT)) D  Q
 . N INC,TXT,EID S EID=5,INC=$$INC(EID),STAT=0
 . S TXT="ICD-10-CM categor"_$S(+INC>1:"ies do",1:"y does")_" not have a description"
 . S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.033,EID,"T")=TXT
 . S TXT="  Category "_CAT_", #"_DA_", does not have a description in file 757.033"
 . D TL(TXT) S TOTERR=+($G(TOTERR))+1
 Q
 ;
 ; Procedure Test
T6 ;   6  Every active ICD-10-PCS code has all of its 
 ;        code fragments on file
 Q:'$L($G(FGID))  Q:$G(CDT)'?7N  Q:'$L(CODE)
 N EFF,HIS,STA,IEN S IEN=$O(^LEX(757.033,"B",FGID,0)) I +IEN'>0 D  Q
 . N INC,TXT,EID,EFF,HIS,STA S EID=6,INC=$$INC(EID),STAT=0
 . S TXT="ICD-10-PCS fragment"_$S(+INC>1:"s",1:"")_" not found in file 757.033"
 . S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.033,EID,"T")=TXT
 . S TXT="  ICD-10-PCS code "_CODE_" fragment "_FRAG_" not found in 757.033"
 . D TL(TXT) S TOTERR=+($G(TOTERR))+1 N FDID
 Q
T7 ;   7  Every fragment for an ICD-10-PCS code is active
 Q:'$L($G(FGID))  Q:$G(CDT)'?7N  Q:'$L(CODE)
 N EFF,HIS,STA,IEN S IEN=$O(^LEX(757.033,"B",FGID,0)) I +IEN>0 D  Q
 . N INC,TXT,EID,EFF,HIS,STA
 . S EFF=$O(^LEX(757.033,+IEN,1,"B",(CDT+.001)),-1)
 . S HIS=$O(^LEX(757.033,+IEN,1,"B",+EFF," "),-1)
 . S STA=$P($G(^LEX(757.033,+IEN,1,+HIS,0)),"^",2) Q:STA>0
 . S EID=7,INC=$$INC(EID),STAT=0
 . S TXT="ICD-10-PCS code fragment"_$S(+INC>1:"s",1:"")_" not active in file 757.033"
 . S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.033,EID,"T")=TXT
 . S TXT="  ICD-10-PCS code "_CODE_" fragment "_FRAG_" not active in 757.033"
 . D TL(TXT) S TOTERR=+($G(TOTERR))+1 N FDID
 Q
T8 ;   8  Every ICD-10-PCS code fragment has codes
 N LA,CD S LA=$P($G(CDS),"^",2),CD=+($P($G(CDS),"^",1))
 S:$L(CAT)&(+($G(DA))'>0) DA=$O(^LEX(757.033,"B",("10P"_CAT),0))
 I +($G(STA))>0,+($G(CD))'>0,$L($G(CAT)),+($G(DA))>0 D  Q
 . N INC,TXT,EID S EID=8,INC=$$INC(EID),STAT=0
 . S TXT="ICD-10-PCS code fragment"_$S(+INC>1:"s do",1:" does")_" not have active codes"
 . S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.033,EID,"T")=TXT
 . S:$G(LA)'?7N TXT="  ICD-10-PCS fragment "_CAT_", #"_DA_", does not have codes"
 . S:$G(LA)?7N TXT="  ICD-10-PCS fragment "_CAT_", #"_DA_", does not have codes since "_$$FMTE^XLFDT($G(LA),"5Z")
 . D TL(TXT) S TOTERR=+($G(TOTERR))+1
 Q
T9 ;   9  Every active ICD-10-PCS Fragment has a name
 S:$L(CAT)&(+($G(DA))'>0) DA=$O(^LEX(757.033,"B",("10D"_CAT),0))
 I +($G(STA))>0,'$L($G(STX)),$L($G(CAT)) D  Q
 . N INC,TXT,EID S EID=9,INC=$$INC(EID),STAT=0
 . S TXT="ICD-10-PCS fragment"_$S(+INC>1:"s do",1:" does")_" not have a title"
 . S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.033,EID,"T")=TXT
 . S TXT="  ICD-10-PCS fragment "_CAT_", #"_DA_", does not have a title in file 757.033"
 . D TL(TXT) S TOTERR=+($G(TOTERR))+1
 Q
 ;
INI ; Initialize Totals
 N TXT
 S TXT="No ICD-10-CM codes in 757.02 overlap with categories in 757.033"
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",757.033,1) S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.033,1,"T")=TXT
 S TXT="Every ICD-10-CM diagnosis code has a category in file 757.033"
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",757.033,2) S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.033,2,"T")=TXT
 S TXT="Every ICD-10-CM category has active codes assigned in file 757.02"
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",757.033,3) S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.033,3,"T")=TXT
 S TXT="Every ICD-10-CM category has a title in file 757.033"
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",757.033,4) S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.033,4,"T")=TXT
 S TXT="Every ICD-10-CM category has a description in file 757.033"
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",757.033,5) S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.033,5,"T")=TXT
 S TXT="Every ICD-10-PCS code has all of its fragments in file 757.033"
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",757.033,6) S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.033,6,"T")=TXT
 S TXT="Every ICD-10-PCS code fragment is active in file 757.033"
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",757.033,7) S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.033,7,"T")=TXT
 S TXT="Every ICD-10-PCS fragment has active codes assigned in 757.02"
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",757.033,8) S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.033,8,"T")=TXT
 Q
 ; Miscellaneous
INC(X) ;   Increment Error
 N ID S ID=+($G(X)) Q:+ID'>0 ""
 S X=+($G(^ZZLEXX("ZZLEXXR",$J,"TOT",757.033,ID)))+1,^ZZLEXX("ZZLEXXR",$J,"TOT",757.033,ID)=+X
 Q X
CAT(CODE) ;   Get Category for Code
 S CODE=$G(CODE) Q:'$L(CODE) ""  N FRAG,MAX,OUT,TDT,LEN S FRAG=$TR(CODE," ","")
 S OUT="",TDT=$P($G(LEXVDT),".",1),MAX=$L(FRAG) F LEN=MAX:-1:3 D  Q:$L(OUT)
 . N EFF,NAM,IEN S FRAG=$E(FRAG,1,(LEN-1))
 . S:$L(FRAG)=3&(FRAG'[".") FRAG=FRAG_"." Q:$L(FRAG)'>3
 . S EFF=$O(^LEX(757.033,"AFRAG",30,(FRAG_" ")," "),-1)
 . S:TDT?7N EFF=$O(^LEX(757.033,"AFRAG",30,(FRAG_" "),(TDT+.0001)),-1)
 . S EFF=$P(EFF,".",1) Q:EFF'?7N  I TDT?7N Q:EFF>TDT
 . S IEN=$O(^LEX(757.033,"AFRAG",30,(FRAG_" "),+EFF," "),-1)
 . S NAM=$$LN(IEN,+EFF) S:'$L(NAM) NAM=$$SN(IEN,+EFF) Q:'$L(NAM)
 . S:$L(FRAG)&(EFF?7N)&($L(NAM)) OUT=(FRAG_"^"_EFF_"^"_NAM)
 N LEXVDT
 Q OUT
COADX(X,Y,Z) ;   Number of Codes in a Category
 N CAT,CODE,ORG,ORD,CTL,CDT,LA,INI S (CTL,CAT)=$G(X),(ORG,ORD)=$E(CAT,1,($L(CAT)-1))_$C($A($E(CAT,$L(CAT)))-1)_"~",INI=+($G(Z))
 S CDT=$G(Y),X=0,LA="" S:CDT'?7N CDT=$$CDT F  S ORD=$O(^LEX(757.02,"ADX",ORD)) Q:'$L(ORD)!(ORD'[CTL)  D
 . N CODE,STA,ACD,IND S CODE=$TR(ORD," ","") Q:'$L(CODE)  S ACD=$O(^LEX(757.02,"ACT",(CODE_" "),3,(CDT+.001)),-1) Q:ACD'?7N
 . S IND=$O(^LEX(757.02,"ACT",(CODE_" "),2,(CDT+.001)),-1) S:IND>ACD&(IND?7N)&(IND>LA) LA=IND
 . Q:IND>ACD&(+($G(INI))>0)  S X=X+1
 S X=+($G(X)) S:$G(LA)?7N $P(X,"^",2)=LA
 Q X
COAPR(X,Y,Z) ;   Number of Codes for a Fragment
 N CAT,CODE,ORG,ORD,CTL,CDT,LA,INI S (CTL,CAT)=$G(X),(ORG,ORD)=$E(CAT,1,($L(CAT)-1))_$C($A($E(CAT,$L(CAT)))-1)_"~",INI=+($G(Z))
 S CDT=$G(Y),X=0,LA="" S:CDT'?7N CDT=$$CDT F  S ORD=$O(^LEX(757.02,"APR",ORD)) Q:'$L(ORD)!(ORD'[CTL)  D
 . N CODE,STA,ACD,IND S CODE=$TR(ORD," ","") Q:'$L(CODE)  S ACD=$O(^LEX(757.02,"ACT",(CODE_" "),3,(CDT+.001)),-1) Q:ACD'?7N
 . S IND=$O(^LEX(757.02,"ACT",(CODE_" "),2,(CDT+.001)),-1) S:IND>ACD&(IND?7N)&(IND>LA) LA=IND
 . Q:IND>ACD&(+($G(INI))>0)  S X=X+1
 S X=+($G(X)) S:$G(LA)?7N $P(X,"^",2)=LA
 Q X
OVER(X,Y) ;   Overlapping Code/Category
 N CAT,COD,CDT,FID,IEN,LA,SAB,STA,STA1,STA2,OVER S COD=$G(X) Q:'$L(COD) 0  S SAB=$S(COD[".":"10D",1:"10P")
 S CDT=$G(Y),X=0,LA="" S:CDT'?7N CDT=$$CDT S STA=$$STATCHK^LEXSRC2(COD,CDT,,SAB),STA1=+STA Q:STA1'>0 0
 S OVER=0,FID=(SAB_COD),IEN=0 F  S IEN=$O(^LEX(757.033,"B",FID,IEN)) Q:+IEN'>0  D
 . N CAT,EFF,HIS,STA2 S CAT=$P($G(^LEX(757.033,+IEN,0)),"^",2),EFF=$O(^LEX(757.033,+IEN,1,"B",(CDT+.0001)),-1)
 . S HIS=$O(^LEX(757.033,+IEN,1,"B",+EFF," "),-1),STA2=$P($G(^LEX(757.033,+IEN,1,+HIS,0)),"^",2) Q:STA2'>0
 . S:$G(COD)=$G(CAT)&($G(STA1)>0)&($G(STA2)>0)&($G(STA1)=$G(STA2)) OVER=1
 S X=OVER
 Q X
SN(X,EFF) ;   Short Name
 N IEN,CDT,IMP,EFF,HIS S IEN=+($G(X)),CDT=$G(LEXVDT) S:$G(EFF)?7N CDT=$G(EFF)
 S IMP=$$IMPDATE^LEXU(30) S:CDT'?7N CDT=$$DT^XLFDT
 S:CDT'>IMP&(IMP?7N) CDT=IMP
 S EFF=$O(^LEX(757.033,+IEN,2,"B",(CDT+.001)),-1)
 S HIS=$O(^LEX(757.033,+IEN,2,"B",+EFF," "),-1)
 S X=$G(^LEX(757.033,+IEN,2,+HIS,1))
 Q X
LN(X,EFF) ;   Long Name
 N IEN,CDT,IMP,EFF,HIS S IEN=+($G(X)),CDT=$G(LEXVDT) S:$G(EFF)?7N CDT=$G(EFF)
 S IMP=$$IMPDATE^LEXU(30) S:CDT'?7N CDT=$$DT^XLFDT
 S:CDT'>IMP&(IMP?7N) CDT=IMP
 S EFF=$O(^LEX(757.033,+IEN,3,"B",(CDT+.001)),-1)
 S HIS=$O(^LEX(757.033,+IEN,3,"B",+EFF," "),-1)
 S X=$G(^LEX(757.033,+IEN,3,+HIS,1))
 Q X
TM(X,Y) ;   Trim Character Y - Default " "
 S X=$G(X) Q:X="" X  S Y=$G(Y) S:'$L(Y) Y=" " F  Q:$E(X,1)'=Y  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=Y  S X=$E(X,1,($L(X)-1))
 Q X
BL ;   Blank Line
 D TL("") Q
AP(X,Y) ;   Append Line at Y
 S X=$G(X),Y=+($G(Y)) S:Y'>0 Y=1
 I $G(ONE)>0 W ?Y,X Q
 W:'$D(ZTQUEUED) ?Y,$G(X),! Q:'$D(ZTQUEUED)
 N C,T S C=+($O(^ZZLEXX("ZZLEXXR",$J,"DRAFT"," "),-1)) Q:C'>0
 S T=$G(^ZZLEXX("ZZLEXXR",$J,"DRAFT",C))
 S:$L(T)'>Y T=T_$J(" ",(Y-$L(T))) S T=T_X
 S ^ZZLEXX("ZZLEXXR",$J,"DRAFT",C)=T
 Q
TL(X) ;   Text Line
 W:'$D(ZTQUEUED) !,$G(X) Q:'$D(ZTQUEUED)
 N C S C=+($G(^ZZLEXX("ZZLEXXR",$J,"DRAFT",0))),C=C+1
 S ^ZZLEXX("ZZLEXXR",$J,"DRAFT",C)=$G(X),^ZZLEXX("ZZLEXXR",$J,"DRAFT",0)=C
 N ZTQUEUED
 Q
CDT(X) ;   Code Set Date
 N IMP S X=$$QTR,IMP=$$IMPDATE^LEXU(30) S:X<IMP X=IMP
 Q X
QTR(X) ;   Get Quarter
 N QTR,TD,FD,YR,MO,DA S TD=$$DT^XLFDT,FD=$$FMADD^XLFDT(TD,100)
 S YR=$E(FD,1,3),MO=$E(FD,4,5),DA="01" S:+MO>0&(+MO<4) MO="01" S:+MO>3&(+MO<7) MO="04" S:+MO>6&(+MO<10) MO="07" S:+MO>9&(+MO<13) MO="10"
 S X=YR_MO_DA
 Q X
OUT ;
 Q:'$D(ONE)  Q:ONE'="757.033"  N TST
 W !!,"  CHARACTER POSITIONS                   ^LEX(757.033,    #757.033"
 S TST=0 F  S TST=$O(^ZZLEXX("ZZLEXXR",$J,"TOT",757.033,TST)) Q:+TST'>0  D
 . N CT,TX S CT=$G(^ZZLEXX("ZZLEXXR",$J,"TOT",757.033,TST)),TX=$G(^ZZLEXX("ZZLEXXR",$J,"TOT",757.033,TST,"T"))
 . W !,?5 W:+CT>0 +CT," " W TX
 K ^ZZLEXX("ZZLEXXR",$J,"TOT",757.033)
 Q
