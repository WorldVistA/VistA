unit fOCSession;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, fOCMonograph,
  fAutoSz, StdCtrls, ORFn, uConst, ORCtrls, ExtCtrls, VA508AccessibilityManager,
  Grids, strUtils, uDlgComponents, VAUtils, VA508AccessibilityRouter;

type
  TfrmOCSession = class(TfrmAutoSz)
    pnlBottom: TPanel;
    lblJustify: TLabel;
    txtJustify: TCaptionEdit;
    cmdCancelOrder: TButton;
    cmdContinue: TButton;
    btnReturn: TButton;
    memNote: TMemo;
    cmdMonograph: TButton;
    grdchecks: TCaptionStringGrid;
    lblInstr: TVA508StaticText;
    pnlTop: TORAutoPanel;
    lblHover: TLabel;
    procedure cmdCancelOrderClick(Sender: TObject);
    procedure cmdContinueClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure txtJustifyKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnReturnClick(Sender: TObject);
    procedure memNoteEnter(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cmdMonographClick(Sender: TObject);
    procedure grdchecksDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    function CheckBoxRect(poRect: TRect): TRect;
    function GetCheckState(grid: TStringGrid; ACol, ARow: integer): boolean;
    function InCheckBox(Grid: TStringGrid; X, Y, ACol, ARow: integer): boolean;
    procedure SetCheckState(grid: TStringGrid; ACol, ARow: integer; State: boolean);
    procedure grdchecksMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure grdchecksSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure GridDeleteRow(RowNumber: Integer; Grid: TstringGrid);
    procedure grdchecksEnter(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure grdchecksKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure grdchecksMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure grdchecksMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure grdchecksMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
   // procedure memNoteSetText(str: string);
  private
    FCritical: Boolean;
    FCancelSignProcess : Boolean;
    FCheckList: TStringList;
    FOrderList: TStringList;
    procedure SetReqJustify;
    procedure SetReturn(const Value: Boolean);
  public
    { Public declarations }
    property CancelSignProcess : Boolean read FCancelSignProcess write SetReturn default false;
  end;

procedure ExecuteReleaseOrderChecks(SelectList: TList);
function ExecuteSessionOrderChecks(OrderList: TStringList) : Boolean;

implementation

{$R *.DFM}

uses rOrders, uCore, rMisc, fFrame;

type
  TOCRec = class
    OrderID: string;
    OrderText: string;
    Checks: TStringList;
    constructor Create(const AnID: string);
    destructor Destroy; override;
  end;

var
  uCheckedOrders: TList;
  FOldHintHidePause: integer;

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
      OrderIDList.Add(AnOrder.ID + '^^1');  // 3rd pce = 1 means releasing order
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
    if OrderIDList.Count < 1 then SelectList.Clear;
  finally
    OrderIDList.Free;
  end;
end;

{Returns True if the Signature process should proceed.
 Clears OrderList If False. }
function ExecuteSessionOrderChecks(OrderList: TStringList) : Boolean;
var
  i, j, k, l, m, n, rowcnt: Integer;
  LastID, NewID, gridtext: string;
  CheckList,remOC: TStringList;
  OCRec: TOCRec;
  frmOCSession: TfrmOCSession;
  x,substring: string;
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
      //frmOCSession.grdchecks.RowCount := frmOCSession.grdchecks.RowCount + 1; *)
      //rowcnt := frmOCSession.grdchecks.RowCount;
      //if RowCnt > frmOCSession.grdchecks.RowCount then frmOCSession.grdchecks.RowCount := RowCnt;
      rowcnt := 1;
      frmOCSession.grdchecks.canvas.Font.Name := 'Courier New';
      frmOCSession.grdchecks.Canvas.Font.Size := MainFontSize;
      frmOCSession.cmdMonograph.Enabled := false;
      if IsMonograph then frmOCSession.cmdMonograph.Enabled := true;
      try
        ResizeFormToFont(TForm(frmOCSession));
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
          end; {if NewID}
        end; {for i}
        with uCheckedOrders do for i := 0 to Count - 1 do
        begin
          OCRec := TOCRec(Items[i]);
          x := TextForOrder(OCRec.OrderID);
          OCRec.OrderText := x;
          frmOCSession.grdchecks.Cells[2,rowcnt] := OCRec.OrderID + '^O^0^';
          frmOCSession.grdchecks.Cells[1,rowcnt] := OCRec.OrderText;
          RowCnt := RowCnt + 1;
          if RowCnt > frmOCSession.grdchecks.RowCount then frmOCSession.grdchecks.RowCount := RowCnt;
          l := 0;
          m := 0;
          for j := 0 to CheckList.Count - 1 do
            if Piece(CheckList[j], U, 1) = OCRec.OrderID then m := m+1;

          for j := 0 to CheckList.Count - 1 do
            if Piece(CheckList[j], U, 1) = OCRec.OrderID then
            begin
              l := l+1;
              gridText := '';
              substring := Copy(Piece(CheckList[j], U, 4),0,2);
              if substring='||' then
              begin
                remOC := TStringList.Create;
                substring := Copy(Piece(CheckList[j], U, 4),3,Length(Piece(CheckList[j], U, 4)));
                GetXtraTxt(remOC,Piece(substring,'&',1),Piece(substring,'&',2));
                for k := 0 to remOC.Count - 1 do
                begin
                  //add each line to x and OCRec.Checks
                  if k=remOC.Count-1 then
                  begin
                    OCRec.Checks.Add(Pieces(CheckList[j], U, 2, 3)+'^'+'      '+RemOC[k]);
                    x := x + CRLF + RemOC[k];
                    if gridText = '' then gridText := RemOC[k]
                    else gridText := gridText + CRLF + '      ' +RemOC[k];
                  end
                  else if k=0 then
                  begin
                    OCRec.Checks.Add(Pieces(CheckList[j], U, 2, 3)+'^'+RemOC[k]);
                    x := x + CRLF + '('+inttostr(l)+' of '+inttostr(m)+')  ' + RemOC[k];
                    if gridText = '' then gridText := '('+inttostr(l)+' of '+inttostr(m)+')  ' + RemOC[k]
                    else gridText := gridText + CRLF + RemOC[k];
                  end
                  else
                  begin
                    OCRec.Checks.Add(Pieces(CheckList[j], U, 2, 3)+'^'+'      '+RemOC[k]);
                    x := x + CRLF + RemOC[k];
                    if gridText = '' then gridText := RemOC[k]
                    else gridText := gridText + CRLF + '      ' + RemOC[k];
                  end;
                end;
                x := x + CRLF + '        ';
                    if gridText = '' then gridText := '      '
                    else gridText := gridText + CRLF + '      ';
                remOC.free;
              end
              else
              begin
                OCRec.Checks.Add(Pieces(CheckList[j], U, 2, 4));
                x := x + CRLF + '('+inttostr(l)+' of '+inttostr(m)+')  ' + Piece(CheckList[j], U, 4);
                gridText := '('+inttostr(l)+' of '+inttostr(m)+')  ' + Piece(CheckList[j], U, 4);
              end;
             if (Piece(CheckList[j], U, 3) = '1') then frmOCSession.grdchecks.Cells[1,rowcnt] := '*Order Check requires Reason for Override' + CRLF +  gridText
             else frmOCSession.grdchecks.Cells[1,rowcnt] := gridText;
              frmOCSession.grdchecks.Cells[2,rowcnt] := OCRec.OrderID + '^I^'+Piece(CheckList[j], U, 3);
              //frmOCSession.grdchecks.Objects[2, rowcnt] := OCRec;
              rowcnt := rowcnt +1;
              if RowCnt > frmOCSession.grdchecks.RowCount then frmOCSession.grdchecks.RowCount := RowCnt;
            end;
        end; {with...for i}
        frmOCSession.FOrderList := OrderList;
        frmOCSession.FCheckList := CheckList;
        frmOCSession.SetReqJustify;
        MessageBeep(MB_ICONASTERISK);
        if frmOCSession.Visible then frmOCSession.SetFocus;
        frmOCSession.ShowModal;
        Result := not frmOCSession.CancelSignProcess;
        if frmOCSession.CancelSignProcess then begin
          for n := 0 to OrderList.Count - 1 do
            UnlockOrder(Piece(OrderList[n], U, 1));
          OrderList.Clear;
          if Assigned(frmFrame) then
            frmFrame.SetActiveTab(CT_ORDERS);
        end
		    else
		    if frmOCSession.modalresult = mrRetry then Result := False;

        if ScreenReaderActive = True then
          begin
            frmOCSession.lblInstr.TabStop := true;
            frmOCSession.memNote.TabStop := true;
            frmOCSession.memNote.TabOrder := 2;
          end
        else
        begin
          frmOCSession.lblInstr.TabStop := false;
          frmOCSession.memNote.TabStop := false;
        end;
      finally
        with uCheckedOrders do for i := 0 to Count - 1 do TOCRec(Items[i]).Free;
        frmOCSession.Free;
      end; {try}
    end; {if CheckList}
  finally
    CheckList.Free;
  end;
end;


procedure TfrmOCSession.SetCheckState(grid: TStringGrid; ACol, ARow: integer;
  State: boolean);
var
  temp: string;
begin
  temp := grid.Cells[2, ARow];
  if State = True then SetPiece(temp, U, 3, '1')
  else SetPiece(temp, U, 3, '0');
  grid.Cells[2, ARow] := temp;
  grid.Repaint;
end;

procedure TfrmOCSession.SetReqJustify;
var
  i, j: Integer;
  OCRec: TOCRec;
begin
  FCritical := False;
  with uCheckedOrders do for i := 0 to Count - 1 do
  begin
    OCRec := TOCRec(Items[i]);
    for j := 0 to OCRec.Checks.Count - 1 do
      if Piece(OCRec.Checks[j], U, 2) = '1' then FCritical := True;
  end;
  lblJustify.Visible := FCritical;
  txtJustify.Visible := FCritical;
  memNote.Visible := FCritical;
end;

function TfrmOCSession.CheckBoxRect(poRect: TRect): TRect;
const ciCheckBoxDim = 20;
begin
  with poRect do begin
    Result.Top := Top + FontHeightPixel(Font.Handle);
    Result.Left   := Left - (ciCheckBoxDim div 2) + (Right - Left) div 2;
    Result.Right  := Result.Left + ciCheckBoxDim;
    Result.Bottom := Result.Top + ciCheckBoxDim;
  end
end;

procedure TfrmOCSession.cmdCancelOrderClick(Sender: TObject);
var
  i, j, already: Integer;
  AnOrderID: string;
  DeleteOrderList: TstringList;
begin
  inherited;
  DeleteOrderList := TStringList.Create;
  for I := 0 to grdChecks.RowCount do
    if (Piece(grdChecks.Cells[2, i], U, 3) = '1') and (Piece(grdChecks.Cells[2, i], U, 2) = 'O') then
      begin
        AnOrderID := Piece(grdChecks.Cells[2, i], U, 1);
        already := DeleteOrderList.IndexOf(AnOrderID);
        if (already>=0) or (DeleteCheckedOrder(AnOrderID)) then
          begin
             for j := FCheckList.Count - 1 downto 0 do
             if Piece(FCheckList[j], U, 1) = AnOrderID then FCheckList.Delete(j);
             DeleteOrderList.Add(AnOrderId);
             Changes.Remove(CH_ORD, AnOrderId);
             for j := FOrderList.Count - 1 downto 0 do
             if Piece(FOrderList[j], U, 1) = AnOrderID then FOrderList.Delete(j);
             for j := uCheckedOrders.Count - 1 downto 0 do
               if TOCRec(uCheckedOrders.Items[j]).OrderID = AnOrderId then

          end;
      end;
    if DeleteOrderList.Count = 0 then
      begin
        infoBox('No orders are marked to cancel. Check the Cancel box by the orders to cancel. ', 'Error', MB_OK);
      end;
end;

procedure TfrmOCSession.cmdContinueClick(Sender: TObject);
var
i: integer;
Cancel: boolean;
begin
  inherited;
  Cancel := False;
  if FCritical and ((Length(txtJustify.Text) < 2) or not ContainsVisibleChar(txtJustify.Text)) then
  begin
     InfoBox('A justification for overriding critical order checks is required.',
            'Justification Required', MB_OK);
    Exit;
  end;
    
  if FCritical and (ContainsUpCarretChar(txtJustify.Text)) then
  begin
     InfoBox('The justification may not contain the ^ character.',
            'Justification Required', MB_OK);
    Exit;
  end;

  for i := 0 to grdChecks.RowCount do
     if (Piece(grdChecks.Cells[2, i], U, 3) = '1') and (Piece(grdChecks.Cells[2, i], U, 2) = 'O') then
       begin
         Cancel := True;
         Break;
       end;
  if Cancel = True then
    begin
      InfoBox('One or more orders have been marked to cancel!' + CRLF + CRLF +
        'To cancel these orders, click the "Cancel Checked Order(s)" button.' + CRLF + CRLF +
        'To place these orders, uncheck the Cancel box beside the order you wish to keep and then click the "Accept Order(s)" button again.',
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


procedure TfrmOCSession.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  SaveUserBounds(Self); //Save Position & Size of Form
  DeleteMonograph;
end;

procedure TfrmOCSession.FormCreate(Sender: TObject);
begin
  inherited;
   grdChecks.Cells[0, 0] := 'Cancel';
   grdChecks.Cells[1, 0] := 'Order/Order Check Text';
   //cmdMonograph.Font.Size := MainFontSize;
   //cmdMonograph.Width :=  TextWidthByFont(cmdMonograph.Font.Handle, cmdMonograph.Caption);
end;

procedure TfrmOCSession.FormShow(Sender: TObject);

begin
  inherited;
  SetFormPosition(Self); //Get Saved Position & Size of Form
  FCancelSignProcess := False;
  if ScreenReaderActive = True then lblInstr.SetFocus
  else
    begin
      lblInstr.TabStop := false;
      grdChecks.SetFocus;
    end;
  self.lblInstr.Font.Size := mainFontSize + 1;
  //self.lblJustify.Height := self.lblJustify.Height + 20;
 (*if self.lblJustify.Visible = true then
     begin
       self.lblJustify.top := self.txtJustify.Top +  self.lblJustify.Height + 50;
     end; *)

  //if mainFontSize < 12 then inc := 90
  //else if mainFontSize < 18 then inc := 130
  //else inc := 155;
  //self.constraints.MinWidth := self.lblInstr.Left +  TextWidthByFont(self.lblInstr.Font.Handle, self.lblInstr.Caption) + inc;
end;

procedure TfrmOCSession.grdchecksDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
 Wrap: boolean;
 format, str, cdl, temp, colorText: string;
 IsBelowOrder, isSelected: boolean;
 chkRect, DrawRect, colorRect: TRect;
 ChkState: Cardinal;
begin
  inherited;
  temp := grdChecks.Cells[2, ARow];
  format := Piece(grdChecks.Cells[2, ARow], U, 2);
  cdl := Piece(grdChecks.Cells[2, ARow], U, 3);
  colorText := '*Order Check requires Reason for Override';
  grdChecks.Canvas.Brush.Color := Get508CompliantColor(clWhite);
  grdChecks.Canvas.Font.Color := Get508CompliantColor(clBlack);
  grdChecks.Canvas.Font.Style := [];
  isSelected := false;

  if ARow = 0 then
    begin
      grdChecks.Canvas.Brush.Color := Get508CompliantColor(clbtnFace);
      grdChecks.Canvas.Font.Style := [fsBold];
    end;

  //change commented out code to handle different font color this code may not be needed anymore
  if (format = '') and (ARow > 0) then
    grdchecks.Canvas.Font.Color := Get508CompliantColor(clBlue)
  else
    grdChecks.Canvas.Font.Color := Get508CompliantColor(clBlack);
  if cdl = '1' then grdChecks.Canvas.Font.Color := Get508CompliantColor(clBlue);

  //controls highlighting cell when focused in on the cell
  if State = [gdSelected..gdFocused] then
    begin
      isSelected := true;  //use to control colors for high order checks
      grdChecks.Canvas.Font.Color := Get508CompliantColor(clWhite);
      grdChecks.Canvas.Brush.Color := clHighlight;
      grdChecks.Canvas.Font.Color := clHighlightText;
      grdChecks.Canvas.Font.Style := [fsBold];
      grdChecks.Canvas.MoveTo(Rect.Left,Rect.top);
    end
  //if not an order than blanked out lines seperating the order check
  else if (format = 'I') then
    begin
      if (Arow < grdChecks.RowCount) and (Piece(grdChecks.Cells[2, Arow + 1], U, 2) = 'O') then IsBelowOrder := True
      else IsBelowOrder := False;
      grdChecks.Canvas.MoveTo(Rect.Left,Rect.Bottom);
      grdChecks.Canvas.Pen.Color := Get508CompliantColor(clwhite);
      grdChecks.Canvas.LineTo(Rect.Left, Rect.Top);
      grdChecks.Canvas.LineTo(Rect.Right, Rect.Top);
      grdChecks.Canvas.LineTo(Rect.Right, Rect.Bottom);
     if (isBelowOrder = False) or (ARow = (grdChecks.RowCount -1)) then grdChecks.Canvas.LineTo(Rect.left, Rect.Bottom);
    end;
  Str:= grdChecks.Cells[ACol, ARow];
  //determine if the cell needs to wrap
  if ACol = 1 then Wrap := true
  else wrap := false;
  //Blank out existing Cell to prevent overlap after resize
  grdChecks.Canvas.FillRect(Rect);
  //get existing cell
  DrawRect:= Rect;
  if (ACol = 0) and (format = 'O') and (ARow > 0) then
     begin
        if Piece(grdChecks.Cells[2, ARow], U, 4) = '' then
          begin
            DrawRect.Bottom := DrawRect.Bottom + FontHeightPixel(Font.Handle) + 5;
            setPiece(temp, U, 4, 'R');
            grdChecks.Cells[2, ARow] := temp;
          end;
        if GetCheckState(grdChecks, ACol, ARow) = True then chkState := DFCS_CHECKED
        else chkState := DFCS_BUTTONCHECK;
        chkRect := CheckBoxRect(DrawRect);
        DrawFrameControl(grdChecks.Canvas.Handle, chkRect, DFC_BUTTON, chkState);
        DrawText(grdChecks.Canvas.Handle, PChar('Cancel?'), length('Cancel?'), DrawRect, DT_SINGLELINE or DT_Top or DT_Center);
        if ((DrawRect.Bottom - DrawRect.Top) > grdChecks.RowHeights[ARow]) or
            ((DrawRect.Bottom - DrawRect.Top) < grdChecks.RowHeights[ARow]) then
            begin
              grdChecks.RowHeights[ARow]:= (DrawRect.Bottom - DrawRect.Top);
            end;
     end;
  //If order check than indent the order check text
  if (ACol = 1) and (format = 'I') then DrawRect.Left := DrawRect.Left + 10;
  //colorRect use to create Rect for Order Check Label
  colorRect := DrawRect;
  if Wrap then
     begin
      if (cdl = '1') and (format = 'I') then
       begin
          if isSelected = false then
            begin
              grdChecks.Canvas.Font.Color := Get508CompliantColor(clRed);
              grdChecks.Canvas.Font.Style := [fsBold];
            end;
          //determine rect size for order check label
          DrawText(grdChecks.Canvas.Handle, PChar(colorText), length(colorText), colorRect, dt_calcrect or dt_wordbreak);
          DrawRect.Top := ColorRect.Bottom;
          //determine rect size for order check text
          DrawText(grdChecks.Canvas.Handle, PChar(str), length(str), DrawRect, dt_calcrect or dt_wordbreak);
          str := copy(str, length(colorText + CRLF) + 1, length(str));
          if isSelected = false then
            begin
              grdChecks.Canvas.Font.Color := Get508CompliantColor(clblue);
              grdChecks.Canvas.Font.Style := [];
            end;
       end
       //determine size for non-high order check text
       else DrawText(grdChecks.Canvas.Handle, PChar(str), length(str), DrawRect, dt_calcrect or dt_wordbreak);
       DrawRect.Bottom := DrawRect.Bottom + 2;
       //Resize the Cell height if the height does not match the Rect Height
       if ((DrawRect.Bottom - DrawRect.Top) > grdChecks.RowHeights[ARow]) then
          begin
            grdChecks.RowHeights[ARow]:= (DrawRect.Bottom - DrawRect.Top);
          end
       else
          begin
            //if cell doesn't need to grow reset the cell
            DrawRect.Right:= Rect.Right;
            if (cdl = '1') and (format = 'I') then
              begin
                //DrawRect.Top := ColorRect.Bottom;
                if isSelected = false then
                  begin
                    grdChecks.Canvas.Font.Color := Get508CompliantColor(clRed);
                    grdChecks.Canvas.Font.Style := [fsBold];
                  end;
                DrawText(grdChecks.Canvas.Handle, PChar(colorText), length(colorText), colorRect, dt_wordbreak);
                if isSelected = false then
                  begin
                    grdChecks.Canvas.Font.Color := Get508CompliantColor(clBlue);
                    grdChecks.Canvas.Font.Style := [];
                  end;
              end;
            DrawText(grdChecks.Canvas.Handle, PChar(Str), length(Str), DrawRect, dt_wordbreak);
            //reset height
            if format = 'I' then grdChecks.RowHeights[ARow]:= (DrawRect.Bottom - DrawRect.Top);
          end;
      end
  else
    //if not wrap than grow just draw the cell
    DrawText(grdChecks.Canvas.Handle, PChar(Str), length(Str), DrawRect, dt_wordbreak);
end;

procedure TfrmOCSession.grdchecksEnter(Sender: TObject);
begin
  inherited;
  if ScreenReaderActive then
    begin
      grdChecks.Row := 1;
      grdChecks.Col := 0;
      GetScreenReader.Speak('Navigate through the grid to reviews the orders and the order checks');
      if GetCheckState(grdchecks, 0, 1) = true then
        GetScreenReader.Speak('Cancel checkbox is checked press spacebar to uncheck it')
      else GetScreenReader.Speak('Cancel checkbox Not Checked press spacebar to check it to cancel the ' + grdChecks.Cells[1,1] + ' Order');
    end;
  grdChecks.Row := 1;
  grdChecks.Col := 0;
end;

procedure TfrmOCSession.grdchecksKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
     if key = VK_TAB then
      begin
       if ssCtrl	in Shift then
         begin
            if txtJustify.Visible = TRUE then  ActiveControl := txtJustify
            else ActiveControl := cmdContinue;
            Key := 0;
            Exit;
         end;
      end;
      if grdchecks.Col = 0 then
       begin
         Case Key of
            VK_Tab:
              begin
                if (ssShift in Shift) and (grdChecks.Row > 1) then
                     begin
                       grdChecks.Col := 1;
                       grdChecks.Row := grdChecks.Row - 1;
                     end;
                end;
           VK_Space:
             begin
               if Piece(grdChecks.Cells[2, grdChecks.Row], U, 2) = 'O' then
                 begin
                   if GetCheckState(grdChecks, 2, grdChecks.Row) = True then
                       SetCheckState(grdChecks, 2, grdChecks.Row, False)
                      else SetCheckState(grdChecks, 2, grdChecks.Row, True);
                   if ScreenReaderActive then
                     begin
                       if GetCheckState(grdchecks, 0, grdChecks.Row) = true then
                          GetScreenReader.Speak('Cancel checkbox checked')
                        else GetScreenReader.Speak('Cancel checkbox unChecked');
                     end;
                 end;
             end;
       (*    VK_Down:
              begin
                 if (grdChecks.Row < grdChecks.RowCount) and (Piece(grdChecks.Cells[2, grdChecks.Row + 1], U, 2) <> 'O') then
                   begin
                      for I := grdChecks.Row + 1 to grdChecks.RowCount do
                        begin
                          if (Piece(grdChecks.Cells[2, i], U, 2) <> 'O') or (grdChecks.Cells[2, i] = '') then continue
                          else
                            begin
                              grdChecks.Row := i;
                              exit;
                            end;

                        end;
                   end;
              end;
           VK_Up:
             Begin
               if ((grdChecks.Row - 1) > 1) and (Piece(grdChecks.Cells[2, grdChecks.Row - 1], U, 2) <> 'O') then
                 begin
                   for i := grdChecks.Row - 1 downto 0 do
                     begin
                       if (Piece(grdChecks.Cells[2, i], U, 2) <> 'O') or (grdChecks.Cells[2, i] = '') then continue
                       else
                         begin
                           grdChecks.Row := i;
                           exit;
                         end;
                     end;
                 end;
             End; *)
         End;
       end;
    if grdChecks.Col = 1 then
       begin
       // needed to add control for tab key to handle the blank cells that should not have focus.
         if key = VK_Tab then
           begin
             if ssShift in Shift then
                begin
                  if Piece(grdChecks.Cells[2, grdChecks.Row], U, 2) = 'O' then grdChecks.Col := 0
                  else if grdChecks.Row > 1 then
                     begin
                       grdChecks.Col := 1;
                       grdChecks.Row := grdChecks.Row - 1;
                     end;
                 end
             else
               begin
                 if grdChecks.Row = (grdChecks.RowCount - 1) then
                   begin
                     if ScreenReaderActive = True then ActiveControl := memNote
                     else if txtJustify.Visible = TRUE then  ActiveControl := txtJustify
                     else ActiveControl := cmdContinue;
                     Key := 0;
                   end
                 else
                   begin
                     grdChecks.Row := grdChecks.Row + 1;
                     if Piece(grdChecks.Cells[2, grdChecks.Row], U, 2) = 'O' then grdChecks.Col := 0
                     else grdChecks.Col := 2;
                   end;
               end;
             Key := 0;
           end;
       end;
end;

procedure TfrmOCSession.grdchecksMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
 Row, Col: integer;
begin
  inherited;
     grdChecks.MouseToCell(X, Y, Col, Row);
     if Col <> 0 then exit;
     if Piece(grdChecks.Cells[2,row], U, 2) <> 'O' then exit;
     if InCheckBox(grdChecks, X, Y, Col, Row) = false then exit;
     if GetCheckState(grdChecks, Col, Row) = True then SetCheckState(grdChecks, Col, Row, False)
     else SetCheckState(grdChecks, Col, Row, True);
end;



procedure TfrmOCSession.grdchecksMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
acol , arow: integer;
//P : Tpoint;
//Rect: TRect;
begin
//Rect :=  grdChecks.CellRect(ACol, ARow);
//P.X := Rect.Left;
//P.Y := Rect.Top;

grdChecks.MouseToCell(X,y,acol , arow);
//check to see if hint should show
if ARow > grdChecks.RowCount then Exit;
if ACol <> 1 then exit;
if grdChecks.RowHeights[Arow] < grdChecks.Height then Exit;



grdChecks.Hint := grdChecks.Cells[ACol, ARow];
Application.HintHidePause := 20000; //20 Sec
if grdChecks.Hint <> '' then grdCHecks.ShowHint := true;

//Application.HintColor := clYellow;
//Application.ActivateHint(P);

end;

procedure TfrmOCSession.grdchecksMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  inherited;
(*  if grdChecks.Col = 0 then
    begin
      if (grdChecks.Row < grdChecks.RowCount) and (Piece(grdChecks.Cells[2, grdChecks.Row + 1], U, 2) <> 'O') then
        begin
          for I := grdChecks.Row + 1 to grdChecks.RowCount do
            begin
              if (Piece(grdChecks.Cells[2, i], U, 2) <> 'O') or (grdChecks.Cells[2, i] = '') then continue
              else
                begin
                  grdChecks.Row := i;
                  exit;
                end;
            end;
        end;
    end; *)
end;

procedure TfrmOCSession.grdchecksMouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  inherited;
 (* if grdChecks.Col = 0 then
    begin
      if ((grdChecks.Row - 1) > 1) and (Piece(grdChecks.Cells[2, grdChecks.Row - 1], U, 2) <> 'O') then
        begin
          for i := grdChecks.Row - 1 downto 0 do
            begin
              if (Piece(grdChecks.Cells[2, i], U, 2) <> 'O') or (grdChecks.Cells[2, i] = '') then continue
              else
                begin
                  grdChecks.Row := i;
                  exit;
                end;
            end;
        end;
    end;   *)
end;

procedure TfrmOCSession.grdchecksSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  inherited;
      CanSelect := True;
      if ARow = 0 then CanSelect := false
      else if (ACol = 2) then CanSelect := False
      else if (ACol = 1) and (grdChecks.Cells[Acol, Arow] = '') then CanSelect := False;
      //else if (ACol = 0) and (Piece(grdChecks.cells[2,ARow], U, 2) <> 'O') then CanSelect := false;
      if (CanSelect = True) and (ACol = 0) and (Piece(grdChecks.cells[2,ARow], U, 2) = 'O') and (ScreenReaderActive) then
        begin
           if GetCheckState(grdchecks, ACol, ARow) = true then
             GetScreenReader.Speak('Cancel checkbox is checked press spacebar to uncheck it')
           else GetScreenReader.Speak('Cancel checkbox Not Checked press spacebar to check it to cancel the ' + grdChecks.Cells[1,Arow] + ' Order');
        end;
end;

procedure TfrmOCSession.GridDeleteRow(RowNumber: Integer; Grid: TstringGrid);
var
  i: Integer;
begin
  Grid.Row := RowNumber;
  if (Grid.Row = Grid.RowCount - 1) then
    { On the last row}
    Grid.RowCount := Grid.RowCount - 1
  else
  begin
    { Not the last row}
    for i := RowNumber to Grid.RowCount - 1 do
      Grid.Rows[i] := Grid.Rows[i + 1];
    Grid.RowCount := Grid.RowCount - 1;
  end;
end;

function TfrmOCSession.InCheckBox(Grid: TStringGrid; X, Y, ACol,
  ARow: integer): boolean;
var
  Rect: TRect;
begin
  Result := False;
  Rect := CheckBoxRect(grid.CellRect(ACol, ARow));
  if Y < Rect.Top then Exit;
  if Y > Rect.Bottom then Exit;
  if X < Rect.Left then exit;
  if X > Rect.Right then exit;
  Result := True;
end;

function TfrmOCSession.GetCheckState(grid: TStringGrid; ACol, ARow: integer): boolean;
begin
   if Piece(grid.Cells[2, ARow], U, 3) = '1' then Result := True
   else Result := false;
end;

procedure TfrmOCSession.FormResize(Sender: TObject);
begin
  //TfrmAutoSz has defect must call inherited Resize for the resize to function.
  inherited;
    grdChecks.ColWidths[0] := round(grdChecks.Width * 0.08);
    grdChecks.ColWidths[1] := round(grdChecks.Width * 0.88);   //Order Text
    grdChecks.ColWidths[2] := 0;     //OrderID^Format^IsCheck
    grdChecks.tabStops[2] := false;
    if grdChecks.RowCount > 1 then grdChecks.Refresh;
    self.pnlBottom.Top := self.pnlTop.Top + self.pnlTop.Height;
end;

procedure TfrmOCSession.txtJustifyKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  //GE CQ9540  activate Return key, behave as "Continue" buttom clicked.
  if Key = VK_RETURN then cmdContinueClick(self);
end;

procedure TfrmOCSession.btnReturnClick(Sender: TObject);
begin
  inherited;
  FCancelSignProcess := True;
  Close;
end;

procedure TfrmOCSession.SetReturn(const Value: Boolean);
begin
  FCancelSignProcess := Value;
end;

procedure TfrmOCSession.memNoteEnter(Sender: TObject);
begin
  inherited;
  memNote.SelStart := 0;
end;


procedure TfrmOCSession.FormKeyDown(Sender: TObject; var Key: Word;
   Shift: TShiftState);
 begin
   inherited;
   if (Key = VK_F4) and (ssAlt in Shift) then Key := 0;
end;
procedure TfrmOCSession.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  inherited;
  if self.grdchecks.Focused = false then
    begin
    end;
end;

end.
