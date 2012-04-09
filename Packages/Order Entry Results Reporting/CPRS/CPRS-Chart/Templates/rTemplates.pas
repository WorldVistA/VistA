unit rTemplates;

interface

uses SysUtils, Classes, ORNet, ORFn, rCore, uCore, uConst, TRPCB, uTIU;

{ Templates }
procedure GetTemplateRoots;
function IsUserTemplateEditor(TemplateID: string; UserID :Int64): boolean;
procedure GetTemplateChildren(ID: string);
procedure GetTemplateBoilerplate(ID: string);
procedure GetTemplateText(BoilerPlate: TStrings);
function IsTemplateEditor(ID: string): boolean;
//function SubSetOfTemplateOwners(const StartFrom: string; Direction: Integer): TStrings;
function UpdateTemplate(ID: string; Fields: TStrings): string;
procedure UpdateChildren(ID: string; Children: TStrings);
procedure DeleteTemplates(DelList: TStrings);
procedure GetObjectList;
procedure GetAllowedPersonalObjects;
procedure TestBoilerplate(BoilerPlate: TStrings);
function GetTemplateAccess(ID: string): integer;
function SubSetOfBoilerplatedTitles(const StartFrom: string; Direction: Integer): TStrings;
function GetTitleBoilerplate(TitleIEN: string): string;
function GetUserTemplateDefaults(LoadFromServer: boolean = FALSE): string;
procedure SetUserTemplateDefaults(Value: string; PieceNum: integer);
procedure SaveUserTemplateDefaults;
procedure LoadTemplateDescription(TemplateIEN: string);
function GetTemplateAllowedReminderDialogs: TStrings;
function IsRemDlgAllowed(RemDlgIEN: string): integer;
function LockTemplate(const ID: string): boolean; // returns true if successful
procedure UnlockTemplate(const ID: string);
function GetLinkedTemplateData(const Link: string): string;
function SubSetOfAllTitles(const StartFrom: string; Direction: Integer): TStrings;

{ Template Fields }
function SubSetOfTemplateFields(const StartFrom: string; Direction: Integer): TStrings;
function LoadTemplateField(const DlgFld: string): TStrings;
function LoadTemplateFieldByIEN(const DlgFld: string): TStrings;
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

procedure GetTemplateRoots;
begin
  CallV('TIU TEMPLATE GETROOTS', [User.DUZ]);
end;

function IsUserTemplateEditor(TemplateID: string; UserID :Int64): boolean;
begin
  if StrToIntDef(TemplateID,0) > 0 then
    Result := (Piece(sCallV('TIU TEMPLATE ISEDITOR', [TemplateID, UserID]),U,1) = '1')
  else
    Result := FALSE;
end;

procedure GetTemplateChildren(ID: string);
begin
  if(ID = '') or (ID = '0') then
    RPCBrokerV.Results.Clear
  else
    CallV('TIU TEMPLATE GETITEMS', [ID]);
end;

procedure GetTemplateBoilerplate(ID: string);
begin
  if(ID = '') or (ID = '0') then
    RPCBrokerV.Results.Clear
  else
    CallV('TIU TEMPLATE GETBOIL', [ID]);
end;

procedure GetTemplateText(BoilerPlate: TStrings);
var
  i: integer;

begin
  with RPCBrokerV do
  begin
    ClearParameters := True;
    RemoteProcedure := 'TIU TEMPLATE GETTEXT';
    Param[0].PType := literal;
    Param[0].Value := Patient.DFN;
    Param[1].PType := literal;
    Param[1].Value := Encounter.VisitStr;
    Param[2].PType := list;
    for i := 0 to BoilerPlate.Count-1 do
      Param[2].Mult[IntToStr(i+1)+',0'] := BoilerPlate[i];
    CallBroker;
    RPCBrokerV.Results.Delete(0);
    FastAssign(RPCBrokerV.Results, BoilerPlate);
    RPCBrokerV.Results.Clear;
  end;
end;

function IsTemplateEditor(ID: string): boolean;
begin
  Result := (sCallV('TIU TEMPLATE ISEDITOR', [ID, User.DUZ]) = '1');
end;

//function SubSetOfTemplateOwners(const StartFrom: string; Direction: Integer): TStrings;
//begin
//  CallV('TIU TEMPLATE LISTOWNR', [StartFrom, Direction]);
//  MixedCaseList(RPCBrokerV.Results);
//  Result := RPCBrokerV.Results;
//end;

function UpdateTIURec(RPC, ID: string; Fields: TStrings): string;
var
  i, j: integer;

begin
  with RPCBrokerV do
  begin
    ClearParameters := True;
    RemoteProcedure := RPC;
    Param[0].PType := literal;
    Param[0].Value := ID;
    Param[1].PType := list;
    for i := 0 to Fields.Count-1 do
    begin
      j := pos('=',Fields[i]);
      if(j > 0) then
        Param[1].Mult[Fields.Names[i]] := copy(Fields[i],j+1,MaxInt);
    end;
    CallBroker;
    Result := RPCBrokerV.Results[0];
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
  with RPCBrokerV do
  begin
    ClearParameters := True;
    RemoteProcedure := 'TIU TEMPLATE SET ITEMS';
    Param[0].PType := literal;
    Param[0].Value := ID;
    Param[1].PType := list;
    for i := 0 to Children.Count-1 do
      Param[1].Mult[IntToStr(i+1)] := Children[i];
    CallBroker;
  end;
end;

procedure DeleteTemplates(DelList: TStrings);
var
  i: integer;

begin
  if(DelList.Count > 0) then
  begin
    with RPCBrokerV do
    begin
      ClearParameters := True;
      RemoteProcedure := 'TIU TEMPLATE DELETE';
      Param[0].PType := list;
      for i := 0 to DelList.Count-1 do
        Param[0].Mult[IntToStr(i+1)] := DelList[i];
      CallBroker;
    end;
  end;
end;

procedure GetObjectList;
begin
  CallV('TIU GET LIST OF OBJECTS', []);
end;

procedure GetAllowedPersonalObjects;
begin
  CallV('TIU TEMPLATE PERSONAL OBJECTS', []);
end;

procedure TestBoilerplate(BoilerPlate: TStrings);
var
  i: integer;

begin
  with RPCBrokerV do
  begin
    ClearParameters := True;
    RemoteProcedure := 'TIU TEMPLATE CHECK BOILERPLATE';
    Param[0].PType := list;
    for i := 0 to BoilerPlate.Count-1 do
      Param[0].Mult['2,'+IntToStr(i+1)+',0'] := BoilerPlate[i];
    CallBroker;
  end;
end;

function GetTemplateAccess(ID: string): integer;
begin
  Result := StrToIntDef(sCallV('TIU TEMPLATE ACCESS LEVEL', [ID, User.DUZ, Encounter.Location]), 0);
end;

function SubSetOfBoilerplatedTitles(const StartFrom: string; Direction: Integer): TStrings;
begin
  CallV('TIU LONG LIST BOILERPLATED', [StartFrom, Direction]);
  Result := RPCBrokerV.Results;
end;

function GetTitleBoilerplate(TitleIEN: string): string;
begin
  CallV('TIU GET BOILERPLATE', [TitleIEN]);
  Result := RPCBrokerV.Results.Text;
end;

function GetUserTemplateDefaults(LoadFromServer: boolean = FALSE): string;
begin
  if(LoadFromServer) then
  uUserTemplateDefaults := sCallV('TIU TEMPLATE GET DEFAULTS', []);
  Result := uUserTemplateDefaults;
end;

procedure SetUserTemplateDefaults(Value: string; PieceNum: integer);
begin
  SetPiece(uUserTemplateDefaults, '/', PieceNum, Value);
end;

procedure SaveUserTemplateDefaults;
begin
  CallV('TIU TEMPLATE SET DEFAULTS', [uUserTemplateDefaults]);
end;

procedure LoadTemplateDescription(TemplateIEN: string);
begin
  CallV('TIU TEMPLATE GET DESCRIPTION', [TemplateIEN]);
end;

function GetTemplateAllowedReminderDialogs: TStrings;
var
  TmpList: TStringList;

begin
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
end;

function IsRemDlgAllowed(RemDlgIEN: string): integer;
// -1 = inactive or deleted, 0 = not in Param, 1 = allowed
begin
  Result := StrToIntDef(sCallV('TIU REM DLG OK AS TEMPLATE', [RemDlgIEN]),-1);
end;

function LockTemplate(const ID: string): boolean; // returns true if successful
begin
  Result := (sCallV('TIU TEMPLATE LOCK', [ID]) = '1')
end;

procedure UnlockTemplate(const ID: string);
begin
  CallV('TIU TEMPLATE UNLOCK', [ID]);
end;

function GetLinkedTemplateData(const Link: string): string;
begin
  Result := sCallV('TIU TEMPLATE GETLINK', [Link]);
end;

function SubSetOfAllTitles(const StartFrom: string; Direction: Integer): TStrings;
begin
  CallV('TIU TEMPLATE ALL TITLES', [StartFrom, Direction]);
  Result := RPCBrokerV.Results;
end;

{ Template Fields }

function SubSetOfTemplateFields(const StartFrom: string; Direction: Integer): TStrings;
begin
  CallV('TIU FIELD LIST', [StartFrom, Direction]);
  Result := RPCBrokerV.Results;
end;

function LoadTemplateField(const DlgFld: string): TStrings;
begin
  CallV('TIU FIELD LOAD', [DlgFld]);
  Result := RPCBrokerV.Results;
end;

function LoadTemplateFieldByIEN(const DlgFld: string): TStrings;
begin
  CallV('TIU FIELD LOAD BY IEN', [DlgFld]);
  Result := RPCBrokerV.Results;
end;

function CanEditTemplateFields: boolean;
begin
  if(not uCanEditDlgFldChecked) then
  begin
    uCanEditDlgFldChecked := TRUE;
    uCanEditDlgFlds := sCallV('TIU FIELD CAN EDIT', []) = '1';
  end;
  Result := uCanEditDlgFlds;
end;

function UpdateTemplateField(const ID: string; Fields: TStrings): string;
begin
  Result := UpdateTIURec('TIU FIELD SAVE', ID, Fields);
end;

function LockTemplateField(const ID: string): boolean; // returns true if successful
begin
  Result := (sCallV('TIU FIELD LOCK', [ID]) = '1')
end;

procedure UnlockTemplateField(const ID: string);
begin
  CallV('TIU FIELD UNLOCK', [ID]);
end;

procedure DeleteTemplateField(const ID: string);
begin
  CallV('TIU FIELD DELETE', [ID]);
end;

function CallImportExportTemplateFields(FldList: TStrings; RPCName: string): TStrings;
var
  i: integer;

begin
  with RPCBrokerV do
  begin
    ClearParameters := True;
    RemoteProcedure := RPCName;
    Param[0].PType := list;
    for i := 0 to FldList.Count-1 do
      Param[0].Mult[IntToStr(i+1)] := FldList[i];
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
  CallV('TIU FIELD CHECK',[nil]);
  FastAssign(RPCBrokerV.Results, ResultString);
end;

function IsTemplateFieldNameUnique(const FldName, IEN: string): boolean;
begin
  Result := sCallV('TIU FIELD NAME IS UNIQUE', [FldName, IEN]) = '1';
end;

procedure Convert2LMText(Text: TStringList);
var
  i: integer;
begin
  with RPCBrokerV do
  begin
    ClearParameters := True;
    RemoteProcedure := 'TIU FIELD DOLMTEXT';
    Param[0].PType := list;
    for i := 0 to Text.Count-1 do
      Param[0].Mult[IntToStr(i+1)+',0'] := Text[i];
    CallBroker;
  end;
  FastAssign(RPCBrokerV.Results, Text);
end;

function BuildTemplateFields(XMLString: TStrings): boolean;   //Simply builds XML fields on the server
var                                                           //in chunks.
  i,j,p1: integer;
  ok: boolean;

  procedure reset_broker;
  begin
    with RPCBrokerV do begin
      ClearParameters := True;
      RemoteProcedure := 'TIU FIELD LIST ADD';
      Param[0].PType := list;
    end;
  end;

begin
  ok := TRUE;
  with RPCBrokerV do
  begin
    reset_broker;
    j := 1;
    for i := 0 to XMLString.Count-1 do begin
      p1 := pos('<FIELD NAME="',XMLString[i]);
      if (p1 > 0) and (pos('">',copy(XMLString[i],p1+13,maxint)) > 0) then begin
        j := j + 1;
        if (j > 50) then begin
          j := 1;
          CallBroker;
          if pos('1',Results[0]) = 0 then begin
            ok := FALSE;
            break;
          end;//if
          reset_broker;
        end;//if
      end;//if
      Param[0].Mult[IntToStr(i+1)] := XMLString[i];
    end;//for
    if ok then begin
      CallBroker;
      if pos('1',Results[0]) = 0 then ok := FALSE;
    end;//if
  end;
  Result := ok;
end;

function ImportLoadedFields(ResultSet: TStrings): boolean;
begin
  Result := TRUE;
  CallV('TIU FIELD LIST IMPORT',[nil]);
  FastAssign(RPCBrokerV.Results, ResultSet);
  if ResultSet.Count < 1 then
    Result := FALSE;
end;

end.
