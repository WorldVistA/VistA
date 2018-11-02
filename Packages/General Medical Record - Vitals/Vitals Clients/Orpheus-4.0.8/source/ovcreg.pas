{*********************************************************}
{*                   OVCREG.PAS 4.06                     *}
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

{$R OVCREG.RES}
{$R OVCREG2.RES}

{Changes}

{ 08/06/01 - PHB
  - The property editor for TO32Collection accidentally registered itself for
    TCollection types. Therefore, TypeInfo(TCollection) was changed to
    TypeInfo(TO32Collection).}

unit ovcreg;
  {-Registration unit for the Orpheus components}

interface

uses
  DIALOGS, Windows, DesignIntf, DesignEditors, VCLEditors, Classes, Controls, TypInfo,
  OvcData, OvcValid, OvcConst;

type
  {property editor for the virtual ListBox header string property}
  TOvcHeaderProperty = class(TCaptionProperty);

type
  {property editor for the timer pool}
  TOvcTimerPoolEditor = class(TDefaultEditor)
  protected
    procedure EditProperty(const Prop: IProperty; var Continue: Boolean); override;
  end;

type

  {property editor to preculde listing components of the same base class}
  TExcludeComponentProperty = class(TComponentProperty)
  public
    procedure GetValues(Proc : TGetStrProc); override;
  end;

{ TorGenericStringProperty}
type
  TorGenericStringProperty = class(TStringProperty)
  protected
    procedure GetValueList(List: TStrings); virtual; abstract;
  public
    procedure GetValues(Proc: TGetStrProc); override;
    function  GetAttributes: TPropertyAttributes; override;
  end;

procedure Register;

implementation

uses
  SysUtils, Forms, Graphics,
  OvcBase,                {base classes}
  OvcBordr,               {simple borders for entry controls}
  OvcAbot0,               {about dialog and about property editor}
  OvcABtn,                {attached button}
  OvcAE,                  {array editors}
  OvcAEPE,                {array editor property editors}
  OvcBCKLB,               {old style check list box}
  OvcBEdit,               {bordered OvcEdit control}
  OvcBCalc,               {bordered OvcNumberEdit control}
  OvcBCldr,               {bordered OvcDateEdit control}
  OvcBTime,               {bordered OvcTimeEdit control}
  OvcEF,                  {base entry field class--needed for sf, pf, nf, and ae}
  OvcEFPE,                {range property editor}
  OvcSF,                  {simple field component}
  OvcSFPE,                {simple mask property editor form}
  OvcPF,                  {picture field component}
  OvcPFPE,                {picture mask property editor form}
  OvcNF,                  {numeric entry field component}
  OvcNFPE,                {numeric mask property editor}
  OvcNbk,                 {tab control component}
  OvcNbk0,                {tab control component editor}
  OvcCal,                 {calendar component}
  OvcEdCal,               {date edit field with popup calendar}
  OvcEdTim,               {time edit field with popup}
  OvcClock,               {clock component}
  OvcColr0,               {color property editor}
  OvcCmbx,                {mru ComboBox}
  OvcFtCbx,               {font ComboBox}
  OvcFmCbx,               {file association ComboBox}
  OvcFlCbx,               {file ComboBox}
  OvcDrCbx,               {directory ComboBox}
  OvcDvCbx,               {drive ComboBox}
  OvcHsCbx,               {history ComboBox}
  OvcPrCbx,               {printer ComboBox}
  OvcClrCb,               {color ComboBox}
  OvcViewr,               {viewer and text file viewer components}
  OvcMeter,               {meter component}
  OvcPeakM,               {Peak meter component}
  OvcSC,                  {spin components}
  OvcTimer,               {timer pool}
  OvcRLbl,                {rotated label component}
  OvcEdit,                {editor and text editor components}
  OvcXfer,                {form data transfer component}
  OvcXfrC0,               {transfer component component editor}
  OvcFxFnt,               {fixed font class}
  OvcFxFPE,               {fixed font property editor}
  OvcFNPE,                {file name property editor}
  OvcPLb,                 {picture label}
  OvcCkLb,                {checked item ListBox component}
  OvcISLb,                {incremental search ListBox component}
  OvcBtnHd,               {button header component}
  OvcBtnH0,               {button header component editor}
  OvcColE0,               {Collection editor}
  OvcSplit,               {splitter component}
  OvcLkOut,               {LookOut Bar component}
  OvcLkOu0,               {component editor for the LookOutBar}
  OvcCalc,                {calculator component}
  OvcEdClc,               {edit field with popup calculator}
  OvcEditF,               {orpheus edit field}
  OvcFSC,                 {flat spinners}
  OvcURL,                 {url component}
  OvcLB,                  {tab stop version of ListBox}
  OvcState,               {form and component state componets}
  OvcStat0,               {form and component state property editors}
  OvcFiler,               {filer class (for OvcState)}
  OvcStore,               {storage components (for OvcState)}
  OvcSpeed,               {speed button component}
  OvcDock0,               {docking component editor}
  OvcMRU,                 {MRU file list component}
  OvcTCell,               {table cell}
  OvcTable,               {table component}
  OvcTbPE1,               {table property editor}
  OvcTbPE2,               {table property editor}
  OvcTCPE,                {table cell property editor}
  OvcTbRws,               {table rows}
  OvcTbCls,               {table columns}
  OvcTCEdt,               {table cell}
  OvcTCEdtHTMLText,       {table cell}
  OvcTCHdr,               {table cell}
  OvcTCBmp,               {table cell}
  OvcTCGly,               {table cell}
  OvcTCBox,               {table cell}
  OvcTCSim,               {table cell}
  OvcTCPic,               {table cell}
  OvcTCNum,               {table cell}
  OvcTCCBx,               {table cell}
  OvcTCCheckCBx,          {table cell}
  OvcTCIco,               {table cell}
  ovctccustomedt,         {table cell}
  OvcLabel,               {custom label component}
  OvcLbl0,                {property editor for label control}
  OvcCalDg,               {calendar dialog component}
  OvcClcDg,               {calculator dialog component}
  OvcClkDg,               {clock dialog component}
  OvcMoDg,                {memo dialog component}
  OvcSplDg,               {splash screen dialog}
  OvcSlide,               {slider component}
  OvcEdSld,               {number edit slider}
  OvcVLB,                 {virtual list box component}
  OvcOutlE,               {Nodes property editor for the outline}
  OvcOutln,               {Outline component}
  OvcDRpVw,               {report view component with data wrapper}
  OvcDRpVE,               {data report view items property editor}
  OvcRptVw,               {report view component}
  OvcRVIdx,               {report view indexer and common types}
  OvcRvCEd,               {component editor for report view component}
  OvcRvCbx,               {report view view selection combo box}
  OvcRvPDg,               {print dialog for the report views}
  OvcCmd,                 {command processor}
  OvcCmdP0,               {command processor property editor}
  OvcVer,                 {version unit}
  O32ColEd,               {New TO32Collection Editor}
  O32IGridItemEd,         {New InspectorGrid Items Property Editor}
  O32LkOut,               {New LookoutBar for Orpheus 4}
  O32LobEd,               {component editor for the O32LookoutBar}
  O32TCFlx,               {table cell}
  O32FlxEd,               {flexedit component}
  O32FlxBn,               {flexbutton component}
  O32ImgFm,               {imageform component}
  O32sbar,                {StatusBar Component}
  O32IGridEditor1,        {InspectorGrid component editor}
  O32IGrid,               {InspectorGrid component}
  O32Vldtr,               {Validator base classes}
  O32RxVld,               {RegExValidator}
  O32VlReg,               {Validator Registration Unit}
  O32VlOp1,               {ValidatorOptions Class}
  O32VldPE,               {Property Editor for the Regex Sample Expressions}
  O32VPool,               {ValidatorPool Component}
  O32Ovldr,               {Orpheus mask validator}
  O32Pvldr,               {Paradox mask validator}
  OvcTCHeaderExtended;    {Extended table header}

function TorGenericStringProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList, paSortList, paMultiSelect];
end;

procedure TorGenericStringProperty.GetValues(Proc: TGetStrProc);
var
  i      : Integer;
  Values : TStringList;
begin
  Values := TStringList.Create;
  try
    Values.BeginUpdate;
    try
      GetValueList(Values);
      for i := 0 to Pred(Values.Count) do
        Proc(Values[i]);
    finally
      Values.EndUpdate;
    end;
  finally
    Values.Free;
  end;
end;


{*** TorRegisteredValidatorsProperty ***}

type
  TorRegisteredValidatorsProperty = class(TorGenericStringProperty)
    public
      procedure GetValueList(List: TStrings); override;
  end;

procedure TorRegisteredValidatorsProperty.GetValueList(List: TStrings);
begin
  GetRegisteredValidators(List);
end;


{*** TOvcTimerPoolEditor ***}

procedure TOvcTimerPoolEditor.EditProperty(const Prop    : IProperty;
                                           var   Continue: Boolean);
var
  PropName : string;
begin
  PropName := Prop.GetName;
  if CompareText(PropName, 'ONALLTRIGGERS') = 0 then begin
    Prop.Edit;
    Continue := False;
  end;
end;


{*** TExcludeComponentProperty ***}


procedure TExcludeComponentProperty.GetValues(Proc : TGetStrProc);
var
  I, J      : Integer;
  COwner,
  Component : TComponent;
  PropClass : TClass;
  Skip      : Boolean;
begin
  COwner := Designer.GetRoot;
  PropClass := GetTypeData(GetPropType)^.ClassType;
  for I := 0 to COwner.ComponentCount - 1 do begin
    Component := COwner.Components[I];

    {don't list component(s) being edited}
    Skip := False;
    for J := 0 to PropCount-1 do
      if GetComponent(J) = Component then begin
        Skip := True;
        Break;
      end;

    if (Component is PropClass) and (Component.Name <> '') and not Skip then
      Proc(Component.Name);
  end;
end;



type
  {component editor for the table}
  TOvcTableEditor = class(TDefaultEditor)
  public
    procedure ExecuteVerb(Index : Integer);
      override;
    function GetVerb(Index : Integer) : String;
      override;
    function GetVerbCount : Integer;
      override;
  end;

{*** TOvcTableEditor ***}

const
  TableVerbs : array[0..1] of PChar =
    ('Columns Editor', 'Rows Editor');

procedure TOvcTableEditor.ExecuteVerb(Index : Integer);
var
  Table : TOvcTable;
  C     : TOvcfrmColEditor;
  R     : TOvcfrmRowEditor;
begin
  Table := TOvcTable(Component);
  if Index = 0 then begin
    C := TOvcfrmColEditor.Create(Application);
    try
      C.Editor := Self;
      C.SetCols(TOvcTableColumns(Table.Columns));
      C.ShowModal;
      Designer.Modified;
    finally
      C.Free;
    end;
  end else if Index = 1 then begin
    R := TOvcfrmRowEditor.Create(Application);
    try
      R.SetRows(TOvcTableRows(Table.Rows));
      R.ShowModal;
      Designer.Modified;
    finally
      R.Free;
    end;
  end;
end;

function TOvcTableEditor.GetVerb(Index : Integer) : String;
begin
  Result := StrPas(TableVerbs[Index]);
end;

function TOvcTableEditor.GetVerbCount : Integer;
begin
  Result := High(TableVerbs) + 1;
end;


{*** component registration ***}

procedure Register;
begin
  {register property editor for the controller}
  RegisterPropertyEditor(
    TypeInfo(TOvcCommandProcessor), nil, '', TOvcCommandProcessorProperty);

  {register component editor for the controller}
  RegisterComponentEditor(TOvcController, TOvcControllerEditor);

  {register component editor for the sub-component list}
  RegisterPropertyEditor(TypeInfo(TOvcCollection), nil, '',
    TOvcCollectionEditor);
  RegisterPropertyEditor(TypeInfo(TO32Collection), nil, '',
    TO32CollectionEditor);

  { register collection property editor for the InspectorGrid }
  RegisterPropertyEditor(TypeInfo(TO32Collection), TO32InspectorGrid,
    'ItemCollection', TO32IgridCollectionEditor);

  {register label component editor}
  RegisterComponentEditor(TOvcCustomLabel, TOvcLabelEditor);

  {register property editors for the entry fields}
  RegisterPropertyEditor(
    TypeInfo(Char), TOvcSimpleField,    'PictureMask', TSimpleMaskProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOvcPictureField, 'PictureMask', TPictureMaskProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOvcNumericField, 'PictureMask', TNumericMaskProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOvcSimpleField,  'RangeHi', OvcEfPe.TEfRangeProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOvcSimpleField,  'RangeLo', OvcEfPe.TEfRangeProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOvcPictureField, 'RangeHi', OvcEfPe.TEfRangeProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOvcPictureField, 'RangeLo', OvcEfPe.TEfRangeProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOvcNumericField, 'RangeHi', OvcEfPe.TEfRangeProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOvcNumericField, 'RangeLo', OvcEfPe.TEfRangeProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOvcPictureLabel, 'PictureMask', TPictureMaskProperty);

  {register component editor for the timer pool component}
  RegisterComponentEditor(TOvcTimerPool, TOvcTimerPoolEditor);

  {register component editor for the transfer component}
  RegisterComponentEditor(TOvcTransfer, TOvcTransferEditor);

  {register component editor for the tab control}
  RegisterComponentEditor(TOvcNotebook, TOvcNotebookEditor);

  {register property editor for the header of the virtual list box}
  RegisterPropertyEditor(
    TypeInfo(string), TOvcVirtualListBox, 'Header', TOvcHeaderProperty);

  {register property editor for the Caption and URL properties in TOrURL}
  RegisterPropertyEditor(
    TypeInfo(string), TOvcURL, 'Caption', TOvcHeaderProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOvcURL, 'URL', TOvcHeaderProperty);

  {register property editors for the fixed font class}
  RegisterPropertyEditor(
    TypeInfo(string), TOvcFixedFont, 'Name', TOvcFixFontNameProperty);
  RegisterPropertyEditor(
    TypeInfo(TOvcFixedFont), nil, '', TOvcFixFontProperty);

  {register property editor and viewer for FileName properties}
  RegisterPropertyEditor(
    TypeInfo(string), TOvcTextFileEditor, 'FileName', TOvcFileNameProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOvcFileViewer, 'FileName', TOvcFileNameProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOvcTextFileViewer, 'FileName', TOvcFileNameProperty);

  {register property editor for the spinner components}
  RegisterPropertyEditor(TypeInfo(TWinControl), TOvcAttachedButton,
    'AttachedControl', TExcludeComponentProperty);
  RegisterPropertyEditor(TypeInfo(TWinControl), TOvcSpinner,
    'FocusedControl', TExcludeComponentProperty);
  {register docking component editor for the spinner buttons}
  RegisterComponentEditor(TOvcSpinner, TOvcDockingEditor);

  RegisterPropertyEditor(TypeInfo(TWinControl), TOvcFlatSpinner,
    'FocusedControl', TExcludeComponentProperty);
  {register docking component editor for the spinner buttons}
  RegisterComponentEditor(TOvcFlatSpinner, TOvcDockingEditor);

  {register property editor for About property}
  RegisterPropertyEditor(TypeInfo(string), TOvcCustomControlEx,
    'About', TOvcAboutProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcCustomControl,
    'About', TOvcAboutProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcGraphicControl,
    'About', TOvcAboutProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcComponent,
    'About', TOvcAboutProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcTimerPool,
    'About', TOvcAboutProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcCustomRotatedLabel,
    'About', TOvcAboutProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcBasicCheckList,
    'About', TOvcAboutProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcCheckList,
    'About', TOvcAboutProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcListBox,
    'About', TOvcAboutProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcTransfer,
    'About', TOvcAboutProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcAttachedButton,
    'About', TOvcAboutProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcCustomEdit,
    'About', TOvcAboutProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcURL,
    'About', TOvcAboutProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcBaseComboBox,
    'About', TOvcAboutProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcCustomLabel,
    'About', TOvcAboutProperty);
  RegisterPropertyEditor(TypeInfo(string), TO32CollectionItem,
    'About', TOvcAboutProperty);
  RegisterPropertyEditor(TypeInfo(string), TO32InspectorGrid,
    'About', TOvcAboutProperty);
  RegisterPropertyEditor(TypeInfo(string), TO32StatusBar,
    'About', TOvcAboutProperty);
  RegisterPropertyEditor(TypeInfo(string), TO32CollectionItem,
    'About', TOvcAboutProperty);
  RegisterPropertyEditor(TypeInfo(string), TO32FlexButton,
    'About', TOvcAboutProperty);
  RegisterPropertyEditor(TypeInfo(string), TO32LookoutBar,
    'About', TOvcAboutProperty);
  RegisterPropertyEditor(TypeInfo(string), TO32ImageForm,
    'About', TOvcAboutProperty);
  RegisterPropertyEditor(TypeInfo(string), TO32FlexEdit,
    'About', TOvcAboutProperty);
  RegisterPropertyEditor(TypeInfo(string), TO32ValidatorPool,
    'About', TOvcAboutProperty);
  RegisterPropertyEditor(TypeInfo(string), TO32BaseValidator,
    'About', TOvcAboutProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcBaseTableCell,
    'About', TOvcAboutProperty);

  {register property editors for the array editors}
  RegisterPropertyEditor(TypeInfo(Char), TOvcSimpleArrayEditor,
    'PictureMask', TSimpleMaskProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcPictureArrayEditor,
    'PictureMask', TPictureMaskProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcNumericArrayEditor,
    'PictureMask', TNumericMaskProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcSimpleArrayEditor,
    'RangeHi', OvcAePe.TAeRangeProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcSimpleArrayEditor,
    'RangeLo', OvcAePe.TAeRangeProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcPictureArrayEditor,
    'RangeHi', OvcAePe.TAeRangeProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcPictureArrayEditor,
    'RangeLo', OvcAePe.TAeRangeProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcNumericArrayEditor,
    'RangeHi', OvcAePe.TAeRangeProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcNumericArrayEditor,
    'RangeLo', OvcAePe.TAeRangeProperty);

  {register property editors for report view}
  RegisterPropertyEditor(TypeInfo(string), TOvcCustomReportView,
    'ActiveView', TOvcRvActiveViewProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcAbstractRvViewField,
    'FieldName', TOvcRvFieldNameProperty);
  RegisterPropertyEditor(TypeInfo(TOvcDataRvItems), TOvcDataReportView,
    'Items', TOvcReportViewItemsProperty);
  RegisterPropertyEditor(TypeInfo(Integer), TOvcRvField,
    'ImageIndex', TOvcRvImgIdxProperty);

  {register property editor for outline}
  RegisterPropertyEditor(TypeInfo(TOvcOutlineNodes), TOvcCustomOutline,
    'Nodes', TOvcOutlineItemsProperty);

  {register our color property editor}
  RegisterPropertyEditor(TypeInfo(TColor), TPersistent, '', TOvcColorProperty);

  {register file name property editor for the component and form state component}
  RegisterPropertyEditor(TypeInfo(string), TOvcComponentState,
    'IniFileName', TOvcFileNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcFormState,
    'IniFileName', TOvcFileNameProperty);

  {register property storage property and component editor}
  RegisterPropertyEditor(TypeInfo(TStrings), TOvcComponentState,
    'StoredProperties', TStoredPropsProperty);
  RegisterComponentEditor(TOvcComponentState, TOvcComponentStateEditor);

  {register component editor for the button header}
  RegisterComponentEditor(TOvcButtonHeader, TOvcButtonHeaderEditor);

  {register component editor for the LookoutBars}
  RegisterComponentEditor(TOvcLookOutBar, TOvcLookoutBarEditor);
  RegisterComponentEditor(TO32LookOutBar, TO32LookoutBarEditor);

  {register docking component editor for the speed button}
  RegisterComponentEditor(TOvcSpeedButton, TOvcDockingEditor);

  RegisterPropertyEditor(TypeInfo(TOvcTableRows), TOvcTable,
    '', TOvcTableRowProperty);
  RegisterPropertyEditor(TypeInfo(TOvcTableColumns), TOvcTable,
    '', TOvcTableColumnProperty);

  {register component editor for the table}
  RegisterComponentEditor(TOvcTable, TOvcTableEditor);

  {register property editors for the cell entry fields}
  RegisterPropertyEditor(TypeInfo(Char), TOvcTCSimpleField,
    'PictureMask', TSimpleMaskProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcTCPictureField,
    'PictureMask', TPictureMaskProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcTCNumericField,
    'PictureMask', TNumericMaskProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcTCSimpleField,
    'RangeHi', OvcTCPE.TTCRangeProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcTCSimpleField,
    'RangeLo', OvcTCPE.TTCRangeProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcTCPictureField,
    'RangeHi', OvcTCPE.TTCRangeProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcTCPictureField,
    'RangeLo', OvcTCPE.TTCRangeProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcTCNumericField,
    'RangeHi', OvcTCPE.TTCRangeProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcTCNumericField,
    'RangeLo', OvcTCPE.TTCRangeProperty);

  {RegisterPropertyEditor for the ValidatorProperties class}
  RegisterPropertyEditor(TypeInfo(String), TValidatorOptions,
    'ValidatorType', TorRegisteredValidatorsProperty);
  RegisterPropertyEditor(TypeInfo(String), TO32ValidatorItem,
    'ValidatorType', TorRegisteredValidatorsProperty);
  RegisterPropertyEditor(TypeInfo(String), TValidatorOptions,
    'Mask', TSampleMaskProperty);
  RegisterPropertyEditor(TypeInfo(string), TO32RegexValidator,
    'Expression', TSampleMaskProperty);
  RegisterPropertyEditor(TypeInfo(string), TO32BaseValidator,
    'Mask', TSampleMaskProperty);
  RegisterPropertyEditor(TypeInfo(string), TO32ValidatorItem,
    'Mask', TSampleMaskProperty);

  {Register Property Editor for the FlexEdit Table Cell component}
  RegisterPropertyEditor(TypeInfo(String), TO32TCValidatorOptions,
    'ValidatorType', TorRegisteredValidatorsProperty);

  {register component editor for the report view component}
  RegisterComponentEditor(TOvcCustomReportView, TOvcReportViewEditor);

  {register component editor for the InspectorGrid component}
  RegisterComponentEditor(TO32CustomInspectorGrid, TO32InspectorGridEditor);

  {register component editor for the outline}
  RegisterComponentEditor(TOvcCustomOutline, TOvcOutlineEditor);

  RegisterComponents('Orpheus General', [
    TOvcReportView,
    TOvcDataReportView,
    TO32LookoutBar,
    TO32StatusBar,
    TO32InspectorGrid,
    TOvcNotebook,
    TOvcButtonHeader,
    TO32FlexButton,
    TOvcSplitter,
    TOvcCalendar,
    TOvcCalculator,
    TOvcClock,
    TO32ImageForm,
    TOvcLabel,
    TOvcRotatedLabel,
    TOvcPictureLabel,
    TOvcPeakMeter,
    TOvcMeter,
    TOvcSlider,
    TOvcSpinner,
    TOvcFlatSpinner,
    TOvcAttachedButton,
    TOvcSpeedButton,
    TOvcURL
    ]);

  {register editing and related components}
  RegisterComponents('Orpheus Edits', [
    TOvcSliderEdit,
    TOvcEditor,
    TOvcTextFileEditor,
    TO32FlexEdit,
    TOvcSimpleField,
    TOvcPictureField,
    TOvcNumericField,
    TOvcHtmlMemo
    ]);

  {register editing and related components}
  RegisterComponents('Orpheus Lists', [
    TOvcOutline,
    TOvcListBox,
    TOvcBasicCheckList,
    TOvcCheckList,
    TOvcSearchList,
    TOvcVirtualListBox,
    TOvcFileViewer,
    TOvcTextFileViewer
    ]);

  {register editing and related components}
  RegisterComponents('Orpheus ComboBox', [
    TOvcComboBox,
    TOvcFontComboBox,
    TOvcAssociationComboBox,
    TOvcFileComboBox,
    TOvcDirectoryComboBox,
    TOvcDriveComboBox,
    TOvcHistoryComboBox,
    TOvcPrinterComboBox,
    TOvcColorComboBox,
    TOvcViewComboBox
    ]);

  {register non visual components}
  RegisterComponents('Orpheus Non-Visual', [
    TOvcFormState,
    TOvcComponentState,
    TOvcPersistentState,
    TOvcRegistryStore,
    TOvcIniFileStore,
    TOvcVirtualStore,
    TO32XMLFileStore,
    TOvcMenuMRU,
    TOvcTimerPool,
    TOvcTransfer,
    TOvcController,
    TO32RegExValidator,
    TO32ParadoxValidator,
    TO32OrMaskValidator,
    TO32ValidatorPool
    ]);

  {register dialog components}
  RegisterComponents('Orpheus Dialogs', [
    TOvcCalendarDialog,
    TOvcCalculatorDialog,
    TOvcClockDialog,
    TOvcMemoDialog,
    TOvcRvPrintDialog,
    TOvcSplashDialog
    ]);

  {register table and cell components}
  RegisterComponents('Orpheus Table', [
    TOvcTable,
    TOvcTCColHead,
    TOvcTCColHeadExtended,
    TOvcTCRowHead,
    TOvcTCString,
    TOvcTCSimpleField,
    TOvcTCPictureField,
    TOvcTCNumericField,
    TOvcTCMemo,
    TOvcTCHTMLText,
    TOvcTCCheckBox,
    TOvcTCComboBox,
    TOvcTCCheckComboBox,
    TOvcTCBitMap,
    TOvcTCGlyph,
    TOvcTCIcon,
    TO32TCFlexEdit,
    TOvcTCCustomStr,
    TOvcTCCustomInt
    ]);

  {register deprecated components}
  RegisterComponents('Orpheus Deprecated', [
    TOvcLookOutBar,
    TOvcEdit,
    TOvcNumberEdit,
    TOvcDateEdit,
    TOvcTimeEdit,
    TOvcSimpleArrayEditor,
    TOvcPictureArrayEditor,
    TOvcNumericArrayEditor,
    TOvcBorderedEdit,
    TOvcBorderedNumberEdit,
    TOvcBorderedDateEdit,
    TOvcBorderedTimeEdit
    ]);
end;

end.

