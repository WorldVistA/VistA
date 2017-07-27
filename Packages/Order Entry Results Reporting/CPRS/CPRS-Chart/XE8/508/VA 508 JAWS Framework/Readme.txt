Basic Instructions
====================
Scripts folder contains actual script files
SR_SR3 folder contain the SR and SR3 files 
Files from both of these folders should be placed in the same directory (program Files(x86)\Vista\Common files\)


Please see developer document for further details

====================
Update Information
====================

 2/22/17 - ZZZZZZBELLC
 ---------------------
  Updated SR and SR3 files to version 1.11.0.1
  Update to fix thread pause issue. currently there is a hack in place which adda a space to the caption. the form needs a message to fire but     the caption needs to change to make this happen. Can not just keep resetting the caption to itself.	 

 5/27/16 - ZZZZZZBELLC
 ---------------------
  Updated SR and SR3 files to version 1.11.0.0
  New features Added
	*Splash screen - Added a splash screen to show (and speak) the current progress as well as file information. This way users are not left          thinking that the application has not started because a jaws process is still running.
	*Log control - Update to the log control to make this more readable. Have also added the ability to capture error messages thrown by the          jaws compile to the log file
	*Dynamic script inclusion - Added the ability to dynamically include files into the use statement of the applications JSS file. 
	*New update methods - Added two new "merge" update actions that will merge a script file with its applications counterpart script file.
	*Force parameter - Added new parameter that will force the script updates of a specific version or all installed versions of jaws.
 
 2/24/16 - ZZZZZZBELLC
 ---------------------
  Updated SR and SR3 files to version 1.10.0.2
  Updated ScriptList INI to include missing script files for Vitals View