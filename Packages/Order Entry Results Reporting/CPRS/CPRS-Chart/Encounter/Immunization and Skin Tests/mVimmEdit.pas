unit mVimmEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, mVimMBase, Vcl.StdCtrls, Vcl.ExtCtrls,
  mVimmGrid, Vcl.ComCtrls, ORCtrls, ORDtTm, rVimm, ORFn, Vcl.ImgList,
  Vcl.Buttons, System.ImageList, mVimmEditGrid, mEditBase;

type
  TfraImmEdit = class(TfraParent)
  private
  published
    { Private declarations }
  protected
    dataStr: string;
    documentationType: string;
  public
    adminDate: TFMDateTime;
    { Public declarations }
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    function isEditing: boolean;
    procedure collapse;
    procedure expand;
    procedure createLayout(layout: integer; documType, data: string; edit, needsOverride: boolean);
    procedure setEncounterData(date: TFMDateTime; orderName, orderIEN, adminName, adminIEN, loc, visitStr: string);
    function saveFromMain: boolean;
    procedure cancelFromMain;
  end;


var
  fraImmEdit: TfraEditGridBase;

implementation

 uses
 mVimmSelect;

var
  vimmEditGrid: TFrame;
{$R *.dfm}

// uDlgComponents;
{ TfraImmEdit }

constructor TfraImmEdit.Create(aOwner: TComponent);
begin
  inherited;
  style := ssPercent;
  minValue := 55;
  spBtnExpandCollapse.Visible := true;
  vimmEditGrid := TfraVimmEditGrid.Create(self.pnlWorkspace);
  vimmEditGrid.Parent := self.pnlWorkspace;
  vimmEditGrid.Align := alClient;
end;


procedure TfraImmEdit.createLayout(layout: integer; documType, data: string;
  edit, needsOverride: boolean);
var
  inputList, defaultList: TStrings;
begin
  if uVimmInputs.immunizationReading then layout := 5;

  if self.fCollapsed then self.expand;
  inputList := TStringList.create;
  defaultList := TStringList.create;
  try
    TfraVimmEditGrid(vimmEditGrid).editingRecord := true;
    TfraVimmEditGrid(vimmEditGrid).vimmObjectIdx := -1;
    TfraVimmEditGrid(vimmEditGrid).setValues(data, edit, needsOverride);
    TfraVimmEditGrid(vimmEditGrid).setAdditionalInputsParameters(inputList, defaultList, layout, false);
    TfraVimmEditGrid(vimmEditGrid).createLayout(inputList, defaultList, layout);
    TfraVimmEditGrid(vimmEditGrid).setInitialValues;
    if (uVimmInputs.immunizationReading or uVimmInputs.noGrid) then
      begin
        TFraVimmEditGrid(vimmEditGrid).btnSave.Visible := false;
        TFraVimmEditGrid(vimmEditGrid).btnCancel.Visible := false;
      end;
  finally
    FreeAndNil(inputList);
    FreeAndNil(defaultList);
  end;

end;

destructor TfraImmEdit.Destroy;
begin
    inherited;

end;

procedure TfraImmEdit.collapse;
begin
    if not fCollapsed then
      begin
        spbtnExpandCollapseClick(self);
      end;
end;


procedure TfraImmEdit.expand;
begin
  spbtnExpandCollapseClick(self);
end;



function TfraImmEdit.isEditing: boolean;
begin
   result := TfraVimmEditGrid(vimmEditGrid).editingRecord;
end;

function TfraImmEdit.saveFromMain: boolean;
begin
  result := TfraVimmEditGrid(vimmEditGrid).saveGridFromMain;
end;

procedure TfraImmEdit.cancelFromMain;
begin
  TfraVimmEditGrid(vimmEditGrid).cancelGridFromMain;
end;

procedure TfraImmEdit.setEncounterData(date: TFMDateTime; orderName, orderIEN,
  adminName, adminIEN, loc, visitStr: string);
begin

end;


end.
