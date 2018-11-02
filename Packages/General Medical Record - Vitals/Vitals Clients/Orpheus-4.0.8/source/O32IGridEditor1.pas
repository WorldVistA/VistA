{*********************************************************}
{*                O32IGRIDEDITOR.PAS 4.06                *}
{*********************************************************}

{* ***** BEGIN LICENSE BLOCK *****                                            *}
{* Version: MPL 1.1                                                           *}
{*                                                                            *}
{* The contents of this file are subject to the Mozilla Public License        *}
{* Version 1.1 (the "License"); you may not use this file except in           *}
{* compliance with the License. You may obtain a copy of the License at       *}
{* http://www.mozilla.org/MPL/                                                *}
{*                                                                            *}
{* Software distributed under the License is distributed on an "AS IS" basis, *}
{* WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License   *}
{* for the specific language governing rights and limitations under the       *}
{* License.                                                                   *}
{*                                                                            *}
{* The Original Code is TurboPower Orpheus                                    *}
{*                                                                            *}
{* The Initial Developer of the Original Code is TurboPower Software          *}
{*                                                                            *}
{* Portions created by TurboPower Software Inc. are Copyright (C)1995-2002    *}
{* TurboPower Software Inc. All Rights Reserved.                              *}
{*                                                                            *}
{* Contributor(s):                                                            *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

unit O32IGridEditor1;

{$I OVC.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, ExtCtrls, checklst, DesignIntf, DesignEditors,
  ovcbase, ovcsc,  o32flxbn,   ovcef, ovcsf, ovccmbx, ovcftcbx, ovcclrcb,
  O32IGrid, Menus;

type
  TIGridCmpEd = class(TForm)
    TreeView1: TTreeView;
    O32FlexButton1: TO32FlexButton;
    OkButton: TButton;
    Label2: TLabel;
    CaptionEdit: TEdit;
    StringPanel: TPanel;
    ParentPanel: TPanel;
    IntegerPanel: TPanel;
    FloatPanel: TPanel;
    ColorPanel: TPanel;
    FontPanel: TPanel;
    ListPanel: TPanel;
    SetPanel: TPanel;
    LogicalPanel: TPanel;
    DatePanel: TPanel;
    CurrencyPanel: TPanel;
    ParentChildCount: TLabel;
    ParentVisibleChildren: TLabel;
    ParentHiddenChildren: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ParentDisplayTextEdit: TEdit;
    Label6: TLabel;
    ItemVisible: TCheckBox;
    Bevel1: TBevel;
    TypeLbl: TLabel;
    SetListBox: TCheckListBox;
    Label8: TLabel;
    SetDisplayText: TLabel;
    Label9: TLabel;
    ListItems: TComboBox;
    StringDisplayText: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    IntegerValue: TOvcSimpleField;
    Label12: TLabel;
    FloatValue: TOvcSimpleField;
    Label13: TLabel;
    CurrencyEdit: TOvcSimpleField;
    Label14: TLabel;
    DatePicker: TDateTimePicker;
    Label15: TLabel;
    Label16: TLabel;
    LogicalValue: TComboBox;
    Label17: TLabel;
    FontCombo: TOvcFontComboBox;
    ColorCombo: TOvcColorComboBox;
    SetItem: TEdit;
    ImageBox: TGroupBox;
    Image1: TImage;
    ClearImageBtn: TSpeedButton;
    OvcSpinner1: TOvcSpinner;
    PopupMenu: TPopupMenu;
    Delete1: TMenuItem;
    procedure OkButtonClick(Sender: TObject);
    procedure O32FlexButton1Click(Sender: TObject; Item: Integer);
    procedure SetChange(Sender: TObject);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure TreeView1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TreeView1KeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure OvcSpinner1Click(Sender: TObject; State: TOvcSpinState;
      Delta: Double; Wrap: Boolean);
    procedure ListItemsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SetListBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SetListBoxClickCheck(Sender: TObject);
    procedure SetItemKeyPress(Sender: TObject; var Key: Char);
    procedure Delete1Click(Sender: TObject);
    procedure ClearImageBtnClick(Sender: TObject);
  private { Private declarations }
    OutlineLoading: Boolean;
    ItemLoading: Boolean;
    Changed: Boolean;
    CurrentItem : TO32InspectorItem;
    procedure LoadOutline;
    procedure LoadChildrenOf(var Index: Integer; Node: TTreeNode);
    procedure LoadItem;
    procedure LoadImage;
    procedure UpdateItem;
    function GetChildCount: Integer;
  public { Public declarations }
    Grid : TO32CustomInspectorGrid;
  end;

  TO32InspectorGridEditor = class(TDefaultEditor)
  public
    procedure ExecuteVerb(Index : Integer); override;
    function GetVerb(Index : Integer) : String; override;
    function GetVerbCount : Integer; override;
  end;

implementation

uses
  OvcUtils, OVCStr;

{$R *.DFM}

procedure EditItems(Dsg : IDesigner; IGrid : TO32CustomInspectorGrid);
begin
  with TIGridCmpEd.Create(Application) do begin
    Grid := IGrid;
    ShowModal;
  end;
end;

{===== TO32InspectorGridEditor =======================================}

procedure TO32InspectorGridEditor.ExecuteVerb(Index: Integer);
begin
  EditItems(Designer, Component as TO32CustomInspectorGrid);
end;
{=====}

function TO32InspectorGridEditor.GetVerb(Index: Integer): String;
begin
  case Index of
    0 : Result := 'Add/Edit Items';
  else
    Result := '?';
  end;
end;
{=====}

function TO32InspectorGridEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;
{=====}



{==== TIGridCmpEd ====================================================}

procedure TIGridCmpEd.OkButtonClick(Sender: TObject);
begin
  if Changed then UpdateItem;
  Close;
end;
{=====}

procedure TIGridCmpEd.O32FlexButton1Click(Sender: TObject; Item: Integer);
var
  Parent: TO32InspectorItem;
  NewItem: TO32InspectorItem;
  ParentNode: TTreeNode;
begin
  NewItem := nil;
  if (CurrentItem <> nil)
  and (CurrentItem.ItemType in [itSet, itParent]) then
    Parent := CurrentItem
  else
    Parent := nil;

  if (Parent <> nil)
  and (Parent.ItemType = itSet)
  and (Item <> Ord(itLogical)) then begin
    raise Exception.Create('Sets can only have Boolean children!');
    exit;
  end;

  case Item of
    Ord(itParent)   : begin
      if (Parent <> nil) and (Parent.ItemType = itSet) then begin
        raise Exception.Create('Cannot add a parent item as a child of a set!');
        exit;
      end else
       NewItem := Grid.Add(itParent, Parent);
    end;

    Ord(itSet)      : NewItem := Grid.Add(itSet, Parent);
    Ord(itList)     : NewItem := Grid.Add(itList, Parent);
    Ord(itString)   : NewItem := Grid.Add(itString, Parent);
    Ord(itInteger)  : NewItem := Grid.Add(itInteger, Parent);
    Ord(itFloat)    : NewItem := Grid.Add(itFloat, Parent);
    Ord(itCurrency) : NewItem := Grid.Add(itCurrency, Parent);
    Ord(itDate)     : NewItem := Grid.Add(itDate, Parent);
    Ord(itColor)    : NewItem := Grid.Add(itColor, Parent);
    Ord(itLogical)  : NewItem := Grid.Add(itLogical, Parent);
    Ord(itFont)     : NewItem := Grid.Add(itFont, Parent);
  end;

  if Parent <> nil then begin
    ParentNode := TreeView1.Items.Item[NewItem.ParentIndex];
    TreeView1.Items.AddChild(ParentNode, NewItem.Caption);
  end else begin
    TreeView1.Items.Add(nil, NewItem.Caption);
  end;
  TreeView1.SetFocus;
end;
{=====}

procedure TIGridCmpEd.SetChange(Sender: TObject);
begin
  if not ItemLoading then
    Changed := true;
end;
{=====}

procedure TIGridCmpEd.LoadOutline;
var
  I: Integer;
  CurrentNode: TTreeNode;
  ItemText: string;
begin
  OutlineLoading := true;
  CurrentNode := nil;

  if TreeView1.Items.Count > 0 then
    CurrentNode := TreeView1.Items.Item[CurrentItem.Index];

  TreeView1.Items.Clear;
  I := 0;
  While I < Grid.ItemCollection.Count do begin
    ItemText := Grid.Items[I].Caption;
    if ItemText = '' then
      ItemText := Grid.Items[I].Name;
    LoadChildrenOf(I, Treeview1.Items.Add(nil, ItemText));
    I := TreeView1.Items.Count;
  end;

  if CurrentNode <> nil then
    TreeView1.Selected := CurrentNode;
  OutlineLoading := false;
end;
{=====}

procedure TIGridCmpEd.LoadChildrenOf(var Index: Integer; Node: TTreeNode);
var
  I: Integer;
  ItemText: string;
  NewNode: TTreeNode;
begin
  if Grid.Items[Index].ItemType in [itSet, itParent] then begin
    I := Index + 1;
    while I < Grid.ItemCollection.Count do begin
      if Grid.Items[I].ParentIndex = Index then begin
        ItemText := Grid.Items[I].Caption;

        if ItemText = '' then
          ItemText := Grid.Items[I].Name;
        NewNode := Treeview1.Items.AddChild(Node, ItemText);
        if Grid.Items[I].ItemType in [itSet, itParent] then
          LoadChildrenOf(I, NewNode);
      end;
      Inc(I);
    end;
    Index := TreeView1.Items.Count -1;
  end;
end;
{=====}

procedure TIGridCmpEd.LoadItem;
var
  Num, I: Integer;
  TmpItem: TO32InspectorItem;
begin
  ItemLoading := true;

  if CurrentItem = nil then exit;

  { Hide all of the panels }
  StringPanel.Visible := false;
  ParentPanel.Visible := false;
  IntegerPanel.Visible := false;
  FloatPanel.Visible := false;
  ColorPanel.Visible := false;
  FontPanel.Visible := false;
  ListPanel.Visible := false;
  SetPanel.Visible := false;
  LogicalPanel.Visible := false;
  DatePanel.Visible := false;
  CurrencyPanel.Visible := false;

  CaptionEdit.Text := CurrentItem.Caption;
  LoadImage;

  { Show the right panel and load it }
  case CurrentItem.ItemType of
    itParent    : begin
      ParentPanel.Visible := true;
      Num := GetChildCount;
      ParentChildCount.Caption := IntToStr(Num);
      ParentVisibleChildren.Caption := IntToStr(CurrentItem.ChildCount);
      ParentHiddenChildren.Caption := IntToStr(Num-CurrentItem.ChildCount);
      ParentDisplayTextEdit.Text := CurrentItem.DisplayText;
      ItemVisible.Checked := CurrentItem.Visible;
    end;

    itSet       : begin
      SetPanel.Visible:= true;
      SetListBox.Clear;
      TypeLbl.Caption := 'Set';
      ItemVisible.Checked := CurrentItem.Visible;
      for I := 0 to Grid.ItemCollection.Count - 1 do begin
        TmpItem := TO32InspectorItem(Grid.ItemCollection.Items[I]);
        if TmpItem.Parent = CurrentItem then begin
          Num := SetListBox.Items.Add(TmpItem.Caption);
          SetListBox.Checked[Num] := TmpItem.AsBoolean;
        end;
      end;
      SetDisplayText.Caption := CurrentItem.AsString;
    end;

    itList      : begin
      ListPanel.Visible:= true;
      TypeLbl.Caption := 'List';
      ItemVisible.Checked := CurrentItem.Visible;
      ListItems.Items := CurrentItem.ItemsList;
      ListItems.ItemIndex := ListItems.Items.IndexOf(CurrentItem.AsString);
    end;

    itString    : begin
      StringPanel.Visible:= true;
      TypeLbl.Caption := 'String';
      ItemVisible.Checked := CurrentItem.Visible;
      StringDisplayText.Text := CurrentItem.AsString;
    end;

    itInteger   : begin
      IntegerPanel.Visible:= true;
      TypeLbl.Caption := 'Integer';
      ItemVisible.Checked := CurrentItem.Visible;
      IntegerValue.AsInteger := CurrentItem.AsInteger;
    end;

    itFloat     : begin
      FloatPanel.Visible:= true;
      TypeLbl.Caption := 'Float';
      ItemVisible.Checked := CurrentItem.Visible;
      FloatValue.AsFloat := CurrentItem.AsFloat;
    end;

    itCurrency  : begin
      CurrencyPanel.Visible:= true;
      TypeLbl.Caption := 'Currency';
      ItemVisible.Checked := CurrentItem.Visible;
      CurrencyEdit.Text := CurrentItem.AsString;
    end;

    itDate      : begin
      DatePanel.Visible:= true;
      TypeLbl.Caption := 'Date';
      ItemVisible.Checked := CurrentItem.Visible;
      DatePicker.Date := CurrentItem.AsDate;
    end;

    itColor     : begin
    ColorPanel.Visible:= true;
    TypeLbl.Caption := 'Color';
    ItemVisible.Checked := CurrentItem.Visible;
    ColorCombo.SelectedColor := CurrentItem.AsColor;
    end;

    itLogical   : begin
      LogicalPanel.Visible:= true;
      TypeLbl.Caption := 'Boolean';
      ItemVisible.Checked := CurrentItem.Visible;
      if CurrentItem.AsBoolean then
        LogicalValue.ItemIndex := LogicalValue.Items.IndexOf('True')
      else
        LogicalValue.ItemIndex := LogicalValue.Items.IndexOf('False');
    end;

    itFont      : begin
      FontPanel.Visible:= true;
      TypeLbl.Caption := 'Font';
      ItemVisible.Checked := CurrentItem.Visible;
      FontCombo.FontName := CurrentItem.AsString;
    end;
  end;
  ItemLoading := false;
end;
{=====}

procedure TIGridCmpEd.LoadImage;
var
  BMP: TBitmap;
  TransColor: TColor;
  r, c: Integer;
begin
  if CurrentItem.ImageIndex > -1 then begin
    Bmp := TBitmap.Create;
    try
      Grid.Images.GetBitmap(CurrentItem.ImageIndex, Bmp);
      { fix transparent color }
      TransColor := Bmp.Canvas.Pixels[0, Bmp.Height - 1];

      for r := 0 to Bmp.Height - 1 do
        for c := 0 to Bmp.Width - 1 do
          if Bmp.Canvas.Pixels[c, r] = TransColor then
            Bmp.Canvas.Pixels[c, r] := Self.Color;
      Image1.Picture.Bitmap.Assign(BMP);
      ImageBox.Caption := 'Image ' + IntToStr(CurrentItem.ImageIndex) + ' of '
        + IntTOStr(Grid.Images.Count - 1);
    finally
      Bmp.Free;
    end;
  end else begin
    Image1.Picture := nil;
    ImageBox.Caption := 'Image';
  end;
end;
{=====}

procedure TIGridCmpEd.UpdateItem;
var
  NewItem: TO32InspectorItem;
  I: Integer;
begin
  CaptionEdit.ReadOnly := false;
  CaptionEdit.TabStop := true;

  if Changed then begin
    case CurrentItem.ItemType of
      itParent    : begin
        CurrentItem.Caption := CaptionEdit.Text;
        TreeView1.Items.Item[CurrentItem.Index].Text := CurrentItem.Caption;
        CurrentItem.Visible := ItemVisible.Checked;
        CurrentItem.DisplayText := ParentDisplayTextEdit.Text;
      end;

      itSet       : begin
        CaptionEdit.ReadOnly := true;
        CaptionEdit.TabStop := false;
        CurrentItem.Caption := CaptionEdit.Text;
        TreeView1.Items.Item[CurrentItem.Index].Text := CurrentItem.Caption;
        CurrentItem.Visible := ItemVisible.Checked;
        CurrentItem.DeleteChildren;
        for I := 0 to pred(SetListBox.Items.Count) do begin
          NewItem := Grid.Add(itLogical, CurrentItem);
          NewItem.Caption := SetListBox.Items.Strings[I];
          NewItem.AsBoolean := SetListBox.Checked[I];
        end;
      end;

      itList      : begin
        CurrentItem.Caption := CaptionEdit.Text;
        TreeView1.Items.Item[CurrentItem.Index].Text := CurrentItem.Caption;
        CurrentItem.Visible := ItemVisible.Checked;
        CurrentItem.ItemsList.Assign(ListItems.Items);
        CurrentItem.AsString := ListItems.Text;
      end;

      itString    : begin
        CurrentItem.Caption := CaptionEdit.Text;
        TreeView1.Items.Item[CurrentItem.Index].Text := CurrentItem.Caption;
        CurrentItem.Visible := ItemVisible.Checked;
        CurrentItem.AsString := StringDisplayText.Text;
      end;

      itInteger   : begin
        CurrentItem.Caption := CaptionEdit.Text;
        TreeView1.Items.Item[CurrentItem.Index].Text := CurrentItem.Caption;
        CurrentItem.Visible := ItemVisible.Checked;
        CurrentItem.AsInteger := IntegerValue.AsInteger;
      end;

      itFloat     : begin
        CurrentItem.Caption := CaptionEdit.Text;
        TreeView1.Items.Item[CurrentItem.Index].Text := CurrentItem.Caption;
        CurrentItem.Visible := ItemVisible.Checked;
        CurrentItem.AsFloat := FloatValue.AsFloat;
      end;

      itCurrency  : begin
        CurrentItem.Caption := CaptionEdit.Text;
        TreeView1.Items.Item[CurrentItem.Index].Text := CurrentItem.Caption;
        CurrentItem.Visible := ItemVisible.Checked;
        CurrentItem.AsString := CurrencyEdit.Text;
      end;

      itDate      : begin
        CurrentItem.Caption := CaptionEdit.Text;
        TreeView1.Items.Item[CurrentItem.Index].Text := CurrentItem.Caption;
        CurrentItem.Visible := ItemVisible.Checked;
        CurrentItem.AsDate := DatePicker.Date;
      end;

      itColor     : begin
        CurrentItem.Caption := CaptionEdit.Text;
        TreeView1.Items.Item[CurrentItem.Index].Text := CurrentItem.Caption;
        CurrentItem.Visible := ItemVisible.Checked;
        CurrentItem.AsColor := ColorCombo.SelectedColor;
      end;

      itLogical   : begin
        CurrentItem.Caption := CaptionEdit.Text;
        TreeView1.Items.Item[CurrentItem.Index].Text := CurrentItem.Caption;
        CurrentItem.Visible := ItemVisible.Checked;
        CurrentItem.AsBoolean := LogicalValue.Text = 'True';
      end;

      itFont      : begin
        CurrentItem.Caption := CaptionEdit.Text;
        TreeView1.Items.Item[CurrentItem.Index].Text := CurrentItem.Caption;
        CurrentItem.Visible := ItemVisible.Checked;
        CurrentItem.AsFont.Name := FontCombo.FontName;
      end;
    end;
    Changed := false;
  end;
end;
{=====}

function TIGridCmpEd.GetChildCount: Integer;
var
  I : Integer;
begin
  Result := 0;
  for I := 0 to Grid.ItemCollection.Count - 1 do
    if TO32InspectorItem(Grid.ItemCollection.Items[I]).Parent = CurrentItem
    then Inc(Result);
end;
{=====}

procedure TIGridCmpEd.TreeView1Change(Sender: TObject; Node: TTreeNode);
begin
  if OutlineLoading then Exit;

  if CurrentItem <> Grid.Items[Node.AbsoluteIndex] then begin
    { Update the changed data in the item we're leaving }
    if CurrentItem <> nil then UpdateItem;
    { change to the newly selected item }
    CurrentItem := Grid.Items[Node.AbsoluteIndex];
    { load its editor fields. }
    LoadItem;
  end;
end;
{=====}

{ begin}
{ - Added a popup menu to the component editor }
procedure TIGridCmpEd.TreeView1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DELETE then
    Delete1Click(Sender);
end;
{=====}

procedure TIGridCmpEd.Delete1Click(Sender: TObject);
begin
  { Delete the InspectorGrid Item. }
  Grid.Delete(CurrentItem.Index);
  { Delete the TreeView Item. }
  TreeView1.Items.Delete(TreeView1.Selected);
end;
{ end}

procedure TIGridCmpEd.TreeView1KeyPress(Sender: TObject; var Key: Char);
begin
  if CharInSet(Key, ['A'..'Z', 'a'..'z', '0'..'1']) then begin
    CaptionEdit.SetFocus;
    CaptionEdit.Text := Key;
    Key := #0;
    CaptionEdit.SelStart := Length(CaptionEdit.Text);
  end;
end;
{=====}

procedure TIGridCmpEd.FormCreate(Sender: TObject);
begin
  CurrentItem := nil;
  O32FlexButton1.WheelSelection := true;
end;

procedure TIGridCmpEd.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) and Changed then begin
    Key := #0;
    UpdateItem;
    LoadItem;
  end;
end;
{=====}

procedure TIGridCmpEd.FormShow(Sender: TObject);
begin
  if Grid.ItemCollection.VisibleItems.count > 0 then
    CurrentItem := Grid.Items[Grid.ActiveItem]
  else
    CurrentItem := nil;
  { Set default item as itString }
  O32FlexButton1.ActiveItem := 3;
  LoadOutline;
  LoadItem;
  TreeView1.SetFocus;
end;
{=====}

procedure TIGridCmpEd.OvcSpinner1Click(Sender: TObject;
  State: TOvcSpinState; Delta: Double; Wrap: Boolean);
begin
  if (CurrentItem <> nil) and (Grid.Images <> nil) then begin
    if State = ssUpBtn then begin
      if CurrentItem.ImageIndex <= 0 then
        CurrentItem.ImageIndex := Grid.Images.Count - 1
      else
        CurrentItem.ImageIndex := CurrentItem.ImageIndex - trunc(Delta);
    end else begin
      if CurrentItem.ImageIndex >= Grid.Images.Count - 1 then
        CurrentItem.ImageIndex := 0
      else
        CurrentItem.ImageIndex := CurrentItem.ImageIndex + trunc(Delta);
    end;
    Changed := true;
    LoadImage;
    UpdateItem;
  end;
end;
{=====}

procedure TIGridCmpEd.ListItemsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then begin
    if (ListItems.Text <> '')
    and (ListItems.Items.IndexOf(ListItems.Text) = -1) then begin
      ListItems.Items.Add(ListItems.Text);
      ListItems.SelectAll;
      Changed := true;
    end;
  end

  else if Key = VK_DELETE then begin
    ListItems.Items.Delete(ListItems.ItemIndex);
    ListItems.ItemIndex := -1;
    ListItems.Text := '';
    Changed := true;
  end;

  UpdateItem;
end;
{=====}

procedure TIGridCmpEd.SetItemKeyPress(Sender: TObject; var Key: Char);
var
  NewItem: Integer;
begin
  if (Key = #13) then begin
    Key := #0;
    if (SetListBox.Items.IndexOf(SetItem.Text) = -1) then begin
      NewItem := SetListBox.Items.Add(SetItem.Text);
      SetlistBox.Checked[NewItem] := true;
      Changed := true;
      TreeView1.Items.AddChild(TreeView1.Selected,
        SetListBox.Items.Strings[NewItem]);
      UpdateItem;
      LoadItem;
      SetItem.SetFocus;
    end;
  end;
end;
{=====}

procedure TIGridCmpEd.SetListBoxKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  I: Integer;
  Num: Integer;
begin
  Num := SetListBox.ItemIndex;
  if Key = VK_DELETE then begin
    { Find and delete corresponding node }
    for I := 0 to TreeView1.Items.Count do begin
      if (TreeView1.Items.Item[I].Parent = TreeView1.Selected)
      and (TreeView1.Items.Item[I].Text
        = SetListBox.Items.Strings[SetListBox.ItemIndex]) then
      begin
        TreeView1.Items.Delete(TreeView1.Items.Item[I]);
        Break;
      end;
    end;
    SetListBox.Items.Delete(SetListBox.ItemIndex);
    Changed := true;
    UpdateItem;
    LoadItem;
    SetListBox.SetFocus;
    if Num > Pred(SetListBox.Items.Count) then
      SetListBox.ItemIndex := Pred(SetListBox.Items.Count)
    else
      SetListBox.ItemIndex := Num;
  end;
end;
{=====}

procedure TIGridCmpEd.SetListBoxClickCheck(Sender: TObject);
var
  Num, I: Integer;
  Tmp: String;
begin
  Num := SetListBox.ItemIndex;
  Tmp := '[';
  for I := 0 to pred(SetListBox.Items.Count) do begin
    if SetListBox.Checked[I] then
      Tmp := Tmp + SetListBox.Items.Strings[I] + ', ';
  end;
  StripCharFromEnd(' ', Tmp);
  StripCharFromEnd(',', Tmp);
  StripCharFromEnd(' ', Tmp);
  SetDisplayText.Caption := Tmp + ']';

  SetListBox.SetFocus;
  if Num > Pred(SetListBox.Items.Count) then
    SetListBox.ItemIndex := Pred(SetListBox.Items.Count)
  else
    SetListBox.ItemIndex := Num;

  Changed := true;
  UpdateItem;
end;
{=====}

procedure TIGridCmpEd.ClearImageBtnClick(Sender: TObject);
begin
  CurrentItem.ImageIndex := -1;
  LoadImage;
end;

end.
