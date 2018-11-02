unit fGMV_DateTimeDLG;
{
================================================================================
*
*	Application:  Vitals
*	Revision:     $Revision: 1 $  $Modtime: 9/08/08 1:43p $
*	Developer:    dddddddddomain.user@domain.ext
*	Site:         Hines OIFO
*
*	Description:  This is an Date/Time Selection Dialog
*
*	Notes:        Originally compiled in Delphi V
*                     Uses routines from uGMV-Common module:
*                        uGMV-Common.CallServer(...) -- to call 'GMV GET CURRENT TIME' routine,
*                                                 to reteive M-date/time
*                        uGMV-Common.FMDateTimeToWindowsDateTime(...)
*                                                    -- to convert M-date/time
*
================================================================================
*       $Archive: /Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_8/Source/VITALSCOMMON/fGMV_DateTimeDLG.pas $
*
* $History: fGMV_DateTimeDLG.pas $
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 8/12/09    Time: 8:29a
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_8/Source/VITALSCOMMON
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 3/09/09    Time: 3:38p
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_6/Source/VITALSCOMMON
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 1/13/09    Time: 1:26p
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_4/Source/VITALSCOMMON
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/14/07    Time: 10:30a
 * Created in $/Vitals GUI 2007/Vitals-5-0-18/VITALSDATETIME
 *
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/16/06    Time: 5:43p
 * Created in $/Vitals/VITALS-5-0-18/VitalsDateTime
 * GUI v. 5.0.18 updates the default vital type IENs with the local
 * values.
 *
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/16/06    Time: 5:33p
 * Created in $/Vitals/Vitals-5-0-18/VITALS-5-0-18/VitalsDateTime
 *
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/24/05    Time: 3:37p
 * Created in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, CCOW) - Delphi 6/VitalsDateTime
 *
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 4/16/04    Time: 4:21p
 * Created in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, CPRS, Delphi 7)/VITALSDATETIME
 *
 * *****************  Version 2  *****************
 * User: Zzzzzzandria Date: 2/02/04    Time: 5:18p
 * Updated in $/VitalsLite/DateTimeDLL
 *
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 1/30/04    Time: 4:34p
 * Created in $/VitalsLite/DateTimeDLL
 *
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 1/15/04    Time: 3:06p
 * Created in $/VitalsLite/VitalsLiteDLL
 * Vitals Lite DLL
 *
}

interface

uses
{$IFDEF DLL}
  ShareMem,
{$ENDIF}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, ExtCtrls;

type
  TfGMV_DateTime = class(TForm)
    Panel1: TPanel;
    grpBoxDT: TGroupBox;
    Panel2: TPanel;
    pnlDate: TPanel;
    Panel5: TPanel;
    bbtnToday: TBitBtn;
    mncCalendar: TMonthCalendar;
    Panel6: TPanel;
    lbxHours: TListBox;
    lbxMinutes: TListBox;
    Panel4: TPanel;
    bbtnMidnight: TBitBtn;
    bbtnNow: TBitBtn;
    SpeedButton2: TSpeedButton;
    SpeedButton1: TSpeedButton;
    edtTime: TEdit;
    pnlDateTimeText: TPanel;
    Label1: TLabel;
    bbtnYesterday: TBitBtn;
    bbtnTomorrow: TBitBtn;
    Timer1: TTimer;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure lbxHoursClick(Sender: TObject);
    procedure lbxMinutesClick(Sender: TObject);
    procedure edtTimeKeyPress(Sender: TObject; var Key: Char);
    procedure bbtnNowClick(Sender: TObject);
    procedure bbtnMidnightClick(Sender: TObject);
    procedure bbtnTodayClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure edtTimeChange(Sender: TObject);
    procedure mncCalendarClick(Sender: TObject);
    procedure SetDateTimeText;
    procedure UpdateText;
    procedure bbtnYesterdayClick(Sender: TObject);
    procedure bbtnTomorrowClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    dltTime: TDateTime;
    procedure SetDateTime;
    function TimeIsValid(h, m: Integer): Boolean;
    procedure SetButtonState;
    procedure setServerDelay;
  public
    { Public declarations }
  end;

var
  fGMV_DateTime: TfGMV_DateTime;

implementation

uses
  uGMV_Common,
  uGMV_Engine, uGMV_Const, system.UITypes
  ;

{$IFDEF DATETIMEDLL}
var
  PrevApp: TApplication;
  PrevScreen: TScreen;
{$ENDIF}

{$R *.DFM}

procedure TfGMV_DateTime.FormCreate(Sender: TObject);
begin
//{$IFDEF DLL}
  // fix Remedy 154038 --------------------------------------------------- start
  // prior to this fix the code was used within DLL only
  setServerDelay;
//{$ELSE}
//  dltTime := 0;
//  edtTime.Text := FormatDateTime('hh:mm',Now);
//{$ENDIF}
  // fix Remedy 154038 ----------------------------------------------------- end
  Caption := 'Select Date & Time up to ' + FormatDateTime('mm/dd/yyyy hh:mm', mncCalendar.MaxDate);
end;

procedure TfGMV_DateTime.setServerDelay;
var
  aNow: TDateTime;
  s: string;
  f: Real;
begin
  aNow := Now;
  try
    s := getCurrentDateTime;
    if s <> '' then
    try
      f := StrToFloat(s);
      f := FMDateTimeToWindowsDateTime(f);
      dltTime := aNow - f;
      aNow := f;
    except
      on E: EConvertError do
      begin
        MessageDlg('Unable to set client to the servers time.', mtWarning, [mbok], 0);
        dltTime := 0;
        aNow := Now;
        edtTime.Text := FormatDateTime('hh:mm', aNow);
      end;
    end;
  except
    on E: EConvertError do
      MessageDlg('Unable to get the servers time.', mtWarning, [mbok], 0);
  end;
  grpBoxDT.Caption := '';
  mncCalendar.MaxDate := aNow;
  mncCalendar.Date := mncCalendar.MaxDate;
end;

procedure TfGMV_DateTime.SetDateTime;
var
  S: string;
  i, j: Integer;
begin
  try
    i := StrToInt(lbxHours.Items[lbxHours.ItemIndex]);
  except
    i := 0;
  end;
  try
    S := lbxMinutes.Items[lbxMinutes.ItemIndex];
    while (pos('0', S) = 1) or (pos(':', S) = 1) do
      S := copy(s, 2, Length(S) - 1);
    if pos(' --', S) = 1 then
      j := 0
    else
      j := StrToInt(Piece(S, ' ', 1));
  except
    j := 0;
  end;
  if TimeIsValid(i, j) then
    edtTime.Text := Format('%2.2d:%2.2d', [i, j])
  else
  begin
    MessageDlg('Sorry, you cannot select a future date or time' + #13 + #13 +
      'or date more than 1 year old'
      , mtError, [mbOk], 0)
  end;
  SetDateTimeText;
end;

procedure TfGMV_DateTime.lbxHoursClick(Sender: TObject);
begin
  SetDateTime;
end;

procedure TfGMV_DateTime.lbxMinutesClick(Sender: TObject);
begin
  SetDateTime;
end;

procedure TfGMV_DateTime.edtTimeKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    try
      UpdateText;
    except
      MessageDlg('Invalid time string.', mtError, [mbOk], 0);
      activecontrol := edtTime;
    end;
  end;
end;

procedure TfGMV_DateTime.UpdateText;
begin
  begin
    try
      SetDateTimeText;
    except
      MessageDlg('Check time value!', mtError, [mbYes, mbCancel], 0);
    end;
  end;
end;

procedure TfGMV_DateTime.bbtnNowClick(Sender: TObject);
var
  aNow: TDateTime;
begin
  setServerDelay;
  aNow := Now - dltTime;

  edtTime.Text := FormatDateTime(GMV_TimeFormat, aNow);
  try
    mncCalendar.MinDate := 0;
    mncCalendar.MinDate := aNow - 365;
  except
  end;
  mncCalendar.MaxDate := aNow;
  mncCalendar.Date := aNow;
  caption := 'Select Date & Time up to ' + FormatDateTime('mm/dd/yyyy hh:mm', mncCalendar.MaxDate);

  SetButtonState;
  updateText;
  try
    lbxHours.ItemIndex := -1;
    lbxMinutes.ItemIndex := -1;
  except
  end;
end;

procedure TfGMV_DateTime.bbtnMidnightClick(Sender: TObject);
begin
  edtTime.Text := FormatDateTime('hh:mm', 0);
  updateText;
  try
    lbxHours.ItemIndex := -1;
    lbxMinutes.ItemIndex := -1;
  except
  end;
end;

procedure TfGMV_DateTime.bbtnTodayClick(Sender: TObject);
begin
  mncCalendar.Date := Now - dltTime;
  SetDateTimeText;
  bbtnTomorrow.Enabled := False;
end;

procedure TfGMV_DateTime.SpeedButton1Click(Sender: TObject);
var
  T: TDateTime;
begin
  try
    T := StrToTime(edtTime.Text);
    if (T + trunc(mncCalendar.Date)) - mncCalendar.MaxDate > 2 / 24 / 3600 then
      MessageDlg('Sorry, you cannot select a future date or time', //AAN 10/30/2002
        mtError, [mbOk], 0) //AAN 10/30/2002
    else if (T + trunc(mncCalendar.Date)) < mncCalendar.MinDate then
      MessageDlg('Sorry, you cannot select a date more than 1 year old', //AAN 2003/06/04
        mtError, [mbOk], 0) //AAN 2003/06/04
    else
      ModalResult := mrOK
  except
    MessageDlg('Invalid time string.', mtError, [mbOk], 0);
    activecontrol := edtTime;
  end;
end;

procedure TfGMV_DateTime.SpeedButton2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfGMV_DateTime.edtTimeChange(Sender: TObject);
begin
  SetDateTimeText;
end;

procedure TfGMV_DateTime.SetDateTimeText;
begin
  pnlDateTimeText.Caption := FormatDateTime('    mm/dd/yy ', mncCalendar.Date) + edtTime.Text;
end;

procedure TfGMV_DateTime.mncCalendarClick(Sender: TObject);
begin
  SetDateTimeText;
  SetButtonState;
end;

function TfGMV_DateTime.TimeIsValid(h, m: Integer): boolean;
begin
  result :=
    (trunc(mncCalendar.Date) + h / 24 + m / 24 / 60 < mncCalendar.MaxDate)
    and
    (mncCalendar.MinDate < trunc(mncCalendar.Date) + h / 24 + m / 24 / 60);
end;

procedure TfGMV_DateTime.bbtnYesterdayClick(Sender: TObject);
begin
  try
    mncCalendar.Date := mncCalendar.Date - 1;
    UpdateText;
    SetButtonState;
  except
  end;
end;

procedure TfGMV_DateTime.bbtnTomorrowClick(Sender: TObject);
begin
  try
    mncCalendar.Date := mncCalendar.Date + 1;
    UpdateText;
    SetButtonState;
  except
  end;
end;

procedure TfGMV_DateTime.SetButtonState;
begin
  if trunc(mncCalendar.Date) = trunc(mncCalendar.MaxDate) then
    bbtnTomorrow.Enabled := False
  else
    bbtnTomorrow.Enabled := True;
  if trunc(mncCalendar.Date) = trunc(mncCalendar.MinDate) then
    bbtnYesterday.Enabled := False
  else
    bbtnYesterday.Enabled := True;
end;

procedure TfGMV_DateTime.FormActivate(Sender: TObject);
begin
  updateText;
  SetButtonState;
end;

procedure TfGMV_DateTime.Timer1Timer(Sender: TObject);
var
  aNow: TDateTime;
begin
  try
    aNow := Now - dltTime;
    label2.Caption := FormatDateTime(GMV_DateTimeFormat, aNow);
    mncCalendar.MaxDate := aNow;
  except
  end;
end;

procedure TfGMV_DateTime.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = char(VK_ESCAPE) then
    ModalResult := mrCancel;
end;

{$IFDEF DATETIMEDLL}
initialization
  PrevApp := Application;
  PrevScreen := Screen;

finalization
  Application := PrevApp;
  Screen := PrevScreen;
{$ENDIF}
end.

