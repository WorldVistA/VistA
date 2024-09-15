unit fODAnatPath;

interface

uses
  WinProcs, Winapi.Messages, System.SysUtils, System.Classes, System.Actions,
  System.TypInfo, System.Generics.Collections, System.StrUtils, Vcl.ActnList,
  Vcl.Menus, Vcl.ComCtrls, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Samples.Spin, Vcl.Graphics, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, uConst,
  ORfn, ORNet, ORCtrls, ORDtTm, VAUtils, VA508AccessibilityManager, fODBase,
  mODAnatPathBuilder, mODAnatPathSpecimen, oODAnatPath, u508Extensions,
  ORExtensions;

type
  TOrderPrompt = (opURG,opCDT,opSSB,opCTY,opHOF,opSPH,opODC);

  TfrmODAnatPath = class(TfrmODBase)
    lblAvailTest: TLabel;
    cbxAvailTest: TORComboBox;
    mnuMessagePopup: TPopupMenu;
    mnuViewinReportWindow: TMenuItem;
    pnlTabs: TPanel;
    pgctrlSpecimen: TPageControl;
    pgctrlText: TPageControl;
    lblUrgency: TLabel;
    cbxUrgency: TORComboBox;
    lblORDateBox: TLabel;
    calCollTime: TORDateBox;
    lblCollectionType: TLabel;
    cbxCollType: TORComboBox;
    lblOften: TLabel;
    cbxFrequency: TORComboBox;
    lblSurgeon: TLabel;
    cbxPtProvider: TORComboBox;
    pnlTotal: TPanel;
    pnlDoseDraw: TPanel;
    lblDose: TLabel;
    lblDraw: TLabel;
    pnlAntiCoagulation: TPanel;
    pnlUrineVolume: TPanel;
    lblUrineVolume: TLabel;
    pnlPeakTrough: TPanel;
    lblPeakTrough: TLabel;
    pnlOrderComment: TPanel;
    spnedtUrineVolume: TSpinEdit;
    calDoseTime: TORDateBox;
    calDrawTime: TORDateBox;
    rbtnUrineML: TRadioButton;
    rbtnUrineCC: TRadioButton;
    rbtnUrineOZ: TRadioButton;
    cbxSpecimenSelect: TORComboBox;
    lvwSpecimen: ORExtensions.TListView;
    pnlAddSingleSpecimen: TKeyClickPanel;
    aPageNav: TActionList;
    aCtrlTab: TAction;
    aCtrlShiftTab: TAction;
    edtPeakComment: TEdit;
    VA508Urgency: TVA508ComponentAccessibility;
    VA508CollectionDT: TVA508ComponentAccessibility;
    VA508Submitted: TVA508ComponentAccessibility;
    VA508CollectionType: TVA508ComponentAccessibility;
    VA508Frequency: TVA508ComponentAccessibility;
    VA508HowLong: TVA508ComponentAccessibility;
    VA508Orders: TVA508ComponentAccessibility;
    VA508Surgeon: TVA508ComponentAccessibility;
    VA508OrderComment: TVA508ComponentAccessibility;
    VA508SampleDrawn: TVA508ComponentAccessibility;
    VA508UrineVolume: TVA508ComponentAccessibility;
    VA508Anticoagulant: TVA508ComponentAccessibility;
    VA508DoseTime: TVA508ComponentAccessibility;
    VA508DrawTime: TVA508ComponentAccessibility;
    VA508PageControl: TVA508ComponentAccessibility;
    gpMain: TGridPanel;
    lblSubmittedBy: TLabel;
    edtSubmittedBy: TEdit;
    lblEmpry: TLabel;
    lblHowLong: TLabel;
    edtDays: TEdit;
    rbPeak: TRadioButton;
    rbTrough: TRadioButton;
    rbMid: TRadioButton;
    rbUnknown: TRadioButton;
    pnlSpecMessage: TPanel;
    lblSpecMessage: TLabel;
    lblAnticoag: TLabel;
    edtAnticoag: TEdit;
    lblOrderComment: TLabel;
    edtOrderComment: TEdit;
    VA508cbxSpecimenSelect: TVA508ComponentAccessibility;
    procedure VA508CaptionQuery(Sender: TObject; var Text: string);
    procedure VA508SurgeonValueQuery(Sender: TObject; var Text: string);
    procedure VA508GenericCaptionQuery(Sender: TObject; var Text: string);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cmdAcceptClick(Sender: TObject);
    procedure cbxAvailTestEnter(Sender: TObject);
    procedure cbxAvailTestClick(Sender: TObject);
    procedure cbxAvailTestKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure cbxAvailTestChange(Sender: TObject);
    procedure cbxAvailTestExit(Sender: TObject);
    procedure mnuViewinReportWindowClick(Sender: TObject);
    procedure cbxUrgencyChange(Sender: TObject);
    procedure calCollTimeDateDialogClosed(Sender: TObject);
    procedure calCollTimeExit(Sender: TObject);
    procedure edtSubmittedbyExit(Sender: TObject);
    procedure cbxCollTypeChange(Sender: TObject);
    procedure cbxFrequencyChange(Sender: TObject);
    procedure edtDaysChange(Sender: TObject);
    procedure cbxPtProviderChange(Sender: TObject);
    procedure cbxPtProviderNeedData(Sender: TObject; const StartFrom: string;
      Direction, InsertAt: Integer);
    procedure ledtOrderCommentExit(Sender: TObject);
    procedure rgrpCommentPeakTroughClick(Sender: TObject);
    procedure edtPeakCommentExit(Sender: TObject);
    procedure CommentUrineVolumeChange(Sender: TObject);
    procedure ledtCommentAntiCoagulantExit(Sender: TObject);
    procedure DoseDrawComment(Sender: TObject);
    procedure LegacyExit(Sender: TObject);
    procedure LegacyKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure LegacyKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cbxSpecimenChange(Sender: TObject);
    procedure cbxSpecimenSelectEnter(Sender: TObject);
    procedure cbxSpecimenSelectExit(Sender: TObject);
    procedure cbxSpecimenSelectKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cbxSpecimenSelectMouseClick(Sender: TObject);
    procedure pnlAddSingleSpecimenClick(Sender: TObject);
    procedure lvwSpecimenDblClick(Sender: TObject);
    procedure lvwSpecimenKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure aCtrlTabExecute(Sender: TObject);
    procedure aCtrlShiftTabExecute(Sender: TObject);
    procedure EatCarrots(Sender: TObject; var Key: Char);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormResize(Sender: TObject);
    procedure lvwSpecimenClick(Sender: TObject);
    procedure lvwSpecimenChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure pgctrlSpecimenEnter(Sender: TObject);
    procedure pnlFocusEnter(Sender: TObject);
    procedure pnlFocusExit(Sender: TObject);
    procedure VA508PageControlInstructionsQuery(Sender: TObject;
      var Text: string);
    procedure VA508cbxSpecimenSelectInstructionsQuery(Sender: TObject;
      var Text: string);
    procedure lblAvailTestClick(Sender: TObject);
  private
    FlblHeight: integer;
    FReqCommentIdx: integer;
    FMaxDays: Integer;
    FOrderChanging: Boolean;
    FSpecimenChanging: Boolean;
    FUserHasLRLABKey: Boolean;
    FOrderAction: Integer;
    FAList: TStringList;
    FCmtTypes: TStringList;
    FEvtDelayLoc: Integer;
    FEvtDivision: Integer;
    FLastLabIEN: Integer;
    FChangeMessage: string;
    FApplicationMessage: TMessageEvent;
    bSuppressCollectDialog: Boolean;
    FDropDownSpecs: boolean;
    FSpecSelectRedirectTabStop: boolean;
    flv508Manager: Tlv508Manager;
    FAccessData: string;
    FMissingGroupsMessage: string;
    procedure UMDeleteSpecimen(var Message: TMessage); message UM_OBJDESTROY;
    procedure UMMisc(var Message: TMessage); message UM_MISC;
    procedure ToggleControlEnable(cControl: TControl; bSwitch: Boolean);
    procedure ToggleChildControls(pnl: TPanel; bSwitch: Boolean);
    procedure ToggleEnableLegacy(bSwitch: Boolean);
    procedure UpdateAllOrderResponses;
    procedure UpdateAllLegacyResponses(bUpdate: Boolean);
    procedure UpdateLegacyCommentResponse(bUpdate: Boolean);
    procedure ResetOrderGrid;
    procedure BuildOrderGrid;
    procedure AlterContainerCaption(pnl: TPanel; bReq: Boolean);
    procedure AlterCaption(lbl: TCustomLabel; bReq: Boolean);
    procedure UpdateOrderElement(sID,sHide,sReq,sDef: string);
    procedure OrderCommentReset;
    procedure MouseDetect(var Msg: TMsg; var Handled: Boolean);
    procedure BuildPages;
    procedure GetAllSpecimens;
    procedure SetupCollTimes(sCollType: string);
    procedure SetSpecimenActiveSelected;
    procedure ResetGrid;
    function GetPeakGroupIdx: integer;
    function GetPeakGroupTxt: string;
    procedure ForceToFitScreen;
    procedure DropDownSpecimens(Sender: TObject);
  protected
    procedure Enhancements508;
    procedure InitVariables;
    procedure InitControls;
    procedure InitDialog; override;
    procedure SpecimenSelectForExisting;
    procedure SpecimenSelectForNew;
    procedure SetUpSpecimen;
    procedure FinalizeChange;
    procedure RestoreCtrls(lbl: TCustomLabel; ctrl: TControl; ACol, ARow: integer);
    procedure ShuffleLeft(lbl: TCustomLabel; ctrl: TControl);
    procedure SetError(const sString: string; var AnErrMsg: string);
    procedure PosX(dDays: Double; iMinutes: Integer; var AnErrMsg: string);
    procedure UrgencyO(sHide,sReq,sDef: string);
    procedure Urgency;
    procedure UrgencyV(var AnErrMsg: string);
    procedure UrgencyP(var sType: string; var sOldVal: string;
      var sNewVal: string; sValue: string);
    procedure CollectionDateTimeO(sHide,sReq,sDef: string);
    procedure CollectionDateTimeV(var AnErrMsg: string);
    procedure SpecimenSubmittedO(sHide,sReq,sDef: string);
    procedure SpecimenSubmitted;
    procedure SpecimenSubmittedV(var AnErrMsg: string);
    procedure SpecimenSubmittedP(var sType: string; var sOldVal: string;
      var sNewVal: string; sValue: string);
    procedure CollectionTypeO(sHide,sReq,sDef: string);
    procedure CollectionType;
    procedure CollectionTypeV(var AnErrMsg: string);
    procedure CollectionTypeP(var sType: string; var sOldVal: string;
      var sNewVal: string; sValue: string);
    procedure FrequencyO(sHide,sReq,sDef: string);
    procedure Frequency;
    procedure FrequencyV(var AnErrMsg: string);
    procedure FrequencyP(var sType: string; var sOldVal: string;
      var sNewVal: string; sValue: string);
    procedure SurgeonPhysicianO(sHide,sReq,sDef: string);
    procedure SurgeonPhysician;
    procedure SurgeonPhysicianV(var AnErrMsg: string);
    procedure SurgeonPhysicianP(var sType: string; var sOldVal: string;
      var sNewVal: string; sValue: string);
    procedure AnticoagulationO(sHide,sReq,sDef: string);
    procedure AnticoagulationV(var AnErrMsg: string);
    procedure AnticoagulationP(var sOldVal: string; var sNewVal: string;
      sValue: string);
    procedure DoseDrawTimesO(sHide,sReq,sDef: string);
    procedure DoseDrawTimesV(var AnErrMsg: string);
    procedure OrderCommentO(sHide,sReq,sDef: string);
    procedure OrderCommentV(var AnErrMsg: string);
    procedure OrderCommentP(var sOldVal: string; var sNewVal: string;
      sValue: string);
    procedure TDMPeakTroughO(sHide,sReq,sDef: string);
    procedure TDMPeakTroughV(var AnErrMsg: string);
    procedure TDMPeakTroughP(var sOldVal: string; var sNewVal: string;
      sValue: string);
    procedure TransfusionO(sHide,sReq,sDef: string);
    procedure TransfusionV(var AnErrMsg: string);
    procedure TransfusionP(var sOldVal: string; var sNewVal: string;
      sValue: string);
    procedure UrineVolumeO(sHide,sReq,sDef: string);
    procedure UrineVolumeV(var AnErrMsg: string);
    procedure UrineVolumeP(var sOldVal: string; var sNewVal: string;
      sValue: string);
    procedure OrderCommentCollectionO(sHide,sReq,sDef: string);
    procedure OrderCommentCollectionV(var AnErrMsg: string);
    procedure OrderCommentCollectionP(var sType: string; var sOldVal: string;
      var sNewVal: string; sValue: string);
    procedure OrderElementsWithinPages;
    procedure SpecimenPages;
    procedure CollectionSamplesV(var AnErrMsg: string);
    procedure WordProcessingPages;
    procedure ResetDialog;
    procedure Validate(var AnErrMsg: string); override;
    procedure Stack(pnl: TPanel; bAction: Boolean);
    procedure Switch(iCmtType: Integer; bAction: Boolean);
    function UrineUnits: string;
    function UniqueSpecimenDescs: Boolean;
    function IsValid: Boolean;
    function DoesPromptIDExist(sPromptID: string): Boolean;
    procedure ShowOrderMessage(Show: boolean); override;
  public
    procedure SetFontSize( FontSize: integer); override;
    procedure SetupDialog(OrderAction: Integer; const ID: string); override;
    procedure LoadRequiredComment(iCmtType: Integer);
    procedure DeleteSpecimenPage(tbsht: TTabSheet);
    procedure UpdatePageCounts;
    procedure UpdateSpecimenResponses(bUpdate: Boolean);
    procedure UpdateSpecimenResponsesQuick(bUpdate: Boolean);
    procedure UpdateTextResponses(bUpdate: Boolean);
    procedure UpdateTextResponsesQuick(bUpdate: Boolean);
    procedure UpdateOrderText;
    procedure ChangeOrderPromptValue(sID,sValue: string);
    function GetSummary: string;
    function GetOrderComment: string;
    function GetCurrentSpecimenForm: TfraAnatPathSpecimen;
    function GetSpecificSpecimenForm(tbsht: TTabSheet): TfraAnatPathSpecimen;
    function GetCurrentPagTextForm: TfraAnatPathBuilder;
    function GetSpecificPageTextForm(tbsht: TTabSheet): TfraAnatPathBuilder;
    property EvtDelayLoc: Integer read FEvtDelayLoc write FEvtDelayLoc;
    property EvtDivision: Integer read FEvtDivision write FEvtDivision;
  end;

  TLabTest = class(TObject)
  private
    FLoadedTestData: TStringList;
    FTestI: string;                                     // Orderable Item IEN
    FTestE: string;
    FLabSubscript: string;
    FUrgencyList: TStringList;                          // IEN^Urgency Name
    FUrgencyI: string;                                  // Urgency IEN
    FUrgencyE: string;
    FCollectDTI: string;                                // Collection Date/Time FileMan
    FCollectDTE: string;
    FSpecSubmitBy: string;
    FCollectTypeI: string;                              // Collection Type IEN
    FCollectTypeE: string;
    FScheduleI: string;                                 // Frequency ID
    FScheduleE: string;
    FHowMany: string;
    FSurgeonI: string;                                  // Surgeon IEN
    FSurgeonE: string;
    FCurReqComment: string;                             // Name of required comment
    FOrderComment: TStringList;
    FSpecimenList: TStringList;                         // IEN^Specimen Name
    FCurWardComment: TStringList;
    RestrictMulti: Boolean;                             // If true then change the specimen selection to "+" after selection
    FLabSpecimenList: TObjectList<TLabSpecimen>;        // List of Objects (TLabSpecimen from fODAnatPathSpecimen)
    FLabTextList: TObjectList<TLabText>;                // List of Objects (TLabText from fODAnatPathBuilder)
    function TextInstance(sPromptID: string; LabText: TLabText): Integer;
  protected
    procedure GetNextResponseInstance(LabSpecimen: TLabSpecimen; sPrompt: string;
      var iInstance: Integer; Responses: TResponses);
    procedure Urgency(Responses: TResponses);
    procedure CollectionDateTime(Responses: TResponses);
    procedure SpecimenSubmitted(Responses: TResponses);
    procedure CollectionType(Responses: TResponses);
    procedure Schedule(Responses: TResponses);
    procedure SurgeonPhysician(Responses: TResponses);
    procedure CollectionSample;
    procedure Specimen(Responses: TResponses);
    function SetDefColl(sIndex: string): string;
  public
    constructor Create(const iLabTestIEN: Integer; Responses: TResponses);
    destructor Destroy; override;
    procedure LoadUrgency(sCollType: string; cbx: TORComboBox);
    procedure LoadSpecimen(cbx: TORComboBox);
    property LoadedTestData: TStringList read FLoadedTestData;
    property OrderableItemInternal: string read FTestI write FTestI;
    property OrderableItemExternal: string read FTestE write FTestE;
    property LabSubscript: string read FLabSubscript write FLabSubscript;
    property UrgencyInternal: string read FUrgencyI write FUrgencyI;
    property UrgencyExternal: string read FUrgencyE write FUrgencyE;
    property CollectionDateTimeInternal: string read FCollectDTI write FCollectDTI;
    property CollectionDateTimeExternal: string read FCollectDTE write FCollectDTE;
    property SpecimenSubmittedBy: string read FSpecSubmitBy write FSpecSubmitBy;
    property CollectionTypeInternal: string read FCollectTypeI write FCollectTypeI;
    property CollectionTypeExternal: string read FCollectTypeE write FCollectTypeE;
    property ScheduleInternal: string read FScheduleI write FScheduleI;
    property ScheduleExternal: string read FScheduleE write FScheduleE;
    property HowMany: string read FHowMany write FHowMany;
    property SurgeonInternal: string read FSurgeonI write FSurgeonI;
    property SurgeonExternal: string read FSurgeonE write FSurgeonE;
    property ReqOrderCommentType: string read FCurReqComment write FCurReqComment;
    property OrderComment: TStringList read FOrderComment write FOrderComment;
    property SpecimenList: TStringList read FSpecimenList;
    property WardComment: TStringList read FCurWardComment;
    property LabSpecimenList: TObjectList<TLabSpecimen> read FLabSpecimenList write FLabSpecimenList;
    property LabTextList: TObjectList<TLabText> read FLabTextList write FLabTextList;
  end;

var
  frmODAnatPath: TfrmODAnatPath;
  ALabTest: TLabTest;
  uDfltCollSamp: string;
  LRFSAMP: string;         // the default sample           (ptr)
  CurrentFocusedwp: TCustomMemo;

implementation

{$R *.DFM}

uses
  rODBase, rODLab, uCore, rCore, fODLabOthSpec, fLabCollTimes, rOrders, uODBase,
  fRptBox, fFrame, rODAnatPath, fODAnatPathPreview, VA508AccessibilityRouter,
  uORLists, uSimilarNames, uFormMonitor, uOrders, uWriteAccess;

const
  CmtType: array[0..6] of string = ('ANTICOAGULATION','DOSE/DRAW TIMES','ORDER COMMENT',
                                    'ORDER COMMENT MODIFIED','TDM (PEAK-TROUGH)',
                                    'TRANSFUSION','URINE VOLUME');
  TX_BAD_TIME       = 'Collection times must be chosen from the drop down list or ' +
                      'entered as valid Fileman date/times (T@1700, T+1@0800, etc.).' ;
  TX_NO_TESTS       = 'A Lab Test MUST be selected.';
  TX_PAST_TIME      = 'Collection times in the past are not allowed.';
  TX_NO_URGENCY     = 'An urgency MUST be specified.';
  TX_NO_TIME        = 'Collection Time is required.';
  TX_NO_SUBMIT_BY   = 'Specimen submitted is required and MUST be specified.';
  TX_NO_IMMED       = 'Immediate collect is not available for this test.';
  TX_NO_LABCOLLECT  = 'Lab collect is not available for this test.';
  TX_NO_TCOLLTYPE   = 'Collection Type is required.';
  TX_NO_FREQUENCY   = 'A collection frequency MUST be specified.';
  TX_NO_ALPHA       = 'For continuous orders, enter a number of days, or an "X" ' +
                      'followed by a number of times.';
  TX_NO_TIMES       = 'A number of times must be entered for continuous orders.';
  TX_TOO_MANY_TIMES = 'For this frequency, the maximum number of times allowed is:  X';
  TX_TOO_MANY_DAYS  = 'Maximum number of days allowed is ';
  TX_NO_SURGEON     = 'Surgeon/Physician is required and MUST be specified.';
  TX_ANTICOAG_REQD  = 'The kind of anticoagulant the patient is on must be specified.';
  TX_DOSEDRAW_REQD  = 'Both DOSE and DRAW times are required for this order.';
  TX_NO_COMMENT     = 'Order comment is required and MUST be specified.';
  TX_TDM_REQD       = 'A value for LEVEL is required for this order.';
  TX_URINE_REQD     = 'A urine volume must be greater than 0.';
  TX_URINE_MEASURE  = 'A urine volume of measurement must be specified.';
  TX_NO_SPECIMEN    = 'A specimen MUST be specified.';
  TX_NO_COLLSAMPLE  = 'A collection sample MUST be specified for each specimen.';
  TX_NO_SPECDESC    = 'A specimen description MUST be specified for each specimen.';
  TX_SPECDESC_UQ    = 'All specimen descriptions MUST be unique.';

  EDIT_BUMP = 8;

var
  uDfltUrgency: string;
  uDfltCollType: string;
  LRFURG: string;          // the default urgency          (number)		TRY '2'
  LRFDATE: string;         // the default collection time  (NOW,NEXT,AM,PM,T...)
  LRFZX: string;           // the default collection type  (LC,WC,SP,I)   *remove LC,I
  LRFSCH: string;          // the default schedule         (ONE TIME, QD, ...)
  LRFSPEC: string;         // the default specimen         (ptr)

function ValidOrderPromptText(sID: string): Boolean;
begin
  Result := False;

  if sID = 'OPURG' then
    Result := True
  else
  if sID = 'OPCDT' then
    Result := True
  else
  if sID = 'OPSSB' then
    Result := True
  else
  if sID = 'OPCTY' then
    Result := True
  else
  if sID = 'OPHOF' then
    Result := True
  else
  if sID = 'OPSPH' then
    Result := True
  else
  if sID = 'OPODC' then
    Result := True;
end;

function ValidOrderPromptID(var sID: string; var opCode: TOrderPrompt): Boolean;
begin
  Result := False;

  if  ValidOrderPromptText(UpperCase(sID)) then
  begin
    Result := True;
    opCode := TOrderPrompt(GetEnumValue(TypeInfo(TOrderPrompt), sID));
  end;
end;

{$REGION 'TfrmODAnatPath'}

procedure TfrmODAnatPath.VA508CaptionQuery(Sender: TObject; var Text: string);
begin
  inherited;

  if TComponent(Sender).Tag > 9 then
  begin
    if Length(Text) > 0 then
      if Text[1] = '*' then
      begin
        Delete(Text, 1, 1);
        Text := 'Required field ' + Text;
      end;
  end
  else
    case TComponent(Sender).Tag of
     1: Text := 'Required field ' + Text;
     2: if lblUrgency.Caption[1] = '*' then
          Text := 'Required field ' + Text;
     3: if lblORDateBox.Caption[1] = '*' then
          Text := 'Required field ' + Text;
     4: if lblSubmittedby.Caption[1] = '*' then
          Text := 'Required field ' + Text;
     5: if lblCollectionType.Caption[1] = '*' then
          Text := 'Required field ' + Text;
     6: if lblOften.Caption[1] = '*' then
          Text := 'Required field ' + Text;
     7: if lblHowLong.Caption[1] = '*' then
          Text := 'Required field ' + Text;
     8: if lblSurgeon.Caption[1] = '*' then
          Text := 'Required field ' + Text;
    end;
end;

procedure TfrmODAnatPath.VA508cbxSpecimenSelectInstructionsQuery(
  Sender: TObject; var Text: string);
begin
  inherited;
  if (cbxSpecimenSelect.Items.Count > 1) then
    Text := 'To select the value use the arrow keys or type the value, then press the enter key'
  else
    Text := 'To create another ' + cbxSpecimenSelect.Text + ' specimen press the enter key';
end;

procedure TfrmODAnatPath.VA508SurgeonValueQuery(Sender: TObject; var Text: string);
begin
  inherited;

  // Prevent JAWS from saying "Graphic"
  // Only seems to happen for TORComoboBox when caption is editable
  if Length(Text) = 0 then
    Text := ' '
  else
    Text := ' ' + Text + ' ';
end;

procedure TfrmODAnatPath.VA508GenericCaptionQuery(Sender: TObject; var Text: string);
var
  sText: string;
begin
  inherited;
  if TComponent(Sender).Tag = 99 then
  begin
    sText := pgctrlText.ActivePage.Caption;
    if Length(sText) > 0 then
      if sText[1] = '*' then
      begin
        Delete(sText, 1, 1);
        Text := 'Required field ' + sText;
      end;
  end
  else
  if Length(Text) > 0 then
  begin
    if Text[1] = '*' then
    begin
      Delete(Text, 1, 1);
      Text := 'Required field ' + Text;
    end;
  end;
end;

procedure TfrmODAnatPath.VA508PageControlInstructionsQuery(Sender: TObject;
  var Text: string);
begin
  inherited;
  if pgctrlText.PageCount > 1 then
    Text := 'Use the left and right arrow keys to change tabs'
  else
    Text := 'There are no other tabs';
end;

procedure TfrmODAnatPath.FormCreate(Sender: TObject);
var
  access: TWriteAccess.TDGWriteAccess;

  procedure Setup(Ctrl: TControl; Col, Row, ColSpan, RowSpan: integer);
  var
    ci: TControlItem;

  begin
    Ctrl.Parent := gpMain;
    gpMain.ControlCollection.AddControl(Ctrl, Col, Row);
    ci := gpMain.ControlCollection.Items[gpMain.ControlCollection.Indexof(Ctrl)];
    ci.ColumnSpan := ColSpan;
    ci.RowSpan := RowSpan;
    Ctrl.Align := alClient;
  end;

begin
  gpMain.ControlCollection.BeginUpdate;
  try
    // must add to grid at runtime because they are inherited components
    Setup(memOrder, 0, 14, 4, 2);
    Setup(cmdAccept, 4, 14, 1, 1);
    Setup(cmdQuit, 4, 15, 1, 1);
    Setup(pnlMessage, 0, 16, 4, 1);
  finally
    gpMain.ControlCollection.EndUpdate;
  end;
  gpMain.RowCollection.BeginUpdate;
  try
    gpMain.RowCollection[11].Value := 0;
    gpMain.RowCollection[12].Value := 50;
    gpMain.RowCollection[13].Value := 50;
  finally
    gpMain.RowCollection.EndUpdate;
  end;

  frmFrame.pnlVisit.Enabled := False;
  AutoSizeDisabled := True;
  FReqCommentIdx := 7;

  inherited;

  access := WriteAccessV.DGWriteAccess('AP');
  if assigned(access) and (access is TWriteAccess.TDGWriteAccessParent) then
    with TWriteAccess.TDGWriteAccessParent(access) do
    begin
      FAccessData := AccessData;
      if MissingGroups <> '' then
      begin
        FMissingGroupsMessage := 'Only orders for ' + AccessGroups +
          ' are displayed.  Additional orders would be available if you had write access to '
          + MissingGroups;
        gpMain.RowCollection[0].Value := gpMain.RowCollection[0].Value + 4;
        lblAvailTest.Font.Color := clBlue;
        lblAvailTest.Font.Style := [fsUnderline];
        lblAvailTest.Cursor := crHandPoint;
      end;
    end;

  frmODAnatPath := Self;

  calCollTime.Format := 'mmm dd,yyyy@hh:nn';
  FAList := TStringList.Create;

  // To detect mouse click position to, if the wp field has been expanded
  // close it, if not clicked within the wp area
  FApplicationMessage   := Application.OnMessage;
  Application.OnMessage := MouseDetect;

  InitVariables;

  StatusText('Loading Dialog Definition');
  Responses.Dialog := 'LR OTHER LAB AP TESTS';                                  // Loads formatting info
  StatusText('Loading Default Values');

  if EvtID > 0 then
  begin
    EvtDelayLoc := StrToIntDef(GetEventLoc1(IntToStr(EvtID)), 0);
    EvtDivision := StrToIntDef(GetEventDiv1(IntToStr(EvtID)), 0);
    if EvtDelayLoc > 0 then
      getODForLab(FAList,EvtDelayLoc, EvtDivision)
    else
      getODForLab(FAList,Encounter.Location, EvtDivision);
  end
  else
    getODForLab(FAList,Encounter.Location,0);                           // ODForLab returns TStrings with defaults

  if EvTDelayLoc > 0 then
    FMaxDays := MaxDays(EvtDelayLoc, 0)
  else
    FMaxDays := MaxDays(Encounter.Location, 0);

  CtrlInits.LoadDefaults(FAList);
  InitDialog;

  SubSetOfAPOrderItems(cbxAvailTest.Items, Responses.QuickOrder, FAccessData);

  StatusText('');
  SetFontSize(MainFontSize);
  FDropDownSpecs := False;
  FSpecSelectRedirectTabStop := False;
  if ScreenReaderActive then
  begin
    fLV508Manager := Tlv508Manager.Create;
    amgrMain.ComponentManager[lvwSpecimen] := fLV508Manager;
  end
  else
    FormMonitorBringToFrontEvent(Self, DropDownSpecimens, 1);
end;

procedure TfrmODAnatPath.FormShow(Sender: TObject);
begin
  inherited;
  if cbxAvailTest.enabled then
    cbxAvailTest.SetFocus;
  Enhancements508;
end;

procedure TfrmODAnatPath.ForceToFitScreen;
var
  Rect: TRect;
  mh, mw: integer;

begin
  mh := Constraints.MinHeight;
  mw := Constraints.MinWidth;
  Constraints.MinHeight := 0;
  Constraints.MinWidth := 0;
  ForceInsideWorkArea(Self);
  Rect := BoundsRect;
  if mh > Rect.Height then
    mh := Rect.Height;
  if mw > Rect.Width then
    mw := Rect.Width;
  Constraints.MinHeight := mh;
  Constraints.MinWidth := mw;
end;

procedure TfrmODAnatPath.FormClose(Sender: TObject; var Action: TCloseAction);
var
  I: Integer;
begin
  inherited;
  if ScreenReaderActive then
  begin
    if assigned(fLV508Manager) then
    begin
      amgrMain.ComponentManager[lvwSpecimen] := nil;
      FreeAndNil(flv508Manager);
    end;
  end
  else
  begin
    FormMonitorBringToFrontEvent(Self, nil);
  end;

  Application.OnMessage := FApplicationMessage;

  FAList.Free;
  FCmtTypes.Free;

  // Word Processing Pages
  for I := pgctrlText.PageCount - 1 downto 0 do
    pgctrlText.Pages[I].Free;

  // Specimen Pages
  cbxSpecimenSelect.Clear;
  lvwSpecimen.Clear;
  for I := pgctrlSpecimen.PageCount - 1 downto 0 do
    pgctrlSpecimen.Pages[I].Free;
  UpdatePageCounts;

  FreeandNil(ALabTest);
  Responses.Clear;
  frmFrame.pnlVisit.Enabled := True;
end;

procedure TfrmODAnatPath.cmdAcceptClick(Sender: TObject);
begin
  UpdateAllOrderResponses;

  if not IsValid then
    Exit;

  frmAnatPathPreview := TfrmAnatPathPreview.Create(Self);
  try
    frmAnatPathPreview.ShowModal;
    if frmAnatPathPreview.ModalResult = mrOk then
    begin
      OnCloseQuery := nil;
      UpdateAllLegacyResponses(False);
    end
    else
      Exit;
  finally
    frmAnatPathPreview.Free;
  end;

  FLastLabIEN := 0;

  inherited;
end;

procedure TfrmODAnatPath.cbxAvailTestEnter(Sender: TObject);
begin
  inherited;

  FOrderChanging := True;
end;

procedure TfrmODAnatPath.cbxAvailTestClick(Sender: TObject);
begin
  inherited;

  if FOrderChanging then
  begin
    FOrderChanging := False;
    cbxAvailTestChange(Sender);
  end;
end;

procedure TfrmODAnatPath.cbxAvailTestKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;

  FOrderChanging := True;

  if Key = VK_LEFT then
    Key := VK_UP;
  if Key = VK_RIGHT then
    Key := VK_DOWN;
  if Key = VK_RETURN then
    FOrderChanging := False;
end;

procedure TfrmODAnatPath.cbxAvailTestChange(Sender: TObject);
var
  idx: integer;

begin
  inherited;

  if FOrderChanging then
    Exit;
  if (cbxAvailTest.ItemIEN < 1) or (cbxAvailTest.ItemIEN = FLastLabIEN) then
    Exit;

  if FLastLabIEN > 0 then
    if ShowMsg('The current action will reset this form - press YES to CONTINUE.',
               smiWarning, smbYesNo) <> smrYes then
    begin
      cbxAvailTest.SelectByIEN(FLastLabIEN);
      Exit;
    end;

  Changing := True;
  try
    pgctrlSpecimen.LockDrawing;
    try
      pgctrlText.LockDrawing;
      try
        FLastLabIEN := cbxAvailTest.ItemIEN;
        if not (FOrderAction in [ORDER_COPY, ORDER_EDIT, ORDER_QUICK]) then
          Responses.Clear;
        ResetDialog;

        ALabTest := TLabTest.Create(FLastLabIEN, Responses);

        // VISTAOR-25898
        if ALabTest.OrderableItemExternal = 'URINE' then
        begin
          idx := cbxCollType.SelectByID('LC');
          if idx > -1 then
            cbxCollType.Items.Delete(idx);
        end;

        ALabTest.LoadSpecimen(cbxSpecimenSelect);

        StatusText('Loading Test Specific Data');
        BuildOrderGrid;                                                         // *** Lab Order Prompt Grid
        BuildPages;                                                             // *** Word Processing Pages
        OrderMessage(ALabTest.WardComment.Text);                                // *** Ward Comment
        // *** Message used if Builders change the value of another based on it's own
        FChangeMessage := CustomChangeMessage(ALabTest.OrderableItemInternal);
        SetUpSpecimen;                                                          // *** Specimen
      finally
        pgctrlText.UnlockDrawing;
      end;
    finally
      pgctrlSpecimen.UnlockDrawing;
    end;
  finally
    Changing := False;
    StatusText('');
  end;
  FinalizeChange;
  if ScreenReaderActive then
    GetScreenReader.Speak(cbxAvailTest.Text + ' selected');
end;

procedure TfrmODAnatPath.cbxAvailTestExit(Sender: TObject);
begin
  inherited;

  FOrderChanging := True;
  if cbxAvailTest.ItemIEN <> FLastLabIEN then
    cbxAvailTest.SelectByIEN(FLastLabIEN);
  FOrderChanging := False;

  cbxSpecimenSelect.DroppedDown := False;
end;

procedure TfrmODAnatPath.mnuViewinReportWindowClick(Sender: TObject);
begin
  inherited;

  ReportBox(memMessage.Lines, 'Lab Procedure (Anatomic Pathology)', True);
end;

procedure TfrmODAnatPath.cbxUrgencyChange(Sender: TObject);
begin
  inherited;

  if ALabTest = nil then
    Exit;

  ALabTest.UrgencyInternal := IntToStr(cbxUrgency.ItemIEN);
  ALabTest.UrgencyExternal := cbxUrgency.Text;

  UpdateAllLegacyResponses(True);
end;

procedure TfrmODAnatPath.calCollTimeDateDialogClosed(Sender: TObject);
begin
  inherited;

  calCollTimeExit(nil);
end;

procedure TfrmODAnatPath.calCollTimeExit(Sender: TObject);
var
  sTime: string;
begin
  inherited;

  if ALabTest = nil then
    Exit;

  calCollTime.Text := Trim(calCollTime.Text);
  sTime := calCollTime.Text;

  try
    try
      if calCollTime.IsValid then
      begin
        if Piece(sTime,'@',2) = '00:00' then
          calCollTime.Text := Piece(sTime,'@',1);

        if (sTime = 'TODAY') or IsNow(sTime) or (sTime = 'NOON') or (sTime = 'MID') then
          ALabTest.CollectionDateTimeInternal := calCollTime.Text
        else
          ALabTest.CollectionDateTimeInternal := FloatToStr(calCollTime.FMDateTime);

        ALabTest.CollectionDateTimeExternal := calCollTime.Text;
      end;
    except
      ALabTest.CollectionDateTimeInternal := '0';
      ALabTest.CollectionDateTimeExternal := '';

      calCollTime.Text := '';

      if not Changing then
        ShowMsg(TX_BAD_TIME);
    end;
  finally
    UpdateAllLegacyResponses(True);
  end;
end;

procedure TfrmODAnatPath.edtSubmittedbyExit(Sender: TObject);
begin
  inherited;

  if ALabTest = nil then
    Exit;

  ALabTest.SpecimenSubmittedBy := Trim(edtSubmittedby.Text);

  UpdateAllLegacyResponses(True);
end;

procedure TfrmODAnatPath.cbxCollTypeChange(Sender: TObject);
begin
  inherited;

  if ALabTest = nil then
    Exit;

  SetupCollTimes(cbxCollType.ItemID);
  calCollTimeExit(Sender);
  ALabTest.LoadUrgency(cbxCollType.ItemID, cbxUrgency);

  ALabTest.CollectionTypeInternal := cbxCollType.ItemID;
  ALabTest.CollectionTypeExternal := cbxCollType.Text;

  UpdateAllLegacyResponses(True);
end;

procedure TfrmODAnatPath.cbxFrequencyChange(Sender: TObject);
var
  sHowMany: string;
begin
  inherited;

  if ALabTest = nil then
    Exit;

  if FMaxDays < 0 then
  begin
    edtDays.Text := '';
    edtDays.Enabled := False;
    lblHowLong.Enabled := False;
    sHowMany := 'no value';
    edtDays.ShowHint := False;
    if cbxFrequency.ItemIndex <> -1 then
    begin
      ALabTest.ScheduleInternal := cbxFrequency.ItemID;
      ALabTest.ScheduleExternal := cbxFrequency.Text;
      ALabTest.HowMany := '';
    end;
    Exit;
  end;

  if ((cbxFrequency.ItemIndex <> -1) and
      (Piece(cbxFrequency.Items[cbxFrequency.ItemIndex],U,3) <> 'O')) then
  begin
    edtDays.Enabled := True;
    lblHowLong.Enabled := True;
    if Piece(cbxFrequency.Items[cbxFrequency.ItemIndex],U,3) = 'C' then
      edtDays.Hint := 'Enter a number of days, or an "X" followed by a number of times.'
    else
      edtDays.Hint := '';

    if edtDays.Text = '' then
      sHowMany := 'no value'
    else
      sHowMany := edtDays.Text;
    edtDays.Showhint := True;
  end
  else
  begin
    edtDays.Text := '';
    edtDays.Enabled := False;
    lblHowLong.Enabled := False;
    sHowMany := 'no value';
    edtDays.ShowHint := False;
  end;

  if cbxFrequency.ItemIndex <> -1 then
  begin
    ALabTest.ScheduleInternal := cbxFrequency.ItemID;
    ALabTest.ScheduleExternal := cbxFrequency.Text;
  end;

  UpdateAllLegacyResponses(True);
end;

procedure TfrmODAnatPath.edtDaysChange(Sender: TObject);
begin
  inherited;

  if ALabTest = nil then
    Exit;

  if FMaxDays < 0 then
    ALabTest.HowMany := ''
  else
    ALabTest.HowMany := edtDays.Text;

  UpdateAllLegacyResponses(True);
end;

procedure TfrmODAnatPath.cbxPtProviderChange(Sender: TObject);
begin
  inherited;

  if ALabTest = nil then
    Exit;

  ALabTest.SurgeonInternal := IntToStr(cbxPtProvider.ItemIEN);
  ALabTest.SurgeonExternal := cbxPtProvider.Text;

  UpdateAllLegacyResponses(True);
end;

procedure TfrmODAnatPath.cbxPtProviderNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
begin
  setProviderList(cbxPtProvider, StartFrom, Direction);
end;

procedure TfrmODAnatPath.ledtOrderCommentExit(Sender: TObject);
begin
  inherited;

  if ALabTest = nil then
    Exit;

  ALabtest.OrderComment.Clear;
  if Trim(edtOrderComment.Text) <> '' then
  begin
    ALabtest.OrderComment.Add('~For Test: ' + ALabtest.OrderableItemExternal);
    ALabtest.OrderComment.Add(edtOrderComment.Text);
  end;

  UpdateLegacyCommentResponse(True);
end;

procedure TfrmODAnatPath.rgrpCommentPeakTroughClick(Sender: TObject);
begin
  inherited;

  if ALabTest = nil then
    Exit;

  ALabtest.OrderComment.Clear;
  if GetPeakGroupIdx <> -1 then
  begin
    ALabtest.OrderComment.Add('~For Test: ' + ALabtest.OrderableItemExternal);
    ALabtest.OrderComment.Add('~Dose is expected to be at ' +
                               UpperCase(Strip(GetPeakGroupTxt)) + ' level.');

    if edtPeakComment.Text <> '' then
      ALabtest.OrderComment.Add(edtPeakComment.Text);
  end
  else if edtPeakComment.Text <> '' then
  begin
    ALabtest.OrderComment.Add('~For Test: ' + ALabtest.OrderableItemExternal);
    ALabtest.OrderComment.Add(edtPeakComment.Text);
  end;

  UpdateLegacyCommentResponse(True);
end;

procedure TfrmODAnatPath.edtPeakCommentExit(Sender: TObject);
begin
  inherited;

  rgrpCommentPeakTroughClick(Sender);
end;

procedure TfrmODAnatPath.CommentUrineVolumeChange(Sender: TObject);
begin
  inherited;

  if ALabTest = nil then
    Exit;

  if spnedtUrineVolume.Value < 0 then
    spnedtUrineVolume.Value := 0;

  ALabtest.OrderComment.Clear;
  ALabtest.OrderComment.Add('~For Test: ' + ALabtest.OrderableItemExternal);
  ALabtest.OrderComment.Add(spnedtUrineVolume.Text + ' ' + UrineUnits);

  UpdateLegacyCommentResponse(True);
end;

procedure TfrmODAnatPath.lblAvailTestClick(Sender: TObject);
begin
  inherited;
  if FMissingGroupsMessage <> '' then
    ShowMessage(FMissingGroupsMessage);
end;

procedure TfrmODAnatPath.ledtCommentAntiCoagulantExit(Sender: TObject);
begin
  inherited;

  if ALabTest = nil then
    Exit;

  ALabtest.OrderComment.Clear;
  if edtAntiCoag.Text <> '' then
  begin
    ALabtest.OrderComment.Add('~For Test: ' + ALabtest.OrderableItemExternal);
    ALabtest.OrderComment.Add('~Anticoagulant: ' + edtAntiCoag.Text);
  end;

  UpdateLegacyCommentResponse(True);
end;

procedure TfrmODAnatPath.DoseDrawComment(Sender: TObject);
begin
  inherited;

  if ALabTest = nil then
    Exit;

  ALabtest.OrderComment.Clear;
  ALabtest.OrderComment.Add('~For Test: ' + ALabtest.OrderableItemExternal);
  ALabtest.OrderComment.Add('~Last dose: ' + calDoseTime.Text + '   draw time: '+ calDrawTime.Text);

  UpdateLegacyCommentResponse(True);
end;

procedure TfrmODAnatPath.LegacyExit(Sender: TObject);
begin
  inherited;

  UpdateAllLegacyResponses(True);
end;

procedure TfrmODAnatPath.LegacyKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;

  if (Key <> VK_DOWN) and (Key <> VK_UP) and
     (Key <> VK_LEFT) and (Key <> VK_RIGHT) then
    Key := 0
  else
  begin
    Changing := True;

    if Key = VK_LEFT then
      Key := VK_UP;
    if Key = VK_RIGHT then
      Key := VK_DOWN;
  end;
end;

procedure TfrmODAnatPath.LegacyKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;

  Changing := False;
  Key := 0;
end;

procedure TfrmODAnatPath.cbxSpecimenChange(Sender: TObject);
var
  iSpecimenIEN: Integer;
  sSpecimen: string;
  tbshtSpecimen: TTabSheet;
  lvwItem: TListItem;
  mSpecimen: TfraAnatPathSpecimen;
begin
  inherited;

  if ALabTest = nil then
    Exit;
  if FSpecimenChanging then
    Exit;

  if cbxSpecimenSelect.Text = 'Other...' then
    if (cbxSpecimenSelect.ItemIndex >= 0) and (cbxSpecimenSelect.ItemIEN = 0) then
    begin
      GetAllSpecimens;
      Exit;
    end;

  if cbxSpecimenSelect.ItemIEN < 1 then
    Exit;

  iSpecimenIEN := cbxSpecimenSelect.ItemIEN;
  sSpecimen := cbxSpecimenSelect.Text;

  if ALabTest.RestrictMulti then
  begin
    cbxSpecimenSelect.Enabled := False;
    pnlAddSingleSpecimen.Visible := True;
  end;

  tbshtSpecimen := TTabSheet.Create(pgctrlSpecimen);
  tbshtSpecimen.PageControl := pgctrlSpecimen;
  tbshtSpecimen.Caption := IntToStr(pgctrlSpecimen.PageCount);
  tbshtSpecimen.TabVisible := False;

  lvwItem := lvwSpecimen.Items.Add;
  lvwItem.Caption := IntToStr(pgctrlSpecimen.PageCount);
  lvwItem.SubItems.Add('');
  lvwSpecimen.Selected := lvwItem;
  lvwItem.Focused := True;

  mSpecimen := TfraAnatPathSpecimen.Create(tbshtSpecimen);
  mSpecimen.Parent := tbshtSpecimen;
  mSpecimen.Build(sSpecimen, iSpecimenIEN, bSuppressCollectDialog);
  mSpecimen.Show;
  lvwSpecimenDblClick(nil);
  UpdatePageCounts;
  UpdateSpecimenResponses(True);

  if ScreenReaderActive then
    GetScreenReader.Speak('New ' + cbxSpecimenSelect.Text + ' specimen created');
end;

procedure TfrmODAnatPath.cbxSpecimenSelectEnter(Sender: TObject);
begin
  inherited;
  FSpecimenChanging := True;
  if ScreenReaderActive and (pgctrlSpecimen.PageCount < 1) and
    (cbxSpecimenSelect.Items.Count > 1) then
    cbxSpecimenSelect.DroppedDown := True;
end;

procedure TfrmODAnatPath.cbxSpecimenSelectExit(Sender: TObject);
begin
  inherited;
  SetSpecimenActiveSelected;
  FSpecimenChanging := False;
  if FSpecSelectRedirectTabStop then
  begin
    FSpecSelectRedirectTabStop := False;
    if TabIsPressed then
      cbxUrgency.SetFocus
  end;
end;

procedure TfrmODAnatPath.cbxSpecimenSelectKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;

  FSpecimenChanging := True;

  if Key = VK_LEFT then
    Key := VK_UP;
  if Key = VK_RIGHT then
    Key := VK_DOWN;
  if (Key = VK_RETURN) and (cbxSpecimenSelect.ItemIndex >= 0) then
    FSpecimenChanging := False;
end;

procedure TfrmODAnatPath.cbxSpecimenSelectMouseClick(Sender: TObject);
begin
  inherited;

  if FSpecimenChanging then
  begin
    FSpecimenChanging := False;
    cbxSpecimenChange(Sender);
  end;
end;

procedure TfrmODAnatPath.pgctrlSpecimenEnter(Sender: TObject);
begin
  inherited;
  if TabIsPressed then
    FindNextControl(pgctrlSpecimen, True, True, False).SetFocus;
end;

procedure TfrmODAnatPath.pnlAddSingleSpecimenClick(Sender: TObject);
begin
  inherited;

  FSpecimenChanging := False;
  cbxSpecimenChange(Sender);
end;

procedure TfrmODAnatPath.pnlFocusEnter(Sender: TObject);
begin
  inherited;
  with Sender as TPanel do
    BevelInner := bvLowered;
end;

procedure TfrmODAnatPath.pnlFocusExit(Sender: TObject);
begin
  inherited;
  with Sender as TPanel do
    BevelInner := bvRaised;
end;

procedure TfrmODAnatPath.lvwSpecimenChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  inherited;
  lvwSpecimenDblClick(Sender);
end;

procedure TfrmODAnatPath.lvwSpecimenClick(Sender: TObject);
begin
  inherited;
  lvwSpecimenDblClick(Sender);
end;

procedure TfrmODAnatPath.lvwSpecimenDblClick(Sender: TObject);
begin
  inherited;

  if lvwSpecimen.ItemIndex = -1 then
    Exit;

  pgctrlSpecimen.ActivePageIndex := lvwSpecimen.ItemIndex;
  SetSpecimenActiveSelected;
  FSpecimenChanging := False;

  UpdatePageCounts;
end;

procedure TfrmODAnatPath.lvwSpecimenKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;

  if Key = VK_RETURN then
    lvwSpecimenDblClick(Sender);
end;

procedure TfrmODAnatPath.aCtrlTabExecute(Sender: TObject);
begin
  inherited;

  if Assigned(ActiveControl) then
  begin
    if (((ActiveControl = pgctrlSpecimen) or (ActiveControl = lvwSpecimen) or
         (ActiveControl.Owner is TfraAnatPathSpecimen)) and
         (lvwSpecimen.Items.Count > 0)) then
    begin
      if lvwSpecimen.ItemIndex < lvwSpecimen.Items.Count - 1 then
        lvwSpecimen.ItemIndex := lvwSpecimen.ItemIndex + 1
      else
        lvwSpecimen.ItemIndex := 0;
      lvwSpecimenDblClick(nil);
    end
    else if (ActiveControl = pgctrlText) or
            (ActiveControl.Owner is TfraAnatPathBuilder) then
      pgctrlText.SelectNextPage(True);
  end;
end;

procedure TfrmODAnatPath.aCtrlShiftTabExecute(Sender: TObject);
begin
  inherited;

  if Assigned(ActiveControl) then
  begin
    if (((ActiveControl = pgctrlSpecimen) or (ActiveControl = lvwSpecimen) or
         (ActiveControl.Owner is TfraAnatPathSpecimen)) and
         (lvwSpecimen.Items.Count > 0)) then
    begin
      if lvwSpecimen.ItemIndex = 0 then
        lvwSpecimen.ItemIndex := lvwSpecimen.Items.Count - 1
      else
        lvwSpecimen.ItemIndex := lvwSpecimen.ItemIndex - 1;
      lvwSpecimenDblClick(nil);
    end
    else if (ActiveControl = pgctrlText) or
            (ActiveControl.Owner is TfraAnatPathBuilder) then
      pgctrlText.SelectNextPage(False);
  end;
end;

procedure TfrmODAnatPath.EatCarrots(Sender: TObject; var Key: Char);
begin
  inherited;

  if Key = '^' then
    Key := #0;
end;

procedure TfrmODAnatPath.FormKeyPress(Sender: TObject; var Key: Char);
begin
//  Don't cause RETURN to be treated as pressing a tab key
//  inherited;
end;

procedure TfrmODAnatPath.FormResize(Sender: TObject);
begin
  inherited;
  cbxSpecimenSelect.Width := pnlTabs.Width;
  cbxSpecimenSelect.Height := pnlTabs.Height;
  pnlAddSingleSpecimen.Left := pnlTabs.Width - pnlAddSingleSpecimen.Width;
  pnlAddSingleSpecimen.Height := pnlTabs.Height;
  ForceToFitScreen;
end;

// Private ---------------------------------------------------------------------

procedure TfrmODAnatPath.ToggleControlEnable(cControl: TControl; bSwitch: Boolean);
begin
  if assigned(cControl) then
  begin
    if (cControl.Tag in [6, 7]) and (FMaxDays < 0) then
      bSwitch := False;
    cControl.Enabled := bSwitch;
  end;
end;

procedure TfrmODAnatPath.ToggleChildControls(pnl: TPanel; bSwitch: Boolean);
var
  I: Integer;
begin
  for I := 0 to pnl.ControlCount - 1 do
  begin
    if pnl.Controls[I] is TPanel then
      ToggleChildControls(TPanel(pnl.Controls[I]), bSwitch)
    else
      ToggleControlEnable(pnl.Controls[I], bSwitch);
  end;
end;

procedure TfrmODAnatPath.ToggleEnableLegacy(bSwitch: Boolean);
var
  R, C: Integer;
  ctrl: TControl;

begin
  for R := 1 to 4 do
    for C := 1 to 4 do
      ToggleControlEnable(gpMain.ControlCollection.Controls[C, R], bSwitch);

  for R := 5 to 9 do
  begin
    ctrl := gpMain.ControlCollection.Controls[1, R];
    if ctrl is TPanel then
      ToggleChildControls(ctrl as TPanel, bSwitch)
    else
      ToggleControlEnable(ctrl, bSwitch);
  end;

  cbxSpecimenSelect.Enabled := bSwitch;
  cmdAccept.Enabled := bSwitch;
end;

procedure TfrmODAnatPath.UpdateAllOrderResponses;
var
  AResponse: TResponse;
  sVisitStr: string;
begin
  if Changing or (ALabTest = nil) then
    Exit;

  AResponse := Responses.FindResponseByName('VISITSTR', 1);
  if AResponse <> nil then
    sVisitStr := AResponse.EValue;

  Responses.Clear;

  if StrToIntDef(ALabTest.OrderableItemInternal, 0) > 0 then
    Responses.Update('ORDERABLE', 1, ALabTest.OrderableItemInternal, ALabTest.OrderableItemExternal);

  UpdateAllLegacyResponses(False);
  UpdateLegacyCommentResponse(False);

  if sVisitStr <> '' then
    Responses.Update('VISITSTR', 1, sVisitStr, sVisitStr);

  UpdateSpecimenResponses(False);
  UpdateTextResponses(False);

  UpdateOrderText;
end;

procedure TfrmODAnatPath.UpdateAllLegacyResponses(bUpdate: Boolean);
begin
  if Changing or (ALabTest = nil) then
    Exit;

  if StrToIntDef(ALabTest.UrgencyInternal, 0) > 0 then
    Responses.Update('URGENCY', 1, ALabTest.UrgencyInternal, ALabTest.UrgencyExternal)
  else Responses.Remove('URGENCY', 1);

  if ALabTest.CollectionDateTimeInternal <> '' then
    Responses.Update('START', 1, ALabTest.CollectionDateTimeInternal, ALabTest.CollectionDateTimeExternal)
  else Responses.Remove('START', 1);

  if ALabTest.SpecimenSubmittedBy <> '' then
    Responses.Update('SPCSUBMIT', 1, ALabTest.SpecimenSubmittedBy, ALabTest.SpecimenSubmittedBy)
  else Responses.Remove('SPCSUBMIT', 1);

  if ALabTest.CollectionTypeInternal <> '' then
    Responses.Update('COLLECT', 1, ALabTest.CollectionTypeInternal, ALabTest.CollectionTypeExternal)
  else Responses.Remove('COLLECT', 1);

  if ALabTest.ScheduleInternal <> '' then
    Responses.Update('SCHEDULE', 1, ALabTest.ScheduleInternal, ALabTest.ScheduleExternal)
  else Responses.Remove('SCHEDULE', 1);

  if ALabTest.HowMany <> '' then
    Responses.Update('DAYS', 1, ALabTest.HowMany, ALabTest.HowMany)
  else Responses.Remove('DAYS', 1);

  if StrToFloatDef(ALabTest.SurgeonInternal, 0) > 0 then
    Responses.Update('SURGPROV', 1, ALabTest.SurgeonInternal, ALabTest.SurgeonExternal)
  else Responses.Remove('SURGPROV', 1);

  if bUpdate then
    UpdateOrderText;
end;

procedure TfrmODAnatPath.UpdateLegacyCommentResponse(bUpdate: Boolean);
begin
  if Changing or (ALabTest = nil) then
    Exit;

  if ALabtest.OrderComment.Count > 0 then
    Responses.Update('COMMENT', 1, TX_WPTYPE, ALabtest.OrderComment.Text);

  if bUpdate then
    UpdateOrderText;
end;

procedure TfrmODAnatPath.ResetOrderGrid;
begin
  gpMain.ControlCollection.BeginUpdate;
  try
    OrderCommentReset;
    RestoreCtrls(lblUrgency, cbxUrgency, 1, 1);
    RestoreCtrls(lblORDateBox, calCollTime, 2, 1);
    RestoreCtrls(lblSubmittedBy, edtSubmittedBy, 3, 1);
    RestoreCtrls(lblCollectionType, cbxCollType, 1, 3);
    RestoreCtrls(lblOften, cbxFrequency, 2, 3);
    RestoreCtrls(lblHowLong, edtDays, 3, 3);
    RestoreCtrls(lblSurgeon, cbxPtProvider, 4, 3);
  finally
    gpMain.ControlCollection.EndUpdate;
  end;
end;

procedure TfrmODAnatPath.BuildOrderGrid;
var
  abElements: array of Boolean;
  sl: TStringList;
  I: Integer;
  sID: string;
  opCode: TOrderPrompt;
begin
  if ALabTest = nil then
    Exit;

  Changing := True;

  // opURG, opCDT, opSSB, opCTY, opHOF, opSPH, opODC
  SetLength(abElements, 7);
  sl := TStringList.Create;
  try
    ResetOrderGrid;      // Reset contains Begin/End Update
//    gplOrderElements.ControlCollection.BeginUpdate;
    try
      if ALabTest.ReqOrderCommentType <> '' then
        LoadRequiredComment(FCmtTypes.IndexOf(ALabTest.ReqOrderCommentType));

      // Order Elements
      OrderElements('O', ALabTest.OrderableItemInternal, sl);

      // O^ID^HIDE(1,0)^REQUIRED(1,0)^DEFAULT_VALUE
      if ((sl.Count > 0) and (sl[0] <> '0')) then
      begin
        for I := 0 to sl.Count - 1 do
        begin
          sID := Piece(sl[I],U,2);
          if ValidOrderPromptID(sID, opCode) then
          begin
            abElements[GetEnumValue(TypeInfo(TOrderPrompt), sID)] := True;
            UpdateOrderElement(sID, Piece(sl[I],U,3), Piece(sl[I],U,4), Piece(sl[I],U,5));
          end;
        end;
        for I := 0 to 6 do
          if not abElements[I] then
            UpdateOrderElement(GetEnumName(TypeInfo(TOrderPrompt), I),'','','');
      end;
    finally
//      gplOrderElements.ControlCollection.EndUpdate;
    end;
  finally
    Changing := False;
    SetLength(abElements, 0);
    sl.Free;
  end;

  UpdateAllLegacyResponses(False);
  UpdateLegacyCommentResponse(True);
end;

procedure TfrmODAnatPath.AlterContainerCaption(pnl: TPanel; bReq: Boolean);
var
  I: Integer;
begin
  for I := 0 to pnl.ControlCount - 1 do
  begin
    if pnl.Controls[I] is TLabel then
      AlterCaption(TLabel(pnl.Controls[I]), bReq)
    else if pnl.Controls[I] is TPanel then
      AlterContainerCaption(TPanel(pnl.Controls[I]), bReq);
  end;
end;

procedure TfrmODAnatPath.AlterCaption(lbl: TCustomLabel; bReq: Boolean);
var
  sCaption: string;
begin
  sCaption := lbl.Caption;

  if sCaption <> '' then
    if ((sCaption[1] = '*') and (not bReq)) then
      Delete(sCaption, 1, 1)
    else if ((sCaption[1] <> '*') and (bReq)) then
      sCaption := '*' + sCaption;

  lbl.Caption := sCaption;
end;

procedure TfrmODAnatPath.UpdateOrderElement(sID,sHide,sReq,sDef: string);
var
  opCode: TOrderPrompt;
begin
  Changing := True;
  try
    if not ValidOrderPromptID(sID, opCode) then
      Exit;

    case opCode of
      opURG : UrgencyO(sHide, sReq, sDef);
      opCDT : CollectionDateTimeO(sHide, sReq, sDef);
      opSSB : SpecimenSubmittedO(sHide, sReq, sDef);
      opCTY : CollectionTypeO(sHide, sReq, sDef);
      opHOF : FrequencyO(sHide, sReq, sDef);
      opSPH : SurgeonPhysicianO(sHide, sReq, sDef);
      opODC : OrderCommentCollectionO(sHide, sReq, sDef);
    end;
  finally
    Changing := False;
  end;
end;

procedure TfrmODAnatPath.OrderCommentReset;
var
  R: integer;
begin
  for R := 5 to 9 do
    AlterContainerCaption(TPanel(gpMain.ControlCollection.Controls[1, R]), False);

  rbPeak.Checked := False;
  rbTrough.Checked := False;
  rbMid.Checked := False;
  rbUnknown.Checked := False;

  edtPeakComment.Clear;
  spnedtUrineVolume.Value := 0;
  rbtnUrineML.Checked := False;
  rbtnUrineCC.Checked := False;
  rbtnUrineOZ.Checked := False;
  edtAntiCoag.Clear;
  calDoseTime.Clear;
  calDrawTime.Clear;
  edtOrderComment.Clear;

  LoadRequiredComment(2);
end;

procedure TfrmODAnatPath.MouseDetect(var Msg: tagMSG; var Handled: Boolean);
var
  pt: TPoint;
begin
  if Msg.message = WM_LBUTTONDOWN then
  begin
    if Assigned(CurrentFocusedwp) then
    begin
      pt := CurrentFocusedwp.ScreenToClient(Mouse.CursorPos);
      if not PtInRect(CurrentFocusedwp.ClientRect, pt) then
        pgctrlText.SetFocus;
    end;

    if Assigned(FApplicationMessage) then
      FApplicationMessage(Msg, Handled);
  end;
end;

procedure TfrmODAnatPath.BuildPages;
var
  I: Integer;
begin
  for I := pgctrlText.PageCount - 1 downto 0 do
    pgctrlText.Pages[I].Free;

  if ALabTest = nil then
    Exit;

  OrderElementsWithinPages;

  ResetGrid;

  If pgctrlText.PageCount > 0 then
    pgctrlText.ActivePageIndex := 0;
end;

procedure TfrmODAnatPath.GetAllSpecimens;
var
  sOtherSpecimen: string;
  mSpecimen: TfraAnatPathSpecimen;
begin
  inherited;

  if ALabTest = nil then
    Exit;

  cbxSpecimenSelect.DroppedDown := False;

  sOtherSpecimen := SelectOtherSpecimen(Font.Size, ALabTest.SpecimenList);
  if sOtherSpecimen = '-1' then
    Exit;
  if cbxSpecimenSelect.SelectByID(Piece(sOtherSpecimen,U,1)) = -1 then
    cbxSpecimenSelect.Items.Insert(0, sOtherSpecimen);

  cbxSpecimenSelect.SelectByID(Piece(sOtherSpecimen,U,1));
  cbxSpecimenChange(nil);

  mSpecimen := GetCurrentSpecimenForm;
  if mSpecimen <> nil then
    if ItemInList(mSpecimen.cbxCollSamp, 'Other...') = - 1 then
    begin
      mSpecimen.cbxCollSamp.Items.Add('0^Other...');
      if mSpecimen.cbxCollSamp.ItemIndex < 0 then
        mSpecimen.cbxCollSamp.ItemIndex := ItemInList(mSpecimen.cbxCollSamp, 'Other...');
    end;
end;

procedure TfrmODAnatPath.SetupCollTimes(sCollType: string);
var
  sCurrent,sORECALLTime: string;
begin
  if FOrderAction in [ORDER_COPY, ORDER_EDIT, ORDER_QUICK] then
    Exit;

  sCurrent := calCollTime.Text;
  calCollTime.Text := '';
  sORECALLTime := Piece(GetLastCollectionTime,U,2);

  if sORECALLTime <> '' then
  begin
    calCollTime.Text := sORECALLTime;
    if not calCollTime.IsValid then
      calCollTime.Text := '';
  end;

  if calCollTime.Text = '' then
  begin
    if LRFDate <> '' then
      calCollTime.Text := LRFDATE
    else
    begin
      if sCollType = 'SP' then
        calCollTime.Text := 'TODAY'
      else if sCollType = 'WC' then
        calCollTime.Text := 'NOW';
    end;
  end;

  if calCollTime.Text = '' then
    calCollTime.Text := sCurrent;
end;

procedure TfrmODAnatPath.SetSpecimenActiveSelected;
var
  mSpecimen: TfraAnatPathSpecimen;
  iSpecimen: Integer;
begin
  FSpecimenChanging := True;
  if pgctrlSpecimen.ActivePageIndex <> -1 then
    if pgctrlSpecimen.ActivePage.ControlCount > 0 then
      if pgctrlSpecimen.ActivePage.Controls[0] is TfraAnatPathSpecimen then
      begin
        mSpecimen :=  TfraAnatPathSpecimen(pgctrlSpecimen.ActivePage.Controls[0]);
        if mSpecimen.LabSpecimen <> nil then
        begin
          iSpecimen :=StrToIntDef(mSpecimen.LabSpecimen.SpecimenInternal, 0);
          if iSpecimen > 0 then
            cbxSpecimenSelect.SelectByIEN(iSpecimen);
        end;
      end;
end;

// Protected -------------------------------------------------------------------

procedure TfrmODAnatPath.Enhancements508;
var
  sCaption: string;
begin
  sCaption := cmdAccept.Caption;
  if sCaption[1] <> '&' then
    sCaption := '&' + cmdAccept.Caption;
  cmdAccept.Caption := sCaption;

  sCaption := cmdQuit.Caption;
  if sCaption[1] <> '&' then
    sCaption := '&' + cmdQuit.Caption;
  cmdQuit.Caption := sCaption;
end;

procedure TfrmODAnatPath.InitVariables;
var
  I: Integer;
begin
  LRFURG := KeyVariable['LRFURG'];
  LRFDATE := KeyVariable['LRFDATE'];
  LRFZX := KeyVariable['LRFZX'];
  LRFSCH := KeyVariable['LRFSCH'];
  LRFSAMP := KeyVariable['LRFSAMP'];
  LRFSPEC := KeyVariable['LRFSPEC'];

  uDfltUrgency := '-1';
  uDfltCollType := '';
  uDfltCollSamp := '-1';

  FillerID := 'LR';
  FEvtDelayLoc := 0;
  FEvtDivision := 0;

  FUserHasLRLABKey := User.HasKey('LRLAB');
  AllowQuickOrder := False;

  FCmtTypes := TStringList.Create;
  for I := 0 to 6 do
    FCmtTypes.Add(CmtType[I]);
end;

procedure TfrmODAnatPath.InitControls;
begin
  cbxUrgency.ItemIndex := -1;
  calCollTime.Clear;
  edtSubmittedby.Clear;
  cbxCollType.ItemIndex := -1;
  cbxFrequency.ItemIndex := -1;
  edtDays.Clear;
  cbxPtProvider.ItemIndex := -1;
  TSimilarNames.RegORComboBox(cbxPtProvider); // Out of an abundance of caution, because Index changes
end;

// Called on Restart
procedure TfrmODAnatPath.InitDialog;
begin
  inherited;

  StatusText('Initializing Dialog');
  ResetDialog;
// when quick order are enabled for AP dialogs this will need to be added
// back in, but right now it's clearing the existing cbxAvailTest.Items
//  CtrlInits.SetControl(cbxAvailTest, 'ShortList');
  cbxAvailTest.ItemIndex := -1;
  ToggleEnableLegacy(False);
  StatusText('');
end;

procedure TfrmODAnatPath.SpecimenSelectForExisting;
begin
  if ((cbxSpecimenSelect.Items.Count = 1) and
      (cbxSpecimenSelect.Items[0] <> '0^Other...')) then
  begin
    cbxSpecimenSelect.ItemIndex := 0;
    cbxSpecimenSelect.Enabled := False;
    pnlAddSingleSpecimen.Visible := True;
  end
  else
  begin
    cbxSpecimenSelect.Enabled := True;
    pnlAddSingleSpecimen.Visible := False;
  end;
end;

procedure TfrmODAnatPath.SpecimenSelectForNew;
var
  event: TNotifyEvent;

begin
  if LRFSPEC <> '' then
    cbxSpecimenSelect.SelectByID(LRFSPEC)
  else if cbxSpecimenSelect.Items.Count = 1 then
  begin
    // the call to cbxSpecimenChange at the end of this routine
    //   does the same thing.  Don't want to call it twice
    event := cbxSpecimenSelect.OnChange;
    cbxSpecimenSelect.OnChange := nil;
    try
      cbxSpecimenSelect.ItemIndex := 0;
    finally
      cbxSpecimenSelect.OnChange := event;
    end;
    if cbxSpecimenSelect.Items[0] <> '0^Other...' then
    begin
      cbxSpecimenSelect.Enabled := False;
      pnlAddSingleSpecimen.Visible := True;
    end;
  end
  else
  begin
    cbxSpecimenSelect.Enabled := True;
    pnlAddSingleSpecimen.Visible := False;
  end;
  if cbxSpecimenSelect.ItemIndex <> -1 then
    cbxSpecimenChange(nil);
end;

procedure TfrmODAnatPath.SetUpSpecimen;
var
  I,iSpec: Integer;
  mSpecimen: TfraAnatPathSpecimen;
begin
  if FOrderAction in [ORDER_COPY, ORDER_EDIT, ORDER_QUICK] then
  begin
    for I := 0 to ALabTest.LabSpecimenList.Count - 1 do
    begin
      iSpec := StrToIntDef(ALabTest.LabSpecimenList.Items[I].SpecimenInternal, 0);
      if iSpec > 0 then
      begin
        if cbxSpecimenSelect.SelectByIEN(iSpec) = - 1 then
          cbxSpecimenSelect.Items.Add(IntToStr(iSpec) + U +
          ALabTest.LabSpecimenList.Items[I].SpecimenExternal);

        cbxSpecimenSelect.ItemIndex := ItemInList(cbxSpecimenSelect,
                                       ALabTest.LabSpecimenList.Items[I].SpecimenExternal);
        bSuppressCollectDialog := True;
        cbxSpecimenChange(nil);
        bSuppressCollectDialog := False;
        mSpecimen := GetCurrentSpecimenForm;
        if mSpecimen <> nil then
        begin
          mSpecimen.LabSpecimen.Free;
          mSpecimen.LabSpecimen := ALabTest.LabSpecimenList.Items[I];
        end;
      end;
    end;
    SpecimenSelectForExisting;
  end
  else
    SpecimenSelectForNew;

  UpdatePageCounts;
end;

procedure TfrmODAnatPath.FinalizeChange;
begin
  UpdateAllOrderResponses;
  cbxAvailTest.OnClick := nil;
  cbxAvailTest.SelectByIEN(FLastLabIEN);
  cbxAvailTest.OnClick := cbxAvailTestChange;
  ToggleEnableLegacy(True);
end;

procedure TfrmODAnatPath.ShuffleLeft(lbl: TCustomLabel; ctrl: TControl);
var
  lblci, ctrlci, pci: TControlItem;
  iColumn, iRow, iNewColumn, I: Integer;
begin
  lblci := gpMain.ControlCollection.Items[gpMain.ControlCollection.Indexof(lbl)];
  ctrlci := gpMain.ControlCollection.Items[gpMain.ControlCollection.Indexof(ctrl)];
  iColumn := lblci.Column;
  iRow := lblci.Row;

  iNewColumn := 1;
  for I := 1 to iColumn - 1 do
  begin
    pci := gpMain.ControlCollection.ControlItems[I, iRow];
    if assigned(pci) and assigned(pci.Control) and (pci.Control.Visible) then
      iNewColumn := I + pci.ColumnSpan;
  end;
  if iColumn <> iNewColumn then
  begin
    lblci.SetLocation(iNewColumn, iRow);
    ctrlci.SetLocation(iNewColumn, iRow + 1);
  end;
end;

procedure TfrmODAnatPath.RestoreCtrls(lbl: TCustomLabel; ctrl: TControl; ACol, ARow: integer);
var
  ci: TControlItem;

begin
  lbl.Visible := True;
  ctrl.Visible := True;
  AlterCaption(lbl, False);
  ci := gpMain.ControlCollection.Items[gpMain.ControlCollection.Indexof(lbl)];
  ci.SetLocation(ACol, ARow);
  ci := gpMain.ControlCollection.Items[gpMain.ControlCollection.Indexof(ctrl)];
  ci.SetLocation(ACol, ARow + 1);
end;

procedure TfrmODAnatPath.ShowOrderMessage(Show: boolean);
begin
  inherited;
  ResetGrid;
end;

procedure TfrmODAnatpath.SetError(const sString: string; var AnErrMsg: string);
begin
  if AnErrMsg <> '' then
    AnErrMsg := AnErrMsg + CRLF;
  AnErrMsg := AnErrMsg + sString;
end;

procedure TfrmODAnatPath.SetFontSize(FontSize: integer);

  procedure FixVert(ctrl: TControl);
  begin
    ctrl.Top := (FlblHeight + (EDIT_BUMP * 2) - ctrl.Height) div 2;
  end;

  procedure FixRBW(rb: TRadioButton);
  begin
    rb.Width := Canvas.TextWidth(rb.Caption) + (Font.Size * 2) + 8;
  end;

begin
  inherited;
  FlblHeight := Canvas.TextHeight('Tg');
  ResetGrid;
  FixRBW(rbPeak);
  FixRBW(rbTrough);
  FixRBW(rbMid);
  FixRBW(rbUnknown);
  FixRBW(rbtnUrineML);
  FixRBW(rbtnUrineCC);
  FixRBW(rbtnUrineOZ);
  FixVert(spnedtUrineVolume);
  spnedtUrineVolume.Left := lblUrineVolume.Width + 10;
  lblUrineVolume.Margins.Right := spnedtUrineVolume.Width + 20;
  FormResize(Self);
end;

procedure TfrmODAnatpath.PosX(dDays: Double; iMinutes: Integer; var AnErrMsg: string);
var
  sString: string;
  iNoOfTimes,I: Integer;
  dMsgTxt: Double;
begin
  sString := Trim(Copy(edtDays.Text, 1, Pos('X', UpperCase(edtDays.Text)) - 1)) +
             Trim(Copy(edtDays.Text, Pos('X', UpperCase(edtDays.Text)) + 1, 99));
  iNoOfTimes := ExtractInteger(sString);
  dDays := iNoOfTimes * dDays;                        // # days requested
  if FloatToStr(iNoOfTimes) <> sString then
    SetError(TX_NO_ALPHA, AnErrMsg)
  else if iNoOfTimes = 0 then
    SetError(TX_NO_TIMES, AnErrMsg)
  else if (dDays > FMaxDays) then
  begin
    dMsgTxt := iMinutes / 60;
    sString := ' hour';
    if dMsgTxt > 24 then
    begin
      dMsgTxt := dMsgTxt / 24;
      sString := ' day';
    end;
    if dMsgTxt > 1 then
      sString := sString + 's';
    I := 0;
    if iMinutes > 0 then
      I := (FMaxDays * 1440) div iMinutes;
    if I = 0 then
      I := 1;
    SetError(TX_TOO_MANY_TIMES + IntToStr(I) + CRLF + '     (Every ' + FloatToStr(dMsgTxt) +
             sString + ' for a maximum of ' + IntToStr(FMaxDays) + ' days.)', AnErrMsg)
  end
  else
  begin
    sString := 'X' + IntToStr(iNoOfTimes);
    ALabTest.HowMany := sString;
    Responses.Update('DAYS', 1, sString, sString);
  end;
end;

procedure TfrmODAnatPath.UrgencyO(sHide,sReq,sDef: string);
var
  iValue: Integer;
begin
  if ALabTest <> nil then
  begin
    if ALabTest.CollectionTypeInternal <> '' then
      ALabTest.LoadUrgency(ALabTest.CollectionTypeInternal, cbxUrgency)
    else
      ALabTest.LoadUrgency(cbxCollType.ItemID, cbxUrgency);
  end;
  if sReq = '1' then
    AlterCaption(lblUrgency, True);
  if ((FOrderAction in [ORDER_COPY, ORDER_EDIT, ORDER_QUICK]) and
      (ALabTest.UrgencyInternal <> '')) then
  begin
    if TryStrToInt(ALabTest.UrgencyInternal, iValue) then
      cbxUrgency.SelectByIEN(iValue);
  end
  else if ((sDef <> '') and (TryStrToInt(sDef, iValue))) then
      cbxUrgency.SelectByIEN(iValue);
  cbxUrgencyChange(nil);
  if sHide = '1' then
  begin
    lblUrgency.Visible := False;
    cbxUrgency.Visible := False;
  end;
end;

procedure TfrmODAnatPath.Urgency;
begin
  CtrlInits.SetControl(cbxUrgency, 'Default Urgency');

  if cbxUrgency.Items.Count > 0 then
    uDfltUrgency := Piece(cbxUrgency.Items[0],U,1);
  if StrToIntDef(uDfltUrgency, 0) > 0 then
    cbxUrgency.SelectByIEN(StrToInt(uDfltUrgency))
  else if LRFURG <> '' then
    cbxUrgency.SelectByID(LRFURG);

  cbxUrgencyChange(nil);
end;

procedure TfrmODAnatpath.UrgencyV(var AnErrMsg: string);
begin
  If StrToIntDef(ALabTest.UrgencyInternal, 0) < 1 then
    SetError(TX_NO_URGENCY, AnErrMsg);
end;

procedure TfrmODAnatPath.UrgencyP(var sType: string; var sOldVal: string;
  var sNewVal: string; sValue: string);
var
  iValue: Integer;
begin
  sType := 'URGENCY';
  sOldVal := cbxUrgency.Text;
  if TryStrToInt(sValue, iValue) then
  begin
    cbxUrgency.SelectByIEN(iValue);
    cbxUrgencyChange(nil);
  end;
  sNewVal := cbxUrgency.Text;
end;

procedure TfrmODAnatPath.CollectionDateTimeO(sHide,sReq,sDef: string);
begin
  if sReq = '1' then
    AlterCaption(lblORDateBox, True);
  if ((FOrderAction in [ORDER_COPY, ORDER_EDIT, ORDER_QUICK]) and
      (ALabTest.CollectionDateTimeExternal <> '')) then
    calCollTime.Text := ALabTest.CollectionDateTimeExternal
  else if sDef <> '' then
    calCollTime.Text := sDef;
  calCollTimeExit(nil);
  if sHide = '1' then
  begin
    lblORDateBox.Visible := False;
    calCollTime.Visible := False;
  end
  else
    ShuffleLeft(lblORDateBox, calCollTime);
end;

procedure TfrmODAnatpath.CollectionDateTimeV(var AnErrMsg: string);
var
  dCollectionTime: TFMDateTime;
begin
  if ((ALabTest.CollectionDateTimeInternal <> 'TODAY') and
      (not IsNow(ALabTest.CollectionDateTimeInternal)) and
      (ALabTest.CollectionDateTimeInternal <> 'NOON') and
      (ALabTest.CollectionDateTimeInternal <> 'MID')) then
  begin
    dCollectionTime := MakeFMDateTime(ALabTest.CollectionDateTimeInternal);
    if ((dCollectionTime < FMNow) and (dCollectionTime <> FMToday)) then
      SetError(TX_PAST_TIME, AnErrMsg)
    else if not IsFMDateTime(ALabTest.CollectionDateTimeInternal) then
      SetError(TX_BAD_TIME, AnErrMsg);
  end;
end;

procedure TfrmODAnatPath.SpecimenSubmittedO(sHide,sReq,sDef: string);
begin
  if sReq = '1' then
    AlterCaption(lblSubmittedby, True);
  if ((FOrderAction in [ORDER_COPY, ORDER_EDIT, ORDER_QUICK]) and
      (ALabTest.SpecimenSubmittedBy <> '')) then
    edtSubmittedby.Text := ALabTest.SpecimenSubmittedBy
  else if sDef <> '' then
    edtSubmittedby.Text := sDef;
  edtSubmittedbyExit(nil);
  if sHide = '1' then
  begin
    lblSubmittedBy.Visible := False;
    edtSubmittedBy.Visible := False;
  end
  else
    ShuffleLeft(lblSubmittedBy, edtSubmittedBy);
end;

procedure TfrmODAnatPath.SpecimenSubmitted;
begin
  CtrlInits.SetControl(edtSubmittedby, 'Default Submitted');
  edtSubmittedbyExit(nil);
end;

procedure TfrmODAnatpath.SpecimenSubmittedV(var AnErrMsg: string);
begin
  if ((lblSubmittedby.Caption[1] = '*') and (ALabTest.SpecimenSubmittedBy = '')) then
    SetError(TX_NO_SUBMIT_BY, AnErrMsg);
end;

procedure TfrmODAnatPath.SpecimenSubmittedP(var sType: string;
  var sOldVal: string; var sNewVal: string; sValue: string);
begin
  sType := 'SPECIMEN SUBMITTED BY';
  sOldVal := edtSubmittedby.Text;
  edtSubmittedby.Text := sValue;
  edtSubmittedbyExit(nil);
  sNewVal := edtSubmittedby.Text;
end;

procedure TfrmODAnatPath.CollectionTypeO(sHide,sReq,sDef: string);
begin
  if sReq = '1' then
    AlterCaption(lblCollectionType, True);
  if ((FOrderAction in [ORDER_COPY, ORDER_EDIT, ORDER_QUICK]) and
      (ALabTest.CollectionTypeInternal <> '')) then
    cbxCollType.SelectByID(ALabTest.CollectionTypeInternal)
  else if sDef <> '' then
    cbxCollType.SelectByID(sDef);
  cbxCollTypeChange(nil);
  if sHide = '1' then
  begin
    lblCollectionType.Visible := False;
    cbxCollType.Visible := False;
  end;
end;

procedure TfrmODAnatPath.CollectionType;
begin
  CtrlInits.SetControl(cbxCollType, 'Collection Types');
  uDfltCollType := ExtractDefault(FAList, 'Collection Types');

  if (uDfltCollType = 'I') or (uDfltCollType = 'LC') then
    uDfltCollType := 'WC';
  if uDfltCollType <> '' then
    cbxCollType.SelectByID(uDfltCollType)
  else if LRFZX <> '' then
    cbxCollType.SelectByID(LRFZX)
  else if OrderForInpatient then
    cbxCollType.SelectByID('WP')
  else
    cbxCollType.SelectByID('SP');

  cbxCollTypeChange(nil);
end;

procedure TfrmODAnatpath.CollectionTypeV(var AnErrMsg: string);
begin
  if ALabTest.CollectionTypeInternal = 'I' then
  begin
    SetError(TX_NO_IMMED, AnErrMsg);
    cbxCollType.ItemIndex := -1;
  end
  else if ALabTest.CollectionTypeInternal = 'LC' then
  begin
    SetError(TX_NO_LABCOLLECT, AnErrMsg);
    cbxCollType.ItemIndex := -1;
  end
  else if ALabTest.CollectionTypeInternal = '' then
    SetError(TX_NO_TCOLLTYPE, AnErrMsg);
end;

procedure TfrmODAnatPath.CollectionTypeP(var sType: string;
  var sOldVal: string; var sNewVal: string; sValue: string);
begin
  sType := 'COLLECTION TYPE';
  sOldVal := cbxCollType.Text;
  cbxCollType.SelectByID(sValue);
  cbxCollTypeChange(nil);
  sNewVal := cbxCollType.Text;
end;

procedure TfrmODAnatPath.FrequencyO(sHide,sReq,sDef: string);
begin
  if sReq = '1' then
    AlterCaption(lblOften, True);
  if ((FOrderAction in [ORDER_COPY, ORDER_EDIT, ORDER_QUICK]) and
      (ALabTest.ScheduleInternal <> '') and (FMaxDays <> -1)) then
  begin
    cbxFrequency.SelectByID(ALabTest.ScheduleInternal);
    if ALabTest.HowMany <> '' then
    begin
      edtDays.Enabled := True;
      lblHowLong.Enabled := True;
      edtDays.Text := ALabTest.HowMany;
    end;
  end
  else if ((sDef <> '') and (FMaxDays <> -1)) then
    cbxFrequency.SelectByID(sDef);
  cbxFrequencyChange(nil);
  if sHide = '1' then
  begin
    lblOften.Visible := False;
    cbxFrequency.Visible := False;
    lblHowLong.Visible := False;
    edtDays.Visible := False;
  end
  else
  begin
    ShuffleLeft(lblOften, cbxFrequency);
    ShuffleLeft(lblHowLong, edtDays);
  end;
end;

procedure TfrmODAnatPath.Frequency;
begin
  CtrlInits.SetControl(cbxFrequency, 'Schedules');

  if LRFSCH <> '' then
    cbxFrequency.ItemIndex := ItemInList(cbxFrequency, LRFSCH);
  if cbxFrequency.ItemIndex = -1 then
    cbxFrequency.ItemIndex := ItemInList(cbxFrequency, 'ONE TIME');
  if cbxFrequency.ItemIndex = -1 then
    cbxFrequency.ItemIndex := ItemInList(cbxFrequency, 'ONCE');

  if FMaxDays < 0 then
  begin
    cbxFrequency.ItemIndex := ItemInList(cbxFrequency, 'ONE TIME');
    if cbxFrequency.ItemIndex = -1 then
      cbxFrequency.ItemIndex := ItemInList(cbxFrequency, 'ONCE');
  end;

  cbxFrequencyChange(nil);
end;

procedure TfrmODAnatpath.FrequencyV(var AnErrMsg: string);
var
  sString: string;
  iMinutes: Integer;
  dDays: Double;
begin
  if StrToIntDef(ALabTest.ScheduleInternal, 0) < 1 then
    SetError(TX_NO_FREQUENCY, AnErrMsg);

  if edtDays.Enabled then
  begin
    sString := Piece(cbxFrequency.Items[cbxFrequency.ItemIndex],U,3);
    if (sString = 'C') or (sString = 'D') then
    begin
      iMinutes := StrToIntDef(Piece(cbxFrequency.Items[cbxFrequency.ItemIndex],U,4), 0);
      dDays := iMinutes / 1440;
      if dDays = 0 then
        dDays := 1;
      if Pos('X', UpperCase(edtDays.Text)) > 0 then
        PosX(dDays, iMinutes, AnErrMsg)
      else
      begin
        dDays := ExtractInteger(edtDays.Text);
        if FloatToStr(dDays) <> Trim(edtDays.Text) then
          SetError(TX_NO_ALPHA, AnErrMsg)
        else if (dDays > FMaxDays) then
          SetError(TX_TOO_MANY_DAYS + IntToStr(FMaxDays), AnErrMsg)
        else
        begin
          ALabTest.HowMany := edtDays.Text;
          Responses.Update('DAYS', 1, edtDays.Text, edtDays.Text);
        end;
      end;
    end;
  end;
end;

procedure TfrmODAnatPath.FrequencyP(var sType: string;
  var sOldVal: string; var sNewVal: string; sValue: string);
begin
  if FMaxDays <> -1 then
  begin
    sType := 'HOW OFTEN?';
    sOldVal := cbxFrequency.Text;
    cbxFrequency.SelectByID(sValue);
    cbxFrequencyChange(nil);
    sNewVal := cbxFrequency.Text;
  end;
end;

procedure TfrmODAnatPath.SurgeonPhysicianO(sHide,sReq,sDef: string);
var
  eValue: Int64;
begin
  eValue := 0;
  if sReq = '1' then
    AlterCaption(lblSurgeon, True);
  if ((FOrderAction in [ORDER_COPY, ORDER_EDIT, ORDER_QUICK]) and
      (ALabTest.SurgeonInternal <> '')) then
    eValue := StrToInt64Def(ALabTest.SurgeonInternal, 0)
  else if sDef <> '' then
    eValue := StrToInt64Def(sDef, 0);
  if eValue > 0 then
  begin
    cbxPtProvider.SetExactByIEN(eValue, ExternalName(eValue, 200));
    TSimilarNames.RegORComboBox(cbxPtProvider);
  end;
  cbxPtProviderChange(nil);

  if sHide = '1' then
  begin
    lblSurgeon.Visible := False;
    cbxPtProvider.Visible := False;
  end
  else
    ShuffleLeft(lblSurgeon, cbxPtProvider);
end;

procedure TfrmODAnatPath.SurgeonPhysician;
begin
  CtrlInits.SetControl(cbxPtProvider, 'Providers');

  if cbxPtProvider.Items.Count > 0 then
    cbxPtProvider.InsertSeparator;

  cbxPtProvider.InitLongList('');
  cbxPtProvider.ItemIndex := -1;
  cbxPtProviderChange(nil);
end;

procedure TfrmODAnatpath.SurgeonPhysicianV(var AnErrMsg: string);
var
  rtnErrMsg: String;
begin
  if not CheckForSimilarName(cbxPtProvider, rtnErrMsg, sPr) then
  begin
    if rtnErrMsg <> '' then
      SetError(rtnErrMsg, AnErrMsg);
  end;
  if ((lblSurgeon.Caption[1] = '*') and (StrToInt64Def(ALabTest.SurgeonInternal, 0) < 1)) then
    SetError(TX_NO_SURGEON, AnErrMsg);
end;

procedure TfrmODAnatPath.SurgeonPhysicianP(var sType: string;
  var sOldVal: string; var sNewVal: string; sValue: string);
var
  eValue: Int64;
begin
  sType := 'SURGEON/PHYSICIAN';
  sOldVal := cbxPtProvider.Text;
  eValue := StrToInt64Def(sValue, 0);
  if eValue > 0 then
  begin
    cbxPtProvider.SetExactByIEN(eValue, ExternalName(eValue, 200));
    TSimilarNames.RegORComboBox(cbxPtProvider);
    cbxPtProviderChange(nil);
  end;
  sNewVal := cbxPtProvider.Text;
end;

procedure TfrmODAnatPath.AnticoagulationO(sHide,sReq,sDef: string);
begin
  if sReq = '1' then
    AlterCaption(lblAntiCoag, True);
  if ((FOrderAction in [ORDER_COPY, ORDER_EDIT, ORDER_QUICK]) and
      (ALabTest.OrderComment.Count > 0)) then
    edtAntiCoag.Text := Trim(ALabTest.OrderComment.Text)
  else if sDef <> '' then
    edtAntiCoag.Text := sDef;
  ledtCommentAntiCoagulantExit(nil);
end;

procedure TfrmODAnatpath.AnticoagulationV(var AnErrMsg: string);
begin
  if lblAntiCoag.Caption[1] = '*' then
    if Pos('Anticoagulant', ALabtest.OrderComment.Text) = 0 then
      SetError(TX_ANTICOAG_REQD, AnErrMsg);
end;

procedure TfrmODAnatPath.AnticoagulationP(var sOldVal: string; var sNewVal: string;
  sValue: string);
begin
  sOldVal := edtAntiCoag.Text;
  edtAntiCoag.Text := sValue;
  ledtCommentAntiCoagulantExit(nil);
  sNewVal := edtAntiCoag.Text;
end;

procedure TfrmODAnatPath.DoseDrawTimesO(sHide,sReq,sDef: string);
begin
  if sReq = '1' then
  begin
    AlterCaption(lblDose, True);
    AlterCaption(lblDraw, True);
  end;
end;

procedure TfrmODAnatpath.DoseDrawTimesV(var AnErrMsg: string);
begin
  if lblDose.Caption[1] = '*' then
    if (Pos('Last dose:', ALabtest.OrderComment.Text) = 0) or
       (Pos('draw time:', ALabtest.OrderComment.Text) = 0) then
      SetError(TX_DOSEDRAW_REQD, AnErrMsg);
end;

procedure TfrmODAnatPath.DropDownSpecimens(Sender: TObject);
begin
  if FDropDownSpecs then
  begin
    cbxSpecimenSelect.SetFocus;
    cbxSpecimenSelect.DroppedDown := False;
    cbxSpecimenSelect.DroppedDown := True;
    FDropDownSpecs := false;
  end;
end;

procedure TfrmODAnatPath.OrderCommentO(sHide,sReq,sDef: string);
begin
  if sReq = '1' then
    AlterCaption(lblOrderComment, True);
  if ((FOrderAction in [ORDER_COPY, ORDER_EDIT, ORDER_QUICK]) and
      (ALabTest.OrderComment.Count > 0)) then
    edtOrderComment.Text := Trim(ALabTest.OrderComment.Text)
  else if sDef <> '' then
    edtOrderComment.Text := sDef;
  ledtOrderCommentExit(nil);
end;

procedure TfrmODAnatpath.OrderCommentV(var AnErrMsg: string);
begin
  if lblOrderComment.Caption[1] = '*' then
    if Trim(ALabTest.OrderComment.Text) = '' then
      SetError(TX_NO_COMMENT, AnErrMsg);
end;

procedure TfrmODAnatPath.OrderCommentP(var sOldVal: string; var sNewVal: string;
  sValue: string);
begin
  sOldVal := edtOrderComment.Text;
  edtOrderComment.Text := sValue;
  ledtOrderCommentExit(nil);
  sNewVal := edtOrderComment.Text;
end;

procedure TfrmODAnatPath.TDMPeakTroughO(sHide,sReq,sDef: string);
begin
  if sReq = '1' then
    AlterCaption(lblPeakTrough, True);
  if ((FOrderAction in [ORDER_COPY, ORDER_EDIT, ORDER_QUICK]) and
      (ALabTest.OrderComment.Count > 0)) then
    edtPeakComment.Text := Trim(ALabTest.OrderComment.Text)
  else if sDef <> '' then
    edtPeakComment.Text := sDef;
  edtPeakCommentExit(nil);
end;

procedure TfrmODAnatpath.TDMPeakTroughV(var AnErrMsg: string);
begin
  if lblPeakTrough.Caption[1] = '*' then
    if Pos('Dose is expected', ALabTest.OrderComment.Text) = 0 then
      SetError(TX_TDM_REQD, AnErrMsg);
end;

procedure TfrmODAnatPath.TDMPeakTroughP(var sOldVal: string; var sNewVal: string;
  sValue: string);
begin
  sOldVal := edtPeakComment.Text;
  edtPeakComment.Text := sValue;
  edtPeakCommentExit(nil);
  sNewVal := edtPeakComment.Text;
end;

procedure TfrmODAnatPath.TransfusionO(sHide,sReq,sDef: string);
begin
  if sReq = '1' then
    AlterCaption(lblOrderComment, True);
  if ((FOrderAction in [ORDER_COPY, ORDER_EDIT, ORDER_QUICK]) and
      (ALabTest.OrderComment.Count > 0)) then
    edtOrderComment.Text := Trim(ALabTest.OrderComment.Text)
  else if sDef <> '' then
    edtOrderComment.Text := sDef;
  ledtOrderCommentExit(nil);
end;

procedure TfrmODAnatpath.TransfusionV(var AnErrMsg: string);
begin
  if lblOrderComment.Caption[1] = '*' then
    if Trim(ALabTest.OrderComment.Text) = '' then
      SetError(TX_NO_COMMENT, AnErrMsg);
end;

procedure TfrmODAnatPath.TransfusionP(var sOldVal: string; var sNewVal: string;
  sValue: string);
begin
  sOldVal := edtOrderComment.Text;
  edtOrderComment.Text := sValue;
  ledtOrderCommentExit(nil);
  sNewVal := edtOrderComment.Text;
end;

procedure TfrmODAnatPath.UrineVolumeO(sHide,sReq,sDef: string);
var
  iValue: Integer;
begin
  if sReq = '1' then
    AlterCaption(lblUrineVolume, True);
  if ((FOrderAction in [ORDER_COPY, ORDER_EDIT, ORDER_QUICK]) and
      (ALabTest.OrderComment.Count > 0)) then
  begin
    iValue := ExtractInteger(ALabTest.OrderComment.Text);
    if iValue >= 0 then
      spnedtUrineVolume.Value := iValue;
  end
  else if sDef <> '' then
    if TryStrToInt(sDef, iValue) then
      spnedtUrineVolume.Value := iValue;
  CommentUrineVolumeChange(nil);
end;

procedure TfrmODAnatpath.UrineVolumeV(var AnErrMsg: string);
begin
  if lblUrineVolume.Caption[1] = '*' then
  begin
    if ((Trim(ALabTest.OrderComment.Text) <> '') and
        (ExtractInteger(ALabTest.OrderComment.Text) <= 0)) then
      SetError(TX_URINE_REQD, AnErrMsg);
    if not rbtnUrineML.Checked and not rbtnUrineCC.Checked and not rbtnUrineOZ.Checked then
      SetError(TX_URINE_MEASURE, AnErrMsg);
  end;
end;

procedure TfrmODAnatPath.UrineVolumeP(var sOldVal: string; var sNewVal: string;
  sValue: string);
var
  iValue: Integer;
begin
  sOldVal := spnedtUrineVolume.Text;
  if TryStrToInt(sValue, iValue) then
  begin
    spnedtUrineVolume.Text := sValue;
    CommentUrineVolumeChange(nil);
  end;
  sNewVal := spnedtUrineVolume.Text;
end;

procedure TfrmODAnatPath.OrderCommentCollectionO(sHide,sReq,sDef: string);
begin
  if ALabTest <> nil then
  begin
    case FCmtTypes.IndexOf(ALabTest.ReqOrderCommentType) of
      0 : AnticoagulationO(sHide, sReq, sDef);
      1 : DoseDrawTimesO(sHide, sReq, sDef);
      2 : OrderCommentO(sHide, sReq, sDef);
      3 : OrderCommentO(sHide, sReq, sDef);
      4 : TDMPeakTroughO(sHide, sReq, sDef);
      5 : TransfusionO(sHide, sReq, sDef);
      6 : UrineVolumeO(sHide, sReq, sDef);
      else OrderCommentO(sHide, sReq, sDef);
    end;
  end
  else
    OrderCommentO(sHide, sReq, sDef);

  if sHide = '1' then
  begin
    pnlOrderComment.Visible := False;
    FReqCommentIdx := 7;
    ResetGrid;
  end;
end;

procedure TfrmODAnatpath.OrderCommentCollectionV(var AnErrMsg: string);
begin
  case FCmtTypes.IndexOf(ALabTest.ReqOrderCommentType) of
    0 : AnticoagulationV(AnErrMsg);
    1 : DoseDrawTimesV(AnErrMsg);
    2 : OrderCommentV(AnErrMsg);
    3 : OrderCommentV(AnErrMsg);
    4 : TDMPeakTroughV(AnErrMsg);
    5 : TransfusionV(AnErrMsg);
    6 : UrineVolumeV(AnErrMsg);
    else if ((ALabTest.ReqOrderCommentType <> '') and (ALabTest.OrderComment.Count < 1)) then
      SetError(TX_NO_COMMENT, AnErrMsg);
  end;
end;

procedure TfrmODAnatPath.OrderCommentCollectionP(var sType: string;
  var sOldVal: string; var sNewVal: string; sValue: string);
begin
  sType := 'ORDER COMMENT';
  case FCmtTypes.IndexOf(ALabTest.ReqOrderCommentType) of
    0 : AnticoagulationP(sOldVal, sNewVal, sValue);
    1 : ;
    2 : OrderCommentP(sOldVal, sNewVal, sValue);
    3 : OrderCommentP(sOldVal, sNewVal, sValue);
    4 : TDMPeakTroughP(sOldVal, sNewVal, sValue);
    5 : TransfusionP(sOldVal, sNewVal, sValue);
    6 : UrineVolumeP(sOldVal, sNewVal, sValue);
    else
    begin
      edtOrderComment.Text := sValue;
      ledtOrderCommentExit(nil);
    end;
  end;
end;

procedure TfrmODAnatPath.OrderElementsWithinPages;
var
  sl: TStringList;
  I,J: Integer;
  tbsht: TTabSheet;
  mBuilder: TfraAnatPathBuilder;

begin
  sl := TStringList.Create;
  try
    OrderElements('P', ALabTest.OrderableItemInternal, sl);
    // P^NUMBER^NAME^PROMPT_ID
    if ((sl.Count > 0) and (sl[0] <> '0')) then
    begin
      if not pgctrlText.Visible then
      begin
        ForceToFitScreen;
        pgctrlText.Visible := True;
        pgctrlText.Top := pnlTabs.Top + pnlTabs.Height + 5;
        pgctrlText.Height := memOrder.Top - pgctrlText.Top - 5;
      end;

      for I := 0 to sl.Count - 1 do
      begin
        tbsht := TTabSheet.Create(pgctrlText);
        tbsht.PageControl := pgctrlText;
        tbsht.Caption := Piece(sl[I],U,3);

        mBuilder := TfraAnatPathBuilder.CreateBuilder(MainFontSize, tbsht);
        mBuilder.Parent := tbsht;
        mBuilder.LabText.PromptID := Piece(sl[I],U,4);
        mBuilder.Show;

        if FOrderAction in [ORDER_COPY, ORDER_EDIT, ORDER_QUICK] then
          for J := 0 to ALabTest.LabTextList.Count - 1 do
            if ((ALabTest.LabTextList.Items[J].Owner = nil) and
                (ALabTest.LabTextList.Items[J].PromptID = mBuilder.LabText.PromptID)) then
            begin
              mBuilder.LabText.Free;
              mBuilder.LabText := ALabTest.LabTextList.Items[J];
              Break;
            end;
      end;
    end;
  finally
    sl.Free;
  end;
end;

procedure TfrmODAnatPath.SpecimenPages;
var
  I: Integer;
begin
  cbxSpecimenSelect.Clear;
  lvwSpecimen.Clear;

  for I := pgctrlSpecimen.PageCount - 1 downto 0 do
    pgctrlSpecimen.Pages[I].Free;

  UpdatePageCounts;
end;

procedure TfrmODAnatPath.CollectionSamplesV(var AnErrMsg: string);
var
  bC,bS: Boolean;
  I: Integer;
begin
  if pgctrlSpecimen.PageCount < 1 then
  begin
    SetError(TX_NO_SPECIMEN, AnErrMsg);
    SetError(TX_NO_COLLSAMPLE, AnErrMsg);
  end
  else
  begin
    bC := False;
    bS := False;
    for I := 0 to ALabTest.LabSpecimenList.Count - 1 do
    begin
      if ((StrToIntDef(ALabTest.LabSpecimenList.Items[I].CollectionSampleInternal, 0) < 1) and (not bC)) then
      begin
        bC := True;
        SetError(TX_NO_COLLSAMPLE, AnErrMsg);
      end;
      if ((ALabTest.LabSpecimenList.Items[I].SpecimenDescription = '') and (not bS)) then
      begin
        bS := True;
        SetError(TX_NO_SPECDESC, AnErrMsg);
      end;
    end;
  end;
end;

procedure TfrmODAnatPath.WordProcessingPages;
var
  I: Integer;
begin
  for I := pgctrlText.PageCount - 1 downto 0 do
    pgctrlText.Pages[I].Free;
end;

// Called by InitDialog and Test Selection
procedure TfrmODAnatpath.ResetDialog;
begin
  StatusText('Reseting Dialog Form');
  if ALabTest <> nil then
    FreeandNil(ALabTest);

  Changing := True;

  cbxSpecimenSelect.Enabled := True;
  pnlAddSingleSpecimen.Visible := False;

  ResetOrderGrid;

  InitControls;
  Urgency;
  // *** Collection Date/Time - Done through calCollTime
  SpecimenSubmitted;
  CollectionType;
  Frequency;
  SurgeonPhysician;

  SpecimenPages;
  WordProcessingPages;

//  Constraints.MinHeight := Height - pgctrlText.Height - 5;
//  Constraints.MaxHeight := Constraints.MinHeight;
  pgctrlText.Visible := False;
//  Height := Constraints.MinHeight;

  Changing := False;
  StatusText('');
end;

procedure TfrmODAnatPath.ResetGrid;
var
  btn, edt, i, hidx, sidx, size: integer;

  procedure setRow(idx, val: integer);
  begin
    gpMain.RowCollection[idx].Value := val;
  end;

begin
  gpMain.RowCollection.BeginUpdate;
  try
    if FMissingGroupsMessage = '' then
      SetRow(0, FlblHeight)
    else
      SetRow(0, FlblHeight + 4);
    edt := FlblHeight + EDIT_BUMP;
    btn := edt + EDIT_BUMP;
    for i := 1 to 4 do
      SetRow(i, edt);
    for i := 5 to 9 do
      if i = FReqCommentIdx then
        SetRow(i, btn)
      else
        SetRow(i, 0);
    SetRow(10, edt);

    if pgctrlSpecimen.PageCount < 1 then
    begin
      hidx := 11;
      sidx := 12;
    end
    else
    begin
      sidx := 11;
      hidx := 12;
    end;

    pgctrlText.Visible := (pgctrlText.PageCount > 0);

    If pgctrlText.PageCount < 1 then
      size := 100
    else
      size := 50;
    gpMain.RowCollection[sIdx].Value := size;
    gpMain.RowCollection[hidx].Value := 0;
    gpMain.RowCollection[13].Value := 100 - size;

    SetRow(14, btn);
    SetRow(15, btn);
    if pnlMessage.Visible then
      SetRow(16, btn * 2)
    else
      SetRow(16, 0);
  finally
    gpMain.RowCollection.EndUpdate;
  end;
  ForceToFitScreen;
end;

procedure TfrmODAnatPath.Validate(var AnErrMsg: string);

  procedure CheckRequiredSepcimenFields(var AnErrMsg: string);
  var
    i, j: Integer;
    LabSpecimen: TLabSpecimen;
    BuildElement: TBuilderElement;

  begin
    for i := 0 to ALabTest.LabSpecimenList.Count - 1 do
    begin
      LabSpecimen := ALabTest.LabSpecimenList.Items[I];
      if assigned(LabSpecimen.Owner) then
        for j := 0 to LabSpecimen.Owner.Elements.Count - 1 do
        begin
          BuildElement := TBuilderElement(LabSpecimen.Owner.Elements.Objects[j]);
          if BuildElement.Required and (BuildElement.Value = '') then
            SetError('The ' + LabSpecimen.SpecimenDescription + ' required field ' +
              BuildElement.GetCaptionwoReq + ' has not been entered.', AnErrMsg);
        end;
    end;
  end;

  procedure CheckRequiredPageFields(var AnErrMsg: string);
  var
    i, j: Integer;
    BuildElement: TBuilderElement;
    BuildItem: TBuilderClusterItem;
    txt: string;
    NeedTxt: boolean;

  begin
  // *** Pages
    for i := 0 to ALabTest.LabTextList.Count - 1 do
      if assigned(ALabTest.LabTextList.Items[i].Owner) then
        if ALabTest.LabTextList.Items[i].Owner.Required then
        begin
          NeedTxt := not ALabTest.LabTextList.Items[i].Owner.Valid;
          for j := 0 to ALabTest.LabTextList.Items[i].Owner.Elements.Count - 1 do
          begin
            BuildElement := ALabTest.LabTextList.Items[i].Owner.Elements[j];
            if BuildElement.Required then
            begin
              if BuildElement.Value = '' then
              begin
                SetError('The required field ' + BuildElement.GetCaptionwoReq +
                  ' on the required page ' + ALabTest.LabTextList.Items[i].Owner.GetCaption +
                  ' has not been entered.', AnErrMsg);
                NeedTxt := False;
              end
              else
              begin
                BuildItem := BuildElement.ClusterElement.GetItembyValue(BuildElement.Value);
                if Assigned(BuildItem) and (BuildElement.ValueEx = '') then
                begin
                  if BuildItem.Associated is TAssociatedDate then
                    txt := 'date'
                  else if BuildItem.Associated is TAssociatedEdit then
                    txt := 'edit'
                  else
                    txt := '';
                  if txt <> '' then
                  begin
                    SetError('The required field ' + BuildElement.GetCaptionwoReq +
                      ', ' + BuildElement.Value + ' entry, on the required page ' +
                       ALabTest.LabTextList.Items[i].Owner.GetCaption +
                      ', has an empty ' + txt + ' field.', AnErrMsg);
                    NeedTxt := False;
                  end;
                end;
              end;
            end;
          end;
          if NeedTxt then
            SetError(ALabTest.LabTextList.Items[i].Owner.GetCaption +
              ' has not been completed.', AnErrMsg);
        end
  end;

begin
  UpdateAllOrderResponses;

  inherited;

  // *** Orderable Item
  if ALabTest = nil then
  begin
    SetError(TX_NO_TESTS, AnErrMsg);
    Exit;
  end;

  UrgencyV(AnErrMsg);
  CollectionDateTimeV(AnErrMsg);
  SpecimenSubmittedV(AnErrMsg);
  CollectionTypeV(AnErrMsg);
  FrequencyV(AnErrMsg);
  SurgeonPhysicianV(AnErrMsg);
  OrderCommentCollectionV(AnErrMsg);
  CollectionSamplesV(AnErrMsg);

  if not UniqueSpecimenDescs then
    SetError(TX_SPECDESC_UQ, AnErrMsg);

  CheckRequiredSepcimenFields(AnErrMsg);

  CheckRequiredPageFields(AnErrMsg);
end;

procedure TfrmODAnatPath.Stack(pnl: TPanel; bAction: Boolean);
begin
  if bAction then
  begin
    pnl.Visible := True;
    pnl.BringToFront;
  end
  else
  begin
    pnl.SendToBack;
    pnl.Visible := False;
  end;
end;

procedure TfrmODAnatPath.Switch(iCmtType: Integer; bAction: Boolean);
begin
  case iCmtType of
    0 : Stack(pnlAntiCoagulation, bAction);           // ANTICOAGULATION
    1 : Stack(pnlDoseDraw, bAction);                  // DOSE/DRAW TIMES
    2 : Stack(pnlOrderComment, bAction);              // ORDER COMMENT
    3 : Stack(pnlOrderComment, bAction);              // ORDER COMMENT MODIFIED
    4 : Stack(pnlPeakTrough, bAction);                // TDM PEAK-TROUGH
    5 : Stack(pnlOrderComment, bAction);              // TRANSFUSION
    6 : begin                                         // URINE VOLUME
          Stack(pnlUrineVolume, bAction);
          if bAction then
            CommentUrineVolumeChange(nil);
        end;
  end;
end;

function TfrmODAnatPath.UrineUnits: string;
begin
  if rbtnUrineML.Checked then
    Result := 'ml'
  else if rbtnUrineCC.Checked then
    Result := 'cc'
  else if rbtnUrineOZ.Checked then
    Result := 'oz'
  else
    Result := '';
end;

procedure TfrmODAnatPath.UMDeleteSpecimen(var Message: TMessage);
var
  iPage,I: Integer;
  tbsht: TTabSheet;

begin
  tbsht := TTabSheet(Message.WParam);
  iPage := tbsht.PageIndex;
  pgctrlSpecimen.Pages[iPage].Free;

  lvwSpecimen.Items.Delete(iPage);
  for I := 0 to lvwSpecimen.Items.Count - 1 do
    lvwSpecimen.Items[I].Caption := IntToStr(I + 1);

  pgctrlSpecimen.ActivePageIndex := pgctrlSpecimen.PageCount - 1;
  lvwSpecimen.Selected := lvwSpecimen.Items[pgctrlSpecimen.ActivePageIndex];
  SetSpecimenActiveSelected;
  FSpecimenChanging := False;

  UpdatePageCounts;
end;

procedure TfrmODAnatPath.UMMisc(var Message: TMessage);
begin
  cbxSpecimenSelect.SetFocus;
  cbxSpecimenSelect.DroppedDown := True;
  FDropDownSpecs := True;
  FSpecSelectRedirectTabStop := True;
end;

function TfrmODAnatPath.UniqueSpecimenDescs: Boolean;
var
  I,J: Integer;
  LabSpecimen: TLabSpecimen;
begin
  Result := True;

  for I := 0 to ALabTest.LabSpecimenList.Count - 1 do
  begin
    LabSpecimen := ALabTest.LabSpecimenList.Items[I];
    for J := 0 to ALabTest.LabSpecimenList.Count - 1 do
      if LabSpecimen <> ALabTest.LabSpecimenList.Items[J] then
        if CompareStrSpaces(LabSpecimen.SpecimenDescription,
                            ALabTest.LabSpecimenList.Items[J].SpecimenDescription) then
        begin
          Result := False;
          Exit;
        end;
  end;
end;

function TfrmODAnatPath.IsValid: Boolean;
var
  sErrMsg: string;
begin
  Result := True;

  Validate(sErrMsg);

  if Length(sErrMsg) > 0 then
  begin
    ShowMsg('This order cannot be saved for the following reason(s):' + CRLF + CRLF + sErrMsg);
    Result := False;
  end;
end;

function TfrmODAnatPath.DoesPromptIDExist(sPromptID: string): Boolean;
var
  I: Integer;
begin
  Result := False;

  if ALabTest = nil then
    Exit;
  if ALabTest.LabTextList = nil then
    Exit;

  for I := 0 to ALabTest.LabTextList.Count - 1 do
    if sPromptID = ALabTest.LabTextList.Items[I].PromptID then
    begin
      Result := True;
      Break;
    end;
end;

// Public ----------------------------------------------------------------------

// Called on Edit/Change
procedure TfrmODAnatPath.SetupDialog(OrderAction: Integer; const ID: string);
begin
  inherited;

  FOrderAction := OrderAction;
  StatusText('Setting Up Dialog');

  // EDIT ACTION ***************************************************************
  if FOrderAction in [ORDER_COPY, ORDER_EDIT, ORDER_QUICK] then
  begin
    StatusText('Retrieving Data');

    // *** ORDERABLE ITEM
    Responses.SetControl(cbxAvailTest, 'ORDERABLE', 1);
    cbxAvailTestChange(nil);
    cbxAvailTest.Enabled := False;
    lblAvailTest.Enabled := False;
  end;
  // EDIT ACTION ***************************************************************

  StatusText('');
end;

procedure TfrmODAnatPath.LoadRequiredComment(iCmtType: Integer);
var
  I: Integer;
begin
  case iCmtType of
    0: FReqCommentIdx := 5;
    1: FReqCommentIdx := 6;
    2: FReqCommentIdx := 7;
    3: FReqCommentIdx := 7;
    4: FReqCommentIdx := 8;
    5: FReqCommentIdx := 7;
    6: FReqCommentIdx := 9;
  end;

  for I := 0 to 6 do
    Switch(I, False);

  Switch(iCmtType, True);

  ResetGrid;
end;

procedure TfrmODAnatPath.DeleteSpecimenPage(tbsht: TTabSheet);
begin
  PostMessage(Self.Handle, UM_OBJDESTROY, WParam(tbsht), 0);
end;

procedure TfrmODAnatPath.UpdatePageCounts;
var
  text: string;

begin
  if pgctrlSpecimen.PageCount < 1 then
  begin
    pnlTotal.Caption := '';
    pnlTotal.TabStop := False;
    if cbxSpecimenSelect.Items.Count > 1 then
      lblSpecMessage.Caption := 'Please select at least one specimen type from the drop-down list to process the order'
    else
      lblSpecMessage.Caption := 'At least one specimen along with a specimen description is required to process an order.';

    if ALabTest <> nil then
    begin
      if (ALabTest.RestrictMulti and (cbxSpecimenSelect.Items.Count > 1)) then
      begin
        cbxSpecimenSelect.Enabled := True;
        pnlAddSingleSpecimen.Visible := False;
      end;
      if ScreenReaderActive then
      begin
        text := lblSpecMessage.Caption;
        text.Replace('-',' ');
        GetScreenReader.Speak(text);
      end;
    end;
  end
  else
  begin
    pnlTotal.Caption := 'Currently Viewing Specimen #' +
                        IntToStr(pgctrlSpecimen.ActivePageIndex + 1) + ' of ' +
                        IntToStr(pgctrlSpecimen.PageCount);
    pnlTotal.TabStop := ScreenReaderActive;
  end;
  ResetGrid;
  if (not ScreenReaderActive) and (pgctrlSpecimen.PageCount < 1) and
    (cbxSpecimenSelect.Items.Count > 1) then
    PostMessage(Self.Handle, UM_MISC, 0, 0)
  else
    FDropDownSpecs := False;
end;

procedure TfrmODAnatPath.UpdateSpecimenResponses(bUpdate: Boolean);
var
  I: Integer;
  AResponse: TResponse;
begin
  if Changing or (ALabTest = nil) then
    Exit;

  for I := Responses.TheList.Count - 1 downto 0 do
  begin
    AResponse := TResponse(Responses.TheList[I]);
    if (AResponse.PromptID = 'SPECIMEN') or
       (AResponse.PromptID = 'SPECDESC') or
       (AResponse.PromptID = 'SAMPLE') then
    begin
      Responses.TheList.Delete(I);
      AResponse.Free;
    end;
  end;

  UpdateSpecimenResponsesQuick(False);

  if bUpdate then
    UpdateOrderText;
end;

procedure TfrmODAnatPath.UpdateSpecimenResponsesQuick(bUpdate: Boolean);
var
  I: Integer;
  LabSpecimen: TLabSpecimen;
begin
  if Changing or (ALabTest = nil) then
    Exit;

  for I := 0 to ALabTest.LabSpecimenList.Count - 1 do
  begin
    LabSpecimen := ALabTest.LabSpecimenList.Items[I];
    Responses.Update('SPECIMEN', (I+1), LabSpecimen.SpecimenInternal, LabSpecimen.SpecimenExternal);
    Responses.Update('SPECDESC', (I+1), LabSpecimen.SpecimenDescription, LabSpecimen.SpecimenDescription);
    Responses.Update(  'SAMPLE', (I+1), LabSpecimen.CollectionSampleInternal, LabSpecimen.CollectionSampleExternal);
  end;

  if bUpdate then
    UpdateOrderText;
end;

procedure TfrmODAnatPath.UpdateTextResponses(bUpdate: Boolean);
var
  I: Integer;
  AResponse: TResponse;
begin
  if Changing or (ALabTest = nil) then
    Exit;

  for I := Responses.TheList.Count - 1 downto 0 do
  begin
    AResponse := TResponse(Responses.TheList[I]);
    if DoesPromptIDExist(AResponse.PromptID) then
    begin
      Responses.TheList.Delete(I);
      AResponse.Free;
    end;
  end;

  UpdateTextResponsesQuick(False);

  if bUpdate then
    UpdateOrderText;
end;

procedure TfrmODAnatPath.UpdateTextResponsesQuick(bUpdate: Boolean);
var
  sl: TStringList;
  I: Integer;
begin
  if Changing or (ALabTest = nil) then
    Exit;

  sl := TStringList.Create;
  try
    for I := 0 to ALabTest.LabTextList.Count - 1 do
    begin
      ALabTest.LabTextList.Items[I].GetText(sl);
      Responses.Update(ALabTest.LabTextList.Items[I].PromptID,
                       ALabTest.TextInstance(ALabTest.LabTextList.Items[I].PromptID,
                       ALabTest.LabTextList.Items[I]),
                       TX_WPTYPE, sl.Text);
    end;
  finally
    sl.Free;
  end;

  if bUpdate then
    UpdateOrderText;
end;

procedure TfrmODAnatPath.UpdateOrderText;
begin
  memOrder.Text := Responses.OrderText;
end;

procedure TfrmODAnatPath.ChangeOrderPromptValue(sID: string; sValue: string);
var
  opCode: TOrderPrompt;
  sType,sOldVal,sNewVal,sMessage: string;
begin
  if sValue = '' then
    Exit;

  Changing := True;
  try
    if not ValidOrderPromptID(sID, opCode) then
      Exit;

    case opCode of
      opURG : UrgencyP(sType, sOldVal, sNewVal, sValue);
      opCDT : ;
      opSSB : SpecimenSubmittedP(sType, sOldVal, sNewVal, sValue);
      opCTY : CollectionTypeP(sType, sOldVal, sNewVal, sValue);
      opHOF : FrequencyP(sType, sOldVal, sNewVal, sValue);
      opSPH : SurgeonPhysicianP(sType, sOldVal, sNewVal, sValue);
      opODC : OrderCommentCollectionP(sType, sOldVal, sNewVal, sValue);
    end;

    if ((sType <> '') and (FChangeMessage <> '') and (sOldVal <> sNewVal)) then
    begin
      sMessage := StringReplace(FChangeMessage, '<cType>', sType, [rfReplaceAll, rfIgnoreCase]);
      sMessage := StringReplace(sMessage, '<oVal>', sOldVal, [rfReplaceAll, rfIgnoreCase]);
      sMessage := StringReplace(sMessage, '<nVal>', sNewVal, [rfReplaceAll, rfIgnoreCase]);
      sMessage := StringReplace(sMessage, '$C(13,10)', CRLF, [rfReplaceAll, rfIgnoreCase]);
      ShowMsg(sMessage);
    end;
  finally
    Changing := False;
  end;

  UpdateAllLegacyResponses(False);
  UpdateLegacyCommentResponse(True);
end;

function TfrmODAnatPath.GetSummary: string;
begin
  Result := ALabTest.OrderableItemExternal + ' ' + ALabTest.UrgencyExternal + ' ' +
            ALabTest.CollectionTypeExternal;
end;

function TfrmODAnatPath.GetOrderComment: string;
begin
  Result := '';

  case FCmtTypes.IndexOf(ALabTest.ReqOrderCommentType) of
    0 : if edtAntiCoag.Text <> '' then                                                 // ANTICOAGULATION
          Result := 'Anticoagulant: ' + edtAntiCoag.Text;
    1 : if (calDoseTime.Text <> '') or (calDrawTime.Text <> '') then
          Result := 'Last dose: ' + calDoseTime.Text + '   draw time: '+ calDrawTime.Text;   // DOSE/DRAW TIMES
    2 : Result := edtOrderComment.Text;                                                     // ORDER COMMENT
    3 : Result := edtOrderComment.Text;                                                     // ORDER COMMENT MODIFIED
    4 : begin                                                                                // TDM PEAK-TROUGH
          if GetPeakGroupIdx <> -1 then
            Result := 'Dose is expected to be at ' +
            UpperCase(Strip(GetPeakGroupTxt)) + ' level.';
          if edtPeakComment.Text <> '' then
          begin
            if GetPeakGroupIdx <> -1 then
              Result := Result + CRLF + edtPeakComment.Text
            else
              Result := edtPeakComment.Text;
          end;
        end;
    5 : Result := edtOrderComment.Text;                                                     // TRANSFUSION
    6 : Result := spnedtUrineVolume.Text;                                                    // URINE VOLUME
  end;
end;

function TfrmODAnatPath.GetPeakGroupIdx: integer;
begin
  Result := -1;
  if rbPeak.Checked then
    Result := 0
  else
  if rbTrough.Checked then
    Result := 1
  else
  if rbMid.Checked then
    Result := 2
  else
  if rbUnknown.Checked then
    Result := 3
end;

function TfrmODAnatPath.GetPeakGroupTxt: string;
begin
  case GetPeakGroupIdx of
    0: Result := rbPeak.Caption;
    1: Result := rbTrough.Caption;
    2: Result := rbMid.Caption;
    3: Result := rbUnknown.Caption;
    else Result := '';
  end;
end;

function TfrmODAnatPath.GetCurrentSpecimenForm: TfraAnatPathSpecimen;
begin
  Result := nil;

  if pgctrlSpecimen.ActivePage <> nil then
    if pgctrlSpecimen.ActivePage.ControlCount > 0 then
      if pgctrlSpecimen.ActivePage.Controls[0] is TfraAnatPathSpecimen then
        Result := TfraAnatPathSpecimen(pgctrlSpecimen.ActivePage.Controls[0]);
end;

function TfrmODAnatPath.GetSpecificSpecimenForm(tbsht: TTabSheet): TfraAnatPathSpecimen;
begin
  Result := nil;

  if tbsht.ControlCount > 0 then
    if tbsht.Controls[0] is TfraAnatPathSpecimen then
      Result := TfraAnatPathSpecimen(tbsht.Controls[0]);
end;

function TfrmODAnatPath.GetCurrentPagTextForm: TfraAnatPathBuilder;
begin
  Result := nil;

  if pgctrlText.ActivePage <> nil then
    if pgctrlText.ActivePage.ControlCount > 0 then
      if pgctrlText.ActivePage.Controls[0] is TfraAnatPathBuilder then
        Result := TfraAnatPathBuilder(pgctrlText.ActivePage.Controls[0]);
end;

function TfrmODAnatPath.GetSpecificPageTextForm(tbsht: TTabSheet): TfraAnatPathBuilder;
begin
  Result := nil;

  if tbsht.ControlCount > 0 then
    if tbsht.Controls[0] is TfraAnatPathBuilder then
      Result := TfraAnatPathBuilder(tbsht.Controls[0]);
end;

{$ENDREGION}

{$REGION 'TLabTest'}

// Private ---------------------------------------------------------------------

function TLabTest.TextInstance(sPromptID: string; LabText: TLabText): Integer;
var
  I: Integer;
begin
  Result := 1;

  if ALabTest <> nil then
    for I := 0 to ALabTest.LabTextList.Count - 1 do
      if ALabTest.LabTextList.Items[I].PromptID = sPromptID then
      begin
        if ALabTest.LabTextList.Items[I] = LabText then
          Break
        else
          Inc(Result);
      end;
end;

// Protected -------------------------------------------------------------------

procedure TLabTest.GetNextResponseInstance(LabSpecimen: TLabSpecimen; sPrompt: string;
  var iInstance: Integer; Responses: TResponses);
var
  I: Integer;
  rResponse: TResponse;
begin
  for I := 0 to Responses.TheList.Count - 1 do
  begin
    rResponse := TResponse(Responses.TheList[I]);
    if ((rResponse.Instance > iInstance) and (rResponse.PromptID = sPrompt)) then
    begin
      iInstance := rResponse.Instance;

      if sPrompt = 'SPECDESC' then
        LabSpecimen.SpecimenDescription := rResponse.EValue
      else if sPrompt = 'SAMPLE' then
      begin
        LabSpecimen.CollectionSampleInternal := rResponse.IValue;
        LabSpecimen.CollectionSampleExternal := rResponse.EValue;
      end;

      Break;
    end;
  end;
end;

procedure TLabTest.Urgency(Responses: TResponses);
begin
  if Length(ExtractDefault(FLoadedTestData, 'Default Urgency')) > 0 then
  begin
    FUrgencyList.Add(ExtractDefault(FLoadedTestData, 'Default Urgency'));
    uDfltUrgency := Piece(ExtractDefault(FLoadedTestData, 'Default Urgency'),U,1);
    UrgencyInternal := uDfltUrgency;
  end
  else
  begin
    ExtractItems(FUrgencyList, FLoadedTestData, 'Urgencies');
    if StrToIntDef(LRFURG, 0) > 0 then
      UrgencyInternal := LRFURG
    else
      UrgencyInternal := uDfltUrgency;
  end;
  if Responses.IValueFor('URGENCY', 1) <> '' then
  begin
    UrgencyInternal := Responses.IValueFor('URGENCY', 1);
    UrgencyExternal := Responses.EValueFor('URGENCY', 1);
  end;
end;

procedure TLabTest.CollectionDateTime(Responses: TResponses);
begin
  CollectionDateTimeInternal := Responses.IValueFor('START', 1);
  CollectionDateTimeExternal := Responses.EValueFor('START', 1);
end;

procedure TLabTest.SpecimenSubmitted(Responses: TResponses);
begin
  SpecimenSubmittedBy := Responses.EValueFor('SPCSUBMIT', 1);
end;

procedure TLabTest.CollectionType(Responses: TResponses);
begin
  CollectionTypeInternal := Responses.IValueFor('COLLECT', 1);
  CollectionTypeExternal := Responses.EValueFor('COLLECT', 1);
end;

procedure TLabTest.Schedule(Responses: TResponses);
begin
  ScheduleInternal := Responses.IValueFor('SCHEDULE', 1);
  ScheduleExternal := Responses.EValueFor('SCHEDULE', 1);
  HowMany := Responses.EValueFor('DAYS', 1);
end;

procedure TLabTest.SurgeonPhysician(Responses: TResponses);
begin
  SurgeonInternal := Responses.IValueFor('SURGPROV', 1);
  SurgeonExternal := Responses.EValueFor('SURGPROV', 1);
end;

procedure TLabTest.CollectionSample;
var
  sString: string;
begin
  sString := ExtractDefault(FLoadedTestData, 'Lab CollSamp');
  if Length(sString) = 0 then
  begin
    sString := ExtractDefault(FLoadedTestData, 'Default CollSamp');
    if StrToIntDef(sString, 0) > 0 then
      sString := SetDefColl(sString);
  end;
  if Length(sString) = 0 then
    sString := '-1';
  uDfltCollSamp := sString;
end;

procedure TLabTest.Specimen(Responses: TResponses);
var
  I,iDesc,iColl: Integer;
  rResponse: TResponse;
  LabSpecimen: TLabSpecimen;
begin
  // *** Specimen, Specimen Description, Collection Sample (TLabSpecimen)
  //     CPRS reports the element instance incorrectly so what we are seeing is
  //     say a specimen with instance 3 and 6 when there are only two instances
  //     of a specimen (1 and 2). Therefore, we cannot group specimen instance 1
  //     with description instance 1 and collection sample instance 1 because the
  //     instances do not match and do not indentify how many of a thing there is.
  iDesc := -1;
  iColl := -1;
  for I := 0 to Responses.TheList.Count - 1 do
  begin
    rResponse := TResponse(Responses.TheList[I]);
    if rResponse.PromptID = 'SPECIMEN' then
    begin
      LabSpecimen := TLabSpecimen.Create(nil);
      FLabSpecimenList.Add(LabSpecimen);
      // Specimen
      LabSpecimen.SpecimenInternal := rResponse.IValue;
      LabSpecimen.SpecimenExternal := rResponse.EValue;
      // Get Specimen Description with a greater instance than the last
      GetNextResponseInstance(LabSpecimen, 'SPECDESC', iDesc, Responses);
      // Get Collection Sample with a greater instance than the last
      GetNextResponseInstance(LabSpecimen, 'SAMPLE', iColl, Responses);
    end;
  end;
end;

function TLabTest.SetDefColl(sIndex: string): string;
var
  sl: TStringList;
  I: Integer;
begin
  Result := '';

  sl := TStringList.Create;
  try
    ExtractItems(sl, FLoadedTestData, 'CollSamp');
    for I := 0 to sl.Count - 1 do
      if Piece(sl[I],U,1) = sIndex then
      begin
        Result := Piece(sl[I],U,2);
        Break;
      end;
  finally
    sl.Free;
  end;
end;

// Public ----------------------------------------------------------------------

constructor TLabTest.Create(const iLabTestIEN: Integer; Responses: TResponses);
var
  I: Integer;
  rResponse: TResponse;
  LabText: TLabText;
begin
  FLoadedTestData := TStringList.Create;
  FUrgencyList := TStringList.Create;
  FOrderComment := TStringList.Create;
  FSpecimenList := TStringList.Create;
  FCurWardComment := TStringList.Create;
  FLabSpecimenList := TObjectList<TLabSpecimen>.Create(False);
  FLabTextList := TObjectList<TLabText>.Create(False);

  // Loads Urgency and Collection Sample (also loads specimen) for a Test
  LoadLabTestData(FLoadedTestData, IntToStr(iLabTestIEN));
  OrderableItemInternal := IntToStr(iLabTestIEN);
  OrderableItemExternal := Piece(ExtractDefault(FLoadedTestData, 'Test Name'),U,1);
  FLabSubscript := Piece(ExtractDefault(FLoadedTestData, 'Item ID'),U,2);
  ExtractText(FCurWardComment, FLoadedTestData, 'GenWardInstructions');
  FCurReqComment := ExtractDefault(FLoadedTestData, 'ReqCom');

  Urgency(Responses);
  CollectionDateTime(Responses);
  SpecimenSubmitted(Responses);
  CollectionType(Responses);
  Schedule(Responses);
  SurgeonPhysician(Responses);
  CollectionSample;

  // *** Order Comment
  OrderComment.Text := Responses.EValueFor('COMMENT', 1);
  if ((OrderComment.Count > 0) and (Pos('~For Test:', OrderComment[0]) > 0)) then
    OrderComment.Delete(0);

  Specimen(Responses);

  // *** Page Text
  for I := 0 to Responses.TheList.Count - 1 do
  begin
    rResponse := TResponse(Responses.TheList[I]);
    if ((rResponse.IValue = TX_WPTYPE) and (rResponse.PromptID <> 'COMMENT')) then
    begin
      LabText := TLabText.Create(nil);
      LabText.PromptID := rResponse.PromptID;
      LabText.RestoredText.Text := Trim(Responses.EValueFor(rResponse.PromptID, rResponse.Instance));
      FLabTextList.Add(LabText);
    end;
  end;
end;

destructor TLabTest.Destroy;
begin
  FLoadedTestData.Free;
  FUrgencyList.Free;
  FOrderComment.Free;
  FSpecimenList.Free;
  FCurWardComment.Free;

  // Items are freed when the specimen pages are
  FLabSpecimenList.Free;

  // Items are freed when the builder (text) pages are
  FLabTextList.Free;
end;

procedure TLabTest.LoadUrgency(sCollType: string; cbx: TORComboBox);
var
  I,iPreviousSelection: Integer;
  sPreviousSelection: string;
begin
  iPreviousSelection := -1;
  sPreviousSelection := cbx.Text;

  cbx.Clear;
  for I := 0 to FUrgencyList.Count - 1 do
  begin
    if not ((sCollType = 'LC') and (Piece(FUrgencyList[I],U,3) = '')) then
      cbx.Items.Add(FUrgencyList[I]);

    if ((sPreviousSelection <> '') and (sPreviousSelection = Piece(FUrgencyList[I],U,2))) then
      iPreviousSelection := I;
  end;

  if LRFURG <> '' then
    cbx.SelectByID(LRFURG)
  else if iPreviousSelection > -1 then
    cbx.ItemIndex := iPreviousSelection
  else
    cbx.SelectByIEN(StrToIntDef(uDfltUrgency, 0));
end;

procedure TLabTest.LoadSpecimen(cbx: TORComboBox);
var
  bAllowOther: Boolean;
begin
  cbx.Clear;
  bAllowOther := False;

  // FSpecimenList is expected to be empty because the LabList Load and Extract
  // data no longer populates it. Here we will use COLL^LR7OR3 to get the specimen
  // configured in lab (top of list) and ours configured in 69.73 to build the
  // new list.
  APSpecimenList(FTestI, FSpecimenList);
  if FSpecimenList.Count > 0 then
  begin
    if Piece(FSpecimenList[0],U,1) = '1' then
      bAllowOther := True;
    if Piece(FSpecimenList[0],U,2) = '1' then
      RestrictMulti := True;
    FSpecimenList.Delete(0);
  end;

  if FSpecimenList.Count > 0 then
  begin
    FastAssign(FSpecimenList, cbx.Items);
    if bAllowOther then
      cbx.Items.Add('0^Other...');
  end
  else
    cbx.Items.Add('0^Other...');
end;

{$ENDREGION}

end.
