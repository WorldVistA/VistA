{******************************************************************************}
{                                                                              }
{       GMV_VitalsViewEnter                                                    }
{                                                                              }
{       Updated Version information to be pulled from the actual file          }
{       ZZZZZZBELLC 1/27/2015                                                  }
{******************************************************************************}


unit uGMV_VersionInfo;
interface

uses Windows,
  SysUtils,
  Classes,
  Graphics,
  Forms,
  Controls,
  StdCtrls,
  Buttons,
  ExtCtrls,
  uGMV_Common
  ;

const
  VersionInfoKeys: array[1..13] of string = (
    'CompanyName',
    'FileDescription',
    'FileVersion',
    'InternalName',
    'LegalCopyRight',
    'OriginalFileName',
    'ProductName',
    'ProductVersion',
    'Comments',
    'VAReleaseDate',
    'VANamespace',
    'VASourceInformation',
    'PreviousVersion'// ZZZZZZBELLC 1/27/2015
    );

  USEnglish = $040904E4;

type
  TVersionInfo = class(TComponent)
    (*
      Retrieves Version Info data about a given binary file.
    *)
  private
    FFileName: string;
    FLanguageID: DWord;
    FInfo: pointer;
    FInfoSize: longint;

    FCtlCompanyName: TControl;
    FCtlFileDescription: TControl;
    FCtlFileVersion: TControl;
    FCtlInternalName: TControl;
    FCtlLegalCopyRight: TControl;
    FCtlOriginalFileName: TControl;
    FCtlProductName: TControl;
    FCtlProductVersion: TControl;
    FCtlComments: TControl;
    FCtlVAReleaseDate: TControl;
    FCtlVANamespace: TControl;
    FCtlVASourceInformation: TControl;

    procedure SetFileName(Value: string);
    procedure SetVerProp(index: Integer; value: TControl);
    function GetVerProp(index: Integer): TControl;
    function GetIndexKey(index: Integer): string;
//    function GetKey(const KName: string): string;
    function GetCompileDateTime: TDateTime;
    function GetVAPatchNumber: string;
    function GetVAServerVersion: string;
    function GetVATestVersion: Boolean;
    procedure Refresh;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    InternalVersion:String;

    function GetKey(const KName: string): string;

    property FileName: string read FFileName write SetFileName;
    property LanguageID: DWord read FLanguageID write FLanguageID;
    property CompileDateTime: TDateTime read GetCompileDateTime;

    property CompanyName: string index 1 read GetIndexKey;
    property FileDescription: string index 2 read GetIndexKey;
    property FileVersion: string index 3 read GetIndexKey;
    property InternalName: string index 4 read GetIndexKey;
    property LegalCopyRight: string index 5 read GetIndexKey;
    property OriginalFileName: string index 6 read GetIndexKey;
    property ProductName: string index 7 read GetIndexKey;
    property ProductVersion: string index 8 read GetIndexKey;
    property Comments: string index 9 read GetIndexKey;
    property VAReleaseDate: string index 10 read GetIndexKey;
    property VANamespace: string index 11 read GetIndexKey;
    property VASourceInformation: string index 12 read GetIndexKey;//AAN 08/05/2002
    property PreviousVersion: string index 13 read GetIndexKey; // ZZZZZZBELLC 1/27/2015
    property VAPatchNumber: string read GetVAPatchNumber;
    property VAServerVersion: string read GetVAServerVersion;
    property VATestVersion: Boolean read GetVATestVersion;

    constructor Create(AOwner: TComponent); override;
    (*
      Allocates memory and initializes variables for the object.
    *)

    destructor Destroy; override;
    (*
      Releases all memory allocated for the object.
    *)

    procedure OpenFile(FName: string);
    (*
      Uses method GetFileVersionInfo to retrieve version information for file
      FName.  If FName is blank, version information is obtained for the
      current executable (Application.ExeName).
    *)

    procedure Close;
    (*
      Releases memory allocated and clears all storage variables.
    *)

  published
    property CtlCompanyName: TControl index 1 read GetVerProp write SetVerProp;
    property CtlFileDescription: TControl index 2 read GetVerProp write SetVerProp;
    property CtlFileVersion: TControl index 3 read GetVerProp write SetVerProp;
    property CtlInternalName: TControl index 4 read GetVerProp write SetVerProp;
    property CtlLegalCopyRight: TControl index 5 read GetVerProp write SetVerProp;
    property CtlOriginalFileName: TControl index 6 read GetVerProp write SetVerProp;
    property CtlProductName: TControl index 7 read GetVerProp write SetVerProp;
    property CtlProductVersion: TControl index 8 read GetVerProp write SetVerProp;
    property CtlComments: TControl index 9 read GetVerProp write SetVerProp;
    property CtlVAReleaseDate: TControl index 10 read GetVerProp write SetVerProp;
    property CtlVANamespace: TControl index 11 read GetVerProp write SetVerProp;
    property CtlVASourceInfo: TControl index 12 read GetVerProp write SetVerProp;
  end;

function CurrentExeNameAndVersion: string;
function RequiredServerVersion: string;

function CurrentDllNameAndVersion: string;
function PrevDllNameAndVersion: string;

implementation

uses
  Dialogs
  , TypInfo
  , uGMV_Const
  ;

function RequiredServerVersion: string;
begin
  with TVersionInfo.Create(Application) do
    try
      OpenFile(Application.ExeName);
      Result := VAServerVersion;
      if VAPatchNumber <> '' then
        Result := Result + ' with patch ' + VAPatchNumber;
    finally
      free;
    end;
end;

function CurrentExeNameAndVersion: string;
begin
  with TVersionInfo.Create(Application) do
    try
      OpenFile(Application.ExeName);
{$IFDEF IGNOREEXENAME}
      Result := UpperCase('Vitals.exe:' + FileVersion);
{$ELSE}
      Result := UpperCase(ExtractFileName(Application.ExeName) + ':' + FileVersion);
{$ENDIF}
    finally
      free;
    end;
end;

function PrevDllNameAndVersion: string;
begin
//  Result := 'GMV_VITALSVIEWENTER.DLL:v. 09/06/05 11:29';  // Max-Min error corrected
//  Result := 'GMV_VITALSVIEWENTER.DLL:v. 09/22/05 11:43';
//  Result := 'GMV_VITALSVIEWENTER.DLL:v. 10/18/05 10:50';  // T12
//  Result := 'GMV_VITALSVIEWENTER.DLL:v. 11/03/05 11:47';
//  Result := 'GMV_VITALSVIEWENTER.DLL:v. 11/21/05 15:53';  //T14
//  Result := 'GMV_VITALSVIEWENTER.DLL:v. 11/30/05 18:00';  //T15
//  Result := 'GMV_VITALSVIEWENTER.DLL:v. 12/29/05 16:20';  //T16
//  Result := 'GMV_VITALSVIEWENTER.DLL:v. 01/20/06 09:08';  //T17
//  Result := 'GMV_VITALSVIEWENTER.DLL:v. 02/15/06 15:55';  //T18
//  Result := 'GMV_VITALSVIEWENTER.DLL:v. 10/04/07 16:52';  //T22 - was not released only tested
//  Result := 'GMV_VITALSVIEWENTER.DLL:v. 01/03/08 11:04';  //T22.2
{$IFDEF PATCH_5_0_22}  Result := 'GMV_VITALSVIEWENTER.DLL:v. 03/14/06 16:35';{$ENDIF}
//{ $IFDEF PATCH_5_0_23 }  Result := 'DUMMY';{$ENDIF} // T23.1
// Patch 23 does not support any previous versions of dll
//{ $IFDEF PATCH_5_0_23}  Result := 'GMV_VITALSVIEWENTER.DLL:v. 10/14/08 15:42';{$ENDIF} // T23.4
//{$IFDEF PATCH_5_0_23}  Result := 'GMV_VITALSVIEWENTER.DLL:v. 01/20/09 16:30'; {$ENDIF} //T23.5
//{$IFDEF PATCH_5_0_23}  Result := 'GMV_VITALSVIEWENTER.DLL:v. 08/11/09 15:00'; {$ENDIF} //T23.8
{$IFDEF PATCH_5_0_23}  Result := 'GMV_VITALSVIEWENTER.DLL:v. 01/21/11 12:52'; {$ENDIF} //T26.1
end;

function CurrentDllNameAndVersion: string;
begin
//  Result := 'GMV_VITALSVIEWENTER.DLL:v. 09/22/05 11:43';  // Max-Min error corrected
//  Result := 'GMV_VITALSVIEWENTER.DLL:v. 10/18/05 10:50';
//  Result := 'GMV_VITALSVIEWENTER.DLL:v. 11/03/05 11:47';  //T13
//  Result := 'GMV_VITALSVIEWENTER.DLL:v. 11/21/05 15:53';  //T14
//  Result := 'GMV_VITALSVIEWENTER.DLL:v. 11/30/05 18:00';  //T15
//  Result := 'GMV_VITALSVIEWENTER.DLL:v. 12/29/05 16:20';  //T16
//  Result := 'GMV_VITALSVIEWENTER.DLL:v. 01/20/06 09:08';  //T17
//  Result := 'GMV_VITALSVIEWENTER.DLL:v. 02/15/06 15:55';  //T18 - ignores CCOW Cancel patient change
//  Result := 'GMV_VITALSVIEWENTER.DLL:v. 03/14/06 16:35';  //T19
//  Result := 'GMV_VITALSVIEWENTER.DLL:v. 10/04/07 16:52';  //T22 - was not released only tested
//  Result := 'GMV_VITALSVIEWENTER.DLL:v. 01/03/08 11:04';  //T22.2 - was notreleased
//{ $IFDEF PATCH_5_0_22}  Result := 'GMV_VITALSVIEWENTER.DLL:v. 05/12/08 08:44'; {$ENDIF} //T22.6
//{ $IFDEF PATCH_5_0_23}  Result := 'GMV_VITALSVIEWENTER.DLL:v. 05/13/08 09:27'; {$ENDIF} //T23.1
//{$IFDEF PATCH_5_0_23}  Result := 'GMV_VITALSVIEWENTER.DLL:v. 04/07/09 16:30'; {$ENDIF} //T23.7
//{$IFDEF PATCH_5_0_23}  Result := 'GMV_VITALSVIEWENTER.DLL:v. 08/11/09 15:00'; {$ENDIF} //T23.8
{$IFDEF PATCH_5_0_23}  Result := 'GMV_VITALSVIEWENTER.DLL:v. 11/05/13 10:00'; {$ENDIF} //T28.1
end;

(*=== TVersionInfo Methods ==================================================*)

constructor TVersionInfo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLanguageID := USEnglish;
{$IFDEF DLL}
  SetFileName('GMV_VitalsViewEnter.dll');
{$ELSE}
  SetFileName(EmptyStr);
{$ENDIF}

end;

destructor TVersionInfo.Destroy;
begin
  if FInfoSize > 0 then
    FreeMem(FInfo, FInfoSize);
  inherited Destroy;
end;

procedure TVersionInfo.SetFileName(Value: string);
begin
  FFileName := Value;
  if Value = EmptyStr then
    FFileName := ExtractFileName(Application.ExeName);
  if csDesigning in ComponentState then
    Refresh
  else
    OpenFile(Value);
end;

procedure TVersionInfo.OpenFile(FName: string);
var
  vlen: DWord;
begin
  if FInfoSize > 0 then
    FreeMem(FInfo, FInfoSize);
  if Length(FName) <= 0 then
    FName := Application.ExeName;
  FInfoSize := GetFileVersionInfoSize(pchar(fname), vlen);
  if FInfoSize > 0 then
    begin
      GetMem(FInfo, FInfoSize);
      if not GetFileVersionInfo(pchar(fname), vlen, FInfoSize, FInfo) then
        raise Exception.Create('Cannot retrieve Version Information for ' + fname);
      Refresh;
    end;
end;

procedure TVersionInfo.Close;
begin
  if FInfoSize > 0 then
    FreeMem(FInfo, FInfoSize);
  FInfoSize := 0;
  FFileName := EmptyStr;
end;

const
  vqvFmt = '\StringFileInfo\%8.8x\%s';

function TVersionInfo.GetKey(const KName: string): string;
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

function TVersionInfo.GetIndexKey(index: Integer): string;
begin
  Result := GetKey(VersionInfoKeys[index]);
end;

function TVersionInfo.GetVerProp(index: Integer): TControl;
begin
  case index of
    1: Result := FCtlCompanyName;
    2: Result := FCtlFileDescription;
    3: Result := FCtlFileVersion;
    4: Result := FCtlInternalName;
    5: Result := FCtlLegalCopyRight;
    6: Result := FCtlOriginalFileName;
    7: Result := FCtlProductName;
    8: Result := FCtlProductVersion;
    9: Result := FCtlComments;
    10: Result := FCtlVAReleaseDate;
    11: Result := FCtlVANamespace;
    12: Result := FCtlVASourceInformation;
  else
    Result := nil;
  end;
end;

procedure TVersionInfo.SetVerProp(index: Integer; value: TControl);
begin
  case index of
    1: FCtlCompanyName := Value;
    2: FCtlFileDescription := Value;
    3: FCtlFileVersion := Value;
    4: FCtlInternalName := Value;
    5: FCtlLegalCopyRight := Value;
    6: FCtlOriginalFileName := Value;
    7: FCtlProductName := Value;
    8: FCtlProductVersion := Value;
    9: FCtlComments := Value;
    10: FCtlVAReleaseDate := Value;
    11: FCtlVANamespace := Value;
    12: FCtlVASourceInformation := Value;
  end;
  Refresh;
end;

procedure TVersionInfo.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if Operation = opRemove then
    begin
      if AComponent = FCtlCompanyName then
        FCtlCompanyName := nil
      else if AComponent = FCtlFileDescription then
        FCtlFileDescription := nil
      else if AComponent = FCtlFileVersion then
        FCtlFileVersion := nil
      else if AComponent = FCtlInternalName then
        FCtlInternalName := nil
      else if AComponent = FCtlLegalCopyRight then
        FCtlLegalCopyRight := nil
      else if AComponent = FCtlOriginalFileName then
        FCtlOriginalFileName := nil
      else if AComponent = FCtlProductName then
        FCtlProductName := nil
      else if AComponent = FCtlProductVersion then
        FCtlProductVersion := nil
      else if AComponent = FCtlComments then
        FCtlComments := nil
      else if AComponent = FCtlVAReleaseDate then
        FCtlVAReleaseDate := nil
      else if AComponent = FCtlVANamespace then
        FCtlVANamespace := nil
      else if AComponent = FCtlVASourceInformation then
        FCtlVASourceInformation := nil;
    end;
end;

procedure TVersionInfo.Refresh;
var
  PropInfo: PPropInfo;

  procedure AssignText(Actl: TComponent; txt: string);
  begin
    if Assigned(ACtl) then
      begin
        PropInfo := GetPropInfo(ACtl.ClassInfo, 'Caption');
        if PropInfo <> nil then
          SetStrProp(ACtl, PropInfo, txt)
        else
          begin
            PropInfo := GetPropInfo(ACtl.ClassInfo, 'Text');
            if PropInfo <> nil then
              SetStrProp(ACtl, PropInfo, txt)
          end;
      end;
  end;

begin
  if csDesigning in ComponentState then
    begin
      AssignText(FCtlCompanyName, VersionInfoKeys[1]);
      AssignText(FCtlFileDescription, VersionInfoKeys[2]);
      AssignText(FCtlFileVersion, VersionInfoKeys[3]);
      AssignText(FCtlInternalName, VersionInfoKeys[4]);
      AssignText(FCtlLegalCopyRight, VersionInfoKeys[5]);
      AssignText(FCtlOriginalFileName, VersionInfoKeys[6]);
      AssignText(FCtlProductName, VersionInfoKeys[7]);
      AssignText(FCtlProductVersion, VersionInfoKeys[8]);
      AssignText(FCtlComments, VersionInfoKeys[9]);
      AssignText(FCtlVAReleaseDate, VersionInfoKeys[10]);
      AssignText(FCtlVANamespace, VersionInfoKeys[11]);
      AssignText(FCtlVASourceInformation, VersionInfoKeys[12]);
    end
  else
    begin
      AssignText(FCtlCompanyName, CompanyName);
      AssignText(FCtlFileDescription, FileDescription);
      AssignText(FCtlFileVersion, FileVersion);
      AssignText(FCtlInternalName, InternalName);
      AssignText(FCtlLegalCopyRight, LegalCopyRight);
      AssignText(FCtlOriginalFileName, OriginalFileName);
      AssignText(FCtlProductName, ProductName);
      AssignText(FCtlProductVersion, ProductVersion);
      AssignText(FCtlComments, Comments);
      AssignText(FCtlVAReleaseDate, VAReleaseDate);
      AssignText(FCtlVANamespace, VANamespace);
      AssignText(FCtlVASourceInformation, VASourceInformation);
    end;
end;

function TVersionInfo.GetCompileDateTime: TDateTime;
begin
{$IFDEF DLL}
   FileAge(GetModuleName(HInstance), Result);
 // FileAge(GetProgramFilesPath+'\Vista\Common Files\GMV_VitalsViewEnter.dll', Result);
 // Result := FileDateToDateTime(FileAge(GetProgramFilesPath+'\Vista\Common Files\GMV_VitalsViewEnter.dll'));
{$ELSE}
  FileAge(Application.ExeName, Result);
 // Result := FileDateToDateTime(FileAge(Application.ExeName));
{$ENDIF}
end;

function TVersionInfo.GetVAPatchNumber: string;
begin
  if StrToIntDef(Piece(FileVersion, '.', 3), 0) > 0 then
    begin
      Result := VANamespace + '*' + VAServerVersion + '*' + Piece(FileVersion, '.', 3);
//      if StrToIntDef(Piece(FileVersion, '.', 4), 0) > 0 then // zzzzzzandria 060223
//        Result := Result + 'T' + Piece(FileVersion, '.', 4); // zzzzzzandria 060223
//      Result := 'GMRV*5.0*3T7'; // 6
//      Result := 'GMRV*5.0*3T8'; // 7
//      Result := 'GMRV*5.0*3T9'; // 8
//      Result := 'GMRV*5.0*3T12';
//      Result := 'GMRV*5.0*3T13';
//      Result := 'GMRV*5.0*3T14';
//      Result := 'GMRV*5.0*3T16';
//      Result := 'GMRV*5.0*3T17';
//      Result := 'GMRV*5.0*3T18'; // zzzzzzandria 060223
    end
  else
    Result := '';
end;

function TVersionInfo.GetVAServerVersion: string;
begin
  Result := Piece(FileVersion, '.', 1) +  '.' + Piece(FileVersion, '.', 2);
end;

function TVersionInfo.GetVATestVersion: Boolean;
begin
  Result := False;
end;

end.
