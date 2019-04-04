ZZLEXXDB ;SLC/KER - Import - ICD-10-CM Cat - Read ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^ZZLEXX("ZZLEXXD"   SACC 1.3
 ;               
 ; External References
 ;    HOME^%ZIS           ICR  10088
 ;    $$STATUS^%ZISH      ICR   2320
 ;    $$FMTE^XLFDT        ICR  10103
 ;    $$NOW^XLFDT         ICR  10103
 ;               
 Q
ORD ; Main Entry Point for ICD-10-CM Order File
 N ENV,ERR,FILE,FIT,HF,HFD,TFD,DFD,HFILE,HFSPEC,HOPEN,PATH,PIT,STOP,TESTK,PAR,Y S ENV=$$ENV^ZZLEXXDA H:+ENV'>0 2  Q:+ENV'>0
 S HF=$$CMOR^ZZLEXXDM I +HF'>0 W:$L($P($G(HF),"^",2)) !!,"  ",$P($G(HF),"^",2) H 2 W ! Q
 S (FILE,HF)=$P($G(HF),"^",2) I '$L($G(HF)) W !!,"  Hostfile not found",! H 2 Q
 S HFD=$$HFD^ZZLEXXDM(HF) S:HFD'?7N HFD=$$EFF^ZZLEXXDM
 I $G(HFD)'?7N W !!," Effective Date of hostfile not provided",! H 2 Q
 S STOP=$$STOP^ZZLEXXDP(HF) W:+STOP>0 ! Q:+STOP>0  Q:$D(TEST) TESTK=1
 S PAR=$$WAR^ZZLEXXDP(HF) I +($G(PAR))'>0 W !!,?4,"File read aborted",! K RTN K:$G(TESTK)>0 TEST H 2 Q
 S DFD=$G(^ZZLEXX(("ZZLEX"_"XE"),("P"_"CS"),"DT","DF"))
 S TFD=$G(^ZZLEXX(("ZZLEX"_"XE"),("P"_"CS"),"DT","TB"))
 I (TFD?7N)&(HFD'=TFD)!(DFD?7N)&(HFD'=DFD) D  H 2 Q
 . I (TFD?7N)&(HFD'=TFD) D  Q
 . . N CD,PD S CD=(+($E(HFD,1,3)))+1700,PD=(+($E(TFD,1,3)))+1700
 . . W !," ICD-10-CM date (",CD,") is inconsistent with the ICD-10-PC","S"
 . . W !," tabular data (",PD,").  Please load ICD-10-CM and ICD-10-PC","S"
 . . W !," from the same fiscal year."
 . I (DFD?7N)&(HFD'=DFD) D  Q
 . . N CD,PD S CD=(+($E(HFD,1,3)))+1700,PD=(+($E(DFD,1,3)))+1700
 . . W !," ICD-10-CM date (",CD,") is inconsistent with the ICD-10-PC","S"
 . . W !," definitions (",PD,").  Please load ICD-10-CM and ICD-10-PC","S"
 . . W !," from the same fiscal year."
 D HOME^%ZIS S PATH=$$PATH^ZZLEXXDM S (HFSPEC,HFILE)=PATH_FILE
 S PIT=$$PIT^ZZLEXXDM(PATH) I 'PIT W !!," Failed to find path ",PATH,! Q
 S FIT=$$FIT^ZZLEXXDM(HFSPEC) I 'FIT W !!," Failed to open hostfile ",HFILE,! Q
 S HOPEN=$$OPEN^ZZLEXXDM(PATH,FILE,"3ORD") I HOPEN'>0 D  Q
 . N ERR S ERR=$P(HOPEN,"^",2) D CLOSE^ZZLEXXDM("3ORD") I $L(ERR) W !!," ",ERR,!
 . I '$L(ERR) W !!," Failed to open hostfile ",HFILE,!
 S:$L($G(FILE)) ^ZZLEXX("ZZLEXXD","CAT","LOAD","HF1")=FILE
 S ^ZZLEXX("ZZLEXXD","CAT","LOAD","TIM","BEG")=$$NOW^XLFDT
 D ORDP D CLOSE^ZZLEXXDM("3ORD")
 I $D(^ZZLEXX("ZZLEXXD","CAT","LOAD","TIM","BEG")) D
 . N BEG,END,ELP,HR S BEG=$G(^ZZLEXX("ZZLEXXD","CAT","LOAD","TIM","BEG"))
 . H 1 S ^ZZLEXX("ZZLEXXD","CAT","LOAD","TIM","ST1")=$$NOW^XLFDT H 2
 . S END=$$NOW^XLFDT,ELP=$$FMDIFF^XLFDT(END,BEG,3)
 . S HR=$$TM($P(ELP,":",1)) S:$L(HR)'=2 HR="0"_HR S:$L(HR)'=2 HR="0"_HR S $P(ELP,":",1)=HR
 . S ^ZZLEXX("ZZLEXXD","CAT","LOAD","TIM","END")=END
 . S ^ZZLEXX("ZZLEXXD","CAT","LOAD","TIM","ELP")=ELP
 Q
ORDP ;   Process Order File
 Q:'$D(IO)  Q:'$D(IO(0))  K ^ZZLEXX("ZZLEXXD","CAT","CM")  S:$G(HFD)?7N ^ZZLEXX("ZZLEXXD","CAT","DT","CM")=HFD S ^ZZLEXX("ZZLEXXD","CAT","DT","CM","ON")=$$NOW^XLFDT
 N CT,EXIT,LBL,POS,SEG,VAL,SEC,AXS,POS,VNUM,VEFF,VEXT,VSAV S (VAL,LBL,SEG,SEC,AXS,POS)="" S POS=0,EXIT=0,CT=0
 S (VNUM,VEFF,VEXT)="" I $G(HFD)?7N S VNUM=$E(HFD,1,3)+1700,VEFF=($E(HFD,1,3)_"1001"),VEXT=$$FMTE^XLFDT(VEFF,"5Z")
 F  Q:EXIT>0  D ORDS Q:EXIT>0
 Q
ORDS ;   Parse/Check for Header Codes
 ; 
 ;     SEQ  1-5       5  Sequence
 ;     CSC  7-14      5  Category/Sub-Category
 ;     FLG   15       1  Flag 0 = Header, 1 = Code
 ;     STX  17-76    60  Short Text                  1 node
 ;     LTX  78-$L() 180  Long Text                   3 node
 ;   
 N MAXLEN S MAXLEN=$$MAX^ZZLEXXDA Q:+($G(MAXLEN))'>0  S EXIT=$$STATUS^%ZISH Q:EXIT>0
 N EXC,LINE S EXC="U IO R LINE U IO(0)" X EXC
 S:'$L($$TM($G(LINE))) EXIT=1 Q:EXIT>0
 N SAB,SRC,FRAG,KEY,NAM,DES,BIX,SEQ,CSC,FLG,STX,LTX,TXT,COD
 S TXT=$G(LINE) Q:$E(TXT,1)="~"  S SAB="10D",SRC=30
 S SEQ=$$TM($E(TXT,1,5))
 S CSC=$$TM($E(TXT,7,14))
 S FLG=$$TM($E(TXT,15)) Q:FLG>0
 S COD=CSC S:$L(COD)>2&(COD'[".") COD=$E(COD,1,3)_"."_$E(COD,4,$L(COD))
 S STX=$$TM($E(TXT,17,76))
 S LTX=$$TLT($$TM($E(TXT,78,$L(TXT))))
 I $D(TEST) U:$D(IO(0)) IO(0) W !,COD,?10,STX U IO
 S ^ZZLEXX("ZZLEXXD","CAT","CM",(COD_" "),0)=COD
 S:$G(VEFF)?7N ^ZZLEXX("ZZLEXXD","CAT","CM",(COD_" "),1)=($G(VNUM)_"^"_$G(VEFF)_"^"_$G(VEXT))
 S ^ZZLEXX("ZZLEXXD","CAT","CM",(COD_" "),2)=STX
 S ^ZZLEXX("ZZLEXXD","CAT","CM",(COD_" "),3)=LTX
 S:$L(LTX)>MAXLEN ^ZZLEXX("ZZLEXXD","CAT","CM",(COD_" "),3,"W")="WARNING:  Exceeds "_MAXLEN_" characters ("_$L(LTX)_")"
 N TEST
 Q
 ; Miscellaneous
TLT(X) ;   Trim Long Text
 N MAX S MAX=$$MAX^ZZLEXXDA Q:+($G(MAX))'>0  S X=$G(X)
 Q:$L(X)'>MAX X S:X[" and " X=$$SWAP($G(X)," and ^ & ") S:X[" AND " X=$$SWAP($G(X)," AND ^ & ")
 Q:$L(X)'>MAX X  S:X[" or " X=$$SWAP($G(X)," or ^/") S:X[" OR " X=$$SWAP($G(X)," OR ^/")
 Q:$L(X)'>MAX X  S:X["/a " X=$$SWAP($G(X),"/a ^/")
 Q:$L(X)'>MAX X  S:X["e.g.," X=$$SWAP($G(X),"e.g.,^e.g,")
 Q:$L(X)'>MAX X  S:X["external " X=$$SWAP($G(X),"external ^ext. ")
 Q X
SSW(X) ;   Short Swap Text
 N Y S Y=$G(X)
 S:Y["&gt;" Y=$$SWAP($G(X),"&gt;^>") S:Y["&GT;" Y=$$SWAP($G(X),"&GT;^>")
 S:Y["&lt;" Y=$$SWAP($G(X),"&lt;^<") S:Y["&LT;" Y=$$SWAP($G(X),"&LT;^<") S X=Y
 Q X
LSW(X) ;   Short Swap Text
 N Y S Y=$G(X) S:Y[" or " Y=$$SWAP($G(X)," or ^/") S X=Y
 Q X
SWAP(X,Y) ;   Swap Y in Text
 N TXT,REP,WIT S TXT=$G(X),REP=$G(Y),WIT=$P(REP,"^",2),REP=$P(REP,"^",1)
 F  Q:TXT'[REP  S TXT=$P(TXT,REP,1)_WIT_$P(TXT,REP,2,299)
 S X=TXT
 Q X
CTC(X) ;   Control Characters
 S X=$G(X) N Y,P S Y="" F P=1:1:$L(X)  D
 . N C,A S C=$E(X,P),A=$A(C) Q:A<32  Q:A>126  Q:A=63  S Y=Y_C
 S X=Y
 Q X
TM(X,Y) ;   Trim Character Y - Default " "
 S X=$G(X) Q:X="" X  S Y=$G(Y) S:'$L(Y) Y=" "
 F  Q:$E(X,1)'=Y  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=Y  S X=$E(X,1,($L(X)-1))
 Q X
