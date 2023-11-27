unit rODAllergy;

//{$O-}

interface

uses SysUtils, Classes, ORNet, ORFn, rCore, uCore, TRPCB, dialogs, rMisc, fNotes,
     VAUtils;

type
  TAllergyRec = record
    Changed:             boolean;
    IEN:                 Integer;
    CausativeAgent:      string;
    AllergyType:         string;
    NatureOfReaction:    string;
    SignsSymptoms:       TStringList;
    Originator:          int64;
    OriginatorName:      string;
    Originated:          TFMDateTime;
    Comments:            TStringList;
    IDBandMarked:        TStringList;
    ChartMarked:         TStringList;
    Verifier:            int64;
    VerifierName:        string;
    Verified:            boolean;
    VerifiedDateTime:    TFMDateTime;
    EnteredInError:      boolean;
    DateEnteredInError:  TFMDateTime;
    UserEnteringInError: int64;
    ErrorComments:       TStringList;
    Observed_Historical: string;
    Observations:        TStringList;
    ReactionDate:        TFMDateTime;
    Severity:            string;
    NoKnownAllergies:    Boolean;
    NewComments:         TStringList;
  end;

  TARTPatchInstalled = record
    PatchInstalled: boolean;
    PatchChecked: boolean;
  end;

  TGMRASiteParams = record
    MarkIDBandFlag:              Boolean;
    OriginatorCommentsRequired:  Boolean;
    ErrorCommentsEnabled:        Boolean;
    ParamsSet:                   Boolean;
  end;

  TARTClinUser = record
    IsClinUser: boolean;
    ReasonFailed: string;
    AccessChecked: boolean;
  end;

function setAllergiesByTarget(aTarget: string;aDest: TStrings): Integer;
function setSubsetofSymptoms(const StartFrom: string; Direction: Integer;const aList: TStrings): integer;
function setAllergiesDefaults(aDest:TSTrings): Integer;

function GetCWADInfo(const DFN: string): string;
function SaveAllergy(EditRec: TAllergyRec): string;
function LoadAllergyForEdit(AllergyIEN: integer): TAllergyRec;
function SendARTBulletin(AFreeTextEntry: string; AComment: TStringList): string;
function RPCEnterNKAForPatient: string;

// site parameter functions
function ARTPatchInstalled: boolean;
function GetSiteParams: TGMRASiteParams;
function MarkIDBand: boolean;
function RequireOriginatorComments: boolean;
function EnableErrorComments: boolean;
function IsARTClinicalUser(var AMessage: string): boolean;
function GetAllergyTitleText: string;

implementation

uses
  ORNetIntf, uConst;

const
  NO_YES: array[Boolean] of string = ('NO', 'YES');

var
  uARTPatchInstalled: TARTPatchInstalled;
  uGMRASiteParams: TGMRASiteParams;
  uARTClinUser: TARTClinUser;

function setSubsetofSymptoms(const StartFrom: string; Direction: Integer;const aList: TStrings): integer;
begin
  result := -1;
  if assigned(aList) then
    begin
      if CallvistA('ORWDAL32 SYMPTOMS',[StartFrom, Direction],aList) then
        Result := aList.Count
      else
        Result := 0;
    end;
end;

function setAllergiesDefaults(aDest:TSTrings): Integer;
begin
  Result := -1;
  if CallVistA('ORWDAL32 DEF',[nil],aDest) then
    Result := aDest.Count;
end;

function setAllergiesByTarget(aTarget: string;aDest: TStrings): Integer;
begin
  Result := -1;
  if CallVistA('ORWDAL32 ALLERGY MATCH',[aTarget],aDest) then
    Result := aDest.Count;
end;

function GetCWADInfo(const DFN: string): string;
begin
  CallVistA('ORWPT CWAD', [DFN], Result);
end;

function LoadAllergyForEdit(AllergyIEN: Integer): TAllergyRec;
var
  Dest: TStringList;
  EditRec: TAllergyRec;
  x: string;
begin
  Dest := TStringList.Create;
  try
    CallvistA('ORWDAL32 LOAD FOR EDIT', [AllergyIEN], Dest);
    if (Dest.Count > 0) and (Piece(Dest[0], U, 1) <> '-1') then
    begin
      with EditRec do
      begin
        Changed := False;
        IEN := AllergyIEN;
        CausativeAgent := ExtractDefault(Dest, 'CAUSATIVE AGENT');
        AllergyType := ExtractDefault(Dest, 'ALLERGY TYPE');
        NatureOfReaction := ExtractDefault(Dest, 'NATURE OF REACTION');
        SignsSymptoms := TStringList.Create;
        ExtractItems(SignsSymptoms, Dest, 'SIGN/SYMPTOMS');
        MixedCaseByPiece(SignsSymptoms, U, 4);
        x := ExtractDefault(Dest, 'ORIGINATOR');
        Originator := StrToInt64Def(Piece(x, U, 1), 0);
        OriginatorName := Piece(x, U, 2);
        Originated := StrToFMDateTime(ExtractDefault(Dest, 'ORIGINATED'));
        Comments := TStringList.Create;
        ExtractText(Comments, Dest, 'COMMENTS');
        IDBandMarked := TStringList.Create;
        ExtractItems(IDBandMarked, Dest, 'ID BAND MARKED');
        ChartMarked := TStringList.Create;
        ExtractItems(ChartMarked, Dest, 'CHART MARKED');
        // x                   := ExtractDefault(Dest, 'VERIFIER');
        // Verifier            := StrToInt64Def(Piece(x, U, 1), 0);
        // VerifierName        := Piece(x, U, 2);
        // x                   := ExtractDefault(Dest, 'VERIFIED');
        // Verified            := Piece(x, U, 1) = 'YES';
        // if Verified then
        // VerifiedDateTime  := StrToFMDateTime(Piece(x, U, 2));
        x := ExtractDefault(Dest, 'ENTERED IN ERROR');
        EnteredInError := Piece(x, U, 1) = 'YES';
        DateEnteredInError := StrToFloatDef(Piece(x, U, 2), 0);
        UserEnteringInError := StrToInt64Def(Piece(x, U, 3), 0);
        ErrorComments := TStringList.Create;
        Observed_Historical := ExtractDefault(Dest, 'OBS/HIST');
        Observations := TStringList.Create;
        ExtractText(Observations, Dest, 'OBSERVATIONS');
        // ReactionDate        := StrToFMDateTime(Piece(ExtractDefault(Dest, 'REACTDT'), U, 3));
        // Severity            := Piece(ExtractDefault(Dest, 'SEVERITY'), U, 3);
        NoKnownAllergies :=
          (StrToIntDef(Piece(ExtractDefault(Dest, 'NKA'), U, 3), 0) > 0);
        NewComments := TStringList.Create;
      end;
    end
    else
      EditRec.IEN := -1;
    result := EditRec;
  finally
    Dest.Free;
  end;
end;

function SaveAllergy(EditRec: TAllergyRec): string;
var
  i: Integer;
  aList: iORNetMult;
  sl: TStrings;
  x, dt3, dt4: string;
  dt: TFMDateTime;

begin
  newORNetMult(aList);
  with EditRec do
  begin
    if NoKnownAllergies then
      aList.AddSubscript(['GMRANKA'], NO_YES[NoKnownAllergies]);
    if CausativeAgent <> '' then
      aList.AddSubscript(['GMRAGNT'], CausativeAgent);
    if AllergyType <> '' then
      aList.AddSubscript(['GMRATYPE'], AllergyType);
    if NatureOfReaction <> '' then
      aList.AddSubscript(['GMRANATR'], NatureOfReaction);
    if Originator > 0 then
      aList.AddSubscript(['GMRAORIG'], Originator);
    if Originated > 0 then
      aList.AddSubscript(['GMRAORDT'], Originated);

    with SignsSymptoms do
      if Count > 0 then
      begin
        aList.AddSubscript(['GMRASYMP', 0], Count);
        dt := GetFMNow;
        dt3 := FloatToStr(dt);
        dt4 := FormatFMDateTime('mmm dd,yyyy@hh:nn', dt);
        for i := 0 to Count - 1 do
        begin
          x := Pieces(Strings[i], U, 1, 5);
          if Piece(x, U, 3) = '' then
          begin
            SetPiece(x, U, 3, dt3);
            SetPiece(x, U, 4, dt4);
          end;
          aList.AddSubscript(['GMRASYMP', i + 1], x);
        end;
      end;

    if EnteredInError then
    begin
      aList.AddSubscript(['GMRAERR'], NO_YES[EnteredInError]);
      aList.AddSubscript(['GMRAERRBY'], UserEnteringInError);
      aList.AddSubscript(['GMRAERRDT'], DateEnteredInError);
      with ErrorComments do
        if Count > 0 then
        begin
          aList.AddSubscript(['GMRAERRCMTS', 0], Count);
          for i := 0 to Count - 1 do
            aList.AddSubscript(['GMRAERRCMTS', i + 1], Strings[i]);
        end;
    end; // RTC 827305

    with ChartMarked do
      if Count > 0 then
      begin
        aList.AddSubscript(['GMRACHT', 0], Count);
        for i := 0 to Count - 1 do
          aList.AddSubscript(['GMRACHT', i + 1], Strings[i]);
      end;

    with IDBandMarked do
      if Count > 0 then
      begin
        aList.AddSubscript(['GMRAIDBN', 0], Count);
        for i := 0 to Count - 1 do
          aList.AddSubscript(['GMRAIDBN', i + 1], Strings[i]);
      end;

    if Length(Observed_Historical) > 0 then
      aList.AddSubscript(['GMRAOBHX'], Observed_Historical);
    if ReactionDate > 0 then
      aList.AddSubscript(['GMRARDT'], ReactionDate);
    if Length(Severity) > 0 then
      aList.AddSubscript(['GMRASEVR'], Severity);

    with NewComments do
      if Count > 0 then
      begin
        aList.AddSubscript(['GMRACMTS', 0], Count);
        for i := 0 to Count - 1 do
          aList.AddSubscript(['GMRACMTS', i + 1], Strings[i]);
      end;

    sl := TStringList.Create;
    try
      CallvistA('ORWDAL32 SAVE ALLERGY', [IEN, Patient.DFN, aList], sl);
      if sl.Count > 0 then
        result := sl[0]
      else
        result := '';
    finally
      sl.Free;
    end;
    // Include "Allergy Entered in Error" items require signature list.
    // cq-8002  -piece 2 is Allergy Entered in Error (IEN)
    // code added allowing v27 GUI changes to continue if M change is not released prior.
    // cq-14842 -  add observed/drug allergies to the fReview/fSignOrders forms for signature.
    if Length(Piece(result, '^', 2)) > 0 then
      Changes.Add(CH_DOC, Piece(result, '^', 2), GetAllergyTitleText, '', CH_SIGN_YES)
  end;
end;

function RPCEnterNKAForPatient: string;
var
  aList: iORNetMult;
  sl: TStrings;
begin
  newORNetMult(aList);
  sl := TStringList.Create;
  aList.AddSubscript(['GMRANKA'], 'YES');
  try
    CallvistA('ORWDAL32 SAVE ALLERGY', ['0', Patient.DFN, aList], sl);
    if sl.Count > 0 then
      result := sl[0]
    else
      result := '';
  finally
    sl.Free;
  end;
end;

function SendARTBulletin(AFreeTextEntry: string; AComment: TStringList): string;
var
  i: Integer;
  aList: iORNetMult;
begin
  if AComment.Count > 0 then
  begin
    newORNetMult(aList);
    for i := 0 to AComment.Count - 1 do
      aList.AddSubscript([Succ(i), 0], AComment[i]);
    aList.AddSubscript(['0'], '^^' + IntToStr(AComment.Count));

    CallvistA('ORWDAL32 SEND BULLETIN', [User.DUZ, Patient.DFN, AFreeTextEntry,
      aList], result);
  end
  else
    CallvistA('ORWDAL32 SEND BULLETIN', [User.DUZ, Patient.DFN,
      AFreeTextEntry], result);
end;

// Site parameter functions

function ARTPatchInstalled: boolean;
begin
  with uARTPatchInstalled do
    if not PatchChecked then
      begin
        PatchInstalled := ServerHasPatch('GMRA*4.0*21');
        PatchChecked := True;
      end;
  Result := uARTPatchInstalled.PatchInstalled;
end;

function GetSiteParams: TGMRASiteParams;
var
  x: string;
begin
  with uGMRASiteParams do
    if not ParamsSet then
      begin
//        x := sCallV('ORWDAL32 SITE PARAMS', [nil]);
        CallVistA('ORWDAL32 SITE PARAMS', [nil],x);
        MarkIDBandFlag := (Piece(x, U, 5) <> '0');
        OriginatorCommentsRequired := (Piece(x, U, 4) = '1');
        ErrorCommentsEnabled := (Piece(x, U, 11) = '1');
        ParamsSet := True;
      end;
  Result := uGMRASiteParams;
end;

function MarkIDBand: boolean;
begin
  Result := GetSiteParams.MarkIDBandFlag;
end;

function RequireOriginatorComments: boolean;
begin
  Result := GetSiteParams.OriginatorCommentsRequired;
end;

function EnableErrorComments: boolean;
begin
  Result := GetSiteParams.ErrorCommentsEnabled;
end;

(*function IsARTClinicalUser(var AMessage: string): boolean;
const
  TX_NO_AUTH = 'You are not authorized to perform this action.' + CRLF +
               'Either the ORES or ORELSE key is required.';
begin
  Result := (User.UserClass > UC_CLERK);     // User has ORES or ORELSE key
  if not Result then AMessage := TX_NO_AUTH else AMessage := '';
end;*)

function IsARTClinicalUser(var AMessage: string): boolean;
const
  TX_NO_AUTH = 'You are not authorized to perform this action.' + CRLF;
var
  x: string;
begin
  with uARTClinUser do
  begin
    if not AccessChecked then
      begin
//        x := sCallV('ORWDAL32 CLINUSER',[nil]);
        CallVistA('ORWDAL32 CLINUSER',[nil],x);
        IsClinUser := (Piece(x, U, 1) = '1');
        if not IsClinUser then ReasonFailed := TX_NO_AUTH + Piece(x, U, 2) else ReasonFailed := '';
        AccessChecked := True;
      end;
    Result   := IsClinUser;
    AMessage := ReasonFailed ;
  end;
end;

function GetAllergyTitleText: string;
begin
    Result := FormatFMDateTime('mmm dd,yy', MakeFMDateTime(floatToStr(FMToday))) +
              '  ' + 'Adverse React/Allergy' + ', ' + Encounter.LocationName + ', ' + User.Name;
end;

end.
