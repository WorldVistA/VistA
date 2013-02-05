ZZUTDIDT ;kitware/JNL - demo code for a unit test %DT routine ;01/25/12  11:15
 ;;1.0;UNIT TEST;;Feb 14, 2012;Build 1
 ; makes it easy to run tests simply by running this routine and
 ; insures that XTMUNIT will be run only where it is present
 I $T(EN^XTMUNIT)'="" D EN^XTMUNIT("ZZUTDIDT")
 Q
 ;
STARTUP ; optional entry point
 ; if present executed before any other entry point any variables
 ; or other work that needs to be done for any or all tests in the
 ; routine.  This is run only once at the beginning.
 Q
 ;
SHUTDOWN ; optional entry point
 ; if present executed after all other processing is complete to remove
 ; any variables, or undo work done in STARTUP.
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
CHKDD   ; Unit test DD tag in %DT routine, CHKTF is used to check True or FALSE
 ;
 N ERRMSG,OUTPUT,INPUT,Y
 S INPUT=2690720.1
 S OUTPUT="JUL 20, 1969@10:00"
 S ERRMSG="DD^%DT conversion failure, input: "_INPUT_" output expected: "_OUTPUT
 S Y=INPUT D DD^%DT
 D CHKTF^XTMUNIT(Y=OUTPUT,ERRMSG_" real: "_Y)
 ; Testing the case with input is 0.0
 S INPUT=0.0
 S OUTPUT="0"
 S ERRMSG="DD^%DT conversion failure, input: "_INPUT_" output expected: "_OUTPUT
 S Y=INPUT D DD^%DT
 D CHKTF^XTMUNIT(Y=OUTPUT,ERRMSG_" real: "_Y)
 ;
 Q
XTROU ;
 ;;%DT
 ; Entry points for tests are specified as the third semi-colon piece,
 ; a description of what it tests is optional as the fourth semi-colon
 ; piece on a line. The first line without a third piece terminates the
 ; search for TAGs to be used as entry points
XTENT ;
 ;;CHKDD;example of unit test DD^%DT call
 Q
