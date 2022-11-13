;#pragma StringComparison partial 
; $Id: va508jaws.jss,v 1.172 2014/01/12 13:48:38 dlee Exp $
/* Data Communication for this framework is provided through hidden windows
Written for the VA508 Script project
Original scripts by: JMerrill
Updated: June, 2007 - JAvila and DLee, for Freedom Scientific
Updated: October, 2007 by DLee
Updated: July, 2021 by Chris Bell
JAWS 7.1 and 8.0
The top line of this file should be preserved for CVS purposes
The framework requires the jaws.SR and VA508JAWSDispatcher.exe files in addition to the FSAPI 1.0 com library in the shared folder of the JAWS program
*/

; Default includes from JAWS
include "HjConst.jsh"
include "hjglobal.jsh"
include "common.jsm"

; constants are differentiated by underscores between words
Const
; Not used by any code in this file, but read by JAWS.SR from this file to determine if the script file should be updated with a newer version
	VA508_Script_Version = 15,

; Maximum property cache lifespan in milliseconds
	VA508_Cache_Mils = 2000,  ; 2 seconds

; iCacheHandling values for VA508getComponentProp()
; See that function for more about these constants.
	VA508_Cache_Use = 0,  ; Use the cache but don't force it to update
	VA508_Cache_Update = 1,  ; Update the cache, then use it
	VA508_Cache_Skip = 2,  ; Don't touch the cache at all, just pull straight from Framework

; Constant used to indicate that the framework sent a null property value explicitly.
; When a cache property value is actually null, it means the framework did not send a value for that property at all.
; This means either there was an error (VA508_QueryCode_Error dataStatus bit set)
; or the property has no value in the framework (appropriate VA508_QueryCode_* dataStatus bit for the property NOT set).
	VA508_Cache_Explicit_Null = " ",

; Used by AutoStartEvent only.to get the msg id used to communicate with sendMessage
	VA508_Reg_Msg_ID = "VA 508 / Freedom Scientific - JAWS Communication Message ID",

; Used only by VA508EnsureInitialized
	VA508_DLL_Dispatcher_Hidden_Window_Class = "TfrmVA508JawsDispatcherHiddenWindow",
	VA508_DLL_Hidden_Main_Window_Class = "TfrmVA508HiddenJawsMainWindow",
	VA508_Message_Get_DLL_With_Focus = 1,

; Not used by any code.
	VA508_DLL_Dispatcher_Hidden_Window_Title = "VA 508 JAWS Dispatcher Window",
	VA508_DLL_Hidden_Data_Window_Class = "TfrmVA508HiddenJawsDataWindow",

; General data format = prefix : next window handle : data
; See VA508GetApplicationData() for more info on the data structure.
	VA508_DLL_Data_Window_Delim = ":",

; Next two used only by VA508GetStringValue.
	VA508_DLL_Data_Offset = "=",
	VA508_DLL_Data_Length = ",",

; Names of data structure elements, found in the data structure itself (gsVA508varData).
; Pass these to VA508GetStringValue() to get values by name.
	VA508_FieldName_Caption = "Caption",
	VA508_FieldName_Value = "Value",
	VA508_FieldName_Control_Type = "ControlType",
	VA508_FieldName_State = "State",
	VA508_FieldName_Instructions = "Instructions",
	VA508_FieldName_Item_Instructions = "ItemInstructions",
	VA508_FieldName_Data_Status = "DataStatus",

; Query bits to retrieve each of the above items except Data_Status.
; These are passed to VA508GetApplicationData().
; iDataStatus comes back with the same flags to indicate what was actually retrieved.
	VA508_QueryCode_Caption = 0x00000001L,
	VA508_QueryCode_Value = 0x00000002L,
	VA508_QueryCode_Control_Type = 0x00000004L,
	VA508_QueryCode_State = 0x00000008L,
	VA508_QueryCode_Instructions = 0x00000010L, ;16
	VA508_QueryCode_Item_Instructions = 0x00000020L, ;32
	VA508_QueryCode_Data = 0x00000040L, ;64

; Query code to retrieve all of the above at once.
	VA508_QueryCode_All = 0x0000007FL, ; 127

; Extra bits that can be sent to the VA508ChangeEvent
	VA508_Data_Change_Event = 0x00001000L, ; 4096
	VA508_DataItem_Change_Event = 0x00002000L, ;8192

; If this comes back from a query, it means the sent hwnd was not in the framework's list of windows
; This can happen if
;	- The hwnd is to another application, or
;	- The hwnd is to a system-generated window, such as SysHeader32 under a ListView or Edit under an edit combo.
	VA508_QueryCode_Error = 0x00800000L,

; Keystroke constants
	Key_F4 = "F4",  ; Key to close an open combo box.
	ksRightArrow = "RightArrow",
	ksLeftArrow = "LeftArrow",

; Window class constants
	wcComboLBox = "ComboLBox", ; Window class of a normal combo box's list window.
	wcTMaskEdit = "TMaskEdit",
	wcTTabControl = "TTabControl",
	wcTTabSheet = "TTabSheet",
	wcTUpDown = "TUpDown",
	wcTTreeView = "TTreeView",
	wcTStringGrid = "TStringGrid",
	wcTComboBox = "TComboBox",
	wcEdit = "Edit",
	WC_CAPTION_LISTBOX = "TCaptionListBox",

; ControlTypes
	ctSpinBox = "SpinBox",

; Window Styles
	window_style_tabsWithButtons = 0x100,

; MSAA constans
	ChildID_Self = 0,
	SELFLAG_TAKEFOCUS = 0x1L,
	SELFLAG_TAKESELECTION = 0x2L,
	ROLE_SYSTEM_PAGETABLIST = 0x3cL,
	ROLE_SYSTEM_PAGETAB = 0x25L,
	ROLE_SYSTEM_LIST = 0x21L,
	STATE_SYSTEM_SELECTED = 0x00000002L,
	STATE_SYSTEM_FOCUSED = 0x00000004L,
	STATE_SYSTEM_FOCUSABLE = 0x00100000L,
	STATE_SYSTEM_SELECTABLE = 0x00200000L,
	STATE_SYSTEM_CHECKED = 0x00000010L,

; Messages
	msgPage = "Page",
	msgNotSelected = "not selected",
	msgDataOnly = "data only",
	msgRowAndColumnNumbers = "row and column numbers",
	msgRowAndColumnHeaders = "row and column headers",
	msgRowAndColumnHeadersAndNumbers = "row and column headers and numbers",
	msgScriptSetName = "V A 508 Scripts",
	msgSpace = " ",
	msgLoadingSettings = "loading settings",
	msgPersonalSettingsSaved = "personal settings saved",
	msgPersonalSettingsNotSaved = "personal settings not saved",
	msgChecked = "checked",
	msgNull = "",
	msgBlank = "blank",
	msgLevel = "Level ",
	msgColumn = "Column",
	msgRow = "Row",

; Personalized settings
	hKey_GridSpeechMode = "GridSpeechMode", ; ini key name
	hKey_GridBrailleMode = "GridBrailleMode", ; ini key name
	jvToggleGridSpeechMode="|ToggleGridSpeechMode:Grid Speech",	 ; function name then shown description
	jvToggleGridBrailleMode="|ToggleGridBrailleMode:Grid Braille",	 ; function name then shown description
	Section_ControlTypes = "ControlTypes",
	Section_BrailleClasses = "BrailleClasses",

; General Constants
	string_delim = "|",
	gi_mag_draw_highlights = 1, 	; for magic
	LB_COUNT = 0x018B,
	LB_getcursel = 0x0188,
	TVGN_CARET = 0x0009,
	TVGN_NEXT = 0x0001,
	TVGN_PREVIOUS = 0x0002,
	TVM_EDITLABELA = 0x110E,
	TVM_EDITLABELW = 0x1141,
	TVM_GETNEXTITEM = 0x110A

Messages
@msgPosMOfN
%1 of %2
@@
@msgItemCount1
%1 item
@@
@msgItemCount2
%1 items
@@
EndMessages


; All global variables start with "g" and a lowercase letter indicating their type string, int, handle or boolean
Globals
; True for debugging enabled (see autoStartEvent)
	int inDebugging,

; True for framework debugging
	int fwDebug,

; Property cache
; GetTickCount() value at the time of the last full cache update
	int giVA508cacheTick,

; Handle of window to which the cache now applies
	handle ghVA508cacheHwnd,

; Properties cached
	string gsVA508cacheCaption,
	string gsVA508cacheValue,
	string gsVA508cacheControlType,
	string gsVA508cacheState,
	string gsVA508cacheInstructions,
	string gsVA508cacheItemInstructions,
	int giVA508cacheDataStatus,

; Cache of grid data for string grids
; "valid" is not passed by the DLL; it is set (along with all the rest of these) by VA508GetGridData().
; The rest are passed in a ^-delimited string from the DLL in the Value field.
	string gsVA508cacheGridColHdr, 
	int giVA508cacheGridColNum, 
	int giVA508cacheGridColCnt,
	string gsVA508cacheGridRowHdr, 
	int giVA508cacheGridRowNum, 
	int giVA508cacheGridRowCnt,
	string gsVA508cacheGridCellVal, 
	int giVA508cacheGridCellNum, 
	int giVA508cacheGridCellCnt,

; Handle of the window of the DLL for the application in focus.
	handle ghVA508DLLWindow,

; ID of registered VA508_Reg_Msg_ID Windows message.
; Sent to the dispatch window and DLL-specific windows, obtained by RegisterWindowMessage
	int giVA508messageID,

; True if the app-specific DLL link has not yet been established.
; This link is remade every time a VA508 app receives focus.
	int gbVA508needToLinkToDLL,
	string gsVA508TutorMessage,  ; saves a global tutor message variable that will be announced by JAWS when getCustomTutorMessage is automatically called if the user settings ask for it
	int giVA508TutorReturnValue,
	handle ghVA508tutorWindow, ; handle of the window where there was a custom tutor message
	string gsVA508dataWindowTitle,
	int giVA508dataWindowTitleLen,

; Data field names and values for the last-queried control.
	string gsVA508varData,
	string gsVA508data,

; A flag to suppress speech at certain times.
	int gbVA508suppressEcho,
	int glbSuppressFocusChange,

; Custom braille types
	string glbsTable,
	string glbsTable2,

; Custom control types for speech
	string glbsTable3,
	string glbsTable4,

; personalized settings for how row and column headers are displayed in a table
	int giGridSpeechMode,
	int giGridBrailleMode,
	int giAppHasBeenLoaded, ; keeps track of if the app has been loaded before so we don't need to pull the ini settings for personalized grids

; Globals for ChangeEvent speaking
	int giSuppressCaption,  ; use custom caption when event occurs but focus did not move
	int giSuppressControlType,
	int giSuppressState,
	int giSuppressValue,
	int giSuppressInstructions,
	int giSuppressItemInstructions,
	int giDidFocusChange, 	; did the focus event fire after the changeEvent did?  If so, scrap speaking anything becuase handleCustomWindows will announce it
	handle ghFromChangeEvent,  ; handle of window that last called changeEvent
	int lt_suppressHighlight,
	int giCancelEvent,
	int giSpokeCellUnit,
	int giDebugMode

;**************************************************************
; Conversion functionality (cast of any type to any other type within reason)
;**************************************************************
Variant Function VA508Cast (variant Value)
	return Value
EndFunction

;**************************************************************
; Dodge for a stringSegmentCount anomaly in at least JAWS 8:
; If the string ends with the delimiter, the final null segment is not counted.
; This causes it to be counted.
;**************************************************************
int function VA508stringSegmentCount(string s, string sDelim)
	var
		int segcount

	let segcount = stringSegmentCount(s, sDelim)

	if stringRight(s, 1) == sDelim then
		let segcount = segcount +1
	endIf

	return segcount

endFunction

;**************************************************************
; Classification of list types:  lb=listbox, lv=listview, lx=extended-select, lm=multiselect.
;**************************************************************
string function getListType(int typeCode)

	if typeCode == WT_ListView || typeCode == WT_LISTVIEWITEM then
		return "lv"

	elif typeCode == WT_ListBox || typeCode == wt_listboxItem then
		return "lb"

	elif typeCode == WT_MultiSelect_ListBox then
		return "lm"

	elif typeCode == WT_ExtendedSelect_ListBox then
		return "lx"

	endIf

	; Return non-null, or things like stringContains("lb lm lx", getListType(typeCode)) will return 1!
	return "--"

endFunction

;**************************************************************
; Detection of special focus situations.
;**************************************************************
int function isSpecialFocus(int includeAllDialogs)

	if menusActive() || userBufferIsActive() || inHJDialog() then
		return True
	endIf

	if includeAllDialogs && dialogActive() then
		return True
	endIf

	if (getWindowClass(getFocus()) == "#32771" && getObjectTypeCode(getFocus()) == WT_ListBoxItem) then
		; This is the Alt+Tab window.
		return True
	endIf

	return False

endFunction

globals
	object goCountDict,
	string gsCountList

;**************************************************************
; Reports execution counts of functions/code blocks.
;**************************************************************
Void function watchCount(string sKey)
	var
		int resetting,
		string sKey1

	if !inDebugging then
		return
	endIf

	let resetting = False

	if sKey == "*" then
		let sKey = stringChopLeft(sKey, 1)
		let resetting = True
	endIf

	if !sKey || resetting then
		; Internal or external call to speak and reset counts.
		var int i
		let i = 1
		while i
			let sKey1 = stringSegment(gsCountList, "|", i+1)
			if sKey1 then
				if goCountDict(sKey1) then
					sayMessage(OT_Message, formatString("%1 %2", sKey1, goCountDict(sKey1)))
					dictSet(goCountDict, sKey1, 0)
				endIf
				let i = i +1
			else
				let i = 0  ; exits loop
			endIf

		endWhile

		if !sKey then
			return
		endIf

	endIf

	; External call to count.
	if stringLeft(gsCountList, 1) != "|" then
		let goCountDict = createObjectEx("Scripting.Dictionary", False)
		let gsCountList = "|"
	endIf

	if !goCountDict then
		return
	endIf

	dictDelta(goCountDict, sKey, 1)

	if !stringContains(gsCountList, "|"+sKey+"|") then
		let gsCountList = gsCountList +sKey +"|"
	endIf

	scheduleFunction("watchCount", 8)

endFunction

;***************************************************************
; Sends Message to hidden window, and retrieves result from window caption.
; Has build in retry attempts and timeout
;***************************************************************
int Function VA508SendMessage(Handle Window, int wParam, int lParam)
	var
		int Result,
		int working,
		int pendingCount,
		int pendingMax,
		int retryCount,
		int idx1,
		int idx2,
		int doSend,
		string header1,
		string header2,
		string value

	;Say ("VA508 JAWS Send Message", OT_JAWS_MESSAGE)
	
	let Result = 0
	if (Window != 0) then
		let working = TRUE
		let retryCount = 2 ; was 3
		let pendingMax = 3 ; was 4
		let doSend = TRUE

		let header1 = GetWindowName(Window)
		while working
			if doSend then
				; This condition should avoid "Unknown function call to VA508GetApplicationData" messages on application shutdown.
				; The idea is to stop trying to send messages when the application closes.
				; Otherwise, this function delays even the AutoFinishEvent for several seconds.
				; GetAppFileName includes an extension and getActiveConfiguration does not,
				; but == stops at the end of the shortest string, so it works.
				; [DGL, 2007-05-24]        
                if getAppFileName() == getActiveConfiguration() && !InHJDialog () then
					SendMessage(Window, giVA508messageID, wParam, lParam)
				else
					return 0
				endIf
				let doSend = FALSE
				let pendingCount = pendingMax
			endIf ; doSend

			let header2 = GetWindowName(Window)
			;	messageBox(getWindowName(StringToInt(StringSegment(header2, VA508_DLL_Data_Window_Delim, 3)))) ; ":"
			if StringCompare(header1, header2, TRUE) == 0 then ; they are equal
;				beep()
				Delay(1,true)
				let pendingCount = pendingCount - 1
				if pendingCount < 1 then
					let retryCount = retryCount - 1
					if retryCount < 1 then
						let working = FALSE
					else
						let doSend = TRUE
					endIf
				endIf
			else ; headers are not equal so we have a new one
				let working = false
				let value = StringSegment(header2, VA508_DLL_Data_Window_Delim, 3) ; ":"
				let Result = StringToInt(value)
			endIf
		endWhile
	endIf ; is window handle valid

	return Result

EndFunction


;**************************************************************
; Uses MSAA to return a window name up to 4 K long even though getWindowName stops at 255 characters.
; MSAA is only used when it seems necessary; getWindowName is used otherwise for efficiency.
;**************************************************************
string Function Get4KName(handle hWnd)
	var
		string wName,
		string mName,
		int cutoffLen

	; Window names can reach 255 characters, but we choose an earlier cutoff for safety.
	let cutoffLen = 240

	let wName = GetWindowName(HWnd)

	if stringLength(wName) > cutoffLen || (hasTitleBar(hwnd) && stringLength(wName) == 0) then
		var
			int childID,
			object obj
		let obj = GetObjectFromEvent(HWnd, -4, 0, childID)  ; -4 = ObjID_Client
		let mName = obj.accName(0)

		if stringLength(mName) > cutoffLen then
			return mName
		endIf

	endIf

	return wName

EndFunction


;***********************************************************************
; Gets a value by its name from the data structure saved in gsVA508varData and gsVA508data.
;***********************************************************************
String Function VA508GetStringValue(string VarName)
	var
		string Search,
		string Result,
		int idx,
		int idx2,
		int idx3,
		int max,
		int offset,
		int len

	let Result = ""
	let Search = VA508_DLL_Data_Window_Delim + VarName + VA508_DLL_Data_Offset ; something like ":Caption="
	let idx = StringContains(gsVA508varData, Search) ; returns starting character position

	if idx > 0 then ; we found a match
		let max = idx + 50 ; just in case of bad data - prevents infinite loop lock up
		let idx = idx + StringLength(Search)
		let idx2 = idx+1

		while (SubString(gsVA508varData, idx2, 1) != VA508_DLL_Data_Length) && (idx2 < max)
			let idx2 = idx2 + 1
		endWhile

		let idx3 = idx2 + 1

		while (SubString(gsVA508varData, idx3, 1) != VA508_DLL_Data_Window_Delim) && (idx2 < max)
			let idx3 = idx3 + 1
		endWhile

		let offset = StringToInt(SubString(gsVA508varData, idx, idx2-idx)) + 1
		let len = StringToInt(SubString(gsVA508varData, idx2+1, idx3-idx2-1))

		if len > 0 then
			let Result = SubString(gsVA508data, offset, len)
		EndIf

	EndIf

	return Result

EndFunction

;***********************************************************************
; Retrieves one or more data items, as indicated by iQueryCode, for the given window.
; Data ends up in gsVA508varData (names/indices) and gsVA508data (values).
; hwnd is the handle of the window for which info is wanted
; iQueryCode indicates what is wanted (VA508_QueryCode_* constants)
;
;gsVA508dataWindowTitle = caption:
; caption:[next window handle]:varlen:var=offset,length:var=offset,len:data
; varlen = from first to last :
;***********************************************************************
globals 
	string gsVA508GetAppDataDebugBuf

Void Function VA508GetApplicationData(handle hwnd, int iQueryCode)
	watchCount("*appData")

	var
		handle hWindow,
		handle nullHandle,
		string sCaption,
		string sSubTitle,
		int idx,
		int len,
		string sData

	let gsVA508varData = ""
	let gsVA508data = ""
	let gsVA508GetAppDataDebugBuf = ""
	let sData= ""

	if fwDebug then
		let gsVA508GetAppDataDebugBuf = gsVA508GetAppDataDebugBuf + formatString("VA508GetApplicationData execution info:\13\10Invocation: handle %1, iQueryCode %2", intToString(hwnd), intToString(iQueryCode))
	endIf

	; hWindow becomes handle of data window received from dll window
	let hWindow = VA508Cast(VA508SendMessage(ghVA508DLLWindow, hwnd, iQueryCode))
	if fwDebug then
		let gsVA508GetAppDataDebugBuf = gsVA508GetAppDataDebugBuf +formatString("\13\10VA508SendMessage(%1, %2) returns %3", intToString(ghVA508DLLWindow), intToString(iQueryCode), intToString(hWindow))
	endIf

	; if more than 4k or 255char windows are chained together and window contains next windows hwnd like a linked list

	while (hWindow != 0) && (hWindow != 1)

		let sCaption= Get4KName(hWindow) ; uses MSAA to get the name of the dll Window
		if fwDebug then
			let gsVA508GetAppDataDebugBuf = gsVA508GetAppDataDebugBuf + formatString("\13\10sCaption from window %1: '%2'", intToString(hWindow), sCaption)
		endIf

		let hWindow = nullHandle

		; Data window title and len are set in Initialization function
		let sSubTitle = SubString(sCaption,1,giVA508dataWindowTitleLen)
		if fwDebug then
			let gsVA508GetAppDataDebugBuf = gsVA508GetAppDataDebugBuf + formatString("\13\10sSubtitle from caption: '%1'", sSubtitle)
		endIf

		if StringCompare(sSubTitle, gsVA508dataWindowTitle , TRUE) == 0 then ; just checking to make sure we have proper window
			if fwDebug then
				let gsVA508GetAppDataDebugBuf = gsVA508GetAppDataDebugBuf + "\13\10Data window title recognized"
			endIf

			let sCaption= StringChopLeft(sCaption, giVA508dataWindowTitleLen) ; get everything after the title
			let idx = StringContains(sCaption, VA508_DLL_Data_Window_Delim) ; ":"

			if idx > 1 then ; see if we have a handle embedded in caption
				let hWindow = VA508Cast(StringToInt(SubString(sCaption, 1, idx-1)))
				if fwDebug then
					let gsVA508GetAppDataDebugBuf = gsVA508GetAppDataDebugBuf +formatString("\13\10Next window: %1", intToString(hWindow))
				endIf
			else
				if fwDebug then
					let gsVA508GetAppDataDebugBuf = gsVA508GetAppDataDebugBuf + "\13\10No next window"
				endIf
			endIf

			let sCaption = StringChopLeft(sCaption, idx) ; pull out everything after handle

			if fwDebug then
				let gsVA508GetAppDataDebugBuf = gsVA508GetAppDataDebugBuf +formatString("\13\10Caption text saved (idx %1): '%2'", intToString(idx), sCaption)
			endIf

			let sData=sData+sCaption ; save what we pulled out into sData variable

		endIf
	EndWhile

	if StringLength(sData) > 0 then  ; we have valid data
		let idx = StringContains(sData, VA508_DLL_Data_Window_Delim) ; ":"
		if idx > 1 then ; get data
			let len = StringToInt(SubString(sData, 1, idx-1)) ; length is first delimiter, length is length of vars, var length/pos, and data
			let sData = StringChopLeft(sData,idx-1) ; get data
			let gsVA508varData = StringLeft(sData,len) ; variable data
			; MessageBox(gsVA508varData) ; contains position and length of each property :Caption=0,2:
			let gsVA508data = StringChopLeft(sData,len) ; actual data
			;	messageBox(gsva508data)
		endIf
	else
		if fwDebug then
			let gsVA508GetAppDataDebugBuf = gsVA508GetAppDataDebugBuf + "\13\10No data to return."
		endIf
	EndIf
EndFunction

;***********************************************************************
; this function is called from AutoStartEvent and AutoFinishEvent to reset all global variables for privacy reasons
;***********************************************************************
Void Function VA508ResetGlobals ()
	let ghVA508DLLWindow = VA508cast(0)
	let gsVA508dataWindowTitle = ""
	let gsVA508tutorMessage = ""
	let ghVA508tutorWindow = VA508cast(0)
	let giVA508TutorReturnValue = 0
	; Clear the cache of framework data.
	VA508cacheUpdate(0)
	let	gbVA508suppressEcho = FALSE

endFunction

;***********************************************************************
Void Function VA508EnsureInitialized ()
var
		int InstanceID,
		handle DispatchWindow,
		string className

	if gbVA508needToLinkToDLL then	; CHECK FOR DLL LINK
		let DispatchWindow = FindTopLevelWindow(VA508_DLL_Dispatcher_Hidden_Window_Class, "")
		if DispatchWindow then	; CHECK FOR DISPATCH WINDOW
			let ghVA508DLLWindow = VA508Cast(VA508SendMessage(DispatchWindow, VA508_Message_Get_DLL_With_Focus, 0))
;			sayInteger(ghVA508DLLWindow)
			if (ghVA508DLLWindow != 0) && (ghVA508DLLWindow != 1) then ; CHECK FOR VALID DLL WINDOW HANDLE
				let className = GetWindowClass(ghVA508DLLWindow)
				If StringCompare(className, VA508_DLL_Hidden_Main_Window_Class, TRUE) == 0 then ; dll window and main window are one in the same
				; the dll window contains the name of the data window
					let gsVA508dataWindowTitle = Get4KName(ghVA508DLLWindow)
					let gsVA508dataWindowTitle = StringSegment(gsVA508dataWindowTitle, VA508_DLL_Data_Window_Delim, 1) + VA508_DLL_Data_Window_Delim
					let giVA508dataWindowTitleLen = StringLength(gsVA508dataWindowTitle)
					; sayString("linked")
					let gbVA508needToLinkToDLL = FALSE
				endIf	; check CLASS name
			endIf ; check DLL window handle

		endIf ; check for existence of DISPATCH window
	endIf ; only call if we need to link2DLL

	if gbVA508needToLinkToDLL then	; if not linked then clear and try again
		let ghVA508DLLWindow = VA508cast(0)
		; keep this delay at 1 or first field may not function on startup
		ScheduleFunction("VA508EnsureInitialized",1)
	EndIf

EndFunction

;***********************************************************************
; Get a property value from the cache.
; iQueryCode:  The VA508_QueryCode_* constant indicating the wanted property.
; sVal:  On return, the property value or null.
; Returns 1 if the wanted property is found, 0 if not, and -1 on error.
; On a return of 1, sVal is the property value; otherwise, it is null.
;***********************************************************************
int function VA508cacheGetVal(int iQueryCode, string byRef sVal)
	let sVal = ""

	if giVA508cacheDataStatus & VA508_QueryCode_Error then
		return -1

	elif !(giVA508cacheDataStatus & iQueryCode) then
		return 0

	elif iQueryCode == VA508_QueryCode_Caption then
		let sVal = gsVA508cacheCaption

	elif iQueryCode == VA508_QueryCode_Value then
		let sVal = gsVA508cacheValue

	elif iQueryCode == VA508_QueryCode_Control_Type then
		let sVal = gsVA508cacheControlType

	elif iQueryCode == VA508_QueryCode_State then
		let sVal = gsVA508cacheState

	elif iQueryCode == VA508_QueryCode_Instructions then
		let sVal = gsVA508cacheInstructions

	elif iQueryCode == VA508_QueryCode_Item_Instructions then
		let sVal = gsVA508cacheItemInstructions

	else
		; This should not happen in production and indicates a programming error.
		beep()
		return -1
	endIf

	return 1

endFunction

;***********************************************************************
; Update the property cache.  Called only by VA508getComponentProp() and VA508 ResetGlobals
; hwnd:  The window handle of interest, or 0 to clear the cache.
;***********************************************************************
Void Function VA508CacheUpdate (handle hwnd)
	var
		int iQueryCode,
		int iStatus,
		string sVal

	let iQueryCode = 0

	if hwnd then
		let iQueryCode = VA508_QueryCode_All
	endIf

	; Clear the cache first.
	let giVA508cacheTick = 0
	let ghVA508cacheHwnd = VA508cast(0)
	let gsVA508cacheCaption = ""
	let gsVA508cacheValue = ""
	let gsVA508cacheControlType = ""
	let gsVA508cacheState = ""
	let gsVA508cacheInstructions = ""
	let gsVA508cacheItemInstructions = ""
	let giVA508cacheDataStatus = 0

	; Clear grid data also.
	VA508getGridData("",0)

	; If we're just clearing the cache, we're done.
	if iQueryCode == 0 then
		return
	endIf

	; Replace the just-cleared cache from the framework.
	; VA508getApplicationData should have been called by the caller already.
	let iStatus = StringToInt(VA508GetStringValue(VA508_FieldName_Data_Status))
	let giVA508cacheTick = getTickCount()
	let ghVA508cacheHwnd = hwnd
	let giVA508cacheDataStatus = iStatus

	if giVA508cacheDataStatus & VA508_QueryCode_Caption then
		let gsVA508cacheCaption = VA508GetStringValue(VA508_FieldName_Caption)
	endIf

	if giVA508cacheDataStatus & VA508_QueryCode_Value then
		let gsVA508cacheValue = VA508GetStringValue(VA508_FieldName_Value)
		; Grid data shows up in Value, so only try to get it if there's something to get.
		VA508getGridData(gsVA508cacheValue, 1)
	endIf

	if giVA508cacheDataStatus & VA508_QueryCode_Control_Type then
		let gsVA508cacheControlType = VA508GetStringValue(VA508_FieldName_Control_Type)
	endIf

	if giVA508cacheDataStatus & VA508_QueryCode_State then
		let gsVA508cacheState = VA508GetStringValue(VA508_FieldName_State)
	endIf

	if giVA508cacheDataStatus & VA508_QueryCode_Instructions then
		let gsVA508cacheInstructions = VA508GetStringValue(VA508_FieldName_Instructions)
	endIf

	if giVA508cacheDataStatus & VA508_QueryCode_Item_Instructions then
		let gsVA508cacheItemInstructions = VA508GetStringValue(VA508_FieldName_Item_Instructions)
	endIf

EndFunction

;***********************************************************************
; Return the framework field name corresponding to the given query code.
;***********************************************************************
string function VA508FieldNameFromQueryCode(int iQueryCode)
	var
		string sFieldName

	if iQueryCode == VA508_QueryCode_Caption then
		let sFieldName = VA508_FieldName_Caption

	elif iQueryCode == VA508_QueryCode_Value then
		let sFieldName = VA508_FieldName_Value

	elif iQueryCode == VA508_QueryCode_Control_Type then
		let sFieldName = VA508_FieldName_Control_Type

	elif iQueryCode == VA508_QueryCode_State then
		let sFieldName = VA508_FieldName_State

	elif iQueryCode == VA508_QueryCode_Instructions then
		let sFieldName = VA508_FieldName_Instructions

	elif iQueryCode == VA508_QueryCode_Item_Instructions then
		let sFieldName = VA508_FieldName_Item_Instructions

	else
		; This should not happen in production and indicates a programming error.
		beep()
		return 0
	endIf

	return sFieldName

endFunction

;***********************************************************************
; Return the query code corresponding to the given framework field name.
;***********************************************************************
int function VA508QueryCodeFromFieldName(string sFieldName)
	var
		int iQueryCode

	if sFieldName == VA508_FieldName_Caption then
		let iQueryCode = VA508_QueryCode_Caption

	elif sFieldName == VA508_FieldName_Value then
		let iQueryCode = VA508_QueryCode_Value

	elif sFieldName == VA508_FieldName_Control_Type then
		let iQueryCode = VA508_QueryCode_Control_Type

	elif sFieldName == VA508_FieldName_State then
		let iQueryCode = VA508_QueryCode_State

	elif sFieldName == VA508_FieldName_Instructions then
		let iQueryCode = VA508_QueryCode_Instructions

	elif sFieldName == VA508_FieldName_Item_Instructions then
		let iQueryCode = VA508_QueryCode_Item_Instructions

	else
		; This should not happen in production and indicates a programming error.
		beep()
		return 0
	endIf

	return iQueryCode

endFunction

;***********************************************************************
; Gets a single component property immediately.
; hwnd:  Window about which to ask.
; xProp:  VA508_QueryCode_* or VA508_FieldName_* constant indicating or naming the wanted property.
; iCacheHandling:  A VA508_Cache_* constant determining how to handle the property cache on this call.
; sVal:  On return, the value of the property if found, otherwise undefined.
; Returns 1 if the property has a custom value, 0 if not, and -1 on error.
; iCacheHandling constant usage in detail:
;	VA508_Cache_Use:
;		If hwnd is the window cached already and the cache is not too old, pull the property from the cache and don't ask the framework.
;		If hwnd is not the cached window or the cache is too old, rebuild the cache completely while getting the property.
;	VA508_Cache_Update:  Rebuild the cache unconditionally from the framework while getting the property.
;	VA508_Cache_Skip:
;		Get the property directly from the framework.
;		If hwnd is the cached window, update the cache entry for the property in the process.
; Called by VA508SayData for Speech and controlPropGet for Braille
;***********************************************************************
int Function VA508GetComponentProp(handle hWnd, variant xProp, int iCacheHandling, string byRef sVal)
	Var
		string sProp,
		int iQueryCode,
		Int iDataStatus

; ***** Code from here to the next short set of stars can be called 40 or more times per second by Braille code.
; For efficiency, frequent callers should pass a query code, not a field name here.

	if stringToInt(xProp) then
		let iQueryCode = VA508cast(xProp)
		let sProp = ""  ; Don't figure that one out unless we need it.
	else
		let sProp = VA508cast(xProp)
		let iQueryCode = VA508QueryCodeFromFieldName(sProp)
	endIf

; Optimize by far the most frequent call case.
	let sVal = ""

	if iCacheHandling == VA508_Cache_Use && hwnd == ghVA508cacheHwnd && getTickCount() - giVA508cacheTick < VA508_Cache_Mils then
		; Use the cached value and don't call on the framework at all this time.
		watchCount("cacheUse")
		return VA508cacheGetVal(iQueryCode, sVal)

	; ***** End of 40-time-per-second code block.
	elif iCacheHandling == VA508_Cache_Skip then
		; Always go to the framework for these.  We'll need the field name for that.
		if !sProp then
			let sProp = VA508FieldNameFromQueryCode(iQueryCode)
		endIf
		watchCount("cacheSkip")
		VA508GetApplicationData(hWnd, iQueryCode)

		let iDataStatus = StringToInt(VA508GetStringValue(VA508_FieldName_Data_Status))  ;"DataStatus"

		if iDataStatus & iQueryCode then
			let sVal = VA508GetStringValue(sProp)
			if hwnd == ghVA508cacheHwnd then
				; A trick to re-use VA508cacheSetVals for this.
				; Makes sure the dataStatus bit is set and sets the property value.
				VA508cacheSetVals(iQueryCode, iDataStatus, sVal, sVal, sVal, sVal, sVal, sVal)
			endIf
			return 1

		elif iDataStatus & VA508_QueryCode_Error then
			; Should not happen, but force the next call to update the cache if it does.
			if hwnd == ghVA508cacheHwnd then
				let giVA508cacheTick = 0
			endIf
			return -1

		else
			; Property not handled by the framework.
			if hwnd == ghVA508cacheHwnd then
				if giVA508cacheDataStatus & iQueryCode then
					; Property removed from framework (probably never happens).
					; Remove the status bit from the cache as well.
					; let giVA508cacheDataStatus = giVA508cacheDataStatus -iQueryCode
				endIf
			endIf
			return 0

		endIf
	endIf

; All remaining use cases are rebuild-cache cases.

	; Clear the cache first.
	VA508cacheUpdate(0)

	; Get all properties from the framework.
	watchCount("cacheUpdate")
	VA508GetApplicationData(hWnd, VA508_QueryCode_All)

	; Update all properties in the cache.
	VA508cacheUpdate(hwnd)

	; Return the property sought in the first place.
	return VA508cacheGetVal(iQueryCode, sVal)

EndFunction

;**********************************************************************
; Update the property cache when the framework sends an event indicating property changes.
; Called only from VA508ChangeEvent and getComponentProp with skip
; should update only items that have changed and getcomponentProp
;**********************************************************************
Void Function VA508CacheSetVals (handle hwnd, int iDataStatus, string sCaption, string sValue, string sControlType, string sState, string sInstructions, string sItemInstructions)
	; Don't mess with the cache if it doesn't apply to this window.
	if hwnd != ghVA508cacheHwnd then
		return
	endIf

	; This is in case the framework suddenly decides to include a property not previously included by tossing it at us in an event call.
	; This will probably never happen, but this line shouldn't hurt anything anyway.
	let giVA508cacheDataStatus = giVA508cacheDataStatus | iDataStatus

	; Hand out property changes based on what we're told changed.
	if iDataStatus & VA508_QueryCode_Caption then
		let gsVA508cacheCaption = sCaption
	endIf

	if iDataStatus & VA508_QueryCode_Value then
		let gsVA508cacheValue = sValue
	endIf

	if iDataStatus & VA508_QueryCode_Control_Type then
		let gsVA508cacheControlType = sControlType
	endIf

	if iDataStatus & VA508_QueryCode_State then
		let gsVA508cacheState = sState
	endIf

	if iDataStatus & VA508_QueryCode_Instructions then
		let gsVA508cacheInstructions = sInstructions
	endIf

	if iDataStatus & VA508_QueryCode_Item_Instructions then
		let gsVA508cacheItemInstructions = sItemInstructions
	endIf

EndFunction

;**********************************************************************
; Fills the VA508cacheGrid* globals.
; called by va508ChacheUpdate
; fromWhere:  Hwnd of window to query (presumably a grid), or Value field already obtained from such a window.
; Returns True if this is a grid and False otherwise.
; Side effects:  Modifies all g?VA508cacheGrid* globals.
; TODO:  If a row or column header or cell value contains a ^, False will be returned and no grid data will be set.
;**********************************************************************
int Function VA508GetGridData (variant fromWhere, int dontCheck)
	watchCount("grid")
	var
		int iResult,
		string sVal

	; It's not a grid until we say it's a grid...
	let gsVA508cacheGridColHdr = ""
	let giVA508cacheGridColNum = 0
	let giVA508cacheGridColCnt = 0
	let gsVA508cacheGridRowHdr = ""
	let giVA508cacheGridRowNum = 0
	let giVA508cacheGridRowCnt = 0
	let giVA508cacheGridCellNum = 0
	let giVA508cacheGridCellCnt = 0
	let gsVA508cacheGridCellVal = ""
	if !fromWhere then
		return False
	endIf

	if stringToInt(fromWhere) && !stringContains(fromWhere, "^") && !dontCheck then
	; A window handle.
	; sayString("grid check")
		let iResult = VA508GetComponentProp(fromWhere, VA508_FieldName_Value, VA508_Cache_Skip, sVal)
		If iResult < 1 then
			return False
		endIf
	else
		; A value property already obtained from somewhere.
		let sVal = fromWhere
	endIf

	if VA508stringSegmentCount(sVal, "^") != 9 then
		; Got a value, but it's not grid data.
		return False
	endIf

	; sayString("valid grid found by ggd")
	let gsVA508cacheGridColHdr = stringSegment(sVal, "^", 1)
	let giVA508cacheGridColNum = stringToInt(stringSegment(sVal, "^", 2))
	let giVA508cacheGridColCnt = stringToInt(stringSegment(sVal, "^", 3))
	let gsVA508cacheGridRowHdr = stringSegment(sVal, "^", 4)
	let giVA508cacheGridRowNum = stringToInt(stringSegment(sVal, "^", 5))
	let giVA508cacheGridRowCnt = stringToInt(stringSegment(sVal, "^", 6))

	; The cell value is at the end of the string from the DLL.
	let giVA508cacheGridCellNum = stringToInt(stringSegment(sVal, "^", 7))
	let giVA508cacheGridCellCnt = stringToInt(stringSegment(sVal, "^", 8))
	let gsVA508cacheGridCellVal = stringSegment(sVal, "^", 9)

	return True

EndFunction

;***********************************************************************
; this function is called from handleCustomWindows and should get called whenever tab, insert+tab are pressed.  It also may get called by sayLine and Braille functions
; Returns False if we should use default and True if this function announced the control and we don't need to do anything else
;***********************************************************************
int Function VA508SayData(handle hwnd)
	var
		int iResult,
		int iResultInstructions,
		int iResultValue,
		int iResultState,
		int bUseDefault,
		string Caption,
		string Value,
		string ControlType,
		string State,
		string Instructions,
		string ItemInstructions,
		string Text,
		handle tempHandle,
		int TypeCode,
		int subTypeCode,
		string StaticText,
		string position,
		string Grouping,
		string GroupingType,
		int special,
		string newControlType,
		int iDataStatus

	; clear global variables, this should happen every time tab is pressed
	let gsVA508tutorMessage = ""
	let ghVA508tutorWindow = tempHandle  ; which is now null
	let giVA508TutorReturnValue = 0

	let special = FALSE

	if gbVA508needToLinkToDLL then
		return False
	endIf
	; the assumption is made that if the return value is 0 or less, that "" will be returned and not garbage

	let iResult = VA508getComponentProp(hwnd, VA508_QueryCode_Caption, VA508_Cache_Update, Caption)

	if iResult >= 0 then  ; Framework has nothing for this window, -1 means error, if 0 this passes
		let bUseDefault = (iResult <= 0)
		let iResult = VA508getComponentProp(hwnd, VA508_QueryCode_Value, VA508_Cache_Use, Value)
		let iResultValue = iResult
		let bUseDefault = bUseDefault && (iResult <= 0)
		let iResult = VA508getComponentProp(hwnd, VA508_QueryCode_Control_Type, VA508_Cache_Use, ControlType)
		let bUseDefault = bUseDefault && (iResult <= 0)
		let iResult = VA508getComponentProp(hwnd, VA508_QueryCode_State, VA508_Cache_Use, State)
		let iResultState = iResult
		let bUseDefault = bUseDefault && (iResult <= 0)
		let iResultInstructions = VA508getComponentProp(hwnd, VA508_QueryCode_Instructions, VA508_Cache_Use, Instructions)
		let iResult = VA508getComponentProp(hwnd, VA508_QueryCode_Item_Instructions, VA508_Cache_Use, ItemInstructions)
	else
		let bUseDefault = TRUE ; because caption had error we can assume we should use default unless a special case below is needed
	endif

	let TypeCode = GetWindowTypeCode(hWnd)
	if !typeCode then
		let typeCode = getObjectSubTypeCode()
	Endif

	if isSpinBox(hwnd) then ; standard delphi spinboxes are not announced correctly
		if VA508getComponentProp(hwnd, VA508_QueryCode_Control_Type, VA508_Cache_Use, ControlType) < 1 then
			let ControlType = ctSpinBox
			let special = true
		Endif ; check for presence of custom controlType

	elif TypeCode == wt_listbox || TypeCode == wt_listView then ; position in group is wrong for standard delphi list boxes
		let special = true

	elif getWindowClass(hwnd) == wcTTreeView then ; to remove unchecked from value
			let special = true

	elif getWindowClass(hwnd) == "TORComboEdit" || getWindowClass(hwnd) == "TORComboBox" then
		let special = True

	endif ; check for spinBox

	if bUseDefault == FALSE || special then
		if VA508getGridData(getFocus(),0) > 0 && isPcCursor() && !userBufferIsActive() then
			let value = getCurrentCellHeadersData()
		elif typeCode == wt_listBox || typecode == wt_listView then 
			if iResultValue < 1 then ; the framework either return nothing or an error
				let value = getAccName()
			Endif
			if iResultState < 1 then ; the framework either return nothing or an error
				if !getObjectState() then
					let state = getAccState()
				endif
			Endif
		elif typeCode == wt_treeview then
			if iResultValue < 1 then
				let value = getAccValue()
			Endif
			; add this state even if another state exists and no matter where the value came from
			let state = tvGetFocusItemExpandStateString (hwnd) + " " + state
		Endif ; end check for special control types

		if ControlType && ControlTypeFound(ControlType, newControlType) then
			let ControlType = newControlType
		EndIf ; end custom spoken control type
		sayControlEx(hwnd, Caption, ControlType, State, Grouping, GroupingType, Value, PositionInGroup(), StaticText)

	else ; use default
		return False

	EndIf ; use default?

	;Say(ItemInstructions,OT_TUTOR)  ; should always say item instructions if they exist?
	; See JAWS 8's tutorialHelp.jss::sayTutorialHelp() for the rationale for using this SayUsingVoice call.
	; TODO: This may speak in a few undesirable places depending on user settings.
	var
		int ot

	let ot = OT_Tutor

	if !shouldItemSpeak(OT_Tutor) && False then
		; TODO: "False" above should be "code invoked from script", but I see no way to establish that.
		let ot = OT_Line
	endIf

	sayUsingVoice(VCTX_Message, itemInstructions, ot)

	If iResultInstructions > 0 then
		let ghVA508tutorWindow = hWnd
		let gsVA508tutorMessage = Instructions
		let giVA508TutorReturnValue = iResultInstructions
	EndIf ; instructions

	return True

EndFunction

;***************************************************************************
; updated to announce custom information for listview/listbox type controls
; spoken order for listbox and listview = value or name, state, then position
; the name of the control is not announced here for listboxes
; customType = caption,type,value,state
; checkbox = caption,type,state
; radioButton = caption, type,state
; button = caption,type, state (use default)
; link = caption, type, state
; comboBox = value, position
; edit = name, type, value, state (use default)
; spinner = name, type, value, state (use default)
; multiline edit = current line 
; page tab = all page tabs
; list item = state, value, position
; tree item = value, state, position, 
; listbox/listview = not possible
; treeview = not possible
; dialog = not possible
; grid = caption, type, value, state
; menu = use default
; slider = caption, type, value
; progressBar = caption, type, value
; groupbox = not possible
;***************************************************************************
Script SayLine()
	var
		int theTypeCode,
		string strVal,
		string strState,
		handle hwnd,
		string strControlType

	;sayString("sayline")
	if !isPcCursor() || isSpecialFocus(False) then
		performScript sayLine()
		return
	Endif

/* Commented out...
	; Update the cache
	VA508GetComponentProp(hwnd, VA508_FieldName_Value, VA508_Cache_Update, strVal)

	let hwnd = getFocus()
	Let TheTypeCode = GetWindowSubTypeCode (GetFocus ())
	If !TheTypeCode then  ; if any unknown typeCode then get the sub type code from MSAA
		Let TheTypeCode = GetObjectSubTypeCode ()
	EndIf

	; if we have a custom control type, then we really don't know how much or little information should be spoken, so say it all!
	if theTypeCode == wt_unknown && VA508GetComponentProp(hwnd, VA508_FieldName_Control_Type, VA508_Cache_Use, strControlType) >  0 then ; make assumption that anything that has a value has child objects, doesn't cover case where it isn't a list but has a custom state but not a custom value
		VA508SayData(hwnd)
		return
	Endif

	; this only applies to list boxes
	if stringContains("lb lm lx", getListType(theTypeCode))  ; doesn't apply to listview, should pick up tree with custom value
		&& !VA508GetGridData(hwnd) then ; grids should be handled differently though, so if value but grid don't use this code, use code in sayLine function
		; BOTH value and state are custom
		if VA508GetComponentProp(hwnd, VA508_FieldName_Value, VA508_Cache_Use, strVal) >  0 &&
		VA508GetComponentProp(hwnd, VA508_FieldName_State, VA508_Cache_Use, strState) >  0 then
			SayMessage (OT_LINE, strVal)
			SayMessage (OT_item_state, strState)  ; custom expanded/collapsed states should be handled by the framework
			SayMessage (OT_POSITION, PositionInGroup ())
			return
		Endif
		; only VALUE is custom, use state from jaws
		if VA508GetComponentProp(hwnd, VA508_FieldName_Value, VA508_Cache_Use, strVal) >  0 &&
		VA508GetComponentProp(hwnd, VA508_FieldName_State, VA508_Cache_Use, strState) < 1 then
			SayMessage (OT_line, strVal)
			If (theTypeCode == WT_TREEVIEW || theTypecode == WT_TREEVIEWITEM) then
				SayTVFocusItemExpandState (hwnd)  ; getObjectState() doesn't return correct info for tree views
			Else
				SayMessage  (ot_item_state,getObjectState())
			endif
			SayMessage (OT_POSITION, PositionInGroup ())
			return
		Endif
		; only STATE is custom - current case for checklist box
		if VA508GetComponentProp(hwnd, VA508_FieldName_State, VA508_Cache_Use, strState) > 0 &&
		VA508GetComponentProp(hwnd, VA508_FieldName_Value, VA508_Cache_Use, strVal) <  1 then
			Let strVal = GetAccName()
			SayMessage (OT_line, strVal)
			SayMessage (OT_item_State, strState)
			SayMessage (OT_POSITION, PositionInGroup ())
			return
		EndIf  ; only state
	Endif ; are we on a listbox or a custom control that has it's value set

	; another special case for listboxes
	; no custom state or value found but need to use msaa for listboxes
	; for standard listboxes that JAWS has trouble announcing not selected for
	if stringContains("lb lm lx", getListType(theTypeCode)) then  ; doesn't apply to listview, only listbox, should pick up tree with custom value
		say(getAccState(),ot_item_state)
		say(getAccName(),ot_selected_item) ; uses msaa for list item, falls back on getObjectValue()
		SayMessage (OT_POSITION, PositionInGroup ())
		return
	Endif
*/
	; performScript sayLine()  ; this function in default is likely to call the function sayLine below

	sayLine()

EndScript

;*****************************************************************************************
String Function tvGetFocusItemExpandStateString (handle hwnd)
	if tvGetFocusItemExpandState (hwnd) then
		return "opened"
	else
		return "closed"
	Endif
EndFunction

;*****************************************************************************************
; also called by control+home and control+end in grid
; called by script sayLine for edits and buttons when sayLine command is pressed
void Function SayLine(int iDrawHighlights)
	var
		int typeCode,
		int subTypeCode,
		handle hwnd,
		string strState,
		string strCaption,
		string strValue,
		string strControlType,
		string strPosition,
		int special

	;sayString("sayline")
	if !isPCCursor() || isSpecialFocus(False)  then
		return sayLine(iDrawHighlights)
	endIf

	let hwnd = getFocus()
	let typeCode = getWindowTypeCode(hwnd)

	; sayInteger(typeCode)
	let subTypeCode = getWindowSubTypeCode(hwnd)

	if stringContains("lb lm lx", getListType(TypeCode)) then 
		let special = true ; for listbox without customizations we need this for msaa names to be announced

	elif getObjectTypeCode() == wt_listboxItem then ; for list view
		let special = true ; for listview without customizations we need this for position in group to be spoken
		
	elif getObjectTypeCode() == WT_LISTVIEWITEM then ; for list view
		let special = true ; for listview without customizations we need this for position in group to be spoken

	elif (getWindowClass(hwnd) == "TORComboEdit" || getWindowClass(hwnd) == "TORComboBox") && positionInGroup() then
		let special = True

	EndIf

	; simple call to update the cache
	VA508GetComponentProp(getFocus(), VA508_FieldName_Control_Type, VA508_Cache_Update, strControlType)

	; added jda 4-22-08 to make standard edit combos announce blank when empty and nothing else, also prevents speaking of caption on standard edit combos when sayLine is pressed
	if getWindowClass(hwnd) == wcEdit && getWindowClass(getParent(hwnd)) == wcTComboBox then
		let typeCode = wt_editCombo
	endif

; combo boxes should not have their name spoken
	if (typeCode == wt_edit && subTypeCode != wt_multiline_edit) ; also covers edit comboes, and spinboxes because they have a typeCode of edit 
		|| typeCode == wt_button then ; also handles edit & edit comboes

		; sayInteger(subTypeCode)
		if VA508SayData(hwnd) then
			return
		else			; else fall through to regular sayline
			sayLine(iDrawHighlights)	 ; calls internal sayline function as default has no sayline function
			return
		endIf

	; if we have a custom control type, then we really don't know how much or little information should be spoken, so say it all!
	elif TypeCode == wt_unknown && VA508GetComponentProp(hwnd, VA508_FieldName_Control_Type, VA508_Cache_Use, strControlType) >  0 then ; make assumption that anything that has a value has child objects, doesn't cover case where it isn't a list but has a custom state but not a custom value
		VA508SayData(hwnd)
		return

	elif VA508getGridData(getFocus(),0) > 0 then  ; GRID
		say(getCurrentCellHeadersData(),ot_line)
		return

	elif VA508GetComponentProp(getFocus(), VA508_FieldName_Caption, VA508_Cache_Use, strCaption) < 1 &&
		VA508GetComponentProp(getFocus(), VA508_FieldName_Control_Type, VA508_Cache_Use, strControlType) < 1 &&
		VA508GetComponentProp(getFocus(), VA508_FieldName_Value, VA508_Cache_Use, strValue) < 1 &&
		VA508GetComponentProp(getFocus(), VA508_FieldName_State, VA508_Cache_Use, strState) < 1  &&
		!special then
		sayLine(iDrawHighlights)	 ; calls internal sayline function as default has no sayline function
		return

	elif subTypeCode == wt_multiline_Edit then
		sayLine(iDrawHighlights)	 ; calls internal sayline function as default has no sayline function
		return

	endIf

	; now we have at least one custom property and it is stored in our local variable or we are special

	let strPosition = PositionInGroup()
	if getWindowClass(hwnd) == "TORComboEdit" then
		let typeCode = WT_EditCombo
	elif getWindowClass(hwnd) == "TORComboBox" then
		let typeCode = WT_ComboBox
	endIf

	; now let's set everything from default if there wasn't a custom framework property
	if VA508GetComponentProp(getFocus(), VA508_FieldName_Caption, VA508_Cache_Use, strCaption) < 1 then
		;let strCaption = getAccName()
		let strCaption = getObjectName() ; don't need to worry about child objects
	Endif

	if VA508GetComponentProp(getFocus(), VA508_FieldName_Control_Type, VA508_Cache_Use, strControlType) < 1 then
		let strControlType = getObjectType()
	Endif

	if VA508GetComponentProp(getFocus(), VA508_FieldName_Value, VA508_Cache_Use, strValue) < 1 then
		let strValue = getAccValue()
	Endif

	if VA508GetComponentProp(getFocus(), VA508_FieldName_State, VA508_Cache_Use, strState) < 1 then
		let strState = getObjectState()
	Endif

	if typeCode == wt_treeview then
		let strState = tvGetFocusItemExpandStateString (hwnd) + " " + strState
	Endif

; caption is typically not announced here, so no custom caption is announced unless we think we are on a control with no children and no value
; ControlType is typically not announced here, so no custom control type is announced
; controls with custom values should be handled by sayLine script and thus are not handled here
; instructions and item instructions are typically not announced when sayLine is pressed that is why custom ones are not set here

	if typeCode == wt_checkbox || typeCode == wt_radiobutton then
		say(strCaption,ot_control_name)
		say(strControlType,ot_control_type)
		say(strState,ot_item_state)

	Elif typeCode == wt_comboBox || typeCode == WT_EditCombo then
		if !strValue then
			let strValue = " "
		endIf
		say(strValue,ot_line)
		; jda added 4-22-08 if statement to prevent position in group from being announced when tor edit combo box is empty
		if !(strValue == " " && stringLength(strValue)) then
			say(strPosition,ot_position)
		Endif

	Elif typeCode == wt_slider || typeCode == wt_progressBar then
		say(strCaption,ot_control_name)
		say(strControlType,ot_control_type)
		say(strValue,ot_selected_item)

	elif stringContains("lb lm lx", getListType(typeCode)) then
		say(strValue,ot_selected_item)
		say(strState,ot_item_state)
		say(strPosition,ot_position)

	elif typecode == wt_listview then ; for list views
		say(strValue,ot_selected_item)
		say(strState,ot_item_state)
		say(strPosition,ot_position)

	elif typeCode == wt_treeview then
		; no level needs to be announced here
		say(strValue,ot_selected_item)
		say(strState,ot_item_state)
		say(strPosition,ot_position)	

	Else ; for anything else speak everything
		if VA508SayData(hwnd) then
			return
		else
			sayLine(iDrawHighlights)	; this should never get called, here as backup!
		endif

	Endif

EndFunction

;****************************************
; this function should replace sayObjectTypeAndText
int Function HandleCustomWindows(handle hwnd)
	;Say ("VA 508 JAWS Handle Custom Windows", OT_JAWS_MESSAGE)
	


	;sayString (getWindowClass (hwnd))

	if getWindowClass (hwnd) == wcTComboBox && getWindowClass (getFirstChild (hwnd)) == wcEdit then
		return True
	endif

	if glbSuppressFocusChange then
		let glbSuppressFocusChange = FALSE
		return true
	endif

	; don't waste our time processing
	if hWnd == 0 || getWindowClass(hWnd) == "Invalid" then
		return true
	Endif

	if VA508SayData (hwnd) then
		;sayString("custom")
		return true  ; customizations were announced
	else
		; sayString("use default")
		return false ; we are using default code in JAWS
	endIf

EndFunction

; called first
;************************************************************************
void Function	SayTutorialHelp (int iSubType, int flag)
	If (GetCurrentWindow() == ghVA508tutorWindow) then
		If giVA508TutorReturnValue > 0 then  ; if we have a global tutor message announce it
			if gsVa508tutorMessage == " " && stringLength(gsva508tutorMessage) == 1 then
				return ; prevents blank from being announced when custom tutor message is " "
			endif
		Endif
	Endif
	SayTutorialHelp (iSubType, flag)
EndFunction

;***********************************************************************
; JAWS internally calls this function... in JAWS 7.1 and higher
;***********************************************************************
String Function GetCustomTutorMessage ()
	If (GetCurrentWindow() == ghVA508tutorWindow) then
		If giVA508TutorReturnValue > 0 then  ; if we have a global tutor message announce it
			Return gsVA508tutorMessage ; if " " then JAWS may announce blank when insert+tab is pressed
		EndIf
	EndIf
	Return getCustomTutorMessage()
EndFunction

;**********************************************************************
; initialize variables and tell code to perform handshake with dispatch window.  Reset any globals in case other application left them in memory which should not be the case though
;**********************************************************************
Void Function AutoStartEvent ()
	let inDebugging = False
	let fwDebug = False
	let giDebugMode = 0

	if fileExists(getJAWSSettingsDirectory() +"\\debug.ini") then
		let inDebugging = True
	endIf

	if fileExists(getJAWSSettingsDirectory() +"\\fwdebug.ini") then
		let fwDebug = True
	endIf
		let gbVA508needToLinkToDLL = TRUE
		let giVA508messageID = RegisterWindowMessage(VA508_Reg_Msg_ID)
		VA508ResetGlobals()
		VA508EnsureInitialized()
		UpdateBrailleClasses()
		UpdateControlTypes()

	If !giAppHasBeenLoaded Then
		LoadPersonalSettings()	; load personal settings
		let giAppHasBeenLoaded=TRUE
	EndIf

EndFunction

;**********************************************************************
; called when user alt+tabs out of application, resets all global variables and forces the application to re-initialize next time.  This helps to ensure patient privacy as no patient data is left in hidden windows.
;**********************************************************************
Void Function AutoFinishEvent()
	var
		object nullObject

		let gbVA508needToLinkToDLL = TRUE
		VA508ResetGlobals()
EndFunction

;**********************************************************************
; called when JAWSKey+Q is pressed to announce script file settings that are loaded and module file name that is being used
;**********************************************************************
Script ScriptFileName()

	; one line of debugging code
	if !giDebugMode then
		ScriptAndAppNames(msgScriptSetName)

	Else ; start debug mode
		DisplayDebugData()

	Endif ; end debug mode

EndScript

;***********************************************************************
; added by jda 4-22-08
;***********************************************************************
void Function DisplayDebugData()
	var
		string strCaption,
		string strControlType,
		string strValue,
		string strState,
		string strInstructions,
		string strItemInstructions,
		int iCustomInfo,
		string sDisplayText
	
	let sDisplayText = ""
	if VA508GetComponentProp(getFocus(), VA508_FieldName_Caption, VA508_Cache_Use, strCaption) > 0 then
		;say("has custom name",ot_jaws_message)
		;say(strCaption,ot_control_name)
		let sDisplayText = sDisplayText + "Custom Name: " + strCaption + "\n"
		let iCustomInfo = true
	Endif

	if VA508GetComponentProp(getFocus(), VA508_FieldName_Control_Type, VA508_Cache_Use, strControlType) > 0 then
		;say("has custom type",ot_jaws_message)
		;say(strControlType,ot_control_type)
		let sDisplayText = sDisplayText + "Custom Type: " + strControlType + "\n"
		let iCustomInfo = true
	Endif

	if VA508GetComponentProp(getFocus(), VA508_FieldName_Value, VA508_Cache_Use, strValue) > 0 then
		;say("has custom value",ot_jaws_message)
		;say(strValue,ot_selected_item)
		let sDisplayText = sDisplayText + "Custom Value: " + strValue + "\n"
		let iCustomInfo = true
	Endif

	if VA508GetComponentProp(getFocus(), VA508_FieldName_State, 	VA508_Cache_Use, strState) > 0 then
		;say("has custom state",ot_jaws_message)
		;say(strState,ot_item_state)
		let sDisplayText = sDisplayText + "Custom State: " + strState + "\n"
		let iCustomInfo = true
	Endif

	if VA508GetComponentProp(getFocus(),VA508_FieldName_Instructions, VA508_Cache_Use, strInstructions) > 0 then
		;say("has custom instructions",ot_jaws_message)
		;say(strInstructions,ot_line)
		let sDisplayText = sDisplayText + "Custom Instructions: " + strInstructions + "\n"
		let iCustomInfo = true
	Endif

	if VA508GetComponentProp(getFocus(), VA508_FieldName_Item_Instructions, 	VA508_Cache_Use, strItemInstructions) > 0 then
		;say("has custom item instructions",ot_jaws_message)
		;say(strItemInstructions,ot_line)
		let sDisplayText = sDisplayText + "Custom Item Instructions: " + strItemInstructions + "\n"
		let iCustomInfo = true
	Endif

	if !iCustomInfo then
		;say("No custom information found",ot_Jaws_message)
		let sDisplayText = "no custom information found\n"
	Endif
	
	va508getApplicationData(getFocus(),va508_queryCode_all)
	;copyToClipboard("Status:" + VA508GetStringValue(va508_fieldname_data_status)+ " Data: " + gsva508data)

	let sDisplayText = sDisplayText + "Status:" + VA508GetStringValue(va508_fieldname_data_status)+ " Data: " + gsva508data + "\n" + "DLL handle: " + IntToString(ghVA508DLLWindow) + "\n" + "Need to link to DLL?: " + IntToString(gbVA508needToLinkToDLL) + "\n" + "Data Windows Title: " + gsVA508dataWindowTitle + "\n"

	;sayMessage(ot_message,"data copied to clipboard")
	If UserBufferIsActive() then 
		UserBufferDeActivate() 
	Endif

	UserBufferClear()

	sayMessage(ot_user_buffer,sDisplayText)

EndFunction

;**********************************************************************
int function abs(int n)
	; Absolute value
	if n < 0 then
		return 0 - n
	endIf

	return n

endFunction

;**********************************************************************
; Get position and count from TORComboBox windows.
;**********************************************************************
int function getTorComboInfo(int byRef pos, int byRef count)
	var
		handle hwnd,
		object o, 
		int childID
		
	let hwnd = getCurrentWindow()
	if !hwnd then
		return False
	endIf

	if getWindowClass(hwnd) == "TorComboEdit" then
		let hwnd = getParent(hwnd)
	endIf

	if getWindowClass(hwnd) != "TorComboBox" then
		return False
	endIf

	let o = getObjectFromEvent(hwnd, -4, 0, childID)  ; -4 = ObjID_Client
	if !o then
		return False
	endIf

	let o = o.accNavigate(8, childID)  ; 8 = NavDir_LastChild
	if !o then
		return False
	endIf

	if o.accRole(0) == 9 then  ; 9 = Role_System_Window
		let o = o.accChild(-4)
		if !o then
			return False
		endIf
	endIf

	if o.accRole(0) != 33  ; 33 = Role_System_List
		&& isPCCursor() && getWindowTypeCode(getFirstChild(getFocus())) == WT_Button then
		let hwnd = getFirstChild(findTopLevelWindow("TORDropPanel", ""))
		if getWindowClass(hwnd) != "TORListBox" || abs(getWindowLeft(hwnd) -getWindowLeft(getFocus())) > 5 || abs(getWindowTop(hwnd) -getWindowBottom(getFocus())) > 5 then
			return False
		endIf

		let o = getObjectFromEvent(hwnd, -4, 0, childID)  ; -4 = ObjID_Client
		if !o then
			return False
		endIf

		if o.accRole(0) != 33 then  ; 33 = Role_System_List
			return False
		endIf

	endIf

	let count = o.accChildCount +0
	let pos = o.accSelection +0

	return True

endFunction

;**********************************************************************
; add proper speaking of position in group information for standard delphi listboxes, listviews already work correctly
; called by sayTreeViewLevel from activeItemChangedEvent
String Function PositionInGroup ()
var
	handle hwnd,
	int hItem,
	int hOrigItem,
	int count,
	int count1,
	int pos,
	string str

	let hwnd = getFocus()
	let pos = 0
	let count = 0
	if getObjectTypeCode() == wt_listboxitem then ; this is actually for list views which return a type code of listbox item
		let pos = lvGetFocusItem(hwnd)
		let count = lvGetItemCount (hwnd)

	elif getObjectTypeCode() == WT_LISTVIEWITEM then ; this is actually for list views which return a type code of listbox item
		let pos = lvGetFocusItem(hwnd)
		let count = lvGetItemCount (hwnd)
		
	elif getObjectTypeCode() == wt_listbox then
		let pos = SendMessage(hwnd,LB_GETCURSEL,0,0)+1
		let count = SendMessage(hwnd,LB_COUNT,0,0)

	elif getWindowClass(hwnd) == "TorComboEdit" || (getWindowClass(hwnd) == "TorComboBox" && !positionInGroup()) then
		if !getTorComboInfo(pos, count) then
			let pos = 0
			let count = 0
		endIf

	elif getObjectTypeCode() == wt_treeview && !(StringContains(StringLower(PositionInGroup()),"of") ||
			StringContains(StringLower(PositionInGroup()),"item")) then
		; sayString(positioninGroup())
		; use custom
		let hItem = sendMessage(hWnd,TVM_GETNEXTITEM,TVGN_CARET,0)
		if hItem then
			let hOrigItem = hItem
			let count = 0
			while hItem != 0 && count < 200 ; should always go through once
				let hItem = sendMessage(hWnd,TVM_GETNEXTITEM,TVGN_PREVIOUS,hItem)
				let count = count + 1
			EndWhile
			let hItem = hOrigItem
			let count1 = -1
			while hItem != 0 && count1 < 200 ; should always go through once
				let hItem = sendMessage(hWnd,TVM_GETNEXTITEM,TVGN_NEXT,hItem)
				let count1 = count1 + 1
			EndWhile
			let pos = count
			let count = count+count1
		Endif ; if we a valid handle for the item
	endif ; if we have a valid position

	if count then
		if pos == 0 then
			if count == 1 then
				let str = formatString(msgItemCount1, intToString(count))
			else
				let str = formatString(msgItemCount2, intToString(count))
			endIf
		else
			let str = formatString(msgPosMOfN, intToString(pos), intToString(count))
		endIf
	endIf

	if stringLength(str) then
		return str
	endIf

	return PositionInGroup()

EndFunction

;**********************************************************************
;**********************************************************************
Script Test()
	var
		string str

	; get4kName(getCurrentWindow())
	; sayInteger(RegisterWindowMessage("VA 508 / Freedom Scientific - JAWS Communication Message ID"))
EndScript

;**********************************************************************
; Test function for getting and speaking and/or displaying all DLL framework data for any window.
; Requires BX to be loaded.  [BX tools are not allowed on VA computers]
; Usage:
; First select a window via the BX Window Navigation map.
; Then from inside or outside of BX, type BXQuickKey T (for Test) <num>.
; <num> is a number or number plus other keys that determine what to query for and speak or show, as follows:
;	- 0 for query and speak all,
;	- Ctrl+Shift+3 for query and show-all (in JAWS virtual viewer),
;	- 1-7 for query and speak caption, value, controlType, state, instructions, itemInstructions, or data individually,
;	- 8-9 to send query bit 8 or 9 and speak result,
;	- Shift+0-9 to send one of query bits 10-19 and speak result,
;	- Ctrl+0-9 to send one of query bits 20-29 and speak result,
;	- Ctrl+Shift+0-2 to send one of query bits 30-32 and speak result, or
;	- Ctrl+Shift+4-9 for query and show caption, value, controlType, state, instructions, or itemInstructions individually.
; Parameter n is set to 0-9 for keys 0-9, 10-19 for Shift+0-9, 20-29 for Ctrl+0-9, and 30-39 for Ctrl+Shift+0-9.
; This function calls VA508GetApplicationData and VA508GetGridData but does all other parsing internally.
;**********************************************************************
void function bxTestNum(int n)
	var
		handle hwnd,
		int iQueryCode,
		string fmt,
		string varData, string data,
		string delim,
		string seg,
		string varName, int varStart, int varLen, string varVal,
		int i,
		string debugBuf,
		string buf
	/*
	let hwnd = VA508Cast(bxGetWindow())
	if !hwnd then
		bxSayString("No window selected", "")
		return
	endIf
	*/
	let hwnd = getCurrentWindow()
	let fmt = ""
	if n >= 32 then
		let n = n -33
		let fmt = fmt +"v"
	endIf
	if n then
		let iQueryCode = 1 << (n-1)
	else
		let iQueryCode = VA508_QueryCode_All
	endIf
	VA508GetApplicationData(hwnd, iQueryCode)
	let debugBuf = gsVA508GetAppDataDebugBuf

	let varData = gsVA508varData
	let data = gsVA508data
	let delim = stringLeft(varData, 1)
	let buf = ""
	let buf = buf +formatString(
			;"VA508 data for window of class %1:\13\10Delimiter: '%2'\13\10",
			"VA508 data for window of class %1:\13\10",
			getWindowClass(hwnd),
			delim
			)
	let i = 1
	while i
		let i = i +1
		let seg = stringSegment(varData, delim, i)
		if stringLength(seg) then
			let varName = stringSegment(seg, "=,", 1)
			let varVal = ""
			let varStart = stringToInt(stringSegment(seg, "=,", 2)) +1
			let varLen = stringToInt(stringSegment(seg, "=,", 3))
			if varStart && varLen then
				let varVal = substring(data, varStart, varLen)
			endIf
			if stringLength(varVal) then
				let buf = buf +formatString("\13\10%1: %2", varName, varVal)
				if varName == "value" then
					; Include grid data where appropriate.
					if VA508getGridData(varVal,0) then
						let buf = buf +formatString(
								"\13\10Grid data:\13\10Column %1 (%2 of %3)\13\10Row %4 (%5 of %6)\13\10Cell %7 (%8 of %9)",
								gsVA508cacheGridColHdr, intToString(giVA508cacheGridColNum), intToString(giVA508cacheGridColCnt),
								gsVA508cacheGridRowHdr, intToString(giVA508cacheGridRowNum), intToString(giVA508cacheGridRowCnt),
								gsVA508cacheGridCellVal, intToString(giVA508cacheGridCellNum), intToString(giVA508cacheGridCellCnt))
					endIf
				elif varName == "dataStatus" then
					; Some of these bits are obsolete but can still be passed, so they are named here.
					; Obsolete bits: CheckForStateChanges through ItemChangeSpeakValues, except for ItemChanged.
					; [DGL, 2007-05-31]
					let buf = buf +formatString(" (%1)",
							VA508Cast(olStringFlags(stringToInt(varVal),
							"|Caption|Value|ControlType|State|Instructions|ItemInstructions|Data||CheckForStateChanges|CheckForItemChanges|GetOnlyIfStateChanged|GetOnlyIfItemChanged|StateChanged|ItemChanged|ItemChangeSpeakValues|||||||||Error"))
							)
				endIf
			endIf
		else
			let i = 0  ; exits loop
		endIf
	endWhile

	if fwDebug then
		let buf = buf +formatString("\13\10\13\10VarData: %1\13\10Data: %2",
			varData, data)
		if debugBuf then
			let buf = buf +"\13\10\13\10" +debugBuf
		endIf
	endIf  ; fwDebug

	bxSayString(buf, fmt)

endFunction

;**********************************************************************
; Automatically close a combo box if one is open when tab or shift+tab is pressed
; Without this, tab and shift+tab in an open combo box do nothing.
;**********************************************************************
void function autoCloseIfOpenCombo()
	var
		string class,
		handle hWnd

	let hWnd = getFocus()

	if getWindowClass(hWnd) == wcComboLBox then
		TypeKey(Key_F4)
	endIf

endFunction

;**********************************************************************
Script Tab()
	if isSpecialFocus(False) then
		autoCloseIfOpenCombo()
	endIf

	PerformScript Tab()

EndScript

;**********************************************************************
Script ShiftTab()
	if isSpecialFocus(False) then
		autoCloseIfOpenCombo()
	endIf

	PerformScript ShiftTab()

EndScript

;**********************************************************************
; Avoids double speech in edit combo boxes.
;**********************************************************************
Void Function ValueChangedEvent (handle hwnd, int objId, int childId, int nObjType, string sObjName, string sObjValue,int bIsFocusObject)
	; A fix borrowed from JAWS 9...
	if nObjType == WT_Edit && getObjectSubtypeCode() == WT_EditCombo then
		; This seems to happen at random;
		; nObjType should normally be WT_EditCombo also.  [DGL, 2007-10-03]
		let nObjType = WT_EditCombo
	endIf

	ValueChangedEvent (hwnd, objId, childId, nObjType, sObjName, sObjValue, bIsFocusObject)

	if nObjType == wt_editCombo && bIsFocusObject && sObjValue then
		; we can assume it was spoken so suppress sayHighLightedText
		let gbVA508suppressEcho = true
	endIf

EndFunction

;**********************************************************************
; Overwrite of default to prevent double speaking in edit comboes and other places
;**********************************************************************
Void Function SayHighLightedText (handle hwnd, string buffer)
	if lt_suppressHighlight then
		scheduleFunction("lt_clearSuppressHighlight", 1000)
		return
	endIf

	;sayInteger(GetWindowSubTypeCode(hwnd))

	; prevent double speaking in open edit comboes
	if getWindowClass(getFocus()) == wcComboLBox then
	  if getWindowSubTypeCode(hwnd) == wt_editcombo || getWindowClass(hwnd) == "TORComboEdit" then
	  	return
	  endIf
	EndIf

	; prevent double speaking in TORComboEdit boxes, which seem to stay open.
	if (hwnd == getFocus() || getWindowClass(hwnd) == "TORListBox") && getWindowClass(getFocus()) == "TORComboEdit" then
		return
	endIf

	;sayString(getWindowClass(hwnd) +" " +getWindowClass(getFocus()))
	if getWindowClass(hwnd) == wcTMaskEdit then
		return
	Endif

	; added to suppress echo when valueChangedEvent works in closed editComboes
	if gbVA508suppressEcho then
		let gbVA508suppressEcho = false
		return
	EndIf

	if getWindowClass(hwnd) == wcTStringGrid && hwnd != getFocus() then
		return ; prevent speaking of highlight in grid when focus is not in that control
	Endif

	SayHighLightedText (hwnd, buffer)

EndFunction

;**********************************************************************
; Handles custom translations of types and states for output.
; Also completely defines the structure and location of translation tables.
; sTable:  Braille for Braille translations.
; Other tables such as "Speech" could be defined if necessary.
; iQueryCode:  Properties to look up in the table.
; 	%1 and %2 in sKeyFormat become initial Type and State values, respectively.
; sTypeVal and sStateVal:  Initial values on entry, initial or translated as appropriate on exit.
; Returns True if anything was changed and False if not.
;
; Table location:  All in <app>.jcf (initially VA508APP.jcf).
; Table section names:  [<name> Translations] (e.g., <name>=Braille)
; Keys (LHS in file): <prop1name>[|<prop2name>...] <propVal1>[|<propVal2>...]
;	where prop<n>name = e.g. ControlType or State.
;	Examples: "ControlType checkbox" or "ControlType|State Checkbox|Checked"
; Values (RHS in file): <delim><prop1val>[|<prop2val>...]
;	Examples:  "|lbx" or "|lbx|<x>"
; Full example:
;	[Braille Translations]
;	ControlType|State checkListBox|checked=|lbx|<x>
; makes the type "lbx" and the state "<x>" for a checked listbox item.
; Called by controlPropGet
;**********************************************************************
int function VA508TranslateProps(string sTable, int iQueryCode, string byRef sTypeVal, string byRef sStateVal)
	var
		string sFile,
		string sSect,
		string sKeyFormat1, string sKeyFormat2, string sKeyFormat,
		string sKey,
		string sTran,
		string sDelim,
		int i,
		int iChanged

	let iChanged = False

	; Set file and section.
	let sFile = findJAWSSettingsFile(getActiveConfiguration() +".jcf")
	if !fileExists(sFile) then
		; No file, no translations.
		return False
	endIf
	let sSect = formatString("%1 Translations", sTable)

	; Set key by constructing it based on iQueryCode.
	let sKeyFormat1 = ""
	let sKeyFormat2 = ""
	if iQueryCode & VA508_QueryCode_Control_Type then
		let sKeyFormat1 = sKeyFormat1 +"|ControlType"
		let sKeyFormat2 = sKeyFormat2 +"|%1"
	endIf

	if iQueryCode & VA508_QueryCode_State then
		let sKeyFormat1 = sKeyFormat1 +"|State"
		let sKeyFormat2 = sKeyFormat2 +"|%2"
	endIf

	let sKeyFormat = stringChopLeft(sKeyFormat1, 1) +msgSpace +stringChopLeft(sKeyFormat2, 1)
	let sKey = formatString(sKeyFormat, sTypeVal, sStateVal)

	; Look up the key and abort if not found.
	let sTran = iniReadString(sSect, sKey, "<NoTranslation>", sFile)
	if stringCompare(sTran, "<NoTranslation>", True) == 0 then
		return False
	endIf

	; A translation was found; interpret it.
	let sDelim = stringLeft(sTran, 1)
	let i = 1
	if stringContains(sKeyFormat, "%1") then
		; There is a Type translation.
		let i = i +1
		let sTypeVal = stringSegment(sTran, sDelim, i)
		let iChanged = True
	endIf

	if stringContains(sKeyFormat, "%2") then
		; There is a State translation.
		let i = i +1
		let sStateVal = stringSegment(sTran, sDelim, i)
		let iChanged = True
	endIf

	return iChanged

endFunction

;**********************************************************************
; Handles all control property requests.
; Called only by BraillePropHelper
; Returns 1 when a property has a custom value, 0 when not, and below 0 on error.
; This function defines the accepted list of JAWS control property names.
; Most of them come from the names of the BrailleAddObject* functions built in to JAWS.
; sOrigin can be current, focus, or hwnd<handle>.
; whichProp is the name of the property sought.
; whichProp can end in .brl for a Braille-specific answer.
; sVal is the returned property value if the function returns 1, undefined otherwise.
;**********************************************************************
int function controlpropGet(string sOrigin, string whichProp, int nSubtype, string byRef sVal)
	var
		handle hwnd,
		int iCacheHandling,
		int isBraille,
		int iResult

	; sayString("control prop")
	; Get hwnd, iCacheHandling, and nSubtype worked out.
	let iCacheHandling = VA508_Cache_Skip
	if sOrigin == "focus" || (sOrigin == "current" && isPCCursor()) then
		let hwnd = getFocus()
		let iCacheHandling = VA508_Cache_Use
		if !nSubtype then
			let nSubtype = getObjectSubtypeCode()
		endIf

	elif sOrigin == "current" then
		let hwnd = getCurrentWindow()
		if !nSubtype then
			let nSubtype = getObjectSubtypeCode()
		endIf

	elif sOrigin == "hwnd" then
		let hwnd = stringToHandle(stringChopLeft(sOrigin, 4))
		if hwnd == getFocus() then
			let iCacheHandling = VA508_Cache_Use
		endIf
		if !nSubtype then
			let nSubtype = getWindowSubtypeCode(hwnd)
		endIf

	else
		; Not supported at this time.
		return 0

endIf

	; Now for isBraille and whichProp.
	let isBraille = False
	if stringRight(whichProp, 4) == ".brl" then
		let whichProp = stringChopRight(whichProp, 4)
		let isBraille = True
	endIf

	; Check the framework for custom values.
	if whichProp == "Name" then
		return VA508GetComponentProp(hwnd, VA508_FieldName_Caption, iCacheHandling, sVal)

	elif whichProp == "Type" || whichProp == "State" then
		var
			int iTypeRet, string sTypeVal,
			int iStateRet, string sStateVal
		let iTypeRet = VA508GetComponentProp(hwnd, VA508_FieldName_Control_Type, iCacheHandling, sTypeVal)
		let iStateRet = VA508GetComponentProp(hwnd, VA508_FieldName_State, iCacheHandling, sStateVal)
		if isBraille then
			if iTypeRet > 0 && iStateRet > 0 then
				VA508TranslateProps("Braille", VA508_QueryCode_Control_Type +VA508_QueryCode_State, sTypeVal, sStateVal)
			endIf
			if iTypeRet > 0 then
				VA508TranslateProps("Braille", VA508_QueryCode_Control_Type, sTypeVal, sStateVal)
			endIf
			if iStateRet > 0 then
				VA508TranslateProps("Braille", VA508_QueryCode_State, sTypeVal, sStateVal)
			endIf
		endIf  ; isBraille

		if whichProp == "Type" then
			let sVal = sTypeVal
			return iTypeRet
		else  ; State
			let sVal = sStateVal
			return iStateRet
		endIf

	elif whichProp == "Value" then
		var int iValFound
		let iValFound = VA508GetComponentProp(hwnd, VA508_FieldName_Value, iCacheHandling, sVal) > 0
		if iValFound > 0 && VA508GetGridData(sVal,0) then ; GRID
			if isBraille then
				let sVal = ""
				if giGridBrailleMode == 1 || giGridBrailleMode == 3 then
					let sVal = "r"+IntToString(giVA508CacheGridRowNum)+"c"+intToString(giVa508CacheGridcolNum)+msgSpace
				Endif
				if giGridBrailleMode == 1 || giGridBrailleMode == 2 then
					let sVal = sVal + gsVA508cacheGridRowHdr +msgSpace +gsVA508CacheGridColHdr +msgSpace
				endif
				if gsVA508CacheGridCellVal == "" then
					let gsVA508CacheGridCellVal = "-" 
				Endif
			else ; NOT BRAILLE
				let sVal = ""
			endIf  ; isBraille
			let sVal = sVal + gsVA508CacheGridCellVal ;always show cell
			return true
		elif nSubType == wt_progressBar then
			if iValFound < 1 then
				let sVal = getObjectValue()
				return true
			Endif
		endif

		return iValFound

	; TODO:  Many of the rest are not handled yet.
	elif whichProp == "ContainerName" then
		; Generally a group box name.

	elif whichProp == "ContainerType" then
		; Not sure how often this one gets used.

	elif whichProp == "Position" then
		; e.g., "1 of 4" or "4 items" for lists and trees.

	elif whichProp == "DlgPageName" then
		; Name of active tab.

	elif whichProp == "DlgText" then
		; Dialog static text.

	elif whichProp == "ContextHelp" then
		; TODO: This could be Instructions or Item_Instructions.

	elif whichProp == "Time" then
		; This may not be used at all.

	elif whichProp == "Level" then
		; Tree level.

	endIf

	return 0  ; no custom value for this property

endFunction

; Braille Support
;**********************************************************************
int function BraillePropHelper(string whichProp, int nSubtype)
	; Logic for BrailleAddObject* functions to use.
	var
		int x, int y,
		int tc,
		int iResult,
		string sVal,
		int nWindowSubTypeCode

	let nWindowSubTypeCode = getWindowSubtypeCode(getFocus())
	if nWindowSubTypeCode == wt_unknown then
		let nWindowSubTypeCode = getObjectSubTypeCode()
	endif

	if  nWindowSubTypeCode != nSubtype then
		; BrailleAddObject* function(s) called on a parent (e.g., dialog) control.
		; We currently have no way to handle this, so let JAWS do it.
		return False
	endIf

	let iResult = controlpropGet("focus", whichProp +".brl", nSubType, sVal)
	if iResult > 0 then
		if whichProp != "name" then  ; prevents cursor from being placed on label instead of value in edit fields
			let x = getCursorCol()
			let y = getCursorRow()
		Endif
		BrailleAddString(sVal, x,y, 0)
		return True
	endIf

	return False

endFunction

;************************************************************************
int Function BrailleClassFound(string ControlType, int byref nType)
	var
		int i,
		int count

	let i = StringSegmentIndex (glbsTable, string_delim, StringLower(msgSpace+ControlType), true)
	if i then
		let nType = StringToInt(StringSegment(glbsTable2,string_delim,i))
		return true
	endif

	return false

EndFunction

;************************************************************************
int function BrailleCallbackObjectIdentify()
	var
		int nType,
		string controlType

	if isSpinBox(getCurrentWindow()) then
			return wt_spinbox
	Endif

	if VA508GetComponentProp(getCurrentWindow(),VA508_FieldName_Control_Type,VA508_Cache_Use,controlType) > 0 then
		let nType = 0
		if BrailleClassFound(ControlType, nType) then
			return nType
		EndIf
	Endif

	return BrailleCallBackObjectIdentify()

EndFunction

; added so spinbox sub type code can make nSubType code passed to BrailleAddObject functions
; what is returned in getWindowSubTypeCode must matach what is returned in BrailleCallBackObjectIdentify for the BraillePropHelper to show any custom information
;************************************************************************
int Function getWindowSubTypeCode (handle hwnd)
	var
		int nType,
		string ControlType,
		int cacheHandling

	; sayString("get window sub type code")

	if isSpinBox(hwnd) then
			return wt_spinbox
	Endif

	if hwnd == getFocus() then
		let cacheHandling = VA508_Cache_Use
	else
		let cacheHandling = VA508_Cache_Skip
	endIf

	if VA508GetComponentProp(getCurrentWindow(),VA508_FieldName_Control_Type,cacheHandling,controlType) > 0 then
		if BrailleClassFound(ControlType, nType) then
			return nType
		EndIf
	Endif

	return getWindowSubTypeCode(hwnd)

EndFunction

;************************************************************************
; These are all the BrailleAddObject* functions internally recognized as of JAWS 8.0.
int function BrailleAddObjectName(int nSubtype)
	return BraillePropHelper("Name", nSubtype)
endFunction

;************************************************************************
int function BrailleAddObjectType(int nSubtype)
	return BraillePropHelper("Type", nSubtype)
endFunction

;************************************************************************
int function BrailleAddObjectState(int nSubtype)
	return BraillePropHelper("State", nSubtype)
endFunction

;************************************************************************
int function BrailleAddObjectValue(int nSubtype)
	return BraillePropHelper("Value", nSubtype)
endFunction

;************************************************************************
int function BrailleAddObjectContainerName(int nSubtype)
	return BraillePropHelper("ContainerName", nSubtype)
endFunction

;************************************************************************
int function BrailleAddObjectContainerType(int nSubtype)
	return BraillePropHelper("ContainerType", nSubtype)
endFunction

;************************************************************************
int function BrailleAddObjectPosition(int nSubtype)
	return BraillePropHelper("Position", nSubtype)
endFunction

;************************************************************************
int function BrailleAddObjectDlgPageName(int nSubtype)
	return BraillePropHelper("DlgPageName", nSubtype)
endFunction

;************************************************************************
int function BrailleAddObjectDlgText(int nSubtype)
	return BraillePropHelper("DlgText", nSubtype)
endFunction

;************************************************************************
int function BrailleAddObjectContextHelp(int nSubtype)
	return BraillePropHelper("ContextHelp", nSubtype)
endFunction

;************************************************************************
int function BrailleAddObjectTime(int nSubtype)
	return BraillePropHelper("Time", nSubtype)
endFunction

;************************************************************************
int function BrailleAddObjectLevel(int nSubtype)
	return BraillePropHelper("Level", nSubtype)
endFunction

;**********************************************************************
; Allows JAWS ListView commands like Ctrl+JAWSKey+numbers to work with custom but functional ListView controls
; Only affects JAWS 7.1 and later.
;**********************************************************************
int function isTrueListView(handle hwnd)
	var
		int result

	let result = isTrueListView(hwnd)
	if result then
		return result
	endIf

	if stringContains(stringLower(getWindowClass(hwnd)), "list") && lvGetNumOfColumns(hwnd) > 0 then
		return True
	endIf

	return False

endFunction

;**********************************************************************
; Makes F2 edit the current tree node as a left-click does
;**********************************************************************
Script f2editTreeNode ()
	var
		int hItem,
		handle hWnd

	sayCurrentScriptKeyLabel()

	let hwnd = getFocus()
	if getWindowClass(hWnd) == wcTTreeView then
		let hItem = sendMessage(hWnd,TVM_GETNEXTITEM,TVGN_CARET,0)
		if hItem then
			sendMessage(hWnd,TVM_EDITLABELW,0,hitem)
			return
		Endif

	elif getWindowTypeCode(hwnd) == WT_TREEVIEW then ; we have a tree that's not a TTreeView then it might not have an api so use mouse
		saveCursor()  
		JAWSCursor()  
		saveCursor()
		routeJAWSToPC()
		leftMouseButton()
		return
	endIf

	typeCurrentScriptKey()

EndScript

;**********************************************************************
; Called by JAWS.SR when things happen to a window in the active VA508 application.
; This is the only function/script in this file called externally.
; ControlTypes are only sent for custom types and are always sent regardless of whether the type changes, it is doubtful that a type will actually change
; This function gets called before focusChangedEvent, thus 3ms schedule functions were used
;**********************************************************************
void function VA508ChangeEvent(handle hwnd, int iDataStatus, string sCaption, string sValue, string sControlType, string sState, string sInstructions, string sItemInstructions)

	; sayString("called")

	if giCancelEvent == true then
		return
	Endif

	let ghFromChangeEvent = hwnd
	let giDidFocusChange = false ; used to ensure that we don't have double speaking when the event comes in before handleCustomWindows has a change to speak it
	if iDataStatus & VA508_Data_Change_Event then
		let iDataStatus = iDataStatus - VA508_Data_Change_Event ; not needed so let's remove
	Endif

	if iDataStatus & VA508_QueryCode_Control_Type then
		let iDataStatus = iDataStatus - VA508_QueryCode_Control_Type ; not needed
	Endif

	; Update the cache so Braille will update immediately.
	VA508CacheSetVals(hwnd, iDataStatus, sCaption, sValue, sControlType, sState, sInstructions, sItemInstructions)
	BrailleRefresh() ;for an instant update rather than waiting up to 2 seconds to see the change, or in the case of braille viewer instead of waiting 30 seconds

/*
sayString(formatString(
"Event %1 vals %2 %3 %4 %5 %6 %7",
decToHex(iDataStatus), sCaption, sValue, sControlType,
 sState, sInstructions, sItemInstructions
))
*/

	; Don't speak changes to non-focused windows.
	if hwnd != getFocus() then
		if inDebugging then bxGauge(3, 0) Endif
		return
	endIf

	watchCount("change")

	; was a grid cell changed?
	; jda 9-14-07

	if VA508GetGridData(sValue,0) && !giSpokeCellUnit then
		say(gsVA508cacheGridColHdr,ot_control_name)
		say(gsVA508cacheGridRowHdr,ot_control_name)
		if gsVA508cacheGridCellVal == "" then
			let gsVA508cacheGridCellVal = " " ; so blank will be spoken
		Endif
		say(gsVA508cacheGridCellVal,ot_line)
		say("column " + intToString(giVA508cacheGridColNum),ot_position)
		say("row " + intToString(giVA508cacheGridRowNum),ot_position)
		return
	Endif

	; For some one-thing-only changes, just speak what changed.
	; Since changes are spoken individually this might affect reading order preferences that users have set when arrow keys are used
	if iDataStatus & VA508_QueryCode_Caption && sCaption then
		let giSuppressCaption = true
	Endif

	; this is always set and thus would always be announced, thus it is filtered out and should not get called
	if iDataStatus & VA508_QueryCode_Control_Type && sControlType then
		let giSuppressControlType = true
	endIf

	if iDataStatus & VA508_QueryCode_State && sState then
		let giSuppressState = true
	Endif

	if iDataStatus & VA508_QueryCode_Value && sValue && !VA508GetGridData(hwnd,0) then
		let giSuppressValue = true
	Endif

	if iDataStatus & VA508_QueryCode_Instructions && sInstructions then
		let giSuppressInstructions = true
	Endif

	if iDataStatus & VA508_QueryCode_Item_instructions && sItemInstructions then
		let giSuppressItemInstructions = true
	Endif

	ScheduleFunction("AnnounceEvent",3)

endFunction

;*********************************************************************************************************
; Called by the Announce* functions below.
;*********************************************************************************************************
Void Function AnnounceProp(int iQueryCode, int outputType, int byRef propGlobalFlag)
	var
		string prop

	if propGlobalFlag && giDidFocusChange == false then
		if VA508getComponentProp(ghFromChangeEvent, iQueryCode, VA508_Cache_Use, prop) > 0 then
			sayMessage(outputType, prop)
		Endif
	Endif

	let propGlobalFlag = false

EndFunction

;*********************************************************************************************************
; All these are called by va508ChangeEvent
;*********************************************************************************************************
Void Function AnnounceEvent()
	AnnounceProp(VA508_QueryCode_Caption, OT_Control_Name, giSuppressCaption)
	AnnounceProp(VA508_QueryCode_Control_Type, OT_Control_Type, giSuppressControlType)
	AnnounceProp(VA508_QueryCode_State, OT_Item_State, giSuppressState)
	AnnounceProp(VA508_QueryCode_Value, OT_Selected_Item, giSuppressValue)
	AnnounceProp(VA508_QueryCode_Instructions, OT_Tutor, giSuppressInstructions)
	AnnounceProp(VA508_QueryCode_Item_Instructions, OT_Tutor, giSuppressItemInstructions)
endFunction

;*********************************************************************************************************
; overwrite of default to allow control+tab to be used to change tabs in Delphi applications
Script NextDocumentWindow ()
	ChangeDocumentWindow(1)
EndScript

;*********************************************************************************************************
; overwrite of default to allow control_shift+tab to be used to change tabs in Delphi applications
Script PreviousDocumentWindow ()
	ChangeDocumentWindow(0)
EndScript

;*********************************************************************************************************
; allows control tab when pressed on a child object of a page tab to announce the change in page
; allows control tab to announce the correct tab when focus in on page tab control and style is set to button or flat button
;*********************************************************************************************************
Void Function ChangeDocumentWindow(int direction)
	var
		string pageName,
		handle hwnd

	if isSpecialFocus(False) then
		if direction == 1 then
			PerformScript NextDocumentWindow()
		elif direction == 0 then
			PerformScript PreviousDocumentWindow()
		Endif
		return
	endIf
	let hwnd = getFocus()
	; store to see if page changed
	let PageName = getDialogPageName()

	; cause tab to change
	if getWindowClass(hwnd) == wcTTabControl then ; this control doesn't natively support control+shift+tab
		if direction == 1 then
			typeKey(ksRightArrow)
		elif direction == 0 then
			typeKey(ksLeftArrow)
		endif
	elif getWindowClass(getParent(hwnd)) == wcTTabControl ||
		getWindowClass(getParent(getParent(hwnd))) == wcTTabControl then ; this control doesn't natively support control+shift+tab
			SelectTab(direction)
	endif

	if direction == 1 then
		PerformScript NextDocumentWindow()
	elif direction == 0 then
		PerformScript PreviousDocumentWindow()
	Endif

	let hwnd = getFocus()  ; have to get focus again because it may have changed???
	; announce change when focus is on special type of TPageControl tab with buttons
	if getObjectTypeCode() == wt_tabcontrol then
		if getWindowStyleBits(hwnd) & window_style_tabsWithButtons then  ; tabs with buttons or flat buttons, control+tab doesn't work correctly here
			let glbSuppressFocusChange = true
			delay(1, True)
			SayControlEx (hwnd, getDialogPageName(), "", "", "", "", "", "", "")
			ScheduleFunction("ClearSuppressFocusChange",3)
			return
		endif

	; announce change when focus is on child of page tab
	elif PageName != getDialogPageName() && getDialogPageName() then
			say(getDialogPageName()+msgSpace+MsgPage,ot_controL_name)
	endif

EndFunction

;*********************************************************************************************************
; overwrite of default function to return proper page names in Delphi windows
String Function GetDialogPageName()
	var
		string page,
		object o,
		int cid,
		handle hwnd

	let hwnd = getFocus()
	let page = getDialogPageName()
	if page == "" then
		if getWindowClass(getParent(hwnd)) == wcTTabSheet ||
			getWindowClass(getParent(getParent(hwnd))) == wcTTabSheet then ; for TPageControl when child or granchild has focus
			if getWindowTypeCode(getParent(hwnd)) == wt_tabControl then
				let page = getWindowName(getParent(hwnd))

			elif getWindowTypeCode(getParent(getParent(hwnd))) == wt_tabControl then
				let page = getWindowName(getParent(getParent(hwnd)))
			endif

		; TTabControl not handled here
		elif getWindowClass(getParent(hwnd)) == wcTTabControl ||
			getWindowClass(getParent(getParent(hwnd))) == wcTTabControl then ; forTTabControl when child or grandchild has focus
			let page = getSelectedTab()

		elif getObjectTypeCode() == wt_tabControl then ; for TTabControl and TPageControl
			; getObjectName() can return the wrong name
			let o = getFocusObject(cid)
			if o then
				let page = o.accName(cid)
			endif
		endif
	endif

	return page

EndFunction

; gets the selected tab from a TTabControl when a child control is in focus
;***************************************************************************
String Function getSelectedTab()
	var
		object o,
		int cid,
		int count

	if getWindowClass(getParent(getFocus())) == wcTTabControl then ; forTTabControl
		let o = getFocusObject(cid) ; full child control
		let count = 1
		while o && count < 10 && o.accRole(childId_self) != role_system_pagetablist
			let o = o.accParent() ; window
			let count = count + 1
		EndWhile

		if o && o.accRole(childId_self) == role_system_pagetablist then
			let count = 1
			while count <= o.accChildCount()
				if o.accState(count) & state_system_selected then
					return o.accName(count)
				endif
				let count = count + 1
			EndWhile
		endif
	Endif

EndFunction

;***************************************************************************
; 1 for next
; 0 for previous
; Used for TTabControl to activate a new tab using MSAA
;***************************************************************************
Void Function SelectTab(int direction)
	var
		object o,
		int cid,
		int childCount,
		int count

	; msaa structure includes all control in page under page tab list.... troubling
	; only works when groupbox or panel is not used
	if getWindowClass(getParent(getFocus())) == wcTTabControl then ; forTTabControl
		let o = getFocusObject(cid)
		let count = 1

		; find the page tab list
		while o && count < 10 && o.accRole(childId_self) != role_system_pagetablist
			let o = o.accParent() ; window
			let count = count + 1
		EndWhile

		; find the selected child
		if o && o.accRole(childId_self) == role_system_pagetablist then
			let childCount = o.accChildCount()
			let count = 1
			while count <= o.accChildCount()
				if o.accState(count) & state_system_selected then
					let cid = count
				endif
				let count = count + 1
			EndWhile

			; set focus to the next or prior child
			if direction == 1 then
				if o.accRole(cid+1) != role_system_pagetab then
					let cid = 0
				endif ; role page tab
				o.accSelect(selflag_takeSelection,cid+1)

			elif direction == 0 then
				if cid > 1 then
					o.accSelect(selflag_takeSelection,cid-1)
				else ; just sit on first tab
				endif
			Endif ; direction

		EndIf ; role page tab list

	Endif ; TTabControl

EndFunction

;***************************************************************************
; resets the global variable that suppress focus changes from being announced
Void Function ClearSuppressFocusChange()
	let glbSuppressFocusChange = FALSE
EndFunction

;***************************************************************************
int Function isSpinBox (handle hwnd)
	if getObjectTypeCode() == wt_edit && getWindowClass(getNextWindow(hwnd)) == wcTUpDown then
		return true
	endif

	return false

EndFunction

;***************************************************************************
; get value for element from framework, falls back on getObjectValue()
String Function getValue()
	var
		string value

	if VA508GetComponentProp(getFocus(),VA508_FieldName_Value,VA508_Cache_Update,value) <= 0 then ; no custom property returned
		let value = getObjectValue()
	endif

	return value ; could be null from either getObjectValue or from framework if it was set to null on purpose

EndFunction

;***************************************************************************
; updated for grid support
int function moveByLine(int forward)
	var
		handle hwnd

	let hwnd = getFocus()

	if isPCCursor() && !isSpecialFocus(False) then
		if isSpinBox(hwnd) || getWindowClass(hwnd) == "TORComboEdit" || getWindowClass(hwnd) == "TORComboBox" then
			if forward then
				nextLine()
			else
				priorLine()
			endIf
			if 	isSpinBox(hwnd) || getWindowClass(hwnd) == "TORComboEdit" then
				; JCC January 2015 foirce refresh of MSAA before  speaking selection
				MSAARefresh (True, 200)
				say(getValue(),ot_selected_item)
			endIf
			return True

		elif SpeakCellUnit("downArrow") then
			return True

		endIf
	endIf

	return False

endFunction

Script SayNextLine()
	if !moveByLine(True) then
		performScript sayNextLine()
	endIf
EndScript

Script SayPriorLine()
	if !moveByLine(False) then
		performScript sayPriorLine()
	endIf
EndScript

;***************************************************************************
; updated for grid support
Script SayNextCharacter()
	if SpeakCellUnit("rightArrow") then
		return
	Endif

	performScript sayNextCharacter()

EndScript

;***************************************************************************
; updated to allow correct announcement in grids
;***************************************************************************
Script SayPriorCharacter()
	if SpeakCellUnit("leftArrow") then
		return
	Endif

	performScript sayPriorCharacter()

EndScript

;******************************************************************
function clearSpokeCellUnit()
	let giSpokeCellUnit = false
EndFunction

;******************************************************************
; Speaks the aspects of a cell that are different from the last cell visited
int Function SpeakCellUnit(string str)
	var
		string strVal,
		string buildString
		
	;sayString("speak cell unit")
	let giSpokeCellUnit = true
	scheduleFunction("clearSpokeCellUnit",2) ; prevent double speaking by changeEvent

	if !isPCCursor() || isSpecialFocus(False) then
		return 0

	elif VA508getGridData(getFocus(),0) > 0 then ; IN GRID
		TypeKey(str)
		delay(1, True)
		; Update the cache.
		VA508GetComponentProp(getFocus(), VA508_FieldName_Value, VA508_Cache_Update, strVal)
		VA508GetGridData(strVal,0) ; have to call here to refresh view when Braille is not being used
		if gsVA508cacheGridCellVal == "" then 
			let gsVA508cacheGridCellVal = " " ; so it will say blank with ot_line
		Endif
		if !giGridSpeechMode then
			say(gsVA508cacheGridCellVal,ot_line)  ; DATA ONLY
			return 1
		elif str == "leftArrow" || str == "rightArrow" || str == "home" || str == "end" then
			;	COLUMN CHANGE
			if giGridSpeechMode == 1 || giGridSpeechMode == 2 then
				; don't use ot_line here incase it is blank we dont' want blank spoken
				sayUsingVoice(VCTX_MESSAGE,gsVA508cacheGridColHdr,ot_control_name)
			Endif
			say(gsVA508cacheGridCellVal,ot_line)
			if giGridSpeechMode == 1 || giGridSpeechMode == 3 then
				say("column " + intToString(giVA508cacheGridColNum),ot_position)
			Endif
			return 1
		elif str == "upArrow" || str == "downArrow" || str == "pageUp" || str == "pageDown" then
			; Row change
			if giGridSpeechMode == 1 || giGridSpeechMode == 2 then
			; don't use ot_line here incase it is blank we dont' want blank spoken
				sayUsingVoice(VCTX_MESSAGE,gsVA508cacheGridRowHdr,ot_control_name)
			Endif
			say(gsVA508cacheGridCellVal,ot_line)
			if giGridSpeechMode == 1 || giGridSpeechMode == 3 then
				say("row " + intToString(giVA508cacheGridRowNum),ot_position)
			Endif
			return 1
		endif

	; IN TAB CONTROL
	elif getObjectTypeCode() == wt_tabcontrol && getWindowStyleBits(getCurrentWindow()) & window_style_tabsWithButtons then  ; tabs with buttons or flat buttons
		let glbSuppressFocusChange = true
		TypeKey(str)
		delay(1, True)
		sayControlEx(getCurrentWindow(), getObjectName(), getObjectSubtype(), getAccState())
		ScheduleFunction("ClearSuppressFocusChange",3)
		return 1

	endif

	return 0

EndFunction

;******************************************************************
; returns the full string of col number, row number, column name, row name, and cell data for the current table cell
; used by sayLine, tab, shift+tab, insert+tab and control+home, and control+end
string Function getCurrentCellHeadersData ()
	var
		string str

	VA508GetGridData(getFocus(),0) ; have to call here to refresh view when Braille is not being used
	let str = "column" + msgSpace + IntToString(giVA508CacheGridColNum) + "row" + msgSpace + IntToString(giVA508CacheGridRowNum) + msgSpace
	let str = str + gsVA508cacheGridColHdr + msgSpace + gsVA508cacheGridRowHdr + msgSpace + gsVA508cacheGridCellVal

	return str

EndFunction

;home and end in grid

;*********************************************************************
; updated for grid support
Script JAWSHome()
	if SpeakCellUnit("home") then
		return
	Endif

	performScript JAWSHome()

EndScript

;*********************************************************************
; updated for grid support
Script JAWSEnd()
	if SpeakCellUnit("end") then
		return
	Endif
	performScript JAWSEnd()
EndScript

;*********************************************************************
; updated for grid support
Script JAWSPageDown()
	if SpeakCellUnit("pageDown") then
		return
	Endif
	performScript JAWSPageDown()
EndScript

;*********************************************************************
; updated for grid support
Script JAWSPageUp()
	if SpeakCellUnit("pageUp") then
		return
	Endif
	performScript JAWSPageUp()
EndScript

;*********************************************************************
Int Function UpdateBrailleClasses()
	var
		string sFile,
		string sTable,
		int i,
		int count

	let glbsTable = ""
	let glbsTable2 = ""
	let sFile = findJAWSSettingsFile(getActiveConfiguration() +".jcf") ; get applicatio specific jcf file
	if !fileExists(sFile) then
		; No file, no translations.
		return False
	endIf

	; file exists
	; this line adds a space at the beginning of each item in the list that is returned because of a bug in StringSegmentIndex
	let glbsTable = msgSpace + StringReplaceSubStrings(StringLower(IniReadSectionKeys (section_BrailleClasses, sFile)),string_delim, string_delim+MsgSpace) ; msgSpace need for first item to match
	let count = VA508StringSegmentCount (glbsTable, string_delim)
	let i = 1
	while i <= count
		let glbsTable2 = glbsTable2 + IntToString(IniReadInteger (section_BrailleClasses, StringChopLeft(StringSegment(glbsTable,string_delim,count),1), 0, sFile)) + string_delim
		let i = i + 1
	endWhile

	if glbsTable2 then
		let glbsTable2 = stringChopRight (glbsTable2, 1)
	Endif

	return True

EndFunction

;*****************************************************************************************************
Int Function UpdateControlTypes()
	var
		string sFile,
		string sTable,
		int i,
		int count

	let glbsTable3 = ""
	let glbsTable4 = ""
	let sFile = findJAWSSettingsFile(getActiveConfiguration() +".jcf")
	if !fileExists(sFile) then
		; No file, no translations.
		return False
	endIf

	let glbsTable3 = msgSpace + StringReplaceSubStrings(StringLower(IniReadSectionKeys (section_ControlTypes, sFile)),string_delim, string_delim+msgSpace)
	let count = VA508StringSegmentCount (glbsTable3, string_delim)
	let i = 1
	while i <= count
		let glbsTable4 = glbsTable4 + IniReadString (section_ControlTypes, StringChopLeft(StringSegment(glbsTable3,string_delim,count),1), msgNull, sFile) + string_delim
		let i = i + 1
	endWhile

	if glbsTable4 then
		let glbsTable4 = stringChopRight (glbsTable4, 1)
	Endif

	return True

EndFunction

;************************************************************************
int Function ControlTypeFound (string ControlType, string ByRef newControlType)
	var
		int i,
		int count

	let i = StringSegmentIndex (glbsTable3, string_delim, StringLower(msgSpace+ControlType), true)
	if i then
		let newControlType = StringSegment(glbsTable4,string_delim,i)
		return true
	endif

	return false

EndFunction


/* Start - Personal settings */

;*******************************************************************************************
; called by JAWS verbosity dialog to flip or return status
String Function ToggleGridSpeechMode (int iRetVal)
	If not iRetVal Then ; flip only if space pressed
		Let giGridSpeechMode = giGridSpeechMode + 1
		if giGridSpeechMode > 3 then
			let giGridSpeechMode = 0
		Endif
	EndIf  ; update it

; return state, used to build visual list of current settings
	If giGridSpeechMode == 1 Then
		return msgRowAndColumnHeadersAndNumbers

	elif giGridSpeechMode == 2 then
		return msgRowAndColumnHeaders

	elif giGridSpeechMode == 3 then
		return msgRowAndColumnNumbers

	Else ; 0
		return msgDataOnly

	EndIf

EndFunction

;*******************************************************************************************
; called by JAWS verbosity dialog to flip or return status
String Function ToggleGridBrailleMode (int iRetVal)
	If not iRetVal Then ; flip only if space pressed
		Let giGridBrailleMode = giGridBrailleMode + 1
		if giGridBrailleMode > 3 then
			let giGridBrailleMode = 0
		Endif
	EndIf  ; update it

	; return state
	If giGridBrailleMode == 1 Then
		return msgRowAndColumnHeadersAndNumbers

	elif giGridBrailleMode == 2 then
		return msgRowAndColumnHeaders

	elif giGridBrailleMode == 3 then
		return msgRowAndColumnNumbers

	Else ; 0
		return msgDataOnly

	EndIf

EndFunction

;*******************************************************************************************
Void Function LoadPersonalSettings ()
	var
		string sFile

	; Load personal preferences
	; SayUsingVoice(VCTX_MESSAGE,msgLoadingSettings,OT_USER_REQUESTED_INFORMATION)
	let sFile = findJAWSSettingsFile(getActiveConfiguration() +".jsi")
	let giGridSpeechMode = IniReadInteger (Section_Options, hKey_GridSpeechMode, 1, sFile)
	let giGridBrailleMode = IniReadInteger (Section_Options, hKey_GridBrailleMode, 1, sFile)
EndFunction

;*******************************************************************************************
Int Function SavePersonalSettings ()
; save personal preferences
	Var
		int iResult,
		string sFile

	let sFile = findJAWSSettingsFile(getActiveConfiguration() +".jsi")
	let iResult =IniWriteInteger (Section_Options, hKey_GridSpeechMode, giGridSpeechMode, sFile)
	let iResult = IResult | IniWriteInteger (Section_Options, hKey_GridBrailleMode, giGridBrailleMode, sFile)
	return iResult
EndFunction

;*******************************************************************************************
; modified to include personalized settings for automatically speaking buddies as the sign in and incoming messages
Script AdjustJAWSVerbosity ()
	Var
		int iPrevGridSpeechMode,
		int iPrevGridBrailleMode,
		string sList

	;	save the current values
	let iPrevGridSpeechMode = giGridSpeechMode
	let iPrevGridBrailleMode = giGridBrailleMode

	let sList=jvToggleGridSpeechMode + jvToggleGridBrailleMode

	JAWSVerbosityCore (sList) ; call default

	; If any values changed, save them...
	If iPrevGridSpeechMode != giGridSpeechMode || iPrevGridBrailleMode != giGridBrailleMode then
		If savePersonalSettings() then
			SayUsingVoice(VCTX_MESSAGE, msgPersonalSettingsSaved,OT_STATUS)
		Else
			SayFormattedMessage(ot_error, msgPersonalSettingsNotSaved)
		EndIf
	EndIf

EndScript

/* End - Personal settings */

;***************************************************************************************
; getObjectName() is often wrong and this can be used to get the real msaa name as long as the msaa cache is up-to-date in JAWS
; if no msaa name is returned then fall back on getObjectName and getObjectValue which use other methods in addition to MSAA to determine the name or value (name of list item)
; called on listboxes and listviews
;***************************************************************************************
string Function getAccName ()
	var
		object o,
		int cid,
		string str,
		int TypeCode

	let TypeCode = getObjectTypeCode()
	let o = getFocusObject(cid)
	if o then
		
		if TypeCode == wt_listbox || TypeCode == wt_listboxItem || TypeCode == wt_listview || TypeCode == WT_LISTVIEWITEM  then
			let str = o.accName(cid)
		Else
			let str = getObjectName()
		Endif
		if o.accRole(cid) == role_system_list then ; we are on parent not simple child, should cover listView and listbox
			let str = o.accName(1) ; announce first item if nothing is focused
		Endif
	Endif ; object exists?

	if !str then
		if TypeCode == wt_listbox || TypeCode == wt_listboxItem || TypeCode == wt_listview || TypeCode == WT_LISTVIEWITEM then
			let str = getObjectValue()
		else
			let str = getObjectName()
		EndIf
	Endif

	return str

EndFunction

;***************************************************************************
string Function getAccValue ()
	var
		object o,
		int cid,
		string str,
		int TypeCode

	let TypeCode = getObjectTypeCode()
	let o = getFocusObject(cid)
	if o then
		if TypeCode == wt_listbox || TypeCode == wt_listview || TypeCode == wt_listboxItem || TypeCode == WT_LISTVIEWITEM ||
			TypeCode == wt_treeview then
			let str = o.accName(cid)
		else
			; let str = o.accValue(cid)
			let str = getObjectValue()
		Endif
		if o.accRole(cid) == role_system_list then ; we are on parent not simple child, should cover listView and listbox
			let str = o.accName(1) ; announce first item if nothing is focused
		Endif
	Endif ; object exists?

	if !str then
		let str = getObjectValue()
	Endif

	return str

EndFunction

;***************************************************************************************
; currently only returns checked and/or not selected
; getObjectName() is often wrong and this can be used to get the real msaa name as long as the msaa cache is up-to-date in JAWS
string Function getAccState ()
	var
		object o,
		int cid,
		int ret,
		string str

	let o = getFocusObject(cid)
	if o then
		let ret = o.accState(cid)
	EndIf

	if ret & state_system_focused && ret & state_system_selectable && !(ret & state_system_selected) then
		let str = msgNotSelected
	endif

	if ret & state_system_checked then
		let str = str + msgSpace + msgChecked
	Endif

	return str

EndFunction

;****************************************************************************************************
; use to overwrite default speech for itmes when arrow keys are used and custom properties exist
; for listbox when focus changes within object
; arrow, home, end in listbox
; arrows, home, end in listview
;****************************************************************************************************
Void Function sayObjectActiveItem(int speakPositionInfo)
var
	string strValue,
	string strState,
	int iResultValue,
	int iResultState

	; sayString("sayObjectActiveItem")

	if getObjectTypeCode() == wt_tabcontrol && getWindowStyleBits(getCurrentWindow()) & window_style_tabsWithButtons then  ; tabs with buttons or flat buttons
		say(getAccState(),ot_item_state) ; Makes JAWS say "not selected" when a tab is in focus but not selected (possible on this type of tab control)
	endif

	if stringContains("lb lm lx lv", getListType(getObjectSubtypeCode())) then
		let iResultValue = VA508GetComponentProp(getFocus(), VA508_FieldName_Value, VA508_Cache_Update, strValue)
		let iResultState = VA508GetComponentProp(getFocus(), VA508_FieldName_State, VA508_Cache_Use, strState)
		if  iResultValue > 0 then
			if giSuppressValue then
				let giSuppressValue = false
			Endif
			say(strValue,ot_selected_item)
		Else
			say(getAccName(),ot_selected_item) ; getObjectValue() is wrong when extended selection is on
		Endif
		if  iResultState > 0 then
			if giSuppressState then
				let giSuppressState = false
			Endif
			say(strState,ot_item_state)
		Else
			say(getAccState(),ot_item_state)  ; will announce not selected if the item is not selected in extended selection mode
		Endif
		if speakPositionInfo then 
			sayMessage(ot_position,PositionInGroup ()) 
		Endif
		return
	endif

	sayObjectActiveItem(speakPositionInfo)

EndFunction

;****************************************************************************************************
; use to overwrite default speech for itmes when arrow keys are used and custom properties exist
; arrows, home, end in treeview
; currently doesn't handle custom states, position, level, information etc.
;****************************************************************************************************
Void Function ActiveItemChangedEvent (handle curHwnd, int curObjectId, int curChildId, handle prevHwnd, int prevObjectId, int prevChildId)
	var
		int iObjType,
		int level,
		string strValue,
		string strState,
		int iResultValue,
		int iResultState

	; sayString("active item changed")
	Let iObjType = GetObjectSubtypeCode ()

	If (WT_TREEVIEW == iObjType || WT_TREEVIEWITEM == iObjType) && !MenusActive() then
		;SayTreeViewLevel (true) ; calls sayTreeViewItem even though you would not expect it to to say name, level, also says position in group
		; level change
		let iResultValue = VA508GetComponentProp(getFocus(), VA508_FieldName_Value, VA508_Cache_Update, strValue)
		let iResultState = VA508GetComponentProp(getFocus(), VA508_FieldName_State, VA508_Cache_Use, strState)

		let level = getTreeViewLevel()
		if level != PreviousTreeviewLevel then
			sayMessage(ot_position,msgLevel + IntToString(level), IntToString(level))
			let PreviousTreeviewLevel = level
		Endif

		; value
		if !giSuppressValue then ; don't announce value because ChangeEvent will catch it
			if iResultValue > 0 then
				say(strValue,ot_selected_item)
			Else
				say(getAccValue(),ot_selected_item) ;also contains state
			Endif
		Else
			if iResultValue > 0 then
				say(strValue,ot_selected_item)
				let giSuppressValue = false
			Endif		
		Endif

		; never suppress open/closed states on tree views even if the framework has state data
		SayTVFocusItemExpandState (curhwnd)
		if giSuppressState then
			if iResultState > 0 then
				say(strState,ot_item_state)
				let giSuppressState = false
			Endif
		Else ; if we have a custom state but the event didn't fire still speak it
			if iResultState > 0 then
				say(strState,ot_item_state)
			Endif
		Endif

		; position info, always speak it, never get it from the framework
		SayMessage(ot_position, PositionInGroup())

		return

	Endif

	ActiveItemChangedEvent (curHwnd, curObjectId, curChildId, prevHwnd, prevObjectId, prevChildId)

Endfunction

;**********************************************************************************************************
; overwritten so when this function is called from saytree viewLevel in ActivateItemChangedEvent the item will not be spoken because we have a custom value that represents a custom name for the focused tree view item
void function SayTreeViewItem()
	if giSuppressValue then ; don't announce value because ChangeEvent will catch it
		return
	Endif

	sayTreeViewItem()

EndFunction

;*****************************************************************************************************
Void Function FocusChangedEvent (handle FocusWindow, handle PrevWindow)
	let giCancelEvent = true
	let giDidFocusChange = true
	FocusChangedEvent (FocusWindow, PrevWindow)
EndFunction

;********************************************************************************************************
Void Function KeyPressedEvent (int nKey, string strKeyName, int nIsBrailleKey, int nIsScriptKey)
	let giCancelEvent = false
	; sayInteger(nkey)
	;if nKey == 69206331 then
	if nKey == 2097467 then
		if giDebugMode then
			let giDebugMode = 0
		Else
			let giDebugMode = 1
		Endif
	Endif
	KeyPressedEvent (nKey, strKeyName, nIsBrailleKey, nIsScriptKey)
EndFunction

;********************************************************************************************************
void Function MouseButtonEvent (int eventID, int x, int y)
	let giCancelEvent = false
	MouseButtonEvent (eventID, x, y)
EndFunction


;**********  ListView navigation with Ctrl+Alt+arrows/Home/End.
; Borrowed from freely available code written by Doug Lee

; Original CVS Id: listtbl.jss,v 1.7 2006/01/11 13:22:22 dgl Exp
; Module Prefix:  lt/lt_
; Purpose:  Makes JAWS ctrl+alt commands navigate ListViews as if they were tables.  Drop in (ahead of default) and enjoy.
;
; Interface:  No callable functions inside.
; Overrides:  scripts down/up/prior/next/sayCell, first/lastCellInTable, moveToTop/BottomOfColumn, moveToStart/EndOfRow.
;
; Author:  Doug Lee
;
; Revision History:  See CVS.

globals
	int lt_suppressHighlight,
	handle lt_lastWin,
	int lt_lastCol

string function lt_stringCast(variant v)
	; Cast of anything to string, to make the compiler happy in a few places.
	return v
endFunction

string function lt_stringSegmentWithMultiCharDelim(string s, string sep, int idx)
	; Same as stringSegment but with multi-character delimiters.
	; Used in breaking up MSAA accDescription strings containing multiple ListView column names/values.
	var
		int pos
	let idx = idx -1
	while stringLength(s) && idx
		let pos = stringContains(s, sep)
		if !pos then
			return ""
		endIf
		let s = stringChopLeft(s, pos+stringLength(sep) -1)
		let idx = idx -1
	endWhile

	let pos = stringContains(s, sep)
	if pos then
		let s = stringLeft(s, pos-1)
	endIf

	return s

endFunction

int function lt_canTryLVCalls()
	; Returns True if it is ok to try the lv* functions, which became available in JAWS 5.10.
	;return (getJfwVersion() >= 510000)

	return False

endFunction

int function lt_getMSAARect(object o, int childID, int byRef left, int byRef right, int byRef top, int byRef bottom)
; Get the bounding rectangle for the given MSAA object and childID.
; The rectangle is returned 1-based, as JAWS likes its rectangles.
; MSAA provides 0-based left/top/width/height.

	o.accLocation(intRef(left), intRef(top), intRef(right), intRef(bottom), childID)

	if !left && !right && !top && !bottom then
		return False
	endIf

	; but we want 1-based left/right/top/bottom.
	let left = left +1
	let top = top +1
	let right = left +right
	let bottom = top +bottom

	return True

endFunction

int function lt_move(string where)
; Move to and announce the requested "cell" of the focused ListView control,
; or left-click or right-click the current cell or its header.
; Where:
;	- Left/right/up/down to move one cell.
;	- Home/end for start/end of row.
;	- Top/bottom for top/bottom of current column.
;	- First/last for first/last cell in view.
;	- Here for current cell.
;	- (Cell|Header)Click(Left|Right) to left- or right-click the current cell or its header.
	var
		int useLV, string moveFunc,
		handle hwndList, handle hwndHeader,
		object oList, int rowIdx, int rowCount,
		object oHeader, int colIdx, int colCount,
		int sayRow, int sayCol, int sayCell,
		int rowSaid,
		string buf, int pos,
		int sayColPos, int sayRowPos

	if !isPCCursor() || userBufferIsActive() || menusActive() then
		return False
	endIf
	let hwndList = getFocus()

	; Figure out if this is a control with which we can do anything useful.
	; Also figure out if we can use JAWS 5.10+ lv* calls or whether we must use MSAA instead.
	let useLV = lt_canTryLVCalls()
	if useLV then
		let useLV = (lvGetNumOfColumns(hwndList))
	endIf
	if !useLV && getWindowTypeCode(hwndList) != WT_ListView then
		return False
	endIf

	; Reset the column index when we move from one list to another.
	if lt_lastWin != hwndList then
		let lt_lastWin = hwndList
		let lt_lastCol = 1
	endIf

	; Get the list's MSAA object even if we will be using lv* calls.
	; Reason: lvSetFocusItem() and setCurrentItem() seem unreliable; they can return 1 but still change nothing.
	; This is just in case we need to use accSelect.
	let oList = getObjectFromEvent(hwndList, 0-4, 0, rowIdx)
	if !oList then
		sayMessage(OT_Error, "List access error")
		return True  ; don't go on to try a table access
	endIf

	; Get the current list item and header info.
	if useLV then
		let rowIdx = getCurrentItem(hwndList)
		if !rowIdx then
			sayMessage(OT_Error, "Nothing selected")
			return True
		endIf
		let rowCount = getItemCount(hwndList)
		let colIdx = lt_lastCol
		; May be 0 or out of range; leave it that way for now.
		let colCount = lvGetNumOfColumns(hwndList)
	else  ; use MSAA
		; List info
		let rowIdx = oList.accFocus +0
		if !rowIdx then
			sayMessage(OT_Error, "Nothing selected")
			return True
		endIf
		let rowCount = oList.accChildCount -1  ; -1 to account for the header object

		; Header info
		let hwndHeader = getFirstChild(hwndList)
		if !hwndHeader then
			sayMessage(OT_Error, "List headers not found")
			return True
		endIf
		let oHeader = getObjectFromEvent(hwndHeader, 0-4, 0, colIdx)
		if !oHeader then
			sayMessage(OT_Error, "List header access error")
			return True
		endIf
		let colIdx = lt_lastCol
		; May be 0 or out of range; leave it that way for now.
		let colCount = oHeader.accChildCount +0
	endIf

	; Set rowIdx, colIdx, sayCol, sayRow, sayColPos, sayRowPos, and sayCell based on the navigation request.
	; Also set moveFunc if the list item is changing.
	let sayCol = False
	let sayRow = False
	let sayColPos = False
	let sayRowPos = False
	let sayCell = True
		let moveFunc = ""

	if where == "left" then
		let colIdx = colIdx -1
		let sayCol = True

	elif where == "right" then
		let colIdx = colIdx +1
		let sayCol = True

	elif where == "up" then
		let rowIdx = rowIdx -1
		let sayRow = True
		let moveFunc = "priorLine"

	elif where == "down" then
		let rowIdx = rowIdx +1
		let sayRow = True
		let moveFunc = "nextLine"

	elif where == "home" then
		let colIdx = 1
		let sayCol = True

	elif where == "end" then
		let colIdx = colCount
		let sayCol = True

	elif where == "top" then
		let rowIdx = 1
		let sayRow = True
		let moveFunc = "JAWSHome"

	elif where == "bottom" then
		let rowIdx = rowCount
		let sayRow = True
		let moveFunc = "JAWSEnd"

	elif where == "first" then
		let rowIdx = 1
		let colIdx = 1
		let sayCol = True
		let sayRow = True
		let moveFunc = "JAWSHome"

	elif where == "last" then
		let rowIdx = rowCount
		let colIdx = colCount
		let sayCol = True
		let sayRow = True
		let moveFunc = "JAWSEnd"

	elif where == "here" then
		; No navigation.
		let sayCol = True
		let sayRow = True
		let sayColPos = True
		let sayRowPos = True

	elif where == "cellClick" then  ; left or right
		; SayCell already set.

	elif where == "headerClick" then  ; left or right
		let sayCell = False
		let sayCol = True

	else
		sayMessage(OT_Error, "Unknown navigation: " +where)
		return True

	endIf

	; Enforce boundaries and update the remembered last-visited column index.
	if !moveFunc then
		; Row boundaries are determined by the control itself when key sending is used to move focus; see below.
		if rowIdx < 1 then
			beep()
			let rowIdx = 1
			let moveFunc = ""
		elif rowIdx > rowCount then
			beep()
			let rowIdx = rowCount
			let moveFunc = ""
		endIf
	endIf

	if colIdx < 1 then
		beep()
		let colIdx = 1

	elif colIdx > colCount then
		beep()
		let colIdx = colCount
	endIf

	let lt_lastCol = colIdx

	; Move focus if necessary but prevent the speaking of highlighting.
	if moveFunc then
		let lt_suppressHighlight = True
		if moveFunc then
			; This is the preferred way of changing focus:  It's what the app will expect, and it won't focus something without scrolling it into view.
			if formatStringWithEmbeddedFunctions("<" +moveFunc +">") == 0 then
				beep()
			endIf
		elif useLV then
			; LvSetFocusItem() and setCurrentItem() seem unreliable; they can return 1 but still change nothing.
			; We therefore still use MSAA here, which is why we got the MSAA object earlier regardless of useLV.  [DGL, 2006-01-11, JAWS 6.20]
			;SetCurrentItem(hwndList, rowIdx)
			oList.accSelect(3, rowIdx)
		else
			oList.accSelect(3, rowIdx)
		endIf
		pause()
		; The stopSpeech is still here even though we suppress highlighting via the global lt_suppressHighlight variable.
		; This is because app-specific scripts with their own sayHighlightedText functions can (and often do) speak their own highlighting, thus defeating the lt_suppressHighlight approach.
		; For some reason, using only stopSpeech seems to allow a split second of unwanted speech unless the lt_suppressHighlight method is also used.
		; We therefore use both at once.  [DGL, 2006-01-11]
		stopSpeech()
	endIf

	; Click if a click was requested.
	if stringContains(stringLower(where), "click") then
		var
			int isRight,
			int left, int right, int top, int bottom,
			int cx, int cy
		let isRight = (stringContains(stringLower(where), "right") > 0)
		; lvGetItemColumnRect can crash the app against which it is called, so we use MSAA here.
		if !lt_getMSAARect(oHeader, colIdx, left, right, top, bottom) then
			beep()
			return False
		endIf
		let cx = (left+right) /2
		if where == "cellClick" then
			let cy = getCursorRow()
		elif where == "headerClick" then
			let cy = (top+bottom) /2
		endIf  ; cell or header
		saveCursor()  JAWSCursor()  saveCursor()
		moveTo(cx, cy)
		if isRight then
			rightMouseButton()
		else
			leftMouseButton()
		endIf
		delay(1, True)
	endIf  ; click

	; Reset the row index to what's actually the case.
	; This is to handle cases where arrows follow visual order but not item index order.
	; Example:  when a Windows Explorer Details view is sorted by type.
	; This may also be needed when a list is resorted by a click.
	if useLV then
		let rowIdx = getCurrentItem(hwndList)
	else
		let rowIdx = oList.accFocus +0
	endIf

	; Say row, column, and/or cell if appropriate.
	if useLV then
		if sayRow then
			;sayMessage(OT_Message, lt_stringCast(lvGetItemText(hwndList, rowIdx, 1)))
			;let rowSaid = True
		endIf

		if sayCol then
			sayMessage(OT_Message, lvGetColumnHeader(hwndList, colIdx))
		endIf

		if sayCell then
			if colIdx == 1 then
				if !rowSaid then
					sayMessage(OT_Message, lvGetItemText(hwndList, rowIdx, colIdx))
				endIf
			else
				sayMessage(OT_Message, lvGetItemText(hwndList, rowIdx, colIdx))
			endIf
		endIf  ; sayCell

	else  ; Use MSAA instead
		if sayRow then
			;sayMessage(OT_Message, lt_stringCast(oList.accName(1)))
			;let rowSaid = True
		endIf

		if sayCol then
			sayMessage(OT_Message, oHeader.accName(colIdx))
		endIf

		if sayCell then
			if colIdx == 1 then
				if !rowSaid then
					sayMessage(OT_Message, oList.accName(rowIdx))
				endIf
			else
				let buf = oList.accDescription(rowIdx)
				let pos = stringContains(buf, lt_stringCast(oHeader.accName(colIdx)) +":")
				if !pos then
					let buf = lt_stringSegmentWithMultiCharDelim(buf, ", ", colIdx-1)  ; -1 because the first column is not included in accDescription
					if !stringLength(buf) then
						sayMessage(OT_Error, "Can't find column value")
						return True
					endIf
				else
					let buf = stringChopLeft(buf, pos +stringLength(oHeader.accName(colIdx)) +1)
					if colIdx < colCount then
						let pos = stringContains(buf, lt_stringCast(oHeader.accName(colIdx+1)) +":")
						if pos then
							let buf = stringLeft(buf, pos-1)
						else
							;sayMessage(OT_Error, "Can't find end of cell value")
							beep()
							; allow the overly long value to speak though
						endIf
					endIf
				endIf
				sayMessage(OT_Message, buf)
			endIf
		endIf  ; sayCell
	endIf  ; LV vs. MSAA

	if sayRowPos then
		sayMessage(OT_Position, "Row " +intToString(rowIdx) +" of " +intToString(rowCount))
	endIf

	if sayColPos then
		sayMessage(OT_Position, "Column " +intToString(colIdx) +" of " +intToString(colCount))
	endIf

	return True

endFunction

void function lt_clearSuppressHighlight()
	let lt_suppressHighlight = False
endFunction

script downCell()
	if !lt_move("down") then
		performScript downCell()
	endIf
endScript

script upCell()
	if !lt_move("up") then
		performScript upCell()
	endIf
endScript

script priorCell()
	if !lt_move("left") then
		performScript priorCell()
	endIf
endScript

script nextCell()
	if !lt_move("right") then
		performScript nextCell()
	endIf
endScript

script moveToTopOfColumn()
	if !lt_move("top") then
		performScript moveToTopOfColumn()
	endIf
endScript

script moveToBottomOfColumn()
	if !lt_move("bottom") then
		performScript moveToBottomOfColumn()
	endIf
endScript

script moveToStartOfRow()
	if !lt_move("home") then
		performScript moveToStartOfRow()
	endIf
endScript

script moveToEndOfRow()
	if !lt_move("end") then
		performScript moveToEndOfRow()
	endIf
endScript

script firstCellInTable()
	if !lt_move("first") then
		performScript firstCellInTable()
	endIf
endScript

script lastCellInTable()
	if !lt_move("last") then
		performScript lastCellInTable()
	endIf
endScript

script sayCell()
	if !lt_move("here") then
		performScript sayCell()
	endIf
endScript

script ltLeftClickCell()
	if !lt_move("cellClickLeft") then
		sayCurrentScriptKeyLabel()
		typeCurrentScriptKey()
	endIf
endScript

script ltRightClickCell()
	if !lt_move("cellClickRight") then
		sayCurrentScriptKeyLabel()
		typeCurrentScriptKey()
	endIf
endScript

script ltLeftClickHeader()
	if !lt_move("headerClickLeft") then
		sayCurrentScriptKeyLabel()
		typeCurrentScriptKey()
	endIf
endScript

script ltRightClickHeader()
	if !lt_move("headerClickRight") then
		sayCurrentScriptKeyLabel()
		typeCurrentScriptKey()
	endIf
endScript

;*******************************************
; called when left/right arrows are used in tree views
; and when checkboxes are clicked 
void function ObjStateChangedEvent(handle hObj, int iObjType, int nChangedState, int nState, int nOldState)
	; force v508 change event state from speaking state 
	giSuppressState = false 

	if iObjType == wt_treeview || iObjType == wt_treeviewItem then
		sayLine(0)
		return
	endif

	ObjStateChangedEvent(hObj, iObjType, nChangedState, nState, nOldState)

EndFunction


;===============================================================================
;
; Code supporting custom commands sent directly to the framework by keystrokes listed in the app.jkm file.
; This code includes constants, a script called by all such keys, and overrides to provide help for these keys.
; Help for custom keys is located in the Custom Command Help section of the app.jcf file.
; Keys in this section take the form short1=..., long1=..., short2=..., etc.
; "Short" is the short (Synopsis) help text, and long is the longer (description) text.
; Warning:  Each .jcf line should be less than 255 characters long.
;
; Overrides:  Functions GetScriptSynopsis and GetScriptDescription.
; This section uses the VA508SendMessage function and the gbVA508needToLinkToDLL global variable.

const
; Name of the below script
; jkm lines should look like, for example,  F1=VA508SendCustomCommand(1)
	VA508_Custom_Command_Script = "VA508SendCustomCommand",

; Offset added to the cmdno passed to the script to get the LParam value for SendMessage.
	VA508_Custom_Command_Offset = 0x100000,

; app.jcf section name for help text
	VA508_Custom_Command_Help_Section = "Custom Command Help",

; Prefixes for command synopses and descriptions, the full key being one of these plus the command number.
	VA508_Custom_Command_Help_Prefix1 = "short",
	VA508_Custom_Command_Help_Prefix2 = "long"

;*******************************************
; Called from the application .jkm file to send custom messages to the framework.
; Example jkm line:  F1=VA508SendCustomCommand(1)
;*******************************************
script VA508SendCustomCommand(int cmdno)
	var
		handle hwnd,
		int WParam,
		int LParam

	if gbVA508needToLinkToDLL then
		sayMessage(OT_Error, "Framework not connected")
		return
	endIf

	let hwnd = ghVA508DLLWindow
	let WParam = 0
	let LParam = cmdno +VA508_Custom_Command_Offset

	VA508SendMessage(hwnd, WParam, LParam)

endScript

;*******************************************
; Retrieve help text for custom commands.
; Scr is the script name (VA508SendCustomCommand).
; Cmdno is the command number being queried.
; Extended is True for long (Description) text and False for short (Synopsis) text.
;*******************************************
string function getCustomScriptHelpText(string scr, int cmdno, int extended)
	var
		string sSect,
		string sKey,
		string sFile,
		string helpBuf

	let sFile = findJAWSSettingsFile(getActiveConfiguration() +".jcf")

	if !fileExists(sFile) then
		; No file, no custom help.
		return ""
	endIf

	let sSect = VA508_Custom_Command_Help_Section
	if extended then
		let sKey = VA508_Custom_Command_Help_Prefix2
	else
		let sKey = VA508_Custom_Command_Help_Prefix1
	endIf

	let sKey = sKey +intToString(cmdno)
	let helpBuf = iniReadString(sSect, sKey, "", sFile)

	return helpBuf

endFunction

;*******************************************
; Pull the command number being queried from the jkm line for the just-pressed keystroke.
;*******************************************
int function getCustomCommandNumber()
	var
		string keyName,
		string scr

	; This pulls the current script name with parameters.
	let keyName = getCurrentScriptKeyName()
	let scr = getScriptAssignedTo(keyName)

	; and this pulls out the number in parentheses.
	let scr = stringChopLeft(scr, stringContains(scr, "("))
	let scr = stringLeft(scr, stringContains(scr, ")") -1)

	return stringToInt(scr)

endFunction

;*******************************************
; Implements GetScriptSynopsis and GetScriptDescription below.
; Returns custom help if found and normal (jsd) help if not.
;*******************************************
string function getScriptHelpText(string scr, int extended)
	var
		int cmdno,
		string helpBuf

let helpBuf = ""

	if stringCompare(scr, VA508_Custom_Command_Script, False) == 0 then
		let cmdno = getCustomCommandNumber()
		let helpBuf = getCustomScriptHelpText(scr, cmdno, extended)
		if helpBuf then
			return helpBuf
		endIf
	endIf

	if extended then
		return getScriptDescription(scr)
	else
		return getScriptSynopsis(scr)
	endIf

endFunction

;*******************************************
; Override of standard JAWS function.
;*******************************************
string function getScriptSynopsis(string scr)
	return getScriptHelpText(scr, False)
endFunction

;*******************************************
; Override of standard JAWS function.
;*******************************************
string function getScriptDescription(string scr)
	return getScriptHelpText(scr, True)
	;va508getApplicationData(getFocus(),va508_queryCode_all)
	;sayString(VA508GetStringValue(va508_fieldname_data_status))
	;sayString(gsva508data)
endFunction

;*******************************************
; Return status of focus change suppression so we can prevent double speaking if HandleCustomWindows is extended in application specific script file.
;*******************************************
Int Function SuppressFocusChange  ()
	return(glbSuppressFocusChange )
EndFunction

; ProcessEventOnFocusChangedEventEx
; when in a GRID view, use ActiveItemEvent logic to suppress speaking of WindowName and ttype for each move.
void function ProcessEventOnFocusChangedEventEx(handle hwndFocus, int nObject, int nChild, handle hwndPrevFocus, int nPrevObject, int nPrevChild, int nChangeDepth, string sClass, int nType)

	if hwndFocus == hwndPrevFocus && nType == WT_LISTBOX && StringCompare (sClass, "TCaptionStringGrid") == 0 then 
		;Say ("Process Event 1", OT_JAWS_MESSAGE)
		
		ActiveItemChangedEvent (hwndFocus, nObject, nChild, hwndPrevFocus, nPrevObject, nPrevChild)
		SayMessage (OT_POSITION, PositionInGroup ())
	Else
		;Say ("Process Event 2", OT_JAWS_MESSAGE)
		
		ProcessEventOnFocusChangedEventEx (hwndFocus, nObject, nChild, hwndPrevFocus, nPrevObject, nPrevChild, nChangeDepth, sClass, nType)
	EndIf 

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

