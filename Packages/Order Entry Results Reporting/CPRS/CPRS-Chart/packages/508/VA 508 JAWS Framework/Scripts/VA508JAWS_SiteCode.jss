/***************************************************************
This file is used to load SITE SPECIFIC code. 
Be sure to update the version number so that this file is not 
overwritten when/if a new Jaws update is updated.
***************************************************************/

Const	
/***************************************************************
 UPDATE THE SCRIPT VERSION: This will be used to update this file
 Please do not use 1, this is the base version.  
***************************************************************/
	VA508_Script_Version = 15
; import DELPHI framework customizations. 
import "VA508JAWS.jsd" 

/***************************************************************
The below line is used to dynamically add "include" files
as outlined in the VA508ScriptList.ini. Please do not remove
***************************************************************/
	;VA508_FRAMEWORK_INCLUDES

; Standar constants 
include "hjconst.jsh" 
Globals
	handle gprevFocus,
	string gs_DelphiApplicationName,
	int gbVA508suppressEcho,
	collection Delphi_AppDefined 


/***************************************************************
 SiteCodSiteCode initialize 
	This code will tell the standard script file which of the following functions for a specific application have code defined in this module.
	Also any code that needs to run as part of AutoStart (whenever the application takes focus.
 	The following function need to have overrides with specific app prefix information.
		int HandleCustomWindows(FocusWindow)
		int HandleCustomAppWindows (handle AppWindow ) 
		String GetCustomTutorMessage ()

	TO override one of the above functions call it APPNAME__FUnctionName and create a collection instance for tthe function.
	An example for CPRSChart is included in this script.
***********************************************/




Void Function SiteCodeInitialize ()
; Below is commented out to prevent actual use 
;Delphi_AppDefined .CPRSChart__HandleCustomWindows = True  ; We are customizing HandleCustomWindows for CPRSChart.
	
	;SayMessage (OT_JAWS_MESSAGE, "VA508JAWS_SiteCode Site Code Initialize")

EndFunction


 
/***************************************************************
 Add all custom site code below  
***************************************************************/
;***
; Site specific code for CPRSChart
;
;***
; Site specific code for ProviderRoleTool added 2/19/2021
;
;  *** 



int Function CPRSChart__HandleCustomWindows (handle FocusWindow)
	SayMessage (OT_JAWS_MESSAGE, "Special handling for " + GetWindowClass (FocusWindow)) 
EndFunction

int Function ProviderRoleTool__HandleCustomWindows (handle FocusWindow)
	SayMessage (OT_JAWS_MESSAGE, "Special handling for " + GetWindowClass (FocusWindow))
EndFunction
