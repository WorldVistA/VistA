ZZLEXXBP ;SLC/KER - Import - ICD-10-PCS - Prompts ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^LEX(757.02,        SACC 1.3
 ;    ^XTMP(              SACC 2.3.2.5.2
 ;               
 ; External References
 ;    ENDR^%ZISS          ICR  10088
 ;    KILL^%ZISS          ICR  10088
 ;    $$GET1^DIQ          ICR   2056
 ;    ^DIR                ICR  10026
 ;    $$DT^XLFDT          ICR  10103
 ;    $$FMADD^XLFDT       ICR  10103
 ;    $$FMDIFF^XLFDT      ICR  10103
 ;    $$FMTE^XLFDT        ICR  10103
 ;    $$UP^XLFSTR         ICR  10104
 ;               
 Q
EFF(X) ; Effective Date
 N DIR,DIR,DIROUT,DIRUT,DTOUT,DUOUT,DIRB,BEG,END,TD,FY,YR,PD,FD,OF,Y S DIRB=""
 S TD=$$DT^XLFDT,YR=$$UP^XLFSTR($G(X)) I YR'?4N D
 . S YR=$P(YR,".TXT",1),YR=$E(YR,($L(YR)-3),$L(YR)) S:YR?4N YR=YR-1
 S OF=$E(TD,1,3)_"1001",BEG=TD,END=OF S:TD>OF BEG=OF,END=TD S OF=$$FMDIFF^XLFDT(END,BEG)
 S PD=$$FMADD^XLFDT(TD,-(365+OF)),FD=$$FMADD^XLFDT(TD,(365+OF)) S PD=($E(PD,1,3)-1)_"1001",FD=$E(FD,1,3)_"1001"
 S:YR?4N DIRB="Oct 1, "_YR S FY=$P($G(X),".",1),FY=$E(FY,($L(FY)-3),$L(FY)) S:FY?4N YR=FY S:'$L(DIRB) DIRB="Oct 1, "_FY
 S:$L(DIRB) DIR("B")=DIRB S DIR("A")=" Enter the effective date:  "
 S (DIR("?"),DIR("??"))="^D EFFH^ZZLEXXBP",DIR("PRE")="S:X[""?"" X=""??"""
 S DIR(0)="DAO^"_PD_":"_FD_":EX" W ! D ^DIR Q:X["^" "^" Q:$D(DTOUT)!($D(DUOUT))!($D(DIRUT))!($D(DIROUT)) "^"
 S X=Y
 Q X
EFFH ;   Effective Date Help
 I $G(PD)?7N,$G(FD)?7N D  Q
 . W !,?4,"Enter an effective date between ",$$FMTE^XLFDT(PD)," and "
 . W !,?4,$$FMTE^XLFDT(FD)," or ""^"" to exit. "
 W !,?4,"Enter an effective date or ""^"" to exit. "
 Q
 ;
TL(X) ; Test Load
 N TEST,DIR,DIR,DIROUT,DIRUT,DTOUT,DUOUT,DIRB,HF,Y S HF=$P($G(X),".",1)
 S DIR("B")="Yes" S:$L(HF) DIR("A")=" Test load the data in "_HF_":  "
 S:'$L(HF) DIR("A")=" Test load the data in the host file:  "
 S (DIR("?"),DIR("??"))="^D TLH^ZZLEXXBP",DIR("PRE")="S:X[""?"" X=""??"""
 S DIR(0)="YAO" W ! D ^DIR Q:X["^" "^" Q:$D(DTOUT)!($D(DUOUT))!($D(DIRUT))!($D(DIROUT)) "^"
 S X=Y
 Q X
TLH ;   Test Load Help
 D ATTR
 W !,?4,"Answer '",$G(BOLD),"Yes",$G(NORM),"' to test the load.  Possible changes will be"
 W !,?4,"displayed on the screen along with the total number of"
 W !,?4,"possible changes, but no ICD data will be updated",!
 W !,?4,"Answer '",$G(BOLD),"No",$G(NORM),"' to load the data, display the total possible"
 W !,?4,"changes with an option of updating the ICD files",!
 W !,?4,"or enter '^' to exit."
 D KATTR
 Q
 ;
CM(X) ; Test Load
 N COMMIT,DIR,DIR,DIROUT,DIRUT,DTOUT,DUOUT,DIRB,LEXHF,LEXFN,LEXTY,Y S LEXHF=$G(X) Q:'$L(LEXHF) 0
 S LEXFN="" S:$$UP^XLFSTR(LEXHF)["ICD10PCS" LEXFN="ICD Procedure file"
 S:$$UP^XLFSTR(LEXHF)["ICD10CM" LEXFN="ICD Diagnosis file" Q:'$L(LEXFN) 0
 S LEXTY=$P($G(LEXFN)," file",1) S:'$L(LEXTY) LEXTY="ICD Diagnosis"
 S DIR("B")="No",DIR("A")=" Update the "_LEXTY_" and Lexicon files:  "
 S (DIR("?"),DIR("??"))="^D CMH^ZZLEXXBP",DIR("PRE")="S:X[""?"" X=""??"""
 S DIR(0)="YAO" D CMW W ! D ^DIR Q:X["^" "^" Q:$D(DTOUT)!($D(DUOUT))!($D(DIRUT))!($D(DIROUT)) "^"
 S X=Y
 Q X
CMH ;   Test Load Help
 D ATTR S LEXTY=$G(LEXTY),LEXFN=$G(LEXFN),LEXHF=$G(LEXHF)
 I $L($G(LEXTY)) D
 . W !,?4,"Answer '",$G(BOLD),"Yes",$G(NORM),"' to update the ",$G(LEXTY)," and Lexicon files"
 . W !,?4,"with the data from the host file ",LEXHF," and"
 . W !,?4,"display the total changes made"
 . W !
 I '$L($G(LEXTY)) D
 . W !,?4,"Answer '",$G(BOLD),"Yes",$G(NORM),"' to update tbe ICD and Lexicon files with the"
 . W !,?4,"data from the host file ",LEXHF," and display the"
 . W !,?4,"total changes made"
 . W !
 W !,?4,"Answer '",$G(BOLD),"No",$G(NORM),"' to skip the update of the ICD and Lexicon files"
 W !,?4,"and display the total possibe changes had the update"
 W !,?4,"occurred",!
 W !,?4,"or enter '^' to exit."
 D KATTR
 Q
CMW ;   Commit Warning
 Q:'$L($G(LEXTY))  D ATTR W:$L($G(IOF)) @IOF W:'$L($G(IOF)) !
 W !," Update the ",LEXTY," and Lexicon files",!
 W !,?3,$G(BOLD),"WARNING:",$G(NORM),"  If you select to update the ",LEXTY," and Lexicon ",$G(NORM)
 W !,?3,$G(NORM),"          files, then ",$G(BOLD),"DO NOT",$G(NORM)," interrupt the update process (i.e., ",$G(NORM)
 W !,?3,$G(NORM),"          Control-C, close terminal session, etc.). ",$G(NORM),!
 W !,?3,$G(NORM),"          If you interrupt the update process you will leave ",$G(NORM)
 W !,?3,$G(NORM),"          partially edited records on file.  If this happens you",$G(NORM)
 W !,?3,$G(NORM),"          will need to restore the account to GOLD, delete the ",$G(NORM)
 W !,?3,$G(NORM),"          ^ZZLEXX(""ZZLEXXB*"" global and start the ICD-10 load over",$G(NORM)
 W !,?3,$G(NORM),"          again.",$G(NORM)
 D KATTR
 Q
 ;
BD(X) ; Select Brief/Detailed Display
 N DIR,DIROUT,DIRUT,DTOUT,DUOUT,DIRB,ENT,COM S ENT="BD^ZZLEXXBP",COM="Brief/Detailed Display"
 S DIRB=$$RET("BD") S DIR("B")="Detailed" S:$L(DIRB) DIR("B")=DIRB
 S DIR(0)="SAO^B:Brief Display;D:Detailed Display"
 S DIR("A")=" Select Display Type - Brief/Detailed (B/D):  "
 S (DIR("?"),DIR("??"))="^D BDH^ZZLEXXBP"
 S DIR("PRE")="S OX=X S:$L(X)&(X'[""^"")&(""^B^D^""'[(""^""_$$UP^XLFSTR($E(X,1))_""^"")) X=""??"""
 W ! D ^DIR Q:$D(DIROUT)!($D(DTOUT))!($D(DIRUT))!($D(DUOUT)) "^"  S (X,Y)=$$UP^XLFSTR($E(Y,1))
 S DIRB="" S:X="B" DIRB="Brief" S:X="D" DIRB="Detailed" D:$L(DIRB) SAV("BD",DIRB)
 Q X
BDH ;   Select Brief/Detailed Display Help
 D ATTR
 W !,?6,"Enter '",$G(BOLD),"B",$G(NORM),"' for a brief display (displays summary only),"
 W !,?6,"'",$G(BOLD),"D",$G(NORM),"' for a detailed display (displays individual entries)"
 W !,?6,"or '^' to exit"
 D KATTR
 Q
 ;
CL(X) ; Code Listing
 N DIR,DIROUT,DIRUT,DTOUT,DUOUT,DIRB,ENT,COM,OX S ENT="LC^ZZLEXXBP",COM="Code Listing"
 S DIRB=$$RET("CL") S DIR("B")="Yes" S:$L(DIRB) DIR("B")=DIRB S DIR(0)="YAO"
 S DIR("A")=" Include code listing: (Y/N):  "
 S (DIR("?"),DIR("??"))="^D CLH^ZZLEXXBP"
 S DIR("PRE")="S OX=X S:$L(X)&(X'[""^"")&(""^Y^N^""'[(""^""_$$UP^XLFSTR($E(X,1))_""^"")) X=""??"""
 W ! D ^DIR Q:$D(DIROUT)!($D(DTOUT))!($D(DIRUT))!($D(DUOUT)) "^"
 S DIRB="" S:Y="1" DIRB="Yes" S:Y="0" DIRB="No" D:$L(DIRB) SAV("CL",DIRB)
 S X=Y
 Q X
CLH ;   Select Brief/Detailed Display Help
 D ATTR
 W !,?6,"Enter '",$G(BOLD),"Yes",$G(NORM),"' to include a listing of codes."
 W !,?6,"'",$G(BOLD),"No",$G(NORM),"' to display the summary only (totals, no codes)"
 W !,?6,"or '^' to exit"
 D KATTR
 Q
 ;
WAR(X) ; Warning - Continue?
 N HF,ED,LAST,DIR,DIR,DIROUT,DIRUT,DTOUT,DUOUT,DIRB,TMP,Y
 S HF=$$UP^XLFSTR($G(X)),ED=$P($$DEFF(HF),"^",1) Q:ED'?7N 1
 S:HF["PCS"&(HF'["CM") LAST=$O(^LEX(757.02,"AUPD","10P"," "),-1)
 S:HF'["PCS"&(HF["CM") LAST=$O(^LEX(757.02,"AUPD","10D"," "),-1)
 Q:ED>0&(LAST>0)&(+ED>LAST) 1
 S:ED>0&(LAST>0)&(ED=LAST) TMP=$$WARLP(HF,ED,LAST)
 S:ED>0&(LAST>0)&(ED<LAST) TMP=$$WARLE(HF,ED,LAST)
 I $D(DIROUT)!($D(DIRUT))!($D(DTOUT))!($D(DUOUT))!($G(TMP)["^") Q "^"
 S X=0 S:+TMP>0 X=1
 Q X
WARLP(X,Y,Z) ;   Warning - Loaded Previously
 N HF,NOM,ED,LAST,DIR S HF=$G(X),ED=$G(Y),LAST=$G(Z),NOM=""
 S:HF["PCS"&(HF'["CM") NOM="ICD-10-PCS" S:HF'["PCS"&(HF["CM") NOM="ICD-10-CM"
 S DIR(0)="YAO",DIR("A")=" Do you want to continue?  (Y/N)  ",DIR("B")="No"
 S DIR("PRE")="S:X[""?"" X=""??""",(DIR("?"),DIR("??"))="^D WARLPH^ZZLEXXBP"
 D WARLPI,^DIR S X=Y
 Q X
WARLPI ;     Warning - Loaded Previously Intro
 D ATTR
 I $D(COMMIT),'$D(TEST) D  Q
 . W !,?1,"Data from file ",$G(HF)," was already loaded.  "
 . I $G(ED)?7N,$G(LAST)?7N W ! D
 . . W !,?4,"Load host file data effective:    ",$G(BOLD),$$FMTE^XLFDT($G(ED)),$G(NORM)
 . . W !,?4,"on top of global data effective:  ",$G(BOLD),$$FMTE^XLFDT($G(LAST)),$G(NORM),!
 . W !,?4,"Reloading ",$G(NOM)," data of the same date ",$G(BOLD),"may have no effect.",$G(NORM) W !
 I '$D(COMMIT),$D(TEST) D  Q
 . W !,?1,"Data from file ",$G(HF)," was already loaded.  "
 . I $G(ED)?7N,$G(LAST)?7N W ! D
 . . W !,?4,"Test host file data effective:  ",$G(BOLD),$$FMTE^XLFDT($G(ED)),$G(NORM)
 . . W !,?4,"with global data effective:     ",$G(BOLD),$$FMTE^XLFDT($G(LAST)),$G(NORM),!
 . W !,?4,"Testing ",$G(NOM)," data of the same date may result in ",$G(BOLD),"""no ",$G(NORM)
 . W !,?4,$G(BOLD),"changes found""",$G(NORM)," test results." W !
 D KATTR
 Q
WARLPH ;     Warning - Loaded Previously Help
 D ATTR
 I $D(COMMIT),'$D(TEST) D  Q
 . W !,?4,"Answer ""Yes"" to load the data in host file ",$G(HF)
 . W !,?4,"(",$G(BOLD),"not recommended",$G(NORM),", this is redundant since this data was already"
 . W !,?4,"loaded)",!
 . W !,?4,"Answer ""No"" to abort the load and exit (",$G(BOLD),"highly recommended",$G(NORM),")"
 I '$D(COMMIT),$D(TEST) D  Q
 . W !,?4,"Answer ""Yes"" to test the data in host file ",$G(HF)
 . W !,?4,"This would be redundant since this data was already loaded, however"
 . W !,?4,"it may still be useful to test the previous load.  A test result of"
 . W !,?4,$G(BOLD),"""no changes found""",$G(NORM)," would verify the data loaded correctly.",!
 . W !,?4,"Answer ""No"" to abort the test and exit."
 D KATTR
 Q
WARLE(X,Y,Z) ;   Warning - Load Error
 N HF,ED,LAST,DIR S HF=$G(X),ED=$G(Y),LAST=$G(Z)
 S DIR(0)="YAO",DIR("A")=" Do you want to continue?  (Y/N)  ",DIR("B")="No"
 S DIR("PRE")="S:X[""?"" X=""??""",(DIR("?"),DIR("??"))="^D WARLEH^ZZLEXXBP"
 D WARLEI,^DIR S X=Y
 Q X
WARLEI ;     Warning - Load Error Intro
 D ATTR
 I $D(COMMIT),'$D(TEST) D  Q
 . W !,?1,"Data from file ",$G(HF)," was already loaded and data"
 . W !,?1,"from a later host file was also loaded. "
 . I $G(ED)?7N,$G(LAST)?7N W ! D
 . . W !,?4,"Load host file data effective:    ",$G(BOLD),$$FMTE^XLFDT($G(ED)),$G(NORM)
 . . W !,?4,"on top of global data effective:  ",$G(BOLD),$$FMTE^XLFDT($G(LAST)),$G(NORM),!
 . W !,?4,"Reloading this file at this time ",$G(BOLD),"could cause irreparable",$G(NORM)
 . W !,?4,$G(BOLD),"damage, creating the necessity to have the account restored",$G(NORM)
 . W !,?4,$G(BOLD),"to a gold state.",$G(NORM) W !
 I '$D(COMMIT),$D(TEST) D  Q
 . W !!,?1,"Test results from loading host file ",$G(BOLD),$G(HF),$G(NORM)," will be"
 . W !,?1,"inaccurate since this data was already loaded.  Also, data from a "
 . W !,?1,"later host file has been loaded further throwing off the test results. "
 . I $G(ED)?7N,$G(LAST)?7N W ! D
 . . W !,?4,"Test host file data effective:  ",$G(BOLD),$$FMTE^XLFDT($G(ED)),$G(NORM)
 . . W !,?4,"with global data effective:     ",$G(BOLD),$$FMTE^XLFDT($G(LAST)),$G(NORM)
 . W !
 D KATTR
WARLEH ;     Warning - Load Error Help
 D ATTR
 I $D(COMMIT),'$D(TEST) D  Q
 . W !,?4,"Answer ""Yes"" to load the data in host file ",$G(HF)
 . W !,?4,"(",$G(BOLD),"not recommended",$G(NORM),", this will corrupt the data on file and require"
 . W !,?4,"the account to be restored to gold)",!
 . W !,?4,"Answer ""No"" to abort the load and exit (",$G(BOLD),"highly recommended",$G(NORM),")"
 I '$D(COMMIT),$D(TEST) D  Q
 . W !,?4,"Answer ""Yes"" to test the data in host file ",$G(HF)
 . W !,?4,"There is no scenario where such a test would produce meaningful"
 . W !,?4,"results",!
 . W !,?4,"Answer ""No"" to abort the test and exit."
 D KATTR
 Q
 ;
 ; Miscellaneous
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
DEFF(X) ;   Default Effective Date
 N DEF,TD,YR S TD=$$DT^XLFDT,YR=$$UP^XLFSTR($G(X)) I YR'?4N D
 . S YR=$P(YR,".TXT",1),YR=$E(YR,($L(YR)-3),$L(YR)) S:YR?4N YR=YR-1
 S DEF="" S:YR?4N DEF=(YR-1700)_"1001"
 S X="" S:DEF?7N X=DEF_"^"_$$FMTE^XLFDT(DEF,"5Z")
 Q X
TM(X,Y) ;   Trim Character Y - Default " " Space
 S X=$G(X) Q:X="" X  S Y=$G(Y) S:'$L(Y) Y=" "
 F  Q:$E(X,1)'=Y  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=Y  S X=$E(X,1,($L(X)-1))
 Q X
KILL ;   Kill Globals
 D KILL^ZZLEXXBA
 Q
ATTR ;   Screen Attributes
 N X,%,IOINHI,IOINORM S X="IOINHI;IOINORM" D ENDR^%ZISS S BOLD=$G(IOINHI),NORM=$G(IOINORM) Q
KATTR ;   Kill Screen Attributes
 D KILL^%ZISS K IOINHI,IOINORM,BOLD,NORM
 Q
