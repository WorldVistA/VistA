ZZLEXXAN ;SLC/KER - Import - ICD-10-CM - IENS, Freq, Text ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^UTILITY($J         ICR  10011
 ;               
 ; External References
 ;    ENDR^%ZISS          ICR  10088
 ;    KILL^%ZISS          ICR  10088
 ;    $$OS^%ZOSV          ICR   3522
 ;    ^DIWP               ICR  10011
 ;    $$FMTE^XLFDT        ICR  10103
 ;    $$UP^XLFSTR         ICR  10104
 ;               
 Q
NEWIEN(X,Y,LEX) ;   Get New IIENs
 ;     X             Source
 ;     Y             Code
 ;     LEX("IC")     ICD9, ICD0, ICPT IEN
 ;     LEX("MC")     Major Concept IEN
 ;     LEX("FQ")     Frequency IEN
 ;     LEX("EX")     Expression IEN
 ;     LEX("SO")     Code IEN
 ;     LEX("SM")     Semantic Map IEN
 K LEX
 N IN,IC,MC,FQ,EX,SO,SM
 N SRC,CODE S SRC=$G(X) Q:"^1^2^3^4^30^31^56^MOD^"'[("^"_SRC_"^")  S CODE=$G(Y)
 S:SRC=1 IC=$O(@("^ICD9(500000)"),-1)+1 S:SRC=1&($L($G(CODE)))&($D(@("^ICD9(""ABA"",1,"""_(CODE_" ")_""")"))) IC=$O(@("^ICD9(""ABA"",1,"""_(CODE_" ")_""",0)"))
 S:SRC=2 IC=$O(@("^ICD0(500000)"),-1)+1 S:SRC=2&($L($G(CODE)))&($D(@("^ICD0(""ABA"",2,"""_(CODE_" ")_""")"))) IC=$O(@("^ICD0(""ABA"",2,"""_(CODE_" ")_""",0)"))
 S:SRC=30 IC=$O(@("^ICD9("" "")"),-1)+1 S:SRC=30&($L($G(CODE)))&($D(@("^ICD9(""ABA"",30,"""_(CODE_" ")_""")"))) IC=$O(@("^ICD9(""ABA"",30,"""_(CODE_" ")_""",0)"))
 S:SRC=31 IC=$O(@("^ICD0("" "")"),-1)+1 S:SRC=31&($L($G(CODE)))&($D(@("^ICD0(""ABA"",31,"""_(CODE_" ")_""")"))) IC=$O(@("^ICD0(""ABA"",31,"""_(CODE_" ")_""",0)"))
 S:SRC=3 IC=$O(@("^ICPT("" "")"),-1)+1 S:SRC=2&(CODE?5N) IC=+CODE
 S:SRC=3&($L($G(CODE)))&($D(@("^ICPT(""BA"","""_(CODE_" ")_""")"))) IC=$O(@("^ICPT(""BA"","""_(CODE_" ")_""",0)"))
 S:SRC=4 IC=$O(@("^ICPT("" "")"),-1)+1 S:SRC=4&($L($G(CODE)))&($D(@("^ICPT(""BA"","""_(CODE_" ")_""")"))) IC=$O(@("^ICPT(""BA"","""_(CODE_" ")_""",0)"))
 I SRC="MOD" D
 . S IC=$O(@("^DIC(81.3,"" "")"),-1)+1 Q:'$L(CODE)  Q:'$D(@("^DIC(81.3,""BA"","""_(CODE_" ")_""")"))
 . N I S (IC,I)=0 F  S I=$O(@("^DIC(81.3,""BA"","""_(CODE_" ")_""","_+I_")")) Q:+I'>0  Q:IC>0  D  Q:IC>0
 . . I $O(@("^DIC(81.3,"_+I_",60,0)"))>0 S IC=I
 S:+($G(IC))>0 LEX("IC")=+($G(IC))
 S:"^1^2^3^4^"[("^"_SRC_"^") MC=$O(@("^LEX(757,4999999)"),-1)+1
 S:"^30^31^"[("^"_SRC_"^") MC=$O(@("^LEX(757,6999999)"),-1)+1
 S:"^56^"[("^"_SRC_"^") MC=$O(@("^LEX(757,"" "")"),-1)+1
 S:+($G(MC))>0 LEX("MC")=+($G(MC))
 S:+($G(MC))>0 LEX("FQ")=+($G(MC))
 S:"^1^2^3^4^"[("^"_SRC_"^") EX=$O(@("^LEX(757.01,4999999)"),-1)+1
 S:"^30^31^"[("^"_SRC_"^") EX=$O(@("^LEX(757.01,6999999)"),-1)+1
 S:"^56^"[("^"_SRC_"^") EX=$O(@("^LEX(757.01,"" "")"),-1)+1
 S:+($G(EX))>0 LEX("EX")=+($G(EX))
 S:"^1^2^3^4^"[("^"_SRC_"^") SO=$O(@("^LEX(757.02,4999999)"),-1)+1
 S:"^30^31^"[("^"_SRC_"^") SO=$O(@("^LEX(757.02,6999999)"),-1)+1
 S:"^56^"[("^"_SRC_"^") SO=$O(@("^LEX(757.02,"" "")"),-1)+1
 S:+($G(SO))>0 LEX("SO")=+($G(SO))
 S:"^1^2^3^4^"[("^"_SRC_"^") SM=$O(@("^LEX(757.1,4999999)"),-1)+1
 S:"^30^31^"[("^"_SRC_"^") SM=$O(@("^LEX(757.1,6999999)"),-1)+1
 S:"^56^"[("^"_SRC_"^") SM=$O(@("^LEX(757.1,"" "")"),-1)+1
 S:+($G(SM))>0 LEX("SM")=+($G(SM))
 Q
FREQ(X) ;   Get frequency based on codes and semantics
 N SRC,FRE S SRC=$G(X)
 ;     Coding Systems
 ;       ICD-10-CM                   6
 ;       ICD-10-PCS                  5
 S:SRC=30 FRE=6 S:SRC=31 FRE=5
 ;       CPT/HCPCS                   4
 S:SRC=3 FRE=4 S:SRC=4 FRE=4
 ;       ICD-9-CM                    3
 ;       DSM III/IV                  2
 ;       ICD-9 Proc                  2
 S:SRC=1 FRE=3 S:SRC=5 FRE=2 S:SRC=6 FRE=2 S:SRC=17 FRE=2 S:SRC=2 FRE=2
 ;       Nursing                     1
 S:SRC>10&(SRC<16) FRE=1
 S X=+($G(FRE))
 Q X
EXM(X,LEX,SRC) ;   Exact Match Major Concept
 ;     Input    X         Search Text
 ;              .LEX      Local Array
 ;              SRC       Source (for IEN restrictions)
 ;               
 ;     Output   $$EXM     Number of exact matches found
 ;              LEX       Local Array EXIEN ^ MCIEN
 K LEX N LEXA,LEXCTL,LEXI,LEXIEN,LEXINC,LEXMCO,LEXO,LEXORD,LEXORG,LEXCT,LEXSRC S LEXSRC=$G(SRC)
 S LEXORG=$G(X),LEXCTL=$$UP^XLFSTR($E(LEXORG,1,62)),LEXCT=0,LEXINC=0,LEXMCO=1
 S LEXORD=$E(LEXCTL,1,($L(LEXCTL)-1))_$C($A($E(LEXCTL,$L(LEXCTL)))-1)_"~" S X=0
 F  S LEXORD=$O(@("^LEX(757.01,""B"","""_LEXORD_""")")) Q:'$L(LEXORD)  Q:$E(LEXORD,1,$L(LEXCTL))'=LEXCTL  D
 . N LEXIEN S LEXIEN=0 F  S LEXIEN=$O(@("^LEX(757.01,""B"","""_LEXORD_""","_+LEXIEN_")")) Q:+LEXIEN'>0  D
 . . Q:$P($G(@("^LEX(757.01,"_+LEXIEN_",1)")),"^",2)'=1  Q:$P($G(@("^LEX(757.01,"_+LEXIEN_",1)")),"^",5)>0
 . . N LEXEXP,LEXI S LEXEXP=$G(@("^LEX(757.01,"_+LEXIEN_",0)")) Q:$$TX(LEXEXP)'=$$TX(LEXORG)
 . . S LEXI=$O(LEXA(" "),-1)+1 S LEXA(LEXI)=LEXIEN_"^"_+($P($G(@("^LEX(757.01,"_+LEXIEN_",1)")),"^",1)),LEXA(0)=LEXI
 K LEX S (X,LEXI)=0 F  S LEXI=$O(LEXA(LEXI)) Q:+LEXI'>0  D
 . N LEXEX,LEXMC,LEXME,LEXO S LEXEX=$G(LEXA(LEXI)),LEXMC=$P(LEXEX,"^",2),LEXEX=$P(LEXEX,"^",1)
 . S LEXME=+($P($G(@("^LEX(757,"_+LEXMC_",0)")),"^",1)) Q:+LEXEX'>0  Q:+LEXMC'>0
 . Q:"^31^30^"[("^"_LEXSRC_"^")&(LEXEX>6999999)  Q:LEXSRC<31&(LEXEX>4999999)
 . Q:(LEXSRC>31&(LEXSRC'=56))&(LEXEX>6999999)
 . Q:$P($G(@("^LEX(757.01,"_+LEXEX_",1)")),"^",5)>0  Q:$P($G(@("^LEX(757.01,"_+LEXME_",1)")),"^",5)>0
 . S LEXO=$O(LEX(" "),-1)+1 S LEX(LEXO)=+LEXEX_"^"_+LEXMC,(X,LEX(0))=LEXO
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
KILL ;   Kill Global
 D KILL^ZZLEXXAA
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
