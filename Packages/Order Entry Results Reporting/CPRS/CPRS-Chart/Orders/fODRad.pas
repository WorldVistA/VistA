unit fODRad;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ORCtrls, fODBase, ORFn, ExtCtrls,
  ComCtrls, uConst, ORDtTm, VA508AccessibilityManager, VA508AccessibilityRouter;

type
  TfrmODRad = class(TfrmODBase)
    lblDrug: TLabel;
    cboProcedure: TORComboBox;
    cboAvailMod: TORComboBox;
    lblAvailMod: TLabel;
    cmdRemove: TButton;
    calRequestDate: TORDateBox;
    cboUrgency: TORComboBox;
    cboTransport: TORComboBox;
    cboCategory: TORComboBox;
    chkPreOp: TCheckBox;
    cboSubmit: TORComboBox;
    lstLastExam: TORListBox;
    lblHistory: TLabel;
    memHistory: TCaptionMemo;
    lstSelectMod: TORListBox;
    lblSelectMod: TLabel;
    lblRequestDate: TLabel;
    lblUrgency: TLabel;
    lblTransport: TLabel;
    lblCategory: TLabel;
    lblSubmit: TLabel;
    lblLastExam: TLabel;
    lblAskSubmit: TLabel;
    chkIsolation: TCheckBox;
    FRadCommonCombo: TORListBox;
    lblImType: TLabel;
    cboImType: TORComboBox;
    calPreOp: TORDateBox;
    lblPreOp: TLabel;
    pnlLeft: TPanel;
    pnlRight: TPanel;
    pnlHandR: TPanel;
    grpPregnant: TGroupBox;
    radPregnant: TRadioButton;
    radPregnantNo: TRadioButton;
    radPregnantUnknown: TRadioButton;
    lblReason: TLabel;
    txtReason: TCaptionEdit;
    pnlRightBase: TPanel;
    Submitlbl508: TVA508StaticText;
    VA508ComponentAccessibility1: TVA508ComponentAccessibility;
    VA508ComponentAccessibility2: TVA508ComponentAccessibility;
    procedure cboProcedureNeedData(Sender: TObject;
              const StartFrom: string; Direction, InsertAt: Integer);
    procedure cboAvailModMouseClick(Sender: TObject);
    procedure cmdRemoveClick(Sender: TObject);
    procedure ControlChange(Sender: TObject);
    procedure cboProcedureSelect(Sender: TObject);
    procedure SetModifierList;
    procedure cboCategoryChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cboImTypeChange(Sender: TObject);
    procedure memHistoryExit(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure cboAvailModKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure calPreOpChange(Sender: TObject);
    procedure cmdAcceptClick(Sender: TObject);
    procedure cboProcedureExit(Sender: TObject);
    procedure cboImTypeExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure chkIsolationExit(Sender: TObject);
    procedure calPreOpExit(Sender: TObject);
    procedure cboImTypeDropDownClose(Sender: TObject);
    procedure pnlMessageExit(Sender: TObject);
    procedure VA508ComponentAccessibility1StateQuery(Sender: TObject;
      var Text: string);
    procedure pnlMessageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure txtReasonKeyPress(Sender: TObject; var Key: Char);
    procedure tmrBringToFrontTimer(Sender: TObject);
    procedure lblImTypeClick(Sender: TObject);
  private
    FLastRadID: string;
    FEditCopy: boolean;
    FPreOpDate: string;
    FEvtDelayDiv: string;
    FPredefineOrder: boolean;
    ImageTypeChanged : boolean;
    FFormFirstOpened: boolean;
    FMissingGroupsMessage: string;
    function NoPregnantSelection : Boolean;
    procedure ImageTypeChange;
    procedure FormFirstOpened(Sender: TObject);
    procedure setup508Label(text: string; lbl: TVA508StaticText; ctrl: TControl);
  protected
    procedure InitDialog; override;
    procedure Validate(var AnErrMsg: string); override;
    procedure SetDefaultPregant;
    procedure ShowOrderMessage(Show: boolean); override;
  public
    procedure SetFontSize(FontSize: integer); override;
    procedure SetupDialog(OrderAction: Integer; const ID: string); override;
  end;

implementation

{$R *.DFM}

uses rODBase, rODRad, rOrders, uCore, rCore, fODRadApproval, fODRadConShRes, fLkUpLocation, fFrame,
  uFormMonitor, System.UITypes, VAUtils, uOrders, uWriteAccess;

const
  TX_NO_PROC          = 'An Imaging Procedure must be specified.'    ;
  TX_NO_URG           = 'The Urgency must be specified.'    ;
  TX_NO_MODE          = 'A mode of transport must be selected.';
  TX_INVALID_REASON   = 'You cannot enter control characters in the Reason for Study field.';
  TX_BAD_REASON       = 'You cannot enter a ^ in the Reason for Study field.';
  TX_NO_REASON        = 'A Valid Reason for Study must be entered.';
  TX_BAD_HISTORY      = 'An incomplete or invalid Clinical History has been entered.' + CRLF +
                        'Please correct or clear.';
  TX_NO_DATE          = 'A "Date Desired" must be specified.';
  TX_BAD_DATE         = 'The "Date Desired" you have entered is invalid.';
  TX_PAST_DATE        = '"Date Desired" must not be in the past.';
  TX_APPROVAL_REQUIRED= 'This procedure requires Radiologist approval.' ;
  TX_NO_SOURCE        = 'A source must be specified for Contract/Sharing/Research patients.';
  TX_NO_AGREE         = 'There are no active agreements of the type specified.';
  TX_NO_AGREE_CAP     = 'No Agreements on file';
  TX_ORD_LOC          = 'Ordering location must be specified if patient type and order category do not match.';
  TC_REQ_LOC          = 'Location Required';
  TX_LOC_ORDER        = 'The selected location will be used to determine the ordering location ' +
                        'when the patient location does not match the specified category.';
  TX_NO_CATEGORY      = 'A category of examination must be specified.';
  TX_NO_IMAGING_LOCATION = 'A  "Submit To"  location must be specified.';

var
  Radiologist, Contract, Research: string ;
  AName, IsPregnant: string;
  ALocation, AType: integer;
  
{ TfrmODBase common methods }

procedure TfrmODRad.SetupDialog(OrderAction: Integer; const ID: string);
var
  sl: TStrings;
  tmpResp: TResponse;
  i: integer;
  oldCE: TNotifyEvent;

begin
  inherited;
  if OrderAction in [ORDER_COPY, ORDER_EDIT, ORDER_QUICK] then with Responses do
  begin
    if (OrderAction = ORDER_QUICK) or (OrderAction = ORDER_EDIT) or (OrderAction = ORDER_COPY) then
      FPredefineOrder := True;
    FEditCopy := True;
    Changing := True;
    with cboImType do
      begin
        oldCE := OnChange;
        OnChange := nil;
        try
          SubsetOfImagingTypes(cboImType.Items);
	      for i := 0 to Items.Count-1 do
    	    if StrToIntDef(Piece(Items[i],U,4), 0) = DisplayGroup then ItemIndex := i;
        finally
          OnChange := oldCE;
        end;
        if OrderAction = ORDER_EDIT then
        begin
          Enabled := False;
          Color := clBtnFace;
        end;
     end;
    if Self.EvtID>0 then
      FEvtDelayDiv := GetEventDiv1(IntToStr(Self.EvtID));
//    CtrlInits.LoadDefaults(ODForRad(Patient.DFN, FEvtDelayDiv, DisplayGroup));   // ODForRad returns TStrings with defaults
    sl := TStringList.Create;
    try
      ODForRad(sl, Patient.DFN, FEvtDelayDiv, DisplayGroup);
      CtrlInits.LoadDefaults(sl);
    finally
      sl.free;
    end;
    InitDialog;
    SetControl(cboProcedure,       'ORDERABLE', 1);
    Changing := True;
    SetModifierList;
    SetControl(cboUrgency,         'URGENCY', 1);
    SetControl(cboTransport,       'MODE', 1);
    SetControl(cboSubmit,          'IMLOC', 1);
    SetControl(cboCategory,        'CLASS', 1);
    SetControl(txtReason,           'REASON', 1);
    SetControl(memHistory,         'COMMENT', 1);
    SetControl(chkIsolation,       'YN', 1);
    SetControl(radPregnant,        'PREGNANT', 1);
    SetControl(calPreOp,           'PREOP', 1);
    tmpResp := FindResponseByName('START',1);
    if tmpResp <> nil then
      begin
        if ContainsAlpha(tmpResp.IValue) then
          calRequestDate.Text := tmpResp.IValue
        else
          calRequestDate.FMDateTime := StrToFMDateTime(tmpResp.IValue);
      end;
    tmpResp := FindResponseByName('PROVIDER',1);
    if tmpResp <> nil then with tmpResp do if Length(EValue)>0 then Radiologist := IValue + '^' + EValue;
    if (cboCategory.ItemID = 'C') or (cboCategory.ItemID = 'S') then
      begin
        tmpResp := FindResponseByName('CONTRACT',1);
        if tmpResp <> nil then with tmpResp do
         if Length(EValue)>0 then
          begin
            Contract := IValue + '^' + EValue;
            Research := '';
          end;
      end;
    if cboCategory.ItemID = 'R' then
      begin
        tmpResp := FindResponseByName('RESEARCH',1);
        if tmpResp <> nil then with tmpResp do
         if Length(EValue)>0 then
          begin
            Research := EValue;
            Contract := '';
          end;
      end;
    //hds00007460
    tmpResp := FindResponseByName('PREGNANT',1);
    if tmpResp <> nil then
       if Length(tmpResp.EValue)>0 then
       begin
          IsPregnant := tmpResp.EValue;
          if IsPregnant = 'YES' then
             radPregnant.Checked := True
          else
          if IsPregnant = 'NO' then
             radPregnantNo.Checked := True
          else
          if IsPregnant = 'UNKNOWN' then
             radPregnantUnknown.Checked := True;
       end;
    //hds00007460
    Changing := False;
    FEditCopy := False;
    OrderMessage(ImagingMessage(cboProcedure.ItemIEN)) ;
    ControlChange(Self);
    FPredefineOrder := False;
  end;
end;

procedure TfrmODRad.ShowOrderMessage(Show: boolean);
begin
  inherited;
  pnlRightBase.Height := memOrder.Top - 5;
  pnlLeft.Height := memOrder.Top - 5;
end;

procedure TfrmODRad.tmrBringToFrontTimer(Sender: TObject);
begin
  if FFormFirstOpened then
    inherited
  else
    tmrBringToFront.Enabled := False;
end;

procedure TfrmODRad.txtReasonKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if Key = U then
    key := #0;
end;

procedure TfrmODRad.InitDialog;
var
  i: integer;
  tmplst: TStringList;
  cboSubmitText: String;

  procedure InsertSeperator;
  begin
    if cboProcedure.LongList then
      cboProcedure.InsertSeparator
    else
    begin
      cboProcedure.Items.Add(LLS_LINE);
      cboProcedure.Items.Add(LLS_SPACE);
    end;
  end;

begin
  if not FEditCopy then
  begin
    inherited;
    if not ReasonForStudyCarryOn then txtReason.text := '';
  end;

  FPreOpDate := '';
  FLastRadID := '';
  Radiologist := '';
  Contract := '';
  Research := '';
  ALocation := 0;
  AName := '';
  AType := 0;
  FEvtDelayDiv := '';
  if (Self.EvtID > 0 ) and (FEvtDelayDiv = '') then
    FEvtDelayDiv := GetEventDiv1(IntToStr(Self.EvtID));
  cboProcedure.Clear;
  cboProcedure.LongList := IsRadProcsLongList(DisplayGroup); // RTC 777234
  with CtrlInits do
   begin
    SetControl(cboProcedure, 'ShortList');
    if cboProcedure.Items.Count > 0 then InsertSeperator;
    SetControl(FRadCommonCombo, 'Common Procedures');
    for i := 0 to FRadCommonCombo.Items.Count-1 do
      cboProcedure.Items.Add(FRadCommonCombo.Items[i]);
    if FRadCommonCombo.Items.Count>0 then InsertSeperator;

    //calRequestDate.Text := 'TODAY';     default removed per E3R #19834 - v27.10 - RV
    SetControl(cboAvailMod, 'Modifiers');
    SetControl(cboUrgency, 'Urgencies');
    SetControl(cboTransport, 'Transport');
    with cboTransport do if OrderForInpatient
      then SelectByID('W')
      else SelectByID('A');
    SetControl(cboCategory, 'Category');
    with cboCategory do if OrderForInpatient
      then SelectByID('I')
      else SelectByID('O');
    SetControl(cboSubmit, 'Submit to');
    SetControl(lblAskSubmit,'Ask Submit') ;
    if (cboSubmit.Items.Count = 0) then
      begin
        cboSubmit.ItemIndex := -1;
        lblSubmit.Enabled := False;
        cboSubmit.Enabled := False;
        //TDP - CQ#19393 cboSubmit 508 changes
        cboSubmitText := cboSubmit.Text;
        if cboSubmitText = '' then cboSubmitText := 'No Value';
        setup508Label(cboSubmitText, Submitlbl508, cboSubmit);
        cboSubmit.Font.Color := clGrayText;
      end
    else if (lblAskSubmit.Caption = 'YES') then
      begin
        if (cboSubmit.Items.Count > 1) then
          begin
            tmplst := TStringList.Create;
            try
              FastAssign(cboSubmit.Items, tmplst);
              SortByPiece(tmplst, U, 2);
              FastAssign(tmplst, cboSubmit.Items);
            finally
              tmplst.Free;
            end;
            cboSubmit.ItemIndex := -1 ;
            lblSubmit.Enabled := True;
            cboSubmit.Enabled := True;
            //TDP - CQ#19393 cboSubmit 508 changes
            cboSubmitText := cboSubmit.Text;
            if cboSubmitText = '' then cboSubmitText := 'No Value';
            setup508Label(cboSubmitText, Submitlbl508, cboSubmit);
            cboSubmit.Font.Color := clWindowText;
          end
        else
          begin
            cboSubmit.ItemIndex := 0;
            lblSubmit.Enabled := False;
            cboSubmit.Enabled := False;
            //TDP - CQ#19393 cboSubmit 508 changes
            cboSubmitText := cboSubmit.Text;
            if cboSubmitText = '' then cboSubmitText := 'No Value';
            setup508Label(cboSubmitText, Submitlbl508, cboSubmit);
            cboSubmit.Font.Color := clGrayText;
          end;
      end
    else if lblAskSubmit.Caption = 'NO' then
      begin
        if (cboSubmit.Items.Count = 1) then
          cboSubmit.ItemIndex := 0
        else
          cboSubmit.ItemIndex := -1 ;
        lblSubmit.Enabled := False;
        cboSubmit.Enabled := False;
        //TDP - CQ#19393 cboSubmit 508 changes
        cboSubmitText := cboSubmit.Text;
        if cboSubmitText = '' then cboSubmitText := 'No Value';
        setup508Label(cboSubmitText, Submitlbl508, cboSubmit);
        cboSubmit.Font.Color := clGrayText;
      end;
    chkIsolation.Checked := PatientOnIsolationProcedures(Patient.DFN) ;
    SetControl(lstLastExam, 'Last 7 Days');
   end;
  lstSelectMod.Clear;
  ControlChange(Self);

  StatusText('Initializing Long List');
  if cboProcedure.LongList then
    cboProcedure.InitLongList('')
  else
  begin
    tmplst := SubsetOfRadProcs(DisplayGroup, '', 1);
    cboProcedure.Items.AddStrings(tmplst);
    tmplst.Free;
  end;

  StatusText('');
end;

procedure TfrmODRad.lblImTypeClick(Sender: TObject);
begin
  inherited;
  if FMissingGroupsMessage <> '' then
    ShowMessage(FMissingGroupsMessage);
end;

procedure TfrmODRad.ControlChange(Sender: TObject);
var
  i: integer ;
begin
  inherited;
  if Changing then Exit;
  Responses.Clear;
  with cboProcedure do
    if ItemIEN > 0 then Responses.Update('ORDERABLE', 1, ItemID, Text)
    else Responses.Update('ORDERABLE', 1, ''    , '');
  //with calRequestDate do if FMDateTime > 0 then     RPC call on EVERY character typed in REASON box!!!!  (v15)
  with calRequestDate do if Length(Text) > 0 then
    Responses.Update('START', 1, Text, Text)
    else Responses.Update('START', 1, '', '') ;
  with cboUrgency do if Length(ItemID)   > 0 then Responses.Update('URGENCY',   1, ItemID, Text);
  with cboTransport do if Length(ItemID) > 0 then Responses.Update('MODE',      1, ItemID, Text);
  with cboCategory do if Length(ItemID)  > 0 then Responses.Update('CLASS',     1, ItemID, Text);
  with cboSubmit do if Length(ItemID)    > 0 then Responses.Update('IMLOC',     1, ItemID, Text);
  with radPregnant do if Checked                then Responses.Update('PREGNANT',  1, 'Y'   , 'Yes')
                 else if not Enabled         then Responses.Update('PREGNANT',  1, ''    , '');
  with radPregnantNo do if Checked           then Responses.Update('PREGNANT',  1, 'N'   , 'No');
  with radPregnantUnknown do if Checked      then Responses.Update('PREGNANT',  1, 'U'   , 'Unknown');
  with chkIsolation do if Checked            then Responses.Update('YN',        1, '1'   , 'Yes')
                                             else Responses.Update('YN',        1, '0'   , 'No');
  with calPreOp do if Length(Text)       > 0 then Responses.Update('PREOP',     1, FPreOpDate, Text);
  with txtReason  do if GetTextLen       > 0 then Responses.Update('REASON',    1, Text, Text);
  with memHistory do if GetTextLen       > 0 then Responses.Update('COMMENT',   1, TX_WPTYPE, Text);
  with lstSelectMod do for i := 0 to Items.Count - 1 do
                                                  Responses.Update('MODIFIER',i+1, Piece(Items[i],U,1), Piece(Items[i],U,2));
  Responses.Update('PROVIDER',1, Piece(Radiologist,U,1),Piece(Radiologist,U,2)) ;
  Responses.Update('CONTRACT',1, Piece(Contract,U,1),Piece(Contract,U,2)) ;
  Responses.Update('RESEARCH',1, Research, Research) ;
  if ALocation > 0 then  Responses.Update('LOCATION', 1, IntToStr(ALocation), AName)
  else with Encounter do Responses.Update('LOCATION', 1, IntToStr(Location) , LocationName);
  memOrder.Text := Responses.OrderText;
end;

//TDP - CQ#19393 Made history memobox read text
procedure TfrmODRad.VA508ComponentAccessibility1StateQuery(Sender: TObject;
  var Text: string);
begin
  inherited;
  Text := memHistory.Text;
end;

procedure TfrmODRad.Validate(var AnErrMsg: string);
var
  i, j: integer;
  AskLoc: boolean;
  ch: Char;
  MaxDays: Double;
  MaxDate: TDateTime;
  ALongMessage: String;

  procedure SetError(const x: string);
  begin
    if Length(AnErrMsg) > 0 then AnErrMsg := AnErrMsg + CRLF;
    AnErrMsg := AnErrMsg + x;
  end;

  procedure GetOrderingLocation(AType: integer);
  begin
    ALocation := 0;
    AName := '';
    LookupLocation(ALocation, AName, AType, TX_LOC_ORDER);
    if ALocation = 0 then
      begin
        SetError(TX_ORD_LOC);
        if OrderForInpatient then cboCategory.SelectByID('I') else cboCategory.SelectByID('O');
        with Encounter do Responses.Update('LOCATION', 1, IntToStr(Location) , LocationName);
      end
    else
      Responses.Update('LOCATION', 1, IntToStr(ALocation), AName);
  end;

begin
  inherited ;
  with cboProcedure do
    begin
      if ((Length(Text) = 0) or (ItemIEN <= 0)) then SetError(TX_NO_PROC)
      else
        begin
          if ItemID <> FLastRadID then Responses.Update('PROVIDER',1, '','');
          if (UpperCase(Piece(Items[ItemIndex],U,4))='Y') and (Radiologist='') then
           begin
             SelectApprovingRadiologist(Font.Size, Radiologist);
             if Radiologist='' then  SetError(TX_APPROVAL_REQUIRED)
             else
               Responses.Update('PROVIDER',1, Piece(Radiologist,U,1),Piece(Radiologist,U,2)) ;
           end ;
        end ;
    end;

  with cboUrgency do
    begin
      if ((Length(Text) = 0) or (ItemIEN <= 0)) then SetError(TX_NO_URG)
    end;

  if Length(txtReason.Text) < 3 then
    SetError(TX_NO_REASON)
  else if pos(U, txtReason.Text) > 0 then
    SetError(TX_BAD_REASON)
  else
  begin
    j := 0;
    for i := 1 to Length(txtReason.Text) do
    begin
      ch := txtReason.Text[i];
      if CharInSet(ch, ['A'..'Z','a'..'z','0'..'9']) then j := j + 1;
      if not CharInSet(ch, ['A'..'Z','a'..'z','0'..'9']) and (j > 0) then j := 0;
      if ord(ch) < 32 then // Control Character
      begin
        SetError(TX_INVALID_REASON);
        j := 2;
      end;
      if j = 2 then break;
    end;
    if j < 2 then SetError(TX_NO_REASON);
  end;

  if Length(memHistory.Text) > 0 then
  begin
    j := 0;
    for i := 1 to Length(memHistory.Text) do
      begin
        if CharInSet(memHistory.Text[i], ['A'..'Z','a'..'z','0'..'9']) then j := j + 1;
        if not CharInSet(memHistory.Text[i], ['A'..'Z','a'..'z','0'..'9']) and (j > 0) then j := 0;
        if j = 2 then break;
      end;
    if j < 2 then SetError(TX_BAD_HISTORY);
  end;

  with cboCategory do
    begin
      AskLoc := (ALocation = 0);
      if ((not Patient.Inpatient) and (Self.EvtType = 'A')) then
        AskLoc := False;
      if ItemID = '' then SetError(TX_NO_CATEGORY);
      if CharInSet(CharAt(ItemID,1), ['C','S']) and (Contract = '') then SetError(TX_NO_SOURCE);
      if (CharAt(ItemID, 1) = 'R')       and (Research = '') then SetError(TX_NO_SOURCE);
      if ((CharAt(ItemID, 1) = 'O') and (LocationType(Encounter.Location) = 'W')) then
      begin
        if AskLoc then
          GetOrderingLocation(LOC_OUTP);
      end
      else if ((CharAt(ItemID, 1) = 'I') and (not (LocationType(Encounter.Location) = 'W'))) then
      begin
        if AskLoc then
          GetOrderingLocation(LOC_INP);
      end;
    end;
  if Length(cboTransport.Text) = 0 then SetError(TX_NO_MODE);

  with cboSubmit do
    if Enabled and (ItemIEN = 0)then SetError(TX_NO_IMAGING_LOCATION);

  MaxDays := SystemParameters.AsTypeDef<Double>('radiologyFutureDateLimit',0);
  MaxDate := FMDateTimeToDateTime(FMToday) + MaxDays;
  with calRequestDate do
  begin
    if FMDateTime = 0 then
      SetError(TX_NO_DATE)
    else if FMDateTime < 0 then
      SetError(TX_BAD_DATE)
    else if FMDateTime < FMToday then
      SetError(TX_PAST_DATE)
    else if FMDateTimeToDateTime(FMDateTime) > MaxDate then
      begin
        ALongMessage := TX_BAD_DATE + CRLF + 'Please choose a date between ' +
          FormatFMDateTime('mm/dd/yyyy', FMToday) + ' and ' +
            FormatDateTime('mm/dd/yyyy',MaxDate);
        SetError(ALongMessage);
      end;
  end;

end;

procedure TfrmODRad.cboProcedureNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
var
  sl: TStrings;
begin
  inherited;
  // cboProcedure.ForDataUse(SubSetOfRadProcs(DisplayGroup, StartFrom, Direction));
  sl := SubSetOfRadProcs(DisplayGroup, StartFrom, Direction);
  try
    cboProcedure.ForDataUse(sl);
  finally
    sl.Free;
  end;
end;

procedure TfrmODRad.cboAvailModMouseClick(Sender: TObject);
var
  x: string;
  i: integer;
  Found: boolean;
begin
  if (cboAvailMod.Items.Count < 1) or  //GE 04-30-05 prevent list index out of bounds when empty
     (cboAvailMod.ItemIndex < 0) then Exit;
  Found := False;
  with cboAvailMod do x := Items[ItemIndex];
  with lstSelectMod do
    begin
      if Items.Count > 0 then
        for i := 0 to Items.Count - 1 do
          if Items[i] = x then Found := True;
      if not Found then
        begin
          Items.Add(x);
          SelectByID(Piece(x, U, 1));
        end;
    end;
  if Piece(x, '^', 2) = 'PORTABLE EXAM' then
    cboTransport.SelectByID('P');
  ControlChange(Sender);
end;

procedure TfrmODRad.cmdRemoveClick(Sender: TObject);
begin
  with lstSelectMod do
     if (SelCount = 0) or (ItemIndex < 0) then exit
     else
      begin
       if Piece(Items[ItemIndex], U, 2) = 'PORTABLE EXAM' then
         with cboTransport do if OrderForInpatient
           then SelectByID('W')
           else SelectByID('A');
       Items.Delete(ItemIndex);
       ItemIndex := Items.Count - 1;
       if ItemIndex > -1 then SelectByID(Piece(Items[ItemIndex], U, 1));
      end ;
  ControlChange(Sender);
end;

procedure TfrmODRad.cboProcedureSelect(Sender: TObject);
var
  tmpResp: TResponse;
begin
  inherited;
  with cboProcedure do
   begin
    if ItemID <> FLastRadID then
     begin
       FLastRadID := ItemID;
       if FPredefineOrder then
         FPredefineOrder := False;
     end else Exit;
    Changing := True;
    if Sender <> Self then
      Responses.Clear;       // Sender=Self when called from SetupDialog
    ClearControl(lstSelectMod);
    ClearControl(lstLastExam);
    //ClearControl(memHistory);    {WPB-1298-30758}
    Changing := False;
    if CharAt(ItemID, 1) = 'Q' then
     with Responses do
       begin
         QuickOrder := ExtractInteger(ItemID);
         //SetControl(cboProcedure, 'ORDERABLE', 1);   //v22.9 - RV
         //SetModifierList;                            //v22.9 - RV
         FLastRadID := ItemID;
       end;
   end;
   with Responses do if QuickOrder > 0 then
   begin
    Changing := True;
    SetControl(cboProcedure,       'ORDERABLE', 1);
    SetModifierList;                                   //v22.9 - RV
    SetControl(lstSelectMod,       'MODIFIER', 1);
    SetControl(cboUrgency,         'URGENCY', 1);
    SetControl(cboSubmit,          'IMLOC', 1);
    SetControl(cboTransport,       'MODE', 1);
    SetControl(cboCategory,        'CLASS', 1);
    SetControl(txtReason,          'REASON', 1);
    SetControl(memHistory,         'COMMENT', 1);
    SetControl(chkIsolation,       'YN', 1);
    SetControl(radPregnant,        'PREGNANT', 1);
    SetControl(calPreOp   ,        'PREOP', 1);
    tmpResp := FindResponseByName('START',1);
    if tmpResp <> nil then
      begin
        if ContainsAlpha(tmpResp.IValue) then
          calRequestDate.Text := tmpResp.IValue
        else
          calRequestDate.FMDateTime := StrToFMDateTime(tmpResp.IValue);
      end;
    Changing := False;
   end;
  OrderMessage(ImagingMessage(cboProcedure.ItemIEN)) ;
  ControlChange(Self);
end;

procedure TfrmODRad.SetModifierList;
var
  i: integer;
  tmpResp: TResponse;
begin
  i := 1;
  tmpResp := Responses.FindResponseByName('MODIFIER',i);
  while tmpResp <> nil do
    begin
      lstSelectMod.Items.Add(tmpResp.IValue + '^' + tmpResp.EValue);
      if tmpResp.EValue = 'PORTABLE EXAM' then
        with cboTransport do SelectByID('P');
      Inc(i);
      tmpResp := Responses.FindResponseByName('MODIFIER',i);
    end ;
end;

procedure TfrmODRad.cboCategoryChange(Sender: TObject);
var
  Source: string;
begin
  inherited;
  if Contract <> '' then Source := Contract
  else if Research <> '' then Source := Research
  else Source := '';
  Contract := '';
  Research := '';
  with cboCategory do
    begin
      if CharInSet(CharAt(ItemID,1), ['C','S','R']) then
        begin
          SelectSource(Font.Size, CharAt(ItemID,1), Source);
          if Source = '-1' then
            InfoBox(TX_NO_AGREE, TX_NO_AGREE_CAP, MB_OK or MB_ICONWARNING)
          else if CharInSet(CharAt(ItemID,1), ['C','S']) then
            Contract := Source
          else if ItemID='R' then
            Research := Source;
        end;
    end;
  ControlChange(Self);
end;

procedure TfrmODRad.FormCreate(Sender: TObject);
var
  DGAccess: TWriteAccess.TDGWriteAccess;

begin
  FFormFirstOpened := TRUE;
  ImageTypeChanged := false;
  frmFrame.pnlVisit.Enabled := false;
  AutoSizeDisabled := True;
  inherited;
  memHistory.Width := pnlHandR.ClientWidth;
  memHistory.Height := pnlHandR.ClientHeight - memHistory.Top;
  FillerID := 'RA';                     // does 'on Display' order check **KCM**
  StatusText('Loading Dialog Definition');
  Responses.Clear;
  DisplayGroup := 0;
  AllowQuickOrder := True;
  Responses.Dialog := 'RA OERR EXAM';              // loads formatting info
  StatusText('Loading Default Values');
  SubsetOfImagingTypes(cboImType.Items);
  if Self.EvtID>0 then
    FEvtDelayDiv := GetEventDiv1(IntToStr(Self.EvtID));
  PreserveControl(cboImType);
  PreserveControl(calRequestDate);
  PreserveControl(cboUrgency);
  PreserveControl(cboTransport);
  PreserveControl(cboSubmit);
  PreserveControl(cboCategory);
  PreserveControl(calPreOp);
  PreserveControl(txtReason);
  PreserveControl(memHistory);      {WPB-1298-30758}
  if (Patient.Sex <> 'F') then
  begin
    //TDP - CQ#19393 change to allow grpPregnant to be tabbed to if screen reader active
    if ScreenReaderSystemActive then grpPregnant.TabStop := True;
    radPregnant.Enabled := False;
    radPregnantNo.Enabled := False;
    radPregnantUnknown.Enabled := False;
  end else SetDefaultPregant;
  FormMonitorBringToFrontEvent(Self, FormFirstOpened);

  DGAccess := WriteAccessV.DGWriteAccess(ImgDisp);
 if assigned(DGAccess) and (DGAccess is TWriteAccess.TDGWriteAccessParent) then
    with DGAccess as TWriteAccess.TDGWriteAccessParent do
    begin
      if MissingGroups <> '' then
      begin
        FMissingGroupsMessage := 'Only imaging types for ' + AccessGroups +
          ' are displayed.  Additional imaging types would be available if you had write access to '
          + MissingGroups;
        lblImType.Font.Color := clBlue;
        lblImType.Font.Style := [fsUnderline];
        lblImType.Cursor := crHandPoint;
      end;
    end;
  StatusText('');
end;

{Assigned to cbolmType.OnDropDownClose and cbolmType.OnExit, instead of
 cbolmType.OnChange, becuase when it is OnChange the delay interfers with
 Window-Eyes ability to read the drop-down Items.}
procedure TfrmODRad.cboImTypeChange(Sender: TObject);
begin
  inherited;
  ImageTypeChanged := true;
end;

procedure TfrmODRad.memHistoryExit(Sender: TObject);
var
  AStringList: TStringList;
begin
  inherited;
  AStringList := TStringList.Create;
  try
    FastAssign(memHistory.Lines, AStringList);
    LimitStringLength(AStringList, 74);
    FastAssign(AstringList, memHistory.Lines);
    ControlChange(Self);
  finally
    AStringList.Free;
  end;
end;

procedure TfrmODRad.FormResize(Sender: TObject);
begin
  inherited;
  memHistory.Width := pnlHandR.ClientWidth;
  memHistory.Height := pnlHandR.ClientHeight - memHistory.Top;
end;

procedure TfrmODRad.cboAvailModKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = VK_RETURN then cboAvailModMouseClick(Self);
end;

procedure TfrmODRad.calPreOpChange(Sender: TObject);
begin
  inherited;
  FPreOpDate := FloatToStr(calPreOp.FMDateTime);
  ControlChange(Self);
end;

procedure TfrmODRad.SetDefaultPregant;
begin
  if (Patient.Sex = 'F') and ((Patient.Age > 55) or (Patient.Age < 12)) then
  begin
    radPregnantNo.Checked := True;
    grpPregnant.TabStop := False;
  end;
end;

procedure TfrmODRad.SetFontSize(FontSize: integer);
begin
  Self.Font.Size := FontSize;
  Width := pnlLeft.ClientWidth + pnlRightBase.ClientWidth + 20;
  Height := pnlRightBase.ClientHeight + memOrder.ClientHeight + 50;
end;

procedure TfrmODRad.cmdAcceptClick(Sender: TObject);
const
  Txt1 = 'This order can not be saved for the following reason(s):';
  Txt2 = #13+#13+'A response for the pregnant field must be selected.';
var
  NeedCheckPregnant: boolean;
begin
  if Patient.Sex = 'F' then
  begin
    NeedCheckPregnant := True;
    if radPregnant.Checked then NeedCheckPregnant := False
    else if radPregnantNo.Checked then NeedCheckPregnant := False
    else if radPregnantUnknown.Checked then NeedCheckPregnant := False;
    if NeedCheckPregnant then
    begin
      MessageDlg(Txt1+Txt2, mtWarning,[mbOK],0);
      Exit;
    end;
  end;
  inherited;
end;

//TDP - CQ#19393 cboSubmit 508 changes. Can change in future to be generic if needed. (See fODLab.pas)
procedure TfrmODRad.setup508Label(text: string; lbl: TVA508StaticText; ctrl: TControl);
begin
  if ScreenReaderSystemActive and not ctrl.Enabled then begin
    lbl.Enabled := True;
    lbl.Visible := True;
    lbl.Caption := lblSubmit.Caption + '. Read Only. Value is ' + Text;
    lbl.Width := lblSubmit.Width + 2;
  end else
    lbl.Visible := false;
end;

procedure TfrmODRad.cboProcedureExit(Sender: TObject);
var
  i: integer;
  ModList: TStringList;
begin
  inherited;
  ModList := TStringList.Create;
  if lstSelectMod.Items.Count > 0 then
    for i := 0 to lstSelectMod.Count - 1 do
      ModList.Add(lstSelectMod.Items[i]);
  cboProcedureSelect(Self);
  for i := 0 to ModList.Count - 1 do
  begin
    lstSelectMod.Items.Add(ModList[i]);
    lstSelectMod.SelectByID(Piece(ModList[i],U,1));
  end;
  with lstSelectMod do
    for i := 0 to Items.Count - 1 do
      Responses.Update('MODIFIER',i+1, Piece(Items[i],U,1), Piece(Items[i],U,2));
  //TDP - Made Order Message next focus if showing and Tab or Entered was pressed
  if (pnlMessage.Showing) AND ((TabIsPressed()) OR (EnterIsPressed())) then memMessage.SetFocus;
end;


procedure TfrmODRad.cboImTypeExit(Sender: TObject);
begin
  inherited;
  ImageTypeChange;
end;

procedure TfrmODRad.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  pnlMessage.Visible := False;
  ClientHeight := memOrder.BoundsRect.Bottom + 11;
  inherited;
  frmFrame.pnlVisit.Enabled := true;
  FormMonitorBringToFrontEvent(Self, nil);
end;

procedure TfrmODRad.chkIsolationExit(Sender: TObject);
begin
  inherited;
  //Fix for CQ: 10025
  if TabIsPressed() then
    if NoPregnantSelection() then
      if radPregnant.CanFocus then
        radPregnant.SetFocus();
end;

procedure TfrmODRad.calPreOpExit(Sender: TObject);
begin
  inherited;
  //Fix for CQ: 10025
  if ShiftTabIsPressed() then
    if NoPregnantSelection() then
      if radPregnant.CanFocus then
        radPregnant.SetFocus();
end;

function TfrmODRad.NoPregnantSelection : Boolean;
begin
  result := not ((radPregnant.Checked) or (radPregnantNo.Checked) or (radPregnantUnknown.Checked));
end;

{TDP - Added to control where focus went now that pnlMessage was being focused
       out of turn after cboProcedure.}
procedure TfrmODRad.pnlMessageExit(Sender: TObject);
begin
  inherited;
  if TabIsPressed() then cboAvailMod.SetFocus;
  if ShiftTabIsPressed() then cboProcedure.SetFocus;
end;

{TDP - Added to control where focus went now that pnlMessage was being focused
       out of turn after cboProcedure.}
procedure TfrmODRad.pnlMessageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  cboProcedure.SetFocus;
end;

procedure TfrmODRad.cboImTypeDropDownClose(Sender: TObject);
begin
  inherited;
  ImageTypeChange;
end;

procedure TfrmODRad.ImageTypeChange;
var
  sl: TStringList;
begin
  if not ImageTypeChanged then Exit;
  ImageTypeChanged := false;
  if FPredefineOrder then
    FPredefineOrder := False;
  if Changing or (cboImtype.ItemIndex = -1) then exit;
  with cboImType do DisplayGroup := StrToIntDef(Piece(Items[ItemIndex], U, 4), 0) ;
  if DisplayGroup = 0 then exit;
//  CtrlInits.LoadDefaults(ODForRad(Patient.DFN, FEvtDelayDiv, DisplayGroup));   // ODForRad returns TStrings with defaults
  sl := TStringList.Create;
  try
    ODForRad(sl, Patient.DFN, FEvtDelayDiv, DisplayGroup);
    CtrlInits.LoadDefaults(sl);
  finally
    sl.Free;
  end;
  FPredefineOrder := False;
  InitDialog;
end;

procedure TfrmODRad.FormFirstOpened(Sender: TObject);
begin
  if(FFormFirstOpened) then
  begin
    FFormFirstOpened := FALSE;
    BringToFront;
    with cboImType do
      if not FEditCopy and (ItemIEN = 0) and (DroppedDown = False) and (Application.Active) then
      begin
        cboImType.DroppedDown := TRUE;
      end;
  end;
end;

end.
