;
; This JAWS module adds specific additions for BCMA DELPHI Framework.
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

MESSAGES
@msg_BCMA_HotKey
Here are some hot keys for use with BCMA:
description  hot key
Medication Orders Alt-M.
Reports Alt+R.
Switch Tab %keyfor(NextDocumentWindow).
Reverse switch Tab %keyfor(PreviousDocumentWindow).


In lists:
Click Cell: %keyfor(ltLeftClickCell).
Sort column  %keyfor(ltLeftClickHeader).

In tree views:
Edit item  %keyfor(f2editTreeNode).

Press escape to close this window
@@
EndMessages 

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

Script HotKeyHelp ()
var String HelpText 

	HelpText = msg_BCMA_HotKey
if UserBufferIsActive () Then
	UserBufferDeactivate ()
EndIf
SayFormattedMessage (OT_USER_BUFFER, HelpText 
)

EndScript

; The next three function are for control-tab and control-shift-tab 
Script NextDocumentWindow ()
if BCMA__TabBarChange() then
		Return 
Else 
	PerformScript NextDocumentWindow()
EndIf
EndScript

Script PreviousDocumentWindow ()
if BCMA__TabBarChange() then
		Return 
Else 
	PerformScript NextDocumentWindow()
EndIf
EndScript

; Special handling of control-tab and control-shift-tab
; TabBarChange()
; returns true when tabTabBar was found
; Put focus on TabBar if in main window =  TfrmMainClass  and then run script key.
int Function BCMA__TabBarChange ()
var 
	handle  hWind,
	handle hReal,
	handle hTabBar
hWind = GetCurrentWindow ()
hReal = GetTopLevelWindow ( hWind )
if GetWindowClass (hReal) ==  "TfrmMain"  then 
	hTabBar = FindWindow (hReal, "TPageControl")
	if hTabBar != 0 THEN
		setFocus(hTabBar )
		delay(1)		
		TypeCurrentScriptKey ()
		return true
	EndIf
EndIf
return false
EndFunction






; HandleCustomWindows 
; Parameter 1 handle of window to provide custom speaking.
; returns boolean  true to stop additional processing.
;  1 In Main Window (Class = TfrmMain )
;	a) for Patient Info  (Class = TRichEdit ) Make jaws declare as Button with name of "Patient Information"
;	b) (Class = TListView) Speak control with Name as "BCMA Clinical Reminders"
;	c)(Class = TListBox) Speak jaws cursor must be used.
;	d) (class = TStringGrid) Speak current TabBar.
Function HandleCustomWindows (handle FocusWindow)
var 
	handle RealWindow =  GetRealWindow  (FocusWindow ),
	Handle hTabBar,
	String sNull,
	string sRealClass = GetWindowClass (RealWindow) 

if  SuppressFocusChange() Then
	Return true
endif

if sRealClass ==  "TfrmMain"  then 
	if GetWindowClass (FocusWindow) ==  "TRichEdit"  then
		SayControlEx (FocusWindow , "Patient Information", "button", sNull, sNull, sNull, GetWindowTextEx (FocusWindow , false, false ))
		return true 
	elif GetWindowClass(FocusWindow) == "TListView"  then 
		SayControlEx (FocusWindow,"BCMA Clinical Reminders") 
		return true
	elif  GetWindowClass (FocusWindow) == "TListBox"   Then
		SayString("This grid only works with jaws cursor ")
		SaveCursor()
		JawsCursor()
		RouteJAWSToPc ()
		SetRestriction (RestrictWindow )
		SayLine ()
	elif GetWindowClass (FocusWindow) == "TStringGrid" Then
		hTabBar = FindWindow (RealWindow , "TPageControl")
		if hTabBar != 0 Then
			SayObjectTypeAndText (1)
;			SayWindowTypeAndText (hTabBar)	
		endif
	EndIf
EndIf
EndFunction


; ***
; HandleCustomAppWindows 
; Parameter 1 handle of window to provide custom speaking.
; returns boolean  true to stop additional processing.
; When the TfrmMain real window becomes active move focus to the TabBar.
Function HandleCustomAppWindows (handle hReal)
var Handle hGrid
if  SuppressFocusChange() Then
	Return true
endif
if GetWindowClass (hReal) ==  "TfrmMain"  then 
	hGrid =  FindWindow (hReal, "TStringGrid")
	if hGrid != 0 Then
		SetFocus(hGrid)
		return(true)
	endIf
EndIf 
EndFunction


Function GetCustomTutorMessage ()
var 
	handle hFocus,
	handle hReal,
	string sClass 

hFocus = GetCurrentWindow ()
hReal = GetRealWindow (hFocus )
sClass = GetWindowClass (hFocus) 
if  sClass == "TRichEdit" && GetWindowClass( hReal )== "TfrmMain"  then 
	return "for a full PATIENT INQUIRY click the ENTER button."
elif sClass == "TStringGrid" Then
		return "Press enter for details."
EndIf
EndFunction
