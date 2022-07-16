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

  var
  DSTPro: TDstProvider;

procedure initDst;

implementation

uses
  System.Net.HttpClientComponent, System.Net.URLClient, System.Net.HttpClient,
  SysUtils, System.JSON, ORFn, uGN_RPCLog, uCore, uConsults, uORRESTClient,
  uDSTConst, fDSTView, System.UITypes
  , uUserInfo
  ;

procedure initDst;
begin
  if not Assigned(DSTPro) then
    DSTPro := TDstProvider.Create;
  DSTPro.ReloadParameters; // -- might be not connected yet
  DSTPro.Production := User.IsProductionAccount;
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
  DOB := FormatDateTime(DST_DATE_TIME_FORMAT,
    FMDateTimeToDateTime(Patient.DOB));

  UserID := getUserInfo();

  PTData := TJSONObject.Create;
  try
    if DstUuid <> '' then
      PTData.AddPair(DST_ID, DstUuid);

    PTData.AddPair(DST_CONSULT_CONSULTSERVICE, service);
    PTData.AddPair(DST_CONSULT_CONSULTURGENCY, urgency);
    if cid > 0 then
      PTData.AddPair(DST_CONSULT_DATE, FormatDateTime(DST_DATE_TIME_FORMAT,
        FMDateTimeToDateTime(cid)));
    if nltd > 0 then
      PTData.AddPair(DST_CONSULT_NOTLATERTHAN,
        FormatDateTime(DST_DATE_TIME_FORMAT, FMDateTimeToDateTime(nltd)));
    PTData.AddPair(DST_CONSULT_PTFIRSTNAME, FName);
    PTData.AddPair(DST_CONSULT_PTLASTNAME, LName);
    PTData.AddPair(DST_CONSULT_PTMIDNAME, MName);
    PTData.AddPair(DST_CONSULT_PTSSN, Patient.SSN);
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

    Result := PTData.ToString;
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
      end;
    end;
  finally
    RESTClient.Free;
  end;
end;

function getNetJsonReply(aUrl: String): String;
var
  i: Integer;
  jHeader: TNameValuePair;
  nClient: TNetHTTPClient;
  nRequest: TNetHTTPRequest;
  iResponse: IHTTPResponse;
begin
  Result := '';
  jHeader.Name := 'Content-Type';
  jHeader.Value := 'application/json';

  nClient := TNetHTTPClient.Create(nil);
  nClient.AllowCookies := True;
  nClient.HandleRedirects := True;
  nClient.UserAgent := 'Embarcadero URI Client/1.0';
  nRequest := TNetHTTPRequest.Create(nil);
  nRequest.Client := nClient;
  try
    iResponse := nRequest.Get(aUrl, nil, [jHeader]);
    i := iResponse.StatusCode;
    if i <> 200 then
      Result := 'error ' + IntToStr(i) + ' (' + iResponse.StatusText + ')'
    else
      Result := iResponse.ContentAsString();

    addLogLine(Result, 'HTTP JSON REPLY');
  finally
    nClient.Free;
    nRequest.Free;
  end;
end;

/// /////////////////////////////////////////////////////////////////////////////

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
    FSwitch := SystemParameters.StringValue[DST_CTB_SWITCH];
    if FSwitch <> 'O' then
    begin
      FTestUrl := SystemParameters.StringValue[DST_TEST_SERVER];
      FProdUrl := SystemParameters.StringValue[DST_PROD_SERVER];
    end;
    if FSwitch = 'D' then
    begin
      FUiPath := SystemParameters.StringValue[DST_UI_PATH];
    end;
    if FSwitch = 'C' then
    begin
      FUiPath := SystemParameters.StringValue[CTB_UI_PATH];
    end;
    FDstConsSaveApi := SystemParameters.StringValue[DST_CONSULT_SAVE_API];
    FDstConsDecApi := SystemParameters.StringValue[DST_CONSULT_DECISION_API];
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
      FOrderConsult := StrToBool(SystemParameters.StringValue
        [CTB_ORDER_CONSULT]);
      FReceive := StrToBool(SystemParameters.StringValue[CTB_RECEIVE]);
      FSchedule := StrToBool(SystemParameters.StringValue[CTB_SCHEDULE]);
      FCancel := StrToBool(SystemParameters.StringValue[CTB_CANCEL]);
      FEditRes := StrToBool(SystemParameters.StringValue[CTB_EDITRES]);
      FDiscontinue := StrToBool(SystemParameters.StringValue[CTB_DISCON]);
      FForward := StrToBool(SystemParameters.StringValue[CTB_FORWARD]);
      FComment := StrToBool(SystemParameters.StringValue[CTB_COMMENT]);
      FSigFind := StrToBool(SystemParameters.StringValue[CTB_SIGFIND]);
      FAdminComp := StrToBool(SystemParameters.StringValue[CTB_ADMINCOMP]);
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

    if Result <> '' then
    begin
      JSonValue := TJSONObject.ParseJSONValue(Result);
      Result := JSonValue.GetValue<string>('dst_id', '');
      JSonValue.Free;
    end
    else
      Result := '';
  finally
    addLogLine('Server: ' + sServer + #13#10 + 'Path: ' + sPath + #13#10 +
      'Request: ' + #13#10 + sRequest + #13#10 + 'Result:' + #13#10 + Result,
      '--GET DST ID--');
  end;
end;

function TDstProvider.getDstReply(dstID: string; workflowID: string): String;
var
  sNode, sURL: String;
  JSonValue: TJsonValue;
begin
  Result := '';
  if Production then
    sURL := DstParameters.FProdUrl + DstParameters.FDstConsDecApi + dstID
  else
    sURL := DstParameters.FTestUrl + DstParameters.FDstConsDecApi + dstID;
  try
    Result := getNetJsonReply(sURL);
  finally
    addLogLine('URL: ' + sURL + #13#10 + 'Result:' + #13#10 + Result,
      '--GET DST REPLY--');
  end;

  if pos('error', Result) <> 1 then
  begin
    if workflowID = 'ORDER' then
      sNode := 'dst_status_message'
    else
      sNode := 'decision_info';
    JSonValue := TJSONObject.ParseJSONValue(Result);
    try
      if Assigned(JSonValue) then
        Result := JSonValue.GetValue<string>(sNode, '');
    finally
      JSonValue.Free;
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

    Result := dstReviewResult(sURL);
  finally
    addLogLine('URL: ' + sURL + #13#10 + 'Result:' + #13#10 + IntToStr(Result),
      'GET DST REPLY(2)');
  end;
end;

// CONSULTS only. Not used yet
function TDstProvider.getDstReply(aService, aUrgency,
  aWorkflow: string): String;
var
  sID: String;
begin
//  sID := getDstUuid(aService, aUrgency, ConsultRec.ClinicallyIndicatedDate,
//    ConsultRec.NoLaterThanDate, 'CPRS_SIGNED');

//  if getDstReply(sID) = mrOK then
    Result := getDstReply(sID, aWorkflow)
//  else
//    Result := '';
end;

initialization

finalization

if Assigned(DSTPro) then
  DSTPro.Free;

end.
