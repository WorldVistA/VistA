ZZLEXXMF ;SLC/KER - Import - Misc - Update Build ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^XTMP(              SACC 2.3.2.5.2
 ;               
 ; External References
 ;    ^DIR                ICR  10026
 ;    $$DT^XLFDT          ICR  10103
 ;    $$FMADD^XLFDT       ICR  10103
 ;    $$FMTE^XLFDT        ICR  10103
 ;               
 Q
UPD ; Update
 N BLD,CHG,CICD,CICP,CLEX,CONT,CPAT,CTL,CUR,DCHG,DIR,DIRB,DIRO,DIROUT,DIRUT,DPAT,DTOUT,DUOUT,EXIT,FD,FI,FY,ICD,ICP,IEN
 N IIEN,LCHG,LEX,LPAT,MAX,MIN,NRD,NRV,ORD,ORV,PCHG,PPAT,QED,QEDE,QFY,QT,QTR,RTN,RV,TD,TM,TQ,TTL,TY,UOK,VER,VRRV,X,Y
 S CHG=0,UOK=$$UOK G:UOK'>0 UPDQ S (DCHG,LCHG,PCHG)=1
 S CLEX=$$CLEX,LCHG=1,LPAT=$$LPAT,LEFF=$P(CLEX,"^",2)
 G:'$L(LPAT)!(LPAT["^") UPDQ
 S:+LPAT=+CLEX LPAT=CLEX,LCHG=0
 S CICD=$$CICD,DCHG=1,DPAT=$$DPAT,DEFF=$P(CICD,"^",2)
 G:'$L(DPAT)!(DPAT["^") UPDQ
 S:+DPAT=+CICD DPAT=CICD,DCHG=0
 S CICP=$$CICP,PCHG=1,PPAT=$$PPAT,PEFF=$P(CICP,"^",2)
 G:'$L(PPAT)!(PPAT["^") UPDQ
 S:+PPAT=+CICP PPAT=CICP,PCHG=0
 I LCHG>0!(DCHG>0)!(PCHG>0) S QTR=$$QTR,FY=$$FY(+($G(QTR)))
 S QED="" I "^1^2^3^4^"[("^"_$G(QTR)_"^"),FY?4N D
 . S QFY=FY S:$G(QTR)=1 QFY=QFY-1
 . S:QTR=1 QED=(QFY-1700)_"1001" S:QTR=2 QED=(QFY-1700)_"0101"
 . S:QTR=3 QED=(QFY-1700)_"0401" S:QTR=4 QED=(QFY-1700)_"0701"
 . S:+($G(LPAT))'=+($G(CLEX)) LPAT=+($G(LPAT))_"^"_QED
 . S:+($G(DPAT))'=+($G(CICD)) DPAT=+($G(DPAT))_"^"_QED
 . S:+($G(PPAT))'=+($G(CICP)) PPAT=+($G(PPAT))_"^"_QED
 S TTL="" S:$G(FY)?4N&($G(QTR)?1N) TTL="FY"_FY_" "_QTR_$S($G(QTR)=1:"st",$G(QTR)=2:"nd",$G(QTR)=3:"rd",$G(QTR)=4:"th",1:"")_" Quarter"
 S QEDE="" S:(QED?7N) QEDE=$$FMTE^XLFDT(QED,"5Z")
 S VER=$$VER W:$L($P(VER,"^",2)) !!,"    ",$P(VER,"^",2)
 W:$L($P(VER,"^",2))&($P(VER,"^",2)'["No C")&($L(TTL)) " - ",TTL
UPDQ ; Update Quit
 S CONT=$$CONT W:$L($G(IOF)) @IOF
 Q
 ;
 ; 
UOK(X) ; Update Revision
 W:$L($G(IOF)) @IOF N CHG,DIR,DTOUT,DUOUT,DIRUT,DIROUT,DIRB,DIRO,Y,TD,FD
 S CHG=0 D SHOW S TD=$$DT^XLFDT,FD=$$FMADD^XLFDT(TD,120)
 S DIRB="" I +($G(DUZ))>0 S DIRB=$G(^XTMP(("UOK^ZZLEXXMF "_+($G(DUZ))),"UOK"))
 S DIR(0)="YAO" S:$L($G(DIRB)) DIR("B")=DIRB S DIR("PRE")="S:X[""?"" X=""??"""
 S (DIR("?"),DIR("??"))="^D UOKH^ZZLEXXMF"
 S DIR("A")=" Update the Revision Number and Effective Date?  (Y/N)  "
 W ! D ^DIR S:$D(DTOUT)!($D(DUOUT))!($D(DIRUT)) X="^" S:$D(DIROUT) X="^^"
 I X["^",+($G(DUZ)) K ^XTMP(("UOK^ZZLEXXMF "_+($G(DUZ)))) Q X
 S DIRO=$S(+Y>0:"YES",+Y'>0&($L(Y)):"NO",1:"") I +($G(DUZ)),$L(DIRO) D
 . S ^XTMP(("UOK^ZZLEXXMF "_+($G(DUZ))),0)=(FD_"^"_TD_"^Update Revision")
 . S ^XTMP(("UOK^ZZLEXXMF "_+($G(DUZ))),"UOK")=DIRO
 S X=+Y
 Q X
UOKH ;   Update Revision Help
 W !,"     Enter 'Yes' to update the revision and effective date"
 W !,"     on the Data Dictionary VRRV node, and 'No' to leave the"
 W !,"     Data Dictionary VRRV node as is."
 Q
VER(X) ; Verify Revision
 W:$L($G(IOF)) @IOF N CHG,DIR,DTOUT,DUOUT,DIRUT,DIROUT,DIRB,DIRO,Y S CHG=0 D CHANGE
 I $G(CLEX)=$G(LPAT),$G(CICD)=$G(DPAT),$G(CICP)=$G(PPAT) S X="0^No Changes Made" Q X
 S DIR(0)="YAO",DIR("PRE")="S:X[""?"" X=""??""",(DIR("?"),DIR("??"))="^D UOKH^ZZLEXXMF"
 S DIR("A")=" Update the Revision Number and Effective Date?  (Y/N)  "
 W ! D ^DIR S:$D(DTOUT)!($D(DUOUT))!($D(DIRUT)) X="^" S:$D(DIROUT) X="^^" Q:X["^" X
 S X=+($G(Y)) I X>0 D
 . N FI I $P($G(LPAT),"^",1)?1N.N,$P($G(LPAT),"^",2)?7N F FI=757,757.001,757.01,757.02,757.1 S @("^DD("_+FI_",0,""VRRV"")")=LPAT
 . I $P($G(DPAT),"^",1)?1N.N,$P($G(DPAT),"^",2)?7N S @("^DD("_80_",0,""VRRV"")")=DPAT
 . I $P($G(PPAT),"^",1)?1N.N,$P($G(PPAT),"^",2)?7N S @("^DD("_80.1_",0,""VRRV"")")=PPAT
 . I CLEX=LPAT,CICD=DPAT,CICP=PPAT S X=+X_"^No Changed Nade"
 . I CLEX'=LPAT!(CICD'=DPAT)!(CICP'=PPAT)!(+($G(CHG))>0) D
 . . S X=+X_"^Revision Number/Effective Dates Updated"
 S:+X'>0 X=+X_"^"_"No Changes Made"
 Q X
VERH ;   Verify Revision Help
 W !,"     Enter 'Yes' to update the revision and effective date"
 W !,"     on the Data Dictionary VRRV node, and 'No' to leave the"
 W !,"     Data Dictionary VRRV node as is."
 Q
 ;
 ; Effective Date
QTR(X) ;   Quarter
 N DIR,DTOUT,DUOUT,DIRUT,DIROUT,TD,TQ,TY,TM,Y S TD=$$DT^XLFDT,TY=$E(TD,1,3)+1700,TM=$E(TD,4,5),TQ=""
 S:"^10^11^12^"[("^"_TM_"^") TQ=2 S:"^01^02^03^"[("^"_TM_"^") TQ=3 S:"^04^05^06^"[("^"_TM_"^") TQ=4
 S:"^07^08^09^"[("^"_TM_"^") TQ=1 S:TQ>0&(TQ<5) DIR("B")=TQ
 S DIR(0)="NAO^1:4:0",DIR("A")=" Enter the quarter:  (1/2/3/4)  "
 S (DIR("?"),DIR("??"))="^D QTRH^ZZLEXXMF"
 S DIR("PRE")="S:X[""?"" X=""??"""
 W ! D ^DIR Q:$D(DIROUT) "^^" Q:$D(DTOUT)!($D(DUOUT))!($D(DIRUT)) "^"  Q:'$L(X) ""
 S X="" S:+Y>0&(+Y<5) X=+Y
 Q X
QTRH ;     Quarter Help
 W !,?4,"The response must be a number, 1-4, that corresponds to"
 W !,?4,"a fiscal year quarter:",!
 W !,?4,"   1     1st quarter     Oct 1st"
 W !,?4,"   2     2nd quarter     Jan 1st"
 W !,?4,"   3     3rd quarter     Apr 1st"
 W !,?4,"   4     4th quarter     Jul 1st"
 Q
FY(X) ;   Fiscal Year
 N DIR,DTOUT,DUOUT,DIRUT,DIROUT,QT,TD,TQ,TY,FY,TM,Y S TD=$$DT^XLFDT,TY=$E(TD,1,3)+1700,TM=$E(TD,4,5),FY=TY
 S QT=$G(X) S:"^10^11^12^"[("^"_TM_"^")!(QT=1) FY=FY+1 S:FY?4N DIR("B")=FY
 S DIR(0)="NAO^"_(TY-1)_":"_(TY+1)_":0",DIR("A")=" Enter the fiscal year:  "
 S (DIR("?"),DIR("??"))="^D FYH^ZZLEXXMF"
 S DIR("PRE")="S X=$$FYI^ZZLEXXMF(X)"
 W ! D ^DIR Q:$D(DIROUT) "^^" Q:$D(DTOUT)!($D(DUOUT))!($D(DIRUT)) "^"  Q:'$L(X) ""
 S X="" S:+Y?4N X=+Y
 Q X
FYI(X) ;     Fiscal Year Input Transform
 Q:X["?" "??"  Q:$L(X)&(X'?4N)&(X'["^") "??"  Q:X["^^" "^^"  Q:X["^" "^"
 Q X
FYH ;     Fiscal Year Help
 W !,?4,"The response must be a 4 digit number that corresponds to"
 W !,?4,"a fiscal year, not to exceed 1 year in the past and one year"
 W !,?4,"in the future."
 I $G(FY)?4N W !!,?4,"   ",(FY-1)," or ",FY," or ",(FY+1)
 Q
 ; 
 ; Patches
LPAT(X) ;   Lexicon Patch
 N BLD,CPAT,CUR,DIR,DIROUT,DIRUT,DTOUT,DUOUT,DIRB,DPAT,MAX,MIN,VRRV,Y
 S DIRB=$$RET("LPAT") S CUR="",VRRV=$$CLEX,CPAT=$P(VRRV,"^",1) S:CPAT>0 CUR=CPAT S MIN=+CUR-1,MAX=+CUR+3 S:MIN'>0 MIN=1 S:MAX'>0 MAX=500
 S:+($G(CUR))>0 DIR("B")=+($G(CUR)) S:+($G(X))>0 DIR("B")=+($G(X)) S:+($G(DIRB))>0 DIR("B")=+($G(DIRB))
 S DIR(0)="NAO^"_MIN_":"_MAX_":0",DIR("A")=" Enter the Lexicon Patch Number:  ",(DIR("?"),DIR("??"))="^D LPATH^ZZLEXXMF"
 S DIR("PRE")="S:X[""?"" X=""??""" W ! D ^DIR Q:'$L(X) ""  Q:$D(DIROUT) "^^" Q:$D(DTOUT)!($D(DUOUT))!($D(DIRUT)) "^"
 S X="" S:+Y>(MIN-1)&(+Y<(MAX+1)) X=+Y I +Y>0 D SAV("LPAT",+Y)
 Q X
LPATH ;     Lexicon Patch Help
 W !,?4,"The response must be a number" W:+($G(MIN))>0&(+($G(MAX))>0) ", "_+($G(MIN))_"-",+($G(MAX)),"," W " that corresponds to"
 W !,?4,"a patch revision number:",!
 W !,?4,"   ",MIN,?15," LEX*2.0*",MIN
 W !,?4,"   ",CUR,?15," LEX*2.0*",CUR,?32,"Current Patch"
 W !,?4,"   nnn",?15," LEX*2.0*nnn"
 Q
DPAT(X) ;   ICD Diagnosis Patch
 N BLD,CPAT,CUR,DIR,DIROUT,DIRB,DIRUT,DTOUT,DUOUT,DPAT,MAX,MIN,VRRV,Y
 S DIRB=$$RET("DPAT") S CUR="",VRRV=$$CICD,CPAT=$P(VRRV,"^",1) S:CPAT>0 CUR=CPAT S MIN=CUR-1,MAX=CUR+3 S:MIN'>0 MIN=1 S:MAX'>0 MAX=500
 S:+($G(CUR))>0 DIR("B")=+($G(CUR)) S:+($G(X))>0 DIR("B")=+($G(X)) S:+($G(DIRB))>0 DIR("B")=+($G(DIRB))
 S DIR(0)="NAO^"_MIN_":"_MAX_":0",DIR("A")=" Enter the ICD Diagnosis Patch Number:  " S (DIR("?"),DIR("??"))="^D DPATH^ZZLEXXMF"
 S DIR("PRE")="S:X[""?"" X=""??""" W ! D ^DIR Q:'$L(X) ""  Q:$D(DIROUT) "^^" Q:$D(DTOUT)!($D(DUOUT))!($D(DIRUT)) "^"
 S X="" S:+Y>(MIN-1)&(+Y<(MAX+1)) X=+Y I +Y>0 D SAV("DPAT",+Y)
 Q X
DPATH ;     ICD Diagnosis Patch Help
 W !,?4,"The response must be a number" W:+($G(MIN))>0&(+($G(MAX))>0) ", "_+($G(MIN))_"-",+($G(MAX)),"," W " that corresponds to"
 W !,?4,"a patch revision number:",!
 W !,?4,"   ",MIN,?15," ICD*18.0*",MIN
 W !,?4,"   ",CUR,?15," ICD*18.0*",CUR,?32,"Current Patch"
 W !,?4,"   nnn",?15," ICD*18.0*nnn"
 Q
PPAT(X) ;   ICD Procedure Patch
 N BLD,CPAT,CUR,DIR,DIROUT,DIRB,DIRUT,DTOUT,DUOUT,PPAT,MAX,MIN,VRRV,Y
 S DIRB=$$RET("PPAT") S CUR="",VRRV=$$CICD,CPAT=$P(VRRV,"^",1) S:CPAT>0 CUR=CPAT S MIN=CUR-1,MAX=CUR+3 S:MIN'>0 MIN=1 S:MAX'>0 MAX=500
 S:+($G(CUR))>0 DIR("B")=+($G(CUR)) S:+($G(X))>0 DIR("B")=+($G(X)) S:+($G(DIRB))>0 DIR("B")=+($G(DIRB))
 S DIR(0)="NAO^"_MIN_":"_MAX_":0",DIR("A")=" Enter the ICD Procedure Patch Number:  " S (DIR("?"),DIR("??"))="^D PPATH^ZZLEXXMF"
 S DIR("PRE")="S:X[""?"" X=""??""" W ! D ^DIR Q:'$L(X) ""  Q:$D(DIROUT) "^^" Q:$D(DTOUT)!($D(DUOUT))!($D(DIRUT)) "^"
 S X="" S:+Y>(MIN-1)&(+Y<(MAX+1)) X=+Y D SAV("PPAT",+Y)
 Q X
PPATH ;     ICD Procedure Patch Help
 W !,?4,"The response must be a number" W:+($G(MIN))>0&(+($G(MAX))>0) ", "_+($G(MIN))_"-",+($G(MAX)),"," W " that corresponds to"
 W !,?4,"a patch revision number:",!
 W !,?4,"   ",MIN,?15," ICD*18.0*",MIN
 W !,?4,"   ",CUR,?15," ICD*18.0*",CUR,?32,"Current Patch"
 W !,?4,"   nnn",?15," ICD*18.0*nnn"
 Q
SAV(X,Y) ;   Save Defaults
 N RTN,TAG,REF,NUM,COM,VAL,NAM,ID,NOW,FUT,KEY
 S TAG=$G(X),VAL=$G(Y) Q:'$L(TAG)  Q:'$L(VAL)  S RTN=$P($T(+1)," ",1) Q:'$L(RTN)
 S COM=$E($$TM($TR($P($T(@TAG+0)," ",2,299),";"," ")),1,13) Q:'$L(COM)
 S NUM=+($G(DUZ)) Q:+NUM'>0  S NAM=$$GET1^DIQ(200,(NUM_","),.01) Q:'$L(NAM)
 S KEY=$E(COM,1,13) S:$L(KEY)'>11 KEY=KEY_$J(" ",12-$L(KEY))
 S NOW=$$DT^XLFDT,FUT=$$FMADD^XLFDT(NOW,60),ID=RTN_" "_NUM_" "_KEY
 S ^XTMP(ID,0)=FUT_"^"_NOW_"^"_COM,^XTMP(ID,TAG)=VAL
 Q
RET(X) ;   Retrieve Defaults
 N RTN,TAG,REF,NUM,COM,VAL,NAM,ID,NOW,FUT,KEY
 S TAG=$G(X) Q:'$L(TAG) ""  S RTN=$P($T(+1)," ",1) Q:'$L(RTN) ""
 S COM=$E($$TM($TR($P($T(@TAG+0)," ",2,299),";"," ")),1,13) Q:'$L(COM) ""
 S NUM=+($G(DUZ)) Q:+NUM'>0 ""  S NAM=$$GET1^DIQ(200,(NUM_","),.01) Q:'$L(NAM) ""
 S KEY=$E(COM,1,13) S:$L(KEY)'>11 KEY=KEY_$J(" ",12-$L(KEY))
 S ID=RTN_" "_NUM_" "_KEY S X=$G(^XTMP(ID,TAG))
 Q X
 ;
 ; Miscellaneous
CICD(X) ;   Current ICD Diagnosis Version
 N RV S X="",RV=$G(@("^DD("_+80_",0,""VRRV"")")) S:$P(RV,"^",1)?1N.N&($P(RV,"^",2)?7N) X=RV
 Q X
CICP(X) ;   Current ICD Procedure Version
 N RV S X="",RV=$G(@("^DD("_+80.1_",0,""VRRV"")")) S:$P(RV,"^",1)?1N.N&($P(RV,"^",2)?7N) X=RV
 Q X
CLEX(X) ;   Current Lexicon Versions
 N FI,RV,VRRV S VRRV="" F FI=757,757.001,757.01,757.02,757.1 D
 . S RV=$G(@("^DD("_+FI_",0,""VRRV"")")) S:$P(RV,"^",2)>$P(VRRV,"^",2) VRRV=RV
 S X=VRRV
 Q X
ILEX(X) ;   Install Lexicon Patch
 N CTL,ORD,IEN,IIEN S IEN="",(CTL,ORD)="LEX*2.0*"
 F  S ORD=$O(@("^XPD(9.7,""B"","""_ORD_""")")) Q:'$L(ORD)!(ORD'[CTL)  D
 . S IIEN=0 F  S IIEN=$O(@("^XPD(9.7,""B"","""_ORD_""","_+IIEN_")")) Q:+IIEN'>0  S:IIEN>IEN IEN=IIEN
 S X=$P($P($G(@("^XPD(9.7,"_+IEN_",0)")),"^",1),"*",3)_"^"_$P($G(@("^XPD(9.7,"_+IEN_",0)")),"^",1)
 Q X
IICD(X) ;   Install ICD Patch
 N CTL,ORD,IEN,IIEN S IEN="",(CTL,ORD)="ICD*18.0*"
 F  S ORD=$O(@("^XPD(9.7,""B"","""_ORD_""")")) Q:'$L(ORD)!(ORD'[CTL)  D
 . S IIEN=0 F  S IIEN=$O(@("^XPD(9.7,""B"","""_ORD_""","_+IIEN_")")) Q:+IIEN'>0  S:IIEN>IEN IEN=IIEN
 S X=$P($P($G(@("^XPD(9.7,"_+IEN_",0)")),"^",1),"*",3)_"^"_$P($G(@("^XPD(9.7,"_+IEN_",0)")),"^",1)
 Q X
CONT(X) ;   Ask to Continue
 Q:+($G(EXIT))>0 "^"  Q:$G(CONT)["^" "^"  N DIR,DIROUT,DIRUT,DUOUT,DTOUT,Y
 S DIR(0)="FAO^1:30",DIR("A")="    Press <Enter> to continue or '^' to exit "
 S DIR("PRE")="S:X[""^^"" X=""^^"" S:X'[""^^""&(X[""^"") X=""^"" S:X[""?"" X=""??"" S:X'[""^""&(X'[""?"") X="""""
 S (DIR("?"),DIR("??"))="^D CONTH^ZZLEXXMF" W ! D ^DIR S:$D(DIROUT)!($D(DUOUT)) EXIT=1 Q:$D(DIROUT) "^^"  Q:$D(DUOUT) "^"  Q:X["^" "^" Q ""
 Q ""
CONTH ;      Ask to Continue Help
 W !,"        Press <Enter> to continue or '^' to exit"
 Q
SHOW ;   Show VRRV
 N ICD,ICP,LEX S ICD=$$CICD,ICP=$$CICP,LEX=$$CLEX W !," File/Number",?26,"Revision",?37,"Effective"
 W !," ----------------------   --------   ----------"
 W !," Lexicon          #757*",?28,$J($P(LEX,"^",1),4),?37,$$FMTE^XLFDT($P(LEX,"^",2),"5Z")
 W !," ICD Diagnosis    #80  ",?28,$J($P(ICD,"^",1),4),?37,$$FMTE^XLFDT($P(ICD,"^",2),"5Z")
 W !," ICD Procedures   #80.1",?28,$J($P(ICP,"^",1),4),?37,$$FMTE^XLFDT($P(ICP,"^",2),"5Z")
 Q
CHANGE ;   Show VRRV Changes
 ; ICD Diagnosis    #80        92    10/01/2017     No Change
 ; ICD Procedures   #80.1      91    04/01/2017      92    
 ; ICD Procedures   #80.1     113    10/01/2017     No Change
 N NRV,NRD,ORV,ORD,ICD,ICP,LEX S ICD=$$CICD,ICP=$$CICP,LEX=$$CLEX S CHG=+($G(CHG))
 W !," Filename and Number",?28,"Old Revision/Date",?50,"New Revision/Date"
 W !," ----------------------     -----------------     -----------------"
 S ORV=$P($G(LEX),"^",1),ORD=$$FMTE^XLFDT($P($G(LEX),"^",2),"5Z")
 S NRV=$P($G(LPAT),"^",1),NRD=$$FMTE^XLFDT($P($G(LPAT),"^",2),"5Z")
 S:$G(LEX)=$G(LPAT) NRV="No Change",NRD=""
 S:$G(LEX)'=$G(LPAT)&($L($G(LPAT))) CHG=+($G(CHG))+1
 S:'$L($G(LPAT)) NRV="No Change",NRD=""
 W !," Lexicon          #757*",?28,$J($P(ORV,"^",1),3),?35,ORD,?50,$J($P(NRV,"^",1),3),?57,NRD
 S ORV=$P($G(ICD),"^",1),ORD=$$FMTE^XLFDT($P($G(ICD),"^",2),"5Z")
 S NRV=$P($G(DPAT),"^",1),NRD=$$FMTE^XLFDT($P($G(DPAT),"^",2),"5Z")
 S:$G(ICD)=$G(DPAT) NRV="No Change",NRD=""
 S:$G(ICD)'=$G(DPAT)&($L($G(DPAT))) CHG=+($G(CHG))+1
 S:'$L($G(DPAT)) NRV="No Change",NRD=""
 W !," ICD Diagnosis    #80  ",?28,$J($P(ORV,"^",1),3),?35,ORD,?50,$J($P(NRV,"^",1),3),?57,NRD
 S ORV=$P($G(ICP),"^",1),ORD=$$FMTE^XLFDT($P($G(ICP),"^",2),"5Z")
 S NRV=$P($G(PPAT),"^",1),NRD=$$FMTE^XLFDT($P($G(PPAT),"^",2),"5Z")
 S:$G(ICP)=$G(PPAT) NRV="No Change",NRD=""
 S:$G(ICP)'=$G(PPAT)&($L($G(PPAT))) CHG=+($G(CHG))+1
 S:'$L($G(PPAT)) NRV="No Change",NRD=""
 W !," ICD Procedures   #80.1",?28,$J($P(ORV,"^",1),3),?35,ORD,?50,$J($P(NRV,"^",1),3),?57,NRD
 Q
TM(X,Y) ;   Trim Character Y - Default " " Space
 S X=$G(X) Q:X="" X  S Y=$G(Y) S:'$L(Y) Y=" "
 F  Q:$E(X,1)'=Y  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=Y  S X=$E(X,1,($L(X)-1))
 Q X
