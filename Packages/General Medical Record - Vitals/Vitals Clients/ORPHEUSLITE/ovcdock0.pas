{*********************************************************}
{*                  OVCDOCK0.PAS 4.06                    *}
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

unit ovcdock0;
  {-component editor to dock control to others}

interface

uses
  Windows, Classes, Controls,
  {$IFDEF VERSION6} DesignIntf, DesignEditors, {$ELSE} DsgnIntf, {$ENDIF}
  Forms, StdCtrls, SysUtils, OvcData, ExtCtrls;

type
  TOvcfrmDock = class(TForm)
    lbComponentList: TListBox;
    lblClassName: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    rgPosition: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure lbComponentListClick(Sender: TObject);
    procedure lbComponentListDblClick(Sender: TObject);
  private
  public
    procedure BuildComponentList(Form : TCustomForm; Control : TControl);
  end;

  TOvcDockingEditor = class(TDefaultEditor)
    procedure ExecuteVerb(Index : Integer);
      override;
    function GetVerb(Index : Integer) : string;
      override;
    function GetVerbCount : Integer;
      override;
  end;


procedure DisplayDockWithDialog(Control : TControl);


implementation

{$R *.DFM}

procedure DisplayDockWithDialog(Control : TControl);
var
  PF : TForm;
  DC : TControl;
begin
  with TOvcfrmDock.Create(Application) do
    try
      PF := TForm(GetParentForm(Control));
      BuildComponentList(PF, Control);
      if (ShowModal = mrOK) and (lbComponentList.ItemIndex > -1) then begin
        DC := TControl(lbComponentList.Items.Objects[lbComponentList.ItemIndex]);
        case rgPosition.ItemIndex of
          0 : {left}
            Control.SetBounds(DC.Left-Control.Width, DC.Top, Control.Width, DC.Height);
          1 : {right}
            Control.SetBounds(DC.Left+DC.Width, DC.Top, Control.Width, DC.Height);
          2 : {top}
            Control.SetBounds(DC.Left, DC.Top-Control.Height, DC.Width, Control.Height);
          3 : {bottom}
            Control.SetBounds(DC.Left, DC.Top+DC.Height, DC.Width, Control.Height);
        end;
      end;
    finally
      Free;
    end;
end;

procedure TOvcfrmDock.BuildComponentList(Form : TCustomForm; Control : Tcontrol);
var
  I : Integer;
  C : TComponent;
begin
  lbComponentList.Clear;
  if Form <> nil then begin
    for I := 0 to Form.ComponentCount - 1 do begin
      C := Form.Components[I];
      if (C = Control) or (C.Name = '') then
        Continue;
      lbComponentList.Items.AddObject(C.Name, C);
    end;
  end;
end;


{*** TOvcDockingEditor ***}

procedure TOvcDockingEditor.ExecuteVerb(Index : Integer);
begin
  if Index = 0 then
    DisplayDockWithDialog(TControl(Component));
end;

function TOvcDockingEditor.GetVerb(Index : Integer) : string;
begin
  Result := 'Dock With...';
end;

function TOvcDockingEditor.GetVerbCount : Integer;
begin
  Result := 1;
end;


{*** TfrmDock ***}

procedure TOvcfrmDock.FormCreate(Sender: TObject);
begin
  Top := (Screen.Height - Height) div 3;
  Left := (Screen.Width - Width) div 2;
  lblClassName.Caption := '';
end;

procedure TOvcfrmDock.btnOKClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TOvcfrmDock.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TOvcfrmDock.lbComponentListClick(Sender: TObject);
var
  I : Integer;
begin
  {get the currently selected control's class name}
  I := lbComponentList.ItemIndex;
  if I > -1 then
    lblClassName.Caption := lbComponentList.Items.Objects[I].ClassName;
end;

procedure TOvcfrmDock.lbComponentListDblClick(Sender: TObject);
begin
  lbComponentListClick(Sender);
  btnOkClick(Sender);
end;

end.
