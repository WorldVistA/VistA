unit uGMV_User;

interface

uses
  SysUtils
  ,Classes
  ,Dialogs
  ,Forms
  ,StdCtrls
  ,Controls
  ;

type
  TGMV_UserSetting = (
    usCanvasAbnormal,
    usCanvasNormal,
    usPtSelectorType,
    usPtSelectorIndex,
    usLastVistAPrinter,
    usGridDateRange,
    usDefaultTemplate
    ,usMetricStyle
    ,usTemplateTree
    ,usLastVitals
    ,usParamTreeWidth
    ,usPatientListHeight
    ,usLastVitalsListHeight
    ,usPOPBoxes
    ,usGraph
    ,usSearchDelay
    ,usTemplate
    ,usGridDateFrom
    ,usGridDateTo
    ,usOneUnavailableBox
//    ,usCloseInputWindowAfterSave
    );

  TGMV_User = class(TObject)
  private
    FByPassCRCCheck: Boolean;
    FDTime: integer;
    FDUZ: string;
    FSignOnDt: TDateTime;
    FName: string;
    FDomainIEN: string;
    FDomain: string;
    FDivisionIEN: string;
    FDivision: string;
    FGMVManager: Boolean;
    FTitle: string;
    FConfirmAppClose: Boolean;
    FHelpFileDirectory: string;

    FVASite: string;//2003-10-24 AAN

    function GetSetting(Name: TGMV_UserSetting): string;
    procedure SetSetting(Name: TGMV_UserSetting; const Value: string);
  public
    constructor Create;
    destructor Destroy; override;
    procedure SetupUser;
    procedure SetupSignOnParams;
    function SignOn(Context: string; BypassOffline: Boolean): Boolean;
    function CreateContext(Context: string): Boolean;
    function SignOff: Boolean;
    property Setting[Name: TGMV_UserSetting]: string read GetSetting write SetSetting;
//  published
    { Published declarations }
    property DTime: integer read FDTime;
    property ByPassCRCCheck: Boolean read FByPassCRCCheck default False;
    property DUZ: string read FDUZ;
    property SignOnDateTime: TDateTime read FSignOnDt;
    property Name: string read FName;
    property DomainIEN: string read FDomainIEN;
    property Domain: string read FDomain;
    property DivisionIEN: string read FDivisionIEN;
    property Division: string read FDivision;
    property GMVManager: Boolean read FGMVManager;
    property Title: string read FTitle;
    property ConfirmAppClose: Boolean read FConfirmAppClose write FConfirmAppClose;
    property HelpFileDirectory: string read FHelpFileDirectory;
    property VASite: string read FVASite;
  end;

var  GMVUser: TGMV_User;

const
  GMVUSERSETTING: array[TGMV_UserSetting] of string = (
       'CanvasAbnormal', 'CanvasNormal'
      ,'PtSelectorType', 'PtSelectorIndex', 'LastVistAPrinter', 'GridDateRange', 'DefaultTemplate'
      ,'CPRSMetricStyle','ShowTemplates','ShowLastVitals','ParamTreeWidth','PatientListHeight'
      ,'LastVitalsListHeight','ShowPOPBoxes','Graph','SearchDelay','Template','GridDateFrom','GridDateTo' //AAn 08/02/2002
      ,'OneUnavailableBox'
//      ,'CloseInputWindowAfterSave'
      );


implementation

uses
  uGMV_GlobalVars
  , uGMV_Common
  , uGMV_VersionInfo
  , uGMV_FileEntry
  , uGMV_Const
  , uGMV_EXEVersion
  , uGMV_Engine
  , System.UITypes;

{ TMDTUser }

constructor TGMV_User.Create;
begin
  inherited Create;
  FDUZ := '';
  FName := '';
  FTitle := '';
  FDivisionIEN := '';
  FDivision := '';
end;

destructor TGMV_User.Destroy;
begin
  inherited Destroy;
end;

procedure TGMV_User.SetupUser;
var
  UserParameter: string;
begin
  UserParameter := getUserparameter;

  GMVAllowUserTemplates := (Copy(UserParameter, 1, 1) = 'Y');

  // Apply user settings here for the initial startup
  UserParameter := Setting[usCanvasNormal];
  if UserParameter <> '' then
    begin
      GMVNormalBkgd := StrToIntDef(Piece(UserParameter, ';', 1), GMVNormalBkgd);
      GMVNormalTodayBkgd := StrToIntDef(Piece(UserParameter, ';', 5), GMVNormalTodayBkgd);
      GMVNormalText := StrToIntDef(Piece(UserParameter, ';', 2), GMVNormalText);
      GMVNormalBold := (Piece(UserParameter, ';', 3) = '1');
      GMVNormalQuals := (Piece(UserParameter, ';', 4) = '1');

      GMVInquiryBkgd :=  StrToIntDef(Piece(UserParameter, ';', 6), dfltGMVInquiryBkgd);
      GMVInquiryTextBkgd :=  StrToIntDef(Piece(UserParameter, ';', 7), dfltGMVInquiryTextBkgd);
      GMVInquiryName :=  Piece(UserParameter, ';', 8);
      if GMVInquiryName = '' then GMVInquiryName := dfltGMVInquiryName;

      // Comment next lines to restore user settins from DB
      GMVInquiryBkgd :=  dfltGMVInquiryBkgd;
      GMVInquiryTextBkgd :=  dfltGMVInquiryTextBkgd;
      GMVInquiryName :=  dfltGMVInquiryName;
    end;

  UserParameter := Setting[usCanvasAbnormal];
  if UserParameter <> '' then
    begin
      GMVAbnormalBkgd := StrToIntDef(Piece(UserParameter, ';', 1), GMVAbnormalBkgd);
      GMVAbnormalTodayBkgd := StrToIntDef(Piece(UserParameter, ';', 5), GMVAbnormalTodayBkgd);
      GMVAbnormalText := StrToIntDef(Piece(UserParameter, ';', 2), GMVAbnormalText);
      GMVAbnormalBold := (Piece(UserParameter, ';', 3) = '1');
      GMVAbnormalQuals := (Piece(UserParameter, ';', 4) = '1');
    end;

  GMVSearchDelay := GMVUser.Setting[usSearchDelay];
  if GMVSearchDelay = '' then
    begin
      GMVSearchDelay := '1.0';
      GMVUser.Setting[usSearchDelay] := '1.0';
    end;

end;

procedure TGMV_User.SetupSignOnParams;
var
  SL: TStringList;
begin
  SL := getUserSignOnInfo;
  if SL.Count > 0 then
    begin
      FDUZ := SL[0];
      FSignOnDt := getServerWDateTime;  // From now on we will use SERVER TIME only
      if FSignOnDt = 0 then             // zzzzzzandria 050419
        FSignOnDt := Now;               // zzzzzzandria 050419
      FName := SL[1];
      FDomainIEN := SL[2];
      FDomain := SL[3];
      FDivisionIEN := SL[4];
      FDivision := SL[5];
      FGMVManager := (StrToIntDef(SL[6], 0) = 1);
      FTitle := SL[7];
      FDTime := StrToIntDef(SL[9], 300);
      if SL.Count > 10 then             // Patch GRMV*5*3 installed
        FVASite := Piece(SL[10],'^',GMV_VASitePos)
      else                              // Not installed
        FVASite := '';
    end;
  SL.Free;
end;

function TGMV_User.SignOn(Context: string; BypassOffline: Boolean): Boolean;
var
  i: integer;

begin
//////////////////////////////////////////////////////////// Version Comparisson
  if not IsThisExeCompatibleVersion then
    begin
      MessageDlg(
        'You are using ' + CurrentExeNameAndVersion + ' and it' + #13 +
        'is not listed as compatible with the server you connected to.' + #13 + #13 +
        'The selected server needs version ' + RequiredServerVersion + #13 +
        'installed to ensure compatability with this client version.' + #13 + #13 +
        'This program must be upgraded before continuing.',mtWarning,mbAbortIgnore,0);
      Result := False;
      Exit;
    end;
///////////////////////////////////////// Parameters not dealing with connection
  SetupSignOnParams;

  FHelpFileDirectory :=
    ExtractFileDir(Application.ExeName) + '\Help\';

  for i := 1 to ParamCount do
    begin
      if InString(ParamStr(i), ['/demo', '-demo'], False) then
        begin
          FByPassCRCCheck := True;
        end;

      if InString(ParamStr(i), ['/dfn=', '-dfn=', 'dfn='], False) then
        GMVInitialDFN := Piece(ParamStr(i), '=', 2);

      if InString(ParamStr(i), ['/helpdir=', '-helpdir=', 'helpdir='], False) then
// zzzzzzandria 2007-07-18 the next line commented out ------------------- begin
//        FHelpFileDirectory := ExcludeTrailingBackslash(Piece(ParamStr(i), '=', 2)) + '\';
        FHelpFileDirectory := Piece(ParamStr(i), '=', 2);
        if copy(FHelpFileDirectory, Length(FHelpFileDirectory),1) <>'\' then
          FHelpFileDirectory := FHelpFileDirectory + '\';
// zzzzzzandria 2007-07-18 ------------------------------------------------- end
    end;

  SetupUser;

  Result := True;
end;

function TGMV_User.CreateContext(Context: string): Boolean;
begin
  Result := CreateContext(Context);
end;

function TGMV_User.SignOff: Boolean;
begin
  Result := True;
end;

function TGMV_User.GetSetting(Name: TGMV_UserSetting): string;
begin
  try
    Result := getUserSettings(GMVUSERSETTING[Name]);
  except
    on E: Exception do
      Result := '';
  end;
end;

procedure TGMV_User.SetSetting(Name: TGMV_UserSetting; const Value: string);
var
  s: String;
begin
  try
    if not EngineReady then
      Exit;

    s := setUserSettings(GMVUSERSETTING[Name],Value);
    if Piece(s,'^',1) = '-1' then
      MessageDlg(
        'Unable to set parameter ' + GMVUSERSETTING[Name] + '.' + #13 +
        'Error Message: ' + Piece(s, '^', 2), mtError, [mbOK], 0);
  except
    on E: Exception do
      MessageDlg(
        'Unable to set parameter ' + GMVUSERSETTING[Name] + '.' + #13 +
        'Exception Error Message: ' + E.Message, mtError, [mbOK], 0);

  end;
end;

end.
