ZZLEXXDE ;SLC/KER - Import - ICD-10-CM Cat - Device ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^ZZLEXX(""ZZLEXXD"  SACC 1.3
 ;               
 ; External References
 ;    ^%ZIS               ICR  10086
 ;    HOME^%ZIS           ICR  10086
 ;    ^%ZISC              ICR  10089
 ;    $$DEL^%ZISH         ICR   2320
 ;    CLOSE^%ZISH         ICR   2320
 ;    OPEN^%ZISH          ICR   2320
 ;    $$OS^%ZOSV          ICR   3522
 ;    $$GET1^DIQ          ICR   2056
 ;    $$DT^XLFDT          ICR  10103
 ;    $$LOW^XLFSTR        ICR  10104
 ;    $$UP^XLFSTR         ICR  10104
 ;               
 ; Device
PATH(X,Y) ;   Path
 N UCI,SYS,PAT,PATH S UCI=$G(X) S:'$L(UCI) UCI=$$LOC S SYS=$G(Y)
 S:'$L(SYS) SYS=$$SYS S SYS=$E(SYS,1)
 S SYS=$$UP^XLFSTR(SYS),(PAT,UCI)=$$UP^XLFSTR(UCI) Q:'$L(UCI) ""  Q:'$L(SYS) ""  Q:"^U^V^"'[("^"_SYS_"^") ""
 S PATH="USER$:["_UCI_"]" S:SYS'="V" PATH="/home/"_$$LOW^XLFSTR(UCI)_"/" S:UCI="DEVCUR"&(PATH["[") PATH="VA5$:[BETA]"
 S X=PATH
 Q X
PIT(X)  ;   Path - Input Transform
 N TPATH,TFILE,TFSPEC,OUT,FILE,PATH,IOP S TPATH=$G(X),TFILE="ZZLEXXDA"_+($G(DUZ))_".DAT",TFSPEC=TPATH_TFILE
 D HOME^%ZIS S IOP="HFS",%ZIS("HFSNAME")=TFSPEC,%ZIS("HFSMODE")="W",%ZIS="0" D ^%ZIS S OUT=POP
 I OUT U:$L($G(IO(0))) IO(0) D ^%ZISC,HOME^%ZIS Q 0
 U IO W ! U:$L($G(IO(0))) IO(0) D ^%ZISC,HOME^%ZIS K FAR
 S PATH="" S:TPATH["]" PATH=$P(TPATH,"]",1)_"]",FILE=$P(TPATH,"]",2)
 S:TPATH["/" PATH=$P(TPATH,"/",1,($L(TPATH,"/")-1))_"/",FILE=$P(TPATH,"/",$L(TPATH,"/"))
 S FAR(TFILE)="",Y=$$DEL^%ZISH(TPATH,$NA(FAR)),X=1_"^"_Y K FAR
 D ^%ZISC,HOME^%ZIS K %ZIS
 Q X
HFN(X,Y) ;   Hostfile Name
 N SYS,TY,FY
 S SYS=$G(X),TY=$G(Y),FY=$G(^ZZLEXX("ZZLEXXD","CAT","CHG",DT)) S:FY?7N FY=+($E(FY,1,3))+1700 S:FY'?4N FY=+($E($$DT^XLFDT,1,3))+1700
 S X="ICD10"_SYS_TY_FY_".TXT"
 Q X
OPEN(X) ;   Open Device (write)
 N HFOK,HFP,HFN,HFH S HFP=$$PATH S HFN=$G(X) Q:'$L($G(HFN)) "0^Missing Hostfile Name"
 S HFH="ZZLEXXD8"_$G(HFN) D OPEN^%ZISH(HFH,HFP,HFN,"W")
 S HFOK=$G(POP) I HFOK D CLOSE Q ("0^Error opening"_HFN)
 I IO'[HFN D CLOSE Q ("0^Error opening Hostfile "_HFN)
 Q 1
CLOSE(X) ;   Close Device
 N HFH S HFH="ZZLEXXD8"_$G(X) D CLOSE^%ZISH(HFH)
 Q
SYS(X) ;   System
 S X="U" S:$$OS^%ZOSV'["UNIX" X="V"
 Q X
LOC(X) ;   Local Namespace
 X "S X=$ZNSPACE" Q X
ENV(X) ;   Environment
 D HOME^%ZIS S U="^",DT=$$DT^XLFDT,DTIME=300 K POP
 N NM S NM=$$GET1^DIQ(200,(DUZ_","),.01)
 I '$L(NM) W !!,?5,"Invalid/Missing DUZ" Q 0
 S:$G(DUZ(0))'["@" DUZ(0)=$G(DUZ(0))_"@"
 Q 1
