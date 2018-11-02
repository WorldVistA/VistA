{*********************************************************}
{*                  IGRIDITEMED.PAS 4.06                 *}
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

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit O32IGridItemEd;
  {-Inspector Grid Items property editor}

interface

uses
  Windows, Classes, Controls, DesignIntf, DesignEditors, Dialogs, ExtCtrls, Forms,
  Graphics, Messages, StdCtrls, SysUtils, OvcBase, OvcData, OvcSpeed, Menus, O32IGrid;

type
  TProtectedSelectionList = class(TDesignerSelections);

  TFormIGridItemEditor = class(TForm)
    ListBox1: TListBox;
    Panel1: TPanel;
    BtnAdd: TOvcSpeedButton;
    BtnDelete: TOvcSpeedButton;
    BtnMoveUp: TOvcSpeedButton;
    BtnMoveDown: TOvcSpeedButton;

    procedure btnAddClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnMoveUpClick(Sender: TObject);
    procedure btnMoveDownClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    procedure FillListBox;
    procedure SelectComponentList(SelList : TDesignerSelections);
    procedure OmPropChange(var Msg : TMessage); message OM_PROPCHANGE;
  public
    Collection : TO32InspectorItems;
    Designer   : IDesigner;
    InInLined  : Boolean;
  end;

  TO32IgridCollectionEditor = class(TPropertyEditor)
  public
    procedure Edit; override;
    function GetAttributes : TPropertyAttributes; override;
    function GetValue : string; override;
  end;

procedure ShowCollectionEditor(Designer : IDesigner;
                               Collection : TO32InspectorItems;
                               InInLined  : Boolean);

implementation

{$R *.dfm}


procedure ShowCollectionEditor(Designer : IDesigner; Collection : TO32InspectorItems; InInLined  : Boolean);
begin
  if Collection.ItemEditor = nil then
    Collection.ItemEditor := TFormIGridItemEditor.Create(Application);
  TFormIGridItemEditor(Collection.ItemEditor).Collection := Collection;
  TFormIGridItemEditor(Collection.ItemEditor).Designer := Designer;
  TFormIGridItemEditor(Collection.ItemEditor).InInLined := InInLined;
  TFormIGridItemEditor(Collection.ItemEditor).Show;
end;

{*** TO32IgridCollectionEditor ***}

function TO32IgridCollectionEditor.GetAttributes : TPropertyAttributes;
begin
  Result := [paDialog];
end;

function TO32IgridCollectionEditor.GetValue: string;
begin
  Result := '(' + TO32Collection(GetOrdValueAt(0)).ClassName + ')';
end;

procedure TO32IgridCollectionEditor.Edit;
begin
  ShowCollectionEditor(Designer, TO32InspectorItems(GetOrdValueAt(0)), False);
end;


{*** TFormIGridItemEditor ***}

procedure TFormIGridItemEditor.FormCreate(Sender: TObject);
begin
  Top := (Screen.Height - Height) div 3;
  Left := (Screen.Width - Width) div 2;
end;

procedure TFormIGridItemEditor.FormShow(Sender : TObject);
begin
  Caption := Collection.GetEditorCaption;
  FillListBox;

  if Collection.ReadOnly or InInLined then
  begin
    btnAdd.Enabled := False;
    btnDelete.Enabled := False;
    btnMoveUp.Enabled := False;
    btnMoveDown.Enabled := False;
    Caption := Caption + ' (Read Only)';
  end;
end;

procedure TFormIGridItemEditor.FormDestroy(Sender: TObject);
begin
  if Collection <> nil then
    Collection.ItemEditor := nil;
end;

procedure TFormIGridItemEditor.FillListBox;
var
  i : Integer;
begin
  ListBox1.Clear;
  ListBox1.ItemIndex := -1;
  for i := 0 to pred(Collection.Count) do begin
    if TO32InspectorItem(Collection.Item[i]).Caption <> '' then
      ListBox1.Items.AddObject(IntToStr(i) + ' - '
        + TO32InspectorItem(Collection.Item[i]).Caption,
        Collection.Item[i])
    else
      ListBox1.Items.AddObject(IntToStr(i) + ' - '
        + TO32InspectorItem(Collection.Item[i]).Name,
        Collection.Item[i]);
  end;
end;

procedure TFormIGridItemEditor.btnAddClick(Sender: TObject);
begin
  if InInLined then begin
    ShowMessage('Can''t add inherited components');
    exit;
  end;
  Collection.Add;
  FillListBox;
  ListBox1.ItemIndex := ListBox1.Items.Count-1;
  Collection.DoOnItemSelected(ListBox1.ItemIndex);
  Designer.Modified;
end;

procedure TFormIGridItemEditor.btnDeleteClick(Sender: TObject);
var
  i,J,c : Integer;
begin
  C := 0;
  J := -1;
  for i := 0 to pred(ListBox1.Items.Count) do
    if ListBox1.Selected[i] then begin
      inc(C);
      J := I;
    end;
  if C <> 1 then exit;
  if J <> -1 then begin
    if InInLined then begin
      ShowMessage('Inherited component - can''t delete');
      exit;
    end;
    TComponent(ListBox1.Items.Objects[J]).Free;

    ListBox1.ItemIndex := -1;
    FillListBox;
    Designer.Modified;

    dec(J);
    if (J >= 0) and (J < ListBox1.Items.Count) then begin
      ListBox1.Selected[J] := True;
      ListBox1Click(Sender);
    end;
  end;
end;

procedure TFormIGridItemEditor.btnMoveUpClick(Sender: TObject);
var
  SaveItemIndex : Integer;
begin
  if (ListBox1.SelCount = 1) and (ListBox1.ItemIndex > 0) then begin
    SaveItemIndex := ListBox1.ItemIndex;
    with TO32InspectorItem(ListBox1.Items.Objects[ListBox1.ItemIndex]) do begin
      Index := Index - 1;
      Designer.Modified;
    end;
    FillListBox;
    ListBox1.Selected[SaveItemIndex-1] := True;
    ListBox1.ItemIndex := SaveItemIndex - 1;
    ListBox1Click(Sender);
  end;
end;

procedure TFormIGridItemEditor.btnMoveDownClick(Sender: TObject);
var
  SaveItemIndex : Integer;
begin
  if (ListBox1.SelCount = 1) and (ListBox1.ItemIndex < ListBox1.Items.Count - 1) then begin
    SaveItemIndex := ListBox1.ItemIndex;
    with TO32InspectorItem(ListBox1.Items.Objects[ListBox1.ItemIndex]) do begin
      Index := Index + 1;
      Designer.Modified;
    end;
    FillListBox;
    ListBox1.Selected[SaveItemIndex+1] := True;
    ListBox1.ItemIndex := SaveItemIndex + 1;
    ListBox1Click(Sender);
  end;
end;

procedure TFormIGridItemEditor.ListBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_UP) and (ssCtrl in Shift) then begin
    if btnMoveUp.Enabled then
      btnMoveUpClick(nil);
    Key := 0;
  end else if (Key = VK_DOWN) and (ssCtrl in Shift) then begin
    if btnMoveUp.Enabled then
      btnMoveDownClick(nil);
    Key := 0;
  end else if (Key = VK_DELETE) then begin
    btnDeleteClick(nil);
    Key := 0;
  end else if (Key = VK_INSERT) then begin
    btnAddClick(nil);
    Key := 0;
  end;
end;

procedure TFormIGridItemEditor.ListBox1Click(Sender: TObject);
var
  SelList : TDesignerSelections;
  i : Integer;
begin
  SelList := TDesignerSelections.Create;
  for i := 0 to pred(ListBox1.Items.Count) do
    if ListBox1.Selected[i] then begin
      TProtectedSelectionList(SelList).Add(TComponent(ListBox1.Items.Objects[i]));
      Collection.DoOnItemSelected(I);
    end;
  if not Collection.ReadOnly
  and not InInLined
  then begin
      btnMoveUp.Enabled := TProtectedSelectionList(SelList).Count = 1;
    btnMoveDown.Enabled := btnMoveUp.Enabled;
    btnDelete.Enabled := btnMoveUp.Enabled;
  end;
  if TProtectedSelectionList(SelList).Count > 0 then
    SelectComponentList(SelList);
end;

procedure TFormIGridItemEditor.SelectComponentList(SelList : TDesignerSelections);
begin
  if Designer <> nil then
    (Designer as IDesigner).SetSelections(SelList);
  SelList.Free;
end;

procedure TFormIGridItemEditor.OmPropChange(var Msg : TMessage);
var
  I, J : Integer;
  Found : Boolean;
begin
  FillListBox;
  for I := Pred(ListBox1.Items.Count) downto 0 do begin
    Found := False;
    for J := 0 to pred(Collection.Count) do
      if Collection.Item[J] = ListBox1.Items.Objects[I] then begin
        Found := True;
        break;
      end;
    if not Found then
      ListBox1.Items.Delete(I);
  end;

  for I := 0 to Pred(Collection.Count) do begin
    Found := False;
    for J := 0 to pred(ListBox1.Items.Count) do
      if Collection.Item[I] = ListBox1.Items.Objects[J] then begin
        Found := True;
        break;
      end;
    if not Found then
      { use the item's caption unless it's an empty string... }
      if TO32InspectorItem(Collection.Item[I]).Caption <> '' then
        ListBox1.Items.AddObject(IntToStr(I) + ' - '
          + TO32InspectorItem(Collection.Item[I]).Caption, Collection.Item[I])
      else
      { in which case, use the item's name }
        ListBox1.Items.AddObject(IntToStr(I) + ' - '
          + TO32InspectorItem(Collection.Item[I]).Name, Collection.Item[I])
  end;

  for I := 0 to Pred(ListBox1.Items.Count) do
    { use the item's caption unless it's an empty string... }
    if TO32InspectorItem(Collection.Item[I]).Caption <> '' then
      ListBox1.Items.AddObject(IntToStr(I) + ' - '
        + TO32InspectorItem(Collection.Item[I]).Caption, Collection.Item[I])
    else
    { in which case, use the item's name }
      ListBox1.Items.AddObject(IntToStr(I) + ' - '
        + TO32InspectorItem(Collection.Item[I]).Name, Collection.Item[I]);

  if Designer <> nil then
    Designer.Modified;
end;

end.




