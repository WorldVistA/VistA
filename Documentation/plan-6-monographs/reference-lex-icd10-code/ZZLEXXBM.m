ZZLEXXBM ;SLC/KER - Import - ICD-10-PCS - Host File ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^LEX(757.02         SACC 1.3
 ;    ^UTILITY($J         ICR  10011
 ;    ^ZZLEXX("ZZLEXXBM"  SACC 1.3
 ;               
 ; External References
 ;    ^%ZIS               ICR  10086
 ;    HOME^%ZIS           ICR  10086
 ;    ^%ZISC              ICR  10089
 ;    $$DEL^%ZISH         ICR   2320
 ;    $$LIST^%ZISH        ICR   2320
 ;    $$STATUS^%ZISH      ICR   2320
 ;    CLOSE^%ZISH         ICR   2320
 ;    OPEN^%ZISH          ICR   2320
 ;    ENDR^%ZISS          ICR  10088
 ;    KILL^%ZISS          ICR  10088
 ;    $$OS^%ZOSV          ICR   3522
 ;    ^DIR                ICR  10026
 ;    ^DIWP               ICR  10011
 ;    $$FMTE^XLFDT        ICR  10103
 ;    $$HTFM^XLFDT        ICR  10103
 ;    $$UP^XLFSTR         ICR  10104
 ;               
DIR(X,N,H,S) ; Host File Directory
 N ASIZE,BYTE,CNT,CON,CRE,CT,EDT,FDTS,FI,FILESPEC,FN,FULL
 N HAS,HDR,I,ID,NOT,OK,PATH,SCREEN,SEG,SIZE,TEMP,TXT,UFN,Y
 K ^ZZLEXX("ZZLEXXBM",$J,"DEVICE","DIR"),^ZZLEXX("ZZLEXXBM",$J,"DEVICE","TEMP")
 S PATH=$G(X) Q:'$L(PATH)  S NOT=$$UP^XLFSTR($G(N)),HAS=$$UP^XLFSTR($G(H))
 S FILESPEC="" S SCREEN("*.TXT")="",SCREEN("*.txt")=""
 S Y=$$LIST^%ZISH(PATH,"SCREEN","^ZZLEXX(""ZZLEXXBM"",$J,""DEVICE"",""TEMP"")")
 S HDR="File Name"_$J(" ",29)_"Effective Date"_$J(" ",6)_" Bytes"
 S HDR="File Name"_$J(" ",34)_"Date"_$J(" ",11)_" Bytes"
 S CT=0,FN="" F  S FN=$O(^ZZLEXX("ZZLEXXBM",$J,"DEVICE","TEMP",FN)) Q:'$L(FN)  D
 . N ASIZE,BYTE,CRE,CNT,CON,EDT,EFFD,FDTS,FI,I,OK,SEG,SIZE,TEMP,TXT,UFN
 . S OK=1 I $L($G(NOT)) D
 . . N UFN,I S UFN=$$UP^XLFSTR(FN),CON=0 F I=1:1 Q:'$L($P(NOT,";",I))  S:UFN[$P(NOT,";",I) OK=0
 . Q:'OK  S OK=1 I $L($G(HAS)) D
 . . N CON,CNT,UFN,SEG,I S UFN=$$UP^XLFSTR(FN),CON=0,CNT=0
 . . F I=1:1 S SEG=$P(HAS,";",I) Q:'$L(SEG)  S CNT=CNT+1 S:UFN[SEG CON=CON+1
 . . S:CNT>0&(CON'=CNT) OK=0
 . Q:'OK  S FULL=FN S:$L(PATH) FULL=PATH_FN
 . S FDTS=$$FDTS(FULL) Q:+FDTS'>0
 . S CRE=$P(FDTS,"^",1),(TEMP,EDT)=$P(FDTS,"^",2)
 . S SIZE=$P(FDTS,"^",3),ASIZE=$$CS(SIZE)
 . S BYTE=$J(" ",(11-$L(SIZE)))_SIZE
 . S FI=FN S:FN[";" FI=$P(FN,";",1) S ID=FI S:ID["." ID=$P(ID,".",1)
 . S EFFD=$$DEFF^ZZLEXXBP(FI)
 . Q:$D(^ZZLEXX("ZZLEXXBM",$J,"DEVICE","DIR","B",FI))
 . S TEMP=$P(TEMP," ",1)
 . S CT=CT+1,TXT=FI
 . S:$P(EFFD,"^",1)?7N&($L($P(EFFD,"^",2))) HDR="File Name"_$J(" ",29)_"Effective Date"_$J(" ",6)_" Bytes"
 . S:$P(EFFD,"^",1)?7N&($L($P(EFFD,"^",2))) TXT=TXT_$J(" ",(40-$L(TXT)))_$P(EFFD,"^",2)
 . S:$P(EFFD,"^",1)'?7N!('$L($P(EFFD,"^",2))) TXT=TXT_$J(" ",(40-$L(TXT)))_TEMP
 . S TXT=TXT_$J(" ",(13-$L(TEMP)))_BYTE
 . S TEMP=CRE
 . S ^ZZLEXX("ZZLEXXBM",$J,"DEVICE","DIR",CT)=TXT
 . S ^ZZLEXX("ZZLEXXBM",$J,"DEVICE","DIR",CT,"NAME")=FI
 . S ^ZZLEXX("ZZLEXXBM",$J,"DEVICE","DIR",CT,"SIZE")=SIZE
 . S ^ZZLEXX("ZZLEXXBM",$J,"DEVICE","DIR",CT,"ASIZ")=ASIZE
 . S ^ZZLEXX("ZZLEXXBM",$J,"DEVICE","DIR",CT,"BYTE")=BYTE
 . S ^ZZLEXX("ZZLEXXBM",$J,"DEVICE","DIR",CT,"DATE")=CRE
 . S ^ZZLEXX("ZZLEXXBM",$J,"DEVICE","DIR",CT,"EDAT")=EDT
 . S ^ZZLEXX("ZZLEXXBM",$J,"DEVICE","DIR",CT,"EFFD")=EFFD
 . S ^ZZLEXX("ZZLEXXBM",$J,"DEVICE","DIR",0)=CT
 . S ^ZZLEXX("ZZLEXXBM",$J,"DEVICE","DIR","B",FI,CT)=""
 . S ^ZZLEXX("ZZLEXXBM",$J,"DEVICE","DIR","C",FN,CT)=""
 S ^ZZLEXX("ZZLEXXBM",$J,"DEVICE","DIR","H")=HDR
 K ^ZZLEXX("ZZLEXXBM",$J,"DEVICE","TEMP")
 Q
DIRQ ;   Directory Quit
 K ^ZZLEXX("ZZLEXXBM",$J,"DEVICE","TEMP")
 Q
CS(X) ;   Host File Condensed Size
 N ID S ID="" S X=+($G(X)) Q:X'>0 "" S:X'>1024 X=X,ID=" B "
 S:X>1024 X=(X/1024),ID=" KB" S:X>1000 X=(X/1000),ID=" MB" S:X>1000 X=(X/1000),ID=" GB"
 S:ID=" B " X=X_ID S:ID'=" B " X=$FN(X,"",1)_ID
 S:$L(X) X=$J(" ",(10-$L(X)))_X
 Q X
FDTS(X) ;   Host File Dates and Size
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
 ; 
SEL(X) ; Host File Selection
 N SEL,FND,Y S FND=+($G(^ZZLEXX("ZZLEXXBM",$J,"DEVICE","DIR",0))) I +FND'>0 K ^ZZLEXX("ZZLEXXBM",$J) Q "-1^No host files found/available"
 S:+FND=1 SEL=$$ONE S:+FND>1 SEL=$$MUL S X=$S(SEL>0:("1^"_$G(^ZZLEXX("ZZLEXXBM",$J,"DEVICE","DIR",+SEL,"NAME"))),1:"-1^Host file selection not made")
 K ^ZZLEXX("ZZLEXXBM",$J) Q X
ONE(X) ;   One Host File Found
 N Y,DIR,DIRUT,DTOUT,DUOUT,DIROUT,MAX,Y S MAX=+($G(^ZZLEXX("ZZLEXXBM",$J,"DEVICE","DIR",0))) Q:MAX'=1 "-1^No selection available"
 S DIR("A",1)=("  "_$G(^ZZLEXX("ZZLEXXBM",$J,"DEVICE","DIR","H"))),DIR("A",2)=("  "_$G(^ZZLEXX("ZZLEXXBM",$J,"DEVICE","DIR",1)))
 S DIR("A",3)=" ",DIR("A")="     Ok?  (Y/N)  ",DIR("B")="Yes",DIR(0)="YAO",(DIR("?"),DIR("??"))="^D ONEH^ZZLEXXBM"
 W ! D ^DIR S X=$S(+Y>0:1,1:0)
 Q X
ONEH ;   One Host File Found Help
 W !,?7,"Answer ""Yes"" to select this host file or ""No"" or ""^""",!,?7,"to exit without making a selection"
 Q
MUL(X) ;   Multiple Host Files Found
 N EXIT,IEN,LAST,SEL,MAX,HDR,Y
 S MAX=$G(^ZZLEXX("ZZLEXXBM",$J,"DEVICE","DIR",0)) Q:MAX'>1 "-1^No selection available"
 S HDR="        "_$G(^ZZLEXX("ZZLEXXBM",$J,"DEVICE","DIR","H")) W !!," ",MAX," host files found",!
 S SEL="",(LAST,EXIT,IEN)=0
 F  S IEN=$O(^ZZLEXX("ZZLEXXBM",$J,"DEVICE","DIR",IEN)) Q:+IEN'>0!(+EXIT>0)  D  Q:+EXIT>0  Q:+SEL>0
 . N ENT,LEXT,LEXO S ENT=$G(^ZZLEXX("ZZLEXXBM",$J,"DEVICE","DIR",IEN)),LAST=IEN
 . W:IEN#5=1 !,HDR W !," ",$J(IEN,4),".  ",ENT W:IEN#5=0 ! S:IEN#5=0 SEL=$$MULS(LAST)
 . S:SEL="^" EXIT=1
 I LAST#5'=0,+SEL'>0 W ! S SEL=$$MULS(LAST) S:SEL="^" EXIT=1
 S X="^" S:'EXIT&(+SEL>0) X=SEL S:+X'>0 X="^"
 Q X
MULS(X) ;   Multiple Host Files Prompt
 N DIR,DIROUT,DIRUT,DTOUT,DUOUT,MAX,LAST,Y S MAX=$G(^ZZLEXX("ZZLEXXBM",$J,"DEVICE","DIR",0)) Q:MAX'>1 "-1^No selection available"
 S LAST=+($G(X)) S:LAST>0 DIR("A")=" Select 1-"_LAST_" or '^' to exit:  "
 S (DIR("?"),DIR("??"))="Answer must be from 1 to "_LAST_", or <Return> to continue  "
 S DIR(0)="NAO^1:"_LAST_":0" D ^DIR Q:X="" X  S:$D(DTOUT)!($D(DUOUT))!($D(DIRUT))!($D(DIROUT)) X="^" Q:X="^" "^"
 I +Y>0,+Y'>LAST S X=+Y Q X
 Q -1
 ; 
 ; Device
OPEN(X,Y,Z) ;   Open Device
 N HFOK,HFP,HFN,HFH S HFP=$G(X)
 Q:'$L($G(HFP)) "0^Missing Host file Path"
 S HFN=$G(Y) Q:'$L($G(HFN)) "0^Missing Host file Name"
 S HFH=$$LR_$G(Z)
 D OPEN^%ZISH(HFH,HFP,HFN,"R")
 S HFOK=$G(POP) I HFOK D CLOSE Q ("0^Error opening"_HFN)
 I IO'[HFN D CLOSE Q ("0^Error opening Host file "_HFN)
 Q 1
CLOSE(X) ;   Close Device
 N HFH S HFH=$$LR_$G(X) D CLOSE^%ZISH(HFH)
 Q
EOF(X) ;   End of File
 U IO S X=$$STATUS^%ZISH U IO(0)
 Q X
PATH(X,Y) ;   Path
 N UCI,SYS,PAT,PATH S UCI=$G(X) S:'$L(UCI) UCI=$$LOC S SYS=$G(Y)
 S:'$L(SYS) SYS=$$SYS S SYS=$E(SYS,1)
 S SYS=$$UP^XLFSTR(SYS),(PAT,UCI)=$$UP^XLFSTR(UCI) Q:'$L(UCI) ""  Q:'$L(SYS) ""  Q:"^U^V^"'[("^"_SYS_"^") ""
 S PATH="USER$:["_UCI_"]" S:SYS'="V" PATH="/home/sftp/patches/" S:UCI="DEVCUR"&(PATH["[") PATH="VA5$:[BETA]"
 S X=PATH
 Q X
PIT(X)  ;   Path - Input Transform
 N TPATH,TFILE,TFSPEC,OUT,FILE,PATH,IOP S TPATH=$G(X),TFILE="ZZLEXXBM"_+($G(DUZ))_".DAT",TFSPEC=TPATH_TFILE
 D HOME^%ZIS S IOP="HFS",%ZIS("HFSNAME")=TFSPEC,%ZIS("HFSMODE")="W",%ZIS="0" D ^%ZIS S OUT=POP
 I OUT U:$L($G(IO(0))) IO(0) D ^%ZISC,HOME^%ZIS Q 0
 U IO W ! U:$L($G(IO(0))) IO(0) D ^%ZISC,HOME^%ZIS K FAR
 S PATH="" S:TPATH["]" PATH=$P(TPATH,"]",1)_"]",FILE=$P(TPATH,"]",2)
 S:TPATH["/" PATH=$P(TPATH,"/",1,($L(TPATH,"/")-1))_"/",FILE=$P(TPATH,"/",$L(TPATH,"/"))
 S FAR(TFILE)="",Y=$$DEL^%ZISH(TPATH,$NA(FAR)),X=1_"^"_Y K FAR
 D ^%ZISC,HOME^%ZIS K %ZIS
 Q X
 ; 
SM(X,Y) ; Semantics
 ; 
 ; Input
 ; 
 ;    X   Code
 ;    Y   Coding System
 ; 
 ; Output
 ; 
 ;    X   2 piece "^" delimited string
 ;    
 ;           1  SC - Semantic Class (pointer 757.11)
 ;           2  ST - Semantic Type (pointer 757.12)
 ;           
 ;           ^LEX(757.1,DA,0)= MC ^ SC ^ ST
 ; 
 N CODE,CTL,DIRB,FND,MC,ORD,SI,SIEN,SM,SMP,SR,SRC,TRL S CODE=$G(X),SRC=$G(Y)
 S:SRC=1 DIRB="6^47" S:SRC=2 DIRB="14^61" S:SRC=3 DIRB="14^61" S:SRC=4 DIRB="10^74" S:SRC=30 DIRB="6^47"
 S:SRC=31 DIRB="14^61" S:SRC=56 DIRB="10^71" Q:'$L($G(DIRB)) "15^999" Q:SRC=56 "10^71"
 S TRL="" I (SRC="3"!(SRC=4)),"^T^F^"[("^"_$E(CODE,5)_"^") S TRL=$E(CODE,5)
 S (FND,SMP)="",CTL=CODE F  Q:$L(CTL)<2  Q:$L(SMP)  D  Q:$L(SMP)
 . N SIEN,ORD S ORD=$E(CTL,1,($L(CTL)-1))_$C($A($E(CTL,$L(CTL)))-1)_"~ "
 . F  S ORD=$O(@("^LEX(757.02,""CODE"","""_ORD_""")")) Q:'$L(ORD)!(ORD'[CTL)  Q:$L(SMP)  D  Q:$L(SMP)
 . . I $L($G(TRL)),$G(TRL)?1U,(SRC=3!(SRC=4)),$E(ORD,5)'=TRL Q
 . . N SIEN S SIEN=0 F  S SIEN=$O(@("^LEX(757.02,""CODE"","""_ORD_""","_+SIEN_")")) Q:+SIEN'>0  Q:$L(SMP)  D  Q:$L(SMP)
 . . . N MC,SI,SM,SR S MC=$P($G(@("^LEX(757.02,"_+SIEN_",0)")),"^",4),SR=$P($G(@("^LEX(757.02,"_+SIEN_",0)")),"^",3) Q:SR'=SRC
 . . . S SI=$O(@("^LEX(757.1,""B"","_+MC_",0)")),SM=$P($G(@("^LEX(757.1,"_+SI_",0)")),"^",2,3)
 . . . Q:'$D(@("^LEX(757.11,"_+($P(SM,"^",1))_",0)"))  Q:'$D(@("^LEX(757.12,"_+($P(SM,"^",2))_",0)"))
 . . . S SMP=SM,FND=$P($G(@("^LEX(757.02,"_+SIEN_",0)")),"^",2)
 . S CTL=$E(CTL,1,($L(CTL)-1))
 S:'$L(SMP) SMP=DIRB S X=$G(SMP)
 Q X
 ;
 ; Miscellaneous
LF(X) ;   Last File
 N EXIT,LAST,NAM,OPEN,PATH,SAB,YEAR
 S SAB=$G(X) Q:"^10D^10P^"'[("^"_SAB_"^") ""
 S LAST=$O(^LEX(757.02,"AUPD",SAB," "),-1) Q:LAST'?7N ""
 S NAM=$S(SAB="10D":"icd10cm",SAB="10P":"icd10pcs",1:"") Q:'$L(NAM) ""
 S YEAR=$E(LAST,1,3)+1700,EXIT=0,(X,LAST)="" F  Q:EXIT  D  Q:EXIT
 . N HFNAME,PATH,OPEN S HFNAME=NAM_"_order_"_YEAR_".txt"
 . S PATH=$$PATH^ZZLEXXAM,OPEN=$$OPEN^ZZLEXXAM(PATH,HFNAME,"CHK")
 . S:OPEN'>0 EXIT=1,X=LAST Q:OPEN'>0  S:OPEN>0 LAST=YEAR
 . D CLOSE^ZZLEXXAM("CHK") S YEAR=YEAR+1
 Q X
LI(X) ;   Last Install
 N LAST,SAB S SAB=$G(X) Q:"^10D^10P^"'[("^"_SAB_"^") ""
 S LAST=$O(^LEX(757.02,"AUPD",SAB," "),-1) Q:LAST'?7N
 S X=$E(LAST,1,3)+1700 S:LAST["1001" X=X+1
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
TX(X) ;   Format Text
 S X=$$UP^XLFSTR($$TM($$DS($TR($G(X),"""",""))))
 Q X
TM(X,Y) ;   Trim Character Y - Default " " Space
 S X=$G(X) Q:X="" X  S Y=$G(Y) S:'$L(Y) Y=" "
 F  Q:$E(X,1)'=Y  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=Y  S X=$E(X,1,($L(X)-1))
 Q X
DS(X) ;   Remove Double Space
 S X=$G(X) Q:X="" X
 F  Q:X'["  "  S X=$P(X,"  ",1)_" "_$P(X,"  ",2,299)
 Q X
ATTR ;   Screen Attributes
 N X,%,IOINHI,IOINORM S X="IOINHI;IOINORM" D ENDR^%ZISS S BOLD=$G(IOINHI),NORM=$G(IOINORM) Q
KATTR ;   Kill Screen Attributes
 D KILL^%ZISS K IOINHI,IOINORM,BOLD,NORM Q
KILL ;   Kill Globals
 D KILL^ZZLEXXBA
 Q
ED(X) ;   External Date
 S X=$G(X) Q:$P(X,".",1)'?7N ""
 S X=$$FMTE^XLFDT(X,"5ZM") S:X["@" X=$P(X,"@",1)_"  "_$P(X,"@",2)
 Q X
SYS(X) ;   System
 S X="U" S:$$OS^%ZOSV'["UNIX" X="V"
 Q X
LOC(X) ;   Local Namespace
 X "S X=$ZNSPACE" Q X
LR(X) ;   Local Routine
 S X=$T(+1),X=$P(X," ",1) Q X
CTL(X) ;   Remove/Replace Control Characters
 S X=$G(X) Q:'$L(X) ""  N OUT,PSN,CHR,ASC,REP,WIT
 ;     Accented letter e
 F CHR=130,136,137,138 S REP=$C(CHR),WIT="e" S X=$$CTLR(X,REP,WIT)
 ;     Accented letter c 
 F CHR=128,135 S REP=$C(CHR),WIT="c" S X=$$CTLR(X,REP,WIT)
 ;     Accented letter u 
 F CHR=129,151,163 S REP=$C(CHR),WIT="u" S X=$$CTLR(X,REP,WIT)
 ;     Accented letter a 
 F CHR=131,132,133,134,143,145,146,160,166 S REP=$C(CHR),WIT="a" S X=$$CTLR(X,REP,WIT)
 ;     Accented letter i
 F CHR=139,140,141 S REP=$C(CHR),WIT="i" S X=$$CTLR(X,REP,WIT)
 ;     Accented letter o 
 F CHR=147,148,149,153,162 S REP=$C(CHR),WIT="o" S X=$$CTLR(X,REP,WIT)
 ;     En dash
 S REP=$C(150),WIT="o" S X=$$CTLR(X,REP,WIT)
 ;     Inverted exclamation mark
 S REP=$C(161),WIT="a" S X=$$CTLR(X,REP,WIT)
 ;     Currency sign
 S REP=$C(164),WIT="a" S X=$$CTLR(X,REP,WIT)
 ;     Section Sing (double S)
 S REP=$C(167),WIT="c" S X=$$CTLR(X,REP,WIT)
 ;     Spacing diaeresis - umlaut
 S REP=$C(168),WIT="e" S X=$$CTLR(X,REP,WIT)
 ;     Copyright sign
 S REP=$C(169),WIT="e" S X=$$CTLR(X,REP,WIT)
 ;     Left double angle quotes
 S REP=$C(171),WIT="e" S X=$$CTLR(X,REP,WIT)
 ;     Pilcrow sign - paragraph sign
 S REP=$C(182),WIT="o" S X=$$CTLR(X,REP,WIT)
 ;     Spacing cedilla
 S REP=$C(184),WIT="o" S X=$$CTLR(X,REP,WIT)
 ;     One Fourth Fraction
 S REP=$C(188),WIT="u" S X=$$CTLR(X,REP,WIT)
 ;     Small letter a with circumflex
 S REP=$C(226),WIT="o" S X=$$CTLR(X,REP,WIT)
 ;     HTML En Dash
 S REP=$C(8211),WIT="o" S X=$$CTLR(X,REP,WIT)
 ;     Extended ASCII Vowels
 S REP=$C(142),WIT="Z" S X=$$CTLR(X,REP,WIT)
 S REP=$C(156),WIT="oe" S X=$$CTLR(X,REP,WIT)
 S REP=$C(158),WIT="z" S X=$$CTLR(X,REP,WIT)
 S REP=$C(159),WIT="Y" S X=$$CTLR(X,REP,WIT)
 F CHR=192,193,194,195,196,197 S REP=$C(CHR),WIT="A" S X=$$CTLR(X,REP,WIT)
 S REP=$C(198),WIT="AE" S X=$$CTLR(X,REP,WIT)
 S REP=$C(199),WIT="C" S X=$$CTLR(X,REP,WIT)
 F CHR=200,201,202,203 S REP=$C(CHR),WIT="E" S X=$$CTLR(X,REP,WIT)
 F CHR=204,205,206,207 S REP=$C(CHR),WIT="I" S X=$$CTLR(X,REP,WIT)
 S REP=$C(208),WIT="ETH" S X=$$CTLR(X,REP,WIT)
 S REP=$C(209),WIT="N" S X=$$CTLR(X,REP,WIT)
 F CHR=210,211,212,213,214,216 S REP=$C(CHR),WIT="O" S X=$$CTLR(X,REP,WIT)
 F CHR=217,218,219,220 S REP=$C(CHR),WIT="U" S X=$$CTLR(X,REP,WIT)
 S REP=$C(221),WIT="Y" S X=$$CTLR(X,REP,WIT)
 F CHR=154,223 S REP=$C(CHR),WIT="s" S X=$$CTLR(X,REP,WIT)
 F CHR=224,225,226,227,228,229 S REP=$C(CHR),WIT="a" S X=$$CTLR(X,REP,WIT)
 S REP=$C(230),WIT="ae" S X=$$CTLR(X,REP,WIT)
 S REP=$C(231),WIT="c" S X=$$CTLR(X,REP,WIT)
 F CHR=232,233,234,235 S REP=$C(CHR),WIT="e" S X=$$CTLR(X,REP,WIT)
 F CHR=236,237,238,239 S REP=$C(CHR),WIT="i" S X=$$CTLR(X,REP,WIT)
 S REP=$C(240),WIT="eth" S X=$$CTLR(X,REP,WIT)
 S REP=$C(241),WIT="n" S X=$$CTLR(X,REP,WIT)
 F CHR=242,243,244,245,246,248 S REP=$C(CHR),WIT="o" S X=$$CTLR(X,REP,WIT)
 F CHR=249,250,251,252 S REP=$C(CHR),WIT="u" S X=$$CTLR(X,REP,WIT)
 F CHR=253,255 S REP=$C(CHR),WIT="y" S X=$$CTLR(X,REP,WIT)
 ;     All others (remove)
 S OUT="" F PSN=1:1:$L(X) S CHR=$E(X,PSN),ASC=$A(CHR) S:ASC>31&(ASC<127) OUT=OUT_CHR
 ;     Uppercase leading character
 S X=$$UP^XLFSTR($E(OUT,1))_$E(OUT,2,$L(OUT))
 Q X
DBLS(X) ;   Double Space/Special Characters
 S X=$G(X) Q:(X'["  ")&(X'["^") X
 F  S X=$P(X,"  ",1)_" "_$P(X,"  ",2,300) Q:X'["  "
 F  S X=$P(X,"^",1)_" "_$P(X,"^",2,300) Q:X'["^"
 F  Q:$E(X,1)'=" "  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=" "  S X=$E(X,1,($L(X)-1))
 Q X
CTLR(LEX,X,Y) ;   Control Character Replace
 N LEXT,LEXR1,LEXR2,LEX2,LEXW S LEXT=$G(LEX) Q:'$L(LEXT) ""  S LEXR1=$G(X) S X=LEXT Q:'$L(LEXR1) X  Q:LEXT'[LEXR1 X
 S LEXW=$G(Y),LEXR2=$C(195)_LEXR1
 I LEXT[LEXR2 F  Q:LEXT'[LEXR2  S LEXT=$P(LEXT,LEXR2,1)_LEXW_$P(LEXT,LEXR2,2,4000)
 I LEXT[LEXR1 F  Q:LEXT'[LEXR1  S LEXT=$P(LEXT,LEXR1,1)_LEXW_$P(LEXT,LEXR1,2,4000)
 S X=LEXT
 Q X
