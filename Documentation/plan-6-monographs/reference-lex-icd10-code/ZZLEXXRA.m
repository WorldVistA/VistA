ZZLEXXRA ;SLC/KER - Import - Rel Verify ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^LEX(               SACC 1.3
 ;    ^LEX(757.02,        SACC 1.3
 ;    ^ZZLEXX("ZZLEXXR")  SACC 1.3
 ;               
 ; External References
 ;    HOME^%ZIS           ICR  10086
 ;    ^%ZTLOAD            ICR  10063
 ;    $$S^%ZTLOAD         ICR  10063
 ;    $$FIND1^DIC         ICR   2051
 ;    $$GET1^DIQ          ICR   2056
 ;    $$DT^XLFDT          ICR  10103
 ;    $$FMDIFF^XLFDT      ICR  10103
 ;    $$FMTE^XLFDT        ICR  10103
 ;    $$NOW^XLFDT         ICR  10103
 ;    ^XMD                ICR  10070
 ;               
 Q
RV ; Relationship Verfiy ICD Load Files
 I $$INPROG^ZZLEXXRS("RV2]^ZZLEXXRA")>0 W !,"  FileMan Field Verify is already inprogress, aborting" Q
 N %DT,ABR,ABT,ADAT,ALL,ANOD,APIE,BLD,CHG,CHGS,CHK,CMD,COMMIT,CRE,CSID,MAIN
 N CT,CTL,DA,DIC,DIRA,EFF,ENV,ERR,EXP,EXT,FI,FILE,FIR,FOK,IEN,INP,LARY,LAS
 N LDAT,LIM,LIST,LNOD,LOC,LPIE,MDA,MET,MSG,MUMPS,MTO,NAM,NARY,ND,NDI,NDN
 N NDS,NEW,NM,NN,NODE,NS,NXT,OA,OK,OLD,ONODE,OUT,OVER,PIE,PKG,POP,POS,PSN
 N QUIET,REC,REV,ROOT,RT,RTNM,RVD,RVE,RVN,SEG,SM,STA,STO,STR,TD,TEF,TNAME
 N TOT,TX,TXT,TY,VER,VRD,VRE,X,Y,Z,ZZLEXX,ZTDESC,ZTDTH,ZTIO,ZTQUEUED,ZTREQ,ZTRTN
 N ZTSAVE,ZTSK,ZZLEXX,CONT S MAIN="ALL" S ENV=$$ENV Q:+ENV'>0  S ZTRTN="ICD10^ZZLEXXRA"
 S CHK=$$RUNNING^ZZLEXXRS I CHK>0 D  Q
 . W !,"  A load utility task is running, aborting"
 S ZZLEXX=1,ZTDESC="Relationship Verify ICD Load Files",ZTIO="",ZTDTH=$H
 S MTO=$$NAM(+($G(DUZ))) Q:'$L(MTO)  S ZTSAVE("MTO")="",ZTSAVE("ZZLEXX")=""
 S:$D(MAIN) ZTSAVE("MAIN")="" D ^%ZTLOAD
 I +($G(ZTSK))>0 W !,?4,"Relationship Verify ICD Load Files tasked (",+($G(ZTSK)),")"
 D HOME^%ZIS K Y,ZTSK,ZTDESC,ZTDTH,ZTIO,ZTRTN N TEST
 Q
RV2(X) ; Relationship Verfiy ICD Load Files
 Q:$$INPROG^ZZLEXXRS("RV2]^ZZLEXXRA")>0 ""
 N %DT,ABR,ABT,ADAT,ALL,ANOD,APIE,BLD,CHG,CHGS,CHK,CMD,COMMIT,CRE,CSID,MAIN
 N CT,CTL,DA,DIC,DIRA,EFF,ENV,ERR,EXP,EXT,FI,FILE,FIR,FOK,IEN,INP,LARY,LAS
 N LDAT,LEX,LIM,LIST,LNOD,LOC,LPIE,MDA,MET,MSG,MUMPS,MTO,NAM,NARY,ND,NDI,NDN
 N NDS,NEW,NM,NN,NODE,NS,NXT,OA,OK,OLD,ONODE,OUT,OVER,PIE,PKG,POP,POS,PSN
 N QUIET,REC,REV,ROOT,RT,RTNM,RVD,RVE,RVN,SEG,SM,STA,STO,STR,TD,TEF,TNAME
 N TOT,TX,TXT,TY,VER,VRD,VRE,X,Y,Z,ZZLEXX,ZTDESC,ZTDTH,ZTIO,ZTQUEUED,ZTREQ,ZTRTN
 N ZTSAVE,ZTSK,ZZLEXX,CONT S MAIN="ALL" S ENV=$$ENV Q:+ENV'>0  S ZTRTN="ICD10^ZZLEXXRA"
 S CHK=$$RUNNING^ZZLEXXRS I CHK>0 D  Q ""
 . W !,"  A load utility task is running, aborting"
 S ZZLEXX=1 S ZTDESC="Relationship Verify ICD Load Files",ZTIO="",ZTDTH=$H
 S MTO=$$NAM(+($G(DUZ))) Q:'$L(MTO)  S ZTSAVE("MTO")="",ZTSAVE("ZZLEXX")=""
 S:$D(MAIN) ZTSAVE("MAIN")="" D ^%ZTLOAD
 S LEX=+($G(ZTSK)) D HOME^%ZIS K Y,ZTSK,ZTDESC,ZTDTH,ZTIO,ZTRTN N TEST S X=LEX
 Q X
ICD10 ; Relationship Verfiy ICD Load Files (TASK)
 K ^ZZLEXX("ZZLEXXR",$J,"TOT"),^ZZLEXX("ZZLEXXR",$J,"MAIN"),^ZZLEXX("ZZLEXXR",$J,"FRAG"),^ZZLEXX("ZZLEXXR",$J,"DRAFT")
 K ^ZZLEXX("ZZLEXXR",$J,"MSG"),^ZZLEXX("ZZLEXXR",$J,"SUM"),^ZZLEXX("ZZLEXXR",$J,"TIME"),^ZZLEXX("ZZLEXXR",$J,"TEMP")
 N CSID,CT,DA,EFF,FI,LARY,MDA,MTO,NARY,OVER,RUN,STA,BEG,END,REDO,BEG,END,ELP,LEXT,FULL,TOTERR,LEXSUB
 S LEXSUB="Load ICD-10 Relationship Verify"
 S FULL="",BEG=$$HACK,TOTERR=0
 S LEXT="Relationship Verify ICD Load Files"
 D UPD(757),F757
 D UPD(757.001),F757001
 D UPD(757.01),F75701
 D UPD(757.02),F75702
 D UPD(757.033),F757033
 D UPD(757.1),F7571
 D UPD(80),F80
 D UPD(80.1),F801
 D UPD("SUM"),SSUM
 S END=$$HACK,ELP=$$ELAP(BEG,END)
 D:$D(ZTQUEUED) END^ZZLEXXRR(BEG,END,ELP,TOTERR,"ICD-10 Relationship Verify"),BUILD^ZZLEXXRR
 I $D(ZTQUEUED),$D(^ZZLEXX("ZZLEXXR",$J,"DRAFT")) D UPD("MAIL"),MAIL
 K ^ZZLEXX("ZZLEXXR",$J,"TOT"),^ZZLEXX("ZZLEXXR",$J,"MAIN"),^ZZLEXX("ZZLEXXR",$J,"FRAG"),^ZZLEXX("ZZLEXXR",$J,"DRAFT")
 K ^ZZLEXX("ZZLEXXR",$J,"MSG"),^ZZLEXX("ZZLEXXR",$J,"SUM"),^ZZLEXX("ZZLEXXR",$J,"TIME"),^ZZLEXX("ZZLEXXR",$J,"TEMP")
 Q
F757 ;   File 757
 S ZZLEXX=1 N FULL S FULL="" D EN^ZZLEXXRB Q
F757001 ;   File 757.001
 S ZZLEXX=1 N FULL S FULL="" D EN^ZZLEXXRC Q
F75701 ;   File 757.01
 N RELVER S (RELVER,ZZLEXX)=1 N FULL S FULL="" D EN^ZZLEXXRD Q
F75702 ;   File 757.02
 S ZZLEXX=1 N FULL S FULL="" D EN^ZZLEXXRE Q
F757033 ;   File 757.033
 S ZZLEXX=1 N FULL S FULL="" D EN^ZZLEXXRL Q
F7571 ;   File 757.1
 S ZZLEXX=1 N FULL S FULL="" D EN^ZZLEXXRM Q
F80 ;   File 80
 S ZZLEXX=1 N FULL S FULL="" D EN^ZZLEXXRN Q
F801 ;   File 80.1
 S ZZLEXX=1 N FULL S FULL="" D EN^ZZLEXXRP Q
 ;
INC(X) ; Increment Error
 N ID S ID=+($G(X)) Q:+ID'>0 ""
 S X=+($G(^ZZLEXX("ZZLEXXR",$J,"TOT",757.01,ID)))+1
 S ^ZZLEXX("ZZLEXXR",$J,"TOT",757.01,ID)=+X
 Q X
SSUM ; Summary
 I $D(^ZZLEXX("ZZLEXXR",$J,"TOT")) D
 . N FI,RE,GL,FN,TXT,CNT,ERT,LN D SSW(" ")
 . S LN=0,FI="" F  S FI=$O(^ZZLEXX("ZZLEXXR",$J,"TOT",FI)) Q:+FI=0  D
 . . Q:$E(FI,1,3)'=757  S LN=LN+1 I LN=1&($G(OA)'="O") D
 . . . D SSW(" "),SSW("  Lexicon Utility"),SSW("  ===============")
 . . D SSL
 . S LN=0,FI="" F  S FI=$O(^ZZLEXX("ZZLEXXR",$J,"TOT",FI)) Q:+FI=0  D
 . . Q:$E(FI,1,2)'=80  S LN=LN+1 I LN=1&($G(OA)'="O") D
 . . . D SSW(" "),SSW("  ICD-10 Diagnosis/Procedures"),SSW("  =================================")
 . . D SSL
 . D SSW(" ")
 Q
SSL ;   Lines
 S GL=$G(@("^DIC("_+FI_",0,""GL"")")) Q:'$L(GL)
 S:$L(GL)&(+FI>0) GL=GL_$J("",(15-$L(GL)))_"  #"_+FI
 S FN=$$FN(FI) S TXT="  "_FN,TXT=TXT_$J("",40-$L(TXT))_GL D SSW(""),SSW(TXT)
 S RE=0 F  S RE=$O(^ZZLEXX("ZZLEXXR",$J,"TOT",FI,RE)) Q:+RE=0  D
 . S CNT=$G(^ZZLEXX("ZZLEXXR",$J,"TOT",FI,RE))
 . S ERT=$G(^ZZLEXX("ZZLEXXR",$J,"TOT",FI,RE,"T")) Q:'$L(ERT)
 . S:+CNT>0 CNT=CNT_" " S TXT="    "_CNT_ERT D SSW(TXT)
 Q
SSW(X) ;   Write
 N I S X=$G(X) S:'$L(X) X=" "
 W:'$D(ZTQUEUED) !,$G(X) Q:'$D(ZTQUEUED)
 S I=$O(^ZZLEXX("ZZLEXXR",$J,"SUM"," "),-1)+1
 S ^ZZLEXX("ZZLEXXR",$J,"SUM",I,0)=X
 Q
 ;
MAIL ; Send Message
 K XMZ N DIFROM,I,USER,TX,CT,OK,SP S U="^" S XMSUB="Load ICD-10 Relationship Verify"
 S:$L($G(LEXSUB)) XMSUB=$G(LEXSUB)
 S USER=$$NAM(+($G(DUZ))) G:'$L(USER) MAILQ S XMY(USER)="" S XMY("G.LEXICON@DNS    .DOMAIN")=""
 K ^ZZLEXX("ZZLEXXR",$J,"MSG")
 S I=999 F  S I=$O(^ZZLEXX("ZZLEXXR",$J,"DRAFT",I)) Q:+I'>0  K ^ZZLEXX("ZZLEXXR",$J,"DRAFT",I)
 I $O(^ZZLEXX("ZZLEXXR",$J,"DRAFT"," "),-1)>990 D
 . N CT S CT=$O(^ZZLEXX("ZZLEXXR",$J,"DRAFT"," "),-1)+1 S ^ZZLEXX("ZZLEXXR",$J,"DRAFT",CT)=" "
 . S CT=$O(^ZZLEXX("ZZLEXXR",$J,"DRAFT"," "),-1)+1 S ^ZZLEXX("ZZLEXXR",$J,"DRAFT",CT)=" Report truncated - too many errors to report"
 . S CT=$O(^ZZLEXX("ZZLEXXR",$J,"DRAFT"," "),-1)+1 S ^ZZLEXX("ZZLEXXR",$J,"DRAFT",CT)=" "
 D SUM^ZZLEXXRR S I=0 F  S I=$O(^ZZLEXX("ZZLEXXR",$J,"DRAFT",I)) Q:+I'>0  D
 . N CT,PT,NT S CT=$O(^ZZLEXX("ZZLEXXR",$J,"MSG"," "),-1)
 . S PT=$G(^ZZLEXX("ZZLEXXR",$J,"MSG",+CT)) S CT=CT+1
 . S NT=$E($G(^ZZLEXX("ZZLEXXR",$J,"DRAFT",I)),1,79)
 . I CT>1,'$L($$TM(PT)),'$L($$TM(NT)) Q
 . S ^ZZLEXX("ZZLEXXR",$J,"MSG",CT)=NT
 S XMTEXT="^ZZLEXX(""ZZLEXXR"","_$J_",""MSG""," N MSG
 S XMDUZ=.5 D ^XMD
MAILQ ; Mail Quit
 S:$D(ZTQUEUED) ZTREQ="@" K ^ZZLEXX("ZZLEXXR",$J,"DRAFT"),^ZZLEXX("ZZLEXXR",$J,"TIME"),^ZZLEXX("ZZLEXXR",$J,"SUM"),^ZZLEXX("ZZLEXXR",$J,"MSG")
 K %,%Z,XCNP,XMSCR,XMDUZ,XMY,XMZ,XMSUB,XMY,XMTEXT,XMDUZ
 Q
 ; 
 ; Miscellaneous
UPD(X) ;   Update
 Q:'$D(ZTQUEUED)  Q:'$D(ZTSK)  Q:+($G(ZTSK))'>0  Q:'$L($G(@("^%ZTSK("_+($G(ZTSK))_",.03)")))
 N TX,CHK S TX="Load ICD-10 Relationship Verify" S:+($G(X))>0 TX=TX_" (file #"_+($G(X))_")"
 S:X="SUM" TX=TX_" (Summary)" S:X="MAIL" TX=TX_" (Mail)" S @("^%ZTSK("_+($G(ZTSK))_",.03)")=$G(X)
 S CHK=$$S^%ZTLOAD(TX) N ZTSK
 Q
FN(X) ;   Filename
 N FI,FN S FI=+($G(X)) Q:FI'>0  Q:"^757^757.001^757.01^757.02^757.033^757.1^80^80.1^"'[("^"_FI_"^") ""
 S FN=$P($G(@("^DIC("_+FI_",0)")),"^",1) Q:'$L(FN) ""
 S:FI=757 FN="Major Concept Map"
 S:FI=757.001 FN="Concept Usage"
 S:FI=757.01 FN="Expressions"
 S:FI=757.02 FN="Codes"
 S:FI=757.033 FN="Character Positions"
 S:FI=757.1 FN="Semantic Map"
 S:FI=80 FN="ICD-10 Diagnosis"
 S:FI=80.1 FN="ICD-10 Procedure"
 S:"^757^757.001^757.01^757.02^757.033^757.1^80^80.1^"[("^"_FI_"^") FN=FN_" File"
 S X=FN
 Q X
NAM(X) ;   Name
 S X=+($G(X)) Q:X'>0 ""  S X=$$GET1^DIQ(200,(+X_","),.01)
 Q X
HACK(X) ;   Get Curent Time (NOW)
 S X=$$NOW^XLFDT Q X
ELAP(X,E) ;   Get Elapsed Time (B)ginning/(E)nding
 N BEG,END,ELP S BEG=$G(X),END=$G(E) S ELP=$$FMDIFF^XLFDT(END,BEG,3)
 S:$L(ELP,":")=2&($L(ELP)=8) ELP=$TR(ELP," ","0")
 S:$L($P(ELP,":",1))=3&($E(ELP,1)="0") ELP=$E(ELP,2,$L(ELP))
 S X=ELP
 Q X
TIME(B,E,T) ;   Save Time
 D TI(" "),TI("Relationship Verify"),TI(" ")
 D TI(("   Start:     "_$$LDTT($G(B))))
 D TI(("   Finish:    "_$$LDTT($G(E))))
 S T=$$TM($G(T))
 S:$L(T,":")=3&('$L($P(T,":",1))) T="00"_T
 S:$L(T,":")=3&($L($P(T,":",1))=1) T="0"_T
 D TI(("   Time:                  "_$G(T)))
 Q
LDTT(X) ;   Long Date and Time
 S X=$$FMTE^XLFDT($G(X),"5Z") S:X["@" X=$P(X,"@",1)_"  "_$P(X,"@",2)
 Q X
BL ;   Blank Line
 N C,TXT S C=+($O(^ZZLEXX("ZZLEXXR",$J,"DRAFT"," "),-1)) S TXT=$$TM($G(^ZZLEXX("ZZLEXXR",$J,"DRAFT",C))) Q:+C>0&(TXT="")  I $D(TEST) W ! N TEST Q
 D TL("")
 Q
AL(X) ;   Append Line
 I $D(TEST) W $G(X) N TEST Q
 S X=$G(X) N C S C=+($O(^ZZLEXX("ZZLEXXR",$J,"DRAFT"," "),-1)) S:C=0 C=1 S ^ZZLEXX("ZZLEXXR",$J,"DRAFT",C)=$G(^ZZLEXX("ZZLEXXR",$J,"DRAFT",C))_X,^ZZLEXX("ZZLEXXR",$J,"DRAFT",0)=C
 Q
RL(X) ;   Text Line
 W:'$D(ZTQUEUED) !,$G(X) Q:'$D(ZTQUEUED)  I $D(TEST) W $G(X) N TEST Q
 S X=$G(X) N C S C=+($G(^ZZLEXX("ZZLEXXR",$J,"DRAFT",0))),C=C+1 S ^ZZLEXX("ZZLEXXR",$J,"DRAFT",C)=$G(X),^ZZLEXX("ZZLEXXR",$J,"DRAFT",0)=C
 Q
TL(X) ;   Text Line
 I $D(TEST) W !,$G(X) N TEST Q
 S X=$G(X) N C S C=+($O(^ZZLEXX("ZZLEXXR",$J,"DRAFT"," "),-1)),C=C+1,^ZZLEXX("ZZLEXXR",$J,"DRAFT",C)=X,^ZZLEXX("ZZLEXXR",$J,"DRAFT",0)=C
 Q
TI(X) ;   Text Line (TIME)
 I '$D(ZTQUEUED) W !,$G(X) Q
 S X=$G(X) N C S C=+($O(^ZZLEXX("ZZLEXXR",$J,"TIME"," "),-1))+1,^ZZLEXX("ZZLEXXR",$J,"TIME",C,0)=(" "_X),^ZZLEXX("ZZLEXXR",$J,"TIME",0)=C
 Q
TT(X) ;   Title Line
 N LN,C S X=$G(X) S LN="",$P(LN,"-",78)="-"
 I $D(TEST) W !,$G(X),!,LN N TEST Q
 S C=+($O(^ZZLEXX("ZZLEXXR",$J,"DRAFT"," "),-1)),C=C+1
 S ^ZZLEXX("ZZLEXXR",$J,"DRAFT",C)=X,C=C+1,^ZZLEXX("ZZLEXXR",$J,"DRAFT",C)=LN,^ZZLEXX("ZZLEXXR",$J,"DRAFT",0)=C
 Q
I10(X,Y) ;   Is ICD-10 Concept
 N FI,IEN,MC,SIEN S FI=$G(X),IEN=$G(Y) Q:'$D(^LEX(FI,+IEN,0)) 0  I +FI=757.02 D  Q X
 . S X=0 S:"^30^31^"[("^"_$P($G(^LEX(FI,+IEN,0)),"^",3)_"^") X=1
 S:FI=757!(FI=757.001) MC=IEN S:FI=757.01 MC=$P($G(^LEX(FI,+IEN,1)),"^",1)
 S:FI=757.02 MC=$P($G(^LEX(FI,+IEN,0)),"^",4) S:FI=757.1 MC=$P($G(^LEX(FI,+IEN,0)),"^",1) Q:+MC'>0 0  S (X,SIEN)=0
 F  S SIEN=$O(^LEX(757.02,"AMC",+MC,SIEN)) Q:+SIEN'>0  S:"^30^31^"[("^"_$P($G(^LEX(757.02,+SIEN,0)),"^",3)_"^") X=1
 Q X
DXPT ;   Fix ICD-10 Diagnosis Preferred Terms
 N FIX,COMMIT S (FIX,COMMIT)=1 D T30^ZZLEXXRD
 Q
PRPT ;   Fix ICD-10 Procedures Preferred Terms
 N FIX,COMMIT S (FIX,COMMIT)=1 D T31^ZZLEXXRD
 Q
TM(X) ;   Trim Spaces
 S X=$G(X) Q:X="" X F  Q:$E(X,1)'=" "  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=" "  S X=$E(X,1,($L(X)-1))
 F  Q:X'["  "  S X=$P(X,"  ",1)_" "_$P(X,"  ",2,229)
 Q X
ENV(X) ;   Check environment
 N USR S DT=$$DT^XLFDT D HOME^%ZIS S U="^" I +($G(DUZ))=0 Q 0
 S USR=$$GET1^DIQ(200,(DUZ_","),.01) I '$L(USR) Q 0
 Q 1
