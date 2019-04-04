ZZLEXXEB ;SLC/KER - Import - ICD-10-PCS Frag - Tabular ;10/26/2017
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
TAB ; Main Entry Point for Tabular File
 N ENV,ERR,FILE,FIT,HF,HFD,CFD,DFD,HFILE,HFSPEC,HOPEN,PATH,PIT,PAR,TESTK,STOP,Y S ENV=$$ENV^ZZLEXXEA H:+ENV'>0 2 Q:+ENV'>0
 S HF=$$PCST^ZZLEXXEM I +HF'>0 W:$L($P(HF,"^",2)) !!,?4,$P(HF,"^",2),! H 2 Q
 S (FILE,HF)=$P($G(HF),"^",2) I '$L($G(HF)) W !!,?4,"Hostfile not found",! H 2 Q
 S HFD=$$HFD^ZZLEXXEM(HF) S:HFD'?7N HFD=$$EFF^ZZLEXXEM S:$D(TEST) TESTK=1
 I $G(HFD)'?7N W !!,?4,"Effective Date of hostfile not provided",! H 2 Q
 S STOP=$$STOP^ZZLEXXEP(HF) W:+STOP>0 ! Q:+STOP>0
 S PAR=$$WAR^ZZLEXXEP(HF) I +($G(PAR))'>0 W !!,?4,"File read aborted",! K COMMIT,RTN K:$G(TESTK)>0 TEST H 2 Q
 S DFD=$G(^ZZLEXX("ZZLEXXE","PCS","DT","DF"))
 S CFD=$G(^ZZLEXX(("ZZLEX"_"XD"),"CAT","DT",("C"_"M")))
 I DFD?7N,HFD?7N,DFD'=HFD D  H 2 Q
 . W !!,?4,"The effective date for the Tabular data (",$$FMTE^XLFDT(HFD,"5Z"),")"
 . W !,?4,"is inconsistent with the Definitions file (",$$FMTE^XLFDT(DFD,"5Z"),")"
 . W !,?4,"Read tabular data and definitions from the same fiscal"
 . W !,?4,"year."
 I (CFD?7N)&(HFD?7N)&(HFD'=CFD) D  H 2 Q
 . N CD,TD S TD=(+($E(HFD,1,3)))+1700,CD=(+($E(CFD,1,3)))+1700
 . W !," ICD-10-P","CS tabular data date (",TD,") is inconsistent with "
 . W !," the ICD-10-C","M"," data (",CD,").  Please load ICD-10-P","CS and "
 . W !," ICD-10-C","M"," from the same fiscal year."
 D HOME^%ZIS S PATH=$$PATH^ZZLEXXEM S (HFSPEC,HFILE)=PATH_FILE
 S PIT=$$PIT^ZZLEXXEM(PATH) I 'PIT W !!,?4,"Failed to find directory path ",PATH,! H 2 Q
 S FIT=$$FIT^ZZLEXXEM(HFSPEC) I 'FIT W !!,?4,"Failed to open hostfile ",HFILE,! H 2 Q
 S HOPEN=$$OPEN^ZZLEXXEM(PATH,FILE,"1TAB") I HOPEN'>0 D  H 2 Q
 . N ERR S ERR=$P(HOPEN,"^",2) D CLOSE^ZZLEXXEM("1TAB") I $L(ERR) W !!," ",ERR,!
 . I '$L(ERR) W !!,?4,"Failed to open hostfile ",HFILE,!
 S:$L($G(FILE)) ^ZZLEXX("ZZLEXXE","PCS","LOAD","HF1")=FILE
 S:'$D(^ZZLEXX("ZZLEXXE","PCS","LOAD","TIM","BEG")) ^ZZLEXX("ZZLEXXE","PCS","LOAD","TIM","BEG")=$$NOW^XLFDT
 D TABP D CLOSE^ZZLEXXEM("1TAB")
 I $D(^ZZLEXX("ZZLEXXE","PCS","LOAD","TIM","BEG")) D
 . N BEG,END,ELP,HR S BEG=$G(^ZZLEXX("ZZLEXXE","PCS","LOAD","TIM","BEG"))
 . H 1 S ^ZZLEXX("ZZLEXXE","PCS","LOAD","TIM","ST1")=$$NOW^XLFDT H 2
 . S END=$$NOW^XLFDT,ELP=$$FMDIFF^XLFDT(END,BEG,3)
 . S HR=$$TM($P(ELP,":",1)) S:$L(HR)'=2 HR="0"_HR S:$L(HR)'=2 HR="0"_HR S $P(ELP,":",1)=HR
 . S ^ZZLEXX("ZZLEXXE","PCS","LOAD","TIM","END")=END
 . S ^ZZLEXX("ZZLEXXE","PCS","LOAD","TIM","ELP")=ELP
 Q
TABP ;   Process Tabular File
 Q:'$D(IO)  Q:'$D(IO(0))  K ^ZZLEXX("ZZLEXXE","PCS","TAB"),^ZZLEXX("ZZLEXXE","PCS","TAB","B")
 K ^ZZLEXX("ZZLEXXE","PCS","TAB","D"),^ZZLEXX("ZZLEXXE","PCS","DT","DF"),^ZZLEXX("ZZLEXXE","PCS","DT","TB")
 K ^ZZLEXX("ZZLEXXE","PCS","DT","PC"),^ZZLEXX("ZZLEXXE","PCS","DT","PCS")
 S:$G(HFD)?7N ^ZZLEXX("ZZLEXXE","PCS","DT","TB")=HFD S ^ZZLEXX("ZZLEXXE","PCS","DT","TB","ON")=$$NOW^XLFDT
 N HFV S HFV="" S:HFD?7N HFV=+($E(HFD,1,3))+1701 I HFV?4N D
 . I '$D(^ZZLEXX("ZZLEXXE","PCS","DT","VER")) K ^ZZLEXX("ZZLEXXE","PCS","DT","DF"),^ZZLEXX("ZZLEXXE","PCS","DT","TB"),^ZZLEXX("ZZLEXXE","PCS","DT","PC"),^ZZLEXX("ZZLEXXE","PCS","DT","PCS")
 . S ^ZZLEXX("ZZLEXXE","PCS","DT","VER")=HFV S:$G(HFD)?7N ^ZZLEXX("ZZLEXXE","PCS","DT","TB")=HFD S ^ZZLEXX("ZZLEXXE","PCS","DT","TB","ON")=$$NOW^XLFDT
 N CT,EOF,LBL,POS,SEG,VAL,VEF,SDOV S (SDOV,VEF,VAL,LBL,SEG)="" S POS=0,EOF=0,CT=0 F  Q:EOF>1  D TABS Q:EOF>1
 Q
TABS ;   Check Tabular <Segment>
 N DEF,EXC,LINE,ND,NUM,ROOT S EXC="U IO R LINE U IO(0)" X EXC
 I LINE["<version>" D
 . S SDOV=$P($P(LINE,"<version>",2),"</version>",1) Q:'$L(SDOV)
 . N TY,TE,TA S TY=SDOV-1701,TE=TY_"1001",TA=$$FMTE^XLFDT(TE,"5Z")
 . S VEF=SDOV_"^"_TE_"^"_TA
 S CT=CT+1 S ROOT="",NUM=1,(SDOV,ND)="" I LINE[">" S ND="<"_$P($P(LINE,"<",2),">",1)_">"
 S:LINE["<ICD10" EOF=1 S:LINE["<pcsTable>" EOF=1 S:LINE["</ICD10" EOF=2 Q:EOF>1
 S:CT>15&(EOF'>0) EOF=2 Q:EOF>1
 I LINE["<pcsRow codes=" S ROOT=SEG D TABR Q
 I LINE["<axis pos=""" D
 . S POS=$P($P(LINE,"<axis pos=""",2),"""",1)
 . S:POS=1 SEG="" S NUM=$P($P(LINE," values=""",2),"""",1)
 S (VAL,LBL)="" I LINE["<label code=""" D
 . S VAL=$P($P(LINE,"<label code=""",2),"""",1),VAL=$$TLT(VAL)
 . S LBL=$P($P(LINE,">",2),"<",1)
 S DEF=""  I LINE["<definition>" D
 . S DEF=$P(LINE,"<definition>",2),DEF=$P(DEF,"</definition>",1),DEF=$$TLT(DEF)
 S:$L($G(VAL)) SEG=SEG_$G(VAL)
 I $L(SEG),$L($G(VEF),"^")=3 S ^ZZLEXX("ZZLEXXE","PCS","TAB",(SEG_" "),1)=$G(VEF)
 I $L(SEG),$L(LBL) D
 . S ^ZZLEXX("ZZLEXXE","PCS","TAB",(SEG_" "),0)=SEG,^ZZLEXX("ZZLEXXE","PCS","TAB",(SEG_" "),2)=$$SSW(LBL)
 . S ^ZZLEXX("ZZLEXXE","PCS","TAB","B",$$UP^XLFSTR(LBL),(SEG_" "))=""
 I $L(SEG),$L(DEF) D
 . S ^ZZLEXX("ZZLEXXE","PCS","TAB",(SEG_" "),3)=DEF,^ZZLEXX("ZZLEXXE","PCS","TAB","D",$$UP^XLFSTR(DEF),(SEG_" "))=""
 Q
TABR ;   Check Tabular <Rows>
 Q:'$L(ROOT)  N MAXLEN S MAXLEN=$$MAX^ZZLEXXEA Q:+($G(MAXLEN))'>0
 N EXIT,RT S EXIT=0,RT=$G(ROOT) F  Q:EXIT  D  Q:EXIT
 . N DEF,EXC,FRA,LBL,LINE,NNN,NUM,STR,VAL
 . S EXC="U IO R LINE U IO(0)" X EXC S (VAL,LBL,DEF)=""
 . S:LINE["</ICD10" EXIT=1,EOF=2 S:LINE["</pcsRow>" EXIT=1 Q:EXIT
 . S:LINE["<axis pos=""" POS=$P($P(LINE,"<axis pos=""",2),"""",1) Q:POS'?1N
 . S:LINE["<axis pos="""&(LINE[" values=""") NUM=$P($P(LINE," values=""",2),"""",1)
 . S:LINE["<label code=""" VAL=$P($P(LINE,"<label code=""",2),"""",1),LBL=$P($P(LINE,">",2),"<",1),VAL=$$TLT(VAL)
 . S DEF="" S:LINE["<definition>" DEF=$P(LINE,"<definition>",2),DEF=$P(DEF,"</definition>",1),DEF=$$TLT(DEF)
 . I POS>0,$L(VAL),$L(LBL),$L(RT) S ORD=$E(RT,1,($L(RT)-1))_$C($A($E(RT,$L(RT)))-1)_"~ " D
 . . F  S ORD=$O(^ZZLEXX("ZZLEXXE","PCS","TAB",ORD)) Q:'$L(ORD)  Q:$E(ORD,1,$L(RT))'=RT  D
 . . . N FRA S FRA=$TR(ORD," ","") I $L(FRA)=(POS-1),$L(VAL),$L(LBL) D
 . . . . N NNN,STR S NNN=FRA_VAL Q:$$FOK(NNN)'>0  Q:'$L(NNN)
 . . . . S ^ZZLEXX("ZZLEXXE","PCS","TAB",(NNN_" "),0)=NNN
 . . . . I $L($G(VEF),"^")=3 S ^ZZLEXX("ZZLEXXE","PCS","TAB",(NNN_" "),1)=$G(VEF)
 . . . . S STR=$$TLT($$SSW(LBL)) S ^ZZLEXX("ZZLEXXE","PCS","TAB",(NNN_" "),2)=STR
 . . . . S:$L(STR)>MAXLEN ^ZZLEXX("ZZLEXXE","PCS","TAB",(NNN_" "),2,"W")="WARNING:  Exceeds "_MAXLEN_" characters ("_$L(STR)_")"
 . . . . S ^ZZLEXX("ZZLEXXE","PCS","TAB","B",$$UP^XLFSTR(LBL),(NNN_" "))=""
 . I POS>0,$L(DEF),$L(RT) S ORD=$E(RT,1,($L(RT)-1))_$C($A($E(RT,$L(RT)))-1)_"~ " D
 . . F  S ORD=$O(^ZZLEXX("ZZLEXXE","PCS","TAB",ORD)) Q:'$L(ORD)  Q:$E(ORD,1,$L(RT))'=RT  D
 . . . N FRA S FRA=$TR(ORD," ","") I $L(FRA)=(POS-1),$L(VAL),$L(DEF) D
 . . . . N NNN,STR S NNN=FRA_VAL Q:$$FOK(NNN)'>0  Q:'$L(NNN)
 . . . . S STR=$$TLT($G(DEF)) S ^ZZLEXX("ZZLEXXE","PCS","TAB",(NNN_" "),3)=STR
 . . . . S:$L(STR)>MAXLEN ^ZZLEXX("ZZLEXXE","PCS","TAB",(NNN_" "),3,"W")="WARNING:  Exceeds "_MAXLEN_" characters ("_$L(STR)_")"
 . . . . S ^ZZLEXX("ZZLEXXE","PCS","TAB","D",$$UP^XLFSTR(DEF),(NNN_" "))=""
 Q
 ; 
 ; Miscellaneous
FOK(X) ;   Fragment OK
 N FRA,ORD,NXT S FRA=$G(X) Q:'$L(FRA) 0
 S ORD=$E(FRA,1,($L(FRA)-1))_$C($A($E(FRA,$L(FRA)))-1)_"~ "
 S NXT=$O(@("^ICD0(""ABA"",31,"""_ORD_""")")) Q:$E(NXT,1,$L(FRA))'=FRA 0
 Q 1
OUT ;   Output Hostfile
 N ENV,ERR,FILE,FIT,HF,HFILE,HFSPEC,HOPEN,ORD,JB,PATH,PIT,TAB,Y S ENV=$$ENV^ZZLEXXEA Q:+ENV'>0
 S HF="ZZLEXXE.TXT" S (FILE,HF)=$$UP^XLFSTR($G(HF)) D HOME^%ZIS
 S PATH=$$PATH^ZZLEXXEM S PIT=$$PIT^ZZLEXXEM(PATH) I 'PIT W !!," Failed to find path ",PATH,! Q
 S HFSPEC=(PATH_HF),HOPEN=$$OPENW^ZZLEXXEM(HFSPEC,"1OUT") I HOPEN'>0 W !!," Failed to open hostfile ",HFILE,! Q
 S TAB=$C(9) I '$D(^ZZLEXX) D CLOSE^ZZLEXXEM("1OUT") Q
 S ORD="" F  S ORD=$O(^ZZLEXX("ZZLEXXE","TAB",ORD)) Q:'$L(ORD)  D
 . N FRA,NAM,DES S FRA=$TR(ORD," ","")
 . S NAM=$G(^ZZLEXX("ZZLEXXE","TAB",ORD,0))
 . S DES=$G(^ZZLEXX("ZZLEXXE","TAB",ORD,1))
 . U IO W !,FRA,TAB,NAM W:$L($G(DES)) TAB,$G(DES) U IO(0)
 D CLOSE^ZZLEXXEM("1OUT")
 Q
TLT(X) ;   Trim Long Text
 S MAXLEN=$$MAX^ZZLEXXEA Q:+($G(MAXLEN))'>0  N MAX S MAX=MAXLEN S X=$G(X)
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
TM(X,Y) ;   Trim Character Y - Default " "
 S X=$G(X) Q:X="" X  S Y=$G(Y) S:'$L(Y) Y=" "
 F  Q:$E(X,1)'=Y  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=Y  S X=$E(X,1,($L(X)-1))
 Q X
LSW(X) ;   Short Swap Text
 N Y S Y=$G(X) S:Y[" or " Y=$$SWAP($G(X)," or ^/") S X=Y
 Q X
SWAP(X,Y) ;   Swap Y in Text
 N TXT,REP,WIT S TXT=$G(X),REP=$G(Y),WIT=$P(REP,"^",2),REP=$P(REP,"^",1)
 F  Q:TXT'[REP  S TXT=$P(TXT,REP,1)_WIT_$P(TXT,REP,2,299)
 S X=TXT
 Q X
