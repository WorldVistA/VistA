{*********************************************************}
{*                  OVCCOLED0.PAS 4.06                   *}
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

unit ovccole0;
  {-collection property editor}

interface

uses
  Windows, Classes, Controls, DesignIntf, DesignEditors, Dialogs, ExtCtrls, Forms,
  Graphics, Messages, StdCtrls, SysUtils, OvcBase, OvcData, OvcSpeed, Menus;

type
  TProtectedSelList = class(TDesignerSelections);

  TOvcfrmCollEditor = class(TForm)
    ListBox1: TListBox;
    Panel1: TPanel;
    btnAdd: TOvcSpeedButton;
    btnDelete: TOvcSpeedButton;
    btnMoveUp: TOvcSpeedButton;
    btnMoveDown: TOvcSpeedButton;

    procedure btnAddClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnMoveUpClick(Sender: TObject);
    procedure btnMoveDownClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    procedure FillGrid;

    procedure SelectComponentList(SelList : TDesignerSelections);

    procedure SelectComponent(Component : TComponent);

    procedure OmPropChange(var Msg : TMessage);
      message OM_PROPCHANGE;
  public
    Collection : TOvcCollection;
    Designer   : IDesigner;
    InInLined  : Boolean;
  end;

type
  TOvcCollectionEditor = class(TPropertyEditor)
  public
    procedure Edit;
      override;
    function GetAttributes : TPropertyAttributes;
      override;
    function GetValue : string;
      override;
  end;

procedure ShowCollectionEditor(Designer : IDesigner;
                               Collection : TOvcCollection;
                               InInLined  : Boolean);

implementation

{$R *.DFM}

procedure ShowCollectionEditor(Designer : IDesigner;
                               Collection : TOvcCollection;
                               InInLined  : Boolean);
begin
  if Collection.ItemEditor = nil then
    Collection.ItemEditor := TOvcfrmCollEditor.Create(Application);
  TOvcfrmCollEditor(Collection.ItemEditor).Collection := Collection;
  TOvcfrmCollEditor(Collection.ItemEditor).Designer := Designer;
  TOvcfrmCollEditor(Collection.ItemEditor).InInLined := InInLined;
  TOvcfrmCollEditor(Collection.ItemEditor).Show;
end;


{*** TOvcCollectionEditor ***}

function TOvcCollectionEditor.GetAttributes : TPropertyAttributes;
begin
  Result := [paDialog];
end;

function TOvcCollectionEditor.GetValue: string;
begin
  Result := '(' + TOvcCollection(GetOrdValueAt(0)).ClassName + ')';
end;

procedure TOvcCollectionEditor.Edit;
begin
  ShowCollectionEditor(Designer,
                       TOvcCollection(GetOrdValueAt(0)),
                       False);
end;


{*** TfCollEditor ***}

procedure TOvcfrmCollEditor.FormCreate(Sender: TObject);
begin
  Top := (Screen.Height - Height) div 3;
  Left := (Screen.Width - Width) div 2;
end;

procedure TOvcfrmCollEditor.FormShow(Sender : TObject);
begin
  Caption := Collection.GetEditorCaption;
  FillGrid;

  if Collection.ReadOnly or InInLined then
  begin
    btnAdd.Enabled := False;
    btnDelete.Enabled := False;
    btnMoveUp.Enabled := False;
    btnMoveDown.Enabled := False;
    Caption := Caption + ' (Read Only)';
  end;
end;

procedure TOvcfrmCollEditor.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SelectComponent(Collection.Owner);
end;

procedure TOvcfrmCollEditor.FormDestroy(Sender: TObject);
begin
  if Collection <> nil then
    Collection.ItemEditor := nil;
end;

procedure TOvcfrmCollEditor.FillGrid;
var
  i : Integer;
begin
  ListBox1.Clear;
  ListBox1.ItemIndex := -1;
  for i := 0 to pred(Collection.Count) do
    if Collection.Item[i] is TOvcCollectible then
      ListBox1.Items.AddObject(
        IntToStr(i) + ' - ' + TOvcCollectible(Collection.Item[i]).DisplayText,
        Collection.Item[i])
    else
      ListBox1.Items.AddObject(
        IntToStr(i) + ' - ' + TOvcCollectibleControl(Collection.Item[i]).DisplayText,
        Collection.Item[i])
end;

procedure TOvcfrmCollEditor.btnAddClick(Sender: TObject);
var
  NewItem : TComponent;
begin
  if InInLined then begin
    ShowMessage('Inherited component - can''t add');
    exit;
  end;
  NewItem := Collection.Add;
  ListBox1.Selected[ListBox1.Items.Count-1] := True;
  ListBox1.ItemIndex := ListBox1.Items.Count-1;
  SelectComponent(NewItem);
  Collection.DoOnItemSelected(ListBox1.ItemIndex);
  Designer.Modified;
end;

procedure TOvcfrmCollEditor.btnDeleteClick(Sender: TObject);
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
    SelectComponent(Collection.Owner);
    TComponent(ListBox1.Items.Objects[J]).Free;

    ListBox1.ItemIndex := -1;
    FillGrid;
    Designer.Modified;

    dec(J);
    if (J >= 0) and (J < ListBox1.Items.Count) then begin
      ListBox1.Selected[J] := True;
      ListBox1Click(Sender);
    end;
  end;
end;

procedure TOvcfrmCollEditor.btnMoveUpClick(Sender: TObject);
var
  SaveItemIndex : Integer;
begin
  if (ListBox1.SelCount = 1) and (ListBox1.ItemIndex > 0) then begin
    SaveItemIndex := ListBox1.ItemIndex;
    if ListBox1.Items.Objects[ListBox1.ItemIndex] is TOvcCollectible then
      with TOvcCollectible(ListBox1.Items.Objects[ListBox1.ItemIndex]) do begin
        Index := Index - 1;
        Designer.Modified;
      end
    else
      with TOvcCollectibleControl(ListBox1.Items.Objects[ListBox1.ItemIndex]) do begin
        Index := Index - 1;
        Designer.Modified;
      end;
    FillGrid;
    ListBox1.Selected[SaveItemIndex-1] := True;
    ListBox1.ItemIndex := SaveItemIndex - 1;
    ListBox1Click(Sender);
  end;
end;


procedure TOvcfrmCollEditor.btnMoveDownClick(Sender: TObject);
var
  SaveItemIndex : Integer;
begin
  if (ListBox1.SelCount = 1) and (ListBox1.ItemIndex < ListBox1.Items.Count - 1) then begin
    SaveItemIndex := ListBox1.ItemIndex;
    if ListBox1.Items.Objects[ListBox1.ItemIndex] is TOvcCollectible then
      with TOvcCollectible(ListBox1.Items.Objects[ListBox1.ItemIndex]) do begin
        Index := Index + 1;
        Designer.Modified;
      end
    else
      with TOvcCollectibleControl(ListBox1.Items.Objects[ListBox1.ItemIndex]) do begin
        Index := Index + 1;
        Designer.Modified;
      end;
    FillGrid;
    ListBox1.Selected[SaveItemIndex+1] := True;
    ListBox1.ItemIndex := SaveItemIndex + 1;
    ListBox1Click(Sender);
  end;
end;

procedure TOvcfrmCollEditor.ListBox1KeyDown(Sender: TObject; var Key: Word;
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

procedure TOvcfrmCollEditor.ListBox1Click(Sender: TObject);
var
  SelList : TDesignerSelections;
  i : Integer;
begin
  SelList := TDesignerSelections.Create;
  for i := 0 to pred(ListBox1.Items.Count) do
    if ListBox1.Selected[i] then begin
        TProtectedSelList(SelList).Add(TComponent(ListBox1.Items.Objects[i]));
      Collection.DoOnItemSelected(I);
    end;
  if not Collection.ReadOnly and not InInLined then
  begin
    btnMoveUp.Enabled := TProtectedSelList(SelList).Count = 1;
    btnMoveDown.Enabled := btnMoveUp.Enabled;
    btnDelete.Enabled := btnMoveUp.Enabled;
  end;
  if TProtectedSelList(SelList).Count > 0 then
    SelectComponentList(SelList)
  else
    SelectComponent(Collection.Owner);
end;

procedure TOvcfrmCollEditor.SelectComponentList(SelList : TDesignerSelections);
begin
  if Designer <> nil then
    (Designer as IDesigner).SetSelections(SelList);
  SelList.Free;
end;

procedure TOvcfrmCollEditor.SelectComponent(Component : TComponent);
var
  SelList : TDesignerSelections;
begin
  SelList := TDesignerSelections.Create;
  TProtectedSelList(SelList).Add(Component);
  SelectComponentList(SelList);
end;

procedure TOvcfrmCollEditor.OmPropChange(var Msg : TMessage);
var
  I, J : Integer;
  Found : Boolean;
begin
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
    if not Found then begin
      if Collection.Item[I] is TOvcCollectible then
        ListBox1.Items.AddObject(
          IntToStr(I) + ' - ' + TOvcCollectible(Collection.Item[I]).DisplayText,
          Collection.Item[I])
      else
        ListBox1.Items.AddObject(
          IntToStr(I) + ' - ' + TOvcCollectibleControl(Collection.Item[I]).DisplayText,
          Collection.Item[I])
    end;
  end;
  for I := 0 to Pred(ListBox1.Items.Count) do
    if ListBox1.Items.Objects[i] is TOvcCollectible then
      ListBox1.Items.Strings[i] := IntToStr(i) + ' - ' +
        TOvcCollectible(ListBox1.Items.Objects[i]).DisplayText
    else
      ListBox1.Items.Strings[i] := IntToStr(i) + ' - ' +
        TOvcCollectibleControl(ListBox1.Items.Objects[i]).DisplayText;
  if Designer <> nil then
    Designer.Modified;
end;

end.


