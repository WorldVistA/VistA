unit fOptionsReportsDefault;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Spin, fOptions, ComCtrls, ORFn, ORNet, ORCtrls,
  ORDtTm, rCore, fBase508Form, VA508AccessibilityManager;

type
  TfrmOptionsReportsDefault = class(TfrmBase508Form)
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edtDefaultMax: TCaptionEdit;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Panel1: TPanel;
    btnOK: TButton;
    btnReset: TButton;
    lblDefaultText: TMemo;
    btnCancel: TButton;
    odcDfStart: TORDateBox;
    odcDfStop: TORDateBox;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure edtDefaultMaxExit(Sender: TObject);
    procedure edtDefaultStartKeyPress(Sender: TObject; var Key: Char);
    procedure edtDefaultEndKeyPress(Sender: TObject; var Key: Char);
    procedure edtDefaultMaxKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure odcDfStartExit(Sender: TObject);
    procedure odcDfStopExit(Sender: TObject);
    procedure odcDfStartKeyPress(Sender: TObject; var Key: Char);
    procedure odcDfStopKeyPress(Sender: TObject; var Key: Char);
    procedure odcDfStartClick(Sender: TObject);
    procedure odcDfStopClick(Sender: TObject);
    procedure edtDefaultMaxClick(Sender: TObject);
  private
    { Private declarations }
    startDate, endDate, maxOcurs: integer;
    sDate,eDate: String;
  public
    { Public declarations }
    procedure fillLabelText;

  end;

var
  frmOptionsReportsDefault: TfrmOptionsReportsDefault;

procedure DialogOptionsHSDefault(topvalue, leftvalue, fontsize: integer; var actiontype: Integer);

implementation

uses rOptions, uOptions, fReports, uCore;
{$R *.DFM}

procedure DialogOptionsHSDefault(topvalue, leftvalue, fontsize: integer; var actiontype: Integer);
var
  frmOptionsReportsDefault: TfrmOptionsReportsDefault;
begin
  frmOptionsReportsDefault := TfrmOptionsReportsDefault.Create(Application);
  actiontype := 0;
  try
    with frmOptionsReportsDefault do
    begin
      if (topvalue < 0) or (leftvalue < 0) then
        Position := poScreenCenter
      else
      begin
        Position := poDesigned;
        Top := topvalue;
        Left := leftvalue;
      end;
      ResizeAnchoredFormToFont(frmOptionsReportsDefault);
      ShowModal;
      actiontype := btnOK.Tag;
    end;
  finally
    frmOptionsReportsDefault.Release;
  end;
end;

procedure TfrmOptionsReportsDefault.btnOKClick(Sender: TObject);
var
  valueStartdate, valueEnddate, valueMax, values: string;
begin
  if (odcDfStart.Text = sDate) and (odcDfStop.Text = eDate) and (not edtDefaultMax.Modified ) then
    begin
      Close;
      Exit;
    end;

  if (odcDfStart.Text='') or (odcDfStop.Text='') or (edtDefaultMax.Text='') then
    begin
      InfoBox('You have to fill out each box, don''t leave blank!', 'Warning', MB_OK or MB_ICONWARNING);
      Exit;
    end;

  valueStartdate := odcDfStart.RelativeTime;
  valueEnddate := odcDfStop.RelativeTime;
  valueMax := edtDefaultMax.Text;
  values := valueStartdate + ';' + valueEnddate + ';' + valueMax;
  if InfoBox('Do you really want to change all of the reports settings to the specified values as following?'
    +#13#13' Start date: ' + odcDfStart.Text
    +#13' End date: ' + odcDfStop.Text
    +#13' Max occurences: ' + edtDefaultMax.Text
    +#13#13' Click Yes, all of the CPRS reports except for health summary reports will have these same settings.',
    'Confirmation', MB_YESNO or MB_ICONQUESTION) = IDYES then
  begin
      rpcSetDefaultReportsSetting(values);
      rpcActiveDefaultSetting;
      frmReports.LoadTreeView;
      with frmReports.tvReports do
        begin
         if Items.Count > 0 then
           Selected := Items.GetFirstNode;
         frmReports.tvReportsClick(Selected);
        end;
      Close;
  end
  else
  begin
    odcDfStart.Text := sDate;
    odcDfStop.Text := eDate;
    edtDefaultMax.Text := IntToStr(maxOcurs);
  end;
end;


procedure TfrmOptionsReportsDefault.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmOptionsReportsDefault.btnResetClick(Sender: TObject);
var
  startD,endD,maxOc: integer;
  values,msg,stdate,endate: string;
  today: TFMDateTime;
begin
  rpcRetrieveDefaultSetting(startD,endD,maxOc,msg);
  today := FMToday;
  if msg = 'NODEFAULT' then
  begin
    InfoBox('No default report settings are available', 'Warning', MB_OK or MB_ICONWARNING);
    Exit;
  end;
  //if (startD=startDate) and (endD=endDate) and (maxOc=maxOcurs) then
  //  Exit;
  stdate := DateToStr(FMDateTimeToDateTime(FMDateTimeOffsetBy(today, startD)));
  endate := DateToStr(FMDateTimeToDateTime(FMDateTimeOffsetBy(today, endD)));
  if InfoBox('Do you really want to change all of the reports settings to the default values as following?'
    +#13#13' Start date: ' + stdate
    +#13' End date: ' + endate
    +#13' Max occurences: ' + IntToStr(maxOc)
    +#13#13' Click Yes, all of the CPRS reports except for health summary reports will have these same settings.',
    'Confirmation', MB_YESNO or MB_ICONQUESTION) = IDYES then
  begin
    rpcDeleteUserLevelReportsSetting;
    odcDfStart.Text := stdate;
    odcDfStop.Text := endate;
    edtDefaultMax.Text := inttostr(maxOc);
    values := odcDfStart.RelativeTime + ';' + odcDfStop.RelativeTime + ';' + edtDefaultMax.Text;
    rpcSetDefaultReportsSetting(values);
    rpcActiveDefaultSetting;
    sDate := odcDfStart.Text;
    eDate := odcDfStop.Text;
    startDate := startD;
    endDate := endD;
    maxOcurs := maxOc;
    fillLabelText;
    frmReports.LoadTreeView;
    with frmReports.tvReports do
     begin
       if Items.Count > 0 then
         Selected := Items.GetFirstNode;
       frmReports.tvReportsClick(Selected);
     end;
  end;
end;

procedure TfrmOptionsReportsDefault.edtDefaultMaxExit(Sender: TObject);
var
  newValue: string;
  I, code: integer;
begin
  if edtDefaultMax.Modified then
  begin

  newValue := edtDefaultMax.Text;
  if length(newValue) = 0 then
    begin
      InfoBox('Invalid value of max occurences', 'Warning', MB_OK or MB_ICONWARNING);
      edtDefaultMax.Text := '100';
    end;
  if length(newValue) > 0 then
    begin
      Val(newValue, I, code);
      if I = 0 then begin end; //added to keep compiler from generating a hint
      if code <> 0 then
        begin
          InfoBox('Invalid value of max occurences', 'Warning', MB_OK or MB_ICONWARNING);
          edtDefaultMax.Text := inttostr(maxOcurs);
        end;
      if code = 0 then
        if strtoint(edtDefaultMax.Text) <= 0 then
          begin
            InfoBox('Invalid value of max occurences', 'Warning', MB_OK or MB_ICONWARNING);
            edtDefaultMax.Text := inttostr(maxOcurs);
          end;
    end;
  fillLabelText;

  end;
end;

procedure TfrmOptionsReportsDefault.fillLabelText;
var
  fromday,dayto: string;
begin
  fromday := DateToStr(FMDateTimeToDateTime(odcDfStart.FMDateTime));
  dayto := DateToStr(FMDateTimeToDateTime(odcDfStop.FMDateTime));
  lblDefaultText.Text := 'All of the CPRS reports except for Health Summary reports will be displayed on the CPRS Reports tab from start date: '
                       + fromday + ' to end date: ' + dayto + '.';
end;

procedure TfrmOptionsReportsDefault.edtDefaultStartKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    Perform(WM_NextDlgCtl, 0, 0);
    exit;
  end;
end;

procedure TfrmOptionsReportsDefault.edtDefaultEndKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    Perform(WM_NextDlgCtl, 0, 0);
    exit;
  end;
end;

procedure TfrmOptionsReportsDefault.edtDefaultMaxKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    Perform(WM_NextDlgCtl, 0, 0);
    exit;
  end;
end;

procedure TfrmOptionsReportsDefault.FormCreate(Sender: TObject);
var
  today : TFMDateTime;
begin
  today := FMToday;
  rpcGetDefaultReportsSetting(startDate,endDate,maxOcurs);
  odcDfStart.FMDateTime := FMDateTimeOffsetBy(today, startDate);
  sDate := odcDfStart.Text;
  odcDfStop.FMDateTime := FMDateTimeOffsetBy(today, endDate);
  eDate := odcDfStop.Text;
  if maxOcurs <> 0 then
    begin
      edtDefaultMax.Text := inttostr(maxOcurs);
      fillLabelText;
    end;
  lblDefaultText.Text := 'Click dots in boxes to set start and end dates. You can also input values directly.';
  btnCancel.caption := 'Cancel';
  if (not User.ToolsRptEdit) then // For users with Reports settings edit parameter not set.
    begin
      lblDefaultText.Text := 'Settings can only be viewed (no editing provided).';
      btnReset.visible := false;
      btnOK.visible := false;
      btnCancel.caption := 'Close';
      odcDfStart.readOnly := true;
      odcDfStart.enabled := false;
      odcDfStart.onExit := nil;
      odcDfStart.onKeyPress := nil;
      odcDfStop.readOnly := true;
      odcDfStop.enabled := false;
      odcDfStop.onExit := nil;
      odcDfStop.onKeyPress := nil;
      edtDefaultMax.readOnly := true;
    end;
end;

procedure TfrmOptionsReportsDefault.odcDfStartExit(Sender: TObject);
const
  TX_BAD_START   = 'The start date is not valid.';
  TX_STOPSTART   = 'The start date must not be after the stop date.';

var
  x,ErrMsg,datestart,datestop: String;
begin
    if odcDfStart.text = '' then
    begin
      InfoBox(TX_BAD_START, 'Warning', MB_OK or MB_ICONWARNING);
      odcDfStart.Text := sDate;
      odcDfStart.Setfocus;
      odcDfStart.SelectAll;
      exit;
    end;

    ErrMsg := '';
    odcDfStart.Validate(x);
    if Length(x) > 0 then
      begin
        ErrMsg := TX_BAD_START;
        InfoBox(TX_BAD_START, 'Warning', MB_OK or MB_ICONWARNING);
        odcDfStart.Text := sDate;
        odcDfStart.Setfocus;
        odcDfStart.SelectAll;
        exit;
      end;
   datestart := odcDfStart.RelativeTime;
   datestop := odcDfStop.RelativeTime;
   delete(datestart,1,1);
   delete(datestop,1,1);
   if StrToIntDef(datestop,0) < StrToIntDef(datestart,0) then
   begin
    InfoBox(TX_STOPSTART, 'Warning', MB_OK or MB_ICONWARNING);
    odcDfStart.Text := odcDfStop.Text;
    odcDfStart.SetFocus;
    odcDfStart.SelectAll;
    exit;
   end;
   odcDfStart.Text := DateToStr(FMDateTimeToDateTime(odcDfStart.FMDateTime));
   fillLabelText;
end;

procedure TfrmOptionsReportsDefault.odcDfStopExit(Sender: TObject);
const
  TX_BAD_STOP    = 'The stop date is not valid.';
  TX_BAD_ORDER   = 'The stop date must not be earlier than start date.';
var
  x, ErrMsg,datestart,datestop: string;
begin
   if odcDfStop.text = '' then
   begin
      InfoBox(TX_BAD_STOP, 'Warning', MB_OK or MB_ICONWARNING);
      odcDfStop.Text := eDate;
      odcDfStop.Setfocus;
      odcDfStop.SelectAll;
      exit;
   end;

   ErrMsg := '';
   odcDfStop.Validate(x);
   if Length(x) > 0 then
   begin
     ErrMsg := TX_BAD_STOP;
     InfoBox(TX_BAD_STOP, 'Warning', MB_OK or MB_ICONWARNING);
     odcDfStop.Visible := True;
     odcDfStop.Text := eDate;
     odcDfStop.Setfocus;
     odcDfStop.SelectAll;
     exit;
   end;
   datestart := odcDfStart.RelativeTime;
   datestop := odcDfStop.RelativeTime;
   delete(datestart,1,1);
   delete(datestop,1,1);
   if StrToIntDef(datestop,0) < StrToIntDef(datestart,0) then
   begin
    InfoBox(TX_BAD_ORDER, 'Warning', MB_OK or MB_ICONWARNING);
    odcDfStop.Text := odcDfStart.Text;
    odcDfStop.SetFocus;
    odcDfStop.SelectAll;
    exit;
   end;
   odcDfStop.Text := DateToStr(FMDateTimeToDateTime(odcDfStop.FMDateTime));
   fillLabelText;
end;


procedure TfrmOptionsReportsDefault.odcDfStartKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    Perform(WM_NextDlgCtl, 0, 0);
    exit;
  end;
  if Key = #27 then //Escape
  begin
    Key := #0;
    btnCancel.Click;
  end;
end;

procedure TfrmOptionsReportsDefault.odcDfStopKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    Perform(WM_NextDlgCtl, 0, 0);
    exit;
  end;
  if Key = #27 then //Escape
  begin
    Key := #0;
    btnCancel.Click;
  end;
end;

procedure TfrmOptionsReportsDefault.odcDfStartClick(Sender: TObject);
begin
  odcDfStart.SelectAll;
end;

procedure TfrmOptionsReportsDefault.odcDfStopClick(Sender: TObject);
begin
  odcDfStop.SelectAll;
end;

procedure TfrmOptionsReportsDefault.edtDefaultMaxClick(Sender: TObject);
begin
  edtDefaultMax.SelectAll;
end;

end.
