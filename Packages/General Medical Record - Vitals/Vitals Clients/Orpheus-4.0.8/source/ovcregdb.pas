{*********************************************************}
{*                  OVCREGDB.PAS 4.06                    *}
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

{$R OVCREGDB.RES}

unit ovcregdb;
  {-Registration unit for the Orpheus DB-Aware Components}

interface

uses
  Windows, Classes, DesignIntf, DesignEditors, Forms, SysUtils;

procedure Register;

implementation

uses
  OvcAbot0,  {about form and About property editor}
  OvcVer,
  OvcData,
  OvcAE,     {array editors}
  OvcDBAE,   {data aware array editors}
  OvcDbAE0,  {dbae range property editor form}
  OvcDbAE1,  {simple picture mask property editor}
  OvcDbAE2,  {picture picture mask property editor}
  OvcDbAE3,  {numeric picture mask property editor}
  OvcDbCL,   {data aware column list}
  OvcDbEd,   {data aware editor}
  OvcEFPE,   {range property editor}
  OvcFNPE,
  OvcNFPE,   {numeric mask property editor}
  OvcPFPE,   {picture mask property editor form}
  OvcSFPE,   {simple field property editor}
  OvcTbCls,  {table columns (for property editor)}
  OvcDbTbl,  {data aware table}
  OvcDbTb0,  {data aware table columns editor}
  OvcDbSF,   {data aware simple field}
  OvcDbPF,   {data aware picture field}
  OvcDbNF,   {data aware numeric field}
  OvcDbCal,  {data aware calendar}
  OvcDbClk,  {data aware clock}
  OvcDbPLb,  {db picture label}
  OvcDbDLb,  {db display label}
  OvcDbISE,  {db incremental search edit component}
  OvcDbNum,  {db number edit field w/ popup calculator}
  OvcDbDat,  {db date edit field w/ popup calendar}
  OvcDbTim,  {db date edit field w/ popup}
  OvcDbIdx,  {db index selection component}
  OvcDbMDg,  {db memo dialog component}
  OvcDbACb,  {db alias ComboBox}
  OvcDbFCb,  {db field ComboBox}
  OvcDbTCb,  {db table name ComboBox}
  OvcDbSld,  {db slider control}
  OvcDbCCb,  {db color ComboBox}
  OvcDbSEd,  {db slider edit control}
  OvcDbRpV,  {db report view}
  O32dbfe;   {db Flex Edit}

type
  {component editor for the table}
  TOvcDbTableEditor = class(TDefaultEditor)
  public
    procedure ExecuteVerb(Index : Integer);
      override;
    function GetVerb(Index : Integer) : String;
      override;
    function GetVerbCount : Integer;
      override;
  end;


{*** TOvcTableEditor ***}

procedure TOvcDbTableEditor.ExecuteVerb(Index : Integer);
var
  Table : TOvcDbTable;
  C     : TOvcfrmDbColEditor;
begin
  Table := TOvcDbTable(Component);
  if Index = 0 then begin
    C := TOvcfrmDbColEditor.Create(Application);
    try
      C.Editor := Self;
      C.SetCols(TOvcTableColumns(Table.Columns));
      C.ShowModal;
      Designer.Modified;
    finally
      C.Free;
    end;
  end;
end;

function TOvcDbTableEditor.GetVerb(Index : Integer) : String;
begin
  Result := 'Columns Editor...';
end;

function TOvcDbTableEditor.GetVerbCount : Integer;
begin
  Result := 1;
end;


{*** component registration ***}

procedure Register;
begin
  {register property editors for the data aware entry fields}
  RegisterPropertyEditor(
    TypeInfo(Char), TOvcDbSimpleField, 'PictureMask',
    TSimpleMaskProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOvcDbPictureField, 'PictureMask',
    TPictureMaskProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOvcDbNumericField, 'PictureMask',
    TNumericMaskProperty);

  RegisterPropertyEditor(
    TypeInfo(string), TOvcDbSimpleArrayEditor, 'PictureMask',
    OvcDbAE1.TDbAESimpleMaskProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOvcDbPictureArrayEditor, 'PictureMask',
    OvcDbAE2.TDbAEPictureMaskProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOvcDbNumericArrayEditor, 'PictureMask',
    OvcDbAE3.TDbAENumericMaskProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOvcDbSimpleArrayEditor, 'RangeHi', TDbAeRangeProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOvcDbSimpleArrayEditor, 'RangeLo', TDbAeRangeProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOvcDbPictureArrayEditor, 'RangeHi', TDbAeRangeProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOvcDbPictureArrayEditor, 'RangeLo', TDbAeRangeProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOvcDbNumericArrayEditor, 'RangeHi', TDbAeRangeProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOvcDbNumericArrayEditor, 'RangeLo', TDbAeRangeProperty);

  RegisterPropertyEditor(
    TypeInfo(string), TOvcDbSimpleField, 'RangeHi',
    OvcEfPe.TEfRangeProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOvcDbSimpleField, 'RangeLo',
    OvcEfPe.TEfRangeProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOvcDbPictureField, 'RangeHi',
    OvcEfPe.TEfRangeProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOvcDbPictureField, 'RangeLo',
    OvcEfPe.TEfRangeProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOvcDbNumericField, 'RangeHi',
    OvcEfPe.TEfRangeProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOvcDbNumericField, 'RangeLo',
    OvcEfPe.TEfRangeProperty);

  {register property editor for About property}
  RegisterPropertyEditor(
    TypeInfo(string), TOvcDbIndexSelect, 'About', TOvcAboutProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOvcDbSearchEdit, 'About', TOvcAboutProperty);

  RegisterPropertyEditor(
    TypeInfo(string), TOvcDbIndexSelect, 'About', TOvcAboutProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOvcDbSearchEdit, 'About', TOvcAboutProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOvcDbAliasComboBox, 'About', TOvcAboutProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOvcDbTableNameComboBox, 'About', TOvcAboutProperty);

  RegisterPropertyEditor(
    TypeInfo(TOvcTableColumns), TOvcDbTable, '', TOvcDbTableColumnProperty);

  {register component editor for the table}
  RegisterComponentEditor(TOvcDbTable, TOvcDbTableEditor);

  {register DB components part 1}
  RegisterComponents('Orpheus db', [
    TOvcDbReportView,
    TOvcDbSlider,
    TOvcDbSliderEdit,
    TOvcDbSearchEdit,
    TOvcDbIndexSelect,
    TOvcDbColumnList,
    TOvcDbCalendar,
    TOvcDbClock,
    TOvcDbFieldComboBox,
    TOvcDbAliasComboBox,
    TOvcDbTableNameComboBox,
    TOvcDbColorComboBox,
    TOvcDbMemoDialog,
    TOvcDbSimpleField,
    TOvcDbPictureField,
    TOvcDbNumericField,
    TO32DbFlexEdit,
    TOvcDbEditor,
    TOvcDbTable,
    TOvcDbPictureLabel,
    TOvcDbDisplayLabel
    ]);


  {register Deprecated DB components}
  RegisterComponents('Orpheus Deprecated', [
    TOvcDbDateEdit,
    TOvcDbTimeEdit,
    TOvcDbNumberEdit,
    TOvcDbSimpleArrayEditor,
    TOvcDbPictureArrayEditor,
    TOvcDbNumericArrayEditor
    ]);

end;

end.
