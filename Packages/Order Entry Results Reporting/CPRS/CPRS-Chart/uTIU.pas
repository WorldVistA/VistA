unit uTIU;

interface

uses SysUtils, Classes, ORNet, ORFn, rCore, uCore, uConst, ORCtrls, ComCtrls,
  Controls, Windows, Clipbrd;

type
  TNoteErrorReturn = (neAbort, neRetry, neIgnore);

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

  TNoteErrorObj = class(TObject)
    private
      fDocLines: TStringList;
      fCopyToClip: Boolean;
      fAllowIgnore: Boolean;
      fAllowAbort: Boolean;
      fErrMsg: String;
      fTitle: string;
      fIsNewNote: Boolean;
    public
      constructor Create(); overload;
      destructor Destroy; override;
      function ShowNoteError(): TNoteErrorReturn;
      procedure ShouldCopyToClipboard(Sender: TObject);
      property DocLines: TStringList read fDocLines write fDocLines;
      property AllowIgnore: Boolean read fAllowIgnore write fAllowIgnore;
      property AllowAbort: Boolean read fAllowAbort write fAllowAbort;
      property ErrorMessage: String read fErrMsg write fErrMsg;
      property Title: String read fTitle write fTitle;
      property IsNewNote: Boolean read fIsNewNote write fIsNewNote;
  end;

  // notes tab specific procedures
function MakeNoteDisplayText(RawText: string): string;
function MakeConsultDisplayText(RawText: string): string;
function SetLinesTo74ForSave(AStrings: TStrings; AParent: TWinControl)
  : TStrings;
function UserIsCosigner(anIEN: Integer; aUser: String): boolean;

function ShowNoteError(ErrMsg: String; Lines: TStrings; AllowIgnore: Boolean = False; AllowAbort: Boolean = False): TNoteErrorReturn;
function ShowNewNoteError(DocType, ErrMsg: String; Lines: TStrings; AllowIgnore: Boolean = False; AllowAbort: Boolean = False): TNoteErrorReturn;

implementation

uses
  ORExtensions,
  rTIU, uDocTree, VAUtils, vcl.Dialogs, vcl.Themes, Vcl.StdCtrls, system.UITypes, VA508AccessibilityRouter;

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
  ARichEdit74: ORExtensions.TRichEdit;
begin
  Result := AStrings;
  ARichEdit74 := ORExtensions.TRichEdit.Create(AParent);
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

// procedure ShowNoteError(ErrMsg: string; Lines: TStrings);
function ShowNoteError(ErrMsg: string; Lines: TStrings;
  AllowIgnore: Boolean = False; AllowAbort: Boolean = False): TNoteErrorReturn;
const
  TC_SAVE_ERROR = 'Error saving note text';
var
  NoteErrObj: TNoteErrorObj;
begin
  NoteErrObj := TNoteErrorObj.Create;
  try
    NoteErrObj.ErrorMessage := ErrMsg;
    NoteErrObj.Title := TC_SAVE_ERROR;
    If Assigned(Lines) then
      NoteErrObj.DocLines.Assign(Lines);
    NoteErrObj.AllowIgnore := AllowIgnore;
    NoteErrObj.AllowAbort := AllowAbort;
    NoteErrObj.IsNewNote := False;
    Result := NoteErrObj.ShowNoteError;
  finally
    FreeAndNil(NoteErrObj);
  end;
end;

function ShowNewNoteError(DocType, ErrMsg: String; Lines: TStrings; AllowIgnore: Boolean = False; AllowAbort: Boolean = False): TNoteErrorReturn;
const
  TC_CREATE_ERROR = 'Error creating %s.';
var
  NoteErrObj: TNoteErrorObj;
begin
  NoteErrObj := TNoteErrorObj.Create;
  try
    NoteErrObj.ErrorMessage := ErrMsg;
    NoteErrObj.Title := Format(TC_CREATE_ERROR, [DocType]);
    If Assigned(Lines) then
      NoteErrObj.DocLines.Assign(Lines);
    NoteErrObj.AllowIgnore := AllowIgnore;
    NoteErrObj.AllowAbort := AllowAbort;
    NoteErrObj.IsNewNote := True;
    Result := NoteErrObj.ShowNoteError;
  finally
    FreeAndNil(NoteErrObj);
  end;
end;

{ TNoteErrorObj }

procedure TNoteErrorObj.ShouldCopyToClipboard(Sender: TObject);
const
  ClipTxt = 'This will overwrite anything that is already in the clipboard. %s';
var
  rtnEvt: TNotifyEvent;
begin
 If (sender is TTaskDialog) then
 begin
   fCopyToClip := tfVerificationFlagChecked in TTaskDialog(Sender).Flags;
   if fCopyToClip then
   begin
     TTaskDialog(Sender).FooterText := Format(ClipTxt, ['']);
     TTaskDialog(Sender).FooterIcon := tdiWarning;
   end else
   begin
    TTaskDialog(Sender).FooterText := '';
    TTaskDialog(Sender).FooterIcon := tdiNone;
   end;
 end else
 begin
   If (sender is TCheckBox) then
   begin
     fCopyToClip := TCheckBox(sender).Checked;
     if fCopyToClip then
     begin
      if MessageDlg(Format(ClipTxt, ['Are you sure?']), mtWarning, [mbYes, mbNo], -1, mbYes) = mrNo then
      begin
        fCopyToClip := false;
        rtnEvt := TCheckBox(sender).OnClick;
        TCheckBox(sender).OnClick := nil;
        try
          TCheckBox(sender).Checked := false;
        finally
          TCheckBox(sender).OnClick := rtnEvt;
        end;
      end;
     end;
   end;
 end;
end;

constructor TNoteErrorObj.Create();
begin
  Inherited Create;
  fDocLines := TStringlist.create;
end;

destructor TNoteErrorObj.Destroy;
begin
 FreeAndNil(fDocLines);
 Inherited;
end;

function TNoteErrorObj.ShowNoteError(): TNoteErrorReturn;
const
  TX_SAVE_ERROR1 =
    'An error was encountered while trying to save the note you are editing.' +
    CRLF + CRLF + '    Error:  ';

  TX_CREATE_ERROR = 'An error was encountered while trying to create the document. ';

  TX_SAVE_ERROR3 = CRLF + CRLF + '%s will attempt this action again. ' + '%s %s'
    + CRLF + CRLF +
    'Please note If problems continue, or network connectivity is lost, please copy all of your text to '
    + 'the clipboard and paste it into Microsoft Word before continuing or before closing CPRS.';

  TX_SAVE_ERROR_IGNORE = CRLF + CRLF +
    '%s will return back to chart without the changes saved. ' +
    'From there you can try again now using CTRL-SHIFT-S, or ''Save without signature''.'
    + 'These actions will improve the likelihood that no text will be lost.';
  TX_SAVE_ERROR_ABORT = CRLF + CRLF +
    '%s will abandon these changes and revert the note to it''s prior saved state.';
  TX_SAVE_ERROR_NEW_ABORT = CRLF + CRLF + '%s will abandon this new document.';
  TX_SAVE_ERROR_COPY = 'Copy note text to clipboard? This will overwrite anything that is already in the clipboard.';
var
  Msg, IgnoreMsg, AbortMsg: string;
  AModalResult: Integer;
  MsgBtns: TMsgDlgButtons;
  ShouldCopyBool: Boolean;
  TskDlg: TTaskDialog;
  TskBtn: TTaskDialogBaseButtonItem;
begin
  Result := neIgnore;

  if (not ScreenReaderActive) and (Win32MajorVersion >= 6) and StyleServices.Enabled then
  begin
    IgnoreMsg := '';
    AbortMsg := '';

    if FAllowIgnore then
      IgnoreMsg := Format(TX_SAVE_ERROR_IGNORE, ['RETURN TO NOTE']);

    if FAllowAbort then
    begin
     if fIsNewNote then
      AbortMsg := Format(TX_SAVE_ERROR_NEW_ABORT, ['ABORT'])
     else
      AbortMsg := Format(TX_SAVE_ERROR_ABORT, ['ABORT']);
    end;

    if fIsNewNote then
      Msg := TX_CREATE_ERROR + FErrMsg + Format(TX_SAVE_ERROR3, ['RETRY', IgnoreMsg, AbortMsg])
    else
      Msg := TX_SAVE_ERROR1 + FErrMsg + Format(TX_SAVE_ERROR3, ['RETRY', IgnoreMsg, AbortMsg]);


    TskDlg := TTaskDialog.Create(nil);
    try
      TskDlg.Title := FTitle;
      TskDlg.Caption := FTitle;
      TskDlg.Text := Msg;
      TskDlg.CommonButtons := [];

      TskBtn := TskDlg.Buttons.Add;
      TskBtn.Caption := 'Retry';
      TskBtn.ModalResult := MrRetry;

      if FAllowIgnore then
      begin
        TskBtn := TskDlg.Buttons.Add;
        TskBtn.Caption := 'Return to Note';
        TskBtn.ModalResult := MrIgnore;
      end;

      if FAllowAbort then
      begin
        TskBtn := TskDlg.Buttons.Add;
        TskBtn.Caption := 'Abort';
        TskBtn.ModalResult := MrAbort;
      end;

      TskDlg.MainIcon := TdiError;
      TskDlg.VerificationText := 'Copy note text to Clipboard';
      TskDlg.Flags := [];
      TskDlg.OnVerificationClicked := ShouldCopyToClipboard;
      TskDlg.FooterText := ' ';
      TskDlg.FooterIcon := TdiNone;
      TskDlg.Buttons.DefaultButton := TskDlg.Buttons.FindButton(MrRetry);

      if TskDlg.Execute then
      begin
        if FCopyToClip then
          Clipboard.AsText := FDocLines.Text;

        case TskDlg.ModalResult of
          MrRetry:
            Result := neRetry;
          MrNo:
            Result := neIgnore;
          MrAbort:
            Result := neAbort;
        end;
      end;
    finally
      FreeAndNil(TskDlg);
    end;
  end
  else
  begin
    IgnoreMsg := '';
    AbortMsg := '';
    MsgBtns := [];
    Include(MsgBtns, MbRetry);

    if FAllowIgnore then
    begin
      IgnoreMsg := Format(TX_SAVE_ERROR_IGNORE, ['IGNORE']);
      Include(MsgBtns, MbIgnore);
    end;

    if FAllowAbort then
    begin
      AbortMsg := Format(TX_SAVE_ERROR_ABORT, ['ABORT']);
      Include(MsgBtns, MbAbort);
    end;

    if fIsNewNote then
      Msg := TX_CREATE_ERROR + FErrMsg + Format(TX_SAVE_ERROR3, ['RETRY', IgnoreMsg, AbortMsg])
    else
      Msg := TX_SAVE_ERROR1 + FErrMsg + Format(TX_SAVE_ERROR3, ['RETRY', IgnoreMsg, AbortMsg]);

    AModalResult := InfoDlgWithCheckbox(Msg, fTitle, mtError, MsgBtns, True,
      TX_SAVE_ERROR_COPY, ShouldCopyToClipboard, ShouldCopyBool);

    if ShouldCopyBool then
      Clipboard.AsText := FDocLines.Text;

    case AModalResult of
      MrRetry:
        Result := neRetry;
      MrIgnore:
        Result := neIgnore;
      MrAbort:
        Result := neAbort;
    end;
  end;
end;

end.
