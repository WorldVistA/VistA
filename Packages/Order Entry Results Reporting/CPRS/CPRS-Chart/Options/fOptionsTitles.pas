unit fOptionsTitles;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ORCtrls, ORFn, fBase508Form, VA508AccessibilityManager,
  Vcl.Buttons;

type
  TfrmOptionsTitles = class(TfrmBase508Form)
    lblDocumentClass: TLabel;
    lblDocumentTitles: TLabel;
    lblYourTitles: TLabel;
    lblDefaultTitle: TStaticText;
    lblDefault: TStaticText;
    cboDocumentClass: TORComboBox;
    lstYourTitles: TORListBox;
    btnAdd: TButton;
    btnRemove: TButton;
    btnDefault: TButton;
    btnSaveChanges: TButton;
    pnlBottom: TPanel;
    bvlBottom: TBevel;
    btnOK: TButton;
    btnCancel: TButton;
    cboDocumentTitles: TORComboBox;
    lblDocumentPreference: TStaticText;
    btnDown: TButton;
    btnUp: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure cboDocumentClassClick(Sender: TObject);
    procedure cboDocumentTitlesNeedData(Sender: TObject;
      const StartFrom: String; Direction, InsertAt: Integer);
    procedure btnSaveChangesClick(Sender: TObject);
    procedure btnDefaultClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure lstYourTitlesChange(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure cboDocumentTitlesChange(Sender: TObject);
    procedure btnUpClick(Sender: TObject);
    procedure btnDownClick(Sender: TObject);
    function GetFirstSelection(aList: TORListBox): integer;
    procedure SetItem(aList: TORListBox; index: integer);
    procedure RemoveSelected;
    procedure lstYourTitlesClick(Sender: TObject);
  private
    { Private declarations }
    FLastClass: integer;
    procedure AddIfUnique(entry: string; aList: TORListBox);
    function MemberNotOnList(alist: TStrings; listnum: string): boolean;
    procedure CheckEnable;
  public
    { Public declarations }
  end;

var
  frmOptionsTitles: TfrmOptionsTitles;

procedure DialogOptionsTitles(topvalue, leftvalue, fontsize: integer; var actiontype: Integer);

implementation

{$R *.DFM}

uses
  rOptions, uOptions, rCore, rTIU, rConsults, rDCSumm, VAUtils;

procedure DialogOptionsTitles(topvalue, leftvalue, fontsize: integer; var actiontype: Integer);
// create the form and make it modal, return an action
var
  frmOptionsTitles: TfrmOptionsTitles;
begin
  frmOptionsTitles := TfrmOptionsTitles.Create(Application);
  actiontype := 0;
  try
    with frmOptionsTitles do
    begin
      if (topvalue < 0) or (leftvalue < 0) then
        Position := poScreenCenter
      else
      begin
        Position := poDesigned;
        Top := topvalue;
        Left := leftvalue;
      end;
      //ResizeAnchoredFormToFont(frmOptionsTitles);
      ShowModal;
      actiontype := btnOK.Tag;
    end;
  finally
    frmOptionsTitles.Release;
  end;
end;

procedure TfrmOptionsTitles.FormShow(Sender: TObject);
var
  i: integer;
begin
  FLastClass := -1;
  with cboDocumentClass do
  begin
    rpcGetClasses(cboDocumentClass.Items);
    Items.Add(IntToStr(IdentifyConsultsClass) + U + 'Consults');
    for i := 0 to Items.Count - 1 do
      if Piece(Items[i], '^', 2) = 'Progress Notes' then
      begin
        ItemIndex := i;
        FLastClass := ItemIndex;
        break;
      end;
  end;
  cboDocumentClassClick(self);
end;

procedure TfrmOptionsTitles.btnOKClick(Sender: TObject);
begin
  if btnSaveChanges.Enabled then
    btnSaveChangesClick(self);
  ResetTIUPreferences;
  ResetDCSummPreferences;
end;

procedure TfrmOptionsTitles.cboDocumentClassClick(Sender: TObject);
var
  aList: TStringList;
  defaultIEN: Integer;
begin
  if btnSaveChanges.Enabled then
  begin
    if InfoBox('Do you want to save changes to your '
        + Piece(cboDocumentClass.Items[FLastClass], '^', 2) + ' defaults?',
        'Confirmation', MB_YESNO or MB_ICONQUESTION) = IDYES then
      btnSaveChangesClick(self);
  end;
  cboDocumentTitles.Text := '';
  cboDocumentTitles.InitLongList('');
  aList := TStringList.Create;
  try
  with lstYourTitles do
  begin
        rpcGetTitlesForUser(cboDocumentClass.ItemIEN, aList);
    SortByPiece(aList, '^', 3);
    FastAssign(aList, lstYourTitles.Items);
    defaultIEN := rpcGetTitleDefault(cboDocumentClass.ItemIEN);
    if defaultIEN > 0 then SelectByIEN(defaultIEN)
    else ItemIndex := -1;
    if ItemIndex > -1 then
        if defaultIEN > 0 then SelectByIEN(defaultIEN)
        else ItemIndex := -1;
      if defaultIEN > 0 then
        SelectByIEN(defaultIEN)
      else
        ItemIndex := -1;
        if (ItemIndex > -1) and (defaultIEN > 0) then
    begin
      lblDefault.Caption := DisplayText[ItemIndex];
      lblDefault.Tag := ItemIEN;
    end
    else
    begin
      lblDefault.Caption := '<no default specified>';
      lblDefault.Tag := 0;
    end;
  end;
  lstYourTitlesChange(self);
  btnSaveChanges.Enabled := false;
  FLastClass := cboDocumentClass.ItemIndex;
  CheckEnable;
  finally
    FreeAndNil(aList);
end;
end;

procedure TfrmOptionsTitles.cboDocumentTitlesNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
var
  aResults: TStringList;
begin
  with cboDocumentTitles do
    begin
      aResults := TStringList.Create;
      try
      HideSynonyms := (cboDocumentClass.ItemIEN <> CLS_PROGRESS_NOTES);
        rpcGetTitlesForClass(cboDocumentClass.ItemIEN, StartFrom, Direction, aResults);
        ForDataUse(aResults);
      finally
        FreeAndNil(aResults);
      end;
    end;
end;

procedure TfrmOptionsTitles.btnSaveChangesClick(Sender: TObject);
var
  classnum: integer;
begin
  classnum := strtointdef(Piece(cboDocumentClass.Items[FLastClass], '^', 1), 0);
  if classnum > 0 then
  begin
    rpcSaveDocumentDefaults(classnum, lblDefault.Tag, lstYourTitles.Items);
    btnSaveChanges.Enabled := false;
    if      classnum =  CLS_PROGRESS_NOTES     then ResetNoteTitles
    else if classnum =  CLS_DC_SUMM            then ResetDCSummTitles
    else if classnum =  IdentifyConsultsClass  then ResetConsultTitles
    else if classnum =  IdentifyClinProcClass  then ResetClinProcTitles;
  end;
end;

procedure TfrmOptionsTitles.btnDefaultClick(Sender: TObject);
begin
  with lstYourTitles do
    if ItemIndex > -1 then
    begin
      if btnDefault.Caption = 'Set as Default' then
      begin
        lblDefault.Caption := DisplayText[ItemIndex];
        lblDefault.Tag := ItemIEN;
        btnDefault.Caption := 'Remove Default';
      end
      else
      begin
        lblDefault.Caption := '<no default specified>';
        lblDefault.Tag := 0;
        btnDefault.Caption := 'Set as Default';
      end;
      btnDefault.Enabled := true;
    end
    else
    begin
      lblDefault.Caption := '<no default specified>';
      lblDefault.Tag := 0;
      btnDefault.Enabled := false;
    end;
    btnSaveChanges.Enabled := true;
end;

procedure TfrmOptionsTitles.btnAddClick(Sender: TObject);
begin
  AddIfUnique(cboDocumentTitles.Items[cboDocumentTitles.ItemIndex], lstYourTitles);
  lstYourTitles.SelectByIEN(cboDocumentTitles.ItemIEN);
  btnSaveChanges.Enabled := true;
  btnAdd.Enabled := false;
  CheckEnable;
end;

procedure TfrmOptionsTitles.lstYourTitlesChange(Sender: TObject);
begin
  with btnDefault do
  begin
    if lstYourTitles.SelCount = 1 then
    begin
      if lstYourTitles.ItemIEN = lblDefault.Tag then
        Caption := 'Remove Default'
      else
        Caption := 'Set as Default';
      Enabled := true;
    end
    else
      Enabled := false;
  end;
  //CheckEnable;             // ?? causes access violation
end;

procedure TfrmOptionsTitles.btnRemoveClick(Sender: TObject);
var
  index: integer;
begin
  index := GetFirstSelection(lstYourTitles);
  RemoveSelected;
  SetItem(lstYourTitles, index);
  CheckEnable;
  if lstYourTitles.Items.Count = 0 then
  begin
    btnDefault.Enabled := false;
    btnRemove.Enabled := false;
  end
  else
    lstYourTitlesChange(self);
  btnSaveChanges.Enabled := true;
end;

procedure TfrmOptionsTitles.AddIfUnique(entry: string; aList: TORListBox);
var
  i: integer;
  ien: string;
  inlist: boolean;
begin
  ien := Piece(entry, '^', 1);
  inlist := false;
  with aList do
  for i := 0 to Items.Count - 1 do
    if ien = Piece(Items[i], '^', 1) then
    begin
      inlist := true;
      break;
    end;
  if not inlist then
    aList.Items.Add(entry);
end;

function TfrmOptionsTitles.MemberNotOnList(alist: TStrings; listnum: string): boolean;
var
  i: integer;
begin
  result := true;
  with alist do
  for i := 0 to Count - 1 do
    if listnum = Piece(alist[i], '^', 1) then
    begin
      result := false;
      break;
    end;
end;

procedure TfrmOptionsTitles.cboDocumentTitlesChange(Sender: TObject);
begin
  CheckEnable;
end;

procedure TfrmOptionsTitles.btnUpClick(Sender: TObject);
var
  newindex, i: integer;
begin
  with lstYourTitles do
  begin
    i := 0;
    while i < Items.Count do
    begin
      if Selected[i] then
      begin
        newindex := i - 1;
        Items.Move(i, newindex);
        Selected[newindex] := true;
      end;
      inc(i)
    end;
  end;
  btnSaveChanges.Enabled := true;
  CheckEnable;
  lstYourTitlesChange(self);
end;

procedure TfrmOptionsTitles.btnDownClick(Sender: TObject);
var
  newindex, i: integer;
begin
  with lstYourTitles do
  begin
    i := Items.Count - 1;
    while i > -1 do
    begin
      if Selected[i] then
      begin
        newindex := i + 1;
        Items.Move(i, newindex);
        Selected[newindex] := true;
      end;
      dec(i)
    end;
  end;
  btnSaveChanges.Enabled := true;
  CheckEnable;
  lstYourTitlesChange(self);
end;

function TfrmOptionsTitles.GetFirstSelection(aList: TORListBox): integer;
begin
  for result := 0 to aList.Items.Count - 1 do
    if aList.Selected[result] then exit;
  result := LB_ERR;
end;

procedure TfrmOptionsTitles.SetItem(aList: TORListBox; index: integer);
var
  maxindex: integer;
begin
  with aList do
  begin
    SetFocus;
    maxindex := aList.Items.Count - 1;
    if Index = LB_ERR then
      Index := 0
    else if Index > maxindex then Index := maxindex;
    Selected[index] := true;
  end;
  //CheckEnable;
end;

procedure TfrmOptionsTitles.RemoveSelected;
var
  i: integer;
begin
  for i := lstYourTitles.Items.Count - 1 downto 0 do
  begin
    if lstYourTitles.Selected[i] then
    begin
      if strtoint(Piece(lstYourTitles.Items[i], '^' ,1)) = lblDefault.Tag then
      begin
        lblDefault.Caption := '<no default specified>';
        lblDefault.Tag := 0;
        btnDefault.Enabled := false;
      end;
      lstYourTitles.Items.Delete(i);
    end;
  end;
end;

procedure TfrmOptionsTitles.CheckEnable;
// allow buttons to be enabled or not depending on selections
var
  astring: string;
begin
  with lstYourTitles do
  begin
    if Items.Count > 0 then
    begin
      if SelCount > 0 then
      begin
        btnUp.Enabled     := (SelCount > 0)
                             and (not Selected[0]);
        btnDown.Enabled   := (SelCount > 0)
                             and (not Selected[Items.Count - 1]);
        btnRemove.Enabled := true;
      end
      else
      begin
        btnUp.Enabled     := false;
        btnDown.Enabled   := false;
        btnRemove.Enabled := false;
      end;
    end
    else
    begin
      btnUp.Enabled     := false;
      btnDown.Enabled   := false;
      btnRemove.Enabled := false;
    end;
  end;
  with cboDocumentTitles do
  if ItemIndex > -1 then
  begin
    astring := ItemID;
    btnAdd.Enabled := MemberNotOnList(lstYourTitles.Items, astring);
  end
  else
    btnAdd.Enabled := false;
end;

procedure TfrmOptionsTitles.lstYourTitlesClick(Sender: TObject);
begin
  lstYourTitlesChange(self);    // need to check default
  CheckEnable;
end;

end.
