ZZLEXXEM ;SLC/KER - Import - ICD-10-PCS Frag - Misc ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^LEX(757.02         SACC 1.3
 ;    ^XTMP(              SACC 2.3.2.5.2
 ;    ^ZZLEXX("ZZLEXXE"   SACC 1.3
 ;    ^ZZLEXX("ZZLEXXEM"  SACC 1.3
 ;               
 ; External References
 ;    ^%ZIS               ICR  10086
 ;    HOME^%ZIS           ICR  10086
 ;    ^%ZISC              ICR  10089
 ;    $$DEL^%ZISH         ICR   2320
 ;    $$LIST^%ZISH        ICR   2320
 ;    CLOSE^%ZISH         ICR   2320
 ;    OPEN^%ZISH          ICR   2320
 ;    $$OS^%ZOSV          ICR   3522
 ;    $$GET1^DIQ          ICR   2056
 ;    ^DIR                ICR  10026
 ;    $$DT^XLFDT          ICR  10103
 ;    $$FMADD^XLFDT       ICR  10103
 ;    $$FMTE^XLFDT        ICR  10103
 ;    $$HTFM^XLFDT        ICR  10103
 ;    $$UP^XLFSTR         ICR  10103
 ;               
PCST(X) ; ICD-10-PCS Procedure Tabular
 K ^ZZLEXX("ZZLEXXEM",$J) N PATH,NOT,HAS,HFV S HFV=$G(^ZZLEXX("ZZLEXXE","PCS","DT","VER"))
 S HAS="PCS;TAB" S:$D(CUR)&(HFV?4N) HAS=HAS_";"_HFV N CUR
 S NOT="ADDENDA",PATH=$$PATH D DIR(PATH,NOT,HAS) S X=$$SEL K ^ZZLEXX("ZZLEXXEM",$J) W !
 Q X
PCSD(X) ; ICD-10-PCS Procedure Descriptions
 K ^ZZLEXX("ZZLEXXEM",$J) N PATH,NOT,HAS,HFV S HFV=$G(^ZZLEXX("ZZLEXXE","PCS","DT","VER"))
 S HAS="PCS;DEF" S:$D(CUR)&(HFV?4N) HAS=HAS_";"_HFV N CUR
 S NOT="ADDENDA",PATH=$$PATH D DIR(PATH,NOT,HAS) S X=$$SEL K ^ZZLEXX("ZZLEXXEM",$J) W !
 Q X
 ;
DIR(X,N,H) ; Get Directory Listing
 N ASIZE,BYTE,CNT,CON,CRE,CT,EDT,FDTS,FI,FILESPEC,FN,FULL
 N HAS,HDR,I,ID,NOT,OK,PATH,SCREEN,SEG,SIZE,MIS,TXT,UFN,Y
 N FILFY,LEXFY K ^ZZLEXX("ZZLEXXEM",$J,"DEVICE")
 S PATH=$G(X) Q:'$L(PATH)  S NOT=$G(N),HAS=$G(H) S FILESPEC=""
 S SCREEN("*.TXT")="",SCREEN("*.txt")=""
 S Y=$$LIST^%ZISH(PATH,"SCREEN",("^ZZLEXX(""ZZLEXXEM"",$J,""DEVICE"",""TEMP"")"))
 S HDR="File Name"_$J(" ",29)_"Effective Date"_$J(" ",6)_" Bytes"
 S HDR="File Name"_$J(" ",34)_"Date"_$J(" ",11)_" Bytes"
 S CT=0,FN="" F  S FN=$O(^ZZLEXX("ZZLEXXEM",$J,"DEVICE","TEMP",FN)) Q:'$L(FN)  D
 . N ASIZE,BYTE,CRE,CNT,CON,EDT,EFFD,FDTS,FI,I,OK,SEG,SIZE,TDT,TXT,UFN
 . S OK=1 I $L($G(NOT)) D
 . . N UFN,I S UFN=$$UP^XLFSTR(FN),CON=0 F I=1:1 Q:'$L($P(NOT,";",I))  S:UFN[$P(NOT,";",I) OK=0
 . Q:'OK  S OK=1 I $L($G(HAS)) D
 . . N CON,CNT,UFN,SEG,I S UFN=$$UP^XLFSTR(FN),CON=0,CNT=0
 . . F I=1:1 S SEG=$P(HAS,";",I) Q:'$L(SEG)  S CNT=CNT+1 S:UFN[SEG CON=CON+1
 . . S:CNT>0&(CON'=CNT) OK=0
 . Q:'OK  S FULL=FN S:$L(PATH) FULL=PATH_FN
 . S FDTS=$$FDTS(FULL) Q:+FDTS'>0
 . S CRE=$P(FDTS,"^",1),(TDT,EDT)=$P(FDTS,"^",2)
 . S SIZE=$P(FDTS,"^",3),ASIZE=$$CS(SIZE)
 . S BYTE=$J(" ",(11-$L(SIZE)))_SIZE
 . S FI=FN S:FN[";" FI=$P(FN,";",1) S ID=FI S:ID["." ID=$P(ID,".",1)
 . S EFFD=$$DEFF(FI)
 . S FILFY=$P($$FY(FI),"^",1)
 . S LEXFY=$P($$TI(FI),"^",1)
 . Q:+FILFY<+LEXFY
 . Q:$D(^ZZLEXX("ZZLEXXEM",$J,"DEVICE","DIR","B",FI))
 . S TDT=$P(TDT," ",1)
 . S CT=CT+1,TXT=FI
 . S:$P(EFFD,"^",1)?7N&($L($P(EFFD,"^",2))) HDR="File Name"_$J(" ",29)_"Effective Date"_$J(" ",6)_" Bytes"
 . S:$P(EFFD,"^",1)?7N&($L($P(EFFD,"^",2))) TXT=TXT_$J(" ",(40-$L(TXT)))_$P(EFFD,"^",2)
 . S:$P(EFFD,"^",1)'?7N!('$L($P(EFFD,"^",2))) TXT=TXT_$J(" ",(40-$L(TXT)))_TDT
 . S TXT=TXT_$J(" ",(13-$L(TDT)))_BYTE
 . S TDT=CRE
 . S ^ZZLEXX("ZZLEXXEM",$J,"DEVICE","DIR",CT)=TXT
 . S ^ZZLEXX("ZZLEXXEM",$J,"DEVICE","DIR",CT,"NAME")=FI
 . S ^ZZLEXX("ZZLEXXEM",$J,"DEVICE","DIR",CT,"SIZE")=SIZE
 . S ^ZZLEXX("ZZLEXXEM",$J,"DEVICE","DIR",CT,"ASIZ")=ASIZE
 . S ^ZZLEXX("ZZLEXXEM",$J,"DEVICE","DIR",CT,"BYTE")=BYTE
 . S ^ZZLEXX("ZZLEXXEM",$J,"DEVICE","DIR",CT,"DATE")=CRE
 . S ^ZZLEXX("ZZLEXXEM",$J,"DEVICE","DIR",CT,"EDAT")=EDT
 . S ^ZZLEXX("ZZLEXXEM",$J,"DEVICE","DIR",CT,"EFFD")=EFFD
 . S ^ZZLEXX("ZZLEXXEM",$J,"DEVICE","DIR",0)=CT
 . S ^ZZLEXX("ZZLEXXEM",$J,"DEVICE","DIR","B",FI,CT)=""
 . S ^ZZLEXX("ZZLEXXEM",$J,"DEVICE","DIR","C",FN,CT)=""
 S ^ZZLEXX("ZZLEXXEM",$J,"DEVICE","DIR","H")=HDR
 K ^ZZLEXX("ZZLEXXEM",$J,"TEMP")
 Q
 ;
 ; Select from Directory Listing
SEL(X) ;   Select Hostfile
 N SEL,FND,Y S FND=+($G(^ZZLEXX("ZZLEXXEM",$J,"DEVICE","DIR",0))) Q:+FND'>0 "-1^No hostfiles found/available"
 S:+FND=1 SEL=$$ONE S:+FND>1 SEL=$$MUL S X=$S(SEL>0:("1^"_$G(^ZZLEXX("ZZLEXXEM",$J,"DEVICE","DIR",+SEL,"NAME"))),1:"-1^Hostfile selection not made")
 Q X
ONE(X) ;   One Entry Found
 N Y,DIR,DIRUT,DTOUT,DUOUT,DIROUT,MAX,Y S MAX=+($G(^ZZLEXX("ZZLEXXEM",$J,"DEVICE","DIR",0))) Q:MAX'=1 "-1^No selection available"
 S DIR("A",1)=("  "_$G(^ZZLEXX("ZZLEXXEM",$J,"DEVICE","DIR","H"))),DIR("A",2)=("  "_$G(^ZZLEXX("ZZLEXXEM",$J,"DEVICE","DIR",1)))
 S DIR("A",3)=" ",DIR("A")="     Ok?  (Y/N)  ",DIR("B")="Yes",DIR(0)="YAO",(DIR("?"),DIR("??"))="^D ONEH^ZZLEXXEM"
 W ! D ^DIR S X=$S(+Y>0:1,1:0)
 Q X
ONEH ;   One Entry Found Help
 W !,?7,"Answer ""Yes"" to select this hostfile or ""No"" or ""^""",!,?7,"to exit without making a selection"
 Q
MUL(X) ;   Multiple Entries Found
 N EXIT,IEN,LAST,SEL,MAX,HDR,Y
 S MAX=$G(^ZZLEXX("ZZLEXXEM",$J,"DEVICE","DIR",0)) Q:MAX'>1 "-1^No selection available"
 S HDR="        "_$G(^ZZLEXX("ZZLEXXEM",$J,"DEVICE","DIR","H")) W !!," ",MAX," hostfiles found",!
 S SEL="",(LAST,EXIT,IEN)=0
 F  S IEN=$O(^ZZLEXX("ZZLEXXEM",$J,"DEVICE","DIR",IEN)) Q:+IEN'>0!(+EXIT>0)  D  Q:+EXIT>0  Q:+SEL>0
 . N ENT,LEXT,LEXO S ENT=$G(^ZZLEXX("ZZLEXXEM",$J,"DEVICE","DIR",IEN)),LAST=IEN
 . W:IEN#5=1 !,HDR W !," ",$J(IEN,4),".  ",ENT W:IEN#5=0 ! S:IEN#5=0 SEL=$$MULS(LAST)
 . S:SEL="^" EXIT=1
 I LAST#5'=0,+SEL'>0 W ! S SEL=$$MULS(LAST) S:SEL="^" EXIT=1
 S X="^" S:'EXIT&(+SEL>0) X=SEL S:+X'>0 X="^"
 Q X
MULS(X) ;     Multiple
 N DIR,DIROUT,DIRUT,DTOUT,DUOUT,MAX,LAST,Y S MAX=$G(^ZZLEXX("ZZLEXXEM",$J,"DEVICE","DIR",0)) Q:MAX'>1 "-1^No selection available"
 S LAST=+($G(X)) S:LAST>0 DIR("A")=" Select 1-"_LAST_" or '^' to exit:  "
 S (DIR("?"),DIR("??"))="Answer must be from 1 to "_LAST_", or <Return> to continue  "
 S DIR(0)="NAO^1:"_LAST_":0" D ^DIR Q:X="" X  S:$D(DTOUT)!($D(DUOUT))!($D(DIRUT))!($D(DIROUT)) X="^" Q:X="^" "^"
 I +Y>0,+Y'>LAST S X=+Y Q X
 Q -1
 ;
EFF(X) ; Effective Date
 N DIR,DIRB,DIROUT,DIRUT,DTOUT,DUOUT,MIN,MAX,NOW,LAT,DIRB,IN,Y
 S IN=$G(X) I IN?7N S IN=(+($E(IN,1,3))+1700)
 S MIN=2015,(NOW,MAX)=$$DT^XLFDT,(LAT,MAX)=$$FMADD^XLFDT(MAX,365),MAX=$E(MAX,1,3),MAX=MAX+1700
 S:IN?4N&(IN<MIN) MIN=IN S DIRB=NOW S:$E(DIRB,4,5)>8 DIRB=LAT I DIRB?7N S DIRB=(+($E(DIRB,1,3))+1700)
 S:DIRB?4N DIR("B")=DIRB S:IN?4N DIR("B")=IN S DIR(0)="NAO^"_MIN_":"_MAX_":0"
 S DIR("A")=" Enter the fiscal year of the ICD-10 update:  "
 S (DIR("?"),DIR("??"))="^D EFFH^ZZLEXXEM"
 D ^DIR S:$D(DTOUT)!($D(DUOUT))!($D(DIROUT))!(Y'?4N) X="^"
 Q:X="^" "^"  S X=Y S:X?4N X=(X-1700)_"1001"
 Q X
EFFH ;   Effective Date Help
 I $G(MIN)?4N,$G(MAX)?4N,MIN'=MAX D  Q
 . W !,"    Enter a fiscal year from ",MIN," to ",MAX,".  This is the fiscal year"
 . W !,"    that the ICD-10 character position updates are effective."
 W !,"    Enter the fiscal year that the ICD-10 character position updates"
 W !,"    are effective."
 Q
DEFF(X) ; Default Effective Date
 N DEF,TD,YR S TD=$$DT^XLFDT,YR=$$UP^XLFSTR($G(X)) I YR'?4N D
 . S YR=$P(YR,".TXT",1),YR=$E(YR,($L(YR)-3),$L(YR)) S:YR?4N YR=YR-1
 S DEF="" S:YR?4N DEF=(YR-1700)_"1001"
 S X="" S:DEF?7N X=DEF_"^"_$$FMTE^XLFDT(DEF,"5Z")
 Q X
 ;
 ; Miscellaneous
OPEN(X,Y,Z) ;   Open Device
 N HFOK,HFP,HFN,HFH S HFP=$G(X)
 Q:'$L($G(HFP)) "0^Missing Hostfile Path"
 S HFN=$G(Y) Q:'$L($G(HFN)) "0^Missing Hostfile Name"
 S HFH="ZZLEXXE"_$G(Z)
 D OPEN^%ZISH(HFH,HFP,HFN,"R")
 S HFOK=$G(POP) I HFOK D CLOSE Q ("0^Error opening"_HFN)
 I IO'[HFN D CLOSE Q ("0^Error opening Hostfile "_HFN)
 Q 1
OPENW(X,Y) ;   Open Device
 N HFOK,HFP,HFN,HFH S HFP=$$PATH S HFN=$G(Y) Q:'$L($G(HFN)) "0^Missing Hostfile Name"
 S HFH="ZZLEXXE"_$G(Y) D OPEN^%ZISH(HFH,HFP,HFN,"W")
 S HFOK=$G(POP) I HFOK D CLOSE Q ("0^Error opening"_HFN)
 I IO'[HFN D CLOSE Q ("0^Error opening Hostfile "_HFN)
 Q 1
CLOSE(X) ;   Close Device
 N HFH S HFH="ZZLEXXE"_$G(X) D CLOSE^%ZISH(HFH)
 Q
PIT(X)  ;   Path - Input Transform
 N TPATH,TFILE,TFSPEC,OUT,FILE,PATH,IOP S TPATH=$G(X),TFILE="ZZLEXXEM"_+($G(DUZ))_".DAT",TFSPEC=TPATH_TFILE
 D HOME^%ZIS S IOP="HFS",%ZIS("HFSNAME")=TFSPEC,%ZIS("HFSMODE")="W",%ZIS="0" D ^%ZIS S OUT=POP
 I OUT U:$L($G(IO(0))) IO(0) D ^%ZISC,HOME^%ZIS Q 0
 U IO W ! U:$L($G(IO(0))) IO(0) D ^%ZISC,HOME^%ZIS K FAR
 S PATH="" S:TPATH["]" PATH=$P(TPATH,"]",1)_"]",FILE=$P(TPATH,"]",2)
 S:TPATH["/" PATH=$P(TPATH,"/",1,($L(TPATH,"/")-1))_"/",FILE=$P(TPATH,"/",$L(TPATH,"/"))
 S FAR(TFILE)="",Y=$$DEL^%ZISH(TPATH,$NA(FAR)),X=1_"^"_Y K FAR
 D ^%ZISC,HOME^%ZIS K %ZIS
 Q X
FIT(X)  ;   Hostfile - Input Transform
 N TFSPEC,OUT,IOP S TFSPEC=$G(X)
 D HOME^%ZIS S IOP="HFS",%ZIS("HFSNAME")=TFSPEC,%ZIS("HFSMODE")="R",%ZIS="0" D ^%ZIS S OUT=POP
 I OUT U:$L($G(IO(0))) IO(0) D ^%ZISC,HOME^%ZIS Q 0
 U IO U:$L($G(IO(0))) IO(0) D ^%ZISC,HOME^%ZIS S X=1_"^"_TFSPEC
 D ^%ZISC,HOME^%ZIS K %ZIS
 Q X
PATH(X,Y) ;   Path
 N UCI,SYS,PAT,PATH S UCI=$G(X) S:'$L(UCI) UCI=$$LOC S SYS=$G(Y)
 S:'$L(SYS) SYS=$$SYS S SYS=$E(SYS,1)
 S SYS=$$UP^XLFSTR(SYS),(PAT,UCI)=$$UP^XLFSTR(UCI) Q:'$L(UCI) ""  Q:'$L(SYS) ""  Q:"^U^V^"'[("^"_SYS_"^") ""
 S PATH="USER$:["_UCI_"]" S:SYS'="V" PATH="/home/sftp/patches/" S:UCI="DEVCUR"&(PATH["[") PATH="VA5$:[BETA]"
 S X=PATH
 Q X
SYS(X) ;   System
 S X="U" S:$$OS^%ZOSV'["UNIX" X="V"
 Q X
LOC(X) ;   Local Namespace
 X "S X=$ZNSPACE" Q X
HFD(X) ;   Hostfile Date
 N ORG,OUT,PSN,MIS,STR,CT,RES S ORG=$G(X) Q:'$D(X) ""  S CT=0,MIS="" F PSN=1:1:$L(ORG)  D
 . S:$E(ORG,PSN)?1N MIS=MIS_$E(ORG,PSN) Q:$E(ORG,PSN)?1N  I $E(ORG,PSN)'?1N I $L(MIS) S CT=CT+1,STR(CT)=MIS,MIS=""
 S (PSN,CT)=0 F  S PSN=$O(STR(PSN)) Q:PSN'>0  I $G(STR(PSN))?4N S CT=CT+1,RES(CT)=$G(STR(PSN)),RES(0)=CT
 S (OUT,X)="" I RES(0)=1 S OUT=$G(RES(1)) S:OUT?4N OUT=((OUT-1701)_"1001")
 S:OUT?7N X=OUT
 Q X
CTC(X) ;   Control Characters
 S X=$G(X) N Y,P S Y="" F P=1:1:$L(X)  D
 . N C,A S C=$E(X,P),A=$A(C) Q:A<32  Q:A>126  Q:A=63  S Y=Y_C
 S X=Y
 Q X
CS(X) ;   Condensed Size
 N ID S ID="" S X=+($G(X)) Q:X'>0 "" S:X'>1024 X=X,ID=" B "
 S:X>1024 X=(X/1024),ID=" KB" S:X>1000 X=(X/1000),ID=" MB" S:X>1000 X=(X/1000),ID=" GB"
 S:ID=" B " X=X_ID S:ID'=" B " X=$FN(X,"",1)_ID
 S:$L(X) X=$J(" ",(10-$L(X)))_X
 Q X
FDTS(X) ;   File Dates and Size
 N FOUT,FIL1,FIL2,FIL3,EDAT,IDAT,FDAT,FDES,FSYS,I,FOPEN,FEX,ST,TYPE,SIZE,CRE,MOD,ERR,PATH,FN
 S FOUT=$G(X),SIZE=0 Q:'$L(FOUT) -1  S PATH=""
 S:FOUT["]" PATH=$P(FOUT,"]",1)_"]"
 S:FOUT["/" PATH=$P(FOUT,"/",1,($L(FOUT,"/")-1))_"/"
 S FN=FOUT S:$L(PATH)&(FN[PATH) FN=$P(FN,PATH,2)
 S FEX="S SIZE=$ZU(140,1,FOUT)" X FEX
 S FEX="S MOD=$ZU(140,2,FOUT)" X FEX
 S FEX="S CRE=$ZU(140,3,FOUT)" X FEX
 S SIZE=$G(SIZE) Q:SIZE'>0 "-1^No Data in file"
 S MOD=$G(MOD) S:+MOD>0 MOD=$$HTFM^XLFDT(MOD) S:$P(MOD,".",1)'?7N MOD=""
 S CRE=$G(CRE) S:+CRE>0 CRE=$$HTFM^XLFDT(CRE) S:$P(CRE,".",1)'?7N CRE=""
 S X=CRE_"^"_$$ED(CRE)_"^"_SIZE
 Q X
ED(X) ;   External Date
 S X=$G(X) Q:$P(X,".",1)'?7N ""
 S X=$$FMTE^XLFDT(X,"5ZM") S:X["@" X=$P(X,"@",1)_"  "_$P(X,"@",2)
 Q X
SHOD ;   Show Directory
 N NN,NC S NN="^ZZLEXX(""ZZLEXXEM"","_$J_",""DEVICE"",""DIR"")",NC="^ZZLEXX(""ZZLEXXEM"","_$J_",""DEVICE"",""DIR"","
 F  S NN=$Q(@NN) Q:'$L(NN)!(NN'[NC)  W !,NN,"=",@NN
 Q
PS(X) ;   Page/Scroll
 K LNCT N DIR,DIRB,DIROUT,DIRUT,DTOUT,DUOUT,MIN,MAX,NOW,LAT,DIRB,IN,TX
 S DIRB=$$RET("PS^ZZLEXXEM",DUZ,"Page/Scroll") S:$L(DIRB) DIR("B")=DIRB
 S DIR(0)="SAO^P:Page;S:Scroll"
 S DIR("A")=" Display output by Page or Scroll (P/S):  "
 S (DIR("?"),DIR("??"))="^D PSH^ZZLEXXEM"
 D ^DIR S:$D(DTOUT)!($D(DUOUT))!($D(DIROUT))!(Y'?4N) X="^"
 S X=$E($$UP^XLFSTR(Y),1) S:X="P" LNCT=""
 S TX="" S:Y="P" TX="Page" S:Y="S" TX="Scroll"
 D:$L(TX) SAV("PS^ZZLEXXEM",DUZ,"Page/Scroll",TX)
 Q X
PSH(X) ;   Page/Scroll Help
 W !,"    Enter 'P' to display the output one page at a time"
 W !,"       or 'S' to display the output continuously (scroll)."
 Q
SAV(X,N,C,V) ;   Save Defaults
 N RTN,TAG,REF,USR,COM,VAL,NAME,ID,NOW,FUT,KEY S REF=$G(X),RTN=$P(REF,"^",2),TAG=$P(REF,"^",1),USR=+($G(N)),VAL=$G(V),COM=$G(C)
 Q:'$L($T(@REF))  Q:+USR'>0  Q:'$L(VAL)  Q:'$L(COM)  S NAME=$$GET1^DIQ(200,(USR_","),.01) Q:'$L(NAME)
 S KEY=$E(COM,1,13) S:$L(KEY)'>11 KEY=KEY_$J(" ",12-$L(KEY)) S NOW=$$DT^XLFDT,FUT=$$FMADD^XLFDT(NOW,30),ID=RTN_" "_USR_" "_KEY
 S ^XTMP(ID,0)=FUT_"^"_NOW_"^"_COM,^XTMP(ID,TAG)=VAL
 Q
RET(X,N,C) ;   Retrieve Defaults
 N RTN,TAG,REF,USR,COM,VAL,NAME,ID,NOW,FUT,KEY S REF=$G(X),RTN=$P(REF,"^",2),TAG=$P(REF,"^",1),USR=+($G(N)),COM=$G(C)
 Q:'$L($T(@REF)) ""  Q:+USR'>0 ""  Q:'$L(COM) ""  S NAME=$$GET1^DIQ(200,(USR_","),.01) Q:'$L(NAME) ""
 S KEY=$E(COM,1,13) S:$L(KEY)'>11 KEY=KEY_$J(" ",12-$L(KEY)) S ID=RTN_" "_USR_" "_KEY
 S X=$G(^XTMP(ID,TAG))
 Q X
DIS(X) ;   Display Summary or Details
 N DIR,DIROUT,DIRUT,DUOUT,DTOUT,Y,ARY,MIN,MAX,CT,I Q:'$D(^ZZLEXX("ZZLEXXE")) "^"
 S CT=0 I $D(^ZZLEXX("ZZLEXXE","PCS","CHG")) D
 . S CT=CT+1 S ARY(CT)="SUM^ZZLEXXEJ",ARY(CT,1)="Summary of Changes"
 . S CT=CT+1 S ARY(CT)="CHG^ZZLEXXEJ",ARY(CT,1)="Detail Listing of Changes"
 I $D(^ZZLEXX("ZZLEXXE","PCS","CHG","WARN")) D
 . S CT=CT+1 S ARY(CT)="WARN^ZZLEXXEK",ARY(CT,1)="Warnings"
 I $D(^ZZLEXX("ZZLEXXE","PCS","LOAD")) D
 . S CT=CT+1 S ARY(CT)="LOAD^ZZLEXXEJ",ARY(CT,1)="Changes Loaded"
 I $D(^ZZLEXX("ZZLEXXE","PCS","DT")) D
 . S CT=CT+1 S ARY(CT)="UPD^ZZLEXXEJ",ARY(CT,1)="Progress of Read/Load"
 S MIN=$O(ARY(0)),MAX=$O(ARY(" "),-1) Q:MIN'>0 "^" Q:MIN=MAX $G(ARY(MIN))
 S DIR("A",1)=" Display:",DIR("A",2)=" ",CT=2,I=0 F  S I=$O(ARY(I)) Q:+I'>0  D
 . N TX S TX=$G(ARY(I,1)),CT=CT+1,DIR("A",CT)=("  "_$J(I,2)_"  "_TX)
 S CT=CT+1,DIR("A",CT)=" ",DIR(0)="NAO^"_MIN_":"_MAX_":0",DIR("A")=" Select display:  "
 D ^DIR I +Y>0,$D(ARY(+Y)) S X=$G(ARY(+Y)) Q X
 Q "^"
FY(X) ;   File Fiscal Year and Date
 N HF,FY,FD S HF=$$UP^XLFSTR($G(X)) S X="" Q:'$L(HF) X  S FY=$P(HF,".",1),FY=$E(FY,($L(FY)-3),$L(FY)) Q:FY'?4N X
 S FD=((FY-1)-1700)_"1001" Q:FD'?7N X  S X=FY_"^"_FD
 Q X
TI(X) ;   Terminology Fiscal Year and Date
 N FY,IN,HF,SAB,LAST S HF=$$UP^XLFSTR($G(X)) S (X,SAB)="" S SAB="10P"
 S LAST=9999999 F  S LAST=$O(^LEX(757.02,"AUPD",SAB,LAST),-1) Q:+LAST'>0  Q:$E(LAST,4,7)="1001"
 Q:LAST'?7N X  S FY=$E(LAST,1,3) Q:FY'?3N X  S FY=(FY+1700)+1 S X=FY_"^"_LAST
 Q X
LR(X) ;   Local Routine
 S X=$T(+1),X=$P(X," ",1)
 Q X
