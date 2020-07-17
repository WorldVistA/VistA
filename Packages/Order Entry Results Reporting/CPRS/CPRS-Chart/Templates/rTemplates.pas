unit rTemplates;

interface

uses
  SysUtils,
  Classes,
  ORNet,
  ORFn,
  rCore,
  uCore,
  uConst,
  TRPCB,
  uTIU;

{ Templates }
procedure GetTemplateRoots(aLst: TStrings);
function IsUserTemplateEditor(TemplateID: string; UserID: Int64): boolean;
procedure GetTemplateChildren(ID: string; aLst: TStrings);
procedure GetTemplateBoilerplate(ID: string; aLst: TStrings);
procedure GetTemplateText(BoilerPlate: TStrings);
function IsTemplateEditor(ID: string): boolean;
function UpdateTemplate(ID: string; Fields: TStrings): string;
procedure UpdateChildren(ID: string; Children: TStrings);
procedure DeleteTemplates(DelList: TStrings);
procedure GetObjectList(aLst: TStrings);
procedure GetAllowedPersonalObjects(aLst: TStrings);
procedure TestBoilerplate(BoilerPlate: TStrings);
function GetTemplateAccess(ID: string): integer;
function SubSetOfBoilerplatedTitles(const StartFrom: string; Direction: integer; aLst: TStrings): boolean;
function GetTitleBoilerplate(TitleIEN: string): string;
function GetUserTemplateDefaults(LoadFromServer: boolean = FALSE): string;
procedure SetUserTemplateDefaults(Value: string; PieceNum: integer);
procedure SaveUserTemplateDefaults;
procedure LoadTemplateDescription(TemplateIEN: string; aLst: TStrings);
function GetTemplateAllowedReminderDialogs(aLst: TStrings): boolean;
function IsRemDlgAllowed(RemDlgIEN: string): integer;
function LockTemplate(const ID: string): boolean; // returns true if successful
procedure UnlockTemplate(const ID: string);
function GetLinkedTemplateData(const Link: string): string;
function SubSetOfAllTitles(const StartFrom: string; Direction: integer; aLst: TStrings): boolean;

{ Template Fields }
function SubSetOfTemplateFields(const StartFrom: string; Direction: integer; aLst: TStrings): boolean;
function LoadTemplateField(const DlgFld: string; aLst: TStrings): boolean;
function LoadTemplateFieldByIEN(const DlgFld: string; aLst: TStrings): boolean;
function CanEditTemplateFields: boolean;
function UpdateTemplateField(const ID: string; Fields: TStrings): string;
function LockTemplateField(const ID: string): boolean;
procedure UnlockTemplateField(const ID: string);
procedure DeleteTemplateField(const ID: string);
function ExportTemplateFields(FldList: TStrings): TStrings;
function ImportTemplateFields(FldList: TStrings): TStrings;
function IsTemplateFieldNameUnique(const FldName, IEN: string): boolean;
procedure Convert2LMText(Text: TStringList);
procedure CheckTemplateFields(ResultString: TStrings);
function BuildTemplateFields(XMLString: TStrings): boolean;
function ImportLoadedFields(ResultSet: TStrings): boolean;

implementation

var
  uUserTemplateDefaults: string = '';
  uCanEditDlgFldChecked: boolean = FALSE;
  uCanEditDlgFlds: boolean;

  { Template RPCs -------------------------------------------------------------- }

procedure GetTemplateRoots(aLst: TStrings);
begin
  CallVistA('TIU TEMPLATE GETROOTS', [User.DUZ], aLst);
end;

function IsUserTemplateEditor(TemplateID: string; UserID: Int64): boolean;
var
  aStr: string;
begin
  if StrToIntDef(TemplateID, 0) > 0 then
    begin
      CallVistA('TIU TEMPLATE ISEDITOR', [TemplateID, UserID], aStr);
      Result := (Piece(aStr, U, 1) = '1')
    end
  else
    Result := FALSE;
end;

procedure GetTemplateChildren(ID: string; aLst: TStrings);
begin
  if (ID = '') or (ID = '0') then
    aLst.Clear
  else
    CallVistA('TIU TEMPLATE GETITEMS', [ID], aLst);
end;

procedure GetTemplateBoilerplate(ID: string; aLst: TStrings);
begin
  if (ID = '') or (ID = '0') then
    aLst.Clear
  else
    CallVistA('TIU TEMPLATE GETBOIL', [ID], aLst);
end;

procedure GetTemplateText(BoilerPlate: TStrings);
var
  i: integer;

begin
  LockBroker;
  try
    with RPCBrokerV do
    begin
      ClearParameters := True;
      RemoteProcedure := 'TIU TEMPLATE GETTEXT';
      Param[0].PType := literal;
      Param[0].Value := Patient.DFN;
      Param[1].PType := literal;
      Param[1].Value := Encounter.VisitStr;
      Param[2].PType := list;
      for i := 0 to BoilerPlate.Count - 1 do
        Param[2].Mult[IntToStr(i + 1) + ',0'] := BoilerPlate[i];
      CallBroker;
      RPCBrokerV.Results.Delete(0);
      FastAssign(RPCBrokerV.Results, BoilerPlate);
      RPCBrokerV.Results.Clear;
    end;
  finally
    UnlockBroker;
  end;
end;

function IsTemplateEditor(ID: string): boolean;
var
  aStr: string;
begin
  CallVistA('TIU TEMPLATE ISEDITOR', [ID, User.DUZ], aStr);
  Result := (aStr = '1');
end;

function UpdateTIURec(RPC, ID: string; Fields: TStrings): string;
var
  i, j: integer;

begin
  LockBroker;
  try
    with RPCBrokerV do
    begin
      ClearParameters := True;
      RemoteProcedure := RPC;
      Param[0].PType := literal;
      Param[0].Value := ID;
      Param[1].PType := list;
      for i := 0 to Fields.Count - 1 do
        begin
          j := pos('=', Fields[i]);
          if (j > 0) then
            Param[1].Mult[Fields.Names[i]] := copy(Fields[i], j + 1, MaxInt);
        end;
      CallBroker;
      Result := RPCBrokerV.Results[0];
    end;
  finally
    UnlockBroker;
  end;
end;

function UpdateTemplate(ID: string; Fields: TStrings): string;
begin
  Result := UpdateTIURec('TIU TEMPLATE CREATE/MODIFY', ID, Fields);
end;

procedure UpdateChildren(ID: string; Children: TStrings);
var
  i: integer;

begin
  LockBroker;
  try
    with RPCBrokerV do
    begin
      ClearParameters := True;
      RemoteProcedure := 'TIU TEMPLATE SET ITEMS';
      Param[0].PType := literal;
      Param[0].Value := ID;
      Param[1].PType := list;
      for i := 0 to Children.Count - 1 do
        Param[1].Mult[IntToStr(i + 1)] := Children[i];
      CallBroker;
    end;
  finally
    UnlockBroker;
  end;
end;

procedure DeleteTemplates(DelList: TStrings);
var
  i: integer;

begin
  if (DelList.Count > 0) then
    begin
      LockBroker;
      try
        with RPCBrokerV do
        begin
          ClearParameters := True;
          RemoteProcedure := 'TIU TEMPLATE DELETE';
          Param[0].PType := list;
          for i := 0 to DelList.Count - 1 do
            Param[0].Mult[IntToStr(i + 1)] := DelList[i];
          CallBroker;
        end;
      finally
        UnlockBroker;
      end;
    end;
end;

procedure GetObjectList(aLst: TStrings);
begin
  CallVistA('TIU GET LIST OF OBJECTS', [], aLst);
end;

procedure GetAllowedPersonalObjects(aLst: TStrings);
begin
  CallVistA('TIU TEMPLATE PERSONAL OBJECTS', [], aLst);
end;

procedure TestBoilerplate(BoilerPlate: TStrings);
var
  i: integer;

begin
  LockBroker;
  try
    with RPCBrokerV do
    begin
      ClearParameters := True;
      RemoteProcedure := 'TIU TEMPLATE CHECK BOILERPLATE';
      Param[0].PType := list;
      for i := 0 to BoilerPlate.Count - 1 do
        Param[0].Mult['2,' + IntToStr(i + 1) + ',0'] := BoilerPlate[i];
      CallBroker;
    end;
  finally
    UnlockBroker;
  end;
end;

function GetTemplateAccess(ID: string): integer;
var
  aStr: string;
begin
  CallVistA('TIU TEMPLATE ACCESS LEVEL', [ID, User.DUZ, Encounter.Location], aStr);
  Result := StrToIntDef(aStr, 0);
end;

function SubSetOfBoilerplatedTitles(const StartFrom: string; Direction: integer; aLst: TStrings): boolean;
begin
  Result := CallVistA('TIU LONG LIST BOILERPLATED', [StartFrom, Direction], aLst);
end;

function GetTitleBoilerplate(TitleIEN: string): string;
var
  aLst: TStringList;
begin
  aLst := TStringList.Create;
  try
    CallVistA('TIU GET BOILERPLATE', [TitleIEN], aLst);
    Result := aLst.Text;
  finally
    FreeAndNil(aLst);
  end;
end;

function GetUserTemplateDefaults(LoadFromServer: boolean = FALSE): string;
begin
  if LoadFromServer then
    CallVistA('TIU TEMPLATE GET DEFAULTS', [], uUserTemplateDefaults);
  Result := uUserTemplateDefaults;
end;

procedure SetUserTemplateDefaults(Value: string; PieceNum: integer);
begin
  SetPiece(uUserTemplateDefaults, '/', PieceNum, Value);
end;

procedure SaveUserTemplateDefaults;
begin
  CallVistA('TIU TEMPLATE SET DEFAULTS', [uUserTemplateDefaults]);
end;

procedure LoadTemplateDescription(TemplateIEN: string; aLst: TStrings);
begin
  CallVistA('TIU TEMPLATE GET DESCRIPTION', [TemplateIEN], aLst);
end;

function GetTemplateAllowedReminderDialogs(aLst: TStrings): boolean;
var
  aTmpLst: TStringList;
begin
  aTmpLst := TStringList.Create;
  try
    Result := CallVistA('TIU REMINDER DIALOGS', [], aTmpLst);
    SortByPiece(aTmpLst, U, 2);
    MixedCaseList(aTmpLst);
    aLst.Text := aTmpLst.Text;
  finally
    FreeAndNil(aTmpLst);
  end;
  {
    CallV('TIU REMINDER DIALOGS', []);
    TmpList := TStringList.Create;
    try
    FastAssign(RPCBrokerV.Results, TmpList);
    SortByPiece(TmpList, U, 2);
    MixedCaseList(TmpList);
    FastAssign(TmpList, RPCBrokerV.Results);
    finally
    TmpList.Free;
    end;
    Result := RPCBrokerV.Results;
  }
end;

function IsRemDlgAllowed(RemDlgIEN: string): integer;
// -1 = inactive or deleted, 0 = not in Param, 1 = allowed
var
  aStr: string;
begin
  CallVistA('TIU REM DLG OK AS TEMPLATE', [RemDlgIEN], aStr);
  Result := StrToIntDef(aStr, -1);
end;

function LockTemplate(const ID: string): boolean; // returns true if successful
var
  aStr: string;
begin
  CallVistA('TIU TEMPLATE LOCK', [ID], aStr);
  Result := (aStr = '1')
end;

procedure UnlockTemplate(const ID: string);
begin
  CallVistA('TIU TEMPLATE UNLOCK', [ID]);
end;

function GetLinkedTemplateData(const Link: string): string;
begin
  CallVistA('TIU TEMPLATE GETLINK', [Link], Result);
end;

function SubSetOfAllTitles(const StartFrom: string; Direction: integer; aLst: TStrings): boolean;
begin
  Result := CallVistA('TIU TEMPLATE ALL TITLES', [StartFrom, Direction], aLst);
end;

{ Template Fields }

function SubSetOfTemplateFields(const StartFrom: string; Direction: integer; aLst: TStrings): boolean;
begin
  Result := CallVistA('TIU FIELD LIST', [StartFrom, Direction], aLst);
end;

function LoadTemplateField(const DlgFld: string; aLst: TStrings): boolean;
begin
  Result := CallVistA('TIU FIELD LOAD', [DlgFld], aLst);
end;

function LoadTemplateFieldByIEN(const DlgFld: string; aLst: TStrings): boolean;
begin
  Result := CallVistA('TIU FIELD LOAD BY IEN', [DlgFld], aLst);
end;

function CanEditTemplateFields: boolean;
var
  aStr: string;
begin
  if (not uCanEditDlgFldChecked) then
    begin
      uCanEditDlgFldChecked := True;
      CallVistA('TIU FIELD CAN EDIT', [], aStr);
      uCanEditDlgFlds := (aStr = '1');
    end;
  Result := uCanEditDlgFlds;
end;

function UpdateTemplateField(const ID: string; Fields: TStrings): string;
begin
  Result := UpdateTIURec('TIU FIELD SAVE', ID, Fields);
end;

function LockTemplateField(const ID: string): boolean; // returns true if successful
var
  aStr: string;
begin
  CallVistA('TIU FIELD LOCK', [ID], aStr);
  Result := (aStr = '1');
end;

procedure UnlockTemplateField(const ID: string);
begin
  CallVistA('TIU FIELD UNLOCK', [ID]);
end;

procedure DeleteTemplateField(const ID: string);
begin
  CallVistA('TIU FIELD DELETE', [ID]);
end;

function CallImportExportTemplateFields(FldList: TStrings; RPCName: string): TStrings;
var
  i: integer;

begin
// LockBroker in calling code, since result is RPCBrokerV.Results;
  with RPCBrokerV do
    begin
      ClearParameters := True;
      RemoteProcedure := RPCName;
      Param[0].PType := list;
      for i := 0 to FldList.Count - 1 do
        Param[0].Mult[IntToStr(i + 1)] := FldList[i];
      CallBroker;
    end;
  Result := RPCBrokerV.Results;
end;

function ExportTemplateFields(FldList: TStrings): TStrings;
begin
  Result := CallImportExportTemplateFields(FldList, 'TIU FIELD EXPORT');
end;

function ImportTemplateFields(FldList: TStrings): TStrings;
begin
  Result := CallImportExportTemplateFields(FldList, 'TIU FIELD IMPORT');
end;

procedure CheckTemplateFields(ResultString: TStrings);
begin
  CallVistA('TIU FIELD CHECK', [nil], ResultString);
end;

function IsTemplateFieldNameUnique(const FldName, IEN: string): boolean;
var
  aStr: string;
begin
  CallVistA('TIU FIELD NAME IS UNIQUE', [FldName, IEN], aStr);
  Result := (aStr = '1');
end;

procedure Convert2LMText(Text: TStringList);
var
  i: integer;
begin
  LockBroker;
  try
    with RPCBrokerV do
    begin
      ClearParameters := True;
      RemoteProcedure := 'TIU FIELD DOLMTEXT';
      Param[0].PType := list;
      for i := 0 to Text.Count - 1 do
        Param[0].Mult[IntToStr(i + 1) + ',0'] := Text[i];
      CallBroker;
    end;
    FastAssign(RPCBrokerV.Results, Text);
  finally
    UnlockBroker;
  end;
end;

function BuildTemplateFields(XMLString: TStrings): boolean; // Simply builds XML fields on the server
var // in chunks.
  i, j, p1: integer;
  ok: boolean;

  procedure reset_broker;
  begin
    with RPCBrokerV do
      begin
        ClearParameters := True;
        RemoteProcedure := 'TIU FIELD LIST ADD';
        Param[0].PType := list;
      end;
  end;

begin
  ok := True;
  LockBroker;
  try
    with RPCBrokerV do
    begin
      reset_broker;
      j := 1;
      for i := 0 to XMLString.Count - 1 do
        begin
          p1 := pos('<FIELD NAME="', XMLString[i]);
          if (p1 > 0) and (pos('">', copy(XMLString[i], p1 + 13, MaxInt)) > 0) then
            begin
              j := j + 1;
              if (j > 50) then
                begin
                  j := 1;
                  CallBroker;
                  if pos('1', Results[0]) = 0 then
                    begin
                      ok := FALSE;
                      break;
                    end; // if
                  reset_broker;
                end; // if
            end; // if
          Param[0].Mult[IntToStr(i + 1)] := XMLString[i];
        end; // for
      if ok then
        begin
          CallBroker;
          if pos('1', Results[0]) = 0 then ok := FALSE;
        end; // if
    end;
  finally
    UnlockBroker;
  end;
  Result := ok;
end;

function ImportLoadedFields(ResultSet: TStrings): boolean;
begin
  CallVistA('TIU FIELD LIST IMPORT', [nil], ResultSet);
  Result := (ResultSet.Count > 0);
end;

end.
