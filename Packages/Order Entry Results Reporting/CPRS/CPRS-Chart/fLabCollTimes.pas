unit fLabCollTimes;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ORCtrls, ORDtTm, ORFn, ExtCtrls, ComCtrls, fBase508Form,
  VA508AccessibilityManager;

type
  TfrmLabCollectTimes = class(TfrmBase508Form)
    calLabCollect: TORDateBox;
    lstLabCollTimes: TORListBox;
    cmdOK: TButton;
    cmdCancel: TButton;
    lblFutureTimes: TMemo;
    calMonth: TMonthCalendar;
    procedure calLabCollectChange(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure calMonthClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure calMonthKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FFutureLabCollTime: string;
  public
    { Public declarations }
  end;

  function GetFutureLabTime(ACollDate: TFMDateTime): string;

implementation

uses
  rCore, uCore, ORNet, rODLab, VAUtils;

{$R *.DFM}
function GetFutureLabTime(ACollDate: TFMDateTime): string;
var
  frmLabCollectTimes: TfrmLabCollectTimes;
begin
  frmLabCollectTimes := TfrmLabCollectTimes.Create(Application);
  try
    with frmLabCollectTimes do
    begin
      calLabCollect.FMDateTime := Trunc(ACollDate);
      calMonth.Date := FMDateTimeToDateTime(calLabCollect.FMDateTime);
      FFutureLabCollTime := '';
      ShowModal;
      Result := FFutureLabCollTime;
    end; {with frmLabCollectTimes}
  finally
    frmLabCollectTimes.Release;
  end;
end;

procedure TfrmLabCollectTimes.calLabCollectChange(Sender: TObject);
begin
  with lstLabColltimes do
    begin
      Clear;
      GetLabTimesForDate(Items, calLabCollect.FMDateTime, Encounter.Location);
      ItemIndex := 0;
    end;
end;

procedure TfrmLabCollectTimes.cmdOKClick(Sender: TObject);
begin
  if lstLabCollTimes.ItemIEN > 0 then
    begin
      with calLabCollect, lstLabCollTimes do
        FFutureLabCollTime := RelativeTime + '@' + ItemID;
      Close;
    end
  else
    FFutureLabCollTime := '';
end;

procedure TfrmLabCollectTimes.cmdCancelClick(Sender: TObject);
begin
  FFutureLabCollTime := '';
  Close;
end;

procedure TfrmLabCollectTimes.calMonthClick(Sender: TObject);
begin
  calLabCollect.FMDateTime := DateTimeToFMDateTime(calMonth.Date);
  calMonth.SetFocus;
end;

procedure TfrmLabCollectTimes.FormCreate(Sender: TObject);
begin
  ResizeAnchoredFormToFont(self);
end;

procedure TfrmLabCollectTimes.calMonthKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_LEFT: calMonth.Date := calMonth.Date - 1;
    VK_RIGHT: calMonth.Date := calMonth.Date + 1;
    VK_UP: calMonth.Date := calMonth.Date - 7;
    VK_DOWN: calMonth.Date := calMonth.Date + 7;
  end;
end;

end.
