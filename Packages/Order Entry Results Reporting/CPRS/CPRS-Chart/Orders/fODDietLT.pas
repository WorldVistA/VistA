unit fODDietLT;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, ExtCtrls, StdCtrls, ORFn, fODBase, rODBase, VA508AccessibilityManager;

type
  TfrmODDietLT = class(TfrmAutoSz)
    lblMealCutoff: TStaticText;
    Label2: TStaticText;
    GroupBox1: TGroupBox;
    cmdYes: TButton;
    cmdNo: TButton;
    radLT1: TRadioButton;
    radLT2: TRadioButton;
    radLT3: TRadioButton;
    chkBagged: TCheckBox;
    Bevel1: TBevel;
    procedure cmdYesClick(Sender: TObject);
    procedure cmdNoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FOutpatient: boolean;
    YesPressed: Boolean;
  public
    { Public declarations }
  end;

  TLateTrayFields = record
    LateMeal: Char;
    LateTime: string;
    IsBagged: Boolean;
  end;

procedure CheckLateTray(const StartTime: string; var LateTrayFields: TLateTrayFields; IsOutpatient: boolean; AMeal: char = #0);
procedure LateTrayCheck(SomeResponses: TResponses; EventId: integer; IsOutpatient: boolean; var LateTrayFields: TLateTrayFields);
procedure LateTrayOrder(LateTrayFields: TLateTrayFields; IsInpatient: boolean);

implementation

{$R *.DFM}

uses rCore, uCore, rODDiet, uConst, rOrders, uWriteAccess;

const
  TX_MEAL_REQ = 'A meal time must be selected.';
  TC_MEAL_REQ = 'No Meal Time Selected';

procedure CheckLateTray(const StartTime: string; var LateTrayFields: TLateTrayFields; IsOutpatient: boolean; AMeal: char = #0);
var
  frmODDietLT: TfrmODDietLT;
  DietParams: TDietParams;
  FMTime: TFMDateTime;
  TimePart: Extended;
  Meal: Char;
  AvailTimes,ALocation: string;
  TimeCount: Integer;

  function AMPMToFMTime(const x: string): Extended;
  var
    IntTime: Integer;
  begin
    Result := 0;
    if Pos(':', x) = 0 then Exit;
    IntTime := StrToIntDef(Piece(x, ':', 1) + Copy(Piece(x, ':', 2), 1, 2), 0);
    if (Pos('P', x) > 0) and (IntTime < 1200) then IntTime := IntTime + 1200;
    if (Pos('A', x) > 0) and (IntTime > 1200) then IntTime := IntTime - 1200;
    Result := IntTime / 10000;
  end;

  function FMTimeToAMPM(x: Extended): string;
  var
    TimePart: extended;
    AMPMTime, Suffix: string;
  begin
    TimePart := Frac(x);
    if TimePart > 0.1159 then
    begin
      if TimePart > 0.1259 then x := x - 0.12;
      Suffix := 'P'
    end
    else Suffix := 'A';
    AMPMTime := FormatFMDateTime('hh:nn', x);
    Result := AMPMTime + Suffix;
  end;

  procedure SetAvailTimes(ATime: Extended; var ACount: Integer; var TimeList: string);
  var
    i: Integer;
    ReturnList: string;
  begin
    ACount := 0;
    ReturnList := '';
    for i := 1 to 3 do
      if AMPMToFMTime(Piece(TimeList, U, i)) > ATime then
      begin
        if Length(ReturnList) > 0 then ReturnList := ReturnList + U;
        ReturnList := ReturnList + Piece(TimeList, U, i);
        Inc(ACount);
      end;
    TimeList := ReturnList;
  end;

begin
  // initialize LateTrayFields
  LateTrayFields.LateMeal := #0;
  LateTrayFields.LateTime := '';
  LateTrayFields.IsBagged := False;
  // make sure the start time is today and not in the future
  FMTime := StrToFMDateTime(StartTime);
  if FMTime < 0 then Exit;
  if Int(FMTime) <> FMToday then Exit;
  TimePart := Frac(FMTime);
  if TimePart = 0 then TimePart := Frac(FMNow);
  if TimePart > Frac(FMNow) then Exit;
  Meal := #0;
  ALocation := IntToStr(Encounter.Location);
  LoadDietParams(DietParams,ALocation);
  // check to see if falling within the alarm range of a meal
  if not IsOutpatient then
  begin
    if (TimePart > (StrToIntDef(Piece(DietParams.Alarms, U, 1), 0) / 10000)) and
       (TimePart < (StrToIntDef(Piece(DietParams.Alarms, U, 2), 0) / 10000)) then Meal := 'B';
    if (TimePart > (StrToIntDef(Piece(DietParams.Alarms, U, 3), 0) / 10000)) and
       (TimePart < (StrToIntDef(Piece(DietParams.Alarms, U, 4), 0) / 10000)) then Meal := 'N';
    if (TimePart > (StrToIntDef(Piece(DietParams.Alarms, U, 5), 0) / 10000)) and
       (TimePart < (StrToIntDef(Piece(DietParams.Alarms, U, 6), 0) / 10000)) then Meal := 'E';
    if Meal = #0 then Exit;
  end
  else  // for outpatients
  begin
(*  From Rich Knoepfle, NFS developer
If they order a breakfast and it is after the LATE BREAKFAST ALARM END, I don't allow them to do it.  (For special meals I don't allow them to order something for the following day).
If it's before the LATE BREAKFAST ALARM BEGIN than I accept the order.
If it's between the LATE BREAKFAST ALARM BEGIN and ALARM END then I ask if they want to order a Late breakfast tray.
*)
    Meal := AMeal;
    case AMeal of
      'B':  if (TimePart < (StrToIntDef(Piece(DietParams.Alarms, U, 1), 0) / 10000)) or
               (TimePart > (StrToIntDef(Piece(DietParams.Alarms, U, 2), 0) / 10000)) then Meal := #0;
      'N':  if (TimePart < (StrToIntDef(Piece(DietParams.Alarms, U, 3), 0) / 10000)) or
               (TimePart > (StrToIntDef(Piece(DietParams.Alarms, U, 4), 0) / 10000)) then Meal := #0;
      'E':  if (TimePart < (StrToIntDef(Piece(DietParams.Alarms, U, 5), 0) / 10000)) or
               (TimePart > (StrToIntDef(Piece(DietParams.Alarms, U, 6), 0) / 10000)) then Meal := #0;
    end;
    if Meal = #0 then exit;
  end;

  // get the available late times for this meal
  case Meal of
  'B': AvailTimes := Pieces(DietParams.BTimes, U, 4, 6);
  'E': AvailTimes := Pieces(DietParams.ETimes, U, 4, 6);
  'N': AvailTimes := Pieces(DietParams.NTimes, U, 4, 6);
  end;
  SetAvailTimes(TimePart, TimeCount, AvailTimes);
  if TimeCount = 0 then Exit;

  // setup form to get the selected late tray
  frmODDietLT := TfrmODDietLT.Create(Application);
  try
    ResizeFormToFont(TForm(frmODDietLT));
    with frmODDietLT do
    begin
      FOutpatient := IsOutpatient;
      if Length(Piece(AvailTimes, U, 1)) > 0 then radLT1.Caption := Piece(AvailTimes, U, 1);
      if Length(Piece(AvailTimes, U, 2)) > 0 then radLT2.Caption := Piece(AvailTimes, U, 2);
      if Length(Piece(AvailTimes, U, 3)) > 0 then radLT3.Caption := Piece(AvailTimes, U, 3);
      radLT1.Visible := Length(radLT1.Caption) > 0;
      radLT2.Visible := Length(radLT2.Caption) > 0;
      radLT3.Visible := Length(radLT3.Caption) > 0;
      radLT1.Checked := TimeCount = 1;
      chkBagged.Visible := DietParams.Bagged;
      with lblMealCutOff do case Meal of
      'B': Caption := 'You have missed the breakfast cut-off.';
      'E': Caption := 'You have missed the evening cut-off.';
      'N': Caption := 'You have missed the noon cut-off.';
      end;
      // display the form
      ShowModal;
      if YesPressed then
      begin
        with radLT1 do if Checked then LateTrayFields.LateTime := Caption;
        with radLT2 do if Checked then LateTrayFields.LateTime := Caption;
        with radLT3 do if Checked then LateTrayFields.LateTime := Caption;
        LateTrayFields.LateMeal := Meal;
        LateTrayFields.IsBagged := chkBagged.Checked;
      end;
    end; {with frmODDietLT}
  finally
    frmODDietLT.Release;
  end;
end;

procedure LateTrayCheck(SomeResponses: TResponses; EventId: integer; IsOutpatient: boolean; var LateTrayFields: TLateTrayFields);
var
  AResponse, AnotherResponse: TResponse;
begin
  if IsOutpatient then
  begin
    AResponse := SomeResponses.FindResponseByName('ORDERABLE', 1);
    if (EventID = 0) and (AResponse <> nil) and (Copy(AResponse.EValue, 1, 3) <> 'NPO') then
    begin
      AResponse := SomeResponses.FindResponseByName('START', 1);
      AnotherResponse := SomeResponses.FindResponseByName('MEAL', 1);
      if (AResponse <> nil) and (AnotherResponse <> nil) then
        CheckLateTray(AResponse.IValue, LateTrayFields, True, CharAt(AnotherResponse.IValue, 1));
    end;
  end
  else
  begin
    AResponse := SomeResponses.FindResponseByName('ORDERABLE', 1);
    if (EventID = 0) and (AResponse <> nil) and (Copy(AResponse.EValue, 1, 3) <> 'NPO') then
    begin
      AResponse := SomeResponses.FindResponseByName('START', 1);
      if AResponse <> nil then CheckLateTray(AResponse.IValue, LateTrayFields, False);
    end;
  end;
end;

procedure LateTrayOrder(LateTrayFields: TLateTrayFields; IsInpatient: boolean);
const
  TX_EL_SAVE_ERR    = 'An error occurred while saving this late tray order.';
  TC_EL_SAVE_ERR    = 'Error Saving Late Tray Order';
var
  NewOrder: TOrder;
  CanSign: integer;
begin
  NewOrder := TOrder.Create;
  try
    with LateTrayFields do OrderLateTray(NewOrder, LateMeal, LateTime, IsBagged);
    if NewOrder.ID <> '' then
    begin
      if IsInpatient then
        begin
          if (Encounter.Provider = User.DUZ) and User.CanSignOrders
            then CanSign := CH_SIGN_YES
            else CanSign := CH_SIGN_NA;
        end
      else
        begin
          CanSign := CH_SIGN_NA;
        end;
        Changes.Add(CH_ORD, NewOrder.ID, NewOrder.Text, '', CanSign, waOrders,
          '', 0, NewOrder.DGroup);
        SendMessage(Application.MainForm.Handle, UM_NEWORDER, ORDER_NEW,
          integer(NewOrder))
      end
    else InfoBox(TX_EL_SAVE_ERR, TC_EL_SAVE_ERR, MB_OK);
  finally
    NewOrder.Free;
  end;
end;

// ---------- frmODDietLT procedures ---------------
procedure TfrmODDietLT.FormCreate(Sender: TObject);
begin
  inherited;
  YesPressed := False;
end;

procedure TfrmODDietLT.cmdYesClick(Sender: TObject);
begin
  inherited;
    if (radLT1.Checked = False) and (radLT2.Checked = False) and (radLT3.Checked = False) then
    begin
      InfoBox(TX_MEAL_REQ, TC_MEAL_REQ, MB_OK);
      Exit;
    end;
  YesPressed := True;
  Close;
end;

procedure TfrmODDietLT.cmdNoClick(Sender: TObject);
begin
  inherited;
  Close;
end;

end.
