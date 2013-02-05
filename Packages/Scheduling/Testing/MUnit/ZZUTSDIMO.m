ZZUTSDIMO ;kitware/JNL -code for a unit test SDIMO tag ;07/10/12  11:15
 ;;1.0;UNIT TEST;;JUL 10, 2012;Build 1
 ; makes it easy to run tests simply by running this routine and
 ; insures that XTMUNIT will be run only where it is present
 TSTART
 I $T(EN^XTMUNIT)'="" D EN^XTMUNIT("ZZUTSDIMO")
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
CHKRCODE   ; Unit test to test the return code of $$SDIMO^SDAMA203
 ;first case is patient id is NULL, this should just return -2
 S SDCLIEN=TESTCID1
 S RCODE=$$SDIMO^SDAMA203(SDCLIEN)
 D CHKEQ^XTMUNIT(RCODE,-2,"Expected return code is -2, real: "_RCODE)
 I RCODE=1 K SDIMO(1)
 ;second case is clinic id is NULL, this should just return -1
 S RCODE=$$SDIMO^SDAMA203()
 D CHKEQ^XTMUNIT(RCODE,-1,"Expected return code is -1, real: "_RCODE)
 I RCODE=1 K SDIMO(1)
 ;third case is invalid clinic id -1, this should just return -1
 S RCODE=$$SDIMO^SDAMA203(INVLDCID,TESTPID1)
 D CHKEQ^XTMUNIT(RCODE,-1,"Expected return code is -1, real: "_RCODE)
 I RCODE=1 K SDIMO(1)
 ;fourth case is invalid patient id -1, this should just return -1
 S RCODE=$$SDIMO^SDAMA203(TESTCID1,INVLDPID)
 D CHKEQ^XTMUNIT(RCODE,-1,"Expected return code is -1, real: "_RCODE)
 I RCODE=1 K SDIMO(1)
 Q
XTROU ;
 ;;;SDAMA203
 ; Entry points for tests are specified as the third semi-colon piece,
 ; a description of what it tests is optional as the fourth semi-colon
 ; piece on a line. The first line without a third piece terminates the
 ; search for TAGs to be used as entry points
XTENT ;
 ;;CHKRCODE; unit test to check return code of $$SDIMO^SDAMA203
 Q
