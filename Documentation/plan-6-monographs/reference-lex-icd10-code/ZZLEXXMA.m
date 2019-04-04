ZZLEXXMA ;SLC/KER - Import - Miscellaneous ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^UTILITY($J         ICR  10011
 ;               
 ; External References
 ;    HOME^%ZIS           ICR  10086
 ;    $$GET1^DIQ          ICR   2056
 ;    ^DIWP               ICR  10011
 ;    $$DT^XLFDT          ICR  10103
 ;    $$FMDIFF^XLFDT      ICR  10103
 ;    $$HTFM^XLFDT        ICR  10103
 ;    $$NOW^XLFDT         ICR  10103
 ;               
 Q
EN ; Task FileMan/Relationship Verify
 N ENV,RUN,FVT,RVT S ENV=$$ENV Q:+ENV'>0
 W:$L($G(IOF)) @IOF W !," FileMan/Relationship Verify",!," ===========================",!
 S RUN=$$ISRUN I +RUN>0 D  S CONT=$$CONT^ZZLEXX,DONE=1 Q
 . N TX,I S TX(1)=$P(RUN,"^",2) D PR(.TX,55) S I=0 F  S I=$O(TX(I)) Q:I'>0  W !,?4,$G(TX(I))
 I $$CHKIX>0 D  S CONT=$$CONT^ZZLEXX,DONE=1 Q
 . W !!,?4,"Files are currently being re-indexed, you cannot verify"
 . W !!,?4,"the files while the files are being re-indexed",!
 S FVT=$$FV2^ZZLEXXVA,RVT=$$RV2^ZZLEXXRA
 I +FVT>0 D
 . W !,?4,"FileMan Verify has been tasked (task #",+FVT,")"
 I +RVT>0 D
 . W !,?4,"Relationship Verify has been tasked (task #",+RVT,")"
 I +FVT>0&(+RVT>0) D ENH
 S CONT=$$CONT^ZZLEXX,DONE=1
 Q
ENH ; Task FileMan/Relationship Verify Help
 N MTO S MTO=$$USR Q:'$L(MTO)  W !
 W !,?4,"The FileMan and Relationship Verify could take "
 W !,?4,"from 6 to 12 minutes. The results of the FileMan"
 W !,?4,"and Relationship Verify will be mailed to the "
 W !,?4,"local IN box for ",MTO,!
 Q
 ;
MON ; Monitor Task
 N ENV S ENV=$$ENV Q:'ENV
 W:$L($G(IOF)) @(IOF) W !,"Task Monitor, press '^' to stop Monitor and exit" H 2
 N MONU,DSPL,MON,END,EXIT,TERM,REP,CHK,LIM
 S MONU=$$USR S:$L(MONU) MONU=$$LUSR(MONU)
 S MON=1,EXIT=0,END=0,CHK=0,DSPL=0,LIM=2
 F  D  Q:EXIT
 . S CHK=CHK+1 S:CHK=1!(CHK>LIM) DSPL=1
 . S:CHK'=1&(CHK'>LIM) DSPL=0 S:CHK>LIM CHK=1
 . D MON2 S TERM="" R TERM:1 I TERM["^" S END=1,DSPL=1 D MON3 S EXIT=1
 I $D(TASKLIST("A")) D
 . N BK,CT,TN,RTN S TN=0,RTN="",CT=0
 . S BK="------------------------------------------------------------------------------"
 . F  S TN=$O(TASKLIST("A",TN)) Q:+TN=0  D
 . . S CT=CT+1,RTN=$G(TASKLIST("A",TN))
 . . I CT=1 D
 . . . W # W !!,"Task observed " W:$L($G(MONU)) "for ",MONU," " W "during monitoring:"
 . . . W !!,BK,!,"Task Found",?27,"Initial Status" W ?52,"Ending Status",!,BK
 . . W !,$J(TN,8),"   ",RTN
 . . W:$D(TASKLIST("S",TN)) ?27,"Task Started"
 . . W:$D(TASKLIST("I",TN)) ?27,"Task In-Progress"
 . . W:'$D(TASKLIST("E",TN)) ?52,"Completed"
 . . W:$D(TASKLIST("E",TN)) ?52,"Still Running"
 . W !!!
 K TASKLIST
 Q
MON2 ;   Task List
 W:+($G(DSPL))=1&($L($G(IOF))) @IOF W:+($G(DSPL))=1&('$L($G(IOF))) #
 N CNT,USER,TN,RTN,TDES S MON=+($G(MON)),END=+($G(END))
 S:MON&(+($G(DSPL))=1) REP=+($G(REP))+1 S U="^",CNT=0,USER=$$USR Q:'$L(USER)
 S TN=0 F  S TN=$O(@("^%ZTSCH(""TASK"","_+TN_")")) Q:+TN=0  D
 . N ND,TK,TK2,ST,ED,EP S ND=$G(@("^%ZTSCH(""TASK"","_+TN_")")) Q:ND'[USER
 . S TK=$G(@("^%ZTSK("_+TN_",.03)")),TK2=$G(@("^%ZTSK("_+TN_",.11)")) S:$L(TK2) TK=TK2
 . S RTN=$P(ND,U,1,2),ST=$P($G(@("^%ZTSK("_+TN_",0)")),"^",5)
 . S:$L(ST)&(ST[",") ST=$$HTFM^XLFDT(ST) S ED=$$NOW^XLFDT
 . S EP="" S:($E(ST,1,7)?7N)&($E(ST,1,7)?7N) EP=$$FMDIFF^XLFDT(ED,ST,3)
 . S:$E(EP,1)=" "&($E(EP,3)=":") EP=$TR(EP," ","0")
 . S TDES=$S(ND'["No Description":$P(ND,U,5),1:"No Description")
 . I TDES?1N.N1",".N,$L(TK) S TDES=TK
 . S CNT=CNT+1
 . I CNT=1,END=0 W:+($G(DSPL))=1 !,"Task for:  ",USER,!
 . I END=0 I +($G(DSPL))=1 D
 . . N OFF S OFF=$L(RTN)+22 W !,$J(TN,6),?12,RTN W $J(" ",(78-OFF)) W:$L($G(EP),":")=3 EP
 . . W !,?12,TDES,!
 . I MON=1 D UPDT((+($G(REP))),CNT,TN,RTN,END)
 I CNT=0,END=0 W:+($G(DSPL))=1 !!,"No task were found for ",USER
 I CNT=0,MON=1,END=0 W:+($G(DSPL))=1 "  ",+($G(REP)),"  "
 I CNT>0,MON=1,END=0 W:+($G(DSPL))=1 !!,+($G(REP)),"  "
 I CNT=0,MON=1,END=0 W "."
 I CNT>0,MON=1,END=0 W "."
 Q
MON3 ;   Clear Task List
 W:$L($G(IOF)) @IOF D MON2
 Q
 ;
 ; Miscellaneous
ISRUN(X) ;   Task is Running
 N RUN,TN,TN1,TN2,TX,TX1,TX2,TXT S TXT=""
 K RUN S (RUN,TN)=0 F  S TN=$O(@("^%ZTSCH(""TASK"","_TN_")")) Q:+TN=0  D
 . N ND,TAG,RTN S ND=$G(@("^%ZTSCH(""TASK"","_+TN_")")),TAG=$P(ND,"^",1),RTN=$P(ND,"^",2)
 . I TAG="FVT",RTN="ZZLEXXMB" S RUN=+($G(RUN))+1,RUN("FV")=TN
 . I TAG="RVT",RTN="ZZLEXXMC" S RUN=+($G(RUN))+1,RUN("RV")=TN
 I RUN=1 D  Q ("1^"_TXT)
 . I $D(RUN("FV")) D  Q
 . . N TN,TX S TN=$G(RUN("FV")) S TX="FileMan Field Verify task"
 . . S:TN>0 TX=TX_" (#"_+TN_")" S TXT=TX_" is running"
 . I $D(RUN("RV")) D  Q
 . . N TN,TX S TN=$G(RUN("RV")) S TX="Relationship Verify task"
 . . S:TN>0 TX=TX_" (#"_+TN_")" S TXT=TX_" is running"
 I RUN=2 D  Q ("2^"_TXT)
 . N TN1,TN2,TX3,TX1,TX1,TX
 . S TN1=$G(RUN("FV")),TX1="FileMan Field Verify task" S:+TN1>0 TX1=TX1_" (#"_+TN1_")"
 . S TN2=$G(RUN("RV")),TX2="Relationship Verify" S TX=TX1_" and "_TX2 S TXT=TX
 . S TX3="task" S:+TN2>0 TX3=TX3_" (#"_+TN2_")" S TX3=TX3_" are running" S TXT=TXT_TX3
 Q 0
CHKIX(X) ;   Check Re-Indexing
 N RUN,TAG,RTN,TN,FI,ND,P1,P2 S FI=$G(X),RTN="ZZLEXXME"
 S TAG="" S:"^757^757.001^757.01^757.02^757.1^80^80.1^"[("^"_+FI_"^") TAG=$TR(FI,".","")_"T"
 K RUN S (RUN,TN)=0 F  S TN=$O(@("^%ZTSCH(""TASK"","_TN_")")) Q:+TN=0  D
 . N ND,P1,P2 S ND=$G(@("^%ZTSCH(""TASK"","_+TN_")")),P1=$P(ND,"^",1),P2=$P(ND,"^",2)
 . S:+FI'>0&('$L(TAG))&(RTN=P2) RUN=1 S:+FI>0&($L(TAG))&(TAG=P1)&(RTN=P2) RUN=1
 S X=RUN
 Q X
PR(LEX,X) ;   Parse Array using FileMan
 N DIW,DIWF,DIWI,DIWL,DIWR,DIWT,DIWTC,DIWX,DN,LEXC,LEXI,LEXL,Z
 K ^UTILITY($J,"W") Q:'$D(LEX)  S LEXL=+($G(X)) S:+LEXL'>0 LEXL=79
 S LEXC=+($G(LEX)) S:+($G(LEXC))'>0 LEXC=$O(LEX(" "),-1) Q:+LEXC'>0
 S DIWL=1,DIWF="C"_+LEXL S LEXI=0
 F  S LEXI=$O(LEX(LEXI)) Q:+LEXI=0  S X=$G(LEX(LEXI)) D ^DIWP
 K LEX S (LEXC,LEXI)=0
 F  S LEXI=$O(^UTILITY($J,"W",1,LEXI)) Q:+LEXI=0  D
 . S LEX(LEXI)=$$TM($G(^UTILITY($J,"W",1,LEXI,0))," "),LEXC=LEXC+1
 S:$L(LEXC) LEX=LEXC K ^UTILITY($J,"W")
 Q
UPDT(P,C,T,R,E) ;   Update
 N REP,CNT,TN,RTN,END
 S REP=+($G(P)) Q:REP=0  S CNT=+($G(C)) Q:CNT=0
 S TN=$G(T),RTN=$G(R) Q:+TN=0  Q:RTN=""  S END=+($G(E))
 S TASKLIST("A",TN)=RTN
 I REP=1 S TASKLIST("I",TN)=RTN Q
 I REP>1,END=0,'$D(TASKLIST("I",TN)) S TASKLIST("S",TN)=RTN
 I REP>1,END=1 S TASKLIST("E",TN)=RTN
 Q
LUSR(X) ;   User
 N LST,FST,OTH
 S LST=$P(X,",",1),LST=$$TM(LST),LST=$$MX(LST)
 S FST=$P(X,",",2),FST=$$TM(FST),FST=$$SP(FST),FST=$$TM(FST),FST=$$MX(FST)
 S:$L(FST) X=FST_" "_LST
 S:'$L(FST) X=LST
 Q X
LO(X) ;   Lower Case
 Q $TR(X,"ABCDEFGHIJKLMNOPQRSTUVWXYZ","abcdefghijklmnopqrstuvwxyz")
UP(X) ;   Uppercase
 Q $TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
MX(X) ;   Mixed Case
 Q $$UP($E(X,1))_$$LO($E(X,2,$L(X)))
SP(X) ;   Special Characters
 S:X[" "&($E(X,1)'=" ") X=$P(X," ",1) S:X[","&($E(X,1)'=",") X=$P(X,",",1)
 S:X["/"&($E(X,1)'="/") X=$P(X,"/",1) S:X["-"&($E(X,1)'="-") X=$P(X,"-",1)
 Q X
TM(X,Y) ;   Trim Character Y - Default " " Space
 S X=$G(X) Q:X="" X  S Y=$G(Y) S:'$L(Y) Y=" "
 F  Q:$E(X,1)'=Y  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=Y  S X=$E(X,1,($L(X)-1))
 Q X
NAM(X) ;   Name
 S X=+($G(X)) Q:X'>0 ""  S X=$$GET1^DIQ(200,(+X_","),.01)
 Q X
ENV(X) ;   Check environment
 N USR,CONT,DONE S DT=$$DT^XLFDT D HOME^%ZIS S U="^" I +($G(DUZ))=0 W !!,?5,"DUZ not defined" Q 0
 S USR=$$USR I '$L(USR) W !!,?5,"DUZ not valid" Q 0
 S:$G(DUZ(0))'["@" DUZ(0)=$G(DUZ(0))_"@"
 Q 1
USR(X) ;   User Name
 Q $$GET1^DIQ(200,(+($G(DUZ))_","),.01)
