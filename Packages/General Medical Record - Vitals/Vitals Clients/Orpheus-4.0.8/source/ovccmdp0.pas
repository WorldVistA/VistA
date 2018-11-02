{*********************************************************}
{*                  OVCCMDP0.PAS 4.06                    *}
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

unit ovccmdp0;
  {-Property editor for the command processor}

interface

uses
  Windows, Buttons, Classes, Controls, Dialogs, Forms, DesignIntf, DesignEditors,
  Graphics, Menus, Messages, StdCtrls, SysUtils, Tabs, OvcData, OvcCmd, OvcMisc,
  OvcCmdP1, OvcExcpt, OvcConst, ExtCtrls;

type
  TOvcHotEdit = class(TEdit)
  protected
    procedure CMDialogChar(var Msg : TCMDialogChar);
      message CM_DIALOGCHAR;
    procedure WMGetDlgCode(var Msg: TWMGetDlgCode);
      message WM_GETDLGCODE;
    procedure WMKeyDown(var Msg : TWMKeyDown);
      message WM_KEYDOWN;
    procedure WMSysKeyDown(var Msg : TWMSysKeyDown);
      message WM_SYSKEYDOWN;
    procedure WMChar(var Msg : TWMChar);
      message WM_CHAR;
  end;

type
  TOvcfrmCmdTable = class(TForm)
    tabTable       : TTabSet;
    lbKeys         : TListBox;
    lbCommands     : TListBox;
    dlgSaveDialog  : TSaveDialog;
    dlgOpenDialog  : TOpenDialog;
    btnAssign      : TBitBtn;
    btnClear       : TBitBtn;
    btnClose       : TBitBtn;
    btnNewCmd      : TBitBtn;
    mnuCmdMenu     : TMainMenu;
    miNew          : TMenuItem;
    miDelete       : TMenuItem;
    miDuplicate    : TMenuItem;
    miLoad         : TMenuItem;
    miSave         : TMenuItem;
    miOrder        : TMenuItem;
    miRename       : TMenuItem;
    edFirst        : TEdit;
    edSecond       : TEdit;
    ckActive       : TCheckBox;
    ckWordstar     : TCheckBox;
    lblWordStar    : TLabel;

    procedure FillTabList;
    procedure CreateEditFields;
    procedure FormActivate(Sender: TObject);
    procedure SetCommandHighlght(Cmd : Integer);
    procedure FillListBoxes(TableIndex : Integer);
    procedure lbKeysClick(Sender: TObject);
    procedure TableTabChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure btnCloseClick(Sender: TObject);
    procedure miLoadClick(Sender: TObject);
    procedure miSaveClick(Sender: TObject);
    procedure miDeleteClick(Sender: TObject);
    procedure miRenameClick(Sender: TObject);
    procedure ckActiveClick(Sender: TObject);
    procedure ckWordstarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    function GetKeys : TOvcCmdRec;
    procedure AssignKeysToCommand(const CR : TOvcCmdRec);
    procedure btnUserCmdClick(Sender: TObject);
    procedure btnAssignClick(Sender: TObject);
    procedure miNewClick(Sender: TObject);
    procedure miDuplicateClick(Sender: TObject);
    procedure miOrderClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure EditEnter(Sender: TObject);
    procedure EditChange(Sender: TObject);

  protected
    { Private declarations }
    CurrentTable   : Integer;  {the displayed table index}
    EditsCreated   : Boolean;
    HotEdit1       : TOvcHotEdit;
    HotEdit2       : TOvcHotEdit;
    UserNext       : Integer;

  public
    { Public declarations }
    CP             : TOvcCommandProcessor;
  end;

type
  {property editor for the command processor}
  TOvcCommandProcessorProperty = class(TClassProperty)
  public
    procedure Edit;
      override;
    function GetAttributes : TPropertyAttributes;
      override;
  end;

type
  {component editor for the controller}
  TOvcControllerEditor = class(TComponentEditor)
  public
    procedure ExecuteVerb(Index : Integer);
      override;
    function GetVerb(Index : Integer): String;
      override;
    function GetVerbCount : Integer;
      override;
  end;


implementation

{$R *.dfm}


uses
  OvcBase, OVCStr;

const
  cbStates : array[Boolean] of TCheckBoxState = (cbUnChecked, cbChecked);


{*** General ***}

function MakeUserCmdStr(Num : Integer) : string;
begin
  Result := Format(GetOrphStr(SCccUserNum), [Num]);
end;

function KeyToText(Key, SFlags : Byte): string;

  function GetShortCut(Key : Byte; Shift : Byte) : TShortCut;
  begin
    Result := Key;
    if (SFlags and ss_Shift) <> 0 then Inc(Result, scShift);
    if (SFlags and ss_Ctrl) <> 0 then Inc(Result, scCtrl);
    if (SFlags and ss_Alt) <> 0 then Inc(Result, scAlt);
  end;

begin
  Result := ShortCutToText(GetShortCut(Key, SFlags));
end;

function CmdRecToText(CR : TOvcCmdRec): string;
begin
  with CR do begin
    Result := KeyToText(Key1, SS1);
    if Key2 > 0 then
      Result := Result + ' - ' + KeyToText(Key2, SS2);
  end;
end;

procedure TextToKey(const S : string; var Key, SFlags : Byte);
var
  K1 : TShortCut;
begin
  K1 := TextToShortCut(S);
  Key := Lo(K1);
  SFlags := 0;
  if (K1 and scShift <> 0) then SFlags := SFlags or ss_Shift;
  if (K1 and scCtrl <> 0) then SFlags := SFlags or ss_Ctrl;
  if (K1 and scAlt <> 0) then SFlags := SFlags or ss_Alt;
end;


{*** TOvcHotEdit ***}

procedure TOvcHotEdit.CMDialogChar(var Msg : TCMDialogChar);
begin
  {don't call the inherited method if we have the focus}
  if GetFocus = Handle then
    Msg.Result := 1
  else
    inherited;
end;

procedure TOvcHotEdit.WMGetDlgCode(var Msg: TWMGetDlgCode);
begin
  inherited;
  Msg.Result := Msg.Result or DLGC_WANTALLKEYS;
end;

procedure TOvcHotEdit.WMKeyDown(var Msg : TWMKeyDown);
begin
  if (Msg.CharCode in [VK_ESCAPE, VK_RETURN]) and (GetShiftFlags = 0) then
    Text := GetOrphStr(SCNoneStr)
  else
    Text := KeyToText(Lo(Msg.CharCode), GetShiftFlags);
  Msg.Result := 0;
end;

procedure TOvcHotEdit.WMSysKeyDown(var Msg : TWMSysKeyDown);
begin
  Text := KeyToText(Lo(Msg.CharCode), GetShiftFlags);
  Msg.Result := 0;
end;

procedure TOvcHotEdit.WMChar(var Msg : TWMChar);
begin
  Msg.Result := 0;
end;


{*** TCmdTable ***}

procedure TOvcfrmCmdTable.FillListBoxes(TableIndex : Integer);
  {-fill the key and command list boxes}
var
  I            : Integer;
  S            : string;
  CommandCount : Integer;
  CR           : TOvcCmdRec;
begin
  {fill the command list with command names}
  lbCommands.Clear;
  for I := ccFirstCmd To ccLastCmd do
    lbCommands.Items.Add(GetOrphStr(CommandResOfs+I));

  {fill the key list with the new key entries}
  lbKeys.Clear;
  CommandCount := CP.Table[TableIndex].Count;
  for I := 0 to CommandCount - 1 do begin

    {get the command key record}
    CR := CP.Table[TableIndex].Commands[I];

    {convert to text}
    S := CmdRecToText(CR);

    {add to keys list}
    lbKeys.Items.Add(S);

    {add user command to the command list as ccUserXXX}
    if CR.Cmd >= ccUserFirst then begin
      {don't add if its already in the list}
      S := MakeUserCmdStr(CR.Cmd - ccUserFirst);
      if lbCommands.Items.IndexOf(S) = -1 then
        lbCommands.Items.Add(S);
    end;
  end;

  {set table active check box}
  ckActive.State := cbStates[CP.Table[TableIndex].IsActive];

  {clear key edit fields}
  HotEdit1.Text := GetOrphStr(SCNoneStr);
  HotEdit2.Text := GetOrphStr(SCNoneStr);
end;

procedure TOvcfrmCmdTable.FillTabList;
var
  I            : Integer;
  TableCount   : Integer;    {count of tables installed}
begin
  tabTable.Tabs.Clear;
  TableCount := CP.Count;
  CurrentTable := -1;
  if TableCount > 0 then begin
    {add a tab for each table}
    for I := 0 to TableCount - 1 do
      tabTable.Tabs.Add(CP.Table[I].TableName);

    {make the initial tab active}
    tabTable.TabIndex := 0;

    {setting TabIndex will also update the list boxes and CurrentTable}
  end;
end;

procedure TOvcfrmCmdTable.CreateEditFields;
begin
  {create TOvcHotEdit controls in the same place as the invisible TEdits}
  HotEdit1 := TOvcHotEdit.Create(Self);
  with HotEdit1 do begin
    Left := edFirst.Left;
    Top := edFirst.Top;
    Font := edFirst.Font;
    Width := edFirst.Width;
    Height := edFirst.Height;
    MaxLength := edFirst.MaxLength;
    Text := GetOrphStr(SCNoneStr);
    OnChange := edFirst.OnChange;
    OnEnter := edFirst.OnEnter;
    Hint := edFirst.Hint;
    Parent := edFirst.Parent;
  end;

  HotEdit2 := TOvcHotEdit.Create(Self);
  with HotEdit2 do begin
    Left := edSecond.Left;
    Top := edSecond.Top;
    Font := edSecond.Font;
    Width := edSecond.Width;
    Height := edSecond.Height;
    MaxLength := edSecond.MaxLength;
    Text := GetOrphStr(SCNoneStr);
    OnChange := edSecond.OnChange;
    OnEnter := edSecond.OnEnter;
    Hint := edSecond.Hint;
    Parent := edSecond.Parent;
  end;
  {set flag so the edit fields don't get created again}
  EditsCreated := True;
end;

procedure TOvcfrmCmdTable.FormActivate(Sender: TObject);
begin
  {do this only for the first activation}
  if not EditsCreated then begin
    FillTabList;
    CreateEditFields;
  end
end;

procedure TOvcfrmCmdTable.SetCommandHighlght(Cmd : Integer);
var
  I : Integer;
  S : string;
begin
  {highlight the command in the command list}
  if Cmd < ccUserFirst then
    lbCommands.ItemIndex := Cmd
  else begin
    S := MakeUserCmdStr(Cmd - ccUserFirst);
    I := lbCommands.Items.IndexOf(S);

    {if not found, this (-1) will clear the highlight}
    lbCommands.ItemIndex := I;
  end;
end;

procedure TOvcfrmCmdTable.lbKeysClick(Sender: TObject);
var
  I  : Integer;
  CR : TOvcCmdRec;
begin
  I := lbKeys.ItemIndex;
  CR := CP.Table[CurrentTable].Commands[I];
  with CR do begin
    {show the key mappings}
    HotEdit1.Text := KeyToText(Key1, SS1);
    if HotEdit1.Text = '' then
      HotEdit1.Text := GetOrphStr(SCNoneStr);
    HotEdit2.Text := KeyToText(Key2, SS2);
    if HotEdit2.Text = '' then
      HotEdit2.Text := GetOrphStr(SCNoneStr);
    {update the wordstar checkbox}
    ckWordstar.State :=  cbStates[CR.SS2 and ss_WordStar <> 0];
  end;

  {highlight the command in the command list}
  SetCommandHighlght(CR.Cmd);
end;

procedure TOvcfrmCmdTable.TableTabChange(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
begin
  {exit if no tab change}
  if NewTab = CurrentTable then
    Exit;

  {save new tab index}
  CurrentTable := NewTab;

  {update the lists}
  FillListBoxes(CurrentTable);
end;

procedure TOvcfrmCmdTable.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TOvcfrmCmdTable.miLoadClick(Sender: TObject);
var
  I     : Integer;
begin
  if dlgOpenDialog.Execute then begin
    {create and load the new table}
    I := CP.LoadCommandTable(dlgOpenDialog.FileName);
    if I > -1 then begin
      {add new tab}
      tabTable.Tabs.Add(CP.Table[I].TableName);

      {make this table current}
      tabTable.TabIndex := I;
      {setting TabIndex will also update the list boxes and CurrentTable}
    end;
  end;
end;

procedure TOvcfrmCmdTable.miSaveClick(Sender: TObject);
begin
  if dlgSaveDialog.Execute then
    CP.SaveCommandTable(CP.Table[CurrentTable].TableName, dlgSaveDialog.FileName);
end;

procedure TOvcfrmCmdTable.miDeleteClick(Sender: TObject);
var
  S : string;
begin
  if CP.Count > 1 then begin
    S := CP.Table[CurrentTable].TableName;
    if MessageDlg(Format(GetOrphStr(SCDeleteTable), [S]),
        mtConfirmation, mbOkCancel, 0) = mrOk then begin
      {delete table}
      CP.DeleteCommandTable(S);

      {reset tabs}
      FillTabList;
    end;
  end else
    raise EOvcException.Create(GetOrphStr(SCCantDelete));
end;

procedure TOvcfrmCmdTable.miRenameClick(Sender: TObject);
var
  S       : string;
  NewName : string;
begin
  S := CP.Table[CurrentTable].TableName;
  NewName := InputBox(GetOrphStr(SCRenameTable),
             Format(GetOrphStr(SCEnterTableName), [S]), S);
  if NewName <> S then begin
    CP.ChangeTableName(S, NewName);
    FillTabList;
  end;
end;

procedure TOvcfrmCmdTable.ckActiveClick(Sender: TObject);
begin
  CP.Table[CurrentTable].IsActive := ckActive.State = cbChecked;
end;

procedure TOvcfrmCmdTable.ckWordstarClick(Sender: TObject);
var
  K1, K2 : TShortCut;
begin
  {don't do anything if we are clearing the flag}
  if ckWordStar.State = cbUnChecked then
    Exit;

  K1 := TextToShortCut(HotEdit1.Text);
  K2 := TextToShortCut(HotEdit2.Text);

  {first key is Ctrl+SomeKey and second key is SomeKey or Ctrl+SomeKey}
  if (Lo(K1) > 0) and (Lo(K2) > 0) and (Hi(K1) = Hi(scCtrl))then
    HotEdit2.Text := ShortCutToText(Lo(K2))
  else begin
    ckWordStar.State := cbUnChecked;

    {if the check box was physically clicked}
    if GetFocus = ckWordstar.Handle then
      raise EOvcException.Create(GetOrphStr(SCNotWordStarCommands));
  end;
end;

procedure TOvcfrmCmdTable.FormCreate(Sender: TObject);
begin
  Top := (Screen.Height - Height) div 3;
  Left := (Screen.Width - Width) div 2;

  EditsCreated := False;
end;

function TOvcfrmCmdTable.GetKeys : TOvcCmdRec;
begin
  TextToKey(HotEdit1.Text, Result.Key1, Result.SS1);
  TextToKey(HotEdit2.Text, Result.Key2, Result.SS2);
  Result.Cmd := 0;
end;

procedure TOvcfrmCmdTable.AssignKeysToCommand(const CR : TOvcCmdRec);
var
  S : string;
begin
  {don't allow duplicate key mappings}
  if CP.Table[CurrentTable].IndexOf(CR) = -1 then begin
    {add command to the command table}
    CP.Table[CurrentTable].AddRec(CR);

    {add command to command list if not already there}
    if CR.Cmd >= ccUserFirst then begin
      {don't add if its already in the list}
      S := MakeUserCmdStr(CR.Cmd - ccUserFirst);
      if lbCommands.Items.IndexOf(S) = -1 then
        lbCommands.Items.Add(S);
    end;

    {get text for command keys}
    S := CmdRecToText(CR);

    {add key assignment to key list and select it}
    lbKeys.Items.Add(S);
    lbKeys.ItemIndex := lbKeys.Items.IndexOf(S);

    {select the command in the command list}
    SetCommandHighlght(CR.Cmd);
  end else
    raise EOvcException.Create(GetOrphStr(SCDuplicateKeySequence));
end;

procedure TOvcfrmCmdTable.btnUserCmdClick(Sender: TObject);
var
  I   : Integer;
  Idx : Integer;
  S   : string;
  CR  : TOvcCmdRec;
begin
  {check edit field for a key sequence else raise error}
  CR := GetKeys;
  if CR.Key1 > 0 then begin
    {generate next available user number}
    I := -1;
    repeat
      Inc(I);
      S := MakeUserCmdStr(I);
      Idx := lbCommands.Items.IndexOf(S);
    until Idx < 0;

    {fill command record}
    CR.Cmd := ccUserFirst + I;

    {assign this command to the key(s) entered in the edit controls}
    AssignKeysToCommand(CR);
  end else
    raise EOvcException.Create(GetOrphStr(SCInvalidKeySequence));
end;

procedure TOvcfrmCmdTable.btnAssignClick(Sender: TObject);
var
  I    : Integer;
  Code : Integer;
  CR   : TOvcCmdRec;
  S    : string;
begin
  {get key sequence}
  CR := GetKeys;
  if CR.Key1 > 0 then begin
    {combine with command into command rec}
    I := lbCommands.ItemIndex;
    if I > -1 then begin
      CR.Cmd := I;
      {see if this is a user command}
      S := lbCommands.Items[CR.Cmd];
      if System.Copy(S, 1, 6) = GetOrphStr(SCccUser) then begin
        {get the user number from the string}
        while (Length(S) > 0) and (not CharInSet(S[1], ['0'..'9'])) do
          System.Delete(S, 1, 1);

        {assign user number to the command code}
        Val(S, CR.Cmd, Code);
        if Code <> 0 then
          raise EOvcException.Create(GetOrphStr(SCInvalidKeySequence));
        CR.Cmd := CR.Cmd + ccUserFirst;
      end;
      AssignKeysToCommand(CR);
    end else
      raise EOvcException.Create(GetOrphStr(SCNoCommandSelected));
  end else
    raise EOvcException.Create(GetOrphStr(SCInvalidKeySequence));
end;

procedure TOvcfrmCmdTable.miNewClick(Sender: TObject);
var
  NewIdx  : Integer;
begin
  NewIdx := CP.CreateCommandTable(GetOrphStr(SCNewTAble), True);
  if NewIdx > -1 then begin
    {add new tab}
    tabTable.Tabs.Add(CP.Table[NewIdx].TableName);

    {make this table current}
    tabTable.TabIndex := NewIdx;
    {setting TabIndex will also update the list boxes and CurrentTable}
  end else
    raise EOvcException.Create(GetOrphStr(SCCantCreateCommandTable));
end;

procedure TOvcfrmCmdTable.miDuplicateClick(Sender: TObject);
var
  I       : Integer;
  NewIdx  : Integer;
  CR      : TOvcCmdRec;
begin
  {create a new command table and add it to the table list}
  {uses the same table name but with a number suffix}
  NewIdx := CP.CreateCommandTable(CP.Table[CurrentTable].TableName, True);
  if NewIdx > -1 then begin
    {add entries from current table into new table}
    for I := 0 to CP.Table[CurrentTable].Count - 1 do begin
      CR := CP.Table[CurrentTable].Commands[I];
      CP.Table[NewIdx].AddRec(CR);
    end;

    {add new tab}
    tabTable.Tabs.Add(CP.Table[NewIdx].TableName);

    {make this table current}
    tabTable.TabIndex := NewIdx;
    {setting TabIndex will also update the list boxes and CurrentTable}
  end else
    raise EOvcException.Create(GetOrphStr(SCCantCreateCommandTable));
end;

procedure TOvcfrmCmdTable.miOrderClick(Sender: TObject);
var
  I, J : Integer;
  SO   : TOvcfrmScanOrder;
begin
  SO := TOvcfrmScanOrder.Create(Application);
  try
    {fill the list box with the table names}
    for I := 0 to CP.Count - 1 do
      SO.lbCommands.Items.Add(CP.Table[I].TableName);
    {show list of tables in a list box}
    {alow reordering by moving selected entry up/down}
    if SO.ShowModal = mrOk then begin
      {make changes in the table list}
      for I := 0 to CP.Count - 1 do
        if CP.Table[I].TableName <> SO.lbCommands.Items[I] then begin
          {find the table index to match the name in the list box}
          for J := I + 1 to CP.Count - 1 do
            if CP.Table[J].TableName = SO.lbCommands.Items[I] then begin
              {swap the two tables}
              CP.Exchange(I, J);
              Break;
            end;
        end;

      {update tabs}
      FillTabList;
    end;
  finally
    SO.Free;
  end;
end;

procedure TOvcfrmCmdTable.btnClearClick(Sender: TObject);
var
  I  : Integer;
  CR : TOvcCmdRec;
begin
  {get current keys from key edit fields}
  CR := GetKeys;

  {set flag if this is a wordstar command}
  if ckWordStar.Checked then
    CR.SS2 := ss_WordStar;

  {find keys in command table}
  I := CP.Table[CurrentTable].IndexOf(CR);

  if I > -1 then begin
    {delete entry from command table}
    CP.Table[CurrentTable].Delete(I);

    {delete key entry fron key list}
    I := lbKeys.Items.IndexOf(CmdRecToText(CR));
    if I > -1 then begin
      lbKeys.Items.Delete(I);
      ckWordStar.Checked := False;
    end;
  end;
end;

procedure TOvcfrmCmdTable.EditEnter(Sender: TObject);
begin
  {clear highlight from key list box}
  lbKeys.ItemIndex := -1;
end;

procedure TOvcfrmCmdTable.EditChange(Sender: TObject);
begin
  if ckWordStar.State = cbChecked then
    {clear the wordstar flag if we are in the edit fields}
    if (GetFocus = HotEdit1.Handle) or (GetFocus = HotEdit2.Handle) then
      ckWordStar.State := cbUnChecked;
end;


{*** TCommandProcessorProperty ***}

procedure TOvcCommandProcessorProperty.Edit;
var
  CmdPE : TOvcfrmCmdTable;
begin
  {create the property editor form}
  CmdPE := TOvcfrmCmdTable.Create(Application);
  try
    {get pointer to our command processor so the property editor}
    {can edit fields of the command processor directly}
    CmdPE.CP := TOvcController(GetComponent(0)).EntryCommands;

    {display the form}
    CmdPE.ShowModal;

    {indicate that the controller was modified}
    Modified;
  finally
    CmdPE.Free;
  end;
end;

function TOvcCommandProcessorProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paReadOnly]
end;


{*** TOvcControllerEditor ***}

procedure TOvcControllerEditor.ExecuteVerb(Index : Integer);
var
  CmdPE : TOvcfrmCmdTable;
begin
  if Index = 0 then begin
    {create the property editor form}
    CmdPE := TOvcfrmCmdTable.Create(Application);
    try
      {get pointer to our command processor so the property editor}
      {can edit fields of the command processor directly}
      CmdPE.CP := (Component as TOvcController).EntryCommands;

      {display the form}
      CmdPE.ShowModal;

      {indicate that the controller was modified}
      Designer.Modified;
    finally
      CmdPE.Free;
    end;
  end;
end;

function TOvcControllerEditor.GetVerb(Index : Integer): String;
begin
  Result := 'Edit Commands...';
end;

function TOvcControllerEditor.GetVerbCount : Integer;
begin
  Result := 1;
end;


end.
