{*********************************************************}
{*                  OVCDBMDG.PAS 4.06                    *}
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

unit ovcdbmdg;

interface

uses
  UITypes, Windows, Classes, Controls, DB, DBCtrls, Dialogs, ExtCtrls, Forms,
  Graphics, Messages, StdCtrls, SysUtils, OvcConst, OvcData, OvcDlg;

type
  

  TOvcfrmDbMemoDlg = class(TForm)
    btnHelp: TButton;
    Panel1: TPanel;
    Memo: TMemo;
    btnOK: TButton;
    btnCancel: TButton;
    lblReadOnly: TLabel;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
  public
  end;


type
  TOvcDbMemoDialog = class(TOvcBaseDialog)
  protected {private}
    {property variables}
    FDataLink  : TFieldDataLink;
    FMemoFont  : TFont;
    FReadOnly  : Boolean;
    FWordWrap  : Boolean;

    {property methods}
    function GetDataField : string;
    function GetDataSource : TDataSource;
    procedure SetDataField(const value : string);
    procedure SetDataSource(Value : TDataSource);
    procedure SetMemoFont(Value : TFont);

  public
    constructor Create(AOwner : TComponent);
      override;
    destructor Destroy;
      override;
    function ExecuteAction(Action: TBasicAction): Boolean;
      override;
    function UpdateAction(Action: TBasicAction): Boolean;
      override;

    function Execute : Boolean;
      override;

  published
    {properties}
    property Caption;
    property Font;
    property Icon;
    property Options default [doSizeable];
    property Placement;

    property DataField : string
      read GetDataField write SetDataField;
    property DataSource : TDataSource
      read GetDataSource write SetDataSource;
    property MemoFont : TFont
      read FMemoFont write SetMemoFont;
    property ReadOnly : Boolean
      read FReadOnly write FReadOnly default False;
    property WordWrap : Boolean
      read FWordWrap write FWordWrap default True;

    {events}
    property OnHelpClick;
  end;


implementation

{$R *.DFM}


constructor TOvcDbMemoDialog.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  FDataLink := TFieldDataLink.Create;
  FMemoFont := TFont.Create;
  FReadOnly := False;
  FWordWrap := True;
end;

destructor TOvcDbMemoDialog.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;

  FMemoFont.Free;
  FMemoFont := nil;

  inherited Destroy;
end;

function TOvcDbMemoDialog.Execute : Boolean;
var
  F       : TOvcfrmDbMemoDlg;
  Field   : TField;
begin
  F := TOvcfrmDbMemoDlg.Create(Application);
  try
    DoFormPlacement(F);

    {transfer data to memo}
    if (DataSource <> nil) and (Datasource.Dataset <> nil) and
       (DataField <> '') then begin
      Field := Datasource.Dataset.FieldByName(DataField);
      if (Field <> nil) then begin
        if Field is TBlobField then begin
          F.Memo.Lines.Assign(Field)
        end else
          {show simple text for non memo fields}
          F.Memo.Text:= Field.Text;
      end;
    end else
      Field := nil;

    {set memo properties}
    F.Memo.Font := FMemoFont;
    F.Memo.WordWrap := FWordWrap;
    F.Memo.ReadOnly := FReadOnly or (Field = nil) or
                       (not DataSource.DataSet.CanModify) or
                       not (Field is TBlobField);
    if F.Memo.ReadOnly then begin
      F.btnOK.Visible := False;
      F.btnCancel.Caption := GetOrphStr(SCCloseCaption);
    end;
    F.lblReadOnly.Visible := F.Memo.ReadOnly;

    F.btnHelp.Visible := doShowHelp in Options;
    F.btnHelp.OnClick := FOnHelpClick;

    {show the memo form}
    Result := F.ShowModal = mrOK;

    if Result and F.Memo.Modified then begin
      {enter edit mode}
      Field.Dataset.Edit;
      Field.Assign(F.Memo.Lines);
    end;
  finally
    F.Free;
  end;
end;

function TOvcDbMemoDialog.GetDataField : string;
begin
  Result := FDataLink.FieldName;
end;

function TOvcDbMemoDialog.GetDataSource : TDataSource;
begin
  Result:= FDataLink.DataSource;
end;

procedure TOvcDbMemoDialog.SetDataField(const Value : string);
begin
  FDataLink.FieldName := Value;
end;

procedure TOvcDbMemoDialog.SetDataSource(Value : TDataSource);
begin
  FDataLink.DataSource := Value;
end;

procedure TOvcDbMemoDialog.SetMemoFont(Value : TFont);
begin
  FMemoFont.Assign(Value);
end;

function TOvcDbMemoDialog.ExecuteAction(Action : TBasicAction) : Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TOvcDbMemoDialog.UpdateAction(Action : TBasicAction) : Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

{*** TOvcDbMemoDlg ***}

procedure TOvcfrmDbMemoDlg.FormCloseQuery(Sender : TObject; var CanClose : Boolean);
begin
  CanClose := True;
  if Memo.Modified and (ModalResult = mrCancel) then
    if MessageDlg(GetOrphStr(SCCancelQuery), mtConfirmation, [mbYes, mbNo], 0) = mrNo then
      CanClose := False;
end;

end.
