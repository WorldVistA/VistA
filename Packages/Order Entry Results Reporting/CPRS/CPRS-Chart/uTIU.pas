unit uTIU;

interface

uses SysUtils, Classes, ORNet, ORFn, rCore, uCore, uConst, ORCtrls, ComCtrls,
  Controls, Windows, Clipbrd;

type
  TEditNoteRec = record
    DocType: Integer;
    IsNewNote: boolean;
    Title: Integer;
    TitleName: string;
    DateTime: TFMDateTime;
    Author: Int64;
    AuthorName: string;
    Cosigner: Int64;
    CosignerName: string;
    Subject: string;
    Location: Integer;
    LocationName: string;
    VisitDate: TFMDateTime;
    PkgRef: string; // 'IEN;GMR(123,' or 'IEN;SRF('
    PkgIEN: Integer; // file IEN
    PkgPtr: string; // 'GMR(123,' or 'SRF('
    NeedCPT: boolean;
    Addend: Integer;
    LastCosigner: Int64;
    LastCosignerName: string;
    IDParent: Integer;
    ClinProcSummCode: Integer;
    ClinProcDateTime: TFMDateTime;
    Lines: TStrings;
    PRF_IEN: Integer;
    ActionIEN: string;
  end;

  TNoteRec = TEditNoteRec;

  TActionRec = record
    Success: boolean;
    Reason: string;
  end;

  TCreatedDoc = record
    IEN: Integer;
    ErrorText: string;
  end;

  TTIUContext = record
    Changed: boolean;
    BeginDate: string;
    EndDate: string;
    FMBeginDate: TFMDateTime;
    FMEndDate: TFMDateTime;
    Status: string;
    Author: Int64;
    MaxDocs: Integer;
    ShowSubject: boolean;
    SortBy: string;
    ListAscending: boolean;
    GroupBy: string;
    TreeAscending: boolean;
    SearchField: string;
    KeyWord: string;
    Filtered: boolean;
    SearchString: String; // Text Search CQ: HDS00002856
  end;

  TNoteTitles = class(TObject)
  public
    DfltTitle: Integer;
    DfltTitleName: string;
    ShortList: TStringList;
    constructor Create;
    destructor Destroy; override;
  end;

  TTIUPrefs = class(TObject)
  public
    DfltLoc: Integer;
    DfltLocName: string;
    SortAscending: boolean;
    SortBy: string; // D,R,S,A
    AskNoteSubject: boolean;
    AskCosigner: boolean;
    DfltCosigner: Int64;
    DfltCosignerName: string;
    MaxNotes: Integer;
  end;

  // notes tab specific procedures
function MakeNoteDisplayText(RawText: string): string;
function MakeConsultDisplayText(RawText: string): string;
function SetLinesTo74ForSave(AStrings: TStrings; AParent: TWinControl)
  : TStrings;
function UserIsCosigner(anIEN: Integer; aUser: String): boolean;

procedure ShowNoteError(ErrMsg: string; Lines: TStrings);
procedure ShowNewNoteError(DocType: string; Lines: TStrings);

implementation

uses
  rTIU, uDocTree;

const
  TX_CLIPBOARD_MSG = CRLF + CRLF + 'Would you like CPRS to copy this text to the clipboard for ' +
    'you?  Doing so will overwrite anything that is already in the clipboard.';

  TX_SAVE_ERROR1 =
    'An error was encountered while trying to save the note you are editing.' +
    CRLF + CRLF + '    Error:  ';
  TX_SAVE_ERROR2 = CRLF + CRLF +
    'Please try again now using CTRL-SHIFT-S, or ''Save without signature''.' +
    'These actions will improve the likelihood that no text will be lost.'
    + CRLF + CRLF +
    'If problems continue, or network connectivity is lost, please copy all of your text to '
    + 'the clipboard and paste it into Microsoft Word before continuing or before closing CPRS.';
  TC_SAVE_ERROR = 'Error saving note text';


function MakeConsultDisplayText(RawText: string): string;
var
  x: string;
begin
  x := RawText;
  Result := Piece(x, U, 2) + ',' + Piece(x, U, 3) + ',' + Piece(x, U, 4) + ', '
    + Piece(x, U, 5);

end;

function MakeNoteDisplayText(RawText: string): string;
var
  x: string;

  function GetText: string;
  begin
    if ShowMoreNode(Piece(x, U, 2)) then
      Result := Piece(x, U, 2)
    else
    begin
      Result := FormatFMDateTime('mmm dd,yy', MakeFMDateTime(Piece(x, U, 3))) + '  ';
      Result := Result + Piece(x, U, 2) + ', ' + Piece(x, U, 6) + ', ' +
        Piece(Piece(x, U, 5), ';', 2)
    end;
  end;

begin
  x := RawText;
  if Piece(x, U, 1) = '' then
    Result := GetText
  else if CharInSet(Piece(x, U, 1)[1], ['A', 'N', 'E']) then
    Result := Piece(x, U, 2)
  else
    Result := GetText;
end;

{ Progress Note Titles  -------------------------------------------------------------------- }
constructor TNoteTitles.Create;
{ creates an object to store progress note titles so only obtained from server once }
begin
  inherited Create;
  ShortList := TStringList.Create;
end;

destructor TNoteTitles.Destroy;
{ frees the lists that were used to store the progress note titles }
begin
  ShortList.Free;
  inherited Destroy;
end;

function SetLinesTo74ForSave(AStrings: TStrings; AParent: TWinControl)
  : TStrings;
var
  ARichEdit74: TRichEdit;
begin
  Result := AStrings;
  ARichEdit74 := TRichEdit.Create(AParent);
  try
    ARichEdit74.Parent := AParent;
    ARichEdit74.Lines.Text := AStrings.Text;
    ARichEdit74.Width := 525;
    Result.Text := ARichEdit74.Lines.Text;
    // QuickCopy(ARichEdit74, Result);
  finally
    ARichEdit74.Free;
  end;
end;

function UserIsCosigner(anIEN: Integer; aUser: String): boolean;
var
  i: Integer;
  sl: TStrings;
begin
  Result := False;
  sl := TStringList.Create;
  try
    setCurrentSigners(sl, anIEN);
    for i := 0 to sl.Count - 1 do
    begin
      if Piece(sl.Strings[i], U, 3) = 'Expected Cosigner' then
      begin
        Result := Piece(sl.Strings[i], U, 1) = aUser; // IntToStr(User.DUZ));
        break;
      end;
    end;
  finally
    sl.Free;
  end;
end;

procedure ShowNoteError(ErrMsg: string; Lines: TStrings);
var
  msg: string;

begin
  msg := TX_SAVE_ERROR1 + ErrMsg + TX_SAVE_ERROR2 + TX_CLIPBOARD_MSG;
  if InfoBox(msg, TC_SAVE_ERROR, MB_YESNO or MB_ICONWARNING) = mrYes then
    Clipboard.AsText := Lines.Text;
end;

const
  TX_CREATE_ERROR = 'An error was encountered while trying to create this %s.  ' +
    'It may or may not have been created.  You will need to refresh patient ' +
    'information to be sure.' + CRLF + CRLF +
    'To prevent the loss of your work, you should copy you text into the ' +
    'clipboard, and paste it into Microsoft Word, before refreshing patient ' +
    'information.  Afterwards, if the %s has been created, you should edit ' +
    'it, and paste your saved text back into the document.  If, after ' +
    'refreshing patient information, the %s has not been created, you will '+
    'need to create a new %s, then paste your saved text info the new document.' +
    TX_CLIPBOARD_MSG;

  TC_CREATE_ERROR = 'Error creating %s.';

procedure ShowNewNoteError(DocType: string; Lines: TStrings);
var
  msg, title: string;

begin
  msg := Format(TX_CREATE_ERROR, [DocType, DocType, DocType, DocType]);
  title := Format(TC_CREATE_ERROR, [DocType]);
  if InfoBox(msg, title, MB_YESNO or MB_ICONWARNING) = mrYes then
    Clipboard.AsText := Lines.Text;
end;

end.
