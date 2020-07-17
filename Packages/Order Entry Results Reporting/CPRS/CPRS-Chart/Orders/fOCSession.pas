unit fOCSession;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  fOCMonograph,
  fBase508Form,
  System.UITypes,
  StdCtrls,
  ORFn,
  uConst,
  ORCtrls,
  ExtCtrls,
  VA508AccessibilityManager,
  Grids,
  strUtils,
  uDlgComponents,
  VAUtils,
  VA508AccessibilityRouter;

type
  TfrmOCSession = class(TfrmBase508Form)
    pnlBottom: TPanel;
    lblJustify: TLabel;
    txtJustify: TCaptionEdit;
    cmdCancelOrder: TButton;
    cmdContinue: TButton;
    btnReturn: TButton;
    memNote: TMemo;
    cmdMonograph: TButton;
    grdchecks: TCaptionStringGrid;
    pnlTop: TORAutoPanel;
    lblHover: TLabel;
    pnlInstr: TPanel;
    procedure cmdCancelOrderClick(Sender: TObject);
    procedure cmdContinueClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure txtJustifyKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnReturnClick(Sender: TObject);
    procedure memNoteEnter(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cmdMonographClick(Sender: TObject);
    procedure grdchecksDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    function CheckBoxRect(poRect: TRect): TRect;
    function GetCheckState(grid: TStringGrid; ACol, ARow: Integer): boolean;
    function InCheckBox(grid: TStringGrid; X, Y, ACol, ARow: Integer): boolean;
    procedure SetCheckState(grid: TStringGrid; ACol, ARow: Integer; State: boolean);
    procedure grdchecksMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure grdchecksSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: boolean);
    procedure GridDeleteRow(RowNumber: Integer; grid: TStringGrid);
    procedure grdchecksEnter(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure grdchecksKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure grdchecksMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    FCritical: boolean;
    FCancelSignProcess: boolean;
    FCheckList: TStringList;
    FOrderList: TStringList;
    procedure SetReqJustify;
    procedure SetReturn(const Value: boolean);
  public
    { Public declarations }
    property CancelSignProcess: boolean read FCancelSignProcess write SetReturn default false;
  end;

procedure ExecuteReleaseOrderChecks(SelectList: TList);
function ExecuteSessionOrderChecks(OrderList: TStringList): boolean;

implementation

{$R *.DFM}

uses
  rOrders,
  uCore,
  rMisc,
  fFrame;

type
  TOCRec = class
  public
    OrderID: string;
    OrderText: string;
    Checks: TStringList;
    constructor Create(const AnID: string);
    destructor Destroy; override;
  end;

var
  uCheckedOrders: TList;
  FOldHintHidePause: Integer;

constructor TOCRec.Create(const AnID: string);
begin
  OrderID := AnID;
  Checks := TStringList.Create;
  FOldHintHidePause := Application.HintHidePause;
end;

destructor TOCRec.Destroy;
begin
  Application.HintHidePause := FOldHintHidePause;
  Checks.Free;
  inherited Destroy;
end;

procedure ExecuteReleaseOrderChecks(SelectList: TList);
var
  i: Integer;
  AnOrder: TOrder;
  OrderIDList: TStringList;
begin
  OrderIDList := TStringList.Create;
  try
    for i := 0 to SelectList.Count - 1 do
      begin
        AnOrder := TOrder(SelectList.Items[i]);
        OrderIDList.Add(AnOrder.ID + '^^1'); // 3rd pce = 1 means releasing order
      end;
    while OrderIDList.Count > 0 do
      begin
        if ExecuteSessionOrderChecks(OrderIDList) then
          begin
            for i := SelectList.Count - 1 downto 0 do
              begin
                AnOrder := TOrder(SelectList.Items[i]);
                if OrderIDList.IndexOf(AnOrder.ID + '^^1') < 0 then
                  begin
                    Changes.Remove(CH_ORD, AnOrder.ID);
                    SelectList.Delete(i);
                  end;
              end;
            Break;
          end;
      end;
    if OrderIDList.Count < 1 then
      SelectList.Clear;
  finally
    OrderIDList.Free;
  end;
end;

{ Returns True if the Signature process should proceed.
  Clears OrderList If False. }
function ExecuteSessionOrderChecks(OrderList: TStringList): boolean;
var
  i, j, k, l, m, n, rowcnt: Integer;
  LastID, NewID, gridtext: string;
  CheckList, remOC: TStringList;
  OCRec: TOCRec;
  frmOCSession: TfrmOCSession;
  X, substring: string;
begin
  Result := True;
  CheckList := TStringList.Create;
  try
    StatusText('Order Checking...');
    OrderChecksForSession(CheckList, OrderList);
    StatusText('');
    if CheckList.Count > 0 then
      begin
        frmOCSession := TfrmOCSession.Create(Application);
        rowcnt := 1;
        frmOCSession.grdchecks.canvas.Font.Name := 'Courier New';
        frmOCSession.grdchecks.canvas.Font.Size := MainFontSize;
        frmOCSession.cmdMonograph.Enabled := false;
        if IsMonograph then
          frmOCSession.cmdMonograph.Enabled := True;
        try
          uCheckedOrders := TList.Create;
          LastID := '';
          for i := 0 to CheckList.Count - 1 do
            begin
              NewID := Piece(CheckList[i], U, 1);
              if NewID <> LastID then
                begin
                  OCRec := TOCRec.Create(NewID);
                  uCheckedOrders.Add(OCRec);
                  LastID := NewID;
                end; { if NewID }
            end; { for i }
          with uCheckedOrders do
            for i := 0 to Count - 1 do
              begin
                OCRec := TOCRec(Items[i]);
                X := TextForOrder(OCRec.OrderID);
                OCRec.OrderText := X;
                frmOCSession.grdchecks.Cells[2, rowcnt] := OCRec.OrderID + '^O^0^';
                frmOCSession.grdchecks.Cells[1, rowcnt] := OCRec.OrderText;
                rowcnt := rowcnt + 1;
                if rowcnt > frmOCSession.grdchecks.RowCount then
                  frmOCSession.grdchecks.RowCount := rowcnt;
                l := 0;
                m := 0;
                for j := 0 to CheckList.Count - 1 do
                  if Piece(CheckList[j], U, 1) = OCRec.OrderID then
                    m := m + 1;

                for j := 0 to CheckList.Count - 1 do
                  if Piece(CheckList[j], U, 1) = OCRec.OrderID then
                    begin
                      l := l + 1;
                      gridtext := '';
                      substring := Copy(Piece(CheckList[j], U, 4), 0, 2);
                      if substring = '||' then
                        begin
                          remOC := TStringList.Create;
                          substring := Copy(Piece(CheckList[j], U, 4), 3, Length(Piece(CheckList[j], U, 4)));
                          GetXtraTxt(remOC, Piece(substring, '&', 1), Piece(substring, '&', 2));
                          for k := 0 to remOC.Count - 1 do
                            begin
                              // add each line to x and OCRec.Checks
                              if k = remOC.Count - 1 then
                                begin
                                  OCRec.Checks.Add(Pieces(CheckList[j], U, 2, 3) + '^' + '      ' + remOC[k]);
                                  X := X + CRLF + remOC[k];
                                  if gridtext = '' then
                                    gridtext := remOC[k]
                                  else
                                    gridtext := gridtext + CRLF + '      ' + remOC[k];
                                end
                              else if k = 0 then
                                begin
                                  OCRec.Checks.Add(Pieces(CheckList[j], U, 2, 3) + '^' + remOC[k]);
                                  X := X + CRLF + '(' + inttostr(l) + ' of ' + inttostr(m) + ')  ' + remOC[k];
                                  if gridtext = '' then
                                    gridtext := '(' + inttostr(l) + ' of ' + inttostr(m) + ')  ' + remOC[k]
                                  else
                                    gridtext := gridtext + CRLF + remOC[k];
                                end
                              else
                                begin
                                  OCRec.Checks.Add(Pieces(CheckList[j], U, 2, 3) + '^' + '      ' + remOC[k]);
                                  X := X + CRLF + remOC[k];
                                  if gridtext = '' then
                                    gridtext := remOC[k]
                                  else
                                    gridtext := gridtext + CRLF + '      ' + remOC[k];
                                end;
                            end;
                          X := X + CRLF + '        ';
                          if gridtext = '' then
                            gridtext := '      '
                          else
                            gridtext := gridtext + CRLF + '      ';
                          remOC.Free;
                        end
                      else
                        begin
                          OCRec.Checks.Add(Pieces(CheckList[j], U, 2, 4));
                          X := X + CRLF + '(' + inttostr(l) + ' of ' + inttostr(m) + ')  ' + Piece(CheckList[j], U, 4);
                          gridtext := '(' + inttostr(l) + ' of ' + inttostr(m) + ')  ' + Piece(CheckList[j], U, 4);
                        end;
                      if (Piece(CheckList[j], U, 3) = '1') then
                        frmOCSession.grdchecks.Cells[1, rowcnt] := '*Order Check requires Reason for Override' + CRLF + gridtext
                      else
                        frmOCSession.grdchecks.Cells[1, rowcnt] := gridtext;
                      frmOCSession.grdchecks.Cells[2, rowcnt] := OCRec.OrderID + '^I^' + Piece(CheckList[j], U, 3);
                      // frmOCSession.grdchecks.Objects[2, rowcnt] := OCRec;
                      rowcnt := rowcnt + 1;
                      if rowcnt > frmOCSession.grdchecks.RowCount then
                        frmOCSession.grdchecks.RowCount := rowcnt;
                    end;
              end; { with...for i }
          frmOCSession.FOrderList := OrderList;
          frmOCSession.FCheckList := CheckList;
          frmOCSession.SetReqJustify;
          MessageBeep(MB_ICONASTERISK);
          if frmOCSession.Visible then
            frmOCSession.SetFocus;
          frmOCSession.ShowModal;
          Result := not frmOCSession.CancelSignProcess;
          if frmOCSession.CancelSignProcess then
            begin
              for n := 0 to OrderList.Count - 1 do
                UnlockOrder(Piece(OrderList[n], U, 1));
              OrderList.Clear;
              if Assigned(frmFrame) then
                frmFrame.SetActiveTab(CT_ORDERS);
            end
          else if frmOCSession.modalresult = mrRetry then
            Result := false;

          if ScreenReaderActive = True then
            begin
              frmOCSession.pnlInstr.TabStop := True;
              frmOCSession.memNote.TabStop := True;
              frmOCSession.memNote.TabOrder := 2;
            end
          else
            begin
              frmOCSession.pnlInstr.TabStop := false;
              frmOCSession.memNote.TabStop := false;
            end;
        finally
          with uCheckedOrders do
            for i := 0 to Count - 1 do
              TOCRec(Items[i]).Free;
          frmOCSession.Free;
        end; { try }
      end; { if CheckList }
  finally
    CheckList.Free;
  end;
end;

procedure TfrmOCSession.SetCheckState(grid: TStringGrid; ACol, ARow: Integer; State: boolean);
var
  temp: string;
begin
  temp := grid.Cells[2, ARow];
  if State = True then
    SetPiece(temp, U, 3, '1')
  else
    SetPiece(temp, U, 3, '0');
  grid.Cells[2, ARow] := temp;
  grid.Repaint;
end;

procedure TfrmOCSession.SetReqJustify;
var
  i, j: Integer;
  OCRec: TOCRec;
begin
  FCritical := false;
  with uCheckedOrders do
    for i := 0 to Count - 1 do
      begin
        OCRec := TOCRec(Items[i]);
        for j := 0 to OCRec.Checks.Count - 1 do
          if Piece(OCRec.Checks[j], U, 2) = '1' then
            FCritical := True;
      end;
  lblJustify.Visible := FCritical;
  txtJustify.Visible := FCritical;
  memNote.Visible := FCritical;
end;

function TfrmOCSession.CheckBoxRect(poRect: TRect): TRect;
const
  ciCheckBoxDim = 20;
begin
  with poRect do
    begin
      Result.Top := Top + FontHeightPixel(Font.Handle);
      Result.Left := Left - (ciCheckBoxDim div 2) + (Right - Left) div 2;
      Result.Right := Result.Left + ciCheckBoxDim;
      Result.Bottom := Result.Top + ciCheckBoxDim;
    end
end;

procedure TfrmOCSession.cmdCancelOrderClick(Sender: TObject);
var
  i, j, already: Integer;
  AnOrderID: string;
  DeleteOrderList: TStringList;
begin
  inherited;
  DeleteOrderList := TStringList.Create;
  for i := 0 to grdchecks.RowCount do
    if (Piece(grdchecks.Cells[2, i], U, 3) = '1') and (Piece(grdchecks.Cells[2, i], U, 2) = 'O') then
      begin
        AnOrderID := Piece(grdchecks.Cells[2, i], U, 1);
        already := DeleteOrderList.IndexOf(AnOrderID);
        if (already >= 0) or (DeleteCheckedOrder(AnOrderID)) then
          begin
            for j := FCheckList.Count - 1 downto 0 do
              if Piece(FCheckList[j], U, 1) = AnOrderID then
                FCheckList.Delete(j);
            DeleteOrderList.Add(AnOrderID);
            Changes.Remove(CH_ORD, AnOrderID);
            for j := FOrderList.Count - 1 downto 0 do
              if Piece(FOrderList[j], U, 1) = AnOrderID then
                FOrderList.Delete(j);
            for j := uCheckedOrders.Count - 1 downto 0 do
              if TOCRec(uCheckedOrders.Items[j]).OrderID = AnOrderID then

          end;
      end;
  if DeleteOrderList.Count = 0 then
    begin
      infoBox('No orders are marked to cancel. Check the Cancel box by the orders to cancel. ', 'Error', MB_OK);
    end;
end;

procedure TfrmOCSession.cmdContinueClick(Sender: TObject);
var
  i: Integer;
  Cancel: boolean;
begin
  inherited;
  Cancel := false;
  if FCritical and ((Length(txtJustify.Text) < 2) or not ContainsVisibleChar(txtJustify.Text)) then
    begin
      infoBox('A justification for overriding critical order checks is required.', 'Justification Required', MB_OK);
      Exit;
    end;

  if FCritical and (ContainsUpCarretChar(txtJustify.Text)) then
    begin
      infoBox('The justification may not contain the ^ character.', 'Justification Required', MB_OK);
      Exit;
    end;

  for i := 0 to grdchecks.RowCount do
    if (Piece(grdchecks.Cells[2, i], U, 3) = '1') and (Piece(grdchecks.Cells[2, i], U, 2) = 'O') then
      begin
        Cancel := True;
        Break;
      end;
  if Cancel = True then
    begin
      infoBox('One or more orders have been marked to cancel!' + CRLF + CRLF + 'To cancel these orders, click the "Cancel Checked Order(s)" button.' + CRLF + CRLF + 'To place these orders, uncheck the Cancel box beside the order you wish to keep and then click the "Accept Order(s)" button again.',
        'Error', MB_OK);
      Exit;
    end;

  StatusText('Saving Order Checks...');
  SaveOrderChecksForSession(txtJustify.Text, FCheckList);
  StatusText('');
  Close;
end;

procedure TfrmOCSession.cmdMonographClick(Sender: TObject);
var
  monoList: TStringList;
begin
  inherited;
  monoList := TStringList.Create;
  GetMonographList(monoList);
  ShowMonographs(monoList);
  monoList.Free;
end;

procedure TfrmOCSession.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  DeleteMonograph;
end;

procedure TfrmOCSession.FormCreate(Sender: TObject);
const
  GAP = 6;

  procedure FixButtons(btns: array of TButton);
  var
    i, x: integer;
    s: TSize;

  begin
    x := ClientWidth;
    for i := High(btns) downto Low(btns) do
    begin
      s := Self.Canvas.TextExtent(btns[i].Caption);
      btns[i].Width := trunc(s.cx * 1.2);
      btns[i].Height := trunc(s.cy * 1.8);
      if i > 0 then
      begin
        dec(x, btns[i].Width + GAP);
        btns[i].Left := x;
        btns[i].Top := pnlBottom.Height - btns[i].Height - GAP;
      end;
    end;
  end;

  function CombinedHeight(ctrls: array of TControl): integer;
  var
    i: integer;

  begin
    Result := GAP;
    for i := Low(ctrls) to High(ctrls) do
      inc(Result, ctrls[i].Height);
  end;

begin
  inherited;
  grdchecks.Cells[0, 0] := 'Cancel';
  grdchecks.Cells[1, 0] := 'Order/Order Check Text';
  Font.Size := MainFontSize;
  lblJustify.Font.Style := lblJustify.Font.Style + [fsBold];
  pnlInstr.Font.Style := pnlInstr.Font.Style + [fsBold];
  pnlInstr.Font.Size := pnlInstr.Font.Size + 1;
  txtJustify.Height := trunc(canvas.TextHeight('|Zgy') * 1.6);
  ClientWidth := lblJustify.canvas.TextWidth(pnlInstr.Caption) +
    lblJustify.Margins.Left + lblJustify.Margins.Right + 12 + Font.Size;
  FixButtons([cmdCancelOrder, cmdContinue, btnReturn, cmdMonograph]);
  memNote.Height := trunc(Self.Canvas.TextHeight(memNote.Text) * 2.5);
  pnlBottom.Height := CombinedHeight([cmdCancelOrder, memNote, lblJustify, txtJustify, cmdContinue]);
  Realign;
end;

procedure TfrmOCSession.FormShow(Sender: TObject);
begin
  FCancelSignProcess := false;
  pnlInstr.TabStop := ScreenReaderActive;
  if ScreenReaderActive = True then
    pnlInstr.SetFocus
  else
    grdchecks.SetFocus;
end;

procedure TfrmOCSession.grdchecksDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  Wrap: boolean;
  format, str, cdl, temp, colorText: string;
  IsBelowOrder, isSelected: boolean;
  chkRect, DrawRect, colorRect: TRect;
  ChkState: Cardinal;
begin
  inherited;
  temp := grdchecks.Cells[2, ARow];
  format := Piece(grdchecks.Cells[2, ARow], U, 2);
  cdl := Piece(grdchecks.Cells[2, ARow], U, 3);
  colorText := '*Order Check requires Reason for Override';
  grdchecks.canvas.Brush.Color := Get508CompliantColor(clWhite);
  grdchecks.canvas.Font.Color := Get508CompliantColor(clBlack);
  grdchecks.canvas.Font.Style := [];
  isSelected := false;

  if ARow = 0 then
    begin
      grdchecks.canvas.Brush.Color := Get508CompliantColor(clbtnFace);
      grdchecks.canvas.Font.Style := [fsBold];
    end;

  // change commented out code to handle different font color this code may not be needed anymore
  if (format = '') and (ARow > 0) then
    grdchecks.canvas.Font.Color := Get508CompliantColor(clBlue)
  else
    grdchecks.canvas.Font.Color := Get508CompliantColor(clBlack);
  if cdl = '1' then
    grdchecks.canvas.Font.Color := Get508CompliantColor(clBlue);

  // controls highlighting cell when focused in on the cell
  if State = [gdSelected .. gdFocused] then
    begin
      isSelected := True; // use to control colors for high order checks
      grdchecks.canvas.Font.Color := Get508CompliantColor(clWhite);
      grdchecks.canvas.Brush.Color := clHighlight;
      grdchecks.canvas.Font.Color := clHighlightText;
      grdchecks.canvas.Font.Style := [fsBold];
      grdchecks.canvas.MoveTo(Rect.Left, Rect.Top);
    end
    // if not an order than blanked out lines seperating the order check
  else if (format = 'I') then
    begin
      if (ARow < grdchecks.RowCount) and (Piece(grdchecks.Cells[2, ARow + 1], U, 2) = 'O') then
        IsBelowOrder := True
      else
        IsBelowOrder := false;
      grdchecks.canvas.MoveTo(Rect.Left, Rect.Bottom);
      grdchecks.canvas.Pen.Color := Get508CompliantColor(clWhite);
      grdchecks.canvas.LineTo(Rect.Left, Rect.Top);
      grdchecks.canvas.LineTo(Rect.Right, Rect.Top);
      grdchecks.canvas.LineTo(Rect.Right, Rect.Bottom);
      if (IsBelowOrder = false) or (ARow = (grdchecks.RowCount - 1)) then
        grdchecks.canvas.LineTo(Rect.Left, Rect.Bottom);
    end;
  str := grdchecks.Cells[ACol, ARow];
  // determine if the cell needs to wrap
  if ACol = 1 then
    Wrap := True
  else
    Wrap := false;
  // Blank out existing Cell to prevent overlap after resize
  grdchecks.canvas.FillRect(Rect);
  // get existing cell
  DrawRect := Rect;
  if (ACol = 0) and (format = 'O') and (ARow > 0) then
    begin
      if Piece(grdchecks.Cells[2, ARow], U, 4) = '' then
        begin
          DrawRect.Bottom := DrawRect.Bottom + FontHeightPixel(Font.Handle) + 5;
          SetPiece(temp, U, 4, 'R');
          grdchecks.Cells[2, ARow] := temp;
        end;
      if GetCheckState(grdchecks, ACol, ARow) = True then
        ChkState := DFCS_CHECKED
      else
        ChkState := DFCS_BUTTONCHECK;
      chkRect := CheckBoxRect(DrawRect);
      DrawFrameControl(grdchecks.canvas.Handle, chkRect, DFC_BUTTON, ChkState);
      DrawText(grdchecks.canvas.Handle, PChar('Cancel?'), Length('Cancel?'), DrawRect, DT_SINGLELINE or DT_Top or DT_Center);
      if ((DrawRect.Bottom - DrawRect.Top) > grdchecks.RowHeights[ARow]) or ((DrawRect.Bottom - DrawRect.Top) < grdchecks.RowHeights[ARow]) then
        begin
          grdchecks.RowHeights[ARow] := (DrawRect.Bottom - DrawRect.Top);
        end;
    end;
  // If order check than indent the order check text
  if (ACol = 1) and (format = 'I') then
    DrawRect.Left := DrawRect.Left + 10;
  // colorRect use to create Rect for Order Check Label
  colorRect := DrawRect;
  if Wrap then
    begin
      if (cdl = '1') and (format = 'I') then
        begin
          if isSelected = false then
            begin
              grdchecks.canvas.Font.Color := Get508CompliantColor(clRed);
              grdchecks.canvas.Font.Style := [fsBold];
            end;
          // determine rect size for order check label
          DrawText(grdchecks.canvas.Handle, PChar(colorText), Length(colorText), colorRect, dt_calcrect or dt_wordbreak);
          DrawRect.Top := colorRect.Bottom;
          // determine rect size for order check text
          DrawText(grdchecks.canvas.Handle, PChar(str), Length(str), DrawRect, dt_calcrect or dt_wordbreak);
          str := Copy(str, Length(colorText + CRLF) + 1, Length(str));
          if isSelected = false then
            begin
              grdchecks.canvas.Font.Color := Get508CompliantColor(clBlue);
              grdchecks.canvas.Font.Style := [];
            end;
        end
        // determine size for non-high order check text
      else
        DrawText(grdchecks.canvas.Handle, PChar(str), Length(str), DrawRect, dt_calcrect or dt_wordbreak);
      DrawRect.Bottom := DrawRect.Bottom + 2;
      // Resize the Cell height if the height does not match the Rect Height
      if ((DrawRect.Bottom - DrawRect.Top) > grdchecks.RowHeights[ARow]) then
        begin
          grdchecks.RowHeights[ARow] := (DrawRect.Bottom - DrawRect.Top);
        end
      else
        begin
          // if cell doesn't need to grow reset the cell
          DrawRect.Right := Rect.Right;
          if (cdl = '1') and (format = 'I') then
            begin
              // DrawRect.Top := ColorRect.Bottom;
              if isSelected = false then
                begin
                  grdchecks.canvas.Font.Color := Get508CompliantColor(clRed);
                  grdchecks.canvas.Font.Style := [fsBold];
                end;
              DrawText(grdchecks.canvas.Handle, PChar(colorText), Length(colorText), colorRect, dt_wordbreak);
              if isSelected = false then
                begin
                  grdchecks.canvas.Font.Color := Get508CompliantColor(clBlue);
                  grdchecks.canvas.Font.Style := [];
                end;
            end;
          DrawText(grdchecks.canvas.Handle, PChar(str), Length(str), DrawRect, dt_wordbreak);
          // reset height
          if format = 'I' then
            grdchecks.RowHeights[ARow] := (DrawRect.Bottom - DrawRect.Top);
        end;
    end
  else
    // if not wrap than grow just draw the cell
    DrawText(grdchecks.canvas.Handle, PChar(str), Length(str), DrawRect, dt_wordbreak);
end;

procedure TfrmOCSession.grdchecksEnter(Sender: TObject);
begin
  inherited;
  if ScreenReaderActive then
    begin
      grdchecks.Row := 1;
      grdchecks.Col := 0;
      GetScreenReader.Speak('Navigate through the grid to reviews the orders and the order checks');
      if GetCheckState(grdchecks, 0, 1) = True then
        GetScreenReader.Speak('Cancel checkbox is checked press spacebar to uncheck it')
      else
        GetScreenReader.Speak('Cancel checkbox Not Checked press spacebar to check it to cancel the ' + grdchecks.Cells[1, 1] + ' Order');
    end;
  grdchecks.Row := 1;
  grdchecks.Col := 0;
end;

procedure TfrmOCSession.grdchecksKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = VK_TAB then
    begin
      if ssCtrl in Shift then
        begin
          if txtJustify.Visible = True then
            ActiveControl := txtJustify
          else
            ActiveControl := cmdContinue;
          Key := 0;
          Exit;
        end;
    end;
  if grdchecks.Col = 0 then
    begin
      Case Key of
        VK_TAB:
          begin
            if (ssShift in Shift) and (grdchecks.Row > 1) then
              begin
                grdchecks.Col := 1;
                grdchecks.Row := grdchecks.Row - 1;
              end;
          end;
        VK_Space:
          begin
            if Piece(grdchecks.Cells[2, grdchecks.Row], U, 2) = 'O' then
              begin
                if GetCheckState(grdchecks, 2, grdchecks.Row) = True then
                  SetCheckState(grdchecks, 2, grdchecks.Row, false)
                else
                  SetCheckState(grdchecks, 2, grdchecks.Row, True);
                if ScreenReaderActive then
                  begin
                    if GetCheckState(grdchecks, 0, grdchecks.Row) = True then
                      GetScreenReader.Speak('Cancel checkbox checked')
                    else
                      GetScreenReader.Speak('Cancel checkbox unChecked');
                  end;
              end;
          end;
      end;
    end;
  if grdchecks.Col = 1 then
    begin
      // needed to add control for tab key to handle the blank cells that should not have focus.
      if Key = VK_TAB then
        begin
          if ssShift in Shift then
            begin
              if Piece(grdchecks.Cells[2, grdchecks.Row], U, 2) = 'O' then
                grdchecks.Col := 0
              else if grdchecks.Row > 1 then
                begin
                  grdchecks.Col := 1;
                  grdchecks.Row := grdchecks.Row - 1;
                end;
            end
          else
            begin
              if grdchecks.Row = (grdchecks.RowCount - 1) then
                begin
                  if ScreenReaderActive = True then
                    ActiveControl := memNote
                  else if txtJustify.Visible = True then
                    ActiveControl := txtJustify
                  else
                    ActiveControl := cmdContinue;
                  Key := 0;
                end
              else
                begin
                  grdchecks.Row := grdchecks.Row + 1;
                  if Piece(grdchecks.Cells[2, grdchecks.Row], U, 2) = 'O' then
                    grdchecks.Col := 0
                  else
                    grdchecks.Col := 2;
                end;
            end;
          Key := 0;
        end;
    end;
end;

procedure TfrmOCSession.grdchecksMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Row, Col: Integer;
begin
  grdchecks.MouseToCell(X, Y, Col, Row);
  if Col <> 0 then
    Exit;
  if Piece(grdchecks.Cells[2, Row], U, 2) <> 'O' then
    Exit;
  if InCheckBox(grdchecks, X, Y, Col, Row) = false then
    Exit;
  if GetCheckState(grdchecks, Col, Row) = True then
    SetCheckState(grdchecks, Col, Row, false)
  else
    SetCheckState(grdchecks, Col, Row, True);
end;

procedure TfrmOCSession.grdchecksMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  ACol, ARow: Integer;
begin
  grdchecks.MouseToCell(X, Y, ACol, ARow);
  // check to see if hint should show
  if ARow > grdchecks.RowCount then
    Exit;

  if ACol <> 1 then
    Exit;

  if grdchecks.RowHeights[ARow] < grdchecks.Height then
    Exit;

  grdchecks.Hint := grdchecks.Cells[ACol, ARow];
  Application.HintHidePause := 20000; // 20 Sec
  if grdchecks.Hint <> '' then
    grdchecks.ShowHint := True;
end;

procedure TfrmOCSession.grdchecksSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: boolean);
begin
  inherited;
  CanSelect := True;
  if ARow = 0 then
    CanSelect := false
  else if (ACol = 2) then
    CanSelect := false
  else if (ACol = 1) and (grdchecks.Cells[ACol, ARow] = '') then
    CanSelect := false;

  if (CanSelect = True) and (ACol = 0) and (Piece(grdchecks.Cells[2, ARow], U, 2) = 'O') and (ScreenReaderActive) then
    begin
      if GetCheckState(grdchecks, ACol, ARow) = True then
        GetScreenReader.Speak('Cancel checkbox is checked press spacebar to uncheck it')
      else
        GetScreenReader.Speak('Cancel checkbox Not Checked press spacebar to check it to cancel the ' + grdchecks.Cells[1, ARow] + ' Order');
    end;
end;

procedure TfrmOCSession.GridDeleteRow(RowNumber: Integer; grid: TStringGrid);
var
  i: Integer;
begin
  grid.Row := RowNumber;
  if (grid.Row = grid.RowCount - 1) then
    { On the last row }
    grid.RowCount := grid.RowCount - 1
  else
    begin
      { Not the last row }
      for i := RowNumber to grid.RowCount - 1 do
        grid.Rows[i] := grid.Rows[i + 1];
      grid.RowCount := grid.RowCount - 1;
    end;
end;

function TfrmOCSession.InCheckBox(grid: TStringGrid; X, Y, ACol, ARow: Integer): boolean;
var
  Rect: TRect;
begin
  Result := false;
  Rect := CheckBoxRect(grid.CellRect(ACol, ARow));
  if Y < Rect.Top then
    Exit;
  if Y > Rect.Bottom then
    Exit;
  if X < Rect.Left then
    Exit;
  if X > Rect.Right then
    Exit;
  Result := True;
end;

function TfrmOCSession.GetCheckState(grid: TStringGrid; ACol, ARow: Integer): boolean;
begin
  if Piece(grid.Cells[2, ARow], U, 3) = '1' then
    Result := True
  else
    Result := false;
end;

procedure TfrmOCSession.FormResize(Sender: TObject);
begin
  grdchecks.ColWidths[0] := round(grdchecks.Width * 0.08);
  grdchecks.ColWidths[1] := round(grdchecks.Width * 0.88); // Order Text
  grdchecks.ColWidths[2] := 0; // OrderID^Format^IsCheck
  grdchecks.tabStops[2] := false;
  if grdchecks.RowCount > 1 then
    grdchecks.Refresh;
end;

procedure TfrmOCSession.txtJustifyKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;
  // GE CQ9540  activate Return key, behave as "Continue" buttom clicked.
  if Key = VK_RETURN then
    cmdContinueClick(self);
end;

procedure TfrmOCSession.btnReturnClick(Sender: TObject);
begin
  FCancelSignProcess := True;
  Close;
end;

procedure TfrmOCSession.SetReturn(const Value: boolean);
begin
  FCancelSignProcess := Value;
end;

procedure TfrmOCSession.memNoteEnter(Sender: TObject);
begin
  memNote.SelStart := 0;
end;

procedure TfrmOCSession.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;
  if (Key = VK_F4) and (ssAlt in Shift) then
    Key := 0;
end;

end.
