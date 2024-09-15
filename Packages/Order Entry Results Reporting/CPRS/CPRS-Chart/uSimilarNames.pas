unit uSimilarNames;

{ ------------------------------------------------------------------------------
  Extention of ORCtrl.TORComboBox.
  Verifies if there are names "similar" to the selected one.
  If so - requests confirmation of the selection.
  NSR#20110606 (Similar Provider/Cosigner names)
  ---------------------------------------------------------------------------- }
interface

uses
  ORCtrls,
  System.Classes,
  WinApi.Windows,
  Controls,
  System.Generics.Collections,
  ORNetIntf;

const
  SN_ORWU_NEWPERS = 'ORWU NEWPERS';
  SN_ORWU2_COSIGNER = 'ORWU2 COSIGNER';
  SN_ORWTPP_GETCOS = 'ORWTPP GETCOS';

type
  TSelector = (sPt, sPr, sCo, sUnknown);
    // sPr - provider
    // sCo - cosigner
    // sPt - patient

  TSNRec = record
    str: string;
    int: IORNetParam;
    list: TStringList;
  end;

  TSNParamList = TArray<TSNRec>;

  TSNComboBoxData = class(TObject)
  private
    FValue: Int64;
    FRPC: string;
    FParams: TSNParamList;
    procedure ClearParams;
    procedure SetParamLength(len: integer);
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
    class procedure SaveParams(AORComboBox: TORComboBox; const RPCName: string;
      const aParam: array of const);
  public
    class constructor Create;
    class function IsORComboBoxChanged(AORComboBox: TORComboBox): boolean;
    class procedure RegORComboBox(AORComboBox: TORComboBox; AValue: Int64 = 0);
    class property WasWindowShown: boolean read FWasWindowShown; // Was a similarnames window shown during the last similarnames call?
    class property Enabled: boolean read FEnabled write FEnabled;
  end;

function SNCallVistA(AORComboBox: TORComboBox; const aRPCName: string;
  const aParam: array of const; RequireResults: Boolean = False)
  : Boolean; overload;
function SNCallVistA(AORComboBox: TORComboBox; const aRPCName: string;
  const aParam: array of const; var aReturn: Integer;
  RequireResults: Boolean = False; aDefault: Integer = 0): Boolean; overload;
function SNCallVistA(AORComboBox: TORComboBox; const aRPCName: string;
  const aParam: array of const; var aReturn: Integer; aDefault: Integer;
  RequireResults: Boolean = False): Boolean; overload;
function SNCallVistA(AORComboBox: TORComboBox; const aRPCName: string;
  const aParam: array of const; var aReturn: Double;
  RequireResults: Boolean = False; aDefault: Double = 0.0): Boolean; overload;
function SNCallVistA(AORComboBox: TORComboBox; const aRPCName: string;
  const aParam: array of const; var aReturn: Double; aDefault: Double;
  RequireResults: Boolean = False): Boolean; overload;
function SNCallVistA(AORComboBox: TORComboBox; const aRPCName: string;
  const aParam: array of const; var aReturn: string;
  RequireResults: Boolean = False; aDefault: string = ''): Boolean; overload;
function SNCallVistA(AORComboBox: TORComboBox; const aRPCName: string;
  const aParam: array of const; var aReturn: string; aDefault: string;
  RequireResults: Boolean = False): Boolean; overload;
function SNCallVistA(AORComboBox: TORComboBox; const aRPCName: string;
  const aParam: array of const; aReturn: TStrings;
  RequireResults: Boolean = False): Boolean; overload;

 // String return since Patient DNF is string while Provider is Int64
 function getItemIDFromList(aList: TStrings; aType: TSelector = sPt;
  anExceptions: TStrings = nil): String;

function CheckForSimilarName(aCmbBox: TORComboBox; out aErrMsg: String;
  aSelectorType: TSelector; anExceptions: TStrings = nil): Boolean;

implementation

uses
//  System.Generics.Defaults,
  rCore,
  uCore,
  System.UITypes,
  Vcl.Dialogs,
  System.SysUtils,
  ORFn,
  fDupPts,
  ORNet;

const
  fmtInvalidItemSelected =
    'The name selected is not a CPRS user name allowable for entry in this %s field.';
  fmtMultipleItemNames =
    'The %s name selected is not unique. The name confirmation is required.';

type
  TSNRPCInfo = record
    RPCName: string;
    ParamIndex: integer;
  end;

const
  SN_RPC_TBL: array [0 .. 2] of TSNRPCInfo =
    ((RPCName: SN_ORWU_NEWPERS; ParamIndex: 7),
     (RPCName: SN_ORWU2_COSIGNER; ParamIndex: 5),
     (RPCName: SN_ORWTPP_GETCOS; ParamIndex: 3));

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
  FParams[Index].list := Result;
end;

procedure TSNComboBoxData.SetParamLength(len: integer);
var
  i, old: integer;

begin
  old := High(FParams);
  for i := len to old do
    FreeAndNil(FParams[i].list);
  SetLength(FParams, len);
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
  if assigned(AORComboBox) then
  begin
    if not assigned(AORComboBox.Data) then
      AORComboBox.Data := TSNComboBoxData.Create;
    Result := AORComboBox.Data as TSNComboBoxData;
  end;
end;

class procedure TSimilarNames.RegORComboBox(AORComboBox: TORComboBox;
  AValue: Int64 = 0);
var
  val: Int64;

begin
  if AValue = 0 then
  begin
    if assigned(AORComboBox) and
      (not(csDestroying in AORComboBox.ComponentState)) then
      val := AORComboBox.ItemIEN
    else
      val := 0;
  end
  else
    val := AValue;
  GetData(AORComboBox).Value := val;
end;

class procedure TSimilarNames.SaveParams(AORComboBox: TORComboBox;
  const RPCName: string; const aParam: array of const);
var
  i, len: Integer;
  TmpExt: Extended;
  aORNetParam: IORNetParam;
  Error: String;
  data: TSNComboBoxData;

begin
  data := GetData(AORComboBox);
  data.ClearParams;
  data.RPC := RPCName;
  Error := '';
  len := Length(aParam);
  data.SetParamLength(len);
  for i := 0 to len - 1 do
  begin
    with aParam[i] do
    begin
      case VType of
        vtInteger:
          data.Params[i].str := IntToStr(VInteger);
        vtBoolean:
          data.Params[i].str := BoolChar[VBoolean];
        vtChar:
          if VChar = #0 then
            data.Params[i].str := ''
          else
            data.Params[i].str := string(VChar);
        vtExtended:
          begin
            TmpExt := VExtended^;
            if (abs(TmpExt) < 0.0000000000001) then
              TmpExt := 0;
            data.Params[i].str := FloatToStr(TmpExt);
          end;
        vtString:
          data.Params[i].str := string(VString^);
        vtPointer:
          begin
            if VPointer = nil then
              Error := 'nil'
            else
              Error := IntToHex(Integer(VPointer));
            Error := 'Pointer (' + Error + ')';
          end;
        vtPChar:
          data.Params[i].str := string(AnsiChar(VPChar));
        vtInterface:
          if IInterface(VInterface).QueryInterface(IORNetParam, aORNetParam) = S_OK
          then
            data.Params[i].int := aORNetParam
          else
            Error := 'Unknown Interface';
        vtObject:
          if VObject is TStrings then
            data.GetNewList(i).Assign(TStrings(VObject))
          else if VObject.GetInterface(IORNetParam, aORNetParam) then
            data.Params[i].int := aORNetParam
          else
            Error := VObject.ClassName + ' Object';
        vtWideChar:
          if VChar = #0 then
            data.Params[i].str := ''
          else
            data.Params[i].str := string(VWideChar);
        vtAnsiString:
          data.Params[i].str := string(VAnsiString);
        vtInt64:
          data.Params[i].str := IntToStr(VInt64^);
        vtUnicodeString:
          data.Params[i].str := string(VUnicodeString);
      else
        Error := IntToStr(VType);
      end; { case }
    end; { with }
    if Error <> '' then
      raise Exception.Create('Error sending parameters to RPC ' + RPCName +
      '.  Unable to pass parameter type ' + Error + ' to CallVistA.');
  end; { for }
end;

class function TSimilarNames.IsORComboBoxChanged(
  AORComboBox: TORComboBox): boolean;
begin
  Result := (GetData(AORCombobox).Value <> AORComboBox.ItemIEN);
end;

function getItemIDFromList(aList: TStrings; aType: TSelector = sPt;
  anExceptions: TStrings = nil): String;
var
  frmDupPts: TfrmDupPts;
begin
  Result := '';
  if assigned(aList) then
  begin
    frmDupPts := TfrmDupPts.CreateSelector(aType, aList, anExceptions);
    try
      TSimilarNames.FWasWindowShown := True;
      if frmDupPts.ShowModal = mrOK then
        Result := frmDupPts.lboSelPt.ItemID;
    finally
      frmDupPts.Release;
    end;
  end
end;

function SNCallVistA(AORComboBox: TORComboBox; const aRPCName: string;
  const aParam: array of const; RequireResults: Boolean = False)
  : Boolean; overload;
begin
  TSimilarNames.SaveParams(AORComboBox, aRPCName, aParam);
  Result := CallVistA(aRPCName, aParam, RequireResults);
end;

function SNCallVistA(AORComboBox: TORComboBox; const aRPCName: string;
  const aParam: array of const; var aReturn: Integer;
  RequireResults: Boolean = False; aDefault: Integer = 0): Boolean; overload;
begin
  TSimilarNames.SaveParams(AORComboBox, aRPCName, aParam);
  Result := CallVistA(aRPCName, aParam, aReturn, RequireResults, aDefault);
end;

function SNCallVistA(AORComboBox: TORComboBox; const aRPCName: string;
  const aParam: array of const; var aReturn: Integer; aDefault: Integer;
  RequireResults: Boolean = False): Boolean; overload;
begin
  TSimilarNames.SaveParams(AORComboBox, aRPCName, aParam);
  Result := CallVistA(aRPCName, aParam, aReturn, aDefault, RequireResults);
end;

function SNCallVistA(AORComboBox: TORComboBox; const aRPCName: string;
  const aParam: array of const; var aReturn: Double;
  RequireResults: Boolean = False; aDefault: Double = 0.0): Boolean; overload;
begin
  TSimilarNames.SaveParams(AORComboBox, aRPCName, aParam);
  Result := CallVistA(aRPCName, aParam, aReturn, RequireResults, aDefault);
end;

function SNCallVistA(AORComboBox: TORComboBox; const aRPCName: string;
  const aParam: array of const; var aReturn: Double; aDefault: Double;
  RequireResults: Boolean = False): Boolean; overload;
begin
  TSimilarNames.SaveParams(AORComboBox, aRPCName, aParam);
  Result := CallVistA(aRPCName, aParam, aReturn, aDefault, RequireResults);
end;

function SNCallVistA(AORComboBox: TORComboBox; const aRPCName: string;
  const aParam: array of const; var aReturn: string;
  RequireResults: Boolean = False; aDefault: string = ''): Boolean; overload;
begin
  TSimilarNames.SaveParams(AORComboBox, aRPCName, aParam);
  Result := CallVistA(aRPCName, aParam, aReturn, RequireResults, aDefault);
end;

function SNCallVistA(AORComboBox: TORComboBox; const aRPCName: string;
  const aParam: array of const; var aReturn: string; aDefault: string;
  RequireResults: Boolean = False): Boolean; overload;
begin
  TSimilarNames.SaveParams(AORComboBox, aRPCName, aParam);
  Result := CallVistA(aRPCName, aParam, aReturn, aDefault, RequireResults);
end;

function SNCallVistA(AORComboBox: TORComboBox; const aRPCName: string;
  const aParam: array of const; aReturn: TStrings;
  RequireResults: Boolean = False): Boolean; overload;
begin
  TSimilarNames.SaveParams(AORComboBox, aRPCName, aParam);
  Result := CallVistA(aRPCName, aParam, aReturn, RequireResults);
end;

function CheckForSimilarName(aCmbBox: TORComboBox; out aErrMsg: String;
  aSelectorType: TSelector; anExceptions: TStrings = nil): Boolean;

  function InternalLookup(var aSl: TStrings): Boolean;
  var
    aLookupName, aLastName, aFirstName, txt: string;
    i, j: integer;

    function GetDispStr(idx: integer): string;
    begin
      if aCmbBox.LookupPiece = 0 then
        Result := aCmbBox.DisplayText[idx]
      else
        Result := Piece(aCmbBox.Items.Strings[idx],
          aCmbBox.Delimiter, aCmbBox.LookupPiece);
    end;

    function GetDataStr(idx: integer): string;
    begin
      Result := aCmbBox.Items.Strings[idx];
      if aCmbBox.LookupPiece = 0 then
        Result := aCmbBox.DisplayText[idx] + aCmbBox.Delimiter + Result;
    end;

  begin
    Result := False;

    // If we are at the start or the end of the list there might be others, so make the call
    if (aCmbBox.ItemIndex <= 0) or (aCmbBox.ItemIndex = aCmbBox.Items.Count - 1) then
      Exit;

    aLookupName := GetDispStr(aCmbBox.ItemIndex);
    aLastName := Piece(aLookupName, ',', 1);
    aFirstName := Copy(Piece(aLookupName, ',', 2), 0, 2);

    if (Trim(aFirstName) = '') or (Trim(aLastName) = '') then
      Exit;

    aSl := TStringList.Create;
    // Add selected entry
    aSl.Add(GetDataStr(aCmbBox.ItemIndex));

    // Gather the other names for the return
    i := aCmbBox.ItemIndex + 1;
    while i <= aCmbBox.Items.Count - 1 do
    begin
      aLookupName := GetDispStr(i);
      if (aLastName = Piece(aLookupName, ',', 1)) and
        (aFirstName = Copy(Piece(aLookupName, ',', 2), 0, 2)) then
        aSl.Add(GetDataStr(i))
      else
      begin
        Result := True;
        Break;
      end;
      Inc(i);
    end;

    // Rest of the list contaisn same last name so we need to ask for more
    if not Result then
    begin
      FreeAndNil(aSl);
      Exit;
    end;

    // Ensure that we dont have any others in this list
    Result := False;

    // Lookup for previous
    i := aCmbBox.ItemIndex - 1;
    while i >= 0 do
    begin
      aLookupName := GetDispStr(i);
      if (aLastName = Piece(aLookupName, ',', 1)) and
        (aFirstName = Copy(Piece(aLookupName, ',', 2), 0, 2)) then
        aSl.Add(GetDataStr(i))
      else
      begin
        Result := True;
        Break;
      end;
      Dec(i);
    end;

    // We dont know if the list could contain other last name so we need to ask for more
    if not Result then
    begin
      if assigned(aSl) then
        FreeAndNil(aSl);
      Exit;
    end;

    if aCmbBox.LookupPiece = 0 then
    begin
      SortByPiece(aSl, aCmbBox.Delimiter, 1);
      for i := 0 to aSl.Count - 1do
      begin
        txt := aSl[i];
        j := pos(aCmbBox.Delimiter, txt);
        delete(txt, 1, j);
        aSl[i] := txt;
      end;
    end
    else
      SortByPiece(aSl, aCmbBox.Delimiter, aCmbBox.LookupPiece);
  end;

const
  DirectionParamIndex = 1;

var
  i, ParamCount: integer;
  ACmbBoxItemIEN, EmptyString, SimilarNameString: string;
  SimilarNameParamIndex: integer;
  Params: TArray<TVarRec>;
  sDUZ: String;
  SL: TStrings;
  ID: Int64;
  Data: TSNComboBoxData;

begin
  TSimilarNames.FWasWindowShown := False;
  aErrMsg := '';
  Result := True;

  if not TSimilarNames.Enabled then
    Exit(True); // if SimilarNames functionality is not enabled
  if not aCmbBox.CanFocus then
    Exit(True); // The box is invisible, or diabled. The user could not edit it.
  if aCmbBox.ItemIEN = 0 then
    Exit(True); // If no ID is selected
  if aCmbBox.ItemIEN = User.DUZ then
    Exit(True); // If they select themselves then it's ok
  Data := TSimilarNames.GetData(aCmbBox);
  if Data.RPC = '' then
    Exit; // RPC never called
  if not TSimilarNames.IsORComboBoxChanged(aCmbBox) then
    Exit(True);
  // The ComboBox wasn't changed since the last time it was registered

  ID := -1;
  SL := nil;
  try
    // Try to look internally first
    if not InternalLookup(SL) then
    begin
      ParamCount := Length(Data.Params);

      // Make sure the size of the array = at least 8 (newpers) or 6 (cosigner)
      SetLength(Params, ParamCount);

      SimilarNameParamIndex := -1;
      for i := Low(SN_RPC_TBL) to High(SN_RPC_TBL) do
        if Data.RPC = SN_RPC_TBL[i].RPCName then
        begin
          SimilarNameParamIndex := SN_RPC_TBL[i].ParamIndex;
          break;
        end;
      if SimilarNameParamIndex < 0 then
      begin
        // If you see this error, you need to add the new VISTA call to this
        // if then else statement
        raise Exception.CreateFmt
          ('CheckForSimilarName called with an invalid RPC Name = %s',
          [Data.RPC]);
      end;

      if ParamCount < (SimilarNameParamIndex + 1) then
      begin
        SetLength(Params, SimilarNameParamIndex + 1);

        // Fill the just expanded part of the array with empty strings
        EmptyString := '';
        for i := ParamCount to High(Params) do
        begin
          Params[i].VType := vtUnicodeString;
          Params[i].VUnicodeString := Pointer(EmptyString);
        end;
      end;

      // Set Param[0] to the ItemIEN of the passed in ORComboBox
      ACmbBoxItemIEN := IntToStr(aCmbBox.ItemIEN);
      Params[0].VType := vtUnicodeString;
      Params[0].VUnicodeString := Pointer(ACmbBoxItemIEN);

      // Set all other params to the passed in values
      for i := 1 to ParamCount - 1 do
      begin
        if (i = DirectionParamIndex) or (i = SimilarNameParamIndex) then
          continue;
        if assigned(Data.Params[i].list) then
        begin
          Params[i].VType := vtObject;
          Params[i].VObject := Data.Params[i].list;
        end
        else if assigned(Data.Params[i].int) then
        begin
          Params[i].VType := vtInterface;
          Params[i].VInterface := Data.Params[i].int;
        end
        else
        begin
          Params[i].VType := vtUnicodeString;
          Params[i].VUnicodeString := Pointer(Data.Params[i].str);
        end;
      end;

      // Set the similar name parameter in the array to True
      SimilarNameString := '1';
      Params[SimilarNameParamIndex].VType := vtUnicodeString;
      Params[SimilarNameParamIndex].VUnicodeString := Pointer(SimilarNameString);
      // Set the Direction parameter in the array to 1 (forward)
      Params[DirectionParamIndex].VType := vtUnicodeString;
      Params[DirectionParamIndex].VUnicodeString := Pointer(SimilarNameString);
      // happens to be 1

      // Create a stringlist and use it to do the VISTA call
      if assigned(SL) then
        SL.Clear
      else
        SL := TStringList.Create;
      try
        CallVistA(Data.RPC, Params, SL);
      except
        FreeAndNil(SL);
        raise;
      end;
    end;

    // In case of no list
    if not assigned(SL) then
      Exit;

    case SL.Count of
      // No other users
      0:
        aErrMsg := Format(fmtInvalidItemSelected, ['']) +
          ' Please Select another name';
      // Only 1
      1:
        begin
          sDUZ := Piece(SL[0], U, 1);
          if sDUZ = IntToStr(aCmbBox.ItemIEN) then
            ID := aCmbBox.ItemIEN
          else
            aErrMsg := 'LookupSimilarName:' + #13#10#13#10 + 'Search for DUZ=' +
              IntToStr(aCmbBox.ItemIEN) +
              ' returns one record with DUZ=' + sDUZ;
        end
    else
      // Pick the correct user from the list of more than 1
      ID := StrToInt64Def(getItemIDFromList(SL, aSelectorType, anExceptions), -1);
    end;
  finally
    if assigned(SL) then
      SL.Free;
  end;

  // Set the results
  TSimilarNames.RegORComboBox(aCmbBox, ID);
  // Register with the value we are about to set
  if aCmbBox.ItemIEN <> ID then
  begin
    // The user picked something different (might have even clicked cancel) => set the results
    aCmbBox.SelectByIEN(ID); // Important: even if ID = -1 we need to set!
    if ID >= 0 then
    begin
      if aCmbBox.ItemIndex < 0 then
        aCmbBox.SetExactByIEN(ID, ExternalName(ID, 200));
      if assigned(aCmbBox.OnChange) then
        aCmbBox.OnChange(aCmbBox);
      // Do not call OnChange for setting to -1, because it would end up calling OnChange twice
    end;
  end;

  Result := ID >= 0;
end;

end.
