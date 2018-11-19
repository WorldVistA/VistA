ZZRGUTRB ;RGI/CBR,KW/JPS - Unit Tests - RPC Broker ;12/05/2014
 ;;1.0;UNIT TEST;;Apr 25, 2012;Build 1
 TSTART
 I $T(EN^%ut)'="" D EN^%ut("ZZRGUTRB")
 TROLLBACK
 Q
 ;
STARTUP ;
 N GMPIFN1,GMPIFN2,LOC
 S DTIME=500 ;D INIT^GMPLMGR
 K XUSER,XOPT
 D LOGON^ZZRGUTCM
 S GMPROV=1
 S DT=$P($$HTFM^XLFDT($H),".")
 D SELCLIN^ZZRGUTCM
 S U="^"
 D NEWPAT^ZZRGUTCM
 S LSTNAME="List"_DT
 S CATNAME="Diabetes"_DT
 S LOC=GMPCLIN
 D ADDLIST^ZZRGUTCM(.LIST,LSTNAME,CATNAME,+LOC)
 S LSTIEN=+$G(LIST("LST"))
 S CATIEN=+$G(LIST("CAT"))
 D ASSUSR^ZZRGUTCM(LSTIEN,DUZ)
 Q
 ;
SHUTDOWN ;
 ;TROLLBACK
 Q
 ;
ADDSAVE ;
 N PROB1,PROB2,FLDS,DA
 D NISTPRBS^ZZRGUTCM(.PROB1,.PROB2)
 D ORARY^ZZRGUTCM(.PROB1,.FLDS)
 D ADDSAVE^ORQQPL1(.GMPIFN1,GMPDFN,GMPROV,GMPVAMC,.FLDS)
 S:GMPIFN1>0 GMPIFN1=$O(^AUPNPROB("%"),-1)
 D CHKTF^%ut(GMPIFN1>0,"NEW^GMPLSAVE: save failed ("_$G(GMPIFN2(0))_")")
 D:GMPIFN1 CHKPRB^ZZRGUTCM(GMPIFN1,.PROB1,"P")
 K FLDS
 D ORARY^ZZRGUTCM(.PROB2,.FLDS)
 D ADDSAVE^ORQQPL1(.GMPIFN2,GMPDFN,GMPROV,GMPVAMC,.FLDS)
 S GMPIFN2=$O(^AUPNPROB("%"),-1)
 D CHKTF^%ut(GMPIFN2>0,"NEW^GMPLSAVE: save failed ("_$G(GMPIFN2(0))_")")
 D:GMPIFN2 CHKPRB^ZZRGUTCM(GMPIFN2,.PROB2,"P")
 Q
 ;
PROBL ;
 N LISTP,LISTH
 D PROBL^ORQQPL3(.LISTP,GMPDFN,"A")
 D CHKTF^%ut(+$G(LISTP(0))=1,"Invalid number of records")
 D CHKEQ^%ut(GMPIFN1,$P($G(LISTP(1)),U),"Invalid record returned")
 D PROBL^ORQQPL3(.LISTH,GMPDFN,"R")
 D CHKTF^%ut(+$G(LISTH(0))=1,"Invalid number of records")
 D CHKEQ^%ut(GMPIFN2,$P($G(LISTH(1)),U),"Invalid record returned")
 Q
 ;
INACT ;
 N RETURN
 D INACT^ORQQPL2(.RETURN,GMPIFN2)
 D CHKTF^%ut(RETURN>0,"INACT^ORQQPL2 failed: "_$G(RETURN(0)))
 D CHKEQ^%ut("I",$P(^AUPNPROB(GMPIFN2,0),U,12),"Problem not inactivated ("_GMPIFN2_")")
 I RETURN>0 D
 . K ^AUPNPROB("ACTIVE",GMPDFN,"A",GMPIFN2)
 . S ^AUPNPROB("ACTIVE",GMPDFN,"I",GMPIFN2)=""
 Q
 ;
DELETE ;
 N RESULT
 D DELETE^ORQQPL2(.RESULT,GMPIFN2,GMPROV,GMPVAMC,"deletecomment")
 D CHKTF^%ut(RESULT>0,"DELETE^ORQQPL2 failed: "_$G(RESULT(0)))
 D CHKEQ^%ut("H",$P(^AUPNPROB(GMPIFN2,1),U,2),"Problem not deleted ("_GMPIFN2_")")
 K RESULT
 D DELLIST^ORQQPL3(.RESULT,GMPDFN)
 D CHKEQ^%ut(1,$G(RESULT(0)),"DELLIST^ORQQPL3: Number of deleted problems")
 D CHKTF^%ut($G(RESULT(1))[GMPIFN2_"^I^Essential Hypertension","DELLIST^ORQQPL3: List fields")
 D CHKTF^%ut($G(RESULT(1))[";^401.9^3100330^"_DT_"^NSC^^H^3^C^^^C^1^^NSC^","DELLIST^ORQQPL3: List Fields2")
 Q
 ;
REPLACE ;
 N RETURN
 D REPLACE^ORQQPL2(.RETURN,GMPIFN1)
 D CHKTF^%ut(RETURN=0,"Error. Replaced an active problem ("_GMPIFN1_")")
 K RETURN
 D REPLACE^ORQQPL2(.RETURN,GMPIFN2)
 D CHKTF^%ut(RETURN>0,"REPLACE^ORQQPL2 failed: "_$G(RETURN(0)))
 D CHKEQ^%ut("P",$P(^AUPNPROB(GMPIFN2,1),U,2),"Problem not replaced ("_GMPIFN2_")")
 Q
 ;
VERIFY ;
 N RETURN
 D VERIFY^ORQQPL2(.RETURN,GMPIFN2)
 D CHKTF^%ut(RETURN'>0,"Error. Verified a permanent problem ("_GMPIFN2_")")
 D CHKEQ^%ut("Problem Already Verified",$G(RETURN(0)),"Invalid error message")
 K RETURN
 S $P(^AUPNPROB(GMPIFN2,1),U,2)="T"
 D VERIFY^ORQQPL2(.RETURN,GMPIFN2)
 D CHKTF^%ut(RETURN>0,"VERIFY^ORQQPL2 failed: "_$G(RETURN(0)))
 D CHKEQ^%ut("P",$P(^AUPNPROB(GMPIFN2,1),U,2),"Problem not verified ("_GMPIFN2_")")
 Q
 ;
GETCOMM ;
 N ORY,CNT,I
 D GETCOMM^ORQQPL2(.ORY,GMPIFN2)
 S CNT=0,I=""
 F  S I=$O(ORY(I)) Q:I=""  S CNT=CNT+1
 D CHKEQ^%ut(2,CNT,"Invalid number of comments: "_CNT)
 D:CNT>0 CHKEQ^%ut("testcomment4",ORY(1),"Invalid comment returned")
 D:CNT>1 CHKEQ^%ut("deletecomment",ORY(2),"Invalid comment returned")
 Q
 ;
INITUSER ;
 N RET,SITE
 D INITUSER^ORQQPL1(.RET,DUZ)
 S SITE=$G(^GMPL(125.99,1,0))
 D CHKEQ^%ut("1",$G(RET(0)),"INITUSER: Is clinical user?")
 D CHKEQ^%ut("",$G(RET(1)),"INITUSER: Default view")
 D CHKEQ^%ut($P(SITE,U,2),$G(RET(2)),"INITUSER: Verify transcribed problems?")
 D CHKEQ^%ut($P(SITE,U,3),$G(RET(3)),"INITUSER: Prompt for chart copy?")
 D CHKEQ^%ut($P(SITE,U,4),$G(RET(4)),"INITUSER: Use lexicon?")
 D CHKEQ^%ut($S($P(SITE,U,5)="R":1,1:0),$G(RET(5)),"INITUSER: Chronological or reverse chron listing?")
 D CHKEQ^%ut("A",$G(RET(6)),"INITUSER: Context problems")
 D CHKEQ^%ut("0^All",$G(RET(7)),"INITUSER: PROVIDER^NAME")
 D CHKEQ^%ut("",$G(RET(8)),"INITUSER: user's service/section")
 D CHKEQ^%ut("",$G(RET(9)),"INITUSER: Service")
 D CHKEQ^%ut("",$G(RET(10)),"INITUSER: Clinic")
 D CHKEQ^%ut("",$G(RET(11)),"INITUSER: N/A")
 D CHKEQ^%ut("1",$G(RET(12)),"INITUSER: Should comments display?")
 Q
 ;
HISTORY ;
 N RET,EXTDT,DUZN,GMPNAME,CNT,I
 D HIST^ORQQPL2(.RET,GMPIFN2)
 D CHKEQ^%ut(4,RET(0),"HIST^ORQQPL2: # of events.")
 S EXTDT=$$EXTDT^GMPLX(DT)
 S DUZN=$P(^VA(200,DUZ,0),U)
 S GMPNAME=$P(^VA(200,GMPROV,0),U)
 S CNT=0
 F I=1:1:4 D
 . I $G(RET(I))=(EXTDT_U_"STATUS changed by "_DUZN_" from ACTIVE to INACTIVE") S CNT=CNT+1
 . I $G(RET(I))=(EXTDT_U_"PROBLEM removed by "_GMPNAME) S CNT=CNT+1
 . I $G(RET(I))=(EXTDT_U_"PROBLEM placed back on list by "_DUZN) S CNT=CNT+1
 . I $G(RET(I))=(EXTDT_U_"PROBLEM verified by "_DUZN) S CNT=CNT+1
 D CHKEQ^%ut(4,CNT,"HIST^ORQQPL2: Only "_CNT_" out of 4 history entries match")
 Q
 ;
XTENT ;
 ;;ADDSAVE
 ;;INACT
 ;;DELETE
 ;;PROBL
 ;;REPLACE
 ;;VERIFY
 ;;GETCOMM
 ;;HISTORY
 ;;INITUSER
 Q
 ;
