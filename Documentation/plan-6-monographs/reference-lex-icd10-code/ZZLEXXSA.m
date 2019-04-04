ZZLEXXSA ;SLC/KER - Import - SDO Addenda - Main ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^ZZLEXX("ZZLEXXS"   SACC 1.3
 ;               
 ; External References
 ;    HOME^%ZIS           ICR  10086
 ;    $$GET1^DIQ          ICR   2056
 ;    $$DT^XLFDT          ICR  10103
 ;    $$FMTE^XLFDT        ICR  10103
 ;    $$NOW^XLFDT         ICR  10103
 ;    $$UP^XLFSTR         ICR  10104
 ;               
 ; Data Sources (CM/PCS)
 ;               
 ;   CMS Medicare
 ;   > ICD-10
 ;     > 2017 ICD-10-CM and GEMs or
 ;     > 2017 ICD-10-PCS and GEMs
 ;       Note, year will change
 ;       > 2017 Code Descriptions in Tabular Order (ZIP) or
 ;         2017 ICD-10-PCS Order File Long and Abbreviated Titles (ZIP)
 ;         Note, year will change
 ;         > icd10cm_order_addenda_2017.txt  or 
 ;           icd10pcs_order_addenda_yyyy.txt or
 ;           order_addenda_yyyy.txt
 ;           Note, year will change
 ;               
 ; Data Format
 ;               
 ;    Sequential text file.  Each line is formatted as follow:
 ;    
 ;    Diagnosis:
 ;               
 ;       Character
 ;       Positions  Length   Contents
 ;         1-12       12     Action
 ;                             Add
 ;                             Delete
 ;                             Revise from
 ;                             Revise to
 ;         13          1     Blank
 ;         14          1     Type (set of codes)
 ;                             0 header code
 ;                             1 valid code
 ;         15          1     Blank
 ;         15-22       8     Code (without decimal)
 ;         23          1     Blank
 ;         24-83      60     Short Description (text) 
 ;         84          1     Blank
 ;         85-End    1-300   Long Description (text) 
 ;               
 ;    Procedures:
 ;    
 ;       Character
 ;       Positions  Length   Contents
 ;         1-12       12     Action
 ;                             Add
 ;                             Delete
 ;                             Revise from
 ;                             Revise to
 ;         13          1     Blank
 ;         14-20       8     Code
 ;         21          1     Blank
 ;         22-81      60     Short Description (text) 
 ;         82          1     Blank
 ;         83-End    1-300   Long Description (text) 
 ;         
 Q
EN ; Display ICD-10 Addenda
 N %,%D,%ZIS,AC,ACT,ACT2,ASC,ASIZE,BOLD,BYTE,CAT,CHR,CNT,COD,CODE,CODE2,COL,COM,COMMIT,CON,CONT,CRE,CSVT,CT,CTL,DIR,DIRB
 N DIROUT,DIRUT,DIW,DIWF,DIWI,DIWL,DIWR,DIWT,DIWTC,DIWX,DN,DTOUT,DUOUT,EDAT,EDT,EFF,ENT,ENV,ERR,EXC,EXC2,EXEC,EXIT,FAR
 N FDAT,FDES,FDTS,FEX,FI,FIL,FIL1,FIL2,FIL3,FILE,FILESPEC,FN,FND,FOPEN,FOUT,FSYS,FULL,H,HAS,HD,HDR,HF,HFH,HFN,HFNAME
 N HFOK,HFP,HFV,I,ID,IDAT,IEN,LAST,LEFF,LEX,LEX2,LEXBEG,LEXC,LEXCONT,LEXCT,LEXEOP,LEXI,LEXL,LEXLC,LEXO,LEXR1,LEXR2
 N LEXSTD,LEXT,LEXW,LIN,LINE,LINE2,LONG,MAX,MC,MOD,N,ND,NEW,NM,NOM,NORM,NOT,OK,OPEN,ORD,OUT,OX,PAT,PATH,CLIST,POP,PSN
 N QUIET,REP,RTN,S,SCREEN,SEC,SEG,SEL,SHORT,SHORT2,SHOW,SI,SIEN,SIZE,SM,SMP,SR,SRC,ST,SUB,SYS,TAG,TC,TFILE
 N TFSPEC,TMP,TOT,TPATH,TRL,TT,TTL,TX,TXT,TYP,TYP2,UCI,UFN,UHFNAME,VAL,WIT,X,Y,Z,ZTDESC,ZTDTH,ZTIO,ZTQUEUED,ZTREQ,ZTRTN
 N ZTSAVE,ZTSK D HOME^%ZIS W:$L($G(IOF)) @IOF S ENV=$$ENV Q:'ENV  S LEXBEG=$$NOW^XLFDT W:$L($G(IOF)) @IOF
 W !," Display ICD-10 Addenda"
 S SUB=$$SUB,ERR=0 I $D(^ZZLEXX("ZZLEXXS",$J,"ADDENDA")) D  G ENQ
 . W !!,?4,"ICD-10 Addenda Display is already in progress"
 K TOT S TOT=0 K ^ZZLEXX("ZZLEXXS",$J,"ADDENDA")
 ;   Get Host File Name
 S HFNAME=$$ADDF,UHFNAME=$$UP^XLFSTR(HFNAME) I +HFNAME'>0 D  G ENQ
 . W:$L($P($G(HFNAME),"^",2)) !!,?4,$P($G(HFNAME),"^",2),!
 S:UHFNAME["10CM" NOM="ICD-10-CM",CSVT="Diagnosis",FI=80
 S:UHFNAME["10PCS" NOM="ICD-10-PCS",CSVT="Procedures",FI=80.1
 I '$L($G(NOM)) W !,"Invalid Host File Name" G ENQ
 S:+HFNAME>0&($L($P($G(HFNAME),"^",2))>0) HFNAME=$P($G(HFNAME),"^",2)
 I HFNAME["^" W !!,?4,"Host File not found or not selected",! G ENQ
 S LEFF=$P(HFNAME,".",1),LEFF=$E(LEFF,($L(LEFF)-3),$L(LEFF))
 S:LEFF?4N LEFF=(LEFF-1700)_"1001"
 S TTL="" S:$L($G(NOM)) TTL=$G(NOM) S:$L($G(CSVT)) TTL=TTL_" "_$G(CSVT) S:$L(TTL) TTL=TTL_" Addenda"
 S:$G(LEFF)?7N&($L(TTL)) TTL=TTL_" for "_$$FMTE^XLFDT(LEFF,"5Z") S TTL=$$TM($G(TTL))
 S:$G(LEFF)?7N ^ZZLEXX("ZZLEXXS",$J,"ADDENDA","EFF")=$G(LEFF)
 ;   Brief/Detailed
 K QUIET,CLIST S EXIT=0,TMP=$$BD^ZZLEXXSM S:TMP="B" QUIET=1 S:TMP="D" CLIST=1
 I +EXIT>0!($G(TMP)["^") W !!,?4,"Display Aborted",! K COMMIT,RTN,TEST G ENQ
 ;   Open Host File
 S PATH=$$PATH^ZZLEXXSM,OPEN=$$OPEN^ZZLEXXSM(PATH,HFNAME,"CHK") I +OPEN'>0 D  G ENQ
 . W:$L($P($G(OPEN),"^",2)) !!,?4,$L($P($G(OPEN),"^",2)),! H:$L($P($G(OPEN),"^",2)) 2
 ;   Check Host File
 D READ
 ;   Close Host File
 U IO(0) D CLOSE^ZZLEXXSM("CHK") D TOT D:$D(CLIST) CL S:'$D(MAIN) CONT=$$CONT^ZZLEXXSM
ENQ ; Quit
 K ^ZZLEXX("ZZLEXXS",$J),%,%D
 Q
 ;
READ ; Read from Addenda Files
 Q:'$L($G(HFNAME))  Q:'$L($G(NOM))  Q:'$L($G(CSVT))  Q:+($G(FI))'>0
 W:$L($G(IOF)) @IOF W:$L($G(TTL)) !!,$G(TTL) N SUB,EXIT,HF S SUB=$$SUB,HF=$$UP^XLFSTR(HFNAME)
 W ! S EXIT=0 F  D  S EXIT=$$EOF^ZZLEXXSM Q:EXIT>0
 . N LINE,LINE2,EXC,EXC2,ACT,ACT2,TYP,TYP2,CODE,CODE2,SHORT,SHORT2,LONG,LONG2
 . S EXC="U IO R LINE U IO(0)" X EXC U IO(0) Q:'$L($$TM^ZZLEXXSA(LINE))
 . I HF["10CM" D
 . . S ACT=$$UP^XLFSTR($$TM($E($G(LINE),1,12))),CODE=$$UP^XLFSTR($$TM($E($G(LINE),15,22)))
 . . S CODE=$TR(CODE,".","") S CODE=$E(CODE,1,3)_"."_$E(CODE,4,$L(CODE))
 . . S SHORT=$$TM($E($G(LINE),24,83)),LONG=$$TM($E($G(LINE),85,$L(LINE))),HD=$E($G(LINE),14)
 . I HF["10PCS" D
 . . S ACT=$$UP^XLFSTR($$TM($E($G(LINE),1,12))),CODE=$$UP^XLFSTR($$TM($E($G(LINE),14,21)))
 . . S SHORT=$$TM($E($G(LINE),22,81)),LONG=$$TM($E($G(LINE),83,$L(LINE))),HD=1
 . I $E($G(ACT),1,3)'["ADD",$E($G(ACT),1,6)'["DELETE",$E($G(ACT),1,11)'["REVISE FROM",$E($G(ACT),1,9)'["REVISE TO" Q
 . Q:+($G(HD))'>0  Q:HF["10PCS"&($L($G(CODE))'=7)  Q:HF["10CM"&($G(CODE)'[".")
 . I $E(ACT,1,6)["DELETE" D
 . . N AC S AC="IA" S ^ZZLEXX("ZZLEXXS",$J,"ADDENDA","SM","ACT",AC,(CODE_" "))=$G(CODE)_"^"_$G(SHORT)_"^"_$G(LONG) D WRT
 . I $E(ACT,1,3)["ADD" D
 . . N AC S AC="AD" S ^ZZLEXX("ZZLEXXS",$J,"ADDENDA","SM","ACT",AC,(CODE_" "))=$G(CODE)_"^"_$G(SHORT)_"^"_$G(LONG) D WRT
 . I $E($G(ACT),1,11)["REVISE FROM" D  Q
 . . S EXC2="U IO R LINE2 U IO(0)" X EXC2 U IO(0) Q:'$L($$TM^ZZLEXXSA(LINE2))
 . . I HF["10CM" D
 . . . S ACT2=$$UP^XLFSTR($$TM($E($G(LINE2),1,12))),CODE2=$$UP^XLFSTR($$TM($E($G(LINE2),15,22)))
 . . . S CODE2=$TR(CODE2,".","") S CODE2=$E(CODE2,1,3)_"."_$E(CODE2,4,$L(CODE2))
 . . . S SHORT2=$$TM($E($G(LINE2),24,83)),LONG2=$$TM($E($G(LINE2),85,$L(LINE2))),HD=$E($G(LINE2),14)
 . . I HF["10PCS" D
 . . . S ACT2=$$UP^XLFSTR($$TM($E($G(LINE2),1,12))),CODE2=$$UP^XLFSTR($$TM($E($G(LINE2),14,21)))
 . . . S SHORT2=$$TM($E($G(LINE2),22,81)),LONG2=$$TM($E($G(LINE2),83,$L(LINE2))),HD=1
 . . Q:$G(CODE)'=$G(CODE2)  Q:$E($G(ACT2),1,9)'["REVISE TO"  Q:HF["10PCS"&($L($G(CODE))'=7)  Q:HF["10PCS"&($L($G(CODE2))'=7)
 . . S:$$UP^XLFSTR($G(SHORT))'=$$UP^XLFSTR($G(SHORT2)) AC="SR"
 . . S:$$UP^XLFSTR($G(LONG))'=$$UP^XLFSTR($G(LONG2)) AC="FR"
 . . S:$$UP^XLFSTR($G(SHORT))'=$$UP^XLFSTR($G(SHORT2))&($$UP^XLFSTR($G(LONG))'=$$UP^XLFSTR($G(LONG2))) AC="BR"
 . . S ^ZZLEXX("ZZLEXXS",$J,"ADDENDA","SM","ACT",AC,(CODE_" "))=$G(CODE)_"^"_$G(SHORT)_"^"_$G(LONG) D WRT
 . . I $E($G(ACT),1,9)'["REVISE TO" D  Q
 . . . S EXIT=$$EOF^ZZLEXXSM
 N AC,TT,CT S TT=0,AC="" F  S AC=$O(^ZZLEXX("ZZLEXXS",$J,"ADDENDA","SM","ACT",AC)) Q:$L(AC)'=2  D
 . N ORD S ORD="" F  S ORD=$O(^ZZLEXX("ZZLEXXS",$J,"ADDENDA","SM","ACT",AC,ORD)) Q:'$L(ORD)  D
 . . S ^ZZLEXX("ZZLEXXS",$J,"ADDENDA","CL","TOT",AC)=+($G(^ZZLEXX("ZZLEXXS",$J,"ADDENDA","CL","TOT",AC)))+1
 . . S:"^SR^FR^BR^"[("^"_AC_"^") ^ZZLEXX("ZZLEXXS",$J,"ADDENDA","CL","TOT","RV")=+($G(^ZZLEXX("ZZLEXXS",$J,"ADDENDA","CL","TOT","RV")))+1
 ;
 S CT=+($G(^ZZLEXX("ZZLEXXS",$J,"ADDENDA","CL","TOT","AD")))
 S ^ZZLEXX("ZZLEXXS",$J,"ADDENDA","CL","TOT","AD")=CT,TT=TT+CT
 S:$L($G(NOM)) ^ZZLEXX("ZZLEXXS",$J,"ADDENDA","CL","TOT","AD","N")=($G(NOM)_" Additions")
 ;
 S CT=+($G(^ZZLEXX("ZZLEXXS",$J,"ADDENDA","CL","TOT","BR")))
 S ^ZZLEXX("ZZLEXXS",$J,"ADDENDA","CL","TOT","BR")=CT,TT=TT+1
 S:$L($G(NOM)) ^ZZLEXX("ZZLEXXS",$J,"ADDENDA","CL","TOT","BR","N")=($G(NOM)_" Both Long and Short Text Revised")
 ;
 S CT=+($G(^ZZLEXX("ZZLEXXS",$J,"ADDENDA","CL","TOT","FR")))
 S ^ZZLEXX("ZZLEXXS",$J,"ADDENDA","CL","TOT","FR")=CT,TT=TT+CT
 S:$L($G(NOM)) ^ZZLEXX("ZZLEXXS",$J,"ADDENDA","CL","TOT","FR","N")=($G(NOM)_" Long Text Revised")
 ;
 S CT=+($G(^ZZLEXX("ZZLEXXS",$J,"ADDENDA","CL","TOT","IA")))
 S ^ZZLEXX("ZZLEXXS",$J,"ADDENDA","CL","TOT","IA")=CT,TT=TT+CT
 S:$L($G(NOM)) ^ZZLEXX("ZZLEXXS",$J,"ADDENDA","CL","TOT","IA","N")=($G(NOM)_" Inactivations")
 ;
 S CT=+($G(^ZZLEXX("ZZLEXXS",$J,"ADDENDA","CL","TOT","RV")))
 S ^ZZLEXX("ZZLEXXS",$J,"ADDENDA","CL","TOT","RV")=CT
 S:$L($G(NOM)) ^ZZLEXX("ZZLEXXS",$J,"ADDENDA","CL","TOT","RV","N")=($G(NOM)_" Revisions")
 ;
 S CT=+($G(^ZZLEXX("ZZLEXXS",$J,"ADDENDA","CL","TOT","SR")))
 S ^ZZLEXX("ZZLEXXS",$J,"ADDENDA","CL","TOT","SR")=CT,TT=TT+CT
 S:$L($G(NOM)) ^ZZLEXX("ZZLEXXS",$J,"ADDENDA","CL","TOT","SR","N")=($G(NOM)_" Short Text Revised")
 S:+TT>0 ^ZZLEXX("ZZLEXXS",$J,"ADDENDA","CL","TOT")=TT
 Q
WRT ; Write from Addenda Files
 Q:$D(QUIET)  Q:'$L($G(CODE))  Q:'$L($G(SHORT))  Q:'$L($G(LONG))  Q:'$L($G(ACT))  Q:$L($G(AC))'=2
 I $E(ACT,1,6)["DELETE" D  Q
 . N TX,I W !!,$G(CODE),?9,AC
 . S TX(1)=$G(LONG) D PR^ZZLEXXSM(.TX,(78-14)) W ?13,$G(TX(1))
 . S I=1 F  S I=$O(TX(I)) Q:+I'>0  W !,?13,"  ",$G(TX(I))
 I $E(ACT,1,3)["ADD" D  Q
 . N TX,I W !!,$G(CODE),?9,AC,?13,$G(SHORT)
 . S TX(1)=$G(LONG) D PR^ZZLEXXSM(.TX,(78-14)) W !,?13,$G(TX(1))
 . S I=1 F  S I=$O(TX(I)) Q:+I'>0  W !,?13,"  ",$G(TX(I))
 I $E($G(ACT),1,11)["REVISE FROM",$E($G(ACT2),1,9)["REVISE TO" D  Q
 . I AC="BR" D
 . . N TX,I W !!,$G(CODE),?9,AC,?13,$G(SHORT),!,?13,$G(SHORT2)
 . . K TX S TX(1)=$G(LONG) D PR^ZZLEXXSM(.TX,(78-14)) W !,?13,$G(TX(1))
 . . S I=1 F  S I=$O(TX(I)) Q:+I'>0  W !,?13,"  ",$G(TX(I))
 . . K TX S TX(1)=$G(LONG2) D PR^ZZLEXXSM(.TX,(78-14)) W !,?13,$G(TX(1))
 . . S I=1 F  S I=$O(TX(I)) Q:+I'>0  W !,?13,"  ",$G(TX(I))
 . I AC="SR" D
 . . N TX,I W !!,$G(CODE),?9,AC,?13,$G(SHORT),!,?13,$G(SHORT2)
 . I AC="FR" D
 . . N TX,I W !!,$G(CODE),?9,AC
 . . K TX S TX(1)=$G(LONG) D PR^ZZLEXXSM(.TX,(78-14)) W ?13,$G(TX(1))
 . . S I=1 F  S I=$O(TX(I)) Q:+I'>0  W !,?13,"  ",$G(TX(I))
 . . K TX S TX(1)=$G(LONG2) D PR^ZZLEXXSM(.TX,(78-14)) W !,?13,$G(TX(1))
 . . S I=1 F  S I=$O(TX(I)) Q:+I'>0  W !,?13,"  ",$G(TX(I))
 Q
 ; 
 ; Miscellaneous
ADDF(X) ;   Addenda Host File
 N HAS,HFV,NOT,PATH K ^ZZLEXX("ZZLEXXS",$J,"MS") S HAS="ICD10;ORDER;ADDENDA",NOT=""
 S PATH=$$PATH^ZZLEXXSM D DIR^ZZLEXXSM(PATH,NOT,HAS) S X=$$SEL^ZZLEXXSM K ^ZZLEXX("ZZLEXXS",$J,"MS")
 Q X
TOT ;   Report Totals
 N ACT,TTL,TT,TC S TTL=$O(CNT("")) S (TT,TC)=0 F ACT="AD","IA","SR","FR","BR" D
 . N VAL S VAL=+($G(^ZZLEXX("ZZLEXXS",$J,"ADDENDA","CL","TOT",ACT))) Q:+VAL'>0  S TC=TC+1,TT=TT+VAL
 W:'$D(QUIET) ! W !,?1,"Total Changes found:" W:TT'>0 !!,?4,"None" Q:TT'>0  W:TT>0&(TC>1) ?43,$J(TT,6)
 W:TT>0 ! F ACT="AD","IA","RV","SR","FR","BR" D
 . N TTL,VAL S TTL=$$EACT(ACT),VAL=+($G(^ZZLEXX("ZZLEXXS",$J,"ADDENDA","CL","TOT",ACT)))
 . W:"^SR^FR^BR^"[("^"_ACT_"^") !,?6,TTL,?43,$J(VAL,6)
 . W:"^SR^FR^BR^"'[("^"_ACT_"^") !,?4,TTL,?43,$J(VAL,6)
 W !
 Q
CL ;   Code Listing
 W !," Code Listing "
 N COL,TYP S COL=0,TYP="" F  S TYP=$O(^ZZLEXX("ZZLEXXS",$J,"ADDENDA","SM","ACT",TYP)) Q:'$L(TYP)  D
 . N ORD S ORD="" F  S ORD=$O(^ZZLEXX("ZZLEXXS",$J,"ADDENDA","SM","ACT",TYP,ORD)) Q:'$L(ORD)  D
 . . N ACT,COD,EFF,FIL,IEN,NEW,ND
 . . S ND=$G(^ZZLEXX("ZZLEXXS",$J,"ADDENDA","SM","ACT",TYP,ORD)) S ACT=TYP Q:$L(ACT)'=2
 . . S COD=$P(ND,"^",1) Q:'$L(COD)
 . . S FIL=$E((COD_"            "),1,10) Q:'$L(FIL)
 . . S NEW=ACT S:NEW="SR"!(NEW="FR")!(NEW="BR") NEW="RV"
 . . Q:"^AD^IA^SR^FR^BR^"'[("^"_ACT_"^")
 . . Q:"^AD^IA^RV^"'[("^"_NEW_"^")
 . . I '$D(^ZZLEXX("ZZLEXXS",$J,"ADDEDNA","CL","ACT",ACT)) D
 . . . S EFF=$G(^ZZLEXX("ZZLEXXS",$J,"ADDENDA","EFF")) Q:EFF'?7N  S ^ZZLEXX("ZZLEXXS",$J,"ADDENDA","CL","ACT",ACT,"EFF")=("Effective "_$$FMTE^XLFDT(EFF))
 . . S ^ZZLEXX("ZZLEXXS",$J,"ADDEDNA","CL","ACT",ACT,"TOT")=$G(^ZZLEXX("ZZLEXXS",$J,"ADDEDNA","CL","ACT",ACT,"TOT"))+1
 . . S ^ZZLEXX("ZZLEXXS",$J,"ADDEDNA","CL","ACT",ACT,"ORD",ORD)=FIL
 . . I NEW="RV",'$D(^ZZLEXX("ZZLEXXS",$J,"ADDEDNA","CL","ACT",NEW)) D
 . . . S EFF=$G(^ZZLEXX("ZZLEXXS",$J,"ADDENDA","EFF")) Q:EFF'?7N  S ^ZZLEXX("ZZLEXXS",$J,"ADDENDA","CL","ACT",NEW,"EFF")=("Effective "_$$FMTE^XLFDT(EFF))
 . . S:NEW="RV" ^ZZLEXX("ZZLEXXS",$J,"ADDEDNA","CL","ACT",NEW,"TOT")=$G(^ZZLEXX("ZZLEXXS",$J,"ADDEDNA","CL","ACT",NEW,"TOT"))+1
 . . S:NEW="RV" ^ZZLEXX("ZZLEXXS",$J,"ADDEDNA","CL","ACT",NEW,"ORD",ORD)=FIL
 F NEW="AD","IA","RV","SR","FR","BR" D
 . N CLT,COL S (CLT,COL)=0 S ORD="" F  S ORD=$O(^ZZLEXX("ZZLEXXS",$J,"ADDEDNA","CL","ACT",NEW,"ORD",ORD)) Q:'$L(ORD)  D
 . . N FIL,STR S FIL=$G(^ZZLEXX("ZZLEXXS",$J,"ADDEDNA","CL","ACT",NEW,"ORD",ORD)),CLT=CLT+1
 . . S COL=COL+1 I COL=1 S IEN=$O(^ZZLEXX("ZZLEXXS",$J,"ADDEDNA","CL","ACT",NEW,"LIST"," "),-1)+1 D  Q
 . . . S ^ZZLEXX("ZZLEXXS",$J,"ADDEDNA","CL","ACT",NEW,"LIST",IEN)="         "_FIL S COL=1
 . . S IEN=+($O(^ZZLEXX("ZZLEXXS",$J,"ADDEDNA","CL","ACT",NEW,"LIST"," "),-1))
 . . S STR=$G(^ZZLEXX("ZZLEXXS",$J,"ADDEDNA","CL","ACT",NEW,"LIST",IEN))_FIL
 . . S ^ZZLEXX("ZZLEXXS",$J,"ADDEDNA","CL","ACT",NEW,"LIST",IEN)=STR
 . . S:COL>6 COL=0
 . S:+CLT>0 ^ZZLEXX("ZZLEXXS",$J,"ADDENDA","CL","ACT",NEW,"TOT")=CLT
 D CLOUT
 Q
CLOUT ;   Code Listing Output
 N ACT,CAT,EFF,IEN,LIN,SEC,STR,TOT F ACT="AD","IA","RV","SR","FR","BR" D
 . N IEN,CAT,SEC,LIN,EFF,TOT S CAT="" S:ACT="AD" CAT="Additions"
 . S:ACT="IA" CAT="Inactivations" S:ACT="RU" CAT="Re-Used"
 . S:ACT="RV" CAT="Revisions" S:ACT="RA" CAT="Reactivations"
 . S:ACT="SR" CAT="Short Text Revised"
 . S:ACT="FR" CAT="Long Text Revised"
 . S:ACT="BR" CAT="Both Short/Long Text Revised"
 . S SEC=$G(NOM)_" "_$G(CSVT)_" "_CAT
 . S TOT=$G(^ZZLEXX("ZZLEXXS",$J,"ADDENDA","CL","ACT",ACT,"TOT")) Q:+TOT'>0
 . S LIN="",$P(LIN,"-",$L(SEC))="-" S:$L(LIN) LIN="     "_LIN S:$L(SEC) SEC="     "_SEC
 . W:$L(CAT) !!,SEC,!,LIN,!
 . S:+TOT>0 TOT="("_+TOT_" code"_$S(+TOT>1:"s",1:"")_")"
 . S EFF=$G(^ZZLEXX("ZZLEXXS",$J,"ADDENDA","CL","ACT",ACT,"EFF"))
 . S:$G(TOT)["(" EFF=EFF_$J("",(51-$L(EFF)))_$J($G(TOT),11)
 . I $L(EFF) W !,"       ",EFF
 . S IEN=0 F  S IEN=$O(^ZZLEXX("ZZLEXXS",$J,"ADDEDNA","CL","ACT",ACT,"LIST",IEN)) Q:+IEN'>0  D
 . . N STR S STR=$G(^ZZLEXX("ZZLEXXS",$J,"ADDEDNA","CL","ACT",ACT,"LIST",IEN))
 . . W !,$$TL(STR)
 Q
TM(X,Y) ;   Trim Character Y - Default " " Space
 S X=$G(X) Q:X="" X  S Y=$G(Y) S:'$L(Y) Y=" "
 F  Q:$E(X,1)'=Y  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=Y  S X=$E(X,1,($L(X)-1))
 Q X
TL(X) ;   Strip Trailing Spaces
 S X=$G(X) F  Q:$E(X,$L(X))'=" "  S X=$E(X,1,($L(X)-1))
 Q X
EACT(X) ;   External Action
 Q:$G(X)="AD" "Additions"  Q:$G(X)="SR" "Short Text Revisions"  Q:$G(X)="FR" "Long Text Revisions"  Q:$G(X)="BR" "Long/Short Text Revisions"
 Q:$G(X)="RA" "Re-Activations"  Q:$G(X)="RU" "Re-Used"  Q:$G(X)="RV" "Revisions"  Q:$G(X)="IA" "Inactivations"  Q:$G(X)="NC" "Codes with No Change"
 Q " "
KILL ;   Kill Global
 K ^ZZLEXX("ZZLEXXS",$J),%,%D
 Q
SUB(X) ;   Load Subscript
 Q ($$LR_"L")
LR(X) ;   Local Routine
 S X=$T(+1),X=$P(X," ",1) Q X
ENV(X) ;   Environment
 D HOME^%ZIS S U="^",DT=$$DT^XLFDT,DTIME=300 K POP
 N NM S NM=$$GET1^DIQ(200,(DUZ_","),.01)
 I '$L(NM) W !!,?5,"Invalid/Missing DUZ" Q 0
 S:$G(DUZ(0))'["@" DUZ(0)=$G(DUZ(0))_"@"
 Q 1
