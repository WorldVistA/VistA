unit uEditObject;
interface

uses
Vcl.Forms, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Controls, Vcl.graphics,  Vcl.Dialogs,
Vcl.CheckLst,
Winapi.Windows, Winapi.Messages,
System.Classes, System.SysUtils, System.UITypes,
VA508AccessibilityManager, rEditObject, ORCtrls, ORDtTm, ORFn, ORNetINTF, VAUtils, rCore, fBase508Form;

type

tLayout = class(TObject)
  private
  procedure returnDataForType(name: string; dataList: TStrings; var returnList: TStrings);
  procedure returnDataDefaultForType(name: string; dataDefaultList: TStrings; var returnList: TStrings);
  procedure returnAboveTheLineForType(name: string; dataLineList: TStrings; var returnList: TStrings);
  protected
  fname              : string;
  frow               : integer;
  fcolumn            : integer;
  flayoutType        : integer;
  fcontrols          : TStringList;
  fInputList         : TStrings;
  public
  hasNoData: boolean;
  constructor Create; overload;
  destructor Destroy; override;
  procedure initilizeLookups;
  procedure buildLayout(inputList, defaultList: TStrings);
  procedure returnComponentDataList(name: string; dataList: TStrings);
  function validateData(compList: TStrings): boolean;
  function validate(list, inputList, resultList: TStrings): boolean;
  procedure clearLayoutControls;
  function getControlIndex(name: string): integer;
  function getObject(idx: integer): TObject;
  property name: string read fname write fname;
  property row: integer read frow write frow;
  property column: integer read fcolumn write fcolumn;
  property layoutType: integer read flayoutType write flayoutType;
  property controls: TStringList read fcontrols write fcontrols;
  property inputList: TStrings read fInputList write fInputList;
end;

TLayoutControl = class(TObject)
  private
  protected
  public
  name            : string;
  caption         : string;
  control         : string;
  required        : boolean;
  needSort        : boolean;
  colNum          : integer;
  rowNum          : integer;
  ColSpan         : integer;
  intValue        : string;
  extValue        : string;
  uiControl       : TObject;
  dataList        : TStrings;
  dataDefaultList : TStrings;
  aboveTheLineList : TStrings;
  fAboveTheLine   : boolean;
  fenabled        : boolean;
  setDefault      : boolean;
  constructor Create; overload;
  destructor Destroy; override;
end;

tEditObject = class(TObject)
private

protected
  caption       : string;
  required      : boolean;
  comboBox: boolean;
  flongList: boolean;
  needSort: boolean;
  fintVal: string;
  fextVal: string;
  feditIntValue: string;
  feditExtValue: string;
  dataList: TStrings;
  dataDefaultList: TStrings;
  controlType: string;
  setDefault: boolean;
  procedure CreateControl(layoutControl: TLayoutControl; AOwner, AParent: TWinControl);
  procedure CreateLabel(layoutControl: TLayoutControl; AOwner, AParent: TWinControl);
  procedure CreatePanel(layoutControl: TLayoutControl; AOwner, AParent: TWinControl);
//  procedure loadUsers(control: TControl; const StartFrom: string; Direction, InsertAt: Integer; providerOnly: boolean);
  procedure onNeedData(sender: TObject; const StartFrom: string; Direction, InsertAt: integer); virtual;
  procedure promptChange(Sender: TObject); virtual;
  procedure validatePrompt(Sender: TObject); virtual;
  procedure setDefaultValue;
  procedure setComboBoxDefault(editIntVal, editExtVal: string); virtual;
  procedure setEditDefault(editIntVal, editExtVal: string);
  procedure setDateDefault(editIntVal, editExtVal: string);
  procedure setLabelDefault(editIntVal, editExtVal: string);
  procedure setCheckBoxDefault(editIntVal, editExtVal: string);
  procedure populateComponent;
  procedure populateDefaultList;
  procedure populateAboveTheLine(name: string; aboveTheLineList: TStrings);
  procedure update508Label;
  procedure keyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  function validateObject: string;
public
  editPanel     : TPanel;
  editLabel     : TStaticText;
  editComponent : TControl;
  name          : string;
  origWidth     : integer;
  VA508Label    : TVA508StaticText;
  controlEnabled: boolean;
  property longList: boolean read flongList write flongList;
  property extVal: string read fextVal write fextVal;
  property intVal: string read fIntVal write fIntVal;
  property editIntValue: string read feditIntValue write feditIntValue;
  property editExtValue: string read feditExtValue write feditExtValue;
  constructor Create(layoutControl: TLayoutControl; AOwner, AParent: TWinControl);
  destructor Destroy; override;
  procedure update508Text(enabled: boolean);
end;

PromptType = (ptEdit, ptDate, ptDateBox, ptCBO, ptCBOLongList, ptLabel, ptCheckListBox, ptMemo, ptRadioGroup, ptCheckBox, ptListBox);

implementation


{ editObject }

constructor tEditObject.Create(layoutControl: TLayoutControl; AOwner, AParent: TWinControl);
var
tempCaption: string;
begin
  name := layoutControl.name;
  required := layoutControl.required;
  caption := layoutControl.caption;
  needSort := layoutControl.needSort;
  setDefault := layoutControl.setDefault;
  dataList := TStringList.create;
  dataDefaultList := TStringList.Create;
  if layoutControl.dataList <> nil then
    begin
//      dataList := TStringList.create;
      FastAssign(layoutControl.dataList, dataList);
    end;
  if layoutControl.dataDefaultList <> nil then
    begin
//      dataDefaultList := TStringList.Create;
      FastAssign(layoutControl.dataDefaultList, dataDefaultList);
    end;
  editIntValue := layoutControl.intValue;
  editExtValue := layoutControl.extValue;
  controlEnabled := false;
  CreatePanel(layoutControl, AOwner, AParent);
  CreateControl(layoutControl, AOwner, AParent);
  CreateLabel(layoutControl, AOwner, AParent);
  if screenReaderActive then
    begin
      if required then tempCaption := caption + ' (Required)'
      else tempCaption := caption;
      if (GetParentForm(editComponent) is TfrmBase508Form) then
        begin
          if editComponent is TStaticText then
            (GetParentForm(editComponent) as TfrmBase508Form).amgrMain.AccessText[TWinControl(editComponent)] := tempCaption + ' ' + (editComponent as TStaticText).caption
          else
          (GetParentForm(editComponent) as TfrmBase508Form).amgrMain.AccessText[TWinControl(editComponent)] := tempCaption;
        end;
//      if (editComponent is TORComboBox) then
//        (editComponent as TORComboBox).Caption := editLabel.Caption;
    end;
end;

procedure tEditObject.CreateControl(layoutControl: TLayoutControl; AOwner, AParent: TWinControl);
var
  lblPt: TStaticText;
  edt: TEdit;
  orCBO: TORComboBox;
  orDTE: TORDateBox;
  orDTC: TORDateCombo;
  rgp: TRadioGroup;
  chk: TCheckBox;
  memo: TMemo;
  M, d, Y: Word;
  orLstBox: TORListBox;
//  controlType: string;
  ptType: PromptType;

  function findIndex(control: TControl; lookUp: string): integer;
    begin
      result := (control as TORComboBox).Items.IndexOf(lookup);
    end;
begin
  controlType := layoutControl.control;
  if controlType = 'ptCBO' then ptType := ptCBO
  else if controlType = 'ptLabel' then ptType := ptLabel
  else if controlType = 'ptDate' then ptType := ptDate
  else if controlType = 'ptDateTime' then ptType := ptDate
  else if controlType = 'ptDateBox' then ptType := ptDateBox
  else if controlType = 'ptEdit' then ptType := ptEdit
  else if controlType = 'ptCBOLongList' then ptType := ptCBOLongList
  else if controlType = 'ptCheckListBox' then ptType := ptCheckListBox
  else if controlType = 'ptCBOFreeText' then ptType := ptCBO
  else if controlType = 'ptMemo' then ptType := ptMemo
  else if controlType = 'ptRadioGroup' then ptType := ptRadioGroup
  else if controlType = 'ptCheckBox' then ptType := ptCheckBox
  else if controlType = 'ptListBox' then ptType := ptListBox
  else
    begin
     ShowMessage('Control type ' + ControlType + ' is not valid');
     exit;
    end;


  case ptType of
    ptCBO, ptCBOLongList, ptCheckListBox:
      begin
        orCBO := TORComboBox.Create(AOwner);
        orCBO.Parent := editPanel;
        orCBO.Align := alTop;
        comboBox := true;
        if ptType = ptCBOLongList then
        begin
          orCBO.LongList := true;
          orCBO.OnNeedData := onNeedData;
          longList  := true;
        end
        else
          orCBO.LongList := false;
        if ptType = ptCheckListBox then
          begin
            orCBO.CheckBoxes := true;
//            TCheckListBox(orCBO).IntegralHeight := true; // RTC 1299114
          end;
        orCBO.Style := orcsDropDown;
        orCBO.Pieces := '2';
        orCBO.LookupPiece := 2;
        orCBO.Top := 1;
        if needSort then orCBO.Sorted := true
        else orCBO.Sorted := false;
        editComponent := orCBO;
        orCBO.OnChange := promptChange;
        orCBO.OnExit := validatePrompt;
        orCBO.OnKeyUp := keyUP;
        orCBO.TabStop := true;
        orCBO.UniqueAutoComplete := true;
        if (layoutControl.fenabled = false) then
          begin
            orCBO.Enabled := false;
            orCBO.Color := cl3DLight;
            controlEnabled := false;
          end
        else
          controlEnabled := true;
      end;
    ptListBox:
      begin
        orLstBox := TORListBox.Create(AOwner);
        orLstBox.Parent := editPanel;
        orLstBox.Align := alTop;
        orLstBox.OnClick := promptChange;
        orLstBox.OnExit := validatePrompt;
        orLstBox.LongList := false;
        orLstBox.Delimiter := '^';
        orLstBox.MultiSelect := false;
        orlstBox.Pieces := '2';
        orlstBox.LookupPiece := 2;
        orlstBox.TabPositions := '2';
        orlstBox.Style := lbStandard;
        editComponent := orLstBox;
        if (layoutControl.fenabled = false) then
          begin
            orlstBox.Enabled := false;
            orlstBox.Color := cl3DLight;
            controlEnabled := false;
          end
        else
          controlEnabled := true;;
      end;
    ptLabel:
      begin
        lblPt := TStaticText.Create(AOwner);
        lblPt.Parent := editPanel;
        lblPt.Align := alTop;
        lblPt.caption := 'Unknown';
        lblPt.Top := 1;
        lblPt.Visible := true;
        editComponent := lblPT;
        if ScreenReaderActive then lblPt.TabStop := true;

      end;
    ptDate:
      begin
        orDTE := TORDateBox.Create(AOwner);
        orDTE.Parent := editPanel;
        orDTE.Align := alTop;
        orDTE.DateOnly := (controlType = 'ptDate');
        orDTE.RequireTime := false;
        ordte.Format := 'mmm d,yyyy@hh:nn';
        editComponent := orDTE;
        orDTE.OnChange := promptChange;
        orDTE.OnExit := validatePrompt;
        orDTE.Top := 1;
        orDTE.TabStop := true;
        if (layoutControl.fenabled = false) then
          begin
            orDTE.Enabled := false;
            controlEnabled := false;
          end
        else
          controlEnabled := true;
      end;
    ptDateBox:
      begin
        orDTC := TORDateCombo.Create(AOwner);
        orDTC.Parent := editPanel;
        DecodeDate(Now, Y, M, d);
        orDTC.Year := Y;
        orDTC.Align := alTop;
        editComponent := orDTC;
        orDTC.OnChange := promptChange;
        orDTC.Top := 1;
        orDTC.TabStop := true;
        if (layoutControl.fenabled = false) then
          begin
            orDTC.Enabled := false;
            controlEnabled := false;
          end
        else
          controlEnabled := true;
      end;
    ptEdit:
      begin
        edt := TEdit.Create(AOwner);
        edt.Parent := editPanel;
        edt.Align := alTop;
        editComponent := edt;
        edt.OnChange := promptChange;
        edt.OnExit := validatePrompt;
        edt.Top := 1;
        edt.TabStop := true;
        if (layoutControl.fenabled = false) then
          begin
            edt.Enabled := false;
            edt.Color := cl3DLight;
            controlEnabled := false;
          end
        else
          controlEnabled := true;
      end;
    ptMemo:
      begin
        memo := TMemo.Create(AOwner);
        memo.Parent := editPanel;
        memo.Align := alClient;
        editComponent := memo;
        memo.OnChange := promptChange;
        memo.OnExit := validatePrompt;
        memo.Top := 1;
        memo.TabStop := true;
        if (layoutControl.fenabled = false) then
          begin
            memo.Enabled := false;
            memo.Color := cl3DLight;
            controlEnabled := false;
          end
        else
          controlEnabled := true;
      end;
    ptRadioGroup:
      begin
        rgp := TRadioGroup.Create(AOwner);
        rgp.Parent := editPanel;
        rgp.Align := alTop;
        if layoutControl.required then
          begin
            if ScreenReaderActive then
              rgp.Caption := layoutControl.caption + ' (Required)'
            else rgp.Caption := layoutControl.caption + '*';
            rgp.Font.Style := rgp.Font.Style + [TFontStyle.fsBold];
          end
        else rgp.Caption := layoutControl.caption;
        rgp.OnClick := promptChange;
        rgp.OnExit := validatePrompt;
        rgp.Columns := 2;
        rgp.Top := 1;
        rgp.TabStop := true;
        editComponent := rgp;
        if (layoutControl.fenabled = false) then
          begin
            rgp.Enabled := false;
            rgp.Color := cl3DLight;
            controlEnabled := false;
          end
        else
          controlEnabled := true;
      end;
    ptCheckBox:
      begin
        chk := TCheckBox.Create(AOwner);
        chk.Parent := editPanel;
        chk.Align := alTop;
        chk.OnClick := promptChange;
        chk.OnExit := validatePrompt;
        chk.Top := 1;
        chk.TabStop := true;
        editComponent := chk;
        if (layoutControl.fenabled = false) then
          begin
            chk.Enabled := false;
            chk.Color := cl3DLight;
            controlEnabled := false;
          end
        else
          controlEnabled := true;
      end;
  end;
end;

procedure tEditObject.CreateLabel(layoutControl: TLayoutControl; AOwner,
  AParent: TWinControl);
begin
  if controlType = 'ptRadioGroup' then
    exit;
  editLabel := TStaticText.Create(AOwner);
  editLabel.Parent := editPanel;
  editLabel.Caption := layoutControl.caption;
  if layoutControl.required then editLabel.Caption := editLabel.Caption + '*';
  editLabel.Align := alTop;
  editLabel.Visible := true;
  editLabel.Top := 0;
  update508Text(layoutControl.fenabled);
//  if not layoutControl.fenabled then
//    begin
//      update508Text(false);
//      editLabel.Font.Style := editLabel.Font.Style;
//    end
//  else editLabel.Font.style := editLabel.Font.Style +  [TFontStyle.fsBold];
end;

procedure tEditObject.CreatePanel(layoutControl: TLayoutControl; AOwner,
  AParent: TWinControl);
begin
  editPanel := TPanel.Create(AOwner);
  editPanel.Parent := AParent;
  //Adjust padding for different font size
  if application.MainForm.Font.Size = 8 then
    begin
      editPanel.Padding.Top := 10;
      editPanel.Padding.Bottom := 10;
      end
  else if (application.MainForm.Font.Size = 10) or
          (application.MainForm.Font.Size = 12)  then
    begin
      editPanel.Padding.Top := 5;
      editPanel.Padding.Bottom := 5;
    end
  else if application.MainForm.Font.Size > 12 then
    begin
      editPanel.Padding.Top := 0;
      editPanel.Padding.Bottom := 0;
    end;
//  editPanel.Padding.Top := 0;
//  editPanel.Padding.Bottom := 0;
  editPanel.Padding.Left := 5;
  editPanel.Padding.Right := 5;
  editPanel.Align := alClient;
  editPanel.BevelOuter := bvNone;
  editPanel.BevelInner := bvNone;
  editPanel.BevelKind := bkNone;
  editPanel.Align := alClient;
  editPanel.ParentBackground := true;
  editPanel.ParentColor := true;
  if (not layoutControl.fenabled) and (not ScreenReaderActive) then
    begin
      editPanel.Enabled := false;
    end
  else editPanel.Enabled := true;
//  editPanel.TabStop := true;
end;

destructor tEditObject.Destroy;
begin
  FreeAndNil(dataList);
  FreeAndNil(dataDefaultList);
  inherited;
end;

procedure tEditObject.keyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if (Sender is TORComboBox) then
   begin
    if (Key = VK_BACK) and ((Sender as TORComboBox).Text = '') then (Sender as TORComboBox).ItemIndex := -1;
   end;
end;

procedure tEditObject.onNeedData(sender: TObject; const StartFrom: string;
  Direction, InsertAt: integer);
begin

end;

procedure tEditObject.populateAboveTheLine(name: string; aboveTheLineList: TStrings);
var
//items: TStringList;
i,idx,k: integer;
locText: string;
locFound: boolean;
begin
  if not (editComponent is TORComboBox) then exit;
  idx := 0;
  for i := 0 to aboveTheLineList.Count - 1 do
    begin
      LocText := Piece(aboveTheLineList[i], U, 1);
      if LocText <> '' then
        begin
          if (LocText <> '0') and (IntToStr(StrToIntDef(LocText, 0)) = LocText) then
            begin
              LocFound := FALSE;
              for k := 0 to (editComponent as TORComboBox).items.Count - 1 do
                begin
                  if Piece((editComponent as TORComboBox).Items[k], U, 1) = LocText then
                    begin
                      LocText := (editComponent as TORComboBox).Items[k];
                      LocFound := TRUE;
                      break;
                    end;
                end;
              if not LocFound then LocText := '';
            end
            else
              begin
                if StrToIntDef(Piece(LocText, U, 1), -1) = -1 then LocText := '0^' + LocText;
              end;
            if LocText <> '' then
              begin
                (editComponent as TORComboBox).items.insert(idx, LocText);
                inc(idx);
              end;
        end;
    end;
  if idx > 0 then
    begin
      (editComponent as TORComboBox).Items.insert(idx, '-1' + LLS_LINE);
      (editComponent as TORComboBox).Items.insert(idx + 1, '-1' + LLS_SPACE);
    end;
end;

procedure tEditObject.populateComponent;
var
i,fontSize,row: integer;
rgp: TRadioGroup;
begin
  if (editComponent is TMemo) and (dataDefaultList <> nil) then
    begin
      for i := 0 to dataDefaultList.Count - 1 do
          (editComponent as TMemo).Lines.Add(Piece(dataDefaultList.Strings[i], u, 1));
    end;
  if dataList = nil then exit;
  if dataList.Count = 0 then exit;
  if (editComponent is TORComboBox) then
    begin
      FastAssign(dataList, (editComponent as TORComboBox).Items);
    end;
  if (editComponent is TORListBox) then
    begin
      FastAssign(dataList, (editComponent as TORListBox).Items);
    end;
  if (editComponent is TRadioGroup) then
    begin
      rgp := (editComponent as TRadioGroup);
      for i := 0 to dataList.Count - 1 do
        rgp.Items.Add(Piece(dataList[i],u,2));
      row := rgp.Items.Count div 2;
      fontSize := TextHeightByFont(rgp.Font.Handle, rgp.Caption);
      rgp.Height := (fontSize * row) + (fontSize * 2);
    end;
  if not (editComponent is TORComboBox) then exit;
  if dataDefaultList = nil  then exit;
  if dataDefaultList.Count = 0 then exit;
  populateDefaultList;
end;

procedure tEditObject.populateDefaultList;
var
idx, j, k: integer;
locText: string;
locFound: boolean;
cbo: TORComboBox;
begin
  idx := 0;
  cbo := (editComponent as TORComboBox);
  for j := 0 to dataDefaultList.Count - 1 do
    begin
      LocText := Piece(dataDefaultList[j], U, 2);
      if LocText <> '' then
        begin
          if (LocText <> '0') and (IntToStr(StrToIntDef(LocText, 0)) = LocText) then
            begin
              LocFound := FALSE;
              for k := 0 to cbo.items.Count - 1 do
                begin
                  if Piece(cbo.Items[k], U, 2) = LocText then
                    begin
                      LocText := cbo.Items[k];
                      LocFound := TRUE;
                      break;
                    end;
                end;
              if not LocFound then LocText := '';
            end
          else
            begin
              if StrToIntDef(Piece(LocText, U, 1), -1) = -1 then LocText := '0^' + LocText;
            end;
          if LocText <> '' then
            begin
              cbo.items.insert(idx, LocText);
              inc(idx);
            end;
        end;
    end;
  if idx > 0 then
    begin
      cbo.Items.insert(idx, '-1' + LLS_LINE);
      cbo.Items.insert(idx + 1, '-1' + LLS_SPACE);
    end;
end;

procedure tEditObject.promptChange(Sender: TObject);
var
  idx: integer;
  temp: string;
  cbo: TORComboBox;
  edt: TEdit;
  dte: TORDateBox;
  dtc: TORDateCombo;
  memo: TMemo;
  rgp: TRadioGroup;
  chk: TCheckBox;
  lstBox: TORListBox;
begin
  self.intVal := '';
  self.extVal := '';
  if (Sender is TORComboBox) then
    begin
      cbo := (Sender as TORComboBox);
      if cbo.CheckBoxes then
        begin
          intVal := '';
          extVal := '';
          for idx := 0 to cbo.Items.Count - 1 do
            begin
              if cbo.Checked[idx] then
                begin
                  if intVal = '' then
                    begin
                      intVal := Piece(cbo.Items.Strings[idx], u, 1);
                      extVal := Piece(cbo.Items.Strings[idx], u, 2);
                    end
                  else
                    begin
                      intVal := intVal + ';' + Piece(cbo.Items.Strings[idx], u, 1);
                      extVal := extVal + ';' + Piece(cbo.Items.Strings[idx], u, 2);
                    end;
                end;
            end;
          exit;
        end;
      idx := cbo.ItemIndex;
      if idx = -1 then
        begin
          if controlType = 'ptCBOFreeText' then
            begin
                if cbo.Text <> '' then
                  begin
                    intVal := '';
                    extVal := cbo.Text;
                  end;
            end;
          exit;
        end;
      temp := cbo.Items.Strings[idx];
      if temp = '' then exit;
      if (Piece(temp, U, 1) = '-1') then exit;

      intVal := Piece(temp, u, 1);
      extVal := Piece(temp, u, 2);
    end
  else if (Sender is TORDateBox) then
    begin
      dte := (Sender as TORDateBox);
      if dte.FMDateTime > 0 then
        begin
          intVal := FloatToStr(dte.FMDateTime);
          extVal := intVal;
        end;
    end
    else if (Sender is TORDateCombo) then
    begin
      dtc := (Sender as TORDateCombo);
      while (dtc.FMDate > 2000000) and (dtc.FMDate > FMToday) do
        begin
          dtc.FMDate := dtc.FMDate - 10000;
          dtc.updateYear;
          dtc.Refresh;
        end;
      if dtc.FMDate > 0 then
        begin
          intVal := FloatToStr(dtc.FMDate);
          extVal := intVal;
        end;
    end
  else if (Sender is TEdit) then
    begin
      edt := (Sender as TEdit);
      intVal := edt.Text;
      extVal := edt.Text;
    end
  else if (Sender is TMemo) then
    begin
      memo := (Sender as TMemo);
      intVal := '';
      for idx := 0 to memo.Lines.Count - 1 do
        begin
          if intVal = '' then intVal := memo.Lines[idx]
          else intVal := intVal + CRLF + memo.Lines[idx];
        end;
      extVal := intVal;
    end
  else if (Sender is TCheckBox) then
    begin
      chk := (Sender as TCheckBox);
      intVal := '';
      if chk.Checked then
        begin
          intVal := '0';
          extVal := 'No';
        end
      else
        begin
          intVal := '1';
          extVal := 'Yes';
        end;
    end
  else if (Sender is TRadioGroup) then
    begin
      rgp := (Sender as TRadioGroup);
      intVal := IntToStr(rgp.ItemIndex);
      extVal := rgp.Items.Strings[rgp.ItemIndex];
    end
  else if (Sender is TORListBox) then
    begin
      intVal := '';
      extVal := '';
      lstBox := (Sender as TORListBox);
      for idx := 0 to lstBox.Count - 1 do
        begin
          if not lstBox.Selected[idx]then continue;
          intVal := Piece(lstBox.Items.Strings[idx], U, 1);
          extVal := Piece(lstBox.Items.Strings[idx], U, 2);
        end;
    end;
end;

procedure tEditObject.setCheckBoxDefault(editIntVal, editExtVal: string);
var
chk: TCheckBox;
begin
  chk  := (self.editComponent as TCheckBox);
  intVal := editIntVal;
  extVal := editExtVal;
  if intVal = '1' then chk.Checked := true
  else chk.Checked := false;
end;

procedure tEditObject.setComboBoxDefault(editIntVal, editExtVal: string);
var
cbo: TORComboBox;
i,idx: integer;
checked: boolean;
temp: string;

  procedure handleMultipleValues(lookup: string; isInt: boolean);
  var
  tmpList: TStringList;
  i,j: integer;
  find: string;
  begin
    tmpList := TStringList.Create;
    try
      PiecestoList(lookup, ';', tmpList);
      for i := 0 to tmpList.Count - 1 do
        begin
          find := tmpList.Strings[i];
          if isInt then
            begin
              for j := 0 to cbo.Items.Count - 1 do
                begin
                  if Piece(cbo.Items.Strings[j], u, 1) = find then
                    cbo.Checked[j] := true;
                end;
            end
          else
            begin
              j := cbo.Items.IndexOf(find);
              if j > -1 then cbo.Checked[j] := true;
            end;
        end;

    finally
      FreeAndNil(tmpList);
    end;

  end;
begin
  checked := false;
  cbo := (self.editComponent as TORComboBox);
  try
  if editExtVal <> '' then
    begin
      if (Pos(';', editExtVal) > 0) and (cbo.CheckBoxes) then
        handleMultipleValues(editExtVal, false)
      else
        begin
          idx := cbo.Items.IndexOf(editExtVal);
          if idx > -1 then
            begin
              if cbo.CheckBoxes then
                begin
                  cbo.Checked[idx] := true;
                  checked := true;
                end
              else cbo.ItemIndex := idx;
            end
          else if (idx = -1) and (controlType = 'ptCBOFreeText') then
            begin
              cbo.ItemIndex := -1;
              cbo.Text := editExtVal;
            end;
        end;
    end;

  if (cbo.ItemIndex > -1) or (checked) or (cbo.Text <> '') then exit;
  if editIntVal <> '' then
    begin
      if (Pos(';', editIntVal) > 0) and (cbo.CheckBoxes) then
        handleMultipleValues(editIntVal, true)
      else
        begin
          i := -1;
          for idx := 0 to cbo.Items.Count -1 do
            if Piece(cbo.Items.Strings[idx], u, 1) = editIntVal then
              begin
                i := idx;
                break;
              end;
          if i > -1 then
            begin
              if cbo.CheckBoxes then
                begin
                  cbo.Checked[i] := true;
                end
              else cbo.ItemIndex := i;
            end;
        end;
    end;
  finally
  if cbo.CheckBoxes then
    begin
      IntVal := '';
      ExtVal := '';
      for idx := 0 to cbo.Items.Count - 1 do
        begin
          if not cbo.Checked[idx] then continue;
          temp := cbo.Items.Strings[idx];
          if IntVal <> '' then IntVal := IntVal + ';' + Piece(temp, u, 1)
          else IntVal := Piece(temp, u, 1);
          if ExtVal <> '' then ExtVal := ExtVal + ';' + Piece(temp, u, 2)
          else ExtVal := Piece(temp, u, 2);
        end;
    end
  else if cbo.ItemIndex > -1 then
    begin
      temp := cbo.Items.Strings[cbo.ItemIndex];
      intVal := Piece(temp, U, 1);
      extVal := Piece(temp, u, 2);
    end
  else if (cbo.ItemIndex = -1) and (controlType = 'ptCBOFreeText') then
    begin
      intVal := '';
      extVal := cbo.Text;
    end;

  end;
end;

procedure tEditObject.setDateDefault(editIntVal, editExtVal: string);
var
dte: TORDateBox;
dtc: TORDateCombo;
isEnabled: boolean;
value: string;
begin
  if editExtVal <> '' then value := editExtVal
  else value := editIntVal;
  if (self.editComponent is TORDateBox) then
    begin
      dte := (self.editComponent as TORDateBox);
      isEnabled := dte.Enabled;
      if not dte.Enabled then dte.Enabled := true;

      dte.FMDateTime := strToFloatDef(value, 0);
//      dte.Text := editExtVal;
      intVal := FloatToStr(dte.FMDateTime);
      extVal := FloatToStr(dte.FMDateTime);
      dte.Enabled := isEnabled;
    end
  else
    begin
      dtc := (self.editComponent as TORDateCombo);
      isEnabled := dtc.Enabled;
      if not dtc.Enabled then dtc.Enabled := true;
      dtc.FMDate := strToFloatDef(value, 0);
      intVal := FloatToStr(dtc.FMDate);
      extVal := FloatToStr(dtc.FMDate);
      dtc.Enabled := isEnabled;
    end;

end;

procedure tEditObject.setDefaultValue;
begin
  if (editIntValue = '') and (editExtValue = '') then exit;
  if not setDefault then exit;
  if (editComponent is TORDateBox) then setDateDefault(editIntValue, editExtValue)
  else if (editComponent is TORDateCombo) then setDateDefault(editIntValue, editExtValue)
  else if (editComponent is TORComboBox) then setComboBoxDefault(editIntValue, editExtValue)
  else if (editComponent is TEdit) then setEditDefault(editIntValue, editExtValue)
  else if (editComponent is TStaticText) then  setLabelDefault(editIntValue, editExtValue)
  else if (editComponent is TCheckBox) then setCheckBoxDefault(editIntValue, editExtValue);

end;

procedure tEditObject.setEditDefault(editIntVal, editExtVal: string);
var
edt: TEdit;
value: string;
begin
  if editExtVal <> '' then value := editExtVal
  else value := editIntVal;
  edt := (editComponent as TEdit);
  edt.Text := value;
  intVal := edt.Text;
  extVal := edt.Text;
end;

procedure tEditObject.setLabelDefault(editIntVal, editExtVal: string);
var
lbl: TStaticText;
value: string;
begin
  if editExtVal <> '' then value := editExtVal
  else value := editIntVal;
  lbl := (editComponent as TStaticText);
  lbl.Caption := value;
  if editIntVal <> '' then intVal := editIntVal
  else intVal := lbl.Caption;
  extVal := lbl.Caption;
end;

procedure tEditObject.update508Label;
begin
  //build label text for 508
  if not ScreenReaderActive then exit;
  (GetParentForm(editComponent) as TfrmBase508Form).amgrMain.AccessText[TWinControl(editComponent)] := editLabel.Caption + ' ' + (editComponent as TStaticText).caption;
end;

procedure tEditObject.update508Text(enabled: boolean);
begin
  //build label text and enable tabstops for 508
  if (not enabled) or (not controlEnabled) then
    begin
      editLabel.Caption := caption;
      editLabel.Font.Style := [];
    end
  else
    begin
      if required then
        editLabel.Caption := caption + '*'
      else
        editLabel.Caption := caption;
      editLabel.Font.style := [TFontStyle.fsBold];
    end;
  if not ScreenReaderActive then
    exit;
  if not enabled then
    begin
      editLabel.TabStop := true;
      (GetParentForm(editLabel) as TfrmBase508Form).amgrMain.AccessText[TWinControl(editLabel)] := editLabel.Caption + ' is disable no action needed';
    end
  else
    begin
      editLabel.TabStop := false;
      (GetParentForm(editLabel) as TfrmBase508Form).amgrMain.AccessText[TWinControl(editLabel)] := editLabel.Caption;
    end;
end;

function tEditObject.validateObject: string;
begin
  if (extVal <> '') and (pos(U, extVal)>0) then
    result := '-1' + U + Caption + ' cannot contain an ^';
  if editPanel.Visible = false then result := ''
  else if (required = true) and ((self.editPanel.Enabled) and controlEnabled) then
    begin
      if ((intVal = '') or (extVal = '')) and (controlType <> 'ptCBOFreeText') then
        begin
          if (controlType = 'ptCBO') or (controlType = 'ptCBOLongList') or (controlType = 'ptCheckListBox') then
            begin
              if (self.editComponent as TORComboBox).Items.Count = 0 then
                begin
                  if controlType <> 'ptCBOLongList' then
                    result := name + U + '' + U + ''
                  else
                    result := '-1' + U + 'The value for ' + caption + ' cannot be blank. Please select a valid ' + caption + ' from the list of possible entries.';
                end
              else begin
                if (self.editComponent as TORComboBox).Text <> '' then
                  result := '-1' + U + 'The value ' + (self.editComponent as TORComboBox).Text + ' is not valid. Please select a valid ' + caption + ' from the list of possible entries.'
                  else result := '-1' + U + 'The value for ' + caption + ' cannot be blank. Please select a valid ' + caption + ' from the list of possible entries.';
              end;
            end
          else result := '-1' + U + 'The value for ' + caption + ' is not defined';
        end
      else if (controlType = 'ptDate') or (controlType = 'ptDateTime') or (controlType = 'ptDateBox') then
        begin
          if (intVal = '0') or (extVal = '0') then
            result := '-1' + U + 'The value for ' + caption + ' cannot be blank. Please select a valid ' + caption + ' from the list of possible entries.'
          else result := name + U + intVal + U + extVal;
        end
      else
        result := name + U + intVal + U + extVal;
    end
  else
    result := name + U + intVal + U + extVal;
end;

procedure tEditObject.validatePrompt(Sender: TObject);
begin
  if Pos(U, self.intVal) > 0 then
    ShowMessage(caption + ' cannot contain a ^')
  else if Pos(U, self.extVal) > 0 then
    ShowMessage(caption + ' cannot contain a ^');
end;

procedure tLayout.initilizeLookups;
var
i: integer;
layoutControl: TLayoutControl;
editObject: TEditObject;
returnList: TStrings;

begin
  for i := 0 to controls.Count - 1 do
    begin
      layoutControl := TLayoutControl(controls.Objects[i]);
      editObject := TEditObject(layoutControl.uiControl);
      if editObject.longList then
        begin

        end
      else
        begin
          returnList := TStringList.Create;
          try
            editObject.populateComponent;
            editObject.setDefaultValue;
            if (editObject.editComponent is TORComboBox) and
              (layoutControl.control = 'ptCBO') and
              ((editObject.editComponent as TORComboBox).Items.Count = 0) then
                begin
                  (editObject.editComponent as TORComboBox).Enabled := false;
                  (editObject.editComponent as TORComboBox).Color := cl3DLight;
                  editObject.editLabel.Caption := editObject.caption;
                  editObject.controlEnabled := false;
                  editObject.update508Text(layoutControl.fenabled);
                end;
            if layoutControl.fAboveTheLine then
              editObject.populateAboveTheLine(layoutControl.name, layoutControl.aboveTheLineList);
          finally
            FreeAndNil(returnList);
          end;

        end;
    end;
end;

function tLayout.validateData(compList: TStrings): boolean;
var
i: integer;
layoutControl: TLayoutControl;
editObject: tEditObject;
temp: string;
begin
  result := true;
  if (controls = nil) or (controls.Count = 0) then
    begin;
      result := false;
      exit;
    end;
  for i := 0 to controls.Count - 1 do
    begin
      layoutControl := TLayoutControl(controls.Objects[i]);
      editObject := tEditObject(layoutControl.uiControl);
      temp := editObject.validateObject;
      if Piece(temp, U, 1) = '-1' then
        begin
          compList.Clear;
          compList.Add(Piece(temp, U, 2));
          result := false;
          exit;
        end
      else if temp <> '' then compList.Add(temp);
    end;
  end;

procedure tLayout.returnAboveTheLineForType(name: string;
  dataLineList: TStrings; var returnList: TStrings);
var
i: integer;
temp: string;

begin
  for i := 0 to dataLineList.Count - 1 do
    begin
      temp := dataLineList.Strings[i];
      if Piece(temp, u, 1) <> name then
        continue
      else returnList.Add(pieces(temp,u,2,3));
    end;
end;

procedure tLayout.returnComponentDataList(name: string; dataList: TStrings);
var
i: integer;
layoutControl: TLayoutControl;
editObject: tEditObject;
begin
   i := controls.IndexOf(name);
   if i = -1 then exit;
   layoutControl := TLayoutControl(controls.Objects[i]);
   editObject := tEditObject(layoutControl.uiControl);
   if (editObject.dataList <> nil) and (editObject.dataList.Count > 0)  then
    FastAssign(editObject.dataList, dataList);
end;


{ tLayout }

procedure tLayout.buildLayout(inputList, defaultList: TStrings);
var
temp: string;
aboveTheLineList, layoutList, dataList, dataDefaultList, dataTypes, returnList : TStrings;
i: integer;
layoutControl: TLayoutControl;
aList: iORNetMult;
begin
  neworNetMult(aList);
  for i := 0 to inputList.count - 1 do
    begin
      temp := InputList.strings[i];
      if Piece(temp, U, 1) = 'TYPE' then name := Piece(temp, U, 2);
      aList.AddSubscript(['DATA', Piece(temp, u, 1) ], Piece(temp, u, 2));
    end;
//  if controls <> nil then clearLayoutControls;
//  if controls = nil then controls := TStringList.Create;
  if (layoutType = -1) then
    begin
      row := 1;
      column := 1;
      exit;
    end;
  dataList := TStringList.Create;
  dataTypes := TStringList.Create;
  returnList := TStringList.Create;
  dataDefaultList := TStringList.Create;
  layoutList := TStringList.Create;
  aboveTheLineList := TStringList.Create;
  hasNoData := false;
  try
  getLayoutLists(aList, defaultList, layoutList, dataList, dataTypes, dataDefaultList, aboveTheLineList);
  if layoutList.Count = 0 then
    begin
      hasNoData := true;
      exit;
    end;

  for i := 0 to layoutList.Count -1 do
    begin
      temp := layoutList.Strings[i];
      if Piece(temp, U, 1) = 'LAYOUT' then
        begin
          column := StrToIntDef(Piece(temp, u, 2), 0);
          row := StrToIntDef(Piece(temp, u, 3), 0);
        end
      else
        begin
           layoutControl := TLayoutControl.Create;
           layoutControl.name := Piece(temp, U, 1);
           layoutControl.caption := Piece(temp, u, 2);
           layoutControl.control := Piece(temp, u, 3);
           layoutControl.colNum := StrToIntDef(Piece(temp, u, 4), 0);
           layoutControl.rowNum := StrToIntDef(Piece(temp, u, 5), 0);
           layoutControl.ColSpan := StrToIntDef(Piece(temp, u, 6), 0);
           layoutControl.needSort := Piece(temp, u, 7) = '1';
           layoutControl.required := Piece(temp, u, 8) = '1';
           layoutControl.fAboveTheLine := Piece(temp, u, 9) = '1';
           layoutControl.fenabled := Piece(temp, u, 10) = '1';
           layoutControl.setDefault := Piece(temp, U, 11) = '1';
           layoutControl.intValue := Piece(temp, u, 12);
           layoutControl.extValue := Piece(temp, u, 13);
           if dataTypes.IndexOf(layoutControl.name) > -1 then
            begin
              returnList.Clear;
              returnDataForType(layoutControl.name, dataList, returnList);
              if returnList.Count > 0 then
                begin
//                  layoutControl.dataList := TStringList.Create;
                  FastAssign(returnList, layoutControl.dataList);
                end;
              returnList.clear;
              returnDataDefaultForType(layoutControl.name, dataDefaultList, returnList);
              if returnList.count > 0 then
                begin
//                  layoutControl.dataDefaultList := TStringList.Create;
                  FastAssign(returnList, layoutControl.dataDefaultList);
                end;
              returnList.clear;
              returnAboveTheLineForType(layoutControl.name, aboveTheLineList, returnList);
              if returnList.count > 0 then
                FastAssign(returnList, layoutControl.aboveTheLineList);
            end;
           controls.AddObject(layoutControl.name, layoutControl);
        end;

    end;
  finally
    FreeAndNil(layoutList);
    FreeAndNil(dataList);
    FreeAndNil(dataTypes);
    FreeAndNil(returnList);
    FreeAndNil(dataDefaultList);
    FreeAndNil(aboveTheLineList);
  end;
end;

procedure tLayout.clearLayoutControls;
var
i: integer;
layoutControl: TLayOutControl;
begin
  try
    if controls = nil then exit;
    for I := 0 to controls.Count - 1 do
      begin
        layoutControl := TLayoutControl(controls.Objects[i]);
        FreeAndNil(layoutControl);
      end;
    controls.Clear;
    layoutType := -1;
  finally

  end;
end;

constructor tLayout.Create;
begin
 inputList := TStringList.Create;
 fcontrols := TStringList.Create;
end;

destructor tLayout.Destroy;
var
i: integer;
begin
  for I := 0 to fControls.Count - 1 do
    Controls.Objects[i].Free;
  FreeAndNil(fcontrols);
  FreeAndNil(fInputList);
  inherited;
end;

function tLayout.getControlIndex(name: string): integer;
begin
 result := controls.IndexOf(name);
end;

function tLayout.getObject(idx: integer): TObject;
begin
  result := controls.Objects[idx];
end;

procedure tLayout.returnDataDefaultForType(name: string; dataDefaultList: TStrings;
  var returnList: TStrings);
var
i: integer;
temp: string;

begin
  for i := 0 to dataDefaultList.Count - 1 do
    begin
      temp := dataDefaultList.Strings[i];
      if Piece(temp, u, 1) <> name then
        continue
      else returnList.Add(Pieces(temp, u, 2, 20));
    end;
end;

procedure tLayout.returnDataForType(name: string; dataList: TStrings;
  var returnList: TStrings);
var
i: integer;
temp: string;

begin
  for i := 0 to dataList.Count - 1 do
    begin
      temp := dataList.Strings[i];
      if Piece(temp, u, 1) <> name then
        continue
      else returnList.Add(Pieces(temp, u, 2, 20));
    end;
end;

function tLayout.validate(list, inputList,
  resultList: TStrings): boolean;
begin
  Result := validateResults(list, inputList, resultList);
end;

{ TLayoutControl }

constructor TLayoutControl.Create;
begin
  dataList := TStringList.Create;
  dataDefaultList := TStringList.Create;
  aboveTheLineList := TStringList.Create;
end;

destructor TLayoutControl.Destroy;
begin
  FreeAndNil(uiControl);
  FreeAndNil(dataList);
  FreeAndNil(dataDefaultList);
  FreeAndNil(aboveTheLineList);
  inherited;
end;

end.
