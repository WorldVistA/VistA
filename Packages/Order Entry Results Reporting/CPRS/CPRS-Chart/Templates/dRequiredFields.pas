unit dRequiredFields;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Datasnap.DBClient, VCL.Controls,
  uTemplateFields, ORFN;

type
  TdmRF = class(TDataModule)
    cdsControls: TClientDataSet;
    cdsControlsAbsY: TIntegerField;
    cdsControlsAbsX: TIntegerField;
    cdsControlsCTRL_OBJ: TLargeintField;
    cdsControlsCTRL_FOCUSABLE: TBooleanField;
    cdsControlsFLD_REQUIRED: TBooleanField;
    cdsControlsTag: TIntegerField;
    cdsControlsTop: TIntegerField;
    cdsControlsLeft: TIntegerField;
    cdsControlsFLD_OBJ: TIntegerField;
    cdsControlsFLD: TIntegerField;
    cdsControlsFLD_ID: TIntegerField;
    cdsControlsFLD_NAME: TStringField;
    cdsControlsClass: TStringField;
    dsControls: TDataSource;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    fRequiredFields: TStringList;
    function getRequiredFieldText(aCtrl: TWinControl): string;
    function getControlValue(aControl: TObject): string;
    function getTemplateFieldByControl(aControl: TWinControl): TTemplateField;
    function getRequiredFieldValue(aFld: string; aDelim: string = U): string;
    function getFieldControl: TWinControl;
  public
    { Public declarations }
    function getControlFirstRequiredField: TWinControl;
    function getControlLastRequiredField: TWinControl;
    function getControlNextRequiredField(aControl: TWinControl): TWinControl;
    function getControlPrevRequiredField(aControl: TWinControl): TWinControl;

    procedure ClearRequired;
    procedure RefreshCdsControls(aCtrl: TWinControl);
    procedure setFilterFieldsRequired(aValue: Boolean);
    procedure HighlightControls(aRequired: Boolean);
    function getNumberOfMissingFields(aParent: TWinControl): Integer;
    procedure AddFieldControl(aFld: TTemplateField; aControl: TWinControl;
      anID: string);
    procedure RemoveChildFieldControls(aControl: TWinControl);
    function RequiredFields2Str: string;
    procedure FindFocusedControl(aCtrl:TWinControl);
  end;

var
  FdmRF : TdmRF;

function dmRF: TdmRF;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

uses
  VAUtils, VCL.StdCtrls, VCL.ComCtrls, VCL.ExtCtrls, VCL.Graphics, VCL.Dialogs,
  Forms, mTemplateFieldButton, ORDtTm, ORCtrls, uDlgComponents, WinApi.Windows,
  fOptionsTIUTemplates, System.Variants;

const
  _not_Required_ = '(not R)';
  _Required_ = '(*R*)';

  /// ///////////////////////////////////////////////////////////////////////////
  // Extension of the TORDateCombo to support RequiredColor property
type
  TORDateCombo = class(ORDtTm.TORDateCombo)
  private
    procedure setRequiredColor(aColor: TColor);
  public
    property RequiredColor: TColor write setRequiredColor;
  end;

procedure TORDateCombo.setRequiredColor(aColor: TColor);
begin
  if assigned(MonthCombo) then
    MonthCombo.Color := aColor;
  if assigned(DayCombo) then
    DayCombo.Color := aColor;
  if assigned(YearEdit) then
    YearEdit.Color := aColor;
end;

/// /////////////////////////////////////////////////////////////////////////////
function parseControlAddress(aSource: string): string;
begin
  Result := piece(piece(aSource, U, 1), ':', 2);
end;

function parseControlFLD(aSource: string): string;
begin
  Result := piece(aSource, U, 2);
end;

function parseFLD(aSource: string): string;
begin
  Result := piece(piece(aSource, U, 2), ':', 2);
end;

function parseFieldID(aSource: string): string;
begin
  Result := piece(aSource, U, 3);
end;

function parseFieldName(aSource: string): string;
begin
  Result := piece(aSource, U, 4);
end;

function parseFieldAddress(aSource: string): string;
begin
  Result := piece(aSource, U, 5);
end;

/// ////////////////////////////////////////////////////////////////////////////
//
// fREquiredFields maps VistA fields to the template dialog controls
//
{ TODO : Replace fRequiredFields with cdsControls }
procedure TdmRF.AddFieldControl(aFld: TTemplateField; aControl: TWinControl;
  anID: string);
var
  ss: string;
begin
  ss := 'CTRL:' + IntToStr(Integer(aControl)) + U + 'FLD:' + anID + U + aFld.ID
    + U + aFld.FldName + U + IntToStr(Integer(aFld)) + U + '  ' +
    aControl.ClassName;

  if aFld.Required then
    ss := ss + U + ' ' + _Required_
  else
    ss := ss + U + ' ' + _not_Required_;

  fRequiredFields.AddObject(ss, aFld);
end;

procedure TdmRF.RemoveChildFieldControls(aControl: TWinControl);
var
  ctrlID: string;
  cc: integer;
begin
  ctrlID := 'CTRL:' + IntToStr(Integer(aControl));
  for cc := 0 to fRequiredFields.Count - 1 do
  begin
    if Piece(fRequiredFields[cc], U, 1) = ctrlID then
    begin
      fRequiredFields.Delete(cc);
      break;
    end;
  end;
  for cc := 0 to aControl.ControlCount - 1 do
    if aControl.Controls[cc] is TWinControl then
      RemoveChildFieldControls(TWinControl(aControl.Controls[cc]));
end;

/// ///////////////////////////////////////////////////////////////////////////

procedure HighlightControl(Ctrl: TControl; aRequired: Boolean);
var
  Color2Use: TColor;
begin
  if not assigned(Ctrl) then
    Exit;

  Color2Use := clWindow;
  if aRequired then
  begin
    if Ctrl.Enabled and TWinControl(Ctrl).CanFocus then
      Color2Use := ReqHighlightColor
    else
      Color2Use := ReqHighlightDisabledColor;
  end
  else
  begin
    if ((Ctrl is TEdit) or (Ctrl is TORComboBox) or (Ctrl is TORDateCombo) or
      (Ctrl is TORDateBox) or (Ctrl is TRichEdit)) then
      Color2Use := clWindow
    else if ((Ctrl is TORCheckBox) or (Ctrl is TfraTemplateFieldButton) or
      (Ctrl is TPanel)) then
      Color2Use := clBtnFace;
  end;

  if (Ctrl is TEdit) then
    TEdit(Ctrl).Color := Color2Use
  else if (Ctrl is TORComboBox) then
    TORComboBox(Ctrl).Color := Color2Use
  else if (Ctrl is TORDateCombo) then
    TORDateCombo(Ctrl).RequiredColor := Color2Use
  else if (Ctrl is TCPRSDialogDateBox) then
    TCPRSDialogDateBox(Ctrl).Color := Color2Use
  else if (Ctrl is TORDateBox) then
    TORDateBox(Ctrl).Color := Color2Use
  else if (Ctrl is TRichEdit) then
    TRichEdit(Ctrl).Color := Color2Use
  else if (Ctrl is TORCheckBox) then
    TORCheckBox(Ctrl).Color := Color2Use
  else if (Ctrl is TfraTemplateFieldButton) then
  begin
    TfraTemplateFieldButton(Ctrl).spRequired.Pen.Color := Color2Use;
    TfraTemplateFieldButton(Ctrl).spRequired.Brush.Color := Color2Use
  end
  else if (Ctrl is TCPRSDialogNumber) then
  begin
    TCPRSDialogNumber(Ctrl).Edit.Color := Color2Use;
    // uncomment and provide the value in case the font color should be updated
    // TCPRSDialogNumber(Ctrl).Edit.Font.Color := ???;
  end
  // keep TPanel processing the last to avoid overwriting the child types
  else if (Ctrl is TPanel) then
    TPanel(Ctrl).Color := Color2Use
  else if (Ctrl is TCPRSDialogDateCombo) then
    TCPRSDialogDateCombo(Ctrl).Color := Color2Use;
end;

procedure TdmRF.HighlightControls(aRequired: Boolean);
var
  i: Integer;
  sCtrl: string;
  Ctrl: TWinControl;
  FLD: TTemplateField;

begin
  for i := 0 to fRequiredFields.Count - 1 do
  begin
    sCtrl := parseControlAddress(fRequiredFields[i]);
    Ctrl := TWinControl(StrToInt(sCtrl));

    if assigned(Ctrl) then
    begin
      FLD := getTemplateFieldByControl(Ctrl);
      if assigned(FLD) then
        HighlightControl(Ctrl, aRequired and FLD.Required and
          (getRequiredFieldText(Ctrl) = ''));
    end;
  end;
end;

function TdmRF.getRequiredFieldText(aCtrl: TWinControl): string;
var
  s, sCtrl, sFLD, sFLDID: string;
  i: Integer;
begin
  Result := '';
  sFLD := '';
  sCtrl := IntToStr(Integer(aCtrl));
  for i := 0 to fRequiredFields.Count - 1 do
  begin
    s := fRequiredFields[i];
    if sCtrl = parseControlAddress(s) then
    begin
      sFLD := parseFieldAddress(s);
      sFLDID := parseControlFLD(s);
      break;
    end;
  end;
  if sFLD <> '' then
  begin
    for i := 0 to fRequiredFields.Count - 1 do
    begin
      s := fRequiredFields[i];
      if sFLDID <> parseControlFLD(s) then
        continue;
      sCtrl := parseControlAddress(s);
      Result := Result + getControlValue(TWinControl(StrToInt(sCtrl)));
    end;
  end;
end;

procedure TdmRF.ClearRequired;
begin
  fRequiredFields.Clear;
end;

function TdmRF.getTemplateFieldByControl(aControl: TWinControl): TTemplateField;
var
  s, sCtrl, fldID: string;
begin
  Result := nil;
  sCtrl := IntToStr(Integer(aControl));
  for s in fRequiredFields do
  begin
    if sCtrl <> parseControlAddress(s) then
      continue;
    fldID := parseFieldID(s);
    Result := getTemplateField(fldID, True);
    break;
  end;
end;

function TdmRF.getControlValue(aControl: TObject): string;
begin
  Result := '';

  if aControl is TEdit then
    Result := TEdit(aControl).Text
  else if (aControl is TRadioButton) then
  begin
    if (TRadioButton(aControl).Checked) then
      Result := TRadioButton(aControl).Caption
  end
  else if (aControl is TORComboBox) then
    Result := TORComboBox(aControl).Text
  else if (aControl is TMemo) then
    Result := TMemo(aControl).Text
  else if (aControl is TRichEdit) then
    Result := TRichEdit(aControl).Text
  else if (aControl is TORCheckBox) then
  begin
    if (TORCheckBox(aControl).Checked) then
      Result := TORCheckBox(aControl).Caption
  end
  else if (aControl is TCheckBox) then
  begin
    if (TCheckBox(aControl).Checked) then
      Result := TCheckBox(aControl).Caption
  end
  else if (aControl is TfraTemplateFieldButton) then
    Result := TfraTemplateFieldButton(aControl).ButtonText
  else if (aControl is TCPRSDialogNumber) then
    Result := TCPRSDialogNumber(aControl).Edit.Text
    // Result := '' // testing blank values for Number fields
  else
  // uncomment for testing the highligting of the required fields in DEBUG build
  // ShowMessage('DEBUG ONLY MESSAGE:' + CRLF + 'Control of class "' +
  //   aControl.ClassName + '" returns blank value')
      ;
  // Comment in case TRichEdit with only CRFL is considered NOT empty
  if (aControl is TRichEdit) then
  begin
    if Result = CRLF then
      Result := '';
  end
  else
  if (aControl is TCPRSDialogDateCombo) then
    Result := TCPRSDialogDateCombo(aControl).DateText;
end;

function TdmRF.getRequiredFieldValue(aFld: string; aDelim: string = U): string;
var
  ss, s, sCtrl: string;
  Ctrl: TWinControl;
begin
  Result := '';
  for ss in fRequiredFields do
  begin
    s := parseFLD(ss);
    if s <> aFld then
      continue;
    sCtrl := parseControlAddress(ss);
    Ctrl := TWinControl(StrToInt(sCtrl));
    s := getControlValue(Ctrl);
    if s <> '' then
      Result := Result + s + aDelim;
  end;
  if Result <> '' then
    Result := copy(Result, 1, Length(Result) - Length(aDelim));
end;

/// ////////////////////////////////////////////////////////////////////////////

type
  TMyORDateCombo = class(TCPRSDialogDateCombo);

function TdmRF.getFieldControl: TWinControl;
var
  sObj: string;
  cds: TClientDataSet;
begin
  Result := nil;
  cds := cdsControls;
  sObj := cds.FieldByName('CTRL_OBJ').AsString;
  if sObj <> '' then
  begin
    Result := TWinControl(StrToInt(sObj));
    if Result is TCPRSDialogDateCombo then
      Result := TMyORDateCombo(Result).YearEdit;
  end;
end;

procedure TdmRF.DataModuleCreate(Sender: TObject);
begin
  inherited;
  fRequiredFields := TStringList.Create;
end;

procedure TdmRF.DataModuleDestroy(Sender: TObject);
begin
  fRequiredFields.Free;
  inherited;
end;

function TdmRF.getControlFirstRequiredField: TWinControl;
var
  cds: TClientDataSet;
  bFilter: Boolean;
  sValue, sFLD: string;
begin
  Result := nil;
  cds := cdsControls;

  bFilter := cds.Filtered;
  setFilterFieldsRequired(True);

  if cds.RecordCount > 0 then
  begin
    cds.First;
    sValue := '';
    while not cds.EOF do
    begin
      sFLD := cds.FieldByName('FLD').AsString;
      sValue := getRequiredFieldValue(sFLD);
      if sValue = '' then
      begin
        Result := getFieldControl;
        break;
      end;
      cds.Next;
    end;
  end;
  setFilterFieldsRequired(bFilter);
end;

function TdmRF.getControlLastRequiredField: TWinControl;
var
  cds: TClientDataSet;
  bFilter: Boolean;
  sValue, sFLD: string;
begin
  Result := nil;

  cds := cdsControls;
  bFilter := cds.Filtered;
  setFilterFieldsRequired(True);

  if cds.RecordCount > 0 then
  begin
    cds.Last;
    sValue := '';
    while not cds.BOF do
    begin
      sFLD := cds.FieldByName('FLD').AsString;
      sValue := getRequiredFieldValue(sFLD);
      if sValue = '' then
      begin
        Result := getFieldControl;
        break;
      end;
      cds.Prior;
    end;
  end;
  setFilterFieldsRequired(bFilter);
end;

function TdmRF.getControlNextRequiredField(aControl: TWinControl): TWinControl;
var
  cds: TClientDataSet;
  bFilter: Boolean;
  sValue, sFLD: string;
  BM: TBookmark;
begin
  Result := nil;
  cds := cdsControls;
  cds.Locate('CTRL_OBJ',VarArrayOf([IntToStr(Integer(aControl))]),[]);
  BM := cds.GetBookmark;
  bFilter := cds.Filtered;
  setFilterFieldsRequired(False);
  cds.GotoBookmark(BM);
  cds.Next;
  while not cds.EOF do
  begin
    if (cds.FieldByName('FLD_OBJ').AsString <> '') and
      cds.FieldByName('FLD_REQUIRED').AsBoolean then
    begin
      sFLD := cds.FieldByName('FLD').AsString;
      sValue := getRequiredFieldValue(sFLD);
      if sValue = '' then
      begin
        Result :=     getFieldControl;
        break;
      end;
    end;
    cds.Next;
  end;
  setFilterFieldsRequired(bFilter);
  if Result = nil then
  begin
    MessageBeep(0);
    cds.GotoBookmark(BM);
  end;
  cds.FreeBookmark(BM);
end;

function TdmRF.getControlPrevRequiredField(aControl: TWinControl): TWinControl;
var
  cds: TClientDataSet;
  bFilter: Boolean;
  sValue, sFLD: string;
  BM: TBookmark;
begin
  Result := nil;
  cds := cdsControls;
  cds.Locate('CTRL_OBJ',VarArrayOf([IntToStr(Integer(aControl))]),[]);
  BM := cds.GetBookmark;
  bFilter := cds.Filtered;
  setFilterFieldsRequired(False);

  cds.GotoBookmark(BM);
  cds.Prior;
  while not cds.BOF do
  begin
    if (cds.FieldByName('FLD_OBJ').AsString <> '') and
      cds.FieldByName('FLD_REQUIRED').AsBoolean then
    begin
      sFLD := cds.FieldByName('FLD').AsString;
      sValue := getRequiredFieldValue(sFLD);
      if sValue = '' then
      begin
        Result := getFieldControl;
        break;
      end;
    end;
    cds.Prior;
  end;
  setFilterFieldsRequired(bFilter);
  if Result = nil then
  begin
    MessageBeep(0);
    cds.GotoBookmark(BM);
  end;
  cds.FreeBookmark(BM);
end;

procedure TdmRF.FindFocusedControl(aCtrl: TWinControl);
begin
  if aCtrl <> nil then
  try
    if not cdsControls.Locate('CTRL_OBJ', VarArrayOf([IntToStr(Integer(aCtrl))]
      ), []) then
      cdsControls.First;
  finally
  end;
end;

// cdsControls:
// -- maps controls of sbMain to the template dialog fields
// -- defines order of the fields browsing (IndexFieldNames == 'AbsY;AbsX')
// -- provides data source for debug data grid

procedure TdmRF.RefreshCdsControls(aCtrl: TWinControl);

  function getFieldByCtrl(aCtrl: string): string;
  var
    s: string;
  begin
    Result := '';
    for s in fRequiredFields do
    begin
      if aCtrl = parseControlAddress(s) then
      begin
        Result := s;
        break;
      end;
    end;
  end;

  procedure setFocusableControlsInfo(aCtrl: TWinControl; posY, posX: Integer);
  var
    s: string;
    absX, absY, i: Integer;
  begin
    if not assigned(aCtrl) then
      Exit;
    if not aCtrl.Visible then
      Exit;
    if not aCtrl.Enabled then
      Exit;
    if aCtrl.CanFocus then
    begin
      absY := posY + aCtrl.Top;
      absX := posX + aCtrl.Left;
      with cdsControls do
      begin
        Insert;
        FieldByName('AbsY').AsInteger := absY;
        FieldByName('AbsX').AsInteger := absX;
        FieldByName('CTRL_OBJ').AsInteger := Integer(aCtrl);
        FieldByName('CTRL_FOCUSABLE').AsBoolean := aCtrl.CanFocus;
        FieldByName('Tag').AsInteger := aCtrl.Tag;
        FieldByName('Top').AsInteger := aCtrl.Top;
        FieldByName('Left').AsInteger := aCtrl.Left;
        FieldByName('Class').AsString := aCtrl.ClassName;

        s := getFieldByCtrl(IntToStr(Integer(aCtrl)));
        if s <> '' then
        begin
          FieldByName('FLD').AsString := piece(piece(s, '^', 2), ':', 2);
          FieldByName('FLD_OBJ').AsString := piece(s, '^', 5);
          FieldByName('FLD_ID').AsString := parseFieldID(s);
          FieldByName('FLD_NAME').AsString := parseFieldName(s);
          FieldByName('FLD_REQUIRED').AsBoolean :=
            pos(_Required_, piece(s, '^', 7)) > 0;
        end;
        Post;
      end;
      for i := 0 to aCtrl.ControlCount - 1 do
        if aCtrl.Controls[i] is TWinControl then
          setFocusableControlsInfo(TWinControl(aCtrl.Controls[i]), absY, absX);
    end;
  end;

begin
  cdsControls.EmptyDataSet;
  cdsControls.DisableControls;
  setFocusableControlsInfo(aCtrl, 0, 0);
  cdsControls.EnableControls;
end;

procedure TdmRF.setFilterFieldsRequired(aValue: Boolean);
var
  cds: TClientDataSet;
begin
  cds := cdsControls;

  cds.Filtered := False;;
  cds.Filter := 'FLD_REQUIRED=''True'' and CTRL_FOCUSABLE=''True''';
  cds.Filtered := aValue;
end;

function TdmRF.getNumberOfMissingFields(aParent: TWinControl): Integer;
var
  sl: TStringList;
  s, sCtrl, sFLD: string;
  Ctrl: TWinControl;
  i, ind: Integer;

begin
  sl := TStringList.Create;
  for i := 0 to fRequiredFields.Count - 1 do
  begin
    s := fRequiredFields[i];
    if (pos(_not_Required_, s) > 0) then
      continue;
    sCtrl := parseControlAddress(s);
    sFLD := parseFLD(s);
    Ctrl := TWinControl(StrToInt(sCtrl));

    if Ctrl.CanFocus then
    begin
      sCtrl := getControlValue(Ctrl);

      ind := sl.IndexOf(sFLD);
      if ind < 0 then
      begin
        sl.Add(sFLD);
        if sCtrl <> '' then
          sl.Objects[sl.Count - 1] := Pointer(dmRF);
      end
      else
      begin
        if sCtrl <> '' then
          sl.Objects[ind] := Pointer(dmRF);
      end;
    end;
  end;

  Result := 0;
  for i := 0 to sl.Count - 1 do
    if sl.Objects[i] = nil then
      inc(Result);
  sl.Free;
end;

function TdmRF.RequiredFields2Str: string;
var
  sl: TStringList;
  s, sCtrl, sFLD: string;
  Ctrl: TWinControl;
  i, iCtrl, iFocusable, iBlank, ind: Integer;

begin
  Result := 'Required FIELDS' + CRLF;
  iCtrl := 0;
  iFocusable := 0;
  sl := TStringList.Create;
  for i := 0 to fRequiredFields.Count - 1 do
  begin
    s := fRequiredFields[i];
    if (pos(_not_Required_, s) > 0) then
      continue;
    inc(iCtrl);
    sCtrl := parseControlAddress(s);
    sFLD := parseFLD(s);
    Ctrl := TWinControl(StrToInt(sCtrl));

    s := Format('%4.0d X=%4.0d Y=%4.0d ', [i, Ctrl.Left, Ctrl.Top]) + s;

    if pos(_Required_, s) > 0 then
    begin
      if Ctrl.CanFocus then
      begin
        inc(iFocusable);
        s := s + ' (Can focus)';
        sCtrl := getControlValue(Ctrl);
        s := s + ' -- ' + sCtrl;

        ind := sl.IndexOf(sFLD);
        if ind < 0 then
        begin
          sl.Add(sFLD);
          if sCtrl <> '' then
            sl.Objects[sl.Count - 1] := Pointer(dmRF);
        end
        else
        begin
          if sCtrl <> '' then
            sl.Objects[ind] := Pointer(dmRF);
        end;
      end;
    end;
    Result := Result + s + CRLF;
  end;

  iBlank := 0;
  for i := 0 to sl.Count - 1 do
    if sl.Objects[i] = nil then
      inc(iBlank);

  Result := Result + '-------------------------' + CRLF +
    Format('Total # of R.Fields: %d, Visible: %d, Focusable: %d, Blank Required: %d',
    [fRequiredFields.Count, iCtrl, iFocusable, iBlank]) + CRLF;
  sl.Free;
end;

// FH 12/3/2019
// This function instantiate one datamodule
function dmRF : TdmRF;
begin
  if not Assigned(FdmRF) then
    FdmRF := TdmRF.Create(nil);
  Result := FdmRF;
end;
// Initialization needs to here so I can use Finalization
Initialization

Finalization
  FreeAndNil(FdmRF);

end.
