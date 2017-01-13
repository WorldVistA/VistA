{ ******************************************************************************

    ___  __  ____  _  _      _    ____   __   ____  ____  ____
   / __)/  \(  _ \( \/ )    / )  (  _ \ / _\ / ___)(_  _)(  __)
  ( (__(  O )) __/ )  /    / /    ) __//    \\___ \  )(   ) _)
   \___)\__/(__)  (__/    (_/    (__)  \_/\_/(____/ (__) (____)


  This code will activly monitor and track both copy and paste from within and
  between applications.

  Components:
  TCopyApplicationMonitor
  This control is application wide and will contain the overall tracked
  clipboard.

  TCopyEditMonitor
  This control hooks into the desired tCustomEdit and monitors the WMCopy
  and WMPaste messages.

  TCopyPasteDetails
  this is the visual element that will display the detials collected by
  TCopyEditMonitor into a TRichEdit.

  Conditional Defines:
  CPLOG
  If the CPLOG conditional define is set then when a log file of the
  Copy/Paste process is created and saved in the user's
  AppData\Local\[Application name] folder. A document is created per
  process.




  -------------------------
  | TCopyApplicationMonitor |
  -------------------------
              ^
              |
              |
              |
              |
      ------------------
      | TCopyEditMonitor |
      ------------------
              ^
              |
              |
              |
              |
      -------------------
      | TCopyPasteDetails |
      -------------------


  {Modifications }

{ DONE -oChris Bell -cDisplay :(04/01/14) - Add date/time of original document
  ( if applicable) to the pasted data display. Update labels on display since
  they are misleading. }
{ DONE -oChris Bell -cDisplay :(04/01/14) Reorganize the pasted data details. }
{ DONE -oChris Bell -cEditMonitor : Create onshow and onhide events. Create events with inherited calls. }
{ DONE -oChris Bell : add sync for thread }
{ DONE -oChris Bell : (2/26/15) Create collection for track only. This will allow one component to track mulitple richedits (think templates) }
{ DONE -oChris Bell : (2/26/15) RemoveHook on destroy }
{ DONE -oChris Bell -cCopy/Paste : Make transfer protocol. Template IEN will be -3 and when transfer called it will convert all -2 to the current IEN. Will also transffer paste text over }
{ TODO -oChris Bell -cCopy/Paste : Documentation }
{ TODO : Edit of paste }
{ TODO : indents of templates }
{ TODO : Default selected parameter }
{ TODO : add logging to new code }

{ ****************************************************************************** }
{$WARN XML_CREF_NO_RESOLVE OFF}  // Cref is formatted correctly
{$WARN XML_NO_MATCHING_PARM OFF} // This is related to the cref above for HighLightInfoPanel

unit CopyMonitor;

interface

uses
  SysUtils, Classes, RichEdit, ClipBrd, Windows, Messages, Controls, StdCtrls,
  Math, ComCtrls, CommCtrl, Graphics, Forms, Vcl.ExtCtrls, Vcl.Buttons,
  VA508AccessibilityRouter, SHFolder, SyncObjs, TLHelp32, System.Rtti,
  System.TypInfo, Vcl.Dialogs, System.IniFiles;

type
  // -------- RECORDS --------//

  /// <summary>Holds information about the clipboard (if available)</summary>
  /// <param name="AppName">Name of the application<para><b>Type: </b><c>string</c></para></param>
  /// <param name="AppClass">Applications class name<para><b>Type: </b><c>string</c></para></param>
  /// <param name="AppHwnd">Handle to the application<para><b>Type: </b><c>HWND</c></para></param>
  /// <param name="AppPid">Process ID to the application<para><b>Type: </b><c>Cardinal</c></para></param>
  /// <param name="AppTitle">Applications title<para><b>Type: </b><c>string</c></para></param>
  /// <param name="ObjectHwnd">Handle to the object (owner)<para><b>Type: </b><c>HWND</c></para></param>
  tClipInfo = record
    AppName: string;
    AppClass: string;
    AppHwnd: HWND;
    AppPid: Cardinal;
    AppTitle: String;
    ObjectHwnd: HWND;
  end;

  /// <summary>Holds information about the copied/pasted text</summary>
  /// <param name="ApplicationName">Application text was copied from<para><b>Type: </b><c>String</c></para>
  /// <para><b>Example:</b> if copied from CPRS this would be <example>CPRS</example></para></param>
  /// <param name="ApplicationPackage">Application package that text came from<para><b>Type: </b><c>String</c></para>
  /// <para><b>Example:</b> if copied from CPRS this would be <example>OR</example></para></param>
  /// <param name="CopiedFromIEN">IEN where text was copied from<para><b>Type: </b><c>Integer</c></para></param>
  /// <param name="CopiedFromPackage">Package this text came from<para><b>Type: </b><c>String</c></para>
  /// <para><b>Example:</b> if copied from a note (TIU package) this would be <example>8925</example></para></param>
  /// <param name="CopiedText">Text that was copied<para><b>Type: </b><c>TStringList</c></para></param>
  /// <param name="DateTimeOfCopy"> Date and time of the copy<para><b>Type: </b><c>String</c></para></param>
  /// <param name="DateTimeOfPaste"> Date and time of the paste<para><b>Type: </b><c>String</c></para></param>
  /// <param name="OriginalText">Holds the text before any modifications<para><b>Type: </b><c>TStringList</c></para></param>
  /// <param name="PasteDBID">IEN of the paste in the paste file<para><b>Type: </b><c>Integer</c></para></param>
  /// <param name="PasteToIEN">IEN this data was pasted to<para><b>Type: </b><c>Integer</c></para></param>
  /// <param name="PercentData">The IEN and Package used for the Source. Delimited by a ;<para><b>Type: </b><c>String</c></para></param>
  /// <param name="PercentMatch">Percent that pasted text matches this entry<para><b>Type: </b><c>Double</c></para></param>
  /// <param name="SaveForDocument">Flag used to "mark" for save into note<para><b>Type: </b><c>Boolean</c></para></param>
  /// <param name="SaveItemID">ID that was used to save the item. Used to match in recalc procedure<para><b>Type: </b><c>Integer</c></para></param>
  /// <param name="SaveToTheBuffer">Flag used to "mark" for save into buffer<para><b>Type: </b><c>Boolean</c></para></param>
  TCprsClipboard = record
    ApplicationName: string;
    ApplicationPackage: string;
    CopiedFromIEN: Integer;
    CopiedFromPackage: string;
    CopiedText: TStringList;
    DateTimeOfCopy: string;
    DateTimeOfPaste: String;
    OriginalText: TStringList;
    PasteDBID: Integer;
    PasteToIEN: Integer;
    PercentData: String;
    PercentMatch: Double;
    SaveForDocument: Boolean;
    SaveItemID: Integer;
    SaveToTheBuffer: Boolean;
  end;

  /// <summary>Holds information about the ident\ifiable text</summary>
  /// <param name="LineToHighlight">The line of text that we found<para><b>Type: </b><c>WideString</c></para></param>
  /// <param name="AboveWrdCnt">Indicates if this line was above our word count (2)<para><b>Type: </b><c>Boolean</c></para></param>
  tHighlightRecord = record
    LineToHighlight: WideString;
    AboveWrdCnt: Boolean;
  end;

  /// <summary>All the identifiable text <see cref="CopyMonitor|tHighlightRecord" /></summary>
  THighlightRecordArray = Array of tHighlightRecord;

  /// <summary>Holds information about the grouped text</summary>
  /// <param name="GroupParent">This would be the text from the parent record<para><b>Type: </b><c>TStringList</c></para></param>
  /// <param name="GroupText">the text that we are grouping<para><b>Type: </b><c>TStringList</c></para></param>
  /// <param name="ItemIEN">IEN of the paste in the paste file<para><b>Type: </b><c>Integer</c></para></param>
  /// <param name="VisibleOnNote">were we able to find the text on the document<para><b>Type: </b><c>Boolean</c></para></param>
  /// <param name="HiglightLines">List of identifiable text<para><b>Type: </b><c><see cref="CopyMonitor|THighlightRecordArray" /></c></para></param>
  TGroupRecord = record
    GroupParent: Boolean;
    GroupText: TStringList;
    ItemIEN: Integer;
    VisibleOnNote: Boolean;
    HiglightLines: THighlightRecordArray;
  end;

  /// <summary>Used when loading/displaying pasted text</summary>
  /// <param name="DateTimeOfPaste">Date time of paste<para><b>Type: </b><c>string</c></para></param>
  /// <param name="DateTimeOfOriginalDoc">Date time the original document was created<para><b>Type: </b><c>string</c></para></param>
  /// <param name="UserWhoPasted">User who pasted<para><b>Type: </b><c>string</c></para></param>
  /// <param name="CopiedFromLocation">Where text was copied from<para><b>Type: </b><c>string</c></para></param>
  /// <param name="CopiedFromDocument">Document IEN where the text was copied from<para><b>Type: </b><c>string</c></para></param>
  /// <param name="CopiedFromAuthor">Author of the document where the text was copied from<para><b>Type: </b><c>string</c></para></param>
  /// <param name="CopiedFromPatient">Patient where the text was copied from<para><b>Type: </b><c>string</c></para></param>
  /// <param name="CopiedFromApplication">Application where the text was copied from<para><b>Type: </b><c>string</c></para></param>
  /// <param name="PastedPercentage">Percent matched when text was pasted<para><b>Type: </b><c>string</c></para></param>
  /// <param name="PastedText">Text that was pasted<para><b>Type: </b><c>TStringList</c></para></param>
  /// <param name="New">Flag for a new entry<para><b>Type: </b><c>Boolean</c></para></param>
  /// <param name="InfoPanelIndex">ItemIndex for this entry<para><b>Type: </b><c>Integer</c></para></param>
  /// <param name="GroupItems">Identifies this as a group of items<para><b>Type: </b><c>array of TGroupRecord</c></para></param>
  /// <param name="HiglightLines">The text used for highlighting<para><b>Type: </b><c>Array of TStringList</c></para></param>
  TPasteText = record
    CopiedFromApplication: String;
    CopiedFromAuthor: string;
    CopiedFromDocument: string;
    CopiedFromLocation: string;
    CopiedFromPatient: string;
    DateTimeOfPaste: string;
    DateTimeOfOriginalDoc: String;
    GroupItems: array of TGroupRecord;
    HiglightLines: THighlightRecordArray;
    IdentFired: Boolean;
    InfoPanelIndex: Integer;
    New: Boolean;
    OriginalText: TStringList;
    PasteDBID: Integer;
    PastedPercentage: string;
    PastedText: TStringList;
    UserWhoPasted: string;
    VisibleOnList: Boolean;
    VisibleOnNote: Boolean;
    Analyzed: Boolean;
  end;

  // -------- OverWrite Classes --------//

  /// <summary><para>Extend the TButton class</para></summary>
  TCollapseBtn = class(TButton)
  public
    procedure Click; override;
  end;

  /// <summary><para>Extend the TListBox class</para></summary>
  TSelectorBox = class(TListBox)
  private
    /// <summary>Color of the selector</summary>
    SelectorColor: TColor;
    /// <summary><para>Custom draw procedure</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <param name="Control">Control<para><b>Type: </b><c>TWinControl</c></para></param>
    /// <param name="Index">Index<para><b>Type: </b><c>Integer</c></para></param>
    /// <param name="Rect">Rect<para><b>Type: </b><c>TRect</c></para></param>
    /// <param name="State">State<para><b>Type: </b><c>TOwnerDrawState</c></para></param>
    procedure OurDrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
      State: TOwnerDrawState);
    /// <summary><para>Used to change the color when focus is set</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <param name="Message">Message<para><b>Type: </b><c>TWMSetFocus</c></para></param>
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    /// <summary><para>Used to change the color when focus is killed</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <param name="Message">Message<para><b>Type: </b><c>TWMSetFocus</c></para></param>
    procedure WMKilFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
  public
    /// <summary><para>used to fire off the correct selection</para><para><b>Type: </b><c>Integer</c></para></summary>
    procedure Click; override;
    /// <summary><para>constructor</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <param name="AOwner">AOwner<para><b>Type: </b><c>TComponent</c></para></param>
    constructor Create(AOwner: TComponent); override;
  end;

  /// <summary>The collection item for the MonitorCollection</summary>
  TTrackOnlyItem = class(TCollectionItem)
  private
    /// <summary>The collection object to monitor</summary>
    FObject: TCustomEdit;
    /// <summary>Pointer to the original WndProc</summary>
    FOurOrigWndProc: TWndMethod;
    /// <summary><para>Setter for TrackObject which also hooks into the object</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <param name="Value">The object to monitor<para><b>Type: </b><c>TCustomEdit</c></para></param>
    procedure SetTrackObject(const Value: TCustomEdit);
    /// <summary><para>Custom WndProc</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <param name="Message">Message<para><b>Type: </b><c>TMessage</c></para></param>
    procedure OurWndProc(var Message: TMessage);
  protected
    /// <summary><para>Override for GetDisplayName</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <returns><para><b>Type: </b><c>String</c></para> </returns>
    function GetDisplayName: String; override;
  public
    /// <summary><para>Assigns the customedit to the trackitem</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <param name="Source">Source<para><b>Type: </b><c>TPersistent</c></para></param>
    procedure Assign(Source: TPersistent); override;
  published
    /// <summary><para>The TCustomEdit we want to monitor</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <param name="TrackItem">TrackItem<para><b>Type: </b><c>TTrackOnlyItem</c></para></param>
    property TrackObject: TCustomEdit read FObject write SetTrackObject;
  end;

  /// <summary><para>The collection that will hold the items we want to track</para></summary>
  TTrackOnlyCollection = class(TCollection)
  private
    FOwner: TComponent;
    procedure SetObjectToMonitor(TrackItem: TTrackOnlyItem);
  protected
    function GetOwner: TPersistent; override;
    function GetItem(Index: Integer): TTrackOnlyItem;
    procedure SetItem(Index: Integer; Value: TTrackOnlyItem);
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TComponent);
    function Add: TTrackOnlyItem;
    function Insert(Index: Integer): TTrackOnlyItem;
    property Items[Index: Integer]: TTrackOnlyItem read GetItem
      write SetItem; default;
  end;

  // -------- Threads --------//

  /// <summary>Thread used to task off the lookup when pasting</summary>
  TCopyPasteThread = class(TThread)
  private
    /// <summary><para>Lookup item's <see cref="CopyMonitor|TCopyEditMonitor" /></para><para><b>Type: </b><c>TComponent</c></para></summary>
    fEditMonitor: TComponent;
    /// <summary><para>Lookup item's IEN</para><para><b>Type: </b><c>Integer</c></para></summary>
    fItemIEN: Integer;
    /// <summary><para>Lookup item's copy/paste format details</para><para><b>Type: </b><c>String</c></para></summary>
    fPasteDetails: String;
    /// <summary><para>Lookup item's text</para><para><b>Type: </b><c>String</c></para></summary>
    fPasteText: String;

    fClipInfo: tClipInfo;
  protected
    /// <summary><para>Call to execute the thread</para></summary>
    procedure Execute; override;
  public
    /// <summary><para>Constructor</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <param name="PasteText">Pasted text<para><b>Type: </b><c>String</c></para></param>
    /// <param name="PasteDetails">Pasted details<para><b>Type: </b><c>String</c></para></param>
    /// <param name="ItemIEN">Documents IEN that text was pasted into<para><b>Type: </b><c>Integer</c></para></param>
    /// <param name="EditMonitor">Documents <see cref="CopyMonitor|TCopyEditMonitor" /> that text was pasted into<para><b>Type: </b><c>TComponent</c></para></param>
    constructor Create(PasteText, PasteDetails: String; ItemIEN: Int64;
      EditMonitor: TComponent; ClipInfo: tClipInfo);
    /// <summary><para>Destructor</para></summary>
    destructor Destroy; override;
    /// <summary><para>Item IEN that this thread belongs to</para><para><b>Type: </b><c>Integer</c></para></summary>
    property TheadOwner: Integer read fItemIEN;
  end;

  // -------- Events --------//

  /// <summary>External call to allow the copy/paste functionality</summary>
  /// <param name="Sender">Object that is calling this<para><b>Type: </b><c>TObject</c></para></param>
  /// <param name="AllowMonitor">Flag indicates if this is excluded or not<para><b>Type: </b><c>Boolean</c></para></param>
  /// <remarks>Used to exclude Documents from copy/paste functionality</remarks>
  TAllowMonitorEvent = procedure(Sender: TObject; var AllowMonitor: Boolean)
    of object;

  /// <summary><para>External call to load the pasted text</para></summary>
  /// <param name="Sender">Object that is calling this<para><b>Type: </b><c>TObject</c></para></param>
  /// <param name="LoadList">Load items into this list<para><b>Type: </b><c>TStrings</c></para></param>
  /// <param name="ProcessLoad">Flag determines if loading should continue<para><b>Type: </b><c>Boolean</c></para>
  /// <remarks><b>Default:</b><c> True</c></remarks></param>
  TLoadEvent = procedure(Sender: TObject; LoadList: TStrings; var ProcessLoad: Boolean{ = true}) of object;

  /// <summary><para>External call to load the properties</para></summary>
  /// <param name="Sender">Object that is calling this<para><b>Type: </b><c>TObject</c></para></param>
  TLoadProperties = procedure(Sender: TObject) of object;

  TPollBuff = procedure(Sender: TObject; var Error: Boolean{ = false}) of object;

  /// <summary><para>Call to save the recalculated percentages</para></summary>
  /// <param name="Sender">Object that is calling this<para><b>Type: </b><c>TObject</c></para></param>
  /// <param name="SaveList">List containing items to save<para><b>Type: </b><c>TStrings</c></para></param>
  TRecalculateEvent = procedure(Sender: TObject; SaveList: TStringList)
    of object;

  /// <summary><para>External call to save the pasted text</para></summary>
  /// <param name="Sender">Object that is calling this<para><b>Type: </b><c>TObject</c></para></param>
  /// <param name="SaveList">List containing items to save<para><b>Type: </b><c>TStrings</c></para></param>
  /// <param name="ReturnList">Return list from the RPC. Used to recalculate the percentage<para><b>Type: </b><c>TStrings</c></para></param>
  TSaveEvent = procedure(Sender: TObject; SaveList: TStringList;
    var ReturnList: TStringList) of object;

  /// <summary><para>External call for Onshow/OnHide</para></summary>
  /// <param name="Sender">Object that is calling this<para><b>Type: </b><c>TObject</c></para></param>
  TVisible = procedure(Sender: TObject) of object;

  /// <summary><para>procedure that should fire for the visual message</para><para><b>Type: </b><c>Integer</c></para></summary>
  TVisualMessage = procedure(Sender: TObject; const CPmsg: Cardinal;
    CPVars: Array of Variant) of object;

  TToggleEvent = procedure(Sender: TObject; Toggled: Boolean) of object;
  TPasteArray = array of TPasteText;
  // -------- Main Components --------//

  TStopWatch = class
  private
    FOwner: TObject;
    fFrequency: TLargeInteger;
    fIsRunning: Boolean;
    fIsHighResolution: Boolean;
    fStartCount, fStopCount: TLargeInteger;
    fActive: Boolean;
    procedure SetTickStamp(var lInt: TLargeInteger);
    function GetElapsedTicks: TLargeInteger;
    function GetElapsedMilliseconds: TLargeInteger;
    Function GetElapsedNanoSeconds: TLargeInteger;
    function GetElapsed: string;
  public
    constructor Create(AOwner: TComponent; const IsActive: Boolean = false;
      const startOnCreate: Boolean = false);
    destructor Destroy; override;
    procedure Start;
    procedure Stop;
    property IsHighResolution: Boolean read fIsHighResolution;
    property ElapsedTicks: TLargeInteger read GetElapsedTicks;
    property ElapsedMilliseconds: TLargeInteger read GetElapsedMilliseconds;
    property ElapsedNanoSeconds: TLargeInteger read GetElapsedNanoSeconds;
    property Elapsed: string read GetElapsed;
    property IsRunning: Boolean read fIsRunning;
  end;

  TLogfileLevel = (LOG_SUM, LOG_DETAIL);

  TLogComponent = class
  private
    FOwner: TObject;
    FCriticalSection: TCriticalSection;
    /// <summary><para>Determines if we should log or not</para><para><b>Type: </b><c>Boolean</c></para></summary>
    fLogToFile: TLogfileLevel;
    /// <summary><para>The name of the Log File</para><para><b>Type: </b><c>String</c></para></summary>
    fOurLogFile: String;
    /// <summary><para>Gets the log file</para></summary>
    /// <returns>The name of the log file<para><b>Type: </b><c>String</c></para> - </returns>
    function GetLogFileName(): String;
    function Dump(Instance: TPasteArray): string;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure LogText(Action, MessageTxt: String);
    /// <summary>True if logging is turned on</summary>
    property LogToFile: TLogfileLevel read fLogToFile write fLogToFile;
    property LogFile: String read fOurLogFile;
  end;

  /// <summary>This is the "overall" component. Each instance of <see cref="CopyMonitor|TCopyEditMonitor" /> and/or  <see cref="CopyMonitor|TCopyPasteDetails" /> will send into this.
  /// This control holds the collection of text that was copied so that each monitor can interact with it</summary>
  TCopyApplicationMonitor = class(TComponent)
  private
    /// <summary><para>Clipboard custom format for copy/paste</para><para><b>Type: </b><c>Word</c></para></summary>
    CF_CopyPaste: Word;
    /// <summary><para>Number of characters that will halt the highlight from the background</para><para><b>Type: </b><c>Integer</c></para></summary>
    FBackGroundLimit: Integer;
    /// <summary><para>Number of characters to break up long lines at</para><para><b>Type: </b><c>Integer</c></para></summary>
    FBreakUpLimit: Integer;
    /// <summary><para>Holds all records of copied/pasted text</para>
    /// <para><b>Type: </b><c>Array of <see cref="CopyMonitor|TCprsClipboard" /></c></para></summary>
    FCPRSClipBoard: array of TCprsClipboard;
    /// <summary><para>Controls the critical section for the thread</para><para><b>Type: </b><c>TCriticalSection</c></para></summary>
    FCriticalSection: TCriticalSection;
    /// <summary><para>Controls if the user can see paste details</para><para><b>Type: </b><c>Boolean</c></para></summary>
    FDisplayPaste: Boolean;
    /// <summary><para>List of applications to exlude from the past tracking</para><para><b>Type: </b><c>TStringList</c></para></summary>
    fExcludeApps: TStringList;
    /// <summary><para>Color used to highlight the matched text</para><para><b>Type: </b><c>TColor</c></para></summary>
    FHighlightColor: TColor;
    /// <summary><para>External load buffer event</para><para><b>Type: </b><c><see cref="CopyMonitor|TLoadEvent" /></c></para></summary>
    FLoadBuffer: TLoadEvent;
    /// <summary><para>Flag that indicates if the buffer has been loaded</para><para><b>Type: </b><c>Boolean</c></para></summary>
    FLoadedBuffer: Boolean;

    fBufferTimer: TTimer;
    FBufferPolled: Boolean;
    fStartPollBuff: TPollBuff;
    fStopPollBuff: TPollBuff;
    fLCSToggle: Boolean;
    fLCSCharLimit: Integer;
    FLCSTextColor: TColor;
    FLCSTextStyle: TFontStyles;
    FLCSUseColor: Boolean;

    /// <summary><para>External load properties event</para><para><b>Type: </b><c><see cref="CopyMonitor|TLoadProperties" /></c></para></summary>
    FLoadProperties: TLoadProperties;
    /// <summary><para>Flag indicates if properties have been loaded</para><para><b>Type: </b><c>Boolean</c></para></summary>
    FLoadedProperties: Boolean;
    fEnabled: Boolean;
    /// <summary><para>Holds list of currently running threads</para><para><b>Type: </b><c>Array of <see cref="CopyMonitor|tCopyPasteThread" /></c></para></summary>
    FCopyPasteThread: Array of TCopyPasteThread;
    FLogObject: TLogComponent;
    /// <summary><para>Flag to display highlight when match found</para><para><b>Type: </b><c>Boolean</c></para></summary>
    FMatchHighlight: Boolean;
    /// <summary><para>Style to use for the matched text font</para><para><b>Type: </b><c>TFontStyles</c></para></summary>
    FMatchStyle: TFontStyles;
    /// <summary><para>The monitoring application name</para><para><b>Type: </b><c>string</c></para></summary>
    FMonitoringApplication: string;
    /// <summary><para>The monitoring application's package</para><para><b>Type: </b><c>string</c></para></summary>
    FMonitoringPackage: string;
    /// <summary><para>Number of words used to trigger copy/paste functionality</para><para><b>Type: </b><c>Double</c></para></summary>
    FNumberOfWords: Double;
    /// <summary><para>Percent used to match pasted text</para><para><b>Type:</b> <c>Double</c></para></summary>
    FPercentToVerify: Double;
    /// <summary><para>External save buffer event</para><para><b>Type: </b><c><see cref="CopyMonitor|TSaveEvent" /></c></para></summary>
    FSaveBuffer: TSaveEvent;
    /// <summary><para>Stop Watch for metric information</para><para><b>Type: </b><c><see cref="CopyMonitor|TStopWatch" /></c></para></summary>
    fStopWatch: TStopWatch;
    /// <summary><para>List of paste details (panels) to keep in size sync</para><para><b>Type: </b><c>Array of TPanel</c></para></summary>
    fSyncSizeList: Array of TPanel;
    /// <summary><para>The current users DUZ</para><para><b>Type: </b><c>Int64</c></para></summary>
    FUserDuz: Int64;
    /// <summary>Clear out all SaveForDocument parameters</summary>
    procedure ClearCopyPasteClipboard();
    /// <summary>Adds the text being copied to the <see cref="CopyMonitor|TCprsClipboard" /> array and to the clipboard with details</summary>
    /// <param name="TextToCopy">Copied text<para><b>Type: </b><c>string</c></para></param>
    /// <param name="FromName">Copied text's package<para><b>Type: </b><c>string</c></para></param>
    /// <param name="ItemID">ID of document the text was copied from<para><b>Type: </b><c>Integer</c></para></param>
    procedure CopyToCopyPasteClipboard(TextToCopy, FromName: string;
      ItemID: Integer);
    /// <summary><para>checks if should be exlcuded</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <param name="AppName">AppName<para><b>Type: </b><c>String</c></para></param>
    /// <returns><para><b>Type: </b><c>Boolean</c></para> - </returns>
    function FromExcludedApp(AppName: String): Boolean;
    /// <summary><para>Get the owner (if applicable) from the clipboard</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <returns><para><b>Type: </b><c>tClipInfo</c></para> - </returns>
    function GetClipSource(): tClipInfo;
    /// <summary>Used to calcuate percent</summary>
    /// <param name="String1">Original string</param>
    /// <param name="String2">Compare String</param>
    /// <param name="CutOff2">number of character changes to fall in the threshold</param>
    /// <returns>Percentage the same</returns>
    function LevenshteinDistance(String1, String2: String;
      CutOff: Integer): Double;
    /// <summary>Perform the lookup of the pasted text and mark as such</summary>
    /// <param name="TextToPaste">Text being pasted</param>
    /// <param name="PasteDetails">Details from the clipboard</param>
    /// <param name="ItemIEN">Destination's IEN </param>
    procedure PasteToCopyPasteClipboard(TextToPaste, PasteDetails: string;
      ItemIEN: Integer; ClipInfo: tClipInfo);
    /// <summary>Saved the copied text for this note</summary>
    /// <param name="Sender">Object that is calling this<para><b>Type: </b><c>TComponent</c></para></param>
    /// <param name="SaveList">List to save<para><b>Type: </b><c>TStringList</c></para></param>
    procedure SaveCopyPasteClipboard(Sender: TComponent; SaveList: TStringList);
    /// <summary><para>Sync all the sizes for the marked panels</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <param name="sender">sender<para><b>Type: </b><c>TObject</c></para></param>
    procedure SyncSizes(Sender: TObject);
    /// <summary>How many words appear in the text</summary>
    /// <param name="TextToCount">Occurences of</param>
    /// <returns>Total number of occurences</returns>
    function WordCount(TextToCount: string): Integer;

    procedure SetEnabled(aValue: Boolean);
  public
    /// <summary>Number of characters that will halt the highlight from the background</summary>
    Property BackGroundLimit: Integer read FBackGroundLimit
      write FBackGroundLimit;
    /// <summary>Constructor</summary>
    /// <param name="AOwner">Object that is calling this</param>
    constructor Create(AOwner: TComponent); override;
    /// <summary>CriticalSection</summary>
    property CriticalSection: TCriticalSection read FCriticalSection;
    /// <summary>Destructor</summary>
    destructor Destroy; override;
    /// <summary>Controls if the user can see paste details</summary>
    property DisplayPaste: Boolean read FDisplayPaste write FDisplayPaste;
    /// <summary>List of applications to exclude from tracking</summary>
    property ExcludeApps: TStringList read fExcludeApps write fExcludeApps;

    procedure LoadTheBufferPolled(Sender: TObject);
    property LogObject: TLogComponent read FLogObject;
    procedure LogText(Action, MessageTxt: String); overload;
    procedure LogText(Action: String; MessageTxt: TPasteArray); overload;

    /// <summary><para>Recalculates the percentage after the save</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <param name="ReturnedList">Data that is returned from the save RPC<para><b>Type: </b><c>TStringList</c></para></param>
    /// <param name="SaveList">Data that will be transfered back to vista<para><b>Type: </b><c>TStringList</c></para></param>
    /// <param name="ExisitingPaste">List of paste that already existed on the document (used for monitoring edits of paste)<para><b>Type: </b><c>array of <see cref="CopyMonitor|TPasteText" /></c></para></param>
    procedure RecalPercentage(ReturnedList: TStringList;
      var SaveList: TStringList; ExisitingPaste: TPasteArray);
    Function StartStopWatch(): Boolean;
    Function StopStopWatch(): Boolean;
    property BufferLoaded: Boolean read FLoadedBuffer;
  published
    /// <summary><para>where to break the text at</para><para><b>Type: </b>intger</para></summary>
    property BreakUpLimit: Integer read FBreakUpLimit write FBreakUpLimit;
    /// <summary>Color used to highlight the matched text</summary>
    property HighlightColor: TColor read FHighlightColor write FHighlightColor;
    /// <summary>Call to load the buffer </summary>
    property LoadBuffer: TLoadEvent read FLoadBuffer write FLoadBuffer;
    /// <summary>Load the copy buffer from VistA</summary>
    procedure LoadTheBuffer();
    /// <summary>External load for the properties</summary>
    property LoadProperties: TLoadProperties read FLoadProperties
      write FLoadProperties;
    /// <summary>External Load Properties</summary>
    procedure LoadTheProperties();
    /// <summary>Flag to display highlight when match found</summary>
    property MatchHighlight: Boolean read FMatchHighlight write FMatchHighlight;
    /// <summary>Style to use for the matched text font</summary>
    property MatchStyle: TFontStyles read FMatchStyle write FMatchStyle;
    /// <summary>The application that we are monitoring</summary>
    property MonitoringApplication: string read FMonitoringApplication
      write FMonitoringApplication;
    /// <summary>The package that this application relates to</summary>
    property MonitoringPackage: string read FMonitoringPackage
      write FMonitoringPackage;
    /// <summary>How many words do we start to consider this copy/paste</summary>
    property NumberOfWordsToBegin: Double read FNumberOfWords
      write FNumberOfWords;
    /// <summary>Percent to we consider this copy/paste functionality</summary>
    property PercentToVerify: Double read FPercentToVerify
      write FPercentToVerify;
    /// <summary>Should the buffer call be polled?</summary>
    Property PolledBuffer: Boolean read FBufferPolled write FBufferPolled;
    /// <summary>Call to save the buffer </summary>
    property SaveBuffer: TSaveEvent read FSaveBuffer write FSaveBuffer;
    /// <summary>Save copy buffer to VistA</summary>
    procedure SaveTheBuffer();

    Property StartPollBuff: TPollBuff read fStartPollBuff write fStartPollBuff;
    Property StopPollBuff: TPollBuff read fStopPollBuff write fStopPollBuff;

    property LCSToggle: Boolean read fLCSToggle write fLCSToggle;
    property LCSCharLimit: Integer read fLCSCharLimit write fLCSCharLimit;
    property LCSUseColor: Boolean read FLCSUseColor write FLCSUseColor;
    property LCSTextColor: TColor read FLCSTextColor write FLCSTextColor;
    property LCSTextStyle: TFontStyles read FLCSTextStyle write FLCSTextStyle;

    /// <summary>The current users DUZ</summary>
    property UserDuz: Int64 read FUserDuz write FUserDuz;
    Property Enabled: Boolean read fEnabled write SetEnabled;
  end;

  /// <summary><para>Non visual control that hooks into a control and monitors copy/paste. Sends data back to<see cref="CopyMonitor|TCopyApplicationMonitor" /> </para></summary>
  TCopyEditMonitor = class(TComponent)
  private
    /// <summary><para>"Overall" component that this should report to</para>
    /// <para><b>Type: </b><c><see cref="CopyMonitor|TCopyApplicationMonitor" /></c></para></summary>
    FCopyMonitor: TCopyApplicationMonitor;
    /// <summary><para>External event to fire when copying</para><para><b>Type: </b><c><see cref="CopyMonitor|TAllowMonitorEvent" /></c></para></summary>
    FCopyToMonitor: TAllowMonitorEvent;

    /// <summary><para>The current document IEN</para><para><b>Type: </b><c>Int64</c></para></summary>
    fItemIEN: Int64;
    /// <summary><para>External event to fire when loading</para><para><b>Type: </b><c><see cref="CopyMonitor|TLoadEvent" /></c></para></summary>
    FLoadPastedText: TLoadEvent;
    /// <summary><para>Stop Watch for metric information</para><para><b>Type: </b><c><see cref="CopyMonitor|TStopWatch" /></c></para></summary>
    fStopWatch: TStopWatch;
    /// <summary><para>External event to fire when pasting</para><para><b>Type: </b><c><see cref="CopyMonitor|TAllowMonitorEvent" /></c></para></summary>
    FPasteToMonitor: TAllowMonitorEvent;
    /// <summary><para>Package related to this monitor</para><para><b>Type: </b><c>string</c></para>
    /// <para><b>Example:</b> if copied from a note (TIU package) this would be <example>8925</example></para></summary>
    FRelatedPackage: string;
    /// <summary><para>External save of recalculated percentage event</para><para><b>Type: </b><c><see cref="CopyMonitor|TRecalculateEvent" /></c></para></summary>
    FRecalPer: TRecalculateEvent;
    /// <summary><para>External event to fire when saving</para><para><b>Type: </b><c><see cref="CopyMonitor|TSaveEvent" /></c></para></summary>
    FSaveTheMonitor: TSaveEvent;
    /// <summary><para>Array of object to monitor</para>
    /// <para><b>Type: </b><c>TCustomEdit</c></para>
    /// <para><b>Note:</b>This is used in addition to FMonitor <example></example></para>
    /// </summary>
    FTrackOnlyObjects: TTrackOnlyCollection;
    /// <summary><para>Call used to determine if visual panel should show. Should only be called from <c><see cref="CopyMonitor|TCopyPasteDetails" /></c></para><para><b>Type: </b><c><see cref="CopyMonitor|TVisualMessage" /></c></para></summary>
    FVisualMessage: TVisualMessage;
    /// <summary><para>Event triggered when data is copied from the monitoring object</para></summary>
    /// <param name="Sender">Object that is making the call<para><b>Type: </b><c>TObject</c></para></param>
    /// <param name="AllowMonitor">Flag indicates if this is excluded or not<para><b>Type: </b><c>Boolean</c></para></param>
    /// <param name="Msg">The message to process<para><b>Type: </b><c>TMessage</c></para></param>
    function CopyToMonitor(Sender: TObject; AllowMonitor: Boolean;
      Msg: uint): Boolean;
    /// <summary><para>Loads the identifiable text for a given entry (ignore leading and trailing spaces)</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <param name="TheRich">The richedit we want to search in<para><b>Type: </b><c>TRichEdit</c></para></param>
    /// <param name="SearchText">The text we want to find<para><b>Type: </b><c>TStringList</c></para></param>
    /// <param name="HighRec">The higlight record the results fill into<para><b>Type: </b><c> <see cref="CopyMonitor|THighlightRecordArray" /></c></para></param>
    /// <returns><para><b>If we were able to identify the text or not</b><c>Boolean</c></para> - </returns>
    function LoadIdentLines(TheRich: TRichEdit; SearchText: TStringList;
      var HighRec: THighlightRecordArray; RecAnalyzed: Boolean): Boolean;
    /// <summary><para>Event triggered when data is pasted into the monitoring object</para></summary>
    /// <param name="Sender">Object that is making the call<para><b>Type: </b><c>TObject</c></para></param>
    /// <param name="AllowMonitor">Flag indicates if this is excluded or not<para><b>Type: </b><c>Boolean</c></para></param>
    /// <param name="AllowMonitor">Information about the clipboard source<para><b>Type: </b><c>tClipInfo</c></para></param>
    procedure PasteToMonitor(Sender: TObject; AllowMonitor: Boolean;
      ClipInfo: tClipInfo);
    /// <summary><para>Setter for Application monitor</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <param name="value">Application monitor to use<para><b>Type: </b><c><see cref="CopyMonitor|TCopyApplicationMonitor" /></c></para></param>
    procedure SetCopyMonitor(Value: TCopyApplicationMonitor);
    /// <summary>Sets the ItemIEN</summary>
    /// <param name="NewItemIEN">New IEN to set to<para><b>Type: </b><c>Int64</c></para></param>
    procedure SetItemIEN(NewItemIEN: Int64);
    /// <summary><para>Setter for the track items</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <param name="Value">Value<para><b>Type: </b><c>TTrackOnlyCollection</c></para></param>
    procedure SetOurCollection(const Value: TTrackOnlyCollection);
    Function StartStopWatch(): Boolean;
    Function StopStopWatch(): Boolean;
  public
    /// <summary><para>Holds all records of pasted text for the specific document</para>
    /// <para><b>Type: </b><c>Array of <see cref="CopyMonitor|TPasteText" /></c></para></summary>
    PasteText: TPasteArray;
    /// <summary>Clears the <see cref="CopyMonitor|TCopyEditMonitor.PasteText" /></summary>
    procedure ClearPasteArray();
    /// <summary><para>Calls <see cref="CopyMonitor|TCopyApplicationMonitor.ClearCopyPasteClipboard" /></para><para><b>Type: </b><c>Integer</c></para></summary>
    procedure ClearTheMonitor();
    /// <summary>constructor</summary>
    constructor Create(AOwner: TComponent); override;
    /// <summary>Destructor</summary>
    destructor Destroy; override;
    /// <summary><para>The current document's IEN</para><para><b>Type: </b><c>Integer</c></para></summary>
    property ItemIEN: Int64 read fItemIEN write SetItemIEN;
    /// <summary><para>Event to fire when loading the pasted text</para><para><b>Type: </b><c>TLoadEvent</c></para></summary>
    Property LoadPastedText: TLoadEvent read FLoadPastedText
      write FLoadPastedText;
    /// <summary><para>Add all available objects to the track items</para><para><b>Type: </b><c>Integer</c></para></summary>
    Procedure MonitorAllAvailable();
    /// <summary><para>Save the Monitor for the current document</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <param name="ItemID">Document's IEN<para><b>Type: </b><c>Integer</c></para></param>
    procedure SaveTheMonitor(Sender: TObject; ItemID: Integer);
    /// <summary><para>transfer data between TcopyEditMonitors</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <param name="Dest">Dest<para><b>Type: </b><c>TCopyEditMonitor</c></para></param>
    procedure TransferData(Dest: TCopyEditMonitor);
    /// <summary><para>Visual message to fire when comming from PasteDetails</para><para><b>Type: </b><c>TVisualMessage</c></para></summary>
    Property VisualMessage: TVisualMessage read FVisualMessage
      write FVisualMessage;
  published
    /// <summary><para>The "Parent" component that monitors the application</para><para><b>Type: </b><c><see cref="CopyMonitor|TCopyApplicationMonitor" /></c></para></summary>
    property CopyMonitor: TCopyApplicationMonitor read FCopyMonitor
      write SetCopyMonitor;
    /// <summary><para>Event to fire when copying</para><para><b>Type: </b><c><see cref="CopyMonitor|TAllowMonitorEvent" /></c></para></summary>
    property OnCopyToMonitor: TAllowMonitorEvent read FCopyToMonitor
      write FCopyToMonitor;
    /// <summary><para>Event to fire when loading</para><para><b>Type: </b><c><see cref="CopyMonitor|TSaveEvent" /></c></para></summary>
    property OnLoadPastedText: TLoadEvent read FLoadPastedText
      write FLoadPastedText;
    /// <summary><para>Event to fire when pasting</para><para><b>Type: </b><c><see cref="CopyMonitor|TAllowMonitorEvent" /></c></para></summary>
    property OnPasteToMonitor: TAllowMonitorEvent read FPasteToMonitor
      write FPasteToMonitor;
    /// <summary><para>Event to fire when saving</para><para><b>Type: </b><c><see cref="CopyMonitor|TSaveEvent" /></c></para></summary>
    property OnSaveTheMonitor: TSaveEvent read FSaveTheMonitor
      write FSaveTheMonitor;
    /// <summary>Call to recalculate the percentage </summary>
    property RecalculatePercentage: TRecalculateEvent read FRecalPer
      write FRecalPer;
    /// <summary><para>Package this object's monitor is related to</para><para><b>Type: </b><c><see cref="CopyMonitor|TCopyEditMonitor.FRelatedPackage" /></c></para></summary>
    property RelatedPackage: string read FRelatedPackage write FRelatedPackage;
    /// <summary><para>Collection of tracked items</para><para><b>Type: </b><c>Integer</c></para></summary>
    property TrackOnlyEdits: TTrackOnlyCollection read FTrackOnlyObjects
      write SetOurCollection;
  end;

  /// <summary><para>Visual control that hooks into a control and monitors copy/paste. Sends data back to<see cref="CopyMonitor|TCopyApplicationMonitor" /> </para></summary>
  TCopyPasteDetails = class(TPanel)
  private
    /// <summary><para>Button used to collapse the <see cref="CopyMonitor|TCopyEditMonitor.FInfoPanel" /></para><para><b>Type: </b><c>TCollapseBtn</c></para></summary>
    FCollapseBtn: TCollapseBtn;

    fTopPanel: TPanel;
    fAnalyzeBtn: TButton;
    fProgressBar: TProgressBar;

    /// <summary><para>Select the "All entries" or first item if on </para><para><b>Type: </b><c>Boolean</c></para></summary>
    fDefaultSelectAll: Boolean;
    /// <summary><para>Uses all the same logic from <see cref="CopyMonitor|TCopyEditMonitor" /></para></summary>
    fEditMonitor: TCopyEditMonitor;
    /// <summary><para>External event to fire when hiding the infopanel</para><para><b>Type: </b><c><see cref="CopyMonitor|TVisible" /></c></para></summary>
    FHide: TVisible;
    /// <summary><para>Flag used to determine if the <see cref="CopyMonitor|TCopyEditMonitor.FInfoPanel" /> is collapsed</para><para><b>Type: </b><c>Boolean</c></para></summary>
    FInfoboxCollapsed: Boolean;
    /// <summary><para>Contains the details for the selected entry in <see cref="CopyMonitor|TCopyEditMonitor.FInfoSelector" /></para><para><b>Type: </b><c>TRichEdit</c></para></summary>
    FInfoMessage: TRichEdit;
    /// <summary><para>List of pasted entries for <see cref="CopyMonitor|TCopyEditMonitor.FMonitorObject" /></para><para><b>Type: </b><c>TSelectorBox</c></para></summary>
    FInfoSelector: TSelectorBox;
    /// <summary><para>Last height of the  <see cref="CopyMonitor|TCopyEditMonitor.FInfoPanel" /></para><para><b>Type: </b><c>Integer</c></para></summary>
    FLastInfoboxHeight: Integer;
    /// <summary><para>Object to monitor</para><para><b>Type: </b><c>TCustomEdit</c></para></summary>
    FMonitorObject: TRichEdit;
    /// <summary><para>New paste highlight is currently active</para><para><b>Type: </b><c>Boolean</c></para></summary>
    FNewShowing: Boolean;
    /// <summary><para>original wnd proc</para><para><b>Type: </b><c>TWndMethod</c></para></summary>
    FOurOrigWndProc: TWndMethod;
    /// <summary><para>Cursor position in <see cref="CopyMonitor|TCopyEditMonitor.FMonitorObject" /> where the text was pasted</para><para><b>Type: </b><c>Integer</c></para></summary>
    FPasteCurPos: Integer;
    /// <summary><para>External event to fire when showing the infopanel</para><para><b>Type: </b><c><see cref="CopyMonitor|TVisible" /></c></para></summary>
    FShow: TVisible;
    /// <summary><para>Shows all paste actions</para><para><b>Type: </b><c>Integer</c></para></summary>
    FShowAllPaste: Boolean;
    /// <summary><para>Flag to detemine if OnResize should be suspended</para><para><b>Type: </b><c>Boolean</c></para></summary>
    FSuspendResize: Boolean;
    /// <summary><para>Flag to detemine if this panels size should sync with others</para><para><b>Type: </b><c>Boolean</c></para></summary>
    FSyncSizes: Boolean;

    FOnButtonToggle: TToggleEvent;
    FOnAnalyze: TSaveEvent;

    /// <summary>Handles the collapse/expand of the "Info Panel"</summary>
    /// <param name="Sender">Object that is making the call<para><b>Type: </b><c>TObject</c></para></param>
    procedure CloseInfoPanel(Sender: TObject);
    /// <summary>Highlights the pasted data in the monitor object (TRichedit)</summary>
    /// <param name="Color">Color from  <see cref="CopyMonitor|TCopyApplicationMonitor.HighlightColor" /><para><b>Type: </b><c>TColor</c></para></param>
    /// <param name="Style">Style from  <see cref="CopyMonitor|TCopyApplicationMonitor.MatchStyle" /><para><b>Type: </b><c>TFontStyles</c></para></param>
    /// <param name="ShowHighlight">Flag from <see cref="CopyMonitor|TCopyApplicationMonitor.MatchHighlight" /><para><b>Type: </b><c>Boolean</c></para></param>
    /// <param name="PasteText">Pasted data from <see cref="CopyMonitor|TCopyEditMonitor.PasteText" /> <para><b>Type: </b><c>String</c></para></param name="PasteText">
    procedure HighLightInfoPanel(Color: TColor; Style: TFontStyles;
      ShowHighlight: Boolean; PasteText: String;
      ClearPrevHighLight: Boolean = true);
    /// <summary>Handles the manual resizing of the "Info Panel"</summary>
    /// <param name="Sender">Object that is making the call<para><b>Type: </b><c>TObject</c></para></param>
    procedure InfoPanelResize(Sender: TObject);
    /// <summary>Loads the details for the selected past entry</summary>
    /// <param name="Sender">Object that is making the call<para><b>Type: </b><c>TObject</c></para></param>
    procedure lbSelectorClick(Sender: TObject);

    procedure LCSCompareStrings(DestRich: TRichEdit;
      OrigStr, ModStr: TStringList);
    procedure AnalyzeClick(Sender: TObject);

    /// <summary>Removes the highlighting from the monitoring object</summary>
    /// <param name="Sender">Object that is making the call<para><b>Type: </b><c>TObject</c></para></param>
    procedure pnlMessageExit(Sender: TObject);
    /// <summary><para>Custom WndProc</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <param name="Message">Message<para><b>Type: </b><c>TMessage</c></para></param>
    procedure OurWndProc(var Message: TMessage);
    /// <summary>Responsible for loading the results into the "Info Panel"</summary>
    procedure ReloadInfoPanel();
    /// <summary><para>Assign object to monitor</para></summary>
    /// <param name="ACopyObject">Object to montior<para><b>Type: </b><c>TCustomEdit</c></para>
    /// <para><b>Example:</b><example>TRichEdit</example></para></param>
    procedure SetObjectToMonitor(ACopyObject: TRichEdit);
    /// <summary>Responsible for displaying the "Info Panel"</summary>
    /// <param name="Toggle">Determines if this should display or not<para><b>Type: </b><c>Boolean</c></para></param>
    procedure ShowInfoPanel(Toggle: Boolean);
    /// <summary><para>Determines if the panel should show</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <param name="sender">sender<para><b>Type: </b><c>TObject</c></para></param>
    /// <param name="CPmsg">CPmsg<para><b>Type: </b><c>Cardinal</c></para></param>
    /// <param name="CPVars">CPVars<para><b>Type: </b><c>Array of Variant</c></para></param>
    Procedure VisualMesageCenter(Sender: TObject; const CPmsg: Cardinal;
      CPVars: Array of Variant);
  public
    /// <summary><para>Check if paste were modified</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <param name="Sender">Sender<para><b>Type: </b><c>TComponent</c></para></param>
    /// <param name="SaveList">SaveList<para><b>Type: </b><c>TStringList</c></para></param>
    procedure CheckForModifiedPaste(var SaveList: TStringList);
    /// <summary>constructor</summary>
    constructor Create(AOwner: TComponent); override;
    /// <summary>Select all entries  by default</summary>
    Property DefaultSelectAll: Boolean read fDefaultSelectAll
      write fDefaultSelectAll;
    /// <summary>Destructor</summary>
    destructor Destroy; override;
    /// <summary><para>Override the DoExit procedure</para></summary>
    procedure DoExit; override;
    /// <summary><para>Calls <see cref="CopyMonitor|TCopyEditMonitor.ShowInfoPanel" /></para><para><b>Type: </b><c>Integer</c></para></summary>
    property FInfoPanelVisible: Boolean write ShowInfoPanel;
    /// <summary>Finds pasted text for a given document</summary>
    procedure LoadPasteText();

    procedure FillPasteArray(SourceData: THashedStringList;
      var UpdateRec: TPasteText);

    Procedure ManuallyShowNewHighlights();
    /// <summary><para>Save the Monitor for the current document</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <param name="ItemID">Document's IEN<para><b>Type: </b><c>Integer</c></para></param>
    procedure SaveTheMonitor(ItemID: Integer);
    /// <summary><para>show all paste actions</para><para><b>Type: </b><c>Boolean</c></para></summary>
    property ShowAllPaste: Boolean read FShowAllPaste write FShowAllPaste;
    /// <summary><para>Override the Resize procedure</para></summary>
    procedure Resize; override;
    property InfoBoxCollapsed: Boolean read FInfoboxCollapsed;
  published
    /// <summary><para>Button used to collapse or expand the panel</para><para><b>Type: </b><c>TCollapseBtn</c></para></summary>
    property CollapseBtn: TCollapseBtn read FCollapseBtn;
    /// <summary><para>Uses all the same logic from <see cref="CopyMonitor|TCopyEditMonitor" /></para></summary>
    property EditMonitor: TCopyEditMonitor read fEditMonitor write fEditMonitor;
    /// <summary><para>Contains the pasted details</para><para><b>Type: </b><c>TRichEdit</c></para></summary>
    property InfoMessage: TRichEdit read FInfoMessage;
    /// <summary><para>Displays the selectable entries</para><para><b>Type: </b><c>TSelectorBox</c></para></summary>
    property InfoSelector: TSelectorBox read FInfoSelector;
    /// <summary><para>Event to fire when hiding</para><para><b>Type: </b><c><see cref="CopyMonitor|TVisible" /></c></para></summary>
    property OnHide: TVisible read FHide write FHide;
    /// <summary><para>Event to fire when showing</para><para><b>Type: </b><c><see cref="CopyMonitor|TVisible" /></c></para></summary>
    property OnShow: TVisible read FShow write FShow;
    /// <summary><para>Flag to detemine if this panels size should sync with others</para><para><b>Type: </b><c>Boolean</c></para></summary>
    property SyncSizes: Boolean read FSyncSizes write FSyncSizes;
    /// <summary><para>Object to monitor</para><para><b>Type: </b><c>TCustomEdit</c></para></summary>
    property VisualEdit: TRichEdit read FMonitorObject write SetObjectToMonitor;
    property OnButtonToggle: TToggleEvent read FOnButtonToggle
      write FOnButtonToggle;
    property OnAnalyze: TSaveEvent read FOnAnalyze write FOnAnalyze;
  end;

  // -------- Global Functions --------//

  /// <summary><para>Breaks a string up so it can be sent via the RPC broker</para></summary>
  /// <param name="OrigList">Stringlist that needs to be broken up<para><b>Type: </b><c>TStringList</c></para></param>
  /// <returns><para><b>Type: </b><c>TStringList</c></para> - </returns>
  /// <remarks>Breaks up strings at <example></example></remarks>
procedure BreakUpLongLines(var SaveList: TStringList; BaseNode: String;
  const OrigList: TStringList; BreakLimit: Integer);
/// <summary><para>converts a Delphi date/time type to a Fileman date/time</para><para><b>Type: </b><c>Integer</c></para></summary>
/// <param name="ADateTime">The date/time<para><b>Type: </b><c>TDateTime</c></para></param>
/// <returns><para><b>Type: </b><c>Double</c></para> - </returns>
function DateTimeToFMDateTime(ADateTime: TDateTime): Double;
/// <summary><para>Remove special characters</para><para><b>Type: </b><c>Integer</c></para></summary>
/// <param name="X">String to filter<para><b>Type: </b><c>string</c></para></param>
/// <param name="ATabWidth">Length of the tab<para><b>Type: </b><c>Integer</c></para></param>
/// <returns><para><b>Type: </b><c>string</c></para> - </returns>
function FilteredString(const X: string; ATabWidth: Integer = 8): string;
/// <summary><para>Format fmDateTime</para></summary>
/// <param name="AFormat">The format to use<para><b>Type: </b><c>string</c></para></param>
/// <param name="ADateTime">The date/time<para><b>Type: </b><c>Double</c></para></param>
/// <returns><para><b>Type: </b><c>string</c></para> - </returns>
function FormatFMDateTime(AFormat: string; ADateTime: Double): string;
/// <summary><para>Returns the Nth piece (PieceNum) of a string delimited by Delim</para></summary>
/// <param name="S">String to search<para><b>Type: </b><c>string</c></para></param>
/// <param name="Delim">Character used as the delemiter<para><b>Type: </b><c>char</c></para></param>
/// <param name="PieceNum">Number of delemieted text for the return<para><b>Type: </b><c>Integer</c></para></param>
/// <returns><para><b>Type: </b><c>string</c></para> - </returns>
function Piece(const S: string; Delim: char; PieceNum: Integer): string;

const
  { names of months used by FormatFMDateTime }
  MONTH_NAMES_SHORT: array [1 .. 12] of string = ('Jan', 'Feb', 'Mar', 'Apr',
    'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');
  MONTH_NAMES_LONG: array [1 .. 12] of string = ('January', 'February', 'March',
    'April', 'May', 'June', 'July', 'August', 'September', 'October',
    'November', 'December');

  Show_Panel = $1000;
  ShowAndSelect_Panel = $1001;
  Hide_Panel = $1002;
  ShowHighlight = $1003;
  PasteLimit = 20000; // Limit the paste to a certain number of characters
  NSecsPerSec = 1000000000;

procedure Register;

implementation

uses Types, DateUtils, System.Generics.Collections, System.UITypes;

procedure Register;
begin
  RegisterComponents('CPRS', [TCopyApplicationMonitor, TCopyEditMonitor,
    TCopyPasteDetails]);
end;

{$REGION 'CopyApplicationMonitor'}

procedure TCopyApplicationMonitor.ClearCopyPasteClipboard;
var
  I: Integer;
begin
  if not fEnabled then
    Exit;
  StartStopWatch;
  try
    for I := Low(FCPRSClipBoard) to High(FCPRSClipBoard) do
    begin
      FCPRSClipBoard[I].SaveForDocument := false;
      FCPRSClipBoard[I].DateTimeOfPaste := '';
      FCPRSClipBoard[I].PasteToIEN := -1;
      FCPRSClipBoard[I].SaveItemID := -1;
    end;
  finally
    if StopStopWatch then
      LogText('METRIC', 'Clear: ' + fStopWatch.Elapsed);
  end;
  LogText('SAVE', 'Clearing all pasted data that was marked for save');

end;

procedure TCopyApplicationMonitor.PasteToCopyPasteClipboard(TextToPaste,
  PasteDetails: string; ItemIEN: Integer; ClipInfo: tClipInfo);
var
  TextFound, AddItem: Boolean;
  I, PosToUSe, CutOff: Integer;
  PertoCheck, LastPertToCheck: Double;
  CompareText: TStringList;
  Len1, Len2: Integer;
begin
  if not fEnabled then
    Exit;
  // load the properties
  if not FLoadedProperties then
    LoadTheProperties;
  // load the buffer
  if not FLoadedBuffer then
    LoadTheBuffer;

  TextFound := false;
  CompareText := TStringList.Create;
  try
    CompareText.Text := TextToPaste; // Apples to Apples

    // Direct macthes
    StartStopWatch;
    try
      for I := Low(FCPRSClipBoard) to High(FCPRSClipBoard) do
      begin
        If AnsiSameText(Trim(FCPRSClipBoard[I].CopiedText.Text),
          Trim(CompareText.Text)) then
        begin
          if (FCPRSClipBoard[I].CopiedFromIEN <> ItemIEN) then
          begin
            FCPRSClipBoard[I].SaveForDocument :=
              (FCPRSClipBoard[I].CopiedFromIEN <> ItemIEN);
            FCPRSClipBoard[I].DateTimeOfPaste :=
              FloatToStr(DateTimeToFMDateTime(Now));
            FCPRSClipBoard[I].CopiedFromPackage := FCPRSClipBoard[I]
              .CopiedFromPackage; // ????????
            FCPRSClipBoard[I].PercentMatch := 100.00;
            FCPRSClipBoard[I].PasteToIEN := ItemIEN;
            FCPRSClipBoard[I].PasteDBID := -1;

            // Log info
            LogText('PASTE', 'Direct Match Found');
            LogText('PASTE', 'Pasted Text IEN(' + IntToStr(ItemIEN) + ')');
            LogText('TEXT', 'Pasted Text:' + #13#10 + CompareText.Text);
            LogText('PASTE', 'Matched to Text IEN(' +
              IntToStr(FCPRSClipBoard[I].CopiedFromIEN) + '):');
            LogText('TEXT', 'Matched to Text: ' + #13#10 +
              Trim(FCPRSClipBoard[I].CopiedText.Text));

          end;
          TextFound := true;
          Break;
        end;
      end;
    finally
      If StopStopWatch then
        LogText('METRIC', 'Direct Match: ' + fStopWatch.Elapsed);
    end;

    // % check or exceed limit
    if not TextFound then
    begin
      // check for text limit
      if Length(CompareText.Text) >= PasteLimit then
      begin
        // never exclude if originated from a tracking app
        if Length(PasteDetails) > 0 then
          AddItem := true
        else
        begin
          // Check if excluded
          AddItem := (not FromExcludedApp(ClipInfo.AppName));
          if not AddItem then
            LogText('PASTE', 'Excluded Application');
        end;

        if AddItem then
        begin
          // Look for the details first
          SetLength(FCPRSClipBoard, Length(FCPRSClipBoard) + 1);

          with FCPRSClipBoard[High(FCPRSClipBoard)] do
          begin
            // From tracking app
            if Length(PasteDetails) > 0 then
            begin
              CopiedFromIEN := StrToIntDef(Piece(PasteDetails, '^', 1), -1);
              CopiedFromPackage := Piece(PasteDetails, '^', 2);
              ApplicationPackage := Piece(PasteDetails, '^', 3);
              ApplicationName := Piece(PasteDetails, '^', 4);
              PercentMatch := 100.0;

              LogText('PASTE', 'Paste from cross session - Over Limit ' +
                PasteDetails);
              LogText('PASTE', 'Added to internal clipboard IEN(-1)');
            end
            else
            begin
              // Exceeds the limit set
              CopiedFromIEN := -1;
              CopiedFromPackage := 'Paste exceeds maximum compare limit.';
              if Trim(ClipInfo.AppName) <> '' then
                CopiedFromPackage := CopiedFromPackage + ' From: ' +
                  ClipInfo.AppName + ' - ' + ClipInfo.AppTitle;
              ApplicationPackage := MonitoringPackage;
              ApplicationName := MonitoringApplication;
              PercentMatch := 100.0;

              LogText('PASTE', 'Pasted from outside the tracking - Over Limit ('
                + IntToStr(Length(CompareText.Text)) + ')');
              LogText('PASTE]', 'Added to internal clipboard IEN(-1)');
            end;
            PasteToIEN := ItemIEN;
            PasteDBID := -1;
            DateTimeOfCopy := FloatToStr(DateTimeToFMDateTime(Now));
            SaveForDocument := true;
            DateTimeOfPaste := FloatToStr(DateTimeToFMDateTime(Now));
            SaveToTheBuffer := true;
            CopiedText := TStringList.Create;
            CopiedText.Text := CompareText.Text;
            TextFound := true;
          end;
        end;
      end
      else
      begin
        StartStopWatch;
        try
          // Percentage match
          LastPertToCheck := 0;
          PosToUSe := -1;

          for I := Low(FCPRSClipBoard) to High(FCPRSClipBoard) do
          begin
            try
              Len1 := Length(Trim(FCPRSClipBoard[I].CopiedText.Text));
              Len2 := Length(CompareText.Text);
              CutOff := ceil(min(Len1, Len2) * (FPercentToVerify * 0.01));
              PertoCheck := LevenshteinDistance
                (Trim(FCPRSClipBoard[I].CopiedText.Text),
                CompareText.Text, CutOff);
            except
              PertoCheck := 0;
            end;
            if PertoCheck > LastPertToCheck then
            begin
              if PertoCheck > FPercentToVerify then
              begin
                PosToUSe := I;
                LastPertToCheck := PertoCheck;
              end;
            end;

          end;
          if PosToUSe <> -1 then
          begin
            If (FCPRSClipBoard[PosToUSe].CopiedFromIEN <> ItemIEN) then
            begin

              LogText('PASTE', 'Partial Match: %' +
                FloatToStr(round(LastPertToCheck)));
              LogText('PASTE', 'Pasted Text IEN(' + IntToStr(ItemIEN) + ')');
              LogText('TEXT', 'Pasted Text:' + #13#10 + CompareText.Text);
              LogText('PASTE', 'Matched to Text IEN(' +
                IntToStr(FCPRSClipBoard[PosToUSe].CopiedFromIEN) + ')');
              LogText('TEXT', 'Matched to Text: ' + #13#10 +
                Trim(FCPRSClipBoard[PosToUSe].CopiedText.Text));
              LogText('PASTE', 'Added to internal clipboard IEN(-1)');

              // add new
              SetLength(FCPRSClipBoard, Length(FCPRSClipBoard) + 1);
              with FCPRSClipBoard[High(FCPRSClipBoard)] do
              begin
                CopiedFromIEN := -1;
                CopiedFromPackage := 'Outside of current ' +
                  MonitoringApplication + ' tracking';
                ApplicationPackage := MonitoringPackage;
                ApplicationName := MonitoringApplication;
                PercentMatch := round(LastPertToCheck);

                PercentData := IntToStr(FCPRSClipBoard[PosToUSe].CopiedFromIEN)
                  + ';' + FCPRSClipBoard[PosToUSe].CopiedFromPackage;
                PasteToIEN := ItemIEN;
                PasteDBID := -1;
                DateTimeOfCopy := FloatToStr(DateTimeToFMDateTime(Now));
                SaveForDocument := true;
                DateTimeOfPaste := FloatToStr(DateTimeToFMDateTime(Now));
                SaveToTheBuffer := true;
                CopiedText := TStringList.Create;
                CopiedText.Text := CompareText.Text;
                OriginalText := TStringList.Create;
                OriginalText.Text := FCPRSClipBoard[PosToUSe].CopiedText.Text;
              end;

            end;
            TextFound := true;
          end;
        finally
          If StopStopWatch then
            LogText('METRIC', 'Percentage Match: ' + fStopWatch.Elapsed);
        end;

      end;

      // add outside paste in here
      if (not TextFound) and (WordCount(CompareText.Text) >= FNumberOfWords)
      then
      begin
        StartStopWatch;
        try
          if Length(PasteDetails) > 0 then
            AddItem := true
          else
          begin
            // Check if excluded
            AddItem := (not FromExcludedApp(ClipInfo.AppName));
            if not AddItem then
              LogText('PASTE', 'Excluded Application');
          end;

          if AddItem then
          begin
            // Look for the details first
            SetLength(FCPRSClipBoard, Length(FCPRSClipBoard) + 1);
            with FCPRSClipBoard[High(FCPRSClipBoard)] do
            begin
              if Length(PasteDetails) > 0 then
              begin
                CopiedFromIEN := StrToIntDef(Piece(PasteDetails, '^', 1), -1);
                CopiedFromPackage := Piece(PasteDetails, '^', 2);
                ApplicationPackage := Piece(PasteDetails, '^', 3);
                ApplicationName := Piece(PasteDetails, '^', 4);
                PercentMatch := 100.0;

                LogText('PASTE', 'Paste from cross session ' + PasteDetails);
                LogText('PASTE', 'Added to internal clipboard IEN(-1)');

              end
              else
              begin
                CopiedFromIEN := -1;
                CopiedFromPackage := 'Outside of current ' +
                  MonitoringApplication + ' tracking.';
                if Trim(ClipInfo.AppName) <> '' then
                  CopiedFromPackage := CopiedFromPackage + 'From: ' +
                    ClipInfo.AppName + ' - ' + ClipInfo.AppTitle;
                ApplicationPackage := MonitoringPackage;
                ApplicationName := MonitoringApplication;
                PercentMatch := 100.0;

                LogText('PASTE', 'Pasted from outside the tracking');
                LogText('PASTE]', 'Added to internal clipboard IEN(-1)');

              end;
              PasteToIEN := ItemIEN;
              PasteDBID := -1;
              DateTimeOfCopy := FloatToStr(DateTimeToFMDateTime(Now));
              SaveForDocument := true;
              DateTimeOfPaste := FloatToStr(DateTimeToFMDateTime(Now));
              SaveToTheBuffer := true;
              CopiedText := TStringList.Create;
              CopiedText.Text := CompareText.Text;
            end;
          end;
        finally
          If StopStopWatch then
            LogText('METRIC', 'Outside Paste: ' + fStopWatch.Elapsed);
        end;
      end;
    end;
  finally
    CompareText.Free;
  end;
end;

procedure TCopyApplicationMonitor.SaveCopyPasteClipboard(Sender: TComponent;
  SaveList: TStringList);
var
  I, SaveCnt, IEN2Use: Integer;
  Package2Use: String;
begin
  if not fEnabled then
    Exit;
  // load the properties
//  if not FLoadedProperties then
//    LoadTheProperties;
  // load the buffer
//  if not FLoadedBuffer then
//    LoadTheBuffer;
  SaveList.Text := '';
  if (Sender is TCopyEditMonitor) then
  begin
    StartStopWatch;
    try
      with (Sender as TCopyEditMonitor) do
      begin
        SaveCnt := 0;
        for I := Low(FCPRSClipBoard) to High(FCPRSClipBoard) do
        begin
          if FCPRSClipBoard[I].SaveForDocument = true then
          begin
            Inc(SaveCnt);
            FCPRSClipBoard[I].SaveItemID := SaveCnt;
            if FCPRSClipBoard[I].PercentMatch <> 100 then
            begin
              IEN2Use := StrToIntDef(Piece(FCPRSClipBoard[I].PercentData,
                ';', 1), -1);
              Package2Use := Piece(FCPRSClipBoard[I].PercentData, ';', 2);
            end
            else
            begin
              IEN2Use := FCPRSClipBoard[I].CopiedFromIEN;
              Package2Use := FCPRSClipBoard[I].CopiedFromPackage;
            end;

            SaveList.Add(IntToStr(SaveCnt) + ',0=' + IntToStr(UserDuz) + '^' +
              FCPRSClipBoard[I].DateTimeOfPaste + '^' + IntToStr(ItemIEN) + ';'
              + RelatedPackage + '^' + IntToStr(IEN2Use) + ';' + Package2Use +
              '^' + FloatToStr(FCPRSClipBoard[I].PercentMatch) + '^' +
              FCPRSClipBoard[I].ApplicationPackage + '^' + FCPRSClipBoard[I]
              .ApplicationName + '^-1');

            // Line Count (w/out OUR line breaks for size - code below)

            BreakUpLongLines(SaveList, IntToStr(SaveCnt),
              FCPRSClipBoard[I].CopiedText, FBreakUpLimit);

            // Send in  the original text if needed
            If Assigned(FCPRSClipBoard[I].OriginalText) then
            begin
              SaveList.Add(IntToStr(SaveCnt) + ',0,-1=' +
                IntToStr(FCPRSClipBoard[I].OriginalText.Count));
              BreakUpLongLines(SaveList, IntToStr(SaveCnt) + ',0',
                FCPRSClipBoard[I].OriginalText, FBreakUpLimit);
            end;

          end;
        end;

        SaveList.Add('TotalToSave=' + IntToStr(SaveCnt));
        LogText('SAVE', 'Saved ' + IntToStr(SaveCnt) + ' Items');

      end;
    finally
      If StopStopWatch then
        LogText('METRIC', 'Build Save: ' + fStopWatch.Elapsed);
    end;
  end;
end;

procedure TCopyApplicationMonitor.CopyToCopyPasteClipboard(TextToCopy,
  FromName: string; ItemID: Integer);
var
  I: Integer;
  Found: Boolean;

  procedure AddToClipBrd(CPDetails, CPText: string);
  var
    gMem: HGLOBAL;
    lp: Pointer;
  begin
{$WARN SYMBOL_PLATFORM OFF}
    Win32Check(OpenClipBoard(0));
    try
      Win32Check(EmptyClipBoard);
      // Add the details to the clipboard
      gMem := GlobalAlloc(GMEM_MOVEABLE + GMEM_DDESHARE, Length(CPDetails) + 1);
      try
        Win32Check(gMem <> 0);
        lp := GlobalLock(gMem);
        Win32Check(lp <> nil);
        CopyMemory(lp, Pointer(PAnsiChar(AnsiString(CPDetails))),
          Length(CPDetails) + 1);
        Win32Check(gMem <> 0);
        SetClipboardData(CF_CopyPaste, gMem);
        Win32Check(gMem <> 0);
      finally
        GlobalUnlock(gMem);
      end;

      // now add the text to the clipboard
      CPText := StringReplace(CPText, #13, #13#10, [rfReplaceAll]);
      gMem := GlobalAlloc(GMEM_DDESHARE + GMEM_MOVEABLE,
        (Length(CPText) + 1) * 2);
      try
        Win32Check(gMem <> 0);
        lp := GlobalLock(gMem);
        Win32Check(lp <> nil);
        CopyMemory(lp, Pointer(PAnsiChar(AnsiString(CPText))),
          (Length(CPText) + 1) * 2);
        Win32Check(gMem <> 0);
        SetClipboardData(CF_TEXT, gMem);
        Win32Check(gMem <> 0);
      finally
        GlobalUnlock(gMem);
      end;
    finally
      Win32Check(CloseClipBoard);
    end;
{$WARN SYMBOL_PLATFORM ON}
  end;

begin
  if not fEnabled then
    Exit;
  Found := false;
  if not FLoadedProperties then
    LoadTheProperties;
  if not FLoadedBuffer then
    LoadTheBuffer;

  LogText('COPY', 'Copying data from IEN(' + IntToStr(ItemID) + ')');
  StartStopWatch;
  try
    if WordCount(TextToCopy) >= FNumberOfWords then
    begin
      // check if this already exist
      for I := Low(FCPRSClipBoard) to High(FCPRSClipBoard) do
      begin
        if FCPRSClipBoard[I].CopiedFromPackage = UpperCase(FromName) then
        begin
          if FCPRSClipBoard[I].CopiedFromIEN = ItemID then
          begin
            if AnsiSameText(Trim(FCPRSClipBoard[I].CopiedText.Text),
              Trim(TextToCopy)) then
            begin
              Found := true;

              LogText('COPY', 'Copied data already being monitored');
              Break;
            end;
          end;
        end;
      end;

      // Copied text doesn't exist so add it in
      if (not Found) and (WordCount(TextToCopy) >= FNumberOfWords) then
      begin

        LogText('COPY', 'Adding copied data to session tracking');
        SetLength(FCPRSClipBoard, Length(FCPRSClipBoard) + 1);
        FCPRSClipBoard[High(FCPRSClipBoard)].CopiedFromIEN := ItemID;
        FCPRSClipBoard[High(FCPRSClipBoard)].CopiedFromPackage :=
          UpperCase(FromName);
        FCPRSClipBoard[High(FCPRSClipBoard)].ApplicationPackage :=
          MonitoringPackage;
        FCPRSClipBoard[High(FCPRSClipBoard)].ApplicationName :=
          MonitoringApplication;
        FCPRSClipBoard[High(FCPRSClipBoard)].DateTimeOfCopy :=
          FloatToStr(DateTimeToFMDateTime(Now));
        FCPRSClipBoard[High(FCPRSClipBoard)].PasteDBID := -1;
        FCPRSClipBoard[High(FCPRSClipBoard)].SaveForDocument := false;
        FCPRSClipBoard[High(FCPRSClipBoard)].SaveToTheBuffer := true;
        FCPRSClipBoard[High(FCPRSClipBoard)].CopiedText := TStringList.Create;
        FCPRSClipBoard[High(FCPRSClipBoard)].CopiedText.Text := TextToCopy;
      end;
    end;
    AddToClipBrd(IntToStr(ItemID) + '^' + UpperCase(FromName) + '^' +
      MonitoringPackage + '^' + MonitoringApplication, TextToCopy);
  finally
    If StopStopWatch then
      LogText('METRIC', 'Add To Clipbaord: ' + fStopWatch.Elapsed);
  end;
end;

constructor TCopyApplicationMonitor.Create(AOwner: TComponent);
Var
  I: Integer;
begin
  inherited;
  FLoadedBuffer := false;
  FLoadedProperties := false;
  FHighlightColor := clYellow;
  FMatchStyle := [];
  FMatchHighlight := true;
  FDisplayPaste := true;
  fEnabled := true;
  fLCSToggle := true;
  fLCSCharLimit := 5000;

  CF_CopyPaste := RegisterClipboardFormat('CF_CopyPaste');
  FLogObject := nil;

  for I := 1 to ParamCount do
  begin
    if UpperCase(ParamStr(I)) = 'CPLOG' then
    begin
      FLogObject := TLogComponent.Create(Self);
      FLogObject.LogToFile := LOG_DETAIL;
      Break;
    end
    else if UpperCase(ParamStr(I)) = 'CPLOGDEBUG' then
    begin
      FLogObject := TLogComponent.Create(Self);
      FLogObject.LogToFile := LOG_DETAIL;
      Break;
    end;
  end;
  if Assigned(FLogObject) then
    fStopWatch := TStopWatch.Create(Self, true);
  SetLength(fSyncSizeList, 0);
  FCriticalSection := TCriticalSection.Create;
  fExcludeApps := TStringList.Create;
  fExcludeApps.CaseSensitive := false;

  LogText('START', StringOfChar('*', 20) + FormatDateTime('mm/dd/yyyy hh:mm:ss',
    Now) + StringOfChar('*', 20));
  LogText('INIT', 'Monitor object created');

end;

destructor TCopyApplicationMonitor.Destroy;
var
  I: Integer;
begin
  // Clear copy arrays
  for I := Low(FCPRSClipBoard) to High(FCPRSClipBoard) do
  begin
    FCPRSClipBoard[I].CopiedText.Free;
    If Assigned(FCPRSClipBoard[I].OriginalText) then
      FCPRSClipBoard[I].OriginalText.Free;
  end;
  SetLength(FCPRSClipBoard, 0);
  SetLength(fSyncSizeList, 0);
  FCriticalSection.Free;
  fExcludeApps.Free;

  for I := Low(FCopyPasteThread) to High(FCopyPasteThread) do
    FCopyPasteThread[I].Terminate;
  SetLength(FCopyPasteThread, 0);

  if Assigned(fStopWatch) then
    fStopWatch.Free;
  LogText('INIT', 'Monitor object destroyed');
  LogText('STOP', StringOfChar('*', 20) + FormatDateTime('mm/dd/yyyy hh:mm:ss',
    Now) + StringOfChar('*', 20));
  inherited;
end;

procedure TCopyApplicationMonitor.LoadTheBufferPolled(Sender: TObject);
const
  Wait_Timeout = 60; // Loop time each loop 1 second
  Timer_Delay = 5000; // MS
var
  BufferList: THashedStringList;
  I, X: Integer;
  NumLines, BuffLoopStart, BuffLoopStop{, StrtSub, StpSub}: Integer;
  ProcessLoad, LoadDone, ErrOccurred: Boolean;
  tmpString: String;
begin
  ErrOccurred := False;
  if not fEnabled or FLoadedBuffer then
    Exit;

  // Do we need to start the polling
  if not Assigned(fBufferTimer) then
  begin
    if not Assigned(fStartPollBuff) then
    begin
      // need to be able to start the buffer
      FLoadedBuffer := true;
      Exit;
    end
    else
    begin
      LogText('BUFF', 'RPC START POLL');
      StartStopWatch;
      try
        fStartPollBuff(Self, ErrOccurred);
      finally
        If StopStopWatch then
          LogText('METRIC', 'Start Buffer RPC: ' + fStopWatch.Elapsed);
      end;
      if ErrOccurred then
      begin
        FLoadedBuffer := true;
        Exit;
      end;
    end;

    fBufferTimer := TTimer.Create(Self);
    fBufferTimer.Interval := Timer_Delay;
    fBufferTimer.OnTimer := LoadTheBufferPolled;
    fBufferTimer.Enabled := true;
    Exit; // Dont run the check right away, let the timmer handle this
  end;

  // Timmer has been started so lets check
  if (Sender is TTimer) then
  begin
    if not Assigned(FLoadBuffer) then
    begin
      // need to be able to check the buffer
      FLoadedBuffer := true;
      Exit;
    end
    else
    begin
      BufferList := THashedStringList.Create();
      try
        ProcessLoad := true;
        LoadDone := false;
//        BuffLoopStart := 0;
//        BuffLoopStop := -1;
        fBufferTimer.Enabled := false;
        LogText('BUFF', 'RPC BUFFER CALL');

        StartStopWatch;
        try
          FLoadBuffer(Self, BufferList, ProcessLoad);
        finally
          If StopStopWatch then
            LogText('METRIC', 'Buffer Load RPC: ' + fStopWatch.Elapsed);
        end;

        if ProcessLoad then
        begin
          StartStopWatch;
          try

            if BufferList.Count > 0 then
            begin
              if BufferList.Strings[0] <> '-1' then
              begin
                //first line is always the ~DONE
                LoadDone := BufferList.Values['~Done'] = '1';
                //If more than 1 line (the done line) then try to start processing the copies
                if BufferList.Count > 1 then
                begin
                BuffLoopStart :=
                  StrToIntDef(Piece(Piece(BufferList.Strings[1], ',', 1),
                  '(', 2), 0);
                BuffLoopStop :=
                  StrToIntDef
                  (Piece(Piece(BufferList.Strings[BufferList.Count - 1], ',',
                  1), '(', 2), -1);

                if BuffLoopStop > 0 then
                 SetLength(FCPRSClipBoard, BuffLoopStop);
                for I := BuffLoopStart to BuffLoopStop do
                begin

                  with FCPRSClipBoard[I - 1] do
                  begin
                    SaveForDocument := false;
                    SaveToTheBuffer := false;
                    tmpString := BufferList.Values['(' + IntToStr(I) + ',0)'];
                    DateTimeOfCopy := Piece(tmpString, '^', 1);
                    ApplicationPackage := Piece(tmpString, '^', 3);
                    CopiedFromIEN :=
                      StrToIntDef(Piece(Piece(tmpString, '^', 4), ';', 1), -1);
                    CopiedFromPackage :=
                      Piece(Piece(tmpString, '^', 4), ';', 2);
                    ApplicationName := Piece(tmpString, '^', 6);
                    NumLines := StrToIntDef(Piece(tmpString, '^', 5), -1);
                    if NumLines > 0 then
                    begin
                      CopiedText := TStringList.Create;
                      CopiedText.BeginUpdate;
                      for X := 1 to NumLines do
                        CopiedText.Add
                          (BufferList.Values['(' + IntToStr(I) + ',' +
                          IntToStr(X) + ')']);
                      CopiedText.EndUpdate;
                    end;
                  end;
                end;
                end;
              end;
            end;
          finally
            If StopStopWatch then
              LogText('METRIC', 'Buffer build: ' + fStopWatch.Elapsed);
          end;

        end;

      finally
        BufferList.Free;
      end;

      // Stop the timer
      if LoadDone then
      begin
        FLoadedBuffer := true;
        fBufferTimer.Enabled := false;
        LogText('BUFF', 'Buffer loaded with ' + IntToStr(Length(FCPRSClipBoard))
          + ' Items');
      end
      else
        fBufferTimer.Enabled := true;

    end;
  end
  else
  begin
    // Not from the Timer so we need to wait until the call is done
    I := 0;
    while fBufferTimer.Enabled or (I >= Wait_Timeout) do
    begin
      // check to see if the buffer has finished yet
      Sleep(1000);
      Application.ProcessMessages;
      Inc(I);
    end;
  end;

end;

procedure TCopyApplicationMonitor.LoadTheBuffer();
var
  BufferList: TStringList;
  I, X: Integer;
  NumLines, BuffParent: Integer;
  ProcessLoad: Boolean;
begin
  if not fEnabled then
    Exit;

  if FBufferPolled then
  begin
    LoadTheBufferPolled(Self);
    Exit;
  end;

  // Non polled logic
  BufferList := TStringList.Create();
  try
    ProcessLoad := true;
    BuffParent := 0;
    if Assigned(FLoadBuffer) then
    begin
      LogText('BUFF', 'RPC CALL');

      StartStopWatch;
      try
        FLoadBuffer(Self, BufferList, ProcessLoad);
      finally
        If StopStopWatch then
          LogText('METRIC', 'Buffer Load RPC: ' + fStopWatch.Elapsed);
      end;
    end;

    if ProcessLoad then
    begin
      StartStopWatch;
      try
        LogText('BUFF', 'Loading the buffer.' + BufferList.Values['(0,0)'] +
          ' Items.');

        if BufferList.Count > 0 then
          BuffParent := StrToIntDef(BufferList.Values['(0,0)'], -1);

        for I := 1 to BuffParent do
        begin // first line is the total number

          LogText('BUFF', 'Buffer item (' + IntToStr(I) + '): ' +
            BufferList.Values['(' + IntToStr(I) + ',0)']);

          SetLength(FCPRSClipBoard, Length(FCPRSClipBoard) + 1);
          FCPRSClipBoard[High(FCPRSClipBoard)].SaveForDocument := false;
          FCPRSClipBoard[High(FCPRSClipBoard)].SaveToTheBuffer := false;
          FCPRSClipBoard[High(FCPRSClipBoard)].DateTimeOfCopy :=
            Piece(BufferList.Values['(' + IntToStr(I) + ',0)'], '^', 1);
          FCPRSClipBoard[High(FCPRSClipBoard)].ApplicationPackage :=
            Piece(BufferList.Values['(' + IntToStr(I) + ',0)'], '^', 3);
          FCPRSClipBoard[High(FCPRSClipBoard)].CopiedFromIEN :=
            StrToIntDef
            (Piece(Piece(BufferList.Values['(' + IntToStr(I) + ',0)'], '^', 4),
            ';', 1), -1);
          FCPRSClipBoard[High(FCPRSClipBoard)].CopiedFromPackage :=
            Piece(Piece(BufferList.Values['(' + IntToStr(I) + ',0)'], '^',
            4), ';', 2);
          FCPRSClipBoard[High(FCPRSClipBoard)].ApplicationName :=
            Piece(BufferList.Values['(' + IntToStr(I) + ',0)'], '^', 6);
          FCPRSClipBoard[High(FCPRSClipBoard)].CopiedText := TStringList.Create;
          NumLines :=
            StrToIntDef(Piece(BufferList.Values['(' + IntToStr(I) + ',0)'],
            '^', 5), -1);
          for X := 1 to NumLines do
            FCPRSClipBoard[High(FCPRSClipBoard)
              ].CopiedText.Add(BufferList.Values['(' + IntToStr(I) + ',' +
              IntToStr(X) + ')']);

        end;
        FLoadedBuffer := true;

      finally
        If StopStopWatch then
          LogText('METRIC', 'Buffer build: ' + fStopWatch.Elapsed);
      end;

    end;

  finally
    BufferList.Free;
  end;
end;

procedure TCopyApplicationMonitor.SaveTheBuffer();
var
  SaveList, ReturnList: TStringList;
  I, SaveCnt: Integer;
  ErrOccurred: Boolean;
begin
  ErrOccurred := False;
  if not fEnabled then
    Exit;

  if FBufferPolled and not FLoadedBuffer then
  begin
    // Ensure that the buffer poll has stoped
    if Assigned(fStopPollBuff) then
    begin
      LogText('BUFF', 'RPC STOP POLL');
      StartStopWatch;
      try
        fStopPollBuff(Self, ErrOccurred);
      finally
        If StopStopWatch then
          LogText('METRIC', 'Stop Buffer RPC: ' + fStopWatch.Elapsed);
      end;
    end;
  end;

  SaveList := TStringList.Create;
  ReturnList := TStringList.Create;
  try
    SaveCnt := 0;

    LogText('BUFF', 'Preparing Buffer for Save');
    StartStopWatch;
    try
      for I := Low(FCPRSClipBoard) to High(FCPRSClipBoard) do
      begin
        if FCPRSClipBoard[I].SaveToTheBuffer then
        begin
          Inc(SaveCnt);
          SaveList.Add(IntToStr(SaveCnt) + ',0=' + IntToStr(UserDuz) + '^' +
            FCPRSClipBoard[I].DateTimeOfCopy + '^' +
            IntToStr(FCPRSClipBoard[I].CopiedFromIEN) + ';' + FCPRSClipBoard[I]
            .CopiedFromPackage + '^' + FCPRSClipBoard[I].ApplicationPackage +
            '^' + FCPRSClipBoard[I].ApplicationName);

          SaveList.Add(IntToStr(SaveCnt) + ',-1=' +
            IntToStr(FCPRSClipBoard[I].CopiedText.Count));
          BreakUpLongLines(SaveList, IntToStr(SaveCnt),
            FCPRSClipBoard[I].CopiedText, FBreakUpLimit);

        end;
      end;
      SaveList.Add('TotalBufferToSave=' + IntToStr(SaveCnt));
    finally
      If StopStopWatch then
        LogText('METRIC', 'Build Save: ' + fStopWatch.Elapsed);
    end;
    LogText('BUFF', IntToStr(SaveCnt) + ' Items ready to save');
    if Assigned(FSaveBuffer) then
    begin
      StartStopWatch;
      try
        FSaveBuffer(Self, SaveList, ReturnList);
      finally
        If StopStopWatch then
          LogText('METRIC', 'Buffer Save RPC: ' + fStopWatch.Elapsed);
      end;
    end;
  finally
    ReturnList.Free;
    SaveList.Free;
  end;
end;

procedure TCopyApplicationMonitor.LoadTheProperties();
begin
  if not fEnabled then
    Exit;
  if not FLoadedProperties and Assigned(FLoadProperties) then
  begin

    StartStopWatch;
    try
      FLoadProperties(Self);
    finally
      If StopStopWatch then
        LogText('METRIC', 'Load Properties: ' + fStopWatch.Elapsed);
    end;

    // Log the properties
    LogText('PROP', 'Loading properties' + #13#10 + 'Number of words:' +
      FloatToStr(FNumberOfWords) + #13#10 + 'Percent to verify:' +
      FloatToStr(PercentToVerify));

  end;
  FLoadedProperties := true;

end;

function TCopyApplicationMonitor.WordCount(TextToCount: string): Integer;
var
  CharCnt: Integer;

  function IsEnd(CharToCheck: char): Boolean;
  begin
    Result := CharInSet(CharToCheck, [#0 .. #$1F, ' ', '.', ',', '?', ':', ';',
      '(', ')', '/', '\']);
  end;

begin
//  if not fEnabled then
//    Exit;
  Result := 0;
  if fEnabled then begin
    CharCnt := 1;
    while CharCnt <= Length(TextToCount) do
    begin
      while (CharCnt <= Length(TextToCount)) and (IsEnd(TextToCount[CharCnt])) do
        Inc(CharCnt);
      if CharCnt <= Length(TextToCount) then
      begin
        Inc(Result);
        while (CharCnt <= Length(TextToCount)) and
          (not IsEnd(TextToCount[CharCnt])) do
          Inc(CharCnt);
      end;
    end;
  end;
end;

function TCopyApplicationMonitor.LevenshteinDistance(String1, String2: String;
  CutOff: Integer): Double;
Var
  currentRow, previousRow, tmpRow: Array of Integer;
  firstLength, secondLength, I, J, tmpTo, tmpFrom, Cost: Integer;
  tmpStr: String;
  tmpChar: char;

begin
  Result := 0.0;
  if not fEnabled then
    Exit;
  firstLength := Length(String1);
  secondLength := Length(String2);

  if (firstLength = 0) then
  begin
    Result := secondLength;
    Exit;
  end
  else if (secondLength = 0) then
  begin
    Result := firstLength;
    Exit;
  end;

  if (firstLength > secondLength) then
  begin
    // Need to swap the text around for the compare
    tmpStr := String1;
    String1 := String2;
    String2 := tmpStr;
    // set the new lengths
    firstLength := secondLength;
    secondLength := Length(String2);
  end;

  // IF no max then use the longest length
  If (CutOff < 0) then
    CutOff := secondLength;

  // If more characters changed then our % threshold would allow then no need to calc
  if (secondLength - firstLength > CutOff) then
  begin
    Result := -1;
    Exit;
  end;

  SetLength(currentRow, firstLength + 1);
  SetLength(previousRow, firstLength + 1);

  // Pad the array
  for I := 0 to firstLength do
    previousRow[I] := I;

  for I := 1 to secondLength do
  begin
    tmpChar := String2[I];
    currentRow[0] := I - 1;
    tmpFrom := Max(I - CutOff - 1, 1);
    tmpTo := min(I + CutOff + 1, firstLength);
    for J := tmpFrom to tmpTo do
    begin
      if String1[J] = tmpChar then
        Cost := 0
      else
        Cost := 1;
      currentRow[J] := min(min(currentRow[J - 1] + 1, previousRow[J] + 1),
        previousRow[J - 1] + Cost);
    end;
    // shift the array around
    tmpRow := Copy(previousRow, 0, Length(previousRow));
    previousRow := Copy(currentRow, 0, Length(currentRow));
    currentRow := Copy(tmpRow, 0, Length(tmpRow));
    // clean up
    SetLength(tmpRow, 0);
  end;

  Result := (1 - (previousRow[firstLength] / Max(firstLength,
    secondLength))) * 100;

end;

procedure TCopyApplicationMonitor.RecalPercentage(ReturnedList: TStringList;
  var SaveList: TStringList; ExisitingPaste: TPasteArray);
var
  I, Z: Integer;
  StringA, StringB: WideString;
  ArrayIdentifer, RPCIdentifer, Package, FromEdit: string;
  NumOfEntries, NumOfLines: Integer;
begin
  if not fEnabled then
    Exit;
  LogText('SAVE', 'Recalculate Percentage');
  StartStopWatch;
  try
    NumOfEntries := StrToIntDef(ReturnedList.Values['(0,0)'], 0);

    SaveList.Add('0=' + IntToStr(NumOfEntries));

    for I := 1 to NumOfEntries do
    begin

      FromEdit := Piece(ReturnedList.Values['(' + IntToStr(I) + ',0)'], '^', 5);

      if FromEdit = '1' then
      begin
        ArrayIdentifer :=
          Piece(ReturnedList.Values['(' + IntToStr(I) + ',0)'], '^', 2);

        // Build String a from the internal clipboard
        for Z := Low(ExisitingPaste) to High(ExisitingPaste) do
        begin
          if ExisitingPaste[Z].PasteDBID = StrToIntDef(ArrayIdentifer, -1) then
          begin
            if Assigned(ExisitingPaste[Z].OriginalText) then
              StringA := ExisitingPaste[Z].OriginalText.Text
            else
              StringA := ExisitingPaste[Z].PastedText.Text;
            Break;
          end;
        end;
      end
      else
      begin
        ArrayIdentifer :=
          Piece(ReturnedList.Values['(' + IntToStr(I) + ',0)'], '^', 1);

        // Build String a from the internal clipboard
        for Z := Low(FCPRSClipBoard) to High(FCPRSClipBoard) do
        begin
          if FCPRSClipBoard[Z].SaveItemID = StrToIntDef(ArrayIdentifer, -1) then
          begin
            StringA := FCPRSClipBoard[Z].CopiedText.Text;
            Break;
          end;
        end;
      end;

      // build string B from what was saved
      RPCIdentifer :=
        Piece(ReturnedList.Values['(' + IntToStr(I) + ',0)'], '^', 2);
      Package := Piece(ReturnedList.Values['(' + IntToStr(I) + ',0)'], '^', 3);
      NumOfLines := StrToIntDef
        (Piece(ReturnedList.Values['(' + IntToStr(I) + ',0)'], '^', 4), 0);

      StringB := '';
      for Z := 1 to NumOfLines do
      begin
        StringB := StringB + ReturnedList.Values
          ['(' + IntToStr(I) + ',' + IntToStr(Z) + ')'] + #13#10;
      end;

      // Strip the cariage returns out
      StringA := StringReplace(StringReplace(StringA, #13, '', [rfReplaceAll]),
        #10, '', [rfReplaceAll]);
      StringB := StringReplace(StringReplace(StringB, #13, '', [rfReplaceAll]),
        #10, '', [rfReplaceAll]);

      SaveList.Add(IntToStr(I) + '=' + RPCIdentifer + '^' + Package + '^' +
        IntToStr(round(LevenshteinDistance(StringA, StringB, -1))));

    end;
  finally
    If StopStopWatch then
      LogText('METRIC', 'Recal Build: ' + fStopWatch.Elapsed);
  end;
end;

procedure TCopyApplicationMonitor.LogText(Action: string;
  MessageTxt: TPasteArray);
begin
  if not fEnabled then
    Exit;
  if Assigned(FLogObject) then
    if FLogObject.fLogToFile = LOG_DETAIL then
      FLogObject.LogText(Action, FLogObject.Dump(MessageTxt));
end;

procedure TCopyApplicationMonitor.LogText(Action, MessageTxt: String);
begin
  if not fEnabled then
    Exit;
  if Assigned(FLogObject) then
    FLogObject.LogText(Action, MessageTxt);
end;

function TCopyApplicationMonitor.GetClipSource(): tClipInfo;

  function GetAppByPID(PID: Cardinal): String;
  var
    snapshot: THandle;
    ProcEntry: TProcessEntry32;
  begin
    snapshot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    if (snapshot <> INVALID_HANDLE_VALUE) then
    begin
      ProcEntry.dwSize := SizeOf(ProcessEntry32);
      if (Process32First(snapshot, ProcEntry)) then
      begin
        // check the first entry
        if ProcEntry.th32ProcessID = PID then
          Result := ProcEntry.szExeFile
        else
        begin
          while Process32Next(snapshot, ProcEntry) do
          begin
            if ProcEntry.th32ProcessID = PID then
            begin
              Result := ProcEntry.szExeFile;
              Break;
            end;
          end;
        end;
      end;
    end;
    CloseHandle(snapshot);
  end;

  function GetHandleByPID(PID: Cardinal): HWND;
  type
    TEInfo = record
      PID: DWORD;
      HWND: THandle;
    end;
  var
    EInfo: TEInfo;

    function CallBack(Wnd: DWORD; var EI: TEInfo): Bool; stdcall;
    var
      PID: DWORD;
    begin
      GetWindowThreadProcessID(Wnd, @PID);
      Result := (PID <> EI.PID) or (not IsWindowVisible(Wnd)) or
        (not IsWindowEnabled(Wnd));

      if not Result then
        EI.HWND := Wnd;
    end;

  begin
    EInfo.PID := PID;
    EInfo.HWND := 0;
    EnumWindows(@CallBack, Integer(@EInfo));
    Result := EInfo.HWND;
  end;

begin
  if not fEnabled then
    Exit;
  LogText('PASTE', 'Clip Source');
  with Result do
  begin
    ObjectHwnd := 0;
    AppHwnd := 0;
    AppPid := 0;
    // Get the owners handle (TEdit, etc...)
    ObjectHwnd := GetClipboardOwner;
    if ObjectHwnd <> 0 then
    begin
      // Get its running applications Process ID
      GetWindowThreadProcessID(ObjectHwnd, AppPid);

      if AppPid <> 0 then
      begin
        // Get the applciation name from the Process ID
        AppName := GetAppByPID(AppPid);

        // Get the main applications hwnd
        AppHwnd := GetHandleByPID(AppPid);

        SetLength(AppClass, 255);
        SetLength(AppClass, GetClassName(AppHwnd, PChar(AppClass),
          Length(AppClass)));
        SetLength(AppTitle, 255);
        SetLength(AppTitle, GetWindowText(AppHwnd, PChar(AppTitle),
          Length(AppTitle)));

      end
      else
        AppName := 'No Process Found';
    end
    else
      AppName := 'No Source Found';

  end;
end;

function TCopyApplicationMonitor.FromExcludedApp(AppName: String): Boolean;
var
  I: Integer;
begin
  Result := false;
  if not fEnabled then
    Exit;
  for I := 0 to ExcludeApps.Count - 1 do
  begin
    if UpperCase(Piece(ExcludeApps[I], '^', 1)) = UpperCase(AppName) then
    begin
      Result := true;
      Break;
    end;
  end;
end;

procedure TCopyApplicationMonitor.SyncSizes(Sender: TObject);
var
  I, UseHeight: Integer;
begin
  if not fEnabled then
    Exit;
  UseHeight := TCopyPasteDetails(Sender).Height;
  if Assigned(fSyncSizeList) then
  begin
    for I := Low(fSyncSizeList) to High(fSyncSizeList) do
    begin
      if Assigned(fSyncSizeList[I]) then
        if fSyncSizeList[I] <> Sender then
          TCopyPasteDetails(fSyncSizeList[I]).Height := UseHeight;
    end;
  end;
end;

Function TCopyApplicationMonitor.StartStopWatch(): Boolean;
begin

  Result := Assigned(fStopWatch);
  if Result then
    fStopWatch.Start;
end;

Function TCopyApplicationMonitor.StopStopWatch(): Boolean;
begin
  Result := Assigned(fStopWatch);
  if Result then
    fStopWatch.Stop;
end;

procedure TCopyApplicationMonitor.SetEnabled(aValue: Boolean);
begin
  fEnabled := aValue;
end;

{$ENDREGION}
{$REGION 'CopyEditMonitor'}

Function TCopyEditMonitor.CopyToMonitor(Sender: TObject; AllowMonitor: Boolean;
  Msg: uint): Boolean;
begin
  Result := False;
  if not Assigned(FCopyMonitor) then
    Exit;
  if not FCopyMonitor.Enabled then
    Exit;
  inherited;
  if Assigned(FCopyToMonitor) then
  begin
    StartStopWatch;
    try
      FCopyToMonitor(Self, AllowMonitor);
    finally
      If StopStopWatch then
        FCopyMonitor.LogText('METRIC', 'Allow Copy RPC: ' + fStopWatch.Elapsed);
    end;
  end;

  // Set the return
  Result := AllowMonitor;

  if AllowMonitor then
  begin
    CopyMonitor.CopyToCopyPasteClipboard(Trim(TCustomEdit(Sender).SelText),
      RelatedPackage, ItemIEN);
    if (Msg = WM_CUT) then
      TCustomEdit(Sender).SelText := '';
  end;
end;

procedure TCopyEditMonitor.PasteToMonitor(Sender: TObject;
  AllowMonitor: Boolean; ClipInfo: tClipInfo);
Var
  PasteDetails: String;
  dwSize: DWORD;
  gMem: HGLOBAL;
  lp: Pointer;
  I: Integer;
  ProcessPaste: Boolean;
  CompareText: TStringList;
begin
  if not Assigned(FCopyMonitor) then
    Exit;
  if not FCopyMonitor.Enabled then
    Exit;
{$WARN SYMBOL_PLATFORM OFF}
  inherited;
  if Assigned(FPasteToMonitor) then
  begin
    StartStopWatch;
    try
      FPasteToMonitor(Self, AllowMonitor);
    finally
      If StopStopWatch then
        FCopyMonitor.LogText('METRIC', 'Allow Paste RPC: ' +
          fStopWatch.Elapsed);
    end;
  end;

  TCustomEdit(Sender).SelText := Clipboard.AsText;
  if AllowMonitor then
  begin
    FCopyMonitor.LogText('PASTE', 'Data pasted to IEN(' +
      IntToStr(ItemIEN) + ')');
    PasteDetails := '';
    // Get the details from the clipboard
    if Clipboard.HasFormat(Self.CopyMonitor.CF_CopyPaste) then
    begin
      gMem := Clipboard.GetAsHandle(Self.CopyMonitor.CF_CopyPaste);
      try
        Win32Check(gMem <> 0);
        lp := GlobalLock(gMem);
        Win32Check(lp <> nil);
        dwSize := GlobalSize(gMem);
        if dwSize <> 0 then
        begin
          SetString(PasteDetails, PAnsiChar(lp), dwSize - 1);
        end;
      finally
        GlobalUnlock(gMem);
      end;

      FCopyMonitor.LogText('PASTE', 'Cross session clipboard found');
    end;

    if Clipboard.HasFormat(CF_TEXT) then
    begin
      ProcessPaste := false;
      CompareText := TStringList.Create;
      try
        CompareText.Text := Trim(Clipboard.AsText);
        for I := Low(FCopyMonitor.FCPRSClipBoard)
          to High(FCopyMonitor.FCPRSClipBoard) do
        begin
          If AnsiSameText(Trim(FCopyMonitor.FCPRSClipBoard[I].CopiedText.Text),
            Trim(CompareText.Text)) then
          begin
            if (FCopyMonitor.FCPRSClipBoard[I].CopiedFromIEN <> ItemIEN) then
              ProcessPaste := true;
          end;
        end;

        if not ProcessPaste then
          if (FCopyMonitor.WordCount(CompareText.Text) >=
            FCopyMonitor.FNumberOfWords) then
            ProcessPaste := true;

      finally
        CompareText.Free;
      end;

      if ProcessPaste then
      begin
        SetLength(FCopyMonitor.FCopyPasteThread,
          Length(FCopyMonitor.FCopyPasteThread) + 1);
        FCopyMonitor.FCopyPasteThread[High(FCopyMonitor.FCopyPasteThread)] :=
          TCopyPasteThread.Create(Trim(Clipboard.AsText), PasteDetails, ItemIEN,
          FCopyMonitor, ClipInfo);
{$WARN SYMBOL_DEPRECATED OFF}
        FCopyMonitor.FCopyPasteThread
          [High(FCopyMonitor.FCopyPasteThread)].Start;
{$WARN SYMBOL_DEPRECATED ON}
        SetLength(PasteText, Length(PasteText) + 1);
        PasteText[High(PasteText)].DateTimeOfPaste :=
          FloatToStr(DateTimeToFMDateTime(Now));
        PasteText[High(PasteText)].New := true;
        PasteText[High(PasteText)].PasteDBID := -1;
        PasteText[High(PasteText)].PastedText := TStringList.Create;
        PasteText[High(PasteText)].PastedText.Text := Trim(Clipboard.AsText);
        PasteText[High(PasteText)].IdentFired := false;

        if Assigned(FVisualMessage) then
        begin
          if not FCopyMonitor.DisplayPaste then
            FVisualMessage(Self, Hide_Panel, [true])
          else
            FVisualMessage(Self, ShowHighlight, [true]);
        end;
      end;

    end;

  end;
{$WARN SYMBOL_PLATFORM ON}
end;

procedure TCopyEditMonitor.ClearTheMonitor();
begin
  if not Assigned(FCopyMonitor) then
    Exit;
  if not FCopyMonitor.Enabled then
    Exit;
  CopyMonitor.ClearCopyPasteClipboard;
end;

procedure TCopyEditMonitor.SetItemIEN(NewItemIEN: Int64);
begin
  if not Assigned(FCopyMonitor) then
    Exit;
  if not FCopyMonitor.Enabled then
    Exit;
  fItemIEN := NewItemIEN;
  // do not show the pannel if there is no note loaded
  if Assigned(FVisualMessage) then
    FVisualMessage(Self, Hide_Panel, [(fItemIEN < 1)]);
end;

procedure TCopyEditMonitor.SaveTheMonitor(Sender: TObject; ItemID: Integer);
var
  SaveList, ReturnList: TStringList;
  I, ReturnCursor: Integer;
  CanContinue: Boolean;
begin
  if not Assigned(FCopyMonitor) then
    Exit;
  if not FCopyMonitor.Enabled then
    Exit;

  SaveList := TStringList.Create;
  ReturnList := TStringList.Create;
  try
    inherited;

    CanContinue := false;
    ReturnCursor := Screen.Cursor;
    Screen.Cursor := crHourGlass;
    try
      while not CanContinue do
      begin
        CanContinue := true;
        for I := Low(FCopyMonitor.FCopyPasteThread)
          to High(FCopyMonitor.FCopyPasteThread) do
        begin
          if FCopyMonitor.FCopyPasteThread[I].TheadOwner = ItemID then
          begin
            FCopyMonitor.LogText('SAVE', 'Thread still exist, can not save');
            CanContinue := false;
            Break;
          end;
        end;
      end;
    finally
      Screen.Cursor := ReturnCursor;
    end;

    ItemIEN := ItemID;

    FCopyMonitor.LogText('SAVE', 'Saving paste data for IEN(' +
      IntToStr(ItemID) + ')');

    // get information about new paste
    CopyMonitor.SaveCopyPasteClipboard(Self, SaveList);

    // check for modified entries
    if Sender is TCopyPasteDetails then
      TCopyPasteDetails(Sender).CheckForModifiedPaste(SaveList);

    if Assigned(FSaveTheMonitor) then
    begin
      StartStopWatch;
      try
        FSaveTheMonitor(Self, SaveList, ReturnList);
      finally
        If StopStopWatch then
          FCopyMonitor.LogText('METRIC',
            'Save RPC: ' + FCopyMonitor.fStopWatch.Elapsed);
      end;
    end;

    if ReturnList.Count > 1 then
    begin
      // there was an error so dont recalculate
      if StrToIntDef(ReturnList[0], 0) > 1 then
      begin

        FCopyMonitor.LogText('SAVE', 'Recalculating percentage for IEN(' +
          IntToStr(ItemID) + ')');
        // Recaulculate the after save percentage
        SaveList.Clear;
        if Sender is TCopyPasteDetails then
          CopyMonitor.RecalPercentage(ReturnList, SaveList,
            TCopyPasteDetails(Sender).EditMonitor.PasteText);

        if Assigned(FRecalPer) then
        begin
          StartStopWatch;
          try
            FRecalPer(Self, SaveList);
          finally
            If StopStopWatch then
              CopyMonitor.LogText('METRIC',
                'Recal RPC: ' + CopyMonitor.fStopWatch.Elapsed);
          end;
        end;
      end;
    end;

    // we are done so clear
    CopyMonitor.ClearCopyPasteClipboard();

  finally
    ReturnList.Free;
    SaveList.Free;
  end;
end;

constructor TCopyEditMonitor.Create(AOwner: TComponent);
var
  I: Integer;
begin
  inherited Create(AOwner);
  FVisualMessage := nil;
  FTrackOnlyObjects := TTrackOnlyCollection.Create(Self);
  SetLength(PasteText, 0);
  for I := 1 to ParamCount do
  begin
    if UpperCase(ParamStr(I)) = 'CPLOG' then
    begin
      fStopWatch := TStopWatch.Create(Self, true);
      Break;
    end
    else if UpperCase(ParamStr(I)) = 'CPLOGDEBUG' then
    begin
      fStopWatch := TStopWatch.Create(Self, true);
      Break;
    end;
  end;
end;

destructor TCopyEditMonitor.Destroy;
var
  I: Integer;
begin
  for I := 0 to TrackOnlyEdits.Count - 1 do
  begin
    with TrackOnlyEdits.GetItem(I) do
    begin
      FObject.WindowProc := FOurOrigWndProc;
      FObject := nil;
    end;
  end;
  ClearPasteArray;

  if Assigned(fStopWatch) then
    fStopWatch.Free;
  FTrackOnlyObjects.Free;
  inherited;
end;

procedure TCopyEditMonitor.ClearPasteArray();
Var
  I, X: Integer;
begin

  for I := high(PasteText) downto Low(PasteText) do
  begin
    for X := Low(PasteText[I].GroupItems) to High(PasteText[I].GroupItems) do
      PasteText[I].GroupItems[X].GroupText.Free;
    SetLength(PasteText[I].GroupItems, 0);

    SetLength(PasteText[I].HiglightLines, 0);
    PasteText[I].PastedText.Free;

  end;
  SetLength(PasteText, 0);
end;

procedure TCopyEditMonitor.SetOurCollection(const Value: TTrackOnlyCollection);
begin
  FTrackOnlyObjects.Assign(Value);
end;

Procedure TCopyEditMonitor.MonitorAllAvailable();
var
  list: TList;
  I, idx: Integer;
  Control: TWinControl;
  Item: TTrackOnlyItem;

  function OwnerCheck(Component: TComponent): Boolean;
  var
    root: TComponent;
  begin
    Result := false;
    root := Component;
    while Assigned(root) do
    begin
      if root = owner then
      begin
        Result := true;
        Exit;
      end;
      root := root.owner;
    end;
  end;

  procedure Update(Component: TWinControl);
  var
    I: Integer;
  begin
    if (((not Assigned(Component.Parent)) or (csAcceptsControls
      in Component.Parent.ControlStyle)) and (Component is TCustomEdit)) then
      list.Add(Component);
    for I := 0 to Component.ControlCount - 1 do
    begin
      if Component.Controls[I] is TWinControl then
      begin
        Control := TWinControl(Component.Controls[I]);
        if (not Assigned(Control.owner)) or OwnerCheck(Control) then
          Update(Control);
      end;
    end;
  end;

begin
  if not Assigned(FCopyMonitor) then
    Exit;
  if not FCopyMonitor.Enabled then
    Exit;
  FCopyMonitor.LogText('DYNAMIC', 'Monitor All Available');
  list := TList.Create;
  try
    // Load our list with the components
    if (owner is TWinControl) and
      ([csLoading, csDesignInstance] * owner.ComponentState = []) then
      Update(TWinControl(owner));

    // Filter out items that exist
    for I := FTrackOnlyObjects.Count - 1 downto 0 do
    begin
      Item := FTrackOnlyObjects[I];

      if Assigned(Item.TrackObject) then
      begin
        idx := list.IndexOf(Item.TrackObject);
        if idx < 0 then
          Item.Free
        else
          list.delete(idx);
      end
      else
        Item.Free;
    end;
    // Item := nil;
    for I := 0 to list.Count - 1 do
    begin
      Item := FTrackOnlyObjects.Add;
      Item.TrackObject := TCustomEdit(list[I]);
    end;

  finally
    list.Free;
  end;
end;

procedure TCopyEditMonitor.TransferData(Dest: TCopyEditMonitor);
Var
  I: Integer;
begin
  if not Assigned(FCopyMonitor) then
    Exit;
  if not FCopyMonitor.Enabled then
    Exit;
  FCopyMonitor.LogText('DYNAMIC', 'Transfer Data');
  // First move all IENs over
  for I := Low(CopyMonitor.FCPRSClipBoard)
    to High(CopyMonitor.FCPRSClipBoard) do
  begin
    if CopyMonitor.FCPRSClipBoard[I].PasteToIEN = Self.ItemIEN then
    begin
      CopyMonitor.FCPRSClipBoard[I].PasteToIEN := Dest.ItemIEN;
    end;
  end;

  // Now move the paste text over
  for I := Low(PasteText) to High(PasteText) do
  begin
    SetLength(Dest.PasteText, Length(Dest.PasteText) + 1);
    Dest.PasteText[High(Dest.PasteText)].DateTimeOfPaste :=
      PasteText[I].DateTimeOfPaste;
    Dest.PasteText[High(Dest.PasteText)].New := PasteText[I].New;
    Dest.PasteText[High(Dest.PasteText)].PasteDBID := -1;
    Dest.PasteText[High(Dest.PasteText)].PastedText := TStringList.Create;
    Dest.PasteText[High(Dest.PasteText)].PastedText.Text :=
      PasteText[I].PastedText.Text;
    Dest.PasteText[High(Dest.PasteText)].IdentFired := false;
  end;

  if Assigned(Dest.VisualMessage) then
  begin
    if not Dest.CopyMonitor.DisplayPaste then
      Dest.VisualMessage(Dest, Hide_Panel, [true])
    else
      Dest.VisualMessage(Dest, Show_Panel, [true]);
  end;

end;

Function TCopyEditMonitor.StartStopWatch(): Boolean;
begin

  Result := Assigned(fStopWatch);
  if Result then
    fStopWatch.Start;
end;

Function TCopyEditMonitor.StopStopWatch(): Boolean;
begin
  Result := Assigned(fStopWatch);
  if Result then
    fStopWatch.Stop;
end;

// Use this to search and ignore spaces and lines less than 3 words
function TCopyEditMonitor.LoadIdentLines(TheRich: TRichEdit;
  SearchText: TStringList; var HighRec: THighlightRecordArray;
  RecAnalyzed: Boolean): Boolean;
var
  I, LastSrchPos: Integer;
  cloneArray: Boolean;
  TempHighlightArray: array of tHighlightRecord;
  HashSearch: THashedStringList;
begin
{  if not Assigned(FCopyMonitor) then
    Exit;
  if not FCopyMonitor.Enabled then
    Exit; }
  Result := False;
  if Assigned(FCopyMonitor) and FCopyMonitor.Enabled then begin
    // First look for the entire text
    Result := (TheRich.FindText(StringReplace(Trim(SearchText.Text), #10, '',
      [rfReplaceAll]), 0, Length(TheRich.Text), []) > -1);
    if Result then
    begin
      SetLength(HighRec, Length(HighRec) + 1);
      with HighRec[high(HighRec)] do
      begin
        LineToHighlight := StringReplace(Trim(SearchText.Text), #10, '',
          [rfReplaceAll]);
        AboveWrdCnt := true;
      end;
    end
    else if RecAnalyzed then
    begin
      // Next look for the broken up text
      SetLength(TempHighlightArray, 0);
      cloneArray := false;
      LastSrchPos := 0;
      // Move list into has for faster search
      HashSearch := THashedStringList.Create;
      try
        HashSearch.Assign(SearchText);
        for I := 0 to HashSearch.Count - 1 do
        begin
          if StringReplace(Trim(HashSearch[I]), #10, '', [rfReplaceAll]) = '' then
            Continue;
          SetLength(TempHighlightArray, Length(TempHighlightArray) + 1);
          with TempHighlightArray[High(TempHighlightArray)] do
          begin
            LineToHighlight := StringReplace(Trim(HashSearch[I]), #10, '',
              [rfReplaceAll]);

            if CopyMonitor.WordCount(LineToHighlight) > 2 then
            begin
              AboveWrdCnt := true;
              LastSrchPos := TheRich.FindText(LineToHighlight, LastSrchPos,
                Length(TheRich.Text), []);

              if LastSrchPos = -1 then
              begin
                // If one line greater than 2 words doesnt match the whole thing doesnt
                cloneArray := false;
                Break;
              end
              else
                cloneArray := true;
            end
            else
              AboveWrdCnt := false;
          end;
        end;
      finally
        HashSearch.Free;
      end;

      // Add to highlight array (meaning we can show these)
      if cloneArray then
      begin
        for I := Low(TempHighlightArray) to High(TempHighlightArray) do
        begin
          SetLength(HighRec, Length(HighRec) + 1);
          HighRec[high(HighRec)].LineToHighlight := TempHighlightArray[I]
            .LineToHighlight;
          HighRec[high(HighRec)].AboveWrdCnt := TempHighlightArray[I].AboveWrdCnt;
        end;
      end;
      SetLength(TempHighlightArray, 0);
      Result := cloneArray;
    end;
  end;
end;

procedure TCopyEditMonitor.SetCopyMonitor(Value: TCopyApplicationMonitor);
var
  ObjToUse: TCopyPasteDetails;
begin
  FCopyMonitor := Value;
  if owner is TCopyPasteDetails then
  begin
    ObjToUse := owner as TCopyPasteDetails;

    if ObjToUse.SyncSizes then
    begin
      with FCopyMonitor do
      begin
        SetLength(fSyncSizeList, Length(fSyncSizeList) + 1);
        fSyncSizeList[High(fSyncSizeList)] := TCopyPasteDetails(ObjToUse);
      end;
    end;
  end;
end;
{$ENDREGION}
{$REGION 'Misc'}

function Piece(const S: string; Delim: char; PieceNum: Integer): string;
var
  I: Integer;
  Strt, Next: PChar;
begin
  I := 1;
  Strt := PChar(S);
  Next := StrScan(Strt, Delim);
  while (I < PieceNum) and (Next <> nil) do
  begin
    Inc(I);
    Strt := Next + 1;
    Next := StrScan(Strt, Delim);
  end;
  if Next = nil then
    Next := StrEnd(Strt);
  if I < PieceNum then
    Result := ''
  else
    SetString(Result, Strt, Next - Strt);
end;

function FormatFMDateTime(AFormat: string; ADateTime: Double): string;
var
  X: string;
  Y, m, d, h, n, S: Integer;

  function CharAt(const X: string; APos: Integer): char;
  { returns a character at a given position in a string or the null character if past the end }
  begin
    if Length(X) < APos then
      Result := #0
    else
      Result := X[APos];
  end;

  function TrimFormatCount: Integer;
  { delete repeating characters and count how many were deleted }
  var
    c: char;
  begin
    Result := 0;
    c := AFormat[1];
    repeat
      delete(AFormat, 1, 1);
      Inc(Result);
    until CharAt(AFormat, 1) <> c;
  end;

begin { FormatFMDateTime }
  Result := '';
  if not(ADateTime > 0) then
    Exit;
  X := FloatToStrF(ADateTime, ffFixed, 15, 6) + '0000000';
  Y := StrToIntDef(Copy(X, 1, 3), 0) + 1700;
  m := StrToIntDef(Copy(X, 4, 2), 0);
  d := StrToIntDef(Copy(X, 6, 2), 0);
  h := StrToIntDef(Copy(X, 9, 2), 0);
  n := StrToIntDef(Copy(X, 11, 2), 0);
  S := StrToIntDef(Copy(X, 13, 2), 0);
  while Length(AFormat) > 0 do
  begin
    case UpCase(AFormat[1]) of
      '"':
        begin // literal
          delete(AFormat, 1, 1);
          while not(CharInSet(CharAt(AFormat, 1), [#0, '"'])) do
          begin
            Result := Result + AFormat[1];
            delete(AFormat, 1, 1);
          end;
          if CharAt(AFormat, 1) = '"' then
            delete(AFormat, 1, 1);
        end;
      'D':
        case TrimFormatCount of // day/date
          1:
            if d > 0 then
              Result := Result + IntToStr(d);
          2:
            if d > 0 then
              Result := Result + FormatFloat('00', d);
        end;
      'H':
        case TrimFormatCount of // hour
          1:
            Result := Result + IntToStr(h);
          2:
            Result := Result + FormatFloat('00', h);
        end;
      'M':
        case TrimFormatCount of // month
          1:
            if m > 0 then
              Result := Result + IntToStr(m);
          2:
            if m > 0 then
              Result := Result + FormatFloat('00', m);
          3:
            if m in [1 .. 12] then
              Result := Result + MONTH_NAMES_SHORT[m];
          4:
            if m in [1 .. 12] then
              Result := Result + MONTH_NAMES_LONG[m];
        end;
      'N':
        case TrimFormatCount of // minute
          1:
            Result := Result + IntToStr(n);
          2:
            Result := Result + FormatFloat('00', n);
        end;
      'S':
        case TrimFormatCount of // second
          1:
            Result := Result + IntToStr(S);
          2:
            Result := Result + FormatFloat('00', S);
        end;
      'Y':
        case TrimFormatCount of // year
          2:
            if Y > 0 then
              Result := Result + Copy(IntToStr(Y), 3, 2);
          4:
            if Y > 0 then
              Result := Result + IntToStr(Y);
        end;
    else
      begin // other
        Result := Result + AFormat[1];
        delete(AFormat, 1, 1);
      end;
    end; { case }
  end;
end; { FormatFMDateTime }

function DateTimeToFMDateTime(ADateTime: TDateTime): Double;
var
  Y, m, d, h, n, S, l: Word;
  DatePart, TimePart: Integer;
begin
  DecodeDate(ADateTime, Y, m, d);
  DecodeTime(ADateTime, h, n, S, l);
  DatePart := ((Y - 1700) * 10000) + (m * 100) + d;
  TimePart := (h * 10000) + (n * 100) + S;
  Result := DatePart + (TimePart / 1000000);
end;

function FilteredString(const X: string; ATabWidth: Integer = 8): string;
var
  I, J: Integer;
  c: char;
begin
  Result := '';
  for I := 1 to Length(X) do
  begin
    c := X[I];
    if c = #9 then
    begin
      for J := 1 to (ATabWidth - (Length(Result) mod ATabWidth)) do
        Result := Result + ' ';
    end
    else if CharInSet(c, [#32 .. #127]) then
    begin
      Result := Result + c;
    end
    else if CharInSet(c, [#10, #13, #160]) then
    begin
      Result := Result + ' ';
    end
    else if CharInSet(c, [#128 .. #159]) then
    begin
      Result := Result + '?';
    end
    else if CharInSet(c, [#161 .. #255]) then
    begin
      Result := Result + X[I];
    end;
  end;

  if Copy(Result, Length(Result), 1) = ' ' then
    Result := TrimRight(Result) + ' ';
end;

procedure BreakUpLongLines(var SaveList: TStringList; BaseNode: String;
  const OrigList: TStringList; BreakLimit: Integer);
var
  BrCnt, I, Z, LastBreakPos: Integer;
  LineText: WideString;
  BrokenUpList: TStringList;

begin

  BrokenUpList := TStringList.Create;
  try
    BrCnt := 0;
    for I := 0 to OrigList.Count - 1 do
    begin
      // break up long lines for the save
      if Length(OrigList[I]) > BreakLimit then
      begin
        // break this line up
        LineText := OrigList[I];

        // loop through and break up line at FBreakUpLimit
        while Length(LineText) > BreakLimit do
        begin
          Inc(BrCnt);
          LastBreakPos := BreakLimit;

          if (LineText[BreakLimit + 1] <> ' ') then
          begin
            for Z := BreakLimit downto 1 do
              if LineText[Z] = ' ' then
              begin
                LastBreakPos := Z;
                Break;
              end;
          end;

          BrokenUpList.Add(BaseNode + ',' + IntToStr(BrCnt) + '=' +
            FilteredString(Copy(LineText, 1, LastBreakPos)));
          LineText := Copy(LineText, LastBreakPos + 1, Length(LineText));

        end;
        // add any remainder
        if Length(LineText) > 0 then
        begin
          Inc(BrCnt);
          BrokenUpList.Add(BaseNode + ',' + IntToStr(BrCnt) + '=' +
            FilteredString(LineText));
        end;
      end
      else
      begin
        Inc(BrCnt);
        BrokenUpList.Add(BaseNode + ',' + IntToStr(BrCnt) + '=' +
          FilteredString(OrigList[I]));
      end;

    end;

    // add our final line count
    SaveList.Add(BaseNode + ',-1=' + IntToStr(BrCnt));
    // Add our text
    for I := 0 to BrokenUpList.Count - 1 do
      SaveList.Add(BrokenUpList.Strings[I]);

  finally
    BrokenUpList.Free;
  end;
end;

{$ENDREGION}
{$REGION 'Thread'}

constructor TCopyPasteThread.Create(PasteText, PasteDetails: String;
  ItemIEN: Int64; EditMonitor: TComponent; ClipInfo: tClipInfo);
begin
  inherited Create(true);
  FreeOnTerminate := true;
  fEditMonitor := EditMonitor;
  fPasteText := PasteText;
  fPasteDetails := PasteDetails;
  fClipInfo := ClipInfo;
  fItemIEN := ItemIEN;
  TCopyApplicationMonitor(fEditMonitor).LogText('THREAD', 'Thread created');
end;

destructor TCopyPasteThread.Destroy;
var
  I: Integer;

  procedure DeleteX(const Index: Cardinal);
  var
    ALength: Cardinal;
    TailElements: Cardinal;
  begin
    with TCopyApplicationMonitor(fEditMonitor) do
    begin
      ALength := Length(FCopyPasteThread);
      Assert(ALength > 0);
      Assert(Index < ALength);
      TailElements := ALength - Index;
      if TailElements > 0 then
        Move(FCopyPasteThread[Index + 1], FCopyPasteThread[Index],
          SizeOf(FCopyPasteThread) * TailElements);

      SetLength(FCopyPasteThread, ALength - 1);
    end;
  end;

begin
  inherited;
  with TCopyApplicationMonitor(fEditMonitor) do
  begin

    for I := high(FCopyPasteThread) downto low(FCopyPasteThread) do
    begin
      if FCopyPasteThread[I] = Self then
      begin
        DeleteX(I);
        LogText('THREAD', 'Thread deleted');
      end;
    end;

  end;

end;

procedure TCopyPasteThread.Execute;
begin
  TCopyApplicationMonitor(fEditMonitor).CriticalSection.Acquire;
  try
    TCopyApplicationMonitor(fEditMonitor).LogText('THREAD',
      'Looking for matches');
    TCopyApplicationMonitor(fEditMonitor).PasteToCopyPasteClipboard(fPasteText,
      fPasteDetails, fItemIEN, fClipInfo);
  finally
    TCopyApplicationMonitor(fEditMonitor).CriticalSection.Release;
  end;
end;

{$ENDREGION}
{$REGION 'TcpyPasteDetails'}

Procedure TCopyPasteDetails.ManuallyShowNewHighlights();
begin
  with EditMonitor do
  begin
    if not Assigned(FCopyMonitor) then
      Exit;
    if not FCopyMonitor.Enabled then
      Exit;
    if Length(PasteText) > 0 then
    begin
      if Assigned(FVisualMessage) then
      begin
        if not FCopyMonitor.DisplayPaste then
          FVisualMessage(Self, Hide_Panel, [true])
        else
          FVisualMessage(Self, ShowHighlight, [true, true]);
      end;
    end;
  end;
end;

procedure TCopyPasteDetails.VisualMesageCenter(Sender: TObject;
  const CPmsg: Cardinal; CPVars: Array of Variant);
var
  SelectAll: Boolean;
begin
  if not Assigned(EditMonitor.FCopyMonitor) then
    Exit;
  if not EditMonitor.FCopyMonitor.Enabled then
    Exit;
  Try
    case CPmsg of
      Show_Panel:
        // CPVar[0] = Toggle to show panel
        ShowInfoPanel(Boolean(CPVars[0]));
      ShowAndSelect_Panel:
        Begin
          // CPVar[0] = Toggle to show panel
          // CPVar[1] = Select the all entries (if applicable)
          ShowInfoPanel(Boolean(CPVars[0]));
          if Boolean(CPVars[0]) then
          begin
            if FLastInfoboxHeight < Self.Constraints.MinHeight then
              FLastInfoboxHeight := Self.Constraints.MinHeight;
            if FInfoboxCollapsed then
            begin
              CloseInfoPanel(Self);
            end
            else
              Self.Height := FLastInfoboxHeight;

            // Autoselect the pasted text
            FInfoSelector.ItemIndex := 0;

            SelectAll := false;
            if Length(CPVars) > 1 then
              SelectAll := Boolean(CPVars[1]);

            if FInfoSelector.ItemIndex <> -1 then
            begin
              if (UpperCase(FInfoSelector.Items[FInfoSelector.ItemIndex])
                = 'ALL ENTRIES') and (not SelectAll) then
                FInfoSelector.ItemIndex := 1;
            end;

            lbSelectorClick(FInfoSelector);
            FInfoSelector.SetFocus;
          end;
        End;
      Hide_Panel:
        // CPVar[0] = Toggle to show panel
        // CPVar[1] = Select the all entries (if applicable)
        If Boolean(CPVars[0]) then
          ShowInfoPanel(false);
      ShowHighlight:
        Begin
          // CPVar[0] = Toggle to show panel
          ShowInfoPanel(Boolean(CPVars[0]));
          if Boolean(CPVars[0]) then
          begin
            if FLastInfoboxHeight < Self.Constraints.MinHeight then
              FLastInfoboxHeight := Self.Constraints.MinHeight;
            if FInfoboxCollapsed then
            begin
              CloseInfoPanel(Self);
            end
            else
              Self.Height := FLastInfoboxHeight;

            // Autoselect the pasted text
            FInfoSelector.ItemIndex := 0;

            SelectAll := false;
            if Length(CPVars) > 1 then
              SelectAll := Boolean(CPVars[1]);
            if FInfoSelector.ItemIndex <> -1 then
            begin
              if (UpperCase(FInfoSelector.Items[FInfoSelector.ItemIndex])
                = 'ALL ENTRIES') and (not SelectAll) then
                FInfoSelector.ItemIndex := 1;
            end;

            FInfoSelector.SelectorColor := clLtGray;
            FNewShowing := true;
            lbSelectorClick(FInfoSelector);
          end;
        End;
    end;

  Except
    on E: Exception do
    begin
      raise Exception.Create('Exception class name = ' + E.ClassName + #13 +
        'Exception message = ' + E.Message);
    end;

  End;
end;

procedure TCopyPasteDetails.InfoPanelResize(Sender: TObject);
begin
  if Assigned(EditMonitor.FCopyMonitor) then
    if not EditMonitor.FCopyMonitor.Enabled then
      Exit;
  if Self.Constraints.MinHeight <> (fTopPanel.Top + FInfoSelector.Top) then
    Self.Constraints.MinHeight := (fTopPanel.Top + FInfoSelector.Top);
  if FSuspendResize then
    Exit;
  if Self.Height > Self.Constraints.MinHeight then
  begin
    FCollapseBtn.Caption := 'Ú'; // up
    FInfoboxCollapsed := false;
  end;
  if Self.Height = Self.Constraints.MinHeight then
  begin
    FCollapseBtn.Caption := 'Ù'; // up
    FInfoboxCollapsed := true;
  end
  else
    FLastInfoboxHeight := Self.Height;
end;

Procedure TCopyPasteDetails.ReloadInfoPanel();
Var
  I: Integer;
begin
  if not Assigned(EditMonitor.FCopyMonitor) then
    Exit;
  if not EditMonitor.FCopyMonitor.Enabled then
    Exit;
  FInfoMessage.Text := '<-- Please select the desired paste date';
  With FInfoSelector, EditMonitor do
  begin
    TabOrder := FMonitorObject.TabOrder + 1;
    Clear;
    If Length(PasteText) > 1 then
      Items.Add('All Entries');
    for I := High(PasteText) downto Low(PasteText) do
    begin
      if PasteText[I].New then
        PasteText[I].InfoPanelIndex := Items.Add('new')
      else if PasteText[I].VisibleOnList then
        PasteText[I].InfoPanelIndex :=
          Items.Add(FormatFMDateTime('mmm dd,yyyy hh:nn',
          StrToFloat(PasteText[I].DateTimeOfPaste)));
    end;
    FInfoMessage.TabOrder := FMonitorObject.TabOrder + 2;
  end;
end;

procedure TCopyPasteDetails.CloseInfoPanel(Sender: TObject);
begin
  if Assigned(EditMonitor.FCopyMonitor) then
    if not EditMonitor.FCopyMonitor.Enabled then
      Exit;
  if Self.Constraints.MinHeight <> (fTopPanel.Top + FInfoSelector.Top) then
    Self.Constraints.MinHeight := (fTopPanel.Top + FInfoSelector.Top);
  FSuspendResize := true;
  if FInfoboxCollapsed then
  begin
    if FLastInfoboxHeight > 0 then
      Self.Height := FLastInfoboxHeight
    else
      Self.Height := Self.Constraints.MinHeight;
    FCollapseBtn.Caption := 'Ú'; // down
  end
  else
  begin
    FLastInfoboxHeight := Self.Height;
    Self.Height := Self.Constraints.MinHeight;
    FCollapseBtn.Caption := 'Ù'; // up
  end;
  FInfoboxCollapsed := Not FInfoboxCollapsed;
  FSuspendResize := false;
  if Assigned(FOnButtonToggle) then
    FOnButtonToggle(Self, FInfoboxCollapsed);
end;

procedure TCopyPasteDetails.ShowInfoPanel(Toggle: Boolean);
begin
  if Assigned(EditMonitor.FCopyMonitor) then
    if not EditMonitor.FCopyMonitor.Enabled then
      Exit;
  SendMessage(Parent.Handle, WM_SETREDRAW, 0, 0);
  try
    if Toggle then
    begin
      Self.Visible := true;
      ReloadInfoPanel;
      if Assigned(FShow) then
        FShow(Self);
    end
    else
    begin
      if Assigned(Self) then
      begin
        Self.Visible := false;
        if Assigned(FHide) then
          FHide(Self);
      end;

    end;
  finally
    SendMessage(Parent.Handle, WM_SETREDRAW, 1, 0);
    RedrawWindow(Parent.Handle, nil, 0, RDW_ERASE or RDW_FRAME or
      RDW_INVALIDATE or RDW_ALLCHILDREN);
  end;
end;

procedure TCopyPasteDetails.pnlMessageExit(Sender: TObject);
VAr
  Format: CHARFORMAT2;
  ResetMask: Integer;
  LastCurPos, LastCurSel: Integer;
begin
  if Assigned(EditMonitor.FCopyMonitor) then
    if not EditMonitor.FCopyMonitor.Enabled then
      Exit;
  with EditMonitor do
  begin
    ResetMask := TRichEdit(FMonitorObject).Perform(EM_GETEVENTMASK, 0, 0);
    TRichEdit(FMonitorObject).Perform(EM_SETEVENTMASK, 0, 0);
    TRichEdit(FMonitorObject).Perform(WM_SETREDRAW, Ord(false), 0);
    try
      LastCurPos := TRichEdit(FMonitorObject).SelStart;
      LastCurSel := TRichEdit(FMonitorObject).SelLength;
      TRichEdit(FMonitorObject).SelStart := 0;
      TRichEdit(FMonitorObject).SelLength :=
        Length(TRichEdit(FMonitorObject).Text);
      // Set the font
      TRichEdit(FMonitorObject).SelAttributes.Style := [];
      // Set the background color
      FillChar(Format, SizeOf(Format), 0);
      Format.cbSize := SizeOf(Format);
      Format.dwMask := CFM_BACKCOLOR;
      if TRichEdit(FMonitorObject).Color > 0 then
        Format.crBackColor := TRichEdit(FMonitorObject).Color
      else
        Format.crBackColor := clWhite;

      TRichEdit(FMonitorObject).Perform(EM_SETCHARFORMAT, SCF_SELECTION,
        Longint(@Format));
      TRichEdit(FMonitorObject).SelLength := 0;

      if not TRichEdit(FMonitorObject).ReadOnly and TRichEdit(FMonitorObject).Enabled
      then
        if FNewShowing then
        begin
          TRichEdit(FMonitorObject).SelStart := LastCurPos;
          TRichEdit(FMonitorObject).SelLength := LastCurSel;
        end
        else
          TRichEdit(FMonitorObject).SelStart := FPasteCurPos;

    finally
      TRichEdit(FMonitorObject).Perform(WM_SETREDRAW, Ord(true), 0);
      InvalidateRect(TRichEdit(FMonitorObject).Handle, NIL, true);
      TRichEdit(FMonitorObject).Perform(EM_SETEVENTMASK, 0, ResetMask);
    end;
  end;
end;

procedure TCopyPasteDetails.lbSelectorClick(Sender: TObject);
var
  I, ii, iii, CharCnt, X, ReturnFSize: Integer;
  FirstClear: Boolean;
  Synamb, DisplayTxt: TStringList;
begin
  if Assigned(EditMonitor.FCopyMonitor) then
    if not EditMonitor.FCopyMonitor.Enabled then
      Exit;
  if TListBox(Sender).ItemIndex < 0 then
    Exit;

  with EditMonitor do
  begin
    FInfoMessage.Clear;
    if UpperCase(TListBox(Sender).Items[TListBox(Sender).ItemIndex]) = 'ALL ENTRIES'
    then
    begin
      FInfoMessage.SelAttributes.Style := [fsBold, fsUnderline];
      ReturnFSize := FInfoMessage.SelAttributes.Size;
      FInfoMessage.SelAttributes.Size := ReturnFSize + 2;
      FInfoMessage.SelText := 'Paste Details';
      FInfoMessage.Lines.Add('');
      FInfoMessage.SelAttributes.Size := ReturnFSize;
      FInfoMessage.SelAttributes.Style := [];
      FInfoMessage.SelText := 'Details are provided for individual entries.';
      FInfoMessage.Lines.Add('');

      // now higlight all the items
      for I := Low(PasteText) to High(PasteText) do
      begin
        // Update highlight lines if its new (from transfer)
        if not(PasteText[I].IdentFired) then
        begin
          PasteText[I].VisibleOnNote := LoadIdentLines(FMonitorObject,
            PasteText[I].PastedText, PasteText[I].HiglightLines,
            PasteText[I].Analyzed);
          PasteText[I].IdentFired := true;
        end;

        if PasteText[I].VisibleOnNote then
        begin
          if Length(PasteText[I].GroupItems) > 0 then
          begin
            // Loop through the groups
            for ii := High(PasteText[I].GroupItems)
              downto Low(PasteText[I].GroupItems) do
            begin
              if PasteText[I].GroupItems[ii].GroupParent then
                Continue;
              // If the group is visible
              if PasteText[I].GroupItems[ii].VisibleOnNote then
              begin
                // Loop through the highlights
                for iii := Low(PasteText[I].GroupItems[ii].HiglightLines)
                  to High(PasteText[I].GroupItems[ii].HiglightLines) do
                begin
                  // If above word count
                  if PasteText[I].GroupItems[ii].HiglightLines[iii].AboveWrdCnt
                  then
                  begin
                    HighLightInfoPanel(CopyMonitor.HighlightColor,
                      CopyMonitor.MatchStyle, CopyMonitor.MatchHighlight,
                      PasteText[I].GroupItems[ii].HiglightLines[iii]
                      .LineToHighlight, false);
                  end;
                end;
              end;
            end;
          end
          else
          begin
            for ii := Low(PasteText[I].HiglightLines)
              to High(PasteText[I].HiglightLines) do
            begin
              if PasteText[I].HiglightLines[ii].AboveWrdCnt then
              begin
                HighLightInfoPanel(CopyMonitor.HighlightColor,
                  CopyMonitor.MatchStyle, CopyMonitor.MatchHighlight,
                  PasteText[I].HiglightLines[ii].LineToHighlight, false);
              end;
            end;
          end;
        end;
      end;

      FInfoMessage.SelStart := 0;
    end
    else
    begin

      for I := Low(PasteText) to High(PasteText) do
      begin
        if PasteText[I].InfoPanelIndex = TListBox(Sender).ItemIndex then
        begin
          FInfoMessage.SelAttributes.Style := [fsBold, fsUnderline];
          ReturnFSize := FInfoMessage.SelAttributes.Size;
          FInfoMessage.SelAttributes.Size := ReturnFSize + 2;
          FInfoMessage.SelText := 'Source (from)';
          FInfoMessage.Lines.Add('');
          FInfoMessage.SelAttributes.Size := ReturnFSize;

          if PasteText[I].New then
          begin
            FInfoMessage.SelAttributes.Style := [];
            if (Length(PasteText[I].PastedText.Text) >
              CopyMonitor.BackGroundLimit) and
              (CopyMonitor.BackGroundLimit <> -1) then
              FInfoMessage.SelText :=
                'Paste exceeds GUI highlight limit and will only be tracked in the report'
            else
              FInfoMessage.SelText :=
                'More details will be provided once saved';
            FInfoMessage.Lines.Add('');
          end;

          if PasteText[I].DateTimeOfOriginalDoc <> '' then
          begin
            FInfoMessage.SelAttributes.Style := [fsBold];
            FInfoMessage.SelText := 'Document created on: ';
            FInfoMessage.SelAttributes.Style := [];
            FInfoMessage.SelText := FormatFMDateTime('mmm dd,yyyy hh:nn',
              StrToFloat(PasteText[I].DateTimeOfOriginalDoc));
            FInfoMessage.Lines.Add('');
          end;

          if PasteText[I].CopiedFromLocation <> '' then
          begin
            if StrToIntDef(Piece(PasteText[I].CopiedFromLocation, ';', 1),
              -1) = -1 then
            begin
              CharCnt := 1;
              for iii := 0 to Length(PasteText[I].CopiedFromLocation) do
                if PasteText[I].CopiedFromLocation[iii] = ';' then
                  Inc(CharCnt);
              FInfoMessage.SelAttributes.Style := [fsBold];
              FInfoMessage.SelText := 'Patient: ';
              FInfoMessage.SelAttributes.Style := [];
              FInfoMessage.SelText := Piece(PasteText[I].CopiedFromLocation,
                ';', CharCnt);
              FInfoMessage.Lines.Add('');
            end
            else if PasteText[I].CopiedFromPatient <> '' then
            begin
              FInfoMessage.SelAttributes.Style := [fsBold];
              FInfoMessage.SelText := 'Patient: ';
              FInfoMessage.SelAttributes.Style := [];
              FInfoMessage.SelText :=
                Piece(PasteText[I].CopiedFromPatient, ';', 2);
              FInfoMessage.Lines.Add('');
            end;
          end
          else if PasteText[I].CopiedFromPatient <> '' then
          begin
            FInfoMessage.SelAttributes.Style := [fsBold];
            FInfoMessage.SelText := 'Patient: ';
            FInfoMessage.SelAttributes.Style := [];
            FInfoMessage.SelText :=
              Piece(PasteText[I].CopiedFromPatient, ';', 2);
            FInfoMessage.Lines.Add('');
          end;

          if PasteText[I].CopiedFromDocument <> '' then
          begin
            FInfoMessage.SelAttributes.Style := [fsBold];
            FInfoMessage.SelText := 'Title: ';
            FInfoMessage.SelAttributes.Style := [];
            FInfoMessage.SelText := PasteText[I].CopiedFromDocument;
            FInfoMessage.Lines.Add('');
          end;

          if Piece(PasteText[I].CopiedFromAuthor, ';', 2) <> '' then
          begin
            FInfoMessage.SelAttributes.Style := [fsBold];
            FInfoMessage.SelText := 'Author: ';
            FInfoMessage.SelAttributes.Style := [];
            FInfoMessage.SelText :=
              Piece(PasteText[I].CopiedFromAuthor, ';', 2);
            FInfoMessage.Lines.Add('');
          end;

          if PasteText[I].CopiedFromLocation <> '' then
          begin
            if StrToIntDef(Piece(PasteText[I].CopiedFromLocation, ';', 1), -1)
              <> -1 then
            begin
              FInfoMessage.SelAttributes.Style := [fsBold];
              FInfoMessage.SelText := 'ID: ';
              FInfoMessage.SelAttributes.Style := [];
              FInfoMessage.SelText :=
                Piece(PasteText[I].CopiedFromLocation, ';', 1);
              FInfoMessage.Lines.Add('');
            end;
            if Piece(PasteText[I].CopiedFromLocation, ';', 2) <> '' then
            begin
              FInfoMessage.SelAttributes.Style := [fsBold];
              FInfoMessage.SelText := 'From: ';
              FInfoMessage.SelAttributes.Style := [];
              FInfoMessage.SelText :=
                Piece(PasteText[I].CopiedFromLocation, ';', 2);
              FInfoMessage.Lines.Add('');
            end;
          end;

          if PasteText[I].CopiedFromApplication <> '' then
          begin
            FInfoMessage.SelAttributes.Style := [fsBold];
            FInfoMessage.SelText := 'Application: ';
            FInfoMessage.SelAttributes.Style := [];
            FInfoMessage.SelText := PasteText[I].CopiedFromApplication;
            FInfoMessage.Lines.Add('');
          end;

          FInfoMessage.Lines.Add('');

          FInfoMessage.SelAttributes.Style := [fsBold, fsUnderline];
          ReturnFSize := FInfoMessage.SelAttributes.Size;
          FInfoMessage.SelAttributes.Size := ReturnFSize + 2;
          FInfoMessage.SelText := 'Pasted Info';
          FInfoMessage.Lines.Add('');
          FInfoMessage.SelAttributes.Size := ReturnFSize;

          if PasteText[I].DateTimeOfPaste <> '' then
          begin
            FInfoMessage.SelAttributes.Style := [fsBold];
            FInfoMessage.SelText := 'Date: ';
            FInfoMessage.SelAttributes.Style := [];
            FInfoMessage.SelText := FormatFMDateTime('mmm dd,yyyy hh:nn',
              StrToFloat(PasteText[I].DateTimeOfPaste));
            FInfoMessage.Lines.Add('');
          end;

          if Piece(PasteText[I].UserWhoPasted, ';', 2) <> '' then
          begin
            FInfoMessage.SelAttributes.Style := [fsBold];
            FInfoMessage.SelText := 'User: ';
            FInfoMessage.SelAttributes.Style := [];
            FInfoMessage.SelText := Piece(PasteText[I].UserWhoPasted, ';', 2);
            FInfoMessage.Lines.Add('');
          end;

          if PasteText[I].PastedPercentage <> '' then
          begin
            FInfoMessage.SelAttributes.Style := [fsBold];
            FInfoMessage.SelText := 'Percentage: ';
            FInfoMessage.SelAttributes.Style := [];
            FInfoMessage.SelText := PasteText[I].PastedPercentage;
            FInfoMessage.Lines.Add('');
          end;

          // Update highlight lines if its new (from transfer)
          if not(PasteText[I].IdentFired) then
          begin
            PasteText[I].VisibleOnNote := LoadIdentLines(FMonitorObject,
              PasteText[I].PastedText, PasteText[I].HiglightLines,
              PasteText[I].Analyzed);
            PasteText[I].IdentFired := true;
          end;
          // check if we are not going to show some lines and add them to the list
          Synamb := TStringList.Create;
          try
            if Length(PasteText[I].GroupItems) > 0 then
            begin
              // loop through the paste text
              for ii := high(PasteText[I].GroupItems)
                downto low(PasteText[I].GroupItems) do
              begin
                if PasteText[I].GroupItems[ii].GroupParent then
                  Continue;
                // If the group is visible
                if PasteText[I].GroupItems[ii].VisibleOnNote then
                begin
                  // loop through highlights
                  for iii := high(PasteText[I].GroupItems[ii].HiglightLines)
                    downto low(PasteText[I].GroupItems[ii].HiglightLines) do
                  begin
                    // if its above the word count
                    if not PasteText[I].GroupItems[ii].HiglightLines[iii].AboveWrdCnt
                    then
                      Synamb.Add(PasteText[I].GroupItems[ii].HiglightLines[iii]
                        .LineToHighlight);
                  end;
                end;
              end;
            end
            else
            begin
              for ii := high(PasteText[I].HiglightLines)
                downto low(PasteText[I].HiglightLines) do
              begin
                if not PasteText[I].HiglightLines[ii].AboveWrdCnt then
                  Synamb.Add(PasteText[I].HiglightLines[ii].LineToHighlight);
              end;
            end;

            if Synamb.Count > 0 then
            begin
              FInfoMessage.SelAttributes.Style := [fsBold];
              FInfoMessage.SelText :=
                'Syntactic ambiguity found (lines not identified): ';
              FInfoMessage.SelAttributes.Style := [];
              for X := 0 to Synamb.Count - 1 do
                FInfoMessage.Lines.Add(Synamb[X]);
              FInfoMessage.Lines.Add('');
            end;

          finally
            Synamb.Free;
          end;

          FirstClear := true;

          DisplayTxt := TStringList.Create;
          try
            if PasteText[I].VisibleOnNote then
            begin
              // if group
              if Length(PasteText[I].GroupItems) > 0 then
              begin
                // loop through the paste text
                for ii := high(PasteText[I].GroupItems)
                  downto low(PasteText[I].GroupItems) do
                begin
                  if PasteText[I].GroupItems[ii].GroupParent then
                    Continue;
                  // If the group is visible
                  if PasteText[I].GroupItems[ii].VisibleOnNote then
                  begin
                    // loop through highlights
                    for iii := high(PasteText[I].GroupItems[ii].HiglightLines)
                      downto low(PasteText[I].GroupItems[ii].HiglightLines) do
                    begin
                      // if its above the word count
                      if PasteText[I].GroupItems[ii].HiglightLines[iii].AboveWrdCnt
                      then
                      begin
                        HighLightInfoPanel(CopyMonitor.HighlightColor,
                          CopyMonitor.MatchStyle, CopyMonitor.MatchHighlight,
                          PasteText[I].GroupItems[ii].HiglightLines[iii]
                          .LineToHighlight, FirstClear);
                        if FirstClear then
                          FirstClear := false;
                      end;
                      DisplayTxt.Add(PasteText[I].GroupItems[ii].HiglightLines
                        [iii].LineToHighlight);
                    end;
                  end;
                end;
              end
              else
              begin
                for ii := high(PasteText[I].HiglightLines)
                  downto low(PasteText[I].HiglightLines) do
                begin
                  if PasteText[I].HiglightLines[ii].AboveWrdCnt then
                  begin
                    HighLightInfoPanel(CopyMonitor.HighlightColor,
                      CopyMonitor.MatchStyle, CopyMonitor.MatchHighlight,
                      PasteText[I].HiglightLines[ii].LineToHighlight,
                      FirstClear);
                    if FirstClear then
                      FirstClear := false;
                  end;
                  DisplayTxt.Add(PasteText[I].HiglightLines[ii].LineToHighlight);
                end;
              end;
            end;

            if not(EditMonitor.FCopyMonitor.LCSToggle) or
              (Length(PasteText[I].GroupItems) = 0) then
            begin

              FInfoMessage.SelAttributes.Style := [fsBold];
              if PasteText[I].VisibleOnNote then
                FInfoMessage.SelText := 'Pasted Text: '
              else
                FInfoMessage.SelText :=
                  'Pasted Text (Unable to identify on document): ';
              FInfoMessage.SelAttributes.Style := [];

              // If this is from the group then load the group parent
              if Length(PasteText[I].GroupItems) > 0 then
              begin
                for ii := high(PasteText[I].GroupItems)
                  downto low(PasteText[I].GroupItems) do
                begin
                  if PasteText[I].GroupItems[ii].GroupParent then
                  begin
                    for X := 0 to PasteText[I].GroupItems[ii]
                      .GroupText.Count - 1 do
                      FInfoMessage.Lines.Add
                        (PasteText[I].GroupItems[ii].GroupText[X]);
                    Break;
                  end;
                end;
              end
              else
              begin
                for X := 0 to PasteText[I].PastedText.Count - 1 do
                  FInfoMessage.Lines.Add(PasteText[I].PastedText[X]);
              end;
            end
            else if (EditMonitor.FCopyMonitor.LCSToggle) and
              (Length(PasteText[I].GroupItems) > 0) then
            begin
              FInfoMessage.SelAttributes.Style := [fsBold];
              if PasteText[I].VisibleOnNote then
                FInfoMessage.SelText := 'Pasted Text: '
              else
                FInfoMessage.SelText :=
                  'Pasted Text (Unable to identify on document): ';
              FInfoMessage.SelAttributes.Style := [];

              // If this is from the group then load the group parent
              if Length(PasteText[I].GroupItems) > 0 then
              begin
                for ii := high(PasteText[I].GroupItems)
                  downto low(PasteText[I].GroupItems) do
                begin
                  if PasteText[I].GroupItems[ii].GroupParent then
                  begin
                    LCSCompareStrings(FInfoMessage,
                      PasteText[I].GroupItems[ii].GroupText, DisplayTxt);
                    Break;
                  end;
                end;
              end
              else
              begin
                for X := 0 to PasteText[I].PastedText.Count - 1 do
                  FInfoMessage.Lines.Add(PasteText[I].PastedText[X]);
              end;
            end;

          finally
            DisplayTxt.Free;
          end;

          if not PasteText[I].VisibleOnNote then
            pnlMessageExit(Self);

          FInfoMessage.SelStart := 0;
          Break;
        end;

      end;
    end;
  end;
end;

procedure TCopyPasteDetails.LCSCompareStrings(DestRich: TRichEdit;
  OrigStr, ModStr: TStringList);
type
  TIntMultiArray = array of array of Integer;

  TDiff = record
    Character: char;
    CharStatus: char;
  end;
var
  LCSAlgAry: TIntMultiArray;
  RtnCursor, Len1, Len2, I: Integer;
  CharDiff, Diff: TDiff;
  FinalList: TList<TDiff>;
  aStr1, aStr2: WideString;
  FlipStringLst: TStringList;

  function FillLCSAlgAry(aValue1, aValue2: string): TIntMultiArray;
  var
    Len1, Len2, I, X: Integer;
  begin
    Len1 := Length(aValue1);
    Len2 := Length(aValue2);

    // We need one extra column and one extra row to be filled with zeroes
    SetLength(Result, Len1 + 1, Len2 + 1);

    // First column filled with zeros
    for I := 0 to Len1 do
      Result[I, 0] := 0;

    // First row filled with zeros
    for X := 0 to Len2 do
      Result[0, X] := 0;

    for I := 1 to Len1 do
    begin
      for X := 1 to Len2 do
      begin
        if aValue1[I] = aValue2[X] then
          Result[I, X] := Result[I - 1, X - 1] + 1
        else
          Result[I, X] := Max(Result[I, X - 1], Result[I - 1, X]);
      end;
    end;
  end;

begin
  RtnCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    SetLength(LCSAlgAry, 0);
    // mod goes in reverse
    FlipStringLst := TStringList.Create;
    try
     for I := ModStr.Count - 1 downto 0 do
      FlipStringLst.Add(ModStr[I]);

     aStr1 := StringReplace(OrigStr.Text, #10, '', [rfReplaceAll]);
     aStr2 := StringReplace(FlipStringLst.Text, #10, '', [rfReplaceAll]);

     Finally
      FlipStringLst.Free;
     end;

    Len1 := Length(aStr1);
    Len2 := Length(aStr2);

    if EditMonitor.FCopyMonitor.LCSToggle and
      ((Len1 <= EditMonitor.FCopyMonitor.LCSCharLimit) and
      (Len2 <= EditMonitor.FCopyMonitor.LCSCharLimit)) then
    begin

      LCSAlgAry := FillLCSAlgAry(aStr1, aStr2);
      FinalList := TList<TDiff>.Create;
      try
        Len1 := Length(aStr1);
        Len2 := Length(aStr2);
        while (Len1 <> 0) or (Len2 <> 0) do
        begin
          if (Len1 > 0) and (Len2 > 0) and (aStr1[Len1] = aStr2[Len2]) then
          begin
            CharDiff.Character := aStr1[Len1];
            CharDiff.CharStatus := '=';
            FinalList.Add(CharDiff);
            Dec(Len1);
            Dec(Len2);
          end
          else if (Len2 > 0) and
            ((Len1 = 0) or (LCSAlgAry[Len1, Len2 - 1] >= LCSAlgAry[Len1 - 1,
            Len2])) then
          begin
            CharDiff.Character := aStr2[Len2];
            CharDiff.CharStatus := '+';
            FinalList.Add(CharDiff);
            Dec(Len2);
          end
          else if (Len1 > 0) and
            ((Len2 = 0) or (LCSAlgAry[Len1, Len2 - 1] < LCSAlgAry[Len1 - 1,
            Len2])) then
          begin
            CharDiff.Character := aStr1[Len1];
            CharDiff.CharStatus := '-';
            FinalList.Add(CharDiff);
            Dec(Len1);
          end;
        end;

        SetLength(LCSAlgAry, 0);

        // build the return
        for I := FinalList.Count - 1 downto 0 do
        begin
          Diff := FinalList.Items[I];
          { if Diff.CharStatus = '+' then
            begin
            DestRich.SelAttributes.Color := clBlue;
            DestRich.SelText := Diff.Character;
            end
            else }
          if Diff.CharStatus = '-' then
          begin
            FInfoMessage.SelAttributes.Style :=
              EditMonitor.FCopyMonitor.LCSTextStyle;
            DestRich.SelAttributes.Color :=
              EditMonitor.FCopyMonitor.LCSTextColor;
            DestRich.SelText := Diff.Character;
          end
          else
          begin
            FInfoMessage.SelAttributes.Style := [];
            DestRich.SelAttributes.Color := clDefault;
            DestRich.SelText := Diff.Character;
          end;
        end;
      finally
        FinalList.Free;
      end;
    end
    else
    begin

      for I := 0 to OrigStr.Count - 1 do
        DestRich.Lines.Add(OrigStr[I]);
    end;
  finally
    Screen.Cursor := RtnCursor;
  end;

end;

procedure TCopyPasteDetails.HighLightInfoPanel(Color: TColor;
  Style: TFontStyles; ShowHighlight: Boolean; PasteText: String;
  ClearPrevHighLight: Boolean = true);
var
  CharPos, CharPos2, endChars, ResetMask: Integer;
  SearchOpts: TSearchTypes;
  Format: CHARFORMAT2;
  SearchString: string;
  isSelectionHidden: Boolean;

  Procedure CenterPasteText(PasteLine: Integer);
  Var
    TopLine, VisibleLines, FirstLine: Integer;
  begin
    FirstLine := TRichEdit(FMonitorObject)
      .Perform(EM_GETFIRSTVISIBLELINE, 0, 0);
    VisibleLines := round(TRichEdit(FMonitorObject).ClientHeight /
      Abs(TRichEdit(FMonitorObject).font.Height));

    if VisibleLines <= 1 then
      TopLine := PasteLine
    else
      TopLine := Max(PasteLine - round((VisibleLines / 2)) + 1, 0);

    if FirstLine <> TopLine then
      TRichEdit(FMonitorObject).Perform(EM_LINESCROLL, 0, TopLine - FirstLine);

  end;

begin
  if not Assigned(EditMonitor.FCopyMonitor) then
    Exit;
  if not EditMonitor.FCopyMonitor.Enabled then
    Exit;
  ResetMask := TRichEdit(FMonitorObject).Perform(EM_GETEVENTMASK, 0, 0);
  TRichEdit(FMonitorObject).Perform(EM_SETEVENTMASK, 0, 0);
  TRichEdit(FMonitorObject).Perform(WM_SETREDRAW, Ord(false), 0);
  try
    // Clear out the variables
    CharPos := 0;
    SearchOpts := [];
    endChars := Length(TRichEdit(FMonitorObject).Text);

    If ClearPrevHighLight then
      pnlMessageExit(Self);
    repeat

      SearchString := StringReplace(Trim(PasteText), #10, '', [rfReplaceAll]);

      // find the text and save the position
      CharPos2 := TRichEdit(FMonitorObject).FindText(SearchString, CharPos,
        endChars, SearchOpts);
      CharPos := CharPos2 + 1;
      if CharPos = 0 then
        Break;
      FPasteCurPos := CharPos2;
      // Select the word
      TRichEdit(FMonitorObject).SelStart := CharPos2;
      TRichEdit(FMonitorObject).SelLength := Length(SearchString);

      // Set the font
      TRichEdit(FMonitorObject).SelAttributes.Style := Style;

      if ShowHighlight then
      begin
        // Set the background color
        FillChar(Format, SizeOf(Format), 0);
        Format.cbSize := SizeOf(Format);
        Format.dwMask := CFM_BACKCOLOR;
        Format.crBackColor := Color;
        TRichEdit(FMonitorObject).Perform(EM_SETCHARFORMAT, SCF_SELECTION,
          Longint(@Format));
        Application.ProcessMessages;
      end;

      isSelectionHidden := TRichEdit(FMonitorObject).HideSelection;
      try
        TRichEdit(FMonitorObject).HideSelection := false;
        TRichEdit(FMonitorObject).SelLength := 1;
        // Scroll to caret
        CenterPasteText(TRichEdit(FMonitorObject).Perform(EM_LINEFROMCHAR,
          TRichEdit(FMonitorObject).SelStart, 0));

      finally
        TRichEdit(FMonitorObject).HideSelection := isSelectionHidden;
      end;
      TRichEdit(FMonitorObject).SelLength := 0;

      if FNewShowing then
        TRichEdit(FMonitorObject).SelStart := TRichEdit(FMonitorObject).SelStart
          + Length(SearchString);

    until CharPos = 0;

  finally
    TRichEdit(FMonitorObject).Perform(WM_SETREDRAW, Ord(true), 0);
    InvalidateRect(TRichEdit(FMonitorObject).Handle, NIL, true);
    TRichEdit(FMonitorObject).Perform(EM_SETEVENTMASK, 0, ResetMask);
  end;
end;

constructor TCopyPasteDetails.Create(AOwner: TComponent);
var
  fLeftPnl{, MainPanel}: TPanel;
begin
  inherited;

  With Self do
  begin
    Caption := '';
    Height := 100;
    BevelInner := bvRaised;
    BorderStyle := bsSingle;
    TabStop := false;
    ShowCaption := false;
    Visible := true;
  end;

  fTopPanel := TPanel.Create(Self);
  With fTopPanel do
  begin
    Name := 'PasteInfoTopPanel';
    Parent := Self;
    ShowCaption := false;
    align := altop;
    BevelOuter := bvNone;
    // AutoSize := true;
    Height := 20;
  end;

  FCollapseBtn := TCollapseBtn.Create(Self);
  with FCollapseBtn do
  begin
    SetSubComponent(true);
    Name := 'PasteInfoCollapseBtn';
    Parent := fTopPanel;
    align := alRight;
    Width := 17;
    Caption := 'Ú';
    font.Name := 'Wingdings';
    TabStop := false;
  end;

  With TLabel.Create(Self) do
  begin
    Name := 'PasteInfoLabel';
    Parent := fTopPanel;
    align := alClient;
    Caption := 'Pasted Data';
    font.Style := [fsBold];
  end;

  Self.Constraints.MinHeight := fTopPanel.Height + 10;

  fLeftPnl := TPanel.Create(Self);
  With fLeftPnl do
  begin
    Name := 'CPLftPnl';
    Parent := Self;
    ShowCaption := false;
    align := alLeft;
    BevelOuter := bvNone;
    Width := 117;
    Height := 20;
  end;

  FInfoSelector := TSelectorBox.Create(Self);
  With FInfoSelector do
  begin
    SetSubComponent(true);
    Name := 'PasteInfo';
    Parent := fLeftPnl;
    // Width := 117;
    align := alClient;
    ItemHeight := 13;
    TabStop := true;
    AlignWithMargins := true;
  end;

  fAnalyzeBtn := TButton.Create(Self);
  with fAnalyzeBtn do
  begin
    SetSubComponent(true);
    Name := 'CPAnalyzeBtn';
    Parent := fLeftPnl;
    Caption := 'Analyze';
    Hint := 'Manualy run the server code that allows for highlighting to appear. Warning this could take some time to process and will cancel the background job already queued for this.';
    align := alBottom;
    TabStop := true;
    AlignWithMargins := true;
    OnClick := AnalyzeClick;
    Visible := false;
    ShowHint := true;
  end;

  FInfoMessage := TRichEdit.Create(Self);
  With FInfoMessage do
  begin
    SetSubComponent(true);
    Name := 'PasteInfoMessage';
    Parent := Self;
    align := alClient;
    AlignWithMargins := true;
    ReadOnly := true;
    ScrollBars := ssBoth;
    TabStop := true;
    WantReturns := false;
    WordWrap := false;
    Text := '<-- Please select the desired paste date';
  end;

  fProgressBar := TProgressBar.Create(Self);
  with fProgressBar do
  begin
    SetSubComponent(true);
    Name := 'CPProgress';
    Parent := Self;
    align := alBottom;
    Visible := false;
  end;

  fEditMonitor := TCopyEditMonitor.Create(Self);
  fEditMonitor.SetSubComponent(true);
  fEditMonitor.VisualMessage := VisualMesageCenter;
  FInfoboxCollapsed := false;
  fEditMonitor.Name := 'EditorMonitor';
  FShowAllPaste := false;
  FNewShowing := false;
  fDefaultSelectAll := false;

end;

destructor TCopyPasteDetails.Destroy;
begin

  if (Assigned(FMonitorObject) and Assigned(fEditMonitor)) then
  begin
    FMonitorObject.WindowProc := FOurOrigWndProc;
    FMonitorObject := nil;
  end;
  inherited;
end;

procedure TCopyPasteDetails.DoExit;
begin
  if Assigned(EditMonitor.FCopyMonitor) then
    if not EditMonitor.FCopyMonitor.Enabled then
      Exit;
  inherited;
  pnlMessageExit(Self);
end;

procedure TCopyPasteDetails.Resize;
begin
  inherited;

  InfoPanelResize(Self);
  if FSyncSizes then
    if Assigned(fEditMonitor.FCopyMonitor) then
      fEditMonitor.FCopyMonitor.SyncSizes(Self);
end;

procedure TCopyPasteDetails.SetObjectToMonitor(ACopyObject: TRichEdit);
begin
  FMonitorObject := nil;

  if Assigned(ACopyObject) then
  begin
    // Point richedit to monitor
    FMonitorObject := ACopyObject;
    FOurOrigWndProc := FMonitorObject.WindowProc;
    FMonitorObject.WindowProc := OurWndProc;
  end;
end;

procedure TCopyPasteDetails.FillPasteArray(SourceData: THashedStringList;
  Var UpdateRec: TPasteText);
type
  fGroupByArray = record
    IEN: Integer;
    MainArrayLocation: Integer;
    UpdateRecord: TPasteText;
  end;
var
  TotalPasted, I, X, NumLines, SubCnt{, StrtSub}: Integer;
  GroupByArray: Array of fGroupByArray;
  PastedString: TStringList;
  PrntNode: string;
  RecToUse: TPasteText;
  RecFound: Boolean;
  function AddToExisitingGroup(ParentIEN, ThisRecIEN: String;
    var StrToSearchFor: TStringList): Boolean;
  var
    I: Integer;
    GrpRecToUse: TPasteText;
  begin
    Result := true;
    RecFound := false;
    for I := Low(GroupByArray) to High(GroupByArray) do
    begin
      if GroupByArray[I].IEN = StrToIntDef(ParentIEN, 0) then
      begin
        // If the parent was found then ignore the group
        // Make sure the orverall is not visible (spaces are now ignored)
        if EditMonitor.PasteText[GroupByArray[I].MainArrayLocation].VisibleOnNote
        then
        begin
          // Set our flag
          Result := false;
          Break;
        end
        else
        begin

          if GroupByArray[I].MainArrayLocation = -3 then
            GrpRecToUse := UpdateRec
          else
          begin
            GrpRecToUse := EditMonitor.PasteText
              [GroupByArray[I].MainArrayLocation];
          end;
          RecFound := true;
          with GrpRecToUse do
          begin
            // First time, we need to add the main text to the GroupText
            if Length(GroupItems) = 0 then
            begin
              SetLength(GroupItems, Length(GroupItems) + 1);
              GroupItems[High(GroupItems)].GroupParent := true;
              GroupItems[High(GroupItems)].GroupText := TStringList.Create;
              GroupItems[High(GroupItems)].GroupText.Assign(PastedText);
              GroupItems[High(GroupItems)].ItemIEN :=
                StrToIntDef(ParentIEN, -1);
              SetLength(GroupItems[High(GroupItems)].HiglightLines, 0);
              GroupItems[High(GroupItems)].VisibleOnNote :=
                EditMonitor.LoadIdentLines(FMonitorObject, PastedText,
                GroupItems[High(GroupItems)].HiglightLines,
                GrpRecToUse.Analyzed);
              PastedText.Clear; // ????
            end;
            // Add this text to the GroupText
            SetLength(GroupItems, Length(GroupItems) + 1);
            GroupItems[High(GroupItems)].GroupParent := false;
            GroupItems[High(GroupItems)].GroupText := TStringList.Create;
            GroupItems[High(GroupItems)].GroupText.Assign(StrToSearchFor);
            GroupItems[High(GroupItems)].ItemIEN := StrToIntDef(ThisRecIEN, -1);
            SetLength(GroupItems[High(GroupItems)].HiglightLines, 0);
            GroupItems[High(GroupItems)].VisibleOnNote :=
              EditMonitor.LoadIdentLines(FMonitorObject, StrToSearchFor,
              GroupItems[High(GroupItems)].HiglightLines, GrpRecToUse.Analyzed);
            // Add this text to the PastedText
            PastedText.Add(Trim(StrToSearchFor.Text));
            // Set our flag
            Result := false;
            Break;

          end;

        end;
      end;
    end;
    if RecFound then
    begin
      if UpdateRec.PasteDBID <> -3 then
        RecToUse := GrpRecToUse
      else
        EditMonitor.PasteText[GroupByArray[I].MainArrayLocation] := GrpRecToUse;
    end;
  end;

begin
  TotalPasted := StrToIntDef(SourceData.Values['(0,0)'], -1);
  If TotalPasted > -1 then
    EditMonitor.CopyMonitor.LogText('LOAD', 'Found ' + IntToStr(TotalPasted) +
      ' existing paste');

  // clear the array by default
  SetLength(GroupByArray, 0);
  PastedString := TStringList.Create;
  try
    for I := 1 to TotalPasted do
    begin
      PrntNode := SourceData.Values['(' + IntToStr(I) + ',0)'];
      NumLines := StrToIntDef(Piece(PrntNode, '^', 8), -1);
      PastedString.BeginUpdate;
      PastedString.Clear;
      for X := 1 to NumLines do
        PastedString.Add(SourceData.Values['(' + IntToStr(I) + ',' +
          IntToStr(X) + ')']);
      PastedString.EndUpdate;

      if AddToExisitingGroup(Piece(PrntNode, '^', 12), Piece(PrntNode, '^', 11),
        PastedString) then
      begin
        EditMonitor.CopyMonitor.LogText('LOAD', 'New Entry Found');

        if UpdateRec.PasteDBID <> -3 then
          RecToUse := UpdateRec
        else
        begin
          SetLength(EditMonitor.PasteText, Length(EditMonitor.PasteText) + 1);
          RecToUse := EditMonitor.PasteText[High(EditMonitor.PasteText)];
        end;

        SetLength(RecToUse.GroupItems, 0);

        // Add this to our group
        SetLength(GroupByArray, Length(GroupByArray) + 1);
        // If there is a parent id but we didnt add from above then we know its parent is missing
        if StrToIntDef(Piece(PrntNode, '^', 12), -1) <> -1 then
          GroupByArray[High(GroupByArray)].IEN :=
            StrToIntDef(Piece(PrntNode, '^', 12), -1)
        else
          GroupByArray[High(GroupByArray)].IEN :=
            StrToIntDef(Piece(PrntNode, '^', 11), -1);

        if UpdateRec.PasteDBID <> -3 then
        begin
          GroupByArray[High(GroupByArray)].MainArrayLocation := -3;
          GroupByArray[High(GroupByArray)].UpdateRecord := UpdateRec;
        end
        else
          GroupByArray[High(GroupByArray)].MainArrayLocation :=
            High(EditMonitor.PasteText);

        with RecToUse do
        begin
          DateTimeOfPaste := Piece(PrntNode, '^', 1);
          UserWhoPasted := Piece(PrntNode, '^', 2);
          CopiedFromLocation := Piece(PrntNode, '^', 3);
          CopiedFromDocument := Piece(PrntNode, '^', 4);
          CopiedFromAuthor := Piece(PrntNode, '^', 5);
          CopiedFromPatient := Piece(PrntNode, '^', 6);
          PastedPercentage := Piece(PrntNode, '^', 7);
          CopiedFromApplication := Piece(PrntNode, '^', 9);
          PasteDBID := StrToIntDef(Piece(PrntNode, '^', 11), -1);
          Analyzed := (Piece(PrntNode, '^', 13) = '1');
          // If its a group then pastedstrings would not be found
          if Length(GroupItems) = 0 then
          begin
            IF Piece(PrntNode, '^', 12) = '+' then
              VisibleOnNote := false
            else
              VisibleOnNote := EditMonitor.LoadIdentLines(FMonitorObject,
                PastedString, RecToUse.HiglightLines, RecToUse.Analyzed);
          end
          else
          begin
            VisibleOnNote := false;
            for X := Low(GroupItems) to High(GroupItems) do
            begin
              if GroupItems[X].GroupParent then
                Continue;
              VisibleOnNote := GroupItems[X].VisibleOnNote;
              if not VisibleOnNote then
                Break;
            end;
          end;
          IdentFired := true;
          VisibleOnList := (FShowAllPaste) or VisibleOnNote or not Analyzed;

          DateTimeOfOriginalDoc := Piece(PrntNode, '^', 10);
          PastedText := TStringList.Create;
          PastedText.BeginUpdate;
          PastedText.Assign(PastedString);
          PastedText.EndUpdate;

          // check for original copy
          SubCnt := StrToIntDef(SourceData.Values['(' + IntToStr(I) +
            ',0,0)'], 0);
          if SubCnt > 0 then
          begin
            OriginalText := TStringList.Create;
            OriginalText.BeginUpdate;
            for X := 1 to SubCnt do
              // OriginalText.Add(Piece(CopiedText.Strings[X], '=', 2));
              OriginalText.Add(SourceData.Values['(' + IntToStr(I) + ',0,' +
                IntToStr(X) + ')']);
            OriginalText.EndUpdate;
          end;

        end;

        EditMonitor.CopyMonitor.LogText('LOAD', 'Text found in note [' +
          PrntNode + ']');

        if UpdateRec.PasteDBID <> -3 then
        begin
          UpdateRec := RecToUse;
          if Length(UpdateRec.GroupItems) > 0 then
            // Setup the main record
            UpdateRec.VisibleOnNote := false;
          for X := Low(UpdateRec.GroupItems) to High(UpdateRec.GroupItems) do
          begin
            if UpdateRec.GroupItems[X].GroupParent then
              Continue;
            UpdateRec.VisibleOnNote := UpdateRec.GroupItems[X].VisibleOnNote;
            if not UpdateRec.VisibleOnNote then
              Break;
          end;
          UpdateRec.VisibleOnList := (FShowAllPaste) or UpdateRec.VisibleOnNote;
        end
        else
          EditMonitor.PasteText[High(EditMonitor.PasteText)] := RecToUse;
      end
      else
      begin
        // Need to update our record if it was grouped
        if UpdateRec.PasteDBID <> -3 then
        begin
          UpdateRec := RecToUse;
          if Length(UpdateRec.GroupItems) > 0 then
            // Setup the main record
            UpdateRec.VisibleOnNote := false;
          for X := Low(UpdateRec.GroupItems) to High(UpdateRec.GroupItems) do
          begin
            if UpdateRec.GroupItems[X].GroupParent then
              Continue;
            UpdateRec.VisibleOnNote := UpdateRec.GroupItems[X].VisibleOnNote;
            if not UpdateRec.VisibleOnNote then
              Break;
          end;
          UpdateRec.VisibleOnList := (FShowAllPaste) or UpdateRec.VisibleOnNote;
        end;
      end;
    end;
  finally
    PastedString.Free;
  end;

  SetLength(GroupByArray, 0);
end;

procedure TCopyPasteDetails.LoadPasteText();

var
  CopiedText: THashedStringList;
  ProcessLoad, AnyItemsVisible, NeedAnalyzed, BlwWrdCnt: Boolean;
  ClonedRichEdit: TRichEdit;
  I, X, Z: Integer;
  Dummy: TPasteText;

  function UpdatePasteText(PasteText: TStringList): TStrings;
  begin
    ClonedRichEdit.Text := PasteText.Text;
    Result := ClonedRichEdit.Lines;
  end;

  procedure CopyRicheditProperties(Dest, Source: TRichEdit);
  var
    ms: TMemoryStream;
    OldName: string;
    Rect: TRect;
  begin
    OldName := Source.Name;
    Source.Name := ''; // needed to avoid Name collision
    try
      ms := TMemoryStream.Create;
      try
        ms.WriteComponent(Source);
        ms.Position := 0;
        ms.ReadComponent(Dest);
      finally
        ms.Free;
      end;
    finally
      Source.Name := OldName;
    end;
    Dest.Visible := false;
    Dest.Parent := Source.Parent;

    Source.Perform(EM_GETRECT, 0, Longint(@Rect));
    Dest.Perform(EM_SETRECT, 0, Longint(@Rect));
  end;

  procedure LoadPreviousNewPaste();
  var
    I: Integer;
  begin

    for I := Low(EditMonitor.CopyMonitor.FCPRSClipBoard)
      to High(EditMonitor.CopyMonitor.FCPRSClipBoard) do
    begin
      if (EditMonitor.CopyMonitor.FCPRSClipBoard[I].SaveForDocument) and
        (EditMonitor.CopyMonitor.FCPRSClipBoard[I].PasteToIEN = EditMonitor.
        ItemIEN) then
      begin
        SetLength(EditMonitor.PasteText, Length(EditMonitor.PasteText) + 1);
        with EditMonitor.PasteText[High(EditMonitor.PasteText)] do
        begin
          DateTimeOfPaste := FloatToStr(DateTimeToFMDateTime(Now));
          New := true;
          PastedText := TStringList.Create;
          PastedText.Assign(EditMonitor.CopyMonitor.FCPRSClipBoard[I]
            .CopiedText);
          VisibleOnNote := EditMonitor.LoadIdentLines(FMonitorObject,
            PastedText, HiglightLines, false);
          VisibleOnList := (FShowAllPaste) or VisibleOnNote;
        end;
      end;
    end;

  end;

begin
  if not Assigned(EditMonitor.FCopyMonitor) then
    Exit;
  if not EditMonitor.FCopyMonitor.Enabled then
    Exit;
  EditMonitor.ClearPasteArray;

  EditMonitor.CopyMonitor.LoadTheProperties;

  if not EditMonitor.CopyMonitor.DisplayPaste then
  begin
    if Assigned(EditMonitor.VisualMessage) then
      EditMonitor.VisualMessage(Self, Hide_Panel, [true]);
    Exit;
  end;

  // Only display this information on a richedit
  If (FMonitorObject is TRichEdit) then
  begin
    CopiedText := THashedStringList.Create();
    try
      ProcessLoad := true;

      if Assigned(EditMonitor.LoadPastedText) then
      begin
        EditMonitor.StartStopWatch;
        try
          EditMonitor.LoadPastedText(Self, CopiedText, ProcessLoad);
        finally
          If EditMonitor.StopStopWatch then
            EditMonitor.FCopyMonitor.LogText('METRIC',
              'Load Paste RPC: ' + EditMonitor.FCopyMonitor.fStopWatch.Elapsed);
        end;
      end;

      AnyItemsVisible := false;
      if ProcessLoad then
      begin

        if CopiedText.Count > 0 then
        begin

          EditMonitor.StartStopWatch;
          TRY
            // Call out to fill the Paste array

            // This is just used to pass into the function. -3 is invlaid and tells the funtion to create the array
            Dummy.PasteDBID := -3;

            FillPasteArray(CopiedText, Dummy);
            {
              TotalPasted := StrToIntDef(CopiedText.Values['(0,0)'], -1);
              If TotalPasted > -1 then
              EditMonitor.CopyMonitor.LogText('LOAD',
              'Found ' + IntToStr(TotalPasted) + ' existing paste');

              // clear the array by default
              SetLength(GroupByArray, 0);
              PastedString := TStringList.Create;
              try
              for I := 1 to TotalPasted do
              begin


              PrntNode := CopiedText.Values['(' + IntToStr(I) + ',0)'];
              NumLines := StrToIntDef(Piece(PrntNode, '^', 8), -1);
              //  StrtSub := CopiedText.IndexOfName('(' + IntToStr(I) + ',1)');

              PastedString.BeginUpdate;
              PastedString.Clear;
              for X := 1 to NumLines do
              PastedString.Add(CopiedText.Values['(' + IntToStr(I) + ',' + IntToStr(X) + ')']);

              PastedString.EndUpdate;

              // if (FShowAllPaste) then

              if AddToExisitingGroup(Piece(PrntNode, '^', 12),
              Piece(PrntNode, '^', 11), PastedString) then
              begin
              EditMonitor.CopyMonitor.LogText('LOAD', 'New Entry Found');
              SetLength(EditMonitor.PasteText,
              Length(EditMonitor.PasteText) + 1);
              With EditMonitor.PasteText[High(EditMonitor.PasteText)] do
              SetLength(GroupItems, 0);
              // Add this to our group
              SetLength(GroupByArray, Length(GroupByArray) + 1);
              // If there is a parent id but we didnt add from above then we know its parent is missing
              if StrToIntDef(Piece(PrntNode, '^', 12), -1) <> -1 then
              GroupByArray[High(GroupByArray)].IEN :=
              StrToIntDef(Piece(PrntNode, '^', 12), -1)
              else
              GroupByArray[High(GroupByArray)].IEN :=
              StrToIntDef(Piece(PrntNode, '^', 11), -1);
              GroupByArray[High(GroupByArray)].MainArrayLocation :=
              High(EditMonitor.PasteText);

              with EditMonitor.PasteText[High(EditMonitor.PasteText)] do
              begin
              DateTimeOfPaste := Piece(PrntNode, '^', 1);
              UserWhoPasted := Piece(PrntNode, '^', 2);
              CopiedFromLocation := Piece(PrntNode, '^', 3);
              CopiedFromDocument := Piece(PrntNode, '^', 4);
              CopiedFromAuthor := Piece(PrntNode, '^', 5);
              CopiedFromPatient := Piece(PrntNode, '^', 6);
              PastedPercentage := Piece(PrntNode, '^', 7);
              CopiedFromApplication := Piece(PrntNode, '^', 9);
              PasteDBID := StrToIntDef(Piece(PrntNode, '^', 11), -1);
              Analyzed := (Piece(PrntNode, '^', 13) = '1');
              // If its a group then pastedstrings would not be found
              if Length(GroupItems) = 0 then
              VisibleOnNote := EditMonitor.LoadIdentLines
              (FMonitorObject, PastedString,
              EditMonitor.PasteText[High(EditMonitor.PasteText)
              ].HiglightLines)
              else
              begin
              VisibleOnNote := false;
              for X := Low(GroupItems) to High(GroupItems) do
              begin
              if GroupItems[X].GroupParent then
              Continue;
              VisibleOnNote := GroupItems[X].VisibleOnNote;
              if not VisibleOnNote then
              Break;
              end;
              end;
              IdentFired := true;
              VisibleOnList := (FShowAllPaste) or VisibleOnNote;

              DateTimeOfOriginalDoc := Piece(PrntNode, '^', 10);
              PastedText := TStringList.Create;
              PastedText.BeginUpdate;
              PastedText.Assign(PastedString);
              PastedText.EndUpdate;

              // check for original copy
              SubCnt := StrToIntDef
              (CopiedText.Values['(' + IntToStr(I) + ',0,0)'], 0);
              // StrtSub := CopiedText.IndexOfName('(' + IntToStr(I) + ',0,1)');
              if SubCnt > 0 then
              begin
              OriginalText := TStringList.Create;
              OriginalText.BeginUpdate;
              for X := 1 to SubCnt do
              //  OriginalText.Add(Piece(CopiedText.Strings[X], '=', 2));
              OriginalText.Add(CopiedText.Values['(' + IntToStr(I) + ',0,' + IntToStr(X) + ')']);
              OriginalText.EndUpdate;
              end;

              end;

              EditMonitor.CopyMonitor.LogText('LOAD',
              'Text found in note [' + PrntNode + ']');
              end;

              if Assigned(ClonedRichEdit) then
              FreeAndNil(ClonedRichEdit);

              end;
              finally
              PastedString.Free;
              end;

              SetLength(GroupByArray, 0);
            }

            // load the paste that have not saved. this clears when a new document is created or saved
            if Length(EditMonitor.PasteText) > 0 then
            begin
              LoadPreviousNewPaste;

              EditMonitor.FCopyMonitor.LogText('DEBUG', EditMonitor.PasteText);

            end;
            // Final update for isvisible
            NeedAnalyzed := false;
            for I := Low(EditMonitor.PasteText)
              to High(EditMonitor.PasteText) do
            begin
              BlwWrdCnt := false;
              with EditMonitor.PasteText[I] do
              begin
                if Length(GroupItems) > 0 then
                begin
                  // Setup the main record
                  VisibleOnNote := false;
                  for X := Low(GroupItems) to High(GroupItems) do
                  begin
                    if GroupItems[X].GroupParent then
                      Continue;
                    VisibleOnNote := GroupItems[X].VisibleOnNote;

                    if VisibleOnNote then
                    begin
                      // Look to see if the whole text was found
                      for Z := Low(HiglightLines) to High(HiglightLines) do
                      begin
                        BlwWrdCnt := not HiglightLines[Z].AboveWrdCnt;
                        if BlwWrdCnt then
                          Break;
                      end;
                    end;

                    if (not VisibleOnNote) or BlwWrdCnt then
                      Break;

                  end;
                end
                else
                begin
                  // Look to see if the whole text was found
                  for X := Low(HiglightLines) to High(HiglightLines) do
                  begin
                    BlwWrdCnt := not HiglightLines[X].AboveWrdCnt;
                    if BlwWrdCnt then
                      Break;
                  end;
                end;

                // check if this should be analyzed. If we can find the WHOLE item
                if VisibleOnNote and (not Analyzed) and (not BlwWrdCnt) then
                  Analyzed := true
                else if not Analyzed then
                  NeedAnalyzed := true;

                VisibleOnList := (FShowAllPaste) or VisibleOnNote or
                  (not Analyzed);

                if not AnyItemsVisible then
                  AnyItemsVisible := VisibleOnList;
              end;
            end;

            if AnyItemsVisible then
            begin
              If ScreenReaderSystemActive then
                GetScreenReader.Speak('Pasted data exist');
            end;

            fAnalyzeBtn.Visible := NeedAnalyzed;
            Self.Repaint;

          finally
            If EditMonitor.StopStopWatch then
              EditMonitor.FCopyMonitor.LogText('METRIC',
                'Build Paste Internal: ' +
                EditMonitor.FCopyMonitor.fStopWatch.Elapsed);
          end;
        end;

      end;
      if Assigned(EditMonitor.VisualMessage) then
      begin
        if fDefaultSelectAll then
          EditMonitor.VisualMessage(Self, ShowHighlight,
            [AnyItemsVisible, true])
        else
          EditMonitor.VisualMessage(Self, Show_Panel, [AnyItemsVisible]);
      end;
    finally
      CopiedText.Free;
    end;
  end;
end;

procedure TCopyPasteDetails.OurWndProc(var Message: TMessage);
var
  ShiftState: TShiftState;
  FireMessage: Boolean;

  procedure HideCurrentHighlight();
  begin
    if FNewShowing then
    begin
      pnlMessageExit(Self);
      FNewShowing := false;
    end;
  end;

  Procedure PerformPaste(EditMonitorObj: TCopyEditMonitor;
    TheEdit: TCustomEdit);
  var
    ClpInfo: tClipInfo;
  begin
    HideCurrentHighlight;
    if Clipboard.HasFormat(CF_TEXT) then
    begin
      ClpInfo := EditMonitor.CopyMonitor.GetClipSource;
      EditMonitorObj.PasteToMonitor(TheEdit, true, ClpInfo);
    end;
  end;

  Procedure PerformCopyCut(EditMonitorObj: TCopyEditMonitor;
    TheEdit: TCustomEdit; CMsg: Cardinal);
  begin
    HideCurrentHighlight;
    EditMonitorObj.CopyToMonitor(TheEdit, true, CMsg);
  end;

begin
  FireMessage := true;
  if Assigned(EditMonitor.FCopyMonitor) then
  begin
    if EditMonitor.FCopyMonitor.Enabled then
    begin
      case Message.Msg of
        WM_PASTE:
          begin
            PerformPaste(EditMonitor, FMonitorObject);
            FireMessage := false;
          end;
        WM_COPY:
          begin
            PerformCopyCut(EditMonitor, FMonitorObject, Message.Msg);
            FireMessage := false;
          end;
        WM_CUT:
          begin
            PerformCopyCut(EditMonitor, FMonitorObject, Message.Msg);
            FireMessage := false;
          end;
        WM_KEYDOWN:
          begin
            ShiftState := KeyDataToShiftState(Message.WParam);
            if (ssCtrl in ShiftState) then
            begin
              if (Message.WParam = Ord('V')) then
              begin
                PerformPaste(EditMonitor, FMonitorObject);
                FireMessage := false;
              end
              else if (Message.WParam = Ord('C')) then
              begin
                PerformCopyCut(EditMonitor, FMonitorObject, Message.Msg);
                FireMessage := false;
              end
              else if (Message.WParam = Ord('X')) then
              begin
                PerformCopyCut(EditMonitor, FMonitorObject, Message.Msg);
                FireMessage := false;
              end
              else if (Message.WParam = VK_INSERT) then
              begin
                PerformPaste(EditMonitor, FMonitorObject);
                FireMessage := false;
              end;
            end
            else if (ssShift in ShiftState) then
            begin
              if (Message.WParam = VK_INSERT) then
              begin
                PerformPaste(EditMonitor, FMonitorObject);
                FireMessage := false;
              end;
            end;
            HideCurrentHighlight;
          end;
      end;
    end;
  end;
  if FireMessage then
    FOurOrigWndProc(Message);
end;

procedure TCopyPasteDetails.SaveTheMonitor(ItemID: Integer);
begin
  if not Assigned(EditMonitor.FCopyMonitor) then
    Exit;
  if not EditMonitor.FCopyMonitor.Enabled then
    Exit;
  fEditMonitor.SaveTheMonitor(Self, ItemID);
end;

procedure TCopyPasteDetails.CheckForModifiedPaste(var SaveList: TStringList);
var
  I, SaveCnt: Integer;

  procedure FormatResult(InfoRecord: TPasteText; DBID: Integer;
    PasteText: TStringList);
  begin
    Inc(SaveCnt);

    SaveList.Add(IntToStr(SaveCnt) + ',0=' +
      IntToStr(EditMonitor.FCopyMonitor.UserDuz) + '^' +
      InfoRecord.DateTimeOfPaste + '^' + IntToStr(EditMonitor.ItemIEN) + ';' +
      EditMonitor.RelatedPackage + '^' + Piece(InfoRecord.CopiedFromLocation,
      ';', 1) + ';' + Piece(InfoRecord.CopiedFromLocation, ';', 2) + '^' +
      InfoRecord.PastedPercentage + '^' +
      EditMonitor.FCopyMonitor.MonitoringPackage + '^' +
      InfoRecord.CopiedFromApplication + '^' + IntToStr(DBID));

    // Line Count (w/out OUR line breaks for size - code below)

    BreakUpLongLines(SaveList, IntToStr(SaveCnt), PasteText,
      EditMonitor.FCopyMonitor.FBreakUpLimit);

    // Send in  the original text if needed
    If Assigned(InfoRecord.OriginalText) then
    begin
      SaveList.Add(IntToStr(SaveCnt) + ',0,-1=' +
        IntToStr(InfoRecord.OriginalText.Count));
      BreakUpLongLines(SaveList, IntToStr(SaveCnt) + ',0',
        InfoRecord.OriginalText, EditMonitor.FCopyMonitor.FBreakUpLimit);
    end;

  end;

  function IsTextVisible(HigRec: Array of tHighlightRecord): Boolean;
  var
    I, LastSrchPos: Integer;
    AllFound: Boolean;
  begin
    AllFound := true;
    // Check for highlight records
    LastSrchPos := 0;
    for I := Low(HigRec) to High(HigRec) do
    begin
      if EditMonitor.CopyMonitor.WordCount(HigRec[I].LineToHighlight) > 2 then
      begin
        LastSrchPos := TRichEdit(FMonitorObject)
          .FindText(HigRec[I].LineToHighlight, LastSrchPos,
          Length(TRichEdit(FMonitorObject).Text), []);

        if LastSrchPos = -1 then
        begin
          // If one line greater than 2 words doesnt match the whole thing doesnt
          AllFound := false;
          Break;
        end
        else
          AllFound := true;
      end;
    end;
    Result := AllFound;

  end;

begin
  if not Assigned(EditMonitor.FCopyMonitor) then
    Exit;
  if not EditMonitor.FCopyMonitor.Enabled then
    Exit;
  // now check for modified text
  EditMonitor.StartStopWatch;
  try
    SaveCnt := StrToIntDef(SaveList.Values['TotalToSave'], -1);

    //Send back all paste because we can not determine the orignal text modifications. Edit of an edit to text that was left off
    for I := Low(fEditMonitor.PasteText) to High(fEditMonitor.PasteText) do
    begin
     // saftey net
      if fEditMonitor.PasteText[I].PasteDBID = -1 then
        Continue;

      // check the main record (could not have groups)
          FormatResult(fEditMonitor.PasteText[I],
            fEditMonitor.PasteText[I].PasteDBID,
            fEditMonitor.PasteText[I].PastedText);
    end;

    {
    for I := Low(fEditMonitor.PasteText) to High(fEditMonitor.PasteText) do
    begin

      // saftey net
      if fEditMonitor.PasteText[I].PasteDBID = -1 then
        Continue;

      with fEditMonitor.PasteText[I] do
      begin

        // If group item then check each group else check main entry
        for X := Low(GroupItems) to High(GroupItems) do
        begin
          if GroupItems[X].GroupParent then
            Continue;
          // Check if the goup item still exist on the note (if it did at load)
          if GroupItems[X].VisibleOnNote then
          begin
            if not IsTextVisible(GroupItems[X].HiglightLines) then
              FormatResult(fEditMonitor.PasteText[I], GroupItems[X].ItemIEN,
                GroupItems[X].GroupText);
          end;
        end;
      end;
      // check the main record (could not have groups)
      if fEditMonitor.PasteText[I].VisibleOnNote then
        if not IsTextVisible(fEditMonitor.PasteText[I].HiglightLines) then
          FormatResult(fEditMonitor.PasteText[I],
            fEditMonitor.PasteText[I].PasteDBID,
            fEditMonitor.PasteText[I].PastedText);

    end;
    }
    SaveList.Values['TotalToSave'] := IntToStr(SaveCnt);

    EditMonitor.FCopyMonitor.LogText('SAVE', 'Edited Records ' +
      IntToStr(SaveCnt) + ' Items');
  finally
    If EditMonitor.StopStopWatch then
      EditMonitor.FCopyMonitor.LogText('METRIC', 'Check modified build: ' +
        EditMonitor.FCopyMonitor.fStopWatch.Elapsed);
  end;
end;

procedure TCopyPasteDetails.AnalyzeClick(Sender: TObject);
const
  WarnMsg = 'Warning this process may take some time to run. You will be analyzing %s record(s). By clicking ''OK'' you will have to wait for these record to process.';
var
  WrnMsg, IEN2Use, Package2Use: String;
  LoopTotal, I: Integer;
  SndLst, RtnLst: TStringList;
  RtnHash: THashedStringList;
begin
  if not Assigned(EditMonitor.FCopyMonitor) then
    Exit;
  if not EditMonitor.FCopyMonitor.Enabled then
    Exit;
  if not Assigned(FOnAnalyze) then
    Exit;

  LoopTotal := 0;
  for I := Low(EditMonitor.PasteText) to High(EditMonitor.PasteText) do
    if not EditMonitor.PasteText[I].Analyzed then
      Inc(LoopTotal);

  if LoopTotal > 0 then
  begin
    WrnMsg := Format(WarnMsg, [IntToStr(LoopTotal)]);
    if MessageDlg(WrnMsg, mtWarning, [mbOK, mbCancel], -1) = mrOk then
    begin
      Screen.Cursor := crHourGlass;
      try
        // Loop through each item and process the info
        SndLst := TStringList.Create;
        try
          RtnLst := TStringList.Create;
          try

            fProgressBar.Position := 0;
            fProgressBar.Max := LoopTotal + 1;
            fProgressBar.Visible := true;
            Self.Repaint;
            for I := Low(EditMonitor.PasteText)
              to High(EditMonitor.PasteText) do
            begin
              if not EditMonitor.PasteText[I].Analyzed then
              begin
                // process this record
                // Call RPC
                SndLst.Clear;

                IEN2Use :=
                  Piece(EditMonitor.PasteText[I].CopiedFromLocation, ';', 1);
                Package2Use :=
                  Piece(EditMonitor.PasteText[I].CopiedFromLocation, ';', 2);

                SndLst.Add('1,0=' + IntToStr(EditMonitor.FCopyMonitor.UserDuz) +
                  '^' + EditMonitor.PasteText[I].DateTimeOfPaste + '^' +
                  IntToStr(EditMonitor.ItemIEN) + ';' +
                  EditMonitor.RelatedPackage + '^' + IEN2Use + ';' + Package2Use
                  + '^' + EditMonitor.PasteText[I].PastedPercentage + '^' +
                  EditMonitor.FCopyMonitor.MonitoringPackage + '^' +
                  EditMonitor.PasteText[I].CopiedFromApplication + '^' +
                  IntToStr(EditMonitor.PasteText[I].PasteDBID));

                // Line Count (w/out OUR line breaks for size - code below)
                BreakUpLongLines(SndLst, '1',
                  EditMonitor.PasteText[I].PastedText,
                  EditMonitor.FCopyMonitor.FBreakUpLimit);

                FOnAnalyze(Self, SndLst, RtnLst);

                // Update the record and run the ident code
                if RtnLst.Count > 1 then
                begin
                  if RtnLst.Strings[0] <> '-1' then
                  begin
                    RtnHash := THashedStringList.Create;
                    try
                      RtnHash.Assign(RtnLst);
                      FillPasteArray(RtnHash, EditMonitor.PasteText[I]);
                    finally
                      RtnHash.Free;
                    end;
                  end;
                end;

                // Update the progress bar
                fProgressBar.Position := fProgressBar.Position + 1;

              end;
            end;
            fProgressBar.Visible := false;
            fProgressBar.Position := 0;
            fAnalyzeBtn.Visible := false;
            lbSelectorClick(FInfoSelector);
          finally
            RtnLst.Free;
          end;
        finally
          SndLst.Free;
        end;
      finally
        Screen.Cursor := crDefault;
      end;

    end;
  end;
end;

{$ENDREGION}
{$REGION 'TCollapseBtn'}

procedure TCollapseBtn.Click;
begin
  inherited;
  TCopyPasteDetails(Self.owner).CloseInfoPanel(Self);
  // Do not put any code past this line (event is triggered above)
end;

{$ENDREGION}
{$REGION 'TSelectorBox'}

constructor TSelectorBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Self.Style := lbOwnerDrawFixed;
  OnDrawItem := OurDrawItem;
end;

procedure TSelectorBox.Click;
begin
  inherited;
  TCopyPasteDetails(Self.owner).lbSelectorClick(Self);
end;

procedure TSelectorBox.WMSetFocus(var Message: TWMSetFocus);
begin
  SelectorColor := clHighlight;
  inherited;
end;

procedure TSelectorBox.WMKilFocus(var Message: TWMKillFocus);
begin
  SelectorColor := clLtGray;
  inherited;
end;

procedure TSelectorBox.OurDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  with Self.Canvas do
  begin
    if odSelected in State then
      Brush.Color := Self.SelectorColor;

    FillRect(Rect);
    TextOut(Rect.Left, Rect.Top, Self.Items[Index]);
    if odFocused In State then
    begin
      Brush.Color := Self.Color;
      DrawFocusRect(Rect);
    end;
  end;
end;

{$ENDREGION}
{$REGION 'TTrackOnlyItem'}

procedure TTrackOnlyItem.Assign(Source: TPersistent);

begin
  if Source is TTrackOnlyItem then
    TrackObject := TTrackOnlyItem(Source).TrackObject
  else
    inherited; // raises an exception
end;

function TTrackOnlyItem.GetDisplayName: String;
begin
  if Assigned(FObject) then
    Result := FObject.Name
  else
    Result := Format('Track Edit %d', [Index]);
end;

procedure TTrackOnlyItem.SetTrackObject(const Value: TCustomEdit);
// var
// CollOwner: TComponent;
begin
  FObject := Value;
  // CollOwner := TTrackOnlyCollection(Collection).FOwner;
  FOurOrigWndProc := FObject.WindowProc;
  FObject.WindowProc := OurWndProc;
end;

procedure TTrackOnlyItem.OurWndProc(var Message: TMessage);
var
  ShiftState: TShiftState;
  FireMessage: Boolean;

  Procedure PerformPaste(EditMonitorObj: TCopyEditMonitor;
    TheEdit: TCustomEdit);
  var
    ClpInfo: tClipInfo;
  begin
    if Clipboard.HasFormat(CF_TEXT) then
    begin
      ClpInfo := EditMonitorObj.CopyMonitor.GetClipSource;
      EditMonitorObj.PasteToMonitor(TheEdit, true, ClpInfo);
    end;
  end;

  Procedure PerformCopyCut(EditMonitorObj: TCopyEditMonitor;
    TheEdit: TCustomEdit; CMsg: Cardinal);
  begin
    EditMonitorObj.CopyToMonitor(TheEdit, true, CMsg);
  end;

begin
  FireMessage := true;
  if Assigned(TTrackOnlyCollection(Collection).FOwner) then
  begin
    if Assigned(TCopyEditMonitor(TTrackOnlyCollection(Collection).FOwner)
      .FCopyMonitor) then
    begin
      if TCopyEditMonitor(TTrackOnlyCollection(Collection).FOwner).FCopyMonitor.Enabled
      then
      begin
        case Message.Msg of
          WM_PASTE:
            PerformPaste(TCopyEditMonitor(TTrackOnlyCollection(Collection)
              .FOwner), FObject);
          WM_COPY:
            begin
              PerformCopyCut(TCopyEditMonitor(TTrackOnlyCollection(Collection)
                .FOwner), FObject, Message.Msg);
              FireMessage := false;
            end;
          WM_CUT:
            begin
              PerformCopyCut(TCopyEditMonitor(TTrackOnlyCollection(Collection)
                .FOwner), FObject, Message.Msg);
              FireMessage := false;
            end;
          WM_KEYDOWN:
            begin
              ShiftState := KeyDataToShiftState(Message.WParam);
              if (ssCtrl in ShiftState) then
              begin
                if (Message.WParam = Ord('V')) then
                begin
                  PerformPaste(TCopyEditMonitor(TTrackOnlyCollection(Collection)
                    .FOwner), FObject);
                  FireMessage := false;
                end
                else if (Message.WParam = Ord('C')) then
                begin
                  PerformCopyCut
                    (TCopyEditMonitor(TTrackOnlyCollection(Collection).FOwner),
                    FObject, Message.Msg);
                  FireMessage := false;
                end
                else if (Message.WParam = Ord('X')) then
                begin
                  PerformCopyCut
                    (TCopyEditMonitor(TTrackOnlyCollection(Collection).FOwner),
                    FObject, Message.Msg);
                  FireMessage := false;
                end
                else if (Message.WParam = VK_INSERT) then
                begin
                  PerformPaste(TCopyEditMonitor(TTrackOnlyCollection(Collection)
                    .FOwner), FObject);
                  FireMessage := false;
                end;
              end
              else if (ssShift in ShiftState) then
              begin
                if (Message.WParam = VK_INSERT) then
                begin
                  PerformPaste(TCopyEditMonitor(TTrackOnlyCollection(Collection)
                    .FOwner), FObject);
                  FireMessage := false;
                end;
              end;
            end;
        end;
      end;
    end;
  end;

  if FireMessage then
    FOurOrigWndProc(Message);
end;

{$ENDREGION}
{$REGION 'TTrackOnlyCollection'}

function TTrackOnlyCollection.Add: TTrackOnlyItem;
begin
  Result := TTrackOnlyItem(inherited Add);
  SetObjectToMonitor(Result);
end;

constructor TTrackOnlyCollection.Create(AOwner: TComponent);
begin
  inherited Create(TTrackOnlyItem);
  FOwner := AOwner;
end;

function TTrackOnlyCollection.GetItem(Index: Integer): TTrackOnlyItem;
begin
  Result := TTrackOnlyItem(inherited GetItem(Index));
end;

function TTrackOnlyCollection.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TTrackOnlyCollection.Insert(Index: Integer): TTrackOnlyItem;
begin
  Result := TTrackOnlyItem(inherited Insert(Index));
  SetObjectToMonitor(Result);
end;

procedure TTrackOnlyCollection.SetItem(Index: Integer; Value: TTrackOnlyItem);
begin
  inherited SetItem(Index, Value);
  SetObjectToMonitor(Value);
end;

procedure TTrackOnlyCollection.Update(Item: TCollectionItem);
begin
  inherited Update(Item);
end;

procedure TTrackOnlyCollection.SetObjectToMonitor(TrackItem: TTrackOnlyItem);
begin

end;

{$ENDREGION}
{$REGION 'TStopWatch'}

constructor TStopWatch.Create(AOwner: TComponent;
  const IsActive: Boolean = false; const startOnCreate: Boolean = false);
begin
  inherited Create();
  FOwner := AOwner;
  fIsRunning := false;
  fActive := IsActive;
  fIsHighResolution := QueryPerformanceFrequency(fFrequency);
  if NOT fIsHighResolution then
    fFrequency := MSecsPerSec;

  if startOnCreate then
    Start;
end;

destructor TStopWatch.Destroy;
begin
  Stop;
  inherited Destroy;
end;

function TStopWatch.GetElapsedTicks: TLargeInteger;
begin
  Result := fStopCount - fStartCount;
end;

procedure TStopWatch.SetTickStamp(var lInt: TLargeInteger);
begin
  if fIsHighResolution then
    QueryPerformanceCounter(lInt)
  else
    lInt := MilliSecondOf(Now);
end;

function TStopWatch.GetElapsed: string;
begin
  Result := FloatToStr(ElapsedMilliseconds / 1000) + ' Sec / ' +
    FloatToStr(ElapsedMilliseconds) + ' Ms / ' +
    FloatToStr(ElapsedNanoSeconds) + ' Ns';
end;

function TStopWatch.GetElapsedMilliseconds: TLargeInteger;
begin
  Result := (MSecsPerSec * (fStopCount - fStartCount)) div fFrequency;
end;

function TStopWatch.GetElapsedNanoSeconds: TLargeInteger;
begin
  Result := (NSecsPerSec * (fStopCount - fStartCount)) div fFrequency;
end;

procedure TStopWatch.Start;
begin
  if fActive then
  begin
    SetTickStamp(fStartCount);
    fIsRunning := true;
  end;
end;

procedure TStopWatch.Stop;
begin
  if fActive then
  begin
    SetTickStamp(fStopCount);
    fIsRunning := false;
  end;
end;
{$ENDREGION}
{$REGION 'TLogComponent'}

constructor TLogComponent.Create(AOwner: TComponent);
begin
  inherited Create();
  FOwner := AOwner;
  FCriticalSection := TCriticalSection.Create;
end;

destructor TLogComponent.Destroy;
begin
  FCriticalSection.Free;
  inherited Destroy;
end;

function TLogComponent.Dump(Instance: TPasteArray): string;
var
  I: Integer;

  function DumpRecordPasteRec(RecToUse: TPasteText): String;
  var
    X, Y: Integer;
  begin
    Result := '[RecToUse.CopiedFromApplication]: ' +
      RecToUse.CopiedFromApplication;
    Result := Result + #13#10 + '[RecToUse.CopiedFromAuthor]: ' +
      RecToUse.CopiedFromAuthor;
    Result := Result + #13#10 + '[RecToUse.CopiedFromDocument]: ' +
      RecToUse.CopiedFromDocument;
    Result := Result + #13#10 + '[RecToUse.CopiedFromLocation]: ' +
      RecToUse.CopiedFromLocation;
    Result := Result + #13#10 + '[RecToUse.CopiedFromPatient]: ' +
      RecToUse.CopiedFromPatient;
    Result := Result + #13#10 + '[RecToUse.DateTimeOfPaste]: ' +
      RecToUse.DateTimeOfPaste;
    Result := Result + #13#10 + '[RecToUse.DateTimeOfOriginalDoc]: ' +
      RecToUse.DateTimeOfOriginalDoc;
    Result := Result + #13#10 + '[RecToUse.GroupItems]';
    for X := Low(RecToUse.GroupItems) to High(RecToUse.GroupItems) do
    begin
      with RecToUse.GroupItems[X] do
      begin
        Result := Result + #13#10#9 + '[GroupParent]' + BoolToStr(GroupParent);
        Result := Result + #13#10#9 + '[GroupText]' + GroupText.Text;
        Result := Result + #13#10#9 + '[GroupParent]' + IntToStr(ItemIEN);
        Result := Result + #13#10#9 + '[VisibleOnNote]' +
          BoolToStr(VisibleOnNote);
        Result := Result + #13#10#9 + '[HiglightLines]:';
        for Y := Low(HiglightLines) to High(HiglightLines) do
        begin
          Result := Result + #13#10#9#9 + '[LineToHighlight]: ' + HiglightLines
            [Y].LineToHighlight;
          Result := Result + #13#10#9#9 + '[LineToHighlight]: ' +
            BoolToStr(HiglightLines[Y].AboveWrdCnt);
        end;
      end;
    end;
    Result := Result + #13#10 + '[HiglightLines]:';
    for Y := Low(RecToUse.HiglightLines) to High(RecToUse.HiglightLines) do
    begin
      Result := Result + #13#10#9 + '[LineToHighlight]: ' +
        RecToUse.HiglightLines[Y].LineToHighlight;
      Result := Result + #13#10#9 + '[LineToHighlight]: ' +
        BoolToStr(RecToUse.HiglightLines[Y].AboveWrdCnt);
    end;
    Result := Result + #13#10 + '[RecToUse.IdentFired]: ' +
      BoolToStr(RecToUse.IdentFired);
    Result := Result + #13#10 + '[RecToUse.InfoPanelIndex]: ' +
      IntToStr(RecToUse.InfoPanelIndex);
    Result := Result + #13#10 + '[RecToUse.New]: ' + BoolToStr(RecToUse.New);
    if Assigned(RecToUse.OriginalText) then
      Result := Result + #13#10 + '[RecToUse.OriginalText]: ' +
        RecToUse.OriginalText.Text;
    Result := Result + #13#10 + '[RecToUse.PasteDBID]: ' +
      IntToStr(RecToUse.PasteDBID);
    Result := Result + #13#10 + '[RecToUse.PastedPercentage]: ' +
      RecToUse.PastedPercentage;
    Result := Result + #13#10 + '[RecToUse.PastedText]: ' +
      RecToUse.PastedText.Text;
    Result := Result + #13#10 + '[RecToUse.UserWhoPasted]: ' +
      RecToUse.UserWhoPasted;
    Result := Result + #13#10 + '[RecToUse.VisibleOnList]: ' +
      BoolToStr(RecToUse.VisibleOnList);
    Result := Result + #13#10 + '[RecToUse.VisibleOnNote]: ' +
      BoolToStr(RecToUse.VisibleOnNote);
  end;

begin
  Result := '';
  for I := Low(Instance) to High(Instance) do
    Result := Result + '(' + IntToStr(I) + ')' + DumpRecordPasteRec(Instance[I]
      ) + #13#10;
end;

function TLogComponent.GetLogFileName(): String;
Var
  OurLogFile, LocalOnly, AppDir: string;

  // Finds the users special directory
  function LocalAppDataPath: string;
  const
    SHGFP_TYPE_CURRENT = 0;
  var
    path: array [0 .. MaxChar] of char;
  begin
    SHGetFolderPath(0, CSIDL_LOCAL_APPDATA, 0, SHGFP_TYPE_CURRENT, @path[0]);
    Result := StrPas(path);
  end;

begin
  OurLogFile := LocalAppDataPath;
  if (Copy(OurLogFile, Length(OurLogFile), 1) <> '\') then
    OurLogFile := OurLogFile + '\';

  LocalOnly := OurLogFile;

  // Now set the application level
  OurLogFile := OurLogFile + ExtractFileName(Application.ExeName);
  if (Copy(OurLogFile, Length(OurLogFile), 1) <> '\') then
    OurLogFile := OurLogFile + '\';
  AppDir := OurLogFile;

  // try to create or use base direcrtory
  if not DirectoryExists(AppDir) then
    if not ForceDirectories(AppDir) then
      OurLogFile := LocalOnly;

  OurLogFile := OurLogFile + 'CPRS_' + IntToStr(GetCurrentProcessID)
  { FormatDateTime('hhmmsszz', now) } + '_CopyPaste.TXT';

  Result := OurLogFile;
end;

procedure TLogComponent.LogText(Action, MessageTxt: string);
const
  PadLen: Integer = 18;
VAR
  AddText: TStringList;
  FS: TFileStream;
  Flags: Word;
  X, CenterPad: Integer;
  TextToAdd, Suffix, Suffix2: String;
begin
  FCriticalSection.Acquire;
  try
    if Trim(fOurLogFile) = '' then
      fOurLogFile := GetLogFileName;

    If FileExists(fOurLogFile) then
      Flags := fmOpenReadWrite
    else
      Flags := fmCreate;

    AddText := TStringList.Create;
    try
      AddText.Text := MessageTxt;

      if UpperCase(Action) = 'TEXT' then
      begin
        Suffix := FormatDateTime('hh:mm:ss', Now) + ' [' +
          UpperCase(Action) + ']';
        for X := 1 to AddText.Count - 1 do
        begin
          Suffix2 := '[' + IntToStr(X) + ' of ' +
            IntToStr(AddText.Count - 1) + ']';
          // center text
          CenterPad := round((PadLen - Length(Suffix2)) / 2);
          Suffix2 := StringOfChar(' ', CenterPad) + Suffix2;
          AddText.Strings[X] := Suffix2.PadRight(PadLen) + ' - ' +
            AddText.Strings[X];
        end;
      end
      else
      begin
        Suffix := FormatDateTime('hh:mm:ss', Now) + ' [' +
          UpperCase(Action) + ']';
        if AddText.Count > 1 then
        begin
          Suffix2 := FormatDateTime('hh:mm:ss', Now) + ' [' +
            StringOfChar('^', Length(Action)) + ']';
          for X := 1 to AddText.Count - 1 do
            AddText.Strings[X] := Suffix2.PadRight(PadLen) + ' - ' +
              AddText.Strings[X];
        end;
      end;
      TextToAdd := Suffix.PadRight(PadLen) + ' - ' + AddText.Text;

      FS := TFileStream.Create(fOurLogFile, Flags);
      try
        FS.Position := FS.Size;
        FS.Write(TextToAdd[1], Length(TextToAdd) * SizeOf(char));
      finally
        FS.Free;
      end;
    finally
      AddText.Free;
    end;
  finally
    FCriticalSection.Release;
  end;
end;

{$ENDREGION}

end.
