unit fOrderVw;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, StdCtrls, ComCtrls, ExtCtrls, ORCtrls, ORFn, rOrders, ORDtTm,
  fBase508form, VA508AccessibilityManager;

type
  TfrmOrderView = class(TfrmAutoSz)
    pnlView: TPanel;
    lblView: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    lblFilter: TLabel;
    trFilters: TCaptionTreeView;
    Panel3: TPanel;
    treService: TCaptionTreeView;
    lblService: TLabel;
    Panel4: TPanel;
    chkDateRange: TCheckBox;
    GroupBox1: TGroupBox;
    lblFrom: TLabel;
    lblThru: TLabel;
    calFrom: TORDateBox;
    calThru: TORDateBox;
    chkInvChrono: TCheckBox;
    chkByService: TCheckBox;
    cmdOK: TButton;
    cmdCancel: TButton;
    Splitter1: TSplitter;
    lbl508View: TStaticText;
    procedure FormCreate(Sender: TObject);
    procedure treServiceClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure chkDateRangeClick(Sender: TObject);
    procedure calChange(Sender: TObject);
    procedure trFiltersClick(Sender: TObject);
    procedure Splitter1Moved(Sender: TObject);
    procedure treServiceChange(Sender: TObject; Node: TTreeNode);
    procedure trFiltersChange(Sender: TObject; Node: TTreeNode);
    procedure chkDateRangeEnter(Sender: TObject);
    procedure pnlViewEnter(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FChanged: Boolean;
    FDGroup: Integer;
    FDGroupName: string;
    FFilter: Integer;
    FFilterName: string;
    FInvChrono: Boolean;
    FByService: Boolean;
    FTimeFrom: TFMDateTime;
    FTimeThru: TFMDateTime;
    procedure LoadDGroups(const Parent: string; Node: TTreeNode);
    procedure LoadFilters(const Parent: string; Node: TTreeNode);
    procedure SynchViewData;
    procedure UpdateViewName;
  public
    { Public declarations }
  end;

procedure SelectOrderView(var OrderView: TOrderView);

implementation

{$R *.DFM}

uses
VA508AccessibilityRouter, VAUtils;

const
  TX_DATES = 'To list orders for a specific date range, both From & Thru dates are required.';
  TC_DATES = 'Error in Date Range';

var
  uDGroupList: TStringList;
  uFilterList: TStringList;

procedure SelectOrderView(var OrderView: TOrderView);
var
  frmOrderView: TfrmOrderView;
begin
  frmOrderView := TfrmOrderView.Create(Application);
  try
    ResizeFormToFont(TForm(frmOrderView));
    with frmOrderView do
    begin
      FDGroup    := OrderView.DGroup;
      FFilter    := OrderView.Filter;
      FInvChrono := OrderView.InvChrono;
      FByService := OrderView.ByService;
      FTimeFrom  := OrderView.TimeFrom;
      FTimeThru  := OrderView.TimeThru;
      SynchViewData;
      ShowModal;
      if FChanged then
      begin
        OrderView.Changed   := FChanged;
        OrderView.DGroup    := FDGroup;
        OrderView.Filter    := FFilter;
        OrderView.InvChrono := FInvChrono;
        OrderView.ByService := FByService;
        OrderView.TimeFrom  := FTimeFrom;
        OrderView.TimeThru  := FTimeThru;
        OrderView.CtxtTime  := 0;                // set by RefreshOrderList
        OrderView.TextView  := 0;                // set by RefreshOrderList
        OrderView.ViewName  := lblView.Caption;
        OrderView.EventDelay.EventType := 'C';
        OrderView.EventDelay.Specialty := 0;     // treating specialty only for event delayed
        OrderView.EventDelay.Effective := 0;     // effective date only for discharge orders
      end
      else OrderView.Changed := False;
    end; {with}
  finally
    frmOrderView.Release;
  end;
end;

procedure TfrmOrderView.FormCreate(Sender: TObject);
var
  IsScreenReaderActive: Boolean;
begin
  inherited;
  FChanged := False;
  uDGroupList  := TStringList.Create;
  uFilterList := TStringList.Create;
  try
    ListDGroupAll(uDGroupList);
    LoadDGroups('0', nil);

    ListOrderFiltersAll(uFilterList);
    LoadFilters('0', nil);
  finally
    uDGroupList.Free;
    uDGroupList := nil;
    uFilterList.Free;
    uFilterList := nil;    
  end;
  IsScreenReaderActive := ScreenReaderActive;
  //lbl508View.Enabled := IsScreenReaderActive;
  lbl508View.Visible := IsScreenReaderActive;
  pnlView.TabStop := IsScreenReaderActive;
  lbl508View.TabStop := IsScreenReaderActive;
  lblView.Visible := not IsScreenReaderActive;
  //lblView.Enabled := not IsScreenReaderActive;
end;

procedure TfrmOrderView.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if pnlView.Focused then
  begin
    if (Key = VK_TAB) then
    begin
      if ssShift in Shift then
      begin
        cmdCancel.SetFocus(); //Force back to Cancel button instead of focus on pnlView
        Key := 0;
      end;
    end;
  end;
end;

procedure TfrmOrderView.UpdateViewName;
const
  FMT_TIME = 'ddddd';
var
  DateText, FilterText: string;
begin
  if chkDateRange.Checked
    then DateText := ' ('     + FormatFMDateTime(FMT_TIME, calFrom.FMDateTime) +
                     ' thru ' + FormatFMDateTIme(FMT_TIME, calThru.FMDateTime) + ')'
    else DateText := '';
  if FFilter in [6, 8, 9, 10, 19, 20]
    then FilterText := FFilterName
    else FilterText := FFilterName + ' Orders';
  lblView.Caption := FilterText + ' - ' + FDGroupName + DateText;
  lbl508View.Caption := lblView.Caption;
end;

procedure TfrmOrderView.SynchViewData;
var
  i: Integer;
begin
  with treService.Items do for i := 0 to Count - 1 do if Integer(Item[i].Data) = FDGroup then
  begin
    Item[i].Expanded := True;
    Item[i].Selected := True;
    FDGroupName := Item[i].Text;
    Break;
  end;

  with trFilters.Items do for i := 0 to Count - 1 do if Integer(Item[i].Data) = FFilter then
  begin
    Item[i].Expanded := True;
    Item[i].Selected := True;
    FFilter := Integer(Item[i].Data);
    FFilterName := Item[i].Text;
    Break;
  end;

  if (FTimeFrom > 0) or (FTimeThru > 0) then
  begin
    calFrom.FMDateTime := FTimeFrom;
    calThru.FMDateTime := FTimeThru;
    chkDateRange.Checked := True;
    chkDateRangeClick(Self);
  end;
  UpdateViewName;
  chkByService.Checked := FByService;
  chkInvChrono.Checked := FInvChrono;
end;

procedure TfrmOrderView.LoadDGroups(const Parent: string; Node: TTreeNode);
var
  MyID, MyParent, Name: string;
  i, IEN: Integer;
  ChildNode: TTreeNode;
  HasChildren: Boolean;
begin
  with uDGroupList do for i := 0 to Count - 1 do
  begin
    MyParent := Piece(Strings[i], U, 3);
    if MyParent = Parent then
    begin
      MyID := Piece(Strings[i], U, 1);
      IEN  := StrToIntDef(MyID, 0);
      Name := Piece(Strings[i], U, 2);
      HasChildren := Piece(Strings[i], U, 4) = '+';
      ChildNode := treService.Items.AddChildObject(Node, Name, Pointer(IEN));
      if HasChildren then LoadDGroups(MyID, ChildNode);
    end;
  end;
end;

procedure TfrmOrderView.LoadFilters(const Parent: string; Node: TTreeNode);
var
  MyID, MyParent, Name: string;
  i, IEN: Integer;
  ChildNode: TTreeNode;
  HasChildren: Boolean;
begin
  with uFilterList do for i := 0 to Count - 1 do
  begin
    MyParent := Piece(Strings[i], U, 3);
    if MyParent = Parent then
    begin
      MyID := Piece(Strings[i], U, 1);
      IEN  := StrToIntDef(MyID, 0);
      Name := Piece(Strings[i], U, 2);
      HasChildren := Piece(Strings[i], U, 4) = '+';
      ChildNode := trFilters.Items.AddChildObject(Node, Name, Pointer(IEN));
      if HasChildren then LoadFilters(MyID, ChildNode);
    end;
  end;
end;

procedure TfrmOrderView.pnlViewEnter(Sender: TObject);
begin
  inherited;
  lbl508View.SetFocus;
end;

procedure TfrmOrderView.treServiceChange(Sender: TObject; Node: TTreeNode);
begin
  inherited;
  treServiceClick(Sender);
end;

procedure TfrmOrderView.treServiceClick(Sender: TObject);
var
  Node: TTreeNode;
begin
  inherited;
  Node := treService.Selected;
  if Node <> nil then
  begin
    FDGroup := Integer(Node.Data);
    FDGroupName := Node.Text;
    UpdateViewName;
  end;
end;

procedure TfrmOrderView.chkDateRangeClick(Sender: TObject);
begin
  inherited;
  lblThru.Enabled := chkDateRange.Checked;
  calThru.Enabled := chkDateRange.Checked;
  lblFrom.Enabled := chkDateRange.Checked;
  calFrom.Enabled := chkDateRange.Checked;
  if chkDateRange.Checked then
  begin
    calFrom.Color := clWindow;
    calThru.Color := clWindow;
    if calThru.FMDateTime = 0 then calThru.Text := 'NOW';
  end else
  begin
    calFrom.FMDateTime := 0;
    calThru.FMDateTime := 0;
    calFrom.Color := clBtnFace;
    calThru.Color := clBtnFace;
  end;
  UpdateViewName;
end;

procedure TfrmOrderView.chkDateRangeEnter(Sender: TObject);
begin
  inherited;
  if chkDateRange.Checked = False then
    amgrMain.AccessData.Items[7].AccessText := 'Only List Orders Placed During Time Period. Date fields hidden until checked.'
  else amgrMain.AccessData.Items[7].AccessText := 'Only List Orders Placed During Time Period.'
end;

procedure TfrmOrderView.calChange(Sender: TObject);
begin
  inherited;
  UpdateViewName;
end;

procedure TfrmOrderView.cmdOKClick(Sender: TObject);
begin
  inherited;
  if chkDateRange.Checked and ((not calFrom.IsValid) or (not calThru.IsValid)) then
  begin
    InfoBox(TX_DATES, TC_DATES, MB_OK);
    Exit;
  end;
  if chkDateRange.Checked then
  begin
    FTimeFrom := calFrom.FMDateTime;
    FTimeThru := calThru.FMDateTime;
  end else
  begin
    FTimeFrom := 0;
    FTimeThru := 0;
  end;
  FChanged := True;
  FInvChrono := chkInvChrono.Checked;
  FByService := chkByService.Checked;
  Close;
end;

procedure TfrmOrderView.cmdCancelClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TfrmOrderView.trFiltersChange(Sender: TObject; Node: TTreeNode);
begin
  inherited;
  trFiltersClick(Sender);
end;

procedure TfrmOrderView.trFiltersClick(Sender: TObject);
var
  Node: TTreeNode;
begin
  inherited;
  Node := trFilters.Selected;
  if Node <> nil then
  begin
    FFilter := Integer(Node.Data);
    FFilterName := Node.Text;
    chkDateRange.Enabled := True;
    if FFilter = 2 then                          // disallow date range for active orders view
    begin
      chkDateRange.Checked := False;
      chkDateRangeClick(Self);
    end;
    if FFilter = 5 then                          // disallow date range for expiring orders view
    begin
      chkDateRange.Checked := False;
      chkDateRangeClick(Self);
      chkDateRange.Enabled := False;
    end;
    if FFilter in [8, 9, 10, 20] then chkDateRange.Checked := True else
    begin
      if (calFrom.Text = '') and (calThru.Text = '') then chkDateRange.Checked := False;
    end;
    UpdateViewName;
  end;
end;

procedure TfrmOrderView.Splitter1Moved(Sender: TObject);
begin
  inherited;
  Splitter1.Align := alNone;
  Splitter1.Align := alLeft;
end;

end.
