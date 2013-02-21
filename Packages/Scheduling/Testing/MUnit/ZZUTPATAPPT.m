ZZUTPATAPPT ;kitware/JNL -code for a unit test PATAPPT tag ;07/10/12  11:15
 ;;1.0;UNIT TEST;;JUL 10, 2012;Build 1
 ; makes it easy to run tests simply by running this routine and
 ; insures that XTMUNIT will be run only where it is present
 TSTART
 I $T(EN^XTMUNIT)'="" D EN^XTMUNIT("ZZUTPATAPPT")
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
CHKRCODE   ; Unit test to test the return code of $$PATAPPT^SDAMA204
 ;first case is patient id is NULL, this should just return -2
 S RCODE=0
 S RCODE=$$PATAPPT^SDAMA204()
 D CHKEQ^XTMUNIT(RCODE,-1,"Expected return code is -1, real: "_RCODE)
 D CHKERRCODE(102)
 I RCODE K ^TMP($J,"SDAMA204","PATAPPT")
 ;second case is patient id is -1, this should just return -1
 S RCODE=0
 S RCODE=$$PATAPPT^SDAMA204(-1)
 D CHKEQ^XTMUNIT(RCODE,-1,"Expected return code is -1, real: "_RCODE)
 D CHKERRCODE(110)
 I RCODE K ^TMP($J,"SDAMA204","PATAPPT")
 ;third case is patient id is 0, this should just return -1
 S RCODE=0
 S RCODE=$$PATAPPT^SDAMA204(0)
 D CHKEQ^XTMUNIT(RCODE,-1,"Expected return code is -1, real: "_RCODE)
 D CHKERRCODE(114)
 I RCODE K ^TMP($J,"SDAMA204","PATAPPT")
 ;fourth case is patient id is 1, this should just return 0 or 1
 S RCODE=0
 S RCODE=$$PATAPPT^SDAMA204(1)
 D CHKTF^XTMUNIT((RCODE>0)!(RCODE=0),"Expected return code is >=0, real: "_RCODE)
 I RCODE K ^TMP($J,"SDAMA204","PATAPPT")
 Q
 ;
CHKERRCODE(ERRCODE) ;
 D CHKTF^XTMUNIT($D(^TMP($J,"SDAMA204","PATAPPT","ERROR",ERRCODE))'=0,"Expecting Error Code is "_ERRCODE)
 Q
 ;
XTROU ;
 ;;;SDAMA204
 ; Entry points for tests are specified as the third semi-colon piece,
 ; a description of what it tests is optional as the fourth semi-colon
 ; piece on a line. The first line without a third piece terminates the
 ; search for TAGs to be used as entry points
XTENT ;
 ;;CHKRCODE; unit test to check return code of $$PATAPPT^SDAMA204
 Q
