; Scripts for CAPRI Version 2.7.190.4 
; Department of Veterans Affairs Feb 23, 2016 
; Author: Jonathan Cohn (section508@domain)
; Script version 4
; CAPRI Version 2.7.190.4 
;Jaws Version: Written with JAWS 17 
; Revision History
; Version 4
; Updated code to work with current DELPHI Framework and jsh/jsm files.


/* 
 This is used for custom application code and allows sites to load site specific code 


Written for the VA508 Script project
Original scripts by: CBell
Updated: May, 2014 by Chris Bell
*/

/***************************************************************
To add site specific code, Follow the instructions in file name 
VA508JAWS_SiteCode.jss. 
***************************************************************/
include "CAPRI.jsh"
include "CAPRI.jsm"
include "hjConst.jsh" ; Standard constants 
include "hjglobal.jsh" 

include "MSAAconst.jsh"
include "common.jsm"  ;  cscNull and cscSpace along with other standard messages 

use "VA508JAWS.jsb" ; import DELPHI framework 

;import "va508jaws.jsd" ; import function declarations  from documentation file (help compile and control+I to work.




; constants are differentiated by underscores between words,
Const	
; Not used by any code in this file, but read by JAWS.SR from this file to determine if the script file should be updated with a newer version
	VA508_Script_Version = 4
/* 
;Below is the Application specific code (Code written by SRA )
***************************************************************/

Function AutoStartEvent () ; Set globals used for determineing specific application being run
gs_DelphiApplicationName  = "capri" 
; initialize customized handlers 
SiteCodeInitialize  ()
; Call standard 
VA508JAWS::AutoStartEvent()
EndFunction

Function AutoFinishEvent () ; Set globals used for determineing specific application being run

gs_DelphiApplicationName  = cscNull
SiteCodeClear()

; Call standard 
VA508JAWS::AutoFinishEvent ()
EndFunction
;****
; 
Script HotKeyHelp ()
var String HelpText 

	HelpText = msg_HotKey

if UserBufferIsActive () Then
	UserBufferDeactivate ()
EndIf
SayFormattedMessage (OT_USER_BUFFER, HelpText 
)
EndScript

; Control tab 


; control+shift+tab 


Script ControlEnter ()
; Double click on current spot when  window class is  CAPTION_LISTBOX
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
; InC and p exam requests allow enter key to move focus appropriately and also use mouse to click.
; overrides behaviour in the tree view and in the body parts button.
var 
	handle hFocusWindow  = GetFocus(),
	string sFocusName = GetWindowName (hFocusWindow),
	handle hAppMainWindow = GetAppMainWindow (hFocusWindow),
	string sAppMainClass = GetWindowClass (hAppMainWindow )

if  sAppMainClass ==  "TfrmViewExam" Then 
	if sFocusName== "Find by Body System"	Then 
		SaveCursor() JawsCursor() SaveCursor()
		RouteJAWSToPc ()
		Delay (1, true)
		LeftMouseButton () 
		Delay (2, True)
		RestoreCursor () RestoreCursor ()
		; Now that click has been performed, set focus on the list of body parts 
		var 
			handle hPanel = FindWindow(FindWindow(hAppMainWindow,  "TPanel", cscNull ), "TPanel", cscNull ),
			handle hDest = FindWindow (hPanel, "TTreeView", cscNull)
		if hDest Then 
			SetFocus( hDest )
		EndIf
	elif  GetWindowClass(hFocusWindow) == "TTreeView" Then 
		SaveCursor() JawsCursor() SaveCursor()
		RouteJAWSToPc ()
		Delay (1, true)
		LeftMouseButton ()   LeftMouseButton ()
		Delay (1, True)
		RestoreCursor () RestoreCursor ()
		; Now that double click has been performed, set focus on exam the list 
		hPanel = FindWindow(FindWindow(hAppMainWindow,  "TPanel", cscNull ), "TPanel", cscNull )
		hDest = FindWindow (hPanel, "TCheckListBox", cscNull)
		if hDest Then 
			SetFocus( hDest )
		EndIf
	Else
		typeCurrentScriptKey() ; Pass key to application 
	EndIf
EndIf

typeCurrentScriptKey() ; Pass key to application 
EndScript

; ***
; HandleCustomAppWindows 
; Parameter 1 handle of window to provide custom speaking.
; returns boolean  true to stop additional processing.
; When the TfrmMain real window becomes active move focus to the TabBar.





; Special handling of control-tab and control-shift-tab
; TabBarChange()
; returns true when tabTabBar was found
; Put focus on TabBar if in main window =  TfrmMainClass  and then run script key.


;---***---
; Start of Code for CAPRI 
;---***---

Int Function HandleCustomWindows (handle FocusWindow)
var
	string FocusName = GetWindowName (FocusWindow),
	string FocusClass = GetWindowClass(FocusWindow ),
	Int FocusSubType = GetWindowSubtypeCode (FocusWindow) ,
	String sGroupName,
	handle AppWindow = GetAppMainWindow (FocusWindow),
	String AppClass = GetWindowClass (AppWindow),
	string sTabName = GetDialogPageName (),
	string sValue,
	int iResult 

if FocusClass == WC_MSAATabControl  Then 
	return  SayControlEx (FocusWindow, sTabName)
Elif AppClass == WC_PatientListAppWindow then 
	; Issue 2 / 20116 better handling of patient list changes 
	if FocusClass == WC_PatientListBox  Then 
SayMessage(OT_JAWS_MESSAGE , msgPatientListUpdated)	
Return true 
	elif focusclass == "tedit" then 
	EndIf
Elif AppClass == WC_MainAppWindow  Then 
	If  StringCompare (sTabName, WN_MAIN_ReportsTab ) == 0 Then
		if FocusSubType == WT_LISTBOX  Then 
			return SayControlEx(FocusWindow, msgWinodwReportList)
		ElIf FocusSubType == WT_READONLYEDIT 
			sValue =  GetWindowText (FocusWindow, False)
			if  StringLength(sValue)  == 0  Then 
				sValue = msg_BlankField
			Else
				sValue = GetLine()
			EndIf
			return SayControlEx (FocusWindow, msgWinodwReportOutput, cscNull, cscNUll, cscNull, cscNull, sValue)
		EndIf
	ElIf  StringCompare (sTabName, WN_MAIN_AddressTab ) == 0 Then
		if (GetWindowHierarchyX (FocusWindow)< 25 
		   && GetWindowHierarchyX (FocusWindow) > 13 )
		 || (GetWindowHierarchyX (FocusWindow) < 7  
		   && GetWindowHierarchyX (FocusWindow) > 1 ) 
		Then 
		sGroupName = "Temporary Address" 
			sValue =  GetWindowText (FocusWindow, False)
			if  StringLength(sValue)  == 0  Then 
				sValue = msg_BlankField
			EndIf

			if GetWindowName(FocusWindow) == "End Date:" Then
				if GetWindowHierarchyX (FocusWindow) == 21 Then
					FocusName = "Address line 3"
				Elif GetWindowHierarchyX (FocusWindow) == 22 Then
					FocusName = "Address line 2" 
				EndIf
			EndIf
			return SayControlEx (FocusWindow, FocusName, cscNull, cscNull, sGroupName , cscNull, sValue)
		EndIf
	ElIf InClinicalTabs () Then 
		var string sCurrentSection =  ClinicalSectionName()

		if  FocusSubType == WT_EXTENDEDSELECT_LISTBOX Then 
			return SayControlEx(FocusWindow, "Select "+ sCurrentSection )
		ElIf FocusSubType== WT_READONLYEDIT Then 
			return SayControlEx(FocusWindow, sCurrentSection)
		EndIf
	ElIf sTabName == "Local"
   && FocusSubType == WT_READONLYEDIT Then 
		return SayControlEx(FocusWindow, "Health Summary Component Report" )
	EndIf
Elif AppClass == "TfrmAddress" then
	If  GetWindowTypeCode  (FocusWindow)== WT_EDIT Then 
		SaveCursor()  InvisibleCursor() SaveCursor() 
		SetRestriction (RestrictAppWindow)
		MoveToWindow (AppWindow )
		JAWSTopOfFile ()
		FindString (AppWindow, "Temporary", S_TOP, S_RESTRICTED , False )
		var int iTemporaryColumn = GetCursorCol ( )
RestoreCursor ()RestoreCursor ()
		if GetWindowLeft (FocusWindow )>= iTemporaryColumn Then
			sGroupName = "Temporary"
		Else
			sGroupName = "Permanent"
		EndIf
	return SayControlEx (FocusWindow, cscNull, cscNull, cscNull, sGroupName)
	EndIf
elif AppClass == "TfrmNewExam"  
   || AppClass == "TfrmViewExam"
then 
	if FocusSubType == WT_LISTBOX  Then 
		if FocusName  == "More"  Then 
				return SayControlEx(FocusWindow, "Considerations Select one or more") 
		ElIf FocusClass == "TCheckListBox"
		   && GetWindowClass (GetNextWindow (FocusWindow)) == "TTreeView"
		   && GetWindowName (GetParent (GetParent (FocusWindow))) == "Exams Requested:"
		Then
			return SayControlEx(FocusWindow , "Select Exams To Add:")			
		EndIf
	ELIf FocusSubType == WT_EDITCOMBO 
	  && StringCompare(FocusName, WN_CP_ClaimRequired ) == 0  then 
		return SayControlEx (FocusWindow, msg_ClaimFileRequired)
	ElIf StringCompare(FocusName, WN_CP_LastRatingExamDate) == 0 Then 
		return SayControlEx (FocusWindow, FocusName, cscNull, cscNull, cscNull, cscNull, GetObjectName (True, 0))
	EndIf
ElIf  AppClass ==  "TfrmExamRequestTemplate" Then 
	if FocusSubType == WT_LISTBOX
	   && GetDialogPageName() == "SC/Increased Eval"
	then 
		return SayControlEx (FocusWindow, "Veteran claims increased disabilities:")
	ElIf FocusSubType  == WT_BUTTON 
	   && GetWindowName (GetNextWindow (FocusWindow)) == "Add New Medical Condition To List"
	Then
		return SayControlEx (FocusWindow, cscNull, cscNull, cscNull, "Add condition")
	EndIf	
elif AppClass == "TfrmReportsAdhocSubItem1" Then 
	if focusClass == "TORComboEdit" Then
		FocusName = "File Selections:"
		SaveCursor() InvisibleCursor() SaveCursor()
		MoveToWindow (GetPriorWindow (GetPriorWindow (GetParent(FocusWindow))))
		sGroupName = GetChunk ()
		RestoreCursor ()RestoreCursor ()
		return SayControlEx (FocusWindow, FocusName, cscNull, cscNull, sGroupName)
	Elif FocusClass == "TORListBox" Then 
		return SayControlEx(FocusWindow, "File Entries Selected:")
	EndIf
elif AppClass == "TFormReportBuilder" 
   && FocusSubType == WT_LISTBOX 
Then
	return sayControlEx(FocusWindow, "List of sections")
elif AppClass == "TfrmPNCSSandbox" Then
	; this window locks us in templates and does nothing just close it.
	TypeKey ("ALT-F4" )
EndIf

; Now handle generalized over rides for the CAPRI application.
if GetWindowClass (FocusWindow )== "TCheckListBox" Then 
;	SayString("Please Verify List Check Box")
	iResult = VA508getComponentProp(FocusWindow , VA508_FieldName_Caption , 0 , FocusName ) ; 0 = Get from cache 
	if ! iResult Then
		FocusName = GetWindowName (FocusWindow )
	EndIf
	Say(FocusName , OT_CONTROL_NAME )
	iResult = 	CAPRI__SpeakSelectedCheckBox()
	if ! iResult Then 
		SayObjectActiveItem (False)
	EndIf
	 return true 
Elif FocusSubType == WT_READONLYEDIT  
   && StringLength (GetWindowText (FocusWindow, False))== 0 
Then
	say(sGroupName , OT_CONTROL_GROUP_NAME)
	Say(FocusName, OT_WINDOW_NAME)
	sayMessage (OT_LINE, "Empty or unavailable field", cscSpace )
	return true 
ElIf FocusClass  == "TTab95Control"
	SayControlEx(FocusWindow, FocusName  )
Elif StringCompare (FocusClass , "TButton" )== 0 Then
; Speak  buttons for selection panels (buttons with Names "<" , ">", "<<"  and ">>"  #20
	if StringCompare(FocusName, ">" ) == 0 Then
		return SayControlEx (FocusWindow, "Add selected component")
	Elif StringCompare(FocusName, "<" ) == 0 Then
		return SayControlEx (FocusWindow, "Remove selected component")
	Elif StringCompare(FocusName, ">>" ) == 0 Then
		return SayControlEx (FocusWindow, "Add all components")
	Elif StringCompare(FocusName, "<<" ) == 0 Then
		return SayControlEx (FocusWindow, "Remove all components")
	EndIf
EndIf
return HandleCustomWindows( FocusWindow) 
EndFunction

Int Function HandleCustomAppWindows (handle hAppMainWindow )
var
	Handle hMemoWindow,
	string sAppMainClass = GetWindowClass (hAppMainWindow )
if sAppMainClass == "TMessageForm" Then 
	Say (GetWindowTextEx (hAppMainWindow , False, False), OT_SCREEN_MESSAGE)
	return(True )
elif sAppMainClass == "TfrmErrMsg"  
   && GetWindowClass( GetFirstChild (hAppMainWindow ))  ==  "TMemo"
Then 
	beep()
	SpeakWindowInformation (hAppMainWindow )
	Say (GetWindowTextEx (GetFirstChild (hAppMainWindow ), False, False, True), OT_ERROR, False)
	Return( True) 
elif sAppMainClass == "TFrmDisplayHelp"  
Then 
	hMemoWindow = FindWindow (hAppMainWindow , "TMemo", cscNull)
	if hMemoWindow Then 
		SpeakWindowInformation (hAppMainWindow )
		Say (GetWindowTextEx (hMemoWindow , False, False, True), OT_ERROR, False)
		Return( True) 
	EndIf
elif sAppMainClass == "TFrmDisplayError"  
Then 
	hMemoWindow = FindWindow (hAppMainWindow , "TMemo", cscNull)
	if hMemoWindow Then 
		beep()
		SpeakWindowInformation (hAppMainWindow )
		Say (GetWindowTextEx (hMemoWindow , False, False, True), OT_ERROR, False)
		Return( True) 
	EndIF
EndIf 
return HandleCustomAppWindows( hAppMainWindow )  ; call default 
EndFunction

string function GetCustomTutorMessage()
; don't attempt to process special windows.
if  isSpecialFocus ( False ) Then
	Return False 
EndIf

var
	handle FocusWindow =  getFocus(),
	Handle AppWindow = GetAppMainWindow (FocusWindow),
	int FocusType = GetWindowSubtypeCode (FocusWindow, True),
	String FocusName = GetWindowName( FocusWindow ),
	String AppClass = GetWindowClass (AppWindow)

if AppClass == "TfrmAddress"  && FocusType == WT_BUTTON Then 
	return FormatString( "Use Virtulize Window %keyfor(VirtualizeWindow ) to review the address.")
ElIf AppClass == WC_PatientListAppWindow&& FocusName==  "More" && FocusType ==WT_BUTTON Then
	Return "type space to expand list of patients."
elif AppClass == "TFormReportBuilder" 
   && FocusType == WT_Button
Then
	If FocusName == "Add Selected" Then 
		return "add items selected in the clinical documents screen" 
	ElIf FocusName == "Add All" Then 
		return "Add all items in the clinical documents screen."
	EndIf
elif AppClass == "TListForm" 
  && GetWindowName( AppWindow ) == "Field Selector" Then
	if FocusType  == WT_EDIT Then
		return "enter a search term and then select from the below list." 
	EndIf
EndIf

if InClinicalTabs () Then
	if  FocusType  == WT_BUTTON Then 
		if FocusName == "Report Builder" Then 
			return "Use the Select " + ClinicalSectionName() + " before this button."
		ElIf FocusName == "100 Documents" Then 
			Return "Adjust parameters for selected section" 
		EndIf
	ElIf FocusType  == WT_EXTENDEDSELECT_LISTBOX Then 
		Return "Select items with the space bar." 
	EndIf
EndIf

if GetWindowClass(FocusWindow) == WC_DateTimePicker  Then
	return"Type alt-downarrow to open the calendar"
EndIf

EndFunction


Int Function CAPRI__SpeakSelectedCheckBox ()
var
	int cid,
	object o = getFocusObject(cid),
int fLeft, int fTop, int  fRight, int fBottom,
	int iMSAATop, int iMSAAHeight, int iMSAALeft, int iMSAAWidth 
if o then

	o.accLocation(intRef(iMSAALeft ), intRef(iMSAATop), intRef(iMSAAWidth), intRef(iMSAAHeight), cID)
if !iMSAALeft && !iMSAATop && !iMSAAWidth && !iMSAAHeight then
	return  False 
EndIf
	fTop = iMSAAtop + 1 
	fBottom = fTop + iMSAAHeight 
fLeft = iMSAALeft + 1 
fRight = fLeft + iMSAAWidth  
Say(GetTextInRect (fLeft, fTop, fRight , fBottom, 0, IgnoreColor, IgnoreColor, true ), OT_SELECTED)
return true 
endIf
EndFunction
Script VirtualizeWindow()
var
	string AppClass = GetWindowClass (GetAppMainWindow (GetCurrentWindow ()))

if  StringCompare("capri", gs_DelphiApplicationName , True) == 0   
   && AppClass == "TfrmAddress" 
then
	CAPRI__VirtualizeAddressPanel()
else 
	PerformScript VirtualizeWindow()
EndIf
EndScript 


void function CAPRI__VirtualizeAddressPanel ()
var
	int iTempAddressStart,
	handle TestingWindow ,
	handle AppWindow = GetAppMainWindow (GetFocus()),
	string sKey, string sValue, 
	collection AddressInformation 

AddressInformation = new collection 
SaveCursor()  InvisibleCursor() SaveCursor() 
	SetRestriction (RestrictAppWindow)
MoveToWindow (AppWindow )
JAWSTopOfFile ()
FindString (AppWindow, "Temporary", S_TOP, S_RESTRICTED , False )
iTempAddressStart = GetCursorCol ( )
RestoreCursor ()RestoreCursor ()
TestingWindow  = GetFirstChild(AppWindow )
while TestingWindow  
	sValue = GetWindowText (TestingWindow , False)

	if sValue Then
		if GetWindowLeft (TestingWindow ) > iTempAddressStart  Then 
			sKey = "t" + GetWindowName (TestingWindow )
		Else
			sKey = "permanent" + GetWindowName (TestingWindow )
		EndIf
		AddressInformation[ sKey ] = sValue 
	EndIf
	TestingWindow  = GetNextWindow (TestingWindow )
EndWhile 

; Now print out address information.
UserBufferDeactivate ()
UserBufferClear ()
SayMessage(OT_USER_BUFFER, "Address Verification\n\nVerify the below address information.\n")
if CollectionItemExists (AddressInformation, "tStreet:") Then
	SayMessage (OT_USER_BUFFER, "\nTemporary Address:" )
	SayMessage(OT_USER_BUFFER, AddressInformation["tStreet:"] )
	if CollectionItemExists (AddressInformation, "permanentAddress (line 2):")
		SayMessage(OT_USER_BUFFER, AddressInformation["tAddress (line 2):"])
	EndIf

	if CollectionItemExists (AddressInformation, "tAddress (line 3):")
		SayMessage(OT_USER_BUFFER, AddressInformation["tAddress (line 3):"])
	EndIf
	UserBufferAddFormattedMessage ( "%1, %2  %3 %4 \nCounty: %5", "%1, %2  %3 %4 \nCounty: %5", AddressInformation["tCity:"], AddressInformation["tState:"], AddressInformation["tZip+4:"], AddressInformation["tCountry:"], AddressInformation["tCounty:"])
	UserBufferAddFormattedMessage ( "Primary Phone: %1	Office Phone: %2", "Primary Phone: %1	Office Phone: %2",AddressInformation["tPhone:"], AddressInformation["tOffice Phone:" ] )
EndIf
SayMessage(OT_USER_BUFFER, "Permanent Adrss:")
SayMessage(OT_USER_BUFFER, AddressInformation["permanentAddress (line 1):"])
if CollectionItemExists (AddressInformation, "permanentAddress (line 2):")
	SayMessage(OT_USER_BUFFER, AddressInformation["permanentAddress (line 2):"])
EndIf

if CollectionItemExists (AddressInformation, "permanentAddress (line 3):")
	SayMessage(OT_USER_BUFFER, AddressInformation["permanentAddress (line 3):"])
EndIf
UserBufferAddFormattedMessage ( "%1, %2  %3 %4 \nCounty: %5", "%1, %2  %3 %4 \nCounty: %5", AddressInformation["permanentCity:"], AddressInformation["permanentState:"], AddressInformation["permanentZip+4:"], AddressInformation["permanentCountry:"], AddressInformation["permanentCounty:"])
UserBufferAddFormattedMessage ( "Primary Phone: %1	Office Phone: %2", "Primary Phone: %1	Office Phone: %2",AddressInformation["permanentPhone:"], AddressInformation["permanentOffice Phone:" ] )
UserBufferAddText ("\nAddress information is correct", "Capri_ClickAddressButton(1)", "Continue to form", "Courier", 15)
UserBufferAddText ("Edit address information", "Capri_ClickAddressButton(2)", "Edit address", "Courier", 15)
UserBufferActivate (False)
JAWSPageUp () SayLine()

EndFunction

const CAPRI_AddressButtons = "OK|Edit Address Now"
 

Void Function Capri_ClickAddressButton (int iButton)
UserBufferDeactivate ()
var string sObjectName = StringSegment (CAPRI_AddressButtons, "|", iButton)
var handle myButton = FindWindow (GetAppMainWindow (GetFocus()), cscNull, sObjectName )
if myButton Then 
	SetFocus (myButton)
	delay(1)
	TypeKey ("space")
EndIf
EndFunction

Void Function ActiveItemChangedEvent (handle curHwnd, int curObjectId, int curChildId,
	handle prevHwnd, int prevObjectId, int prevChildId)
if FixCheckBoxList() Then
	 if CAPRI__SpeakSelectedCheckBox () Then 
		return 
	EndIf
Endif
va508jaws::ActiveItemChangedEvent (curHwnd, curObjectId, curChildId,prevHwnd, prevObjectId, prevChildId)
EndFunction 

Void Function activsayObjectActiveItem(int speakPositionInfo)
if GetWindowClass (GetFocus())== "TCheckListBox" Then 
	CAPRI__SpeakSelectedCheckBox ()
	if speakPositionInfo Then 
		Say(PositionInGroup(),  OT_POSITION)
	EndIf
Else 
va508jaws::sayObjectActiveItem(speakPositionInfo)
EndIf
EndFunction 





Object Function oMSAAGetSelectedTab (int ByRef cID)
var
	object o,
	int count,
	string wcTTabControl  = "TTabPage"

	let o = getFocusObject(cid) ; full child control
	let count = 1
	while o && count < 10 && o.accRole(CHILDID_SELF ) != role_system_pagetablist
		let o = o.accParent() ; window
		let count = count + 1
	EndWhile

	if o && o.accRole(childId_self) == role_system_pagetablist then
		let count = 1
		while count <= o.accChildCount()
			if o.accState(count) & state_system_selected then
	cID = count 
				return o
			endif
			let count = count + 1
		EndWhile
	endif
EndFunction

String Function GetDialogPageName()
var 
	object o,
	int cID ,
	String sTabName 

o = oMSAAGetSelectedTab (cID)
sTabName = o.AccName(cID) 
sTabName =  stringChopLeft (sTabName, 		StringContains (sTabName, ")"))
sTabName = StringTrimLeadingBlanks (sTabName)
return sTabName 
EndFunction

Void Function MSAASelectTab(int direction)
var
	object o,
	int cid

o = oMSAAGetSelectedTab( cID) 
if Cid  == 0 then 
	beep()
	return 
EndIf 
if direction == 1 then
	if o.accRole(cid+1) != role_system_pagetab then
		let cid = 0
	endif ; role page tab
	o.accSelect(selflag_takeSelection| SELFLAG_TAKEFOCUS ,cid+1)
elif direction == 0 then
	if cid > 1 then
		o.accSelect(selflag_takeSelection | SELFLAG_TAKEFOCUS ,cid-1)
	ElIf o.accRole( o.accChildCount()) == role_system_pagetab then
		o.accSelect(selflag_takeSelection| SELFLAG_TAKEFOCUS,o.accChildCount())
	else ; just sit on first tab
	beep()
		return 
	endif
Endif ; direction
EndFunction

int Function IsMultiPageDialog ()
if GetDialogPageName()
	Return True
Else
	Return False
EndIf
EndFunction 



script NextDocumentWindow ()
MSAASelectTab	(1)
EndScript

script PreviousDocumentWindow ()
MSAASelectTab	(0 )
EndScript




Script AltX ()
var
	handle hFocusWindow  = GetFocus(),
	handle hAppMainWindow = GetAppMainWindow (hFocusWindow),
	string sAppMainClass = GetWindowClass (hAppMainWindow )

TypeCurrentScriptKey ()
if sAppMainClass ==  "TfrmViewExam"  Then 
	delay(1)
	var 
	handle hPanel = FindWindow(FindWindow(hAppMainWindow,  "TPanel", cscNull ), "TPanel", cscNull ),
handle hListExams = FindWindow (hPanel, "TCheckListBox", cscNull)
	if hListExams Then 
		SetFocus( hListExams)
	EndIf
EndIf
;TCheckListBox
;



EndScript







Messages
@CAPRI__ClinicalTabs 
1)  Notes
2)  Discharge Summaries
3)  Consults
4)  Vitals
5)  Meds
6)  Labs
7)  Imaging
8)  Diet
9)  Nutritional Assessment
U)  Order Summary
Y)  Procedures
Z)  Problem List
@@

@CAPRI__ClinicalSection 
Notes
Discharge Summaries
Consults
Vitals
Medications
Lab reports
Imaging
Dietetics Profile
Nutritional Assessments
Orders
Procedures
Problems
@@
EndMessages 
	
Int Function InClinicalTabs ()
var
	handle hAppMainWindow = GetAppMainWindow (GetFocus ()),
	string sAppMainClass =  GetWindowClass (hAppMainWindow )

if sAppMainClass ==  "TfrmMain"  Then
	return   StringSegmentIndex (CAPRI__ClinicalTabs , "\n", GetDialogPageName (), True)
EndIf

return False 
EndFunction



string Function ClinicalSectionName ()
var int iPosition = InClinicalTabs ()

if iPosition Then 
	return StringSegment (CAPRI__ClinicalSection , "\n", iPosition)
EndIf

return cscNUll 
EndFunction






script tab()
var
	handle hFocusWindow = GetFocus(),
handle hAppWindow = GetAppMainWindow (hFocusWindow),
string sAppClass = GetWindowClass (hAppWindow)

If sAppClass == "TPNCSForm" Then
	var 
		handle  hPreviewWindow = FindWindow (hAppWindow , "TTabControl"),
		handle hYesWindow  =  FindWindow (hAppWindow , cscNull , "Yes - Save and Exit")
	if IsWindowVisible (GetParent (hYesWindow)) Then 
		If GetNextWindow (hYesWindow) == hFocusWindow  Then 
			SetFocus( hYesWindow ) 
		else ; if hYesWindow == hFocusWindow Then 
			SetFocus (GetNextWindow (hYesWindow))
		EndIf
		Return
	Elif hPreviewWindow  && GetWindowName( hPreviewWindow) == "FULL REPORT" Then		
 		if    GetParent (hFocusWindow) == hPreviewWindow  Then 
			SetFocus( FindWindow (GetParent (hPreviewWindow), cscNull, "OK"))
			return
		EndIf
	else
	EndIf
EndIf
PerformScript Tab()
EndScript

script ShiftTab()
var
	handle hFocusWindow = GetFocus(),
handle hAppWindow = GetAppMainWindow (hFocusWindow),
string sAppClass = GetWindowClass (hAppWindow)

If sAppClass == "TPNCSForm" Then
	var 
		handle  hPreviewWindow = FindWindow (hAppWindow , "TTabControl"),
		handle hYesWindow  =  FindWindow (hAppWindow , cscNull , "Yes - Save and Exit")

	if IsWindowVisible (GetParent (hYesWindow)) Then 
		Say(GetWindowTextEx (GetParent (hYesWindow), False, True , False ) , OT_SCREEN_MESSAGE)
		If GetNextWindow (hYesWindow) == hFocusWindow  Then 
			SetFocus( hYesWindow ) 
			SetFocus (GetNextWindow (hYesWindow))
		EndIf
		Return
	Elif hPreviewWindow  && GetWindowName( hPreviewWindow) == "FULL REPORT" Then		
 		if    GetWindowName(hFocusWindow) == "OK" Then 
			SetFocus( GetFirstChild (hPreviewWindow ))
			return
		EndIf
	else
	EndIf
EndIf
PerformScript ShiftTab()
EndScript

int function  ShouldShowUnknownFunctionCallStack()
	return false 
EndFunction 

int function GetMenuMode()
var 
	String sAppMainClass = GetWindowClass (GetAppMainWindow (GetFocus())),
	String sFocusClass = GetWindowClass (GetFocus())

if ( sAppMainClass == "Tfrmreports" 
     || sAppMainClass == "Tfrmreports" )
   && (sFocusClass == "TGroupButton" 
     || sFocusClass == "TCheckBox" 
     || sFocusClass == "TRadioButton" )
Then

	return 0 
ElIf sAppMainClass == "TMessageForm" 
   || sAppMainClass == "#32770"
   || sAppMainClass == "TfrmSpecialReport"
   || sAppMainClass == "TfrmROFinder"
   || sAppMainClass == "TfrmVREReportSetup"
   || sAppMainClass == "TfrmForwardingAddress"
   || sAppMainClass == "TfrmVlerGetExams"
Then 
	Return 0 
EndIF

return GetMenuMode()
EndFunction


void function SayLine()
if FixCheckBoxList() Then
	 if CAPRI__SpeakSelectedCheckBox () Then 
		return 
	EndIf
Endif
va508jaws::SayLine()
EndFunction



int Function FixCheckBoxList ()
if GetWindowClass (GetFocus()) == "TCheckListBox" then
	if GetWindowClass(GetAppMainWindow(GetFocus( ))) == "TfrmSpecialReport"  Then 
		return true
	EndIf
EndIF

return false 
EndFunction


int function ProcessSpaceBarKeyPressed(int nKey, string strKeyName, int nIsBrailleKey, int nIsScriptKey)
If !KeyIsSpacebar(nKey,strKeyName,nIsBrailleKey) then
	return false
EndIf

if FixCheckBoxList() Then 
	Delay (1)
	SaveCursor() InvisibleCursor() SaveCursor()
	RouteInvisibleToPc ()
	PriorChunk ()
	SayChunk ()
	RestoreCursor ()RestoreCursor ()
	return true 
Else
return ProcessSpaceBarKeyPressed(nKey, strKeyName, nIsBrailleKey, nIsScriptKey)
EndIf
EndFunction 

Void Function SiteCodeInitialize ()
Delphi_AppDefined  = new collection 

EndFunction

void function SiteCodeClear()
CollectionRemoveAll (Delphi_AppDefined  )
EndFunction 


int function GetWindowSubtypeCode (handle hWnd)
var
	int iSubType = va508jaws::GetWindowSubtypeCode (hWnd),
	int iParentSubType = va508jaws::GetWindowSubtypeCode (GetParent (hWnd) )

if iSubType == WT_EDIT 
   && iParentSubType == WT_EDITCOMBO 
Then
	iSubType = WT_EDITCOMBO
EndIF
return iSubType
EndFunction 

globals   
	string gsVA508cacheCaption, 
	string gsVA508cacheValue, 
	string gsVA508CacheControlType,
	int giVA508cacheDataStatus 

void Function SpeakPatientListUpdates ()
Say("Patient List updated press tab to select a patient", OT_JAWS_MESSAGE)
EndFunction


Script OpenListBox()
TypeCurrentScriptKey ()
delay(1)
SayLine()
SayMessage(OT_HELP, "Use arrows to pick a date", "Navigate with arrows")
EndScript



Void Function VA508CacheUpdate (handle hwnd)
var 
	string WindowClass,
	int iFieldPosition,
	int iValuePosition ,
	int iMaxLength 

; In CAPRI, the 	 fields with class TVA508StaticText set the Caption / Name to a single space and put extra data into the value.
; so if Name is lenght 1 and Class is appropriate and Value contains ReadOnly then put everything before ReadOnly into Name and put everything after ReadOnly into Value 


; First call the standard framework then correct for the label we have issues with.

VA508CacheUpdate (hwnd)


; Was a Caption / Name length 1? and we have a cached value 
if giVA508cacheDataStatus & VA508_QueryCode_Caption 
  && giVA508cacheDataStatus & VA508_QueryCode_Value 
  && StringLength (gsVA508cacheCaption ) == 1 
then
	iMaxLength = StringLength(gsVA508CacheValue )
	iFieldPosition = StringContains(gsVA508cacheValue , VA508FrameWork_ReadOnlyLabel) -1 
	iValuePosition = StringContains(gsVA508cacheValue , VA508FrameWork_ValueLabel ) + StringLength( VA508FrameWork_ValueLabel) -1 

	if iFieldPosition  > 0 Then 
		gsVA508cacheCaption  = SubString (gsVA508CacheValue, 1, iFieldPosition)
		gsVA508CacheValue = SubString (gsVA508CacheValue, iValuePosition, iMaxLength)
		gsVA508CacheControlType=  VA508FrameWork_ReadOnlyLabel 
	elif StringContains(gsVA508cacheValue , VA508FrameWork_DisabledLabel) Then 
		iFieldPosition = StringContains(gsVA508cacheValue , VA508FrameWork_DisabledLabel)  - 1 
		iValuePosition = iFieldPosition + StringLength(VA508FrameWork_DisabledLabel)
		gsVA508cacheCaption  = SubString (gsVA508CacheValue, 1, iFieldPosition)
		gsVA508CacheValue = SubString (gsVA508CacheValue, iValuePosition, iMaxLength)
		gsVA508CacheControlType=  VA508FrameWork_DisabledLabel 
	EndIf

	if StringLength (gsVA508CacheValue ) <  1 
  || StringCompare ( gsVA508CacheValue, cscSpace ) == 0 
 Then  
		gsVA508CacheValue = msg_BlankField
	EndIf
EndIf
EndFunction