unit fODMedComplex;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, StdCtrls, Grids, Buttons, ExtCtrls, ORCtrls, Menus, ORFn, fODBase, uConst,
  ComCtrls, VA508AccessibilityManager;

type
  TfrmODMedComplex = class(TfrmAutoSz)
    grdDoses: TStringGrid;
    cmdOK: TButton;
    cmdCancel: TButton;
    cboRoute: TORComboBox;
    cboSchedule: TORComboBox;
    pnlInstruct: TPanel;
    cboInstruct: TORComboBox;
    btnUnits: TSpeedButton;
    pnlDays: TPanel;
    txtDays: TCaptionEdit;
    Label1: TLabel;
    popUnits: TPopupMenu;
    Bevel1: TBevel;
    cmdInsert: TButton;
    cmdRemove: TButton;
    UpDown2: TUpDown;
    procedure FormCreate(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure btnUnitsClick(Sender: TObject);
    procedure pnlInstructExit(Sender: TObject);
    procedure cboRouteExit(Sender: TObject);
    procedure cboScheduleExit(Sender: TObject);
    procedure pnlDaysExit(Sender: TObject);
    procedure grdDosesDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure pnlInstructEnter(Sender: TObject);
    procedure pnlDaysEnter(Sender: TObject);
    procedure grdDosesMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cmdInsertClick(Sender: TObject);
    procedure cmdRemoveClick(Sender: TObject);
    procedure grdDosesMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure grdDosesKeyPress(Sender: TObject; var Key: Char);
    procedure txtDaysChange(Sender: TObject);
    procedure cboRouteClick(Sender: TObject);
  private
    FDropColumn: Integer;
    procedure ShowEditor(ACol, ARow: Integer; AChar: Char);
    procedure UnitClick(Sender: TObject);
    procedure Validate(var AnErrMsg: string);
    function ValFor(FieldID, ARow: Integer): string;
    procedure UMDelayEvent(var Message: TMessage); message UM_DELAYEVENT;
  public
    { Public declarations }
  end;

function ExecuteComplexDose(CtrlInits: TCtrlInits; Responses: TResponses): Boolean;

implementation

{$R *.DFM}

uses rODBase, System.Types, VAUtils, UResponsiveGUI;

const
  COL_SELECT   =  0;
  COL_INSTRUCT =  1;
  COL_ROUTE    =  2;
  COL_SCHEDULE =  3;
  COL_DURATION =  4;
  VAL_INSTR    = 10;
  VAL_MISC     = 11;
  VAL_ROUTE    = 12;
  VAL_SCHEDULE = 13;
  VAL_DAYS     = 14;
  VAL_ABBROUTE = 15;
  TAB          = #9;
  TX_NO_AMPER  = ' Instructions may not contain the ampersand (&) character.';
  TX_NF_ROUTE  = ' not found in the Medication Routes file.';
  TX_NO_ROUTE  = ': Route must be entered.';
  TX_NO_SCHED  = ': Schedule must be entered.';

{ public functions }

function ExecuteComplexDose(CtrlInits: TCtrlInits; Responses: TResponses): Boolean;
var
  frmODMedComplex: TfrmODMedComplex;
  AResponse: TResponse;
  AnInstance, ARow: Integer;
  x: string;
begin
  frmODMedComplex := TfrmODMedComplex.Create(Application);
  try
    ResizeFormToFont(TForm(frmODMedComplex));
    with frmODMedComplex do
    begin
      grdDoses.Cells[COL_INSTRUCT, 0] := CtrlInits.DefaultText('Verb');
      if grdDoses.Cells[COL_INSTRUCT, 0] = '' then grdDoses.Cells[COL_INSTRUCT, 0] := 'Amount';
      CtrlInits.SetControl(cboInstruct, 'Instruct');
      CtrlInits.SetPopupMenu(popUnits, UnitClick, 'Nouns');
      CtrlInits.SetControl(cboRoute,    'Route');
      CtrlInits.SetControl(cboSchedule, 'Schedules');
      with Responses do
      begin
        grdDoses.RowCount := InstanceCount('INSTR') + 2;  // 1 row for headers, 1 for new dose
        ARow := 1;                                        // row 1 is first dose row
        AnInstance := NextInstance('INSTR', 0);
        while AnInstance > 0 do
        begin
          grdDoses.Cells[COL_INSTRUCT, ARow] :=
            IValueFor('INSTR', AnInstance) + ' ' + IValueFor('MISC', AnInstance) + TAB +
            IValueFor('INSTR', AnInstance) + TAB + IValueFor('MISC', AnInstance);
          AResponse := FindResponseByName('ROUTE', AnInstance);
          cboRoute.SelectByID(AResponse.IValue);
          with cboRoute do if ItemIndex > -1 then x := DisplayText[ItemIndex];
          grdDoses.Cells[COL_ROUTE,    ARow] := x + TAB + AResponse.IValue + TAB + AResponse.EValue;
          grdDoses.Cells[COL_SCHEDULE, ARow] := IValueFor('SCHEDULE', AnInstance);
          x := IValueFor('DAYS', AnInstance);
          if Length(x) > 0 then x := x + ' day(s)';
          grdDoses.Cells[COL_DURATION, ARow] := x + TAB + IValueFor('DAYS', AnInstance);
          AnInstance := NextInstance('INSTR', AnInstance);
          Inc(ARow);
        end; {while AnInstance}
      end; {with Responses}
    end;
    Result := frmODMedComplex.ShowModal = mrOK;
    if Result then with frmODMedComplex, grdDoses, Responses do
    begin
      Clear('INSTR');
      Clear('MISC');
      Clear('ROUTE');
      Clear('SCHEDULE');
      Clear('DAYS');
      for ARow := 1 to Pred(RowCount) do
      begin
        if Length(ValFor(VAL_INSTR, ARow)) > 0 then
        begin
          Update('INSTR',    ARow, ValFor(VAL_INSTR,    ARow), ValFor(VAL_INSTR,    ARow));
          if Length(ValFor(VAL_MISC, ARow)) > 0 then
            Update('MISC',   ARow, ValFor(VAL_MISC,     ARow), ValFor(VAL_MISC,     ARow));
          Update('ROUTE',    ARow, ValFor(VAL_ROUTE,    ARow), ValFor(VAL_ABBROUTE, ARow));
          Update('SCHEDULE', ARow, ValFor(VAL_SCHEDULE, ARow), ValFor(COL_SCHEDULE, ARow));
          Update('DAYS',     ARow, ValFor(VAL_DAYS,     ARow), ValFor(VAL_DAYS,     ARow));
        end; {if Length}
      end; {with...for}
    end; {if Result}
  finally
    frmODMedComplex.Release;
  end;
end;

{ General Functions - get & set cell values}

function TfrmODMedComplex.ValFor(FieldID, ARow: Integer): string;
{ Contents of grid cells is as follows (cells delimited by |, ^ indicates tab char)
    InstructionText^INSTR^MISC | RouteText^ROUTE^Abbrev. | SCHEDULE  DurationText^DAYS
  Only the first tab piece for each cell is drawn. }
begin
  Result := '';
  if (ARow < 1) or (ARow >= grdDoses.RowCount) then Exit;
  with grdDoses do
    case FieldID of
    COL_INSTRUCT : Result := Piece(Cells[COL_INSTRUCT, ARow], TAB, 1);
    COL_ROUTE    : Result := Piece(Cells[COL_ROUTE,    ARow], TAB, 1);
    COL_SCHEDULE : Result := Piece(Cells[COL_SCHEDULE, ARow], TAB, 1);
    COL_DURATION : Result := Piece(Cells[COL_DURATION, ARow], TAB, 1);
    VAL_INSTR    : Result := Piece(Cells[COL_INSTRUCT, ARow], TAB, 2);
    VAL_MISC     : Result := Piece(Cells[COL_INSTRUCT, ARow], TAB, 3);
    VAL_ROUTE    : Result := Piece(Cells[COL_ROUTE,    ARow], TAB, 2);
    VAL_SCHEDULE : Result := Piece(Cells[COL_SCHEDULE, ARow], TAB, 1);
    VAL_DAYS     : Result := Piece(Cells[COL_DURATION, ARow], TAB, 2);
    VAL_ABBROUTE : Result := Piece(Cells[COL_ROUTE,    ARow], Tab, 3);
    end;
end;

procedure FindInCombo(const x: string; AComboBox: TORComboBox);
var
  i, Found: Integer;
begin
  with AComboBox do
  begin
    i := 0;
    Found := -1;
    while (i < Items.Count) and (Found < 0) do
    begin
      if CompareText(Copy(DisplayText[i], 1, Length(x)), x) = 0 then Found := i;
      Inc(i);
    end; {while}
    if Found > -1 then
    begin
      ItemIndex := Found;
      TResponsiveGUI.ProcessMessages;
      SelStart  := 1;
      SelLength := Length(Items[Found]);
    end else
    begin
      Text := x;
      SelStart := Length(x);
    end;
  end; {with AComboBox}
end;

{ Form Events }

procedure TfrmODMedComplex.FormCreate(Sender: TObject);
begin
  inherited;
  with grdDoses do
  begin
    ColWidths[COL_SELECT]   := 12;
    ColWidths[COL_INSTRUCT] := 160;
    Cells[COL_INSTRUCT, 0]  := 'Amount';
    Cells[COL_ROUTE,    0]  := 'Route';
    Cells[COL_SCHEDULE, 0]  := 'Schedule';
    Cells[COL_DURATION, 0]  := 'Duration';
  end;
  FDropColumn := -1;
end;

{ grdDoses events (including cell editors) }

procedure TfrmODMedComplex.grdDosesMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  ACol, ARow: Integer;
begin
  inherited;
  grdDoses.MouseToCell(X, Y, ACol, ARow);
  if (ARow < 0) or (ACol < 0) then Exit;
  if ACol > COL_SELECT then ShowEditor(ACol, ARow, #0) else
  begin
    grdDoses.Col := COL_INSTRUCT;
    grdDoses.Row := ARow;
  end;
end;

procedure TfrmODMedComplex.grdDosesKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if Key = #13 then ShowEditor(grdDoses.Col, grdDoses.Row, #0);
  if CharInSet(Key, [#32..#127]) then ShowEditor(grdDoses.Col, grdDoses.Row, Key);
end;

procedure TfrmODMedComplex.grdDosesMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  case FDropColumn of
  COL_INSTRUCT: with cboInstruct do if Items.Count > 0 then DroppedDown := True;
  COL_ROUTE:    with cboRoute    do if Items.Count > 0 then DroppedDown := True;
  COL_SCHEDULE: with cboSchedule do if Items.Count > 0 then DroppedDown := True;
  end;
  FDropColumn := -1;
end;

procedure TfrmODMedComplex.grdDosesDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
  State: TGridDrawState);
{ only show the first tab piece of the cell }
begin
  inherited;
  grdDoses.Canvas.TextRect(Rect, Rect.Left+2, Rect.Top+2,
    Piece(grdDoses.Cells[ACol, ARow], TAB, 1));
end;

procedure TfrmODMedComplex.ShowEditor(ACol, ARow: Integer; AChar: Char);

  procedure PlaceControl(AControl: TWinControl);
  var
    ARect: TRect;
  begin
    with AControl do
    begin
      ARect := grdDoses.CellRect(ACol, ARow);
      SetBounds(ARect.Left + grdDoses.Left + 1,  ARect.Top  + grdDoses.Top + 1,
                ARect.Right - ARect.Left + 1,    ARect.Bottom - ARect.Top + 1);
      BringToFront;
      Show;
      SetFocus;
    end;
  end;

begin
  inherited;
  if ARow = 0 then Exit;  // header row
  // require initial instruction entry when in last row
  with grdDoses do if (ARow = Pred(RowCount)) and (ACol > COL_INSTRUCT) and
    (ValFor(VAL_INSTR, ARow) = '') then Exit;
  // only allow route when in first row
  if (ACol = COL_ROUTE) and (ARow > 1) then Exit;
  // display appropriate editor for row & column
  case ACol of
  COL_INSTRUCT: begin
                  // if this is the last row, default the route & schedule to previous row
                  if (ARow > 1) and (ARow = Pred(grdDoses.RowCount)) then
                  begin
                    grdDoses.Cells[COL_INSTRUCT, ARow] := TAB + TAB + ValFor(VAL_MISC, Pred(ARow));
                    grdDoses.Cells[COL_ROUTE,    ARow] := grdDoses.Cells[COL_ROUTE,    Pred(ARow)];
                    grdDoses.Cells[COL_SCHEDULE, ARow] := grdDoses.Cells[COL_SCHEDULE, Pred(ARow)];
                  end;
                  // set appropriate value for cboInstruct & btnUnits
                  btnUnits.Caption := ValFor(VAL_MISC, ARow);
                  pnlInstruct.Tag := ARow;
                  if popUnits.Items.Count = 0 then
                  begin
                    btnUnits.Visible := False;
                    cboInstruct.Width := pnlInstruct.Width;
                  end;
                  PlaceControl(pnlInstruct);
                  FDropColumn := COL_INSTRUCT;
                  if AChar <> #0
                    then PostMessage(Handle, UM_DELAYEVENT, Ord(AChar), COL_INSTRUCT)
                    else cboInstruct.Text := ValFor(VAL_INSTR, ARow);
                end;
  COL_ROUTE:    begin
                  // set appropriate value for cboRoute
                  cboRoute.SelectByID(ValFor(VAL_ROUTE, ARow));
                  if cboRoute.Text = '' then cboRoute.Text := ValFor(COL_ROUTE, ARow);
                  cboRoute.Tag := ARow;
                  PlaceControl(cboRoute);
                  FDropColumn := COL_ROUTE;
                  if AChar <> #0 then PostMessage(Handle, UM_DELAYEVENT, Ord(AChar), COL_ROUTE);
                end;
  COL_SCHEDULE: begin
                  // set appropriate value for cboSchedule
                  cboSchedule.Tag := ARow;
                  PlaceControl(cboSchedule);
                  FDropColumn := COL_SCHEDULE;
                  if AChar <> #0
                    then PostMessage(Handle, UM_DELAYEVENT, Ord(AChar), COL_SCHEDULE)
                    else cboSchedule.Text := ValFor(COL_SCHEDULE, ARow);
                end;
  COL_DURATION: begin
                  // set appropriate value for txtDays
                  pnlDays.Tag := ARow;
                  PlaceControl(pnlDays);
                  txtDays.SetFocus;
                  if AChar <> #0
                    then PostMessage(Handle, UM_DELAYEVENT, Ord(AChar), COL_DURATION)
                    else txtDays.Text := ValFor(VAL_DAYS, ARow);
                end;
  end; {case ACol}
end;

procedure TfrmODMedComplex.UMDelayEvent(var Message: TMessage);
{ after focusing events are completed for a combobox, set the key the user typed }
begin
  case Message.LParam of
  COL_INSTRUCT : FindInCombo(Chr(Message.WParam), cboInstruct);
  COL_ROUTE    : FindInCombo(Chr(Message.WParam), cboRoute);
  COL_SCHEDULE : FindInCombo(Chr(Message.WParam), cboSchedule);
  COL_DURATION : begin
                   txtDays.Text := Chr(Message.WParam);
                   txtDays.SelStart := 1;
                 end;
  end;
end;

{ Instructions Editor }

procedure TfrmODMedComplex.pnlInstructEnter(Sender: TObject);
begin
  inherited;
  // if this was the last row, create a new last row
  if grdDoses.Row = Pred(grdDoses.RowCount) then grdDoses.RowCount := grdDoses.RowCount + 1;
  // shift focus to the combobox portion of the instructions panel
  cboInstruct.SetFocus;
end;

procedure TfrmODMedComplex.pnlInstructExit(Sender: TObject);
var
  ARow: Integer;
begin
  inherited;
  ARow := pnlInstruct.Tag;
  // clear the rest of the row if no instruction has been entered
  with grdDoses do if (ARow = Pred(RowCount)) and (cboInstruct.Text = '') then
  begin
    Cells[COL_INSTRUCT, ARow] := '';
    Cells[COL_ROUTE,    ARow] := '';
    Cells[COL_SCHEDULE, ARow] := '';
    Cells[COL_DURATION, ARow] := '';
    Exit;
  end;
  // save entered information in the cell
  grdDoses.Cells[COL_INSTRUCT, ARow] := cboInstruct.Text + ' ' + btnUnits.Caption + TAB +
    cboInstruct.Text + TAB + btnUnits.Caption;
  pnlInstruct.Tag := -1;
  pnlInstruct.Hide;
end;

procedure TfrmODMedComplex.btnUnitsClick(Sender: TObject);
var
  APoint: TPoint;
begin
  inherited;
  APoint := btnUnits.ClientToScreen(Point(0, btnUnits.Height));
  popUnits.Popup(APoint.X, APoint.Y);
end;

procedure TfrmODMedComplex.UnitClick(Sender: TObject);
begin
  btnUnits.Caption := TMenuItem(Sender).Caption;
end;

{ Route Editor }

procedure TfrmODMedComplex.cboRouteClick(Sender: TObject);
{ force all routes to be the same (until pharmacy changes to accomodate varying routes) }
var
  i: Integer;
  x: string;
begin
  inherited;
  with cboRoute do if ItemIndex > -1
    then x := Piece(Items[ItemIndex], U, 3)
    else x := cboRoute.Text;
  for i := 1 to Pred(grdDoses.RowCount) do
    if Length(ValFor(VAL_INSTR, i)) > 0
      then grdDoses.Cells[COL_ROUTE, i] := cboRoute.Text + TAB + cboRoute.ItemID + TAB + x;
end;

procedure TfrmODMedComplex.cboRouteExit(Sender: TObject);
begin
  inherited;
  cboRouteClick(Self);
  cboRoute.Tag := -1;
  cboRoute.Hide;
end;

{ Schedule Editor }

procedure TfrmODMedComplex.cboScheduleExit(Sender: TObject);
begin
  inherited;
  grdDoses.Cells[COL_SCHEDULE, cboSchedule.Tag] := cboSchedule.Text;
  cboSchedule.Tag := -1;
  cboSchedule.Hide;
end;

{ Duration Editor }

procedure TfrmODMedComplex.pnlDaysEnter(Sender: TObject);
begin
  inherited;
  txtDays.SetFocus;
end;

procedure TfrmODMedComplex.pnlDaysExit(Sender: TObject);
var
  x: string;
begin
  inherited;
  x := txtDays.Text;
  if Length(x) > 0 then x := x + ' day(s)';
  x := x + TAB + txtDays.Text;
  grdDoses.Cells[COL_DURATION, pnlDays.Tag] := x;
  pnlDays.Tag := -1;
  pnlDays.Hide;
end;

procedure TfrmODMedComplex.txtDaysChange(Sender: TObject);
begin
  inherited;
  if txtDays.Text = '0' then txtDays.Text := '';
end;

{ Command Buttons }

procedure TfrmODMedComplex.cmdInsertClick(Sender: TObject);
var
  i: Integer;
  x0, x1, x2: string;
begin
  inherited;
  cmdInsert.SetFocus;                            // make sure exit events for editors fire
  with grdDoses do
  begin
    if Row < 1 then Exit;
    x0 := TAB + TAB + ValFor(VAL_MISC, Row);
    x1 := grdDoses.Cells[COL_ROUTE,    Row];
    x2 := grdDoses.Cells[COL_SCHEDULE, Row];
    RowCount := RowCount + 1;
    { move rows down }
    for i := Pred(RowCount) downto Succ(Row) do Rows[i] := Rows[i-1];
    Rows[Row].Clear;
    Cells[COL_INSTRUCT, Row] := x0;
    Cells[COL_ROUTE,    Row] := x1;
    Cells[COL_SCHEDULE, Row] := x2;
    Col := COL_INSTRUCT;
    ShowEditor(COL_INSTRUCT, Row, #0);
  end;
end;

procedure TfrmODMedComplex.cmdRemoveClick(Sender: TObject);
var
  i: Integer;
begin
  inherited;
  cmdRemove.SetFocus;                            // make sure exit events for editors fire
  with grdDoses do if (Row > 0) and (RowCount > 2) then
  begin
    { move rows up }
    for i := Row to RowCount - 2 do Rows[i] := Rows[i+1];
    RowCount := RowCount - 1;
    Rows[RowCount].Clear;
  end;
end;

procedure TfrmODMedComplex.Validate(var AnErrMsg: string);
var
  i: Integer;
  RouteID, RouteAbbr: string;

  procedure SetError(const x: string);
  begin
    if Length(AnErrMsg) > 0 then AnErrMsg := AnErrMsg + CRLF;
    AnErrMsg := AnErrMsg + x;
  end;

begin
  AnErrMsg := '';
  with grdDoses do for i := 1 to Pred(RowCount) do
  begin
    if Length(ValFor(VAL_INSTR, i)) > 0 then
    begin
      if Pos('&', cboInstruct.Text) > 0 then SetError(IntToStr(i) + TX_NO_AMPER);
      if ValFor(COL_ROUTE,    i) = ''   then SetError(IntToStr(i) + TX_NO_ROUTE);
      if ValFor(COL_SCHEDULE, i) = ''   then SetError(IntToStr(i) + TX_NO_SCHED);
      if (ValFor(VAL_ROUTE,    i) = '') and (Length(ValFor(COL_ROUTE, i)) > 0) then
      begin
        LookupRoute(ValFor(COL_ROUTE, i), RouteID, RouteAbbr);
        if RouteID = '0'
          then SetError(ValFor(COL_ROUTE, i) + TX_NF_ROUTE)
          else Cells[COL_ROUTE, i] := ValFor(COL_ROUTE, i) + TAB + RouteID + TAB + RouteAbbr;
      end; {if ValFor}
    end; {if Length}
  end; {with grdDoses...for i}
end;

procedure TfrmODMedComplex.cmdOKClick(Sender: TObject);
var
  ErrMsg: string;
begin
  inherited;
  cmdOK.SetFocus;                                // make sure exit events for editors fire
  Validate(ErrMsg);
  if ShowMsgOn(Length(ErrMsg) > 0, ErrMsg, 'Error') then Exit;
  ModalResult := mrOK;
end;

procedure TfrmODMedComplex.cmdCancelClick(Sender: TObject);
begin
  inherited;
  Close;
end;

{ Test Stuff }

end.
