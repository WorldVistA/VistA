{///////////////////////////////////////////////////////
//Description: This form has been copied form the vital entry tab in fPCEEdit
// It is intended to be used for vital entry off of the cover sheet in CPRS and
// posibly being ported to a separate application from CPRS that only does Vital entry.
//
//Created: April 1998
//Author: Robert Bott
//Location: ISL
//
//To Do List:
// needs to be modified to use the application font settings.

////////////////////////////////////////////////////////
//Modifed: 4/21/98
//By: Robert Bott
//Location: ISL
//Description of Mod:  Modified this unit to use only the Date/time entered
// rather than the encounter.datetime.
//
//Modifed: 5/06/98
//By: Robert Bott
//Location: ISL
//Description of Mod: removed DateStrToFMDateTimeStr function and added
// TOTDateBox to allow the date/time to be edited.
//
//Modifed: 6/15/98
//By: Robert Bott
//Location: ISL
//Description of Mod: moved line of code to change caption from formCreate event
// to formShow event.  This prevents an error occuring at that line if there is
// not a broker connection.

//Modifed: 6/23/98
//By: Robert Bott
//Location: ISL
//Description of Mod:
//  Moved code that verifies valid provider and visit from fvit into fVitals.
//   now found in procedure TfrmVitals.btnEnterVitalsClick(Sender: TObject);
//   formerly in procedure TfrmVit.FormActivate(Sender: TObject);

//Modifed: 9/18/98
//By: Robert Bott
//Location: ISL
//Description of Mod:
//  changed procedure TfrmVit.cmdOKClick to display the error message returned
//     from ValAndStoreVitals.

//Modifed: 12/10/98
//By: Robert Bott
//Location: ISL
//Description of Mod:
//  Changed oredr of display and entry to Temp, Pulse, Resp, B/P, HT, WT

//Modifed: 6/29/99
//By: Robert Bott
//Location: ISL
//Description of Mod:
//  Changed AssignVitals finction to round conversions before storing them.

///////////////////////////////////////////////////////////////////////////////}

unit fvit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, fAutoSz,StdCtrls, ORFn, ORCtrls, rvitals, ORDtTm,
  VA508AccessibilityManager;


type
  TfrmVit = class(TfrmAutoSz)
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
    txtMeasBP: TCaptionEdit;
    cboTemp: TCaptionComboBox;
    txtMeasTemp: TCaptionEdit;
    txtMeasResp: TCaptionEdit;
    txtMeasPulse: TCaptionEdit;
    txtMeasHt: TCaptionEdit;
    cboHeight: TCaptionComboBox;
    txtMeasWt: TCaptionEdit;
    cboWeight: TCaptionComboBox;
    lblVitPointer: TOROffsetLabel;
    cmdOK: TButton;
    cmdCancel: TButton;
    lblVital: TStaticText;
    lblVitBP: TStaticText;
    lnlVitTemp: TStaticText;
    lblVitResp: TStaticText;
    lblVitPulse: TStaticText;
    lblVitHeight: TStaticText;
    lblVitWeight: TStaticText;
    txtMeasDate: TORDateBox;
    lblDatePain: TStaticText;
    lblLastPain: TStaticText;
    lblVitPain: TStaticText;
    cboPain: TORComboBox;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
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
    procedure cmdCancelClick(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure lbllastClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure cboPainChange(Sender: TObject);
    procedure SetVitPointer(Sender: TObject);
    procedure txtMeasTempExit(Sender: TObject);
    procedure txtMeasHtExit(Sender: TObject);
    procedure txtMeasWtExit(Sender: TObject);

  private
    { Private declarations }
    procedure InitVitalPanel;
    procedure PopulateLastVital;
    function GetVitHTRate: String;
    procedure AssignVitals;
    procedure CheckVitalUnit(AWinControl: TWinControl);
  public
    { Public declarations }
  end;

const
  TX_NEED_VISIT = 'A visit or location is required before entering vital signs.';
  TX_NO_VISIT   = 'Insufficient Visit Information';
  TX_NEED_PROVIDER = 'A valid provider must be selected before entering vital signs.';
  TX_NO_PROVIDER   = 'Undefined Provider';

var
  frmVit: TfrmVit;
  uVitalLocation: Real;
  //uVitalNew:     TStringlist;

implementation

{$R *.DFM}

uses UCore, rCore, rPCE, fPCELex, fPCEOther, fVitals,fVisit, fFrame, fEncnt,
  uVitals, VAUtils;

var
  uVitalOld:     TStringlist;
  uVitalNew:     TStringlist;
  UcboVitChanging:      Boolean = False;


{Start of code for Vital Page--------------------------------------------------}
procedure TfrmVit.FormKeyPress(Sender: TObject; var Key: Char);
{capture return key press if on the vital screen}
begin
  inherited;
  if (ActiveControl.tag IN ([TAG_VITTEMP,TAG_VITPULSE,TAG_VITRESP,
    TAG_VITBP,TAG_VITHEIGHT,TAG_VITWEIGHT,TAG_VITTEMPUNIT,TAG_VITHTUNIT,TAG_VITWTUNIT,TAG_VITPAIN,TAG_VITDATE]))then
    begin
    if Key = #13 then
    begin
      Key := #0;

      if (activeControl.Tag = TAG_VITPAIN) then cmdOK.setfocus
      else
      begin
        Perform(WM_NEXTDLGCTL,0,0);
        SetVitPointer(Sender);
      end;
    end;
  end;

end;

procedure TfrmVit.InitVitalPanel;
begin
  lblDate.font.Style := [fsBold];
  lblDateBP.font.Style := [fsBold];
  lblDateTemp.font.Style := [fsBold];
  lblDateResp.font.Style := [fsBold];
  lblDatePulse.font.Style := [fsBold];
  lblDateHeight.font.Style := [fsBold];
  lblDateWeight.font.Style := [fsBold];
  lblDatePain.font.style := [fsBold];    {*RAB*}
  lblLstMeas.font.Style := [fsBold];
  lblLastBP.font.Style := [fsBold];
  lblLastTemp.font.Style := [fsBold];
  lblLastResp.font.Style := [fsBold];
  lblLastPulse.font.Style := [fsBold];
  lblLastHeight.font.Style := [fsBold];
  lblLastWeight.font.Style := [fsBold];
  lblLastPain.font.style := [fsBold];  {*RAB*}
  lblVital.font.Style := [fsbold];


  UcboVitChanging := true; //prevents entering code in CheckVitalUnit
  try
    InitPainCombo(cboPain);
    cboTemp.Text := cboTemp.Items[0];
    cboHeight.Text := cboHeight.Items[0];
    cboWeight.Text := cboWeight.Items[0];
  finally
    UcboVitchanging := False; //prevents entering code in CheckVitalUnit
  end;

  txtMeasDate.Text := FormatFMDateTime('dddddd@hh:nn', FMNOW);

  if (UvitalOld.text = '') then
    PopulateLastVital;
end;



procedure TfrmVit.PopulateLastVital;
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
      lblLastTemp.Caption := piece(strings[i],U,3);
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
      lblLastHeight.Caption := piece(strings[i],U,3);
      lblDateHeight.Caption := FormatFMDateTime('dddddd',
        StrToFloat(piece(strings[i],U,4)));
    end;
    if piece(strings[i],U,2) = 'WT' then
    begin
      lblLastWeight.Caption := piece(strings[i],U,3);
      lblDateWeight.Caption := FormatFMDateTime('dddddd',
        StrToFloat(piece(strings[i],U,4)));
    end;
    if piece(strings[i],U,2) = 'PN' then             {*RAB*}
    begin
      lblLastPain.Caption := piece(strings[i],U,3);  {*RAB*}
      lblDatePain.Caption := FormatFMDateTime('dddddd', {*RAB*}
        StrToFloat(piece(strings[i],U,4)));           {*RAB*}

    end;
  end;

end;



function TfrmVit.GetVitHTRate: String;
begin
  Result := ConvertHeight2Inches(txtMeasHT.Text);
  txtMeasHT.text := Result;
end;

//procedure: procedure TFrmVit.AssignVitals;
//Modifed: 10/02/98
//By: Robert Bott
//Location: ISL
//Description of Mod:
//  If encounter.provider is not defined (=0) then use User.DUZ to store vitals.
procedure TFrmVit.AssignVitals;
begin
  AssignVitals2List(uVitalNew, txtMeasDate.FMDateTime, FloatToStr(uVitalLocation),
                       txtMeasBP.text, txtMeasTemp.text, cboTemp.text,
                       txtMeasResp.text, txtMeasPulse.text, GetVitHTRate, cboHeight.text,
                       txtMeasWT.text, cboWeight.text, cboPain.ItemID);
end;

procedure TfrmVit.cboTempChange(Sender: TObject);
begin
  inherited;
  if not (cbotemp.droppeddown) then
    CheckVitalUnit(cboTemp);
end;


procedure TFrmVit.CheckVitalUnit(AWinControl: TWinControl);
var
  len,i: integer;
  found: boolean;
  comp: string; //substring for comparing
  temp: string;
begin
  if (UcboVitchanging = true) then exit;

  UcboVitChanging := true;
  try
    with AWinControl as TComboBox do
    begin
      found := False;
      temp := (AWinControl as TComboBox).text;
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
            (AWinControl as TComboBox).Text := '';
            (AWinControl as TComboBox).text := items[i];

          end;
          inc(i);
        end;
        if (found = false) then Delete(temp,1,1);
      end;
      if (found = False) then
      begin
        (AWinControl as TComboBox).Text := '';
      end;
    end;
  finally
    UcboVitChanging := false;
  end;
end;


procedure TfrmVit.cboHeightChange(Sender: TObject);
begin
  inherited;
  CheckVitalUnit(cboHeight);
end;

procedure TfrmVit.cboWeightChange(Sender: TObject);
begin
  inherited;
  CheckVitalUnit(cboWeight);
end;

procedure TfrmVit.txtMeasBPExit(Sender: TObject);
begin
  inherited;
  if VitalInvalid(txtMeasBP) then
    txtMeasBP.SetFocus;
end;

procedure TfrmVit.cboTempExit(Sender: TObject);
begin
  inherited;
  if(ActiveControl <> txtMeasTemp) then
  begin
    if VitalInvalid(txtMeasTemp, cboTemp) then
      txtMeasTemp.SetFocus;
  end;
end;

procedure TfrmVit.txtMeasRespExit(Sender: TObject);
begin
  inherited;
  if VitalInvalid(txtMeasResp) then
    txtMeasResp.SetFocus;
end;

procedure TfrmVit.txtMeasPulseExit(Sender: TObject);
begin
  inherited;
  if VitalInvalid(txtMeasPulse) then
    txtMeasPulse.SetFocus;
end;

procedure TfrmVit.cboHeightExit(Sender: TObject);
begin
  inherited;
  if(ActiveControl <> txtMeasHt) then
  begin
    if VitalInvalid(txtMeasHt, cboHeight, GetVitHTRate) then
      txtMeasHt.SetFocus;
  end;
end;

procedure TfrmVit.cboWeightExit(Sender: TObject);
begin
  inherited;
  if(ActiveControl <> txtMeasWt) then
  begin
    if VitalInvalid(txtMeasWt, cboWeight) then
      txtMeasWt.SetFocus;
  end;
end;

procedure TfrmVit.FormCreate(Sender: TObject);

begin
  inherited;
  //uVisitType := TPCEProc.create;
  uVitalOld  := TStringList.create;
  uVitalNew  := TStringList.create;
  ResizeAnchoredFormToFont(self);
end;



procedure TfrmVit.FormDestroy(Sender: TObject);

begin
  inherited;
  //uVisitType.Free;
  uVitalOld.Free;
  uVitalNew.free;
end;



procedure TfrmVit.cmdCancelClick(Sender: TObject);
begin
  inherited;
  close();
end;

procedure TfrmVit.cmdOKClick(Sender: TObject);
var
  StoreMessage: string;
begin
  inherited;
  // do validation for vitals & anything else here
  AssignVitals;

  //store vitals
  StoreMessage := ValAndStoreVitals(UVitalNew);
  if (Storemessage <> 'True') then
  begin
    ShowMsg(storemessage);
    exit;
  end;
  close();
end;

procedure TfrmVit.lbllastClick(Sender: TObject);
begin
  inherited;
  //
  try
    frmVitals.Show;
  except
    with sender as tLabel do
      SelectVital(self.Font.Size, tag);
  end; //end of try
end;


procedure TfrmVit.FormShow(Sender: TObject);
begin
  inherited;
  frmVit.caption := 'Vital entry for - '+ patient.name; {RAB 6/15/98}
end;

procedure TfrmVit.FormActivate(Sender: TObject);
begin
  inherited;
  InitVitalPanel;
  txtMeasTemp.setfocus;  //added 3/30/99 after changing tab order.
                         //The date is now first in tab order, but it shouldn't default there.

end;


procedure TfrmVit.cboPainChange(Sender: TObject);
begin
  inherited;
  CheckVitalUnit(cboPain);
end;

procedure TfrmVit.SetVitPointer(Sender: TObject);
begin
  if ActiveControl.tag in ([TAG_VITTEMP, TAG_VITPULSE, TAG_VITRESP, TAG_VITBP, TAG_VITHEIGHT,
    TAG_VITWEIGHT]) then
    begin
      // move pointer to some height and five pixels to right of edit box.
      lblVitPointer.Top := ActiveControl.Top+((ActiveControl.height ) div
      (lblVitPointer.height ));

      if ActiveControl = txtMeasTemp then
        lblVitPointer.left := (cboTemp.left + cboTemp.Width)
      else if ActiveControl = txtMeasHT then
        lblVitPointer.left := (cboHeight.left + cboHeight.Width)
      else if ActiveControl = txtMeasWT then
        lblVitPointer.left := (cboWeight.left + cboWeight.Width)
      else
        lblVitPointer.left := (ActiveControl.left + ActiveControl.Width);

    end;
end;

procedure TfrmVit.txtMeasTempExit(Sender: TObject);
begin
  if(ActiveControl <> cboTemp) then
  begin
    if VitalInvalid(txtMeasTemp, cboTemp) then
      txtMeasTemp.SetFocus;
  end;
end;

procedure TfrmVit.txtMeasHtExit(Sender: TObject);
begin
  if(ActiveControl <> cboHeight) then
  begin
    if VitalInvalid(txtMeasHt, cboHeight, GetVitHTRate) then
      txtMeasHt.SetFocus;
  end;
end;

procedure TfrmVit.txtMeasWtExit(Sender: TObject);
begin
  if(ActiveControl <> cboWeight) then
  begin
    if VitalInvalid(txtMeasWt, cboWeight) then
      txtMeasWt.SetFocus;
  end;
end;

end.
