unit mVimmGrid;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, mVimmBase, Vcl.Grids, Vcl.StdCtrls,
  Vcl.ExtCtrls, rVimm, Vcl.ComCtrls, ORFn, Vcl.Menus, Vcl.ImgList, Vcl.Buttons,
  System.ImageList, VA508AccessibilityManager, ORextensions;

type
  TfraGrid = class(TfraParent)
    lstView: ORextensions.TListView;
    popMenu: TPopupMenu;
    addImm: TMenuItem;
    editImm: TMenuItem;
    delImm: TMenuItem;
    viewImm: TMenuItem;
    btnAdd: TButton;
    procedure popMenuPopup(Sender: TObject);
    procedure addImmClick(Sender: TObject);
    procedure editImmClick(Sender: TObject);
    procedure viewImmClick(Sender: TObject);
    procedure delImmClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnAddKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
//    procedure startUpdates(immunization: string = ''; details: boolean = false);
    function setDataStr: string;
  public
    { Public declarations }
    constructor Create(aOwner: TComponent); override;
//    destructor Destroy; override;
    procedure updateGrid;
    procedure addListToGrid(inputList: TStringList; documentType: string);
    procedure addToGrid(row, idx: integer; vimmData: TVimmResult);
    function getRowIndex(idx: integer; vimmData: TVimmResult): integer;
    procedure collapse;
    procedure expand;
    function validateGridResults: boolean;
    procedure startUpdates(immunization: string = ''; details: boolean = false);
    procedure setText(isSkin: boolean);
    function gridCount: integer;
    procedure setup508Controls(fMgr: TVA508AccessibilityManager);
  end;

//var
//  fraGrid: TfraGrid;

implementation

uses
  mVimmSelect, mVimmEdit;

{$R *.dfm}

{ TfraGrid }

procedure TfraGrid.addImmClick(Sender: TObject);
begin
  startUpdates('');
end;

//add initial values to the grid values have to be pass in from calling application
procedure TfraGrid.addListToGrid(inputList: TStringList; documentType: string);
var
i,idx: integer;
tmp: string;
hasGeneric: string;
begin
  hasGeneric := '';
//  idx := -1;
  for i := 0 to inputList.Count - 1 do
    begin
      tmp := inputList.Strings[i];
      if Piece(tmp, U, 3) = '-1' then
        begin
          if Piece(tmp, U, 2) = genericImm then
            begin
              hasGeneric := tmp;
              continue;
            end;
          if uVimmInputs.isSkinTest then
            begin
              if placementsOnFile then
                begin
                  documentType := '4';
                  uVimmInputs.documentType := '4';
                end;
            end;
//          if inputList.Count = 1 then idx := setInitialVimmResult(tmp, documentType)
//          else idx := setInitialVimmResult(tmp, '');
          idx := setInitialVimmResult(tmp, documentType);
          if idx = -1 then continue;
        end
      else StrToIntDef(Piece(tmp, U, 3),-1);
//      updateGrid(idx);
    end;
  updateGrid;
  if (inputList.count = 1) and (uVimmInputs.startInEditMode) then
    begin
      if hasGeneric <> '' then
        begin
          startUpdates(hasGeneric, false);
        end
      else
        begin
          self.lstView.ItemIndex := 0;
          editImmClick(self);
        end;
    end;
end;

//add an individual item to the grid. Both from initial list and from editor and the add button
procedure TfraGrid.addToGrid(row, idx: integer; vimmData: TVimmResult);
var
 lstItem: TListItem;
 strs: TStrings;
 item: TStringList;
begin
  item := TStringList.create;
  try
  lstView.Items.BeginUpdate;
  strs := TStringList.Create;
  try
    if vimmData.name = genericIMM then strs.Add('')
    else strs.Add(vimmData.name);
    strs.Add(vimmData.documType);
    if vimmData.isComplete then
      begin
        strs.Add('Complete');
      end
    else strs.Add('Incomplete');
    strs.Add(vimmData.uniqueID);
    if row > -1 then
      begin
        lstView.Items.Item[row].Caption := IntToStr(idx);
        lstView.Items.Item[row].SubItems := strs;
      end
    else
      begin
        lstItem := lstView.Items.Add;
        lstItem.Caption := IntToStr(idx);
        lstItem.SubItems := strs;
      end;
  finally
    lstView.Items.EndUpdate;
    FreeAndNil(strs);
  end;
  finally
    item.free;
  end;

end;

procedure TfraGrid.btnAddClick(Sender: TObject);
begin
  inherited;
  StartUpdates('');
end;

procedure TfraGrid.btnAddKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  StartUpdates('');
end;

procedure TfraGrid.collapse;
begin
  if not fcollapsed then spbtnExpandCollapseClick(self);
end;

constructor TfraGrid.Create(aOwner: TComponent);
var
i: integer;
temp: string;
begin
  inherited;
  style := ssAbsolute;
  minValue := pnlWorkspace.Top + pnlWorkspace.Height;
  if uVimmInputs.isSkinTest then
    begin
      for I := 0 to self.popMenu.Items.Count - 1 do
        begin
          temp := self.popMenu.Items[i].Caption;
          self.popMenu.Items[i].Caption := StringReplace(temp, 'Immunization', 'Skin Test', [rfReplaceAll, rfIgnoreCase]);
        end;
    end;
end;

procedure TfraGrid.delImmClick(Sender: TObject);
var
immunization: string;
aControl, eControl: TControl;
grid: TGridPanel;
begin
//  inherited;
  grid := TGridPanel(self.Parent);
  aControl := grid.ControlCollection.Controls[0, 2];
  if (aControl is TfraVimmSelect) then
    begin
      eControl := (aControl as TfraVimmSelect).getEditControl;
      if (eControl is TFraImmEdit) and ((eControl as TFraImmEdit).isEditing) then
        begin
          ShowMessage('Cannot add a new item while editing an active record. Click the Clear or Save button to exit the current record.');
          exit;
        end;
    end;
  immunization := setDataStr;
  if immunization = '' then exit;
  if infoBox('You are about to delete ' + Piece(immunization, U, 2) + '. Are you sure?', 'Delete record?', MB_YESNO) = mrYes then
    begin
      if removeVimmResult(immunization) = false then
        begin
          ShowMessage('Problem removing record.');
          Exit;
        end;
      lstView.DeleteSelected;
      grid := TGridPanel(self.Parent);
      aControl := grid.ControlCollection.Controls[0, 2];
      if (aControl is TfraVimmSelect) then
      TfraVimmSelect(aControl).clearEditFields;
    end;
end;

procedure TfraGrid.editImmClick(Sender: TObject);
var
dataStr: string;
begin
  dataStr := setDataStr;
  if dataStr = '' then exit;
  startUpdates(dataStr);
end;

procedure TfraGrid.expand;
begin
  if fCollapsed then spbtnExpandCollapseClick(self);
end;

//find row that matches the vimm result data
function TfraGrid.getRowIndex(idx: integer; vimmData: TVimmResult):integer;
var
 lstItem: TListItem;
 i: integer;
begin
  result := -1;
  for i := 0 to lstView.Items.Count - 1 do
    begin
      lstItem := lstView.Items.Item[i];
      if lstItem.Caption = IntToStr(idx) then
        begin
          result := i;
          exit;
        end;
    end;
end;

function TfraGrid.gridCount: integer;
begin
  result := self.lstView.Items.Count;
end;

procedure TfraGrid.popMenuPopup(Sender: TObject);
begin
    if lstView.ItemIndex = -1 then
      begin
        popMenu.Items[1].Enabled := false;
        popMenu.Items[2].Enabled := false;
        popMenu.Items[3].Enabled := false;
      end
    else begin
      popMenu.Items[1].Enabled := true;
      popMenu.Items[1].Enabled := true;
      popMenu.Items[2].Enabled := true;
      popMenu.Items[3].Enabled := true;
    end;

end;

//build immunization string
//pick list id^name^documentation Type
//or
//result id^name^documentation type
function TfraGrid.setDataStr: string;
var
lstItem: TListItem;
idx: integer;
documType, name, uid, vid: string;
begin
  result := '';
  idx := lstView.ItemIndex;
  if idx = -1 then
    begin
      ShowMessage('No row selected');
      exit;
    end;
  lstItem := lstView.Items.Item[idx];
  vid := lstItem.Caption;
  name := lstItem.SubItems[0];
  documType := lstItem.SubItems[1];
  uid := lstItem.SubItems[3];
  result := vid + U + name + U + documType + U + uid;
end;

procedure TfraGrid.setText(isSkin: boolean);
begin
  if isSkin then
    begin
      self.lblHeader.Caption := 'Skin Test List';
      self.lstView.Columns.Items[1].Caption := 'Skin Test';
      self.btnAdd.Caption := 'Add Skin Test';
    end
  else
    begin
      self.lblHeader.Caption := 'Immunization List';
      self.lstView.Columns.Items[1].Caption := 'Immunization';
      self.btnAdd.Caption := 'Add Immunization';
    end;
end;

procedure TfraGrid.setup508Controls(fMgr: TVA508AccessibilityManager);
begin
  if uVimmInputs.isSkinTest then
    fMgr.AccessText[TWinControl(lstView)] := 'Skin Test List press Shift plus F10 to activate content menu'
  else fMgr.AccessText[TWinControl(lstView)] := 'Immunization List press Shift plus F10 to activate content menu';
end;

//calls to the immunization frame to start the update process
//both new and edit records
procedure TfraGrid.startUpdates(immunization: string = ''; details: boolean = false);
var
grid: TGridPanel;
aControl, eControl: TControl;
edit: boolean;
begin
  grid := TGridPanel(self.Parent);
  aControl := grid.ControlCollection.Controls[0, 2];
  if (aControl is TfraVimmSelect) then
    begin
      eControl := (aControl as TfraVimmSelect).getEditControl;
      if (eControl is TFraImmEdit) and ((eControl as TFraImmEdit).isEditing) then
        begin
          ShowMessage('Cannot add a new item while editing an active record. Click the Clear or Save button to exit the current record.');
          exit;
        end;
    end;
  if immunization = '' then edit := false
//  else edit := true;
  else edit := hasVimmResultData(immunization);
  if (aControl is TfraVimmSelect) then
    TfraVimmSelect(aControl).startEdits(immunization, details, edit);
end;

procedure TfraGrid.updateGrid;
var
vimmData: TVimmResult;
i: integer;
begin
  if uVimmResults.results = nil then exit;
  self.lstView.Clear;
  for i := 0 to uVimmResults.results.Count - 1 do
    begin
      vimmData := TVimmResult(uVimmResults.results.Objects[i]);
      addToGrid(-1, i, vimmData);
    end;
//  vimmData := getVimmResultById(idx);
//  i := getRowIndex(idx, vimmData);
//  addToGrid(i, idx, vimmData);
end;

//check all rows for a status of complete.
//the only way the form can save data if grid is showing
function TfraGrid.validateGridResults: boolean;
var
row: integer;
lstItem: TListItem;
begin
  result := true;
  for row := 0 to self.lstView.Items.Count -1 do
    begin
      lstItem := lstView.Items.Item[row];
      if lstItem.SubItems[2] <> 'Complete' then
        begin
          result := false;
          exit;
        end;
    end;
end;

procedure TfraGrid.viewImmClick(Sender: TObject);
var
immunization: string;
begin
  immunization := setDataStr;
  if immunization = '' then exit;
  startUpdates(immunization, true);
end;

end.
