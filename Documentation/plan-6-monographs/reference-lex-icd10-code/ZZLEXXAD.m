ZZLEXXAD ;SLC/KER - Import - ICD-10-CM - Lex AD/FR/BR/RU ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^ICD9(              ICR   4485
 ;    ^LEX(757            SACC 1.3
 ;    ^LEX(757.001        SACC 1.3
 ;    ^LEX(757.01         SACC 1.3
 ;    ^LEX(757.02         SACC 1.3
 ;    ^LEX(757.03         SACC 1.3
 ;    ^LEX(757.1          SACC 1.3
 ;    ^LEX(757.11         SACC 1.3
 ;    ^LEX(757.12         SACC 1.3
 ;               
 ; External References
 ;    HOME^%ZIS           ICR  10086
 ;    FILE^DIE            ICR   2053
 ;    UPDATE^DIE          ICR   2053
 ;    IX1^DIK             ICR  10013
 ;    $$GET1^DIQ          ICR   2056
 ;    $$STATCHK^ICDEX     ICR   5747
 ;    $$STATCHK^LEXSRC2   N/A
 ;    $$DT^XLFDT          ICR  10103
 ;    $$FMTE^XLFDT        ICR  10103
 ;    $$PATCH^XPDUTL      ICR  10141
 ;               
 ; Local Variables NEWed or KILLed Elsewhere
 ;     COMMIT,LEXEXP,LEXSC,LEXSRC,LEXST,LSTAD,LSTAT,TEST
 ;               
 Q
LEX ; Lexicon
 N %,SIEN,EIEN,EXC,OLDE,OLDS,OLDD,LEXCHK S ACT=$G(ACT),CODE=$G(CODE),LSTAD=$G(LSTAD) Q:"^AD^SR^FR^BR^RA^RU^IA^"'[("^"_ACT_"^")
 Q:ACT="SR"  Q:'$L($G(ACT))  Q:'$L($G(CODE))  Q:$G(LSTAD)'?7N  Q:'$D(^LEX(757.03,+($G(LEXSRC)),0))
 D:$G(ACT)="IA" IA^ZZLEXXAE(CODE,LSTAD,LEXSRC) Q:$G(ACT)="IA"  D:$G(ACT)="RA" RA^ZZLEXXAE(CODE,LSTAD,LEXSRC) Q:$G(ACT)="RA"
 K:$D(TEST) FULL Q:"^1^0^"'[("^"_$G(LSTAT)_"^")  Q:'$D(^LEX(757.11,+($G(LEXSC)),0))  Q:'$D(^LEX(757.12,+($G(LEXST)),0))  Q:'$L($G(LEXEXP))
 Q:$$PATCH^XPDUTL("LEX*2.0*103")'>0&($L(LEXEXP)>240)  Q:$$PATCH^XPDUTL("LEX*2.0*103")>0&($L(LEXEXP)>4000)  Q:$G(LSTAD)'?7N
 S EXC="S ^D",EXC=EXC_"D(757.01,.01,""LAYGO"",1,0)=""I 1""" X EXC
 S LEXCHK=$$STATCHK^LEXSRC2(CODE,(LSTAT+.0001),"",LEXSRC),SIEN=$P(LEXCHK,"^",2),EIEN=+($G(^LEX(757.02,+SIEN,0)))
 S OLDE=$G(^LEX(757.01,+EIEN,0)),OLDS=+LEXCHK  S:ACT="RU"&($$TX(OLDE)=$$TX(LEXEXP)) ACT="RA"
 D:"^AD^FR^BR^RU^"[("^"_$G(ACT)_"^") AFBR
 S EXC="S ^D",EXC=EXC_"D(757.01,.01,""LAYGO"",1,0)=""I 0""" X EXC
 Q
 ;
AFBR ; AD/FR/BR/RU - Add, Revise or Re-Use
 ;   Needs
 ;     ACT      Action Code
 ;     CODE     Code
 ;     LEXEXP   Expression
 ;     LEXSRC   Source (pointer 757.03)
 ;     LEXSC    Semantic Class (pointer 757.11)
 ;     LEXST    Semantic Type (pointer 757.12)
 ;     LSTAT    Status
 ;     LSTAD    Status Effective Date
 N DA,EIEN,EX,EXM,FQ,FREQ,HIS,IC,IEN,LAS,LEX,LEXCHK,MC,ODAT,OIEN,OLDE,OLDS,OLDD,PEFF,SC,SIEN,SM,SO,ST,TEFF,THIS,TMP,TSTA,TSTD,TTL,X
 S ACT=$G(ACT),CODE=$G(CODE),LSTAT=$G(LSTAT),LSTAD=$G(LSTAD),LEXSRC=$G(LEXSRC),LEXSC=$G(LEXSC),LEXST=$G(LEXST),LEXEXP=$G(LEXEXP)
 Q:"^AD^FR^BR^RU^"'[("^"_ACT_"^")  Q:'$L($G(CODE))  Q:'$L($G(LSTAT))  Q:"^0^1^"'[("^"_$G(LSTAT)_"^")  Q:$G(LSTAD)'?7N
 Q:'$D(^LEX(757.03,+LEXSRC,0))  Q:'$D(^LEX(757.11,+LEXSC,0))  Q:'$D(^LEX(757.12,+LEXST,0))  Q:'$L($G(LEXEXP))
 S LEXCHK=$$STATCHK^LEXSRC2(CODE,(LSTAD+.0001),"",LEXSRC)
 S SIEN=$P(LEXCHK,"^",2),EIEN=+($G(^LEX(757.02,+SIEN,0))),OLDE=$G(^LEX(757.01,+EIEN,0))
 S OLDS=+LEXCHK,OLDD=$P(LEXCHK,"^",3) D NEWIEN^ZZLEXXAN(+($G(LEXSRC)),$G(CODE),.LEX) S FREQ=$$FREQ^ZZLEXXAN(LEXSRC)
 S MC=+($G(LEX("MC"))),FQ=+($G(LEX("MC"))),EX=+($G(LEX("EX"))),SO=+($G(LEX("SO"))),SM=+($G(LEX("SM")))
 S X=$$EXM^ZZLEXXAN($G(LEXEXP),.EXM,LEXSRC) I +X>0 D ADJI
 I $$TX(LEXEXP)=$$TX(OLDE),ACT="RU" S ACT="RA" D RA^ZZLEXXAE(CODE,LSTAD,LEXSRC) Q
 S TTL=$S($G(ACT)="AD":"Addition",$G(ACT)="RU":"Re-used",$G(ACT)="RA":"Re-Activation",$G(ACT)="IA":"Inactivation",1:"Revision")
 I $D(COMMIT) D
 . I $G(ACT)="FR"!($G(ACT)="BR")!($G(ACT)="RU") D IA^ZZLEXXAE(CODE,LSTAD,LEXSRC)
 . ;   Add Major Concept Map
 . ;     Expression                757         .01
 . ;     Group                     757          1
 . I '$D(^LEX(757,MC,0)) D
 . . N DA,DIERR,FDA,FDAI,IENS,COM K DIERR,FDA,DA S DA=+($G(MC)),IENS=("+1,")
 . . S COM="("_$G(TTL)_$S($L(TTL):" for code ",1:"Code ")_$G(CODE)_" in file #757, add entry)"
 . . S FDA(757,IENS,.01)=$G(EX)
 . . S FDA(757,IENS,1)=""
 . . S FDAI(1)=DA
 . . D UPDATE^DIE(,"FDA","FDAI","DIERR")
 . . D:$D(DIERR) ERR
 . ;   Add Concept Usage (frequency)
 . ;     Major Concept             757.001     .01
 . ;     Originating Value         757.001      1
 . ;     Frequency                 757.001      2
 . I '$D(^LEX(757.001,MC,0)) D
 . . N DA,DIERR,FDA,FDAI,IENS,COM K DIERR,FDA,DA S DA=+($G(FQ)),IENS=("+1,")
 . . S COM="("_$G(TTL)_$S($L(TTL):" for code ",1:"Code ")_$G(CODE)_" in file #757.001, add entry)"
 . . S FDA(757.001,IENS,.01)=$G(MC)
 . . S FDA(757.001,IENS,1)=+($G(FREQ))
 . . S FDA(757.001,IENS,2)=+($G(FREQ))
 . . S FDAI(1)=DA
 . . D UPDATE^DIE(,"FDA","FDAI","DIERR")
 . . D:$D(DIERR) ERR
 . ;   Add Expression
 . ;     Displayable Text          757.01      .01
 . ;     Major Concept             757.01       1
 . ;     Type                      757.01       2
 . ;     Scope                     757.01       3
 . ;     Form                      757.01       4
 . I '$D(^LEX(757.01,EX,0)) D
 . . N DA,DIERR,FDA,FDAI,IENS,COM,I K DIERR,FDA,DA S DA=+($G(EX)),IENS=("+1,")
 . . S COM="("_$G(TTL)_$S($L(TTL):" for code ",1:"Code ")_$G(CODE)_" in file #757.01, add entry)"
 . . S FDA(757.01,IENS,.01)=$G(LEXEXP)
 . . S FDA(757.01,IENS,1)=+($G(MC))
 . . S FDA(757.01,IENS,2)=1
 . . S FDA(757.01,IENS,3)="D"
 . . S FDA(757.01,IENS,4)=1
 . . S FDAI(1)=DA
 . . D UPDATE^DIE(,"FDA","FDAI","DIERR")
 . . D:$D(DIERR) ERR
 . . S I=0 F  S I=$O(^LEX(757.01,+EX,7,I)) Q:+I'>0  D
 . . . N DA,DIK S DA(1)=+EX,DA=I,DIK="^LEX(757.01,"_+EX_",7," D IX1^DIK
 . ;   Edit/Add Code
 . ;     Expression                757.02      .01
 . ;     Code                      757.02       1
 . ;     Classification Source     757.02       2
 . ;     Major Concept             757.02       3
 . ;     Preference Flag           757.02       4
 . ;     Deactivation Flag         757.02       5  
 . ;       (before LEX*2.0*103)
 . ;     Primary Flag              757.02       6
 . ;     Effective Date            757.28      .01
 . ;     Status                    757.28       1
 . I $D(^LEX(757.02,SO,0)) D
 . . N DA,DIERR,FDA,FDAI,IENS,LEXDF,LEXI,LEXTEFF,LEXTHIS,LEXTSTA,LEXTSTD,COM
 . . S COM="("_$G(TTL)_$S($L(TTL):" for code ",1:"Code ")_$G(CODE)_" in file #757.02, edit entry)"
 . . Q:$P($G(^LEX(757.02,SO,0)),"^",1)'=EX  Q:$P($G(^LEX(757.02,SO,0)),"^",2)'=CODE
 . . Q:$P($G(^LEX(757.02,SO,0)),"^",3)'=LEXSRC  Q:$P($G(^LEX(757.02,SO,0)),"^",4)'=MC
 . . S LEXDF=$S(LSTAT>0:"",1:1) I $$PATCH^XPDUTL("LEX*2.0*103")'>0,$D(@("^DD(757.02,5)")) D
 . . . N DA,DIERR,FDA K DIERR,FDA,DA S DA=+($G(SO)) S FDA(757.02,(DA_","),5)=LEXDF
 . . . D FILE^DIE(,"FDA","DIERR") D:$D(DIERR) ERR
 . . S LEXTEFF=$O(^LEX(757.02,+SO,4,"B",(+($G(LSTAD))+.0001)),-1)
 . . S LEXTHIS=$O(^LEX(757.02,+SO,4,"B",+LEXTEFF," "),-1)
 . . S LEXTSTD=$P($G(^LEX(757.02,+SO,4,+LEXTHIS,0)),"^",1)
 . . S LEXTSTA=$P($G(^LEX(757.02,+SO,4,+LEXTHIS,0)),"^",2)
 . . I LSTAD=LEXTEFF S $P(^LEX(757.02,+SO,4,+LEXTHIS,0),"^",2)=+($G(LSTAT))
 . . I LSTAD'=LEXTEFF!(LSTAT'=LEXTSTA) D
 . . . N DA,FDA,FDAI,IENS,LEXI,DIERR,IENS K DIERR,FDA,DA,COM
 . . . S COM="("_$G(TTL)_$S($L(TTL):" for code ",1:"Code status ")_$G(CODE)_" in sub-file #757.28, add entry)"
 . . . S LEXI=$O(^LEX(757.02,+SO,4," "),-1)+1
 . . . S DA(1)=+($G(SO)),DA=+($G(LEXI)),IENS=("+1,"_DA(1)_",")
 . . . S FDA(757.28,IENS,.01)=$G(LSTAD)
 . . . S FDA(757.28,IENS,1)=$G(LSTAT)
 . . . S FDAI(1)=DA
 . . . D UPDATE^DIE(,"FDA","FDAI","DIERR")
 . . . D:$D(DIERR) ERR
 . I '$D(^LEX(757.02,SO,0)) D
 . . N DA,DIERR,FDA,FDAI,IENS,COM K DIERR,FDA,DA S DA=+($G(SO)),IENS=("+1,")
 . . S COM="("_$G(TTL)_$S($L(TTL):" for code ",1:"Code ")_$G(CODE)_" in file #757.02, add entry)"
 . . S FDA(757.02,IENS,.01)=+($G(EX))
 . . S FDA(757.02,IENS,1)=$G(CODE)
 . . S FDA(757.02,IENS,2)=LEXSRC
 . . S FDA(757.02,IENS,3)=+($G(MC))
 . . S FDA(757.02,IENS,4)=1
 . . S:$$PATCH^XPDUTL("LEX*2.0*103")'>0&($D(^DD(757.02,5))) FDA(757.02,IENS,5)=""
 . . S FDA(757.02,IENS,6)=1
 . . S FDAI(1)=DA
 . . D UPDATE^DIE(,"FDA","FDAI","DIERR")
 . . D:$D(DIERR) ERR
 . . S COM="("_$G(TTL)_$S($L(TTL):" for code ",1:"Code status ")_$G(CODE)_" in sub-file #757.28, add entry)"
 . . K DIERR,FDA,DA S DA(1)=+($G(SO)),IENS=("+1,"_DA(1)_",")
 . . S DA=$O(^LEX(757.02,+DA(1),4," "),-1)+1
 . . S FDA(757.28,IENS,.01)=$G(LSTAD)
 . . S FDA(757.28,IENS,1)=$G(LSTAT)
 . . S FDAI(1)=DA
 . . D UPDATE^DIE(,"FDA","FDAI","DIERR")
 . . D:$D(DIERR) ERR
 . ;   Add Semantics
 . ;     Major Concept             757.1       .01
 . ;     Semantic Class            757.1        1
 . ;     Semantic Type             757.1        2
 . I '$D(^LEX(757.1,SM,0)) D
 . . N DA,DIERR,FDA,FDAI,IENS K DIERR,FDA,DA,COM S DA=+($G(SM)),IENS=("+1,")
 . . S COM="("_$G(TTL)_$S($L(TTL):" for code ",1:"Code ")_$G(CODE)_" in file #757.1, add entry)"
 . . S FDA(757.1,IENS,.01)=+($G(MC))
 . . S FDA(757.1,IENS,1)=$G(LEXSC)
 . . S FDA(757.1,IENS,2)=$G(LEXST)
 . . S FDAI(1)=DA
 . . D UPDATE^DIE(,"FDA","FDAI","DIERR")
 . . D:$D(DIERR) ERR
 . D:$D(TEST) WRT I $D(FULL) D
 . . N EXC W:+($G(LEX("MC")))>0!(+($G(LEX("FQ")))>0)!(+($G(LEX("EX")))>0)!(+($G(LEX("SO")))>0)!(+($G(LEX("SM")))>0) !,TTL,!
 . . I +($G(LEX("MC")))>0 S EXC="ZW ^LEX(757,"_+MC_")" X EXC
 . . I +($G(LEX("FQ")))>0 S EXC="ZW ^LEX(757.001,"_+FQ_")" X EXC
 . . I +($G(LEX("EX")))>0 S EXC="ZW ^LEX(757.01,"_+EX_")" X EXC
 . . I +($G(LEX("SO")))>0 S EXC="ZW ^LEX(757.02,"_+SO_")" X EXC
 . . I +($G(LEX("SM")))>0 S EXC="ZW ^LEX(757.1,"_+SM_")" X EXC
 I '$D(COMMIT) D
 . D:$D(TEST) WRT Q:'$D(FULL)
 . N EXC,IEN,LAS,PEFF,ODAT,OIEN
 . W !,$G(TTL),!,"^LEX(757,",+MC,",0)=""",EX_"^""",!
 . W "^LEX(757.001,",+FQ,",0)=""",+MC,"^",+FREQ,"^",+FREQ_"""",!
 . W "^LEX(757.01,",+EX,",0)=""",$G(LEXEXP),"""",!
 . W "^LEX(757.01,",+EX,",1)=""",MC,"^1^D^1""",!
 . I $O(^LEX(757.01,+EX,3,0))>0 S EXC="ZW ^LEX(757.01,"_+EX_",3)" X EXC
 . I $O(^LEX(757.01,+EX,4,0))>0 S EXC="ZW ^LEX(757.01,"_+EX_",4)" X EXC
 . I $O(^LEX(757.01,+EX,5,0))>0 S EXC="ZW ^LEX(757.01,"_+EX_",5)" X EXC
 . I $O(^LEX(757.01,+EX,7,0))>0 S EXC="ZW ^LEX(757.01,"_+EX_",7)" X EXC
 . W "^LEX(757.02,",+SO,",0)=""",+EX,"^",CODE,"^",+LEXSRC,"^",+MC,"^1^^1",!
 . S OIEN=$O(^LEX(757.02,+SO,4,"B",LSTAD,0))
 . S ODAT=$G(^LEX(757.02,+SO,4,+OIEN,0))
 . S LAS=$O(^LEX(757.02,+SO,4," "),-1) S:ODAT'=(LSTAD_"^1") LAS=LAS+1
 . W "^LEX(757.02,",+SO,",4,0)=""^757.28D^",LAS,"^",LAS,"""",!
 . S IEN=0 F  S IEN=$O(^LEX(757.02,+SO,4,IEN)) Q:+IEN'>0  D
 . . N TMP S TMP=$G(^LEX(757.02,+SO,4,+IEN,0)) Q:'$L(TMP)
 . . W "^LEX(757.02,",+SO,",4,",+IEN,",0)=""",TMP,"""",!
 . W:ODAT'=(LSTAD_"^1") "^LEX(757.02,",+SO,",4,",LAS,",0)=""",+LSTAD,"^1",!
 . S PEFF="" F  S PEFF=$O(^LEX(757.02,+SO,4,"B",PEFF)) Q:+PEFF'>0  D
 . . N IEN S IEN=0 F  S IEN=$O(^LEX(757.02,+SO,4,"B",PEFF,IEN)) Q:+IEN'>0  D
 . . . W "^LEX(757.02,",+SO,",4,""B"",",PEFF,",",+IEN,")=""""",!
 . W:ODAT'=(LSTAD_"^1") "^LEX(757.02,",+SO,",4,""B"",",+LSTAD,",",+LAS,")=""""",!
 . W "^LEX(757.1,",SM,",0)=""",MC,"^",LEXSC,"^",LEXST,!
 Q
 ;
WRT ;   Write Findings
 Q:'$D(TEST)  Q:'$L(CODE)  Q:$G(LSTAD)'?7N  Q:$G(ACT)="NC"  Q:'$L(ACT)  N AC,TA,EACT S AC=$G(ACT)
 N ACT S ACT=AC,EACT=$$EACT^ZZLEXXAA($G(ACT)),EACT=$$TM(("Lexicon "_EACT),"s") S:EACT["Revision" EACT="Lexicon Expression Revision"
 W !!," ",$G(CODE),?21,$G(ACT),?26,EACT,?56,$$FMTE^XLFDT($G(LSTAD))
 ;   Write Inactive
 I $G(ACT)="IA",$L($G(LEXEXP)),$G(LSTAD)?7N D  Q
 . W !,"   Lexicon Expression:"  D
 . . K TA N I S TA(1)=$G(LEXEXP) D PR^ZZLEXXAM(.TA,(78-17))
 . . W !,"     ",$$FMTE^XLFDT($G(LSTAD),"5Z"),?17,$G(TA(1))
 . . S I=1 F  S I=$O(TA(I)) Q:+I'>0  W !,?17,$G(TA(I))
 ;   Write Active
 I $G(ACT)'="IA" D
 . I $L($G(LEXEXP)),$G(LSTAD)?7N D
 . . W !,"   Lexicon Expression:"  D
 . . . K TA N I S TA(1)=$G(LEXEXP) D PR^ZZLEXXAM(.TA,(78-17))
 . . . W !,"     ",$$FMTE^XLFDT($G(LSTAD),"5Z"),?17,$G(TA(1))
 . . . S I=1 F  S I=$O(TA(I)) Q:+I'>0  W !,?17,$G(TA(I))
 . . I $L($G(OLDE)),$G(OLDD)?7N,$$TX(OLDE)'=$$TX(LEXEXP) D
 . . . K TA N I S TA(1)=$G(OLDE) D PR^ZZLEXXAM(.TA,(78-17))
 . . . W !,"     ",$$FMTE^XLFDT($G(OLDD),"5Z"),?17,$G(TA(1))
 . . . S I=1 F  S I=$O(TA(I)) Q:+I'>0  W !,?17,$G(TA(I))
 . Q:'$L($G(LEXEXP))!($G(LSTAD)'?7N)
 . I +($G(LEXSC))>0,+($G(LEXST))>0,"^AD^RU^"[("^"_$G(ACT)_"^") D
 . . Q:$G(ACT)="RA"  Q:$G(ACT)="IA"
 . . W !,"   Lexicon Semantics:"
 . . W !,"    ",$J(+($G(LEXSC)),3),?17,$P($G(^LEX(757.11,+($G(LEXSC)),0)),"^",2)
 . . W !,"    ",$J(+($G(LEXST)),3),?17,$P($G(^LEX(757.12,+($G(LEXST)),0)),"^",2)
 Q
 ; 
 ; Miscellaneous
ERR ;   Errors
 N SEQ S SEQ=0 F  S SEQ=$O(DIERR("DIERR",SEQ)) Q:+SEQ'>0  D
 . N TI,TX,TXI S TI=0 F  S TI=$O(DIERR("DIERR",SEQ,"TEXT",TI)) Q:+TI'>0  D
 . . N TMP,TXI S TMP=$G(DIERR("DIERR",SEQ,"TEXT",TI)) Q:'$L(TMP)
 . . S TXI=$O(TX(" "),-1)+1,TX(TXI)=TMP
 . I $L($G(COM)) S TXI=$O(TX(" "),-1)+1,TX(TXI)=$G(COM)
 . Q:$O(TX(0))'>0  D PR^ZZLEXXAM(.TX,50) S TX(1)="ERROR>>  "_$G(TX(1))
 . W !,?2,$G(TX(1)) S TI=1 F  S TI=$O(TX(TI)) Q:+TI'>0  W !,?11,$G(TX(TI))
 Q
ADJI ;   Adjust IENs MC/FQ/EX/SO/SM
 Q:'$L($G(CODE))  Q:'$L($G(LEXSRC))  Q:'$L($G(LEXSC))  Q:'$L($G(LEXST))  Q:$O(EXM(0))'>0
 N I,EXIT S (I,EXIT)=0 F  S I=$O(EXM(I))  Q:I'>0  Q:EXIT  D  Q:EXIT
 . N IENS,TEXIEN,TMCIEN,TSOIEN,TSMIEN S (TEXIEN,TMCIEN,TSOIEN,TSMIEN)=0,IENS=$G(EXM(I))
 . S TEXIEN=+IENS,TMCIEN=+($P($G(^LEX(757.01,+TEXIEN,1)),"^",1)) Q:+TMCIEN'>0
 . Q:TEXIEN>6999999&(+($G(LEXSRC))'=56)  Q:TEXIEN<6999999&(+($G(LEXSRC))=56)
 . N S S S=0 F  S S=$O(^LEX(757.02,"B",+TEXIEN,S)) Q:+S'>0  Q:+TSOIEN>0  D  Q:+TSOIEN>0
 . . Q:$P($G(^LEX(757.02,S,0)),"^",2)'=$G(CODE)  Q:$P($G(^LEX(757.02,S,0)),"^",3)'=$G(LEXSRC)  S TSOIEN=S
 . S S=0 F  S S=$O(^LEX(757.1,"B",+TMCIEN,S)) Q:+S'>0  Q:+TSMIEN>0  D  Q:+TSMIEN>0
 . . Q:$P($G(^LEX(757.1,S,0)),"^",2)'=$G(LEXSC)  Q:$P($G(^LEX(757.1,S,0)),"^",3)'=$G(LEXST)  S TSMIEN=S
 . I $D(^LEX(757.01,+TEXIEN,0)),$D(^LEX(757,+TMCIEN,0)) D
 . . S EXIT=1,EX=+($G(TEXIEN)),(FQ,MC)=+($G(TMCIEN)) S:$D(^LEX(757.02,+TSOIEN,0)) SO=+($G(TSOIEN))
 . . S:$D(^LEX(757.1,+TSMIEN,0)) SM=+($G(TSMIEN))
 Q
TX(X) ;   Format Lexicon Text
 S X=$$TM($$DS($$DQ($$CTL($G(X)))))
 Q X
CTL(X) ;   Remove Control Characters
 Q $$CTL^ZZLEXXAM($G(X))
DQ(X) ;   Remove Double Quotes (there are no double quotes in ICD)
 Q $TR($G(X),"""","")
DS(X) ;   Remove Double Space
 S X=$G(X) Q:X="" X
 F  Q:X'["  "  S X=$P(X,"  ",1)_" "_$P(X,"  ",2,299)
 Q X
TM(X,Y) ;   Trim Character Y - Default " " Space
 S X=$G(X) Q:X="" X  S Y=$G(Y) S:'$L(Y) Y=" "
 F  Q:$E(X,1)'=Y  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=Y  S X=$E(X,1,($L(X)-1))
 Q X
LOC(X) ;   Local Namespace
 X "S X=$ZNSPACE" Q X
LR(X) ;   Local Routine
 S X=$T(+1),X=$P(X," ",1) Q X
ENV(X) ;   Environment
 D HOME^%ZIS S U="^",DT=$$DT^XLFDT,DTIME=300 K POP
 N NM S NM=$$GET1^DIQ(200,(DUZ_","),.01)
 I '$L(NM) W !!,?5,"Invalid/Missing DUZ" Q 0
 S:$G(DUZ(0))'["@" DUZ(0)=$G(DUZ(0))_"@"
 Q 1
INA ;   Find Inactive Diagnosis Codes
 N ORD,IEN S ORD="" F  S ORD=$O(^ICD9("ABA",30,ORD)) Q:'$L(ORD)  S IEN=0 F  S IEN=$O(^ICD9("ABA",30,ORD,IEN))  Q:+IEN'>0  D
 . N CODE,SIEN,SEFF,STA,TD S TD=$$DT^XLFDT
 . S CODE=$P($G(^ICD9(+IEN,0)),"^",1)
 . S STA=$$STATCHK^ICDEX(CODE,TD,30) Q:+STA>0
 . Q:$P(STA,"^",2)<0
 . Q:'$L($P(STA,"^",3))
 . S SIEN=$P(STA,"^",2) Q:SIEN'>0  Q:SIEN'=IEN
 . S SEFF=$P(STA,"^",3) Q:SEFF'?7N  Q:SEFF>TD
 . S STA=+STA
 . W !,CODE,?15,SIEN,?25,STA,?30,$$FMTE^XLFDT(SEFF,"5Z")
 Q
KILL ;   Kill Global
 D KILL^ZZLEXXAA
 Q
