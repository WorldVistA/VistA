
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
	
	; Default includes from JAWS
	include "HjConst.jsh"
	include "hjglobal.jsh"
	include "common.jsm"
	
	Include "UIA.jsh"
	Import "UIA.jsd"
	use "UIA.jsb"

; constants are differentiated by underscores between words,
Const	
; Not used by any code in this file, but read by JAWS.SR from this file to determine if the script file should be updated with a newer version
	VA508_Script_Version = 15,
; Site specific library used in  PerformFunction()
	VA508_SITE_LIBRARY  = "VA508JAWS_SiteCode::"

/***************************************************************
The below line is used to dynamically add "include" files
as outlined in the VA508ScriptList.ini. Please do not remove
***************************************************************/
	;VA508_FRAMEWORK_USES




/***************************************************************
Below is the Application specific code (Code written by SRA )

This script will be converted to the host applicaion name .jss file
(example: this file becomes CPRSChart.jss). If you wish to overwrite
this file you may create a manual version of the JSS for that specific
application however it will not use any code listed below. This script
is intended for global functions not specific to an application.

If you wish to make an application spcific script and maintain any code
outlined in this file please create/modify a new DelphiLib file and add 
to the scriptlist ini file. You may tell your DelphiLib file to compile 
inside this file as outlined in the ini
***************************************************************/

GLOBALS
	collection Delphi_AppDefined, 
	string gs_DelphiApplicationName
	
Function AutoStartEvent () ; Set globals used for determineing specific application being run

; *** 08 Jul 2016, String handling routine added in response to apparent change in way GetActiveConfiguration behaves in VA environment under JAWS 17
;      Even with parameter set to 0 or null, GetActiveConfiguration is returning UNC path in addition to config name
;      Routine replaces backslashes with question marks to ease string handling and trims UNC path up to config name --  Margaret Rood for Freedom Scientific


var
	string sActiveConf
	
	let sActiveConf=GetActiveConfiguration()
	If GetJFWVersion () >= 17000  && StringContains (sActiveConf,"\\")
	   let sActiveConf = StringReplaceSubstrings (sActiveConf, "\\","?")
	   let sActiveConf = StringChopLeft (sActiveConf, StringLength (sActiveConf) - (StringContains (StringReverse (sActiveConf), "?") - 1))
	EndIf

	gs_DelphiApplicationName  = sActiveConf

	; initialize customized handlers 
	Delphi_AppDefined  = new collection 
	SiteCodeInitialize ()

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
; Below code is generalized and should not do specific functions. Specific application functions will be called from the wrapper (DelphiLIB file).
; ***

Script SpeakControlInfo () ;Ctrl + Alt + Shift + S
var
	string sControlName,
	string parm2,
	string parm3,
	string parm4,
	string parm5,
	string parm6,
	string parm7,
	string parm8

	;sayControlEx(getCurrentWindow(), getObjectName(), getObjectSubtype(), getAccState())
	;SayControl (GetFocus ())
	;SayControlEx (GetFocus (), sControlName)
	;SayControlEx (getFocus (), parm2, parm3, parm4, parm5, parm6, sControlName)
	;Say (sControlName, OT_Jaws_Message)
	SayWindow (GetFocus (), 0)	
		
EndScript

Script SayWindowsClass () ;Assigned to JawsKey + Shift + W

	SayMessage (OT_JAWS_MESSAGE, "Class is " + GetWindowClass (GetFocus ()))

EndScript

Script SayRealWindowClass () ;Assigned to JawsKey + Shift + R

	SayMessage (OT_JAWS_MESSAGE, "Real Window Class is " + GetWindowClass (GetRealWindow (GetFocus ())))

EndScript


Script SayPanelItem () ;Assigned to JawsKey + Control + Z

	Say (GetTextInFocusRects (GetFocus ()), OT_JAWS_MESSAGE)

EndScript

Script ShowUIAInfo () ;Assigned to JawsKey + Alt + Shift + W
	var
		object oUIA = CreateObjectEx ("FreedomSci.UIA", 0, "UIAScriptAPI.x.manifest"),
		object oFocusElement = FSUIAGetFocusedElement (),
		;object oFocusElement = oUIA.ElementFromHandle (GetFocus ()),
		object oAcc = CreateObject ("IAccessible", "Accessibility.dll"),
		string sText = ""

	UserBufferDeactivate ()
	UserBufferClear ()
	UserBufferAddText ("CPRS Chart")
	UserBufferAddText ("---")
	UserBufferAddText ("Name")
	UserBufferAddText (oFocusElement.Name)
	UserBufferAddText ("---")
	UserBufferAddText ("NameProperty")
	UserBufferAddText (oFocusElement.NameProperty)
	UserBufferAddText ("---")
	UserBufferAddText ("ControlType")
	UserBufferAddText (oFocusElement.ControlType)
	UserBufferAddText ("---")
	UserBufferAddText ("ClassName")
	UserBufferAddText (oFocusElement.ClassName)
	UserBufferAddText ("---")
	UserBufferAddText ("Value")
	UserBufferAddText (oFocusElement.Value)
	UserBufferAddText ("---")
	UserBufferAddText ("Description")
	UserBufferAddText (oFocusElement.Description)
	UserBufferAddText ("---")
	UserBufferAddText ("Automation ID")
	UserBufferAddText (oFocusElement.AutomationId)
	UserBufferAddText ("---")
	UserBufferAddText ("Description2")
	UserBufferAddText (oAcc.accDescription)
	UserBufferAddText ("=================================")
	UserBufferAddText ("AcceleratorKey	= ")
	UserBufferAddText (oFocusElement.AcceleratorKey)
	UserBufferAddText ("AccessKey	= ")
	UserBufferAddText (oFocusElement.AccessKey)
	UserBufferAddText ("Annotation Objects	= " + intToString (oFocusElement.AnnotationObjects))
	UserBufferAddText ("Annotation Types	= " + intToString (oFocusElement.AnnotationTypes))
	UserBufferAddText ("AriaProperties	= " + intToString (oFocusElement.AriaProperties))
	UserBufferAddText ("AriaRole	= " + intToString (oFocusElement.AriaRole))
	UserBufferAddText ("AutomationId	= " + intToString (oFocusElement.AutomationId))
	UserBufferAddText ("BoundingRectangle	= " + intToString (oFocusElement.BoundingRectangle))
	UserBufferAddText ("ClassName	= " + intToString (oFocusElement.ClassName))
	UserBufferAddText ("ControllerFor	= " + intToString (oFocusElement.ControllerFor))
	UserBufferAddText ("ControlType	= ")
	UserBufferAddText (oFocusElement.ControlType)
	UserBufferAddText ("Culture	= " + intToString (oFocusElement.Culture))
	UserBufferAddText ("DescribedBy	= " + intToString (oFocusElement.DescribedBy))
	UserBufferAddText ("FlowsFrom	= " + intToString (oFocusElement.FlowsFrom))
	UserBufferAddText ("FlowsTo	= " + intToString (oFocusElement.FlowsTo))
	UserBufferAddText ("FrameworkID	= " + intToString (oFocusElement.FrameworkID))
	UserBufferAddText ("FullDescription	= " + intToString (oFocusElement.FullDescription))
	UserBufferAddText ("HasKeyboardFocus	= " + intToString (oFocusElement.HasKeyboardFocus))
	UserBufferAddText ("HelpText	= " + intToString (oFocusElement.HelpText))
	UserBufferAddText ("IsContentElement	= " + intToString (oFocusElement.IsContentElement))
	UserBufferAddText ("IsControlElement	= " + intToString (oFocusElement.IsControlElement))
	UserBufferAddText ("IsDataValidForForm	= " + intToString (oFocusElement.IsDataValidForForm))
	UserBufferAddText ("IsEnabled	= " + intToString (oFocusElement.IsEnabled))
	UserBufferAddText ("IsKeyboardFocusable	= " + intToString (oFocusElement.IsKeyboardFocusable))
	UserBufferAddText ("IsOffscreen	= " + intToString (oFocusElement.IsOffscreen))
	UserBufferAddText ("IsPassword	= " + intToString (oFocusElement.IsPassword))
	UserBufferAddText ("IsPeripheral	= " + intToString (oFocusElement.IsPeripheral))
	UserBufferAddText ("IsRequiredForForm	= " + intToString (oFocusElement.IsRequiredForForm))
	UserBufferAddText ("ItemStatus	= ")
	UserBufferAddText (oFocusElement.ItemStatus)
	UserBufferAddText ("ItemType	= " + intToString (oFocusElement.ItemType))
	UserBufferAddText ("LabeledBy	= " + intToString (oFocusElement.LabeledBy))
	UserBufferAddText ("LandmarkType	= " + intToString (oFocusElement.LandmarkType))
	UserBufferAddText ("Level	= " + intToString (oFocusElement.Level))
	UserBufferAddText ("LiveSetting	= " + intToString (oFocusElement.LiveSetting))
	UserBufferAddText ("LocalizedControlType	= " + intToString (oFocusElement.LocalizedControlType))
	UserBufferAddText ("LocalizedLandmarkType	= " + intToString (oFocusElement.LocalizedLandmarkType))
	UserBufferAddText ("Name	= ")
	UserBufferAddText (oFocusElement.Name)
	UserBufferAddText ("NativeWindowHandle	= " + intToString (oFocusElement.NativeWindowHandle))
	UserBufferAddText ("OptimizeForVisualContent = " + intToString (oFocusElement.OptimizeForVisualContent))
	UserBufferAddText ("Orientation	= " + intToString (oFocusElement.Orientation))
	UserBufferAddText ("PositionInSet	= " + intToString (oFocusElement.PositionInSet))
	UserBufferAddText ("ProcessId	= ")
	UserBufferAddText (oFocusElement.ProcessId)
	UserBufferAddText ("ProviderDescription	= " + intToString (oFocusElement.ProviderDescription))
	UserBufferAddText ("SizeOfSet	= ")
	UserBufferAddText (oFocusElement.SizeOfSet)

	UserBufferActivate ()
	;UIASayElement(oFocusElement)
	;SayFormattedMessage (OT_User_Buffer, "Name=" + oFocusElement.Name)
	;+ "\n" + "Control Type=" + IntToString (oFocusElement.ControlType) + "\n" + "Class Name=" + IntToString (oFocusElement.ClassName))

EndScript

Object Function GetButtonByAutomationIDEx (string sAutomationID, int iNumber, handle hWindow) 
	Var 
		object oUIA = CreateObjectEx ("FreedomSci.UIA", 0, "UIAScriptAPI.x.manifest" ), 
		object oCondition = oUIA.CreateStringPropertyCondition (UIA_AutomationIDPropertyID, sAutomationID), 
		object oElement, 
		object oElementArray

	If !hWindow then
		hWindow = GetAppMainWindow (GetFocus ()) 
	EndIf 

	oElement = oUIA.GetElementFromHandle (hWindow) 
	oElementArray = oElement.FindAll (TreeScope_Descendants, oCondition) 

	Return oElementArray (iNumber) 

EndFunction

Script WalkThroughUIAObjects () ;Assigned to JawsKey + Control + Shift + Q
	var
		object oUIA = CreateObjectEx ("FreedomSci.UIA", 0, "UIAScriptAPI.x.manifest"), 
		object oConditionControlType = oUIA.CreateIntPropertyCondition (UIA_ControlTypePropertyId, UIA_ButtonControlTypeId), 
		object oConditionType = oUIA.CreateStringPropertyCondition (UIA_ClassNamePropertyId, "Button"), 
		;object oCondition = oUIA.CreateAndCondition (oConditionControlType, oConditionType), 
		object oCondition = oUIA.CreateTrueCondition (),
		object oElement,
		object oElementArray

	oElement = oUIA.GetElementFromHandle(GetAppMainWindow (GetFocus ()))
	oElementArray = oElement.FindAll(TreeScope_Descendants, oCondition)

	UserBufferDeactivate ()
	UserBufferClear ()

	UserBufferAddText (IntToString (oElementArray.Count))
	UserBufferAddText ("====")
	
	ForEach oElement in oElementArray
		UserBufferAddText (oElement.Name)
		UserBufferAddText (oElement.ClassName)
		UserBufferAddText (oElement.AutomationID)
		UserBufferAddText (oElement.IsOffscreen)
		UserBufferAddText (oElement.IsEnabled)
		UserBufferAddText ("---")
		
	EndForEach

	UserBufferActivate ()
	
EndScript

