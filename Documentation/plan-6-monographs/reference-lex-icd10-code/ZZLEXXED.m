ZZLEXXED ;SLC/KER - Import - ICD-10-PCS Frag - Changes ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^LEX(757.033)       SACC 1.3
 ;    ^ZZLEXX("ZZLEXXE"   SACC 1.3
 ;               
 ; External References
 ;    $$NOW^XLFDT         ICR  10103
 ;    $$UP^XLFSTR         ICR  10103
 ;               
 Q
PCHG ;   ICD-10-PCS Changes
 N MAXLEN S MAXLEN=$$MAX^ZZLEXXEA Q:+($G(MAXLEN))'>0  W !,?3,"ICD-10-PCS Procedure Changes "
 K ^ZZLEXX("ZZLEXXE","PCS","DT","CP"),^ZZLEXX("ZZLEXXE","PCS","DT","CP","ON"),^ZZLEXX("ZZLEXXE","PCS","CHG","PCS")
 K ^ZZLEXX("ZZLEXXE","PCS","LOAD","SYS"),^ZZLEXX("ZZLEXXE","PCS","LOAD","TOT"),^ZZLEXX("ZZLEXXE","PCS","LOAD","TYP")
 S ^ZZLEXX("ZZLEXXE","PCS","LOAD")=0,^ZZLEXX("ZZLEXXE","PCS","LOAD","TOT")=0
 N CIEN,CT,FID,FND,I,NC,ND,NF,NN,OF,OK,ORD,OVAL,REFF,RHIS,RIEN,RVAL,SEFF,SEG,SID,TF,UVAL,MAX
 S MAX=MAXLEN,ORD="" F  S ORD=$O(^ZZLEXX("ZZLEXXE","PCS","PCS",ORD)) Q:'$L(ORD)  D
 . N SEG,FID,SID,CIEN,SEFF,RVAL,OVAL,VERDT
 . S (VERDT,SEFF)=$P($G(^ZZLEXX("ZZLEXXE","PCS","PCS",ORD,1)),"^",2) Q:SEFF'?7N
 . S:VERDT>$G(^ZZLEXX("ZZLEXXE","PCS","DT","CHG")) ^ZZLEXX("ZZLEXXE","PCS","DT","CHG")=VERDT
 . S SEG=$TR(ORD," ",""),FID="10P"_SEG,SID=(SEG_" ")
 . S CIEN=$O(^LEX(757.033,"B",FID,0))
 . ;     Added
 . I +CIEN'>0 D  Q
 . . M ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","AD",SID)=^ZZLEXX("ZZLEXXE","PCS","PCS",SID)
 . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","AD",SID)=SEG
 . . I '$L($G(^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","AD",SID,1))) D
 . . . N ERR S ERR="WARNING:  New Code """_$TR(SID," ","")_""" missing Effective Date"
 . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","AD",SID,1,"W")=ERR,^ZZLEXX("ZZLEXXE","PCS","CHG","WARN","PCS",SID,1,1)=ERR
 . . I '$L($G(^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","AD",SID,2))) D
 . . . N ERR S ERR="WARNING:  New Code """_$TR(SID," ","")_""" missing Name/Title"
 . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","AD",SID,2,"W")=ERR,^ZZLEXX("ZZLEXXE","PCS","CHG","WARN","PCS",SID,2,1)=ERR
 . . I '$L($G(^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","AD",SID,3))) D
 . . . Q  N ERR S ERR="WARNING:  New Code """_$TR(SID," ","")_""" missing Description"
 . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","AD",SID,3,"W")=ERR,^ZZLEXX("ZZLEXXE","PCS","CHG","WARN","PCS",SID,3,1)=ERR
 . . I +($G(MAX))>0 D
 . . . I $L($G(^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","AD",SID,2)))>MAX D
 . . . . N ERR S ERR="WARNING:  New Code """_$TR(SID," ","")_""" Name/Title exceeds "_MAX_" characters"
 . . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","AD",SID,2,"W")=ERR,^ZZLEXX("ZZLEXXE","PCS","CHG","WARN","PCS",SID,2,1)=ERR
 . . . I $L($G(^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","AD",SID,3)))>MAX D
 . . . . N ERR S ERR="WARNING:  New Code """_$TR(SID," ","")_""" Discription exceeds "_MAX_" characters"
 . . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","AD",SID,3,"W")=ERR,^ZZLEXX("ZZLEXXE","PCS","CHG","WARN","PCS",SID,3,1)=ERR
 . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","AD")=$G(^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","AD"))+1
 . ;     2 Short Name
 . S RVAL=$G(^ZZLEXX("ZZLEXXE","PCS","PCS",SID,2)) I $L(RVAL) D
 . . N UVAL,RIEN,REFF,RHIS,FND,OVAL
 . . S REFF=$O(^LEX(757.033,CIEN,2,"B",(VERDT+.001)),-1)
 . . S RHIS=$O(^LEX(757.033,CIEN,2,"B",+REFF," "),-1)
 . . S OVAL=$G(^LEX(757.033,CIEN,2,+RHIS,1))
 . . I $L(OVAL),OVAL'=RVAL D
 . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","SR",SID)=VERDT
 . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","SR",SID,0)=RVAL
 . . . I $L(RVAL)>MAXLEN D
 . . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","SR",SID,0,"W")="WARNING:  Exceeds "_MAXLEN_" characters ("_$L(RVAL)_")"
 . . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","WARN","PCS",SID,2,0)=RVAL
 . . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","WARN","PCS",SID,2,1)="WARNING:  Name/Title exceeds "_MAXLEN_" characters ("_$L(RVAL)_")"
 . . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","WARN","PCS")=$G(^ZZLEXX("ZZLEXXE","PCS","CHG","WARN","PCS"))+1
 . . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","WARN")=$G(^ZZLEXX("ZZLEXXE","PCS","CHG","WARN"))+1
 . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","SR",SID,1)=OVAL
 . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","SR")=$G(^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","SR"))+1
 . . I '$L(OVAL),OVAL'=RVAL D
 . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","SN",SID)=VERDT
 . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","SN",SID,0)=RVAL
 . . . I $L(RVAL)>MAXLEN D
 . . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","SN",SID,0,"W")="WARNING:  Exceeds "_MAXLEN_" characters ("_$L(RVAL)_")"
 . . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","WARN","PCS",SID,2,0)=RVAL
 . . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","WARN","PCS",SID,2,1)="WARNING:  Name/Title exceeds "_MAXLEN_" characters ("_$L(RVAL)_")"
 . . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","WARN","PCS")=$G(^ZZLEXX("ZZLEXXE","PCS","CHG","WARN","PCS"))+1
 . . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","WARN")=$G(^ZZLEXX("ZZLEXXE","PCS","CHG","WARN"))+1
 . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","SN")=$G(^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","SN"))+1
 . ;     3 Description/Definition
 . S RVAL=$G(^ZZLEXX("ZZLEXXE","PCS","PCS",SID,3)) I $L(RVAL) D
 . . N UVAL,RIEN,REFF,RHIS,FND,OVAL
 . . S REFF=$O(^LEX(757.033,CIEN,3,"B",(VERDT+.001)),-1)
 . . S RHIS=$O(^LEX(757.033,CIEN,3,"B",+REFF," "),-1)
 . . S OVAL=$G(^LEX(757.033,CIEN,3,+RHIS,1))
 . . I $L(OVAL),OVAL'=RVAL D
 . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","LR",SID)=VERDT
 . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","LR",SID,0)=RVAL
 . . . I $L(RVAL)>MAXLEN D
 . . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","LR",SID,0,"W")="WARNING:  Exceeds "_MAXLEN_" characters ("_$L(RVAL)_")"
 . . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","WARN","PCS",SID,3,0)=RVAL
 . . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","WARN","PCS",SID,3,1)="WARNING:  Description/Definition exceeds "_MAXLEN_" characters ("_$L(RVAL)_")"
 . . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","WARN","PCS")=$G(^ZZLEXX("ZZLEXXE","PCS","CHG","WARN","PCS"))+1
 . . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","WARN")=$G(^ZZLEXX("ZZLEXXE","PCS","CHG","WARN"))+1
 . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","LR",SID,1)=OVAL
 . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","LR")=$G(^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","LR"))+1
 . . I '$L(OVAL),OVAL'=RVAL D
 . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","LN",SID)=VERDT
 . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","LN",SID,0)=RVAL
 . . . I $L(RVAL)>MAXLEN D
 . . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","LN",SID,0,"W")="WARNING:  Exceeds "_MAXLEN_" characters ("_$L(RVAL)_")"
 . . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","WARN","PCS",SID,3,0)=RVAL
 . . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","WARN","PCS",SID,3,1)="WARNING:  Description/Definition exceeds "_MAXLEN_" characters ("_$L(RVAL)_")"
 . . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","WARN","PCS")=$G(^ZZLEXX("ZZLEXXE","PCS","CHG","WARN","PCS"))+1
 . . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","WARN")=$G(^ZZLEXX("ZZLEXXE","PCS","CHG","WARN"))+1
 . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","LN")=$G(^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","LN"))+1
 . ;     4 Explanation
 . S RVAL=$G(^ZZLEXX("ZZLEXXE","PCS","PCS",SID,4)) I $L(RVAL) D
 . . N UVAL,RIEN,REFF,RHIS,FND,OVAL
 . . S REFF=$O(^LEX(757.033,CIEN,4,"B",(VERDT+.001)),-1)
 . . S RHIS=$O(^LEX(757.033,CIEN,4,"B",+REFF," "),-1)
 . . S OVAL=$G(^LEX(757.033,CIEN,4,+RHIS,1))
 . . I $L(OVAL),OVAL'=RVAL D
 . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","ER",SID)=VERDT
 . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","ER",SID,0)=RVAL
 . . . I $L(RVAL)>MAXLEN D
 . . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","ER",SID,0,"W")="WARNING:  Exceeds "_MAXLEN_" characters ("_$L(RVAL)_")"
 . . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","WARN","PCS",SID,4,0)=RVAL
 . . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","WARN","PCS",SID,4,1)="WARNING:  Explanation exceeds "_MAXLEN_" characters ("_$L(RVAL)_")"
 . . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","WARN","PCS")=$G(^ZZLEXX("ZZLEXXE","PCS","CHG","WARN","PCS"))+1
 . . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","WARN")=$G(^ZZLEXX("ZZLEXXE","PCS","CHG","WARN"))+1
 . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","ER",SID,1)=OVAL
 . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","ER")=$G(^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","ER"))+1
 . . I '$L(OVAL),OVAL'=RVAL D
 . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","EN",SID)=VERDT
 . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","EN",SID,0)=RVAL
 . . . I $L(RVAL)>MAXLEN D
 . . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","EN",SID,0,"W")="WARNING:  Exceeds "_MAXLEN_" characters ("_$L(RVAL)_")"
 . . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","WARN","PCS",SID,4,0)=RVAL
 . . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","WARN","PCS",SID,4,1)="WARNING:  Explanation exceeds "_MAXLEN_" characters ("_$L(RVAL)_")"
 . . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","WARN","PCS")=$G(^ZZLEXX("ZZLEXXE","PCS","CHG","WARN","PCS"))+1
 . . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","WARN")=$G(^ZZLEXX("ZZLEXXE","PCS","CHG","WARN"))+1
 . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","EN")=$G(^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","EN"))+1
 . ;     5 Includes
 . I $D(^ZZLEXX("ZZLEXXE","PCS","PCS",SID,5)) D
 . . N EFF,HIS,I,CT S EFF=$O(^LEX(757.033,CIEN,5,"B",9999999),-1)
 . . S HIS=$O(^LEX(757.033,CIEN,5,"B",+EFF," "),-1)
 . . I '$D(^LEX(757.033,CIEN,5)) D  Q
 . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","IN")=$G(^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","IN"))+1
 . . . N I S I=0 F  S I=$O(^ZZLEXX("ZZLEXXE","PCS","PCS",SID,5,I)) Q:+I'>0  D
 . . . . N ND S ND=$G(^ZZLEXX("ZZLEXXE","PCS","PCS",SID,5,I)) Q:'$L(ND)
 . . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","IN",SID)=VERDT
 . . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","IN",SID,I)=ND
 . . . . I $L(ND)>MAXLEN D
 . . . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","WARN","PCS",SID,5,I,0)=RVAL
 . . . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","WARN","PCS",SID,5,I,1)="WARNING:  Includes/Synonym exceeds "_MAXLEN_" characters ("_$L(RVAL)_")"
 . . . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","WARN","PCS")=$G(^ZZLEXX("ZZLEXXE","PCS","CHG","WARN","PCS"))+1
 . . . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","WARN")=$G(^ZZLEXX("ZZLEXXE","PCS","CHG","WARN"))+1
 . . N TF,OF,NF,CT,NN,NC,OK,ND
 . . S (CT,I)=0 F  S I=$O(^LEX(757.033,CIEN,5,+HIS,1,I)) Q:+I'>0  D
 . . . N ND S ND=$G(^LEX(757.033,CIEN,5,+HIS,1,+I,0)) S:$L(ND) OF($$UP^XLFSTR(ND))=""
 . . K TF M TF=^ZZLEXX("ZZLEXXE","PCS","PCS",SID,5)
 . . K NF S CT=0,NN="TF",NC="TF(" F  S NN=$Q(@NN) Q:'$L(NN)!(NN'[NC)  D
 . . . N ND S ND=$G(@NN) Q:'$L(ND)  S NF($$UP^XLFSTR(ND))=""
 . . S CT=0,OK=1,ND="" F  S ND=$O(OF(ND)) Q:'$L(ND)  S:'$D(NF(ND)) OK=0,CT=CT+1
 . . S ND="" F  S ND=$O(NF(ND)) Q:'$L(ND)  S:'$D(OF(ND)) OK=0,CT=CT+1
 . . I +OK'>0 D
 . . . K ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","IR",SID,0)
 . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","IR")=$G(^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","IR"))+1
 . . . S I=0 F  S I=$O(^ZZLEXX("ZZLEXXE","PCS","PCS",SID,5,I)) Q:+I'>0  D
 . . . . N ND S ND=$G(^ZZLEXX("ZZLEXXE","PCS","PCS",SID,5,I)) Q:'$L(ND)
 . . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","IR",SID)=VERDT
 . . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","IR",SID,0,I)=ND
 . . . K ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","IR",SID,1)
 . . . S (CT,I)=0 F  S I=$O(^LEX(757.033,CIEN,5,+HIS,1,I)) Q:+I'>0  D
 . . . . N ND S ND=$G(^LEX(757.033,CIEN,5,+HIS,1,+I,0))
 . . . . I $L(ND) S CT=CT+1 D
 . . . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","IR",SID)=VERDT
 . . . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","IR",SID,1,CT)=ND
 . . . . I $L(ND)>MAXLEN D
 . . . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","WARN","PCS",SID,5,CT,0)=RVAL
 . . . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","WARN","PCS",SID,5,CT,1)="WARNING:  Includes/Synonym exceeds "_MAXLEN_" characters ("_$L(RVAL)_")"
 . . . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","WARN","PCS")=$G(^ZZLEXX("ZZLEXXE","PCS","CHG","WARN","PCS"))+1
 . . . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","WARN")=$G(^ZZLEXX("ZZLEXXE","PCS","CHG","WARN"))+1
 S ORD="10P" F  S ORD=$O(^LEX(757.033,"B",ORD)) Q:'$L(ORD)!(ORD'["10P")  D
 . N CIEN S CIEN=0 F  S CIEN=$O(^LEX(757.033,"B",ORD,CIEN)) Q:+CIEN'>0  D
 . . N FRG,EFF,HIS,STA,VERDT,CHK
 . . S VERDT=$G(^ZZLEXX("ZZLEXXE","PCS","DT","CHG"))
 . . S FRG=$P($G(^LEX(757.033,CIEN,0)),"^",2) Q:'$L(FRG)
 . . S CHK=FRG_" ",EFF=$O(^LEX(757.033,CIEN,1,"B",9999999),-1)
 . . S HIS=$O(^LEX(757.033,CIEN,1,"B",+EFF," "),-1)
 . . S STA=$P($G(^LEX(757.033,CIEN,1,+HIS,0)),"^",2)
 . . I +STA>0,'$D(^ZZLEXX("ZZLEXXE","PCS","PCS",CHK)) D
 . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","IA",FRG)=VERDT
 . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","IA")=$G(^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","IA"))+1
 . . I +STA'>0,$D(^ZZLEXX("ZZLEXXE","PCS","PCS",CHK)) D
 . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","RA",FRG)=VERDT
 . . . S ^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","RA")=$G(^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","RA"))+1
 I $D(^ZZLEXX("ZZLEXXE","PCS","TAB")),$L($O(^ZZLEXX("ZZLEXXE","PCS","TAB",""))),$D(^ZZLEXX("ZZLEXXE","PCS","DEF")),$L($O(^ZZLEXX("ZZLEXXE","PCS","DEF",""))) D
 . I $G(^ZZLEXX("ZZLEXXE","PCS","DT","DF"))?7N,$G(^ZZLEXX("ZZLEXXE","PCS","DT","TB"))?7N,$G(^ZZLEXX("ZZLEXXE","PCS","DT","PC"))?7N  D
 . . N VER,PDT,PON S VER=$G(^ZZLEXX("ZZLEXXE","PCS","DT","PC")),VER=$$VER(VER) Q:VER'?4N  Q:VER'>2010
 . . S PDT=$G(^ZZLEXX("ZZLEXXE","PCS","DT","DF")) Q:PDT'?7N  S PON=$$NOW^XLFDT
 . . S ^ZZLEXX("ZZLEXXE","PCS","DT","CP")=PDT,^ZZLEXX("ZZLEXXE","PCS","DT","CP","ON")=PON
 . . S:PDT>$G(^ZZLEXX("ZZLEXXE","PCS","CHG","DT")) ^ZZLEXX("ZZLEXXE","PCS","CHG","DT")=PDT S ^ZZLEXX("ZZLEXXE","PCS","CHG","DT","ON")=PON
 . . S:PDT>$G(^ZZLEXX("ZZLEXXE","PCS","DT","CHG")) ^ZZLEXX("ZZLEXXE","PCS","DT","CHG")=PDT S ^ZZLEXX("ZZLEXXE","PCS","DT","CHG","ON")=PON
 I $D(^ZZLEXX("ZZLEXXE","PCS","LOAD","TIM","BEG")) D
 . N BEG,END,ELP,HR S BEG=$G(^ZZLEXX("ZZLEXXE","PCS","LOAD","TIM","BEG")) Q:$P(BEG,".",1)'?7N
 . H 1 S ^ZZLEXX("ZZLEXXE","PCS","LOAD","TIM","ST3")=$$NOW^XLFDT H 2
 . S END=$$NOW^XLFDT,ELP=$$FMDIFF^XLFDT(END,BEG,3)
 . S HR=$$TM($P(ELP,":",1)) S:$L(HR)'=2 HR="0"_HR S:$L(HR)'=2 HR="0"_HR S $P(ELP,":",1)=HR
 . S ^ZZLEXX("ZZLEXXE","PCS","LOAD","TIM","END")=END
 . S ^ZZLEXX("ZZLEXXE","PCS","LOAD","TIM","ELP")=ELP
 W ?33,"Done"
 Q
 ;
 ; Miscellaneous
VER(X) ;     Version
 S X=$P($G(X),".",1) Q:X'?7N ""  N YR,MD S YR=$E(X,1,3)+1700,MD=$E(X,4,5) S:+MD>9 YR=YR+1 S X=YR
 Q X
TM(X,Y) ;   Trim Character Y - Default " "
 S X=$G(X) Q:X="" X  S Y=$G(Y) S:'$L(Y) Y=" "
 F  Q:$E(X,1)'=Y  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=Y  S X=$E(X,1,($L(X)-1))
 Q X
CC ;   Compile Totals
 N SYS,TOT,TY,TT S TOT=0,SYS="PCS",TT=0,TY="" F  S TY=$O(^ZZLEXX("ZZLEXXE","PCS","CHG",SYS,TY)) Q:'$L(TY)  D
 . Q:TY="ON"  Q:TY="DT"  S TT=TT+$G(^ZZLEXX("ZZLEXXE","PCS","CHG",SYS,TY))
 S:+TT>0 ^ZZLEXX("ZZLEXXE","PCS","CHG",SYS)=TT,TOT=TOT+TT
 S:TOT>0 ^ZZLEXX("ZZLEXXE","PCS","CHG")=TOT
 Q
TN(X) ; Type Name
 N TY S TY=$G(X) Q:TY="SN"!(TY="SR") "Name/Title"  Q:TY="LN"!(TY="LR") "Description/Definition"
 Q:TY="EN"!(TY="ER") "Explanations"  Q:TY="IN"!(TY="IR") "Inclusions/Synonyms"
 Q ""
NN(X) ; Node Number
 N TY S TY=$G(X)  Q:TY="SN"!(TY="SR") 2  Q:TY="LN"!(TY="LR") 3  Q:TY="EN"!(TY="ER") 4  Q:TY="IN"!(TY="IR") 5
 Q ""
