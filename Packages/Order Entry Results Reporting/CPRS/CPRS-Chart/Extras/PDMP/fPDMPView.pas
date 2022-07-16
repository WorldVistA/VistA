unit fPDMPView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, System.ImageList, System.Actions, SHDocVw,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.ImgList, Vcl.ActnList, Vcl.OleCtrls,
  ORFn, ORCtrls, rMisc, fBase508Form,
  mPDMPReviewOptions, oPDMPData, rPDMP, uPDMP;

type
  TpdmpView = class(TfrmBase508Form)
    pnlBottom: TPanel;
    btnDone: TButton;
    btnCancel: TButton;
    alResults: TActionList;
    acSelectAll: TAction;
    pnlBrowser: TPanel;
    acBrowser: TAction;
    wbPDMP: TWebBrowser;
    splBrowser: TSplitter;
    frPDMPReview: TfrPDMPReviewOptions;
    pnlCanvas: TPanel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure wbPDMPNavigateError(ASender: TObject; const pDisp: IDispatch;
      const URL, Frame, StatusCode: OleVariant; var Cancel: WordBool);
    procedure wbPDMPNavigateComplete2(ASender: TObject; const pDisp: IDispatch;
      const URL: OleVariant);
  private
    { Private declarations }
    fPageErrorCode: Integer;
    fUseDefaultBrowser: Boolean;
    pdmpDataObject: TpdmpDataObject;
    function validateBrowser: Boolean;
    procedure setUseDefaultBrowser(aValue: Boolean);
    procedure setHeight;
  public
    constructor createByPDMPData(aData: TpdmpDataObject;
      aDefaultBrowser: Boolean);
    property UseDefaultBrowser: Boolean read fUseDefaultBrowser
      write setUseDefaultBrowser;

    procedure _PDMP_WebError(var Message: TMessage); message UM_PDMP_WEBERROR;
    procedure _Pdmp_Refresh(var Message: TMessage); message UM_PDMP_Refresh;
    procedure setFontSize(aSize: Integer);
  end;

function showPDMP(pdmpData: TpdmpDataObject;
  DefaultBrowser: Boolean = false): string;
function IsEncounterOK: Boolean;

implementation

uses
  Winapi.CommCtrl, ShellAPI, HTTPApp,
{$IFDEF PDMPTEST}
  uCore.Encounter, uCore.SystemParameters, uCore.User, rCore.TIU, uCore.TIU,
{$ELSE}
  uCore,
  rTIU, uTIU, fFrame, rCore,
{$ENDIF}
  uFormUtils, uGN_RPCLog, uSizing, fEncnt, fPDMPCosigner;

{$R *.dfm}

const
  _URL_OK = 399;

procedure Pause(const ADelay: LongWord);
var
  StartTC: DWORD;
  CurrentTC: Int64;
begin
  StartTC := GetTickCount;
  repeat
    Application.ProcessMessages;
    CurrentTC := GetTickCount;
    if CurrentTC < StartTC then
      // tick count has wrapped around: adjust it
      CurrentTC := CurrentTC + High(DWORD);
  until CurrentTC - StartTC >= ADelay;
end;

function PageMsgByCode(aCode: Integer): String;
var
  msg: String;
const
  TryToRepeat = 'Try to repeat the request';
  NoReport = 'PDMP Report could not be retrieved ';

begin
  msg := '';
  case aCode of
    0 .. 399:
      msg := 'OK';
    400:
      msg := NoReport +
        '(Badly formed or invalid XML. HTTP Status: 400 - BAD REQUEST)';
    401:
      msg := NoReport + '(Failure in the authentication process, ' +
        'either with headers and password digest or the client certificate. HTTP STatus: 401 - UNAUTHORIZED)';
    403:
      msg := NoReport +
        '(Report request is requesting a report created by a different licensee. HTTP Status: 403 - FORBIDDEN)';
    404:
      msg := NoReport +
        '(No report exists for that URL. HTTP Status: 404 - NOT FOUND )';
    410:
      msg := NoReport + '(Report Request URL has expired)' + #13#10 +
        TryToRepeat;
    500:
      msg := NoReport + '(PDMP Gateway responded with: Internal Server Error)' +
        TryToRepeat;
    503:
      msg := NoReport + '(PDMP Gateway responded with: Service Unavailable)' +
        #13#10 + TryToRepeat;
    504:
      msg := NoReport + '(PDMP Gateway timed out)' + #13#10 + TryToRepeat;
  else
    msg := NoReport + '(PDMP Gateway responded with HTTP Status: ' +
      IntToStr(aCode) + ')' + #13#10 + TryToRepeat;

  end;
  Result := msg;
end;

function IsEncounterOK: Boolean;
var
  bEncounterUpdated: Boolean;
begin
{$IFDEF PDMPTEST}
  Result := True;
{$ELSE}
  bEncounterUpdated := false;
  if Encounter.NeedVisit then
  begin
    bEncounterUpdated := UpdateEncounter(0, 0, 0);
    frmFrame.DisplayEncounterText; // Updated encounter indicator(s)
  end;
  // Check again in case there was an attempt to update Encounter
  if Encounter.NeedVisit then
  begin
    if bEncounterUpdated then
      InfoBox('A valid encounter must be defined to access PDMP',
        PDMP_MSG_TITLE, MB_OK + MB_ICONERROR);
    Result := false;
  end
  else
    Result := True;
{$ENDIF}
end;

/// <summary> Validates the browser error code</summary>
function URLOK(aCode: Integer): Boolean;
begin
  Result := (0 <= aCode) and (aCode <= _URL_OK);
end;

/// <summary> Opens URL in external browser</summary>
procedure ShowURL(aURL: String);
begin
  ShellExecute(0, 'open', PChar(aURL), nil, nil, SW_SHOWNORMAL);
end;

/// <summary> Adds text to the end of existent TIU note </summary>
function UpdateNote(aNoteIEN: String; UpdateText: String): String;
var
  UpdatedNote: TCreatedDoc;
  NoteIEN: Int64;
  fEditNote: TEditNoteRec;
begin
  Result := '';
  NoteIEN := StrToIntDef(aNoteIEN, 0);
  if NoteIEN > 0 then
  begin
    GetNoteForEdit(fEditNote, StrToIntDef(aNoteIEN, 0));
    fEditNote.Lines.Text := fEditNote.Lines.Text + CRLF + CRLF + UpdateText;
    PutEditedNote(UpdatedNote, fEditNote, StrToIntDef(aNoteIEN, 0));
  end
  else
    Result := 'Incorrect note ID ' + aNoteIEN + '>';
end;

/// <summary> Registration of selected option on PDMP Review dialog in VistA </summary>
function registerReview(aData: TpdmpDataObject; noteText: String = ''): String;
var
  errList, tmpList: TStrings;
  sError, encDate, encType, sRC: string;
  iRC: Integer;

  function FormatLine(aLine: String; LL: Integer = 80): String;
  var
    iPos: Integer;
    s, ss, sLine: String;
  begin
    iPos := 0;
    Result := '';
    ss := '';
    sLine := '';
    while iPos < Length(aLine) do
    begin
      inc(iPos);
      s := copy(aLine, iPos, 1);
      if s = ' ' then
      begin
        if Length(sLine + ss) > LL then
        begin
          Result := Result + sLine + CRLF; // result is blank or ends on CRLF
          sLine := ss + ' ';
          ss := '';
        end
        else
        begin
          sLine := sLine + ss + ' ';
          ss := '';
        end;
      end
      else
        ss := ss + s;
    end;

    if Length(sLine + ss) > LL then
      Result := Result + sLine + CRLF + ss
    else
      Result := Result + sLine + ss;
  end;

  function FormatText(aText: String; LL: Integer = 80): String;
  var
    sl: TStrings;
    s: String;
  begin
    sl := TStringList.Create;
    sl.Text := aText;

    Result := '';
    for s in sl do
      Result := Result + FormatLine(s, LL) + CRLF;
  end;
{
  function pdmpNoteExists: Boolean;
  var
    ActionRec: TActionRec;
  begin
    ActOnDocument(ActionRec, StrToIntDef(aData.NoteIEN, 0), 'EDIT RECORD');
    Result := ActionRec.Success;
    // verification the note IEN used for correct Patient, user, note title IEN
    if Result then
    begin
      Result := pdmpIsNoteLinked(aData.NoteIEN, aData.PatIEN,
        IntToStr(User.DUZ));
      if not Result then
        sError := 'IEN reserved for PDMP note was reassigned';
    end
    else
      sError := 'PDMP Note can''t be edited';
  end;
}
begin
  Result := '-1^RegisterReview';

  if not assigned(Encounter) then
    exit;

  aData.VisitString := Encounter.VisitStr;

  encDate := Piece(aData.VisitString, ';', 2);
  encType := Piece(aData.VisitString, ';', 3);

  errList := TStringList.Create;
  tmpList := TStringList.Create;
  noteText := FormatText(noteText);
  tmpList.Text := noteText;
  sError := '';

  try
    begin
      sError := pdmpCreateNote(tmpList, encDate, aData.EncounterLocation,
        aData.VisitString, aData.PatIEN, aData.SignOnUserIEN,
        aData.AuthorizedUserIEN, sError, aData.VistATask, errList);
{$IFDEF PDMPTEST}
{$ELSE}
      sRC := Piece(sError, U, 1);
      iRC := StrToIntDef(sRC, -1);

      if (0 < iRC) then
      begin
        Changes.Add(10, Piece(sError, U, 1), Piece(sError, U, 2), '', 1);
        aData.NoteIEN := sRC;
        Result := sError;
      end
      else
      begin
        Result := sError;
        InfoBox('Note creation failed.' + #13#10#13#10 + Piece(sError, U, 2),
          'Error creating note', MB_OK);
      end;
{$ENDIF}
{$IFDEF DEBUG}
      AddLogLine('REVIEW TEXT: "' + noteText + '"' + #13#10 +
        'REGISTRATION RESULT:' + #13#10 + Result,
        'DEBUG: PDMP Review Registration');
{$ENDIF}
    end;
  finally
    FreeAndNil(tmpList);
  end
end;

/// <summary>Opens dialog window to review the results of the PDMP request</summary>
function showPDMP(pdmpData: TpdmpDataObject;
  DefaultBrowser: Boolean = false): string;
var
  iCount: Integer;
  s: String;
  pdmp: TpdmpView;

begin
  if not assigned(pdmpData) then
  begin
    beep;
    beep;
    beep;
    InfoBox(PDMP_ERROR_NO_DATA, PDMP_MSG_TITLE, MB_OK + MB_ICONERROR);
  end
  else
  begin
    if pdmpData.errorOccurred <> '' then
    begin
      InfoBox(pdmpData.errorOccurred, PDMP_MSG_TITLE, MB_OK + MB_ICONERROR);
      pdmpRegisterReview(pdmpData.VistATask, 'ERROR', pdmpData.errorOccurred);
    end
    else if pdmpData.pdmpList.Count = 1 then
    begin
      InfoBox(PDMP_NO_DATA_FOUND, PDMP_MSG_TITLE, MB_OK + MB_ICONWARNING);
      pdmpRegisterReview(pdmpData.VistATask, 'ERROR', PDMP_NO_DATA_FOUND);
    end
    else
    begin
      if IsEncounterOK then
      begin
        pdmp := TpdmpView.createByPDMPData(pdmpData, DefaultBrowser);
        try
          pdmp.setHeight;

          // flashing Cache with "YES" option prior to review
          pdmpRegisterReview(pdmpData.VistATask, 'YES');

          if DefaultBrowser then
            ShowURL(pdmpData.ReportURL)
          else
          begin
            pdmp.wbPDMP.Navigate(pdmpData.ReportURL);
            iCount := 0;
            // The latest state that was observed: INTERACTIVE :(
            while (pdmp.wbPDMP.ReadyState <> READYSTATE_INTERACTIVE) and
              (iCount < 30) do
            begin
              Pause(5);
              inc(iCount);
            end;
          end;
          //
          if pdmp.ShowModal = mrOK then
          begin
            s := pdmp.frPDMPReview.getValue;
            // Moving registration of the results to the point Browser reached INTERACTIVE State
            // ss := pdmpRegisterReview(pdmpData.VistATask, 'YES'); // add s if needed
            // if Piece(ss, '^', 1) = '1' then
            Result := registerReview(pdmpData, s); // updates CPRS notes list

            if assigned(Application.MainForm) then
              sendMessage(Application.MainForm.Handle, UM_PDMP_Reviewed,0,0);
          end
          else
          begin
            // registration of the case user canceled the Review dialog
            if pdmp.btnCancel.Caption <> 'Close' then
              pdmpRegisterReview(pdmpData.VistATask, 'RCANCEL');
            Result := ''; // don't update CPRS notes list
          end;
        finally
          pdmp.Free;
        end;
      end
      else
        Result := '-1^Encounter incomplete';
    end;
  end;
end;

/// /////////////////////////////////////////////////////////////////////////////
/// <summary> Review form constructor utilizing TPDMPDataObject information</summary>
constructor TpdmpView.createByPDMPData(aData: TpdmpDataObject;
  aDefaultBrowser: Boolean);
var
  sl: TStrings;
begin
  inherited Create(Application);
  pdmpDataObject := aData;
  if assigned(aData) then
  begin
    sl := TStringList.Create;
    try
      pdmpGetReviewOptions(sl, pdmpDataObject.HasDEA);
      frPDMPReview.setView(sl);
      frPDMPReview.Visible := sl.Count > 1;
    finally
      sl.Free;
    end;
  end;
  UseDefaultBrowser := aDefaultBrowser;
end;

procedure TpdmpView._PDMP_WebError(var Message: TMessage);
var
  msg: String;
begin
  msg := PageMsgByCode(Message.WParam);
  if msg = '' then
    msg := 'Oops!';
  ShowMessage(msg);
  ModalResult := mrCancel;
end;

procedure TpdmpView._Pdmp_Refresh(var Message: TMessage);
var
  h: Integer;
begin
  h := frPDMPReview.getOptionsHeight + 24;
  if UseDefaultBrowser then
      setHeight
  else
    if frPDMPReview.Height < h then
      frPDMPReview.Height := h;
end;

/// <summay> Hides TWebBrowser and updates size of the form if the default OS browser is used</summary>
procedure TpdmpView.setHeight;
var
  h, hh: Integer;
  r: TRect;
  Monitor: TMonitor;
begin
  h := frPDMPReview.getOptionsHeight + 24;
  if UseDefaultBrowser then
    self.Height := h + pnlBottom.Height + 48
  else
  begin
    Monitor := Screen.MonitorFromPoint(Mouse.CursorPos);
    r := Monitor.WorkareaRect;
    self.Height := r.Height;
    hh := self.Height div 4;
    if hh < h then
      h := hh;
    frPDMPReview.Height := h;
  end;
end;

/// <summary> User input validation </summary>
function TpdmpView.validateBrowser: Boolean;
var
  sError: String;
begin
  Result := frPDMPReview.IsValid(sError);
  if not Result then
    InfoBox(sError, PDMP_MSG_TITLE, MB_OK + MB_ICONERROR);
end;

/// <summary> Processes TWebBrowser navigation errors/return codes</summary>
procedure TpdmpView.wbPDMPNavigateComplete2(ASender: TObject;
  const pDisp: IDispatch; const URL: OleVariant);
var
  i: Integer;
  s: String;
begin
  inherited;
  // notify Server the navigation is complete
  i := wbPDMP.ReadyState;
  case i of
    0:
      s := 'UNINTIALIZED';
    1:
      s := 'LOADING';
    2:
      s := 'LOADED';
    3:
      s := 'INTERACTIVE';
    4:
      s := 'COMPLETE';
  else
    s := 'UNKNOWN ReadyState=' + IntToStr(i);
  end;
  // if (i = 3) and assigned(pdmpDataObject) then
  // pdmpRegisterReview(pdmpDataObject.VistATask, 'YES');
end;

/// <summary> Processing navigstion errors </summary>
/// <summary> Errors are placed in the RPC Log </summary>
procedure TpdmpView.wbPDMPNavigateError(ASender: TObject;
  const pDisp: IDispatch; const URL, Frame, StatusCode: OleVariant;
  var Cancel: WordBool);
var
  s, msg: String;
  b: Boolean;
begin
  inherited;
  fPageErrorCode := StatusCode;
  b := URLOK(fPageErrorCode);
  btnDone.Visible := b; // URLOK(fPageErrorCode);

  if not b then
  begin
    btnCancel.Caption := 'Close';
    adjustBtn(btnCancel);
  end;

  frPDMPReview.Visible := b;
  splBrowser.Visible := b;
  splBrowser.Top := frPDMPReview.Top - splBrowser.Height;

  msg := PageMsgByCode(fPageErrorCode);
{$IFDEF DEBUG}
{$ELSE}
  if not b then
{$ENDIF}
  begin
    s := 'URL ERROR: "' + IntToStr(StatusCode) + '"' + #13#10 + 'URL: ' + URL +
      #13#10 + msg;
    AddLogLine(s, 'PDMP URL ERROR ' + IntToStr(StatusCode));

    pdmpRegisterReview(pdmpDataObject.VistATask, 'ERROR', s);
  end;

  if fPageErrorCode < -99 then
    fPageErrorCode := 555;

  PostMessage(self.Handle, UM_PDMP_WEBERROR, fPageErrorCode, 0);
end;

/// <summary> Saves form position on clisng </summary>
procedure TpdmpView.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  try
    SaveUserBounds(self);
  finally
  end;
end;

/// <summary> Validates user input prior to form closing</summary>
procedure TpdmpView.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := (ModalResult = mrCancel) or (validateBrowser);
end;

/// <summary> Adjustment of the form components to match Main Form font </summary>
procedure TpdmpView.FormCreate(Sender: TObject);
begin
  inherited;
  ResizeFormToFont(self);
  SetFormPosition(self);
  btnDone.Caption := '&Done and Create Note';

  adjustBtn(btnCancel, True);
  adjustBtn(btnDone);
  Constraints.MinHeight := pnlBottom.Height * PDMP_ConstraintsRatio;

  frPDMPReview.ReviewHandler := self.Handle;
end;

/// <summary> ESC processing </summary>
procedure TpdmpView.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = VK_Escape then
  begin
    Key := 0;
    ModalResult := mrCancel;
  end;
end;

/// <summary> Hides bottom panel if the form is too small</summary>
procedure TpdmpView.FormResize(Sender: TObject);
begin
  inherited;
  pnlBottom.Visible := Height > pnlBottom.Height * PDMP_ConstraintsRatio;
end;

/// <summary> Adjust size of the form components to match main form font size</summary>
procedure TpdmpView.FormShow(Sender: TObject);
begin
  inherited;
  if assigned(Application.MainForm) then
  begin
    Font.Size := Application.MainForm.Font.Size;
    adjustBtn(btnCancel, True);
    adjustBtn(btnDone, True);
  end;
end;

/// <summary> Hides TWebBrowser component if the Default OS browser is used </summary>
procedure TpdmpView.setUseDefaultBrowser(aValue: Boolean);
begin
  fUseDefaultBrowser := aValue;

  pnlBrowser.Visible := not aValue;
  splBrowser.Visible := not aValue;
  if aValue then
    frPDMPReview.Align := alClient
  else
  begin
    frPDMPReview.Align := alBottom;
    splBrowser.Top := pnlBrowser.Height + 1;
  end;
end;

procedure TpdmpView.setFontSize(aSize: Integer);
begin
  Font.Size := aSize;
end;

end.
