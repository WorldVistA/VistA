unit fODProc;
{------------------------------------------------------------------------------
Update History

    2016-02-25: NSR#20110606 (Similar Provider/Cosigner names)
-------------------------------------------------------------------------------}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fODBase, StdCtrls, ORCtrls, ExtCtrls, ComCtrls, ORfn, uConst, Buttons,
  Menus, ORDtTm, VA508AccessibilityManager;

type

  TfrmODProc = class(TfrmODBase)
    pnlMain: TPanel;
    pnlCombatVet: TPanel;
    lblProc: TLabel;
    lblService: TOROffsetLabel;
    lblReason: TLabel;
    lblUrgency: TStaticText;
    lblPlace: TStaticText;
    lblAttn: TStaticText;
    lblProvDiag: TStaticText;
    pnlReason: TPanel;
    memReason: TCaptionRichEdit;
    cboUrgency: TORComboBox;
    cboPlace: TORComboBox;
    cboAttn: TORComboBox;
    cboProc: TORComboBox;
    cboCategory: TORComboBox;
    cboService: TORComboBox;
    cmdLexSearch: TButton;
    gbInptOpt: TGroupBox;
    radInpatient: TRadioButton;
    radOutpatient: TRadioButton;
    txtProvDiag: TCaptionEdit;
    lblClinicallyIndicated: TStaticText;
    calClinicallyIndicated: TORDateBox;
    lblLatest: TStaticText;
    calLatest: TORDateBox;
    mnuPopProvDx: TPopupMenu;
    mnuPopProvDxDelete: TMenuItem;
    popReason: TPopupMenu;
    popReasonCut: TMenuItem;
    popReasonCopy: TMenuItem;
    popReasonPaste: TMenuItem;
    popReasonPaste2: TMenuItem;
    popReasonReformat: TMenuItem;
    txtCombatVet: TVA508StaticText;
    servicelbl508: TVA508StaticText;
    gpMain: TGridPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    Panel10: TPanel;
    procedure FormCreate(Sender: TObject);

    procedure cboAttnNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure cboProcNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure radInpatientClick(Sender: TObject);
    procedure radOutpatientClick(Sender: TObject);
    procedure ControlChange(Sender: TObject);
    procedure cboProcSelect(Sender: TObject);
    procedure memReasonExit(Sender: TObject);
    procedure cmdLexSearchClick(Sender: TObject);
    procedure cboServiceChange(Sender: TObject);
    procedure mnuPopProvDxDeleteClick(Sender: TObject);
    procedure txtProvDiagChange(Sender: TObject);
    procedure popReasonCutClick(Sender: TObject);
    procedure popReasonCopyClick(Sender: TObject);
    procedure popReasonPasteClick(Sender: TObject);
    procedure popReasonPopup(Sender: TObject);
    procedure popReasonReformatClick(Sender: TObject);
    procedure memReasonKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure memReasonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure memReasonKeyPress(Sender: TObject; var Key: Char);
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure cboAttnChange(Sender: TObject);
  private
    FLastProcID: string;
    FEditCtrl: TCustomEdit;
    FNavigatingTab: boolean;
    procedure ReadServerVariables;
    procedure SetProvDiagPromptingMode;
    procedure SetupReasonForRequest(OrderAction: integer);
    procedure GetProvDxandValidateCode(AResponses: TResponses);
    function ShowPrerequisites: boolean;
    procedure DoSetFontSize(FontSize: Integer; FromCreate: Boolean = False);
      reintroduce;
    procedure SetUpCombatVet(Eligable:Boolean);  // RTC#722078
    procedure updateService;
    procedure setup508Label(text: string; lbl: TVA508StaticText; ctrl: TControl);
  protected
    procedure ShowOrderMessage(Show: boolean); override;
    procedure InitDialog; override;
    procedure Validate(var AnErrMsg: string); override;
//    function  DefaultReasonForRequest(Service: string; Resolve: Boolean): TStrings;
    function  DefaultReasonForRequest(aDest: TSTrings;Service: string; Resolve: boolean):Integer;
  public
    procedure SetupDialog(OrderAction: Integer; const ID: string); override;
    procedure SetFontSize( FontSize: integer); override;
  end;


function CanFreeProcDialog(dialog : TfrmODBase) : boolean;

implementation

{$R *.DFM}

uses
    rODBase, rConsults, uCore, uConsults, rCore, fConsults, fPCELex, rPCE, ORClasses,
    clipbrd, fPreReq, uTemplates, fFrame, uODBase, VA508AccessibilityRouter,
    uVA508CPRSCompatibility, uORLists, uSimilarNames, uFormUtils, VAUtils;


var
  ProvDx:  TProvisionalDiagnosis;
  GMRCREAF: string;
  OkToFreeProcDialog: boolean;

const
  TX_NO_PROC         = 'A procedure must be specified.'    ;
  TX_NO_REASON       = 'A reason for this procedure must be entered.'  ;
  TX_NO_SERVICE      = 'A service must be selected to perform this procedure.';
  TX_NO_URGENCY      = 'An urgency must be specified.';
  TX_NO_PLACE        = 'A place of consultation must be specified';
  TX_NO_DIAG         = 'A provisional diagnosis must be entered for consults to this service.';
  TX_SELECT_DIAG     = 'You must use the "Lexicon" button to select a diagnosis for consults to this service.';
  TC_INACTIVE_CODE   = 'Inactive ICD Code';
  TX_INACTIVE_CODE1  = 'The provisional diagnosis code is not active as of today''s date.' + #13#10;
  TX_INACTIVE_CODE_REQD     = 'Another code must be selected before the order can be saved.';
  TX_INACTIVE_CODE_OPTIONAL = 'If another code is not selected, no code will be saved.';
  TX_PAST_DATE       = 'Clinically indicated date must be today or later.';

{ ********* Static Unit Methods ************ }

function CanFreeProcDialog(dialog : TfrmODBase) : boolean;
begin
  Result := true;
  if (dialog is TfrmODProc) then
    Result := OkToFreeProcDialog;
end;

{ ********************* TfrmODProc Methods **************** }

procedure TfrmODProc.FormCreate(Sender: TObject);
var
  sl: TStrings;

begin
  frmFrame.pnlVisit.Enabled := false;
  AutoSizeDisabled := true;
  inherited;
  OkToFreeProcDialog := false;
  DoSetFontSize(MainFontSize, True);
  AllowQuickOrder := true;
  FillChar(ProvDx, SizeOf(ProvDx), 0);
  FillerID := 'GMRC'; // does 'on Display' order check **KCM**
  StatusText('Loading Dialog Definition');
  Responses.dialog := 'GMRCOR REQUEST'; // loads formatting info
  StatusText('Loading Default Values');
  sl := TStringList.Create;
  try
    setODForProcedures(sl);
    CtrlInits.LoadDefaults(sl);
    // ODForProcedures returns TStrings with defaults
  finally
    sl.Free;
  end;
  StatusText('Initializing Long List');
  ReadServerVariables;
  cboProc.InitLongList('') ;
  cboAttn.InitLongList('') ;
  PreserveControl(calClinicallyIndicated);
  PreserveControl(cboAttn);
  PreserveControl(cboProc);

  SetUpCombatVet(patient.CombatVet.IsEligible);  // RTC#722078
  InitDialog;

  cmdQuit.Top := ClientHeight - cmdQuit.Height - Font.Size + 8;
  cmdAccept.Top := cmdQuit.Top - cmdAccept.Height - Font.Size + 8;
end;

procedure TfrmODProc.InitDialog;
begin
  inherited;
  Changing := True;
  FLastProcID := '';
  with CtrlInits do
  begin
   SetControl(cboProc, 'ShortList');
   cboProc.InsertSeparator;
   if OrderForInpatient then
    begin
      radInpatient.Checked := True;                   //INPATIENT PROCEDURE
      cboCategory.Items.Clear;
      cboCategory.Items.Add('I^Inpatient');
      cboCategory.SelectById('I');
      SetControl(cboPlace, 'Inpt Place');
      SetControl(cboUrgency, 'Inpt Proc Urgencies');      //S.GMRCR
      SetControl(calClinicallyIndicated, 'Clin Ind Date');
    end
   else
    begin
      radOutpatient.Checked := True;                 //OUTPATIENT PROCEDURE
      cboCategory.Items.Clear;
      cboCategory.Items.Add('O^Outpatient');
      cboCategory.SelectById('O');
      SetControl(cboPlace, 'Outpt Place');
      SetControl(cboUrgency, 'Outpt Urgencies');     //S.GMRCO
      SetControl(calClinicallyIndicated, 'Clin Ind Date');
    end ;
  end ;
  cboAttn.ItemIndex := -1;
  TSimilarNames.RegORComboBox(cboAttn);
  memOrder.Clear ;
  memReason.Clear;
  cboProc.Enabled := True;
  cboProc.Font.Color := clWindowText;
  //cboService.Enabled := True;
  //cboService.Font.Color := clWindowText;
  ActiveControl := cboProc;
  SetProvDiagPromptingMode;
  if not ShowPrerequisites then
    begin
      Close;
      Exit;
    end;
  if calClinicallyIndicated.Text = 'T' then calClinicallyIndicated.Text := 'TODAY';
  StatusText('');
  Changing := False;
end;

procedure TfrmODProc.SetupDialog(OrderAction: Integer; const ID: string);
var
  tmpResp: TResponse;
begin
  inherited;
  ReadServerVariables;
  if OrderAction in [ORDER_COPY, ORDER_EDIT, ORDER_QUICK] then with Responses do        {*KCM*}
  begin
    SetControl(cboProc,       'ORDERABLE', 1);
    if cboProc.ItemIndex < 0 then exit;
    setProcedureServices(cboService.Items,cboProc.ItemIEN);
    Changing := True;
    tmpResp := TResponse(FindResponseByName('CLASS',1));
    cboCategory.SelectByID(tmpResp.IValue);
    if tmpResp.IValue = 'I' then
      radInpatient.Checked := True
    else
      radOutpatient.Checked := True ;
    SetControl(cboUrgency,    'URGENCY',     1);
    SetControl(cboPlace,      'PLACE',     1);
    SetControl(cboAttn,       'PROVIDER',  1);
    TSimilarNames.RegORComboBox(cboAttn);
    SetControl(calClinicallyIndicated,   'CLINICALLY',  1);
    cboProc.Enabled := False;
    cboProc.Font.Color := clGrayText;
   //SetControl(cboService,    'SERVICE',   1);     // to fix OR*3.0*95 bug in v17.6  (RV)
    tmpResp := TResponse(FindResponseByName('SERVICE',1));
    if tmpResp <> nil then
      cboService.SelectByID(Piece(tmpResp.IValue, U, 1))
    else if (cboService.Items.Count = 1) then
      cboService.ItemIndex := 0
    else if (cboService.Items.Count > 1) then
      cboService.ItemIndex := -1 ;
    if cboService.ItemIndex > -1 then
      begin
        cboService.Enabled := False;
        cboService.Font.Color := clGrayText;
      end
    else
      begin
        cboService.Enabled := True;
        cboService.Font.Color := clWindowText;
      end;
    if (OrderAction in [ORDER_COPY, ORDER_QUICK]) and (not ShowPrerequisites) then
      begin
        Close;
        Exit;
      end;
    SetProvDiagPromptingMode;
    GetProvDxandValidateCode(Responses);
    SetTemplateDialogCanceled(FALSE);
    SetControl(memReason,     'COMMENT',   1);
    if WasTemplateDialogCanceled then
    begin
      AbortOrder := True;
      OkToFreeProcDialog := true;
      SetTemplateDialogCanceled(FALSE);
      Close;
      Exit;
    end;
    SetTemplateDialogCanceled(FALSE);
    SetupReasonForRequest(OrderAction);
    if WasTemplateDialogCanceled then
    begin
      AbortOrder := True;
      OkToFreeProcDialog := true;
      SetTemplateDialogCanceled(FALSE);
      Close;
      Exit;
    end;
    Changing := False;
    OrderMessage(ConsultMessage(cboProc.ItemIEN));
    ControlChange(Self);
  end;
end;

procedure TfrmODProc.Validate(var AnErrMsg: string);

  procedure SetError(const x: string);
  begin
    if Length(AnErrMsg) > 0 then AnErrMsg := AnErrMsg + CRLF;
    AnErrMsg := AnErrMsg + x;
  end;
var
  ErrMsg: String;
begin
  inherited;
  if cboProc.ItemIEN = 0                  then SetError(TX_NO_PROC);
  if cboUrgency.ItemIEN = 0               then SetError(TX_NO_URGENCY);
  if cboPlace.ItemID = ''                 then SetError(TX_NO_PLACE);
  if (not ContainsVisibleChar(memReason.Text))
                                          then SetError(TX_NO_REASON);
  if cboService.ItemIEN = 0               then SetError(TX_NO_SERVICE);
  if (ProvDx.Reqd = 'R') and (Length(txtProvDiag.Text) = 0) then
    begin
      if ProvDx.PromptMode = 'F' then
        SetError(TX_NO_DIAG)
      else
        SetError(TX_SELECT_DIAG);
    end;
  if calClinicallyIndicated.FMDateTime < FMToday then SetError(TX_PAST_DATE);


  if not CheckForSimilarName(cboAttn, ErrMsg, sPr) then
  begin
     if ErrMsg <> '' then
      SetError(ErrMsg);
  end;

  AnErrMsg := Trim(AnErrMsg);
end;

procedure TfrmODProc.cboAttnChange(Sender: TObject);
var
  x: string;
  i: integer;
begin
  if cboProc.ItemIEN = 0 then Exit;

  with cboProc do
    begin
      if ItemIEN > 0 then
        begin
          i := Pos('<', Text);
          if i > 0 then
            begin
              x := Piece(Copy(Text, i + 1, 99), '>', 1);
              x := UpperCase(Copy(x, 1, 1)) + Copy(x, 2, 99);
            end
          else
            x := Text;
          Responses.Update('ORDERABLE', 1, ItemID, x);
        end
      else Responses.Update('ORDERABLE', 1, '', '');
    end;
  updateService();
  with memReason     do if GetTextLen   > 0 then Responses.Update('COMMENT',   1, TX_WPTYPE, Text);
  with cboCategory   do if ItemID     <> '' then Responses.Update('CLASS',     1, ItemID, Text);
  with cboUrgency    do if ItemIEN      > 0 then Responses.Update('URGENCY',   1, ItemID, Text);
  with cboPlace      do if ItemID     <> '' then Responses.Update('PLACE',     1, ItemID, Text);
  with cboAttn       do if ItemIEN      > 0 then Responses.Update('PROVIDER',  1, ItemID, Text);
  with calClinicallyIndicated   do if Length(Text) > 0 then Responses.Update('CLINICALLY',  1, Text, Text);
  if Length(ProvDx.Text)                > 0 then Responses.Update('MISC',      1, ProvDx.Text,   ProvDx.Text)
   else Responses.Update('MISC',      1, '',   '');
  if Length(ProvDx.Code)                > 0 then Responses.Update('CODE',      1, ProvDx.Code,   ProvDx.Code)
   else Responses.Update('CODE',      1, '',   '');

  memOrder.Text := Responses.OrderText;
end;


procedure TfrmODProc.cboAttnNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
begin
  inherited;
  setPersonList(cboAttn, StartFrom, Direction);
end;

procedure TfrmODProc.cboProcNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
begin
  inherited;
  setProcedureList(cboProc,StartFrom, Direction);
end;

procedure TfrmODProc.radInpatientClick(Sender: TObject);
begin
  inherited;
  with CtrlInits do
  begin
    SetControl(cboPlace, 'Inpt Place');
    SetControl(cboUrgency, 'Inpt Proc Urgencies');
    cboCategory.Items.Clear;
    cboCategory.Items.Add('I^Inpatient') ;
    cboCategory.SelectById('I');
  end ;
  ControlChange(Self);
end;

procedure TfrmODProc.radOutpatientClick(Sender: TObject);
begin
  inherited;
  with CtrlInits do
  begin
    SetControl(cboPlace, 'Outpt Place');
    SetControl(cboUrgency, 'Outpt Urgencies');
    cboCategory.Items.Clear;
    cboCategory.Items.Add('O^Outpatient');
    cboCategory.SelectById('O');
  end ;
  ControlChange(Self);
end;

procedure TfrmODProc.ControlChange(Sender: TObject);
var
  x: string;
  i: integer;
begin
  inherited;
  if Changing or (cboProc.ItemIEN = 0) then Exit;
  with cboProc do
    begin
      if ItemIEN > 0 then
        begin
          i := Pos('<', Text);
          if i > 0 then
            begin
              x := Piece(Copy(Text, i + 1, 99), '>', 1);
              x := UpperCase(Copy(x, 1, 1)) + Copy(x, 2, 99);
            end
          else
            x := Text;
          Responses.Update('ORDERABLE', 1, ItemID, x);
        end
      else Responses.Update('ORDERABLE', 1, '', '');
    end;
  updateService();
  with memReason     do if GetTextLen   > 0 then Responses.Update('COMMENT',   1, TX_WPTYPE, Text);
  with cboCategory   do if ItemID     <> '' then Responses.Update('CLASS',     1, ItemID, Text);
  with cboUrgency    do if ItemIEN      > 0 then Responses.Update('URGENCY',   1, ItemID, Text);
  with cboPlace      do if ItemID     <> '' then Responses.Update('PLACE',     1, ItemID, Text);
  with cboAttn       do if ItemIEN      > 0 then Responses.Update('PROVIDER',  1, ItemID, Text);
  with calClinicallyIndicated   do if Length(Text) > 0 then Responses.Update('CLINICALLY',  1, Text, Text);
  if Length(ProvDx.Text)                > 0 then Responses.Update('MISC',      1, ProvDx.Text,   ProvDx.Text)
   else Responses.Update('MISC',      1, '',   '');
  if Length(ProvDx.Code)                > 0 then Responses.Update('CODE',      1, ProvDx.Code,   ProvDx.Code)
   else Responses.Update('CODE',      1, '',   '');

  memOrder.Text := Responses.OrderText;
end;

procedure TfrmODProc.cboProcSelect(Sender: TObject);
begin
  inherited;
  with cboProc do
   begin
    if ItemIndex = -1 then Exit;
    if ItemID <> FLastProcID then FLastProcID := ItemID else Exit;
    Changing := True;
    if Sender <> Self then Responses.Clear;       // Sender=Self when called from SetupDialog
    Changing := False;
    if CharAt(ItemID, 1) = 'Q' then
     begin
      Responses.QuickOrder := ExtractInteger(ItemID);
      Responses.SetControl(cboProc, 'ORDERABLE', 1);
      FLastProcID := ItemID;
     end;
    with cboService do
      begin
        Clear;
        setProcedureServices(cboService.Items,cboProc.ItemIEN);
        if Items.Count > 1 then
          ItemIndex := -1
        else if Items.Count = 1 then
          begin
            ItemIndex := 0 ;
            Responses.Update('SERVICE', 1, ItemID, Text);
          end
        else
          begin
            if Sender = Self then    // Sender=Self when called from SetupDialog
              InfoBox('There are no services defined for this procedure.',
              'Information', MB_OK or MB_ICONINFORMATION);
            cboProc.ItemIndex := -1;
            InitDialog;
            Exit ;
          end;
      end;
   end;
  with Responses do if QuickOrder > 0 then
    begin
      SetControl(cboProc,       'ORDERABLE', 1);
      Changing := True;
      with cboService do
        begin
          setProcedureServices(cboService.Items,cboProc.ItemIEN);
          if Items.Count > 1 then
            ItemIndex := -1
          else if Items.Count = 1 then
            ItemIndex := 0 ;
        end;
      if not ShowPrerequisites then
        begin
          Close;
          Exit;
        end;
      SetControl(cboCategory,   'CLASS',      1);
      if cboCategory.ItemID = 'I' then radInpatient.Checked := True
      else radOutpatient.Checked := True ;
      SetControl(cboUrgency,    'URGENCY',     1);
      SetControl(cboPlace,      'PLACE',     1);
      SetControl(cboAttn,       'PROVIDER',  1);
      TSimilarNames.RegORComboBox(cboAttn);
      SetControl(calClinicallyIndicated,   'CLINICALLY',  1);
      SetTemplateDialogCanceled(FALSE);
      SetControl(memReason,     'COMMENT',   1);
      if WasTemplateDialogCanceled and OrderContainsObjects then
      begin
        AbortOrder := TRUE;
        Close;
        Exit;
      end;
      SetupReasonForRequest(ORDER_QUICK);
      GetProvDxandValidateCode(Responses);
      SetControl(cboService,    'SERVICE',   1);
      cboProc.Enabled := False;
      cboProc.Font.Color := clGrayText;
      if cboService.ItemIndex > -1 then
        begin
          cboService.Enabled := False;
          cboService.Font.Color := clGrayText;
        end
      else
        begin
          cboService.Enabled := True;
          cboService.Font.Color := clWindowText;
        end;
      Changing := False;
    end
  else
    begin
      if cboProc.ItemIEN > 0 then
        begin
          if cboService.ItemIndex > -1 then
            begin
              cboService.Enabled := False;
              cboService.Font.Color := clGrayText;
            end
          else
            begin
              cboService.Enabled := True;
              cboService.Font.Color := clWindowText;
            end;
          if not ShowPrerequisites then
            begin
              Close;
              Exit;
            end;
          DefaultReasonForRequest(memReason.Lines, Piece(cboProc.Items[cboProc.ItemIndex], U, 4), True);
          SetupReasonForRequest(ORDER_NEW);
        end;
    end;
  SetProvDiagPromptingMode;
  OrderMessage(ConsultMessage(cboProc.ItemIEN));
  ControlChange(Self) ;
end;

procedure TfrmODProc.memReasonExit(Sender: TObject);
var
  AStringList: TStringList;
begin
  inherited;
  AStringList := TStringList.Create;
  try
    AStringList.Text := memReason.Text;
    LimitStringLength(AStringList, 74);
    memReason.Text := AStringList.Text;
    ControlChange(Self);
  finally
    AStringList.Free;
  end;
end;

procedure  TfrmODProc.ReadServerVariables;
begin
  if StrToIntDef(KeyVariable['GMRCNOAT'], 0) > 0 then
    begin
      cboAttn.Enabled    := False;
      cboAttn.Font.Color := clGrayText;
      lblAttn.Enabled    := False;
      cboAttn.Color      := clBtnFace;
    end
  else
    begin
      cboAttn.Enabled    := True;
      cboAttn.Font.Color := clWindowText;
      lblAttn.Enabled    := True;
      cboAttn.Color      := clWindow;
    end;

  if StrToIntDef(KeyVariable['GMRCNOPD'], 0) > 0 then
    begin
      cmdLexSearch.Enabled   := False;
      txtProvDiag.Enabled    := False;
      txtProvDiag.Font.Color := clGrayText;
      lblProvDiag.Enabled    := False;
      txtProvDiag.ReadOnly   := True;
      txtProvDiag.Color      := clBtnFace;
    end
  else SetProvDiagPromptingMode;

  GMRCREAF := KeyVariable['GMRCREAF'];
end;

procedure TfrmODProc.cmdLexSearchClick(Sender: TObject);
var
  Match: string;
  i: integer;
  EncounterDate: TFMDateTime;
begin
  inherited;
  if (Encounter.VisitCategory = 'A') or (Encounter.VisitCategory = 'I') then
    EncounterDate := Encounter.DateTime
  else
    EncounterDate := FMNow;

  LexiconLookup(Match, LX_ICD, EncounterDate);
  if Match = '' then Exit;
  ProvDx.Code := Piece(Piece(Match, U, 1),'/',1);
  ProvDx.Text := Piece(Match, U, 2);
  i := Pos(' (ICD', ProvDx.Text);
  if i = 0 then i := Length(ProvDx.Text) + 1;
  if ProvDx.Text[i-1] = '*' then i := i - 2;
  ProvDx.Text := Copy(ProvDx.Text, 1, i - 1);
  txtProvDiag.Text := ProvDx.Text + ' (' + ProvDx.Code + ')';
  ProvDx.CodeInactive := False;
end;

procedure TfrmODProc.SetProvDiagPromptingMode;
const
  TX_USE_LEXICON = 'You must use the "Lexicon" button to select a provisional diagnosis for this service.';
  TX_PROVDX_OPT  = 'Provisional Diagnosis';
  TX_PROVDX_REQD = 'Provisional Dx (REQUIRED)';
begin
  cmdLexSearch.Enabled   := False;
  txtProvDiag.Enabled    := False;
  txtProvDiag.ReadOnly   := True;
  txtProvDiag.Color      := clBtnFace;
  txtProvDiag.Font.Color := clBtnText;
  lblProvDiag.Enabled    := False;
  txtProvDiag.Hint       := '';
  if cboProc.ItemIEN = 0 then Exit;
  ProvDx.PreviousPromptMode := ProvDx.PromptMode;
  //GetProvDxMode(ProvDx, cboService.ItemID);
  GetProvDxMode(ProvDx, Piece(cboProc.Items[cboProc.ItemIndex], U, 4));
  //  Returns:  string  A^B
  //     A = O (optional), R (required) or S (suppress)
  //     B = F (free-text) or L (lexicon)
  if (ProvDx.PreviousPromptMode <> '') and (ProvDx.PromptMode <> ProvDx.PreviousPromptMode) then
    begin
      ProvDx.Code := '';
      ControlChange(Self);
    end;
  with ProvDx do if (Reqd = '') or (PromptMode = '') then Exit;
  if ProvDx.Reqd = 'R' then
    lblProvDiag.Caption := TX_PROVDX_REQD
  else
    lblProvDiag.Caption := TX_PROVDX_OPT;
  if ProvDx.Reqd = 'S' then
    begin
      cmdLexSearch.Enabled   := False;
      txtProvDiag.Enabled    := False;
      txtProvDiag.ReadOnly   := True;
      txtProvDiag.Color      := clBtnFace;
      txtProvDiag.Font.Color := clBtnText;
      lblProvDiag.Enabled    := False;
    end
  else
    case ProvDx.PromptMode[1] of
      'F':  begin
              cmdLexSearch.Enabled   := False;
              txtProvDiag.Enabled    := True;
              txtProvDiag.ReadOnly   := False;
              txtProvDiag.Color      := clWindow;
              txtProvDiag.Font.Color := clWindowText;
              lblProvDiag.Enabled    := True;
            end;
      'L':  begin
              cmdLexSearch.Enabled   := True;
              txtProvDiag.Enabled    := True;
              txtProvDiag.ReadOnly   := True;
              txtProvDiag.Color      := clInfoBk;
              txtProvDiag.Font.Color := clInfoText;
              lblProvDiag.Enabled    := True;
              txtProvDiag.Hint       := TX_USE_LEXICON;
            end;
    end;
end;

procedure TfrmODProc.setup508Label(text: string; lbl: TVA508StaticText; ctrl: TControl);
begin
  if ScreenReaderSystemActive and not ctrl.Enabled then begin
    lbl.Enabled := True;
    lbl.Visible := True;
    lbl.Caption := lblService.Caption + ', ' + Text;
    lbl.Width := (ctrl.Left + ctrl.Width) - lbl.Left;
  end else
    lbl.Visible := false;
end;

procedure TfrmODProc.cboServiceChange(Sender: TObject);
begin
  inherited;
  //SetProvDiagPromptingMode;
  ControlChange(Self);
end;

procedure TfrmODProc.mnuPopProvDxDeleteClick(Sender: TObject);
begin
  inherited;
  ProvDx.Text := '';
  ProvDx.Code := '';
  txtProvDiag.Text := '';
  ControlChange(Self);
end;

procedure TfrmODProc.txtProvDiagChange(Sender: TObject);
begin
  inherited;
  if ProvDx.PromptMode = 'F' then
    ProvDx.Text := txtProvDiag.Text;
  ControlChange(Self);
end;

procedure TfrmODProc.popReasonPopup(Sender: TObject);
begin
  inherited;
  if PopupComponent(Sender, popReason) is TCustomEdit
    then FEditCtrl := TCustomEdit(PopupComponent(Sender, popReason))
    else FEditCtrl := nil;
  if FEditCtrl <> nil then
  begin
    popReasonCut.Enabled      := FEditCtrl.SelLength > 0;
    popReasonCopy.Enabled     := popReasonCut.Enabled;
    popReasonPaste.Enabled    := (not TORExposedCustomEdit(FEditCtrl).ReadOnly) and
                                   Clipboard.HasFormat(CF_TEXT);
  end else
  begin
    popReasonCut.Enabled      := False;
    popReasonCopy.Enabled     := False;
    popReasonPaste.Enabled    := False;
  end;
  popReasonReformat.Enabled := True;
end;

procedure TfrmODProc.popReasonCutClick(Sender: TObject);
begin
  inherited;
  FEditCtrl.CutToClipboard;
end;

procedure TfrmODProc.popReasonCopyClick(Sender: TObject);
begin
  inherited;
  FEditCtrl.CopyToClipboard;
end;

procedure TfrmODProc.popReasonPasteClick(Sender: TObject);
begin
  inherited;
  FEditCtrl.SelText := Clipboard.AsText;
end;

procedure TfrmODProc.popReasonReformatClick(Sender: TObject);
begin
  inherited;
  if Screen.ActiveControl <> memReason then Exit;
  ReformatMemoParagraph(memReason);
end;

procedure TfrmODProc.SetupReasonForRequest(OrderAction: integer);
var
  EditReason: string;

  procedure EnableReason;
  begin
    memReason.Color := clWindow;
    memReason.Font.Color := clWindowText;
    memReason.ReadOnly := False;
    lblReason.Caption := 'Reason for Request';
  end;

  procedure DisableReason;
  begin
    memReason.Color := clInfoBk;
    memReason.Font.Color := clInfoText;
    memReason.ReadOnly := True;
    lblReason.Caption := 'Reason for Request  (not editable)';
  end;

begin
  if ((OrderAction = ORDER_QUICK) and (cboProc.ItemID <> '') and (Length(memReason.Text) = 0)) then
    DefaultReasonForRequest(memReason.Lines, Piece(cboProc.Items[cboProc.ItemIndex], U, 4), True);
  EditReason := GMRCREAF;
  if EditReason = '' then EditReason := ReasonForRequestEditable(Piece(cboProc.Items[cboProc.ItemIndex], U, 4));
  case EditReason[1] of
    '0':  EnableReason;
    '1':  if OrderAction in [ORDER_COPY, ORDER_EDIT] then
            EnableReason
          else
            DisableReason;
    '2':  DisableReason
  else
    EnableReason;
  end;
end;

procedure TfrmODProc.ShowOrderMessage(Show: boolean);
var
  update: boolean;

begin
  update := (pnlMessage.Visible <> Show);
  inherited;
  if Update then
  begin
    pnlMessage.Top := ClientHeight;
    Realign;
  end;
  FormResize(Self);
end;

function TfrmODProc.ShowPrerequisites: boolean;
var
  AList: TStringList;
const
  TC_PREREQUISITES = 'Procedure Prerequisites - ';
begin
  Result := True;
  AbortOrder := False;
  AList := TStringList.Create;
  try
    with cboProc do
      if ItemIEN > 0 then
        begin
          setServicePrerequisites(aList, Piece(Items[ItemIndex], U, 4));
          if AList.Count > 0 then
            begin
              if not DisplayPrerequisites(AList, TC_PREREQUISITES + DisplayText[ItemIndex]) then
                begin
                  memOrder.Clear;
                  Result := False;
                  AbortOrder := True;
                  //cmdQuitClick(Self);
                end
              else Result := True;
            end;
        end;
  finally
    AList.Free;
  end;
end;

function TfrmODProc.DefaultReasonForRequest(aDest: TSTrings;Service: string; Resolve: boolean)
  : Integer;
var
  TmpSL: TStringList;
  DocInfo: string;
  x: string;
  HasObjects: boolean;
begin
  Assert(aDest <> nil);
  Resolve := false; // override value passed in - resolve on client - PSI-05-093
  DocInfo := '';
  TmpSL := TStringList.Create;
  try
    setDefaultReasonForRequest(aDest, Piece(cboProc.Items[cboProc.ItemIndex], U, 4), Resolve);
    TmpSL.text := aDest.text;
    x := TmpSL.text;
    ExpandOrderObjects(x, HasObjects);
    TmpSL.text := x;
    Responses.OrderContainsObjects := HasObjects;
    ExecuteTemplateOrBoilerPlate(TmpSL,
      StrToIntDef(Piece(Piece(cboProc.Items[cboProc.ItemIndex], U, 4), ';', 1),
      0), ltProcedure, nil, 'Reason for Request: ' + cboProc.DisplayText
      [cboProc.ItemIndex], DocInfo);
    AbortOrder := WasTemplateDialogCanceled;
    Responses.OrderContainsObjects := HasObjects or TemplateBPHasObjects;
    if AbortOrder then
    begin
      aDest.Clear;
      Close;
    end
    else
    begin
      aDest.Assign(TmpSL);
      if aDest.Count > 0 then
        SpeakTextInserted;
    end;
  finally
    TmpSL.Free;
  end;
  Result := aDest.Count;
end;

procedure TfrmODProc.memReasonKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if FNavigatingTab then
  begin
    if ssShift in Shift then
      FindNextControl(Sender as TWinControl, False, True, False).SetFocus //previous control
    else if ssCtrl	in Shift then
      FindNextControl(Sender as TWinControl, True, True, False).SetFocus; //next control
    FNavigatingTab := False;
  end;
  if (key = VK_ESCAPE) then begin
    FindNextControl(Sender as TWinControl, False, True, False).SetFocus; //previous control
    Key := 0;
  end;
end;

procedure TfrmODProc.GetProvDxandValidateCode(AResponses: TResponses);
var
  tmpDx: TResponse;
begin
  with AResponses do
    begin
      tmpDx := TResponse(FindResponseByName('MISC',1));
      if tmpDx <> nil then ProvDx.Text := tmpDx.Evalue;
      tmpDx := TResponse(FindResponseByName('CODE',1));
      if (tmpDx <> nil) and (tmpDx.EValue <> '') then
      begin
        if IsActiveICDCode(tmpDx.EValue) then
          ProvDx.Code := tmpDx.Evalue
        else
          begin
            if ProvDx.Reqd = 'R' then
              InfoBox(TX_INACTIVE_CODE1 + TX_INACTIVE_CODE_REQD, TC_INACTIVE_CODE, MB_ICONWARNING or MB_OK)
            else
              InfoBox(TX_INACTIVE_CODE1 + TX_INACTIVE_CODE_OPTIONAL, TC_INACTIVE_CODE, MB_ICONWARNING or MB_OK);
            ProvDx.Code := '';
            ProvDx.Text := '';
          end;
      end;
      txtProvDiag.Text := ProvDx.Text;
      if ProvDx.Code <> '' then txtProvDiag.Text :=  txtProvDiag.Text + ' (' + ProvDx.Code + ')';
    end;
end;

procedure TfrmODProc.SetFontSize(FontSize: integer);
begin
  inherited;
  DoSetFontSize(FontSize);
end;

procedure TfrmODProc.updateService;
begin
  with cboService do
    if ItemIEN > 0 then
    begin
      setup508Label(Text, servicelbl508, cboService);
      Responses.Update('SERVICE', 1, ItemID, Text);
    end
    else begin
      Responses.Update('SERVICE', 1, '', '');
      setup508Label('No service selected.', servicelbl508, cboService);
    end;
end;

procedure TfrmODProc.DoSetFontSize(FontSize: Integer;
  FromCreate: boolean = False);
var
  x, y: integer;
begin
  memReason.Width := pnlReason.ClientWidth;
  memReason.Height := pnlReason.ClientHeight;// - memReason.Height;  MAC-0104-61043 - RV
  x := (memOrder.Height div 2) - Font.Size + 2;
  cmdQuit.Height := x;
  cmdAccept.Height := x;
  x := memOrder.Height + memOrder.Margins.Top + memOrder.Margins.Bottom;
  y := ClientHeight - x;
  x := (x - cmdQuit.Height - cmdAccept.Height) div 3;
  cmdAccept.Top := y + x;
  cmdQuit.Top := ClientHeight - memOrder.Margins.Bottom - cmdQuit.Height - x;
  x := (memOrder.Left + memOrder.Width + 6) - cmdAccept.left;
  if x > 0 then
  begin
    inc(x, memOrder.Margins.Right);
    memOrder.Margins.Right := x;
    pnlMessage.Margins.Right := x;
  end
  else
  begin
    x := -x;
    if x > (ClientWidth - (cmdAccept.Left + cmdAccept.Width))  then
    begin
      Width := Width - x;
      x := memOrder.Margins.Right - x;
      memOrder.Margins.Right := x;
      pnlMessage.Margins.Right := x;
    end;
  end;
  FormResize(Self);
end;

procedure TfrmODProc.memReasonKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  //The navigating tab controls were inadvertantently adding tab characters
  //This should fix it
  FNavigatingTab := (Key = VK_TAB) and ([ssShift,ssCtrl] * Shift <> []);
  if FNavigatingTab then
    Key := 0;
end;

procedure TfrmODProc.memReasonKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if FNavigatingTab then
    Key := #0;  //Disable shift-tab processing
end;

procedure TfrmODProc.FormResize(Sender: TObject);
const
  LEFT_MARGIN = 4;
begin
  inherited;
  LimitEditWidth(memReason, MAX_PROGRESSNOTE_WIDTH-7); //puts memReason at 74 characters
  Self.Constraints.MinWidth := TextWidthByFont(memReason.Font.Handle,
    StringOfChar('X', MAX_PROGRESSNOTE_WIDTH)) + (LEFT_MARGIN * 10) + ScrollBarWidth;
  Self.Constraints.MinHeight := Height - ClientHeight + CombineHeights([memOrder,
    pnlMessage, pnlCombatVet, memReason, lblReason, gpMain]);
end;

procedure TfrmODProc.FormShow(Sender: TObject);
begin
  inherited;
  setup508Label('No service selected.', servicelbl508, cboService);
end;

procedure TfrmODProc.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  frmFrame.pnlVisit.Enabled := true;
end;

procedure TfrmODProc.SetUpCombatVet(Eligable:Boolean);  // RTC#722078
begin
  pnlCombatVet.Visible := Eligable;
  txtCombatVet.Enabled := Eligable;
  if Eligable then
    begin
      txtCombatVet.Caption := 'Combat Veteran Eligibility Expires on ' + patient.CombatVet.ExpirationDate;
      ActiveControl := txtCombatVet;
    end;
end;

end.
