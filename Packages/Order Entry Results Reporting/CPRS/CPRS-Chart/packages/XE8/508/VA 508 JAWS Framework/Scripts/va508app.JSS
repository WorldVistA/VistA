
/* 
 This is used for custom application code and allows sites to load site specific code 


Written for the VA508 Script project
Original scripts by: CBell
Updated: May, 2014 by Chris Bell
*/

/***************************************************************
To add site specific code, Follow the instructions in file name 
VA508JAWS_SiteCode.jss. 
This will cause a warning message if removed or commented out.
***************************************************************/
	Use "VA508JAWS_SiteCode.jsb" ; import functions from site specific code These will override the Delphi framework. code 

use "VA508JAWS.jsb" ; import DELPHI framework 
import "va508jaws.jsd" ; import function declarations  from documentation file (help compile and control+I to work.

; constants are differentiated by underscores between words,
Const	
; Not used by any code in this file, but read by JAWS.SR from this file to determine if the script file should be updated with a newer version
	VA508_Script_Version = 7
	

/***************************************************************
The below line is used to dynamically add "include" files
as outlined in the VA508ScriptList.ini. Please do not remove
***************************************************************/
	;VA508_FRAMEWORK_USES


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


