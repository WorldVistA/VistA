{*********************************************************}
{*                  OVCOUTLE.PAS 4.06                    *}
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

unit Ovcoutle;
{property editor for the outline Items property}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, OvcBase, OvcVLB, OvcOutln, ExtCtrls, OvcEditF, OvcEdPop, OvcEdSld,
  OvcData, DesignIntf, DesignEditors;

type
  TOvcfrmOLItemsEditor = class(TForm)
    OvcController1: TOvcController;
    GroupBox1: TGroupBox;
    OvcOutline1: TOvcOutline;
    btnNewItem: TButton;
    btnNewSubItem: TButton;
    btnDelete: TButton;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    edtText: TEdit;
    Label2: TLabel;
    rgStyle: TRadioGroup;
    btnOk: TButton;
    btnCancel: TButton;
    btnApply: TButton;
    OvcSliderEdit1: TOvcSliderEdit;
    chkChecked: TCheckBox;
    rgMode: TRadioGroup;
    procedure btnNewItemClick(Sender: TObject);
    procedure btnNewSubItemClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OvcOutline1ActiveChange(Sender: TOvcCustomOutline; OldNode,
      NewNode: TOvcOutlineNode);
    procedure rgStyleClick(Sender: TObject);
    procedure chkCheckedClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure OvcSliderEdit1Change(Sender: TObject);
    procedure edtTextExit(Sender: TObject);
  private
    FCurRoot: TOvcOutlineNode;
    procedure SetCurRoot(const Value: TOvcOutlineNode);
  public
    EditOutline : TOvcCustomOutline;
    Dsgn : IDesigner;
    property CurRoot : TOvcOutlineNode read FCurRoot write SetCurRoot;
  end;

  {property editor for the outline's items property}
  TOvcOutlineItemsProperty = class(TPropertyEditor)
  public
    procedure Edit;
      override;
    function GetAttributes : TPropertyAttributes;
      override;
    function GetValue : string;
      override;
  end;

  {component editor for the outline}
  TOvcOutlineEditor = class(TDefaultEditor)
  public
    procedure ExecuteVerb(Index : Integer);
      override;
    function GetVerb(Index : Integer) : String;
      override;
    function GetVerbCount : Integer;
      override;
  end;

var
  OvcfrmOLItemsEditor: TOvcfrmOLItemsEditor;

implementation

{$R *.DFM}

procedure TOvcfrmOLItemsEditor.btnNewItemClick(Sender: TObject);
begin
  btnNewItem.SetFocus; {force edit to update item}
  if CurRoot <> nil then
    CurRoot := OvcOutline1.Nodes.AddChild(CurRoot.Parent, '')
  else
    CurRoot := OvcOutline1.Nodes.Add('');
  OvcOutline1.ActiveNode := CurRoot;
  edtText.SetFocus;
end;

procedure TOvcfrmOLItemsEditor.btnNewSubItemClick(Sender: TObject);
var
  Parent,NewRoot : TOvcOutlineNode;
begin
  if CurRoot <> nil then begin
    Parent := CurRoot;
    NewRoot := OvcOutline1.Nodes.AddChild(CurRoot, '');
    Parent.Expanded := True;
    OvcOutline1.ActiveNode := NewRoot;
    edtText.SetFocus;
  end;
end;

procedure TOvcfrmOLItemsEditor.SetCurRoot(const Value: TOvcOutlineNode);
begin
  if Value <> FCurRoot then begin
    if Value = nil then begin
      if (CurRoot <> nil) and (CurRoot <> Pointer(Self)) then
        CurRoot.Text := edtText.Text;
      FCurRoot := nil;
      btnNewSubItem.Enabled := False;
      btnDelete.Enabled := False;
      edtText.Enabled := False;
      edtText.Text := '';
      rgStyle.Enabled := False;
      rgStyle.ItemIndex := -1;
      rgMode.Enabled := False;
      rgMode.ItemIndex := -1;
      OvcSliderEdit1.Enabled := False;
      OvcSliderEdit1.AsInteger := 0;
      OvcSliderEdit1.PopupMin := 0;
      OvcSliderEdit1.PopupMax := 1;
    end else begin
      FCurRoot := Value;
      btnNewSubItem.Enabled := True;
      btnDelete.Enabled := True;
      edtText.Enabled := True;
      edtText.Text := Value.Text;
      rgStyle.Enabled := True;
      rgStyle.ItemIndex := ord(Value.Style);
      rgMode.Enabled := True;
      rgMode.ItemIndex := ord(Value.Mode);
      OvcSliderEdit1.AsInteger := Value.ImageIndex;
      if (Value.Outline.Images <> nil)
      and (Value.Outline.Images.Count > 0) then begin
        OvcSliderEdit1.Enabled := True;
        OvcSliderEdit1.PopupMax := Value.Outline.Images.Count;
        OvcSliderEdit1.PopupMin := -1;
      end;
      chkChecked.Enabled := CurRoot.Style <> osPlain;
      chkChecked.Checked := CurRoot.Checked;
    end;
  end;
end;

procedure TOvcfrmOLItemsEditor.FormShow(Sender: TObject);
begin
  OvcSliderEdit1.AsInteger := -1;
  FCurRoot := Pointer(Self);
  CurRoot := nil;
end;

procedure TOvcfrmOLItemsEditor.OvcOutline1ActiveChange(Sender: TOvcCustomOutline;
  OldNode, NewNode: TOvcOutlineNode);
begin
  CurRoot := NewNode;
end;

procedure TOvcfrmOLItemsEditor.rgStyleClick(Sender: TObject);
begin
  if CurRoot <> nil then begin
    CurRoot.Style := TOvcOlNodeStyle(rgStyle.ItemIndex);
    chkChecked.Enabled := CurRoot.Style <> osPlain;
    chkChecked.Checked := CurRoot.Checked;
  end;
end;

procedure TOvcfrmOLItemsEditor.chkCheckedClick(Sender: TObject);
begin
  if CurRoot <> nil then
    CurRoot.Checked := chkChecked.Checked;
end;

procedure TOvcfrmOLItemsEditor.btnDeleteClick(Sender: TObject);
var
  DelRoot : TOvcOutlineNode;
begin
  if CurRoot <> nil then begin
    DelRoot := CurRoot;
    CurRoot := nil;
    DelRoot.Free;
  end;
end;

procedure TOvcfrmOLItemsEditor.btnApplyClick(Sender: TObject);
begin
  EditOutline.Nodes.Assign(OvcOutline1.Nodes);
end;

procedure ShowOutlineItemsEditor(Des : IDesigner; Outline : TOvcCustomOutline);
begin
  with TOvcfrmOLItemsEditor.Create(Application) do
    try
      Caption := 'Node Editor';
      EditOutline := Outline;
      Dsgn := Des;
      OvcOutline1.Nodes.Assign(EditOutline.Nodes);
      OvcOutline1.Images := EditOutline.Images;
      if ShowModal = mrOK then
        EditOutline.Nodes.Assign(OvcOutline1.Nodes);
    finally
      Free;
    end;
end;

{*** TOvcOutlineItemsProperty ***}

function TOvcOutlineItemsProperty.GetAttributes : TPropertyAttributes;
begin
  Result := [paDialog];
end;

function TOvcOutlineItemsProperty.GetValue: string;
begin
  Result := '(' + TOvcOutlineNodes(GetOrdValueAt(0)).ClassName + ')';
end;

procedure TOvcOutlineItemsProperty.Edit;
begin
  ShowOutlineItemsEditor(Designer, GetComponent(0) as TOvcCustomOutline);
end;

{*** TOvcOutlineEditor ***}

procedure TOvcOutlineEditor.ExecuteVerb(Index : Integer);
begin
  ShowOutlineItemsEditor(Designer, Component as TOvcCustomOutline);
end;

function TOvcOutlineEditor.GetVerb(Index : Integer) : String;
begin
  case Index of
    0 : Result := 'Edit Nodes...';
  else
    Result := '?';
  end;
end;

function TOvcOutlineEditor.GetVerbCount : Integer;
begin
  Result := 1;
end;

procedure TOvcfrmOLItemsEditor.OvcSliderEdit1Change(Sender: TObject);
begin
  try
    if CurRoot <> nil then
      CurRoot.ImageIndex := OvcSliderEdit1.AsInteger;
  except
  end;
end;

procedure TOvcfrmOLItemsEditor.edtTextExit(Sender: TObject);
begin
  if CurRoot <> nil then
    CurRoot.Text := edtText.Text;
end;

end.
