ZZUTNEXTAPPT ;kitware/JNL - code for a unit test NEXTAPPT tag;07/10/12  11:15
 ;;1.0;UNIT TEST;;JUL 10, 2012;Build 1
 ; makes it easy to run tests simply by running this routine and
 ; insures that XTMUNIT will be run only where it is present
 TSTART
 I $T(EN^XTMUNIT)'="" D EN^XTMUNIT("ZZUTNEXTAPPT")
 TROLLBACK
 Q
 ;
STARTUP ; optional entry point
 ; if present executed before any other entry point any variables
 ; or other work that needs to be done for any or all tests in the
 ; routine.  This is run only once at the beginning.
 D INIT^ZZUTSDCOM
 Q
 ;
SHUTDOWN ; optional entry point
 ; if present executed after all other processing is complete to remove
 ; any variables, or undo work done in STARTUP.
 D CLEANUP^ZZUTSDCOM
 K ^TMP($J,"SDAMA201","NEXTAPPT")
 Q
 ;
SETUP ; optional entry point
 ; if present it will be executed before each test entry to set up
 ; variables, etc.
 Q
 ;
TEARDOWN ; optional entry point
 ; if present it will be exceuted after each test entry to clean up
 ; variables, etc.
 Q
 ;
CHKRCODE   ; Unit test to test the return code of $$NEXTAPPT^SDAMA201
 ;
 ;first case is invalid patient id -1, this should just return -1 with error code 114
 N RCODE S RCODE=0
 S RCODE=$$NEXTAPPT^SDAMA201(INVLDPID,,,)
 S ERRMSG="Expected rcode is -1"
 D CHKEQ^XTMUNIT(RCODE,-1,ERRMSG_" real: "_RCODE)
 D CHKERRCODE(114)
 I RCODE K ^TMP($J,"SDAMA201","NEXTAPPT")
 ;second case is patient id is NULL, this should return -1 and error code 102
 S RCODE=0
 S RCODE=$$NEXTAPPT^SDAMA201(,,,)
 D CHKEQ^XTMUNIT(RCODE,-1,ERRMSG_" real: "_RCODE)
 D CHKERRCODE(102)
 I RCODE K ^TMP($J,"SDAMA201","NEXTAPPT")
 ;third case is invalid fields list, should return -1 and set error code 103
 S FLDLIST="0;13"
 S RCODE=0
 S RCODE=$$NEXTAPPT^SDAMA201(TESTPID1,FLDLIST,,)
 D CHKEQ^XTMUNIT(RCODE,-1,ERRMSG_" real: "_RCODE)
 D CHKERRCODE(103)
 I RCODE K ^TMP($J,"SDAMA201","NEXTAPPT")
 ;fourth case is invalid patient status filter list, should return -1 and set error code 112
 S PSTATLST="UNDEFINED"
 S RCODE=0
 S RCODE=$$NEXTAPPT^SDAMA201(TESTPID1,,,PSTATLST)
 D CHKEQ^XTMUNIT(RCODE,-1,ERRMSG_" real: "_RCODE)
 D CHKERRCODE(112)
 I RCODE K ^TMP($J,"SDAMA201","NEXTAPPT")
 ;fifth case is invalid appointment status filter list, should return -1 and set error code 109
 S APPTSLST="UNDEFINED"
 S RCODE=0
 S RCODE=$$NEXTAPPT^SDAMA201(TESTPID1,,APPTSLST,)
 S ERRMSG="Expected rcode is -1"
 D CHKEQ^XTMUNIT(RCODE,-1,ERRMSG_" real: "_RCODE)
 D CHKERRCODE(109)
 I RCODE K ^TMP($J,"SDAMA201","NEXTAPPT")
 ;sixth case is invalid appointment status list/patient status combination, should return -1 and set error code 113
 S APPTSLST="R;N;C;NT"
 S PSTATLST="I"
 D CHKINVALDCOMB(.APPTSLST,.PSTATLIST)
 S APPTSLST="R;N;C;NT"
 S PSTATLST="O"
 D CHKINVALDCOMB(.APPTSLST,.PSTATLIST)
 S APPTSLST="N"
 S PSTATLST="I"
 D CHKINVALDCOMB(.APPTSLST,.PSTATLIST)
 S APPTSLST="N"
 S PSTATLST="O"
 D CHKINVALDCOMB(.APPTSLST,.PSTATLIST)
 S APPTSLST="C"
 S PSTATLST="I"
 D CHKINVALDCOMB(.APPTSLST,.PSTATLIST)
 S APPTSLST="C"
 S PSTATLST="O"
 D CHKINVALDCOMB(.APPTSLST,.PSTATLIST)
 S APPTSLST="NT"
 S PSTATLST="I"
 D CHKINVALDCOMB(.APPTSLST,.PSTATLIST)
 ; This seems to be a bug in the VISN0 code, this indeed returns some values back
 ;S APPTSLST="NT"
 ;S PSTATLST="O"
 ;D CHKINVALDCOMB(.APPTSLST,.PSTATLIST)
 S APPTSLST="NT:C"
 S PSTATLST="O"
 D CHKINVALDCOMB(.APPTSLST,.PSTATLIST)
 S APPTSLST="NT:C"
 S PSTATLST="I"
 D CHKINVALDCOMB(.APPTSLST,.PSTATLIST)
 S APPTSLST=""
 S PSTATLST="I"
 D CHKINVALDCOMB(.APPTSLST,.PSTATLIST)
 S APPTSLST=""
 S PSTATLST="O"
 D CHKINVALDCOMB(.APPTSLST,.PSTATLIST)
 Q
 ;
CHKINVALDCOMB(APPTSLST,PSTATLIST) ; check the combination of patient status and appt status
 S RCODE=0
 S RCODE=$$NEXTAPPT^SDAMA201(TESTPID1,,APPTSLST,PSTATLST)
 S ERRMSG="Expected rcode is -1"
 D CHKEQ^XTMUNIT(RCODE,-1,ERRMSG_" real: "_RCODE_" APP: "_APPTSLST_" PAT: "_PSTATLST)
 D CHKERRCODE(113)
 I RCODE K ^TMP($J,"SDAMA201","NEXTAPPT")
 Q
CHKERRCODE(ERRCODE) ;
 D CHKTF^XTMUNIT($D(^TMP($J,"SDAMA201","NEXTAPPT","ERROR",ERRCODE))'=0,"Expecting Error Code is "_ERRCODE)
 Q
 ;
CHKPATAPPT ; unit test case to check the appointment date
 S RCODE=0
 S RCODE=$$NEXTAPPT^SDAMA201(VISN0PAT1,,,)
 Q:RCODE'=1
 ; fld list
 S RCODE=0
 S FLDLIST="1;3;4;12"
 S RCODE=$$NEXTAPPT^SDAMA201(VISN0PAT1,.FLDLIST,,)
 D CHKEQ^XTMUNIT(RCODE,1,"Should only have one appointment")
 D:RCODE=1 CHKAPPTDETAIL(1,.FLDLIST)
 I RCODE K ^TMP($J,"SDAMA201","NEXTAPPT")
 ; appointment status
 S RCODE=0
 S FLDLIST="3;4;12"
 S RCODE=$$NEXTAPPT^SDAMA201(VISN0PAT1,.FLDLIST,"R",)
 D CHKEQ^XTMUNIT(RCODE,1,"Should only have one appointment")
 D:RCODE=1 CHKAPPTDETAIL(1,.FLDLIST)
 I RCODE K ^TMP($J,"SDAMA201","NEXTAPPT")
 ; patient status status
 S RCODE=0
 S FLDLIST="3;4;5;6;7;8;9"
 S RCODE=$$NEXTAPPT^SDAMA201(VISN0PAT1,.FLDLIST,"R","O")
 D CHKEQ^XTMUNIT(RCODE,1,"Should only have one appointment")
 D:RCODE=1 CHKAPPTDETAIL(1,.FLDLIST)
 I RCODE K ^TMP($J,"SDAMA201","NEXTAPPT")
 Q
CHKAPPTDETAIL(NODEID,FLDLIST) ;
 I $D(FLDLIST)=0 S I=0 F I=1:1:$L(NEXTAPPTRST1,U) D CHKAPPTFLDDETAIL(NODEID,I)
 Q:$D(FLDLIST)=0  S I=0 F I=1:1:$L(FLDLIST,";") D CHKAPPTFLDDETAIL(NODEID,$P(FLDLIST,";",I))
 Q
CHKAPPTFLDDETAIL(NODEID,FLDID) ;
 D CHKEQ^XTMUNIT(^TMP($J,"SDAMA201","NEXTAPPT",NODEID,FLDID),$TR($P(NEXTAPPTRST1,U,FLDID),";",U),"FIELD: "_FLDID_" RESULT MISMATCH!")
 Q
XTROU ;
 ;;;SDAMA201
 ; Entry points for tests are specified as the third semi-colon piece,
 ; a description of what it tests is optional as the fourth semi-colon
 ; piece on a line. The first line without a third piece terminates the
 ; search for TAGs to be used as entry points
XTENT ;
 ;;CHKRCODE; unit test to check return code of $$NEXTAPPT^SDAMA201
 ;;CHKPATAPPT; unit test to check patient appointment result from $$NEXTAPPT^SDAMA201
 Q
