ZZLEXXVA ;SLC/KER - Import - FileMan Verify (Main) ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^ICD0(              ICR   4486
 ;    ^ICD9(              ICR   4485
 ;    ^LEX(757.02         SACC 1.3
 ;               
 ; External References
 ;    HOME^%ZIS           ICR  10086
 ;    FILE^DID            ICR   2052
 ;    $$GET1^DIQ          ICR   2056
 ;    ^DIR                ICR  10026
 ;    $$DT^XLFDT          ICR  10103
 ;               
FV ; One file, with update
 I $$INPROG^ZZLEXXVH("ALL^ZZLEXXVB")>0 W !,"  FileMan Field Verify is already inprogress, aborting" Q
 N %DT,ABR,ABT,ADAT,ALL,ANOD,APIE,BLD,CHG,CHGS,CHK,CMD,COMMIT,CRE
 N CTL,DIC,DIERR,DIRA,DISYS,ENV,ERR,EXP,EXT,FI,FILE,FIR,FOK,IEN,INP
 N IOP,LAS,LDAT,LIM,LIST,LNOD,LOC,LPIE,MET,MSG,MUMPS,NAM,ND,NDI,NDN
 N NDS,NEW,NM,NN,NODE,NS,NXT,OA,OK,OLD,ONODE,OUT,PIE,PKG,POP
 N POS,PSN,QUIET,REC,REV,ROOT,RT,RTNM,RVD,RVE,RVN,SEG,SM
 N STO,STR,TD,TMP,TNAME,TOT,TX,TXT,TY,VER,VRD,VRE,X,Y,Z
 N ZTDESC,ZTDTH,ZTIO,ZTQUEUED,ZTREQ,ZTRTN,ZTSAVE,ZTSK,CONT
 S ENV=$$ENV Q:+ENV'>0  W:$L($G(IOF)) @IOF
 S CHK=$$RUNNING^ZZLEXXVH I '$D(FORCE),CHK>0 D STA Q
 D EN^ZZLEXXVB N TEST,FORCE K %DT
 W !
 Q
FV2(X) ; One file, with update
 Q:$$INPROG^ZZLEXXVH("ICD10^ZZLEXXVB")>0 ""
 N %DT,ABR,ABT,ADAT,ALL,ANOD,APIE,BLD,CHG,CHGS,CHK,CMD,COMMIT,CRE,CTL
 N DIC,DIERR,DIRA,DISYS,ENV,ERR,EXP,EXT,FI,FILE,FIR,FOK,IEN,INP,IOP
 N LAS,LDAT,LIM,LIST,LNOD,LOC,LPIE,MET,MSG,MUMPS,NAM,ND,NDI,NDN,LEX,NDS
 N NEW,NM,NN,NODE,NS,NXT,OA,OK,OLD,ONODE,OUT,PIE,PKG,POP,POS,PSN,QUIET
 N REC,REV,ROOT,RT,RTNM,RVD,RVE,RVN,SEG,SM,STO,STR,TD,TMP,TNAME,TOT,TX
 N TXT,TY,VER,VRD,VRE,X,Y,Z,ZTDESC,ZTDTH,ZTIO,ZTQUEUED,ZTREQ,ZTRTN,ZTSAVE
 N ZTSK,CONT S ENV=$$ENV Q:+ENV'>0 ""  S CHK=$$RUNNING^ZZLEXXVH Q:CHK>0 ""
 S LEX=$$EN2^ZZLEXXVB N TEST,FORCE K %DT S X="" S:+LEX>0 X=LEX
 Q X
 ;                     
STA ; Status
 N FIR,LAS S FIR=$O(LIST(0)),LAS=$O(LIST(" "),-1)
 I FIR'>0,LAS'>0,+($G(CHK))'>0 Q
 I +($G(CHK))>0!(+($G(FIR))'>0)!($D(ABT)) D  Q
 . W !!,"  FileMan Field Verify aborting"
 . I +($G(CHK))>0 W ", already running" Q
 I +($G(FIR))>0 D
 . W !!,"  FileMan Field Verify tasked (#",FIR
 . W:LAS>0&(LAS>FIR) " to #",LAS W ")"
 W !
 Q
I10(X,Y) ;   Is ICD-10 Concept
 N FI,IEN,MC,SIEN S FI=$G(X),IEN=$G(Y) I "^757^757.001^757.01^757.02^757.1^80^80.1^"'[("^"_FI_"^") Q 1
 I "^80^80.1^"[("^"_FI_"^") D  Q X
 . S X=0 N SR S:FI=80 SR=$P($G(^ICD9(+IEN,1)),"^",1) S:FI=80.1 SR=$P($G(^ICD0(+IEN,1)),"^",1)
 . S X=$S("^30^31^"[("^"_$G(SR)_"^"):1,1:0)
 Q:'$D(^LEX(FI,+IEN,0)) 0  I +FI=757.02 D  Q X
 . S X=0 S:"^30^31^"[("^"_$P($G(^LEX(FI,+IEN,0)),"^",3)_"^") X=1
 S MC=0 S:FI=757!(FI=757.001) MC=IEN S:FI=757.01 MC=$P($G(^LEX(FI,+IEN,1)),"^",1)
 S:FI=757.02 MC=$P($G(^LEX(FI,+IEN,0)),"^",4) S:FI=757.1 MC=$P($G(^LEX(FI,+IEN,0)),"^",1) Q:+MC'>0 0  S (X,SIEN)=0
 F  S SIEN=$O(^LEX(757.02,"AMC",+MC,SIEN)) Q:+SIEN'>0  S:"^30^31^"[("^"_$P($G(^LEX(757.02,+SIEN,0)),"^",3)_"^") X=1
 Q X
SHO ; Show ^TMP Global
 D SHO^ZZLEXXVB
 Q
ENV(X) ; Environment
 D HOME^%ZIS S U="^",DT=$$DT^XLFDT,DTIME=300 K POP
 N NM S NM=$$GET1^DIQ(200,(DUZ_","),.01)
 I '$L(NM) W !!,?5,"Invalid/Missing DUZ" Q 0
 S:$G(DUZ(0))'["@" DUZ(0)=$G(DUZ(0))_"@"
 Q 1
FOK(X) ;   ICD-10 File is OK
 N TY,GL,MS,FI S (FI,X)=$G(X),TY=+($P(FI,".",1)) Q:'$L(FI) 0  Q:'$L(TY) 0  Q:+FI'>0 0
 D FILE^DID(FI,,"GLOBAL NAME","GL","MS") Q:'$L($G(GL("GLOBAL NAME"))) 0  Q:'$D(@("^DIC("_+FI_",0)")) 0
 Q:"^757^80^"'[("^"_TY_"^") 0  Q:TY=80&("^80^80.1^"'[("^"_FI_"^")) 0
 Q:TY=757&("^757^757.001^757.01^757.02^757.1^"'[("^"_FI_"^")) 0
 Q 1
