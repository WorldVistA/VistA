unit uSimilarNames;

{ ------------------------------------------------------------------------------
  Extention of ORCtrl.TORComboBox.
  Verifies if there are names "similar" to the selected one.
  If so - requests confirmation of the selection.
  NSR#20110606 (Similar Provider/Cosigner names)
  ---------------------------------------------------------------------------- }
////////////////////////////////////////////////////////////////////////////////
///  Usage:
///  1. Register an ORComboBox with TSimilarNames.RegORComboBox
///  2. Use TSimilarNames.CallVista for the calls for data (there are wrapper
///     functions in rCore, and a few other places, for this)
///  3. Use CheckForSimilarName when the user selects an item in the ORComboBox
///  4. Set the provider/cosigner/etc. to ORCombobox.ItemIEN
////////////////////////////////////////////////////////////////////////////////

interface

uses
  ORCtrls,
  System.Classes,
  WinApi.Windows,
  Controls,
  System.Generics.Collections,
  ORNetIntf;

type
  TSelector = (sPt, sPr, sCo, sUnknown);
    // sPr - provider
    // sCo - cosigner
    // sPt - patient

  TSNRec = record
    Str: string;
    Int: IORNetParam;
    List: TStringList;
  end;

  TSNParamList = TArray<TSNRec>;

  TSNComboBoxData = class(TObject)
  private
    FValue: Int64;
    FRPC: string;
    FParams: TSNParamList;
    procedure ClearParams;
    procedure SetParamLength(ALength: integer);
    function GetNewList(Index: integer): TStringList;
  public
    destructor Destroy; override;
    property Value: Int64 read FValue write FValue;
    property RPC: string read FRPC write FRPC;
    property Params: TSNParamList read FParams;
  end;

  TSimilarNames = class(TObject)
  strict private
    class var FEnabled: Boolean;
  private
    class var FWasWindowShown: boolean;
    class function GetData(AORComboBox: TORComboBox): TSNComboBoxData;
    class procedure SaveParams(AORComboBox: TORComboBox; const ARPCName: string;
      const AParam: array of const);
  public
    class constructor Create;
    class function IsORComboBoxChanged(AORComboBox: TORComboBox): Boolean;
    class procedure RegORComboBox(AORComboBox: TORComboBox; AValue: Int64 = 0);
    class property WasWindowShown: boolean read FWasWindowShown; // Was a similarnames window shown during the last similarnames call?
    class property Enabled: boolean read FEnabled write FEnabled;

    class function CallVistA(AORComboBox: TORComboBox;
      const AParam: array of const; ARequireResults: Boolean = False)
      : Boolean; overload;
    class function CallVistA(AORComboBox: TORComboBox;
      const AParam: array of const; var AReturn: Integer;
      ARequireResults: Boolean = False; ADefault: Integer = 0)
      : Boolean; overload;
    class function CallVistA(AORComboBox: TORComboBox;
      const AParam: array of const; var AReturn: Integer; ADefault: Integer;
      ARequireResults: Boolean = False): Boolean; overload;
    class function CallVistA(AORComboBox: TORComboBox;
      const AParam: array of const; var AReturn: Double;
      ARequireResults: Boolean = False; ADefault: Double = 0.0)
      : Boolean; overload;
    class function CallVistA(AORComboBox: TORComboBox;
      const AParam: array of const; var AReturn: Double; ADefault: Double;
      ARequireResults: Boolean = False): Boolean; overload;
    class function CallVistA(AORComboBox: TORComboBox;
      const AParam: array of const; var AReturn: string;
      ARequireResults: Boolean = False; ADefault: string = '')
      : Boolean; overload;
    class function CallVistA(AORComboBox: TORComboBox;
      const AParam: array of const; var AReturn: string; ADefault: string;
      ARequireResults: Boolean = False): Boolean; overload;
    class function CallVistA(AORComboBox: TORComboBox;
      const AParam: array of const; AReturn: TStrings;
      ARequireResults: Boolean = False): Boolean; overload;
  end;

  // String return, since Patient DNF is string while Provider is Int64
function getItemIDFromList(AList: TStrings; AType: TSelector = sPt;
  AExceptions: TStrings = nil): string;

function CheckForSimilarName(AORComboBox: TORComboBox; out AErrorMsg: string;
  ASelectorType: TSelector; AExceptions: TStrings = nil): Boolean;

implementation

uses
  rCore,
  uCore,
  System.UITypes,
  Vcl.Dialogs,
  System.SysUtils,
  ORFn,
  fDupPts,
  ORNet;

const
  RPCName = 'ORNEWPERS NEWPERSON';

{ TSNComboBoxData }

procedure TSNComboBoxData.ClearParams;
begin
  SetParamLength(0);
end;

destructor TSNComboBoxData.Destroy;
begin
  ClearParams;
  inherited;
end;

function TSNComboBoxData.GetNewList(Index: integer): TStringList;
begin
  Result := TStringList.Create;
  FParams[Index].List := Result;
end;

procedure TSNComboBoxData.SetParamLength(ALength: integer);
var
  I, Old: integer;
begin
  Old := High(FParams);
  for I := ALength to Old do
    FreeAndNil(FParams[I].List);
  SetLength(FParams, ALength);
end;

{ TSimilarNames }

class constructor TSimilarNames.Create;
begin
  inherited;
  FEnabled := True;
  FWasWindowShown := False;
end;

class function TSimilarNames.GetData(AORComboBox: TORComboBox): TSNComboBoxData;
begin
  Result := nil;
  if Assigned(AORComboBox) then
  begin
    if not Assigned(AORComboBox.Data) then
      AORComboBox.Data := TSNComboBoxData.Create;
    if not(AORComboBox.Data is TSNComboBoxData) then
      raise Exception.Create('AORComboBox.Data is not of type TSNComboBoxData');
    Result := AORComboBox.Data as TSNComboBoxData;
  end;
end;

class procedure TSimilarNames.RegORComboBox(AORComboBox: TORComboBox;
  AValue: Int64 = 0);
begin
  if (AValue = 0) and Assigned(AORComboBox) and
    (not(csDestroying in AORComboBox.ComponentState)) then
    AValue := AORComboBox.ItemIEN;
  GetData(AORComboBox).Value := AValue;
end;

class procedure TSimilarNames.SaveParams(AORComboBox: TORComboBox;
  const ARPCName: string; const AParam: array of const);
var
  I, ALength: Integer;
  AExt: Extended;
  AORNetParam: IORNetParam;
  AError: String;
  AData: TSNComboBoxData;
begin
  AData := GetData(AORComboBox);
  AData.ClearParams;
  AData.RPC := ARPCName;
  AError := '';
  ALength := Length(AParam);
  AData.SetParamLength(ALength);
  for I := 0 to ALength - 1 do
  begin
    with AParam[I] do
    begin
      case VType of
        vtInteger:
          AData.Params[I].Str := IntToStr(VInteger);
        vtBoolean:
          AData.Params[I].Str := BoolChar[VBoolean];
        vtChar:
          if VChar = #0 then
            AData.Params[I].Str := ''
          else
            AData.Params[I].Str := string(VChar);
        vtExtended:
          begin
            AExt := VExtended^;
            if (Abs(AExt) < 0.0000000000001) then
              AExt := 0;
            AData.Params[I].Str := FloatToStr(AExt);
          end;
        vtString:
          AData.Params[I].Str := string(VString^);
        vtPointer:
          begin
            if VPointer = nil then
              AError := 'nil'
            else
              AError := IntToHex(Integer(VPointer));
            AError := 'Pointer (' + AError + ')';
          end;
        vtPChar:
          AData.Params[I].Str := string(AnsiChar(VPChar));
        vtInterface:
          if IInterface(VInterface).QueryInterface(IORNetParam, AORNetParam) = S_OK
          then
            AData.Params[I].Int := AORNetParam
          else
            AError := 'Unknown Interface';
        vtObject:
          if VObject is TStrings then
            AData.GetNewList(I).Assign(TStrings(VObject))
          else if VObject.GetInterface(IORNetParam, AORNetParam) then
            AData.Params[I].Int := AORNetParam
          else
            AError := VObject.ClassName + ' Object';
        vtWideChar:
          if VChar = #0 then
            AData.Params[I].Str := ''
          else
            AData.Params[I].Str := string(VWideChar);
        vtAnsiString:
          AData.Params[I].Str := string(VAnsiString);
        vtInt64:
          AData.Params[I].Str := IntToStr(VInt64^);
        vtUnicodeString:
          AData.Params[I].Str := string(VUnicodeString);
      else
        AError := IntToStr(VType);
      end;
    end;
    if AError <> '' then
      raise Exception.Create('Error sending parameters to RPC ' + ARPCName +
      '.  Unable to pass parameter type ' + AError + ' to CallVistA.');
  end;
end;

class function TSimilarNames.IsORComboBoxChanged(
  AORComboBox: TORComboBox): Boolean;
begin
  Result := (GetData(AORCombobox).Value <> AORComboBox.ItemIEN);
end;

function getItemIDFromList(AList: TStrings; AType: TSelector = sPt;
  AExceptions: TStrings = nil): string;
var
  AFrmDupPts: TfrmDupPts;
begin
  Result := '';
  if Assigned(AList) then
  begin
    AFrmDupPts := TfrmDupPts.CreateSelector(AType, AList, AExceptions);
    try
      TSimilarNames.FWasWindowShown := True;
      if AFrmDupPts.ShowModal = mrOK then
        Result := AFrmDupPts.lboSelPt.ItemID;
    finally
      FreeAndNil(AFrmDupPts);
    end;
  end
end;

class function TSimilarNames.CallVistA(AORComboBox: TORComboBox;
  const AParam: array of const;
  ARequireResults: Boolean = False): Boolean;
begin
  TSimilarNames.SaveParams(AORComboBox, RPCName, AParam);
  Result := ORNet.CallVistA(RPCName, AParam, ARequireResults);
end;

class function TSimilarNames.CallVistA(AORComboBox: TORComboBox;
  const AParam: array of const; var AReturn: Integer;
  ARequireResults: Boolean = False; ADefault: Integer = 0): Boolean;
begin
  TSimilarNames.SaveParams(AORComboBox, RPCName, AParam);
  Result := ORNet.CallVistA(RPCName, AParam, AReturn, ARequireResults,
    ADefault);
end;

class function TSimilarNames.CallVistA(AORComboBox: TORComboBox;
  const AParam: array of const; var AReturn: Integer;
  ADefault: Integer; ARequireResults: Boolean = False): Boolean;
begin
  TSimilarNames.SaveParams(AORComboBox, RPCName, AParam);
  Result := ORNet.CallVistA(RPCName, AParam, AReturn, ADefault,
    ARequireResults);
end;

class function TSimilarNames.CallVistA(AORComboBox: TORComboBox;
  const AParam: array of const; var AReturn: Double;
  ARequireResults: Boolean = False; ADefault: Double = 0.0): Boolean;
begin
  TSimilarNames.SaveParams(AORComboBox, RPCName, AParam);
  Result := ORNet.CallVistA(RPCName, AParam, AReturn, ARequireResults,
    ADefault);
end;

class function TSimilarNames.CallVistA(AORComboBox: TORComboBox;
  const AParam: array of const; var AReturn: Double;
  ADefault: Double; ARequireResults: Boolean = False): Boolean;
begin
  TSimilarNames.SaveParams(AORComboBox, RPCName, AParam);
  Result := ORNet.CallVistA(RPCName, AParam, AReturn, ADefault,
    ARequireResults);
end;

class function TSimilarNames.CallVistA(AORComboBox: TORComboBox;
  const AParam: array of const; var AReturn: string;
  ARequireResults: Boolean = False; ADefault: string = ''): Boolean;
begin
  TSimilarNames.SaveParams(AORComboBox, RPCName, AParam);
  Result := ORNet.CallVistA(RPCName, AParam, AReturn, ARequireResults,
    ADefault);
end;

class function TSimilarNames.CallVistA(AORComboBox: TORComboBox;
  const AParam: array of const; var AReturn: string;
  ADefault: string; ARequireResults: Boolean = False): Boolean;
begin
  TSimilarNames.SaveParams(AORComboBox, RPCName, AParam);
  Result := ORNet.CallVistA(RPCName, AParam, AReturn, ADefault,
    ARequireResults);
end;

class function TSimilarNames.CallVistA(AORComboBox: TORComboBox;
  const AParam: array of const; AReturn: TStrings;
  ARequireResults: Boolean = False): Boolean;
begin
  TSimilarNames.SaveParams(AORComboBox, RPCName, AParam);
  Result := ORNet.CallVistA(RPCName, AParam, AReturn, ARequireResults);
end;

type
  TSNRPCInfo = record
    RPCName: string;
    ParamIndex: integer;
  end;

function CheckForSimilarName(AORComboBox: TORComboBox; out AErrorMsg: string;
  ASelectorType: TSelector; AExceptions: TStrings = nil): Boolean;

  function InternalLookup(AStringList: TStringList): Boolean;
  // Result = Success

    function GetDataStr(AIndex: Integer): string;
    begin
      Result := AORComboBox.Items.Strings[AIndex];
      if AORComboBox.LookupPiece = 0 then
      begin
        Result := AORComboBox.DisplayText[AIndex] +
          AORComboBox.Delimiter + Result;
      end;
    end;

  var
    ALookupName, ALastName, AFirstName, S: string;
    I, J: Integer;
  begin
    Result := False;

    // If we are at the start or the end of the list there might be others, so make the call
    if (AORComboBox.ItemIndex <= 0) or
      (AORComboBox.ItemIndex = AORComboBox.Items.Count - 1) then
      Exit(False);

    ALookupName := AORComboBox.LookupString[AORComboBox.ItemIndex];
    ALastName := Piece(ALookupName, ',', 1);
    AFirstName := Copy(Piece(ALookupName, ',', 2), 0, 2);

    if (Trim(AFirstName) = '') or (Trim(ALastName) = '') then
      Exit(False);

    // Add selected entry
    AStringList.Add(GetDataStr(AORComboBox.ItemIndex));

    // Look through the stringlist from the selected item to the end
    for I := AORComboBox.ItemIndex + 1 to AORComboBox.Items.Count - 1 do
    begin
      ALookupName := AORComboBox.LookupString[I];
      if (ALastName = Piece(ALookupName, ',', 1)) and
        (AFirstName = Copy(Piece(ALookupName, ',', 2), 0, 2)) then
      begin
        AStringList.Add(GetDataStr(I))
      end else begin
        // Item is not a match
        Result := True;
        Break;
      end;
    end;
    // The rest of the list contains only matches, so we can't do an internal lookup and we need to ask for more
    if not Result then Exit;

    // Look through the stringlist from the selected item to the beginning
    Result := False;
    // Lookup for previous
    for I := AORComboBox.ItemIndex - 1 downto 0 do
    begin
      ALookupName := AORComboBox.LookupString[I];
      if (ALastName = Piece(ALookupName, ',', 1)) and
        (AFirstName = Copy(Piece(ALookupName, ',', 2), 0, 2)) then
      begin
        AStringList.Add(GetDataStr(I))
      end else begin
        // Item is not a match
        Result := True;
        Break;
      end;
    end;
    // The previous part of the list contains only matches, so we can't do an internal lookup and we need to ask for more
    if not Result then Exit;

    if AORComboBox.LookupPiece = 0 then
    begin
      SortByPiece(AStringList, AORComboBox.Delimiter, 1);
      for I := 0 to AStringList.Count - 1 do
      begin
        S := AStringList[I];
        J := Pos(AORComboBox.Delimiter, S);
        Delete(S, 1, J);
        AStringList[I] := S;
      end;
    end else begin
      SortByPiece(AStringList, AORComboBox.Delimiter, AORComboBox.LookupPiece);
    end;
  end;

var
  I: Integer;
  AORNetMult: IORNetMult;
  AParams: TArray<TVarRec>;
  ADUZ: string;
  AStringList: TStringList;
  AID: Int64;
  AData: TSNComboBoxData;
begin
  TSimilarNames.FWasWindowShown := False;
  AErrorMsg := '';

  if not TSimilarNames.Enabled then
    Exit(True); // if SimilarNames functionality is not enabled
  if not AORComboBox.CanFocus then
    Exit(True); // The box is invisible, or disabled. The user could not edit it.
  if AORComboBox.ItemIEN = 0 then
    Exit(True); // If no AID is selected
  if AORComboBox.ItemIEN = User.DUZ then
    Exit(True); // If they select themselves then no similar name fumnctionality is invoked
  AData := TSimilarNames.GetData(AORComboBox);
  if AData.RPC = '' then
    Exit(True); // The RPC was never called. Similar names functionality can't be invoked
  if not TSimilarNames.IsORComboBoxChanged(AORComboBox) then
    Exit(True); // The ComboBox ItemIEN hasn't changed since the last time it was registered

  AID := -1;
  AStringList := TStringList.Create;
  try
    // Try to look internally first
    if not InternalLookup(AStringList) then // comment out this line to force the RPC call!
    begin
      // First, Copy AData.Params to Params
      SetLength(AParams, Length(AData.Params));
      AORNetMult := nil;
      for I := Low(AData.Params) to High(AData.Params) do
      begin
        if Assigned(AData.Params[I].List) then
        begin
          AParams[I].VType := vtObject;
          AParams[I].VObject := AData.Params[I].List;
        end
        else if Assigned(AData.Params[I].Int) then
        begin
          AParams[I].VType := vtInterface;
          AParams[I].VInterface := AData.Params[I].Int;
          if not Assigned(AORNetMult) then
          begin
            // If we've found an ORNetMult we need to hold on to it.
            if not IInterface(AParams[I].VInterface).QueryInterface(IORNetMult,
              AORNetMult) = S_OK then
              AORNetMult := nil;
          end;
        end else begin
          AParams[I].VType := vtUnicodeString;
          AParams[I].VUnicodeString := Pointer(AData.Params[I].Str);
        end;
      end;

      if not Assigned(AORNetMult) then
        raise Exception.Create('Parameter of type IORNetMult was not found') ;

      // Set the specific similar name params to the correct values
      AORNetMult.AddSubscript('FROM', AORComboBox.ItemIEN);
      AORNetMult.AddSubscript('DIR', 1);
      AORNetMult.AddSubscript('SPN', 1);

      // Clear the stringlist and use it to do the VISTA call
      AStringList.Clear;
      CallVistA(AData.RPC, AParams, AStringList);
    end;

    case AStringList.Count of
      // No other users
      0:
        AErrorMsg := 'The name selected is not a CPRS user name allowable ' +
          'for entry in this field. Please Select another name.';
      // Only 1
      1:
        begin
          ADUZ := Piece(AStringList[0], U, 1);
          if ADUZ = IntToStr(AORComboBox.ItemIEN) then
            AID := AORComboBox.ItemIEN
          else
            AErrorMsg := 'LookupSimilarName:' + #13#10#13#10 + 'Search for DUZ=' +
              IntToStr(AORComboBox.ItemIEN) +
              ' returns one record with DUZ=' + ADUZ;
        end
    else
      // Let the user pick the correct user from the list of more than 1
      AID := StrToInt64Def(getItemIDFromList(AStringList, ASelectorType,
        AExceptions), -1);
    end;
  finally
    FreeAndNil(AStringList);
  end;

  // Set the results
  TSimilarNames.RegORComboBox(AORComboBox, AID);
  // Register with the value we are about to set
  if AORComboBox.ItemIEN <> AID then
  begin
    // The user picked something different (might have even clicked cancel) => set the results
    AORComboBox.SelectByIEN(AID); // Important: even if AID = -1 we need to set!
    if AID >= 0 then
    begin
      if AORComboBox.ItemIndex < 0 then
        AORComboBox.SetExactByIEN(AID, ExternalName(AID, 200));
      if Assigned(AORComboBox.OnChange) then
        AORComboBox.OnChange(AORComboBox);
      // Do not call OnChange for setting to -1, because it would end up calling OnChange twice
    end;
  end;

  Result := AID >= 0;
end;

end.
