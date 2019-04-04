ZZLEXXME ;SLC/KER - Import - Misc - Re-Index ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^ICD0(              ICR   4486
 ;    ^ICD9(              ICR   4485
 ;    ^LEX(757)           SACC 1.3
 ;    ^LEX(757.001)       SACC 1.3
 ;    ^LEX(757.01)        SACC 1.3
 ;    ^LEX(757.02)        SACC 1.3
 ;    ^LEX(757.1)         SACC 1.3
 ;               
 ; External References
 ;    HOME^%ZIS           ICR  10086
 ;    $$OS^%ZOSV          ICR   3522
 ;    ^%ZTLOAD            ICR  10063
 ;    IXALL^DIK           ICR  10013
 ;    $$GET1^DIQ          ICR   2056
 ;    $$DT^XLFDT          ICR  10103
 ;    $$FMDIFF^XLFDT      ICR  10103
 ;    $$FMTE^XLFDT        ICR  10103
 ;    $$NOW^XLFDT         ICR  10103
 ;               
 Q
EN ; Main Entry Point
 N CONT,ENV,ALL,RTN S ENV=$$ENV Q:ENV'>0  W:$L(IOF) @IOF
 I $$CHKIX>0 D  S CONT=$$CONT^ZZLEXX,DONE=1 Q
 . W !!,?4,"Re-indexing ICD Load files is already in progress",!
 I $$CHKVF>0 D  S CONT=$$CONT^ZZLEXX,DONE=1 Q
 . W !!,?4,"Verify Files is in already in progress, you cannot re-index"
 . W !!,?4,"the files while the files are being verified",!
 W !," Re-indexing ICD Load files",! S ALL=""
 D F757,F757001,F75701,F75702,F7571,F80,F801 D EST
 W:$$CHKIX>0 ! S CONT=$$CONT^ZZLEXX,DONE=1
 Q
F757 ; Re-Index Major Concept Map file #757
 I $$CHKIX(757)>0 W !!,?4,"Re-indexing file 757 is already in progress",! Q
 I '$D(ALL) D
 . W !," Re-Indexing Major Concept Map file #757, Estimated Completion Time:",!
 . W !,"     ",$$FD(757),"             10 - 18 Seconds",!
 N FI S FI=757 N ZTSK,ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE,ZTQUEUED,ZTREQ,ZTPRI
 S ZTRTN="F"_$TR(FI,".","")_"T^ZZLEXXME" S ZTDESC=$$DESC(FI) S:$D(TEST) ZTQUEUED=""
 S ZTIO="",ZTDTH=$H,ZTPRI=1 D:$D(TEST) @ZTRTN D:'$D(TEST) ^%ZTLOAD
 I +($G(ZTSK))>0 W !,?5,$$DESC(FI)," tasked (#",+($G(ZTSK)),")"
 D HOME^%ZIS
 Q
F757001 ; Re-Index Concept Usage file #757.001
 I $$CHKIX(757.001)>0 W !!,?4,"Re-indexing file 757.001 is already in progress",! Q
 I '$D(ALL) D
 . W !," Re-Indexing Concept Usage file #757.001, Estimated Completion Time:",!
 . W !,"     ",$$FD(757.001),"             20 - 28 Seconds",!
 N FI S FI=757.001 N ZTSK,ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE,ZTQUEUED,ZTREQ,ZTPRI
 S ZTRTN="F"_$TR(FI,".","")_"T^ZZLEXXME" S ZTDESC=$$DESC(FI) S:$D(TEST) ZTQUEUED=""
 S ZTIO="",ZTDTH=$H,ZTPRI=1 D:$D(TEST) @ZTRTN D:'$D(TEST) ^%ZTLOAD
 I +($G(ZTSK))>0 W !,?5,$$DESC(FI)," tasked (#",+($G(ZTSK)),")"
 D HOME^%ZIS
 Q
F75701 ; Re-Index Expressions file #757.01
 I $$CHKIX(757.01)>0 W !!,?4,"Re-indexing file 757.01 is already in progress",! Q
 I '$D(ALL) D
 . W !," Re-Indexing Expressions file #757.01, Estimated Completion Time:",!
 . W !,"     ",$$FD(757.01),"             29 - 32 Minutes",!
 N FI S FI=757.01 N ZTSK,ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE,ZTQUEUED,ZTREQ,ZTPRI
 S ZTRTN="F"_$TR(FI,".","")_"T^ZZLEXXME" S ZTDESC=$$DESC(FI) S:$D(TEST) ZTQUEUED=""
 S ZTIO="",ZTDTH=$H,ZTPRI=1 D:$D(TEST) @ZTRTN D:'$D(TEST) ^%ZTLOAD
 I +($G(ZTSK))>0 W !,?5,$$DESC(FI)," tasked (#",+($G(ZTSK)),")"
 D HOME^%ZIS
 Q
F75702 ; Re-Index Codes file #757.02
 I $$CHKIX(757.02)>0 W !!,?4,"Re-indexing file 757.02 is already in progress",! Q
 I '$D(ALL) D
 . W !," Re-Indexing Codes file #757.02, Estimated Completion Time:",!
 . W !,"     ",$$FD(757.02),"              6 -  9 Minutes",!
 N FI S FI=757.02 N ZTSK,ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE,ZTQUEUED,ZTREQ,ZTPRI
 S ZTRTN="F"_$TR(FI,".","")_"T^ZZLEXXME" S ZTDESC=$$DESC(FI) S:$D(TEST) ZTQUEUED=""
 S ZTIO="",ZTDTH=$H,ZTPRI=1 D:$D(TEST) @ZTRTN D:'$D(TEST) ^%ZTLOAD
 I +($G(ZTSK))>0 W !,?5,$$DESC(FI)," tasked (#",+($G(ZTSK)),")"
 D HOME^%ZIS
 Q
F7571 ; Re-Index Semantic Map file #757.1
 I $$CHKIX(757.1)>0 W !!,?4,"Re-indexing file 757.1 is already in progress",! Q
 I '$D(ALL) D
 . W !," Re-Indexing Semantic Map file #757.1, Estimated Completion Time:",!
 . W !,"     ",$$FD(757.1),"             45 - 90 Seconds",!
 N FI S FI=757.1 N ZTSK,ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE,ZTQUEUED,ZTREQ,ZTPRI
 S ZTRTN="F"_$TR(FI,".","")_"T^ZZLEXXME" S ZTDESC=$$DESC(FI) S:$D(TEST) ZTQUEUED=""
 S ZTIO="",ZTDTH=$H,ZTPRI=1 D:$D(TEST) @ZTRTN D:'$D(TEST) ^%ZTLOAD
 I +($G(ZTSK))>0 W !,?5,$$DESC(FI)," tasked (#",+($G(ZTSK)),")"
 D HOME^%ZIS
 Q
F80 ; Re-Index ICD Diagnosis file #80
 I $$CHKIX(80)>0 W !!,?4,"Re-indexing file 80 is already in progress",! Q
 I '$D(ALL) D
 . W !," Re-Indexing ICD Diagnosis file #80, Estimated Completion Time:",!
 . W !,"     ",$$FD(80),"              3 -  5 Minutes",!
 N FI S FI=80 N ZTSK,ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE,ZTQUEUED,ZTREQ,ZTPRI
 S ZTRTN="F"_$TR(FI,".","")_"T^ZZLEXXME" S ZTDESC=$$DESC(FI) S:$D(TEST) ZTQUEUED=""
 S ZTIO="",ZTDTH=$H,ZTPRI=1 D:$D(TEST) @ZTRTN D:'$D(TEST) ^%ZTLOAD
 I +($G(ZTSK))>0 W !,?5,$$DESC(FI)," tasked (#",+($G(ZTSK)),")"
 D HOME^%ZIS
 Q
F801 ; Re-Index ICD Procedures file #80.1
 I $$CHKIX(80.1)>0 W !!,?4,"Re-indexing file 80.1 is already in progress",! Q
 I '$D(ALL) D
 . W !," Re-Indexing ICD Procedures file #80.1, Estimated Completion Time:",!
 . W !,"     ",$$FD(80.1),"              3 -  5 Minutes",!
 N FI S FI=80.1 N ZTSK,ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE,ZTQUEUED,ZTREQ,ZTPRI
 S ZTRTN="F"_$TR(FI,".","")_"T^ZZLEXXME" S ZTDESC=$$DESC(FI) S:$D(TEST) ZTQUEUED=""
 S ZTIO="",ZTDTH=$H,ZTPRI=1 D:$D(TEST) @ZTRTN D:'$D(TEST) ^%ZTLOAD
 I +($G(ZTSK))>0 W !,?5,$$DESC(FI)," tasked (#",+($G(ZTSK)),")"
 D HOME^%ZIS
 Q
 ;
F757T ; Re-Index Major Concept Map file #757   Tasked
 S:$D(ZTQUEUED) ZTREQ="@" N DIK,BEG,END,ELP S BEG=$$NOW^XLFDT
 K ^LEX(757,"B") S DIK="^LEX(757," D IXALL^DIK
 S END=$$NOW^XLFDT,ELP=$TR($$FMDIFF^XLFDT(END,BEG,3)," ","0")
 Q
F757001T ; Re-Index Concept Usage file #757.001   Tasked
 S:$D(ZTQUEUED) ZTREQ="@" N DIK,BEG,END,ELP S BEG=$$NOW^XLFDT
 K ^LEX(757.001,"B"),^LEX(757.001,"AF") S DIK="^LEX(757.001," D IXALL^DIK
 S END=$$NOW^XLFDT,ELP=$TR($$FMDIFF^XLFDT(END,BEG,3)," ","0")
 Q
F75701T ; Re-Index Expressions file #757.01      Tasked
 S:$D(ZTQUEUED) ZTREQ="@" N DIK,BEG,END,ELP S BEG=$$NOW^XLFDT
 N DA,DIK S DA=0 F  S DA=$O(^LEX(757.01,DA)) Q:+DA'>0  D
 . K ^LEX(757.01,DA,4,"B"),^LEX(757.01,DA,5,"B"),^LEX(757.01,DA,7,"B"),^LEX(757.01,DA,7,"C")
 K ^LEX(757.01,"ADC"),^LEX(757.01,"ADTERM"),^LEX(757.01,"AH"),^LEX(757.01,"AMC")
 K ^LEX(757.01,"ASL"),^LEX(757.01,"AWRD"),^LEX(757.01,"B")
 K DA S DIK="^LEX(757.01," D IXALL^DIK D:$L($T(EXP^LEXXGP1)) EXP
 S END=$$NOW^XLFDT,ELP=$TR($$FMDIFF^XLFDT(END,BEG,3)," ","0")
 Q
F75702T ; Re-Index Codes file #757.02            Tasked
 S:$D(ZTQUEUED) ZTREQ="@" N DIK,BEG,END,ELP S BEG=$$NOW^XLFDT
 N DA,DIK S DA=0 F  S DA=$O(^LEX(757.02,DA)) Q:+DA'>0  K ^LEX(757.02,DA,4,"B")
 K ^LEX(757.02,"ACODE"),^LEX(757.02,"ACT"),^LEX(757.02,"ADC"),^LEX(757.02,"ADCODE")
 K ^LEX(757.02,"ADX"),^LEX(757.02,"AMC"),^LEX(757.02,"APCODE"),^LEX(757.02,"APR")
 K ^LEX(757.02,"ASRC"),^LEX(757.02,"AUPD"),^LEX(757.02,"AVA"),^LEX(757.02,"B")
 K ^LEX(757.02,"CODE") K DA S DIK="^LEX(757.02," D IXALL^DIK
 S END=$$NOW^XLFDT,ELP=$TR($$FMDIFF^XLFDT(END,BEG,3)," ","0")
 Q
F7571T ; Re-Index Semantic Map file #757.1      Tasked
 S:$D(ZTQUEUED) ZTREQ="@" N DIK,BEG,END,ELP S BEG=$$NOW^XLFDT
 K ^LEX(757.1,"AMCC"),^LEX(757.1,"AMCT"),^LEX(757.1,"ASTT"),^LEX(757.1,"B")
 K DA S DIK="^LEX(757.1," D IXALL^DIK
 S END=$$NOW^XLFDT,ELP=$TR($$FMDIFF^XLFDT(END,BEG,3)," ","0")
 Q
F80T ; Re-Index ICD Diagnosis file #80        Tasked
 S:$D(ZTQUEUED) ZTREQ="@" N DIK,BEG,END,ELP,EXC S BEG=$$NOW^XLFDT
 S EXC="S $P(^ICD9(0),""^"",1)=""ICD DIAGNOSIS"",$P(^ICD9(0),""^"",2)=""80IO""" X EXC
 S EXC="S $P(^ICD9(0),""^"",3)=$P($G(^ICD9(0)),""^"",3),$P(^ICD9(0),""^"",4)=$P($G(^ICD9(0)),""^"",4)" X EXC
 N DA,DIK S DA=0 F  S DA=$O(^ICD9(DA)) Q:+DA'>0  D
 . S EXC="K ^ICD9("_+DA_",3,""B""),^ICD9("_+DA_",4,""B""),^ICD9("_+DA_",66,""B""),^ICD9("_+DA_",67,""B"")" X EXC
 . S EXC="K ^ICD9("_+DA_",68,""B""),^ICD9("_+DA_",69,""B""),^ICD9("_+DA_",""N"",""B""),^ICD9("_+DA_",6,""B"")" X EXC
 . S EXC="K ^ICD9("_+DA_",7,""B""),^ICD9("_+DA_",""R"",""B""),^ICD9("_+DA_",5,""B""),^ICD9("_+DA_",66,""B"")" X EXC
 . S EXC="K ^ICD9("_+DA_",67,""B""),^ICD9("_+DA_",3,""B""),^ICD9("_+DA_",4,""B""),^ICD9("_+DA_",73,""B"")" X EXC
 . N D2 S D2=0 F  S D2=$O(^ICD9(DA,68,D2)) Q:+D2'>0  S EXC="K ^ICD9("_+DA_",68,"_+D2_",2,""B"")" X EXC
 . S D2=0 F  S D2=$O(^ICD9(DA,3,D2)) Q:+D2'>0  S EXC="K ^ICD9("_+DA_",3,"_+D2_",1,""B"")" X EXC
 S EXC="K ^ICD9(""AB""),^ICD9(""ABA""),^ICD9(""ACC""),^ICD9(""ACT""),^ICD9(""ACTS""),^ICD9(""AD"")" X EXC
 S EXC="K ^ICD9(""ADS""),^ICD9(""ADSS""),^ICD9(""AN""),^ICD9(""AST""),^ICD9(""ASTS""),^ICD9(""AVA"")" X EXC
 S EXC="K ^ICD9(""BA""),^ICD9(""D"")" X EXC K DA,DIK S DIK="^ICD9(" D IXALL^DIK
 S END=$$NOW^XLFDT,ELP=$TR($$FMDIFF^XLFDT(END,BEG,3)," ","0")
 Q
F801T ; Re-Index ICD Procedures file #80.1     Tasked
 S:$D(ZTQUEUED) ZTREQ="@" N DIK,BEG,END,ELP,EXC S BEG=$$NOW^XLFDT
 S EXC="S $P(^ICD0(0),""^"",1)=""ICD OPERATION/PROCEDURE"",$P(^ICD0(0),""^"",2)=""80.1IO""" X EXC
 S EXC="S $P(^ICD0(0),""^"",3)=$P($G(^ICD0(0)),""^"",3),$P(^ICD0(0),""^"",4)=$P($G(^ICD0(0)),""^"",4)" X EXC
 N DA,DIK S DA=0 F  S DA=$O(^ICD0(DA)) Q:+DA'>0  D
 . K ^ICD0(DA,3,"B"),^ICD0(DA,66,"B"),^ICD0(DA,67,"B")
 . K ^ICD0(DA,68,"B"),^ICD0(DA,2,"B"),^ICD0(DA,73,"B")
 . N D2 S D2=0 F  S D2=$O(^ICD0(DA,68,D2)) Q:+D2'>0  D
 . . K ^ICD0(DA,68,D2,2,"B")
 . S D2=0 F  S D2=$O(^ICD0(DA,2,D2)) Q:+D2'>0  D
 . . K ^ICD0(DA,2,D2,1,"B") N D3 S D3=0
 . . F  S D3=$O(^ICD0(DA,2,D2,1,D3)) Q:+D3'>0  D
 . . . K ^ICD0(DA,2,D2,1,D3,1,"B")
 S EXC="K ^ICD0(""AB""),^ICD0(""ABA""),^ICD0(""ACT""),^ICD0(""ACTS"")" X EXC
 S EXC="K ^ICD0(""AD""),^ICD0(""ADS""),^ICD0(""ADSS""),^ICD0(""AEXC"")" X EXC
 S EXC="K ^ICD0(""AN""),^ICD0(""AST""),^ICD0(""ASTS""),^ICD0(""AVA"")" X EXC
 S EXC="K ^ICD0(""BA""),^ICD0(""D"")" X EXC K DA S DIK="^ICD0(" D IXALL^DIK
 S END=$$NOW^XLFDT,ELP=$TR($$FMDIFF^XLFDT(END,BEG,3)," ","0")
 Q
EXP ; Index all Lookup Indexes
 Q:'$L($T(EXP^LEXXGP1))  S:$D(ZTQUEUED) ZTREQ="@"
 K ^TMP("LEXAWRD",$J),^TMP("LEXAWRDU",$J),^TMP("LEXAWRDK",$J),^TMP("LEXASL",$J),^TMP("LEXASLU",$J),^TMP("LEXSUB",$J),^TMP("LEXXGPTIM",$J)
 N DIC,DTOUT,DUOUT,LEX,LEX1,LEX2,LEX3,LEX4,LEXB,LEXBD,LEXBEG,LEXBEGD,LEXBEGT,LEXBT,LEXC,LEXCHR
 N LEXCHRS,LEXCMD,LEXCOM,LEXCTL,LEXD,LEXDF,LEXE,LEXEL,LEXELP,LEXELPT,LEXEND,LEXENDD,LEXENDT,LEXET,LEXEX,LEXEXP,LEXF
 N LEXFC,LEXFIR,LEXFUL,LEXHDR,LEXI,LEXID,LEXIDS,LEXIDX,LEXINAM,LEXIT,LEXJ,LEXLAST,LEXLN,LEXLOOK,LEXLOUD,LEXLWRD,LEXM
 N LEXMC,LEXMCEI,LEXMCI,LEXN,LEXNAM,LEXNEW,LEXNM,LEXNOD,LEXO,LEXO1,LEXO2,LEXP,LEXPDT,LEXPRE,LEXRI,LEXRT,LEXRT1,LEXRT2
 N LEXS,LEXSI,LEXSUB,LEXT,LEXTDAT,LEXTEXP,LEXTK,LEXTKC,LEXTKN,LEXTMP,LEXTWRD,LEXTX,LEXTXT,LEXV,LEXX,X,XCNP,XMDUZ
 N XMSCR,XMSUB,XMTEXT,XMY,XMZ,Y S:'$D(LEXQUIT) LEXQUIT="ALL" N LEXTXT,LEXFUL S LEXFUL="" D EXP^LEXXGP1
 K LEXQUIT,ZTQUEUED,LEXMAIL,LEXHOME N ZTQUEUED,LEXTEST K ^TMP("LEXAWRD",$J),^TMP("LEXAWRDU",$J),^TMP("LEXAWRDK",$J)
 K ^TMP("LEXASL",$J),^TMP("LEXASLU",$J),^TMP("LEXSUB",$J),^TMP("LEXXGPTIM",$J)
 Q
 ; 
 ; Miscellaneous
EST ;   Estimated Times
 W !!," Estimated Completion Time (re-indexed concurrently)       47 - 64 Minutes",!
 W !,"     ",$$FD(757),"     ^LEX(757)        45 - 60 Seconds"
 W !,"     ",$$FD(757.001),"     ^LEX(757.001)     1 -  2 Minutes"
 W !,"     ",$$FD(757.01),"     ^LEX(757.01)     30 - 40 Minutes"
 W !,"     ",$$FD(757.02),"     ^LEX(757.02)     10 - 14 Minutes"
 W !,"     ",$$FD(757.1),"     ^LEX(757.1)       2 -  4 Minutes"
 W !,"     ",$$FD(80),"     ^ICD9             8 - 10 Minutes"
 W !,"     ",$$FD(80.1),"     ^ICD0             7 -  9 Minutes"
 W !,"     ",$$FD("R"),"     ^LEX             17 - 24 Minutes"
 I $$OS^%ZOSV["VMS" D
 . Q  W !,"     NOTE:  All times given are for a LINUX system."
 Q
CHKIX(X) ;   Check Re-Indexing
 N RUN,TAG,RTN,TN,FI,ND,P1,P2 S FI=$G(X),RTN=$$LR
 S TAG="" S:"^757^757.001^757.01^757.02^757.1^80^80.1^"[("^"_+FI_"^") TAG=$TR(FI,".","")_"T"
 K RUN S (RUN,TN)=0 F  S TN=$O(@("^%ZTSCH(""TASK"","_TN_")")) Q:+TN=0  D
 . N ND,P1,P2 S ND=$G(@("^%ZTSCH(""TASK"","_+TN_")")),P1=$P(ND,"^",1),P2=$P(ND,"^",2)
 . S:+FI'>0&('$L(TAG))&(RTN=P2) RUN=1 S:+FI>0&($L(TAG))&(TAG=P1)&(RTN=P2) RUN=1
 S X=RUN
 Q X
CHKVF(X) ;   Check Verify Files
 N RUN,TN,TN1,TN2,TX,TX1,TX2,TXT
 K RUN S (RUN,TN)=0 F  S TN=$O(@("^%ZTSCH(""TASK"","_TN_")")) Q:+TN=0  D
 . N ND,TAG,RTN S ND=$G(@("^%ZTSCH(""TASK"","_+TN_")")),TAG=$P(ND,"^",1),RTN=$P(ND,"^",2)
 . I TAG="FVT",RTN="ZZLEXXMB" S RUN=+($G(RUN))+1
 . I TAG="RVT",RTN="ZZLEXXMC" S RUN=+($G(RUN))+1
 Q 0
FD(X) ;   FileMan File Designation
 N FI S FI=+($G(X))
 Q:FI=757 "Major Concept Map       #757    "
 Q:FI=757.001 "Concept Usage           #757.001"
 Q:FI=757.01 "Expressions             #757.01 "
 Q:FI=757.02 "Codes                   #757.02 "
 Q:FI=757.1 "Semantic Map            #757.1  "
 Q:FI=80 "ICD Diagnosis           #80     "
 Q:FI=80.1 "ICD Procedures          #80.1   "
 Q:$G(X)="R" "Repair Lookup Indexes   #757*   "
 S X="ICD/Lexicon files               "
 Q X
FN(X) ;   File Name
 N FI S FI=+($G(X)) Q:FI=757 "Major Concept Map file #757"  Q:FI=757.001 "Concept Usage file #757.001"
 Q:FI=757.01 "Expressions file #757.01"  Q:FI=757.02 "Codes file #757.02"  Q:FI=757.1 "Semantic Map file #757.1"
 Q:FI=80 "ICD Diagnosis file #80"  Q:FI=80.1 "ICD Procedures file #80.1"  S X="ICD/Lexicon file"
 Q X
DESC(X) ;   Task Description
 N FI,FN,TY,OUT,MST,NM S FI=+($G(X)),TY=$P(FI,".",1) Q:"^757^80^81^"'[("^"_TY_"^") "Re-index File"
 S NM=$$FN(+FI) S:$L(NM) X="Re-index "_NM S:'$L(NM) X="Re-index File #"_FI
 Q X
CLR ;   Clear
 N TEST
 Q
KG ; Kill Global
 K ^ZZLEXX("ZZLEXXME",$J)
 Q
LR(X) ;   Local Routine
 S X=$T(+1),X=$P(X," ",1) Q X
ENV(X) ;   Check environment
 N USR,DONE S DT=$$DT^XLFDT D HOME^%ZIS S U="^" I +($G(DUZ))=0 Q 0
 S USR=$$GET1^DIQ(200,(DUZ_","),.01) I '$L(USR) Q 0
 Q 1
