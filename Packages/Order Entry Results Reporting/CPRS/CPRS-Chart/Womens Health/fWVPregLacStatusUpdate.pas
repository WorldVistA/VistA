unit fWVPregLacStatusUpdate;
{
  ================================================================================
  *
  *       Application:  TDrugs Patch OR*3*377 and WV*1*24
  *       Developer:    dan.petit@domain.ext
  *       Site:         Salt Lake City ISC
  *
  *       Description:  Update form to enter the appropriate information for
  *                     pregnancy and lactation data. Caller supplies the
  *                     appropriate patient via the TWVPatient object as
  *                     an IWVPaitent interface.
  *
  *       Notes:
  *
  ================================================================================
}

interface

uses
  System.Actions,
  System.Classes,
  System.SysUtils,
  System.UITypes,
  System.Variants,
  Vcl.ActnList,
  Vcl.ComCtrls,
  Vcl.Controls,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.Forms,
  Vcl.Graphics,
  Vcl.Menus,
  Vcl.StdCtrls,
  Winapi.Messages,
  Winapi.Windows,
  iWVInterface,
  DateUtils,
  rMisc,
  ORFn,
  ORCtrls,
  VAUtils,
  ORDtTm,
  rReminders,
  fBase508Form,
  VA508AccessibilityManager;

type
  TfrmWVPregLacStatusUpdate = class(TfrmBase508Form)
    btnCancel: TButton;
    btnSave: TButton;
    pnlOptions: TPanel;
    robnAbleToConceiveYes: TRadioButton;
    robnAbleToConceiveNo: TRadioButton;
    ckbxMenopause: TCheckBox;
    ckbxHysterectomy: TCheckBox;
    stxtAbleToConceive: TStaticText;
    stxtCurrentlyPregnant: TStaticText;
    pnlLactationStatus: TPanel;
    robnLactatingNo: TRadioButton;
    stxtLactationStatus: TStaticText;
    ckbxPermanent: TCheckBox;
    stxtReaderStop: TStaticText;
    grdConceive: TGridPanel;
    pnlConeiveLabel: TPanel;
    grdPregStatus: TGridPanel;
    pnlPregStatusLabel: TPanel;
    grdLayout: TGridPanel;
    pnlConveive: TPanel;
    pnlPregnant: TPanel;
    pnlLactationLabel: TPanel;
    grdLactation: TGridPanel;
    pnlOther: TPanel;
    ststxtOther: TStaticText;
    edtOther: TEdit;
    scrollBox: TScrollBox;
    pnlForm: TPanel;
    robnLactatingYes: TRadioButton;
    robnPregnantUnsure: TRadioButton;
    robnPregnantNo: TRadioButton;
    robnPregnantYes: TRadioButton;
    pnlLMP: TPanel;
    stxtLastMenstrualPeriod: TStaticText;
    dteLMPD: TORDateBox;
    pnlEDD: TPanel;
    stxtEDDMethod: TStaticText;
    dteEDD: TORDateBox;

    procedure AbleToConceiveYesNo(Sender: TObject);
    procedure PregnantYesNoUnsure(Sender: TObject);
    procedure CheckOkToSave(Sender: TObject);
    procedure robnLactatingYesNoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dteLMPDExit(Sender: TObject);
    procedure dteLMPDChange(Sender: TObject);
    procedure dteEDDChange(Sender: TObject);
    procedure dteLMPDMouseLeave(Sender: TObject);
    procedure scrollBoxResize(Sender: TObject);
    procedure SetScrollBarHeight(FontSize: Integer);
    procedure dteLMPDDateDialogClosed(Sender: TObject);
  private
    { Private declarations }
    fDFN: string;
    MinFormHeight: Integer; //Determines when the scrollbars appear
    MinFormWidth: Integer;
    function calcDates(originalValue, newValue: TFMDateTime; update, patient: string): TFMDateTime;
    procedure updateEDD(date: TFMDateTime);
  public
    EDD: integer;
    function Execute: Boolean;
    function GetData(aList: TStringList): Boolean;
  end;

function NewPLUpdateForm(aDFN: string): TfrmWVPregLacStatusUpdate;

implementation

{$R *.dfm}


const
  { Names for Name=Value pairs }
  SUB_ABLE_TO_CONCEIVE = 'ABLE TO CONCEIVE';
  SUB_LACTATION_STATUS = 'LACTATION STATUS';
  SUB_LAST_MENSTRUAL_PERIOD = 'LAST MENSTRUAL PERIOD DATE';
  SUB_EDD = 'EXPECTED DUE DATE';
  SUB_MEDICAL_REASON = 'MEDICAL REASON';
  SUB_PATIENT = 'PATIENT';
  SUB_PREGNANCY_STATUS = 'PREGNANCY STATUS';


function NewPLUpdateForm(aDFN: string): TfrmWVPregLacStatusUpdate;
begin
  Result := TfrmWVPregLacStatusUpdate.Create(Application.MainForm);

  with Result do
    begin
      Loaded;
      fDFN := aDFN;
      pnlLactationStatus.Visible := True;
    end;
end;

function TfrmWVPregLacStatusUpdate.calcDates(originalValue,
  newValue: TFMDateTime; update, patient: string): TFMDateTime;
var
itemID, temp: string;
begin
  if update = 'EDD' then
    begin
      if EDD < 1 then
        begin
           Result := -1;
           Exit;
        end;
      itemID := IntToStr(EDD);
    end;
  temp := getLinkPromptValue(FloatToStr(newValue), itemID, FloatToStr(originalValue), patient);
  Result := StrToFloatDef(temp, -1);
end;

procedure TfrmWVPregLacStatusUpdate.CheckOkToSave(Sender: TObject);
begin
  if robnAbleToConceiveYes.Checked then
    begin
      if robnPregnantYes.Checked then
        btnSave.Enabled := (dteEDD.FMDateTime > 0)
       else btnSave.Enabled := robnPregnantNo.Checked or robnPregnantUnsure.Checked;
    end
  else if robnAbleToConceiveNo.Checked then
    btnSave.Enabled := ckbxHysterectomy.Checked or ckbxMenopause.Checked or ckbxPermanent.Checked
    or (edtOther.Text <> '')
  else if robnLactatingYes.Checked or robnLactatingNo.Checked then
    btnSave.Enabled := True
  else
    btnSave.Enabled := False;
end;

procedure TfrmWVPregLacStatusUpdate.dteEDDChange(Sender: TObject);
begin
  CheckOkToSave(Sender);
end;

procedure TfrmWVPregLacStatusUpdate.dteLMPDChange(Sender: TObject);
begin
//  CheckOkToSave(Sender);
end;

procedure TfrmWVPregLacStatusUpdate.dteLMPDDateDialogClosed(Sender: TObject);
begin
  updateEDD(dteLMPD.FMDateTime);
  CheckOkToSave(Sender);
end;

procedure TfrmWVPregLacStatusUpdate.dteLMPDExit(Sender: TObject);
begin
  updateEDD(dteLMPD.FMDateTime);
end;

procedure TfrmWVPregLacStatusUpdate.dteLMPDMouseLeave(Sender: TObject);
begin
  updateEDD(dteLMPD.FMDateTime);
  CheckOkToSave(Sender);
end;

procedure TfrmWVPregLacStatusUpdate.robnLactatingYesNoClick(Sender: TObject);
begin
  CheckOkToSave(Sender);
end;


procedure TfrmWVPregLacStatusUpdate.scrollBoxResize(Sender: TObject);
begin
  inherited;
  ScrollBox.OnResize := nil;
  //At least minimum
   if (pnlForm.Width < MinFormWidth) or (pnlForm.Height < MinFormHeight) then
   pnlForm.Align := alNone;
   pnlForm.AutoSize := false;
   if (pnlForm.Width < MinFormWidth) then pnlForm.Width := MinFormWidth;
   if pnlForm.Height < MinFormHeight then pnlForm.Height := MinFormHeight;


  if (ScrollBox.Width >= MinFormWidth) then
  begin
   if (ScrollBox.Height >= (MinFormHeight)) then
   begin
       pnlForm.Align := alClient;
   end else begin
     pnlForm.Align := alTop;
     pnlForm.AutoSize := true;
   end;
  end else begin
   if (ScrollBox.Height >= (MinFormHeight)) then
   begin
    pnlForm.Align := alNone;
    pnlForm.Top := 0;
    pnlForm.Left := 0;
    pnlForm.AutoSize := false;
    pnlForm.Width := MinFormWidth;
    pnlForm.height :=  ScrollBox.Height;
   end else begin
    pnlForm.Align := alNone;
    pnlForm.Top := 0;
    pnlForm.Left := 0;
    pnlForm.AutoSize := true;
   end;
  end;
  ScrollBox.OnResize := ScrollBoxResize;
end;

procedure TfrmWVPregLacStatusUpdate.SetScrollBarHeight(FontSize: Integer);
begin
  MinFormHeight := (self.grdPregStatus.Height + self.grdConceive.Height + self.grdConceive.Height);
  case FontSize of
    8: MinFormWidth := self.ckbxPermanent.Left + self.ckbxPermanent.Width + 5;
    10: MinFormWidth := self.ckbxPermanent.Left + self.ckbxPermanent.Width + 5;
    12: MinFormWidth := self.ckbxPermanent.Left + self.ckbxPermanent.Width + 30;
    14: MinFormWidth := 800;
    18: MinFormWidth := 1000;
  end;

end;

procedure TfrmWVPregLacStatusUpdate.updateEDD(date: TFMDateTime);
var
aDate: TFMDateTime;
begin
  aDate := calcDates(0, date, 'EDD', fDFN);
  if aDate > 0 then dteEDD.FMDateTime := aDate;
end;

procedure TfrmWVPregLacStatusUpdate.AbleToConceiveYesNo(Sender: TObject);
begin
  if robnAbleToConceiveYes.Checked then
    begin
      ckbxMenopause.Checked := False;
      ckbxMenopause.Enabled := False;
      ckbxHysterectomy.Checked := False;
      ckbxHysterectomy.Enabled := False;
      ckbxPermanent.Checked := False;
      ckbxPermanent.Enabled := False;
      ststxtOther.Enabled := false;
      edtother.Enabled := false;

      robnPregnantYes.Enabled := True;
      robnPregnantYes.TabStop := True;
      robnPregnantNo.Enabled := True;
      robnPregnantUnsure.Enabled := True;

      stxtLastMenstrualPeriod.Enabled := False;
      dteLMPD.Enabled := false;
      dteEDD.Enabled := false;
      stxtEDDMethod.Enabled := False;
    end
  else if robnAbleToConceiveNo.Checked then
    begin
      ckbxMenopause.Enabled := True;
      ckbxHysterectomy.Enabled := True;
      ckbxPermanent.Enabled := True;
      ststxtOther.Enabled := true;
      edtOther.Enabled := true;

      robnPregnantYes.Enabled := False;
      robnPregnantYes.Checked := False;
      robnPregnantNo.Enabled := False;
      robnPregnantNo.Checked := False;
      robnPregnantUnsure.Enabled := False;
      robnPregnantUnsure.Checked := False;

      stxtLastMenstrualPeriod.Enabled := False;
      dteLMPD.Enabled := false;
      dteEDD.Enabled := false;
      stxtEDDMethod.Enabled := False;
    end
  else
    begin
      ckbxMenopause.Checked := False;
      ckbxMenopause.Enabled := False;
      ckbxHysterectomy.Checked := False;
      ckbxHysterectomy.Enabled := False;
      ckbxPermanent.Checked := False;
      ckbxPermanent.Enabled := False;
      ststxtOther.Enabled := false;
      edtOther.Enabled := false;

      robnPregnantYes.Enabled := False;
      robnPregnantYes.Checked := False;
      robnPregnantNo.Enabled := False;
      robnPregnantNo.Checked := False;
      robnPregnantUnsure.Enabled := False;
      robnPregnantUnsure.Checked := False;

      stxtLastMenstrualPeriod.Enabled := False;
      dteLMPD.Enabled := false;
      dteEDD.Enabled := false;
      stxtEDDMethod.Enabled := False;
    end;

  CheckOkToSave(Sender);
end;

procedure TfrmWVPregLacStatusUpdate.PregnantYesNoUnsure(Sender: TObject);
begin
    if robnPregnantYes.Checked then
      begin
        stxtLastMenstrualPeriod.Enabled := True;
        dteLMPD.Enabled := true;
        dteEDD.Enabled := true;
        stxtEDDMethod.Enabled := True;
//        if ScreenReaderActive then
//        begin
//          stxtEDDMethod.TabStop := True;
//          stxtEDDMethod.TabOrder := 4;
//        end;
      end
    else
      begin
        stxtLastMenstrualPeriod.Enabled := False;
        dteLMPD.FMDateTime := 0;
        dteEDD.FMDateTime := 0;
        dteLMPD.Text := '';
        dteEDD.Text := '';
        dteLMPD.Enabled := false;
        dteEDD.Enabled := false;
        stxtEDDMethod.Enabled := False;
      end;

  CheckOkToSave(Sender);
end;

function TfrmWVPregLacStatusUpdate.Execute: Boolean;
begin
  Result := (ShowModal = mrOk);
end;

procedure TfrmWVPregLacStatusUpdate.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  try
    SaveUserBounds(Self);
    Action := caFree;
  finally
    Action := caFree;
  end;
end;

procedure TfrmWVPregLacStatusUpdate.FormCreate(Sender: TObject);
var
  height, dteheight: integer;
begin
  inherited;
  SetFormPosition(Self);
  ResizeFormToFont(self);
  //setLabelTabStops(ScreenReaderActive);
  height := TextHeightByFont(stxtAbleToConceive.Font.Handle, stxtAbleToConceive.Caption);
  pnlConeiveLabel.Height := height + 5;
  pnlPregStatusLabel.Height := height + 5;
  pnlLactationLabel.Height := height + 5;
  SetScrollBarHeight(MainFontSize);
  dteheight := (height + 5);
  self.pnlLMP.Height := dteheight + 1;
  self.pnlEDD.Height := dteheight + 1;
  self.dteLMPD.Constraints.MaxHeight := dteheight;
  self.dteEDD.Constraints.MaxHeight := dteheight;
  self.dteLMPD.Constraints.MinHeight := dteheight;
  self.dteEDD.Constraints.MinHeight := dteheight;
end;

function TfrmWVPregLacStatusUpdate.GetData(aList: TStringList): Boolean;
var
  aStr: string;

  procedure AddReason(var aStr: string; aValue: string);
  begin
    if aStr <> '' then
      begin
        // Remove any previous 'and's
        if Pos(' and ', aStr) > 0 then
          aStr := StringReplace(aStr, ' and ', ', ', [rfReplaceAll]);
        // Append on this value with a gramatically correct 'and'
        aStr := Format('%s and %s', [aStr, aValue]);
        // Set capitialization to gramatically correct first char only
        aStr := UpperCase(Copy(aStr, 1, 1)) + LowerCase(Copy(aStr, 2, Length(aStr)));
      end
    else
      aStr := aValue;
  end;

begin
  aList.Clear;
  try
    aList.Values[SUB_PATIENT] := fDFN;

    if robnAbleToConceiveYes.Checked then
      begin
        aList.Values[SUB_ABLE_TO_CONCEIVE] := 'Yes';

        if robnPregnantYes.Checked then
          begin
            aList.Values[SUB_PREGNANCY_STATUS] := 'Yes';
            if dteLMPD.FMDateTime > 0 then aList.Values[SUB_LAST_MENSTRUAL_PERIOD] := FloatToStr(dteLMPD.FMDateTime);
            if dteEDD.FMDateTime > 0 then aList.Values[SUB_EDD] := FloatToStr(dteEDD.FMDateTime);
          end
        else if robnPregnantNo.Checked then
          aList.Values[SUB_PREGNANCY_STATUS] := 'No'
        else if robnPregnantUnsure.Checked then
          aList.Values[SUB_PREGNANCY_STATUS] := 'Unsure'
        else
          aList.Values[SUB_PREGNANCY_STATUS] := 'Unknown';
      end
    else if robnAbleToConceiveNo.Checked then
      begin
        aList.Values[SUB_ABLE_TO_CONCEIVE] := 'No';
        aStr := '';

        if ckbxHysterectomy.Checked then
          AddReason(aStr, ckbxHysterectomy.Caption);

        if ckbxMenopause.Checked then
          AddReason(aStr, ckbxMenopause.Caption);

        if ckbxPermanent.Checked then
          AddReason(aStr, ckbxPermanent.Caption);

        if edtOther.Text <> '' then
          AddReason(aStr, edtOther.Text);

        aList.Values[SUB_MEDICAL_REASON] := aStr;
      end;

    if robnLactatingYes.Checked then
      aList.Values[SUB_LACTATION_STATUS] := 'Yes'
    else if robnLactatingNo.Checked then
      aList.Values[SUB_LACTATION_STATUS] := 'No';

    Result := True;
  except
    on e: Exception do
      begin
        aList.Clear;
        aList.Add('-1^' + e.Message);
        Result := False;
      end;
  end;
end;

end.
