unit uReminders;

interface

uses
  ORExtensions,
  Windows, Messages, Classes, Controls, StdCtrls, SysUtils, ComCtrls, Menus,
  Graphics, Forms, ORClasses, ORCtrls, ORDtTm, ORFn, ORNet, Dialogs, uPCE,
  uVitals, System.Generics.Collections, uComponentNexus,
  ExtCtrls, fDrawers, fDeviceSelect, TypInfo, StrUtils, fRptBox, fVimm, rVimm;

type
  TReminderDialog = class(TObject)
  private
    FDlgData: string;
    FElements: TStringList; // list of TRemDlgElement objects
    FOnNeedRedraw: TNotifyEvent;
    FNeedRedrawCount: integer;
    FOnTextChanged: TNotifyEvent;
    FTextChangedCount: integer;
    FPCEDataObj: TPCEData;
    FNoResolve: boolean;
    FWHReviewIEN: string;
    // AGP CHANGE 23.13 Allow for multiple processing of WH Review of Result Reminders
    FRemWipe: integer;
    FMHTestArray: TORStringList;
    FPromptsDefaults: TStringList;
  protected
    linkSeqList: TStrings;
    linkSeqListChecked: TStrings;
    function GetIEN: string; virtual;
    function GetPrintName: string; virtual;
    procedure BeginNeedRedraw;
    procedure EndNeedRedraw(Sender: TObject);
    procedure BeginTextChanged;
    procedure EndTextChanged(Sender: TObject);
    function GetDlgSL(Purge: Boolean = True): TORStringList;
    procedure ComboBoxResized(Sender: TObject);
    procedure ComboBoxCheckedText(Sender: TObject; NumChecked: integer;
      var Text: string);
    function AddData(Lst: TStrings; Finishing: boolean = FALSE;
      Historical: boolean = FALSE): integer;
    function Visible: boolean;
    procedure findLinkItem(elementList, promptList: TStringList; startSeq: String);
    procedure DoFocus(Ctrl: TWinControl);
  public
    constructor BaseCreate;
    constructor Create(ADlgData: string);
    destructor Destroy; override;
    procedure FinishProblems(List: TStrings;
      var MissingTemplateFields: boolean);
    function BuildControls(ParentWidth: integer; AParent, AOwner: TWinControl;
      BuildAll: boolean): TWinControl;
    function Processing: boolean;
    procedure AddText(Lst: TStrings);
    procedure closeReportView;
    property PrintName: string read GetPrintName;
    property IEN: string read GetIEN;
    property Elements: TStringList read FElements;
    property OnNeedRedraw: TNotifyEvent read FOnNeedRedraw write FOnNeedRedraw;
    property OnTextChanged: TNotifyEvent read FOnTextChanged
      write FOnTextChanged;
    property PCEDataObj: TPCEData read FPCEDataObj write FPCEDataObj;
    property DlgData: string read FDlgData; // AGP Change 24.8
    property WHReviewIEN: string read FWHReviewIEN write FWHReviewIEN;
    // AGP CHANGE 23.13
    property RemWipe: integer read FRemWipe write FRemWipe;
    property MHTestArray: TORStringList read FMHTestArray write FMHTestArray;

  end;

  TReminder = class(TReminderDialog)
  private
    FRemData: string;
    FCurNodeID: string;
  protected
    function GetDueDateStr: string;
    function GetLastDateStr: string;
    function GetIEN: string; override;
    function GetPrintName: string; override;
    function GetPriority: integer;
    function GetStatus: string;
  public
    constructor Create(ARemData: string);
    property DueDateStr: string read GetDueDateStr;
    property LastDateStr: string read GetLastDateStr;
    property Priority: integer read GetPriority;
    property Status: string read GetStatus;
    property RemData: string read FRemData;
    property CurrentNodeID: string read FCurNodeID write FCurNodeID;
  end;

  TRDChildReq = (crNone, crOne, crAtLeastOne, crNoneOrOne, crAll);
  TRDElemType = (etCheckBox, etTaxonomy, etDisplayOnly, etChecked, etDisable);

  TRemPrompt = class;

  TRemDlgElement = class(TObject)
  private
    FReminder: TReminderDialog;
    FParent: TRemDlgElement;
    FChildren: TList; // Points to other TRemDlgElement objects
    FData: TList; // List of TRemData objects
    FPrompts: TList; // list of TRemPrompts objects
    FNexus: TComponentNexus;
    FPanel: TPanel;
    FCheckBox: TORCheckBox;
    FGroupBox: TGroupBox;
    FCodesList: TStrings;
    FText: string;
    FPNText: string;
    FRec1: string;
    FID: string;
    FDlgID: string;
    FHaveData: boolean;
    FTaxID: string;
    FChecked: boolean;
    FChildrenShareChecked: boolean;
    FHasSharedPrompts: boolean;
    FHasComment: boolean;
    FHasSubComments: boolean;
    FCommentPrompt: TRemPrompt;
    FFieldValues: TORStringList;
    FMSTPrompt: TRemPrompt;
    FWHPrintDevice, FWHResultChk, FWHResultNot: String;
    FVitalDateTime: TFMDateTime; // AGP Changes 26.1
    FInitialChecked: boolean;
    FImmunizationPromptCreated: boolean;
  protected
    originalType: String;
    function buildLinkSeq(linkIEN, dialogIEN, seq: string): boolean;
    procedure Check4ChildrenSharedPrompts;
    function ShowChildren: boolean;
    function EnableChildren: boolean;
    function Enabled: boolean;
    procedure SetChecked(const Value: boolean);
    procedure UpdateData;
    function oneValidCode(Choices: TORStringList; ChoicesActiveDates: TList;
      encDt: TFMDateTime): String;
    procedure setActiveDates(Choices: TORStringList; ChoicesActiveDates: TList;
      ActiveDates: TStringList);
    procedure GetData;
    function TrueIndent: integer;
    procedure cbClicked(Sender: TObject);
    procedure cbEntered(Sender: TObject);
    procedure linkItemRedraw(element: TRemDlgElement);
    procedure FieldPanelEntered(Sender: TObject);
    procedure FieldPanelExited(Sender: TObject);
    procedure FieldPanelKeyPress(Sender: TObject; var Key: Char);
    procedure FieldPanelOnClick(Sender: TObject);
    procedure FieldPanelLabelOnClick(Sender: TObject);
    function BuildControls(var Y, TabIdx: integer; ParentWidth: integer;
      BaseParent, AOwner: TWinControl; BuildAll: boolean): TWinControl;
    function AddData(Lst: TStrings; Finishing: boolean;
      AHistorical: boolean = FALSE): integer;
    procedure FinishProblems(List: TStrings);
    function IsChecked: boolean;
    procedure SubCommentChange(Sender: TObject);
    function EntryID: string;
    procedure FieldPanelChange(Sender: TObject);
    procedure GetFieldValues(FldData: TStrings);
    procedure ParentCBEnter(Sender: TObject);
    procedure ParentCBExit(Sender: TObject);
    procedure RemoveChildControls(All: boolean);
    procedure ComponentAdded(AComponent: TComponent);
    procedure NexusFreeNotification(Sender: TObject; AComponent: TComponent);
  public
    constructor Create;
    destructor Destroy; override;
    function ElemType: TRDElemType;
    function Add2PN: boolean;
    function Indent: integer;
    function FindingType: string;
    function Historical: boolean;
    function contraindication: boolean;
    function refused: boolean;
    function ResultDlgID: string;
    function IncludeMHTestInPN: boolean;
    function HideChildren: boolean;
    function ChildrenIndent: integer;
    function ChildrenSharePrompts: boolean;
    function ChildrenRequired: TRDChildReq;
    function Box: boolean;
    function BoxCaption: string;
    function IndentChildrenInPN: boolean;
    function IndentPNLevel: integer;
    function GetTemplateFieldValues(const Text: string;
      FldValues: TORStringList = nil): string;
    function allCompleteResults: boolean;
    procedure AddText(Lst: TStrings);
    property Text: string read FText;
    property ID: string read FID;
    property DlgID: string read FDlgID;
    property Checked: boolean read FChecked write SetChecked;
    property Reminder: TReminderDialog read FReminder;
    property HasComment: boolean read FHasComment;
    property WHPrintDevice: String read FWHPrintDevice write FWHPrintDevice;
    property WHResultChk: String read FWHResultChk write FWHResultChk;
    property WHResultNot: String read FWHResultNot write FWHResultNot;
    property VitalDateTime: TFMDateTime read FVitalDateTime
      write FVitalDateTime;
  end;

  TRemDataType = (rdtDiagnosis, rdtProcedure, rdtPatientEducation, rdtExam,
    rdtHealthFactor, rdtImmunization, rdtSkinTest, rdtVitals, rdtOrder,
    rdtMentalHealthTest, rdtWHPapResult, rdtWhNotPurp, rdtGenFindings, rdtStandardCode);

  TRemPCERoot = class;

  TRemData = class(TObject)
  private
    FPCERoot: TRemPCERoot;
    FParent: TRemDlgElement;
    FRec3: string;
    FActiveDates: TStringList; // Active dates for finding items. (rectype 3)
    // FRoot: string;
    FChoices: TORStringList;
    FChoicesActiveDates: TList;
    // Active date ranges for taxonomies. (rectype 5)
    // List of TStringList objects that contain active date
    // ranges for each FChoices object of the same index
    FChoicePrompt: TRemPrompt; // rectype 4
    FChoicesMin: integer;
    FChoicesMax: integer;
    FChoicesFont: THandle;
    FSyncCount: integer;
    vimmResult: TVimmResult;
  protected
    function AddData(List: TStrings; Finishing: boolean; historical: boolean): integer;
  public
    destructor Destroy; override;
    function Add2PN: boolean;
    function DisplayWHResults: boolean;
    function InternalValue: string;
    function ExternalValue: string;
    function Narrative: string;
    function Category: string;
    function DataType: TRemDataType;
    function Code: string;
    property Parent: TRemDlgElement read FParent;
  end;

  TRemPromptType = (ptComment, ptVisitLocation, ptVisitDate, ptQuantity,
    ptPrimaryDiag, ptAdd2PL, ptExamResults, ptSkinResults, ptSkinReading,
    ptLevelSeverity, ptSeries, ptReaction, ptContraindicated, ptLevelUnderstanding,
    ptWHPapResult, ptWHNotPurp, ptDate, ptDateTime, ptView, ptPrint, ptMagnitude,
    ptUCUMCode, ptPDMP);

  TControlInfo = class(TObject)
  public
    Prompt: TRemPrompt;
    Name: string;
    Control: TControl;
    MinWidth, MaxWidth: integer;
    destructor Destroy; override;
  end;

  TRemPrompt = class(TComponent)
  private
    FFromControl: boolean;
    FParent: TRemDlgElement;
    FRec4: string;
    FCaptionAssigned: boolean;
    FData: TRemData;
    FControls: TObjectList<TControlInfo>;
    FOriginalDataRec3: string;
    FValue: string;
    FOverrideType: TRemPromptType;
    FIsShared: boolean;
    FSharedChildren: TList;
    FCurrentControl: TControl;
    FFromParent: boolean;
    FInitializing: boolean;
    FMiscText: string;
    FMonthReq: boolean;
    FPrintNow: String;
    FMHTestComplete: integer;
    FValidate: String;
    ViewRecord: boolean;
    reportView: TfrmReportBox;
    FUCUMText: string;
    FLastUCUMData: TStrings;
    FLastUCUMStartFrom: string;
    FLastUCUMDirection: integer;
    FUCUMPrompt: TRemPrompt;
    FOldReportViewOnDestroy: TNotifyEvent;
    FUCUMInfo: TUCUMInfo;
    FLastUCUMInfoData: string;
    procedure reportViewClosed(Sender: TObject);
    procedure SetCurrentControl(const Value: TControl);
    function getUCumData: string;
    function getDataType: string;
  protected
    function CreateControlInfo(AName: String; cls: TControlClass;
      AOwner: TComponent; AParent: TWinControl): TControlInfo;
    function ControlInfo(AName: String): TControlInfo; overload;
    function ControlInfo(AControl: TControl): TControlInfo; overload;
    function RemDataActive(RData: TRemData; encDt: TFMDateTime): boolean;
    function CompareActiveDate(ActiveDates: TStringList;
      encDt: TFMDateTime): boolean;
    function RemDataChoiceActive(RData: TRemData; j: integer;
      encDt: TFMDateTime): boolean;
    function GetValue: string;
    procedure SetValueFromParent(Value: string);
    procedure SetValue(Value: string);
    procedure PromptChange(Sender: TObject);
    procedure VitalVerify(Sender: TObject);
    procedure ComboBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    function CanShare(Prompt: TRemPrompt): boolean;
    procedure InitValue;
    procedure DoMHTest(Sender: TObject);
    procedure DoVimm(Sender: TObject);
    procedure DoView(Sender: TObject);
    procedure DoWHReport(Sender: TObject);
    procedure ViewWHText(Sender: TObject);
    procedure GAFHelp(Sender: TObject);
    function EntryID: string;
    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure EditEnter(Sender: TObject);
//    function buildUCUMDataText: string;
//    procedure EditEnter2(Sender: TObject);
    procedure EditExit(Sender: TObject);
    procedure UCUMNeedData(Sender: TObject; const StartFrom: string; Direction, InsertAt: Integer);
    function EventType: string;
    procedure DoPDMP(Sender: TObject);
    function getSeries: string;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure ClearControls;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function PromptOK: boolean;
    function PromptType: TRemPromptType;
    function Add2PN: boolean;
    function InternalValue: string;
    function Forced: boolean;
    function Caption: string;
    function ForcedCaption: string;
    function UCUMInfo: TUCUMInfo;
    function SameLine: boolean;
    function Required: boolean;
    function NoteText: string;
    function VitalType: TVitalType;
    function VitalValue: string;
    function VitalUnitValue: string;
    property CurrentControl: TControl read FCurrentControl write SetCurrentControl;
    property Value: string read GetValue write SetValue;
    property validate: string read FValidate write FValidate;
  end;

  TRemPCERoot = class(TObject)
  private
    FData: TList;
    FID: string;
    FForcedPrompts: TStringList;
    FValue: string;
    FValueSet: string;
  protected
    class function GetRoot(Data: TRemData; Rec3: string; Historical: boolean)
      : TRemPCERoot;
    procedure Done(Data: TRemData);
    procedure Sync(Prompt: TRemPrompt);
    procedure UnSync(Prompt: TRemPrompt);
    function GetValue(PromptType: TRemPromptType; var NewValue: string)
      : boolean;
  public
    destructor Destroy; override;
  end;

  TReminderStatus = (rsDue, rsApplicable, rsNotApplicable, rsNone, rsUnknown);

  TRemCanFinishProc = function: boolean of object;
  TRemDisplayPCEProc = procedure of object;

  TTreeChangeNotifyEvent = procedure(Proc: TNotifyEvent) of object;

  TRemForm = record
    Form: TForm;
    PCEObj: TPCEData;
    RightPanel: TPanel;
    CanFinishProc: TRemCanFinishProc;
    DisplayPCEProc: TRemDisplayPCEProc;
    DrawerReminderTV: TORTreeView;
    DrawerReminderTreeChange: TTreeChangeNotifyEvent;
    DrawerRemoveReminderTreeChange: TTreeChangeNotifyEvent;
    NewNoteRE: ORExtensions.TRichEdit;
    NoteList: TORListBox;
  end;

  TResyncObj = class
  public
    cb: TORCheckBox;
    elem: TRemDlgElement;
  end;

var
  RemForm: TRemForm;
  NotPurposeValue: string;
  WHRemPrint: string;
  InitialRemindersLoaded: boolean = FALSE;
  IgnoreReminderClicks: boolean = False;
  RemDlgResyncElements: TObjectList<TResyncObj>;

const
  HAVE_REMINDERS = 0;
  NO_REMINDERS = 1;
  RemPriorityText: array [1 .. 3] of string = ('High', '', 'Low');
  ClinMaintText = 'Clinical Maintenance';

  rdtUnknown = TRemDataType(-1);
  rdtAll = TRemDataType(-2);
  rdtHistorical = TRemDataType(-3);
  rdtMagnitudeTypes = TRemDataType(-4);
  rdtAdd2PLTypes = TRemDataType(-5);

  ptUnknown = TRemPromptType(-1);
  ptSubComment = TRemPromptType(-2);
  ptDataList = TRemPromptType(-3);
  ptVitalEntry = TRemPromptType(-4);
  ptMHTest = TRemPromptType(-5);
  ptGAF = TRemPromptType(-6);
  ptMST = TRemPromptType(-7);
  ptImmunization = TRemPromptType(-8);
  ptSkinTest = TRemPromptType(-9);

  MSTCode = 'MST';
  MSTDataTypes = [pdcHF, pdcExam];
  pnumMST = ord(pnumComment) + 4;

  MAX_REMINDER_CACHE_SIZE = 16 * 1024 * 1024;

procedure NotifyWhenRemindersChange(Proc: TNotifyEvent);
procedure RemoveNotifyRemindersChange(Proc: TNotifyEvent);
procedure StartupReminders;
function GetReminderStatus: TReminderStatus;
function RemindersEvaluatingInBackground: boolean;
procedure ResetReminderLoad;
procedure LoadReminderData(ProcessingInBackground: boolean = FALSE);
function ReminderEvaluated(Data: string; ForceUpdate: boolean = FALSE): boolean;
procedure RemindersEvaluated(List: TStringList);
procedure EvalReminder(IEN: integer);
procedure EvalProcessed;
procedure EvaluateCategoryClicked(AData: pointer; Sender: TObject);

procedure SetReminderPopupRoutine(Menu: TPopupMenu);
procedure SetReminderPopupCoverRoutine(Menu: TPopupMenu);
procedure SetReminderMenuSelectRoutine(Menu: TMenuItem);
procedure BuildReminderTree(Tree: TORTreeView);
function ReminderNode(Node: TTreeNode): TORTreeNode;
procedure ClearReminderData;
function GetReminder(ARemData: string): TReminder;
procedure WordWrap(AText: string; Output: TStrings; LineLength: integer;
  AutoIndent: integer = 4; MHTest: boolean = FALSE);
function InteractiveRemindersActive: boolean;
function GetReminderData(Rem: TReminderDialog; Lst: TStrings;
  Finishing: boolean = FALSE; Historical: boolean = FALSE): integer; overload;
function GetReminderData(Lst: TStrings; Finishing: boolean = FALSE;
  Historical: boolean = FALSE): integer; overload;
procedure SetReminderFormBounds(Frm: TForm; DefX, DefY, DefW, DefH, ALeft, ATop,
  AWidth, AHeight: integer);

procedure UpdateReminderDialogStatus;

// Added to interface to allow Coversheet to use exact same menu structure
procedure ReminderMenuBuilder(MI: TMenuItem; RemStr: string; IncludeActions, IncludeEval, ViewFolders: boolean);


function PXRMWorking: boolean;
procedure PXRMDoneWorking;

// const
// InteractiveRemindersActive = FALSE;

var
  { ActiveReminder string format:
    IEN^PRINT NAME^DUE DATE/TIME^LAST OCCURENCE DATE/TIME^PRIORITY^DUE^DIALOG
    where PRIORITY 1=High, 2=Normal, 3=Low
    DUE      0=Applicable, 1=Due, 2=Not Applicable }
  ActiveReminders: TORStringList = nil;

  { OtherReminder string format:
    IDENTIFIER^TYPE^NAME^PARENT IDENTIFIER^REMINDER IEN^DIALOG
    where TYPE C=Category, R=Reminder }
  OtherReminders: TORStringList = nil;

  RemindersInProcess: TORStringList = nil;
  CoverSheetRemindersInBackground: boolean = FALSE;
  KillReminderDialogProc: procedure(Frm: TForm) = nil;
  RemindersStarted: boolean = FALSE;
  ProcessedReminders: TORStringList = nil;
  ReminderDialogInfo: TStringList = nil;
//  immProcedureCnt: integer = 0;
  uPXRMWorkingCount: integer = 0;

const
  UM_MESSAGEBOX = WM_USER + 381;

  CatCode = 'C';
  RemCode = 'R';
  EduCode = 'E';
  pnumVisitLoc = pnumComment + 1;
  pnumVisitDate = pnumComment + 2;
  RemTreeDateIdx = 8;
  IncludeParentID = ';';
  OtherCatID = CatCode + '-6';

  RemDataCodes: array [TRemDataType] of string =
    { dtDiagnosis } ('POV',
    { dtProcedure } 'CPT',
    { dtPatientEducation } 'PED',
    { dtExam } 'XAM',
    { dtHealthFactor } 'HF',
    { dtImmunization } 'IMM',
    { dtSkinTest } 'SK',
    { dtVitals } 'VIT',
    { dtOrder } 'Q',
    { dtMentalHealthTest } 'MH',
    { dtWHPapResult } 'WHR',
    { dtWHNotPurp } 'WH',
    { dtGenFindings } 'GFIND',
    { dtStandardCode } 'SC');

implementation

uses
  rCore, uCore, rReminders, uConst, fReminderDialog, fNotes, rMisc,
  fMHTest, rPCE, rTemplates, dShared, uTemplateFields, fIconLegend,
  fReminderTree, uInit, VAUtils, VA508AccessibilityRouter,
  VA508AccessibilityManager, uDlgComponents, fBase508Form,
  System.Types, System.UITypes, uMisc, fPDMPMgr, fFrame, uPDMP, uResponsiveGUI;

type
  TRemFolder = (rfUnknown, rfDue, rfApplicable, rfNotApplicable,
    rfEvaluated, rfOther);
  TRemFolders = set of TRemFolder;
  TValidRemFolders = succ(low(TRemFolder)) .. high(TRemFolder);
  TExposedComponent = class(TControl);

  TWHCheckBox = class(TCPRSDialogCheckBox)
  private
    FPrintNow: TCPRSDialogCheckBox;
    FViewLetter: TCPRSDialogCheckBox;
    FCheck1: TWHCheckBox;
    FCheck2: TWHCheckBox;
    FCheck3: TWHCheckBox;
    FEdit: TEdit;
    FButton: TButton;
    FOnDestroy: TNotifyEvent;
    Flbl, Flbl2: TControl;
    FPrintVis: String;
    // FPrintDevice: String;
    FPntNow: String;
    FPntBatch: String;
    FButtonText: String;
    FCheckNum: String;
  protected
  public
    property lbl: TControl read Flbl write Flbl;
    property lbl2: TControl read Flbl2 write Flbl2;
    property PntNow: String read FPntNow write FPntNow;
    property PntBatch: String read FPntBatch write FPntBatch;
    property CheckNum: String read FCheckNum write FCheckNum;
    property ButtonText: String read FButtonText write FButtonText;
    property PrintNow: TCPRSDialogCheckBox read FPrintNow write FPrintNow;
    property Check1: TWHCheckBox read FCheck1 write FCheck1;
    property Check2: TWHCheckBox read FCheck2 write FCheck2;
    property Check3: TWHCheckBox read FCheck3 write FCheck3;
    property ViewLetter: TCPRSDialogCheckBox read FViewLetter write FViewLetter;
    property Button: TButton read FButton write FButton;
    property Edit: TEdit read FEdit write FEdit;
    property OnDestroy: TNotifyEvent read FOnDestroy write FOnDestroy;
    property PrintVis: String read FPrintVis write FPrintVis;
  end;

var
  LastReminderLocation: integer = -2;
  EvaluatedReminders: TORStringList = nil;
  ReminderTreeMenu: TORPopupMenu = nil;
  ReminderTreeMenuDlg: TORPopupMenu = nil;
  ReminderCatMenu: TPopupMenu = nil;
  EducationTopics: TORStringList = nil;
  WebPages: TORStringList = nil;
  ReminderCallList: TORStringList = nil;
  LastProcessingList: string = '';
  InteractiveRemindersActiveChecked: boolean = FALSE;
  InteractiveRemindersActiveStatus: boolean = FALSE;
  PCERootList: TStringList;
  PrimaryDiagRoot: TRemPCERoot = nil;
  ElementChecked: TRemDlgElement = nil;
  HistRootCount: longint = 0;
  uRemFolders: TRemFolders = [rfUnknown];
//  immProcedureCnt: integer = 0;

const
  DueText = 'Due';
  ApplicableText = 'Applicable';
  NotApplicableText = 'Not Applicable';
  EvaluatedText = 'All Evaluated';
  OtherText = 'Other Categories';

  DueCatID = CatCode + '-2';
  DueCatString = DueCatID + U + DueText;

  ApplCatID = CatCode + '-3';
  ApplCatString = ApplCatID + U + ApplicableText;

  NotApplCatID = CatCode + '-4';
  NotApplCatString = NotApplCatID + U + NotApplicableText;

  EvaluatedCatID = CatCode + '-5';
  EvaluatedCatString = EvaluatedCatID + U + EvaluatedText;

  // OtherCatID = CatCode + '-6';
  OtherCatString = OtherCatID + U + OtherText;

  LostCatID = CatCode + '-7';
  LostCatString = LostCatID + U + 'In Process';

  ReminderDateFormat = 'mm/dd/yyyy';

  RemData2PCECat: array [TRemDataType] of TPCEDataCat =
    { dtDiagnosis } (pdcDiag,
    { dtProcedure } pdcProc,
    { dtPatientEducation } pdcPED,
    { dtExam } pdcExam,
    { dtHealthFactor } pdcHF,
    { dtImmunization } pdcImm,
    { dtSkinTest } pdcSkin,
    { dtVitals } pdcVital,
    { dtOrder } pdcOrder,
    { dtMentalHealthTest } pdcMH,
    { dtWHPapResult } pdcWHR,
    { dtWHNotPurp } pdcWH,
    { dtGenFindings } pdcGenFinding,
    { dtStandardCode } pdcStandardCodes);

  RemPromptCodes: array [TRemPromptType] of string =
    { ptComment } ('COM',
    { ptVisitLocation } 'VST_LOC',
    { ptVisitDate } 'VST_DATE',
    { ptQuantity } 'CPT_QTY',
    { ptPrimaryDiag } 'POV_PRIM',
    { ptAdd2PL } 'POV_ADD',
    { ptExamResults } 'XAM_RES',
    { ptSkinResults } 'SK_RES',
    { ptSkinReading } 'SK_READ',
    { ptLevelSeverity } 'HF_LVL',
    { ptSeries } 'IMM_SER',
    { ptReaction } 'IMM_RCTN',
    { ptContraindicated } 'IMM_CNTR',
    { ptLevelUnderstanding } 'PED_LVL',
    { ptWHPapResult } 'WH_PAP_RESULT',
    { ptWHNotPurp } 'WH_NOT_PURP',
    { ptDate } 'DATE',
    { ptDateTime } 'DATE_TIME',
    { ptView } 'GF_VIEW',
    { ptPrint } 'GF_PRINT',
    { ptMagnitude } 'UCUM',
    { ptUCUMCode } 'UCUM_CODE',
    { ptPDMP} 'PDMP');

  RemPromptTypes: array [TRemPromptType] of TRemDataType =
    { ptComment } (rdtAll,
    { ptVisitLocation } rdtHistorical,
    { ptVisitDate } rdtHistorical,
    { ptQuantity } rdtProcedure,
    { ptPrimaryDiag } rdtDiagnosis,
    { ptAdd2PL } rdtAdd2PLTypes,
    { ptExamResults } rdtExam,
    { ptSkinResults } rdtSkinTest,
    { ptSkinReading } rdtSkinTest,
    { ptLevelSeverity } rdtHealthFactor,
    { ptSeries } rdtImmunization,
    { ptReaction } rdtImmunization,
    { ptContraindicated } rdtImmunization,
    { ptLevelUnderstanding } rdtPatientEducation,
    { ptWHPapResult } rdtWHPapResult,
    { ptWHNotPurp } rdtWhNotPurp,
    { ptDate } rdtAll,
    { ptDateTime } rdtGenFindings,
    { ptView } rdtGenFindings,
    { ptPrint } rdtGenFindings,
    { ptMagnitude } rdtMagnitudeTypes,
    { ptUCUMCode } rdtStandardCode,
    { ptPDMP } rdtAll);

  FinishPromptPieceNum: array [TRemPromptType] of integer =
    { ptComment } (pnumComment,
    { ptVisitLocation } pnumVisitLoc,
    { ptVisitDate } pnumVisitDate,
    { ptQuantity } pnumProcQty,
    { ptPrimaryDiag } pnumDiagPrimary,
    { ptAdd2PL } pnumAdd2PL,
    { ptExamResults } pnumExamResults,
    { ptSkinResults } pnumSkinResults,
    { ptSkinReading } pnumSkinReading,
    { ptLevelSeverity } pnumHFLevel,
    { ptSeries } pnumImmSeries,
    { ptReaction } pnumImmReaction,
    { ptContraindicated } pnumImmContra,
    { ptLevelUnderstanding } pnumPEDLevel,
    { ptWHPapResult } pnumWHPapResult,
    { ptWHNotPurp } pnumWHNotPurp,
    { ptDate } pnumDate,
    { ptDateTime } pnumDate,
    { ptView } pnumGFPrint,
    { ptPrint } pnumGFPrint,
    { ptMagnitude } pnumCodesMagnitude,
    { ptUCUMCode } pnumCodesUCUM,
    { ptPDMP } pnumPDMP);

  ComboPromptTags: array [TRemPromptType] of integer =
    { ptComment } (0,
    { ptVisitLocation } TAG_HISTLOC,
    { ptVisitDate } 0,
    { ptQuantity } 0,
    { ptPrimaryDiag } 0,
    { ptAdd2PL } 0,
    { ptExamResults } TAG_XAMRESULTS,
    { ptSkinResults } TAG_SKRESULTS,
    { ptSkinReading } 0,
    { ptLevelSeverity } TAG_HFLEVEL,
    { ptSeries } TAG_IMMSERIES,
    { ptReaction } TAG_IMMREACTION,
    { ptContraindicated } 0,
    { ptLevelUnderstanding } TAG_PEDLEVEL,
    { ptWHPapResult } 0,
    { ptWHNotPurp } 0,
    { ptDate } 0,
    { ptDateTime } 0,
    { ptView } 0,
    { ptPrint } 0,
    { ptMagnitude } 0,
    { ptUCUMCode } 0,
    { ptPDPM} 0
    );

  PromptDescriptions: array [TRemPromptType] of string =
    { ptComment } ('Comment',
    { ptVisitLocation } 'Visit Location',
    { ptVisitDate } 'Visit Date',
    { ptQuantity } 'Quantity',
    { ptPrimaryDiag } 'Primary Diagnosis',
    { ptAdd2PL } 'Add to Problem List',
    { ptExamResults } 'Exam Results',
    { ptSkinResults } 'Skin Test Results',
    { ptSkinReading } 'Skin Test Reading',
    { ptLevelSeverity } 'Level of Severity',
    { ptSeries } 'Series',
    { ptReaction } 'Reaction',
    { ptContraindicated } 'Repeat Contraindicated',
    { ptLevelUnderstanding } 'Level of Understanding',
    { ptWHPapResult } 'Women''s Health Procedure',
    { ptWHNotPurp } 'Women Health Notification Purpose',
    { ptDate } 'Date',
    { ptDateTime } 'Date\Time',
    { ptView } 'General Finding View',
    { ptPrint } 'General Finding Print',
    { ptMagnitude } 'Magnitude',
    { ptUCUMCode } 'Unified Code for Units of Measure (UCUM)',
    { ptPDMP} 'PDMP');

  RemFolderCodes: array [TValidRemFolders] of Char =
    { rfDue } ('D',
    { rfApplicable } 'A',
    { rfNotApplicable } 'N',
    { rfEvaluated } 'E',
    { rfOther } 'O');

  MSTDescTxt: array [0 .. 4, 0 .. 1] of string = (('Yes', 'Y'), ('No', 'N'),
    ('Declined', 'D'), ('Normal', 'N'), ('Abnormal', 'A'));

  SyncPrompts = [ptComment, ptQuantity, ptAdd2PL, ptExamResults, ptSkinResults,
    ptSkinReading, ptLevelSeverity, ptSeries, ptReaction, ptContraindicated,
    ptLevelUnderstanding];

  MagnitudeDataTypes = [rdtPatientEducation, rdtExam, rdtHealthFactor, rdtStandardCode];
  Add2PLDataTypes = [rdtDiagnosis, rdtStandardCode];

  Gap = 3;
  LblGap = 4;
  IndentGap = 18;
  PromptGap = 10;
  NewLinePromptGap = 18;
  IndentMult = 9;
  PromptIndent = 30;
  gbLeftIndent = 2;
  gbTopIndent = 9;
  gbTopIndent2 = 16;
  DisabledFontColor = clBtnShadow;
  r3Type = 4;
  r3Code2 = 6;
  r3Code = 7;
  r3Cat = 9;
  r3Nar = 8;
  r3CodingSystem = 10;
  r3GAF = 12;
  r3GenFindID = 14;
  r3GenFindNewData = 16;
  r3GenFindDataGroup = 17;
  r3GenFindPrinter = 18;

  RemTreeCode = 999;

  CRCode = '<br>';
  CRCodeLen = length(CRCode);
  REMEntryCode = 'REM';

  MonthReqCode = 'M';
  HistCode = 'H';
  EncDateCode = 'E';
  FutureCode = 'F';
  AnyDateCode = 'A';

function PXRMWorking: boolean;
begin
  Result := (uPXRMWorkingCount > 0);
  if not Result then
      inc(uPXRMWorkingCount);
end;

procedure PXRMDoneWorking;
begin
  if uPXRMWorkingCount > 0 then
    dec(uPXRMWorkingCount);
end;


function InitText(const InStr: string): string;
var
  i: integer;

begin
  Result := InStr;
  if (copy(Result, 1, CRCodeLen) = CRCode) then
  begin
    i := pos(CRCode, copy(Result, CRCodeLen + 1, MaxInt));
    if (i > 0) and ((i = (CRCodeLen + 1)) or
      (Trim(copy(Result, CRCodeLen + 1, i - 1)) = '')) then
      delete(Result, 1, CRCodeLen + i - 1);
  end;
end;

function CRLFText(const InStr: string): string;
begin
  Result := StringReplace(InStr, '<br>', CRLF, [rfReplaceAll]);
end;

function Code2VitalType(Code: string): TVitalType;
var
  v: TVitalType;

begin
  Result := vtUnknown;
  for v := low(TValidVitalTypes) to high(TValidVitalTypes) do
  begin
    if (Code = VitalPCECodes[v]) then
    begin
      Result := v;
      break;
    end;
  end;
end;

type
  TMultiClassObj = record
    case integer of
      0:
        (edt: TCPRSDialogFieldEdit);
      1:
        (cb: TCPRSDialogCheckBox);
      2:
        (cbo: TCPRSDialogComboBox);
      3:
        (dt: TCPRSDialogDateCombo);
      4:
        (ctrl: TORExposedControl);
      5:
        (vedt: TVitalEdit);
      6:
        (vcbo: TVitalComboBox);
      7:
        (btn: TCPRSDialogButton);
      8:
        (pNow: TORCheckBox);
      9:
        (pBat: TORCheckBox);
      10:
        (lbl: TLabel);
      11:
        (WHChk: TWHCheckBox);
      12:
        (date: TCPRSDialogDateBox);
      13:
        (pdmpBtn: TfrmPDMP); // Windows control
  end;

  EForcedPromptConflict = class(EAbort);

function IsSyncPrompt(pt: TRemPromptType): boolean;
begin
  if (pt in SyncPrompts) then
    Result := TRUE
  else
    Result := (pt = ptVitalEntry);
end;

procedure NotifyWhenRemindersChange(Proc: TNotifyEvent);
begin
  ActiveReminders.Notifier.NotifyWhenChanged(Proc);
  OtherReminders.Notifier.NotifyWhenChanged(Proc);
  RemindersInProcess.Notifier.NotifyWhenChanged(Proc);
  Proc(nil);
end;

procedure RemoveNotifyRemindersChange(Proc: TNotifyEvent);
begin
  ActiveReminders.Notifier.RemoveNotify(Proc);
  OtherReminders.Notifier.RemoveNotify(Proc);
  RemindersInProcess.Notifier.RemoveNotify(Proc);
end;

function ProcessingChangeString: string;
var
  i: integer;
  TmpSL: TStringList;

begin
  Result := U;
  if (RemindersInProcess.Count > 0) then
  begin
    TmpSL := TStringList.Create;
    try
      FastAssign(RemindersInProcess, TmpSL);
      TmpSL.Sort;
      for i := 0 to TmpSL.Count - 1 do
      begin
        if (TReminder(TmpSL.Objects[i]).Processing) then
          Result := Result + TmpSL[i] + U;
      end;
    finally
      TmpSL.Free;
    end;
  end;
end;

procedure StartupReminders;
begin
  if (not InitialRemindersLoaded) then
  begin
    RemindersStarted := TRUE;
    InitialRemindersLoaded := TRUE;
    LoadReminderData;
  end;
end;

function GetReminderStatus: TReminderStatus;
begin
  if (EvaluatedReminders.IndexOfPiece('1', U, 6) >= 0) then
    Result := rsDue
  else if (EvaluatedReminders.IndexOfPiece('0', U, 6) >= 0) then
    Result := rsApplicable
  else if (EvaluatedReminders.IndexOfPiece('2', U, 6) >= 0) then
    Result := rsNotApplicable
  else
    Result := rsUnknown;
  // else if(EvaluatedReminders.Count > 0) or (OtherReminders.Count > 0) or
  // (not InitialRemindersLoaded) or
  // (ProcessingChangeString <> U) then Result := rsUnknown
  // else Result := rsNone;
end;

function RemindersEvaluatingInBackground: boolean;
begin
  Result := CoverSheetRemindersInBackground;
  if (not Result) then
    Result := (ReminderCallList.Count > 0)
end;

var
  TmpActive: TStringList = nil;
  TmpOther: TStringList = nil;

procedure BeginReminderUpdate;
begin
  ActiveReminders.Notifier.BeginUpdate;
  OtherReminders.Notifier.BeginUpdate;
  TmpActive := TStringList.Create;
  FastAssign(ActiveReminders, TmpActive);
  TmpOther := TStringList.Create;
  FastAssign(OtherReminders, TmpOther);
end;

procedure EndReminderUpdate(Force: boolean = FALSE);
var
  DoNotify: boolean;

begin
  DoNotify := Force;
  if (not DoNotify) then
    DoNotify := (not ActiveReminders.Equals(TmpActive));
  KillObj(@TmpActive);
  if (not DoNotify) then
    DoNotify := (not OtherReminders.Equals(TmpOther));
  KillObj(@TmpOther);
  OtherReminders.Notifier.EndUpdate;
  ActiveReminders.Notifier.EndUpdate(DoNotify);
end;

function GetRemFolders: TRemFolders;
var
  i: TRemFolder;
  tmp: string;

begin
  if rfUnknown in uRemFolders then
  begin
    tmp := GetReminderFolders;
    uRemFolders := [];
    for i := low(TValidRemFolders) to high(TValidRemFolders) do
      if (pos(RemFolderCodes[i], tmp) > 0) then
        include(uRemFolders, i);
  end;
  Result := uRemFolders;
end;

procedure SetRemFolders(const Value: TRemFolders);
var
  i: TRemFolder;
  tmp: string;

begin
  if (Value <> uRemFolders) then
  begin
    BeginReminderUpdate;
    try
      uRemFolders := Value;
      tmp := '';
      for i := low(TValidRemFolders) to high(TValidRemFolders) do
        if (i in Value) then
          tmp := tmp + RemFolderCodes[i];
      SetReminderFolders(tmp);
    finally
      EndReminderUpdate(TRUE);
    end;
  end;
end;

function ReminderEvaluated(Data: string; ForceUpdate: boolean = FALSE): boolean;
var
  idx: integer;
  Code, Sts, Before: string;

begin
  Result := ForceUpdate;
  if (Data <> '') then
  begin
    Code := Piece(Data, U, 1);
    if StrToIntDef(Code, 0) > 0 then
    begin
      ActiveReminders.Notifier.BeginUpdate;
      try
        idx := EvaluatedReminders.IndexOfPiece(Code);
        if (idx < 0) then
        begin
          EvaluatedReminders.Add(Data);
          Result := TRUE;
        end
        else
        begin
          Before := Piece(EvaluatedReminders[idx], U, 6);
          EvaluatedReminders[idx] := Data;
          if (not Result) then
            Result := (Before <> Piece(Data, U, 6));
        end;
        idx := ActiveReminders.IndexOfPiece(Code);
        if (idx < 0) then
        begin
          Sts := Piece(Data, U, 6);
          // if(Sts = '0') or (Sts = '1') then
          if (Sts = '0') or (Sts = '1') or (Sts = '3') or (Sts = '4') then
          // AGP Error change 26.8
          begin
            Result := TRUE;
            ActiveReminders.Add(Data);
          end;
        end
        else
        begin
          if (not Result) then
            Result := (ActiveReminders[idx] <> Data);
          ActiveReminders[idx] := Data;
        end;
        idx := ProcessedReminders.IndexOfPiece(Code);
        if (idx >= 0) then
          ProcessedReminders.delete(idx);
      finally
        ActiveReminders.Notifier.EndUpdate(Result);
      end;
    end
    else
      Result := TRUE;
    // If Code = 0 then it's 0^No Reminders Due, indicating a status change.
  end;
end;

procedure RemindersEvaluated(List: TStringList);
var
  i: integer;
  DoUpdate, RemChanged: boolean;

begin
  DoUpdate := FALSE;
  ActiveReminders.Notifier.BeginUpdate;
  try
    for i := 0 to List.Count - 1 do
    begin
      RemChanged := ReminderEvaluated(List[i]);
      if (RemChanged) then
        DoUpdate := TRUE;
    end;
  finally
    ActiveReminders.Notifier.EndUpdate(DoUpdate);
  end;
end;

(*
  procedure CheckReminders; forward;

  procedure IdleCallEvaluateReminder(Msg: string);
  var
  i:integer;
  Code: string;

  begin
  Code := Piece(Msg,U,1);
  repeat
  i := ReminderCallList.IndexOfPiece(Code);
  if(i >= 0) then
  ReminderCallList.Delete(i);
  until(i < 0);
  ReminderEvaluated(EvaluateReminder(Msg), (ReminderCallList.Count = 0));
  CheckReminders;
  end;

  procedure CheckReminders;
  var
  i:integer;

  begin
  for i := ReminderCallList.Count-1 downto 0 do
  if(EvaluatedReminders.IndexOfPiece(Piece(ReminderCallList[i], U, 1)) >= 0) then
  ReminderCallList.Delete(i);
  if(ReminderCallList.Count > 0) then
  CallRPCWhenIdle(IdleCallEvaluateReminder,ReminderCallList[0])
  end;
*)

procedure CheckReminders;
var
  RemList: TStringList;
  i: integer;
  Code: string;
  aList: TStrings;
begin
  for i := ReminderCallList.Count - 1 downto 0 do
    if (EvaluatedReminders.IndexOfPiece(Piece(ReminderCallList[i], U, 1)) >= 0)
    then
      ReminderCallList.delete(i);
  if (ReminderCallList.Count > 0) then
  begin
    RemList := TStringList.Create;
    try
      while (ReminderCallList.Count > 0) do
      begin
        Code := Piece(ReminderCallList[0], U, 1);
        ReminderCallList.delete(0);
        repeat
          i := ReminderCallList.IndexOfPiece(Code);
          if (i >= 0) then
            ReminderCallList.delete(i);
        until (i < 0);
        RemList.Add(Code);
      end;
      if (RemList.Count > 0) then
      begin
        aList := TStringList.Create;
        try
        EvaluateReminders(RemList, aList);
        FastAssign(aList, RemList);
        for i := 0 to RemList.Count - 1 do
          ReminderEvaluated(RemList[i], (i = (RemList.Count - 1)));
        finally
          FreeAndNil(aList);
        end;
      end;
    finally
      RemList.Free;
    end;
  end;
end;

procedure ResetReminderLoad;
begin
  LastReminderLocation := -2;
  LoadReminderData;
end;

procedure LoadReminderData(ProcessingInBackground: boolean = FALSE);
var
  i, idx: integer;
  RemID: string;
  TempList: TORStringList;
  aList: TStrings;

begin
  if (RemindersStarted and (LastReminderLocation <> Encounter.Location)) then
  begin
    LastReminderLocation := Encounter.Location;
    BeginReminderUpdate;
    aList := TStringList.Create;
    try
      GetCurrentReminders(aList);
      TempList := TORStringList.Create;
      try
        if (aList.Count > 0) then
        begin
          for i := 0 to AList.Count - 1 do
          begin
            RemID := AList[i];
            idx := EvaluatedReminders.IndexOfPiece(RemID);
            if (idx < 0) then
            begin
              TempList.Add(RemID);
              if (not ProcessingInBackground) then
                ReminderCallList.Add(RemID);
            end
            else
              TempList.Add(EvaluatedReminders[idx]);
          end;
        end;
        // FastAssign(TempList,ActiveReminders);
        for i := 0 to TempList.Count - 1 do
        begin
          RemID := Piece(TempList[i], U, 1);
          if (ActiveReminders.IndexOfPiece(RemID) < 0) then
            ActiveReminders.Add(TempList[i]);
        end;
      finally
        TempList.Free;
      end;
      CheckReminders;
      GetOtherReminders(OtherReminders);
    finally
      FreeAndNil(aList);
      EndReminderUpdate;
    end;
  end;
end;

{ Supporting events for Reminder TreeViews }

procedure GetImageIndex(AData: pointer; Sender: TObject; Node: TTreeNode);
var
  iidx, oidx: integer;
  Data, tmp: string;

begin
  if (Assigned(Node)) then
  begin
    oidx := -1;
    Data := (Node as TORTreeNode).StringData;
    if (copy(Piece(Data, U, 1), 1, 1) = CatCode) then
    begin
      if (Node.Expanded) then
        iidx := 1
      else
        iidx := 0;
    end
    else
    begin
      tmp := Piece(Data, U, 6);
      // if(Tmp = '1') then iidx := 2
      if (tmp = '3') or (tmp = '4') or (tmp = '1') then
        iidx := 2 // AGP ERROR CHANGE 26.8
      else if (tmp = '0') then
        iidx := 3
      else
      begin
        if (EvaluatedReminders.IndexOfPiece(copy(Piece(Data, U, 1), 2, MaxInt),
          U, 1) < 0) then
          iidx := 5
        else
          iidx := 4;
      end;

      if (Piece(Data, U, 7) = '1') then
      begin
        tmp := copy(Piece(Data, U, 1), 2, 99);
        if (ProcessedReminders.IndexOfPiece(tmp, U, 1) >= 0) then
          oidx := 1
        else
          oidx := 0;
      end;
    end;
    Node.ImageIndex := iidx;
    Node.SelectedIndex := iidx;
    if (Node.OverlayIndex <> oidx) then
    begin
      Node.OverlayIndex := oidx;
      Node.TreeView.Invalidate;
    end;
  end;
end;

type
  TRemMenuCmd = (rmClinMaint, rmEdu, rmInq, rmWeb, rmDash, rmEval, rmDue,
    rmApplicable, rmNotApplicable, rmEvaluated, rmOther, rmLegend);
  TRemViewCmds = rmDue .. rmOther;

const
  RemMenuFolder: array [TRemViewCmds] of TRemFolder =
  { rmDue } (rfDue,
    { rmApplicable } rfApplicable,
    { rmNotApplicable } rfNotApplicable,
    { rmEvaluated } rfEvaluated,
    { rmOther } rfOther);

  RemMenuNames: array [TRemMenuCmd] of string = (
    { rmClinMaint } ClinMaintText,
    { rmEdu } 'Education Topic Definition',
    { rmInq } 'Reminder Inquiry',
    { rmWeb } 'Reference Information',
    { rmDash } '-',
    { rmEval } 'Evaluate Reminder',
    { rmDue } DueText,
    { rmApplicable } ApplicableText,
    { rmNotApplicable } NotApplicableText,
    { rmEvaluated } EvaluatedText,
    { rmOther } OtherText,
    { rmLegend } 'Reminder Icon Legend');

  EvalCatName = 'Evaluate Category Reminders';

function GetEducationTopics(EIEN: string): string;
var
  i, idx: integer;
  tmp, Data: string;
  aList: TSTrings;
begin
  aList := TStringList.Create;
  try
  if (not Assigned(EducationTopics)) then
    EducationTopics := TORStringList.Create;
  idx := EducationTopics.IndexOfPiece(EIEN);
  if (idx < 0) then
  begin
    tmp := copy(EIEN, 1, 1);
    idx := StrToIntDef(copy(EIEN, 2, MaxInt), 0);
    if (tmp = RemCode) then
      GetEducationTopicsForReminder(idx, alist)
    else if (tmp = EduCode) then
      GetEducationSubtopics(idx, alist);
    tmp := EIEN;
    if (aList.Count > 0) then
    begin
      for i := 0 to aList.Count - 1 do
      begin
        Data := aList[i];
        tmp := tmp + U + Piece(Data, U, 1) + ';';
        if (Piece(Data, U, 3) = '') then
          tmp := tmp + Piece(Data, U, 2)
        else
          tmp := tmp + Piece(Data, U, 3);
      end;
    end;
    idx := EducationTopics.Add(tmp);
  end;
  Result := EducationTopics[idx];
  idx := pos(U, Result);
  if (idx > 0) then
    Result := copy(Result, idx + 1, MaxInt)
  else
    Result := '';
  finally
    FreeAndNil(Alist);
  end;

end;

function GetWebPageName(idx: integer): string;
begin
  Result := Piece(WebPages[idx], U, 2);
end;

function GetWebPageAddress(idx: integer): string;
begin
  Result := Piece(WebPages[idx], U, 3);
end;

function GetWebPages(EIEN: string): string; overload;
var
  i, idx: integer;
  tmp, Data, Title: string;
  RIEN: string;
  aList: TStrings;
begin
  aList := TStringList.Create;
  try
  if not user.WebAccess then exit;

  RIEN := RemCode + EIEN;
  if (not Assigned(WebPages)) then
    WebPages := TORStringList.Create;
  idx := WebPages.IndexOfPiece(RIEN);
  if (idx < 0) then
  begin
    GetReminderWebPages(EIEN, aList);
    tmp := RIEN;
    if (aList.Count > 0) then
    begin
      for i := 0 to Alist.Count - 1 do
      begin
        Data := aList[i];
        if (Piece(Data, U, 1) = '1') and (Piece(Data, U, 3) <> '') then
        begin
          Data := U + Piece(Data, U, 4) + U + Piece(Data, U, 3);
          if (Piece(Data, U, 2) = '') then
          begin
            Title := Piece(Data, U, 3);
            if (length(Title) > 60) then
              Title := copy(Title, 1, 57) + '...';
            SetPiece(Data, U, 2, Title);
          end;
          // if(copy(UpperCase(Piece(Data, U, 3)),1,7) <> 'HTTP://') then
          // SetPiece(Data, U, 3,'http://'+Piece(Data,U,3));
          idx := WebPages.IndexOf(Data);
          if (idx < 0) then
            idx := WebPages.Add(Data);
          tmp := tmp + U + IntToStr(idx);
        end;
      end;
    end;
    idx := WebPages.Add(tmp);
  end;
  Result := WebPages[idx];
  idx := pos(U, Result);
  if (idx > 0) then
    Result := copy(Result, idx + 1, MaxInt)
  else
    Result := '';
  finally
    FreeAndNil(aList);
  end;

end;

function ReminderName(IEN: integer): string;
var
  idx: integer;
  SIEN: string;

begin
  SIEN := IntToStr(IEN);
  Result := '';
  idx := EvaluatedReminders.IndexOfPiece(SIEN);
  if (idx >= 0) then
    Result := Piece(EvaluatedReminders[idx], U, 2);
  if (Result = '') then
  begin
    idx := ActiveReminders.IndexOfPiece(SIEN);
    if (idx >= 0) then
      Result := Piece(ActiveReminders[idx], U, 2);
  end;
  if (Result = '') then
  begin
    idx := OtherReminders.IndexOfPiece(SIEN, U, 5);
    if (idx >= 0) then
      Result := Piece(OtherReminders[idx], U, 3);
  end;
  if (Result = '') then
  begin
    idx := RemindersInProcess.IndexOfPiece(SIEN);
    if (idx >= 0) then
      Result := TReminder(RemindersInProcess.Objects[idx]).PrintName;
  end;
end;

procedure ReminderClinMaintClicked(AData: pointer; Sender: TObject);
var
  IEN: integer;
  aList: TStrings;
  returnValue: integer;
begin
  aList := TStringList.Create;
  try
  IEN := (Sender as TMenuItem).Tag;
  if (IEN > 0) then
    begin
      returnValue := DetailReminder(IEN, aList);
      if returnValue > 0 then
          ReportBox(aList, RemMenuNames[rmClinMaint] + ': ' + ReminderName(IEN), TRUE)
      else infoBox('Error loading Clinical maintenance', 'Error', MB_OK);
    end;
  finally
    FreeAndNil(aList);
  end;

end;

procedure ReminderEduClicked(AData: pointer; Sender: TObject);
var
  IEN: integer;
  aList: TStrings;
begin
  IEN := (Sender as TMenuItem).Tag;
  if (IEN > 0) then
    aList := TStringList.Create;
    try
      if EducationTopicDetail(IEN, aList) > 0 then
            ReportBox(Alist, 'Reminder Inquiry: ' + 'Education Topic: ' + (Sender as TMenuItem).Caption, TRUE)
      else infoBox('Error loading Education Topic Inquiry.', 'Error', MB_OK);
    finally
      FreeAndNil(aList);
    end;
end;

procedure ReminderInqClicked(AData: pointer; Sender: TObject);
var
  IEN: integer;
  aList: TStrings;
begin
  IEN := (Sender as TMenuItem).Tag;
  if (IEN > 0) then
    aList := TStringList.Create;
    try
      if ReminderInquiry(IEN, aList) > 0 then
            ReportBox(aList, 'Reminder Inquiry: ' + ReminderName(IEN), TRUE)
      else infoBox('Error loading Reminder Inquiry.', 'Error', MB_OK);
    finally
      FreeAndNil(aList);
    end;
end;

procedure ReminderWebClicked(AData: pointer; Sender: TObject);
var
  idx: integer;

begin
  idx := (Sender as TMenuItem).Tag - 1;
  if (idx >= 0) then
    GotoWebPage(GetWebPageAddress(idx));
end;

procedure EvalReminder(IEN: integer);
var
  Msg, RName: string;
  NewStatus: string;

begin
  if (IEN > 0) then
  begin
    NewStatus := EvaluateReminder(IntToStr(IEN));
    ReminderEvaluated(NewStatus);
    NewStatus := Piece(NewStatus, U, 6);
    RName := ReminderName(IEN);
    if (RName = '') then
      RName := 'Reminder';
    if (NewStatus = '1') then
      Msg := 'Due'
    else if (NewStatus = '0') then
      Msg := 'Applicable'
    else if (NewStatus = '3') then
      Msg := 'Error' // AGP Error code change 26.8
    else if (NewStatus = '4') then
      Msg := 'CNBD' // AGP Error code change 26.8
    else
      Msg := 'Not Applicable';
    Msg := RName + ' is ' + Msg + '.';
    InfoBox(Msg, RName + ' Evaluation', MB_OK);
  end;
end;

procedure EvalProcessed;
var
  i: integer;

begin
  if (ProcessedReminders.Count > 0) then
  begin
    BeginReminderUpdate;
    try
      while (ProcessedReminders.Count > 0) do
      begin
        if (ReminderCallList.IndexOf(ProcessedReminders[0]) < 0) then
          ReminderCallList.Add(ProcessedReminders[0]);
        repeat
          i := EvaluatedReminders.IndexOfPiece
            (Piece(ProcessedReminders[0], U, 1));
          if (i >= 0) then
            EvaluatedReminders.delete(i);
        until (i < 0);
        ProcessedReminders.delete(0);
      end;
      CheckReminders;
    finally
      EndReminderUpdate(TRUE);
    end;
  end;
end;

procedure ReminderEvalClicked(AData: pointer; Sender: TObject);
begin
  EvalReminder((Sender as TMenuItem).Tag);
end;

procedure ReminderViewFolderClicked(AData: pointer; Sender: TObject);
var
  rfldrs: TRemFolders;
  rfldr: TRemFolder;

begin
  rfldrs := GetRemFolders;
  rfldr := TRemFolder((Sender as TMenuItem).Tag);
  if rfldr in rfldrs then
    exclude(rfldrs, rfldr)
  else
    include(rfldrs, rfldr);
  SetRemFolders(rfldrs);
end;

procedure EvaluateCategoryClicked(AData: pointer; Sender: TObject);
var
  Node: TORTreeNode;
  Code: string;
  i: integer;

begin
  if (Sender is TMenuItem) then
  begin
    BeginReminderUpdate;
    try
      Node := TORTreeNode(TORTreeNode(TMenuItem(Sender).Tag).GetFirstChild);
      while Assigned(Node) do
      begin
        Code := Piece(Node.StringData, U, 1);
        if (copy(Code, 1, 1) = RemCode) then
        begin
          Code := copy(Code, 2, MaxInt);
          if (ReminderCallList.IndexOf(Code) < 0) then
            ReminderCallList.Add(copy(Node.StringData, 2, MaxInt));
          repeat
            i := EvaluatedReminders.IndexOfPiece(Code);
            if (i >= 0) then
              EvaluatedReminders.delete(i);
          until (i < 0);
        end;
        Node := TORTreeNode(Node.GetNextSibling);
      end;
      CheckReminders;
    finally
      EndReminderUpdate(TRUE);
    end;
  end;
end;

procedure ReminderIconLegendClicked(AData: pointer; Sender: TObject);
begin
  ShowIconLegend(ilReminders);
end;

procedure ReminderMenuBuilder(MI: TMenuItem; RemStr: string;
  IncludeActions, IncludeEval, ViewFolders: boolean);
var
  M: TMethod;
  tmp: string;
  Cnt: integer;
  RemID: integer;
  cmd: TRemMenuCmd;

  function Add(Text: string; Parent: TMenuItem; Tag: integer; Typ: TRemMenuCmd)
    : TORMenuItem;
  var
    InsertMenu: boolean;
    idx: integer;

  begin
    Result := nil;
    InsertMenu := TRUE;
    if (Parent = MI) then
    begin
      if (MI.Count > Cnt) then
      begin
        Result := TORMenuItem(MI.Items[Cnt]);
        Result.Enabled := TRUE;
        Result.Visible := TRUE;
        Result.ImageIndex := -1;
        while Result.Count > 0 do
          Result.delete(Result.Count - 1);
        InsertMenu := FALSE;
      end;
      inc(Cnt);
    end;
    if (not Assigned(Result)) then
      Result := TORMenuItem.Create(MI);
    if (Text = '') then
      Result.Caption := RemMenuNames[Typ]
    else
      Result.Caption := Text;
    Result.Tag := Tag;
    Result.Data := RemStr;
    if (Tag <> 0) then
    begin
      case Typ of
        rmClinMaint:
          M.Code := @ReminderClinMaintClicked;
        rmEdu:
          M.Code := @ReminderEduClicked;
        rmInq:
          M.Code := @ReminderInqClicked;
        rmWeb:
          M.Code := @ReminderWebClicked;
        rmEval:
          M.Code := @ReminderEvalClicked;
        rmDue .. rmOther:
          begin
            M.Code := @ReminderViewFolderClicked;
            case Typ of
              rmDue:
                idx := 0;
              rmApplicable:
                idx := 2;
              rmNotApplicable:
                idx := 4;
              rmEvaluated:
                idx := 6;
              rmOther:
                idx := 8;
            else
              idx := -1;
            end;
            if (idx >= 0) and (RemMenuFolder[Typ] in GetRemFolders) then
              inc(idx);
            Result.ImageIndex := idx;
          end;
        rmLegend:
          M.Code := @ReminderIconLegendClicked;
      else
        M.Code := nil;
      end;
      if (Assigned(M.Code)) then
        Result.OnClick := TNotifyEvent(M)
      else
        Result.OnClick := nil;
    end;
    if (InsertMenu) then
      Parent.Add(Result);
  end;

  procedure AddEducationTopics(Item: TMenuItem; EduStr: string);
  var
    i, j: integer;
    Code: String;
    NewEduStr: string;
    itm: TMenuItem;

  begin
    if (EduStr <> '') then
    begin
      repeat
        i := pos(';', EduStr);
        j := pos(U, EduStr);
        if (j = 0) then
          j := length(EduStr) + 1;
        Code := copy(EduStr, 1, i - 1);
        // AddEducationTopics(Add(copy(EduStr,i+1,j-i-1), Item, StrToIntDef(Code, 0), rmEdu),
        // GetEducationTopics(EduCode + Code));

        NewEduStr := GetEducationTopics(EduCode + Code);
        if (NewEduStr = '') then
          Add(copy(EduStr, i + 1, j - i - 1), Item, StrToIntDef(Code, 0), rmEdu)
        else
        begin
          itm := Add(copy(EduStr, i + 1, j - i - 1), Item, 0, rmEdu);
          Add(copy(EduStr, i + 1, j - i - 1), itm, StrToIntDef(Code, 0), rmEdu);
          Add('', itm, 0, rmDash);
          AddEducationTopics(itm, NewEduStr);
        end;

        delete(EduStr, 1, j);
      until (EduStr = '');
    end;
  end;

  procedure AddWebPages(Item: TMenuItem; WebStr: string);
  var
    i, idx: integer;

  begin
    if (WebStr <> '') then
    begin
      repeat
        i := pos(U, WebStr);
        if (i = 0) then
          i := length(WebStr) + 1;
        idx := StrToIntDef(copy(WebStr, 1, i - 1), -1);
        if (idx >= 0) then
          Add(GetWebPageName(idx), Item, idx + 1, rmWeb);
        delete(WebStr, 1, i);
      until (WebStr = '');
    end;
  end;

begin
  RemID := StrToIntDef(copy(Piece(RemStr, U, 1), 2, MaxInt), 0);
  Cnt := 0;
  M.Data := nil;

  if (RemID > 0) then
  begin
    Add('', MI, RemID, rmClinMaint);
    tmp := GetEducationTopics(RemCode + IntToStr(RemID));
    if (tmp <> '') then
      AddEducationTopics(Add('', MI, 0, rmEdu), tmp)
    else
      Add('', MI, 0, rmEdu).Enabled := FALSE;
    Add('', MI, RemID, rmInq);
    tmp := GetWebPages(IntToStr(RemID));
    if (tmp <> '') then
      AddWebPages(Add('', MI, 0, rmWeb), tmp)
    else
      Add('', MI, 0, rmWeb).Enabled := FALSE;

    if (IncludeActions or IncludeEval) then
    begin
      Add('', MI, 0, rmDash);
      Add('', MI, RemID, rmEval);
    end;
  end;

  if (ViewFolders) then
  begin
    Add('', MI, 0, rmDash);
    for cmd := low(TRemViewCmds) to high(TRemViewCmds) do
      Add('', MI, ord(RemMenuFolder[cmd]), cmd);
  end;

  Add('', MI, 0, rmDash);
  Add('', MI, 1, rmLegend);

  while MI.Count > Cnt do
    MI.delete(MI.Count - 1);
end;

procedure ReminderTreePopup(AData: pointer; Sender: TObject);
begin
  ReminderMenuBuilder((Sender as TPopupMenu).Items, (Sender as TORPopupMenu)
    .Data, TRUE, FALSE, FALSE);
end;

procedure ReminderTreePopupCover(AData: pointer; Sender: TObject);
begin
  ReminderMenuBuilder((Sender as TPopupMenu).Items, (Sender as TORPopupMenu)
    .Data, FALSE, FALSE, FALSE);
end;

procedure ReminderTreePopupDlg(AData: pointer; Sender: TObject);
begin
  ReminderMenuBuilder((Sender as TPopupMenu).Items, (Sender as TORPopupMenu)
    .Data, FALSE, TRUE, FALSE);
end;

procedure ReminderMenuItemSelect(AData: pointer; Sender: TObject);
begin
  ReminderMenuBuilder((Sender as TMenuItem), (Sender as TORMenuItem).Data,
    FALSE, FALSE, TRUE);
end;

procedure SetReminderPopupRoutine(Menu: TPopupMenu);
var
  M: TMethod;

begin
  M.Code := @ReminderTreePopup;
  M.Data := nil;
  Menu.OnPopup := TNotifyEvent(M);
end;

procedure SetReminderPopupCoverRoutine(Menu: TPopupMenu);
var
  M: TMethod;

begin
  M.Code := @ReminderTreePopupCover;
  M.Data := nil;
  Menu.OnPopup := TNotifyEvent(M);
end;

procedure SetReminderPopupDlgRoutine(Menu: TPopupMenu);
var
  M: TMethod;

begin
  M.Code := @ReminderTreePopupDlg;
  M.Data := nil;
  Menu.OnPopup := TNotifyEvent(M);
end;

procedure SetReminderMenuSelectRoutine(Menu: TMenuItem);
var
  M: TMethod;

begin
  M.Code := @ReminderMenuItemSelect;
  M.Data := nil;
  Menu.OnClick := TNotifyEvent(M);
end;

function ReminderMenu(Sender: TComponent): TORPopupMenu;
begin
  if (Sender.Tag = RemTreeCode) then
  begin
    if (not Assigned(ReminderTreeMenuDlg)) then
    begin
      ReminderTreeMenuDlg := TORPopupMenu.Create(nil);
      SetReminderPopupDlgRoutine(ReminderTreeMenuDlg)
    end;
    Result := ReminderTreeMenuDlg;
  end
  else
  begin
    if (not Assigned(ReminderTreeMenu)) then
    begin
      ReminderTreeMenu := TORPopupMenu.Create(nil);
      SetReminderPopupRoutine(ReminderTreeMenu);
    end;
    Result := ReminderTreeMenu;
  end;
end;

procedure RemContextPopup(AData: pointer; Sender: TObject; MousePos: TPoint;
  var Handled: boolean);
var
  Menu: TORPopupMenu;
  MItem: TMenuItem;
  M: TMethod;
  p1: string;
  UpdateMenu: boolean;

begin
  UpdateMenu := TRUE;
  Menu := nil;
  with (Sender as TORTreeView) do
  begin
    if ((htOnItem in GetHitTestInfoAt(MousePos.X, MousePos.Y)) and
      (Assigned(Selected))) then
    begin
      p1 := Piece((Selected as TORTreeNode).StringData, U, 1);
      if (copy(p1, 1, 1) = RemCode) then
      begin
        Menu := ReminderMenu(TComponent(Sender));
        Menu.Data := TORTreeNode(Selected).StringData;
      end
      else if (copy(p1, 1, 1) = CatCode) and (p1 <> OtherCatID) and
        (Selected.HasChildren) then
      begin
        if (not Assigned(ReminderCatMenu)) then
        begin
          ReminderCatMenu := TPopupMenu.Create(nil);
          MItem := TMenuItem.Create(ReminderCatMenu);
          MItem.Caption := EvalCatName;
          M.Data := nil;
          M.Code := @EvaluateCategoryClicked;
          MItem.OnClick := TNotifyEvent(M);
          ReminderCatMenu.Items.Add(MItem);
        end
        else
          MItem := ReminderCatMenu.Items[0];
        PopupMenu := ReminderCatMenu;
        MItem.Tag := integer(TORTreeNode(Selected));
        UpdateMenu := FALSE;
      end;
    end;
    if UpdateMenu then
      PopupMenu := Menu;
    Selected := Selected;
    // This strange line Keeps item selected after a right click
    if (not Assigned(PopupMenu)) then
      Handled := TRUE;
  end;
end;

{ StringData of the TORTreeNodes will be in the format:
  1          2          3             4                        5        6   7
  TYPE + IEN^PRINT NAME^DUE DATE/TIME^LAST OCCURENCE DATE/TIME^PRIORITY^DUE^DIALOG
  8                 9                            10
  Formated Due Date^Formated Last Occurence Date^InitialAbsoluteIdx

  where TYPE     C=Category, R=Reminder
  PRIORITY 1=High, 2=Normal, 3=Low
  DUE      0=Applicable, 1=Due, 2=Not Applicable
  DIALOG   1=Active Dialog Exists
}
procedure BuildReminderTree(Tree: TORTreeView);
var
  ExpandedStr: string;
  TopID1, TopID2: string;
  SelID1, SelID2: string;
  i, j: integer;
  NeedLost: boolean;
  tmp, Data, LostCat, Code: string;
  Node: TORTreeNode;
  M: TMethod;
  Rem: TReminder;
  OpenDue, Found: boolean;

  function Add2Tree(Folder: TRemFolder; CatID: string; Node: TORTreeNode = nil)
    : TORTreeNode;
  begin
    if (Folder = rfUnknown) or (Folder in GetRemFolders) then
    begin
      if (CatID = LostCatID) then
      begin
        if (NeedLost) then
        begin
          (Tree.Items.AddFirst(nil, '') as TORTreeNode).StringData :=
            LostCatString;
          NeedLost := FALSE;
        end;
      end;

      if (not Assigned(Node)) then
        Node := Tree.FindPieceNode(CatID, 1);
      if (Assigned(Node)) then
      begin
        Result := (Tree.Items.AddChild(Node, '') as TORTreeNode);
        Result.StringData := Data;
      end
      else
        Result := nil;
    end
    else
      Result := nil;
  end;

begin
  if (not Assigned(Tree)) then
    exit;
  Tree.Items.BeginUpdate;
  try
    Tree.NodeDelim := U;
    Tree.NodePiece := 2;
    M.Code := @GetImageIndex;
    M.Data := nil;
    Tree.OnGetImageIndex := TTVExpandedEvent(M);
    Tree.OnGetSelectedIndex := TTVExpandedEvent(M);
    M.Code := @RemContextPopup;
    Tree.OnContextPopup := TContextPopupEvent(M);

    if (Assigned(Tree.TopItem)) then
    begin
      TopID1 := Tree.GetNodeID(TORTreeNode(Tree.TopItem), 1, IncludeParentID);
      TopID2 := Tree.GetNodeID(TORTreeNode(Tree.TopItem), 1);
    end
    else
      TopID1 := U;

    if (Assigned(Tree.Selected)) then
    begin
      SelID1 := Tree.GetNodeID(TORTreeNode(Tree.Selected), 1, IncludeParentID);
      SelID2 := Tree.GetNodeID(TORTreeNode(Tree.Selected), 1);
    end
    else
      SelID1 := U;

    ExpandedStr := Tree.GetExpandedIDStr(1, IncludeParentID);
    OpenDue := (ExpandedStr = '');

    Tree.Items.Clear;
    NeedLost := TRUE;

    if (rfDue in GetRemFolders) then
      (Tree.Items.Add(nil, '') as TORTreeNode).StringData := DueCatString;
    if (rfApplicable in GetRemFolders) then
      (Tree.Items.Add(nil, '') as TORTreeNode).StringData := ApplCatString;
    if (rfNotApplicable in GetRemFolders) then
      (Tree.Items.Add(nil, '') as TORTreeNode).StringData := NotApplCatString;
    if (rfEvaluated in GetRemFolders) then
      (Tree.Items.Add(nil, '') as TORTreeNode).StringData := EvaluatedCatString;
    if (rfOther in GetRemFolders) then
      (Tree.Items.Add(nil, '') as TORTreeNode).StringData := OtherCatString;

    for i := 0 to EvaluatedReminders.Count - 1 do
    begin
      Data := RemCode + EvaluatedReminders[i];
      tmp := Piece(Data, U, 6);
      // if(Tmp = '1') then Add2Tree(rfDue, DueCatID)
      if (tmp = '1') or (tmp = '3') or (tmp = '4') then
        Add2Tree(rfDue, DueCatID) // AGP Error code change 26.8
      else if (tmp = '0') then
        Add2Tree(rfApplicable, ApplCatID)
      else
        Add2Tree(rfNotApplicable, NotApplCatID);
      Add2Tree(rfEvaluated, EvaluatedCatID);
    end;

    if (rfOther in GetRemFolders) and (OtherReminders.Count > 0) then
    begin
      for i := 0 to OtherReminders.Count - 1 do
      begin
        tmp := OtherReminders[i];
        if (Piece(tmp, U, 2) = CatCode) then
          Data := CatCode + Piece(tmp, U, 1)
        else
        begin
          Code := Piece(tmp, U, 5);
          Data := RemCode + Code;
          Node := Tree.FindPieceNode(Data, 1);
          if (Assigned(Node)) then
            Data := Node.StringData
          else
          begin
            j := EvaluatedReminders.IndexOfPiece(Code);
            if (j >= 0) then
              SetPiece(Data, U, 6, Piece(EvaluatedReminders[j], U, 6));
          end;
        end;
        SetPiece(Data, U, 2, Piece(tmp, U, 3));
        SetPiece(Data, U, 7, Piece(tmp, U, 6));
        tmp := CatCode + Piece(tmp, U, 4);
        Add2Tree(rfOther, OtherCatID, Tree.FindPieceNode(tmp, 1));
      end;
    end;

    { The Lost category is for reminders being processed that are no longer in the
      reminder tree view.  This can happen with reminders that were Due or Applicable,
      but due to user action are no longer applicable, or due to location changes.
      The Lost category will not be used if a lost reminder is in the other list. }

    if (RemindersInProcess.Count > 0) then
    begin
      for i := 0 to RemindersInProcess.Count - 1 do
      begin
        Rem := TReminder(RemindersInProcess.Objects[i]);
        tmp := RemCode + Rem.IEN;
        Found := FALSE;
        Node := nil;
        repeat
          Node := Tree.FindPieceNode(tmp, 1, #0, Node);
          // look in the tree first
          if ((not Found) and (not Assigned(Node))) then
          begin
            Data := tmp + U + Rem.PrintName + U + Rem.DueDateStr + U +
              Rem.LastDateStr + U + IntToStr(Rem.Priority) + U + Rem.Status;
            if (Rem.Status = '1') then
              LostCat := DueCatID
            else if (Rem.Status = '0') then
              LostCat := ApplCatID
            else
              LostCat := LostCatID;
            Node := Add2Tree(rfUnknown, LostCat);
          end;
          if (Assigned(Node)) then
          begin
            Node.Bold := Rem.Processing;
            Found := TRUE;
          end;
        until (Found and (not Assigned(Node)));
      end;
    end;

    for i := 0 to Tree.Items.Count - 1 do
    begin
      Node := TORTreeNode(Tree.Items[i]);
      for j := 3 to 4 do
      begin
        tmp := Piece(Node.StringData, U, j);
        if (tmp = '') then
          Data := ''
        else
          Data := FormatFMDateTimeStr(ReminderDateFormat, tmp);
        Node.SetPiece(j + (RemTreeDateIdx - 3), Data);
      end;
      Node.SetPiece(RemTreeDateIdx + 2, IntToStr(Node.AbsoluteIndex));
      tmp := Piece(Node.StringData, U, 5);
      if (tmp <> '1') and (tmp <> '3') then
        Node.SetPiece(5, '2');
    end;

  finally
    Tree.Items.EndUpdate;
  end;

  if (SelID1 = U) then
    Node := nil
  else
  begin
    Node := Tree.FindPieceNode(SelID1, 1, IncludeParentID);
    if (not Assigned(Node)) then
      Node := Tree.FindPieceNode(SelID2, 1);
    if (Assigned(Node)) then
      Node.EnsureVisible;
  end;
  Tree.Selected := Node;

  Tree.SetExpandedIDStr(1, IncludeParentID, ExpandedStr);
  if (OpenDue) then
  begin
    Node := Tree.FindPieceNode(DueCatID, 1);
    if (Assigned(Node)) then
      Node.Expand(FALSE);
  end;

  if (TopID1 = U) then
    Tree.TopItem := Tree.Items.GetFirstNode
  else
  begin
    Tree.TopItem := Tree.FindPieceNode(TopID1, 1, IncludeParentID);
    if (not Assigned(Tree.TopItem)) then
      Tree.TopItem := Tree.FindPieceNode(TopID2, 1);
  end;
end;

function ReminderNode(Node: TTreeNode): TORTreeNode;
var
  p1: string;

begin
  Result := nil;
  if (Assigned(Node)) then
  begin
    p1 := Piece((Node as TORTreeNode).StringData, U, 1);
    if (copy(p1, 1, 1) = RemCode) then
      Result := (Node as TORTreeNode)
  end;
end;

procedure LocationChanged(Sender: TObject);
begin
  LoadReminderData;
end;

procedure ClearReminderData;
var
  Changed: boolean;

begin
  if (Assigned(frmReminderTree)) then
    frmReminderTree.Free;
  Changed := ((ActiveReminders.Count > 0) or (OtherReminders.Count > 0) or
    (ProcessingChangeString <> U));
  ActiveReminders.Notifier.BeginUpdate;
  OtherReminders.Notifier.BeginUpdate;
  RemindersInProcess.Notifier.BeginUpdate;
  try
    ProcessedReminders.Clear;
    if (Assigned(KillReminderDialogProc)) then
      KillReminderDialogProc(nil);
    ActiveReminders.Clear;
    OtherReminders.Clear;
    EvaluatedReminders.Clear;
    ReminderCallList.Clear;
    RemindersInProcess.KillObjects;
    RemindersInProcess.Clear;
    LastProcessingList := '';
    InitialRemindersLoaded := FALSE;
    CoverSheetRemindersInBackground := FALSE;
  finally
    RemindersInProcess.Notifier.EndUpdate;
    OtherReminders.Notifier.EndUpdate;
    ActiveReminders.Notifier.EndUpdate(Changed);
    RemindersStarted := FALSE;
    LastReminderLocation := -2;
    RemForm.Form := nil;
  end;
end;

procedure RemindersInProcessChanged(Data: pointer; Sender: TObject;
  var CanNotify: boolean);
var
  CurProcessing: string;
begin
  CurProcessing := ProcessingChangeString;
  CanNotify := (LastProcessingList <> CurProcessing);
  if (CanNotify) then
    LastProcessingList := CurProcessing;
end;

procedure InitReminderObjects;
var
  M: TMethod;

  procedure InitReminderList(var List: TORStringList);
  begin
    if (not Assigned(List)) then
      List := TORStringList.Create;
  end;

begin
  InitReminderList(ActiveReminders);
  InitReminderList(OtherReminders);
  InitReminderList(EvaluatedReminders);
  InitReminderList(ReminderCallList);
  InitReminderList(RemindersInProcess);
  InitReminderList(ProcessedReminders);

  M.Code := @RemindersInProcessChanged;
  M.Data := nil;
  RemindersInProcess.Notifier.OnNotify := TCanNotifyEvent(M);

  AddToNotifyWhenCreated(LocationChanged, TEncounter);

  RemForm.Form := nil;
end;

procedure FreeReminderObjects;
begin
  KillObj(@ActiveReminders);
  KillObj(@OtherReminders);
  KillObj(@EvaluatedReminders);
  KillObj(@ReminderTreeMenuDlg);
  KillObj(@ReminderTreeMenu);
  KillObj(@ReminderCatMenu);
  KillObj(@EducationTopics);
  KillObj(@WebPages);
  KillObj(@ReminderCallList);
  KillObj(@TmpActive);
  KillObj(@TmpOther);
  KillObj(@RemindersInProcess, TRUE);
  KillObj(@ReminderDialogInfo, TRUE);
  KillObj(@PCERootList, TRUE);
  KillObj(@ProcessedReminders);
  if assigned(RemDlgResyncElements) then
    FreeAndNil(RemDlgResyncElements);
end;

function GetReminder(ARemData: string): TReminder;
var
  idx: integer;
  SIEN: string;

begin
  Result := nil;
  SIEN := Piece(ARemData, U, 1);
  if (copy(SIEN, 1, 1) = RemCode) then
  begin
    SIEN := copy(SIEN, 2, MaxInt);
    idx := RemindersInProcess.IndexOf(SIEN);
    if (idx < 0) then
    begin
      RemindersInProcess.Notifier.BeginUpdate;
      try
        idx := RemindersInProcess.AddObject(SIEN, TReminder.Create(ARemData));
      finally
        RemindersInProcess.Notifier.EndUpdate;
      end;
    end;
    Result := TReminder(RemindersInProcess.Objects[idx]);
  end;
end;

var
  ScootOver: integer = 0;

procedure WordWrap(AText: string; Output: TStrings; LineLength: integer;
  AutoIndent: integer = 4; MHTest: boolean = FALSE);
var
  i, j, FCount, MHLoop: integer;
  First, MHRes: boolean;
  OrgText, Text, Prefix, tmpText: string;
begin
  StripScreenReaderCodes(AText);
  inc(LineLength, ScootOver);
  dec(AutoIndent, ScootOver);
  FCount := Output.Count;
  First := TRUE;
  MHLoop := 1;
  MHRes := FALSE;
  tmpText := '';
  if (MHTest = TRUE) and (pos('~', AText) > 0) then
    MHLoop := 2;
  for j := 1 to MHLoop do
  begin
    if (j = 1) and (MHLoop = 2) then
    begin
      tmpText := Piece(AText, '~', 1);
      MHRes := TRUE;
    end
    else if (j = 2) then
    begin
      tmpText := Piece(AText, '~', 2);
      First := FALSE;
      MHRes := FALSE;
    end
    else if (j = 1) and (MHLoop = 1) then
    begin
      tmpText := AText;
      First := FALSE;
      MHRes := FALSE;
    end;
    if tmpText <> '' then
      OrgText := tmpText
    else
      OrgText := InitText(AText);
    Prefix := StringOfChar(' ', MAX_ENTRY_WIDTH - LineLength);
    repeat
        OrgText := CRLFText(OrgText);
//      i := pos(CRCode, OrgText);
//      if (i = 0) then i := pos(CRLF, orgText);
      i := pos(CRLF, OrgText);
      if (i = 0) then
      begin
        Text := OrgText;
        OrgText := '';
      end
      else
      begin
        Text := copy(OrgText, 1, i - 1);
        delete(OrgText, 1, i + Length(CRLF) - 1);
      end;
      if (Text = '') and (OrgText <> '') then
      begin
        Output.Add('');
        inc(FCount);
      end;

       If Text <> '' then begin
        if(First) then
        begin
          dec(LineLength, AutoIndent);
          Prefix := Prefix + StringOfChar(' ', AutoIndent);
          First := FALSE;
        end;

        // Wrap the text and account for the new charaters
        Text := SafeWrapText(text, CRLF + Prefix, [#3, ' '], LineLength, LineLength);
        // remove the #3 (if present)
        If Pos(#3, Text) > 0 then
          Text := StringReplace(Text, #3, '', [rfReplaceAll,rfIgnoreCase]);

        Output.Add(Prefix + Text);

      end;

      if ((First) and (FCount <> Output.Count)) and (MHRes = FALSE) then
      begin
        dec(LineLength, AutoIndent);
        Prefix := Prefix + StringOfChar(' ', AutoIndent);
        First := FALSE;
      end;
    until (OrgText = '');
  end;
end;

function InteractiveRemindersActive: boolean;
begin
  if (not InteractiveRemindersActiveChecked) then
  begin
    InteractiveRemindersActiveStatus := GetRemindersActive;
    InteractiveRemindersActiveChecked := TRUE;
  end;
  Result := InteractiveRemindersActiveStatus;
end;

function GetReminderData(Rem: TReminderDialog; Lst: TStrings;
  Finishing: boolean = FALSE; Historical: boolean = FALSE): integer;
begin
  Result := Rem.AddData(Lst, Finishing, Historical);
end;

function GetReminderData(Lst: TStrings; Finishing: boolean = FALSE;
  Historical: boolean = FALSE): integer;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to RemindersInProcess.Count - 1 do
    inc(Result, TReminder(RemindersInProcess.Objects[i]).AddData(Lst, Finishing,
      Historical));
end;

procedure SetReminderFormBounds(Frm: TForm; DefX, DefY, DefW, DefH, ALeft, ATop,
  AWidth, AHeight: integer);
var
  Rect: TRect;
  ScreenW, ScreenH: integer;

begin
  SystemParametersInfo(SPI_GETWORKAREA, 0, @Rect, 0);
  ScreenW := Rect.Right - Rect.Left + 1;
  ScreenH := Rect.Bottom - Rect.Top + 1;
  if (AWidth = 0) then
    AWidth := DefW
  else
    DefW := AWidth;
  if (AHeight = 0) then
    AHeight := DefH
  else
    DefH := AHeight;
  if (DefX = 0) and (DefY = 0) then
  begin
    DefX := (ScreenW - DefW) div 2;
    DefY := (ScreenH - DefH) div 2;
  end
  else
    dec(DefY, DefH);
  if ((ALeft <= 0) or (ATop <= 0) or ((ALeft + AWidth) > ScreenW) or
    ((ATop + AHeight) > ScreenH)) then
  begin
    if (DefX < 0) then
      DefX := 0
    else if ((DefX + DefW) > ScreenW) then
      DefX := ScreenW - DefW;
    if (DefY < 0) then
      DefY := 0
    else if ((DefY + DefH) > ScreenH) then
      DefY := ScreenH - DefH;
    Frm.SetBounds(Rect.Left + DefX, Rect.Top + DefY, DefW, DefH);
  end
  else
    Frm.SetBounds(Rect.Left + ALeft, Rect.Top + ATop, AWidth, AHeight);
end;

procedure UpdateReminderDialogStatus;
var
  TmpSL: TStringList;
  Changed: boolean;

  procedure Build(AList: TORStringList; PNum: integer);
  var
    i: integer;
    Code: string;

  begin
    for i := 0 to AList.Count - 1 do
    begin
      Code := Piece(AList[i], U, PNum);
      if ((Code <> '') and (TmpSL.IndexOf(Code) < 0)) then
        TmpSL.Add(Code);
    end;
  end;

  procedure Reset(AList: TORStringList; PNum, DlgPNum: integer);
  var
    i, j: integer;
    tmp, Code, Dlg: string;

  begin
    for i := 0 to TmpSL.Count - 1 do
    begin
      Code := Piece(TmpSL[i], U, 1);
      j := -1;
      repeat
        j := AList.IndexOfPiece(Code, U, PNum, j);
        if (j >= 0) then
        begin
          Dlg := Piece(TmpSL[i], U, 2);
          if (Dlg <> Piece(AList[j], U, DlgPNum)) then
          begin
            tmp := AList[j];
            SetPiece(tmp, U, DlgPNum, Dlg);
            AList[j] := tmp;
            Changed := TRUE;
          end;
        end;
      until (j < 0);
    end;
  end;

begin
  Changed := FALSE;
  BeginReminderUpdate;
  try
    TmpSL := TStringList.Create;
    try
      Build(ActiveReminders, 1);
      Build(OtherReminders, 5);
      Build(EvaluatedReminders, 1);
      GetDialogStatus(TmpSL);
      Reset(ActiveReminders, 1, 7);
      Reset(OtherReminders, 5, 6);
      Reset(EvaluatedReminders, 1, 7);
    finally
      TmpSL.Free;
    end;
  finally
    EndReminderUpdate(Changed);
  end;
end;

procedure PrepText4NextLine(var txt: string);
var
  tlen: integer;

begin
  if (txt <> '') then
  begin
    tlen := length(txt);
    if (copy(txt, tlen - CRCodeLen + 1, CRCodeLen) = CRCode) then
      exit;
    if (copy(txt, tlen, 1) = '.') then
      txt := txt + ' ';
    txt := txt + ' ';
  end;
end;

procedure ExpandTIUObjects(var txt: string; VisitStr: string);
var
  ObjList: TStringList;
  Err: TStringList;
  i, j, k, oLen: integer;
  obj, ObjTxt: string;

begin
  ObjList := TStringList.Create;
  try
    Err := nil;
    if (not dmodShared.BoilerplateOK(txt, CRCode, ObjList, Err)) and
      (Assigned(Err)) then
    begin
      try
        Err.Add(CRLF + 'Contact IRM and inform them about this error.' + CRLF +
          'Make sure you give them the name of the reminder that you are processing,'
          + CRLF + 'and which dialog elements were selected to produce this error.');
        InfoBox(Err.Text, 'Reminder Boilerplate Object Error',
          MB_OK + MB_ICONERROR);
      finally
        Err.Free;
      end;
    end;
    if (ObjList.Count > 0) then
    begin
      GetTemplateText(ObjList, VisitStr);
      i := 0;
      while (i < ObjList.Count) do
      begin
        if (pos(ObjMarker, ObjList[i]) = 1) then
        begin
          obj := copy(ObjList[i], ObjMarkerLen + 1, MaxInt);
          if (obj = '') then
            break;
          j := i + 1;
          while (j < ObjList.Count) and (pos(ObjMarker, ObjList[j]) = 0) do
            inc(j);
          if ((j - i) > 2) then
          begin
            ObjTxt := '';
            for k := i + 1 to j - 1 do
              ObjTxt := ObjTxt + CRCode + ObjList[k];
          end
          else
            ObjTxt := ObjList[i + 1];
          i := j;
          obj := '|' + obj + '|';
          oLen := length(obj);
          repeat
            j := pos(obj, txt);
            if (j > 0) then
            begin
              delete(txt, j, oLen);
              insert(ObjTxt, txt, j);
            end;
          until (j = 0);
        end
        else
          inc(i);
      end
    end;
  finally
    ObjList.Free;
  end;
end;

{ TReminderDialog }

const
  RPCCalled = '99';
  DlgCalled = RPCCalled + U + 'DLG';

constructor TReminderDialog.BaseCreate;
var
  idx, eidx, i: integer;
  TempSL: TORStringList;
  ParentID: string;
  // Line: string;
  Element: TRemDlgElement;

begin
  TempSL := GetDlgSL;
  if (TempSL.Count > 0) and (Piece(TempSL[0], U, 2) = '1') then
  begin
    Self.RemWipe := 1;
  end;
  idx := -1;
  repeat
    idx := TempSL.IndexOfPiece('1', U, 1, idx);
    if (idx >= 0) then
    begin
      if (not Assigned(FElements)) then
        FElements := TStringList.Create;
      eidx := FElements.AddObject('', TRemDlgElement.Create);
      Element := TRemDlgElement(FElements.Objects[eidx]);
      with Element do
      begin
        FReminder := Self;
        FRec1 := TempSL[idx];
        FID := Piece(FRec1, U, 2);
        FDlgID := Piece(FRec1, U, 3);
        FElements[eidx] := FDlgID;
        if (ElemType = etTaxonomy) then
          FTaxID := BOOLCHAR[Historical] + FindingType
        else
          FTaxID := '';

        FText := '';
        i := -1;
        // if Piece(FRec1,U,5) <> '1' then
        repeat
          i := TempSL.IndexOfPieces(['2', FID, FDlgID], i);
          if (i >= 0) then
          begin
            PrepText4NextLine(FText);
            FText := FText + Trim(Piece(TempSL[i], U, 4));
          end;
        until (i < 0);
        ExpandTIUObjects(FText, RemForm.PCEObj.VisitString);
        AssignFieldIDs(FText);

        if (pos('.', FDlgID) > 0) then
        begin
          ParentID := FDlgID;
          i := length(ParentID);
          while ((i > 0) and (ParentID[i] <> '.')) do
            dec(i);
          if (i > 0) then
          begin
            ParentID := copy(ParentID, 1, i - 1);
            i := FElements.IndexOf(ParentID);
            if (i >= 0) then
            begin
              FParent := TRemDlgElement(FElements.Objects[i]);
              if (not Assigned(FParent.FChildren)) then
                FParent.FChildren := TList.Create;
              FParent.FChildren.Add(Element);
            end;
          end;
        end;
        if (ElemType = etDisplayOnly) then
          SetChecked(TRUE);
        UpdateData;
      end;
    end;
  until (idx < 0);
end;

constructor TReminderDialog.Create(ADlgData: string);
begin
  FDlgData := ADlgData;
  linkSeqList := TStringlist.Create;
  linkSeqListChecked := TStringlist.Create;
  BaseCreate;
end;

destructor TReminderDialog.Destroy;
begin
  KillObj(@FElements, TRUE);
  FreeAndNil(linkSeqList);
  FreeAndNil(linkSeqListChecked);

//  if assigned(frmFrame.PDMPMgr) then // PDMP
//    frmFrame.PDMPMgr.ShowNow := False;

  inherited;
end;

procedure TReminderDialog.DoFocus(Ctrl: TWinControl);
begin
  if ShouldFocus(Ctrl) then
    Ctrl.SetFocus;
end;

function TReminderDialog.Processing: boolean;
var
  i, j: integer;
  Elem: TRemDlgElement;
  RData: TRemData;

function ChildrenChecked(Prnt: TRemDlgElement): boolean; forward;

  function CheckItem(Item: TRemDlgElement): boolean;
  begin
    if (Item.ElemType = etDisplayOnly) then
    begin
      Result := ChildrenChecked(Item);
      if (not Result) then
        Result := Item.Add2PN;
    end
    else
      Result := Item.FChecked;
  end;

  function ChildrenChecked(Prnt: TRemDlgElement): boolean;
  var
    i: integer;

  begin
    Result := FALSE;
    if (Assigned(Prnt.FChildren)) then
    begin
      for i := 0 to Prnt.FChildren.Count - 1 do
      begin
        Result := CheckItem(TRemDlgElement(Prnt.FChildren[i]));
        if (Result) then
          break;
      end;
    end;
  end;

begin
  Result := FALSE;
  if (Assigned(FElements)) then
  begin
    for i := 0 to FElements.Count - 1 do
    begin
      Elem := TRemDlgElement(FElements.Objects[i]);
      if (not Assigned(Elem.FParent)) then
      begin
        Result := CheckItem(Elem);
        if (Result = FALSE) then
        // (AGP CHANGE 24.9 add check to have the finish problem check for MH test)
        begin
          if (Assigned(Elem.FData)) then
          begin
            for j := 0 to Elem.FData.Count - 1 do
            begin
              RData := TRemData(Elem.FData[j]);
              if Piece(RData.FRec3, U, 4) = 'MH' then
                Result := TRUE;
              if (Result) then
                break;
            end;
          end;
        end;
        if (Result) then
          break;
      end;
    end;
  end;
end;

function TReminderDialog.GetDlgSL(Purge: Boolean = True): TORStringList;
var
  idx: integer;
  aList: TStrings;
  isReminder: boolean;

  procedure GetIdx(const id: string);
  var
    i: integer;

  begin
    idx := - 1;
    for i := ReminderDialogInfo.Count - 1 downto 0 do
      if ReminderDialogInfo[i] = id then
      begin
        idx := i;
        exit;
      end;
  end;

begin
  aList := TStringList.Create;
  try
    if (not Assigned(ReminderDialogInfo)) then
      ReminderDialogInfo := TStringList.Create;
    GetIdx(GetIEN);
    if (idx < 0) then
      idx := ReminderDialogInfo.AddObject(GetIEN, TORStringList.Create);
    Result := TORStringList(ReminderDialogInfo.Objects[idx]);
    MarkMostRecent(ReminderDialogInfo, idx);
    if (Result.Count = 0) then
    begin
      if (Self is TReminder) then isReminder := true
      else isReminder := false;
      if GetDialogInfo(GetIEN, isReminder, aList) = 0 then exit;
      FastAssign(alist, Result);
      // Used to prevent repeated calling of RPC if dialog is empty
      Result.Add(DlgCalled);
      if Purge then
        PurgeOldIfNeeded(ReminderDialogInfo, MAX_REMINDER_CACHE_SIZE);
    end;
  finally
     FreeAndNil(aList);
  end;

end;

function TReminderDialog.BuildControls(ParentWidth: integer;
  AParent, AOwner: TWinControl; BuildAll: boolean): TWinControl;
var
  Y, i, TabIdx: integer;
  Elem: TRemDlgElement;
  ERes: TWinControl;

begin
  Result := nil;
  if (Assigned(FElements)) then
  begin
    Y := 0;
    TabIdx := 0;
    for i := 0 to FElements.Count - 1 do
    begin
      Elem := TRemDlgElement(FElements.Objects[i]);
      if (not Assigned(Elem.FParent)) then
      begin
        ERes := Elem.BuildControls(Y, TabIdx, ParentWidth, AParent, AOwner, BuildAll);
        if (not Assigned(Result)) then
          Result := ERes;
      end;
      if (Elem.ElemType = etChecked) then
        begin
          elem.SetChecked(true);
          SetPiece(Elem.FRec1, U, 4, 'S');
        end;
    end;
  end;
  if (AParent.ControlCount = 0) then
  begin
    with TVA508StaticText.Create(AOwner) do
    begin
      Parent := AParent;
      Caption := 'No Dialog found for ' + Trim(GetPrintName) + ' Reminder.';
      Left := Gap;
      Top := Gap;
    end;
  end;
  ElementChecked := nil;
end;

procedure TReminderDialog.closeReportView;
var
e, p: integer;
Element: TRemDlgElement;
prompt: TRemPrompt;
begin
  try
  if self.FElements = nil then exit;
  for e := 0 to self.FElements.Count - 1 do
    begin
      Element := TRemDlgElement(self.FElements.Objects[e]);
      if not Assigned(element.FPrompts) then continue;

      for p := 0 to Element.FPrompts.Count -1 do
        begin
          Prompt := TRemPrompt(Element.FPrompts[p]);
          if assigned(prompt.reportView) then
            begin
              if prompt.reportView.Showing then
                begin
                  prompt.reportView.Close;
                  FreeAndNil(prompt.reportView);
                end;
            end;
        end;
    end;
  finally

  end;
end;

procedure TReminderDialog.AddText(Lst: TStrings);
var
  i, idx: integer;
  Elem: TRemDlgElement;
  temp: string;

begin
  if (Assigned(FElements)) then
  begin
    idx := Lst.Count;
    for i := 0 to FElements.Count - 1 do
    begin
      Elem := TRemDlgElement(FElements.Objects[i]);
      if (not Assigned(Elem.FParent)) then
        Elem.AddText(Lst);
    end;
    if (Self is TReminder) and (PrintName <> '') and (idx <> Lst.Count) then
    begin
      temp := PrintName;
      StripScreenReaderCodes(temp);
      Lst.insert(idx, '  ' + temp + ':')
    end;
  end;
end;

function TReminderDialog.AddData(Lst: TStrings; Finishing: boolean = FALSE;
  Historical: boolean = FALSE): integer;
var
  i: integer;
  Elem: TRemDlgElement;

begin
  Result := 0;
  if (Assigned(FElements)) then
  begin
    for i := 0 to FElements.Count - 1 do
    begin
      Elem := TRemDlgElement(FElements.Objects[i]);
      if (not Assigned(Elem.FParent)) then
        inc(Result, Elem.AddData(Lst, Finishing, Historical));
    end;
  end;
end;

procedure TReminderDialog.ComboBoxCheckedText(Sender: TObject;
  NumChecked: integer; var Text: string);
var
  i, Done: integer;
  DotLen, ComLen, TxtW, TotalW, NewLen: integer;
  tmp: string;
  Fnt: THandle;
  lb: TORListBox;

begin
  if (NumChecked = 0) then
    Text := '(None Selected)'
  else if (NumChecked > 1) then
  begin
    Text := '';
    lb := (Sender as TORListBox);
    Fnt := lb.Font.Handle;
    DotLen := TextWidthByFont(Fnt, '...');
    TotalW := (lb.Owner as TControl).ClientWidth - 15;
    ComLen := TextWidthByFont(Fnt, ', ');
    dec(TotalW, (NumChecked - 1) * ComLen);
    Done := 0;
    for i := 0 to lb.Items.Count - 1 do
    begin
      if (lb.Checked[i]) then
      begin
        inc(Done);
        if (Text <> '') then
        begin
          Text := Text + ', ';
          dec(TotalW, ComLen);
        end;
        tmp := lb.DisplayText[i];
        if (Done = NumChecked) then
          TxtW := TotalW
        else
          TxtW := TotalW div (NumChecked - Done + 1);
        NewLen := NumCharsFitInWidth(Fnt, tmp, TxtW);
        if (NewLen < length(tmp)) then
          tmp := copy(tmp, 1, NumCharsFitInWidth(Fnt, tmp, (TxtW - DotLen)
            )) + '...';
        dec(TotalW, TextWidthByFont(Fnt, tmp));
        Text := Text + tmp;
      end;
    end;
  end;
end;

procedure TReminderDialog.BeginTextChanged;
begin
  inc(FTextChangedCount);
end;

procedure TReminderDialog.EndTextChanged(Sender: TObject);
begin
  if (FTextChangedCount > 0) then
  begin
    dec(FTextChangedCount);
    if (FTextChangedCount = 0) and Assigned(FOnTextChanged) then
      FOnTextChanged(Sender);
  end;
end;

function TReminderDialog.GetIEN: string;
begin
  Result := Piece(FDlgData, U, 1);
end;

function TReminderDialog.GetPrintName: string;
begin
  Result := Piece(FDlgData, U, 2);
end;

procedure TReminderDialog.BeginNeedRedraw;
begin
  inc(FNeedRedrawCount);
end;

procedure TReminderDialog.EndNeedRedraw(Sender: TObject);
begin
  if (FNeedRedrawCount > 0) then
  begin
    dec(FNeedRedrawCount);
    if (FNeedRedrawCount = 0) and (Assigned(FOnNeedRedraw)) then
      FOnNeedRedraw(Sender);
  end;
end;

procedure TReminderDialog.FinishProblems(List: TStrings;
  var MissingTemplateFields: boolean);
var
  i: integer;
  Elem: TRemDlgElement;
  TmpSL: TStringList;
  FldData: TORStringList;

begin
  if (Processing and Assigned(FElements)) then
  begin
    TmpSL := TStringList.Create;
    try
      FldData := TORStringList.Create;
      try
        for i := 0 to FElements.Count - 1 do
        begin
          Elem := TRemDlgElement(FElements.Objects[i]);
          if (not Assigned(Elem.FParent)) then
          begin
            Elem.FinishProblems(List);
            Elem.GetFieldValues(FldData);
          end;
        end;
        FNoResolve := TRUE;
        try
          AddText(TmpSL);
        finally
          FNoResolve := FALSE;
        end;
        MissingTemplateFields := AreTemplateFieldsRequired(TmpSL.Text, FldData);
      finally
        FldData.Free;
      end;
    finally
      TmpSL.Free;
    end;
  end;
end;

procedure TReminderDialog.ComboBoxResized(Sender: TObject);
begin
  // This causes the ONCheckedText event to re-fire and re-update the text,
  // based on the new size of the combo box.
  if (Sender is TORComboBox) then
    with (Sender as TORComboBox) do
      OnCheckedText := OnCheckedText;
end;

function TReminderDialog.Visible: boolean;
begin
  Result := (CurrentReminderInDialog = Self);
end;

procedure TReminderDialog.findLinkItem(elementList, promptList: TStringList; startSeq: String);
var
  a, r, p: integer;
  action: string;
  elementChange: boolean;
  Element: TRemDlgElement;
  Prompt: TRemPrompt;
  promptActedOn: TStringList;

  procedure setToDisable(Element: TRemDlgElement);
    var
    c: integer;
    tempElem: TRemDlgElement;
    begin
     if not assigned(element.FChildren) then exit;

      for c := 0 to element.FChildren.Count - 1 do
        begin
          tempElem := TRemDlgElement(element.FChildren[c]);
          tempElem.originalType := Piece(tempElem.FRec1, U, 4) + U;
          SetPiece(tempElem.FRec1, U, 4, 'H');
          setToDisable(tempElem);
        end;
    end;

   procedure setToEnable(Element: TRemDlgElement);
    var
    c: integer;
    tempElem: TRemDlgElement;
    begin
      if not assigned(element.FChildren) then exit;
      for c := 0 to element.FChildren.Count - 1 do
        begin
          tempElem := TRemDlgElement(element.FChildren[c]);
          SetPiece(tempElem.FRec1, U, 4, Piece(tempElem.originalType, U, 1));
          setToEnable(tempElem);
        end;
    end;

    function sequenceMatch(id, seq, frec1, startSeq: string): boolean;
      var
      l: integer;
      temp: string;
      begin
         if linkSeqListChecked.IndexOf(seq) = -1 then result := false
         else
          begin
            result := false;
            for l := 0 to linkSeqList.Count - 1 do
              begin
                temp := linkSeqList.Strings[l];
                if Piece(temp, u, 1) <> seq then continue;
                if (Piece(temp, u, 2) <> '') and (Piece(temp, u, 2) <> startSeq) then continue;

                if Piece(FRec1, U, 3) = Piece(temp, U, 3) then
                  begin
                    result := true;
                    exit;
                  end;
              end;

          end;

      end;

begin
  promptActedOn := TStringList.Create;
  try
    for r := 0 to Self.FElements.Count - 1 do
    begin
      elementChange := FALSE;
      Element := TRemDlgElement(Self.FElements.Objects[r]);
      if (elementList.Count > 0) then
      begin
        for a := 0 to elementList.Count - 1 do
        begin
          action := elementList.Strings[a];

          if StrToInt(Piece(Element.FRec1, U, 2)) <> StrToInt(Piece(action, U, 1))
          then
            continue;
          if (Piece(action, u, 4) <> '0') and (not sequenceMatch(Piece(action, U, 1), Piece(action, u, 4), element.FRec1, startSeq)) then continue;
  //        if (Piece(Element.FRec1, U, 3) <> Piece(action, U, 4)) and (Piece(action, U, 4) <> '') then
  //          continue;

          if (Piece(action, U, 2) = 'CHECKED') and (not Element.isChecked) then
          begin
            TResponsiveGUI.ProcessMessages;
            Element.SetChecked(TRUE);
            elementChange := TRUE;
          end
          else if Piece(action, U, 2) = 'SUPPRESS' then
          begin
            TResponsiveGUI.ProcessMessages;
            if Piece(Element.FRec1, U, 4) <> 'D' then
            begin
              SetPiece(Element.FRec1, U, 4, 'D');
              Element.SetChecked(TRUE);
              elementChange := TRUE;
            end;
          end
          else if (Piece(action, U, 2) = 'UNCHECKED') and (Element.isChecked) then
          begin
            TResponsiveGUI.ProcessMessages;
            Element.SetChecked(FALSE);
            elementChange := TRUE;
          end
          else if (Piece(action, U, 2) = 'UNSUPPRESS') and (Piece(Element.FRec1, U, 4) = 'D') then
          begin
            TResponsiveGUI.ProcessMessages;
            SetPiece(Element.FRec1, U, 4, 'S');
            Element.SetChecked(FALSE);
            elementChange := TRUE;
          end
          else if Piece(action, U, 2) = 'DISABLE' then
            begin
              TResponsiveGUI.ProcessMessages;
              if Piece(Element.FRec1, U, 4) <> 'H' then
                begin
  //                element.originalType := Piece(Element.FRec1, U, 4);
                  if element.Checked then element.originalType := Piece(Element.FRec1, U, 4) + U + '1'
                  else element.originalType := Piece(Element.FRec1, U, 4) + U + '0';
                  SetPiece(Element.FRec1, U, 4, 'H');
                  Element.SetChecked(false);
                  setToDisable(element);
                  elementChange := True;
                end;
            end
          else if Piece(action, U, 2) = 'UNDISABLE' then
            begin
                TResponsiveGUI.ProcessMessages;
                  SetPiece(Element.FRec1, U, 4, Piece(element.originalType, U, 1));
                  if (Piece(element.originalType, U, 2)= '1') or (Piece(element.originalType, U, 1) = 'D') then element.SetChecked(true)
                  else element.SetChecked(false);
                  setToEnable(element);
                  elementChange := True;
            end
        end;
      end;
      if (Element.FPrompts = nil) then
        begin
          if elementChange then Element.linkItemRedraw(element);
          continue;
        end;
      if not Element.FChecked then
        begin
          if elementChange then Element.linkItemRedraw(element);
          continue;
        end;
      if promptList.Count > 0 then
      begin
        for p := 0 to Element.FPrompts.Count - 1 do
        begin
          Prompt := TRemPrompt(Element.FPrompts[p]);
          for a := 0 to promptList.Count - 1 do
          begin
            action := promptList.Strings[a];
            if StrToInt(Piece(Prompt.FRec4, U, 2)) <> StrToInt(Piece(action, U, 1))
            then
              continue;
            if (Piece(Prompt.FRec4, U, 4) <> Piece(action, U, 2)) then
              continue;
            if (Piece(action, u, 5) <> '0') and
               (not sequenceMatch(Piece(action, U, 1), Piece(action, u, 5), element.FRec1, startSeq)) then
                  continue;
            promptActedOn.Add(action);
            if (Piece(action, U, 3) = 'REQUIRED') then
            begin
              SetPiece(Prompt.FRec4, U, 10, '1');
              elementChange := TRUE;
            end
            else if (Piece(action, U, 3) = 'UNREQUIRED') then
            begin
              SetPiece(Prompt.FRec4, U, 10, '0');
              elementChange := TRUE;
            end
            else
            begin
              Prompt.SetValueFromParent(Piece(action, U, 4));
  //            Prompt.SetValue(Piece(action, U, 4));
            end;
          end;
        end;
      end;
      if elementChange and (element <> nil) and (element.FParent <> nil) then Element.linkItemRedraw(element);
    end;
    for p := 0 to promptList.Count - 1 do
    begin
      action := promptList.Strings[p];
      if (promptActedOn <> nil) and (promptActedOn.IndexOf(action) = -1) then
      begin
        if FPromptsDefaults = nil then FPromptsDefaults := TStringList.Create;
        FPromptsDefaults.Add(action);
      end;
    end;
  finally
    promptActedOn.free;
  end;
end;

{ TReminder }

constructor TReminder.Create(ARemData: string);
begin
  linkSeqList := TStringlist.Create;
  linkSeqListChecked := TStringlist.Create;
  FRemData := ARemData;
  BaseCreate;
end;

function TReminder.GetDueDateStr: string;
begin
  Result := Piece(FRemData, U, 3);
end;

function TReminder.GetIEN: string;
begin
  Result := copy(Piece(FRemData, U, 1), 2, MaxInt);
end;

function TReminder.GetLastDateStr: string;
begin
  Result := Piece(FRemData, U, 4);
end;

function TReminder.GetPrintName: string;
begin
  Result := Piece(FRemData, U, 2);
end;

function TReminder.GetPriority: integer;
begin
  Result := StrToIntDef(Piece(FRemData, U, 5), 2);
end;

function TReminder.GetStatus: string;
begin
  Result := Piece(FRemData, U, 6);
end;

{ TRemDlgElement }

function Code2DataType(Code: string): TRemDataType;
var
  idx: TRemDataType;

begin
  Result := rdtUnknown;
  for idx := low(TRemDataType) to high(TRemDataType) do
  begin
    if (Code = RemDataCodes[idx]) then
    begin
      Result := idx;
      break;
    end;
  end;
end;

function Code2PromptType(Code: string): TRemPromptType;
var
  idx: TRemPromptType;

begin
  if (Code = '') then
    Result := ptSubComment
  else if (Code = MSTCode) then
    Result := ptMST
  else
  begin
    Result := ptUnknown;
    for idx := low(TRemPromptType) to high(TRemPromptType) do
    begin
      if (Code = RemPromptCodes[idx]) then
      begin
        Result := idx;
        break;
      end;
    end;
  end;
end;

function TRemDlgElement.Add2PN: boolean;
var
  Lst: TStringList;

begin
  if (FChecked) then
  begin
    Result := (Piece(FRec1, U, 5) <> '1');
    // Suppress := (Piece(FRec1,U,1)='1');
    if (Result and (ElemType = etDisplayOnly)) then
    begin
      // Result := FALSE;
      if (Assigned(FPrompts) and (FPrompts.Count > 0)) or
        (Assigned(FData) and (FData.Count > 0)) or Result then
      begin
        Lst := TStringList.Create;
        try
          AddData(Lst, FALSE);
          Result := (Lst.Count > 0);
          if not Assigned(FData) then
            Result := TRUE;
        finally
          Lst.Free;
        end;
      end;
    end;
  end
  else
    Result := FALSE;
end;

function TRemDlgElement.Box: boolean;
begin
  Result := (Piece(FRec1, U, 19) = '1');
end;

function TRemDlgElement.BoxCaption: string;
begin
  if (Box) then
    Result := Piece(FRec1, U, 20)
  else
    Result := '';
end;

function TRemDlgElement.ChildrenIndent: integer;
begin
  Result := StrToIntDef(Piece(FRec1, U, 16), 0);
end;

function TRemDlgElement.ChildrenRequired: TRDChildReq;
var
  tmp: string;
begin
  tmp := Piece(FRec1, U, 18);
  if tmp = '1' then
    Result := crOne
  else if tmp = '2' then
    Result := crAtLeastOne
  else if tmp = '3' then
    Result := crNoneOrOne
  else if tmp = '4' then
    Result := crAll
  else
    Result := crNone;
end;

function TRemDlgElement.ChildrenSharePrompts: boolean;
begin
  Result := (Piece(FRec1, U, 17) = '1');
end;

procedure TRemDlgElement.ComponentAdded(AComponent: TComponent);
begin
  if Assigned(AComponent) then
    FNexus.NotifyOnFree(AComponent);
end;

function TRemDlgElement.contraindication: boolean;
begin
  Result := (Piece(FRec1, U, 8) = '2');
end;

destructor TRemDlgElement.Destroy;
begin
  FreeAndNil(FNexus);
  KillObj(@FFieldValues);
  KillObj(@FData, TRUE);
  KillObj(@FPrompts, TRUE);
  KillObj(@FChildren);
  FreeAndNil(FCodesList);
  inherited;
end;

function TRemDlgElement.ElemType: TRDElemType;
var
  tmp: string;

begin
  tmp := Piece(FRec1, U, 4);
  if (tmp = 'D') then
    Result := etDisplayOnly
  else if (tmp = 'T') then
    Result := etTaxonomy
  else if (tmp = 'C') then
    Result := etChecked
  else if (tmp = 'H') then
    Result := etDisable
  else
    Result := etCheckBox;
end;

function TRemDlgElement.FindingType: string;
begin
  if (ElemType = etTaxonomy) then
    Result := Piece(FRec1, U, 7)
  else
    Result := '';
end;

function TRemDlgElement.HideChildren: boolean;
begin
  Result := (Piece(FRec1, U, 15) <> '0');
end;

function TRemDlgElement.Historical: boolean;
begin
  Result := (Piece(FRec1, U, 8) = '1');
end;

function TRemDlgElement.Indent: integer;
begin
  Result := StrToIntDef(Piece(FRec1, U, 6), 0);
end;

procedure TRemDlgElement.GetData;
var
  TempSL: TStrings;
  i: integer;
  tmp, remIEN, newDataOnly, tempRPC: string;

begin
  if FHaveData then
    exit;
  if Piece(FRec1, U, 25) = '0' then
    exit;

  TempSL := TStringList.Create;
  try
    newDataOnly := Piece(Self.FRec1, U, 27);
    if (FReminder.GetDlgSL.IndexOfPieces([RPCCalled, FID, FTaxID, newDataOnly]
      ) < 0) then
    begin
      if Self.FReminder.DlgData <> '' then
        remIEN := Piece(Self.FReminder.FDlgData, U, 1)
      else
        remIEN := Piece(TReminder(Self.FReminder).FRemData, U, 1);
      if GetDialogPrompts(FID, Historical, FindingType, remIEN, TempSL,
        newDataOnly) = 0 then
        exit;
      tempRPC := RPCCalled + U + U + U + newDataOnly;
      TempSL.Add(tempRPC);
      for i := 0 to TempSL.Count - 1 do
      begin
        tmp := TempSL[i];
        SetPiece(tmp, U, 2, FID);
        SetPiece(tmp, U, 3, FTaxID);
        TempSL[i] := tmp;
      end;
      FastAddStrings(TempSL, FReminder.GetDlgSL(False));
      PurgeOldIfNeeded(ReminderDialogInfo, MAX_REMINDER_CACHE_SIZE);
    end;
    UpdateData;
  finally
    FreeAndNil(TempSL);
  end;
end;

procedure TRemDlgElement.UpdateData;
var
  Ary: array of integer;
  idx, i, j, Cnt: integer;
  TempSL: TORStringList;
  RData: TRemData;
  RPrompt, LastPrompt: TRemPrompt;
  tmp, Tmp2, choiceTmp{, data}: string;
  {InsertUCUM,} NewLine: boolean;
  dt: TRemDataType;
  pt: TRemPromptType;
  DateRange: string;
  ChoicesActiveDates: TStringList;
  ChoiceIdx: integer;
  Piece7, newDataOnly: string;
  encDt: TFMDateTime;

begin
  if FHaveData then
    exit;
  TempSL := FReminder.GetDlgSL;
  newDataOnly := Piece(self.FRec1, U, 27);
  if (TempSL.IndexOfPieces([RPCCalled, FID, FTaxID, newDataOnly]) >= 0) then
  begin
    FHaveData := TRUE;
    RData := nil;
    idx := -1;
    repeat
      idx := TempSL.IndexOfPieces(['3', FID, FTaxID], idx);
      if (idx >= 0) and (Pieces(TempSL[idx - 1], U, 1, 6) = Pieces(TempSL[idx], U, 1, 6)) then
        if pos(':', Piece(TempSL[idx], U, 7)) > 0 then // if has date ranges
        begin
          if RData <> nil then
          begin
            if (not Assigned(RData.FActiveDates)) then
              RData.FActiveDates := TStringList.Create;
            DateRange := Pieces(Piece(TempSL[idx], U, 7), ':', 2, 3);
            RData.FActiveDates.Add(DateRange);
            with RData do
            begin
              FParent := Self;
              Piece7 := Piece(Piece(TempSL[idx], U, 7), ':', 1);
              FRec3 := TempSL[idx];
              SetPiece(FRec3, U, 7, Piece7);
            end;
          end;
        end;

      if (idx >= 0) and (Pieces(TempSL[idx - 1], U, 1, 6) <> Pieces(TempSL[idx],
        U, 1, 6)) then
      begin
        dt := Code2DataType(Piece(TempSL[idx], U, r3Type));
        if (dt <> rdtUnknown) and
          ((dt <> rdtOrder) or CharInSet(CharAt(Piece(TempSL[idx], U, 11), 1),
          ['D', 'Q', 'M', 'O', 'A'])) and // AGP change 26.10 for allergy orders
          ((dt <> rdtMentalHealthTest) or MHTestsOK) then
        begin
          if (not Assigned(FData)) then
            FData := TList.Create;
          RData := TRemData(FData[FData.Add(TRemData.Create)]);
          if pos(':', Piece(TempSL[idx], U, 7)) > 0 then
          begin
            RData.FActiveDates := TStringList.Create;
            RData.FActiveDates.Add(Pieces(Piece(TempSL[idx], U, 7), ':', 2, 3));
          end;
          with RData do
          begin
            FParent := Self;
            Piece7 := Piece(Piece(TempSL[idx], U, 7), ':', 1);
            FRec3 := TempSL[idx];
            SetPiece(FRec3, U, 7, Piece7);
            // FRoot := FRec3;
            i := idx + 1;
            ChoiceIdx := 0;
            while (i < TempSL.Count) and
              (TempSL.PiecesEqual(i, ['5', FID, FTaxID])) do
            begin
              if (Pieces(TempSL[i - 1], U, 1, 6) = Pieces(TempSL[i], U, 1, 6))
              then
              begin
                if pos(':', Piece(TempSL[i], U, 7)) > 0 then
                begin
                  if (not Assigned(FChoicesActiveDates)) then
                  begin
                    FChoicesActiveDates := TList.Create;
                    ChoicesActiveDates := TStringList.Create;
                    FChoicesActiveDates.insert(ChoiceIdx, ChoicesActiveDates);
                  end;
                  TStringList(FChoicesActiveDates[ChoiceIdx])
                    .Add(Pieces(Piece(TempSL[i], U, 7), ':', 2, 3));
                end;
                inc(i);
              end
              else
              begin
                if (not Assigned(FChoices)) then
                begin
                  FChoices := TORStringList.Create;
                  if (not Assigned(FPrompts)) then
                    FPrompts := TList.Create;
                  FChoicePrompt :=
                    TRemPrompt(FPrompts[FPrompts.Add(TRemPrompt.Create(nil))]);
                  with FChoicePrompt do
                  begin
                    FParent := Self;
                    tmp := Piece(FRec3, U, 10);
                    NewLine := (tmp <> '');
                    FRec4 := '4' + U + FID + U + FTaxID + U + U +
                      BOOLCHAR[not RData.Add2PN] + U + U + 'P' + U + tmp + U +
                      BOOLCHAR[NewLine] + U + '1';
                    FData := RData;
                    FOverrideType := ptDataList;
                    InitValue;
                  end;
                end;
                tmp := TempSL[i];
                Piece7 := Piece(Piece(TempSL[i], U, 7), ':', 1);
                SetPiece(tmp, U, 7, Piece7);
                Tmp2 := Piece(Piece(tmp, U, r3Code), ':', 1);
                if (Tmp2 <> '') then
                  Tmp2 := ' (' + Tmp2 + ')';
                Tmp2 := MixedCase(Piece(tmp, U, r3Nar)) + Tmp2;
                SetPiece(tmp, U, 12, Tmp2);
                ChoiceIdx := FChoices.Add(tmp);
                if pos(':', Piece(TempSL[i], U, 7)) > 0 then
                begin
                  if (not Assigned(FChoicesActiveDates)) then
                    FChoicesActiveDates := TList.Create;
                  ChoicesActiveDates := TStringList.Create;
                  ChoicesActiveDates.Add(Pieces(Piece(TempSL[i], U, 7),
                    ':', 2, 3));
                  FChoicesActiveDates.insert(ChoiceIdx, ChoicesActiveDates);
                end
                else if Assigned(FChoicesActiveDates) then
                  FChoicesActiveDates.insert(ChoiceIdx, TStringList.Create);
                inc(i);
              end;
            end;
            choiceTmp := '';
            // agp ICD-10 modify this code to handle one valid code against encounter date if combobox contains more than one code.
            if (Assigned(FChoices)) and
              ((FChoices.Count = 1) or (FChoicesActiveDates.Count = 1)) then
            // If only one choice just pick it
            begin
              choiceTmp := FChoices[0];
            end;
            if (Assigned(FChoices)) and (Assigned(FChoicesActiveDates)) and
              (choiceTmp = '') then
            begin
              if (Assigned(FParent.FReminder.FPCEDataObj)) then
                encDt := FParent.FReminder.FPCEDataObj.DateTime
              else
                encDt := RemForm.PCEObj.VisitDateTime;
              choiceTmp := oneValidCode(FChoices, FChoicesActiveDates, encDt);
            end;
            // if(assigned(FChoices)) and (((FChoices.Count = 1) or (FChoicesActiveDates.Count = 1)) or
            // (oneValidCode(FChoices, FChoicesActiveDates, FParent.FReminder.FPCEDataObj.DateTime) = true)) then // If only one choice just pick it
            if (choiceTmp <> '') then

            begin
              if (not Assigned(RData.FActiveDates)) then
              begin
                RData.FActiveDates := TStringList.Create;
                setActiveDates(FChoices, FChoicesActiveDates,
                  RData.FActiveDates);
              end;

              FPrompts.Remove(FChoicePrompt);
              KillObj(@FChoicePrompt);
              tmp := choiceTmp;
              KillObj(@FChoices);
              Cnt := 5;
              if (Piece(FRec3, U, 9) = '') then
                inc(Cnt);
              SetLength(Ary, Cnt);
              for i := 0 to Cnt - 1 do
                Ary[i] := i + 4;
              SetPieces(FRec3, U, Ary, tmp);
              if RData.DataType = rdtStandardCode then
                SetPiece(FRec3, U, 10, piece(tmp, U, 10)); // Save Coding System
              if (not Assigned(RData.FActiveDates)) then
              begin
                RData.FActiveDates := TStringList.Create;
              end;

            end;
            if (Assigned(FChoices)) then
            begin
              for i := 0 to FChoices.Count - 1 do
                FChoices.Objects[i] := TRemPCERoot.GetRoot(RData, FChoices[i],
                  Historical);
            end
            else
              FPCERoot := TRemPCERoot.GetRoot(RData, RData.FRec3, Historical);
            if (dt = rdtVitals) then
            begin
              if (Code2VitalType(Piece(FRec3, U, 6)) <> vtUnknown) then
              begin
                if (not Assigned(FPrompts)) then
                  FPrompts := TList.Create;
                FChoicePrompt :=
                  TRemPrompt(FPrompts[FPrompts.Add(TRemPrompt.Create(nil))]);
                with FChoicePrompt do
                begin
                  FParent := Self;
                  tmp := Piece(FRec3, U, 10);
                  NewLine := FALSE;
                  // FRec4 := '4' + U + FID + U + FTaxID + U + U + BOOLCHAR[not RData.Add2PN] + U +
                  // RData.InternalValue + U + 'P' + U + Tmp + U + BOOLCHAR[SameL] + U + '1';
                  FRec4 := '4' + U + FID + U + FTaxID + U + U +
                    BOOLCHAR[not RData.Add2PN] + U + U + 'P' + U + tmp + U +
                    BOOLCHAR[NewLine] + U + '0';
                  FData := RData;
                  FOverrideType := ptVitalEntry;
                  InitValue;
                end;
              end;
            end;
            if (dt = rdtImmunization) or (dt = rdtSkinTest) then
              begin
                if not self.FImmunizationPromptCreated  then
                  begin
                    if (not Assigned(FPrompts)) then
                      FPrompts := TList.Create;
                    FChoicePrompt := TRemPrompt(FPrompts[FPrompts.Add(TRemPrompt.Create(nil))]);
                      with FChoicePrompt do
                        begin
                          FParent := Self;
                          tmp := Piece(FRec3, U, 10);
                          NewLine := FALSE;
                          FRec4 := '4' + U + FID + U + FTaxID + U + U +
                          BOOLCHAR[not RData.Add2PN] + U + U + 'P' + U + '' + U +
                          BOOLCHAR[NewLine] + U + '0';
                          FData := RData;
                          FOriginalDataRec3 := RData.FRec3;
                          if dt = rdtSkinTest then FOverrideType := ptSkinTest
                          else FOverrideType := ptImmunization;
                      end;
                      self.FImmunizationPromptCreated := true;
                  end;
              end;
              //AGP VIMM end changes

            if (dt = rdtMentalHealthTest) then
            begin
              if (not Assigned(FPrompts)) then
                FPrompts := TList.Create;
              FChoicePrompt :=
                TRemPrompt(FPrompts[FPrompts.Add(TRemPrompt.Create(nil))]);
              with FChoicePrompt do
              begin
                FParent := Self;
                tmp := Piece(FRec3, U, 10);
                NewLine := FALSE;
                // FRec4 := '4' + U + FID + U + FTaxID + U + U + BOOLCHAR[not RData.Add2PN] + U +
                // RData.InternalValue + U + 'P' + U + Tmp + U + BOOLCHAR[SameL] + U + '1';
                FRec4 := '4' + U + FID + U + FTaxID + U + U +
                  BOOLCHAR[not RData.Add2PN] + U + U + 'P' + U + tmp + U +
                  BOOLCHAR[NewLine] + U + '0';
                FData := RData;
                if ((Piece(FRec3, U, r3GAF) = '1')) and (MHDLLFound = FALSE)
                then
                begin
                  FOverrideType := ptGAF;
                  SetPiece(FRec4, U, 8, ForcedCaption + ':');
                end
                else
                  FOverrideType := ptMHTest;
              end;
            end;
          end;
        end;
      end;
    if (FCodesList <> nil) and (RData <> nil) and (RData.FRec3 <> '') then
      begin
        if (Piece(RData.FRec3, U, 4) = 'CPT') or
           (Piece(RData.FRec3, U, 4) = 'POV') or
           (Piece(RData.FRec3, U, 4) = 'SCT') then
              FCodesList.Add(RData.FRec3);
      end;

    until (idx < 0);

    LastPrompt := nil;
    idx := -1;
    repeat
      idx := TempSL.IndexOfPieces(['4', FID, FTaxID], idx);
      if (idx >= 0) then
      begin
        if Piece(TempSL[idx], U, 20) <> newDataOnly then
          continue;
        pt := Code2PromptType(Piece(TempSL[idx], U, 4));
        if (pt <> ptUnknown) and ((pt <> ptComment) or (not FHasComment)) then
        begin
          if (not Assigned(FPrompts)) then
            FPrompts := TList.Create;
          RPrompt := TRemPrompt(FPrompts[FPrompts.Add(TRemPrompt.Create(nil))]);
          with RPrompt do
          begin
            FParent := Self;
            FRec4 := TempSL[idx];
            InitValue;
            if pt = ptMagnitude then
            begin
              if assigned(FParent.FData) and (FParent.FData.Count > 0) then
              begin
                for j := 0 to FParent.FData.Count-1 do
                begin
                  if TRemData(FParent.FData[j]).DataType in MagnitudeDataTypes then
                  begin
                    RPrompt.FData := FParent.FData[j];
                    FOverrideType := ptMagnitude;
                    UpdateUCUMInfo(RPrompt.getDataType, RPrompt.FData.Code, RPrompt.getUCumData);
                    break;
                  end;
                end;
//                if Assigned(RPrompt.FData) and (RPrompt.FData.DataType = dtStandardCode) then
//                begin
//                  if (idx < (TempSL.Count-1)) then
//                    InsertUCUM := (Piece(TempSL[idx+1],U,4) <> RemPromptCodes[ptUCUMCode])
//                  else
//                    InsertUCUM := True;
//                  if InsertUCUM then
//                  begin
//                    data := '4' + U + FID + U + FTaxID + U + RemPromptCodes[ptUCUMCode] +
//                            '^1^^P^' + PromptDescriptions[ptUCUMCode] + '^1^' + Piece(FRec4, U, 10);
//                    TempSL.Insert(idx+1,data);
//                  end;
//                  LastPrompt := RPrompt;
//                end;
              end;
            end;
            if pt = ptUCUMCode then
            begin
              FUCUMPrompt := LastPrompt;
              LastPrompt := nil;
            end;
          end;
          if (pt = ptComment) then
          begin
            FHasComment := TRUE;
            FCommentPrompt := RPrompt;
          end;
          if (pt = ptSubComment) then
            FHasSubComments := TRUE;
          if (pt = ptMST) then
            FMSTPrompt := RPrompt;
        end;
      end;
    until (idx < 0);

    idx := -1;
    repeat
      idx := TempSL.IndexOfPieces(['6', FID, FTaxID], idx);
      if (idx >= 0) then
      begin
        if Piece(TempSL[idx], U, 5) <> newDataOnly then
          continue;
        PrepText4NextLine(FPNText);
        FPNText := FPNText + Trim(Piece(TempSL[idx], U, 4));
      end;
    until (idx < 0);
    ExpandTIUObjects(FPNText, RemForm.PCEObj.VisitString);
  end;
end;

procedure TRemDlgElement.SetChecked(const Value: boolean);
var
  i, j, k: integer;
  Kid: TRemDlgElement;
  Prompt: TRemPrompt;
  RData: TRemData;
  linkItem, linkAction, linkType, linkSeq: String;
  elementList, promptList: TStringList;

  procedure UpdateForcedValues(Elem: TRemDlgElement);
  var
    i: integer;

  begin
    if (Elem.IsChecked) then
    begin
      if (Assigned(Elem.FPrompts)) then
      begin
        for i := 0 to Elem.FPrompts.Count - 1 do
        begin
          Prompt := TRemPrompt(Elem.FPrompts[i]);
          if Prompt.Forced then
          begin
            try
              Prompt.SetValueFromParent(Prompt.FValue);
            except
              on E: EForcedPromptConflict do
              begin
                Elem.FChecked := FALSE;
                InfoBox(E.Message, 'Error', MB_OK or MB_ICONERROR);
                break;
              end
              else
                raise;
            end;
          end;
        end;
      end;
      if (Elem.FChecked) and (Assigned(Elem.FChildren)) then
        for i := 0 to Elem.FChildren.Count - 1 do
          UpdateForcedValues(TRemDlgElement(Elem.FChildren[i]));
    end;
  end;

begin
  if (FChecked <> Value) then
  begin

    FChecked := Value;
    if (Value) then
    begin
      GetData;
      if (FChecked and Assigned(FParent)) then
      begin
        FParent.Check4ChildrenSharedPrompts;
        if (FParent.ChildrenRequired in [crOne, crNoneOrOne]) then
        begin
          for i := 0 to FParent.FChildren.Count - 1 do
          begin
            Kid := TRemDlgElement(FParent.FChildren[i]);
            if (Kid <> Self) and (Kid.FChecked) then
              Kid.SetChecked(FALSE);
          end;
        end;
      end;
      UpdateForcedValues(Self);
    end
    else if (Assigned(FPrompts) and Assigned(FData)) then
    begin
      for i := 0 to FPrompts.Count - 1 do
      begin
        Prompt := TRemPrompt(FPrompts[i]);
        if Prompt.Forced and (IsSyncPrompt(Prompt.PromptType)) then
        begin
          for j := 0 to FData.Count - 1 do
          begin
            RData := TRemData(FData[j]);
            if (Assigned(RData.FPCERoot)) then
              RData.FPCERoot.UnSync(Prompt);
            if (Assigned(RData.FChoices)) then
            begin
              for k := 0 to RData.FChoices.Count - 1 do
              begin
                if (Assigned(RData.FChoices.Objects[k])) then
                  TRemPCERoot(RData.FChoices.Objects[k]).UnSync(Prompt);
              end;
            end;
          end;
        end;
      end;
    end;
    try
      begin
        elementList := TStringList.Create;
        promptList := TStringList.Create;
        linkItem := Piece(Self.FRec1, U, 22);
        linkType := Piece(Self.FRec1, U, 23);
        linkAction := Piece(Self.FRec1, U, 24);
        linkSeq := Piece(self.FRec1, u, 28);
        if (linkItem <> '') and (linkAction <> '') and (linkType <> '') then
          begin
            if linkType = 'ELEMENT' then
              begin
                if value then elementList.Add(linkItem + U + LINKACTION + U + U + linkSeq)
                else elementList.Add(linkItem + U + 'UN'+linkAction + U + U + linkSeq);
              end
            else if linkAction= 'REQUIRED' then  promptList.Add(linkItem + U + linkType + U + 'REQUIRED')
            else promptList.Add(linkItem + U + linkType + U + 'VALUE' + U + linkAction);
            if buildLinkSeq(linkSeq, self.FID, Piece(self.FRec1, u, 3)) then
              self.FReminder.findLinkItem(elementList, promptList, Piece(self.FRec1, u, 3));
          end;
      end;
    finally
      if elementList <> nil then FreeAndNil(elementList);
      if promptList <> nil then  FreeAndNil(promptList);
    end;
  end;
end;

function TRemDlgElement.TrueIndent: integer;
var
  Prnt: TRemDlgElement;
  Nudge: integer;

begin
  Result := Indent;
  Nudge := Gap;
  Prnt := FParent;
  while Assigned(Prnt) do
  begin
    if (Prnt.Box) then
    begin
      Prnt := nil;
      inc(Nudge, Gap);
    end
    else
    begin
      Result := Result + Prnt.ChildrenIndent;
      Prnt := Prnt.FParent;
    end;
  end;
  Result := (Result * IndentMult) + Nudge;
end;

procedure TRemDlgElement.cbClicked(Sender: TObject);
var
  i: integer;
  robj: TResyncObj;
  chk: TORCheckBox;

begin
  chk := (Sender as TORCheckBox);
  if IgnoreReminderClicks then
  begin
    if not assigned(RemDlgResyncElements) then
      RemDlgResyncElements := TObjectList<TResyncObj>.Create
    else
    begin
      for i := 0 to RemDlgResyncElements.Count - 1 do
        with RemDlgResyncElements[i] do
          if (cb = chK) and (elem = Self) then
            exit;
    end;
    robj := TResyncObj.Create;
    robj.cb := chk;
    robj.elem := Self;
    RemDlgResyncElements.Add(robj);
    exit;
  end;
  FReminder.BeginTextChanged;
  try
    FReminder.BeginNeedRedraw;
    try
      if (Assigned(Sender)) then
      begin
        SetChecked(chk.Checked);
        ElementChecked := Self;
      end;
    finally
      FReminder.EndNeedRedraw(Sender);
    end;
  finally
    FReminder.EndTextChanged(Sender);
  end;
  RemindersInProcess.Notifier.Notify;
  if Assigned(chk.Associate) and (not ScreenReaderSystemActive)
  then
    if self.FInitialChecked then
      self.FInitialChecked := false
    else FReminder.DoFocus(TDlgFieldPanel(chk.Associate));
end;

function TRemDlgElement.EnableChildren: boolean;
var
  Chk: boolean;

begin
  if (Assigned(FParent)) then
    Chk := FParent.EnableChildren
  else
    Chk := TRUE;
  if (Chk) then
  begin
    if (ElemType = etDisplayOnly) then
      Result := TRUE
    else if (ElemType = etChecked) then
      Result := True
    else if (ElemType = etDisable) then
      Result := false
    else
      Result := FChecked;
  end
  else
    Result := FALSE;
end;

function TRemDlgElement.Enabled: boolean;
begin
  if (Assigned(FParent)) then
    Result := FParent.EnableChildren
  else
    Result := TRUE;
end;

function TRemDlgElement.ShowChildren: boolean;
begin
  if (Assigned(FChildren) and (FChildren.Count > 0)) then
  begin
    if ((ElemType = etDisplayOnly) or FChecked) then
      Result := TRUE
    else
      Result := (not HideChildren);
  end
  else
    Result := FALSE;
end;

type
  TAccessCheckBox = class(TORCheckBox);

procedure TRemDlgElement.cbEntered(Sender: TObject);
begin
  // changing focus because of a mouse click sets ClicksDisabled to false during the
  // call to SetFocus - this is how we allow the cbClicked code to execute on a mouse
  // click, which will set the focus after the mouse click.  All other cases and the
  // ClicksDisabled will be FALSE and the focus is reset here.  If we don't make this
  // check, you can't click on the check box..
  if (Last508KeyCode = VK_UP) or (Last508KeyCode = VK_LEFT) then
  begin
    UnfocusableControlEnter(nil, Sender);
    exit;
  end;
  if not TAccessCheckBox(Sender).ClicksDisabled then
  begin
    if ScreenReaderSystemActive then
      (Sender as TCPRSDialogParentCheckBox).FocusOnBox := TRUE
    else FReminder.DoFocus(TDlgFieldPanel(TORCheckBox(Sender).Associate));
  end;
end;

procedure TRemDlgElement.ParentCBEnter(Sender: TObject);
begin
  (Sender as TORCheckBox).FocusOnBox := TRUE;
end;

procedure TRemDlgElement.ParentCBExit(Sender: TObject);
begin
  (Sender as TORCheckBox).FocusOnBox := FALSE;
end;

function TRemDlgElement.refused: boolean;
begin
  Result := (Piece(FRec1, U, 8) = '3');
end;

type
  TORExposedWinControl = class(TWinControl);

function TRemDlgElement.BuildControls(var Y, TabIdx: integer; ParentWidth: integer;
  BaseParent, AOwner: TWinControl; BuildAll: boolean): TWinControl;
var
  lbl, UCUMlbl: TLabel;
  lblText: string;
  sLbl: TCPRSDialogStaticLabel;
  lblCtrl: TControl;
  pnl: TDlgFieldPanel;
  AutoFocusControl: TWinControl;
  cb: TCPRSDialogParentCheckBox;
  gb: TGroupBox;
  ERes, Prnt: TWinControl;
  PrntWidth: integer;
  i, X, Y1, TabIdx1: integer;
  LastX, MinX, MaxX: integer;
  Prompt: TRemPrompt;
  ctrl: TMultiClassObj;
  OK, DoLbl, HasVCombo, cbSingleLine: boolean;
  ud: TUpDown;
  HelpBtn: TButton;
  vCombo: TComboBox;
  pt: TRemPromptType;
  SameLineCtrl: TList;
  Kid: TRemDlgElement;
  vt: TVitalType;
  Req: boolean;
  isDisable: boolean;
  isNewList: TList;

  function isNew(obj: TObject): boolean;
  begin
    Result := (isNewList.IndexOf(obj) >= 0);
  end;

  procedure SetTabOrder(AControl: TControl);
  begin
    if AControl is TWinControl then
    begin
      TWinControl(AControl).TabOrder := TabIdx;
      inc(TabIdx);
    end;
  end;

  function GetPanel(const EID, AText: string; const PnlWidth: integer;
    OwningCheckBox: TCPRSDialogParentCheckBox): TDlgFieldPanel;
  var
    idx, p: integer;
    Entry: TTemplateDialogEntry;

  begin
    // This call creates a new TTemplateDialogEntry if necessary and creates the
    // necessary template field controls with their default values stored in the
    // TTemplateField object.
    Entry := GetDialogEntry(BaseParent,
      EID + IntToStr(integer(BaseParent)), AText);
    Entry.InternalID := EID;
    // This call looks for the Entry's values in TRemDlgElement.FFieldValues
    idx := FFieldValues.IndexOfPiece(EID);
    // If the Entry's values were found in the previous step then they will be
    // restored to the TTemplateDialogEntry.FieldValues in the next step.
    if (idx >= 0) then
    begin
      p := pos(U, FFieldValues[idx]);
      // Can't use Piece because 2nd piece may contain ^ characters
      if (p > 0) then
        Entry.FieldValues := copy(FFieldValues[idx], p + 1, MaxInt);
    end
    else
      begin
        if ((OwningCheckBox = nil) or (OwningCheckBox.Checked = true)) and (Entry.FieldValues <> '') then
        FFieldValues.Add(Entry.InternalID + U + Entry.FieldValues);
//        if (OwningCheckBox.Checked = true) and (Entry.FieldValues <> '') then
//        FFieldValues.Add(Entry.InternalID + U + Entry.FieldValues);
      end;
    Entry.AutoDestroyOnPanelFree := TRUE;
    // The FieldPanelChange event handler is where the Entry.FieldValues are saved to the
    // Element.FFieldValues.
    Entry.OnChange := FieldPanelChange;
    // Calls TTemplateDialogEntry.SetFieldValues which calls
    // TTemplateDialogEntry.SetControlText to reset the template field default
    // values to the values that were restored to the Entry from the Element if
    // they exist, otherwise the default values will remain.
    Result := Entry.GetPanel(PnlWidth, BaseParent, OwningCheckBox);
    SetTabOrder(Result);
  end;

  procedure NextLine(var Y: integer);
  var
    i: integer;
    MaxY: integer;
    C: TControl;

  begin
    MaxY := 0;
    for i := 0 to SameLineCtrl.Count - 1 do
    begin
      C := TControl(SameLineCtrl[i]);
      if (MaxY < C.Height) then
        MaxY := C.Height;
    end;
    for i := 0 to SameLineCtrl.Count - 1 do
    begin
      C := TControl(SameLineCtrl[i]);
      if (MaxY > C.Height) then
        C.Top := Y + ((MaxY - C.Height) div 2);
    end;
    inc(Y, MaxY);
    if Assigned(cb) and Assigned(pnl) then
      cb.Top := pnl.Top;
    SameLineCtrl.Clear;
  end;

  function GetControl(AName: String; cls: TControlClass; AOwner: TComponent;
    AParent: TWinControl): TControl;
  var
    info: TControlInfo;

  begin
    info := Prompt.ControlInfo(AName);
    if assigned(info) then
    begin
      if (info.MinWidth > 0) then
        MinX := info.MinWidth;
      if (info.MaxWidth > 0) then
        MaxX := info.MaxWidth;
    end
    else
    begin
      info := Prompt.CreateControlInfo(AName, cls, AOwner, AParent);
      if assigned(info) then
        isNewList.Add(info.Control)
      else
      begin
        Result := nil;
        exit;
      end;
    end;
    Result := info.Control;
    SetTabOrder(Result);
  end;

  procedure SetMinMax(AMinX: integer; AMaxX: integer = 0);
  var
    info: TControlInfo;

  begin
    if (AMinX > 0) or (AMaxX > 0) then
    begin
      info := Prompt.ControlInfo(Ctrl.ctrl);
      if assigned(info) then
      begin
        if AMinX > 0 then
          info.MinWidth := AMinX;
        if AMaxX > 0 then
          info.MaxWidth := AMaxX;
      end;
      if AMinX > 0 then
        MinX := AMinX;
      if AMaxX > 0 then
        MaxX := AMaxX;
    end;
  end;

  procedure ProcessLabel(Required, AEnabled: boolean; AParent: TWinControl;
    Control: TControl);
  begin
    if (Trim(Prompt.Caption) = '') and (not Required) then
      lblCtrl := nil
    else
    begin
      if ScreenReaderSystemActive then
      begin
        slbl := GetControl('srlbl', TCPRSDialogStaticLabel, AOwner, AParent)
          as TCPRSDialogStaticLabel;
        if isNew(slbl) then
        begin
          lbl := TLabel.Create(AOwner);
          try
            lbl.Parent := AParent;
            sLbl.Height := lbl.Height;
          finally
            FreeAndNil(lbl);
          end;
        end;
        lblCtrl := sLbl;
      end
      else
        lblCtrl := GetControl('plbl', TLabel, AOwner, AParent) as TLabel;
      if isNew(lblCtrl) then
      begin
        lblText := Prompt.Caption;
        if Required then
        begin
          if Assigned(Control) and Supports(Control, ICPRSDialogComponent) then
          begin
            (Control as ICPRSDialogComponent).RequiredField := TRUE;
            if ScreenReaderSystemActive and (AOwner = frmRemDlg) then
              frmRemDlg.amgrMain.AccessText[sLbl] := lblText;
          end;
          lblText := lblText + ' *';
        end;
        SetStrProp(lblCtrl, CaptionProperty, lblText);
        if ScreenReaderSystemActive then
        begin
          ScreenReaderSystem_CurrentLabel(sLbl);
          ScreenReaderSystem_AddText(lblText);
        end;
        UpdateColorsFor508Compliance(lblCtrl);
      end;
      if (lblCtrl is TWinControl) and (Control is TWinControl) then
      begin
        TWinControl(lblCtrl).TabOrder := TWinControl(Control).TabOrder;
        inc(TabIdx);
      end;
      lblCtrl.Enabled := AEnabled;
    end;
  end;

  procedure ScreenReaderSupport(Control: TWinControl);
  begin
    if ScreenReaderSystemActive then
    begin
      if Supports(Control, ICPRSDialogComponent) then
        ScreenReaderSystem_CurrentComponent(Control as ICPRSDialogComponent)
      else
        ScreenReaderSystem_Stop;
    end;
  end;

  procedure UpdatePrompt(var prompt: TRemPrompt);
  var
  action,frec4: string;
  p: integer;
  found: boolean;
  begin
    if prompt.FParent.FReminder.FPromptsDefaults = nil then exit;
    frec4 := prompt.FRec4;
    found := false;
    for p := 0 to prompt.FParent.FReminder.FPromptsDefaults.Count -1 do
      begin
        action := prompt.FParent.FReminder.FPromptsDefaults.Strings[p];
        if ((Piece(FRec4, U, 4) <> Piece(action, U, 2))) or
        (Piece(FRec4, U, 2) <> Piece(action, U, 1)) then continue;
        if (Piece(action, U, 3) = 'REQUIRED') then
          begin
            SetPiece(Prompt.FRec4, U, 10, '1');
          end
          else if (Piece(action, U, 3) = 'UNREQUIRED') then
          begin
            SetPiece(Prompt.FRec4, U, 10, '0');
          end
          else
          begin
            Prompt.SetValueFromParent(Piece(action, U, 4));
//            SetPiece(Prompt.FRec4, U, 6 ,(Piece(action, U, 4)));
          end;
          found := true;
//        prompt.FParent.FReminder.FPromptsDefaults.Delete(p);
      end;
//      if prompt.FParent.FReminder.FPromptsDefaults.Count = 0 then
      if found then
        FreeAndNil(prompt.FParent.FReminder.FPromptsDefaults);
  end;

  procedure AddPrompts(Shared: boolean; AParent: TWinControl; PWidth: integer;
    var Y: integer);
  var
    idx64: Int64;
    i, j, k, idx: integer;
    textArr, DefLoc: TStrings;
    LocText, text, isReq: string;
    LocFound: boolean;
    M, n,t: integer;
    ActDt, InActDt: Double;
    encDt: TFMDateTime;
    ActChoicesSL: TORStringList;
    Piece12, WHReportStr, TMP: String;
    FirstX, WrapLeft, LineWidth: integer;

  begin
    ActChoicesSL := nil;
    SameLineCtrl := TList.Create;
    try
      if (Assigned(cb)) then
      begin
        if (not Shared) then
        begin
          SameLineCtrl.Add(cb);
          SameLineCtrl.Add(pnl);
        end;
        if (cbSingleLine and (not Shared)) then
          LastX := cb.Left + pnl.Width + PromptGap + IndentGap
        else
          LastX := PWidth;
      end
      else
      begin
        if (not Shared) then
          SameLineCtrl.Add(pnl);
        LastX := PWidth;
      end;
      if (Assigned(cb)) then
        FirstX := cb.Left + NewLinePromptGap
      else
        FirstX := pnl.Left + NewLinePromptGap;
      for i := 0 to FPrompts.Count - 1 do
      begin
        Prompt := TRemPrompt(FPrompts[i]);
        UpdatePrompt(prompt);
        OK := ((Prompt.FIsShared = Shared) and Prompt.PromptOK and
          (not Prompt.Forced));
        if (OK and Shared) then
        begin
          OK := FALSE;
          for j := 0 to Prompt.FSharedChildren.Count - 1 do
          begin
            Kid := TRemDlgElement(Prompt.FSharedChildren[j]);
            if (Kid.FChecked) then
            begin
              OK := TRUE;
              break;
            end;
          end;
        end;
        ctrl.ctrl := nil;
        ud := nil;
        HelpBtn := nil;
        vCombo := nil;
        HasVCombo := FALSE;
        if (OK) then
        begin
          pt := Prompt.PromptType;
          MinX := 0;
          MaxX := 0;
          lbl := nil;
          UCUMlbl := nil;
          sLbl := nil;
          lblCtrl := nil;
          DoLbl := Prompt.Required;
          case pt of
            ptPDMP: // PDMP Button on Dialog
              begin
                ctrl.btn := GetControl('btn', TCPRSDialogButton,
                  AOwner, AParent) as TCPRSDialogButton;
                if isNew(ctrl.btn) then
                begin
                  ctrl.btn.Caption := prompt.ForcedCaption;
                  ctrl.btn.OnClick := prompt.DoPDMP;
                  MinX := TextWidthByFont(ctrl.btn.Font.Handle,ctrl.btn.Caption) + 20;
                  if MinX < 120 then
                    MinX := 120;
                  SetMinMax(MinX);
                end;
                doLbl := False;
              end;

            ptUCUMCode:
              begin
                doLbl := True;
                ctrl.cbo := GetControl('cbo', TCPRSDialogComboBox,
                  AOwner, AParent) as TCPRSDialogComboBox;
                idx64 := StrToInt64Def(Prompt.Value,0);
                if isNew(ctrl.cbo) then
                begin
                  ctrl.cbo.OnKeyDown := Prompt.ComboBoxKeyDown;
                  ctrl.cbo.Style := orcsDropDown;
                  ctrl.cbo.LongList := True;
                  ctrl.cbo.Pieces := '2';
                  ctrl.cbo.LookupPiece := 2;
                  ctrl.cbo.OnNeedData := Prompt.UCUMNeedData;
                  ctrl.cbo.InitLongList(GetUCUMText(idx64));
                  SetMinMax(TextWidthByFont(ctrl.cbo.Font.Handle,
                    'AbCdEfGhIjKlMnOpQrStUvWxYz 1234'));
                  UpdateColorsFor508Compliance(ctrl.edt);
                end;
                MaxX := PWidth;
                ctrl.cbo.OnChange := nil;
                try
                  ctrl.cbo.SelectByIEN(idx64);
                finally
                  ctrl.cbo.OnChange := Prompt.PromptChange;
                end;
              end;

            ptComment, ptQuantity, ptMagnitude:
              begin
                ctrl.edt := GetControl('edt', TCPRSDialogFieldEdit,
                  AOwner, AParent) as TCPRSDialogFieldEdit;
                ctrl.edt.OnChange := nil;
                try
                  ctrl.edt.Text := Prompt.Value;
                  if isNew(ctrl.edt) then
                  begin
                    UpdateColorsFor508Compliance(ctrl.edt);
                    if (pt = ptComment) then
                    begin
                      ctrl.edt.MaxLength := 245;
                      SetMinMax(TextWidthByFont(ctrl.edt.Font.Handle,
                        'AbCdEfGhIjKlMnOpQrStUvWxYz 1234'));
                    end
                    else if (pt = ptMagnitude) then
                    begin
                      if assigned(Prompt.FData) then
                      begin
                        ctrl.edt.UCUMCaption := Prompt.Caption;
                        ctrl.edt.Prompt := Prompt;
                        MinX := ctrl.edt.Width - LblGap;;
                        SetMinMax(MinX, MinX); // MaxX := MinX
                        ctrl.edt.ShowHint := True;
    //                    if Prompt.FData.DataType = dtStandardCode then
    //                    begin
    //                      Prompt.EditEnter2(ctrl.edt); // setup hint etc.
    //                      ctrl.edt.OnEnter := Prompt.EditEnter2;
    //                    end;
                      end;
                    end;
                  end;
                  if (pt = ptComment) then
                    MaxX := PWidth
                  else if (pt = ptMagnitude) then
                  begin
                    if assigned(Prompt.FData) then
                    begin
  //                  if Prompt.FData.DataType <> dtStandardCode then
                        UCUMlbl := GetControl('ulbl', TLabel, AOwner,
                          AParent) as TLabel;
                        if isNew(UCUMlbl) then
                        begin
                          ctrl.edt.AssociateLabel := UCUMLbl;
                          Prompt.EditEnter(ctrl.edt); // setup hint etc.
                          ctrl.edt.OnEnter := Prompt.EditEnter;
                          UpdateColorsFor508Compliance(UCUMlbl);
                        end;
  //                  end;
                      if isNew(ctrl.edt) then
                        ctrl.edt.OnExit := Prompt.EditExit;
                    end;
                  end
                  else // ptQuantity
                  begin
                    ud := GetControl('ud', TUpDown, AOwner, AParent)
                      as TUpDown;
                    if isNew(ud) then
                    begin
                      ud.Associate := ctrl.edt;
                      if (pt = ptQuantity) then
                      begin
                        ud.Min := 1;
                        ud.max := 100;
                      end
                      else
                      begin
                        ud.Min := 0;
                        ud.max := 40;
                      end;
                      SetMinMax(TextWidthByFont(ctrl.edt.Font.Handle,
                        IntToStr(ud.max)) + 24);
                      UpdateColorsFor508Compliance(ud);
                    end;
                    ud.Position := StrToIntDef(Prompt.Value, ud.Min);
                  end;
                  if isNew(ctrl.edt) then
                    ctrl.edt.OnKeyPress := Prompt.EditKeyPress;
                finally
                  if pt = ptComment then
                    begin
                      if prompt.EventType = 'E' then
                      begin
                        if isNew(Ctrl.edt) then
                          ctrl.edt.OnExit := Prompt.PromptChange;
                      end
                      else
                        ctrl.edt.OnChange := Prompt.PromptChange;
                    end
                  else
                    ctrl.edt.OnChange := Prompt.PromptChange;
                end;
                DoLbl := TRUE;
              end;

            ptVisitLocation, ptLevelUnderstanding, ptSeries, ptReaction,
              ptExamResults, ptLevelSeverity, ptSkinResults, ptSkinReading:
              begin
                ctrl.cbo := GetControl('cbo', TCPRSDialogComboBox,
                  AOwner, AParent) as TCPRSDialogComboBox;
                if isNew(ctrl.cbo) then
                begin
                  ctrl.cbo.OnKeyDown := Prompt.ComboBoxKeyDown;
                  ctrl.cbo.Style := orcsDropDown;
                  ctrl.cbo.Pieces := '2';
                  if pt = ptSkinReading then
                  begin
                    ctrl.cbo.Pieces := '1';
                    ctrl.cbo.Items.Add('');
                    for j := 0 to 50 do
                      ctrl.cbo.Items.Add(IntToStr(j));
                    GetComboBoxMinMax(ctrl.cbo, MinX, MaxX);
                  end
                  else // pt <> ptSkinReading
                  begin
                    ctrl.cbo.Tag := ComboPromptTags[pt];
                    PCELoadORCombo(ctrl.cbo, MinX, MaxX);
                  end;
                  SetMinMax(MaxX, MaxX); // MinX := MaxX;
                  if (pt = ptVisitLocation) then
                  begin
                    DefLoc := TStringList.Create;
                    try
                      if GetDefLocations(DefLoc) > 0 then
                      begin
                        idx := 1;
                        for j := 0 to DefLoc.Count - 1 do
                        begin
                          LocText := Piece(DefLoc[j], U, 2);
                          if LocText <> '' then
                          begin
                            if (LocText <> '0') and
                              (IntToStr(StrToIntDef(LocText, 0)) = LocText) then
                            begin
                              LocFound := FALSE;
                              for k := 0 to ctrl.cbo.Items.Count - 1 do
                              begin
                                if (Piece(ctrl.cbo.Items[k], U, 1) = LocText) then
                                begin
                                  LocText := ctrl.cbo.Items[k];
                                  LocFound := TRUE;
                                  break;
                                end;
                              end;
                              if not LocFound then
                                LocText := '';
                            end
                            else
                              LocText := '0^' + LocText;
                            if LocText <> '' then
                            begin
                              ctrl.cbo.Items.insert(idx, LocText);
                              inc(idx);
                            end;
                          end;
                        end;

                        if idx > 1 then
                        begin
                          ctrl.cbo.Items.insert(idx, '-1' + LLS_LINE);
                          ctrl.cbo.Items.insert(idx + 1, '-1' + LLS_SPACE);
                        end;
                      end;
                    finally
                      FreeAndNil(defLoc);
                    end
                  end;
                end;
                ctrl.cbo.OnChange := nil;
                try
                  ctrl.cbo.SelectByID(Prompt.Value);
                  if (ctrl.cbo.ItemIndex < 0) then
                  begin
                    ctrl.cbo.Text := Prompt.Value;
                    if (pt = ptVisitLocation) then
                    begin
                      if ctrl.cbo.Items.Count > 0 then
                        ctrl.cbo.Items[0] := '0' + U + Prompt.Value
                      else if isNew(ctrl.cbo) then
                        ctrl.cbo.Items.Add('0' + U + Prompt.Value);
                    end;
                  end;
                  if (ctrl.cbo.ItemIndex < 0) then
                    ctrl.cbo.ItemIndex := 0;
                  if isNew(ctrl.cbo) then
                  begin
                    ctrl.cbo.ListItemsOnly := (pt <> ptVisitLocation);
                    UpdateColorsFor508Compliance(ctrl.cbo);
                  end;
                finally
                  ctrl.cbo.OnChange := Prompt.PromptChange;
                end;
                DoLbl := TRUE;
              end;

            ptWHPapResult:
              begin
                if FData <> nil then
                begin
                  if (TRemData(FData[i]).DisplayWHResults) = TRUE then
                  begin
                    NextLine(Y);
                    ctrl.btn := GetControl('btn', TCPRSDialogButton,
                      AOwner, AParent) as TCPRSDialogButton;
                    if isNew(ctrl.btn) then
                    begin
                      ctrl.btn.OnClick := Prompt.DoWHReport;
                      ctrl.btn.Caption := 'Review complete report';
                      ctrl.btn.Width := TextWidthByFont(ctrl.btn.Font.Handle,
                        ctrl.btn.Caption) + 13;
                      ctrl.btn.Height := TextHeightByFont(ctrl.btn.Font.Handle,
                        ctrl.btn.Caption) + 8;
                      ScreenReaderSupport(ctrl.btn);
                      UpdateColorsFor508Compliance(ctrl.btn);
                    end;
                    ctrl.btn.Left := NewLinePromptGap + 15;
                    ctrl.btn.Top := Y + 7;
                    Y := ctrl.btn.Top + ctrl.btn.Height;
                    NextLine(Y);
                    ctrl.WHChk := GetControl('WHChk', TWHCheckBox,
                      AOwner, AParent) as TWHCheckBox;
                    ProcessLabel(Prompt.Required, TRUE, ctrl.WHChk.Parent,
                      ctrl.WHChk);
                    if isNew(lblCtrl) then
                      UpdateColorsFor508Compliance(lblCtrl);
                    ctrl.WHChk.Flbl := lblCtrl;
                    ctrl.WHChk.Flbl.Top := Y + 5;
                    ctrl.WHChk.Flbl.Left := NewLinePromptGap + 15;
                    WrapLeft := ctrl.WHChk.Flbl.Left;
                    Y := ctrl.WHChk.Flbl.Top + ctrl.WHChk.Flbl.Height;
                    NextLine(Y);
                    if isNew(ctrl.WHChk) then
                    begin
                      ctrl.WHChk.RadioStyle := TRUE;
                      ctrl.WHChk.GroupIndex := 1;
                      ctrl.WHChk.Caption := 'NEM (No Evidence of Malignancy)';
                      ctrl.WHChk.ShowHint := TRUE;
                      ctrl.WHChk.Hint := 'No Evidence of Malignancy';
                      ctrl.WHChk.Width := TextWidthByFont(ctrl.WHChk.Font.Handle,
                        ctrl.WHChk.Caption) + 20;
                      ctrl.WHChk.Height :=
                        TextHeightByFont(ctrl.WHChk.Font.Handle,
                        ctrl.WHChk.Caption) + 4;
                      ctrl.WHChk.OnClick := Prompt.PromptChange;
                      UpdateColorsFor508Compliance(ctrl.WHChk);
                      ScreenReaderSupport(ctrl.WHChk);
                    end;
                    ctrl.WHChk.Top := Y + 5;
                    ctrl.WHChk.Left := WrapLeft;
                    ctrl.WHChk.Checked := (WHResultChk = 'N');
                    LineWidth := WrapLeft + ctrl.WHChk.Width + 5;
                    ctrl.WHChk.Check2 := GetControl('Check2',
                      TWHCheckBox, AOwner, ctrl.WHChk.Parent) as TWHCheckBox;
                    if isNew(ctrl.WHChk.Check2) then
                    begin
                      ctrl.WHChk.Check2.RadioStyle := TRUE;
                      ctrl.WHChk.Check2.GroupIndex := 1;
                      ctrl.WHChk.Check2.Caption := 'Abnormal';
                      ctrl.WHChk.Check2.Width :=
                        TextWidthByFont(ctrl.WHChk.Check2.Font.Handle,
                        ctrl.WHChk.Check2.Caption) + 20;
                      ctrl.WHChk.Check2.Height :=
                        TextHeightByFont(ctrl.WHChk.Check2.Font.Handle,
                        ctrl.WHChk.Check2.Caption) + 4;
                      ctrl.WHChk.Check2.OnClick := Prompt.PromptChange;
                      UpdateColorsFor508Compliance(ctrl.WHChk.Check2);
                      ScreenReaderSupport(ctrl.WHChk.Check2);
                    end;
                    if (LineWidth + ctrl.WHChk.Check2.Width) > PWidth - 10 then
                    begin
                      LineWidth := WrapLeft;
                      Y := ctrl.WHChk.Top + ctrl.WHChk.Height;
                      NextLine(Y);
                    end;
                    ctrl.WHChk.Check2.Top := Y + 5;
                    ctrl.WHChk.Check2.Left := LineWidth;
                    ctrl.WHChk.Check2.Checked := (WHResultChk = 'A');
                    LineWidth := LineWidth + ctrl.WHChk.Check2.Width + 5;
                    ctrl.WHChk.Check3 := GetControl('Check3',
                      TWHCheckBox, AOwner, ctrl.WHChk.Parent) as TWHCheckBox;
                    if isNew(ctrl.WHChk.Check3) then
                    begin
                      ctrl.WHChk.Check3.RadioStyle := TRUE;
                      ctrl.WHChk.Check3.GroupIndex := 1;
                      ctrl.WHChk.Check3.Caption := 'Unsatisfactory for Diagnosis';
                      ctrl.WHChk.Check3.Width :=
                        TextWidthByFont(ctrl.WHChk.Check3.Font.Handle,
                        ctrl.WHChk.Check3.Caption) + 20;
                      ctrl.WHChk.Check3.Height :=
                        TextHeightByFont(ctrl.WHChk.Check3.Font.Handle,
                        ctrl.WHChk.Check3.Caption) + 4;
                      ctrl.WHChk.Check3.OnClick := Prompt.PromptChange;
                      UpdateColorsFor508Compliance(ctrl.WHChk.Check3);
                      ScreenReaderSupport(ctrl.WHChk.Check3);
                    end;
                    if (LineWidth + ctrl.WHChk.Check3.Width) > PWidth - 10 then
                    begin
                      LineWidth := WrapLeft;
                      Y := ctrl.WHChk.Check2.Top + ctrl.WHChk.Check2.Height;
                      NextLine(Y);
                    end;
                    ctrl.WHChk.Check3.Top := Y + 5;
                    ctrl.WHChk.Check3.Checked := (WHResultChk = 'U');
                    ctrl.WHChk.Check3.Left := LineWidth;
                    Y := ctrl.WHChk.Check3.Top + ctrl.WHChk.Check3.Height;
                    NextLine(Y);
                  end
                  else
                    DoLbl := FALSE;
                end
                else
                  DoLbl := FALSE;
              end;

            ptWHNotPurp:
              begin
                NextLine(Y);
                ctrl.WHChk := GetControl('WHChk', TWHCheckBox,
                  AOwner, AParent) as TWHCheckBox;
                ProcessLabel(Prompt.Required, TRUE, ctrl.WHChk.Parent,
                  ctrl.WHChk);
                if isNew(lblCtrl) then
                  UpdateColorsFor508Compliance(lblCtrl);
                ctrl.WHChk.Flbl := lblCtrl;
                ctrl.WHChk.Flbl.Top := Y + 7;
                ctrl.WHChk.Flbl.Left := NewLinePromptGap + 30;
                WrapLeft := ctrl.WHChk.Flbl.Left;
                LineWidth := WrapLeft + ctrl.WHChk.Flbl.Width + 10;
                if isNew(ctrl.WHChk) then
                begin
                  ctrl.WHChk.ShowHint := TRUE;
                  ctrl.WHChk.Hint := 'Letter will print with next WH batch run';
                  ctrl.WHChk.Caption := 'Letter';
                  ctrl.WHChk.Width := TextWidthByFont(ctrl.WHChk.Font.Handle,
                    ctrl.WHChk.Caption) + 25;
                  ctrl.WHChk.Height := TextHeightByFont(ctrl.WHChk.Font.Handle,
                    ctrl.WHChk.Caption) + 4;
                  ctrl.WHChk.OnClick := Prompt.PromptChange;
                  UpdateColorsFor508Compliance(ctrl.WHChk);
                  ScreenReaderSupport(ctrl.WHChk);
                end;
                if (LineWidth + ctrl.WHChk.Width) > PWidth - 10 then
                begin
                  LineWidth := WrapLeft;
                  Y := ctrl.WHChk.Flbl.Top + ctrl.WHChk.Flbl.Height;
                  NextLine(Y);
                end;
                ctrl.WHChk.Top := Y + 7;
                ctrl.WHChk.Left := LineWidth;
                ctrl.WHChk.Checked := (pos('L', WHResultNot) > 0);
                LineWidth := LineWidth + ctrl.WHChk.Width + 10;
                ctrl.WHChk.Check2 := GetControl('Check2', TWHCheckBox,
                  AOwner, ctrl.WHChk.Parent) as TWHCheckBox;
                if isNew(ctrl.WHChk.Check2) then
                begin
                  ctrl.WHChk.Check2.Caption := 'In-Person';
                  ctrl.WHChk.Check2.Width :=
                    TextWidthByFont(ctrl.WHChk.Check2.Font.Handle,
                    ctrl.WHChk.Check2.Caption) + 25;
                  ctrl.WHChk.Check2.Height :=
                    TextHeightByFont(ctrl.WHChk.Check2.Font.Handle,
                    ctrl.WHChk.Check2.Caption) + 4;
                  ctrl.WHChk.Check2.OnClick := Prompt.PromptChange;
                  UpdateColorsFor508Compliance(ctrl.WHChk.Check2);
                  ScreenReaderSupport(ctrl.WHChk.Check2);
                end;
                if (LineWidth + ctrl.WHChk.Check2.Width) > PWidth - 10 then
                begin
                  LineWidth := WrapLeft;
                  Y := ctrl.WHChk.Top + ctrl.WHChk.Height;
                  NextLine(Y);
                end;
                ctrl.WHChk.Check2.Top := Y + 7;
                ctrl.WHChk.Check2.Left := LineWidth;
                ctrl.WHChk.Check2.Checked := (pos('I', WHResultNot) > 0);
                LineWidth := LineWidth + ctrl.WHChk.Check2.Width + 10;
                ctrl.WHChk.Check3 := GetControl('Check3', TWHCheckBox,
                  AOwner, ctrl.WHChk.Parent) as TWHCheckBox;
                if isNew(ctrl.WHChk.Check3) then
                begin
                  ctrl.WHChk.Check3.Caption := 'Phone Call';
                  ctrl.WHChk.Check3.Width :=
                    TextWidthByFont(ctrl.WHChk.Check3.Font.Handle,
                    ctrl.WHChk.Check3.Caption) + 20;
                  ctrl.WHChk.Check3.Height :=
                    TextHeightByFont(ctrl.WHChk.Check3.Font.Handle,
                    ctrl.WHChk.Check3.Caption) + 4;
                  ctrl.WHChk.Check3.OnClick := Prompt.PromptChange;
                  UpdateColorsFor508Compliance(ctrl.WHChk.Check3);
                  ScreenReaderSupport(ctrl.WHChk.Check3);
                end;
                if (LineWidth + ctrl.WHChk.Check3.Width) > PWidth - 10 then
                begin
                  LineWidth := WrapLeft;
                  Y := ctrl.WHChk.Check2.Top + ctrl.WHChk.Check2.Height;
                  NextLine(Y);
                end;
                ctrl.WHChk.Check3.Top := Y + 7;
                ctrl.WHChk.Check3.Checked := (pos('P', WHResultNot) > 0);
                ctrl.WHChk.Check3.Left := LineWidth;
                Y := ctrl.WHChk.Check3.Top + ctrl.WHChk.Check3.Height;
                NextLine(Y);
                ctrl.WHChk.FButton := GetControl('FButton',
                  TCPRSDialogButton, AOwner, ctrl.WHChk.Parent) as TCPRSDialogButton;
                ctrl.WHChk.FButton.Enabled := (pos('L', WHResultNot) > 0);
                ctrl.WHChk.FButton.Left := ctrl.WHChk.Flbl.Left;
                ctrl.WHChk.FButton.Top := Y + 7;
                if isNew(ctrl.WHChk.FButton) then
                begin
                  ctrl.WHChk.FButton.OnClick := Prompt.ViewWHText;
                  ctrl.WHChk.FButton.Caption := 'View WH Notification Letter';
                  ctrl.WHChk.FButton.Width :=
                    TextWidthByFont(ctrl.WHChk.FButton.Font.Handle,
                    ctrl.WHChk.FButton.Caption) + 13;
                  ctrl.WHChk.FButton.Height :=
                    TextHeightByFont(ctrl.WHChk.FButton.Font.Handle,
                    ctrl.WHChk.FButton.Caption) + 13;
                  UpdateColorsFor508Compliance(ctrl.WHChk.FButton);
                  ScreenReaderSupport(ctrl.WHChk.FButton);
                end;

                LineWidth := ctrl.WHChk.FButton.Left + ctrl.WHChk.FButton.Width;
                if Piece(Prompt.FRec4, U, 12) = '1' then
                begin
                  ctrl.WHChk.FPrintNow := GetControl('FPrintNow',
                    TCPRSDialogCheckBox, AOwner, ctrl.WHChk.Parent) as
                    TCPRSDialogCheckBox;
                  if isNew(ctrl.WHChk.FPrintNow) then
                  begin
                    ctrl.WHChk.FPrintNow.ShowHint := TRUE;
                    ctrl.WHChk.FPrintNow.Hint :=
                      'Letter will print after "Finish" button is clicked';
                    ctrl.WHChk.FPrintNow.Caption := 'Print Now';
                    ctrl.WHChk.FPrintNow.Width :=
                      TextWidthByFont(ctrl.WHChk.FPrintNow.Font.Handle,
                      ctrl.WHChk.FPrintNow.Caption) + 20;
                    ctrl.WHChk.FPrintNow.Height :=
                      TextHeightByFont(ctrl.WHChk.FPrintNow.Font.Handle,
                      ctrl.WHChk.FPrintNow.Caption) + 4;
                    UpdateColorsFor508Compliance(ctrl.WHChk.FPrintNow);
                    ScreenReaderSupport(ctrl.WHChk.FPrintNow);
                  end;
                  if (LineWidth + ctrl.WHChk.FPrintNow.Width) > PWidth - 10 then
                  begin
                    LineWidth := WrapLeft;
                    Y := ctrl.WHChk.FButton.Top + ctrl.WHChk.FButton.Height;
                    NextLine(Y);
                  end;
                  ctrl.WHChk.FPrintNow.Left := LineWidth + 15;
                  ctrl.WHChk.FPrintNow.Top := Y + 7;
                  ctrl.WHChk.FPrintNow.Enabled := (pos('L', WHResultNot) > 0);
                  ctrl.WHChk.FPrintNow.OnClick := nil;
                  try
                    ctrl.WHChk.FPrintNow.Checked := (WHPrintDevice <> '');
                  finally
                    ctrl.WHChk.FPrintNow.OnClick := Prompt.PromptChange;
                  end;
                  MinX := PWidth;
                  if (ctrl.WHChk.FButton.Top + ctrl.WHChk.FButton.Height) >
                    (ctrl.WHChk.FPrintNow.Top + ctrl.WHChk.FPrintNow.Height)
                  then
                    Y := ctrl.WHChk.FButton.Top + ctrl.WHChk.FButton.Height + 7
                  else
                    Y := ctrl.WHChk.FPrintNow.Top +
                      ctrl.WHChk.FPrintNow.Height + 7;
                end
                else
                  Y := ctrl.WHChk.FButton.Top + ctrl.WHChk.FButton.Height + 7;
                NextLine(Y);
              end;

            ptVisitDate:
              begin
                ctrl.dt := GetControl('dt', TCPRSDialogDateCombo,
                  AOwner, AParent) as TCPRSDialogDateCombo;
                if isNew(ctrl.dt) then
                begin
                  ctrl.dt.LongMonths := TRUE;
                  UpdateColorsFor508Compliance(ctrl.dt);
                  SetMinMax(ctrl.dt.Width);
                end;
                ctrl.dt.OnChange := nil;
                try
                  ctrl.dt.FMDate := StrToFloatDef(Prompt.Value, ctrl.dt.FMDate);
                finally
                  ctrl.dt.OnChange := Prompt.PromptChange;
                end;
                DoLbl := TRUE;
              end;

            ptDate, ptDateTime:
              begin
                ctrl.date :=  GetControl('date', TCPRSDialogDateBox,
                  AOwner, AParent) as TCPRSDialogDateBox;
                if isNew(ctrl.date) then
                begin
                  if pt = ptDate then ctrl.date.DateOnly := true
                  else ctrl.date.DateOnly := false;
//                ctrl.dt.LongMonths := TRUE;
                  UpdateColorsFor508Compliance(ctrl.date);
                  SetMinMax(ctrl.date.Width);
                end;
                ctrl.date.OnChange := nil;
                try
                  tmp := Prompt.Value;
                  if tmp = 'E' then
                    begin
                      ctrl.date.FMDateTime := prompt.FParent.FReminder.PCEDataObj.DateTime;
                      prompt.Value := FloatToStr(ctrl.date.FMDateTime);
                    end
                  else
                    ctrl.date.FMDateTime := StrToFloatDef(tmp, 0);
                finally
                  if Prompt.EventType = 'E' then
                    ctrl.Date.onExit := Prompt.promptChange
                  else ctrl.date.OnChange := Prompt.PromptChange;
                end;
                DoLbl := TRUE;
              end;

            ptView, ptPrint:
              begin
                ctrl.btn := GetControl('btn', TCPRSDialogButton,
                  AOwner, AParent) as TCPRSDialogButton;
                if isNew(ctrl.btn) then
                begin
//                if Piece(prompt.FRec4, U, 12) <> 'V'  then
                  ctrl.btn.OnClick := Prompt.DoView;
//                else ctrl.btn.OnClick := prompt.PromptChange;
                  ctrl.btn.Caption := Prompt.ForcedCaption;
                  if prompt.Required then
                  begin
                    ctrl.btn.Caption := ctrl.btn.Caption + ' *';
                    (ctrl.btn as ICPRSDialogComponent).RequiredField := TRUE;
                  end;
                  SetMinMax(TextWidthByFont(ctrl.btn.Font.Handle,
                    ctrl.btn.Caption) + 13);
                  ctrl.btn.Height := TextHeightByFont(ctrl.btn.Font.Handle,
                    ctrl.btn.Caption) + 8;
                end;
                DoLbl := FALSE;
              end;

            ptPrimaryDiag, ptAdd2PL, ptContraindicated:
              begin
                ctrl.cb := GetControl('cb', TCPRSDialogCheckBox,
                  AOwner, AParent) as TCPRSDialogCheckBox;
                if isNew(ctrl.cb) then
                begin
                  ctrl.cb.OnEnter := ParentCBEnter;
                  ctrl.cb.OnExit := ParentCBExit;
                  ctrl.cb.Caption := Prompt.Caption;
                  ctrl.cb.AutoSize := FALSE;
                  ctrl.cb.Height := TORCheckBox(ctrl.cb).Height + 5;
                  ctrl.cb.Width := 17;
                  UpdateColorsFor508Compliance(ctrl.cb);
                  SetMinMax(ctrl.cb.Width);
                end;
                ctrl.cb.OnClick := nil;
                try
                  ctrl.cb.Checked := (Prompt.Value = '1');
                finally
                  ctrl.cb.OnClick := Prompt.PromptChange;
                end;
                if Prompt.Required = FALSE then
                  DoLbl := TRUE;
              end;

          else
            begin
              if (pt = ptSubComment) then
              begin
                ctrl.cb := GetControl('cb', TCPRSDialogCheckBox,
                  AOwner, AParent) as TCPRSDialogCheckBox;
                if isNew(ctrl.cb) then
                begin
                  ctrl.cb.Caption := Prompt.Caption;
                  ctrl.cb.AutoSize := TRUE;
                  ctrl.cb.Tag := integer(Prompt);
                  UpdateColorsFor508Compliance(ctrl.cb);
                  SetMinMax(ctrl.cb.Width);
                end;
                ctrl.cb.OnClick := nil;
                try
                  ctrl.cb.Checked := (Prompt.Value = '1');
                  if (ctrl.cb.Checked = false) then
                    begin
  //                    if textArr = nil then textArr := TStringList.Create;
                      text := prompt.FParent.FCommentPrompt.value;
                      if pos(ctrl.cb.Caption, text)>0 then
                        begin
                          ctrl.cb.Checked := true;
                          Prompt.Value := '1';
                        end;
                    end;
                finally
                  ctrl.cb.OnClick := SubCommentChange;
                end;
              end
              else if pt = ptVitalEntry then
              begin
                vt := Prompt.VitalType;
                if (vt = vtPain) then
                begin
                  ctrl.cbo := GetControl('cbo', TCPRSDialogComboBox,
                    AOwner, AParent) as TCPRSDialogComboBox;
                  if isNew(ctrl.cbo) then
                  begin
                    ctrl.cbo.Style := orcsDropDown;
                    ctrl.cbo.Pieces := '1,2';
                    ctrl.cbo.OnKeyDown := Prompt.ComboBoxKeyDown;
                    InitPainCombo(ctrl.cbo);
                    ctrl.cbo.ListItemsOnly := TRUE;
                    SetMinMax(TextWidthByFont(ctrl.cbo.Font.Handle,
                      ctrl.cbo.DisplayText[0]) + 24,
                      TextWidthByFont(ctrl.cbo.Font.Handle,
                      ctrl.cbo.DisplayText[1]) + 24);
                    UpdateColorsFor508Compliance(ctrl.cbo);
                  end;
                  ctrl.cbo.OnChange := nil;
                  try
                    ctrl.cbo.SelectByID(Prompt.VitalValue);
                  finally
                    ctrl.cbo.OnChange := Prompt.PromptChange;
                  end;
                  ctrl.cbo.SelLength := 0;
                  if (ElementChecked = Self) then
                  begin
                    AutoFocusControl := ctrl.cbo;
                    ElementChecked := nil;
                  end;
                end
                else
                begin
                  ctrl.vedt := GetControl('vedt', TVitalEdit, AOwner,
                    AParent) as TVitalEdit;
                  if isNew(ctrl.vedt) then
                  begin
                    SetMinMax(TextWidthByFont(ctrl.vedt.Font.Handle, '12345.67'));
                    ctrl.vedt.OnKeyPress := Prompt.EditKeyPress;
                    ctrl.vedt.OnChange := Prompt.PromptChange;
                    ctrl.vedt.OnExit := Prompt.VitalVerify;
                    UpdateColorsFor508Compliance(ctrl.vedt);
                  end;
                  if (vt in [vtTemp, vtHeight, vtWeight]) then
                  begin
                    HasVCombo := TRUE;
                    ctrl.vedt.LinkedCombo := GetControl('LinkedCombo',
                      TVitalComboBox, AOwner, AParent) as TVitalComboBox;
                    if isNew(ctrl.vedt.LinkedCombo) then
                    begin
                      ctrl.vedt.LinkedCombo.OnChange := Prompt.PromptChange;
                      ctrl.vedt.LinkedCombo.Tag := VitalControlTag(vt, TRUE);
                      ctrl.vedt.LinkedCombo.OnExit := Prompt.VitalVerify;
                      ctrl.vedt.LinkedCombo.LinkedEdit := ctrl.vedt;
                      case vt of
                        vtTemp:
                          begin
                            ctrl.vedt.LinkedCombo.Items.Add('F');
                            ctrl.vedt.LinkedCombo.Items.Add('C');
                          end;

                        vtHeight:
                          begin
                            ctrl.vedt.LinkedCombo.Items.Add('IN');
                            ctrl.vedt.LinkedCombo.Items.Add('CM');
                          end;

                        vtWeight:
                          begin
                            ctrl.vedt.LinkedCombo.Items.Add('LB');
                            ctrl.vedt.LinkedCombo.Items.Add('KG');
                          end;
                      end;
                      ctrl.vedt.LinkedCombo.Width :=
                        TextWidthByFont(ctrl.vedt.Font.Handle,
                        ctrl.vedt.LinkedCombo.Items[1]) + 30;
                      UpdateColorsFor508Compliance(ctrl.vedt.LinkedCombo);
                      SetMinMax(MinX + ctrl.vedt.LinkedCombo.Width);
                    end;
                    ctrl.vedt.LinkedCombo.SelectByID(Prompt.VitalUnitValue);
                    if (ctrl.vedt.LinkedCombo.ItemIndex < 0) then
                      ctrl.vedt.LinkedCombo.ItemIndex := 0;
                    ctrl.vedt.LinkedCombo.SelLength := 0;
                  end;
                  if (ElementChecked = Self) then
                  begin
                    AutoFocusControl := ctrl.vedt;
                    ElementChecked := nil;
                  end;
                end;
                ctrl.ctrl.Text := Prompt.VitalValue;
                if isNew(ctrl.ctrl) then
                  ctrl.ctrl.Tag := VitalControlTag(vt);
                DoLbl := TRUE;
              end
              else if pt = ptDataList then
              begin
                ctrl.cbo := GetControl('cbo', TCPRSDialogComboBox,
                  AOwner, AParent) as TCPRSDialogComboBox;
                if isNew(ctrl.cbo) then
                begin
                  ctrl.cbo.Style := orcsDropDown;
                  ctrl.cbo.Pieces := '12';
                  if ActChoicesSL = nil then
                    ActChoicesSL := TORStringList.Create;
                  if Assigned(Prompt.FData.FChoicesActiveDates)
                  then { csv active/inactive dates }
                  begin
                    if Self.Historical then
                      encDt := DateTimeToFMDateTime(Date)
                    else
                      encDt := RemForm.PCEObj.VisitDateTime;
                    for M := 0 to (Prompt.FData.FChoices.Count - 1) do
                    begin
                      for n := 0 to
                        (TStringList(Prompt.FData.FChoicesActiveDates[M])
                        .Count - 1) do
                      begin
                        ActDt := StrToIntDef
                          ((Piece(TStringList(Prompt.FData.FChoicesActiveDates[M])
                          .Strings[n], ':', 1)), 0);
                        InActDt :=
                          StrToIntDef
                          ((Piece(TStringList(Prompt.FData.FChoicesActiveDates[M])
                          .Strings[n], ':', 2)), 9999999);
                        // Piece12 := Piece(Piece(Prompt.FData.FChoices.Strings[m],U,12),':',1);
                        Piece12 := Piece(Prompt.FData.FChoices.Strings[M], U, 12);
                        Prompt.FData.FChoices.SetStrPiece(M, 12, Piece12);
                        if (encDt >= ActDt) and (encDt <= InActDt) then
                          ActChoicesSL.AddObject(Prompt.FData.FChoices[M],
                            Prompt.FData.FChoices.Objects[M]);
                      end; { loop through the TStringList object in FChoicesActiveDates[m] object property }
                    end; { loop through FChoices/FChoicesActiveDates }
                  end
                  else
                    FastAssign(Prompt.FData.FChoices, ActChoicesSL);
                  FastAssign(ActChoicesSL, ctrl.cbo.Items);
                  ctrl.cbo.CheckBoxes := TRUE;
                  ctrl.cbo.OnResize := FReminder.ComboBoxResized;
                  ctrl.cbo.ListItemsOnly := TRUE;
                  UpdateColorsFor508Compliance(ctrl.cbo);
                end;
                ctrl.cbo.OnCheckedText := nil;
                ctrl.cbo.OnChange := nil;
                try
                  ctrl.cbo.SelectByID(Prompt.Value);
                finally
                  ctrl.cbo.OnCheckedText := FReminder.ComboBoxCheckedText;
                  ctrl.cbo.CheckedString := Prompt.Value;
                  ctrl.cbo.OnChange := Prompt.PromptChange;
                end;
                if (ElementChecked = Self) then
                begin
                  AutoFocusControl := ctrl.cbo;
                  ElementChecked := nil;
                end;
                DoLbl := TRUE;
                if (Prompt.FData.FChoicesFont = ctrl.cbo.Font.Handle) then
                begin
                  if isNew(ctrl.cbo) then
                    SetMinMax(Prompt.FData.FChoicesMin, Prompt.FData.FChoicesMax)
                end
                // agp ICD-10 suppress combobox and label if no values.
                else if (ctrl.cbo.Items.Count > 0) then
                begin
                  if isNew(ctrl.cbo) then
                  begin
                    GetComboBoxMinMax(ctrl.cbo, MinX, MaxX);
                    inc(MaxX, 18); // Adjust for checkboxes
                    MinX := MaxX;
                    Prompt.FData.FChoicesFont := ctrl.cbo.Font.Handle;
                    Prompt.FData.FChoicesMin := MinX;
                    Prompt.FData.FChoicesMax := MaxX;
                    SetMinMax(MinX, MaxX);
                  end;
                end
                else
                  DoLbl := FALSE
              end
              else if (pt = ptMHTest) or ((pt = ptGAF) and (MHDLLFound = TRUE))
              then
              begin
                ctrl.btn := GetControl('btn', TCPRSDialogButton,
                  AOwner, AParent) as TCPRSDialogButton;
                if isNew(ctrl.btn) then
                begin
                  ctrl.btn.OnClick := Prompt.DoMHTest;
                  ctrl.btn.Caption := 'Perform ' + Prompt.FData.Narrative;
  //                ctrl.btn.Caption := Prompt.ForcedCaption;
                  if Piece(Prompt.FData.FRec3, U, 13) = '1' then
                  begin
                    ctrl.btn.Caption := ctrl.btn.Caption + ' *';
                    (ctrl.btn as ICPRSDialogComponent).RequiredField := TRUE;
                  end;
                  SetMinMax(TextWidthByFont(ctrl.btn.Font.Handle,
                    ctrl.btn.Caption) + 13);
                  ctrl.btn.Height := TextHeightByFont(ctrl.btn.Font.Handle,
                    ctrl.btn.Caption) + 8;
                end;
                DoLbl := false;
              end
              else if ((pt = ptGAF)) and (MHDLLFound = FALSE) then
              begin
                ctrl.edt := GetControl('edt', TCPRSDialogFieldEdit,
                  AOwner, AParent) as TCPRSDialogFieldEdit;
                ctrl.edt.OnChange := nil;
                try
                  ctrl.edt.Text := Prompt.Value;
                  ud := GetControl('ud', TUpDown, AOwner, AParent) as TUpDown;
                  if isNew(ud) then
                  begin
                    ud.Associate := ctrl.edt;
                    ud.Min := 0;
                    ud.max := 100;
                  end;
                  if isNew(ctrl.edt) then
                  begin
                    SetMinMax(TextWidthByFont(ctrl.edt.Font.Handle, IntToStr(ud.max))
                      + 24 + Gap);
                    ctrl.edt.OnKeyPress := Prompt.EditKeyPress;
                  end;
                  ud.Position := StrToIntDef(Prompt.Value, ud.Min);
                finally
                  ctrl.edt.OnChange := Prompt.PromptChange;
                end;
                if (User.WebAccess and (GAFURL <> '')) then
                begin
                  HelpBtn := GetControl('HelpBtn', TCPRSDialogButton,
                    AOwner, AParent) as TCPRSDialogButton;
                  if isNew(HelpBtn) then
                  begin
                    HelpBtn.Caption := 'Reference Info';
                    HelpBtn.OnClick := Prompt.GAFHelp;
                    HelpBtn.Width := TextWidthByFont(HelpBtn.Font.Handle,
                      HelpBtn.Caption) + 13;
                    HelpBtn.Height := ctrl.edt.Height;
                    SetMinMax(MinX + HelpBtn.Width);
                  end;
                end;
                DoLbl := TRUE;
              end
              else if (pt = ptImmunization) or (pt = ptSkinTest) then
                begin
                  ctrl.btn := GetControl('btn', TCPRSDialogButton,
                    AOwner, AParent) as TCPRSDialogButton;
                  if isNew(ctrl.btn) then
                  begin
                    ctrl.btn.OnClick := Prompt.DoVimm;
                    if assigned(Prompt.FData) and (Piece(Prompt.FData.FRec3, U, 13) = '1') then isReq := '*'
                    else isReq := '';
                    if assigned(Prompt.FData) and (Piece(Prompt.FData.FRec3, u, 10) <> '') then
                      ctrl.btn.Caption := Piece(Prompt.FData.FRec3, u, 10) + isReq
                    else if pt = ptSkinTest then ctrl.btn.Caption := 'Enter Skin Test' + isReq
                    else ctrl.btn.Caption := 'Enter Immunizations' + isReq;
  //                  if Piece(Prompt.FData.FRec3, U, 13) = '1' then
  //                    begin
  //                      ctrl.btn.Caption := ctrl.btn.Caption + ' *';
  //                      (ctrl.btn as ICPRSDialogComponent).RequiredField := TRUE;
  //                    end;
                    SetMinMax(TextWidthByFont(ctrl.btn.Font.Handle, ctrl.btn.Caption) + 13);
                    ctrl.btn.Height := TextHeightByFont(ctrl.btn.Font.Handle, ctrl.btn.Caption) + 8;
                  end;
                  DoLbl := TRUE;
                end
              else
                ctrl.ctrl := nil;
            end;
          end;

          if (DoLbl) and ((pt <> ptWHNotPurp) and (pt <> ptWHPapResult)) then
          begin
            Req := Prompt.Required;
            if (not Req) and (pt = ptGAF) and (MHDLLFound = FALSE) then
              Req := (Piece(Prompt.FData.FRec3, U, 13) = '1');
            ProcessLabel(Req, Prompt.FParent.Enabled, AParent, ctrl.ctrl);
            if Assigned(lblCtrl) then
            begin
              inc(MinX, lblCtrl.Width + LblGap);
              inc(MaxX, lblCtrl.Width + LblGap);
            end
            else
              DoLbl := FALSE;
          end;

          if (MaxX < MinX) then
            MaxX := MinX;

          if ((Prompt.SameLine) and ((LastX + MinX + Gap) < PWidth)) and
            ((pt <> ptWHNotPurp) and (pt <> ptWHPapResult)) then
          begin
            X := LastX;
          end
          else
          begin
            if (Shared) and (Assigned(FChildren)) and (FChildren.Count > 0) then
              X := TRemDlgElement(FChildren[0]).TrueIndent
            else
              X := FirstX;
            NextLine(Y);
          end;
          if (MaxX > (PWidth - X - Gap)) then
            MaxX := PWidth - X - Gap;
          if ((DoLbl) or (Assigned(ctrl.ctrl))) and
            ((pt <> ptWHNotPurp) and (pt <> ptWHPapResult)) then
          begin
            if DoLbl then
            begin
              lblCtrl.Left := X;
              lblCtrl.Top := Y;
              inc(X, lblCtrl.Width + LblGap);
              dec(MinX, lblCtrl.Width + LblGap);
              dec(MaxX, lblCtrl.Width + LblGap);
              SameLineCtrl.Add(lblCtrl);
            end;
            if (Assigned(ctrl.ctrl)) then
            begin
              if ScreenReaderSystemActive then
              begin
                if Supports(ctrl.ctrl, ICPRSDialogComponent) then
                  ScreenReaderSystem_CurrentComponent
                    (ctrl.ctrl as ICPRSDialogComponent)
                else
                  ScreenReaderSystem_Stop;
              end;
              ctrl.ctrl.Enabled := Prompt.FParent.Enabled;
              if not ctrl.ctrl.Enabled then
                ctrl.ctrl.Font.Color := DisabledFontColor
              else
                ctrl.ctrl.ParentFont := True;
              ctrl.ctrl.Left := X;
              ctrl.ctrl.Top := Y;
              LastX := ctrl.ctrl.Left + ctrl.ctrl.Width + Gap;
              SameLineCtrl.Add(ctrl.ctrl);
              if assigned(UCUMlbl) then
              begin
                if (UCUMlbl.Width + LastX) > PWidth then
                begin
                  NextLine(Y);
                  X := FirstX;
                  UCUMlbl.Left := X;
                end
                else
                  UCUMlbl.Left := X + ctrl.ctrl.Width + LblGap;
                UCUMlbl.Top := Y;
                SameLineCtrl.Add(UCUMlbl);
              end
              else if (Assigned(ud)) then
              begin
                SameLineCtrl.Add(ud);
                if (Assigned(HelpBtn)) then
                begin
                  SameLineCtrl.Add(HelpBtn);
                  ctrl.ctrl.Width := MinX - HelpBtn.Width - ud.Width;
                  HelpBtn.Left := X + ctrl.ctrl.Width + ud.Width + Gap;
                  HelpBtn.Top := Y;
                  HelpBtn.Enabled := Prompt.FParent.Enabled;
                end
                else
                  ctrl.ctrl.Width := MinX - ud.Width;
                ud.Left := X + ctrl.ctrl.Width;
                ud.Top := Y;
                LastX := X + MinX + PromptGap;
                ud.Enabled := Prompt.FParent.Enabled;
              end
              else if (HasVCombo) then
              begin
                SameLineCtrl.Add(ctrl.vedt.LinkedCombo);
                ctrl.ctrl.Width := MinX - ctrl.vedt.LinkedCombo.Width;
                ctrl.vedt.LinkedCombo.Left := X + ctrl.ctrl.Width;
                ctrl.vedt.LinkedCombo.Top := Y;
                LastX := X + MinX + PromptGap;
                ctrl.vedt.LinkedCombo.Enabled := Prompt.FParent.Enabled;
              end
              else
              begin
                ctrl.ctrl.Width := MaxX;
                LastX := X + MaxX + PromptGap;
              end;
            end;
          end;
        end;
        if (Assigned(ud)) then
          Prompt.CurrentControl := ud
        else
          Prompt.CurrentControl := ctrl.ctrl;
      end;
      NextLine(Y);
    finally
      SameLineCtrl.Free;
      ActChoicesSL.Free;
    end;

//    if Assigned(Application.MainForm) then
////      if fHasPdmp then
//         disabling access to PDMP from the main window toolbar
//        sendMessage(Application.MainForm.Handle, UM_PDMP_Disable, 0, 0)
//      else
////         enabling access to PDMP from the main window toolbar
//        sendMessage(Application.MainForm.Handle, UM_PDMP_Enable, 0, 0);

  end;

  procedure UpdatePrompts(EnablePanel: boolean; ClearCB: boolean);
  var
    i: integer;

  begin
    if EnablePanel then
    begin
      if not ScreenReaderSystemActive then
      begin
        pnl.TabStop := TRUE;
        { tab through the panels instead of the checkboxes }
        pnl.OnEnter := FieldPanelEntered;
        pnl.OnExit := FieldPanelExited;
      end;
      if ClearCB then
      begin
        cb := nil;
        FreeAndNil(FCheckBox);
      end;
    end;

    if (FChecked and Assigned(FPrompts) and (FPrompts.Count > 0)) then
    begin
      AddPrompts(FALSE, BaseParent, ParentWidth, Y);
    end
    else
    begin
      if (not FChecked) and Assigned(FPrompts) then
        for i := 0 to FPrompts.Count - 1 do
          TRemPrompt(FPrompts[i]).ClearControls;
      inc(Y, pnl.Height);
    end;
  end;

begin
  Result := nil;
  cb := nil;
  pnl := nil;
  if elemType = etDisable  then isDisable := true
//  else if assigned(fparent) and (fParent.ElemType = etDisable) then isDisable := true
  else isDisable := false;
  AutoFocusControl := nil;
  X := TrueIndent;
  isNewList := TList.Create;
  try
    if BuildAll then
    begin
      FreeAndNil(FPanel);
      FreeAndNil(FCheckBox);
      FreeAndNil(FGroupBox);
      if (Assigned(FPrompts)) then
      begin
        for i := 0 to FPrompts.Count - 1 do
          TRemPrompt(FPrompts[i]).ClearControls;
      end;
    end;
    if (ElemType = etDisplayOnly) or ((isDisable) and (Piece(originalType, U, 1) = 'D')) then
    begin
      if (FText <> '') or ((FData <> nil) and (FData.Count > 0)) then
      begin
        inc(Y, Gap);
        pnl := GetPanel(EntryID, CRLFText(FText),
            ParentWidth - X - (Gap * 2), nil);
        if assigned(FPanel) and (FPanel <> pnl) then
          FPanel.Free;
        FPanel := pnl;
        ComponentAdded(FPanel);
        pnl.Left := X;
        pnl.Top := Y;
        UpdatePrompts(ScreenReaderSystemActive, TRUE);
        if isDisable then
          pnl.Font.Color := DisabledFontColor
        else
          pnl.ParentFont := True;
      end;
    end
    else
    begin
      inc(Y, Gap);
      if not assigned(FCheckBox) then
      begin
        FCheckBox := TCPRSDialogParentCheckBox.Create(AOwner);
        ComponentAdded(FCheckBox);
      end;
      cb := FCheckBox as TCPRSDialogParentCheckBox;
      cb.Parent := BaseParent;
      SetTabOrder(cb);
      cb.Left := X;
      cb.Top := Y;
      cb.Tag := integer(Self);
      cb.WordWrap := TRUE;
      cb.AutoSize := TRUE;
      if isDisable then
        begin
          cb.checked := false;
          cb.Enabled := false;
        end
      else
        cb.Checked := FChecked;

      cb.Width := ParentWidth - X - Gap;
      if not ScreenReaderSystemActive then
        cb.Caption := CRLFText(FText);
      cb.AutoAdjustSize;
      cbSingleLine := cb.SingleLine;
      cb.WordWrap := FALSE;
      cb.Caption := ' ';
      if not ScreenReaderSystemActive then
        cb.TabStop := FALSE; { take checkboxes out of the tab order }
      pnl := GetPanel(EntryID, CRLFText(FText), ParentWidth - X - (Gap * 2) -
          IndentGap, cb);
      if assigned(FPanel) and (FPanel <> pnl) then
        FPanel.Free;
      FPanel := pnl;
      ComponentAdded(FPanel);
      pnl := FPanel as TDlgFieldPanel;
      pnl.Left := X + IndentGap;
      pnl.Top := Y;
      if (isDisable) then
        pnl.Font.Color := DisabledFontColor
      else
        pnl.ParentFont := True;
      cb.Associate := pnl;
      pnl.Tag := integer(cb); { So the panel can check the checkbox }
      cb.OnClick := cbClicked;
      cb.OnEnter := cbEntered;
      if ScreenReaderSystemActive then
        cb.OnExit := ParentCBExit;

      UpdateColorsFor508Compliance(cb);
      pnl.OnKeyPress := FieldPanelKeyPress;
      pnl.OnClick := FieldPanelOnClick;
      for i := 0 to pnl.ControlCount - 1 do
        if ((pnl.Controls[i] is TLabel) or (pnl.Controls[i] is TVA508StaticText))
          and not(fsUnderline in TLabel(pnl.Controls[i]).Font.Style) then
        // If this isn't a hyperlink change the event handler
          TLabel(pnl.Controls[i]).OnClick := FieldPanelLabelOnClick;

      if (Assigned(FParent) and (FParent.ChildrenRequired in [crOne, crNoneOrOne]))
      then
        cb.RadioStyle := TRUE;
  //    if (ElemType = etChecked)  then
  //      begin
  //        cb.Checked := true;
  //        self.FInitialChecked := true;
  //        UpdatePrompts(True, False);
  //      end
  //      else
      UpdatePrompts(TRUE, FALSE);
    end;

    if (ShowChildren) then
    begin
      gb := nil;
      if (Box) then
      begin
        if not assigned(FGroupBox) then
        begin
          FGroupBox := TGroupBox.Create(AOwner);
          ComponentAdded(FGroupBox);
        end;
        gb := FGroupBox;
        gb.Parent := BaseParent;
        SetTabOrder(gb);
        gb.Left := TrueIndent + (ChildrenIndent * IndentMult);
        gb.Top := Y;
        gb.Width := ParentWidth - gb.Left - Gap;
        PrntWidth := gb.Width - (Gap * 2);
        gb.Caption := BoxCaption;
        gb.Enabled := EnableChildren;
        if (not EnableChildren) then
          gb.Font.Color := DisabledFontColor
        else
          gb.ParentFont := True;
        UpdateColorsFor508Compliance(gb);
        Prnt := gb;
        if (gb.Caption = '') then
          Y1 := gbTopIndent
        else
          Y1 := gbTopIndent2;
      end
      else
      begin
        Prnt := BaseParent;
        Y1 := Y;
        PrntWidth := ParentWidth;
  //      if elemType = etDisable then Prnt.Enabled := false;
      end;
      TabIdx1 := 0;
      for i := 0 to FChildren.Count - 1 do
      begin
        if Box then
          ERes := TRemDlgElement(FChildren[i]).BuildControls(Y1, TabIDx1,
            PrntWidth, Prnt, AOwner, BuildAll)
        else
          ERes := TRemDlgElement(FChildren[i]).BuildControls(Y1, TabIdx,
            PrntWidth, Prnt, AOwner, BuildAll);
        if (not Assigned(Result)) then
          Result := ERes;
      end;

      if (FHasSharedPrompts) then
        AddPrompts(TRUE, Prnt, PrntWidth, Y1);

      if (Box) then
      begin
        gb.Height := Y1 + (Gap * 3);
        inc(Y, Y1 + (Gap * 4));
      end
      else
        Y := Y1;
    end
    else if not BuildAll then
      RemoveChildControls(False);

    SubCommentChange(nil);

    if (Assigned(AutoFocusControl)) then
    begin
      if (AutoFocusControl is TORComboBox) and
        (TORComboBox(AutoFocusControl).CheckBoxes) and
        (pos('1', TORComboBox(AutoFocusControl).CheckedString) = 0) then
        Result := AutoFocusControl
      else if (TORExposedControl(AutoFocusControl).Text = '') then
        Result := AutoFocusControl
    end;
    if ScreenReaderSystemActive then
      ScreenReaderSystem_Stop;
  finally
    isNewList.Free;
  end;
end;

function TRemDlgElement.buildLinkSeq(linkIEN, dialogIEN, seq: string): boolean;
var
seqList: TStrings;
idx: integer;
hasStart, found: boolean;
temp: string;
begin
  if linkIEN = '0' then
    begin
      result := true;
      exit;
    end;
  seqList := TStringList.Create;
  try
    if self.FReminder.linkSeqListChecked.IndexOf(linkIEN) = -1 then
    begin
      getLinkSeqList(seqlist, linkIEN);
      FastAssign(seqList, FReminder.linkSeqList);
//      for idx := 0 to seqList.Count - 1 do
//        self.FReminder.linkSeqList.Add(linkIEN + U + seqList.Strings[idx]);
      self.FReminder.linkSeqListChecked.Add(linkIEN);
    end;
    hasStart := false;
    found := false;
    for idx := 0 to FReminder.linkSeqList.Count - 1 do
      begin
        temp := FReminder.linkSeqList.Strings[idx];
        if Piece(temp, U, 2) <> '' then
          begin
            hasStart := true;
            if Piece(temp, U, 2) = seq then
              begin
                found := true;
                break;
              end;
          end;
      end;
    if hasStart then
      begin
        if not found then result := false
        else result := true
      end
    else result := true;
  finally
    FreeAndNil(seqList);
  end;

end;

// This is used to get the template field values if this reminder is not the
// current reminder in dialog, in which case no uEntries will exist so we have
// to get the template field values that were saved in the element.
function TRemDlgElement.GetTemplateFieldValues(const Text: string;
  FldValues: TORStringList = nil): string;
var
  flen, CtrlID, i, j: integer;
  Fld: TTemplateField;
  temp, FldName, NewTxt: string;

const
  TemplateFieldBeginSignature = '{FLD:';
  TemplateFieldEndSignature = '}';
  TemplateFieldSignatureLen = length(TemplateFieldBeginSignature);
  TemplateFieldSignatureEndLen = length(TemplateFieldEndSignature);
  FieldIDDelim = '`';
  FieldIDLen = 6;

  procedure AddNewTxt;
  begin
    if (NewTxt <> '') then
    begin
      insert(StringOfChar('x', length(NewTxt)), temp, i);
      insert(NewTxt, Result, i);
      inc(i, length(NewTxt));
    end;
  end;

begin
  Result := Text;
  temp := Text;
  repeat
    i := pos(TemplateFieldBeginSignature, temp);
    if (i > 0) then
    begin
      CtrlID := 0;
      if (copy(temp, i + TemplateFieldSignatureLen, 1) = FieldIDDelim) then
      begin
        CtrlID := StrToIntDef(copy(temp, i + TemplateFieldSignatureLen + 1,
          FieldIDLen - 1), 0);
        delete(temp, i + TemplateFieldSignatureLen, FieldIDLen);
        delete(Result, i + TemplateFieldSignatureLen, FieldIDLen);
      end;
      j := pos(TemplateFieldEndSignature,
        copy(temp, i + TemplateFieldSignatureLen, MaxInt));
      if (j > 0) then
      begin
        inc(j, i + TemplateFieldSignatureLen - 1);
        flen := j - i - TemplateFieldSignatureLen;
        FldName := copy(temp, i + TemplateFieldSignatureLen, flen);
        Fld := GetTemplateField(FldName, FALSE);
        delete(temp, i, flen + TemplateFieldSignatureLen + 1);
        delete(Result, i, flen + TemplateFieldSignatureLen + 1);
      end
      else
      begin
        delete(temp, i, TemplateFieldSignatureLen);
        delete(Result, i, TemplateFieldSignatureLen);
        Fld := nil;
      end;
      // Get the value that was entered if there is one
      if Assigned(FldValues) and (CtrlID > 0) then
      begin
        j := FldValues.IndexOfPiece(IntToStr(CtrlID));
        if not(j < 0) then
          if Fld.DateType in DateComboTypes then
            NewTxt := Piece(Piece(FldValues[j], U, 2), ':', 1)
          else
            NewTxt := Piece(FldValues[j], U, 2);
      end;
      // If nothing has been entered, use the default
      if (NewTxt = '') and Assigned(Fld) and
      // If this template field is a dftHyperlink or dftText that is
      // excluded (FSepLines = True) then don't get the default text
        not((Fld.FldType in [dftHyperlink, dftText]) and Fld.SepLines) then
        NewTxt := Fld.TemplateFieldDefault;
      AddNewTxt;
    end;
  until not(i > 0);
end;

procedure TRemDlgElement.AddText(Lst: TStrings);
var
  i, ilvl, r: integer;
  Prompt: TRemPrompt;
  txt: string;
  FldData: TORStringList;
  RData: TRemData;
begin
  if (not(FReminder is TReminder)) then
    ScootOver := 4;
  try
    if Add2PN then
    begin
      ilvl := IndentPNLevel;
      if (FPNText <> '') then
        txt := FPNText
      else
      begin
        txt := FText;
        if not FReminder.FNoResolve then
          // If this is the CurrentReminderInDialog then we get the template field
          // values from the visual control in the dialog window.
          if FReminder = CurrentReminderInDialog then
            txt := ResolveTemplateFields(CRLFText(txt), false, false, false, (ilvl + ScootOver))
          else
          // If this is not the CurrentReminderInDialog (i.e.: Next or Back button
          // has been pressed), then we have to get the template field values
          // that were saved in the element.
          begin
            FldData := TORStringList.Create;
            GetFieldValues(FldData);
            txt := GetTemplateFieldValues(txt, FldData);
          end;
      end;
      if FReminder.FNoResolve then
      begin
        StripScreenReaderCodes(txt);
        Lst.Add(txt);
      end
      else
        WordWrap(txt, Lst, ilvl);
//      dec(ilvl, 2);
      if assigned(fData) then
        begin
          for r := 0 to fData.Count - 1 do
            begin
              rdata := TRemData(fData[r]);
              if assigned(rData.vimmResult) and rData.vimmResult.isComplete = true  then
//                wordWrap(CRLF + rData.vimmResult.getNoteText.Text, Lst, ilvl);
                begin
                if (txt <> '') and (txt = CRLF) then wordWrap(txt + rData.vimmResult.getNoteText.Text, Lst, ilvl)
//                  begin
//                    if txt <> CRLF then wordWrap(txt + CRLF + rData.vimmResult.getNoteText.Text, Lst, ilvl)
//                    else wordWrap(txt + rData.vimmResult.getNoteText.Text, Lst, ilvl)
//                  end
                else
                  begin
                    wordWrap(rData.vimmResult.getNoteText.Text, Lst, ilvl)
//                    if r = 0 then wordWrap(rData.vimmResult.getNoteText.Text, Lst, ilvl)
//                    else wordWrap(CRLF + rData.vimmResult.getNoteText.Text, Lst, ilvl);
                  end;
                end;

            end;
        end;
      dec(ilvl, 2);
      if (Assigned(FPrompts)) then
      begin
        for i := 0 to FPrompts.Count - 1 do
        begin
          Prompt := TRemPrompt(FPrompts[i]);
          if (not Prompt.FIsShared) then
          begin
            if Prompt.PromptType = ptMHTest then
              WordWrap(Prompt.NoteText, Lst, ilvl, 4, TRUE)
            else
              WordWrap(Prompt.NoteText, Lst, ilvl);
          end;

        end;
      end;
      if (Assigned(FParent) and FParent.FHasSharedPrompts) then
      begin
        for i := 0 to FParent.FPrompts.Count - 1 do
        begin
          Prompt := TRemPrompt(FParent.FPrompts[i]);
          if (Prompt.FIsShared) and (Prompt.FSharedChildren.IndexOf(Self) >= 0)
          then
          begin
            // AGP Change MH dll
            if (Prompt.PromptType = ptMHTest) then
              WordWrap(Prompt.NoteText, Lst, ilvl, 4, TRUE)
            else
              WordWrap(Prompt.NoteText, Lst, ilvl);
          end;
        end;
      end;
    end;
    if (Assigned(FChildren)) and (FChecked or (ElemType = etDisplayOnly)) then
    begin
      for i := 0 to FChildren.Count - 1 do
      begin
        TRemDlgElement(FChildren[i]).AddText(Lst);
      end;
    end;
  finally
    if (not(FReminder is TReminder)) then
      ScootOver := 0;
  end;
end;

function TRemDlgElement.allCompleteResults: boolean;
var
i: integer;
remData: TRemData;
begin
  result := true;
  if not assigned(FData) then
    begin
      result := false;
    end;
  for i := 0 to FData.Count - 1 do
    begin
      remData := TRemData(self.FData[i]);
      if ((Piece(remData.FRec3, U, 4) <> 'IMM') and (Piece(remData.FRec3, U, 4) <> 'SK')) then continue;
      if (remData.vimmResult = nil) then
      begin
        if Piece(remData.FRec3, U, 8) = 'IMMUNIZATION, NO DEFAULT SELECTED' then
        begin
          if FData.count = 1 then
          begin
            result := false;
            exit;
          end
          else continue;
        end;
        result := false;
      end
      else if not remData.vimmResult.isComplete then result := false;
    end;
end;

function TRemDlgElement.AddData(Lst: TStrings; Finishing: boolean;
  AHistorical: boolean = FALSE): integer;
var
  i, j: integer;
  OK: boolean;
  ActDt, InActDt, encDt: Double;
  RData: TRemData;
  foundDone: boolean;
  newDataOnly: String;

  function findDataGroup(elem: TRemDlgElement; var foundDone: boolean): string;
    begin
      while foundDone = false do
        begin
          if Piece(elem.FParent.FRec1, U, 26) <> '' then
            begin
              result := Piece(elem.FParent.FRec1, U, 26);
              foundDone := true;
            end
          else if elem.FParent.FParent <> nil then
            begin
              result := findDataGroup(elem.FParent, foundDone);
              foundDone := true;
            end
          else begin
            result := '';
            foundDone := true;
          end;
      end;
    end;

begin
  Result := 0;
  // OK := ((ElemType <> etDisplayOnly) and FChecked);
  OK := FChecked;
  newDataOnly := Piece(self.FRec1, U, 27);
  if (OK and Finishing) then
    begin
      OK := (Historical = AHistorical);
//      if not OK then OK := FImmunizationPromptCreated = true;
    end;
  if OK then
  begin
    if (Assigned(FData)) then
    begin
      if Self.Historical then
        encDt := DateTimeToFMDateTime(Date)
      else
        encDt := RemForm.PCEObj.VisitDateTime;
      for i := 0 to FData.Count - 1 do
      begin
        RData := TRemData(FData[i]);
        if newDataOnly <> Piece(RData.FRec3, U, 16) then
          continue;
        if finishing and (Piece(RData.FRec3, U, 17) = '') and (self.FParent <> nil) then
          begin
            foundDone := false;
            setPiece(RData.FRec3, U, pnumRemGenFindGroup, findDataGroup(self, foundDone));
          end
        else if finishing and (Piece(RData.FRec3, U, 17) <> '') then
          setPiece(RData.FRec3, U, pnumRemGenFindGroup, Piece(RData.FRec3, U, 17));


        if Assigned(RData.FActiveDates) then
          for j := 0 to (TRemData(FData[i]).FActiveDates.Count - 1) do
          begin
            ActDt := StrToIntDef(Piece(TRemData(FData[i]).FActiveDates[j],
              ':', 1), 0);
            InActDt := StrToIntDef(Piece(TRemData(FData[i]).FActiveDates[j],
              ':', 2), 9999999);
            if (encDt >= ActDt) and (encDt <= InActDt) then
            begin
              inc(Result, TRemData(FData[i]).AddData(Lst, Finishing, AHistorical));
              break;
            end;
          end
        else
          inc(Result, TRemData(FData[i]).AddData(Lst, Finishing, AHistorical));
      end;
    end;
  end;
  if (Assigned(FChildren)) and (FChecked or (ElemType = etDisplayOnly)) then
  begin
    for i := 0 to FChildren.Count - 1 do
      inc(Result, TRemDlgElement(FChildren[i]).AddData(Lst, Finishing,
        AHistorical));
  end;
end;

procedure TRemDlgElement.Check4ChildrenSharedPrompts;
var
  i, j: integer;
  Kid: TRemDlgElement;
  PList, EList: TList;
  FirstMatch: boolean;
  Prompt: TRemPrompt;

begin
  if (not FChildrenShareChecked) then
  begin
    FChildrenShareChecked := TRUE;
    if (ChildrenSharePrompts and Assigned(FChildren)) then
    begin
      for i := 0 to FChildren.Count - 1 do
        TRemDlgElement(FChildren[i]).GetData;
      PList := TList.Create;
      try
        EList := TList.Create;
        try
          for i := 0 to FChildren.Count - 1 do
          begin
            Kid := TRemDlgElement(FChildren[i]);
            // if(Kid.ElemType <> etDisplayOnly) and (assigned(Kid.FPrompts)) then
            if (Assigned(Kid.FPrompts)) then
            begin
              for j := 0 to Kid.FPrompts.Count - 1 do
              begin
                PList.Add(Kid.FPrompts[j]);
                EList.Add(Kid);
              end;
            end;
          end;
          if (PList.Count > 1) then
          begin
            for i := 0 to PList.Count - 2 do
            begin
              if (Assigned(EList[i])) then
              begin
                FirstMatch := TRUE;
                Prompt := TRemPrompt(PList[i]);
                for j := i + 1 to PList.Count - 1 do
                begin
                  if (Assigned(EList[j]) and
                    (Prompt.CanShare(TRemPrompt(PList[j])))) then
                  begin
                    if (FirstMatch) then
                    begin
                      FirstMatch := FALSE;
                      if (not Assigned(FPrompts)) then
                        FPrompts := TList.Create;
                      FHasSharedPrompts := TRUE;
                      Prompt.FIsShared := TRUE;
                      if (not Assigned(Prompt.FSharedChildren)) then
                        Prompt.FSharedChildren := TList.Create;
                      Prompt.FSharedChildren.Add(EList[i]);
                      FPrompts.Add(PList[i]);
                      TRemDlgElement(EList[i]).FPrompts.Remove(PList[i]);
                      EList[i] := nil;
                    end;
                    Prompt.FSharedChildren.Add(EList[j]);
                    Kid := TRemDlgElement(EList[j]);
                    Kid.FPrompts.Remove(PList[j]);
                    if (Kid.FHasComment) and (Kid.FCommentPrompt = PList[j])
                    then
                    begin
                      Kid.FHasComment := FALSE;
                      Kid.FCommentPrompt := nil;
                    end;
                    TRemPrompt(PList[j]).Free;
                    EList[j] := nil;
                  end;
                end;
              end;
            end;
          end;
        finally
          EList.Free;
        end;
      finally
        PList.Free;
      end;
      for i := 0 to FChildren.Count - 1 do
      begin
        Kid := TRemDlgElement(FChildren[i]);
        if (Assigned(Kid.FPrompts) and (Kid.FPrompts.Count = 0)) then
        begin
          Kid.FPrompts.Free;
          Kid.FPrompts := nil;
        end;
      end;
    end;
  end;
end;

procedure TRemDlgElement.FinishProblems(List: TStrings);
var
  i, {iCode, iValue,} Cnt: integer;
  cReq: TRDChildReq;
  Kid: TRemDlgElement;
  Prompt: TRemPrompt;
  txt, Msg, Value: string;
  pt: TRemPromptType;
  required: boolean;
//  UCUMData, temp: string;
//  failed: boolean;

begin
  // if(ElemType <> etDisplayOnly) and (FChecked) and (assigned(FPrompts)) then
  if (FChecked and (Assigned(FPrompts))) then
  begin
    for i := 0 to FPrompts.Count - 1 do
    begin
      Prompt := TRemPrompt(FPrompts[i]);
      if assigned(Prompt.reportView) then
        begin
          if Prompt.reportView.Showing then
            begin
              Prompt.reportView.cmdClose.Click;
              FreeAndNil(Prompt.reportView);
            end;

//            Prompt.reportView.Close;
        end;
      Value := Prompt.GetValue;
      pt := Prompt.PromptType;
      required := false;
      if (Prompt.PromptOK and (not Prompt.Forced) and Prompt.Required and
        (((pt <> ptWHNotPurp) and (pt <> ptWHPapResult) and ((pt <> ptView) and (pt <> ptPrint))) and
        ((Value = '') or (Value = '@') or ((pt = ptPrimaryDiag) and
        (Value = '0'))) or ((pt in [ptVisitDate, ptDate, ptDateTime]) and
        Prompt.FMonthReq and (StrToIntDef(copy(Value, 4, 2), 0) = 0)) or
        ((pt in [ptVisitDate, ptVisitLocation]) and (Value = '0'))))
        then required := true
        else if Prompt.Required and ((pt = ptDate) or (pt = ptDateTime))
        then required := true;
        if (required = true) and ((pt = ptDate) or (pt = ptDateTime)) then
          begin
            if (StrToIntDef(copy(Value, 4, 2), 0) <> 0) and (StrToIntDef(copy(Value, 6, 2), 0) <> 0) then
              required := false;
          end;
//      if (Prompt.PromptOK and (not Prompt.Forced) and Prompt.Required and
//        (((pt <> ptWHNotPurp) and (pt <> ptWHPapResult)) and
//        ((Value = '') or (Value = '@') or ((pt = ptPrimaryDiag) and
//        (Value = '0'))) or ((pt in [ptVisitDate]) and
//        Prompt.FMonthReq and (StrToIntDef(copy(Value, 4, 2), 0) = 0)) or
//        ((pt in [ptVisitDate, ptVisitLocation]) and (Value = '0')))
//        or((pt = ptDate) and ((StrToIntDef(copy(Value, 4, 2), 0) = 0) or
//        (StrToIntDef(copy(Value, 6, 2), 0) = 0))))
      if required = true then
      begin
        WordWrap('Element: ' + FText, List, 68, 6);
        txt := Prompt.ForcedCaption;
        if (pt in [ptVisitDate]) and Prompt.FMonthReq then
          txt := txt + ' (Month Required)';
//        WordWrap('Item: ' + txt, List, 65, 6);
        if (pt = ptDate) then txt := txt + ' (Month and Day Required)';
        WordWrap('Item: ' + txt, List, 65, 6);
      end;
      if (pt = ptDate) then
        begin
          if ( prompt.validate = HistCode) and (StrToFloatDef(value, 0) > FMNow) then
            begin
              txt := Prompt.ForcedCaption + ' cannot have a date in the future.';
              WordWrap('Prompt: ' + txt, List, 65, 6);
            end;
          if ( prompt.validate = FutureCode) and (StrToFloatDef(value, 0) < FMNow) then
            begin
              txt := Prompt.ForcedCaption + ' cannot have a date in the past.';
              WordWrap('Prompt: ' + txt, List, 65, 6);
            end;
        end;
      if (pt = ptDateTime) and (StrToFloatDef(value, 0) < FMNOW) then
          begin
            txt := Prompt.ForcedCaption + ' cannot have a date/time in the past.';
            WordWrap('Prompt: ' + txt, List, 65, 6);
          end;

      if (Prompt.PromptOK and (not Prompt.Forced) and Prompt.Required and
        ((WHResultChk = '') and (Value = '')) and ((pt = ptWHPapResult) and
        (FData <> nil))) then
      begin
        WordWrap('Prompt: ' + Prompt.ForcedCaption, List, 65, 6);
      end;
      if (Prompt.PromptOK and (not Prompt.Forced) and Prompt.Required and
        (pt = ptWHNotPurp)) and ((WHResultNot = '') and (Value = '')) then
      begin
        WordWrap('Element: ' + FText, List, 68, 6);
        WordWrap('Prompt: ' + Prompt.ForcedCaption, List, 65, 6);
      end;
      if ((pt = ptView) or (pt = ptPrint)) and (Prompt.Required) then
        begin
          if prompt.ViewRecord then break
          else
            begin
              WordWrap('Element: ' + FText, List, 68, 6);
              WordWrap('Prompt: ' + Prompt.ForcedCaption + ' must be viewed', List, 65, 6);
            end;
        end;
      if (pt = ptMagnitude) and (Value <> '') then
        begin
          if prompt.CurrentControl is TCPRSDialogFieldEdit then
          begin
            msg := ValidateMagnitudeMessage(prompt.CurrentControl as TCPRSDialogFieldEdit);
            if msg <> '' then
            begin
              WordWrap('Element: ' + FText, List, 68, 6);
              WordWrap('Prompt: ' + Piece(msg,U,2), List, 65, 6);
            end;
          end;
//          failed := false;
//          uCUMData := Prompt.getUCumData;
//          if (StrToIntDef(Piece(uCUMData, u, 3), 0) = 0) and (POS('.', value) > 0) then
//            failed := true
//          else if (StrToIntDef(Piece(uCUMData, u, 3), 0) > 0) and (POS('.', value) > 0) then
//            begin
//              temp := Piece(value, '.', 2);
//              if Length(temp) > StrToIntDef(Piece(uCUMData, u, 3), 0) then
//                failed := true;
//            end;
//          if not failed then
//            begin
//              temp := Piece(value, '.', 1);
//              val(temp, iValue, iCode);
//              if iCode <> 0 then
//                failed := true
//              else if iValue < StrToIntDef(Piece(uCUMData, u, 1), 0) then
//                failed := true
//              else if iValue > StrToIntDef(Piece(uCUMData, u, 1), 0) then
//                failed := true;
//            end;
//          if failed then
//            begin
//              WordWrap('Element: ' + FText, List, 68, 6);
//              WordWrap('Prompt: ' + Prompt.ForcedCaption + ' ' + Prompt.buildUCUMDataText, List, 65, 6);
//            end;
        end;
      // (AGP Change 24.9 add check to see if MH tests are required)
      if ((pt = ptMHTest) or (pt = ptGAF)) and
        (StrToInt(Piece(Prompt.FData.FRec3, U, 13)) > 0) and (not Prompt.Forced)
      then
      begin
        if (Piece(Prompt.FData.FRec3, U, 13) = '2') and
          (Prompt.FMHTestComplete = 0) then
          break;
        if (pt = ptMHTest) and (Prompt.FMHTestComplete = 2) then
        begin
          if ((Prompt.FValue = '') or (pos('X', Prompt.FValue) > 0)) then
          begin
            if Prompt.FValue = '' then
              WordWrap('MH test ' + Piece(Prompt.FData.FRec3, U, 8) +
                ' not done', List, 65, 6);
            if pos('X', Prompt.FValue) > 0 then
              WordWrap('You are missing one or more responses in the MH test ' +
                Piece(Prompt.FData.FRec3, U, 8), List, 65, 6);
            WordWrap(' ', List, 65, 6);
          end;
        end;
        if (pt = ptMHTest) and (Prompt.FMHTestComplete = 0) or
          ((Prompt.FValue = '') and (pos('New MH dll', Prompt.FValue) = 0)) then
        begin
          if Prompt.FValue = '' then
            WordWrap('MH test ' + Piece(Prompt.FData.FRec3, U, 8) + ' not done',
              List, 65, 6);
          if pos('X', Prompt.FValue) > 0 then
            WordWrap('You are missing one or more responses in the MH test ' +
              Piece(Prompt.FData.FRec3, U, 8), List, 65, 6);
          WordWrap(' ', List, 65, 6);
        end;
        if (pt = ptMHTest) and (Prompt.FMHTestComplete = 0) and
          (pos('New MH dll', Prompt.FValue) > 0) then
        begin
          WordWrap('MH test ' + Piece(Prompt.FData.FRec3, U, 8) +
            ' is not complete', List, 65, 6);
          WordWrap(' ', List, 65, 6);
        end;
        if (pt = ptGAF) and ((Prompt.FValue = '0') or (Prompt.FValue = '')) then
        begin
          WordWrap('GAF test must have a score greater then zero', List, 65, 6);
          WordWrap(' ', List, 65, 6);
        end;
      end;
      if ((pt = ptImmunization) or (pt = ptSkinTest)) and ((assigned(Prompt.FData)) and (Piece(Prompt.FData.FRec3, U, 13) = '1')) then
         begin
          if not prompt.FParent.allCompleteResults then
            begin
              WordWrap('You are missing a complete Immunization/Skin Test Record', List, 65, 6);
              if assigned(Prompt.FData) and (Piece(Prompt.FData.FRec3, u, 10) <> '') then
                WordWrap(Piece(Prompt.FData.FRec3, u, 10), List, 65, 5)
              else WordWrap(Piece(Prompt.FParent.FText, u, 10), List, 65, 5);
            end;


         end;
    end;
  end;
  if (Assigned(FChildren)) and (FChecked or (ElemType = etDisplayOnly)) then
  begin
    cReq := ChildrenRequired;
    if (cReq in [crOne, crAtLeastOne, crAll]) then
    begin
      Cnt := 0;
      for i := 0 to FChildren.Count - 1 do
      begin
        Kid := TRemDlgElement(FChildren[i]);
        // if(Kid.FChecked and (Kid.ElemType <> etDisplayOnly)) then
        if (Kid.FChecked) then
          inc(Cnt);
      end;
      if (cReq = crOne) and (Cnt <> 1) then
        Msg := 'One selection required'
      else if (cReq = crAtLeastOne) and (Cnt < 1) then
        Msg := 'One or more selections required'
      else if (cReq = crAll) and (Cnt < FChildren.Count) then
        Msg := 'All selections are required'
      else
        Msg := '';
      if (Msg <> '') then
      begin
        txt := BoxCaption;
        if (txt = '') then
          txt := FText;
        WordWrap('Group: ' + txt, List, 68, 6);
        WordWrap(Msg, List, 65, 0);
        WordWrap(' ', List, 68, 6);
        // (AGP change 24.9 added blank line for display spacing)
      end;
    end;
    for i := 0 to FChildren.Count - 1 do
      TRemDlgElement(FChildren[i]).FinishProblems(List);
  end;
end;

function TRemDlgElement.IsChecked: boolean;
var
  Prnt: TRemDlgElement;

begin
  Result := TRUE;
  Prnt := Self;
  while Result and Assigned(Prnt) do
  begin
    Result := ((Prnt.ElemType = etDisplayOnly) or Prnt.FChecked);
    Prnt := Prnt.FParent;
  end;
end;

procedure TRemDlgElement.linkItemRedraw(element: TRemDlgElement);
begin
  FReminder.BeginTextChanged;
  try
    begin
    FReminder.BeginNeedRedraw;
    FReminder.EndNeedRedraw(element);
    end;
  finally
    FReminder.EndTextChanged(element);
  end;
  RemindersInProcess.Notifier.Notify;
end;

procedure TRemDlgElement.NexusFreeNotification(Sender: TObject;
  AComponent: TComponent);
begin
  if AComponent = FPanel then
    FPanel := nil
  else if AComponent = FCheckBox then
    FCheckBox := nil
  else if AComponent = FGroupBox then
    FGroupBox := nil;
end;

// agp ICD-10 add this function to scan for valid codes against encounter date.
function TRemDlgElement.oneValidCode(Choices: TORStringList;
  ChoicesActiveDates: TList; encDt: TFMDateTime): string;
var
  C, Cnt, lastItem: integer;
  Prompt: TRemPrompt;
begin
  Cnt := 0;
  Result := '';
  Prompt := TRemPrompt.Create(nil);
  try
    lastItem := 0;
    for C := 0 to Choices.Count - 1 do
    begin
      if (Prompt.CompareActiveDate(TStringList(ChoicesActiveDates[C]), encDt)
        = TRUE) then
      begin
        Cnt := Cnt + 1;
        lastItem := C;
        if (Cnt > 1) then
          break;
      end;
    end;
    if (Cnt = 1) then
      Result := Choices[lastItem];
  finally
    Prompt.Free;
  end;
end;

function TRemDlgElement.IndentChildrenInPN: boolean;
begin
  // if(Box) then
  Result := (Piece(FRec1, U, 21) = '1');
  // else
  // Result := FALSE;
end;

function TRemDlgElement.IndentPNLevel: integer;
begin
  if (Assigned(FParent)) then
  begin
    Result := FParent.IndentPNLevel;
    if (FParent.IndentChildrenInPN) then
      dec(Result, 2);
  end
  else
    Result := 76;
end;

function TRemDlgElement.IncludeMHTestInPN: boolean;
begin
  Result := (Piece(FRec1, U, 9) = '0');
end;

procedure TRemDlgElement.RemoveChildControls(All: boolean);
var
  i: integer;

begin
  if All and Assigned(FPrompts) then
    for i := 0 to FPrompts.Count - 1 do
      TRemPrompt(FPrompts[i]).ClearControls;
  if (Assigned(FChildren)) then
    for i := 0 to FChildren.Count - 1 do
      TRemDlgElement(FChildren[i]).RemoveChildControls(True);
  FreeAndNil(FGroupBox);
  if All then
  begin
    FreeAndNil(FPanel);
    FreeAndNil(FCheckBox);
  end;
end;

function TRemDlgElement.ResultDlgID: string;
begin
  Result := Piece(FRec1, U, 10);
end;

procedure TRemDlgElement.setActiveDates(Choices: TORStringList;
  ChoicesActiveDates: TList; ActiveDates: TStringList);
var
  C: integer;
begin
  for C := 0 to Choices.Count - 1 do
  begin
    ActiveDates.Add(TStringList(ChoicesActiveDates[C]).CommaText)
  end;
end;

procedure TRemDlgElement.SubCommentChange(Sender: TObject);
var
  i: integer;
  txt: string;
  OK: boolean;

begin
  if (FHasSubComments and FHasComment and Assigned(FCommentPrompt)) then
  begin
    OK := FALSE;
    if (Assigned(Sender)) then
    begin
      with (Sender as TORCheckBox) do
        TRemPrompt(Tag).FValue := BOOLCHAR[Checked];
      OK := TRUE;
    end;
    if (not OK) then
      OK := (FCommentPrompt.GetValue = '');
    if (OK) then
    begin
      for i := 0 to FPrompts.Count - 1 do
      begin
        with TRemPrompt(FPrompts[i]) do
        begin
          if (PromptType = ptSubComment) and (FValue = BOOLCHAR[TRUE]) then
          begin
            if (txt <> '') then
              txt := txt + ', ';
            txt := txt + Caption;
          end;
        end;
      end;
      if (txt <> '') then
        txt[1] := UpCase(txt[1]);
      FCommentPrompt.SetValue(txt);
    end;
  end;
end;

constructor TRemDlgElement.Create;
begin
  FFieldValues := TORStringList.Create;
  FCodesList := TStringList.Create;
  FNexus := TComponentNexus.Create(nil);
  FNexus.OnFreeNotification := NexusFreeNotification;
end;

function TRemDlgElement.EntryID: string;
begin
  Result := REMEntryCode + FReminder.GetIEN + '/' + IntToStr(integer(Self));
end;

procedure TRemDlgElement.FieldPanelChange(Sender: TObject);
var
  idx: integer;
  Entry: TTemplateDialogEntry;
  fval: string;

begin
  FReminder.BeginTextChanged;
  try
    Entry := TTemplateDialogEntry(Sender);
    idx := FFieldValues.IndexOfPiece(Entry.InternalID);
    fval := Entry.InternalID + U + Entry.FieldValues;
    if (idx < 0) then
      FFieldValues.Add(fval)
    else
      FFieldValues[idx] := fval;
  finally
    FReminder.EndTextChanged(Sender);
  end;
end;

procedure TRemDlgElement.GetFieldValues(FldData: TStrings);
var
  i, p: integer;
  TmpSL: TStringList;

begin
  TmpSL := TStringList.Create;
  try
    for i := 0 to FFieldValues.Count - 1 do
    begin
      p := pos(U, FFieldValues[i]);
      // Can't use Piece because 2nd piece may contain ^ characters
      if (p > 0) then
      begin
        TmpSL.CommaText := copy(FFieldValues[i], p + 1, MaxInt);
        FastAddStrings(TmpSL, FldData);
        TmpSL.Clear;
      end;
    end;
  finally
    TmpSL.Free;
  end;
  if (Assigned(FChildren)) and (FChecked or (ElemType = etDisplayOnly)) then
    for i := 0 to FChildren.Count - 1 do
      TRemDlgElement(FChildren[i]).GetFieldValues(FldData);
end;

{ cause the paint event to be called and draw a focus rectangle on the TFieldPanel }
procedure TRemDlgElement.FieldPanelEntered(Sender: TObject);
begin
  with TDlgFieldPanel(Sender) do
  begin
    Focus := TRUE;
    Invalidate;
    if Parent is TDlgFieldPanel then
    begin
      TDlgFieldPanel(Parent).Focus := FALSE;
      TDlgFieldPanel(Parent).Invalidate;
    end;
  end;
end;

{ cause the paint event to be called and draw the TFieldPanel without the focus rect. }
procedure TRemDlgElement.FieldPanelExited(Sender: TObject);
begin
  with TDlgFieldPanel(Sender) do
  begin
    Focus := FALSE;
    Invalidate;
    if Parent is TDlgFieldPanel then
    begin
      TDlgFieldPanel(Parent).Focus := TRUE;
      TDlgFieldPanel(Parent).Invalidate;
    end;
  end;
end;

{ Check the associated checkbox when spacebar is pressed }
procedure TRemDlgElement.FieldPanelKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = ' ' then
  begin
    FieldPanelOnClick(Sender);
    Key := #0;
  end;
end;

{ So the FieldPanel will check the associated checkbox }
procedure TRemDlgElement.FieldPanelOnClick(Sender: TObject);
begin
  // if TFieldPanel(Sender).Focus then
  TORCheckBox(TDlgFieldPanel(Sender).Tag).Checked := not FChecked;
end;

{ call the FieldPanelOnClick so labels on the panels will also click the checkbox }
procedure TRemDlgElement.FieldPanelLabelOnClick(Sender: TObject);
begin
  FieldPanelOnClick(TLabel(Sender).Parent);
  { use the parent/fieldpanel as the Sender }
end;

{ TRemData }

function TRemData.Add2PN: boolean;
begin
  Result := (Piece(FRec3, U, 5) <> '1');
end;

function TRemData.AddData(List: TStrings; Finishing: boolean; historical: boolean): integer;
var
  i, j, k: integer;
  PCECat: TPCEDataCat;
  Primary: boolean;
  ActDt, InActDt: Double;
  encDt: TFMDateTime;

  procedure AddPrompt(Prompt: TRemPrompt; dt: TRemDataType; var X: string);
  var
    pt: TRemPromptType;
    PNum: integer;
    Pdt: TRemDataType;
    v: TVitalType;
    rte, unt, txt, tmp: string;
    UIEN: Int64;

  begin
    PNum := -1;
    pt := Prompt.PromptType;
    if (pt = ptSubComment) or (pt = ptUnknown) or (((pt = ptView) or
       (pt = ptPrint)) and (Piece(prompt.FRec4, U, 12) <> 'V')) then
      exit;
    if (pt = ptMST) then
    begin
      if (PCECat in MSTDataTypes) then
      begin
        UIEN := FParent.FReminder.PCEDataObj.Providers.PCEProvider;
        if UIEN <= 0 then
          UIEN := User.DUZ;
        SetPiece(X, U, pnumMST, Prompt.GetValue + ';' + // MST Code
          FloatToStr(RemForm.PCEObj.VisitDateTime) + ';' + IntToStr(UIEN)
          + ';' + //
          Prompt.FMiscText); // IEN of Exam, if any
      end;
    end
    else if (PCECat = pdcVital) then
    begin
      if (pt = ptVitalEntry) then
      begin
        rte := Prompt.VitalValue;
        if (rte <> '') then
        begin
          v := Prompt.VitalType;
          unt := Prompt.VitalUnitValue;
          ConvertVital(v, rte, unt);
          // txt := U + VitalCodes[v] + U + rte + U + FloatToStr(RemForm.PCEObj.VisitDateTime);  AGP Change 26.1 commented out
          txt := U + VitalCodes[v] + U + rte + U + '0';
          // AGP Change 26.1 Use for Vital date/time
          if (not Finishing) then
            txt := Char(ord('A') + ord(v)) + FormatVitalForNote(txt);
          // Add vital sort char
          List.AddObject(Char(ord('A') + ord(PCECat)) + txt, Self);
        end;
      end
      else
        exit;
    end
    else if (PCECat = pdcMH) then
    begin
      if (pt = ptMHTest) or (pt = ptGAF) then
        X := X + U + Prompt.GetValue
      else
        exit;
    end
    else if (pt <> ptDataList) and (ord(pt) >= ord(low(TRemPromptType))) then
    begin
      Pdt := RemPromptTypes[pt];
      if (Pdt = dt) or (Pdt = rdtAll) or (Pdt = rdtGenFindings) or
        ((pdt = rdtAdd2PLTypes) and (dt in Add2PLDataTypes)) or
        ((pdt = rdtMagnitudeTypes) and (dt in MagnitudeDataTypes)) or
        ((Pdt = rdtHistorical) and Assigned(Prompt.FParent) and
        Prompt.FParent.Historical) then
        PNum := FinishPromptPieceNum[pt];
      if (PNum < 0) and (pdt = rdtAdd2PLTypes) then
      begin
        case dt of
          rdtDiagnosis: PNum := pnumPOVAdd2PL;
          rdtStandardCode: PNUM := pnumSCAdd2PL;
        end;
      end;
      if (PNum > 0) then
      begin
        if (pt = ptPrimaryDiag) then
          SetPiece(X, U, PNum, BOOLCHAR[Primary])
        else if (pt = ptDate) or (pt = ptDateTime) then
        begin
          tmp := Prompt.GetValue;
          if (tmp = '0') then
            tmp := '';
          SetPiece(X, U, PNum, tmp);
        end
        else if pdt = rdtMagnitudeTypes then
          begin
            SetPiece(X, U, PNum, Prompt.GetValue);
            if (Prompt.UCUMInfo <> nil) and (prompt.UCUMInfo.Code <> '') then
              SetPiece(X, U, pnumCodesUCUM, prompt.UCUMInfo.Code);
            SetPiece(X, U, PNum, Prompt.GetValue);
          end
        else
          SetPiece(X, U, PNum, Prompt.GetValue);
      end;
    end;
  end;

  procedure addVimmData(var List: TStrings; PCECat: TPCEDataCat;
    values: string; Finishing, historical: boolean);
  var
    str, tmp: string;
    i, idx: integer;
    Data: TVimmResult;
    codes: TStringList;
//    cs: TVimmCS;
    codeCat: TPCEDataCat;
    immList, tempList: TStrings;
//    isHistorical: boolean;
  begin
    codes := TStringList.Create;
    tempList := TStringList.Create;
    immList := TStringList.Create;
    try
      if Self.vimmResult = nil then
        exit;
      Data := Self.vimmResult;

      if Data.isComplete = FALSE then
        exit;
      if finishing then
        begin
          if (historical = true) and (data.documType <> 'Historical') then exit
          else if (historical = false) and (data.documType = 'Historical') then exit;
        end;

      SetPiece(str, U, pnumCode, Data.ID);
      SetPiece(str, U, pnumNarrative, Data.name);
      if historical = true then
        begin
          if PCECat = pdcSkin then setPiece(str, u, pnumVisitDate, Piece(data.DelimitedStr, u, 8))
          else setPiece(str, u, pnumVisitDate, Piece(data.DelimitedStr, u, 19));
          if StrToIntDef(data.outsideLocIEN, 0) = 0 then
            setPiece(str, U, pnumVisitLoc, data.outsideLoc)
          else setPiece(str, U, pnumVisitLoc, data.outsideLocIEN);
        end;


        if data.cptCode <> '' then codes.Add(data.diagnosisDelimitedStr);
        if data.dxCode <> '' then codes.Add(data.procedureDelimitedStr);



      if Finishing then
      begin
        idx := List.IndexOf(Char(ord('A') + ord(PCECat)) + str);
        List.AddObject(Char(ord('A') + ord(PCECat)) + str, Data);
        if (data.documType = 'Administered') and (not data.isSkin) and (not historical) and
          (StrToIntDef(Piece(data.DelimitedStr, U, 30), 0) = 0) and (idx = -1) then
          begin
            if Pos('IMM', Piece(data.DelimitedStr, U, 1)) > 0 then
              immList.Add(data.DelimitedStr);
//            inc(immProcedureCnt)
          end;
      end
      else
      begin
        tmp := Char(ord('A') + ord(PCECat)) + GetPCEDataText(PCECat, '', '',
          Data.name) + GetImmContraText(Data.isContraindicated, Data.isRefused);
          if data.documType = 'Historical' then tmp := tmp + ' (Historical)';

        List.AddObject(tmp, Self);
        inc(Result);
      end;
      if (codes = nil) or (data.documType = 'Historical') then
        exit;
      for i := 0 to codes.Count - 1 do
      begin
        tmp := codes.Strings[i];
//        cs := TVimmCS(codes.Objects[i]);
        str := '';
        SetPiece(str, U, pnumCode, Piece(tmp, U, 2));
        SetPiece(str, U, pnumNarrative, Piece(tmp, u, 4));
        codeCat := pdcHNC;
        if Pos('CPT', Piece(tmp, u, 1)) > 0 then
          codeCat := pdcProc
        else if Pos('POV', Piece(tmp, u, 1)) > 0 then
          codeCat := pdcDiag
//        if cs.codingSystem = 'CPT' then
//          codeCat := pdcProc
//        else if cs.codingSystem = 'I10' then
//          codeCat := pdcDiag
        else if codeCat = pdcHNC then
          continue;
        if Finishing then
          List.AddObject(Char(ord('A') + ord(codeCat)) + tmp, Self)
        else
        begin
          tmp := Char(ord('A') + ord(codeCat)) + GetPCEDataText(codeCat,
            Piece(tmp, u, 2), '', Piece(tmp, u, 4));
          // if (Assigned(FParent) and FParent.Historical) then txt := txt + ' (Historical)';
          List.AddObject(tmp, Self);
        end;
      end;
    finally
      codes.Free;
      FreeAndNil(tempList);
      FreeAndNil(immList);
    end;
  end;

  procedure Add(Str: string; Root: TRemPCERoot; historical: boolean);
  var
    i, Qty: integer;
    Value, IsGAF, txt, X, Code, Nar, Cat, CodingSystem,
    GenFindID, GenFindNewData, GenFindDataGroup, GenFindPrinter: string;
    Skip: boolean;
    Prompt: TRemPrompt;
    dt: TRemDataType;
    TestDate: TFMDateTime;
    i1, i2: integer;

  begin
    X := '';
    dt := Code2DataType(Piece(Str, U, r3Type));
    PCECat := RemData2PCECat[dt];
    Code := Piece(Str, U, r3Code);
    if (Code = '') then
      Code := Piece(Str, U, r3Code2);
    Nar := Piece(Str, U, r3Nar);
    Cat := Piece(Str, U, r3Cat);
    CodingSystem := Piece(Str, U, r3CodingSystem);
    GenFindID := Piece(Str, U, r3GenFindID);
    GenFindNewData := Piece(Str, U, r3GenFindNewData);
    GenFindDataGroup := Piece(Str, U, r3GenFindDataGroup);
    GenFindPrinter := Piece(Str, U, r3GenFindPrinter);

    Primary := FALSE;
    if (Assigned(FParent) and Assigned(FParent.FPrompts) and (PCECat = pdcDiag))
    then
    begin
      if (FParent.Historical) then
      begin
        for i := 0 to FParent.FPrompts.Count - 1 do
        begin
          Prompt := TRemPrompt(FParent.FPrompts[i]);
          if (Prompt.PromptType = ptPrimaryDiag) then
          begin
            Primary := (Prompt.GetValue = BOOLCHAR[TRUE]);
            break;
          end;
        end;
      end
      else
        Primary := (Root = PrimaryDiagRoot);
    end;

    Skip := FALSE;
    if (PCECat = pdcMH) then
    begin
      IsGAF := Piece(FRec3, U, r3GAF);
      Value := FChoicePrompt.GetValue;
      if (Value = '') or ((IsGAF = '1') and (Value = '0')) then
        Skip := TRUE;
    end;

    if Finishing or (PCECat = pdcVital) then
    begin
      if (dt = rdtOrder) then
        X := U + Piece(Str, U, 6) + U + Piece(Str, U, 11) + U + Nar
      else
      begin
        if (PCECat = pdcMH) then
        begin
          if (Skip) then
            X := ''
          else
          begin
            TestDate := Trunc(FParent.FReminder.PCEDataObj.VisitDateTime);
            if (IsGAF = '1') then
              ValidateGAFDate(TestDate);
            X := U + Nar + U + IsGAF + U + FloatToStr(TestDate) + U +
              IntToStr(FParent.FReminder.PCEDataObj.Providers.PCEProvider);
          end;
        end
        else if (PCECat <> pdcVital) then
        begin
          X := Piece(Str, U, 6);
          if (PCECat = pdcImm) or (PCECat = pdcSkin) then
            begin
              addVimmData(List, PCECat, str, finishing, historical);
              Exit;
            end;
          SetPiece(X, U, pnumCode, Code);
          SetPiece(X, U, pnumCategory, Cat);
          SetPiece(X, U, pnumNarrative, Nar);
          SetPiece(X, U, pnumRemGenFindID, GenFindID);
          SetPiece(X, U, pnumRemGenFindNewData, GenFindNewData);
          SetPiece(X, U, pnumRemGenFindGroup, GenFindDataGroup);
          setPiece(X, U, pnumGFPrint, GenFindPrinter);
          SetPiece(X, U, pnumCodingSystem, CodingSystem);
        end;
        if (Assigned(FParent)) then
        begin
          if (Assigned(FParent.FPrompts)) then
          begin
            for i := 0 to FParent.FPrompts.Count - 1 do
            begin
              Prompt := TRemPrompt(FParent.FPrompts[i]);
              if (not Prompt.FIsShared) then
                AddPrompt(Prompt, dt, X);
            end;
          end;
          if (Assigned(FParent.FParent) and FParent.FParent.FHasSharedPrompts)
          then
          begin
            for i := 0 to FParent.FParent.FPrompts.Count - 1 do
            begin
              Prompt := TRemPrompt(FParent.FParent.FPrompts[i]);
              if (Prompt.FIsShared) and
                (Prompt.FSharedChildren.IndexOf(FParent) >= 0) then
                AddPrompt(Prompt, dt, X);
            end;
          end;
        end;
      end;
      if (X <> '') then
        List.AddObject(Char(ord('A') + ord(PCECat)) + X, Self);
    end
    else
    begin
      Qty := 1;
      if (Assigned(FParent) and Assigned(FParent.FPrompts)) then
      begin
        if (PCECat = pdcProc) then
        begin
          for i := 0 to FParent.FPrompts.Count - 1 do
          begin
            Prompt := TRemPrompt(FParent.FPrompts[i]);
            if (Prompt.PromptType = ptQuantity) then
            begin
              Qty := StrToIntDef(Prompt.GetValue, 1);
              if (Qty < 1) then
                Qty := 1;
              break;
            end;
          end;
        end;
      end;
      if (not Skip) then
      begin
        if (PCECat = pdcIMM) or (PCECat = pdcSkin) then
          begin
            addVimmData(List, PCECat, str, finishing, historical);
            exit;
          end;
        txt := Char(ord('A') + ord(PCECat)) + GetPCEDataText(PCECat, Code, Cat,
          Nar, Primary, Qty, CodingSystem);
        if (Assigned(FParent) and FParent.Historical) then
          txt := txt + ' (Historical)';
        List.AddObject(txt, Self);
        inc(Result);
      end;
      if Assigned(FParent) and Assigned(FParent.FMSTPrompt) then
      begin
        txt := FParent.FMSTPrompt.Value;
        if txt <> '' then
        begin
          if FParent.FMSTPrompt.FMiscText = '' then
          begin
            i1 := 0;
            i2 := 2;
          end
          else
          begin
            i1 := 3;
            i2 := 4;
          end;
          for i := i1 to i2 do
            if txt = MSTDescTxt[i, 1] then
            begin
              List.AddObject(Char(ord('A') + ord(pdcMST)) + MSTDescTxt[i,
                0], Self);
              break;
            end;
        end;
      end;
    end;
  end;

begin
  Result := 0;
  if (Assigned(FChoicePrompt)) and (Assigned(FChoices)) then
  begin
    If not Assigned(FChoicesActiveDates) then
    begin
      for i := 0 to FChoices.Count - 1 do
      begin
        if (copy(FChoicePrompt.GetValue, i + 1, 1) = '1') then
          Add(FChoices[i], TRemPCERoot(FChoices.Objects[i]), historical)
      end
    end
    else { if there are active dates for each choice then check them }
    begin
      If Self.FParent.Historical then
        encDt := DateTimeToFMDateTime(Date)
      else
        encDt := RemForm.PCEObj.VisitDateTime;
      k := 0;
      for i := 0 to FChoices.Count - 1 do
      begin
        for j := 0 to (TStringList(Self.FChoicesActiveDates[i]).Count - 1) do
        begin
          ActDt := StrToIntDef
            ((Piece(TStringList(Self.FChoicesActiveDates[i]).Strings[j],
            ':', 1)), 0);
          InActDt := StrToIntDef
            ((Piece(TStringList(Self.FChoicesActiveDates[i]).Strings[j], ':', 2)
            ), 9999999);
          if (encDt >= ActDt) and (encDt <= InActDt) then
          begin
            if (copy(FChoicePrompt.GetValue, k + 1, 1) = '1') then
              Add(FChoices[i], TRemPCERoot(FChoices.Objects[i]), historical);
            inc(k);
          end; { Active date check }
        end; { FChoicesActiveDates.Items[i] loop }
      end; { FChoices loop }
    end { FChoicesActiveDates check }
  end { FChoicePrompt and FChoices check }
  else
    Add(FRec3, FPCERoot, historical);
  { Active dates for this are checked in TRemDlgElement.AddData }
end;

function TRemData.Category: string;
begin
  Result := Piece(FRec3, U, r3Cat);
end;

function TRemData.Code: string;
begin
  Result := Piece(FRec3, U, r3Code2);
end;

function TRemData.DataType: TRemDataType;
begin
  Result := Code2DataType(Piece(FRec3, U, r3Type));
end;

destructor TRemData.Destroy;
var
  i: integer;

begin
  if (Assigned(FPCERoot)) then
    FPCERoot.Done(Self);
  if vimmResult <> nil then
    FreeAndNil(vimmResult);
  if (Assigned(FChoices)) then
  begin
    for i := 0 to FChoices.Count - 1 do
    begin
      if (Assigned(FChoices.Objects[i])) then
        TRemPCERoot(FChoices.Objects[i]).Done(Self);
    end;
  end;
  KillObj(@FChoices);
  inherited;
end;

function TRemData.DisplayWHResults: boolean;
begin
  Result := FALSE;
  if FRec3 <> '' then
    Result := (Piece(FRec3, U, 6) <> '0');
end;

function TRemData.ExternalValue: string;
begin
  Result := Piece(FRec3, U, r3Code);
end;

function TRemData.InternalValue: string;
begin
  Result := Piece(FRec3, U, 6);
end;

function TRemData.Narrative: string;
begin
  Result := Piece(FRec3, U, r3Nar);
end;

{ TRemPrompt }

function TRemPrompt.Add2PN: boolean;
begin
  Result := FALSE;
  if (not Forced) and (PromptOK) then
    // if PromptOK then
    Result := (Piece(FRec4, U, 5) <> '1');
  if (Result = FALSE) and (Piece(FRec4, U, 4) = 'WH_NOT_PURP') then
    Result := TRUE;
end;

function TRemPrompt.Caption: string;
begin
  Result := Piece(FRec4, U, 8);
  //AGP commented out according to GIT this was added from a merge of 31.266.2
  //this code not exist in 31B, 31MA, or 32A.
  // if Result = '' then
  // Result := PromptDescriptions[PromptType];

  if (not FCaptionAssigned) then
  begin
    AssignFieldIDs(Result);
    SetPiece(FRec4, U, 8, Result);
    FCaptionAssigned := TRUE;
  end;
end;

procedure TRemPrompt.ClearControls;
begin
  if assigned(FControls) then
    FControls.Clear;
  CurrentControl := nil;
end;

constructor TRemPrompt.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FOverrideType := ptUnknown;
  FLastUCUMDirection := -789;
  FUCUMInfo := nil;
  FLastUCUMInfoData := '';
end;

function TRemPrompt.CreateControlInfo(AName: String; cls: TControlClass;
  AOwner: TComponent; AParent: TWinControl): TControlInfo;
begin
  if (cls = nil) or (AOwner = nil) or (AParent = nil) then
  begin
    Result := nil;
    exit;
  end;
  if FControls = nil then
    FControls := TObjectList<TControlInfo>.Create;
  Result := TControlInfo.Create;
  with Result do
  begin
    Control := cls.Create(AOwner);
    Control.Parent := AParent;
    Control.FreeNotification(Self);
    Prompt := Self;
    Name := AName;
    MinWidth := 0;
    MaxWidth := 0;
  end;
  FControls.Add(Result);
end;

function TRemPrompt.Forced: boolean;
begin
  Result := (Piece(FRec4, U, 7) = 'F');
end;

function TRemPrompt.InternalValue: string;
var
  M, d, Y: Word;
  Code, valid: string;
begin
  Result := Piece(FRec4, U, 6);
  Code := Piece(FRec4, U, 4);
  valid := Piece(FRec4, U, 15);
  if (Code = RemPromptCodes[ptVisitDate])
  then
  begin
    if (copy(Result, 1, 1) = MonthReqCode) then
    begin
      FMonthReq := TRUE;
      delete(Result, 1, 1);
    end;
    if (Result = '') then
    begin
      DecodeDate(Now, Y, M, d);
      Result := IntToStr(Y - 1700) + '0000';
      SetPiece(FRec4, U, 6, Result);
    end;
  end;
  if (Code = RemPromptCodes[ptDate]) or  (Code = RemPromptCodes[ptDateTime]) then
    begin
      if (copy(Result, 1, 1) = EncDateCode) then
        begin
          Result := EncDateCode;
          SetPiece(FRec4, U, 6, Result);
        end;
      if valid = HistCode then validate := HistCode
      else if valid = FutureCode then validate :=  FutureCode
      else validate :=  AnyDateCode;
    end;
end;

procedure TRemPrompt.PromptChange(Sender: TObject);
var
  cbo: TORComboBox;
  pt: TRemPromptType;
  device, TmpValue, OrgValue: string;
  idx, I: integer;
  NeedRedraw, elementNeedRedraw: boolean;
  dte: TFMDateTime;
  whCKB: TWHCheckBox;
  // printoption: TORCheckBox;
  WHValue, WHValue1, itemId, linkItem, linkSeq, linkType, promptValue: String;
  elementList, promptList: TStringList;

begin
  if pxrmworking then
    exit;
  try
  FParent.FReminder.BeginTextChanged;
  try
    FFromControl := TRUE;
    try
      TmpValue := GetValue;
      OrgValue := TmpValue;
      pt := PromptType;
      NeedRedraw := FALSE;
      elementNeedRedraw := FALSE;
      case pt of
        ptComment, ptQuantity, ptMagnitude:
          TmpValue := (Sender as TEdit).Text;

        ptVisitDate, ptDate, ptDateTime:
          begin
            if pt = ptVisitDate then dte := (Sender as TORDateCombo).FMDate
            else dte := (Sender as TORDateBox).FMDateTime;
            if (pt = ptVisitDate) then
            begin
              while (dte > 2000000) and (dte > FMToday) do
              begin
                dte := dte - 10000;
                NeedRedraw := TRUE;
              end;
            end;
            TmpValue := FloatToStr(dte);
            if (TmpValue = '1000000') then
            begin
              if (pt = ptVisitDate) then
                TmpValue := '0'
              else
                TmpValue := '';
            end;

          end;

        ptPrimaryDiag, ptAdd2PL, ptContraindicated:
          begin
            TmpValue := BOOLCHAR[(Sender as TORCheckBox).Checked];
            NeedRedraw := (pt = ptPrimaryDiag);
          end;

        ptVisitLocation:
          begin
            cbo := (Sender as TORComboBox);
            if (cbo.ItemIEN < 0) then
              NeedRedraw := (not cbo.DroppedDown)
            else
            begin
              if (cbo.ItemIndex <= 0) then
                cbo.Items[0] := '0' + U + cbo.Text;
              TmpValue := cbo.itemId;
              if (StrToIntDef(TmpValue, 0) = 0) then
                TmpValue := cbo.Text;
            end;
          end;

        ptWHPapResult:
          begin
            if (Sender is TWHCheckBox) then
            begin
              whCKB := (Sender as TWHCheckBox);
              if whCKB.Checked = TRUE then
              begin
                if whCKB.Caption = 'NEM (No Evidence of Malignancy)' then
                  FParent.WHResultChk := 'N';
                if whCKB.Caption = 'Abnormal' then
                  FParent.WHResultChk := 'A';
                if whCKB.Caption = 'Unsatisfactory for Diagnosis' then
                  FParent.WHResultChk := 'U';
                // AGP Change 23.13 WH multiple processing
                for i := 0 to FParent.FData.Count - 1 do
                begin
                  if Piece(TRemData(FParent.FData[i]).FRec3, U, 4) = 'WHR' then
                  begin
                    FParent.FReminder.WHReviewIEN :=
                      Piece(TRemData(FParent.FData[i]).FRec3, U, 6)
                  end;
                end;
              end
              else
              begin
                FParent.WHResultChk := '';
                FParent.FReminder.WHReviewIEN := ''; // AGP CHANGE 23.13
              end;
            end;
          end;

        ptWHNotPurp:
          begin
            if (Sender is TWHCheckBox) then
            begin
              whCKB := (Sender as TWHCheckBox);
              if whCKB.Checked = TRUE then
              begin
                if whCKB.Caption = 'Letter' then
                begin
                  if FParent.WHResultNot = '' then
                    FParent.WHResultNot := 'L'
                  else if pos('L', FParent.WHResultNot) = 0 then
                    FParent.WHResultNot := FParent.WHResultNot + ':L';
                  if whCKB.FButton <> nil then
                    whCKB.FButton.Enabled := TRUE;
                  if whCKB.FPrintNow <> nil then
                  begin
                    whCKB.FPrintVis := '1';
                    whCKB.FPrintNow.Enabled := TRUE;
                  end;
                end;
                if whCKB.Caption = 'In-Person' then
                begin
                  if FParent.WHResultNot = '' then
                    FParent.WHResultNot := 'I'
                  else if pos('I', FParent.WHResultNot) = 0 then
                    FParent.WHResultNot := FParent.WHResultNot + ':I';
                end;
                if whCKB.Caption = 'Phone Call' then
                begin
                  if FParent.WHResultNot = '' then
                    FParent.WHResultNot := 'P'
                  else if pos('P', FParent.WHResultNot) = 0 then
                    FParent.WHResultNot := FParent.WHResultNot + ':P';
                end;
              end
              else
              begin
                // this section is to handle unchecking of boxes and disabling print now and view button
                WHValue := FParent.WHResultNot;
                if whCKB.Caption = 'Letter' then
                begin
                  for i := 1 to length(WHValue) do
                  begin
                    if WHValue1 = '' then
                    begin
                      if (WHValue[i] <> 'L') and (WHValue[i] <> ':') then
                        WHValue1 := WHValue[i];
                    end
                    else if (WHValue[i] <> 'L') and (WHValue[i] <> ':') then
                      WHValue1 := WHValue1 + ':' + WHValue[i];
                  end;
                  if (whCKB.FButton <> nil) and (whCKB.FButton.Enabled = TRUE)
                  then
                    whCKB.FButton.Enabled := FALSE;
                  if (whCKB.FPrintNow <> nil) and
                    (whCKB.FPrintNow.Enabled = TRUE) then
                  begin
                    whCKB.FPrintVis := '0';
                    if whCKB.FPrintNow.Checked = TRUE then
                      whCKB.FPrintNow.Checked := FALSE;
                    whCKB.FPrintNow.Enabled := FALSE;
                    FParent.WHPrintDevice := '';
                  end;
                end;
                if whCKB.Caption = 'In-Person' then
                begin
                  for i := 1 to length(WHValue) do
                  begin
                    if WHValue1 = '' then
                    begin
                      if (WHValue[i] <> 'I') and (WHValue[i] <> ':') then
                        WHValue1 := WHValue[i];
                    end
                    else if (WHValue[i] <> 'I') and (WHValue[i] <> ':') then
                      WHValue1 := WHValue1 + ':' + WHValue[i];
                  end;
                end;
                if whCKB.Caption = 'Phone Call' then
                begin
                  for i := 1 to length(WHValue) do
                  begin
                    if WHValue1 = '' then
                    begin
                      if (WHValue[i] <> 'P') and (WHValue[i] <> ':') then
                        WHValue1 := WHValue[i];
                    end
                    else if (WHValue[i] <> 'P') and (WHValue[i] <> ':') then
                      WHValue1 := WHValue1 + ':' + WHValue[i];
                  end;
                end;
                FParent.WHResultNot := WHValue1;
              end;
            end
            else if ((Sender as TORCheckBox) <> nil) and
              (Piece(FRec4, U, 12) = '1') then
            begin
              if (((Sender as TORCheckBox).Caption = 'Print Now') and
                ((Sender as TORCheckBox).Enabled = TRUE)) and
                ((Sender as TORCheckBox).Checked = TRUE) and
                (FParent.WHPrintDevice = '') then
              begin
                FParent.WHPrintDevice := SelectDevice(Self, Encounter.Location,
                  FALSE, 'Women Health Print Device Selection');
                FPrintNow := '1';
                if FParent.WHPrintDevice = '' then
                begin
                  FPrintNow := '0';
                  (Sender as TORCheckBox).Checked := FALSE;
                end;
              end;
              if (((Sender as TORCheckBox).Caption = 'Print Now') and
                ((Sender as TORCheckBox).Enabled = TRUE)) and
                ((Sender as TORCheckBox).Checked = FALSE) then
              begin
                FParent.WHPrintDevice := '';
                FPrintNow := '0';
              end;
            end;
          end;

        ptPrint:
          begin
            if Piece(FRec4, U, 12) = 'V'  then
              begin
                device := SelectDevice(Self, Encounter.Location, FALSE, 'Print Device Selection');
                tmpValue := Piece(device, U, 1);
//         if device <> '' then FValue := device
//         else FValue := '';

              end;
          end;

        ptExamResults, ptSkinResults, ptLevelSeverity, ptSeries, ptReaction,
          ptLevelUnderstanding, ptSkinReading, ptUCUMCode:
          TmpValue := (Sender as TORComboBox).itemId;

      else
        if pt = ptVitalEntry then
        begin
          case (Sender as TControl).Tag of
            TAG_VITTEMPUNIT, TAG_VITHTUNIT, TAG_VITWTUNIT:
              idx := 2;
            TAG_VITPAIN:
              begin
                idx := -1;
                TmpValue := (Sender as TORComboBox).itemId;
                if FParent.VitalDateTime = 0 then
                  FParent.VitalDateTime := FMNow;
              end;
          else
            idx := 1;
          end;
          if (idx > 0) then
          begin
            // AGP Change 26.1 change Vital time/date to Now instead of encounter date/time
            SetPiece(TmpValue, ';', idx, TORExposedControl(Sender).Text);
            if (FParent.VitalDateTime > 0) and
              (TORExposedControl(Sender).Text = '') then
              FParent.VitalDateTime := 0;
            if (FParent.VitalDateTime = 0) and
              (TORExposedControl(Sender).Text <> '') then
              FParent.VitalDateTime := FMNow;
          end;
        end
        else if pt = ptDataList then
        begin
          TmpValue := (Sender as TORComboBox).CheckedString;
          NeedRedraw := TRUE;
        end
        else if (pt = ptGAF) and (MHDLLFound = FALSE) then
          TmpValue := (Sender as TEdit).Text;
      end;
      if (TmpValue <> OrgValue) then
      begin
        if NeedRedraw then
          FParent.FReminder.BeginNeedRedraw;
        try
          elementNeedRedraw := FALSE;
          itemId := Piece(Self.FRec4, U, 2);
          linkItem := Piece(Self.FRec4, U, 13);
          linkType := Piece(Self.FRec4, U, 14);
          linkSeq := Piece(self.FRec4, U, 28);

          elementList := TStringList.Create;
          promptList := TStringList.Create;
          SetValue(TmpValue);
          //check to not call VistA if user is in the middle of changing a date.
          if ((pt = ptDate) or (pt = ptDateTime)) and (TmpValue = '-1') then exit;
          if (linkItem = '') or (linkType = '') then exit;
          promptValue := getLinkPromptValue(TmpValue, itemId, OrgValue, patient.dfn);
          if linkType = 'ELEMENT' then
          begin
            if promptValue <> '' then
            begin
              elementNeedRedraw := TRUE;
              elementList.Add(linkItem + U + promptValue + U + U + linkseq);
            end;
          end
          else
          begin
            if promptValue = 'REQUIRED' then
            begin
              promptList.Add(linkItem + U + linkType + U + 'REQUIRED' + U + U + linkseq);
              elementNeedRedraw := TRUE;
            end
            else if promptValue <> '' then
            begin
              promptList.Add(linkItem + U + linkType + U + 'VALUE' + U +
                promptValue + U + linkseq);
              elementNeedRedraw := TRUE;
            end;
          end;
        finally
          if NeedRedraw then
            FParent.FReminder.EndNeedRedraw(Self);
        end;
      end
      else if NeedRedraw then
      begin
        FParent.FReminder.BeginNeedRedraw;
        FParent.FReminder.EndNeedRedraw(Self);
      end;
    finally
      FFromControl := FALSE;
    end;
  finally
    FParent.FReminder.EndTextChanged(Sender);
  end;
  if (FParent.ElemType = etDisplayOnly) and (not Assigned(FParent.FParent)) then
    RemindersInProcess.Notifier.Notify;
  if elementNeedRedraw then
    try
      if FParent.buildLinkSeq(linkSeq, self.FParent.FID, Piece(self.FParent.FRec1, u, 3)) then
        FParent.FReminder.findLinkItem(elementList, promptList, Piece(self.FParent.FRec1, u, 3));
    finally
      if elementList <> nil then FreeAndNil(elementList);
      if promptList <> nil then  FreeAndNil(promptList);
    end;
  finally
    pxrmDoneWorking;
  end;
end;

procedure TRemPrompt.ComboBoxKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) and (Sender is TORComboBox) and
    ((Sender as TORComboBox).DroppedDown) then
    (Sender as TORComboBox).DroppedDown := FALSE;
end;

function TRemPrompt.PromptOK: boolean;
var
  pt: TRemPromptType;
  dt: TRemDataType;
  C, i: integer;
  encDate: TFMDateTime;

begin
  pt := PromptType;
  if (pt = ptUnknown) or (pt = ptMST) then
    Result := FALSE
  else if (pt = ptDataList) or (pt = ptVitalEntry) or (pt = ptMHTest) or
    (pt = ptGAF) or (pt = ptWHPapResult) or (pt = ptImmunization) or (pt = ptSkinTest) then
    Result := TRUE
  else if (pt = ptSubComment) then
    Result := FParent.FHasComment
  else
  begin
    dt := RemPromptTypes[pt];
    if (dt = rdtAll) or (dt = rdtMagnitudeTypes) or (dt = rdtAdd2PLTypes) then
      Result := TRUE
    else if (dt = rdtUnknown) then
      Result := FALSE
    else if (pt = ptUCUMCode) and (dt = rdtStandardCode) then
      Result := TRUE
    else if (dt = rdtHistorical) then
      Result := FParent.Historical
      // hanlde combo box prompts that are not assocaite with codes
    else if (dt <> rdtProcedure) and (dt <> rdtDiagnosis) and (dt <> rdtStandardCode) then
    begin
      Result := FALSE;
      if (Assigned(FParent.FData)) then
      begin
        for i := 0 to FParent.FData.Count - 1 do
        begin
          if (TRemData(FParent.FData[i]).DataType = dt) then
          begin
            Result := TRUE;
            break;
          end;
        end;
      end;
    end
    else
    // agp ICD10 change to screen out prompts if taxonomy does not contain active codes for the encounter date.
    // historical values override the date check.
    begin
      Result := FALSE;
      if (Assigned(FParent.FData)) then
      begin
        for i := 0 to FParent.FData.Count - 1 do
        begin
          if (TRemData(FParent.FData[i]).DataType = dt) then
          begin
            if (FParent.Historical) then
            begin
              Result := TRUE;
              break;
            end
            else if (TRemData(FParent.FData[i]).FActiveDates <> nil) then
            begin
              encDate := TRemData(FParent.FData[i])
                .FParent.FReminder.FPCEDataObj.DateTime;
              if (RemDataActive(TRemData(FParent.FData[i]), encDate) = TRUE)
              then
                Result := TRUE;
              break;
            end
            // else if (Assigned(TRemData(FParent.FData[i]).FChoices) and (TRemData(FParent.FData[i]).FChoices <> nil)) then
            else if Assigned(TRemData(FParent.FData[i]).FChoices) then
            begin
              encDate := TRemData(FParent.FData[i])
                .FParent.FReminder.FPCEDataObj.DateTime;
              for C := 0 to TRemData(FParent.FData[i]).FChoices.Count - 1 do
              begin
                if (CompareActiveDate(TStringList(TRemData(FParent.FData[i])
                  .FChoicesActiveDates[C]), encDate) = TRUE) then
                begin
                  Result := TRUE;
                  break;
                end;
              end;
            end;
            // Result := TRUE;
            // break;
          end;
        end;
      end;
    end;
  end;
end;

function TRemPrompt.PromptType: TRemPromptType;
begin
  if (Assigned(FData)) or (FOriginalDataRec3 <> '') then
    Result := FOverrideType
  else
    Result := Code2PromptType(Piece(FRec4, U, 4));
end;

function TRemPrompt.Required: boolean;
var
  pt: TRemPromptType;

begin
  pt := PromptType;
  if (pt = ptVisitDate) then
    Result := TRUE
  else if (pt = ptSubComment) then
    Result := FALSE
  else
    Result := (Piece(FRec4, U, 10) = '1');
end;

function TRemPrompt.SameLine: boolean;
begin
  Result := (Piece(FRec4, U, 9) <> '1');
end;

function TRemPrompt.NoteText: string;
var
  pt: TRemPromptType;
  dateStr, fmt, tmp, WHValue: string;
  Cnt, i, j, k: integer;
  ActDt, InActDt: Double;
  encDt: TFMDateTime;

begin
  Result := '';
  pt := PromptType;
  if Add2PN then
  begin
    tmp := GetValue;
    case pt of
      ptComment, ptMagnitude:
        Result := tmp;

      ptQuantity:
        if (StrToIntDef(tmp, 1) <> 1) then
          Result := tmp;

      (* ptSkinReading: if(StrToIntDef(tmp,0) <> 0) then
        Result := tmp; *)

      ptSkinReading: // (AGP Change 26.1)
        begin
          Result := tmp;
        end;

      ptVisitDate, ptDate:
        begin
          try
            if (tmp <> '') and (tmp <> '0') and (length(tmp) = 7) then
            begin
              dateStr := '';
              if FMonthReq and (copy(tmp, 4, 2) = '00') then
                Result := ''
              else
              begin
                if (copy(tmp, 4, 4) = '0000') then
                begin
                  fmt := 'YYYY';
                  dateStr := '  Exact date is unknown';
                end
                else if (copy(tmp, 6, 2) = '00') then
                begin
                  fmt := 'MMMM, YYYY';
                  dateStr := '  Exact date is unknown';
                end
                else
                  fmt := 'MMMM D, YYYY';
                if dateStr = '' then
                  Result := FormatFMDateTimeStr(fmt, tmp)
                else
                  Result := FormatFMDateTimeStr(fmt, tmp) + ' ' + dateStr;
              end;
            end;
          except
            on EConvertError do
              Result := tmp
            else
              raise;
          end;
        end;

      ptDateTime:
        begin
          try
            fmt := 'MMMM D, YYYY@HH:NN';
            if dateStr = '' then
            Result := FormatFMDateTimeStr(fmt, tmp)
            else
              Result := FormatFMDateTimeStr(fmt, tmp) + ' ' + dateStr;
          except
            on EConvertError do
              Result := tmp
            else
              raise;
          end;
        end;

      ptPrimaryDiag, ptAdd2PL, ptContraindicated:
        if (tmp = '1') then
          Result := ' ';

      ptVisitLocation:
        if (StrToIntDef(tmp, 0) = 0) then
        begin
          if (tmp <> '0') then
            Result := tmp;
        end
        else
        begin
          Result := GetPCEDisplayText(tmp, ComboPromptTags[pt]);
        end;

      ptWHPapResult:
        begin
          if FParent.WHResultChk = 'N' then
            Result := 'NEM (No Evidence of Malignancy)';
          if FParent.WHResultChk = 'A' then
            Result := 'Abnormal';
          if FParent.WHResultChk = 'U' then
            Result := 'Unsatisfactory for Diagnosis';
          if FParent.WHResultChk = '' then
            Result := '';
        end;

      ptWHNotPurp:
        begin
          if FParent.WHResultNot <> '' then
          begin
            WHValue := FParent.WHResultNot;
            // IF Forced = false then
            // begin
            if WHValue <> 'CPRS' then
            begin
              for Cnt := 1 to length(WHValue) do
              begin
                if Result = '' then
                begin
                  if WHValue[Cnt] = 'L' then
                    Result := 'Letter';
                  if WHValue[Cnt] = 'I' then
                    Result := 'In-Person';
                  if WHValue[Cnt] = 'P' then
                    Result := 'Phone Call';
                end
                else
                begin
                  if (WHValue[Cnt] = 'L') and (pos('Letter', Result) = 0) then
                    Result := Result + '; Letter';
                  if (WHValue[Cnt] = 'I') and (pos('In-Person', Result) = 0)
                  then
                    Result := Result + '; In-Person';
                  if (WHValue[Cnt] = 'P') and (pos('Phone Call', Result) = 0)
                  then
                    Result := Result + '; Phone Call';
                end;
              end;
            end;
          end
          else if Forced = TRUE then
          begin
            if pos(':', Piece(FRec4, U, 6)) = 0 then
            begin
              if Piece(FRec4, U, 6) = 'L' then
              begin
                Result := 'Letter';
                FParent.WHResultNot := 'L';
              end;
              if Piece(FRec4, U, 6) = 'I' then
              begin
                Result := 'In-Person';
                FParent.WHResultNot := 'I';
              end;
              if Piece(FRec4, U, 6) = 'P' then
              begin
                Result := 'Phone Call';
                FParent.WHResultNot := 'P';
              end;
              if Piece(FRec4, U, 6) = 'CPRS' then
              begin
                Result := '';
                FParent.WHResultNot := 'CPRS';
              end;
            end
            else
            begin
              WHValue := Piece(FRec4, U, 6);
              for Cnt := 0 to length(WHValue) do
              begin
                if Result = '' then
                begin
                  if WHValue[Cnt] = 'L' then
                  begin
                    Result := 'Letter';
                    FParent.WHResultNot := WHValue[Cnt];
                  end;
                  if WHValue[Cnt] = 'I' then
                  begin
                    Result := 'In-Person';
                    FParent.WHResultNot := WHValue[Cnt];
                  end;
                  if WHValue[Cnt] = 'P' then
                  begin
                    Result := 'Phone Call';
                    FParent.WHResultNot := WHValue[Cnt];
                  end;
                end
                else
                begin
                  if (WHValue[Cnt] = 'L') and (pos('Letter', Result) = 0) then
                  begin
                    Result := Result + '; Letter';
                    FParent.WHResultNot := FParent.WHResultNot + ':' +
                      WHValue[Cnt];
                  end;
                  if (WHValue[Cnt] = 'I') and (pos('In-Person', Result) = 0)
                  then
                  begin
                    Result := Result + '; In-Person';
                    FParent.WHResultNot := FParent.WHResultNot + ':' +
                      WHValue[Cnt];
                  end;
                  if (WHValue[Cnt] = 'P') and (pos('Phone Call', Result) = 0)
                  then
                  begin
                    Result := Result + '; Phone Call';
                    FParent.WHResultNot := FParent.WHResultNot + ':' +
                      WHValue[Cnt];
                  end;
                end;
              end;

            end;
          end
          else
            Result := '';
        end;

      ptExamResults, ptSkinResults, ptLevelSeverity, ptSeries, ptReaction,
        ptLevelUnderstanding:
        begin
          Result := tmp;
          if (Piece(Result, U, 1) = '@') then
            Result := ''
          else
            Result := GetPCEDisplayText(tmp, ComboPromptTags[pt]);
        end;

    else
      begin
        if pt = ptDataList then
        begin
          if (Assigned(FData) and Assigned(FData.FChoices)) then
          begin
            if not(Assigned(FData.FChoicesActiveDates)) then
              for i := 0 to FData.FChoices.Count - 1 do
              begin
                if (copy(tmp, i + 1, 1) = '1') then
                begin
                  if (Result <> '') then
                    Result := Result + ', ';
                  Result := Result + Piece(FData.FChoices[i], U, 12);
                end;
              end
            else { if there are active dates for each choice then check them }
            begin
              if Self.FParent.Historical then
                encDt := DateTimeToFMDateTime(Date)
              else
                encDt := RemForm.PCEObj.VisitDateTime;
              k := 0;
              for i := 0 to FData.FChoices.Count - 1 do
              begin
                for j := 0 to (TStringList(FData.FChoicesActiveDates[i])
                  .Count - 1) do
                begin
                  ActDt := StrToIntDef
                    ((Piece(TStringList(FData.FChoicesActiveDates[i])
                    .Strings[j], ':', 1)), 0);
                  InActDt :=
                    StrToIntDef
                    ((Piece(TStringList(FData.FChoicesActiveDates[i])
                    .Strings[j], ':', 2)), 9999999);
                  if (encDt >= ActDt) and (encDt <= InActDt) then
                  begin
                    if (copy(tmp, k + 1, 1) = '1') then
                    begin
                      if (Result <> '') then
                        Result := Result + ', ';
                      Result := Result + Piece(FData.FChoices[i], U, 12);
                    end;
                    inc(k);
                  end; { ActiveDate check }
                end; { FChoicesActiveDates.Items[i] loop }
              end; { FChoices loop }
            end;
          end;
        end
        else if pt = ptVitalEntry then
        begin
          Result := VitalValue;
          if (Result <> '') then
            Result := ConvertVitalData(Result, VitalType, VitalUnitValue);
        end
        else if pt = ptMHTest then
          Result := FMiscText
        else if (pt = ptGAF) and (MHDLLFound = FALSE) then
        begin
          if (StrToIntDef(Piece(tmp, U, 1), 0) <> 0) then
          begin
            Result := tmp;
          end
        end
        else if pt = ptMHTest then
          Result := FMiscText;

        (*
          GafDate := Trunc(FParent.FReminder.PCEDataObj.VisitDateTime);
          ValidateGAFDate(GafDate);
          Result := tmp + CRCode + 'Date Determined: ' + FormatFMDateTime('mm/dd/yyyy', GafDate) +
          CRCode + 'Determined By: ' + FParent.FReminder.PCEDataObj.Providers.PCEProviderName;
        *)
        // end;
      end;
    end;
  end;
  if (Result <> '') and (Caption <> '') then
  begin
    Result := Trim(Caption + ' ' + Trim(Result));
    if (pt = ptMagnitude) and (FUCUMText <> '') then
      Result := Result + ' ' + FUCUMText;
  end;
  // end;
end;

{
function TRemPrompt.buildUCUMDataText: string;
var
temp: string;
begin
  temp := getUCUMData;
  if StrToIntDef(Piece(temp, u, 3), 0) > 0 then
    result := 'Enter a number between '
  else result := 'Enter a whole number between ';
  result := result + Piece(temp, U, 1) + ' and ';
  result := result + Piece(temp, u, 2);
  if StrToIntDef(Piece(temp, u, 3), 0) > 0 then
    result := result + ' up to ' + Piece(temp, u, 3) + ' right of the decimal';
end;
}

procedure TRemPrompt.Notification(AComponent: TComponent;
  Operation: TOperation);
var
  i: integer;

begin
  inherited;
  if (Operation = opRemove) then
  begin
    if AComponent is TControl and Assigned(FControls) then
    begin
      for i := 0 to FControls.Count - 1 do
        if (FControls[i].Control = AComponent) then
        begin
          FControls.Delete(i);
          break;
        end;
    end;
    if AComponent = FCurrentControl then
      FCurrentControl := nil;
  end;
end;

function TRemPrompt.CanShare(Prompt: TRemPrompt): boolean;
var
  pt: TRemPromptType;

begin
  if (Forced or Prompt.Forced or Prompt.FIsShared or Required or Prompt.Required)
  then
    Result := FALSE
  else
  begin
    pt := PromptType;
    Result := (pt = Prompt.PromptType);
    if (Result) then
    begin
      if (pt in [ptAdd2PL, ptLevelUnderstanding]) or
        ((pt = ptComment) and (not FParent.FHasSubComments)) then
        Result := ((Add2PN = Prompt.Add2PN) and (Caption = Prompt.Caption))
      else
        Result := FALSE;
    end;
  end;
end;

destructor TRemPrompt.Destroy;
begin
  FreeAndNil(FControls);
  KillObj(@FSharedChildren);
  if assigned(FLastUCUMData) then
    FreeAndNil(FLastUCUMData);
  inherited;
end;

function TRemPrompt.RemDataActive(RData: TRemData; encDt: TFMDateTime): boolean;
// var
// ActDt, InActDt: Double;
// j: integer;

begin
  // Result := FALSE;
  if Assigned(RData.FActiveDates) then
    Result := CompareActiveDate(RData.FActiveDates, encDt)
    // agp ICD-10 move code to it own function to reuse the comparison in other parts of dialogs
    // for j := 0 to (RData.FActiveDates.Count - 1) do
    // begin
    // ActDt := StrToIntDef(Piece(RData.FActiveDates[j],':',1), 0);
    // InActDt := StrToIntDef(Piece(RData.FActiveDates[j], ':', 2), 9999999);
    // if (EncDt >= ActDt) and (EncDt <= InActDt) then
    // begin
    // Result := TRUE;
    // Break;
    // end;
    // end
  else
    Result := TRUE;
end;

// agp ICD-10 code was imported from  RemDataActive
function TRemPrompt.CompareActiveDate(ActiveDates: TStringList;
  encDt: TFMDateTime): boolean;
var
  ActDt, InActDt: Double;
  j: integer;
begin
  Result := FALSE;
  for j := 0 to (ActiveDates.Count - 1) do
  begin
    ActDt := StrToIntDef(Piece(ActiveDates[j], ':', 1), 0);
    InActDt := StrToIntDef(Piece(ActiveDates[j], ':', 2), 9999999);
    if (encDt >= ActDt) and (encDt <= InActDt) then
    begin
      Result := TRUE;
      break;
    end;
  end
end;

function TRemPrompt.ControlInfo(AName: String): TControlInfo;
var
  i: integer;

begin
  Result := nil;
  if (AName = '') or (FControls = nil) then
    exit;
  for i := 0 to FControls.Count - 1 do
    if (FControls[i].Name = AName) then
    begin
      Result := FControls[i];
      exit;
    end;
end;

function TRemPrompt.ControlInfo(AControl: TControl): TControlInfo;
var
  i: integer;

begin
  Result := nil;
  if (AControl = nil) or (FControls = nil) then
    exit;
  for i := 0 to FControls.Count - 1 do
    if (FControls[i].Control = AControl) then
    begin
      Result := FControls[i];
      exit;
    end;
end;

function TRemPrompt.RemDataChoiceActive(RData: TRemData; j: integer;
  encDt: TFMDateTime): boolean;
var
  ActDt, InActDt: Double;
  i: integer;
begin
  Result := FALSE;
  If not Assigned(RData.FChoicesActiveDates) then
  // if no active dates were sent
    Result := TRUE // from the server then don't check dates
  else { if there are active dates for each choice then check them }
  begin
    for i := 0 to (TStringList(RData.FChoicesActiveDates[j]).Count - 1) do
    begin
      ActDt := StrToIntDef((Piece(TStringList(RData.FChoicesActiveDates[j])
        .Strings[i], ':', 1)), 0);
      InActDt := StrToIntDef
        ((Piece(TStringList(RData.FChoicesActiveDates[j]).Strings[i], ':', 2)
        ), 9999999);
      if (encDt >= ActDt) and (encDt <= InActDt) then
      begin
        Result := TRUE;
      end; { Active date check }
    end; { FChoicesActiveDates.Items[i] loop }
  end { FChoicesActiveDates check }
end;

procedure TRemPrompt.reportViewClosed(Sender: TObject);
begin
  if assigned(self.reportView) then
    begin
      if assigned(FOldReportViewOnDestroy) then
        FOldReportViewOnDestroy(self.reportView);
      self.reportView := nil;
    end;
end;

function TRemPrompt.UCUMInfo: TUCUMInfo;
var
  data: string;

begin
  data := getDataType + U + FData.Code + U + getUCumData;
  if data <> FLastUCUMInfoData then
  begin
    FLastUCUMInfoData := data;
    FUCUMInfo:= GetUCUMInfo(getDataType, FData.Code);
  end;
  Result := FUCUMInfo;
end;

function TRemPrompt.GetValue: string;
// Returns TRemPrompt.FValue if this TRemPrompt is not a ptPrimaryDiag
// Returns 0-False or 1-True if this TRemPrompt is a ptPrimaryDiag
var
  i, j, k: integer;
  RData: TRemData;
  OK: boolean;
  encDt: TFMDateTime;

begin
  OK := (Piece(FRec4, U, 4) = RemPromptCodes[ptPrimaryDiag]);
  if (OK) and (Assigned(FParent)) then
    OK := (not FParent.Historical);
  if OK then
  begin
    OK := FALSE;
    if (Assigned(FParent) and Assigned(FParent.FData))
    then { If there's FData, see if }
    begin { there's a primary diagnosis }
      for i := 0 to FParent.FData.Count - 1 do { if there is return True }
      begin
        encDt := RemForm.PCEObj.VisitDateTime;
        RData := TRemData(FParent.FData[i]);
        if (RData.DataType = rdtDiagnosis) then
        begin
          if (Assigned(RData.FPCERoot)) and (RemDataActive(RData, encDt)) then
            OK := (RData.FPCERoot = PrimaryDiagRoot)
          else if (Assigned(RData.FChoices)) and (Assigned(RData.FChoicePrompt))
          then
          begin
            k := 0;
            for j := 0 to RData.FChoices.Count - 1 do
            begin
              if RemDataChoiceActive(RData, j, encDt) then
              begin
                if (Assigned(RData.FChoices.Objects[j])) and
                  (copy(RData.FChoicePrompt.FValue, k + 1, 1) = '1') then
                begin
                  if (TRemPCERoot(RData.FChoices.Objects[j]) = PrimaryDiagRoot)
                  then
                  begin
                    OK := TRUE;
                    break;
                  end;
                end; // if FChoices.Objects (which is the RemPCERoot object) is assigned
                inc(k);
              end; // if FChoices[j] is active
            end; // loop through FChoices
          end; // If there are FChoices and an FChoicePrompt (i.e.: is this a ptDataList}
        end;
        if OK then
          break;
      end;
    end;
    Result := BOOLCHAR[OK];
  end
  else
    Result := FValue;
end;

procedure TRemPrompt.SetCurrentControl(const Value: TControl);
begin
  if FCurrentControl <> Value then
  begin
    if assigned(FCurrentControl) then
      FCurrentControl.RemoveFreeNotification(Self);
    FCurrentControl := Value;
    if assigned(FCurrentControl) then
      FCurrentControl.FreeNotification(Self);
  end;
end;

procedure TRemPrompt.SetValue(Value: string);
var
  pt: TRemPromptType;
  i, j, k: integer;
  RData: TRemData;
  Primary, Done: boolean;
  tmp: string;
  OK, NeedRefresh: boolean;
  encDt: TFMDateTime;
  genFindOnly: boolean;

  function genFindingOnly(list: TList): boolean;
  var
  rData: TRemData;
  i: integer;
  begin
    result := true;
    for i := 0 to list.Count-1 do
    begin
      rData := TRemData(List[i]);
      if (rData.DataType <> rdtGenFindings) and (rData.DataType <> rdtOrder) then
      begin
        result := false;
        exit;
      end;
    end;
  end;

begin
  NeedRefresh := (not FFromControl);
  if (Forced and (not FFromParent)) then
    exit;
  pt := PromptType;
  if (pt in [ptVisitDate, ptDate, ptDateTime]) then
  begin
    if (pt = ptVisitDate) and (Value = '') then
      Value := '0'
    else
    begin
      try
        if (pt = ptVisitDate) and (StrToFloat(Value) > FMToday) then
        begin
          Value := '0';
          InfoBox('Can not enter a future date for a historical event.',
            'Invalid Future Date', MB_OK + MB_ICONERROR);
        end;
      except
        on EConvertError do
          Value := '0'
        else
          raise;
      end;
      if (Value = '0') or (Value = '') then
        NeedRefresh := TRUE;
    end;
  end;
  if (GetValue <> Value) or (FFromParent) then
  begin
    FValue := Value;
    encDt := RemForm.PCEObj.VisitDateTime;
    if ((pt = ptExamResults) and Assigned(FParent) and Assigned(FParent.FData)
      and (FParent.FData.Count > 0) and Assigned(FParent.FMSTPrompt)) then
    begin
      FParent.FMSTPrompt.SetValueFromParent(Value);
      if (FParent.FMSTPrompt.FMiscText = '') then
        // Assumes first finding item is MST finding
        FParent.FMSTPrompt.FMiscText := TRemData(FParent.FData[0])
          .InternalValue;
    end;

    if assigned(FParent.FData) then
      genFindOnly := genFindingOnly(FParent.FData)
    else
      genFindOnly := false;

    OK := (Assigned(FParent) and Assigned(FParent.FData) and
      (Piece(FRec4, U, 4) = RemPromptCodes[ptPrimaryDiag]));
    if (OK = FALSE) and (Value = 'New MH dll') then
      OK := TRUE;
    if OK then
      OK := (not FParent.Historical);
    if OK then
    begin
      Done := FALSE;
      Primary := (Value = BOOLCHAR[TRUE]);
      for i := 0 to FParent.FData.Count - 1 do
      begin
        RData := TRemData(FParent.FData[i]);
        if (RData.DataType = rdtDiagnosis) then
        begin
          if (Assigned(RData.FPCERoot)) and (RemDataActive(RData, encDt)) then
          begin
            if (Primary) then
            begin
              PrimaryDiagRoot := RData.FPCERoot;
              Done := TRUE;
            end
            else
            begin
              if (PrimaryDiagRoot = RData.FPCERoot) then
              begin
                PrimaryDiagRoot := nil;
                Done := TRUE;
              end;
            end;
          end
          else if (Assigned(RData.FChoices)) and (Assigned(RData.FChoicePrompt))
          then
          begin
            k := 0;
            for j := 0 to RData.FChoices.Count - 1 do
            begin
              if RemDataChoiceActive(RData, j, encDt) then
              begin
                if (Primary) then
                begin
                  if (Assigned(RData.FChoices.Objects[j])) and
                    (copy(RData.FChoicePrompt.FValue, k + 1, 1) = '1') then
                  begin
                    PrimaryDiagRoot := TRemPCERoot(RData.FChoices.Objects[j]);
                    Done := TRUE;
                    break;
                  end;
                end
                else
                begin
                  if (Assigned(RData.FChoices.Objects[j])) and
                    (PrimaryDiagRoot = TRemPCERoot(RData.FChoices.Objects[j]))
                  then
                  begin
                    PrimaryDiagRoot := nil;
                    Done := TRUE;
                    break;
                  end;
                end;
                inc(k);
              end;
            end;
          end;
        end;
        if Done then
          break;
      end;
    end;
    if (pt = ptUCUMCode) and assigned(FUCUMPrompt) then
      FUCUMPrompt.FUCUMText := GetUCUMText(StrToInt64Def(Value,0));

    if (Assigned(FParent) and Assigned(FParent.FData) and IsSyncPrompt(pt)) and (not genFindOnly) then
    begin
      for i := 0 to FParent.FData.Count - 1 do
      begin
        RData := TRemData(FParent.FData[i]);
        if (Assigned(RData.FPCERoot)) and (RemDataActive(RData, encDt)) then
          RData.FPCERoot.Sync(Self);
        if (Assigned(RData.FChoices)) then
        begin
          for j := 0 to RData.FChoices.Count - 1 do
          begin
            if (Assigned(RData.FChoices.Objects[j])) and
              RemDataChoiceActive(RData, j, encDt) then
              TRemPCERoot(RData.FChoices.Objects[j]).Sync(Self);
          end;
        end;
      end;
    end;
  end;
  if (not NeedRefresh) then
    NeedRefresh := (GetValue <> Value);
  if (NeedRefresh and Assigned(FCurrentControl) and FParent.FReminder.Visible) then
  begin
    case pt of
      ptComment, ptMagnitude:
        begin
          try
            tmp := GetValue;
            (FCurrentControl as TEdit).Text := tmp;
          except

          end;
        end;


      ptQuantity:
        (FCurrentControl as TUpDown).Position := StrToIntDef(GetValue, 1);

      (* ptSkinReading:
        (FCurrentControl as TUpDown).Position := StrToIntDef(GetValue,0); *)

      ptVisitDate:
        begin
          try
            (FCurrentControl as TORDateCombo).FMDate := StrToFloat(GetValue);
          except
            on EConvertError do
              (FCurrentControl as TORDateCombo).FMDate := 0;
            else
              raise;
          end;
        end;

        ptDate, ptDateTime:
        begin
          try
            (FCurrentControl as TORDateBox).FMDateTime := StrToFloatDef(GetValue, 0);
          except
            on EConvertError do
              (FCurrentControl as TORDateBox).FMDateTime := 0;
            else
              raise;
          end;
        end;

      ptPrimaryDiag, ptAdd2PL, ptContraindicated:
        (FCurrentControl as TORCheckBox).Checked := (GetValue = BOOLCHAR[TRUE]);

      ptVisitLocation:
        begin
          tmp := GetValue;
          with (FCurrentControl as TORComboBox) do
          begin
            if (Piece(tmp, U, 1) = '0') then
            begin
              if Items.Count > 0 then
                Items[0] := tmp
              else
                Items.Add(tmp);
              SelectByID('0');
            end
            else
              SelectByID(tmp);
          end;
        end;

      ptWHPapResult:
        (FCurrentControl as TORCheckBox).Checked := (GetValue = BOOLCHAR[TRUE]);

      ptWHNotPurp:
        (FCurrentControl as TORCheckBox).Checked := (GetValue = BOOLCHAR[TRUE]);

      ptExamResults, ptSkinResults, ptLevelSeverity, ptSeries, ptReaction,
        ptLevelUnderstanding, ptSkinReading, ptUCUMCode:
        (FCurrentControl as TORComboBox).SelectByID(GetValue);

    else
      if (pt = ptVitalEntry) then
      begin
        if (FCurrentControl is TORComboBox) then
          (FCurrentControl as TORComboBox).SelectByID(VitalValue)
        else if (FCurrentControl is TVitalEdit) then
        begin
          with (FCurrentControl as TVitalEdit) do
          begin
            Text := VitalValue;
            if (Assigned(LinkedCombo)) then
            begin
              tmp := VitalUnitValue;
              if (tmp <> '') then
                LinkedCombo.Text := VitalUnitValue
              else
                LinkedCombo.ItemIndex := 0;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TRemPrompt.SetValueFromParent(Value: string);
begin
  FFromParent := TRUE;
  try
    SetValue(Value);
  finally
    FFromParent := FALSE;
  end;
end;

procedure TRemPrompt.UCUMNeedData(Sender: TObject; const StartFrom: string;
  Direction, InsertAt: Integer);
begin
  if (FLastUCUMStartFrom <> StartFrom) or
     (FLastUCUMDirection <> Direction) then
  begin
    if not assigned(FLastUCUMData) then
      FLastUCUMData := TStringList.Create;
    FLastUCUMStartFrom := StartFrom;
    FLastUCUMDirection := Direction;
    ListUCUMCodes(StartFrom, Direction, FLastUCUMData);
  end;
  TORComboBox(Sender).ForDataUse(FLastUCUMData);
end;

procedure TRemPrompt.InitValue;
var
  Value: string;
  pt: TRemPromptType;
  idx, i, j: integer;
  TempSL: TORStringList;
  Found: boolean;
  RData: TRemData;

begin
  Value := InternalValue;
  pt := PromptType;
  if (ord(pt) >= ord(low(TRemPromptType))) and (ComboPromptTags[pt] <> 0) then
  begin
    TempSL := TORStringList.Create;
    try
      GetPCECodes(TempSL, ComboPromptTags[pt]);
      idx := TempSL.CaseInsensitiveIndexOfPiece(Value, U, 1);
      if (idx < 0) then
        idx := TempSL.CaseInsensitiveIndexOfPiece(Value, U, 2);
      if (idx >= 0) then
        Value := Piece(TempSL[idx], U, 1);
    finally
      TempSL.Free;
    end;
  end;
  if ((not Forced) and Assigned(FParent) and Assigned(FParent.FData) and
    IsSyncPrompt(pt)) then
  begin
    Found := FALSE;
    for i := 0 to FParent.FData.Count - 1 do
    begin
      RData := TRemData(FParent.FData[i]);
      if (Assigned(RData.FPCERoot)) then
        Found := RData.FPCERoot.GetValue(pt, Value);
      if (not Found) and (Assigned(RData.FChoices)) then
      begin
        for j := 0 to RData.FChoices.Count - 1 do
        begin
          if (Assigned(RData.FChoices.Objects[j])) then
          begin
            Found := TRemPCERoot(RData.FChoices.Objects[j]).GetValue(pt, Value);
            if (Found) then
              break;
          end;
        end;
      end;
      if (Found) then
        break;
    end;
  end;
  FInitializing := TRUE;
  try
    SetValueFromParent(Value);
  finally
    FInitializing := FALSE;
  end;
end;

function TRemPrompt.ForcedCaption: string;
var
  pt: TRemPromptType;

begin
  Result := Caption;
  if (Result = '') then
  begin
    pt := PromptType;
    if (pt = ptDataList) then
    begin
      if (Assigned(FData)) then
      begin
        if (FData.DataType = rdtDiagnosis) then
          Result := 'Diagnosis'
        else if (FData.DataType = rdtProcedure) then
          Result := 'Procedure'
        else if (FData.DataType = rdtStandardCode) then
          Result := 'Standard Codes';
      end;
    end
    else if (pt = ptVitalEntry) then
      Result := VitalDesc[VitalType] + ':'
    else if (pt = ptMHTest) then
      Result := 'Perform ' + FData.Narrative
    else if (pt = ptGAF) then
      Result := 'GAF Score'
    else
      Result := PromptDescriptions[pt];
    if (Result = '') then
      Result := 'Prompt';
  end;
  if (copy(Result, length(Result), 1) = ':') then
    delete(Result, length(Result), 1);
end;

function TRemPrompt.VitalType: TVitalType;
begin
  Result := vtUnknown;
  if (Assigned(FData)) then
    Result := Code2VitalType(FData.InternalValue);
end;

procedure TRemPrompt.VitalVerify(Sender: TObject);
var
  vedt: TVitalEdit;
  vcbo: TVitalComboBox;
  AObj: TWinControl;

begin
  if (Sender is TVitalEdit) then
  begin
    vedt := TVitalEdit(Sender);
    vcbo := vedt.LinkedCombo;
  end
  else if (Sender is TVitalComboBox) then
  begin
    vcbo := TVitalComboBox(Sender);
    vedt := vcbo.LinkedEdit;
  end
  else
  begin
    vcbo := nil;
    vedt := nil;
  end;
  AObj := Screen.ActiveControl;
  if ((not Assigned(AObj)) or ((AObj <> vedt) and (AObj <> vcbo))) then
  begin
    if (vedt.Tag = TAG_VITHEIGHT) then
      vedt.Text := ConvertHeight2Inches(vedt.Text);
    if VitalInvalid(vedt, vcbo) then
      FParent.FReminder.DoFocus(vedt);
  end;
end;

function TRemPrompt.VitalUnitValue: string;
var
  vt: TVitalType;

begin
  vt := VitalType;
  if (vt in [vtTemp, vtHeight, vtWeight]) then
  begin
    Result := Piece(GetValue, ';', 2);
    if (Result = '') then
    begin
      case vt of
        vtTemp:
          Result := 'F';
        vtHeight:
          Result := 'IN';
        vtWeight:
          Result := 'LB';
      end;
      SetPiece(FValue, ';', 2, Result);
    end;
  end
  else
    Result := '';
end;

function TRemPrompt.VitalValue: string;
begin
  Result := Piece(GetValue, ';', 1);
end;

/// <summary>Starts PDMP request/review from the template</summary>
procedure TRemPrompt.DoPDMP(Sender: TObject);
begin
  if assigned(frmFrame.PDMPMgr) then
    begin
//      TButton(FCurrentcontrol).Enabled := False;

//      frmFrame.PDMPMgr.ShowNow := True;
      frmFrame.PDMPMgr.AlignView := alLeft;
      frmFrame.PDMPMgr.PDMPNoteIEN := IntToStr(fNotes.frmNotes.EditNoteIEN);
      frmFrame.pdmpRun(alLeft);
    end;
end;

procedure TRemPrompt.DoView(Sender: TObject);
var
  IEN, Value: string;
  aList: TStrings;
  canPrint, vistaPrint: boolean;
  header, vistaDevice: string;

begin
  if pxrmworking then
    exit;
  aList := TStringList.Create;
  try
    begin
      // IEN := Piece(TRemData(FParent.FData[0]).FRec3, U, 6);
      canPrint := FALSE;
      vistaPrint := Piece(FRec4, U, 12) = 'V';
      IEN := Piece(FParent.FRec1, U, 2);
      if FParent.FData.Count > 0 then
        Value := Piece(TRemData(FParent.FData[0]).FRec3, U, 14)
      else
        Value := '';
      getGeneralFindingText(aList, canPrint, header, patient.dfn, IEN, Value);
      if Piece(FRec4, U, 12) = 'N' then
        canPrint := FALSE;
      if vistaPrint then
      begin
        vistaDevice := VistAPrintReportBox(aList, header);
        if vistaPrint then
          SetValue(Piece(vistaDevice, U, 1));
      end
      else
        begin
          self.reportView := ModelessReportBox(aList, header, canPrint, false);
          FOldReportViewOnDestroy := self.reportView.OnDestroy;
          self.reportView.OnDestroy := self.reportViewClosed;
        end;
      ViewRecord := TRUE;
    end;
  finally
    FreeAndNil(aList);
    pxrmDoneWorking;
  end;
end;

procedure TRemPrompt.DoWHReport(Sender: TObject);
Var
  comp, IEN: string;
  i: integer;
  lst: TStringList;

begin
  if pxrmWorking then
    exit;
  try
    for i := 0 to FParent.FData.Count - 1 do
      begin
        comp := Piece(TRemData(FParent.FData[i]).FRec3, U, 4);
        IEN := Piece(TRemData(FParent.FData[i]).FRec3, U, 6);
      end;
    lst := TStringList.Create;
    try
      CallVistA('ORQQPXRM GET WH REPORT TEXT', [IEN], lst);
      ReportBox(lst, 'Procedure Report Results', TRUE);
    finally
      lst.Free;
    end;
  finally
    pxrmDoneWorking;
  end;
end;

procedure TRemPrompt.ViewWHText(Sender: TObject);
var
  WHRecNum, WHTitle: string;
  i: integer;
  lst: TStringList;

begin
  if pxrmWorking then
    exit;
  try
    for i := 0 to FParent.FData.Count - 1 do
      begin
        if Piece(TRemData(FParent.FData[i]).FRec3, U, 4) = 'WH' then
          begin
            WHRecNum := (Piece(TRemData(FParent.FData[i]).FRec3, U, 6));
            WHTitle := (Piece(TRemData(FParent.FData[i]).FRec3, U, 8));
          end;
      end;
    lst := TStringList.Create;
    try
      CallVistA('ORQQPXRM GET WH LETTER TEXT', [WHRecNum], lst);
      ReportBox(lst, 'Women Health Notification Purpose: ' + WHTitle, FALSE);
    finally
      lst.Free;
    end;
  finally
    pxrmDoneWorking;
  end;
end;

procedure TRemPrompt.DoMHTest(Sender: TObject);
var
  TmpSL, tmpScores, tmpResults, linkList, elementList, promptList: TStringList;
  i, l: integer;
  Before, After, Score, dien, linkType, linkItem, linkSeq, value: string;
  MHRequired, doLink: boolean;

begin
  if pxrmworking then
    exit;
  linkList := TStringList.Create;
  if (Sender is TCPRSDialogButton) then
    (Sender as TCPRSDialogButton).Enabled := FALSE;
//  dolink := false;
  try
    dien := Piece(self.FRec4, U, 2);
    if FParent.FReminder.MHTestArray = nil then
      FParent.FReminder.MHTestArray := TORStringList.Create;
    if (MHTestAuthorized(FData.Narrative)) then
    begin
      FParent.FReminder.BeginTextChanged;
      try
        if (FParent.IncludeMHTestInPN) then
          TmpSL := TStringList.Create
        else
          TmpSL := nil;
        if Piece(Self.FData.FRec3, U, 13) = '1' then
          MHRequired := TRUE
        else
          MHRequired := FALSE;
        Before := GetValue;
        After := PerformMHTest(Before, FData.Narrative, TmpSL, MHRequired, RemForm.PCEObj);
        if uInit.TimedOut then
          After := '';
        if Piece(After, U, 1) = 'New MH dll' then
        begin
          if Piece(After, U, 2) = 'COMPLETE' then
          begin
            FParent.FReminder.MHTestArray.Add(FData.Narrative + U +
              FParent.FReminder.IEN);
            Self.FMHTestComplete := 1;
            Score := Piece(After, U, 3);

            if FParent.ResultDlgID <> '' then
            begin
              tmpScores := TStringList.Create;
              tmpResults := TStringList.Create;
              PiecestoList(copy(Score, 2, length(Score)), '*', tmpScores);
              PiecestoList(FParent.ResultDlgID, '~', tmpResults);
              GetMHResultText(FMiscText, tmpResults, tmpScores, dien, linkList);
              if tmpScores <> nil then
                tmpScores.Free;
              if tmpResults <> nil then
                tmpResults.Free;
            end;
            if (FMiscText <> '') then
              FMiscText := FMiscText + '~<br>';
            if TmpSL <> nil then
            begin
              for i := 0 to TmpSL.Count - 1 do
              begin
                if (i > 0) then
                  FMiscText := FMiscText + CRCode;
                FMiscText := FMiscText + TmpSL[i];
              end;
            end;
            // end;
            // ExpandTIUObjects(FMiscText, RemForm.PCEObj.VisitString);
          end
          else if Piece(After, U, 2) = 'INCOMPLETE' then
          begin
            FParent.FReminder.MHTestArray.Add(FData.Narrative + U +
              FParent.FReminder.IEN);
            Self.FMHTestComplete := 2;
            FMiscText := '';
            After := 'X';
          end
          else if Piece(After, U, 2) = 'CANCELLED' then
          begin
            Self.FMHTestComplete := 0;
            FMiscText := '';
            After := '';
          end;
          SetValue(After);
          end;
      finally
        if not uInit.TimedOut then
          FParent.FReminder.EndTextChanged(Sender);
      end;
      if not uInit.TimedOut then
        if (FParent.ElemType = etDisplayOnly) and (not Assigned(FParent.FParent))
        then
          RemindersInProcess.Notifier.Notify;
    end
    else
      InfoBox('Not Authorized to score the ' + FData.Narrative + ' test.',
        'Insufficient Authorization', MB_OK + MB_ICONERROR);
//  finally
//    if (Sender is TCPRSDialogButton) then
//    begin
//      (Sender as TCPRSDialogButton).Enabled := TRUE;
//      (Sender as TCPRSDialogButton).SetFocus;
//    end;
  if linkList.Count > 0 then
    begin
      try
        begin
          promptList := TStringList.Create;
          elementList := TStringList.Create;
          doLink := false;
          for l := 0 to linkList.Count - 1 do
            begin
              linkItem := Piece(linkList.Strings[l], U, 1);
              if linkItem = '' then continue;
              linkType := Piece(linkList.Strings[l], U, 2);
              if linkType = '' then continue;
              value := Piece(linkList.Strings[l], U, 3);
              if value = '' then continue;
              linkSeq := Piece(linkList.Strings[l],u, 4);
              if linkType = 'ELEMENT' then elementList.Add(linkItem + U + value + U + '' + U + linkSeq)
              else
                begin
                  if value = 'REQUIRED' then promptList.Add(linkItem + U + linkType + U + 'REQUIRED' + U + U + linkSeq)
                  else promptList.Add(linkItem + U + linkType + U + 'VALUE' + U + value + U + linkSeq);
                end;
              if FParent.buildLinkSeq(linkSeq, self.FParent.FID, Piece(self.FParent.FRec1, u, 3)) then
                doLink := true;
            end;
            if doLink then self.FParent.FReminder.findLinkItem(elementList, promptList, Piece(self.FParent.FRec1, u, 3));
      end;
    finally
//        freeAndNil(linkList);
//        if elementList <> nil then freeAndNil(elementList);
//        if promptList <> nil then freeAndNil(promptList);
      end;
    end;
    finally
      if (Sender is TCPRSDialogButton) then
        begin
          (Sender as TCPRSDialogButton).Enabled := TRUE;
          FParent.FReminder.DoFocus(Sender as TCPRSDialogButton);
        end;
      pxrmdoneWorking;
  end;
end;

procedure TRemPrompt.DoVimm(Sender: TObject);
var
  i, r: integer;
  resultList: TStringList;
  Code, codeSys, temp, VIMM, vimmFrec3: string;
  Data, dataResult: TVimmResult;
  Found: boolean;
  RData, RemData: TRemData;
  codesLst: TStrings;
  promptList: TStringList;
  Prompt: TRemPrompt;

begin
  resultList := TStringList.Create;
  promptList := TStringList.Create;
  uVimmInputs.documentType := '';
  if uVimmInputs.DataList = nil then
    uVimmInputs.DataList := TStringList.Create;
  if uVimmInputs.NewList <> nil then
    uVimmInputs.NewList.Clear
  else
    uVimmInputs.NewList := TStringList.Create;
  codesLst := TStringList.Create;
  try
    FParent.FReminder.BeginTextChanged;
    // search for existing VImm Object for element (edits)
    uVimmInputs.collapseICE := True;
    for i := 0 to FParent.FData.Count - 1 do
    begin
      vimmFrec3 := TRemData(FParent.FData[i]).FRec3;
      if (Piece(vimmFrec3, U, 4) <> 'IMM') and (Piece(vimmFrec3, U, 4) <> 'SK')
      then
        continue;
      if Piece(vimmFrec3, U, 4) = 'SK' then
        uVimmInputs.isSkinTest := True
      else
        uVimmInputs.isSkinTest := FALSE;

      if TRemData(FParent.FData[i]).vimmResult <> nil then
      begin
        Data := TRemData(FParent.FData[i]).vimmResult.copy;
        uVimmInputs.DataList.AddObject('DATA' + U + Data.ID, Data);
        continue;
      end;
      VIMM := Piece(vimmFrec3, U, 6) + U + Piece(vimmFrec3, U, 8);
      uVimmInputs.NewList.Add('VIMM' + U + VIMM);
      if (FParent.Historical) and (not uVimmInputs.isSkinTest) then
        uVimmInputs.documentType := '1'
      else
        uVimmInputs.documentType := '0';
    end;

    uVimmInputs.noGrid := FALSE;
    uVimmInputs.makeNote := FALSE;
    uVimmInputs.patientName := patient.name;
    uVimmInputs.patientIEN := patient.dfn;
    uVimmInputs.userName := user.name;
    uVimmInputs.userIEN := user.DUZ;
    if FParent.Historical then
      uVimmInputs.selectionType := 'historical'
    else
      uVimmInputs.selectionType := 'current';
    uVimmInputs.encounterProviderName :=
      RemForm.PCEObj.Providers.PCEProviderName;
    uVimmInputs.encounterProviderIEN := RemForm.PCEObj.Providers.PCEProvider;
    if ((uVimmInputs.encounterProviderName = '') or (uVimmInputs.encounterProviderIEN < 1)) and
        (encounter.Provider > 0) then
      begin
        uVimmInputs.encounterProviderName := encounter.ProviderName;
        uVimmInputs.encounterProviderIEN := encounter.Provider;
      end;

    uVimmInputs.encounterLocation := RemForm.PCEObj.Location;
    uVimmInputs.encounterCategory := RemForm.PCEObj.VisitCategory;
    uVimmInputs.dateEncounterDateTime := RemForm.PCEObj.VisitDateTime;
    uVimmInputs.VisitString := RemForm.PCEObj.VisitString;
    if (Assigned(uVimmInputs.DataList)) and (uVimmInputs.DataList.Count > 0)
    then
      uVimmInputs.startInEditMode := FALSE
    else
      uVimmInputs.startInEditMode := True;
    if (FParent.FData.Count > 0) and
      (Piece(TRemData(FParent.FData[0]).FRec3, U, 18) = '1') then
    begin
      uVimmInputs.noGrid := True;
      uVimmInputs.immunizationReading := True;
      uVimmInputs.startInEditMode := True;
    end
    else
      uVimmInputs.immunizationReading := FALSE;
    if uVimmInputs.isSkinTest and FParent.Historical then
    begin
      uVimmInputs.noGrid := True;
      uVimmInputs.startInEditMode := True;
    end;
    if FParent.contraindication then
      uVimmInputs.documentType := '2'
    else if FParent.refused then
      uVimmInputs.documentType := '3';
    if not uVimmInputs.isSkinTest then
    begin
      uVimmInputs.defaultSeries := Self.getSeries;
    end;
    uVimmInputs.fromCover := FALSE;
    if performVimm(resultList, FALSE) = FALSE then
      exit;
    for i := FParent.FData.Count - 1 downto 0 do
    begin
      RData := TRemData(FParent.FData[i]);
      if Assigned(FParent.FPrompts) then
      begin
        for r := 0 to FParent.FPrompts.Count - 1 do
        begin
          Prompt := TRemPrompt(FParent.FPrompts[r]);
          if Prompt.FData = RData then
          begin
            Prompt.FData := nil;
            promptList.AddObject(RData.FRec3, Prompt);
          end;
        end;
      end;
      FParent.FData.delete(i);
      RData.Free;
    end;

    for r := 0 to resultList.Count - 1 do
    begin
      dataResult := TVimmResult(resultList.Objects[r]);
      RemData := TRemData(FParent.FData[FParent.FData.Add(TRemData.Create)]);
      RemData.FParent := FParent;
      RemData.FRec3 := FOriginalDataRec3;
      SetPiece(RemData.FRec3, U, 6, dataResult.ID);
      SetPiece(RemData.FRec3, U, 8, dataResult.name);
      RemData.vimmResult := dataResult.copy;
      if dataResult.cptCode <> '' then
        codesLst.Add(dataResult.procedureDelimitedStr);
      if dataResult.dxCode <> '' then
        codesLst.Add(dataResult.diagnosisDelimitedStr);
    end;

    for i := 0 to FParent.FCodesList.Count - 1 do
    begin
      Found := FALSE;
      temp := FParent.FCodesList.Strings[i];
      codeSys := Piece(temp, U, 4);
      Code := Piece(temp, U, 7);
      for r := 0 to codesLst.Count - 1 do
      begin
        temp := codesLst.Strings[r];
        if (pos(codeSys, Piece(temp, U, 1)) > 0) and (Code = Piece(temp, U, 2))
        then
        begin
          Found := True;
          break;
        end;
      end;
      if Found then
        continue;
      RemData := TRemData(FParent.FData[FParent.FData.Add(TRemData.Create)]);
      RemData.FParent := FParent;
      RemData.FRec3 := FParent.FCodesList.Strings[i];
    end;

    if (promptList.Count > 0) and (FParent.FData.Count > 0) then
    begin
      for r := promptList.Count - 1 downto 0 do
      begin
        for i := 0 to FParent.FData.Count - 1 do
        begin
          RData := TRemData(FParent.FData[i]);
          if (Piece(RData.FRec3, U, 6) = Piece(promptList[r], U, 6)) and
            (Piece(RData.FRec3, U, 8) = Piece(promptList[r], U, 8)) then
          begin
            TRemPrompt(promptList.Objects[r]).FData := RData;
            promptList.delete(r);
            break;
          end;
        end;
      end;
    end;

    if promptList.Count > 0 then
    begin
      for r := 0 to promptList.Count - 1 do
      begin
        Prompt := TRemPrompt(promptList.Objects[r]);
        RemData := TRemData(FParent.FData[FParent.FData.Add(TRemData.Create)]);
        RemData.FParent := FParent;
        RemData.FRec3 := Prompt.FOriginalDataRec3;
        Prompt.FData := RemData;
      end;
    end;

  finally
    if resultList <> nil then
      FreeAndNil(resultList);
    if codesLst <> nil then
      FreeAndNil(codesLst);
    clearResults;
    FreeAndNil(promptList);
    FParent.FReminder.EndTextChanged(Sender);
  end;
end;

procedure TRemPrompt.GAFHelp(Sender: TObject);
begin
  inherited;
  GotoWebPage(GAFURL);
end;

function TRemPrompt.getDataType: string;
begin
  Result := Piece(FData.FRec3, U, r3Type);
end;

function TRemPrompt.getSeries: string;
var
i: integer;
begin
  result := '';
  if FParent.FPrompts.count = 1 then
    exit;
  for I := 0 to FParent.FPrompts.Count - 1 do
    begin
      if piece(TRemPrompt(FParent.FPrompts[i]).FRec4, u, 4) <> 'IMM_SER' then
        continue;
      result := piece(TRemPrompt(FParent.FPrompts[i]).FRec4, u, 6)
    end;
end;

function TRemPrompt.getUCumData: string;
begin
  Result := Pieces(self.FRec4, u, 30, 36);
end;

//procedure TRemPrompt.EditEnter2(Sender: TObject);
//var
//  edt: TCPRSDialogFieldEdit;
//
//begin
//  edt := TCPRSDialogFieldEdit(Sender);
//  ParseMagUCUM4StandardCodes(edt);
//end;

procedure TRemPrompt.EditEnter(Sender: TObject);
var
  edt: TCPRSDialogFieldEdit;

begin
  if assigned(FData) then
  begin
    edt := TCPRSDialogFieldEdit(Sender);
    //data := GetMagUCUMData(RemDataCodes[FData.DataType],FData.Code);
    ParseMagUCUMData(UCUMInfo, nil, edt, nil, edt.AssociateLabel);
    FUCUMText := edt.AssociateLabel.Caption;
  end;
end;

procedure TRemPrompt.EditExit(Sender: TObject);
begin
  if Sender is TCPRSDialogFieldEdit then
    PostValidateMag(TCPRSDialogFieldEdit(Sender));
end;

function TRemPrompt.EntryID: string;
begin
  Result := FParent.EntryID + '/' + IntToStr(integer(Self));
end;

function TRemPrompt.EventType: string;
begin
  Result := Piece(FRec4, U, 29);
end;

procedure TRemPrompt.EditKeyPress(Sender: TObject; var Key: Char);
begin
  if PromptType = ptMagnitude then
    ValidateMagKeyPress(Sender, Key)
  else
  begin
    if (Key = '?') and (Sender is TCustomEdit) and
    ((TCustomEdit(Sender).Text = '') or (TCustomEdit(Sender).SelStart = 0)) then
      Key := #0;
  end;
end;

{ TRemPCERoot }

destructor TRemPCERoot.Destroy;
begin
  KillObj(@FData);
  KillObj(@FForcedPrompts);
  inherited;
end;

procedure TRemPCERoot.Done(Data: TRemData);
var
  i, idx: integer;

begin
  if (Assigned(FForcedPrompts) and Assigned(Data.FParent) and
    Assigned(Data.FParent.FPrompts)) then
  begin
    for i := 0 to Data.FParent.FPrompts.Count - 1 do
      UnSync(TRemPrompt(Data.FParent.FPrompts[i]));
  end;
  FData.Remove(Data);
  if (FData.Count <= 0) then
  begin
    idx := PCERootList.IndexOfObject(Self);
    // if(idx < 0) then
    // idx := PCERootList.IndexOf(FID);
    if (idx >= 0) then
      PCERootList.delete(idx);
    if PrimaryDiagRoot = Self then
      PrimaryDiagRoot := nil;
    Free;
  end;
end;

class function TRemPCERoot.GetRoot(Data: TRemData; Rec3: string;
  Historical: boolean): TRemPCERoot;
var
  DID: string;
  idx: integer;
  obj: TRemPCERoot;

begin
  if (Data.DataType = rdtVitals) then
    DID := 'V' + Piece(Rec3, U, 6)
  else
  begin
    if (Historical) then
    begin
      inc(HistRootCount);
      DID := IntToStr(HistRootCount);
    end
    else
      DID := '0';
    DID := DID + U + Piece(Rec3, U, r3Type) + U + Piece(Rec3, U, r3Code) + U +
      Piece(Rec3, U, r3Cat) + U + Piece(Rec3, U, r3Nar);
  end;
  idx := -1;
  if (not Assigned(PCERootList)) then
    PCERootList := TStringList.Create
  else if (PCERootList.Count > 0) then
    idx := PCERootList.IndexOf(DID);
  if (idx < 0) then
  begin
    obj := TRemPCERoot.Create;
    try
      obj.FData := TList.Create;
      obj.FID := DID;
      idx := PCERootList.AddObject(DID, obj);
    except
      obj.Free;
      raise;
    end;
  end;
  Result := TRemPCERoot(PCERootList.Objects[idx]);
  Result.FData.Add(Data);
end;

function TRemPCERoot.GetValue(PromptType: TRemPromptType;
  var NewValue: string): boolean;
var
  ptS: string;
  i: integer;

begin
  ptS := Char(ord('D') + ord(PromptType));
  i := pos(ptS, FValueSet);
  if (i = 0) then
    Result := FALSE
  else
  begin
    NewValue := Piece(FValue, U, i);
    Result := TRUE;
  end;
end;

procedure TRemPCERoot.Sync(Prompt: TRemPrompt);
var
  i, j: integer;
  RData: TRemData;
  Prm: TRemPrompt;
  pt: TRemPromptType;
  ptS, Value: string;

begin
  // if(assigned(Prompt.FParent) and ((not Prompt.FParent.FChecked) or
  // (Prompt.FParent.ElemType = etDisplayOnly))) then exit;
  if (Assigned(Prompt.FParent) and (not Prompt.FParent.FChecked)) then
    exit;
  pt := Prompt.PromptType;
  Value := Prompt.GetValue;
  if (Prompt.Forced) then
  begin
    if (not Prompt.FInitializing) then
    begin
      if (not Assigned(FForcedPrompts)) then
        FForcedPrompts := TStringList.Create;
      if (FForcedPrompts.IndexOfObject(Prompt) < 0) then
      begin
        for i := 0 to FForcedPrompts.Count - 1 do
        begin
          Prm := TRemPrompt(FForcedPrompts.Objects[i]);
          if (pt = Prm.PromptType) and (FForcedPrompts[i] <> Value) and
            (Prm.FParent.IsChecked) then
            raise EForcedPromptConflict.Create('Forced Value Error:' + CRLF +
              CRLF + Prompt.ForcedCaption +
              ' is already being forced to another value.');
        end;
        FForcedPrompts.AddObject(Value, Prompt);
      end;
    end;
  end
  else
  begin
    if (Assigned(FForcedPrompts)) then
    begin
      for i := 0 to FForcedPrompts.Count - 1 do
      begin
        Prm := TRemPrompt(FForcedPrompts.Objects[i]);
        if (pt = Prm.PromptType) and (FForcedPrompts[i] <> Value) and
          (Prm.FParent.IsChecked) then
        begin
          Prompt.SetValue(FForcedPrompts[i]);
          if (Assigned(Prompt.FParent)) then
            Prompt.FParent.cbClicked(nil); // Forces redraw
          exit;
        end;
      end;
    end;
  end;
  if (Prompt.FInitializing) then
    exit;
  for i := 0 to FData.Count - 1 do
    inc(TRemData(FData[i]).FSyncCount);
  ptS := Char(ord('D') + ord(pt));
  i := pos(ptS, FValueSet);
  if (i = 0) then
  begin
    FValueSet := FValueSet + ptS;
    i := length(FValueSet);
  end;
  SetPiece(FValue, U, i, Value);
  for i := 0 to FData.Count - 1 do
  begin
    RData := TRemData(FData[i]);
    if (RData.FSyncCount = 1) and (Assigned(RData.FParent)) and
      (Assigned(RData.FParent.FPrompts)) then
    begin
      for j := 0 to RData.FParent.FPrompts.Count - 1 do
      begin
        Prm := TRemPrompt(RData.FParent.FPrompts[j]);
        if (Prm <> Prompt) and (pt = Prm.PromptType) and (not Prm.Forced) then
          Prm.SetValue(Prompt.GetValue);
      end;
    end;
  end;
  for i := 0 to FData.Count - 1 do
  begin
    RData := TRemData(FData[i]);
    if (RData.FSyncCount > 0) then
      dec(RData.FSyncCount);
  end;
end;

procedure TRemPCERoot.UnSync(Prompt: TRemPrompt);
var
  idx: integer;

begin
  if (Assigned(FForcedPrompts) and Prompt.Forced) then
  begin
    idx := FForcedPrompts.IndexOfObject(Prompt);
    if (idx >= 0) then
      FForcedPrompts.delete(idx);
  end;
end;

{ TControlInfo }

destructor TControlInfo.Destroy;
begin
  if not (csDestroying in Control.ComponentState) then
  begin
    Control.RemoveFreeNotification(Prompt);
    if Control = Prompt.FCurrentControl then
      Prompt.FCurrentControl := nil;
    FreeAndNil(Control);
  end;
  inherited;
end;

initialization

InitReminderObjects;

finalization

FreeReminderObjects;

end.
