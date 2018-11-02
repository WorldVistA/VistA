{*********************************************************}
{*                 OVCSTAT0.PAS 4.06                    *}
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

unit ovcstat0;
  {-form and component state property editor}

interface

uses
  Windows, Buttons, Classes, Controls,
  {$IFDEF VERSION6} DesignIntf, DesignEditors, {$ELSE} DsgnIntf, {$ENDIF}
  ExtCtrls, Forms, Messages, StdCtrls, SysUtils, TypInfo, OvcFiler, OvcState,
  OvcSpeed, OvcBase, OvcLB;

type
  TOvcfrmPropsDlg = class(TForm)
    StoredList: TOvcListBox;
    PropertiesList: TOvcListBox;
    ComponentsList: TOvcListBox;
    AddButton: TButton;
    DeleteButton: TButton;
    ClearButton: TButton;
    OkBtn: TButton;
    CancelBtn: TButton;
    UpBtn: TOvcSpeedButton;
    DownBtn: TOvcSpeedButton;
    lblClassName: TLabel;
    lblPropType: TLabel;
    ComponentsListLabel1: TOvcAttachedLabel;
    PropertiesListLabel1: TOvcAttachedLabel;
    StoredListLabel1: TOvcAttachedLabel;

    procedure AddButtonClick(Sender: TObject);
    procedure ClearButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure DownBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ListClick(Sender: TObject);
    procedure PropertiesListDblClick(Sender: TObject);
    procedure StoredListClick(Sender: TObject);
    procedure StoredListDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure StoredListDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure StoredListKeyPress(Sender: TObject; var Key: Char);
    procedure UpBtnClick(Sender: TObject);

  private
    TheOwner : TWinControl;
    {$IFDEF VERSION4}
    FDesigner: IDesigner;
    {$ELSE}
    FDesigner: TDesigner;
    {$ENDIF}

    procedure AddItem(IdxComp, IdxProp : Integer; AUpdate : Boolean);
    procedure BuildLists(StoredProps : TStrings);
    procedure CheckAddItem(const CompName, PropName : string);
    procedure CheckButtons;
    procedure ClearLists;
    procedure DeleteProp(I : Integer);
    function FindProp(const CompName, PropName : string; var IdxComp, IdxProp : Integer) : Boolean;
    procedure ListToIndex(List : TCustomListBox; Idx : Integer);
    procedure SetStoredList(AList : TStrings);
    procedure UpdateCurrentClass;
    procedure UpdateCurrentProp;
  end;

  TOvcComponentStateEditor = class(TComponentEditor)
    procedure ExecuteVerb(Index : Integer);
      override;
    function GetVerb(Index : Integer) : string;
      override;
    function GetVerbCount : Integer;
      override;
  end;

  TStoredPropsProperty = class(TClassProperty)
  public
    procedure Edit;
      override;
    function GetAttributes : TPropertyAttributes;
      override;
    function GetValue : string;
      override;
  end;

{$IFDEF VERSION4}
  {$IFDEF VERSION5}
    function ShowStorageDesigner(AForm : TWinControl;
                                 ADesigner : IDesigner;
                                 AStoredList : TStrings) : Boolean;
  {$ELSE}
    function ShowStorageDesigner(AForm : TForm;
                                 ADesigner : IDesigner;
                                 AStoredList : TStrings) : Boolean;
  {$ENDIF}
{$ELSE}
function ShowStorageDesigner(AForm : TForm; ADesigner : TDesigner; AStoredList : TStrings) : Boolean;
{$ENDIF}


implementation

{$R *.DFM}

uses
  OvcData;


{*** TOvcComponentStateEditor ***}

procedure TOvcComponentStateEditor.ExecuteVerb(Index : Integer);
var
  Storage : TOvcComponentState;
  StorageOwner   : TComponent;
begin
  Storage := Component as TOvcComponentState;
  {$IFDEF VERSION5}
  StorageOwner := Designer.GetRoot;
  {$ELSE}
  StorageOwner := Designer.Form;
  {$ENDIF}

  if (Index = 0) then begin
{$IFDEF VERSION5}
    if (csAncestor in Storage.ComponentState) then
      raise Exception.Create('Component has ancestor. StoredProperties cannot be edited');
    if ShowStorageDesigner(StorageOwner as TWinControl, Designer, Storage.StoredProperties) then
{$ELSE}
    if ShowStorageDesigner(StorageOwner as TForm, Designer, Storage.StoredProperties) then
{$ENDIF}
      Storage.SetNotification;
  end;
end;

function TOvcComponentStateEditor.GetVerb(Index : Integer) : string;
begin
  Result := 'Stored Properties...';
end;

function TOvcComponentStateEditor.GetVerbCount : Integer;
begin
  Result := 1;
end;


{*** TStoredPropsProperty ***}

procedure TStoredPropsProperty.Edit;
var
  Storage : TOvcComponentState;
  StorageOwner   : TComponent;
begin
  Storage := GetComponent(0) as TOvcComponentState;
  {$IFDEF VERSION5}
  StorageOwner := Designer.GetRoot;
  {$ELSE}
  StorageOwner := Designer.Form;
  {$ENDIF}


{$IFDEF VERSION5}
  if (csAncestor in Storage.ComponentState) then
    raise Exception.Create('Component has ancestor. StoredProperties cannot be edited');
  if ShowStorageDesigner(StorageOwner as TWinControl, Designer, Storage.StoredProperties) then
{$ELSE}
  if ShowStorageDesigner(StorageOwner as TForm, Designer, Storage.StoredProperties) then
{$ENDIF}
    Storage.SetNotification;
end;

function TStoredPropsProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paDialog] - [paSubProperties];
end;

function TStoredPropsProperty.GetValue : string;
begin
  Result := '(Properties)';
end;


{*** ShowStorageDesigner ***}

{$IFDEF VERSION4}
  {$IFDEF VERSION5}
function ShowStorageDesigner(AForm : TWinControl; ADesigner : IDesigner; AStoredList : TStrings) : Boolean;
  {$ELSE}
function ShowStorageDesigner(AForm : TForm; ADesigner : IDesigner; AStoredList : TStrings) : Boolean;
  {$ENDIF}
{$ELSE}
function ShowStorageDesigner(AForm : TForm; ADesigner : TDesigner; AStoredList : TStrings) : Boolean;
{$ENDIF}
begin
  with TOvcfrmPropsDlg.Create(Application) do
  try
    TheOwner := AForm;
    FDesigner := ADesigner;
    Screen.Cursor := crHourGlass;
    try
      UpdateStoredList(AForm, AStoredList, False);
      SetStoredList(AStoredList);
    finally
      Screen.Cursor := crDefault;
    end;
    Result := ShowModal = mrOk;
    if Result then
      AStoredList.Assign(StoredList.Items);
  finally
    Free;
  end;
end;


{*** Utilities ***}

function BoxCanDropItem(List : TCustomListBox; X, Y : Integer;
  var DragIndex : Integer) : Boolean;
var
  Focused : Integer;
begin
  Result := False;
  if (List.SelCount = 1) or (not TListBox(List).MultiSelect) then begin
    Focused := List.ItemIndex;
    if Focused <> LB_ERR then begin
      DragIndex := List.ItemAtPos(Point(X, Y), True);
      if (DragIndex >= 0) and (DragIndex <> Focused) then
        Result := True;
    end;
  end;
end;

procedure BoxDragOver(List : TCustomListBox; Source : TObject;
  X, Y : Integer; State : TDragState; var Accept : Boolean; Sorted : Boolean);
var
  DragIndex : Integer;
  R         : TRect;

  procedure DrawItemFocusRect(Idx : Integer);
  var
    P: TPoint;
    DC: HDC;
  begin
    R := List.ItemRect(Idx);
    P := List.ClientToScreen(R.TopLeft);
    R := Bounds(P.X, P.Y, R.Right - R.Left, R.Bottom - R.Top);
    DC := GetDC(0);
    DrawFocusRect(DC, R);
    ReleaseDC(0, DC);
  end;

begin
  if Source <> List then
    Accept := Source is TCustomListBox
  else begin
    if Sorted then
      Accept := False
    else begin
      Accept := BoxCanDropItem(List, X, Y, DragIndex);
      if ((List.Tag - 1) = DragIndex) and (DragIndex >= 0) then begin
        if State = dsDragLeave then begin
          DrawItemFocusRect(List.Tag - 1);
          List.Tag := 0;
        end;
      end else begin
        if List.Tag > 0 then
          DrawItemFocusRect(List.Tag - 1);
        if DragIndex >= 0 then
          DrawItemFocusRect(DragIndex);
        List.Tag := DragIndex + 1;
      end;
    end;
  end;
end;

procedure BoxSetItem(List : TCustomListBox; Index : Integer);
var
  MaxIndex: Integer;
begin
  with List do begin
    SetFocus;
    MaxIndex := List.Items.Count - 1;
    if Index = LB_ERR then
      Index := 0
    else begin
     if Index > MaxIndex then
       Index := MaxIndex;
    end;
    if Index >= 0 then begin
      if TListBox(List).MultiSelect then
        Selected[Index] := True
      else
        List.ItemIndex := Index;
    end;
  end;
end;

procedure BoxMoveFocusedItem(List : TCustomListBox; DstIndex : Integer);
var
  InsIndex : Integer;
  DelIndex : Integer;
begin
  if (DstIndex >= 0) and (DstIndex < List.Items.Count) then
    if (DstIndex <> List.ItemIndex) then begin
      if DstIndex > List.ItemIndex then begin
        InsIndex := DstIndex + 1;
        DelIndex := List.ItemIndex;
      end else begin
        InsIndex := DstIndex;
        DelIndex := List.ItemIndex + 1;
      end;
      List.Items.InsertObject(InsIndex, List.Items[List.ItemIndex],
          List.Items.Objects[List.ItemIndex]);
      List.Items.Delete(DelIndex);
      BoxSetItem(List, DstIndex);
    end;
end;


{*** TFormPropsDlg ***}

procedure TOvcfrmPropsDlg.AddButtonClick(Sender : TObject);
var
  I : Integer;
begin
  if PropertiesList.SelCount > 0 then begin
    for I := PropertiesList.Items.Count - 1 downto 0 do begin
      if PropertiesList.Selected[I] then
        AddItem(ComponentsList.ItemIndex, I, False);
    end;
    UpdateCurrentClass;
  end else
    AddItem(ComponentsList.ItemIndex, PropertiesList.ItemIndex, True);

  if FDesigner <> nil then
    FDesigner.Modified;

  CheckButtons;
end;

procedure TOvcfrmPropsDlg.AddItem(IdxComp, IdxProp : Integer; AUpdate : Boolean);
var
  Idx       : Integer;
  StrList   : TStringList;
  Component : TComponent;
  CompName  : string;
  PropName  : string;
begin
  CompName := ComponentsList.Items[IdxComp];
  Component := TheOwner.FindComponent(CompName);
  if Component = nil then
    Exit;

  StrList := TStringList(ComponentsList.Items.Objects[IdxComp]);
  PropName := StrList[IdxProp];
  StrList.Delete(IdxProp);
  if StrList.Count = 0 then begin
    Idx := ComponentsList.ItemIndex;
    StrList.Free;
    ComponentsList.Items.Delete(IdxComp);
    ListToIndex(ComponentsList, Idx);
  end;

  StoredList.Items.AddObject(CreateStoredItem(CompName, PropName), Component);
  StoredList.ItemIndex := StoredList.Items.Count - 1;
  if AUpdate then
    UpdateCurrentClass;
end;

procedure TOvcfrmPropsDlg.BuildLists(StoredProps : TStrings);
var
  I, J     : Integer;
  C        : TComponent;
  List     : TOvcPropertyList;
  StrList  : TStrings;
  CompName : string;
  PropName : string;
begin
  ClearLists;
  if TheOwner <> nil then begin
    for I := 0 to TheOwner.ComponentCount - 1 do begin
      C := TheOwner.Components[I];
      if (C is TOvcFormState) or (C.Name = '') then
        Continue;
      List := TOvcPropertyList.Create(C, tkProperties, '');
      try
        StrList := TStringList.Create;
        try
          TStringList(StrList).Sorted := True;
          for J := 0 to List.Count - 1 do
            StrList.Add(List.Items[J]^.PI.Name);
          ComponentsList.Items.AddObject(C.Name, StrList);
        except
          StrList.Free;
          raise;
        end;
      finally
        List.Free;
      end;
    end;

    if StoredProps <> nil then begin
      for I := 0 to StoredProps.Count - 1 do begin
        if ParseStoredItem(StoredProps[I], CompName, PropName) then
          CheckAddItem(CompName, PropName);
      end;
      ListToIndex(StoredList, 0);

      if FDesigner <> nil then
        FDesigner.Modified;
    end;
  end else
    StoredList.Items.Clear;

  UpdateCurrentClass;
  UpdateCurrentProp;
end;

procedure TOvcfrmPropsDlg.CheckAddItem(const CompName, PropName : string);
var
  IdxComp : Integer;
  IdxProp : Integer;
begin
  if FindProp(CompName, PropName, IdxComp, IdxProp) then
    AddItem(IdxComp, IdxProp, True);
end;

procedure TOvcfrmPropsDlg.CheckButtons;
var
  Enable: Boolean;
begin
  AddButton.Enabled := (ComponentsList.ItemIndex >= 0) and
    (PropertiesList.ItemIndex >= 0);
  Enable := (StoredList.Items.Count > 0) and
    (StoredList.ItemIndex >= 0);
  DeleteButton.Enabled := Enable;
  ClearButton.Enabled := Enable;
  UpBtn.Enabled := Enable and (StoredList.ItemIndex > 0);
  DownBtn.Enabled := Enable and (StoredList.ItemIndex < StoredList.Items.Count - 1);
end;

procedure TOvcfrmPropsDlg.ClearButtonClick(Sender : TObject);
begin
  if StoredList.Items.Count > 0 then begin
    SetStoredList(nil);
    if FDesigner <> nil then
      FDesigner.Modified;
  end;
end;

procedure TOvcfrmPropsDlg.ClearLists;
var
  I : Integer;
begin
  for I := 0 to ComponentsList.Items.Count - 1 do
    ComponentsList.Items.Objects[I].Free;

  ComponentsList.Items.Clear;
  ComponentsList.Clear;
  PropertiesList.Clear;
  StoredList.Clear;
end;

procedure TOvcfrmPropsDlg.DeleteButtonClick(Sender : TObject);
begin
  DeleteProp(StoredList.ItemIndex);
end;

procedure TOvcfrmPropsDlg.DeleteProp(I : Integer);
var
  CompName : string;
  PropName : string;
  IdxComp  : Integer;
  IdxProp  : Integer;
  Idx      : Integer;
  StrList  : TStringList;
begin
  Idx := StoredList.ItemIndex;
  if ParseStoredItem(StoredList.Items[I], CompName, PropName) then begin
    StoredList.Items.Delete(I);
    if FDesigner <> nil then
      FDesigner.Modified;
    ListToIndex(StoredList, Idx);
    if not FindProp(CompName, PropName, IdxComp, IdxProp) then begin
      if IdxComp < 0 then begin
        StrList := TStringList.Create;
        try
          StrList.Add(PropName);
          ComponentsList.Items.AddObject(CompName, StrList);
          ComponentsList.ItemIndex := ComponentsList.Items.IndexOf(CompName);
        except
          StrList.Free;
          raise
        end;
      end else begin
        TStrings(ComponentsList.Items.Objects[IdxComp]).Add(PropName);
      end;
      UpdateCurrentClass;
    end;
  end;
end;

procedure TOvcfrmPropsDlg.DownBtnClick(Sender : TObject);
begin
  BoxMoveFocusedItem(StoredList, StoredList.ItemIndex + 1);
  if FDesigner <> nil then
    FDesigner.Modified;
  CheckButtons;
end;

function TOvcfrmPropsDlg.FindProp(const CompName, PropName : string; var IdxComp,
  IdxProp : Integer) : Boolean;
begin
  Result := False;
  IdxComp := ComponentsList.Items.IndexOf(CompName);
  if IdxComp >= 0 then begin
    IdxProp := TStrings(ComponentsList.Items.Objects[IdxComp]).IndexOf(PropName);
    if IdxProp >= 0 then
      Result := True;
  end;
end;

procedure TOvcfrmPropsDlg.FormCreate(Sender: TObject);
begin
  Top := (Screen.Height - Height) div 3;
  Left := (Screen.Width - Width) div 2;
end;

procedure TOvcfrmPropsDlg.FormDestroy(Sender : TObject);
begin
  ClearLists;
end;

procedure TOvcfrmPropsDlg.ListClick(Sender : TObject);
begin
  if Sender = ComponentsList then
    UpdateCurrentClass
  else begin
    UpdateCurrentProp;
    CheckButtons;
  end;
end;

procedure TOvcfrmPropsDlg.ListToIndex(List : TCustomListBox; Idx : Integer);

  procedure SetItemIndex(Index: Integer);
  begin
    if TListBox(List).MultiSelect then
      TListBox(List).Selected[Index] := True;
    List.ItemIndex := Index;
  end;

begin
  if Idx < List.Items.Count then
    SetItemIndex(Idx)
  else if Idx - 1 < List.Items.Count then
    SetItemIndex(Idx - 1)
  else if (List.Items.Count > 0) then
    SetItemIndex(0);
end;

procedure TOvcfrmPropsDlg.PropertiesListDblClick(Sender : TObject);
begin
  if AddButton.Enabled then
    AddButtonClick(nil);
end;

procedure TOvcfrmPropsDlg.SetStoredList(AList: TStrings);
begin
  BuildLists(AList);
  if ComponentsList.Items.Count > 0 then
    ComponentsList.ItemIndex := 0;
  CheckButtons;
end;

procedure TOvcfrmPropsDlg.StoredListClick(Sender : TObject);
begin
  CheckButtons;
end;

procedure TOvcfrmPropsDlg.StoredListDragDrop(Sender, Source : TObject; X,
  Y : Integer);
begin
  BoxMoveFocusedItem(StoredList, StoredList.ItemAtPos(Point(X, Y), True));
  if FDesigner <> nil then
    FDesigner.Modified;
  CheckButtons;
end;

procedure TOvcfrmPropsDlg.StoredListDragOver(Sender, Source : TObject; X,
  Y : Integer; State : TDragState; var Accept : Boolean);
begin
  BoxDragOver(StoredList, Source, X, Y, State, Accept, StoredList.Sorted);
  CheckButtons;
end;

procedure TOvcfrmPropsDlg.StoredListKeyPress(Sender : TObject; var Key : Char);
begin
  DeleteProp(StoredList.ItemIndex);
end;

procedure TOvcfrmPropsDlg.UpBtnClick(Sender : TObject);
begin
  BoxMoveFocusedItem(StoredList, StoredList.ItemIndex - 1);
  if FDesigner <> nil then
    FDesigner.Modified;
  CheckButtons;
end;

procedure TOvcfrmPropsDlg.UpdateCurrentClass;
var
  IdxProp   : Integer;
  TopIdx    : Integer;
  List      : TStrings;
  Component : TComponent;
  CompName  : string;
begin
  IdxProp := PropertiesList.ItemIndex;
  if IdxProp < 0 then
    IdxProp := 0;

  if ComponentsList.Items.Count <= 0 then begin
    PropertiesList.Clear;
    Exit;
  end;

  TopIdx := PropertiesList.TopIndex;

  if (ComponentsList.ItemIndex < 0) then
    ComponentsList.ItemIndex := 0;

  List := TStrings(ComponentsList.Items.Objects[ComponentsList.ItemIndex]);
  if List.Count > 0 then
    PropertiesList.Items := List
  else
    PropertiesList.Clear;

  ListToIndex(PropertiesList, IdxProp);
  PropertiesList.TopIndex := TopIdx;
  CheckButtons;

  {get the currently selected components class name}
  if ComponentsList.ItemIndex > -1 then begin
    CompName := ComponentsList.Items[ComponentsList.ItemIndex];
    Component := TheOwner.FindComponent(CompName);
    if Assigned(Component) then
      lblClassName.Caption := Component.ClassName;
  end;

  ComponentsList.ResetHorizontalScrollbar;
  PropertiesList.ResetHorizontalScrollbar;
  StoredList.ResetHorizontalScrollbar;
end;

procedure TOvcfrmPropsDlg.UpdateCurrentProp;
var
  P         : PExPropInfo;
  IdxProp   : Integer;
  List      : TOvcPropertyList;
  Component : TComponent;
  CompName  : string;
begin
  IdxProp := PropertiesList.ItemIndex;
  if IdxProp < 0 then
    IdxProp := 0;

  if ComponentsList.Items.Count <= 0 then begin
    PropertiesList.Clear;
    Exit;
  end;

  if (ComponentsList.ItemIndex < 0) then
    ComponentsList.ItemIndex := 0;

  CompName := ComponentsList.Items[ComponentsList.ItemIndex];
  Component := TheOwner.FindComponent(CompName);
  List := TOvcPropertyList.Create(Component, tkProperties, '');
  try
    {get the currently selected property data type}
    if List.Count >= IdxProp then begin
      {find this property in the list}
      P := List.Find(PropertiesList.Items[IdxProp]);
      if Assigned(P) then
        {get the data type for this property}
        lblPropType.Caption := GetPropType(P)^.Name
      else
        lblPropType.Caption := '';
    end else
      lblPropType.Caption := '';
  finally
    List.Free;
  end;

  ComponentsList.ResetHorizontalScrollbar;
  PropertiesList.ResetHorizontalScrollbar;
  StoredList.ResetHorizontalScrollbar;
end;


end.
