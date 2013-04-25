ZZRGUSD4 ;Unit Tests - Clinic API; 4/19/13
 ;;1.0;UNIT TEST;;05/28/2012;
 Q:$T(^SDMAPI1)=""
 TSTART
 I $T(EN^XTMUNIT)'="" D EN^XTMUNIT("ZZRGUSD4")
 TROLLBACK
 Q
STARTUP ;
 S DTIME=500,DUZ=1,U="^"
 K XUSER,XOPT
 D LOGON^ZZRGUSDC
 S DT=$P($$HTFM^XLFDT($H),".")
 D SETUP^ZZRGUSDC()
 Q
 ;
SHUTDOWN ;
 Q
 ;
MAKEUS ;
 N SDD,RETURN,RE,%
 S SDD=DT_".08",SDD=SDD_U_$$FMTE^XLFDT(SDD)
 S RTN="S %=$$MAKEUS^SDMAPI2(.RETURN,.PAT,.CLN,SDD,TYPE)"
 D EXSTPAT^ZZRGUSD5(RTN),EXSTCLN^ZZRGUSD5(RTN)
 ;undefined SD
 S %=$$MAKEUS^SDMAPI2(.RE,DFN,SC,"AA")
 D CHKEQ^XTMUNIT(RE_U_$P(RE(0),U),"0^INVPARAM","Expected: INVPARAM SD")
 D CHKEQ^XTMUNIT($P(RE(0),U,2)["SD",1,"Expected: INVPARAM SD")
 ;undefined TYP
 S %=$$MAKEUS^SDMAPI2(.RE,DFN,SC,SDD)
 D CHKEQ^XTMUNIT(RE_U_$P(RE(0),U),"0^INVPARAM","Expected: INVPARAM TYPE")
 D CHKEQ^XTMUNIT($P(RE(0),U,2)["TYPE",1,"Expected: INVPARAM TYPE")
 ;
 S %=$$MAKEUS^SDMAPI2(.RE,DFN,SC,,TYPE)
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: ")
 S SC0=+DFN_"^"_+LEN_"^^^^"_DUZ_"^"_DT
 D CHKEQ^XTMUNIT(^SC(+SC,"S",+RE(1),1,1,0),SC0,"Invalid clinic appointment - 0 node")
 S DPT0=+SC_"^^^^^^4^^^^^^^^^"_+TYPE_"^^"_DUZ_"^"_DT_"^^^^^0^W^0"
 D CHKEQ^XTMUNIT(^DPT(+DFN,"S",+RE(1),0),DPT0,"Invalid patient appointment - 0 node")
 ;future appt
 S %=$$MAKEUS^SDMAPI2(.RETURN,DFN,SC,$$FMADD^XLFDT($$NOW^XLFDT(),1),TYPE)
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"INVPARAM","Expected error: INVPARAM")
 ;invalid clinic
 S ^SC(+SC,"I")=DT-1_U_DT+1,SDD=DT_".1",SDD=SDD_U_$$FMTE^XLFDT(SDD)
 S %=$$MAKEUS^SDMAPI2(.RETURN,DFN,SC,SDD,TYPE)
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: APTCINV")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"APTCINV","Expected error: APTCINV")
 K ^SC(+SC,"I")
 Q
MAKECO ;
 N RETURN,%,COD
 K ^DPT(+DFN,"S"),^SC(+SC,"S")
 S ^XUSEC("SDOB",DUZ)="",^XUSEC("SDMOB",DUZ)=""
 ;future appointment cannot be checked out
 K ^DPT(+DFN,"S"),^SC(+SC,"S")
 S SD0=$$FMADD^XLFDT($$NOW^XLFDT(),,,1)
 S CIO="CO",CIO("DT")=$$NOW^XLFDT()
 S %=$$MAKEUS^SDMAPI2(.RETURN,DFN,SC,SD0,TYPE,,.CIO)
 D CHKEQ^XTMUNIT(RETURN,1,"Unxpected error: "_$G(RETURN(0)))
 D CHKEQ^XTMUNIT($G(RETURN("COD")),"","Past Appt, cannot be checked out.")
 ;appt checked out
 K ^DPT(+DFN,"S"),^SC(+SC,"S")
 S SD0=$E($$NOW^XLFDT(),1,10)
 S CIO="CO",CIO("DT")=$$NOW^XLFDT()
 S %=$$MAKEUS^SDMAPI2(.RETURN,DFN,SC,SD0,TYPE,,.CIO)
 D CHKEQ^XTMUNIT(RETURN,1,"Unxpected error: "_$G(RETURN(0)))
 D CHKEQ^XTMUNIT($G(RETURN("COD")),$E(CIO("DT"),1,12),"Incorrect check out date")
 ;appt checked out
 K ^DPT(+DFN,"S"),^SC(+SC,"S")
 S COD=$$NOW^XLFDT(),SD0=+$E(COD,1,10),COD=+$E(COD,1,12)
 S CIO="CO" ;,CIO("DT")=$$NOW^XLFDT()
 S %=$$MAKEUS^SDMAPI2(.RETURN,DFN,SC,SD0,TYPE,,.CIO)
 D CHKEQ^XTMUNIT(RETURN,1,"Unxpected error: "_$G(RETURN(0)))
 D CHKEQ^XTMUNIT(+$G(RETURN("COD")),COD,"Incorrect check out date")
 K ^XUSEC("SDOB",DUZ),^XUSEC("SDMOB",DUZ)
 Q
MAKECI ;
 N RETURN,%
 K ^DPT(+DFN,"S"),^SC(+SC,"S")
 S ^XUSEC("SDOB",DUZ)="",^XUSEC("SDMOB",DUZ)=""
 ;future appointment cannot be checked in
 S SD0=+$$FMADD^XLFDT($$NOW^XLFDT(),0,0,10),SD0=+$E(SD0,1,12),CIO="CI"
 S %=$$MAKEUS^SDMAPI2(.RETURN,DFN,SC,SD0,TYPE,,.CIO)
 D CHKEQ^XTMUNIT(RETURN,1,"Unxpected error: "_$G(RETURN(0)))
 D CHKEQ^XTMUNIT($G(RETURN("CI")),"","Future Appt cannot be checked in.")
 ;appt checked in
 S SDPAST=+$E($$NOW^XLFDT(),1,12)
 S %=$$MAKEUS^SDMAPI2(.RETURN,DFN,SC,SDPAST,TYPE,,.CIO)
 D CHKEQ^XTMUNIT(RETURN,1,"Unxpected error: "_$G(RETURN(0)))
 D CHKEQ^XTMUNIT(+$G(RETURN("CI")),+SDPAST,"Incorrect check in date")
 ;past appointment cannot be checked in
 S SDPAST=$E($$FMADD^XLFDT($$NOW^XLFDT(),-1),1,10)
 S %=$$MAKEUS^SDMAPI2(.RETURN,DFN,SC,SDPAST,TYPE,,.CIO)
 D CHKEQ^XTMUNIT(RETURN,1,"Unxpected error: "_$G(RETURN(0)))
 D CHKEQ^XTMUNIT($G(RETURN("CI")),"","Past Appt, cannot be checked in.")
 K ^XUSEC("SDOB",DUZ),^XUSEC("SDMOB",DUZ)
 Q
 ;
CHKTYP ; Check appt type
 N RETURN,%
 K ^DPT(+DFN,"S"),^SC(+SC,"S")
 ; Undefined type
 S SD0=$$NOW^XLFDT(),SD0=$E(SD0,1,12)+0.0001
 S %=$$MAKEUS^SDMAPI2(.RETURN,DFN,SC,SD0,,,)
 D CHKEQ^XTMUNIT(RETURN,0,"Unxpected error: "_$G(RETURN(0)))
 D CHKEQ^XTMUNIT(RETURN(0),"INVPARAM^Invalid parameter value - TYPE^1","Expected error: INVPARAM")
 ; Undefined type
 S SD0=$$NOW^XLFDT(),SD0=$E(SD0,1,12)+0.0001
 S %=$$MAKEUS^SDMAPI2(.RETURN,DFN,SC,SD0,$P(^SD(409.1,0),U,3)+1,,)
 D CHKEQ^XTMUNIT(RETURN,0,"Unxpected error: "_$G(RETURN(0)))
 D CHKEQ^XTMUNIT(RETURN(0),"TYPNFND^Appointment type not found.^1","Expected error: TYPNFND")
 ; Out of sync service conected
 S SD0=$$NOW^XLFDT(),SD0=$E(SD0,1,12)+0.0001
 S %=$$MAKEUS^SDMAPI2(.RETURN,DFN,SC,SD0,11,,)
 D CHKEQ^XTMUNIT(RETURN,0,"Unxpected error: "_$G(RETURN(0)))
 D CHKEQ^XTMUNIT(RETURN(0),"TYPINVSC^The 'SC Percent','Service Connected' and 'Primary Eligibility Codes' are OUT OF^1","Expected error: TYPINVSC")
 ; Out of sync service conected
 S SD0=$$NOW^XLFDT(),SD0=$E(SD0,1,12)+0.0001
 S %=$$MAKEUS^SDMAPI2(.RETURN,DFN,SC,SD0,4,,)
 D CHKEQ^XTMUNIT(RETURN,0,"Unxpected error: "_$G(RETURN(0)))
 D CHKEQ^XTMUNIT(RETURN(0),"TYPINVD^Patient must have the eligibility code EMPLOYEE, COLLATERAL or SHARING AGREEMENT^1","Expected error: TYPINVD")
 Q
CHKSTYP ; Check appt subtype
 N RETURN,%
 D SUBTYP^ZZRGUSDC
 ; Appointment subtype not found or inactive
 S SD0=$$NOW^XLFDT(),SD0=$E(SD0,1,12)+0.0001
 S %=$$MAKEUS^SDMAPI2(.RETURN,DFN,SC,SD0,9,3,)
 D CHKEQ^XTMUNIT(RETURN,0,"Unxpected error: "_$G(RETURN(0)))
 D CHKEQ^XTMUNIT(RETURN(0),"STYPNFND^Appointment subtype not found or inactive.^1","Expected error: STYPNFND")
 ; Unscheduled appointment subtype
 S SDD=DT_".08",SDD=SDD_U_$$FMTE^XLFDT(SDD)
 S %=$$MAKEUS^SDMAPI2(.RETURN,DFN,SC,SDD,TYPE,STYP)
 D CHKEQ^XTMUNIT(RETURN,1,"Unexpected error: ")
 S SC0=+DFN_"^"_+LEN_"^^^^"_DUZ_"^"_DT
 D CHKEQ^XTMUNIT(^SC(+SC,"S",+SDD,1,1,0),SC0,"Invalid clinic appointment - 0 node")
 S DPT0=+SC_"^^^^^^4^^^^^^^^^"_+TYPE_"^^"_DUZ_"^"_DT_"^^^^^"_+STYP_"^W^0"
 D CHKEQ^XTMUNIT(^DPT(+DFN,"S",+SDD,0),DPT0,"Invalid patient appointment - 0 node")
 ; Invalid sub type
 K ^SC(+SC,"ST",$P(SD,".")) S SDD=$P(SD,".",1)_".11"
 S %=$$MAKE^SDMAPI2(.RE,DFN,SC,SDD,TYPE,"AA",LEN,NXT,RSN,,,,,,,1)
 D CHKEQ^XTMUNIT(RE_U_$P(RE(0),U),"0^INVPARAM","Expected error: INVPARAM")
 ; Appointment subtype
 S %=$$MAKE^SDMAPI2(.RETURN,DFN,SC,SDD,TYPE,STYP,LEN,NXT,RSN,,,,,,,1)
 D CHKEQ^XTMUNIT(RETURN,1,"Unexpected error: "_$G(RETURN(0)))
 S SC0=+DFN_"^"_+LEN_"^^"_RSN_"^^"_DUZ_"^"_DT
 D CHKEQ^XTMUNIT(^SC(+SC,"S",+SDD,1,1,0),SC0,"Invalid clinic appointment - 0 node")
 S DPT0=+SC_"^^^^^^3^^^^^^^^^"_+TYPE_"^^"_DUZ_"^"_DT_"^^^^^"_+STYP_"^"_NXT_"^3"
 D CHKEQ^XTMUNIT(^DPT(+DFN,"S",+SDD,0),DPT0,"Invalid patient appointment - 0 node")
 Q
LSTASTYP ;Check appt subtype
 N RETURN,%
 S %=$$LSTASTYP^SDMAPI5(.RETURN,,,,TYPE) ; List appointment subtypes
 D CHKEQ^XTMUNIT(RETURN(0),"2^*^0^","Invalid 0 node")
 D CHKEQ^XTMUNIT(RETURN(1,"ID"),1,"Invalid appt subtype ID")
 D CHKEQ^XTMUNIT(RETURN(1,"NAME"),"Sharing 1","Invalid appt subtype NAME")
 D CHKEQ^XTMUNIT(RETURN(1,"STATUS"),"YES","Invalid appt subtype NAME")
 D CHKEQ^XTMUNIT(RETURN(2,"ID"),2,"Invalid appt subtype ID")
 D CHKEQ^XTMUNIT(RETURN(2,"NAME"),"Sharing 2","Invalid appt subtype NAME")
 D CHKEQ^XTMUNIT(RETURN(2,"STATUS"),"YES","Invalid appt subtype NAME")
 Q
MAKENA ; Request type
 N RE,%
 S SD1=$$FMADD^XLFDT(SD,-2)
 ; Invalid scheduling request type
 S %=$$MAKE^SDMAPI2(.RE,DFN,SC,SD1,TYPE,,LEN,,RSN,,,,,,,1)
 D CHKEQ^XTMUNIT(RE_U_$P(RE(0),U),"0^INVPARAM","Expected error: INVPARAM")
 ; Scheduling request type not found
 S %=$$MAKE^SDMAPI2(.RE,DFN,SC,SD1,TYPE,,LEN,"AAA",RSN,,,,,,,1)
 D CHKEQ^XTMUNIT(RE_U_$P(RE(0),U),"0^SRTNFND","Expected error: SRTNFND")
 ; Scheduling request type
 S %=$$MAKE^SDMAPI2(.RE,DFN,SC,SD1,TYPE,,LEN,NXT,RSN,,,,,,,1)
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 Q
MAKELAB ; LAB, EKG or X-RAY
 N RE,%
 S SD1=$$FMADD^XLFDT(SD,1)
 ; Invalid LAB
 S %=$$MAKE^SDMAPI2(.RE,DFN,SC,SD1,TYPE,,LEN,NXT,RSN,,"AA",,,,,1)
 D CHKEQ^XTMUNIT(RE_U_$P($G(RE(0)),U),"0^INVPARAM","Expected error: INVPARAM")
 ; Invalid LAB
 S %=$$MAKE^SDMAPI2(.RE,DFN,SC,SD1,TYPE,,LEN,NXT,RSN,,SD1,,,,,1)
 D CHKEQ^XTMUNIT(RE_U_$P($G(RE(0)),U),"0^TSTAHAPT","Expected error: TSTAHAPT")
 ; Invalid XRAY
 S LAB=$$FMADD^XLFDT(SD1,,1)
 S %=$$MAKE^SDMAPI2(.RE,DFN,SC,SD1,TYPE,,LEN,NXT,RSN,,LAB,"AA",,,,1)
 D CHKEQ^XTMUNIT(RE_U_$P($G(RE(0)),U),"0^INVPARAM","Expected error: INVPARAM")
 ; Invalid XRAY
 S %=$$MAKE^SDMAPI2(.RE,DFN,SC,SD1,TYPE,,LEN,NXT,RSN,,LAB,SD1,,,,1)
 D CHKEQ^XTMUNIT(RE_U_$P($G(RE(0)),U),"0^TSTAHAPT","Expected error: TSTAHAPT")
 ; Invalid EKG
 S LAB=$$FMADD^XLFDT(SD1,,1)
 S %=$$MAKE^SDMAPI2(.RE,DFN,SC,SD1,TYPE,,LEN,NXT,RSN,,LAB,LAB,"AA",,,1)
 D CHKEQ^XTMUNIT(RE_U_$P($G(RE(0)),U),"0^INVPARAM","Expected error: INVPARAM")
 ; Invalid EKG
 S %=$$MAKE^SDMAPI2(.RE,DFN,SC,SD1,TYPE,,LEN,NXT,RSN,,LAB,LAB,SD1,,,1)
 D CHKEQ^XTMUNIT(RE_U_$P($G(RE(0)),U),"0^TSTAHAPT","Expected error: TSTAHAPT")
 ; Already has apt
 S %=$$MAKE^SDMAPI2(.RE,DFN,SC,SD1,TYPE,,LEN,NXT,RSN,,SD1,SD1,SD1,,,1)
 D CHKEQ^XTMUNIT(RE_U_$P($G(RE(0)),U),"0^TSTAHAPT","Expected error: TSTAHAPT")
 ; Invalid consult param
 S %=$$MAKE^SDMAPI2(.RE,DFN,SC,SD1,TYPE,,LEN,NXT,RSN,,LAB,LAB,LAB,,"AAA",1)
 D CHKEQ^XTMUNIT(RE_U_$P($G(RE(0)),U),"0^INVPARAM","Expected error: INVPARAM")
 ; Invalid consult
 S %=$$MAKE^SDMAPI2(.RE,DFN,SC,SD1,TYPE,,LEN,NXT,RSN,,LAB,LAB,LAB,,1,1)
 D CHKEQ^XTMUNIT(RE_U_$P($G(RE(0)),U),"0^CNSNFND","Expected error: CNSNFND")
 ; Valid appt
 S ^GMR(123,1,0)=""
 S %=$$MAKE^SDMAPI2(.RE,DFN,SC,SD1,TYPE,,LEN,NXT,RSN,,LAB,LAB,LAB,,1,1)
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 Q
XTENT ;
 ;;MAKEUS;Make unscheduled appointment
 ;;MAKECI;Make appt check-in
 ;;MAKECO;Make appt check-out
 ;;CHKTYP;Check appt type
 ;;CHKSTYP;Check appt subtype
 ;;LSTASTYP;Check appt subtype
 ;;MAKENA;Request type
 ;;MAKELAB;LAB, EKG or X-RAY
