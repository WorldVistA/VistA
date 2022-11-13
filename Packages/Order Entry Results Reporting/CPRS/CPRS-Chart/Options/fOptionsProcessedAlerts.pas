unit fOptionsProcessedAlerts;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ORCtrls, ORDtTmRng, ORFn, ExtCtrls, fBase508Form,
  VA508AccessibilityManager;

type
  TCBProcedure = procedure of object;

  TfrmOptionsProcessedAlerts = class(TfrmBase508Form)
    pnlBottom: TPanel;
    bvlBottom: TBevel;
    btnCancel: TButton;
    btnOK: TButton;
    btnDefaults: TButton;
    edDays: TEdit;
    edMaxRecords: TEdit;
    sTxtMaxRecords: TVA508StaticText;
    sTxtLogDays: TVA508StaticText;
    procedure btnDefaultsClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure edDaysKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    procedure setDefaults;
    procedure setInfo(aValue:String);
    function getInfo:String;
    procedure Init508;
  public
    { Public declarations }
    CBProcedure: TCBProcedure;
    property Info:String read getInfo write setInfo;
  end;

var
  frmOptionsProcessedAlerts: TfrmOptionsProcessedAlerts;
  paLogDaysMax: Real;
  paLogDays: Real;
  paLogRecordsMax: Integer;
  ProcessedAlertsSessionInfo:String;

function UpdateProcessedAlertsPreferences(aCB: TCBProcedure):Integer;
function getProcessedAlertsInfo:String;
procedure setProcessedAlertsInfo(anInfo:String);
procedure loadProcessedAlertsInfo;

implementation

uses
  rOptions, uOptions, rCore, VAUtils, System.UITypes;

{$R *.DFM}
const
  defLogDays = 7.0;
  defLogRecordMax = 100;
  posLogDays = 1;  // position of the LogDays value in the string
  posRecordMax = 2;// position of the LogRecordMax value

procedure setPaGUIDefaults;
begin
  paLogDays := defLogDays;
  paLogRecordsMax := defLogRecordMax;
end;

procedure setPaSiteDefaults;
begin
  paLogDays := defLogDays;
  paLogDaysMax := rpcGetDaysBeforeAlertPurge; // server max for the user(?)
  // UPDATE with RPC call for the case the defaults are coming from the server
  paLogDays := paLogDaysMax;
  paLogRecordsMax := defLogRecordMax;
end;

function getProcessedAlertsInfo:String;
begin
  Result := Format('%g^%d',[paLogDays,paLogRecordsMax]);
end;

procedure setProcessedAlertsInfo(anInfo:String);
begin
  paLogDays := StrToFloatDef(Piece(anInfo,U,posLogDays),paLogDays);
  paLogRecordsMax := StrToIntDef(Piece(anInfo,U,posRecordMax),paLogRecordsMax);
end;

procedure loadProcessedAlertsInfo;
var
  sInfo:String;
begin
  if ProcessedAlertsSessionInfo = '' then
    begin
      sInfo := rpcGetNotificationDefaults;
      paLogDays := StrToFloatDef(Piece(sInfo,U,4),paLogDays);  // CPRSv32 Test Issue Tracker #37
      paLogRecordsMax := StrToIntDef(Piece(sInfo,U,5),paLogRecordsMax); // CPRSv32 Test Issue Tracker #37
    end
  else
    begin
    sInfo := ProcessedAlertsSessionInfo;
      paLogDays := StrToFloatDef(Piece(sInfo,U,1{4}),paLogDays);  // CPRSv32 Test Issue Tracker #37
      paLogRecordsMax := StrToIntDef(Piece(sInfo,U,2{5}),paLogRecordsMax); // CPRSv32 Test Issue Tracker #37
    end;
  if ProcessedAlertsSessionInfo = '' then
    ProcessedAlertsSessionInfo := getProcessedAlertsInfo;
end;
////////////////////////////////////////////////////////////////////////////////

function UpdateProcessedAlertsPreferences(aCB: TCBProcedure):Integer;
begin
  setPaSiteDefaults;

  frmOptionsProcessedAlerts := TfrmOptionsProcessedAlerts.Create(Application);

  try
    with frmOptionsProcessedAlerts do
    begin
      CBProcedure := aCB;
      Init508;
      ResizeAnchoredFormToFont(frmOptionsProcessedAlerts);
      LoadProcessedAlertsInfo;
      setInfo(getProcessedAlertsInfo);
      Result := ShowModal;
      if Result <> mrCancel then
        begin
          paLogDays := StrToFloatDef(edDays.Text,paLogDays);  // save new values in unit var
          paLogRecordsMax := StrToIntDef(edMaxRecords.Text,paLogRecordsMax);  // save new values in unit var
        end;
      if (Result = mrOK) and Assigned(CBProcedure) then
        CBProcedure;
    end;
  finally
    frmOptionsProcessedAlerts.Release;
    frmOptionsProcessedAlerts := nil;
  end;
end;

////////////////////////////////////////////////////////////////////////////////

procedure TfrmOptionsProcessedAlerts.setDefaults;
begin
  setPaSiteDefaults;
  edDays.Text := Format('%g',[defLogDays]);
  edMaxRecords.Text := Format('%d',[defLogRecordMax]);
end;

procedure TfrmOptionsProcessedAlerts.setInfo(aValue:String);
begin
  edDays.Text := piece(aValue,U,1);
  edMaxRecords.Text := piece(aValue,U,2);
end;

procedure TfrmOptionsProcessedAlerts.btnDefaultsClick(Sender: TObject);
begin
  inherited;
  SetDefaults;
end;

procedure TfrmOptionsProcessedAlerts.edDaysKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not CharInSet(Key, [#8, '0' .. '9'{, FormatSettings.DecimalSeparator}]) then
  begin
    ShowMessage('Invalid key: "' + Key + '"');
    Key := #0;
  end
  else if (Key = '0') and
    ((Length(TEdit(Sender).Text) = 0) or (TEdit(Sender).SelStart=0)) then
    begin
      ShowMessage('"0" should not be used as the first character');
      Key := #0;
    end
//  else if (Key = FormatSettings.DecimalSeparator) and
//    (Pos(Key, TEdit(Sender).Text) > 0) then
//  begin
//    ShowMessage('Invalid Key: twice ' + Key);
//    Key := #0;
//  end;
end;

procedure TfrmOptionsProcessedAlerts.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  sErr: String;
  i: Integer;
  f: Real;
  ed: TEdit;
const
  fmtInvalidValue =
    'The value selected as the max number of records %s is not valid';
begin
  inherited;
  if ModalResult = mrOK then
  begin
    ed := nil;

    if edDays.Text = '' then
    begin
      sErr := 'Log Data days value is not defined';
      ed := edDays;
    end
    else
    begin
      f := StrToFloatDef(edDays.Text, paLogDays);
      if (f > paLogDaysMax) or (f < 0) then
      begin
        sErr := 'The requested number of days ' + FloatToStr(f) + CRLF +
          'is out of the range of "1..' + FloatToStr(paLogDaysMax) + '" (days)';
        ed := edDays;
      end;
    end;

    if edMaxRecords.Text = '' then
    begin
      sErr := 'Max # of recortds to show is not defined';
      ed := edMaxRecords;
    end
    else
    begin

      try
        i := StrToIntDef(edMaxRecords.Text, -1);
        if i < 1 then
        begin
          sErr := sErr + CRLF + Format(fmtInvalidValue, [edMaxRecords.Text]);
          if not assigned(ed) then
            ed := edMaxRecords;
        end;
      except
        on E: Exception do
        begin
          sErr := sErr + CRLF + Format(fmtInvalidValue, [edMaxRecords.Text]);
          if not assigned(ed) then
            ed := edMaxRecords;
        end;
      end;
    end;

    CanClose := sErr = '';
    if not CanClose then
    begin
      MessageDlg(trim(sErr) + CRLF + CRLF +
        'Please update the value(s) or cancel the changes.', mtError,
        [mbOK], 0);
      if assigned(ed) then
      begin
        ed.SelStart := 0;
        ed.SelLength := Length(ed.Text);
        ed.SetFocus;
      end;
    end;
  end
  else
    CanClose := True;
end;

function TfrmOptionsProcessedAlerts.getInfo:String;
begin
  Result := edDays.Text + U + edMaxRecords.Text;
end;

procedure TfrmOptionsProcessedAlerts.Init508;
var
  b: Boolean;
begin
  b := ScreenReaderActive;
  sTxtMaxRecords.TabStop := b;
  sTxtLogDays.TabStop := b;
end;

initialization

  setPaGUIDefaults;

end.
