ZZLEXXRS ;SLC/KER - Import - Rel Verify - Task ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^ZZLEXX("ZZLEXXR"   SACC 1.3
 ;               
 ; External References
 ;    STAT^%ZTLOAD        ICR  10063
 ;    $$GET1^DIQ          ICR   2056
 ;    $$FMDIFF^XLFDT      ICR  10103
 ;    $$FMTE^XLFDT        ICR  10103
 ;    $$HTFM^XLFDT        ICR  10103
 ;    $$NOW^XLFDT         ICR  10103
 ;               
 Q 
INPROG(X) ;   Task in Progress
 N INP,TAG,RTN,ZTAG,ZRTN,TN
 S INP=$G(X) S:$L(INP,"^")=2 TAG=$P(INP,"^",1),RTN=$P(INP,"^",2)
 S:$L(INP,"^")=1 TAG="",RTN=$P(INP,"^",2) Q:'$L(RTN) 0
 S (RUN,TN)=0 F  S TN=$O(@("^%ZTSCH(""TASK"","_+TN_")")) Q:+TN=0  D
 . N ND,ZTAG,ZRTN,RTNN S ND=$G(@("^%ZTSCH(""TASK"","_+TN_")"))
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
 . . S ALT=$G(@("^%ZTSK("_+TN_",.11)"))
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
 K TASKLIST
 Q
LIST ;   Task List
 W:+($G(DSPL))=1&($L($G(IOF)))&('$D(NOS)) @IOF
 N CNT,TN,RTN,TDES S MON=+($G(MON)),END=+($G(END))
 S:MON&(+($G(DSPL))=1) REP=+($G(REP))+1 S U="^",CNT=0
 S TN=0 F  S TN=$O(@("^%ZTSCH(""TASK"","_TN_")")) Q:+TN=0  D
 . N ND,T1,T2,T3,TK,TK2,RTNN,RUNT,RUNE,ALT S ND=$G(@("^%ZTSCH(""TASK"","_+TN_")")),RUNT=$$RUNT(TN)
 . S RUNE=$P(RUNT,"^",2),RUNT=$P(RUNT,"^",1)
 . S (T1,TK)=$G(@("^%ZTSK("_+TN_",.03)")),(T2,TK2)=$G(@("^%ZTSK("_+TN_",.11)")) S:$L(TK2) TK=TK2
 . S T3=$G(@("^%ZTSK("_+TN_",.3,""FI"")")),ALT=$G(@("^%ZTSK("_+TN_",.11)"))
 . S RTN=$P(ND,U,1,2),RTNN=$S(RTN["^":$P(RTN,"^",2),1:RTN) Q:$E(RTNN,1,6)'="ZZLEXX"
 . I $D(RUN) S RUN=+($G(RUN))+1 Q
 . I $D(FUL) D  Q
 . . I RTNN'["ZZLEXXR"&(FUL>0) S FUL=0 Q
 . . I RTNN["ZZLEXXR",+($G(FILE))>0 D
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
 S (RUN,TN)=0 F  S TN=$O(@("^%ZTSCH(""TASK"","_+TN_")")) Q:+TN=0  D
 . N ND,RTN,RTNN S ND=$G(@("^%ZTSCH(""TASK"","_+TN_")"))
 . S RTN=$P(ND,U,1,2),RTNN=$S(RTN["^":$P(RTN,"^",2),1:RTN) Q:$E(RTNN,1,6)'="ZZLEXX"  Q:RTN'=INP
 . S ZTSK=TN D STAT^%ZTLOAD Q:$G(ZTSK(0))'>0  Q:$G(ZTSK(1))<1  Q:$G(ZTSK(1))>2  S RUN=RUN+1
 Q:+($G(RUN))>0 1
 Q 0
RUNT(X) ;   Scheduled Run Time
 N IEN,RUNT,RUNCODE,RUNBEG,RUNEND,RUNELP S IEN=+($G(X)) Q:'$D(@("^%ZTSK("_+IEN_",0)")) ""
 S RUNT=$$GET1^DIQ(14.4,(IEN_","),6,"I","TGT","MSG")
 S RUNCODE=$$GET1^DIQ(14.4,(IEN_","),51,"I","TGT","MSG")
 S RUNBEG=$$HTFM^XLFDT(RUNT),RUNEND=$$NOW^XLFDT,RUNELP=""
 S:$P(RUNBEG,".",1)?7N RUNELP=$$FMDIFF^XLFDT(RUNEND,RUNBEG,3)
 S:$L(RUNELP," ")=2 RUNELP=$TR(RUNELP," ","0")
 S:RUNCODE=5 RUNT=$TR($$FMTE^XLFDT($$HTFM^XLFDT(RUNT),"5Z"),"@"," ")
 S:RUNCODE'=5 (RUNT,RUNELP)="" S X=RUNT_"^"_RUNELP S:RUNCODE'=5 X=""
 Q X
TM(X,Y) ;   Trim Y
 S X=$G(X),Y=$G(Y) S:'$L(Y) Y=" "
 F  Q:$E(X,1)'=Y  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=Y  S X=$E(X,1,($L(X)-1))
 Q X
