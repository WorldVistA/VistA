unit fOMNavA;

{$ASSERTIONS OFF}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, Grids, StdCtrls, ORCtrls, ExtCtrls, uConst, rOrders, uOrders, fFrame, fBase508Form,
  VA508AccessibilityManager;

type
  TfrmOMNavA = class(TfrmBase508Form)
    pnlTool: TPanel;
    cmdDone: TORAlignButton;
    grdMenu: TCaptionStringGrid;
    cmdPrev: TBitBtn;
    cmdNext: TBitBtn;
    accEventsGrdMenu: TVA508ComponentAccessibility;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure grdMenuDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure grdMenuKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure grdMenuMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure grdMenuMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure grdMenuMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlToolMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlToolMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure pnlToolMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cmdDoneClick(Sender: TObject);
    procedure cmdPrevClick(Sender: TObject);
    procedure cmdNextClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure grdMenuKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure accEventsGrdMenuCaptionQuery(Sender: TObject;
      var Text: string);
    procedure accEventsGrdMenuValueQuery(Sender: TObject;
      var Text: string);
  private
    FMainFormID: string;
    FOrderingMenu: Integer;
    FLastCol: Integer;
    FLastRow: Integer;
    FMouseDown: Boolean;
    FCtrlUp: Boolean;
    FSelecting: Boolean;
    FOrderMenuItem: TOrderMenuItem;
    FMenuHits: TList; {of TOrderMenu}
    FStack: TList; {of TMenuPath}
    FQuickBitmap: TBitmap;
    FOrigPoint: TPoint;
    FStartPoint: TPoint;
    FFormMove: Boolean;
    FKeyVars: string;
    FDelayEvent: TOrderDelayEvent;
    FMenuStyle: Integer;
    FRefNum: Integer;
    FSelectList: TList; {of TOrderMenuItem}
    FTheShift: TShiftState;
    procedure ActivateDialog(AnItem: TOrderMenuItem);
    procedure AddToSelectList(AnItem: TOrderMenuItem);
    procedure ClearMenuGrid;
    function DialogNotDisabled(DlgIEN: Integer): Boolean;
    procedure DoSelectList;
    function FindOrderMenu(AMenu: Integer): TOrderMenu;
    procedure PlaceMenuItems;
    procedure SetNavButtons;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure UMDestroy(var Message: TMessage);    message UM_DESTROY;
  public
    procedure CreateParams(var Params: TCreateParams); override;
    procedure SetEventDelay(AnEvent: TOrderDelayEvent);
    procedure SetNewMenu(MenuIEN: Integer; AnOwner: TComponent; ARefNum: Integer);
    procedure ResizeFont;
    property RefNum: Integer read FRefNum write FRefNum;
    property MainFormID: string read FMainFormID write FMainFormID;
  end;

var
  frmOMNavA: TfrmOMNavA;
  AlreadyRunning: Boolean = false;

implementation

{$R *.DFM}

uses rODBase, ORFn, fODBase,fODGen, fODAuto, fOMVerify, uCore, rMisc, uODBase,
  fOrders, VAUtils, System.UITypes, System.Types, fOMSet, rCore;

const
  TX_NOFORM    = 'This selection does not have an associated windows form.';
  TC_NOFORM    = 'Missing Form ID';
  TX_ODACTIVE  = 'An ordering dialog is already active.';
  TC_ODACTIVE  = 'Unable to Select Item';
  TX_QO_NOSAVE = 'Unexpected error - it was not possible to save this order.';
  TC_QO_NOSAVE = 'Unable to Save Quick Order';
  TC_DISABLED  = 'Item Disabled';

type
  TMenuPath = class
  public
    IENList: array of Integer;
    OwnedBy: TComponent;
    RefNum:  Integer;
    Current: Integer;
    destructor Destroy; override;
  end;

procedure TfrmOMNavA.ClearMenuGrid;
var
  ACol, ARow: Integer;
begin
  with grdMenu do
  begin
    for ACol := 0 to ColCount - 1 do for ARow := 0 to RowCount - 1 do
    begin
      Objects[ACol, ARow] := nil;
      Cells[ACol, ARow] := '';
    end;
    RowCount := 1;
    ColCount := 1;
    Cells[0, 0] := '';
  end;
end;

function TfrmOMNavA.FindOrderMenu(AMenu: Integer): TOrderMenu;
{ searchs the menu cache (FMenuHits) for a menu.  If not there, load the menu from the server. }
var
  i: Integer;
  AnOrderMenu: TOrderMenu;
begin
  i := 0;
  Result := nil;
  while (i < FMenuHits.Count) and (Result = nil) do          // search the menu cache
  begin
    AnOrderMenu := TOrderMenu(FMenuHits.Items[i]);
    if AnOrderMenu.IEN = AMenu then Result := AnOrderMenu;
    Inc(i);
  end;
  if Result = nil then                                       // load new menu from server
  begin
    AnOrderMenu := TOrderMenu.Create;
    AnOrderMenu.IEN := AMenu;
    AnOrderMenu.MenuItems := TList.Create;
    LoadOrderMenu(AnOrderMenu, AMenu);
    FMenuHits.Add(AnOrderMenu);
    Result := AnOrderMenu;
  end;
end;

procedure TfrmOMNavA.PlaceMenuItems;
{ places the menu items in the proper grid cells }
var
  i: Integer;
  OrderMenu: TOrderMenu;
  OrderMenuItem: TOrderMenuItem;
begin
  ClearMenuGrid;
  OrderMenu := FindOrderMenu(FOrderingMenu);
  if OrderMenu = nil then Exit;
  pnlTool.Caption  := OrderMenu.Title;
  grdMenu.ColCount := OrderMenu.NumCols;
  FKeyVars         := OrderMenu.KeyVars;
  grdMenu.DefaultColWidth := (grdMenu.ClientWidth div grdMenu.ColCount) - 1;
  with OrderMenu.MenuItems do for i := 0 to Count - 1 do
  begin
    OrderMenuItem := TOrderMenuItem(Items[i]);
    with grdMenu do
    begin
      if OrderMenuItem.Row >= RowCount then RowCount := OrderMenuItem.Row + 1;
      if (OrderMenuItem.Col > -1) and (OrderMenuItem.Row > -1) then
      begin
        Cells[OrderMenuItem.Col, OrderMenuItem.Row] := OrderMenuItem.ItemText;
        Objects[OrderMenuItem.Col, OrderMenuItem.Row] := OrderMenuItem;
      end; {if OrderMenuItem}
    end; {with grdMenu}
  end; {for i}
  with grdMenu do if VisibleRowCount < RowCount then
    ColWidths[ColCount - 1] := DefaultColWidth - GetSystemMetrics(SM_CXVSCROLL);
end;

procedure TfrmOMNavA.SetNewMenu(MenuIEN: Integer; AnOwner: TComponent; ARefNum: Integer);
{ Creates a new 'starting' menu.  For initial menu or menu from inside order set. }
var
  NewMenuPath: TMenuPath;
  I: Integer;
begin
  //SMT if we are adding from an OrderMenu in an Orderset, we just update
  //    the RefNum (position in Orderset) because we insert above the menu
  //    so that we will return to the menu.
  for I := 0 to FStack.Count - 1 do
  if TMenuPath(Fstack.Items[I]).IENList[0] = MenuIEN then
  begin
    TMenuPath(FStack.Items[I]).RefNum := ARefNum;
    Exit;
  end;

  NewMenuPath := TMenuPath.Create;
  SetLength(NewMenuPath.IENList, 1);
  NewMenuPath.IENList[0] := MenuIEN;
  NewMenuPath.OwnedBy := AnOwner;
  NewMenuPath.RefNum  := ARefNum;
  NewMenuPath.Current := 0;
  FStack.Add(NewMenuPath);
  FOrderingMenu := MenuIEN;  // sets new starting point here
  SetNavButtons;
  PlaceMenuItems;            // displays menu, with nav & done buttons set
  PushKeyVars(FKeyVars);
  Self.Enabled := True;
end;

{ menu navigation }

procedure TfrmOMNavA.SetNavButtons;
var
  MenuPath: TMenuPath;
begin
  with FStack do MenuPath := TMenuPath(Items[Count - 1]);
  cmdPrev.Enabled := MenuPath.Current > 0;
  cmdNext.Enabled := MenuPath.Current < High(MenuPath.IENList);
  if FStack.Count > 1 then cmdDone.Caption := 'Next' else cmdDone.Caption := 'Done';
  pnlTool.Invalidate;
end;

procedure TfrmOMNavA.cmdPrevClick(Sender: TObject);
var
  MenuPath: TMenuPath;
begin
  with FStack do MenuPath := TMenuPath(Items[Count - 1]);
  Dec(MenuPath.Current);
  FOrderingMenu := MenuPath.IENList[MenuPath.Current];
  SetNavButtons;
  PlaceMenuItems;
  PopKeyVars;
end;

procedure TfrmOMNavA.cmdNextClick(Sender: TObject);
var
  MenuPath: TMenuPath;
begin
  with FStack do MenuPath := TMenuPath(Items[Count - 1]);
  Inc(MenuPath.Current);
  FOrderingMenu := MenuPath.IENList[MenuPath.Current];
  SetNavButtons;
  PlaceMenuItems;
  PushKeyVars(FKeyVars);
end;

procedure TfrmOMNavA.cmdDoneClick(Sender: TObject);
var
  MenuPath: TMenuPath;
  OMset :TComponent;
begin
  if FSelecting then Exit;
  //SMT If we are in the middle of an orderset, check if we want to bail out before closing.
  OMSet := FindComponent('frmOMSet');
  if FStack.Count = 1 then
    if (OMSet <> nil) and not TfrmOMSet(OMSet).CloseQuery then Exit;

  //BLJ 353683: Per conversation with Chris Bell, we need to check bounds before we
  //  do any of the garbage below.
  if FStack.Count < 1 then
    exit;
  MenuPath := TMenuPath(FStack.Items[FStack.Count - 1]);
  FStack.Delete(FStack.Count - 1);
  if FStack.Count = 0 then Close;
  with MenuPath do if (OwnedBy <> nil) and (OwnedBy is TWinControl)
    then SendMessage(TWinControl(OwnedBy).Handle, UM_DESTROY, RefNum, 0);
  PopKeyVars(MenuPath.Current + 1);
  MenuPath.Free;
  if FStack.Count > 0 then
  begin
    with FStack do MenuPath := TMenuPath(Items[Count - 1]);
    FOrderingMenu := MenuPath.IENList[MenuPath.Current];
    SetNavButtons;
    PlaceMenuItems;
  end;
end;

{ Form methods }

procedure TfrmOMNavA.FormCreate(Sender: TObject);
begin
  FLastCol := -1;
  FLastRow := -1;
  FMenuStyle := OrderMenuStyle;
  FMenuHits := TList.Create;
  FStack := TList.Create;
  FSelectList := TList.Create;
  FQuickBitmap := TBitmap.Create;
  FQuickBitmap.LoadFromResourceName(hInstance, 'BMP_QO_THIN');
  NoFresh := True;
  ResizeFont;
//  TAccessibleStringGrid.WrapControl(grdMenu);
end;

procedure TfrmOMNavA.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do Style := (Style or WS_POPUP) and (not WS_DLGFRAME);
  //with Params do Style := WS_THICKFRAME or WS_POPUP or WS_BORDER;
end;

procedure TfrmOMNavA.UMDestroy(var Message: TMessage);
{ sent by ordering dialog when it is closing }
begin
  Self.Enabled := True;
  Self.SetFocus;
end;

procedure TfrmOMNavA.accEventsGrdMenuCaptionQuery(Sender: TObject;
  var Text: string);
begin
  Text := pnlTool.Caption;
end;

procedure TfrmOMNavA.FormDestroy(Sender: TObject);
var
  i, j: Integer;
  OrderMenu: TOrderMenu;
  OrderMenuItem: TOrderMenuItem;
begin
//  TAccessibleStringGrid.UnwrapControl(grdMenu);
  ClearMenuGrid;
  for i := 0 to FMenuHits.Count - 1 do
  begin
    OrderMenu := TOrderMenu(FMenuHits.Items[i]);
    for j := 0 to OrderMenu.MenuItems.Count - 1 do
    begin
      OrderMenuItem := TOrderMenuItem(OrderMenu.MenuItems.Items[j]);
      OrderMenuItem.Free;
    end;
    OrderMenu.MenuItems.Clear;
    OrderMenu.MenuItems.Free;
    OrderMenu.Free;
  end;
  FMenuHits.Free;
  Assert(FStack.Count = 0);
  FStack.Free;
  Assert(FSelectList.Count = 0);
  FSelectList.Free;
  FQuickBitmap.Free;
  DestroyingOrderMenu;
  if assigned(frmOrders) and (frmOrders.TheCurrentView<>nil)
    and (frmOrders.TheCurrentView.EventDelay.PtEventIFN>0)
    and (IsCompletedPtEvt(frmOrders.TheCurrentView.EventDelay.PtEventIFN)) then
    SendMessage(frmOrders.handle,UM_EVENTOCCUR,0,0);
end;

procedure TfrmOMNavA.FormActivate(Sender: TObject);
begin
  // do we need to bring something to front here?
end;

procedure TfrmOMNavA.FormClose(Sender: TObject; var Action: TCloseAction);
var
  MenuPath: TMenuPath;
begin
  while FStack.Count > 0 do
  begin
    with FStack do MenuPath := TMenuPath(Items[Count - 1]);
    with MenuPath do if (OwnedBy <> nil) and (OwnedBy is TWinControl)
      then SendMessage(TWinControl(OwnedBy).Handle, UM_DESTROY, RefNum, 0);
    PopKeyVars(MenuPath.Current + 1);
    MenuPath.Free;
    with FStack do Delete(Count - 1);
  end;
  SaveUserBounds(Self, MainFormID);
  NoFresh := False;
  Action := caFree;
end;

procedure TfrmOMNavA.SetEventDelay(AnEvent: TOrderDelayEvent);
begin
  FDelayEvent := AnEvent;
end;

procedure TfrmOMNavA.grdMenuDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
  State: TGridDrawState);
{ Draws each cell in the grid based on characteristics in associated OrderMenuItem object. }
const
  QO_BMP_WIDTH = 15;
var
  OrderMenuItem: TOrderMenuItem;
  AMnemonic: string;
  MneRect, ItmRect: TRect;
  MneWidth: integer;
begin
  //if Sender = ActiveControl then Exit;
  //if not (gdSelected in State) then Exit;
  with Sender as TStringGrid do with Canvas do
  begin
    MneWidth := TextWidthByFont(Handle, 'MMM');
    OrderMenuItem := TOrderMenuItem(grdMenu.Objects[ACol, ARow]);
    if (OrderMenuItem <> nil) then with OrderMenuItem do
    begin
      Font.Style := [];
      Font.Color := clWindowText;
      if Selected    then
      begin
        Font.Color := Get508CompliantColor(clBlue);
        Font.Style := Font.Style + [fsUnderline];
      end;
      if Display = 2 then
        Font.Style := Font.Style + [fsBold];
    end;
    Brush.Color := Color;
    if (FMenuStyle = 0) and
      ((OrderMenuItem = nil) or ((OrderMenuItem <> nil) and (OrderMenuItem.Display <> 2))) then
    begin
      if OrderMenuItem <> nil then AMnemonic := OrderMenuItem.Mnemonic else AMnemonic := '';
      FillRect(Rect);
      MneRect.Left := Rect.Left + QO_BMP_WIDTH;
      MneRect.Right := MneRect.Left + MneWidth;
      MneRect.Top := Rect.Top + 2;
      MneRect.Bottom := Rect.Bottom;
      ItmRect.Left := Rect.Left + QO_BMP_WIDTH + MneWidth + 1;
      ItmRect.Right := Rect.Right;
      ItmRect.Top := Rect.Top + 2;
      ItmRect.Bottom := Rect.Bottom;
      TextRect(MneRect, MneRect.Left, MneRect.Top, AMnemonic);
      TextRect(ItmRect, ItmRect.Left, ItmRect.Top, Cells[ACol, ARow]);
    end
    else TextRect(Rect, Rect.Left + QO_BMP_WIDTH, Rect.Top + 2, Cells[ACol, ARow]);
    if (OrderMenuItem <> nil) and OrderMenuItem.AutoAck
      then Draw(Rect.Left + 2, Rect.Top + 2, FQuickBitmap);	{ draw bitmap }
    if gdSelected in State then
    begin
      Pen.Width := 1;
      if FMouseDown then Pen.Color := clBtnShadow    else Pen.Color := clBtnHighlight;
      MoveTo(Rect.Left,  Rect.Bottom - 1);
      LineTo(Rect.Left,  Rect.Top);
      LineTo(Rect.Right, Rect.Top);
      if FMouseDown then Pen.Color := clBtnHighlight else Pen.Color := clBtnShadow;
      LineTo(Rect.Right, Rect.Bottom);
      LineTo(Rect.Left,  Rect.Bottom);
    end;
  end;
end;

{ Mouse & Keyboard Handling }

procedure TfrmOMNavA.AddToSelectList(AnItem: TOrderMenuItem);
begin
  if AnItem = nil then Exit;
  FSelectList.Add(AnItem);
  FSelecting := True;
  cmdDone.Enabled := False;
end;

procedure TfrmOMNavA.DoSelectList;
var
  i: Integer;
  x: string;
  ItemList: TStringList;
  AMenuItem: TOrderMenuItem;
begin
  FSelecting := False;
  cmdDone.Enabled := True;
  if FSelectList.Count = 0 then Exit;
  ItemList := TStringList.Create;
  try
    for i := 0 to FSelectList.Count - 1 do
    begin
      AMenuItem := TOrderMenuItem(FSelectList[i]);
      if AMenuItem <> nil then
      begin
        x := IntToStr(AMenuItem.IEN) + U + AMenuItem.DlgType + U + AMenuItem.ItemText;
        ItemList.Add(x);
      end;
    end;
    if ItemList.Count > 0 then ActivateOrderList(ItemList, FDelayEvent, Self, 0, '', '');
  finally
    FSelectList.Clear;
    ItemList.Free;
  end;
end;

procedure TfrmOMNavA.grdMenuKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  ALocation: Integer;
  AName, ASvc: string;
begin
  //frmFrame.UpdatePtInfoOnRefresh;
  if Key in [VK_RETURN, VK_SPACE] then with grdMenu do
  begin
    If AlreadyRunning then Exit;
    AlreadyRunning := true;
    try
      if frmOrders <> nil then
      begin
        if (frmOrders.TheCurrentView<>nil) and (frmOrders.TheCurrentView.EventDelay.PtEventIFN>0)
          and IsCompletedPtEvt(frmOrders.TheCurrentView.EventDelay.PtEventIFN) then
        begin
          FDelayEvent.EventType := 'C';
          FDelayEvent.EventIFN  := 0;
          FDelayEvent.TheParent := TParentEvent.Create(0);
          FDelayEvent.EventName := 'All Services, Active';
          FDelayEvent.PtEventIFN := 0;
          // set location
          CurrentLocationForPatient(Patient.DFN, ALocation, AName, ASvc);
          if ALocation <> 0 then
            Encounter.Location := ALocation;
        end;
      end;
      //frmFrame.UpdatePtInfoOnRefresh;
      FOrderMenuItem := TOrderMenuItem(Objects[Col, Row]);
      if Assigned(FOrderMenuItem) then
        if FOrderMenuItem.Display > 0 then FOrderMenuItem := nil;          // display only
      if FOrderMenuItem <> nil then
      begin
        FOrderMenuItem.Selected := True;
        if ssCtrl in Shift
          then AddToSelectList(FOrderMenuItem)
          else ActivateDialog(FOrderMenuItem);
        FOrderMenuItem := nil;
        Key := 0;
      end;
      if frmOrders <> nil then
      begin
        if (frmOrders.TheCurrentView<>nil) and (frmOrders.TheCurrentView.EventDelay.PtEventIFN>0)
          and IsCompletedPtEvt(frmOrders.TheCurrentView.EventDelay.PtEventIFN) then
        begin
          FDelayEvent.EventType := 'C';
          FDelayEvent.EventIFN  := 0;
          FDelayEvent.TheParent := TParentEvent.Create(0);
          FDelayEvent.EventName := 'All Services, Active';
          FDelayEvent.PtEventIFN := 0;
          // set location
          CurrentLocationForPatient(Patient.DFN, ALocation, AName, ASvc);
          if ALocation <> 0 then
            Encounter.Location := ALocation;
        end;
      end;
    finally
      AlreadyRunning := false;
    end;
  end;
  if Key = VK_BACK then
  begin
    cmdPrevClick(Self);
    Key := 0;
  end;
  if Key = VK_ESCAPE then
  begin
    cmdDoneClick(Self);
    Key := 0;
  end;
end;

procedure TfrmOMNavA.grdMenuKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_CONTROL then
  begin
    if FMouseDown then FCtrlUp := True else DoSelectList;
  end;
end;

procedure TfrmOMNavA.grdMenuMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ACol, ARow: Integer;
  ALocation: Integer;
  AName, ASvc: string;
begin
  //frmFrame.UpdatePtInfoOnRefresh;
  if ssDouble in Shift then
  begin
    FTheShift := [ssDouble];
    Exit;  // ignore a double click
  end;
  If AlreadyRunning then Exit;
  AlreadyRunning := true;
  try
    if frmOrders <> nil then
    begin
      if (frmOrders.TheCurrentView<>nil) and (frmOrders.TheCurrentView.EventDelay.PtEventIFN>0)
        and IsCompletedPtEvt(frmOrders.TheCurrentView.EventDelay.PtEventIFN) then
      begin
        FDelayEvent.EventType := 'C';
        FDelayEvent.EventIFN  := 0;
        FDelayEvent.TheParent := TParentEvent.Create(0);
        FDelayEvent.EventName := 'All Services, Active';
        FDelayEvent.PtEventIFN := 0;
        // set location
        CurrentLocationForPatient(Patient.DFN, ALocation, AName, ASvc);
        if ALocation <> 0 then
          Encounter.Location := ALocation;
      end;
    end;
    //frmFrame.UpdatePtInfoOnRefresh;
    with grdMenu do
    begin
      MouseToCell(X, Y, ACol, ARow);
      if (ACol > -1) and (ARow > -1) and (ACol < grdMenu.ColCount) and (ARow < grdMenu.RowCount) then
      begin
        FMouseDown := True;
        FOrderMenuItem := TOrderMenuItem(Objects[ACol, ARow]);
        // check to see if this is a display only field
        if (FOrderMenuItem <> nil) and (FOrderMenuItem.Display > 0) then FOrderMenuItem := nil;
        if  FOrderMenuItem <> nil then FOrderMenuItem.Selected := True;
      end;
    end;
  finally
    AlreadyRunning := false;
  end;
end;

procedure TfrmOMNavA.grdMenuMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  ACol, ARow: Integer;
begin
  grdMenu.MouseToCell(X, Y, ACol, ARow);
  if (ACol = FLastCol) and (ARow = FLastRow) then Exit;
  if (ACol > -1) and (ARow > -1) and (ACol < grdMenu.ColCount) and (ARow < grdMenu.RowCount) then
  begin
    FLastCol := ACol;
    FLastRow := ARow;
    grdMenu.Col := ACol;
    grdMenu.Row := ARow;
  end;
end;

procedure TfrmOMNavA.grdMenuMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  ALocation: Integer;
  AName, ASvc: string;
begin
  if ssDouble in Shift then Exit;  // ignore a double click
  if ssDouble in FTheShift then
  begin
    FTheShift := [];
    Exit;
  end;

  If AlreadyRunning then Exit;
  AlreadyRunning := true;
  try
    FMouseDown := False;
    //grdMenu.Invalidate;
    // may want to check here to see if mouse still over the same item
    if ssCtrl in Shift then AddToSelectList(FOrderMenuItem) else
    begin
      if FCtrlUp then
      begin
        FCtrlUp := False;
        AddToSelectList(FOrderMenuItem);
        DoSelectList;
      end
      else ActivateDialog(FOrderMenuItem);
    end;
    FCtrlUp := False;
    FOrderMenuItem := nil;
    if frmOrders <> nil then
    begin
      if (frmOrders.TheCurrentView<>nil) and (frmOrders.TheCurrentView.EventDelay.PtEventIFN>0)
        and IsCompletedPtEvt(frmOrders.TheCurrentView.EventDelay.PtEventIFN) then
      begin
        FDelayEvent.EventType := 'C';
        FDelayEvent.EventIFN  := 0;
        FDelayEvent.TheParent := TParentEvent.Create(0);
        FDelayEvent.EventName := 'All Services, Active';
        FDelayEvent.PtEventIFN := 0;
        // set location
        CurrentLocationForPatient(Patient.DFN, ALocation, AName, ASvc);
        if ALocation <> 0 then
          Encounter.Location := ALocation;
      end;
    end;
  finally
    AlreadyRunning := False;
  end;
end;

procedure TfrmOMNavA.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  FLastCol := -1;
  FLastRow := -1;
end;

function TfrmOMNavA.DialogNotDisabled(DlgIEN: Integer): Boolean;
var
  x: string;
begin
  Result := True;
  x := OrderDisabledMessage(DlgIEN);
  if Length(x) > 0 then
  begin
    Result := False;
    InfoBox(x, TC_DISABLED, MB_OK);
  end;
end;

procedure TfrmOMNavA.accEventsGrdMenuValueQuery(Sender: TObject;
  var Text: string);
var
  OrderMenuItem : TOrderMenuItem;
begin
  inherited;
  if grdMenu.Objects[grdMenu.Col, grdMenu.Row] is TOrderMenuItem then begin
    OrderMenuItem := TOrderMenuItem(grdMenu.Objects[grdMenu.Col, grdMenu.Row]);
    Text := OrderMenuItem.Mnemonic + ', ' + OrderMenuItem.ItemText;
    if OrderMenuItem.AutoAck then
      Text := 'Auto Accept, '+ Text;
  end;
end;

procedure TfrmOMNavA.ActivateDialog(AnItem: TOrderMenuItem);
var
  MenuPath: TMenuPath;
begin
  if AnItem = nil then Exit;
  case AnItem.DlgType of
  #0:  { ignore if no type, i.e., display header or blank };
  'A': ActivateAction(IntToStr(AnItem.IEN) + ';' + IntToStr(AnItem.FormID), Self, 0);
  'D': ActivateOrderDialog(IntToStr(AnItem.IEN), FDelayEvent, Self, 0);
  'M': begin
         // this simply moves to new menu, rather than open a new form as in ActivateOrderMenu
         if DialogNotDisabled(AnItem.IEN) then
         begin
           with FStack do MenuPath := TMenuPath(Items[Count - 1]);
           with MenuPath do
           begin
             Inc(Current);
             if Current > High(IENList) then SetLength(IENList, Current + 1);
             if Current <> AnItem.IEN then
             begin
               IENList := Copy(IENList, 0, Current + 1);
               IENList[Current] := AnItem.IEN;
             end;
             FOrderingMenu := AnItem.IEN;
             SetNavButtons;
             PlaceMenuItems;
             PushKeyVars(FKeyVars);
             with grdMenu do
               GoodNotifyWinEvent(EVENT_OBJECT_FOCUS, Handle, integer(OBJID_CLIENT), ColRowToIndex(Col,Row));
           end; {with MenuPath}
         end; {if}
       end; {'M'}
  'Q': ActivateOrderDialog(IntToStr(AnItem.IEN), FDelayEvent, Self, 0);
  'P': ShowMsg('Order Dialogs of type "Prompt" cannot be processed.');
  'O': begin
         // disable initially, since the 1st item in the set may be a menu
         Self.Enabled := False;
         if not ActivateOrderSet(IntToStr(AnItem.IEN), FDelayEvent, Self, 0)
           then Self.Enabled := True;
       end;
  else ShowMsg('Unknown Order Dialog type: ' + AnItem.DlgType);
  end; {case}
end;

{ imitate caption bar using panel at top of form }

procedure TfrmOMNavA.pnlToolMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button <> mbLeft then Exit;
  FStartPoint := TControl(Sender).ClientToScreen(Point(X, Y));
  FOrigPoint  := Point(Left, Top);
  FFormMove   := True;
end;

procedure TfrmOMNavA.pnlToolMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  NewPoint: TPoint;
begin
  if FFormMove then
  begin
    NewPoint := TControl(Sender).ClientToScreen(Point(X, Y));
    SetBounds(FOrigPoint.X - (FStartPoint.X - NewPoint.X),
              FOrigPoint.Y - (FStartPoint.Y - NewPoint.Y), Width, Height);
  end;
end;

procedure TfrmOMNavA.pnlToolMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FFormMove := False;
end;

procedure TfrmOMNavA.FormResize(Sender: TObject);
begin
  grdMenu.DefaultColWidth := (grdMenu.ClientWidth div grdMenu.ColCount) - 1;
  grdMenu.Refresh;
end;

procedure TfrmOMNavA.ResizeFont;
begin
  ResizeAnchoredFormToFont(Self);
  grdMenu.Canvas.Font := grdMenu.Font;
  grdMenu.Invalidate;
  pnlTool.Font.Size := Font.Size;
  cmdDone.Font.Size := Font.Size;
end;

{ TMenuPath }

destructor TMenuPath.Destroy;
begin
  SetLength(IENList, 0);
  inherited;
end;

end.
