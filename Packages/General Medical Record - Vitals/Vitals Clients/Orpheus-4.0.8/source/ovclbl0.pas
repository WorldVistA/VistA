{*********************************************************}
{*                  OVCLBL0.PAS 4.06                     *}
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

unit ovclbl0;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  ExtCtrls, DesignIntf, DesignEditors, Menus, IniFiles, OvcLbl2, TypInfo, OvcCmbx,
  OvcClrCb, OvcLabel, OvcBase, OvcData;

type
  TfrmOvcLabel = class(TForm)
    Panel1: TPanel;
    OvcLabel: TOvcLabel;
    Button1: TButton;
    Button2: TButton;
    Panel2: TPanel;
    SchemeCb: TComboBox;
    SaveAsBtn: TButton;
    DeleteBtn: TButton;
    Panel3: TPanel;
    GraduateRg: TRadioGroup;
    ShadowRg: TRadioGroup;
    HighlightRg: TRadioGroup;
    FromColorCcb: TOvcColorComboBox;
    HighlightColorCcb: TOvcColorComboBox;
    ShadowColorCcb: TOvcColorComboBox;
    HighlightDirectionLbl: TLabel;
    ShadowDirectionLbl: TLabel;
    FontColorCcb: TOvcColorComboBox;
    Panel4: TPanel;
    FontSizeSb: TScrollBar;
    FontSizeLbl: TLabel;
    HighlightDepthLbl: TLabel;
    ShadowDepthLbl: TLabel;
    ShadowDepthSb: TScrollBar;
    HighlightDepthSb: TScrollBar;
    AppearanceCb: TComboBox;
    ColorSchemeCb: TComboBox;
    OvcController1: TOvcController;
    procedure FontSizeSbChange(Sender: TObject);
    procedure HighlightDepthSbChange(Sender: TObject);
    procedure ShadowDepthSbChange(Sender: TObject);
    procedure GraduateRgClick(Sender: TObject);
    procedure HighlightRgClick(Sender: TObject);
    procedure ShadowRgClick(Sender: TObject);
    procedure FromColorCcbChange(Sender: TObject);
    procedure HighlightColorCcbChange(Sender: TObject);
    procedure ShadowColorCcbChange(Sender: TObject);
    procedure FontColorCcbChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SaveAsBtnClick(Sender: TObject);
    procedure DeleteBtnClick(Sender: TObject);
    procedure SchemeCbChange(Sender: TObject);
    procedure AppearanceCbChange(Sender: TObject);
    procedure ColorSchemeCbChange(Sender: TObject);
  private
  public
    HighlightDirectionDp : TOvcDirectionPicker;
    ShadowDirectionDp : TOvcDirectionPicker;
    SettingScheme : Boolean;
    SettingCb : Boolean;

    procedure DeleteScheme(const S : string);
    procedure HighlightDirectionChange(Sender: TObject);
    procedure ShadowDirectionChange(Sender: TObject);
    procedure SchemeChange;
  end;

type
  {component editor for the notebook pages}
  TOvcLabelEditor = class(TDefaultEditor)
  public
    procedure ExecuteVerb(Index : Integer);
      override;
    function GetVerb(Index : Integer) : String;
      override;
    function GetVerbCount : Integer;
      override;
  end;

  {property editor for the special settings class}
  TOvcCustomSettingsProperty = class(TClassProperty)
  public
    procedure Edit;
      override;
    function GetAttributes : TPropertyAttributes;
      override;
  end;

function EditOvcLabel(L : TOvcLabel) : Boolean;


implementation

uses
  OvcLbl1;

{$R *.DFM}

const
  IniFileName = 'ORPHEUS.INI';

function EditOvcLabel(L : TOvcLabel) : Boolean;
var
  D : TfrmOvcLabel;
begin
  Result := False;
  D := TfrmOvcLabel.Create(Application);
  try
    D.OvcLabel.Font.Assign(L.Font);
    D.OvcLabel.CustomSettings.Assign(L.CustomSettings);

    D.FontSizeSb.Position := L.Font.Size;
    D.HighlightDepthSB.Position := L.CustomSettings.HighlightDepth;
    D.ShadowDepthSB.Position := L.CustomSettings.ShadowDepth;

    D.GraduateRg.ItemIndex := Ord(L.CustomSettings.GraduateStyle);
    D.HighlightRg.ItemIndex := Ord(L.CustomSettings.HighlightStyle);
    D.ShadowRg.ItemIndex := Ord(L.CustomSettings.ShadowStyle);

    D.FontColorCcb.SelectedColor := L.Font.Color;
    D.FromColorCcb.SelectedColor := L.CustomSettings.GraduateFromColor;
    D.HighlightColorCcb.SelectedColor := L.CustomSettings.HighlightColor;
    D.ShadowColorCcb.SelectedColor := L.CustomSettings.ShadowColor;

    D.HighlightDirectionDp.Direction := Ord(L.CustomSettings.HighlightDirection)-1;
    D.ShadowDirectionDp.Direction := Ord(L.CustomSettings.ShadowDirection)-1;

    if D.ShowModal = mrOK then begin
      L.CustomSettings.BeginUpdate;
      try
        L.Font.Assign(D.OvcLabel.Font);
        L.CustomSettings.Assign(D.OvcLabel.CustomSettings);
      finally
        L.CustomSettings.EndUpdate;
      end;
      Result := True;
    end;
  finally
    D.Free;
  end;
end;


{*** TOvcLabelEditor ***}

procedure TOvcLabelEditor.ExecuteVerb(Index : Integer);
begin
  if EditOvcLabel(TOvcLabel(Component)) then
    Designer.Modified;
end;

function TOvcLabelEditor.GetVerb(Index : Integer) : String;
begin
  Result := 'Style Manager...';
end;

function TOvcLabelEditor.GetVerbCount : Integer;
begin
  Result := 1;
end;


{*** TOvcCustomSettingsProperty ***}

procedure TOvcCustomSettingsProperty.Edit;
var
  I : Integer;
  C : TComponent;
  L : TOvcLabel;
  M : TOvcLabel;
begin
  C := TComponent(GetComponent(0));
  if C is TOvcCustomLabel then begin
    L := TOvcLabel(C);
    if EditOvcLabel(L) then begin
      {if more than one component selected, apply changes to others}
      for I := 2 to PropCount do begin
        M := TOvcLabel(GetComponent(Pred(I)));
        M.CustomSettings.BeginUpdate;
        try
          M.Font.Assign(L.Font);
          M.CustomSettings.Assign(L.CustomSettings);
        finally
          M.CustomSettings.EndUpdate;
        end;
        M.Invalidate;
      end;
      Designer.Modified;
    end;
  end;
end;

function TOvcCustomSettingsProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paSubProperties, paMultiSelect, paDialog, paReadOnly]
end;


{*** TOvcLabelFrm ***}

procedure TfrmOvcLabel.FontSizeSbChange(Sender: TObject);
begin
  OvcLabel.Font.Size := FontSizeSb.Position;
  FontSizeLbl.Caption := IntToStr(OvcLabel.Font.Size);
  SchemeChange;
end;

procedure TfrmOvcLabel.HighlightDepthSbChange(Sender: TObject);
begin
  OvcLabel.CustomSettings.HighlightDepth := HighlightDepthSb.Position;
  HighlightDepthLbl.Caption := IntToStr(OvcLabel.CustomSettings.HighlightDepth);
  SchemeChange;
end;

procedure TfrmOvcLabel.ShadowDepthSbChange(Sender: TObject);
begin
  OvcLabel.CustomSettings.ShadowDepth := ShadowDepthSb.Position;
  ShadowDepthLbl.Caption := IntToStr(OvcLabel.CustomSettings.ShadowDepth);
  SchemeChange;
end;

procedure TfrmOvcLabel.GraduateRgClick(Sender: TObject);
begin
  case GraduateRg.ItemIndex of
    0 : OvcLabel.CustomSettings.GraduateStyle := gsNone;
    1 : OvcLabel.CustomSettings.GraduateStyle := gsHorizontal;
    2 : OvcLabel.CustomSettings.GraduateStyle := gsVertical;
  end;
  SchemeChange;
end;

procedure TfrmOvcLabel.HighlightRgClick(Sender: TObject);
begin
  case HighlightRg.ItemIndex of
    0 : OvcLabel.CustomSettings.HighlightStyle := ssPlain;
    1 : OvcLabel.CustomSettings.HighlightStyle := ssExtrude;
    2 : OvcLabel.CustomSettings.HighlightStyle := ssGraduated;
  end;
  SchemeChange;
end;

procedure TfrmOvcLabel.ShadowRgClick(Sender: TObject);
begin
  case ShadowRg.ItemIndex of
    0 : OvcLabel.CustomSettings.ShadowStyle := ssPlain;
    1 : OvcLabel.CustomSettings.ShadowStyle := ssExtrude;
    2 : OvcLabel.CustomSettings.ShadowStyle := ssGraduated;
  end;
  SchemeChange;
end;

procedure TfrmOvcLabel.FromColorCcbChange(Sender: TObject);
begin
  OvcLabel.CustomSettings.GraduateFromColor := FromColorCcb.SelectedColor;
  SchemeChange;
end;

procedure TfrmOvcLabel.HighlightColorCcbChange(Sender: TObject);
begin
  OvcLabel.CustomSettings.HighlightColor := HighlightColorCcb.SelectedColor;
  SchemeChange;
end;

procedure TfrmOvcLabel.ShadowColorCcbChange(Sender: TObject);
begin
  OvcLabel.CustomSettings.ShadowColor := ShadowColorCcb.SelectedColor;
  SchemeChange;
end;

procedure TfrmOvcLabel.FontColorCcbChange(Sender: TObject);
begin
  OvcLabel.Font.Color := FontColorCcb.SelectedColor;
  SchemeChange;
end;

procedure TfrmOvcLabel.FormCreate(Sender: TObject);
var
  Ini : TIniFile;
  A   : TOvcAppearance;
  C   : TOvcColorScheme;
begin
  Top := (Screen.Height - Height) div 3;
  Left := (Screen.Width - Width) div 2;

  {load scheme names into combo box}
  Ini := TIniFile.Create(IniFileName);
  try
    SchemeCb.Items.Clear;
    Ini.ReadSection('Schemes', SchemeCb.Items);
  finally
    Ini.Free;
  end;

  {create direction pickers}
  HighlightDirectionDp := TOvcDirectionPicker.Create(Self);
  HighlightDirectionDp.Top := HighlightDirectionLbl.Top;
  HighlightDirectionDp.Left := HighlightDirectionLbl.Left + HighlightDirectionLbl.Width;
  HighlightDirectionDp.Width := 50;
  HighlightDirectionDp.Height := 50;
  HighlightDirectionDp.NumDirections := 8;
  HighlightDirectionDp.OnChange := HighlightDirectionChange;
  HighlightDirectionDp.Parent := HighlightDirectionLbl.Parent;
  HighlightDirectionDp.Visible := True;

  ShadowDirectionDp := TOvcDirectionPicker.Create(Self);
  ShadowDirectionDp.Top := ShadowDirectionLbl.Top;
  ShadowDirectionDp.Left := ShadowDirectionLbl.Left + ShadowDirectionLbl.Width;
  ShadowDirectionDp.Width := 50;
  ShadowDirectionDp.Height := 50;
  ShadowDirectionDp.NumDirections := 8;
  ShadowDirectionDp.OnChange := ShadowDirectionChange;
  ShadowDirectionDp.Parent := ShadowDirectionLbl.Parent;
  ShadowDirectionDp.Visible := True;

  {initialize appearance and color scheme ComboBoxes using rtti}
  for A := Low(TOvcAppearance) to High(TOvcAppearance) do
    AppearanceCb.Items.Add(GetEnumName(TypeInfo(TOvcAppearance), Ord(A)));
  for C := Low(TOvcColorScheme) to High(TOvcColorScheme) do
    ColorSchemeCb.Items.Add(GetEnumName(TypeInfo(TOvcColorScheme), Ord(C)));
end;

procedure TfrmOvcLabel.SaveAsBtnClick(Sender: TObject);
var
  Ini : TIniFile;
  S   : string;
begin
  with TfrmSaveScheme.Create(Self) do begin
    if (ShowModal = mrOK) and (SchemeNameEd.Text > '') then begin
      S := SchemeNameEd.Text;
      Ini := TIniFile.Create(IniFileName);
      try
        {delete scheme}
        DeleteScheme(S);

        {add scheme name to list of schemes}
        Ini.WriteInteger('Schemes', S, 0);

        {create new scheme section and add values}
        Ini.WriteInteger(S, 'GraduateStyle', Ord(OvcLabel.CustomSettings.GraduateStyle));
        Ini.WriteInteger(S, 'HighlightStyle', Ord(OvcLabel.CustomSettings.HighlightStyle));
        Ini.WriteInteger(S, 'ShadowStyle', Ord(OvcLabel.CustomSettings.ShadowStyle));
        Ini.WriteString(S, 'GraduateFromColor', ColorToString(OvcLabel.CustomSettings.GraduateFromColor));
        Ini.WriteString(S, 'HighlightColor', ColorToString(OvcLabel.CustomSettings.HighlightColor));
        Ini.WriteString(S, 'ShadowColor', ColorToString(OvcLabel.CustomSettings.ShadowColor));
        Ini.WriteInteger(S, 'HighlightDirection', Ord(OvcLabel.CustomSettings.HighlightDirection));
        Ini.WriteInteger(S, 'ShadowDirection', Ord(OvcLabel.CustomSettings.ShadowDirection));
        Ini.WriteString(S, 'FontColor', ColorToString(OvcLabel.Font.Color));
        Ini.WriteString(S, 'FontName', OvcLabel.Font.Name);
        Ini.WriteInteger(S, 'FontPitch', Ord(OvcLabel.Font.Pitch));
        Ini.WriteInteger(S, 'FontSize', OvcLabel.Font.Size);
        Ini.WriteBool(S, 'FontBold', fsBold in OvcLabel.Font.Style);
        Ini.WriteBool(S, 'FontItalic', fsItalic in OvcLabel.Font.Style);
        Ini.WriteBool(S, 'FontUnderline', fsUnderline in OvcLabel.Font.Style);
        Ini.WriteBool(S, 'FontStrikeOut', fsStrikeOut in OvcLabel.Font.Style);
        Ini.WriteInteger(S, 'HighlightDepth', OvcLabel.CustomSettings.HighlightDepth);
        Ini.WriteInteger(S, 'ShadowDepth', OvcLabel.CustomSettings.ShadowDepth);
      finally
        Ini.Free;
      end;

      {add item to the ComboBox, if its not there already}
      if SchemeCb.Items.IndexOf(S) < 0 then
        SchemeCb.Items.Add(S);
    end;
    Free;
  end;
end;

procedure TfrmOvcLabel.DeleteBtnClick(Sender: TObject);
var
  I   : Integer;
begin
  I := SchemeCb.ItemIndex;
  if I > -1 then begin
    DeleteScheme(SchemeCb.Items[I]);
    {delete the entry from the combo box}
    SchemeCb.Items.Delete(I);
  end;
end;

procedure TfrmOvcLabel.DeleteScheme(const S : string);
var
  Ini : TIniFile;
begin
  {delete the scheme entry from the ini file}
  Ini := TIniFile.Create(IniFileName);
  try
    {delete the section}
    Ini.EraseSection(S);
    {delete the scheme name}
    Ini.DeleteKey('Schemes', S);
  finally
    Ini.Free;
  end;
end;

procedure TfrmOvcLabel.SchemeCbChange(Sender: TObject);
var
  I   : Integer;
  Ini : TIniFile;
  S   : string;
begin
  I := SchemeCb.ItemIndex;
  if I > -1 then begin
    S := SchemeCb.Items[I];
    Ini := TIniFile.Create(IniFileName);
    SettingScheme := True;
    try
      OvcLabel.CustomSettings.GraduateStyle := TOvcGraduateStyle(Ini.ReadInteger(S, 'GraduateStyle', 0));
      OvcLabel.CustomSettings.HighlightStyle := TOvcShadeStyle(Ini.ReadInteger(S, 'HighlightStyle', 0));
      OvcLabel.CustomSettings.ShadowStyle := TOvcShadeStyle(Ini.ReadInteger(S, 'ShadowStyle', 0));
      OvcLabel.CustomSettings.GraduateFromColor := StringToColor(Ini.ReadString(S, 'GraduateFromColor', '0'));
      OvcLabel.CustomSettings.HighlightColor := StringToColor(Ini.ReadString(S, 'HighlightColor', '0'));
      OvcLabel.CustomSettings.ShadowColor := StringToColor(Ini.ReadString(S, 'ShadowColor', '0'));
      OvcLabel.CustomSettings.HighlightDirection := TOvcShadeDirection(Ini.ReadInteger(S, 'HighlightDirection', 0));
      OvcLabel.CustomSettings.ShadowDirection := TOvcShadeDirection(Ini.ReadInteger(S, 'ShadowDirection', 0));
      OvcLabel.CustomSettings.HighlightDepth := Ini.ReadInteger(S, 'HighlightDepth', 1);
      OvcLabel.CustomSettings.ShadowDepth := Ini.ReadInteger(S, 'ShadowDepth', 1);

      OvcLabel.Font.Color := StringToColor(Ini.ReadString(S, 'FontColor', '0'));
      OvcLabel.Font.Name := Ini.ReadString(S, 'FontName', 'Times New Roman');
      OvcLabel.Font.Pitch := TFontPitch(Ini.ReadInteger(S, 'FontPitch', 0));
      OvcLabel.Font.Size := Ini.ReadInteger(S, 'FontSize', 10);
      OvcLabel.Font.Style := [];
      if Ini.ReadBool(S, 'FontBold', False) then
        OvcLabel.Font.Style := OvcLabel.Font.Style + [fsBold];
      if Ini.ReadBool(S, 'FontItalic', False) then
        OvcLabel.Font.Style := OvcLabel.Font.Style + [fsItalic];
      if Ini.ReadBool(S, 'FontUnderline', False) then
        OvcLabel.Font.Style := OvcLabel.Font.Style + [fsUnderline];
      if Ini.ReadBool(S, 'FontStrikeOut', False) then
        OvcLabel.Font.Style := OvcLabel.Font.Style + [fsStrikeOut];

      FontSizeSb.Position := OvcLabel.Font.Size;
      HighlightDepthSB.Position := OvcLabel.CustomSettings.HighlightDepth;
      ShadowDepthSB.Position := OvcLabel.CustomSettings.ShadowDepth;
      GraduateRg.ItemIndex := Ord(OvcLabel.CustomSettings.GraduateStyle);
      HighlightRg.ItemIndex := Ord(OvcLabel.CustomSettings.HighlightStyle);
      ShadowRg.ItemIndex := Ord(OvcLabel.CustomSettings.ShadowStyle);
      FontColorCcb.SelectedColor := OvcLabel.Font.Color;
      FromColorCcb.SelectedColor := OvcLabel.CustomSettings.GraduateFromColor;
      HighlightColorCcb.SelectedColor := OvcLabel.CustomSettings.HighlightColor;
      ShadowColorCcb.SelectedColor := OvcLabel.CustomSettings.ShadowColor;
      HighlightDirectionDp.Direction := Ord(OvcLabel.CustomSettings.HighlightDirection)-1;
      ShadowDirectionDp.Direction := Ord(OvcLabel.CustomSettings.ShadowDirection)-1;
    finally
      SettingScheme := False;
      Ini.Free;
    end;
  end;
end;

procedure TfrmOvcLabel.HighlightDirectionChange(Sender: TObject);
begin
  OvcLabel.CustomSettings.HighlightDirection :=
    TOvcShadeDirection(HighlightDirectionDp.Direction+1);
  SchemeChange;
end;

procedure TfrmOvcLabel.ShadowDirectionChange(Sender: TObject);
begin
  OvcLabel.CustomSettings.ShadowDirection :=
    TOvcShadeDirection(ShadowDirectionDp.Direction+1);
  SchemeChange;
end;

procedure TfrmOvcLabel.SchemeChange;
begin
  if not SettingScheme then
    SchemeCb.ItemIndex := -1;

  if not SettingCb then begin
    AppearanceCb.ItemIndex := -1;
    ColorSchemeCb.ItemIndex := -1;
  end;
end;


procedure TfrmOvcLabel.AppearanceCbChange(Sender: TObject);
begin
  if AppearanceCb.ItemIndex > -1 then begin
    SettingScheme := True;
    SettingCb := True;
    try
      OvcLabel.Appearance := TOvcAppearance(AppearanceCb.ItemIndex);

      FontSizeSb.Position := OvcLabel.Font.Size;
      HighlightDepthSB.Position := OvcLabel.CustomSettings.HighlightDepth;
      ShadowDepthSB.Position := OvcLabel.CustomSettings.ShadowDepth;
      GraduateRg.ItemIndex := Ord(OvcLabel.CustomSettings.GraduateStyle);
      HighlightRg.ItemIndex := Ord(OvcLabel.CustomSettings.HighlightStyle);
      ShadowRg.ItemIndex := Ord(OvcLabel.CustomSettings.ShadowStyle);
      FontColorCcb.SelectedColor := OvcLabel.Font.Color;
      FromColorCcb.SelectedColor := OvcLabel.CustomSettings.GraduateFromColor;
      HighlightColorCcb.SelectedColor := OvcLabel.CustomSettings.HighlightColor;
      ShadowColorCcb.SelectedColor := OvcLabel.CustomSettings.ShadowColor;
      HighlightDirectionDp.Direction := Ord(OvcLabel.CustomSettings.HighlightDirection)-1;
      ShadowDirectionDp.Direction := Ord(OvcLabel.CustomSettings.ShadowDirection)-1;
    finally
      SettingCb := False;
      SettingScheme := False;
    end;
  end;
end;

procedure TfrmOvcLabel.ColorSchemeCbChange(Sender: TObject);
begin
  if ColorSchemeCb.ItemIndex > -1 then begin
    SettingScheme := True;
    SettingCb := True;
    try
      OvcLabel.ColorScheme := TOvcColorScheme(ColorSchemeCb.ItemIndex);

      FontSizeSb.Position := OvcLabel.Font.Size;
      HighlightDepthSB.Position := OvcLabel.CustomSettings.HighlightDepth;
      ShadowDepthSB.Position := OvcLabel.CustomSettings.ShadowDepth;
      GraduateRg.ItemIndex := Ord(OvcLabel.CustomSettings.GraduateStyle);
      HighlightRg.ItemIndex := Ord(OvcLabel.CustomSettings.HighlightStyle);
      ShadowRg.ItemIndex := Ord(OvcLabel.CustomSettings.ShadowStyle);
      FontColorCcb.SelectedColor := OvcLabel.Font.Color;
      FromColorCcb.SelectedColor := OvcLabel.CustomSettings.GraduateFromColor;
      HighlightColorCcb.SelectedColor := OvcLabel.CustomSettings.HighlightColor;
      ShadowColorCcb.SelectedColor := OvcLabel.CustomSettings.ShadowColor;
      HighlightDirectionDp.Direction := Ord(OvcLabel.CustomSettings.HighlightDirection)-1;
      ShadowDirectionDp.Direction := Ord(OvcLabel.CustomSettings.ShadowDirection)-1;
    finally
      SettingCb := False;
      SettingScheme := False;
    end;
  end;
end;

end.
