unit oDST;

interface
uses
  Winapi.Windows;

type

  TDstParameters = record
    FSwitch: string;

    FOrderConsult: Boolean;

    FReceive: Boolean;
    FSchedule: Boolean;
    FCancel: Boolean;
    FEditRes: Boolean;
    FDiscontinue: Boolean;
    FForward: Boolean;
    FComment: Boolean;
    FSigFind: Boolean;
    FAdminComp: Boolean;
    FTestUrl: String;
    FProdUrl: String;
    FUiPath: String;
    FDstConsSaveApi: String;
    FDstConsDecApi: String;
  end;

  TDstProvider = class(TObject)
  private
    fProduction: Boolean;
    fParameters: TDstParameters;
    procedure setDstMode(aMode: String);
    procedure setProduction(aProduction: Boolean);
    function getDstMode: String;
    function ParametersStr: String;
  public
    property DstParameters: TDstParameters read fParameters write fParameters;
    property Production: Boolean read fProduction write setProduction;
    property DstMode: String read getDstMode write setDstMode;
    procedure ReloadParameters;
    function getDstUuid(id, service, urgency: string; cid, nltd: Double;
      workflow: string; outpatient: string): string;
    function getDstReply(dstID: string; workflowID: string): String; overload;
    function getDstReply(dstID: string): Integer; overload;
    function getDstReply(aService, aUrgency, aWorkflow: string)
      : String; overload;
  end;

  TDSTMgr = class(TObject)
  private
    { Private declarations }
    fDstBtnVisible: boolean;
    fDstProvider: TdstProvider;
    fDstID: String;
    fDstResult: String;
    fDSTCase: String;
    fDSTMode: String;
    fDSTService: String;
    fDSTUrgency: String;
    fDSTCid: Double;
    fDSTNltd: Double;
    fDSTOutpatient: String;
    fDSTAction: Integer;
    fDSTCaption: String;
    procedure setDSTMode(aMode: String);
    procedure setDSTAction(anAction: Integer);
  public
    { Public declarations }
    property DstProvider: TdstProvider read fDstProvider write fDstProvider;
    property DSTId: String read fDstID write fDstID;
    property DSTService: String read fDSTService write fDSTService;
    property DSTUrgency: String read fDSTUrgency write fDSTUrgency;
    property DSTCid: Double read fDSTCid write fDSTCid;
    property DSTNltd: Double read fDSTNltd write fDSTNltd;
    property DSTOutpatient: String read fDSTOutpatient write fDSTOutpatient;
    property DSTCase: String read fDSTCase write fDSTCase;
    property DSTMode: String read fDSTMode write setDSTMode;
    property DSTAction: Integer read fDSTAction write setDSTAction;
    property DSTResult: String read fDstResult write fDstResult;
    property DSTBtnVisible: boolean read fDstBtnVisible write fDstBtnVisible;
    property DSTCaption: String read fDSTCaption;

    procedure doDst;
    procedure doDSTConsultAct;
    procedure doDSTConsult(aWorkflow: String = 'ORDER');

    constructor Create;
    destructor Destroy; override;
  end;

const
  DST_DST = 'D';
  DST_CTB = 'C';
  DST_OTH = 'O';

  DST_CASE_CONSULT_ACT = 'CONSULT_ACT';
  DST_CASE_CONSULT_EDIT = 'CONSULT_EDIT';
  DST_CASE_CONSULTS = 'CONSULTS';
  DST_CASE_CONSULT_OD = 'CONSULT_OD';

var
  DSTPro: TDstProvider;

procedure initDst;
function GetDSTMgr(aCase: string = ''): TDSTMgr;  // factory for singleton
procedure FreeDSTMgr;

function isDstEnabled: Boolean;
function isCtbEnabled: Boolean;

implementation

uses
  System.Net.HttpClientComponent, System.Net.URLClient, System.Net.HttpClient,
  SysUtils, System.JSON, ORFn, uGN_RPCLog, uCore, uConsults, uORRESTClient,
  uDSTConst, fDSTView, System.UITypes, fConsults
  , uUserInfo
  ;

var
  ADSTMgr: TDSTMgr;

function GetDSTMgr(aCase: string=''): TDSTMgr;
begin
  if not assigned(ADSTMgr) then
    ADSTMgr := TDSTMgr.Create;
  if aCase <> '' then
    ADSTMgr.dstCase := aCase;
  result := ADSTMgr;
end;

procedure FreeDSTMgr;
begin
  FreeAndNil(ADSTMgr);
end;

function isDstEnabled: Boolean;
begin
  Result := SystemParameters.AsType<string>(DST_CTB_SWITCH) <> '0';
end;

function isCtbEnabled: Boolean;
begin
  Result := SystemParameters.AsType<string>(CTB_ENABLED) <> '0';
end;

procedure initDst;
begin
  if not Assigned(DSTPro) then
    DSTPro := TDstProvider.Create;
  DSTPro.ReloadParameters; // -- might be not connected yet
  DSTPro.Production := User.IsProductionAccount;
end;

function ctbFormattedDate(aFMDate: TFMDateTime): String;
var
  ADatePart: Integer;
  AYear, AMonth, ADay: Word;
begin
  {FormatFMDateTime will not return 00 if a value is missing. Janurary 1950
  will be returned as 1950-01-. 1950 will return as 1950--. These values are
  considered valid DOBs and therefore must be reset to yyyy-mm-dd prior
  to sending to CTB 2.0 }

  ADatePart := Trunc(aFMDate);

  AYear := ADatePart div 10000 + 1700;
  AMonth := ADatePart mod 10000 div 100;
  ADay := ADatePart mod 100;

  if (AYear > 0) and (AMonth = 0) and (ADay = 0) then
    Result := FormatFMDateTime('yyyy', aFMDate) + '-00-00'
  else if (AYear > 0) and (AMonth > 0) and (ADay = 0) then
    Result := FormatFMDateTime('yyyy-mm', aFMDate) + '-00'
  else if (AYear > 0) and (AMonth > 0) and (ADay > 0) then
    Result := FormatFMDateTime('yyyy-mm-dd', aFMDate)
  else
    Result := '';
end;

function getDstRequestString(anID: String; aPatient: TPatient; aUser: TUser;
  service, urgency, workflow: string; cid, nltd: Double;
  outpatient: String): String;
var
  PTData: TJSONObject;
  DstUuid, FName, MName, LName, DOB, UserID, ConsultHistory: string;
begin
  Result := '';

  if (workflow <> 'ORDER') and (ConsultRec.dstID <> '') then
    DstUuid := ConsultRec.dstID
  else
    DstUuid := anID;

  LName := Piece(aPatient.Name, ',', 1);
  FName := Piece(aPatient.Name, ',', 2);
  MName := Piece(FName, ' ', 2);
  DOB := ctbFormattedDate(Patient.DOB);

  UserID := getUserInfo();

  PTData := TJSONObject.Create;
  try
    if DstUuid <> '' then
      PTData.AddPair(DST_ID, DstUuid);

    PTData.AddPair(DST_CONSULT_CONSULTSERVICE, service);
    PTData.AddPair(DST_CONSULT_CONSULTURGENCY, urgency);
    if cid > 0 then
      PTData.AddPair(DST_CONSULT_DATE, FormatFMDateTime('yyyy-mm-dd', cid));
    if nltd > 0 then
      PTData.AddPair(DST_CONSULT_NOTLATERTHAN,
        FormatFMDateTime('yyyy-mm-dd', nltd));
    PTData.AddPair(DST_CONSULT_PTFIRSTNAME, FName);
    PTData.AddPair(DST_CONSULT_PTLASTNAME, LName);
    PTData.AddPair(DST_CONSULT_PTMIDNAME, MName);
    if DOB <> '' then
        PTData.AddPair(DST_CONSULT_PTDOB, DOB);
    PTData.AddPair(DST_CONSULT_PTICN, Patient.FullICN);
    PTData.AddPair(DST_CONSULT_PTCLASS, outpatient);
    PTData.AddPair(DST_CONSULT_SITEID, User.StationNumber);

    PTData.AddPair(DST_CONSULT_WORKFLOWID, workflow);

    if (workflow <> 'ORDER') then
    begin
      if Assigned(ConsultRec.RequestProcessingActivity) then
      begin
        ConsultHistory := ConsultRec.RequestProcessingActivity.Text;
        ConsultHistory := StringReplace(ConsultHistory, #$D#$A, '\\r\\n',
          [rfReplaceAll, rfIgnoreCase]);
        ConsultHistory := StringReplace(ConsultHistory, #$27#$27, '\' + #$27,
          [rfReplaceAll, rfIgnoreCase]);
        PTData.AddPair(DST_CONSULT_HISTORY, ConsultHistory)
      end
      else
        PTData.AddPair(DST_CONSULT_HISTORY, '');
    end;

    PTData.AddPair(DST_CONSULT_USERID, UserID);

    if aUser.IsProvider then
      PTData.AddPair(DST_CONSULT_PROVIDERKEY, 'true')
    else
      PTData.AddPair(DST_CONSULT_PROVIDERKEY, 'false');

    //ToJSON always returns UTF8 expected by CTB 2.0
    Result := PTData.ToJSON;
  finally
    PTData.Free;
  end;
  addLogLine(Result, 'DST REQUEST');
end;

function getRestReply(aRequest, aServer, aPath: String): String;
var
  RESTClient: TORRESTClient;
begin
  Result := '';
  RESTClient := TORRESTClient.Create;
  try
    RESTClient.Server := aServer;
    RESTClient.Path := aPath;
    try
      Result := RESTClient.Post(aRequest);
    except
      on E: TORRESTException do
      begin
        addLogLine(E.Message, 'REST POST ERROR');
        Result := 'Error' + CRLF + E.Message;
      end;
    end;
  finally
    RESTClient.Free;
  end;
end;

function getNetReply(aServer, aPath, anId: String): String;
var
  RESTClient: TORRESTClient;
begin
  Result := '';
  RESTClient := TORRESTClient.Create;
  try
    RESTClient.Server := aServer; //s/b passed based on prod or test
    RESTClient.Path := aPath;   //s/b dst decision path
    try
      Result := RESTClient.Get(anID)
     except
      on E: TORRESTException do
      begin
        addLogLine(E.Message, 'REST GET ERROR');
        Result := 'Error' + CRLF + E.Message;
      end;
    end;
  finally
    RESTClient.Free;
  end;
end;

function TDstProvider.getDstMode;
begin
  Result := fParameters.FSwitch;
end;

procedure TDstProvider.setDstMode(aMode: String);
begin
  fParameters.FSwitch := aMode;
end;

procedure TDstProvider.setProduction(aProduction: Boolean);
begin
  fProduction := aProduction;
end;

function TDstProvider.ParametersStr;
const
  fmtSName = '%s - %s';

  function bStr(aName: String; aValue: Boolean): String;
  begin
    if aValue then
      Result := Format(fmtSName, [aName, 'True'])
    else
      Result := Format(fmtSName, [aName, 'False'])
  end;

begin
  Result := '';
  with fParameters do
  begin
    Result := Result + Format(fmtSName, ['FSwitch', FSwitch]) + #13#10;
    Result := Result + bStr('FOrderConsult', FOrderConsult) + #13#10;
    Result := Result + bStr('FReceive', FReceive) + #13#10;
    Result := Result + bStr('FSchedule', FSchedule) + #13#10;
    Result := Result + bStr('FCancel', FCancel) + #13#10;
    Result := Result + bStr('FEditRes', FEditRes) + #13#10;
    Result := Result + bStr('FDiscontinue', FDiscontinue) + #13#10;
    Result := Result + bStr('FForward', FForward) + #13#10;
    Result := Result + bStr('FComment', FComment) + #13#10;
    Result := Result + bStr('FSigFind', FSigFind) + #13#10;
    Result := Result + bStr('FComment', FComment) + #13#10;
    Result := Result + Format(fmtSName, ['FTestUrl', FTestUrl]) + #13#10;
    Result := Result + Format(fmtSName, ['FProdUrl', FProdUrl]) + #13#10;
    Result := Result + Format(fmtSName, ['FUiPath', FUiPath]) + #13#10;
    Result := Result + Format(fmtSName, ['FDstSaveApi', FDstConsSaveApi]
      ) + #13#10;
    Result := Result + Format(fmtSName, ['FDstConsDecApi', FDstConsDecApi]
      ) + #13#10;
  end;
end;

procedure TDstProvider.ReloadParameters;
begin
  with fParameters do
  begin
    // switch parameter value can be D, C, or O (DST, CTB, or OFF)
    FSwitch := SystemParameters.AsType<string>(DST_CTB_SWITCH);
    if FSwitch <> 'O' then
    begin
      FTestUrl := SystemParameters.AsType<string>(DST_TEST_SERVER);
      FProdUrl := SystemParameters.AsType<string>(DST_PROD_SERVER);
    end;
    if FSwitch = 'D' then
    begin
      FUiPath := SystemParameters.AsType<string>(DST_UI_PATH);
    end;
    if FSwitch = 'C' then
    begin
      FUiPath := SystemParameters.AsType<string>(CTB_UI_PATH);
    end;
    FDstConsSaveApi := SystemParameters.AsType<string>(DST_CONSULT_SAVE_API);
    FDstConsDecApi := SystemParameters.AsType<string>(DST_CONSULT_DECISION_API);
    if FSwitch = 'O' then
    begin
      FOrderConsult := False;
      FReceive := False;
      FSchedule := False;
      FCancel := False;
      FEditRes := False;
      FDiscontinue := False;
      FForward := False;
      FComment := False;
      FSigFind := False;
      FAdminComp := False;
    end
    else
    begin
      FOrderConsult := StrToBool(SystemParameters.AsType<string>(CTB_ORDER_CONSULT));
      FReceive := StrToBool(SystemParameters.AsType<string>(CTB_RECEIVE));
      FSchedule := StrToBool(SystemParameters.AsType<string>(CTB_SCHEDULE));
      FCancel := StrToBool(SystemParameters.AsType<string>(CTB_CANCEL));
      FEditRes := StrToBool(SystemParameters.AsType<string>(CTB_EDITRES));
      FDiscontinue := StrToBool(SystemParameters.AsType<string>(CTB_DISCON));
      FForward := StrToBool(SystemParameters.AsType<string>(CTB_FORWARD));
      FComment := StrToBool(SystemParameters.AsType<string>(CTB_COMMENT));
      FSigFind := StrToBool(SystemParameters.AsType<string>(CTB_SIGFIND));
      FAdminComp := StrToBool(SystemParameters.AsType<string>(CTB_ADMINCOMP));
    end;
  end;

  addLogLine(ParametersStr, '--DST PARAMETERS--');

end;

function TDstProvider.getDstUuid(id, service, urgency: string; cid, nltd: Double;
  workflow: string; outpatient: string): string;
var
  JSonValue: TJsonValue;
  sServer, sPath, sRequest: String;
begin
  sRequest := getDstRequestString(id, Patient, User, service, urgency, workflow,
    cid, nltd, outpatient);

  sPath := fParameters.FDstConsSaveApi;

  if Production then
    sServer := fParameters.FProdUrl
  else
    sServer := fParameters.FTestUrl;

  try
    Result := getRestReply(sRequest, sServer, sPath);
    if (Pos('Error', Result) <> 1) and (Result <> '') then
    begin
      JSonValue := TJSONObject.ParseJSONValue(Result);
      Result := JSonValue.GetValue<string>('dst_id', '');
      JSonValue.Free;
    end
   finally
    addLogLine('Server: ' + sServer + #13#10 + 'Path: ' + sPath + #13#10 +
      'Request: ' + #13#10 + sRequest + #13#10 + 'Result:' + #13#10 + Result,
      '--GET DST ID--');
  end;
end;

function TDstProvider.getDstReply(dstID: string; workflowID: string): String;
var
  sNode, sURL, sApi: String;
  JSonValue: TJsonValue;
begin
  result := '';
  if assigned(ADSTMgr) then
  begin
    if Production then
    begin
      sURL := DstParameters.FProdUrl;
      sApi := DstParameters.FDstConsDecApi;
    end
    else
    begin
      sURL := DstParameters.FTestUrl;
      sApi := DstParameters.FDstConsDecApi;
    end;
    try
      result := getNetReply(sURL, sApi, dstID);
    finally
      addLogLine('URL: ' + sURL + #13#10 + 'API: ' + sApi + #13#10 + 'DST ID: '
        + dstID + #13#10 + 'Result:' + #13#10 + result,
        '--GET DST DECISION REPLY--');
    end;

    if pos('Error', result) <> 1 then
    begin
      if workflowID = 'ORDER' then
        sNode := 'dst_status_message'
      else
        sNode := 'decision_info';
      JSonValue := TJSONObject.ParseJSONValue(result);
      try
        if assigned(JSonValue) then
          result := JSonValue.GetValue<string>(sNode, '');
      finally
        JSonValue.Free;
      end;
    end;
  end;
end;

function TDstProvider.getDstReply(dstID: string): Integer;
var
  sURL: String;
begin
  Result := mrCancel;
  try
    if Production then
      sURL := DstParameters.FProdUrl + DstParameters.FUiPath + '?dstID=' + dstID
    else
      sURL := DstParameters.FTestUrl + DstParameters.FUiPath +
        '?dstID=' + dstID;
{$IFDEF DEBUG}
    sURL := 'https://dst-demo.domain/ctb/emulator/';
{$ENDIF}
    Result := dstReviewResult(sURL, DSTMode);
  finally
    addLogLine('URL: ' + sURL + #13#10 + 'Result:' + #13#10 + IntToStr(Result),
      'DST BROWSER CLOSE');
  end;
end;

// CONSULTS only. Not used yet
function TDstProvider.getDstReply(aService, aUrgency,
  aWorkflow: string): String;
var
  sID: String;
begin
    Result := getDstReply(sID, aWorkflow)
end;

{ TDSTMgr }

constructor TDSTMgr.Create;
begin
  // if not assigned(fDstProvider) then
  // fDstProvider := TdstProvider.Create;
  // fDstProvider.ReloadParameters;
  InitDST; // one provider for all dialogs
  fDstProvider := DSTPro;
  SetDSTMode(DSTPro.DstParameters.fSwitch); // DST_DST;
  //fDSTCase := aCase;   // Set in factory[
end;

destructor TDSTMgr.Destroy;
begin
  // if assigned(fDstProvider) then
  // fDstProvider := nil; // single DstPro is used for all dialogs/windows
end;

procedure TDSTMgr.doDst;
begin
  if (assigned(DstProvider)) and (DSTCase <> '') then
  begin
    if DSTCase = DST_CASE_CONSULT_ACT then
      doDSTConsultAct
    else if DSTCase = DST_CASE_CONSULT_EDIT then
      doDSTConsult('EDIT-RESUBMIT')
    else if DSTCase = DST_CASE_CONSULT_OD then
      doDSTConsult('ORDER');
  end
  else
    GetDstMgr.DSTResult := 'Error';
end;

procedure TDSTMgr.doDSTConsult(aWorkflow: String);
begin
  DSTId := DstProvider.getDstUuid(DSTId, DSTService, DSTUrgency, DSTCid,
    DSTNltd, aWorkflow, DSTOutpatient);

  if (Pos('Error',DSTId) <> 1) and (DSTId <> '')  then
    begin
      DstProvider.getDSTReply(DSTId);
      DSTResult := DstProvider.getDSTReply(DSTId, aWorkflow);
   end
  else if Pos('Error',DSTId) = 1 then
       DstResult := DSTId;
end;

procedure TDSTMgr.doDSTConsultAct;
  function getActionName: String;
  begin
    case fDSTAction of
      CN_ACT_FORWARD:
        Result := 'FORWARD';
      CN_ACT_ADD_CMT:
        Result := 'COMMENT';
      CN_ACT_ADMIN_COMPLETE:
        Result := 'ADMINISTRATIVE COMPLETE';
      CN_ACT_SIGFIND:
        Result := 'SIGNIFICANT FINDING';
      CN_ACT_RECEIVE:
        Result := 'RECEIVE';
      CN_ACT_SCHEDULE:
        Result := 'SCHEDULE';
      CN_ACT_DENY:
        Result := 'CANCEL-DENY';
      CN_ACT_DISCONTINUE:
        Result := 'DISCONTINUE';
    else
      Result := '';
    end;
  end;

begin
  DSTId := DstProvider.getDstUuid(DSTId, DSTService, DSTUrgency,
    ConsultRec.ClinicallyIndicatedDate, ConsultRec.NoLaterThanDate,
    getActionName, DSTOutpatient);
  if (Pos('Error',DSTId) <> 1) and (DSTId <> '') then
  begin
     DstProvider.getDSTReply(DSTId);
     DstResult := DstProvider.getDstReply(DSTId, getActionName());
  end
  else if Pos('Error',DSTId) = 1 then
       DstResult := DSTId;
end;


procedure TDSTMgr.setDSTAction(anAction: Integer);
begin
  fDSTAction := anAction;
  fDstBtnVisible := False;
  // add comment always has a button unless Switch = 'O'
  if anAction = CN_ACT_ADD_CMT then
    fDstBtnVisible := DstProvider.DstParameters.fComment
  else if DstProvider.DstParameters.fSwitch = 'C' then
    case anAction of
      CN_ACT_FORWARD:
        fDstBtnVisible := DstProvider.DstParameters.fForward;
      CN_ACT_ADMIN_COMPLETE:
        fDstBtnVisible := DstProvider.DstParameters.fAdminComp;
      CN_ACT_SIGFIND:
        fDstBtnVisible := DstProvider.DstParameters.fSigFind;
      CN_ACT_RECEIVE:
        fDstBtnVisible := DstProvider.DstParameters.fReceive;
      CN_ACT_SCHEDULE:
        fDstBtnVisible := DstProvider.DstParameters.fSchedule;
      CN_ACT_DENY:
        fDstBtnVisible := DstProvider.DstParameters.fCancel;
      CN_ACT_DISCONTINUE:
        fDstBtnVisible := DstProvider.DstParameters.FDiscontinue;
    end;
  //btnLaunchToolbox.Enabled := fDstBtnVisible;   must be set in forms.
end;

procedure TDSTMgr.setDSTMode(aMode: String);
begin
  //fDSTCaption := 'Disabled';
  DstProvider.DSTMode := aMode;
  fDstBtnVisible := True;
  if aMode = DST_DST then
    fDSTCaption := 'Launch DST'
  else if aMode = DST_CTB then
    fDSTCaption := 'Open Consult Toolbox'
  else if aMode = DST_OTH then
    fDstBtnVisible := False
  else if aMode = '' then
    fDstBtnVisible := False;
  // btnLaunchToolbox.Caption := s; must be set in forms.
end;


initialization

finalization

if Assigned(DSTPro) then
  DSTPro.Free;

end.
