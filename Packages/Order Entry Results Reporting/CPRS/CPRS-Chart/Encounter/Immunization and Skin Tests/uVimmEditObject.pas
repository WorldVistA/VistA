unit uVimmEditObject;

interface

uses
Vcl.Forms, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Controls, Vcl.graphics,  Vcl.Dialogs,
Vcl.CheckLst,
Winapi.Windows, Winapi.Messages,
System.Classes, System.SysUtils,
VA508AccessibilityManager, rvimm, rCore, ORCtrls, ORDtTm, ORFn, uEditObject, VAUtils;

type

vEditObject = class(tEditObject)
private
//  fOnChangeOver: TNotifyEvent;
  procedure loadUsers(control: TControl; const StartFrom: string; Direction, InsertAt: Integer; providerOnly: boolean);
protected
  procedure onNeedData(sender: TObject; const StartFrom: string; Direction, InsertAt: integer); override;
  procedure promptChange(Sender: TObject); override;
  procedure setComboBoxDefault(editIntVal, editExtVal: string); override;
public
  layout: tLayout;
  procedure populateComponent;
  procedure setDefaultValue;
  procedure populateAboveTheLine(name: string; aboveTheLineList: TStrings);
end;

procedure populateProviderLookup(editObject: vEditObject; name, IEN: string);
procedure updateSiteLookUp(data: string; routeEditObject: vEditObject; layout: tLayout);
procedure updateExpAndManuf(data: string; layout: tLayout);
procedure updateDatePrompt(data: string; layout: tLayout);
procedure updateRefusalPrompts(data: string; layout: TLayout);
procedure updateOrderingProvider(data: string; layout: TLayout);
procedure clearValues;

implementation

uses
 uSimilarNames;

 var
 oldFMDate: TFMDateTime;
 oldProvider: string;
 oldProviderIEN: string;

{ editObject }

procedure vEditObject.loadUsers(control: TControl; const StartFrom: string;
  Direction, InsertAt: Integer; providerOnly: boolean);
var
  Dest: TStrings;
  cbo: TORComboBox;

begin
  Dest := TSTringList.Create;
  try
    cbo := (control as TORComboBox);
    cbo.Pieces := '2,3';
    cbo.UniqueAutoComplete := true;
    if not providerOnly then
      setSubSetOfPersons(cbo, Dest,StartFrom, Direction)
    else
      setSubSetOfProviders(cbo, Dest,StartFrom, Direction);
    cbo.ForDataUse(Dest);
  finally
    Dest.Free;
  end;
end;

procedure vEditObject.onNeedData(sender: TObject; const StartFrom: string;
  Direction, InsertAt: integer);
var
provider: boolean;
begin
 if name = 'ORDERING PROVIDER' then provider := true
 else provider := false;
 loadUsers((editComponent as TORComboBox), startFrom, direction, insertAt, provider);
end;

procedure vEditObject.populateAboveTheLine(name: string;
  aboveTheLineList: TStrings);
begin
  inherited;
end;

procedure vEditObject.populateComponent;
var
 cbo: TORCombobox;
 i: integer;
begin
  if name = 'ADMIN ROUTE' then
    begin
      if self.dataList = nil then exit;
      if self.dataList.count = 0 then exit;
      if (editComponent is TORComboBox) then
        begin
          cbo := (editComponent as TORCombobox);
          for i := 0 to dataList.Count - 1 do
            begin
              if Piece(dataList.Strings[i], u, 1) <> 'SITE' then
                cbo.Items.Add(dataList.Strings[i]);
            end;
        end;
    end
    else
    inherited;
end;

procedure vEditObject.promptChange(Sender: TObject);
var
  idx, pIDX: integer;
  temp, ErrMsg, strValue: string;
  cbo: TORComboBox;
  SimRtn: Boolean;
  cbk: TCheckBox;
//  rtb: TRadioButton;
//  rgp: TRadioGroup;
begin
  self.intVal := '';
  self.extVal := '';
  if self.name = 'STOP' then
    begin
//      cbk := (Sender as TCheckBox);
//      if cbk.Checked then
//        begin
//          intVal := '0';
//          extVal := 'No';
//        end
//      else
//        begin
//          intVal := '1';
//          extVal := 'Yes';
//        end;
//      temp := intVal + U + extVal;
      cbo := (Sender as TORComboBox);
      idx := cbo.ItemIndex;
      if idx = -1 then exit;
      temp := cbo.Items.Strings[idx];
      if temp = '' then exit;
      intVal := Piece(temp, u, 1);
      extVal := Piece(temp, u, 2);
//      rgp := (Sender as TRadioGroup);
//      intVal := IntToStr(rgp.ItemIndex);
//      extVal := rgp.Items.Strings[rgp.ItemIndex];
//      temp := intVal + U + extVal;
      updateDatePrompt(temp, layout);
    end;
  if self.name = 'ADMIN ROUTE' then
    begin
      cbo := (Sender as TORComboBox);
      idx := cbo.ItemIndex;
      if idx = -1 then exit;
      temp := cbo.Items.Strings[idx];
      if temp = '' then exit;
      intVal := Piece(temp, u, 1);
      extVal := Piece(temp, u, 2);
      updateSiteLookUp(temp, self, layout);
      exit;
    end
  else if (self.name = 'LOT NUMBER') and ((Sender is TORComboBox)) then
    begin
      cbo := (Sender as TORComboBox);
      idx := cbo.ItemIndex;
      if idx = -1 then exit;
      temp := cbo.Items.Strings[idx];
      if temp = '' then exit;
      intVal := Piece(temp, u, 1);
      extVal := Piece(temp, u, 2);
      updateExpAndManuf(temp, layout);
      exit;
    end
  else if ((self.name = 'REFUSAL') or (self.name = 'CONTRAINDICATED')) and (Sender is TORComboBox)  then
    begin
      cbo := (Sender as TORComboBox);
      idx := cbo.ItemIndex;
      if idx = -1 then exit;
      temp := cbo.Items.Strings[idx];
      intVal := Piece(temp, u, 1);
      extVal := Piece(temp, u, 2);
      if self.name = 'REFUSAL' then pIDX := 5
      else if self.name = 'CONTRAINDICATED' then pIDX := 8
      else pIDX := 0;
      if pIDX = 0 then exit;
      strValue := Piece(temp, U, piDX);
      updateRefusalPrompts(strValue, layout);
      exit;
    end
  else if (self.name = 'ORDERED BY POLICY') and (Sender is TCHeckBox) then
    begin
      cbk := (Sender as TCheckBox);
      if not cbk.Checked then
        begin
          intVal := '0';
          extVal := 'No';
        end
      else
        begin
          intVal := '1';
          extVal := 'Yes';
        end;
      temp := intVal + U + extVal;
      updateOrderingProvider(temp, layout);
    end
  else if (Sender is TORComboBox) and (self.controlType = 'ptCBOLongList') then
    begin
      cbo := (Sender as TORComboBox);
      SimRtn :=  CheckForSimilarName(cbo, ErrMsg, sPr);
      if not SimRtn then
      begin
        ShowMsgOn(ErrMsg <> '', ErrMsg, 'Provider Selection');
        exit;
      end
      else
        begin
          idx := cbo.ItemIndex;
          if idx = -1 then exit;
          temp := cbo.Items.Strings[idx];
          if temp = '' then exit;
          intVal := Piece(temp, u, 1);
          extVal := Piece(temp, u, 2);
        end;
    end
  else inherited;
end;

procedure vEditObject.setComboBoxDefault(editIntVal, editExtVal: string);
var
i, idx: integer;
cbo: TORComboBox;
begin
  if (name = 'STOP') and (editIntVal <> '') then
    begin
      cbo := (self.editComponent as TORComboBox);
      i := -1;
      for idx := 0 to cbo.Items.Count -1 do
        begin
          if Piece(cbo.Items.Strings[idx], u, 1) = editIntVal then
            begin
              i := idx;
              break;
            end;
        end;
      if i > -1 then cbo.itemindex := i;
//      if cbo.ItemIndex = -1 then exit;
//      if editIntVal = '1' then cbo.Enabled := false
//      else cbo.Enabled := true;
    end;
  inherited;

end;

procedure vEditObject.setDefaultValue;
begin
 inherited;
 oldFMDate := 0;
 if (self.name = 'LOT NUMBER') and (self.controlType = 'ptCBO') and
    (self.dataList.Count = 1) then
      updateExpAndManuf(dataList.Strings[0], layout);
 if (self.name = 'SERIES') and (self.controlType = 'ptCBO') and
    (uVimmInputs.defaultSeries <> '')
      then
        begin
          setComboBoxDefault(uVimmInputs.defaultSeries, '');
        end;

end;

procedure populateProviderLookup(editObject: vEditObject; name, IEN: string);
var
  i, idx: integer;
  cbo: TORComboBox;
  IEN64: Int64;
  DoLookup: boolean;

begin
  if not editObject.setDefault then exit;
  cbo := (editObject.editComponent as TORComboBox);
  cbo.InitLongList(name);
  IEN64 := StrToInt64Def(IEN, 0);
  DoLookup := True;
  if IEN64 <> 0 then
  begin
    cbo.SelectByIEN(IEN64);
    if cbo.ItemIndex < 0 then
      cbo.SetExactByIEN(IEN64, name);
    if cbo.ItemIndex > -1 then
      DoLookup := False;
  end;

  if DoLookup then
  begin
    idx := -1;
    for i := 0 to cbo.Items.Count - 1 do
      begin
        if sameText(Piece(cbo.Items.Strings[i], U, 2), name)  then
          begin
            idx := i;
            break;
          end;
      end;

  //  idx := (editObject.editComponent as TORComboBox).Items.IndexOf(name);
    if idx > -1 then
      begin
        cbo.ItemIndex := idx;
      end;
  end;
  TSimilarNames.RegORComboBox(cbo);

  idx := cbo.ItemIndex;
  if idx > -1 then
  begin
    editObject.intVal := Piece(cbo.Items.Strings[idx],u,1);
    editObject.extVal := Piece(cbo.Items.Strings[idx],u,2);
  end;
end;

procedure updateSiteLookUp(data: string; routeEditObject: vEditObject; layout: tLayout);
var
idx, i, k, siteIdx: integer;
locText: string;
items: TStrings;
siteNone, locFound: boolean;
layoutControl: tLayoutControl;
editObject: vEditObject;
cboSite: TORCombobox;
begin
  idx := routeEditObject.dataList.IndexOf(data);
  if idx = -1 then exit;
  siteIdx := Layout.controls.IndexOf('ADMIN SITE');
  layoutControl := tLayoutControl(Layout.controls.Objects[siteIdx]);
  editObject := vEditObject(layoutControl.uiControl);
  cboSite := (editObject.editComponent as TORCombobox);
  siteNone := false;
    if cboSite.Items.Count > 0 then
      begin
        cboSite.ItemIndex := -1;
        cboSite.Text := '';
        cboSite.Items.Clear;
      end;
  items := TStringList.Create;
  try
  inc(idx);
  for i := idx to routeEditObject.dataList.Count -1 do
    begin
      if (Piece(routeEditObject.dataList.Strings[i], u, 1) <> 'SITE') then break;
      if (Piece(routeEditObject.dataList.Strings[i], u, 2) = 'ALL') then continue;
//      if Piece(routeEditObject.dataList.Strings[i], u, 2) = 'ALL' then exit;
      if Piece(routeEditObject.dataList.Strings[i], u, 2) = 'NONE' then
        begin
          siteNone := true;
          break;
        end;
      items.Add(Piece(routeEditObject.dataList.Strings[i], u, 2));
    end;
    if siteNone then
      begin
        cboSite.Enabled := false;
        cboSite.Color := cl3DLight;
        editObject.controlEnabled := false;
        editObject.update508Text(false);
      end
    else
      begin
        cboSite.Enabled := true;
        cboSite.Color := clWindow;
        editObject.controlEnabled := true;
        FastAssign(editObject.dataList, cboSite.items);
        idx := 0;
        for i := 0 to items.Count - 1 do
        begin
          LocText := Piece(items[i], U, 1);
          if LocText <> '' then
            begin
              if (LocText <> '0') and (IntToStr(StrToIntDef(LocText, 0)) = LocText) then
                begin
                  LocFound := FALSE;
                  for k := 0 to cboSite.items.Count - 1 do
                    begin
                      if Piece(cboSite.Items[k], U, 1) = LocText then
                        begin
                          LocText := cboSite.Items[k];
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
                  cboSite.items.insert(idx, LocText);
                  inc(idx);
                end;
            end;
        end;
        if idx > 0 then
          begin
            cboSite.Items.insert(idx, '-1' + LLS_LINE);
            cboSite.Items.insert(idx + 1, '-1' + LLS_SPACE);
          end;
        editObject.update508Text(true);
      end;

  finally
    FreeAndNil(items);
  end;

end;

procedure updateDatePrompt(data: string; layout: tLayout);
var
idx: integer;
layoutControl: tLayoutControl;
editObject: vEditObject;
begin
  idx := Layout.controls.IndexOf('WARN UNTIL DATE');
  if idx > -1 then
  begin
    layoutControl := tLayoutControl(Layout.controls.Objects[idx]);
    editObject := vEditObject(layoutControl.uiControl);
    if Piece(data,u,1) = '1' then
      begin
//        oldFMDate
        if (editObject.editComponent as TORDateBox).FMDateTime > 0 then
          begin
            oldFMDate := (editObject.editComponent as TORDateBox).FMDateTime;
            (editObject.editComponent as TORDateBox).FMDateTime := 0;
            (editObject.editComponent as TORDateBox).Text := '';

          end;
//            orCBO.Enabled := false;
//            orCBO.Color := cl3DLight;
        editObject.editPanel.Enabled := false;
        editObject.controlEnabled := false;
        (editObject.editComponent as TORDateBox).Enabled := false;
        (editObject.editComponent as TORDateBox).Color := cl3DLight;
//        editObject.editPanel.Enabled := true;
        editObject.update508Text(false);
        editObject.intVal := '';
        editObject.extVal := '';
//        editObject.editPanel.Refresh;
      end
    else
      begin
        (editObject.editComponent as TORDateBox).Enabled := true;
        (editObject.editComponent as TORDateBox).Color := clWindow;
        if oldFMDate > 0 then
          (editObject.editComponent as TORDateBox).FMDateTime := oldFMDate;
        editObject.controlEnabled := true;
        editObject.editPanel.Enabled := true;
        editObject.update508Text(true);
        editObject.intVal := FloatToStr((editObject.editComponent as TORDateBox).FMDateTime);
        editObject.extVal := FloatToStr((editObject.editComponent as TORDateBox).FMDateTime);
      end;
  end;
end;

procedure updateOrderingProvider(data: string; layout: TLayout);
var
idx, index: integer;
layoutControl: tLayoutControl;
editObject: vEditObject;
begin
  idx := Layout.controls.IndexOf('ORDERING PROVIDER');
  if idx > -1 then
  begin
    layoutControl := tLayoutControl(Layout.controls.Objects[idx]);
    editObject := vEditObject(layoutControl.uiControl);
    if Piece(data, U, 1) = '1' then
      begin
        if (editObject.editComponent as TORComboBox).ItemIndex > -1 then
          begin
            index := (editObject.editComponent as TORComboBox).ItemIndex;
            oldProvider := Piece((editObject.editComponent as TORComboBox).Items.Strings[index], U, 2);
            oldProviderIEN := Piece((editObject.editComponent as TORComboBox).Items.Strings[index], U, 1);
            (editObject.editComponent as TORComboBox).Text := '';
            (editObject.editComponent as TORComboBox).ItemIndex := -1;
          end;
        (editObject.editComponent as TORComboBox).Clear;
        editObject.update508Text(false);
        editObject.editPanel.Enabled := false;
        editObject.controlEnabled := false;
        (editObject.editComponent as TORComboBox).Enabled := false;
        (editObject.editComponent as TORComboBox).Color := cl3DLight;
      end
    else
      begin
        editObject.controlEnabled := true;
        editObject.editPanel.Enabled := true;
        (editObject.editComponent as TORComboBox).Enabled := true;
        (editObject.editComponent as TORComboBox).Color := clWindow;
        editObject.update508Text(true);
        editObject.setDefault := true;
        if oldProvider <> '' then
          populateProviderLookup(editObject, oldProvider, oldProviderIEN)
        else
          populateProviderLookup(editObject, ' ', '');
        if (editObject.editComponent as TORComboBox).ItemIndex > -1 then
          begin
            index := (editObject.editComponent as TORComboBox).ItemIndex;
            editObject.intVal := Piece((editObject.editComponent as TORComboBox).Items.Strings[index], U, 1);
            editObject.extVal := Piece((editObject.editComponent as TORComboBox).Items.Strings[index], U, 2);
          end;
        oldProvider := '';
        oldProviderIEN := '';
      end;
  end;
end;

procedure clearValues;
begin
  oldFMDate := 0;
  oldProvider := '';
  oldProviderIEN := '';
end;

procedure updateRefusalPrompts(data: string; layout: TLayout);
var
id: string;
idx: integer;
layoutControl: tLayoutControl;
editObject: vEditObject;
begin
  if Data = 'FOREVER' then
    id := '1'
  else begin
    id := '0';
    oldFMDate := StrToFloatDef(Data, -1);
  end;
  idx := Layout.controls.IndexOf('STOP');
  if idx > -1 then
  begin
    layoutControl := tLayoutControl(Layout.controls.Objects[idx]);
    editObject := vEditObject(layoutControl.uiControl);
    editObject.setComboBoxDefault(id, '');
    (editObject.editComponent as TORComboBox).OnChange((editObject.editComponent as TORComboBox));
    if id = '1' then
    begin
      (editObject.editComponent as TORComboBox).Enabled := true;
      (editObject.editComponent as TORComboBox).Color := clWindow;
    end
    else
    begin
      (editObject.editComponent as TORComboBox).Enabled := false;
      (editObject.editComponent as TORComboBox).Color := cl3DLight;
    end;
  end;
end;

procedure updateExpAndManuf(data: string; layout: tLayout);
var
idx: integer;
layoutControl: tLayoutControl;
editObject: vEditObject;
dataLbl: TStaticText;
begin
  idx := Layout.controls.IndexOf('EXPIRATION DATE');
  if idx > -1 then
  begin
    layoutControl := tLayoutControl(Layout.controls.Objects[idx]);
    editObject := vEditObject(layoutControl.uiControl);
    dataLbl := (editObject.editComponent as TStaticText);
    dataLbl.caption := Piece(data, U, 4);
    editObject.intVal := dataLbl.Caption;
    editObject.extVal := dataLbl.Caption;
    if ScreenReaderActive then editObject.update508Label;
  end;
  idx := Layout.controls.IndexOf('MANUFACTURER');
  if idx > -1 then
  begin
    layoutControl := tLayoutControl(Layout.controls.Objects[idx]);
    editObject := vEditObject(layoutControl.uiControl);
    dataLbl := (editObject.editComponent as TStaticText);
    dataLbl.caption := Piece(data, U, 3);
    editObject.intVal := dataLbl.Caption;
    editObject.extVal := dataLbl.Caption;
    if ScreenReaderActive then editObject.update508Label;
  end;
end;


initialization
oldFMDate := 0;
oldProvider := '';
oldProviderIEN := '';

finalization
oldFMDate := 0;
oldProvider := '';
oldProviderIEN := '';

end.
