unit fOptionsCombinations;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ORCtrls, OrFn, ComCtrls, fBase508Form,
  VA508AccessibilityManager;

type
  TfrmOptionsCombinations = class(TfrmBase508Form)
    radAddByType: TRadioGroup;
    lblInfo: TMemo;
    lblAddby: TLabel;
    lblCombinations: TLabel;
    lstAddBy: TORComboBox;
    btnAdd: TButton;
    btnRemove: TButton;
    pnlBottom: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    bvlBottom: TBevel;
    lvwCombinations: TCaptionListView;
    procedure radAddByTypeClick(Sender: TObject);
    procedure lstAddByNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure FormCreate(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure lvwCombinationsColumnClick(Sender: TObject;
      Column: TListColumn);
    procedure lvwCombinationsCompare(Sender: TObject; Item1,
      Item2: TListItem; Data: Integer; var Compare: Integer);
    procedure btnRemoveClick(Sender: TObject);
    procedure lstAddByChange(Sender: TObject);
    procedure lstAddByKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnOKClick(Sender: TObject);
    procedure lstAddByEnter(Sender: TObject);
    procedure lstAddByExit(Sender: TObject);
    procedure lvwCombinationsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FsortCol: integer;
    FsortAscending: boolean;
    FDirty: boolean;
    function Duplicate(avalueien, asource: string): boolean;
    procedure LoadCombinations(alist: TStrings);
  public
    { Public declarations }
  end;

var
  frmOptionsCombinations: TfrmOptionsCombinations;

procedure DialogOptionsCombinations(topvalue, leftvalue, fontsize: integer; var actiontype: Integer);

implementation

uses rOptions, rCore, uORLists, uSimilarNames;

{$R *.DFM}

type
  TCombination = class
  public
    IEN: string;
    Entry: string;
    Source: string;
end;

procedure DialogOptionsCombinations(topvalue, leftvalue, fontsize: integer; var actiontype: Integer);
// create the form and make it modal, return an action
var
  frmOptionsCombinations: TfrmOptionsCombinations;
begin
  frmOptionsCombinations := TfrmOptionsCombinations.Create(Application);
  actiontype := 0;
  try
    with frmOptionsCombinations do
    begin
      if (topvalue < 0) or (leftvalue < 0) then
        Position := poScreenCenter
      else
      begin
        Position := poDesigned;
        Top := topvalue;
        Left := leftvalue;
      end;
      ResizeAnchoredFormToFont(frmOptionsCombinations);
      ShowModal;
      actiontype := btnOK.Tag;
    end;
  finally
    frmOptionsCombinations.Release;
  end;
end;

procedure TfrmOptionsCombinations.radAddByTypeClick(Sender: TObject);
begin
  with lstAddBy do
  begin
    case radAddByType.ItemIndex of
      0: begin
           ListItemsOnly := false;
           LongList := false;
           ListWardAll(lstAddBy.Items);
           MixedCaseList(lstAddBy.Items);
           lblAddby.Caption := 'Ward:';
         end;
      1: begin
           ListItemsOnly := true;
           LongList := true;
           InitLongList('');
           lblAddby.Caption := 'Clinic:';
         end;
      2: begin
           ListItemsOnly := true;
           LongList := true;
           InitLongList('');
           lblAddby.Caption := 'Provider:';
         end;
      3: begin
           ListItemsOnly := false;
           LongList := false;
           ListSpecialtyAll(lstAddBy.Items);
           lblAddby.Caption := 'Specialty:';
         end;
      4: begin
           ListItemsOnly := false;
           LongList := false;
           ListTeamAll(lstAddBy.Items);
           lblAddby.Caption := 'List:';
         end;
      5: begin  // TDP - Added 5/27/2014 PCMM team mods
           ListItemsOnly := false;
           LongList := false;
           ListPcmmAll(lstAddBy.Items);
           lblAddby.Caption := 'PCMM:';
         end;
    end;
    lstAddBy.Caption := lblAddby.Caption;
    ItemIndex := -1;
    Text := '';
    btnAdd.Enabled := false;
  end;
end;

procedure TfrmOptionsCombinations.lstAddByNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
begin
  with lstAddBy do
  begin
    case radAddByType.ItemIndex of
      0: begin
           Pieces := '2';
         end;
      1: begin
           Pieces := '2';
           setClinicList(lstAddBy, StartFrom, Direction);
         end;
      2: begin
           Pieces := '2,3';
           setProviderList(lstAddBy, StartFrom, Direction);
         end;
      3: begin
           Pieces := '2';
         end;
      4: begin
           Pieces := '2';
         end;
    end;
  end;
end;

procedure TfrmOptionsCombinations.FormCreate(Sender: TObject);
begin
  radAddByType.ItemIndex := 0;
  radAddByTypeClick(self);
  FDirty := false;
end;

procedure TfrmOptionsCombinations.btnAddClick(Sender: TObject);
var
  aListItem: TListItem;
  aCombination: TCombination;
  valueien, valuename, valuesource, aErrMsg: string;
begin
  if radAddByType.ItemIndex = 2 then
  begin
    if not CheckForSimilarName(lstAddBy, aErrMsg, sPr) then
    begin
      ShowMsgOn(Trim(aErrMsg) <> '' , aErrMsg, 'Invalid Provider');
      exit;
    end;
  end;

  valuesource := radAddByType.Items[radAddByType.ItemIndex];
  if copy(valuesource, 1, 1) = '&' then
    valuesource := copy(valuesource, 2, length(valuesource) - 1);
  // TDP - Added 5/27/2014 to handle PCMM team addition
  if copy(valuesource, 3, 1) = '&' then
    valuesource := copy(valuesource, 1, 2) + copy(valuesource, 4, length(valuesource) - 1);
 { if radAddByType.ItemIndex = 2 then
   valuename := Piece(lstAddBy.DisplayText[lstAddBy.ItemIndex], '-', 1)
  else } //Removed per PTM 274 - should not peice by the "-" at all
   valuename := lstAddBy.DisplayText[lstAddBy.ItemIndex];
  valueien := Piece(lstAddBy.Items[lstAddBy.ItemIndex], '^', 1);
  if Duplicate(valueien, valuesource) then exit; // check for duplicates
  aListItem := lvwCombinations.Items.Add;
  with aListItem do
  begin
    Caption := valuename;
    SubItems.Add(valuesource);
  end;
  aCombination := TCombination.Create;
  with aCombination do
  begin
    IEN := valueien;
    Entry := valuename;
    Source := valuesource;
  end;
  aListItem.SubItems.AddObject('combo object', aCombination);
  btnAdd.Enabled := false;
  FDirty := true;
end;

procedure TfrmOptionsCombinations.lvwCombinationsColumnClick(
  Sender: TObject; Column: TListColumn);
begin
  if FsortCol = Column.Index then
    FsortAscending := not FsortAscending
  else
    FsortAscending := true;
  FsortCol := Column.Index;
  (Sender as TListView).AlphaSort;
end;

procedure TfrmOptionsCombinations.lvwCombinationsCompare(Sender: TObject;
  Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  if not(Sender is TListView) then exit;
  if FsortAscending then
  begin
    if FsortCol = 0 then
      Compare := CompareStr(Item1.Caption, Item2.Caption)
    else
      Compare := CompareStr(Item1.SubItems[FsortCol - 1],
        Item2.SubItems[FsortCol - 1]);
  end
  else
  begin
    if FsortCol = 0 then
      Compare := CompareStr(Item2.Caption, Item1.Caption)
    else
      Compare := CompareStr(Item2.SubItems[FsortCol - 1],
        Item1.SubItems[FsortCol - 1]);
  end;
end;

procedure TfrmOptionsCombinations.btnRemoveClick(Sender: TObject);
var
  i: integer;
begin
  with lvwCombinations do
  for i := Items.Count - 1 downto 0 do
    if Items[i].Selected then
      Items[i].Delete;
  btnRemove.Enabled := false;
  FDirty := true;
end;

procedure TfrmOptionsCombinations.lstAddByChange(Sender: TObject);
var
  valueien, source: string;
begin
  if lstAddBy.ItemIndex = -1 then
    btnAdd.Enabled := false
  else
  begin
    source := radAddByType.Items[radAddByType.ItemIndex];
    if copy(source, 1, 1) = '&' then
      source := copy(source, 2, length(source) - 1);
    // TDP - Added 5/27/2014 to handle PCMM team addition
    if copy(source, 3, 1) = '&' then
      source := copy(source, 1, 2) + copy(source, 4, length(source) - 1);
    valueien := Piece(lstAddBy.Items[lstAddBy.ItemIndex], '^', 1);
    btnAdd.Enabled :=  not Duplicate(valueien, source);
  end;
  btnRemove.Enabled := false;
end;

function TfrmOptionsCombinations.Duplicate(avalueien,
  asource: string): boolean;
var
  i: integer;
  aCombination :TCombination;
begin
  result := false;
  with lvwCombinations do
  for i := 0 to Items.Count - 1 do
    if asource = Items[i].Subitems[0] then
    begin
      aCombination := TCombination(Items.Item[i].SubItems.Objects[1]);
      if aCombination.IEN = avalueien then
      begin
        Result := true;
      end;
    end;
end;

procedure TfrmOptionsCombinations.lstAddByKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = 13 then Perform(WM_NextDlgCtl, 0, 0);
end;

procedure TfrmOptionsCombinations.btnOKClick(Sender: TObject);
var
  i: Integer;
  alist: TStringList;
  aCombination: TCombination;
begin
  if FDirty then
  begin
    alist := TStringList.Create;
    try
      with lvwCombinations do
        for i := 0 to Items.Count - 1 do
        begin
          aCombination := TCombination(Items.Item[i].SubItems.Objects[1]);
          with aCombination do
            alist.Add(IEN + '^' + Source);
        end;
      rpcSetCombo(alist);
    finally
      alist.Free;
    end;
  end;
end;

procedure TfrmOptionsCombinations.lstAddByEnter(Sender: TObject);
begin
  btnAdd.Default := true;
end;

procedure TfrmOptionsCombinations.lstAddByExit(Sender: TObject);
begin
  btnAdd.Default := false;
end;

procedure TfrmOptionsCombinations.lvwCombinationsChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
begin
  btnRemove.Enabled := lvwCombinations.SelCount > 0;
end;

procedure TfrmOptionsCombinations.LoadCombinations(alist: TStrings);
var
  i: integer;
  aListItem: TListItem;
  aCombination: TCombination;
  valueien, valuename, valuesource: string;
begin
  for i := 0 to alist.Count - 1 do
  begin
    valuesource := Piece(alist[i], '^', 1);
    valuename := Piece(alist[i], '^', 2);
    valueien := Piece(alist[i], '^', 3);
    aListItem := lvwCombinations.Items.Add;
    with aListItem do
    begin
      Caption := valuename;
      SubItems.Add(valuesource);
    end;
    aCombination := TCombination.Create;
    with aCombination do
    begin
      IEN := valueien;
      Entry := valuename;
      Source := valuesource;
    end;
    aListItem.SubItems.AddObject('combo object', aCombination);
  end;
end;

procedure TfrmOptionsCombinations.FormShow(Sender: TObject);
var
  aResults: TStringList;
begin
  aResults := TStringList.Create;
  try
    rpcGetCombo(aResults);
    LoadCombinations(aResults);
  finally
    FreeAndNil(aResults);
  end;
end;

end.
