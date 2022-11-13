unit fPrintLocation;

interface

uses
  Windows, Messages, SysUtils, StrUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fAutoSz, StdCtrls, ExtCtrls, ORCtrls,ORFn, rCore, uCore, oRNet, Math, fOrders, ORClasses, rOrders,
  fMeds, rMeds, CheckLst, Grids, fFrame, fClinicWardMeds,
  VA508AccessibilityManager;

type
  TfrmPrintLocation = class(TfrmAutoSz)
    pnlTop: TPanel;
    pnlBottom: TORAutoPanel;
    orderGrid: TStringGrid;
    pnlOrder: TPanel;
    btnOK: TButton;
    lblText: TLabel;
    btnClinic: TButton;
    btnWard: TButton;
    lblEncounter: TLabel;
    cbolocation: TORComboBox;
    ORpnlBottom: TORAutoPanel;
    orpnlTopBottom: TORAutoPanel;
    cboEncLoc: TComboBox;
    procedure pnlFieldsResize(Sender: TObject);
    procedure orderGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OrderGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure orderGridKeyPress(Sender: TObject; var Key: Char);
    procedure btnClinicClick(Sender: TObject);
    procedure btnWardClick(Sender: TObject);
    procedure cbolocationChange(Sender: TObject);
    procedure cbolocationExit(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    CLoc,WLoc: string;
    CIEN,WIEN: integer;
    function ValFor(FieldID, ARow: Integer): string;
    procedure ShowEditor(ACol, ARow: Integer; AChar: Char);
    procedure ProcessClinicOrders(WardList, ClinicList: TStringList; WardIEN, ClinicIEN: integer; ContainsIMO: boolean);
    procedure rpcChangeOrderLocation(pOrderList:TStringList; ContainsIMO: boolean);
    function ClinicText(ALoc: integer): string;
  public
     { Public declarations }
  CloseOK: boolean;
  DisplayOrders: boolean;
  class procedure PrintLocation(OrderLst: TStringList; pEncounterLoc: integer; pEncounterLocName, pEncounterLocText: string;
             pEncounterDT: TFMDateTime; pEncounterVC: Char; var ClinicLst, WardLst: TStringList;
             var wardIEN: integer; var wardLocation: string; ContainsIMOOrders: boolean; displayEncSwitch: boolean = false);
  class procedure SwitchEncounterLoction(pEncounterLoc: integer; pEncounterLocName, pEncounterLocText: string; pEncounterDT: TFMDateTime; pEncounterVC: Char);
  class function rpcIsPatientOnWard(Patient: string): string;
  class function rpcIsClinicOrder(IEN: string): string;
  end;

var
  frmPrintLocation: TfrmPrintLocation;
  // ClinicIEN, WardIen: integer;
  // ASvc, ClinicLocation, WardLocation: string;
  ClinicArr: TStringList;
  WardArr: TStringList;

implementation

{$R *.dfm}
uses
  VAUtils;
//fFrame;

Const
COL_ORDERINFO = 0;
COL_ORDERTEXT = 1;
COL_LOCATION  = 2;
TAB           = #9;
  LOCATION_CHANGE_1  = 'The patient is admitted to ward';
  LOCATION_CHANGE_2  = 'You have the chart open to a clinic location of';
  LOCATION_CHANGE_2W = 'You have the chart open with the patient still on ward';
  LOCATION_CHANGE_3  = 'What Location are these orders associated with?';
  LOCATION_CHANGE_4  = 'The patient has now been admitted to ward: ';



{ TfrmPrintLocation }

procedure TfrmPrintLocation.btnClinicClick(Sender: TObject);
var
i: integer;
begin
  inherited;
  for i := 1 to self.orderGrid.RowCount do
    begin
      self.orderGrid.Cells[COL_LOCATION,i] := frmPrintLocation.CLoc;
    end;
end;

procedure TfrmPrintLocation.btnOKClick(Sender: TObject);
var
i: integer;
Action: TCloseAction;
begin
if ClinicArr = nil then ClinicArr := TStringList.Create;
if WardArr = nil then wardArr := TStringList.Create;
 if (frmPrintLocation.cboEncLoc.Enabled = true) and (frmPrintLocation.cboEncLoc.ItemIndex = -1) then
    begin
      infoBox('A location must be selected to continue processing patient data', 'Warning', MB_OK);
      exit;
    end;
if frmPrintLocation.DisplayOrders = true then
 begin
   for i := 1 to self.orderGrid.RowCount-1 do
   begin
     if ValFor(COL_LOCATION, i) = '' then
       begin
         infoBox('Every order must have a location define.','Location error', MB_OK);
         exit;
       end;
     if ValFor(COL_LOCATION, i) = frmPrintLocation.CLoc then ClinicArr.Add(ValFor(COL_ORDERINFO, i))
     else if ValFor(COL_LOCATION, i) = frmPrintLocation.WLoc then WardArr.Add(ValFor(COL_ORDERINFO, i));
   end;
 end;
 CloseOK := True;
 Action := caFree;
 frmPrintLocation.FormClose(frmPrintLocation, Action);
 if Action = caFree then frmPrintLocation.Close;
end;

procedure TfrmPrintLocation.btnWardClick(Sender: TObject);
var
i: integer;
begin
  inherited;
  for i := 1 to self.orderGrid.RowCount do
    begin
      self.orderGrid.Cells[COL_LOCATION,i] := frmPrintLocation.WLoc;
    end;
end;

procedure TfrmPrintLocation.cbolocationChange(Sender: TObject);
begin
self.orderGrid.Cells[COL_LOCATION, self.orderGrid.Row] := self.cbolocation.Text;
end;

procedure TfrmPrintLocation.cbolocationExit(Sender: TObject);
begin
cboLocation.Hide;
end;

procedure TfrmPrintLocation.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
i :Integer;
//Action1: TCloseAction;
begin
  inherited;
  if not CloseOK then
    begin
      if ClinicArr = nil then ClinicArr := TStringList.Create;
      if WardArr = nil then wardArr := TStringList.Create;
      if (frmPrintLocation.cboEncLoc.Enabled = true) and (frmPrintLocation.cboEncLoc.ItemIndex = -1) then
        begin
          infoBox('A location must be selected to continue processing patient data', 'Warning', MB_OK);
          Action := caNone;
          exit;
        end;
      for i := 1 to self.orderGrid.RowCount-1 do
        begin
          if ValFor(COL_LOCATION, i) = '' then
            begin
              infoBox('Every order must have a location define.','Location error', MB_OK);
              Action := caNone;
              exit;
            end;
          if ValFor(COL_LOCATION, i) = frmPrintLocation.CLoc then ClinicArr.Add(ValFor(COL_ORDERINFO, i))
          else if ValFor(COL_LOCATION, i) = frmPrintLocation.WLoc then WardArr.Add(ValFor(COL_ORDERINFO, i));
        end;
      CloseOK := True;
    end;
    Action := caFree;
end;

procedure TfrmPrintLocation.FormDestroy(Sender: TObject);
begin
  inherited;
  frmPrintLocation := nil;
end;

procedure TfrmPrintLocation.FormResize(Sender: TObject);
begin
  inherited;
  pnlFieldsResize(Sender)
end;

function TfrmPrintLocation.ClinicText(ALoc: integer): string;
var
  aStr: string;
begin
  CallVistA('ORIMO ISCLOC', [ALoc], aStr);
  if (aStr = '1') then
    Result := LOCATION_CHANGE_2
  else
    Result := LOCATION_CHANGE_2W;
end;

procedure TfrmPrintLocation.OrderGridDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  inherited;
  OrderGrid.Canvas.TextRect(Rect, Rect.Left+2, Rect.Top+2,
    Piece(OrderGrid.Cells[ACol, ARow], TAB, 1));
end;

procedure TfrmPrintLocation.orderGridKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if CharInSet(Key, [#32..#127]) then ShowEditor(OrderGrid.Col, OrderGrid.Row, Key);
end;

procedure TfrmPrintLocation.orderGridMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ACol, ARow: Integer;
begin
  inherited;
  OrderGrid.MouseToCell(X, Y, ACol, ARow);
  if (ARow < 0) or (ACol < 0) then Exit;
  if ACol > COL_ORDERINFO then ShowEditor(ACol, ARow, #0) else
  begin
    OrderGrid.Col := COL_ORDERTEXT;
    OrderGrid.Row := ARow;
  end;
  //if OrderGrid.Col <> COL_ORDERTEXT then
    //DropLastSequence;
end;


procedure TfrmPrintLocation.pnlFieldsResize(Sender: TObject);
Const
  REL_ORDER = 0.85;
  REL_LOCATION   = 0.15;
var
  i, center, diff, ht, RowCountShowing: Integer;
  ColControl: TWinControl;
begin
  inherited;
    if frmPrintLocation = nil then exit;
    with frmPrintLocation do
      begin
        if (frmPrintLocation.WLoc = '') and (frmPrintLocation.CLoc = '') then exit;
        lblText.Caption := LOCATION_CHANGE_1 + ': ' + frmPrintLocation.WLoc + CRLF;
        if frmPrintLocation.DisplayOrders = false then
          begin
            if frmPrintlocation.CLoc = '' then
              begin
                lblText.Caption := LOCATION_CHANGE_4 + frmPrintLocation.WLoc + CRLF;
                cboEncLoc.Enabled := false;
                lblEncounter.Enabled := false;
              end
            else lblText.Caption := lblText.Caption + ClinicText(frmPrintLocation.CIEN) + ': ' + frmPrintLocation.CLoc + CRLF;
            btnClinic.Visible := false;
            btnWard.Visible := false;
            pnlTop.Height := lbltext.Top + lbltext.Height * 2;
            pnlbottom.Top := pnltop.Top + pnltop.Height + 3;
            ordergrid.Height := 1;
            pnlBottom.Height := 1;
            lblEncounter.Top := pnlBottom.Top + pnlBottom.Height;
            cboEncLoc.Top := lblEncounter.Top;
            cboEncLoc.Left := lblEncounter.Left + lblEncounter.Width + 4;
            orpnlBottom.Top := cboEncLoc.Top + cboEncLoc.Height +10;
          end
        else
          begin
            lblText.Caption := lblText.Caption + ClinicText(frmPrintLocation.CIEN) + ': ' + frmPrintLocation.CLoc + CRLF + CRLF;
            lblText.Caption := lblText.Caption + LOCATION_CHANGE_3;
            //lblText.Caption := lblText.Caption + CRLF + 'One clinic location allowed; ' + frmPrintLocation.CLoc + ' will be used';
            btnClinic.Caption := 'All ' + frmPrintLocation.CLoc;
            btnWard.Caption := 'All ' + frmPrintLocation.WLoc;
            btnClinic.Width := TextWidthByFont(btnClinic.Handle, btnClinic.Caption);
            btnWard.Width := TextWidthByFont(btnWard.Handle, btnWard.Caption);
            center := frmPrintLocation.Width div 2;
            btnClinic.Left := center - (btnClinic.Width + 3);
            btnWard.Left := center + 3;
          end;
        if pnlTop.Width > width then
          begin
            pnltop.Width := width - 8;
            orpnlTopBottom.Width := pnltop.Width;
          end;
        if orpnlTopBottom.Width > pnltop.Width then orpnlTopBottom.Width := pnltop.Width;

        if pnlBottom.Width > width then
          begin
            pnlBottom.Width := width - 8;
            ordergrid.Width := pnlBottom.Width - 2;
          end;
        if orderGrid.Width > pnlBottom.Width then orderGrid.Width := pnlBottom.Width - 2;
        if frmPrintLocation.DisplayOrders = true then
          begin
            i := OrderGrid.Width - 12;
            i := i - GetSystemMetrics(SM_CXVSCROLL);
            orderGrid.ColWidths[0] := 0;
            orderGrid.ColWidths[1] := Round(REL_ORDER * i);
            orderGrid.ColWidths[2] := Round(REL_LOCATION * i);
            orderGrid.Cells[1,0] := 'Order';
            orderGrid.Cells[2,0] := 'Location';
            cboEncLoc.Left := lblEncounter.Left + lblEncounter.Width + 4;
            ht := pnlBottom.Top - orderGrid.Top - 6;
            ht := ht div (orderGrid.DefaultRowHeight+1);
            ht := ht * (orderGrid.DefaultRowHeight+1);
            Inc(ht, 3);
            OrderGrid.Height := ht;
            ColControl := nil;
            Case OrderGrid.Col of
              COL_ORDERTEXT:ColCOntrol := pnlOrder;
              COL_LOCATION:ColControl := cboLocation;
            End;
            if assigned(ColControl) and ColControl.Showing then
              begin
                RowCountShowing := (Height - 25) div (orderGrid.defaultRowHeight+1);
                if (OrderGrid.Row <= RowCountShowing) then
                  ShowEditor(OrderGrid.Col, orderGrid.Row, #0)
                else
                  ColControl.Hide;
              end;
          end;
          diff := frmPrintLocation.btnOK.top;
          //diff := (frmPrintLocation.ORpnlBottom.Top + frmPrintlocation.btnOK.Top) - frmPrintLocation.ORpnlBottom.Top;
          frmPrintLocation.ORpnlBottom.Height := frmPrintLocation.btnOK.Top + frmPrintLocation.btnOK.Height + diff;
          frmprintLocation.Height := frmprintLocation.orpnlBottom.Top + frmprintLocation.orpnlBottom.Height + 25;
      end;
end;


class procedure TfrmPrintLocation.PrintLocation(OrderLst: TStringList; pEncounterLoc:integer; pEncounterLocName,
          pEncounterLocText: string; pEncounterDT: TFMDateTime; pEncounterVC: Char;
          var ClinicLst, WardLst: TStringList; var wardIEN: integer; var wardLocation: string;
          ContainsIMOOrders: boolean; displayEncSwitch: boolean = false);
var
ASvc, OrderInfo, OrderText: string;
cidx, i, widx, count: integer;
begin
  frmPrintLocation := TfrmPrintLocation.Create(Application);
  try
  count := 0;
  frmPrintLocation.DisplayOrders := true;
  frmPrintLocation.CloseOK := false;
  KillObj(@ClinicArr);
  KillObj(@WardArr);
  ClinicArr := TStringList.Create;
  WardArr := TStringList.Create;
  CurrentLocationForPatient(Patient.DFN, WardIEN, WardLocation, ASvc);
  frmPrintLocation.lblEncounter.Enabled := displayEncSwitch;
  frmPrintLocation.cboEncLoc.Enabled := displayEncSwitch;
  frmPrintLocation.Cloc := pEncounterLocName;
  frmPrintLocation.WLoc := WardLocation;
  frmPrintLocation.CIEN := pEncounterLoc;
  frmPrintLocation.WIEN := wardIEN;
  ResizeAnchoredFormToFont(frmPrintLocation);
  frmPrintLocation.orderGrid.DefaultRowHeight := frmPrintLocation.cbolocation.Height;
  for i := 0 to OrderLst.Count - 1 do
    begin
    OrderInfo := Piece(OrderLst.Strings[i],':',1);
    if frmPrintLocation.rpcIsClinicOrder(OrderInfo)='0' then
      begin
      count := count+1;
      frmPrintlocation.orderGrid.RowCount := count + 1;
      OrderText := AnsiReplaceText(Piece(OrderLst.Strings[i],':',2),CRLF,'');
      frmPrintLocation.orderGrid.Cells[COL_ORDERINFO,count] := OrderInfo;
      frmPrintLocation.orderGrid.Cells[COL_ORDERTEXT,count] := OrderText;
      end
    else
      begin
      ClinicLst.Add(OrderInfo);
      end;
    end;

  frmPrintlocation.orderGrid.RowCount := count + 1;
  frmPrintLocation.cbolocation.Items.Add(frmPrintLocation.CLoc);
  frmPrintLocation.cbolocation.Items.Add(frmPrintLocation.WLoc);
  if frmPrintLocation.cboEncLoc.Enabled = True then
    begin
      frmPrintLocation.cboEncLoc.Items.Add(frmPrintLocation.CLoc);
      frmPrintLocation.cboEncLoc.Items.Add(frmPrintLocation.WLoc);
    end;
  if count>0 then frmPrintLocation.ShowModal;
  if assigned(ClinicArr) then ClinicLst.AddStrings(ClinicArr);
  if assigned(WardArr) then WardLst.AddStrings(WardArr);
  frmPrintLocation.ProcessClinicOrders(WardLst, ClinicLst, WardIEN, pEncounterLoc, ContainsIMOOrders);
  cidx := frmPrintLocation.cboEncLoc.Items.IndexOf(frmPrintLocation.CLoc);
  widx := frmPrintLocation.cboEncLoc.Items.IndexOf(frmPrintLocation.WLoc);
  if frmPrintLocation.cboEncLoc.ItemIndex = cidx then
    begin
      uCore.Encounter.EncounterSwitch(pEncounterLoc, pEncounterLocName, pEncounterLocText, pEncounterDT, pEncounterVC);
      fframe.frmFrame.DisplayEncounterText;
      fframe.frmFrame.OrderPrintForm := True;
    end
  else if frmPrintLocation.cboEncLoc.ItemIndex = widx then
    begin
    uCore.Encounter.EncounterSwitch(WardIEN, WardLocation, WardLocation, Patient.AdmitTime, 'H');
      fFrame.frmFrame.DisplayEncounterText;
    end;
  finally
   frmPrintLocation.Destroy;
  end;
end;

procedure TfrmPrintLocation.ProcessClinicOrders(WardList, ClinicList: TStringList;
  WardIEN, ClinicIEN: integer; ContainsIMO: boolean);
var
i: integer;
OrderArr: TStringList;
begin
   OrderArr := TStringList.Create;
   for i := 0 to WardList.Count -1 do
     begin
       OrderArr.Add(WardList.Strings[i] + U + InttoStr(WardIen));
     end;
   for i := 0 to ClinicList.Count -1 do
     begin
       OrderArr.Add(ClinicList.Strings[i] + U + InttoStr(ClinicIen));
     end;
   rpcChangeOrderLocation(OrderArr, ContainsIMO);
   KillObj(@WardArr);
end;


procedure TfrmPrintLocation.rpcChangeOrderLocation(pOrderList:TStringList; ContainsIMO: boolean);
var
IMO: string;
begin
  // OrderIEN^Location^ISIMO  -- used to alter location if ward is selected.
  if ContainsIMO = True then
    IMO := '1'
  else
    IMO := '0';
  CallVistA('ORWDX CHANGE',[pOrderList, Patient.DFN, IMO]);
end;


class function TfrmPrintLocation.rpcIsPatientOnWard(Patient: string): string;
begin
  // Ward Loction Name^Ward Location IEN
  CallVistA('ORWDX1 PATWARD', [Patient], Result);
end;


class function TfrmPrintLocation.rpcIsClinicOrder(IEN: string): string;
begin
  CallVistA('ORUTL ISCLORD', [IEN], Result);
end;

procedure TfrmPrintLocation.ShowEditor(ACol, ARow: Integer; AChar: Char);
var
  tmpText: string;

  procedure PlaceControl(AControl: TWinControl);
  var
    ARect: TRect;
  begin
    with AControl do
    begin
      ARect := OrderGrid.CellRect(ACol, ARow);
      SetBounds(ARect.Left + OrderGrid.Left + 1,  ARect.Top  + OrderGrid.Top + 1,
                ARect.Right - ARect.Left + 1,    ARect.Bottom - ARect.Top + 1);
      Tag := ARow;
      BringToFront;
      Show;
      SetFocus;
    end;
  end;

  procedure SynchCombo(ACombo: TORComboBox; const ItemText, EditText: string);
  var
    i: Integer;
  begin
    ACombo.ItemIndex := -1;
    for i := 0 to Pred(ACombo.Items.Count) do
      if ACombo.Items[i] = ItemText then ACombo.ItemIndex := i;
    if ACombo.ItemIndex < 0 then ACombo.Text := EditText;
  end;

begin
  inherited;
  if ARow = 0 then Exit;
  Case ACol of
  COL_LOCATION: begin
                  TmpText := ValFor(COL_Location, ARow);
                  SynchCombo(cboLocation, tmpText, tmpText);
                  PlaceControl(cboLocation);
                end;
  end;

end;

class procedure TfrmPrintLocation.SwitchEncounterLoction(pEncounterLoc: integer; pEncounterLocName, pEncounterLocText: string;
                              pEncounterDT: TFMDateTime; pEncounterVC: Char);
var
cidx, widx, WardIEN: integer;
Asvc, WardLocation: string;
begin
  frmPrintLocation := TfrmPrintLocation.Create(Application);
  try
  frmPrintLocation.DisplayOrders := false;
  frmPrintLocation.CloseOK := false;
  CurrentLocationForPatient(Patient.DFN, WardIEN, WardLocation, ASvc);
  frmPrintLocation.lblEncounter.Enabled := True;
  frmPrintLocation.cboEncLoc.Enabled := True;
  frmPrintLocation.Cloc := pEncounterLocName;
  frmPrintLocation.WLoc := WardLocation;
  frmPrintLocation.CIEN := pEncounterLoc;
  frmPrintLocation.WIEN := wardIEN;
  ResizeAnchoredFormToFont(frmPrintLocation);
  frmPrintLocation.cboEncLoc.Items.Add(frmPrintLocation.CLoc);
  frmPrintLocation.cboEncLoc.Items.Add(frmPrintLocation.WLoc);
  frmPrintLocation.Caption := 'Refresh Encounter Location Form';
  frmPrintLocation.ShowModal;
  cidx := frmPrintLocation.cboEncLoc.Items.IndexOf(frmPrintLocation.CLoc);
  widx := frmPrintLocation.cboEncLoc.Items.IndexOf(frmPrintLocation.WLoc);
  if frmPrintLocation.cboEncLoc.Enabled = FALSE then frmPrintLocation.cboEncLoc.ItemIndex := widx;

  if frmPrintLocation.cboEncLoc.ItemIndex = cidx then
    begin
      Encounter.Location := pEncounterLoc;
      Encounter.LocationName := pEncounterLocName;
      Encounter.LocationText := pEncounterLocText;
      fframe.frmFrame.DisplayEncounterText;
    end
  else if frmPrintLocation.cboEncLoc.ItemIndex = widx then
    begin
      uCore.Encounter.EncounterSwitch(WardIEN, WardLocation, '', Patient.AdmitTime, 'H');
      fFrame.frmFrame.DisplayEncounterText;
    end;
  finally
    frmPrintLocation.Destroy;
  end;
end;

function TfrmPrintLocation.ValFor(FieldID, ARow: Integer): string;

begin
  Result := '';
  if (ARow < 1) or (ARow >= OrderGrid.RowCount) then Exit;
  with OrderGrid do
    case FieldID of
    COL_ORDERINFO   : Result := Piece(Cells[COL_ORDERINFO,     ARow], TAB, 1);
    COL_ORDERTEXT   : Result := Piece(Cells[COL_ORDERTEXT,     ARow], TAB, 1);
    COL_LOCATION    : Result := Piece(Cells[COL_LOCATION,      ARow], TAB, 1);
    end;
end;

initialization

finalization
  KillObj(@ClinicArr);
  KillObj(@WardArr);

end.
