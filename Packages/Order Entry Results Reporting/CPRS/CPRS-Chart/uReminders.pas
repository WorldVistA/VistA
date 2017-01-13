unit uReminders;

interface

uses
  Windows, Messages, Classes, Controls, StdCtrls, SysUtils, ComCtrls, Menus,
  Graphics, Forms, ORClasses, ORCtrls, ORDtTm, ORFn, ORNet, Dialogs, uPCE, uVitals,
  ExtCtrls, fDrawers, fDeviceSelect, TypInfo;

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
    FWHReviewIEN: string;  // AGP CHANGE 23.13 Allow for multiple processing of WH Review of Result Reminders
    FRemWipe: integer;
    FMHTestArray: TORStringList;
  protected
    function GetIEN: string; virtual;
    function GetPrintName: string; virtual;
    procedure BeginNeedRedraw;
    procedure EndNeedRedraw(Sender: TObject);
    procedure BeginTextChanged;
    procedure EndTextChanged(Sender: TObject);
    function GetDlgSL: TORStringList;
    procedure ComboBoxResized(Sender: TObject);
    procedure ComboBoxCheckedText(Sender: TObject; NumChecked: integer; var Text: string);
    function AddData(Lst: TStrings; Finishing: boolean = FALSE; Historical: boolean = FALSE): integer;
    function Visible: boolean;
  public
    constructor BaseCreate;
    constructor Create(ADlgData: string);
    destructor Destroy; override;
    procedure FinishProblems(List: TStrings; var MissingTemplateFields: boolean);
    function BuildControls(ParentWidth: integer; AParent, AOwner: TWinControl): TWinControl;
    function Processing: boolean;
    procedure AddText(Lst: TStrings);
    property PrintName: string read GetPrintName;
    property IEN: string read GetIEN;
    property Elements: TStringList read FElements;
    property OnNeedRedraw: TNotifyEvent read FOnNeedRedraw write FOnNeedRedraw;
    property OnTextChanged: TNotifyEvent read FOnTextChanged write FOnTextChanged;
    property PCEDataObj: TPCEData read FPCEDataObj write FPCEDataObj;
    property DlgData: string read FDlgData; //AGP Change 24.8
    property WHReviewIEN: string read FWHReviewIEN write FWHReviewIEN;  //AGP CHANGE 23.13
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
  TRDElemType = (etCheckBox, etTaxonomy, etDisplayOnly);

  TRemPrompt = class;

  TRemDlgElement = class(TObject)
  private
    FReminder: TReminderDialog;
    FParent: TRemDlgElement;
    FChildren: TList; // Points to other TRemDlgElement objects
    FData: TList; // List of TRemData objects
    FPrompts: TList; // list of TRemPrompts objects
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
    FVitalDateTime: TFMDateTime;  //AGP Changes 26.1
  protected
    procedure Check4ChildrenSharedPrompts;
    function ShowChildren: boolean;
    function EnableChildren: boolean;
    function Enabled: boolean;
    procedure SetChecked(const Value: boolean);
    procedure UpdateData;
    function oneValidCode(Choices: TORStringList; ChoicesActiveDates: TList; encDt: TFMDateTime): String;
    procedure setActiveDates(Choices: TORStringList; ChoicesActiveDates: TList; ActiveDates: TStringList);
    procedure GetData;
    function TrueIndent: integer;
    procedure cbClicked(Sender: TObject);
    procedure cbEntered(Sender: TObject);
    procedure FieldPanelEntered(Sender: TObject);
    procedure FieldPanelExited(Sender: TObject);
    procedure FieldPanelKeyPress(Sender: TObject; var Key: Char);
    procedure FieldPanelOnClick(Sender: TObject);
    procedure FieldPanelLabelOnClick(Sender: TObject);

    function BuildControls(var Y: integer; ParentWidth: integer;
                                BaseParent, AOwner: TWinControl): TWinControl;
    function AddData(Lst: TStrings; Finishing: boolean; AHistorical: boolean = FALSE): integer;
    procedure FinishProblems(List: TStrings);
    function IsChecked: boolean;
    procedure SubCommentChange(Sender: TObject);
    function EntryID: string;
    procedure FieldPanelChange(Sender: TObject);
    procedure GetFieldValues(FldData: TStrings);
    procedure ParentCBEnter(Sender: TObject);
    procedure ParentCBExit(Sender: TObject);
  public
    constructor Create;
    destructor Destroy; override;
    function ElemType: TRDElemType;
    function Add2PN: boolean;
    function Indent: integer;
    function FindingType: string;
    function Historical: boolean;
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
    function GetTemplateFieldValues(const Text: string; FldValues: TORStringList =  nil): string;
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
    property VitalDateTime: TFMDateTime read FVitalDateTime write FVitalDateTime;
  end;

  TRemDataType = (dtDiagnosis, dtProcedure, dtPatientEducation,
                  dtExam, dtHealthFactor, dtImmunization, dtSkinTest,
                  dtVitals, dtOrder, dtMentalHealthTest, dtWHPapResult,
                  dtWhNotPurp);

  TRemPCERoot = class;

  TRemData = class(TObject)
  private
    FPCERoot: TRemPCERoot;
    FParent: TRemDlgElement;
    FRec3: string;
    FActiveDates: TStringList; //Active dates for finding items. (rectype 3)
//    FRoot: string;
    FChoices: TORStringList;
    FChoicesActiveDates: TList; //Active date ranges for taxonomies. (rectype 5)
                                //List of TStringList objects that contain active date
                                //ranges for each FChoices object of the same index
    FChoicePrompt: TRemPrompt;  //rectype 4
    FChoicesMin: integer;
    FChoicesMax: integer;
    FChoicesFont: THandle;
    FSyncCount: integer;
  protected
    function AddData(List: TStrings; Finishing: boolean): integer;
  public
    destructor Destroy; override;
    function Add2PN: boolean;
    function DisplayWHResults: boolean;
    function InternalValue: string;
    function ExternalValue: string;
    function Narrative: string;
    function Category: string;
    function DataType: TRemDataType;
    property Parent: TRemDlgElement read FParent;
  end;

  TRemPromptType = (ptComment, ptVisitLocation, ptVisitDate, ptQuantity,
                    ptPrimaryDiag, ptAdd2PL, ptExamResults, ptSkinResults,
                    ptSkinReading, ptLevelSeverity, ptSeries, ptReaction,
                    ptContraindicated, ptLevelUnderstanding, ptWHPapResult,
                    ptWHNotPurp);

  TRemPrompt = class(TObject)
  private
    FFromControl: boolean;
    FParent: TRemDlgElement;
    FRec4: string;
    FCaptionAssigned: boolean;
    FData: TRemData;
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
  protected
    function RemDataActive(RData: TRemData; EncDt: TFMDateTime):Boolean;
    function CompareActiveDate(ActiveDates: TStringList; EncDt: TFMDateTime):Boolean;
    function RemDataChoiceActive(RData: TRemData; j: integer; EncDt: TFMDateTime):Boolean;
    function GetValue: string;
    procedure SetValueFromParent(Value: string);
    procedure SetValue(Value: string);
    procedure PromptChange(Sender: TObject);
    procedure VitalVerify(Sender: TObject);
    procedure ComboBoxKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    function CanShare(Prompt: TRemPrompt): boolean;
    procedure InitValue;
    procedure DoMHTest(Sender: TObject);
    procedure DoWHReport(Sender: TObject);
    procedure ViewWHText(Sender: TObject);
    procedure GAFHelp(Sender: TObject);
    function EntryID: string;
    procedure EditKeyPress(Sender: TObject; var Key: Char);
  public
    constructor Create;
    destructor Destroy; override;
    function PromptOK: boolean;
    function PromptType: TRemPromptType;
    function Add2PN: boolean;
    function InternalValue: string;
    function Forced: boolean;
    function Caption: string;
    function ForcedCaption: string;
    function SameLine: boolean;
    function Required: boolean;
    function NoteText: string;
    function VitalType: TVitalType;
    function VitalValue: string;
    function VitalUnitValue: string;
    property Value: string read GetValue write SetValue;
  end;

  TRemPCERoot = class(TObject)
  private
    FData: TList;
    FID: string;
    FForcedPrompts: TStringList;
    FValue: string;
    FValueSet: string;
  protected
    class function GetRoot(Data: TRemData; Rec3: string; Historical: boolean): TRemPCERoot;
    procedure Done(Data: TRemData);
    procedure Sync(Prompt: TRemPrompt);
    procedure UnSync(Prompt: TRemPrompt);
    function GetValue(PromptType: TRemPromptType; var NewValue: string): boolean;
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
    NewNoteRE: TRichEdit;
    NoteList: TORListBox;
  end;

var
  RemForm: TRemForm;
  NotPurposeValue: string;
  WHRemPrint: string;
  InitialRemindersLoaded: boolean = FALSE;

const
  HAVE_REMINDERS = 0;
  NO_REMINDERS = 1;
  RemPriorityText: array[1..3] of string = ('High','','Low');
  ClinMaintText = 'Clinical Maintenance';

  dtUnknown = TRemDataType(-1);
  dtAll = TRemDataType(-2);
  dtHistorical = TRemDataType(-3);

  ptUnknown = TRemPromptType(-1);
  ptSubComment = TRemPromptType(-2);
  ptDataList = TRemPromptType(-3);
  ptVitalEntry = TRemPromptType(-4);
  ptMHTest = TRemPromptType(-5);
  ptGAF = TRemPromptType(-6);
  ptMST = TRemPromptType(-7);

  MSTCode = 'MST';
  MSTDataTypes = [pdcHF, pdcExam];
  pnumMST = ord(pnumComment)+4;

procedure NotifyWhenRemindersChange(Proc: TNotifyEvent);
procedure RemoveNotifyRemindersChange(Proc: TNotifyEvent);
procedure StartupReminders;
function GetReminderStatus: TReminderStatus;
function RemindersEvaluatingInBackground: boolean;
procedure ResetReminderLoad;
procedure LoadReminderData(ProcessingInBackground: boolean = FALSE);
function ReminderEvaluated(Data: string; ForceUpdate: boolean = FALSE): boolean;
procedure RemindersEvaluated(List: TStringList);
procedure EvalReminder(ien: integer);
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
                                                   AutoIndent: integer = 4; MHTest: boolean = false);
function InteractiveRemindersActive: boolean;
function GetReminderData(Rem: TReminderDialog; Lst: TStrings; Finishing: boolean = FALSE;
                                         Historical: boolean = FALSE): integer; overload;
function GetReminderData(Lst: TStrings; Finishing: boolean = FALSE;
                                         Historical: boolean = FALSE): integer; overload;
procedure SetReminderFormBounds(Frm: TForm; DefX, DefY, DefW, DefH, ALeft, ATop, AWidth, AHeight: integer);

procedure UpdateReminderDialogStatus;

//const
//  InteractiveRemindersActive = FALSE;

var
{ ActiveReminder string format:
  IEN^PRINT NAME^DUE DATE/TIME^LAST OCCURENCE DATE/TIME^PRIORITY^DUE^DIALOG
  where PRIORITY 1=High, 2=Normal, 3=Low
        DUE      0=Applicable, 1=Due, 2=Not Applicable  }
  ActiveReminders: TORStringList = nil;

{ OtherReminder string format:
  IDENTIFIER^TYPE^NAME^PARENT IDENTIFIER^REMINDER IEN^DIALOG
  where TYPE C=Category, R=Reminder }
  OtherReminders: TORStringList = nil;

  RemindersInProcess: TORStringList = nil;
  CoverSheetRemindersInBackground: boolean = FALSE;
  KillReminderDialogProc: procedure(frm: TForm) = nil;
  RemindersStarted: boolean = FALSE;
  ProcessedReminders: TORStringList = nil;
  ReminderDialogInfo: TStringList = nil;

const
  CatCode = 'C';
  RemCode = 'R';
  EduCode = 'E';
  pnumVisitLoc  = pnumComment + 1;
  pnumVisitDate = pnumComment + 2;
  RemTreeDateIdx = 8;
  IncludeParentID = ';';
  OtherCatID = CatCode + '-6';

  RemDataCodes: array[TRemDataType] of string =
                  { dtDiagnosis        } ('POV',
                  { dtProcedure        }  'CPT',
                  { dtPatientEducation }  'PED',
                  { dtExam             }  'XAM',
                  { dtHealthFactor     }  'HF',
                  { dtImmunization     }  'IMM',
                  { dtSkinTest         }  'SK',
                  { dtVitals           }  'VIT',
                  { dtOrder            }  'Q',
                  { dtMentalHealthTest }  'MH',
                  { dtWHPapResult      }  'WHR',
                  { dtWHNotPurp        }  'WH');

implementation

uses
  rCore, uCore, rReminders, fRptBox, uConst, fReminderDialog, fNotes, rMisc,
  fMHTest, rPCE, rTemplates, dShared, uTemplateFields, fIconLegend, fReminderTree, uInit,
  VAUtils, VA508AccessibilityRouter, VA508AccessibilityManager, uDlgComponents,
  fBase508Form, System.Types, System.UITypes;

type
  TRemFolder = (rfUnknown, rfDue, rfApplicable, rfNotApplicable, rfEvaluated, rfOther);
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
    //FPrintDevice: String;
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

//  OtherCatID = CatCode + '-6';
  OtherCatString = OtherCatID + U + OtherText;

  LostCatID = CatCode + '-7';
  LostCatString = LostCatID + U + 'In Process';

  ReminderDateFormat = 'mm/dd/yyyy';

  RemData2PCECat: array[TRemDataType] of TPCEDataCat =
                  { dtDiagnosis        } (pdcDiag,
                  { dtProcedure        }  pdcProc,
                  { dtPatientEducation }  pdcPED,
                  { dtExam             }  pdcExam,
                  { dtHealthFactor     }  pdcHF,
                  { dtImmunization     }  pdcImm,
                  { dtSkinTest         }  pdcSkin,
                  { dtVitals           }  pdcVital,
                  { dtOrder            }  pdcOrder,
                  { dtMentalHealthTest }  pdcMH,
                  { dtWHPapResult      }  pdcWHR,
                  { dtWHNotPurp        }  pdcWH);

  RemPromptCodes: array[TRemPromptType] of string =
                  { ptComment             } ('COM',
                  { ptVisitLocation       }  'VST_LOC',
                  { ptVisitDate           }  'VST_DATE',
                  { ptQuantity            }  'CPT_QTY',
                  { ptPrimaryDiag         }  'POV_PRIM',
                  { ptAdd2PL              }  'POV_ADD',
                  { ptExamResults         }  'XAM_RES',
                  { ptSkinResults         }  'SK_RES',
                  { ptSkinReading         }  'SK_READ',
                  { ptLevelSeverity       }  'HF_LVL',
                  { ptSeries              }  'IMM_SER',
                  { ptReaction            }  'IMM_RCTN',
                  { ptContraindicated     }  'IMM_CNTR',
                  { ptLevelUnderstanding  }  'PED_LVL',
                  { ptWHPapResult         }  'WH_PAP_RESULT',
                  { ptWHNotPurp           }  'WH_NOT_PURP');

  RemPromptTypes: array[TRemPromptType] of TRemDataType =
                  { ptComment             } (dtAll,
                  { ptVisitLocation       }  dtHistorical,
                  { ptVisitDate           }  dtHistorical,
                  { ptQuantity            }  dtProcedure,
                  { ptPrimaryDiag         }  dtDiagnosis,
                  { ptAdd2PL              }  dtDiagnosis,
                  { ptExamResults         }  dtExam,
                  { ptSkinResults         }  dtSkinTest,
                  { ptSkinReading         }  dtSkinTest,
                  { ptLevelSeverity       }  dtHealthFactor,
                  { ptSeries              }  dtImmunization,
                  { ptReaction            }  dtImmunization,
                  { ptContraindicated     }  dtImmunization,
                  { ptLevelUnderstanding  }  dtPatientEducation,
                  { ptWHPapResult         }  dtWHPapResult,
                  { ptWHNotPurp           }  dtWHNotPurp);

  FinishPromptPieceNum: array[TRemPromptType] of integer =
                  { ptComment             } (pnumComment,
                  { ptVisitLocation       }  pnumVisitLoc,
                  { ptVisitDate           }  pnumVisitDate,
                  { ptQuantity            }  pnumProcQty,
                  { ptPrimaryDiag         }  pnumDiagPrimary,
                  { ptAdd2PL              }  pnumDiagAdd2PL,
                  { ptExamResults         }  pnumExamResults,
                  { ptSkinResults         }  pnumSkinResults,
                  { ptSkinReading         }  pnumSkinReading,
                  { ptLevelSeverity       }  pnumHFLevel,
                  { ptSeries              }  pnumImmSeries,
                  { ptReaction            }  pnumImmReaction,
                  { ptContraindicated     }  pnumImmContra,
                  { ptLevelUnderstanding  }  pnumPEDLevel,
                  { ptWHPapResult         }  pnumWHPapResult,
                  { ptWHNotPurp           }  pnumWHNotPurp);

  ComboPromptTags: array[TRemPromptType] of integer =
                  { ptComment             } (0,
                  { ptVisitLocation       }  TAG_HISTLOC,
                  { ptVisitDate           }  0,
                  { ptQuantity            }  0,
                  { ptPrimaryDiag         }  0,
                  { ptAdd2PL              }  0,
                  { ptExamResults         }  TAG_XAMRESULTS,
                  { ptSkinResults         }  TAG_SKRESULTS,
                  { ptSkinReading         }  0,
                  { ptLevelSeverity       }  TAG_HFLEVEL,
                  { ptSeries              }  TAG_IMMSERIES,
                  { ptReaction            }  TAG_IMMREACTION,
                  { ptContraindicated     }  0,
                  { ptLevelUnderstanding  }  TAG_PEDLEVEL,
                  { ptWHPapResult         }  0,
                  { ptWHNotPurp           }  0);

  PromptDescriptions: array [TRemPromptType] of string =
                  { ptComment             } ('Comment',
                  { ptVisitLocation       }  'Visit Location',
                  { ptVisitDate           }  'Visit Date',
                  { ptQuantity            }  'Quantity',
                  { ptPrimaryDiag         }  'Primary Diagnosis',
                  { ptAdd2PL              }  'Add to Problem List',
                  { ptExamResults         }  'Exam Results',
                  { ptSkinResults         }  'Skin Test Results',
                  { ptSkinReading         }  'Skin Test Reading',
                  { ptLevelSeverity       }  'Level of Severity',
                  { ptSeries              }  'Series',
                  { ptReaction            }  'Reaction',
                  { ptContraindicated     }  'Repeat Contraindicated',
                  { ptLevelUnderstanding  }  'Level of Understanding',
                  { ptWHPapResult         }  'Women''s Health Procedure',
                  { ptWHNotPurp           }  'Women Health Notification Purpose');

  RemFolderCodes: array[TValidRemFolders] of char =
     { rfDue           } ('D',
     { rfApplicable    }  'A',
     { rfNotApplicable }  'N',
     { rfEvaluated     }  'E',
     { rfOther         }  'O');

  MSTDescTxt: array[0..4,0..1] of string = (('Yes','Y'),('No','N'),('Declined','D'),
                                            ('Normal','N'),('Abnormal','A'));

  SyncPrompts = [ptComment, ptQuantity, ptAdd2PL, ptExamResults,
                 ptSkinResults, ptSkinReading, ptLevelSeverity, ptSeries,
                 ptReaction, ptContraindicated, ptLevelUnderstanding];

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
  r3Cat  = 9;
  r3Nar = 8;
  r3GAF = 12;

  RemTreeCode = 999;

  CRCode = '<br>';
  CRCodeLen = length(CRCode);
  REMEntryCode = 'REM';

  MonthReqCode = 'M';

function InitText(const InStr: string): string;
var
  i: integer;

begin
  Result := InStr;
  if(copy(Result, 1, CRCodeLen) = CRCode) then
  begin
    i := pos(CRCode, copy(Result, CRCodeLen+1, MaxInt));
    if(i > 0) and ((i = (CRCodeLen + 1)) or
      (Trim(copy(Result, CrCodeLen+1, i - 1)) = '')) then
      delete(Result,1,CRCodeLen + i - 1);
  end;
end;

function CRLFText(const InStr: string): string;
var
  i: integer;

begin
  Result := InitText(InStr);
  repeat
    i := pos(CRCode, Result);
    if(i > 0) then
      Result := copy(Result,1,i-1) + CRLF + copy(REsult,i + CRCodeLen, MaxInt);
  until(i = 0);
end;

function Code2VitalType(Code: string): TVitalType;
var
  v: TVitalType;

begin
  Result := vtUnknown;
  for v := low(TValidVitalTypes) to high(TValidVitalTypes) do
  begin
    if(Code = VitalPCECodes[v]) then
    begin
      Result := v;
      break;
    end;
  end;
end;

type
  TMultiClassObj = record
    case integer of
      0: (edt:  TCPRSDialogFieldEdit);
      1: (cb:   TCPRSDialogCheckBox);
      2: (cbo:  TCPRSDialogComboBox);
      3: (dt:   TCPRSDialogDateCombo);
      4: (ctrl: TORExposedControl);
      5: (vedt: TVitalEdit);
      6: (vcbo: TVitalComboBox);
      7: (btn:  TCPRSDialogButton);
      8: (pNow: TORCheckBox);
      9: (pBat: TORCheckBox);
     10: (lbl: TLabel);
     11: (WHChk: TWHCheckBox);
  end;

  EForcedPromptConflict = class(EAbort);

function IsSyncPrompt(pt: TRemPromptType): boolean;
begin
  if(pt in SyncPrompts) then
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
  if(RemindersInProcess.Count > 0) then
  begin
    TmpSL := TStringList.Create;
    try
      FastAssign(RemindersInProcess, TmpSL);
      TmpSL.Sort;
      for i := 0 to TmpSL.Count-1 do
      begin
        if(TReminder(TmpSL.Objects[i]).Processing) then
          Result := Result + TmpSL[i] + U;
      end;
    finally
      TmpSL.Free;
    end;
  end;
end;

procedure StartupReminders;
begin
  if(not InitialRemindersLoaded) then
  begin
    RemindersStarted := TRUE;
    InitialRemindersLoaded := TRUE;
    LoadReminderData;
  end;
end;

function GetReminderStatus: TReminderStatus;
begin
       if(EvaluatedReminders.IndexOfPiece('1',U,6) >= 0) then Result := rsDue
  else if(EvaluatedReminders.IndexOfPiece('0',U,6) >= 0) then Result := rsApplicable
  else if(EvaluatedReminders.IndexOfPiece('2',U,6) >= 0) then Result := rsNotApplicable
  else                                                        Result := rsUnknown;
//  else if(EvaluatedReminders.Count > 0) or (OtherReminders.Count > 0) or
//         (not InitialRemindersLoaded) or
//         (ProcessingChangeString <> U) then Result := rsUnknown
//  else Result := rsNone;
end;

function RemindersEvaluatingInBackground: boolean;
begin
  Result := CoverSheetRemindersInBackground;
  if(not Result) then
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
  if(not DoNotify) then
    DoNotify := (not ActiveReminders.Equals(TmpActive));
  KillObj(@TmpActive);
  if(not DoNotify) then
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
      if(pos(RemFolderCodes[i], tmp) > 0) then
        include(uRemFolders, i);
  end;
  Result := uRemFolders;
end;

procedure SetRemFolders(const Value: TRemFolders);
var
  i: TRemFolder;
  tmp: string;

begin
  if(Value <> uRemFolders) then
  begin
    BeginReminderUpdate;
    try
      uRemFolders := Value;
      tmp := '';
      for i := low(TValidRemFolders) to high(TValidRemFolders) do
        if(i in Value) then
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
  if(Data <> '') then
  begin
    Code := Piece(Data, U, 1);
    if StrToIntDef(Code,0) > 0 then
    begin
      ActiveReminders.Notifier.BeginUpdate;
      try
        idx := EvaluatedReminders.IndexOfPiece(Code);
        if(idx < 0) then
        begin
          EvaluatedReminders.Add(Data);
          Result := TRUE;
        end
        else
        begin
          Before := Piece(EvaluatedReminders[idx], U, 6);
          EvaluatedReminders[idx] := Data;
          if(not Result) then
            Result := (Before <> Piece(Data, U, 6));
        end;
        idx := ActiveReminders.IndexOfPiece(Code);
        if(idx < 0) then
        begin
          Sts := Piece(Data, U, 6);
          //if(Sts = '0') or (Sts = '1') then
          if(Sts = '0') or (Sts = '1') or (Sts = '3') or (Sts = '4') then     //AGP Error change 26.8
          begin
            Result := TRUE;
            ActiveReminders.Add(Data);
          end;
        end
        else
        begin
          if(not Result) then
            Result := (ActiveReminders[idx] <> Data);
          ActiveReminders[idx] := Data;
        end;
        idx := ProcessedReminders.IndexOfPiece(Code);
        if(idx >= 0) then
          ProcessedReminders.Delete(idx);
      finally
        ActiveReminders.Notifier.EndUpdate(Result);
      end;
    end
    else
      Result := TRUE; // If Code = 0 then it's 0^No Reminders Due, indicating a status change.
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
    for i := 0 to List.Count-1 do
    begin
      RemChanged := ReminderEvaluated(List[i]);
      if(RemChanged) then DoUpdate := TRUE;
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

begin
  for i := ReminderCallList.Count-1 downto 0 do
    if(EvaluatedReminders.IndexOfPiece(Piece(ReminderCallList[i],U,1)) >= 0) then
      ReminderCallList.Delete(i);
  if(ReminderCallList.Count > 0) then
  begin
    RemList := TStringList.Create;
    try
      while (ReminderCallList.Count > 0) do
      begin
        Code := Piece(ReminderCallList[0],U,1);
        ReminderCallList.Delete(0);
        repeat
          i := ReminderCallList.IndexOfPiece(Code);
          if(i >= 0) then
            ReminderCallList.Delete(i);
        until(i < 0);
        RemList.Add(Code);
      end;
      if(RemList.Count > 0) then
      begin
        EvaluateReminders(RemList);
        FastAssign(RPCBrokerV.Results, RemList);
        for i := 0 to RemList.Count-1 do
          ReminderEvaluated(RemList[i], (i = (RemList.Count-1)));
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

begin
  if(RemindersStarted and (LastReminderLocation <> Encounter.Location)) then
  begin
    LastReminderLocation := Encounter.Location;
    BeginReminderUpdate;
    try
      GetCurrentReminders;
      TempList := TORStringList.Create;
      try
        if(RPCBrokerV.Results.Count > 0) then
        begin
          for i := 0 to RPCBrokerV.Results.Count-1 do
          begin
            RemID := RPCBrokerV.Results[i];
            idx := EvaluatedReminders.IndexOfPiece(RemID);
            if(idx < 0) then
            begin
              TempList.Add(RemID);
              if(not ProcessingInBackground) then
                ReminderCallList.Add(RemID);
            end
            else
              TempList.Add(EvaluatedReminders[idx]);
          end;
        end;
        // FastAssign(TempList,ActiveReminders);
        for i := 0 to TempList.Count-1 do
        begin
          RemID := Piece(TempList[i],U,1);
          if(ActiveReminders.indexOfPiece(RemID) < 0) then
            ActiveReminders.Add(TempList[i]);
        end;
      finally
        TempList.Free;
      end;
      CheckReminders;
      GetOtherReminders(OtherReminders);
    finally
      EndReminderUpdate;
    end;
  end;
end;

{ Supporting events for Reminder TreeViews }

procedure GetImageIndex(AData: Pointer; Sender: TObject; Node: TTreeNode);
var
  iidx, oidx: integer;
  Data, Tmp: string;

begin
  if(Assigned(Node)) then
  begin
    oidx := -1;
    Data := (Node as TORTreeNode).StringData;
    if(copy(Piece(Data, U, 1),1,1) = CatCode) then
    begin
      if(Node.Expanded) then
        iidx := 1
      else
        iidx := 0;
    end
    else
    begin
      Tmp := Piece(Data, U, 6);
      //if(Tmp = '1') then iidx := 2
      if (Tmp = '3') or (Tmp = '4') or (Tmp = '1') then iidx :=2     //AGP ERROR CHANGE 26.8
      else if(Tmp = '0') then iidx := 3
      else
      begin
        if(EvaluatedReminders.IndexOfPiece(copy(Piece(Data, U, 1),2,MaxInt),U,1) < 0) then
          iidx := 5
        else
          iidx := 4;
      end;

      if(Piece(Data,U,7) = '1') then
      begin
        Tmp := copy(Piece(Data, U, 1),2,99);
        if(ProcessedReminders.IndexOfPiece(Tmp,U,1) >=0) then
          oidx := 1
        else
          oidx:= 0;
      end;
    end;
    Node.ImageIndex := iidx;
    Node.SelectedIndex := iidx;
    if(Node.OverlayIndex <> oidx) then
    begin
      Node.OverlayIndex := oidx;
      Node.TreeView.Invalidate;
    end;
  end;
end;

type
  TRemMenuCmd = (rmClinMaint, rmEdu, rmInq, rmWeb, rmDash, rmEval,
                 rmDue, rmApplicable, rmNotApplicable, rmEvaluated, rmOther,
                 rmLegend);
  TRemViewCmds = rmDue..rmOther;

const
  RemMenuFolder: array[TRemViewCmds] of TRemFolder =
                           { rmDue           } (rfDue,
                           { rmApplicable    }  rfApplicable,
                           { rmNotApplicable }  rfNotApplicable,
                           { rmEvaluated     }  rfEvaluated,
                           { rmOther         }  rfOther);

  RemMenuNames: array[TRemMenuCmd] of string = (
                           { rmClinMaint     }  ClinMaintText,
                           { rmEdu           }  'Education Topic Definition',
                           { rmInq           }  'Reminder Inquiry',
                           { rmWeb           }  'Reference Information',
                           { rmDash          }  '-',
                           { rmEval          }  'Evaluate Reminder',
                           { rmDue           }  DueText,
                           { rmApplicable    }  ApplicableText,
                           { rmNotApplicable }  NotApplicableText,
                           { rmEvaluated     }  EvaluatedText,
                           { rmOther         }  OtherText,
                           { rmLegend        }  'Reminder Icon Legend');


  EvalCatName = 'Evaluate Category Reminders';

function GetEducationTopics(EIEN: string): string;
var
  i, idx: integer;
  Tmp, Data: string;

begin
  if(not assigned(EducationTopics)) then
    EducationTopics := TORStringList.Create;
  idx := EducationTopics.IndexOfPiece(EIEN);
  if(idx < 0) then
  begin
    Tmp := copy(EIEN,1,1);
    idx := StrToIntDef(copy(EIEN,2,MaxInt),0);
    if(Tmp = RemCode) then
      GetEducationTopicsForReminder(idx)
    else
    if(Tmp = EduCode) then
      GetEducationSubtopics(idx)
    else
      RPCBrokerV.Results.Clear;
    Tmp := EIEN;
    if(RPCBrokerV.Results.Count > 0) then
    begin
      for i := 0 to RPCBrokerV.Results.Count-1 do
      begin
        Data := RPCBrokerV.Results[i];
        Tmp := Tmp + U + Piece(Data, U, 1) + ';';
        if(Piece(Data, U, 3) = '') then
          Tmp := Tmp + Piece(Data, U, 2)
        else
          Tmp := Tmp + Piece(Data, U, 3);
      end;
    end;
    idx := EducationTopics.Add(Tmp);
  end;
  Result := EducationTopics[idx];
  idx := pos(U, Result);
  if(idx > 0) then
    Result := copy(Result,Idx+1,MaxInt)
  else
    Result := '';
end;

function GetWebPageName(idx :integer): string;
begin
  Result := Piece(WebPages[idx],U,2);
end;

function GetWebPageAddress(idx: integer): string;
begin
  Result := Piece(WebPages[idx],U,3);
end;

function GetWebPages(EIEN: string): string; overload;
var
  i, idx: integer;
  Tmp, Data, Title: string;
  RIEN: string;

begin
  RIEN := RemCode + EIEN;
  if(not assigned(WebPages)) then
    WebPages := TORStringList.Create;
  idx := WebPages.IndexOfPiece(RIEN);
  if(idx < 0) then
  begin
    GetReminderWebPages(EIEN);
    Tmp := RIEN;
    if(RPCBrokerV.Results.Count > 0) then
    begin
      for i := 0 to RPCBrokerV.Results.Count-1 do
      begin
        Data := RPCBrokerV.Results[i];
        if(Piece(Data,U,1) = '1') and (Piece(Data,U,3) <> '') then
        begin
          Data := U + Piece(Data,U,4) + U + Piece(Data,U,3);
          if(Piece(Data,U,2) = '') then
          begin
            Title := Piece(data,U,3);
            if(length(Title) > 60) then
              Title := copy(Title,1,57) + '...';
            SetPiece(Data,U,2,Title);
          end;
          //if(copy(UpperCase(Piece(Data, U, 3)),1,7) <> 'HTTP://') then
          //  SetPiece(Data, U, 3,'http://'+Piece(Data,U,3));
          idx := WebPages.IndexOf(Data);
          if(idx < 0) then
            idx := WebPages.Add(Data);
          Tmp := Tmp + U + IntToStr(idx);
        end;
      end;
    end;
    idx := WebPages.Add(Tmp);
  end;
  Result := WebPages[idx];
  idx := pos(U, Result);
  if(idx > 0) then
    Result := copy(Result,Idx+1,MaxInt)
  else
    Result := '';
end;

function ReminderName(IEN: integer): string;
var
  idx: integer;
  SIEN: string;

begin
  SIEN := IntToStr(IEN);
  Result := '';
  idx := EvaluatedReminders.IndexOfPiece(SIEN);
  if(idx >= 0) then
    Result := piece(EvaluatedReminders[idx],U,2);
  if(Result = '') then
  begin
    idx := ActiveReminders.IndexOfPiece(SIEN);
    if(idx >= 0) then
      Result := piece(ActiveReminders[idx],U,2);
  end;
  if(Result = '') then
  begin
    idx := OtherReminders.IndexOfPiece(SIEN, U, 5);
    if(idx >= 0) then
      Result := piece(OtherReminders[idx],U,3);
  end;
  if(Result = '') then
  begin
    idx := RemindersInProcess.IndexOfPiece(SIEN);
    if(idx >= 0) then
      Result := TReminder(RemindersInProcess.Objects[idx]).PrintName;
  end;
end;

procedure ReminderClinMaintClicked(AData: pointer; Sender: TObject);
var
  ien: integer;

begin
  ien := (Sender as TMenuItem).Tag;
  if(ien > 0) then
    ReportBox(DetailReminder(ien), RemMenuNames[rmClinMaint] + ': '+ ReminderName(ien), TRUE);
end;

procedure ReminderEduClicked(AData: pointer; Sender: TObject);
var
  ien: integer;

begin
  ien := (Sender as TMenuItem).Tag;
  if(ien > 0) then
    ReportBox(EducationTopicDetail(ien), 'Education Topic: ' + (Sender as TMenuItem).Caption, TRUE);
end;

procedure ReminderInqClicked(AData: pointer; Sender: TObject);
var
  ien: integer;

begin
  ien := (Sender as TMenuItem).Tag;
  if(ien > 0) then
    ReportBox(ReminderInquiry(ien), 'Reminder Inquiry: '+ ReminderName(ien), TRUE);
end;

procedure ReminderWebClicked(AData: pointer; Sender: TObject);
var
  idx: integer;

begin
  idx := (Sender as TMenuItem).Tag-1;
  if(idx >= 0) then
    GotoWebPage(GetWebPageAddress(idx));
end;

procedure EvalReminder(ien: integer);
var
  Msg, RName: string;
  NewStatus: string;

begin
  if(ien > 0) then
  begin
    NewStatus := EvaluateReminder(IntToStr(ien));
    ReminderEvaluated(NewStatus);
    NewStatus := piece(NewStatus,U,6);
    RName := ReminderName(ien);
    if(RName = '') then RName := 'Reminder';
         if(NewStatus = '1') then Msg := 'Due'
    else if(NewStatus = '0') then Msg := 'Applicable'
    else if(NewStatus = '3') then Msg := 'Error'    //AGP Error code change 26.8
    else if (NewStatus = '4') then Msg := 'CNBD'    //AGP Error code change 26.8
    else                          Msg := 'Not Applicable';
    Msg := RName + ' is ' + Msg + '.';
    InfoBox(Msg, RName + ' Evaluation', MB_OK);
  end;
end;

procedure EvalProcessed;
var
  i: integer;

begin
  if(ProcessedReminders.Count > 0) then
  begin
    BeginReminderUpdate;
    try
      while(ProcessedReminders.Count > 0) do
      begin
        if(ReminderCallList.IndexOf(ProcessedReminders[0]) < 0) then
          ReminderCallList.Add(ProcessedReminders[0]);
        repeat
          i := EvaluatedReminders.IndexOfPiece(Piece(ProcessedReminders[0],U,1));
          if(i >= 0) then
            EvaluatedReminders.Delete(i);
        until(i < 0);
        ProcessedReminders.Delete(0);
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
  if(Sender is TMenuItem) then
  begin
    BeginReminderUpdate;
    try
      Node := TORTreeNode(TORTreeNode(TMenuItem(Sender).Tag).GetFirstChild);
      while assigned(Node) do
      begin
        Code := Piece(Node.StringData,U,1);
        if(copy(Code,1,1) = RemCode) then
        begin
          Code := copy(Code,2,MaxInt);
          if(ReminderCallList.IndexOf(Code) < 0) then
            ReminderCallList.Add(copy(Node.StringData,2,MaxInt));
          repeat
            i := EvaluatedReminders.IndexOfPiece(Code);
            if(i >= 0) then
              EvaluatedReminders.Delete(i);
          until(i < 0);
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
  Tmp: string;
  Cnt: integer;
  RemID: integer;
  cmd: TRemMenuCmd;

  function Add(Text: string; Parent: TMenuItem; Tag: integer; Typ: TRemMenuCmd): TORMenuItem;
  var
    InsertMenu: boolean;
    idx: integer;

  begin
    Result := nil;
    InsertMenu := TRUE;
    if(Parent = MI) then
    begin
      if(MI.Count > Cnt) then
      begin
        Result := TORMenuItem(MI.Items[Cnt]);
        Result.Enabled := TRUE;
        Result.Visible := TRUE;
        Result.ImageIndex := -1;
        while Result.Count > 0 do
          Result.Delete(Result.Count-1);
        InsertMenu := FALSE;
      end;
      inc(Cnt);
    end;
    if(not assigned(Result)) then
      Result := TORMenuItem.Create(MI);
    if(Text = '') then
      Result.Caption := RemMenuNames[Typ]
    else
      Result.Caption := Text;
    Result.Tag := Tag;
    Result.Data := RemStr;
    if(Tag <> 0) then
    begin
      case Typ of
        rmClinMaint:  M.Code := @ReminderClinMaintClicked;
        rmEdu:        M.Code := @ReminderEduClicked;
        rmInq:        M.Code := @ReminderInqClicked;
        rmWeb:        M.Code := @ReminderWebClicked;
        rmEval:       M.Code := @ReminderEvalClicked;
        rmDue..rmOther:
          begin
            M.Code := @ReminderViewFolderClicked;
            case Typ of
              rmDue:           idx := 0;
              rmApplicable:    idx := 2;
              rmNotApplicable: idx := 4;
              rmEvaluated:     idx := 6;
              rmOther:         idx := 8;
              else             idx := -1;
            end;
            if(idx >= 0) and (RemMenuFolder[Typ] in GetRemFolders) then
              inc(idx);
            Result.ImageIndex := idx;
          end;
        rmLegend:     M.Code := @ReminderIconLegendClicked;
        else
          M.Code := nil;
      end;
      if(assigned(M.Code)) then
        Result.OnClick := TNotifyEvent(M)
      else
        Result.OnClick := nil;
    end;
    if(InsertMenu) then
      Parent.Add(Result);
  end;

  procedure AddEducationTopics(Item: TMenuItem; EduStr: string);
  var
    i, j: integer;
    Code: String;
    NewEduStr: string;
    itm: TMenuItem;

  begin
    if(EduStr <> '') then
    begin
      repeat
        i := pos(';', EduStr);
        j := pos(U, EduStr);
        if(j = 0) then j := length(EduStr)+1;
        Code := copy(EduStr,1,i-1);
        //AddEducationTopics(Add(copy(EduStr,i+1,j-i-1), Item, StrToIntDef(Code, 0), rmEdu),
        //                   GetEducationTopics(EduCode + Code));

        NewEduStr := GetEducationTopics(EduCode + Code);
        if(NewEduStr = '') then
          Add(copy(EduStr,i+1,j-i-1), Item, StrToIntDef(Code, 0), rmEdu)
        else
        begin
          itm := Add(copy(EduStr,i+1,j-i-1), Item, 0, rmEdu);
          Add(copy(EduStr,i+1,j-i-1), itm, StrToIntDef(Code, 0), rmEdu);
          Add('', Itm, 0, rmDash);
          AddEducationTopics(itm, NewEduStr);
        end;

        delete(EduStr,1,j);
      until(EduStr = '');
    end;
  end;

  procedure AddWebPages(Item: TMenuItem; WebStr: string);
  var
    i, idx: integer;

  begin
    if(WebStr <> '') then
    begin
      repeat
        i := pos(U, WebStr);
        if(i = 0) then i := length(WebStr)+1;
        idx := StrToIntDef(copy(WebStr,1,i-1),-1);
        if(idx >= 0) then
          Add(GetWebPageName(idx), Item, idx+1, rmWeb);
        delete(WebStr,1,i);
      until(WebStr = '');
    end;
  end;


begin
  RemID := StrToIntDef(copy(Piece(RemStr,U,1),2,MaxInt),0);
  Cnt := 0;
  M.Data := nil;

  if(RemID > 0) then
  begin
    Add('', MI, RemID, rmClinMaint);
    Tmp := GetEducationTopics(RemCode + IntToStr(RemID));
    if(Tmp <> '') then
      AddEducationTopics(Add('', MI, 0, rmEdu), Tmp)
    else
      Add('', MI, 0, rmEdu).Enabled := FALSE;
    Add('', MI, RemID, rmInq);
    Tmp := GetWebPages(IntToStr(RemID));
    if(Tmp <> '') then
      AddWebPages(Add('', MI, 0, rmWeb), Tmp)
    else
      Add('', MI, 0, rmWeb).Enabled := FALSE;

    if(IncludeActions or IncludeEval) then
    begin
      Add('', MI, 0, rmDash);
      Add('', MI, RemID, rmEval);
    end;
  end;

  if(ViewFolders) then
  begin
    Add('', MI, 0, rmDash);
    for cmd := low(TRemViewCmds) to high(TRemViewCmds) do
      Add('', MI, ord(RemMenuFolder[cmd]), cmd);
  end;

  Add('', MI, 0, rmDash);
  Add('', MI, 1, rmLegend);

  while MI.Count > Cnt do
    MI.Delete(MI.Count-1);
end;

procedure ReminderTreePopup(AData: pointer; Sender: TObject);
begin
  ReminderMenuBuilder((Sender as TPopupMenu).Items, (Sender as TORPopupMenu).Data, TRUE, FALSE, FALSE);
end;

procedure ReminderTreePopupCover(AData: pointer; Sender: TObject);
begin
  ReminderMenuBuilder((Sender as TPopupMenu).Items, (Sender as TORPopupMenu).Data, FALSE, FALSE, FALSE);
end;

procedure ReminderTreePopupDlg(AData: pointer; Sender: TObject);
begin
  ReminderMenuBuilder((Sender as TPopupMenu).Items, (Sender as TORPopupMenu).Data, FALSE, TRUE, FALSE);
end;

procedure ReminderMenuItemSelect(AData: pointer; Sender: TObject);
begin
  ReminderMenuBuilder((Sender as TMenuItem), (Sender as TORMenuItem).Data, FALSE, FALSE, TRUE);
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
  if(Sender.Tag = RemTreeCode) then
  begin
    if(not assigned(ReminderTreeMenuDlg)) then
    begin
      ReminderTreeMenuDlg := TORPopupMenu.Create(nil);
      SetReminderPopupDlgRoutine(ReminderTreeMenuDlg)
    end;
    Result := ReminderTreeMenuDlg;
  end
  else
  begin
    if(not assigned(ReminderTreeMenu)) then
    begin
      ReminderTreeMenu := TORPopupMenu.Create(nil);
      SetReminderPopupRoutine(ReminderTreeMenu);
    end;
    Result := ReminderTreeMenu;
  end;
end;

procedure RemContextPopup(AData: Pointer; Sender: TObject; MousePos: TPoint;
                          var Handled: Boolean);
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
    if((htOnItem in GetHitTestInfoAt(MousePos.X, MousePos.Y)) and (assigned(Selected))) then
    begin
      p1 := Piece((Selected as TORTreeNode).StringData, U, 1);
      if(Copy(p1,1,1) = RemCode) then
      begin
        Menu := ReminderMenu(TComponent(Sender));
        Menu.Data := TORTreeNode(Selected).StringData;
      end
      else
      if(Copy(p1,1,1) = CatCode) and (p1 <> OtherCatID) and (Selected.HasChildren) then
      begin
        if(not assigned(ReminderCatMenu)) then
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
        MItem.Tag := Integer(TORTreeNode(Selected));
        UpdateMenu := FALSE;
      end;
    end;
    if UpdateMenu then
      PopupMenu := Menu;
    Selected := Selected; // This strange line Keeps item selected after a right click
    if(not assigned(PopupMenu)) then
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
  Tmp, Data, LostCat, Code: string;
  Node: TORTreeNode;
  M: TMethod;
  Rem: TReminder;
  OpenDue, Found: boolean;

  function Add2Tree(Folder: TRemFolder; CatID: string; Node: TORTreeNode = nil): TORTreeNode;
  begin
    if (Folder = rfUnknown) or (Folder in GetRemFolders) then
    begin
      if(CatID = LostCatID) then
      begin
        if(NeedLost) then
        begin
          (Tree.Items.AddFirst(nil,'') as TORTreeNode).StringData := LostCatString;
          NeedLost := FALSE;
        end;
      end;

      if(not assigned(Node)) then
        Node := Tree.FindPieceNode(CatID, 1);
      if(assigned(Node)) then
      begin
        Result := (Tree.Items.AddChild(Node,'') as TORTreeNode);
        Result.StringData := Data;
      end
      else
        Result := nil;
    end
    else
      Result := nil;
  end;

begin
  if(not assigned(Tree)) then exit;
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

    if(assigned(Tree.TopItem)) then
    begin
      TopID1 := Tree.GetNodeID(TORTreeNode(Tree.TopItem), 1, IncludeParentID);
      TopID2 := Tree.GetNodeID(TORTreeNode(Tree.TopItem), 1);
    end
    else
      TopID1 := U;

    if(assigned(Tree.Selected)) then
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

    if(rfDue in GetRemFolders) then
      (Tree.Items.Add(nil,'') as TORTreeNode).StringData := DueCatString;
    if(rfApplicable in GetRemFolders) then
      (Tree.Items.Add(nil,'') as TORTreeNode).StringData := ApplCatString;
    if(rfNotApplicable in GetRemFolders) then
      (Tree.Items.Add(nil,'') as TORTreeNode).StringData := NotApplCatString;
    if(rfEvaluated in GetRemFolders) then
      (Tree.Items.Add(nil,'') as TORTreeNode).StringData := EvaluatedCatString;
    if(rfOther in GetRemFolders) then
      (Tree.Items.Add(nil,'') as TORTreeNode).StringData := OtherCatString;

    for i := 0 to EvaluatedReminders.Count-1 do
    begin
      Data := RemCode + EvaluatedReminders[i];
      Tmp := Piece(Data,U,6);
      //     if(Tmp = '1') then Add2Tree(rfDue, DueCatID)
      if(Tmp = '1') or (Tmp = '3') or (Tmp = '4') then Add2Tree(rfDue, DueCatID) //AGP Error code change 26.8
      else if(Tmp = '0') then Add2Tree(rfApplicable, ApplCatID)
      else                    Add2Tree(rfNotApplicable, NotApplCatID);
      Add2Tree(rfEvaluated, EvaluatedCatID);
    end;

    if(rfOther in GetRemFolders) and (OtherReminders.Count > 0) then
    begin
      for i := 0 to OtherReminders.Count-1 do
      begin
        Tmp := OtherReminders[i];
        if(Piece(Tmp, U, 2) = CatCode) then
          Data := CatCode + Piece(Tmp, U, 1)
        else
        begin
          Code := Piece(Tmp, U, 5);
          Data := RemCode + Code;
          Node := Tree.FindPieceNode(Data, 1);
          if(assigned(Node)) then
            Data := Node.StringData
          else
          begin
            j := EvaluatedReminders.IndexOfPiece(Code);
            if(j >= 0) then
              SetPiece(Data, U, 6, Piece(EvaluatedReminders[j], U, 6));
          end;
        end;
        SetPiece(Data, U, 2, Piece(Tmp, U ,3));
        SetPiece(Data, U, 7, Piece(Tmp, U, 6));
        Tmp := CatCode + Piece(Tmp, U, 4);
        Add2Tree(rfOther, OtherCatID, Tree.FindPieceNode(Tmp, 1));
      end;
    end;

  { The Lost category is for reminders being processed that are no longer in the
    reminder tree view.  This can happen with reminders that were Due or Applicable,
    but due to user action are no longer applicable, or due to location changes.
    The Lost category will not be used if a lost reminder is in the other list. }

    if(RemindersInProcess.Count > 0) then
    begin
      for i := 0 to RemindersInProcess.Count-1 do
      begin
        Rem := TReminder(RemindersInProcess.Objects[i]);
        Tmp := RemCode + Rem.IEN;
        Found := FALSE;
        Node := nil;
        repeat
          Node := Tree.FindPieceNode(Tmp, 1, #0, Node); // look in the tree first
          if((not Found) and (not assigned(Node))) then
          begin
            Data := Tmp + U + Rem.PrintName + U + Rem.DueDateStr + U + Rem.LastDateStr + U +
                    IntToStr(Rem.Priority) + U + Rem.Status;
                 if(Rem.Status = '1') then LostCat := DueCatID
            else if(Rem.Status = '0') then LostCat := ApplCatID
            else                           LostCat := LostCatID;
            Node := Add2Tree(rfUnknown, LostCat);
          end;
          if(assigned(Node)) then
          begin
            Node.Bold := Rem.Processing;
            Found := TRUE;
          end;
        until(Found and (not assigned(Node)));
      end;
    end;

    for i := 0 to Tree.Items.Count-1 do
    begin
      Node := TORTreeNode(Tree.Items[i]);
      for j := 3 to 4 do
      begin
        Tmp := Piece(Node.StringData, U, j);
        if(Tmp = '') then
          Data := ''
        else
          Data := FormatFMDateTimeStr(ReminderDateFormat, Tmp);
        Node.SetPiece(j + (RemTreeDateIdx - 3), Data);
      end;
      Node.SetPiece(RemTreeDateIdx + 2, IntToStr(Node.AbsoluteIndex));
      Tmp := Piece(Node.StringData, U, 5);
      if(Tmp <> '1') and (Tmp <> '3') then
        Node.SetPiece(5, '2');
    end;

  finally
    Tree.Items.EndUpdate;
  end;

  if(SelID1 = U) then
    Node := nil
  else
  begin
    Node := Tree.FindPieceNode(SelID1, 1, IncludeParentID);
    if(not assigned(Node)) then
      Node := Tree.FindPieceNode(SelID2, 1);
    if(assigned(Node)) then
      Node.EnsureVisible;
  end;
  Tree.Selected := Node;

  Tree.SetExpandedIDStr(1, IncludeParentID, ExpandedStr);
  if(OpenDue) then
  begin
    Node := Tree.FindPieceNode(DueCatID, 1);
    if(assigned(Node)) then
      Node.Expand(FALSE);
  end;

  if(TopID1 = U) then
    Tree.TopItem := Tree.Items.GetFirstNode
  else
  begin
    Tree.TopItem := Tree.FindPieceNode(TopID1, 1, IncludeParentID);
    if(not assigned(Tree.TopItem)) then
      Tree.TopItem := Tree.FindPieceNode(TopID2, 1);
  end;
end;

function ReminderNode(Node: TTreeNode): TORTreeNode;
var
  p1: string;

begin
  Result := nil;
  if(assigned(Node)) then
  begin
    p1 := Piece((Node as TORTreeNode).StringData, U, 1);
    if(Copy(p1,1,1) = RemCode) then
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
  if(assigned(frmReminderTree)) then
    frmReminderTree.Free;
  Changed := ((ActiveReminders.Count > 0) or (OtherReminders.Count > 0) or
              (ProcessingChangeString <> U));
  ActiveReminders.Notifier.BeginUpdate;
  OtherReminders.Notifier.BeginUpdate;
  RemindersInProcess.Notifier.BeginUpdate;
  try
    ProcessedReminders.Clear;
    if(assigned(KillReminderDialogProc)) then
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

procedure RemindersInProcessChanged(Data: Pointer; Sender: TObject; var CanNotify: boolean);
var
  CurProcessing: string;
begin
  CurProcessing := ProcessingChangeString;
  CanNotify := (LastProcessingList <> CurProcessing);
  if(CanNotify) then
    LastProcessingList := CurProcessing;
end;

procedure InitReminderObjects;
var
  M: TMethod;

  procedure InitReminderList(var List: TORStringList);
  begin
    if(not assigned(List)) then
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
  RemindersInProcess.Notifier.OnNotify :=  TCanNotifyEvent(M);

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
end;

function GetReminder(ARemData: string): TReminder;
var
  idx: integer;
  SIEN: string;

begin
  Result := nil;
  SIEN := Piece(ARemData, U, 1);
  if(Copy(SIEN,1,1) = RemCode) then
  begin
    SIEN := copy(Sien, 2, MaxInt);
    idx := RemindersInProcess.IndexOf(SIEN);
    if(idx < 0) then
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
                                                   AutoIndent: integer = 4; MHTest: boolean = false);
var
  i, j, l, max, FCount, MHLoop: integer;
  First, MHRes: boolean;
  OrgText, Text, Prefix, tmpText: string;

begin
  StripScreenReaderCodes(AText);
  inc(LineLength, ScootOver);
  dec(AutoIndent, ScootOver);
  FCount := Output.Count;
  First := TRUE;
  MHLoop := 1;
  MHRes := False;
  tmpText := '';
  if (MHTest = True) and (Pos('~', AText)>0) then MHLoop := 2;
  for j := 1 to MHLoop do
  begin
  if (j = 1) and (MHLoop = 2) then
    begin
      tmpText := Piece(AText, '~', 1);
      MHRes := True;
    end
  else if (j = 2) then
    begin
      tmpText := Piece(AText, '~', 2);
      First := False;
      MHRes := False;
    end
  else if (j = 1) and (MHLoop = 1) then
    begin
      tmpText := AText;
      First := False;
      MHRes := False;
    end;
  if tmpText <> '' then OrgText := tmpText
  else OrgText := InitText(AText);
  Prefix := StringOfChar(' ',74-LineLength);
  repeat
    i := pos(CRCode, OrgText);
    if(i = 0) then
    begin
      Text := OrgText;
      OrgText := '';
    end
    else
    begin
      Text := copy(OrgText, 1, i - 1);
      delete(OrgText, 1, i + CRCodeLen - 1);
    end;
    if(Text = '') and (OrgText <> '') then
    begin
      Output.Add('');
      inc(FCount);
    end;
    while(Text <> '') do
    begin
      max := length(Text);
      if(max > LineLength) then
      begin
        l := LineLength + 1;
        while(l > 0) and (Text[l] <> ' ') do dec(l);
        if(l < 1) then
        begin
          Output.Add(Prefix+copy(Text,1,LineLength));
          delete(Text,1,LineLength);
        end
        else
        begin
          Output.Add(Prefix+copy(Text,1,l-1));
          while(l <= max) and (Text[l] = ' ') do inc(l);
          delete(Text,1,l-1);
        end;
        if(First) then
        begin
          dec(LineLength, AutoIndent);
          Prefix := Prefix + StringOfChar(' ', AutoIndent);
          First := FALSE;
        end;
      end
      else
      begin
        Output.Add(Prefix+Text);
        Text := '';
      end;
    end;
    if ((First) and (FCount <> Output.Count)) and (MHRes = False) then
    begin
      dec(LineLength, AutoIndent);
      Prefix := Prefix + StringOfChar(' ', AutoIndent);
      First := FALSE;
    end;
  until(OrgText = '');
  end;
end;

function InteractiveRemindersActive: boolean;
begin
  if(not InteractiveRemindersActiveChecked) then
  begin
    InteractiveRemindersActiveStatus := GetRemindersActive;
    InteractiveRemindersActiveChecked := TRUE;
  end;
  Result := InteractiveRemindersActiveStatus;
end;

function GetReminderData(Rem: TReminderDialog; Lst: TStrings; Finishing: boolean = FALSE;
                                                        Historical: boolean = FALSE): integer;
begin
  Result := Rem.AddData(Lst, Finishing, Historical);
end;

function GetReminderData(Lst: TStrings; Finishing: boolean = FALSE;
                                         Historical: boolean = FALSE): integer;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to RemindersInProcess.Count-1 do
    inc(Result, TReminder(RemindersInProcess.Objects[i]).AddData(Lst, Finishing, Historical));
end;

procedure SetReminderFormBounds(Frm: TForm; DefX, DefY, DefW, DefH, ALeft, ATop, AWidth, AHeight: integer);
var
  Rect: TRect;
  ScreenW, ScreenH: integer;

begin
  SystemParametersInfo(SPI_GETWORKAREA, 0, @Rect, 0);
  ScreenW := Rect.Right - Rect.Left + 1;
  ScreenH := Rect.Bottom - Rect.Top + 1;
  if(AWidth = 0) then
    AWidth := DefW
  else
    DefW := AWidth;
  if(AHeight = 0) then
    AHeight := DefH
  else
    DefH := AHeight;
  if(DefX = 0) and (DefY = 0) then
  begin
    DefX := (ScreenW - DefW) div 2;
    DefY := (ScreenH - DefH) div 2;
  end
  else
    dec(DefY, DefH);
  if((ALeft <= 0) or (ATop <= 0) or
    ((ALeft + AWidth) > ScreenW) or
    ((ATop + AHeight) > ScreenH)) then
  begin
    if(DefX < 0) then
      DefX := 0
    else
    if((DefX + DefW) > ScreenW) then
      DefX := ScreenW-DefW;
    if(DefY < 0) then
      DefY := 0
    else
    if((DefY + DefH) > ScreenH) then
      DefY := ScreenH-DefH;
    Frm.SetBounds(Rect.Left + DefX, Rect.Top + DefY, DefW, DefH);
  end
  else
    Frm.SetBounds(Rect.Left + ALeft, Rect.Top + ATop, AWidth, AHeight);
end;

procedure UpdateReminderDialogStatus;
var
  TmpSL: TStringList;
  Changed: boolean;

  procedure Build(AList :TORStringList; PNum: integer);
  var
    i: integer;
    Code: string;

  begin
    for i := 0 to AList.Count-1 do
    begin
      Code := Piece(AList[i],U,PNum);
      if((Code <> '') and (TmpSL.IndexOf(Code) < 0)) then
        TmpSL.Add(Code);
    end;
  end;

  procedure Reset(AList: TORStringList; PNum, DlgPNum: integer);
  var
    i, j: integer;
    Tmp, Code, Dlg: string;

  begin
    for i := 0 to TmpSL.Count-1 do
    begin
      Code := Piece(TmpSL[i],U,1);
      j := -1;
      repeat
        j := AList.IndexOfPiece(Code, U, PNum, j);
        if(j >= 0) then
        begin
          Dlg := Piece(TmpSL[i],U,2);
          if(Dlg <> Piece(AList[j], U, DlgPNum)) then
          begin
            Tmp := AList[j];
            SetPiece(Tmp, U, DlgPNum, Dlg);
            AList[j] := Tmp;
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
  if(txt <> '') then
  begin
    tlen := length(txt);
    if(copy(txt, tlen - CRCodeLen + 1, CRCodeLen) = CRCode) then
      exit;
    if(copy(txt, tlen, 1) = '.') then
      txt := txt + ' ';
    txt := txt + ' ';
  end;
end;

procedure ExpandTIUObjects(var Txt: string; msg: string = '');
var
  ObjList: TStringList;
  Err: TStringList;
  i, j, k, oLen: integer;
  obj, ObjTxt: string;

begin
  ObjList := TStringList.Create;
  try
    Err := nil;
    if(not dmodShared.BoilerplateOK(Txt, CRCode, ObjList, Err)) and (assigned(Err)) then
    begin
      try
        Err.Add(CRLF + 'Contact IRM and inform them about this error.' + CRLF +
                       'Make sure you give them the name of the reminder that you are processing,' + CRLF +
                       'and which dialog elements were selected to produce this error.');
        InfoBox(Err.Text,'Reminder Boilerplate Object Error', MB_OK + MB_ICONERROR);
      finally
        Err.Free;
      end;
    end;
    if(ObjList.Count > 0) then
    begin
      GetTemplateText(ObjList);
      i := 0;
      while (i < ObjList.Count) do
      begin
        if(pos(ObjMarker, ObjList[i]) = 1) then
        begin
          obj := copy(ObjList[i], ObjMarkerLen+1, MaxInt);
          if(obj = '') then break;
          j := i + 1;
          while (j < ObjList.Count) and (pos(ObjMarker, ObjList[j]) = 0) do
            inc(j);
          if((j - i) > 2) then
          begin
            ObjTxt := '';
            for k := i+1 to j-1 do
              ObjTxt := ObjTxt + CRCode + ObjList[k];
          end
          else
            ObjTxt := ObjList[i+1];
          i := j;
          obj := '|' + obj + '|';
          oLen := length(obj);
          repeat
            j := pos(obj, Txt);
            if(j > 0) then
            begin
              delete(Txt, j, OLen);
              insert(ObjTxt, Txt, j);
            end;
          until(j = 0);
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
//  Line: string;
  Element: TRemDlgElement;

begin
  TempSL := GetDlgSL;
  if Piece(TempSL[0],U,2)='1' then
    begin
      Self.RemWipe := 1;
    end;
  idx := -1;
  repeat
    idx := TempSL.IndexOfPiece('1', U, 1, idx);
    if(idx >= 0) then
    begin
      if(not assigned(FElements)) then
        FElements := TStringList.Create;
      eidx := FElements.AddObject('',TRemDlgElement.Create);
      Element := TRemDlgElement(FElements.Objects[eidx]);
      with Element do
      begin
        FReminder := Self;
        FRec1 := TempSL[idx];
        FID := Piece(FRec1, U, 2);
        FDlgID := Piece(FRec1, U, 3);
        FElements[eidx] := FDlgID;
        if(ElemType = etTaxonomy) then
          FTaxID := BOOLCHAR[Historical] + FindingType
        else
          FTaxID := '';

        FText := '';
        i := -1;
       // if Piece(FRec1,U,5) <> '1' then
        repeat
          i := TempSL.IndexOfPieces(['2',FID,FDlgID],i);
          if(i >= 0) then
          begin
            PrepText4NextLine(FText);
            FText := FText + Trim(Piece(TempSL[i], U, 4));
          end;
        until(i < 0);
        ExpandTIUObjects(FText);
        AssignFieldIDs(FText);

        if(pos('.',FDlgID)>0) then
        begin
          ParentID := FDlgID;
          i := length(ParentID);
          while((i > 0) and (ParentID[i] <> '.')) do
            dec(i);
          if(i > 0) then
          begin
            ParentID := copy(ParentID,1,i-1);
            i := FElements.IndexOf(ParentID);
            if(i >= 0) then
            begin
              FParent := TRemDlgElement(FElements.Objects[i]);
              if(not assigned(FParent.FChildren)) then
                FParent.FChildren := TList.Create;
              FParent.FChildren.Add(Element);
            end;
          end;
        end;
        if(ElemType = etDisplayOnly) then
          SetChecked(TRUE);
        UpdateData;
      end;
    end;
  until(idx < 0);
end;

constructor TReminderDialog.Create(ADlgData: string);
begin
  FDlgData := ADlgData;
  BaseCreate;
end;

destructor TReminderDialog.Destroy;
begin
  KillObj(@FElements, TRUE);
  inherited;
end;

function TReminderDialog.Processing: boolean;
var
  i,j: integer;
  Elem: TRemDlgElement;
  RData: TRemData;

  function ChildrenChecked(Prnt: TRemDlgElement): boolean; forward;

  function CheckItem(Item: TRemDlgElement): boolean;
  begin
    if(Item.ElemType = etDisplayOnly) then
    begin
      Result := ChildrenChecked(Item);
      if(not Result) then
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
    if(assigned(Prnt.FChildren)) then
    begin
      for i := 0 to Prnt.FChildren.Count-1 do
      begin
        Result := CheckItem(TRemDlgElement(Prnt.FChildren[i]));
        if(Result) then break;
      end;
    end;
  end;

begin
  Result := FALSE;
  if(assigned(FElements)) then
  begin
    for i := 0 to FElements.Count-1 do
    begin
      Elem := TRemDlgElement(FElements.Objects[i]);
      if(not assigned(Elem.FParent)) then
      begin
        Result := CheckItem(Elem);
        if (Result = false) then  //(AGP CHANGE 24.9 add check to have the finish problem check for MH test)
          begin
          if (assigned(Elem.FData)) then
            begin
               for j := 0 to Elem.FData.Count-1 do
                  begin
                     RData := TRemData(Elem.FData[j]);
                     if piece(RData.FRec3,U,4)='MH' then
                        Result := True;
                     if (Result) then break;
                  end;
            end;
          end;
        if(Result) then break;
      end;
    end;
  end;
end;

function TReminderDialog.GetDlgSL: TORStringList;
var
  idx: integer;

begin
  if(not assigned(ReminderDialogInfo)) then
    ReminderDialogInfo := TStringList.Create;
  idx := ReminderDialogInfo.IndexOf(GetIEN);
  if(idx < 0) then
    idx := ReminderDialogInfo.AddObject(GetIEN, TORStringList.Create);
  Result := TORStringList(ReminderDialogInfo.Objects[idx]);
  if(Result.Count = 0) then
  begin
    FastAssign(GetDialogInfo(GetIEN, (Self is TReminder)), Result);
    Result.Add(DlgCalled); // Used to prevent repeated calling of RPC if dialog is empty
  end;
end;

function TReminderDialog.BuildControls(ParentWidth: integer; AParent, AOwner: TWinControl): TWinControl;
var
  Y, i: integer;
  Elem: TRemDlgElement;
  ERes: TWinControl;

begin
  Result := nil;
  if(assigned(FElements)) then
  begin
    Y := 0;
    for i := 0 to FElements.Count-1 do
    begin
      Elem := TRemDlgElement(FElements.Objects[i]);
      if (not assigned(Elem.FParent)) then
      begin
        ERes := Elem.BuildControls(Y, ParentWidth, AParent, AOwner);
        if(not assigned(Result)) then
          Result := ERes;
      end;
    end;
  end;
  if(AParent.ControlCount = 0) then
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

procedure TReminderDialog.AddText(Lst: TStrings);
var
  i, idx: integer;
  Elem: TRemDlgElement;
  temp: string;

begin
  if(assigned(FElements)) then
  begin
    idx := Lst.Count;
    for i := 0 to FElements.Count-1 do
    begin
      Elem := TRemDlgElement(FElements.Objects[i]);
      if (not assigned(Elem.FParent)) then
        Elem.AddText(Lst);
    end;
    if (Self is TReminder) and (PrintName <> '') and (idx <> Lst.Count) then
    begin
      temp := PrintName;
      StripScreenReaderCodes(temp);
      Lst.Insert(idx, '  ' + temp + ':')
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
  if(assigned(FElements)) then
  begin
    for i := 0 to FElements.Count-1 do
    begin
      Elem := TRemDlgElement(FElements.Objects[i]);
      if (not assigned(Elem.FParent)) then
        inc(Result, Elem.AddData(Lst, Finishing, Historical));
    end;
  end;
end;

procedure TReminderDialog.ComboBoxCheckedText(Sender: TObject; NumChecked: integer; var Text: string);
var
  i, Done: integer;
  DotLen, ComLen, TxtW, TotalW, NewLen: integer;
  tmp: string;
  Fnt: THandle;
  lb: TORListBox;

begin
  if(NumChecked = 0) then
    Text := '(None Selected)'
  else
  if(NumChecked > 1) then
  begin
    Text := '';
    lb := (Sender as TORListBox);
    Fnt := lb.Font.Handle;
    DotLen := TextWidthByFont(Fnt, '...');
    TotalW := (lb.Owner as TControl).ClientWidth - 15;
    ComLen := TextWidthByFont(fnt, ', ');
    dec(TotalW,(NumChecked-1) * ComLen);
    Done := 0;
    for i := 0 to lb.Items.Count-1 do
    begin
      if(lb.Checked[i]) then
      begin
        inc(Done);
        if(Text <> '') then
        begin
          Text := Text + ', ';
          dec(TotalW, ComLen);
        end;
        Tmp := lb.DisplayText[i];
        if(Done = NumChecked) then
          TxtW := TotalW
        else
          TxtW := TotalW div (NumChecked - Done + 1);
        NewLen := NumCharsFitInWidth(fnt, Tmp, TxtW);
        if(NewLen < length(Tmp)) then
          Tmp := copy(Tmp,1,NumCharsFitInWidth(fnt, Tmp, (TxtW - DotLen))) + '...';
        dec(TotalW, TextWidthByFont(fnt, Tmp));
        Text := Text + Tmp;
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
  if(FTextChangedCount > 0) then
  begin
    dec(FTextChangedCount);
    if(FTextChangedCount = 0) and assigned(FOnTextChanged) then
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
  if(FNeedRedrawCount > 0) then
  begin
    dec(FNeedRedrawCount);
    if(FNeedRedrawCount = 0) and (assigned(FOnNeedRedraw)) then
      FOnNeedRedraw(Sender);
  end;
end;

procedure TReminderDialog.FinishProblems(List: TStrings; var MissingTemplateFields: boolean);
var
  i: integer;
  Elem: TRemDlgElement;
  TmpSL: TStringList;
  FldData: TORStringList;

begin
  if(Processing and assigned(FElements)) then
  begin
    TmpSL := TStringList.Create;
    try
      FldData := TORStringList.Create;
      try
        for i := 0 to FElements.Count-1 do
        begin
          Elem := TRemDlgElement(FElements.Objects[i]);
          if (not assigned(Elem.FParent)) then
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
  if(Sender is TORComboBox) then
    with (Sender as TORComboBox) do
      OnCheckedText := OnCheckedText;
end;

function TReminderDialog.Visible: boolean;
begin
  Result := (CurrentReminderInDialog = Self);
end;

{ TReminder }

constructor TReminder.Create(ARemData: string);
begin
  FRemData := ARemData;
  BaseCreate;
end;

function TReminder.GetDueDateStr: string;
begin
  Result := Piece(FRemData, U ,3);
end;

function TReminder.GetIEN: string;
begin
  Result := copy(Piece(FRemData, U, 1), 2, MaxInt);
end;

function TReminder.GetLastDateStr: string;
begin
  Result := Piece(FRemData, U ,4);
end;

function TReminder.GetPrintName: string;
begin
  Result := Piece(FRemData, U ,2);
end;

function TReminder.GetPriority: integer;
begin
  Result := StrToIntDef(Piece(FRemData, U ,5), 2);
end;

function TReminder.GetStatus: string;
begin
  Result := Piece(FRemData, U ,6);
end;

{ TRemDlgElement }

function Code2DataType(Code: string): TRemDataType;
var
  idx: TRemDataType;

begin
  Result := dtUnknown;
  for idx := low(TRemDataType) to high(TRemDataType) do
  begin
    if(Code = RemDataCodes[idx]) then
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
  if(Code = '') then
    Result := ptSubComment
  else
  if(Code = MSTCode) then
    Result := ptMST
  else
  begin
    Result := ptUnknown;
    for idx := low(TRemPromptType) to high(TRemPromptType) do
    begin
      if(Code = RemPromptCodes[idx]) then
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
    //Suppress := (Piece(FRec1,U,1)='1');
    if(Result and (ElemType = etDisplayOnly)) then
    begin
      //Result := FALSE;
      if(assigned(FPrompts) and (FPrompts.Count > 0)) or
        (assigned(FData) and (FData.Count > 0)) or Result then
      begin
        Lst := TStringList.Create;
        try
          AddData(Lst, FALSE);
          Result := (Lst.Count > 0);
          if not assigned(FData) then Result := True;
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
  if(Box) then
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
  Tmp: string;
begin
  Tmp := Piece(FRec1, U, 18);
  if Tmp = '1' then Result := crOne
  else if Tmp = '2' then Result := crAtLeastOne
  else if Tmp = '3' then Result := crNoneOrOne
  else if Tmp = '4' then result := crAll
  else Result := crNone;
end;

function TRemDlgElement.ChildrenSharePrompts: boolean;
begin
  Result := (Piece(FRec1, U, 17) = '1');
end;

destructor TRemDlgElement.Destroy;
begin
  KillObj(@FFieldValues);
  KillObj(@FData, TRUE);
  KillObj(@FPrompts, TRUE);
  KillObj(@FChildren);
  inherited;
end;

function TRemDlgElement.ElemType: TRDElemType;
var
  Tmp: string;

begin
      Tmp := Piece(FRec1, U, 4);
      if(Tmp = 'D') then Result := etDisplayOnly
      else if(Tmp = 'T') then Result := etTaxonomy
      else Result := etCheckBox;
end;

function TRemDlgElement.FindingType: string;
begin
  if(ElemType = etTaxonomy) then
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
  Tmp: string;

begin
  if FHaveData then exit;
  if(FReminder.GetDlgSL.IndexOfPieces([RPCCalled, FID, FTaxID]) < 0) then
  begin
    TempSL := GetDialogPrompts(FID, Historical, FindingType);
    TempSL.Add(RPCCalled);
    for i := 0 to TempSL.Count-1 do
    begin
      Tmp := TempSL[i];
      SetPiece(Tmp,U,2,FID);
      SetPiece(Tmp,U,3,FTaxID);
      TempSL[i] := Tmp;
    end;
    FastAddStrings(TempSL, FReminder.GetDlgSL);
  end;
  UpdateData;
end;

procedure TRemDlgElement.UpdateData;
var
  Ary: array of integer;
  idx, i,cnt: integer;
  TempSL: TORStringList;
  RData: TRemData;
  RPrompt: TRemPrompt;
  Tmp, Tmp2, choiceTmp: string;
  NewLine: boolean;
  dt: TRemDataType;
  pt: TRemPromptType;
  DateRange: string;
  ChoicesActiveDates:   TStringList;
  ChoiceIdx: integer;
  Piece7: string;
  encDt: TFMDateTime;

begin
  if FHaveData then exit;
  TempSL := FReminder.GetDlgSL;
  if(TempSL.IndexOfPieces([RPCCalled, FID, FTaxID]) >= 0) then
  begin
    FHaveData := TRUE;
    RData := nil;
    idx := -1;
    repeat
      idx := TempSL.IndexOfPieces(['3', FID, FTaxID], idx);
      if (idx >= 0) and (Pieces(TempSL[idx-1],U,1,6) = Pieces(TempSL[idx],u,1,6)) then
        if pos(':', Piece(TempSL[idx],U,7)) > 0 then  //if has date ranges
          begin
            if RData <> nil then
              begin
                if (not assigned(RData.FActiveDates)) then
                  RData.FActiveDates := TStringList.Create;
                DateRange := Pieces(Piece(TempSL[idx],U,7),':',2,3);
                RData.FActiveDates.Add(DateRange);
                with RData do
                  begin
                    FParent := Self;
                    Piece7 := Piece(Piece(TempSL[idx],U,7),':',1);
                    FRec3 := TempSL[idx];
                    SetPiece(FRec3,U,7,Piece7);
                  end;
              end;
          end;

      if(idx >= 0) and (Pieces(TempSL[idx-1],U,1,6) <> Pieces(TempSL[idx],u,1,6)) then

//      if(idx >= 0) and ((Pieces(TempSL[idx-1],U,1,6) <> Pieces(TempSL[idx],u,1,6)) or
//      ((Pieces(TempSL[idx-1],U,1,6) = Pieces(TempSL[idx],u,1,6)) and
//      ((pos(':',Piece(TempSL[idx],U,7)) > 0) and (pos(':',Piece(TempSL[idx-1],U,7)) > 0))) and
//      (Piece(TempSL[idx],U,7) <> Piece(TempSL[idx-1],U,7))) then

//      if (idx >= 0) then

      begin
        dt := Code2DataType(piece(TempSL[idx], U, r3Type));
        if(dt <> dtUnknown) and ((dt <> dtOrder) or
          CharInSet(CharAt(piece(TempSL[idx], U, 11),1), ['D', 'Q', 'M', 'O', 'A'])) and   //AGP change 26.10 for allergy orders
          ((dt <> dtMentalHealthTest) or MHTestsOK) then
        begin
          if(not assigned(FData)) then
            FData := TList.Create;
          RData := TRemData(FData[FData.Add(TRemData.Create)]);
          if pos(':',Piece(TempSL[idx],U,7)) > 0 then
            begin
              RData.FActiveDates := TStringList.Create;
              RData.FActiveDates.Add(Pieces(Piece(TempSL[idx],U,7),':',2,3));
            end;
          with RData do
          begin
            FParent := Self;
            Piece7 := Piece(Piece(TempSL[idx],U,7),':',1);
            FRec3 := TempSL[idx];
            SetPiece(FRec3,U,7,Piece7);
//            FRoot := FRec3;
            i := idx + 1;
            ChoiceIdx := 0;
            while(i < TempSL.Count) and (TempSL.PiecesEqual(i, ['5', FID, FTaxID])) do
            begin
              if (Pieces(TempSL[i-1],U,1,6) = Pieces(TempSL[i],U,1,6)) then
                begin
                 if pos(':', Piece(TempSL[i],U,7)) > 0 then
                   begin
                    if (not assigned(FChoicesActiveDates)) then
                      begin
                        FChoicesActiveDates := TList.Create;
                        ChoicesActiveDates := TStringList.Create;
                        FChoicesActiveDates.Insert(ChoiceIdx, ChoicesActiveDates);
                      end;
                    TStringList(FChoicesActiveDates[ChoiceIdx]).Add(Pieces(Piece(TempSL[i],U,7),':',2,3));
                   end;
                 inc(i);
                end
              else
                begin
                  if(not assigned(FChoices)) then
                  begin
                    FChoices := TORStringList.Create;
                    if(not assigned(FPrompts)) then
                      FPrompts := TList.Create;
                    FChoicePrompt := TRemPrompt(FPrompts[FPrompts.Add(TRemPrompt.Create)]);
                    with FChoicePrompt do
                    begin
                      FParent := Self;
                      Tmp := Piece(FRec3,U,10);
                      NewLine := (Tmp <> '');
                      FRec4 := '4' + U + FID + U + FTaxID + U + U + BOOLCHAR[not RData.Add2PN] + U + U +
                               'P' + U + Tmp + U + BOOLCHAR[NewLine] + U + '1';
                      FData := RData;
                      FOverrideType := ptDataList;
                      InitValue;
                    end;
                  end;
                  Tmp := TempSL[i];
                  Piece7 := Piece(Piece(TempSL[i],U,7),':',1);
                  SetPiece(Tmp,U,7,Piece7);
                  Tmp2 := Piece(Piece(Tmp,U,r3Code),':',1);
                  if(Tmp2 <> '') then Tmp2 := ' (' + Tmp2 + ')';
                  Tmp2 := MixedCase(Piece(Tmp,U,r3Nar)) + Tmp2;
                  SetPiece(Tmp,U,12,Tmp2);
                  ChoiceIdx := FChoices.Add(Tmp);
                  if pos(':',Piece(TempSL[i],U,7)) > 0 then
                   begin
                    if (not assigned(FChoicesActiveDates)) then
                      FChoicesActiveDates := TList.Create;
                    ChoicesActiveDates := TStringList.Create;
                    ChoicesActiveDates.Add(Pieces(Piece(TempSL[i],U,7),':',2,3));
                    FChoicesActiveDates.Insert(ChoiceIdx, ChoicesActiveDates);
                   end
                  else
                    if assigned(FChoicesActiveDates) then
                       FChoicesActiveDates.Insert(ChoiceIdx, TStringList.Create);
                  inc(i);
                end;
            end;
            choiceTmp := '';
            // agp ICD-10 modify this code to handle one valid code against encounter date if combobox contains more than one code.
            if(assigned(FChoices)) and ((FChoices.Count = 1) or (FChoicesActiveDates.Count = 1)) then // If only one choice just pick it
            begin
              choiceTmp := FChoices[0];
            end;
            if (assigned(FChoices)) and (assigned(FChoicesActiveDates)) and (choiceTmp = '') then
              begin
                if (assigned(FParent.FReminder.FPCEDataObj)) then encDT := FParent.FReminder.FPCEDataObj.DateTime
                else encDT := RemForm.PCEObj.VisitDateTime;
                choiceTmp := oneValidCode(FChoices, FChoicesActiveDates, encDT);
              end;
            //            if(assigned(FChoices)) and (((FChoices.Count = 1) or (FChoicesActiveDates.Count = 1)) or
//            (oneValidCode(FChoices, FChoicesActiveDates, FParent.FReminder.FPCEDataObj.DateTime) = true)) then // If only one choice just pick it
            if (choiceTmp <> '') then

            begin
              if (not assigned(RData.FActiveDates)) then
              begin
                RData.FActiveDates := TStringList.Create;
                setActiveDates(FChoices, FChoicesActiveDates, RData.FActiveDates);
              end;

              FPrompts.Remove(FChoicePrompt);
              KillObj(@FChoicePrompt);
              Tmp := choiceTmp;
              KillObj(@FChoices);
              cnt := 5;
              if(Piece(FRec3,U,9) = '') then inc(cnt);
              SetLength(Ary,cnt);
              for i := 0 to cnt-1 do
                Ary[i] := i+4;
              SetPieces(FRec3, U, Ary, Tmp);
              if (not assigned(RData.FActiveDates)) then
              begin
                RData.FActiveDates := TStringList.Create;
              end;

            end;
            if(assigned(FChoices)) then
            begin
              for i := 0 to FChoices.Count-1 do
                FChoices.Objects[i] := TRemPCERoot.GetRoot(RData, FChoices[i], Historical);
            end
            else
              FPCERoot := TRemPCERoot.GetRoot(RData, RData.FRec3, Historical);
            if(dt = dtVitals) then
            begin
              if(Code2VitalType(Piece(FRec3,U,6)) <> vtUnknown) then
              begin
                if(not assigned(FPrompts)) then
                  FPrompts := TList.Create;
                FChoicePrompt := TRemPrompt(FPrompts[FPrompts.Add(TRemPrompt.Create)]);
                with FChoicePrompt do
                begin
                  FParent := Self;
                  Tmp := Piece(FRec3,U,10);
                  NewLine := FALSE;
  //                FRec4 := '4' + U + FID + U + FTaxID + U + U + BOOLCHAR[not RData.Add2PN] + U +
  //                         RData.InternalValue + U + 'P' + U + Tmp + U + BOOLCHAR[SameL] + U + '1';
                  FRec4 := '4' + U + FID + U + FTaxID + U + U + BOOLCHAR[not RData.Add2PN] + U +
                           U + 'P' + U + Tmp + U + BOOLCHAR[NewLine] + U + '0';
                  FData := RData;
                  FOverrideType := ptVitalEntry;
                  InitValue;
                end;
              end;
            end;
            if(dt = dtMentalHealthTest) then
            begin
              if(not assigned(FPrompts)) then
                FPrompts := TList.Create;
              FChoicePrompt := TRemPrompt(FPrompts[FPrompts.Add(TRemPrompt.Create)]);
              with FChoicePrompt do
              begin
                FParent := Self;
                Tmp := Piece(FRec3,U,10);
                NewLine := FALSE;
//                FRec4 := '4' + U + FID + U + FTaxID + U + U + BOOLCHAR[not RData.Add2PN] + U +
//                         RData.InternalValue + U + 'P' + U + Tmp + U + BOOLCHAR[SameL] + U + '1';
                FRec4 := '4' + U + FID + U + FTaxID + U + U + BOOLCHAR[not RData.Add2PN] + U +
                         U + 'P' + U + Tmp + U + BOOLCHAR[NewLine] + U + '0';
                FData := RData;
                if ((Piece(FRec3, U, r3GAF) = '1')) and (MHDLLFound = false) then
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
    until(idx < 0);

    idx := -1;
    repeat
      idx := TempSL.IndexOfPieces(['4', FID, FTaxID], idx);
      if(idx >= 0) then
      begin
        pt := Code2PromptType(piece(TempSL[idx], U, 4));
        if(pt <> ptUnknown) and ((pt <> ptComment) or (not FHasComment)) then
        begin
          if(not assigned(FPrompts)) then
            FPrompts := TList.Create;
          RPrompt := TRemPrompt(FPrompts[FPrompts.Add(TRemPrompt.Create)]);
          with RPrompt do
          begin
            FParent := Self;
            FRec4 := TempSL[idx];
            InitValue;
          end;
          if(pt = ptComment) then
          begin
            FHasComment := TRUE;
            FCommentPrompt := RPrompt;
          end;
          if(pt = ptSubComment) then
            FHasSubComments := TRUE;
          if(pt = ptMST) then
            FMSTPrompt := RPrompt;
        end;
      end;
    until(idx < 0);

    idx := -1;
    repeat
      idx := TempSL.IndexOfPieces(['6', FID, FTaxID], idx);
      if(idx >= 0) then
      begin
        PrepText4NextLine(FPNText);
        FPNText := FPNText + Trim(Piece(TempSL[idx], U, 4));
      end;
    until(idx < 0);
    ExpandTIUObjects(FPNText);
  end;
end;

procedure TRemDlgElement.SetChecked(const Value: boolean);
var
  i, j, k: integer;
  Kid: TRemDlgElement;
  Prompt: TRemPrompt;
  RData: TRemData;

  procedure UpdateForcedValues(Elem: TRemDlgElement);
  var
    i: integer;

  begin
    if(Elem.IsChecked) then
    begin
      if(assigned(Elem.FPrompts)) then
      begin
        for i := 0 to Elem.FPrompts.Count-1 do
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
      if(Elem.FChecked) and (assigned(Elem.FChildren)) then
        for i := 0 to Elem.FChildren.Count-1 do
          UpdateForcedValues(TRemDlgElement(Elem.FChildren[i]));
    end;
  end;

begin
  if(FChecked <> Value) then
  begin
    FChecked := Value;
    if(Value) then
    begin
      GetData;
      if(FChecked and assigned(FParent)) then
      begin
        FParent.Check4ChildrenSharedPrompts;
        if(FParent.ChildrenRequired in [crOne, crNoneOrOne]) then
        begin
          for i := 0 to FParent.FChildren.Count-1 do
          begin
            Kid := TRemDlgElement(FParent.FChildren[i]);
            if(Kid <> Self) and (Kid.FChecked) then
              Kid.SetChecked(FALSE);
          end;
        end;
      end;
      UpdateForcedValues(Self);
    end
    else
    if(assigned(FPrompts) and assigned(FData)) then
    begin
      for i := 0 to FPrompts.Count-1 do
      begin
        Prompt := TRemPrompt(FPrompts[i]);
        if Prompt.Forced and (IsSyncPrompt(Prompt.PromptType)) then
        begin
          for j := 0 to FData.Count-1 do
          begin
            RData := TRemData(FData[j]);
            if(assigned(RData.FPCERoot)) then
              RData.FPCERoot.UnSync(Prompt);
            if(assigned(RData.FChoices)) then
            begin
              for k := 0 to RData.FChoices.Count-1 do
              begin
                if(assigned(RData.FChoices.Objects[k])) then
                  TRemPCERoot(RData.FChoices.Objects[k]).UnSync(Prompt);
              end;
            end;
          end;
        end;
      end;
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
  while assigned(Prnt) do
  begin
    if(Prnt.Box) then
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
begin
  FReminder.BeginTextChanged;
  try
    FReminder.BeginNeedRedraw;
    try
      if(assigned(Sender)) then
      begin
        SetChecked((Sender as TORCheckBox).Checked);
        ElementChecked := Self;
      end;
    finally
      FReminder.EndNeedRedraw(Sender);
    end;
  finally
    FReminder.EndTextChanged(Sender);
  end;
  RemindersInProcess.Notifier.Notify;
  if assigned(TORCheckBox(Sender).Associate) and (not ScreenReaderSystemActive) then
    TDlgFieldPanel(TORCheckBox(Sender).Associate).SetFocus;
end;

function TRemDlgElement.EnableChildren: boolean;
var
  Chk: boolean;

begin
  if(assigned(FParent)) then
    Chk := FParent.EnableChildren
  else
    Chk := TRUE;
  if(Chk) then
  begin
    if(ElemType = etDisplayOnly) then
      Result := TRUE
    else
      Result := FChecked;
  end
  else
    Result := FALSE;
end;

function TRemDlgElement.Enabled: boolean;
begin
  if(assigned(FParent)) then
    Result := FParent.EnableChildren
  else
    Result := TRUE;
end;

function TRemDlgElement.ShowChildren: boolean;
begin
  if(assigned(FChildren) and (FChildren.Count > 0)) then
  begin
    if((ElemType = etDisplayOnly) or FChecked) then
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
      (Sender as TCPRSDialogParentCheckBox).FocusOnBox := true
    else
      TDlgFieldPanel(TORCheckBox(Sender).Associate).SetFocus;
  end;
end;

procedure TRemDlgElement.ParentCBEnter(Sender: TObject);
begin
  (Sender as TORCheckBox).FocusOnBox := true;
end;

procedure TRemDlgElement.ParentCBExit(Sender: TObject);
begin
  (Sender as TORCheckBox).FocusOnBox := false;
end;

type
  TORExposedWinControl = class(TWinControl);

function TRemDlgElement.BuildControls(var Y: integer; ParentWidth: integer;
                                           BaseParent, AOwner: TWinControl): TWinControl;
var
  lbl: TLabel;
  lblText: string;
  sLbl: TCPRSDialogStaticLabel;
  lblCtrl: TControl;
  pnl: TDlgFieldPanel;
  AutoFocusControl: TWinControl;
  cb: TCPRSDialogParentCheckBox;
  gb: TGroupBox;
  ERes, prnt: TWinControl;
  PrntWidth: integer;
  i, X, Y1: integer;
  LastX, MinX, MaxX: integer;
  Prompt: TRemPrompt;
  Ctrl: TMultiClassObj;
  OK, DoLbl, HasVCombo, cbSingleLine: boolean;
  ud: TUpDown;
  HelpBtn: TButton;
  vCombo: TComboBox;
  pt: TRemPromptType;
  SameLineCtrl: TList;
  Kid: TRemDlgElement;
  vt: TVitalType;
  DefaultDate: TFMDateTime;
  Req: boolean;

  function GetPanel(const EID, AText: string; const PnlWidth: integer;
                    OwningCheckBox: TCPRSDialogParentCheckBox): TDlgFieldPanel;
  var
    idx, p: integer;
    Entry: TTemplateDialogEntry;

  begin
    // This call creates a new TTemplateDialogEntry if necessary and creates the
    // necessary template field controls with their default values stored in the
    // TTemplateField object.
    Entry := GetDialogEntry(BaseParent, EID + IntToStr(Integer(BaseParent)), AText);
    Entry.InternalID := EID;
    // This call looks for the Entry's values in TRemDlgElement.FFieldValues
    idx := FFieldValues.IndexOfPiece(EID);
    // If the Entry's values were found in the previous step then they will be
    // restored to the TTemplateDialogEntry.FieldValues in the next step.
    if(idx >= 0) then
    begin
      p := pos(U, FFieldValues[idx]); // Can't use Piece because 2nd piece may contain ^ characters
      if(p > 0) then
        Entry.FieldValues := copy(FFieldValues[idx],p+1,MaxInt);
    end;
    Entry.AutoDestroyOnPanelFree := TRUE;
    // The FieldPanelChange event handler is where the Entry.FieldValues are saved to the
    // Element.FFieldValues.
    Entry.OnChange := FieldPanelChange;
    //AGP BACKED OUT THE CHANGE CAUSE A PROBLEM WITH TEMPLATE WORD PROCESSING FIELDS WHEN RESIZING
    //FieldPanelChange(Entry); // to accomodate fields with default values - CQ#15960
    //AGP END BACKED OUT
    // Calls TTemplateDialogEntry.SetFieldValues which calls
    // TTemplateDialogEntry.SetControlText to reset the template field default
    // values to the values that were restored to the Entry from the Element if
    // they exist, otherwise the default values will remain.
    Result := Entry.GetPanel(PnlWidth, BaseParent, OwningCheckBox);
  end;

  procedure NextLine(var Y: integer);
  var
    i: integer;
    MaxY: integer;
    C: TControl;


  begin
    MaxY := 0;
    for i := 0 to SameLineCtrl.Count-1 do
    begin
      C := TControl(SameLineCtrl[i]);
      if(MaxY < C.Height) then
        MaxY := C.Height;
    end;
    for i := 0 to SameLineCtrl.Count-1 do
    begin
      C := TControl(SameLineCtrl[i]);
      if(MaxY > C.Height) then
        C.Top := Y + ((MaxY - C.Height) div 2);
    end;
    inc(Y, MaxY);
    if assigned(cb) and assigned(pnl) then
      cb.Top := pnl.Top;
    SameLineCtrl.Clear;
  end;

  procedure ProcessLabel(Required, AEnabled: boolean;
                         AParent: TWinControl; Control: TControl);  begin
    if(Trim(Prompt.Caption) = '') and (not Required) then
      lblCtrl := nil
    else
    begin
      lbl := TLabel.Create(AOwner);
      lbl.Parent := AParent;
      if ScreenReaderSystemActive then
      begin
        sLbl := TCPRSDialogStaticLabel.Create(AOwner);
        sLbl.Parent := AParent;
        sLbl.Height := lbl.Height;
// get groop box hearder, if any
//                (sLbl as ICPRSDialogComponent).BeforeText := ScreenReaderSystem_GetPendingText;
        lbl.Free;
        lblCtrl := sLbl;
      end
      else
        lblCtrl := lbl;
      lblText := Prompt.Caption;
      if Required then
      begin
        if assigned(Control) and Supports(Control, ICPRSDialogComponent) then
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
      lblCtrl.Enabled := AEnabled;
      UpdateColorsFor508Compliance(lblCtrl);
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

  procedure AddPrompts(Shared: boolean; AParent: TWinControl; PWidth: integer; var Y: integer);
  var
    i, j, k, idx: integer;
    DefLoc: TStrings;
    LocText: string;
    LocFound: boolean;
    m, n: integer;
    ActDt, InActDt: Double;
    EncDt: TFMDateTime;
    ActChoicesSL: TORStringList;
    Piece12, WHReportStr: String;
    WrapLeft, LineWidth: integer;

  begin
    SameLineCtrl := TList.Create;
    try
      if(assigned(cb)) then
      begin
        if(not Shared) then
        begin
          SameLineCtrl.Add(cb);
          SameLineCtrl.Add(pnl);
        end;
        if(cbSingleLine and (not Shared)) then
          LastX := cb.Left + pnl.Width + PromptGap + IndentGap
        else
          LastX := PWidth;
      end
      else
      begin
        if(not Shared) then SameLineCtrl.Add(pnl);
        LastX := PWidth;
      end;
      for i := 0 to FPrompts.Count-1 do
      begin
        Prompt := TRemPrompt(FPrompts[i]);
        OK := ((Prompt.FIsShared = Shared) and Prompt.PromptOK and (not Prompt.Forced));
        if(OK and Shared) then
        begin
          OK := FALSE;
          for j := 0 to Prompt.FSharedChildren.Count-1 do
          begin
            Kid := TRemDlgElement(Prompt.FSharedChildren[j]);
//            if(Kid.ElemType <> etDisplayOnly) and (Kid.FChecked) then
            if(Kid.FChecked) then
            begin
              OK := TRUE;
              break;
            end;
          end;
        end;
        Ctrl.Ctrl := nil;
        ud := nil;
        HelpBtn := nil;
        vCombo := nil;
        HasVCombo := FALSE;
        if(OK) then
        begin
          pt := Prompt.PromptType;
          MinX := 0;
          MaxX := 0;
          lbl := nil;
          sLbl := nil;
          lblCtrl := nil;
          DoLbl := Prompt.Required;
          case pt of
            ptComment, ptQuantity:
              begin
                Ctrl.edt := TCPRSDialogFieldEdit.Create(AOwner);
                Ctrl.ctrl.Parent := AParent;
                Ctrl.edt.Text := Prompt.Value;
                if(pt = ptComment) then
                begin
                  Ctrl.edt.MaxLength := 245;
                  MinX := TextWidthByFont(Ctrl.edt.Font.Handle, 'AbCdEfGhIjKlMnOpQrStUvWxYz 1234');
                  MaxX := PWidth;
                end
                else
                begin
                  ud := TUpDown.Create(AOwner);
                  ud.Parent := AParent;
                  ud.Associate := Ctrl.edt;
                  if(pt = ptQuantity) then
                  begin
                    ud.Min := 1;
                    ud.Max := 100;
                  end
                  else
                  begin
                    ud.Min := 0;
                    ud.Max := 40;
                  end;
                  MinX := TextWidthByFont(Ctrl.edt.Font.Handle, IntToStr(ud.Max)) + 24;
                  ud.Position := StrToIntDef(Prompt.Value, ud.Min);
                  UpdateColorsFor508Compliance(ud);
                end;
                Ctrl.edt.OnKeyPress := Prompt.EditKeyPress;
                Ctrl.edt.OnChange := Prompt.PromptChange;
                UpdateColorsFor508Compliance(Ctrl.edt);
                DoLbl := TRUE;
              end;

            ptVisitLocation, ptLevelUnderstanding,
            ptSeries, ptReaction, ptExamResults,
            ptLevelSeverity, ptSkinResults, ptSkinReading:
              begin
                Ctrl.cbo := TCPRSDialogComboBox.Create(AOwner);
                Ctrl.ctrl.Parent := AParent;
                Ctrl.cbo.OnKeyDown := Prompt.ComboBoxKeyDown;
                Ctrl.cbo.Style := orcsDropDown;
                Ctrl.cbo.Pieces := '2';
                if pt = ptSkinReading then
                  begin
                     Ctrl.cbo.Pieces := '1';
                     Ctrl.cbo.Items.Add('');
                     for j := 0 to 50 do Ctrl.cbo.Items.Add(inttostr(j));
                     GetComboBoxMinMax(Ctrl.cbo,MinX, MaxX);
                  end;
                if pt <> ptSkinReading then
                  begin
                     Ctrl.cbo.Tag := ComboPromptTags[pt];
                     PCELoadORCombo(Ctrl.cbo, MinX, MaxX);
                  end;
                if pt = ptVisitLocation then
                begin
                  DefLoc := GetDefLocations;
                  if DefLoc.Count > 0 then
                  begin
                    idx := 1;
                    for j := 0 to DefLoc.Count-1 do
                    begin
                      LocText := piece(DefLoc[j],U,2);
                      if LocText <> '' then
                      begin
                        if (LocText <> '0') and (IntToStr(StrToIntDef(LocText,0)) = LocText) then
                        begin
                          LocFound := FALSE;
                          for k := 0 to Ctrl.cbo.Items.Count-1 do
                          begin
                            if(piece(Ctrl.cbo.Items[k],U,1) = LocText) then
                            begin
                              LocText := Ctrl.cbo.Items[k];
                              LocFound := TRUE;
                              break;
                            end;
                          end;
                          if not LocFound then
                            LocText := '';
                        end
                        else
                          LocText := '0^'+LocText;
                        if LocText <> '' then
                        begin
                          Ctrl.cbo.Items.Insert(idx, LocText);
                          inc(idx);
                        end;
                      end;
                    end;

                    if idx > 1 then
                    begin
                      Ctrl.cbo.Items.Insert(idx, '-1' + LLS_LINE);
                      Ctrl.cbo.Items.Insert(idx+1, '-1' + LLS_SPACE);
                    end;
                  end;
                end;

                MinX := MaxX;
                Ctrl.cbo.SelectByID(Prompt.Value);
                if(Ctrl.cbo.ItemIndex < 0) then
                begin
                  Ctrl.cbo.Text := Prompt.Value;
                  if(pt = ptVisitLocation) then
                    Ctrl.cbo.Items[0] := '0' + U + Prompt.Value;
                end;
                if(Ctrl.cbo.ItemIndex < 0) then
                  Ctrl.cbo.ItemIndex := 0;
                Ctrl.cbo.OnChange := Prompt.PromptChange;
                DoLbl := TRUE;
                Ctrl.cbo.ListItemsOnly := (pt <> ptVisitLocation);
                UpdateColorsFor508Compliance(Ctrl.cbo);
              end;

              ptWHPapResult:
              begin
                if FData<>nil then
                begin
                  if (TRemData(FData[i]).DisplayWHResults)=true then
                  begin
                    NextLine(Y);
                    Ctrl.btn := TCPRSDialogButton.Create(AOwner);
                    Ctrl.ctrl.Parent := AParent;
                    Ctrl.btn.Left := NewLInePromptGap+15;
                    Ctrl.btn.Top := Y+7;
                    Ctrl.btn.OnClick := Prompt.DoWHReport;
                    Ctrl.btn.Caption := 'Review complete report';
                    Ctrl.btn.Width := TextWidthByFont(Ctrl.btn.Font.Handle, Ctrl.btn.Caption) + 13;
                    Ctrl.btn.Height := TextHeightByFont(Ctrl.btn.Font.Handle, Ctrl.btn.Caption) + 13;
                    Ctrl.btn.Height := TextHeightByFont(Ctrl.btn.Handle, Ctrl.btn.Caption) + 8;
                    ScreenReaderSupport(Ctrl.btn);
                    UpdateColorsFor508Compliance(Ctrl.btn);
                    Y := ctrl.btn.Top + Ctrl.btn.Height;
                    NextLine(Y);
                    Ctrl.WHChk := TWHCheckBox.Create(AOwner);
                    Ctrl.ctrl.Parent := AParent;
                    ProcessLabel(Prompt.Required, TRUE, Ctrl.WHChk.Parent, Ctrl.WHChk);
                    if lblCtrl is TWinControl then
                      TWinControl(lblCtrl).TabOrder := Ctrl.WHChk.TabOrder;
                    Ctrl.WHChk.Flbl := lblCtrl;
                    Ctrl.WHChk.Flbl.Top := Y + 5;
                    Ctrl.WHChk.Flbl.Left := NewLinePromptGap+15;
                    WrapLeft := Ctrl.WHChk.Flbl.Left;
//                    Ctrl.WHChk.Flbl.Width := TextWidthByFont(
//                      TExposedComponent(Ctrl.WHChk.Flbl).Font.Handle,
//                      TExposedComponent(Ctrl.WHChk.Flbl).Caption)+25;
//                    Ctrl.WHChk.Flbl.Height := TextHeightByFont(
//                      TExposedComponent(Ctrl.WHChk.Flbl).Font.Handle,
//                      TExposedComponent(Ctrl.WHChk.Flbl).Caption);
                    //LineWidth := WrapLeft + Ctrl.WHChk.Flbl.Width+10;
                    Y := Ctrl.WHChk.Flbl.Top + Ctrl.WHChk.Flbl.Height;
                    NextLine(Y);
                    Ctrl.WHChk.RadioStyle:=true;
                    Ctrl.WHChk.GroupIndex:=1;
                    Ctrl.WHChk.Check2 := TWHCheckBox.Create(AOwner);
                    Ctrl.WHChk.Check2.Parent := Ctrl.WHChk.Parent;
                    Ctrl.WHChk.Check2.RadioStyle:=true;
                    Ctrl.WHChk.Check2.GroupIndex:=1;
                    Ctrl.WHChk.Check3 := TWHCheckBox.Create(AOwner);
                    Ctrl.WHChk.Check3.Parent := Ctrl.WHChk.Parent;
                    Ctrl.WHChk.Check3.RadioStyle:=true;
                    Ctrl.WHChk.Check3.GroupIndex:=1;
                    Ctrl.WHChk.Caption := 'NEM (No Evidence of Malignancy)';
                    Ctrl.WHChk.ShowHint := true;
                    Ctrl.WHChk.Hint := 'No Evidence of Malignancy';
                    Ctrl.WHChk.Width := TextWidthByFont(Ctrl.WHChk.Font.Handle, Ctrl.WHChk.Caption)+20;
                    Ctrl.WHChk.Height := TextHeightByFont(Ctrl.WHChk.Font.Handle, Ctrl.WHChk.Caption)+4;
                    Ctrl.WHChk.Top := Y + 5;
                    Ctrl.WHChk.Left := WrapLeft;
                    Ctrl.WHChk.OnClick := Prompt.PromptChange;
                    Ctrl.WHChk.Checked := (WHResultChk = 'N');
                    LineWidth := WrapLeft + Ctrl.WHChk.Width+5;
                    Ctrl.WHChk.Check2.Caption := 'Abnormal';
                    Ctrl.WHChk.Check2.Width := TextWidthByFont(Ctrl.WHChk.Check2.Font.Handle, Ctrl.WHChk.Check2.Caption) + 20;
                    Ctrl.WHChk.Check2.Height := TextHeightByFont(Ctrl.WHChk.check2.Font.Handle, Ctrl.WHChk.check2.Caption)+4;
                    if (LineWidth + Ctrl.WHChk.Check2.Width) > PWidth - 10 then
                    begin
                      LineWidth := WrapLeft;
                      Y := Ctrl.WHChk.Top + Ctrl.WHChk.Height;
                      Nextline(Y);
                    end;
                    Ctrl.WHChk.Check2.Top := Y + 5;
                    Ctrl.WHChk.Check2.Left := LineWidth;
                    Ctrl.WHChk.Check2.OnClick := Prompt.PromptChange;
                    Ctrl.WHChk.Check2.Checked := (WHResultChk = 'A');
                    LineWidth := LineWidth + Ctrl.WHChk.Check2.Width+5;
                    Ctrl.WHChk.Check3.Caption := 'Unsatisfactory for Diagnosis';
                    Ctrl.WHChk.Check3.Width := TextWidthByFont(Ctrl.WHChk.Check3.Font.Handle, Ctrl.WHChk.Check3.Caption)+20;
                    Ctrl.WHChk.Check3.Height := TextHeightByFont(Ctrl.WHChk.check3.Font.Handle, Ctrl.WHChk.check3.Caption)+4;
                    if (LineWidth + Ctrl.WHChk.Check3.Width) > PWidth - 10 then
                    begin
                      LineWidth := WrapLeft;
                      Y := Ctrl.WHChk.Check2.Top + Ctrl.WHChk.Check2.Height;
                      Nextline(Y);
                    end;
                    Ctrl.WHChk.Check3.Top := Y + 5;
                    Ctrl.WHChk.Check3.OnClick := Prompt.PromptChange;
                    Ctrl.WHChk.Check3.Checked := (WHResultChk = 'U');
                    Ctrl.WHChk.Check3.Left := LineWidth;
                    UpdateColorsFor508Compliance(Ctrl.WHChk);
                    UpdateColorsFor508Compliance(Ctrl.WHChk.Flbl);
                    UpdateColorsFor508Compliance(Ctrl.WHChk.Check2);
                    UpdateColorsFor508Compliance(Ctrl.WHChk.Check3);
                    ScreenReaderSupport(Ctrl.WHChk);
                    ScreenReaderSupport(Ctrl.WHChk.Check2);
                    ScreenReaderSupport(Ctrl.WHChk.Check3);
                    Y := Ctrl.WHChk.Check3.Top + Ctrl.WHChk.Check3.Height;
                    Nextline(Y);
                  end
                  else
                    DoLbl := FALSE;
                end
                else
                  DoLbl :=FALSE;
              end;

              ptWHNotPurp:
              begin
                NextLine(Y);
                Ctrl.WHChk := TWHCheckBox.Create(AOwner);
                Ctrl.ctrl.Parent := AParent;
                ProcessLabel(Prompt.Required, TRUE, Ctrl.WHChk.Parent, Ctrl.WHChk);
                Ctrl.WHChk.Flbl := lblCtrl;
                if lblCtrl is TWinControl then
                  TWinControl(lblCtrl).TabOrder := Ctrl.WHChk.TabOrder;
                Ctrl.WHChk.Flbl.Top := Y + 7;
                Ctrl.WHChk.Flbl.Left := NewLInePromptGap+30;
                WrapLeft := Ctrl.WHChk.Flbl.Left;
//                Ctrl.WHChk.Flbl.Width := TextWidthByFont(
//                  TExposedComponent(Ctrl.WHChk.Flbl).Font.Handle,
//                  TExposedComponent(Ctrl.WHChk.Flbl).Caption)+25;
//                Ctrl.WHChk.Flbl.Height := TextHeightByFont(
//                  TExposedComponent(Ctrl.WHChk.Flbl).Font.Handle,
//                  TExposedComponent(Ctrl.WHChk.Flbl).Caption)+4;
                LineWidth := WrapLeft + Ctrl.WHChk.Flbl.Width+10;
                Ctrl.WHChk.Check2 := TWHCheckBox.Create(AOwner);
                Ctrl.WHChk.Check2.Parent := Ctrl.WHChk.Parent;
                Ctrl.WHChk.Check3 := TWHCheckBox.Create(AOwner);
                Ctrl.WHChk.Check3.Parent := Ctrl.WHChk.Parent;
                Ctrl.WHChk.ShowHint := true;
                Ctrl.WHChk.Hint := 'Letter will print with next WH batch run';
                Ctrl.WHChk.Caption := 'Letter';
                Ctrl.WHChk.Width := TextWidthByFont(Ctrl.WHChk.Font.Handle, Ctrl.WHChk.Caption)+25;
                Ctrl.WHChk.Height := TextHeightByFont(Ctrl.WHChk.Font.Handle, Ctrl.WHChk.Caption)+4;
                if (LineWidth + Ctrl.WHChk.Width) > PWidth - 10 then
                begin
                  LineWidth := WrapLeft;
                  Y := Ctrl.WHChk.Flbl.Top + Ctrl.WHChk.Flbl.Height;
                  Nextline(Y);
                end;
                Ctrl.WHChk.Top := Y + 7;
                Ctrl.WHChk.Left := LineWidth;
                Ctrl.WHChk.OnClick := Prompt.PromptChange;
                Ctrl.WHChk.Checked := (Pos('L',WHResultNot)>0);
                LineWidth := LineWidth + Ctrl.WHChk.Width+10;
                Ctrl.WHChk.Check2.Caption := 'In-Person';
                Ctrl.WHChk.Check2.Width := TextWidthByFont(Ctrl.WHChk.Check2.Font.Handle, Ctrl.WHChk.Check2.Caption) + 25;
                Ctrl.WHChk.Check2.Height := TextHeightByFont(Ctrl.WHChk.check2.Font.Handle, Ctrl.WHChk.check2.Caption)+4;
                if (LineWidth + Ctrl.WHChk.Check2.Width) > PWidth - 10 then
                begin
                  LineWidth := WrapLeft;
                  Y := Ctrl.WHChk.Top + Ctrl.WHChk.Height;
                  Nextline(Y);
                end;
                Ctrl.WHChk.Check2.Top := Y + 7;
                Ctrl.WHChk.Check2.Left := LineWidth;
                Ctrl.WHChk.Check2.OnClick := Prompt.PromptChange;
                Ctrl.WHChk.Check2.Checked := (Pos('I',WHResultNot)>0);
                LineWidth := LineWidth + Ctrl.WHChk.Check2.Width+10;
                Ctrl.WHChk.Check3.Caption := 'Phone Call';
                Ctrl.WHChk.Check3.Width := TextWidthByFont(Ctrl.WHChk.Check3.Font.Handle, Ctrl.WHChk.Check3.Caption)+20;
                Ctrl.WHChk.Check3.Height := TextHeightByFont(Ctrl.WHChk.check3.Font.Handle, Ctrl.WHChk.check3.Caption)+4;
                if (LineWidth + Ctrl.WHChk.Check3.Width) > PWidth - 10 then
                begin
                  LineWidth := WrapLeft;
                  Y := Ctrl.WHChk.Check2.Top + Ctrl.WHChk.Check2.Height;
                  Nextline(Y);
                end;
                Ctrl.WHChk.Check3.Top := Y + 7;
                Ctrl.WHChk.Check3.OnClick := Prompt.PromptChange;
                Ctrl.WHChk.Check3.Checked := (Pos('P',WHResultNot)>0);
                Ctrl.WHChk.Check3.Left := LineWidth;
                Y := Ctrl.WHChk.Check3.Top + Ctrl.WHChk.Check3.Height;
                Nextline(Y);
                Ctrl.WHChk.Fbutton := TCPRSDialogButton.Create(AOwner);
                Ctrl.WHChk.FButton.Parent := Ctrl.WHChk.Parent;
                Ctrl.WHChk.FButton.Enabled:=(Pos('L',WHResultNot)>0);
                Ctrl.WHChk.FButton.Left := Ctrl.WHChk.Flbl.Left;
                Ctrl.WHChk.FButton.Top := Y+7;
                Ctrl.WHChk.FButton.OnClick := Prompt.ViewWHText;
                Ctrl.WHChk.FButton.Caption := 'View WH Notification Letter';
                Ctrl.WHChk.FButton.Width := TextWidthByFont(Ctrl.WHChk.FButton.Font.Handle, Ctrl.WHChk.FButton.Caption) + 13;
                Ctrl.WHChk.FButton.Height := TextHeightByFont(Ctrl.WHChk.FButton.Font.Handle, Ctrl.WHChk.FButton.Caption) + 13;
                UpdateColorsFor508Compliance(Ctrl.WHChk);
                UpdateColorsFor508Compliance(Ctrl.WHChk.Flbl);
                UpdateColorsFor508Compliance(Ctrl.WHChk.Check2);
                UpdateColorsFor508Compliance(Ctrl.WHChk.Check3);
                UpdateColorsFor508Compliance(Ctrl.WHChk.FButton);
                ScreenReaderSupport(Ctrl.WHChk);
                ScreenReaderSupport(Ctrl.WHChk.Check2);
                ScreenReaderSupport(Ctrl.WHChk.Check3);
                ScreenReaderSupport(Ctrl.WHChk.FButton);
                LineWidth := Ctrl.WHChk.FButton.Left + Ctrl.WHChk.FButton.Width;
                if piece(Prompt.FRec4,u,12)='1' then
                begin
                  Ctrl.WHChk.FPrintNow :=TCPRSDialogCheckBox.Create(AOwner);
                  Ctrl.WHChk.FPrintNow.Parent := Ctrl.WHChk.Parent;
                  Ctrl.WHChk.FPrintNow.ShowHint := true;
                  Ctrl.WHChk.FPrintNow.Hint := 'Letter will print after "Finish" button is clicked';
                  Ctrl.WHChk.FPrintNow.Caption:='Print Now';
                  Ctrl.WHChk.FPrintNow.Width := TextWidthByFont(Ctrl.WHChk.FPrintNow.Font.Handle, Ctrl.WHChk.FPrintNow.Caption)+20;
                  Ctrl.WHChk.FPrintNow.Height := TextHeightByFont(Ctrl.WHChk.FPrintNow.Font.Handle, Ctrl.WHChk.FPrintNow.Caption)+4;
                  if (LineWidth + Ctrl.WHChk.FPrintNow.Width) > PWidth - 10 then
                  begin
                    LineWidth := WrapLeft;
                    Y := Ctrl.WHChk.FButton.Top + Ctrl.WHChk.FButton.Height;
                    Nextline(Y);
                  end;
                  Ctrl.WHChk.FPrintNow.Left := LineWidth + 15;
                  Ctrl.WHChk.FPrintNow.Top := Y + 7;
                  Ctrl.WHChk.FPrintNow.Enabled := (Pos('L',WHResultNot)>0);
                  Ctrl.WHChk.FPrintNow.Checked :=(WHPrintDevice<>'');
                  Ctrl.WHChk.FPrintNow.OnClick := Prompt.PromptChange;
                  UpdateColorsFor508Compliance(Ctrl.WHChk.FPrintNow);
                  MinX :=PWidth;
                  if (Ctrl.WHChk.FButton.Top + Ctrl.WHChk.FButton.Height) > (Ctrl.WHChk.FPrintNow.Top + Ctrl.WHChk.FPrintNow.Height) then
                    Y := Ctrl.WHChk.FButton.Top + Ctrl.WHChk.FButton.Height + 7
                  else
                    Y := Ctrl.WHChk.FPrintNow.Top + Ctrl.WHChk.FPrintNow.Height + 7;
                ScreenReaderSupport(Ctrl.WHChk.FPrintNow);
                end
                else
                  Y := Ctrl.WHChk.FButton.Top + Ctrl.WHChk.FButton.Height + 7;
                NextLine(Y);
              end;

            ptVisitDate:
              begin
                Ctrl.dt := TCPRSDialogDateCombo.Create(AOwner);
                Ctrl.ctrl.Parent := AParent;
                Ctrl.dt.LongMonths := TRUE;
                try
                  DefaultDate := Ctrl.dt.FMDate;
                  Ctrl.dt.FMDate := StrToFloat(Prompt.Value);
                except
                  on EConvertError do
                    Ctrl.dt.FMDate := DefaultDate;
                  else
                    raise;
                end;
                Ctrl.dt.OnChange := Prompt.PromptChange;
                UpdateColorsFor508Compliance(Ctrl.dt);
                DoLbl := TRUE;
                MinX := Ctrl.dt.Width;
                //TextWidthByFont(Ctrl.dt.Font.Handle, 'May 22, 2000') + 26;
              end;

            ptPrimaryDiag, ptAdd2PL, ptContraindicated:
              begin
                Ctrl.cb := TCPRSDialogCheckBox.Create(AOwner);
                Ctrl.ctrl.Parent := AParent;
                Ctrl.cb.Checked := (Prompt.Value = '1');
                Ctrl.cb.Caption := Prompt.Caption;
                if prompt.Required=false then DoLbl := true;
                Ctrl.cb.AutoSize := False;
                Ctrl.cb.OnEnter := ParentCBEnter;
                Ctrl.cb.OnExit := ParentCBExit;
                Ctrl.cb.Height := TORCheckBox(Ctrl.cb).Height + 5;
                Ctrl.cb.Width := 17;
                Ctrl.cb.OnClick := Prompt.PromptChange;
                UpdateColorsFor508Compliance(Ctrl.cb);
                MinX := Ctrl.cb.Width;
              end;

            else
            begin
              if(pt = ptSubComment) then
              begin
                Ctrl.cb := TCPRSDialogCheckBox.Create(AOwner);
                Ctrl.ctrl.Parent := AParent;
                Ctrl.cb.Checked := (Prompt.Value = '1');
                Ctrl.cb.Caption := Prompt.Caption;
                Ctrl.cb.AutoSize := TRUE;
                Ctrl.cb.OnClick := SubCommentChange;
                Ctrl.cb.Tag := Integer(Prompt);
                UpdateColorsFor508Compliance(Ctrl.cb);
                MinX := Ctrl.cb.Width;
              end
              else
              if pt = ptVitalEntry then
              begin
                vt := Prompt.VitalType;
                if(vt = vtPain) then
                begin
                  Ctrl.cbo := TCPRSDialogComboBox.Create(AOwner);
                  Ctrl.ctrl.Parent := AParent;
                  Ctrl.cbo.Style := orcsDropDown;
                  Ctrl.cbo.Pieces := '1,2';
                  Ctrl.cbo.OnKeyDown := Prompt.ComboBoxKeyDown;
                  InitPainCombo(Ctrl.cbo);
                  Ctrl.cbo.ListItemsOnly := TRUE;
                  Ctrl.cbo.SelectByID(Prompt.VitalValue);
                  Ctrl.cbo.OnChange := Prompt.PromptChange;
                  Ctrl.cbo.SelLength := 0;
                  MinX := TextWidthByFont(Ctrl.cbo.Font.Handle, Ctrl.cbo.DisplayText[0]) + 24;
                  MaxX := TextWidthByFont(Ctrl.cbo.Font.Handle, Ctrl.cbo.DisplayText[1]) + 24;
                  if(ElementChecked = Self) then
                  begin
                    AutoFocusControl := Ctrl.cbo;
                    ElementChecked := nil;
                  end;
                  UpdateColorsFor508Compliance(Ctrl.cbo);
                end
                else
                begin
                  Ctrl.vedt := TVitalEdit.Create(AOwner);
                  Ctrl.ctrl.Parent := AParent;
                  MinX := TextWidthByFont(Ctrl.vedt.Font.Handle, '12345.67');
                  Ctrl.vedt.OnKeyPress := Prompt.EditKeyPress;
                  Ctrl.vedt.OnChange := Prompt.PromptChange;
                  Ctrl.vedt.OnExit := Prompt.VitalVerify;
                  UpdateColorsFor508Compliance(Ctrl.vedt);
                  if(vt in [vtTemp, vtHeight, vtWeight]) then
                  begin
                    HasVCombo := TRUE;
                    Ctrl.vedt.LinkedCombo := TVitalComboBox.Create(AOwner);
                    Ctrl.vedt.LinkedCombo.Parent := AParent;
                    Ctrl.vedt.LinkedCombo.OnChange := Prompt.PromptChange;
                    Ctrl.vedt.LinkedCombo.Tag := VitalControlTag(vt, TRUE);
                    Ctrl.vedt.LinkedCombo.OnExit := Prompt.VitalVerify;
                    Ctrl.vedt.LinkedCombo.LinkedEdit := Ctrl.vedt;
                    case vt of
                      vtTemp:
                        begin
                          Ctrl.vedt.LinkedCombo.Items.Add('F');
                          Ctrl.vedt.LinkedCombo.Items.Add('C');
                        end;

                      vtHeight:
                        begin
                          Ctrl.vedt.LinkedCombo.Items.Add('IN');
                          Ctrl.vedt.LinkedCombo.Items.Add('CM');
                        end;

                      vtWeight:
                        begin
                          Ctrl.vedt.LinkedCombo.Items.Add('LB');
                          Ctrl.vedt.LinkedCombo.Items.Add('KG');
                        end;

                    end;
                    Ctrl.vedt.LinkedCombo.SelectByID(Prompt.VitalUnitValue);
                    if(Ctrl.vedt.LinkedCombo.ItemIndex < 0) then
                      Ctrl.vedt.LinkedCombo.ItemIndex := 0;
                    Ctrl.vedt.LinkedCombo.Width := TextWidthByFont(Ctrl.vedt.Font.Handle,
                                                                    Ctrl.vedt.LinkedCombo.Items[1]) + 30;
                    Ctrl.vedt.LinkedCombo.SelLength := 0;
                    UpdateColorsFor508Compliance(Ctrl.vedt.LinkedCombo);
                    inc(MinX, Ctrl.vedt.LinkedCombo.Width);
                  end;
                  if(ElementChecked = Self) then
                  begin
                    AutoFocusControl := Ctrl.vedt;
                    ElementChecked := nil;
                  end;
                end;
                Ctrl.ctrl.Text := Prompt.VitalValue;
                Ctrl.ctrl.Tag := VitalControlTag(vt);
                DoLbl := TRUE;
              end
              else
              if pt = ptDataList then
              begin
                Ctrl.cbo := TCPRSDialogComboBox.Create(AOwner);
                Ctrl.ctrl.Parent := AParent;
                Ctrl.cbo.Style := orcsDropDown;
                Ctrl.cbo.Pieces := '12';
                if ActChoicesSL = nil then
                   ActChoicesSL := TORStringList.Create;
                if Self.Historical then
                  EncDt := DateTimeToFMDateTime(Date)
                else
                  EncDt := RemForm.PCEObj.VisitDateTime;
                if assigned(Prompt.FData.FChoicesActiveDates) then {csv active/inactive dates}
                 for m := 0 to (Prompt.FData.FChoices.Count - 1) do
                  begin
                    for n := 0 to (TStringList(Prompt.FData.FChoicesActiveDates[m]).Count - 1) do
                     begin
                       ActDt := StrToIntDef((Piece(TStringList(Prompt.FData.FChoicesActiveDates[m]).Strings[n], ':', 1)),0);
                       InActDt := StrToIntDef((Piece(TStringList(Prompt.FData.FChoicesActiveDates[m]).Strings[n], ':', 2)),9999999);
                       Piece12 := Piece(Prompt.FData.FChoices.Strings[m],U,12);
                       Prompt.FData.FChoices.SetStrPiece(m,12,Piece12);
                       if (EncDt >= ActDt) and (EncDt <= InActDt) then
                          ActChoicesSL.AddObject(Prompt.FData.FChoices[m], Prompt.FData.FChoices.Objects[m]);
                     end; {loop through the TStringList object in FChoicesActiveDates[m] object property}
                  end  {loop through FChoices/FChoicesActiveDates}
                else
                  FastAssign(Prompt.FData.FChoices, ActChoicesSL);
                FastAssign(ActChoicesSL, Ctrl.cbo.Items);
                Ctrl.cbo.CheckBoxes := TRUE;
                Ctrl.cbo.SelectByID(Prompt.Value);
                Ctrl.cbo.OnCheckedText := FReminder.ComboBoxCheckedText;
                Ctrl.cbo.OnResize := FReminder.ComboBoxResized;
                Ctrl.cbo.CheckedString := Prompt.Value;
                Ctrl.cbo.OnChange := Prompt.PromptChange;
                Ctrl.cbo.ListItemsOnly := TRUE;
                UpdateColorsFor508Compliance(Ctrl.cbo);
                if(ElementChecked = Self) then
                begin
                  AutoFocusControl := Ctrl.cbo;
                  ElementChecked := nil;
                end;
                DoLbl := TRUE;
                if(Prompt.FData.FChoicesFont = Ctrl.cbo.Font.Handle) then
                begin
                  MinX := Prompt.FData.FChoicesMin;
                  MaxX := Prompt.FData.FChoicesMax;
                end
                //agp ICD-10 suppress combobox and label if no values.
                else if (Ctrl.cbo.Items.Count > 0) then
                begin
                  GetComboBoxMinMax(Ctrl.cbo, MinX, MaxX);
                  inc(MaxX,18); // Adjust for checkboxes
                  MinX := MaxX;
                  Prompt.FData.FChoicesFont := Ctrl.cbo.Font.Handle;
                  Prompt.FData.FChoicesMin := MinX;
                  Prompt.FData.FChoicesMax := MaxX;
                end
                else DoLbl := FALSE
              end
              else
              if(pt = ptMHTest) or ((pt = ptGaf) and (MHDLLFound = true)) then
              begin
                Ctrl.btn := TCPRSDialogButton.Create(AOwner);
                Ctrl.ctrl.Parent := AParent;
                Ctrl.btn.OnClick := Prompt.DoMHTest;
                Ctrl.btn.Caption := Prompt.ForcedCaption;
                if Piece(Prompt.FData.FRec3,U,13)='1' then
                begin
                  Ctrl.btn.Caption := Ctrl.btn.Caption + ' *';
                  (Ctrl.btn as ICPRSDialogComponent).RequiredField := TRUE;
                end;
                MinX := TextWidthByFont(Ctrl.btn.Font.Handle, Ctrl.btn.Caption) + 13;
                Ctrl.btn.Height := TextHeightByFont(Ctrl.btn.Font.Handle, Ctrl.btn.Caption) + 8;
                DoLbl := TRUE;
              end
             else
              if ((pt = ptGAF)) and (MHDLLFound = false) then
              begin
                Ctrl.edt := TCPRSDialogFieldEdit.Create(AOwner);
                Ctrl.ctrl.Parent := AParent;
                Ctrl.edt.Text := Prompt.Value;
                ud := TUpDown.Create(AOwner);
                ud.Parent := AParent;
                ud.Associate := Ctrl.edt;
                ud.Min := 0;
                ud.Max := 100;
                MinX := TextWidthByFont(Ctrl.edt.Font.Handle, IntToStr(ud.Max)) + 24 + Gap;
                ud.Position := StrToIntDef(Prompt.Value, ud.Min);
                Ctrl.edt.OnKeyPress := Prompt.EditKeyPress;
                Ctrl.edt.OnChange := Prompt.PromptChange;
                if(User.WebAccess and (GAFURL <> '')) then
                begin
                  HelpBtn := TCPRSDialogButton.Create(AOwner);
                  HelpBtn.Parent := AParent;
                  HelpBtn.Caption := 'Reference Info';
                  HelpBtn.OnClick := Prompt.GAFHelp;
                  HelpBtn.Width := TextWidthByFont(HelpBtn.Font.Handle, HelpBtn.Caption) + 13;
                  HelpBtn.Height := Ctrl.edt.Height;
                  inc(MinX, HelpBtn.Width);
                end;
                DoLbl := TRUE;
              end
              else
                Ctrl.ctrl := nil;
            end;
          end;

           if(DoLbl) and ((pt <> ptWHNotPurp) and (pt <> ptWHPapResult)) then
          //if(DoLbl) then
          begin
            Req := Prompt.Required;
            if (not Req) and (pt = ptGaf) and (MHDLLFound = false) then
              Req := (Piece(Prompt.FData.FRec3,U,13) = '1');
            ProcessLabel(Req, Prompt.FParent.Enabled, AParent, Ctrl.Ctrl);
            if assigned(lblCtrl) then
            begin
              inc(MinX, lblCtrl.Width + LblGap);
              inc(MaxX, lblCtrl.Width + LblGap);
            end
            else
              DoLbl := FALSE;
          end;

          if(MaxX < MinX) then
            MaxX := MinX;

          if((Prompt.SameLine) and ((LastX + MinX + Gap) < PWidth)) and
          ((pt <> ptWHNotPurp) and (pt <> ptWHPapResult)) then
          //if((Prompt.SameLine) and ((LastX + MinX + Gap) < PWidth)) then
          begin
            X := LastX;
          end
          else
          begin
            if(Shared) and (assigned(FChildren)) and (FChildren.Count > 0) then
              X := TRemDlgElement(FChildren[0]).TrueIndent
            else
            begin
              if(assigned(cb)) then
                X := cb.Left + NewLinePromptGap
              else
                X := pnl.Left + NewLinePromptGap;
            end;
            NextLine(Y);
          end;
          if(MaxX > (PWidth - X - Gap)) then
            MaxX := PWidth - X - Gap;
          if((DoLbl) or (assigned(Ctrl.Ctrl)))  and
          ((pt <> ptWHNotPurp) and (pt <> ptWHPapResult)) then
          //if((DoLbl) or (assigned(Ctrl.Ctrl))) then
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
            if(assigned(Ctrl.Ctrl)) then
            begin
              if ScreenReaderSystemActive then
              begin
                if Supports(Ctrl.Ctrl, ICPRSDialogComponent) then
                  ScreenReaderSystem_CurrentComponent(Ctrl.Ctrl as ICPRSDialogComponent)
                else
                  ScreenReaderSystem_Stop;
              end;
              Ctrl.Ctrl.Enabled := Prompt.FParent.Enabled;
              if not Ctrl.Ctrl.Enabled then
                Ctrl.Ctrl.Font.Color := DisabledFontColor;
              Ctrl.Ctrl.Left := X;
              Ctrl.Ctrl.Top := Y;
              SameLineCtrl.Add(Ctrl.Ctrl);
              if(assigned(ud)) then
              begin
                SameLineCtrl.Add(ud);
                if(assigned(HelpBtn)) then
                begin
                  SameLineCtrl.Add(HelpBtn);
                  Ctrl.Ctrl.Width := MinX - HelpBtn.Width - ud.Width;
                  HelpBtn.Left := X + Ctrl.Ctrl.Width + ud.Width + Gap;
                  HelpBtn.Top := Y;
                  HelpBtn.Enabled := Prompt.FParent.Enabled;
                end
                else
                  Ctrl.Ctrl.Width := MinX - ud.Width;
                ud.Left := X + Ctrl.Ctrl.Width;
                ud.Top := Y;
                LastX := X + MinX + PromptGap;
                ud.Enabled := Prompt.FParent.Enabled;
              end
              else
              if(HasVCombo) then
              begin
                SameLineCtrl.Add(Ctrl.vedt.LinkedCombo);
                Ctrl.Ctrl.Width := MinX - Ctrl.vedt.LinkedCombo.Width;
                Ctrl.vedt.LinkedCombo.Left := X + Ctrl.Ctrl.Width;
                Ctrl.vedt.LinkedCombo.Top := Y;
                LastX := X + MinX + PromptGap;
                Ctrl.vedt.LinkedCombo.Enabled := Prompt.FParent.Enabled;
              end
              else
              begin
                Ctrl.Ctrl.Width := MaxX;
                LastX := X + MaxX + PromptGap;
              end;
            end;
          end;
        end;
        if(assigned(ud)) then
          Prompt.FCurrentControl := ud
        else
          Prompt.FCurrentControl := Ctrl.Ctrl;
      end;
      NextLine(Y);
    finally
      SameLineCtrl.Free;
    end;
  end;

  procedure UpdatePrompts(EnablePanel: boolean; ClearCB: boolean);
  begin
    if EnablePanel then
    begin
      if not ScreenReaderSystemActive then
      begin
        pnl.TabStop := TRUE;     {tab through the panels instead of the checkboxes}
        pnl.OnEnter := FieldPanelEntered;
        pnl.OnExit := FieldPanelExited;
      end;
      if ClearCB then
        cb := nil;
    end;

    if (FChecked and assigned(FPrompts) and (FPrompts.Count > 0)) then
    begin
      AddPrompts(FALSE, BaseParent, ParentWidth, Y);
    end
    else
      inc(Y, pnl.Height);
  end;

begin
  Result := nil;
  cb := nil;
  pnl := nil;
  AutoFocusControl := nil;
  X := TrueIndent;
  if(assigned(FPrompts)) then
  begin
    for i := 0 to FPrompts.Count-1 do
      TRemPrompt(FPrompts[i]).FCurrentControl := nil;
  end;
  if(ElemType = etDisplayOnly) then
  begin
    if(FText <> '') then
    begin
      inc(Y,Gap);
      pnl := GetPanel(EntryID, CRLFText(FText), ParentWidth - X - (Gap * 2), nil);
      pnl.Left := X;
      pnl.Top := Y;
      UpdatePrompts(ScreenReaderSystemActive, TRUE);
    end;
  end
  else
  begin
    inc(Y,Gap);
    cb := TCPRSDialogParentCheckBox.Create(AOwner);
    cb.Parent := BaseParent;
    cb.Left := X;
    cb.Top := Y;
    cb.Tag := Integer(Self);
    cb.WordWrap := TRUE;
    cb.AutoSize := TRUE;
    cb.Checked := FChecked;
    cb.Width := ParentWidth - X - Gap;
    if not ScreenReaderSystemActive then
      cb.Caption := CRLFText(FText);
    cb.AutoAdjustSize;
    cbSingleLine := cb.SingleLine;
//    cb.AutoSize := FALSE;
    cb.WordWrap := FALSE;
    cb.Caption := ' ';
//    cb.Width := 13;
//    cb.Height := 17;
    if not ScreenReaderSystemActive then
      cb.TabStop := False;  {take checkboxes out of the tab order}
    pnl := GetPanel(EntryID, CRLFText(FText), ParentWidth - X - (Gap * 2) - IndentGap, cb);
    pnl.Left := X + IndentGap;
    pnl.Top := Y;
    cb.Associate := pnl;
    pnl.Tag := Integer(cb);   {So the panel can check the checkbox}
    cb.OnClick := cbClicked;
    cb.OnEnter := cbEntered;
    if ScreenReaderSystemActive then
      cb.OnExit := ParentCBExit;

    UpdateColorsFor508Compliance(cb);
    pnl.OnKeyPress := FieldPanelKeyPress;
    pnl.OnClick := FieldPanelOnClick;
    for i := 0 to pnl.ControlCount - 1 do
      if ((pnl.Controls[i] is TLabel) or (pnl.Controls[i] is TVA508StaticText)) and
         not (fsUnderline in TLabel(pnl.Controls[i]).Font.Style) then //If this isn't a hyperlink change then event handler
         TLabel(pnl.Controls[i]).OnClick := FieldPanelLabelOnClick;

    //cb.Enabled := Enabled;
    if(assigned(FParent) and (FParent.ChildrenRequired in [crOne, crNoneOrOne])) then
      cb.RadioStyle := TRUE;

    UpdatePrompts(TRUE, FALSE);
  end;

  if(ShowChildren) then
  begin
    gb := nil;
    if(Box) then
    begin
      gb := TGroupBox.Create(AOwner);
      gb.Parent := BaseParent;
      gb.Left := TrueIndent + (ChildrenIndent * IndentMult);
      gb.Top := Y;
      gb.Width := ParentWidth - gb.Left - Gap;
      PrntWidth := gb.Width - (Gap * 2);
      gb.Caption := BoxCaption;
//      if ScreenReaderSystemActive then
//      begin
//        ScreenReaderSystem_AddText(gb.Caption + ',');
//      end;
      gb.Enabled := EnableChildren;
      if(not EnableChildren) then
        gb.Font.Color := DisabledFontColor;
      UpdateColorsFor508Compliance(gb);
      prnt := gb;
      if(gb.Caption = '') then
        Y1 := gbTopIndent
      else
        Y1 := gbTopIndent2;
    end
    else
    begin
      prnt := BaseParent;
      Y1 := Y;
      PrntWidth := ParentWidth;
    end;

    for i := 0 to FChildren.Count-1 do
    begin
      ERes := TRemDlgElement(FChildren[i]).BuildControls(Y1, PrntWidth, prnt, AOwner);
      if(not assigned(Result)) then
        Result := ERes;
    end;

    if(FHasSharedPrompts) then
      AddPrompts(TRUE, prnt, PrntWidth, Y1);

    if(Box) then
    begin
      gb.Height := Y1 + (Gap * 3);
      inc(Y, Y1 + (Gap * 4));
    end
    else
      Y := Y1;
  end;

  SubCommentChange(nil);

  if(assigned(AutoFocusControl)) then
  begin
    if(AutoFocusControl is TORComboBox) and
      (TORComboBox(AutoFocusControl).CheckBoxes) and
      (pos('1',TORComboBox(AutoFocusControl).CheckedString) = 0) then
      Result := AutoFocusControl
    else
    if(TORExposedControl(AutoFocusControl).Text = '') then
      Result := AutoFocusControl
  end;
  if ScreenReaderSystemActive then
    ScreenReaderSystem_Stop;
end;

//This is used to get the template field values if this reminder is not the
//current reminder in dialog, in which case no uEntries will exist so we have
//to get the template field values that were saved in the element.
function TRemDlgElement.GetTemplateFieldValues(const Text: string; FldValues: TORStringList =  nil): string;
var
  flen, CtrlID, i, j: integer;
  Fld: TTemplateField;
  Temp, FldName, NewTxt: string;

const
  TemplateFieldBeginSignature = '{FLD:';
  TemplateFieldEndSignature = '}';
  TemplateFieldSignatureLen = length(TemplateFieldBeginSignature);
  TemplateFieldSignatureEndLen = length(TemplateFieldEndSignature);
  FieldIDDelim = '`';
  FieldIDLen = 6;

  procedure AddNewTxt;
  begin
    if(NewTxt <> '') then
    begin
      insert(StringOfChar('x',length(NewTxt)), Temp, i);
      insert(NewTxt, Result, i);
      inc(i, length(NewTxt));
    end;
  end;

begin
  Result := Text;
  Temp := Text;
  repeat
    i := pos(TemplateFieldBeginSignature, Temp);
    if(i > 0) then
    begin
      CtrlID := 0;
      if(copy(Temp, i + TemplateFieldSignatureLen, 1) = FieldIDDelim) then
      begin
        CtrlID := StrToIntDef(copy(Temp, i + TemplateFieldSignatureLen + 1, FieldIDLen-1), 0);
        delete(Temp,i + TemplateFieldSignatureLen, FieldIDLen);
        delete(Result,i + TemplateFieldSignatureLen, FieldIDLen);
      end;
      j := pos(TemplateFieldEndSignature, copy(Temp, i + TemplateFieldSignatureLen, MaxInt));
      if(j > 0) then
      begin
        inc(j, i + TemplateFieldSignatureLen - 1);
        flen := j - i - TemplateFieldSignatureLen;
        FldName := copy(Temp, i + TemplateFieldSignatureLen, flen);
        Fld := GetTemplateField(FldName, FALSE);
        delete(Temp,i,flen + TemplateFieldSignatureLen + 1);
        delete(Result,i,flen + TemplateFieldSignatureLen + 1);
      end
      else
      begin
        delete(Temp,i,TemplateFieldSignatureLen);
        delete(Result,i,TemplateFieldSignatureLen);
        Fld := nil;
      end;
      // Get the value that was entered if there is one
      if assigned(FldValues) and (CtrlID > 0) then
      begin
        j := FldValues.IndexOfPiece(IntToStr(CtrlID));
        if not(j<0) then
          if Fld.DateType in DateComboTypes then
             NewTxt := Piece(Piece(FldValues[j],U,2),':',1)
          else
             NewTxt := Piece(FldValues[j],U,2);
      end;
      // If nothing has been entered, use the default
      if (NewTxt = '') and assigned(Fld) and
         //If this template field is a dftHyperlink or dftText that is
         //excluded (FSepLines = True) then don't get the default text
         not ((Fld.FldType in [dftHyperlink, dftText]) and Fld.SepLines) then
        NewTxt := Fld.TemplateFieldDefault;
      AddNewTxt;
    end;
  until not (i > 0);
end;

procedure TRemDlgElement.AddText(Lst: TStrings);
var
  i, ilvl: integer;
  Prompt: TRemPrompt;
  txt: string;
  FldData: TORStringList;

begin
  if (not (FReminder is TReminder)) then
    ScootOver := 4;
  try
    if Add2PN then
    begin
      ilvl := IndentPNLevel;
      if(FPNText <> '') then
        txt := FPNText
      else
      begin
        txt := FText;
        if not FReminder.FNoResolve then
          //If this is the CurrentReminderInDialog then we get the template field
          //values from the visual control in the dialog window.
          if FReminder = CurrentReminderInDialog then
             txt := ResolveTemplateFields(txt, TRUE)
          else
          //If this is not the CurrentReminderInDialog (i.e.: Next or Back button
          //has been pressed), then we have to get the template field values
          //that were saved in the element.
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
      dec(ilvl,2);
      if(assigned(FPrompts)) then
      begin
        for i := 0 to FPrompts.Count-1 do
        begin
          Prompt := TRemPrompt(FPrompts[i]);
          if(not Prompt.FIsShared) then
            begin
               if Prompt.PromptType = ptMHTest then  WordWrap(Prompt.NoteText, Lst, ilvl, 4, true)
               else WordWrap(Prompt.NoteText, Lst, ilvl);
            end;

        end;
      end;
      if(assigned(FParent) and FParent.FHasSharedPrompts) then
      begin
        for i := 0 to FParent.FPrompts.Count-1 do
        begin
          Prompt := TRemPrompt(FParent.FPrompts[i]);
          if(Prompt.FIsShared) and (Prompt.FSharedChildren.IndexOf(Self) >= 0) then
            begin
              //AGP Change MH dll
              if (Prompt.PromptType = ptMHTest) then WordWrap(Prompt.NoteText, Lst, ilvl, 4, True)
              else WordWrap(Prompt.NoteText, Lst, ilvl);
            end;
        end;
      end;
    end;
    if (assigned(FChildren)) and (FChecked or (ElemType = etDisplayOnly)) then
    begin
      for i := 0 to FChildren.Count-1 do
      begin
        TRemDlgElement(FChildren[i]).AddText(Lst);
      end;
    end;
  finally
    if (not (FReminder is TReminder)) then
      ScootOver := 0;
  end;
end;

function TRemDlgElement.AddData(Lst: TStrings; Finishing: boolean;
                                AHistorical: boolean = FALSE): integer;
var
  i, j: integer;
  OK: boolean;
  ActDt, InActDt, EncDt: double;
  RData: TRemData;

begin
  Result := 0;
//  OK := ((ElemType <> etDisplayOnly) and FChecked);
  OK := FChecked;
  if(OK and Finishing) then
    OK := (Historical = AHistorical);
  if OK then
  begin
    if(assigned(FData)) then
    begin
      if Self.Historical then
        EncDt := DateTimeToFMDateTime(Date)
      else
        EncDt := RemForm.PCEObj.VisitDateTime;
      for i := 0 to FData.Count-1 do
        begin
          RData := TRemData(FData[i]);
          if assigned(RData.FActiveDates) then
            for j := 0 to (TRemData(FData[i]).FActiveDates.Count - 1) do
              begin
                ActDt := StrToIntDef(Piece(TRemData(FData[i]).FActiveDates[j],':',1), 0);
                InActDt := StrToIntDef(Piece(TRemData(FData[i]).FActiveDates[j], ':', 2), 9999999);
                if (EncDt >= ActDt) and (EncDt <= InActDt) then
                  begin
                    inc(Result, TRemData(FData[i]).AddData(Lst, Finishing));
                    Break;
                  end;
              end
          else
            inc(Result, TRemData(FData[i]).AddData(Lst, Finishing));
        end;
    end;
  end;
  if (assigned(FChildren)) and (FChecked or (ElemType = etDisplayOnly)) then
  begin
    for i := 0 to FChildren.Count-1 do
      inc(Result, TRemDlgElement(FChildren[i]).AddData(Lst, Finishing, AHistorical));
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
  if(not FChildrenShareChecked) then
  begin
    FChildrenShareChecked := TRUE;
    if(ChildrenSharePrompts and assigned(FChildren)) then
    begin
      for i := 0 to FChildren.Count-1 do
        TRemDlgElement(FChildren[i]).GetData;
      PList := TList.Create;
      try
        EList := TList.Create;
        try
          for i := 0 to FChildren.Count-1 do
          begin
            Kid := TRemDlgElement(FChildren[i]);
//            if(Kid.ElemType <> etDisplayOnly) and (assigned(Kid.FPrompts)) then
            if(assigned(Kid.FPrompts)) then
            begin
              for j:= 0 to Kid.FPrompts.Count-1 do
              begin
                PList.Add(Kid.FPrompts[j]);
                EList.Add(Kid);
              end;
            end;
          end;
          if(PList.Count > 1) then
          begin
            for i := 0 to PList.Count-2 do
            begin
              if(assigned(EList[i])) then
              begin
                FirstMatch := TRUE;
                Prompt := TRemPrompt(PList[i]);
                for j := i+1 to PList.Count-1 do
                begin
                  if(assigned(EList[j]) and
                    (Prompt.CanShare(TRemPrompt(PList[j])))) then
                  begin
                    if(FirstMatch) then
                    begin
                      FirstMatch := FALSE;
                      if(not assigned(FPrompts)) then
                        FPrompts := TList.Create;
                      FHasSharedPrompts := TRUE;
                      Prompt.FIsShared := TRUE;
                      if(not assigned(Prompt.FSharedChildren)) then
                        Prompt.FSharedChildren := TList.Create;
                      Prompt.FSharedChildren.Add(EList[i]);
                      FPrompts.Add(PList[i]);
                      TRemDlgElement(EList[i]).FPrompts.Remove(PList[i]);
                      EList[i] := nil;
                    end;
                    Prompt.FSharedChildren.Add(EList[j]);
                    Kid := TRemDlgElement(EList[j]);
                    Kid.FPrompts.Remove(PList[j]);
                    if(Kid.FHasComment) and (Kid.FCommentPrompt = PList[j]) then
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
      for i := 0 to FChildren.Count-1 do
      begin
        Kid := TRemDlgElement(FChildren[i]);
        if(assigned(Kid.FPrompts) and (Kid.FPrompts.Count = 0)) then
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
  i,cnt: integer;
  cReq: TRDChildReq;
  Kid: TRemDlgElement;
  Prompt: TRemPrompt;
  txt, msg, Value: string;
  pt: TRemPromptType;

begin
//  if(ElemType <> etDisplayOnly) and (FChecked) and (assigned(FPrompts)) then
  if(FChecked and (assigned(FPrompts))) then
  begin
    for i := 0 to FPrompts.Count-1 do
    begin
      Prompt := TRemPrompt(FPrompts[i]);
      Value := Prompt.GetValue;
      pt := Prompt.PromptType;
      if(Prompt.PromptOK and (not Prompt.Forced) and Prompt.Required and
         (((pt<>ptWHNotPurp)and(pt<>ptWHPapResult))and
         ((Value = '') or (Value = '@')) or
         ((pt = ptVisitDate) and Prompt.FMonthReq and (StrToIntDef(copy(Value,4,2),0) = 0)) or
         ((pt in [ptVisitDate, ptVisitLocation]) and (Value = '0')))) then
      begin
        WordWrap('Element: ' + FText, List, 68, 6);
        txt := Prompt.ForcedCaption;
        if(pt = ptVisitDate) and Prompt.FMonthReq then
          txt := txt + ' (Month Required)';
        WordWrap('Item: ' + txt, List, 65, 6);
      end;
     if (Prompt.PromptOK and (not Prompt.Forced) and Prompt.Required and
          ((WHResultChk='') and (Value='')) and ((pt=ptWHPapResult) and (FData<>nil))) then
          begin
             WordWrap('Prompt: ' + Prompt.ForcedCaption, List, 65,6);
          end;
     if (Prompt.PromptOK and (not Prompt.Forced) and Prompt.Required
     and (pt=ptWHNotPurp)) and ((WHResultNot = '') and (Value = '')) then
          begin
               WordWrap('Element: ' + FText, List, 68, 6);
               WordWrap('Prompt: ' + Prompt.ForcedCaption, List, 65,6);
          end;
      //(AGP Change 24.9 add check to see if MH tests are required)
     if ((Pt = ptMHTest) or (Pt = ptGAF)) and (StrtoInt(Piece(Prompt.FData.FRec3,U,13)) > 0) and
                (not Prompt.Forced) then
        begin
          if (Piece(Prompt.FData.FRec3,U,13) = '2') and (Prompt.FMHTestComplete = 0) then break;
          if (Pt = ptMHTest) and (Prompt.FMHTestComplete = 2) then
            begin
               if ((Prompt.FValue = '') or (pos('X',Prompt.FValue)>0)) then
                  begin
                    if Prompt.FValue = '' then
                        WordWrap('MH test '+ Piece(Prompt.FData.FRec3,U,8) + ' not done',List,65,6);
                    if pos('X',Prompt.FValue)>0 then
                        WordWrap('You are missing one or more responses in the MH test '+
                               Piece(Prompt.FData.FRec3,U,8),List,65,6);
                   WordWrap(' ',List,65,6);
                  end;
            end;
          if (Pt = ptMHTest) and (Prompt.FMHTestComplete = 0) or ((Prompt.FValue = '') and (Pos('New MH dll',Prompt.FValue) = 0)) then
                  begin
                    if Prompt.FValue = '' then
                        WordWrap('MH test '+ Piece(Prompt.FData.FRec3,U,8) + ' not done',List,65,6);
                    if pos('X',Prompt.FValue)>0 then
                        WordWrap('You are missing one or more responses in the MH test '+
                               Piece(Prompt.FData.FRec3,U,8),List,65,6);
                   WordWrap(' ',List,65,6);
                  end;
          if (Pt = ptMHTest) and (Prompt.FMHTestComplete = 0) and (Pos('New MH dll',Prompt.FValue) > 0) then
            begin
              WordWrap('MH test ' + Piece(Prompt.FData.FRec3, U, 8) + ' is not complete', List, 65, 6);
              WordWrap(' ',List,65,6);
            end;
          if (Pt = ptGAF) and ((Prompt.FValue = '0') or (Prompt.FValue = '')) then
            begin
               WordWrap('GAF test must have a score greater then zero',List,65,6);
               WordWrap(' ',List,65,6);
            end;
        end;
    end;
  end;
  if (assigned(FChildren)) and (FChecked or (ElemType = etDisplayOnly)) then
  begin
    cReq := ChildrenRequired;
    if(cReq in [crOne, crAtLeastOne, crAll]) then
    begin
      cnt := 0;
      for i := 0 to FChildren.Count-1 do
      begin
        Kid := TRemDlgElement(FChildren[i]);
//        if(Kid.FChecked and (Kid.ElemType <> etDisplayOnly)) then
        if(Kid.FChecked) then
          inc(cnt);
      end;
      if(cReq = crOne) and (cnt <> 1) then
        msg := 'One selection required'
      else
      if(cReq = crAtLeastOne) and (cnt < 1) then
        msg := 'One or more selections required'
      else
      if (cReq = crAll) and (cnt < FChildren.Count) then
        msg := 'All selections are required'
      else
        msg := '';
      if(msg <> '') then
      begin
        txt := BoxCaption;
        if(txt = '') then
          txt := FText;
        WordWrap('Group: ' + txt, List, 68, 6);
        WordWrap(Msg, List, 65, 0);
        WordWrap(' ',List,68,6);    // (AGP change 24.9 added blank line for display spacing)
      end;
    end;
    for i := 0 to FChildren.Count-1 do
      TRemDlgElement(FChildren[i]).FinishProblems(List);
  end;
end;

function TRemDlgElement.IsChecked: boolean;
var
  Prnt: TRemDlgElement;

begin
  Result := TRUE;
  Prnt := Self;
  while Result and assigned(Prnt) do
  begin
    Result := ((Prnt.ElemType = etDisplayOnly) or Prnt.FChecked);
    Prnt := Prnt.FParent;
  end;
end;

//agp ICD-10 add this function to scan for valid codes against encounter date.
function TRemDlgElement.oneValidCode(Choices: TORStringList; ChoicesActiveDates: TList;
  encDt: TFMDateTime): string;
var
  C,cnt, lastItem: integer;
  Prompt: TRemPrompt;
begin
  cnt := 0;
  Result := '';
  Prompt := TRemPrompt.Create();
  lastItem := 0;
  for c := 0 to Choices.Count - 1 do
  begin
    if (Prompt.CompareActiveDate(TStringList(ChoicesActiveDates[C]), encDt) = TRUE) then
    begin
      cnt := cnt + 1;
      lastItem := c;
      if (cnt>1) then break;
    end;
  end;
  if (cnt = 1) then Result := Choices[lastItem];
end;

function TRemDlgElement.IndentChildrenInPN: boolean;
begin
  //if(Box) then
    Result := (Piece(FRec1, U, 21) = '1');
  //else
  //  Result := FALSE;
end;

function TRemDlgElement.IndentPNLevel: integer;
begin
  if(assigned(FParent)) then
  begin
    Result := FParent.IndentPNLevel;
    if(FParent.IndentChildrenInPN) then
      dec(Result,2);
  end
  else
    Result := 70;
end;

function TRemDlgElement.IncludeMHTestInPN: boolean;
begin
  Result := (Piece(FRec1, U, 9) = '0');
end;

function TRemDlgElement.ResultDlgID: string;
begin
  Result := Piece(FRec1, U, 10);
end;

procedure TRemDlgElement.setActiveDates(Choices: TORStringList; ChoicesActiveDates: TList;
  ActiveDates: TStringList);
var
  c: integer;
begin
  for c := 0 to Choices.Count - 1 do
  begin
    ActiveDates.Add(TStringList(ChoicesActiveDates[C]).CommaText)
  end;
end;

procedure TRemDlgElement.SubCommentChange(Sender: TObject);
var
  i: integer;
  txt: string;
  ok: boolean;

begin
  if(FHasSubComments and FHasComment and assigned(FCommentPrompt)) then
  begin
    ok := FALSE;
    if(assigned(Sender)) then
    begin
      with (Sender as TORCheckBox) do
        TRemPrompt(Tag).FValue := BOOLCHAR[Checked];
      ok := TRUE;
    end;
    if(not ok) then
      ok := (FCommentPrompt.GetValue = '');
    if(ok) then
    begin
      txt := '';
      for i := 0 to FPrompts.Count-1 do
      begin
        with TRemPrompt(FPrompts[i]) do
        begin
          if(PromptType = ptSubComment) and (FValue = BOOLCHAR[TRUE]) then
          begin
            if(txt <> '') then
              txt := txt + ', ';
            txt := txt + Caption;
          end;
        end;
      end;
      if(txt <> '') then
        txt[1] := UpCase(txt[1]);
      FCommentPrompt.SetValue(txt);
    end;
  end;
end;

constructor TRemDlgElement.Create;
begin
  FFieldValues := TORStringList.Create;
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
    if(idx < 0) then
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
    for i := 0 to FFieldValues.Count-1 do
    begin
      p := pos(U, FFieldValues[i]); // Can't use Piece because 2nd piece may contain ^ characters
      if(p > 0) then
      begin
        TmpSL.CommaText := copy(FFieldValues[i],p+1,MaxInt);
        FastAddStrings(TmpSL, FldData);
        TmpSL.Clear;
      end;
    end;
  finally
    TmpSL.Free;
  end;
  if (assigned(FChildren)) and (FChecked or (ElemType = etDisplayOnly)) then
    for i := 0 to FChildren.Count-1 do
      TRemDlgElement(FChildren[i]).GetFieldValues(FldData);
end;

{cause the paint event to be called and draw a focus rectangle on the TFieldPanel}
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
{cause the paint event to be called and draw the TFieldPanel without the focus rect.}
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

{Check the associated checkbox when spacebar is pressed}
procedure TRemDlgElement.FieldPanelKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = ' ' then
  begin
    FieldPanelOnClick(Sender);
    Key := #0;
  end;
end;

{So the FieldPanel will check the associated checkbox}
procedure TRemDlgElement.FieldPanelOnClick(Sender: TObject);
begin
//  if TFieldPanel(Sender).Focus then
    TORCheckBox(TDlgFieldPanel(Sender).Tag).Checked := not FChecked;
end;

{call the FieldPanelOnClick so labels on the panels will also click the checkbox}
procedure TRemDlgElement.FieldPanelLabelOnClick(Sender: TObject);
begin
  FieldPanelOnClick(TLabel(Sender).Parent); {use the parent/fieldpanel as the Sender}
end;

{ TRemData }

function TRemData.Add2PN: boolean;
begin
  Result := (Piece(FRec3, U, 5) <> '1');
end;

function TRemData.AddData(List: TStrings; Finishing: boolean): integer;
var
  i, j, k: integer;
  PCECat: TPCEDataCat;
  Primary: boolean;
  ActDt, InActDt: Double;
  EncDt: TFMDateTime;

  procedure AddPrompt(Prompt: TRemPrompt; dt: TRemDataType; var x: string);
  var
    pt: TRemPromptType;
    pnum: integer;
    Pdt: TRemDataType;
    v: TVitalType;
    rte, unt, txt: string;
    UIEN: Int64;

  begin
    pnum := -1;
    pt := Prompt.PromptType;
    if(pt = ptSubComment) or (pt = ptUnknown) then exit;
    if(pt = ptMST) then
    begin
      if (PCECat in MSTDataTypes) then
      begin
        UIEN := FParent.FReminder.PCEDataObj.Providers.PCEProvider;
        if UIEN <= 0 then
          UIEN := User.DUZ;
        SetPiece(x, U, pnumMST, Prompt.GetValue + ';' + // MST Code
                                  FloatToStr(RemForm.PCEObj.VisitDateTime) + ';' +
                                  IntToStr(UIEN) + ';' + //
                                  Prompt.FMiscText); // IEN of Exam, if any
      end;
    end
    else
    if(PCECat = pdcVital) then
    begin
      if(pt = ptVitalEntry) then
      begin
        rte := Prompt.VitalValue;
        if(rte <> '') then
        begin
          v := Prompt.VitalType;
          unt := Prompt.VitalUnitValue;
          ConvertVital(v, rte, unt);
          //txt := U + VitalCodes[v] + U + rte + U + FloatToStr(RemForm.PCEObj.VisitDateTime);  AGP Change 26.1 commented out
          txt := U + VitalCodes[v] + U + rte + U + '0'; //AGP Change 26.1 Use for Vital date/time
          if(not Finishing) then
            txt := Char(ord('A')+ord(v)) + FormatVitalForNote(txt);  // Add vital sort char
          List.AddObject(Char(ord('A')+ord(PCECat)) + txt, Self);
        end;
      end
      else
        exit;
    end
    else
    if(PCECat = pdcMH) then
    begin
      if(pt = ptMHTest) or (pt = ptGAF) then
        x := x + U + Prompt.GetValue
      else
        exit;
    end
    else
    if(pt <> ptDataList) and (ord(pt) >= ord(low(TRemPromptType))) then
    begin
      Pdt := RemPromptTypes[pt];
      if (Pdt = dt) or (Pdt = dtAll) or
         ((Pdt = dtHistorical) and assigned(Prompt.FParent) and
           Prompt.FParent.Historical) then
        pnum := FinishPromptPieceNum[pt];
      if(pnum > 0) then
      begin
        if(pt = ptPrimaryDiag) then
          SetPiece(x, U, pnum, BoolChar[Primary])
        else
          SetPiece(x, U, pnum, Prompt.GetValue);
      end;
    end;
  end;

  procedure Add(Str: string; Root: TRemPCERoot);
  var
    i, Qty: integer;
    Value, IsGAF, txt, x, Code, Nar, Cat: string;
    Skip: boolean;
    Prompt: TRemPrompt;
    dt: TRemDataType;
    TestDate: TFMDateTime;
    i1,i2: integer;

  begin
    x := '';
    dt := Code2DataType(Piece(Str, U, r3Type));
    PCECat := RemData2PCECat[dt];
    Code := Piece(Str, U, r3Code);
    if(Code = '') then
      Code := Piece(Str, U, r3Code2);
    Nar := Piece(Str, U, r3Nar);
    Cat := Piece(Str, U, r3Cat);

    Primary := FALSE;
    if(assigned(FParent) and assigned(FParent.FPrompts) and (PCECat = pdcDiag)) then
    begin
      if(FParent.Historical) then
      begin
        for i := 0 to FParent.FPrompts.Count-1 do
        begin
          Prompt := TRemPrompt(FParent.FPrompts[i]);
          if(Prompt.PromptType = ptPrimaryDiag) then
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
      if(Value = '') or ((IsGAF = '1') and (Value = '0')) then
        Skip := TRUE;
    end;

    if Finishing or (PCECat = pdcVital) then
    begin
      if(dt = dtOrder) then
        x := U + Piece(Str,U,6) + U + Piece(Str,U,11) + U + Nar
      else
      begin
        if (PCECat = pdcMH) then
        begin
          if(Skip) then
            x := ''
          else
          begin
            TestDate := Trunc(FParent.FReminder.PCEDataObj.VisitDateTime);
            if(IsGAF = '1') then
              ValidateGAFDate(TestDate);
            x := U + Nar + U + IsGAF + U + FloatToStr(TestDate) + U +
                 IntToSTr(FParent.FReminder.PCEDataObj.Providers.PCEProvider);
          end;
        end
        else
        if (PCECat <> pdcVital) then
        begin
          x := Piece(Str, U, 6);
          SetPiece(x, U, pnumCode, Code);
          SetPiece(x, U, pnumCategory, Cat);
          SetPiece(x, U, pnumNarrative, Nar);
        end;
        if(assigned(FParent)) then
        begin
          if(assigned(FParent.FPrompts)) then
          begin
            for i := 0 to FParent.FPrompts.Count-1 do
            begin
              Prompt := TRemPrompt(FParent.FPrompts[i]);
              if(not Prompt.FIsShared) then
                AddPrompt(Prompt, dt, x);
            end;
          end;
          if(assigned(FParent.FParent) and FParent.FParent.FHasSharedPrompts) then
          begin
            for i := 0 to FParent.FParent.FPrompts.Count-1 do
            begin
              Prompt := TRemPrompt(FParent.FParent.FPrompts[i]);
              if(Prompt.FIsShared) and (Prompt.FSharedChildren.IndexOf(FParent) >= 0) then
                AddPrompt(Prompt, dt, x);
            end;
          end;
        end;
      end;
      if(x <> '') then
        List.AddObject(Char(ord('A')+ord(PCECat)) + x, Self);
    end
    else
    begin
      Qty := 1;
      if(assigned(FParent) and assigned(FParent.FPrompts)) then
      begin
        if(PCECat = pdcProc) then
        begin
          for i := 0 to FParent.FPrompts.Count-1 do
          begin
            Prompt := TRemPrompt(FParent.FPrompts[i]);
            if(Prompt.PromptType = ptQuantity) then
            begin
              Qty := StrToIntDef(Prompt.GetValue, 1);
              if(Qty < 1) then Qty := 1;
              break;
            end;
          end;
        end;
      end;
      if (not Skip) then
      begin
        txt := Char(ord('A')+ord(PCECat)) +
                       GetPCEDataText(PCECat, Code, Cat, Nar, Primary, Qty);
        if(assigned(FParent) and FParent.Historical) then
          txt := txt + ' (Historical)';
        List.AddObject(txt, Self);
        inc(Result);
      end;
      if assigned(FParent) and assigned(FParent.FMSTPrompt) then
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
            if txt = MSTDescTxt[i,1] then
            begin
              List.AddObject(Char( ord('A') + ord(pdcMST)) + MSTDescTxt[i,0], Self);
              break;
            end;
        end;
      end;
    end;
  end;

begin
  Result := 0;
  if(assigned(FChoicePrompt)) and (assigned(FChoices)) then
  begin
    If not assigned(FChoicesActiveDates) then
      begin
        for i := 0 to FChoices.Count - 1 do
        begin
          if (copy(FChoicePrompt.GetValue, i+1, 1) = '1') then
            Add(FChoices[i], TRemPCERoot(FChoices.Objects[i]))
        end
      end
    else  {if there are active dates for each choice then check them}
      begin
        If Self.FParent.Historical then
          EncDt := DateTimeToFMDateTime(Date)
        else
          EncDt := RemForm.PCEObj.VisitDateTime;
        k := 0;
        for i := 0 to FChoices.Count - 1 do
        begin
          for j := 0 to (TStringList(Self.FChoicesActiveDates[i]).Count - 1) do
          begin
            ActDt := StrToIntDef((Piece(TStringList(Self.FChoicesActiveDates[i]).Strings[j], ':', 1)),0);
            InActDt := StrToIntDef((Piece(TStringList(Self.FChoicesActiveDates[i]).Strings[j], ':', 2)),9999999);
            if (EncDt >= ActDt) and (EncDt <= InActDt) then
            begin
              if(copy(FChoicePrompt.GetValue, k+1,1) = '1') then
                Add(FChoices[i], TRemPCERoot(FChoices.Objects[i]));
              inc(k);
            end; {Active date check}
          end; {FChoicesActiveDates.Items[i] loop}
        end; {FChoices loop}
      end {FChoicesActiveDates check}
  end {FChoicePrompt and FChoices check}
  else
    Add(FRec3, FPCERoot); {Active dates for this are checked in TRemDlgElement.AddData}
end;

function TRemData.Category: string;
begin
  Result := Piece(FRec3, U, r3Cat);
end;

function TRemData.DataType: TRemDataType;
begin
  Result := Code2DataType(Piece(FRec3, U, r3Type));
end;

destructor TRemData.Destroy;
var
  i: integer;

begin
  if(assigned(FPCERoot)) then
    FPCERoot.Done(Self);
  if(assigned(FChoices)) then
  begin
    for i := 0 to FChoices.Count-1 do
    begin
      if(assigned(FChoices.Objects[i])) then
        TRemPCERoot(FChoices.Objects[i]).Done(Self);
    end;
  end;
  KillObj(@FChoices);
  inherited;
end;

function TRemData.DisplayWHResults: boolean;
begin
 Result :=False;
 if FRec3<>'' then
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
    //if PromptOK then
    Result := (Piece(FRec4, U, 5) <> '1');
  if (Result=false) and (Piece(FRec4,U,4)='WH_NOT_PURP') then
    Result := True;
end;

function TRemPrompt.Caption: string;
begin
  Result := Piece(FRec4, U, 8);
  if(not FCaptionAssigned) then
  begin
    AssignFieldIDs(Result);
    SetPiece(FRec4, U, 8, Result);
    FCaptionAssigned := TRUE;
  end;
end;

constructor TRemPrompt.Create;
begin
  FOverrideType := ptUnknown;
end;

function TRemPrompt.Forced: boolean;
begin
  Result := (Piece(FRec4, U, 7) = 'F');
end;

function TRemPrompt.InternalValue: string;
var
  m, d, y: word;
  Code: string;

begin
  Result := Piece(FRec4, U, 6);
  Code := Piece(FRec4, U, 4);
  if(Code = RemPromptCodes[ptVisitDate]) then
  begin
    if(copy(Result,1,1) = MonthReqCode) then
    begin
      FMonthReq := TRUE;
      delete(Result,1,1);
    end;
    if(Result = '') then
    begin
      DecodeDate(Now, y, m, d);
      Result := inttostr(y-1700)+'0000';
      SetPiece(FRec4, U, 6, Result);
    end;
  end;
end;

procedure TRemPrompt.PromptChange(Sender: TObject);
var
  cbo: TORComboBox;
  pt: TRemPromptType;
  TmpValue, OrgValue: string;
  idx, i: integer;
  NeedRedraw: boolean;
  dte: TFMDateTime;
  whCKB: TWHCheckBox;
  //printoption: TORCheckBox;
  WHValue, WHValue1: String;
begin
  FParent.FReminder.BeginTextChanged;
  try
    FFromControl := TRUE;
    try
      TmpValue := GetValue;
      OrgValue := TmpValue;
      pt := PromptType;
      NeedRedraw := FALSE;
      case pt of
        ptComment, ptQuantity:
          TmpValue := (Sender as TEdit).Text;

        ptVisitDate:
          begin
            dte := (Sender as TORDateCombo).FMDate;
            while (dte > 2000000) and (dte > FMToday) do
            begin
              dte := dte - 10000;
              NeedRedraw := TRUE;
            end;
            TmpValue := FloatToStr(dte);
            if(TmpValue = '1000000') then
              TmpValue := '0';
          end;

        ptPrimaryDiag, ptAdd2PL, ptContraindicated:
          begin
            TmpValue := BOOLCHAR[(Sender as TORCheckBox).Checked];
            NeedRedraw := (pt = ptPrimaryDiag);
          end;

        ptVisitLocation:
          begin
            cbo := (Sender as TORComboBox);
            if(cbo.ItemIEN < 0) then
              NeedRedraw := (not cbo.DroppedDown)
            else
            begin
              if(cbo.ItemIndex <= 0) then
                cbo.Items[0] := '0' + U + cbo.text;
              TmpValue := cbo.ItemID;
              if(StrToIntDef(TmpValue,0) = 0) then
                TmpValue := cbo.Text;
            end;
          end;

        ptWHPapResult:
          begin
            if (Sender is TWHCheckBox) then
              begin
                whCKB := (Sender as TWHCheckBox);
                if whCKB.Checked = true then
                   begin
                   if whCKB.Caption ='NEM (No Evidence of Malignancy)' then FParent.WHResultChk := 'N';
                   if whCKB.Caption ='Abnormal' then FParent.WHResultChk := 'A';
                   if whCKB.Caption ='Unsatisfactory for Diagnosis' then FParent.WHResultChk := 'U';
                   //AGP Change 23.13 WH multiple processing
		   for i := 0 to FParent.FData.Count-1 do
                     begin
                        if Piece(TRemData(FParent.FData[i]).FRec3,U,4)='WHR' then
                           begin
                           FParent.FReminder.WHReviewIEN := Piece(TRemData(FParent.FData[i]).FRec3,U,6)
                           end;
                     end;
                   end
                else
                  begin
                    FParent.WHResultChk := '';
                    FParent.FReminder.WHReviewIEN := ''; //AGP CHANGE 23.13
                  end;
              end;
          end;


            ptWHNotPurp:
            begin
            if (Sender is TWHCheckBox) then
              begin
                whCKB := (Sender as TWHCheckBox);
                if whCKB.Checked = true then
                  begin
                    if whCKB.Caption ='Letter' then
                      begin
                        if FParent.WHResultNot='' then FParent.WHResultNot := 'L'
                        else
                          if Pos('L',FParent.WHResultNot)=0 then FParent.WHResultNot := FParent.WHResultNot +':L';
                        if whCKB.FButton <> nil then whCKB.FButton.Enabled := true;
                        if whCKB.FPrintNow <> nil then
                           begin
                             whCKB.FPrintVis :='1';
                             whCKB.FPrintNow.Enabled := true;
                           end;
                      end;
                    if whCKB.Caption ='In-Person' then
                       begin
                         if FParent.WHResultNot='' then FParent.WHResultNot := 'I'
                         else
                            if Pos('I',FParent.WHResultNot)=0 then FParent.WHResultNot := FParent.WHResultNot+':I';
                       end;
                    if whCKB.Caption ='Phone Call' then
                       begin
                         if FParent.WHResultNot='' then FParent.WHResultNot := 'P'
                         else
                           if Pos('P',FParent.WHResultNot)=0 then FParent.WHResultNot := FParent.WHResultNot+':P';
                        end;
                end
                else
                   begin
                     // this section is to handle unchecking of boxes and disabling print now and view button
                     WHValue := FParent.WHResultNot;
                       if whCKB.Caption ='Letter' then
                         begin
                           for i:=1 to Length(WHValue) do
                             begin
                              if WHValue1='' then
                                begin
                                  if (WHValue[i]<>'L') and (WHValue[i]<>':') then WHValue1 := WHValue[i];
                                end
                              else
                                if (WHValue[i]<>'L') and (WHValue[i]<>':') then WHValue1 := WHValue1+':'+WHValue[i];
                             end;
                         if (whCKB.FButton <> nil) and (whCKB.FButton.Enabled = true) then whCKB.FButton.Enabled := false;
                         if (whCKB.FPrintNow <> nil) and (whCKB.FPrintNow.Enabled = true) then
                            begin
                              whCKB.FPrintVis := '0';
                              if whCKB.FPrintNow.Checked = true then whCKB.FPrintNow.Checked := false;
                              whCKB.FPrintNow.Enabled := false;
                              FParent.WHPrintDevice := '';
                            end;
                         end;
                       if whCKB.Caption ='In-Person' then
                         begin
                           for i:=1 to Length(WHValue) do
                             begin
                               if WHValue1='' then
                                 begin
                                   if (WHValue[i]<>'I') and (WHValue[i]<>':') then WHValue1 := WHValue[i];
                                 end
                               else
                                 if (WHValue[i]<>'I') and (WHValue[i]<>':') then WHValue1 := WHValue1+':'+WHValue[i];
                             end;
                         end;
                       if whCKB.Caption ='Phone Call' then
                          begin
                            for i:=1 to Length(WHValue) do
                              begin
                                if WHValue1='' then
                                  begin
                                    if (WHValue[i]<>'P') and (WHValue[i]<>':') then WHValue1 := WHValue[i];
                                  end
                                else
                                  if (WHValue[i]<>'P') and (WHValue[i]<>':') then WHValue1 := WHValue1+':'+WHValue[i];
                              end;
                          end;
                     FParent.WHResultNot := WHValue1;
                   end;
                end
                else
                    if ((Sender as TORCheckBox)<>nil) and (Piece(FRec4,U,12)='1') then
                       begin
                          if (((Sender as TORCheckBox).Caption = 'Print Now') and
                             ((Sender as TORCheckBox).Enabled =true)) and ((Sender as TORCheckBox).Checked = true) and
                             (FParent.WHPrintDevice ='') then
                                begin
                                  FParent.WHPrintDevice := SelectDevice(Self, Encounter.Location, false, 'Women Health Print Device Selection');
                                  FPrintNow :='1';
                                  if FParent.WHPrintDevice ='' then
                                    begin
                                      FPrintNow :='0';
                                      (Sender as TORCheckBox).Checked := false;
                                    end;
                                end;
                          if (((Sender as TORCheckBox).Caption = 'Print Now') and
                             ((Sender as TORCheckBox).Enabled =true)) and ((Sender as TORCheckBox).Checked = false) then
                                begin
                                   FParent.WHPrintDevice := '';
                                   FPrintNow :='0';
                                end;
                       end;
        end;

        ptExamResults, ptSkinResults, ptLevelSeverity,
        ptSeries, ptReaction, ptLevelUnderstanding, ptSkinReading: //(AGP Change 26.1)
          TmpValue := (Sender as TORComboBox).ItemID;
        else
          if pt = ptVitalEntry then
          begin
            case (Sender as TControl).Tag of
              TAG_VITTEMPUNIT, TAG_VITHTUNIT, TAG_VITWTUNIT: idx := 2;
              TAG_VITPAIN: begin
                             idx := -1;
                             TmpValue := (Sender as TORComboBox).ItemID;
                             if FParent.VitalDateTime = 0 then
                                  FParent.VitalDateTime := FMNow;
                           end;
              else
                idx := 1;
            end;
            if(idx > 0) then
              begin
                 //AGP Change 26.1 change Vital time/date to Now instead of encounter date/time
                 SetPiece(TmpValue, ';', idx, TORExposedControl(Sender).Text);
                 if (FParent.VitalDateTime > 0) and (TORExposedControl(Sender).Text = '') then
                       FParent.VitalDateTime := 0;
                 if (FParent.VitalDateTime = 0) and (TORExposedControl(Sender).Text <> '') then
                       FParent.VitalDateTime := FMNow;
              end;
          end
          else
          if pt = ptDataList then
          begin
            TmpValue := (Sender as TORComboBox).CheckedString;
            NeedRedraw := TRUE;
          end
          else
          if (pt = ptGAF) and (MHDLLFound = false) then
            TmpValue := (Sender as TEdit).Text;
      end;
      if(TmpValue <> OrgValue) then
      begin
        if NeedRedraw then
          FParent.FReminder.BeginNeedRedraw;
        try
          SetValue(TmpValue);
        finally
          if NeedRedraw then
            FParent.FReminder.EndNeedRedraw(Self);
        end;
      end
      else
      if NeedRedraw then
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
  if(FParent.ElemType = etDisplayOnly) and (not assigned(FParent.FParent)) then
    RemindersInProcess.Notifier.Notify;
end;


procedure TRemPrompt.ComboBoxKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if(Key = VK_RETURN) and (Sender is TORComboBox) and
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
    (pt = ptGAF) or (pt = ptWHPapResult) then
    Result := TRUE
  else if (pt = ptSubComment) then
    Result := FParent.FHasComment
  else
  begin
    dt := RemPromptTypes[PromptType];
    if (dt = dtAll) then
      Result := TRUE
    else if (dt = dtUnknown) then
      Result := FALSE
    else if (dt = dtHistorical) then
      Result := FParent.Historical
    //hanlde combo box prompts that are not assocaite with codes
    else if ( dt <> dtProcedure) and (dt <> dtDiagnosis) then
      begin
         Result := FALSE;
         if(assigned(FParent.FData)) then
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
              encDate := TRemData(FParent.FData[i]).FParent.FReminder.FPCEDataObj.DateTime;
              if (RemDataActive(TRemData(FParent.FData[i]), encDate) = TRUE)
              then
                Result := TRUE;
              break;
            end
//            else if (Assigned(TRemData(FParent.FData[i]).FChoices) and (TRemData(FParent.FData[i]).FChoices <> nil)) then
            else if Assigned(TRemData(FParent.FData[i]).FChoices) then
            begin
              encDate := TRemData(FParent.FData[i]).FParent.FReminder.FPCEDataObj.DateTime;
              for C := 0 to TRemData(FParent.FData[i]).FChoices.Count - 1 do
              begin
                if (CompareActiveDate(TStringList(TRemData(FParent.FData[i]).FChoicesActiveDates[C]), encDate) = TRUE) then
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
  if(assigned(FData)) then
    Result := FOverrideType
  else
    Result := Code2PromptType(Piece(FRec4, U, 4));
end;


function TRemPrompt.Required: boolean;
var
  pt: TRemPromptType;

begin
  pt := PromptType;
  if(pt = ptVisitDate) then
    Result := TRUE
  else
  if(pt = ptSubComment) then
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
  cnt, i, j, k: integer;
  ActDt, InActDt: Double;
  EncDt: TFMDateTime;

begin
  Result := '';
  if Add2PN then
  begin
    pt := PromptType;
    tmp := GetValue;
    case pt of
      ptComment: Result := tmp;

      ptQuantity: if(StrToIntDef(tmp,1) <> 1) then
                    Result := tmp;

     (* ptSkinReading: if(StrToIntDef(tmp,0) <> 0) then
                       Result := tmp;  *)

     ptSkinReading:   // (AGP Change 26.1)
       begin
         Result := tmp;
       end;

      ptVisitDate:
        begin
          try
            if(tmp <> '') and (tmp <> '0') and (length(Tmp) = 7) then
            begin
              dateStr := '';
              if FMonthReq and (copy(tmp,4,2) = '00') then
                Result := ''
              else
              begin
                if(copy(tmp,4,4) = '0000') then
                  begin
                    fmt := 'YYYY';
                    dateStr := ' – Exact date is unknown';
                  end
                else
                if(copy(tmp,6,2) = '00') then
                  begin
                    fmt := 'MMMM, YYYY';
                    dateStr := ' – Exact date is unknown';
                  end
                else
                  fmt := 'MMMM D, YYYY';
                if dateStr = '' then Result := FormatFMDateTimeStr(fmt, tmp)
                else Result := FormatFMDateTimeStr(fmt, tmp) + ' ' + dateStr;
              end;
            end;
          except
            on EConvertError do
              Result := tmp
            else
              raise;
          end;
        end;

      ptPrimaryDiag, ptAdd2PL, ptContraindicated:
        if(tmp = '1') then
          Result := ' ';

      ptVisitLocation:
        if(StrToIntDef(tmp, 0) = 0) then
        begin
          if(tmp <> '0') then
            Result := tmp;
        end
        else
          begin
          Result := GetPCEDisplayText(tmp, ComboPromptTags[pt]);
        end;

      ptWHPapResult:
        begin
         if Fparent.WHResultChk='N' then Result := 'NEM (No Evidence of Malignancy)';
         if Fparent.WHResultChk='A' then Result := 'Abnormal';
         if Fparent.WHResultChk='U' then Result := 'Unsatisfactory for Diagnosis';
         if FParent.WHResultChk='' then Result := '';
        end;

      ptWHNotPurp:
      begin
      if FParent.WHResultNot <> '' then
      begin
      WHValue := FParent.WHResultNot;
      //IF Forced = false then
      //begin
      if WHValue <> 'CPRS' then
      begin
      for cnt := 1 to Length(WHValue) do
          begin
          if Result ='' then
             begin
              if WHValue[cnt]='L' then Result := 'Letter';
              if WHValue[cnt]='I' then Result := 'In-Person';
              if WHValue[cnt]='P' then Result := 'Phone Call';
              end
          else
              begin
              if (WHValue[cnt]='L')and(Pos('Letter',Result)=0) then Result := Result+'; Letter';
              if (WHValue[cnt]='I')and(Pos('In-Person',Result)=0) then Result := Result+'; In-Person';
              if (WHValue[cnt]='P')and(Pos('Phone Call',Result)=0) then Result := Result+'; Phone Call';
              end;
          end;
       end;
      end
      else
      if Forced = true then
         begin
         if pos(':',Piece(FRec4,U,6))=0 then
           begin
           if Piece(FRec4,U,6)='L' then
             begin
             Result := 'Letter';
             FParent.WHResultNot :='L';
             end;
           if Piece(FRec4,U,6)='I' then
              begin
              Result := 'In-Person';
              FParent.WHResultNot := 'I';
              end;
           if Piece(FRec4,U,6)='P' then
              begin
              Result := 'Phone Call';
              FParent.WHResultNot := 'P';
              end;
           if Piece(FRec4,U,6)='CPRS' then
              begin
              Result := '';
              FParent.WHResultNot := 'CPRS';
              end;
           end
           else
           begin
           WHValue := Piece(FRec4,U,6);
           for cnt := 0 to Length(WHValue) do
          begin
          if Result ='' then
             begin
              if WHValue[cnt]='L' then
                begin
                Result := 'Letter';
                FParent.WHResultNot := WHValue[cnt];
                end;
              if WHValue[cnt]='I' then
                begin
                Result := 'In-Person';
                FParent.WHResultNot := WHValue[cnt];
                end;
              if WHValue[cnt]='P' then
                begin
                Result := 'Phone Call';
                FParent.WHResultNot := WHValue[cnt];
                end;
              end
          else
              begin
              if (WHValue[cnt]='L')and(Pos('Letter',Result)=0) then
                 begin
                 Result := Result +'; Letter';
                 FParent.WHResultNot := FParent.WHResultNot + ':' + WHValue[cnt];
                 end;
              if (WHValue[cnt]='I')and(Pos('In-Person',Result)=0) then
                 begin
                 Result := Result +'; In-Person';
                 FParent.WHResultNot := FParent.WHResultNot + ':' + WHValue[cnt];
                 end;
              if (WHValue[cnt]='P')and(Pos('Phone Call',Result)=0) then
                 begin
                 Result := Result +'; Phone Call';
                 FParent.WHResultNot := FParent.WHResultNot + ':' + WHValue[cnt];
                 end;
              end;
          end;

         end;
      end
      else
      Result := '';
    end;

      ptExamResults, ptSkinResults, ptLevelSeverity,
      ptSeries, ptReaction, ptLevelUnderstanding:
        begin
          Result := tmp;
          if(Piece(Result,U,1) = '@') then
            Result := ''
          else
            Result := GetPCEDisplayText(tmp, ComboPromptTags[pt]);
        end;

      else
      begin
        if pt = ptDataList then
        begin
          if(assigned(FData) and assigned(FData.FChoices)) then
          begin
            if not(assigned(FData.FChoicesActiveDates)) then
              for i := 0 to FData.FChoices.Count - 1 do
                begin
                  if(copy(tmp,i+1,1) = '1') then
                    begin
                      if (Result <> '') then
                        Result := Result + ', ';
                      Result := Result + Piece(FData.FChoices[i],U,12);
                    end;
                end
            else   {if there are active dates for each choice then check them}
              begin
                if Self.FParent.Historical then
                  EncDt := DateTimeToFMDateTime(Date)
                else
                  EncDt := RemForm.PCEObj.VisitDateTime;
                k := 0;
                for i := 0 to FData.FChoices.Count - 1 do
                begin
                  for j := 0 to (TStringList(FData.FChoicesActiveDates[i]).Count - 1) do
                  begin
                    ActDt := StrToIntDef((Piece(TStringList(FData.FChoicesActiveDates[i]).Strings[j], ':', 1)),0);
                    InActDt := StrToIntDef((Piece(TStringList(FData.FChoicesActiveDates[i]).Strings[j], ':', 2)),9999999);
                    if (EncDt >= ActDt) and (EncDt <= InActDt) then
                    begin
                      if(copy(tmp,k+1,1) = '1') then
                      begin
                        if(Result <> '') then
                          Result := Result + ', ';
                        Result := Result + Piece(FData.FChoices[i],U,12);
                      end;
                      inc(k);
                    end;  {ActiveDate check}
                  end;  {FChoicesActiveDates.Items[i] loop}
                end;  {FChoices loop}
            end;
          end;
        end
        else
        if pt = ptVitalEntry then
        begin
          Result := VitalValue;
          if(Result <> '') then
            Result := ConvertVitalData(Result, VitalType, VitalUnitValue);
        end
        else
        if pt = ptMHTest then
          Result := FMiscText
        else
        if (pt = ptGAF) and (MHDLLFound = false) then
        begin
          if(StrToIntDef(Piece(tmp, U, 1),0) <> 0) then
          begin
            Result := tmp;
          end
        end
        else
        if pt = ptMHTest then
          Result := FMiscText;

            (*
            GafDate := Trunc(FParent.FReminder.PCEDataObj.VisitDateTime);
            ValidateGAFDate(GafDate);
            Result := tmp + CRCode + 'Date Determined: ' + FormatFMDateTime('mm/dd/yyyy', GafDate) +
                            CRCode + 'Determined By: ' + FParent.FReminder.PCEDataObj.Providers.PCEProviderName;
            *)
          //end;
        end;
      end;
    end;
    if(Result <> '') and (Caption <> '') then
      Result := Trim(Caption + ' ' + Trim(Result));
  //end;
end;

function TRemPrompt.CanShare(Prompt: TRemPrompt): boolean;
var
  pt: TRemPromptType;

begin
  if(Forced or Prompt.Forced or Prompt.FIsShared or Required or Prompt.Required) then
    Result := FALSE
  else
  begin
    pt := PromptType;
    Result := (pt = Prompt.PromptType);
    if(Result) then
    begin
      if(pt in [ptAdd2PL, ptLevelUnderstanding]) or
        ((pt = ptComment) and (not FParent.FHasSubComments)) then
        Result := ((Add2PN = Prompt.Add2PN) and
                   (Caption = Prompt.Caption))
      else
        Result := FALSE;
    end;
  end;
end;

destructor TRemPrompt.Destroy;
begin
  KillObj(@FSharedChildren);
  inherited;
end;

function TRemPrompt.RemDataActive(RData: TRemData; EncDt: TFMDateTime):Boolean;
//var
//  ActDt, InActDt: Double;
//  j: integer;

begin
//  Result := FALSE;
  if assigned(RData.FActiveDates) then Result := CompareActiveDate(RData.FActiveDates, EncDt)
  //agp ICD-10 move code to it own function to reuse the comparison in other parts of dialogs
//    for j := 0 to (RData.FActiveDates.Count - 1) do
//      begin
//        ActDt := StrToIntDef(Piece(RData.FActiveDates[j],':',1), 0);
//        InActDt := StrToIntDef(Piece(RData.FActiveDates[j], ':', 2), 9999999);
//        if (EncDt >= ActDt) and (EncDt <= InActDt) then
//          begin
//            Result := TRUE;
//            Break;
//          end;
//      end
  else
    Result := TRUE;
end;

//agp ICD-10 code was imported from  RemDataActive
function TRemPrompt.CompareActiveDate(ActiveDates: TStringList; EncDt: TFMDateTime): Boolean;
  var
  ActDt, InActDt: Double;
  j: integer;
begin
  Result := FALSE;
  for j := 0 to (ActiveDates.Count - 1) do
  begin
    ActDt := StrToIntDef(Piece(ActiveDates[j], ':', 1), 0);
    InActDt := StrToIntDef(Piece(ActiveDates[j], ':', 2), 9999999);
    if (EncDt >= ActDt) and (EncDt <= InActDt) then
    begin
      Result := TRUE;
      break;
    end;
  end
end;

function TRemPrompt.RemDataChoiceActive(RData: TRemData; j: integer; EncDt: TFMDateTime):Boolean;
var
  ActDt, InActDt: Double;
  i: integer;
begin
  Result := FALSE;
  If not assigned(RData.FChoicesActiveDates) then //if no active dates were sent
    Result := TRUE                               //from the server then don't check dates
  else  {if there are active dates for each choice then check them}
    begin
      for i := 0 to (TStringList(RData.FChoicesActiveDates[j]).Count - 1) do
        begin
          ActDt := StrToIntDef((Piece(TStringList(RData.FChoicesActiveDates[j]).Strings[i], ':', 1)),0);
          InActDt := StrToIntDef((Piece(TStringList(RData.FChoicesActiveDates[j]).Strings[i], ':', 2)),9999999);
          if (EncDt >= ActDt) and (EncDt <= InActDt) then
          begin
            Result := True;
          end; {Active date check}
        end; {FChoicesActiveDates.Items[i] loop}
    end {FChoicesActiveDates check}
end;

function TRemPrompt.GetValue: string;
//Returns TRemPrompt.FValue if this TRemPrompt is not a ptPrimaryDiag
//Returns 0-False or 1-True if this TRemPrompt is a ptPrimaryDiag
var
  i, j, k: integer;
  RData: TRemData;
  Ok: boolean;
  EncDt:  TFMDateTime;

begin
  OK := (Piece(FRec4, U, 4) = RemPromptCodes[ptPrimaryDiag]);
  if(OK) and (assigned(FParent)) then
    OK := (not FParent.Historical);
  if OK then
  begin
    Ok := FALSE;
    if(assigned(FParent) and assigned(FParent.FData)) then {If there's FData, see if}
    begin                                                  {there's a primary diagnosis}
      for i := 0 to FParent.FData.Count-1 do               {if there is return True}
      begin
        EncDt := RemForm.PCEObj.VisitDateTime;
        RData := TRemData(FParent.FData[i]);
        if(RData.DataType = dtDiagnosis) then
        begin
          if(assigned(RData.FPCERoot)) and (RemDataActive(RData, EncDt)) then
            Ok := (RData.FPCERoot = PrimaryDiagRoot)
          else
          if(assigned(RData.FChoices)) and (assigned(RData.FChoicePrompt)) then
          begin
            k := 0;
            for j := 0 to RData.FChoices.Count-1 do
            begin
             if RemDataChoiceActive(RData, j, EncDt) then
             begin
              if(assigned(RData.FChoices.Objects[j])) and
                (copy(RData.FChoicePrompt.FValue,k+1,1)='1') then
              begin
                if(TRemPCERoot(RData.FChoices.Objects[j]) = PrimaryDiagRoot) then
                begin
                  Ok := TRUE;
                  break;
                end;
              end; //if FChoices.Objects (which is the RemPCERoot object) is assigned
              inc(k);
             end; //if FChoices[j] is active
            end; //loop through FChoices
          end; //If there are FChoices and an FChoicePrompt (i.e.: is this a ptDataList}
        end;
        if Ok then break;
      end;
    end;
    Result := BOOLCHAR[Ok];
  end
  else
    Result := FValue;
end;



procedure TRemPrompt.SetValue(Value: string);
var
  pt: TRemPromptType;
  i, j, k : integer;
  RData: TRemData;
  Primary, Done: boolean;
  Tmp: string;
  OK, NeedRefresh: boolean;
  EncDt:  TFMDateTime;

begin
  NeedRefresh := (not FFromControl);
  if(Forced and (not FFromParent)) then exit;
  pt := PromptType;
  if(pt = ptVisitDate) then
  begin
    if(Value = '') then
      Value := '0'
    else
    begin
      try
        if(StrToFloat(Value) > FMToday) then
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
      if(Value = '0') then
        NeedRefresh := TRUE;
    end;
  end;
  if(GetValue <> Value) or (FFromParent) then
  begin
    FValue := Value;
    EncDt := RemForm.PCEObj.VisitDateTime;
    if((pt = ptExamResults) and assigned(FParent) and assigned(FParent.FData) and
       (FParent.FData.Count > 0) and assigned(FParent.FMSTPrompt)) then
    begin
      FParent.FMSTPrompt.SetValueFromParent(Value);
      if (FParent.FMSTPrompt.FMiscText = '') then
      // Assumes first finding item is MST finding
        FParent.FMSTPrompt.FMiscText := TRemData(FParent.FData[0]).InternalValue;
    end;

    OK := (assigned(FParent) and assigned(FParent.FData) and
          (Piece(FRec4, U, 4) = RemPromptCodes[ptPrimaryDiag]));
    if (OK = false) and (Value = 'New MH dll') then OK := true;
    if OK then
      OK := (not FParent.Historical);
    if OK then
    begin
      Done := FALSE;
      Primary := (Value = BOOLCHAR[TRUE]);
      for i := 0 to FParent.FData.Count-1 do
      begin
        RData := TRemData(FParent.FData[i]);
        if(RData.DataType = dtDiagnosis) then
        begin
          if(assigned(RData.FPCERoot)) and (RemDataActive(RData, EncDt)) then
          begin
            if(Primary) then
            begin
              PrimaryDiagRoot := RData.FPCERoot;
              Done := TRUE;
            end
            else
            begin
              if(PrimaryDiagRoot = RData.FPCERoot) then
              begin
                PrimaryDiagRoot := nil;
                Done := TRUE;
              end;
            end;
          end
          else
          if(assigned(RData.FChoices)) and (assigned(RData.FChoicePrompt)) then
          begin
            k := 0;
            for j := 0 to RData.FChoices.Count-1 do
            begin
             if RemDataChoiceActive(RData, j, EncDt) then
             begin
              if(Primary) then
              begin
                if(assigned(RData.FChoices.Objects[j])) and
                  (copy(RData.FChoicePrompt.FValue,k+1,1)='1') then
                begin
                  PrimaryDiagRoot := TRemPCERoot(RData.FChoices.Objects[j]);
                  Done := TRUE;
                  break;
                end;
              end
              else
              begin
                if(assigned(RData.FChoices.Objects[j])) and
                  (PrimaryDiagRoot = TRemPCERoot(RData.FChoices.Objects[j])) then
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
        if Done then break;
      end;
    end;
    if(assigned(FParent) and assigned(FParent.FData) and IsSyncPrompt(pt)) then
    begin
      for i := 0 to FParent.FData.Count-1 do
      begin
        RData := TRemData(FParent.FData[i]);
        if(assigned(RData.FPCERoot)) and (RemDataActive(RData, EncDt)) then
          RData.FPCERoot.Sync(Self);
        if(assigned(RData.FChoices)) then
        begin
          for j := 0 to RData.FChoices.Count-1 do
          begin
            if(assigned(RData.FChoices.Objects[j])) and
                      RemDataChoiceActive(RData, j, EncDt) then
              TRemPCERoot(RData.FChoices.Objects[j]).Sync(Self);
          end;
        end;
      end;
    end;
  end;
  if(not NeedRefresh) then
    NeedRefresh := (GetValue <> Value);
  if(NeedRefresh and assigned(FCurrentControl) and FParent.FReminder.Visible) then
  begin
    case pt of
      ptComment:
        (FCurrentControl as TEdit).Text := GetValue;

      ptQuantity:
        (FCurrentControl as TUpDown).Position := StrToIntDef(GetValue,1);

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

      ptPrimaryDiag, ptAdd2PL, ptContraindicated:
        (FCurrentControl as TORCheckBox).Checked := (GetValue = BOOLCHAR[TRUE]);

      ptVisitLocation:
        begin
          Tmp := GetValue;
          with (FCurrentControl as TORComboBox) do
          begin
            if(piece(Tmp,U,1)= '0') then
            begin
              Items[0] := Tmp;
              SelectByID('0');
            end
            else
              SelectByID(Tmp);
          end;
        end;

      ptWHPapResult:
        (FCurrentControl as TORCheckBox).Checked := (GetValue = BOOLCHAR[TRUE]);

       ptWHNotPurp:
        (FCurrentControl as TORCheckBox).Checked := (GetValue = BOOLCHAR[TRUE]);

      ptExamResults, ptSkinResults, ptLevelSeverity,
      ptSeries, ptReaction, ptLevelUnderstanding, ptSkinReading: //(AGP Change 26.1)
        (FCurrentControl as TORComboBox).SelectByID(GetValue);

      else
        if(pt = ptVitalEntry) then
        begin
          if(FCurrentControl is TORComboBox) then
            (FCurrentControl as TORComboBox).SelectByID(VitalValue)
          else
          if(FCurrentControl is TVitalEdit) then
          begin
            with (FCurrentControl as TVitalEdit) do
            begin
              Text := VitalValue;
              if(assigned(LinkedCombo)) then
              begin
                Tmp := VitalUnitValue;
                if(Tmp <> '') then
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
  if(ord(pt) >= ord(low(TRemPromptType))) and (ComboPromptTags[pt] <> 0) then
  begin
    TempSL := TORStringList.Create;
    try
      GetPCECodes(TempSL, ComboPromptTags[pt]);
      idx := TempSL.CaseInsensitiveIndexOfPiece(Value, U, 1);
      if(idx < 0) then
        idx := TempSL.CaseInsensitiveIndexOfPiece(Value, U, 2);
      if(idx >= 0) then
        Value := Piece(TempSL[idx],U,1);
    finally
      TempSL.Free;
    end;
  end;
  if((not Forced) and assigned(FParent) and assigned(FParent.FData) and IsSyncPrompt(pt)) then
  begin
    Found := FALSE;
    for i := 0 to FParent.FData.Count-1 do
    begin
      RData := TRemData(FParent.FData[i]);
      if(assigned(RData.FPCERoot)) then
        Found := RData.FPCERoot.GetValue(pt, Value);
      if(not Found) and (assigned(RData.FChoices)) then
      begin
        for j := 0 to RData.FChoices.Count-1 do
        begin
          if(assigned(RData.FChoices.Objects[j])) then
          begin
            Found := TRemPCERoot(RData.FChoices.Objects[j]).GetValue(pt, Value);
            if(Found) then break;
          end;
        end;
      end;
      if(Found) then break;
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
  if(Result = '') then
  begin
    pt := PromptType;
    if(pt = ptDataList) then
    begin
      if(assigned(FData)) then
      begin
        if(FData.DataType = dtDiagnosis) then
          Result := 'Diagnosis'
        else
        if(FData.DataType = dtProcedure) then
          Result := 'Procedure';
      end;
    end
    else
    if(pt = ptVitalEntry) then
      Result := VitalDesc[VitalType] + ':'
    else
    if(pt = ptMHTest) then
      Result := 'Perform ' + FData.Narrative
    else
    if(pt = ptGAF) then
      Result := 'GAF Score'
    else
      Result := PromptDescriptions[pt];
    if(Result = '') then Result := 'Prompt';
  end;
  if(copy(Result,length(Result),1) = ':') then
    delete(Result,length(Result),1);
end;

function TRemPrompt.VitalType: TVitalType;
begin
  Result := vtUnknown;
  if(assigned(FData)) then
    Result := Code2VitalType(FData.InternalValue);
end;

procedure TRemPrompt.VitalVerify(Sender: TObject);
var
  vEdt: TVitalEdit;
  vCbo: TVitalComboBox;
  AObj: TWinControl;

begin
  if(Sender is TVitalEdit) then
  begin
    vEdt := TVitalEdit(Sender);
    vCbo := vEdt.LinkedCombo;
  end
  else
  if(Sender is TVitalComboBox) then
  begin
    vCbo := TVitalComboBox(Sender);
    vEdt := vCbo.LinkedEdit;
  end
  else
  begin
    vCbo := nil;
    vEdt := nil;
  end;
  AObj := Screen.ActiveControl;
  if((not assigned(AObj)) or ((AObj <> vEdt) and (AObj <> vCbo))) then
  begin
    if(vEdt.Tag = TAG_VITHEIGHT) then
      vEdt.Text := ConvertHeight2Inches(vEdt.Text);
    if VitalInvalid(vEdt, vCbo) then
      vEdt.SetFocus;
  end;
end;

function TRemPrompt.VitalUnitValue: string;
var
  vt: TVitalType;

begin
  vt := VitalType;
  if (vt in [vtTemp, vtHeight, vtWeight]) then
  begin
    Result := Piece(GetValue,';',2);
    if(Result = '') then
    begin
      case vt of
        vtTemp:   Result := 'F';
        vtHeight: Result := 'IN';
        vtWeight: Result := 'LB';
      end;
      SetPiece(FValue, ';', 2, Result);
    end;
  end
  else
    Result := '';
end;

function TRemPrompt.VitalValue: string;
begin
  Result := Piece(GetValue,';',1);
end;

procedure TRemPrompt.DoWHReport(Sender: TObject);
Var
comp, ien: string;
i: integer;
begin
   for i := 0 to FParent.FData.Count-1 do
      begin
        comp:= Piece(TRemData(FParent.FData[i]).FRec3,U,4);
        ien:= Piece(TRemData(FParent.FData[i]).FRec3,U,6);
      end;
    CallV('ORQQPXRM GET WH REPORT TEXT', [ien]);
    ReportBox(RPCBrokerV.Results,'Procedure Report Results',True);
end;

procedure TRemPrompt.ViewWHText(Sender: TObject);
var
WHRecNum, WHTitle: string;
i: integer;
begin
  for i := 0 to FParent.FData.Count-1 do
     begin
     if Piece(TRemData(FParent.FData[i]).FRec3,U,4)='WH' then
        begin
        WHRecNum:=(Piece(TRemData(FParent.FData[i]).FRec3,U,6));
        WHTitle :=(Piece(TRemData(FParent.FData[i]).FRec3,U,8));
        end;
     end;
  CallV('ORQQPXRM GET WH LETTER TEXT', [WHRecNum]);
  ReportBox(RPCBrokerV.Results,'Women Health Notification Purpose: '+WHTitle,false);
end;

procedure TRemPrompt.DoMHTest(Sender: TObject);
var
  TmpSL, tmpScores, tmpResults: TStringList;
  i, TestComp: integer;
  Before, After, Score: string;
  MHRequired: boolean;

begin
  TestComp := 0;
  try
  if (Sender is TCPRSDialogButton) then
    (Sender as TCPRSDialogButton).Enabled := false;
  if FParent.FReminder.MHTestArray = nil then FParent.FReminder.MHTestArray := TORStringList.Create;
  if(MHTestAuthorized(FData.Narrative)) then
  begin
    FParent.FReminder.BeginTextChanged;
    try
      if(FParent.IncludeMHTestInPN) then
        TmpSL := TStringList.Create
      else
        TmpSL := nil;
      if Piece(self.FData.FRec3,U,13) = '1' then MHRequired := True
      else MHRequired := false;
      Before := GetValue;
      After := PerformMHTest(Before, FData.Narrative, TmpSL, MHRequired);
      if uinit.TimedOut then After := '';
      if Piece(After, U, 1) = 'New MH dll' then
        begin
          if Piece(After,U,2)='COMPLETE' then
          begin
            FParent.FReminder.MHTestArray.Add(FData.Narrative + U + FParent.FReminder.IEN);
            self.FMHTestComplete := 1;
            Score := Piece(After,U,3);
            if FParent.ResultDlgID <> '' then
              begin
                tmpScores := TStringList.Create;
                tmpResults := TStringList.Create;
                PiecestoList(copy(score,2,Length(score)),'*',tmpScores);
                PiecestoList(FParent.ResultDlgID,'~',tmpResults);
                GetMHResultText(FMiscText, tmpResults, tmpScores);
                if tmpScores <> nil then tmpScores.Free;
                if tmpResults <> nil then tmpResults.Free;
              end;
            if (FMiscText <> '') then FMiscText := FMiscText + '~<br>';
            if tmpSL <> nil then
              begin
                for i := 0 to TmpSL.Count-1 do
                  begin
                    if(i > 0) then FMiscText := FMiscText + CRCode;
                    FMiscText := FMiscText + TmpSL[i];
                  end;
              end;
          //end;
            //ExpandTIUObjects(FMiscText);
          end
          else if Piece(After,U,2)='INCOMPLETE' then
            begin
               FParent.FReminder.MHTestArray.Add(FData.Narrative + U + FParent.FReminder.IEN);
               self.FMHTestComplete := 2;
               FMiscText := '';
               After := 'X';
            end
          else if Piece(After,U,2)='CANCELLED' then
            begin
               self.FMHTestComplete := 0;
               FMiscText := '';
               After := '';
            end;
          SetValue(After);
          exit;
        end;
      if pos(U,After)>0 then
        begin
          TestComp := StrtoInt(Piece(After,U,2));
          self.FMHTestComplete := TestComp;
          After := Piece(After,U,1);
        end;
      if(Before <> After) and (not uInit.TimedOut) then
      begin
        if(After = '') or (FParent.ResultDlgID = '') then
          FMiscText := ''
        else
        if TestComp > 0 then
        begin
          MentalHealthTestResults(FMiscText, FParent.ResultDlgID, FData.Narrative,
                                  FParent.FReminder.FPCEDataObj.Providers.PCEProvider, After);
          if(assigned(TmpSL) and (TmpSL.Count > 0)) then
          begin
            if(FMiscText <> '') then
              FMiscText := FMiscText + CRCode + CRCode;
            for i := 0 to TmpSL.Count-1 do
            begin
              if(i > 0) then
                FMiscText := FMiscText + CRCode + CRCode;
              FMiscText := FMiscText + TmpSL[i];
            end;
          end;
          ExpandTIUObjects(FMiscText);
        end;
        SetValue(After);
      end;
    finally
      if not uInit.TimedOut then
         FParent.FReminder.EndTextChanged(Sender);
    end;
    if not uInit.TimedOut then
         if(FParent.ElemType = etDisplayOnly) and (not assigned(FParent.FParent)) then
            RemindersInProcess.Notifier.Notify;
          end
    else
                InfoBox('Not Authorized to score the ' + FData.Narrative + ' test.',
                   'Insufficient Authorization', MB_OK + MB_ICONERROR);
  finally
    if (Sender is TCPRSDialogButton) then
      begin
        (Sender as TCPRSDialogButton).Enabled := true;
        (Sender as TCPRSDialogButton).SetFocus;
      end;

  end;
end;

procedure TRemPrompt.GAFHelp(Sender: TObject);
begin
  inherited;
  GotoWebPage(GAFURL);
end;

function TRemPrompt.EntryID: string;
begin
  Result := FParent.EntryID + '/' + IntToStr(integer(Self));
end;

procedure TRemPrompt.EditKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = '?') and (Sender is TCustomEdit) and
    ((TCustomEdit(Sender).Text = '') or (TCustomEdit(Sender).SelStart = 0)) then
    Key := #0;
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
  if(assigned(FForcedPrompts) and assigned(Data.FParent) and
     assigned(Data.FParent.FPrompts)) then
  begin
    for i := 0 to Data.FParent.FPrompts.Count-1 do
      UnSync(TRemPrompt(Data.FParent.FPrompts[i]));
  end;
  FData.Remove(Data);
  if(FData.Count <= 0) then
  begin
    idx := PCERootList.IndexOfObject(Self);
//    if(idx < 0) then
  //    idx := PCERootList.IndexOf(FID);
    if(idx >= 0) then
      PCERootList.Delete(idx);
    if PrimaryDiagRoot = Self then
      PrimaryDiagRoot := nil;
    Free;
  end;
end;

class function TRemPCERoot.GetRoot(Data: TRemData; Rec3: string;
                                   Historical: boolean): TRemPCERoot;
var
  DID: string;
  Idx: integer;
  obj: TRemPCERoot;

begin
  if(Data.DataType = dtVitals) then
    DID := 'V' + Piece(Rec3, U, 6)
  else
  begin
    if(Historical) then
    begin
      inc(HistRootCount);
      DID := IntToStr(HistRootCount);
    end
    else
      DID := '0';
    DID := DID + U +
           Piece(Rec3, U, r3Type) + U +
           Piece(Rec3, U, r3Code) + U +
           Piece(Rec3, U, r3Cat)  + U +
           Piece(Rec3, U, r3Nar);
  end;
  idx := -1;
  if(not assigned(PCERootList)) then
    PCERootList := TStringList.Create
  else
  if(PCERootList.Count > 0) then
    idx := PCERootList.IndexOf(DID);
  if(idx < 0) then
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

function TRemPCERoot.GetValue(PromptType: TRemPromptType; var NewValue: string): boolean;
var
  ptS: string;
  i: integer;

begin
  ptS := char(ord('D') + ord(PromptType));
  i := pos(ptS, FValueSet);
  if(i = 0) then
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
//  if(assigned(Prompt.FParent) and ((not Prompt.FParent.FChecked) or
//    (Prompt.FParent.ElemType = etDisplayOnly))) then exit;
  if(assigned(Prompt.FParent) and (not Prompt.FParent.FChecked)) then exit;
  pt := Prompt.PromptType;
  Value := Prompt.GetValue;
  if(Prompt.Forced) then
  begin
    if(not Prompt.FInitializing) then
    begin
      if(not assigned(FForcedPrompts)) then
        FForcedPrompts := TStringList.Create;
      if(FForcedPrompts.IndexOfObject(Prompt) < 0) then
      begin
        for i := 0 to FForcedPrompts.Count-1 do
        begin
          Prm := TRemPrompt(FForcedPrompts.Objects[i]);
          if(pt = Prm.PromptType) and (FForcedPrompts[i] <> Value) and (Prm.FParent.IsChecked) then
            raise EForcedPromptConflict.Create('Forced Value Error:' + CRLF + CRLF +
                  Prompt.ForcedCaption + ' is already being forced to another value.');
        end;
        FForcedPrompts.AddObject(Value, Prompt);
      end;
    end;
  end
  else
  begin
    if(assigned(FForcedPrompts)) then
    begin
      for i := 0 to FForcedPrompts.Count-1 do
      begin
        Prm := TRemPrompt(FForcedPrompts.Objects[i]);
        if(pt = Prm.PromptType) and (FForcedPrompts[i] <> Value) and (Prm.FParent.IsChecked) then
        begin
          Prompt.SetValue(FForcedPrompts[i]);
          if(assigned(Prompt.FParent)) then
            Prompt.FParent.cbClicked(nil); // Forces redraw
          exit;
        end;
      end;
    end;
  end;
  if(Prompt.FInitializing) then exit;
  for i := 0 to FData.Count-1 do
    inc(TRemData(FData[i]).FSyncCount);
  ptS := char(ord('D') + ord(pt));
  i := pos(ptS, FValueSet);
  if(i = 0) then
  begin
    FValueSet := FValueSet + ptS;
    i := length(FValueSet);
  end;
  SetPiece(FValue, U, i, Value);
  for i := 0 to FData.Count-1 do
  begin
    RData := TRemData(FData[i]);
    if(RData.FSyncCount = 1) and (assigned(RData.FParent)) and
      (assigned(RData.FParent.FPrompts)) then
    begin
      for j := 0 to RData.FParent.FPrompts.Count-1 do
      begin
        Prm := TRemPrompt(RData.FParent.FPrompts[j]);
        if(Prm <> Prompt) and (pt = Prm.PromptType) and (not Prm.Forced) then
          Prm.SetValue(Prompt.GetValue);
      end;
    end;
  end;
  for i := 0 to FData.Count-1 do
  begin
    RData := TRemData(FData[i]);
    if(RData.FSyncCount > 0) then
      dec(RData.FSyncCount);
  end;
end;

procedure TRemPCERoot.UnSync(Prompt: TRemPrompt);
var
  idx: integer;

begin
  if(assigned(FForcedPrompts) and Prompt.Forced) then
  begin
    idx := FForcedPrompts.IndexOfObject(Prompt);
    if(idx >= 0) then
      FForcedPrompts.Delete(Idx);
  end;
end;

initialization
  InitReminderObjects;

finalization
  FreeReminderObjects;

end.
