unit fEncVitals;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fPCEBase, ORDtTm, StdCtrls, ORCtrls, ExtCtrls, Buttons, fAutoSz, ORFn,
  rvitals, ComCtrls, ORNet, uVitals, VAUtils, TRPCB, VA508AccessibilityManager;

type
  TfrmEncVitals = class(TfrmPCEBase)
    pnlmain: TPanel;
    lblDate: TStaticText;
    lblDateBP: TStaticText;
    lblDateTemp: TStaticText;
    lblDateResp: TStaticText;
    lblDatePulse: TStaticText;
    lblDateHeight: TStaticText;
    lblDateWeight: TStaticText;
    lblLstMeas: TStaticText;
    lbllastBP: TStaticText;
    lblLastTemp: TStaticText;
    lblLastResp: TStaticText;
    lblLastPulse: TStaticText;
    lblLastHeight: TStaticText;
    lblLastWeight: TStaticText;
    lblVitPointer: TOROffsetLabel;
    lblVital: TStaticText;
    lblVitBP: TStaticText;
    lnlVitTemp: TStaticText;
    lblVitResp: TStaticText;
    lblVitPulse: TStaticText;
    lblVitHeight: TStaticText;
    lblVitWeight: TStaticText;
    txtMeasBP: TCaptionEdit;
    cboTemp: TCaptionComboBox;
    txtMeasTemp: TCaptionEdit;
    txtMeasResp: TCaptionEdit;
    cboHeight: TCaptionComboBox;
    txtMeasWt: TCaptionEdit;
    cboWeight: TCaptionComboBox;
    txtMeasDate: TORDateBox;
    lblVitPain: TStaticText;
    lblLastPain: TStaticText;
    lblDatePain: TStaticText;
    cboPain: TORComboBox;
    txtMeasPulse: TCaptionEdit;
    txtMeasHt: TCaptionEdit;
    pnlBottom: TPanel;
    lvVitals: TCaptionListView;
    btnEnterVitals: TButton;
    btnOKkludge: TButton;
    btnCancelkludge: TButton;
    procedure SetVitPointer(Sender: TObject);
    procedure txtMeasBPExit(Sender: TObject);
    procedure cboTempChange(Sender: TObject);
    procedure cboTempExit(Sender: TObject);
    procedure txtMeasRespExit(Sender: TObject);
    procedure txtMeasPulseExit(Sender: TObject);
    procedure cboHeightChange(Sender: TObject);
    procedure cboHeightExit(Sender: TObject);
    procedure cboWeightChange(Sender: TObject);
    procedure cboWeightExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lbllastClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    function HasData: Boolean;
    function AssignVitals: boolean;
    procedure cboPainChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure txtMeasTempExit(Sender: TObject);
    procedure txtMeasHtExit(Sender: TObject);
    procedure txtMeasWtExit(Sender: TObject);
    procedure btnEnterVitalsClick(Sender: TObject); //vitals lite
  private
    FDataLoaded: boolean;
    FChangingFocus: boolean;
    UvitalNew: TStringList;
    uVitalOld: TSTringList;
    procedure InitVitalPanel;
    procedure PopulateLastVital;
    function GetVitHTRate: String;
    procedure CheckVitalUnit;
    procedure ChangeFocus(Control: TWinControl);
    procedure ClearData;
    procedure LoadVitalView(VitalsList : TStringList); //Vitals Lite
    procedure LoadVitalsList;
  public
    function OK2SaveVitals: boolean;
    property VitalNew: TStringList read uVitalNew;
    property VitalOld: TStringList read uVitalOld;
  end;

var
  frmEncVitals: TfrmEncVitals;
//  uVitalLocation: Real;

implementation

{$R *.DFM}

uses UCore, rCore, rPCE, fPCELex, fPCEOther, fVitals,fVisit, fFrame, fEncnt,
     fEncounterFrame, uInit, VA508AccessibilityRouter, System.UITypes;

const
  TX_VDATE_REQ1 = 'Entered vitals information can not be saved without a Date.' + CRLF +
                  'Do you wish to use the encounter date of ';
  TX_VDATE_REQ2 = '?';
  TC_VDATE_REQ = 'Missing Vitals Entry Date';

  TX_KILLDATA = 'Discard entered vitals information?';

var
  UcboVitChanging:      Boolean = False;

function TfrmEncVitals.HasData: Boolean;
begin
  result := False;
  if ((txtMeasBP.text <> '') or (txtMeasTemp.text <> '') or (txtMeasResp.text <> '') or
    (txtMeasPulse.text <> '') or (txtMeasHt.text <> '') or (txtMeasWt.text <> '')) or
    (cboPain.text <>'') then
    result := True;
end;

procedure TfrmEncVitals.InitVitalPanel;
begin
  lblDate.font.Style := [fsBold];
  lblDateBP.font.Style := [fsBold];
  lblDateTemp.font.Style := [fsBold];
  lblDateResp.font.Style := [fsBold];
  lblDatePulse.font.Style := [fsBold];
  lblDateHeight.font.Style := [fsBold];
  lblDateWeight.font.Style := [fsBold];
  lblDatePain.font.style := [fsBold];
  lblLstMeas.font.Style := [fsBold];
  lblLastBP.font.Style := [fsBold];
  lblLastTemp.font.Style := [fsBold];
  lblLastResp.font.Style := [fsBold];
  lblLastPulse.font.Style := [fsBold];
  lblLastHeight.font.Style := [fsBold];
  lblLastWeight.font.Style := [fsBold];
  lblLastPain.font.style := [fsBold];
  lblVital.font.Style := [fsbold];

  {Use this area to read parameter for units and set apropriately
   after parameter is defined. in next version
  }
  UcboVitchanging := true; //prevents entering code in CheckVitalUnit

  try
    InitPainCombo(cboPain);
    cboTemp.Text := cboTemp.Items[0];
    cboHeight.Text := cboHeight.Items[0];
    cboWeight.Text := cboWeight.Items[0];
  finally
    UcboVitchanging := False; //prevents entering code in CheckVitalUnit
  end;

  if txtMeasDate.Text = '' then
    txtMeasDate.Text := FormatFMDateTime('dddddd@hh:nn', uEncPCEData.VisitDateTime);
  if (UvitalOld.text = '') then
    PopulateLastVital;
end;


procedure TfrmEncVitals.PopulateLastVital;
var
 i: integer;
begin
  GetLastVital(uVitalOld,Patient.DFN);
  //populate labels from UVitalOld;
  with UVitalOld do
  for i := 0 to count-1 do
  begin
    if piece(strings[i],U,2) = 'T' then
    begin
      lblLastTemp.Caption := ConvertVitalData(piece(strings[i],U,3), vtTemp);
      lblDateTemp.Caption := FormatFMDateTime('dddddd',
        StrToFloat(piece(strings[i],U,4)));
    end;
    if piece(strings[i],U,2) = 'P' then
    begin
      lblLastPulse.Caption := piece(strings[i],U,3);
      lblDatePulse.Caption := FormatFMDateTime('dddddd',
        StrToFloat(piece(strings[i],U,4)));
    end;
    if piece(strings[i],U,2) = 'R' then
    begin
      lblLastResp.Caption := piece(strings[i],U,3);
      lblDateResp.Caption := FormatFMDateTime('dddddd',
        StrToFloat(piece(strings[i],U,4)));
    end;
    if piece(strings[i],U,2) = 'BP' then
    begin
      lblLastBP.Caption := piece(strings[i],U,3);
      lblDateBP.Caption := FormatFMDateTime('dddddd',
        StrToFloat(piece(strings[i],U,4)));
    end;
    if piece(strings[i],U,2) = 'HT' then
    begin
      lblLastHeight.Caption := ConvertVitalData(piece(strings[i],U,3), vtHeight);
      lblDateHeight.Caption := FormatFMDateTime('dddddd',
        StrToFloat(piece(strings[i],U,4)));
    end;
    if piece(strings[i],U,2) = 'WT' then
    begin
      lblLastWeight.Caption := ConvertVitalData(piece(strings[i],U,3), vtWeight);
      lblDateWeight.Caption := FormatFMDateTime('dddddd',
        StrToFloat(piece(strings[i],U,4)));

    end;
   if piece(strings[i],U,2) = 'PN' then
    begin
      lblLastPain.Caption := piece(strings[i],U,3);
      lblDatePain.Caption := FormatFMDateTime('dddddd',
        StrToFloat(piece(strings[i],U,4)));
    end;
  end;
end;


procedure TfrmEncVitals.SetVitPointer(Sender: TObject);
begin
  if ActiveCtrl.tag in VitalTagSet then
  begin
    // move pointer to some height and five pixels to right of edit box.
    lblVitPointer.Top := ActiveCtrl.Top+((ActiveCtrl.height ) div
    (lblVitPointer.height ));

    if ActiveCtrl = txtMeasTemp then
      lblVitPointer.left := (cboTemp.left + cboTemp.Width)
    else if ActiveCtrl = txtMeasHT then
      lblVitPointer.left := (cboHeight.left + cboHeight.Width)
    else if ActiveCtrl = txtMeasWT then
      lblVitPointer.left := (cboWeight.left + cboWeight.Width)
    else
      lblVitPointer.left := (ActiveCtrl.left + ActiveCtrl.Width);

  end;
end;


function TfrmEncVitals.GetVitHTRate: String;
begin
  Result := ConvertHeight2Inches(txtMeasHT.Text);
  txtMeasHT.text := result;
end;

function TfrmEncVitals.AssignVitals: boolean;
var
  TmpDate: TFMDateTime;

begin
  TmpDate := txtMeasDate.FMDateTime;
  Result := ValidVitalsDate(TmpDate);
  if Result then
    AssignVitals2List(uVitalNew, TmpDate, FloatToStr(PCERPCEncLocation),
                       txtMeasBP.text, txtMeasTemp.text, cboTemp.text,
                       txtMeasResp.text, txtMeasPulse.text, GetVitHTRate, cboHeight.text,
                       txtMeasWT.text, cboWeight.text, cboPain.ItemID);
end;

procedure TfrmEncVitals.cboTempChange(Sender: TObject);
begin
  inherited;
  if not (cbotemp.droppeddown) then
    CheckVitalUnit;
end;


procedure TfrmEncVitals.CheckVitalUnit;
var
  len,i: integer;
  found: boolean;
  comp: string; //substring for comparing
  temp: string;
begin
  if (UcboVitchanging = true) then exit;

  UcboVitChanging := true;
  try
    with ActiveCtrl as TComboBox do
    begin
       found := False;
       temp := text;
       while (found = false) and (Length(temp) > 0) do
       begin
          i := 0;
          while (found = false) and (length(items[i]) > 0) do
          begin
          len := length(temp);
          //match text to string
          comp := copy(items[i],0,len);
          if (CompareText(comp,temp) = 0) then
          begin
             found := true;
             Text := '';
             text := items[i];

          end;
          inc(i);
          end;
          if (found = false) then Delete(temp,1,1);
       end;
       if (found = False) then
       begin
          Text := '';
       end;
    end;
  finally
    UcboVitChanging := false;
  end;
end;


procedure TfrmEncVitals.cboHeightChange(Sender: TObject);
begin
  inherited;
  CheckVitalUnit;
end;

procedure TfrmEncVitals.cboWeightChange(Sender: TObject);
begin
  inherited;
  CheckVitalUnit;
end;

procedure TfrmEncVitals.txtMeasBPExit(Sender: TObject);
begin
  inherited;
  if VitalInvalid(txtMeasBP) then
    ChangeFocus(txtMeasBP);
end;

procedure TfrmEncVitals.cboTempExit(Sender: TObject);
begin
  inherited;
  if(ActiveCtrl <> txtMeasTemp) then
  begin
    if VitalInvalid(txtMeasTemp, cboTemp) then
      ChangeFocus(txtMeasTemp);
  end;
end;

procedure TfrmEncVitals.txtMeasRespExit(Sender: TObject);
begin
  inherited;
  if VitalInvalid(txtMeasResp) then
    ChangeFocus(txtMeasResp);
end;

procedure TfrmEncVitals.txtMeasPulseExit(Sender: TObject);
begin
  inherited;
  if VitalInvalid(txtMeasPulse) then
    ChangeFocus(txtMeasPulse);
end;

procedure TfrmEncVitals.cboHeightExit(Sender: TObject);
begin
  inherited;
  if(ActiveCtrl <> txtMeasHt) then
  begin
    if VitalInvalid(txtMeasHt, cboHeight, GetVitHTRate) then
      ChangeFocus(txtMeasHt);
  end;
end;

procedure TfrmEncVitals.cboWeightExit(Sender: TObject);
begin
  inherited;
  if(ActiveCtrl <> txtMeasWt) then
  begin
    if VitalInvalid(txtMeasWt, cboWeight) then
      ChangeFocus(txtMeasWt);
  end;
end;


procedure TfrmEncVitals.FormCreate(Sender: TObject);
begin

  inherited;
  FTabName := CT_VitNm;
  //uVisitType := TPCEProc.create;
  uVitalOld  := TStringList.create;
  uVitalNew  := TStringList.create;

end;



procedure TfrmEncVitals.FormDestroy(Sender: TObject);

begin
  //uVisitType.Free;
  uVitalOld.Free;
  uVitalNew.free;

{== Vitals Lite 2004-05-21 ===================================================}
  UnloadVitalsDLL;
{== Vitals Lite 2004-05-21 ===================================================}
  inherited;
end;




procedure TfrmEncVitals.lbllastClick(Sender: TObject);
begin
  inherited;
  //
  try
    frmEncVitals.Show;
  except
    with sender as TStaticText do
      SelectVital(self.Font.Size, tag);
  end; //end of try
end;


procedure TfrmEncVitals.FormShow(Sender: TObject);
begin
  inherited;
  //Begin Vitals Lite
  {Visit is Assumed to Be selected when Opening Encounter Dialog}
  LoadVitalsDLL;
  if VitalsDLLHandle = 0 then // No Handle found
    MessageDLG('Can''t find library '+VitalsDLLName+'.',mtError,[mbok],0)
  else
    LoadVitalsList;
  //End Vitals Lite
//  frmEncVitals.caption := 'Vital entry for - '+ patient.name; {RAB 6/15/98}
  FormActivate(Sender);
end;

procedure TfrmEncVitals.FormActivate(Sender: TObject);
begin
  inherited;
  if(not FChangingFocus) and (not FDataLoaded) then
  begin
    FDataLoaded := TRUE;
    InitVitalPanel;
//    txtMeasTemp.setfocus;  //added 3/30/99 after changing tab order.
                         //The date is now first in tab order, but it shouldn't default there.
  end;
end;



procedure TfrmEncVitals.cboPainChange(Sender: TObject);
begin
  inherited;
  CheckVitalUnit;
end;

procedure TfrmEncVitals.FormResize(Sender: TObject);
begin
  inherited;
  //added to make things austo size that do not heave the property.
  cboTemp.height := txtmeastemp.height;
  cboPain.height := txtmeastemp.height;
  cboheight.height := txtmeastemp.height;
  cboweight.height := txtmeastemp.height;
end;

procedure TfrmEncVitals.txtMeasTempExit(Sender: TObject);
begin
  inherited;
  if(ActiveCtrl <> cboTemp) then
  begin
    if VitalInvalid(txtMeasTemp, cboTemp) then
      ChangeFocus(txtMeasTemp);
  end;
end;

procedure TfrmEncVitals.txtMeasHtExit(Sender: TObject);
begin
  inherited;
  if(ActiveCtrl <> cboHeight) then
  begin
    if VitalInvalid(txtMeasHt, cboHeight, GetVitHTRate) then
      ChangeFocus(txtMeasHt);
  end;
end;

procedure TfrmEncVitals.txtMeasWtExit(Sender: TObject);
begin
  inherited;
  if(ActiveCtrl <> cboWeight) then
  begin
    if VitalInvalid(txtMeasWt, cboWeight) then
      ChangeFocus(txtMeasWt);
  end;
end;

procedure TfrmEncVitals.ChangeFocus(Control: TWinControl);
begin
  FChangingFocus := TRUE;
  try
    Control.SetFocus;
  finally
    FChangingFocus := FALSE;
  end;
end;

function TfrmEncVitals.OK2SaveVitals: boolean;
begin
  Result := TRUE;
  if(HasData and (abs(txtMeasDate.FMDateTime) <= 0.0000000000001)) then
  begin
    Result := (InfoBox(TX_VDATE_REQ1 + FormatFMDateTime('dddddd@hh:nn', uEncPCEData.DateTime) +
                       TX_VDATE_REQ2, TC_VDATE_REQ, MB_YESNO or MB_ICONWARNING) = IDYES);
    if Result then
      txtMeasDate.FMDateTime := uEncPCEData.DateTime
    else
    begin
      Result := (InfoBox(TX_KILLDATA, TC_VDATE_REQ, MB_YESNO or MB_ICONWARNING) = IDYES);
      if(Result) then
        ClearData;
    end;
  end;
end;

procedure TfrmEncVitals.ClearData;
begin
  txtMeasBP.text    := '';
  txtMeasTemp.text  := '';
  txtMeasResp.text  := '';
  txtMeasPulse.text := '';
  txtMeasHt.text    := '';
  txtMeasWt.text    := '';
  cboPain.text      := '';
end;

//Begin Vitals Lite
procedure TfrmEncVitals.LoadVitalView(VitalsList: TStringList);
var
  i : integer;
  curCol : TListColumn;
  curItem : TListItem;
  HeadingList,tmpList : TStringList;
begin
  HeadingList := TStringList.Create;
  tmpList := TStringList.Create;
  lvVitals.ShowColumnHeaders := false;                //CQ: 10069 - the column display becomes squished.
  lvVitals.Items.Clear;
  lvVitals.Columns.Clear;
  PiecesToList(VitalsList[0],U,HeadingList);
  for i := 0 to HeadingList.Count-1 do
  begin
    curCol := lvVitals.Columns.Add;
    curCol.Caption := HeadingList[i];
    curCol.AutoSize := true;
  end;
  for i := 1 to VitalsList.Count-1 do
  begin
    curItem := lvVitals.Items.Add;
    PiecesToList(VitalsList[i],U,tmpList);
    curItem.Caption := tmpList[0];
    tmpList.Delete(0);
    curItem.SubItems.Assign(tmpList);
  end;
  lvVitals.ShowColumnHeaders := true;                 //CQ: 10069 - the column display becomes squished.
  HeadingList.Free;
  tmpList.Free;
end;

procedure TfrmEncVitals.btnEnterVitalsClick(Sender: TObject);
var
  VLPtVitals : TGMV_VitalsEnterDLG;
  //GMV_FName : String;
  GMV_Fname: AnsiString;
begin
  inherited;
  if VitalsDLLHandle = 0 then Exit;//The DLL was initialized on Create, but just in case....
  GMV_FName := 'GMV_VitalsEnterDLG';
  @VLPtVitals := GetProcAddress(VitalsDLLHandle,PAnsiChar(GMV_FName));
  if assigned(VLPtVitals) then
  begin
    VLPtVitals(
      RPCBrokerV,
      Patient.DFN,
      IntToStr(uEncPCEData.Location),
      GMV_DEFAULT_TEMPLATE,
      GMV_APP_SIGNATURE,
      FMDateTimeToDateTime(uEncPCEData.DateTime),
      Patient.Name,
      frmFrame.lblPtSSN.Caption + '    ' + frmFrame.lblPtAge.Caption
    );
  end
  else
    MessageDLG('Unable to find function "'+string(GMV_FName)+'".',mtError,[mbok],0);
  @VLPtVitals := nil;
  LoadVitalsList;
end;

procedure TfrmEncVitals.LoadVitalsList;
var
  VitalsList : TStringList;
  VLPtVitals : TGMV_LatestVitalsList;
  //GMV_FName : String;
  GMV_FName: AnsiString;
begin
  if VitalsDLLHandle = 0 then Exit;//The DLL was initialized on Create, but just in case....
  GMV_FName := 'GMV_LatestVitalsList';
  @VLPtVitals := GetProcAddress(VitalsDLLHandle,PAnsiChar(GMV_FName));
  if assigned(VLPtVitals) then
  begin
    VitalsList := VLPtVitals(RPCBrokerV,Patient.DFN,U,false);
    if assigned(VitalsList) then
      LoadVitalView(VitalsList);
  end
  else
    MessageDLG('Can''t find function "'+string(GMV_FName)+'".',mtError,[mbok],0);
  @VLPtVitals := nil;
end;
//End Vitals Lite

initialization
  SpecifyFormIsNotADialog(TfrmEncVitals);

end.
