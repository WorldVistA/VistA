unit uPCE;

interface

uses Windows, SysUtils, Classes, ORFn, uConst, ORCtrls, ORClasses,UBAGlobals,
  ComCtrls, rVimm, StdCtrls, Messages, Forms, vcl.Controls, system.JSON;

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
    FPCEProviderForce: Int64;
    FPCEProviderNameForce: string;
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
    function PCEProviderForce: Int64;
    function PCEProviderNameForce: string;
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
    FCode:     string;
  protected
    procedure SetComment(const Value: String);
    procedure SetCode(const Value: string); virtual;
  public
//    Provider:  Int64;
    Provider:  Int64;
    Category:  string;
    Narrative: string;
    FGecRem: string;
    constructor Create;
    procedure Assign(Src: TPCEItem); virtual;
    procedure Clear; virtual;
    function DelimitedStr: string; virtual;
    function DelimitedStr2: string; virtual;
    function ItemStr: string; virtual;
    function Match(AnItem: TPCEItem): Boolean;
    function MatchPOV(AnItem: TPCEItem): Boolean;
    function isDeleted: boolean;
//    function MatchProvider(AnItem: TPCEItem):Boolean;
    function MatchProvider(AnItem: TPCEItem):Boolean;
    procedure SetFromString(const x: string); virtual;
    function HasCPTStr: string; virtual;
    property Comment: String read FComment write SetComment;
    property GecRem: string read FGecRem write FGecRem;
    property Code: string read FCode write SetCode;
  end;

  TPCEItemClass = class of TPCEItem;

  TUCUMDataType = (udtNumber, udtDate, udtTime);

  TUCUMInfo = class(TObject)
  private
    FMin: Extended;
    FMax: Extended;
    FDec: integer;
    FCode: string;
    FPromptCaption: string;
    FUCUMCaption: string;
    FDataType: TUCUMDataType;
  protected
    function Fmat(val: Extended): string;
  public
    constructor Create(UCUMData: string);
    procedure Update(UCUMData: string);
    function Validate(var Value: string; OverridePrompt: string = ''): string;
    function HintText: string;
    property Code: string read FCode;
    property PromptCaption: string read FPromptCaption;
    property UCUMCaption: string read FUCUMCaption;
  end;

  TPCEMagItem = class(TPCEItem)
  private
    FMagnitude: string;
    FUCUMCode: string;
    FUCUMInfo: TUCUMInfo;
    procedure SetMagnitude(const Value: string);
  protected
    procedure SetCode(const Value: string); override;
    function GetUCUMMagCode: string; virtual;
    function Prefix: string; virtual; abstract;
  public
    procedure Assign(Src: TPCEItem); override;
    procedure Clear; override;
    function DelimitedStr: string; override;
    procedure SetFromString(const x: string); override;
    property Magnitude: string read FMagnitude write SetMagnitude;
    property UCUMCode: string read FUCUMCode write FUCUMCode;
    property UCUMInfo: TUCUMInfo read FUCUMInfo;
  end;

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
    OldNarrative: string;
    procedure Assign(Src: TPCEItem); override;
    procedure Clear; override;
    function DelimitedStr: string; override;
    function DelimitedStr2: string; override;
//    function delimitedStrC: string;
    function ItemStr: string; override;
    procedure SetFromString(const x: string); override;
    procedure Send;
  end;

  TPCEExams = class(TPCEMagItem)
  {class for Examinations}
  protected
    function Prefix: string; override;
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

{class for Health Factors}
  TPCEHealth = class(TPCEMagItem)
  protected
    function Prefix: string; override;
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
    ContraIEN:       string;
    Contra:          string;
    RefusedIEN:      string;
    RefusedText:     string;
    lot:             String;
    administratedBy: String;
    orderBy:         String;
    route:           String;
    site:            String;
    dosage:          String;
    vis:             String;
    visDate:         TFMDateTime;
    remarks:         String;
    documType       : string;
    routeIEN        : string;
    siteIEN         : string;
    adminByIEN      : string;
    orderByIEN      : string;
    overrideReason  : string;
    documentType    : string;
    warnDate        : string;
    orderByPolicy   : boolean;
    delimitedStrTxt    : string;
    delimitedStr1Txt   : string;
    delimitedStr2Txt  : string;
    constructor Create(data: TVimmResult); overload;
    constructor Create(x: string); overload;
    procedure Assign(Src: TPCEItem); override;
    procedure Clear; override;
    function DelimitedStr: string; override;
//    function delimitedStrC: string;
    function ItemStr: string; override;
    procedure SetFromString(const x: string); override;
    function HasCPTStr: string; override;
    function getVimmStr: string;
//    procedure getVimmImmResults(var resultList: TStringList);
  end;

  {class for patient Education}
  TPCEPat = class(TPCEMagItem)
  protected
    function Prefix: string; override;
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
//    Reading:   Integer;
    Reading: string;
    DTRead:    TFMDateTime;
    DTGiven:   TFMDateTime;
    administratedBy: String;
    orderBy:         String;
    site:            String;
    documType       : string;
    siteIEN         : string;
    adminByIEN      : string;
    orderByIEN      : string;
    documentType    : string;
    delimitedStrTxt    : string;
    delimitedStr1Txt   : string;
//    delimitedStr2Txt  : string;
    readBy            : string;
    readByIEN         : string;
    readDate          : string;
    readingComments   : string;
//    delimitedStr2Txt  : string;
    constructor Create(data: TVimmResult); overload;
    constructor Create(x: string); overload;
    procedure Assign(Src: TPCEItem); override;
    procedure Clear; override;
    function DelimitedStr: string; override;
//    function delimitedStrC: string;
    function ItemStr: string; override;
    procedure SetFromString(const x: string); override;
    function HasCPTStr: string; override;
  end;

//  TPCEData = class;

  TGenFindings = class(TPCEItem)
  {class for Reminder General Findings only used for displaying in the
  encounter pane note}
  public

  end;

  TCodingSystem = (csNone, csSNOMED);

const
  CodingSystemID: array[TCodingSystem] of string =
                       {csNone}  ('',
                       {csSNOMED} 'SCT');
  CodingSystemDesc: array[TCodingSystem] of string =
                       {csNone}  ('',
                       {csSNOMED} 'SNOMED CT');
//  CodingSystemLongDesc: array[TCodingSystem] of string =
//                       {csNone}  ('',
//                       {csSNOMED} 'SNOMED Clinical Terms');

type
  TStandardCode = class(TPCEMagItem)
  private
    FCodingSystem: TCodingSystem;
    FAdd2PL: boolean;
    FTaxId: integer;
    procedure SetTaxID(const Value: integer);
  protected
    function GetUCUMMagCode: string; override;
    function Prefix: string; override;
  public
    procedure Assign(Src: TPCEItem); override;
    procedure Clear; override;
    function DelimitedStr: string; override;
    procedure SetFromString(const x: string); override;
    function ItemStr: string; override;
    property CodingSystem: TCodingSystem read FCodingSystem write FCodingSystem;
    property Add2PL: boolean read FAdd2PL write FAdd2PL;
    property TaxId: integer read FTaxId write SetTaxID;
  end;

  tRequiredPCEDataType = (ndDiag, ndProc, ndSC, ndLock); {jm 9/9/99}
  tRequiredPCEDataTypes = set of tRequiredPCEDataType;

  TPCEDataCat = (pdcVisit, pdcDiag, pdcProc, pdcImm, pdcSkin, pdcPED, pdcHF,
                 pdcExam, pdcVital, pdcOrder, pdcMH, pdcMST, pdcHNC, pdcWHR,
                 pdcWH, pdcGenFinding, pdcStandardCodes);

  TPCEData = class
  {class for data to be passed to and from broker}
  private
    FUpdated:      boolean;
    FEncDateTime:  TFMDateTime;                    //encounter date & time
    FNoteDateTime: TFMDateTime;                    //Note date & time
    FEncLocation:  Integer;                        //encounter location
    FEncSvcCat:    Char;                           //
//    FEncInpatient: Boolean;                        //Inpatient flag
    FEncUseCurr:   Boolean;                        //
    FSCChanged:    Boolean;                        //
    FSCRelated:    Integer;                        //service con. related?
    FAORelated:    Integer;                        //
    FIRRelated:    Integer;                        //
    FECRelated:    Integer;                        //
    FMSTRelated:   Integer;                        //
    FHNCRelated:   Integer;                        //
    FCVRelated:    Integer;                        //
    FSHADRelated:   Integer;                       //
    FCLRelated:    Integer;                        //
    FVisitType:    TPCEProc;                       //
    FProviders:    TPCEProviderList;
    FDiagnoses:    TList;                          // pointer list for diagnosis
    FProcedures:   TList;                          // pointer list for Procedures
    FImmunizations: TList;                         // pointer list for Immunizations
    FSkinTests:     TList;                         // pointer list for skin tests
    FPatientEds:    TList;                         // pointer list for Patient Education
    FHealthFactors: TList;                         // pointer list for Health Factors
    FGenFindings:   TList;                         // pointer list for General Findings
    fExams:         TList;                         // pointer list for Exams
    FStandardCodes: TList;                         // pointer list for Standard Codes
    FNoteTitle:    Integer;
    FNoteIEN:      Integer;
    FParent:       string;                         // Parent Visit for secondary encounters
    FHistoricalLocation: string;                   // Institution IEN^Name (if IEN=0 Piece 4 = outside location)
    FStandAlone: boolean;
    FStandAloneLoaded: boolean;
    FProblemAdded: Boolean;                        // Flag set when one or more Dx are added to PL
    FEncounterLock: boolean;
    FVisitIEN: Integer;
    FVisitIENIsPrimary: boolean;
    function GetInpatient: boolean;
    function GetVisitString: string;
    function GetCPTRequired: Boolean;
    function getDocCount: Integer;
    function MatchItem(AList: TList; AnItem: TPCEItem): Integer;
    function MatchPOVItems(AList: TList; AnItem: TPCEItem): Integer;
    function MatchIMMItems(AList: TList; AnItem: TPCEIMM): Integer;
    function MatchSkinTestItems(AList: TList; AnItem: TPCESkin): Integer;
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
    function AddTitle(Cat: TPCEDataCat; input: string): string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure CopyPCEData(Dest: TPCEData);
    function Empty: boolean;
    procedure PCEForNote(NoteIEN: Integer); //EditObj: TPCEData);
    function Save: boolean;
    procedure CopyDiagnoses(Dest: TCaptionListView);     // ICDcode^P|S^Category^Narrative^P|S Text
    procedure CopyProcedures(Dest: TCaptionListView);    // CPTcode^Qty^Category^Narrative^Qty Text
    procedure CopyImmunizations(Dest: TCaptionListView); //
    procedure CopySkinTests(Dest: TCaptionListView);     //
    procedure CopyPatientEds(Dest: TCaptionListView);
    procedure CopyHealthFactors(Dest: TCaptionListView);
    procedure CopyExams(Dest: TCaptionListView);
    procedure CopyGenFindings(Dest: TCaptionListView);
    procedure CopyStandardCodes(Dest: TCaptionListView);
    procedure SetDiagnoses(Src: TStrings; FromForm: boolean = TRUE);       // ICDcode^P|S^Category^Narrative^P|S Text
    procedure SetExams(Src: TStrings; FromForm: boolean = TRUE);
    Procedure SetHealthFactors(Src: TStrings; FromForm: boolean = TRUE);
    procedure SetImmunizations(Src: TStrings; FromForm: boolean = TRUE; vimmData: TVimmResult = nil);   // IMMcode^
    Procedure SetPatientEds(Src: TStrings; FromForm: boolean = TRUE);
    procedure SetSkinTests(Src: TStrings; FromForm: boolean = TRUE; vimmData: TVimmResult = nil);        //
    procedure SetProcedures(Src: TStrings; FromForm: boolean = TRUE);      // CPTcode^Qty^Category^Narrative^Qty Text
    procedure SetGenFindings(Src: TStrings; FromForm: boolean = TRUE);
    procedure SetStandardCodes(Src: TStrings; FromForm: boolean = TRUE);
    procedure markProcedureCodeForDeletion(deleteCode: string);
    procedure SetVisitType(Value: TPCEProc);     // CPTcode^1^Category^Narrative
    function StrDiagnoses: string;               // Diagnoses: ...
    function StrImmunizations: string;           // Immunizzations: ...
    function StrProcedures: string;              // Procedures: ...
    function StrSkinTests: string;
    function StrPatientEds: string;
    function StrHealthFactors: string;
    function StrExams: string;
    function StrGenFindings: string;
    function StrStandardCodes: string;
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
    function VisitDateTimeForce: TFMDateTime;
    function IsSecondaryVisit: boolean;
    function NeedProviderInfo: boolean;
    function proceduresMissingProvider: boolean;
    function validateMagnitudeValues: boolean;
    procedure getVimmResults(var resultList: TStringList);
    function GetICDVersion: String;
    property HasData:      Boolean  read GetHasData;
    property CPTRequired:  Boolean  read GetCPTRequired;
    property ProblemAdded: Boolean  read FProblemAdded;
    property Inpatient:    Boolean  read GetInpatient;
    property UseEncounter: Boolean  read FEncUseCurr  write SetEncUseCurr;
    property SCRelated:    Integer  read FSCRelated   write SetSCRelated;
    property AORelated:    Integer  read FAORelated   write SetAORelated;
    property IRRelated:    Integer  read FIRRelated   write SetIRRelated;
    property ECRelated:    Integer  read FECRelated   write SetECRelated;
    property MSTRelated:   Integer  read FMSTRelated  write SetMSTRelated;
    property HNCRelated:   Integer  read FHNCRelated  write SetHNCRelated;
    property CVRelated:    Integer  read FCVRelated   write SetCVRelated;
    property SHADRelated:   Integer read FSHADRelated write SetSHADRelated;
    property CLRelated:    Integer  read FCLRelated   write SetCLRelated;
    property VisitType:    TPCEProc read FVisitType   write SetVisitType;
    property VisitString:  string   read GetVisitString;
    property VisitCategory:char     read FEncSvcCat   write FEncSvcCat;
    property DateTime:     TFMDateTime read FEncDateTime write FEncDateTime;
    property NoteDateTime: TFMDateTime read FNoteDateTime write FNoteDateTime;
    property Location:     Integer read FEncLocation write FEncLocation;
    property NoteTitle:    Integer read FNoteTitle write FNoteTitle;
    property NoteIEN:      Integer read FNoteIEN write FNoteIEN;
    property DocCount:     Integer read GetDocCount;
    property Providers:    TPCEProviderList read FProviders;
    property Parent:       string read FParent write FParent;
    property HistoricalLocation: string read FHistoricalLocation write FHistoricalLocation;
    property Updated: boolean read FUpdated write FUpdated;
    property VisitIEN: Integer read FVisitIEN write FVisitIEN;
    property VisitIENIsPrimary: boolean read FVisitIENIsPrimary write FVisitIENIsPrimary;
    property Procedures: TList read FProcedures;
    property Diagnoses: TList read FDiagnoses;
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
procedure ParseMagUCUM4StandardCodes(edtMag: TDataEdit);
procedure ParseMagUCUMData(Info: TUCUMInfo; lblMag: TLabel;
  edtMag: TDataEdit; lblUCUM, lblUCUM2: TLabel);
function ValidateMagnitudeMessage(edtMag: TDataEdit): string;
procedure ValidateMagKeyPress(Sender: TObject; var Key: Char);
procedure PostValidateMag(edtMag: TDataEdit);
function HandlePostValidateMag(Message: TMessage): boolean;
function ProcessPostedValidateMag(form: TCustomForm): boolean;
procedure ClearPostValidateMag(form: TCustomForm);
function GetUCUMText(UCUMCode: Int64): string;

function GetPCEDataText(Cat: TPCEDataCat; Code, Category, Narrative: string;
  PrimaryDiag: boolean = FALSE; Qty: integer = 0; CodingSystem: string = ''): string;
function getSeriesExternal(series: string): string;
//  Mag: Double = 0.0; UCUMCode: string = ''): string;

function GetImmContraText(Contraindicated, Refused: boolean): string;

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
                        { dcWH    }  'WH Notification: ',
                        { dcGF    }  'General Findings: ',
                        { dcStd   }  'Standard Codes: ');

  NoPCEValue = '@';
  UM_VALIDATE_MAG = WM_USER + 387; // Used to validate Magnitude values
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
  TX_ISLOCK     = ' The encounter data was not updated last time because of a lock on the record.';
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
  pnumAdd2PL            = -1;
  pnumID                = 1;
  pnumCode              = 2;
  pnumPrvdrIEN          = 2;
  pnumCategory          = 3;
  pnumNarrative         = 4;
  pnumExamResults       = 5;
  pnumSkinResults       = 5;
  pnumHFLevel           = 5;
  pnumImmSeries         = 5;
  pnumProcQty           = 5;
  pnumPEDLevel          = 5;
  pnumDiagPrimary       = 5;
  pnumPrvdrName         = 5;
  pnumCodingSystem      = 5;
  pnumProvider          = 6;
  pnumPrvdrPrimary      = 6;
  pnumWarnDate          = 6;
  pnumSkinReading       = 7;
  pnumImmReaction       = 7;
  pnumCodesMagnitude    = 7;
  pnumPOVAdd2PL         = 7;
  pnumCodesUCUM         = 8;
  pnumSkinDTRead        = 8;
  pnumImmContra         = 8;
  pnumSCAdd2PL          = 9;
  pnumSkinDTGiven       = 9;
  pnumImmRefused        = 9;
  pnumCPTMods           = 9;
  pnumComment           = 10;
  pnumSkinReader        = 11;
  pnumSkinReaderIEN     = 11;
  pnumWHPapResult       = 11;

  pnumWHNotPurp         = 12;
//  pnumImmAdminBy      = 6;
  pnumDataSource        = 12;
  pnumDate              = 13;
  pnumImmDosage         = 13;
  pnumImmOrderBy        = 20;
  pnumRemGenFindID      = 14;
  pnumImmRoute          = 14;
  pnumImmSite           = 15;
  pnumImmLot            = 16;
  pnumRemGenFindNewData = 16;
  pnumRemGenFindGroup   = 17;
  pnumImmManufacturer   = 17;
  pnumExpirationDate    = 18;
//  pnumImmRouteIEN       = 18;
  pnumGFPrint           = 18;

  pnumPDMP              = 18;

  pnumAdminDate         = 19;
//  pnumImmSiteIEN        = 19;
//  pnumImmAdminByIEN  = 6;
  pnumIMMOrderByIEN     = 20;
  pnumIMMVIS            = 21;
  pnumImmOverride       = 24;
  pnumImmDelimitedStr   = 25;
  pnumImmDelimitedStr1  = 26;
  pnumImmDelimitedStr2  = 27;
  pnumImmDocumType      = 30;
  pnumImmCodes          = 31;

  USE_CURRENT_VISITSTR = -2;
  EMPTY_VISIT_STRING = '0;0;A';

var
  CurrentTabPCEObject: TPCEData = nil;

implementation

uses uCore, rPCE, rCore, rTIU, fEncounterFrame, uVitals, fFrame,
  fPCEProvider, rVitals, uReminders, rMisc, uGlobalVar, uDlgComponents,
  fReminderDialog, uMisc, uWriteAccess;

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
//  Code should no longer be needed, this is called from Reminders which in note based encounter and
//  on signing a note. When signing a note the encounter object should be based on the note encounter and
//  not the overall encounter
//  if(PCEEdit.Empty and (PCEEdit.Location <> Encounter.Location) and (not Encounter.NeedVisit) then
//      PCEEdit.UseEncounter := TRUE;
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
    Result := PCEData.OK2SignNote;
  end
  else
  begin
    TmpPCEData := TPCEData.Create;
    try
      TmpPCEData.PCEForNote(IEN);
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
  TLen, i, gap: integer;
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
  gap := ScrollBarWidth;
  if (dest.Style = orcsDropDown) and (gap < dest.height) then
    gap := dest.Height;
  inc(gap, 16);
  inc(Min, gap);
  inc(Max, gap);
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
  end;
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
  PrimaryDiag: boolean = FALSE; Qty: integer = 0; CodingSystem: string = ''): string;
//  Mag: Double = 0.0; UCUMCode: string = ''): string;

//  procedure AddMag;
//  var
//    txt: string;
//  begin
//    if Mag <> 0.0 then
//    begin
//      Result := Result + ', ' + Mag.ToString;
//      if UCUMCode <> '' then
//      begin
//        txt := ExternalName(StrToInt64Def(UCUMCode, 0), 757.5);
//        if txt <> '' then
//          Result := Result + ' ' + txt;
//      end;
//    end;
//  end;

begin
  Result := '';
//  Result := Narrative;
  case Cat of
    pdcVisit: if Code <> '' then Result := Category + ' ' + Narrative;
    pdcDiag:  begin
                Result := GetDiagnosisText(Narrative, Code);
                if PrimaryDiag then Result := Result + ' (Primary)';
              end;
    pdcProc:  begin
                Result := Narrative;
                if Qty > 1 then Result := Result + ' (' + IntToStr(Qty) + ' times)';
              end;
//    pdcHF:    AddMag;
//    pdcPED:   AddMag;
//    pdcExam:  AddMag;
    pdcStandardCodes:
              begin
                if CodingSystem <> '' then
                  Result := CodingSystem + ' ' + Result;
                Result := Narrative + ' (' + Result + Code + ')';
//                AddMag;
              end
    else Result := Narrative;
  end;
end;

function getSeriesExternal(series: string): string;
var
arrayJson: TJSONArray;
jv, jsv, value: TJSONValue;
begin
 result := series;
 jv := SystemParameters.JSONValue['series'];
 arrayJson := jv as TJSONArray;
 for value in arrayJSon do
 begin
   if value.TryGetValue('internal', jsv) then
   begin
   if jsv.Value = series then
   begin
     if value.TryGetValue('external', jsv) then
     begin
      result := jsv.Value;
      exit;
     end;
   end;
   end;
 end;
end;

function GetImmContraText(Contraindicated, Refused: boolean): string;
begin
  Result := '';
  if Contraindicated then
    Result := Result + ' (CONTRAINDICATED)';
  if Refused then
    Result := Result + ' (REFUSED))';
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
  SIEN := IntToStr(StrToInt64Def(Piece(tmp,U,1),0));
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
    Result := 'This patient died ' + FormatFMDateTime('mmm dd, yyyy hh:nn', Patient.DateDied) +
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

function TPCEItem.DelimitedStr2: string;
//Purpose: Return comment string to be passed in RPC call.
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
  if Self.ClassType <> Src.ClassType then
    raise Exception.Create('Invalid Assign - PCE class ' + Src.ClassName +
      ' Assigned to ' + Self.ClassName + ' Object');
  FDelete   := Src.FDelete;
  FSend     := Src.FSend;
  Code      := Src.Code;
  Category  := Src.Category;
  Narrative := Src.Narrative;
  Provider  := Src.Provider;
  Comment   := Src.Comment;
  GecRem    := Src.GecRem;
end;

procedure TPCEItem.SetCode(const Value: string);
begin
  FCode := Value;
end;

procedure TPCEItem.SetComment(const Value: String);
begin
  FComment := Value;
  while (length(FComment) > 0) and (FComment[1] = '?') do
    delete(FComment,1,1);
end;

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
  GecRem    := '';
end;

constructor TPCEItem.Create;
begin
  inherited Create;
  Clear;
end;

function TPCEItem.DelimitedStr: string;
{created delimited string to pass to broker}
var
  DelFlag: Char;
begin
  if FDelete then DelFlag := '-' else DelFlag := '+';
  Result := DelFlag + U + Code + U + Category + U + Narrative;
  SetPiece(Result, U, pnumComment, IntToStr(UNxtCommSeqNum));
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

function TPCEItem.isDeleted: boolean;
begin
  result := FDelete;
end;

procedure TPCEItem.SetFromString(const x: string);
{ sets fields to pieces passed from server:  TYP ^ Code ^ Category ^ Narrative }
begin
  Code      := Piece(x, U, pnumCode);
  Category  := Piece(x, U, pnumCategory);
  Narrative := Piece(x, U, pnumNarrative);
  Provider  := StrToInt64Def(Piece(x, U, pnumProvider), 0);
  Comment   := Piece(x, U, pnumComment);
end;

{ TPCEMagItem }

procedure TPCEMagItem.Assign(Src: TPCEItem);
begin
  inherited;
  FUCUMCode := TPCEMagItem(Src).FUCUMCode;
  FMagnitude := TPCEMagItem(Src).FMagnitude;
  FUCUMInfo := TPCEMagItem(Src).FUCUMInfo;
end;

procedure TPCEMagItem.Clear;
begin
  inherited;
  FUCUMCode := '';
  FMagnitude := '';
  FUCUMInfo := nil;
end;

function TPCEMagItem.DelimitedStr: string;
begin
  Result := inherited DelimitedStr;
  if (not assigned(FUCUMInfo)) or (FMagnitude = '') then
  begin
    SetPiece(Result, U, pnumCodesMagnitude, '');
    SetPiece(Result, U, pnumCodesUCUM, '');
  end
  else
  begin
    SetPiece(Result, U, pnumCodesMagnitude, FMagnitude);
    SetPiece(Result, U, pnumCodesUCUM, FUCUMCode);
  end;
end;

function TPCEMagItem.GetUCUMMagCode: string;
begin
  Result := Code;
end;

procedure TPCEMagItem.SetCode(const Value: string);
begin
  if Code <> Value then
  begin
    inherited;
    FUCUMInfo := GetUCUMInfo(Prefix, GetUCUMMagCode);
  end;
end;

procedure TPCEMagItem.SetFromString(const x: string);
begin
  inherited SetFromString(x); // loads FUCUMInfo in SetCode
  Magnitude := Piece(x, U, pnumCodesMagnitude);
  FUCUMCode := Piece(x, U, pnumCodesUCUM);
end;

procedure TPCEMagItem.SetMagnitude(const Value: string);
var
  newValue: string;

begin
  newValue := Value;
  if assigned(FUCUMInfo) then
    FUCUMInfo.Validate(newValue);
  FMagnitude := newValue;
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

function TPCEExams.DelimitedStr: string;
{created delimited string to pass to broker}
begin
  Result := Prefix + inherited DelimitedStr;
  SetPiece(Result, U, pnumExamResults, Results);
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

function TPCEExams.Prefix: string;
begin
  Result := 'XAM';
end;

procedure TPCEExams.SetFromString(const x: string);
{ sets fields to pieces passed from server:  TYP ^ Code ^ Category ^ Narrative ^ Qty ^ Prov }
begin
  inherited SetFromString(x);
//  Provider := StrToInt64Def(Piece(x, U, pnumProvider), 0);
  Results  := Piece(x, U, pnumExamResults);
  If Results = '' then Results := NoPCEValue;
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
  administratedBy := SKSrc.administratedBy;
  orderBy         := SKSrc.orderBy;
  site            := SKSrc.site;
  siteIEN         := SKSrc.siteIEN;
  adminByIEN      := SKSrc.adminByIEN;
  orderBYIEN      := SKSrc.orderByIEN;
  documType       := SKSrc.documType;
  delimitedStrTxt := SKSrc.delimitedStrTxt;
  delimitedStr1Txt := SKSrc.delimitedStr1Txt;

  if Results = '' then Results := NoPCEValue;
end;

procedure TPCESkin.Clear;
{clear fields(properties) of class}
begin
  inherited Clear;
//  Provider := 0;
  Results := NoPCEValue;
  Reading   := '0';
  DTRead    := 0.0;        //What should dates be ititialized to?
  DTGiven   := 0.0;
end;

constructor TPCESkin.Create(x: string);
var
temp: string;
begin
  inherited Create;
  Code      := Piece(x, U, pnumCode);
  Category  := Piece(x, U, pnumCategory);
  Narrative := Piece(x, U, pnumNarrative);
  temp := Piece(x, U, pnumProvider);
  Provider  := StrToInt64Def(Piece(temp, ';', 1), 0);
  AdminByIEN := Piece(temp, ';', 1);
  administratedBy := Piece(temp, ';', 2);
  if Piece(x, U, pnumSkinResults) = 'Doubtful' then
    Results := 'Unknown'
  else Results := Piece(x, U, pnumSkinResults);
  Reading := Piece(x, U, pnumSkinReading);
  temp := Piece(x, U, pnumSkinReader);
  readDate := Piece(x, U, pnumSkinDTRead);
  if temp <> '' then
    begin
      readByIEN := Piece(temp, ';', 1);
      readBy := Piece(temp, ';', 2);
    end;
  temp := Piece(x, U, 13);
  if temp <> '' then siteIEN := Piece(temp, ';', 1);
  delimitedStrTxt :=  x;
  if Results <> '' then
    begin
      readingComments := Piece(x, U, 14);
      SetPiece(delimitedStrTxt, U, 14, '1');
      delimitedStr1Txt := 'COM^1^' + readingComments;
    end
  else
    begin
      Comment   := Piece(x, U, pnumComment);
      SetPiece(delimitedStrTxt, U, pnumComment, '1');
      delimitedStr1Txt := 'COM^1^' + comment;
    end;
//  delimitedStrTxt :=  x;
//  SetPiece(delimitedStrTxt, U, 20, orderByIEN);
end;

constructor TPCESkin.Create(data: TVimmResult);
begin
  inherited Create;
    Code := data.id;
    Narrative := data.name;
    Reading := data.getReadingValue;
    Results := data.getReadingResult;
//    administratedBy := data.adminBy;
////    orderBy := data.orderBy;
//    site := data.site;
//    documType := data.documType;
//    siteIEN := data.siteIEN;
//    adminByIEN := data.adminByIEN;
////    orderByIEN := data.orderByIEN;
//    dtRead := data.readDate;
//    Reading := data.numResult;
//    Results := data.subjectiveResult;
    delimitedStrTxt    := Data.DelimitedStr;
    delimitedStr1Txt   := Data.DelimitedStr2;
//    delimitedStr2Txt  := Data.DelimitedStr3(num);
end;

//Purpose: Add Comments to PCE Items.
function TPCESkin.DelimitedStr: string;
{created delimited string to pass to broker}
var
 ReadingToPassIn : String;
begin
  Result := 'SK' + inherited DelimitedStr;
  if Uppercase(results) = 'O' then ReadingToPassIn := NoPCEValue
  else ReadingToPassIn := Reading;
  SetPiece(Result, U, pnumSkinResults, Results);
  SetPiece(Result, U, pnumSkinReading, ReadingToPassIn);
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
  if(Results <> NoPCEValue) and (Results <> '') then
//    Result := GetPCECodeString(TAG_SKRESULTS, Results)
    Result := Results
  else
    Result := '';
  Result := Result + U;
//  if(Reading <> 0) then
//    Result := Result + IntToStr(Reading);
  Result := Result + Reading;
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
//    Reading  := StrToInt(sRead);
      Reading := sRead;
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

function TPCEHealth.DelimitedStr: string;
{created delimited string to pass to broker}
begin
  Result := Prefix + inherited DelimitedStr;
  SetPiece(Result, U, pnumHFLevel, Level);
  SetPiece(Result, U, 11, GecRem);
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

function TPCEHealth.Prefix: string;
begin
  Result := 'HF';
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
  lot             := IMMSrc.lot;
  administratedBy := IMMSrc.administratedBy;
  orderBy         := IMMSrc.orderBy;
  route           := IMMSrc.route;
  site            := IMMSrc.site;
  dosage          := IMMSrc.dosage;
  routeIEN        := IMMSrc.routeIEN;
  siteIEN         := IMMSrc.siteIEN;
  adminByIEN      := IMMSrc.adminByIEN;
  orderBYIEN      := IMMSrc.orderByIEN;
  documType       := IMMSrc.documType;
  overrideReason  := ImmSrc.overrideReason;
  delimitedStrTxt := ImmSrc.delimitedStrTxt;
  delimitedStr1Txt := ImmSrc.delimitedStr1Txt;
  delimitedStr2Txt := ImmSrc.delimitedStr2Txt;
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

constructor TPCEImm.Create(x: string);
var
temp, vis: string;
begin
  inherited Create;
  Code      := Piece(x, U, pnumCode);
  Category  := Piece(x, U, pnumCategory);
  Narrative := Piece(x, U, pnumNarrative);
  temp := Piece(x, U, pnumProvider);
  Provider  := StrToInt64Def(Piece(temp, ';', 1), 0);
  AdminByIEN := Piece(temp, ';', 1);
  administratedBy := Piece(temp, ';', 2);
  Comment   := Piece(x, U, pnumComment);
  Series   := Piece(x, U, pnumImmSeries);
  Reaction := Piece(x, U, pnumImmReaction);
//  temp     := Piece(x, U, pnumImmRefused);
  temp := Piece(x, U, pnumImmLot);
  lot      := Piece(temp, ';', 1);
  administratedBy := Piece(x, U, pnumProvider);
  dosage   := Piece(x, U, pnumImmDosage);
  temp := Piece(x, U, pnumImmRoute);
  routeIEN := Piece(temp, ';', 1);
  temp := Piece(x, U, pnumIMMSite);
  siteIEN  := Piece(temp, ';', 3);
  temp := Piece(x, U, pnumImmOrderByIEN);
  OrderByIEN := Piece(temp, ';', 1);
  OrderBy := Piece(temp, ';', 2);
  documType := Piece(x, U, pnumIMMDocumType);
  overrideReason := Piece(x, U, pnumImmOverride);
  temp := Piece(x, U, pnumImmContra);
  Contra := Piece(temp, ':', 2);
  ContraIen := Piece(temp, ':', 1);
  documentType := 'Administered';
  delimitedStrTxt := x;
  SetPiece(delimitedStrTxt, u, 1, 'IMM+');
  warnDate := '';
  delimitedStr1Txt := 'COM^1^' + comment;
  if overrideReason <> '' then
    delimitedStr2Txt := 'COM^2^' + overrideReason;
  if ContraIEN <> '' then
    begin
      warnDate := Piece(x, U, pnumWarnDate);
      Contraindicated := true;
      documentType := 'Contraindication';
      delimitedStrTxt := 'ICR+' + u + contraIEN + U + U + contra + U + code  + ';' + narrative + U + warnDate;
    end
  else Contraindicated := false;
  temp := Piece(x, U, pnumImmRefused);
  RefusedText := Piece(temp, ':', 2);
  RefusedIEN := Piece(temp, ':', 1);
  if RefusedIEN <> '' then
    begin
      warnDate := Piece(x, U, pnumWarnDate);
      Refused := true;
      documentType := 'Refused';
      delimitedStrTxt := 'ICR+' + u + RefusedIEN + U + U + RefusedText + U + code + ';' + narrative + U + warnDate;
      SetPiece(delimitedStrTxt, U, 11, Piece(x, U, 11));
    end
  else Refused := false;
  if Series = '' then series := NoPCEValue;
  if Reaction ='' then reaction := NoPCEValue;
  if contraindicated or refused then exit;
  vis := Piece(x, U, pnumIMMVis);
  SetPiece(delimitedStrTxt, U, pnumProvider, AdminByIEN);
  SetPiece(delimitedStrTxt, U, 13, dosage);
  SetPiece(delimitedStrTxt, U, 14, ';;'+ routeIEN);
  SetPiece(delimitedStrTxt, U, 15, ';;'+ siteIEN);
  SetPiece(delimitedStrTxt, U, 16, ';' + lot);
  SetPiece(delimitedStrTxt, U, 20, orderByIEN);
  SetPiece(delimitedStrTxt, U, pnumIMMVis, vis);
//  delimitedStr1Txt := 'COM^1^' + comment;
end;

constructor TPCEImm.Create(data: TVimmResult);
//var
//num: integer;
begin
  inherited Create;
    Code := data.id;
    Narrative := data.name;
    Contraindicated := data.isContraindicated;
    Refused := data.isRefused;
    if data.getSeries <> '' then series := data.getSeries;

//    Series := data.series;
//    Refused := data.refuse <>'';
//    Contraindicated := data.contraIEN <> '';
//    lot := data.lot;
//    administratedBy := data.adminBy;
//    orderBy := data.orderBy;
//    route := data.route;
//    site := data.site;
//    dosage := data.dosage;
////    vis:             String;
////    visDate:         TFMDateTime;
//    remarks := data.comments;
//    documType := data.documType;
//    routeIEN := data.routeIEN;
//    siteIEN := data.siteIEN;
//    adminByIEN := data.adminByIEN;
//    orderByIEN := data.orderByIEN;
//    overrideReason  := data.overrideReason;
    delimitedStrTxt    := Data.DelimitedStr;
    delimitedStr1Txt   := Data.DelimitedStr2;
    delimitedStr2Txt  := Data.DelimitedStr3;
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
  Result := 'IMM' + Result;
  //Result := 'IMM' + Result + U + Series + U + IntToStr(Provider) + U + Reaction;
  //'IMM'^IEN^^Narrative^Series^^Reaction^Contraindicated^Refused^Lot^Route^Site^AdminBy^OrderBy^Dosage;
//  Result := 'IMM' + Result + U + Series + U + U + Reaction;
//  if Contraindicated then Result := Result + U + '1'
//  else Result := Result + U + '0';
//  //refused not implemented by PCE
//  Result := Result + U;
//  if lot <> '' then Result := Result + U + lot
//  else Result := Result + U;
//  if RouteIEN <> '' then Result := Result + U + routeIEN
//  else Result := Result + U;
//  if SiteIEN <> '' then Result := Result + U + siteIEN
//  else Result := Result + U;
//  if adminByIEN <> '' then Result := Result + U + adminByIEN
//  else Result := result + U;
//  if orderByIEN <> '' then Result := Result + U + orderByIEN
//  else Result := result + U;
//  if dosage <> '' then result := result + U + dosage
//  else result := result + U;

//  Result := Result + U + IntToStr(UNxtCommSeqNum);
  {the following two lines are not yet implemented in PCE side}
  //if Refused then Result := Result + U + '1'
  //else Result := Result + U + '0';
end;


function TPCEImm.getVimmStr: string;
begin
  if delimitedStrTxt <> '' then
    begin
//      result := delimitedStrTxt + '~' + comment;
//      if Piece(delimitedStr1Txt, U, 3) <> '@' then   result := result + '~' +  Piece(delimitedStr1Txt, U, 3);
//      if Piece(delimitedStr2Txt, U, 3) <> '@' then   SetPiece(result, '~', 24, Piece(delimitedStr2Txt, U, 3));
//      exit;
      result := delimitedStrTxt;
      if Piece(delimitedStr1Txt, '~', 3) <> NoPCEValue then SetPiece(result, '~', pnumComment, comment);
      if overrideReason <> '' then SetPiece(result, '~', pnumImmOverride, overrideReason);

    end;
end;

//procedure TPCEImm.getVimmImmResults(var resultList: TStringList);
//var
//data: TVimmResult;
//i: integer;
//imm: TPCEImm;
//begin
//  for i := 0 to FImmunizations.count-1 do
//    begin
//       imm := TPCEImm(Fimmunizations.Items[i]);
//       data := TVimmResult.Create;
//       data.name := imm.Narrative;
//       data.adminByIEN := imm.administratedBy;
//       data.routeIEN := imm.route;
//       data.siteIEN := imm.site;
//       resultList.AddObject(data.name, data);
//    end;
//end;

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
  if(Series <> NoPCEValue) and (Series <> '') then
//    Result := GetPCECodeString(TAG_IMMSERIES, Series)
    Result := getSeriesExternal(Series)
  else
    Result := '';
  Result := Result + U;
  if Refused then Result := Result + 'R'
  else if Contraindicated then Result := Result + 'C';

//  if(Reaction <> NoPCEValue) then
//    Result := Result + GetPCECodeString(TAG_IMMREACTION, Reaction);
//  Result := Result + U;
//  if(Contraindicated) then
//    Result := Result + 'X';
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
  lot      := Piece(x, U, pnumImmLot);
  administratedBy := Piece(x, U, pnumProvider);
  orderBy  := Piece(x, U, pnumImmOrderBy);
  route    := Piece(x, U, pnumImmRoute);
  site     := Piece(x, U, pnumImmSite);
  dosage   := Piece(x, U, pnumImmDosage);
  routeIEN := Piece(x, U, pnumImmRoute);
  siteIEN  := Piece(x, U, pnumIMMSite);
  AdminByIEN  := Piece(x, U, pnumProvider);
  OrderByIEN  := Piece(x, U, pnumIMMOrderByIEN);
  documType := Piece(x, U, pnumIMMDocumType);
  overrideReason := Piece(x, U, pnumImmOverride);
  delimitedStrTxt := Piece(x, u, pnumIMMdelimitedStr);
  if pos('IMM~', delimitedStrTxt)> -1 then
    delimitedStrTxt := StringReplace(delimitedStrTxt, '~', U, [rfReplaceAll, rfIgnoreCase]);
  delimitedStr1Txt := Piece(x, u, pnumIMMdelimitedStr1);
  if pos('COM~', delimitedStr1Txt) > -1 then
    delimitedStr1Txt := StringReplace(delimitedStr1Txt, '~', U, [rfReplaceAll, rfIgnoreCase]);
  delimitedStr2Txt := Piece(x, u, pnumIMMdelimitedStr2);
  if pos('COM~', delimitedStr2Txt) > -1 then
    delimitedStr2Txt := StringReplace(delimitedStr2Txt, '~', U, [rfReplaceAll, rfIgnoreCase]);
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

  Result := 'CPT' + inherited DelimitedStr + U;
  if Provider > 0 then tmpProv := IntToStr(Provider) else tmpProv := '';

  SetPiece(Result, U, pnumProcQty, IntToStr(Quantity));
  SetPiece(Result, U, pnumProvider, tmpProv);
  SetPiece(Result, U, pnumCPTMods, IntToStr(cnt) + Mods);
  if Length(Result) > 250 then SetPiece(Result, U, pnumNarrative, '');
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
  Result := Prefix + inherited DelimitedStr;
  SetPiece(Result, U, pnumPEDLevel, Level);
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

function TPCEPat.Prefix: string;
begin
  Result := 'PED';
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
  OldNarrative := TPCEDiag(Src).OldNarrative;
end;

procedure TPCEDiag.Clear;
{clear fields(properties) of class}
begin
  inherited Clear;
  Primary := False;
  //Provider := 0;
  AddProb  := False;
  OldNarrative := '';
end;

function TPCEDiag.DelimitedStr: string;
{created delimited string to pass to broker}
var
  ProviderStr: string; {jm 9/8/99}
begin
  Result := 'POV' + inherited DelimitedStr;
  if(AddProb) then
    ProviderStr := IntToStr(fProvider)
  else
    ProviderStr := '';
  SetPiece(Result, U, pnumDiagPrimary, BOOLCHAR[Primary]);
  SetPiece(Result, U, pnumProvider, ProviderStr);
  SetPiece(Result, U, pnumPOVAdd2PL, BOOLCHAR[AddProb]);
  if(not SaveComment) then
    SetPiece(Result, U, pnumComment, '');
  if Length(Result) > 250 then SetPiece(Result, U, pnumNarrative, '');
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
    Result := 'COM' + U + IntToStr(UNxtCommSeqNum) + U + Comment;
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

procedure TPCEDiag.SetFromString(const x: string);
{ sets fields to pieces passed from server:  TYP ^ Code ^ Category ^ Narrative ^ Primary ^ ^ ^ Comment }
begin
  inherited SetFromString(x);
  OldComment := Comment;
  Primary := (Piece(x, U, pnumDiagPrimary) = '1');
  //Provider := StrToInt64Def(Piece(x, U, pnumProvider),0);
  AddProb := (Piece(x, U, pnumPOVAdd2PL) = '1');
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
  FGenFindings := TList.Create;
  FStandardCodes := TList.Create;
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
  with FDiagnoses  do for i := 0 to Count - 1 do TObject(Items[i]).Free;
  with FProcedures do for i := 0 to Count - 1 do TObject(Items[i]).Free;
  with FImmunizations do for i := 0 to Count - 1 do TObject(Items[i]).Free;
  with FSkinTests do for i := 0 to Count - 1 do TObject(Items[i]).Free;
  with FPatientEds do for i := 0 to Count - 1 do TObject(Items[i]).Free;
  with FHealthFactors do for i := 0 to Count - 1 do TObject(Items[i]).Free;
  with FExams do for i := 0 to Count - 1 do TObject(Items[i]).Free;
  with FGenFindings do for i := 0 to Count - 1 do TObject(Items[i]).Free;
  with FStandardCodes do for i := 0 to Count - 1 do TObject(Items[i]).Free;
  FVisitType.Free;
  FDiagnoses.Free;
  FProcedures.Free;
  FImmunizations.Free;
  FSkinTests.free;
  FPatientEds.Free;
  FHealthFactors.Free;
  FExams.Free;
  FProviders.Free;
  FGenFindings.Free;
  FStandardCodes.Free;
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
  FVisitIEN := 0;
  FVisitIENIsPrimary := FALSE;
  FEncSvcCat   := 'A';
//  FEncInpatient := FALSE;
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
  ClearList(FGenFindings);
  ClearList(FStandardCodes);

  FVisitType.Clear;
  FProviders.Clear;
  FSCChanged   := False;
  FNoteIEN := 0;
  FNoteTitle := 0;
  FEncounterLock := False;
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

procedure TPCEData.CopyStandardCodes(Dest: TCaptionListView);
begin
  CopyPCEItems(FStandardCodes, Dest, TStandardCode);
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

procedure TPCEData.CopyGenFindings(Dest: TCaptionListView);
begin
  CopyPCEItems(FGenFindings, Dest, TGenFindings);
end;

function TPCEData.GetVisitString: string;
begin
  Result :=  IntToStr(FEncLocation) + ';' + FloatToStr(VisitDateTime) + ';' + FEncSvcCat;
end;

function TPCEData.GetCPTRequired: Boolean;
begin
  Result := (([ndDiag, ndProc] * NeededPCEData) <> []);
end;

procedure TPCEData.PCEForNote(NoteIEN: Integer); //EditObj: TPCEData);
var
  i, j, LOC: Integer;
  TmpCat, TmpVStr: string;
  x: string;
  //DoCopy,
  IsVisit: Boolean;
  PCEList, VisitTypeList: TStringList;
  ADiagnosis:    TPCEDiag;
  AProcedure:    TPCEProc;
  AImmunization: TPCEImm;
  ASkinTest:     TPCESkin;
  APatientEd:    TPCEPat;
  AHealthFactor: TPCEHealth;
  AExam:         TPCEExams;
  AGenFind:      TGenFindings;
  AStandardCode: TStandardCode;
  FileVStr: string;
  FileIEN: integer;
  GetCat, DoRestore: boolean;
  FRestDate, HDREncDate, NoteDateTime: TFMDateTime;
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

  function replaceComment(x: string): String;
  var
  int: integer;
  hasComment, hasOverride, hasReading: boolean;
  isSkin: boolean;
  begin
    hasComment := false;
    hasOverride := false;
    hasReading := false;
    isSkin := false;
    result := x;
    if StrToIntDef(Piece(x, U, pnumComment), 0) > 0 then hasComment := true;
    if (piece(x, U, 1) = 'SK') and (piece(x, U, 5) <> '') then isSkin := true;
    if isSKin and (StrToIntDef(Piece(x, U, 14), 0) > 0) then hasReading := true;
    if (not isSkin) and (StrToIntDef(Piece(x, U, pnumImmOverride), 0) > 0) then hasOverride := true;
    if (not hasComment) and (not hasOverride) and (not hasReading) then exit;

    //check for comment replace string if a comment exists
    if hasComment then
      begin
         int := i + 1;
         If (((int) <= (PCEList.Count - 1)) and (Copy(PCEList[int], 1, 3) = 'COM')) then
         begin
          SetPiece(result, U, pnumComment, Piece(PCEList[int],U,3));
//          if isSkin and (StrToIntDef(Piece(x, U, 14), 0) > 0) then SetPiece(result, U, 14, Piece (PCEList[int],U,3))
//          else SetPiece(result, U, pnumComment, Piece(PCEList[int],U,3));
         end;
      end;
    if (not hasOverride) and (not hasReading) then exit;
    if hasComment then int := i + 2
    else int := i + 1;
    If (((int) <= (PCEList.Count - 1)) and (Copy(PCEList[int], 1, 3) = 'COM')) then
      begin
        if hasOverride then SetPiece(result, U, pnumImmOverride, Piece(PCEList[int],U,3))
        else if hasReading then SetPiece(result, U, 14, Piece(PCEList[int],U,3))

      end;
  end;

  procedure EnsureNoteDateTime;
  begin
    if FVisitIENIsPrimary and (NoteIEN > 0) then
    begin
      if NoteDateTime = 0 then
        NoteDateTime := GetNoteDate(NoteIEN);
      if Inpatient then
        FEncDateTime := NoteDateTime;
      FNoteDateTime := NoteDateTime;
    end;
  end;

begin
  NoteDateTime := 0;
  HDREncDate := 0;
  if(NoteIEN < 1) then
    TmpVStr := Encounter.VisitStr
  else
  begin
    TmpVStr := VisitStrForNote(NoteIEN);
    if(FEncSvcCat = #0) then
      GetCat :=TRUE
    else
    if(GetVisitString = EMPTY_VISIT_STRING) then
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

(*
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
          FNoteIEN := NOTEIEN;
        end;
//        exit;
      end;
    end;
  end;
*)

  TmpCat := Piece(TmpVStr, ';', 3);
  if(TmpCat <> '') then
    FEncSvcCat := TmpCat[1]
  else
    FEncSvcCat := #0;
  FEncLocation := StrToIntDef(Piece(TmpVStr,';',1),0);
  FEncDateTime := StrToFloatDef(Piece(TmpVStr, ';', 2),0);
  if (FEncDateTime = 0) and (NoteIEN > 0) then
    FEncDateTime := GetNoteDate(NoteIEN);

  if(IsSecondaryVisit and (FEncLocation > 0)) then
  begin
    FileIEN := USE_CURRENT_VISITSTR;
    LOC := GetNoteLocation(NoteIEN);
    FileVStr := IntToStr(LOC) + ';' + FloatToStr(GetNoteDate(NoteIEN)) + ';' +
                GetLocSecondaryVisitCode(LOC);
//              IntToStr(FEncLocation) + ';' + FloatToStr(FNoteDateTime) + ';' + GetLocSecondaryVisitCode(FEncLocation);
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
//        FEncInpatient := Piece(x, U, 2) = '1';
        FVisitIEN := StrToIntDef(Piece(x, U, 7),0);
        FVisitIENIsPrimary := (Piece(x, U, 8) = '1');
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
          HDREncDate    := FEncDateTime;
          FEncSvcCat    := CharAt(Piece(Piece(x, U, 4), ';', 3), 1);
        end;
        //FEncProvider  := StrToInt64Def(Piece(x, U, 5), 0);
        ListVisitTypeByLoc(VisitTypeList, FEncLocation, FEncDateTime);
        //set the values needed fot the RPCs
        SetRPCEncLocation(FEncLocation);
//        SetRPCEncDateTime(FEncDateTime);
        EnsureNoteDateTime;
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
        begin
          FEncDateTime := MakeFMDateTime(Piece(x, U, 3));
        end;
        EnsureNoteDateTime;
      end;
      if Copy(x, 1, 7) = 'VST^HL^' then FEncLocation := StrToIntDef(Piece(x, U, 3), 0);
      if Copy(x, 1, 7) = 'VST^VC^' then
      begin
        if DoRestore then
          FEncSvcCat := 'H'
        else
          FEncSvcCat := CharAt(x, 8);
      end;
      if (FEncSvcCat = 'D') and (HDREncDate > 0) and (FEncDateTime <> HDREncDate) then
      begin
        FEncDateTime := HDREncDate;
        EnsureNoteDateTime;
      end;
//      if Copy(x, 1, 7) = 'VST^PS^' then FEncInpatient := CharAt(x, 8) = '1';
      {6/10/99}//if Copy(x, 1, 4) = 'PRV^'    then FEncProvider := StrToInt64Def(Piece(x, U, 2), 0);
      if Copy(x, 1, 7) = 'VST^SC^'  then FSCRelated := SCCValue(x);
      if Copy(x, 1, 7) = 'VST^AO^'  then FAORelated := SCCValue(x);
      if Copy(x, 1, 7) = 'VST^IR^'  then FIRRelated := SCCValue(x);
      if Copy(x, 1, 7) = 'VST^EC^'  then FECRelated := SCCValue(x);
      if Copy(x, 1, 8) = 'VST^MST^' then FMSTRelated := SCCValue(x);
//      if HNCOK and (Copy(x, 1, 8) = 'VST^HNC^') then
      if Copy(x, 1, 8) = 'VST^HNC^' then FHNCRelated := SCCValue(x);
      if Copy(x, 1, 7) = 'VST^CV^' then FCVRelated := SCCValue(x);
      if Copy(x, 1, 9) = 'VST^SHAD^' then FSHADRelated := SCCValue(x);
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
//        x := AppendComment(x);
        x := replaceComment(x);
        AImmunization := TPCEImm.Create(x);
//        AImmunization := TPCEImm.Create;
//        AImmunization.SetFromString(x);
        FImmunizations.Add(AImmunization);
      end;
      if (Copy(x, 1, 2) = 'SK') and (CharAt(x, 3) <> '-') then
      {Skin Tests-------------------------------------------------------------------}
      begin
        x := replaceComment(x);
        ASkinTest := TPCESkin.Create(x);
        FSkinTests.Add(ASkinTest);
//        x := AppendComment(x);
//        ASkinTest := TPCESkin.Create;
//        ASkinTest.SetFromString(x);
//        FSkinTests.Add(ASkinTest);
      end;
      if (Copy(x, 1, 3) = 'PED') and (CharAt(x, 4) <> '-') then
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
      if (Copy(x, 1, 3) = 'XAM') and (CharAt(x, 4) <> '-') then
      {Exams ------------------------------------------------------------------------}
      begin
        x := AppendComment(x);
        AExam := TPCEExams.Create;
        AExam.SetFromString(x);
        FExams.Add(AExam);
      end;
      {General Findings--------------------------------------------------------------}
      if (copy(x, 1, 5) = 'GFIND') and (CharAt(x, 6) <> '-') then
        begin
          AGenFind := TGenFindings.create;
          AGenFind.SetFromString(x);
          FGenFindings.add(AGenFind);
        end;
      {Standard Codes----------------------------------------------------------------}
      if (copy(x, 1, 2) = 'SC') and (CharAt(x, 3) <> '-') then
      begin
        x := AppendComment(x);
        AStandardCode := TStandardCode.Create;
        AStandardCode.SetFromString(x);
        FStandardCodes.add(AStandardCode);
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
function TPCEData.Save: boolean;
{ pass the changes to the encounter to DATA2PCE,
  Pieces: Subscript^Code^Qualifier^Category^Narrative^Delete }
var
  i: Integer;
  x, AVisitStr, EncName, temp, temp1, Temp2, temp3: string;
  PCEList: TStringList;
  FileCat: char;
  FileDate: TFMDateTime;
  FileNoteIEN: integer;
  isLock: boolean;
  Visit: string;
  dstring1,dstring2: pchar; //used to separate former DelimitedStr variable
                             // into two strings, the second being for the comment.

  procedure CleanUp(List: TList; cls: TPCEItemClass);
  var
    DoDelete: boolean;
    idx: integer;

  begin
    with List do
    begin
      for idx := Count - 1 downto 0 do
      begin
        DoDelete := not (TObject(Items[idx]) is cls);
        if not DoDelete then with TPCEItem(Items[idx]) do
        begin
          if FDelete then
            DoDelete := True
          else
          begin
            FSend := False;
            if cls = TPCEDiag then
              TPCEDiag(Items[idx]).AddProb := False;
          end;
        end;
        if DoDelete then
        begin
          TObject(Items[idx]).Free;
          Delete(idx);
        end;
      end;
    end;
  end;

begin
  PCEList := TStringList.Create;
  UNxtCommSeqNum := 1;
  try
    with PCEList do
    begin
      Visit := FVisitIEN.ToString;
      if(IsSecondaryVisit) then
      begin
        FileCat := GetLocSecondaryVisitCode(FEncLocation);
        FileDate := FNoteDateTime;
        FileNoteIEN := NoteIEN;
        if((NoteIEN > 0) and ((FParent = '') or (FParent = '0'))) then
          FParent := GetVisitIEN(NoteIEN);
        if FVisitIENIsPrimary then
          Visit := '';
      end
      else
      begin
        FileCat := FEncSvcCat;
        FileDate := FEncDateTime;
        if FileCat = 'D' then
        begin
          FileNoteIEN := NoteIEN;
        end
        else
        begin
          FileNoteIEN := 0;
        end;
      end;
      AVisitStr :=  IntToStr(FEncLocation) + ';' + FloatToStr(FileDate) + ';' + FileCat;
      Add('HDR^' + BOOLCHAR[GetInpatient] + U + U + AVisitStr + U + Visit);
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
        if FSCRelated   <> SCC_NA then Add('VST^SC^'  + IntToStr(FSCRelated));
        if FAORelated   <> SCC_NA then Add('VST^AO^'  + IntToStr(FAORelated));
        if FIRRelated   <> SCC_NA then Add('VST^IR^'  + IntToStr(FIRRelated));
        if FECRelated   <> SCC_NA then Add('VST^EC^'  + IntToStr(FECRelated));
        if FMSTRelated  <> SCC_NA then Add('VST^MST^' + IntToStr(FMSTRelated));
        if FHNCRelated  <> SCC_NA then Add('VST^HNC^' + IntToStr(FHNCRelated));
        if FCVRelated   <> SCC_NA then Add('VST^CV^'  + IntToStr(FCVRelated));
        if FSHADRelated <> SCC_NA then Add('VST^SHD^' + IntToStr(FSHADRelated));
        if IsLejeuneActive then
          if FCLRelated <> SCC_NA then Add('VST^CL^'+ IntToStr(FCLRelated));
      end;
      with FDiagnoses do for i := 0 to Count - 1 do
        if TObject(Items[i]) is TPCEDiag then with TPCEDiag(Items[i]) do
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
      with FProcedures do for i := 0 to Count - 1 do
        if TObject(Items[i]) is TPCEProc then with TPCEProc(Items[i]) do
          if FSend then
          begin
            PCEList.Add(DelimitedStr);
            PCEList.Add(DelimitedStr2);
          end;
      with FImmunizations do for i := 0 to Count - 1 do
        if TObject(Items[i]) is TPCEImm then with TPCEImm(Items[i]) do
          if FSend then
          begin
            inc(UNxtCommSeqNum);
            temp := DelimitedStr;
            temp1 := DelimitedStrTxt;
            if (Piece(temp1, u, 1) =  'ICR+') and (Piece(temp, U, 1) = 'IMM-') then setPiece(temp1, U, 1, 'ICR-')
            else if (temp1 <> '') and (Piece(temp, U, 1) = 'IMM-') then setPiece(temp1, U, 1, 'IMM-')
            else if (temp1 = '') and (temp <> '') then temp1 := temp;
            if Piece(temp1, U, 29) <> '' then
              begin
                SetPiece(temp1, U, 29, IntToStr(UNxtCommSeqNum));
              end
            else
              begin
                SetPiece(temp1, U, 10, IntToStr(UNxtCommSeqNum));
                SetPiece(temp1, U, 24, IntToStr(UNxtCommSeqNum + 1));
              end;
            PCELIST.Add(temp1);
            temp2 := DelimitedStr1Txt;
            SetPiece(temp2, U, 2, IntToStr(UNxtCommSeqNum));
            PCELIST.Add(temp2);
            temp3 := DelimitedStr2Txt;
            inc(UNxtCommSeqNum);
            if Piece(temp1, U, 29) <> '' then
              begin
                SetPiece(temp3, U, 2, IntToStr(UNxtCommSeqNum));
                PCELIST.Add(temp3);
              end;
            if Piece(temp1, U, 24) <> '' then
              begin
                SetPiece(temp3, U, 2, IntToStr(UNxtCommSeqNum));
                PCELIST.Add(temp3);
              end;
          end;
      with FSkinTests do for i := 0 to Count - 1 do
        if TObject(Items[i]) is TPCESkin then with TPCESkin(Items[i]) do
          if FSend then
          begin
            inc(UNxtCommSeqNum);
            temp := DelimitedStr;
            temp1 := DelimitedStrTxt;
            if (temp1 <> '') and (Piece(temp, U, 1) = 'SK-') then setPiece(temp1, U, 1, 'SK-');
            if (temp1 = '') and (temp <> '') then temp1 := temp;
            if Reading <> '' then SetPiece(temp1, U, 14, IntToStr(UNxtCommSeqNum))
            else SetPiece(temp1, U, 10, IntToStr(UNxtCommSeqNum));
            PCELIST.Add(temp1);
            temp2 := DelimitedStr1Txt;
            SetPiece(temp2, U, 2, IntToStr(UNxtCommSeqNum));
            PCELIST.Add(temp2);
  //          PCEList.Add(DelimitedStr);
  //          PCEList.Add(DelimitedStr2);
          end;
      with FPatientEds do for i := 0 to Count - 1 do
        if TObject(Items[i]) is TPCEPat then with TPCEPat(Items[i]) do
          if FSend then
          begin
            PCEList.Add(DelimitedStr);
            PCEList.Add(DelimitedStr2);
          end;
      with FHealthFactors do for i := 0 to Count - 1 do
        if TObject(Items[i]) is TPCEHealth then with TPCEHealth(Items[i]) do
          if FSend then
          begin
            PCEList.Add(DelimitedStr);
            PCEList.Add(DelimitedStr2);
          end;
      with FExams do for i := 0 to Count - 1 do
        if TObject(Items[i]) is TPCEExams then with TPCEExams(Items[i]) do
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
      with FStandardCodes do for i := 0 to Count - 1 do
        if TObject(Items[i]) is TStandardCode then with TStandardCode(Items[i]) do
          if FSend then
          begin
            PCEList.Add(DelimitedStr);
            PCEList.Add(DelimitedStr2);
          end;
      // call DATA2PCE (in background)
      result := SavePCEData(PCEList, FileNoteIEN, FEncLocation, isLock);
      if not result then
        begin
           FEncounterLock := isLock;
           exit;
        end;
      FEncounterLock := false;
      // turn off 'Send' flags and remove items that were deleted
      CleanUp(FDiagnoses, TPCEDiag);
      CleanUp(FProcedures, TPCEProc);
      CleanUp(FImmunizations, TPCEImm);
      CleanUp(FSkinTests, TPCESkin);
      CleanUp(FPatientEds, TPCEPat);
      CleanUp(FHealthFactors, TPCEHealth);
      CleanUp(FExams, TPCEExams);
      CleanUp(FStandardCodes, TStandardCode);

      for i := FProviders.Count - 1 downto 0 do
      begin
        if(FProviders.ProviderData[i].Delete) then
          FProviders.Delete(i);
      end;

      if FVisitType.FDelete then FVisitType.Clear else FVisitType.FSend := False;
    end; {with PCEList}
    //if (FProcedures.Count > 0) or (FVisitType.Code <> '') then FCPTRequired := False;

    // update the Changes object
    EncName := FormatFMDateTime('mmm dd,yy hh:nn', FileDate);
    x := StrVisitType;
    if Length(x) > 0 then Changes.Add(CH_PCE, 'V' + AVisitStr, x, EncName, CH_SIGN_NA);
    x := StrProcedures;
    if Length(x) > 0 then Changes.Add(CH_PCE, 'P' + AVisitStr, x, EncName, CH_SIGN_NA);
    x := StrDiagnoses;
    if Length(x) > 0 then Changes.Add(CH_PCE, 'D' + AVisitStr, x, EncName, CH_SIGN_NA,
       waNone, Parent, User.DUZ, 0, '', False, False, ProblemAdded);
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
    x := StrStandardCodes;
    if Length(x) > 0 then Changes.Add(CH_PCE, 'C' + AVisitStr, x, EncName, CH_SIGN_NA);

  finally
    PCEList.Free;
  end;
end;

function TPCEData.MatchIMMItems(AList: TList; AnItem: TPCEIMM): Integer;
var
  i: integer;
begin
  Result := -1;
  for I := 0 to AList.count - 1 do
    if TObject(Alist.items[i]) is TPCEIMM then
    begin
      if AnItem.delimitedStrTxt <> TPCEIMM(Alist.items[i]).delimitedStrTxt then
        continue;
      if AnItem.delimitedStr1Txt <>  TPCEIMM(Alist.items[i]).delimitedStr1Txt then
        continue;
      if AnItem.delimitedStr2Txt <>  TPCEIMM(Alist.items[i]).delimitedStr2Txt then
        continue;
      result := i;
      exit;
    end;
end;

function TPCEData.MatchItem(AList: TList; AnItem: TPCEItem): Integer;
{ return index in AList of matching item }
var
  i: Integer;
begin
  Result := -1;
  with AList do for i := 0 to Count - 1 do
    if TObject(Items[i]) is TPCEItem then with TPCEItem(Items[i]) do
      if Match(AnItem) and MatchProvider(AnItem)then
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
  with AList do
    for i := 0 to Count - 1 do
      if TObject(Items[i]) is TPCEItem then with TPCEItem(Items[i]) do
        if MatchPOV(AnItem) and MatchProvider(AnItem)then
        begin
          Result := i;
          break;
        end;
end;

function TPCEData.MatchSkinTestItems(AList: TList; AnItem: TPCESkin): Integer;
var
  i: integer;
begin
  Result := -1;
  for I := 0 to AList.count - 1 do
    if TObject(Alist.items[i]) is TPCESkin then
    begin
      if AnItem.delimitedStrTxt <> TPCESkin(Alist.items[i]).delimitedStrTxt then
        continue;
      if AnItem.delimitedStr1Txt <>  TPCESkin(Alist.items[i]).delimitedStr1Txt then
        continue;
      result := i;
      exit;
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
    if not (TObject(Items[i]) is TPCEItem) then
      continue;
    PreItem := TPCEItem(Items[i]);
    MatchFound := False;
    with PostList do for j := 0 to Count - 1 do
    begin
      if not (Objects[j] is TPCEItem) then
        continue;
      PostItem := TPCEItem(Objects[j]);
      //fix to not mark the ICD-10 diagnosis for deletion when selected to add to the Problem List.
      if (Piece(PostItem.DelimitedStr, '^', 1)='POV+') and (Piece(PostItem.DelimitedStr, '^', 7)='1') and
      (PreItem.Code = PostItem.Code) and (Pos('SNOMED', Piece(PostItem.DelimitedStr, '^', 4)) > 0) then
          MatchFound := True
      else if (PreItem.Match(PostItem) and (PreItem.MatchProvider(PostItem))) then MatchFound := True;
      if MatchFound then
        break;
    end;
    if not MatchFound then
    begin
      PreItem.FDelete := True;
      PreItem.FSend   := True;
    end;
  end;
end;

procedure TPCEData.markProcedureCodeForDeletion(deleteCode: string);
var
item: TPCEItem;
i: integer;
begin
  for i := 0 to FProcedures.Count - 1 do
    begin
      if not (TObject(FProcedures.Items[i]) is TPCEItem) then
        continue;
      Item := TPCEItem(FProcedures.Items[i]);
      if item.Code = deleteCode then
        begin
          item.FDelete := true;
          item.FSend := true;
          exit;
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
    if not (Src.Objects[i] is TPCEDiag) then
      continue;
    SrcDiagnosis := TPCEDiag(Src.Objects[i]);
    MatchIndex := MatchPOVItems(FDiagnoses, SrcDiagnosis);
    if (MatchIndex > -1) and (TObject(FDiagnoses.Items[MatchIndex]) is TPCEDiag) then    //found in fdiagnoses
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
      if not (TObject(FDiagnoses[i]) is TPCEDiag) then
        continue;
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
  SrcProcedure, CurProcedure: TPCEProc;
begin
  if FromForm then MarkDeletions(FProcedures, Src);
  for i := 0 to Src.Count - 1 do
  begin
    if not (Src.Objects[i] is TPCEProc) then
      continue;
    SrcProcedure := TPCEProc(Src.Objects[i]);
    MatchIndex := MatchItem(FProcedures, SrcProcedure);
    if (MatchIndex > -1) and (TObject(FProcedures.Items[MatchIndex]) is TPCEProc) then
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
//        OldProcedure := TPCEProc.Create;
//        OldProcedure.Assign(CurProcedure);
//        OldProcedure.FDelete := TRUE;
//        OldProcedure.FSend := TRUE;
//        FProcedures.Add(OldProcedure);
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



procedure TPCEData.SetImmunizations(Src: TStrings; FromForm: boolean = TRUE; vimmData: TVimmResult = nil);
{ load Immunizations for this encounter into TPCEImm records, assumes all Immunizations for the
  encounter will be listed in Src and marks those that are not in Src for deletion }
var
  i, MatchIndex: Integer;
  SrcImmunization, CurImmunization: TPCEImm;
begin
  if FromForm then MarkDeletions(FImmunizations, Src);
  for i := 0 to Src.Count - 1 do
  begin
    if assigned(vimmData) then
      SrcImmunization := TPCEImm.Create(vimmData)
    else if not (Src.Objects[i] is TPCEImm) then
      continue
    else
      SrcImmunization := TPCEImm(Src.Objects[i]);
    try
    MatchIndex := MatchIMMItems(FImmunizations, SrcImmunization);
    if (MatchIndex > -1) and (TObject(FImmunizations.Items[MatchIndex]) is TPCEImm) then
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
        (CurImmunization.Comment <> SrcImmunization.Comment) or
        (CurImmunization.route <> SrcImmunization.route) or
        (CurImmunization.site <> SrcImmunization.site) or
        (CurImmunization.lot <> SrcImmunization.lot) or
        (CurImmunization.administratedBy <> SrcImmunization.administratedBy) or
        (CurImmunization.overrideReason <> SrcImmunization.overrideReason) or
        (CurImmunization.orderBy <> SrcImmunization.orderBy) or
        (SrcImmunization.delimitedStrTxt <> CurImmunization.delimitedStrTxt) or
        (SrcImmunization.delimitedStr1Txt <> CurImmunization.delimitedStr1Txt) or
        (SrcImmunization.delimitedStr2Txt <> CurImmunization.delimitedStr2Txt) or
        ((FromForm) and ((SrcImmunization.delimitedStrTxt <> CurImmunization.delimitedStrTxt) or
        (SrcImmunization.delimitedStr1Txt <> CurImmunization.delimitedStr1Txt) or
        (SrcImmunization.delimitedStr2Txt <> CurImmunization.delimitedStr2Txt)))then
      begin
        CurImmunization.Series          := SrcImmunization.Series;
        CurImmunization.Reaction        := SrcImmunization.Reaction;
        CurImmunization.Refused         := SrcImmunization.Refused;
        CurImmunization.Contraindicated := SrcImmunization.Contraindicated;
        CurImmunization.Comment         := SrcImmunization.Comment;
        CurImmunization.lot             := SrcImmunization.lot;
        CurImmunization.administratedBy := SrcImmunization.administratedBy;
        CurImmunization.orderBy         := SrcImmunization.orderBy;
        CurImmunization.route           := SrcImmunization.route;
        CurImmunization.site            := SrcImmunization.site;
        CurImmunization.dosage          := SrcImmunization.dosage;
        CurImmunization.adminByIEN      := SrcImmunization.adminByIEN;
        CurImmunization.orderByIEN      := SrcImmunization.orderByIEN;
        CurImmunization.routeIEN        := SrcImmunization.routeIEN;
        CurImmunization.siteIEN         := SrcImmunization.siteIEN;
        CurImmunization.documType       := SrcImmunization.documType;
        CurImmunization.overrideReason  := SrcImmunization.overrideReason;
        CurImmunization.delimitedStrTxt := SrcImmunization.delimitedStrTxt;
        CurImmunization.delimitedStr1Txt := SrcImmunization.delimitedStr1Txt;
        CurImmunization.delimitedStr2Txt := SrcImmunization.delimitedStr2Txt;
        if SrcImmunization.orderByIEN = '' then
          CurImmunization.orderByPolicy := true
        else CurImmunization.orderByPolicy := false;

//        if not FromForm then
//          begin
//            CurImmunization.delimitedStrTxt := StringReplace(SrcImmunization.delimitedStrTxt, '~', U, [rfReplaceAll, rfIgnoreCase]);
//            CurImmunization.delimitedStr1Txt := StringReplace(SrcImmunization.delimitedStr1Txt, '~', U, [rfReplaceAll, rfIgnoreCase]);
//            CurImmunization.delimitedStr2Txt := StringReplace(SrcImmunization.delimitedStr2Txt, '~', U, [rfReplaceAll, rfIgnoreCase]);
//          end
//        else
//          begin
//            CurImmunization.delimitedStrTxt := SrcImmunization.delimitedStrTxt;
//            CurImmunization.delimitedStr1Txt := SrcImmunization.delimitedStr1Txt;
//            CurImmunization.delimitedStr2Txt := SrcImmunization.delimitedStr2Txt;
//          end;

        CurImmunization.FSend := True;
      end;
    end else
    begin
        if not FromForm then
          begin
            SrcImmunization.delimitedStrTxt := StringReplace(SrcImmunization.delimitedStrTxt, '~', U, [rfReplaceAll, rfIgnoreCase]);
            SrcImmunization.delimitedStr1Txt := StringReplace(SrcImmunization.delimitedStr1Txt, '~', U, [rfReplaceAll, rfIgnoreCase]);
            SrcImmunization.delimitedStr2Txt := StringReplace(SrcImmunization.delimitedStr2Txt, '~', U, [rfReplaceAll, rfIgnoreCase]);
          end;
      CurImmunization := TPCEImm.Create;
      CurImmunization.Assign(SrcImmunization);
      CurImmunization.FSend := True;
      FImmunizations.Add(CurImmunization);
    end; {if MatchIndex}
//  end; {for}
    finally
//      FreeAndNil(SrcImmunization);
    end;
  end; {for}
end;

procedure TPCEData.SetSkinTests(Src: TStrings; FromForm: boolean = TRUE; vimmData: TVimmResult = nil);
{ load SkinTests for this encounter into TPCESkin records, assumes all SkinTests for the
  encounter will be listed in Src and marks those that are not in Src for deletion }
var
  i, MatchIndex: Integer;
  SrcSkinTest, CurSkinTest: TPCESkin;
begin
  if FromForm then MarkDeletions(FSKinTests, Src);
  for i := 0 to Src.Count - 1 do
  begin
    if assigned(vimmData) then
      SrcSkinTest := TPCESkin.Create(vimmData)
    else if not (Src.Objects[i] is TPCESkin) then
      continue
    else
      SrcSkinTest := TPCESkin(Src.Objects[i]);
    MatchIndex := MatchSkinTestItems(FSKinTests, SrcSkinTest);
    if (MatchIndex > -1) and (TObject(FSkinTests.Items[MatchIndex]) is TPCESKin) then
    begin
      CurSkinTest := TPCESKin(FSkinTests.Items[MatchIndex]);
      if CurSkinTest.Results = '' then CurSkinTest.Results := NoPCEValue;
      if SrcSkinTest.Results = '' then SrcSkinTest.Results := NoPCEValue;

      if(SrcSkinTest.Results <> CurSkinTest.Results) or
        (SrcSkinTest.Reading <> CurSkinTest.Reading) or
        (CurSkinTest.Comment <> SrcSkinTest.Comment) or
        (SrcSkinTest.administratedBy <> CurSkinTest.administratedBy) or
        (SrcSkinTest.orderBy <> CurSkinTest.orderBy) or
        (SrcSkinTest.site <> CurSkinTest.site) or
        ((FromForm) and ((SrcSkinTest.delimitedStrTxt <> CurSkinTest.delimitedStrTxt) or
        (SrcSkinTest.delimitedStr1Txt <> CurSkinTest.delimitedStr1Txt)))then
      begin

        CurSkinTest.Results := SrcSkinTest.Results;
        CurSkinTest.Reading := SrcSkinTest.Reading;
        CurSkinTest.administratedBy := SrcSkinTest.administratedBy;
        CurSkinTest.adminByIEN := SrcSkinTest.adminByIEN;
        CurSkinTest.DTRead := SrcSkinTEst.DTRead;
//        CurSkinTest.orderBy := SrcSkinTEst.orderBy;
//        CurSkinTEst.orderByIEN := CurSkinTEst.orderByIEN;

        CurSkinTest.Comment := SrcSkinTest.Comment;
        if not FromForm then
          begin
//            StringReplace(Data.DelimitedStr(num), U, '~',
//        [rfReplaceAll, rfIgnoreCase]));
        CurSkinTest.delimitedStrTxt := StringReplace(SrcSkinTest.delimitedStrTxt, '~', U, [rfReplaceAll, rfIgnoreCase]);
        CurSkinTest.delimitedStr1Txt := StringReplace(SrcSkinTest.delimitedStr1Txt, '~', U, [rfReplaceAll, rfIgnoreCase]);
//        CurSkinTest.delimitedStr2Txt := StringReplace(SrcSkinTest.delimitedStr2Txt, '~', U, [rfReplaceAll, rfIgnoreCase]);
          end
        else
          begin
            CurSkinTest.delimitedStrTxt := SrcSkinTest.delimitedStrTxt;
            CurSkinTest.delimitedStr1Txt := SrcSkinTest.delimitedStr1Txt;
//            CurSkinTest.delimitedStr2Txt := SrcSkinTest.delimitedStr2Txt;
          end;
        CurSkinTest.FSend := True;
      end;
    end else
    begin
        if not FromForm then
          begin
            SrcSkinTest.delimitedStrTxt := StringReplace(SrcSkinTest.delimitedStrTxt, '~', U, [rfReplaceAll, rfIgnoreCase]);
            SrcSkinTest.delimitedStr1Txt := StringReplace(SrcSkinTest.delimitedStr1Txt, '~', U, [rfReplaceAll, rfIgnoreCase]);
          end;
      CurSKinTest := TPCESkin.Create;
      CurSkinTest.Assign(SrcSkinTest);
      CurSkinTest.FSend := True;
      FSkinTests.Add(CurSkinTest);
    end; {if MatchIndex}
  end; {for}
end;

procedure TPCEData.SetStandardCodes(Src: TStrings; FromForm: boolean = TRUE);
var
  i, MatchIndex: Integer;
  SrcSCFind, CurSCFind: TStandardCode;
begin
  //set for general findings from Reminder Dialog
  if FromForm then MarkDeletions(FStandardCodes, Src);
  for i := 0 to Src.Count - 1 do
  begin
    if not (Src.Objects[i] is TStandardCode) then
      continue;
    SrcSCFind := TStandardCode(Src.Objects[i]);
    MatchIndex := MatchItem(FStandardCodes, SrcSCFind);
    if (MatchIndex < 0) or (not (TObject(FStandardCodes.Items[MatchIndex]) is TStandardCode)) then
    begin
      CurSCFind := TStandardCode.Create;
      CurSCFind.Assign(SrcSCFind);
      CurSCFind.FSend := True;
      FStandardCodes.Add(CurSCFind);
    end
    else
    begin
      CurSCFind := TStandardCode(FStandardCodes.Items[MatchIndex]);
      if(SrcSCFind.UCUMCode <> CurSCFind.UCUMCode) or
        (SrcSCFind.Magnitude <> CurSCFind.Magnitude) or
        (SrcSCFind.Comment <> CurSCFind.Comment) or
        (SrcSCFind.Add2PL <> CurSCFind.Add2PL) then
      begin
        CurSCFind.UCUMCode := SrcSCFind.UCUMCode;
        CurSCFind.Magnitude := SrcSCFind.Magnitude;
        CurSCFind.Comment := SrcSCFind.Comment;
        CurSCFind.Add2PL := SrcSCFind.Add2PL;
        CurSCFind.FSend := True;
      end;
    end;
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
    if not (Src.Objects[i] is TPCEPat) then
      continue;
    SrcPatientEd := TPCEPat(Src.Objects[i]);
    MatchIndex := MatchItem(FPatientEds, SrcPatientEd);
    if (MatchIndex > -1) and (TObject(FPatientEds.Items[MatchIndex]) is TPCEPat) then
    begin
      CurPatientEd := TPCEPat(FPatientEds.Items[MatchIndex]);

      if CurPatientEd.level = '' then CurPatientEd.level := NoPCEValue;
      if SrcPatientEd.level = '' then SrcPatientEd.level := NoPCEValue;
      if(SrcPatientEd.Level <> CurPatientEd.Level) or
        (SrcPatientEd.UCUMCode <> CurPatientEd.UCUMCode) or
        (SrcPatientEd.Magnitude <> CurPatientEd.Magnitude) or
        (SrcPatientEd.Comment <> CurPatientEd.Comment) then
      begin
        CurPatientEd.Level  := SrcPatientEd.Level;
        CurPatientEd.UCUMCode := SrcPatientEd.UCUMCode;
        CurPatientEd.Magnitude := SrcPatientEd.Magnitude;
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
    if not (Src.Objects[i] is TPCEHealth) then
      continue;
    SrcHealthFactor := TPCEHealth(Src.Objects[i]);
    MatchIndex := MatchItem(FHealthFactors, SrcHealthFactor);
    if (MatchIndex > -1) and (TObject(FHealthFactors.Items[MatchIndex]) is TPCEHealth) then
    begin
      CurHealthFactor := TPCEHealth(FHealthFactors.Items[MatchIndex]);

      if CurHealthFactor.level = '' then CurHealthFactor.level := NoPCEValue;
      if SrcHealthFactor.level = '' then SrcHealthFactor.level := NoPCEValue;
      if(SrcHealthFactor.Level <> CurHealthFactor.Level) or
        (SrcHealthFactor.Magnitude <> CurHealthFactor.Magnitude) or
        (SrcHealthFactor.UCUMCode <> CurHealthFactor.UCUMCode) or
        (SrcHealthFactor.Comment <> CurHealthFactor.Comment) then
      begin
        CurHealthFactor.Level  := SrcHealthFactor.Level;
        CurHealthFactor.Magnitude  := SrcHealthFactor.Magnitude;
        CurHealthFactor.UCUMCode  := SrcHealthFactor.UCUMCode;
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
    if not (Src.Objects[i] is TPCEExams) then
      continue;
    SrcExam := TPCEExams(Src.Objects[i]);
    MatchIndex := MatchItem(FExams, SrcExam);
    if (MatchIndex > -1) and (TObject(FExams.Items[MatchIndex]) is TPCEExams) then
    begin
      CurExam := TPCEExams(FExams.Items[MatchIndex]);
      if CurExam.Results = '' then CurExam.Results := NoPCEValue;
      if SrcExam.Results = '' then SrcExam.Results := NoPCEValue;
      if(SrcExam.Results <> CurExam.Results) or
        (SrcExam.Magnitude <> CurExam.Magnitude) or
        (SrcExam.UCUMCode <> CurExam.UCUMCode) or
        (SrcExam.Comment <> CurExam.Comment) then
      begin
        CurExam.Results  := SrcExam.Results;
        CurExam.Magnitude  := SrcExam.Magnitude;
        CurExam.UCUMCode  := SrcExam.UCUMCode;
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


procedure TPCEData.SetGenFindings(Src: TStrings; FromForm: boolean);
var
  i, MatchIndex: Integer;
  SrcGFind, CurGFind: TGenFindings;
begin
  //set for general findings from Reminder Dialog
  if FromForm then MarkDeletions(FGenFindings, Src);
  for i := 0 to Src.Count - 1 do
  begin
    if not (Src.Objects[i] is TGenFindings) then
      continue;
    SrcGFind := TGenFindings(Src.Objects[i]);
    MatchIndex := MatchItem(FGenFindings, SrcGFind);
    if MatchIndex = -1 then
    begin
      CurGFind := TGenFindings.Create;
      CurGFind.Assign(SrcGFind);
      CurGFind.FSend := True;
      FGenFindings.Add(CurGFind);
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
//    FEncInpatient := Encounter.Inpatient;

  end else
  begin
    FEncDateTime  := 0;
    FEncLocation  := 0;
    FStandAlone := FALSE;
    FStandAloneLoaded := FALSE;
    FProviders.PrimaryIdx := -1;
    FEncSvcCat    := 'A';
//    FEncInpatient := False;
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
  with FDiagnoses do for i := 0 to Count - 1 do
    if TObject(Items[i]) is TPCEDiag then with TPCEDiag(Items[i]) do
      if not FDelete then
        Result := Result + GetPCEDataText(pdcDiag, Code, Category, Narrative, Primary) + CRLF;
  Result := AddTitle(pdcDiag, Result);
end;

function TPCEData.StrProcedures: string;
{ returns the list of procedures for this encounter as a single comma delimited string }
var
  i: Integer;
begin
  Result := '';
  with FProcedures do for i := 0 to Count - 1 do
    if TObject(Items[i]) is TPCEProc then with TPCEProc(Items[i]) do
      if not FDelete then
        Result := Result + GetPCEDataText(pdcProc, Code, Category, Narrative, FALSE, Quantity) +
                         ModText + CRLF;
  Result := AddTitle(pdcProc, Result);
end;

function TPCEData.StrImmunizations: string;
{ returns the list of Immunizations for this encounter as a single comma delimited string }
var
  i: Integer;
begin
  Result := '';
  with FImmunizations do for i := 0 to Count - 1 do
    if TObject(Items[i]) is TPCEImm then with TPCEImm(Items[i]) do
      if not FDelete then
        Result := Result + GetPCEDataText(pdcImm, Code, Category, Narrative) +
          GetImmContraText(Contraindicated, Refused) + CRLF;
  Result := AddTitle(pdcImm, Result);
end;

function TPCEData.StrSkinTests: string;
{ returns the list of Immunizations for this encounter as a single comma delimited string }
var
  i: Integer;
begin
  Result := '';
  with FSkinTests do for i := 0 to Count - 1 do
    if TObject(Items[i]) is TPCESkin then with TPCESkin(Items[i]) do
      if not FDelete then
        Result := Result + GetPCEDataText(pdcSkin, Code, Category, Narrative) + CRLF;
  Result := AddTitle(pdcSkin, Result);
end;

function TPCEData.StrStandardCodes: string;
var
  i: Integer;
begin
  Result := '';
  with FStandardCodes do for i := 0 to Count - 1 do
    if TObject(Items[i]) is TStandardCode then with TStandardCode(Items[i]) do
      if not FDelete then
        Result := Result + GetPCEDataText(pdcStandardCodes, Code, Category, Narrative,
                False, 0, CodingSystemID[CodingSystem]) + CRLF; //, Magnitude, UCUMCode) + CRLF;
  Result := AddTitle(pdcStandardCodes, Result);
end;

function TPCEData.StrPatientEds: string;
var
  i: Integer;
begin
  Result := '';
  with FPatientEds do for i := 0 to Count - 1 do
    if TObject(Items[i]) is TPCEPat then with TPCEPat(Items[i]) do
      if not FDelete then
        Result := Result + GetPCEDataText(pdcPED, Code, Category, Narrative) + CRLF;
//                FALSE, 0, '', Magnitude, UCUMCode) + CRLF;
  Result := AddTitle(pdcPED, Result);
end;

function TPCEData.StrHealthFactors: string;
var
  i: Integer;
begin
  Result := '';
  with FHealthFactors do for i := 0 to Count - 1 do
    if TObject(Items[i]) is TPCEHealth then with TPCEHealth(Items[i]) do
      if not FDelete then
        Result := Result + GetPCEDataText(pdcHF, Code, Category, Narrative) + CRLF;
//                                        FALSE, 0, '', Magnitude, UCUMCode) + CRLF;
  Result := AddTitle(pdcHF, Result);
end;

function TPCEData.StrExams: string;
var
  i: Integer;
begin
  Result := '';
  with FExams do for i := 0 to Count - 1 do
    if TObject(Items[i]) is TPCEExams then with TPCEExams(Items[i]) do
      if not FDelete then
        Result := Result + GetPCEDataText(pdcExam, Code, Category, Narrative) + CRLF;
//                                        FALSE, 0, '', Magnitude, UCUMCode) + CRLF;
  Result := AddTitle(pdcExam, Result);
end;

function TPCEData.StrGenFindings: string;
var
  i: Integer;
begin
  Result := '';
  with FGenFindings do for i := 0 to Count - 1 do
    if TObject(Items[i]) is TGenFindings then with TGenFindings(Items[i]) do
      if not FDelete then
        Result := Result + GetPCEDataText(pdcGenFinding, Code, Category, Narrative) + CRLF;
  Result := AddTitle(pdcGenFinding, Result);
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
  if ASHADRelated = SCC_YES  then AddTxt('Shipboard Hazard and Defense');
  if ACLRelated = SCC_YES  then AddTxt('Camp Lejeune'); //Camp Lejeune
  if Length(Result) > 0 then Result := ' Related to: ' + Result;
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

function TPCEData.validateMagnitudeValues: boolean;
var
  str: string;

  procedure CheckList(list: TList; title: string);
  var
    i: integer;
    temp, tmpMag: string;
    item: TPCEMagItem;

  begin
    for i := 0 to List.Count - 1 do
    begin
      item := TObject(List[i]) as TPCEMagItem;
      if (item.FDelete) or (not assigned(item.UCUMInfo)) then
        continue;
      tmpMag := item.Magnitude;
      temp := item.UCUMInfo.Validate(tmpMag);
      if temp <> '' then
      begin
        temp := title + ' ' + item.Narrative + ' ' + temp;
        if str = '' then
          str := temp
        else
          str := str + CRLF + CRLF + temp;
      end;
    end;
  end;

begin
  Result :=  true;
  str := '';
  CheckList(FHealthFactors, 'Health Factor');
  CheckList(FPatientEds, 'Education Topic');
  CheckList(FExams, 'Exam');
  CheckList(FStandardCodes, 'Standard Code');
  if str <> '' then
  begin
    infoBox('The following entries have an error. ' + CRLF + CRLF + str + CRLF + CRLF +
            'Please correct the errors.', 'Warning', MB_OK or MB_ICONWARNING);
    Result := false;
  end;
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
  Result := 1;
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

function TPCEData.GetICDVersion: String;
var
  cd: TFMDateTime;  //compare date

begin
  // if no Enc Dt or Historical, Hospitalization, or Daily Visit compare I-10 Impl dt with TODAY
  if (VisitDateTime <= 0) or (FEncSvcCat = 'E') or (FEncSvcCat = 'H') then
    cd := FMNow
  else // otherwise compare I-10 Impl dt with Encounter date/time
    cd := VisitDateTime;

  if ICD10ImplDate <> 0 then
  begin
    if (ICD10ImplDate > cd) then
      Result := ICD_9_CM
    else
      Result := ICD_10_CM;
  end
  else
    Result := '';
end;

function TPCEData.GetInpatient: boolean;
begin
  Result := (FEncSvcCat = 'H');
end;

procedure TPCEData.getVimmResults(var resultList: TStringList);
var
data: TVimmResult;
i: integer;
imm: TPCEImm;
begin
  for i := 0 to FImmunizations.count-1 do
    if TObject(Fimmunizations.Items[i]) is TPCEImm then
    begin
       imm := TPCEImm(Fimmunizations.Items[i]);
       data := TVimmResult.Create;
       data.name := imm.Narrative;
//       data.adminBy := imm.administratedBy;
//       data.route := imm.route;
//       data.site := imm.site;
//       data.adminByIEN :=  imm.adminByIEN;
//       data.orderByIEN := imm.orderByIEN;
//       data.routeIEN := imm.routeIEN;
//       data.siteIEN := imm.siteIEN;
//       data.dosage := imm.dosage;
       if imm.documType <> '' then data.documType := imm.documType
       else if self.FEncSvcCat = 'E' then data.documType := 'Historical'
       else data.documType := 'Administered';
       resultList.AddObject(data.name, data);
    end;

end;

procedure TPCEData.CopyPCEData(Dest: TPCEData);
begin
  Dest.Clear;
  Dest.FEncDateTime  := FEncDateTime;
  Dest.FNoteDateTime := FNoteDateTime;
  Dest.FEncLocation  := FEncLocation;
  Dest.FEncSvcCat    := FEncSvcCat;
//  Dest.FEncInpatient := FEncInpatient;
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
  CopyPCEITems(FGenFindings,   Dest.FGenFindings,   TGenFindings);

  Dest.FNoteTitle := FNoteTitle;
  Dest.FNoteIEN := FNoteIEN;
  Dest.FParent := FParent;
  Dest.FHistoricalLocation := FHistoricalLocation;
  Dest.FVisitIEN := FVisitIEN;
end;

function TPCEData.NeededPCEData: tRequiredPCEDataTypes;
var
  EC: TSCConditions;
  NeedSC: boolean;
  TmpLst: TStringList;
  NeedDx: Boolean;
  I : Integer;
begin
  Result := [];
  if FEncounterLock then Include(result, ndLock);

  if(not FutureEncounter(Self)) then
  begin
    if(PromptForWorkload(FNoteIEN, FNoteTitle, FEncSvcCat, StandAlone)) then
    begin
      //assume we need a DX
      NeedDx := true;
      for i := 0 to FDiagnoses.count -1 do
      begin
        if (TObject(FDiagnoses[i]) is TPCEDiag) and TPCEDiag(FDiagnoses[i]).Primary then
        begin
          NeedDX := false;
          break;
        end;
      end;

      if NeedDX then Include(result, ndDiag);

      if((fProcedures.Count <= 0) and (fVisitType.Code = '')) then
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
        EC :=  EligbleConditions(Self);
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
  Result := False;
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
        if(DoAsk) or (FEncounterLock) then
        begin
          if(Asked and ((not Needed) or (not Primary)) and (not FEncounterLock)) then
            exit;
          if(Needed) or (FEncounterLock) then
          begin
            msg := TX_NEED1;
            Add(ndDiag, TX_NEED_DIAG);
            Add(ndProc, TX_NEED_PROC);
            Add(ndSC,   TX_NEED_SC);
            Add(ndLock, TX_ISLOCK);
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
              NeedSave := UpdatePCE(Self, TRUE);
              if(not DoSave) then
                DoSave := NeedSave;
              FUpdated := TRUE;
            end;
            Done := frmFrame.Closing;
            Asked := True;
          end;
        end;
      until(Done);
    finally
      if(DoSave) then
      begin
      // only change Result if it was already true and the save failed.
        if (not Save) and Result then
          Result := False;
      end;
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
  Add(StrGenFindings);
  Add(StrStandardCodes);
end;

function TPCEData.AddTitle(Cat: TPCEDataCat; input: string): string;
begin
  Result := input;
  if Length(Result) > 0 then
    Result := PCEDataCatText[Cat] + CRLF + Copy(Result, 1, Length(Result) - 2) + CRLF;
end;

procedure TPCEData.AddVitalData(Data, List: TStrings);
var
  i: integer;

begin
  for i := 0 to Data.Count-1 do
    List.Add(FormatVitalForNoteNoConv(Data[i]));
end;

function TPCEData.PersonClassDate: TFMDateTime;
begin
  if(FEncSvcCat = 'H') then
    Result := FMToday
  else
    Result := FEncDateTime; //Encounter.DateTime;
end;

function TPCEData.proceduresMissingProvider: boolean;
var
i,cnt: integer;
missingProviders: boolean;
str, temp, provider: string;
begin
  provider := '';
  missingProviders := false;
  result := false;
  str := '';
  cnt := 0;
  for i := 0 to FProcedures.Count - 1 do
    if TObject(FProcedures[i]) is TPCEProc then
    begin
      if (TPCEProc(FProcedures[i]).Provider < 1) and (not TPCEProc(FProcedures[i]).FDelete) then
        begin
          inc(cnt);
          temp := TPCEProc(FProcedures[i]).code + ' ' +  TPCEProc(FProcedures[i]).narrative;
          if str = '' then str := temp
          else str := str + CRLF + CRLF + temp;
          missingProviders := true;
        end;
    end;
  if not missingProviders then
    begin
      result := true;
      exit;
    end;
  if FProviders.primaryIdx < 0 then
    exit;
  temp := 'Assign ' + FProviders.PrimaryName;
  if cnt = 1 then temp := temp + ' to procedure code ' + str + '?'
  else temp := temp + ' to the following procedure codes' + CRLF + CRLF + str;
  if infoBox(temp, 'Missing Procedure Provider', MB_YESNO) = id_yes then
    begin
      for i := 0 to FProcedures.Count - 1 do
        if TObject(FProcedures[i]) is TPCEProc then
        begin
          if TPCEProc(FProcedures[i]).Provider < 1 then
            begin
              TPCEProc(FProcedures[i]).Provider := FProviders.primaryIEN;
              TPCEProc(FProcedures[i]).FSend := true;
            end;
        end;
      result := true;
    end;
end;

function TPCEData.VisitDateTime: TFMDateTime;
begin
  if(IsSecondaryVisit) then
    Result := FNoteDateTime
  else
    Result := FEncDateTime;
end;

function TPCEData.VisitDateTimeForce: TFMDateTime;
begin
  Result := VisitDateTime;
  if Result = 0 then
    Result := Encounter.DateTime;
end;

function TPCEData.IsSecondaryVisit: boolean;
begin
  Result := ((FEncSvcCat = 'H') and (FNoteDateTime > 0) and (GetInpatient));
//  if not Result then result := ((FEncSvcCat = 'D') and (FNoteDateTime > 0));
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
        if (TObject(FDiagnoses[i]) is TPCEDiag) and (not TPCEDiag(FDiagnoses[i]).FDelete) then
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
        if (TObject(FProcedures[i]) is TPCEProc) and (not TPCEProc(FProcedures[i]).FDelete) then
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
      if TObject(List[i]) is TPCEItem then
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
    if (TObject(Src[i]) is ItemClass) and (not TPCEItem(Src[i]).FDelete) then
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
  FPCEProviderForce := 0;
  FPCEProviderName := '';
  FPCEProviderNameForce := '';
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
    result := 0;
    if (uProviders <> nil) and (uProviders.Count > 0) then
      begin
        if uProviders.IndexOfProvider(IntToStr(AIEN)) > -1 then
          result := AIEN;
      end;
    if result = 0 then
      begin
        if(AIEN = 0) or (IndexOfProvider(IntToStr(AIEN)) < 0) then
          Result := 0
        else
          Result := AIEN;
      end;
  end;

begin
  Result := Check(Encounter.Provider);
  if(Result = 0) then Result := Check(User.DUZ);
  if(Result = 0) then Result := PrimaryIEN;
  if (Result = 0) and ((uProviders <> nil) and (uProviders.Count > 0)) then
    result := uProviders.PrimaryIEN;
end;

function TPCEProviderList.PCEProviderForce: Int64;
begin
  Result := PCEProvider;
  if Result = 0 then
    Result := Encounter.Provider;
end;

function TPCEProviderList.PCEProviderName: string;
var
  NewProv: Int64;

begin
  NewProv := PCEProvider;
  if(FPCEProviderIEN <> NewProv) then
  begin
    FPCEProviderIEN := NewProv;
    if FPCEProviderIEN = FPCEProviderForce then
      FPCEProviderName := FPCEProviderNameForce
    else
      FPCEProviderName := ExternalName(PCEProvider, FN_NEW_PERSON);
  end;
  Result := FPCEProviderName;
end;

function TPCEProviderList.PCEProviderNameForce: string;
var
  NewProv: Int64;

begin
  NewProv := PCEProviderForce;
  if(FPCEProviderForce <> NewProv) then
  begin
    FPCEProviderForce := NewProv;
    if FPCEProviderForce = FPCEProviderIEN then
      FPCEProviderNameForce := FPCEProviderName
    else
      FPCEProviderNameForce := ExternalName(PCEProviderForce, FN_NEW_PERSON);
  end;
  Result := FPCEProviderNameForce;
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
    Src.FPCEProviderForce := FPCEProviderForce;
    Src.FPCEProviderNameForce := FPCEProviderNameForce;
  end;
end;

{ TGenFindings }


{ TStandardCode }

procedure TStandardCode.Assign(Src: TPCEItem);
begin
  inherited Assign(Src);
  CodingSystem := TStandardCode(Src).CodingSystem;
  Add2PL := TStandardCode(Src).Add2PL;
  taxID :=  TStandardCode(Src).taxId;
end;

procedure TStandardCode.Clear;
begin
  inherited;
  CodingSystem := csNone;
  Add2PL := False;
  taxid := -1;
end;

function TStandardCode.DelimitedStr: string;
begin
  Result := Prefix + inherited DelimitedStr;
  SetPiece(Result, U, pnumCodingSystem, CodingSystemID[FCodingSystem]);
  SetPiece(Result, U, pnumSCAdd2PL, BOOLCHAR[FAdd2PL]);
end;

function TStandardCode.GetUCUMMagCode: string;
begin
  if taxId > -1 then
    Result := IntToStr(taxId)
  else
    Result := '';
end;

function TStandardCode.ItemStr: string;
begin
  Result := CodingSystemDesc[CodingSystem] + U + Code + U + Narrative;
  if Add2PL then
    Result := Result + U + 'Add';
end;

function TStandardCode.Prefix: string;
begin
  Result := 'SC';
end;

procedure TStandardCode.SetFromString(const x: string);
var
  i: TCodingSystem;
  system: String;

begin
  inherited SetFromString(x);
  system := Piece(x, U, pnumCodingSystem);
  for i := low(TCodingSystem) to high(TCodingSystem) do
  begin
    if (system = CodingSystemID[i]) or (system = CodingSystemDesc[i]) then
    begin
      CodingSystem := i;
      Category := CodingSystemDesc[i];
      break;
    end;
  end;
  Add2PL    := (Piece(x, U, pnumSCAdd2PL) = '1');
end;

procedure TStandardCode.SetTaxID(const Value: integer);
begin
 if FTaxId <> Value then
  begin
    FTaxId := Value;
    FUCUMInfo := GetUCUMInfo(Prefix, GetUCUMMagCode);
  end;
end;

const
  MAG_DATE_FORMAT = 'mm/dd/yyyy';
  MAG_TIME_FORMAT = 'hh:mmAM/PM';
  MAG_TIME_INTERNAL_FORMAT = 'hh:nnAM/PM';
  MAG_DEFAULT = 'Magnitude';

procedure ParseMagUCUM4StandardCodes(edtMag: TDataEdit);
var
  info: TUCUMInfo;

begin
  if edtMag.DataObject is TUCUMInfo then
    info := TUCUMInfo(edtMag.DataObject)
  else
    info := nil;
  ParseMagUCUMData(info, nil, edtMag, nil, nil);
end;

procedure ParseMagUCUMData(Info: TUCUMInfo; lblMag: TLabel;
  edtMag: TDataEdit; lblUCUM, lblUCUM2: TLabel);
var
  ok: boolean;

  procedure SetVisible(ctrl: TControl; Setting: boolean = FALSE);
  begin
    if assigned(ctrl) then
      ctrl.Visible := Setting;
  end;

begin
  edtMag.DataObject := Info;
  if assigned(Info) then
  begin
    with Info do
    begin
      ok := (FDataType <> udtNumber) or (FMin <> 0.0) or (FMax <> 0.0);
      if assigned(lblMag) then
      begin
        if FPromptCaption <> '' then
          begin
            lblMag.Caption := FPromptCaption;
            SetVisible(lblUCUM);
          end
        else
          lblMag.caption := MAG_DEFAULT;
        SetVisible(lblMag, ok);
      end;
      SetVisible(edtMag, ok);
      if ok then
        edtMag.Hint := HintText;
      ok := length(FUCUMCaption) > 0;
      if (assigned(lblUCUM)) and (FPromptCaption = '')  then
        lblUCUM.Visible := ok;
      if assigned(lblUCUM2) then
      begin
        lblUCUM2.Caption := FUCUMCaption;
        lblUCUM2.Visible := ok;
      end;
    end;
  end
  else
  begin
    SetVisible(lblMag);
    SetVisible(edtMag);
    SetVisible(lblUCUM);
    SetVisible(lblUCUM2);
  end;
end;

function ValidateMagnitudeMessage(edtMag: TDataEdit): string;
var
  Caption, txt: string;
  pfrm: TCustomForm;
  Update: boolean;

begin
  Result := '';
  if edtMag.DataObject is TUCUMInfo then
  begin
    txt := Trim(edtMag.Text);
    Update := FALSE;
    if (txt = '') and (edtMag.Text <> '') then
      Update := TRUE
    else if (txt <> '') then
    begin
      if edtMag is TCPRSDialogFieldEdit then
        Caption := TCPRSDialogFieldEdit(edtMag).UCUMCaption
      else
        Caption := TUCUMInfo(edtMag.DataObject).PromptCaption;
      if Caption = '' then
        Caption := MAG_DEFAULT;
      Result := TUCUMInfo(edtMag.DataObject).Validate(txt, Caption);
      if Result = '' then
        Update := TRUE
      else
        Result := Caption + ' Error' + U + Result;
    end;
    if Update then
    begin
      edtMag.Text := txt;
      if (edtMag is TCPRSDialogFieldEdit) and
        assigned(TCPRSDialogFieldEdit(edtMag).Prompt) then
        TCPRSDialogFieldEdit(edtMag).Prompt.Value := txt;
      pfrm := GetParentForm(edtMag);
      if assigned(pfrm) and (pfrm.ActiveControl = edtMag) then
        edtMag.SelectAll;
    end
  end;
end;

procedure ValidateMagKeyPress(Sender: TObject; var Key: Char);
var
  magDataType: TUCUMDataType;
  ctrl: TDataEdit;

begin
  if (Sender is TDataEdit) then
    ctrl := TDataEdit(Sender)
  else
    ctrl := nil;
  if assigned(ctrl) and (ctrl.DataObject is TUCUMInfo) then
    magDataType := TUCUMInfo(ctrl.DataObject).FDataType
  else
    magDataType := udtNumber;
  case magDataType of
    udtDate, udtTime:
      if (Key = Char(VK_RETURN)) and assigned(ctrl) then
      begin
        PostValidateMag(ctrl);
        Key := #0;
      end;
  else
    NumericKeyPress(Sender, Key);
  end;
end;

function ValidateMag(edtMag: TDataEdit): boolean;
var
  msg, hdr: string;
  remDlg: TfrmRemDlg;

begin
  msg := ValidateMagnitudeMessage(edtMag);
  if msg = '' then
    Result := true
  else
  begin
    Result := False;
    if edtMag.Owner is TfrmRemDlg then
    begin
      remDlg := TfrmRemDlg(edtMag.Owner);
      if (edtMag is TCPRSDialogFieldEdit) and (remDlg.MessageBoxText = '') then
      begin
        remDlg.MessageBoxText := msg;
        PostMessage(remDlg.Handle, UM_MESSAGEBOX, 0,
          integer(TCPRSDialogFieldEdit(edtMag).Prompt));
      end;
    end
    else
    begin
      hdr := Piece(msg,U,1);
      msg := Piece(msg,U,2);
      InfoBox(msg, hdr, MB_OK or MB_ICONERROR);
    end;
  end;
end;

procedure PostValidateMag(edtMag: TDataEdit);
var
  pfrm: TCustomForm;

begin
  pfrm := GetParentForm(edtMag);
  if assigned(pfrm) and pfrm.Visible and edtMag.CanFocus and
    IsWindowVisible(edtMag.Handle) then
  begin
    ClearPostValidateMag(pfrm);
    PostMessage(pfrm.Handle, UM_VALIDATE_MAG, WParam(edtMag), 0);
  end;
end;

function HandlePostValidateMag(Message: TMessage): boolean;
var
  edt: TDataEdit;
  pfrm: TCustomForm;

begin
  Result := True;
  edt := TDataEdit(Message.WParam);
  pfrm := GetParentForm(edt);
  if assigned(pfrm) and pfrm.visible and edt.CanFocus and
    IsWindowVisible(edt.Handle) and (not ValidateMag(edt)) then
  begin
    if edt.CanFocus then
      edt.SetFocus;
    ClearPostValidateMag(pfrm);
    Result := FALSE;
  end;
end;

function ProcessPostedValidateMag(form: TCustomForm): boolean;
var
  Msg: TMsg;
  message: TMessage;
  pfrm: TCustomForm;

begin
  Result := True;
  pfrm := GetParentForm(form);
  if assigned(pfrm) and PeekMessage(msg, pfrm.Handle, UM_VALIDATE_MAG,
    UM_VALIDATE_MAG, PM_REMOVE) then
  begin
    message.Msg := Msg.message;
    message.WParam := Msg.wParam;
    message.LParam := Msg.lParam;
    message.Result := 0;
    Result := HandlePostValidateMag(message);
  end;
end;

procedure ClearPostValidateMag(form: TCustomForm);
var
  Msg: TMsg;
  pfrm: TCustomForm;

begin
  pfrm := GetParentForm(form);
  if assigned(pfrm) then
    PeekMessage(Msg, pfrm.Handle, UM_VALIDATE_MAG, UM_VALIDATE_MAG, PM_REMOVE);
end;

var
  LastUCUMCode: Int64 = 0;
  LastUCUMText: string = '';

function GetUCUMText(UCUMCode: Int64): string;
begin
  if (LastUCUMCode <> UCUMCode) then
  begin
    LastUCUMCode := UCUMCode;
    LastUCUMText := ExternalName(UCUMCode, 757.5);
  end;
  Result := LastUCUMText;
end;

{ TUCUMInfo }

constructor TUCUMInfo.Create(UCUMData: string);
begin
  inherited Create;
  Update(UCUMData);
end;

function TUCUMInfo.Fmat(val: Extended): string;
var
  p: integer;

begin
  Result := FloatToStr(abs(val));
  p := pos('.',Result);
  if p=0 then
    p := length(Result) + 1;
  dec(p);
  if p > 3 then
  begin
    p := p - 3;
    while(p > 0) do
    begin
      Result := copy(Result,1,p) + ',' + copy(Result,p+1,MaxInt);
      dec(p,3);
    end;
  end;
  if val < 0 then
    Result := '-' + Result;
end;

function TUCUMInfo.HintText: string;
begin
  case FDataType of
    udtDate:
      Result := MAG_DATE_FORMAT;
    udtTime:
      Result := MAG_TIME_FORMAT;
  else
    begin
      if FDec = 0 then
        Result := 'whole '
      else
        Result := '';
      Result := 'A '+ Result + 'number between ' + Fmat(FMin) + ' and ' + Fmat(FMax);
      if FDec > 0 then
      begin
        Result := Result + ', with no more than ' + FDec.ToString + ' decimal place';
        if FDec > 1 then
          Result := Result + 's';
      end;
      Result := Result + '.';
    end;
  end;
end;

procedure TUCUMInfo.Update(UCUMData: string);
var
  desc: string;

  function cvert(data: string): Extended;
  begin
    if pos('.', data) = 0 then
      Result := StrToInt64Def(data, 0)
    else
      Result := StrToFloatDef(data, 0.0)
  end;

begin
  FMin := cvert(Piece(UCUMData, U, 1));
  FMax := cvert(Piece(UCUMData, U, 2));
  FDec := StrToIntDef(Piece(UCUMData, U, 3), 0);
  FCode := Piece(UCUMData, U, 4);
  FPromptCaption := Piece(UCUMData, U, 5);
  FUCUMCaption := Piece(UCUMData, U, 6);
  desc := Piece(UCUMData, U, 7);
  if desc = 'month-day-year' then
    FDataType := udtDate
  else if desc = 'clock time e.g 12:30PM' then
    FDataType := udtTime
  else
    FDataType := udtNumber;
end;

function TUCUMInfo.Validate(var Value: string; OverridePrompt: string = ''): string;
var
  newValue, tmpValue, msg, TimePart: string;
  vDateTime: TDateTime;
  fmDateTime: TFMDateTime;
  val: Extended;
  p, vlen: integer;
  valHasDec, newValHasDec: boolean;

  procedure Add(Text: string);
  begin
    if Result = '' then
    begin
      if OverridePrompt <> '' then
        Result := OverridePrompt
      else
      begin
        if FPromptCaption = '' then
          Result := MAG_DEFAULT
        else
          Result := FPromptCaption;
      end;
      Result := Result + ' ';
    end
    else
    begin
      if Result.EndsWith('.') then
        Result[Result.Length] := ',';
      Result := Result + ' and ';
    end;
    Result := Result + Text + '.';
  end;

begin
  Result := '';
  Value := trim(Value);
  if Value = '' then
    Add('has not been entered')
  else
  begin
    newValue := Value;
    case FDataType of
      udtDate:
        begin
          fmDateTime := StrToFMDateTime(Value);
          if fmDateTime < 0 then
            Add('is not in valid date format (' + MAG_DATE_FORMAT + ')')
          else
            Value := FormatFMDateTime(MAG_DATE_FORMAT, Trunc(fmDateTime));
        end;

      udtTime:
        begin
          if IsDigits(Value) then
            tmpValue := '@' + Value
          else
            tmpValue := Value;
          fmDateTime := StrToFMDateTime(tmpValue);
          if fmDateTime < 0 then
            Add('is not in valid time format (' + MAG_TIME_FORMAT + ')')
          else
          begin
            TimePart := copy(Piece(FloatToStrF(fmDateTime, ffFixed, 14, 6), '.',
              2) + '0000', 1, 4);
            if (TimePart = '0000') or (TimePart = '2400') then
              fmDateTime := Trunc(fmDateTime) + 0.0001;
            vDateTime := FMDateTimeToDateTime(fmDateTime);
            Value := FormatDateTime(MAG_TIME_INTERNAL_FORMAT, vDateTime);
          end;
        end;

    else
      begin
        val := StrToFloatDef(Value, 0.0);
        newValue := FloatToStr(val);
        if val < FMin then
          Add('can''t be less than ' + fmat(FMin));
        if val > FMax then
          Add('can''t be greater than ' + fmat(FMax));
        p := pos('.', Value);
        if (p > 0) and (Length(Value) > (p + FDec)) then
        begin
          if FDec = 0 then
            msg := 'can''t have any decimal places'
          else
          begin
            msg := 'can only have ' + FDec.ToString + ' decimal place';
            if FDec > 1 then
              msg := msg + 's';
          end;
          Add(msg);
        end;
        if (Result = '') and (newValue <> Value) then
        begin
          p := pos('.', Value);
          vlen := Length(Value);
          valHasDec := (p > 0);
          newValHasDec := (pos('.', newValue) > 0);
          if valHasDec and (p < vlen) then
          begin
            p := vlen;
            while ((p > 0) and (Value[p] = '0')) do
              p := p - 1;
            if p < vlen then
            begin
              if valHasDec and (not newValHasDec) then
                newValue := newValue + '.';
              newValue := newValue + StringOfChar('0', vlen - p);
            end;
          end;
          Value := newValue;
        end;
      end;
    end;
  end;
end;

initialization

finalization
  KillObj(@PCESetsOfCodes);
  KillObj(@HistLocations);

end.
