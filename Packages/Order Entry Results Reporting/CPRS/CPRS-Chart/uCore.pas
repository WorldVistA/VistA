unit uCore;
{ The core objects- patient, user, and encounter are defined here.  All other clinical objects
  in the GUI assume that these core objects exist. }

{$OPTIMIZATION OFF}                              // REMOVE AFTER UNIT IS DEBUGGED

interface

uses
  SysUtils,
  Windows,
  WinAPI.ShellAPI,
  Classes,
  Forms,
  ORFn,
  rCore,
  uConst,
  ORClasses,
  uCombatVet,
  UORJSONParameters,
  uWriteAccess,
  Controls;

type
  TWinControlHack = Class(Controls.TWinControl);

  TUser = class(TObject)
  private
    FDUZ:             Int64;                      // User DUZ (IEN in New Person file)
    FName:            string;                     // User Name (mixed case)
    FUserClass:       Integer;                    // User Class (based on OR keys for now)
    FCanSignOrders:   Boolean;                    // Has ORES key
    FIsProvider:      Boolean;                    // Has VA Provider key
    FOrderRole:       Integer;
    FNoOrdering:      Boolean;
    FEnableVerify:    Boolean;
    FActOneStep:      Boolean;
    FDTIME:           Integer;
    FCountDown:       Integer;
    FCurrentPrinter:  string;
    FNotifyAppsWM:    Boolean;
    FDomain:          string;
    FPtMsgHang:       Integer;
    FService:         Integer;
    FAutoSave:        Integer;
    FInitialTab:      Integer;
    FUseLastTab:      Boolean;
    FWebAccess:       Boolean;
    FIsRPL:           string;
    FRPLList:         string;
    FHasCorTabs:      Boolean;
    FHasRptTab:       Boolean;
    FIsReportsOnly:   Boolean;
    FToolsRptEdit:    Boolean;
    FDisableHold:     Boolean;
    FGECStatus:       Boolean;
    FStationNumber:   string;
    FIsProductionAccount: boolean;
    FJobNumber:       string;
  public
    constructor Create;
    function HasKey(const KeyName: string): Boolean;
    procedure SetCurrentPrinter(Value: string);
    property DUZ:             Int64   read FDUZ;
    property Name:            string  read FName;
    property UserClass:       Integer read FUserClass;
    property CanSignOrders:   Boolean read FCanSignOrders;
    property IsProvider:      Boolean read FIsProvider;
    property OrderRole:       Integer read FOrderRole;
    property NoOrdering:      Boolean read FNoOrdering;
    property EnableVerify:    Boolean read FEnableVerify;
    property EnableActOneStep: Boolean read FActOneStep;
    property DTIME:           Integer read FDTIME;
    property CountDown:       Integer read FCountDown;
    property PtMsgHang:       Integer read FPtMsgHang;
    property Service:         Integer read FService;
    property AutoSave:        Integer read FAutoSave;
    property InitialTab:      Integer read FInitialTab;
    property UseLastTab:      Boolean read FUseLastTab;
    property WebAccess:       Boolean read FWebAccess;
    property DisableHold:     Boolean read FDisableHold;
    property IsRPL:           string  read FIsRPL;
    property RPLList:         string  read FRPLList;
    property HasCorTabs:      Boolean read FHasCorTabs;
    property HasRptTab:       Boolean read FHasRptTab;
    property IsReportsOnly:   Boolean read FIsReportsOnly;
    property ToolsRptEdit:    Boolean read FToolsRptEdit;
    property CurrentPrinter:  string  read FCurrentPrinter write SetCurrentPrinter;
    property GECStatus:       Boolean read FGECStatus;
    property StationNumber:   string  read FStationNumber;
    property IsProductionAccount: boolean read FIsProductionAccount;
    property JobNumber:       string read FJobNumber;
  end;

  TPatient = class(TObject)
  private
    FDFN:        string;                         // Internal Entry Number in Patient file  //*DFN*
    FICN:        string;                         // Integration Control Number from MPI
    FFullICN:    string;                         // Integration Contorl Number including checksum from MPI
    FName:       string;                         // Patient Name (mixed case)
    FSSN:        string;                         // Patient Identifier (generally SSN)
    FDOB:        TFMDateTime;                    // Date of Birth in Fileman format
    FAge:        Integer;                        // Patient Age
    FSex:        Char;                           // Male, Female, Unknown
    FSIGI:       string;                         // SIGI: Male, Female, TransMale, TransFemale,
                                                 //       TransMan, Transwoman, Male-to-Female,
                                                 //       Female-to-Male, Individual chooses not to answer
    FPronoun:    string;                         // he/him/she/her/they/them
    FCWAD:       string;                         // chars identify if pt has CWAD warnings
    FRestricted: Boolean;                        // True if this is a restricted record
    FInpatient:  Boolean;                        // True if that patient is an inpatient
    FStatus:     string;                         // Patient status indicator (Inpatient or Outpatient)
    FLocation:   Integer;                        // IEN in Hosp Loc if inpatient
    FWardService: string;
    FSpecialty:  Integer;                        // IEN of the treating specialty if inpatient
    FSpecialtySvc: string;                       // treating specialty service if inpatient
    FAdmitTime:  TFMDateTime;                    // Admit date/time if inpatient
    FSrvConn:    Boolean;                        // True if patient is service connected
    FSCPercent:  Integer;                        // Per Cent Service Connection
    FPrimTeam:   string;                         // name of primary care team
    FPrimProv:   string;                         // name of primary care provider
    FAttending:  string;                         // if inpatient, name of attending
    FAssociate:  string;                         // if inpatient, name of associate
    FInProvider:  string;                        // if inpatient, name of inpatient provider
    FMHTC:       string;                         // name of Mental Health Treatment Coordinator
    FDateDied: TFMDateTime;                      // Date of Patient Death (<=0 or still alive)
    FDateDiedLoaded: boolean;                    // Used to determine of DateDied has been loaded
    FCombatVet : TCombatVet;                     // Object Holding CombatVet Data
    FVAAData: TStringList;                       // Holds raw insurance information
    FMHVData: TStringList;                       // Holds raw MyHealthyVet information
    procedure SetDFN(const Value: string);
    function GetDateDied: TFMDateTime;
    function GetCombatVet: TCombatVet;       // *DFN*
    function GetPtIsVAA: boolean;
    function GetPtIsMHV: boolean;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure RefreshVAAStatus;
    procedure RefreshMHVStatus;
    procedure GetVAAInformation(var aSubscriberName: string; aReportText: TStrings);

    property DFN:              string      read FDFN write SetDFN;  //*DFN*
    property ICN:              string      read FICN;
    property FullICN:          string      read FFullICN;
    property Name:             string      read FName;
    property SSN:              string      read FSSN;
    property DOB:              TFMDateTime read FDOB;
    property Age:              Integer     read FAge;
    property Sex:              Char        read FSex;
    property SIGI:             string      read FSIGI; // NSR#20130305
    property Pronoun:          string      read FPronoun;
    property CWAD:             string      read FCWAD;
    property Inpatient:        Boolean     read FInpatient;
    property Status:           string      read FStatus;
    property Location:         Integer     read FLocation;
    property WardService:      string      read FWardService;
    property Specialty:        Integer     read FSpecialty;
    property SpecialtySvc:     string      read FSpecialtySvc;
    property AdmitTime:        TFMDateTime read FAdmitTime;
    property DateDied:         TFMDateTime read GetDateDied;
    property ServiceConnected: Boolean     read FSrvConn;
    property SCPercent:        Integer     read FSCPercent;
    property PrimaryTeam:      string      read FPrimTeam;
    property PrimaryProvider:  string      read FPrimProv;
    property Attending:        string      read FAttending;
    property Associate:        string      read FAssociate;
    property InProvider:        string     read FInProvider;
    property MHTC:             string      read FMHTC;
    property CombatVet:        TCombatVet  read GetCombatVet;
    property PtIsMHV:          boolean     read GetPtIsMHV;
    property PtIsVAA:          boolean     read GetPtIsVAA;
  end;

  TEncounter = class(TObject)
  private
    FChanged:       Boolean;                     // one or more visit fields have changed
    FDateTime:      TFMDateTime;                 // date/time of encounter (appt, admission)
//    FInpatient:     Boolean;                     // true if this is an inpatient encounter
    FLocation:      Integer;                     // IEN in Hospital Location file
    FLocationName:  string;                      // Name in Hospital Location file
    FLocationText:  string;                      // Name + Date/Time or Name + RoomBed
    FProvider:      Int64  ;                     // IEN in New Person file
    FProviderName:  string;                      // Name in New Person file
    FVisitCategory: Char;                        // A=ambulatory,T=Telephone,H=inpt,E=historic
    FStandAlone:    Boolean;                     // true if visit not related to appointment
    FNotifier:      TORNotifier;                 // Event handlers for location changes
    function GetLocationName: string;
    function GetLocationText: string;
    function GetProviderName: string;
    function GetVisitCategory: Char;
    function GetVisitStr: string;
    procedure SetDateTime(Value: TFMDateTime);
    function GetInpatient: Boolean;
    procedure SetInpatient(Value: Boolean);
    procedure SetLocation(Value: Integer);
    procedure SetProvider(Value: Int64);
    procedure SetStandAlone(Value: Boolean);
    procedure SetVisitCategory(Value: Char);
    procedure UpdateText;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure EncounterSwitch(Loc: integer; LocName, LocText: string; DT: TFMDateTime; vCat: Char);
    procedure SwitchToSaved(ShowInfoBox: boolean);
    procedure EmptySaved();
    procedure CreateSaved(Reason: string);
    function GetICDVersion: String;
    function NeedVisit: Boolean;
    property DateTime:        TFMDateTime read FDateTime  write SetDateTime;
    property Inpatient:       Boolean     read GetInpatient write SetInpatient;
    property Location:        Integer     read FLocation  write SetLocation;
    property LocationName:    string      read GetLocationName write FLocationName;
    property LocationText:    string      read GetLocationText write FLocationText;
    property Provider:        Int64       read FProvider  write SetProvider;
    property ProviderName:    string      read GetProviderName;
    property StandAlone:      Boolean     read FStandAlone write SetStandAlone;
    property VisitCategory:   Char        read GetVisitCategory write SetVisitCategory;
    property VisitStr:        string      read GetVisitStr;
    property Notifier:        TORNotifier read FNotifier;
  end;

  TChangeItem = class
  private
    FItemType:     Integer;
    FID:           String;
    FText:         String;
    FGroupName:    String;
    FSignState:    Integer;
    FParentID:     String;
    FUser:         Int64;
    FOrderDG:      String;
    FOrderDGIEN:   Integer;
    FDCOrder:      Boolean;
    FDelay:        Boolean;
    FWriteAccessType: TWriteAccessType;
    constructor Create(AnItemType: Integer;
      const AnID, AText, AGroupName: string; ASignState: Integer;
      AWriteAccessType: TWriteAccessType = waNone; AParentID: string = '';
      User: Int64 = 0; AOrderDGIEN: Integer = 0; OrderDG: string = '';
      DCOrder: Boolean = False; Delay: Boolean = False);
  public
    property ItemType:  Integer read FItemType;
    property ID:        string  read FID;
    property Text:      string  read FText;
    property GroupName: string  read FGroupName;
    property SignState: Integer read FSignState write FSignState;
    property ParentID : string  read FParentID;
    property User: Int64 read FUser write FUser;
    property OrderDGIEN: integer read FOrderDGIEN write FOrderDGIEN;
    property OrderDG: string read FOrderDG write FOrderDG;
    property DCOrder: boolean read FDCOrder write FDCOrder;
    property Delay: boolean read FDelay write FDelay;
    property WriteAccessType: TWriteAccessType read FWriteAccessType write FWriteAccessType;
    function CSValue(): Boolean;
  end;

  TORRemoveChangesEvent = procedure(Sender: TObject; ChangeItem: TChangeItem) of object;  {**RV**}

  TChanges = class
  private
    FCount:        Integer;
    FDocuments:    TList;
    FOrders:       TList;
    FOrderGrp:     TStringList;
    FPCE:          TList;
    FPCEGrp:       TStringList;
    FOnRemove:     TORRemoveChangesEvent;    {**RV**}
    FRefreshCoverPL: Boolean;
    FRefreshProblemList: Boolean;
  private
    procedure AddUnsignedToChanges;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(ItemType: Integer; const AnID, ItemText, GroupName: string;
      SignState: Integer; AWriteAccessType: TWriteAccessType = waNone;
      AParentID: string = ''; User: Int64 = 0; AOrderDGIEN: Integer = 0;
      OrderDG: String = ''; DCOrder: Boolean = False; Delay: Boolean = False;
      ProblemAdded: Boolean = False);
    procedure Clear;
    function CanSign: Boolean;
    function Exist(ItemType: Integer; const AnID: string): Boolean;
    function ExistForOrder(const AnID: string): Boolean;
    function Locate(ItemType: Integer; const AnID: string): TChangeItem;
    procedure Remove(ItemType: Integer; const AnID: string);
    procedure ReplaceID(ItemType: Integer; const OldID, NewID: string);
    procedure ReplaceSignState(ItemType: Integer; const AnID: string; NewState: Integer);
    procedure ReplaceText(ItemType: Integer; const AnID, NewText: string);
    procedure ReplaceODGrpName(const AnODID, NewGrp: string);
    procedure ChangeOrderGrp(const oldGrpName,newGrpName: string);
    function RequireReview: Boolean;
    property Count:      Integer     read FCount;
    property Documents:  TList       read FDocuments;
    property OnRemove: TORRemoveChangesEvent read FOnRemove write FOnRemove;        {**RV**}
    property Orders:     TList       read FOrders;
    property PCE:        TList       read FPCE;
    property OrderGrp: TStringList read FOrderGrp;
    property PCEGrp:   TStringList read FPCEGrp;
    property RefreshCoverPL: Boolean read FRefreshCoverPL write FRefreshCoverPL;
    property RefreshProblemList: Boolean read FRefreshProblemList write FRefreshProblemList;
  end;

  TNotifyItem = class
  private
    DFN: string;
    FollowUp: Integer;
    //AlertData: string;
    RecordID: string;
    HighLightSection: String;
    Data: TStringList;
    Processing: boolean;
  end;

  TNotifications = class
  private
    FActive: Boolean;
    FList: TList;
    FCurrentIndex: Integer;
    FNotifyItem: TNotifyItem;
    FNotifIndOrders: boolean;
    function GetDFN: string;  //*DFN*
    function GetFollowUp: Integer;
    function GetAlertData: string;
    function GetHighLightSection: String; //CB
    function GetIndOrderDisplay: Boolean;
    function GetRecordID: string;
    function GetText: string;
    function GetData: TStringList;
    function GetProcessing: boolean;
    procedure SetIndOrderDisplay(Value: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(const ADFN: string; AFollowUp: Integer; const ARecordID: string;
      AHighLightSection : string; AData : TStringList; AProcessing: boolean = true);
    procedure Clear;
    procedure Next;
    procedure Prior;
    procedure Delete;
    procedure DeleteForCurrentUser;
    function IsLast: boolean;
    property Active:   Boolean read FActive;
    property DFN:      string  read GetDFN;  //*DFN*
    property FollowUp: Integer read GetFollowUp;
    property AlertData: string read GetAlertData;
    property RecordID: string  read GetRecordID;
    property Text:     string  read GetText;
    property Data:     TStringList  read GetData;
    property Processing: boolean read GetProcessing;
    property HighLightSection: String read GetHighLightSection; //cb
    property IndOrderDisplay:  Boolean read GetIndOrderDisplay write SetIndOrderDisplay;
  end;

  TRemoteSite = class
  private
    FSiteID: string;
    FSiteName: string;
    FLastDate: TFMDateTime;
    FSelected: Boolean;
    FRemoteHandle: string;
    FLabRemoteHandle: string;
    FQueryStatus: string;
    FLabQueryStatus: string;
    FData: TStringList;
    FLabData: TStringList;
    FCurrentLabQuery: string;
    FCurrentReportQuery: string;
    procedure SetSelected(Value: Boolean);
  public
    destructor  Destroy; override;
    constructor Create(ASite: string);
    procedure ReportClear;
    procedure LabClear;
    property SiteID  : string        read FSiteID;
    property SiteName: string        read FSiteName;
    property LastDate: TFMDateTime   read FLastDate;
    property Selected: boolean       read FSelected write SetSelected;
    property RemoteHandle: string    read FRemoteHandle write FRemoteHandle;
    property QueryStatus: string     read FQueryStatus write FQueryStatus;
    property Data: TStringList       read FData write FData;
    property LabRemoteHandle: string read FLabRemoteHandle write FLabRemoteHandle;
    property LabQueryStatus: string  read FLabQueryStatus write FLabQueryStatus;
    property LabData: TStringList    read FLabData write FLabData;
    property CurrentLabQuery: string    read FCurrentLabQuery write FCurrentLabQuery;
    property CurrentReportQuery: string read FCurrentReportQuery write FCurrentReportQuery;
  end;

  TRemoteSiteList = class
  private
    FCount: integer;
    FSiteList: TList;
    FRemoteDataExists: Boolean;
    FNoDataReason: string;
  public
    constructor Create;
    destructor  Destroy; override;
    procedure   Add(ASite: string);
    procedure   ChangePatient(const DFN: string);
    procedure   Clear;
    property    Count           : integer     read FCount;
    property    SiteList        : TList       read FSiteList;
    property    RemoteDataExists: Boolean     read FRemoteDataExists;
    property    NoDataReason    : string      read FNoDataReason;
  end;

  TRemoteReport = class
  private
    FReport: string;
    FHandle: string;
  public
    constructor Create(AReport: string);
    destructor Destroy; override;
    property Handle            :string     read FHandle write FHandle;
    property Report            :string     read FReport write FReport;
  end;

  TRemoteReportList = class
  private
    FCount: integer;
    FReportList: TList;
  public
    constructor Create;
    destructor  Destroy; override;
    procedure   Add(AReportList, AHandle: string);
    procedure   Clear;
    property    Count           :integer     read FCount;
    property    ReportList      :TList       read FReportList;
  end;

  PReportTreeObject = ^TReportTreeObject;
  TReportTreeObject = Record
    ID       : String;         //Report ID
    Heading  : String;         //Report Heading
    Remote   : String;         //Remote Data Capable
    RptType  : String;         //Report Type
    Category : String;         //Report Category
    RPCName  : String;         //Associated RPC
    IFN      : String;         //IFN of report in file 101.24
    HDR      : String;         //HDR is source of data if = 1
  end;

var
  User: TUser;
  Patient: TPatient;
  Encounter: TEncounter = nil;
  SavedEncounter: TEncounter = nil;
  Changes: TChanges;
  RemoteSites: TRemoteSiteList;
  RemoteReports: TRemoteReportList;
  Notifications: TNotifications;
  HasFlag: boolean;
  FlagList: TStringList;
  ICD10ImplDate: TFMDateTime;
  EncLoadDateTime: TDateTime = 0;
  PLUpdateDateTime: TDateTime = 0;
  //hds7591  Clinic/Ward movement.
  TempEncounterLoc: Integer; // used to Save Encounter Location when user selected "Review Sign Changes" from "File"
  TempEncounterLocName: string; // since in the path PatientRefresh is done prior to checking if patient has been admitted while entering OPT orders.
  TempEncounterText: string;
  TempEncounterDateTime: TFMDateTime;
  TempEncounterVistCat: Char;
  SavedEncounterLoc: Integer; // used to Save Encounter Location when doing clinic meds/ivs
  SavedEncounterLocName: string;
  SavedEncounterText: string;
  SavedEncounterDateTime: TFMDateTime;
  SavedEncounterVisitCat: Char;
  SavedEncounterReason: string; //used to store why it will be reverted to the saved value
  uAllergyCacheCreated: Boolean = False;
  uAllergiesChanged: Boolean = false;

procedure NotifyOtherApps(const AppEvent, AppData: string);
procedure FlushNotifierBuffer;
procedure TerminateOtherAppNotification;
procedure GotoWebPage(const URL: WideString);
function subtractMinutesFromDateTime(Time1 : TDateTime;Minutes : extended) : TDateTime;
function AllowAccessToSensitivePatient(NewDFN: string; var AccessStatus: integer): boolean;
function SystemParameters: TORJSONParameters;
procedure ClearSystemParameters;
function EHRActive: boolean;

const
  ICD_9_CM = 'ICD^ICD-9-CM';
  ICD_10_CM = '10D^ICD-10-CM';

implementation

uses ORNet, rTIU, rOrders, rConsults, uOrders;

type
  HlinkNavProc = function(pUnk: IUnknown; szTarget: PWideChar): HResult; stdcall;

var
  uVistaMsg, uVistaDomMsg: UINT;

type
  TNotifyAppsThread = class(TThread)
  private
    FRunning: boolean;
  public
    constructor CreateThread;
    procedure ResumeIfIdle;
    procedure ResumeAndTerminate;
    procedure Execute; override;
    property Running: boolean read FRunning;
  end;

  TMsgType = (mtVistaMessage, mtVistaDomainMessage);

var
  uSynchronizer: TMultiReadExclusiveWriteSynchronizer = nil;
  uNotifyAppsThread: TNotifyAppsThread = nil;
  uNotifyAppsQueue: TStringList = nil;
  uNotifyAppsActive: boolean = TRUE;
  AnAtom: ATOM = 0;

const
  LONG_BROADCAST_TIMEOUT = 30000; // 30 seconds
  SHORT_BROADCAST_TIMEOUT = 2000; // 2 seconds
  MSG_TYPE: array[TMsgType] of String = ('V','D');

function AllowAccessToSensitivePatient(NewDFN: string; var AccessStatus: integer): boolean;
const
  TX_DGSR_ERR    = 'Unable to perform sensitive record checks';
  TC_DGSR_ERR    = 'Error';
  TC_DGSR_SHOW   = 'Restricted Record';
  TC_DGSR_DENY   = 'Access Denied';
  TX_DGSR_YESNO  = 'Do you want to continue accessing this patient record? No/Yes';
  TC_NEXT_NOTIF  = 'NEXT NOTIFICATION:  ';
var
  //AccessStatus: integer;
  AMsg, PrefixC, PrefixT: string;
  ASensitivePatientPrompt: string;
begin
  Result := TRUE;
  if Notifications.Active then
  begin
    PrefixT := Piece(Notifications.RecordID, U, 1) + CRLF + CRLF;
    PrefixC := TC_NEXT_NOTIF;
  end
  else
  begin
    PrefixT := '';
    PrefixC := '';
  end;

  CheckSensitiveRecordAccess(NewDFN, AccessStatus, AMsg);
  case AccessStatus of
    DGSR_FAIL:
      begin
        InfoBox(PrefixT + TX_DGSR_ERR, PrefixC + TC_DGSR_ERR, MB_OK);
        Result := False;
      end;
    DGSR_NONE: { Nothing - allow access to the patient. };
    DGSR_SHOW:
      InfoBox(PrefixT + AMsg, PrefixC + TC_DGSR_SHOW, MB_OK);
    DGSR_ASK:
      begin
        ASensitivePatientPrompt := SystemParameters.AsTypeDef<string>
          ('sensitivePatientPrompt', TX_DGSR_YESNO);

        if InfoBox(PrefixT + AMsg + CRLF + ASensitivePatientPrompt, PrefixC + TC_DGSR_SHOW,
          MB_YESNO or MB_ICONWARNING or MB_DEFBUTTON2) = IDYES then
          LogSensitiveRecordAccess(NewDFN)
        else
          Result := False;
      end
  else
    begin
      InfoBox(PrefixT + AMsg, PrefixC + TC_DGSR_DENY, MB_OK);
      if Notifications.Active then
        Notifications.DeleteForCurrentUser;
      Result := False;
    end;
  end;
end;

function QueuePending: boolean;
begin
  uSynchronizer.BeginRead;
  try
    Result := (uNotifyAppsQueue.Count > 0);
  finally
    uSynchronizer.EndRead;
  end;
end;

procedure ProcessQueue(ShortTimout: boolean);
var
  msg: String;
  process: boolean;
  AResult: LPDWORD;
  MsgCode, timeout: UINT;
  TypeCode: String;

begin
  if(not QueuePending) then exit;
  uSynchronizer.BeginWrite;
  try
    process := (uNotifyAppsQueue.Count > 0);
    if(process) then
    begin
      msg := uNotifyAppsQueue.Strings[0];
      uNotifyAppsQueue.Delete(0);
    end;
  finally
    uSynchronizer.EndWrite;
  end;
  if(process) then
  begin
    TypeCode := copy(msg,1,1);
    delete(msg,1,1);
    if(TypeCode = MSG_TYPE[mtVistaMessage]) then
      MsgCode := uVistaMsg
    else
      MsgCode := uVistaDomMsg;

    if(ShortTimout) then
      timeout := SHORT_BROADCAST_TIMEOUT
    else
      timeout := LONG_BROADCAST_TIMEOUT;

    // put text in the global atom table
    AnAtom := GlobalAddAtom(PChar(msg));
    if (AnAtom <> 0) then
    begin
      try
        // broadcast 'VistA Domain Event - Clinical' to all main windows
        //SendMessage(HWND_BROADCAST, uVistaDomMsg, WPARAM(Application.MainForm.Handle), LPARAM(AnAtom));
        //
        //Changed to SendMessageTimeout to prevent hang when other app unresponsive  (RV)
        AResult := nil;
{$WARN SYMBOL_DEPRECATED OFF} // researched
{$WARN SYMBOL_PLATFORM OFF}
        if (not Application.Terminated) or (assigned(Application.MainForm) and (TWinControlHack(Application.MainForm).WindowHandle <> 0)) then
          SendMessageTimeout(HWND_BROADCAST, MsgCode, WPARAM(Application.MainForm.Handle), LPARAM(AnAtom),
                SMTO_ABORTIFHUNG or SMTO_BLOCK, timeout, AResult^);
{$WARN SYMBOL_PLATFORM ON}
{$WARN SYMBOL_DEPRECATED ON}
      finally
      // after all windows have processed the message, remove the text from the table
        GlobalDeleteAtom(AnAtom);
        AnAtom := 0;
      end;
    end;
  end;
end;

constructor TNotifyAppsThread.CreateThread;
begin
  inherited Create(TRUE);
  FRunning := TRUE;
end;

procedure TNotifyAppsThread.ResumeIfIdle;
begin
  if(Suspended) then
{$WARN SYMBOL_DEPRECATED OFF} // researched
    Resume;
{$WARN SYMBOL_DEPRECATED ON}
end;

procedure TNotifyAppsThread.ResumeAndTerminate;
begin
  Terminate;
  if(Suspended) then
{$WARN SYMBOL_DEPRECATED OFF} // researched
    Resume;
{$WARN SYMBOL_DEPRECATED ON}
end;

procedure TNotifyAppsThread.Execute;
begin
  while(not Terminated) do
  begin
    if(QueuePending) then
      ProcessQueue(FALSE)
    else if(not Terminated) then
{$WARN SYMBOL_DEPRECATED OFF} // researched
      Suspend;
{$WARN SYMBOL_DEPRECATED ON}
  end;
  FRunning := FALSE;
end;

function AppNotificationEnabled: boolean;
begin
  Result := FALSE;
  if(not uNotifyAppsActive) then exit;
  if Application.MainForm = nil then Exit;
  if User = nil then exit;
  if not User.FNotifyAppsWM then Exit;
  // register the message with windows to get a unique message number (if not already registered)
  if uVistaMsg = 0    then uVistaMsg    := RegisterWindowMessage('VistA Event - Clinical');
  if uVistaDomMsg = 0 then uVistaDomMsg := RegisterWindowMessage('VistA Domain Event - Clinical');
  if (uVistaMsg = 0) or (uVistaDomMsg = 0) then Exit;
  if(not assigned(uNotifyAppsQueue)) then
    uNotifyAppsQueue := TStringList.Create;
  if(not assigned(uSynchronizer)) then
    uSynchronizer := TMultiReadExclusiveWriteSynchronizer.Create;
  if(not assigned(uNotifyAppsThread)) then
    uNotifyAppsThread := TNotifyAppsThread.CreateThread;
  Result := TRUE;
end;

procedure ReleaseAppNotification;
var
  waitState: DWORD;

begin
  uNotifyAppsActive := FALSE;
  if(assigned(uNotifyAppsThread)) then
  begin
    uNotifyAppsThread.ResumeAndTerminate;
    sleep(10);
    if(uNotifyAppsThread.Running) then
    begin
      waitState := WaitForSingleObject(uNotifyAppsThread.Handle, SHORT_BROADCAST_TIMEOUT);
      if((waitState = WAIT_TIMEOUT) or
         (waitState = WAIT_FAILED) or
         (waitState = WAIT_ABANDONED)) then
      begin
        TerminateThread(uNotifyAppsThread.Handle, 0);
        if(AnAtom <> 0) then
        begin
          GlobalDeleteAtom(AnAtom);
          AnAtom := 0;
        end;
      end;
    end;
    FreeAndNil(uNotifyAppsThread);
  end;
  if(assigned(uSynchronizer)) and
    (assigned(uNotifyAppsQueue)) then
  begin
    while(QueuePending) do
      ProcessQueue(TRUE);
  end;
  FreeAndNil(uSynchronizer);
  FreeAndNil(uNotifyAppsQueue);
end;

procedure NotifyOtherApps(const AppEvent, AppData: string);
var
  m1: string;
  m2: string;

begin
  if(AppNotificationEnabled) then
  begin
    // first send the domain version of the message
    m1 := MSG_TYPE[mtVistaDomainMessage] + AppEvent + U + 'CPRS;' + User.FDomain + U + Patient.DFN + U + AppData;
    // for backward compatibility, send the message without the domain
    m2 := MSG_TYPE[mtVistaMessage] + AppEvent + U + 'CPRS' + U + Patient.DFN + U + AppData;
    uSynchronizer.BeginWrite;
    try
      uNotifyAppsQueue.Add(m1);
      uNotifyAppsQueue.Add(m2);
    finally
      uSynchronizer.EndWrite;
    end;
    uNotifyAppsThread.ResumeIfIdle;
  end;
end;

procedure FlushNotifierBuffer;
begin
  if(AppNotificationEnabled) then
  begin
    uSynchronizer.BeginWrite;
    try
      uNotifyAppsQueue.Clear;
    finally
      uSynchronizer.EndWrite;
    end;
  end;
end;

procedure TerminateOtherAppNotification;
begin
  ReleaseAppNotification;
end;

{ TUser methods ---------------------------------------------------------------------------- }

constructor TUser.Create;
{ create the User object for the currently logged in user }
var
  UserInfo: TUserInfo;
begin
  UserInfo := GetUserInfo;
  FDUZ           := UserInfo.DUZ;
  FName          := UserInfo.Name;
  FUserClass     := UserInfo.UserClass;
  FCanSignOrders := UserInfo.CanSignOrders;
  FIsProvider    := UserInfo.IsProvider;
  FOrderRole     := UserInfo.OrderRole;
  FNoOrdering    := UserInfo.NoOrdering;
  FEnableVerify  := UserInfo.EnableVerify;
  FDTIME         := UserInfo.DTIME;
  FCountDown     := UserInfo.CountDown;
  FNotifyAppsWM  := UserInfo.NotifyAppsWM;
  FDomain        := UserInfo.Domain;
  FPtMsgHang     := UserInfo.PtMsgHang;
  FService       := UserInfo.Service;
  FAutoSave      := UserInfo.AutoSave;
  FInitialTab    := UserInfo.InitialTab;
  FUseLastTab    := UserInfo.UseLastTab;
  FActOneStep    := UserInfo.EnableActOneStep;
  FWebAccess     := UserInfo.WebAccess;
  FDisableHold     := UserInfo.DisableHold;
  FIsRPL           := UserInfo.IsRPL;
  FRPLList         := UserInfo.RPLList;
  FHasCorTabs      := UserInfo.HasCorTabs;
  FHasRptTab       := UserInfo.HasRptTab;
  FIsReportsOnly   := UserInfo.IsReportsOnly;
  FToolsRptEdit    := UserInfo.ToolsRptEdit;
  FCurrentPrinter  := GetDefaultPrinter(DUZ, 0);
  FGECStatus       := UserInfo.GECStatusCheck;
  FStationNumber   := UserInfo.StationNumber;
  FIsProductionAccount := UserInfo.IsProductionAccount;
  FJobNumber       := UserInfo.JobNumber;
end;

function TUser.HasKey(const KeyName: string): Boolean;
{ returns true if the current user has the given security key }
begin
  Result := HasSecurityKey(KeyName);
end;

{ TPatient methods ------------------------------------------------------------------------- }

constructor TPatient.Create;
begin
  FMHVData := TStringList.Create;
  FVAAData := TStringList.Create;
end;

destructor TPatient.Destroy;
begin
  FreeAndNil(FCombatVet);
  FreeAndNil(FVAAData);
  FreeAndNil(FMHVData);
  inherited;
end;

procedure TPatient.Clear;
{ clears all fields in the Patient object }
begin
  FDFN          := '';
  FName         := '';
  FSSN          := '';
  FDOB          := 0;
  FAge          := 0;
  FSex          := 'U';
  FCWAD         := '';
  FRestricted   := False;
  FInpatient    := False;
  FStatus       := '';
  FLocation     := 0;
  FWardService  := '';
  FSpecialty    := 0;
  FSpecialtySvc := '';
  FAdmitTime    := 0;
  FSrvConn      := False;
  FSCPercent    := 0;
  FPrimTeam     := '';
  FPrimProv     := '';
  FAttending    := '';
  FMHTC         := '';
  FMHVData.Clear;
  FVAAData.Clear;
  FreeAndNil(FCombatVet);
end;

function TPatient.GetCombatVet: TCombatVet;
begin
  if FCombatVet = nil then
    FCombatVet := TCombatVet.Create(FDFN);
  Result := FCombatVet;
end;

function TPatient.GetDateDied: TFMDateTime;
begin
  if(not FDateDiedLoaded) then
  begin
    FDateDied := DateOfDeath(FDFN);
    FDateDiedLoaded := TRUE;
  end;
  Result := FDateDied;
end;

function TPatient.GetPtIsMHV: Boolean;
begin
  if FMHVData.Count = 0 then
    RefreshMHVStatus;
  if FMHVData.Count > 0 then
    Result := FMHVData[0] <> '0'
  else
    Result := False;
end;

function TPatient.GetPtIsVAA: Boolean;
begin
  if FVAAData.Count = 0 then
    RefreshVAAStatus;
  if FVAAData.Count > 0 then
    Result := FVAAData[0] <> '0'
  else
    Result := False;
end;

procedure TPatient.GetVAAInformation(var aSubscriberName: string; aReportText: TStrings);
begin
  if GetPtIsVAA then
    try
      aSubscriberName := Piece(FVAAData[12], ':', 1) + ': ' + Trim(Piece(FVAAData[12], ':', 2));
      aReportText.Text := FVAAData.Text;
      aReportText.Delete(0);
    except
      aSubscriberName := 'Error in VAA information';
      aReportText.Clear;
    end
  else
    begin
      aSubscriberName := '';
      aReportText.Clear;
    end;
end;

procedure TPatient.RefreshMHVStatus;
begin
  GetMHVData(FDFN, FMHVData);
end;

procedure TPatient.RefreshVAAStatus;
begin
  GetVAAData(FDFN, FVAAData);
end;

procedure TPatient.SetDFN(const Value: string);  //*DFN*
{ selects a patient and sets up the Patient object for the patient }
var
  PtSelect: TPtSelect;
begin
  if (Value = FDFN) then Exit;  //*DFN*
  Clear;
  if Value = '' then
    exit;
  SelectPatient(Value, PtSelect);
  FDFN        := Value;
  FName       := PtSelect.Name;
  FICN        := PtSelect.ICN;
  FFullICN    := PtSelect.FullICN;
  FSSN        := PtSelect.SSN;
  FDOB        := PtSelect.DOB;
  FAge        := PtSelect.Age;
  FSigi       := PtSelect.SIGI;
  FPronoun    := PtSelect.Pronoun;
  FSex        := PtSelect.Sex;
  FCWAD       := PtSelect.CWAD;
  FRestricted := PtSelect.Restricted;
  FInpatient  := Length(PtSelect.Location) > 0;
  if FInpatient then FStatus := ' (INPATIENT)'
  else FStatus := ' (OUTPATIENT)';
  FWardService := PtSelect.WardService;
  FLocation   := PtSelect.LocationIEN;
  FSpecialty  := PtSelect.SpecialtyIEN;
  FSpecialtySvc := PtSelect.SpecialtySvc;
  FAdmitTime  := PtSelect.AdmitTime;
  FSrvConn    := PtSelect.ServiceConnected;
  FSCPercent  := PtSelect.SCPercent;
  FPrimTeam   := PtSelect.PrimaryTeam;
  FPrimProv   := PtSelect.PrimaryProvider;
  FAttending  := PtSelect.Attending;
  FAssociate  := PtSelect.Associate;
  FInProvider := PtSelect.InProvider;
  FMHTC       := PtSelect.MHTC;
  RefreshVAAStatus;
  RefreshMHVStatus;
end;

{ TEncounter ------------------------------------------------------------------------------- }

constructor TEncounter.Create;
begin
  inherited;
  FNotifier := TORNotifier.Create(Self, TRUE);
  ICD10ImplDate := GetICD10ImplementationDate;
end;

destructor TEncounter.Destroy;
begin
  FreeAndNil(FNotifier);
  inherited;
end;

procedure TEncounter.EncounterSwitch(Loc: integer; LocName, LocText: string; DT: TFMDateTime; vCat: Char);
begin
 Encounter.Location := Loc;
 Encounter.LocationName := LocName;
 Encounter.LocationText := LocText;
 Encounter.VisitCategory := vCat;
 Encounter.DateTime := DT;;
end;

procedure TEncounter.CreateSaved(Reason: string);
begin
    SavedEncounterLoc := Encounter.Location;
    SavedEncounterLocName := Encounter.LocationName;
    SavedEncounterText := Encounter.LocationText;
    SavedEncounterDateTime := Encounter.DateTime;
    SavedEncounterVisitCat := Encounter.VisitCategory;
    SavedEncounterReason := Reason;
end;

procedure TEncounter.EmptySaved();
begin
  SavedEncounterLoc := 0;
  SavedEncounterLocName := '';
  SavedEncounterText := '';
  SavedEncounterDateTime := 0;
  SavedEncounterVisitCat := #0;
  SavedEncounterReason := '';
end;

procedure TEncounter.SwitchToSaved(ShowInfoBox: boolean);
begin
  if SavedEncounterLoc > 0 then
  begin
    if ShowInfoBox then InfoBox(SavedEncounterReason, 'Notice', MB_OK or MB_ICONWARNING);
    EncounterSwitch(SavedEncounterLoc, SavedEncounterLocName, SavedEncounterText, SavedEncounterDateTime, SavedEncounterVisitCat);
    EmptySaved();
  end;
end;

procedure TEncounter.Clear;
{ clears all the fields of an Encounter (usually done upon patient selection }
begin
  FChanged      := False;
  FDateTime     := 0;
//  FInpatient    := False;
  FLocationName := '';
  FLocationText := '';
  FProvider     := 0;
  FProviderName := '';
  FStandAlone   := False;
  FVisitCategory := #0;
  SetLocation(0); // Used to call Notifications - do it last so everything else is set
end;

function TEncounter.GetLocationText: string;
{ returns abbreviated hospital location + room/bed (or date/time for appt) }
begin
  if FChanged then UpdateText;
  Result := FLocationText;
end;

function TEncounter.GetLocationName: string;
{ returns external text value for hospital location }
begin
  if FChanged then UpdateText;
  Result := FLocationName;
end;

function TEncounter.GetProviderName: string;
{ returns external text value for provider name }
begin
  if FChanged then UpdateText;
  Result := FProviderName;
end;

function TEncounter.GetVisitCategory: Char;
begin
  Result := FVisitCategory;
  if Result = #0 then Result := 'A';
end;

function TEncounter.GetVisitStr: string;
begin
  Result :=  IntToStr(FLocation) + ';' + FloatToStr(FDateTime) + ';' + VisitCategory;
  // use VisitCategory property to insure non-null character
end;

function TEncounter.GetICDVersion: String;
var
  cd: TFMDateTime;  //compare date
begin
  // if no Enc Dt or Historical, Hospitalization, or Daily Visit compare I-10 Impl dt with TODAY
  if (FDateTime <= 0) or (FVisitCategory = 'E') or (FVisitCategory = 'H') then
    cd := FMNow
  else // otherwise compare I-10 Impl dt with Encounter date/time
    cd := FDateTime;

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

function TEncounter.NeedVisit: Boolean;
{ returns true if required fields for visit creation are present }
begin
  // added "<" to FDateTime check to trap "-1" visit dates - v23.12 (RV)
  if (FDateTime <= 0) or (FLocation = 0) then Result := True else Result := False;
end;

procedure TEncounter.SetDateTime(Value: TFMDateTime);
{ sets the date/time for the encounter - causes the visit to be reset }
begin
  if Value <> FDateTime then
  begin
    FDateTime := Value;
    FChanged := True;
  end;
end;

function TEncounter.GetInpatient: Boolean;
{ sets the inpatient flag for the encounter - causes the visit to be reset }
begin
  Result := (FVisitCategory = 'H');
end;

procedure TEncounter.SetInpatient(Value: Boolean);
{ sets the inpatient flag for the encounter - causes the visit to be reset }
begin
  if Value <> GetInpatient then
  begin
//    FInpatient := Value;
    FChanged := True;
  end;
end;

procedure TEncounter.SetLocation(Value: Integer);
{ sets the location for the encounter - causes the visit to be reset }
begin
  if Value <> FLocation then
  begin
    FLocation := Value;
    FChanged := True;
    FNotifier.Notify(Self);
  end;
end;

procedure TEncounter.SetProvider(Value: Int64);
{ sets the provider for the encounter - causes the visit to be reset }
begin
  if Value <> FProvider then
  begin
    FProvider := Value;
    FChanged := True;
  end;
end;

procedure TEncounter.SetStandAlone(Value: Boolean);
{ StandAlone should be true if this encounter isn't related to an appointment }
begin
  if Value <> FStandAlone then
  begin
    FStandAlone := Value;
    FChanged := True;
  end;
end;

procedure TEncounter.SetVisitCategory(Value: Char);
{ sets the visit type for this encounter - causes to visit to be reset }
begin
  if Value <> FVisitCategory then
  begin
    FVisitCategory := Value;
    FChanged := True;
  end;
end;

procedure TEncounter.UpdateText;
{ retrieve external values for provider name, hospital location }
var
  EncounterText: TEncounterText;
begin
  { this references the Patient object which is assumed to be created }
  EncounterText := GetEncounterText(Patient.DFN, FLocation, FProvider);
  with EncounterText do
  begin
    FLocationName := LocationName;
    if Length(LocationAbbr) > 0
      then FLocationText := LocationAbbr
      else FLocationText := LocationName;
    if Length(LocationName) > 0 then
    begin
      if (FVisitCategory = 'H') //FInpatient
        then FLocationText := FLocationText + ' ' + RoomBed
        else FLocationText := FLocationText + ' ' +
          FormatFMDateTime('mmm dd,yy hh:nn', FDateTime);
    end
    else FLocationText := '';
    if Length(ProviderName) > 0  // ProviderName is the field in EncounterText
      then FProviderName := ProviderName
      else FProviderName := '';
  end;
  FChanged := False;
end;


{ TChangeItem ------------------------------------------------------------------------------ }

constructor TChangeItem.Create(AnItemType: Integer;
  const AnID, AText, AGroupName: string; ASignState: Integer;
  AWriteAccessType: TWriteAccessType = waNone; AParentID: string = '';
  User: Int64 = 0; AOrderDGIEN: Integer = 0; OrderDG: string = '';
  DCOrder: Boolean = False; Delay: Boolean = False);
begin
  FItemType  := AnItemType;
  FID        := AnID;
  FText      := AText;
  FGroupName := AGroupName;
  FSignState := ASignState;
  FWriteAccessType := AWriteAccessType;
  FParentID  := AParentID;
  FUser      := User;
  FOrderDGIEN := AOrderDGIEN;
  FOrderDG   := OrderDG;
  FDCOrder   := DCOrder;
  FDelay     := Delay;
end;

function TChangeItem.CSValue(): boolean;
var
  ret: string;
begin
  CallVistA('ORDEA CSVALUE', [FID], ret);
  if ret = '1' then Result :=  True
  else Result := False;
end;

{ TChanges --------------------------------------------------------------------------------- }

constructor TChanges.Create;
begin
  FDocuments          := TList.Create;
  FOrders             := TList.Create;
  FPCE                := TList.Create;
  FOrderGrp           := TStringList.Create;
  FPCEGrp             := TStringList.Create;
  FCount              := 0;
  FRefreshCoverPL     := False;
  FRefreshProblemList := False;
end;

destructor TChanges.Destroy;
begin
  Clear;
  FDocuments.Free;
  FOrders.Free;
  FPCE.Free;
  FOrderGrp.Free;
  FPCEGrp.Free;
  inherited Destroy;
end;

procedure TChanges.Add(ItemType: Integer;
  const AnID, ItemText, GroupName: string; SignState: Integer;
  AWriteAccessType: TWriteAccessType = waNone; AParentID: string = '';
  User: Int64 = 0; AOrderDGIEN: Integer = 0; OrderDG: String = '';
  DCOrder: Boolean = False; Delay: Boolean = False;
  ProblemAdded: Boolean = False);
var
  i: Integer;
  Found: Boolean;
  ChangeList: TList;
  NewChangeItem: TChangeItem;

begin
  ChangeList := nil;
  case ItemType of
    CH_DOC: ChangeList := FDocuments;
    CH_SUM: ChangeList := FDocuments;  {*REV*}
    CH_CON: ChangeList := FDocuments;
    CH_SUR: ChangeList := FDocuments;
    CH_ORD: ChangeList := FOrders;
    CH_PCE: ChangeList := FPCE;
  end;
  if ChangeList <> nil then
  begin
    if AWriteAccessType = waNone then
      case ItemType of
        CH_DOC: AWriteAccessType := waProgressNotes;
        CH_SUM: AWriteAccessType := waDCSumm;
        CH_CON: AWriteAccessType := waConsults;
        CH_SUR: AWriteAccessType := waSurgery;
        CH_ORD: AWriteAccessType := waOrders;
      end;
    FRefreshCoverPL := ProblemAdded;
    FRefreshProblemList := ProblemAdded;
    Found := False;
    with ChangeList do for i := 0 to Count - 1 do
      with TChangeItem(Items[i]) do if ID = AnID then
      begin
        Found := True;
        // can't change ItemType, ID, or GroupName, must call Remove first
        FText := ItemText;
        FSignState := SignState;
      end;
    if not Found then
    begin
      NewChangeItem := TChangeItem.Create(ItemType, AnID, ItemText, GroupName,
        SignState, AWriteAccessType, AParentID, User, AOrderDGIEN, OrderDG,
        DCOrder, Delay);
      ChangeList.Add(NewChangeItem);
      case ItemType of
        CH_ORD: begin
                  with FOrderGrp do if IndexOf(GroupName) < 0 then Add(GroupName);
                end;
        CH_PCE: begin
                  with FPCEGrp do if IndexOf(GroupName) < 0 then Add(GroupName);
                end;
      end;
      Inc(FCount);
    end;
  end;
end;

function TChanges.CanSign: Boolean;
{ returns true if any items in the changes list can be signed by the user }
var
  i: Integer;
begin
  Result := False;
  with FDocuments do for i := 0 to Count - 1 do
    with TChangeItem(Items[i]) do if FSignState <> CH_SIGN_NA then
    begin
      Result := True;
      Exit;
    end;
  with FOrders do for i := 0 to Count - 1 do
    with TChangeItem(Items[i]) do if FSignState <> CH_SIGN_NA then
    begin
      Result := True;
      Exit;
    end;
  // don't have to worry about FPCE - it never requires signatures
end;

procedure TChanges.Clear;
var
  i, ConsultIEN: Integer;
  DocIEN: Int64;
  OrderID: string;
begin
  with FDocuments do for i := 0 to Count - 1 do
    begin
      DocIEN := StrToInt64Def(TChangeItem(Items[i]).ID, 0);
      UnlockDocument(DocIEN);
      ConsultIEN := GetConsultIENforNote(DocIEN);
      if ConsultIEN > -1 then
        begin
          OrderID := GetConsultOrderIEN(ConsultIEN);
          UnlockOrderIfAble(OrderID);
        end;
      TChangeItem(Items[i]).Free;
    end;
  with FOrders do for i := 0 to Count - 1 do TChangeItem(Items[i]).Free;
  with FPCE do for i := 0 to Count - 1 do TChangeItem(Items[i]).Free;
  FDocuments.Clear;
  FOrders.Clear;
  FPCE.Clear;
  FOrderGrp.Clear;
  FPCEGrp.Clear;
  FCount := 0;
end;

function TChanges.Exist(ItemType: Integer; const AnID: string): Boolean;
var
  ChangeList: TList;
  i: Integer;
begin
  Result := False;
  ChangeList := nil;
  case ItemType of
  CH_DOC: ChangeList := FDocuments;
  CH_SUM: ChangeList := FDocuments;   {*REV*}
  CH_CON: ChangeList := FDocuments;
  CH_SUR: ChangeList := FDocuments;
  CH_ORD: ChangeList := FOrders;
  CH_PCE: ChangeList := FPCE;
  end;
  if ChangeList <> nil then with ChangeList do
    for i := 0 to Count - 1 do if TChangeItem(Items[i]).ID = AnID then
    begin
      Result := True;
      Break;
    end;
end;

function TChanges.ExistForOrder(const AnID: string): Boolean;
{ returns TRUE if any item in the list of orders has matching order number (ignores action) }
var
  i: Integer;
begin
  Result := False;
  if FOrders <> nil then with FOrders do
    for i := 0 to Count - 1 do
      if Piece(TChangeItem(Items[i]).ID, ';', 1) = Piece(AnID, ';', 1) then
      begin
        Result := True;
        Break;
      end;
end;

function TChanges.Locate(ItemType: Integer; const AnID: string): TChangeItem;
var
  ChangeList: TList;
  i: Integer;
begin
  Result := nil;
  ChangeList := nil;
  case ItemType of
  CH_DOC: ChangeList := FDocuments;
  CH_SUM: ChangeList := FDocuments;   {*REV*}
  CH_CON: ChangeList := FDocuments;
  CH_SUR: ChangeList := FDocuments;
  CH_ORD: ChangeList := FOrders;
  CH_PCE: ChangeList := FPCE;
  end;
  if ChangeList <> nil then with ChangeList do
    for i := 0 to Count - 1 do if TChangeItem(Items[i]).ID = AnID then
    begin
      Result := TChangeItem(Items[i]);
      Break;
    end;
end;

procedure TChanges.Remove(ItemType: Integer; const AnID: string);
{ remove a change item from the appropriate list of changes (depending on type)
  this doesn't check groupnames, may leave a groupname without any associated items }
var
  ChangeList: TList;
  i,j: Integer;
  needRemove: boolean;
begin
  ChangeList := nil;
  case ItemType of
  CH_DOC: ChangeList := FDocuments;
  CH_SUM: ChangeList := FDocuments;
  CH_CON: ChangeList := FDocuments;
  CH_SUR: ChangeList := FDocuments;
  CH_ORD: ChangeList := FOrders;
  CH_PCE: ChangeList := FPCE;
  end;
  if ChangeList <> nil then with ChangeList do
    for i := Count - 1 downto 0 do if TChangeItem(Items[i]).ID = AnID then
    begin
      if Assigned(FOnRemove) then FOnRemove(Self, TChangeItem(Items[i]))    {**RV**}
        else TChangeItem(Items[i]).Free;                                    {**RV**}
      //TChangeItem(Items[i]).Free;                                         {**RV**}
      // set TChangeItem(Items[i]) = nil?
      Delete(i);
      Dec(FCount);
    end;
  if ItemType = CH_ORD then
  begin
    for i := OrderGrp.Count - 1 downto 0 do
    begin
      needRemove := True;
      for j := 0 to FOrders.Count - 1 do
        if (AnsiCompareText(TChangeItem(FOrders[j]).GroupName,OrderGrp[i]) = 0 ) then
          needRemove := False;
      if needRemove then
        OrderGrp.Delete(i);
    end;
  end;
  if ItemType = CH_ORD then UnlockOrder(AnID);
  if ItemType = CH_DOC then UnlockDocument(StrToIntDef(AnID, 0));
  if ItemType = CH_CON then UnlockDocument(StrToIntDef(AnID, 0));
  if ItemType = CH_SUM then UnlockDocument(StrToIntDef(AnID, 0));
  if ItemType = CH_SUR then UnlockDocument(StrToIntDef(AnID, 0));
end;

procedure TChanges.ReplaceID(ItemType: Integer; const OldID, NewID: string);
var
  ChangeList: TList;
  i: Integer;
begin
  ChangeList := nil;
  case ItemType of
  CH_DOC: ChangeList := FDocuments;
  CH_SUM: ChangeList := FDocuments;   {*REV*}
  CH_CON: ChangeList := FDocuments;
  CH_SUR: ChangeList := FDocuments;
  CH_ORD: ChangeList := FOrders;
  CH_PCE: ChangeList := FPCE;
  end;
  if ChangeList <> nil then with ChangeList do
    for i := 0 to Count - 1 do if TChangeItem(Items[i]).ID = OldID then
    begin
      TChangeItem(Items[i]).FID := NewID;
    end;
end;

procedure TChanges.ReplaceSignState(ItemType: Integer; const AnID: string; NewState: Integer);
var
  ChangeList: TList;
  i: Integer;
begin
  ChangeList := nil;
  case ItemType of
  CH_DOC: ChangeList := FDocuments;
  CH_SUM: ChangeList := FDocuments;   {*REV*}
  CH_CON: ChangeList := FDocuments;
  CH_SUR: ChangeList := FDocuments;
  CH_ORD: ChangeList := FOrders;
  CH_PCE: ChangeList := FPCE;
  end;
  if ChangeList <> nil then with ChangeList do
    for i := 0 to Count - 1 do if TChangeItem(Items[i]).ID = AnID then
    begin
      TChangeItem(Items[i]).FSignState := NewState;
    end;
end;

procedure TChanges.ReplaceText(ItemType: Integer; const AnID, NewText: string);
var
  ChangeList: TList;
  i: Integer;
begin
  ChangeList := nil;
  case ItemType of
  CH_DOC: ChangeList := FDocuments;
  CH_SUM: ChangeList := FDocuments;   {*REV*}
  CH_CON: ChangeList := FDocuments;
  CH_SUR: ChangeList := FDocuments;
  CH_ORD: ChangeList := FOrders;
  CH_PCE: ChangeList := FPCE;
  end;
  if ChangeList <> nil then with ChangeList do
    for i := 0 to Count - 1 do if TChangeItem(Items[i]).ID = AnID then
    begin
      TChangeItem(Items[i]).FText := NewText;
    end;
end;

function TChanges.RequireReview: Boolean;
{ returns true if documents can be signed or if any orders exist in Changes }
var
  i: Integer;
begin
  Result := False;
  AddUnsignedToChanges;
  if FOrders.Count > 0 then Result := True;
  if Result = False then with FDocuments do for i := 0 to Count - 1 do
    with TChangeItem(Items[i]) do if FSignState <> CH_SIGN_NA then
    begin
      Result := True;
      Break;
    end;
end;

procedure TChanges.AddUnsignedToChanges;
{ retrieves unsigned orders outside this session based on OR UNSIGNED ORDERS ON EXIT }
var
  i, CanSign, DisplayGroup (*, OrderUser*): Integer;
  OrderUser: int64;
  AnID, Display: string;
  HaveOrders, OtherOrders: TStringList;
  AChangeItem: TChangeItem;
  IsDiscontinue, IsDelay: boolean;
begin
  if Patient.DFN = '' then Exit;
  // exit if there is already an 'Other Unsigned' group?
  HaveOrders  := TStringList.Create;
  OtherOrders := TStringList.Create;
  try
    StatusText('Looking for unsigned orders...');
    for i := 0 to Pred(FOrders.Count) do
    begin
      AChangeItem := FOrders[i];
      HaveOrders.Add(AChangeItem.ID);
    end;
    LoadUnsignedOrders(OtherOrders, HaveOrders);
    if (Encounter.Provider = User.DUZ) and User.CanSignOrders
      then CanSign := CH_SIGN_YES
      else CanSign := CH_SIGN_NA;
    for i := 0 to Pred(OtherOrders.Count) do
    begin
      AnID := Piece(OtherOrders[i],U,1);
      if Piece(OtherOrders[i],U,2) = '' then OrderUser := 0
      else OrderUser := StrtoInt64(Piece(OtherOrders[i],U,2));
      //agp change the M code to pass back the value for the new order properties
      Display := Piece(OtherOrders[i],U,3);
      DisplayGroup := StrToIntDef(Piece(OtherOrders[i], U, 8), 0);
      if Piece(OtherOrders[i],U,4) = '1' then  IsDiscontinue := True
      else IsDiscontinue := False;
      if Piece(OtherOrders[i],U,5) = '1' then  IsDelay := True
      else IsDelay := False;
      Add(CH_ORD, AnID, TextForOrder(AnID), 'Other Unsigned', CanSign, waOrders,
        '', OrderUser, DisplayGroup, Display, IsDiscontinue, IsDelay);
    end;
  finally
    StatusText('');
    HaveOrders.Free;
    OtherOrders.Free;
  end;
end;

{ TNotifications ---------------------------------------------------------------------------- }

constructor TNotifications.Create;
begin
  FList := TList.Create;
  FCurrentIndex := -1;
  FActive := False;
  FNotifIndOrders := False;
end;

destructor TNotifications.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TNotifications.Add(const ADFN: string; AFollowUp: Integer; const ARecordID: string;
            AHighLightSection : string; AData : TStringList; AProcessing: boolean = true);
var
  NotifyItem: TNotifyItem;
begin
  NotifyItem := TNotifyItem.Create;
  NotifyItem.DFN := ADFN;
  NotifyItem.FollowUp := AFollowUp;
  NotifyItem.RecordID := ARecordId;
  NotifyItem.Data := TStringList.Create;
  NotifyItem.Processing := AProcessing;
//  AData.Assign(NotifyItem.Data);
  NotifyItem.Data.Assign(AData);

  If AHighLightSection <> '' then NotifyItem.HighLightSection := AHighLightSection;
  FList.Add(NotifyItem);
  FActive := True;
end;

procedure TNotifications.Clear;
var
  i: Integer;
begin
  with FList do for i := 0 to Count - 1 do with TNotifyItem(Items[i]) do
  begin
    TNotifyItem(Items[i]).Data.Free;
    Free;
  end;
  FList.Clear;
  FActive := False;
  FCurrentIndex := -1;
  FNotifyItem := nil;
  FNotifIndOrders := False;
end;

function TNotifications.GetDFN: string;  //*DFN*
begin
  if FNotifyItem <> nil then Result := FNotifyItem.DFN else Result := '';  //*DFN*
end;

function TNotifications.GetFollowUp: Integer;
begin
  if FNotifyItem <> nil then Result := FNotifyItem.FollowUp else Result := 0;
end;

function TNotifications.GetAlertData: string;
var
  x: string;
begin
  if FNotifyItem <> nil then
  begin
    if FNotifyItem.Processing then
      x := ''
    else
      x := '1';
    Result := GetXQAData(Piece(FNotifyItem.RecordID, U, 2), x);
  end
  else
    Result := '';
end;

function TNotifications.GetRecordID: string;
begin
  if FNotifyItem <> nil then Result := FNotifyItem.RecordID else Result := '';
end;

function TNotifications.GetText: string;
begin
  if FNotifyItem <> nil
    then Result := Piece(Piece(FNotifyItem.RecordID, U, 1 ), ':', 2)
    else Result := '';
end;

function TNotifications.IsLast: boolean;
begin
  Result := (FCurrentIndex = FList.Count - 1);
end;

function TNotifications.GetData: TStringList;
begin
  if FNotifyItem <> nil then Result := FNotifyItem.Data else Result := nil;
end;

function TNotifications.GetHighLightSection: String; //CB
begin
  if FNotifyItem <> nil then Result := FNotifyItem.HighLightSection else Result := '';
end;

function TNotifications.GetIndOrderDisplay: Boolean;
begin
  Result := FNotifIndOrders;
end;

function TNotifications.GetProcessing: boolean;
begin
  if FNotifyItem <> nil then Result := FNotifyItem.Processing else Result := False;
end;

procedure TNotifications.SetIndOrderDisplay(Value: Boolean);
begin
  FNotifIndOrders := Value;
end;

procedure TNotifications.Next;
begin
  Inc(FCurrentIndex);
  if FCurrentIndex < FList.Count then FNotifyItem := TNotifyItem(FList[FCurrentIndex]) else
  begin
    FActive := False;
    FNotifyItem := nil;
  end;
end;

procedure TNotifications.Prior;
begin
  Dec(FCurrentIndex);
  if FCurrentIndex < 0
    then FNotifyItem := nil
    else FNotifyItem := TNotifyItem(FList[FCurrentIndex]);
  if FList.Count > 0 then FActive := True;
end;

procedure TNotifications.Delete;
begin
  if FNotifyItem <> nil then DeleteAlert(Piece(FNotifyItem.RecordID, U, 2));
end;

procedure TNotifications.DeleteForCurrentUser;
begin
  if FNotifyItem <> nil then DeleteAlertForUser(Piece(FNotifyItem.RecordID, U, 2));
end;

{ TRemoteSite methods ---------------------------------------------------------------------------- }

constructor TRemoteSite.Create(ASite: string);
begin
  FSiteID   := Piece(ASite, U, 1);
  FSiteName := VariableMixedCase(Piece(ASite, U, 2));
  FLastDate := StrToFMDateTime(Piece(ASite, U, 3));
  FSelected := False;
  FQueryStatus := '';
  FData := TStringList.Create;
  FLabQueryStatus := '';
  FLabData := TStringList.Create;
  FCurrentLabQuery := '';
  FCurrentReportQuery := '';
end;

destructor TRemoteSite.Destroy;
begin
  LabClear;
  ReportClear;
  FData.Free;
  FLabData.Free;
  inherited Destroy;
end;

procedure TRemoteSite.ReportClear;
begin
  FData.Clear;
  FQueryStatus := '';
end;

procedure TRemoteSite.LabClear;
begin
  FLabData.Clear;
  FLabQueryStatus := '';
end;

procedure TRemoteSite.SetSelected(Value: boolean);
begin
  FSelected := Value;
end;

constructor TRemoteReport.Create(AReport: string);
begin
  FReport   := AReport;
  FHandle := '';
end;

destructor TRemoteReport.Destroy;
begin
  inherited Destroy;
end;

constructor TRemoteReportList.Create;
begin
  FReportList := TList.Create;
  FCount := 0;
end;

destructor TRemoteReportList.Destroy;
begin
  //Clear;
  FReportList.Free;
  inherited Destroy;
end;

procedure TRemoteReportList.Add(AReportList, AHandle: string);
var
  ARemoteReport: TRemoteReport;
begin
  ARemoteReport := TRemoteReport.Create(AReportList);
  ARemoteReport.Handle := AHandle;
  ARemoteReport.Report := AReportList;
  FReportList.Add(ARemoteReport);
  FCount := FReportList.Count;
end;

procedure TRemoteReportList.Clear;
var
  i: Integer;
begin
  with FReportList do
    for i := 0 to Count - 1 do
      with TRemoteReport(Items[i]) do Free;
  FReportList.Clear;
  FCount := 0;
end;

constructor TRemoteSiteList.Create;
begin
  FSiteList := TList.Create;
  FCount := 0;
end;

destructor TRemoteSiteList.Destroy;
begin
  Clear;
  FSiteList.Free;
  inherited Destroy;
end;

procedure TRemoteSiteList.Add(ASite: string);
var
  ARemoteSite: TRemoteSite;
begin
  ARemoteSite := TRemoteSite.Create(ASite);
  FSiteList.Add(ARemoteSite);
  FCount := FSiteList.Count;
end;

procedure TRemoteSiteList.Clear;
var
  i: Integer;
begin
  with FSiteList do for i := 0 to Count - 1 do with TRemoteSite(Items[i]) do Free;
  FSiteList.Clear;
  FCount := 0;
end;

procedure TRemoteSiteList.ChangePatient(const DFN: string);
var
  ALocations: TStringList;
  i: integer;
begin
  Clear;
  ALocations := TStringList.Create;
  try
    FRemoteDataExists := HasRemoteData(DFN, ALocations);
    if FRemoteDataExists then
      begin
        SortByPiece(ALocations, '^', 2);
        for i := 0 to ALocations.Count - 1 do
          if piece(ALocations[i],'^',5) = '1' then
            Add(ALocations.Strings[i]);
        FNoDataReason := '';
      end
    else if ALocations.Count > 0 then
      FNoDataReason := Piece(ALocations[0], U, 2)
    else
      FNoDataReason := '';
    FCount := FSiteList.Count;
  finally
    ALocations.Free;
  end;
end;

procedure TUser.SetCurrentPrinter(Value: string);
begin
  FCurrentPrinter := Value;
end;

procedure GotoWebPage(const URL: WideString);
begin
  ShellExecute(HInstance, 'open', PChar(url), nil, nil, SW_NORMAL);
end;

function subtractMinutesFromDateTime(Time1 : TDateTime;Minutes : extended) : TDateTime;
var
  TimeMinutes : TDateTime;
const
  MinutesPerDay = 60 * 24;
begin
  TimeMinutes := Minutes / MinutesPerDay;
  result := time1 - TimeMinutes;
end;

procedure TChanges.ReplaceODGrpName(const AnODID, NewGrp: string);
var
  ChangeList: TList;
  i: Integer;
begin
  ChangeList := FOrders;
  if ChangeList <> nil then with ChangeList do
    for i := 0 to Count - 1 do if TChangeItem(Items[i]).ID = AnODID then
      TChangeItem(Items[i]).FGroupName := NewGrp;
end;

procedure TChanges.ChangeOrderGrp(const oldGrpName,newGrpName: string);
var
  i : integer;
begin
  for i := 0 to FOrderGrp.Count - 1 do
  begin
    if AnsiCompareText(FOrderGrp[i],oldGrpName)= 0 then
      FOrderGrp[i] := newGrpName;
  end;
end;

var
  GlobalSystemParameters: TORJSONParameters;

function SystemParameters: TORJSONParameters;
// Just In Time creation of SystemParameters.
// A small potential memory leak is solved with this fix, as well as the need
// to check for Assigned every time you try and use it.
begin
  if not Assigned(GlobalSystemParameters) then
  begin
    if not Assigned(User) then raise Exception.Create('User not assigned.');
    GlobalSystemParameters := CreateSysUserParameters(User.DUZ);
  end;
  Result := GlobalSystemParameters;
end;

procedure ClearSystemParameters;
begin
  FreeAndNil(GlobalSystemParameters);
end;

var
  EHRActiveStatus: Integer = 0;

function EHRActive: boolean;
var
  Value: integer;
begin
  if EHRActiveStatus = 0 then
  begin
    CallVista('ORACCESS EHRACTIVE', [], Value);
    EHRActiveStatus := Value + 1;
  end;
  Result := (EHRActiveStatus = 2);
end;

initialization
  uVistaMsg := 0;

finalization
  ReleaseAppNotification;
  ClearSystemParameters;
end.
