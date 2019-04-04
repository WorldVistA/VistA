ZZLEXXBA ;SLC/KER - Import - ICD-10-PCS - Read ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^LEX(757.01         SACC 1.3
 ;    ^LEX(757.02         SACC 1.3
 ;    ^LEX(757.11         SACC 1.3
 ;    ^LEX(757.12         SACC 1.3
 ;    ^ZZLEXX("ZZLEXXB"   SACC 1.3
 ;               
 ; External References
 ;    HOME^%ZIS           ICR  10086
 ;    $$OS^%ZOSV          ICR   3522
 ;    $$GET1^DIQ          ICR   2056
 ;    $$STATCHK^LEXSRC2   N/A
 ;    $$DT^XLFDT          ICR  10103
 ;    $$FMDIFF^XLFDT      ICR  10103
 ;    $$FMTE^XLFDT        ICR  10103
 ;    $$NOW^XLFDT         ICR  10103
 ;    $$UP^XLFSTR         ICR  10104
 ;               
 ; Data Source
 ;               
 ;   CMS Medicare
 ;   > ICD-10
 ;     > 2017 ICD-10-PCS and GEMs
 ;       Note, year will change
 ;       > 2017 Code Descriptions in Tabular Order (ZIP)
 ;         Note, year will change
 ;         > icd10pcs_order_2017.txt
 ;           Note, year will change
 ;               
 ; Data Format
 ; 
 ;    Sequential text file.  Each line is formatted as follow:
 ;    
 ;    Start  Length  Content
 ;      1      5     Sequential number with leading zeros (not
 ;                   used by VistA)
 ;      6      1     Blank
 ;      7      7     ICD-10-PCS Code 
 ;     14      1     Blank
 ;     15      1     Code/Header flag (boolean)
 ;                     1 - is an ICD-10 code, valid for 
 ;                         submission for HIPAA covered 
 ;                         transactions.  Load into the 
 ;                         Procedure file #80.1.
 ;                     0 - is a header code, it is NOT 
 ;                         valid for HIPAA covered 
 ;                         transactions.  Do not load 
 ;                         "0"s in the Procedure file 
 ;                         #80.1.
 ;     16      1     Blank
 ;     17     60     Short Description (text) will need to be
 ;                   trimed of leading and trailing spaces, 
 ;                   converted to uppercase and formatted to
 ;                   store in the ICD Procedure file #80.1, 
 ;                   Operation/Procedure sub-file #80.167, 
 ;                   field #1, 1-60 characters in length.
 ;     77      1     Blank
 ;     78     End    Long Description (text) will need to be
 ;                   trimed of leading and trailing spaces,
 ;                   converted to uppercase and formatted to
 ;                   store in the ICD Procedure file #80.1, 
 ;                   Description sub-file #80.168, field #1,
 ;                   1-245 characters in length.
 ; 
 Q
LOAD ; Load ICD-10-PCS Codes and Descriptions
 N %,%D,%ZIS,AC,ACT,ASC,ASIZE,BEG,BOLD,BYTE,CDT,CLIST,CHR,CNT,CODE,CODES,COMMIT,CON,CRE,CT,CTL,DA,DEFF,DHIS,DIEN,DIR,DIRB,DIROUT,DIRUT,DIW
 N DIWF,DIWI,DIWL,DIWR,DIWT,DIWTC,DIWX,DN,DSUP,DTOUT,DTXT,DUOUT,EACT,EBEG,EDAT,EDT,EEND,EFF,EFFD,EIEN,END,ENT,ENV,ERR,EX,EXC,EXCL
 N EXEC,EXIT,EXM,EXP,FAR,FD,FDA,FDAI,FDAT,FDES,FDTS,FEX,FI,FIL1,FIL2,FIL3,FILE,FILESPEC,FLAG,FLTXD,FLTXT,FN,FND,FOPEN,FOUT,FQ,FRE,FREQ
 N FSTAD,FSTAT,FSTXD,FSTXT,FSYS,FULL,FY,H,HAS,HDR,HF,HFH,HFN,HFNAME,HFOK,HFP,HFV,HIEN,HIS,HR,I,IC,ID,IDAT,IEN,IENS,IN,KEY,KEYS,KEYW,KIEN
 N LAS,LAST,LEFF,LEX2,LEXA,LEXBEG,LEXC,LEXCHK,LEXCONT,LEXCT,LEXCTL,LEXD,LEXDF,LEXE,LEXELP,LEXEND,LEXEOP,LEXEX,LEXEXP,LEXFN,LEXFSC,LEXFSM
 N LEXFST,LEXHF,LEXI,LEXIEN,LEXINC,LEXL,LEXLC,LEXLSC,LEXLSM,LEXLST,LEXMC,LEXMCO,LEXME,LEXN,LEXO,LEXORD,LEXORG,LEXR1,LEXR2,LEXS,LEXSC
 N LEXSID,LEXSRC,LEXST,LEXT,LEXTEFF,LEXTHIS,LEXTSTA,LEXTSTD,LEXW,LIEN,LINE,LLTXD,LLTXT,LSTAD,LSTAT,LSTXD,LSTXT,LSUP,LTXT,MAX,MC,MIEN,MOD
 N N,ND,NM,NORM,NOT,ODAT,OF,OIEN,OK,OLDD,OLDE,OLDS,OPEN,ORD,OUT,PAT,PATH,PD,PEFF,PIEN,PLTX,POP,PSN,PSTA,PSTX,QUIET,REP,RTN,S,SAB,SC,SCREEN,SEFF
 N SEG,SEL,SEQ,SF,SHOW,SI,SIEN,SIZE,SM,SMP,SO,SR,SRC,ST,STA,STAT,STXT,SYS,TA,TAG,TC,TD,TEFF,TERM,TEST,TESTK,TEXIEN,TFILE,TFSPEC,THIS,TI
 N TIEN,TMCIEN,TMP,TOT,TPATH,TRL,TSMIEN,TSOIEN,TSTA,TSTD,TT,TTL,TX,TXI,TXT,TYPE,UCI,UFN,VAL,WIT,X,Y,YR,Z,ZTDESC,ZTDTH,ZTIO,ZTQUEUED,ZTREQ
 N ZTRTN,ZTSAVE,ZTSK D HOME^%ZIS W:$L($G(IOF)) @IOF S ENV=$$ENV Q:'ENV  S LEXBEG=$$NOW^XLFDT
 W !," Update ICD-10-PCS Codes Set fields"
 S (TESTK,ERR)=0 I $D(^ZZLEXX("ZZLEXXB",$J)) D  Q
 . W !!,?4,"ICD-10-PCS load of codes and text is already in progress"
 . W !,?4,"Temporary global ^ZZLEXX(""ZZLEXXB"",$J) exist",! K COMMIT,RTN
 W ":",!!,"    .01       CODE NUMBER"
 W !,"    1.1       CODING SYSTEM",!,"    66        STATUS"
 W !,"    67        OPERATION/PROCEDURE",!,"    68        DESCRIPTION"
 S (TESTK,ERR)=0 K TOT S TOT=0 K ^ZZLEXX("ZZLEXXB",$J) S:'$D(TEST) TESTK=1
 ;   Get Host File Name
 S HFNAME=$$ICDF I +HFNAME'>0 D  Q
 . W:$L($P($G(HFNAME),"^",2)) !!,?4,$P($G(HFNAME),"^",2),! K COMMIT,RTN
 S:+HFNAME>0&($L($P($G(HFNAME),"^",2))>0) HFNAME=$P($G(HFNAME),"^",2)
 I HFNAME["^" W !!,?4,"Host File not found or not selected",! K COMMIT,RTN Q
 ;   Get Effective Date
 S LEFF=$$EFF^ZZLEXXBP(HFNAME) I LEFF'?7N W !!,?4,"Effective Date not selected",! K COMMIT,RTN Q
 ;   Get Test Load  TEST
 I '$D(TEST) S TMP=$$TL^ZZLEXXBP(HFNAME) S:TMP>0 TEST="" I TMP["^" W !!,?4,"Load Aborted",! K COMMIT,RTN K:$G(TESTK)>0 TEST Q
 ;   Get Update     COMMIT
 I '$D(TEST),'$D(COMMIT) I TMP'>0,'$D(TEST) S TMP=$$CM^ZZLEXXBP(HFNAME) S:TMP>0 COMMIT="" I TMP["^" W !!,?4,"Load Aborted",! K COMMIT,RTN K:$G(TESTK)>0 TEST Q
 K:$D(TEST) COMMIT
 I '$D(TEST),'$D(COMMIT) W !!,?4,"Neither a ""Test"" load nor an ""Actual"" load was selected",! K COMMIT,TEST,RTN Q
 S TMP=$$WAR^ZZLEXXBP(HFNAME) I +($G(TMP))'>0 W !!,?4,"Load Aborted",! K COMMIT,RTN K:$G(TESTK)>0 TEST Q
 K CLIST,QUIET S EXIT=0 I $D(TEST),'$D(COMMIT) D
 . N TMP S TMP=$$BD^ZZLEXXAP S:TMP="B" QUIET=1 S:TMP="D" CLIST=1 S:TMP["^" EXIT=1
 I +EXIT>0 W !!,?4,"Load Aborted",! K COMMIT,RTN K:$G(TESTK)>0 TEST Q
 ;   Open Host File
 S PATH=$$PATH^ZZLEXXBM,OPEN=$$OPEN^ZZLEXXBM(PATH,HFNAME,"CHK") I +OPEN'>0 D  Q
 . W:$L($P($G(OPEN),"^",2)) !!,?4,$L($P($G(OPEN),"^",2)) K:$G(TESTK)>0 TEST K COMMIT,RTN
 ;   Check Host File
 W:$D(COMMIT)!($D(QUIET)) !!,?1,"Get Data  ",!
 I $D(COMMIT)!($D(QUIET)) D
 . W !,?3,"Get AD, RA, RU, SR, FR, and BR from host file  ",!
 . W !,?3,"    AD   Added Codes"
 . W !,?3,"    RA   Re-Activated Codes"
 . W !,?3,"    RU   Re-Used Codes"
 . W !,?3,"    SR   Codes with revised short descriptions"
 . W !,?3,"    FR   Codes with revised long descriptions"
 . W !,?3,"    BR   Codes with both revised short and long descriptions",!
 D NTO^ZZLEXXBB
 ;   Close Host File
 U IO(0) D CLOSE^ZZLEXXBM("CHK")
 ;   Check ICD File
 I $D(COMMIT)!($D(QUIET)) D
 . W !,?3,"Get IA from ICD Procedure global  ",!
 . W !,?3,"    IA   Inactivated Codes"
 D:+($G(ERR))'>0 OTN^ZZLEXXBB
 N ORD S EXIT=0,ORD="" F  S ORD=$O(^ZZLEXX("ZZLEXXB",$J,"ICD",ORD)) Q:'$L(ORD)  Q:EXIT  D  Q:EXIT
 . I '$D(^ZZLEXX("ZZLEXXB",$J,"ICD",ORD,"AC")) D  Q
 . . D ERR(("Action Code not set "_$G(ORD)),$$TM(ORD)) S ERR=+($G(ERR))+1,EXIT=1
 . N ACT,EACT S ACT=$G(^ZZLEXX("ZZLEXXB",$J,"ICD",ORD,"AC")),EACT=$$EACT(ACT) I '$L(EACT) D  Q
 . . D ERR(("Invalid Action Code """_EACT_""" for "_$G(ORD)),$$TM(ORD))
 . . S ERR=+($G(ERR))+1,EXIT=1
 ;   Errors Detected
 I +ERR>0!($G(^ZZLEXX("ZZLEXXB",$J,"ERR",0))>0) D  Q
 . W !!," Fix errors in ",$G(HFNAME)," then retry",! K ^ZZLEXX("ZZLEXXB",$J),COMMIT,RTN K:$G(TESTK)>0 TEST
 ;   No Changes Detected
 I '$D(^ZZLEXX("ZZLEXXB",$J,"ICD")) D  Q
 . W !!," Nothing loaded, re-check the host file and retry",! K ^ZZLEXX("ZZLEXXB",$J),COMMIT,RTN K:$G(TESTK)>0 TEST
 ;   Process Data
 D:$D(SHOW) SHO
 W:$D(COMMIT) !!,?1,"Save Data  ",!
 D CNT K CNT("NC") I $D(COMMIT),$L($O(CNT(""))) D
 . W:+($G(CNT("AD")))>0 !,?5,"AD  Added Codes"
 . W:+($G(CNT("IA")))>0 !,?5,"IA  Inactivated Codes "
 . W:+($G(CNT("RA")))>0 !,?5,"RA  Re-activated Codes "
 . W:+($G(CNT("RU")))>0 !,?5,"RU  Re-used Codes  "
 . W:+($G(CNT("SR")))>0 !,?5,"SR  Revised Short Description "
 . W:+($G(CNT("FR")))>0 !,?5,"FR  Revised Long Description Revision  "
 . W:+($G(CNT("BR")))>0 !,?5,"BR  Revised both Short and Long Description"
 . W !,?5,"SP  Supplemental Keywords  "
 N SHOW D:'$D(TEST) FILE^ZZLEXXBC I $D(COMMIT) D
 . N QUIET,DONE S (QUIET,DONE)="" W:$D(COMMIT) !!,?1,"Update Coding Systems file #757.03  "
 . D EN^ZZLEXXMD
 ;   Display Load Totals
 K CNT D CNT,SEND^ZZLEXXBZ,TOT D:$D(CLIST) CL^ZZLEXXBF D END
 K:$G(TESTK)>0 TEST D KILL
 Q
 ;
 ; Host File
ICDF(X) ;   ICD Pr Host File
 N HAS,HFV,NOT,PATH K ^ZZLEXX("ZZLEXXBM",$J) S HAS="ICD;PCS;10;ORDER",NOT="ADDENDA"
 S PATH=$$PATH^ZZLEXXBM D DIR^ZZLEXXBM(PATH,NOT,HAS) S X=$$SEL^ZZLEXXBM K ^ZZLEXX("ZZLEXXBM",$J)
 Q X
 ; 
 ; Miscellaneous
ERR(X,Y) ;   Error
 N I,TXT,ERR,EXP,CODE S ERR=$G(X),CODE=$G(Y) S TXT=$$TM(ERR)
 S:$L(CODE)&(TXT'[CODE) TXT=TXT_" ("_CODE_")" S I=$O(^ZZLEXX("ZZLEXXB",$J,"ERR"," "),-1)+1
 S ^ZZLEXX("ZZLEXXB",$J,"ERR",I)=TXT S ^ZZLEXX("ZZLEXXB",$J,"ERR",0)=I W !!,">>>>> Error:  ",ERR
 Q
PUR ;   Purge
 N ORD S ORD="" F  S ORD=$O(^ZZLEXX("ZZLEXXB",$J,"ICD",ORD)) Q:'$L(ORD)  D
 . K:$G(^ZZLEXX("ZZLEXXB",$J,"ICD",ORD,"AC"))="NC" ^ZZLEXX("ZZLEXXB",$J,"ICD",ORD)
 Q
WRT ;   Write Findings
 Q:$D(QUIET)  Q:'$D(TEST)  Q:$G(LEFF)'?7N  Q:$G(ACT)="NC"  N TA,EACT
 S EACT=$$TM(("ICD Pr "_$$EACT($G(ACT))),"s")
 W !!," ",$G(CODE),?21,$G(ACT),?26,EACT,?60,$$FMTE^XLFDT($G(LEFF))
 ;     Write Inactive
 I $G(ACT)="IA" D  Q
 . N FSTXD,FSTXT,FLTXD,FLTXT,LEXD,LEXT
 . S FSTXD=$G(^ZZLEXX("ZZLEXXB",$J,"ICD",(CODE_" "),"SD","FILE"))
 . S FSTXT=$G(^ZZLEXX("ZZLEXXB",$J,"ICD",(CODE_" "),"ST","FILE"))
 . S FLTXD=$G(^ZZLEXX("ZZLEXXB",$J,"ICD",(CODE_" "),"LD","FILE"))
 . S FLTXT=$G(^ZZLEXX("ZZLEXXB",$J,"ICD",(CODE_" "),"LT","FILE"))
 . S LEXD=$G(^ZZLEXX("ZZLEXXB",$J,"ICD",(CODE_" "),"LX","EFFD"))
 . S LEXT=$G(^ZZLEXX("ZZLEXXB",$J,"ICD",(CODE_" "),"LX","EXPR"))
 . I $G(FSTXD)?7N&($L($G(FSTXT))) W !,"  Short Description:",!,"    ",$$FMTE^XLFDT($G(FSTXD),"5Z"),?16,$G(FSTXT)
 . I $G(FLTXD)?7N&($L($G(FLTXT))) W !,"  Long Description:"  D
 . . K TA N I S TA(1)=$G(FLTXT) D PR^ZZLEXXBM(.TA,(78-16)) W !,"    ",$$FMTE^XLFDT($G(FLTXD),"5Z"),?16,$G(TA(1))
 . . S I=1 F  S I=$O(TA(I)) Q:+I'>0  W !,?16,$G(TA(I))
 . Q  I $G(LEXD)?7N&($L($G(LEXT))) W !,"  Lexicon Expression:"  D
 . . K TA N I S TA(1)=$G(LEXT) D PR^ZZLEXXBM(.TA,(78-16)) W !,"    ",$$FMTE^XLFDT($G(LEXD),"5Z"),?16,$G(TA(1))
 . . S I=1 F  S I=$O(TA(I)) Q:+I'>0  W !,?16,$G(TA(I))
 ;     Write Active
 I $G(ACT)'="IA" D
 . N FSTXD,FSTXT,FLTXD,FLTXT,LEFF,LSTXD,LSTXT,LLTXD,LLTXT,LEXLSC,LEXLST,LEXD,LEXT,LEXN,LEXE,TA
 . S FSTXD=$G(^ZZLEXX("ZZLEXXB",$J,"ICD",(CODE_" "),"SD","FILE"))
 . S FSTXT=$G(^ZZLEXX("ZZLEXXB",$J,"ICD",(CODE_" "),"ST","FILE"))
 . S FLTXD=$G(^ZZLEXX("ZZLEXXB",$J,"ICD",(CODE_" "),"LD","FILE"))
 . S FLTXT=$G(^ZZLEXX("ZZLEXXB",$J,"ICD",(CODE_" "),"LT","FILE"))
 . S LSTXD=$G(^ZZLEXX("ZZLEXXB",$J,"ICD",(CODE_" "),"SD","LOAD"))
 . S LSTXT=$G(^ZZLEXX("ZZLEXXB",$J,"ICD",(CODE_" "),"ST","LOAD"))
 . S LLTXD=$G(^ZZLEXX("ZZLEXXB",$J,"ICD",(CODE_" "),"LD","LOAD"))
 . S LLTXT=$G(^ZZLEXX("ZZLEXXB",$J,"ICD",(CODE_" "),"LT","LOAD"))
 . S LEXLSC=$G(^ZZLEXX("ZZLEXXB",$J,"ICD",(CODE_" "),"LX","SMSC"))
 . S LEXLST=$G(^ZZLEXX("ZZLEXXB",$J,"ICD",(CODE_" "),"LX","SMST"))
 . S LEXE=$G(^ZZLEXX("ZZLEXXB",$J,"ICD",(CODE_" "),"LX","LOAD"))
 . S LEXN=$G(^ZZLEXX("ZZLEXXB",$J,"ICD",(CODE_" "),"LX","NEWT"))
 . S LEXD=$G(^ZZLEXX("ZZLEXXB",$J,"ICD",(CODE_" "),"LX","EFFD"))
 . S LEFF=$G(^ZZLEXX("ZZLEXXB",$J,"ICD",(CODE_" "),"AD","LOAD"))
 . S LEXT=$G(^ZZLEXX("ZZLEXXB",$J,"ICD",(CODE_" "),"LX","EXPR"))
 . I $G(ACT)="RA"!($G(ACT)="RU") D  Q:$G(ACT)="RA"
 . . N STA,INA,EFF
 . . S STA=$G(^ZZLEXX("ZZLEXXB",$J,"ICD",(CODE_" "),"AS","FILE"))
 . . S INA=$G(^ZZLEXX("ZZLEXXB",$J,"ICD",(CODE_" "),"AD","FILE"))
 . . S EFF=$G(LEFF)
 . . I STA'>0,INA?7N,EFF?7N,EFF>INA,$G(ACT)="RA" D
 . . . W !,"  Inactivated:",?17,$$FMTE^XLFDT($G(INA),"5Z")
 . . . W !,"  Re-Activated:",?17,$$FMTE^XLFDT($G(EFF),"5Z")
 . . I STA'>0,INA?7N,EFF?7N,EFF>INA,$G(ACT)="RU" D  Q
 . . . W !,"  Inactivated:",?17,$$FMTE^XLFDT($G(INA),"5Z")
 . . . W !,"  Re-Used:",?17,$$FMTE^XLFDT($G(EFF),"5Z")
 . . I $G(LLTXD)?7N,$L($G(LLTXT)) D
 . . . W !,"  Description:"
 . . . N TA,I K TA S TA(1)=$G(LLTXT) D PR^ZZLEXXBM(.TA,(78-17)) W ?17,$G(TA(1)) W:$O(TA(1))>0 !
 . . . S I=1 F  S I=$O(TA(I)) Q:+I'>0  W ?17,$G(TA(I)) W:$O(TA(I))>0 !
 . I $$TX($G(FSTXT))'=$$TX($G(LSTXT)),$G(ACT)'="RA" D
 . . I ($G(LSTXD)?7N&($L($G(LSTXT))))!($G(FSTXD)?7N&($L($G(FSTXT)))) W !,"  Short Description:"
 . . I $G(LSTXD)?7N&($L($G(LSTXT))) W !,"    ",$$FMTE^XLFDT($G(LSTXD),"5Z"),?16,$G(LSTXT)
 . . I $G(FSTXD)?7N&($L($G(FSTXT))) W !,"    ",$$FMTE^XLFDT($G(FSTXD),"5Z"),?16,$G(FSTXT)
 . I $$TX($G(FLTXT))'=$$TX($G(LLTXT)),$G(ACT)'="RA" D
 . . I ($G(FLTXD)?7N&($L($G(FLTXT))))!($G(LLTXD)?7N&($L($G(LLTXT)))) W !,"  Long Description:"
 . . I $G(LLTXD)?7N&($L($G(LLTXT))) D
 . . . K TA N I S TA(1)=$G(LLTXT) D PR^ZZLEXXBM(.TA,(78-16))
 . . . W !,"    ",$$FMTE^XLFDT($G(LLTXD),"5Z"),?16,$G(TA(1))
 . . . S I=1 F  S I=$O(TA(I)) Q:+I'>0  W !,?16,$G(TA(I))
 . . I $G(FLTXD)?7N&($L($G(FLTXT))) D
 . . . K TA N I S TA(1)=$G(FLTXT) D PR^ZZLEXXBM(.TA,(78-16))
 . . . W !,"    ",$$FMTE^XLFDT($G(FLTXD),"5Z"),?16,$G(TA(1))
 . . . S I=1 F  S I=$O(TA(I)) Q:+I'>0  W !,?16,$G(TA(I))
 . Q  I ($G(FLTXD)?7N&($L($G(FLTXT))))!($G(LLTXD)?7N&($L($G(LLTXT)))) D
 . . I $$TX($G(LEXT))'=$$TX($G(LEXN)),$L(LEXN),$L($G(LEXT)),$L($G(LEXD)),$G(LEXD)?7N D
 . . . Q:$$TX($G(LEXT))=$$TX($G(LEXN))
 . . . W !,"  Lexicon Expression:"
 . . . I LEFF?7N,$L(LEXN) D
 . . . . N TA,I K TA S TA(1)=$G(LEXN) D PR^ZZLEXXBM(.TA,(78-16))
 . . . . W !,"    ",$$FMTE^XLFDT($G(LEFF),"5Z"),?16,$G(TA(1))
 . . . . S I=1 F  S I=$O(TA(I)) Q:+I'>0  W !,?16,$G(TA(I))
 . . . I LEXD?7N,$L(LEXT) D
 . . . . Q:LEFF=LEXD&($$TX(LEXN)=$$TX(LEXT))
 . . . . N TA,I K TA S TA(1)=$G(LEXT) D PR^ZZLEXXBM(.TA,(78-16))
 . . . . W !,"    ",$$FMTE^XLFDT($G(LEXD),"5Z"),?16,$G(TA(1))
 . . . . S I=1 F  S I=$O(TA(I)) Q:+I'>0  W !,?16,$G(TA(I))
 . . . I +($G(LEXLSC))>0,+($G(LEXLST))>0 D
 . . . . W !,"  Lexicon Semantics:"
 . . . . W !,"    ",+($G(LEXLSC)),?16,$P($G(^LEX(757.11,+($G(LEXLSC)),0)),"^",2)
 . . . . W !,"    ",+($G(LEXLST)),?16,$P($G(^LEX(757.12,+($G(LEXLST)),0)),"^",2)
 Q
CNT ;   Count Changes
 K CNT N ORD S ORD="" F  S ORD=$O(^ZZLEXX("ZZLEXXB",$J,"ICD",ORD)) Q:'$L(ORD)  D
 . N ACT S ACT=$G(^ZZLEXX("ZZLEXXB",$J,"ICD",ORD,"ACT")) I $L(ACT) S CNT(ACT)=$G(CNT(ACT))+1 Q
 . S ACT=$G(^ZZLEXX("ZZLEXXB",$J,"ICD",ORD,"AC")) I $L(ACT) S CNT(ACT)=$G(CNT(ACT))+1
 Q
TOT ;   Report Totals
 W:'$D(COMMIT) ! N ACT,TTL,TT,TC S TTL=$O(CNT("")) S (TT,TC)=0 F ACT="AD","IA","RA","RU","SR","FR","BR" D
 . N VAL S VAL=+($G(CNT(ACT))) Q:+VAL'>0  S TC=TC+1,TT=TT+VAL
 W:$L(TTL)&('$D(COMMIT)) !!,?1,"Total Changes found:" W:$L(TTL)&($D(COMMIT)) !!,?1,"Total changes made:"
 I TT'>0 W !!,?4,"None" Q
 W:TT>0&(TC>1) ?33,$J(TT,6) W:TT>0 ! F ACT="AD","IA","RA","RU","SR","FR","BR","NC" D
 . N TTL,VAL S TTL=$$EACT(ACT),VAL=+($G(CNT(ACT))) W:+VAL>0&(ACT'="NC") !,?4,TTL,?33,$J(VAL,6)
 . W:+VAL>0&(ACT="NC") !!,?1,TTL,?33,$J(VAL,6),!
 Q
END ;   Timing
 Q:'$L($G(LEXBEG))  N LEXEND,LEXELP,EBEG,EEND,HR
 S LEXEND=$$NOW^XLFDT S LEXELP=$$FMDIFF^XLFDT(LEXEND,$G(LEXBEG),3)
 S HR=$$TM($P(LEXELP,":",1)) S:$L(HR)'=2 HR="0"_HR S:$L(HR)'=2 HR="0"_HR S $P(LEXELP,":",1)=HR
 S EBEG=$$FMTE^XLFDT($G(LEXBEG),"5ZS"),EBEG=$P(EBEG,"@",1)_"  "_$P(EBEG,"@",2)
 S EEND=$$FMTE^XLFDT($G(LEXEND),"5ZS"),EEND=$P(EEND,"@",1)_"  "_$P(EEND,"@",2) W !
 W !," Start:     ",EBEG,!," Finish:    ",EEND,!," Elapsed:               ",LEXELP,!
 Q
UP ;   Convert Uppercase Terms to Mix
 D UP^ZZLEXXBB
 Q
LEX(X,Y) ;   Lexicon Term
 N CODE,CDT,STA,SIEN,EIEN,TERM,EFFD S CODE=$G(X),CDT=$G(Y) Q:'$D(^LEX(757.02,"CODE",(CODE_" "))) ""  Q:CDT'?7N ""
 S STA=$$STATCHK^LEXSRC2(CODE,(CDT+.0001),"","10D"),SIEN=$P(STA,"^",2),EIEN=+($G(^LEX(757.02,+SIEN,0)))
 S TERM=$G(^LEX(757.01,+EIEN,0)),EFFD=$P(STA,"^",3),STA=$P(STA,"^",1)
 Q:$L(TERM)&(EFFD?7N)&(+SIEN>0)&(+EIEN>0)&("^1^0^"[("^"_STA_"^")) (SIEN_"^"_EIEN_"^"_STA_"^"_EFFD_"^"_TERM)
 Q ""
ED(X) ;   External Date
 S X=$G(X) Q:$P(X,".",1)'?7N ""
 S X=$$FMTE^XLFDT(X,"5ZM") S:X["@" X=$P(X,"@",1)_"  "_$P(X,"@",2)
 Q X
TX(X) ;   Format Text
 S X=$$UP^XLFSTR($$TM($$DS($TR($G(X),"""",""))))
 Q X
DS(X) ;   Remove Double Space
 S X=$G(X) Q:X="" X
 F  Q:X'["  "  S X=$P(X,"  ",1)_" "_$P(X,"  ",2,299)
 Q X
TM(X,Y) ;   Trim Character Y - Default " " Space
 S X=$G(X) Q:X="" X  S Y=$G(Y) S:'$L(Y) Y=" "
 F  Q:$E(X,1)'=Y  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=Y  S X=$E(X,1,($L(X)-1))
 Q X
EACT(X) ;   External Action
 Q:$G(X)="AD" "Additions"  Q:$G(X)="SR" "Short Text Revisions"  Q:$G(X)="FR" "Long Text Revisions"  Q:$G(X)="BR" "Long/Short Text Revisions"
 Q:$G(X)="RA" "Re-Activations"  Q:$G(X)="RU" "Re-Used"  Q:$G(X)="IA" "Inactivations"  Q:$G(X)="NC" "Codes with No Change"
 Q " "
SYS(X) ;   System
 S X="U" S:$$OS^%ZOSV'["UNIX" X="V"
 Q X
LOC(X) ;   Local Namespace
 X "S X=$ZNSPACE" Q X
SHO ;   Show ^ZZLEXX("ZZLEXXB",$J) Global
 N ORD,CT S ORD="",CT=0 F  S ORD=$O(^ZZLEXX("ZZLEXXB",$J,"ICD",ORD)) Q:'$L(ORD)  D
 . Q:^ZZLEXX("ZZLEXXB",$J,"ICD",ORD,"AC")="NC"  S CT=CT+1 W:CT=1 !! ZW ^ZZLEXX("ZZLEXXB",$J,"ICD",ORD)
 W:CT>0 !!
 Q
KILL ;   Kill Global
 K ^ZZLEXX("ZZLEXXB",$J),%,%D,RTN
 Q
LR(X) ;   Local Routine
 S X=$T(+1),X=$P(X," ",1) Q X
ENV(X) ;   Environment
 D HOME^%ZIS S U="^",DT=$$DT^XLFDT,DTIME=300 K POP
 N NM S NM=$$GET1^DIQ(200,(DUZ_","),.01)
 I '$L(NM) W !!,?5,"Invalid/Missing DUZ" Q 0
 S:$G(DUZ(0))'["@" DUZ(0)=$G(DUZ(0))_"@"
 Q 1
