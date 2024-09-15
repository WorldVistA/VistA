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

  TCPIndicator = (allchr, begchar, endchr, nochr, nachar);

  TPasteStatus = (PasteNew, PasteModify, PasteNA);

  TCPStatus = (AuditProc, AuditNA, AuditCom);

  // -------- RECORDS --------//

  tClipInfo = record
    AppName: string;
    AppClass: string;
    AppHwnd: HWND;
    AppPid: Cardinal;
    AppTitle: String;
    ObjectHwnd: HWND;
  end;

  TCprsClipboard = record
    ApplicationName: string;
    ApplicationPackage: string;
    CopiedFromIEN: Int64;
    CopiedFromPackage: string;
    CopiedText: TStringList;
    HashValue: String;
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

  THighlightRecord = record
    AboveWrdCnt: Boolean;
  strict private
    FLineToHighlight: WideString;
    function GetLineToHighlight: WideString;
  public
    procedure Assign(const Source: THighlightRecord);
    property LineToHighlight: WideString read GetLineToHighlight
      write FLineToHighlight;
  end;

  THighlightRecordArray = Array of tHighlightRecord;

  TGroupRecord = record
    GroupParent: Boolean;
    GroupText: TStringList;
    ItemIEN: Int64;
    VisibleOnNote: Boolean;
    HiglightLines: THighlightRecordArray;
  Public
    procedure Assign(const Source: TGroupRecord);
  end;

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

  TAllowMonitorEvent = procedure(Sender: TObject; var AllowMonitor: Boolean)
    of object;

  TLoadBuffEvent = procedure(Sender: TObject; LoadList: TStrings;
    var ProcessLoad: Boolean) of object;

  TLoadEvent = procedure(Sender: TObject; LoadList: TStrings;
    var ProcessLoad, PreLoaded: Boolean) of object;

  TLoadProperties = procedure(Sender: TObject) of object;

  TPollBuff = procedure(Sender: TObject; var Error: Boolean) of object;

  TRecalculateEvent = procedure(Sender: TObject; SaveList: TStringList)
    of object;

  TSaveEvent = procedure(Sender: TObject; SaveList: TStringList;
    var ReturnList: TStringList) of object;

  TVisible = procedure(Sender: TObject) of object;

  TVisualMessage = procedure(Sender: TObject; const CPmsg: Cardinal;
    CPVars: Array of Variant; FromNewPaste: Boolean = false) of object;

  TToggleEvent = procedure(Sender: TObject; Toggled: Boolean) of object;

  TNoParamEvent = procedure() of object;

  TCPFoundRec = record
    Text: String;
    NoteLine: Integer;
    PasteLine: Integer;
    StartChar: Integer;
    EndChar: Integer;
    LineIndicator: TCPIndicator;
  end;

  TCPTextRec = record
    Text: String;
    InnerLine: Integer;
    LineNumber: Integer;
    InnBeg: Integer;
    InnEnd: Integer;
    Found: Boolean;
  end;

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

  TCPMatchingLines = record
    NoteLineNum: Integer;
    PasteLineNum: Integer;
  end;

  TCPMatchingLinesArray = Array of TCPMatchingLines;
  TCPFindTxtRecArray = Array of TCPFindTxtRec;
  TCPFoundRecArray = Array of TCPFoundRec;

  TCpTextRecArray = array of TCPTextRec;

const
  UM_STATUSTEXT = (WM_USER + 302);
  // used to send update status msg to main form

implementation
uses
  System.SysUtils;

procedure THighlightRecord.Assign(const Source: THighlightRecord);
begin
  LineToHighlight := Source.LineToHighlight;
  AboveWrdCnt := Source.AboveWrdCnt;
end;

function THighlightRecord.GetLineToHighlight: WideString;
begin
  Result := System.SysUtils.Trim(FLineToHighlight);
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
