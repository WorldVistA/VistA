unit fOCSession;

{ ------------------------------------------------------------------------------
  Update History

  2016-09-20: NSR#20101203 (Critical/Hight Order Check Display)
  ------------------------------------------------------------------------------- }
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fOCMonograph,
  fAutoSz, StdCtrls, ORFn, uConst, ORCtrls, ExtCtrls, VA508AccessibilityManager,
  Grids, strUtils, uDlgComponents, VAUtils, VA508AccessibilityRouter,
  Vcl.ComCtrls, Winapi.RichEdit, ShellAPI, ORNet, rOCSession, Data.Bind.EngExt,
  Vcl.Bind.DBEngExt, Vcl.ImgList, fOMAction, VA508ImageListLabeler, Vcl.Menus,
  System.Actions, Vcl.ActnList, System.ImageList, u508Button, ORExtensions;

type
  tStringListArray = array of TStringList;

  TfrmOCSession = class(TfrmAutoSz)
    PnlCtr: TPanel;
    PnlCtrBtm: TPanel;
    LblOverrideNum: TLabel;
    lblOverrideChecks: TVA508StaticText;
    PnlCtrLft: TPanel;
    pnlCtrRght: TPanel;
    lvOrders: ORExtensions.TListView;
    Splitter: TSplitter;
    rchOrdChk: rOCSession.TRichEdit;
    pnlReason: TPanel;
    lblReason: tLabel;
    pnlComment: TPanel;
    memRmtCmt: TMemo;
    Panel1: TPanel;
    Splitter2: TSplitter;
    ImageList1: TImageList;
    ImageList2: TImageList;
    lblNote: tLabel;
    pnlInstr: TPanel;
    pnlLegend: TPanel;
    lvLegend: ORExtensions.TListView;
    VA508StatusImgLst: TVA508ImageListLabeler;
    VA508CheckBoxImgLst: TVA508ImageListLabeler;
    pnlList: TPanel;
    pnlOrderChecks: TPanel;
    ActionList1: TActionList;
    acAllergyAssessment: TAction;
    acViewMonograph: TAction;
    grdPnlButtom: TGridPanel;
    cmbOverReason: TORComboBox;
    pnlPAA: TPanel;
    btnAllergy: u508Button.TButton;
    pnlVM: TPanel;
    btnMonograph: u508Button.TButton;
    pnlCCO: TPanel;
    cmdCancelOrder: u508Button.TButton;
    pnlAccept: TPanel;
    cmdContinue: u508Button.TButton;
    pnlRTO: TPanel;
    btnReturn: u508Button.TButton;
    lblInstr: TStaticText;
    lblComment: tLabel;
    procedure cmdAcceptOrdersClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure txtJustifyKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cmdMonographClick(Sender: TObject);
    procedure lvOrdersSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure memRmtCmtChange(Sender: TObject);
    procedure cmbOverReasonChange(Sender: TObject);
    procedure lvOrdersClick(Sender: TObject);
    procedure acViewMonographExecute(Sender: TObject);
    procedure acAllergyAssessmentExecute(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure pnlOrderChecksResize(Sender: TObject);
    procedure cmdCancelOrderClick(Sender: TObject);
    procedure lvOrdersEnter(Sender: TObject);
    procedure lvOrdersKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure memRmtCmtEnter(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    // procedure memNoteSetText(str: string);
  protected
    procedure ExecuteOrderCheckCallBack(Sender: TObject);
    procedure DoSetFontSize(FontSize: integer); override;
  private
    FOrderList: tStringListArray;
    overrideRecord: TOrderRec;
    fCurrentOrderChecks: TStringList;
    procedure EnableAllgyBtn;
    procedure UpdateStatusIcons();
    procedure SetupOrderChecksDisplay(aOrderLists: tStringListArray; aOrderCheckList: TStringList); overload;
    procedure SetupOrderChecksDisplay(aOrderCheckList: TStringList); overload;
    function ResizeLabels(aLabelObject: TObject): TRect;
    function ParseOrderCheckText(const inStr: String): String;
  public
    Property CurrentOrderChecks: TStringList read fCurrentOrderChecks write fCurrentOrderChecks;
  end;

procedure ExecuteOrderChecks;

procedure ExecuteReleaseOrderChecks(SelectList: TList);
procedure ExecuteReleaseOrderChecksSL(SelectList: TStringList);

function ExecuteSessionOrderChecks(OrderLists: tStringListArray): Boolean;
Procedure LookupOrderChecks(aOrderLists: tStringListArray;
  aReturnList: TStringList);

const
  // Status Images
  Status_UnChk = 0;
  Status_Chk = 1;

  // State Images
  State_Alert = 0;
  State_Chk = 1;
  State_Cancel = 2;

  NonOrders: array [0 .. 1] of string = ('ALLGY', 'MONO');
  NO_REMOTE_COMMENTS = 'No Remote Comments found';
  REASON_REQUIRED_FOR_OVERRIDE =
    'Checks marked with *** require reason for override';

implementation

{$R *.DFM}

uses rOrders, uCore, rMisc, fFrame, fAllgyAR, System.UITypes, uOrders;

var
  frmOCSession: TfrmOCSession;

Procedure LookupOrderChecks(aOrderLists: tStringListArray;
  aReturnList: TStringList);
var
  LoadList: TStringList;
  j: Integer;
begin
  if not assigned(aReturnList) then
    exit;

  LoadList := TStringList.Create;
  try
    // set up our "LoadList" which is used to gather the data
    for j := Low(aOrderLists) to High(aOrderLists) do
      LoadList.AddStrings(aOrderLists[j]);

    if LoadList.Count > 0 then
      OrderChecksForSession(aReturnList, LoadList);
  finally
    LoadList.Free;
  end;
end;

{ TODO -oChris Bell : test non critical order checks }
{ Returns True if the Signature process should proceed.
  Clears OrderList If False. }
function ExecuteSessionOrderChecks(OrderLists: tStringListArray): Boolean;
var
  j, n: Integer;
  CheckList: TStringList;
  LstItem: TListItem;

begin
  Screen.Cursor := crHourGlass;
  Try
    Result := true; //was "false". RTC#412125
    CheckList := TStringList.Create;
    try
      StatusText('Order Checking...');

      //Look up the order checks
      LookupOrderChecks(OrderLists, CheckList);

      StatusText('');

      if CheckList.Count > 0 then
      begin

        frmOCSession := TfrmOCSession.Create(Application);
        try

          frmOCSession.SetupOrderChecksDisplay(OrderLists, CheckList);
          frmOCSession.ShowModal;

          Result := frmOCSession.ModalResult <> mrCancel;
          if not Result then
          begin
            for j := Low(OrderLists) to High(OrderLists) do
            begin
              for n := 0 to OrderLists[j].Count - 1 do
                UnlockOrder(Piece(OrderLists[j].Strings[n], U, 1));
              OrderLists[j].Clear;
            end;

            if Assigned(frmFrame) then
              frmFrame.SetActiveTab(CT_ORDERS);
          end;

          // clean up objects
          for LstItem in frmOCSession.lvOrders.Items do
            TOrderRec(LstItem.Data).Free;

          SetLength(frmOCSession.FOrderList, 0);
        finally
          FreeAndNil(frmOCSession);
        end; { try }
      end; { if CheckList }
    finally
      CheckList.Free;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure ExecuteOrderChecks;
var
  CheckList: TStringList;
begin
  //After allergy assesment is performed we need to re-run the order checks for all orders
  if Assigned(frmOCSession) then
  begin
    CheckList := TStringList.Create;
    try
      //Look up the order checks
      LookupOrderChecks(frmOCSession.FOrderList, CheckList);

      if CheckList.Count > 0 then
      begin
        frmOCSession.SetupOrderChecksDisplay(CheckList);

        // Disable the button after refresh is done.
        frmOCSession.btnAllergy.Enabled := False;
      end else
      begin
        frmOCSession.ModalResult := mrOk;
    //    frmOCSession.close;
      end;
    finally
      CheckList.Free;
    end;
  end;


    {
    if Assigned(frmOCSession) then
      begin
        if Assigned(frmOCSession.lvOrders.Selected) then
          if Assigned(frmOCSession.lvOrders.Selected.Data) then
          begin
            TheOrderRec := TOrderRec(frmOCSession.lvOrders.Selected.Data);
            OrderList := nil;
            LoadList := nil;
            try
              OrderList := TStringList.Create;
              LoadList := TStringList.Create;
              OrderList.Add(TheOrderRec.OrderID + '^^1');
              OrderChecksForSession(LoadList, OrderList);

              // Sort the list by ID
              SortByPiece(LoadList, U, 1);
              DisplayTxt := TStringList.Create;
              try
                // Format each string in the RPC return and add to our output string
                for S in LoadList do
                  DisplayTxt.Add(frmOCSession.ParseOrderCheckText(s));

                TheOrderRec.SetOrderCheckText(DisplayTxt);
                // Needs to be reset
                TheOrderRec.IsComplete := False;
              finally
                DisplayTxt.Free;
              end;
              // select the first order in the list
              frmOCSession.lvOrders.Selected.Selected := true;
              //frmOCSession.lvOrders.Items[frmOCSession.lvOrders.ItemIndex].Selected := true;
              // Update Status of the Form
              frmOCSession.UpdateStatusIcons();

              frmOCSession.EnableAllgyBtn;
            finally
              LoadList.Free;
              OrderList.Free;
            end;

          end;
      end;
  }
end;

function ParceOrderCheckText(const instr: string): String;
begin
  Result := '';
  // Add check type. 1=high 2=moderate 3=low
  SetPiece(Result, U, 1, trim(Piece(instr, U, 3)));
  // Add display text
  SetPiece(Result, U, 2, Piece(instr, U, 4));
  if (Piece(instr, U, 2) = '3') and (Piece(instr, U, 5) = '1')
  then
  begin
    // Add collection for comment flag
    SetPiece(Result, U, 3, Piece(instr, U, 5));
    // Add previous comment
    SetPiece(Result, U, 4, Piece(instr, U, 7));
    // Add Override Reason //TDP - Added Override Reason
    SetPiece(Result, U, 5, Piece(instr, U, 8));
  end;
end;

procedure ExecuteReleaseOrderChecks(SelectList: TList);
var
  i: Integer;
  AnOrder: TOrder;
  OrderIDList: TStringList;
  OrderListArray: TstringListArray;
begin
  OrderIDList := TStringList.Create;
  try
    for i := 0 to SelectList.Count - 1 do
    begin
      AnOrder := TOrder(SelectList.Items[i]);
      OrderIDList.Add(AnOrder.ID + '^^1'); // 3rd pce = 1 means releasing order
    end;

    OrderListArray := [OrderIDList];
    if ExecuteSessionOrderChecks([OrderIDList]) then
    begin
      If OrderIDList.Count > 0 then
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
      end;
    end;
    if OrderIDList.Count < 1 then
      SelectList.Clear;
  finally
    OrderIDList.Free;
  end;
end;

procedure ExecuteReleaseOrderChecksSL(SelectList: TStringList);
var
  sID: String;
  i: Integer;
  OrderIDList: TStringList;
begin
  OrderIDList := TStringList.Create;
  try
    for i := 0 to SelectList.Count - 1 do
    begin
      sID := SelectList[i] + '^^1';
      OrderIDList.Add(sID); // 3rd pce = 1 means releasing order
    end;
    if ExecuteSessionOrderChecks([OrderIDList]) then
    begin
      If OrderIDList.Count > 0 then
      begin
        for i := SelectList.Count - 1 downto 0 do
        begin
          sID := SelectList[i];
          if OrderIDList.IndexOf(sID+ '^^1') < 0 then
          begin
            Changes.Remove(CH_ORD, sID);
            SelectList.Delete(i);
          end;
        end;
      end;
    end;
    if OrderIDList.Count < 1 then
      SelectList.Clear;
  finally
    OrderIDList.Free;
  end;
end;
////////////////////////////////////////////////////////////////////////////////

procedure TfrmOCSession.EnableAllgyBtn;
var
  S: string;
begin
  acAllergyAssessment.Enabled :=
    CallVistA('ORQQAL LIST', [Patient.DFN], S) and
      (S = '^No Allergy Assessment');
end;

procedure TfrmOCSession.cmdAcceptOrdersClick(Sender: TObject);

  procedure ProcessChks();
  var
    AnOrderID, CommentStr, ReasonStr: String;
    CList, RList: TStringList;
    lstItm: TListItem;
    TheRec: TOrderRec;
  begin
    RList := nil;
    CList := nil;
    try
      RList := TStringList.Create;
      CList := TStringList.Create;

      for lstItm in lvOrders.Items do
      begin
        if Assigned(lstItm.Data) then
        begin
          TheRec := TOrderRec(lstItm.Data);

          if IndexText(TheRec.OrderID, NonOrders) > -1 then
            continue;

          if not TheRec.Canceled then
          begin
            if TheRec.IsCritical then
              ReasonStr := trim(TheRec.OverRideSel);

            CommentStr := trim(TheRec.CommentTxt.text);
            AnOrderID := TheRec.OrderID;

            RList.Add(AnOrderID + '^' + ReasonStr);
            CList.Add(AnOrderID + '^' + CommentStr);
          end;
        end;
      end;

      StatusText('Saving Order Check...');
      if fCurrentOrderChecks.Count > 0 then
        SaveMultiOrderChecksForSession(fCurrentOrderChecks, RList, CList);
      StatusText('');
    finally
      CList.Free;
      RList.Free;
    end;
  end;

var
  lstItm: TListItem;
  ChangeLst: TStringList;
  TheRec: TOrderRec;
  ChangeStr: WideString;
  StrItm: String;
  OldCursor: TCursor;
begin
  inherited;
  OldCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    ChangeLst := TStringList.Create;
    try
      for lstItm in lvOrders.Items do
      begin
        if Assigned(lstItm.Data) then
        begin
          TheRec := TOrderRec(lstItm.Data);
          if IndexText(TheRec.OrderID, NonOrders) > -1 then
            continue;

          ChangeLst.Add(MixedCase(TheRec.OrderName))
        end;
      end;
      ChangeStr := '';

      if trim(ChangeStr) <> '' then
        ChangeStr := ChangeStr + #13#10;

      if ChangeLst.Count > 0 then
        ChangeStr := ChangeStr +
          'The following item(s) will be accepted:' + #13#10;
      for StrItm in ChangeLst do
        ChangeStr := ChangeStr + StrItm + #13#10;

      if trim(ChangeStr) <> '' then
        ChangeStr := ChangeStr + #13#10;
        // build the save
        if ChangeLst.Count > 0 then
          ProcessChks;

        ModalResult := mrOk;
    finally
      ChangeLst.Free;
    end;
  finally
    Screen.Cursor := OldCursor;
  end;
end;

procedure TfrmOCSession.cmdCancelOrderClick(Sender: TObject);

  procedure RemoveCanceled();
  var
    I, X, y: Integer;
    lstItm: TListItem;
    TheRec: TOrderRec;
  begin
    for I := lvOrders.Items.Count-1 downto 0 do
    begin
      lstItm := lvOrders.Items[I];
      if Assigned(lstItm.Data) then
      begin
        TheRec := TOrderRec(lstItm.Data);

        if IndexText(TheRec.OrderID, NonOrders) > -1 then
          continue;

        if TheRec.Canceled then
        begin
          if DeleteCheckedOrder(TheRec.OrderID) then
          begin
            Changes.Remove(CH_ORD, TheRec.OrderID);
            lstItm.Delete;
            try
              for X := Low(FOrderList) to High(FOrderList) do
              begin
                for y := FOrderList[X].Count - 1 downto 0 do
                  if Piece(FOrderList[X].Strings[y], U, 1) = TheRec.OrderID then
                  begin
                    FOrderList[X].Delete(y);
                 end;
              end;
            finally
              FreeAndNil(TheRec);
            end;
          end;
        end;
      end;
    end;
  end;

var
  lstItm: TListItem;
  CancelLst: TStringList;
  TheRec: TOrderRec;
  ChangeStr: WideString;
  StrItm: String;
  OldCursor: TCursor;
begin
  OldCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    inherited;
    CancelLst := TStringList.Create;
    try
      for lstItm in lvOrders.Items do
      begin
        if Assigned(lstItm.Data) then
        begin
          TheRec := TOrderRec(lstItm.Data);
          if IndexText(TheRec.OrderID, NonOrders) > -1 then
            continue;

          if TheRec.Canceled then
            CancelLst.Add(MixedCase(TheRec.OrderName))
        end;
      end;

      if CancelLst.Count > 0 then
        ChangeStr := 'The following item(s) will be canceled:' + #13#10;

      for StrItm in CancelLst do
        ChangeStr := ChangeStr + StrItm + #13#10;

      if trim(ChangeStr) <> '' then
        ChangeStr := ChangeStr + #13#10;

      // Cancel process
      if CancelLst.Count > 0 then
        RemoveCanceled;

      //check for remaining orders
      if lvOrders.Items.Count = 0 then
        ModalResult := mrCancel;

    finally
      CancelLst.Free;
    end;
  finally
    Screen.Cursor := OldCursor;
  end;
  UpdateStatusIcons;
end;

procedure TfrmOCSession.cmdMonographClick(Sender: TObject);
var
  monoList: TStringList;
begin
  inherited;
  monoList := TStringList.Create;
  try
    GetMonographList(monoList);
    ShowMonographs(monoList);
  finally
    monoList.Free;
  end;
end;

procedure TfrmOCSession.DoSetFontSize(FontSize: integer);
begin
  // Don't do inherited;
end;

procedure TfrmOCSession.ExecuteOrderCheckCallBack(Sender: TObject);
begin
  ExecuteOrderChecks;
end;

procedure TfrmOCSession.cmbOverReasonChange(Sender: TObject);
begin
  inherited;
  if Assigned(overrideRecord) then
  begin
    overrideRecord.OverRideSel := cmbOverReason.text;
    overrideRecord.IsComplete := IsValidOverrideReason(overrideRecord.OverRideSel);
    UpdateStatusIcons;
  end;
end;

procedure TfrmOCSession.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  SaveUserBounds(self); // Save Position & Size of Form
  DeleteMonograph;
end;

procedure TfrmOCSession.FormCreate(Sender: TObject);
begin
  inherited;
  fCurrentOrderChecks := TStringList.Create;
end;

procedure TfrmOCSession.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fCurrentOrderChecks);
  inherited;
end;

procedure TfrmOCSession.FormShow(Sender: TObject);
begin
  inherited;
  SetFormPosition(self); // Get Saved Position & Size of Form
  // 508 Code here
  if ScreenReaderActive = True then
  begin
    pnlInstr.TabStop := True;
    lblOverrideChecks.TabStop := True;
    lvLegend.TabStop := True;
    pnlInstr.SetFocus;
  end;

  PnlCtrLft.Width := (ClientWidth div 2);

  rchOrdChk.AutoDetect := true;

  UpdateStatusIcons;
end;

procedure TfrmOCSession.lvOrdersClick(Sender: TObject);
var
  htst: THitTests;
  lvCurPos: TPoint;
  lstItm: TListItem;
begin
  inherited;
  lvCurPos := lvOrders.ScreenToClient(Mouse.CursorPos);
  htst := lvOrders.GetHitTestInfoAt(lvCurPos.X, lvCurPos.y);

  if htOnStateIcon in htst then
  begin
    lstItm := lvOrders.GetItemAt(lvCurPos.X, lvCurPos.y);
    if Assigned(lstItm) then
    begin
      if Assigned(lstItm.Data) then
      begin
        if IndexText(TOrderRec(lstItm.Data).OrderID, NonOrders) = -1 then
        begin
          Case lstItm.StateIndex of
            - 1:
              exit;
            Status_UnChk:
              begin
                lstItm.StateIndex := Status_Chk;
                lstItm.Checked := true;
                TOrderRec(lstItm.Data).Canceled := true;
              end;
            Status_Chk:
              begin
                lstItm.StateIndex := Status_UnChk;
                lstItm.Checked := false;
                TOrderRec(lstItm.Data).Canceled := false;
              end;
          End;
        end;
      end;
    end;
  end;
  UpdateStatusIcons;
end;

procedure TfrmOCSession.lvOrdersEnter(Sender: TObject);
begin
  inherited;
  if lvOrders.Items.Count > 0 then
  begin
    lvOrders.Items.Item[0].Focused := True;
    lvOrders.Items.Item[0].Selected := True; //lvOrders.Items[0];
  end;
end;

procedure TfrmOCSession.lvOrdersKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  lstItm: TListItem;
begin
  inherited;

  if Key = vkSpace then
  begin
    lstItm := lvOrders.Selected;
    if Assigned(lstItm) then
    begin
      if Assigned(lstItm.Data) then
      begin
        if IndexText(TOrderRec(lstItm.Data).OrderID, NonOrders) = -1 then
        begin
          Case lstItm.StateIndex of
            - 1:
              exit;
            Status_UnChk:
              begin
                lstItm.StateIndex := Status_Chk;
                lstItm.Checked := true;
                TOrderRec(lstItm.Data).Canceled := true;
              end;
            Status_Chk:
              begin
                lstItm.StateIndex := Status_UnChk;
                lstItm.Checked := false;
                TOrderRec(lstItm.Data).Canceled := false;
              end;
          End;
        end;
      end;
    end;
    UpdateStatusIcons;
  end;
end;

procedure TfrmOCSession.UpdateStatusIcons();
var
  lstItm: TListItem;
  AnyIncomplete: Boolean;
  ItemsRemaining: Integer;
begin
  AnyIncomplete := false;
  lvOrders.Items.BeginUpdate;
  try
    ItemsRemaining := 0;
    cmdCancelOrder.Enabled := False;
    for lstItm in lvOrders.Items do
    begin
      if lstItm.Checked then begin
        lstItm.SubItemImages[0] := State_Cancel;
        cmdCancelOrder.Enabled := True;
        AnyIncomplete := True;
      end
      else
      begin
        if Assigned(lstItm.Data) then
        begin
          if IndexText(TOrderRec(lstItm.Data).OrderID, NonOrders) = -1 then
          begin
            if TOrderRec(lstItm.Data).IsComplete then
              lstItm.SubItemImages[0] := State_Chk
            else
            begin
              if TOrderRec(lstItm.Data).IsCritical then
                lstItm.SubItemImages[0] := State_Alert
              else
                lstItm.SubItemImages[0] := -1;
              AnyIncomplete := true;
              if TOrderRec(lstItm.Data).IsCritical then
                Inc(ItemsRemaining);
            end;
          end;
        end;
      end;
    end;
  finally
    lvOrders.Items.EndUpdate;
  end;
  cmdContinue.Enabled := not AnyIncomplete;
  // Update remaining count
  LblOverrideNum.Caption := IntToStr(ItemsRemaining);
end;

procedure TfrmOCSession.lvOrdersSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
var
  i: Integer;
  cmbchange: boolean;
const
  fmtOrderTitle = 'Order Checks for: %s';
var
  ChangeEVT: TNotifyEvent;
  chkLvl: string;
begin
  // Load the info
  if (not Assigned(Item)) or (not Assigned(Item.Data)) or
    (not Item.Selected) then
    exit;

  overrideRecord := TOrderRec(Item.Data);

  Panel1.BringToFront;
  // Populate the data
  rchOrdChk.Clear;
  rchOrdChk.Clear;
  memRmtCmt.Clear;

  // Add the critical header if needed
  ChangeEVT := cmbOverReason.OnChange;
  cmbOverReason.OnChange := nil;
  try

    cmbOverReason.ItemIndex := -1;
    if overrideRecord.IsCritical then
    begin
      pnlReason.TabStop := false;
      cmbOverReason.Enabled := true;
      cmbOverReason.Text := '';

      rchOrdChk.Lines.Add(Format(fmtOrderTitle, [overrideRecord.OrderName]));
      rchOrdChk.Lines.Add('');

      rchOrdChk.SelAttributes.Color := Get508CompliantColor(clRed);
      rchOrdChk.Lines.Add(REASON_REQUIRED_FOR_OVERRIDE);
      // '*Order Check Requires Reason for Override'});
    end
    else
    begin
      cmbOverReason.Enabled := false;
      pnlReason.TabStop := ScreenReaderActive;
      //TDP - If not Critical change status indicator to Check/Complete
      //TOrderRec(lvOrders.Items.Item[lvOrders.ItemIndex].Data).IsComplete := true;//.SubItemImages[0] := State_Chk;
      TOrderRec(Item.Data).IsComplete := true;
      UpdateStatusIcons;
    end;

    chkLvl := '';

    for i := 0 to overrideRecord.OrderCheckTxt.Count - 1 do
    begin
      rchOrdChk.SelAttributes.Color := Get508CompliantColor(clBlack);
      rchOrdChk.SelAttributes.Style := [fsBold];
      rchOrdChk.Lines.Add('(' + IntToStr(i + 1) + ' of ' +
        IntToStr(overrideRecord.OrderCheckTxt.Count) + ')  ');
      rchOrdChk.SelAttributes.Style := [];

      if Piece(overrideRecord.OrderCheckTxt.Strings[i], U, 1) = '1' then
      begin
        // High
        rchOrdChk.SelAttributes.Color := Get508CompliantColor(clBlue);
        chkLvl := '{Check Level: High} ';
      end else if Piece(overrideRecord.OrderCheckTxt.Strings[i], U, 1) = '2' then
      begin
        // Moderate
        rchOrdChk.SelAttributes.Color := Get508CompliantColor(clGreen);
        chkLvl := '{Check Level: Moderate} ';
      end else begin
        // Low
        rchOrdChk.SelAttributes.Color := Get508CompliantColor(clBlack);
        chkLvl := '{Check Level: Low} ';
      end;

      rchOrdChk.Lines.Add(chkLvl+Piece(Trim(overrideRecord.OrderCheckTxt.Strings[i]), U, 2));
      if not (I = overrideRecord.OrderCheckTxt.Count - 1) then
        rchOrdChk.Lines.Add('');
    end;

    cmbOverReason.Items := overrideRecord.OverRideReasons;
    cmbOverReason.ItemIndex := -1;

    cmbchange := false;

    if overrideRecord.OverRideSel <> '' then
    begin
      for i := 0 to cmbOverReason.Items.Count - 1 do
        if cmbOverReason.Items.Strings[i] = overrideRecord.OverRideSel then
        begin
          cmbOverReason.ItemIndex := i;
          cmbchange := true;
          break;
        end;

      if cmbOverReason.ItemIndex = -1 then
      begin
        cmbOverReason.text := overrideRecord.OverRideSel;
        cmbchange := true;
      end;

      if cmbchange then cmbOverReasonChange(cmbOverReason);

    end;
  finally
    cmbOverReason.OnChange := ChangeEVT;
  end;

  cmbOverReason.Enabled := overrideRecord.IsCritical;
  memRmtCmt.Lines := overrideRecord.CommentTxt;

  // AA: disabling changes color of the memRmtCmt. ReadOnly is enough
  // memRmtCmt.Enabled := overrideRecord.HaveComment;
  memRmtCmt.ReadOnly := not overrideRecord.HaveComment;
  if not overrideRecord.HaveComment then
  begin
    memRmtCmt.text := NO_REMOTE_COMMENTS;
    memRmtCmt.Color := clBtnFace;
  end
  else
    memRmtCmt.Color := clWindow;

  if not overrideRecord.IsCritical then
    overrideRecord.IsComplete := true;
end;

procedure TfrmOCSession.memRmtCmtChange(Sender: TObject);
begin
  inherited;
  if memRmtCmt.text = NO_REMOTE_COMMENTS then
    exit;
  if Assigned(overrideRecord) then
    overrideRecord.CommentTxt.Assign(memRmtCmt.Lines);
end;

procedure TfrmOCSession.memRmtCmtEnter(Sender: TObject);
var
  SpeakString: String;
begin
  // Due to readonly the lable is not read via the 508 manager
  if memRmtCmt.ReadOnly then
  begin
    SpeakString := StringReplace(lblComment.Caption, '&', '', [rfReplaceAll]);
    SpeakString := StringReplace(SpeakString, '(', ',', [rfReplaceAll]);
    SpeakString := StringReplace(SpeakString, ')', ',', [rfReplaceAll]);
    GetScreenReader.Speak(SpeakString);
  end;
  inherited;
end;

procedure TfrmOCSession.pnlOrderChecksResize(Sender: TObject);
var
  aRect: TRect;
begin
  inherited;
  aRect := ResizeLabels(lblNote);
  lblNote.Width := aRect.Width;
  lblNote.Height := aRect.Height + 8;
end;

procedure TfrmOCSession.txtJustifyKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  // GE CQ9540  activate Return key, behave as "Continue" buttom clicked.
  if Key = VK_RETURN then
    cmdAcceptOrdersClick(self);
end;

function TfrmOCSession.ParseOrderCheckText(const inStr: String): String;
begin
  result := '';
  // Add check type. 1=high 2=moderate 3=low
  SetPiece(result, U, 1, trim(Piece(inStr, U, 3)));
  // Add display text
  SetPiece(result, U, 2, Piece(inStr, U, 4));
  if (Piece(inStr, U, 2) = '3') and (Piece(inStr, U, 5) = '1')
  then
  begin
    // Add collection for comment flag
    SetPiece(result, U, 3, Piece(inStr, U, 5));
    // Add previous comment
    SetPiece(result, U, 4, Piece(inStr, U, 7));
    // Add Override Reason //TDP - Added Override Reason
    SetPiece(result, U, 5, Piece(inStr, U, 8));
  end;
end;

procedure TfrmOCSession.acAllergyAssessmentExecute(Sender: TObject);
begin
  inherited;
  fAllgyAR.EnterEditAllergy(0, true, false, nil, -1, True,
    ExecuteOrderCheckCallBack, False);
end;

procedure TfrmOCSession.acViewMonographExecute(Sender: TObject);
var
  monoList: TStringList;
begin
  inherited;
  monoList := TStringList.Create;
  try
    GetMonographList(monoList);
    ShowMonographs(monoList);
  finally
    monoList.Free;
  end;
end;

procedure TfrmOCSession.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_F4) and (ssAlt in Shift) then
    Key := 0;
end;

function TfrmOCSession.ResizeLabels(aLabelObject: TObject) : TRect;
var
  aDummyLbl: TLabel;
  lText: String;
begin
  aDummyLbl := TLabel.Create(self);
  try
    if aLabelObject is TStaticText then
    begin
      aDummyLbl.Parent := TStaticText(aLabelObject).Parent;
      aDummyLbl.Align := alClient;
      aDummyLbl.Caption := TStaticText(aLabelObject).Caption;
      aDummyLbl.WordWrap := True;
    end else if aLabelObject is TLabel then
    begin
      aDummyLbl.Parent := TLabel(aLabelObject).Parent;
      aDummyLbl.Align := alClient;
      aDummyLbl.Caption := TLabel(aLabelObject).Caption;
      aDummyLbl.WordWrap := True;
    end else raise Exception.Create('aLabelObject is not TStaticText or Tlabel');

    lText := aDummyLbl.Caption;
    Result.Left := 0;
    Result.Right := aDummyLbl.Width;
    Result.Top := 0;
    Result.Bottom := 0;
    aDummyLbl.Canvas.TextRect(Result, lText, [tfCalcRect, tfWordBreak]);
  Finally
    aDummyLbl.Free;
  End;
end;

procedure TfrmOCSession.FormResize(Sender: TObject);
var
  ARect: TRect;
begin
  aRect := ResizeLabels(lblInstr);
  lblInstr.Width := aRect.Width;
  lblInstr.Height := aRect.Height;

  if Self.Font.Size > 10 then
    grdPnlButtom.Height := 50
  else
    grdPnlButtom.Height := 34;
  inherited;
end;

procedure TfrmOCSession.SetupOrderChecksDisplay(aOrderCheckList: TStringList);
begin
  SetupOrderChecksDisplay(nil, aOrderCheckList);
end;

procedure TfrmOCSession.SetupOrderChecksDisplay(aOrderLists: tStringListArray; aOrderCheckList: TStringList);

  function getNextOne(aList: TStringList; aCurrent: Integer): String;
  begin
    Result := '';
    if aCurrent < aList.Count - 1 then
      Result := aList[aCurrent + 1];
  end;

var
  RtnCursor, nn: Integer;
  NxtID, TmpStr, NewID, LstStr, OrderName: String;
  DisplayTxt: TStringList;
  LstEnum: TStringsEnumerator;
  LstItem: TListItem;
  TheOrderRec: TOrderRec;
begin
  RtnCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    frmOCSession.lvOrders.Clear;

    CurrentOrderChecks.Assign(aOrderCheckList);

    AutoSizeDisabled := true;

    ResizeFormToFont(self);

    NxtID := '';

    // Sort the list by ID
    SortByPiece(aOrderCheckList, U, 1);

    DisplayTxt := TStringList.Create;
    try
      // loop and build out the needed data
      nn := 0;
      LstEnum := aOrderCheckList.GetEnumerator;
      while LstEnum.MoveNext do
      begin
        TmpStr := '';
        LstStr := LstEnum.Current;
        // Grab the data
        NewID := Piece(LstStr, U, 1);

        // Look at the next ID to see if its a new record
        NxtID := getNextOne(aOrderCheckList, nn);
        NxtID := Piece(NxtID, U, 1);
        Inc(nn);

        TmpStr := frmOCSession.ParseOrderCheckText(LstStr);

        // add the out put to our stringlist
        DisplayTxt.Add(TmpStr);
        // If order changes then lets build the panel
        if NewID <> NxtID then
        begin
          OrderName := StringReplace(trim(TextForOrder(NewID)), #$D#$A, ' -- ',
            [rfReplaceAll, rfIgnoreCase]);
          LstItem := frmOCSession.lvOrders.Items.Add;
          TheOrderRec := TOrderRec.Create(NewID, OrderName, DisplayTxt);
          LstItem.Data := TheOrderRec;
          LstItem.Caption := '';
          LstItem.ImageIndex := -1;
          LstItem.SubItems.Add('');
          LstItem.StateIndex := 0;
          if TheOrderRec.IsCritical then
          begin
            LstItem.SubItemImages[0] := State_Alert;
            LstItem.SubItems.Add( { '*' + } OrderName);
          end
          else
          begin
            LstItem.SubItemImages[0] := -1;
            LstItem.SubItems.Add(OrderName);
          end;
          DisplayTxt.Clear;
        end;
      end;

    finally
      DisplayTxt.Free;
    end;

    // set up frmOCSession.FOrderList which is used to keep track of what was removed
    if aOrderLists <> nil then
    begin
      SetLength(FOrderList, 0);
      FOrderList := copy(aOrderLists, 0, Length(aOrderLists));
    end;

    MessageBeep(MB_ICONASTERISK);
    if Visible then
      SetFocus;

    // Make the call to set the allergry assesment up
    EnableAllgyBtn;

    // Add the Monograph
    acViewMonograph.Enabled := IsMonograph;
    // select the first order in the list
    if lvOrders.Items.Count > 0 then
      lvOrders.Items[0].Selected := true;

  finally
    Screen.Cursor := RtnCursor;
  end;
end;

end.
