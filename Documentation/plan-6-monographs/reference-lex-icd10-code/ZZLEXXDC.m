ZZLEXXDC ;SLC/KER - Import - ICD-10-CM Cat - Changes ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^LEX(757.033,       SACC 1.3
 ;    ^ZZLEXX("ZZLEXXD"   SACC 1.3
 ;               
 ; External References
 ;    $$NOW^XLFDT         ICR  10103
 ;               
 Q
CCHG ;   ICD-10-CM Changes
 N MAXLEN S MAXLEN=$$MAX^ZZLEXXDA Q:+($G(MAXLEN))'>0  W !,?3,"ICD-10-CM Diagnosis Changes "
 K ^ZZLEXX("ZZLEXXD","CAT","DT","CC"),^ZZLEXX("ZZLEXXD","CAT","DT","CC","ON"),^ZZLEXX("ZZLEXXD","CAT","CHG","CM")
 N CIEN,CT,FID,FND,I,NC,ND,NF,NN,OF,OK,ORD,OVAL,REFF,RHIS,RIEN,RVAL,SEFF,SEG,SID,TF,UVAL,VERDT,MAX
 S MAX=MAXLEN,ORD="" F  S ORD=$O(^ZZLEXX("ZZLEXXD","CAT","CM",ORD)) Q:'$L(ORD)  D
 . N SEG,FID,SID,CIEN,VERDT,RVAL,OVAL,COD
 . S COD=$P($G(^ZZLEXX("ZZLEXXD","CAT","CM",ORD,0)),"^",1)
 . S (VERDT,SEFF)=$P($G(^ZZLEXX("ZZLEXXD","CAT","CM",ORD,1)),"^",2) Q:SEFF'?7N
 . S:VERDT>$G(^ZZLEXX("ZZLEXXD","CAT","DT","CHG")) ^ZZLEXX("ZZLEXXD","CAT","DT","CHG")=VERDT
 . S SEG=$TR(ORD," ",""),FID="10D"_SEG,SID=(SEG_" ")
 . S CIEN=$O(^LEX(757.033,"B",FID,0))
 . ;     Added
 . I +CIEN'>0 D  Q
 . . M ^ZZLEXX("ZZLEXXD","CAT","CHG","CM","AD",SID)=^ZZLEXX("ZZLEXXD","CAT","CM",SID)
 . . S ^ZZLEXX("ZZLEXXD","CAT","CHG","CM","AD",SID)=SEG
 . . I '$L($G(^ZZLEXX("ZZLEXXD","CAT","CHG","CM","AD",SID,1))) D
 . . . N ERR S ERR="WARNING:  New Code """_$TR(SID," ","")_""" missing Effective Date"
 . . . S ^ZZLEXX("ZZLEXXD","CAT","CHG","CM","AD",SID,1,"W")=ERR,^ZZLEXX("ZZLEXXD","CAT","CHG","WARN","CM",SID,1,1)=ERR
 . . I '$L($G(^ZZLEXX("ZZLEXXD","CAT","CHG","CM","AD",SID,2))) D
 . . . N ERR S ERR="WARNING:  New Code """_$TR(SID," ","")_""" missing Name/Title"
 . . . S ^ZZLEXX("ZZLEXXD","CAT","CHG","CM","AD",SID,2,"W")=ERR,^ZZLEXX("ZZLEXXD","CAT","CHG","WARN","CM",SID,2,1)=ERR
 . . I '$L($G(^ZZLEXX("ZZLEXXD","CAT","CHG","CM","AD",SID,3))) D
 . . . Q  N ERR S ERR="WARNING:  New Code """_$TR(SID," ","")_""" missing Description"
 . . . S ^ZZLEXX("ZZLEXXD","CAT","CHG","CM","AD",SID,3,"W")=ERR,^ZZLEXX("ZZLEXXD","CAT","CHG","WARN","CM",SID,3,1)=ERR
 . . I +($G(MAX))>0 D
 . . . I $L($G(^ZZLEXX("ZZLEXXD","CAT","CHG","CM","AD",SID,2)))>MAX D
 . . . . N ERR S ERR="WARNING:  New Code """_$TR(SID," ","")_""" Name/Title exceeds "_MAX_" characters"
 . . . . S ^ZZLEXX("ZZLEXXD","CAT","CHG","CM","AD",SID,2,"W")=ERR,^ZZLEXX("ZZLEXXD","CAT","CHG","WARN","CM",SID,2,1)=ERR
 . . . I $L($G(^ZZLEXX("ZZLEXXD","CAT","CHG","CM","AD",SID,3)))>MAX D
 . . . . N ERR S ERR="WARNING:  New Code """_$TR(SID," ","")_""" Discription exceeds "_MAX_" characters"
 . . . . S ^ZZLEXX("ZZLEXXD","CAT","CHG","CM","AD",SID,3,"W")=ERR,^ZZLEXX("ZZLEXXD","CAT","CHG","WARN","CM",SID,3,1)=ERR
 . . S ^ZZLEXX("ZZLEXXD","CAT","CHG","CM","AD")=$G(^ZZLEXX("ZZLEXXD","CAT","CHG","CM","AD"))+1
 . ;     2 Short Name
 . S RVAL=$G(^ZZLEXX("ZZLEXXD","CAT","CM",SID,2)) I $L(RVAL) D
 . . N UVAL,RIEN,REFF,RHIS,FND,OVAL
 . . S REFF=$O(^LEX(757.033,CIEN,2,"B",(VERDT+.001)),-1)
 . . S RHIS=$O(^LEX(757.033,CIEN,2,"B",+REFF," "),-1)
 . . S OVAL=$G(^LEX(757.033,CIEN,2,+RHIS,1))
 . . I $L(OVAL),OVAL'=RVAL D
 . . . S ^ZZLEXX("ZZLEXXD","CAT","CHG","CM","SR",SID)=VERDT
 . . . S ^ZZLEXX("ZZLEXXD","CAT","CHG","CM","SR",SID,0)=RVAL
 . . . I $L(RVAL)>MAXLEN D
 . . . . S ^ZZLEXX("ZZLEXXD","CAT","CHG","CM","SR",SID,0,"W")="WARNING:  Exceeds "_MAXLEN_" characters ("_$L(RVAL)_")"
 . . . . S ^ZZLEXX("ZZLEXXD","CAT","CHG","WARN","CM",SID,2,0)=RVAL
 . . . . S ^ZZLEXX("ZZLEXXD","CAT","CHG","WARN","CM",SID,2,1)="WARNING:  Name/Title exceeds "_MAXLEN_" characters ("_$L(RVAL)_")"
 . . . . S ^ZZLEXX("ZZLEXXD","CAT","CHG","WARN","CM")=$G(^ZZLEXX("ZZLEXXD","CAT","CHG","WARN","CM"))+1,^ZZLEXX("ZZLEXXD","CAT","CHG","WARN")=$G(^ZZLEXX("ZZLEXXD","CAT","CHG","WARN"))+1
 . . . S ^ZZLEXX("ZZLEXXD","CAT","CHG","CM","SR",SID,1)=OVAL
 . . . S ^ZZLEXX("ZZLEXXD","CAT","CHG","CM","SR")=$G(^ZZLEXX("ZZLEXXD","CAT","CHG","CM","SR"))+1
 . . I '$L(OVAL),OVAL'=RVAL D
 . . . S ^ZZLEXX("ZZLEXXD","CAT","CHG","CM","SN",SID)=VERDT
 . . . S ^ZZLEXX("ZZLEXXD","CAT","CHG","CM","SN",SID,0)=RVAL
 . . . I $L(RVAL)>MAXLEN D
 . . . . S ^ZZLEXX("ZZLEXXD","CAT","CHG","CM","SN",SID,0,"W")="WARNING:  Exceeds "_MAXLEN_" characters ("_$L(RVAL)_")"
 . . . . S ^ZZLEXX("ZZLEXXD","CAT","CHG","WARN","CM",SID,2,0)=RVAL
 . . . . S ^ZZLEXX("ZZLEXXD","CAT","CHG","WARN","CM",SID,2,1)="WARNING:  Name/Title exceeds "_MAXLEN_" characters ("_$L(RVAL)_")"
 . . . . S ^ZZLEXX("ZZLEXXD","CAT","CHG","WARN","CM")=$G(^ZZLEXX("ZZLEXXD","CAT","CHG","WARN","CM"))+1,^ZZLEXX("ZZLEXXD","CAT","CHG","WARN")=$G(^ZZLEXX("ZZLEXXD","CAT","CHG","WARN"))+1
 . . . S ^ZZLEXX("ZZLEXXD","CAT","CHG","CM","SN")=$G(^ZZLEXX("ZZLEXXD","CAT","CHG","CM","SN"))+1
 . ;     3 Description/Definition
 . S RVAL=$G(^ZZLEXX("ZZLEXXD","CAT","CM",SID,3)) I $L(RVAL) D
 . . N UVAL,RIEN,REFF,RHIS,FND,OVAL
 . . S REFF=$O(^LEX(757.033,CIEN,3,"B",(VERDT+.001)),-1)
 . . S RHIS=$O(^LEX(757.033,CIEN,3,"B",+REFF," "),-1)
 . . S OVAL=$G(^LEX(757.033,CIEN,3,+RHIS,1))
 . . I $L(OVAL),OVAL'=RVAL D
 . . . S ^ZZLEXX("ZZLEXXD","CAT","CHG","CM","LR",SID)=VERDT
 . . . S ^ZZLEXX("ZZLEXXD","CAT","CHG","CM","LR",SID,0)=RVAL
 . . . I $L(RVAL)>MAXLEN D
 . . . . S ^ZZLEXX("ZZLEXXD","CAT","CHG","CM","LR",SID,0,"W")="WARNING:  Exceeds "_MAXLEN_" characters ("_$L(RVAL)_")"
 . . . . S ^ZZLEXX("ZZLEXXD","CAT","CHG","WARN","CM",SID,3,0)=RVAL
 . . . . S ^ZZLEXX("ZZLEXXD","CAT","CHG","WARN","CM",SID,3,1)="WARNING:  Description/Definition exceeds "_MAXLEN_" characters ("_$L(RVAL)_")"
 . . . . S ^ZZLEXX("ZZLEXXD","CAT","CHG","WARN","CM")=$G(^ZZLEXX("ZZLEXXD","CAT","CHG","WARN","CM"))+1,^ZZLEXX("ZZLEXXD","CAT","CHG","WARN")=$G(^ZZLEXX("ZZLEXXD","CAT","CHG","WARN"))+1
 . . . S ^ZZLEXX("ZZLEXXD","CAT","CHG","CM","LR",SID,1)=OVAL
 . . . S ^ZZLEXX("ZZLEXXD","CAT","CHG","CM","LR")=$G(^ZZLEXX("ZZLEXXD","CAT","CHG","CM","LR"))+1
 . . I '$L(OVAL),OVAL'=RVAL D
 . . . S ^ZZLEXX("ZZLEXXD","CAT","CHG","CM","LN",SID)=VERDT
 . . . S ^ZZLEXX("ZZLEXXD","CAT","CHG","CM","LN",SID,0)=RVAL
 . . . I $L(RVAL)>MAXLEN D
 . . . . S ^ZZLEXX("ZZLEXXD","CAT","CHG","CM","LN",SID,0,"W")="WARNING:  Exceeds "_MAXLEN_" characters ("_$L(RVAL)_")"
 . . . . S ^ZZLEXX("ZZLEXXD","CAT","CHG","WARN","CM",SID,3,0)=RVAL
 . . . . S ^ZZLEXX("ZZLEXXD","CAT","CHG","WARN","CM",SID,3,1)="WARNING:  Description/Definition exceeds "_MAXLEN_" characters ("_$L(RVAL)_")"
 . . . . S ^ZZLEXX("ZZLEXXD","CAT","CHG","WARN","CM")=$G(^ZZLEXX("ZZLEXXD","CAT","CHG","WARN","CM"))+1,^ZZLEXX("ZZLEXXD","CAT","CHG","WARN")=$G(^ZZLEXX("ZZLEXXD","CAT","CHG","WARN"))+1
 . . . S ^ZZLEXX("ZZLEXXD","CAT","CHG","CM","LN")=$G(^ZZLEXX("ZZLEXXD","CAT","CHG","CM","LN"))+1
 S ORD="10D" F  S ORD=$O(^LEX(757.033,"B",ORD)) Q:'$L(ORD)!(ORD'["10D")  D
 . N CIEN S CIEN=0 F  S CIEN=$O(^LEX(757.033,"B",ORD,CIEN)) Q:+CIEN'>0  D
 . . N FRG,EFF,HIS,STA,VERDT,CHK
 . . S VERDT=$G(^ZZLEXX("ZZLEXXD","CAT","DT","CHG"))
 . . S FRG=$P($G(^LEX(757.033,CIEN,0)),"^",2) Q:'$L(FRG)
 . . S CHK=FRG_" ",EFF=$O(^LEX(757.033,CIEN,1,"B",9999999),-1)
 . . S EFF=$O(^LEX(757.033,CIEN,1,"B",9999999),-1)
 . . S HIS=$O(^LEX(757.033,CIEN,1,"B",+EFF," "),-1)
 . . S STA=$P($G(^LEX(757.033,CIEN,1,+HIS,0)),"^",2)
 . . I +STA>0,'$D(^ZZLEXX("ZZLEXXD","CAT","CM",CHK)) D
 . . . S ^ZZLEXX("ZZLEXXD","CAT","CHG","CM","IA",FRG)=VERDT
 . . . S ^ZZLEXX("ZZLEXXD","CAT","CHG","CM","IA")=$G(^ZZLEXX("ZZLEXXD","CAT","CHG","CM","IA"))+1
 . . I +STA'>0,$D(^ZZLEXX("ZZLEXXD","CAT","CM",CHK)) D
 . . . S ^ZZLEXX("ZZLEXXD","CAT","CHG","CM","RA",FRG)=VERDT
 . . . S ^ZZLEXX("ZZLEXXD","CAT","CHG","CM","RA")=$G(^ZZLEXX("ZZLEXXD","CAT","CHG","CM","RA"))+1
 I $D(^ZZLEXX("ZZLEXXD","CAT","CM")),$L($O(^ZZLEXX("ZZLEXXD","CAT","CM",""))) D
 . I $G(^ZZLEXX("ZZLEXXD","CAT","DT","CM"))?7N,$P($G(^ZZLEXX("ZZLEXXD","CAT","DT","CM","ON")),".",1)?7N  D
 . . N VER,CDT,CON S VER=$$VER($G(^ZZLEXX("ZZLEXXD","CAT","DT","CM"))) Q:VER'?4N  Q:VER'>2010
 . . S CDT=$G(^ZZLEXX("ZZLEXXD","CAT","DT","CM")) Q:CDT'?7N  S CON=$$NOW^XLFDT
 . . S ^ZZLEXX("ZZLEXXD","CAT","DT","CC")=CDT,^ZZLEXX("ZZLEXXD","CAT","DT","CC","ON")=CON
 . . S:CDT>$G(^ZZLEXX("ZZLEXXD","CAT","CHG","DT")) ^ZZLEXX("ZZLEXXD","CAT","CHG","DT")=CDT S ^ZZLEXX("ZZLEXXD","CAT","CHG","DT","ON")=CON
 . . S:CDT>$G(^ZZLEXX("ZZLEXXD","CAT","DT","CHG")) ^ZZLEXX("ZZLEXXD","CAT","DT","CHG")=CDT S ^ZZLEXX("ZZLEXXD","CAT","DT","CHG","ON")=CON
 I $D(^ZZLEXX("ZZLEXXD","CAT","LOAD","TIM","BEG")) D
 . N BEG,END,ELP,HR S BEG=$G(^ZZLEXX("ZZLEXXD","CAT","LOAD","TIM","BEG")) Q:$P(BEG,".",1)'?7N
 . H 1 S ^ZZLEXX("ZZLEXXD","CAT","LOAD","TIM","ST2")=$$NOW^XLFDT H 2
 . S END=$$NOW^XLFDT,ELP=$$FMDIFF^XLFDT(END,BEG,3)
 . S HR=$$TM($P(ELP,":",1)) S:$L(HR)'=2 HR="0"_HR S:$L(HR)'=2 HR="0"_HR S $P(ELP,":",1)=HR
 . S ^ZZLEXX("ZZLEXXD","CAT","LOAD","TIM","END")=END
 . S ^ZZLEXX("ZZLEXXD","CAT","LOAD","TIM","ELP")=ELP
 W ?33,"Done",!
 Q
 ;
 ; Miscellaneous
VER(X) ;     Version
 S X=$P($G(X),".",1) Q:X'?7N ""  N YR,MD S YR=$E(X,1,3)+1700,MD=$E(X,4,5) S:+MD>9 YR=YR+1 S X=YR
 Q X
CC ;   Compile Totals
 N SYS,TOT,TY,TT S SYS="CM",TT=0,TY="" F  S TY=$O(^ZZLEXX("ZZLEXXD","CAT","CHG",SYS,TY)) Q:'$L(TY)  D
 . Q:TY="ON"  Q:TY="DT"  S TT=TT+$G(^ZZLEXX("ZZLEXXD","CAT","CHG",SYS,TY))
 S:+TT>0 ^ZZLEXX("ZZLEXXD","CAT","CHG",SYS)=TT,TOT=TOT+TT
 S:TOT>0 ^ZZLEXX("ZZLEXXD","CAT","CHG")=TOT
 Q
TM(X,Y) ;   Trim Character Y - Default " "
 S X=$G(X) Q:X="" X  S Y=$G(Y) S:'$L(Y) Y=" "
 F  Q:$E(X,1)'=Y  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=Y  S X=$E(X,1,($L(X)-1))
 Q X
TN(X) ; Type Name
 N TY S TY=$G(X) Q:TY="SN"!(TY="SR") "Name/Title"  Q:TY="LN"!(TY="LR") "Description/Definition"
 Q:TY="EN"!(TY="ER") "Explanations"  Q:TY="IN"!(TY="IR") "Inclusions/Synonyms"
 Q ""
NN(X) ; Node Number
 N TY S TY=$G(X)  Q:TY="SN"!(TY="SR") 2  Q:TY="LN"!(TY="LR") 3  Q:TY="EN"!(TY="ER") 4  Q:TY="IN"!(TY="IR") 5
 Q ""
