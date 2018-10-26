unit uPCE;

interface

uses Windows, SysUtils, Classes, ORFn, uConst, ORCtrls, ORClasses,UBAGlobals, ComCtrls;

type
  TPCEProviderRec = record
    IEN: int64;
    Name: string;
    Primary: boolean;
    Delete: boolean;
  end;

  TPCEProviderList = class(TORStringList)
  private
    FNoUpdate: boolean;
    FOnPrimaryChanged: TNotifyEvent;
    FPendingDefault: string;
    FPendingUser: string;
    FPCEProviderIEN: Int64;
    FPCEProviderName: string;
    function GetProviderData(Index: integer): TPCEProviderRec;
    procedure SetProviderData(Index: integer; const Value: TPCEProviderRec);
    function GetPrimaryIdx: integer;
    procedure SetPrimaryIdx(const Value: integer);
    procedure SetPrimary(index: integer; Primary: boolean);
  public
    function Add(const S: string): Integer; override;
    function AddProvider(AIEN, AName: string; APrimary: boolean): integer;
    procedure Assign(Source: TPersistent); override;
    function PCEProvider: Int64;
    function PCEProviderName: string;
    function IndexOfProvider(AIEN: string): integer;
    procedure Merge(AList: TPCEProviderList);
    procedure Clear; override;
    procedure Delete(Index: Integer); override;
    function PrimaryIEN: int64;
    function PrimaryName: string;
    function PendingIEN(ADefault: boolean): Int64;
    function PendingName(ADefault: boolean): string;
    property ProviderData[Index: integer]: TPCEProviderRec read GetProviderData
                                                          write SetProviderData; default;
    property PrimaryIdx: integer read GetPrimaryIdx write SetPrimaryIdx;
    property OnPrimaryChanged: TNotifyEvent read FOnPrimaryChanged
                                           write FOnPrimaryChanged;
  end;

  TPCEItem = class(TObject)
  {base class for PCE items}
  private
    FDelete:   Boolean;                          //flag for deletion
    FSend:     Boolean;                          //flag to send to broker
    FComment:  String;
  protected
    procedure SetComment(const Value: String);
  public
//    Provider:  Int64;
    Provider:  Int64;
    Code:      string;
    Category:  string;
    Narrative: string;
    FGecRem: string;
    procedure Assign(Src: TPCEItem); virtual;
    procedure Clear; virtual;
    function DelimitedStr: string; virtual;
    function DelimitedStr2: string; virtual;
    function ItemStr: string; virtual;
    function Match(AnItem: TPCEItem): Boolean;
    function MatchPOV(AnItem: TPCEItem): Boolean;
//    function MatchProvider(AnItem: TPCEItem):Boolean;
    function MatchProvider(AnItem: TPCEItem):Boolean;
    procedure SetFromString(const x: string); virtual;
    function HasCPTStr: string; virtual;
    property Comment: String read FComment write SetComment;
    property GecRem: string read FGecRem write FGecRem;
  end;

  TPCEItemClass = class of TPCEItem;

  TPCEProc = class(TPCEItem)
  {class for procedures}
  public
    FIsOldProcedure: boolean;
    Quantity:  Integer;
    Modifiers: string; // Format Modifier1IEN;Modifier2IEN;Modifier3IEN; Trailing ; needed
//    Provider: Int64; {jm 9/8/99}
    Provider: Int64; {jm 9/8/99}
    procedure Assign(Src: TPCEItem); override;
    procedure Clear; override;
    function DelimitedStr: string; override;
//    function DelimitedStrC: string;
//    function Match(AnItem: TPCEProc): Boolean;
    function ModText: string;
    function ItemStr: string; override;
    procedure SetFromString(const x: string); override;
    procedure CopyProc(Dest: TPCEProc);
    function Empty: boolean;
  end;

  TPCEDiag = class(TPCEItem)
  {class for diagnosis}
  public
    fProvider: Int64; 
    Primary:   Boolean;
    AddProb:   Boolean;
    OldComment: string;
    SaveComment: boolean;
    procedure Assign(Src: TPCEItem); override;
    procedure Clear; override;
    function DelimitedStr: string; override;
    function DelimitedStr2: string; override;
//    function delimitedStrC: string;        
    function ItemStr: string; override;
    procedure SetFromString(const x: string); override;
    procedure Send;
  end;

  TPCEExams = class(TPCEItem)
  {class for Examinations}
  public
//    Provider: Int64;
    Results:   String;
    procedure Assign(Src: TPCEItem); override;
    procedure Clear; override;
    function DelimitedStr: string; override;
//    function delimitedStrC: string;
    function ItemStr: string; override;
    procedure SetFromString(const x: string); override;
    function HasCPTStr: string; override;
  end;


  TPCEHealth = class(TPCEItem)
  {class for Health Factors}
  public
//    Provider: Int64; {jm 9/8/99}
    Level:   string;
    procedure Assign(Src: TPCEItem); override;
    procedure Clear; override;
    function DelimitedStr: string; override;
//    function delimitedStrC: string;        
    function ItemStr: string; override;
    procedure SetFromString(const x: string); override;
    function HasCPTStr: string; override;
  end;

  TPCEImm = class(TPCEItem)  
  {class for immunizations}
  public
//    Provider:        Int64; {jm 9/8/99}
    Series:          String;
    Reaction:        String;
    Refused:         Boolean; //not currently used
    Contraindicated: Boolean;
    procedure Assign(Src: TPCEItem); override;
    procedure Clear; override;
    function DelimitedStr: string; override;
//    function delimitedStrC: string;        
    function ItemStr: string; override;
    procedure SetFromString(const x: string); override;
    function HasCPTStr: string; override;
  end;

  TPCEPat = class(TPCEItem)
  {class for patient Education}
  public
//    Provider: Int64; {jm 9/8/99}
    Level:   String;
    procedure Assign(Src: TPCEItem); override;
    procedure Clear; override;
    function DelimitedStr: string; override;
//    function delimitedStrC: string;        
    function ItemStr: string; override;
    procedure SetFromString(const x: string); override;
    function HasCPTStr: string; override;
  end;

  TPCESkin = class(TPCEItem)  
  {class for skin tests}
  public
//    Provider:  Int64; {jm 9/8/99}
    Results:   String;                   //Do not confuse for reserved word "result"
    Reading:   Integer;
    DTRead:    TFMDateTime;
    DTGiven:   TFMDateTime;
    procedure Assign(Src: TPCEItem); override;
    procedure Clear; override;
    function DelimitedStr: string; override;
//    function delimitedStrC: string;
    function ItemStr: string; override;
    procedure SetFromString(const x: string); override;
    function HasCPTStr: string; override;
  end;

//  TPCEData = class;

  tRequiredPCEDataType = (ndDiag, ndProc, ndSC); {jm 9/9/99}
  tRequiredPCEDataTypes = set of tRequiredPCEDataType;

  //modified: 6/9/99
  //By: Robert Bott
  //Location: ISL
  //Purpose: Changed to allow capture of multiple providers.
  TPCEData = class
  {class for data to be passed to and from broker}
  private
    FUpdated:      boolean;
    FEncDateTime:  TFMDateTime;                    //encounter date & time
    FNoteDateTime: TFMDateTime;                    //Note date & time
    FEncLocation:  Integer;                        //encounter location
    FEncSvcCat:    Char;                           //
    FEncInpatient: Boolean;                        //Inpatient flag
    FEncUseCurr:   Boolean;                        //
    FSCChanged:    Boolean;                        //
    FSCRelated:    Integer;                        //service con. related?
    FAORelated:    Integer;                        //
    FIRRelated:    Integer;                        //
    FECRelated:    Integer;                        //
    FMSTRelated:   Integer;                        //
    FHNCRelated:   Integer;                        //
    FCVRelated:    Integer;                        //
    FSHADRelated:   Integer;                        //
    FCLRelated:    Integer;                        //
    FVisitType:    TPCEProc;                       //
    FProviders:    TPCEProviderList;
    FDiagnoses:    TList;                          //pointer list for diagnosis
    FProcedures:   TList;                          //pointer list for Procedures
    FImmunizations: TList;                         //pointer list for Immunizations
    FSkinTests:     TList;                         //pointer list for skin tests
    FPatientEds:    TList;
    FHealthFactors: TList;
    fExams:         TList;
    FNoteTitle:    Integer;
    FNoteIEN:      Integer;
    FParent:       string;                         // Parent Visit for secondary encounters
    FHistoricalLocation: string;                   // Institution IEN^Name (if IEN=0 Piece 4 = outside location)
    FStandAlone: boolean;
    FStandAloneLoaded: boolean;
    FProblemAdded: Boolean;                         // Flag set when one or more Dx are added to PL

    function GetVisitString: string;
    function GetCPTRequired: Boolean;
    function getDocCount: Integer;
    function MatchItem(AList: TList; AnItem: TPCEItem): Integer;
    function MatchPOVItems(AList: TList; AnItem: TPCEItem): Integer;
    procedure MarkDeletions(PreList: TList; PostList: TStrings);
    procedure SetSCRelated(Value: Integer);
    procedure SetAORelated(Value: Integer);
    procedure SetIRRelated(Value: Integer);
    procedure SetECRelated(Value: Integer);
    procedure SetMSTRelated(Value: Integer);
    procedure SetHNCRelated(Value: Integer);
    procedure SetCVRelated(Value: Integer);
    procedure SetSHADRelated(Value: Integer);
    procedure SetCLRelated(Value: Integer);
    procedure SetEncUseCurr(Value: Boolean);
    function GetHasData: Boolean;
    procedure GetHasCPTList(AList: TStrings);
    procedure CopyPCEItems(Src: TList; Dest: TObject; ItemClass: TPCEItemClass);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure CopyPCEData(Dest: TPCEData);
    function Empty: boolean;
    procedure PCEForNote(NoteIEN: Integer; EditObj: TPCEData);(* overload;
    procedure PCEForNote(NoteIEN: Integer; EditObj: TPCEData; DCSummAdmitString: string); overload;*)
    procedure Save;
    procedure CopyDiagnoses(Dest: TCaptionListView);     // ICDcode^P|S^Category^Narrative^P|S Text
    procedure CopyProcedures(Dest: TCaptionListView);    // CPTcode^Qty^Category^Narrative^Qty Text
    procedure CopyImmunizations(Dest: TCaptionListView); //
    procedure CopySkinTests(Dest: TCaptionListView);     //
    procedure CopyPatientEds(Dest: TCaptionListView);
    procedure CopyHealthFactors(Dest: TCaptionListView);
    procedure CopyExams(Dest: TCaptionListView);
    procedure SetDiagnoses(Src: TStrings; FromForm: boolean = TRUE);       // ICDcode^P|S^Category^Narrative^P|S Text
    procedure SetExams(Src: TStrings; FromForm: boolean = TRUE);
    Procedure SetHealthFactors(Src: TStrings; FromForm: boolean = TRUE);
    procedure SetImmunizations(Src: TStrings; FromForm: boolean = TRUE);   // IMMcode^
    Procedure SetPatientEds(Src: TStrings; FromForm: boolean = TRUE);
    procedure SetSkinTests(Src: TStrings; FromForm: boolean = TRUE);        //
    procedure SetProcedures(Src: TStrings; FromForm: boolean = TRUE);      // CPTcode^Qty^Category^Narrative^Qty Text

    procedure SetVisitType(Value: TPCEProc);     // CPTcode^1^Category^Narrative
    function StrDiagnoses: string;               // Diagnoses: ...
    function StrImmunizations: string;           // Immunizzations: ...
    function StrProcedures: string;              // Procedures: ...
    function StrSkinTests: string;
    function StrPatientEds: string;
    function StrHealthFactors: string;
    function StrExams: string;
    function StrVisitType(const ASCRelated, AAORelated, AIRRelated, AECRelated,
                                AMSTRelated, AHNCRelated, ACVRelated, ASHADRelated, ACLRelated: Integer): string; overload;
    function StrVisitType: string; overload;
    function StandAlone: boolean;
    procedure AddStrData(List: TStrings);
    procedure AddVitalData(Data, List: TStrings);

    function NeededPCEData: tRequiredPCEDataTypes;
    function OK2SignNote: boolean;

    function PersonClassDate: TFMDateTime;
    function VisitDateTime: TFMDateTime;
    function IsSecondaryVisit: boolean;
    function NeedProviderInfo: boolean;

    property HasData:      Boolean  read GetHasData;
    property CPTRequired:  Boolean  read GetCPTRequired;
    property ProblemAdded: Boolean  read FProblemAdded;
    property Inpatient:    Boolean  read FEncInpatient;
    property UseEncounter: Boolean  read FEncUseCurr  write SetEncUseCurr;
    property SCRelated:    Integer  read FSCRelated   write SetSCRelated;
    property AORelated:    Integer  read FAORelated   write SetAORelated;
    property IRRelated:    Integer  read FIRRelated   write SetIRRelated;
    property ECRelated:    Integer  read FECRelated   write SetECRelated;
    property MSTRelated:   Integer  read FMSTRelated  write SetMSTRelated;
    property HNCRelated:   Integer  read FHNCRelated  write SetHNCRelated;
    property CVRelated:    Integer  read FCVRelated  write SetCVRelated;
    property SHADRelated:   Integer  read FSHADRelated write SetSHADRelated;
    property CLRelated:    Integer  read FCLRelated  write SetCLRelated;
    property VisitType:    TPCEProc read FVisitType   write SetVisitType;
    property VisitString:  string   read GetVisitString;
    property VisitCategory:char     read FEncSvcCat   write FEncSvcCat;
    property DateTime:     TFMDateTime read FEncDateTime write FEncDateTime;
    property NoteDateTime: TFMDateTime read FNoteDateTime write FNoteDateTime;
    property Location:     Integer  Read FencLocation;
    property NoteTitle:    Integer read FNoteTitle write FNoteTitle;
    property NoteIEN:      Integer read FNoteIEN write FNoteIEN;
    property DocCOunt:     Integer read GetDocCount;
    property Providers:    TPCEProviderList read FProviders;
    property Parent:       string read FParent write FParent;
    property HistoricalLocation: string read FHistoricalLocation write FHistoricalLocation;
    property Updated: boolean read FUpdated write FUpdated;
  end;

type
  TPCEType = (ptEncounter, ptReminder, ptTemplate);

const
  PCETypeText: array[TPCEType] of string = ('encounter', 'reminder', 'template');

function InvalidPCEProviderTxt(AIEN: Int64; ADate: TFMDateTime): string;
function MissingProviderInfo(PCEEdit: TPCEData; PCEType: TPCEType = ptEncounter): boolean;
function IsOK2Sign(const PCEData: TPCEData; const IEN: integer) :boolean;
function FutureEncounter(APCEData: TPCEData): boolean;
function CanEditPCE(APCEData: TPCEData): boolean;
procedure GetPCECodes(List: TStrings; CodeType: integer);
procedure GetComboBoxMinMax(dest: TORComboBox; var Min, Max: integer);
procedure PCELoadORCombo(dest: TORComboBox); overload;
procedure PCELoadORCombo(dest: TORComboBox; var Min, Max: integer); overload;
function GetPCEDisplayText(ID: string; Tag: integer): string;
procedure SetDefaultProvider(ProviderList: TPCEProviderList; APCEData: TPCEData);
function ValidateGAFDate(var GafDate: TFMDateTime): string;
procedure GetVitalsFromDate(VitalStr: TStrings; PCEObj: TPCEData);
procedure GetVitalsFromNote(VitalStr: TStrings; PCEObj: TPCEData; ANoteIEN: Int64);

type
  TPCEDataCat = (pdcVisit, pdcDiag, pdcProc, pdcImm, pdcSkin, pdcPED, pdcHF,
                 pdcExam, pdcVital, pdcOrder, pdcMH, pdcMST, pdcHNC, pdcWHR, pdcWH);

function GetPCEDataText(Cat: TPCEDataCat; Code, Category, Narrative: string;
                       PrimaryDiag: boolean = FALSE; Qty: integer = 0): string;

const
  PCEDataCatText: array[TPCEDataCat] of string =
                        { dcVisit } ('',
                        { dcDiag  }  'Diagnoses: ',
                        { dcProc  }  'Procedures: ',
                        { dcImm   }  'Immunizations: ',
                        { dcSkin  }  'Skin Tests: ',
                        { dcPED   }  'Patient Educations: ',
                        { dcHF    }  'Health Factors: ',
                        { dcExam  }  'Examinations: ',
                        { dcVital }  '',
                        { dcOrder }  'Orders: ',
                        { dcMH    }  'Mental Health: ',
                        { dcMST   }  'MST History: ',
                        { dcHNC   }  'Head and/or Neck Cancer: ',
                        { dcWHR   }  'Women''s Health Procedure: ',
                        { dcWH    }  'WH Notification: ');

  NoPCEValue = '@';
  TAB_STOP_CHARS = 7;
  TX_NO_VISIT   = 'Insufficient Visit Information';
  TX_NEED_PROV1  = 'The provider responsible for this encounter must be entered before ';
  TX_NEED_PROV2  = ' information may be entered.';
//  TX_NEED_PROV3  = 'you can sign the note.';
  TX_NO_PROV    = 'Missing Provider';
  TX_BAD_PROV   = 'Invalid Provider';
  TX_NOT_ACTIVE = ' does not have an active person class.';
  TX_NOT_PROV   = ' is not a known Provider.';
  TX_MISSING    = 'Required Information Missing';
  TX_REQ1       = 'The following required fields have not been entered:' + CRLF;
  TC_REQ        = 'Required Fields';
  TX_ADDEND_AD  = 'Cannot make an addendum to an addendum' + CRLF +
                  'Please select the parent note or document, and try again.';
  TX_ADDEND_MK  = 'Unable to Make Addendum';
  TX_DEL_CNF    = 'Confirm Deletion';
  TX_IN_AUTH    = 'Insufficient Authorization';
  TX_NOPCE      = '<No encounter information entered>';
  TX_NEED_T     = 'Missing Encounter Information';
  TX_NEED1      = 'This note title is marked to prompt for the following missing' + CRLF +
                  'encounter information:' + CRLF;
  TX_NEED_DIAG  = '  A diagnosis.';
  TX_NEED_PROC  = '  A visit type or procedure.';
  TX_NEED_SC    = '  One or more service connected questions.';
  TX_NEED2      = 'Would you like to enter encounter information now?';
  TX_NEED3      = 'You must enter the encounter information before you can sign the note.';
  TX_NEEDABORT  = 'Document not signed.';
  TX_COS_REQ    = 'A cosigner is required for this document.';
  TX_COS_SELF   = 'You cannot make yourself a cosigner.';
  TX_COS_AUTH   = ' is not authorized to cosign this document.';
  TC_COS        = 'Select Cosigner';

  TAG_IMMSERIES  = 10;
  TAG_IMMREACTION= 20;
  TAG_SKRESULTS  = 30;
  TAG_PEDLEVEL   = 40;
  TAG_HFLEVEL    = 50;
  TAG_XAMRESULTS = 60;
  TAG_HISTLOC    = 70;

{ These piece numbers are used by both the PCE objects and reminders }
  pnumCode           = 2;
  pnumPrvdrIEN       = 2;
  pnumCategory       = 3;
  pnumNarrative      = 4;
  pnumExamResults    = 5;
  pnumSkinResults    = 5;
  pnumHFLevel        = 5;
  pnumImmSeries      = 5;
  pnumProcQty        = 5;
  pnumPEDLevel       = 5;
  pnumDiagPrimary    = 5;
  pnumPrvdrName      = 5;
  pnumProvider       = 6;
  pnumPrvdrPrimary   = 6;
  pnumSkinReading    = 7;
  pnumImmReaction    = 7;
  pnumDiagAdd2PL     = 7;
  pnumSkinDTRead     = 8;
  pnumImmContra      = 8;
  pnumSkinDTGiven    = 9;
  pnumImmRefused     = 9;
  pnumCPTMods        = 9;
  pnumComment        = 10;
  pnumWHPapResult    =11;
  pnumWHNotPurp      =12;

  USE_CURRENT_VISITSTR = -2;

implementation

uses uCore, rPCE, rCore, rTIU, fEncounterFrame, uVitals, fFrame,
     fPCEProvider, rVitals, uReminders, rMisc, uGlobalVar;

const
  FN_NEW_PERSON = 200;

function InvalidPCEProviderTxt(AIEN: Int64; ADate: TFMDateTime): string;
begin
  Result := '';
  if(not CheckActivePerson(IntToStr(AIEN), ADate)) then
    Result := TX_NOT_ACTIVE
  else
  if(not IsUserAProvider(AIEN, ADate)) then
    Result := TX_NOT_PROV;
end;

function MissingProviderInfo(PCEEdit: TPCEData; PCEType: TPCEType = ptEncounter): boolean;
begin
  if(PCEEdit.Empty and (PCEEdit.Location <> Encounter.Location) and (not Encounter.NeedVisit)) then
    PCEEdit.UseEncounter := TRUE;
  Result := NoPrimaryPCEProvider(PCEEdit.Providers, PCEEdit);
  if(Result) then
    InfoBox(TX_NEED_PROV1 + PCETypeText[PCEType] + TX_NEED_PROV2,
            TX_NO_PROV, MB_OK or MB_ICONWARNING);
end;

var
  UNxtCommSeqNum: integer;                             

function IsOK2Sign(const PCEData: TPCEData; const IEN: integer) :boolean;
var
  TmpPCEData: TPCEData;

begin
  if(assigned(PCEData)) then
    PCEData.FUpdated := FALSE;
  if(assigned(PCEData) and (PCEData.VisitString <> '') and
     (VisitStrForNote(IEN) = PCEData.VisitString)) then
  begin
    if(PCEData.FNoteIEN <= 0) then
      PCEData.FNoteIEN := IEN;
    Result := PCEData.OK2SignNote
  end
  else
  begin
    TmpPCEData := TPCEData.Create;
    try
      TmpPCEData.PCEForNote(IEN, nil);
      Result := TmpPCEData.OK2SignNote;
    finally
      TmpPCEData.Free;
    end;
  end;
end;

function FutureEncounter(APCEData: TPCEData): boolean;
begin
  Result := (Int(APCEData.FEncDateTime + 0.0000001) > Int(FMToday + 0.0000001));
end;

function CanEditPCE(APCEData: TPCEData): boolean;
begin
  if(GetAskPCE(APCEData.FEncLocation) = apDisable) then
    Result := FALSE
  else
    Result := (not FutureEncounter(APCEData));
end;

procedure GetComboBoxMinMax(dest: TORComboBox; var Min, Max: integer);
var
  DC: HDC;
  SaveFont: HFont;
  TextSize: TSize;
  TLen, i: integer;
  x: string;

begin
  Min := MaxInt;
  Max := 0;
  DC := GetDC(0);
  try
    SaveFont := SelectObject(DC, dest.Font.Handle);
    try
      for i := 0 to dest.Items.Count-1 do
      begin
        x := dest.DisplayText[i];
        GetTextExtentPoint32(DC, PChar(x), Length(x), TextSize);
        TLen := TextSize.cx;
        if(TLen > 0) and (Min > TLen) then
          Min := TLen;
        if(Max < TLen) then
          Max := TLen;
      end;
    finally
      SelectObject(DC, SaveFont);
    end;
  finally
    ReleaseDC(0, DC);
  end;
  if(Min > Max) then Min := Max;

  inc(Min, ScrollBarWidth + 8);
  inc(Max, ScrollBarWidth + 8);
end;

type
  TListMinMax = (mmMin, mmMax, mmFont);

var
  PCESetsOfCodes: TStringList = nil;
  HistLocations: TORStringList = nil;
  WHNotPurpose: TORStringList = nil;
  WHPapResult: TORStringList = nil;
  WHMammResult: TORStringList = nil;
  WHUltraResult: TORStringList = nil;
const
  SetOfCodesHeader = '{^~Codes~^}';
  SOCHeaderLen = length(SetOfCodesHeader);
  ListMinMax: array[1..7, TListMinMax] of integer =
                          ((0,0,-1),  // TAG_IMMSERIES
                           (0,0,-1),  // TAG_IMMREACTION
                           (0,0,-1),  // TAG_SKRESULTS
                           (0,0,-1),  // TAG_PEDLEVEL
                           (0,0,-1),  // TAG_HFLEVEL
                           (0,0,-1),  // TAG_XAMRESULTS
                           (0,0,-1));  // TAG_HISTLOC
                           
function CodeSetIndex(CodeType: integer): integer;
var
  TempSL: TStringList;
  Hdr: string;

begin
  Hdr := SetOfCodesHeader + IntToStr(CodeType);
  Result := PCESetsOfCodes.IndexOf(Hdr);
  if(Result < 0) then
  begin
    TempSL := TStringList.Create;
    try
      case CodeType of
        TAG_IMMSERIES:   LoadImmSeriesItems(TempSL);
        TAG_IMMREACTION: LoadImmReactionItems(TempSL);
        TAG_SKRESULTS:   LoadSkResultsItems(TempSL);
        TAG_PEDLEVEL:    LoadPEDLevelItems(TempSL);
        TAG_HFLEVEL:     LoadHFLevelItems(TempSL);
        TAG_XAMRESULTS:  LoadXAMResultsItems(TempSL);
        else
          KillObj(@TempSL);
      end;
      if(assigned(TempSL)) then
      begin
        Result := PCESetsOfCodes.Add(Hdr);
        FastAddStrings(TempSL, PCESetsOfCodes);
      end;
    finally
      KillObj(@TempSL);
    end;
  end;
end;

procedure GetPCECodes(List: TStrings; CodeType: integer);
var
  idx: integer;

  begin
  if(CodeType = TAG_HISTLOC) then
  begin
    if(not assigned(HistLocations)) then
    begin
      HistLocations := TORStringList.Create;
      LoadHistLocations(HistLocations);
      HistLocations.SortByPiece(2);
      HistLocations.Insert(0,'0');
    end;
    FastAddStrings(HistLocations, List);
  end
  else
  begin
    if(not assigned(PCESetsOfCodes)) then
      PCESetsOfCodes := TStringList.Create;
    idx := CodeSetIndex(CodeType);
    if(idx >= 0) then
    begin
      inc(idx);
      while((idx < PCESetsOfCodes.Count) and
            (copy(PCESetsOfCodes[idx],1,SOCHeaderLen) <> SetOfCodesHeader)) do
      begin
        List.Add(PCESetsOfCodes[idx]);
        inc(idx);
      end;
    end;
  end;
end;

function GetPCECodeString(CodeType: integer; ID: string): string;
var
  idx: integer;

begin
  Result := '';
  if(CodeType <> TAG_HISTLOC) then
  begin
    if(not assigned(PCESetsOfCodes)) then
      PCESetsOfCodes := TStringList.Create;
    idx := CodeSetIndex(CodeType);
    if(idx >= 0) then
    begin
      inc(idx);
      while((idx < PCESetsOfCodes.Count) and
            (copy(PCESetsOfCodes[idx],1,SOCHeaderLen) <> SetOfCodesHeader)) do
      begin
        if(Piece(PCESetsOfCodes[idx], U, 1) = ID) then
        begin
          Result := Piece(PCESetsOfCodes[idx], U, 2);
          break;
        end;
        inc(idx);
      end;
    end;
  end;
end;

procedure PCELoadORComboData(dest: TORComboBox; GetMinMax: boolean; var Min, Max: integer);
var
  idx: integer;

begin
  if(dest.items.count < 1) then
  begin
    dest.Clear;
    GetPCECodes(dest.Items, dest.Tag);
    dest.itemindex := 0;
    if(GetMinMax) and (dest.Items.Count > 0) then
    begin
      idx := dest.Tag div 10;
      if(idx > 0) and (idx < 8) then
      begin
        if(ListMinMax[idx, mmFont] <> integer(dest.Font.Handle)) then
        begin
          GetComboBoxMinMax(dest, Min, Max);
          ListMinMax[idx, mmMin] := Min;
          ListMinMax[idx, mmMax] := Max;
        end
        else
        begin
          Min := ListMinMax[idx, mmMin];
          Max := ListMinMax[idx, mmMax];
        end;
      end;
    end;
  end;
end;

procedure PCELoadORCombo(dest: TORComboBox);
var
  tmp: integer;

begin
  PCELoadORComboData(dest, FALSE, tmp, tmp);
end;

procedure PCELoadORCombo(dest: TORComboBox; var Min, Max: integer);
begin
  PCELoadORComboData(dest, TRUE, Min, Max);
end;

function GetPCEDisplayText(ID: string; Tag: integer): string;
var
  Hdr: string;
  idx: integer;
  TempSL: TStringList;

begin
  Result := '';
  if(Tag = TAG_HISTLOC) then
  begin
    if(not assigned(HistLocations)) then
    begin
      HistLocations := TORStringList.Create;
      LoadHistLocations(HistLocations);
      HistLocations.SortByPiece(2);
      HistLocations.Insert(0,'0');
    end;
    idx := HistLocations.IndexOfPiece(ID);
    if(idx >= 0) then
      Result := Piece(HistLocations[idx], U, 2);
  end
  else
  begin
    if(not assigned(PCESetsOfCodes)) then
      PCESetsOfCodes := TStringList.Create;
    Hdr := SetOfCodesHeader + IntToStr(Tag);
    idx := PCESetsOfCodes.IndexOf(Hdr);
    if(idx < 0) then
    begin
      TempSL := TStringList.Create;
      try
        case Tag of
          TAG_IMMSERIES:   LoadImmSeriesItems(TempSL);
          TAG_IMMREACTION: LoadImmReactionItems(TempSL);
          TAG_SKRESULTS:   LoadSkResultsItems(TempSL);
          TAG_PEDLEVEL:    LoadPEDLevelItems(TempSL);
          TAG_HFLEVEL:     LoadHFLevelItems(TempSL);
          TAG_XAMRESULTS:  LoadXAMResultsItems(TempSL);
          else
            KillObj(@TempSL);
        end;
        if(assigned(TempSL)) then
        begin
          idx := PCESetsOfCodes.Add(Hdr);
          FastAddStrings(TempSL, PCESetsOfCodes);
        end;
      finally
        KillObj(@TempSL);
      end;
    end;
    if(idx >= 0) then
    begin
      inc(idx);
      while((idx < PCESetsOfCodes.Count) and
            (copy(PCESetsOfCodes[idx],1,SOCHeaderLen) <> SetOfCodesHeader)) do
      begin
        if(Piece(PCESetsOfCodes[idx], U, 1) = ID) then
        begin
          Result := Piece(PCESetsOfCodes[idx], U, 2);
          break;
        end;
        inc(idx);
      end;
    end;
  end;
end;

function GetPCEDataText(Cat: TPCEDataCat; Code, Category, Narrative: string;
                       PrimaryDiag: boolean = FALSE; Qty: integer = 0): string;
begin
  Result := '';
  case Cat of
    pdcVisit: if Code <> '' then Result := Category + ' ' + Narrative;
    pdcDiag:  begin
               Result := GetDiagnosisText(Narrative, Code);
               if PrimaryDiag then Result := Result + ' (Primary)';
             end;
    pdcProc: begin
              Result := Narrative;
              if Qty > 1 then Result := Result + ' (' + IntToStr(Qty) + ' times)';
            end;
    else Result := Narrative;
  end;
end;

procedure SetDefaultProvider(ProviderList: TPCEProviderList; APCEData: TPCEData);
var
  SIEN, tmp: string;
  DefUser, AUser: Int64;
  UserName: string;

begin
  DefUser := Encounter.Provider;
  if(DefUser <> 0) and (InvalidPCEProviderTxt(DefUser, APCEData.PersonClassDate) <> '') then
    DefUser := 0;
  if(DefUser <> 0) then
  begin
    AUser := DefUser;
    UserName := Encounter.ProviderName;
  end
  else
  if(InvalidPCEProviderTxt(User.DUZ, APCEData.PersonClassDate) = '') then
  begin
    AUser := User.DUZ;
    UserName := User.Name;
  end
  else
  begin
    AUser := 0;
    UserName := '';
  end;
  if(AUser = 0) then
    ProviderList.FPendingUser := ''
  else
    ProviderList.FPendingUser := IntToStr(AUser) + U + UserName;
  ProviderList.FPendingDefault := '';
  tmp := DefaultProvider(APCEData.Location, DefUser, APCEData.PersonClassDate, APCEData.NoteIEN);
  SIEN := IntToStr(StrToIntDef(Piece(tmp,U,1),0));
  if(SIEN <> '0') then
  begin
    if(CheckActivePerson(SIEN, APCEData.PersonClassDate)) then
    begin
      if(piece(TIUSiteParams, U, 8) = '1') and // Check to see if DEFAULT PRIMARY PROVIDER is by Location 
        (SIEN = IntToStr(User.DUZ)) then
        ProviderList.AddProvider(SIEN, Piece(tmp,U,2) ,TRUE)
      else
        ProviderList.FPendingDefault := tmp;
    end;
  end;
end;

function ValidateGAFDate(var GafDate: TFMDateTime): string;
var
  DateMsg: string;
  OKDate: TFMDateTime;

begin
  Result := '';
  if(Patient.DateDied > 0) and (FMToday > Patient.DateDied) then
  begin
    DateMsg := 'Date of Death';
    OKDate := Patient.DateDied;
  end
  else
  begin
    DateMsg := 'Today';
    OKDate := FMToday;
  end;
  if(GafDate <= 0) then
  begin
    Result := 'A date is required to enter a GAF score.  Date Determined changed to ' + DateMsg + '.';
    GafDate := OKDate;
  end
  else
  if(Patient.DateDied > 0) and (GafDate > Patient.DateDied) then
  begin
    Result := 'This patient died ' + FormatFMDateTime('dddddd hh:nn', Patient.DateDied) +
           '.  Date GAF determined can not ' + CRLF +
           'be later than the date of death, and has been changed to ' + DateMsg + '.';
    GafDate := OKDate;
  end;
end;

procedure GetVitalsFromDate(VitalStr: TStrings; PCEObj: TPCEData);
var
  dte: TFMDateTime;
  
begin
  if(PCEObj.IsSecondaryVisit) then
    dte := PCEObj.NoteDateTime
  else
    dte := PCEObj.DateTime;
  GetVitalsFromEncDateTime(VitalStr, Patient.DFN, dte);
end;

procedure GetVitalsFromNote(VitalStr: TStrings; PCEObj: TPCEData; ANoteIEN: Int64);
begin
  if(PCEObj.IsSecondaryVisit) then
    GetVitalsFromEncDateTime(VitalStr, Patient.DFN, PCEObj.NoteDateTime)
  else
    GetVitalFromNoteIEN(VitalStr, Patient.DFN, ANoteIEN);
end;

{ TPCEItem methods ------------------------------------------------------------------------- }

//function TPCEItem.DelimitedStr2: string;
//added: 6/17/98
//By: Robert Bott
//Location: ISL
//Purpose: Return comment string to be passed in RPC call.
function TPCEItem.DelimitedStr2: string;
{created delimited string to pass to broker}
begin
  If Comment = '' then
  begin
    result := 'COM' + U +  IntToStr(UNxtCommSeqNum) + U + NoPCEValue;
  end
  else
  begin
    Result := 'COM' + U +  IntToStr(UNxtCommSeqNum) + U + Comment;
  end;

  Inc(UNxtCommSeqNum); //set up for next comment
end;

procedure TPCEItem.Assign(Src: TPCEItem);
begin
  FDelete   := Src.FDelete;
  FSend     := Src.FSend;
  Code      := Src.Code;
  Category  := Src.Category;
  Narrative := Src.Narrative;
  Provider  := Src.Provider;
  Comment   := Src.Comment;                            
end;

procedure TPCEItem.SetComment(const Value: String);
begin
  FComment := Value;
  while (length(FComment) > 0) and (FComment[1] = '?') do
    delete(FComment,1,1);
end;


//procedure TPCEItem.Clear;
//modified: 6/17/98
//By: Robert Bott
//Location: ISL
//Purpose: Add Comments to PCE Items.
procedure TPCEItem.Clear;
{clear fields(properties) of class}
begin
  FDelete   := False;
  FSend     := False;
  Code      := '';
  Category  := '';
  Narrative := '';
  Provider  := 0;
  Comment   := '';                                     
end;

//function TPCEItem.DelimitedStr: string;
//modified: 6/17/98
//By: Robert Bott
//Location: ISL
//Purpose: Add Comments to PCE Items.
function TPCEItem.DelimitedStr: string;
{created delimited string to pass to broker}
var
  DelFlag: Char;
begin
  if FDelete then DelFlag := '-' else DelFlag := '+';
  Result := DelFlag + U + Code + U + Category + U + Narrative;
end;

function TPCEItem.ItemStr: string;
{returns string to be assigned to Tlist in PCEData object}
begin
  Result := Narrative;
end;

function TPCEItem.Match(AnItem: TPCEItem): Boolean;
{checks for match of Code, Category. and Item}
begin
  Result := False;
  if (Code = AnItem.Code) and (Category = AnItem.Category) and (Narrative = AnItem.Narrative)
    then Result := True;
end;

function TPCEItem.HasCPTStr: string;
begin
  Result := '';
end;

//procedure TPCEItem.SetFromString(const x: string);
//modified: 6/17/98
//By: Robert Bott
//Location: ISL
//Purpose: Add Comments to PCE Items.
procedure TPCEItem.SetFromString(const x: string);
{ sets fields to pieces passed from server:  TYP ^ Code ^ Category ^ Narrative }
begin
  Code      := Piece(x, U, pnumCode);
  Category  := Piece(x, U, pnumCategory);
  Narrative := Piece(x, U, pnumNarrative);
  Provider  := StrToInt64Def(Piece(x, U, pnumProvider), 0);
  Comment   := Piece(x, U, pnumComment);
end;


{ TPCEExams methods ------------------------------------------------------------------------- }

procedure TPCEExams.Assign(Src: TPCEItem);
begin
  inherited Assign(Src);
  Results := TPCEExams(Src).Results;
  if Results = '' then Results := NoPCEValue;
end;

procedure TPCEExams.Clear;
{clear fields(properties) of class}
begin
  inherited Clear;
//  Provider := 0;
  Results  := NoPCEValue;
end;

//function TPCEExams.DelimitedStr: string;
//modified: 6/17/98
//By: Robert Bott
//Location: ISL
//Purpose: Add Comments to PCE Items.
function TPCEExams.DelimitedStr: string;
{created delimited string to pass to broker}
begin
  Result := inherited DelimitedStr;
  //Result := 'XAM' + Result + U + Results + U + IntToStr(Provider) +U + U + U +
  Result := 'XAM' + Result + U + Results + U +U + U + U +
   U + IntToStr(UNxtCommSeqNum);
end;

(*function TPCEExams.delimitedStrC: string;
begin
  Result := inherited DelimitedStr;
  Result := 'XAM' + Result + U + Results + U + IntToStr(Provider) +U + U + U +
   U + comment;
end;
*)
function TPCEExams.HasCPTStr: string;
begin
  Result := Code + ';AUTTEXAM(';
end;

function TPCEExams.ItemStr: string;
{returns string to be assigned to Tlist in PCEData object}
begin
  if(Results <> NoPCEValue) then
    Result := GetPCECodeString(TAG_XAMRESULTS, Results)
  else
    Result := '';
  Result := Result + U + inherited ItemStr;
end;

procedure TPCEExams.SetFromString(const x: string);
{ sets fields to pieces passed from server:  TYP ^ Code ^ Category ^ Narrative ^ Qty ^ Prov }
begin
  inherited SetFromString(x);
//  Provider := StrToInt64Def(Piece(x, U, pnumProvider), 0);
  Results  := Piece(x, U, pnumExamResults);
  If results = '' then results := NoPCEValue;
end;


{ TPCESkin methods ------------------------------------------------------------------------- }

procedure TPCESkin.Assign(Src: TPCEItem);
var
  SKSrc: TPCESkin;

begin
  inherited Assign(Src);
  SKSrc := TPCESkin(Src);
  Results := SKSrc.Results;
  Reading := SKSrc.Reading;
  DTRead  := SKSrc.DTRead;
  DTGiven := SKSrc.DTGiven;
  if Results = '' then Results := NoPCEValue;
end;

procedure TPCESkin.Clear;
{clear fields(properties) of class}
begin
  inherited Clear;
//  Provider := 0;
  Results := NoPCEValue;
  Reading   := 0;
  DTRead    := 0.0;        //What should dates be ititialized to?
  DTGiven   := 0.0;
end;

//function TPCESkin.DelimitedStr: string;
//modified: 6/17/98
//By: Robert Bott
//Location: ISL
//Purpose: Add Comments to PCE Items.
function TPCESkin.DelimitedStr: string;
{created delimited string to pass to broker}
begin
  Result := inherited DelimitedStr;
  //Result := 'SK' + Result + U + results + U + IntToStr(Provider) + U +
  Result := 'SK' + Result + U + results + U + U +
   IntToStr(Reading) + U + U + U + IntToStr(UNxtCommSeqNum); 
    //+ FloatToStr(DTRead) + U + FloatToStr(DTGiven);
end;

(*function TPCESkin.delimitedStrC: string;
begin
  Result := inherited DelimitedStr;
  Result := 'SK' + Result + U + results + U + IntToStr(Provider) + U +
   IntToStr(Reading) + U + U + U + comment;
end;
*)
function TPCESkin.HasCPTStr: string;
begin
  Result := Code + ';AUTTSK(';
end;

function TPCESkin.ItemStr: string;
{returns string to be assigned to Tlist in PCEData object}
begin
  if(Results <> NoPCEValue) then
    Result := GetPCECodeString(TAG_SKRESULTS, Results)
  else
    Result := '';
  Result := Result + U;
  if(Reading <> 0) then
    Result := Result + IntToStr(Reading);
  Result := Result + U + inherited ItemStr;
end;

procedure TPCESkin.SetFromString(const x: string);
{ sets fields to pieces passed from server:  TYP ^ Code ^ Category ^ Narrative ^ Qty ^ Prov }
var
  sRead, sDTRead, sDTGiven: String;
begin
  inherited SetFromString(x);
//  Provider := StrToInt64Def(Piece(x, U, pnumProvider), 0);
  Results  := Piece(x, U, pnumSkinResults);
  sRead    := Piece(x, U, pnumSkinReading);
  sDTRead  := Piece(x, U, pnumSkinDTRead);
  sDtGiven := Piece(x, U, pnumSkinDTGiven);
  If results = '' then results := NoPCEValue;

  if sRead <> '' then
    Reading  := StrToInt(sRead);
  if sDTRead <> '' then
    DTRead   := StrToFMDateTime(sDTRead);
  if sDTGiven <> '' then
    DTGiven  := StrToFMDateTime(sDTGiven);

end;


{ TPCEHealth methods ------------------------------------------------------------------------- }

procedure TPCEHealth.Assign(Src: TPCEItem);
begin
  inherited Assign(Src);
  Level := TPCEHealth(Src).Level;
  if Level = '' then Level := NoPCEValue;
end;

procedure TPCEHealth.Clear;
{clear fields(properties) of class}
begin
  inherited Clear;
//  Provider := 0;
  Level    := NoPCEValue;
end;

//function TPCEHealth.DelimitedStr: string;
//modified: 6/17/98
//By: Robert Bott
//Location: ISL
//Purpose: Add Comments to PCE Items.
function TPCEHealth.DelimitedStr: string;
{created delimited string to pass to broker}
begin
  Result := inherited DelimitedStr;
//  Result := 'HF' + Result + U + Level + U + IntToStr(Provider) + U + U + U +
  Result := 'HF' + Result + U + Level + U + U + U + U +
   U + IntToStr(UNxtCommSeqNum)+ U + GecRem; 
end;

(*function TPCEHealth.delimitedStrC: string;
begin
  Result := inherited DelimitedStr;
  Result := 'HF' + Result + U + Level + U + IntToStr(Provider) + U + U + U +
   U + comment;
end;
*)
function TPCEHealth.HasCPTStr: string;
begin
  Result := Code + ';AUTTHF(';
end;

function TPCEHealth.ItemStr: string;
{returns string to be assigned to Tlist in PCEData object}
begin
  if(Level <> NoPCEValue) then
    Result := GetPCECodeString(TAG_HFLEVEL, Level)
  else
    Result := '';
  Result := Result + U + inherited ItemStr;
end;

procedure TPCEHealth.SetFromString(const x: string);
{ sets fields to pieces passed from server:  TYP ^ Code ^ Category ^ Narrative ^ Qty ^ Prov }
begin
  inherited SetFromString(x);
//  Provider := StrToInt64Def(Piece(x, U, pnumProvider), 0);
  Level    := Piece(x, U, pnumHFLevel);
  if level = '' then level := NoPCEValue;
end;


{ TPCEImm methods ------------------------------------------------------------------------- }

procedure TPCEImm.Assign(Src: TPCEItem);
var
  IMMSrc: TPCEImm;
  
begin
  inherited Assign(Src);
  IMMSrc := TPCEImm(Src);
  Series          := IMMSrc.Series;
  Reaction        := IMMSrc.Reaction;
  Refused         := IMMSrc.Refused;
  Contraindicated := IMMSrc.Contraindicated;
  if Series = '' then Series := NoPCEValue;
  if Reaction ='' then Reaction := NoPCEValue;
end;

procedure TPCEImm.Clear;
{clear fields(properties) of class}
begin
  inherited Clear;
//  Provider := 0;
  Series   := NoPCEValue;
  Reaction := NoPCEValue;
  Refused  := False; //not currently used
  Contraindicated := false;
end;

//function TPCEImm.DelimitedStr: string;
//modified: 6/17/98
//By: Robert Bott
//Location: ISL
//Purpose: Add Comments to PCE Items.
function TPCEImm.DelimitedStr: string;
{created delimited string to pass to broker}
begin
  Result := inherited DelimitedStr;
  //Result := 'IMM' + Result + U + Series + U + IntToStr(Provider) + U + Reaction;
  Result := 'IMM' + Result + U + Series + U + U + Reaction;
  if Contraindicated then Result := Result + U + '1'
  else Result := Result + U + '0';
  Result := Result + U + U + IntToStr(UNxtCommSeqNum); 
  {the following two lines are not yet implemented in PCE side}
  //if Refused then Result := Result + U + '1'
  //else Result := Result + U + '0';
end;

(*function TPCEImm.delimitedStrC: string;
begin
  Result := inherited DelimitedStr;
  Result := 'IMM' + Result + U + Series + U + IntToStr(Provider) + U + Reaction;
  if Contraindicated then Result := Result + U + '1'
  else Result := Result + U + '0';
  Result := Result + U + U + comment;
    {the following two lines are not yet implemented in PCE side}
  //if Refused then Result := Result + U + '1'
  //else Result := Result + U + '0';
end;
*)
function TPCEImm.HasCPTStr: string;
begin
  Result := Code + ';AUTTIMM(';
end;

function TPCEImm.ItemStr: string;
{returns string to be assigned to Tlist in PCEData object}
begin
  if(Series <> NoPCEValue) then
    Result := GetPCECodeString(TAG_IMMSERIES, Series)
  else
    Result := '';
  Result := Result + U;
  if(Reaction <> NoPCEValue) then
    Result := Result + GetPCECodeString(TAG_IMMREACTION, Reaction);
  Result := Result + U;
  if(Contraindicated) then
    Result := Result + 'X';
  Result := Result + U + inherited ItemStr;
end;

procedure TPCEImm.SetFromString(const x: string);
{ sets fields to pieces passed from server:  TYP ^ Code ^ Category ^ Narrative ^ Qty ^ Prov }
var
  temp: String;
begin
  inherited SetFromString(x);
//  Provider := StrToInt64Def(Piece(x, U, pnumProvider), 0);
  Series   := Piece(x, U, pnumImmSeries);
  Reaction := Piece(x, U, pnumImmReaction);
  temp     := Piece(x, U, pnumImmRefused);
  if temp = '1' then refused  := true else refused := false;
  temp     := Piece(x, U, pnumImmContra);
  if temp = '1' then Contraindicated := true else Contraindicated := false;
  if Series = '' then series := NoPCEValue;
  if Reaction ='' then reaction := NoPCEValue;
end;



{ TPCEProc methods ------------------------------------------------------------------------- }

procedure TPCEProc.Assign(Src: TPCEItem);
begin
  inherited Assign(Src);
  Quantity := TPCEProc(Src).Quantity;
  Modifiers := TPCEProc(Src).Modifiers;
  Provider := TPCEProc(Src).Provider;
end;

procedure TPCEProc.Clear;
{clear fields(properties) of class}
begin
  inherited Clear;
  Quantity := 0;
  Modifiers := '';
//  Provider := 0;
  Provider := 0;
end;

procedure TPCEProc.CopyProc(Dest: TPCEProc);
begin
  Dest.FDelete    :=  FDelete;
  Dest.FSend      :=  Fsend;                          //flag to send to broker
//  Dest.Provider   := Provider;
  Dest.Provider   := Provider;
  Dest.Code       := Code;
  Dest.Category   := Category;
  Dest.Narrative  := Narrative;
  Dest.Comment    := Comment;
  Dest.Modifiers  := Modifiers;
end;

//function TPCEProc.DelimitedStr: string;
//modified: 6/17/98
//By: Robert Bott
//Location: ISL
//Purpose: Add Comments to PCE Items.
function TPCEProc.DelimitedStr: string;
var
  i, cnt: integer;
  Mods, ModIEN, tmpProv: string;

{created delimited string to pass to broker}
begin
  i := 1;
  cnt := 0;
  Mods := '';
  repeat
    ModIEN := piece(Modifiers, ';', i);
    if(ModIEN <> '') then
    begin
      inc(cnt);
      Mods := Mods + ';' + ModifierCode(ModIEN) + '/' + ModIEN;
      inc(i);
    end;
  until (ModIEN = '');

  Result := inherited DelimitedStr;
  if Provider > 0 then tmpProv := IntToStr(Provider) else tmpProv := '';
  Result := 'CPT' + Result + U + IntToStr(Quantity) + U + tmpProv
             + U + U + U + IntToStr(cnt) + Mods + U + IntToStr(UNxtCommSeqNum) + U;
  if Length(Result) > 250 then SetPiece(Result, U, 4, '');
end;

(*function TPCEProc.delimitedStrC: string;
begin
  Result := inherited DelimitedStr;
  Result := 'CPT' + Result + U + IntToStr(Quantity) + U + IntToStr(Provider) +
  U + U + U + U + comment;
end;
*)

function TPCEProc.Empty: boolean;
begin
  Result := (Code = '') and (Category = '') and (Narrative = '') and
            (Comment = '') and (Quantity = 0) and (Provider = 0) and (Modifiers = '');
end;

(*function TPCEProc.Match(AnItem: TPCEProc): Boolean;        {NEW CODE - v20 testing only - RV}
begin
  Result := inherited Match(AnItem) and (Modifiers = AnItem.Modifiers);
end;*)

function TPCEProc.ModText: string;
var
  i: integer;
  tmp: string;

begin
  Result := '';
  if(Modifiers <> '') then
  begin
    i := 1;
    repeat
      tmp := Piece(Modifiers,';',i);
      if(tmp <> '') then
      begin
        tmp := ModifierName(tmp);
        Result := Result + ' - ' + tmp;
      end;
      inc(i);
    until (tmp = '');
  end;
end;

function TPCEProc.ItemStr: string;
{returns string to be assigned to Tlist in PCEData object}
begin
  if(Quantity > 1) then
    Result := IntToStr(Quantity) + ' times'
  else
    Result := '';
  Result := Result + U + inherited ItemStr + ModText;
end;

procedure TPCEProc.SetFromString(const x: string);
var
  i, cnt: integer;
  Mods: string;
{ sets fields to pieces passed from server:  TYP ^ Code ^ Category ^ Narrative ^ Qty ^ Prov }
begin
  inherited SetFromString(x);
  Quantity := StrToIntDef(Piece(x, U, pnumProcQty), 1);
//  Provider := StrToInt64Def(Piece(x, U, pnumProvider), 0);
  Provider := StrToInt64Def(Piece(x, U, pnumProvider), 0);
  Modifiers := '';
  Mods := Piece(x, U, pnumCPTMods);
  cnt := StrToIntDef(Piece(Mods, ';', 1), 0);
  if(cnt > 0) then
   for i := 1 to cnt do
     Modifiers := Modifiers + Piece(Piece(Mods, ';' , i+1), '/', 2) + ';';
end;


{ TPCEPat methods ------------------------------------------------------------------------- }

procedure TPCEPat.Assign(Src: TPCEItem);
begin
  inherited Assign(Src);
  Level := TPCEPat(Src).Level;
  if Level = '' then Level := NoPCEValue;
end;

procedure TPCEPat.Clear;
{clear fields(properties) of class}
begin
  inherited Clear;
//  Provider := 0;
  Level    := NoPCEValue;
end;

//function TPCEPat.DelimitedStr: string;
//modified: 6/17/98
//By: Robert Bott
//Location: ISL
//Purpose: Add Comments to PCE Items.
function TPCEPat.DelimitedStr: string;
{created delimited string to pass to broker}
begin
  Result := inherited DelimitedStr;
  //Result := 'PED' + Result + U + Level + U + IntToStr(Provider) + U + U + U +
  Result := 'PED' + Result + U + Level + U+ U + U + U +
   U + IntToStr(UNxtCommSeqNum); 
end;

(*function TPCEPat.delimitedStrC: string;
begin
  Result := inherited DelimitedStr;
  Result := 'PED' + Result + U + Level + U + IntToStr(Provider) + U + U + U +
   U + comment;
end;
*)
function TPCEPat.HasCPTStr: string;
begin
  Result := Code + ';AUTTEDT(';
end;

function TPCEPat.ItemStr: string;
{returns string to be assigned to Tlist in PCEData object}
begin
  if(Level <> NoPCEValue) then
    Result := GetPCECodeString(TAG_PEDLEVEL, Level)
  else
    Result := '';
  Result := Result + U + inherited ItemStr;
end;

procedure TPCEPat.SetFromString(const x: string);
{ sets fields to pieces passed from server:  TYP ^ Code ^ Category ^ Narrative ^ Qty ^ Prov }
begin
  inherited SetFromString(x);
//  Provider := StrToInt64Def(Piece(x, U, pnumProvider), 0);
  Level    := Piece(x, U, pnumPEDLevel);
  if level = '' then level := NoPCEValue;
end;

{ TPCEDiag methods ------------------------------------------------------------------------- }

procedure TPCEDiag.Assign(Src: TPCEItem);
begin
  inherited Assign(Src);
  Primary    := TPCEDiag(Src).Primary;
  AddProb    := TPCEDiag(Src).AddProb;
end;

//procedure TPCEDiag.Clear;
//modified: 6/17/98
//By: Robert Bott
//Location: ISL
//Purpose: Clear a diagnosis object.
procedure TPCEDiag.Clear;
{clear fields(properties) of class}
begin
  inherited Clear;
  Primary := False;
  //Provider := 0;
  AddProb  := False;
end;

//function TPCEDiag.DelimitedStr: string;
//modified: 6/17/98
//By: Robert Bott
//Location: ISL
//Purpose: Create delimited string to pass to Broker.
function TPCEDiag.DelimitedStr: string;
{created delimited string to pass to broker}
var
  ProviderStr: string; {jm 9/8/99}
begin
  Result := inherited DelimitedStr;
  if(AddProb) then
    ProviderStr := IntToStr(fProvider)
  else
    ProviderStr := '';
  Result := 'POV' + Result + U + BOOLCHAR[Primary] + U + ProviderStr + U +
    BOOLCHAR[AddProb] + U + U + U;
  if(SaveComment) then Result := Result + IntToStr(UNxtCommSeqNum);
  if Length(Result) > 250 then SetPiece(Result, U, 4, '');
end;

function TPCEDiag.DelimitedStr2: string;
begin
  If Comment = '' then
  begin
    SaveComment := (OldComment <> '') or (not AddProb);
    if(SaveComment) then
      result := 'COM' + U +  IntToStr(UNxtCommSeqNum) + U + NoPCEValue
    else
      result := '';
  end
  else
  begin
    Result := 'COM' + U +  IntToStr(UNxtCommSeqNum) + U + Comment;
    SaveComment := TRUE;
  end;
  Inc(UNxtCommSeqNum);
end;

(*function TPCEDiag.DelimitedStrC: string;
{created delimited string for internal use - keep comment in same string.}
begin
  Result := inherited DelimitedStr;
  Result := 'POV' + Result + U + BOOLCHAR[Primary] + U + IntToStr(Provider)+
  U + BOOLCHAR[AddProb] + U + U + U + comment;
end;
*)
function TPCEDiag.ItemStr: string;
{returns string to be assigned to Tlist in PCEData object}
begin
  if Primary then
    Result := 'Primary'
  else
    Result := 'Secondary';
// This may change in the future if we add a check box to the grid    
  if(AddProb) then
    Result := 'Add' + U + Result
  else
    Result := U + Result;

  Result := Result + U + GetDiagnosisText((inherited ItemStr), Code);
end;

procedure TPCEDiag.Send;
//marks diagnosis to be sent;
begin
  Fsend := True;
end;

//procedure TPCEDiag.SetFromString(const x: string);
//modified: 6/17/98
//By: Robert Bott
//Location: ISL
//Purpose: Sets fields to pieces passed from server.
procedure TPCEDiag.SetFromString(const x: string);
{ sets fields to pieces passed from server:  TYP ^ Code ^ Category ^ Narrative ^ Primary ^ ^ ^ Comment }
begin
  inherited SetFromString(x);
  OldComment := Comment;
  Primary := (Piece(x, U, pnumDiagPrimary) = '1');
  //Provider := StrToInt64Def(Piece(x, U, pnumProvider),0);
  AddProb := (Piece(x, U, pnumDiagAdd2PL) = '1');
end;

{ TPCEData methods ------------------------------------------------------------------------- }

constructor TPCEData.Create;
begin
  FDiagnoses   := TList.Create;
  FProcedures  := TList.Create;
  FImmunizations := TList.Create;
  FSkinTests   := TList.Create;
  FVisitType   := TPCEProc.Create;
  FPatientEds  := TList.Create;
  FHealthFactors := TList.Create;
  fExams       := TList.Create;
  FProviders := TPCEProviderList.Create;
  FSCRelated   := SCC_NA;
  FAORelated   := SCC_NA;
  FIRRelated   := SCC_NA;
  FECRelated   := SCC_NA;
  FMSTRelated  := SCC_NA;
  FHNCRelated  := SCC_NA;
  FCVRelated   := SCC_NA;
  FSHADRelated := SCC_NA;
  FCLRelated   := SCC_NA;
  FSCChanged   := False;
end;

destructor TPCEData.Destroy;
var
  i: Integer;
begin
  with FDiagnoses  do for i := 0 to Count - 1 do TPCEDiag(Items[i]).Free;
  with FProcedures do for i := 0 to Count - 1 do TPCEProc(Items[i]).Free;
  with FImmunizations do for i := 0 to Count - 1 do TPCEImm(Items[i]).Free;
  with FSkinTests do for i := 0 to Count - 1 do TPCESkin(Items[i]).Free;
  with FPatientEds do for i := 0 to Count - 1 do TPCEPat(Items[i]).Free;
  with FHealthFactors do for i := 0 to Count - 1 do TPCEHealth(Items[i]).Free;
  with FExams do for i := 0 to Count - 1 do TPCEExams(Items[i]).Free;
  FVisitType.Free;
  FDiagnoses.Free;
  FProcedures.Free;
  FImmunizations.Free;  
  FSkinTests.free;      
  FPatientEds.Free;
  FHealthFactors.Free;
  FExams.Free;
  FProviders.Free;
  inherited Destroy;
end;

procedure TPCEData.Clear;

  procedure ClearList(AList: TList);
  var
    i: Integer;

  begin
    for i := 0 to AList.Count - 1 do
      TObject(AList[i]).Free;
    AList.Clear;
  end;

begin
  FEncDateTime := 0;
  FNoteDateTime := 0;
  FEncLocation := 0;
  FEncSvcCat   := 'A';
  FEncInpatient := FALSE;
  FProblemAdded := False;
  FEncUseCurr   := FALSE;
  FStandAlone := FALSE;
  FStandAloneLoaded := FALSE;
  FParent       := '';
  FHistoricalLocation := '';
  FSCRelated  := SCC_NA;
  FAORelated  := SCC_NA;
  FIRRelated  := SCC_NA;
  FECRelated  := SCC_NA;
  FMSTRelated := SCC_NA;
  FHNCRelated := SCC_NA;
  FCVRelated  := SCC_NA;
  FSHADRelated := SCC_NA;
  FCLRelated   := SCC_NA;

  ClearList(FDiagnoses);
  ClearList(FProcedures);
  ClearList(FImmunizations);
  ClearList(FSkinTests);
  ClearList(FPatientEds);
  ClearList(FHealthFactors);
  ClearList(FExams);

  FVisitType.Clear;
  FProviders.Clear;
  FSCChanged   := False;
  FNoteIEN := 0;
  FNoteTitle := 0;
end;

procedure TPCEData.CopyDiagnoses(Dest: TCaptionListView);
begin
  CopyPCEItems(FDiagnoses, Dest, TPCEDiag);
end;

procedure TPCEData.CopyProcedures(Dest: TCaptionListView);
begin
  CopyPCEItems(FProcedures, Dest, TPCEProc);
end;

procedure TPCEData.CopyImmunizations(Dest: TCaptionListView);
begin
  CopyPCEItems(FImmunizations, Dest, TPCEImm);
end;

procedure TPCEData.CopySkinTests(Dest: TCaptionListView);
begin
  CopyPCEItems(FSkinTests, Dest, TPCESkin);
end;

procedure TPCEData.CopyPatientEds(Dest: TCaptionListView);
begin
  CopyPCEItems(FPatientEds, Dest, TPCEPat);
end;

procedure TPCEData.CopyHealthFactors(Dest: TCaptionListView);
begin
  CopyPCEItems(FHealthFactors, Dest, TPCEHealth);
end;

procedure TPCEData.CopyExams(Dest: TCaptionListView);
begin
  CopyPCEItems(FExams, Dest, TPCEExams);
end;

function TPCEData.GetVisitString: string;
begin
  Result :=  IntToStr(FEncLocation) + ';' + FloatToStr(VisitDateTime) + ';' + FEncSvcCat;
end;

function TPCEData.GetCPTRequired: Boolean;
begin
  Result := (([ndDiag, ndProc] * NeededPCEData) <> []);
end;

procedure TPCEData.PCEForNote(NoteIEN: Integer; EditObj: TPCEData);
(*const
  NULL_STR = '';
begin
  PCEForNote(NoteIEN, EditObj, NULL_STR);
end;

procedure TPCEData.PCEForNote(NoteIEN: Integer; EditObj: TPCEData; DCSummAdmitString: string);*)
var
  i, j: Integer;
  TmpCat, TmpVStr: string;
  x: string;
  DoCopy, IsVisit: Boolean;
  PCEList, VisitTypeList: TStringList;
  ADiagnosis:    TPCEDiag;
  AProcedure:    TPCEProc;
  AImmunization: TPCEImm;
  ASkinTest:     TPCESkin;
  APatientEd:    TPCEPat;
  AHealthFactor: TPCEHealth;
  AExam:         TPCEExams;
  FileVStr: string;
  FileIEN: integer;
  GetCat, DoRestore: boolean;
  FRestDate: TFMDateTime;
//  AProvider:     TPCEProvider;  {6/9/99}

  function SCCValue(x: string): Integer;
  begin
    Result := SCC_NA;
    if Piece(x, U, 3) = '1' then Result := SCC_YES;
    if Piece(x, U, 3) = '0' then Result := SCC_NO;
  end;

  function AppendComment(x: string): String;
  begin
    //check for comment append string if a comment exists   
    If (((i+1) <= (PCEList.Count - 1)) and (Copy(PCEList[(i+1)], 1, 3) = 'COM')) then
    begin
      //remove last piece (comment sequence number) from x.
      While x[length(x)] <> U do
        x := Copy(X,0,(length(x)-1));
      //add last piece of comment to x
      x := X + Piece (PCEList[(i+1)],U,3);
    end;
    result := x;
  end;

begin
(*  if DCSummAdmitString <> '' then
    TmpVStr := DCSummAdmitString
  else*) if(NoteIEN < 1) then
    TmpVStr := Encounter.VisitStr
  else
  begin
    TmpVStr := VisitStrForNote(NoteIEN);
    if(FEncSvcCat = #0) then
      GetCat :=TRUE
    else
    if(GetVisitString = '0;0;A') then
    begin
      FEncLocation := StrToIntDef(Piece(TmpVStr, ';', 1), 0);
      FEncDateTime := StrToFloatDef(Piece(TmpVStr, ';', 2),0);
      GetCat :=TRUE
    end
    else
      GetCat := FALSE;
    if(GetCat) then
    begin
      TmpCat := Piece(TmpVStr, ';', 3);
      if(TmpCat <> '') then
        FEncSvcCat := TmpCat[1];
    end;
  end;

  if(assigned(EditObj)) then
  begin
    if(copy(TmpVStr,1,2) <> '0;') and   // has location
      (pos(';0;',TmpVStr) = 0) and     // has time
      (EditObj.GetVisitString = TmpVStr) then
    begin
      if(FEncSvcCat = 'H') and (FEncInpatient) then
        DoCopy := (FNoteDateTime = EditObj.FNoteDateTime)
      else
        DoCopy := TRUE;
      if(DoCopy) then
      begin
        if(EditObj <> Self) then
        begin
          EditObj.CopyPCEData(Self);
          FNoteTitle := 0;
          FNoteIEN := 0;
        end;
        exit;
      end;
    end;
  end;

  TmpCat := Piece(TmpVStr, ';', 3);
  if(TmpCat <> '') then
    FEncSvcCat := TmpCat[1]
  else
    FEncSvcCat := #0;
  FEncLocation := StrToIntDef(Piece(TmpVStr,';',1),0);
  FEncDateTime := StrToFloatDef(Piece(TmpVStr, ';', 2),0);

  if(IsSecondaryVisit and (FEncLocation > 0)) then
  begin
    FileIEN := USE_CURRENT_VISITSTR;
    FileVStr := IntToStr(FEncLocation) + ';' + FloatToStr(FNoteDateTime) + ';' +
                                               GetLocSecondaryVisitCode(FEncLocation);
    DoRestore := TRUE;
    FRestDate := FEncDateTime;
  end
  else
  begin
    DoRestore := FALSE;
    FRestDate := 0;
    FileIEN := NoteIEN;
(*    if DCSummAdmitString <> '' then
      FileVStr := DCSummAdmitString
    else*) if(FileIEN < 0) then
      FileVStr := Encounter.VisitStr
    else
      FileVStr := '';
  end;

  Clear;
  PCEList       := TStringList.Create;
  VisitTypeList := TStringList.Create;
  try
    LoadPCEDataForNote(PCEList, FileIEN, FileVStr);        // calls broker RPC to load data
    FNoteIEN := NoteIEN;
    for i := 0 to PCEList.Count - 1 do
    begin
      x := PCEList[i];
      if Copy(x, 1, 4) = 'HDR^' then             // HDR ^ Inpatient ^ ProcReq ^ VStr ^ Provider
      {header information-------------------------------------------------------------}
      begin
        FEncInpatient := Piece(x, U, 2) = '1';
        //FCPTRequired  := Piece(x, U, 3) = '1';  
        //FNoteHasCPT   := Piece(x, U, 6) = '1';    //4/21/99 error! PIECE 3 = cptRequired, not HasCPT!
        FEncLocation  := StrToIntDef(Piece(Piece(x, U, 4), ';', 1), 0);
        if DoRestore then
        begin
          FEncSvcCat := 'H';
          FEncDateTime := FRestDate;
          FNoteDateTime := MakeFMDateTime(Piece(Piece(x, U, 4), ';', 2));
        end
        else
        begin
          FEncDateTime  := MakeFMDateTime(Piece(Piece(x, U, 4), ';', 2));
          FEncSvcCat    := CharAt(Piece(Piece(x, U, 4), ';', 3), 1);
        end;
        //FEncProvider  := StrToInt64Def(Piece(x, U, 5), 0);
        ListVisitTypeByLoc(VisitTypeList, FEncLocation, FEncDateTime);
        //set the values needed fot the RPCs
        SetRPCEncLocation(FEncLocation);
//        SetRPCEncDateTime(FEncDateTime);
      end;
      {visit information--------------------------------------------------------------}
      if Copy(x, 1, 7) = 'VST^DT^' then
      begin
        if DoRestore then
        begin
          FEncDateTime := FRestDate;
          FNoteDateTime := MakeFMDateTime(Piece(x, U, 3));
        end
        else
          FEncDateTime := MakeFMDateTime(Piece(x, U, 3));
      end;
      if Copy(x, 1, 7) = 'VST^HL^' then FEncLocation := StrToIntDef(Piece(x, U, 3), 0);
      if Copy(x, 1, 7) = 'VST^VC^' then
      begin
        if DoRestore then
          FEncSvcCat := 'H'
        else
          FEncSvcCat := CharAt(x, 8);
      end;
      if Copy(x, 1, 7) = 'VST^PS^' then FEncInpatient := CharAt(x, 8) = '1';
      {6/10/99}//if Copy(x, 1, 4) = 'PRV^'    then FEncProvider := StrToInt64Def(Piece(x, U, 2), 0);
      if Copy(x, 1, 7) = 'VST^SC^'  then FSCRelated := SCCValue(x);
      if Copy(x, 1, 7) = 'VST^AO^'  then FAORelated := SCCValue(x);
      if Copy(x, 1, 7) = 'VST^IR^'  then FIRRelated := SCCValue(x);
      if Copy(x, 1, 7) = 'VST^EC^'  then FECRelated := SCCValue(x);
      if Copy(x, 1, 8) = 'VST^MST^' then FMSTRelated := SCCValue(x);
//      if HNCOK and (Copy(x, 1, 8) = 'VST^HNC^') then
      if Copy(x, 1, 8) = 'VST^HNC^' then FHNCRelated := SCCValue(x);
      if Copy(x, 1, 7) = 'VST^CV^' then FCVRelated := SCCValue(x);
      if IsLejeuneActive then
        if Copy(x, 1, 7) = 'VST^CL^' then FCLRelated := SCCValue(x);

      if (Copy(x, 1, 3) = 'PRV') and (CharAt(x, 4) <> '-') then
      {Providers---------------------------------------------------------------------}
      begin
        FProviders.Add(x);
      end;

      if (Copy(x, 1, 3) = 'POV') and (CharAt(x, 4) <> '-') then
      {'POV'=Diagnosis--------------------------------------------------------------}
      begin
        //check for comment append string if a comment exists   
        x := AppendComment(x);
        ADiagnosis := TPCEDiag.Create;
        ADiagnosis.SetFromString(x);
        FDiagnoses.Add(ADiagnosis);
      end;
      if (Copy(x, 1, 3) = 'CPT') and (CharAt(x, 4) <> '-') then
      {CPT (procedure) information--------------------------------------------------}
      begin
        x := AppendComment(x);                         

        IsVisit := False;
        with VisitTypeList do for j := 0 to Count - 1 do
          if Pieces(x, U, 2, 4) = Strings[j] then IsVisit := True;
        if IsVisit and (FVisitType.Code = '') then FVisitType.SetFromString(x) else
        begin
          AProcedure := TPCEProc.Create;
          AProcedure.SetFromString(x);
          AProcedure.fIsOldProcedure := TRUE;
          FProcedures.Add(AProcedure);
        end; {if IsVisit}
      end; {if Copy}
      if (Copy(x, 1, 3) = 'IMM') and (CharAt(x, 4) <> '-') then
      {Immunizations ---------------------------------------------------------------}
      begin
        x := AppendComment(x);                         
        AImmunization := TPCEImm.Create;
        AImmunization.SetFromString(x);
        FImmunizations.Add(AImmunization);
      end;
      if (Copy(x, 1, 2) = 'SK') and (CharAt(x, 3) <> '-') then
      {Skin Tests-------------------------------------------------------------------}
      begin
        x := AppendComment(x);                         
        ASkinTest := TPCESkin.Create;
        ASkinTest.SetFromString(x);
        FSkinTests.Add(ASkinTest);
      end;
      if (Copy(x, 1, 3) = 'PED') and (CharAt(x, 3) <> '-') then
      {Patient Educations------------------------------------------------------------}
      begin
        x := AppendComment(x);                         
        APatientEd := TPCEpat.Create;
        APatientEd.SetFromString(x);
        FpatientEds.Add(APatientEd);
      end;
      if (Copy(x, 1, 2) = 'HF') and (CharAt(x, 3) <> '-') then
      {Health Factors----------------------------------------------------------------}
      begin
        x := AppendComment(x);                         
        AHealthFactor := TPCEHealth.Create;
        AHealthFactor.SetFromString(x);
        FHealthFactors.Add(AHealthFactor);
      end;
      if (Copy(x, 1, 3) = 'XAM') and (CharAt(x, 3) <> '-') then
      {Exams ------------------------------------------------------------------------}
      begin
        x := AppendComment(x);
        AExam := TPCEExams.Create;
        AExam.SetFromString(x);
        FExams.Add(AExam);
      end;

    end;
  finally
    PCEList.Free;
    VisitTypeList.Free;
  end;
end;

//procedure TPCEData.Save;
//modified: 6/17/98
//By: Robert Bott
//Location: ISL
//Purpose: Add Comments to PCE Items.
procedure TPCEData.Save;
{ pass the changes to the encounter to DATA2PCE,
  Pieces: Subscript^Code^Qualifier^Category^Narrative^Delete }
var
  i: Integer;
  x, AVisitStr, EncName, Temp2: string;
  PCEList: TStringList;
  FileCat: char;
  FileDate: TFMDateTime;
  FileNoteIEN: integer;
  dstring1,dstring2: pchar; //used to separate former DelimitedStr variable
                             // into two strings, the second being for the comment.

begin
  PCEList := TStringList.Create;
  UNxtCommSeqNum := 1;                                 
  try
    with PCEList do
    begin
      if(IsSecondaryVisit) then
      begin
        FileCat := GetLocSecondaryVisitCode(FEncLocation);
        FileDate := FNoteDateTime;
        FileNoteIEN := NoteIEN;
        if((NoteIEN > 0) and ((FParent = '') or (FParent = '0'))) then
          FParent := GetVisitIEN(NoteIEN);
      end
      else
      begin
        FileCat := FEncSvcCat;
        FileDate := FEncDateTime;
        FileNoteIEN := 0;
      end;
      AVisitStr :=  IntToStr(FEncLocation) + ';' + FloatToStr(FileDate) + ';' + FileCat;
      Add('HDR^' + BOOLCHAR[FEncInpatient] + U + U + AVisitStr);
//      Add('HDR^' + BOOLCHAR[FEncInpatient] + U + BOOLCHAR[FNoteHasCPT] + U + AVisitStr);
      // set up list that can be passed via broker to set up array for DATA2PCE
      Add('VST^DT^' + FloatToStr(FileDate));  // Encounter Date/Time
      Add('VST^PT^' + Patient.DFN);               // Encounter Patient    //*DFN*
      if(FEncLocation > 0) then
        Add('VST^HL^' + IntToStr(FEncLocation));    // Encounter Location
      Add('VST^VC^' + FileCat);                // Encounter Service Category
      if(StrToIntDef(FParent,0) > 0) then
        Add('VST^PR^' + FParent);                 // Parent for secondary visit
      if(FileCat = 'E') and (FHistoricalLocation <> '') then
        Add('VST^OL^' + FHistoricalLocation);     // Outside Location
      FastAddStrings(FProviders, PCEList);

      if FSCChanged then
      begin
        if FSCRelated  <> SCC_NA then  Add('VST^SC^'  + IntToStr(FSCRelated));
        if FAORelated  <> SCC_NA then  Add('VST^AO^'  + IntToStr(FAORelated));
        if FIRRelated  <> SCC_NA then  Add('VST^IR^'  + IntToStr(FIRRelated));
        if FECRelated  <> SCC_NA then  Add('VST^EC^'  + IntToStr(FECRelated));
        if FMSTRelated <> SCC_NA then  Add('VST^MST^' + IntToStr(FMSTRelated));
        if FHNCRelated  <> SCC_NA then Add('VST^HNC^'+ IntToStr(FHNCRelated));
        if FCVRelated   <> SCC_NA then Add('VST^CV^' + IntToStr(FCVRelated));
        if FSHADRelated <> SCC_NA then Add('VST^SHD^'+ IntToStr(FSHADRelated));
        if IsLejeuneActive then
         if FCLRelated   <> SCC_NA then Add('VST^CL^'+ IntToStr(FCLRelated));
      end;
     with FDiagnoses  do for i := 0 to Count - 1 do with TPCEDiag(Items[i]) do
        if FSend then
        begin
          Temp2 := DelimitedStr2; // Call first to make sure SaveComment is set.
          if(SaveComment) then
            dec(UNxtCommSeqNum);
          fProvider := FProviders.PCEProvider;
          // Provides user with list of dx when signing orders - Billing Aware
          PCEList.Add(DelimitedStr);
          if(SaveComment) then
          begin
            inc(UNxtCommSeqNum);
            if(Temp2 <> '') then
              PCEList.Add(Temp2);
          end;
      end;
      with FProcedures do for i := 0 to Count - 1 do with TPCEProc(Items[i]) do
        if FSend then
        begin
          PCEList.Add(DelimitedStr);
          PCEList.Add(DelimitedStr2);
        end;
      with FImmunizations do for i := 0 to Count - 1 do with TPCEImm(Items[i]) do
        if FSend then
        begin
          PCEList.Add(DelimitedStr);
          PCEList.Add(DelimitedStr2);
        end;
      with FSkinTests do for i := 0 to Count - 1 do with TPCESkin(Items[i]) do
        if FSend then
        begin
          PCEList.Add(DelimitedStr);
          PCEList.Add(DelimitedStr2);
        end;
      with FPatientEds do for i := 0 to Count - 1 do with TPCEPat(Items[i]) do
        if FSend then
        begin
          PCEList.Add(DelimitedStr);
          PCEList.Add(DelimitedStr2);
        end;
      with FHealthFactors do for i := 0 to Count - 1 do with TPCEHealth(Items[i]) do
        if FSend then
        begin
          PCEList.Add(DelimitedStr);
          PCEList.Add(DelimitedStr2);
        end;
      with FExams do for i := 0 to Count - 1 do with TPCEExams(Items[i]) do
        if FSend then
        begin
          PCEList.Add(DelimitedStr);
          PCEList.Add(DelimitedStr2);
        end;

      with FVisitType  do
      begin
        if Code = '' then Fsend := false;
        if FSend then
        begin
          PCEList.Add(DelimitedStr);
          PCEList.Add(DelimitedStr2);
        end;
      end;
      // call DATA2PCE (in background)
      SavePCEData(PCEList, FileNoteIEN, FEncLocation);

      // turn off 'Send' flags and remove items that were deleted
      with FDiagnoses  do for i := Count - 1 downto 0 do with TPCEDiag(Items[i]) do
      begin
        FSend := False;
        // for diags, toggle off AddProb flag as well
        AddProb := False;
        if FDelete then
        begin
          TPCEDiag(Items[i]).Free;
          Delete(i);
        end;
      end;
      with FProcedures do for i := Count - 1 downto 0 do with TPCEProc(Items[i]) do
      begin
        FSend := False;
        if FDelete then
        begin
          TPCEProc(Items[i]).Free;
          Delete(i);
        end;
      end;
      with FImmunizations do for i := Count - 1 downto 0 do with TPCEImm(Items[i]) do
      begin
        FSend := False;
        if FDelete then
        begin
          TPCEImm(Items[i]).Free;
          Delete(i);
        end;
      end;
      with FSkinTests do for i := Count - 1 downto 0 do with TPCESkin(Items[i]) do
      begin
        FSend := False;
        if FDelete then
        begin
          TPCESkin(Items[i]).Free;
          Delete(i);
        end;
      end;
      with FPatientEds do for i := Count - 1 downto 0 do with TPCEPat(Items[i]) do
      begin
        FSend := False;
        if FDelete then
        begin
          TPCEPat(Items[i]).Free;
          Delete(i);
        end;
      end;
      with FHealthFactors do for i := Count - 1 downto 0 do with TPCEHealth(Items[i]) do
      begin
        FSend := False;
        if FDelete then
        begin
          TPCEHealth(Items[i]).Free;
          Delete(i);
        end;
      end;
      with FExams do for i := Count - 1 downto 0 do with TPCEExams(Items[i]) do
      begin
        FSend := False;
        if FDelete then
        begin
          TPCEExams(Items[i]).Free;
          Delete(i);
        end;
      end;
      
      for i := FProviders.Count - 1 downto 0 do
      begin
        if(FProviders.ProviderData[i].Delete) then
          FProviders.Delete(i);
      end;

      if FVisitType.FDelete then FVisitType.Clear else FVisitType.FSend := False;
    end; {with PCEList}
    //if (FProcedures.Count > 0) or (FVisitType.Code <> '') then FCPTRequired := False;  

    // update the Changes object
    EncName := FormatFMDateTime('yyyy/mm/dd@hh:nn', FileDate);
    x := StrVisitType;
    if Length(x) > 0 then Changes.Add(CH_PCE, 'V' + AVisitStr, x, EncName, CH_SIGN_NA);
    x := StrProcedures;
    if Length(x) > 0 then Changes.Add(CH_PCE, 'P' + AVisitStr, x, EncName, CH_SIGN_NA);
    x := StrDiagnoses;
    if Length(x) > 0 then Changes.Add(CH_PCE, 'D' + AVisitStr, x, EncName, CH_SIGN_NA,
       Parent, User.DUZ, '', False, False, ProblemAdded);
    x := StrImmunizations;
    if Length(x) > 0 then Changes.Add(CH_PCE, 'I' + AVisitStr, x, EncName, CH_SIGN_NA);
    x := StrSkinTests;
    if Length(x) > 0 then Changes.Add(CH_PCE, 'S' + AVisitStr, x, EncName, CH_SIGN_NA);
    x := StrPatientEds;
    if Length(x) > 0 then Changes.Add(CH_PCE, 'A' + AVisitStr, x, EncName, CH_SIGN_NA);
    x := StrHealthFactors;
    if Length(x) > 0 then Changes.Add(CH_PCE, 'H' + AVisitStr, x, EncName, CH_SIGN_NA);
    x := StrExams;
    if Length(x) > 0 then Changes.Add(CH_PCE, 'E' + AVisitStr, x, EncName, CH_SIGN_NA);


  finally
    PCEList.Free;
  end;
end;

function TPCEData.MatchItem(AList: TList; AnItem: TPCEItem): Integer;
{ return index in AList of matching item }
var
  i: Integer;
begin
  Result := -1;
  with AList do for i := 0 to Count - 1 do with TPCEItem(Items[i]) do if Match(AnItem) and MatchProvider(AnItem)then
  begin
    Result := i;
    break;
  end;
end;

function TPCEData.MatchPOVItems(AList: TList; AnItem: TPCEItem): Integer;
var
  i: Integer;
begin
  Result := -1;
  with AList do for i := 0 to Count - 1 do with TPCEItem(Items[i]) do if MatchPOV(AnItem) and MatchProvider(AnItem)then
  begin
    Result := i;
    break;
  end;
end;

procedure TPCEData.MarkDeletions(PreList: TList; PostList: TStrings);
{mark items that need deleted}
var
  i, j: Integer;
  MatchFound: Boolean;
  PreItem, PostItem: TPCEItem;
begin
  with PreList do for i := 0 to Count - 1 do
  begin
    PreItem := TPCEItem(Items[i]);
    MatchFound := False;
    with PostList do for j := 0 to Count - 1 do
    begin
      PostItem := TPCEItem(Objects[j]);
      //fix to not mark the ICD-10 diagnosis for deletion when selected to add to the Problem List.
      if (Piece(PostItem.DelimitedStr, '^', 1)='POV+') and (Piece(PostItem.DelimitedStr, '^', 7)='1') and
      (PreItem.Code = PostItem.Code) and (Pos('SNOMED', Piece(PostItem.DelimitedStr, '^', 4)) > 0) then
          MatchFound := True
      else if (PreItem.Match(PostItem) and (PreItem.MatchProvider(PostItem))) then MatchFound := True;
    end;
    if not MatchFound then
    begin
      PreItem.FDelete := True;
      PreItem.FSend   := True;
    end;
  end;
end;

procedure TPCEData.SetDiagnoses(Src: TStrings; FromForm: boolean = TRUE);
{ load diagnoses for this encounter into TPCEDiag records, assumes all diagnoses for the
  encounter will be listed in Src and marks those that are not in Src for deletion }
var
  i, MatchIndex: Integer;
  SrcDiagnosis, CurDiagnosis, PrimaryDiag: TPCEDiag;
begin
  if FromForm then MarkDeletions(FDiagnoses, Src);
  PrimaryDiag := nil;
  for i := 0 to Src.Count - 1 do
  begin
    SrcDiagnosis := TPCEDiag(Src.Objects[i]);
    MatchIndex := MatchPOVItems(FDiagnoses, SrcDiagnosis);
    if MatchIndex > -1 then    //found in fdiagnoses
    begin
      CurDiagnosis := TPCEDiag(FDiagnoses.Items[MatchIndex]);
      if ((SrcDiagnosis.Primary <> CurDiagnosis.Primary) or
       (SrcDiagnosis.Comment <> CurDiagnosis.Comment) or
       (SrcDiagnosis.AddProb <> CurDiagnosis.Addprob) or
       (SrcDiagnosis.Narrative <> CurDiagnosis.Narrative)) then
      begin
        CurDiagnosis.Primary    := SrcDiagnosis.Primary;
        CurDiagnosis.Comment    := SrcDiagnosis.Comment;
        CurDiagnosis.AddProb    := SrcDiagnosis.AddProb;
        CurDiagnosis.Narrative  := SrcDiagnosis.Narrative;
        CurDiagnosis.FSend := True;
      end;
    end
    else
    begin
      CurDiagnosis := TPCEDiag.Create;
      CurDiagnosis.Assign(SrcDiagnosis);
      CurDiagnosis.FSend := True;
      FDiagnoses.Add(CurDiagnosis);
    end; {if MatchIndex}
    if(CurDiagnosis.Primary and (not assigned(PrimaryDiag))) then
      PrimaryDiag := CurDiagnosis;
    if (CurDiagnosis.AddProb) then
      FProblemAdded := True;
  end; {for}
  if(assigned(PrimaryDiag)) then
  begin
    for i := 0 to FDiagnoses.Count - 1 do
    begin
      CurDiagnosis := TPCEDiag(FDiagnoses[i]);
      if(CurDiagnosis.Primary) and (CurDiagnosis <> PrimaryDiag) then
      begin
        CurDiagnosis.Primary := FALSE;
        CurDiagnosis.FSend := True;
      end;
    end;
  end;
end;

procedure TPCEData.SetProcedures(Src: TStrings; FromForm: boolean = TRUE);
{ load Procedures for this encounter into TPCEProc records, assumes all Procedures for the
  encounter will be listed in Src and marks those that are not in Src for deletion }
var
  i, MatchIndex: Integer;
  SrcProcedure, CurProcedure, OldProcedure: TPCEProc;
begin
  if FromForm then MarkDeletions(FProcedures, Src);
  for i := 0 to Src.Count - 1 do
  begin
    SrcProcedure := TPCEProc(Src.Objects[i]);
    MatchIndex := MatchItem(FProcedures, SrcProcedure);
    if MatchIndex > -1 then
    begin
      CurProcedure := TPCEProc(FProcedures.Items[MatchIndex]);
(*      if (SrcProcedure.Provider <> CurProcedure.Provider) then
      begin
        OldProcedure := TPCEProc.Create;
        OldProcedure.Assign(CurProcedure);
        OldProcedure.FDelete := TRUE;
        OldProcedure.FSend := TRUE;
        FProcedures.Add(OldProcedure);
      end;*)
      if (SrcProcedure.Quantity <> CurProcedure.Quantity) or
         (SrcProcedure.Provider <> CurProcedure.Provider) or
         (Curprocedure.Comment <> SrcProcedure.Comment) or
         (Curprocedure.Modifiers <> SrcProcedure.Modifiers)then
      begin
        OldProcedure := TPCEProc.Create;
        OldProcedure.Assign(CurProcedure);
        OldProcedure.FDelete := TRUE;
        OldProcedure.FSend := TRUE;
        FProcedures.Add(OldProcedure);
        CurProcedure.Quantity := SrcProcedure.Quantity;
        CurProcedure.Provider := SrcProcedure.Provider;
        CurProcedure.Comment := SrcProcedure.Comment;
        CurProcedure.Modifiers := SrcProcedure.Modifiers;
        CurProcedure.FSend := True;
      end;
    end else
    begin
      CurProcedure := TPCEProc.Create;
      CurProcedure.Assign(SrcProcedure);
      CurProcedure.FSend := True;
      FProcedures.Add(CurProcedure);
    end; {if MatchIndex}
  end; {for}
end;



procedure TPCEData.SetImmunizations(Src: TStrings; FromForm: boolean = TRUE);
{ load Immunizations for this encounter into TPCEImm records, assumes all Immunizations for the
  encounter will be listed in Src and marks those that are not in Src for deletion }
var
  i, MatchIndex: Integer;
  SrcImmunization, CurImmunization: TPCEImm;
begin
  if FromForm then MarkDeletions(FImmunizations, Src);
  for i := 0 to Src.Count - 1 do
  begin
    SrcImmunization := TPCEImm(Src.Objects[i]);
    MatchIndex := MatchItem(FImmunizations, SrcImmunization);
    if MatchIndex > -1 then
    begin
      CurImmunization := TPCEImm(FImmunizations.Items[MatchIndex]);

      //set null strings to NoPCEValue
      if SrcImmunization.Series = '' then SrcImmunization.Series := NoPCEValue;
      if SrcImmunization.Reaction = '' then SrcImmunization.Reaction := NoPCEValue;
      if CurImmunization.Series = '' then CurImmunization.Series := NoPCEValue;
      if CurImmunization.Reaction = '' then CurImmunization.Reaction := NoPCEValue;

      if(SrcImmunization.Series <> CurImmunization.Series) or
        (SrcImmunization.Reaction <> CurImmunization.Reaction) or
        (SrcImmunization.Refused <> CurImmunization.Refused) or
        (SrcImmunization.Contraindicated <> CurImmunization.Contraindicated) or
        (CurImmunization.Comment <> SrcImmunization.Comment)then  
      begin
        CurImmunization.Series          := SrcImmunization.Series;
        CurImmunization.Reaction        := SrcImmunization.Reaction;
        CurImmunization.Refused         := SrcImmunization.Refused;
        CurImmunization.Contraindicated := SrcImmunization.Contraindicated;
        CurImmunization.Comment         := SrcImmunization.Comment;  
        CurImmunization.FSend := True;
      end;
    end else
    begin
      CurImmunization := TPCEImm.Create;
      CurImmunization.Assign(SrcImmunization);
      CurImmunization.FSend := True;
      FImmunizations.Add(CurImmunization);
    end; {if MatchIndex}
  end; {for}
end;

procedure TPCEData.SetSkinTests(Src: TStrings; FromForm: boolean = TRUE);
{ load SkinTests for this encounter into TPCESkin records, assumes all SkinTests for the
  encounter will be listed in Src and marks those that are not in Src for deletion }
var
  i, MatchIndex: Integer;
  SrcSkinTest, CurSkinTest: TPCESkin;
begin
  if FromForm then MarkDeletions(FSKinTests, Src);
  for i := 0 to Src.Count - 1 do
  begin
    SrcSkinTest := TPCESkin(Src.Objects[i]);
    MatchIndex := MatchItem(FSKinTests, SrcSkinTest);
    if MatchIndex > -1 then
    begin
      CurSkinTest := TPCESKin(FSkinTests.Items[MatchIndex]);
      if CurSkinTest.Results = '' then CurSkinTest.Results := NoPCEValue;
      if SrcSkinTest.Results = '' then SrcSkinTest.Results := NoPCEValue;

      if(SrcSkinTest.Results <> CurSkinTest.Results) or
        (SrcSkinTest.Reading <> CurSkinTest.Reading) or
        (CurSkinTest.Comment <> SrcSkinTest.Comment) then
      begin

        CurSkinTest.Results := SrcSkinTest.Results;
        CurSkinTest.Reading := SrcSkinTest.Reading;
        CurSkinTest.Comment := SrcSkinTest.Comment;
        CurSkinTest.FSend := True;
      end;
    end else
    begin
      CurSKinTest := TPCESkin.Create;
      CurSkinTest.Assign(SrcSkinTest);
      CurSkinTest.FSend := True;
      FSkinTests.Add(CurSkinTest);
    end; {if MatchIndex}
  end; {for}
end;

procedure TPCEData.SetPatientEds(Src: TStrings; FromForm: boolean = TRUE);
var
  i, MatchIndex: Integer;
  SrcPatientEd, CurPatientEd: TPCEPat;
begin
  if FromForm then MarkDeletions(FPatientEds, Src);
  for i := 0 to Src.Count - 1 do
  begin
    SrcPatientEd := TPCEPat(Src.Objects[i]);
    MatchIndex := MatchItem(FPatientEds, SrcPatientEd);
    if MatchIndex > -1 then
    begin
      CurPatientEd := TPCEPat(FPatientEds.Items[MatchIndex]);

      if CurPatientEd.level = '' then CurPatientEd.level := NoPCEValue;
      if SrcPatientEd.level = '' then SrcPatientEd.level := NoPCEValue;
      if(SrcPatientEd.Level <> CurPatientEd.Level) or
        (CurPatientEd.Comment <> SrcPatientEd.Comment) then
      begin
        CurPatientEd.Level  := SrcPatientEd.Level;
        CurPatientEd.Comment := SrcPatientEd.Comment;  
        CurPatientEd.FSend := True;
      end;
    end else
    begin
      CurPatientEd := TPCEPat.Create;
      CurPatientEd.Assign(SrcPatientEd);
      CurPatientEd.FSend := True;
      FPatientEds.Add(CurPatientEd);
    end; {if MatchIndex}
  end; {for}
end;


procedure TPCEData.SetHealthFactors(Src: TStrings; FromForm: boolean = TRUE);

var
  i, MatchIndex: Integer;
  SrcHealthFactor, CurHealthFactor: TPCEHealth;
begin
  if FromForm then MarkDeletions(FHealthFactors, Src);
  for i := 0 to Src.Count - 1 do
  begin
    SrcHealthFactor := TPCEHealth(Src.Objects[i]);
    MatchIndex := MatchItem(FHealthFactors, SrcHealthFactor);
    if MatchIndex > -1 then
    begin
      CurHealthFactor := TPCEHealth(FHealthFactors.Items[MatchIndex]);

      if CurHealthFactor.level = '' then CurHealthFactor.level := NoPCEValue;
      if SrcHealthFactor.level = '' then SrcHealthFactor.level := NoPCEValue;
      if(SrcHealthFactor.Level <> CurHealthFactor.Level) or
        (CurHealthFactor.Comment <> SrcHealthFactor.Comment) then  
      begin
        CurHealthFactor.Level  := SrcHealthFactor.Level;
        CurHealthFactor.Comment := SrcHealthFactor.Comment;  
        CurHealthFactor.FSend := True;
      end;
       if(SrcHealthFactor.GecRem <> CurHealthFactor.GecRem) then
          CurHealthFactor.GecRem := SrcHealthFactor.GecRem;
    end else
    begin
      CurHealthFactor := TPCEHealth.Create;
      CurHealthFactor.Assign(SrcHealthFactor);
      CurHealthFactor.FSend := True;
      CurHealthFactor.GecRem := SrcHealthFactor.GecRem;
      FHealthFactors.Add(CurHealthFactor);
    end; {if MatchIndex}
  end; {for}
end;


procedure TPCEData.SetExams(Src: TStrings; FromForm: boolean = TRUE);

var
  i, MatchIndex: Integer;
  SrcExam, CurExam: TPCEExams;
begin
  if FromForm then MarkDeletions(FExams, Src);
  for i := 0 to Src.Count - 1 do
  begin
    SrcExam := TPCEExams(Src.Objects[i]);
    MatchIndex := MatchItem(FExams, SrcExam);
    if MatchIndex > -1 then
    begin
      CurExam := TPCEExams(FExams.Items[MatchIndex]);
      if CurExam.Results = '' then CurExam.Results := NoPCEValue;
      if SrcExam.Results = '' then SrcExam.Results := NoPCEValue;
      if(SrcExam.Results <> CurExam.Results) or
        (CurExam.Comment <> SrcExam.Comment) then  
      begin
        CurExam.Results  := SrcExam.Results;
        CurExam.Comment := SrcExam.Comment;  
        CurExam.Fsend := True;
      end;
    end else
    begin
      CurExam := TPCEExams.Create;
      CurExam.Assign(SrcExam);
      CurExam.FSend := True;
      FExams.Add(CurExam);
    end; {if MatchIndex}
  end; {for}
end;


procedure TPCEData.SetVisitType(Value: TPCEProc);
var
  VisitDelete: TPCEProc;
begin
  if (not FVisitType.Match(Value)) or
  (FVisitType.Modifiers <> Value.Modifiers) then  {causes CPT delete/re-add}
  begin
    if FVisitType.Code <> '' then                // add old visit to procedures for deletion
    begin
      VisitDelete := TPCEProc.Create;
      VisitDelete.Assign(FVisitType);
      VisitDelete.FDelete := True;
      VisitDelete.FSend   := True;
      FProcedures.Add(VisitDelete);
    end;
    FVisitType.Assign(Value);
    FVisitType.Quantity := 1;
    FVisitType.FSend := True;
  end;
end;

procedure TPCEData.SetSCRelated(Value: Integer);
begin
  if Value <> FSCRelated then
  begin
    FSCRelated := Value;
    FSCChanged := True;
  end;
end;

procedure TPCEData.SetAORelated(Value: Integer);
begin
  if Value <> FAORelated then
  begin
    FAORelated := Value;
    FSCChanged := True;
  end;
end;

procedure TPCEData.SetIRRelated(Value: Integer);
begin
  if Value <> FIRRelated then
  begin
    FIRRelated := Value;
    FSCChanged := True;
  end;
end;

procedure TPCEData.SetECRelated(Value: Integer);
begin
  if Value <> FECRelated then
  begin
    FECRelated := Value;
    FSCChanged := True;
  end;
end;

procedure TPCEData.SetMSTRelated(Value: Integer);
begin
  if Value <> FMSTRelated then
  begin
    FMSTRelated := Value;
    FSCChanged := True;
  end;
end;

procedure TPCEData.SetHNCRelated(Value: Integer);
begin
//  if HNCOK and (Value <> FHNCRelated) then
  if Value <> FHNCRelated then
  begin
    FHNCRelated := Value;
    FSCChanged := True;
  end;
end;

procedure TPCEData.SetCVRelated(Value: Integer);
begin
  if (Value <> FCVRelated) then
  begin
    FCVRelated := Value;
    FSCChanged := True;
  end;
end;

procedure TPCEData.SetSHADRelated(Value: Integer);
begin
  if (Value <> FSHADRelated) then
  begin
    FSHADRelated := Value;
    FSCChanged   := True;
  end;
end;

procedure TPCEData.SetCLRelated(Value: Integer);
begin
  if (Value <> FCLRelated) then
  begin
    FCLRelated := Value;
    FSCChanged   := True;
  end;
end;

procedure TPCEData.SetEncUseCurr(Value: Boolean);
begin
  FEncUseCurr := Value;
  if FEncUseCurr then
  begin
    FEncDateTime  := Encounter.DateTime;
    FEncLocation  := Encounter.Location;
    //need to add to full list of providers
    FEncSvcCat    := Encounter.VisitCategory;
    FStandAlone   := Encounter.StandAlone;
    FStandAloneLoaded := TRUE;
    FEncInpatient := Encounter.Inpatient;

  end else
  begin
    FEncDateTime  := 0;
    FEncLocation  := 0;
    FStandAlone := FALSE;
    FStandAloneLoaded := FALSE;
    FProviders.PrimaryIdx := -1;
    FEncSvcCat    := 'A';
    FEncInpatient := False;
  end;
  //
  SetRPCEncLocation(FEncLocation);
end;

function TPCEData.StrDiagnoses: string;
{ returns the list of diagnoses for this encounter as a single comma delimited string }
var
  i: Integer;
begin
  Result := '';
  with FDiagnoses do for i := 0 to Count - 1 do with TPCEDiag(Items[i]) do
    if not FDelete then
      Result := Result + GetPCEDataText(pdcDiag, Code, Category, Narrative, Primary) + CRLF;
  if Length(Result) > 0 then Result := PCEDataCatText[pdcDiag] + CRLF + Copy(Result, 1, Length(Result) - 2) + CRLF;
end;

function TPCEData.StrProcedures: string;
{ returns the list of procedures for this encounter as a single comma delimited string }
var
  i: Integer;
begin
  Result := '';
  with FProcedures do for i := 0 to Count - 1 do with TPCEProc(Items[i]) do
    if not FDelete then
      Result := Result + GetPCEDataText(pdcProc, Code, Category, Narrative, FALSE, Quantity) +
                         ModText + CRLF;
  if Length(Result) > 0 then Result := PCEDataCatText[pdcProc] + CRLF + Copy(Result, 1, Length(Result) - 2) + CRLF;
end;

function TPCEData.StrImmunizations: string;
{ returns the list of Immunizations for this encounter as a single comma delimited string }
var
  i: Integer;
begin
  Result := '';
  with FImmunizations do for i := 0 to Count - 1 do with TPCEImm(Items[i]) do
    if not FDelete then
      Result := Result + GetPCEDataText(pdcImm, Code, Category, Narrative) + CRLF;
  if Length(Result) > 0 then Result := PCEDataCatText[pdcImm] + CRLF + Copy(Result, 1, Length(Result) - 2) + CRLF;
end;


function TPCEData.StrSkinTests: string;
{ returns the list of Immunizations for this encounter as a single comma delimited string }
var
  i: Integer;
begin
  Result := '';
  with FSkinTests do for i := 0 to Count - 1 do with TPCESkin(Items[i]) do
    if not FDelete then
      Result := Result + GetPCEDataText(pdcSkin, Code, Category, Narrative) + CRLF;
  if Length(Result) > 0 then Result := PCEDataCatText[pdcSkin] + CRLF + Copy(Result, 1, Length(Result) - 2) + CRLF;
end;

function TPCEData.StrPatientEds: string;
var
  i: Integer;
begin
  Result := '';
  with FPatientEds do for i := 0 to Count - 1 do with TPCEPat(Items[i]) do
    if not FDelete then
      Result := Result + GetPCEDataText(pdcPED, Code, Category, Narrative) + CRLF;
  if Length(Result) > 0 then Result := PCEDataCatText[pdcPED] + CRLF + Copy(Result, 1, Length(Result) - 2) + CRLF;
end;

function TPCEData.StrHealthFactors: string;
var
  i: Integer;
begin
  Result := '';
  with FHealthFactors do for i := 0 to Count - 1 do with TPCEHealth(Items[i]) do
    if not FDelete then
      Result := Result + GetPCEDataText(pdcHF, Code, Category, Narrative) + CRLF;
  if Length(Result) > 0 then Result := PCEDataCatText[pdcHF] + CRLF + Copy(Result, 1, Length(Result) - 2) + CRLF;
end;

function TPCEData.StrExams: string;
var
  i: Integer;
begin
  Result := '';
  with FExams do for i := 0 to Count - 1 do with TPCEExams(Items[i]) do
    if not FDelete then
      Result := Result + GetPCEDataText(pdcExam, Code, Category, Narrative) + CRLF;
  if Length(Result) > 0 then Result := PCEDataCatText[pdcExam] + CRLF + Copy(Result, 1, Length(Result) - 2) + CRLF;
end;

function TPCEData.StrVisitType(const ASCRelated, AAORelated, AIRRelated,
  AECRelated, AMSTRelated, AHNCRelated, ACVRelated, ASHADRelated, ACLRelated: Integer): string;
{ returns as a string the type of encounter (according to CPT) & related contitions treated }

  procedure AddTxt(txt: string);
  begin
    if(Result <> '') then
      Result := Result + ',';
    Result := Result + ' ' + txt;
  end;

begin
  Result := '';
  if ASCRelated = SCC_YES  then AddTxt('Service Connected Condition');
  if AAORelated = SCC_YES  then AddTxt('Agent Orange Exposure');
  if AIRRelated = SCC_YES  then AddTxt('Ionizing Radiation Exposure');
  if AECRelated = SCC_YES  then AddTxt('Environmental Contaminants');
  if AMSTRelated = SCC_YES then AddTxt('MST');//'Military Sexual Trauma';
//  if HNCOK and (AHNCRelated = SCC_YES) then AddTxt('Head and/or Neck Cancer');
  if AHNCRelated = SCC_YES then AddTxt('Head and/or Neck Cancer');
  if ACVRelated = SCC_YES  then AddTxt('Combat Veteran Related');
  if ACLRelated = SCC_YES  then AddTxt('Camp Lejeune'); //Camp Lejeune
  if Length(Result) > 0 then Result := ' related to: ' + Result;
//  Result := Trim(Result);
end;

function TPCEData.StrVisitType: string;
{ returns as a string the type of encounter (according to CPT) & related contitions treated }
begin
  Result := '';
  with FVisitType do
    begin
      Result := GetPCEDataText(pdcVisit, Code, Category, Narrative);
      if Length(ModText) > 0 then Result := Result + ModText + ', ';
    end;
  Result := Trim(Result + StrVisitType(FSCRelated, FAORelated, FIRRelated,
                                       FECRelated, FMSTRelated, FHNCRelated, FCVRelated, FSHADRelated, FCLRelated));
end;

function TPCEData.StandAlone: boolean;
var
  Sts: integer;

begin
  if(not FStandAloneLoaded) and ((FNoteIEN > 0) or ((FEncLocation > 0) and (FEncDateTime > 0))) then
  begin
    Sts := HasVisit(FNoteIEN, FEncLocation, FEncDateTime);
    FStandAlone := (Sts <> 1);
    if(Sts >= 0) then
      FStandAloneLoaded := TRUE;
  end;
  Result := FStandAlone;
end;

function TPCEData.getDocCount: Integer;
begin
  rESULT := 1;
//  result := DocCount(vISIT);
end;

{function TPCEItem.MatchProvider(AnItem: TPCEItem): Boolean;
begin
  Result := False;
  if (Provider = AnItem.Provider) then Result := True;
end;
}
function TPCEItem.MatchPOV(AnItem: TPCEItem): Boolean;
begin
  Result := False;
  if (Code = AnItem.Code) and (Category = AnItem.Category)
    then Result := True;
end;

function TPCEItem.MatchProvider(AnItem: TPCEItem): Boolean;
begin
  Result := False;
  if (Provider = AnItem.Provider) then Result := True;
end;

function TPCEData.GetHasData: Boolean;
begin
  result := True;
  if ((FDiagnoses.count = 0)
     and (FProcedures.count = 0)
     and (FImmunizations.count = 0)
     and (FSkinTests.count = 0)
     and (FPatientEds.count = 0)
     and (FHealthFactors.count = 0)
     and (fExams.count = 0) and
     (FvisitType.Quantity = 0))then
      result := False;
end;

procedure TPCEData.CopyPCEData(Dest: TPCEData);
begin
  Dest.Clear;
  Dest.FEncDateTime  := FEncDateTime;
  Dest.FNoteDateTime := FNoteDateTime;
  Dest.FEncLocation  := FEncLocation;
  Dest.FEncSvcCat    := FEncSvcCat;
  Dest.FEncInpatient := FEncInpatient;
  Dest.FStandAlone   := FStandAlone;
  Dest.FStandAloneLoaded := FStandAloneLoaded;
  Dest.FEncUseCurr   := FEncUseCurr;
  Dest.FSCChanged    := FSCChanged;
  Dest.FSCRelated    := FSCRelated;
  Dest.FAORelated    := FAORelated;
  Dest.FIRRelated    := FIRRelated;
  Dest.FECRelated    := FECRelated;
  Dest.FMSTRelated   := FMSTRelated;
  Dest.FHNCRelated   := FHNCRelated;
  Dest.FCVRelated    := FCVRelated;
  Dest.FSHADRelated  := FSHADRelated;
  if IsLejeuneActive then
   Dest.fCLRelated    := FCLRelated; //Camp Lejeune
  FVisitType.CopyProc(Dest.VisitType);
  Dest.FProviders.Assign(FProviders);

  CopyPCEItems(FDiagnoses,     Dest.FDiagnoses,     TPCEDiag);
  CopyPCEItems(FProcedures,    Dest.FProcedures,    TPCEProc);
  CopyPCEItems(FImmunizations, Dest.FImmunizations, TPCEImm);
  CopyPCEItems(FSkinTests,     Dest.FSkinTests,     TPCESkin);
  CopyPCEItems(FPatientEds,    Dest.FPatientEds,    TPCEPat);
  CopyPCEItems(FHealthFactors, Dest.FHealthFactors, TPCEHealth);
  CopyPCEItems(FExams,         Dest.FExams,         TPCEExams);

  Dest.FNoteTitle := FNoteTitle;
  Dest.FNoteIEN := FNoteIEN;
  Dest.FParent := FParent;
  Dest.FHistoricalLocation := FHistoricalLocation;
end;

function TPCEData.NeededPCEData: tRequiredPCEDataTypes;
var
  EC: TSCConditions;
  NeedSC: boolean;
  TmpLst: TStringList;

begin
  Result := [];
  if(not FutureEncounter(Self)) then
  begin
    if(PromptForWorkload(FNoteIEN, FNoteTitle, FEncSvcCat, StandAlone)) then
    begin
      if(fdiagnoses.count <= 0) then
        Include(Result, ndDiag);
      if((fprocedures.count <= 0) and (fVisitType.Code = '')) then
      begin
        TmpLst := TStringList.Create;
        try
          GetHasCPTList(TmpLst);
          if(not DataHasCPTCodes(TmpLst)) then
            Include(Result, ndProc);
        finally
          TmpLst.Free;
        end;
      end;
      if(RequireExposures(FNoteIEN, FNoteTitle)) then
      begin
        NeedSC := FALSE;
        EC :=  EligbleConditions;
        if (EC.SCAllow and (SCRelated = SCC_NA)) then
          NeedSC := TRUE
        else   if(SCRelated <> SCC_YES) then  //if screlated = yes, the others are not asked.
        begin
               if(EC.AOAllow and (AORelated = SCC_NA)) then NeedSC := TRUE
          else if(EC.IRAllow and (IRRelated = SCC_NA)) then NeedSC := TRUE
          else if(EC.ECAllow and (ECRelated = SCC_NA)) then NeedSC := TRUE
        end;
        if(EC.MSTAllow and (MSTRelated = SCC_NA)) then NeedSC := TRUE;
//        if HNCOK and (EC.HNCAllow and (HNCRelated = SCC_NA)) then NeedSC := TRUE;
        if(EC.HNCAllow and (HNCRelated = SCC_NA)) then NeedSC := TRUE;
        if(EC.CVAllow and (CVRelated = SCC_NA) and (SHADRelated = SCC_NA)) then NeedSC := TRUE;
        if(NeedSC) then
          Include(Result, ndSC);
      end;
(*      if(Result = []) and (FNoteIEN > 0) then   //  **** block removed in v19.1  {RV} ****
        ClearCPTRequired(FNoteIEN);*)
    end;
  end;
end;


function TPCEData.OK2SignNote: boolean;
var
  Req: tRequiredPCEDataTypes;
  msg: string;
  Asked, DoAsk, Primary, Needed: boolean;
  Outpatient, First, DoSave, NeedSave, Done: boolean;
  Ans: integer;
  Flags: word;
  Ask: TAskPCE;

  procedure Add(Typ: tRequiredPCEDataType; txt: string);
  begin
    if(Typ in Req) then
      msg := msg + txt + CRLF;
  end;

begin
  if not CanEditPCE(Self) then
  begin
    Result := TRUE;
    exit;
  end;
  if IsNonCountClinic(FEncLocation) then
  begin
    Result := TRUE;
    exit;
  end;
  if IsCancelOrNoShow(NoteIEN) then
  begin
    Result := TRUE;
    exit;
  end;
  Ask := GetAskPCE(FEncLocation);
  if(Ask = apNever) or (Ask = apDisable) then
    Result := TRUE
  else
  begin
    DoSave := FALSE;
    try
      Asked := FALSE;
      First := TRUE;
      Outpatient := ((FEncSvcCat = 'A') or (FEncSvcCat = 'I') or (FEncSvcCat = 'T'));
      repeat
        Result := TRUE;
        Done := TRUE;
        Req := NeededPCEData;
        Needed := (Req <> []);
        if(First) then
        begin
          if Needed and (not Outpatient) then
            OutPatient := TRUE;
          if((Ask = apPrimaryAlways) or Needed or
             ((Ask = apPrimaryOutpatient) and Outpatient)) then
          begin
            if(Providers.PrimaryIdx < 0) then
            begin
              NoPrimaryPCEProvider(FProviders, Self);
              if(not DoSave) then
                DoSave := (Providers.PrimaryIdx >= 0);
              if(DoSave and (FProviders.PendingIEN(FALSE) <> 0) and
                (FProviders.IndexOfProvider(IntToStr(FProviders.PendingIEN(FALSE))) < 0)) then
                FProviders.AddProvider(IntToStr(FProviders.PendingIEN(FALSE)), FProviders.PendingName(FALSE), FALSE);
            end;
          end;
          First := FALSE;
        end;
        Primary := (Providers.PrimaryIEN = User.DUZ);
        case Ask of
          apPrimaryOutpatient: DoAsk := (Primary and Outpatient);
          apPrimaryAlways:     DoAsk := Primary;
          apNeeded:            DoAsk := Needed;
          apOutpatient:        DoAsk := Outpatient;
          apAlways:            DoAsk := TRUE;
          else
        { apPrimaryNeeded }    DoAsk := (Primary and Needed);
        end;
        if(DoAsk) then
        begin
          if(Asked and ((not Needed) or (not Primary))) then
            exit;
          if(Needed) then
          begin
            msg := TX_NEED1;
            Add(ndDiag, TX_NEED_DIAG);
            Add(ndProc, TX_NEED_PROC);
            Add(ndSC,   TX_NEED_SC);
            if(Primary and ForcePCEEntry(FEncLocation)) then
            begin
              Flags := MB_OKCANCEL;
              msg :=  msg + CRLF + TX_NEED3;
            end
            else
            begin
              if(Primary) then
                Flags := MB_YESNOCANCEL
              else
                Flags := MB_YESNO;
              msg :=  msg + CRLF + TX_NEED2;
            end;
            Flags := Flags + MB_ICONWARNING;
          end
          else
          begin
            Flags := MB_YESNO + MB_ICONQUESTION;
            msg :=  TX_NEED2;
          end;
          Ans := InfoBox(msg, TX_NEED_T, Flags);
          if(Ans = ID_CANCEL) then
          begin
            Result := FALSE;
            InfoBox(TX_NEEDABORT, TX_NEED_T, MB_OK);
            exit;
          end;
          Result := (Ans = ID_NO);
          if(not Result) then
          begin
            if(not MissingProviderInfo(Self)) then
            begin
              NeedSave := UpdatePCE(Self, FALSE);
              if(not DoSave) then
                DoSave := NeedSave;
              FUpdated := TRUE;
            end;
            Done := frmFrame.Closing;
            Asked := TRUE;
          end;
        end;
      until(Done);
    finally
      if(DoSave) then
        Save;
    end;
  end;
end;

procedure TPCEData.AddStrData(List: TStrings);

  procedure Add(Txt: string);
  begin
    if(length(Txt) > 0) then List.Add(Txt);
  end;

begin
  Add(StrVisitType);
  Add(StrDiagnoses);
  Add(StrProcedures);
  Add(StrImmunizations);
  Add(StrSkinTests);
  Add(StrPatientEds);
  Add(StrHealthFactors);
  Add(StrExams);
end;

procedure TPCEData.AddVitalData(Data, List: TStrings);
var
  i: integer;

begin
  for i := 0 to Data.Count-1 do
    List.Add(FormatVitalForNote(Data[i]));
end;

function TPCEData.PersonClassDate: TFMDateTime;
begin
  if(FEncSvcCat = 'H') then
    Result := FMToday
  else
    Result := FEncDateTime; //Encounter.DateTime;
end;

function TPCEData.VisitDateTime: TFMDateTime;
begin
  if(IsSecondaryVisit) then
    Result := FNoteDateTime
  else
    Result := FEncDateTime;
end;

function TPCEData.IsSecondaryVisit: boolean;
begin
  Result := ((FEncSvcCat = 'H') and (FNoteDateTime > 0) and (FEncInpatient));
end;

function TPCEData.NeedProviderInfo: boolean;
var
  i: integer;
  TmpLst: TStringList;

begin
  if(FProviders.PrimaryIdx < 0) then
  begin
    Result := AutoCheckout(FEncLocation);
    if not Result then
    begin
      for i := 0 to FDiagnoses.Count - 1 do
      begin
        if not TPCEDiag(FDiagnoses[i]).FDelete then
        begin
          Result := TRUE;
          break;
        end;
      end;
    end;
    if not Result then
    begin
      for i := 0 to FProcedures.Count - 1 do
      begin
        if not TPCEProc(FProcedures[i]).FDelete then
        begin
          Result := TRUE;
          break;
        end;
      end;
    end;
    if not Result then
    begin
      for i := 0 to FProviders.Count - 1 do
      begin
        if not FProviders[i].Delete then
        begin
          Result := TRUE;
          break;
        end;
      end;
    end;
    if not Result then
    begin
      TmpLst := TStringList.Create;
      try
        GetHasCPTList(TmpLst);
        if(DataHasCPTCodes(TmpLst)) then
          Result := TRUE;
      finally
        TmpLst.Free;
      end;
    end;
  end
  else
    Result := FALSE;
end;

procedure TPCEData.GetHasCPTList(AList: TStrings);

  procedure AddList(List: TList);
  var
    i: integer;
    tmp: string;

  begin
    for i := 0 to List.Count-1 do
    begin
      tmp := TPCEItem(List[i]).HasCPTStr;
      if(tmp <> '') then
        AList.Add(tmp);
    end;
  end;

begin
  AddList(FImmunizations);
  AddList(FSkinTests);
  AddList(FPatientEds);
  AddList(FHealthFactors);
  AddList(FExams);
end;

procedure TPCEData.CopyPCEItems(Src: TList; Dest: TObject; ItemClass: TPCEItemClass);
Type
 fDestType = (CopyCaptionList, CopyStrings, CopyList);
var
  AItem: TPCEItem;
  i: Integer;
  DestType: fDestType;
begin
  if (Dest is TCaptionListView) then
   DestType := CopyCaptionList
  else if(Dest is TStrings) then
     DestType := CopyStrings
   else
   if(Dest is TList) then
     DestType := CopyList
   else
     exit;

  for i := 0 to Src.Count - 1 do
  begin
    if(not TPCEItem(Src[i]).FDelete) then
    begin
      AItem := ItemClass.Create;
      AItem.Assign(TPCEItem(Src[i]));
      case DestType of
       CopyCaptionList: TCaptionListView(Dest).AddObject(AItem.ItemStr, AItem);
       CopyStrings: TStrings(Dest).AddObject(AItem.ItemStr, AItem);
       CopyList: TList(Dest).Add(AItem);
      end;

    end;
  end;
end;

function TPCEData.Empty: boolean;
begin
  Result := (FProviders.Count = 0);
  if(Result) then Result := (FSCRelated  = SCC_NA);
  if(Result) then Result := (FAORelated  = SCC_NA);
  if(Result) then Result := (FIRRelated  = SCC_NA);
  if(Result) then Result := (FECRelated  = SCC_NA);
  if(Result) then Result := (FMSTRelated = SCC_NA);
//  if(Result) and HNCOK then Result := (FHNCRelated = SCC_NA);
  if(Result) then Result := (FHNCRelated = SCC_NA);
  if(Result) then Result := (FCVRelated = SCC_NA);
  if(Result) then Result := (FSHADRelated = SCC_NA);
  if(Result) then Result := (FCLRelated = SCC_NA); //Camp Lejeune
  if(Result) then Result := (FDiagnoses.Count = 0);
  if(Result) then Result := (FProcedures.Count = 0);
  if(Result) then Result := (FImmunizations.Count = 0);
  if(Result) then Result := (FSkinTests.Count = 0);
  if(Result) then Result := (FPatientEds.Count = 0);
  if(Result) then Result := (FHealthFactors.Count = 0);
  if(Result) then Result := (fExams.Count = 0);
  if(Result) then Result := (FVisitType.Empty);
end;


{ TPCEProviderList }

function TPCEProviderList.Add(const S: string): Integer;
var
  SIEN: string;
  LastPrimary: integer;

begin
  SIEN := IntToStr(StrToInt64Def(Piece(S, U, pnumPrvdrIEN), 0));
  if(SIEN = '0') then
    Result := -1
  else
  begin
    LastPrimary := PrimaryIdx;
    Result := IndexOfProvider(SIEN);
    if(Result < 0) then
      Result := inherited Add(S)
    else
      Strings[Result] := S;
    if(Piece(S, U, pnumPrvdrPrimary) = '1') then
    begin
      FNoUpdate := TRUE;
      try
        SetPrimaryIdx(Result);
      finally
        FNoUpdate := FALSE;
      end;
      if(assigned(FOnPrimaryChanged) and (LastPrimary <> PrimaryIdx)) then
        FOnPrimaryChanged(Self);
    end;
  end;
end;

function TPCEProviderList.AddProvider(AIEN, AName: string; APrimary: boolean): integer;
var
  tmp: string;

begin
  tmp := 'PRV' + U + AIEN + U + U + U + AName + U;
  if(APrimary) then tmp := tmp + '1';
  Result := Add(tmp);
end;

procedure TPCEProviderList.Clear;
var
  DoNotify: boolean;

begin
  DoNotify := (assigned(FOnPrimaryChanged) and (GetPrimaryIdx >= 0));
  FPendingDefault := '';
  FPendingUser := '';
  FPCEProviderIEN := 0;
  FPCEProviderName := '';
  inherited;
  if(DoNotify) then
    FOnPrimaryChanged(Self);
end;

procedure TPCEProviderList.Delete(Index: Integer);
var
  DoNotify: boolean;

begin
  DoNotify := (assigned(FOnPrimaryChanged) and (Piece(Strings[Index], U, pnumPrvdrPrimary) = '1'));
  inherited Delete(Index);
  if(DoNotify) then
    FOnPrimaryChanged(Self);
end;

function TPCEProviderList.PCEProvider: Int64;

  function Check(AIEN: Int64): Int64;
  begin
    if(AIEN = 0) or (IndexOfProvider(IntToStr(AIEN)) < 0) then
      Result := 0
    else
      Result := AIEN;
  end;

begin
  Result := Check(Encounter.Provider);
  if(Result = 0) then Result := Check(User.DUZ);
  if(Result = 0) then Result := PrimaryIEN;
end;

function TPCEProviderList.PCEProviderName: string;
var
  NewProv: Int64;

begin
  NewProv := PCEProvider;
  if(FPCEProviderIEN <> NewProv) then
  begin
    FPCEProviderIEN := NewProv;
    FPCEProviderName := ExternalName(PCEProvider, FN_NEW_PERSON);
  end;
  Result := FPCEProviderName;
end;

function TPCEProviderList.GetPrimaryIdx: integer;
begin
  Result := IndexOfPiece('1', U, pnumPrvdrPrimary);
end;

function TPCEProviderList.GetProviderData(Index: integer): TPCEProviderRec;
var
  X: string;

begin
  X := Strings[Index];
  Result.IEN     := StrToInt64Def(Piece(X, U, pnumPrvdrIEN), 0);
  Result.Name    := Piece(X, U, pnumPrvdrName);
  Result.Primary := (Piece(X, U, pnumPrvdrPrimary) = '1');
  Result.Delete  := (Piece(X, U, 1) = 'PRV-');
end;

function TPCEProviderList.IndexOfProvider(AIEN: string): integer;
begin
  Result := IndexOfPiece(AIEN, U, pnumPrvdrIEN);
end;

procedure TPCEProviderList.Merge(AList: TPCEProviderList);
var
  i, idx: integer;
  tmp: string;

begin
  for i := 0 to Count-1 do
  begin
    tmp := Strings[i];
    idx := AList.IndexOfProvider(Piece(tmp, U, pnumPrvdrIEN));
    if(idx < 0) then
    begin
      SetPiece(tmp, U, 1, 'PRV-');
      Strings[i] := tmp;
    end;
  end;
  for i := 0 to AList.Count-1 do
    Add(AList.Strings[i]); // Add already filters out duplicates
end;

function TPCEProviderList.PendingIEN(ADefault: boolean): Int64;
begin
  if(ADefault) then
    Result := StrToInt64Def(Piece(FPendingDefault, U, 1), 0)
  else
    Result := StrToInt64Def(Piece(FPendingUser, U, 1), 0);
end;

function TPCEProviderList.PendingName(ADefault: boolean): string;
begin
  if(ADefault) then
    Result := Piece(FPendingDefault, U, 2)
  else
    Result := Piece(FPendingUser, U, 2);
end;

function TPCEProviderList.PrimaryIEN: int64;
var
  idx: integer;

begin
  idx := GetPrimaryIdx;
  if(idx < 0) then
    Result := 0
  else
    Result := StrToInt64Def(Piece(Strings[idx], U, pnumPrvdrIEN), 0);
end;

function TPCEProviderList.PrimaryName: string;
var
  idx: integer;

begin
  idx := GetPrimaryIdx;
  if(idx < 0) then
    Result := ''
  else
    Result := Piece(Strings[idx], U, pnumPrvdrName);
end;

procedure TPCEProviderList.SetPrimary(index: integer; Primary: boolean);
var
  tmp, x: string;

begin
  tmp := Strings[index];
  if(Primary) then
    x := '1'
  else
    x := '';
  SetPiece(tmp, U, pnumPrvdrPrimary, x);
  Strings[Index] := tmp;
end;

procedure TPCEProviderList.SetPrimaryIdx(const Value: integer);
var
  LastPrimary, idx: integer;
  Found: boolean;

begin
  LastPrimary := GetPrimaryIdx;
  idx := -1;
  Found := FALSE;
  repeat
    idx := IndexOfPiece('1', U, pnumPrvdrPrimary, idx);
    if(idx >= 0) then
    begin
      if(idx = Value) then
        Found := TRUE
      else
        SetPrimary(idx, FALSE);
    end;
  until(idx < 0);
  if(not Found) and (Value >= 0) and (Value < Count) then
    SetPrimary(Value, TRUE);
  if((not FNoUpdate) and assigned(FOnPrimaryChanged) and (LastPrimary <> Value)) then
    FOnPrimaryChanged(Self);
end;

procedure TPCEProviderList.SetProviderData(Index: integer;
  const Value: TPCEProviderRec);
var
  tmp, SIEN: string;

begin
  if(Value.IEN = 0) or (index < 0) or (index >= Count) then exit;
  SIEN := IntToStr(Value.IEN);
  if(IndexOfPiece(SIEN, U, pnumPrvdrIEN) = index) then
  begin
    tmp := 'PRV';
    if(Value.Delete) then tmp := tmp + '-';
    tmp := tmp + U + SIEN + U + U + U + Value.Name + U;
    Strings[index] := tmp;
    if Value.Primary then
      SetPrimaryIdx(Index);
  end;
end;

procedure TPCEProviderList.Assign(Source: TPersistent);
var
  Src: TPCEProviderList;

begin
  inherited Assign(Source);
  if(Source is TPCEProviderList) then
  begin
    Src := TPCEProviderList(Source);
    Src.FOnPrimaryChanged := FOnPrimaryChanged;
    Src.FPendingDefault := FPendingDefault;
    Src.FPendingUser := FPendingUser;
    Src.FPCEProviderIEN := FPCEProviderIEN;
    Src.FPCEProviderName := FPCEProviderName;
  end;
end;

initialization

finalization
  KillObj(@PCESetsOfCodes);
  KillObj(@HistLocations);

end.
