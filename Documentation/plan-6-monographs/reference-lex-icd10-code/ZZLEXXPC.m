ZZLEXXPC ;SLC/KER - Import - Changes - Get ICD-10-PCS ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^ICD0(              ICR   4486
 ;    ^ZZLEXX("ZZLEXXP"   SACC 2.3.2.5.1
 ;               
 ; External References
 ;    $$DT^XLFDT          ICR  10103
 ;    $$FMTE^XLFDT        ICR  10103
 ;    $$UP^XLFSTR         ICR  10104
 ;               
 ; Local Variables NEWed or KILLed Elsewhere
 ;     LOC,REMOTE
 ;               
 Q
OP ; Main Entry Point ICD-10-PCS Proc
 Q:'$L($G(LOC))  Q:'$L($G(REMOTE))  K ^ZZLEXX("ZZLEXXP",$J,"10P") S DT=$$DT^XLFDT
 N ACT,ARY,EDT,EFF,EXIT,IEN,IEN2,INA,LLT,LLTE,LST,LSTE,LT,N0,ND,NO,RACT,REFF,RINA,RLT,RLTE,RSO,RST,RSTE,SAB,SO,ST
 S SAB="10P",EXIT=0,IEN=0
 I $D(^ICD0("ABA",31)) D
 . N ORD S ORD="" F  S ORD=$O(^ICD0("ABA",31,ORD)) Q:'$L(ORD)  Q:EXIT  D  Q:EXIT
 . . S IEN=0 F  S IEN=$O(^ICD0("ABA",31,ORD,IEN)) Q:+IEN'>0  D OP2  Q:EXIT
 I '$D(^ICD0("ABA",30)) D
 . S IEN=0 F  S IEN=$O(^ICD0(IEN)) Q:+IEN'>0  D OP2  Q:EXIT
 Q
OP2 ; ICD-10-PCS Proc 
 N ARY,IEN2,EDT,ND,NO,N0,ON,EFF,ST,ACT,RACT,INA,RINA,ST,RST,LT,RLT,REFF,SO,RSO,LST,LSTE,RST,RSTE,LLT,LLTE,RLT,RLTE
 S (ACT,RACT,INA,RINA)=0 Q:+($G(IEN))'>0  Q:$P($G(^ICD0(IEN,1)),"^",1)'=31  S SO=$P($G(^ICD0(IEN,0)),"^",1) Q:'$L(SO)
 S ND="^["""_REMOTE_"""]ICD0("_IEN_",0)"
 S RSO=$P($G(@ND),"^",1) Q:$L(RSO)&(SO'=RSO)
 S EDT=$O(^ICD0(IEN,66,"B"," "),-1)+1
 F  S EDT=$O(^ICD0(IEN,66,"B",EDT),-1) Q:+EDT'>0  D
 . N IEN2 S IEN2=$O(^ICD0(IEN,66,"B",EDT," "),-1)+1
 . F  S IEN2=$O(^ICD0(IEN,66,"B",EDT,IEN2),-1) Q:+IEN2'>0  D
 . . N EFF,ST S ND=$G(^ICD0(IEN,66,IEN2,0)),ST=$P(ND,"^",2),EFF=$P(ND,"^",1) Q:+EFF'>0
 . . S:ST>0&(ACT'>0) ACT=EFF S:ST'>0&(INA'>0) INA=EFF
 S ND="^["""_REMOTE_"""]ICD0("_IEN_",66,""B"","" "")"
 S EDT=$O(@ND,-1)+1,ON="^["""_REMOTE_"""]ICD0("_IEN_",66,""B"",EDT)"
 F  S EDT=$O(@ON,-1) Q:+EDT'>0  D
 . N IEN2,ND,ON
 . S ND="^["""_REMOTE_"""]ICD0("_IEN_",66,""B"","_EDT_","" "")",IEN2=$O(@ND,-1)+1
 . S ON="^["""_REMOTE_"""]ICD0("_IEN_",66,""B"","_EDT_",IEN2)"
 . F  S IEN2=$O(@ON,-1) Q:+IEN2'>0  D
 . . N EFF,ST,ND,NO,N0,N1 S ND="^["""_REMOTE_"""]ICD0("_IEN_",66,"_IEN2_",0)",N0=$G(@ND),ST=$P(N0,"^",2),EFF=$P(N0,"^",1) Q:+EFF'>0
 . . S:ST>0&(RACT'>0) RACT=EFF S:ST'>0&(RINA'>0) RINA=EFF
 S (LSTE,LST)="" I $O(^ICD0(IEN,67,"B"," "),-1)>0 D
 . S LST=$O(^ICD0(IEN,67,"B"," "),-1),LST=$O(^ICD0(IEN,67,"B",LST," "),-1),LSTE=$P($G(^ICD0(IEN,67,+LST,0)),"^",1)
 . S LST=$P($G(^ICD0(IEN,67,+LST,0)),"^",2)
 S (RSTE,RST)="",ND="^["""_REMOTE_"""]ICD0("_IEN_",67,""B"","" "")" I $O(@ND,-1)>0 D
 . S RST=$O(@ND,-1) S ND="^["""_REMOTE_"""]ICD0("_IEN_",67,""B"","_+RST_","" "")"
 . S RST=$O(@ND,-1) S ND="^["""_REMOTE_"""]ICD0("_IEN_",67,"_+RST_",0)" S RSTE=$P($G(@ND),"^",1),RST=$P($G(@ND),"^",2)
 S (LLTE,LLT)="" I $O(^ICD0(IEN,68,"B"," "),-1)>0 D
 . S LLT=$O(^ICD0(IEN,68,"B"," "),-1),LLT=$O(^ICD0(IEN,68,"B",LLT," "),-1),LLTE=$P($G(^ICD0(IEN,68,+LLT,0)),"^",1),LLT=$G(^ICD0(IEN,68,+LLT,1))
 S (RLTE,RLT)="",ND="^["""_REMOTE_"""]ICD0("_IEN_",68,""B"","" "")" I $O(@ND,-1)>0 D
 . S RLT=$O(@ND,-1) S ND="^["""_REMOTE_"""]ICD0("_IEN_",68,""B"","_+RLT_","" "")"
 . S RLT=$O(@ND,-1) S ND="^["""_REMOTE_"""]ICD0("_IEN_",68,"_+RLT_",0)" S RLTE=$P($G(@ND),"^",1)
 . S ND="^["""_REMOTE_"""]ICD0("_IEN_",68,"_+RLT_",1)" S RLT=$G(@ND)
 ;               
 ;     Re-Used
 ;       If Local Active greater than 0
 ;       If Local Inactivative>0 or Remote Inactivative>0
 ;       If Local Active greater than Local Inactive>0
 ;       If Local Active greater than Remote Activative>0
 ;       If Local Short Text not equal Remote Short Text or
 ;           if Local Long Text not equal Remote Long Text
 I ACT>0&(INA>0!RINA>0)&(ACT>INA)&(ACT>RACT)&(LST'=RST!(LLT'=RLT)) D SAV(3,ACT,IEN) Q
 ;               
 ;     Reactivation
 ;       If Local Active greater than 0
 ;       If Local Inactivative>0 or Remote Inactivative>0
 ;       If Local Active greater than Local Inactive>0
 ;       If Local Active greater than Remote Activative>0
 ;       If Local Short Text equal Remote Short Text and
 ;           if Local Long Text equal Remote Long Text
 I ACT>0&(INA>0!RINA>0)&(ACT>INA)&(ACT>RACT)&(LST=RST&(LLT=RLT)) D SAV(5,ACT,IEN) Q
 ;               
 ;     Additions
 ;       If Local Active greater than 0
 ;       If Remote Active not greater than 0
 I ACT>0&(RACT'>0) D  Q
 . ;       If Local Inactive greater that Local Active
 . I INA>0,ACT>0,INA>ACT D  Q
 . . D SAV(2,INA,IEN)
 . D SAV(1,ACT,IEN) Q
 ;               
 ;     Inactivations
 ;       If Local Active greater than 0
 ;       If Local Active equal Remote Active
 ;       If Local Inactive greater than 0
 ;       If Local Inactive not equal Remote Inactive
 I ACT>0&(ACT=RACT)&(INA>0)&(INA'=RINA) D SAV(2,INA,IEN) Q
 ;               
 ;     Revised Short Text
 ;       If Local Short Text not equal Remote Short Text
 ;       If Local Effective Date greater than 0
 K ARY S ARY(67,1)=$G(LST) I $$UP^XLFSTR($G(LST))'=$$UP^XLFSTR($G(RST)),+($G(LSTE))>0 D SAV(4,LSTE,IEN,.ARY)
 ;               
 ;     Revised Description
 ;       If Local Description not equal Remote Description
 ;       If Local Effective Date greater than 0
 K ARY S ARY(68,1)=$G(LLT) I $$UP^XLFSTR(LLT)'=$$UP^XLFSTR(RLT),+($G(LLTE))>0 D SAV(4,LLTE,IEN,.ARY) Q
 Q
SAV(T,E,I,Y) ;   Save Procedure
 N SAB,SABF,TYPE,TYPEF,EFFD,EFFF,SO,IEN,FLD,PDTL,PTTL,PTTT,LEN S LEN=9
 S SAB="10P",SABF="ICD-10 Procedure",TYPE=$G(T) Q:'$L(T)  S EFFD=$G(E) Q:EFFD'?7N
 S SO=31,IEN=$G(I) Q:'$L(IEN)  S SO=$P($G(^ICD0(+IEN,0)),"^",1) Q:'$L(SO)
 S LEN=10,EFFF=$TR($$FMTE^XLFDT(EFFD,"1DZ"),"@"," ") Q:'$L(EFFF)
 S TYPEF=$S(TYPE=1:"Additions",TYPE=2:"Inactivations",TYPE=3:"Re-Used",TYPE=4:"Revisions",TYPE=5:"Reactivations",1:"") Q:'$L(TYPEF)
 S PDTL=SABF_" "_TYPEF S PDTL=PDTL_", Effective "_EFFF,PTTT=SABF_" Changes, Effective "_EFFF,PTTL=SABF_" "_TYPEF
 I '$D(^ZZLEXX("ZZLEXXP",$J,"10P",TYPE,EFFD,((SO_" ")_$J("",LEN-($L(SO)+1))))) D
 . N RANGE,FY S RANGE=$P($G(^ZZLEXX("ZZLEXXP",$J,"TEMP","QTR")),"^",4,5),FY=$$FY(EFFD,$P(RANGE,"^",1))
 . ; =4^3060602^3060901^3060701^3060930^FY06 4th Qtr^20064
 . S ^ZZLEXX("ZZLEXXP",$J,"10P",TYPE,EFFD,((SO_" ")_$J("",LEN-($L(SO)+1))))=IEN
 . S ^ZZLEXX("ZZLEXXP",$J,"10P",TYPE,EFFD,0)=(+($G(^ZZLEXX("ZZLEXXP",$J,"10P",TYPE,EFFD,0)))+1)_"^"_PDTL
 . S ^ZZLEXX("ZZLEXXP",$J,"10P",TYPE,0)=(+($G(^ZZLEXX("ZZLEXXP",$J,"10P",TYPE,0)))+1)_"^"_PTTL
 . S ^ZZLEXX("ZZLEXXP",$J,"TEMP","10P",EFFD)=(+($G(^ZZLEXX("ZZLEXXP",$J,"TEMP","10P",EFFD)))+1)_"^"_PTTT
 . S ^ZZLEXX("ZZLEXXP",$J,"TEMP","10P",EFFD,TYPE,0)=(+($G(^ZZLEXX("ZZLEXXP",$J,"TEMP","10P",EFFD,TYPE,0)))+1)_"^"_PDTL
 . S ^ZZLEXX("ZZLEXXP",$J,"TEMP","QTR",EFFD)=FY
 I $O(Y(0))>0,$D(DES) N SS S SS="" F  S SS=$O(Y(SS)) Q:'$L(SS)  N I S I=0 F  S I=$O(Y(SS,I)) Q:+I'>0  D
 . S ^ZZLEXX("ZZLEXXP",$J,"10P",TYPE,EFFD,((SO_" ")_$J("",LEN-($L(SO)+1))),SS,I)=$G(Y(SS,I)) N DES
 Q
FY(X,Y) ;
 N EFF,FY,YR,YQ,MO,QT,CY,TD,CM,CQ,CYQ,CC S EFF=$G(X) Q:EFF'?7N  S YR=$E(EFF,1,3),MO=$E(EFF,4,5),CC=$G(Y)
 S YR=YR+1700 S:+MO>9 YR=YR+1 S FY="FY"_$E(YR,3,4),TD=+($G(DT)) S:TD'?7N TD=$$DT^XLFDT S:CC?7N TD=CC S CY=$E(TD,1,3)+1700,CM=$E(TD,4,5)
 S QT=$S(+MO>0&(+MO<4):"2nd",+MO>3&(+MO<7):"3rd",+MO>6&(+MO<10):"4th",+MO>9&(+MO<13):"1st",1:"") S:$L(QT)&(QT'["Q")&(QT'["q") QT=QT_" Qtr"
 S CQ=$S(+CM>0&(+CM<4):"2nd",+CM>3&(+CM<7):"3rd",+CM>6&(+CM<10):"4th",+CM>9&(+CM<13):"1st",1:"") S:+CM>9 CY=CY+1
 S YQ=YR_(+QT),CYQ=CY_(+CQ) S:+YQ<+CYQ QT=QT_" (Update)" S:+YQ>+CYQ QT=QT_" (Projected)" S X=FY_" "_QT
 Q X
