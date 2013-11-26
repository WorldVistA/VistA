The files in FunctionalTest are used to run the automated testing for VistA Roll-n-Scroll, CPRS and Vitals GUI.

--------------------------
***VISTA Roll-n-Scroll***
--------------------------
OSEHRA Automated Testing Framework for Functional Testing of VistA Packages

This project provides tools and scripts to perform functional testing on the roll and scroll VistA interface running under a GT.M or InterSystems Cache environment.

To run the Roll and Scroll tests do the following:

1. run cmake-gui to configure and generate cmake files, making a /bin or /build folder
2. from the /bin (/build) folder do the following:
  > cmake -P ImportRG.cmake
  > ctest -R RAS_

NOTES:
-- The cmake -P ImportRG.cmake must be run before every ctest -R RAS_ since these functional tests have database state pre-requisits. Once we establish a means to restore the database to it original test more quickly, this procedure can be incorporated into the python test scripts eliminating the need to rebuild the database for each run.
-- Functional test result logs are located in the @TEST_VISTA_OUTPUT_DIR@ directory specified within cmake-gui

--------------------------
***CPRS and Vitals GUI***
--------------------------
The program uses CPRS 28 and Vitals Manager.  A zip file containing the two programs needed can be found on the OSEHRA website:
http://osehra.org/document/guis-used-automatic-functional-testing

The .sikuli folder is used by a cross-platform Open Source automation suite called Sikuli
(http://sikuli.org).  It uses OpenCV to scrape the screen for the supplied screenshots
and act upon them according to the script.  This must be installed before the testing can take place. It is available from the download page (http://sikuli.org/download.shtml)
for all major platforms.

The Python file will enter the VistA instance and set up the information needed to perform the
testing.  The scripts create a Clinic, one doctor, one nurse and one patient.  The Python script is written with the intent that it will be run after a fresh import of the
globals and routines from the OSEHRA codebase.  The script will:
- Configure a Null device, if necessary
- Set-up and initialize a new domain
- Set-up and configure the Box-volume pair for the specific instance of VistA
- Create a clinic
- Create the a Nurse and a Doctor for the Clinic
- Gives the Nurse and Doctor keys and permissions to do their jobs.
- Create a patient
- Set up tests to run on the patient.
- Register the version of both CPRS and Vitals with the instance so that they will connect.
- Start the TCP listener via FileMan, if necessary
- Configure CPRS to let the system mark Allergies as 'Entered in Error'



If using GT.M to connect to CPRS, there is a change that needs to be made to the ZTLOAD1.m routine that removes a block from the intialization of Fileman.
This change, described here: http://groups.google.com/group/hardhats/browse_thread/thread/f9c2716d7fd17b57/f9c4f09852a8e3db?#f9c4f09852a8e3db , needs to be
made before running the PostImportScript for GT.M.

-----------------
***SSH Suport***
-----------------
Setup:
If connecting via SSH, paramiko will need to be installed. See installation notes here: http://www.lag.net/paramiko/
For linux, installing the python package is suffecient. However for Windows, pre-complied PyCrpto libraries are needed to be installed too: http://www.voidspace.org.uk/python/modules.shtml#pycrypto

SSH tests will fail in ctest if paramiko is not setup correctly.

Usage:
For a python test script to connect to VistA via SSH, the .cfg file (Windows INI format) must be present, in the same directory as the python test script. For a python test script 'example_01_test.py', it's configuration file must be named 'example_01.cfg'. In the configuration file, the 'RemoteConnect' option must be set to 1, setting it to 0 will toggle it off such that it acts as a normal telnet or pexpect connect.

Example configuration file name:
example_01_suite.py
example_01_test.py
example_01.cfg

Example configuration file contents:
[RemoteDetails]
RemoteConnect=1
ServerLocation=test.instance.org
SSHUsername=user
SSHPassword=password
Instance=cache
UseDefaultNamespace=1
Namespace= ; Leave empty since not using
