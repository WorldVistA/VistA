ZZLEXXBE ;SLC/KER - Import - ICD-10-PCS - Lex IA/RA ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^LEX(757.01         SACC 1.3
 ;    ^LEX(757.02         SACC 1.3
 ;    ^LEX(757.03         SACC 1.3
 ;               
 ; External References
 ;    FILE^DIE            ICR   2053
 ;    UPDATE^DIE          ICR   2053
 ;    IX1^DIK             ICR  10013
 ;    $$STATCHK^LEXSRC2   N/A
 ;    $$PATCH^XPDUTL      ICR  10141
 ;               
 ; Local Variables NEWed or KILLed Elsewhere
 ;     COMMIT,FULL,LSTAT,TEST
 ;               
 Q
IA(X,Y,Z) ; IA - Inactivate Code/Expression
 ;   Input
 ;     X    Code
 ;     Y    Status Effective Date
 ;     Z    Source
 N ACT,CODE,CDT,CTL,DA,EXIT,I,IEN,LAS,LEXCHK,ORD,PEFF,PIEN,PSTA,SF,LSTAD,TMP,SRC,CODES S ACT="IA"
 S CODE=$G(X),LSTAD=$G(Y),SRC=$G(Z) Q:'$L($G(CODE))  Q:$G(LSTAD)'?7N  Q:'$D(^LEX(757.03,+($G(SRC)),0))
 S (CTL,ORD)=CODE,ORD=$E(CODE,1,($L(CODE)-1))_$C($A($E(CODE,$L(CODE)))-1)_"~"
 F  S ORD=$O(^LEX(757.02,"CODE",ORD)) Q:'$L(ORD)  Q:$TR(ORD," ","")'=CTL  D
 . N IENS,IEN S IEN=0 F  S IEN=$O(^LEX(757.02,"CODE",ORD,IEN)) Q:+IEN'>0  D
 . . N DA,DIK,PEFF,PIEN,PSTA,LAS,SIEN,EXIT,TMP S SIEN=+($G(IEN)),TMP=LSTAD_"^"_LSTAT
 . . S DA=SIEN,DIK="^LEX(757.02," D IX1^DIK
 . . Q:$P($G(^LEX(757.02,+IEN,0)),"^",2)'=$G(CTL)
 . . Q:$P($G(^LEX(757.02,+IEN,0)),"^",3)'=+($G(SRC))
 . . S (EXIT,I)=0 F  S I=$O(^LEX(757.02,IEN,4,I)) Q:+I'>0  S:$G(^LEX(757.02,IEN,4,I,0))=TMP EXIT=1
 . . Q:EXIT  S PEFF=$O(^LEX(757.02,+IEN,4,"B",(LSTAD+.001)),-1)
 . . S PIEN=$O(^LEX(757.02,+IEN,4,"B",+PEFF," "),-1)
 . . S PSTA=$P($G(^LEX(757.02,+IEN,4,+PIEN,0)),"^",2) Q:PEFF?7N&(+PSTA="0")
 . . S PIEN=$O(^LEX(757.02,+IEN,4," "),-1)+1
 . . ;   Edit Status
 . . ;     Effective Date            757.28      .01
 . . ;     Status                    757.28       1
 . . I $D(COMMIT) D
 . . . N DA,FDA,FDAI,ERR,IENS K ERR,FDA,DA
 . . . S DA(1)=+($G(SIEN)),DA=+($G(PIEN)),IENS=("+1,"_DA(1)_",")
 . . . S FDA(757.28,IENS,.01)=$G(LSTAD)
 . . . S FDA(757.28,IENS,1)=0
 . . . S FDAI(1)=DA
 . . . D UPDATE^DIE(,"FDA","FDAI","ERR")
 . . . D:$D(ERR) ERR^ZZLEXXBD
 . . . I $$PATCH^XPDUTL("LEX*2.0*103")'>0,$D(@("^DD(757.02,5)")),$D(^LEX(757.02,DA,0)) D
 . . . . N DA,ERR,FDA K ERR,FDA,DA S DA=+($G(SIEN))
 . . . . S FDA(757.02,(DA_","),5)=1 D FILE^DIE(,"FDA","ERR") D:$D(ERR) ERR^ZZLEXXBD
 . . . D:$D(TEST) WRT^ZZLEXXBD I '$D(IENS(IEN)),$D(FULL) D
 . . . . N EXC W !,"Inactivation:",! N EIEN S EIEN=+($G(^LEX(757.02,+IEN,0)))
 . . . . S EXC="ZW ^LEX(757.01,+EIEN,0),^LEX(757.02,+IEN)" X EXC
 . . . S IENS(IEN)="",CODES(($G(CODE)_" "))=""
 . . K DA S DA=+($G(SIEN)),DIK="^LEX(757.02," D IX1^DIK
 . . I '$D(COMMIT),'$D(IENS(IEN)) D
 . . . D:$D(TEST) WRT^ZZLEXXBD Q:'$D(FULL)
 . . . N TMP,LAS,EIEN,EXP,IEN,PEFF,PIEN,OIEN,ODAT S TMP=$G(^LEX(757.02,+SIEN,0)),$P(TMP,"^",6)="1"
 . . . W !!,"Inactivation:" S EIEN=+TMP,EXP=$G(^LEX(757.01,+EIEN,0))
 . . . W:$L(EXP) !,"^LEX(757.01,",+EIEN,",0)=""",$G(EXP),""""
 . . . W !,"^LEX(757.02,",+SIEN,",0)=""",TMP,""""
 . . . S OIEN=$O(^LEX(757.02,+SIEN,4,"B",LSTAD,0))
 . . . S ODAT=$G(^LEX(757.02,+SIEN,4,+OIEN,0))
 . . . S TMP=$G(^LEX(757.02,+SIEN,4,0)),LAS=$O(^LEX(757.02,+SIEN,4," "),-1)+1
 . . . S:ODAT'=(LSTAD_"^0") ($P(TMP,"^",3),$P(TMP,"^",4))=LAS W !,"^LEX(757.02,",+SIEN,",4,0)=""",TMP,""""
 . . . S IEN=0 F  S IEN=$O(^LEX(757.02,+SIEN,4,IEN)) Q:+IEN'>0  D
 . . . . S TMP=$G(^LEX(757.02,+SIEN,4,+IEN,0)) Q:'$L(TMP)
 . . . . W !,"^LEX(757.02,",+SIEN,",4,",+IEN,",0)=""",TMP,""""
 . . . W:ODAT'=(LSTAD_"^0") !,"^LEX(757.02,",+SIEN,",4,",+LAS,",0)=""",+LSTAD,"^0",""""
 . . . S PEFF="" F  S PEFF=$O(^LEX(757.02,+SIEN,4,"B",PEFF)) Q:+PEFF'>0  D
 . . . . N IEN S IEN=0 F  S IEN=$O(^LEX(757.02,+SIEN,4,"B",PEFF,IEN)) Q:+IEN'>0  D
 . . . . . W !,"^LEX(757.02,",+SIEN,",4,""B"",",PEFF,",",+IEN,")="""""
 . . . W:ODAT'=(LSTAD_"^0") !,"^LEX(757.02,",+SIEN,",4,""B"",",+LSTAD,",",+LAS,")="""""
 Q
 ;
RA(X,Y,Z) ; RA - Reactivate Code/Expression
 ;   Input
 ;     X    Code
 ;     Y    Status Effective Date
 ;     Z    Source
 N ACT,CODE,DA,IEN,LAS,LEX,ODAT,OIEN,PEFF,PIEN,PSTA,SAB,SF,SIEN,LEXEXP,LEXSRC,LSTAD,TMP S ACT="RA"
 S CODE=$G(X),LSTAD=$G(Y),LEXSRC=$G(Z) Q:'$L($G(CODE))  Q:$G(LSTAD)'?7N  Q:'$D(^LEX(757.03,+($G(LEXSRC)),0))
 S SAB=$E($G(^LEX(757.03,+LEXSRC,0)),1,3) S LEX=$$STATCHK^LEXSRC2(CODE,(LSTAD+.0001),,SAB) Q:+LEX>0  S SF="757.28DA"
 S SIEN=$P(LEX,"^",2) Q:$P($G(^LEX(757.02,+SIEN,0)),"^",2)'=$G(CODE)
 S EIEN=+($P($G(^LEX(757.02,+SIEN,0)),"^",1)) Q:'$L($G(^LEX(757.01,+EIEN,0)))  S LEXEXP=$G(^LEX(757.01,+EIEN,0))
 Q:$P($G(^LEX(757.02,+SIEN,0)),"^",3)'=+($G(LEXSRC))
 S PEFF=$O(^LEX(757.02,+SIEN,4,"B",9999999),-1),PIEN=$O(^LEX(757.02,+SIEN,4,"B",+PEFF," "),-1)
 S PSTA=$P($G(^LEX(757.02,+SIEN,4,+PIEN,0)),"^",2) Q:+PSTA>0  S PIEN=$O(^LEX(757.02,+SIEN,4," "),-1)+1
 ;   Edit Status
 ;     Effective Date            757.28      .01
 ;     Status                    757.28       1
 I $D(COMMIT) D
 . N DA,ERR,FDA,FDAI,IENS K ERR,FDA,DA
 . S DA(1)=+($G(SIEN)),DA=+($G(PIEN)),IENS=("+1,"_DA(1)_",")
 . S FDA(757.28,IENS,.01)=$G(LSTAD)
 . S FDA(757.28,IENS,1)=1
 . S FDAI(1)=DA
 . D UPDATE^DIE(,"FDA","FDAI","ERR")
 . D:$D(ERR) ERR^ZZLEXXBD
 . I $$PATCH^XPDUTL("LEX*2.0*103")'>0,$D(@("^DD(757.02,5)")) D
 . . N DA,ERR,FDA K ERR,FDA,DA S DA=+($G(SIEN))
 . . S FDA(757.02,(DA_","),5)="" D FILE^DIE(,"FDA","ERR") D:$D(ERR) ERR^ZZLEXXBD
 . D:$D(TEST) WRT^ZZLEXXBD I $D(FULL) D
 . . N EXC W !,"Re-activation:",! N EIEN,EXP S EIEN=+($G(^LEX(757.02,+SIEN,0)))
 . . S EXC="ZW ^LEX(757.01,+EIEN,0),^LEX(757.02,+SIEN)" X EXC
 I '$D(COMMIT) D
 . D:$D(TEST) WRT^ZZLEXXBD Q:'$D(FULL)
 . N TMP,LAS,EIEN,EXP,IEN,PEFF,PIEN,OIEN,ODAT S TMP=$G(^LEX(757.02,+SIEN,0)),$P(TMP,"^",6)=""
 . W !!,"Re-activation:" S EIEN=+TMP,EXP=$G(^LEX(757.01,+EIEN,0))
 . W:$L(EXP) !,"^LEX(757.01,",+EIEN,",0)=""",EXP,""""
 . W !,"^LEX(757.02,",+SIEN,",0)=""",TMP,""""
 . S OIEN=$O(^LEX(757.02,+SIEN,4,"B",LSTAD,0))
 . S ODAT=$G(^LEX(757.02,+SIEN,4,+OIEN,0))
 . S TMP=$G(^LEX(757.02,+SIEN,4,0)),LAS=$O(^LEX(757.02,+SIEN,4," "),-1)+1
 . S:ODAT'=(LSTAD_"^1") ($P(TMP,"^",3),$P(TMP,"^",4))=LAS W !,"^LEX(757.02,",+SIEN,",4,0)=""",TMP,""""
 . S IEN=0 F  S IEN=$O(^LEX(757.02,+SIEN,4,IEN)) Q:+IEN'>0  D
 . . S TMP=$G(^LEX(757.02,+SIEN,4,+IEN,0)) Q:'$L(TMP)
 . . W !,"^LEX(757.02,",+SIEN,",4,",+IEN,",0)=""",TMP,""""
 . W:ODAT'=(LSTAD_"^1") !,"^LEX(757.02,",+SIEN,",4,",+LAS,",0)=""",+LSTAD,"^1",""""
 . S PEFF="" F  S PEFF=$O(^LEX(757.02,+SIEN,4,"B",PEFF)) Q:+PEFF'>0  D
 . . N IEN S IEN=0 F  S IEN=$O(^LEX(757.02,+SIEN,4,"B",PEFF,IEN)) Q:+IEN'>0  D
 . . . W !,"^LEX(757.02,",+SIEN,",4,""B"",",PEFF,",",+IEN,")="""""
 . W:ODAT'=(LSTAD_"^1") !,"^LEX(757.02,",+SIEN,",4,""B"",",+LSTAD,",",+LAS,")="""""
 Q
KILL ;   Kill Globals
 D KILL^ZZLEXXBA
 Q
