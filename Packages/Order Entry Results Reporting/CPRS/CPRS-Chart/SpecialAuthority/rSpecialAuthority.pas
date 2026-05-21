unit rSpecialAuthority;

interface

uses
  System.Classes,
  uPCE,
  uSpecialAuthorityTypesEx,
  uSpecialAuthorityEx,
  uProbs,
  VAShared.GenericStringList;

type
  TSpecialAuthoritiesStringList = TStringList<TSpecialAuthoritiesEx>;

function CreateSpecialAuthoritiesEx(PCEData: TPCEData; out Error: string)
  : TSpecialAuthoritiesEx;
procedure UpdateSpecialAuthoritiesEx(PCEData: TPCEData; out Error: string);
procedure CreateOrderSpecialAuthorities(OrderList
  : TSpecialAuthoritiesStringList; out Error: string);
procedure SaveOrderSpecialAuthorities(OrderList: TSpecialAuthoritiesStringList;
  out Error: string);
function CreateProblemListPatientQualifiers(out Error: string)
  : TProblemListPatientQualifiers;
procedure CreateProblemListSpecialAuthorities(ProblemList
  : TSpecialAuthoritiesStringList; out Error: string);

procedure InitSpecialAuthorityTypesEx(out Error: string);
procedure ReloadSpecialAuthorityTypesEx(out Error: string);

implementation

uses
  System.Generics.Collections,
  System.JSON,
  System.SysUtils,
  ORFn,
  ORNet,
  VAShared.UJSONValueHelper,
  uCore,
  rCore,
  rPCE,
  uMisc,
  uConst;

function CreateSpecialAuthoritiesEx(PCEData: TPCEData; out Error: string)
  : TSpecialAuthoritiesEx;
var
  dt: TFMDateTime;
  loc, visit: Integer;
  InputJSON: TJSONObject;
  OutputJSON: TJSONValue;
begin
  Error := '';
  Result := nil;
  dt := Encounter.DateTime;
  visit := 0;
  loc := uEncLocation;
  if assigned(PCEData) then
  begin
    visit := PCEData.VisitIEN;
    if PCEData.Location > 0 then
      loc := PCEData.Location;
    if PCEData.VisitCategory = 'E' then
      dt := FMNow
    else
      dt := PCEData.VisitDateTime;
  end;
  OutputJSON := nil;
  InputJSON := TJSONObject.Create;
  try
    InputJSON.AddPair('patientId', Patient.DFN);
    InputJSON.AddPair('dateTime', dt);
    InputJSON.AddPair('location', loc);
    if visit > 0 then
      InputJSON.AddPair('visitIen', visit);
    OutputJSON := CreateJSONFromVistACall('PXSPECAUTH SPECAUTHDEF', Error,
      InputJSON);
    if Error <> '' then
      Exit;
    Result := TSpecialAuthoritiesExConverter.ToObject<TSpecialAuthoritiesEx>
      (OutputJSON);
    Result.PackageLink := PCE_PACKAGE;
  finally
    FreeAndNil(OutputJSON);
    FreeAndNil(InputJSON);
  end;
end;

procedure UpdateSpecialAuthoritiesEx(PCEData: TPCEData; out Error: string);
var
  TempAuthorities: TSpecialAuthoritiesEx;
begin
  TempAuthorities := CreateSpecialAuthoritiesEx(PCEData, Error);
  try
    if Error = '' then
      PCEData.SpecialAuthorities.CopyFrom(TempAuthorities, [ctCopyVisible]);
  finally
    FreeAndNil(TempAuthorities);
  end;
end;

procedure CreateSpecialAuthorities(List: TSpecialAuthoritiesStringList;
  const RPCName, ListName, IDName, Package: string; out Error: string);
var
  I, Idx: Integer;
  ID: string;
  InputJSON, ItemID: TJSONObject;
  JSONOutput: TJSONValue;
  JSONList: TJSONArray;
  TempAuthorities: TSpecialAuthoritiesEx;
  FreeTempAuthorities: Boolean;
begin
  Error := '';
  if assigned(List) then
  begin
    JSONOutput := nil;
    InputJSON := TJSONObject.Create;
    try
      InputJSON.AddPair('patientId', Patient.DFN);
      JSONList := TJSONArray.Create;
      InputJSON.AddPair(ListName, JSONList);
      for I := 0 to List.Count - 1 do
      begin
        ItemID := TJSONObject.Create;
        ItemID.AddPair(IDName, List[I]);
        JSONList.AddElement(ItemID);
      end;
      JSONOutput := CreateJSONFromVistACall(RPCName, Error, InputJSON);
      if Error <> '' then
        Exit;
      JSONList := JSONOutput.AsTypeDef<TJSONArray>(ListName, nil);
      if assigned(JSONList) then
      begin
        for I := 0 to JSONList.Count - 1 do
        begin
          ID := JSONList[I].AsTypeDef<string>(IDName, '');
          Idx := List.IndexOf(ID);
          if Idx >= 0 then
          begin
            FreeTempAuthorities := True;
            TempAuthorities := TSpecialAuthoritiesExConverter.
              ToObject<TSpecialAuthoritiesEx>(JSONList[I]);
            try
              if assigned(TempAuthorities) then
              begin
                TempAuthorities.ChangeEnabled(True);
                if assigned(List.Objects[Idx]) then
                  List.Objects[Idx].CopyFrom(TempAuthorities,
                    [ctCopyValues, ctCopyVisible])
                else
                begin
                  List.Objects[Idx] := TempAuthorities;
                  FreeTempAuthorities := False;
                end;
                List.Objects[Idx].PackageLink := Package;
              end;
            finally
              if FreeTempAuthorities then
                FreeAndNil(TempAuthorities);
            end;
          end;
        end;
      end;
    finally
      FreeAndNil(JSONOutput);
      FreeAndNil(InputJSON);
    end;
  end;
end;

// This procedure creates TSpecialAuthoritiesEx objects based on RPC data, and
// attaches them to the passed in OrderList in the Objects property.
procedure CreateOrderSpecialAuthorities(OrderList
  : TSpecialAuthoritiesStringList; out Error: string);
var
  Temp: string;
begin
  Temp := VISTA_PACKAGE;
  CreateSpecialAuthorities(OrderList, 'ORSPECAUTH SAFORORDERS', 'orders',
    'orderId', Error, Temp);
end;

procedure SaveOrderSpecialAuthorities(OrderList: TSpecialAuthoritiesStringList;
  out Error: string);
var
  Count: Integer;
  AValue: string;
  SAValue: TSpecialAuthorityValue;
  InputJSON, JSONOrder, JSONAuthority: TJSONObject;
  JSONOutput: TJSONValue;
  JSONOrderList, JSONAuthorities: TJSONArray;
begin
  Error := '';
  if assigned(OrderList) then
  begin
    JSONOutput := nil;
    InputJSON := TJSONObject.Create;
    try
      InputJSON.AddPair('patientId', Patient.DFN);
      JSONOrderList := TJSONArray.Create;
      InputJSON.AddPair('orders', JSONOrderList);
      Count := 0;
      for var I := 0 to OrderList.Count - 1 do
      begin
        if not assigned(OrderList.Objects[I]) then
          continue;
        JSONOrder := TJSONObject.Create;
        JSONOrderList.AddElement(JSONOrder);
        JSONOrder.AddPair('orderId', OrderList[I]);
        JSONAuthorities := TJSONArray.Create;
        JSONOrder.AddPair('specialAuthority', JSONAuthorities);
        for var J := 0 to OrderList.Objects[I].Count - 1 do
          if OrderList.Objects[I][J].Visible then
          begin
            JSONAuthority := TJSONObject.Create;
            JSONAuthorities.Add(JSONAuthority);
            JSONAuthority.AddPair('id',
              OrderList.Objects[I][J].SpecialAuthorityTypeEx.ID);
            SAValue := OrderList.Objects[I][J].Value;
            if not OrderList.Objects[I][J].Enabled then
              SAValue := savUnanswered;
            case SAValue of
              savNo:
                AValue := 'No';
              savYes:
                AValue := 'Yes';
            else
              AValue := 'Unanswered';
            end;
            JSONAuthority.AddPair('value', AValue);
            inc(Count);
          end;
      end;
      if Count = 0 then
        Exit;
      JSONOutput := CreateJSONFromVistACall('ORSPECAUTH UPDATEORDERSA', Error,
        InputJSON);
    finally
      FreeAndNil(JSONOutput);
      FreeAndNil(InputJSON);
    end;
  end;
end;

function CreateProblemListPatientQualifiers(out Error: string)
  : TProblemListPatientQualifiers;
var
  InputJSON: TJSONObject;
  OutputJSON: TJSONValue;
begin
  Error := '';
  OutputJSON := nil;
  Result := nil;
  InputJSON := TJSONObject.Create;
  try
    InputJSON.AddPair('patientId', Patient.DFN);
    OutputJSON := CreateJSONFromVistACall('GMPLSPECAUTH SPECAUTHDEF', Error,
      InputJSON);
    if Error <> '' then
      Exit;
    Result := TSpecialAuthoritiesExConverter.
      ToObject<TProblemListPatientQualifiers>(OutputJSON);
    Result.PackageLink := PROBLEM_LIST_PACKAGE;
  finally
    FreeAndNil(OutputJSON);
    FreeAndNil(InputJSON);
  end;
end;

// This procedure creates TSpecialAuthoritiesEx objects based on RPC data, and
// attaches them to the passed in ProblemList in the Objects property.
procedure CreateProblemListSpecialAuthorities(ProblemList
  : TSpecialAuthoritiesStringList; out Error: string);
var
  Temp: string;
begin
  Temp := PROBLEM_LIST_PACKAGE;
  CreateSpecialAuthorities(ProblemList, 'GMPLSPECAUTH SAFORPROBLEMS',
    'problems', 'problemId', Error, Temp);
end;

procedure InitSpecialAuthorityTypesEx(out Error: string);
var
  OutputJSON: TJSONValue;
begin
  Error := '';
  if not assigned(SpecialAuthorityTypesEx) then
  begin
    OutputJSON := nil;
    try
      OutputJSON := CreateJSONFromVistACall('PXSPECAUTH SPECAUTHSTRUCT', Error);
      if Error <> '' then
        Exit;
      SpecialAuthorityTypesEx := TSpecialAuthorityTypesExConverter.
        ToObject<TSpecialAuthorityTypesEx>(OutputJSON);
//      for var I := SpecialAuthorityTypesEx.Count - 1 downto 0 do
//        if SpecialAuthorityTypesEx[I].disabled then
//          SpecialAuthorityTypesEx.SpecialAuthorityTypes.Delete(I);
    finally
      FreeAndNil(OutputJSON);
    end;
  end;
end;

procedure ReloadSpecialAuthorityTypesEx(out Error: string);
var
  OutputJSON: TJSONValue;
  tempSpecialAuthorityTypeEx: TSpecialAuthorityTypesEx;
  specialAuthority: TSpecialAuthorityTypeEx;
  I: Integer;
begin
  Error := '';
  OutputJSON := nil;
  try
    OutputJSON := CreateJSONFromVistACall('PXSPECAUTH SPECAUTHSTRUCT', Error);
    if Error <> '' then
      Exit;
    tempSpecialAuthorityTypeEx := TSpecialAuthorityTypesExConverter.ToObject<TSpecialAuthorityTypesEx>(OutputJSON);
    //Only setting top level objects for now, at this time we do not use the ValueChange Object in SA, per request from HIMS
    for I := 0 to tempSpecialAuthorityTypeEx.Count - 1 do
    begin
      if SpecialAuthorityTypesEx.Item[tempSpecialAuthorityTypeEx[i].code] <> nil then
        specialAuthority := SpecialAuthorityTypesEx.Item[tempSpecialAuthorityTypeEx[i].code]
      else begin
        specialAuthority := TSpecialAuthorityTypeEx.Create;
        SpecialAuthorityTypesEx.SpecialAuthorityTypes.Add(specialAuthority);
      end;
      specialAuthority.id := tempSpecialAuthorityTypeEx[i].id;
      specialAuthority.code := tempSpecialAuthorityTypeEx[i].code;
      specialAuthority.abbreviation := tempSpecialAuthorityTypeEx[i].abbreviation;
      specialAuthority.displayName := tempSpecialAuthorityTypeEx[i].displayName;
      specialAuthority.disabled := tempSpecialAuthorityTypeEx[i].disabled;
      specialAuthority.description := tempSpecialAuthorityTypeEx[i].description;
      specialAuthority.sequence := tempSpecialAuthorityTypeEx[i].sequence;
    end;

  finally
    FreeAndNil(OutputJSON);
    FreeAndNil(tempSpecialAuthorityTypeEx);
  end;
end;

end.
