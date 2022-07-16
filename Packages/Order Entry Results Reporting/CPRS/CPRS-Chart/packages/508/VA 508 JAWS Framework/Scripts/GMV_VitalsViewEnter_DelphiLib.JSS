;
; This JAWS module adds specific additions for GMV_VitalsViewEnter DELPHI Framework.
; This module will bring in the framework library.
; By placing applications specific functions in this file, it makes the use of BCVMA .JSS able to have local changes that can then call the functions in this library.
;Written for the VA508 Script project
;Original scripts by: CBell
;Updated: April , 2016 by Jonathan Cohn 

use "VA508JAWS.jsb" ; import DELPHI framework 

; constants are differentiated by underscores between words,
Const	
	; Not used by any code in this file, but read by JAWS.SR from this file to determine if the script file should be updated with a newer version
	VA508_Script_Version = 1
		

/***************************************************************
;Below is the Application specific code (Code written by SRA )
***************************************************************/

	include "hjConst.jsh" ; Standard constants 
	include "winstyles.jsh" ; WWindow style bits used to check READ only state.
	include "common.jsm"  ;  cscNull and cscSpace along with other standard messages 

globals 
; Application name used in a few cases still.
	string gs_DelphiApplicationName



Function AutoStartEvent () ; Set globals used for determineing specific application being run
gs_DelphiApplicationName  = GetActiveConfiguration ()
; initialize customized handlers 


; Call standard 
VA508JAWS::AutoStartEvent()
EndFunction

Function AutoFinishEvent () ; Set globals used for determineing specific application being run

gs_DelphiApplicationName  = cscNull
; Call standard 
VA508JAWS::AutoFinishEvent ()
EndFunction



;---***---
; Start of Code customized for for BCMA (Bar Code Medication 
;---***---

; ***

; HandleCustomWindows 
int Function GMV_VitalsViewEnter__HandleCustomWindows (handle FocusWindow) 
Return False
EndFunction