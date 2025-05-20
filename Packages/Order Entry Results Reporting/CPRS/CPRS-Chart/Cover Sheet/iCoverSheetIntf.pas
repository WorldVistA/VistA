unit iCoverSheetIntf;

{
  ================================================================================
  *
  *       Application:  CPRS - Coversheet
  *       Developer:    dan.petit@domain.ext
  *       Site:         Salt Lake City ISC
  *       Date:         2015-12-04
  *
  *       Description:  Main interface unit for application use.
  *
  *       Notes:
  *
  ================================================================================
}
interface

uses
  System.Classes,
  System.SysUtils,
  System.Types,
  Vcl.Controls,
  Vcl.ExtCtrls,
  Vcl.Graphics;

type
  ECoverSheetException = class(Exception);
  ECoverSheetInitFail = class(ECoverSheetException);
  ECoverSheetDisplayFail = class(ECoverSheetException);
  ECoverSheetSwitchPtFail = class(ECoverSheetException);

  ICPRS508 = interface;
  ICPRSTab = interface;
  ICPRSBaseDisplayPanel = interface;

  ICoverSheet = interface;
  ICoverSheetDisplayPanel = interface;
  ICoverSheetGrid = interface;
  ICoverSheetParam = interface;
  ICoverSheetParamEnumerator = interface;
  ICoverSheetParamList = interface;
  ICoverSheetParam_CPRS = interface;
  ICoverSheetParam_Web = interface;

  ICPRS508 = interface(IInterface)
    ['{B5168113-29E6-4C5E-886E-819DD1F2242E}']
    procedure OnSetFontSize(Sender: TObject; aNewSize: integer);
    procedure OnFocusFirstControl(Sender: TObject);
    procedure OnSetScreenReaderStatus(Sender: TObject; aActive: boolean);
  end;

  ICPRSTab = interface(IInterface)
    ['{70F51186-B098-4D32-9EBD-FC07F0FFFE03}']
    procedure OnClearPtData(Sender: TObject);
    procedure OnDisplayPage(Sender: TObject; aCallingContext: integer);
    procedure OnLoaded(Sender: TObject);
  end;

  ICoverSheet = interface(ICPRS508)
    ['{A83A5329-FDDA-4005-B5C7-504C11CDCFF5}']
    function getParams: ICoverSheetParamList;
    function getUniqueID: string;
    function getIPAddress: string;
    function getIsFinishedLoading: boolean;
    function getOnRefreshCWAD: TNotifyEvent;
    function getOnRefreshReminders: TNotifyEvent;
    function getPanelCount: integer;

    procedure setOnRefreshCWAD(const aValue: TNotifyEvent);
    procedure setOnRefreshReminders(const aValue: TNotifyEvent);

    procedure OnClearPtData(Sender: TObject);
    procedure OnDisplay(Sender: TObject; aTarget: TGridPanel);
    procedure OnExpandAllPanels(Sender: TObject);
    procedure OnInitCoverSheet(Sender: TObject);
    procedure OnRefreshPanel(Sender: TObject; aID: integer);
    procedure OnSwitchToPatient(Sender: TObject; aDFN: string);

    property Params: ICoverSheetParamList read getParams;
    property UniqueID: string read getUniqueID;
    property IPAddress: string read getIPAddress;
    property IsFinishedLoading: boolean read getIsFinishedLoading;
    property OnRefreshCWAD: TNotifyEvent read getOnRefreshCWAD write setOnRefreshCWAD;
    property OnRefreshReminders: TNotifyEvent read getOnRefreshReminders write setOnRefreshReminders;
    property PanelCount: integer read getPanelCount;
  end;

  ICoverSheetDisplayPanel = interface(IInterface)
    ['{90175D34-D7EB-4953-95E6-BA97218DE4C9}']
    function getBackgroundColor: TColor;
    function getParam: ICoverSheetParam;
    function getTitle: string;
    function getTitleFontColor: TColor;
    function getTitleFontBold: boolean;
    function getIsFinishedLoading: boolean;

    procedure setBackgroundColor(const aValue: TColor);
    procedure setParam(const aValue: ICoverSheetParam);
    procedure setTitle(const aValue: string);
    procedure setTitleFontColor(const aValue: TColor);
    procedure setTitleFontBold(const aValue: boolean);

    procedure OnClearPtData(Sender: TObject);
    procedure OnBeginUpdate(Sender: TObject);
    procedure OnEndUpdate(Sender: TObject);
    procedure OnRefreshDisplay(Sender: TObject);

    property BackgroundColor: TColor read getBackgroundColor write setBackgroundColor;
    property IsFinishedLoading: boolean read getIsFinishedLoading;
    property Params: ICoverSheetParam read getParam write setParam;
    property Title: string read getTitle write setTitle;
    property TitleFontColor: TColor read getTitleFontColor write setTitleFontColor;
    property TitleFontBold: boolean read getTitleFontBold write setTitleFontBold;
  end;

  ICoverSheetGrid = interface(IInterface)
    ['{48842D2D-F143-4A4A-8C18-365FA06C93CF}']
    function getPanelCount: integer;
    function getPanelColumn(aPanelIndex: integer): integer;
    function getPanelRow(aPanelIndex: integer): integer;
    function getPanelXY(aPanelIndex: integer): TPoint;
    function getRowCount: integer;

    procedure setPanelCount(const aValue: integer);

    property PanelCount: integer read getPanelCount write setPanelCount;
    property PanelColumn[aPanelIndex: integer]: integer read getPanelColumn;
    property PanelRow[aPanelIndex: integer]: integer read getPanelRow;
    property PanelXY[aPanelIndex: integer]: TPoint read getPanelXY;
    property RowCount: integer read getRowCount;
  end;

  ICoverSheetParam = interface(IInterface)
    ['{E48FEECF-8414-4339-92A0-85A2AF69252C}']
    function getID: integer;
    function getDisplayColumn: integer;
    function getDisplayRow: integer;
    function getTitle: string;

    procedure setDisplayColumn(const aValue: integer);
    procedure setDisplayRow(const aValue: integer);
    procedure setTitle(const aValue: string);

    function NewCoverSheetControl(aOwner: TComponent): TControl;

    property ID: integer read getID;
    property DisplayColumn: integer read getDisplayColumn write setDisplayColumn;
    property DisplayRow: integer read getDisplayRow write setDisplayRow;
    property Title: string read getTitle write setTitle;
  end;

  ICoverSheetParamEnumerator = interface(IInterface)
    ['{EACF2780-1FA7-4189-85A6-67AFA93DAD3A}']
    function GetCurrent: ICoverSheetParam;
    function MoveNext: boolean;

    property Current: ICoverSheetParam read GetCurrent;
  end;

  ICoverSheetParamList = interface(IInterface)
    ['{315DADF5-5A72-4A15-BD16-48E764F5E904}']
    function getCoverSheetParam(aID: string): ICoverSheetParam;
    function getCoverSheetParamByIndex(aIndex: integer): ICoverSheetParam;
    function getCoverSheetParamCount: integer;

    function Add(aCoverSheetParam: ICoverSheetParam): boolean;
    function Clear: boolean;
    function GetEnumerator: ICoverSheetParamEnumerator;

    property Param[aID: string]: ICoverSheetParam read getCoverSheetParam;
    property ParamByIndex[aIndex: integer]: ICoverSheetParam read getCoverSheetParamByIndex;
    property Count: integer read getCoverSheetParamCount;
  end;

  ICoverSheetParam_CPRS = interface(ICoverSheetParam)
    ['{794B69BE-3942-450D-95D8-18066CF4FA44}']
    function getLoadInBackground: boolean;
    function getDateFormat: string;
    function getDatePiece: integer;
    function getDetailRPC: string;
    function getInvert: boolean;
    function getMainRPC: string;
    function getParam1: string;
    function getPollingID: string;
    function getStatus: string;
    function getTitleCase: boolean;
    function getHighlightText: boolean;
    function getAllowDetailPrint: boolean;
    function getIsApplicable: boolean;
    function getOnNewPatient: TNotifyEvent;

    procedure setLoadInBackground(const aValue: boolean);
    procedure setInvert(const aValue: boolean);
    procedure setOnNewPatient(const aValue: TNotifyEvent);
    procedure setParam1(const aValue: string);

    property AllowDetailPrint: boolean read getAllowDetailPrint;
    property LoadInBackground: boolean read getLoadInBackground write setLoadInBackground;
    property DateFormat: string read getDateFormat;
    property DatePiece: integer read getDatePiece;
    property DetailRPC: string read getDetailRPC;
    property Invert: boolean read getInvert write setInvert;
    property MainRPC: string read getMainRPC;
    property Param1: string read getParam1 write setParam1;
    property PollingID: string read getPollingID;
    property Status: string read getStatus;
    property TitleCase: boolean read getTitleCase;
    property HighlightText: boolean read getHighlightText;
    property IsApplicable: boolean read getIsApplicable;
    property OnNewPatient: TNotifyEvent read getOnNewPatient write setOnNewPatient;
  end;

  ICoverSheetParam_Web = interface(ICoverSheetParam)
    ['{7ED04B07-E55F-4B0B-AEC9-22B14FE24D28}']
    function getHomePage: string;
    function getShowNavigator: boolean;

    procedure setHomePage(const aValue: string);
    procedure setShowNavigator(const aValue: boolean);

    property HomePage: string read getHomePage write setHomePage;
    property ShowNavigator: boolean read getShowNavigator write setShowNavigator;
  end;

  ICPRSBaseDisplayPanel = interface(IInterface)
    ['{BA7574C5-D954-48D2-BDA6-C82AFE9B97CC}']
    function getBackgroundColor: TColor;
    function getTitle: string;
    function getTitleFontColor: TColor;
    function getTitleFontBold: boolean;

    procedure setBackgroundColor(const aValue: TColor);
    procedure setTitle(const aValue: string);
    procedure setTitleFontColor(const aValue: TColor);
    procedure setTitleFontBold(const aValue: boolean);

    function FinishedLoading: boolean;

    property BackgroundColor: TColor read getBackgroundColor write setBackgroundColor;
    property Title: string read getTitle write setTitle;
    property TitleFontColor: TColor read getTitleFontColor write setTitleFontColor;
    property TitleFontBold: boolean read getTitleFontBold write setTitleFontBold;
  end;

function CoverSheet: ICoverSheet;

const
  CV_CPRS_PROB = 10;
  CV_CPRS_ALLG = 20;
  CV_CPRS_POST = 30;
  CV_CPRS_MEDS = 40;
  CV_CPRS_RMND = 50;
  CV_CPRS_LABS = 60;
  CV_CPRS_VITL = 70;
  CV_CPRS_VSIT = 80;
  CV_CPRS_IMMU = 90;
  CV_CPRS_WVHT = 99; // TDrugs Patch OR*3*377 and WV*1*24 - DanP@SLC 11-20-2015
  CV_WDGT_CLOCK = 1000;
  CV_WDGT_MINIBROWSER = 1001;

  DT_FORMAT = 'MMM DD, YYYY@hh:nn';

function NewGUID(aStrip: boolean = True): string;

implementation

uses
  System.StrUtils,
  oCoverSheet;

var
  fCoverSheet: ICoverSheet;

function CoverSheet: ICoverSheet;
begin
  fCoverSheet.QueryInterface(ICoverSheet, Result);
end;

function NewGUID(aStrip: boolean = True): string;
var
  aGUID: TGUID;
begin
  CreateGUID(aGUID);
  Result := GUIDToString(aGUID);
  if aStrip then
    begin
      Result := ReplaceStr(Result, '{', '');
      Result := ReplaceStr(Result, '}', '');
      Result := ReplaceStr(Result, '-', '');
    end;
end;

initialization

TCoverSheet.Create.GetInterface(ICoverSheet, fCoverSheet);

finalization

fCoverSheet := nil;

end.
