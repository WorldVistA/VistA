ZZLEXXHB ;SLC/KER - Import - Semantics (Misc) ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^LEX(757.01,        SACC 1.3
 ;    ^LEX(757.02,        SACC 1.3
 ;    ^LEX(757.1,         SACC 1.3
 ;    ^LEX(757.11,        SACC 1.3
 ;    ^LEX(757.12,        SACC 1.3
 ;    ^TMP("LEXFND")      SACC 2.3.2.5.1
 ;    ^TMP("LEXHIT")      SACC 2.3.2.5.1
 ;    ^TMP("LEXSCH")      SACC 2.3.2.5.1
 ;    ^ZZLEXX("ZZLEXXHB") SACC 1.3
 ;               
 ; External References
 ;    HOME^%ZIS           ICR  10086
 ;    ^%ZTLOAD            ICR  10063
 ;    ^DIC                ICR  10006
 ;    IX1^DIK             ICR  10013
 ;    $$GET1^DIQ          ICR   2056
 ;    LOOK^LEXA           N/A
 ;    CONFIG^LEXSET       N/A
 ;    $$DT^XLFDT          ICR  10103
 ;    $$UP^XLFSTR         ICR  10104
 ;    ^XMD                ICR  10070
 ;               
 Q
REC ; Semantic Class and Type Reclassification
 N I,ENV S ENV=$$ENV Q:+ENV'>0
 N MTO,ZTRTN,ZTDTH,ZTSAVE,ZTSK,ZTQUEUED,ZTREQ,COMMIT
 S ZTRTN="RECT^ZZLEXXHB",ZTDESC="Semantic Reclassification",ZTIO="",ZTDTH=$H
 S COMMIT=1,ZTSAVE("COMMIT")="" D:$D(TEST) @ZTRTN D:'$D(TEST) ^%ZTLOAD
 D HOME^%ZIS K Y,ZTSK,ZTDESC,ZTDTH,ZTIO,ZTRTN,TEST
 Q
RECT ; Semantic Class and Type Reclassification (tasked)
 K ^ZZLEXX("ZZLEXXHB",$J,"REC"),^ZZLEXX("ZZLEXXHB",$J,"MSG")
 N SIEN,OUT,RE K OUT S SIEN=0 F  S SIEN=$O(^LEX(757.02,"ASRC","SCT",SIEN)) Q:+SIEN'>0  D
 . N ABT,CODE,EI,ND,MC,OTH,SRC S ABT=0 S ND=$G(^LEX(757.02,+SIEN,0))
 . S SRC=$P(ND,"^",3) Q:+SRC'=56  S MC=$P(ND,"^",4) Q:+MC'>0
 . S OUT("TT")=+($G(OUT("TT")))+1 S OTH=$$OT(MC) S:OTH>0 OUT("OT")=+($G(OUT("OT")))+1 Q:+OTH>0
 . S CODE=$P(ND,"^",2) Q:'$L(CODE)
 . S ABT=$$EM(MC) S:+($G(ABT))>0 OUT("EM")=+($G(OUT("EM")))+1 Q:ABT>0
 . S ABT=$$HR(MC) S:+($G(ABT))>0 OUT("HR")=+($G(OUT("HR")))+1 Q:ABT>0
 . S ABT=$$FS(MC) S:+($G(ABT))>0 OUT("FS")=+($G(OUT("FS")))+1 Q:ABT>0
 . S ABT=$$LK(MC) S:+($G(ABT))>0 OUT("LK")=+($G(OUT("LK")))+1 Q:ABT>0
 . S EP=$G(^LEX(757.01,+ND,0))
 . S EI=0 F  S EI=$O(^LEX(757.01,"AMC",MC,EI)) Q:+EI'>0  D
 . . N EP Q:$P($G(^LEX(757.01,+EI,1)),"^",2)'=8  S EP=$G(^LEX(757.01,+EI,0))
 . S EI=+ND
 . W !,"CODE ",CODE,?22,"EX=",EI,"  ",EP
 S RE=+$G(OUT("EM"))+$G(OUT("HR"))+$G(OUT("FS"))+$G(OUT("LK"))
 S OUT("RE")=RE N TX D BL
 S TX=" Total Major Concepts:                      "_$J(+($G(OUT("TT"))),6) D TL($G(TX))
 S TX=" Total Major Concepts NOT Reclassified:     "_$J(+($G(OUT("OT"))),6) D TL($G(TX))
 S TX=" Total Major Concepts Reclassified:         "_$J(+($G(OUT("RE"))),6) D TL($G(TX)),BL
 I +RE>0 D
 . S:+($G(OUT("EM")))>0 TX="     Reclassified by Exact Match Lookup:    "_$J($G(OUT("EM")),6) D TL($G(TX))
 . S:+($G(OUT("HR")))>0 TX="     Reclassified by Hierarchy:             "_$J($G(OUT("HR")),6) D TL($G(TX))
 . S:+($G(OUT("FS")))>0 TX="     Reclassified by Fully Specified Term:  "_$J($G(OUT("FS")),6) D TL($G(TX))
 . S:+($G(OUT("LK")))>0 TX="     Reclassified by Lexicon Term Lookup:   "_$J($G(OUT("LK")),6) D TL($G(TX)),BL
 D SEND
 Q
EM(X) ;   Exact Match
 N MIEN,EIEN,SEM S SEM="",MIEN=+($G(X)) Q:+MIEN'>0 0
 S EIEN=0 F  S EIEN=$O(^LEX(757.01,"AMC",MIEN,EIEN)) Q:EIEN'>0  D
 . Q:$P($G(^LEX(757.01,+EIEN,1)),"^",2)=8
 . N TXT,UTXT,CTL,ORD S TXT=$P($G(^LEX(757.01,+EIEN,0)),"^",1),UTXT=$$UP^XLFSTR(TXT)
 . S CTL=$E(UTXT,1,63),ORD=$E(UTXT,1,62)_$C($A($E(UTXT,63))-1)_"~"
 . F  S ORD=$O(^LEX(757.01,"B",ORD)) Q:'$L(ORD)!(ORD'[CTL)  D
 . . N EX S EX=0 F  S EX=$O(^LEX(757.01,"B",ORD,EX)) Q:$L(SEM)  Q:+EX'>0  D  Q:$L(SEM)
 . . . Q:EX>6999999  Q:$$UP^XLFSTR($G(^LEX(757.01,+EX,0)))'=UTXT
 . . . N MC S MC=+($P($G(^LEX(757.01,+EX,1)),"^",1)) Q:$L(SEM)  Q:MC'>0  D  Q:$L(SEM)
 . . . . N SM S SM=0 F  S SM=$O(^LEX(757.1,"B",MC,SM)) Q:$L(SEM)  Q:+SM'>0  D  Q:$L(SEM)
 . . . . . N ND,TMP,SC,ST S ND=$G(^LEX(757.1,+SM,0)),TMP=$P(ND,"^",2,3)
 . . . . . S SC=$P(ND,"^",2),ST=$P(ND,"^",3)
 . . . . . Q:'$D(^LEX(757.11,+SC,0))  Q:'$D(^LEX(757.12,+ST,0))
 . . . . . S:TMP'="^10^71" SEM=TMP
 S X=0 I $P(SEM,"^",1)?1N.N,$P(SEM,"^",2)?1N.N,$L(SEM,"^")=2 D
 . N SC,ST,ND S SC=$P(SEM,"^",1),ST=$P(SEM,"^",2) Q:'$D(^LEX(757.11,+SC,0))  Q:'$D(^LEX(757.12,+ST,0))
 . S ND=MIEN_"^"_SC_"^"_ST,X=1 I $D(COMMIT) S DA=$O(^LEX(757.1," "),-1)+1,DIK="^LEX(757.1,",^LEX(757.1,DA,0)=ND D IX1^DIK W:'$D(ZTQUEUED) "+"
 Q X
HR(X) ;   Hierarchy
 N MIEN,EIEN,SEM S SEM="",MIEN=+($G(X)) Q:+MIEN'>0 0
 S EIEN=0 F  S EIEN=$O(^LEX(757.01,"AMC",MIEN,EIEN)) Q:$L(SEM)  Q:EIEN'>0  D  Q:$L(SEM)
 . Q:$P($G(^LEX(757.01,+EIEN,1)),"^",2)'=8
 . N CD,CI,HI,HR,SM,SC,ST
 . S CD=$O(^LEX(757.01,+EIEN,7,"C",56," "),-1) Q:'$L(CD)
 . S CI=$O(^LEX(757.01,+EIEN,7,"C",56,CD,""),-1) Q:+CI'>0
 . S HI=$P($G(^LEX(757.01,+EIEN,7,+CI,0)),"^",3)
 . S SM=$$IHCT^ZZLEXXHA(HI)
 . S SC=$P(SM,"^",2),ST=$P(SM,"^",3)
 . Q:'$D(^LEX(757.11,+SC,0))  Q:'$D(^LEX(757.12,+ST,0))
 . S SEM=$P(SM,"^",2,3)
 S X=0 I $P(SEM,"^",1)?1N.N,$P(SEM,"^",2)?1N.N,$L(SEM,"^")=2 D
 . N SC,ST,ND S SC=$P(SEM,"^",1),ST=$P(SEM,"^",2) Q:'$D(^LEX(757.11,+SC,0))  Q:'$D(^LEX(757.12,+ST,0))
 . S ND=MIEN_"^"_SC_"^"_ST,X=1 I $D(COMMIT) S DA=$O(^LEX(757.1," "),-1)+1,DIK="^LEX(757.1,",^LEX(757.1,DA,0)=ND D IX1^DIK W:'$D(ZTQUEUED) "+"
 Q X
FS(X) ;   Fully Specified
 N MIEN,EIEN,SEM S SEM="",MIEN=+($G(X)) Q:+MIEN'>0 0
 S EIEN=0 F  S EIEN=$O(^LEX(757.01,"AMC",MIEN,EIEN)) Q:$L(SEM)  Q:EIEN'>0  D  Q:$L(SEM)
 . Q:$P($G(^LEX(757.01,+EIEN,1)),"^",2)'=8
 . N EX,CD,CI,HI,HR,SM,SC,ST
 . S EX=$P($G(^LEX(757.01,+EIEN,0)),"^",1)
 . S HI=$P(EX,"(",$L(EX,")")) S HI=$P(HI,")",1)
 . S SM=$$IHCT^ZZLEXXHA(HI)
 . S SC=$P(SM,"^",2),ST=$P(SM,"^",3)
 . Q:'$D(^LEX(757.11,+SC,0))  Q:'$D(^LEX(757.12,+ST,0))
 . S SEM=$P(SM,"^",2,3)
 S X=0 I $P(SEM,"^",1)?1N.N,$P(SEM,"^",2)?1N.N,$L(SEM,"^")=2 D
 . N SC,ST,ND S SC=$P(SEM,"^",1),ST=$P(SEM,"^",2) Q:'$D(^LEX(757.11,+SC,0))  Q:'$D(^LEX(757.12,+ST,0))
 . S ND=MIEN_"^"_SC_"^"_ST,X=1 I $D(COMMIT) S DA=$O(^LEX(757.1," "),-1)+1,DIK="^LEX(757.1,",^LEX(757.1,DA,0)=ND D IX1^DIK W:'$D(ZTQUEUED) "+"
 Q X
LK(X) ;   Lookup
 N MIEN,EIEN,SEM,LEXVDT S SEM="",MIEN=+($G(X)) Q:+MIEN'>0 0
 S EIEN=0 F  S EIEN=$O(^LEX(757.01,"AMC",MIEN,EIEN)) Q:$L(SEM)  Q:EIEN'>0  D  Q:$L(SEM)
 . Q:$P($G(^LEX(757.01,+EIEN,1)),"^",2)=8
 . N EXP,UEXP,LEX,LEXI
 . S EXP=$G(^LEX(757.01,+EIEN,0)),UEXP=$$UP^XLFSTR(EXP)
 . S:UEXP["BRODMANN AREA" EXP="CEREBRAL CORTEX"
 . S:UEXP["CLINICAL STAGE I" EXP="BREAST CANCER STAGE"
 . S:UEXP["DEPRESSION"&(UEXP["SCREEN") EXP="DEPRESSION SCREENING"
 . S:UEXP["THERAPY" EXP="THERAPY"
 . S:UEXP["INFECT" EXP="INFECTED"
 . S:UEXP["SULFUR COLLOID" EXP="SULFUR COLLOID"
 . S:UEXP["ENDOSCOPY" EXP="ENDOSCOPY SURGICAL"
 . S:UEXP["PROSTATE" EXP="DISORDER PROSTATE"
 . S:UEXP["OCULAR COLOBOMA" EXP="OPTIC COLOBOMA"
 . S:UEXP["HOUSING UNSATISFACTORY" EXP="INADEQUATE HOUSING"
 . S:UEXP["CALYPTOSPORIDAE" EXP="PROTOZOA"
 . S:UEXP["EIMERIIDAE" EXP="APICOMPLEXA"
 . S:UEXP["AVULSION OF TOOTH" EXP="CRACKED TOOTH"
 . S:UEXP["LUXATION OF TOOTH" EXP="CRACKED TOOTH"
 . S:UEXP["CITRULLI" EXP="GRAM NEGATIVE BACTERIA"
 . S:UEXP["FLEXOR DIGITORUM" EXP="FLEXOR LEG"
 . S:UEXP["CRANIAL"&(UEXP["HEMORRHAGE") EXP="CRANIAL HEMORRHAGE"
 . S:UEXP["GLOMERULOPATHY" EXP="GLOMERULONEPHRITIS"
 . S:UEXP["LIGAMENT" EXP="LIGAMENT"
 . S:UEXP["DISEASE OF INFANT" EXP="DISEASE INFANT"
 . S:UEXP["APPEARANCE OF PATIENT" EXP="PATIENT EXAM"
 . S:UEXP["GENUS SUS" EXP="PIGS"
 . S:UEXP["COMPUTERIZED AXIAL" EXP="CAT SCAN"
 . S:UEXP["COMPUTED TOMOGRAPHY" EXP="CAT SCAN"
 . S:UEXP["ALLERGEN EXTRACT" EXP="ALLERGEN EXTRACT"
 . S:UEXP["OFFICINALE EXTRACT" EXP="ALLERGEN EXTRACT"
 . S:UEXP["MARIANUM EXTRACT" EXP="ALLERGEN EXTRACT"
 . S:UEXP["MENOPAUSE" EXP="MENOPAUSE"
 . S:UEXP["SINGLE PHOTON EMISSION COMPUTED TOMOGRAPHY" EXP="SPECT"
 . S:UEXP["ALLERGY" EXP="ALLERGY"
 . S:UEXP["CARCINOMA" EXP="CARCINOMA"
 . S:UEXP["ULCER" EXP="ULCER"
 . S:UEXP["CEREBROVASCULAR ACCIDENT" EXP="CEREBROVASCULAR ACCIDENT"
 . S:UEXP["NUTRITIONAL DEFICIENCY" EXP="NUTRITIONAL DEFICIENCY"
 . S:UEXP["ULTRASONOGRAPHY" EXP="ULTRASOUND"
 . K ^TMP("LEXSCH",$J),^TMP("LEXFND",$J),^TMP("LEXHIT",$J),LEX
 . D CONFIG^LEXSET("LEX","WRD",DT)
 . D LOOK^LEXA(EXP,"LEX",100,"WRD",DT,"","",1)
 . K ^TMP("LEXSCH",$J),^TMP("LEXFND",$J),^TMP("LEXHIT",$J)
 . N LEXI S LEXI=0 F  S LEXI=$O(LEX("LIST",LEXI)) Q:$L(SEM)  Q:+LEXI'>0  D  Q:$L(SEM)
 . . N LEXE,LEXET,LEXM,SIEN,ND
 . . S LEXE=+($G(LEX("LIST",LEXI))) Q:LEXE>6999999
 . . S LEXET=$G(^LEX(757.01,+LEXE,0))
 . . S LEXM=+($G(^LEX(757.01,+LEXE,1))) Q:+LEXM'>0
 . . S SIEN=0 F  S SIEN=$O(^LEX(757.1,"B",LEXM,SIEN)) Q:$L(SEM)  Q:+SIEN'>0  D  Q:$L(SEM)
 . . . N ND,TMP S ND=$G(^LEX(757.1,+SIEN,0)) S TMP=$P(ND,"^",2,3)
 . . . S:TMP'="^10^71" SEM=TMP
 . . . I $L(SEM) D
 . . . . Q  W !,LEXE,?8,LEXET,!,?8,EXP,!,?8,SEM
 S X=0 I $P(SEM,"^",1)?1N.N,$P(SEM,"^",2)?1N.N,$L(SEM,"^")=2 D
 . N SC,ST,ND S SC=$P(SEM,"^",1),ST=$P(SEM,"^",2) Q:'$D(^LEX(757.11,+SC,0))  Q:'$D(^LEX(757.12,+ST,0))
 . S ND=MIEN_"^"_SC_"^"_ST,X=1 I $D(COMMIT) S DA=$O(^LEX(757.1," "),-1)+1,DIK="^LEX(757.1,",^LEX(757.1,DA,0)=ND D IX1^DIK W:'$D(ZTQUEUED) "+"
 Q X
 ;
 ; Miscellaneous
OT(X) ;   Other than Physical Objects
 N MC S MC=+($G(X)) Q:MC'>0 0  S (X,MIEN)=0 F  S MIEN=$O(^LEX(757.1,"B",MC,MIEN)) Q:+MIEN'>0  D
 . N SEM S SEM=$G(^LEX(757.1,+MIEN,0))
 . S:SEM'[(MC_"^10^71") X=1
 Q X
PO ;   Physical Objects (Count)
 N BOTH,PHOB,OTHR,ALL,SIEN S (BOTH,PHOB,OTHR,ALL,SIEN)=0
 F  S SIEN=$O(^LEX(757.02,"ASRC","SCT",SIEN)) Q:+SIEN'>0  D
 . N CODE,OK,POI,OOI,MC,MIEN,OBJ S OBJ="^10^71" S SRC=$P($G(^LEX(757.02,+SIEN,0)),"^",3) Q:+SRC'=56
 . S MC=$P($G(^LEX(757.02,+SIEN,0)),"^",4) Q:+MC'>0  S CODE=$P($G(^LEX(757.02,+SIEN,0)),"^",2) Q:'$L(CODE)
 . S (OOI,POI)=0,MIEN=0 F  S MIEN=$O(^LEX(757.1,"B",MC,MIEN)) Q:+MIEN'>0  D
 . . N SEM S SEM=$G(^LEX(757.1,+MIEN,0)) S:SEM'[(MC_OBJ) OOI=1 s:SEM[(MC_OBJ) POI=1
 . S ALL=ALL+1 S:OOI>0&(POI>0) BOTH=BOTH+1 S:OOI>0&(POI'>0) OTHR=OTHR+1 S:OOI'>0&(POI>0) PHOB=PHOB+1
 . I OOI'>0&(POI>0) D
 . . N DEA,OK S (DEA,OK)=0 W:$D(TEST) !,CODE,?15 N EIEN S EIEN=0 F  S EIEN=$O(^LEX(757.01,"AMC",MC,EIEN)) Q:+EIEN'>0  D
 . . . Q:$P($G(^LEX(757.01,+EIEN,1)),"^",2)'=8  I $P($G(^LEX(757.01,+EIEN,1)),"^",5)>0 S DEA=1 Q
 . . . W:$D(TEST) $G(^LEX(757.01,+EIEN,0)) S OK=1
 . . I DEA>0,'OK W:$D(TEST) "De-Active"
 W !!," Both Physical Objects and Other:  ",$J(BOTH,6) W !," Physical Objects Only:            ",$J(PHOB,6)
 W !," Other Semantics Only:             ",$J(OTHR,6) W !," All Semantics:                    ",$J(ALL,6),!
 Q
TM(X,Y) ;   Trim Character Y - Default " " Space
 S X=$G(X) Q:X="" X  S Y=$G(Y) S:'$L(Y) Y=" "
 F  Q:$E(X,1)'=Y  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=Y  S X=$E(X,1,($L(X)-1))
 Q X
BL ;   Blank Line
 D TL("  ")
 Q
TL(X) ;   Text Line
 W:'$D(ZTQUEUED) !,$G(X) N C S C=$O(^ZZLEXX("ZZLEXXHB",$J,"REC"," "),-1)+1
 S ^ZZLEXX("ZZLEXXHB",$J,"REC",C)=$G(X)
 Q
SEND ;   Send
 K XMZ,^ZZLEXX("ZZLEXXHB",$J,"MSG") N DIFROM,I,USER S U="^" S XMSUB="Semantic Class/Type Reclassification"
 S I=0 F  S I=$O(^ZZLEXX("ZZLEXXHB",$J,"REC",I)) Q:+I'>0  D
 . N TX S TX=$E($G(^ZZLEXX("ZZLEXXHB",$J,"REC",I)),1,78) Q:'$L(TX)  S ^ZZLEXX("ZZLEXXHB",$J,"MSG",I)=TX
 S USER=$$NAM S:$L(USER) XMY(USER)="" S XMY("G.LEXICON@DNS    .DOMAIN")=""
 S XMTEXT="^ZZLEXX(""ZZLEXXHB"","_$J_",""MSG"","
 S XMDUZ=.5 D ^XMD K ^ZZLEXX("ZZLEXXHB",$J,"REC"),^ZZLEXX("ZZLEXXHB",$J,"MSG")
 K %,%Z,XCNP,XMSCR,XMDUZ,XMY,XMZ,XMSUB,XMY,XMTEXT,XMDUZ
 Q
NAM(X) ;   User Name
 Q $$GET1^DIQ(200,(+($G(DUZ))_","),.01)
UOK(X) ;   User Found
 N DIC,DTOUT,DUOUT,Y S X=$G(X) Q:'$L(X) -1  S DIC=200,DIC(0)="XB" D ^DIC S X=$S(+($G(Y))>0:1,1:0)
 Q X
SH(X) ;   Show Results
 N ENV S ENV=$$ENV Q:+ENV'>0  W:$L($G(IOF)) @IOF N I
 S I=0 F  S I=$O(^ZZLEXX("ZZLEXXHB",$J,"REC",I)) Q:+I'>0  D
 . W !,$G(^ZZLEXX("ZZLEXXHB",$J,"REC",I))
 W !
 Q
ENV(X) ;   Environment
 D HOME^%ZIS S U="^",DT=$$DT^XLFDT,DTIME=300 K POP
 N NM S NM=$$GET1^DIQ(200,(DUZ_","),.01)
 I '$L(NM) W !!,?5,"Invalid/Missing DUZ" Q 0
 S:$G(DUZ(0))'["@" DUZ(0)=$G(DUZ(0))_"@"
 N ALL,DA,DIK,EDIT,FULL,TEXT,TOT
 Q 1
