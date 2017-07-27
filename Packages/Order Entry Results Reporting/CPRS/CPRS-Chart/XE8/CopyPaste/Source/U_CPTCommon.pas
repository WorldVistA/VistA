{ ******************************************************************************

    ___  __  ____  _  _      _    ____   __   ____  ____  ____
   / __)/  \(  _ \( \/ )    / )  (  _ \ / _\ / ___)(_  _)(  __)
  ( (__(  O )) __/ )  /    / /    ) __//    \\___ \  )(   ) _)
   \___)\__/(__)  (__/    (_/    (__)  \_/\_/(____/ (__) (____)


  Common unit

  Type:

  TCPIndicator = Line indicator

  TPasteStatus = Status of each individual paste

  TCPStatus = Status of the note in reguards to Copy/Paste

  Records:

  tClipInfo = Holds information about the clipboard (if available)

  TCprsClipboard = Holds information about the copied/pasted text

  tHighlightRecord = Holds information about the identifiable text

  THighlightRecordArray = All the identifiable text

  TGroupRecord = Holds information about the grouped text

  TPasteText = Used when loading/displaying pasted text

  TCPFoundRec = This is the overall found record

  TCPTextRec = This array holds the lines for both the paste and the
  note (sepperate instances). This will be modified as the search is ran

  TCPFindTxtRec = Find text record. Holds the positions and is returned from FindText

  TCPMatchingLines =  This identifies the perfect match lines between PasteText and
  NoteText and is returned from FindMatchingLines


  Events:

  TAllowMonitorEvent = External call to allow the copy/paste functionality

  TLoadEvent = External call to load the pasted text

  TLoadProperties = External call to load the properties

  TPollBuff = Call to load the buffer (timmer)

  TRecalculateEvent = Call to save the recalculated percentages

  TSaveEvent = External call to save the pasted text

  TVisible = External call for Onshow/OnHide

  TVisualMessage = procedure that should fire for the visual message

  TToggleEvent = Event that fires when panel button is clicked


  { ****************************************************************************** }

unit U_CPTCommon;

interface

uses
  Winapi.Windows, Vcl.Graphics, Vcl.Controls,
  Winapi.Messages, Vcl.ExtCtrls, System.Classes;

type

  /// <summary> Line indicator
  /// allchr: All of the text was found
  /// begchar: Text was found at the start of the line
  /// endchr: Text was found at the end of the line
  /// nochr: No charactes exist on this line (blanks)
  /// nachar: No text is found on this line
  ///  </summary>
  TCPIndicator = (allchr, begchar, endchr, nochr, nachar);

  /// <summary> Status of each individual paste
  /// PasteNew: paste is "new" to the system
  /// PasteModify: Exisiting paste has been modified
  /// PasteNA: no specific status loaded for paste (default status)
  /// </summary>
  TPasteStatus = (PasteNew, PasteModify, PasteNA);

  /// <summary> Status of the note in reguards to Copy/Paste </summary>
  /// AuditProc: Audit in process</param>
  /// AuditNA: Audit not performed</param>
  /// AuditCom: Audit complete</param>
  /// </summary>
  TCPStatus = (AuditProc, AuditNA, AuditCom);

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
  /// <param name="CopiedFromIEN">IEN where text was copied from<para><b>Type: </b><c>Int64</c></para></param>
  /// <param name="CopiedFromPackage">Package this text came from<para><b>Type: </b><c>String</c></para>
  /// <para><b>Example:</b> if copied from a note (TIU package) this would be <example>8925</example></para></param>
  /// <param name="CopiedText">Text that was copied<para><b>Type: </b><c>TStringList</c></para></param>
  /// <param name="DateTimeOfCopy"> Date and time of the copy<para><b>Type: </b><c>String</c></para></param>
  /// <param name="DateTimeOfPaste"> Date and time of the paste<para><b>Type: </b><c>String</c></para></param>
  /// <param name="OriginalText">Holds the text before any modifications<para><b>Type: </b><c>TStringList</c></para></param>
  /// <param name="PasteDBID">IEN of the paste in the paste file<para><b>Type: </b><c>Integer</c></para></param>
  /// <param name="PasteToIEN">IEN this data was pasted to<para><b>Type: </b><c>Int64</c></para></param>
  /// <param name="PercentData">The IEN and Package used for the Source. Delimited by a ;<para><b>Type: </b><c>String</c></para></param>
  /// <param name="PercentMatch">Percent that pasted text matches this entry<para><b>Type: </b><c>Double</c></para></param>
  /// <param name="SaveForDocument">Flag used to "mark" for save into note<para><b>Type: </b><c>Boolean</c></para></param>
  /// <param name="SaveItemID">ID that was used to save the item. Used to match in recalc procedure<para><b>Type: </b><c>Integer</c></para></param>
  /// <param name="SaveToTheBuffer">Flag used to "mark" for save into buffer<para><b>Type: </b><c>Boolean</c></para></param>
  TCprsClipboard = record
    ApplicationName: string;
    ApplicationPackage: string;
    CopiedFromIEN: Int64;
    CopiedFromPackage: string;
    CopiedText: TStringList;
    DateTimeOfCopy: string;
    DateTimeOfPaste: String;
    OriginalText: TStringList;
    PasteDBID: Integer;
    PasteToIEN: Int64;
    PercentData: String;
    PercentMatch: Double;
    SaveForDocument: Boolean;
    SaveItemID: Integer;
    SaveToTheBuffer: Boolean;
  end;

  CprsClipboardArry = Array of TCprsClipboard;

  /// <summary>Holds information about the identifiable text</summary>
  /// <param name="LineToHighlight">The line of text that we found<para><b>Type: </b><c>WideString</c></para></param>
  /// <param name="AboveWrdCnt">Indicates if this line was above our word count (2)<para><b>Type: </b><c>Boolean</c></para></param>
  tHighlightRecord = record
    LineToHighlight: WideString;
    AboveWrdCnt: Boolean;
  Public
    procedure Assign(const Source: tHighlightRecord);
  end;

  /// <summary>All the identifiable text <see cref="U_CPTCommon|tHighlightRecord" /></summary>
  THighlightRecordArray = Array of tHighlightRecord;

  /// <summary>Holds information about the grouped text</summary>
  /// <param name="GroupParent">This would be the text from the parent record<para><b>Type: </b><c>TStringList</c></para></param>
  /// <param name="GroupText">the text that we are grouping<para><b>Type: </b><c>TStringList</c></para></param>
  /// <param name="ItemIEN">IEN of the paste in the paste file<para><b>Type: </b><c>Integer</c></para></param>
  /// <param name="VisibleOnNote">were we able to find the text on the document<para><b>Type: </b><c>Boolean</c></para></param>
  /// <param name="HiglightLines">List of identifiable text<para><b>Type: </b><c><seealso cref="THighlightRecordArray" /></c></para></param>
  TGroupRecord = record
    GroupParent: Boolean;
    GroupText: TStringList;
    ItemIEN: Int64;
    VisibleOnNote: Boolean;
    HiglightLines: THighlightRecordArray;
  Public
    procedure Assign(const Source: TGroupRecord);
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
    Status: TPasteStatus;
    OriginalText: TStringList;
    PasteDBID: Integer;
    PasteNoteIEN: Int64; //For addendums and saving modified text
    PastedPercentage: string;
    PastedText: TStringList;
    UserWhoPasted: string;
    VisibleOnList: Boolean;
    VisibleOnNote: Boolean;
    DoNotFind: Boolean;
  Public
    procedure Assign(const Source: TPasteText);
  end;

  TPasteArray = array of TPasteText;

  TPanelArry = Array of TPanel;

  // -------- Events --------//

  /// <summary>External call to allow the copy/paste functionality</summary>
  /// <param name="Sender">Object that is calling this<para><b>Type: </b><c>TObject</c></para></param>
  /// <param name="AllowMonitor">Flag indicates if this is excluded or not<para><b>Type: </b><c>Boolean</c></para></param>
  /// <remarks>Used to exclude Documents from copy/paste functionality</remarks>
  TAllowMonitorEvent = procedure(Sender: TObject; var AllowMonitor: Boolean)
    of object;

  /// <summary><para>External call to load the the buffer of pasted text</para></summary>
  /// <param name="Sender">Object that is calling this<para><b>Type: </b><c>TObject</c></para></param>
  /// <param name="LoadList">Load items into this list<para><b>Type: </b><c>TStrings</c></para></param>
  /// <param name="ProcessLoad">Flag determines if loading should continue<para><b>Type: </b><c>Boolean</c></para>
  /// <remarks><b>Default:</b><c> True</c></remarks></param>
  TLoadBuffEvent = procedure(Sender: TObject; LoadList: TStrings;
    var ProcessLoad: Boolean) of object;

  /// <summary><para>External call to load the pasted text</para></summary>
  /// <param name="Sender">Object that is calling this<para><b>Type: </b><c>TObject</c></para></param>
  /// <param name="LoadList">Load items into this list<para><b>Type: </b><c>TStrings</c></para></param>
  /// <param name="ProcessLoad">Flag determines if loading should continue<para><b>Type: </b><c>Boolean</c></para>
  /// <param name="PreLoaded">Flag determines if pastetext array was transfered over<para><b>Type: </b><c>Boolean</c></para>
  /// <remarks><b>Default:</b><c> True</c></remarks></param>
  TLoadEvent = procedure(Sender: TObject; LoadList: TStrings;
    var ProcessLoad, PreLoaded: Boolean) of object;

  /// <summary><para>External call to load the properties</para></summary>
  /// <param name="Sender">Object that is calling this<para><b>Type: </b><c>TObject</c></para></param>
  TLoadProperties = procedure(Sender: TObject) of object;

  TPollBuff = procedure(Sender: TObject; var Error: Boolean) of object;

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

  TNoParamEvent = procedure() of object;

  /// <summary> This is the overall found record  </summary>
  /// <param name="Text"> Text that was used for the "search"</param>
  /// <param name="NoteLine"> Note line number</param>
  /// <param name="PasteLine"> Paste line number</param>
  /// <param name="StartChar"> Index where this text begins</param>
  /// <param name="EndChar"> Index where this text ends</param>
  /// <param name="LineIndicator"> Indicator to determine what "type" of find this was <seealso cref="TCPIndicator" /></param>
  TCPFoundRec = record
    Text: String;
    NoteLine: Integer;
    PasteLine: Integer;
    StartChar: Integer;
    EndChar: Integer;
    LineIndicator: TCPIndicator;
  end;

  /// <summary> This array holds the lines for both the paste and the note (sepperate instances). This will be modified as the search is ran  </summary>
  /// <param name="Text"> Text that was used for the "search"</param>
  /// <param name="InnerLine"> Instance of this line number</param>
  /// <param name="LineNumber"> Line number that this text can be found on</param>
  /// <param name="Found"> triggers if we need to continue looking at this record</param>
  TCPTextRec = record
    Text: String;
    InnerLine: Integer;
    LineNumber: Integer;
    InnBeg: Integer;
    InnEnd: Integer;
    Found: Boolean;
  end;

  /// <summary> Find text record. Holds the positions and is returned from FindText
  /// </summary>
  /// <param name="PastedText"> The pasted text</param>
  /// <param name="PartialNoteText"> Partial text from the note array</param>
  /// <param name="FullNoteText"> Full unedited note text</param>
  /// <param name="NoteLine"> Line number to the note text</param>
  /// <param name="InnerNoteLine"> Count of sub entries for the note line</param>
  /// <param name="PosPartialLine"> Position of pasted text in the note array line (could be partial)</param>
  /// <param name="PosEntireLine"> Position of pasted text in the entire unedited note line</param>
  /// <param name="PosPastedLine"> Position of pasted text in the paste array line </param>
  TCPFindTxtRec = record
    PastedText: String;
    PartialNoteText: String;
    FullNoteText: String;
    NoteLine: Integer;
    InnerNoteLine: Integer;
    PosPartialLine: Integer;
    PosEntireLine: Integer;
    PosPastedLine: Integer;
  end;

  /// <summary> This identifies the perfect match lines between PasteText and NoteText and is returned from FindMatchingLines
  /// </summary>
  /// <param name="NoteLineNum"> Note line number</param>
  /// <param name="PasteLineNum"> Paste line number</param>
  TCPMatchingLines = record
    NoteLineNum: Integer;
    PasteLineNum: Integer;
  end;

  /// <summary>see <see cref="fFindPaste|TCPMatchingLines" /> for details</summary>
  TCPMatchingLinesArray = Array of TCPMatchingLines;
  /// <summary>see <see cref="fFindPaste|TCPFindTxtRec" />for details</summary>
  TCPFindTxtRecArray = Array of TCPFindTxtRec;
  /// <summary>see <see cref="fFindPaste|TCPFoundRec" />for details</summary>
  TCPFoundRecArray = Array of TCPFoundRec;

  TCpTextRecArray = array of TCPTextRec;

const
  UM_STATUSTEXT = (WM_USER + 302);
  // used to send update status msg to main form

implementation

procedure tHighlightRecord.Assign(const Source: tHighlightRecord);
begin
  LineToHighlight := Source.LineToHighlight;
  AboveWrdCnt := Source.AboveWrdCnt;
end;

procedure TGroupRecord.Assign(const Source: TGroupRecord);
var
  I: Integer;
begin
  GroupParent := Source.GroupParent;
  ItemIEN := Source.ItemIEN;
  VisibleOnNote := Source.VisibleOnNote;

  for I := Low(Source.HiglightLines) to High(Source.HiglightLines) do
  begin
    SetLength(HiglightLines, Length(HiglightLines) + 1);
    HiglightLines[High(HiglightLines)].Assign(Source.HiglightLines[I]);
  end;

  if Assigned(Source.GroupText) then
  begin
    GroupText := TStringList.Create;
    GroupText.Assign(Source.GroupText);
  end;

end;

procedure TPasteText.Assign(const Source: TPasteText);
var
  I: Integer;
begin
  CopiedFromApplication := Source.CopiedFromApplication;
  CopiedFromAuthor := Source.CopiedFromAuthor;
  CopiedFromDocument := Source.CopiedFromDocument;
  CopiedFromLocation := Source.CopiedFromLocation;
  CopiedFromPatient := Source.CopiedFromPatient;
  DateTimeOfPaste := Source.DateTimeOfPaste;
  DateTimeOfOriginalDoc := Source.DateTimeOfOriginalDoc;
  IdentFired := Source.IdentFired;
  InfoPanelIndex := Source.InfoPanelIndex;
  Status := Source.Status;
  PasteDBID := Source.PasteDBID;
  PasteNoteIEN := Source.PasteNoteIEN;
  PastedPercentage := Source.PastedPercentage;
  UserWhoPasted := Source.UserWhoPasted;
  VisibleOnList := Source.VisibleOnList;
  VisibleOnNote := Source.VisibleOnNote;

  if Assigned(Source.OriginalText) then
  begin
    OriginalText := TStringList.Create;
    OriginalText.Assign(Source.OriginalText);
  end;

  if Assigned(Source.PastedText) then
  begin
    PastedText := TStringList.Create;
    PastedText.Assign(Source.PastedText);
  end;

  for I := Low(Source.HiglightLines) to High(Source.HiglightLines) do
  begin
    SetLength(HiglightLines, Length(HiglightLines) + 1);
    HiglightLines[High(HiglightLines)].Assign(Source.HiglightLines[I]);
  end;

  for I := Low(Source.GroupItems) to High(Source.GroupItems) do
  begin
    SetLength(GroupItems, Length(GroupItems) + 1);
    GroupItems[High(GroupItems)].Assign(Source.GroupItems[I]);
  end;
end;

end.
