ZZLEXXVH ;SLC/KER - Import - FileMan Verify (Task) ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^%ZTSCH("TASK"      None
 ;    ^%ZTSK(             None
 ;    ^DIC(               None
 ;    ^ZZLEXX("ZZLEXXV"   SACC 1.3
 ;    ^XTMP(              SACC 2.3.2.5.2
 ;               
 ; External References
 ;    STAT^%ZTLOAD        ICR  10063
 ;    FILE^DID            ICR   2052
 ;    $$GET1^DIQ          ICR   2056
 ;    ^DIR                ICR  10026
 ;    $$DT^XLFDT          ICR  10103
 ;    $$FMADD^XLFDT       ICR  10103
 ;    $$FMDIFF^XLFDT      ICR  10103
 ;    $$FMTE^XLFDT        ICR  10103
 ;    $$HTFM^XLFDT        ICR  10103
 ;    $$NOW^XLFDT         ICR  10103
 ;               
 Q 
FI(X) ;   Get File #
 N DIR,DIC,DIROUT,DIRUT,DTOUT,DUOUT,Y,SBR,PRE,HLP
 S SBR=$$RET("FI") S DIR(0)="PAO^1:EMZ"
 S DIR("S")="I +($$FOK^ZZLEXXVH(Y))>0",PRE=""
 S DIR("A")=" Select Lexicon/ICD/CPT file:  "
 S DIC="^DIC(" K DLAYGO
 D:'$D(QUIET) FIH S HLP="",DIR("PRE")="D FIP^ZZLEXXVH"
 S (DIR("?"),DIR("??"))="^D FIH^ZZLEXXVH" W ! D ^DIR
 Q:$D(DIROUT)!($D(DIRUT))!($D(DTOUT))!($D(DUOUT))!(X["^") "^"
 S X=+Y,NAM=$P($G(^DIC(+X,0)),"^",1)
 I +X>0,$D(^DIC(+X,0)),$$FOK(+X)>0 D SAV("FI",+X)
 N SAV
 Q X
FIH ;   Get File # Help
 N TAB,TYP S TYP=$S($D(HLP):1,1:0)
 I 'TYP,$L($G(IOF)),$G(ONE)'="ALL" W @IOF
 S TAB=" " S:TYP TAB="     " W:TYP !,"   Select from:",!
 W !,TAB,"80      ICD Diagnosis      757.033 Character Positions"
 W !,TAB,"80.1    ICD Procedures     757.04  Excluded Words"
 W !,TAB,"80.3    Maj Diag Category  757.05  Replacement Words"
 W !,TAB,"80.4    Coding Systems     757.06  Unresolved Narr"
 W !,TAB,"                           757.1   Semantic Map"
 W !,TAB,"81      CPT/HCPCS Codes    757.11  Semantic Class"
 W !,TAB,"81.1    CPT Category       757.12  Semantic Type"
 W !,TAB,"81.3    CPT Copyright      757.13  Source Category"
 W !,TAB,"81.4    CPT Modifier       757.14  Source"
 W !,TAB,"                           757.2   Subset Definitions"
 W !,TAB,"757     Major Concept      757.21  Subsets"
 W !,TAB,"757.001 Concept Usage      757.3   Look-up Screens"
 W !,TAB,"757.01  Expressions        757.31  Displays"
 W !,TAB,"757.011 Expression Type    757.32  Mapping Definitions"
 W !,TAB,"757.014 Expression Form    757.33  Mappings"
 W !,TAB,"757.018 Hierarchy          757.4   Shortcuts"
 W !,TAB,"757.02  Codes              757.41  Shortcut Context"
 W !,TAB,"757.03  Coding System      757.5   UCOM Codes" W:TYP !
 Q 
FIP ;   File Pre-Processing
 I $E(X,1)=" ",+($G(SBR))>0 W " ",SBR S X=+($G(SBR)) Q
 I $L($G(X)),$G(X)'["^",+($$FOK($G(X)))'>0 S X="??" Q
 S:X["?" X="??"
 Q
FOK(X) ;   File is OK
 N TY,GL,MS,FI S (FI,X)=$G(X),TY=+($P(FI,".",1)) Q:'$L(FI) 0  Q:'$L(TY) 0  Q:+FI'>0 0
 D FILE^DID(FI,,"GLOBAL NAME","GL","MS") Q:'$L($G(GL("GLOBAL NAME"))) 0  Q:'$D(@("^DIC("_+FI_",0)")) 0
 Q:"^757^81^80^"'[("^"_TY_"^") 0
 Q:TY=80&("^80^80.1^80.3^80.4^"'[("^"_FI_"^")) 0
 Q:TY=81&("^81^81.1^81.2^81.3^"'[("^"_FI_"^")) 0
 Q:TY=757&('$D(@("^LEX("_FI_")"))&('$D(@("^LEXT("_FI_")")))) 0
 Q 1
SAV(X,Y) ;   Save Defaults
 N RTN,TAG,REF,NUM,COM,VAL,NAM,ID,NOW,FUT,KEY S RTN=$P($T(+1)," ",1)
 Q:'$L(RTN)  S TAG=$G(X) Q:'$L(TAG)
 S COM=$E($$TM($TR($P($T(@TAG+0)," ",2,299),";"," ")),1,13) Q:'$L(COM)
 S NUM=+($G(DUZ)) Q:+NUM'>0  S VAL=$G(Y) Q:'$L(VAL)
 S NAM=$$GET1^DIQ(200,(NUM_","),.01) Q:'$L(NAM)
 S KEY=$E(COM,1,13) S:$L(KEY)'>11 KEY=KEY_$J(" ",12-$L(KEY))
 S NOW=$$DT^XLFDT,FUT=$$FMADD^XLFDT(NOW,60),ID=RTN_" "_NUM_" "_KEY
 S ^XTMP(ID,0)=FUT_"^"_NOW_"^"_COM,^XTMP(ID,TAG)=VAL
 Q
RET(X) ;   Retrieve Defaults
 N RTN,TAG,REF,NUM,COM,VAL,NAM,ID,NOW,FUT,KEY S RTN=$P($T(+1)," ",1)
 Q:'$L(RTN) ""  S TAG=$G(X) Q:'$L(TAG) ""
 S COM=$E($$TM($TR($P($T(@TAG+0)," ",2,299),";"," ")),1,13)
 Q:'$L(COM) ""  S NUM=+($G(DUZ)) Q:+NUM'>0 ""
 S NAM=$$GET1^DIQ(200,(NUM_","),.01) Q:'$L(NAM) ""
 S KEY=$E(COM,1,13) S:$L(KEY)'>11 KEY=KEY_$J(" ",12-$L(KEY))
 S ID=RTN_" "_NUM_" "_KEY S X=$G(^XTMP(ID,TAG))
 Q X
TM(X,Y) ;   Trim Y
 S X=$G(X),Y=$G(Y) S:'$L(Y) Y=" "
 F  Q:$E(X,1)'=Y  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=Y  S X=$E(X,1,($L(X)-1))
 Q X
INPROG(X) ;   Task in Progress
 N INP,TAG,RTN,ZTAG,ZRTN,TN
 S INP=$G(X) S:$L(INP,"^")=2 TAG=$P(INP,"^",1),RTN=$P(INP,"^",2)
 S:$L(INP,"^")=1 TAG="",RTN=$P(INP,"^",2) Q:'$L(RTN) 0
 S (RUN,TN)=0 F  S TN=$O(^%ZTSCH("TASK",TN)) Q:+TN=0  D
 . N ND,ZTAG,ZRTN,RTNN S ND=$G(^%ZTSCH("TASK",TN))
 . S ZTAG=$P(ND,U,1) Q:ZTAG'=TAG  S ZRTN=$P(ND,U,2) Q:ZRTN'=RTN
 . S ZTSK=TN D STAT^%ZTLOAD
 . Q:$G(ZTSK(0))'>0  Q:$G(ZTSK(1))<1  Q:$G(ZTSK(1))>2
 . S RUN=RUN+1
 Q:+($G(RUN))>0 1
 Q 0
RUNNING(X) ;   Is there a task running?
 N RUN,NOS K FUL S RUN=0,NOS="" D MON
 Q RUN
MON ;   Monitor Task
 N DSPL,MON,END,EXIT,TERM,REP,CHK,LIM
 S MON=1,EXIT=0,END=0,CHK=0,DSPL=0,LIM=2
 F  D  Q:EXIT
 . S CHK=CHK+1 S:CHK=1!(CHK>LIM) DSPL=1
 . S:CHK'=1&(CHK'>LIM) DSPL=0 S:CHK>LIM CHK=1
 . D LIST I $D(RUN) S EXIT=1 Q
 . Q:EXIT=1  S TERM="" R TERM:2
 . I TERM["^" S END=1,DSPL=1 D LIST S:+($G(EXIT))'>0 EXIT=1
 I $D(TASKLIST("A")) D
 . N BK,CT,TN,RTN S TN=0,RTN="",CT=0
 . S BK="------------------------------------------------------------------------------"
 . F  S TN=$O(TASKLIST("A",TN)) Q:+TN=0  D
 . . N RTN,TIM,ALT S CT=CT+1,RTN=$P($G(TASKLIST("A",TN)),"~",1)
 . . S ALT=$G(^%ZTSK(+TN,.11))
 . . S TIM=$P($G(TASKLIST("A",TN)),"~",2)
 . . I CT=1 D
 . . . W:$L($G(IOF))&('$D(NOS)) @IOF
 . . . W:'$D(NOS) !!,"Task observed "
 . . . W:'$D(NOS) !!,BK,!,"Task Found",?27,"Initial Status"
 . . . W:'$D(NOS) ?52,"Ending Status",!,BK
 . . W:'$D(NOS) !,$J(TN,8),"   ",RTN
 . . W:$D(TASKLIST("S",TN))&('$D(NOS)) ?27,"Task Started"
 . . W:$D(TASKLIST("I",TN))&('$D(NOS)) ?27,"Task In-Progress"
 . . W:'$D(TASKLIST("E",TN))&('$D(NOS)) ?52,"Completed ",TIM
 . . W:$D(TASKLIST("E",TN))&('$D(NOS)) ?52,"Still Running"
 . W:'$D(NOS) !!!
 D:+($G(EXIT))=2 PURGE
 K TASKLIST
 Q
LIST ;   Task List
 W:+($G(DSPL))=1&($L($G(IOF)))&('$D(NOS)) @IOF
 N CNT,TN,RTN,TDES S MON=+($G(MON)),END=+($G(END))
 S:MON&(+($G(DSPL))=1) REP=+($G(REP))+1 S U="^",CNT=0
 S TN=0 F  S TN=$O(^%ZTSCH("TASK",TN)) Q:+TN=0  D
 . N ND,T1,T2,T3,TK,TK2,RTNN,RUNT,RUNE,ALT S ND=$G(^%ZTSCH("TASK",TN)),RUNT=$$RUNT(TN)
 . S RUNE=$P(RUNT,"^",2),RUNT=$P(RUNT,"^",1)
 . S (T1,TK)=$G(^%ZTSK(TN,.03)),(T2,TK2)=$G(^%ZTSK(TN,.11)) S:$L(TK2) TK=TK2
 . S T3=$G(^%ZTSK(TN,.3,"FI")),ALT=$G(^%ZTSK(+TN,.11))
 . S RTN=$P(ND,U,1,2),RTNN=$S(RTN["^":$P(RTN,"^",2),1:RTN)
 . Q:$E(RTNN,1,6)'="ZZLEXX"
 . I $D(RUN) S RUN=+($G(RUN))+1 Q
 . I $D(FUL) D  Q
 . . I RTNN'["ZZLEXXV"&(FUL>0) S FUL=0 Q
 . . I RTNN["ZZLEXXV",+($G(FILE))>0 D
 . . . S:($G(T1)_$G(T2)_$G(T3))[$G(FILE) FUL=-1
 . S TDES=$S(ND'["No Description":$P(ND,U,5),1:"No Description")
 . I TDES?1N.N1",".N,$L(TK) S TDES=TK
 . S CNT=CNT+1
 . I CNT=1,END=0 W:+($G(DSPL))=1&('$D(NOS)) !,"Export Task:  ",!
 . S:$L($G(ALT))&($G(ALT)'=$G(TDES)) TDES=$G(ALT)
 . I END=0 W:+($G(DSPL))=1&('$D(NOS)) !,$J(TN,6),?12,RTN,?35,RUNT,?60,"Run:  ",RUNE,!,?12,TDES,!
 . I MON=1 D UPDT((+($G(REP))),CNT,TN,RTN,END)
 S:CNT=0 EXIT=2
 I CNT=0,END=0 W:+($G(DSPL))=1&('$D(NOS)) !!,"No export task were found" S EXIT=1 Q
 I CNT=0,MON=1,END=0 W:+($G(DSPL))=1&('$D(NOS)) "  ",+($G(REP)),"  "
 I CNT>0,MON=1,END=0 W:+($G(DSPL))=1&('$D(NOS)) !!,+($G(REP)),"  "
 I CNT=0,MON=1,END=0 W:'$D(NOS) "."
 I CNT>0,MON=1,END=0 W:'$D(NOS) "."
 Q
UPDT(REP,CNT,TN,RTN,END) ;   Update
 N TIM,TGT,MSG,NOW,ELP S REP=+($G(REP)) Q:REP=0  S CNT=+($G(CNT)) Q:CNT=0
 S TN=$G(TN),RTN=$G(RTN) Q:+TN=0  Q:RTN=""  S END=+($G(END))
 S TIM=$$GET1^DIQ(14.4,(+TN_","),6,"I","TGT","MSG")
 S TIM=$$HTFM^XLFDT(TIM) S:$P(TIM,".",1)'?7N TIM=""
 I $L(TIM) S NOW=$$NOW^XLFDT,ELP=$TR($$FMDIFF^XLFDT(NOW,TIM,3)," ","0")
 S TASKLIST("A",TN)=RTN_"~"_ELP
 I REP=1 S TASKLIST("I",TN)=RTN Q
 I REP>1,END=0,'$D(TASKLIST("I",TN)) S TASKLIST("S",TN)=RTN
 I REP>1,END=1 S TASKLIST("E",TN)=RTN
 Q
ISRUN(X) ; Is X Running?
 N INP,RUN,TN S INP=$G(X) Q:$L(INP)'>1 0  Q:$L(INP)>8 0
 S (RUN,TN)=0 F  S TN=$O(^%ZTSCH("TASK",TN)) Q:+TN=0  D
 . N ND,RTN,RTNN S ND=$G(^%ZTSCH("TASK",TN))
 . S RTN=$P(ND,U,1,2),RTNN=$S(RTN["^":$P(RTN,"^",2),1:RTN) Q:$E(RTNN,1,6)'="ZZLEXX"  Q:RTN'=INP
 . S ZTSK=TN D STAT^%ZTLOAD Q:$G(ZTSK(0))'>0  Q:$G(ZTSK(1))<1  Q:$G(ZTSK(1))>2  S RUN=RUN+1
 Q:+($G(RUN))>0 1
 Q 0
PURGE ;   Purge ^ZZLEXX("ZZLEXXV")
 N SUB S SUB="" F  S SUB=$O(^ZZLEXX("ZZLEXXV",$J,SUB)) Q:'$L(SUB)  K ^ZZLEXX("ZZLEXXV",$J,SUB)
 N FILE,ONE,PRIMEB,QUIET,ZTSK
 Q
RUNT(X) ;   Scheduled Run Time
 N IEN,RUNT,RUNCODE,RUNBEG,RUNEND,RUNELP S IEN=+($G(X)) Q:'$D(^%ZTSK(IEN,0)) ""
 S RUNT=$$GET1^DIQ(14.4,(IEN_","),6,"I","TGT","MSG")
 S RUNCODE=$$GET1^DIQ(14.4,(IEN_","),51,"I","TGT","MSG")
 S RUNBEG=$$HTFM^XLFDT(RUNT),RUNEND=$$NOW^XLFDT,RUNELP=""
 S:$P(RUNBEG,".",1)?7N RUNELP=$$FMDIFF^XLFDT(RUNEND,RUNBEG,3)
 S:$L(RUNELP," ")=2 RUNELP=$TR(RUNELP," ","0")
 S:RUNCODE=5 RUNT=$TR($$FMTE^XLFDT($$HTFM^XLFDT(RUNT),"5Z"),"@"," ")
 S:RUNCODE'=5 (RUNT,RUNELP)="" S X=RUNT_"^"_RUNELP S:RUNCODE'=5 X=""
 Q X
