unit mVimmReminders;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, MVimmBase, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ImgList, Vcl.Buttons, System.ImageList, RVimm, Vcl.Grids, OrFn,
  Vcl.ComCtrls, Vcl.Menus, MVimmSelect, FRptBox, VAUtils, FBase508Form,
  VA508AccessibilityManager, ORextensions;

type

  TfraReminders = class(TfraParent)
    pnlItems: TPanel;
    remList: ORextensions.TListView;
    Splitter1: TSplitter;
    pnlDetails: TPanel;
    Splitter2: TSplitter;
    mnuAction: TPopupMenu;
    AddImmunization1: TMenuItem;
    ViewInformation1: TMenuItem;
    acClinMaint: TMenuItem;
    lstHistory: ORextensions.TListView;
    remDetails: ORExtensions.TRichEdit;
    procedure AddImmunization1Click(Sender: TObject);
    procedure ViewInformation1Click(Sender: TObject);
    procedure acClinMaintClick(Sender: TObject);
  private
    { Private declarations }
    procedure addToGrid(data: string);
    procedure updateRemMemo(remDetails: TStrings);
    procedure noReminders;
    function getReminderID: string;
    function getReminderName: string;
    procedure addToHistGrid(data: string);
    procedure viewInformation(showRemDetail: boolean);
  public
    { Public declarations }
    constructor Create(aOwner: TComponent); override;
//    destructor Destroy; override;
    procedure collapse;
    procedure populateReminders;
    procedure setup508Controls(fMgr: TVA508AccessibilityManager);
  end;

//var
//  fraReminders: TfraReminders;

implementation

{$R *.dfm}

{ TfraIce }

procedure TfraReminders.acClinMaintClick(Sender: TObject);
var
remId, remName: string;
details: TStrings;
begin
  inherited;
  remId := getReminderID;
  if remId = '' then
    exit;
  remName := getReminderName;
  details := TStringList.Create;
  try
    getReminderMaint(StrToInt(Piece(remID, U, 1)), details);
    if details.Count > 0 then
      ReportBox(details,'Clinical Maintenance: ' + remName, TRUE)
    else infoBox('Error loading Clinical maintenance', 'Error', MB_OK);
  finally
    FreeAndNil(details);
  end;
end;

procedure TfraReminders.AddImmunization1Click(Sender: TObject);
var
remId: string;
grid: TGridPanel;
aControl: TControl;
begin
  inherited;
  remId := getReminderID;
  if remId = '' then exit;
  grid := TGridPanel(self.Parent);
  aControl := grid.ControlCollection.Controls[0, 2];
  if (aControl is TfraVimmSelect) then
    begin
      if not TfraVimmSelect(aControl).canChange(remId, 'rem') then
        exit;
    end;
  viewInformation(false);
  if (aControl is TfraVimmSelect) then
    TfraVimmSelect(aControl).startFromReminders(remId);
end;

procedure TfraReminders.addToGrid(data: string);
var
 lstItem: TListItem;
 strs: TStrings;
 item: TStringList;
 idx: string;
begin
  item := TStringList.create;
  try
  remList.Items.BeginUpdate;
  strs := TStringList.Create;
  try
    idx := Piece(data, U, 1);
    strs.Add(Piece(data, U, 2));
    strs.Add(Piece(data, U, 3));
    strs.Add(Piece(data, U, 5));
    strs.Add(Piece(data, U, 4));
    lstItem := remList.Items.Add;
    lstItem.Caption := idx;
    lstItem.SubItems := strs;
  finally
    remList.Items.EndUpdate;
    FreeAndNil(strs);
  end;

  finally
    FreeAndNil(item);
  end;
end;

procedure TfraReminders.addToHistGrid(data: string);
var
 lstItem: TListItem;
 strs: TStrings;
 item: TStringList;
 idx: string;
begin
  item := TStringList.create;
  try
    lstHistory.Items.BeginUpdate;
    strs := TStringList.Create;
    idx := Piece(data, U, 1);
    if not uVimmInputs.isSkinTest then
      begin
        strs.Add(FormatFMDateTime('mm/dd/yyyy',  StrToFloatDef(Piece(data, U, 2),0)));
        strs.Add(Piece(data, U, 3));
        strs.Add(Piece(data, U, 4));
      end
    else
      begin
        strs.Add(FormatFMDateTime('mm/dd/yyyy',  StrToFloatDef(Piece(data, U, 2),0)));
        strs.Add(FormatFMDateTime('mm/dd/yyyy',  StrToFloatDef(Piece(data, U, 3),0)));
        strs.Add(Piece(data, U, 4));
        strs.Add(Piece(data, U, 5));
      end;
    lstItem := lstHistory.Items.Add;
    lstItem.Caption := idx;
    lstItem.SubItems := strs;
    lstHistory.Items.EndUpdate;
  finally
    FreeAndNil(item);
  end;

end;

procedure TfraReminders.collapse;
begin
  if not fCollapsed then spbtnExpandCollapseClick(self);
end;

constructor TfraReminders.Create(aOwner: TComponent);
var
i: integer;
temp: string;
begin
  inherited;
  style := ssPercent;
  minValue := 20;
  if uVimmInputs.isSkinTest then
    begin
      width := lstHistory.Width div 5;
      lblHeader.Caption := 'Skin Test Evaluation Statuses:';
      lstHistory.Columns.Add;
      lstHistory.Columns.Items[0].Caption := 'Name';
      lstHistory.Columns.Items[0].Width := -1;
      lstHistory.Columns.Add;
      lstHistory.Columns.Items[1].Caption := 'Date Placed';
      lstHistory.Columns.Items[1].Width := -2;
      lstHistory.Columns.Add;
      lstHistory.Columns.Items[2].Caption := 'Date Read';
      lstHistory.Columns.Items[2].Width := -2;
      lstHistory.Columns.Add;
      lstHistory.Columns.Items[3].Caption := 'Result';
      lstHistory.Columns.Items[3].Width := -2;
      lstHistory.Columns.Add;
      lstHistory.Columns.Items[4].Caption := 'Interpretation';
      lstHistory.Columns.Items[4].Width := -2;
      for I := 0 to self.mnuAction.Items.Count - 1 do
        begin
          temp := self.mnuAction.Items[i].Caption;
          self.mnuAction.Items[i].Caption := StringReplace(temp, 'Immunization', 'Skin Test', [rfReplaceAll, rfIgnoreCase]);
        end;
    end
  else
    begin
      self.lblHeader.Caption := 'Immunization Evaluation Statuses:';
      width := lstHistory.Width div 4;
      lstHistory.Columns.Add;
      lstHistory.Columns.Items[0].Caption := 'Name';
//      lstHistory.Columns.Items[0].WidthType := ssPercent;
      lstHistory.Columns.Items[0].Width := -1;
      lstHistory.Columns.Add;
      lstHistory.Columns.Items[1].Caption := 'Administration Date';
//      lstHistory.Columns.Items[1].WidthType := ssPercent;
      lstHistory.Columns.Items[1].Width := -2;
      lstHistory.Columns.Add;
      lstHistory.Columns.Items[2].Caption := 'Series';
//      lstHistory.Columns.Items[2].WidthType := ssPercent;
      lstHistory.Columns.Items[2].Width := -2;
      lstHistory.Columns.Add;
      lstHistory.Columns.Items[3].Caption := 'Facility/Source';
//      lstHistory.Columns.Items[3].WidthType := ssPercent;
      lstHistory.Columns.Items[3].Width := -2;
      if uVimmInputs.immunizationReading then self.mnuAction.Items[0].Enabled := false
      else self.mnuAction.Items[0].Enabled := true;
    end;
  lstHistory.ShowColumnHeaders := true;
  remDetails.Visible := false;
end;


function TfraReminders.getReminderID: string;
var
lstItem: TListITem;
begin
  result := '';
  if remList.ItemIndex < 0 then
    begin
      ShowMessage('No Reminder Definition selected.');
      exit;
    end;
  lstItem := remList.Items.Item[remList.ItemIndex];
  result := lstItem.Caption + U + lstItem.SubItems.Strings[0];
end;

function TfraReminders.getReminderName: string;
var
lstItem: TListITem;
begin
  result := '';
  if remList.ItemIndex < 0 then
    begin
      ShowMessage('No reminder was selected');
      exit;
    end;
  lstItem := remList.Items.Item[remList.ItemIndex];
  result := lstItem.SubItems[0];
end;

procedure TfraReminders.noReminders;
begin
  if  not fCollapsed then spbtnExpandCollapseClick(self);
  lblHeader.Caption := 'No Evalaution Data Available';
  self.spBtnExpandCollapse.Enabled := false;
end;

procedure TfraReminders.populateReminders;
var
remList: TStrings;
i: integer;
temp: string;
begin
  remList := TStringList.Create;
  try
    getReminders(remList, uVimmInputs.isSkinTest);
    if remList.Count = 0 then noReminders;
    for i := 0 to remList.Count - 1 do
      begin
        temp := remList.Strings[i];
        addToGrid(temp);
      end;
  finally
    FreeAndNil(remList);
  end;
end;

procedure TfraReminders.setup508Controls(fMgr: TVA508AccessibilityManager);
begin
  fMgr.AccessText[TWinControl(remList)] := 'Reminder List View press Shift plus F10 to activate content menu';
end;

procedure TfraReminders.updateRemMemo(remDetails: TStrings);
var
i: integer;
begin
  self.remDetails.Lines.Clear;
//  self.remDetails.Lines.AddStrings(remDetails);
  for I := 0 to remDetails.Count - 1 do
    self.remDetails.Lines.Add(remDetails.Strings[i]);
end;

procedure TfraReminders.viewInformation(showRemDetail: boolean);
var
remId: string;
histList, remDetails: TStrings;
i: integer;
begin
  inherited;
  remId := getReminderID;
  if remID = '' then
    exit;
  remDetails := TStringList.Create;
  histList := TStringList.Create;
  try
    getItemHist(histList, remId);
    self.lstHistory.Clear;
    for i := 0 to histList.Count - 1 do
      addToHistGrid(histList[i]);
    if showRemDetail then
      begin
        self.remDetails.Visible := true;
        self.lstHistory.Height := pnlDetails.Height div 2;
        self.Splitter2.Top := self.lstHistory.Top + self.lstHistory.Height;
//        if self.remDetails.Height = 0 then
//          begin
//            self.lstHistory.Height := pnlDetails.Height div 2;
//            self.Splitter2.Top := self.lstHistory.Top + self.lstHistory.Height;
//          end;
        self.pnlDetails.Refresh;
        getReminderMaint(StrToInt(Piece(remID, U, 1)), remDetails);
        updateRemMemo(remDetails);
      end
    else
      begin
        self.lstHistory.Height := self.pnlDetails.Height - self.Splitter2.Height;
        self.Splitter2.Top := self.lstHistory.Top + self.lstHistory.Height;
        self.remDetails.Visible := false;
        self.pnlDetails.Refresh;
      end;
  finally
    FreeAndNil(histList);
    FreeAndNil(remDetails);
  end;
end;

procedure TfraReminders.ViewInformation1Click(Sender: TObject);
begin
  inherited;
  viewInformation(true);
end;

//destructor TfraIce.Destroy;
//begin
////  pnlIce.Destroy;
////  inherited;
////  if fraIce <> nil then FreeAndNil(fraIce);
//end;

end.
