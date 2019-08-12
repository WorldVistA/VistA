unit uGMV_VersionInfo;

interface
uses
  Classes
  , SysUtils
  , Windows
  ;

type
  TGMV_VersionInfo = class(TObject)
  private
    FFileName: string;
    FLanguageID: DWord;
    FInfo: pointer;
    FInfoSize: longint;
    procedure SetFileName(Value: string);
    procedure OpenFile(FName: string);
    procedure Close;
  public
    constructor Create;
    destructor Destroy; override;
    function GetKey(const KName: string): string;
  end;


const
  USEnglish = $040904E4;
  vqvFmt = '\StringFileInfo\%8.8x\%s';

function getExeNameVersion: String;

implementation

//sFileName := GetModuleName(HInstance); // returns the Dll name
//sFileName := GetModuleName(0); // returns the Exe name

function getExeNameVersion: String;
begin
  with TGMV_VersionInfo.Create do
    try
      Result := UpperCase(fFileName + ':' + getKey('FileVersion'));
    finally
      free;
    end;
end;

////////////////////////////////////////////////////////////////////////////////

constructor TGMV_VersionInfo.Create;
begin
  inherited Create;
  FLanguageID := USEnglish;
  SetFileName(EmptyStr);
end;

destructor TGMV_VersionInfo.Destroy;
begin
  if FInfoSize > 0 then
    FreeMem(FInfo, FInfoSize);
  inherited Destroy;
end;

procedure TGMV_VersionInfo.OpenFile(FName: string);
var
  vlen: DWord;
begin
  if FInfoSize > 0 then
    FreeMem(FInfo, FInfoSize);
  if Length(FName) <= 0 then
    FName := GetModuleName(0); //Application.ExeName;
  FInfoSize := GetFileVersionInfoSize(pchar(fname), vlen);
  if FInfoSize > 0 then
    begin
      GetMem(FInfo, FInfoSize);
      if not GetFileVersionInfo(pchar(fname), vlen, FInfoSize, FInfo) then
        raise Exception.Create('Cannot retrieve Version Information for ' + fname);
    end;
end;

procedure TGMV_VersionInfo.SetFileName(Value: string);
begin
  FFileName := Value;
  if Value = EmptyStr then
    FFileName := ExtractFileName(GetModuleName(0));
  OpenFile(Value);
end;

procedure TGMV_VersionInfo.Close;
begin
  if FInfoSize > 0 then
    FreeMem(FInfo, FInfoSize);
  FInfoSize := 0;
  FFileName := EmptyStr;
end;

function TGMV_VersionInfo.GetKey(const KName: string): string;
var
  vptr: pchar;
  vlen: DWord;
begin
  Result := EmptyStr;
  if FInfoSize <= 0 then
    exit;
  if VerQueryValue(FInfo, pchar(Format(vqvFmt, [FLanguageID, KName])), pointer(vptr), vlen) then
    Result := vptr;
end;

end.
