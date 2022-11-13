unit fOptionsReminders;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ORCtrls, OrFn, fBase508Form, VA508AccessibilityManager,
  Vcl.Buttons;

type
  TfrmOptionsReminders = class(TfrmBase508Form)
    pnlBottom: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    lstDisplayed: TORListBox;
    lstNotDisplayed: TORListBox;
    lblDisplayed: TLabel;
    lblNotDisplayed: TLabel;
    bvlBottom: TBevel;
    radSort: TRadioGroup;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    btnAdd: TBitBtn;
    btnDelete: TBitBtn;
    btnUp: TBitBtn;
    btnDown: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure lstDisplayedChange(Sender: TObject);
    procedure lstNotDisplayedChange(Sender: TObject);
    procedure btnUpClick(Sender: TObject);
    procedure btnDownClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    function GetFirstSelection(aList: TORListBox): integer;
    procedure SetItem(aList: TORListBox; index: integer);
    procedure MoveSelected(aList: TORListBox; items: TStrings);
    procedure btnOKClick(Sender: TObject);
    procedure radSortClick(Sender: TObject);
  private
    { Private declarations }
    procedure CheckEnable;
  public
    { Public declarations }
  end;

var
  frmOptionsReminders: TfrmOptionsReminders;

procedure DialogOptionsReminders(topvalue, leftvalue, fontsize: integer; var actiontype: Integer);

implementation

uses rOptions, fRemCoverSheet, rReminders, VAUtils;

{$R *.DFM}

procedure DialogOptionsReminders(topvalue, leftvalue, fontsize: integer; var actiontype: Integer);
// create the form and make it modal, return an action
var
  frmOptionsReminders: TfrmOptionsReminders;
begin
  if NewRemCoverSheetListActive then
    EditCoverSheetReminderList(TRUE)
  else
  begin
    frmOptionsReminders := TfrmOptionsReminders.Create(Application);
    actiontype := 0;
    try
      with frmOptionsReminders do
      begin
        if (topvalue < 0) or (leftvalue < 0) then
          Position := poScreenCenter
        else
        begin
          Position := poDesigned;
          Top := topvalue;
          Left := leftvalue;
        end;
        ResizeAnchoredFormToFont(frmOptionsReminders);
        ShowModal;
        actiontype := btnOK.Tag;
      end;
    finally
      frmOptionsReminders.Release;
    end;
  end;
end;

procedure TfrmOptionsReminders.FormCreate(Sender: TObject);
var
  i: integer;
  biglist, userlist: TStringList;
begin
  biglist := TStringList.Create;
  userlist := TStringList.Create;
  try
    rpcGetReminders(biglist);
    for i := 0 to biglist.Count - 1 do
      if strtointdef(Piece(biglist[i], '^', 2), 0) > 0 then
        userlist.Add(biglist[i])
      else
        lstNotDisplayed.Items.Add(biglist[i]);
    SortByPiece(userlist, '^', 2);
    for i := 0 to userlist.Count - 1 do
      lstDisplayed.Items.Add(userlist[i]);
  finally
    biglist.free;
    userlist.free;
  end;
  CheckEnable;
end;

procedure TfrmOptionsReminders.CheckEnable;
// allow buttons to be enabled or not depending on selections
begin
  with lstDisplayed do
  begin
    if Items.Count > 0 then
    begin
      if SelCount > 0 then
      begin
        btnUp.Enabled     := (SelCount > 0)
                             and (not Selected[0])
                             and (radSort.ItemIndex = 0);
        btnDown.Enabled   := (SelCount > 0)
                             and (not Selected[Items.Count - 1])
                             and (radSort.ItemIndex = 0);
        btnDelete.Enabled := true;
      end
      else
      begin
        btnUp.Enabled     := false;
        btnDown.Enabled   := false;
        btnDelete.Enabled := false;
      end;
    end
    else
    begin
      btnUp.Enabled     := false;
      btnDown.Enabled   := false;
      btnDelete.Enabled := false;
    end;
  end;
  with lstNotDisplayed do
  begin
    btnAdd.Enabled := SelCount > 0;
  end;
end;

procedure TfrmOptionsReminders.lstDisplayedChange(Sender: TObject);
begin
  CheckEnable;
end;

procedure TfrmOptionsReminders.lstNotDisplayedChange(Sender: TObject);
begin
  CheckEnable;
end;

procedure TfrmOptionsReminders.btnUpClick(Sender: TObject);
var
  newindex, i: integer;
begin
  with lstDisplayed do
  begin
    i := 0;
    while i < Items.Count do
    begin
      if Selected[i] then
      begin
        newindex := i - 1;
        Items.Move(i, newindex);
        Selected[newindex] := true;
      end;
      inc(i);
    end;
  end;
  lstDisplayedChange(self);
end;

procedure TfrmOptionsReminders.btnDownClick(Sender: TObject);
var
  newindex, i: integer;
begin
  with lstDisplayed do
  begin
    i := Items.Count - 1;
    while i > -1 do
    begin
      if Selected[i] then
      begin
        newindex := i + 1;
        Items.Move(i, newindex);
        Selected[newindex] := true;
      end;
      dec(i);
    end;
  end;
  lstDisplayedChange(self);
end;

procedure TfrmOptionsReminders.btnDeleteClick(Sender: TObject);
var
  index: integer;
begin
  index := GetFirstSelection(lstDisplayed);
  MoveSelected(lstDisplayed, lstNotDisplayed.Items);
  SetItem(lstDisplayed, index);
  CheckEnable;
end;

procedure TfrmOptionsReminders.btnAddClick(Sender: TObject);
var
  index: integer;
begin
  index := GetFirstSelection(lstNotDisplayed);
  MoveSelected(lstNotDisplayed, lstDisplayed.Items);
  SetItem(lstNotDisplayed, index);
  if radSort.ItemIndex = 1 then radSortClick(self);
  CheckEnable;
end;

function TfrmOptionsReminders.GetFirstSelection(aList: TORListBox): integer;
begin
  for result := 0 to aList.Items.Count - 1 do
    if aList.Selected[result] then exit;
  result := LB_ERR;
end;

procedure TfrmOptionsReminders.SetItem(aList: TORListBox; index: integer);
var
  maxindex: integer;
begin
  with aList do
  begin
    SetFocus;
    maxindex := aList.Items.Count - 1;
    if Index = LB_ERR then
      Index := 0
    else if Index > maxindex then Index := maxindex;
    Selected[index] := true;
  end;
  CheckEnable;  
end;

procedure TfrmOptionsReminders.MoveSelected(aList: TORListBox; Items: TStrings);
var
  i: integer;
begin
  for i := aList.Items.Count - 1 downto 0 do
  begin
    if aList.Selected[i] then
    begin
      Items.AddObject(aList.Items[i], aList.Items.Objects[i]);
      aList.Items.Delete(i);
    end;
  end;
end;

procedure TfrmOptionsReminders.btnOKClick(Sender: TObject);
var
  i: integer;
  values: string;
  aList: TStringList;
begin
  aList := TStringList.Create;
  try
    with lstDisplayed do
    for i := 0 to Items.Count - 1 do
    begin
      values := inttostr(i + 1) + '^' + Piece(Items[i], '^', 1);
      aList.Add(values);
    end;
    rpcSetReminders(aList);
  finally
    aList.free;
  end;
end;

procedure TfrmOptionsReminders.radSortClick(Sender: TObject);
var
  i: integer;
  userlist: TStringList;
begin
  userlist := TStringList.Create;
  try
    for i := 0 to lstDisplayed.Items.Count - 1 do
      userlist.Add(lstDisplayed.Items[i]);
    case radSort.ItemIndex of
      0: SortByPiece(userlist, '^', 2);
      else SortByPiece(userlist, '^', 3);
    end;
    lstDisplayed.Items.Clear;
    for i := 0 to userlist.Count - 1 do
      lstDisplayed.Items.Add(userlist[i]);
  finally
    userlist.free;
  end;
  CheckEnable;
end;

end.
