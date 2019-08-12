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
    procedure lbxHoursEnter(Sender: TObject);
  private
    { Private declarations }
    dltTime: TDateTime;
    fLastHour: integer;
    fLastMin: integer;
    procedure SetDateTime;
    function TimeIsValid(h, m: Integer): Boolean;
    procedure SetButtonState;
    procedure setServerDelay;
    procedure setTimeBoundaries;
  public
    { Public declarations }
  end;

var
  fGMV_DateTime: TfGMV_DateTime;

implementation

uses
  uGMV_Common,
  uGMV_Engine, uGMV_Const, system.UITypes, DateUtils
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
  fLastHour := -1;
  fLastMin := -1;
  Caption := 'Select Date & Time up to ' + FormatDateTime('mm/dd/yyyy', mncCalendar.MaxDate) + ' and current time';
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
  setTimeBoundaries;
end;

procedure TfGMV_DateTime.SetDateTime;
var
  S: string;
  i, j: Integer;
begin
  try
    if lbxHours.ItemIndex = -1 then
      i := 0
      else
    i := StrToInt(lbxHours.Items[lbxHours.ItemIndex]);
  except
    i := 0;
  end;
  try
    if lbxMinutes.ItemIndex = -1 then
      j := 0
      else begin
    S := lbxMinutes.Items[lbxMinutes.ItemIndex];
    while (pos('0', S) = 1) or (pos(':', S) = 1) do
      S := copy(s, 2, Length(S) - 1);
    if pos(' --', S) = 1 then
      j := 0
    else
      j := StrToInt(Piece(S, ' ', 1));
      end;
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

procedure TfGMV_DateTime.lbxHoursEnter(Sender: TObject);
begin
setTimeBoundaries;
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
  setTimeBoundaries;
  caption := 'Select Date & Time up to ' + FormatDateTime('mm/dd/yyyy', mncCalendar.MaxDate) + ' and current time';

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
  setTimeBoundaries;
  SetDateTimeText;
  bbtnTomorrow.Enabled := False;
end;

procedure TfGMV_DateTime.SpeedButton1Click(Sender: TObject);
var
  T, aNow, aDte: TDateTime;
begin
  try
    //Dont expect an exception
    if Trim(edtTime.Text) = '' then
    begin
      MessageDlg('Invalid time string.', mtError, [mbOk], 0);
      activecontrol := edtTime;
      exit;
    end;

    //Dont expect an exception
    if StrToTimeDef(edtTime.Text, -1) = -1 then
    begin
      MessageDlg('Invalid time string.', mtError, [mbOk], 0);
      activecontrol := edtTime;
      exit;
    end;

    T := StrToTime(edtTime.Text);
    aNow := Now - dltTime;

    if (DateOf(mncCalendar.Date) = DateOf(aNow)) and
       ((HourOf(T) > HourOf(aNow)) or ((HourOf(T) = HourOf(aNow)) and (MinuteOf(t) > MinuteOf(aNow)))) then
    begin
      MessageDlg('Time can not be greater than current time ('+FormatDateTime('hh:mm', aNow)+')', mtError, [mbOk], 0);
      activecontrol := edtTime;
      edtTime.Text := FormatDateTime('hh:mm', aNow);
      exit;
    end;

    aDte := EncodeDateTime(YearOf(mncCalendar.Date), MonthOf(mncCalendar.Date), DayOf(mncCalendar.Date),
                           HourOf(t), MinuteOf(t), SecondOf(T), MilliSecondOf(T));
    if aDte > aNow then
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
  setTimeBoundaries;
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
    setTimeBoundaries;
    UpdateText;
    SetButtonState;
  except
  end;
end;

procedure TfGMV_DateTime.bbtnTomorrowClick(Sender: TObject);
begin
  try
    mncCalendar.Date := mncCalendar.Date + 1;
    setTimeBoundaries;
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
    setTimeBoundaries;
  except
  end;
end;

procedure TfGMV_DateTime.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = char(VK_ESCAPE) then
    ModalResult := mrCancel;
end;

procedure TfGMV_DateTime.setTimeBoundaries;
const
  AllHours: array [0 .. 23] of integer = (00, 01, 02, 03, 04, 05, 06, 07, 08,
    09, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23);
  AllMinutes: Array [0 .. 11] of integer = (00, 05, 10, 15, 20, 25, 30, 35, 40,
    45, 50, 55);

  Procedure AddAllToHourListBox;
  var
    i: integer;
    TxtToAdd: String;
  begin
    if fLastHour <> -1 then
    begin
      lbxHours.Clear;
      for i := Low(AllHours) to High(AllHours) do
      begin
        if AllHours[i] < 10 then
          TxtToAdd := '0' + IntToStr(AllHours[i])
        else
          TxtToAdd := IntToStr(AllHours[i]);
        lbxHours.Items.Add(TxtToAdd);
      end;
      fLastHour := -1;
    end;
  end;

  Procedure AddAllToMinuteListBox;
  var
    i: integer;
    LookUpTxt: String;
  begin
    if fLastMin <> -1 then
    begin
      lbxMinutes.Clear;
      for i := Low(AllMinutes) to High(AllMinutes) do
      begin
        if Odd(AllMinutes[i]) then
        begin
          if AllMinutes[i] < 10 then
            LookUpTxt := ':0' + IntToStr(AllMinutes[i])
          else
            LookUpTxt := ':' + IntToStr(AllMinutes[i]);
        end
        else
        begin
          if AllMinutes[i] < 10 then
            LookUpTxt := ':0' + IntToStr(AllMinutes[i]) + ' --'
          else
            LookUpTxt := ':' + IntToStr(AllMinutes[i]) + ' --';
        end;
        lbxMinutes.Items.Add(LookUpTxt);
      end;
      fLastMin := -1;
    end;
  end;

  Procedure AdjustListBox;
  var
    aHour, aMinute: word;
    aNow: TDateTime;
    LookUpTxt: String;
    i, Indx: integer;
  begin
    aNow := Now - dltTime;

    aHour := HourOf(aNow);
    if fLastHour <> aHour then
    begin
      for i := high(AllHours) downto low(AllHours) do
      begin
        if AllHours[i] < 10 then
          LookUpTxt := '0' + IntToStr(AllHours[i])
        else
          LookUpTxt := IntToStr(AllHours[i]);
        Indx := lbxHours.Items.IndexOf(LookUpTxt);
        if Indx < 0 then
        begin
          if AllHours[i] <= aHour then
            lbxHours.Items.Add(LookUpTxt)
        end
        else if AllHours[i] > aHour then
          lbxHours.Items.Delete(Indx);
      end;

      if lbxHours.ItemIndex > aHour then
      begin
        lbxHours.ItemIndex := -1;
        SetDateTime;
      end;

      fLastHour := aHour;
    end;

    // Do we need to limit the minutes
    if lbxHours.ItemIndex = aHour then
    begin
      aMinute := MinuteOf(aNow);
      if fLastMin <> aMinute then
      begin
        for i := High(AllMinutes) Downto Low(AllMinutes) do
        begin
          if Odd(AllMinutes[i]) then
          begin
            if AllMinutes[i] < 10 then
              LookUpTxt := ':0' + IntToStr(AllMinutes[i])
            else
              LookUpTxt := ':' + IntToStr(AllMinutes[i]);
          end
          else
          begin
            if AllMinutes[i] < 10 then
              LookUpTxt := ':0' + IntToStr(AllMinutes[i]) + ' --'
            else
              LookUpTxt := ':' + IntToStr(AllMinutes[i]) + ' --';
          end;

          Indx := lbxMinutes.Items.IndexOf(LookUpTxt);
          if Indx < 0 then
          begin
            if AllMinutes[i] <= aMinute then
              lbxMinutes.Items.Add(LookUpTxt);
          end
          else if AllMinutes[i] > aMinute then
            lbxMinutes.Items.Delete(Indx);
        end;

        if lbxMinutes.ItemIndex > aMinute then
        begin
          lbxMinutes.ItemIndex := -1;
          SetDateTime;
        end;

        fLastMin := aMinute;
      end;

    end
    else
      AddAllToMinuteListBox;

  end;

var
  aNow: TDateTime;
begin
  aNow := Now - dltTime;
  if DateOf(mncCalendar.Date) = DateOf(aNow) then
  begin
    // Need to set the hour
    AdjustListBox;
  end
  else
  begin
    // Not on the max date so all time is good
    AddAllToHourListBox;
    AddAllToMinuteListBox;
  end;
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
