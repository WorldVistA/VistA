unit fODRTC;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fODBase, StdCtrls, ComCtrls, ExtCtrls, ORCtrls, Grids, Buttons, uConst, ORDtTm,
  Menus,
//  XUDIGSIGSC_TLB,
  rMisc, uOrders, StrUtils, oRFn, contnrs,
  VA508AccessibilityManager, Vcl.CheckLst, rODRTC;

const
  UM_DELAYCLICK = 11037;  // temporary for listview click event
  NO_CLINIC = 'No Clinic selected';
  BAD_DATE = 'Return to clinic date must be today or later.';
  NO_DATE = 'No Return to Clinic Date Defined';
  NO_INTERVAL = 'Interval in Days not defined';
  CANNOT_DEFINE_INTERVAL = 'Interval cannot be defined if appointment number is 1';
  NO_APPT_DEFINED = 'Number of appointments not defined';
  INVALID_APPT_DEFINED = 'Incorrect number of appointments defined';
  NUM_APPT_EXCEED = 'Number of appointments cannot exceed ';
  NUM_INTERVAL_EXCEED = 'Number of appointments interval cannot exceed ';
  COMMENT_LENGTH = 'Comment cannot exceed 75 characters';
  COMMENT_U = 'Comment cannot contain an ^ character';

type
  TfrmODRTC = class(TfrmODBase)
    pnlRequired: TPanel;
    lblClinic: TLabel;
    cboRTCClinic: TORComboBox;
    lblClinicallyIndicated: TStaticText;
    dateCIDC: TORDateBox;
    lblNumberAppts: TStaticText;
    txtNumAppts: TCaptionEdit;
    SpinNumAppt: TUpDown;
    lblFrequency: TStaticText;
    lblPReReq: TStaticText;
    lblComments: TStaticText;
    cboPerQO: TORComboBox;
    lblQO: TLabel;
    txtInterval: TCaptionEdit;
    spnInterval: TUpDown;
    chkTimeSensitve: TCheckBox;
    lblOrderSig: TLabel;
    memInfo: TMemo;
    lblMoreInfo: TLabel;
    edtComment: TEdit;
    stQuickOrdersDisabled: TStaticText;
    stIntervalInDays: TStaticText;
    lstPreReq: TCheckListBox;
    vacaPrerequisites: TVA508ComponentAccessibility;
    vacaMoreInformation: TVA508ComponentAccessibility;
    procedure FormCreate(Sender: TObject);
    procedure ControlChange(Sender: TObject);
    procedure pnlMessageExit(Sender: TObject);
    procedure memMessageKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lbStatementsClickCheck(Sender: TObject; Index: Integer);
    procedure txtNumApptsChange(Sender: TObject);
    procedure cboRTCClinicMouseClick(Sender: TObject);
    procedure dateCIDCChange(Sender: TObject);
    procedure cboIntervalChange(Sender: TObject);
    procedure cboRTCClinicKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cboRTCClinicNeedData(Sender: TObject; const StartFrom: string;
      Direction, InsertAt: Integer);
    procedure cboPerQOKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cboPerQOMouseClick(Sender: TObject);
    procedure chkTimeSensitveClick(Sender: TObject);
    procedure edtCommentChange(Sender: TObject);
    procedure txtNumApptsClick(Sender: TObject);
    procedure txtIntervalClick(Sender: TObject);
    procedure txtIntervalChange(Sender: TObject);
    procedure cboPerQODropDownClose(Sender: TObject);
    procedure lstPreReqClickCheck(Sender: TObject);
    procedure loadAdditionalComments(input: string);
    procedure loadPreReq(input: string);
    procedure cboRTCClinicChange(Sender: TObject);
  private
    OffSet: integer;
    systemInfo: boolean;
    systemPre: boolean;
  protected
    procedure Loaded; override;
    procedure InitDialog; override;
    procedure Validate(var AnErrMsg: string); override;
    procedure SetValuesFromResponses;
    procedure resetAllPrompts;
    procedure ClearAllPrompts;
    procedure quickOrderSelected(idx: integer);
  public
    procedure SetupDialog(OrderAction: Integer; const ID: string); override;

  end;

var
  frmODRTC: TfrmODRTC;
//  crypto: IXuDigSigS;

implementation

{$R *.DFM}

uses rCore, uCore, rODMeds, rODBase, rOrders, fRptBox, fODMedOIFA,
  fFrame, ORNet, VAUtils;

const
  TX_CIDC_DATE_INVALID = 'CIDC date must be after the encounter date.';

{ procedures inherited from fODBase --------------------------------------------------------- }

procedure TfrmODRTC.InitDialog;
{ Executed each time dialog is reset after pressing accept.  Clears controls & responses }
var
tmp: string;
begin
  inherited;
  //  ClearAllFields;
  //FIVTypeDefined := false;
  ClearAllPrompts;
  systemInfo := false;
  systemPre := false;
  with CtrlInits do
    begin
      SetControl(cboPerQO, 'ShortList');
      if cboPerQO.Items.Count < 1 then
      begin
        cboPerQO.Enabled := false;
        if ScreenReaderActive then
        begin
          stQuickOrdersDisabled.TabStop := true;
        end;
      end;
      SetControl(lstPreReq, 'PreReq');
      memInfo.Visible := true;
      lblMoreInfo.Visible := true;
      SetControl(memInfo, 'Info');
      if memInfo.Lines.Count > 0 then systemInfo := true;
      if lstPreReq.Items.Count < 1 then lstPreReq.Enabled := false
      else
        begin
          systemPre := true;
          lstPreReq.Enabled := true;
        end;
    end;
    cboRTCClinic.InitLongList(encounter.LocationName);
    cboRTCCLinic.SelectByIEN(encounter.Location);
    if (not systemInfo) and (cboRTCClinic.ItemIndex > -1) then
      begin
        tmp := cboRTCClinic.Items.Strings[cboRTCClinic.ItemIndex];
        loadAdditionalComments(tmp);
      end;
    if (not systemPre) and (cboRTCClinic.ItemIndex > -1) then
      begin
        tmp := cboRTCClinic.Items.Strings[cboRTCClinic.ItemIndex];
        loadPreReq(tmp);
      end;
    tmp := Piece(CtrlInits.TextOf('Offset'), U, 1);
    self.OffSet := StrToIntDef(tmp,0);
    if self.OffSet = 0 then self.OffSet := 30;

    txtNumAppts.Text := '1';
  if ScreenReaderActive then
  begin
    stQuickOrdersDisabled.TabStop := true;
    stIntervalInDays.TabStop := true;
  end
  else
  begin
    stQuickOrdersDisabled.Visible := false;
    stIntervalInDays.Visible := false;
  end;
end;

procedure TfrmODRTC.SetupDialog(OrderAction: Integer; const ID: string);
begin
  inherited;
  AutoSizeDisabled := True;
  try
    changing := false;
    if OrderAction in [ORDER_COPY, ORDER_EDIT, ORDER_QUICK] then
    begin
      changing := true;
      SetValuesFromResponses;
      cboPerQo.Enabled := false;
      lblQO.Enabled := false;
    end;
    changing := false;
    ControlChange(Self);
  finally
    changing := false;
  end;
end;

procedure TfrmODRTC.SetValuesFromResponses;
var
  AnInstance, idx: integer;
  int, ext: String;
  AResponse: TResponse;
begin
  with Responses do
  begin
    //clinic
    AResponse := FindResponseByName('LOCATION', 1);
    if AResponse <> nil then
      begin
        int := AResponse.IValue;
        ext := AResponse.EValue;
        idx := self.cboRTCClinic.Items.IndexOf(ext);
        if idx > -1 then self.cboRTCClinic.ItemIndex := idx
        else
          begin
            self.cboRTCClinic.Clear;
            self.cboRTCClinic.InitLongList(EXT);
            self.cboRTCClinic.SelectByIEN(StrToIntDef(int,0));
          end;
        if cboRTCClinic.ItemIndex > -1 then
          begin
            loadAdditionalComments(cboRTCClinic.Items.Strings[cboRTCClinic.ItemIndex]);
            loadPreReq(cboRTCClinic.Items.Strings[cboRTCClinic.ItemIndex]);
          end;
      end;

    //provider
//    AResponse := FindResponseByName('PROVIDER', 1);
//    if AResponse <> nil then
//    begin
//      int := AResponse.IValue;
//      ext := MixedCase(AResponse.EValue);
//      idx := self.cboProvider.Items.IndexOf(ext);
//      if idx > -1 then self.cboProvider.ItemIndex := idx
//      else
//        begin
//          self.cboProvider.Items.Add(int + U + ext);
//          idx := self.cboProvider.Items.IndexOf(ext);
//          if idx > -1 then self.cboProvider.ItemIndex := idx;
//
//        end;
//    end;
    //CIDC
    AResponse := FindResponseByName('CLINICALLY', 1);
    if AResponse <> nil then
      begin
        ext := AResponse.Evalue;
        if ext <> '' then self.dateCIDC.text := ext;
      end;
    //Time Sensitive
    AResponse := FindResponseByName('YN', 1);
    if AResponse <> nil then
      begin
        idx := StrToIntDef(AResponse.IValue, 0);
        if idx = 1 then
          self.chkTimeSensitve.Checked := true
        else self.chkTimeSensitve.Checked := false;
      end;
    //Number of Appts
    AResponse := FindResponseByName('SDNUM', 1);
    if AResponse <> nil then
      begin
        ext := AResponse.Evalue;
        if ext <> '' then
          begin
            self.txtNumAppts.text := ext;
            self.SpinNumAppt.Position := StrToIntDef(ext,0);
          end;
      end;
    if StrToIntDef(self.txtNumAppts.text, 0) > 1 then
      begin
        AResponse := FindResponseByName('SDINT', 1);
        if AResponse <> nil then
          begin
            ext := AResponse.EValue;
            self.txtInterval.Text := ext;
            self.spnInterval.Position := StrToIntDef(ext, 0);
          end;
      end
      else
        begin
          self.txtInterval.Enabled := false;
          self.spnInterval.Enabled := false;
        end;
    //prereq
    AnInstance := NextInstance('PREREQ', 0);
    while AnInstance > 0 do
      begin
        AResponse := FindResponseByName('PREREQ', AnInstance);
        if (AResponse <> nil) and (lstPreReq.Enabled = true) then
          begin
            ext := AResponse.EValue;
           for idx := 0 to self.lstPreReq.Count - 1 do
             begin
               if compareText(ext, self.lstPreReq.Items.Strings[idx]) = 0 then
                self.lstPreReq.Checked[idx] := true;
             end;
//            idx := self.lstPreReq.Items.IndexOf(ext);
//            if idx > -1 then self.lstPreReq.Checked[idx] := true;
          end;
          AnInstance := NextInstance('PREREQ', AnInstance);
      end;
    //comments
    AResponse := FindResponseByName('SDCOMMENT', 1);
    if AResponse <> nil then edtComment.Text := AResponse.EValue;
  end;
end;


procedure TfrmODRTC.txtIntervalChange(Sender: TObject);
begin
  inherited;
  controlChange(sender);
end;

procedure TfrmODRTC.txtIntervalClick(Sender: TObject);
begin
  inherited;
  txtInterval.SelectAll;
end;

procedure TfrmODRTC.txtNumApptsChange(Sender: TObject);
begin
  inherited;
  if StrToIntDef(self.txtNumAppts.Text, 0) > 1 then
    begin
      self.txtInterval.Enabled := true;
      self.spnInterval.Enabled := true;
      self.lblFrequency.Caption := 'Interval in day(s)*';
    end
  else
    begin
      self.txtInterval.Text := '0';
      self.lblFrequency.Caption := 'Interval in day(s)';
      self.txtInterval.Enabled := false;
      self.spnInterval.Enabled := false;
    end;
  ControlChange(Sender);
end;

procedure TfrmODRTC.txtNumApptsClick(Sender: TObject);
begin
  inherited;
  txtNumAppts.SelectAll;
end;

procedure TfrmODRTC.Validate(var AnErrMsg: string);
var
  i, int: Integer;

  procedure SetError(const x: string);
  begin
    if Length(AnErrMsg) > 0 then AnErrMsg := AnErrMsg + CRLF;
    AnErrMsg := AnErrMsg + x;
  end;

begin
  inherited;
  int := StrToIntDef(self.txtInterval.Text, 0);;
  if self.cboRTCClinic.ItemIndex = -1 then SetError(NO_CLINIC);
  if (length(self.dateCIDC.Text) <1) then SetError(NO_DATE)
  else
    begin
      if self.dateCIDC.FMDateTime < FMToday then SetError(BAD_DATE);
    end;
  if Length(self.txtNumAppts.Text) < 1 then SetError(NO_APPT_DEFINED)
  else if StrToIntDef(self.txtNumAppts.Text, 0) = 0 then  SetError(INVALID_APPT_DEFINED)
  else
    begin
       i := StrToIntDef(self.txtNumAppts.Text, 0);
       if (i < 2) and (int > 0) then SetError(CANNOT_DEFINE_INTERVAL);
       if i > self.SpinNumAppt.Max then SetError(NUM_APPT_EXCEED + IntToStr(self.SpinNumAppt.Max));
       if i > 1 then
        begin
          if int < 1 then SetError(NO_INTERVAL);
          if int > self.spnInterval.Max then SetError(NUM_INTERVAL_EXCEED + IntToStr(self.spnInterval.Max));
        end;
    end;
  if Length(edtComment.Text) > 75 then SetError(COMMENT_LENGTH);
  if pos(U, edtComment.Text) > 0 then SetError(COMMENT_U);
end;



procedure TfrmODRTC.cboIntervalChange(Sender: TObject);
begin
  inherited;
  ControlChange(Sender);
end;

procedure TfrmODRTC.cboPerQODropDownClose(Sender: TObject);
begin
  inherited;
//  quickOrderSelected(cboPerQO.ItemIndex);
end;

procedure TfrmODRTC.cboPerQOKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_BACK) and (cboPerQO.Text = '') then cboPerQO.ItemIndex := -1;
  quickOrderSelected(cboPerQO.ItemIndex);
end;

procedure TfrmODRTC.cboPerQOMouseClick(Sender: TObject);
begin
  inherited;
  quickOrderSelected(cboPerQO.ItemIndex);
end;

procedure TfrmODRTC.quickOrderSelected(idx: integer);
begin
   try
    if idx = -1 then exit;
    if CharAt(cboPerQO.ItemID, 1) <> 'Q' then exit;
    ResetAllPrompts;

    Responses.QuickOrder := ExtractInteger(cboPerQO.ItemID);
    changing := true;
    SetValuesFromResponses;
    changing := false;
    ControlChange(self);
  finally
    changing := false;
  end;
end;


procedure TfrmODRTC.ClearAllPrompts;
begin
  ClearControl(self.cboRTCClinic);
  ClearControl(self.dateCIDC);
  ClearControl(self.txtNumAppts);
  ClearControl(self.txtInterval);
  ClearControl(self.lstPreReq);
  ClearControl(self.edtComment);
  ClearControl(self.chkTimeSensitve);
  if memInfo.Visible = true then ClearControl(self.memInfo);

end;

procedure TfrmODRTC.ControlChange(Sender: TObject);
var
cnt,idx: integer;
str: string;
CIDC: TFMDateTime;
pp: integer;
begin
  inherited;
  if csLoading in ComponentState then Exit;       // to prevent error caused by txtRefills
  if Changing then Exit;

  //blj defect 529225 - Somehow, JAWS is getting to Responses before it is initialized
  //  so we'll just have to exit until it is.
  if not assigned(Responses) then Exit;
  Responses.clear;
  //Clinic
  idx := self.cboRTCClinic.ItemIndex;
  if idx > -1 then
    begin
      str := self.cboRTCClinic.Items[idx];
      Responses.Update('LOCATION', 1, Piece(str, u, 1), Piece(str, u, 2));
    end;
  //CIDC and time sensitive
  str := self.dateCIDC.Text;
  if Length(str)> 0 then
    begin
      CIDC := self.dateCIDC.FMDateTime;
      if CIDC <> -1 then
        begin
          // RPC call doesn't like fractional part (the time part)
          CIDC := Trunc(CIDC);
          // Convert NOW to T
          if 'NOW'.StartsWith(str.ToUpper) then
            str := 'T';
          // strip any @ times
          pp := Pos('@', str);
          if pp > 0 then
            Delete(str, pp, Length(str));
          if str <> '' then
          begin
            if self.chkTimeSensitve.Checked = TRUE then
            begin
              Responses.Update('YN', 1, '1', 'Yes');
              Responses.varLeading := 'no later than ';
            end
            else
            begin
              Responses.Update('YN', 1, '0', 'No');
              Responses.varLeading := 'on or around (';
              Responses.VarTrailing := ')';
            end;
            {if str contains T+N save str instead of FLoatToStr}
            if (UpperCase(str[1])='T') then
              Responses.Update('CLINICALLY', 1, str, str)
            else
              Responses.Update('CLINICALLY', 1, FloatToStr(CIDC), str);
          end;
        end;
    end;
  //Number of Appt
  str := self.txtNumAppts.Text;
  if length(str)>0 then
    begin
      Responses.Update('SDNUM', 1, str, str);
      if StrToIntDef(str, 0)>1 then
        begin
          //Interval
          str := self.txtInterval.Text;
          Responses.Update('SDINT', 1, str, str);
        end;
    end;
    cnt := 0;
  //PreReq
  for idx := 0 to self.lstPreReq.Items.Count -1 do
    begin
      if self.lstPreReq.Checked[idx] = false then continue;
      inc(cnt);
      str := self.lstPreReq.Items[idx];
      Responses.Update('PREREQ', cnt, str, str);
    end;
  Responses.Update('SDCOMMENT', 1, edtComment.text, edtComment.text);
  memOrder.Text := Responses.OrderText;
end;

procedure TfrmODRTC.dateCIDCChange(Sender: TObject);
begin
  inherited;
  ControlChange(Sender);
end;



procedure TfrmODRTC.edtCommentChange(Sender: TObject);
begin
  inherited;
  ControlChange(Sender);
end;

procedure TfrmODRTC.cboRTCClinicChange(Sender: TObject);
begin
  inherited;
  if cboRTCClinic.ItemIndex > -1 then
    begin
      loadAdditionalComments(cboRTCClinic.Items.Strings[cboRTCClinic.ItemIndex]);
      loadPreReq(cboRTCClinic.Items.Strings[cboRTCClinic.ItemIndex]);
      ControlChange(Sender);
    end;
end;

procedure TfrmODRTC.cboRTCClinicKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
//  if (Key = VK_BACK) and (cboRTCClinic.Text = '') then cboRTCClinic.ItemIndex := -1;
//  if cboRTCClinic.ItemIndex > -1 then
//    begin
//      loadAdditionalComments(cboRTCClinic.Items.Strings[cboRTCClinic.ItemIndex]);
//      loadPreReq(cboRTCClinic.Items.Strings[cboRTCClinic.ItemIndex]);
//      ControlChange(Sender);
//    end;
end;

procedure TfrmODRTC.cboRTCClinicMouseClick(Sender: TObject);
begin
  inherited;
//  ControlChange(Sender);
//  if cboRTCClinic.ItemIndex > -1 then
//    begin
//      loadAdditionalComments(cboRTCClinic.Items.Strings[cboRTCClinic.ItemIndex]);
//      loadPreReq(cboRTCClinic.Items.Strings[cboRTCClinic.ItemIndex]);
//    end;
end;

procedure TfrmODRTC.cboRTCClinicNeedData(Sender: TObject; const StartFrom: string;
  Direction, InsertAt: Integer);
var
  sl: TStrings;
begin
  inherited;
//  cboRTCClinic.ForDataUse(SubSetOfNewLocs(StartFrom, Direction));
  sl := TStringList.Create;
  try
    setSubSetOfNewLocs(sl, StartFrom, Direction);
    cboRTCClinic.ForDataUse(sl);
  finally
    sl.Free;
  end;
end;

procedure TfrmODRTC.chkTimeSensitveClick(Sender: TObject);
begin
  inherited;
  ControlChange(Sender);
end;

procedure TfrmODRTC.pnlMessageExit(Sender: TObject);
begin
  inherited;
//  RestoreDefaultButton;
//  RestoreCancelButton;
end;

procedure TfrmODRTC.resetAllPrompts;
begin
  ResetControl(self.cboRTCClinic);
//  ResetControl(self.cboProvider);
  ResetControl(self.dateCIDC);
  ResetControl(self.txtNumAppts);
  ResetControl(self.txtInterval);
  ResetControl(self.chkTimeSensitve);
  if lstPreReq.Enabled then ResetControl(self.lstPreReq);
  ResetControl(self.edtComment);
//  if memInfo.Visible then ResetControl(self.memInfo);
  ControlChange(self);
end;

procedure TfrmODRTC.memMessageKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_RETURN) or (Key = VK_ESCAPE) then
  begin
    Perform(WM_NEXTDLGCTL, 0, 0);
    Key := 0;
  end;
end;

procedure TfrmODRTC.FormCreate(Sender: TObject);
var
  sl: TStrings;

begin
  inherited;
  lstPreReq.IntegralHeight := True; // RTC 1299114
  AllowQuickOrder := true;
  Responses.Dialog := 'SD RTC';
  sl := TSTringList.Create;
  try
    setODforSD(sl);
    CtrlInits.LoadDefaults(sl);
  finally
    sl.Free;
  end;
  InitDialog;
end;

procedure TfrmODRTC.lbStatementsClickCheck(Sender: TObject;
  Index: Integer);
begin
  inherited;
   ControlChange(self);
end;



procedure TfrmODRTC.loadAdditionalComments(input: string);
var
locIen: string;
addInfoText: TStrings;
begin
  if systemInfo then exit;
  addInfoText := TStringList.Create;
  try
    locIen := Piece(input, U, 1);
    memInfo.Lines.Clear;
    getAdditionalInformation(locIen, 'INFO', addInfoText);
    memInfo.Lines.AddStrings(addInfoText);
  finally
    FreeAndNil(addInfoText);
  end;
end;

procedure TfrmODRTC.Loaded;
begin
  AutoSizeDisabled := True;
  inherited;
end;

procedure TfrmODRTC.loadPreReq(input: string);
var
locIEN: string;
prereq: TStrings;
begin
  if systemPre then exit;
  prereq := TStringList.Create;
  try
    locIEN := Piece(input, U, 1);
    ClearControl(self.lstPreReq);
    getAdditionalInformation(locIEN, 'PRE', prereq);
    self.lstPreReq.Items.AddStrings(prereq);
    if lstPreReq.Items.Count > 0 then lstPreReq.Enabled := true;
  finally
    FreeAndNil(prereq);
  end;

end;

procedure TfrmODRTC.lstPreReqClickCheck(Sender: TObject);
begin
  inherited;
  controlChange(self);
end;

end.
