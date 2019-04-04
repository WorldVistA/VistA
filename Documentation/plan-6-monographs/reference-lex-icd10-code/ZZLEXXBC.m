ZZLEXXBC ;SLC/KER - Import - ICD-10-PCS - ICD AD/FR/BR/RU/IA ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^ICD0(              ICR   4486
 ;    ^LEX(757            SACC 1.3
 ;    ^LEX(757.001        SACC 1.3
 ;    ^LEX(757.01         SACC 1.3
 ;    ^LEX(757.02         SACC 1.3
 ;    ^LEX(757.1          SACC 1.3
 ;    ^LEX(757.11         SACC 1.3
 ;    ^LEX(757.12         SACC 1.3
 ;    ^ZZLEXX("ZZLEXXB"   SACC 1.3
 ;               
 ; External References
 ;    HOME^%ZIS           ICR  10086
 ;    FILE^DIE            ICR   2053
 ;    UPDATE^DIE          ICR   2053
 ;    IX1^DIK             ICR  10013
 ;    $$GET1^DIQ          ICR   2056
 ;    $$CODEABA^ICDEX     ICR   5747
 ;    $$MIX^LEXXM         N/A
 ;    $$DT^XLFDT          ICR  10103
 ;    $$UP^XLFSTR         ICR  10104
 ;    $$PATCH^XPDUTL      ICR  10141
 ;               
 ; Local Variables NEWed or KILLed Elsewhere
 ;     COMMIT
 ;               
 Q
FILE ; Check File
 N ORD S ORD="" F  S ORD=$O(^ZZLEXX("ZZLEXXB",$J,"ICD",ORD)) Q:'$L(ORD)  D ENTRY
 D:$D(COMMIT) EN^ZZLEXXBT
 Q
ENTRY ; Edit Entry for Code
 Q:'$D(ORD)  N ACT,FREQ,FLTXD,FLTXT,FSTAD,FSTAT,FSTXD,FSTXT
 N LEFF,LLTXD,LLTXT,LSTAD,LSTAT,LSTXD,LSTXT,LEXEXP,LEXSC,LEXSRC,LEXST,TTL
 ;   Code
 S CODE=$G(^ZZLEXX("ZZLEXXB",$J,"ICD",ORD,"SO"))
 I '$L(CODE)!($L(CODE)'=7) W !!,?4,"Invalid Code ",$S($L($G(CODE)):("for code "_CODE),1:""),! Q
 ;   Load Effective Date
 S LEFF=$G(^ZZLEXX("ZZLEXXB",$J,"ICD",ORD,"EF")) I LEFF'?7N W !!,?4,"Invalid Effective Date ",$S($L($G(CODE)):("for code "_CODE),1:""),! Q
 ;   Action Code
 S ACT=$G(^ZZLEXX("ZZLEXXB",$J,"ICD",(CODE_" "),"AC")) Q:ACT="NC"
 I "^AD^SR^FR^BR^RA^RU^IA^"'[("^"_ACT_"^") W !!,?4,"Invalid Action Code ",$S($L($G(CODE)):("for code "_CODE),1:""),! Q
 ;   New Status
 S LSTAD=$G(^ZZLEXX("ZZLEXXB",$J,"ICD",(CODE_" "),"AD","LOAD"))
 S LSTAT=$G(^ZZLEXX("ZZLEXXB",$J,"ICD",(CODE_" "),"AS","LOAD"))
 S EXIT=0 I "^AD^RA^RU^IA^"[("^"_ACT_"^") D  Q:EXIT
 . I "^0^1^"'[("^"_LSTAT_"^") W !!,?4,"Invalid Status ",! S EXIT=1 Q
 . I ACT="IA","^0^"'[("^"_LSTAT_"^") W !!,?4,"Invalid Inactive Status ",! S EXIT=1 Q
 . I ACT'="IA","^1^"'[("^"_LSTAT_"^") W !!,?4,"Invalid Active Status ",! S EXIT=1 Q
 . I LSTAD'?7N W !!,?4,"Invalid Status Effective Date ",! S EXIT=1 Q
 ;   New Short Description
 S LSTXT=$G(^ZZLEXX("ZZLEXXB",$J,"ICD",(CODE_" "),"ST","LOAD"))
 S LSTXD=$G(^ZZLEXX("ZZLEXXB",$J,"ICD",(CODE_" "),"SD","LOAD"))
 S EXIT=0 I "^AD^SR^BR^RU^"[("^"_ACT_"^") D  Q:EXIT
 . I '$L(LSTXT) W !!,?4,"Short Description Missing ",$S($L($G(CODE)):("for code "_CODE),1:""),! S EXIT=1 Q
 . I $L(LSTXT)>60 W !!,?4,"Invalid Short Description ",$S($L($G(CODE)):("for code "_CODE),1:""),! S EXIT=1 Q
 . I LSTXD'?7N W !!,?4,"Invalid Short Description Effective Date ",$S($L($G(CODE)):("for code "_CODE),1:""),! S EXIT=1
 ;   New Long Description
 S LLTXT=$G(^ZZLEXX("ZZLEXXB",$J,"ICD",(CODE_" "),"LT","LOAD"))
 S LLTXD=$G(^ZZLEXX("ZZLEXXB",$J,"ICD",(CODE_" "),"LD","LOAD"))
 S EXIT=0 I "^AD^FR^BR^RU^"[("^"_ACT_"^") D  Q:EXIT
 . I '$L(LLTXT) W !!,?4,"Long Description Missing ",$S($L($G(CODE)):("for code "_CODE),1:""),! S EXIT=1 Q
 . I $L(LLTXT)>245 W !!,?4,"Invalid Long Description ",$S($L($G(CODE)):("for code "_CODE),1:""),! S EXIT=1 Q
 . I LLTXD'?7N W !!,?4,"Invalid Short Description Effective Date ",$S($L($G(CODE)):("for code "_CODE),1:""),! S EXIT=1
 ;   New Lexicon Expression
 S LEXEXP=$G(^ZZLEXX("ZZLEXXB",$J,"ICD",(CODE_" "),"LX","LOAD"))
 I '$L(LEXEXP) D
 . S LEXEXP=$G(LLTXT) S:$$UP^XLFSTR(LLTXT)=LLTXT LEXEXP=$$MIX^LEXXM(LLTXT)
 S EXIT=0 I "^AD^FR^RU^"[("^"_ACT_"^") D  Q:EXIT
 . I '$L(LEXEXP) W !!,?4,"Lexicon Expression Missing ",$S($L($G(CODE)):("for code "_CODE),1:""),! S EXIT=1 Q
 . I $$PATCH^XPDUTL("LEX*2.0*103")'>0,$L(LEXEXP)>240 W !!,?4,"Invalid Lexicon Expression ",$S($L($G(CODE)):("for code "_CODE),1:""),! S EXIT=1 Q
 . I $$PATCH^XPDUTL("LEX*2.0*103")>0,$L(LEXEXP)>4000 W !!,?4,"Invalid Lexicon Expression ",$S($L($G(CODE)):("for code "_CODE),1:""),! S EXIT=1 Q
 ;   Source
 S LEXSRC=31
 ;   Semantics
 S LEXSC=$G(^ZZLEXX("ZZLEXXB",$J,"ICD",(CODE_" "),"LX","SMSC"))
 S LEXST=$G(^ZZLEXX("ZZLEXXB",$J,"ICD",(CODE_" "),"LX","SMST"))
 S EXIT=0 I "^AD^FR^BR^RA^RU^"[("^"_ACT_"^") D  Q:EXIT
 . I +LEXSC'>0!('$D(^LEX(757.11,+LEXSC,0))) W !!,?4,"Invalid Semantic Class ",$S($L($G(CODE)):("for code "_CODE),1:"")
 . I +LEXST'>0!('$D(^LEX(757.12,+LEXST,0))) W !!,?4,"Invalid Semantic Type ",$S($L($G(CODE)):("for code "_CODE),1:"")
 ;   Frequency
 S FREQ=$$FREQ^ZZLEXXBN(LEXSRC)
 S TTL=$S($G(ACT)="AD":"Addition",$G(ACT)="RU":"Re-used",$G(ACT)="RA":"Re-Activation",$G(ACT)="IA":"Inactivation",1:"Revision")
 I $L(ACT) D:$L($T(@(ACT_"+1"))) @ACT
 Q
 ;
 ; Actions
AD ;   Addition
 D CODE(CODE),STAT(CODE,LSTAT,LSTAD),SHORT(CODE,LSTXT,LSTXD),LONG(CODE,LLTXT,LLTXD),LEX,SUP,IX(CODE)
 Q
BR ;   Both Short and Long Revision
 D SHORT(CODE,LSTXT,LSTXD),LONG(CODE,LLTXT,LLTXD),LEX,SUP,IX(CODE)
 Q
FR ;   Long Revision
 D LONG(CODE,LLTXT,LLTXD),LEX,SUP,IX(CODE)
 Q
SR ;   Long Revision
 D SHORT(CODE,LSTXT,LSTXD),IX(CODE)
 Q
IA ;   Inactivation
 D STAT(CODE,LSTAT,LSTAD),LEX,IX(CODE)
 Q
RU ;   Re-Use
 D STAT(CODE,LSTAT,LSTAD),SHORT(CODE,LSTXT,LSTXD),LONG(CODE,LLTXT,LLTXD),LEX,SUP,IX(CODE)
 Q
RA ;   Reactivated
 D STAT(CODE,LSTAT,LSTAD),LEX,SUP,IX(CODE)
 Q
 ;
CODE(X) ;   ICD Code
 ;     X   Code                       80.1       .01
 ;         Coding System (31)         80.1       1.1
 N CODE,IEN,DA,COM S CODE=$G(X) Q:'$L(CODE)  S (IEN,DA)=$$CODEABA^ICDEX(CODE,80.1,31) Q:+IEN>0
 S COM="("_$G(TTL)_$S($L(TTL):" for code ",1:"Code ")_$G(CODE)_" in file #80)"
 S (IEN,DA)=$O(^ICD0(" "),-1)+1
 I $D(COMMIT) D
 . I $D(^ICD0(IEN,0)) D
 . . Q:$G(^ICD0(IEN,0))=CODE
 . . N DA,DIERR,FDA K DIERR,FDA S DA=+($G(IEN))
 . . S FDA(80.1,(DA_","),.01)=$G(CODE)
 . . S FDA(80.1,(DA_","),1.1)=31
 . . D FILE^DIE(,"FDA","DIERR")
 . . D:$D(DIERR) ERR
 . I '$D(^ICD0(IEN,0)) D
 . . N DA,DIERR,FDA,FDAI,IENS
 . . K DIERR,FDA S DA=+($G(IEN)),IENS=("+1,")
 . . S FDA(80.1,IENS,.01)=$G(CODE)
 . . S FDA(80.1,IENS,1.1)=31
 . . S FDAI(1)=DA D UPDATE^DIE(,"FDA","FDAI","DIERR")
 . . D:$D(DIERR) ERR
 I '$D(COMMIT) D
 . N TMP W !,"^ICD0(",DA,",0)=""",CODE,"""" S TMP=$G(^ICD0(+DA,0)) S $P(TMP,"^",1)=31
 . W !,"^ICD0(",DA,",0)=""",CODE,"""",!,"^ICD0(",DA,",1)=""",TMP,""""
 Q
 ;
STAT(X,Y,Z) ;   ICD Status
 ;     X   Code                       80         .01
 ;     Y   Status                     80.166     .02
 ;     Z   Effective Date             80.166     .01
 N CODE,DA,EFF,EXIT,HIS,IEN,LAS,PEFF,PIEN,PSTA,SF,STAT,TMP S CODE=$G(X) Q:'$L(CODE)  S STAT=$G(Y) Q:"^1^0^"'[("^"_STAT_"^")
 S COM="("_$G(TTL)_$S($L(TTL):" for code ",1:"Code ")_$G(CODE)_" status change in sub-file #80.066, add entry)"
 S EFF=$G(Z) Q:EFF'?7N  S SF="80.166DA",EXIT=0,(IEN,DA)=$$CODEABA^ICDEX(CODE,80.1,31) Q:+IEN'>0
 ;   Quit if on file
 S TMP=EFF_"^"_STAT,(EXIT,HIS)=0 F  S HIS=$O(^ICD0(DA,66,HIS)) Q:+HIS'>0  S:$G(^ICD0(DA,66,HIS))=TMP EXIT=1
 ;   Quit if no change in status
 Q:EXIT  S PEFF=$O(^ICD0(DA,66,"B",(+EFF+.0001)),-1),PIEN=$O(^ICD0(DA,66,"B",+PEFF," "),-1),PSTA=$P($G(^ICD0(DA,66,+PIEN,0)),"^",2) Q:PSTA=STAT
 S HIS=$O(^ICD0(DA,66," "),-1)+1,DA(1)=DA,DA=HIS
 I $D(COMMIT) D
 . N DIERR,FDA,FDAI,IENS
 . I '$D(^ICD0(DA(1),66,DA,0)) D
 . . N DIERR,FDA,FDAI,IENS K DIERR,FDA
 . . S IENS=("+1,"_DA(1)_",")
 . . S FDA(80.166,IENS,.01)=$G(EFF)
 . . S FDA(80.166,IENS,.02)=$G(STAT)
 . . S FDAI(1)=DA
 . . D UPDATE^DIE(,"FDA","FDAI","DIERR")
 . . D:$D(DIERR) ERR
 I '$D(COMMIT) D
 . W !,"^ICD0(",+IEN,",66,,0)=""^",SF,"^",+HIS,"^",+HIS,""""
 . W !,"^ICD0(",+IEN,",66,",+HIS,",0)=""",EFF,"^",STAT,""""
 . W !,"^ICD0(",+IEN,",66,""B"",",EFF,",",+HIS,")="""""
 Q
 ;
SHORT(X,Y,Z) ;   ICD Short Desxription
 ;     X   Code                       80         .01
 ;     Y   Short Description          80.167      1
 ;     Z   Effective Date             80.167     .01
 N COM,CODE,DA,EFF,EXIT,HIS,IEN,LAS,PEFF,PIEN,PSTX,SF,STXT,TMP S CODE=$G(X) Q:'$L(CODE)  S STXT=$G(Y) Q:'$L(STXT)
 S COM="("_$G(TTL)_$S($L(TTL):" for code ",1:"Code ")_$G(CODE)_" short description in sub-file #80.067, add entry)"
 Q:$L(STXT)>60  S EFF=$G(Z) Q:EFF'?7N  S SF="80.167D",(IEN,DA)=$$CODEABA^ICDEX(CODE,80.1,31) Q:+IEN'>0
 ;   Quit if on file
 S TMP=EFF_"^"_STXT,(EXIT,HIS)=0 F  S HIS=$O(^ICD0(DA,67,HIS)) Q:+HIS'>0  S:$$TX($G(^ICD0(DA,67,HIS,0)))=$$TX(TMP) EXIT=1
 ;   Quit if no change in short description
 Q:EXIT  S PEFF=$O(^ICD0(DA,67,"B",(+EFF+.0001)),-1),PIEN=$O(^ICD0(DA,67,"B",+PEFF," "),-1)
 S PSTX=$P($G(^ICD0(DA,67,+PIEN,0)),"^",2) Q:$$TX(PSTX)=$$TX(STXT)
 S HIS=$O(^ICD0(DA,67," "),-1)+1 Q:HIS'>0  S DA(1)=DA,DA=HIS
 I $D(COMMIT) D
 . N DIERR,FDA,FDAI,IENS
 . I '$D(^ICD0(DA(1),67,DA,0)) D
 . . N DIERR,FDA,FDAI,IENS K DIERR,FDA
 . . S IENS=("+1,"_DA(1)_",")
 . . S FDA(80.167,IENS,.01)=$G(EFF)
 . . S FDA(80.167,IENS,1)=$G(STXT)
 . . S FDAI(1)=DA
 . . D UPDATE^DIE(,"FDA","FDAI","DIERR")
 . . D:$D(DIERR) ERR
 I '$D(COMMIT) D
 . W !,"^ICD0(",+IEN,",67,,0)=""^",SF,"^",+HIS,"^",+HIS,""""
 . W !,"^ICD0(",+IEN,",67,",+HIS,",0)=""",EFF,"^",STXT,""""
 . W !,"^ICD0(",+IEN,",67,""B"",",EFF,",",+HIS,")="""""
 Q
 ;
LONG(X,Y,Z) ;   ICD Long Desxription
 ;     X   Code                       80         .01
 ;     Y   Long Description           80.168      1
 ;     Z   Effective Date             80.168     .01
 N CODE,DA,EFF,HIS,IEN,LAS,LTXT,PEFF,PIEN,PLTX,SF,TMP S CODE=$G(X) Q:'$L(CODE)  S LTXT=$G(Y) Q:'$L(LTXT)
 S COM="("_$G(TTL)_$S($L(TTL):" for code ",1:"Code ")_$G(CODE)_" long description in sub-file #80.068, add entry)"
 Q:$L(LTXT)>245  S EFF=$G(Z) Q:EFF'?7N  S SF="80.168D",(IEN,DA)=$$CODEABA^ICDEX(CODE,80.1,31) Q:+IEN'>0
 ;   Quit if on file
 S (EXIT,HIS)=0 F  S HIS=$O(^ICD0(DA,68,HIS)) Q:+HIS'>0  D
 . S:$G(^ICD0(DA,68,HIS,0))=EFF&($$TX($G(^ICD0(DA,68,HIS,1)))=$$TX(LTXT)) EXIT=1
 ;   Quit if no change in short description
 Q:EXIT  S PEFF=$O(^ICD0(DA,68,"B",(+EFF+.0001)),-1),PIEN=$O(^ICD0(DA,68,"B",+PEFF," "),-1)
 S PLTX=$G(^ICD0(DA,68,+PIEN,1)) Q:$$TX(PLTX)=$$TX(LTXT)
 S HIS=$O(^ICD0(DA,68," "),-1)+1 Q:HIS'>0  S DA(1)=DA,DA=HIS
 I $D(COMMIT) D
 . N DIERR,FDA,FDAI,IENS
 . I '$D(^ICD0(DA(1),68,DA,0)) D
 . . N DIERR,FDA,FDAI,IENS K DIERR,FDA
 . . S IENS=("+1,"_DA(1)_",")
 . . S FDA(80.168,IENS,.01)=$G(EFF)
 . . S FDA(80.168,IENS,1)=$G(LTXT)
 . . S FDAI(1)=DA
 . . D UPDATE^DIE(,"FDA","FDAI","DIERR")
 . . D:$D(DIERR) ERR
 I '$D(COMMIT) D
 . W !,"^ICD0(",+IEN,",68,,0)=""^",SF,"^",+HIS,"^",+HIS,""""
 . W !,"^ICD0(",+IEN,",68,",+HIS,",0)=""",EFF
 . W !,"^ICD0(",+IEN,",68,",+HIS,",0)=""",LTXT,""""
 . W !,"^ICD0(",+IEN,",68,""B"",",EFF,",",+HIS,")="""""
 Q
IX(X) ;   Index Code
 N CODE,SIEN,DA S CODE=$G(X) Q:'$L(CODE)  S SIEN=$$CODEABA^ICDEX(CODE,80.1,31) I +SIEN>0 D
 . N DA,DIK S DA=SIEN,DIK="^ICD0(" D IX1^DIK
 Q:$G(ACT)="SR"  S SIEN=0 F  S SIEN=$O(^LEX(757.02,"CODE",(CODE_" "),SIEN)) Q:+SIEN'>0  D
 . N ND,SO,EX,MC,SM,DA,DIK S ND=$G(^LEX(757.02,+SIEN,0)),EX=+ND,MC=$P(ND,"^",4),SO=SIEN
 . I +MC>0,$D(^LEX(757,+MC,0)) S DA=+MC,DIK="^LEX(757," D IX1^DIK
 . I +MC>0,$D(^LEX(757.001,+MC,0)) S DA=+MC,DIK="^LEX(757.001," D IX1^DIK
 . I +EX>0,$D(^LEX(757.01,+EX,0)) S DA=+EX,DIK="^LEX(757.01," D IX1^DIK
 . I +SO>0,$D(^LEX(757.02,+SO,0)) S DA=+SO,DIK="^LEX(757.02," D IX1^DIK
 . S SM=0 F  S SM=$O(^LEX(757.1,"B",MC,SM)) Q:+SM'>0  D
 . . I +SM>0,$D(^LEX(757.1,+SM,0)) S DA=+SM,DIK="^LEX(757.1," D IX1^DIK
 Q
 ;
LEX ; Edit Lexicon Files 757*
 D LEX^ZZLEXXBD
 Q
 ;
SUP ; Edit Supplemental Keywords for ICD and LEX
 D:$L($G(CODE)) SUP^ZZLEXXBS
 Q
 ; 
 ; Miscellaneous
ERR ;   Errors
 N SEQ S SEQ=0 F  S SEQ=$O(DIERR("DIERR",SEQ)) Q:+SEQ'>0  D
 . N TI,TX,TXI S TI=0 F  S TI=$O(DIERR("DIERR",SEQ,"TEXT",TI)) Q:+TI'>0  D
 . . N TMP,TXI S TMP=$G(DIERR("DIERR",SEQ,"TEXT",TI)) Q:'$L(TMP)
 . . S TXI=$O(TX(" "),-1)+1,TX(TXI)=TMP
 . I $L($G(COM)) S TXI=$O(TX(" "),-1)+1,TX(TXI)=$G(COM)
 . Q:$O(TX(0))'>0  D PR^ZZLEXXBM(.TX,50) S TX(1)="ERROR>>  "_$G(TX(1))
 . W !,?2,$G(TX(1)) S TI=1 F  S TI=$O(TX(TI)) Q:+TI'>0  W !,?11,$G(TX(TI))
 Q
TX(X) ;   Format ICD Text
 S X=$$UP^XLFSTR($$TM($$DS($$DQ($$CTL($G(X))))))
 Q X
CTL(X) ;   Remove Control Characters
 Q $$CTL^ZZLEXXBM($G(X))
DQ(X) ;   Remove Double Quotes (there are no double quotes in ICD)
 Q $TR($G(X),"""","")
DS(X) ;   Remove Double Space
 S X=$G(X) Q:X="" X
 F  Q:X'["  "  S X=$P(X,"  ",1)_" "_$P(X,"  ",2,299)
 Q X
KILL ;   Kill Globals
 D KILL^ZZLEXXBA
 Q
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
