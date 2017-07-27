;
; This This JAWS module adds specific additions for CPRS and GMV_VitalsViewEnter for the DELPHI Framework.
; This module will bring in the framework library.
; By placing applications specific functions in this file, it makes the use of CPRSCHART.JSS able to have local changes that can then call the functions in this library.
;Written for the VA508 Script project
;Original scripts by: CBell
;Updated: May , 2016 by Jonathan Cohn 
; Revision History
; Version 3 - Jonathan Cohn May 9 , 2016 
;Extended Notes move to function with new keystroke F6 to jump to major controls in the NOTES tab.
; Added Script:  MoveToCurrentNote 
; Renamed Script: MoveToNote to  MoveToNewNote 
; Updated Function: FindNotesWindow  
; New Function:  MarkNotesLabelWindow , MarkNotesEditWindow 

;
; Version 2 - Jonathan Cohn April 27, 2016 
; Added functionality to move to the notes editor no matter where in the patient smain tab we are in.
;
; Rvision 1- Jonathan Cohn April 15, 2016 
; Initial revision, migrated code that was in CPRCHART.jss to athis library file. This will allow easier custom code to be added by other scripters.
; Added functionality to the JawsFind script to search GRIDS.

use "VA508JAWS.jsb" ; import DELPHI framework 

; constants are differentiated by underscores between words,
Const	
	; Not used by any code in this file, but read by JAWS.SR from this file to determine if the script file should be updated with a newer version
	VA508_Script_Version = 3
		,
	; Site specific library used in  PerformFunction()
	VA508_SITE_LIBRARY  = "VA508JAWS_SiteCode::"


/***************************************************************
;Below is the Application specific code (Code written by SRA )
***************************************************************/

	include "hjConst.jsh" ; Standard constants 
	include "winstyles.jsh" ; WWindow style bits used to check READ only state.
	include "common.jsm"  ;  cscNull and cscSpace along with other standard messages 

	const WC_CAPTION_LISTBOX = "TCaptionListBox"

MESSAGES
@msgLeaveTextBox 
Use control-tab or control-sshift-tab to leave this edit box.
@@

@msg_CPRSChart_HotKey
Here are some JAWS hot keys for use with CPRS:
description  hot key
Screen Sensitive Help   %keyfor(ScreenSensitiveHelp)
Activate Note for current patient %keyfor(MoveToNote )
Speak chart tab and Patient name  %keyfor(VA508SendCustomCommand(3))
Search in grid %keyfor(JawsFind)
Switch Tab or exit rich edit box  %keyfor(VA508SendCustomCommand(1))
Reverse switch Tab or exit rich edit box  %keyfor(VA508SendCustomCommand(2))


In lists:
Click Cell: %keyfor(ltLeftClickCell)
Sort column  %keyfor(ltLeftClickHeader)

In tree views:
Edit item  %keyfor(f2editTreeNode)

Press escape to close this window
@@

EndMessages 

globals 
; Used in va508changeEvent to prevent double speaking 
	int giSuppressState,
; used in tab / shift-tab / handleCustomWindows to correct tabbing to frames. 
	int  CPRS_TabDirection ,
	;Used in JAWSFind to let functions know a find window is active.
	int InJAWSFind ,
	int JAWSFindComplete,
	; used in find note functionality
	handle ghLastNotesWindow ,
	handle gprevFocus ,
	string gs_DelphiApplicationName,
	; prevent double speaking in focus change 
	int gbVA508suppressEcho ,
	collection Delphi_AppDefined 



const 
CPRS_tab_none = 0,
	cprs_tab_forward = 2,
	cprs_tab_back = 2 




Function AutoStartEvent () ; Set globals used for determineing specific application being run
var
	handle hNull 

gs_DelphiApplicationName  = GetActiveConfiguration ()
ghLastNotesWindow   = hNull 

; initialize customized handlers 


; Call standard 
VA508JAWS::AutoStartEvent()
EndFunction

Function AutoFinishEvent () ; Set globals used for determineing specific application being run

gs_DelphiApplicationName  = cscNull

; Call standard 
VA508JAWS::AutoFinishEvent ()
EndFunction
;****
; Start of function wrappers 
; Below code is generalized and should not do specific functions. Specific application functions will be called from the wrapper.
; ***

Int Function HandleCustomWindows (handle FocusWindow)
var   
	string AppSpecificFunctionName  = gs_DelphiApplicationName   + "__HandleCustomWindows" ,
	int iResult = 0

if  isSpecialFocus ( False ) Then
	Return False 
EndIf

; If the dictionary says we have a Site specific version then call it.
if  Delphi_AppDefined    [AppSpecificFunctionName  ] Then 
	iResult = CallFunctionByName (VA508_SITE_LIBRARY  + AppSpecificFunctionName  , FocusWindow) 
	if iResult then Return True EndIf 
EndIf

; BCMA, CPRSChart and VitalsLite have specialized code 
iResult = CallFunctionByName (AppSpecificFunctionName  , FocusWindow) 
	if iResult then Return True EndIf 
; Call the routine from  VA508JAWS (standard distribution the 
return VA508JAWS::HandleCustomWindows( FocusWindow) 
EndFunction


string function GetCustomTutorMessage()
var   
	string AppSpecificFunctionName  = gs_DelphiApplicationName   + "__GetCustomTutorMessage" ,
	string sResult = cscNull 

if  isSpecialFocus ( False ) Then
	return sResult 
EndIf

; If the dictionary says we have a Site specific version then call it.
if  Delphi_AppDefined    [AppSpecificFunctionName  ] Then 
	sResult = CallFunctionByName (VA508_SITE_LIBRARY  + AppSpecificFunctionName  ) 
	if sResult then Return sResult EndIf 
EndIf

	sResult = CallFunctionByName (AppSpecificFunctionName  ) 
	if sResult then Return sResult  EndIf 

return GetCustomTutorMessage() ; call default 
endFunction

Script HotKeyHelp ()
var String HelpText 

if  gs_DelphiApplicationName== "CPRSChart"  Then 
	HelpText  =  msg_CPRSChart_HotKey
Else
	PerformScript HotKeyHelp()
EndIf 

if UserBufferIsActive () Then
	UserBufferDeactivate ()
EndIf
SayFormattedMessage (OT_USER_BUFFER, HelpText 
)

EndScript



;IN CPRS Calendar view read column headers.
Void Function VA508ChangeEvent (handle hwnd, int iDataStatus, string sCaption, string sValue, string sControlType, string sState, string sInstructions, string sItemInstructions)
var
	string sColumnNumber

; Handle  calendar that provide Column and row information instead of value #25, #27 , #29,#30, JCC 01/2015 
if GetWindowClass (hWnd) == "TORCalendar" 
   && StringLeft (sValue, 7) == "column " 
Then 
	sColumnNumber = SubString (sValue, 8, 1)
	; Suppress speaking of highlights 
	gbVA508suppressEcho = True 
	if sColumnNumber == "1" Then 
	sValue = "Sunday"
	Elif sColumnNumber == "2" Then 
		sValue = "Monday"
	Elif sColumnNumber == "3" Then 
		sValue = "Tuesday"
	Elif sColumnNumber == "4" Then 
		sValue = "Wednesday"
	Elif sColumnNumber == "5" Then 
		sValue = "Thursday"
	Elif sColumnNumber == "6" Then 
		sValue = "Friday"
	Elif sColumnNumber == "7" Then 
		sValue = "Saturday"
	EndIf
EndIf
VA508ChangeEvent(hwnd, iDataStatus, sCaption, sValue, sControlType,sState, sInstructions, sItemInstructions)
EndFunction

Script ControlEnter ()
var
	int hItem,
	handle hWnd

sayCurrentScriptKeyLabel()
let hwnd = getFocus()
if getWindowClass(hWnd) == WC_CAPTION_LISTBOX then
	saveCursor()  JAWSCursor()  saveCursor()
	routeJAWSToPC()
	leftMouseButton()
	LeftMouseButton ()
	return
endIf
typeCurrentScriptKey() ; Pass key to application 
EndScript

Script EnterKey ()
var 
	Handle hwnd = getFocus()

if getWindowClass(hWnd) == WC_CAPTION_LISTBOX then
			SayMessage(OT_JAWS_MESSAGE, "Use the controlEnter to simulate a double click", "Enter")
EndIf

	typeCurrentScriptKey() ; Pass key to application 
EndScript





;---***---
; Start of Code for CPRSChart (CPRS) 
;---***---

int Function CPRSChart__HandleCustomWindows (handle FocusWindow)
var   
	String FocusName = GetWindowName (FocusWindow ),
	String FocusClass = GetWindowClass (FocusWindow),
	handle RealWindow = GetRealWindow (FocusWindow ),
	string RealName = GetWindowName (RealWindow),
	String RealClass = GetWindowClass (RealWindow),
	handle hwnd,
	string 	wndClass,
	string wndName,
	int isSameWindow = (FocusWindow == gprevFocus ),
	int tabdirection = CPRS_TabDirection
; reset globals 
CPRS_TabDirection= CPRS_Tab_None 
gPrevFocus  = FocusWindow 
; Correct move up in list and move down in list for on cover bage panel 	adjustments.
if StringCompare(FocusClass,"TBitBtn") == 0  
  && StringLength(FocusName ) == 0 
  && StringCompare(RealClass,  "TfrmRemCoverSheet") == 0 
Then 
	var 
		int iWindowX = GetWindowHierarchyX (FocusWindow),
		int iWindowY = GetWindowHierarchyY (FocusWindow)
	if  iWindowX  == 9 && iWindowY == 4 Then 
		return 	SayControlEx(FocusWindow, "Move Up in list")
	elif  iWindowX  == 8 && iWindowY == 4 Then 
		return SayControlEx(FocusWindow, "Move down in list")
	EndIf

; Speak  buttons for selection panels (buttons with Names "<" , ">", "<<"  and ">>"  #20	ElIf StringCompare (FocusClass , "TButton" )== 0 Then
Elif StringCompare (FocusClass , "TButton" )== 0 Then
	if StringCompare(FocusName, ">" ) == 0 Then
		return SayControlEx (FocusWindow, "Add to selection list")
	Elif StringCompare(FocusName, "<" ) == 0 Then
		return SayControlEx (FocusWindow, "Remove from selection list")
	Elif StringCompare(FocusName, ">>" ) == 0 Then
		return SayControlEx (FocusWindow, "Add all to selection list")
	Elif StringCompare(FocusName, "<<" ) == 0 Then
		return SayControlEx (FocusWindow, "Remove all from selection list")
	EndIf
EndIf ; Need to be able to look at other buttons 

; Speak login dialog messages  Issue: Scripting #  6 01/2015 
If StringCompare(RealClass , "TMessageForm" ) == 0 Then  
	SayMessage( OT_DIALOG_TEXT, GetWindowTextEx (RealWindow, False, False, True))
; Error dialog in CPRS v31 has a child memo .
Elif StringCompare(RealClass, "TfrmErrMsg") ==  0   Then 
	SayMessage( OT_DIALOG_TEXT, GetWindowTextEx (GetFirstChild(RealWindow), False, False, True))
; Speak window with class TStaticTextwhen on a button in Discharge Summary Properties window 
elif RealName == "Discharge Summary Properties" && GetWindowTypeCode (FocusWindow )   == WT_BUTTON then
	hwnd = GetNextWindow(FindWindow (RealWindow , "TStaticText")) ; 
	wndClass =  GetWindowClass (hwnd)
	wndName = GetWindowName(hwnd)
	if ( wndClass == "TStaticText" ) then 
		SayMessage (OT_HELP, wndName, "")
	endif 
; Speak spin box name in auto discharge orders window #21 
elif StringCompare (RealClass , "TfrmOrdersEvntRelease") == 0 
   && StringCompare( FocusClass, "TEdit") == 0 
Then
	return SayControlEx (FocusWindow, GetWindowTextEx (GetPriorWindow (GetParent (FocusWindow)), False, False ), "SpinBox" )
; Prevent continually repeating when focus change is declared for the same window 
elif StringCompare(FocusClass , "TCPRSDialogRichEdit" ) == 0 then 
	if  isSameWindow  then 
		return true
	EndIf
; FOR PANEL THAT HAVE FOCUS AND ONLY ONE CHILD 
ELIF  isListPanel (FocusWindow) Then 
	if TabDirection == cprs_tab_forward then
		TabKey ()
		return true 
	elif  TabDirection == CPRS_Tab_Back Then 
		ShiftTabKey ()
		return true 
	EndIf 
endif


; for readonlyRichEdit, Memos and CaptionMemo read the entire window text on focus  
if  ((FocusClass == "TRichEdit"
       || FocusClass  == "TMemo" 
       || FocusClass == "tCaptionMemo" ) 
     && (GetWindowStyleBits (FocusWindow) & ES_READONLY )) THEN
	Say (GetWindowText (FocusWindow, false), OT_SCREEN_MESSAGE )
	 return true
EndIf 
EndFunction

string function CPRSChart__GetCustomTutorMessage()
var 
	handle FocusWindow,
	string FocusClass 
FocusWindow = GetCurrentWindow ()
FocusClass = GetWindowClass (FocusWindow) 

if  ( FocusClass == "TRichEdit"
   ||   FocusClass == "tCaptionRIchEdit" )
   && ! (  GetWindowStyleBits (FocusWindow) & ES_READONLY ) ; Not ReadOnly 
Then   
	return msgLeaveTextBox  
elif  FocusClass == "TStatusBar" Then
	return"Click Insert-PageDown at any time to read this status."
elif   FocusClass == "TCPRSDialogRichEdit" then
	return(cscSpace )
EndIf
endfunction

;---***---
; Start of Code for BCMA (Bar Code Medication 
;---***---

; ***

;---***---
; Start of Code for Vitals module
;---***---

int Function GMV_VitalsViewEnter__HandleCustomWindows (handle FocusWindow) 
var
	String FocusClass = GetWindowClass( FocusWindow ),
	handle ParentWindow  = GetParent(FocusWindow),
	Handle LabelWindow ,
	Handle MarkerWindow = GetParent(GetParent( ParentWindow) ), ; generally this should be the data strip if it is present.
	String sGroupLabel
; First check for vital input screen lots of things to do here!
if GetWindowClass (GetTopLevelWindow (FocusWindow)) == "TfrmGMV_InputLite" Then 
	; mostly edit fields are one level lower in the tree Try the next parent 
	if FocusClass == "edit" && GetWindowClass(MarkerWindow) !=  "TfraGMV_InputOne2" Then 
		MarkerWindow = GetParent(MarkerWindow)
	EndIF

	; Check to see if we are in input strip area 
	if GetWindowClass(MarkerWindow) == "TfraGMV_InputOne2" Then 
		LabelWindow =  GetFirstChild( GetFirstChild (MarkerWindow)) ;  ; Window with vital type 
		sGroupLabel = GetWindowTextEx (LabelWindow , False, False , True )
		LabelWindow = GetNextWindow (GetNextWindow (LabelWindow)) ; window with line count 
		sGroupLabel = GetWindowTextEx (LabelWindow, False, False, True ) + sGroupLabel 
		If FocusClass == "tCheckBox" Then
			if GetWindowHierarchyX (ParentWindow)  == 4 Then
				return SayControlEx (FocusWindow, "Metric", cscNull, cscNull, sGroupLabel)
			Elif GetWindowHierarchyX (ParentWindow)  == 3 
			  && GetWindowHierarchyX (FocusWindow) == 1 
			Then
				return SayControlEx (FocusWindow, sGroupLabel + ", mark as unavailable") ; Incorporate the group label in the first check box so it reads once 
			Elif GetWindowHierarchyX (ParentWindow)  == 3 
			  && GetWindowHierarchyX (FocusWindow) == 2 
			Then
				return SayControlEx (FocusWindow, "Mark as refused", cscNull, cscNull, sGroupLabel)
			Else
				Return False ; we don't know this checkbox 
			EndIf 
		elif FocusClass == "TComboBox"Then 
			SayControlEx( FocusWindow,  sGroupLabel)
			Return True 
		elif FocusClass == "EDIT"Then 
			var string sUnits = GetWindowText (GetFirstWindow (ParentWindow), False)
			SayControlEx( FocusWindow,  sGroupLabel)
			if GetWindowHierarchyX (ParentWindow) > 1 Then 
				SayMessage (OT_SCREEN_MESSAGE," IN" + sUnits, cscNull)
			EndIf
Return True 
		ElIf FocusClass == "TBitBtn" Then 
			return SayControlEx( FocusWindow, "Enter qualifiers" , cscNull, cscNull, sGroupLabel)
		EndIf
	EndIf
elif FocusClass ==  "TListBox" Then  ; only one list box in Vitals lite 
	Return SayControlEx(FocusWindow, "Select report dates")
ElIf FocusClass == "TTrackBar"  Then  ; Speak some data of use here 
	SayMessage(OT_SCREEN_MESSAGE, GetWindowText (FindWindow (GetParent (GetParent (GetParent (FocusWindow))), "TStringGrid" ), False))
	Return True 
ElIf FocusClass == "TStringGrid"Then 
	SayLine()
	Return True 
; Speak dialog text of input errors 
ElIf GetWindowClass(GetParent( FocusWindow )) == "TMessageForm" Then 
	SayWindow (GetParent(FocusWindow) , Read_Everything)
EndIf 

; for readonlyRichEdit, Memos and CaptionMemo read the entire window text on focus  
if  ((FocusClass == "TRichEdit"
       || FocusClass  == "TMemo" 
       || FocusClass == "tCaptionMemo" ) 
     && (GetWindowStyleBits (FocusWindow) & ES_READONLY )) THEN
	Say (GetWindowText (FocusWindow, false), OT_SCREEN_MESSAGE )
	 return true
EndIf 
EndFunction


;*** foobar *** debugging codes 

 



void function ObjStateChangedEvent(handle hObj, optional int iObjType, int nChangedState, int nState, int nOldState)
; force v508 change event state from speaking state 
giSuppressState = false 
ObjStateChangedEvent(hObj, iObjType, nChangedState, nState, nOldState)
EndFunction


Script tab()
CPRS_TabDirection  = cprs_tab_forward 
PerformScript Tab()		
EndScript
Script Shifttab()
CPRS_TabDirection  = cprs_tab_back
PerformScript ShiftTab()		
EndScript
globals 
string gsVA508cacheValue , string gsVA508varData, string gsVA508Data




; Are we in the parent of a list view instead of the list view. \
; CPRS has some extra tab stops appearing in these locations.
Function isListPanel (handle hWnd)
var 
	handle FirstChild  = GetFirstChild(hWnd)
if GetWindowClass(hWnd ) == "TPanel" 
	&& FirstChild 
	&& GetWindowClass(GetFirstChild(hWnd )) ==  "TListView"
Then 
	; Just to be paranoid, only succeed when there is exactly one child window 
	return not GetNextWindow (GetFirstChild (hWnd))
EndIf
Return False 
EndFunction


; When shift tabbing, ActiverITem is changed instead of focus change.
Void Function ActiveItemChangedEvent (handle curHwnd, int curObjectId, int curChildId,
	handle prevHwnd, int prevObjectId, int prevChildId)
if  CPRS_TabDirection 
	; If we are in a pane with a list inside then do a shift tab if Tabdirection says so. Also reset the global.
	if  isListPanel (curHwnd) 
	  && CPRS_TabDirection == CPRS_Tab_Back Then 
		CPRS_TABDirection = CPRS_Tab_None 
		ShiftTabKey ()
		return 
	Else
		CPRS_TabDirection = CPRS_Tab_none 
	EndIf 
EndIf
return ActiveItemChangedEvent (curHwnd, curObjectId, curChildId,	prevHwnd, prevObjectId, prevChildId)
EndFunction 


 
; Grids were generating FocusChangedEvents causing the Name and type to be spoken on each move within the Grid. Have Grids behave more like listboxes.
void function ProcessEventOnFocusChangedEventEx(
	handle hwndFocus, int nObject, int nChild,
	handle hwndPrevFocus, int nPrevObject, int nPrevChild,
	int nChangeDepth, string sClass, int nType)
if  hwndFocus ==  hwndPrevFocus
  && nType ==WT_LISTBOX 
  && StringCompare(sClass , "TCaptionStringGrid" ) == 0 
then 
	ActiveItemChangedEvent(hwndFocus,nObject,nChild,hwndPrevFocus,nPrevObject,nPrevChild)
	SayMessage (OT_POSITION, PositionInGroup ())
Else
	ProcessEventOnFocusChangedEventEx(
	hwndFocus, nObject, nChild,
	hwndPrevFocus, nPrevObject, nPrevChild,
	nChangeDepth, sClass, nType)
EndIf 
EndFunction 

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

; the next 5procedures implment the move to notes functionalities 
Script MoveToNewNote ()	
var
	handle hReal =  GetRealWindow (GetFocus()),
	handle hTabControl = GetFirstChild(GetFirstChild(hReal )),
	handle hNewNoteButton,
	handle hNotes
While hTabControl && GetWindowTypeCode (hTabControl ) != WT_TABCONTROL 
	hTabControl = GetNextWindow (hTabControl)
EndWhile 

if hTabControl Then 
	if GetWindowName(hTabControl ) != "Notes" Then 
		TypeKey ("Control+n" )
		delay(2)
	EndIf
else
	SayMessage(OT_ERROR, "Notes tab is currently unavailable" , "Unavailable")
EndIf

; We should now be on the Notes tab. Check this by looking at the New Note button 
hNewNoteButton = FindWindow(hReal,  "TORAlignButton", "New Note")
if hNewNoteButton then
	if IsWindowDisabled (hNewNoteButton) then 
		hNotes =  FindNotesWindow (hReal)
		if hNotes then
			Say("A new note is already started. You are now in the active note", OT_JAWS_MESSAGE)
			SetFocus(hNotes)
		EndIf
	Else
		SetFocus(hNewNoteButton)
		Delay(1)
		TypeKey("Space")
	EndIf
EndIf
EndScript

HANDLE Function FindNotesWindow (handle hReal)
var
	handle hNotesPage ,
	handle hNull

ghLastNotesWindow  = hNull 
; Find the Notes tab page and then look for an active RichEdit 
	hNotesPage = FindWindow(hReal, "TfrmNotes", "frmNotes")
	if IsWindowVisible (hNotesPage ) Then
	; First look for the notes label and if that fails then look for the text field  of a note.
	EnumerateChildWindows (hNotesPage, "MarkNotesLabelWindow")
	if not  ghLastNotesWindow   Then 
		EnumerateChildWindows (hNotesPage, "MarkNotesEditWindow")
	EndIf
EndIf
return ghLastNotesWindow  
EndFunction

Function MarkNotesEditWindow (handle hwnd)
if GetWindowClass(hWnd) == "TRichEdit" 
  && isWindowVisible(hWnd)
  && not isWindowDisabled(hWnd)
  && GetWindowHierarchyX (hWnd) > 2 
Then
	ghLastNotesWindow = hWnd 
	Return False
else
	return True 
EndIf
EndFunction 




Function MarkNotesLabelWindow (handle hwnd)
if GetWindowClass(hWnd) == "TVA508StaticText" 
  && isWindowVisible(hWnd)
  && not isWindowDisabled(hWnd)
  && GetWindowHierarchyX (hWnd) > 2 
Then
	ghLastNotesWindow = hWnd 
	Return False
else
	return True 
EndIf
EndFunction

Script MoveToCurrentNote ()	
var
	handle hReal =  GetRealWindow (GetFocus()),
	handle hTabControl = GetFirstChild(GetFirstChild(hReal )),
	handle hNewNoteButton,
	handle hNotes

While hTabControl && GetWindowTypeCode (hTabControl ) != WT_TABCONTROL 

	hTabControl = GetNextWindow (hTabControl)
EndWhile 

if hTabControl  == 0 
  || GetWindowName(hTabControl ) != "Notes" 
  Then 
	SayMessage( OT_JAWS_MESSAGE, "Only available in NOTES Tab.", "Not in notes")
	return
EndIf
; now that we have verified we are in the notes field process as appropriate.
if not MarkNotesLabelWindow (GetFocus()) then 
	; In notes label just tab.
	PerformScript Tab()
Elif not MarkNotesEditWindow (GetFocus()) then 
	; current window is a notes edit window, move to the tree view.
	SetFocus (FindWindow (hReal, "TORTreeView" ))
	delay(2)
else 
	SayMessage(OT_JAWS_MESSAGE, "Moving to Note text", "Notes")
	delay(1)
	hNotes =  FindNotesWindow (hReal)
	SetFocus(hNotes)
EndIf
EndScript