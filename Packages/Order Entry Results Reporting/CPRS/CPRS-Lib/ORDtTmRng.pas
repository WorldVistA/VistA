unit ORDtTmRng;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ORFn, OR2006Compatibility, ORDtTm, VA508AccessibilityManager;

type
  TORfrmDateRange = class(Tfrm2006Compatibility)
    lblStart: TLabel;
    lblStop: TLabel;
    cmdOK: TButton;
    cmdCancel: TButton;
    lblInstruct: TLabel;
    VA508Man: TVA508AccessibilityManager;
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FCalStart: TORDateBox;
    FCalStop:  TORDateBox;
  protected
    procedure Loaded; override;
  end;

  TORDateRangeDlg = class(TComponent)
  private    FTextOfStart: string;    FTextOfStop: string;    FFMDateStart: TFMDateTime;    FFMDateStop: TFMDateTime;    FRelativeStart: string;    FRelativeStop: string;    FDateOnly: Boolean;    FRequireTime: Boolean;    FInstruction: string;    FLabelStart: string;    FLabelStop: string;    FFormat: string;    procedure SetDateOnly(Value: Boolean);    procedure SetFMDateStart(Value: TFMDateTime);
    procedure SetFMDateStop(Value: TFMDateTime);
    procedure SetTextOfStart(const Value: string);
    procedure SetTextOfStop(const Value: string);
    procedure SetRequireTime(Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    function Execute: Boolean;
    property RelativeStart: string    read FRelativeStart;
    property RelativeStop:  string    read FRelativeStop;
  published
    property DateOnly:    Boolean     read FDateOnly    write SetDateOnly;    property FMDateStart: TFMDateTime read FFMDateStart write SetFMDateStart;    property FMDateStop:  TFMDateTime read FFMDateStop  write SetFMDateStop;    property Instruction: string      read FInstruction write FInstruction;    property LabelStart:  string      read FLabelStart  write FLabelStart;    property LabelStop:   string      read FLabelStop   write FLabelStop;    property RequireTime: Boolean     read FRequireTime write SetRequireTime;    property Format:      string      read FFormat      write FFormat;    property TextOfStart: string      read FTextOfStart write SetTextOfStart;    property TextOfStop:  string      read FTextOfStop  write SetTextOfStop; end;
  procedure Register;

implementation

{$R *.DFM}

const
  FMT_DATETIME = 'dddddd@hh:nn';
  FMT_DATEONLY = 'dddddd';

{ TORDateRangeDlg --------------------------------------------------------------------------- }

constructor TORDateRangeDlg.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FInstruction := 'Enter a date range -';
  FLabelStart  := 'Begin Date';
  FLabelStop   := 'End Date';
  FFormat      := FMT_DATETIME;
end;

function TORDateRangeDlg.Execute: Boolean;
var
  frmDateRange: TORfrmDateRange;
begin
  frmDateRange := TORfrmDateRange.Create(Application);
  try
    with frmDateRange do
    begin
      FCalStart.Text        := FTextOfStart;
      FCalStop.Text         := FTextOfStop;
      if FFMDateStart > 0 then
      begin
        FCalStart.FMDateTime := FFMDateStart;
        FCalStart.Text := FormatFMDateTime(FFormat, FFMDateStart);
      end;
      if FFMDateStop > 0 then      begin
        FCalStop.FMDateTime := FFMDateStop;
        FCalStop.Text := FormatFMDateTime(FFormat, FFMDateStop);
      end;
      FCalStart.DateOnly    := FDateOnly;      FCalStop.DateOnly     := FDateOnly;      FCalStart.RequireTime := FRequireTime;      FCalStop.RequireTime  := FRequireTime;      lblInstruct.Caption  := FInstruction;      lblStart.Caption     := FLabelStart;      lblStop.Caption      := FLabelStop;
      Result := (ShowModal = IDOK);
      if Result then
      begin
        FTextOfStart   := FCalStart.Text;
        FTextOfStop    := FCalStop.Text;
        FFMDateStart   := FCalStart.FMDateTime;
        FFMDateStop    := FCalStop.FMDateTime;
        FRelativeStart := FCalStart.RelativeTime;
        FRelativeStop  := FCalStop.RelativeTime;
      end;
    end;



  finally
    frmDateRange.Free;
  end;
end;

procedure TORDateRangeDlg.SetDateOnly(Value: Boolean);
begin
  FDateOnly := Value;
  if FDateOnly then
  begin
    FRequireTime := False;
    FMDateStart  := Int(FFMDateStart);
    FMDateStop   := Int(FFMDateStop);
    if FFormat = FMT_DATETIME then FFormat := FMT_DATEONLY;
  end;
end;

procedure TORDateRangeDlg.SetRequireTime(Value: Boolean);
begin
  FRequireTime := Value;
  if FRequireTime then
  begin
    if FFormat = FMT_DATEONLY then FFormat := FMT_DATETIME;
    SetDateOnly(False);
  end;
end;

procedure TORDateRangeDlg.SetFMDateStart(Value: TFMDateTime);
begin
  FFMDateStart := Value;
  FTextOfStart := FormatFMDateTime(FFormat, FFMDateStart);
end;

procedure TORDateRangeDlg.SetFMDateStop(Value: TFMDateTime);
begin
  FFMDateStop := Value;
  FTextOfStop := FormatFMDateTime(FFormat, FFMDateStop);
end;

procedure TORDateRangeDlg.SetTextOfStart(const Value: string);
begin
  FTextOfStart := Value;
  FFMDateStart := 0;
end;

procedure TORDateRangeDlg.SetTextOfStop(const Value: string);
begin
  FTextOfStop := Value;
  FFMDateStop := 0;
end;


{ TORfrmDateRange --------------------------------------------------------------------------- }

procedure TORfrmDateRange.cmdOKClick(Sender: TObject);
var
  ErrMsg: string;

begin

  FCalStart.Validate(ErrMsg);
  if ErrMsg <> '' then
  begin
    Application.MessageBox(PChar(ErrMsg), 'Start Date Error', MB_OK);
    Exit;
  end;
  FCalStop.Validate(ErrMsg);
  if ErrMsg <> '' then
  begin
    Application.MessageBox(PChar(ErrMsg), 'Stop Date Error', MB_OK);
    Exit;
  end;
  ModalResult := mrOK;
end;

procedure TORfrmDateRange.cmdCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure Register;
{ used by Delphi to put components on the Palette }
begin
  RegisterComponents('CPRS', [TORDateRangeDlg]);
end;

procedure TORfrmDateRange.FormCreate(Sender: TObject);
{ Create date boxes here to avoid problem where TORDateBox is not already on component palette. }
var
  item: TVA508AccessibilityItem;
  id: integer;
begin
  FCalStart := TORDateBox.Create(Self);
  FCalStart.Parent := Self;
  FCalStart.SetBounds(8, 58, 121, 21);
  FCalStart.TabOrder := 0;
  FCalStop := TORDateBox.Create(Self);
  FCalStop.Parent := Self;
  FCalStop.SetBounds(145, 58, 121, 21);
  FCalStop.TabOrder := 1;
  ResizeAnchoredFormToFont(self);
  UpdateColorsFor508Compliance(self);

  VA508Man.AccessData.Add.component := FCalStart;
  item := VA508Man.AccessData.FindItem(FCalStart, False);
  id:= item.INDEX;
  VA508Man.AccessData[id].AccessText := 'From date/time. Press the enter key to access.';

  VA508Man.AccessData.Add.component := FCalStop;
  item := VA508Man.AccessData.FindItem(FCalStop, False);
  id:= item.INDEX;
  VA508Man.AccessData[id].AccessText := 'Through date/time. Press the enter key to access.';


end;

procedure TORfrmDateRange.FormDestroy(Sender: TObject);
begin
  FCalStart.Free;
  FCalStop.Free;
end;

procedure TORfrmDateRange.Loaded;
begin
  inherited Loaded;
  UpdateColorsFor508Compliance(Self);
end;

end.
