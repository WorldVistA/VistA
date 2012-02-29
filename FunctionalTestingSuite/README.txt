The files in the FunctionalTestingSuite are used to run the automated testing of the CPRS and Vitals GUI.

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