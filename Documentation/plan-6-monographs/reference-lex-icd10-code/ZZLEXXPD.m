ZZLEXXPD ;SLC/KER - Import - Changes - Get Positions ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^LEX(757.033        SACC 1.3
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
CP ; Main Entry Point ICD-10 Character Positions
 Q:'$L($G(LOC))  Q:'$L($G(REMOTE))  K ^ZZLEXX("ZZLEXXP",$J,"CAT"),^ZZLEXX("ZZLEXXP",$J,"FRG") S DT=$$DT^XLFDT
 N EXIT,ID,IEN,SAB,SO,SYS
 S (EXIT,IEN)=0 F  S IEN=$O(^LEX(757.033,IEN)) Q:+IEN'>0  Q:EXIT  D  Q:EXIT
 . N ID,SYS,SAB S ID=$P($G(^LEX(757.033,+IEN,0)),"^",1) Q:'$L(ID)
 . S SO=$P($G(^LEX(757.033,+IEN,0)),"^",2) Q:'$L(SO)
 . S SYS=$E(ID,1,3)  Q:"^10D^10P^"'[("^"_SYS_"^")
 . S SAB=$S(SYS="10D":"CAT",SYS="10P":"FRG",1:"") Q:'$L(SAB)  D CP2
 Q
CP2 ; Get Character Positions for IEN
 N ACT,ARY,C,EDT,EFF,IEN2,INA,LEP,LEPE,LEYE,LLRVD
 N LLT,LLTE,LST,LSTE,LSY,LSYC,LSYE,LSYI,LT,N0,N1,ND,NO,ON
 N RACT,REFF,REP,REPE,RINA,RLRVD,RLT,RLTE,RSO,RST,RSTE
 N RSY,RSYE,RSYI,ST,SYI,TX
 S (ACT,RACT,INA,RINA,LLRVD,RLRVD)=0 Q:+($G(IEN))'>0  S SO=$P($G(^LEX(757.033,IEN,0)),"^",2) Q:'$L(SO)
 ; Code
 S ND="^["""_REMOTE_"""]LEX(757.033,"_IEN_",0)"
 S RSO=$P($G(@ND),"^",2) Q:$L(RSO)&(SO'=RSO)
 ; Status         1
 ;    ^LEX(757.033,3,1,1,0)=3151001^1
 S EDT=$O(^LEX(757.033,IEN,1,"B"," "),-1)+1
 F  S EDT=$O(^LEX(757.033,IEN,1,"B",EDT),-1) Q:+EDT'>0  D
 . N IEN2 S IEN2=$O(^LEX(757.033,IEN,1,"B",EDT," "),-1)+1
 . F  S IEN2=$O(^LEX(757.033,IEN,1,"B",EDT,IEN2),-1) Q:+IEN2'>0  D
 . . N EFF,ST S ND=$G(^LEX(757.033,IEN,1,IEN2,0)),ST=$P(ND,"^",2),EFF=$P(ND,"^",1) Q:+EFF'>0
 . . S:ST>0&(ACT'>0) ACT=EFF S:ST'>0&(INA'>0) INA=EFF
 S ND="^["""_REMOTE_"""]LEX(757.033,"_IEN_",1,""B"","" "")"
 S EDT=$O(@ND,-1)+1,ON="^["""_REMOTE_"""]LEX(757.033,"_IEN_",1,""B"",EDT)"
 F  S EDT=$O(@ON,-1) Q:+EDT'>0  D
 . N IEN2,ND,ON
 . S ND="^["""_REMOTE_"""]LEX(757.033,"_IEN_",1,""B"","_EDT_","" "")",IEN2=$O(@ND,-1)+1
 . S ON="^["""_REMOTE_"""]LEX(757.033,"_IEN_",1,""B"","_EDT_",IEN2)"
 . F  S IEN2=$O(@ON,-1) Q:+IEN2'>0  D
 . . N EFF,ST,ND,NO,N0,N1 S ND="^["""_REMOTE_"""]LEX(757.033,"_IEN_",1,"_IEN2_",0)"
 . . S N0=$G(@ND),ST=$P(N0,"^",2),EFF=$P(N0,"^",1) Q:+EFF'>0
 . . S:ST>0&(RACT'>0) RACT=EFF S:ST'>0&(RINA'>0) RINA=EFF
 ; Name           2
 ;    ^LEX(757.033,3,2,1,1)=Bypass
 S (LSTE,LST)="" I $O(^LEX(757.033,IEN,2,"B"," "),-1)>0 D
 . S LST=$O(^LEX(757.033,IEN,2,"B"," "),-1),LST=$O(^LEX(757.033,IEN,2,"B",+LST," "),-1)
 . S LSTE=$P($G(^LEX(757.033,IEN,2,+LST,0)),"^",1)
 . S LST=$P($G(^LEX(757.033,IEN,2,+LST,1)),"^",1)
 S (RSTE,RST)="",ND="^["""_REMOTE_"""]LEX(757.033,"_IEN_",2,""B"","" "")" I $O(@ND,-1)>0 D
 . S RST=$O(@ND,-1) S ND="^["""_REMOTE_"""]LEX(757.033,"_IEN_",2,""B"","_+RST_","" "")"
 . S RST=$O(@ND,-1) S ND="^["""_REMOTE_"""]LEX(757.033,"_IEN_",2,"_+RST_",0)" S RSTE=$P($G(@ND),"^",1)
 . S ND="^["""_REMOTE_"""]LEX(757.033,"_IEN_",2,"_+RST_",1)" S RST=$P($G(@ND),"^",1)
 S:LSTE>0&(LSTE>LLRVD) LLRVD=LSTE S:RSTE>0&(RSTE>RLRVD) RLRVD=RSTE
 ; Description    3
 ;    ^LEX(757.033,3,3,1,0)=3151001
 ;    ^LEX(757.033,3,3,1,1)=Altering the route of passage
 S (LLTE,LLT)="" I $O(^LEX(757.033,IEN,3,"B"," "),-1)>0 D
 . S LLT=$O(^LEX(757.033,IEN,3,"B"," "),-1),LLT=$O(^LEX(757.033,IEN,3,"B",LLT," "),-1)
 . S LLTE=$P($G(^LEX(757.033,IEN,3,+LLT,0)),"^",1),LLT=$G(^LEX(757.033,IEN,3,+LLT,1))
 S (RLTE,RLT)="",ND="^["""_REMOTE_"""]LEX(757.033,"_IEN_",3,""B"","" "")" I $O(@ND,-1)>0 D
 . S RLT=$O(@ND,-1) S ND="^["""_REMOTE_"""]LEX(757.033,"_IEN_",3,""B"","_+RLT_","" "")"
 . S RLT=$O(@ND,-1) S ND="^["""_REMOTE_"""]LEX(757.033,"_IEN_",3,"_+RLT_",0)" S RLTE=$P($G(@ND),"^",1)
 . S ND="^["""_REMOTE_"""]LEX(757.033,"_IEN_",3,"_+RLT_",1)" S RLT=$P($G(@ND),"^",1)
 S:LLTE>0&(LLTE>LLRVD) LLRVD=LLTE S:RLTE>0&(RLTE>RLRVD) RLRVD=RLTE
 ; Explanation    4
 ;    ^LEX(757.033,3,4,1,0)=3151001
 ;    ^LEX(757.033,3,4,1,1)=Rerouting contents of a body part
 S (LEPE,LEP)="" I $O(^LEX(757.033,IEN,4,"B"," "),-1)>0 D
 . S LEP=$O(^LEX(757.033,IEN,4,"B"," "),-1),LEP=$O(^LEX(757.033,IEN,4,"B",LEP," "),-1)
 . S LEPE=$P($G(^LEX(757.033,IEN,4,+LEP,0)),"^",1),LEP=$G(^LEX(757.033,IEN,4,+LEP,1))
 S (REPE,REP)="",ND="^["""_REMOTE_"""]LEX(757.033,"_IEN_",4,""B"","" "")" I $O(@ND,-1)>0 D
 . S REP=$O(@ND,-1) S ND="^["""_REMOTE_"""]LEX(757.033,"_IEN_",4,""B"","_+REP_","" "")"
 . S REP=$O(@ND,-1) S ND="^["""_REMOTE_"""]LEX(757.033,"_IEN_",4,"_+REP_",0)" S REPE=$P($G(@ND),"^",1)
 . S ND="^["""_REMOTE_"""]LEX(757.033,"_IEN_",4,"_+REP_",1)" S REP=$P($G(@ND),"^",1)
 S:LEPE>0&(LEPE>LLRVD) LLRVD=LEPE S:REPE>0&(REPE>RLRVD) RLRVD=REPE
 ; Synonyms       5
 ;    ^LEX(757.033,5028018,5,1,0)=3161001
 ;    ^LEX(757.033,5028018,5,1,1,1,0)=Spinal fusion
 K LSY S (LSYE,LSY)="" I $O(^LEX(757.033,IEN,5,"B"," "),-1)>0 D
 . N SYI S SYI=$O(^LEX(757.033,IEN,5,"B"," "),-1),SYI=$O(^LEX(757.033,IEN,5,"B",+SYI," "),-1)
 . S LSYE=$P($G(^LEX(757.033,IEN,5,+SYI,0)),"^",1)
 . N LSYI S LSYI=0 F  S LSYI=$O(^LEX(757.033,+IEN,5,+SYI,1,+LSYI)) Q:+LSYI'>0  D
 . . N TX,C S TX=$G(^LEX(757.033,+IEN,5,+SYI,1,+LSYI,0))
 . . I $L(TX) S C=$O(LSY(" "),-1)+1,LSY(+C)=TX
 K RSY S (RSYE,RSY)="",ND="^["""_REMOTE_"""]LEX(757.033,"_IEN_",5,""B"","" "")" I $O(@ND,-1)>0 D
 . N SYI S SYI=$O(@ND,-1) S ND="^["""_REMOTE_"""]LEX(757.033,"_IEN_",5,""B"","_+SYI_","" "")"
 . S SYI=$O(@ND,-1) S ND="^["""_REMOTE_"""]LEX(757.033,"_IEN_",5,"_+SYI_",0)" S RSYE=$P($G(@ND),"^",1)
 . N RSYI S RSYI=0 F  S RSYI=$O(@(("^["""_REMOTE_"""]LEX(757.033,"_IEN_",5,"_+SYI_",1,"_RSYI_")"))) Q:+RSYI'>0  D
 . . ; ^LEX(757.033,5028018,5,1,1,1,0)
 . . N TX,ND,C S ND="^["""_REMOTE_"""]LEX(757.033,"_IEN_",5,"_+SYI_",1,"_+RSYI_",0)" S TX=$P($G(@ND),"^",1)
 . . I $L(TX) S C=$O(RSY(" "),-1)+1,RSY(+C)=TX
 S LSYC=0,LSYI=0 F  S LSYI=$O(LSY(LSYI)) Q:+LSYI'>0  D  Q:LSYC>0
 . I $$UP^XLFSTR($G(LSY(+LSYI)))'=$$UP^XLFSTR($G(RSY(+LSYI))) S LSYC=1
 I LSYC>0 S:LSYE>0&(LSYE>LLRVD) LLRVD=LSYE S:RSYE>0&(RSYE>RLRVD) RLRVD=RSYE
 D CP3
 Q
CP3 ; Check Character Positions
 ;     
 ;     Re-Used                Node 1   Type 3
 ;       If Local Active greater than 0
 ;       If Local Inactivative>0 or Remote Inactivative>0
 ;       If Local Active greater than Local Inactive>0
 ;       If Local Active greater than Remote Activative>0
 ;       If Local Short Text not equal Remote Short Text or
 ;           if Local Long Text not equal Remote Long Text
 N I,REV I ACT>0&(INA>0!RINA>0)&(ACT>INA)&(ACT>RACT)&(LST'=RST!(LLT'=RLT)) D SAV(SAB,3,ACT,SO,IEN) Q
 ;               
 ;     Reactivation           Node 1   Type 5
 ;       If Local Active greater than 0
 ;       If Local Inactivative>0 or Remote Inactivative>0
 ;       If Local Active greater than Local Inactive>0
 ;       If Local Active greater than Remote Activative>0
 ;       If Local Short Text equal Remote Short Text and
 ;           if Local Long Text equal Remote Long Text
 I ACT>0&(INA>0!RINA>0)&(ACT>INA)&(ACT>RACT)&(LST=RST&(LLT=RLT)) D SAV(SAB,5,ACT,SO,IEN) Q
 ;               
 ;     Additions              All      Type 1
 ;       If Local Active greater than 0
 ;       If Remote Active not greater than 0
 I ACT>0&(RACT'>0) D  Q
 . ;       If Local Inactive greater that Local Active
 . I INA>0,ACT>0,INA>ACT D  Q
 . . D SAV(SAB,2,INA,SO,IEN)
 . D SAV(SAB,1,ACT,SO,IEN) Q
 ;               
 ;     Inactivations          Node 1   Type 2
 ;       If Local Active greater than 0
 ;       If Local Active equal Remote Active
 ;       If Local Inactive greater than 0
 ;       If Local Inactive not equal Remote Inactive
 I ACT>0&(ACT=RACT)&(INA>0)&(INA'=RINA) D SAV(SAB,2,INA,SO,IEN) Q
 ;               
 ;     Revised Name           Node 2   Type 4
 ;       If Local Short Text not equal Remote Short Text
 ;       If Local Effective Date greater than 0
 K ARY S REV=0 S ARY(2,1)=$G(LST) I $$UP^XLFSTR($G(LST))'=$$UP^XLFSTR($G(RST)),+($G(LSTE))>0 D SAV(SAB,4,LSTE,SO,IEN,.ARY) S REV=1
 ;               
 ;     Revised Description    Node 3   Type 4
 ;       If Local Description not equal Remote Description
 ;       If Local Effective Date greater than 0
 K ARY S ARY(3,1)=$G(LLT) I $$UP^XLFSTR(LLT)'=$$UP^XLFSTR(RLT),+($G(LLTE))>0 D:+REV'>0 SAV(SAB,4,LLTE,SO,IEN,.ARY) Q
 ;               
 ;     Revised Explanation    Node 4   Type 4
 ;       If Local Explanation not equal Remote Explanation
 ;       If Local Effective Date greater than 0
 K ARY S ARY(4,1)=$G(LEP) I $$UP^XLFSTR(LEP)'=$$UP^XLFSTR(REP),+($G(LEPE))>0 D:+REV'>0 SAV(SAB,4,LLTE,SO,IEN,.ARY) Q
 ;               
 ;     Revised Synonyms       Node 5   Type 4
 K ARY S I=0 F  S I=$O(LSY(I)) Q:+I'>0  D
 . N C,TX S TX=$G(LSY(I)) Q:'$L(TX)  S C=$O(ARY(5," "),-1)+1 S ARY(5,+C)=TX
 I +($G(LSYC))>0,+($G(LSYE))>0 D:+REV'>0 SAV(SAB,4,LSYE,SO,IEN,.ARY)
 Q
 ;
 ; Miscellaneous
SAV(C,T,E,S,I,Y) ;   Save
 N SAB,SABF,TYPE,TYPEF,EFFD,EFFF,SO,IEN,FLD,PDTL,PTTL,PTTT,LEN S LEN=9
 S SAB=$G(C) Q:'$L(SAB)  S TYPE=$G(T) Q:'$L(T)  S EFFD=$G(E) Q:EFFD'?7N
 S SO=$G(S) Q:'$L(SO)  S IEN=$G(I) Q:'$L(IEN)
 S SABF=$S(SAB="CAT":"ICD-10-CM Category",SAB="FRG":"ICD-10-PCS Fragment",1:"") Q:'$L(SABF)
 S LEN=$S(SAB="CAT":10,SAB="FRG":10,1:9)
 S EFFF=$TR($$FMTE^XLFDT(EFFD,"1DZ"),"@"," ") Q:'$L(EFFF)
 S TYPEF=$S(TYPE=1:"Additions",TYPE=2:"Inactivations",TYPE=3:"Re-Used",TYPE=4:"Revisions",TYPE=5:"Reactivations",1:"") Q:'$L(TYPEF)
 S PDTL=SABF_" "_TYPEF S:SAB["ICP"&(TYPE=3) PDTL=SABF_"s "_TYPEF
 S PDTL=PDTL_", Effective "_EFFF,PTTT=SABF_" Changes, Effective "_EFFF,PTTL=SABF_" "_TYPEF
 I '$D(^ZZLEXX("ZZLEXXP",$J,SAB,TYPE,EFFD,((SO_" ")_$J("",LEN-($L(SO)+1))))) D
 . N RANGE,FY S RANGE=$P($G(^ZZLEXX("ZZLEXXP",$J,"TEMP","QTR")),"^",4,5),FY=$$FY(EFFD,$P(RANGE,"^",1))
 . S ^ZZLEXX("ZZLEXXP",$J,SAB,TYPE,EFFD,((SO_" ")_$J("",LEN-($L(SO)+1))))=IEN
 . S ^ZZLEXX("ZZLEXXP",$J,SAB,TYPE,EFFD,0)=(+($G(^ZZLEXX("ZZLEXXP",$J,SAB,TYPE,EFFD,0)))+1)_"^"_PDTL
 . S ^ZZLEXX("ZZLEXXP",$J,SAB,TYPE,0)=(+($G(^ZZLEXX("ZZLEXXP",$J,SAB,TYPE,0)))+1)_"^"_PTTL
 . S ^ZZLEXX("ZZLEXXP",$J,"TEMP",SAB,EFFD)=(+($G(^ZZLEXX("ZZLEXXP",$J,"TEMP",SAB,EFFD)))+1)_"^"_PTTT
 . S ^ZZLEXX("ZZLEXXP",$J,"TEMP",SAB,EFFD,TYPE,0)=(+($G(^ZZLEXX("ZZLEXXP",$J,"TEMP",SAB,EFFD,TYPE,0)))+1)_"^"_PDTL
 . S ^ZZLEXX("ZZLEXXP",$J,"TEMP","QTR",EFFD)=FY
 I $O(Y(0))>0,$D(DES) N SS S SS="" F  S SS=$O(Y(SS)) Q:'$L(SS)  N I S I=0 F  S I=$O(Y(SS,I)) Q:+I'>0  D
 . S ^ZZLEXX("ZZLEXXP",$J,SAB,TYPE,EFFD,((SO_" ")_$J("",LEN-($L(SO)+1))),SS,I)=$G(Y(SS,I)) N DES
 Q
FY(X,Y) ; Fiscal Year
 N EFF,FY,YR,YQ,MO,QT,CY,TD,CM,CQ,CYQ,CC S EFF=$G(X) Q:EFF'?7N  S YR=$E(EFF,1,3),MO=$E(EFF,4,5),CC=$G(Y)
 S YR=YR+1700 S:+MO>9 YR=YR+1 S FY="FY"_$E(YR,3,4),TD=+($G(DT)) S:TD'?7N TD=$$DT^XLFDT S:CC?7N TD=CC S CY=$E(TD,1,3)+1700,CM=$E(TD,4,5)
 S QT=$S(+MO>0&(+MO<4):"2nd",+MO>3&(+MO<7):"3rd",+MO>6&(+MO<10):"4th",+MO>9&(+MO<13):"1st",1:"") S:$L(QT)&(QT'["Q")&(QT'["q") QT=QT_" Qtr"
 S CQ=$S(+CM>0&(+CM<4):"2nd",+CM>3&(+CM<7):"3rd",+CM>6&(+CM<10):"4th",+CM>9&(+CM<13):"1st",1:"") S:+CM>9 CY=CY+1
 S YQ=YR_(+QT),CYQ=CY_(+CQ) S:+YQ<+CYQ QT=QT_" (Update)" S:+YQ>+CYQ QT=QT_" (Projected)" S X=FY_" "_QT
 Q X
