unit fEditProc;

interface

uses
  ORExtensions,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ORCtrls, ExtCtrls, ComCtrls, ORfn, uConst, uConsults, Buttons,
  Menus, fAutoSz, ORDtTm, VA508AccessibilityManager, fBase508Form;

type
  TfrmEditProc = class(TfrmAutoSz)
    cmdAccept: TButton;
    cmdQuit: TButton;
    pnlMessage: TPanel;
    imgMessage: TImage;
    memMessage: ORExtensions.TRichEdit;
    pnlMain: TPanel;
    lblProc: TLabel;
    lblReason: TLabel;
    lblService: TOROffsetLabel;
    lblComment: TLabel;
    lblComments: TLabel;
    lblUrgency: TStaticText;
    lblPlace: TStaticText;
    lblAttn: TStaticText;
    lblProvDiag: TStaticText;
    lblInpOutp: TStaticText;
    memReason: ORExtensions.TRichEdit;
    cboUrgency: TORComboBox;
    radInpatient: TRadioButton;
    radOutpatient: TRadioButton;
    cboPlace: TORComboBox;
    txtProvDiag: TCaptionEdit;
    txtAttn: TORComboBox;
    cboProc: TORComboBox;
    cboCategory: TORComboBox;
    cboService: TORComboBox;
    memComment: ORExtensions.TRichEdit;
    btnCmtCancel: TButton;
    btnCmtOther: TButton;
    cmdLexSearch: TButton;
    lblClinicallyIndicated: TStaticText;
    lblLatest: TStaticText;
    calClinicallyIndicated: TORDateBox;
    calLatest: TORDateBox;
    mnuPopProvDx: TPopupMenu;
    mnuPopProvDxDelete: TMenuItem;
    popReason: TPopupMenu;
    popReasonCut: TMenuItem;
    popReasonCopy: TMenuItem;
    popReasonPaste: TMenuItem;
    popReasonPaste2: TMenuItem;
    popReasonReformat: TMenuItem;
    pnlCombatVet: TPanel;
    txtCombatVet: TVA508StaticText;
    pnlButtons: TPanel;
    GridPanel1: TGridPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    procedure txtAttnNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure cboProcNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure radInpatientClick(Sender: TObject);
    procedure radOutpatientClick(Sender: TObject);
    procedure ControlChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cboProcSelect(Sender: TObject);
    procedure memReasonExit(Sender: TObject);
    procedure cmdAcceptClick(Sender: TObject);
    procedure cmdQuitClick(Sender: TObject);
//    procedure OrderMessage(const AMessage: string);
    procedure btnCmtCancelClick(Sender: TObject);
    procedure btnCmtOtherClick(Sender: TObject);
    procedure cmdLexSearchClick(Sender: TObject);
    procedure mnuPopProvDxDeleteClick(Sender: TObject);
    procedure popReasonCutClick(Sender: TObject);
    procedure popReasonCopyClick(Sender: TObject);
    procedure popReasonPasteClick(Sender: TObject);
    procedure popReasonPopup(Sender: TObject);
    procedure popReasonReformatClick(Sender: TObject);
    procedure memCommentKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure memReasonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure memReasonKeyPress(Sender: TObject; var Key: Char);
    procedure calClinicallyIndicatedExit(Sender: TObject);
    procedure calLatestExit(Sender: TObject);
    procedure memCommentExit(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    FLastProcID: string;
    FChanged: boolean;
    FChanging: boolean;
    FEditCtrl: TCustomEdit;
    FNavigatingTab: boolean;
    FClinicallyIndicatedDate: TFMDateTime;
    procedure SetProvDiagPromptingMode;
//    procedure SetUpCombatVet;
    procedure SetUpCombatVet(Eligable:Boolean);  // RTC#722078
    procedure OrderMessage(const AMessage: string);
  protected
    procedure InitDialog;
    procedure Validate(var AnErrMsg: string);
    function  ValidSave: Boolean;
  end;


function EditResubmitProcedure(FontSize: Integer; ConsultIEN: integer): boolean;

var
  frmEditProc: TfrmEditProc;

implementation

{$R *.DFM}

uses
  rConsults, uCore, rCore, fConsults, rODBase, fRptBox, fPCELex, rPCE, ORClasses, clipbrd ,
  uORLists, uSimilarNames, VAUtils, uMisc;

var
  OldRec, NewRec: TEditResubmitRec;
  Defaults: TStringList;
  uMessageVisible: DWORD;
  ProvDx: TProvisionalDiagnosis;

const
  TX_NO_PROC         = 'A procedure must be specified.'    ;
  TX_NO_REASON       = 'A reason for this procedure must be entered.'  ;
  TX_NO_SERVICE      = 'A service must be selected to perform this procedure.';
  TX_NO_URGENCY      = 'An urgency must be specified.';
  TX_NO_PLACE        = 'A place of consultation must be specified';
  TX_NO_DIAG         = 'A provisional diagnosis must be entered for consults to this service.';
  TX_SELECT_DIAG     = 'You must use the "Lexicon" button to select a diagnosis for consults to this service.';
  TX_INACTIVE_CODE   = 'The provisional diagnosis code is not active as of today''s date.' + #13#10 +
                       'Another code must be selected';
  TC_INACTIVE_CODE   = 'Inactive ICD Code';
  TX_PAST_DATE       = 'Clinically indicated date must be today or later.';

function EditResubmitProcedure(FontSize: Integer; ConsultIEN: integer): boolean;
begin
  Result := False;
  if ConsultIEN = 0 then exit;
  OldRec.Clear;
  NewRec.Clear;
  FillChar(OldRec, SizeOf(OldRec), 0);
  FillChar(NewRec, SizeOf(NewRec), 0);
  FillChar(ProvDx, SizeOf(ProvDx), 0);
  OldRec := LoadConsultForEdit(ConsultIEN);
  NewRec.IEN := OldRec.IEN;
  NewRec.RequestType := OldRec.RequestType;
  with NewRec do
    begin
      InitSL(RequestReason);
      InitSL(DenyComments);
      InitSL(OtherComments);
      InitSL(NewComments);
    end;
  StatusText('Loading Procedure for Edit');
  frmEditProc := TfrmEditProc.Create(Application);
  Defaults    := TStringList.Create;
  try
    ResizeAnchoredFormToFont(frmEditProc);
    with frmEditProc do
      begin
        FChanged     := False;
        InitDialog;
        ShowModal ;
        Result := FChanged ;
      end ;
  finally
    OldRec.Clear;
    NewRec.Clear;
    Defaults.Free;
    frmEditProc.Release;
    frmEditProc := nil;
  end;
end;

procedure TfrmEditProc.InitDialog;
var
  i: integer;
begin
  if FChanging then exit;
  FChanging := True;
  InitSL(Defaults);
  setODForProcedures(Defaults);
  FLastProcID := '';
  cboProc.InitLongList(OldRec.ConsultProcName) ;
  cboProc.SelectByIEN(OldRec.OrderableItem);
  if cboProc.ItemIndex = -1 then
    begin
      cboProc.Items.Insert(0, IntToStr(OldRec.OrderableItem) + U + OldRec.ConsultProcName +
                              U + OldRec.ConsultProcName + U + OldRec.ConsultProc);
      cboProc.ItemIndex := 0;
    end;
  cboProcSelect(Self);
  txtAttn.InitLongList(OldRec.AttnName) ;
  if OldRec.Attention > 0 then
    txtAttn.SelectByIEN(OldRec.Attention)
  else
    txtAttn.ItemIndex := -1;
  cboService.SelectByIEN(OldRec.ToService);
  if OldRec.InpOutp <> '' then
    case OldRec.InpOutp[1] of
      'I': radInpatient.Checked  := True;                 //INPATIENT PROCEDURE
      'O': radOutpatient.Checked := True;                 //OUTPATIENT PROCEDURE
    end
  else
    begin
      if Patient.Inpatient then
        radInpatient.Checked  := True
      else
        radOutpatient.Checked := True;
    end;
  cboPlace.SelectByID(OldRec.Place);
  with cboUrgency do for i := 0 to Items.Count-1 do
    if UpperCase(DisplayText[i]) = UpperCase(OldRec.UrgencyName) then ItemIndex := i;
  calClinicallyIndicated.FMDateTime := OldRec.ClinicallyIndicatedDate;
  FClinicallyIndicatedDate := OldRec.ClinicallyIndicatedDate;
  txtProvDiag.Text := OldRec.ProvDiagnosis;
  ProvDx.Code := OldRec.ProvDxCode;
  if OldRec.ProvDxCodeInactive then
   begin
    InfoBox(TX_INACTIVE_CODE, TC_INACTIVE_CODE, MB_ICONWARNING or MB_OK);
    ProvDx.CodeInactive := True;
   end;
  QuickCopy(OldRec.RequestReason, memReason);
  btnCmtCancel.Enabled := (OldRec.DenyComments.Count > 0);
  btnCmtOther.Enabled := (OldRec.OtherComments.Count > 0);
  memComment.Clear ;
  SetProvDiagPromptingMode;
  SetUpCombatVet(patient.CombatVet.IsEligible);  // RTC#722078
  FChanging := False;
  ControlChange(Self);    //CQ20913
  StatusText('');
  TSimilarNames.RegORComboBox(txtAttn);
end;

procedure TfrmEditProc.Validate(var AnErrMsg: string);

  procedure SetError(const x: string);
  begin
    if Length(AnErrMsg) > 0 then AnErrMsg := AnErrMsg + CRLF;
    AnErrMsg := AnErrMsg + x;
  end;
var
  ErrMsg: String;
begin
  if cboProc.ItemIEN = 0                  then SetError(TX_NO_PROC);
  if memReason.Lines.Count = 0            then SetError(TX_NO_REASON);
  if cboService.ItemIEN = 0               then SetError(TX_NO_SERVICE);
  if cboUrgency.ItemIEN = 0               then SetError(TX_NO_URGENCY);
  if cboPlace.ItemID = ''                 then SetError(TX_NO_PLACE);
  if (ProvDx.Reqd = 'R') and (Length(txtProvDiag.Text) = 0) then
    begin
      if ProvDx.PromptMode = 'F' then
        SetError(TX_NO_DIAG)
      else
        SetError(TX_SELECT_DIAG);
    end;
  if OldRec.ProvDxCodeInactive and ProvDx.CodeInactive then
    SetError(TX_INACTIVE_CODE);
  if calClinicallyIndicated.FMDateTime < FMToday     then SetError(TX_PAST_DATE);

  if not CheckForSimilarName(txtAttn, ErrMsg, sPr) then
  begin
    if ErrMsg <> '' then
      SetError(ErrMsg);
  end;

end;

procedure TfrmEditProc.txtAttnNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
begin
  inherited;
  setPersonList(txtAttn, StartFrom, Direction);
end;

procedure TfrmEditProc.calClinicallyIndicatedExit(Sender: TObject);
begin
  inherited;
  FClinicallyIndicatedDate := calClinicallyIndicated.FMDateTime;
  ControlChange(Self);
end;

procedure TfrmEditProc.calLatestExit(Sender: TObject);
begin
  inherited;
  //FLatestDate := calLatest.FMDateTime;
  //ControlChange(Self);
end;

procedure TfrmEditProc.cboProcNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
begin
  inherited;
  setProcedureList(cboProc, StartFrom, Direction);
end;

procedure TfrmEditProc.radInpatientClick(Sender: TObject);
begin
  inherited;
  cboCategory.Items.Clear;
  cboCategory.Items.Add('I^Inpatient');
  cboCategory.SelectById('I');
  ExtractItems(cboPlace.Items, Defaults, 'Inpt Place');
  ExtractItems(cboUrgency.Items, Defaults, 'Inpt Proc Urgencies');      //S.GMRCR
  ControlChange(Self);
end;

procedure TfrmEditProc.radOutpatientClick(Sender: TObject);
begin
  inherited;
  cboCategory.Items.Clear;
  cboCategory.Items.Add('O^Outpatient');
  cboCategory.SelectById('O');
  ExtractItems(cboPlace.Items, Defaults, 'Outpt Place');
  ExtractItems(cboUrgency.Items, Defaults, 'Outpt Urgencies');     //S.GMRCO
  ControlChange(Self);
end;

procedure TfrmEditProc.ControlChange(Sender: TObject);
begin
  if FChanging then exit;
  with NewRec do
    begin
      with cboProc do if ItemIEN > 0 then
        if Piece(Items[ItemIndex], U, 4) <> OldRec.ConsultProc then
          begin
            ConsultProc     := Piece(Items[ItemIndex], U, 4);
            ConsultProcName := Text;
          end
        else
          begin
            ConsultProc     := '';
            ConsultProcName := '';
          end;

      with cboService do if ItemIEN > 0 then
        if ItemIEN <> OldRec.ToService then
          begin
            ToService     := ItemIEN;
            ToServiceName := Text;
          end
        else
          begin
            ToService     := 0;
            ToServiceName := '';
          end;

     with cboCategory do if Length(ItemID) > 0 then
       if ItemID <> OldRec.InpOutP then
         InpOutP := ItemID
       else
         InpOutP := '';

     with cboUrgency do if ItemIEN > 0 then
       if StrToIntDef(Piece(Items[ItemIndex], U, 3), 0) <> OldRec.Urgency then
         begin
           Urgency     := StrToIntDef(Piece(Items[ItemIndex], U, 3), 0);
           UrgencyName := Text;
         end
       else
         begin
           Urgency     := 0;
           UrgencyName := '';
         end;

     if FClinicallyIndicatedDate > 0 then
     begin
       if FClinicallyIndicatedDate <> OldRec.ClinicallyIndicatedDate then
         ClinicallyIndicatedDate := FClinicallyIndicatedDate
       else
         ClinicallyIndicatedDate := 0;
     end;

     with cboPlace do if Length(ItemID) > 0 then
       if ItemID <> OldRec.Place then
         begin
           Place     := ItemID;
           PlaceName := Text;
         end
       else
         begin
           Place     := '';
           PlaceName := '';
         end;

     with txtAttn do
     begin
       if ItemIEN > 0 then
         begin
           if ItemIEN <> OldRec.Attention then
             begin
               Attention := ItemIEN;
               AttnName  := Text;
             end
           else
             begin
               Attention := 0;
               AttnName  := '';
             end;
         end
       else  // blank
         begin
           if OldRec.Attention > 0 then
             begin
               Attention := -1;
               AttnName  := '';
             end
           else
             begin
               Attention := 0;
               AttnName  := '';
             end;
         end;
     end;

     with txtProvDiag do
       if Length(Text) > 0 then
         begin
           if Text <> OldRec.ProvDiagnosis then
             ProvDiagnosis := Text
           else
             ProvDiagnosis := '';

           if ProvDx.Code <> OldRec.ProvDxCode then
             ProvDxCode := ProvDx.Code
           else
             ProvDxCode := '';

           if OldRec.ProvDxCodeInactive then
             ProvDx.CodeInactive := (ProvDx.Code = OldRec.ProvDxCode);
         end
       else  //blank
         begin
           ProvDx.Code := '';
           ProvDx.CodeInactive := False;
           if OldRec.ProvDiagnosis <> '' then
             ProvDiagnosis := '@'
           else
             ProvDiagnosis := '';
         end;

     with memReason do if Lines.Count > 0 then
        if Lines.Equals(OldRec.RequestReason) then
          RequestReason.Clear
        else
          QuickCopy(memReason, RequestReason);

      with memComment do
        if GetTextLen > 0 then
          QuickCopy(memComment, NewComments)
        else
          NewComments.Clear;
    end;
end;

procedure TfrmEditProc.FormClose(Sender: TObject; var Action: TCloseAction);
const
  TX_ACCEPT = 'Resubmit this request?' + CRLF + CRLF;
  TX_ACCEPT_CAP = 'Unsaved Changes';
begin
  if FChanged then
    if InfoBox(TX_ACCEPT, TX_ACCEPT_CAP, MB_YESNO) = ID_YES then
      if not ValidSave then Action := caNone;
end;

procedure TfrmEditProc.FormResize(Sender: TObject);
const
  LEFT_MARGIN = 4;
begin
  inherited;
  LimitEditWidth(memReason, MAX_PROGRESSNOTE_WIDTH-7); //puts memReason at 74 characters
  Self.Constraints.MinWidth := TextWidthByFont(memReason.Font.Handle, StringOfChar('X', MAX_PROGRESSNOTE_WIDTH)) + (LEFT_MARGIN * 10) + ScrollBarWidth;
end;

function TfrmEditProc.ValidSave: Boolean;
const
  TX_NO_SAVE     = 'This request cannot be saved for the following reason(s):' + CRLF + CRLF;
  TX_NO_SAVE_CAP = 'Unable to Save Request';
  TX_SAVE_ERR    = 'Unexpected error - it was not possible to save this request.';
var
  ErrMsg: string;
begin
  Result := True;
  Validate(ErrMsg);
  if Length(ErrMsg) > 0 then
  begin
    InfoBox(TX_NO_SAVE + ErrMsg, TX_NO_SAVE_CAP, MB_OK);
    Result := False;
  end;
  if (ProvDx.Reqd = 'R') and (Length(txtProvDiag.Text) = 0) and (ProvDx.PromptMode = 'L') then
    cmdLexSearchClick(Self);
end;

procedure TfrmEditProc.SetUpCombatVet(Eligable:Boolean);  // RTC#722078
begin
  pnlCombatVet.Visible := Eligable;
  txtCombatVet.Enabled := Eligable;
  if Eligable then
    begin
      txtCombatVet.Caption := 'Combat Veteran Eligibility Expires on ' + patient.CombatVet.ExpirationDate;
      ActiveControl := txtCombatVet;
    end;
end;

procedure TfrmEditProc.cboProcSelect(Sender: TObject);
begin
  inherited;
  with cboProc do
   begin
    if ItemIndex = -1 then Exit;
    if ItemID <> FLastProcID then FLastProcID := ItemID else Exit;
    with cboService do
      begin
        Clear;
        setProcedureServices(cboService.Items,cboProc.ItemIEN);
        if Items.Count > 0 then
          begin
            ItemIndex := 0 ;
            NewRec.ToService := ItemIEN;
            NewRec.ToServiceName := Text;
          end
        else
          begin
            InfoBox('There are no services defined for this procedure.',
              'Information', MB_OK or MB_ICONINFORMATION);
            //cboProc.ItemIndex := -1;
            InitDialog;
            Exit ;
          end;
      end;
   end;
  OrderMessage(ConsultMessage(cboProc.ItemIEN));
  ControlChange(Self) ;
end;

procedure TfrmEditProc.memReasonExit(Sender: TObject);
var
  AStringList: TStringList;
begin
  inherited;
  AStringList := TStringList.Create;
  try
    //QuickCopy(memReason, AStringList);
    AStringList.Text := memReason.Text;
    LimitStringLength(AStringList, 74);
    //QuickCopy(AstringList, memReason);
    memReason.Text := AStringList.Text;
    ControlChange(Self);
  finally
    AStringList.Free;
  end;
end;

procedure TfrmEditProc.cmdAcceptClick(Sender: TObject);
begin
  if ValidSave then
    begin
      FChanged := (ResubmitConsult(NewRec) = '0');
      Close;
    end;
end;

procedure TfrmEditProc.cmdQuitClick(Sender: TObject);
begin
  inherited;
  FChanged := False;
  Close;
end;

procedure TfrmEditProc.OrderMessage(const AMessage: string);
begin
  memMessage.Lines.SetText(PChar(AMessage));
  if ContainsVisibleChar(AMessage) then
  begin
    pnlMessage.Visible := True;
    pnlMessage.BringToFront;
    uMessageVisible := GetTickCount;
  end
  else pnlMessage.Visible := False;
end;

procedure TfrmEditProc.btnCmtCancelClick(Sender: TObject);
begin
  ReportBox(OldRec.DenyComments, 'Cancellation Comments', False);
end;

procedure TfrmEditProc.btnCmtOtherClick(Sender: TObject);
begin
  ReportBox(OldRec.OtherComments, 'Added Comments', False);
end;



procedure TfrmEditProc.cmdLexSearchClick(Sender: TObject);
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
  ProvDx.Code := Piece(Match, U, 1);
  ProvDx.Text := Piece(Match, U, 2);
  i := Pos(' (ICD', ProvDx.Text);
  if i = 0 then i := Length(ProvDx.Text) + 1;
  if ProvDx.Text[i-1] = '*' then i := i - 2;
  ProvDx.Text := Copy(ProvDx.Text, 1, i - 1);
  txtProvDiag.Text := ProvDx.Text + ' (' + ProvDx.Code + ')';
  ProvDx.CodeInactive := False;
end;

procedure TfrmEditProc.SetProvDiagPromptingMode;
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
  //GetProvDxMode(ProvDx, cboService.ItemID);
  GetProvDxMode(ProvDx, Piece(cboProc.Items[cboProc.ItemIndex], U, 4));
  //  Returns:  string  A^B
  //     A = O (optional), R (required) or S (suppress)
  //     B = F (free-text) or L (lexicon)
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

procedure TfrmEditProc.mnuPopProvDxDeleteClick(Sender: TObject);
begin
  inherited;
  ProvDx.Text := '';
  ProvDx.Code := '';
  ProvDx.CodeInactive := False;
  txtProvDiag.Text := '';
  ControlChange(Self);
end;

procedure TfrmEditProc.popReasonPopup(Sender: TObject);
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

procedure TfrmEditProc.popReasonCutClick(Sender: TObject);
begin
  inherited;
  FEditCtrl.CutToClipboard;
end;

procedure TfrmEditProc.popReasonCopyClick(Sender: TObject);
begin
  inherited;
  FEditCtrl.CopyToClipboard;
end;

procedure TfrmEditProc.popReasonPasteClick(Sender: TObject);
begin
  inherited;
  FEditCtrl.SelText := Clipboard.AsText;
end;

procedure TfrmEditProc.popReasonReformatClick(Sender: TObject);
begin
  if (Screen.ActiveControl <> memReason) and
     (Screen.ActiveControl <> memComment)then Exit;
  ReformatMemoParagraph(TCustomMemo(FEditCtrl));
end;


procedure TfrmEditProc.memCommentExit(Sender: TObject);
//added OnExit code for CQ17822 WAT
var
  AStringList: TStringList;
begin
  inherited;
  AStringList := TStringList.Create;
  try
    //QuickCopy(memComment, AStringList);
    AStringList.Text := memComment.Text;
    LimitStringLength(AStringList, 74);
    //QuickCopy(AstringList, memComment);
    memComment.Text := AStringList.Text;
    ControlChange(Self);
  finally
    AStringList.Free;
  end;
end;

procedure TfrmEditProc.memCommentKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if FNavigatingTab then
  begin
    if ssShift in Shift then
      FindNextControl(Sender as TWinControl, False, True, False).SetFocus //previous control
    else if ssCtrl	in Shift then
      FindNextControl(Sender as TWinControl, True, True, False).SetFocus; //next control
  end;
  if (key = VK_ESCAPE) then begin
    FindNextControl(Sender as TWinControl, False, True, False).SetFocus; //previous control
    key := 0;
  end;
end;

procedure TfrmEditProc.memReasonKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //The navigating tab controls were inadvertently adding tab characters
  //This should fix it
  FNavigatingTab := (Key = VK_TAB) and ([ssShift,ssCtrl] * Shift <> []);
  if FNavigatingTab then
    Key := 0;
end;

procedure TfrmEditProc.memReasonKeyPress(Sender: TObject; var Key: Char);
begin
  if FNavigatingTab then
    Key := #0;  //Disable shift-tab processing
end;

end.


