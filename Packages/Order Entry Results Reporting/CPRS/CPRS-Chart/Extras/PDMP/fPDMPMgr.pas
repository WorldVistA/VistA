unit fPDMPMgr;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, fBase508Form,
  System.ImageList, Vcl.ImgList, System.Actions, Vcl.ActnList, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ExtCtrls,
  oPDMPData, uPDMP;

type
  TfrmPDMP = class(TfrmBase508Form)
    alPdmp: TActionList;
    acResults: TAction;
    acPDMPRequest: TAction;
    acCancel: TAction;
    pnlPdmp: TPanel;
    bbCancel: TButton;
    bbResults: TButton;
    bbStart: TButton;
    procedure acCancelExecute(Sender: TObject);
    procedure acPDMPRequestExecute(Sender: TObject);
    procedure acResultsExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    fCachedData: Boolean;
    fUseDefaultBrowser: Boolean;
    fShowNow: Boolean;
    fAlignView: TAlign;
    fStatus: Integer;
    fNoteIEN: String;
    fRequester: Pointer;
    fPDMPData: TPDMPDataObject;

    procedure UMPdmpAbort(var Message: TMessage); message UM_PDMP_Abort;
    procedure UMPdmpDone(var Message: TMessage); message UM_PDMP_Done;
    procedure UMPdmpError(var Message: TMessage); message UM_PDMP_Error;
    procedure UMPdmpLoading(var Message: TMessage); message UM_PDMP_Loading;
    procedure UMPdmpReady(var Message: TMessage); message UM_PDMP_Ready;

    procedure doShowResults;
    procedure doDone;

    procedure setStatus(aStatus: Integer);
    procedure updateBtnWidth(aBtn: TButton; aCaption: String = '');
    procedure notifyManager(var Message: TMessage);
    procedure updateChangeList;

    function CanCosign: Boolean;

  public
    { Public declarations }
    property AlignView: TAlign read fAlignView write fAlignView;
    property ShowNow: Boolean read fShowNow write fShowNow;
    property CachedData: Boolean read fCachedData write fCachedData;
    property Status: Integer read fStatus write setStatus;
    property PDMPData: TPDMPDataObject read fPDMPData;
    property UseDefaultBrowser: Boolean read fUseDefaultBrowser
      write fUseDefaultBrowser;
    property  PDMPNoteIEN: String read fNoteIEN write fNoteIEN;
    property Requester: pointer read fRequester write fRequester;

    procedure doStart(aRequester:Pointer = nil);
    procedure doCancel(bKill: Boolean = True);
    procedure updateFont;
    procedure doCache(aPatient: String; aResult: TStrings = nil);
    function getLastReviewDate(aPatientID: String): String;
  end;

var
  frmPDMP: TfrmPDMP;

implementation

{$R *.dfm}

uses
  fEncnt, ORFn, fPDMPView,    fReminderDialog,
  uCore, fFrame, rCore, uSizing,
  rPDMP, fPDMPUser, fPDMPCosigner, UResponsiveGUI;

const
  CAPTION_GAP = 8;
  cRequestHintDefault = 'Request PDMP data';
  fmtLastReview = 'Last query completed: %s';

procedure TfrmPDMP.notifyManager(var Message: TMessage);
begin
  if assigned(Application.MainForm) then
    PostMessage(Application.MainForm.Handle, Message.Msg, Message.WParam,
      Message.LParam);
end;

procedure TfrmPDMP.UMPdmpAbort(var Message: TMessage);
begin
  updateChangeList;
  Status := UM_PDMP_Done;
  notifyManager(Message);
end;

procedure TfrmPDMP.UMPdmpError(var Message: TMessage);
begin
  updateChangeList;
  Status := UM_PDMP_Ready;
  notifyManager(Message);
end;

procedure TfrmPDMP.UMPdmpLoading(var Message: TMessage);
begin
  Status := UM_PDMP_Loading;
  notifyManager(Message);
end;

procedure TfrmPDMP.UMPdmpReady(var Message: TMessage);
begin
  Status := UM_PDMP_Ready;
//  notifyManager(Message); - commented as this is status of DATA not UI
end;

procedure TfrmPDMP.UMPdmpDone(var Message: TMessage);
var
  pdmpObject: TPDMPDataObject;
begin
  pdmpObject := TPDMPDataObject(message.WParam);
  if pdmpObject <> nil then
    Status := UM_PDMP_Done
  else
  begin
    Status := UM_PDMP_Error;
    InfoBox('PDMP: Expected PDMP DATA object not found', PDMP_MSG_TITLE,
      MB_OK + MB_ICONERROR);
  end;
  notifyManager(Message);
end;

procedure TfrmPDMP.acCancelExecute(Sender: TObject);
begin
  doCancel; // kills VistA job polling data
end;

procedure TfrmPDMP.acPDMPRequestExecute(Sender: TObject);
var
  sl: TStringList;
begin
  if PDMP_ENABLED then
  begin
    acPDMPRequest.Enabled := False;
    pdmpGetParams;
    sl := TStringList.Create;
    try
      if PDMP_RPC_CHECK then // check if all PDMP RPCs are present
      begin
        if not pdmpRPCCheck(sl) then
          if InfoBox('Incomplete RPC set.' + CRLF +
            'The next RPC(s) are missing:' + CRLF + CRLF + sl.Text + CRLF + CRLF
            + 'Do you want to continue?', PDMP_MSG_TITLE,
            MB_YESNO + MB_ICONWARNING) <> ID_Yes then
            exit;
      end;
      doStart(Sender); // check requirements, create pdmpData object, Load data
    finally
      sl.Free;
      acPDMPRequest.Enabled := True;
    end;
  end
  else
    InfoBox('PDMP functionality is DISABLED', PDMP_MSG_TITLE,
      MB_OK + MB_ICONWARNING);
end;

procedure TfrmPDMP.acResultsExecute(Sender: TObject);
begin
  acResults.Enabled := False;
  fRequester := Sender;
  doShowResults;
  acResults.Enabled := True;
end;

procedure TfrmPDMP.doCancel(bKill: Boolean = True);
begin
  case Status of
    UM_PDMP_Loading:
      begin
        if assigned(PDMPData) then
        begin
          // assigning blank value to the VistATask kills it
          // Comment it out to let the background task finish
          if not fPDMPData.DataLoaded then
          begin
            if bKill then
              fPDMPData.VistATask := '';
          end;
          doDone; // cleans PDMPData object, stops timer
        end;
      end;
    UM_PDMP_Ready:
      doDone;
  end;
end;

procedure TfrmPDMP.doStart(aRequester:Pointer = nil);
var
  pdmpCosignerRequired: Boolean;
  tempUser, CosignerIEN, CosignerName: string;
  DelegationAllowed, hasDea: Boolean;
begin
  if SystemParameters.AsType<string>('PDMP.validNoteTitle') <> '1' then
  begin
    InfoBox('No valid PDMP Note Title found', PDMP_MSG_TITLE,
      MB_OK + MB_ICONERROR);
    Status := 0;
    exit;
  end;

  fRequester := aRequester;            // Tracking origin of the request
  fShowNow := not assigned(Requester); // Auto-opens non modal results view

  if not assigned(fPDMPData) then
    fPDMPData := TPDMPDataObject.Create;
  PDMPData.pdmpClearData;

  if PDMPData <> nil then
  begin
    // Need to init Data object and verify if it is authorized to do the request
    hasDea := SystemParameters.AsType<string>('PDMP.isAuthorizedUser') = '1';
    pdmpCosignerRequired := SystemParameters.AsType<string>(PDMP_PARAM_RequiredCosigner) = '1';
    DelegationAllowed := SystemParameters.AsType<string>('PDMP.delegateFeatureEnabled') = '1';

    PDMPData.Init(IntToStr(User.DUZ), IntToStr(Encounter.Provider) + U +
      Encounter.ProviderName, IntToStr(Encounter.Location), Patient.DFN,
      Encounter.VisitStr, hasDea, self.Handle);

    Status := UM_PDMP_Init;

    if hasDea then
    begin
      if pdmpCosignerRequired then
      begin
        CosignerIEN := pdmpSelectCosigner('', 0, FMNow);
        CosignerName := piece(CosignerIEN, U, 2);
        CosignerIEN := piece(CosignerIEN, U, 1);
      end
      else
        CosignerIEN := '';

      if CosignerIEN <> '-2' then
      begin
        PDMPData.AuthorizedUserIEN := CosignerIEN; // IntToStr(User.DUZ);
        PDMPData.AuthorizedUserName := CosignerName; // User.Name;
        Status := PDMPData.LoadData(CosignerIEN); // UM_PDMP_Loading or UM_PDMP_ERROR;
      end
      else
      begin
        Status := 0;
        PostMessage(Application.MainForm.Handle, UM_PDMP_Abort, 0, 0);
      end;
    end
    else if DelegationAllowed then
    begin
      tempUser := pdmpSelectUser(PDMPData.EncounterProviderName, True,
        pdmpCosignerRequired);
      if tempUser = '-1' then // selection failed
      begin
        InfoBox('Authorized PDMP User not selected', PDMP_MSG_TITLE,
          MB_OK + MB_ICONWARNING);
        Status := 0;
        PostMessage(Application.MainForm.Handle, UM_PDMP_Abort, 0, 0);
      end
      else if tempUser = '-2' then // user canceled selection
      begin
        Status := 0;
        PostMessage(Application.MainForm.Handle, UM_PDMP_Abort, 0, 0);
      end
      else
      begin
        PDMPData.AuthorizedUserIEN := piece(tempUser, U, 1);
        PDMPData.AuthorizedUserName := piece(tempUser, U, 2);
        Status := PDMPData.LoadData; // UM_PDMP_Loading or UM_PDMP_ERROR
      end;
    end
    else
    begin
      InfoBox('PDMP Authorization Delegation is not allowed', PDMP_MSG_TITLE,
        MB_OK + MB_ICONWARNING);
      Status := 0;
      PostMessage(Application.MainForm.Handle, UM_PDMP_Abort, 0, 0);
    end;
  end
  else
  begin
    InfoBox('STARTING PDMP Error:' + CRLF + 'Failed to create PDMPData',
      PDMP_MSG_TITLE, MB_OK + MB_ICONERROR);
    PostMessage(Application.MainForm.Handle, UM_PDMP_Abort, 0, 0);
  end;
end;

procedure TfrmPDMP.FormCreate(Sender: TObject);
begin
  inherited;
  updateFont;
  if not assigned(fPDMPData) then
    fPDMPData := TPDMPDataObject.Create;
  AlignView := alNone;
  ShowNow := False;
end;

procedure TfrmPDMP.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fPDMPData);
  inherited;
end;

function TfrmPDMP.CanCosign: Boolean;
var
  bCosignerRequired: Boolean;
  CosignerIEN, CosignerName: String;
begin
  // check if cosigner is needed and available
  bCosignerRequired := SystemParameters.AsType<string>
    (PDMP_PARAM_RequiredCosigner) = '1';

  if bCosignerRequired and (PDMPData.AuthorizedUserIEN = '') then
  begin
    CosignerIEN := pdmpSelectCosigner('', 0, FMNow);
    CosignerName := piece(CosignerIEN, U, 2); // IEN only
    CosignerIEN := piece(CosignerIEN, U, 1); // IEN only

    if CosignerIEN <> '-2' then
    begin
      PDMPData.AuthorizedUserIEN := CosignerIEN; // IntToStr(User.DUZ);
      PDMPData.AuthorizedUserName := CosignerName; // User.Name;
      Result := True;
    end
    else
    begin
      InfoBox('PDMP: Required cosigner is not selected', PDMP_MSG_TITLE,
        MB_OK + MB_ICONWARNING);
      Result := False;
    end;
  end
  else
    Result := True;
end;

procedure TfrmPDMP.doShowResults;
var
  iRC: Integer;
  sRC: string;
  bModal: Boolean;

begin
  iRC := 0;
  UseDefaultBrowser := PDMP_UseDefaultBrowser;

  if PDMPData <> nil then
  begin
    if PDMPData.pdmpStatus = UM_PDMP_Error then
    begin
      InfoBox('PDMP Error:' + #13#10#13#10 + PDMPData.LongMessage,
        PDMP_MSG_TITLE, MB_OK);
    end
    else
    begin
      if assigned(fRequester) then // Request came from ribbon bar
      begin                        // check if edited note is saved
        if CanReview <> IDYES then
          exit;
      end;

      try
        if CanCosign then
          try
            bModal := (fRequester <> nil); // Requestor is not nil when called from ribbon
            if bModal then
              PDMPData.NoteIEN := ''
            else
              PDMPData.NoteIEN := fNoteIEN; // note ien is not used in non modal cases

            sRC := showPDMP(PDMPData, bModal, AlignView, UseDefaultBrowser);
            iRC := StrToIntDef(piece(sRC, '^', 1), 0);
            if (0 < iRC) and assigned(Application.MainForm) then
              PostMessage(Application.MainForm.Handle, UM_PDMP_NOTE_ID, iRC, 0);
          except
            on E: Exception do
              InfoBox(E.Message, PDMP_MSG_TITLE, MB_OK + MB_ICONERROR);
          end;

      except
        on E: Exception do
          InfoBox(E.Message, PDMP_MSG_TITLE, MB_OK + MB_ICONERROR);
      end;
    end;
  end
  else
    InfoBox('PDMP: Unexpected error PROCESSING RESULTS', PDMP_MSG_TITLE,
      MB_OK + MB_ICONERROR);

  // reset manager only if review was successful or note creation failed
  if (iRC >= 0) or (iRC = -100) then
  begin
    acPDMPRequest.Hint := cRequestHintDefault;
    if assigned(PDMPData) then
      acPDMPRequest.Hint := acPDMPRequest.Hint + #13#10 +
        format(fmtLastReview, [pdmpLastReviewDate(PDMPData.PatIEN)]);
    doDone;
  end;
end;

procedure TfrmPDMP.doDone;
begin
  fPDMPData.pdmpClearData;

  if assigned(fPDMPData.pdmpTimer) then
    fPDMPData.pdmpTimer.Enabled := False; // stop checking for results

  Status := UM_PDMP_Done;

  if assigned(Application.MainForm) then
    SendMessage(Application.MainForm.Handle, UM_PDMP_Done, 0, 0);

  fRequester := nil; // reset to default
  fShowNow := False;
end;

procedure TfrmPDMP.updateBtnWidth(aBtn: TButton; aCaption: String = '');
var
  s: String;
begin
  if assigned(Application.MainForm) then
    if aBtn.Visible then
    begin
      s := aCaption;
      if s = '' then
        s := aBtn.Caption;
      Width := getMainFormTextWidth(s) + CAPTION_GAP * 3;
    end;
end;

procedure TfrmPDMP.updateFont;
begin
  if assigned(Application.MainForm) then
    self.font.Size := Application.MainForm.font.Size;
  TResponsiveGUI.ProcessMessages;
  updateBtnWidth(bbStart, 'Query');
  updateBtnWidth(bbCancel, 'Cancel');
  updateBtnWidth(bbResults, 'Results');
end;

procedure TfrmPDMP.updateChangeList;
begin
  // Notes are not used for registering the fact of disclosure
  if not assigned(fPDMPData) then
    exit;

  // if PDMP_Use_NOTE_FOR_ACCOUNTING_OF_DISCLOSURE  then
  // begin
  // if (StrToIntDef(fPDMPData.NoteIEN, -1) > 0) then
  // Changes.Add(10, fPDMPData.NoteIEN, fPDMPData.NoteHeader, '', 1);
  // end;
end;

procedure TfrmPDMP.setStatus(aStatus: Integer);

  function NeedToShowNow: Boolean;
  begin
    Result := fShowNow or
      (SystemParameters.AsType<string>('PDMP.backgroundRetrieval') <> '1');
  end;

begin
  fStatus := aStatus;

  if aStatus = 0 then
    fPDMPData.pdmpClearData;

  bbStart.Visible := (aStatus = 0) or (aStatus = UM_PDMP_Init) or
    (aStatus = UM_PDMP_Done);

  if bbStart.Visible then
    CachedData := False;

  bbCancel.Visible := aStatus = UM_PDMP_Loading;
  bbResults.Visible := aStatus = UM_PDMP_Ready;

  updateBtnWidth(bbStart, 'Query');
  updateBtnWidth(bbCancel, 'Cancel');
  updateBtnWidth(bbResults, 'Results');
  TResponsiveGUI.ProcessMessages;

  if (Status = UM_PDMP_Ready) then
    begin
      updateChangeList;
      Screen.Cursor := crDefault;
    end;

  if NeedToShowNow then
  begin
    if bbResults.Visible then
    begin
      Screen.Cursor := crDefault;
      doShowResults;
    end
    else
    begin
      if bbCancel.Visible then
        Screen.Cursor := crHourGlass;
    end;
  end;

  case Status of
    UM_PDMP_Done: Screen.Cursor := crDefault;
    UM_PDMP_Ready: PostMessage(Application.MainForm.Handle, UM_PDMP_READY, 0, 0);
  end;

end;

procedure TfrmPDMP.doCache(aPatient: String; aResult: TStrings = nil);
begin
  if aResult <> nil then
  begin
    PDMPData.StatusManager := self.Handle;
    PDMPData.PatIEN := aPatient;
    PDMPData.updatePDMP(aResult);
    PDMPData.SignOnUserIEN := IntToStr(User.DUZ);
    acPDMPRequest.Hint := cRequestHintDefault;
  end;
end;

function TfrmPDMP.getLastReviewDate(aPatientID: String): String;
begin
  Result := '';
  acPDMPRequest.Hint := cRequestHintDefault;
  if aPatientID <> '' then
  begin
    Result := pdmpLastReviewDate(aPatientID);
    if Result <> '' then
      acPDMPRequest.Hint := acPDMPRequest.Hint + #13#10 +
        format(fmtLastReview, [Result]);
  end;
end;

end.
