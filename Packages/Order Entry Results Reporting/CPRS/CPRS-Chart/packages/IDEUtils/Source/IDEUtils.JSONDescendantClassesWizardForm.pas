unit IDEUtils.JSONDescendantClassesWizardForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.ExtCtrls, IDEUtils.JSONDescendantClassesCommon;

type
  TfrmJSONDescendantClassesWizardForm = class(TForm)
    cboUnit: TComboBox;
    lblName: TLabel;
    lblDesc: TLabel;
    pnlButtons: TPanel;
    btnCancel: TButton;
    btnFinish: TButton;
    lblPrefix: TLabel;
    lblSuffix: TLabel;
    edtPrefix: TEdit;
    edtSuffix: TEdit;
    cbIncludeOwners: TCheckBox;
    cbTopLevelOwner: TCheckBox;
    lblTopOwnerClass: TLabel;
    edtTopOwnerClass: TEdit;
    lblOwnerName: TLabel;
    cboOwnerName: TComboBox;
    gpMain: TGridPanel;
    btnNext: TButton;
    btnBack: TButton;
    pnlLeft: TPanel;
    lblSection1: TLabel;
    lblSection0: TLabel;
    sbMain: TScrollBox;
    bvlTop: TBevel;
    lblSection2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnFinishClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cbClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure gpMainResize(Sender: TObject);
  private const
    LastPage = 2;
    RowGroups: array [0 .. LastPage] of set of Byte = ([0], [1, 2],
      [3, 4, 5, 6, 7]);
  private
    FPage: Integer;
    FLabels: Array [0 .. LastPage] of TLabel;
    procedure ShowPage;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmJSONDescendantClassesWizardForm: TfrmJSONDescendantClassesWizardForm;

implementation

{$R *.dfm}

uses
  ToolsAPI,
  IDEUtils.JSONDescendantClassesWizard,
  IDEUtils.JSONDescendantClassesBuilder;

type
  TFileName = class
  private
    FFileName: string;
  public
    constructor Create(AFileName: string);
    property FileName: string read FFileName;
  end;

  // const
  // NewRowHeight = 31;
  // RowGroups: array [0 .. TfrmJSONDescendantClassesWizardForm.LastPage]
  // of set of Byte = ([0], [1, 2], [3, 4, 5, 6]);

procedure TfrmJSONDescendantClassesWizardForm.btnBackClick(Sender: TObject);
begin
  if FPage > 0 then
    dec(FPage);
  ShowPage;
end;

procedure TfrmJSONDescendantClassesWizardForm.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmJSONDescendantClassesWizardForm.btnFinishClick(Sender: TObject);
var
  Msg, AUnitName, AFileName, APrefix, ASuffix, AOwnerPropertyName,
    AOwnerClassName: string;
  AIncludeOwners, ATopClassOwner: Boolean;
  UnitInfo: TUnitInfo;

  procedure AddError(Txt: string);
  begin
    if Msg <> '' then
      Msg := Msg + #13#10;
    Msg := Msg + Txt;
  end;

begin
  Msg := '';
  AUnitName := '';
  AFileName := '';
  AOwnerClassName := '';
  if (cboUnit.ItemIndex >= 0) then
  begin
    AUnitName := cboUnit.Items[cboUnit.ItemIndex];
    AFileName := TFileName(cboUnit.Items.Objects[cboUnit.ItemIndex]).FFileName;
  end;
  APrefix := Trim(edtPrefix.Text);
  ASuffix := Trim(edtSuffix.Text);
  if cbIncludeOwners.Checked and cbTopLevelOwner.Checked then
  begin
    AOwnerClassName := Trim(edtTopOwnerClass.Text);
    if (AOwnerClassName = '') then
      AddError('Top Level Class Owner Class Name can not be blank.')
    else if not IsValidIdent(AOwnerClassName, False) then
      AddError('Invalid class name characters in Top Level Object Owner Class Name.');
  end;
  if cbIncludeOwners.Checked and (cboOwnerName.ItemIndex < 0) then
  begin
    if Trim(cboOwnerName.Text) = '' then
      AddError('Owner Property Name can not be blank.')
    else if not IsValidIdent(Trim(cboOwnerName.Text)) then
      AddError('Invalid property name characters in Owner Property Name.');
  end;
  if Msg <> '' then
    ShowMessage(Msg)
  else
  begin
    AIncludeOwners := cbIncludeOwners.Checked;
    if AIncludeOwners then
    begin
      ATopClassOwner := cbTopLevelOwner.Checked;
      AOwnerPropertyName := Trim(cboOwnerName.Text);
    end
    else
    begin
      ATopClassOwner := False;
      AOwnerPropertyName := '';
    end;
    UnitInfo := TUnitInfo.Create;
    try
      UnitInfo.ProjectUnitName := AUnitName;
      UnitInfo.ProjectFileName := AFileName;
      UnitInfo.Prefix := APrefix;
      UnitInfo.Suffix := ASuffix;
      UnitInfo.BuildOwners := AIncludeOwners;
      UnitInfo.OwnerName := AOwnerPropertyName;
      UnitInfo.TopClassOwnerName := AOwnerClassName;
      UnitInfo.TopClassOwner := ATopClassOwner;
      ParseJSONUnit(UnitInfo);
      BuildJSONDescendantClasses(UnitInfo);
      Close;
    finally
      FreeAndNil(UnitInfo);
    end;
  end;
end;

procedure TfrmJSONDescendantClassesWizardForm.btnNextClick(Sender: TObject);
var
  Msg, APrefix, ASuffix: string;

  procedure AddError(Txt: string);
  begin
    if Msg <> '' then
      Msg := Msg + #13#10;
    Msg := Msg + Txt;
  end;

begin
  Msg := '';
  case FPage of
    0:
      if (cboUnit.ItemIndex < 0) then
        AddError('No JSON Unit selected.');
    1:
      begin
        APrefix := Trim(edtPrefix.Text);
        ASuffix := Trim(edtSuffix.Text);
        if (APrefix = '') and (ASuffix = '') then
          AddError('Both Prefix and Suffix can not be blank.')
        else if not IsValidIdent('T' + APrefix + 'Testing' + ASuffix, False)
        then
          AddError('Invalid class name characters in Prefix and/or Suffix.');
      end;
  end;
  if Msg = '' then
  begin
    if FPage < LastPage then
      inc(FPage);
    ShowPage;
  end
  else
    ShowMessage(Msg);
end;

procedure TfrmJSONDescendantClassesWizardForm.cbClick(Sender: TObject);
begin
  lblOwnerName.Visible := cbIncludeOwners.Checked;
  cboOwnerName.Visible := cbIncludeOwners.Checked;
  cbTopLevelOwner.Visible := cbIncludeOwners.Checked;
  lblTopOwnerClass.Visible := cbIncludeOwners.Checked and
    cbTopLevelOwner.Checked;
  edtTopOwnerClass.Visible := cbIncludeOwners.Checked and
    cbTopLevelOwner.Checked;
end;

procedure TfrmJSONDescendantClassesWizardForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
  for var i := 0 to cboUnit.Items.Count - 1 do
    cboUnit.Items.Objects[i].Free;
end;

procedure TfrmJSONDescendantClassesWizardForm.FormCreate(Sender: TObject);
var
  ActiveProject: IOTAProject;
  ModuleInfo: IOTAModuleInfo;
begin
  gpMainResize(Self);
  Caption := AJSONDescendantClassesWizard.GetName;
  FLabels[0] := lblSection0;
  FLabels[1] := lblSection1;
  FLabels[2] := lblSection2;
  cboOwnerName.Items.Add(OwnerNamePlusClass);
  cboOwnerName.Items.Add(OwnerNameFromClass);
  cboOwnerName.Items.Add(OwnerNameOwner);
  cboOwnerName.ItemIndex := 0;
  ActiveProject := (BorlandIDEServices as IOTAModuleServices).GetActiveProject;
  if Assigned(ActiveProject) then
  begin
    for var i := 0 to ActiveProject.GetModuleCount - 1 do
    begin
      ModuleInfo := ActiveProject.GetModule(i);
      if (not Assigned(ModuleInfo)) or
        (not LowerCase(ModuleInfo.FileName).EndsWith('.pas')) then
        continue;
      cboUnit.Items.AddObject(ModuleInfo.Name,
        TFileName.Create(ModuleInfo.FileName));
    end;
    FPage := 0;
    ShowPage;
  end
  else
  begin
    ShowMessage('No Active Project');
    Close;
  end;
end;

procedure TfrmJSONDescendantClassesWizardForm.gpMainResize(Sender: TObject);
begin
  cbIncludeOwners.Margins.Right := gpMain.Width -
    Trunc(gpMain.ColumnCollection[0].Value) - 16;
  cbTopLevelOwner.Margins.Right := cbIncludeOwners.Margins.Right;
end;

procedure TfrmJSONDescendantClassesWizardForm.ShowPage;
var
  AControl, FirstControl: TWinControl;
  AVisible: Boolean;
begin
  gpMain.BeginUpdate;
  try
    for var i := 0 to gpMain.RowCollection.Count - 1 do
      if (i in RowGroups[FPage]) or (i > 7) and (FPage = LastPage) then
        gpMain.RowCollection[i].Value := 31
      else
        gpMain.RowCollection[i].Value := 0;
    FirstControl := nil;
    for var i := 0 to gpMain.ControlCollection.Count - 1 do
    begin
      AVisible := (gpMain.RowCollection[gpMain.ControlCollection[i].Row]
        .Value > 0);
      gpMain.ControlCollection[i].Control.Visible := AVisible;
      if AVisible and (gpMain.ControlCollection[i].Control is TWinControl) then
      begin
        AControl := gpMain.ControlCollection[i].Control as TWinControl;
        if (not Assigned(FirstControl)) or
          (FirstControl.TabOrder > (AControl.TabOrder)) then
          FirstControl := AControl;
      end;
    end;
    ActiveControl := FirstControl;
  finally
    gpMain.EndUpdate;
  end;
  if FPage = 2 then
    cbClick(Self);
  btnBack.Enabled := (FPage > 0);
  btnNext.Enabled := (FPage < LastPage);
  btnFinish.Enabled := (FPage = LastPage);
  for var i := 0 to LastPage do
    if i = FPage then
    begin
      FLabels[i].Font.Style := [fsBold];
      lblName.Caption := FLabels[i].Caption;
      lblDesc.Caption := FLabels[i].Hint;
    end
    else
      FLabels[i].Font.Style := [];
end;

{ TFileName }

constructor TFileName.Create(AFileName: string);
begin
  FFileName := AFileName;
end;

end.
