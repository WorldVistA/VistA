ZZUTSDAPI ;kitware/JNL - code for a unit test SDAPI tag;07/10/12  11:15
 ;;1.0;UNIT TEST;;JUL 10, 2012;Build 1
 ; makes it easy to run tests simply by running this routine and
 ; insures that XTMUNIT will be run only where it is present
 TSTART
 I $T(EN^XTMUNIT)'="" D EN^XTMUNIT("ZZUTSDAPI")
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
 K ^TMP($J,"SDAMA301")
 K SDARRAY
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
CHKRCODE   ; Unit test to test the return code of $$SDAPI^SDAMA301
 ;
 ;first case is invalid date/time format, this should just return -1
 S SDARRAY(1)=INVLDDT
 S SDARRAY("FLDS")="ALL"
 S SDARRAY(2)=TESTCID1
 S RCODE=$$SDAPI^SDAMA301(.SDARRAY)
 S ERRMSG="Expected rcode is -1"
 D CHKEQ^XTMUNIT(RCODE,-1,ERRMSG_" real: "_RCODE)
 D CHKTF^XTMUNIT($D(^TMP($J,"SDAMA301",115))'=0,"Expecting Error Code is 115")
 I RCODE K ^TMP($J,"SDAMA301")
 ;second case is invalid patient id -1, this should just return -1
 K SDARRAY
 S RCODE=0
 S SDARRAY(1)=TESTDRANG1
 S SDARRAY("FLDS")="ALL"
 S SDARRAY(4)=INVLDPID
 S RCODE=$$SDAPI^SDAMA301(.SDARRAY)
 D CHKEQ^XTMUNIT(RCODE,-1,ERRMSG_" real: "_RCODE)
 D CHKTF^XTMUNIT($D(^TMP($J,"SDAMA301",115))'=0,"Expecting Error Code is 115")
 I RCODE K ^TMP($J,"SDAMA301")
 ;third case is invalid clinic id -1, this should just return -1
 K SDARRAY
 S RCODE=0
 S SDARRAY(1)=TESTDRANG1
 S SDARRAY("FLDS")="ALL"
 S SDARRAY(2)=INVLDCID
 S RCODE=$$SDAPI^SDAMA301(.SDARRAY)
 D CHKEQ^XTMUNIT(RCODE,-1,ERRMSG_" real: "_RCODE)
 D CHKTF^XTMUNIT($D(^TMP($J,"SDAMA301",115))'=0,"Expecting Error Code is 115")
 I RCODE K ^TMP($J,"SDAMA301")
 Q
 ;
CHKPATAPPT ; unit test case to check the appointment date
 S RCODE=0
 S RCODE=$$HASAPPT(VISN0PAT1)
 I RCODE'>0 Q
 K SDARRAY
 S SDARRAY(2)=VISN0CLI1
 S SDARRAY(4)=VISN0PAT1
 S SDARRAY("FLDS")="ALL"
 S RCODE=$$SDAPI^SDAMA301(.SDARRAY)
 D CHKEQ^XTMUNIT(RCODE,10,"Expected rcode 10, real: "_RCODE)
 D CHKTF^XTMUNIT($D(^TMP($J,"SDAMA301"))'=0,"^TMP global should not be empty")
 D CHKTF^XTMUNIT($D(^TMP($J,"SDAMA301",VISN0PAT1,VISN0CLI1,VISN0APPT1P1C1))'=0,"Should have APPT at "_VISN0APPT1P1C1)
 S APPNODE=^TMP($J,"SDAMA301",VISN0PAT1,VISN0CLI1,VISN0APPT1P1C1)
 S APPNODE1=^TMP($J,"SDAMA301",VISN0PAT1,VISN0CLI1,VISN0APPT1P1C1,0) ; extra information
 D CHKVISN0APT1(.APPNODE)
 D CHKVISN0APT1EXTRA(.APPNODE1) ;
 I RCODE K ^TMP($J,"SDAMA301")
 ; Test the filter
 ; first is the date/time filter
 S APPNODE=0,APPNODE1=0
 S STRTDATE=$P(VISN0APPT1P1C1,".",1)
 S SDARRAY(1)=STRTDATE_";"_STRTDATE
 S RCODE=0
 S RCODE=$$SDAPI^SDAMA301(.SDARRAY)
 D CHKTF^XTMUNIT(RCODE=1,"Should have only one appointment")
 D CHKTF^XTMUNIT($D(^TMP($J,"SDAMA301"))'=0,"^TMP global should not be empty")
 D CHKTF^XTMUNIT($D(^TMP($J,"SDAMA301",VISN0PAT1,VISN0CLI1,VISN0APPT1P1C1))'=0,"Should have APPT at "_VISN0APPT1P1C1)
 S APPNODE=^TMP($J,"SDAMA301",VISN0PAT1,VISN0CLI1,VISN0APPT1P1C1)
 S APPNODE1=^TMP($J,"SDAMA301",VISN0PAT1,VISN0CLI1,VISN0APPT1P1C1,0) ; extra information
 D CHKVISN0APT1(.APPNODE)
 D CHKVISN0APT1EXTRA(.APPNODE1) ;
 I RCODE K ^TMP($J,"SDAMA301")
 ; second is the date/time filter and appointment status filter
 S APPNODE=0,APPNODE1=0
 S RCODE=0
 S SDARRAY(3)="R"
 S RCODE=$$SDAPI^SDAMA301(.SDARRAY)
 D CHKTF^XTMUNIT(RCODE=1,"Should have only one appointment")
 D CHKTF^XTMUNIT($D(^TMP($J,"SDAMA301"))'=0,"^TMP global should not be empty")
 D CHKTF^XTMUNIT($D(^TMP($J,"SDAMA301",VISN0PAT1,VISN0CLI1,VISN0APPT1P1C1))'=0,"Should have APPT at "_VISN0APPT1P1C1)
 S APPNODE=^TMP($J,"SDAMA301",VISN0PAT1,VISN0CLI1,VISN0APPT1P1C1)
 S APPNODE1=^TMP($J,"SDAMA301",VISN0PAT1,VISN0CLI1,VISN0APPT1P1C1,0) ; extra information
 D CHKVISN0APT1(.APPNODE)
 D CHKVISN0APT1EXTRA(.APPNODE1) ;
 I RCODE K ^TMP($J,"SDAMA301")
 ; appointment status is NS should not return any results
 S APPNODE=0,APPNODE1=0
 S RCODE=0
 S SDARRAY(3)="NS"
 S RCODE=$$SDAPI^SDAMA301(.SDARRAY)
 D CHKTF^XTMUNIT(RCODE=0,"Should not have any appointment")
 D CHKTF^XTMUNIT($D(^TMP($J,"SDAMA301"))=0,"^TMP global should be empty")
 I RCODE K ^TMP($J,"SDAMA301")
 ; change the fields to only returl flds 28
 S SDARRAY(3)="R"
 S SDARRAY("FLDS")="28"
 S RCODE=0
 S APPNODE=0,APPNODE1=0
 S RCODE=$$SDAPI^SDAMA301(.SDARRAY)
 D CHKTF^XTMUNIT(RCODE=1,"Should have only one appointment")
 D CHKTF^XTMUNIT($D(^TMP($J,"SDAMA301"))'=0,"^TMP global should not be empty")
 D CHKTF^XTMUNIT($D(^TMP($J,"SDAMA301",VISN0PAT1,VISN0CLI1,VISN0APPT1P1C1))'=0,"Should have APPT at "_VISN0APPT1P1C1)
 S APPNODE1=^TMP($J,"SDAMA301",VISN0PAT1,VISN0CLI1,VISN0APPT1P1C1,0) ; extra information
 D CHKVISN0APT1EXTRA(.APPNODE1) ;
 I RCODE K ^TMP($J,"SDAMA301")
 ; Check the Purged option
 ; according to API, if purged is specifed, fields list can not contain 5-9,11,22,28,30,31 or 33
 S SDARRAY("PURGED")=1
 S RCODE=0
 S RCODE=$$SDAPI^SDAMA301(.SDARRAY)
 S ERRMSG="Expected rcode is -1"
 D CHKEQ^XTMUNIT(RCODE,-1,ERRMSG_" real: "_RCODE)
 D CHKTF^XTMUNIT($D(^TMP($J,"SDAMA301",115))'=0,"Expecting Error Code is 115")
 I RCODE K ^TMP($J,"SDAMA301")
 ; check the sort option
 K SDARRAY("PURGED")
 K SDARRAY(4) ; do not provide the patient filter
 S SDARRAY("SORT")="P" ; sort by patient
 S SDARRAT("FLDS")="2;3;4" ; return limit fields
 S RCODE=0
 S RCODE=$$SDAPI^SDAMA301(.SDARRAY)
 D CHKTF^XTMUNIT(RCODE>0,"Should have at least one appointment")
 D CHKTF^XTMUNIT($D(^TMP($J,"SDAMA301"))>0,"^TMP global should NOT be empty")
 D CHKTF^XTMUNIT($D(^TMP($J,"SDAMA301",VISN0PAT1,VISN0APPT1P1C1))>0,"Should have found the appointment")
 I RCODE K ^TMP($J,"SDAMA301")
 Q
 ;
CHKVISN0APT1(APPNODE) ;
 D CHKEQ^XTMUNIT(VISN0APPT1P1C1,$P(APPNODE,U,1),"Should be from the same time as: "_VISN0APPT1P1C1)
 D CHKEQ^XTMUNIT(VISN0CLI1,$P($P(APPNODE,U,2),";",1),"Should be from the clinic id: "_VISN0CLI1)
 D CHKEQ^XTMUNIT("R",$P($P(APPNODE,U,3),";",1),"Status should be: R")
 D CHKEQ^XTMUNIT(VISN0PAT1,$P($P(APPNODE,U,4),";",1),"Patient IEN should be: "_VISN0PAT1)
 D CHKEQ^XTMUNIT(15,$P(APPNODE,U,5),"Appointment Length should be: 15 minutes")
 D CHKEQ^XTMUNIT("REGULAR",$P($P(APPNODE,U,10),";",2),"Appointment should be regular")
 D CHKEQ^XTMUNIT("141;301",$P(APPNODE,U,13),"Primary Stop Code IEN and code should be 141 and 301")
 D CHKEQ^XTMUNIT("3030409",$P(APPNODE,U,16),"Appointment was made at 3030409")
 ;Check if X-Ray films are required
 D CHKEQ^XTMUNIT("Y",$P(APPNODE,U,23),"Need to take X-Ray films")
 Q
 ;
CHKVISN0APT1EXTRA(APPNODE) ;
 D CHKEQ^XTMUNIT(11729,$P($P(APPNODE,U,1),";",1),"Date Entry Clerk' DUZ should be 11729")
 Q
 ;
HASAPPT(PATIEN) ;
 N SDARRAY,RCODE
 S SDARRAY(4)=PATIEN
 S SDARRAY("FLDS")=1
 S SDARRAY("MAX")=1
 S RCODE=$$SDAPI^SDAMA301(.SDARRAY)
 I RCODE K ^TMP($J,"SDAMA301")
 Q RCODE
 ;
CLINICHASAPPT(CLIIEN) ;
 N SDARRAY,RCODE
 S SDARRAY(2)=CLIIEN
 S SDARRAY("FLDS")=1
 S SDARRAY("MAX")=1
 S RCODE=$$SDAPI^SDAMA301(.SDARRAY)
 I RCODE K ^TMP($J,"SDAMA301")
 Q RCODE
 ;
XTROU ;
 ;;;SDAMA301
 ;;;ZZUTSDCOM
 ; Entry points for tests are specified as the third semi-colon piece,
 ; a description of what it tests is optional as the fourth semi-colon
 ; piece on a line. The first line without a third piece terminates the
 ; search for TAGs to be used as entry points
XTENT ;
 ;;CHKRCODE; unit test to check return code of $$SDAPI^SDAMA301
 ;;CHKPATAPPT; unit test to check patient appointment result from $$SDAPI^SDAMA301
 Q
