ZZDGPTCO1 ;kitware/JPS - demo code for a unit test DGPTCO1 routine ;5/10/2012  13:00
 ;;1.0;UNIT TEST;;Apr 19, 2012;Build 1
 ; makes it easy to run tests simply by running this routine and
 ; insures that XTMUNIT will be run only where it is present
 I $T(EN^XTMUNIT)'="" D EN^XTMUNIT("ZZDGPTCO1")
 Q
 ;
STARTUP ; optional entry point
 ; if present executed before any other entry point any variables
 ; or other work that needs to be done for any or all tests in the
 ; routine.  This is run only once at the beginning.
 D DT^DICRW
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
CHKCHKCUR; Unit test CHKCUR tag in DGPTCO1 routine using a global that will cause all if statements to be computed as true
 ;  Corresponds to the default census date being September 30,2007 (3970930)
 ;
 TSTART
 D GETDGIEN
 D CHKEQ^XTMUNIT(22,$G(DGIEN),"Return of Original GETDGIEN doesn't match")
 S NEWDGIEN=$G(DGIEN)+1
 K ^DG(45.86,"AC",1,DGIEN) S ^DG(45.86,"AC",0,DGIEN)=""
 S ^DG(45.86,"AC",1,NEWDGIEN)="" S ^DG(45.86,"B",3070930,NEWDGIEN)=""
 S ^DG(45.86,NEWDGIEN,0)="3070930^3010720^2970331^1^3010401"
 W ! W "----------------------------------------------",!
 N DGIEN
 S DGIEN=$S($D(^DG(45.86,+$O(^DG(45.86,"AC",1,0)),0)):+^(0),1:"") W DGIEN,!
 S DGIEN=$O(^DG(45.86,"B",+$G(DGIEN),0)) W DGIEN,! D CHKEQ^XTMUNIT(23,$G(DGIEN),"Return of New DGIEN doesn't match")
 S DGCLOSE=$P($G(^DG(45.86,NEWDGIEN,0)),U,2) W DGCLOSE,!
 S DGACT=$P($G(^DG(45.86,NEWDGIEN,0)),U,4) W DGACT,!
 W "-------------------------------------------",!
 D CHKCUR^DGPTCO1
 TROLLBACK
 Q
CHKCHKCUR2 ; Test CHKCUR tag in DGPTCO1 routine with a new global that will cause the second if statement to fail
 ;  and not pass the check of DGCLOSE causing an error
 ;  Corresponds to the default census date being September 31,2007 (3970931)
 ;  And the closing date of July 20, 2001(3010720)
 ;
 TSTART
 D GETDGIEN
 D CHKEQ^XTMUNIT(22,$G(DGIEN),"Return of Original GETDGIEN doesn't match")
 S NEWDGIEN=$G(DGIEN)+1
 K ^DG(45.86,"AC",1,DGIEN) S ^DG(45.86,"AC",0,DGIEN)=""
 S ^DG(45.86,"AC",1,NEWDGIEN)="" S ^DG(45.86,"B",3070931,NEWDGIEN)=""
 S ^DG(45.86,NEWDGIEN,0)="3070931^3010720^2970331^1^3010401"
 W ! W "----------------------------------------------",!
 N DGIEN
 S DGIEN=$S($D(^DG(45.86,+$O(^DG(45.86,"AC",1,0)),0)):+^(0),1:"") W DGIEN,!
 S DGIEN=$O(^DG(45.86,"B",+$G(DGIEN),0)) W DGIEN,! D CHKEQ^XTMUNIT(23,$G(DGIEN),"Return of New DGIEN doesn't match")
 S DGCLOSE=$P($G(^DG(45.86,NEWDGIEN,0)),U,2) W DGCLOSE,!
 S DGACT=$P($G(^DG(45.86,NEWDGIEN,0)),U,4) W DGACT,!
 W "-------------------------------------------",!!
 D CHKCUR^DGPTCO1
 TROLLBACK
 Q
CHKCHKCUR3 ;  Test CHKCUR tag in DGPTCO1 routine with a new global that will cause the second if statement to fail
 ;  But will pass the DGCLOSE check, not causing an error.
 ;  Corresponds to the default census date being September 31,2007 (3970931)
 ;  And the closing date of July 14, 2001(3010714)
 ;
 TSTART
 D GETDGIEN
 D CHKEQ^XTMUNIT(22,$G(DGIEN),"Return of Original GETDGIEN doesn't match")
 S NEWDGIEN=$G(DGIEN)+1
 K ^DG(45.86,"AC",1,DGIEN) S ^DG(45.86,"AC",0,DGIEN)=""
 S ^DG(45.86,"AC",1,NEWDGIEN)="" S ^DG(45.86,"B",3070931,NEWDGIEN)=""
 S ^DG(45.86,NEWDGIEN,0)="3070931^3010714^2970331^1^3010401"
 W ! W "----------------------------------------------",!
 N DGIEN
 S DGIEN=$S($D(^DG(45.86,+$O(^DG(45.86,"AC",1,0)),0)):+^(0),1:"") W DGIEN,!
 S DGIEN=$O(^DG(45.86,"B",+$G(DGIEN),0)) W DGIEN,! D CHKEQ^XTMUNIT(23,$G(DGIEN),"Return of New DGIEN doesn't match")
 S DGCLOSE=$P($G(^DG(45.86,NEWDGIEN,0)),U,2) W DGCLOSE,!
 S DGACT=$P($G(^DG(45.86,NEWDGIEN,0)),U,4) W DGACT,!
 W "-------------------------------------------",!
 D CHKCUR^DGPTCO1
 TROLLBACK
 Q
CHKCHKCUR4 ;  Test CHKCUR tag in DGPTCO1 routine with a new global that will cause the second if statement to fail
 ;  But will pass the DGCLOSE check, not causing an error.
 ;  Corresponds to the default census date being December 31, 2010 (3101231)
 ;  and the closing date of July 14, 2001(3010714)
 ;
 TSTART
 D GETDGIEN
 D CHKEQ^XTMUNIT(22,$G(DGIEN),"Return of Original GETDGIEN doesn't match")
 S NEWDGIEN=$G(DGIEN)+1
 K ^DG(45.86,"AC",1,DGIEN) S ^DG(45.86,"AC",0,DGIEN)=""
 S ^DG(45.86,"AC",1,NEWDGIEN)="" S ^DG(45.86,"B",3101231,NEWDGIEN)=""
 S ^DG(45.86,NEWDGIEN,0)="3101231^3010714^2970331^1^3010401"
 W ! W "----------------------------------------------",!
 N DGIEN
 S DGIEN=$S($D(^DG(45.86,+$O(^DG(45.86,"AC",1,0)),0)):+^(0),1:"") W DGIEN,!
 S DGIEN=$O(^DG(45.86,"B",+$G(DGIEN),0)) W DGIEN,! D CHKEQ^XTMUNIT(23,$G(DGIEN),"Return of New DGIEN doesn't match")
 S DGCLOSE=$P($G(^DG(45.86,NEWDGIEN,0)),U,2) W DGCLOSE,!
 S DGACT=$P($G(^DG(45.86,NEWDGIEN,0)),U,4) W DGACT,!
 W "-------------------------------------------",!
 D CHKCUR^DGPTCO1
 TROLLBACK
 Q
CHKCHKCUR5 ;  Test CHKCUR tag in DGPTCO1 routine with a new global that will cause the third if statement to fail
 ;  But will not pass the DGCLOSE check,causing an error.
 ;  Corresponds to the default census date being December 32, 2010 (3101232)
 ;  and the closing date of July 14, 2001(3010714)
 ;
 TSTART
 D GETDGIEN
 D CHKEQ^XTMUNIT(22,$G(DGIEN),"Return of Original GETDGIEN doesn't match")
 S NEWDGIEN=$G(DGIEN)+1
 K ^DG(45.86,"AC",1,DGIEN) S ^DG(45.86,"AC",0,DGIEN)=""
 S ^DG(45.86,"AC",1,NEWDGIEN)="" S ^DG(45.86,"B",3101232,NEWDGIEN)=""
 S ^DG(45.86,NEWDGIEN,0)="3101232^3010714^2970331^1^3010401"
 W ! W "----------------------------------------------",!
 N DGIEN
 S DGIEN=$S($D(^DG(45.86,+$O(^DG(45.86,"AC",1,0)),0)):+^(0),1:"") W DGIEN,!
 S DGIEN=$O(^DG(45.86,"B",+$G(DGIEN),0)) W DGIEN,! D CHKEQ^XTMUNIT(23,$G(DGIEN),"Return of New DGIEN doesn't match")
 S DGCLOSE=$P($G(^DG(45.86,NEWDGIEN,0)),U,2) W DGCLOSE,!
 S DGACT=$P($G(^DG(45.86,NEWDGIEN,0)),U,4) W DGACT,!
 W "-------------------------------------------",!
 D CHKCUR^DGPTCO1
 TROLLBACK
 Q
GETDGIEN
 K DGIEN
 S DGIEN=$S($D(^DG(45.86,+$O(^DG(45.86,"AC",1,0)),0)):+^(0),1:"")
 S DGIEN=$O(^DG(45.86,"B",+$G(DGIEN),0))
 ;
XTROU ;
 ;;ZZDGPTCO1
 ; Entry points for tests are specified as the third semi-colon piece,
 ; a description of what it tests is optional as the fourth semi-colon
 ; piece on a line. The first line without a third piece terminates the
 ; search for TAGs to be used as entry points
XTENT ;
 ;;CHKCHKCUR;example of unit test CHKCUR^DGPTCO1 call
 ;;CHKCHKCUR2;second example of unit test call
 ;;CHKCHKCUR3;third example of unit test call
 ;;CHKCHKCUR4;fourth example of unit test call
 ;;CHKCHKCUR5;fifth example of unit test call
 Q
