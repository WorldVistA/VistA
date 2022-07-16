unit uSimilarNames;

{ ------------------------------------------------------------------------------
  Extention of ORCtrl.TORComboBox.
  Verifies if there are names "similar" to the selected one.
  If so - requests confirmation of the selection.
  NSR#20110606 (Similar Provider/Cosigner names)
  ---------------------------------------------------------------------------- }
interface

uses
  Vcl.Forms,
  ORCtrls,
  System.Classes,
  WinApi.Windows,
  controls;

type
  TFMDateTime = Double;
  TSelector = (sPt, sPr, sCo, sUnknown);
    // sPr - provider
    // sCo - cosigner
    // sPt - patient

  TLookupType = (ltPerson, ltProvider, ltCosign, ltUnknown,
    ltPDMPAuthorizedUser);

type
  TSimilarNames = class(TObject)
  strict private
    class procedure EnsureORComboBoxRegs;
  private
    class var FWasWindowShown: boolean;
  public
    class function IsORComboBoxChanged(AORComboBox: TORComboBox): boolean;
    class procedure RegORComboBox(AORComboBox: TORComboBox; AValue: Int64 = 0);
    class property WasWindowShown: boolean read FWasWindowShown; // Was a similarnames window shown during the last similarnames call?
  end;

function getItemIDFromList(aList: TStrings; aType: TSelector = sPt;
  anExceptions: TStrings = nil): Int64;

function CheckForSimilarName(aCmbBox: TOrComboBox; Var aErrMsg: String;
  aLookupSource: TLookupType; aSelectorType: TSelector; aValidationDate: String = '';
  anExceptions: TStrings = nil; aTitleIEN: Int64 = 0): Boolean; overload;

function CheckForSimilarName(aCmbBox: TOrComboBox; Var aErrMsg: String;
  aLookupSource: TLookupType;
  VistaParams: TArray<string>; aSelectorType: TSelector; aValidationDate: String = '';
  anExceptions: TStrings = nil; aTitleIEN: Int64 = 0): Boolean; overload;

Var
  SimilarNameEnabled: Boolean;

implementation

uses
  System.Generics.Defaults,
  System.Generics.Collections,
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
{$IFDEF DEBUG_AA}
  fmtInvalidDUZ =
    'The provided DUZ (%d) does not match a CPRS user name allowable for entry in this field.'
    + #13#10 + 'Please select another name.';
{$ENDIF}

type
  TORComboBoxReg = class(TObject)
  strict private
    FORComboBox: TORComboBox;
    FValue: Int64;
  public
    constructor Create(AORComboBox: TORComboBox; AValue: Int64 = 0);
    procedure UpdateValue(AORComboBox: TORComboBox; AValue: Int64 = 0);
    property ORComboBox: TORComboBox read FORComboBox;
    property Value: Int64 read FValue write FValue;
  end;

  TORComboBoxRegComparer = class(TComparer<TORComboBoxReg>)
  private
    FComparer: IComparer<TObject>;
  public
    constructor Create;
    destructor Destroy; override;
    function Compare(const Left, Right: TORComboBoxReg): Integer; override;
  end;

  TORComboBoxRegs = class(TComponent)
  strict private
    FList: TObjectList<TORComboBoxReg>; // This list must always be sorted!!!
    FComparer: IComparer<TORComboBoxReg>;
  strict protected
    property Comparer: IComparer<TORComboBoxReg> read FComparer;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Reg(AORComboBox: TORComboBox; AValue: Int64 = 0);
    procedure Unreg(AORComboBox: TORComboBox); overload;
    function IsORComboBoxChanged(AORComboBox: TORComboBox): boolean;
  end;

var
  ORComboBoxRegs: TORComboBoxRegs;

constructor TORComboBoxReg.Create(AORComboBox: TORComboBox; AValue: Int64 = 0);
begin
  inherited Create;
  FORComboBox := AORComboBox;
  UpdateValue(AORComboBox, AValue);
end;

procedure TORComboBoxReg.UpdateValue(AORComboBox: TORComboBox;
  AValue: Int64 = 0);
begin
  if AValue = 0 then
  begin
    if Assigned(AORComboBox) and
      (not (csDestroying in AORComboBox.ComponentState)) then
    begin
      // This goes wrong when the combobox is being destroyed!
      FValue := FORComboBox.ItemIEN;
    end else begin
      FValue := 0;
    end;
  end else begin
    FValue := AValue;
  end;
end;

constructor TORComboBoxRegComparer.Create;
begin
  inherited Create;
  FComparer := TComparer<TObject>.Default;
end;

destructor TORComboBoxRegComparer.Destroy;
begin
  FComparer := nil;
  inherited Destroy;
end;

function TORComboBoxRegComparer.Compare(const Left,
  Right: TORComboBoxReg): Integer;
begin
  Result := FComparer.Compare(Left.ORComboBox, Right.ORComboBox);
end;

constructor TORComboBoxRegs.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FComparer := TORComboBoxRegComparer.Create;
  FList := TObjectList<TORComboBoxReg>.Create(Comparer, True);
end;

destructor TORComboBoxRegs.Destroy;
begin
  FreeAndNil(FList);
  FComparer := nil;
  inherited Destroy;
end;

procedure TORComboBoxRegs.Reg(AORComboBox: TORComboBox;
  AValue: Int64 = 0);
// Registers an ORCombobox and sets it value
// This either finds a TORComboBoxReg already in the list or
// creates a new TORComboBoxReg and adds it to the list (if not found)
// It also sets the start value, either to the passed in string, or to the
// value currently displaying in the box
var
  I: Integer;
  AORComboBoxReg: TORComboBoxReg;
  WasAlreadyRegistered: boolean;
begin
  if not Assigned(AORCombobox) then Exit;
  WasAlreadyRegistered := True;
  AORComboBoxReg := TORComboBoxReg.Create(AORComboBox, AValue);
  try
    if FList.BinarySearch(AORComboBoxReg, I, Comparer) then
    begin
      FList[I].UpdateValue(AORComboBox, AValue);
    end else begin
      AORComboBox.FreeNotification(Self);
      FList.Insert(I, AORComboBoxReg);
      WasAlreadyRegistered := False;
    end;
  finally
    if WasAlreadyRegistered then FreeAndNil(AORComboBoxReg);
  end;
end;

procedure TORComboBoxRegs.Unreg(AORComboBox: TORComboBox);
// Unregister a TORCombobox
var
  I: Integer;
  AORComboBoxReg: TORComboBoxReg;
begin
  if not Assigned(AORComboBox) then Exit;
  AORComboBoxReg := TORComboBoxReg.Create(AORComboBox);
  try
    if FList.BinarySearch(AORComboBoxReg, I, Comparer) then FList.Delete(I);
  finally
    FreeAndNil(AORComboBoxReg);
  end;
end;

function TORComboBoxRegs.IsORComboBoxChanged(AORComboBox: TORComboBox): boolean;
// 1. Check if combobox is registered.
//   - If not, register, and consider it changed (Result = True)
//   - If changed...
// 2. Check if registered combobox's value is current value
//   - If not, Result = True
//   - If, Result = False
var
  I: Integer;
  AORComboBoxReg: TORComboBoxReg;
  WasAlreadyRegistered: boolean;
begin
  if not Assigned(AORCombobox) then Exit(False);
  WasAlreadyRegistered:= True;
  AORComboBoxReg := TORComboBoxReg.Create(AORComboBox);
  try
    if FList.BinarySearch(AORComboBoxReg, I, Comparer) then
    begin
      // It was registered
      Result := FList[I].Value <> AORComboBox.ItemIEN;
    end else begin
      // It was not registered
      AORComboBox.FreeNotification(Self);
      FList.Insert(I, AORComboBoxReg);
      WasAlreadyRegistered := False;
      Result := True;
    end;
  finally
    if WasAlreadyRegistered then FreeAndNil(AORComboBoxReg);
  end;
end;

procedure TORComboBoxRegs.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (Operation = opRemove) and (AComponent is TORComboBox) then
  begin
    Unreg(TORComboBox(AComponent));
  end;
  inherited;
end;

class procedure TSimilarNames.EnsureORComboBoxRegs;
// Make sure the ORComboBoxRegs global (but local) variable is initialized
begin
  if not Assigned(ORComboBoxRegs) then
    ORComboBoxRegs := TORComboBoxRegs.Create(nil);
end;

class procedure TSimilarNames.RegORComboBox(AORComboBox: TORComboBox;
  AValue: Int64 = 0);
// Registers an ORCombobox for use with similar names. An IEN can be passed in,
// or the IEN, of the current value of the combobox is used.
// If you just want to update the value of the combobox without triggering
// similarnames functionality consequences, use this method too.
begin
  EnsureORComboBoxRegs;
  ORComboBoxRegs.Reg(AORComboBox, AValue);
end;

class function TSimilarNames.IsORComboBoxChanged(
  AORComboBox: TORComboBox): boolean;
// Returns True is the ORComboBox has changed value since it was last seen by
// similar names
begin
  EnsureORComboBoxRegs;
  Result := ORComboBoxRegs.IsORComboBoxChanged(AORComboBox);
end;

function getItemIDFromList(aList: TStrings; aType: TSelector = sPt;
  anExceptions: TStrings = nil): Int64;
var
  frmDupPts: TfrmDupPts;
begin
  Result := -1;
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

function DoCheckForSimilarName(aCmbBox: TOrComboBox; Var aErrMsg: String;
  aLookupSource: TLookupType; VistaParams: TArray<string>;
  aSelectorType: TSelector; aValidationDate: String = '';
  anExceptions: TStrings = nil; aTitleIEN: Int64 = 0): Boolean;

 Function InternalLookup(var aSl: TStrings): Boolean;
 var
  aLookupName, aLastName, aFirstName: String;
  I: Integer;
 begin
  Result := false;

  //If we are at the start or the end of the list there might be others, so make the call
  if (aCmbBox.ItemIndex = 0) or (aCmbBox.ItemIndex = aCmbBox.Items.Count - 1) or (aCmbBox.LookupPiece = 0) then
  begin
    exit;
  end;

  aLookupName := Piece(aCmbBox.Items.Strings[aCmbBox.ItemIndex], aCmbBox.Delimiter, aCmbBox.LookupPiece);
  aLastName := Piece(aLookupName, ',', 1);
  aFirstName := Copy(Piece(aLookupName, ',', 2), 0, 2);

  if (Trim(aFirstName) = '') or (Trim(aLastName) = '') then
  begin
    exit;
  end;

  aSl := TStringList.Create;
  //Add selected entry
  aSl.Add(aCmbBox.Items.Strings[aCmbBox.ItemIndex]);

  //Gather the other names for the return
  I := aCmbBox.ItemIndex + 1;
  While I <= aCmbBox.Items.Count - 1 do
  begin
    aLookupName := Piece(aCmbBox.Items.Strings[I], aCmbBox.Delimiter, aCmbBox.LookupPiece);
    if (aLastName = Piece(aLookupName, ',', 1)) and (aFirstName = Copy(Piece(aLookupName, ',', 2), 0, 2)) then
      aSl.Add(aCmbBox.Items.Strings[I])
    else begin
      Result := true;
      break;
    end;
    Inc(I);
  end;

  //Rest of the list contaisn same last name so we need to ask for more
  if not Result then
  begin
    if Assigned(aSl) then
      FreeAndNil(aSl);
    exit;
  end;

  //Ensure that we dont have any others in this list
  Result := False;

  //Lookup for previous
  I := aCmbBox.ItemIndex - 1;
  While I >= 0 do
  begin
    aLookupName := Piece(aCmbBox.Items.Strings[I], aCmbBox.Delimiter, aCmbBox.LookupPiece);
    if (aLastName = Piece(aLookupName, ',', 1)) and (aFirstName = Copy(Piece(aLookupName, ',', 2), 0, 2)) then
      aSl.Add(aCmbBox.Items.Strings[I])
    else begin
      Result := True;
      break;
    end;
    Dec(I);
  end;

  //We dont know if the list could contain other last name so we need to ask for more
  if not Result then
  begin
    if Assigned(aSl) then
      FreeAndNil(aSl);
    exit;
  end;

  SortByPiece(aSl, aCmbBox.Delimiter, aCmbBox.LookupPiece);
 end;

var
  I, ParamCount: integer;
  ACmbBoxItemIEN, EmptyString, SimilarNameString: string;
  SimilarNameParamIndex: integer;
  DirectionParamIndex: integer;
  Params: TArray<TVarRec>;
  sDUZ: String;
  SL: TStrings;
  ID: Int64;
begin
  TSimilarNames.FWasWindowShown := False;
  aErrMsg := '';
  Result := true;
  SL := nil;

  if not SimilarNameEnabled then Exit(True); // if SimilarNames functionality is not enabled
  if not aCmbBox.CanFocus then Exit(True); // The box is invisible, or diabled. The user could not edit it.
  if aCmbBox.ItemIEN = 0 then Exit(True); // If no ID is selected
  if aCmbBox.ItemIEN = User.DUZ then Exit(True); //If they select themselves then it's ok
  if not TSimilarNames.IsORComboBoxChanged(aCmbBox) then Exit(True); // The ComboBox wasn't changed since the last time it was registered

  ID := -1;
  //Try to look internally first
  if not InternalLookup(SL) then
  begin
    if (Length(VistaParams) > 1) and
      (
        (VistaParams[0] = 'ORWU NEWPERS') or
        (VistaParams[0] = 'ORWU2 COSIGNER')
      ) then
    begin
      // We received a list of parameters. We are using that to do the call
      // Unfortunately, we have to deal with an array of const...
      // Warning: while the TVarRecs in the array are being used, it is
      // imperative that the local string variables that are used to fill it
      // do NOT go out of scope, so it is not a good idea to split this
      // functionality off into a local procedure!

      ParamCount := Length(VistaParams) - 1;

      // Make sure the size of the array = at least 8 (newpers) or 6 (cosigner)
      SetLength(Params, ParamCount);
      if (VistaParams[0] = 'ORWU NEWPERS') then begin
        if ParamCount < 8 then SetLength(Params, 8);
        SimilarNameParamIndex := 7;
        DirectionParamIndex := 1;
      end else begin
        if (VistaParams[0] = 'ORWU2 COSIGNER') then
        begin
          if ParamCount < 6 then SetLength(Params, 6);
          SimilarNameParamIndex := 5;
          DirectionParamIndex := 1;
        end else begin
          // If you see this error, you need to add the new VISTA call to this
          // if then else statement
          raise Exception.CreateFmt('SimilarName- and DirectionParamIndex '+
            'not set because VistaParams[0] = %s', [VistaParams[0]]);
        end;
      end;

      // Fill the just expanded part of the array with empty strings
      EmptyString := '';
      for I := ParamCount to High(Params) do
      begin
        Params[I].VType := vtUnicodeString;
        Params[I].VUnicodeString := Pointer(EmptyString);
      end;

      // Set Param[0] to the ItemIEN of the passed in ORComboBox
      ACmbBoxItemIEN := IntToStr(aCmbBox.ItemIEN);
      Params[0].VType := vtUnicodeString;
      Params[0].VUnicodeString := Pointer(ACmbBoxItemIEN);

      // Set all other params to the passed in values
      for I := 1 to ParamCount-1 do
      begin
        Params[I].VType := vtUnicodeString;
        Params[I].VUnicodeString := Pointer(VistaParams[I+1]);
      end;

      // Set the similar name parameter in the array to True
      SimilarNameString := '1';
      Params[SimilarNameParamIndex].VType := vtUnicodeString;
      Params[SimilarNameParamIndex].VUnicodeString := Pointer(SimilarNameString);
      // Set the Direction parameter in the array to 1 (forward)
      Params[DirectionParamIndex].VType := vtUnicodeString;
      Params[DirectionParamIndex].VUnicodeString := Pointer(SimilarNameString); // happens to be 1

      // Create a stringlist and use it to do the VISTA call
      SL := TStringList.Create;
      try
        CallVistA(VistaParams[0], Params, SL);
      except
        FreeAndNil(SL);
        raise;
      end;
      // Only now it is safe for variables used in the Params array to go out
      // of scope, as the Vista call has been made.
    end else begin
      //grab similar of the same kind
      case aLookupSource of
        ltPerson: SL := SubsetOfActiveAndInactivePersonsWithSimilarNames(aCmbBox.ItemIEN, aValidationDate);
        ltProvider: SL := setSubSetOfProvidersWithSimilarNames(aCmbBox.ItemIEN, aValidationDate);
        ltCosign: SL := SubsetOfCosignersWithSimilarNames(aCmbBox.ItemIEN, MakeFMDateTime(aValidationDate), aTitleIEN);
        ltPDMPAuthorizedUser: SL := setSubSetOfPDMPAuthorizedUsersWithSimilarNames(aCmbBox.ItemIEN, aValidationDate);
      else
        // If you see this error, you need to add the new LookupSource to the case statement
        raise Exception.CreateFmt('Unknown LookupSource %d', [Ord(aLookupSource)]);
      end;
    end;
  end;

  //In case of no list
  if not Assigned(SL) then
    exit;

  Try
    case SL.Count of
      //No other users
      0: aErrMsg := Format(fmtInvalidItemSelected, ['']) + ' Please Select another name';
      //Only 1
      1:
        begin
          sDUZ := Piece(SL[0], U, 1);
          if sDUZ = IntToStr(aCmbBox.ItemIEN) then
            ID := aCmbBox.ItemIEN
          else
            aErrMsg := 'LookupSimilarName:' + #13#10#13#10 + 'Search for DUZ=' + IntToStr(aCmbBox.ItemIEN) + ' returns one record with DUZ=' + sDUZ;
        end
    else
      //Pick the correct user from the list of more than 1
      ID := getItemIDFromList(SL, aSelectorType, anExceptions);
    end;
  Finally
    if Assigned(SL) then
      SL.Free;
  End;

  TSimilarNames.RegORComboBox(aCmbBox, ID); // Register with the value we are about to set
  if aCmbBox.ItemIEN <> ID then
  begin
    // The user picked something different (might have even clicked cancel) => set the results
    aCmbBox.SelectByIEN(ID); // Important: even if ID = -1 we need to set!
    if ID >= 0 then begin
      if aCmbBox.ItemIndex < 0 then aCmbBox.SetExactByIEN(ID, ExternalName(ID, 200));
      if Assigned(aCmbBox.OnChange) then aCmbBox.OnChange(aCmbBox); // Do not call OnChange for setting to -1, because it would end up calling OnChange twice
    end;
  end;

  Result := Id >= 0;
end;

function CheckForSimilarName(aCmbBox: TOrComboBox; Var aErrMsg: String;
  aLookupSource: TLookupType; aSelectorType: TSelector; aValidationDate: String = '';
  anExceptions: TStrings = nil; aTitleIEN: Int64 = 0): Boolean;
begin
  Result := DoCheckForSimilarName(aCmbBox, aErrMsg,
    aLookupSource, [], aSelectorType, aValidationDate,
    anExceptions, aTitleIEN);
end;

function CheckForSimilarName(aCmbBox: TOrComboBox; Var aErrMsg: String;
  aLookupSource: TLookupType; // I want to get rid of this, but it's used as "backup" right now in case VistaParams is empty
  VistaParams: TArray<string>;
  aSelectorType: TSelector; aValidationDate: String = '';
  anExceptions: TStrings = nil; aTitleIEN: Int64 = 0): Boolean;
begin
  Result := DoCheckForSimilarName(aCmbBox, aErrMsg,
    aLookupSource, VistaParams, aSelectorType, aValidationDate,
    anExceptions, aTitleIEN);
end;

initialization
  TSimilarNames.FWasWindowShown := False;
finalization
  FreeAndNil(ORComboBoxRegs);
end.
