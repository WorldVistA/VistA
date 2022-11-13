
/* 
 This is used for custom application code and allows sites to load site specific code 


Written for the VA508 Script project
Original scripts by: CBell
Updated: May, 2014 by Chris Bell
Updated April 2016 by Jonathan Cohn
; version 5: Migrate application specific code into a seperate library.
; Any JAWS function can now be over-written in this file as long as the original  code is called as a fall back.
; Any generic CPRSChart jaws updates should go into the CPRChart_Delphilib so that proper stacking of library functions can occur.
; 
*/

/***************************************************************
Site specific code can be placed in VA508JAWS_SiteCode.jss, however going forward this hshould now be placed in this file.

If you have code in VA508JAWS_SiteCode.jss.  uncomment the below use statement and the appropriate line in the AutoStartEvent function.

***************************************************************/
; 	Use "VA508JAWS_SiteCode.jsb" ; import functions from site specific code These will override the Delphi framework. code 
; Use only one of the below if there is a delphi Lib JSB file, it will use jaws.jsb va508
; use "VA508JAWS.jsb" ; import DELPHI standard framework
use "CPRS_DelphiLib.jsb" ; CPRS / Vials lite additions to the DELPHI Dramework.

import "va508jaws.jsd" ; import function declarations  from documentation file (help compile and control+I to work.

; constants are differentiated by underscores between words,
Const	
; Not used by any code in this file, but read by JAWS.SR from this file to determine if the script file should be updated with a newer version
	VA508_Script_Version = 15,
; Site specific library used in  PerformFunction()
	VA508_SITE_LIBRARY  = "VA508JAWS_SiteCode::"




/***************************************************************
Below is the Application specific code (Code written by SRA )
***************************************************************/
GLOBALS
	collection Delphi_AppDefined 

Function AutoStartEvent () ; Set globals used for determineing specific application being run
	Delphi_AppDefined  = new collection 
	; Uncomment below line if Site specific library is being used.
	; SiteCodeInitialize  ()
	; Call standard 
	AutoStartEvent()
EndFunction

; Place any customizations here.
; Make sure that if you overide standard JAWS or JAWS Delphi framework functions that they 
; properly call the standard function if required.