ZZLEXXAT ;SLC/KER - Import - ICD-10-CM - Preferred Term ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^LEX(757.01         SACC 1.3
 ;    ^LEX(757.02,        SACC 1.3
 ;               
 ; External References
 ;    IX1^DIK             ICR  10013
 ;    IX2^DIK             ICR  10013
 ;    $$STATCHK^LEXSRC2   N/A
 ;    $$MIX^LEXXMC        N/A
 ;    $$FMADD^XLFDT       ICR  10103
 ;    $$FMDIFF^XLFDT      ICR  10103
 ;    $$NOW^XLFDT         ICR  10103
 ;    $$UP^XLFSTR         ICR  10105
 ;               
 ; Local Variables NEWed or KILLed Elsewhere
 ;     COMMIT
 ;               
 Q
EN ; Main Entry Point for Preferred Terms
 Q:'$D(COMMIT)  N %,LASTF,LASTI,SAB,BEG,END,ELP,FIX S BEG=$$NOW^XLFDT
 S SAB="10D",LASTF=$$LF(SAB),LASTI=$$LI(SAB)
 I $L(LASTF),LASTF=LASTI S (FIX,COMMIT)=1 D PT(SAB)
 S END=$$NOW^XLFDT,ELP=$$FMDIFF^XLFDT(END,BEG,3)
 Q 
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
PT(X) ; ICD-10 Preferred Terms
 N ORD,SAB,SRC,RT S ORD="",SAB=$G(X) Q:"^10D^10P^"'[("^"_SAB_"^")
 S RT=$S(SAB="10D":"^ICD9(",SAB="10P":"^ICD0(",1:"") Q:'$L(RT)
 S SRC=$S(SAB="10D":30,SAB="10P":31,1:"") Q:SRC'>0
 F  S ORD=$O(@(RT_"""ABA"","_+SRC_","""_ORD_""")")) Q:'$L(ORD)  D
 . N IIEN S IIEN=0 F  S IIEN=$O(@(RT_"""ABA"","_+SRC_","""_ORD_""","_+IIEN_")")) Q:+IIEN'>0  D
 . . N CDT,CODE,HIEN,ICDT,FDT,STAT,SIEN,LIEN,LEXT,DA,DIK
 . . S CDT=9999999 Q:"^10D^10P^"'[("^"_$G(SAB)_"^")
 . . S CDT=$O(@(RT_+IIEN_",68,""B"","_+CDT_")"),-1) Q:CDT'?7N
 . . S CODE=$P($G(@(RT_+IIEN_",0)")),"^",1) Q:'$L(CODE)
 . . S HIEN=$O(@(RT_+IIEN_",68,""B"","_+CDT_","" "")"),-1) Q:+HIEN'>0
 . . S ICDT=$G(@(RT_+IIEN_",68,"_+HIEN_",1)")) Q:'$L(ICDT)
 . . I $$UP^XLFSTR(ICDT)=ICDT,$D(FIX) D
 . . . N DA,DIK S ICDT=$$MIX^LEXXMC(ICDT)
 . . . S DA(1)=+IIEN,DA=+HIEN,DIK=RT_+IIEN_",68," D IX2^DIK
 . . . S @(RT_+IIEN_",68,"_+HIEN_",1)")=ICDT
 . . . S DA(1)=+IIEN,DA=+HIEN,DIK=RT_+IIEN_",68," D IX1^DIK
 . . S FDT=$$FMADD^XLFDT(CDT,1)
 . . S STAT=$$STATCHK^LEXSRC2(CODE,FDT,,SAB)
 . . S SIEN=$P(STAT,"^",2) Q:+SIEN'>0
 . . S LIEN=+($G(^LEX(757.02,+SIEN,0))) Q:+LIEN'>0
 . . S LEXT=$G(^LEX(757.01,+LIEN,0))
 . . I $$UP^XLFSTR(LEXT)'=LEXT,$$UP^XLFSTR(ICDT)=$$UP^XLFSTR(LEXT) Q
 . . I $D(FIX) D
 . . . N TERM S TERM=$G(ICDT) S:$$UP^XLFSTR(TERM)=TERM TERM=$$MIX^LEXXMC(TERM)
 . . . Q:'$D(FIX)  Q:'$D(COMMIT)  I +($G(LIEN))>0 D
 . . . . N DA,DIK S DA=+LIEN,DIK="^LEX(757.01," D IX2^DIK
 . . . . S ^LEX(757.01,+DA,0)=TERM D IX1^DIK
 Q
