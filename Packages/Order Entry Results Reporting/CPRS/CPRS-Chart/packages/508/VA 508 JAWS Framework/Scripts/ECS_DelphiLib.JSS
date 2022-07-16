
; Use only one of the below if there is a delphi Lib JSB file, it will use jaws.jsb va508
; use "VA508JAWS.jsb" ; import DELPHI standard framework
;use "CPRS_DelphiLib.jsb" ; CPRS / Vials lite additions to the DELPHI Dramework.

import "va508jaws.jsd" ; import function declarations  from documentation file (help compile and control+I to work.

; constants are differentiated by underscores between words,
Const	
; Not used by any code in this file, but read by JAWS.SR from this file to determine if the script file should be updated with a newer version
	VA508_Script_Version = 11,
; Site specific library used in  PerformFunction()
;	VA508_SITE_LIBRARY  = "VA508JAWS_SiteCode::"




/***************************************************************
Below is the Application specific code (Code written by SRA )
***************************************************************/
include "hjconst.jsh" 
globals
	int InJAWSFind,
	int JAWSFindComplete

void function DoJAWSFind(optional int bReverse)
var 
	int bForceJaws  = False 

InJAWSFind = true 
if IsPCCursor () 
  && StringCompare(GetWindowClass (GetFocus ( )), "TCaptionStringGrid"  ) == 0 
Then 
	bForceJaws = true 
	JawsCursor()
	RouteJAWSToPc ()
	var int iRestriction = GetRestriction ()
	SetRestriction (RestrictWindow )

	delay(1) 
EndIf
var int iResult = JawsFind(bReverse)
if bForceJaws Then
	delay(2)
	SetRestriction (iRestriction)
	PCCursor ()
EndIF
; Speak if we found something 
if iResult then
	SayLine()
EndIf

InJAWSFind = FALSE
JAWSFindComplete=GetTickCount()
EndFunction

; Place any customizations here.
; Make sure that if you overide standard JAWS or JAWS Delphi framework functions that they 
; properly call the standard function if required.


