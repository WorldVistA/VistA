
; Header file for CAPRI code.
; contains constansts and globals 

Const	
WC_MainAppWindow = "TfrmMain",
WC_PatientListAppWindow  = "TfrmPatientList"  ,
WN_Main_ReportsTab = "Reports",
WN_Main_AdminTab = "Admin",
WN_Main_AddressTab = "Address",
WN_Main_AppointmentTab = "Appointments",
WN_CP_ClaimRequired  = "Required?:", 
	WN_CP_LastRatingExamDate = "Last Rating Exam Date:",
;  window Classes 
	WC_PatientListBox = "TfrmPatientList",
	WC_CAPTION_LISTBOX = "TCaptionListBox",
	WC_DateTimePicker = "TDateTimePicker",
	WC_MSAATabControl = "TTab95Control",
	WC_ParentTComboEdit = "TFMComboBox",
; Function Names for schedule events
	csFN_PatientListSpeak = "SpeakPatientListUpdates" 
GLOBALS
	handle gprevFocus ,
	string gs_DelphiApplicationName,
	string gsVA508cacheGridColHdr,
	handle ghFromChangeEvent ,
	int gbVA508suppressEcho ,
	int giCancelEvent ,
	int giSuppressCaption ,
	int giSuppressControlType ,
	int giSuppressControlType ,
	int giSuppressValue ,
	int giSuppressInstructions ,
	int giSuppressItemInstructions ,
	int giSuppressState ,
	string gsVA508cacheGridRowHdr,
	string gsVA508cacheGridCellVal ,
int giVA508cacheGridColNum,
	int giVA508cacheGridRowNum,

	
	int giDidFocusChange ,
int giSpokeCellUnit ,
	collection Delphi_AppDefined 
/* 

const ; Framework constants taken from VA508JAWS.jss (should be migrated to a jsh file)
	VA508_Cache_Mils = 2000,  ; 2 seconds
*/ 

; iCacheHandling values for VA508getComponentProp()
; See that function for more about these constants.
const 
	VA508_Cache_Use = 0,  ; Use the cache but don't force it to update
	VA508_Cache_Update = 1,  ; Update the cache, then use it
	VA508_Cache_Skip = 2,  ; Don't touch the cache at all, just pull straight from Framework
; Constant used to indicate that the framework sent a null property value explicitly.
; When a cache property value is actually null, it means the framework did not send a value for that property at all.
; This means either there was an error (VA508_QueryCode_Error dataStatus bit set)
; or the property has no value in the framework (appropriate VA508_QueryCode_* dataStatus bit for the property NOT set).
	VA508_Cache_Explicit_Null = " ",
; Names of data structure elements, found in the data structure itself (gsVA508varData).
; Pass these to VA508GetStringValue() to get values by name.
	VA508_FieldName_Caption = "Caption",
	VA508_FieldName_Value = "Value",
	VA508_FieldName_Control_Type = "ControlType",
	VA508_FieldName_State = "State",
	VA508_FieldName_Instructions = "Instructions",
	VA508_FieldName_Item_Instructions = "ItemInstructions",
	VA508_FieldName_Data_Status = "DataStatus"

; Query bits to retrieve each of the above items except Data_Status.
; These are passed to VA508GetApplicationData().
; iDataStatus comes back with the same flags to indicate what was actually retrieved.
const 
	VA508_QueryCode_Caption = 0x000001L,
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
	VA508FrameWork_ReadOnlyLabel = " Read Only.",
	VA508FrameWork_DisabledLabel = " Disabled field. ",
VA508FrameWork_ValueLabel = "Value is "


