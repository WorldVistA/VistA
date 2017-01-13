unit mRadioListView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ImgList, Vcl.ComCtrls, ORFn;

type
  TRadioLVFrame = class(TFrame)
    lvRadioList: TListView;
    imgRadioButtons: TImageList;
    procedure lvRadioListClick(Sender: TObject);
    procedure lvRadioListChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure lvRadioListSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
  private
    { Private declarations }
    FCode: String;
    FSelectedGroup: TListGroup;
    procedure ClearGroupButtons;
    procedure ClearItemButtons;
//    procedure GroupSelect(GroupID: Integer);
  public
    { Public declarations }
    procedure SetRadioListViewModel(ResultSet: TStrings);
    property Code: String read FCode;
  end;

implementation

{$R *.dfm}

const
  lsNotSelected = 0;
  lsSelected = 1;
  lsNonSelectable = -1;

procedure TRadioLVFrame.ClearGroupButtons;
var
  lgs: TListGroups;
  lgi: Integer;
begin
  lgs := lvRadioList.Groups;

  for lgi := 0 to (TCollection(lgs).Count - 1) do
    if lgs[lgi].TitleImage <> lsNonSelectable then
         lgs[lgi].TitleImage := lsNotSelected;
end;

procedure TRadioLVFrame.ClearItemButtons;
var
  lii : TListItem;
begin
  for lii in lvRadioList.Items do
    if lii.StateIndex <> lsNonSelectable then
      lii.StateIndex := lsNotSelected;
end;

{procedure TRadioLVFrame.GroupSelect(GroupID: Integer);
var
  i: Integer;
begin
  for i := 0 to lvRadioList.Items.Count - 1 do
  begin
    if (GroupID = lvRadioList.Items[i].GroupID) and not lvRadioList.Items[i].Selected then
    begin
      lvRadioList.Items[i].Selected := true;
    end;
  end;
end;}

procedure TRadioLVFrame.lvRadioListChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  // OnChange
end;

procedure TRadioLVFrame.lvRadioListClick(Sender: TObject);
var
  hts: THitTests;
  lvCursorPos: TPoint;
  li: TListItem;
begin
  inherited;
   //position of the mouse cursor related to ListView
   lvCursorPos := lvRadioList.ScreenToClient(Mouse.CursorPos) ;

   //click where?
   hts := lvRadioList.GetHitTestInfoAt(lvCursorPos.X, lvCursorPos.Y);

   //locate the state-clicked item
   if (htOnStateIcon in hts) or (htOnItem in hts) then
   begin
     li := lvRadioList.GetItemAt(lvCursorPos.X, lvCursorPos.Y);
     if Assigned(li) then
     begin
       if li.StateIndex = lsNonSelectable then
         Exit;

       ClearItemButtons;

       li.StateIndex := lsSelected;
     end;
   end;
end;

procedure TRadioLVFrame.lvRadioListSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
var
  lgid: Integer;
  lg: TListGroup;
begin
  if lvRadioList.GroupView then
  begin
    lgid := Item.GroupID;
    lg := lvRadioList.Groups[lgid];
    if lg.TitleImage = lsNonSelectable then
      Exit;

    ClearGroupButtons;
    if (lg <> FSelectedGroup) then
    begin
      FCode := '';
      FSelectedGroup := lg;
    end;
    lg.TitleImage := lsSelected;
  end;
  if (Item.SubItems[0] <> '') then
  begin
    if FCode = '' then
      FCode := Item.SubItems[0]
    else
      FCode := Item.SubItems[0] + '/' + FCode;
  end;
end;

procedure TRadioLVFrame.SetRadioListViewModel(ResultSet: TStrings);
var
  i, gid: Integer;
  Item: TListItem;
  Group: TListGroup;
  RecStr: String;

function FindGroup(gid: Integer): TListGroup;
var
  i: integer;
begin
  for i := 0 to lvRadioList.Groups.Count - 1 do
    if lvRadioList.Groups[i].GroupID = gid then
    begin
      result := lvRadioList.Groups[i];
      Exit;
    end;
  result := nil;
end;

begin
  lvRadioList.Items.Clear;
  lvRadioList.Groups.Clear;
  FCode := '';

  // loop through ResultSet and create groups
  for i := 0 to ResultSet.Count - 1 do
  begin
    RecStr := ResultSet[i];
    Item := lvRadioList.Items.Add;
    Item.ImageIndex := 0;
    Item.StateIndex := -1;
    Item.Caption := piece(RecStr, '^', 2);
    Item.SubItems.Add(piece(RecStr, '^', 3));
    gid := -1;
    if (Piece(RecStr, '^', 1) <> '') then
      gid := StrToInt(Piece(RecStr, '^', 1)) - 1;
    if gid > -1 then
    begin
      Group := FindGroup(gid);
      if Group = nil then
      begin
        Group := lvRadioList.Groups.Add;
        Group.GroupID := gid;
        Group.Header := 'Alternative ' + IntToStr(gid + 1);
        Group.TitleImage := 0;
      end;
      Item.GroupID := Group.GroupID;
    end;
  end;
  if lvRadioList.Items.Count = 1 then
    lvRadioList.SelectAll;
end;

end.
