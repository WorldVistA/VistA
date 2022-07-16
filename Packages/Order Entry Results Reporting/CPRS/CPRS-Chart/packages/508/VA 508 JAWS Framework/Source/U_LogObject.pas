unit U_LogObject;

interface

uses
  Classes, System.SyncObjs, Winapi.Windows, SysUtils,
  System.DateUtils, Vcl.Forms, Winapi.SHFolder;

type

  ILoggerInterface = interface(IInterface)
    ['{076BB521-F79C-4991-A5E8-3F50CE0E1CA2}']
    Function GetLogFileName(): String;
    procedure SetActive(aValue: Boolean);
    Function GetActive: Boolean;

    procedure LogText(Action, MessageTxt: String);
    property LogFile: String read GetLogFileName;
    Property Active: Boolean read GetActive write SetActive;
  end;

  TLogComponent = class(TInterfacedObject, ILoggerInterface)
  private
    FCriticalSection: TCriticalSection;
    fOurLogFile: String;
    fActive: Boolean;
    procedure SetActive(aValue: Boolean);
    Function GetActive: Boolean;
    Function GetLogFileName(): String;
    Function ThePurge: String;
    Function RightPad(S: string; ch: char; Len: Integer): string;
  public
    constructor Create();
    destructor Destroy; override;
    procedure LogText(Action, MessageTxt: String);
    property LogFile: String read GetLogFileName;
    Property Active: Boolean read GetActive write SetActive;
  end;

function LogInterface: ILoggerInterface;

implementation

var
  fLogInterface: ILoggerInterface;

function LogInterface: ILoggerInterface;
begin
  if not Assigned(fLogInterface) then
    TLogComponent.Create.GetInterface(ILoggerInterface, fLogInterface);

  fLogInterface.QueryInterface(ILoggerInterface, Result);
end;

constructor TLogComponent.Create();
begin
  inherited Create();
  FCriticalSection := TCriticalSection.Create;
end;

destructor TLogComponent.Destroy;
begin
  FCriticalSection.Free;
  inherited Destroy;
end;

function TLogComponent.GetLogFileName(): String;
Var
  OurLogFile, LocalOnly, AppDir, AppName: string;

  // ******************************************************************
  // Finds the users special directory
  // ******************************************************************
  function LocalAppDataPath: string;
  const
    SHGFP_TYPE_CURRENT = 0;
  var
    path: array [0 .. MAX_PATH] of char;
  begin
    SHGetFolderPath(0, CSIDL_LOCAL_APPDATA, 0, SHGFP_TYPE_CURRENT, @path[0]);
    Result := StrPas(path);
  end;

begin
  if Trim(fOurLogFile) <> '' then
    Result := fOurLogFile
  else
  begin
    OurLogFile := LocalAppDataPath;
    if (Copy(OurLogFile, Length(OurLogFile), 1) <> '\') then
      OurLogFile := OurLogFile + '\';

    LocalOnly := OurLogFile;

    // Now set the application level
    OurLogFile := OurLogFile + ExtractFileName(Application.ExeName);
    if (Copy(OurLogFile, Length(OurLogFile), 1) <> '\') then
      OurLogFile := OurLogFile + '\';
    AppDir := OurLogFile;

    // try to create or use base direcrtory
    if not DirectoryExists(AppDir) then
      if not ForceDirectories(AppDir) then
        OurLogFile := LocalOnly;

    // Get the application name
    AppName := ExtractFileName(Application.ExeName);
    AppName := Copy(AppName, 0, Pos('.', AppName) - 1);

    OurLogFile := OurLogFile + AppName + '_' + IntToStr(GetCurrentProcessID) +
      '_' + FormatDateTime('mm_dd_yy_hh_mm', now) + '_JawsLog.TXT';

    fOurLogFile := OurLogFile;
    Result := OurLogFile;
  end;
end;

procedure TLogComponent.LogText(Action, MessageTxt: string);
const
  PadLen: Integer = 18;
VAR
  AddText: TStringList;
  X: Integer;
  TextToAdd, Suffix, Suffix2: String;
  myFile: TextFile;
begin
  if not fActive then
    exit;
  Action := RightPad(Action, ' ', 11);
  FCriticalSection.Acquire;
  try
    // Clean the old dir on first run
    if Trim(fOurLogFile) = '' then
      TextToAdd := ThePurge + TextToAdd;

    // This should never be blank
    if fOurLogFile = '' then
      fOurLogFile := GetLogFileName;

    if Trim(fOurLogFile) = '' then
      fOurLogFile := GetLogFileName;

    AddText := TStringList.Create;
    try
      AddText.Text := MessageTxt;

      Suffix := FormatDateTime('hh:mm:ss', now) + ' [' +
        UpperCase(Action) + ']';
      if AddText.Count > 1 then
      begin
        Suffix2 := FormatDateTime('hh:mm:ss', now) + ' [' +
          StringOfChar('^', Length(Action)) + ']';
        for X := 1 to AddText.Count - 1 do
          AddText.Strings[X] := Suffix2.PadRight(PadLen) + ' - ' +
            AddText.Strings[X];
      end;

      TextToAdd := Suffix.PadRight(PadLen) + ' - ' + Trim(AddText.Text);

      // Asign our file
      AssignFile(myFile, fOurLogFile);
      if FileExists(fOurLogFile) then
        Append(myFile)
      else
        ReWrite(myFile);

      // Write this final line
      WriteLn(myFile, TextToAdd);

      CloseFile(myFile);
    finally
      AddText.Free;
    end;
  finally
    FCriticalSection.Release;
  end;
end;

Function TLogComponent.ThePurge: String;
const
  aFileMask = '*_JawsLog.txt';
var
  searchResult: TSearchRec;
  iDelCnt, iErrorCnt, iFile: Integer;
  dtFileDate, dtNow: TDateTime;
  sFilePath: string;
begin
  // Init variables
  iDelCnt := 0;
  iErrorCnt := 0;
  dtNow := Date;
  sFilePath := ExtractFilePath(GetLogFileName);

  // Loop through dir looking for the files
  iFile := FindFirst(sFilePath + aFileMask, faAnyFile, searchResult);
  while iFile = 0 do
  begin
    // Make sure we are on a file and not a directory
    if (searchResult.Name <> '.') and (searchResult.Name <> '..') and
      ((searchResult.Attr and faDirectory) <> faDirectory) then
    begin
      // Check the date of the file
{$IFDEF VER180}
      dtFileDate := searchResult.Time;
{$ELSE}
      dtFileDate := searchResult.TimeStamp;
{$ENDIF}
      if trunc(dtNow - dtFileDate) + 1 > 60 then
      begin
        // Try to delete and update the count as needed
        if not SysUtils.DeleteFile(sFilePath + searchResult.Name) then
          Inc(iErrorCnt)
        else
          Inc(iDelCnt);
      end;
    end;
    // Grab the next file
    iFile := FindNext(searchResult);
  end;
  // Free up memory allocation
  SysUtils.FindClose(searchResult);

  // If any files were purged or errored then add this to the return message
  if (iErrorCnt > 0) or (iDelCnt > 0) then
  begin
    Result := (StringOfChar(' ', 15) + 'Log Purge Information');
    Result := Result + #13#10 + (RightPad('', '=', 50));
    Result := Result + #13#10 + (RightPad('Days', ' ', 10) + ': ' +
      IntToStr(60));
    Result := Result + #13#10 + (RightPad('Purged', ' ', 10) + ': ' +
      IntToStr(iDelCnt));
    Result := Result + #13#10 + (RightPad('NA', ' ', 10) + ': ' +
      IntToStr(iErrorCnt));
    Result := Result + #13#10 + #13#10;
  end
  else
    Result := '';
end;

function TLogComponent.RightPad(S: string; ch: char; Len: Integer): string;
var
  RestLen: Integer;
begin
  Result := S;
  RestLen := Len - Length(S);
  if RestLen < 1 then
    exit;
  Result := S + StringOfChar(ch, RestLen);
end;

procedure TLogComponent.SetActive(aValue: Boolean);
begin
  fActive := aValue;
end;

Function TLogComponent.GetActive: Boolean;
begin
  Result := fActive;
end;

end.
