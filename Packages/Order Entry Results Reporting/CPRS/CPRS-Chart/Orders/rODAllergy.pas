unit rODAllergy;

{$O-}

interface

uses SysUtils, Classes, ORNet, ORFn, rCore, uCore, TRPCB, dialogs, rMisc,fNotes ;

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

function SearchForAllergies(StringToMatch: string): TStrings;
function SubsetofSymptoms(const StartFrom: string; Direction: Integer): TStrings;
function ODForAllergies: TStrings;
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

const
  NO_YES: array[Boolean] of string = ('NO', 'YES');

var
  uARTPatchInstalled: TARTPatchInstalled;
  uGMRASiteParams: TGMRASiteParams;
  uARTClinUser: TARTClinUser;

function ODForAllergies: TStrings;
begin
  CallV('ORWDAL32 DEF',[nil]);
  Result := RPCBrokerV.Results;
end;

function SearchForAllergies(StringToMatch: string): TStrings;
begin
  CallV('ORWDAL32 ALLERGY MATCH',[StringToMatch]);
  Result := RPCBrokerV.Results;
end;

function SubsetofSymptoms(const StartFrom: string; Direction: Integer): TStrings;
begin
  Callv('ORWDAL32 SYMPTOMS',[StartFrom, Direction]);
  Result := RPCBrokerV.Results;
end;

function GetCWADInfo(const DFN: string): string;
begin
  Result := sCallV('ORWPT CWAD',[DFN]);
end;

function LoadAllergyForEdit(AllergyIEN: integer): TAllergyRec;
var
  Dest: TStringList;
  EditRec: TAllergyRec;
  x: string;
begin
  Dest := TStringList.Create;
  try
    tCallV(Dest, 'ORWDAL32 LOAD FOR EDIT', [AllergyIEN]) ;
    if Piece(RPCBrokerV.Results[0], U, 1) <> '-1' then
    begin
      with EditRec do
        begin
          Changed             := False;
          IEN                 := AllergyIEN;
          CausativeAgent      := ExtractDefault(Dest, 'CAUSATIVE AGENT');
          AllergyType         := ExtractDefault(Dest, 'ALLERGY TYPE');
          NatureOfReaction    := ExtractDefault(Dest, 'NATURE OF REACTION');
          SignsSymptoms       := TStringList.Create;
          ExtractItems(SignsSymptoms, Dest, 'SIGN/SYMPTOMS');
          MixedCaseByPiece(SignsSymptoms, U, 4);
          x                   := ExtractDefault(Dest, 'ORIGINATOR');
          Originator          := StrToInt64Def(Piece(x, U, 1), 0);
          OriginatorName      := Piece(x, U, 2);
          Originated          := StrToFMDateTime(ExtractDefault(Dest, 'ORIGINATED'));
          Comments            := TStringList.Create;
          ExtractText(Comments, Dest, 'COMMENTS');
          IDBandMarked        := TStringList.Create;
          ExtractItems(IDBandMarked, Dest, 'ID BAND MARKED');
          ChartMarked         := TStringList.Create;
          ExtractItems(ChartMarked, Dest, 'CHART MARKED');
          //x                   := ExtractDefault(Dest, 'VERIFIER');
          //Verifier            := StrToInt64Def(Piece(x, U, 1), 0);
          //VerifierName        := Piece(x, U, 2);
          //x                   := ExtractDefault(Dest, 'VERIFIED');
          //Verified            := Piece(x, U, 1) = 'YES';
          //if Verified then
          //  VerifiedDateTime  := StrToFMDateTime(Piece(x, U, 2));
          x                   := ExtractDefault(Dest, 'ENTERED IN ERROR');
          EnteredInError      := Piece(x, U, 1) = 'YES';
          DateEnteredInError  := StrToFloatDef(Piece(x, U, 2), 0);
          UserEnteringInError := StrToInt64Def(Piece(x, U, 3), 0);
          ErrorComments       := TStringList.Create;
          Observed_Historical := ExtractDefault(Dest, 'OBS/HIST');
          Observations        := TStringList.Create;
          ExtractText(Observations, Dest, 'OBSERVATIONS');
          //ReactionDate        := StrToFMDateTime(Piece(ExtractDefault(Dest, 'REACTDT'), U, 3));
          //Severity            := Piece(ExtractDefault(Dest, 'SEVERITY'), U, 3);
          NoKnownAllergies    := (StrToIntDef(Piece(ExtractDefault(Dest, 'NKA'), U, 3), 0) > 0);
          NewComments         := TStringList.Create;
        end;
    end
    else
      EditRec.IEN := -1;
    Result := EditRec;
  finally
    Dest.Free;
  end;
end;

function SaveAllergy(EditRec: TAllergyRec): string;
var
  i: integer;
begin

  with RPCBrokerV, EditRec do
    begin
      ClearParameters := True;
      RemoteProcedure := 'ORWDAL32 SAVE ALLERGY';
      Param[0].PType := literal;
      Param[0].Value := IntToStr(IEN);
      Param[1].PType := literal;
      Param[1].Value := Patient.DFN;
      Param[2].PType := list;
      with Param[2] do
        begin
          if NoKnownAllergies then
            Mult['"GMRANKA"']  := NO_YES[NoKnownAllergies];
          if CausativeAgent <> '' then
            Mult['"GMRAGNT"']  := CausativeAgent;
          if AllergyType <> '' then
            Mult['"GMRATYPE"'] := AllergyType ;
          if NatureOfReaction <> '' then
            Mult['"GMRANATR"'] := NatureOfReaction ;
          if Originator > 0 then
            Mult['"GMRAORIG"'] := IntToStr(Originator);
          if Originated > 0 then
            Mult['"GMRAORDT"'] := FloatToStr(Originated);
          with SignsSymptoms do if Count > 0 then
            begin
              Mult['"GMRASYMP",0'] := IntToStr(Count);
              for i := 0 to Count - 1 do
                Mult['"GMRASYMP",' + IntToStr(i+1)] := Pieces(Strings[i], U, 1, 5);
            end;
          //if Verified then
          //  Mult['"GMRAVER"']  := NO_YES[Verified];
          //if Verifier > 0 then
          //  Mult['"GMRAVERF"'] := IntToStr(Verifier);
          //if VerifiedDateTime > 0 then
          //  Mult['"GMRAVERD"'] := FloatToStr(VerifiedDateTime);
          if EnteredInError then
            begin
              Mult['"GMRAERR"']  := NO_YES[EnteredInError];
              Mult['"GMRAERRBY"']  := IntToStr(UserEnteringInError);
              Mult['"GMRAERRDT"']  := FloatToStr(DateEnteredInError);
              with ErrorComments do if Count > 0 then
                begin
                  Mult['"GMRAERRCMTS",0'] := IntToStr(Count);
                  for i := 0 to Count - 1 do
                    Mult['"GMRAERRCMTS",' + IntToStr(i+1)] := Strings[i];
                end;

            end ;
          with ChartMarked do if Count > 0 then
            begin
              Mult['"GMRACHT",0'] := IntToStr(Count);
              for i := 0 to Count - 1 do
                Mult['"GMRACHT",' + IntToStr(i+1)] := Strings[i];
            end;
          with IDBandMarked do if Count > 0 then
            begin
              Mult['"GMRAIDBN",0'] := IntToStr(Count);
              for i := 0 to Count - 1 do
                Mult['"GMRAIDBN",' + IntToStr(i+1)] := Strings[i];
            end;
          if Length(Observed_Historical) > 0 then
            Mult['"GMRAOBHX"'] :=  Observed_Historical;
          if ReactionDate > 0 then
            Mult['"GMRARDT"']  :=  FloatToStr(ReactionDate);
          if Length(Severity) > 0 then
            Mult['"GMRASEVR"'] :=  Severity;
          with NewComments do if Count > 0 then
            begin
              Mult['"GMRACMTS",0'] := IntToStr(Count);
              for i := 0 to Count - 1 do
                Mult['"GMRACMTS",' + IntToStr(i+1)] := Strings[i];
            end;
        end;
        CallBroker;
        Result := Results[0];
        // Include "Allergy Entered in Error" items require signature list.
        //cq-8002  -piece 2 is Allergy Entered in Error (IEN)
       // code added allowing v27 GUI changes to continue if M change is not released prior.
       //cq-14842 -  add observed/drug allergies to the fReview/fSignOrders forms for signature.
       if Length(Piece(Result,'^',2))> 0 then
         Changes.Add(10, Piece(Result,'^',2), GetAllergyTitleText, '', 1)
       else
          exit;
        end;
end;

function RPCEnterNKAForPatient: string;
begin
  with RPCBrokerV do
    begin
      ClearParameters := True;
      RemoteProcedure := 'ORWDAL32 SAVE ALLERGY';
      Param[0].PType := literal;
      Param[0].Value := '0';
      Param[1].PType := literal;
      Param[1].Value := Patient.DFN;
      Param[2].PType := list;
      with Param[2] do
        Mult['"GMRANKA"']  := 'YES';
      CallBroker;
      Result := Results[0];
    end;
end;

function SendARTBulletin(AFreeTextEntry: string; AComment: TStringList): string;
var
  i: integer;
begin
  with RPCBrokerV do
    begin
      ClearParameters := True;
      RemoteProcedure := 'ORWDAL32 SEND BULLETIN';
      Param[0].PType := literal;
      Param[0].Value := User.DUZ;
      Param[1].PType := literal;
      Param[1].Value := Patient.DFN;
      Param[2].PType := literal;
      Param[2].Value := AFreeTextEntry;
      if AComment.Count > 0 then with Param[3] do
        begin
          PType := list;
          for i := 0 to AComment.Count - 1 do
            Mult[IntToStr(Succ(i)) + ',0'] := AComment[i];
          Mult['0'] := '^^' + IntToStr(AComment.Count);
        end;
      CallBroker;
      Result := Results[0];
    end;
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
        x := sCallV('ORWDAL32 SITE PARAMS', [nil]);
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
        x := sCallV('ORWDAL32 CLINUSER',[nil]);
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
    Result := FormatFMDateTime('dddddd', MakeFMDateTime(floatToStr(FMToday))) +
              '  ' + 'Adverse React/Allergy' + ', ' + Encounter.LocationName + ', ' + User.Name;
end;

end.
