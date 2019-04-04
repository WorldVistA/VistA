ZZLEXXEC ;SLC/KER - Import - ICD-10-PCS Frag - Definitions ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;   ^ZZLEXX("ZZLEXXE"    SACC 1.3
 ;               
 ; External References
 ;    HOME^%ZIS           ICR  10088
 ;    $$FMTE^XLFDT        ICR  10103
 ;    $$NOW^XLFDT         ICR  10103
 ;    $$UP^XLFSTR         ICR  10103
 ;               
 Q
DEF ; Main Entry Point for Definitions File
 N ENV,ERR,FILE,FIT,HF,HFD,HFV,TFD,HFILE,HFSPEC,HOPEN,PATH,PAR,PIT,STOP,TESTK,Y S ENV=$$ENV^ZZLEXXEA H:+ENV'>0 2 Q:+ENV'>0
 S TFD=$G(^ZZLEXX("ZZLEXXE","PCS","DT","TB")),HF=$$PCSD^ZZLEXXEM I +HF'>0 W:$L($P($G(HF),"^",2)) !!,?4,$P($G(HF),"^",2) H 2 W ! Q
 I TFD'?7N!('$D(^ZZLEXX("ZZLEXXE","PCS","TAB"))) W !!,?4,"Tabular data not found. Read tabular data before definitions.",! H 2 Q
 S (FILE,HF)=$P($G(HF),"^",2) I '$L($G(HF)) W !!,?4,"Hostfile not found",! H 2 Q
 S TFD=$G(^ZZLEXX("ZZLEXXE","PCS","DT","TB")),HFD=$$HFD^ZZLEXXEM(HF) S:HFD'?7N HFD=$$EFF^ZZLEXXEM(TFD)
 I $G(HFD)'?7N W !!,?4,"Effective Date of hostfile not provided",! H 2 Q
 S STOP=$$STOP^ZZLEXXEP(HF) W:+STOP>0 ! Q:+STOP>0  S:$D(TEST) TESTK=1
 S PAR=$$WAR^ZZLEXXEP(HF) I +($G(PAR))'>0 W !!,?4,"File read aborted",! K COMMIT,RTN K:$G(TESTK)>0 TEST H 2 Q
 I TFD?7N,HFD?7N,TFD'=HFD D  H 2 Q
 . W !!,?4,"The effective date for the Tabular data (",$$FMTE^XLFDT(TFD,"5Z"),")"
 . W !,?4,"is inconsistent with the Definitions file (",$$FMTE^XLFDT(HFD,"5Z"),")"
 . W !,?4,"Read tabular data and definitions from the same fiscal"
 . W !,?4,"year."
 S CFD=$G(^ZZLEXX(("ZZLEX"_"XD"),"CAT","DT",("C"_"M")))
 I (CFD?7N)&(HFD?7N)&(HFD'=CFD) D  H 2 Q
 . N CD,TD S TD=(+($E(HFD,1,3)))+1700,CD=(+($E(CFD,1,3)))+1700
 . W !," ICD-10-P","CS definitions data date (",TD,") is inconsistent with "
 . W !," the ICD-10-C","M"," data (",CD,").  Please load ICD-10-P","CS and "
 . W !," ICD-10-C","M"," from the same fiscal year."
 D HOME^%ZIS S PATH=$$PATH^ZZLEXXEM S (HFSPEC,HFILE)=PATH_FILE S PIT=$$PIT^ZZLEXXEM(PATH) I 'PIT D  H 2 Q
 . W !!,?4,"Failed to find path ",PATH,!
 S FIT=$$FIT^ZZLEXXEM(HFSPEC) I 'FIT D  H 2 Q
 . W !!,?4,"Failed to open hostfile ",HFILE,!
 S HOPEN=$$OPEN^ZZLEXXEM(PATH,FILE,"2DEF") I HOPEN'>0 D  H 2 Q
 . N ERR S ERR=$P(HOPEN,"^",2) D CLOSE^ZZLEXXEM("2DEF") I $L(ERR) W !!," ",ERR,!
 . I '$L(ERR) W !!,?4,"Failed to open hostfile ",HFILE,!
 S:$L($G(FILE)) ^ZZLEXX("ZZLEXXE","PCS","LOAD","HF2")=FILE
 S:'$D(^ZZLEXX("ZZLEXXE","PCS","LOAD","TIM","BEG")) ^ZZLEXX("ZZLEXXE","PCS","LOAD","TIM","BEG")=$$NOW^XLFDT
 D DEFP D CLOSE^ZZLEXXEM("2DEF")
 I $D(^ZZLEXX("ZZLEXXE","PCS","LOAD","TIM","BEG")) D
 . N BEG,END,ELP,HR S BEG=$G(^ZZLEXX("ZZLEXXE","PCS","LOAD","TIM","BEG"))
 . H 1 S ^ZZLEXX("ZZLEXXE","PCS","LOAD","TIM","ST2")=$$NOW^XLFDT H 2
 . S END=$$NOW^XLFDT,ELP=$$FMDIFF^XLFDT(END,BEG,3)
 . S HR=$$TM($P(ELP,":",1)) S:$L(HR)'=2 HR="0"_HR S:$L(HR)'=2 HR="0"_HR S $P(ELP,":",1)=HR
 . S ^ZZLEXX("ZZLEXXE","PCS","LOAD","TIM","END")=END
 . S ^ZZLEXX("ZZLEXXE","PCS","LOAD","TIM","ELP")=ELP
 Q
DEFP ;   Process Definition File
 Q:'$D(IO)  Q:'$D(IO(0))  K ^ZZLEXX("ZZLEXXE","PCS","DEF"),^ZZLEXX("ZZLEXXE","PCS","DEF","B")
 K ^ZZLEXX("ZZLEXXE","PCS","DT","DF"),^ZZLEXX("ZZLEXXE","PCS","DT","PCS")
 S:$G(HFD)?7N ^ZZLEXX("ZZLEXXE","PCS","DT","DF")=HFD S ^ZZLEXX("ZZLEXXE","PCS","DT","DF","ON")=$$NOW^XLFDT
 S:$G(HFD)?7N&($G(^ZZLEXX("ZZLEXXE","PCS","DT","TB"))=$G(HFD)) ^ZZLEXX("ZZLEXXE","PCS","DT","PCS")=HFD,^ZZLEXX("ZZLEXXE","PCS","DT","PCS","ON")=$$NOW^XLFDT
 N CT,EOF,LBL,POS,SEG,VAL,SEC,AXS,POS S (VAL,LBL,SEG,SEC,AXS,POS)="" S POS=0,EOF=0,CT=0 F  Q:EOF>1  D DEFS Q:EOF>1
 D PCS
 Q
DEFS ;   Check Definition <Section>
 N DEF,EXC,LINE,ND,NUM,ROOT,OSEC S EXC="U IO R LINE U IO(0)" X EXC
 S CT=CT+1 S ROOT="",NUM=1,ND="" I LINE[">" S ND="<"_$P($P(LINE,"<",2),">",1)_">"
 S:LINE["<ICD10" EOF=1 S:LINE["</ICD10" EOF=2 Q:EOF>1  S:CT>15&(EOF'>0) EOF=2 Q:EOF>1
 S OSEC=SEC I LINE["<section code=""" S OSEC=$E($P(LINE,"<section code=""",2),1)
 I OSEC'=SEC S SEC=OSEC,POS="" D
 . I $D(TEST) U IO(0) W !,OSEC," " U IO
 . N DEF,ND,NUM,ROOT,I,EXIT S EXIT=0 F I=1:1 D  Q:EXIT
 . . N EXC,LINE,OPOS S EXC="U IO R LINE U IO(0)" X EXC I LINE["</section" S EXIT=1 Q
 . . S OPOS=POS I LINE["<axis pos=""" S OPOS=$E($P(LINE,"<axis pos=""",2),1)
 . . I OPOS'=POS U:$D(TEST) IO(0) W:$D(TEST) OPOS U:$D(TEST) IO S POS=OPOS D DEFA
 N TEST
 Q
DEFA ;   Check Definition <Axis>
 N DEF,ND,NUM,ROOT,I,EXIT S EXIT=0 F I=1:1 D  Q:EXIT
 . N EXC,LINE,OPOS,TTL,DEF,EXP,INC S EXC="U IO R LINE U IO(0)" X EXC S:LINE["</ICD10" EXIT=1,EOF=2 Q:EOF>1  I LINE["</axis" S EXIT=1 Q
 . S OPOS=POS I LINE["<terms>" D
 . . N I,EXIT S EXIT=0 F I=1:1 D  Q:EXIT
 . . . N EXC,TTL,DEF,EXP,INC,II,VAL S (TTL,DEF,EXP,INC,VAL)=""
 . . . S EXC="U IO R LINE U IO(0)" X EXC I LINE["</terms" D  S EXIT=1 Q
 . . . . I $D(ARY) S ARY("SEC")=$G(SEC),ARY("POS")=$G(POS) D
 . . . . . D DEFO K ARY
 . . . S VAL="" S:LINE["<title>" VAL=$P($P(LINE,"<title>",2),"</title>",1) S:$L(VAL) TTL=$$TLT^ZZLEXXEB($$CTC(VAL))
 . . . I $L(TTL) S ARY(2)=TTL
 . . . S VAL="" S:LINE["<definition>" VAL=$P($P(LINE,"<definition>",2),"</definition>",1) S:$L(VAL) DEF=$$TLT^ZZLEXXEB($$CTC(VAL))
 . . . I $L(DEF) S ARY(3)=DEF
 . . . S VAL="" S:LINE["<explanation>" VAL=$P($P(LINE,"<explanation>",2),"</explanation>",1) S:$L(VAL) EXP=$$TLT^ZZLEXXEB($$CTC(VAL))
 . . . I $L(EXP) S ARY(4)=EXP
 . . . S VAL="" S:LINE["<includes>" VAL=$P($P(LINE,"<includes>",2),"</includes>",1) S:$L(VAL) INC=$$TLT^ZZLEXXEB($$CTC(VAL))
 . . . I $L(INC) S II=$O(ARY(5," "),-1)+1,ARY(5,II)=INC
 Q
DEFO ;   Definition Output
 N MAXLEN S MAXLEN=$$MAX^ZZLEXXEA Q:+($G(MAXLEN))'>0  N SEC,POS,INC,VAL,II,NAM,UPN
 S SEC=$G(ARY("SEC")) Q:$L(SEC)'=1  S POS=$G(ARY("POS")) Q:$L(POS)'=1
 S INC=$O(^ZZLEXX("ZZLEXXE","PCS","DEF",SEC,POS," "),-1)+1
 S (NAM,VAL)=$$TLT^ZZLEXXEB($G(ARY(2))),UPN=$$UP^XLFSTR(NAM) I $L(VAL) D
 . S ^ZZLEXX("ZZLEXXE","PCS","DEF",SEC,POS,INC,2)=VAL,^ZZLEXX("ZZLEXXE","PCS","DEF","B",VAL,SEC,POS,INC,2)=""
 . S:$L(VAL)>MAXLEN ^ZZLEXX("ZZLEXXE","PCS","DEF",SEC,POS,INC,2,"W")="WARNING:  Exceeds "_MAXLEN_" characters ("_$L(VAL)_")"
 S VAL=$$TLT^ZZLEXXEB($G(ARY(3))) I $L(VAL) D
 . S ^ZZLEXX("ZZLEXXE","PCS","DEF",SEC,POS,INC,3)=VAL
 . S:$L(VAL)>MAXLEN ^ZZLEXX("ZZLEXXE","PCS","DEF",SEC,POS,INC,3,"W")="WARNING:  Exceeds "_MAXLEN_" characters ("_$L(VAL)_")"
 S VAL=$$TLT^ZZLEXXEB($G(ARY(4))) I $L(VAL) D
 . S ^ZZLEXX("ZZLEXXE","PCS","DEF",SEC,POS,INC,4)=VAL
 . S:$L(VAL)>MAXLEN ^ZZLEXX("ZZLEXXE","PCS","DEF",SEC,POS,INC,4,"W")="WARNING:  Exceeds "_MAXLEN_" characters ("_$L(VAL)_")"
 S II=0 F  S II=$O(ARY(5,II)) Q:+II'>0  D
 . S VAL=$$TLT^ZZLEXXEB($G(ARY(5,II))) S:$L(VAL) ^ZZLEXX("ZZLEXXE","PCS","DEF",SEC,POS,INC,5,II)=VAL
 I $L(UPN),$D(^ZZLEXX("ZZLEXXE","PCS","TAB","B",UPN)) D
 . N FRG S FRG="" F  S FRG=$O(^ZZLEXX("ZZLEXXE","PCS","TAB","B",UPN,FRG))  D  Q:'$L(FRG)
 . . N VAL,COD,II S (COD,VAL)=$TR(FRG," ","") Q:'$L(VAL)
 . . Q:$E(VAL,1)'=SEC  Q:$L(VAL)'=POS
 . . Q:$G(^ZZLEXX("ZZLEXXE","PCS","TAB",FRG,0))'=VAL
 . . Q:$G(^ZZLEXX("ZZLEXXE","PCS","TAB",FRG,2))'=NAM
 . . S VAL=$$TLT^ZZLEXXEB($G(ARY(3))) I $L(VAL) D
 . . . I '$D(^ZZLEXX("ZZLEXXE","PCS","TAB",FRG,3)) D
 . . . . S ^ZZLEXX("ZZLEXXE","PCS","TAB",FRG,3)=VAL,^ZZLEXX("ZZLEXXE","PCS","TAB","D",$$UP^XLFSTR(VAL),FRG)=""
 . . . . S:$L(VAL)>MAXLEN ^ZZLEXX("ZZLEXXE","PCS","TAB",FRG,3,"W")="WARNING:  Exceeds "_MAXLEN_" characters ("_$L(VAL)_")"
 . . S VAL=$$TLT^ZZLEXXEB($G(ARY(4))) I $L(VAL) D
 . . . S ^ZZLEXX("ZZLEXXE","PCS","TAB",FRG,4)=VAL
 . . . S:$L(VAL)>MAXLEN ^ZZLEXX("ZZLEXXE","PCS","TAB",FRG,4,"W")="WARNING:  Exceeds "_MAXLEN_" characters ("_$L(VAL)_")"
 . . K:$O(ARY(5,0))>0 ^ZZLEXX("ZZLEXXE","PCS","TAB",FRG,5)
 . . S II=0 F  S II=$O(ARY(5,II)) Q:+II'>0  D
 . . . S VAL=$$TLT^ZZLEXXEB($G(ARY(5,II))) I $L(VAL) S ^ZZLEXX("ZZLEXXE","PCS","TAB",FRG,5,II)=VAL
 Q
 ; 
 ; Miscellaneous
PCS ;   Merge Tabular and Definitions into PCS
 K ^ZZLEXX("ZZLEXXE","PCS","PCS") I $D(^ZZLEXX("ZZLEXXE","PCS","TAB")),$L($O(^ZZLEXX("ZZLEXXE","PCS","TAB",""))),$D(^ZZLEXX("ZZLEXXE","PCS","DEF")) D
 . I $L($O(^ZZLEXX("ZZLEXXE","PCS","DEF",""))),$G(^ZZLEXX("ZZLEXXE","PCS","DT","DF"))?7N,$G(^ZZLEXX("ZZLEXXE","PCS","DT","TB"))?7N D
 . . N VER,PDT,PON S VER=$G(^ZZLEXX("ZZLEXXE","PCS","DT","DF")),VER=$$VER(VER) Q:VER'?4N  Q:VER'>2010  S PDT=$G(^ZZLEXX("ZZLEXXE","PCS","DT","DF")) Q:PDT'?7N  S PON=$$NOW^XLFDT
 . . M ^ZZLEXX("ZZLEXXE","PCS","PCS")=^ZZLEXX("ZZLEXXE","PCS","TAB") S ^ZZLEXX("ZZLEXXE","PCS","DT","PC")=PDT,^ZZLEXX("ZZLEXXE","PCS","DT","PC","ON")=PON
 Q
TM(X,Y) ;   Trim Character Y - Default " "
 S X=$G(X) Q:X="" X  S Y=$G(Y) S:'$L(Y) Y=" "
 F  Q:$E(X,1)'=Y  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=Y  S X=$E(X,1,($L(X)-1))
 Q X
VER(X) ;     Version
 S X=$P($G(X),".",1) Q:X'?7N ""  N YR,MD S YR=$E(X,1,3)+1700,MD=$E(X,4,5) S:+MD>9 YR=YR+1 S X=YR
 Q X
CTC(X) ;   Control Characters
 S X=$G(X) N Y,P S Y="" F P=1:1:$L(X)  D
 . N C,A S C=$E(X,P),A=$A(C) Q:A<32  Q:A>126  Q:A=63  S Y=Y_C
 S X=Y
 Q X
LONG ;   Long Descriptions
 S MAXLEN=$$MAX^ZZLEXXEA Q:+($G(MAXLEN))'>0  N ORD S ORD="" F  S ORD=$O(^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","LR",ORD)) Q:'$L(ORD)  D
 . N NEW,OLD S NEW=$G(^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","LR",ORD,0)),OLD=$G(^ZZLEXX("ZZLEXXE","PCS","CHG","PCS","LR",ORD,1))
 . W:$L(NEW)'>MAXLEN !,$L(NEW),?10,$L(OLD) Q:$L(NEW)'>MAXLEN  W !!,$L(NEW),?5,NEW,!,$L(OLD),?5,OLD
 Q
