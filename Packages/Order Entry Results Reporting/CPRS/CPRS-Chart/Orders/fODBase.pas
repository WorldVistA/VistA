unit fODBase;

{$OPTIMIZATION OFF}                              // REMOVE AFTER UNIT IS DEBUGGED

interface

uses
  ORExtensions,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, fAutoSz, StdCtrls,
  ORCtrls, ORFn, uConst, rOrders, rODBase, uCore, ComCtrls, ExtCtrls, Menus, Mask,
  Buttons, UBAGlobals, UBACore, VA508AccessibilityManager, CheckLst, uInfoBoxWithBtnControls;

type
  TCtrlInit = class
  private
    Name:   string;
    Text:   string;
    ListID: string;
    List:   TStringList;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TCtrlInits = class
  private
    FDfltList: TList;
    FOIList:   TList;
    procedure ExtractInits(Src: TStrings; Dest: TList);
    function FindInitByName(const AName: string): TCtrlInit;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ClearOI;
    function DefaultText(const ASection: string): string;
    procedure LoadDefaults(Src: TStrings);
    procedure LoadOrderItem(Src: TStrings);
    procedure SetControl(AControl: TControl; const ASection: string);
    procedure SetListOnly(AControl: TControl; const ASection: string);
    procedure SetPopupMenu(AMenu: TPopupMenu; AClickEvent: TNotifyEvent; const ASection: string);
    function TextOf(const ASection: string): string;
  end;

  TResponses = class
  private
    FDialog: string;
    FDialogDisplayName: string;
    FResponseList: TList;
    FPrompts: TList;
    FCopyOrder: string;
    FEditOrder: string;
    FTransferOrder: string;
    FDisplayGroup: Integer;
    FQuickOrder: Integer;
    FOrderChecks: TStringList;
    FVarLeading:  string;
    FVarTrailing: string;
    FEventType: Char;
    FEventIFN: Integer;
    FEventName: string;
    FSpecialty: Integer;
    FEffective: TFMDateTime;
    FParentEvent: TParentEvent;
    FLogTime:   TFMDateTime;
    FViewName: string;
    FCancel: boolean;
    FOrderContainsObjects: boolean;
    FReason : String; //ADDED for NSR 20071211 by KCH on 09/04/2015
    FRemComment : String; //ADDED for NSR 20071211 by KCH on 11/23/2015
    function FindResponseByIEN(APromptIEN, AnInstance: Integer): TResponse;
    function GetOrderText: string;
    function IENForPrompt(const APromptID: string): Integer;
    procedure SetDialog(Value: string);
    procedure SetCopyOrder(const AnID: string);
    procedure SetEditOrder(const AnID: string);
    procedure SetQuickOrder(AnIEN: Integer);
    procedure SetQuickOrderByID(const AnID: string);
    procedure FormatResponse(var FormattedText: string; var ExcludeText: Boolean;
              APrompt: TPrompt; const x: string; AnInstance: Integer);
    function FindPromptByIEN(AnIEN: Integer): TPrompt;
    procedure AppendChildren(var ParentText: string; ChildPrompts: string; AnInstance: Integer);
    procedure BuildOCItems(AList: TStringList; var AStartDtTm: string; const AFillerID: string);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear; overload;
    procedure Clear(const APromptID: string; SaveInstance: Integer = 0); overload;
    function EValueFor(const APromptID: string; AnInstance: Integer): string;
    function GetIENForPrompt(const APromptID: string): Integer;
    function FindResponseByName(const APromptID: string; AnInstance: Integer): TResponse;
    function PromptExists(const APromptID: string):boolean;
    function InstanceCount(const APromptID: string): Integer;
    function IValueFor(const APromptID: string; AnInstance: Integer): string;
    function NextInstance(const APromptID: string; LastInstance: Integer): Integer;
    function IValueExists(const APromptID, AnIValue: string): boolean; // DRM - I10010348FY16/525455 - 2017/6/20
    function TotalRows: Integer;
    function OrderCRC: string;
    procedure Remove(const APromptID: string; AnInstance: Integer);
    procedure SaveQuickOrder(var ANewIEN: Integer; const ADisplayName: string);
    procedure SaveOrder(var AnOrder: TOrder; DlgIEN: Integer; IsIMOOrder: boolean = False);
    procedure SetControl(AControl: TControl; const APromptID: string; AnInstance: Integer);
    procedure SetEventDelay(AnEvent: TOrderDelayEvent);
    procedure SetPromptFormat(const APromptID, NewFormat: string);
    procedure Update(const APromptID: string; AnInstance: Integer;
      const AnIValue, AnEValue: string);
    property Dialog: string            read FDialog         write SetDialog;
    property DialogDisplayName: string read FDialogDisplayName write FDialogDisplayName;
    property DisplayGroup: Integer     read FDisplayGroup   write FDisplayGroup;
    property CopyOrder:    string      read FCopyOrder      write SetCopyOrder;
    property EditOrder:    string      read FEditOrder;  //  write SetEditOrder;
    property TransferOrder:string      read FTransferOrder  write FTransferOrder;
    property EventType:    Char        read FEventType;
    property EventIFN:     integer     read FEventIFN       write FEventIFN;
    property EventName:    string      read FEventName      write FEventName;
    property LogTime:      TFMDateTime read FLogTime        write FLogTime;
    property QuickOrder:   Integer     read FQuickOrder     write SetQuickOrder;
    property OrderChecks:  TStringList read FOrderChecks    write FOrderChecks;
    property OrderText:    string      read GetOrderText;
    property VarLeading:   string      read FVarLeading     write FVarLeading;
    property VarTrailing:  string      read FVarTrailing    write FVarTrailing;
    property TheList:      TList       read FResponseList   write FResponseList;
    property Cancel:       boolean     read FCancel         write FCancel;
    property OrderContainsObjects: boolean read FOrderContainsObjects write FOrderContainsObjects;
    property Reason: String read FReason write FReason;//ADDED for NSR 20071211 by KCH on 09/04/2015
    property RemComment: String read FRemComment write FRemComment;//ADDED for NSR 20071211 by KCH on 09/04/2015
  end;

  TCallOnExit = procedure;

  TfrmODBase = class(TfrmAutoSz)
    memOrder: TCaptionMemo;
    cmdAccept: TButton;
    cmdQuit: TButton;
    pnlMessage: TPanel;
    imgMessage: TImage;
    memMessage: ORExtensions.TRichEdit;
    tmrBringToFront: TTimer;
    procedure cmdQuitClick(Sender: TObject);
    procedure cmdAcceptClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure memMessageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlMessageExit(Sender: TObject);
    procedure pnlMessageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlMessageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure tmrBringToFrontTimer(Sender: TObject);
  private
    FMergeOrderChecks: boolean;
    FIsSupply:  Boolean;
    FAllowQO:      Boolean;
    FAutoAccept:   Boolean;
    FClosing:      Boolean;
    FDialogIEN:    Integer;
    FDisplayGroup: Integer;
    FFillerID:     string;
    FFromQuit:     Boolean;
    FCtrlInits:    TCtrlInits;
    FResponses:    TResponses;
    FPreserve:     TList;
    FRefNum:       Integer;
    FOrderAction:  Integer;
    FKeyVariables: string;
    FCallOnExit:   TCallOnExit;
    FTestMode:     Boolean;
    FDlgFormID:    Integer;
    FDfltCopay:    String;
    FEvtID    :    Integer;
    FEvtType  :    Char;
    FEvtName  :    string;
    //CQ 20854 - Display Supplies Only - JCS
    FEvtDlgID:     String;
    FIncludeOIPI:  boolean;
    FIsIMO:        boolean;  //imo
    FMessageClickX: integer;
    FMessageClickY: integer;
    FAcceptingOrder: boolean;
    FTriedToClose: boolean;
    function AcceptOrderChecks: Boolean;
    procedure ClearDialogControls;
    function GetKeyVariable(const Index: string): string;
    function GetEffectiveDate: TFMDateTime;
    procedure SetDisplayGroup(Value: Integer);
    procedure SetFillerID(const Value: string);
    procedure BuildOrderChecks(var aReturnList: TStringList);
    function OverrideFunction(aReturnList: TStringList; aOverrideType: String;
      aOverrideReason: String = ''; aOverrideComment: String = ''): boolean;
  protected
    FEvtForPassDischarge: Char;
    FChanging: Boolean;
    function LESValidationCheck: boolean;
    procedure InitDialog; virtual;
    procedure SetDialogIEN(Value: Integer); virtual;
    procedure Validate(var AnErrMsg: string); virtual;
    procedure updateSig; virtual;
    function ValidSave: Boolean;
    procedure ShowOrderMessage(Show: boolean); virtual;
    property MergeOrderChecks: boolean read FMergeOrderChecks write FMergeOrderChecks;
    procedure DoShow; override;
    procedure DoSetFontSize(FontSize: integer); override;
  public
    function OrderForInpatient: Boolean;
    procedure SetDefaultCoPay(AnOrderID: string);
    procedure OrderMessage(const AMessage: string);
    procedure PreserveControl(AControl: TControl);
    procedure SetupDialog(OrderAction: Integer; const ID: string); virtual;
    procedure setTabToDiet; virtual;
    procedure SetFontSize(FontSize: integer); virtual;
    procedure SetKeyVariables(const VarStr: string);
    procedure TabClose(var CanClose: Boolean);
    function IsManualEvent: Boolean;
    property AllowQuickOrder: Boolean   read FAllowQO    write FAllowQO;
    property AutoAccept: Boolean        read FAutoAccept   write FAutoAccept;
    property CallOnExit: TCallOnExit    read FCallOnExit   write FCallOnExit;
    property Changing:  Boolean         read FChanging     write FChanging;
    property Closing:   Boolean         read FClosing;
    property CtrlInits: TCtrlInits      read FCtrlInits    write FCtrlInits;
    property DialogIEN: Integer         read FDialogIEN    write SetDialogIEN;
    property DisplayGroup: Integer      read FDisplayGroup write SetDisplayGroup;
    property EffectiveDate: TFMDateTime read GetEffectiveDate;
    property FillerID: string           read FFillerID     write SetFillerID;
    property KeyVariable[const Index: string]: string read GetKeyVariable;
    property RefNum: Integer            read FRefNum       write FRefNum;
    property Responses: TResponses      read FResponses    write FResponses;
    property TestMode: Boolean          read FTestMode     write FTestMode;
    property DlgFormID: Integer         read FDlgFormID    write FDlgFormID;
    property DfltCopay: string          read FDfltCopay    write FDfltCopay;
    property EvtForPassDischarge: Char  read FEvtForPassDischarge  write FEvtForPassDischarge;
    property EvtID: integer             read FEvtID        write FEvtID;
    property EvtType: Char              read FEvtType      write FEvtType;
    property EvtName: String            read FEvtName      write FEvtName;
    //CQ 20854 - Display Supplies Only - JCS
    property EvtDlgID: string           read FEvtDlgID     write FEvtDlgID;
    property IncludeOIPI: boolean       read FIncludeOIPI  write FIncludeOIPI;
    property IsIMO:boolean              read FIsIMO        write FIsIMO;
    property IsSupply: boolean          read FIsSupply     write FIsSupply;
  end;

var
  frmODBase: TfrmODBase = nil;
  XfInToOutNow :boolean = False;       // it's used only for transfering Inpatient Meds to OutPatient Med for
                                       // immediately release (NO EVENT DELAY)
  XferOuttoInOnMeds : boolean = False; // it's used only for transfering Outpatient Meds to Inpatient Med for
                                       // immediately release (NO EVENT DELAY)
  ImmdCopyAct: boolean  = False;
  IsUDGroup: boolean = False;     // it's only used for copy inpatient med order.
  DEASig: string;                 // digital signature
  DupORIFN: string;               // it's used to identify the order number for duplicate orders in order checking
  NoFresh: boolean = False;        // EDO use only
  SaveAsCurrent: boolean = False;  // EDO use only
  CIDCOkToSave: boolean;   // CIDC only, used for consult orders.
  OrderSource: string = '';
  EventDefaultOD: integer = 0;    // If it's event default dialog?
  IsTransferAction: boolean = False;
  AcceptOK: Boolean;    // moved from TFrmODBase because it can be checked after dialog is destroyed
  AbortOrder: Boolean;  // moved from TFrmODBase because it can be checked after dialog is destroyed

procedure ClearControl(AControl: TControl);
procedure ResetControl(AControl: TControl);
Function Shouldcancelchangeorder: boolean; //rtw

implementation

{$R *.DFM}

uses fOCAccept, uODBase, rCore, rMisc, fODMessage,
  fTemplateDialog, uEventHooks, uTemplates, rConsults,fOrders,uOrders,
  fFrame, uTemplateFields, fClinicWardMeds, fODDietLT, rODDiet, VAUtils, fODDiet,
  System.Types, uOwnerWrapper, fODAuto, uWriteAccess;

var //rtw
 UAPCanceled: boolean; //rtw

const
  TX_ACCEPT = 'Accept the following order?' + CRLF + CRLF;
  TX_ACCEPT_CAP = 'Unsaved Order';
  TC_ORDERCHECKS = 'Order Checks';

Function Shouldcancelchangeorder: boolean; //rtw
begin
 result := UAPCanceled;
end; //rtw

{ Procedures shared with descendent forms }

procedure ClearControl(AControl: TControl);
{ clears a control, removes text and listbox items }
begin
  if AControl is TLabel then with TLabel(AControl) do Caption := ''
  else if AControl is TStaticText then with TStaticText(AControl) do Caption := ''
  else if AControl is TButton then with TButton(AControl) do Caption := ''
  else if AControl is TEdit then with TEdit(AControl) do Text := ''
  else if AControl is TMemo then with TMemo(AControl) do Clear
  else if AControl is TRichEdit then with TRichEdit(AControl) do Clear
  else if AControl is TORListBox then with TORListBox(AControl) do Clear
  else if AControl is TListBox then with TListBox(AControl) do Clear
  else if AControl is TORComboBox then with TORComboBox(AControl) do
  begin
    Items.Clear;
    Text := '';
  end
  else if AControl is TComboBox then with TComboBox(AControl) do
  begin
    Clear;
    Text := '';
  end
  else if AControl is TCheckListBox then with TCheckListBox(Acontrol) do  Clear;
end;

procedure ResetControl(AControl: TControl);
{ clears text, deselects items, does not remove listbox or combobox items }
var
i: integer;
begin
  if AControl is TLabel then with TLabel(AControl) do Caption := ''
  else if AControl is TStaticText then with TStaticText(AControl) do Caption := ''
  else if AControl is TButton then with TButton(AControl) do Caption := ''
  else if AControl is TEdit then with TEdit(AControl) do Text := ''
  else if AControl is TMemo then with TMemo(AControl) do Clear
  else if AControl is TRichEdit then with TRichEdit(AControl) do Clear
  else if AControl is TListBox then with TListBox(AControl) do ItemIndex := -1
  else if AControl is TORComboBox then with TORComboBox(AControl) do
  begin
    Text := '';
    ItemIndex := -1;
  end
  else if AControl is TComboBox then with TComboBox(AControl) do
  begin
    Text := '';
    ItemIndex := -1;
  end
  else if AControl is TCheckListBox then with TCheckListBox(AControl) do
    begin
       for i := 0 to count -1 do
         begin
           checked[i] := false;
         end;
    end;


end;

{ TCtrlInit methods }

constructor TCtrlInit.Create;
begin
  List := TStringList.Create;
end;

destructor TCtrlInit.Destroy;
begin
  List.Free;
  inherited Destroy;
end;

{ TCtrlInits methods }

constructor TCtrlInits.Create;
{ create lists to store initial value for dialog and selected orderable item }
begin
  FDfltList := TList.Create;
  FOIList   := TList.Create;
end;

destructor TCtrlInits.Destroy;
{ free the objects used to store initialization information }
var
  i: Integer;
begin
  { free the objects in the lists first }
  with FDfltList do for i := 0 to Count - 1 do TCtrlInit(Items[i]).Free;
  FDfltList.Free;
  ClearOI;
  FOIList.Free;
  inherited Destroy;
end;

procedure TCtrlInits.ClearOI;
{ clears the records in FOIList, but not FDfltList }
var
  i: Integer;
begin
  with FOIList do for i := 0 to Count - 1 do TCtrlInit(Items[i]).Free;
  FOIList.Clear;
end;

procedure TCtrlInits.ExtractInits(Src: TStrings; Dest: TList);
{ load a list with TCtrlInit records (source strings are those passed from server }
var
  i: Integer;
  ACtrlInit: TCtrlInit;
begin
  i := 0;
  while i < Src.Count do
  begin
    if CharAt(Src[i], 1) = '~' then
    begin
      ACtrlInit := TCtrlInit.Create;
      with ACtrlInit do
      begin
        Name := Copy(Src[i], 2, Length(Src[i]));
        Inc(i);
        while (i < Src.Count) and (CharAt(Src[i], 1) <> '~') do
        begin
          if CharAt(Src[i], 1) = 'i' then List.Add(Copy(Src[i], 2, 255));
          if CharAt(Src[i], 1) = 't' then List.Add(Copy(Src[i], 2, 255));
          if CharAt(Src[i], 1) = 'd' then
          begin
            Text := Piece(Src[i], U, 2);
            ListID := Copy(Piece(Src[i], U, 1), 2, 255);
          end;
          Inc(i);
        end; {while i & CharAt...}
        Dest.Add(ACtrlInit);
      end; {with ACtrlDflt}
    end; {if CharAt}
  end; {while i}
end;


procedure TCtrlInits.LoadDefaults(Src: TStrings);
{ loads control initialization information for the dialog }
var
  i: integer;

begin
  with FDfltList do
    for i := 0 to Count - 1 do
  	  if assigned(Items[i]) then
	      TObject(Items[i]).Free;
  FDfltList.Clear;
  ExtractInits(Src, FDfltList);
end;

procedure TCtrlInits.LoadOrderItem(Src: TStrings);
{ loads control initialization information for the orderable item }
begin
  ClearOI;
  ExtractInits(Src, FOIList);
end;

function TCtrlInits.FindInitByName(const AName: string): TCtrlInit;
{ look first in FOIList, then in FDfltList for initial values identified by name (~section) }
var
  i: Integer;
begin
  Result := nil;
  with FOIList do
    for i := 0 to Count - 1 do if TCtrlInit(Items[i]).Name = AName then
    begin
      Result := TCtrlInit(Items[i]);
      break;
    end;
  if Result = nil then with FDfltList do
    for i := 0 to Count - 1 do if TCtrlInit(Items[i]).Name = AName then
    begin
      Result := TCtrlInit(Items[i]);
      break;
    end;
end;

procedure TCtrlInits.SetControl(AControl: TControl; const ASection: string);
{ initializes a control to the information in a section (~section from server) }
var
  CtrlInit: TCtrlInit;
  i: integer;
begin
  ClearControl(AControl);
  CtrlInit := FindInitByName(ASection);
  if CtrlInit = nil then Exit;
  if AControl is TLabel then with TLabel(AControl) do Caption := CtrlInit.Text
  else if AControl is TStaticText then with TStaticText(AControl) do Caption := CtrlInit.Text
  else if AControl is TButton then with TButton(AControl) do Caption := CtrlInit.Text
  else if AControl is TEdit then with TEdit(AControl) do Text := CtrlInit.Text
  else if AControl is TMemo then FastAssign(CtrlInit.List, TMemo(AControl).Lines)
  else if AControl is TRichEdit then QuickCopy(CtrlInit.List, TRichEdit(AControl))
  else if AControl is TORListBox then FastAssign(CtrlInit.List, TORListBox(AControl).Items)
  else if AControl is TListBox then FastAssign(CtrlInit.List, TListBox(AControl).Items)
  else if AControl is TComboBox then with TComboBox(AControl) do
  begin
    FastAssign(CtrlInit.List, TComboBox(AControl).Items);
    Text := CtrlInit.Text;
  end
  else if AControl is TORComboBox then with TORComboBox(AControl) do
  begin
    FastAssign(CtrlInit.List, TORComboBox(AControl).Items);
    if LongList then InitLongList(Text) else Text := CtrlInit.Text;
    SelectByID(CtrlInit.ListID);
  end
  else if AControl is TCheckListBox then with TCheckListBox(AControl) do
       begin
         IntegralHeight := True; // RTC 1299114
         for i := 0 to CtrlInit.List.Count - 1 do
           begin
             TCheckListBox(AControl).Items.Add(Piece(CtrlInit.List[i], U, 2));
           end;
//         FastAssign(CtrlInit.List, TCheckListBox(AControl).Items);
       end;
  { need to add SelectByID for combobox & listbox }
end;

procedure TCtrlInits.SetListOnly(AControl: TControl; const ASection: string);
{ assigns list portion to a control from a section (used to set ShortList for meds) }
var
  CtrlInit: TCtrlInit;
begin
  CtrlInit := FindInitByName(ASection);
  if CtrlInit = nil then Exit;
  if      AControl is TMemo       then FastAssign(CtrlInit.List, TMemo(AControl).Lines)
  else if AControl is TORListBox  then FastAssign(CtrlInit.List, TORListBox(AControl).Items)
  else if AControl is TListBox    then FastAssign(CtrlInit.List, TListBox(AControl).Items)
  else if AControl is TComboBox   then FastAssign(CtrlInit.List, TComboBox(AControl).Items)
  else if AControl is TORComboBox then FastAssign(CtrlInit.List, TORComboBox(AControl).Items);
end;

procedure TCtrlInits.SetPopupMenu(AMenu: TPopupMenu; AClickEvent: TNotifyEvent; const ASection: string);
{ populates a popup menu with items in a list, leaves the maximum text width in Tag }
var
  i, MaxWidth: Integer;
  CtrlInit: TCtrlInit;
  AMenuItem: TMenuItem;
begin
  CtrlInit := FindInitByName(ASection);
  // clear the current menu entries
  for i := AMenu.Items.Count - 1 downto 0 do
  begin
    AMenuItem := AMenu.Items[i];
    if AMenuItem <> nil then
    begin
      AMenu.Items.Delete(i);
      AMenuItem.Free;
    end;
  end;
  MaxWidth := 0;
  for i := 0 to CtrlInit.List.Count - 1 do
  begin
    AMenuItem := TMenuItem.Create(Application);
    AMenuItem.Caption := CtrlInit.List[i];
    AMenuItem.OnClick := AClickEvent;
    AMenu.Items.Add(AMenuItem);
    MaxWidth := HigherOf(MaxWidth, Application.MainForm.Canvas.TextWidth(CtrlInit.List[i]));
  end;
  AMenu.Tag := MaxWidth;
end;

function TCtrlInits.DefaultText(const ASection: string): string;
var
  CtrlInit: TCtrlInit;
begin
  Result := '';
  CtrlInit := FindInitByName(ASection);
  if CtrlInit <> nil then Result := CtrlInit.ListID;
end;

function TCtrlInits.TextOf(const ASection: string): string;
var
  CtrlInit: TCtrlInit;
begin
  Result := '';
  CtrlInit := FindInitByName(ASection);
  if CtrlInit <> nil then Result := CtrlInit.List.Text;
end;

{ TResponses methods }

function SortPromptsBySequence(Item1, Item2: Pointer): Integer;
{ compare function used to sort formatting info by sequence - used by TResponses.SetDialog}
var
  Prompt1, Prompt2: TPrompt;
begin
  Prompt1 := TPrompt(Item1);
  Prompt2 := TPrompt(Item2);
  if Prompt1.Sequence < Prompt2.Sequence then Result := -1
  else if Prompt1.Sequence > Prompt2.Sequence then Result := 1
  else Result := 0;
end;

constructor TResponses.Create;
begin
  FResponseList := TList.Create;
  FPrompts := TList.Create;
  FOrderChecks := TStringList.Create;
  FEventType := #0;
  FParentEvent := TParentEvent.Create(0);
  FLogTime := 0;
  FReason := '';
end;

destructor TResponses.Destroy;
{ frees all response objects before freeing list }
var
  i: Integer;
begin
  Clear;
  FOrderChecks.Free;
  FResponseList.Free;
  with FPrompts do for i := 0 to Count - 1 do TPrompt(Items[i]).Free;
  FPrompts.Free;
  inherited Destroy;
end;

procedure TResponses.Clear;
{ clears all information in the response multiple }
var
  i: Integer;
begin
  FVarLeading  := '';
  FVarTrailing := '';
  FQuickOrder  := 0;
  //FCopyOrder  := '';  // don't clear FCopyOrder either?
  // don't clear FEditOrder or it will cause a new order to be created instead of an edit
  with FResponseList do for i := 0 to Count - 1 do TResponse(Items[i]).Free;
  FResponseList.Clear;
  FOrderChecks.Clear;
end;

procedure TResponses.Clear(const APromptID: string; SaveInstance: Integer = 0);
var
  AResponse: TResponse;
  i: Integer;
begin
  with FResponseList do
    for i := Count - 1 downto SaveInstance do
    begin
      AResponse := TResponse(Items[i]);
      if AResponse.PromptID = APromptID then
      begin
        AResponse.Free;
        FResponseList.Delete(i);
      end; {if AResponse}
    end; {for}
end;

procedure TResponses.SetDialog(Value: string);
{ loads formatting information for a dialog }
var
  i: Integer;
begin
  with FPrompts do for i := 0 to Count - 1 do TPrompt(Items[i]).Free;
  FPrompts.Clear;
  FDialog := Value;
  LoadDialogDefinition(FPrompts, FDialog);
  FPrompts.Sort(SortPromptsBySequence);
end;

procedure TResponses.SetCopyOrder(const AnID: string);
{ sets responses to the values for an order that is created by copying }
var
  HasObjects: boolean;
begin
  if AnID = '' then
  begin
    FCopyOrder := AnID;
    Exit;
  end;
  Clear;
  LoadResponses(FResponseList, AnID, HasObjects);                      // Example AnID=C123456;1-3604
  FCopyOrder := Copy(Piece(AnID, '-', 1), 2, Length(AnID));
  FOrderContainsObjects := HasObjects;
end;

procedure TResponses.SetEditOrder(const AnID: string);
{ sets responses to the values for an order that is about to be edited }
var
  HasObjects: boolean;
begin
  Clear;
  LoadResponses(FResponseList, AnID, HasObjects);                      // Example AnID=X123456;1
  FEditOrder := Copy(Piece(AnID, '-', 1), 2, Length(AnID));
  FOrderContainsObjects := HasObjects;
end;

procedure TResponses.SetQuickOrder(AnIEN: Integer);
{ sets responses to a quick order value - this is used by the QuickOrder property}
var
  HasObjects: boolean;
begin
  Clear;
  LoadResponses(FResponseList, IntToStr(AnIEN), HasObjects);           // Example AnIEN=134
  FQuickOrder := AnIEN;
  FOrderContainsObjects := HasObjects;
end;

procedure TResponses.SetQuickOrderByID(const AnID: string);
{ sets responses to a quick order value }
var
  HasObjects: boolean;
begin
  Clear;
  LoadResponses(FResponseList, AnID, HasObjects);                      // Example AnID=134-3645
  FQuickOrder := StrToIntDef(Piece(AnID, '-', 1), 0);      // 2nd '-' piece is $H seconds
  FOrderContainsObjects := HasObjects;
end;

procedure TResponses.BuildOCItems(AList: TStringList; var AStartDtTm: string;
  const AFillerID: string);
var
  i, TheInstance: Integer;
  OrderableIEN, PkgPart: string;
begin
  if EditOrder <> '' then DupORIFN := EditOrder;
  if CopyOrder <> '' then DupORIFN := CopyOrder;
  //if {(CopyOrder <> '') or} (EditOrder <> '') then Exit;  // only check new orders
  with FResponseList do
    for i := 0 to FResponseList.Count - 1 do
      begin
        with TResponse(Items[i]) do
          begin
            if (PromptID = 'ORDERABLE') or (PromptID = 'ADDITIVE') then
              begin
                OrderableIEN := IValue;
                TheInstance := Instance;
                PkgPart := '';
                if AFillerID = 'LR' then PkgPart := '^LR^' + IValueFor('SPECIMEN', TheInstance);
                if (AFillerID = 'PSI') or (AFillerID = 'PSO') or (AFillerID = 'PSH') or (AFillerID = 'PSNV')
                  then PkgPart := U + AFillerID + U + IValueFor('DRUG', TheInstance);
                // was -- then PkgPart := '^PS^' + IValueFor('DRUG', TheInstance);
                if AFillerID = 'PSIV' then
                  begin
                    if PromptID = 'ORDERABLE' then PkgPart := '^PSIV^B;' + IValueFor('VOLUME', TheInstance);
                    if PromptID = 'ADDITIVE'  then PkgPart := '^PSIV^A';
                  end;
                AList.Add(OrderableIEN + PkgPart);
              end;
            //AGP IV CHANGES
            if (AFillerID = 'PSI') or (AFillerID = 'PSO') or (AFillerID = 'PSH') or (AFillerID = 'PSIV') or (AFillerID = 'PSNV') then
              begin
                IF PromptID = 'COMMENT' then continue;
                Alist.Add(AFillerID + U + PromptID + U + InttoStr(Instance) + U + IValueFor(PromptID, Instance) + U + EValueFor(PromptID, Instance));
              end;
      end;
  end;
  AStartDtTm := IValueFor('START', 1);
end;

function TResponses.EValueFor(const APromptID: string; AnInstance: Integer): string;
var
  i: Integer;
begin
  Result := '';
  with FResponseList do for i := 0 to Count - 1 do with TResponse(Items[i]) do
    if (PromptID = APromptID) and (Instance = AnInstance) then
    begin
      Result := EValue;
      break;
    end;
end;

function TResponses.IValueFor(const APromptID: string; AnInstance: Integer): string;
var
  i: Integer;
begin
  Result := '';
  with FResponseList do for i := 0 to Count - 1 do with TResponse(Items[i]) do
    if (PromptID = APromptID) and (Instance = AnInstance) then
    begin
      Result := IValue;
      break;
    end;
end;

function TResponses.PromptExists(const APromptID: string): boolean;
var
  i: Integer;
begin
  Result := False;
  with FPrompts do for i := 0 to Count - 1 do with TPrompt(Items[i]) do
    if (ID = APromptID) then Result :=  True;
end;

function TResponses.FindResponseByName(const APromptID: string; AnInstance: Integer): TResponse;
var
  i: Integer;
begin
  Result := nil;
  with FResponseList do for i := 0 to Count - 1 do with TResponse(Items[i]) do
    if (PromptID = APromptID) and (Instance = AnInstance) then
    begin
      Result := TResponse(Items[i]);
      break;
    end;
end;

function TResponses.IENForPrompt(const APromptID: string): Integer;
var
  i: Integer;
begin
  Result := 0;
  with FPrompts do for i := 0 to Count - 1 do with TPrompt(Items[i]) do
    if (ID = APromptID) then
    begin
      Result := IEN;
      break;
    end;
end;

function TResponses.InstanceCount(const APromptID: string): Integer;
var
  i: Integer;
begin
  Result := 0;
  with FResponseList do for i := 0 to Count - 1 do with TResponse(Items[i]) do
    if (PromptID = APromptID) then Inc(Result);
end;

// DRM - I10010348FY16/525455 - 2017/6/20
function TResponses.IValueExists(const APromptID, AnIValue: string): boolean; // added by DRM for I10010348FY16 on 2017/6/22
var
  ii: integer;
begin
  Result := False;
  with FResponseList do for ii := 0 to Count - 1 do with TResponse(Items[ii]) do
    if (PromptID = APromptID) and (IValue = AnIValue) then
    begin
      Result := True;
      Break;
    end;
end;
// DRM ---

function TResponses.TotalRows: Integer;
var
  TotalRows: Integer;
begin
  TotalRows := HigherOf(InstanceCount('INSTR'), InstanceCount('ROUTE'));
  TotalRows := HigherOf(TotalRows, InstanceCount('SCHEDULE'));
  TotalRows := HigherOf(TotalRows, InstanceCount('DAYS'));
  TotalRows := HigherOf(TotalRows, (InstanceCount('CONJ')+1));
  Result := TotalRows;
end;

function TResponses.NextInstance(const APromptID: string; LastInstance: Integer): Integer;
var
  i: Integer;
begin
  Result := 0;
  with FResponseList do for i := 0 to Count - 1 do with TResponse(Items[i]) do
    if (PromptID = APromptID) and (Instance > LastInstance) and
      ((Result = 0) or ((Result > 0) and (Instance < Result))) then Result := Instance;
end;

function TResponses.FindResponseByIEN(APromptIEN, AnInstance: Integer): TResponse;
var
  i: Integer;
begin
  Result := nil;
  with FResponseList do for i := 0 to Count - 1 do with TResponse(Items[i]) do
    if (PromptIEN = APromptIEN) and (Instance = AnInstance) then
    begin
      Result := TResponse(Items[i]);
      break;
    end;
end;

procedure TResponses.FormatResponse(var FormattedText: string; var ExcludeText: Boolean;
  APrompt: TPrompt; const x: string; AnInstance: Integer);
var
  AValue: string;
  PromptIEN: Integer;
  Related: TResponse;
begin
  FormattedText := '';
  ExcludeText := True;
  with APrompt do
  begin
    if FmtCode = '@' then Exit;                // skip this response
    if CharAt(FmtCode, 1) = '@' then           // exclude if related response exists
    begin
      PromptIEN := StrToIntDef(Copy(FmtCode, 2, Length(FmtCode)), 0);
      if (FindResponseByIEN(PromptIEN, AnInstance) <> nil) then Exit;
    end;
    if CharAt(FmtCode, 1) = '*' then           // include if related response exists
    begin
      PromptIEN := StrToIntDef(Copy(FmtCode, 2, Length(FmtCode)), 0);
      if FindResponseByIEN(PromptIEN, AnInstance) = nil then Exit;
    end;
    if CharAt(FmtCode, 1) = '#' then           // include if related response = value
    begin
      AValue := Copy(FmtCode, Pos('=', FmtCode) + 1, Length(FmtCode));
      PromptIEN := StrToIntDef(Copy(Piece(FmtCode, '=', 1), 2, Length(FmtCode)), 0);
      Related := FindResponseByIEN(PromptIEN, AnInstance);
      if Related = nil then Exit;
      if not (Related.EValue = AValue) then Exit;
    end;
    if CharAt(FmtCode, 1) = '=' then           // exclude if related response has same text
    begin
      PromptIEN := StrToIntDef(Copy(FmtCode, 2, Length(FmtCode)), 0);
      Related := FindResponseByIEN(PromptIEN, AnInstance);
      if (Related <> nil) and ((Pos(Related.EValue, x) > 0) or (Pos(x, Related.EValue) > 0)) then Exit;
    end;
    ExcludeText := False;
    if (Length(x) = 0) or (CompareText(x, Omit) = 0) then Exit;
    FormattedText := x;
    if IsChild and (Length(Leading) > 0) and (CharAt(Leading, 1) <> '@')
      then FormattedText := Leading + ' ' + FormattedText;
    if IsChild and (Length(Trailing) > 0) and (CharAt(Trailing, 1) <> '@')
      then FormattedText := FormattedText + ' ' + Trailing;
  end; {with APrompt}
end;

function TResponses.FindPromptByIEN(AnIEN: Integer): TPrompt;
var
  i: Integer;
begin
  Result := nil;
  with FPrompts do for i := 0 to Count - 1 do with TPrompt(Items[i]) do
    if IEN = AnIEN then
    begin
      Result := TPrompt(Items[i]);
      break;
    end;
end;

procedure TResponses.AppendChildren(var ParentText: string; ChildPrompts: string; AnInstance: Integer);
var
  x, Segment: string;
  Boundary, ChildIEN: Integer;
  ExcludeText: Boolean;
  AResponse: TResponse;
  APrompt: TPrompt;
begin
  while Length(ChildPrompts) > 0 do
  begin
    Boundary := Pos('~', ChildPrompts);
    if Boundary = 0 then Boundary := Length(ChildPrompts) + 1;
    Segment := Copy(ChildPrompts, 1, Boundary - 1);
    Delete(ChildPrompts, 1, Boundary);
    ChildIEN := StrToIntDef(Segment, 0);
    APrompt := FindPromptByIEN(ChildIEN);
    if APrompt <> nil then
    begin
      AResponse := FindResponseByIEN(APrompt.IEN, AnInstance);
      if AResponse <> nil then
      begin
        FormatResponse(x, ExcludeText, APrompt, AResponse.EValue, AnInstance);
        //x := FormatResponse(APrompt, AResponse.EValue, AnInstance);
        if not ExcludeText then
        begin
          if (Length(ParentText) > 0) and (Length(x) > 0) then ParentText := ParentText + ' ';
          ParentText := ParentText + x;
        end; {if not ExcludeText}
      end; {if AResponse}
    end; {if APrompt}
  end; {while Length}
end; {AppendChildren}

function TResponses.GetOrderText: string;
{ loop thru the response objects and build the order text }
var
  i, AnInstance, NumInstance: Integer;
  x, Segment: string;
  ExcludeText, StartNewline: Boolean;
  AResponse: TResponse;
  APrompt: TPrompt;
begin
  Result := '';
  with FPrompts do for i := 0 to Count - 1 do
  begin
    APrompt := TPrompt(Items[i]);
    if APrompt.Sequence = 0 then Continue;   // skip if prompt not in formatting sequence
    NumInstance := 0;
    Segment := '';
    AnInstance := NextInstance(APrompt.ID, 0);
    while AnInstance > 0 do
    begin
      Inc(NumInstance);
      AResponse := FindResponseByName(APrompt.ID, AnInstance);
      FormatResponse(x, ExcludeText, APrompt, AResponse.EValue, AnInstance);
      //x := FormatResponse(APrompt, AResponse.EValue, AnInstance);
      if not ExcludeText then
      begin
        if Length(APrompt.Children) > 0 then AppendChildren(x, APrompt.Children, AnInstance);
        if Length(x) > 0 then
        begin
          // should the newline property be checked for children, too?
          if APrompt.NewLine and (Length(Result) > 0) then x := CRLF + x;
          if NumInstance > 1     then Segment := Segment + ',';
          if Length(Segment) > 0 then Segment := Segment + ' ';
          Segment := Segment + x;
        end; {if Length(x)}
      end; {if not ExcudeText}
      AnInstance := NextInstance(APrompt.ID, AnInstance);
    end; {while AnInstance}
    if NumInstance > 0 then with APrompt do
    begin
      if Length(Segment) > 0 then
      begin
        if Copy(Segment, 1, 2) = CRLF then
        begin
          Segment := Copy(Segment, 3, Length(Segment));
          StartNewline := True;
        end
        else StartNewline := False;
        if (Length(Leading) > 0) then
        begin
          if (CharAt(Leading, 1) <> '@')
            then Segment := Leading + ' ' + Segment
            else Segment := FVarLeading + ' ' + Segment;
        end; {if Length(Leading)}
        if StartNewline then Segment := CRLF + Segment;
        if (Length(Trailing) > 0) then
        begin
          if (CharAt(Trailing, 1) <> '@')
            then Segment := Segment + ' ' + Trailing
            else Segment := Segment + ' ' + FVarTrailing;
        end; {if Length(Trailing)}
      end; {if Length(Segment)}
      if Length(Result) > 0 then Result := Result + ' ';
      Result := Result + Segment;
    end; {with APrompt}
  end; {with FPrompts}
end; {GetOrderText}

procedure TResponses.Update(const APromptID: string; AnInstance: Integer;
  const AnIValue, AnEValue: string);
{ for a given Prompt,Instance update or create the associated response object }
var
  AResponse: TResponse;
  ien: integer;

begin
  AResponse := FindResponseByName(APromptID, AnInstance);
  if AResponse = nil then
  begin
    ien := IENForPrompt(APromptID);
    if ien > 0 then
    begin
      AResponse := TResponse.Create;
      AResponse.PromptID := APromptID;
      AResponse.PromptIEN := ien;
      AResponse.Instance := AnInstance;
      FResponseList.Add(AResponse);
    end;
  end;
  if assigned(AResponse) then
  begin
    AResponse.IValue := AnIValue;
    AResponse.EValue := AnEValue;
  end;
end;

function TResponses.OrderCRC: string;
const
  CRC_WIDTH = 8;
var
  i: Integer;
  x: string;
  tmplst: TStringList;
begin
  tmplst := TStringList.Create;
  try
    with FResponseList do for i := 0 to Count - 1 do with TResponse(Items[i]) do
    begin
      if IValue = TX_WPTYPE then x := EValue else x := IValue;
      tmplst.Add(IntToStr(PromptIEN) + U + IntToStr(Instance) + U + x);
    end;
    Result := IntToHex(CRCForStrings(tmplst), CRC_WIDTH);
  finally
    tmplst.Free;
  end;
end;

procedure TResponses.Remove(const APromptID: string; AnInstance: Integer);
var
  AResponse: TResponse;
begin
  AResponse := FindResponseByName(APromptID, AnInstance);
  if AResponse <> nil then
  begin
    FResponseList.Remove(AResponse);
    AResponse.Free;
  end;
end;

procedure TResponses.SaveQuickOrder(var ANewIEN: Integer; const ADisplayName: string);
begin
  if FDisplayGroup = ClinDisp then  //Clin. Meds share same quick order definition with Inpt. Meds
    PutQuickOrder(ANewIEN, OrderCRC, ADisplayName, InptDisp, FResponseList)
  else
    PutQuickOrder(ANewIEN, OrderCRC, ADisplayName, FDisplayGroup, FResponseList)
end;

procedure TResponses.SaveOrder(var AnOrder: TOrder; DlgIEN: Integer; IsIMOOrder: boolean);
var
  ConstructOrder: TConstructOrder;
  i,j: integer;
  QOUDGroup: boolean;
  NewPtEvtPtr: Integer;  // ptr to #100.2
  APtEvtPtr: string;
begin
  //IMOLoc := 0;
  NewPtEvtPtr := 0;
  QOUDGroup := False;
  if FQuickOrder > 0 then
  begin
   DlgIEN := FQuickOrder;
   QOUDGroup := CheckQOGroup( IntToStr(FQuickOrder) );
  end;
  AnOrder.EditOf := FEditOrder;  // null if new order, otherwise ORIFN of original order
  with ConstructOrder do
  begin
    if XfInToOutNow then
      DialogName := FDialog + '^O'
    else DialogName := FDialog;
    LeadText     := FVarLeading;
    TrailText    := FVarTrailing;
    DGroup       := FDisplayGroup;
    OrderItem    := DlgIEN;
    DelayEvent   := FEventType;
    Specialty    := FSpecialty;
    Effective    := FEffective;
    LogTime      := FLogTime;
    OCList       := FOrderChecks;
    DigSig       := DEASig;
    IsIMODialog  := IsIMOOrder;       //IMO

    if (Patient.Inpatient = False) and (IsValidIMOLoc(encounter.Location,Patient.DFN)=true) and
       (((pos('OR GXTEXT WORD PROCESSING ORDER',ConstructOrder.DialogName)>0) and (ConstructOrder.DGroup = NurDisp)) or
       ((ConstructOrder.DialogName = 'OR GXMISC GENERAL') and (ConstructOrder.DGroup = NurDisp)) or
       ((ConstructOrder.DialogName = 'OR GXTEXT TEXT ONLY ORDER') and (ConstructOrder.DGroup = NurDisp))) and //AGP Change CQ #10757
      ((FEditOrder = '') and (Self.FEventName = '') and (Self.FCopyOrder = '')) then
         begin
            ConstructOrder.IsIMODialog := True;
            ConstructOrder.DGroup := ClinOrdDisp;
          end;
    IsEventDefaultOR := EventDefaultOD;
    if IsUDGroup or QOUDGroup then
    begin
      for i := 0 to FResponseList.Count - 1 do
       if UpperCase(TResponse(FResponseList.Items[i]).PromptID) = 'PICKUP' then
       begin
          FResponseList.Delete(i);
          Break;
       end;
    end;

    if SaveAsCurrent then
      ConstructOrder.DelayEvent := #0;

    ResponseList := FResponseList;
    if (FEventIFN>0) and (EventExist(Patient.DFN, FEventIFN)>0) then
    begin
      APtEvtPtr   := IntToStr(EventExist(Patient.DFN, FEventIFN));
      PTEventPtr  := APtEvtPtr;
      //PutNewOrder(AnOrder, ConstructOrder, OrderSource, IMOLoc);
      PutNewOrder(AnOrder, ConstructOrder, OrderSource);//Modified for NSR 20071211 by KCH on 11/23/2015
      if not SaveAsCurrent then
      begin
        AnOrder.EventPtr  := PTEventPtr;
        AnOrder.EventName := 'Delayed ' + MixedCase(Piece(EventInfo(APtEvtPtr),'^',4));
      end;
    end
    else
    begin
      //PutNewOrder(AnOrder, ConstructOrder, OrderSource, IMOLoc);
      PutNewOrder(AnOrder, ConstructOrder, OrderSource);//Modified for NSR 20071211 by KCH on 11/23/2015
      if not SaveAsCurrent then
      begin
        if (FEventIFN > 0) and (FParentEvent.ParentIFN > 0) then
        begin
          {For a child event, create a parent event in 100.2 first}
          SaveEvtForOrder(Patient.DFN, FParentEvent.ParentIFN, AnOrder.ID);
          NewPtEvtPtr := EventExist(Patient.DFN, FParentEvent.ParentIFN);
          AnOrder.EventPtr := IntToStr(NewPtEvtPtr);
          AnOrder.EventName := 'Delayed ' + MixedCase(Piece(EventInfo(IntToStr(NewPtEvtPtr)),'^',4));
          {Then create the child event in 100.2}
          SaveEvtForOrder(Patient.DFN, FEventIFN, '');
          NewPtEvtPtr := EventExist(Patient.DFN, FEventIFN);
        end
        else if (FEventIFN > 0) and (FParentEvent.ParentIFN = 0) then
        begin
          SaveEvtForOrder(Patient.DFN, FEventIFN, AnOrder.ID);
          NewPtEvtPtr := EventExist(Patient.DFN, FEventIFN);
          AnOrder.EventPtr := IntToStr(NewPtEvtPtr);
          AnOrder.EventName := 'Delayed ' + MixedCase(Piece(EventInfo(IntToStr(NewPtEvtPtr)),'^',4));
        end;
        if FEventIFN > 0 then
        begin
          for j := 1 to frmOrders.lstSheets.Items.Count - 1 do
          begin
            if FEventIFN = StrToInt( Piece(Piece(frmOrders.lstSheets.Items[j],'^',1),';',1) ) then
            begin
              frmOrders.lstSheets.Items[j] := IntToStr( NewPtEvtPtr) + '^' + Piece(frmOrders.lstSheets.Items[j],'^',2);
              frmOrders.lstSheets.ItemIndex := j;
            end;
          end;
        end;
      end;
    end;
    DEASig := ''; //PKI
  end;
  AnOrder.EditOf := FEditOrder;
{Begin BillingAware}
  if  rpcGetBAMasterSwStatus then
  begin
     UBAGlobals.BAOrderID := '';
     UBAGlobals.BAOrderID := AnOrder.ID;
  end;
{Begin BillingAware}
end;

procedure TResponses.SetControl(AControl: TControl; const APromptID: string; AnInstance: Integer);
{ sets the value of a control, uses ID string & instance to find the right response entry }
var
  i: Integer;
  AResponse: TResponse;
  IEN: integer;
  HasObjects: boolean;

  procedure AssignBPText(List: TStrings; const Value: string);
  var
    tmp, cptn, DocInfo: string;
    LType: TTemplateLinkType;

  begin
    DocInfo := '';
    LType := DisplayGroupToLinkType(DisplayGroup);
    cptn := 'Reason for Request: ' + EValueFor('ORDERABLE', 1);
    tmp := Value;
    case LType of
      ltConsult:   IEN := StrToIntDef(GetServiceIEN(IValueFor('ORDERABLE', 1)),0);
      ltProcedure: IEN := StrToIntDef(GetProcedureIEN(IValueFor('ORDERABLE', 1)),0);
      else         IEN := 0;
    end;
    ExpandOrderObjects(tmp, HasObjects);
    FOrderContainsObjects := FOrderContainsObjects or HasObjects;

    if AbortOrder then
    begin
      SetTemplateDialogCanceled(FALSE);
      Exit;
    end;

    if IEN <> 0 then
      begin
        // template will execute on copy order if commented out  (tried to eliminate for CSV v22, RV)
        //
        //if (Length(tmp) > 0) and (not HasTemplateField(tmp)) then
        //  CheckBoilerplate4Fields(tmp, cptn)
        //else

        // CQ #11669 - changing an existing order shouldn't restart template - JM
          if assigned(frmODBase) and (frmODBase.FOrderAction = ORDER_EDIT) then
            CheckBoilerplate4Fields(tmp, cptn)
          else
            ExecuteTemplateOrBoilerPlate(tmp, IEN, LType, nil, cptn, DocInfo);
      end
    else
      CheckBoilerplate4Fields(tmp, cptn);
    List.Text := tmp;
    if WasTemplateDialogCanceled then AbortOrder := True;

  end;

begin
  AResponse := FindResponseByName(APromptID, AnInstance);
  if AResponse = nil then Exit;
  if AControl is TLabel then with TLabel(AControl) do Caption := AResponse.EValue
  else if AControl is TStaticText then with TStaticText(AControl) do Caption := AResponse.EValue
  else if AControl is TButton then with TButton(AControl) do Caption := AResponse.EValue
  else if AControl is TEdit then with TEdit(AControl) do Text := AResponse.EValue
  else if AControl is TMaskEdit then with TMaskEdit(AControl) do Text := AResponse.EValue
  else if AControl is TCheckBox then with TCheckBox(AControl) do
    Checked := (StrToIntDef(AResponse.IValue,0) > 0) or
               (UpperCase(AResponse.IValue) = 'Y')
  else if AControl is TMemo then with TMemo(AControl) do AssignBPText(Lines, AResponse.EValue)
  else if AControl is TRichEdit then with TRichEdit(AControl) do AssignBPText(Lines, AResponse.EValue)
  else if AControl is TORListBox then with TORListBox(AControl) do
  begin
    for i := 0 to Items.Count - 1 do
      if Piece(Items[i], U, 1) = AResponse.IValue then ItemIndex := i;
  end
  else if AControl is TListBox then with TListBox(AControl) do
  begin
    for i := 0 to Items.Count - 1 do
      if Items[i] = AResponse.EValue then ItemIndex := i;
  end
  else if AControl is TComboBox then with TComboBox(AControl) do
  begin
    for i := 0 to Items.Count - 1 do
      if Items[i] = AResponse.EValue then ItemIndex := i;
    Text := AResponse.EValue;
  end
  else if AControl is TORComboBox then with TORComboBox(AControl) do
  begin
    if LongList then InitLongList(AResponse.EValue);
    SelectByID(AResponse.IValue);
    if (not LongList) and (ItemIndex < 0) then Text := AResponse.EValue;
  end;
end;

procedure TResponses.SetEventDelay(AnEvent: TOrderDelayEvent);
begin
  with AnEvent do if CharInSet(EventType, ['A','D','T','M','O']) then
  begin
    FEventIFN  := EventIFN;
    FEventName := EventName;
    FEventType := EventType;
    FSpecialty := Specialty;
    FEffective := Effective;
    FViewName := 'Delayed ' + MixedCase(EventName);
    FParentEvent := TParentEvent(AnEvent.TheParent);
  end;
end;

procedure TResponses.SetPromptFormat(const APromptID, NewFormat: string);
var
  i: Integer;
begin
  with FPrompts do for i := 0 to Count - 1 do with TPrompt(Items[i]) do
    if (ID = APromptID) then FmtCode := NewFormat;
end;

{ Private calls }
procedure TfrmODBase.BuildOrderChecks(var aReturnList: TStringList);
var
  StartDtTm, x: string;
  OIList, OCTemp: TStringList;
begin
  if not assigned(aReturnList) then
    Exit;
  OCTemp := nil;
  try
    if FMergeOrderChecks and (Responses.OrderChecks.count > 0) then
    begin
      OCTemp := TStringList.Create;
      OCTemp.Assign(Responses.OrderChecks);
    end;
    Responses.OrderChecks.Clear;
    OIList := TStringList.Create;
    try
      StatusText('Order Checking...');
      Responses.BuildOCItems(OIList, StartDtTm, FillerID);
      x := Responses.IValueFor('REFILLS', 1) + U + Responses.IValueFor('PICKUP',
        1) + U + Responses.IValueFor('SUPPLY', 1) + U +
        Responses.IValueFor('QTY', 1);
      OrderChecksOnAccept(Responses.OrderChecks, FillerID, StartDtTm, OIList,
        DupORIFN, '0', x, Self is TfrmODAuto);
      if FMergeOrderChecks and assigned(OCTemp) then
        Responses.OrderChecks.AddStrings(OCTemp);
      aReturnList.Assign(Responses.OrderChecks);
    finally
      OIList.Free;
    end;
  finally
    FreeAndNil(OCTemp);
  end;
end;

function TfrmODBase.OverrideFunction(aReturnList: TStringList;
  aOverrideType: String; aOverrideReason: String = '';
  aOverrideComment: String = ''): boolean;
var
  OrdableItemIEN: String;
begin
  result := False;

  if CompareText(aOverrideType, 'SAVE') = 0 then
  begin
    Responses.Reason := aOverrideReason;
    Responses.RemComment := aOverrideComment;
  end
  else
  begin
    // only build override section if auto accept order
    if FAutoAccept then
    begin
      // Grab the overrider reasons and comments based on orderable id
      OrdableItemIEN := Responses.IValueFor('ORDERABLE', 1);
      GetAllergyReasonList(aReturnList, StrToInt(OrdableItemIEN),
        aOverrideType);
      result := True;
    end;
  end;
end;

procedure TfrmODBase.ClearDialogControls;
var
  i: Integer;
begin
  FChanging := True;
  for i := 0 to ControlCount - 1 do
  begin
    // need to check if control is container & clear it's children also
    if (Controls[i] is TLabel) or (Controls[i] is TButton) or (Controls[i] is TStaticText) then Continue;
    if FPreserve.IndexOf(Controls[i]) < 0 then ClearControl(Controls[i]);
  end;
  if assigned(memOrder) then memOrder.Clear();

  FChanging := False;
  ShowOrderMessage( False );
end;

procedure TfrmODBase.SetDisplayGroup(Value: Integer);
begin
  FDisplayGroup := Value;
  Responses.FDisplayGroup := Value;
end;

procedure TfrmODBase.SetFillerID(const Value: string);
var
  x: string;
begin
  FFillerID := Value;
  if AddFillerAppID(FFillerID) and OrderChecksEnabled then
  begin
    StatusText('Order Checking...');
    x := OrderChecksOnDisplay(FillerID);
    StatusText('');
    if Length(x) > 0 then InfoBox(x, TC_ORDERCHECKS, MB_OK);
  end;
end;

{ Protected Calls (used by descendant forms) }

procedure TfrmODBase.InitDialog;
begin
  ClearDialogControls;
  ClearAllergyOrderCheckCache;
  uAllergiesChanged := False;
  Responses.Clear;
  AcceptOK := False;
  AbortOrder := False;
end;

function TfrmODBase.OrderForInpatient: Boolean;
var
  AnEventType: Char;
begin
  AnEventType := OrderEventTypeOnCreate;
  // if event type = #0, then it wasn't passed or we're not in create
  if AnEventType = #0 then AnEventType := Responses.FEventType;
  case AnEventType of
  'A','O': Result := True;
  'D': Result := False;
  'T':
  begin
    if IsPassEvt1(FEvtID,'T') then  Result := False
    else Result := True;
  end
  else Result := Patient.Inpatient;
  end;
end;

function TfrmODBase.IsManualEvent: Boolean;
var
  AnEventType: Char;
begin
  AnEventType := OrderEventTypeOnCreate;
  // if event type = #0, then it wasn't passed or we're not in create
  if AnEventType = #0 then AnEventType := Responses.FEventType;
  Result := AnEventType = 'M'
end;

procedure TfrmODBase.ShowOrderMessage(Show: boolean);
var
  t, btm: integer;

begin
  if Show then
  begin
    pnlMessage.Visible := True;
    pnlMessage.BringToFront;
    memMessage.TabStop := True;
    if memOrder.Visible and (pnlMessage.Top < memOrder.BoundsRect.Bottom) then
    begin
      btm := memOrder.BoundsRect.Bottom + pnlMessage.Height + 4;
      if ClientHeight < btm then
      begin
        t := memOrder.Top;
        ClientHeight := btm;
        memOrder.Top := t; // in case of alignments/anchors moves memOrder
      end;
      pnlMessage.Top := memOrder.BoundsRect.Bottom + 2;
    end;
  end
  else
  begin
    pnlMessage.Visible := False;
    pnlMessage.SendToBack;
    memMessage.TabStop := False;
  end;
end;

procedure TfrmODBase.OrderMessage(const AMessage: string);
{Caller needs to set pnlMessage.TabOrder}
begin
  //TDP - Added pnlMessage.Caption for screen reader readability
  pnlMessage.Caption := 'Informational Message.';
  memMessage.Lines.SetText(PChar(AMessage));
  //begin CQ: 2640
  memMessage.SelStart := 0; // Put at first character
  SendMessage(memMessage.Handle, WM_VSCROLL, SB_TOP, 0);
  //End CQ: 2640
  ShowOrderMessage(ContainsVisibleChar(AMessage));
end;

procedure TfrmODBase.PreserveControl(AControl: TControl);
begin
  FPreserve.Add(AControl);
end;

procedure TfrmODBase.SetDialogIEN(Value: Integer);
begin
  FDialogIEN := Value;
end;

procedure TfrmODBase.SetupDialog(OrderAction: Integer; const ID: string);
begin
  FOrderAction := OrderAction;
  AbortOrder := False;
  SetTemplateDialogCanceled(False);   //wat/jh CQ 20061
  ClearAllergyOrderCheckCache;
  uAllergiesChanged := False;
  case OrderAction of
  ORDER_NEW:   {nothing};
  ORDER_EDIT:  Responses.SetEditOrder(ID);
  ORDER_COPY:  Responses.SetCopyOrder(ID);
  ORDER_QUICK: Responses.SetQuickOrderByID(ID);
  end;
  if CharInSet(Responses.FEventType, ['A','D','T','M','O']) then Caption := Caption + ' (Delayed ' + Responses.FEventName + ')'; // ' (Event Delayed)';
  if OrderAction in [ORDER_EDIT, ORDER_COPY] then cmdQuit.Caption := 'Cancel';
end;

function TfrmODBase.GetEffectiveDate: TFMDateTime;
begin
  Result := Responses.FEffective;
end;

function TfrmODBase.GetKeyVariable(const Index: string): string;
begin
  if      UpperCase(Index) = 'LRFZX'    then Result := Piece(FKeyVariables, U, 1)
  else if UpperCase(Index) = 'LRFSAMP'  then Result := Piece(FKeyVariables, U, 2)
  else if UpperCase(Index) = 'LRFSPEC'  then Result := Piece(FKeyVariables, U, 3)
  else if UpperCase(Index) = 'LRFDATE'  then Result := Piece(FKeyVariables, U, 4)
  else if UpperCase(Index) = 'LRFURG'   then Result := Piece(FKeyVariables, U, 5)
  else if UpperCase(Index) = 'LRFSCH'   then Result := Piece(FKeyVariables, U, 6)
  else if UpperCase(Index) = 'PSJNOPC'  then Result := Piece(FKeyVariables, U, 7)
  else if UpperCase(Index) = 'GMRCNOPD' then Result := Piece(FKeyVariables, U, 8)
  else if UpperCase(Index) = 'GMRCNOAT' then Result := Piece(FKeyVariables, U, 9)
  else if UpperCase(Index) = 'GMRCREAF' then Result := Piece(FKeyVariables, U, 10)
  else                                       Result := '';
end;

procedure TfrmODBase.SetKeyVariables(const VarStr: string);
begin
  FKeyVariables := VarStr;
end;

procedure TfrmODBase.setTabToDiet;
begin

end;

procedure TfrmODBase.Validate(var AnErrMsg: string);
const
  TX_OR_DISABLED = 'Ordering has been disabled.  Press Quit.';
  TX_PAST_START  = 'The start date may not be earlier than the present.';
  TX_NO_LOCATION = 'A location must be identified.' + CRLF +
                   '(Select File | Update Provider/Location)';
  TX_NO_PROVIDER = 'A provider who is authorized to write orders must be indentified.' + CRLF +
                   '(Select File | Update Provider/Location)';
var
  StartStr,x: string;
  StartDt: TFMDateTime;
begin
  AnErrMsg := '';
  if User.NoOrdering then AnErrMsg := 'Ordering has been disabled.  Press Quit.';
  // take this out if we <don't> need to check for earlier start date/times
  // should this check be against FMNow??
  StartStr := Piece(Responses.IValueFor('START', 1), '.', 1);
  if not IsFMDateTime(StartStr)
    then StartDt := StrToFMDateTime(StartStr)
    else StartDt := StrToFloat(StartStr);
  if (StartDt > 0) and (StartDt < FMToday)
    then AnErrMsg := 'The start date may not be earlier than the present.';
  //frmFrame.UpdatePtInfoOnRefresh;
  if (not Patient.Inpatient) and (Responses.EventIFN > 0) then x := ''
  else
  begin
    if Encounter.Location = 0 then AnErrMsg := TX_NO_LOCATION;
  end;
  if (Encounter.Provider = 0) or (PersonHasKey(Encounter.Provider, 'PROVIDER') = False)
    then AnErrMsg := TX_NO_PROVIDER;
  if IsPFSSActive and Responses.PromptExists('VISITSTR') then
    Responses.Update('VISITSTR', 1, Encounter.VisitStr, Encounter.VisitStr);
end;

{ Form Calls }

procedure TfrmODBase.FormCreate(Sender: TObject);
begin
  inherited;
  FMergeOrderChecks := False;
  frmODBase   := Self;
  AcceptOK    := False;
  AbortOrder  := False;
  FAutoAccept := False;
  FChanging   := False;
  FClosing    := False;
  FFromQuit   := False;
  FTestMode   := False;
  FIncludeOIPI := True;
  FEvtForPassDischarge := #0;
  FCtrlInits  := TCtrlInits.Create;
  FResponses  := TResponses.Create;
  FPreserve   := TList.Create;
  FIsIMO      := False;          //imo
  FIsSupply   := False;
  UAPCanceled := False; //rtw
  {This next bit is mostly for the font size.  It also sets the default size of
  order forms if it is not in the database.  This is handy if a new user wants
  to have large fonts.  However, in the general case, this will be resized
  through rMisc.SetFormPosition.}
  if not AutoSizeDisabled then
    ResizeFormToFont(self);
  DoSetFontSize(MainFontSize);

  imgMessage.Picture.Icon.Handle := LoadIcon(0, IDI_ASTERISK);
  //if User.NoOrdering then cmdAccept.Enabled := False;
  if uCore.User.NoOrdering then cmdAccept.Enabled := False;
  FDlgFormID := OrderFormIDOnCreate;
  FEvtID     := OrderEventIDOnCreate;
  FEvtType   := OrderEventTypeOnCreate;
  FEvtName   := OrderEventNameOnCreate;
  //CQ 20854 - Display Supplies Only - JCS
  FEvtDlgID  := OrderFormDlgIDOnCreate;
  DefaultButton := cmdAccept;
end;

procedure TfrmODBase.FormDestroy(Sender: TObject);
var
  o: TComponent;

begin
  ClearAllergyOrderCheckCache; // in case the dialog was never shown
  frmODBase := nil;
  FCtrlInits.Free;
  FResponses.Free;
  FPreserve.Free;
  //DestroyingOrderDialog;
  if Assigned(FCallOnExit) then FCallOnExit;
  o := UnwrappedOwner(Self);
  if (o <> nil) and (o is TWinControl) and (TWinControl(o).HandleAllocated) then
    SendMessage(TWinControl(o).Handle, UM_DESTROY, FRefNum, 0);
  inherited;
end;

procedure TfrmODBase.FormKeyPress(Sender: TObject; var Key: Char);
{ causes RETURN to be treated as pressing a tab key (need to have user preference) }
begin
  inherited;
  if (Key = #13) and not (ActiveControl is TCustomMemo) then
  begin
    Key := #0;
    Perform(WM_NEXTDLGCTL, 0, 0);
  end;
end;

{ Accept & Quit Buttons }
function TfrmODBase.AcceptOrderChecks: boolean;
{ returns True if order was accepted with order checks, false if order should be cancelled }
var
  OIList: TStringList;
begin
  result := True;
  if not OrderChecksEnabled then
    Exit;
  DupORIFN := '';
  StatusText('');
  OIList := TStringList.Create;
  try
    BuildOrderChecks(OIList);
    result := AcceptOrderWithChecks(OIList, BuildOrderChecks, OverrideFunction);
  finally
    FreeAndNil(OIList);
    StatusText('');
  end;
end;

function TfrmODBase.ValidSave: Boolean;
const
  TX_NO_SAVE     = 'This order cannot be saved for the following reason(s):' + CRLF + CRLF;
  TX_NO_SAVE_CAP = 'Unable to Save Order';
  TX_SAVE_ERR    = 'Unexpected error - it was not possible to save this order.';
var
  ErrMsg: string;
  NewOrder: TOrder;
  CanSign, OrderAction: Integer;
  IsDelayOrder: boolean;
  //thisSourceOrder: TOrder;
begin
  Result := True;
  IsDelayOrder := False;
  Validate(ErrMsg);
  if Length(ErrMsg) > 0 then
  begin
    if Trim(ErrMsg) <> TX_INVALID_NO_MESSAGE then
      InfoBox(TX_NO_SAVE + ErrMsg, TX_NO_SAVE_CAP, MB_OK);
    Result := False;
    Exit;
  end;
  if not AcceptOrderChecks then
  begin
    //added code to shut CPRS down without access violations if the fOCAccept is open when timing out.
    if frmFrame.TimedOut then
      begin
         Result := False;
         Exit;
      end;
    if AskAnotherOrder(DialogIEN) then
        InitDialog           // ClearDialogControls is in InitDialog
      else
        begin
          ClearDialogControls;    // to allow form to close without prompting to save order
          Close;
        end;
    Result := False;
    Exit;
  end;
  if FTestMode then
  begin
    Result := False;
    Exit;
  end;
  // LES validation checking for changed lab order
  if not LESValidationCheck then Exit;
  NewOrder := TOrder.Create;

  Responses.SaveOrder(NewOrder, DialogIEN, FIsIMO);

  if frmOrders.IsDefaultDlg then
  begin
    frmOrders.EventDefaultOrder := NewOrder.ID;
    frmOrders.EvtOrderList.Add(NewOrder.EventPtr + '^' + NewOrder.ID);
    frmOrders.IsDefaultDlg := False;
  end;
  if Length(DfltCopay)>0 then SetDefaultCoPayToNewOrder(NewOrder.ID, DfltCopay);
  if (Length(FEvtName)>0) then
  begin
    NewOrder.EventName := 'Delayed ' + MixedCase(FEvtName);
    FEvtName := '';
  end;
  if not ProcessOrderAcceptEventHook(NewOrder.ID, NewOrder.DGroup) then
  begin
    if NewOrder.ID <> '' then
    begin
      if (Encounter.Provider = User.DUZ) and User.CanSignOrders
        then CanSign := CH_SIGN_YES
        else CanSign := CH_SIGN_NA;
      if NewOrder.Signature = OSS_NOT_REQUIRE then CanSign := CH_SIGN_NA;
      if (NewOrder.EventPtr <> '') and (GetEventDefaultDlg(responses.FEventIFN) <> InttoStr(Responses.QuickOrder)) then
          IsDelayOrder := True;
      Changes.Add(CH_ORD, NewOrder.ID, NewOrder.Text, Responses.FViewName, CanSign,
        waOrders,'',0, NewOrder.DGroup, NewOrder.DGroupName, False, IsDelayOrder);

    UBAGlobals.TargetOrderID := NewOrder.ID;

      if Responses.EditOrder = '' then OrderAction := ORDER_NEW else OrderAction := ORDER_EDIT;
      SendMessage(Application.MainForm.Handle, UM_NEWORDER, OrderAction, Integer(NewOrder));
    end
    else InfoBox(TX_SAVE_ERR, TX_NO_SAVE_CAP, MB_OK);
  end;
  NewOrder.Free;      // free here - recieving forms should get own copy using assign
end;

procedure TfrmODBase.cmdAcceptClick(Sender: TObject);
const
  TX_CMPTEVT = ' occurred since you started writing delayed orders. '
    + 'The orders that were entered and signed have now been released. '
    + 'Any unsigned orders will be released immediately upon signature. '
    + #13#13
    + 'To write new delayed orders for this event you need to click the write delayed orders button again and select the appropriate event. '
    + 'Orders delayed to this same event will remain delayed until the event occurs again.'
    + #13#13
    + 'The Orders tab will now be refreshed and switched to the Active Orders view. '
    + 'If you wish to continue to write active orders for this patient, '
    + 'close this message window and continue as usual.';
var
  theGrpName: string;
  keepOpen, alreadyClosed: boolean;
  LateTrayFields: TLateTrayFields;
  x, CxMsg: string;
  List: TStringList;
  Value: Integer;
begin
  if FAcceptingOrder then
    Exit;
  FTriedToClose := False;
  FAcceptingOrder := True;
  try

    AcceptOK := False;
    CIDCOkToSave := False;
    alreadyClosed := False;
    Self.Responses.Cancel := False;
    keepOpen := False;
    UAPCanceled := False; // rtw
    if frmOrders <> nil then
    begin
      if (frmOrders.TheCurrentView <> nil) and
        (frmOrders.TheCurrentView.EventDelay.PtEventIFN > 0) and
        IsCompletedPtEvt(frmOrders.TheCurrentView.EventDelay.PtEventIFN) then
      begin
        theGrpName := 'Delayed ' + frmOrders.TheCurrentView.EventDelay.
          EventName;
        SaveAsCurrent := True;
      end;
    end;
    if (Responses.Dialog = 'FHW8') and Patient.Inpatient then
    begin
      List := TStringList.Create;
      try
        begin
          x := CurrentDietText;

          if Piece(x, #13, 1) = 'Current Diet:  ' then
          begin
            List.Add('Continue to write diet order^true');
            uInfoBoxWithBtnControls.DefMessageDlg
              ('Active TubeFeeding Order must have an active diet order',
              mtConfirmation, List, 'New Diet Order Required', False);
            keepOpen := True;
          end
          else
          begin
            CheckForAutoDCDietOrders(Self.EvtID, Self.DisplayGroup, x, CxMsg,
              nil, True);

            List.Add('Continue CURRENT Diet Order^false');
            List.Add('Write NEW Diet ORder^false');
            Value := uInfoBoxWithBtnControls.DefMessageDlg
              ('"A tubefeeding order must also have an active diet order' + #9 +
              CxMsg, mtConfirmation, List, 'Diet Order Required', True);
            if Value = 1 then
              keepOpen := True;
          end;
        end;
      finally
        List.Free;
      end;
    end;
    // check for diet orders that will be auto-DCd because of start/stop overlaps
    if Responses.Dialog = 'FHW1' then
    begin
      if (Self.EvtID <> 0) then
      begin
        CheckForAutoDCDietOrders(Self.EvtID, Self.DisplayGroup, '', CxMsg,
          cmdAccept);
        if CxMsg <> '' then
        begin
          if InfoBox(CxMsg + CRLF + CRLF + 'Have you done either of the above?',
            'Possible delayed order conflict', MB_ICONWARNING or MB_YESNO) = ID_NO
          then
            Exit;
        end;
      end
      else if FAutoAccept then
      begin
        x := CurrentDietText;
        CheckForAutoDCDietOrders(0, Self.DisplayGroup, x, CxMsg, nil);
        if CxMsg <> '' then
        begin
          if InfoBox(CxMsg + CRLF + 'Are you sure?', 'Confirm',
            MB_ICONWARNING or MB_YESNO) = ID_NO then
          begin
            // AbortOrder := True;
            AcceptOK := False;
            // cmdQuitClick(Self);
            Exit;
          end;
        end;
      end;
    end;

    if ValidSave then
    begin
      AcceptOK := True;
      CIDCOkToSave := True;
      with Responses do
        if (not FAutoAccept and (CopyOrder = '') and (EditOrder = '') and
          (TransferOrder = '') and AskAnotherOrder(DialogIEN)) then
          InitDialog
        else if (keepOpen = True) then
        begin
          if Not FAutoAccept then
          begin
            if Responses.Dialog = 'FHW8' then
              setTabToDiet;
            InitDialog
          end
          else
          begin
            SetupDialog(0, 'FHW');
          end;
        end // ClearDialogControls is in InitDialog
        else
        begin
          LateTrayFields.LateMeal := #0;
          with Responses do
            if FAutoAccept and ((Dialog = 'FHW1') or (Dialog = 'FHW OP MEAL') or
              (Dialog = 'FHW SPECIAL MEAL')) then
            begin
              LateTrayCheck(Responses, Self.EvtID, not OrderForInpatient,
                LateTrayFields);
            end;
          ClearDialogControls;
          // to allow form to close without prompting to save order
          with LateTrayFields do
            if LateMeal <> #0 then
              LateTrayOrder(LateTrayFields, OrderForInpatient);
          Close;
          alreadyClosed := True;
        end;
      if NoFresh then
      begin
        if SaveAsCurrent then
        begin
          SaveAsCurrent := False;
          with Responses do
          begin
            if not alreadyClosed then
            begin
              ClearDialogControls;
              Close;
            end;
          end;
          frmOrders.GroupChangesUpdate(theGrpName);
          Exit;
        end;
      end
      else
      begin
        if SaveAsCurrent then
        begin
          SaveAsCurrent := False;
          with Responses do
          begin
            if not alreadyClosed then
            begin
              ClearDialogControls;
              Close;
            end;
          end;
          frmOrders.GroupChangesUpdate(theGrpName);
          // EDONeedRefresh := True;
          Exit;
        end;
      end
    end; { if ValidSave }
    if SaveAsCurrent then
      SaveAsCurrent := False;

  finally
    FAcceptingOrder := False;
    if FTriedToClose then
      Close;
  end;
end;

procedure TfrmODBase.cmdQuitClick(Sender: TObject);
begin
  inherited;
  FFRomQuit := True;
  UAPCanceled := True;  //rtw
  Close;
end;

procedure TfrmODBase.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  // unlock an order that is being edited if accept wasn't pressed
  //   this unlock is currently done in ActivateOrderDialog
  //with Responses do if (Length(EditOrder) > 0) and (not FAcceptOK) then UnlockOrder(EditOrder);
  ClearAllergyOrderCheckCache;
  PopKeyVars;
  SaveUserBounds(Self);
  FClosing := True;
  Action := caFree;
  Encounter.SwitchToSaved(True);
  frmFrame.DisplayEncounterText;
  (*
  if User.NoOrdering then Exit;
  if Length(memOrder.Text) > 0 then
    if InfoBox(TX_ACCEPT + memOrder.Text, TX_ACCEPT_CAP, MB_YESNO) = ID_YES then
      if not ValidSave then
      begin
        FClosing := False;
        Action := caNone;
      end;
  *)
end;

procedure TfrmODBase.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  inherited;
  if FAcceptingOrder then
  begin
    FTriedToClose := True;
    CanClose := False;
    exit;
  end;
  //self.Responses.Cancel := False;
  if User.NoOrdering then Exit;
  if AbortOrder then
  begin
    SetTemplateDialogCanceled(FALSE);
    exit;
  end;
  if FOrderAction in [ORDER_EDIT, ORDER_COPY] then Exit;  // don't invoke verify dialog
  if FOrderAction = ORDER_QUICK then Exit;                // should this be here??
  if frmFrame.ContextChanging then
    begin
      // close any sub-dialogs created by order dialog FIRST!!
      exit;
    end;
  if FFromQuit = False then updateSig;
  if Length(memOrder.Text) > 0 then
  begin
    if InfoBox(TX_ACCEPT + memOrder.Text, TX_ACCEPT_CAP, MB_YESNO) = ID_YES
      then CanClose := ValidSave
      else memOrder.Text := '';  // so don't return False on subsequent CloseQuery
  end;
end;

procedure TfrmODBase.TabClose(var CanClose: Boolean);
begin
  inherited;
  CanClose := True;
  if Length(memOrder.Text) > 0 then
    if InfoBox(TX_ACCEPT + memOrder.Text, TX_ACCEPT_CAP, MB_YESNO) = ID_YES then
      if not ValidSave then CanClose := False;
  if CanClose then InitDialog;
end;

procedure TfrmODBase.tmrBringToFrontTimer(Sender: TObject);
begin
  inherited;
  tmrBringToFront.Enabled := False;
  BringToFront;
end;

procedure TfrmODBase.updateSig;
begin

end;

procedure TfrmODBase.memMessageMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  ShowOrderMessage( False );
end;

procedure TfrmODBase.SetDefaultCoPay(AnOrderID: string);
begin
  FDfltCopay := GetDefaultCopay(AnOrderID);
end;

procedure TfrmODBase.DoSetFontSize( FontSize: integer);
begin
  if AutoSizeDisabled then
    inherited DoSetFontSize(FontSize)
  else
  begin
    //You get to resize the window yourself!
    Font.Size := FontSize;
    memMessage.DefAttributes.Size := FontSize;
  end;
end;

procedure TfrmODBase.DoShow;
begin
  inherited;
  tmrBringToFront.Enabled := True;
end;

procedure TfrmODBase.SetFontSize( FontSize: integer);
begin
  DoSetFontSize( FontSize );
end;

function TResponses.GetIENForPrompt(const APromptID: string): Integer;
var
  i: Integer;
begin
  Result := 0;
  with FPrompts do for i := 0 to Count - 1 do with TPrompt(Items[i]) do
    if (ID = APromptID) then
    begin
      Result := IEN;
      break;
    end;
end;

procedure TfrmODBase.pnlMessageExit(Sender: TObject);
begin
  inherited;
  ShowOrderMessage(False);
end;

procedure TfrmODBase.pnlMessageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  FMessageClickX := X;
  FMessageClickY := Y;
end;

procedure TfrmODBase.pnlMessageMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if (ssLeft in Shift) then
    pnlMessage.SetBounds(pnlMessage.Left + X - FMessageClickX, pnlMessage.Top + Y - FMessageClickY, pnlMessage.Width, pnlMessage.Height);
end;

function TfrmODBase.LESValidationCheck: boolean;
var
  idx: integer;
  LESGrpList,LESRejectedReason: TStringList;
  IsLESOrder: boolean;
  TempMSG,LESODInfo: string;
begin
  Result := True;
  if Length(Responses.EditOrder)>1 then
  begin
    LESGrpList := TStringList.Create;
    PiecesToList(GetDispGroupForLES,'^',LESGrpList);
    IsLESOrder := False;
    for idx:=0 to LESGrpList.Count - 1 do
      if StrToIntDef(LESGrpList[idx],0) = Responses.DisplayGroup then
      begin
        IsLESOrder := True;
        Break;
      end;
    if IsLESOrder then
    begin
      TempMSG := '';
      LESODInfo := Patient.DFN +
                  '^' + Responses.IValueFor('ORDERABLE',1) +
                  '^' + IntToStr(Encounter.Location) +
                  '^' + IntToStr(Encounter.Provider) +
                  '^' + Responses.IValueFor('START',1);
      LESRejectedReason := TStringList.Create;
      LESValidationForChangedLabOrder(LESRejectedReason,LESODInfo);
      if LESRejectedReason.Count > 0 then
      begin
        for idx := 0 to LESRejectedReason.Count - 1 do
        begin
          if Length(LESRejectedReason[idx])>0 then
            TempMSG := TempMSG + #13 + LESRejectedReason[idx];
        end;
        if Length(TempMSG)>0 then
        begin
          ShowMsg(TempMSG);
          Result := False;
        end;
      end;
    end;
  end;
end;


end.
