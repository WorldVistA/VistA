unit mGMV_GridGraph;
{
================================================================================
*
*       Application:  Vitals
*       Revision:     $Revision: 2 $  $Modtime: 8/14/09 2:03p $
*       Developer:    ddomain.user@domain.ext/doma.user@domain.ext
*       Site:         Hines OIFO
*
*       Description:  Manages both tabular and graphical display of a patients
*                     vitals records.  Uses the TChart component which requires
*                     the Delphi DB components be on the palette as well.
*
*       Notes:
*
================================================================================
*       $Archive: /Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_8/Source/VITALSVIEW/mGMV_GridGraph.pas $
*
* $History: mGMV_GridGraph.pas $
 * 
 * *****************  Version 2  *****************
 * User: Zzzzzzandria Date: 8/20/09    Time: 10:15a
 * Updated in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_8/Source/VITALSVIEW
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 8/12/09    Time: 8:29a
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_8/Source/VITALSVIEW
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 3/09/09    Time: 3:39p
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_6/Source/VITALSVIEW
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 1/13/09    Time: 1:26p
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_4/Source/VITALSVIEW
 * 
 * *****************  Version 7  *****************
 * User: Zzzzzzandria Date: 6/17/08    Time: 4:04p
 * Updated in $/Vitals/5.0 (Version 5.0)/VitalsGUI2007/Vitals/VITALSVIEW
 * 
 * *****************  Version 4  *****************
 * User: Zzzzzzandria Date: 2/20/08    Time: 1:42p
 * Updated in $/Vitals GUI 2007/Vitals/VITALSVIEW
 * Build 5.0.23.0
 * 
 * *****************  Version 3  *****************
 * User: Zzzzzzandria Date: 1/07/08    Time: 6:52p
 * Updated in $/Vitals GUI 2007/Vitals/VITALSVIEW
 *
 * *****************  Version 2  *****************
 * User: Zzzzzzandria Date: 7/17/07    Time: 2:30p
 * Updated in $/Vitals GUI 2007/Vitals-5-0-18/VITALSVIEW
 *
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/14/07    Time: 10:31a
 * Created in $/Vitals GUI 2007/Vitals-5-0-18/VITALSVIEW
 * 
 * *****************  Version 2  *****************
 * User: Zzzzzzandria Date: 6/13/06    Time: 11:15a
 * Updated in $/Vitals/VITALS-5-0-18/VitalsView
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/16/06    Time: 5:44p
 * Created in $/Vitals/VITALS-5-0-18/VitalsView
 * GUI v. 5.0.18 updates the default vital type IENs with the local
 * values.
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/16/06    Time: 5:33p
 * Created in $/Vitals/Vitals-5-0-18/VITALS-5-0-18/VitalsView
 *
 * *****************  Version 4  *****************
 * User: Zzzzzzandria Date: 7/22/05    Time: 3:51p
 * Updated in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, CCOW) - Delphi 6/VitalsView
 *
 * *****************  Version 3  *****************
 * User: Zzzzzzandria Date: 7/06/05    Time: 12:11p
 * Updated in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, CCOW) - Delphi 6/VitalsView
 *
 * *****************  Version 2  *****************
 * User: Zzzzzzandria Date: 6/03/05    Time: 6:02p
 * Updated in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, CCOW) - Delphi 6/VitalsView
 *
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/24/05    Time: 5:04p
 * Created in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, CCOW) - Delphi 6/VitalsView
 *
*
================================================================================
}
interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  Grids,
  ExtCtrls,
  Chart,
  Buttons,
  ExtDlgs,
  Menus, ActnList, ImgList, ComCtrls
  , mGMV_MDateTime, TeeProcs, Series, TeEngine, StdActns, System.Actions,
  VclTee.TeeGDIPlus, System.ImageList
  ;

type
  TStringToDouble = Function(aString: String): Double;

  TfraGMV_GridGraph = class(TFrame)
    pnlMain: TPanel;
    ActionList1: TActionList;
    acResizeGraph: TAction;
    acPrintGraph: TAction;
    acValueCaptions: TAction;
    ImageList1: TImageList;
    acGraphButtons: TAction;
    pnlGridGraph: TPanel;
    splGridGraph: TSplitter;
    pnlGraph: TPanel;
    pnlGrid: TPanel;
    grdVitals: TStringGrid;
    pnlDateRange: TPanel;
    acEnterVitals: TAction;
    ac3D: TAction;
    pnlTitle: TPanel;
    pnlPtInfo: TPanel;
    Panel9: TPanel;
    lblHospital: TLabel;
    Label6: TLabel;
    pnlActions: TPanel;
    sbEnterVitals: TSpeedButton;
    pnlGraphBackground: TPanel;
    chrtVitals: TChart;
    pnlGridTop: TPanel;
    pnlGSelect: TPanel;
    acOptions: TAction;
    Label1: TLabel;
    pnlDateRangeInfo: TPanel;
    Label11: TLabel;
    lblDateFromTitle: TLabel;
    pnlGBot: TPanel;
    pnlGTop: TPanel;
    pnlGLeft: TPanel;
    pnlGRight: TPanel;
    sbEnteredInError: TSpeedButton;
    acEnteredInError: TAction;
    acCustomRange: TAction;
    pnlGraphOptions: TPanel;
    PopupMenu1: TPopupMenu;
    cbValues: TCheckBox;
    ckb3D: TCheckBox;
    cbAllowZoom: TCheckBox;
    acZoom: TAction;
    acGraphOptions: TAction;
    ShowHideGraphOptions1: TMenuItem;
    Panel5: TPanel;
    pnlPTop: TPanel;
    pnlPRight: TPanel;
    pnlPLeft: TPanel;
    pnlPBot: TPanel;
    pnlDateRangeTop: TPanel;
    lbDateRange: TListBox;
    Panel6: TPanel;
    lblDateRange: TLabel;
    acEnteredInErrorByTime: TAction;
    N1: TMenuItem;
    MarkasEnteredInError1: TMenuItem;
    N2: TMenuItem;
    Print1: TMenuItem;
    acPatientAllergies: TAction;
    sbtnAllergies: TSpeedButton;
    ColorSelect1: TColorSelect;
    ColorDialog1: TColorDialog;
    cbChrono: TCheckBox;
    cbxGraph: TComboBox;
    SelectGraphColor1: TMenuItem;
    EnterVitals1: TMenuItem;
    Allergies1: TMenuItem;
    Panel4: TPanel;
    trbHGraph: TTrackBar;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    acZoomOut: TAction;
    acZoomIn: TAction;
    acZoomReset: TAction;
    pnlRight: TPanel;
    pnlDebug: TPanel;
    pnlZoom: TPanel;
    sbPlus: TSpeedButton;
    sbMinus: TSpeedButton;
    sbReset: TSpeedButton;
    edZoom: TEdit;
    PrintDialog1: TPrintDialog;
    sbTest: TStatusBar;
    Series2: TLineSeries;
    Series3: TLineSeries;
    Series1: TLineSeries;
    acUpdateGridColors: TAction;
    UpdateGridColors1: TMenuItem;
    acPatientInfo: TAction;
    edPatientName: TEdit;
    edPatientInfo: TEdit;
    acVitalsReport: TAction;
    acRPCLog: TAction;
    pnlGSelectLeft: TPanel;
    pnlGSelectRight: TPanel;
    pnlGSelectBottom: TPanel;
    pnlGSelectTop: TPanel;
    acShowGraphReport: TAction;
    procedure cbxDateRangeClick(Sender: TObject);
    procedure cbxGraphChange(Sender: TObject);
    procedure ShowHideLabels(Sender: TObject);
    procedure chrtVitalsClickSeries(Sender: TCustomChart; Series: TChartSeries;
      ValueIndex: integer; Button: TMouseButton; Shift: TShiftState; x,
      Y: integer);
    procedure chrtVitalsAfterDraw(Sender: TObject);
    procedure sbtnPrintGraphClick(Sender: TObject);
    procedure sbtnLabelsClick(Sender: TObject);
    procedure sbtnMaxGraphClick(Sender: TObject);
    procedure grdVitalsDrawCell(Sender: TObject; ACol, ARow: integer;
      Rect: TRect; State: TGridDrawState);
    procedure grdVitalsSelectCell(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; x, Y: integer);
    procedure acResizeGraphExecute(Sender: TObject);
    procedure acPrintGraphExecute(Sender: TObject);
    procedure acValueCaptionsExecute(Sender: TObject);
    procedure acEnterVitalsExecute(Sender: TObject);
    procedure ac3DExecute(Sender: TObject);
    procedure lbDateRangeMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Panel9Resize(Sender: TObject);
    procedure scbHGraphChange(Sender: TObject);
    procedure chrtVitalsResize(Sender: TObject);
    procedure cbxGraphExit(Sender: TObject);
    procedure cbxGraphEnter(Sender: TObject);
    procedure lbDateRangeExit(Sender: TObject);
    procedure lbDateRangeEnter(Sender: TObject);
    procedure grdVitalsEnter(Sender: TObject);
    procedure grdVitalsExit(Sender: TObject);
    procedure acEnteredInErrorExecute(Sender: TObject);
    procedure acCustomRangeExecute(Sender: TObject);
    procedure lbDateRangeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure acZoomExecute(Sender: TObject);
    procedure acGraphOptionsExecute(Sender: TObject);
    procedure acEnteredInErrorByTimeExecute(Sender: TObject);
    procedure acPatientAllergiesExecute(Sender: TObject);
    procedure ColorSelect1Accept(Sender: TObject);
    procedure sbGraphColorClick(Sender: TObject);
    procedure cbChronoClick(Sender: TObject);
    procedure lbDateRangeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure chrtVitalsBeforeDrawSeries(Sender: TObject);
    procedure grdVitalsTopLeftChanged(Sender: TObject);
    procedure chrtVitalsClickLegend(Sender: TCustomChart;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure acZoomOutExecute(Sender: TObject);
    procedure acZoomInExecute(Sender: TObject);
    procedure acZoomResetExecute(Sender: TObject);
    procedure splGridGraphMoved(Sender: TObject);
    procedure chrtVitalsDblClick(Sender: TObject);
    procedure acUpdateGridColorsExecute(Sender: TObject);
    procedure pnlPtInfoEnter(Sender: TObject);
    procedure pnlPtInfoExit(Sender: TObject);
    procedure acPatientInfoExecute(Sender: TObject);
    procedure acVitalsReportExecute(Sender: TObject);
    procedure pnlPtInfoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlPtInfoMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure grdVitalsMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure acRPCLogExecute(Sender: TObject);
    procedure acShowGraphReportExecute(Sender: TObject);
  private
    fAxisMax,
    fAxisMin: Double;
    bLabelShow: Boolean;
    bIgnoreBlueLines: Boolean;
    fXL,fXR: LongInt;                   // X coordinates of the Blue Lines
    FbgColor: TColor;                   // graph bg color
    FbgTodayColor: TColor;              // graph bg color

    ptName:String;
    ptInfo: String;
    FPatientDFN: string;                // parent copy to enter vitals, to retreive data
    FMDateTimeRange: TMDateTimeRange;   // parent copy to retreive data
    FObservationRange: String;          // string copy of the above
    FPatientLocation: String;           // parent copy to enter vitals
    FPatientLocationName:String;

    fGridRow:Integer;
    fGraphIndex:Integer;
    fFrameInitialized: Boolean;
    FStyle:String; // fsVitals or fsDLL
    FCurrentPoint: Integer;
    fSelectedDateTime:TDateTime;  // entered in error

    iIgnoreCount:Integer;
    iIgnoreGraph:Integer;

    function MetricValueString(_Row_:Integer;_Value_:String):String;// AAN 06/24/2002
    procedure drawMissingDataLines(Sender: TObject);
    procedure drawMissingLines(aStartPoint,aStopPoint:Integer);
    procedure maximizeGraph(Sender: TObject);
//    procedure printGraph(Sender: TObject);
    procedure setPatientDFN(const Value: string);
    procedure getVitalsData(aFrom,aTo:String);
    procedure GraphDataByIndex(anIndex:Integer);
    procedure getGraphByName(aName:String);
    procedure setGraphIndex(anIndex:Integer);

    procedure setStyle(aStyle:String);
    procedure setPatientLocation(aLocation:String);
    procedure setPatientLocationName(aLocationName:String);
    procedure setMDateTimeRange(aMDTR: TMDateTimeRange);

    procedure setTRP;
    procedure setBP;
    procedure setBPWeight;
    procedure setHW;

    procedure setSingleGraph(anIndex:Integer;aName:String;
      aConverter:TStringToDouble = nil);
    procedure setSingleVital(aRow:Integer;aSeria:Integer=0;aName:String='';
      aConverter:TStringToDouble = nil);
    procedure setSeriesAxis(TheSeries:Array of Integer);

    procedure setCurrentPoint(aValue: Integer);
    procedure setGridPosition(aPosition: Integer);

    procedure setObservationRange(aRange:String);
    procedure setTrackBarLimits;

    procedure updateLists;
    procedure setColor(aColor:TColor);
    procedure setTodayColor(aColor:TColor);

    function GraphNameByGridRow(aRow:Integer):String;
    function GridRowByGraphIndex(anIndex:Integer):Integer;

    function getDefaultGridPosition: Integer;

//    procedure setPatientInfoView(aName,anInfo:String);
    function getPatientName:String;
    function getPatientInfo:String;

    function GridScrollBarIsVisible:Boolean;
    procedure ShowGraphReport;
  public
    PackageSignature: String;   //?
    InputTemplateName: String;
    procedure setGraphTitle(aFirst,aSecond: String);
    procedure updateTimeLabels;
    procedure updateFrame(Reload:Boolean=True);
    procedure setUpFrame;
    procedure saveStatus;
    procedure restoreUserPreferences;
    procedure setGraphByABBR(aABBR:String);
    procedure showVitalsReport;
  published
    property BGColor: TColor read fBGColor write SetColor;
    property BGTodayColor: TColor read fBGTodayColor write SetTodayColor;
    property FrameInitialized: Boolean  read FFrameInitialized write FFrameInitialized;
    property GraphIndex: Integer        read FGraphIndex write setGraphIndex; //needs update
    property FrameStyle: String         read FStyle write SetStyle; //CPRS or Vitals
    property PatientDFN: string         read FPatientDFN write SetPatientDFN;
    property PatientLocation: string    read FPatientLocation write SetPatientLocation;
    property PatientLocationName:string read FPatientLocationName write SetPatientLocationName;
    property MDateTimeRange: TMDateTimeRange read FMDateTimeRange write setMDateTimeRange;
    property CurrentPoint: Integer      read FCurrentPoint write setCurrentPoint;
    property ObservationRange: String   read FObservationRange write setObservationRange;
    property IgnoreCount: Integer       read iIgnoreCount write iIgnoreCount;
    property GridRow: Integer           read fGridRow write fGridRow;
    function GraphIndexByGridRow(aRow:Integer):Integer;
  end;

const
  fsVitals = 'Vitals';
  fsDLL = 'Dll';

implementation

uses
  fGMV_DateRange,
  fGMV_ShowSingleVital
  , uGMV_Const
  , uGMV_GlobalVars
  , uGMV_User
  , uGMV_Utils
  , fGMV_InputLite
  , uGMV_Engine
  , fGMV_EnteredInError
  , fGMV_PtInfo, uGMV_VitalTypes
  , uGMV_Common
  , Math
  , Clipbrd, Printers
  , fGMV_UserSettings, fGMV_RPCLog
{$IFNDEF DLL}
  , fGMV_UserMain
{$ENDIF}
  , uGMV_Log
  , System.Types;

{$R *.DFM}
const
  rHeader = 0;
  rTemp = 1;
  rPulse = 2;
  rResp = 3;
  rPOx = 4;
  rBP = 6;
  rWeight = 7;
  rBMI = 8;
  rHeight = 9;
  rGirth = 10;
  rCVP = 11;
  rIntake = 12;
  rOutput = 13;
  rPain = 14;
  rLocation = 15;
  rEnteredBy = 16;
  rSource = 17; // Data Source

  // Graph names================================================================
  sgnNoGraph = 'No Graph';

  sgnTRP = 'TPR';
  sgnBP = 'B/P';
  sgnHW = 'Height/Weight';
  sgnPOX = 'Pulse Ox.';
  sgnBPWeight = 'B/P -- Weight';

  sgnTemp = 'Temperature';
  sgnPulse = 'Pulse';
  sgnResp = 'Respiration';//  Cells[0, 4] := ' P Ox %:'; //AAN 2003/06/03
  sgnWeight = 'Weight'; //    Cells[0, 7] := ' Wt (lbs):';
  sgnBMI = 'BMI';       //    Cells[0, 8] := ' BMI:';
  sgnHeight = 'Height'; //    Cells[0, 9] := ' Ht (in):';
  sgnGirth = 'C/G';     //    Cells[0, 10] := ' C/G:';
  sgnCVP = 'CVP';       //    Cells[0, 11] := ' CVP (cmH2O):';
  sgnIn = 'Intake';     //    Cells[0, 12] := ' In 24hr (c.c.):';
  sgnOutput = 'Output'; //    Cells[0, 13] := ' Out 24hr (c.c.):';
  sgnPain = 'Pain';     //    Cells[0, 14] := ' Pain:';

  iMaximumLimit = 2000;
  sNoData = 'NO DATA';

////////////////////////////////////////////////////////////////////////////////

function BPMeanBP(aString:String):Double;
begin
  Result := BPMean(aString);
end;

function BPDias(aString:String):Double;
var
  s2,s3:String;
begin
  s2 := Piece(Piece(aString,'/',2),' ',1);
  s3 := Piece(Piece(aString,'/',3),' ',1);
  if s3 = '' then
    Result := iVal(s2)
  else
    Result := iVal(s3);
end;

function PainNo99(aString:String):Double;
begin
  if trim(aString) = '99' then
    Result := iIgnore
  else
    Result := iVal(aString);
end;

//////////////////////////////////////////////////////////////////////////////

function getDateTime(aString:String):String;
var
  sDate,sTime:String;
const
//  sValid = '24:00:00'; // 061227 zzzzzzandria
  sValid = '23:59:59';
begin
//    Result := Piece(aString, '^', 1) + ' ' + Piece(aString, '^', 2); // Date Time
// zzzzzzandria 060920 -- 148503 ----------------------------------------- Start
  sDate := Piece(aString, '^', 1);
  sTime := Piece(aString, '^', 2);

// 061228 zzzzzzandria: 24:00:00 is corrected when data is added to the series only.
// no need to change data in the Grid header.
//  if sTime = '24:00:00' then        sTime := sValid
//  else if sTime = '00:00:00' then   sTime := sValid
  ;
  // zzzzzzandria 2007-07-17 Remedy 148503 --------------------------- begin
  // assuming '00:00:00' is a valid time for I/O only
  if sTime = '00:00:00' then   sTime := sValid;
  // zzzzzzandria 2007-07-17 Remedy 148503 ----------------------------- end

  Result := sDate + ' ' + sTime;
// zzzzzzandria 060920 -- 148503 ----------------------------------------- End
end;

function getTemperature(aString:String):String;
begin
  Result := Piece(Piece(aString, '^', 3), '-', 1) + Piece(Piece(aString, '^', 3), '-', 2); //temperature
end;

function getPulse(aString:String):String;
var
  s1,s2:String;
begin
  s1 := Piece(Piece(aString, '^', 4), '-', 1);
  s2 := Piece(Piece(aString, '^', 4), '-', 2);
  while pos(' ',s2)=1 do
    s2 := copy(s2,2,length(s2)-1);
  Result := s1 + ' ' +Piece(s2, ' ', 1) + ' ' +
                      Piece(s2, ' ', 2) + ' ' +
                      Piece(s2, ' ', 3) + ' ' +
                      Piece(s2, ' ', 4);
end;

function getRespiration(aString:String):String;
begin
  Result := Piece(Piece(aString, '^', 5), '-', 1) +Piece(Piece(aString, '^', 5), '-', 2); // Respiratory
end;

function getBP(aString:String):String;
begin
  Result  := Piece(Piece(aString, '^', 7), '-', 1) + ' ' + Piece(Piece(aString, '^', 7), '-', 2);
end;

function getWeight(aString:String):String;
begin
  Result := Piece(Piece(aString, '^', 8), '-', 1) + Piece(Piece(aString, '^', 8), '-', 2);
end;

////////////////////////////////////////////////////////////////////////////////
procedure PrintBitmap(Canvas:  TCanvas; DestRect:  TRect;  Bitmap:  TBitmap);
var
  BitmapHeader:  pBitmapInfo;
  BitmapImage :  POINTER;
  HeaderSize  :  DWORD;    // Use DWORD for D3-D5 compatibility
  ImageSize   :  DWORD;
begin
  GetDIBSizes(Bitmap.Handle, HeaderSize, ImageSize);
  GetMem(BitmapHeader, HeaderSize);
  GetMem(BitmapImage,  ImageSize);
  try
    GetDIB(Bitmap.Handle, Bitmap.Palette, BitmapHeader^, BitmapImage^);
    StretchDIBits(Canvas.Handle,
                  DestRect.Left, DestRect.Top,     // Destination Origin
                  DestRect.Right  - DestRect.Left, // Destination Width
                  DestRect.Bottom - DestRect.Top,  // Destination Height
                  0, 0,                            // Source Origin
                  Bitmap.Width, Bitmap.Height,     // Source Width & Height
                  BitmapImage,
                  TBitmapInfo(BitmapHeader^),
                  DIB_RGB_COLORS,
                  SRCCOPY)
  finally
    FreeMem(BitmapHeader);
    FreeMem(BitmapImage)
  end
end {PrintBitmap};

procedure CPRSPrintGraph(GraphImage: TChart; PageTitle: string);
var
  AHeader: TStringList;
  i, y, LineHeight: integer;
  GraphPic: TBitMap;
  Magnif: integer;
const
  TX_FONT_SIZE = 12;
  TX_FONT_NAME = 'Courier New';
  CF_BITMAP = 2;      // from Windows.pas
begin
  ClipBoard;
  AHeader := TStringList.Create;
//  CreatePatientHeader(AHeader, PageTitle);
  aHeader.Text := PageTitle;
  GraphPic := TBitMap.Create;
  try
    GraphImage.CopyToClipboardBitMap;
    GraphPic.LoadFromClipBoardFormat(CF_BITMAP, ClipBoard.GetAsHandle(CF_BITMAP), 0);
    with Printer do
      begin
        Canvas.Font.Size := TX_FONT_SIZE;
        Canvas.Font.Name := TX_FONT_NAME;
        Title := aHeader[0];
        Magnif := ((Canvas.TextWidth(StringOfChar('=', 74))) div GraphImage.Width);
        LineHeight := Printer.Canvas.TextHeight(TX_FONT_NAME);
        y := LineHeight;
        BeginDoc;
        try
          for i := 0 to AHeader.Count - 1 do
            begin
              Canvas.TextOut(0, y, AHeader[i]);
              y := y + LineHeight;
            end;
          y := y + (4 * LineHeight);
          //GraphImage.PrintPartial(Rect(0, y, Canvas.TextWidth(StringOfChar('=', 74)), y + (Magnif * GraphImage.Height)));
          PrintBitmap(Canvas, Rect(0, y, Canvas.TextWidth(StringOfChar('=', 74)), y + (Magnif * GraphImage.Height)), GraphPic);
        finally
          EndDoc;
        end;
      end;
  finally
    ClipBoard.Clear;
    GraphPic.Free;
    AHeader.Free;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

procedure TfraGMV_GridGraph.acPrintGraphExecute(Sender: TObject);
var
  bGrid,
  b:Boolean;
  sName,sInfo,
  sPatient,sLocation,sPrinted,sLabel,sType,sPeriod,
  ss,sss: String;
  i,iLen: Integer;
begin
  if not PrintDialog1.Execute then Exit;

  b := bIgnoreBlueLines;
  bIgnoreBlueLines := true;
  iLen := 74;

  sLocation := 'Hospital location: '+lblHospital.Caption;
  sName := getPatientName;
  sInfo := getPatientInfo;

  sPatient := sName
    + StringOfChar(' ',iLen -1 - Length(sName) - Length(sInfo)) + sInfo;
  sPrinted := 'Printed On: ' + FormatDateTime('mmm dd, yyyy  hh:nn', Now);
  sLabel := ' WORK COPY ONLY ';

  while Length(sLabel) < iLen do sLabel := '*'+sLabel +'*';
  sLabel := copy(sLabel,1,ilen-1);

  sPeriod := 'Period: '+lblDateFromTitle.Caption;
  sType := 'Vitals Type: '+cbxGraph.Text;
  sss := '';
  for i := 1 to Length(sPeriod) do
    begin
      if Copy(sPeriod,i,1) = '/' then sss := sss + '-'
      else sss := sss + Copy(sPeriod,i,1);
    end;
  sPeriod := sss;
  sss := '';
  ss := sType + sPeriod;

  while Length(ss) < iLen-1 do
    begin
      sss := sss + ' ';
      ss := sType + sss + sPeriod;
    end;

  ss :=
    ss + #13 +
    sPatient + #13 +
    sLabel +  #13 +
    sLocation + StringOfChar(' ', iLen - Length(sPrinted+sLocation)-1) + sPrinted+#13
    ;

  ChrtVitals.Invalidate;
  Application.ProcessMessages;

  bGrid := pnlGrid.Visible;
  splGridGraph.Align := alTop;
  if bGrid then pnlGrid.Visible := false;

  CPRSPrintGraph(ChrtVitals,ss);

  pnlGrid.Visible := bGrid;
  splGridGraph.Align := alBottom;

  bIgnoreBlueLines := b;
  ChrtVitals.Invalidate;
  Application.ProcessMessages;

end;
////////////////////////////////////////////////////////////////////////////////

procedure TfraGMV_GridGraph.GetVitalsData(aFrom,aTo:String);
var
  VMEntry: TStringlist;

  procedure CleanUpGrid;
  var
    c,r: Integer;
  begin
    with grdVitals do
      begin
        for c := 1 to ColCount - 1 do
        for r := 1 to RowCount - 1 do
          Cells[c, r] := '';
      end;
  end;

  procedure PopulateGrid;
  var
    i, c, j: integer;
    _S_,__S,s3,
    s1, s2: string;
  begin
    with grdVitals do
      begin
        c := 1;
        ColCount := VMEntry.Count + 1;
        for i := VMEntry.Count - 1 downto 0 do
          begin
            s1 := VMEntry[i];
            _s_ := VMEntry[i];

            Cells[c, rHeader] := getDateTime(_s_);
            Cells[c, rTemp] := getTemperature(_s_);
            Cells[c, rPulse] := getPulse(_s_);
            Cells[c, rResp] := getRespiration(_s_);

            // Pulse Oximetry
            s1 := Piece(Piece(VMEntry[i], '^', 6), '-', 1);//Value
            s2 := Piece(Piece(VMEntry[i], '^', 6), '-', 2);//Method
            s3 := Piece(Piece(VMEntry[i], '^', 6), '--',2);// ?
            Cells[c, rPOx{4}] := s1;//Moving qualifiers away

            //  REMEDY-152003: Spaces  around "/" affect the presentation- Start
            __s := Piece(Piece(VMEntry[i], '^',6), '-', 3)+'/'+
              Piece(Piece(VMEntry[i],'^', 6), '-', 4); //Pox
            if __s = '/' then
              Cells[c, rPOx+1{5}] := s2
            else
              Cells[c, rPOx+1{5}] := __s+ ' '+s2; // zzzzzzandria 060727
            //  REMEDY-152003: Spaces  around "/" affect the presentation -- end

            Cells[c, rBP{6}] := getBP(_s_);

            Cells[c, rWeight{7}] := getWeight(_s_);

            Cells[c, rBMI{8}] := Piece(Piece(VMEntry[i], '^', 10), '-', 1)
                         + Piece(Piece(VMEntry[i], '^', 10), '-', 2);
            Cells[c, rHeight{9}] := Piece(Piece(VMEntry[i], '^', 11), '-', 1)
                         + Piece(Piece(VMEntry[i], '^', 11), '-', 2);
            Cells[c, rGirth{10}] := Piece(Piece(VMEntry[i], '^', 13), '-', 1)
                          + Piece(Piece(VMEntry[i], '^', 13), '-', 2);
            Cells[c, rCVP{11}] := Piece(VMEntry[i], '^', 15);
            Cells[c, rIntake{12}] := Piece(Piece(VMEntry[i], '^', 17), '-', 1);
            Cells[c, rOutput{13}] := Piece(Piece(VMEntry[i], '^', 18), '-', 1);
            Cells[c, rPain{14}] := Piece(Piece(VMEntry[i], '^', 19), '-', 1);

            Cells[c, rLocation] := Piece(VMEntry[i], '^', 22);
            Cells[c, rEnteredBy] := Piece(VMEntry[i], '^', 23);
{$IFDEF PATCH_5_0_23}
            Cells[c, rSource] := Piece(VMEntry[i], '^', 24);
{$ENDIF}
            for j := 0 to 14 do                           //AAN 07/11/2002
              if pos('Unavail',Cells[c,j]) <> 0  then     //AAN 07/11/2002
                Cells[c,j] := 'Unavailable';              //AAN 07/11/2002

            inc(c);
          end;
        Col := ColCount - 1;
        Row := 1;
      end;
  end;

begin
  if not Assigned(MDateTimeRange) or (MDateTimeRange.getSWRange = '')
    or (FPatientDFN = '') then
    Exit;

  try
    CleanUpGrid;
    VMEntry := getAllPatientData(FPatientDFN,aFrom,aTo);
    if VMEntry.Count > 0 then
      PopulateGrid;
    GrdVitals.Refresh;
  finally
    VMEntry.Free;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

procedure TfraGMV_GridGraph.setSeriesAxis(TheSeries:Array of Integer);
var
  i: Integer;
  dXMin,dXMax,
  dMax,dMin,dDelta: Double;

  function LocalMin(aSeries:TChartSeries): Double;
  var
    j: Integer;
    LM: Double;
    flag: Boolean;
  begin
    LM := 500;
    flag := false;
    for j := 0 to aSeries.Count - 1 do
      if aSeries.YValue[j] = 0 then continue
      else
        begin
          LM := min(LM,aSeries.YValues[j]);
          flag := True;
        end;
    if Flag then
      Result := LM
    else
      Result :=0;
  end;

  function LocalXMin(aSeries:TChartSeries): Double;
  var
    j: Integer;
    LM: Double;
  begin
    LM := Now;
    for j := 0 to aSeries.Count - 1 do
      if aSeries.XValue[j] = 0 then continue
      else LM := min(LM,aSeries.XValues[j]);
    Result := LM
  end;

begin
  if chrtVitals.LeftAxis.Minimum > 0 then chrtVitals.LeftAxis.Minimum := 0;

  dMax := chrtVitals.Series[Low(TheSeries)].MaxYValue;
  dXMax := chrtVitals.Series[Low(TheSeries)].MaxXValue;
  dXMin := LocalXMin(chrtVitals.Series[Low(TheSeries)]);

  if cbChrono.Checked then dMin := chrtVitals.Series[Low(TheSeries)].MinYValue
  else                     dMin := LocalMin(chrtVitals.Series[Low(TheSeries)]);

  for i := Low(TheSeries) to High(TheSeries) do
    begin
      if not chrtVitals.Series[Theseries[i]].Active then Continue;
      dMax := Max(dMax,chrtVitals.Series[Theseries[i]].MaxYValue);
      if cbChrono.Checked then
        dMin := Min(dMin,chrtVitals.Series[i].MinYValue)
      else
        dMin := Min(dMin,LocalMin(chrtVitals.Series[i]));

      dXMax := Max(dXMax,chrtVitals.Series[Theseries[i]].MaxXValue);
      dXMin := Min(dXMin,LocalXMin(chrtVitals.Series[Theseries[i]]));

    end;

  dDelta := 0.05*(dMax - dMin);
  dDelta := max(dDelta,0.05*dMax);
  if dDelta = 0 then dDelta := 1
  else if dDelta < 0 then dDelta := - dDelta;

  try
    chrtVitals.LeftAxis.Automatic := False;
    if dMax+dDelta < chrtVitals.LeftAxis.Minimum then
      begin
        chrtVitals.LeftAxis.Minimum := dMin-dDelta;
        chrtVitals.LeftAxis.Maximum := dMax+dDelta;
      end
    else
      begin
        chrtVitals.LeftAxis.Maximum := dMax+dDelta;
        chrtVitals.LeftAxis.Minimum := dMin-dDelta;
      end;

    fAxisMax := dMax+dDelta;
    fAxisMin := dMin-dDelta;

  except
    on E: Exception do
      ShowMessage('(2) Set Series Axis error:'+#13#10+E.Message);
  end;

  try
    if dXMax < dXMin then  dXMax := dXMin;

    chrtVitals.BottomAxis.Automatic := False;
    if chrtVitals.BottomAxis.Maximum < trunc(dXMax+1) then
      chrtVitals.BottomAxis.Maximum := trunc(dXMax+1)
    else
      if dXMax < chrtVitals.BottomAxis.Minimum then
        begin
          chrtVitals.BottomAxis.Minimum := trunc(dXMin);
          chrtVitals.BottomAxis.Maximum := trunc(dXMax+1);
        end
      else
        begin
          chrtVitals.BottomAxis.Maximum := trunc(dXMax+1);
          chrtVitals.BottomAxis.Minimum := trunc(dXMin);
        end;

    if chrtVitals.BottomAxis.Minimum = 0 then
      chrtVitals.BottomAxis.Minimum := trunc(dXMin);

  except
    on E: Exception do
      ShowMessage('(3) Set Series Axis error:'+#13#10+E.Message);
  end;

  chrtVitals.BottomAxis.ExactDateTime := True;// 051031 zzzzzzandria
  chrtVitals.BottomAxis.Increment := DateTimeStep[dtOneMinute];// 051031 zzzzzzandria

end;

procedure TfraGMV_GridGraph.setSingleVital(aRow:Integer;aSeria:Integer=0;aName:String='';
      aConverter:TStringToDouble = nil);
var
  gCol: integer;
  dValue: Double;
  d: Double;

  function ValueDateTime(aCol:Integer):Double;
  var
    ss:String;
    dd: Double;
  begin
    try
      ss := grdVitals.Cells[aCol, rHeader];
      ss := ReplaceStr(ss,'-','/');
      // zzzzzzandria 061228 - replacement for chart only. to fix position
      ss := ReplaceStr(ss,'24:00:00','23:59:59');

      // zzzzzzandria 2007-07-17 Remedy 148503 --------------------------- begin
      // assuming '00:00:00' is a valid time for I/O only
      ss := ReplaceStr(ss,'00:00:00','23:59:59');
      // zzzzzzandria 2007-07-17 Remedy 148503 ----------------------------- end

      dD := StrToDateTimeDef(ss, Now);
    except
      dd := Now;
    end;
    Result := dd;
  end;

begin
  chrtVitals.LeftAxis.Automatic := False;
  try
    if 0 < chrtVitals.LeftAxis.Maximum then
      chrtVitals.LeftAxis.Minimum := 0;
    chrtVitals.LeftAxis.Maximum := 500;
  except
    on E: Exception do
      ShowMessage('Set Single Vital'+#13+E.Message);
  end;

  chrtVitals.Series[aSeria].Clear;

  if aName = '' then
    chrtVitals.Series[aSeria].Title := grdVitals.Cells[0,aRow]
  else
    chrtVitals.Series[aSeria].Title := aName;

  chrtVitals.Series[aSeria].Identifier := IntToStr(aRow);

  gCol := 1;
  with grdVitals do
    while (Cells[gCol, rHeader] <> '') and (gCol < ColCount) do
      begin
        try
          d := ValueDateTime(gCol);

          if cbChrono.Checked then
            begin
              if HasNumericValue(Cells[gCol, aRow]) then
                begin
                  if assigned(aConverter) then
                    dValue := aConverter(Cells[gCol, aRow])
                  else
                    dValue := dVal(Cells[gCol, aRow],grdVitals.Cells[gCol, rHeader]);

                  if dValue <> iIgnore then
                    chrtVitals.Series[aSeria].AddXY(d,dValue, SeriesLabel(Cells[gCol, rHeader]), clTeeColor);
                end
{$IFDEF LINES}
              else
                chrtVitals.Series[aSeria].AddNull(SeriesLabel(Cells[gCol, rHeader]));
{$ENDIF}
                ;
            end
          else
            begin
              if assigned(aConverter) then
                dValue := aConverter(Cells[gCol, aRow])
              else
                 dValue := dVal(Cells[gCol, aRow],grdVitals.Cells[gCol, rHeader]);
              if dValue <> iIgnore then
                begin
                  if HasNumericValue(Cells[gCol, aRow]) then
                    chrtVitals.Series[aSeria].Add(dValue, SeriesLabel(Cells[gCol, rHeader]), clTeeColor)
                  else
                    chrtVitals.Series[aSeria].AddNull(SeriesLabel(Cells[gCol, rHeader]));
                end
              else // we can not just delete 99 for pain
                chrtVitals.Series[aSeria].AddNull(SeriesLabel(Cells[gCol, rHeader]))
            end;
        except
          chrtVitals.Series[aSeria].AddNull(SeriesLabel(Cells[gCol, rHeader]));
        end;
        inc(gCol);
      end;

  setSeriesAxis([aSeria]);

  try
    if aRow = rPain then chrtVitals.LeftAxis.Minimum := -0.5;
    if aRow = rPain then chrtVitals.LeftAxis.Maximum := 12;
  except
    on E: Exception do
      ShowMessage('Pain setup error:'+#13#10+E.Message);
  end;

  chrtVitals.Series[aSeria].Active := True;

  try
    if (grdVitals.ColCount = 2) and
      ((pos(sNoData,grdVitals.Cells[1,0]) = 1)
        or (trim(grdVitals.Cells[1,aRow])='')) then
     chrtVitals.Series[aSeria].Active := False;
  except
  end;
end;

procedure TfraGMV_GridGraph.setHW;
begin
  SetSingleVital(rHeight,0,'Height');
  SetSingleVital(rWeight,1,'Weight');
  setSeriesAxis([0,1]);
end;

procedure TfraGMV_GridGraph.setTRP;
begin
  SetSingleVital(rTemp,0,'Temp.');
  SetSingleVital(rPulse,1,'Pulse');
  SetSingleVital(rResp,2,'Resp.');
  setSeriesAxis([0,1,2]);
end;

procedure TfraGMV_GridGraph.setBP;
begin
  SetSingleVital(rBP,0,'Sys.');
//  SetSingleVital(rBP,1,'Mean',BPMeanBP);
//  SetSingleVital(rBP,2,'Dias.',BPDias);
//  setSeriesAxis([0,1,2]);
  SetSingleVital(rBP,1,'Dias.',BPDias);
  setSeriesAxis([0,1]);
end;

procedure TfraGMV_GridGraph.setBPWeight;
begin
  SetSingleVital(rBP,0,'Sys.');
  SetSingleVital(rBP,1,'Dias.',BPDias);
  SetSingleVital(rWeight,2,'Weight');
  setSeriesAxis([0,1,2]);
end;

procedure TfraGMV_GridGraph.setSingleGraph(anIndex:Integer;aName:String;
      aConverter:TStringToDouble = nil);
begin
  SetSingleVital(anIndex,0,aName,aConverter);
end;

//==============================================================================
//==============================================================================
//==============================================================================

function TfraGMV_GridGraph.getDefaultGridPosition: Integer;
begin
  Result := (grdVitals.Width - grdVitals.ColWidths[0]-grdVitals.GridLineWidth)
    div (grdVitals.ColWidths[1]+grdVitals.GridLineWidth);
  Result := grdVitals.ColCount - Result;
  if Result < 1 then
    Result := 1;
end;

procedure TfraGMV_GridGraph.getGraphByName(aName:String);

  function DataFound:Boolean;
  var
    i: integer;
  begin
    DataFound := False;
    for i := 1 to grdVitals.ColCount - 1 do
      begin
        if Trim(grdVitals.Cells[i,fGridRow]) = '' then continue;
        DataFound := True;
        Break;
      end;
  end;

  procedure CleanUp;
  var
    j: Integer;
  begin
    with chrtVitals do
      begin
        ScaleLastPage := true;
        UndoZoom;
        for j := SeriesList.Count-1 downto 0 do
          begin
            Series[j].Clear;
            Series[j].Active := False;
            Series[j].Marks.Visible := cbValues.Checked;
          end;
      end;
  end;

begin
  acGraphButtons.Enabled := True;
  acResizeGraph.Enabled := True;

  if FPatientDFN = '' then  Exit;

  if (aName = sgnNoGraph) or (aName = sgnGirth) then
    begin
      chrtVitals.Visible := False;
      acGraphButtons.Enabled := False;
      acResizeGraph.Enabled := False;
      if not pnlGrid.Visible then MaximizeGraph(nil);
      if aName = sgnNoGraph then
        pnlGraphBackground.Caption := 'Sorry there is no data for this graph.'
      else
        pnlGraphBackground.Caption := 'Sorry the graph of <'+aName+'> is not available.';
      Exit;
    end
  else
    chrtVitals.Visible := True;

  CleanUp;

  if aName = sgnTRP then setTRP
  else if aName = sgnBP then  setBP
  else if aName = sgnPain then setSingleGraph(rPain,sgnPain,PainNo99) // values of 99 will be ignored
  else if aName = sgnHW then setHW
  else if aName = sgnPOX then setSingleGraph(rPOx,sgnPOX)
  else if aName = sgnHeight then setSingleGraph(rHeight,sgnHeight)
  else if aName = sgnWeight then setSingleGraph(rWeight,sgnWeight)
  else if aName = sgnBMI then setSingleGraph(rBMI,sgnBMI)
  else if aName = sgnTemp then setSingleGraph(rTemp,sgnTemp)
  else if aName = sgnPulse then setSingleGraph(rPulse,sgnPulse)
  else if aName = sgnResp then setSingleGraph(rResp,sgnResp)

  else if aName = sgngIRTH then setSingleGraph(rGirth,sgngIRTH)
  else if aName = sgnCVP then setSingleGraph(rCVP,sgnCVP)
  else if aName = sgnIn then setSingleGraph(rIntake,sgnIn)
  else if aName = sgnOutput then setSingleGraph(rOutput,sgnOutput)

  else if aName = sgnBPWeight then  setBPWeight
  ;

  if aName = sgnTemp then
    chrtVitals.LeftAxis.MinorTickCount := 9
  else
    chrtVitals.LeftAxis.MinorTickCount := 4;

  setTrackBarLimits;
  // the next line was uncommented to fix Remedy 281003. zzzzzzandria 2008-11-03
  CurrentPoint := getDefaultGridPosition; //commented  zzzzzzandria 2008-08-07
  trbHGraph.Position := getDefaultGridPosition;
end;

procedure TfraGMV_GridGraph.GraphDataByIndex(anIndex:Integer);
var
  aTime: TDateTime;
begin
  aTime := now;
  getGraphByName(cbxGraph.Items[anIndex]);
  EventAdd('GraphDataByIndex.UpdateFrame',Format('GraphIndex=%d',[GraphIndex]),aTime);
end;

////////////////////////////////////////////////////////////////////////////////

function TfraGMV_GridGraph.GridScrollBarIsVisible:Boolean;
begin
  Result := (GetWindowlong(grdVitals.Handle, GWL_STYLE) and WS_VSCROLL) <> 0;// zzzzzzandria 20081031
end;

procedure TfraGMV_GridGraph.setTrackBarLimits;
var
  iGridColCount: Integer;
  iMax: Integer;
begin
  iGridColCount := (grdVitals.Width - grdVitals.ColWidths[0]) div
    (grdVitals.ColWidths[1]+grdVitals.GridLineWidth);
  if GridScrollBarIsVisible  then
    Inc(iGridColCount);

  iMax := (grdVitals.ColCount - 1) - (iGridColCount - 1);
  if GridScrollBarIsVisible  then
    Inc(iMax);
(* zzzzzzandria 2008-04-13 =====================================================
  if (FrameStyle=fsVitals) then //zzzzzzandria 051205
    iMax := iMax - 1;
==============================================================================*)
  if iMax < 1 then
    iMax := 1;

  trbHGraph.min := 1;
  trbHGraph.max := iMax;
end;

procedure TfraGMV_GridGraph.setGridPosition(aPosition: Integer);
var
  iPos,
  iMin,iMax: Integer;

  function getVisibleColumnsCount:Integer;
  begin
    Result := ((grdVitals.Width - grdVitals.ColWidths[0]) div grdVitals.ColWidths[1]);
(*  zzzzzzandria 2008-04-13 ====================================================
    if (FrameStyle=fsVitals) then
//    and scrollbarIsVisible then
      Result := Result + 1;
==============================================================================*)
  end;

begin
  try
    iPos := aPosition;
    if iPos < 1 then iPos := 1;
    grdVitals.LeftCol := iPos;

    sbTest.SimpleText := Format(
      ' Current Tab Position: %4d (%4d/%4d)  Leftmost Grid column %4d (Total: %4d)',
      [aPosition,trbHGraph.Min,trbHGraph.Max,grdVitals.LeftCol,grdVitals.ColCount]);

    if not cbChrono.Checked then
      begin
        chrtVitals.BottomAxis.Automatic := False;
        iMin := grdVitals.LeftCol -1; // needs correction becouse Series starts from 0
        iMax  := iMin + getVisibleColumnsCount - 1;
        if iMin <= iMax then
          begin
            if chrtVitals.BottomAxis.Minimum > iMin then
              begin
                chrtVitals.BottomAxis.Minimum := iMin;
                chrtVitals.BottomAxis.Maximum := iMax;
              end
            else
            if chrtVitals.BottomAxis.Maximum < iMax then
              begin
                chrtVitals.BottomAxis.Maximum := iMax;
                chrtVitals.BottomAxis.Minimum := iMin;
              end
            else
              begin
                chrtVitals.BottomAxis.Minimum := 0;
                chrtVitals.BottomAxis.Maximum := iMax;
                chrtVitals.BottomAxis.Minimum := iMin;
              end;
          end;
        chrtVitals.Invalidate;
      end
    else
      setSeriesAxis([0,1,2]);

  except
{$IFDEF AANTEST}
    on E: Exception do
      ShowMessage('3'+#13#10+E.Message);
{$ENDIF}
  end;
end;

procedure TfraGMV_GridGraph.setCurrentPoint(aValue: Integer);
begin
  FCurrentPoint := aValue;
  grdVitals.LeftCol := aValue;// zzzzzzandria 051204
//  if iIgnoreCount > 0 then Exit; //zzzzzzandria 2008-08-07
  Inc(iIgnoreCount);
  setGridPosition(aValue);
  Dec(iIgnoreCount);
end;

procedure TfraGMV_GridGraph.scbHGraphChange(Sender: TObject);
begin
  CurrentPoint := trbHGraph.Position;
end;

procedure TfraGMV_GridGraph.grdVitalsTopLeftChanged(Sender: TObject);
begin
  trbHGraph.Position := grdVitals.LeftCol;
  CurrentPoint := grdVitals.LeftCol;
  chrtVitals.Invalidate;
end;

////////////////////////////////////////////////////////////////////////////////

procedure TfraGMV_GridGraph.setMDateTimeRange(aMDTR: TMDateTimeRange);
begin
  FMDateTimeRange := aMDTR;
  UpdateTimeLabels;
end;

procedure TfraGMV_GridGraph.setObservationRange(aRange:String);
var
  aTime: TDateTime;
begin
  if MDateTimeRange.setMRange(aRange) then
    begin
      if (Uppercase(aRange) = sDateRange) then
        UpdateLists;

      FObservationRange:= aRange;
      updateTimeLabels;
      //set interface elements
      lbDateRange.ItemIndex := lbDateRange.Items.IndexOf(FObservationRange);

      if iIGnoreCount > 0 then Exit;
      Inc(iIgnoreCount);
      if FrameInitialized then
        begin //zzzzzzandria 060610
          aTime := EventStart('SetObservationRange.UpdateFrame');
          UpdateFrame;
          EventStop('SetObservationRange.UpdateFrame','Reload',aTime);
        end;
      Dec(iIgnoreCount);
    end;
end;

procedure TfraGMV_GridGraph.cbxDateRangeClick(Sender: TObject);
var
  s: String;
begin
  try // zzzzzzandria 051208
    if lbDateRange.ItemIndex = -1 then
      s := lbDateRange.Items[0]
    else
      s := lbDateRange.Items[lbDateRange.ItemIndex];
  except
  end;

  ObservationRange := s;

  if fStyle = fsVitals then
    GetParentForm(Self).Perform(CM_PERIODCHANGED, 0, 0);
end;

////////////////////////////////////////////////////////////////////////////////

procedure TfraGMV_GridGraph.UpdateFrame(Reload:Boolean=True);
var
  MDT: TMDateTime;
  aComments: String;
begin
  if not FrameInitialized then
    Exit;
  aComments := 'No Reload';
  try
    if Reload then  // zzzzzzandria 060609
      begin
        aComments := 'Reload';
        MDT := TMDateTime.Create;
        MDT.WDateTime := MDateTimeRange.Stop.WDateTime;
        MDT.WDateTime := trunc(MDT.WDateTime)+1-5/(3600*24);
        GetVitalsData(MDateTimeRange.Start.getSMDateTime,MDT.getSMDateTime);
        MDT.Free;
      end;
    GraphDataByIndex(GraphIndex);

    grdVitals.Invalidate;
    chrtVitals.Invalidate;
  except
    on E:Exception do
      ShowMessage('Error in TfraGMV_GridGraph.UpdateFrame: ' + E.Message);
  end;
end;

procedure TfraGMV_GridGraph.setPatientDFN(const Value: string);
var
  aTime:TDateTime;
begin
  FPatientDFN := Value;
  Visible := (Value <> '');
  if iIgnoreCount > 0 then
    Exit;//  zzzzzzandria 051202

  if Assigned(MDateTimeRange) then
    begin //zzzzzzandria 060610
      aTime := EventStart('SetPatientDFN -- Begin');
      UpdateFrame;
      EventStop('SetPatientDFN -- End','DFN: '+fPatientDFN,aTime);
    end;
end;

procedure TfraGMV_GridGraph.setGraphIndex(anIndex: Integer);
begin
  fGraphIndex := anIndex;

  if iIgnoreCount > 0 then Exit;
  Inc(iIgnoreCount);

  if FGraphIndex <> iIgnoreGraph then
    begin
      cbxGraph.ItemIndex := fGraphIndex;
      getGraphByName(cbxGraph.Items[GraphIndex]);
    end
  else
    begin
      fGraphIndex := 0;
      getGraphByName(sgnNoGraph);
    end;

  grdVitals.Invalidate;
  chrtVitals.Invalidate;

  Dec(iIgnoreCount);
end;

procedure TfraGMV_GridGraph.cbxGraphChange(Sender: TObject);
begin
  if Sender = cbxGraph then
    GraphIndex := cbxGraph.ItemIndex;

  case GraphIndex of
    0: fGridRow := 1;
    1: fGridRow := 2;
    2: fGridRow := 3;
    3: fGridRow := 6;
    4: fGridRow := 4;
    5: fGridRow := 9;
    6: fGridRow := 7;
    7: fGridRow := 8;
    8: fGridRow := 14;

    12: fGridRow := 10;
    13: fGridRow := 11;
    14: fGridRow := 12;
    15: fGridRow := 13;
  else fGridRow := -1;
  end;

  //zzzzzzandria 060610
  UpdateFrame;
end;

////////////////////////////////////////////////////////////////////////////////
// Resizing ====================================================================

procedure TfraGMV_GridGraph.chrtVitalsResize(Sender: TObject);
begin
  setTrackBarLimits;
  setGridPosition(grdVitals.LeftCol{-1});// zzzzzzandria 051130
end;

procedure TfraGMV_GridGraph.MaximizeGraph(Sender: TObject);
begin
  pnlGrid.Visible := (pnlGrid.Visible = False);
  if fStyle = fsVitals then
    begin
      if pnlGrid.Visible then
        begin
          splGridGraph.Visible := True;
          splGridGraph.Align := alTop;
        end
      else
        begin
          splGridGraph.Visible := False;
          splGridGraph.Align := alBottom;
        end;
    end
  else
    begin
      if pnlGrid.Visible then
        begin
          splGridGraph.Visible := True;
          splGridGraph.Align := alBottom;
        end
      else
        begin
          splGridGraph.Visible := False;
          splGridGraph.Align := alTop;
        end;
    end;
end;

procedure TfraGMV_GridGraph.Panel9Resize(Sender: TObject);
begin
  lblHospital.Width := panel9.Width - lblHospital.Left - 4;
  lblHospital.Height := panel9.Height - lblHospital.Top - 2;
end;

////////////////////////////////////////////////////////////////////////////////

procedure TfraGMV_GridGraph.cbChronoClick(Sender: TObject);
var
  aTime: TDateTime;
  iPos: Integer;
begin
  if iIgnoreCount > 0 then Exit;
  iPos := grdVitals.LeftCol; // zzzzzzandria 2008-04-14

  ChrtVitals.SeriesList[0].XValues.DateTime := cbChrono.Checked;
  ChrtVitals.SeriesList[1].XValues.DateTime := cbChrono.Checked;
  ChrtVitals.SeriesList[2].XValues.DateTime := cbChrono.Checked;

  ckb3D.Enabled := cbChrono.Checked;
  if not cbChrono.Checked then
    begin
      ckb3D.Checked := False;
      ckb3D.Enabled := False;
    end;

  aTime := Now;
  UpdateFrame;
  EventAdd('UpdateFrame.cbChronoClick','',aTime);
  grdVitals.LeftCol := iPos; // zzzzzzandria 2008-04-14

  // zzzzzzandria 2008-08-07 last minute fix for Patch 5.0.22.7
  // axis X min is not set correctly when in Sychro mode
  CurrentPoint := trbHGraph.Position;// zzzzzzandria 2008-08-07
end;

////////////////////////////////////////////////////////////////////////////////

procedure TfraGMV_GridGraph.UpdateTimeLabels;
begin
  lblDateFromTitle.Caption := MDateTimeRange.Start.getSWDate;
  lblDateFromTitle.Caption := lblDateFromTitle.Caption + ' -- ' + MDateTimeRange.Stop.getSWDate;

  Application.ProcessMessages;
end;

procedure TfraGMV_GridGraph.UpdateLists;
begin
  if (pos(MDateTimeRange.getSWRange,lbDateRange.Items.Text) = 0) then
    begin
      lbDateRange.Items.Add(MDateTimeRange.getSWRange);
      lbDateRange.ItemIndex := lbDateRange.Items.IndexOf(MDateTimeRange.getSWRange);
    end;
end;

procedure TfraGMV_GridGraph.setGraphTitle(aFirst,aSecond: string);
begin
  chrtVitals.Title.Text.Clear;
  chrtVitals.Title.Text.Add(aFirst);
  chrtVitals.Title.Text.Add(aSecond);

  edPatientName.Text := aFirst;
  edPatientInfo.Text:= aSecond;

  ptName := aFirst;
  ptInfo := aSecond;
end;

procedure TfraGMV_GridGraph.ShowHideLabels(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to chrtVitals.SeriesCount - 1 do
    if chrtVitals.Series[i].Active then
      chrtVitals.Series[i].Marks.Visible := bLabelShow;
end;

function TfraGMV_GridGraph.MetricValueString(_Row_:Integer;_Value_:String):String;
var
  s: String;
  f: Extended;
begin
  Result := '';
  s := piece(_Value_,' ');
  if pos('*',s)=Length(s) then s := copy(s,1,Length(s)-1);
  case _Row_ of
    1:try //Temperature
          f := StrToFloat(S);
          f := (f-32)/9*5;
          s := format('%-8.1f (C)',[f]);
          Result := s;
        except
        end;
    7:try //Weight
          f := StrToFloat(S);
          f := f*0.4535924;
          s := format('%-8.2f (kg)',[f]);
          Result := s;
      except
      end;
    9,10: try //Height, C/G
          f := StrToFloat(S);
          f := f*2.54;
          s := format('%-8.2f (cm)',[f]);
          Result := s;
      except
      end;
    else
      Result := '';
  end;
end;

procedure TfraGMV_GridGraph.chrtVitalsClickSeries(Sender: TCustomChart;
  Series: TChartSeries; ValueIndex: integer; Button: TMouseButton;
  Shift: TShiftState; x, Y: integer);
const
  iDate = 1;
  iTime = 2;
  iLocation = 22;
  iEnteredBy = 23;

var
  iCol,iRow:Integer;
  d: Double;
  sFrom,sTo,sFor:String;
  AllVitalsData,
  VitalsData: TStringList;
  MDT: TMDateTime;

  procedure SetVitalInfo(aRow:Integer);
  var
    sv: String;
    sName,
    sValue, sMetric: String;
  begin
    sName := grdVitals.Cells[0, aRow];
    if pos(':',sName) = length(sName) then
      sName := copy(sName,1,Length(sName)-1);
    sV := grdVitals.Cells[iCol, aRow];
    if Trim(sV) <> '' then sValue := Trim(sV)
    else                   sValue := sNoData;
    sMetric := MetricValueString(aRow,grdVitals.Cells[iCol, aRow]);

    VitalsData.Add('  Vital:' + #9 + sName);
    VitalsData.Add('  Value:' + #9 + sValue);
    if sMetric <> '' then  VitalsData.Add('        ' + #9 + sMetric);
    if aRow = 4 then       VitalsData.Add('        ' + #9 + grdVitals.Cells[iCol, 5]);
    VitalsData.Add('');
  end;

  function ConvertVitalsToText:String;
  var
    i: Integer;
    _S_,__S,s3,//AAN
    s1, s2: string;
    s,ss,
    sDate,sTime, sLocation,sEnteredBy, sOldInfo,sNewInfo,
    sTemp, sPulse,sResp,sBP,sPOx, sFive, sWt, sBMI,
    sHt, sGirth, sCVP, sIn, sOut,sPain:String;
  const
    CRLF = #13#10;
    TAB = char(VK_TAB);

    procedure AddValue(aLabel,aValue:String);
    begin
      if aValue <>'' then
        begin
          ss := ss + TAB+sTime + TAB + aLabel+Piece(aValue,' ',1)+TAB+piece(aValue,' ',2,99) + CRLF;
          sTime := TAB;
        end;
    end;

  begin
    sOldInfo := '';
    sNewInfo := '';
    s := '';
    ss := '';
    sDate := '';
    sTime := '';

    for i := 0 to  AllVitalsData.Count - 1 do
      begin
        s := AllVitalsData[i];
        s1 := s;
        _s_ := s;

        sDate := Piece(s,'^',iDate);
        sTime := Piece(s,'^',iTime);
// 061228 zzzzzzandria uncommening 2 lines
        if i = 0 then
           ss := ss + CRLF + TAB + sDate + CRLF;

        sLocation := Piece(s,'^',iLocation);
        sEnteredBy := Piece(s,'^',iEnteredBy);

        sNewInfo := '--------------- Location: '+ sLocation+ char(VK_TAB)+'  Entered By: '+sEnteredBy+' ---------------';
        if sNewInfo <> sOldInfo then
          begin
            ss := ss + CRLF + TAB+sNewInfo+CRLF;
            sOldInfo := sNewInfo;
          end;
//        ss := ss + TAB+sTime+CRLF;
//        ss := ss + TAB+sTime;
        sTemp := Piece(Piece(s, '^', 3), '-', 1) + Piece(Piece(s, '^', 3), '-', 2); //temperature

        s1 := Piece(Piece(s, '^', 4), '-', 1);
        s2 := Piece(Piece(s, '^', 4), '-', 2);

        while pos(' ',s2)=1 do  s2 := copy(s2,2,length(s2)-1);
        sPulse := s1 + ' ' +
                            Piece(s2, ' ', 1) + ' ' +
                            Piece(s2, ' ', 2) + ' ' +
                            Piece(s2, ' ', 3) + ' ' +
                            Piece(s2, ' ', 4);

        sResp := Piece(Piece(s, '^', 5), '-', 1) + Piece(Piece(s, '^', 5), '-', 2); // Respiratory
        // Pulse Oximetry
        s1 := Piece(Piece(s, '^', 6), '-', 1);//Value
        s2 := Piece(Piece(s, '^', 6), '-', 2);//Method
        s3 := Piece(Piece(s, '^', 6), '--',2);//
        sPOx := s1;//Moving qualifiers away
        __s := Piece(Piece(s, '^',6), '-', 3)+' / '+
               Piece(Piece(s,'^', 6), '-', 4); //Pox
        if __s = ' / ' then      sFive := s2
        else                     sFive := __s+ ' / '+s2;
        if sFive <> '' then sPOx := sPOx + ' '+sFive;
        s1 := Piece(Piece(s, '^', 7), '-', 1);
        s2 := Piece(Piece(s, '^', 7), '-', 2);
        sBP := s1 + ' ' + s2;

        sWt := Piece(Piece(s, '^', 8), '-', 1) + Piece(Piece(s, '^', 8), '-', 2);
        sBMI := Piece(Piece(s, '^', 10), '-', 1) + Piece(Piece(s, '^', 10), '-', 2);
        sHt := Piece(Piece(s, '^', 11), '-', 1) + Piece(Piece(s, '^', 11), '-', 2);
        sGirth := Piece(Piece(s, '^', 13), '-', 1) + Piece(Piece(s, '^', 13), '-', 2);
        sCVP := Piece(s, '^', 15);
        sIn := Piece(Piece(s, '^', 17), '-', 1);
        sOut := Piece(Piece(s, '^', 18), '-', 1);
        sPain := Piece(Piece(s, '^', 19), '-', 1);

        sBMI := trim(sBMI);

        AddValue('Temp.:'+ TAB,trim(sTemp));
        AddValue('Pulse:'+ TAB,trim(sPulse));
        AddValue('Resp.:'+ TAB,trim(sResp));

        AddValue('POx.: '+ TAB,trim(sPOx));
        AddValue('BP:   '+ TAB,trim(sBP));

        AddValue('Wt:   '+ TAB,trim(sWt));
        AddValue('Ht:   '+ TAB,trim(sHt));
        AddValue('C/G.: '+ TAB,trim(sGirth));
        AddValue('CVP:  '+ TAB,trim(sCVP));
        AddValue('In:   '+ TAB,trim(sIn));
        AddValue('Out:  '+ TAB,trim(sOut));
        AddValue('Pain: '+ TAB,trim(sPain));
      end;
    Result := ss;
  end;

begin
  iCol := ValueIndex + 1;
  iRow := StrToIntDef(Series.Identifier, 1);
  VitalsData := TStringList.Create;
  try
    VitalsData.Add('');
    sFor := piece(grdVitals.Cells[iCol, 0],' ',1);
//    VitalsData.Add('  Date:' + #9 + grdVitals.Cells[iCol, 0]);
    if cbxGraph.Items[GraphIndex] = sgnTRP then
      begin
        SetVitalInfo(1);
        SetVitalInfo(2);
        SetVitalInfo(3);
      end
    else if cbxGraph.Items[GraphIndex] = sgnHW then
      begin
        SetVitalInfo(7);
        SetVitalInfo(9);
      end
    else
      SetVitalInfo(iRow);

    {=== ALL VITALS for the day ===============================================}
    if cbChrono.Checked then d := Series.XValue[ValueIndex]
    else
      begin
        sFrom := grdVitals.Cells[ValueIndex+1,0];
        // 061228 zzzzzzandria ......
        // zzzzzzandria 061228 - replacement was done to fix position on the chart
        sFrom := ReplaceStr(sFrom,'24:00:00','23:59:59');
        d := getCellDateTime(sFrom);
      end;
    mdt := TMDateTime.Create;
    mdt.WDateTime := trunc(d)+1/24/60/60;
    sFrom := mdt.getSMDate;
    sFor := mdt.getSWDate;
    mdt.WDateTime := d + 1 - 2/24/60/60;
    sTo := mdt.getSMDate;
    AllVitalsData := getALLPatientData(fPatientDFN,sFrom,sTo);
    VitalsData.Text := ConvertVitalsToText;
    AllVitalsData.Free;
   {===========================================================================}
    ShowInfo('Vitals '+getPatientName+' for '+sFor,VitalsData.Text);
    mdt.Free;
  finally
    FreeAndNil(VitalsData);
  end;
end;

////////////////////////////////////////////////////////////////////////////////

procedure TfraGMV_GridGraph.DrawMissingLines(aStartPoint,aStopPoint:Integer);
var
  rect, RectOld: TRect;
  x,y,
  i, j: integer;
  SeriesNumber: integer;
  FirstDataPoint,
  LastDataPoint  : integer;
  CurrentSeries: TChartSeries;
  iActiveCount: Integer;
const
  iSize = 3;

  procedure DrawEllipse;
  begin
    rect.left := CurrentSeries.CalcXPos(i)-iSize;
    rect.Top := CurrentSeries.CalcYPos(i)-iSize;
    rect.Right := CurrentSeries.CalcXPos(i)+iSize;
    rect.Bottom := CurrentSeries.CalcYPos(i)+iSize;

    chrtVitals.Canvas.Pen.Width := 4;
    Brush.Style := bsSolid;
    Brush.Color := CurrentSeries.SeriesColor;
    chrtVitals.Canvas.Ellipse(rect.Left,rect.top,rect.right,rect.Bottom);
    chrtVitals.Canvas.Pen.Width := 2;
  end;

  procedure DrawRect;
  begin
    rect.left := CurrentSeries.CalcXPos(i)-iSize;
    rect.Top := CurrentSeries.CalcYPos(i)-iSize;
    rect.Right := CurrentSeries.CalcXPos(i)+iSize;
    rect.Bottom := CurrentSeries.CalcYPos(i)+iSize;
    chrtVitals.Canvas.Brush.Color := CurrentSeries.SeriesColor;
    chrtVitals.Canvas.FillRect(rect);
  end;

  procedure DrawPolygon;
  begin
  end;

  function yStep:Integer;
  begin
    Result := 0;
    if not chrtVitals.View3d then Exit;

    chrtVitals.CalcSize3dWalls;
    if chrtVitals.SeriesCount > 0 then
      Result := chrtVitals.Height3D div iActiveCount;
  end;

  function xStep:Integer;
  begin
    Result := 0;
    if not chrtVitals.View3d then Exit;

    chrtVitals.CalcSize3dWalls;
    if chrtVitals.SeriesCount > 0 then
      Result := chrtVitals.Width3D div iActiveCount;
  end;

  function xDelta(ii: Integer): Integer;
  begin
    Result := 0;
  end;

  function yDelta(ii: Integer): Integer;
  begin
    Result := 0;
EXIT;
    case iActiveCount of
      1:begin
          yDelta := yStep+2;
        end;
      2: begin
          case ii of
            0: yDelta :=  - yStep - 2
          else
            yDelta := yStep;
          end;
        end;
      3: begin
          case ii of
            0: yDelta :=  yStep + 2;
            1: yDelta := 0;
            2: yDelta := - yStep - 2
          else
           yDelta := 0;
          end;
        end;
    else
      yDelta := 0;
    end;

  end;

begin
  RectOld := TCanvas(chrtVitals.Canvas).ClipRect;
  chrtVitals.Canvas.ClipRectangle(chrtVitals.chartRect);

  iActiveCount := 0;
  for SeriesNumber := 0 to chrtVitals.SeriesCount - 1 do
    if chrtVitals.Series[SeriesNumber].Active then
        Inc(iActiveCount);

  for SeriesNumber := 0 to chrtVitals.SeriesCount - 1 do
    if chrtVitals.Series[SeriesNumber].Active then
      begin
        CurrentSeries := chrtVitals.Series[SeriesNumber];
        if CurrentSeries.Count < 1 then Continue;
        FirstDataPoint :=0;
        LastDataPoint := CurrentSeries.Count-1;
        j := FirstDataPoint;
        for i := FirstDataPoint+1 to LastDataPoint do
          begin
            if not CurrentSeries.IsNull(i) then
              begin
                with chrtVitals.Canvas do
                  begin
                    Pen.Width := 2;
                    Pen.Color := CurrentSeries.SeriesColor;
//                    if not chrtVitals.View3d then zzzzzzandria 060106
                    case SeriesNumber of
                      0: DrawEllipse;
                      1: DrawEllipse;
                      2:begin
                        Polygon([
                          Point(CurrentSeries.CalcXPos(i)-iSize,CurrentSeries.CalcYPos(i)+iSize),
                          Point(CurrentSeries.CalcXPos(i)+iSize,CurrentSeries.CalcYPos(i)+iSize),
                          Point(CurrentSeries.CalcXPos(i),CurrentSeries.CalcYPos(i)-iSize)
                        ])
                      end;
                      3:begin
                        Polygon([
                          Point(CurrentSeries.CalcXPos(i)-iSize,CurrentSeries.CalcYPos(i)-iSize),
                          Point(CurrentSeries.CalcXPos(i)+iSize,CurrentSeries.CalcYPos(i)-iSize),
                          Point(CurrentSeries.CalcXPos(i),CurrentSeries.CalcYPos(i)+iSize)
                        ])
                      end;
                    end;

                    {}
                  // to avoid starting with null on the screen
                  if {(j <> 0) or}
                    not CurrentSeries.IsNull(j)
                    and not ((i = LastDataPoint) and (CurrentSeries.IsNull(i)))
                  then
                    begin
                      x := CurrentSeries.CalcXPos(j) + xDelta(SeriesNumber);
                      y := CurrentSeries.CalcYPos(j) + yDelta(SeriesNumber);
                      MoveTo(x,y);

                      x := CurrentSeries.CalcXPos(i) + xDelta(SeriesNumber);
                      y := CurrentSeries.CalcYPos(i) + YDelta(SeriesNumber);
                      LineTo(x,y);
{
                      Pen.Color := clRed;
                      y := y + chrtVitals.SeriesHeight3d;
                      LineTo(x,y);
                      x := CurrentSeries.CalcXPos(i) + xDelta(SeriesNumber);
                      y := CurrentSeries.CalcYPos(i) + YDelta(SeriesNumber);
                      MoveTo(x,y);
                      x := x + chrtVitals.SeriesWidth3d;
                      LineTo(x,y);
}
                    end;
                  end;
                j := i;
              end;
          end;
      end;
  chrtVitals.Canvas.ClipRectangle(RectOld);//Restore ClipRectangle
end;

procedure TfraGMV_GridGraph.DrawMissingDataLines(Sender: TObject);
var
  FirstPointOnPage, LastPointOnPage: integer;
begin
  FirstPointOnPage := 0;
  LastPointOnPage := chrtVitals.Series[0].Count-1;
  DrawMissingLines(FirstPointOnPage,LastPointOnPage);
end;

procedure TfraGMV_GridGraph.chrtVitalsAfterDraw(Sender: TObject);
begin
{$IFDEF LINES}
  Exit;
{$ENDIF}
  if not cbChrono.Checked then
    DrawMissingDataLines(nil);
end;

procedure TfraGMV_GridGraph.grdVitalsDrawCell(
  Sender: TObject;
  ACol, ARow: integer;
  Rect: TRect;
  State: TGridDrawState);

  function CurrentGraph:Boolean;
    begin
      case GraphIndex of
        0..3: Result := aRow = fGridRow;
        4: Result := (aRow = 4) or (aRow=5);
        5..8: Result := aRow = fGridRow;
        9:Result := (aRow = 7) or (aRow = 9);
        10: Result := (aRow = 1) or (aRow = 2) or (aRow=3);
        11: Result := (aRow = 6) or (aRow = 7);
      else
        Result := aRow = fGridRow;
      end;
    end;

var
  sToday,
  Value: string;
// Uncomment if you need a separate color for today's values
//  TodayValue,
  AbnormalValue: Boolean;
begin

  sToday :=FormatDateTime('mm-dd-yy',Now);
  //with grdVitals do
  with TStringGrid(Sender) do
    begin
      Value := trim(Cells[ACol, ARow]);
      AbnormalValue := Pos('*', Value) > 0;

// Uncomment if you need a separate color for today's values
//      TodayValue := piece(Cells[aCol,0],' ',1) = sToday;
      // Fill in background as btnFace, Abnormal, Normal
      if (aRow > 14) or (aRow=0) then
            Canvas.Brush.Color := clBtnFace
      else if (ACol = 0) then
        begin
          if (aRow<>0) and CurrentGraph then
            Canvas.Brush.Color := clInfoBk
          else
            Canvas.Brush.Color := clSilver;// clBtnFace;
        end
      else if AbnormalValue then
        begin
// Uncomment if you need a separate color for today's values
//          if TodayValue then
//            Canvas.Brush.Color := DISPLAYCOLORS[GMVAbnormalTodayBkgd]
//          else
            Canvas.Brush.Color := DISPLAYCOLORS[GMVAbnormalBkgd];
        end
      else
// Uncomment if you need a separate color for today's values
//          if TodayValue then
//            Canvas.Brush.Color := DISPLAYCOLORS[GMVNormalTodayBkgd]
//          else
            if CurrentGraph then
              Canvas.Brush.Color := $00DFDFDF
            else
//              Canvas.Brush.Color :=  fBGColor; //DISPLAYCOLORS[GMVNormalBkgd];
              Canvas.Brush.Color :=  DISPLAYCOLORS[GMVNormalBkgd];
      Canvas.FrameRect(Rect);

      {
      // Draw rectangle around selected cell
      if (ACol > 0) and (ARow > 0) and (gdSelected in State) then
        begin
          if AbnormalValue then
            Canvas.Pen.Color := DISPLAYCOLORS[GMVAbnormalText]
          else
            Canvas.Pen.Color := DISPLAYCOLORS[GMVNormalText];
          Canvas.FrameRect(Rect);
        end;
      }

      // Set up font color as btnText, Abnormal, Normal
      if (ACol = 0) or (ARow = 0) or (ARow = 15) or (ARow = 16) then
        begin
          Canvas.Font.Color := clBtnText;
          Canvas.Font.Style := [];
        end
      else if AbnormalValue then
        begin
          Canvas.Font.Color := DISPLAYCOLORS[GMVAbnormalText];
          if GMVAbnormalBold then  Canvas.Font.Style := [fsBold]
          else                     Canvas.Font.Style := [];
        end
      else
        begin
          Canvas.Font.Color := DISPLAYCOLORS[GMVNormalText];
          if GMVNormalBold then    Canvas.Font.Style := [fsBold]
          else                     Canvas.Font.Style := [];
        end;

      // Fill in the data
      if ((ACol = 0) or (ARow = 0)) and (aRow <>15) and (aRow <>16) then
        Canvas.TextRect(Rect, Rect.Left+10, Rect.Top, Value)
      else if ((aRow = 15) or (aRow=16)) {and (not cbWho.Checked)} then
        begin
          Canvas.TextRect(Rect, Rect.Left+10, Rect.Top, Value)
        end
      else if (aRow = 5) then // zzzzzzandria 2008-01-07 ----------------- begin
      // qualifiers are shown regardless of user preferences(options)
        begin
          if pos('*',trim(Cells[ACol, 4])) >0 then
            begin
              if not GMVAbnormalQuals then
                Value := '';
            end
          else if not GMVNormalQuals then
            Value := '';
          Canvas.TextRect(Rect, Rect.Left+10, Rect.Top, Value);
        end // zzzzzzandria 2008-01-07 ------------------------------------- end
      else if AbnormalValue then
        begin
          if GMVAbnormalQuals then Canvas.TextRect(Rect, Rect.Left+10, Rect.Top, Value)
          else                     Canvas.TextRect(Rect, Rect.Left+10, Rect.Top, Piece(Value, ' ', 1))
        end
      else
        begin
          if GMVNormalQuals then  Canvas.TextRect(Rect, Rect.Left+10, Rect.Top, Value)
          else                    Canvas.TextRect(Rect, Rect.Left+10, Rect.Top, Piece(Value, ' ', 1));
        end;

      if gdSelected in State then
        begin
          Canvas.Brush.Color := clRed; // clBlack;//zzzzzzandria 050705
          Canvas.FrameRect(Rect);
        end;
    end;
end;

procedure TfraGMV_GridGraph.grdVitalsSelectCell(Sender: TObject; Button: TMouseButton; Shift: TShiftState; x, Y: integer);
var
  ACol, ARow: Longint;
begin
  grdVitals.MouseToCell(x, Y, ACol, ARow);
  if (aCol = 0) then
    begin
      if GraphIndexByGridRow(aRow) <> iIgnoreGraph then
        GraphIndex := GraphIndexByGridRow(aRow)
      else
        fGraphIndex := 0;
      fGridRow := aRow;

      UpdateFrame; // zzzzzzandria 060105

      grdVitals.Invalidate;
      chrtVitals.Invalidate;
    end;

  if (ACol > 0) and (ARow = 0) then
    try
      fSelectedDateTime := getCellDateTime(grdVitals.Cells[aCol, 0]);
      acEnteredInErrorByTimeExecute(nil);
    except
    end;
end;

procedure TfraGMV_GridGraph.setPatientLocation(aLocation: String);
begin
  FPatientLocation := aLocation;
end;

procedure TfraGMV_GridGraph.setPatientLocationName(aLocationName: String);
begin
  FPatientLocationName := aLocationName;
  lblHospital.Caption := aLocationName;
end;

// Actions =====================================================================

procedure TfraGMV_GridGraph.sbtnPrintGraphClick(Sender: TObject);
begin
  acPrintGraphExecute(Sender);
end;

procedure TfraGMV_GridGraph.sbtnLabelsClick(Sender: TObject);
begin
  acValueCaptionsExecute(Sender);
end;

procedure TfraGMV_GridGraph.sbtnMaxGraphClick(Sender: TObject);
begin
  acResizeGraphExecute(Sender);
end;

procedure TfraGMV_GridGraph.acCustomRangeExecute(Sender: TObject);
begin
  setObservationRange(sDateRange);
  UpdateLists;
end;

procedure TfraGMV_GridGraph.acEnteredInErrorExecute(Sender: TObject);
begin
  if EnterVitalsInError(FPatientDFN) <> mrCancel then
    cbxDateRangeClick(nil);
end;

procedure TfraGMV_GridGraph.acZoomExecute(Sender: TObject);
begin
  chrtVitals.AllowZoom := cbAllowZoom.Checked;
  edZoom.Enabled := chrtVitals.AllowZoom;
  sbPlus.Enabled := chrtVitals.AllowZoom;
  sbMinus.Enabled := chrtVitals.AllowZoom;
  sbReset.Enabled := chrtVitals.AllowZoom;
end;

procedure TfraGMV_GridGraph.acGraphOptionsExecute(Sender: TObject);
begin
  pnlGraphOptions.Visible := not pnlGraphOptions.Visible;
  showHideGraphOptions1.Checked := pnlGraphOptions.Visible;
{$IFNDEF DLL}
  if Assigned(frmGMV_UserMain) then
    frmGMV_UserMain.showHideGraphOptions1.Checked := pnlGraphOptions.Visible;
{$ENDIF}
end;

procedure TfraGMV_GridGraph.acEnteredInErrorByTimeExecute(Sender: TObject);
begin
  if fSelectedDateTime = 0 then Exit;
  if EnteredInErrorByDate(FPatientDFN,trunc(fSelectedDateTime)+1-1/(3600*24)) <> mrCancel then
    cbxDateRangeClick(nil);
end;

procedure TfraGMV_GridGraph.acPatientAllergiesExecute(Sender: TObject);
begin
  sbtnAllergies.Down := True;
  ShowPatientAllergies(FPatientDFN,'Allergies for:'+edPatientName.Text +
    '  ' + edPatientInfo.Text);
  sbtnAllergies.Down := False;
end;

procedure TfraGMV_GridGraph.ColorSelect1Accept(Sender: TObject);
begin
  BGColor := ColorSelect1.Dialog.Color;
end;

procedure TfraGMV_GridGraph.SetColor;
begin
  fBGColor := aColor;
    begin
      chrtVitals.Color := fBGColor;
//      pnlRight.Color := fBGColor;
      trbHGraph.Invalidate;
      grdVitals.Invalidate;
    end;
end;

procedure TfraGMV_GridGraph.SetTodayColor;
begin
  fBGTodayColor := aColor;
    begin
      trbHGraph.Invalidate;
      grdVitals.Invalidate;
    end;
end;

procedure TfraGMV_GridGraph.sbGraphColorClick(Sender: TObject);
begin
  if ColorDialog1.Execute then
    BGColor := ColorDialog1.Color;
end;

procedure TfraGMV_GridGraph.acEnterVitalsExecute(Sender: TObject);
var
  aTime:TDateTime;
begin
  VitalsInputDLG(
     PatientDFN,
     PatientLocation,
     '', // Template
     '', // Signature
     getServerWDateTime,// select server date time  - zzzzzzandria 050419
     ptName,
     ptInfo
     ) ;
  aTime := Now;
  UpdateFrame;
  EventAdd('fraGMV_GridGraph.UpdateFrame','Reload',aTime);
end;

procedure TfraGMV_GridGraph.acValueCaptionsExecute(Sender: TObject);
begin
  bLabelShow := not bLabelShow;
  ShowHideLabels(Sender);
end;

procedure TfraGMV_GridGraph.ac3DExecute(Sender: TObject);
begin
  chrtVitals.View3D := ckb3D.Checked;
  bIgnoreBlueLines := ckb3D.Checked;
end;

procedure TfraGMV_GridGraph.acResizeGraphExecute(Sender: TObject);
begin
  MaximizeGraph(Sender);
end;
(*
procedure TfraGMV_GridGraph.PrintGraph(Sender: TObject);
begin
  with TPrintDialog.Create(Application) do
    try
      if Execute then
        begin
          chrtVitals.PrintProportional := True;
          chrtVitals.PrintMargins.Left := 1;
          chrtVitals.PrintMargins.Top := 1;
          chrtVitals.PrintMargins.Bottom := 1;
          chrtVitals.PrintMargins.Right := 1;
          chrtVitals.PrintResolution := -10;//-70;
          chrtVitals.BottomAxis.LabelsAngle := 0;
          chrtVitals.BackImageInside := False;
          chrtVitals.Print;
          chrtVitals.backimageinside := True;
        end;
    finally
      free;
    end;
end;
*)
procedure TfraGMV_GridGraph.lbDateRangeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
      cbxDateRangeClick(lbDateRange);
end;

////////////////////////////////////////////////////////////////////////////////
function TfraGMV_GridGraph.GraphNameByGridRow(aRow:Integer):String;
  begin
    case aRow of
      rTemp{1}: Result := sgnTemp;
      rPulse{2}:Result := sgnPulse;
      rResp{3}: Result := sgnResp;
      rPOx{4}:  Result := sgnPOX;
      rPOX+1{5}: Result := sgnPOX;
      rBP{6}: Result := sgnBP;
      rWeight{7}: Result := sgnWeight;
      rBMI{8}: Result := sgnBMI;
      rHeight{9}: Result := sgnHeight;
      rGirth{10}: Result := sgnGirth;
      rCVP{11}: Result := sgnCVP; //GraphNameNoGraph;
      rIntake{12}: Result := sgnIn;//GraphNameNoGraph;
      rOutput{13}: Result := sgnOutput;//GraphNameNoGraph;
      rPain{14}: Result := sgnPain;
    else
      Result := sgnNoGraph;
    end;
  end;

function TfraGMV_GridGraph.GraphIndexByGridRow(aRow:Integer):Integer;
begin
  case aRow of
    rTemp{1}:   Result := 0;
    rPulse{2}:  Result := 1;
    rResp{3}:   Result := 2;
    rPOx{4}:    Result := 4;
    rPOx+1{5}:  Result := 4;
    rBP{6}:     Result := 3;
    rWeight{7}: Result := 6;
    rBMI{8}:    Result := 7;
    rHeight{9}: Result := 5;
    rGirth{10}: Result := 12; //iIgnoreGraph; // C/G
    rCVP{11}:   Result := 13; //iIgnoreGraph;  // CVP
    rIntake{12}:Result := 14; //iIgnoreGraph;  // In
    rOutput{13}:Result := 15; //iIgnoreGraph;  // Out
    rPain{14}:  Result := 8;
  else
    Result := iIgnoreGraph;
  end;
end;

function TfraGMV_GridGraph.GridRowByGraphIndex(anIndex:Integer):Integer;
begin
  case anIndex of
    0: Result := rTemp{1};
    1: Result := rPulse{2};
    2: Result := rResp{3};
    3: Result := rBP{6};
    4: Result := rPOx{4};
    5: Result := rHeight{9};
    6: Result := rWeight{7};
    7: Result := rBMI{8};
    8: Result := rPain{14};
    9: Result := 0;
    10:Result := 0;
    11:Result := 0;
    12:Result := rGirth{11};// CVP
    13:Result := rCVP{12};// CVP
    14:Result := rIntake{13};// In
    15:Result := rOutput{14};// Out

  else
    if GraphIndex < 9 then
      Result := GridRowByGraphIndex(GraphIndex)
    else
      Result := 0;
  end;
end;

procedure TfraGMV_GridGraph.SetStyle(aStyle:String);
begin
  splGridGraph.Align := alTop;
  pnlGrid.Align := alBottom;
  pnlGraph.Align := alClient;
  splGridGraph.Align := alBottom;

  pnlDateRangeTop.Visible := True;
  pnlTitle.Visible := aStyle <> fsVitals;

  if aStyle = fsVitals then
    pnlGrid.Constraints.MaxHeight := pnlGridTop.Height +
      (grdVitals.RowCount+1) * (grdVitals.RowHeights[0]+grdVitals.GridLineWidth);

  FStyle := aStyle;
end;

procedure TfraGMV_GridGraph.setUpFrame;

  function GridHeight:Integer;
  var
    i: Integer;
  begin
    Result := 0;
    for i := 0 to grdVitals.RowCount - 1 do
      Result := Result + grdVitals.RowHeights[i]+grdVitals.GridLineWidth;
  end;

begin
  if FrameInitialized then  Exit;

  with grdVitals do
    begin
{$IFDEF PATCH_5_0_23}
      RowCount := 18;
{$ELSE}
      RowCount := 17;
{$ENDIF}
      DefaultRowHeight := 15;
      DefaultColWidth := 100;
      ColWidths[0] := 100;
      Cells[0, rTemp{1}] := ' Temp:';
      Cells[0, rPulse{2}] := ' Pulse:';
      Cells[0, rResp{3}] := ' Resp:';
      Cells[0, rPOx{4}] := ' P Ox %:'; //AAN 2003/06/03
      Cells[0, rPOx+1{5}] := ' L/Min/%:';
      Cells[0, rBP{6}] := ' B/P:';
      Cells[0, rWeight{7}] := ' Wt (lbs):';
      Cells[0, rBMI{8}] := ' BMI:';
      Cells[0, rHeight{9}] := ' Ht (in):';
      Cells[0, rGirth{10}] := ' C/G:';
      Cells[0, rCVP{11}] := ' CVP (cmH2O):';
      Cells[0, rIntake{12}] := ' In 24hr (ml):';
      Cells[0, rOutput{13}] := ' Out 24hr (ml):';
      Cells[0, rPain{14}] := ' Pain:';

      Cells[0, rLocation{15}] := 'Location:';
      Cells[0, rEnteredBy{16}] := 'Entered By:';
{$IFDEF PATCH_5_0_23}
      Cells[0, rSource] := 'Data Source:';
{$ENDIF}
      Height :=(DefaultRowHeight * RowCount) + (GridLineWidth * (RowCount+3)) +
        GetSystemMetrics(SM_CYVSCROLL);

      if FrameStyle <> fsVitals then
        pnlGrid.Height := pnlGridTop.Height + (DefaultRowHeight * RowCount) +
          (GridLineWidth * (RowCount+3)) + GetSystemMetrics(SM_CYVSCROLL);

      Invalidate;
    end;

  lbDateRange.Items.Add('TODAY');
  lbDateRange.Items.Add('T-1');
  lbDateRange.Items.Add('T-2');
  lbDateRange.Items.Add('T-3');
  lbDateRange.Items.Add('T-4');
  lbDateRange.Items.Add('T-5');
  lbDateRange.Items.Add('T-6');
  lbDateRange.Items.Add('T-7');
  lbDateRange.Items.Add('T-15');
  lbDateRange.Items.Add('T-30');
  lbDateRange.Items.Add('Six Months');
  lbDateRange.Items.Add('One Year');
  lbDateRange.Items.Add('Two Years');
  lbDateRange.Items.Add('All Results');
  lbDateRange.Items.Add(sDateRange);  //zzzzzzandria 050421


  cbxGraph.Items.Add(sgnTemp);
  cbxGraph.Items.Add(sgnPulse);
  cbxGraph.Items.Add(sgnResp);
  cbxGraph.Items.Add(sgnBP);
  cbxGraph.Items.Add(sgnPOX);
  cbxGraph.Items.Add(sgnHeight);
  cbxGraph.Items.Add(sgnWeight);
  cbxGraph.Items.Add(sgnBMI);
  cbxGraph.Items.Add(sgnPain);

  cbxGraph.Items.Add(sgnHW);
  cbxGraph.Items.Add(sgnTRP);
  cbxGraph.Items.Add(sgnBPWeight);

  cbxGraph.Items.Add(sgnGirth);
  cbxGraph.Items.Add(sgnCVP);
  cbxGraph.Items.Add(sgnIn);
  cbxGraph.Items.Add(sgnOutput);

  iIgnoreGraph := 21;

  bLabelSHow := False;
  Inc(iIgnoreCount);
  GraphIndex := 1;
  Dec(iIgnoreCount);
  cbxGraph.ItemIndex := 1;

  if Assigned(MDateTimeRange) then
    try
      lbDateRange.Items.Add(MDateTimeRange.getSWRange);
      lbDateRange.ItemIndex := lbDateRange.Items.IndexOf(MDateTimeRange.getSWRange);
    except
    end;

  fSelectedDateTime := 0;
  iIgnoreCount := 0;

  pnlGrid.Constraints.MaxHeight := pnlGridTop.Height + gridHeight;
  grdVitals.ColWidths[0] := pnlDateRange.Width;

{$IFDEF AANTEST}
  sbTest.Visible := True;
  pnlDebug.Visible := True;
{$ENDIF}

  FrameInitialized := True;
end;

// Color frames ================================================================

procedure TfraGMV_GridGraph.cbxGraphExit(Sender: TObject);
begin
  cbxGraph.Color := clTabOut;
  pnlGSelectBottom.Color := pnlGSelect.Color;
  pnlGSelectTop.Color := pnlGSelect.Color;
  pnlGSelectLeft.Color := pnlGSelect.Color;
  pnlGSelectRight.Color := pnlGSelect.Color;
end;

procedure TfraGMV_GridGraph.cbxGraphEnter(Sender: TObject);
begin
  cbxGraph.Color := clTabIn;
  pnlGSelectBottom.Color := clTabIn;
  pnlGSelectTop.Color := clTabIn;
  pnlGSelectLeft.Color := clTabIn;
  pnlGSelectRight.Color := clTabIn;
end;

procedure TfraGMV_GridGraph.lbDateRangeExit(Sender: TObject);
begin
  pnlPBot.Color := clbtnFace;
  pnlPTop.Color := clbtnFace;
  pnlPLeft.Color := clbtnFace;
  pnlPRight.Color := clbtnFace;
end;

procedure TfraGMV_GridGraph.lbDateRangeEnter(Sender: TObject);
begin
  pnlPBot.Color := clTabIn;
  pnlPTop.Color := clTabIn;
  pnlPLeft.Color := clTabIn;
  pnlPRight.Color := clTabIn;
end;

procedure TfraGMV_GridGraph.grdVitalsEnter(Sender: TObject);
begin
  pnlGBot.Color := clTabIn;
  pnlGTop.Color := clTabIn;
  pnlGLeft.Color := clTabIn;
  pnlGRight.Color := clTabIn;
end;

procedure TfraGMV_GridGraph.grdVitalsExit(Sender: TObject);
begin
  pnlGBot.Color := clbtnFace;
  pnlGTop.Color := clbtnFace;
  pnlGLeft.Color := clbtnFace;
  pnlGRight.Color := clbtnFace;
end;

////////////////////////////////////////////////////////////////////////////////

procedure TfraGMV_GridGraph.chrtVitalsBeforeDrawSeries(Sender: TObject);
var
  iLeft,iRight,
  iDelta,
  iMin,iMax: LongInt;

  dBeginPlus, dEndPlus,
  dBegin,dEnd: Double;

  function ValueDateTime(aCol:Integer):Double;
  var
    ss:String;
  begin
    try
      ss := grdVitals.Cells[aCol, rHeader];
      if ss <>'' then
        begin
          ss := ReplaceStr(ss,'-','/');
          if pos(' 24:',sS)>0 then
            ss := piece(ss,' ',1);
          Result := StrToDateTime(ss);
        end
      else
        Result := Now;
    except
      Result := Now;
    end;
  end;

  function yStep:Integer;
  begin
    Result := 0;
    if not chrtVitals.View3d then Exit;

    chrtVitals.CalcSize3dWalls;
    Result := chrtVitals.Height3D div 2;
  end;

  function xStep:Integer;
  begin
    Result := 0;
    if not chrtVitals.View3d then Exit;

    chrtVitals.CalcSize3dWalls;
    Result := chrtVitals.Width3D;
  end;


begin
{$IFDEF LINES}
  Exit;
{$ENDIF}

  if bIgnoreBlueLines then Exit;
  if chrtVitals.View3D then Exit;
  try
    if (grdVitals.ColCount = 2) and
      ((pos(sNoData,grdVitals.Cells[1,0]) = 1)
        or
       (trim(grdVitals.Cells[1,fGridRow])='')
      ) then Exit;
  except
    Exit;
  end;

  dBegin := ValueDateTime(grdVitals.LeftCol);
  if FrameStyle = fsVitals then
    dEnd := ValueDateTime(grdVitals.LeftCol+grdVitals.VisibleColCount)
  else
    dEnd := ValueDateTime(grdVitals.LeftCol+grdVitals.VisibleColCount-1);

  if grdVitals.LeftCol > 1 then
    dBeginPlus := ValueDateTime(grdVitals.LeftCol -1)
  else
    dBeginPlus := dBegin;

  if grdVitals.LeftCol+grdVitals.VisibleColCount< grdVitals.ColCount then
    dEndPlus := ValueDateTime(grdVitals.LeftCol+grdVitals.VisibleColCount)
  else
    dEndPlus := dEnd;

  fXL := (round(chrtVitals.BottomAxis.CalcPosValue(dBegin))+
    round(chrtVitals.BottomAxis.CalcPosValue(dBeginPlus))) div 2
    +xStep;

  fXR := (round(chrtVitals.BottomAxis.CalcPosValue(dEnd)) +
    round(chrtVitals.BottomAxis.CalcPosValue(dEndPlus))) div 2
    +xStep;

//  idelta := round(0.05*(chrtVitals.LeftAxis.Maximum-chrtVitals.LeftAxis.Minimum));
//  if iDelta > 5 then iDelta := 5;
  iDelta := 5;

  iLeft := -1;
  iRight := -1;

  with chrtVitals.Canvas do
    begin
      iMin := chrtVitals.ChartRect.Top+1 + yStep;
      iMax := chrtVitals.ChartRect.Bottom-1 + yStep;
      Pen.Color := clBlue;
      if (fXL > chrtVitals.ChartRect.Left) and (fXL < chrtVitals.ChartRect.Right) then
        begin
          iLeft := fXL+1;
          MoveTo(fXL,iMin);
          LineTo(fXL,iMax);
        end
      else if fXL <= chrtVitals.ChartRect.Left then
        iLeft := chrtVitals.ChartRect.Left + 1;

      if (fXR > chrtVitals.ChartRect.Left) and (fXR < chrtVitals.ChartRect.Right) then
        begin
          iRight := fXR;
          MoveTo(fXR,iMin);
          LineTo(fXR,iMax);
        end
      else if fXR >= chrtVitals.ChartRect.Right then
        iRight := chrtVitals.ChartRect.Right;

      Brush.Color := clSilver;

      if (iLeft > 0) and (iRight > 0) then
        begin
          FillRect(Rect(iLeft,iMin,iRight,iMin+iDelta));
          FillRect(Rect(iLeft,iMax-iDelta,iRight,iMax));
        end;
    end;
end;

//  Unknown ////////////////////////////////////////////////////////////////////

procedure TfraGMV_GridGraph.lbDateRangeMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  cbxDateRangeClick(nil);
end;

procedure TfraGMV_GridGraph.lbDateRangeMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
begin
  i := Y div lbDateRange.ItemHeight + lbDateRange.TopIndex;
  if (i < lbDateRange.Items.Count) and (i>=0) then
    lbDateRange.Hint := lbDateRange.Items[i];
end;

procedure TfraGMV_GridGraph.SaveStatus;

  procedure SaveIntegerItem(aValue:Integer;aName:String);
  var
    s: String;
  begin
    try
      s := IntToStr(aValue);
      setUserSettings(aName,s);
    except
    end;
  end;

  procedure SaveBooleanItem(aValue:Boolean;aName:String);
  begin
    try
      if aValue then setUserSettings(aName,'ON')
      else           setUserSettings(aName,'OFF');
    except
    end;
  end;

begin
  try
    GMVUser.Setting[usGridDateRange] := IntToStr(lbDateRange.ItemIndex);
  except
  end;

  SaveIntegerItem(pnlGrid.Height,'GRIDSIZE');
  SaveIntegerItem(bgColor,'GRAPHCOLOR');

  SaveBooleanItem(pnlGraphOptions.Visible,'GRAPHOPTIONS');
  SaveBooleanItem(cbValues.Checked,'GRAPHOPTIONS-1');
  SaveBooleanItem(ckb3D.Checked,'GRAPHOPTIONS-2');
  SaveBooleanItem(cbAllowZoom.Checked,'GRAPHOPTIONS-3');
  SaveBooleanItem(cbChrono.Checked,'GRAPHOPTIONS-4');

  SaveIntegerItem(GraphIndex,'GRAPH_INDEX');

  SaveIntegerItem(GMVAbnormalText, 'ABNORMALTEXTCOLOR');
  SaveIntegerItem(GMVAbnormalBkgd, 'ABNORMALBGCOLOR');
//  SaveIntegerItem(GMVAbnormalTodayBkgd: integer = 15;
  SaveBooleanItem(GMVAbnormalBold, 'ABNORMALBOLD');
  SaveBooleanItem(GMVAbnormalQuals, 'ABNORMALQUALIFIERS');

  SaveIntegerItem(GMVNormalText, 'NORMALTEXTCOLOR');
  SaveIntegerItem(GMVNormalBkgd, 'NORMALBGCOLOR');;
//  SaveIntegerItem(GMVNormalTodayBkgd: integer = 15;
  SaveBooleanItem(GMVNormalBold, 'NORMALBOLD');
  SaveBooleanItem(GMVNormalQuals, 'NORMALQUALIFIERS');
end;

procedure TfraGMV_GridGraph.RestoreUserPreferences;
var
  s: String;

  function getBoolean(aDefault:Boolean; aName,aTrueString:String):Boolean;
  var
    ss: String;
  begin
    ss := getUserSettings(aName);
    if ss = '' then               //  zzzzzzandria 20090814
      Result := aDefault          //  Remedy 342434
    else                          //
      Result := ss = aTrueString;
  end;

  function getInteger(aDefault:Integer;aName:String):Integer;
  var
    ss: String;
  begin
    ss := getUserSettings(aName);
    if ss = '' then
      Result := aDefault
    else
      try
        Result := StrToIntDef(ss,aDefault);
      except
        Result := aDefault;
      end;
  end;

begin
  s := getUserSettings('GRIDSIZE');
  if s <> '' then pnlGrid.Height := StrToInt(s);

  BGColor := getInteger(clWindow,'GRAPHCOLOR');
  if BGColor = 0 then
    BGColor := clWindow;

  s := getUserSettings('GRAPHOPTIONS');
  pnlGraphOptions.Visible := s <> 'OFF';
  ShowHideGraphOptions1.Checked := s <> 'OFF';
{$IFNDEF DLL}
  if assigned(frmGMV_UserMain) then
    frmGMV_UserMain.ShowHideGraphOptions1.Checked := s <> 'OFF';
{$ENDIF}
  cbValues.Checked := getBoolean(TRUE,'GRAPHOPTIONS-1','ON');

  s := getUserSettings('GRAPHOPTIONS-4');
  inc(iIgnoreCount);
  cbChrono.Checked := s <> 'OFF';
  dec(iIgnoreCount);

  s := getUserSettings('GRAPHOPTIONS-3');
  cbAllowZoom.Checked := s='ON';
  chrtVitals.AllowZoom := s='ON';
  acZoom.Execute;

  s := getUserSettings('GRAPHOPTIONS-2');
  ckb3D.Checked := (s='ON') and cbChrono.Checked;
  ckb3D.Enabled := cbChrono.Checked;

  if FrameStyle = fsVitals then
    begin
      s := getUserSettings('GRAPH_INDEX');
      if s <> '' then
          GraphIndex:= StrToInt(s)
      else
          GraphIndex:= 0;

      GridRow:= GridRowByGraphIndex(GraphIndex);
    end;

  GMVAbnormalText := getInteger(GMVAbnormalText,'ABNORMALTEXTCOLOR');
  GMVAbnormalBkgd := getInteger(GMVAbnormalBkgd, 'ABNORMALBGCOLOR');
//  SaveIntegerItem(GMVAbnormalTodayBkgd: integer = 15;
  GMVAbnormalBold := getBoolean(GMVAbnormalBold, 'ABNORMALBOLD','ON');
  GMVAbnormalQuals := getBoolean(True, 'ABNORMALQUALIFIERS','ON');  //ZZZZZZBELLC  6/2/10

  GMVNormalText := getInteger(GMVNormalText, 'NORMALTEXTCOLOR');
  GMVNormalBkgd := getInteger(GMVNormalBkgd, 'NORMALBGCOLOR');;
//  SaveIntegerItem(GMVNormalTodayBkgd: integer = 15;
  GMVNormalBold := getBoolean(GMVNormalBold, 'NORMALBOLD','ON');
  GMVNormalQuals := getBoolean(True, 'NORMALQUALIFIERS','ON'); //ZZZZZZBELLC 6/2/10

  grdVitals.Invalidate;
end;

procedure TfraGMV_GridGraph.setGraphByABBR(aABBR:String);
var
  aRow: Integer;
begin
  if aABBR = 'BMI' then aRow := rBMI{8} // zzzzzzandria 060913 BMI selection
  else
    case VitalTypeByABBR(aABBR) of
      vtTemp:aRow := rTemp{1};
      vtPulse:aRow := rPulse{2};
      vtResp: aRow := rResp{3};
      vtPO2: aRow := rPOx{4};
      vtBP: aRow := rBP{6};
      vtHeight: aRow := rHeight{9};
      vtWeight: aRow := rWeight{7};
  //    vtBMI: aRow := 8; // zzzzzzandria 060913 BMI selection
      vtCircum: aRow := rGirth{10};
      vtCVP: aRow := rCVP{11};
  //    vtIn: aRow := 8;
  //    vtOutput: aRow := 8;
      vtPain: aRow := rPain{14};
    else
      aRow := 0;
    end;

  grdVitals.Invalidate;

  getGraphByName(GraphNameByGridRow(aRow));
  if GraphIndexByGridRow(aRow) <> iIgnoreGraph then
    fGridRow := aRow;
  GraphIndex := GraphIndexByGridRow(aRow);
  grdVitals.Invalidate;
end;

procedure TfraGMV_GridGraph.chrtVitalsClickLegend(Sender: TCustomChart;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ShowGraphReport;
end;

procedure TfraGMV_GridGraph.ShowGraphReport;
var
  bData: Boolean;
  iActiveSeries: Integer;
  i,j,k,m: Integer;
  sName,sLocation,
  s,ss,s4: String;
  ST,
  SL: TStringList;
const
  sF = '%-20s';
  sNA = 'N/A';

  function RowByName(aName:String):Integer;
  begin
    Result := -1;
    if (aName = sgnTemp) or (aName = 'Temp.') then   Result := rTemp{1}
    else  if (aName = sgnPulse)
          or (aName = 'Pulse') then Result := rPulse{2}
    else  if (aName = sgnResp)
          or (aName = 'Resp.') then Result := rResp{3}
    else  if (aName = 'Pulse Ox.') then Result := rPOx{4}
    else  if (aName = 'Sys.') then Result := rBP{6}
    else  if (aName = 'Dias.') then Result := -1
    else  if (aName = sgnWeight) then Result := rWeight{7}
    else  if (aName = 'BMI') then Result := rBMI{8}
    else  if (aName = sgnHeight) then Result := rHeight{9}
    else  if (aName = sgnGirth) then Result := rGirth{10}
    else  if (aName = sgnCVP) then Result := rCVP{11}
    else  if (aName = sgnIn) then Result := rIntake{12}
    else  if (aName = sgnOutput) then Result := rOutput{13}
    else  if (aName = sgnPain) then Result := rPain{14}
    ;
  end;

  procedure addTitle;
  var
    s: String; //CB Removed Sl (Remedy 370490)
  begin
    ss := ss + ' ' + Format(sF,['Location'])+Format(sF,['Entered By']);  //CB Added space (Remedy 370490)
    s := '';
    while length(s) < Length(ss) do
      s := s + '-';
    SL.Add(ss);
    SL.Add(s);
  end;

begin
  bData := False;
  iActiveSeries := 0;
  SL := TStringList.Create;
  ST := TStringList.Create;

  ss := Format(sF,['Date/Time']);
  for i := 0 to chrtVitals.SeriesCount - 1 do
    begin
      if not chrtVitals.Series[i].Active then continue;
      inc(iActiveSeries);
      s := chrtVitals.Series[i].Title;
      j := RowByName(s);
      if j < 0 then continue;
      if s = 'Sys.' then s := 'B/P';
      ss := ss + Format(sF,[s]) ;
      ST.Add(Format(sF,[s]));
      ST.Objects[ST.Count-1] := Pointer(j);
      if j = rPOx then
        begin
          ST.Add('');
          ST.Objects[ST.Count-1] := Pointer(rPOx+1{5});
        end;
    end;

  if iActiveSeries = 0 then
    begin
      ShowInfo('Graph Report on '+getPatientName,'The graph is empty',True);
      exit;
    end;

  AddTitle;

  for i := 1 to grdVitals.ColCount - 1 do
    begin
      s := '';
      m := 0;
      for j := 0 to ST.Count - 1 do
        begin
          k := Integer(Pointer(ST.Objects[j]));
          ss := grdVitals.Cells[i, k];
          case k of
            rPOx: s4 := ss;                          // 4
            rPOx+1: s := s + Format(sF,[s4+' '+ss]); // 5
          else
            s := s + Format(sF,[ss]);
          end;
          if k <> 4 then inc(m);
        end;
      if trim(s) <> '' then
        begin
          bData := True;
          sName := grdVitals.Cells[i,rEnteredBy]; if sName = '' then sName := sNA;
          sLocation := grdVitals.Cells[i,rLocation];  if sLocation = '' then sLocation := sNA;

          k := m * 20;
          while (Length(s) > k) and (copy(s,Length(s),1)=' ') and (s<>'') do
            s := copy(s,1,Length(s)-1);
          if Length(s) = k then
            s := s + ' ';
          s := Format(sF,[grdVitals.Cells[i,0]]) + s + Format(sF,[sLocation]);
          k := (m+2) * 20;
          while (Length(s) > k) and (copy(s,Length(s),1)=' ') and (s<>'') do
            s := copy(s,1,Length(s)-1);
          if Length(s) = k then
            s := s + ' ';
          s := s + Format(sF,[sName]);
          SL.Add(s);
        end;
    end;

  if not bData then
    SL.Add('No data available in the graph')
  else
    begin
    //  Patient DOB
    //  Ward and Bed
    //  Page number

      SL.Insert(0,'');
      SL.Insert(0,'Location: '+ lblHospital.Caption); // zzzzzzandria 061116
      SL.Insert(0,ptInfo); // zzzzzzandria 061116
      SL.Insert(0,'Vitals on '+getPatientName+' ('+copy(edPatientInfo.Text,8,4)+')');
    end;
  ShowInfo('Graph Report on '+getPatientName,SL.Text,True);

  SL.Free;
  ST.Free;
end;

procedure TfraGMV_GridGraph.acZoomOutExecute(Sender: TObject);
var
  d: Double;
  i: Integer;
begin
  if chrtVitals.LeftAxis.Maximum > iMaximumLimit then Exit;

  try
    i := StrToIntDef(edZoom.Text,50);
    if i > 100 then i := 100;
    if i = 100 then edZoom.Text := '100';
  except
    begin
      edZoom.Text := '50';
      i := 50;
    end;
  end;

  d := i/100;
  try
    chrtVitals.LeftAxis.Maximum := (1+d) * chrtVitals.LeftAxis.Maximum;
    if chrtVitals.LeftAxis.Minimum >=0 then
      chrtVitals.LeftAxis.Minimum := (1-d) * chrtVitals.LeftAxis.Minimum;
  except
    on E: Exception do
      ShowMessage('Zoom In'+#13#10+E.Message);
  end;
end;

procedure TfraGMV_GridGraph.acZoomInExecute(Sender: TObject);
var
  d: Double;
  i: Integer;
begin
  try
    i := StrToIntDef(edZoom.Text,50);
  except
    begin
      edZoom.Text := '50';
      i := 50;
    end;
  end;
  d := i/100;

  if ((1-d) * chrtVitals.LeftAxis.Maximum >= (1+d) * chrtVitals.LeftAxis.Minimum)  then
    begin
      try
        chrtVitals.LeftAxis.Maximum := (1-d) * chrtVitals.LeftAxis.Maximum;
        if chrtVitals.LeftAxis.Minimum >=0 then
          chrtVitals.LeftAxis.Minimum := (1+d) * chrtVitals.LeftAxis.Minimum;
      except
        on E: Exception do
          ShowMessage('Zoom Out'+#13#10+E.Message);
      end;
    end;
end;

procedure TfraGMV_GridGraph.acZoomResetExecute(Sender: TObject);
begin
  try
    chrtVitals.LeftAxis.Maximum := fAxisMax;
    chrtVitals.LeftAxis.Minimum := fAxisMin;
  except
    on E: Exception do
      ShowMessage('Zoom Reset '+#13#10+E.Message);
  end;
end;

procedure TfraGMV_GridGraph.splGridGraphMoved(Sender: TObject);
begin
  splGridGraph.Align := alTop;
  Application.ProcessMessages;
  splGridGraph.Align := alBottom;
  Application.ProcessMessages;
end;

////////////////////////////////////////////////////////////////////////////////
// debug //
////////////////////////////////////////////////////////////////////////////////
procedure TfraGMV_GridGraph.chrtVitalsDblClick(Sender: TObject);
begin
{$IFDEF AANTEST}
  chrtVitals.CalcSize3DWalls;
  ShowMessage(Format('Width = %d Height = %d',[chrtVitals.Width3d,chrtVitals.Height3D]));
{$ENDIF}
end;

procedure TfraGMV_GridGraph.acUpdateGridColorsExecute(Sender: TObject);
begin
  UpdateUserSettings;
  BGTodayColor := GMVNormalTodayBkgd;
  try
    grdVitals.Refresh;
  except
  end;
end;

////////////////////////////////////////////////////////////////////////////////

procedure TfraGMV_GridGraph.acPatientInfoExecute(Sender: TObject);
begin
  ShowPatientInfo(PatientDFN,'Patient Inquiry for:'+edPatientName.Text +
    '  ' + edPatientInfo.Text); // zzzzzzandria 060308
end;

procedure TfraGMV_GridGraph.pnlPtInfoEnter(Sender: TObject);
begin
  pnlPtInfo.BevelOuter := bvRaised; // zzzzzzandria 060308
end;

procedure TfraGMV_GridGraph.pnlPtInfoExit(Sender: TObject);
begin
  pnlPtInfo.BevelOuter := bvNone; // zzzzzzandria 060308
end;

function TfraGMV_GridGraph.getPatientName:String;
begin
  Result := edPatientName.Text;
end;

function TfraGMV_GridGraph.getPatientInfo:String;
begin
  Result := edPatientInfo.Text;
end;

procedure TfraGMV_GridGraph.showVitalsReport;
var
  sTime, sStart,sEnd,sLine, s,sItem,sVal: String;
  j,iEnd,iCount,iStart,iStartLine,i: integer;
begin
  s := '';
  iCount := 0;
  iStartLine := grdVitals.LeftCol + 2;
  iStart := 1;
  iEnd := grdVitals.ColCount-1;

  for i := iStart to iEnd do
    begin
      if (i = iStart) then
        sStart := grdVitals.Cells[i,0];
      if (i = iEnd) then
        sEnd := grdVitals.Cells[i,0];

      sTime := Format(' %s',[grdVitals.Cells[i,0]]);
      sVal := '';
      sLine := '';
      for j := 1 to grdVitals.RowCount - 1 do
        begin
          sItem := grdVitals.Cells[i,j];
          if trim(sItem)<>'' then
            begin
              sLine := sLine + Format(' %s %s;',[grdVitals.Cells[0,j],sItem]);
              sVal := sVal + sItem;
            end;
        end;

      if Trim(sLine) <> '' then  // R141401 - zzzzzzandria 060921 --------------
        s := s + sTime + sLine + #13#10;
      if sVal <> '' then inc(iCount);
    end;
  if trim(lblHospital.Caption) <> '' then
    sLine := lblHospital.Caption
  else
    sLine := 'no location selected';

  s := 'Patient Location: '+ sLine  +#13#10 +
    'Date Range: '+lblDateFromTitle.Caption + #13#10 +
    'The following '+IntToStr(iCount)+
    ' lines are currently visible in the data grid display.'+#13#10 + s;

  ShowInfo('Data Grid Report for '+getPatientName+ ' ' + getPatientInfo,s, False,iStartLine);
end;

procedure TfraGMV_GridGraph.acVitalsReportExecute(Sender: TObject);
begin
  ShowVitalsReport;
end;

procedure TfraGMV_GridGraph.pnlPtInfoMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  pnlPtInfo.BevelOuter := bvLowered; // zzzzzzandria 060308
end;

procedure TfraGMV_GridGraph.pnlPtInfoMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  pnlPtInfo.BevelOuter := bvNone; // zzzzzzandria 060308
  acPatientInfo.Execute;
end;
// R144771 (Zoom distorts Graph display
//      Series.Marks.Clipped set to True
//      Chart ClipPoints set to True
procedure TfraGMV_GridGraph.grdVitalsMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  Column, Row: Longint;
begin // 141396 - Scroll data cells
  grdVitals.MouseToCell(X, Y, Column, Row);
  if (Column < 0) or (Row < 0) then exit; //ZZZZZZBELLC
  if (Column <= grdVitals.ColCount - 1) and (Row <= grdVitals.RowCount - 1) then
    try
      grdVitals.Hint := '  ' + grdVitals.Cells[Column,Row];
    except
    end;
end;

procedure TfraGMV_GridGraph.acRPCLogExecute(Sender: TObject);
begin
  ShowRPCLog;
end;

procedure TfraGMV_GridGraph.acShowGraphReportExecute(Sender: TObject);
begin
  ShowGraphReport;
end;

end.

