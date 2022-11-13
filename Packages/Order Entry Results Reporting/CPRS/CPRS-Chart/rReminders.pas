unit rReminders;

interface
uses
  Windows,Classes, SysUtils, TRPCB, ORNet, ORFn, fMHTest, StrUtils, ORNetINTF, Dialogs, UITypes;

type
  TMHdllFound = record
  DllCheck: boolean;
  DllFound: boolean;
end;

procedure GetCurrentReminders(var aReturn: TStrings);
procedure GetOtherReminders(Dest: TStrings);
procedure EvaluateReminders(RemList: TStringList; var aReturn: TStrings);
function EvaluateReminder(IEN: string): string;
procedure GetEducationTopicsForReminder(ReminderID: integer; var AReturn: TStrings);
procedure GetEducationSubtopics(TopicID: integer; var AReturn: TStrings);
procedure GetReminderWebPages(ReminderID: string; var AReturn: TStrings);
function DetailReminder(IEN: Integer; aReturn: TStrings): integer;
function ReminderInquiry(IEN: Integer; aReturn: TStrings): integer;
function EducationTopicDetail(IEN: Integer; aReturn: TStrings): integer;
function GetDialogInfo(IEN: string; RemIEN: boolean; aReturn: TStrings): integer;
function GetDialogPrompts(IEN: string; Historical: boolean; FindingType, remIEN: string; aReturn: TStrings; newDataOnly: String): integer;
procedure GetDialogStatus(AList: TStringList);
function GetRemindersActive: boolean;
function GetProgressNoteHeader(Locaton: integer): string;
procedure SaveWomenHealthData(var WHData: TStringlist);
function CheckGECValue(const RemIEN: string; NoteIEN: integer; VisitStr: string): String;
procedure SaveMSTDataFromReminder(VDate, Sts, Prov, FType, FIEN, Res: string);

function GetReminderFolders: string;
procedure SetReminderFolders(const Value: string);
function GetDefLocations(aReturn: TStrings): integer;
function InsertRemTextAtCursor: boolean;

function NewRemCoverSheetListActive: boolean;
function CanEditAllRemCoverSheetLists: boolean;
function GetCoverSheetLevelData(ALevel, AClass: string; aReturn: TStrings): integer;
procedure SetCoverSheetLevelData(ALevel, AClass: string; Data: TStrings);
function GetCategoryItems(CatIEN: integer; aReturn: TStrings): integer;
function GetAllRemindersAndCategories(aReturn: TStrings): integer;
function VerifyMentalHealthTestComplete(TestName, Answers: string): String;
function MHDLLFound: boolean;
function UsedMHDllRPC: boolean;
procedure PopulateMHdll;
procedure GetMHResultText(var AText: string; ResultsGroups, Scores: TStringList; DIEN:String; var linkList: TStringList);
procedure SaveGenFindingData(GenFindingList: TStringList; DFN: String; Visit: String; Identifier: String; noteIEN, user, encProv: String);
procedure FormatGenFindingData(var aList: iORNetMult; GenFindingList: TStringList; DFN: String; Visit: String; Identifier: String; noteIEN, user, encProv: String);
procedure clearGlobals;
function ValidateGenFindingData(GenFindingList: TStringList; DFN: String; Visit: String; Identifier: String; noteIEN, user, encProv: String): boolean;
function getLinkPromptValue(value, itemId, orgValue, dfn: string): String;
procedure getGeneralFindingText(var list: TStrings; var canprint: boolean; var header: String; dfn, ien, value: string);
procedure getLinkSeqList(var list: TStrings; ien: string);


implementation

uses
  uCore, uReminders, rCore;

var
  uLastDefLocUser: int64 = -1;
  uDefLocs: TStringList = nil;
  uRemInsertAtCursor: integer = -1;
  uNewCoverSheetListActive: integer = -1;
  uCanEditAllCoverSheetLists: integer = -1;
  MHDLL: TMHDllFound;

procedure GetCurrentReminders(var aReturn: TStrings);
begin
  CallVistA('ORQQPXRM REMINDERS UNEVALUATED', [Patient.DFN, Encounter.Location], AReturn);
end;

procedure GetOtherReminders(Dest: TStrings);
begin
  CallVistA('ORQQPXRM REMINDER CATEGORIES', [Patient.DFN, Encounter.Location], Dest);
end;

procedure EvaluateReminders(RemList: TStringList; var aReturn: TStrings);
var
  i: integer;
  aList: iORNetMult;
begin
    neworNetMult(aList);
    for i := 0 to RemList.Count-1 do
      aList.AddSubscript(i+1, Piece(RemList[i],U,1));
      CallVistA('ORQQPXRM REMINDER EVALUATION', [patient.DFN, aList], aReturn);
end;

function EvaluateReminder(IEN: string): string;
var
  TmpSL: TStringList;
  aList: TStrings;
begin
  TmpSL := TStringList.Create;
  aList := TStringList.Create;
  try
    TmpSL.Add(IEN);
    EvaluateReminders(TmpSL, aList);
    if(aList.Count > 0) then
      Result := aList[0]
    else
      Result := IEN;
  finally
    FreeAndNil(tmpSL);
    FreeAndNil(aList);
  end;
end;

procedure GetEducationTopicsForReminder(ReminderID: integer; var AReturn: TStrings);
begin
  CallVistA('ORQQPXRM EDUCATION SUMMARY', [ReminderID], AReturn);
end;

procedure GetEducationSubtopics(TopicID: integer; var AReturn: TStrings);
begin
  CallVistA('ORQQPXRM EDUCATION SUBTOPICS', [TopicID], aReturn);
end;

procedure GetReminderWebPages(ReminderID: string; var AReturn: TStrings);
begin
  CallVistA('ORQQPXRM REMINDER WEB', [ReminderID], AReturn);
end;

function DetailReminder(IEN: integer; aReturn: TStrings): integer; // Clinical Maintenance
begin
  if InteractiveRemindersActive then
    CallVistA('ORQQPXRM REMINDER DETAIL', [Patient.DFN, IEN], aReturn)
  else
    CallVistA('ORQQPX REMINDER DETAIL', [Patient.DFN, IEN], aReturn);
  result := aReturn.Count;
end;

function ReminderInquiry(IEN: Integer; aReturn: TStrings): integer;
begin
  CallVista('ORQQPXRM REMINDER INQUIRY', [IEN], aReturn);
  Result := AReturn.Count;
end;

function EducationTopicDetail(IEN: Integer; aReturn: TStrings): integer;
begin
  CallVistA('ORQQPXRM EDUCATION TOPIC', [IEN], aReturn);
  result := aReturn.Count;
end;

function GetDialogInfo(IEN: string; RemIEN: boolean; aReturn: TStrings): integer;
var
visitID: string;
begin
     if remForm.PCEObj.VisitIEN > 0 then visitID := IntToStr(remForm.PCEObj.VisitIEN)
     else visitID := remForm.PCEObj.VisitString;

     if RemIEN then
      CallVistA('ORQQPXRM REMINDER DIALOG', [IEN, Patient.DFN, visitID], aReturn)
     else
      CallVistA('PXRM REMINDER DIALOG (TIU)', [IEN, Patient.DFN, visitID], aReturn);
  Result := aReturn.Count;
end;

function GetDialogPrompts(IEN: string; Historical: boolean; FindingType, remIEN: string; aReturn: TStrings; newDataOnly: string): integer;

begin
  CallVistA('ORQQPXRM DIALOG PROMPTS', [IEN, Historical, FindingType, remIEN, newDataOnly], aReturn);
  result := aReturn.Count;
end;

procedure GetDialogStatus(AList: TStringList);
var
  i: integer;
  list: iORNetMult;
begin
  neworNetMult(list);
  if(Alist.Count = 0) then exit;
    for i := 0 to AList.Count-1 do
      list.AddSubscript(Alist[i], '');
    CallVistA('ORQQPXRM DIALOG ACTIVE', [list], aList);
end;

function GetRemindersActive: boolean;
var
aReturn: string;
begin
  CallVistA('ORQQPX NEW REMINDERS ACTIVE',[], aReturn);
  result := aReturn = '1';
end;

function GetProgressNoteHeader(Locaton: integer): string;
begin
  CallVistA('ORQQPXRM PROGRESS NOTE HEADER', [Locaton], result);
end;

procedure SaveWomenHealthData(var WHData: TStringlist);
begin
  if assigned(WHData) then
  begin
  CallVistA('ORQQPXRM WOMEN HEALTH SAVE', [WHData]);
  end;
end;

procedure clearGlobals;
begin
  CallVistA('PXRMRPCG CANCEL', []);
end;

procedure SaveGenFindingData(GenFindingList: TStringList; DFN: String; Visit: String; Identifier: String; noteIEN, user, encProv: String);
var
  aList: iORNetMult;
  aReturn: TStringList;
  c: integer;
  text: string;
begin
  neworNetMult(aList);
  FormatGenFindingData(aList, GenFindingList, DFN, Visit, Identifier, noteIEN, user, encProv);
    aReturn := TStringList.Create;
    text := '';
    try
    CallVistA('PXRMRPCG GENFUPD', [aList], aReturn);
    if aReturn.Count > 0 then
    begin
      if Piece(aReturn.Strings[0], U, 1) = '-1' then
      begin
        for c := 1 to aReturn.Count -1 do
            begin
              text := text + aReturn.Strings[c] + CRLF
            end;
         TaskMessageDlg('General Findings Error', 'Your data was not saved.' + CRLF + text, mtError, [mbOk], 0);
      end;

    end;
    finally
      FreeAndNil(aReturn);
    end;
end;

procedure FormatGenFindingData(var aList: iORNetMult; GenFindingList: TStringList; DFN: String; Visit: String; Identifier: String; noteIEN, user, encProv: String);
var
  c, i, index: integer;
  allGroup, group, dien,node,temp: string;
//  newData: boolean;
  begin
    c := 1;
    i := 1;
    temp := '';
    allGroup := '0';
    aList.AddSubscript('0', DFN + U + Visit + U + NoteIen + U + user + U + encProv);
    for index := 0 to GenFindingList.Count-1 do
      begin
        dien := Piece(GenFindingList[index],U,1);
        node := Pieces(GenFindingList[index],U,2,30);
//        if Piece(node, U, 16) = '1' then newData := true
//        else newData := false;
        group := Piece(node, U, 17);
        if Piece(node,U,14) <> '' then
        begin
          temp := Piece(node,U,2) + U + Piece(node,U,14);
          if group = '' then aList.AddSubscript([dien, '0', 'ID', i], temp)
          else aList.AddSubscript([dien, group, 'ID', i], temp);
          inc(i);
        end;
        if group = '' then alist.AddSubscript([dien,'0',c], node)
        else alist.AddSubscript([dien, group, c], node);
        c := c + 1;
      end;
  end;

function ValidateGenFindingData(GenFindingList: TStringList; DFN: String; Visit: String; Identifier: String; noteIEN, user, encProv: String): boolean;
var
  aList: iORNetMult;
  aReturn: TStringList;
  c: integer;
  text: string;
begin
    result := true;
    neworNetMult(aList);
    FormatGenFindingData(aList, GenFindingList, DFN, Visit, Identifier, noteIEN, user, encProv);
    aReturn := TStringList.Create;
    try
    CallVistA('PXRMRPCG GENFVALD', [aList], aReturn);
    if aReturn.Count > 0 then
    begin
      if Piece(aReturn.Strings[0], U, 1) = '-1' then
        begin
          for c := 1 to aReturn.Count -1 do
            begin
              text := text + aReturn.Strings[c] + CRLF
            end;
          TaskMessageDlg('General Findings Validation Failure', 'Validation Error.' + CRLF + text, mtWarning, [mbOk], 0);
          result := false;
        end;
    end
    else
    begin
      result := false;
    end;
    finally
      FreeAndNil(aReturn);
    end;
end;

function getLinkPromptValue(value, itemId, orgValue, dfn: string): String;
 begin
  CallVistA('PXRMRPCC PROMPTVL',[value, itemId, orgValue, dfn], result);
 end;

procedure getGeneralFindingText(var list: TStrings; var canprint: boolean; var header: String; dfn, ien, value: string);
var
alist: TStrings;
i: integer;
tmp: string;
begin
  aList := TStringList.create;
  try
    CallVistA('PXRMRPCG VIEW', [dfn, ien, value], alist);
    if aList.Count > 0 then
      tmp := aList[0]
    else
      tmp := '';
    if Piece(tmp, U, 1) = '1' then canPrint := true
    else canPrint := false;
    header := Piece(tmp, U, 2);
    for i := 1 to aList.count - 1 do list.add(aList[i]);
  finally
    FreeAndNil(aList);

  end;
end;

procedure getLinkSeqList(var list: TStrings; ien: string);
var
aReturn: TStrings;
node,temp: string;
cnt,i: integer;
begin
  aReturn := TStringList.Create;
  try
    cnt := 0;
    temp := '';
    CallVistA('ORQQPXRM REMINDER LINK SEQ',[ien],aReturn);
    for i := 1 to aReturn.Count - 1 do
      begin
        node := aReturn.Strings[i];
        if pos('~', node) > 0 then
          begin
            temp := '';
            cnt := 0;
          end
        else
          begin
            if cnt = 2 then
              begin
                cnt := 0;
                temp := '';
              end;
            inc(cnt);
            SetPiece(temp, u, cnt, node);
            if cnt = 2 then list.Add(ien + U + temp);
          end;
      end;
//    if aReturn.Strings[0] = '0' then exit;
//    FastAssign(aReturn, list);
  finally
  FreeAndNil(aReturn);
  end;

end;

function CheckGECValue(const RemIEN: string; NoteIEN: integer; VisitStr: string): String;
var
ans,str,str1,title: string;
fin: boolean;
i,cnt: integer;

begin
  CallVistA('ORQQPXRM GEC DIALOG', [RemIEN, Patient.DFN, VisitStr, NoteIEN], result);
  if Piece(Result,U,1) <> '0' then
  begin
    if Piece(Result,U,5)='1' then
        begin
            if pos('~',Piece(Result,U,4))>0 then
               begin
               str:='';
               str1 := Piece(Result,U,4);
               cnt := DelimCount(str1, '~');
               for i:=1 to cnt+1 do
                   begin
                   if i = 1 then str := Piece(str1,'~',i);
                   if i > 1 then str :=str+CRLF+Piece(str1,'~',i);
                   end;
             end
             else str := Piece(Result,U,1);
        title := Piece(Result,U,3);
        fin := (InfoBox(str,title, MB_YESNO)=IDYES);
        if fin = true then ans := '1';
        if fin = false then ans := '0';
        CallVistA('ORQQPXRM GEC FINISHED?',[Patient.DFN,ans]);
        end;
   Result := Piece(Result, U,2);
   end
  else Result := '';
end;

procedure SaveMSTDataFromReminder(VDate, Sts, Prov, FType, FIEN, Res: string);
begin
  CallVistA('ORQQPXRM MST UPDATE', [Patient.DFN, VDate, Sts, Prov, FType, FIEN, Res]);
end;

function GetReminderFolders: string;
begin
  CallVistA('ORQQPX GET FOLDERS', [], result);
end;

procedure SetReminderFolders(const Value: string);
begin
  CallVistA('ORQQPX SET FOLDERS', [Value]);
end;

function GetDefLocations(aReturn: TStrings): integer;
begin
  if (User.DUZ <> uLastDefLocUser) then
  begin
    if(not assigned(uDefLocs)) then
      uDefLocs := TStringList.Create;
    CallVistA('ORQQPX GET DEF LOCATIONS', [], uDefLocs);
    uLastDefLocUser := User.DUZ;
  end;
  aReturn.Assign(uDefLocs);
  Result := areturn.Count;
end;

function InsertRemTextAtCursor: boolean;
var
returnValue: string;
begin
  if uRemInsertAtCursor < 0 then
  begin
    CallVistA('ORQQPX REM INSERT AT CURSOR', [], returnValue);
    result := returnValue = '1';
    uRemInsertAtCursor := ord(Result);
  end
  else
    Result := Boolean(uRemInsertAtCursor);
end;

function NewRemCoverSheetListActive: boolean;
var
returnValue: string;
begin
  if uNewCoverSheetListActive < 0 then
  begin
    CallVistA('ORQQPX NEW COVER SHEET ACTIVE', [], returnValue);
    result := returnValue = '1';
    uNewCoverSheetListActive := ord(Result);
  end
  else
    Result := Boolean(uNewCoverSheetListActive);
end;

function CanEditAllRemCoverSheetLists: boolean;
begin
  if uCanEditAllCoverSheetLists < 0 then
  begin
    Result := HasMenuOptionAccess('PXRM CPRS CONFIGURATION');
    uCanEditAllCoverSheetLists := ord(Result);
  end
  else
    Result := Boolean(uCanEditAllCoverSheetLists);
end;

function GetCoverSheetLevelData(ALevel, AClass: string; aReturn: TStrings): integer;
begin
  CallVistA('ORQQPX LVREMLST', [ALevel, AClass], aReturn);
  Result := aReturn.Count;
end;

procedure SetCoverSheetLevelData(ALevel, AClass: string; Data: TStrings);
var
  i: integer;
  aList: iORNetMult;
begin
  neworNetMult(aList);
    for i := 0 to Data.Count-1 do
      aList.AddSubscript(i + 1, data[i]);
    CallVistA('ORQQPX SAVELVL', [aLevel, aClass, aList]);
end;

function GetCategoryItems(CatIEN: integer; aReturn: TStrings): integer;
begin
  CallVistA('PXRM REMINDER CATEGORY', [CatIEN], aReturn);
  result := aReturn.Count;
end;

function GetAllRemindersAndCategories(aReturn: TStrings): integer;
begin
  CallVistA('PXRM REMINDERS AND CATEGORIES', [], aReturn);
  result := aReturn.Count;
end;

function VerifyMentalHealthTestComplete(TestName, Answers: string): String;
var
aReturn: TStrings;
returnValue: string;
begin
  aReturn := TStringList.Create;
  try
    CallVistA('ORQQPXRM MHV', [Patient.DFN, TestName, Answers], aReturn);
    if aReturn.Count > 0 then
      returnValue := aReturn[0]
    else
    begin
      Result := '';
      Exit;
    end;
    if returnValue='2' then
      begin
        Result := '2'+ U;
        EXIT;
      end;
    if returnValue = '1' then
      begin
        Result := '1' + U;
        EXIT;
      end;
    if returnValue = '0' then
      begin
        Result := '0' + U;
        if aReturn.Count > 1 then
          Result := Result + aReturn.Strings[1];
        EXIT;
      end;
  finally
     FreeAndNil(aReturn);
  end;

end;

function MHDLLFound: boolean;
begin
  if MHDll.DllCheck = false then
     begin
       MHDll.DllCheck := True;
       MHDLL.DllFound := CheckforMHDll;
     end;
  Result := MHDLL.DllFound;
end;

function UsedMHDllRPC: boolean;
var
returnValue: string;
begin
  CallVistA('ORQQPXRM MHDLLDMS',[], returnValue);
  result := returnValue = '1';
end;

procedure PopulateMHdll;
begin
  if MHDll.DllCheck = false then
    begin
      MHDll.DllCheck := True;
      MHDll.DllFound := CheckforMHDll;
    end;
end;

procedure GetMHResultText(var AText: string; ResultsGroups, Scores: TStringList;
      dien: String; var linkList: TStringList);
var
i, j: integer;
tmp, info: string;
tempInfo: TStringList;
aList: iORNetMult;
aReturn: TStringList;
begin
    neworNetMult(aList);
    j := 0;
    for i := 0 to ResultsGroups.Count-1 do
      begin
        j := j + 1;
        aList.AddSubscript(['RESULTS' , IntToStr(j)], ResultsGroups.Strings[i]);
      end;
    j := 0;
    for i := 0 to Scores.Count-1 do
      begin
        j := j + 1;
        aList.AddSubscript(['SCORES' , IntToStr(j)], Scores.Strings[i]);
      end;
  aReturn := TStringList.Create;
  try
  CallVistA('ORQQPXRM MHDLL', [patient.DFN, aList, dien], aReturn);
  AText := '';
  info := '';
  for i := 0 to aReturn.Count - 1 do
    begin
      tmp := aReturn.Strings[i];
      if pos('[INFOTEXT]',tmp)>0 then
        begin
           if info <> '' then info := info + ' ' + Copy(tmp,11,(Length(tmp)-1))
           else info := Copy(tmp,11,(Length(tmp)-1));
        end
      else if pos('[LINK]',tmp)>0 then linkList.Add(Pieces(tmp, U, 2,5))
      else
      begin
        if(AText <> '') then
        begin
          if(copy(AText, length(AText), 1) = '.') then
            AText := AText;
          AText := AText + ' ';
        end;
        AText := AText + Trim(tmp);
      end;
  end;
  if info <> '' then
    begin
      if pos(U, info) > 0 then
        begin
          tempInfo := TStringList.Create;
          PiecestoList(info,'^',tempInfo);
          info := '';
          for i := 0 to tempInfo.Count -1 do
            begin
              if info = '' then info := tempInfo.Strings[i]
              else info := info + CRLF + tempInfo.Strings[i];
            end;
        end;
      InfoBox(info,'Attention Needed',MB_OK);
    end;
  finally
    FreeAndNil(aReturn);
  end;

end;
initialization

finalization
  FreeAndNil(uDefLocs);

end.
