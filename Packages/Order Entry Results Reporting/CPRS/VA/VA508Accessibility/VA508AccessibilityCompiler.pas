unit VA508AccessibilityCompiler;

{$DEFINE VA508COMPILER}
{$UNDEF VA508COMPILER}

{ TODO -oJeremy Merrill -c508 :
Add additional warning types:
1) forms in app without 508 manager components
2) hints about default components?
3) components without tab stops, filter out panels that don't have on click events }
interface

uses
  SysUtils, DesignIntf, DesignEditors, TypInfo, Controls, StdCtrls, Classes, ToolsApi,
  Forms, VA508AccessibilityManager, StrUtils, Windows, Variants, Dialogs;

type
  TVA508Compiler = class(TNotifierObject, IOTANotifier, IOTAIDENotifier, IOTAIDENotifier50, IOTAIDENotifier80)
  private
    FErrorCount: integer;
    FWarningCount: integer;
    FCached: integer;
    FBuilt: integer;
    FDFMDataCount: integer;
    F508Problems: boolean;
    FMessageLog: TStringList;
    F508ManagersFound: boolean;
    FCompileStopped: boolean;
    FOpenFiles: TStringList;
    procedure ScanFor508Errors(const Project: IOTAProject);
    procedure startMessages;
    procedure stopMessages;
    procedure UpdateMonitor(FileName: string);
    procedure StopCompile;
    procedure msg(txt: String);
    procedure infoMessage(fileName, infoText: string);
    procedure error(fileName, errorText: string);
    procedure warning(fileName, errorText: string);
    function CompileNA: boolean;
  protected
    procedure AfterCompile(Succeeded: Boolean); overload;
    procedure AfterCompile(Succeeded: Boolean; IsCodeInsight: Boolean); overload;
    procedure AfterCompile(const Project: IOTAProject; Succeeded: Boolean; IsCodeInsight: Boolean); overload;
    procedure BeforeCompile(const Project: IOTAProject; var Cancel: Boolean); overload;
    procedure BeforeCompile(const Project: IOTAProject; IsCodeInsight: Boolean; var Cancel: Boolean); overload;
    procedure FileNotification(NotifyCode: TOTAFileNotification; const FileName: string; var Cancel: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
  end;

procedure Register;
procedure Unregister;
procedure DLLUnload(Reason: Integer);

implementation

uses VA508AccessibilityCompileInfo, VAUtils,
  VA508Classes, VA508AccessibilityPE;

var
  NotifierIndex: Integer = -1;
  NotifierRegistered: boolean = false;
  SaveDllProc: TDLLProc;
  MessageService: IOTAMessageServices;

const
  VA508 = 'VA 508 ';
  MSG_PREFIX = VA508 + 'Compile Scan';
  VA508_SCAN = MSG_PREFIX + ' ';
  VA508_SCAN_MESSAGE_START = VA508_SCAN + '...';
  VA508_SCAN_DONE = VA508_SCAN + 'Complete - ';
  VA508_ACCURACY_DISCALIMER = '  (scan is not accurate if there are unsaved forms)';
  VA508_SCAN_PASSED = VA508_SCAN_DONE + 'No Errors or Warnings Found' + VA508_ACCURACY_DISCALIMER;
  VA508_SCAN_ERROR_COUNT = VA508_SCAN_DONE + '%d Error%s Found'+VA508_ACCURACY_DISCALIMER;
  VA508_SCAN_WARNING_COUNT = VA508_SCAN_DONE + '%d Warning%s Found'+VA508_ACCURACY_DISCALIMER;
  VA508_SCAN_WARNINGS_AND_ERRORS_COUNT = VA508_SCAN_DONE + '%d Warning%s, and %d Error%s Found';
  ERROR_DUPLICATE_COMPONENTS = 'There is more than one %s component on this form';
  ERROR_READ_ONLY_FILE = 'Compile scan can''t automatically correct error because form files are read only.  Please change the read only file status.  ';
  ERROR_CLOSE_FILE_FIRST = 'Compile scan can''t automatically correct error because form %s is currently open in Delphi.  Please close the file in Delphi.  ';
  WARNING_NO_508_DATA = '"%s" has no accessibility data';
  ERROR_INVALID_DFM = 'Form is not a Text DFM or is corrupted';
  ERROR_CODE = '@\*^ERROR^*/@';
  ERROR_CODE_LEN = length(ERROR_CODE);
  WARNING_CODE = '@\*^WARNING^*/@';
  WARNING_CODE_LEN = length(WARNING_CODE);
  INFO_ALERT = ' ***** '; 
  INFO_CODE = '@\*^INFO^*/@';
  INFO_CODE_LEN = length(INFO_CODE);

procedure Register;
{$IFDEF VA508COMPILER}
var
  Services: IOTAServices;
{$ENDIF}  
begin
{$IFDEF VA508COMPILER}
  Services := BorlandIDEServices as IOTAServices;
  NotifierRegistered := Assigned(Services);
  if NotifierRegistered and (NotifierIndex = -1) then
  begin
    NotifierIndex := Services.AddNotifier(TVA508Compiler.Create);
    SaveDllProc := DllProc;
    DllProc := @DLLUnload;
  end;
{$ENDIF}
end;

procedure Unregister;
var
  Services: IOTAServices;
begin
  if NotifierRegistered and (NotifierIndex <> -1) then
  begin
    Services := BorlandIDEServices as IOTAServices;
    if Assigned(Services) then
    begin
      Services.RemoveNotifier(NotifierIndex);
      NotifierIndex := -1;
      NotifierRegistered := false;
    end;
    DllProc := SaveDllProc;
  end;
end;

procedure DLLUnload(Reason: Integer);
begin
  SaveDllProc(Reason);
  if Reason = DLL_PROCESS_DETACH then
    Unregister;
end;

{ TVA508CompileEnforcer }

function HaveMessageServices: boolean;
begin
  MessageService := (BorlandIDEServices as IOTAMessageServices);
  Result := assigned(MessageService);
end;

procedure TVA508Compiler.BeforeCompile(const Project: IOTAProject; IsCodeInsight: Boolean; var Cancel: Boolean);

  function GetPluralStr(count: integer): string;
  begin
    if count = 1 then
      Result := ''
    else
      Result := 's';
  end;

  procedure ShowErrorMessage(msgtxt: string; count: integer);
  begin
    if (count > 0) then
      msg(Format(msgtxt, [count, GetPluralStr(count)]));
  end;

  procedure Do508Scan;
  begin
    startMessages;
    msg(VA508_SCAN_MESSAGE_START);

    ScanFor508Errors(Project);
    
    if F508ManagersFound and F508Problems then
    begin
      if (FWarningCount>0) and (FErrorCount>0) then
        msg(Format(VA508_SCAN_WARNINGS_AND_ERRORS_COUNT, [FWarningCount, GetPluralStr(FWarningCount),
                                                          FErrorCount, GetPluralStr(FErrorCount)]))
      else
      begin
        ShowErrorMessage(VA508_SCAN_WARNING_COUNT, FWarningCount);
        ShowErrorMessage(VA508_SCAN_ERROR_COUNT, FErrorCount);
      end;

      if (FErrorCount > 0 ) then
      begin
        Cancel := TRUE;
        stopMessages;
      end;
    end
    else
      msg(VA508_SCAN_PASSED);
  end;


begin
  if (not IsCodeInsight) and HaveMessageServices then
  begin
    Do508Scan;
  end;
end;


procedure TVA508Compiler.BeforeCompile(const Project: IOTAProject; var Cancel: Boolean);
begin
end;


procedure TVA508Compiler.AfterCompile(Succeeded: Boolean);
begin
end;

procedure TVA508Compiler.AfterCompile(Succeeded, IsCodeInsight: Boolean);
begin
  if not IsCodeInsight then
    stopMessages;
end;

procedure TVA508Compiler.AfterCompile(const Project: IOTAProject; Succeeded,
  IsCodeInsight: Boolean);
begin
  if not IsCodeInsight then
    stopMessages;
end;

function TVA508Compiler.CompileNA: boolean;
begin
  Result := FCompileStopped or (not F508ManagersFound);
end;

constructor TVA508Compiler.Create;
begin
  FOpenFiles := TStringList.Create;
  FOpenFiles.Sorted := TRUE;
  FOpenFiles.Duplicates := dupIgnore;
end;

destructor TVA508Compiler.Destroy;
begin
  FreeAndNil(FOpenFiles);
  inherited;
end;

procedure TVA508Compiler.StopCompile;
begin
  FCompileStopped := true;
end;

procedure TVA508Compiler.startMessages;
begin
  MessageService.ClearCompilerMessages;
  if assigned(FMessageLog) then
    FMessageLog.Clear
  else
    FMessageLog := TStringList.Create;
  FErrorCount := 0;
  FWarningCount := 0;
  FCached := 0;
  FBuilt := 0;
  F508Problems := false;
  F508ManagersFound := false;
  FCompileStopped := false;
  FDFMDataCount := 0;
end;


procedure TVA508Compiler.stopMessages;
var
  i: integer;
  txt: string;
  ptr: pointer;

  function MessageOK(text, code: String; codeLen: integer; Kind: TOTAMessageKind): boolean;
  var
    p: integer;
    FileName: string;
  begin
    if (copy(text,1,codeLen) = code) then
    begin
      Result := FALSE;
      delete(text,1,codeLen);
      p := pos(code, text);
      if (p > 0) then
      begin
        FileName := copy(text, 1, p-1);
        delete(text,1,p + codeLen - 1);
        MessageService.AddCompilerMessage(FileName, text, MSG_PREFIX, Kind, -1, -1, nil, ptr);
        //MessageService.AddToolMessage(FileName, text, prefix, 0, 0);
      end;
    end
    else
      Result := TRUE;
  end;

begin
  if CompileNA then exit;
  if HaveMessageServices and Assigned(FMessageLog) then
  begin
    if FMessageLog.Count > 0 then
      MessageService.ShowMessageView(nil);
    for i := 0 to FMessageLog.Count-1 do
    begin
      txt := FMessageLog[i];
      if MessageOK(txt, ERROR_CODE,   ERROR_CODE_LEN,   otamkError) and
         MessageOK(txt, WARNING_CODE, WARNING_CODE_LEN, otamkWarn) and
         MessageOK(txt, INFO_CODE, INFO_CODE_LEN, otamkInfo) then
        MessageService.AddCompilerMessage('', txt, '', otamkInfo, -1, -1, nil, ptr);
    end;
  end;
  if assigned(FMessageLog) then
    FreeAndNil(FMessageLog);
end;

procedure TVA508Compiler.UpdateMonitor(FileName: String);
begin
  if not FCompileStopped then
    Update508Monitor(ExtractFileName(FileName), FDFMDataCount, FWarningCount, FErrorCount, FCached, FBuilt, F508ManagersFound);
end;

procedure TVA508Compiler.error(fileName, errorText: string);
begin
  if assigned(FMessageLog) then
    FMessageLog.add(ERROR_CODE + fileName + ERROR_CODE + errorText);
  inc(FErrorCount);
  F508Problems := TRUE;
  UpdateMonitor(fileName);
end;

procedure TVA508Compiler.warning(fileName, errorText: string);
begin
  if assigned(FMessageLog) then
    FMessageLog.add(WARNING_CODE + fileName + WARNING_CODE + errorText);
  inc(FWarningCount);
  F508Problems := TRUE;
  UpdateMonitor(fileName);
end;

procedure TVA508Compiler.msg(txt: String);
begin
  if assigned(FMessageLog) then
    FMessageLog.add(txt);
end;

procedure TVA508Compiler.FileNotification(
  NotifyCode: TOTAFileNotification; const FileName: string;
  var Cancel: Boolean);
var
  idx: integer;
begin
  if assigned(FOpenFiles) then
  begin
    case NotifyCode of
      ofnFileOpened: FOpenFiles.Add(FileName);
      ofnFileClosing:
        begin
          idx := FOpenFiles.IndexOf(FileName);
          if idx >= 0 then
            FOpenFiles.Delete(idx);
        end;
    end;
  end;
end;

procedure TVA508Compiler.infoMessage(fileName, infoText: string);
begin
  if assigned(FMessageLog) then
    FMessageLog.add(INFO_CODE + fileName + INFO_CODE + INFO_ALERT + infoText);
  UpdateMonitor(fileName);
end;
{

    Data = ()

  inherited mgrMain: TVA508AccessibilityManager
    Tag = 123
    OnAccessRequest = mgrMainAccessRequest
    Left = 16
    Top = 32
    Data = (
      (
        'Component = Panel1'
        'Label = Label1'
        'Status = stsOK')
      (
        'Component = Button2'
        'Property = Caption'
        'Status = stsOK')
      (
        'Component = Memo1'
        'Status = stsNoData')
      (
        'Component = RadioButton1'
        'Text = Testing'
        'Status = stsOK')
      (
        'Component = Edit1'
        'Status = stsNoTabStop')
      (
        'Component = Form14'
        'Property = Caption'
        'Status = stsOK'))
  end    
}
// needs alot of work but good enough for now...
procedure TVA508Compiler.ScanFor508Errors(const Project: IOTAProject);
const
  CACHE_EXT = '.VA508';
  END_OF_INDEX = '|EOINDEX|';
  OBJ_NAME = 'object ';
  OBJ_NAME_LEN = length(OBJ_NAME);
  INHERITED_NAME = 'inherited ';
  INHERITED_NAME_LEN = length(INHERITED_NAME);

  OBJECT_END = 'end';

  QUOTE = '''';
  ACCESS_DATA_START_MARKER = '(';
  ACCESS_DATA_END_MARKER = ')';

  ACCESS_DATA_BEGIN = VA508DFMDataPropertyName + EQU + ACCESS_DATA_START_MARKER;
  ACCESS_DATA_EMPTY = ACCESS_DATA_BEGIN + ACCESS_DATA_END_MARKER;

  ACCESS_DATA_COMPONENT = QUOTE + AccessDataComponentText + EQU;
  ACCESS_DATA_COMPONENT_LEN = length(ACCESS_DATA_COMPONENT);

  MAX_PASS_COUNT = 20;

var
  resourceIndex: integer;
  dfm: TStringList;
  tracker: TParentChildFormTracker;
  lastValidObjectLineWasInherited, lastManagerWasInherited: boolean;
  lastValidObjectLineClass: string;
  parser: TVA508Parser;
  info: IOTAModuleInfo;
  CurrentFile: string;
  clsManagerName, ErrorStatusText, lastManagerComponentName: string;
  ComponentWarnings: TStringList;
  Working: boolean;
  PassCount: integer;
  EmptyManagerList: TStringList;
  OpenFilesBefore: TStringList;
  Cache: TStringList;
  CacheXRef: TStringList;
  CacheFile: string;
  CacheModified: boolean;
  CacheIndex: integer;
  CacheXRefIndex: integer;
  CacheSize: integer;
  CacheValid: boolean;

  Module: IOTAModule;
  Editor: IOTAEditor;

  procedure IncCacheIndexes(Start, Amount: integer);
  var
    i: integer;
    value: integer;
  begin
    i := start;
    if (i mod 2) <> 0 then
      inc(i);
    while i < CacheXRef.Count do
    begin
      value := integer(CacheXRef.Objects[i]) + Amount;
      CacheXRef.Objects[i] := TObject(value);
      inc(i, 2);
    end;
  end;

  procedure SetCacheSize(amount: integer);
  var
    diff: integer;
  begin
    diff := amount - CacheSize;
    CacheSize := amount;
    CacheXRef.Objects[CacheXRefIndex + 1] := TObject(CacheSize);
    IncCacheIndexes(CacheXRefIndex + 2, diff);
    CacheModified := TRUE;
  end;

  procedure Add2Cache(line: string);
  begin
    if not CacheValid then
    begin
      Cache.Insert(CacheIndex, line);
      inc(CacheIndex);
      SetCacheSize(CacheSize + 1);
    end;
  end;

  function GetDFMFileName(FileName: string): string;
  begin
    Result := copy(FileName,1,Length(FileName)-4) + '.dfm'
  end;

  function ValidObjectLine(line: String): boolean;
  var
    p: integer;
  begin
    lastValidObjectLineClass := '';
    lastValidObjectLineWasInherited := false;
    result := (LeftStr(line,OBJ_NAME_LEN) = OBJ_NAME);
    if not result then
    begin
      result := (LeftStr(line,INHERITED_NAME_LEN) = INHERITED_NAME);
      if result then lastValidObjectLineWasInherited := TRUE;
    end;
    if result then
    begin
      p := pos(':',line);
      if p>0 then
        lastValidObjectLineClass := trim(copy(line,p+1,MaxInt));
    end;
  end;

  procedure ValidateDFM(var wasDFMValid: boolean; var wasDFMInherited: boolean;
                        var FormClassName: string);
  begin
    Add2Cache(dfm[0]);
    wasDFMValid := ValidObjectLine(dfm[0]);
    wasDFMInherited := lastValidObjectLineWasInherited;
    FormClassName := lastValidObjectLineClass;
  end;

  function GetComponentName(line: string): string;
  var
    p,p2: integer;
  begin
    Result := '';
    p := pos(':',line);
    if p>1 then
    begin
      dec(p);
      p2 := p;
      while((p>0) and (line[p]<>' ')) do
        dec(p);
      Result := trim(copy(line,p+1,p2-p));
    end;
  end;

  procedure ClearWarningList(FileName: String);
  var
    idx: integer;
  begin
    idx := ComponentWarnings.IndexOf(FileName);
    if idx >= 0 then
    begin
      ComponentWarnings.Objects[idx].Free;
      ComponentWarnings.Delete(idx);
    end;
  end;

  function GetWarningList(FileName: String): TStringList;
  var
    idx: integer;
  begin
    Result := nil;
    idx := ComponentWarnings.IndexOf(FileName);
    if idx >= 0 then
      Result := TStringList(ComponentWarnings.Objects[idx]);
  end;

  procedure GetManagerInfo(var ManagerCount: integer; var EmptyManager: boolean);
  var
    i: integer;
    InManager, InAccessData, InItem, InError: boolean;
    line, Component: string;
    warnings: TStringList;

  begin
    warnings := GetWarningList(CurrentFile);
    ManagerCount := 0;
    EmptyManager := FALSE;
    InManager := FALSE;
    InAccessData := FALSE;
    InItem := FALSE;
    Component := '';
    InError := FALSE;
    i := 0;
    while i < dfm.count do
    begin
      line := trim(dfm[i]);
      if InManager then
      begin
        Add2Cache(line);
        if InAccessData then
        begin
          if InItem then
          begin
            if RightStr(line,1) = ACCESS_DATA_END_MARKER then
            begin
              InItem := FALSE;
              delete(line, length(line), 1);
            end;
            if RightStr(line,1) = ACCESS_DATA_END_MARKER then
            begin
              InAccessData := FALSE;
              delete(line, length(line), 1);
            end;

            if LeftStr(line, ACCESS_DATA_COMPONENT_LEN) = ACCESS_DATA_COMPONENT then
              Component := copy(line, ACCESS_DATA_COMPONENT_LEN + 1,
                              length(line) - ACCESS_DATA_COMPONENT_LEN - 1)
            else if line = ErrorStatusText then
              InError := TRUE;

            if (not InItem) and InError and (Component <> '') then
            begin
              if not assigned(warnings) then
              begin
                warnings := TStringList.Create;
                ComponentWarnings.AddObject(CurrentFile, warnings);
              end;
              warnings.Add(Component);
            end;
          end
          else
          begin
            if line = ACCESS_DATA_START_MARKER then
            begin
              InItem := TRUE;
              Component := '';
              InError := FALSE;
            end;
          end;
        end
        else
        begin
          if line = ACCESS_DATA_BEGIN then
          begin
            InAccessData := TRUE;
            InItem := FALSE;
          end
          else
          if line = ACCESS_DATA_EMPTY then
          begin
//            if EmptyManagerList.IndexOf(CurrentFile) < 0 then
  //          begin
    //          EmptyManager := TRUE;
      //        EmptyManagerList.Add(CurrentFile);
        //    end;
          end
          else
          if line = OBJECT_END then
            InManager := FALSE;
        end;
      end
      else
      if ValidObjectLine(line) then
      begin
        if lastValidObjectLineClass = clsManagerName then
        begin
          Add2Cache(line);
          lastManagerComponentName := GetComponentName(dfm[i]);
          lastManagerWasInherited := lastValidObjectLineWasInherited;
          inc(ManagerCount);
          if ManagerCount > 1 then exit;
          InManager := TRUE;
        end;
      end;
      inc(i);
    end;
  end;

  procedure ReportComponentWarnings;
  var
    i, j: integer;
    list: TStringList;
    fileName: string;

  begin
    for i := 0 to ComponentWarnings.Count-1 do
    begin
      fileName := ComponentWarnings[i];
      list := TStringList(ComponentWarnings.Objects[i]);
      for j := 0 to List.Count - 1 do
      begin
        warning(fileName, Format(WARNING_NO_508_DATA, [list[j]]));
      end;
    end;
  end;

  procedure InitCache(AFileName: string);
  var
    SR: TSearchRec;
    SRData: string;
    I: integer;

  begin
    try
      if FindFirst(AFileName, faAnyFile, SR) = 0 then
      begin
//        SRData := IntToStr(SR.Size) + '/' + IntToStr(SR.Time);
        SRData := IntToStr(SR.Size) + '/' + DateTimeToStr(SR.TimeStamp);
        CacheXRefIndex := CacheXRef.IndexOf(AFileName);
        if CacheXRefIndex < 0 then
        begin
          inc(FBuilt);
          CacheIndex := Cache.Count;
          CacheSize := 0;
          CacheValid := FALSE;
          CacheXRefIndex := CacheXRef.AddObject(AFileName, TObject(CacheIndex));
          CacheXRef.AddObject(SRData, TObject(CacheSize));
          CacheModified := TRUE;
        end
        else
        begin
          CacheIndex := integer(CacheXRef.Objects[CacheXRefIndex]);
          CacheSize := integer(CacheXRef.Objects[CacheXRefIndex+1]);
          CacheValid := (CacheXRef[CacheXRefIndex+1] = SRData);
          if CacheValid then
            inc(FCached)
          else
          begin
            inc(FBuilt);
            CacheXRef[CacheXRefIndex+1] := SRData;
            for I := 1 to CacheSize do
              Cache.Delete(CacheIndex);
            SetCacheSize(0);
          end;
        end;
        UpdateMonitor(AFileName);
      end;
    finally
      SysUtils.FindClose(SR);
    end;
  end;

  function FileLoaded(AFileName: string; data: TStringList): boolean;
  var
    Temp, I: integer;
  begin
    Result := FALSE;
    try
      if FileExists(AFileName) then
      begin
        InitCache(AFileName);
        data.Clear;
        if CacheValid then
        begin
          Temp := StrToIntDef(Cache[CacheIndex], 0);
          inc(FDFMDataCount, Temp);
          UpdateMonitor(AFileName);
          Result := TRUE;
          for I := 1 to CacheSize-1 do
            data.Add(Cache[CacheIndex+i]);
        end
        else
        begin
          data.LoadFromFile(AFileName);
          Result := data.Count > 0;
          if Result then
          begin
            inc(FDFMDataCount, data.Count);
            Add2Cache(IntToStr(data.Count));
            UpdateMonitor(AFileName);
          end;
        end;
      end;
    except
    end;
  end;

  function DFMSuccessfullyLoaded: boolean;
  begin
    Result := FALSE;
    if assigned(info) then
    begin
      if info.GetModuleType = omtForm then
      begin
        CurrentFile := info.FileName;
        if RightStr(UpperCase(CurrentFile), 4) = '.PAS' then
        begin
          Result := FileLoaded(GetDFMFileName(CurrentFile), dfm);
        end;
      end;
    end;
  end;

  procedure ScanForErrors;
  var
    count: integer;
    wasDFMValid, wasFormInherited, EmptyManager: boolean;
    formClassName: String;
  begin
    lastManagerComponentName := '';
    formClassName := '';
    wasDFMValid := FALSE;
    EmptyManager := false;
    wasFormInherited := FALSE;
    lastManagerWasInherited := FALSE;
    ValidateDFM(wasDFMValid, wasFormInherited, formClassName);
    if wasDFMValid then
    begin
      GetManagerInfo(count, EmptyManager);
      tracker.AddForm(CurrentFile, formClassName, lastManagerComponentName,
                     EmptyManager, wasFormInherited, lastManagerWasInherited);
      if count > 0 then
        F508ManagersFound := true;
      if count > 1 then
      begin
        ClearWarningList(CurrentFile);
        error(CurrentFile, Format(ERROR_DUPLICATE_COMPONENTS, [clsManagerName]));
      end;
    end
    else
      error(CurrentFile, ERROR_INVALID_DFM)
  end;

  procedure ScanFormFiles;
  var
    i: integer;
  begin
    for i := 0 to Project.GetModuleCount-1 do
    begin
      if FCompileStopped then exit;
      info := Project.GetModule(i);
      try
        if DFMSuccessfullyLoaded then
          ScanForErrors;
      finally
        info := nil;
      end;
    end;
  end;

  procedure OpenEditor;
  begin
    if assigned(info) and (info.GetModuleType = omtForm) then
    begin
      module := info.OpenModule;
      if assigned(module) then
      begin
        Editor := Module.CurrentEditor;
      end;
    end;
  end;

  procedure CloseEditor;
  begin
    Editor := nil;
    try
      if OpenFilesBefore.IndexOf(CurrentFile) < 0 then
      begin
        try
          module.CloseModule(TRUE);
        except
        end;
      end;
    finally
      module := nil;
    end;
  end;

  procedure AttemptAutoFix(index: integer; var ErrorText: string);
  var
    data: TFormData;
    code: TParentChildErrorCode;
    buffer: TStringList;
    dfmFile, line: string;

  begin
    code := tracker.ParentChildErrorStatus(index);
    if not (code in TAutoFixFailCodes) then exit;
    data := tracker.GetFormData(index);
    info := Project.FindModuleInfo(data.FileName);
    if not (assigned(info)) then
    begin
      ErrorText := 'Design info not found when attempting autofix.  ';
      exit;
    end;

    OpenEditor;
    try
      if code in [pcNoChildComponent, pcEmptyManagerComponent, pcInheritedNoParent] then
      begin
        Editor.MarkModified;
        Module.Save(FALSE,TRUE);
        Working := TRUE;
        if code = pcInheritedNoParent then
          infoMessage(data.FileName,
            Format('Form %s has been automatically rebuilt to accommodate deletion of parent %s component', [data.FormClassName, clsManagerName]))
        else
          infoMessage(data.FileName,
            Format('Form %s has been automatically rebuilt to accommodate new %s component', [data.FormClassName, clsManagerName]));
      end;
    finally
      CloseEditor;
    end;
    if (ErrorText = '') and (code = pcNoInheritence) then
    begin
      dfmFile := GetDFMFileName(data.FileName);
      try
        buffer := TStringList.Create;
        try
          buffer.LoadFromFile(dfmFile);
          if (buffer.Count > 0) and (LeftStr(buffer[0], OBJ_NAME_LEN) = OBJ_NAME) then
          begin
            line := INHERITED_NAME + copy(buffer[0], OBJ_NAME_LEN + 1, MaxInt);
            buffer[0] := line;
            buffer.SaveToFile(dfmFile);
            Working := TRUE;
            infoMessage(data.FileName, Format('Form %s has been automatically converted to an inherited form', [data.FormClassName]));
          end;
        finally
          buffer.free;
        end;
      except
        on e: Exception do
          ErrorText := 'Error ' + e.Message + ' updating DFM File.  ';
      end;
    end;
  end;

  {$WARNINGS OFF} // Don't care about platform specific warning
  function IsFileReadOnly(FileName: string): boolean;
  begin
    Result := ((FileGetAttr(FileName) and faReadOnly) <> 0);
  end;
  {$WARNINGS ON}

  procedure HandleInheritenceProblems;
  var
    i, j, p: integer;
    data: TFormData;
    parentClass: string;
    code: TParentChildErrorCode;
    ErrorText, BaseError, DFMFile: string;
    ReadOnly: boolean;
    DataString: string;
    DataStrings: TStringList;
    InStream: TStream;
    OutStream: TStream;

  begin
    for i := 0 to tracker.FormCount - 1 do
    begin
      if FCompileStopped then exit;
      data := tracker.GetFormData(i);
      InitCache(data.FileName);
      if CacheValid then
      begin
        DataString := '';
        for j := 0 to CacheSize-1 do
          DataString := DataString + Cache[CacheIndex + j] + #10#13;
        InStream := TStringStream.Create(DataString);
      end
      else
        InStream := nil;
      parentClass := parser.GetParentClassName(data.FormClassName, data.FileName, InStream, OutStream);
      if assigned(OutStream) then
      begin
        try
          if (not CacheValid) then
          begin
            p := parser.LastPosition;
            OutStream.Position := 0;
            DataStrings := TStringList.Create;
            try
              DataString := '';
              SetLength(DataString, p);
              OutStream.ReadBuffer(PChar(DataString)^, p);
              DataStrings.Text := DataString;
              for j := 0 to DataStrings.Count - 1 do
                Add2Cache(DataStrings[j]);
            finally
              DataStrings.free;
            end;
          end;
        finally
          OutStream.Free;
        end;
      end;
      inc(FDFMDataCount, parser.LastLineRead);
      UpdateMonitor(data.FileName);
      tracker.AddLink(parentClass, data.FormClassName);
    end;
    for i := 0 to tracker.FormCount - 1 do
    begin
      if FCompileStopped then exit;
      code := tracker.ParentChildErrorStatus(i);
      if code in TParentChildFailCodes then
      begin
        BaseError := tracker.ParentChildErrorDescription(i);
        data := tracker.GetFormData(i);
        ClearWarningList(data.FileName);
        DFMFile := GetDFMFileName(Data.FileName);
        ErrorText := '';
        if code in TAutoFixFailCodes then
        begin
          ReadOnly := IsFileReadOnly(DFMFile);
          if (not ReadOnly) then
            ReadOnly := IsFileReadOnly(Data.FileName);
          if ReadOnly then
            ErrorText := ERROR_READ_ONLY_FILE + BaseError
          else
          begin
            if (FOpenFiles.IndexOf(Data.FileName) >= 0) or
               (FOpenFiles.IndexOf(DFMFile) >= 0) then
              ErrorText := Format(ERROR_CLOSE_FILE_FIRST + BaseError, [data.FormClassName])
            else
              AttemptAutoFix(i, ErrorText);
          end;
        end
        else
          ErrorText := BaseError;
        if ErrorText <> '' then
          error(DFMFile, ErrorText);
      end;
    end;
  end;

  procedure CloseModules;
  var
    i: integer;
  begin
    for i := 0 to FOpenFiles.Count - 1 do
    begin
      if OpenFilesBefore.IndexOf(FOpenFiles[i]) < 0 then
      begin
        info := Project.FindModuleInfo(FOpenFiles[i]);
        if assigned(info) then
        begin
          try
            module := info.OpenModule;
            if assigned(module) then
            begin
              try
                try
                  module.CloseModule(TRUE);
                except
                end;
              finally
                module := nil;
              end;
            end;
          finally
            info := nil;
          end;
        end;
      end;
    end;
  end;

  procedure LoadCacheFile;
  var
    ProjectName: String;
    i,idx,offset, size: integer;

  begin
    ProjectName := Project.FileName;
    CacheFile := Project.ProjectOptions.Values['UnitOutputDir'];
    if CacheFile = '' then
      CacheFile := ExtractFilePath(ProjectName);
    CacheFile := AppendBackSlash(CacheFile);
    CacheFile := CacheFile + ExtractFileName(ProjectName);
    CacheFile := copy(CacheFile, 1, length(CacheFile) - length(ExtractFileExt(ProjectName))) + CACHE_EXT;
    Cache := TStringList.Create;
    CacheXRef := TStringList.Create;
    if FileExists(CacheFile) then
    begin
      Cache.LoadFromFile(CacheFile);
      idx := Cache.IndexOf(END_OF_INDEX);
      if (idx < 0) or ((idx mod 4) <> 0) then
        Cache.Clear
      else
      begin
        idx := idx div 4;
        for i := 1 to idx do
        begin
          offset := StrToIntDef(Cache[2], -1);
          size := StrToIntDef(Cache[3], -1);
          if (offset < 0) or (size < 0) then // bad file.
          begin
            Cache.Clear;
            CacheXRef.Clear;
            break;
          end;
          CacheXRef.addObject(Cache[0], TObject(offset));
          CacheXRef.addObject(Cache[1], TObject(size));
          Cache.Delete(0);
          Cache.Delete(0);
          Cache.Delete(0);
          Cache.Delete(0);
        end;
        Cache.Delete(0); // deletes END_OF_INDEX line
      end;
    end;
    CacheModified := FALSE;
  end;

  procedure SaveCacheFile;
  var
    CacheIndex, XRefIndex, i: integer;
    offset, size: integer;
    count: integer;

  begin
    if CacheModified then
    begin
      size := Cache.Count + (CacheXRef.Count * 2) + 1;
      if Cache.Capacity < size then
        Cache.Capacity := size;
      Cache.Insert(0, END_OF_INDEX);
      CacheIndex := 0;
      XRefIndex := 0;
      count := CacheXRef.Count div 2;
      for i := 0 to count-1 do
      begin
        offset := Integer(CacheXRef.Objects[XRefIndex]);
        Cache.Insert(CacheIndex, CacheXRef[XRefIndex]);
        inc(CacheIndex);
        inc(XRefIndex);
        size := Integer(CacheXRef.Objects[XRefIndex]);
        Cache.Insert(CacheIndex, CacheXRef[XRefIndex]);
        inc(CacheIndex);
        inc(XRefIndex);
        Cache.Insert(CacheIndex, IntToStr(offset));
        inc(CacheIndex);
        Cache.Insert(CacheIndex, IntToStr(size));
        inc(CacheIndex);
      end;
      Cache.SaveToFile(CacheFile);
    end;
    CacheXRef.Free;
    Cache.Free;
  end;


  procedure CreateResources;
  var
    i: integer;
  begin
    Working := TRUE;
    PassCount := 0;
    resourceIndex := 0;
    clsManagerName := TVA508AccessibilityManager.ClassName;
    ErrorStatusText := QUOTE + AccessDataStatusText + EQU +
                        GetEnumName(TypeInfo(TVA508AccessibilityStatus), Ord(stsNoData)) + QUOTE;
    info := nil;
    Editor := nil;
    module := nil;
    for i := 1 to 6 do
    begin
      case i of
        1: StartMonitor(Project.FileName, StopCompile);
        2: begin
            dfm := TStringList.Create;
            ComponentWarnings := TStringList.Create;
            EmptyManagerList := TStringList.Create;
            OpenFilesBefore := TStringList.Create;
           end;
        3: parser := TVA508Parser.Create;
        4: tracker := TParentChildFormTracker.Create;
        5: OpenFilesBefore.AddStrings(FOpenFiles);
        6: LoadCacheFile;
      end;
      resourceIndex := i;
    end;
  end;

  procedure DestroyResources;
  var
    i: integer;
  begin
    for i := resourceIndex downto 1 do
    begin
      try
        case i of
          6: SaveCacheFile;
          5: CloseModules;
          4: tracker.Free;
          3: parser.Free;
          2: begin
              OpenFilesBefore.Free;
              EmptyManagerList.Free;
              ComponentWarnings.Free;
              dfm.free;
             end;
          1: StopMonitor;
        end;
      except
      end;
    end;
  end;

  procedure Init;
  var
    i: integer;
  begin
    for I := 0 to ComponentWarnings.Count - 1 do
      ComponentWarnings.Objects[i].Free;
    ComponentWarnings.Clear;
    tracker.Clear;
    Working := FALSE;
    inc(PassCount);
  end;

begin
  try
    CreateResources;
    while Working and (passCount < MAX_PASS_COUNT) do
    begin
      Init;
      ScanFormFiles;
      if not CompileNA then
        HandleInheritenceProblems;
    end;
    if not CompileNA then
      ReportComponentWarnings;
  finally

    DestroyResources;
  end;
end;
initialization

finalization
  Unregister;

end.

