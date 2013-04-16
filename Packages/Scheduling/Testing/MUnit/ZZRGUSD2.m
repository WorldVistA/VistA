ZZRGUSD2 ;Unit Tests - Clinic API; 4/23/13
 ;;1.0;UNIT TEST;;05/28/2012;
 Q:$T(^SDMAPI1)=""
 TSTART
 I $T(EN^XTMUNIT)'="" D EN^XTMUNIT("ZZRGUSD2")
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
MAKE ;
 N RETURN,RE,R,%
 S TC=$P(^SC(+SC,0),U,7)
 S SCODE=105,$P(^SC(+SC,0),U,7)=105
 S CONS=$$ADDREQ^ZZRGUSDC(SD,DFN,SCODE)
 S $P(^SC(+SC,0),U,7)=TC
 ;
 S RTN="S %=$$MAKE^SDMAPI2(.RETURN,.PAT,.CLN,SD,TYPE,,LEN)"
 D EXSTPAT^ZZRGUSD5(RTN),EXSTCLN^ZZRGUSD5(RTN)
 S %=$$MAKE^SDMAPI2(.RE,DFN,SC) ; invalid SD
 D CHKEQ^XTMUNIT(RE_U_$P(RE(0),U),"0^INVPARAM","Expected: INVPARAM SD")
 D CHKEQ^XTMUNIT($P(RE(0),U,2)["SD",1,"Expected: INVPARAM SD")
 S %=$$MAKE^SDMAPI2(.RE,DFN,SC,SD) ; invalid LEN
 D CHKEQ^XTMUNIT(RE_U_$P(RE(0),U),"0^INVPARAM","Expected: INVPARAM LEN")
 D CHKEQ^XTMUNIT($P(RE(0),U,2)["LEN",1,"Expected: INVPARAM LEN")
 S %=$$MAKE^SDMAPI2(.RE,DFN,SC,SD,,,LEN) ; invalid TYPE
 D CHKEQ^XTMUNIT(RE_U_$P(RE(0),U),"0^INVPARAM","Expected: INVPARAM TYPE")
 D CHKEQ^XTMUNIT($P(RE(0),U,2)["TYPE",1,"Expected: INVPARAM TYPE")
 S %=$$MAKE^SDMAPI2(.RETURN,DFN,SC2,SD,TYPE,,LEN,NXT,RSN,,,,,,CONS)
 D CHKEQ^XTMUNIT(RETURN,1,"Unexpected error: "_$G(RETURN(0)))
 S SC0=+DFN_"^"_+LEN_"^^"_RSN_"^^"_DUZ_"^"_DT
 D CHKEQ^XTMUNIT(^SC(+SC2,"S",+SD,1,1,0),SC0,"Invalid clinic appointment - 0 node")
 S DPT0=+SC2_"^^^^^^3^^^^^^^^^"_+TYPE_"^^"_DUZ_"^"_DT_"^^^^^0^"_NXT_"^3"
 D CHKEQ^XTMUNIT(^DPT(+DFN,"S",+SD,0),DPT0,"Invalid patient appointment - 0 node")
 ; already has appt
 S %=$$MAKE^SDMAPI2(.R,DFN,SC,SD,TYPE,,LEN,NXT,RSN,,,,,,CONS)
 D CHKEQ^XTMUNIT(R_U_$P(R(0),U),"0^APTPAHA","Already has appt")
 ; cancel existing appt
 S %=$$MAKE^SDMAPI2(.R,DFN,SC,SD,TYPE,,LEN,NXT,RSN,,,,,,CONS,1)
 D CHKEQ^XTMUNIT(R,1,"Appt made/old cancelled")
 S SC0=+DFN_"^"_+LEN_"^^"_RSN_"^^"_DUZ_"^"_DT
 D CHKEQ^XTMUNIT(^SC(+SC,"S",+SD,1,1,0),SC0,"Invalid clinic appointment - 0 node")
 S DPT0=+SC_"^^^^^^3^^^^^^^^^"_+TYPE_"^"_+SC2_"^"_DUZ_"^"_DT_"^^^^^0^"_NXT_"^3"
 D CHKEQ^XTMUNIT(^DPT(+DFN,"S",+SD,0),DPT0,"Invalid patient appointment - 0 node")
 D CHKEQ^XTMUNIT($D(^SC(+SC2,"S",+SD,1,1)),0,"Appt not cancelled")
 Q
CHECKIN ;
 ;Invalid check-in date
 N RE,RETURN,%
 S %=$$CHECKIN^SDMAPI2(.RE,DFN,SD,SC,"AA"),NOW=$$NOW^XLFDT()
 D CHKEQ^XTMUNIT(RE_U_$P(RE(0),U),"0^INVPARAM","Expected: INVPARAM CIDT")
 ;
 S %=$$CHECKIN^SDMAPI2(.RETURN,DFN,SD,SC),NOW=$$NOW^XLFDT()
 S SC0=+DFN_"^"_+LEN_"^^"_RSN_"^^"_DUZ_"^"_DT_"^^^"
 S SCC=+$J(NOW,2,4)_"^"_DUZ_"^^^"_NOW
 D CHKEQ^XTMUNIT(^SC(+SC,"S",+SD,1,1,0),SC0,"Invalid clinic appointment - 0 node")
 D CHKEQ^XTMUNIT(^SC(+SC,"S",+SD,1,1,"C"),SCC,"Invalid clinic appointment - C node")
 S DPT0=+SC_"^^^^^^3^^^^^^^^^"_+TYPE_"^"_+SC2_"^"_DUZ_"^"_DT_"^^^^^0^"_NXT_"^3"
 D CHKEQ^XTMUNIT(^DPT(+DFN,"S",+SD,0),DPT0,"Invalid patient appointment - 0 node")
 S RTN="S %=$$CHECKIN^SDMAPI2(.RETURN,.PAT,SD,.CLN)"
 D EXSTPAT^ZZRGUSD5(RTN),EXSTCLN^ZZRGUSD5(RTN)
 S %=$$CHECKIN^SDMAPI2(.RE,DFN,,SC)
 D CHKEQ^XTMUNIT(RE_U_$P(RE(0),U),"0^INVPARAM","Expected: INVPARAM SD")
 D CHKEQ^XTMUNIT($P(RE(0),U,2)["SD",1,"Expected: INVPARAM SD")
 S %=$$CHECKIN^SDMAPI2(.RE,DFN,2,SC)
 D CHKEQ^XTMUNIT(RE_U_$P(RE(0),U),"0^APTNFND","Expected: APTNFND")
 Q
NOSHOW ;
 N RETURN,RE,%
 S %=$$NOSHOW^SDMAPI2(.RETURN,DFN,SC,SD),NOW=$$NOW^XLFDT()
 D CHKEQ^XTMUNIT(RETURN,1,"Unxpected error: "_$G(RETURN(0)))
 S SC0=+DFN_"^"_+LEN_"^^"_RSN_"^^"_DUZ_"^"_DT_"^^^"
 D CHKEQ^XTMUNIT(^SC(+SC,"S",+SD,1,1,0),SC0,"Invalid clinic appointment 0 node")
 S DPT0=+SC_"^N^^^^^3^^^^^"_DUZ_"^^"_NOW_"^^"_+TYPE_"^"_+SC2_"^"_DUZ_"^"_DT_"^^^^^0^"_NXT_"^3"
 D CHKEQ^XTMUNIT(^DPT(+DFN,"S",+SD,0),DPT0,"Invalid patient appointment - 0 node")
 I $P(^DPT(+DFN,"S",+SD,0),U,2)="N" D
 . S NOW=$$NOW^XLFDT(),%=$$CANCEL^SDMAPI2(.RETURN,DFN,SC,SD,"PC",CRSN,"Cancellation test remarks")
 . D CHKEQ^XTMUNIT(RETURN,0,"Expected error: APTCNPE")
 . D CHKEQ^XTMUNIT($P(RETURN(0),U),"APTCNPE","Expected error: APTCNPE")
 S $P(^GMR(123,CONS,0),U,12)=13
 S %=$$GETAPCNS^SDCAPI1(.RETURN,DFN,SCODE)
 D CHKEQ^XTMUNIT(RETURN,1,"Unexpected error: "_$G(RETURN(0)))
 S %=$$NOSHOW^SDMAPI2(.RETURN,DFN,SC,SD),NOW=$$NOW^XLFDT()
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: APTNSAL")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"APTNSAL","Expected error: APTNSAL")
 S %=$$NOSHOW^SDMAPI2(.RETURN,DFN,SC,SD,1),NOW=$$NOW^XLFDT()
 D CHKEQ^XTMUNIT(RETURN,1,"Unxpected error: "_$G(RETURN(0)))
 D CHKEQ^XTMUNIT($P(^DPT(+DFN,"S",+SD,0),U,2),"","Unxpected error: "_$G(RETURN(0)))
 S RTN="S %=$$NOSHOW^SDMAPI2(.RETURN,.PAT,.CLN,SD,1)"
 D EXSTPAT^ZZRGUSD5(RTN),EXSTCLN^ZZRGUSD5(RTN)
 S %=$$NOSHOW^SDMAPI2(.RE,DFN,SC,,1)
 D CHKEQ^XTMUNIT(RE_U_$P(RE(0),U),"0^INVPARAM","Expected: INVPARAM SD")
 D CHKEQ^XTMUNIT($P(RE(0),U,2)["SD",1,"Expected: INVPARAM SD")
 S %=$$NOSHOW^SDMAPI2(.RE,DFN,SC,2,1)
 D CHKEQ^XTMUNIT(RE_U_$P(RE(0),U),"0^APTNFND","Expected: APTNFND")
 ; future appt
 S %=$$MAKE^SDMAPI2(.RE,DFN,SC,$$FMADD^XLFDT(SD,1),TYPE,,LEN,NXT,RSN,,,,,,CONS)
 S $P(^SC(+SC,0),U,17)="N"
 S %=$$NOSHOW^SDMAPI2(.RE,DFN,SC,$$FMADD^XLFDT(SD,1))
 D CHKEQ^XTMUNIT(RE_U_$P(RE(0),U),"0^APTNSCE","Expected: APTNSCE")
 S $P(^SC(+SC,0),U,17)="Y"
 S %=$$NOSHOW^SDMAPI2(.RE,DFN,SC,$$FMADD^XLFDT(SD,1))
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 Q
CANCEL ;
 N RETURN,RE,%,DPT1
 K ^DPT(+DFN,"S"),^SC(+SC,"S")
 S SD=$P(DT,".")_".09",SD=SD_U_$$FMTE^XLFDT(SD)
 S %=$$MAKE^SDMAPI2(.RETURN,DFN,SC,SD,TYPE,,LEN,NXT,RSN,,,,,,CONS)
 ;Cancellation reason errors (INVPARAM)
 S %=$$CANCEL^SDMAPI2(.RETURN,DFN,SC,SD,"PC",,)
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"INVPARAM","Expected error: INVPARAM")
 ;Cancellation reason errors (RSNNFND)
 S %=$$CANCEL^SDMAPI2(.RETURN,DFN,SC,SD,"PC",$P(^SD(409.2,0),U,3)+1,"Cancellation test remarks")
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: RSNNFND")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"RSNNFND","Expected error: RSNNFND")
 ;Cancelled by errors (INVPARAM)
 S %=$$CANCEL^SDMAPI2(.RETURN,DFN,SC,SD,,CRSN,"Cancellation test remarks")
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"INVPARAM","Expected error: INVPARAM")
 ;Cancelled by errors (INVPARAM)
 S %=$$CANCEL^SDMAPI2(.RETURN,DFN,SC,SD,"C",5,"Cancellation test remarks")
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"INVPARAM","Expected error: INVPARAM")
 ;
 ;
 S %=$$GETAPCNS^SDCAPI1(.RETURN,DFN,SCODE)
 D CHKEQ^XTMUNIT(RETURN,1,"Unexpected error: "_$G(RETURN(0)))
 S $P(^DPT(+DFN,"S",+SD,0),U,2)="C"
 S RTN="S %=$$CANCEL^SDMAPI2(.RETURN,.PAT,.CLN,SD,""PC"",RSN,)"
 D EXSTPAT^ZZRGUSD5(RTN),EXSTCLN^ZZRGUSD5(RTN)
 ;undefined TYP
 S %=$$CANCEL^SDMAPI2(.RE,DFN,SC,,,,)
 D CHKEQ^XTMUNIT(RE_U_$P(RE(0),U),"0^INVPARAM","Expected: INVPARAM TYP")
 D CHKEQ^XTMUNIT($P(RE(0),U,2)["TYP",1,"Expected: INVPARAM TYP")
 ;undefined SD
 S %=$$CANCEL^SDMAPI2(.RE,DFN,SC,,"C",,)
 D CHKEQ^XTMUNIT(RE_U_$P(RE(0),U),"0^INVPARAM","Expected: INVPARAM SD")
 D CHKEQ^XTMUNIT($P(RE(0),U,2)["SD",1,"Expected: INVPARAM SD")
 ;undefined RSN
 S %=$$CANCEL^SDMAPI2(.RE,DFN,SC,SD,"C",,)
 D CHKEQ^XTMUNIT(RE_U_$P(RE(0),U),"0^INVPARAM","Expected: INVPARAM RSN")
 D CHKEQ^XTMUNIT($P(RE(0),U,2)["RSN",1,"Expected: INVPARAM RSN")
 ;reason not found
 S %=$$CANCEL^SDMAPI2(.RE,DFN,SC,SD,"C",$P(^SD(409.2,0),U,3)+1,)
 D CHKEQ^XTMUNIT(RE_U_$P(RE(0),U),"0^RSNNFND","Expected: RSNNFND")
 ;appt not found
 S %=$$CANCEL^SDMAPI2(.RE,DFN,SC,2,"C",CRSN,)
 D CHKEQ^XTMUNIT(RE_U_$P(RE(0),U),"0^APTNFND","Expected: APTNFND")
 ; Already cancelled
 S %=$$CANCEL^SDMAPI2(.RETURN,DFN,SC,SD,"PC",CRSN,"Cancellation test remarks")
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: APTCAND")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"APTCAND","Expected error: APTCAND")
 S $P(^DPT(+DFN,"S",+SD,0),U,2)=""
 ; Checked out
 S $P(^SC(+SC,"S",+SD,1,1,"C"),U,3)=+SD
 S %=$$CANCEL^SDMAPI2(.RETURN,DFN,SC,SD,"PC",CRSN,"Cancellation test remarks")
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: APTCCHO")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"APTCCHO","Expected error: APTCCHO")
 S $P(^SC(+SC,"S",+SD,1,1,"C"),U,3)=""
 ; User rights
 S ^SC(+SC,"SDPROT")="Y"
 S %=$$CANCEL^SDMAPI2(.RETURN,DFN,SC,SD,"PC",CRSN,"Cancellation test remarks")
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: APTCRGT")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"APTCRGT","Expected error: APTCRGT")
 K ^SC(+SC,"SDPROT")
 ;
 S NOW=$$NOW^XLFDT(),%=$$CANCEL^SDMAPI2(.RETURN,DFN,SC,SD,"PC",CRSN)
 S SC0=+DFN_"^"_+LEN_"^^"_+CRSN_"^^"_DUZ_"^"_DT_"^^^"
 D CHKEQ^XTMUNIT($G(^SC(+SC,"S",+SD,1,1)),"","Invalid clinic appointment - 0 node")
 S DPT0=+SC_"^PC^^^^^3^^^^^"_DUZ_"^^"_+$J($$NOW^XLFDT(),4,2)_"^"_+CRSN_"^"_+TYPE_"^^"_DUZ_"^"_DT_"^^^^^0^"_NXT_"^3"
 S DPT1=^DPT(+DFN,"S",+SD,0)
 S $P(DPT1,"^",14)=+$P(DPT1,"^",14)
 D CHKEQ^XTMUNIT(DPT1,DPT0,"Invalid patient appointment - 0 node")
 ;
 S $P(^GMR(123,CONS,0),U,12)=8
 S TC=$P(^SC(+SC,0),U,7),$P(^SC(+SC,0),U,7)=105
 S %=$$GETAPCNS^SDCAPI1(.RETURN,DFN,SCODE)
 D CHKEQ^XTMUNIT(RETURN,1,"Unexpected error: "_$G(RETURN(0)))
 S $P(^SC(+SC,0),U,7)=TC
 Q
MAKECI ;
 N RETURN,%
 K ^DPT(+DFN,"S"),^SC(+SC,"S")
 S ^XUSEC("SDOB",DUZ)="",^XUSEC("SDMOB",DUZ)=""
 ;future appointment cannot be checked in
 S SD0=$$NOW^XLFDT(),SD0=$E(SD0,1,12)+0.0001
 S %=$$MAKE^SDMAPI2(.RETURN,DFN,SC,SD0,TYPE,,LEN,NXT,RSN,"CI",,,,,CONS,1)
 D CHKEQ^XTMUNIT(RETURN,1,"Unxpected error: "_$G(RETURN(0)))
 D CHKEQ^XTMUNIT($G(RETURN("CI")),"","Future Appt cannot be checked in.")
 ;appt checked in
 S SDPAST=$J($$NOW^XLFDT(),2,4)
 S %=$$MAKE^SDMAPI2(.RETURN,DFN,SC,SDPAST,TYPE,,LEN,NXT,RSN,"CI",,,,,CONS,1)
 D CHKEQ^XTMUNIT(RETURN,1,"Unxpected error: "_$G(RETURN(0)))
 D CHKEQ^XTMUNIT($G(RETURN("CI")),+SDPAST,"Incorrect check in date")
 ;past appointment cannot be checked in
 S SDPAST=$E($$FMADD^XLFDT($$NOW^XLFDT(),-1),1,10)
 S %=$$MAKE^SDMAPI2(.RETURN,DFN,SC,SDPAST,TYPE,,LEN,NXT,RSN,"CI",,,,,CONS,1)
 D CHKEQ^XTMUNIT(RETURN,1,"Unxpected error: "_$G(RETURN(0)))
 D CHKEQ^XTMUNIT($G(RETURN("CI")),"","Past Appt, cannot be checked in.")
 K ^XUSEC("SDOB",DUZ),^XUSEC("SDMOB",DUZ)
 Q
 ;
XTENT ;
 ;;MAKE;Make appointment
 ;;CHECKIN;Check in appointment
 ;;NOSHOW;No show appointment
 ;;CANCEL;Cancel appointment
 ;;MAKECI;Make appt check-in
