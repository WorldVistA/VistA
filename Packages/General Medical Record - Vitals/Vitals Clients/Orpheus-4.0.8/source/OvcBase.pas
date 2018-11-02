{*********************************************************}
{*                    OVCBASE.PAS 4.06                   *}
{*********************************************************}

{* ***** BEGIN LICENSE BLOCK *****                                            *}
{* Version: MPL 1.1                                                           *}
{*                                                                            *}
{* The contents of this file are subject to the Mozilla Public License        *}
{* Version 1.1 (the "License"); you may not use this file except in           *}
{* compliance with the License. You may obtain a copy of the License at       *}
{* http://www.mozilla.org/MPL/                                                *}
{*                                                                            *}
{* Software distributed under the License is distributed on an "AS IS" basis, *}
{* WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License   *}
{* for the specific language governing rights and limitations under the       *}
{* License.                                                                   *}
{*                                                                            *}
{* The Original Code is TurboPower Orpheus                                    *}
{*                                                                            *}
{* The Initial Developer of the Original Code is TurboPower Software          *}
{*                                                                            *}
{* Portions created by TurboPower Software Inc. are Copyright (C)1995-2002    *}
{* TurboPower Software Inc. All Rights Reserved.                              *}
{*                                                                            *}
{* Contributor(s):                                                            *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.$W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

{$R OVCBASE.RES}

unit ovcbase;
  {-Base unit for Orpheus visual components}

interface

uses
  UITypes, Types, Windows, Classes, Controls, Dialogs, Forms, Messages,
  StdCtrls, SysUtils, OvcCmd, OvcData, OvcMisc, OvcConst, OvcExcpt, OvcTimer, OvcDate;

type
  TOvcLabelPosition = (lpTopLeft, lpBottomLeft); {attached label types}

  TOvcAttachEvent = procedure(Sender : TObject; Value : Boolean)
    of object;

  TOvcAttachedLabel = class(TLabel)
  protected {private}
    FControl : TWinControl;

  protected
    procedure SavePosition;
    procedure Loaded;
      override;

  public
    constructor Create(AOwner : TComponent);
      override;
    constructor CreateEx(AOwner : TComponent; AControl : TWinControl);
      virtual;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
      override;

  published
    property Control : TWinControl
      read FControl write FControl;
  end;

  TO32ContainerList = class(TList)
    FOwner: TComponent;
  public
    constructor Create(AOwner: TComponent); virtual;
    destructor Destroy; override;
  end;

  TOvcLabelInfo = class(TPersistent)
  protected {private}
    {property variables}
    FOffsetX  : Integer;
    FOffsetY  : Integer;

    {event variables}
    FOnChange : TNotifyEvent;
    FOnAttach : TOvcAttachEvent;

    {internal methods}
    procedure DoOnAttach;
    procedure DoOnChange;
    function IsVisible : Boolean;

    {property methods}
    procedure SetOffsetX(Value : Integer);
    procedure SetOffsetY(Value : Integer);
    procedure SetVisible(Value : Boolean);

  public
    ALabel   : TOvcAttachedLabel;
    FVisible : Boolean;

    property OnAttach : TOvcAttachEvent
      read FOnAttach write FOnAttach;
    property OnChange : TNotifyEvent
      read FOnChange write FOnChange;

    procedure SetOffsets(X, Y : Integer);

  published
    property OffsetX: Integer
      read FOffsetX write SetOffsetX stored IsVisible;
    property OffsetY: Integer
      read FOffsetY write SetOffsetY stored IsVisible;
    property Visible : Boolean
      read FVisible write SetVisible
      default False;
  end;

  {event method types}
  TMouseWheelEvent = procedure(Sender : TObject; Shift : TShiftState;
                                Delta, XPos, YPos : Word) of object;

  TDataErrorEvent =
    procedure(Sender : TObject; ErrorCode : Word; const ErrorMsg : string)
    of object;
  TPostEditEvent =
    procedure(Sender : TObject; GainingControl : TWinControl)
    of object;
  TPreEditEvent =
    procedure(Sender : TObject; LosingControl : TWinControl)
    of object;
  TDelayNotifyEvent =
    procedure(Sender : TObject; NotifyCode : Word)
    of object;
  TIsSpecialControlEvent =
    procedure(Sender : TObject; Control : TWinControl;
    var Special : Boolean)
    of object;
  TGetEpochEvent =
    procedure (Sender : TObject; var Epoch : Integer)
    of object;

  {options which will be the same for all fields attached to the same controller}
  TOvcBaseEFOption = (
    efoAutoAdvanceChar,
    efoAutoAdvanceLeftRight,
    efoAutoAdvanceUpDown,
    efoAutoSelect,
    efoBeepOnError,
    efoInsertPushes);
  TOvcBaseEFOptions = set of TOvcBaseEFOption;

type
  TOvcCollectionStreamer = class;
  TOvcCollection = class;
  TO32Collection = class;

  {implements the About property and collection streaming}
  TOvcComponent = class(TComponent)
  protected {private}
    FCollectionStreamer : TOvcCollectionStreamer;
    FInternal : Boolean; {flag to suppress name generation
                          on collection items}
    function GetAbout : string;
    procedure SetAbout(const Value : string);

  protected
    {OrCollection streaming hooks:}
    procedure GetChildren(Proc: TGetChildProc; Root : TComponent); override;
    function GetChildOwner: TComponent; override;
    procedure Loaded; override;

  public
    constructor Create(AOwner: TComponent);
      override;
    destructor Destroy;
      override;

    property CollectionStreamer : TOvcCollectionStreamer
      read FCollectionStreamer
      write FCollectionStreamer;
    property Internal : Boolean read FInternal write FInternal;
  published
    {properties}
    property About : string
      read GetAbout
      write SetAbout
      stored False;
  end;

  {implements the About property}
  TO32Component = class(TComponent)
  protected {private}
    FInternal : Boolean; {flag to suppress name generation
                          on collection items}
    function GetAbout : string;
    procedure SetAbout(const Value : string);
  public
    constructor Create(AOwner: TComponent); override;
    property Internal : Boolean read FInternal write FInternal;
  published
    {properties}
    property About : string read GetAbout write SetAbout stored False;
  end;

  TOvcController = class(TOvcComponent)
  protected {private}
    FBaseEFOptions : TOvcBaseEFOptions;     {options common to all entry fields}
    FEntryCommands : TOvcCommandProcessor;   {command processor}
    FEpoch         : Integer;                {combined epoch year and century}
    FErrorPending  : Boolean;                {an error is pending for an ef}
    FErrorText     : string;                 {text of last error}

{ - HWnd changed to TOvcHWnd for BCB Compatibility }
    FHandle        : TOvcHWnd{hWnd};         {our window handle}

    FInsertMode    : Boolean;                {global insert mode flag}
    FTimerPool     : TOvcTimerPool;          {general timer pool}

    {events}
    FOnDelayNotify      : TDelayNotifyEvent;
    FOnError            : TDataErrorEvent;
    FOnGetEpoch         : TGetEpochEvent;
    FOnIsSpecialControl : TIsSpecialControlEvent;
    FOnPostEdit         : TPostEditEvent;
    FOnPreEdit          : TPreEditEvent;
    FOnTimerTrigger     : TTriggerEvent;

    {property methods}
    function GetEpoch : Integer;

{ - HWnd changed to TOvcHWnd for BCB Compatibility }
    function GetHandle : TOvcHWnd{hWnd};
    procedure SetEpoch(Value : Integer);

    {internal methods}
    procedure cWndProc(var Msg : TMessage);
      {-window procedure}

  public
    constructor Create(AOwner: TComponent);
      override;
    destructor Destroy;
      override;

    procedure DestroyHandle;

    {wrappers for event handlers}
    procedure DoOnPostEdit(Sender : TObject; GainingControl : TWinControl);
      {-call the method assigned to the OnPostEdit event}
    procedure DoOnPreEdit(Sender : TObject; LosingControl : TWinControl);
      {-call the method assigned to the OnPreEdit event}
    procedure DoOnTimerTrigger(Sender : TObject; Handle : Integer;
                               Interval : Cardinal; ElapsedTime : Integer);

    procedure DelayNotify(Sender : TObject; NotifyCode : Word);
      {-start the chain of events that will fire the OnDelayNotify event}
    procedure DoOnError(Sender : TObject; ErrorCode : Word; const ErrorMsg : string);
      {-call the method assigned to the OnError event}

{ - HWnd changed to TOvcHWnd for BCB Compatibility }
    function IsSpecialButton(H : TOvcHWnd{hWnd}) : Boolean;
      dynamic;
      {-return true if H is btnCancel, btnHelp, or btnRestore}
    procedure MarkAsUninitialized(Uninitialized : Boolean);
      {-mark all entry fields on form as uninitialized}
    function ValidateEntryFields : TComponent;
      {-ask each entry field to validate its contents. Return nil
        if no error, else return pointer to field with error}
    function ValidateEntryFieldsEx(ReportError, ChangeFocus : Boolean) : TComponent;
      {-ask each entry field to validate its contents. Return nil
        if no error, else return pointer to field with error.
        Conditionally move focus and report error}
    function ValidateTheseEntryFields(const Fields : array of TComponent) : TComponent;
      {-ask the specified entry fields to validate their contents. Return nil
        if no error, else return pointer to field with error}

    property ErrorPending : Boolean
      read FErrorPending write FErrorPending;
    property ErrorText : string
      read FErrorText write FErrorText;

{ - HWnd changed to TOvcHWnd for BCB Compatibility }
    property Handle : TOvcHWnd{hWnd}
      read GetHandle;
    property InsertMode : Boolean
      read FInsertMode write FInsertMode;
    property TimerPool : TOvcTimerPool
      read FTimerPool;

  published
    {properties}
    property EntryCommands : TOvcCommandProcessor
      read FEntryCommands write FEntryCommands stored True;
    property EntryOptions : TOvcBaseEFOptions
      read FBaseEFOptions write FBaseEFOptions
      default [efoAutoSelect, efoBeepOnError, efoInsertPushes];
    property Epoch : Integer
      read GetEpoch write SetEpoch;

    {events}
    property OnError : TDataErrorEvent
      read FOnError write FOnError;
    property OnGetEpoch : TGetEpochEvent
      read FOnGetEpoch write FOnGetEpoch;
    property OnDelayNotify : TDelayNotifyEvent
      read FOnDelayNotify write FOnDelayNotify;
    property OnIsSpecialControl : TIsSpecialControlEvent
      read FOnIsSpecialControl write FOnIsSpecialControl;
    property OnPostEdit : TPostEditEvent
      read FOnPostEdit write FOnPostEdit;
    property OnPreEdit : TPreEditEvent
      read FOnPreEdit write FOnPreEdit;
    property OnTimerTrigger : TTriggerEvent
      read FOnTimerTrigger write FOnTimerTrigger;
  end;

  TOvcGraphicControl = class(TGraphicControl)
  protected {private}
    FCollectionStreamer : TOvcCollectionStreamer;
    {property methods}
    function GetAbout : string;
    procedure SetAbout(const Value : string);
  protected
    {Collection streaming hooks:}
    procedure GetChildren(Proc: TGetChildProc; Root : TComponent); override;
    function GetChildOwner: TComponent; override;
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property CollectionStreamer : TOvcCollectionStreamer
      read FCollectionStreamer write FCollectionStreamer;
  published
    property About : string
      read GetAbout write SetAbout stored False;
  end;

  {Replacement for the TOvcCustomControl except with standard VCL streaming}
  TO32CustomControl = class(TCustomControl)
  protected {private}
    {property variables}
    FAfterEnter         : TNotifyEvent;
    FAfterExit          : TNotifyEvent;
    FOnMouseWheel       : TMouseWheelEvent;
    FLabelInfo          : TOvcLabelInfo;
    FInternal : Boolean; {flag to suppress name generation
                          on collection items}

    {property methods}
    function GetAttachedLabel : TOvcAttachedLabel;
    function GetAbout : string;
    procedure SetAbout(const Value : string);

    {internal methods}
    procedure LabelAttach(Sender : TObject; Value : Boolean);
    procedure LabelChange(Sender : TObject);
    procedure PositionLabel;

    {private message methods}
    procedure OMAssignLabel(var Msg : TMessage);
      message OM_ASSIGNLABEL;
    procedure OMPositionLabel(var Msg : TMessage);
      message OM_POSITIONLABEL;
    procedure OMRecordLabelPosition(var Msg : TMessage);
      message OM_RECORDLABELPOSITION;
    procedure OMAfterEnter(var Msg : TMessage);
      message OM_AFTERENTER;
    procedure OMAfterExit(var Msg : TMessage);
      message OM_AFTEREXIT;

    {VCL message methods}
    procedure CMVisibleChanged(var Msg : TMessage);
      message CM_VISIBLECHANGED;

    {windows message methods}
    procedure WMKillFocus(var Msg : TWMKillFocus);
      message WM_KILLFOCUS;
    procedure WMMouseWheel(var Msg : TMessage);
      message WM_MOUSEWHEEL;
    procedure WMSetFocus(var Msg : TWMSetFocus);
      message WM_SETFOCUS;

  protected
    DefaultLabelPosition : TOvcLabelPosition;

    procedure DoOnMouseWheel(Shift : TShiftState;
                             Delta, XPos, YPos : SmallInt);
      dynamic;
    procedure CreateWnd;
      override;
    procedure Notification(AComponent : TComponent; Operation : TOperation);
      override;

    property AfterEnter : TNotifyEvent
      read FAfterEnter write FAfterEnter;
    property AfterExit : TNotifyEvent
      read FAfterExit write FAfterExit;
    property OnMouseWheel : TMouseWheelEvent
      read FOnMouseWheel write FOnMouseWheel;
    property LabelInfo : TOvcLabelInfo
      read FLabelInfo write FLabelInfo;

  public
    property Internal : Boolean read FInternal write FInternal;
    constructor Create(AOwner : TComponent);
      override;
    destructor Destroy;
      override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
      override;
    property AttachedLabel : TOvcAttachedLabel
      read GetAttachedLabel;

  published
    property About : string
      read GetAbout write SetAbout stored False;
  end;
  {End - TO32CustomControl}


  TOvcCustomControl = class(TCustomControl)
  protected {private}
    {property variables}
    FAfterEnter         : TNotifyEvent;
    FAfterExit          : TNotifyEvent;
    FCollectionStreamer : TOvcCollectionStreamer;
    FOnMouseWheel       : TMouseWheelEvent;
    FLabelInfo          : TOvcLabelInfo;
    FInternal : Boolean; {flag to suppress name generation
                          on collection items}

    {property methods}
    function GetAttachedLabel : TOvcAttachedLabel;
    function GetAbout : string;
    procedure SetAbout(const Value : string);

    {internal methods}
    procedure LabelAttach(Sender : TObject; Value : Boolean);
    procedure LabelChange(Sender : TObject);
    procedure PositionLabel;

    {private message methods}
    procedure OMAssignLabel(var Msg : TMessage);
      message OM_ASSIGNLABEL;
    procedure OMPositionLabel(var Msg : TMessage);
      message OM_POSITIONLABEL;
    procedure OMRecordLabelPosition(var Msg : TMessage);
      message OM_RECORDLABELPOSITION;
    procedure OMAfterEnter(var Msg : TMessage);
      message OM_AFTERENTER;
    procedure OMAfterExit(var Msg : TMessage);
      message OM_AFTEREXIT;

    {VCL message methods}
    procedure CMVisibleChanged(var Msg : TMessage);
      message CM_VISIBLECHANGED;

    {windows message methods}
    procedure WMKillFocus(var Msg : TWMKillFocus);
      message WM_KILLFOCUS;
    procedure WMMouseWheel(var Msg : TMessage);
      message WM_MOUSEWHEEL;
    procedure WMSetFocus(var Msg : TWMSetFocus);
      message WM_SETFOCUS;

  protected
    {descendants can set the value of this variable after calling inherited }
    {create to set the default location and point-of-reference (POR) for the}
    {attached label. if dlpTopLeft, the default location and POR will be at }
    {the top left of the control. if dlpBottomLeft, the default location and}
    {POR will be at the bottom left}
    DefaultLabelPosition : TOvcLabelPosition;

    procedure DoOnMouseWheel(Shift : TShiftState;
                             Delta, XPos, YPos : SmallInt);
      dynamic;
    procedure CreateWnd;
      override;
    procedure Notification(AComponent : TComponent; Operation : TOperation);
      override;

    function GetChildOwner: TComponent; override;
    procedure Loaded; override;

    property AfterEnter : TNotifyEvent
      read FAfterEnter write FAfterEnter;
    property AfterExit : TNotifyEvent
      read FAfterExit write FAfterExit;
    property OnMouseWheel : TMouseWheelEvent
      read FOnMouseWheel write FOnMouseWheel;
    property LabelInfo : TOvcLabelInfo
      read FLabelInfo write FLabelInfo;

  public
    {Collection streaming hooks:}
    procedure GetChildren(Proc: TGetChildProc; Root : TComponent); override;
    constructor Create(AOwner : TComponent);
      override;
    destructor Destroy;
      override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
      override;
    property AttachedLabel : TOvcAttachedLabel
      read GetAttachedLabel;
    property CollectionStreamer : TOvcCollectionStreamer
      read FCollectionStreamer write FCollectionStreamer;
    property Internal : Boolean read FInternal write FInternal;

  published
    property About : string
      read GetAbout write SetAbout stored False;
  end;

  TOvcCollectible = class(TOvcComponent)
  protected {private}
    FCollection : TOvcCollection;
    InChanged : Boolean;

    function GetIndex : Integer;
    procedure SetCollection(Value : TOvcCollection);
    procedure SetIndex(Value : Integer); virtual;

  protected
    procedure Changed; dynamic;
    function GenerateName : string;
      dynamic;
    function GetBaseName : string;
      dynamic;
    function GetDisplayText : string;
      virtual;
    procedure SetName(const NewName : TComponentName);
      override;

  public
    constructor Create(AOwner : TComponent);
      override;
    destructor Destroy;
      override;
    property Collection : TOvcCollection
      read FCollection;
    property DisplayText : string
      read GetDisplayText;
    property Index : Integer
      read GetIndex
      write SetIndex;

    property Name;
  end;

  TO32CollectionItem = class(TCollectionItem)
  protected {private}
    FName: String;
    FDisplayText: String;
    function GetAbout: String;
    procedure SetAbout(const Value: String);
    procedure SetName(Value: String); virtual;
  public
    property DisplayText : string read FDisplayText write FDisplayText;
    property Name: String read FName write SetName;
  published
    property About : String read GetAbout write SetAbout;
  end;


  TOvcCollectibleControl = class(TOvcCustomControl)
  protected {private}
    FCollection : TOvcCollection;
    FInternal : Boolean; {flag to suppress name generation
                          on collection items}
    InChanged : Boolean;

    function GetIndex : Integer;
    procedure SetCollection(Value : TOvcCollection);
    procedure SetIndex(Value : Integer);

  protected
    procedure Changed; dynamic;
    function GenerateName : string;
      dynamic;
    function GetBaseName : string;
      dynamic;
    function GetDisplayText : string;
      virtual;
    procedure SetName(const NewName : TComponentName);
      override;

  public
    constructor Create(AOwner : TComponent);
      override;
    destructor Destroy;
      override;

    property Internal : Boolean read FInternal write FInternal;

    property Collection : TOvcCollection
      read FCollection;

    property DisplayText : string
      read GetDisplayText;

    property Index : Integer
      read GetIndex
      write SetIndex;

    property Name;
  end;

  TOvcCollectibleClass = class of TComponent;
  TO32CollectibleClass = class of TPersistent;

  TOvcItemSelectedEvent =
    procedure(Sender : TObject; Index : Integer) of object;
  TOvcGetEditorCaption =
    procedure(var Caption : string) of object;
  TO32GetEditorCaption =
    procedure(var Caption : string) of object;

  TOvcCollection = class(TPersistent)
  protected {private}
    {property variables}
    FItemClass      : TOvcCollectibleClass;
    FItemEditor     : TForm;
    FItems          : TList;
    FOwner          : TComponent;
    FReadOnly       : Boolean;
    FStored         : Boolean;
    FStreamer       : TOvcCollectionStreamer;

    {event variables}
    FOnChanged      : TNotifyEvent;
    FOnItemSelected : TOvcItemSelectedEvent;
    FOnGetEditorCaption : TOvcGetEditorCaption;

    {Internal variables}
    InLoaded        : Boolean;
    IsLoaded        : Boolean;
    InChanged       : Boolean;

  protected
    function GetCount : Integer;
    function GetItem(Index: Integer): TComponent;
    procedure SetItem(Index: Integer; Value: TComponent);

    procedure Changed;
      virtual;
    procedure Loaded;

  public
    constructor Create(AOwner : TComponent; ItemClass : TOvcCollectibleClass);
    destructor Destroy;
      override;
    property ItemEditor : TForm
      read FItemEditor write FItemEditor;

    function Add : TComponent;
    procedure Clear; virtual;
    procedure Delete(Index : Integer);
    procedure DoOnItemSelected(Index : Integer);
    function GetEditorCaption : string;
    function ItemByName(const Name : string) : TComponent;
    function Insert(Index : Integer) : TComponent;
    function ParentForm : TForm;

    property Count: Integer
                   read GetCount;
    property ItemClass : TOvcCollectibleClass
                   read FItemClass;
    property Item[Index: Integer] : TComponent
                   read GetItem write SetItem; default;
    property OnGetEditorCaption : TOvcGetEditorCaption
      read FOnGetEditorCaption write FOnGetEditorCaption;
    property Owner : TComponent
                   read FOwner;
    property ReadOnly : Boolean
                   read FReadOnly write FReadOnly default False;
    property Stored : Boolean
                   read FStored write FStored default True;
    property OnChanged : TNotifyEvent
                   read FOnChanged write FOnChanged;
    property OnItemSelected : TOvcItemSelectedEvent
                   read FOnItemSelected write FOnItemSelected;
  end;

  TO32Collection = class(TCollection)
  protected {private}
    {property variables}
    FItemEditor     : TForm;
    FReadOnly       : Boolean;

    FOwner: TPersistent;

    {event variables}
    FOnChanged      : TNotifyEvent;
    FOnItemSelected : TOvcItemSelectedEvent;
    FOnGetEditorCaption : TO32GetEditorCaption;

    {Internal variables}
    InLoaded        : Boolean;
    IsLoaded        : Boolean;
    InChanged       : Boolean;

  protected
    function GetCount : Integer;
    procedure Loaded;
  public
    constructor Create(AOwner : TPersistent;
      ItemClass : TCollectionItemClass); virtual;
    destructor Destroy; override;
    property ItemEditor : TForm read FItemEditor write FItemEditor;

    function Add : TO32CollectionItem; dynamic;

    function GetItem(Index: Integer): TO32CollectionItem;
    function GetOwner: TPersistent; override;
    procedure SetItem(Index: Integer; Value: TO32CollectionItem);
    procedure DoOnItemSelected(Index : Integer);
    function GetEditorCaption : string;
    function ItemByName(const Name : string) : TO32CollectionItem;
    function ParentForm : TForm;

    property Count: Integer
                   read GetCount;
    property Item[Index: Integer] : TO32CollectionItem
                   read GetItem write SetItem; default;
    property OnGetEditorCaption : TO32GetEditorCaption
      read FOnGetEditorCaption write FOnGetEditorCaption;
    property ReadOnly : Boolean
                   read FReadOnly write FReadOnly default False;
    property OnChanged : TNotifyEvent
                   read FOnChanged write FOnChanged;
    property OnItemSelected : TOvcItemSelectedEvent
                   read FOnItemSelected write FOnItemSelected;
  end;

  TOvcCollectionStreamer = class
  protected {private}
    FCollectionList : TList;
    FOwner          : TComponent;

  protected
    procedure Loaded;
    procedure GetChildren(Proc: TGetChildProc; Root : TComponent);

  public
    constructor Create(AOwner : TComponent);
    destructor Destroy;
      override;

    procedure Clear;
    function CollectionFromType(Component : TComponent) : TOvcCollection;

    property Owner : TComponent
      read FOwner;
  end;


type
  {base class for Orpheus components. Provides controller access}
  TOvcCustomControlEx = class(TOvcCustomControl)
  protected {private}
    FController : TOvcController;

    function ControllerAssigned : Boolean;
    function GetController: TOvcController;
    procedure SetController(Value : TOvcController); virtual;

  protected
    procedure CreateWnd;
      override;
    procedure Notification(AComponent : TComponent; Operation : TOperation);
      override;

  public
    property Controller : TOvcController
      read GetController
      write SetController;
  end;

  TOvcPopupWindow = class(TCustomForm)
  private
    FPrevActiveWindow: HWND;
    FCloseAction: TCloseAction;
    FBorderStyle: TBorderStyle;
    FCancelled: Boolean;
    procedure SetCloseAction(const Value: TCloseAction);
    procedure SetBorderStyle(const Value: TBorderStyle);
  protected
    procedure Deactivate; override;
    procedure InitializeNewForm; override;
    procedure DoClose(var Action: TCloseAction); override;
    procedure CreateParams(var Params: TCreateParams); override;
  public
    procedure WMActivate(var Message: TWMActivate); message WM_ACTIVATE;
    procedure WMActivateApp(var Message: TWMActivateApp); message WM_ACTIVATEAPP;
    procedure Popup(P: TPoint);
    function IsShortCut(var Message: TWMKey): Boolean; override;
    constructor Create(AOwner: TComponent); override;
    property CloseAction: TCloseAction read FCloseAction write SetCloseAction;
  published
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle default bsSingle;
    property OnClose;
    property Cancelled: Boolean read FCancelled;
    property Visible;
  end;


function FindController(Form : TWinControl) : TOvcController;
  {-search for an existing controller component}
function GetImmediateParentForm(Control : TControl) : TWinControl;
  {-return first form found while searching Parent}
procedure ResolveController(AForm : TWinControl; var AController : TOvcController);
  {-find or create a controller on this form}

function DefaultController : TOvcController;

implementation

{.$DEFINE Logging}
uses
  Graphics,
  OvcVer,
  TypInfo,
  ExtCtrls,
  Consts,
  OvcEF
  {$IFDEF Logging}
  ,LogAPI
  {$ENDIF}
  ;

type
  TLocalEF = class(TOvcBaseEntryField);
var
  FDefaultController : TOvcController = nil;

{===== TO32ContainerList =============================================}

constructor TO32ContainerList.Create(AOwner: TComponent);
begin
  inherited Create;
  FOwner := TComponent(AOwner);
end;
{=====}

destructor TO32ContainerList.Destroy;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    TPanel(Items[I]).Free;
  inherited;
end;


{*** TOvcLabelInfo ***}

procedure TOvcLabelInfo.DoOnAttach;
begin
  if Assigned(FOnAttach) then
    FOnAttach(Self, FVisible);
end;

procedure TOvcLabelInfo.DoOnChange;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

function TOvcLabelInfo.IsVisible : Boolean;
begin
  Result := FVisible;
end;

procedure TOvcLabelInfo.SetOffsets(X, Y : Integer);
begin
  if (X <> FOffsetX) or (Y <> FOffsetY) then begin
    FOffsetX := X;
    FOffsetY := Y;
    DoOnChange;
  end;
end;

procedure TOvcLabelInfo.SetOffsetX(Value : Integer);
begin
  if Value <> FOffsetX then begin
    FOffsetX := Value;
    DoOnChange;
  end;
end;

procedure TOvcLabelInfo.SetOffsetY(Value : Integer);
begin
  if Value <> FOffsetY then begin
    FOffsetY := Value;
    DoOnChange;
  end;
end;

procedure TOvcLabelInfo.SetVisible(Value : Boolean);
begin
  if Value <> FVisible then begin
    FVisible := Value;
    DoOnAttach;
  end;
end;


{*** TOvcAttachedLabel ***}

constructor TOvcAttachedLabel.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  {set new defaults}
  AutoSize    := True;
  ParentFont  := True;
  Transparent := False;
end;

constructor TOvcAttachedLabel.CreateEx(AOwner : TComponent; AControl : TWinControl);
begin
  FControl := AControl;

  Create(AOwner);

  {set attached control property}
  FocusControl := FControl;
end;

procedure TOvcAttachedLabel.Loaded;
begin
  inherited Loaded;

  SavePosition;
end;

procedure TOvcAttachedLabel.SavePosition;
var
  PF : TWinControl;
  I  : Integer;
begin
  if (csLoading in ComponentState) or (csDestroying in ComponentState) then
    Exit;

  {see if our associated control is on the form - save position}
  PF := GetImmediateParentForm(Self);
  if Assigned(PF) then begin
    for I := 0 to Pred(PF.ComponentCount) do begin
      if PF.Components[I] = FControl then begin
        SendMessage(FControl.Handle, OM_ASSIGNLABEL, 0, NativeInt(Self));
        PostMessage(FControl.Handle, OM_RECORDLABELPOSITION, 0, 0);
        Break;
      end;
    end;
  end;
end;

procedure TOvcAttachedLabel.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  SavePosition;

  { The following line causes the IDE to mark the form dirty, requiring it }
  { to be saved.  Not sure what this was supposed to do, but commenting it }
  { out seems to solve the problem. }
  {Application.ProcessMessages;}
end;

function FindController(Form : TWinControl) : TOvcController;
  {-search for an existing controller component}
var
  I : Integer;
begin
  Result := nil;
  for I := 0 to Form.ComponentCount-1 do begin
    if Form.Components[I] is TOvcController then begin
      Result := TOvcController(Form.Components[I]);
      Break;
    end;
  end;
end;

function GetImmediateParentForm(Control : TControl) : TWinControl;
  {return first form found while searching Parent}
var
  ParentCtrl : TControl;
begin
  ParentCtrl := Control.Parent;
  while Assigned(ParentCtrl) and
    not ((ParentCtrl is TCustomForm) or
         (ParentCtrl is TCustomFrame)) do
    ParentCtrl := ParentCtrl.Parent;
  Result := TWinControl(ParentCtrl);
end;

procedure ResolveController(AForm : TWinControl; var AController : TOvcController);
  {-find or create a controller on this form}
begin
  if not Assigned(AController) then begin
    {search for an existing controller. If not found,}
    {create the controller as a child of the form}
    {and assign it as our controller}
    AController := FindController(AForm);
    (*
    if not Assigned(AController) then begin
      AController := TOvcController.Create(AForm);
      try
        AController.Name := 'OvcController1';
      except
        AController.Free;
        AController := nil;
        raise;
      end;
    end;
    *)
  end;
end;

{*** TOvcComponent ***}

constructor TOvcComponent.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TOvcComponent.Destroy;
begin
  FCollectionStreamer.Free;
  FCollectionStreamer := nil;

  inherited Destroy;
end;

function TOvcComponent.GetAbout : string;
begin
  Result := OrVersionStr;
end;

procedure TOvcComponent.SetAbout(const Value : string);
begin
end;


{Logic for streaming collections of sub-components}

function TOvcComponent.GetChildOwner: TComponent;
begin
  if assigned(FCollectionStreamer) then
    Result := FCollectionStreamer.Owner
  else
    Result := inherited GetChildOwner;
end;

procedure TOvcComponent.GetChildren(Proc: TGetChildProc; Root : TComponent);
begin
  if assigned(FCollectionStreamer) then
    CollectionStreamer.GetChildren(Proc, Root)
  else
    inherited GetChildren(Proc,Root);
end;

procedure TOvcComponent.Loaded;
begin
  if assigned(FCollectionStreamer) then
    FCollectionStreamer.Loaded;

  inherited Loaded;
end;

{*** TO32Component ***}
constructor TO32Component.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

function TO32Component.GetAbout : string;
begin
  Result := OrVersionStr;
end;

procedure TO32Component.SetAbout(const Value : string);
begin
end;


{*** TOvcCollectible ***}
constructor TOvcCollectible.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  if (AOwner is TOvcComponent) then begin
    if TOvcComponent(AOwner).CollectionStreamer = nil then
      raise Exception.Create(GetOrphStr(SCNoCollection));
    SetCollection(TOvcComponent(AOwner).CollectionStreamer.CollectionFromType(Self));
  end else
  if (AOwner is TOvcCustomControl) then begin
    if TOvcCustomControl(AOwner).CollectionStreamer = nil then
      raise Exception.Create(GetOrphStr(SCNoCollection));
    SetCollection(TOvcCustomControl(AOwner).CollectionStreamer.CollectionFromType(Self));
  end else
    raise Exception.Create(GetOrphStr(SCNotOvcDescendant));

  if (csDesigning in ComponentState)
  and (AOwner <> nil) then
    if ((AOwner is TOvcComponent) and not TOvcComponent(AOwner).FInternal)
    or ((AOwner is TOvcCollectibleControl) and not TOvcCollectibleControl(AOwner).FInternal)
    or ((AOwner is TOvcCustomControl) and not TOvcCustomControl(AOwner).FInternal) then
      if not (csLoading in AOwner.ComponentState) then
        Name := GenerateName;
end;

destructor TOvcCollectible.Destroy;
var
  OldCollection : TOvcCollection;
begin
  OldCollection := Collection;
  SetCollection(nil);
  inherited Destroy;
  {mark dirty}
  if (csDesigning in ComponentState)
  and (OldCollection <> nil)
  and not (csDestroying in
    OldCollection.Owner.ComponentState) then begin
    OldCollection.Changed;
  end;
end;

function TOvcCollectible.GenerateName : string;
var
  PF : TWinControl;
  I  : Integer;
  S  : string;

  function SearchSubComponents(C : TComponent; const S : string) : TComponent;
  var
    I  : Integer;
  begin
    Result := C;
    if CompareText(S, Result.Name) = 0 then
      Exit;
    for I := 0 to C.ComponentCount-1 do begin
      Result := SearchSubComponents(C.Components[I], S);
      if Result <> nil then
        Exit;
    end;
    Result := nil;
  end;

  function FindComponentName(const S : string) : TComponent;
  begin
    Result := SearchSubComponents(PF, S);
  end;

begin
  I := 1;
  S := GetBaseName;
  Result := Format('%s%d', [S, I]);
  PF := Collection.ParentForm;
  if not Assigned(PF) then
    Exit;

  while FindComponentName(Result) <> nil do begin
    Inc(I);
    Result := Format('%s%d', [S, I]);
  end;
end;

procedure TOvcCollectible.SetName(const NewName : TComponentName);
begin
  inherited SetName(NewName);
  if not (csLoading in ComponentState) then
    if (csInLine in ComponentState) then
      Changed;
  if (Collection <> nil)
  and (Collection.ItemEditor <> nil) then
    SendMessage(Collection.ItemEditor.Handle, OM_PROPCHANGE, 0, 0);
end;

function TOvcCollectible.GetBaseName : string;
begin
  Result := 'CollectionItem';
end;

function TOvcCollectible.GetDisplayText : string;
begin
  Result := ClassName;
end;

procedure TOvcCollectible.Changed;
begin
  if InChanged then exit;
  InChanged := True;
  try
    {$IFDEF Logging}
    LogMsg('TOvcCollectible.Changed');
    LogBoolean('assigned(FCollection)', assigned(FCollection));
    LogBoolean('(csInline in ComponentState)', (csInline in ComponentState));
    LogBoolean('csAncestor in Owner.ComponentState', csAncestor in Owner.ComponentState);
    {$ENDIF}
    if assigned(FCollection) then
        if not (csInline in ComponentState) then
          FCollection.Changed;
  finally
    InChanged := False;
  end;
end;

function TOvcCollectible.GetIndex : Integer;
begin
  if assigned(FCollection) then
    Result := FCollection.FItems.IndexOf(Self)
  else
    Result := -1;
end;

procedure TOvcCollectible.SetIndex(Value : Integer);
begin
  if Value <> Index then begin
    if assigned(FCollection) then begin
      FCollection.FItems.Remove(Self);
      FCollection.FItems.Insert(Value,Self);
    end;
    Changed;
  end;
end;

procedure TOvcCollectible.SetCollection(Value : TOvcCollection);
begin
  if Collection <> Value then begin
    if Collection <> nil then
      Collection.FItems.Remove(Self);
    if Value <> nil then begin
      if not (Self is Value.ItemClass) then
        raise Exception.Create(GetOrphStr(SCItemIncompatible));
      Value.FItems.Add(Self);
    end;
    FCollection := Value;
  end;
end;



{===== TO32CollectionItem ============================================}

function TO32CollectionItem.GetAbout: String;
begin
  Result := OrVersionStr;
end;

procedure TO32CollectionItem.SetAbout(const Value: String);
begin
end;

procedure TO32CollectionItem.SetName(Value: String);
begin
  FName := Value;
end;
{=====}

{*** TOvcCollectibleControl ***}
constructor TOvcCollectibleControl.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  if (AOwner is TOvcComponent) then begin
    if TOvcComponent(AOwner).CollectionStreamer = nil then
      raise Exception.Create(GetOrphStr(SCNoCollection));
    SetCollection(TOvcComponent(AOwner).CollectionStreamer.CollectionFromType(Self));
  end else
  if (AOwner is TOvcCustomControl) then begin
    if TOvcCustomControl(AOwner).CollectionStreamer = nil then
      raise Exception.Create(GetOrphStr(SCNoCollection));
    SetCollection(TOvcCustomControl(AOwner).CollectionStreamer.CollectionFromType(Self));
  end else
    raise Exception.Create(GetOrphStr(SCNotOvcDescendant));

  if (csDesigning in ComponentState)
  and (AOwner <> nil) then
      if ((AOwner is TOvcComponent) and not TOvcComponent(AOwner).FInternal)
      or ((AOwner is TOvcCollectibleControl) and not TOvcCollectibleControl(AOwner).FInternal)
      or ((AOwner is TOvcCustomControl) and not TOvcCustomControl(AOwner).FInternal) then
        if not (csLoading in AOwner.ComponentState)
          and not (csInLine in AOwner.ComponentState)
          then Name := GenerateName;
end;

destructor TOvcCollectibleControl.Destroy;
var
  OldCollection : TOvcCollection;
begin
  OldCollection := Collection;
  SetCollection(nil);
  inherited Destroy;
  {mark dirty}
  if (csDesigning in ComponentState)
  and (OldCollection <> nil)
  and not (csDestroying in
    OldCollection.Owner.ComponentState) then begin
    OldCollection.Changed;
  end;
end;

function TOvcCollectibleControl.GenerateName : string;
var
  PF : TWinControl;
  I  : Integer;
  S  : string;

  function SearchSubComponents(C : TComponent; const S : string) : TComponent;
  var
    I  : Integer;
  begin
    Result := C;
    if CompareText(S, Result.Name) = 0 then
      Exit;
    for I := 0 to C.ComponentCount-1 do begin
      Result := SearchSubComponents(C.Components[I], S);
      if Result <> nil then
        Exit;
    end;
    Result := nil;
  end;

  function FindComponentName(const S : string) : TComponent;
  begin
    Result := SearchSubComponents(PF, S);
  end;

begin
  I := 1;
  S := GetBaseName;
  Result := Format('%s%d', [S, I]);
  PF := Collection.ParentForm;
  if not Assigned(PF) then
    Exit;

  while FindComponentName(Result) <> nil do begin
    Inc(I);
    Result := Format('%s%d', [S, I]);
  end;
end;

procedure TOvcCollectibleControl.SetName(const NewName : TComponentName);
begin
  inherited SetName(NewName);
  if not (csLoading in ComponentState) then
    if not (csInLine in ComponentState) then
      Changed;
end;

function TOvcCollectibleControl.GetBaseName : string;
begin
  Result := 'CollectionItem';
end;

function TOvcCollectibleControl.GetDisplayText : string;
begin
  Result := ClassName;
end;

procedure TOvcCollectibleControl.Changed;
begin
  if InChanged then exit;
  InChanged := True;
  try
    if assigned(FCollection) then
        if not (csInline in ComponentState) then
          FCollection.Changed;
  finally
    InChanged := False;
  end;
end;

function TOvcCollectibleControl.GetIndex : Integer;
begin
  if Collection <> nil then
    Result := Collection.FItems.IndexOf(Self)
  else
    Result := -1;
end;

procedure TOvcCollectibleControl.SetIndex(Value : Integer);
begin
  if Value <> Index then begin
    if Collection <> nil then begin
      Collection.FItems.Remove(Self);
      Collection.FItems.Insert(Value,Self);
    end;
    Changed;
  end;
end;

procedure TOvcCollectibleControl.SetCollection(Value : TOvcCollection);
begin
  if Collection <> Value then begin
    if Collection <> nil then
      Collection.FItems.Remove(Self);
    if Value <> nil then begin
      if not (Self is Value.ItemClass) then
        raise Exception.Create(GetOrphStr(SCItemIncompatible));
      Value.FItems.Add(Self);
    end;
    FCollection := Value;
  end;
end;

{*** TOvcController ***}
constructor TOvcController.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  {create the command processor}
  FEntryCommands := TOvcCommandProcessor.Create;
  FBaseEFOptions := [efoAutoSelect, efoBeepOnError, efoInsertPushes];
  FEpoch         := DefaultEpoch;
  FErrorPending  := False;
  FInsertMode    := True;

  {create the general use timer pool}
  FTimerPool     := TOvcTimerPool.Create(Self);
  FTimerPool.OnAllTriggers := DoOnTimerTrigger;
end;

procedure TOvcController.cWndProc(var Msg : TMessage);
  {-window procedure}
var
  C : TWinControl;
begin
  C := TWinControl(Msg.lParam);
  try
    with Msg do begin
      case Msg of
        OM_SETFOCUS :
          begin
            C.Show;
            if C.CanFocus then
              C.SetFocus;
          end;
        OM_PREEDIT :
          if Assigned(FOnPreEdit) then
            FOnPreEdit(TWinControl(lParam), FindControl(wParam));
        OM_POSTEDIT :
          if Assigned(FOnPostEdit) then
            FOnPostEdit(TWinControl(lParam), FindControl(wParam));
        OM_DELAYNOTIFY :
          if Assigned(FOnDelayNotify) then
            FOnDelayNotify(TObject(lParam), wParam);
      else
        Result := DefWindowProc(Handle, Msg, wParam, lParam);
      end;
    end;
  except
    Application.HandleException(Self);
  end;
end;

procedure TOvcController.DelayNotify(Sender : TObject; NotifyCode : Word);
begin
  if Assigned(FOnDelayNotify) then
    PostMessage(Handle, OM_DELAYNOTIFY, NotifyCode, NativeInt(Sender));
end;

destructor TOvcController.Destroy;
begin
  {destroy the command processor}
  FEntryCommands.Free;
  FEntryCommands := nil;

  FTimerPool.Free;
  FTimerPool := nil;

  {destroy window handle, if created}
  DestroyHandle;

  inherited Destroy;
end;

procedure TOvcController.DestroyHandle;
begin
  if FHandle <> 0 then
    Classes.DeallocateHWnd(FHandle);

  FHandle := 0;
end;

procedure TOvcController.DoOnError(Sender : TObject; ErrorCode : Word;
                         const ErrorMsg : string);
begin
  if Assigned(FOnError) then
    FOnError(Sender, ErrorCode, ErrorMsg)
  else
    MessageDlg(ErrorMsg, mtError, [mbOK], 0);
end;

procedure TOvcController.DoOnPostEdit(Sender : TObject; GainingControl : TWinControl);
var
  H : hWnd;
begin
  if Assigned(GainingControl) then
    H := GainingControl.Handle
  else
    H := 0;

  PostMessage(Handle, OM_POSTEDIT, H, NativeInt(Sender));
end;

procedure TOvcController.DoOnPreEdit(Sender : TObject; LosingControl : TWinControl);
var
  H : hWnd;
begin
  if Assigned(LosingControl) then
    H := LosingControl.Handle
  else
    H := 0;

  PostMessage(Handle, OM_PREEDIT, H, NativeInt(Sender));
end;

procedure TOvcController.DoOnTimerTrigger(Sender : TObject; Handle : Integer;
                         Interval : Cardinal; ElapsedTime : Integer);
begin
  if Assigned(FOnTimerTrigger) then
    FOnTimerTrigger(Sender, Handle, Interval, ElapsedTime);
end;

function TOvcController.GetEpoch : Integer;
begin
  Result := FEpoch;
  if Assigned(FOnGetEpoch) then
    FOnGetEpoch(Self, Result);
end;

{ - HWnd changed to TOvcHWnd for BCB Compatibility }
function TOvcController.GetHandle : TOvcHWnd{hWnd};
begin
  if FHandle = 0 then
    FHandle := Classes.AllocateHWnd(cWndProc);
  Result := FHandle;
end;

{ - HWnd changed to TOvcHWnd for BCB Compatibility }
function TOvcController.IsSpecialButton(H : TOvcHWnd{hWnd}) : Boolean;
begin
  Result := False;
  if Assigned(FOnIsSpecialControl) then
    FOnIsSpecialControl(Self, FindControl(H), Result);
end;

procedure TOvcController.MarkAsUninitialized(Uninitialized : Boolean);
  {-mark all entry fields on form as uninitialized}
var
  I  : Integer;

  procedure MarkField(C : TComponent);
  var
    J : Integer;
  begin
    {first, see if this component is an entry field}
    if C is TOvcBaseEntryField then
      TOvcBaseEntryField(C).Uninitialized := Uninitialized;

    {recurse through all child components}
    for J := 0 to C.ComponentCount-1 do
      MarkField(C.Components[J]);
  end;

begin
  if (Owner is TCustomForm) or (Owner is TCustomFrame) then
    with TWinControl(Owner) do
      for I := 0 to ComponentCount-1 do
        MarkField(Components[I]);
end;

procedure TOvcController.SetEpoch(Value : Integer);
begin
  if Value <> FEpoch then
    if (Value >= MinYear) and (Value <= MaxYear) then
      FEpoch := Value;
end;

function TOvcController.ValidateEntryFields : TComponent;
begin
  {if error, report it and send focus to field with error}
  Result := ValidateEntryFieldsEx(True, True);
end;

function TOvcController.ValidateEntryFieldsEx(ReportError, ChangeFocus : Boolean) : TComponent;
var
  I  : Integer;

  procedure ValidateEF(C : TComponent);
  var
    J  : Integer;
    EF : TLocalEF absolute C;
  begin
    {see if this component is an entry field}
    if (C is TOvcBaseEntryField) then begin

      {don't validate invisible or disabled fields}
      if not EF.Visible or not EF.Enabled then
        Exit;

      {ask entry field to validate itself}
      if (EF.ValidateContents(False) <> 0) then begin
        {remember only the first invalid field found}
        if not Assigned(Result) then
          Result := EF;

        {tell the entry field to report the error}
        if ReportError and not ErrorPending then
          PostMessage(EF.Handle, OM_REPORTERROR, EF.LastError, 0);

        {ask the controller to give the focus back to this field}
        if ChangeFocus and not ErrorPending then begin
          PostMessage(Handle, OM_SETFOCUS, 0, NativeInt(EF));
          ErrorPending := True;
        end;

        {exit if we are reporting the error or changing the focus}
        if (ReportError or ChangeFocus) then
          Exit;
      end;
    end;

    {recurse through all child components}
    for J := 0 to C.ComponentCount-1 do begin
      ValidateEf(C.Components[J]);

      {exit if we've already found an error and should stop}
      if Assigned(Result) and (ReportError or ChangeFocus) then
        Break;
    end;
  end;

begin
  Result := nil;
  if ((Owner is TCustomForm) or (Owner is TCustomFrame)) then
    with TWinControl(Owner) do
      for I := 0 to ComponentCount-1 do begin
        ValidateEf(Components[I]);

        {stop checking if reporting the error or changing focus}
        if Assigned(Result) and (ReportError or ChangeFocus) then
          Break ;
      end;
end;

function TOvcController.ValidateTheseEntryFields(const Fields : array of TComponent) : TComponent;
  {-ask the specified entry fields to validate their contents. Return nil
    if no error, else return pointer to field with error}
var
  I  : Integer;
  EF : TLocalEF;
begin
  Result := nil;

  for I := Low(Fields) to High(Fields) do begin
    if Fields[I] is TOvcBaseEntryField then begin
      EF := TLocalEF(Fields[I]);

      {ask entry field to validate itself}
      if (EF.ValidateContents(False) <> 0) then begin
        Result := EF;

        {tell the entry field to report the error}
        if not ErrorPending then
          PostMessage(EF.Handle, OM_REPORTERROR, EF.LastError, 0);

        {ask the controller to give the focus back to this field}
        if not ErrorPending then begin
          PostMessage(Handle, OM_SETFOCUS, 0, NativeInt(EF));
          ErrorPending := True;
        end;

        Exit;
      end;

    end;
  end;
end;

{*** TOvcGraphicControl ***}

constructor TOvcGraphicControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TOvcGraphicControl.Destroy;
begin
  FCollectionStreamer.Free;
  FCollectionStreamer := nil;
  inherited Destroy;
end;


procedure TOvcGraphicControl.Loaded;
begin
  if Assigned(FCollectionStreamer) then
    FCollectionStreamer.Loaded;
  inherited Loaded;
end;

{Logic for streaming collections of sub-components}

function TOvcGraphicControl.GetChildOwner: TComponent;
begin
  if Assigned(FCollectionStreamer) then
    Result := FCollectionStreamer.Owner
  else
    Result := inherited GetChildOwner;
end;

procedure TOvcGraphicControl.GetChildren(Proc: TGetChildProc; Root : TComponent);
begin
  if Assigned(FCollectionStreamer) then
    CollectionStreamer.GetChildren(Proc, Root)
  else
    inherited GetChildren(Proc, Root);
end;

function TOvcGraphicControl.GetAbout : string;
begin
  Result := OrVersionStr;
end;


procedure TOvcGraphicControl.SetAbout(const Value : string);
begin
end;


{*** TO32CustomControl ***}

procedure TO32CustomControl.CMVisibleChanged(var Msg : TMessage);
begin
  inherited;

  if csLoading in ComponentState then
    Exit;

  if LabelInfo.Visible then
    AttachedLabel.Visible := Visible;
end;

constructor TO32CustomControl.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  DefaultLabelPosition := lpTopLeft;

  FLabelInfo := TOvcLabelInfo.Create;
  FLabelInfo.OnChange := LabelChange;
  FLabelInfo.OnAttach := LabelAttach;
end;

procedure TO32CustomControl.CreateWnd;
begin
  inherited CreateWnd;
end;

destructor TO32CustomControl.Destroy;
begin
  FLabelInfo.Visible := False;
  FLabelInfo.Free;
  FLabelInfo := nil;
  inherited Destroy;
end;

procedure TO32CustomControl.DoOnMouseWheel(Shift : TShiftState;
                                 Delta, XPos, YPos : SmallInt);
begin
  if Assigned(FOnMouseWheel) then
    FOnMouseWheel(Self, Shift, Delta, XPos, YPos);
end;

function TO32CustomControl.GetAttachedLabel : TOvcAttachedLabel;
begin
  if not FLabelInfo.Visible then
    raise Exception.Create(GetOrphStr(SCLabelNotAttached));

  Result := FLabelInfo.ALabel;
end;

function TO32CustomControl.GetAbout : string;
begin
  Result := OrVersionStr;
end;

procedure TO32CustomControl.LabelAttach(Sender : TObject; Value : Boolean);
var
  PF : TWinControl;
  S  : string;
begin
  if (csLoading in ComponentState) then
    Exit;

  PF := GetImmediateParentForm(Self);
  if Value then begin
    if Assigned(PF) then begin
      FLabelInfo.ALabel.Free;
      FLabelInfo.ALabel := TOvcAttachedLabel.CreateEx(PF, Self);
      FLabelInfo.ALabel.Parent := Parent;

      S := GenerateComponentName(PF, Name + 'Label');
      FLabelInfo.ALabel.Name := S;
      FLabelInfo.ALabel.Caption := S;

      FLabelInfo.SetOffsets(0, 0);
      PositionLabel;
      FLabelInfo.ALabel.BringToFront;

      {force auto size}
      FLabelInfo.ALabel.AutoSize := True;
    end;
  end else begin
    if Assigned(PF) then begin
      FLabelInfo.ALabel.Free;
      FLabelInfo.ALabel := nil;
    end;
  end;
end;

procedure TO32CustomControl.LabelChange(Sender : TObject);
begin
  if not (csLoading in ComponentState) then
    PositionLabel;
end;

procedure TO32CustomControl.Notification(AComponent : TComponent; Operation : TOperation);
var
  PF : TWinControl;
begin
  inherited Notification(AComponent, Operation);

  if Operation = opRemove then
    if Assigned(FLabelInfo) and (AComponent = FLabelInfo.ALabel) then begin
      PF := GetImmediateParentForm(Self);
      if Assigned(PF) and not (csDestroying in PF.ComponentState) then begin
        FLabelInfo.FVisible := False;
        FLabelInfo.ALabel := nil;
      end;
    end;
end;

procedure TO32CustomControl.OMAfterEnter(var Msg : TMessage);
begin
  if Assigned(FAfterEnter) then
    FAfterEnter(Self);
end;

procedure TO32CustomControl.OMAfterExit(var Msg : TMessage);
begin
  if Assigned(FAfterExit) then
    FAfterExit(Self);
end;

procedure TO32CustomControl.OMAssignLabel(var Msg : TMessage);
begin
  FLabelInfo.ALabel := TOvcAttachedLabel(Msg.lParam);
end;

procedure TO32CustomControl.OMPositionLabel(var Msg : TMessage);
const
  DX : Integer = 0;
  DY : Integer = 0;
begin
  if FLabelInfo.Visible and
     Assigned(FLabelInfo.ALabel) and
     (FLabelInfo.ALabel.Parent <> nil) and
     not (csLoading in ComponentState) then begin
    if DefaultLabelPosition = lpTopLeft then begin
      DX := FLabelInfo.ALabel.Left - Left;
      DY := FLabelInfo.ALabel.Top + FLabelInfo.ALabel.Height - Top;
    end else begin
      DX := FLabelInfo.ALabel.Left - Left;
      DY := FLabelInfo.ALabel.Top - Top - Height;
    end;
    if (DX <> FLabelInfo.OffsetX) or (DY <> FLabelInfo.OffsetY) then
      PositionLabel;
  end;
end;

procedure TO32CustomControl.OMRecordLabelPosition(var Msg : TMessage);
begin
  if Assigned(FLabelInfo.ALabel) and
     (FLabelInfo.ALabel.Parent <> nil) then begin
    {if the label was cut and then pasted, this will complete the re-attachment}
    FLabelInfo.FVisible := True;

    if DefaultLabelPosition = lpTopLeft then
      FLabelInfo.SetOffsets(FLabelInfo.ALabel.Left - Left,
        FLabelInfo.ALabel.Top + FLabelInfo.ALabel.Height - Top)
    else
      FLabelInfo.SetOffsets(FLabelInfo.ALabel.Left - Left,
        FLabelInfo.ALabel.Top - Top - Height);
  end;
end;

procedure TO32CustomControl.PositionLabel;
begin
  if FLabelInfo.Visible and Assigned(FLabelInfo.ALabel) and
                           (FLabelInfo.ALabel.Parent <> nil) and
                           not (csLoading in ComponentState) then begin

    if DefaultLabelPosition = lpTopLeft then begin
      FLabelInfo.ALabel.SetBounds(Left + FLabelInfo.OffsetX,
                         FLabelInfo.OffsetY - FLabelInfo.ALabel.Height + Top,
                         FLabelInfo.ALabel.Width, FLabelInfo.ALabel.Height);
    end else begin
      FLabelInfo.ALabel.SetBounds(Left + FLabelInfo.OffsetX,
                         FLabelInfo.OffsetY + Top + Height,
                         FLabelInfo.ALabel.Width, FLabelInfo.ALabel.Height);
    end;
  end;
end;

procedure TO32CustomControl.SetBounds(ALeft, ATop, AWidth, AHeight : Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);

  if HandleAllocated then
    PostMessage(Handle, OM_POSITIONLABEL, 0, 0);
end;

procedure TO32CustomControl.SetAbout(const Value : string);
begin
end;

procedure TO32CustomControl.WMKillFocus(var Msg : TWMKillFocus);
begin
  inherited;

  PostMessage(Handle, OM_AFTEREXIT, 0, 0);
end;

procedure TO32CustomControl.WMMouseWheel(var Msg : TMessage);
begin
  with Msg do
    DoOnMouseWheel(KeysToShiftState(LOWORD(wParam)) {fwKeys},
                   HIWORD(wParam) {zDelta},
                   LOWORD(lParam) {xPos},   HIWORD(lParam) {yPos});
end;

procedure TO32CustomControl.WMSetFocus(var Msg : TWMSetFocus);
begin
  inherited;

  PostMessage(Handle, OM_AFTERENTER, 0, 0);
end;

{*** End - TO32CustomCOntrol ***}


{*** TOvcCustomControl ***}
procedure TOvcCustomControl.CMVisibleChanged(var Msg : TMessage);
begin
  inherited;

  if csLoading in ComponentState then
    Exit;

  if LabelInfo.Visible then
    AttachedLabel.Visible := Visible;
end;

constructor TOvcCustomControl.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  DefaultLabelPosition := lpTopLeft;

  FLabelInfo := TOvcLabelInfo.Create;
  FLabelInfo.OnChange := LabelChange;
  FLabelInfo.OnAttach := LabelAttach;
end;

procedure TOvcCustomControl.CreateWnd;
begin
  inherited CreateWnd;
end;

destructor TOvcCustomControl.Destroy;
begin
  FLabelInfo.Visible := False;
  FLabelInfo.Free;
  FLabelInfo := nil;
  FCollectionStreamer.Free;
  FCollectionStreamer := nil;
  inherited Destroy;
end;

procedure TOvcCustomControl.DoOnMouseWheel(Shift : TShiftState;
                                 Delta, XPos, YPos : SmallInt);
begin
  if Assigned(FOnMouseWheel) then
    FOnMouseWheel(Self, Shift, Delta, XPos, YPos);
end;

function TOvcCustomControl.GetAttachedLabel : TOvcAttachedLabel;
begin
  if not FLabelInfo.Visible then
    raise Exception.Create(GetOrphStr(SCLabelNotAttached));

  Result := FLabelInfo.ALabel;
end;

function TOvcCustomControl.GetAbout : string;
begin
  Result := OrVersionStr;
end;

procedure TOvcCustomControl.LabelAttach(Sender : TObject; Value : Boolean);
var
  PF : TWinControl;
  S  : string;
begin
  if (csLoading in ComponentState) then
    Exit;

  PF := GetImmediateParentForm(Self);
  if Value then begin
    if Assigned(PF) then begin
      FLabelInfo.ALabel.Free;
      FLabelInfo.ALabel := TOvcAttachedLabel.CreateEx(PF, Self);
      FLabelInfo.ALabel.Parent := Parent;

      S := GenerateComponentName(PF, Name + 'Label');
      FLabelInfo.ALabel.Name := S;
      FLabelInfo.ALabel.Caption := S;

      FLabelInfo.SetOffsets(0, 0);
      PositionLabel;
      FLabelInfo.ALabel.BringToFront;

      {force auto size}
      FLabelInfo.ALabel.AutoSize := True;
    end;
  end else begin
    if Assigned(PF) then begin
      FLabelInfo.ALabel.Free;
      FLabelInfo.ALabel := nil;
    end;
  end;
end;

procedure TOvcCustomControl.LabelChange(Sender : TObject);
begin
  if not (csLoading in ComponentState) then
    PositionLabel;
end;

procedure TOvcCustomControl.Notification(AComponent : TComponent; Operation : TOperation);
var
  PF : TWinControl;
begin
  inherited Notification(AComponent, Operation);

  if Operation = opRemove then
    if Assigned(FLabelInfo) and (AComponent = FLabelInfo.ALabel) then begin
      PF := GetImmediateParentForm(Self);
      if Assigned(PF) and not (csDestroying in PF.ComponentState) then begin
        FLabelInfo.FVisible := False;
        FLabelInfo.ALabel := nil;
      end;
    end;
end;

procedure TOvcCustomControl.OMAfterEnter(var Msg : TMessage);
begin
  if Assigned(FAfterEnter) then
    FAfterEnter(Self);
end;

procedure TOvcCustomControl.OMAfterExit(var Msg : TMessage);
begin
  if Assigned(FAfterExit) then
    FAfterExit(Self);
end;

procedure TOvcCustomControl.OMAssignLabel(var Msg : TMessage);
begin
  FLabelInfo.ALabel := TOvcAttachedLabel(Msg.lParam);
end;

procedure TOvcCustomControl.OMPositionLabel(var Msg : TMessage);
const
  DX : Integer = 0;
  DY : Integer = 0;
begin
  if FLabelInfo.Visible and
     Assigned(FLabelInfo.ALabel) and
     (FLabelInfo.ALabel.Parent <> nil) and
     not (csLoading in ComponentState) then begin
    if DefaultLabelPosition = lpTopLeft then begin
      DX := FLabelInfo.ALabel.Left - Left;
      DY := FLabelInfo.ALabel.Top + FLabelInfo.ALabel.Height - Top;
    end else begin
      DX := FLabelInfo.ALabel.Left - Left;
      DY := FLabelInfo.ALabel.Top - Top - Height;
    end;
    if (DX <> FLabelInfo.OffsetX) or (DY <> FLabelInfo.OffsetY) then
      PositionLabel;
  end;
end;

procedure TOvcCustomControl.OMRecordLabelPosition(var Msg : TMessage);
begin
  if Assigned(FLabelInfo.ALabel) and
     (FLabelInfo.ALabel.Parent <> nil) then begin
    {if the label was cut and then pasted, this will complete the re-attachment}
    FLabelInfo.FVisible := True;

    if DefaultLabelPosition = lpTopLeft then
      FLabelInfo.SetOffsets(FLabelInfo.ALabel.Left - Left,
        FLabelInfo.ALabel.Top + FLabelInfo.ALabel.Height - Top)
    else
      FLabelInfo.SetOffsets(FLabelInfo.ALabel.Left - Left,
        FLabelInfo.ALabel.Top - Top - Height);
  end;
end;

procedure TOvcCustomControl.PositionLabel;
begin
  if FLabelInfo.Visible and Assigned(FLabelInfo.ALabel) and
                           (FLabelInfo.ALabel.Parent <> nil) and
                           not (csLoading in ComponentState) then begin

    if DefaultLabelPosition = lpTopLeft then begin
      FLabelInfo.ALabel.SetBounds(Left + FLabelInfo.OffsetX,
                         FLabelInfo.OffsetY - FLabelInfo.ALabel.Height + Top,
                         FLabelInfo.ALabel.Width, FLabelInfo.ALabel.Height);
    end else begin
      FLabelInfo.ALabel.SetBounds(Left + FLabelInfo.OffsetX,
                         FLabelInfo.OffsetY + Top + Height,
                         FLabelInfo.ALabel.Width, FLabelInfo.ALabel.Height);
    end;
  end;
end;

procedure TOvcCustomControl.SetBounds(ALeft, ATop, AWidth, AHeight : Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);

  if HandleAllocated then
    PostMessage(Handle, OM_POSITIONLABEL, 0, 0);
end;

procedure TOvcCustomControl.SetAbout(const Value : string);
begin
end;

procedure TOvcCustomControl.WMKillFocus(var Msg : TWMKillFocus);
begin
  inherited;

  PostMessage(Handle, OM_AFTEREXIT, 0, 0);
end;

procedure TOvcCustomControl.WMMouseWheel(var Msg : TMessage);
begin
  with Msg do
    DoOnMouseWheel(KeysToShiftState(LOWORD(wParam)) {fwKeys},
                   HIWORD(wParam) {zDelta},
                   LOWORD(lParam) {xPos},   HIWORD(lParam) {yPos});
end;

procedure TOvcCustomControl.WMSetFocus(var Msg : TWMSetFocus);
begin
  inherited;

  PostMessage(Handle, OM_AFTERENTER, 0, 0);
end;


{Logic for streaming collections of sub-components}

function TOvcCustomControl.GetChildOwner: TComponent;
begin
  if Assigned(FCollectionStreamer) then
    Result := FCollectionStreamer.Owner
  else
    Result := inherited GetChildOwner;
end;

procedure TOvcCustomControl.GetChildren(Proc: TGetChildProc; Root : TComponent);
begin
  if Assigned(FCollectionStreamer) then
    CollectionStreamer.GetChildren(Proc, Root)
  else
    inherited GetChildren(Proc, Root);
end;

procedure TOvcCustomControl.Loaded;
begin
  if Assigned(FCollectionStreamer) then
    FCollectionStreamer.Loaded;
  inherited Loaded;
end;

{*** TOvcCustomControlEx ***}

function TOvcCustomControlEx.ControllerAssigned : Boolean;
begin
  Result := Assigned(FController);
end;

procedure TOvcCustomControlEx.CreateWnd;
var
  OurForm : TWinControl;

begin
  OurForm := GetImmediateParentForm(Self);

  {do this only when the component is first dropped on the form, not during loading}
  if (csDesigning in ComponentState) and not (csLoading in ComponentState) then
    ResolveController(OurForm, FController);

  if not Assigned(FController) and not (csLoading in ComponentState) then begin
    {try to find a controller on this form that we can use}
    FController := FindController(OurForm);

    {if not found and we are not designing, use default controller}
    if not Assigned(FController) and not (csDesigning in ComponentState) then
      FController := DefaultController;
  end;

  inherited CreateWnd;
end;

function TOvcCustomControlEx.GetController: TOvcController;
begin
  if FController = nil then
    Result := DefaultController
  else
    Result := FController;
end;

procedure TOvcCustomControlEx.Notification(AComponent : TComponent; Operation : TOperation);
begin
  inherited Notification(AComponent, Operation);

  if Operation = opRemove then begin
    if (AComponent = FController) then
      FController := nil;
  end else if (Operation = opInsert) and (FController = nil) and
              (AComponent is TOvcController) then
    FController := TOvcController(AComponent);
end;

procedure TOvcCustomControlEx.SetController(Value : TOvcController);
begin
  if not (TObject(Value) is TOvcController) then
    Value := nil;
  FController := Value;
  if Value <> nil then
    Value.FreeNotification(Self);
end;

function TOvcCollection.Add : TComponent;
begin
  if not Assigned(FItemClass) then
    raise Exception.Create(GetOrphStr(SCClassNotSet));
  Result := FItemClass.Create(Owner);
  Changed;
  if ItemEditor <> nil then
    SendMessage(ItemEditor.Handle, OM_PROPCHANGE, 0, 0);
end;

procedure TOvcCollection.Changed;
var
  Parent : TForm;
begin
  {$IFDEF Logging}
  LogMsg('TOvcCollection.Changed');
  LogBoolean('InChanged', InChanged);
  {$ENDIF}
  if InChanged then exit;
  InChanged := True;
  try
    Parent := ParentForm;
    if Parent <> nil then begin
      {$IFDEF Logging}
      LogString('Parent.ClassName', Parent.ClassName);
      LogBoolean('(csLoading in Parent.ComponentState)', (csLoading in Parent.ComponentState));
      {$ENDIF}
      if not (csLoading in Parent.ComponentState)
      and (csDesigning in Parent.ComponentState) then begin
        {$IFDEF Logging}
        LogBoolean('TForm(Parent).Designer <> nil', TForm(Parent).Designer <> nil);
        LogBoolean('InLoaded', InLoaded);
        LogBoolean('IsLoaded', IsLoaded);
        LogBoolean('(csAncestor in Owner.ComponentState)', (csAncestor in Owner.ComponentState));
        LogBoolean('Stored', Stored);
        {$ENDIF}
        if (TForm(Parent).Designer <> nil)
        and not InLoaded
        and IsLoaded
        and not (csAncestor in Owner.ComponentState)
        and Stored then
          TForm(Parent).Designer.Modified;
        if (ItemEditor <> nil)
        and not (csAncestor in Owner.ComponentState)
        then
          SendMessage(ItemEditor.Handle, OM_PROPCHANGE, 0, 0);
      end;
      if Assigned(FOnChanged) then
        FOnChanged(Self);
    end;
  finally
    InChanged := False;
  end;
end;

procedure TOvcCollection.Clear;
var
  i : Integer;
begin
  for i := Count - 1 downto 0 do
    if not (csAncestor in Item[i].ComponentState) then
      Item[i].Free;
  while Count > 0 do
    Item[0].Free;
  if ItemEditor <> nil then
    SendMessage(ItemEditor.Handle, OM_PROPCHANGE, 0, 0);
end;

constructor TOvcCollection.Create(AOwner : TComponent;
                                  ItemClass : TOvcCollectibleClass);
begin
  inherited Create;
  FStored := True;
  FItemClass := ItemClass;
  FItems := TList.Create;
  FOwner := AOwner;

  if (AOwner is TOvcComponent) then
    begin
      if TOvcComponent(AOwner).CollectionStreamer = nil then
        TOvcComponent(AOwner).CollectionStreamer := TOvcCollectionStreamer.Create(AOwner);
      FStreamer := TOvcComponent(AOwner).CollectionStreamer;
      FStreamer.FCollectionList.Add(Self);
    end
  else
  if (AOwner is TOvcCustomControl) then
    begin
      if TOvcCustomControl(AOwner).CollectionStreamer = nil then
        TOvcCustomControl(AOwner).CollectionStreamer := TOvcCollectionStreamer.Create(AOwner);
      FStreamer := TOvcCustomControl(AOwner).CollectionStreamer;
      FStreamer.FCollectionList.Add(Self);
    end
  else
    raise Exception.Create(GetOrphStr(SCNotOvcDescendant));
end;

procedure TOvcCollection.Delete(Index : Integer);
begin
  if (Index > -1) and (Index < Count) then
    Item[Index].Free;
  Changed;
end;

destructor TOvcCollection.Destroy;
begin
  ItemEditor.Free;
  if (Owner is TOvcComponent) then
    TOvcComponent(Owner).CollectionStreamer.FCollectionList.Remove(Self)
  else
    TOvcCustomControl(Owner).CollectionStreamer.FCollectionList.Remove(Self);
  Clear;
  FItems.Free;
  inherited Destroy;
end;

procedure TOvcCollection.DoOnItemSelected(Index : Integer);
begin
  if Assigned(FOnItemSelected) then
    FOnItemSelected(Self, Index);
end;

function TOvcCollection.GetCount : Integer;
begin
  Result := FItems.Count;
end;

function TOvcCollection.GetEditorCaption : string;
begin
  Result := 'Editing ' + ClassName;
  if Assigned(FOnGetEditorCaption) then
    FOnGetEditorCaption(Result);
end;

function TOvcCollection.GetItem(Index : Integer) : TComponent;
begin
  Result := TComponent(FItems[Index]);
end;

function TOvcCollection.Insert(Index : Integer) : TComponent;
begin
  if (Index < 0) or (Index > Count) then
    Index := Count;
  Result := Add;
  if Result is TOvcCollectible then
    TOvcCollectible(Item[Count-1]).Index := Index
  else
  if Result is TOvcCollectibleControl then
    TOvcCollectibleControl(Item[Count-1]).Index := Index
  else
    Result := nil;
end;

function TOvcCollection.ItemByName(const Name : string) : TComponent;
var
  i : Integer;
begin
  for i := 0 to pred(Count) do
    if Item[i].Name = Name then begin
      Result := Item[i];
      exit;
    end;
  Result := nil;
end;

procedure TOvcCollection.Loaded;
begin
  InLoaded := True;
  try
    Changed;
  finally
    InLoaded := False;
  end;
  IsLoaded := True;
end;

function TOvcCollection.ParentForm : TForm;
var
  Temp : TObject;
begin
  Temp := Owner;
  while (Temp <> nil) and not (Temp is TForm) do
    Temp := TComponent(Temp).Owner;
  Result := TForm(Temp);
end;

procedure TOvcCollection.SetItem(Index : Integer; Value : TComponent);
begin
  TOvcCollectible(FItems[Index]).Assign(Value);
end;

procedure TOvcCollectionStreamer.Clear;
var
  I : Integer;
begin
  for I := 0 to pred(FCollectionList.Count) do
    TOvcCollection(FCollectionList[I]).Clear;
end;


{===== TO32Collection ================================================}

constructor TO32Collection.Create(AOwner : TPersistent;
                                  ItemClass : TCollectionItemClass);
begin
  FOwner := AOwner;
  Inherited Create(ItemClass);
end;

destructor TO32Collection.Destroy;
begin
  ItemEditor.Free;
  Clear;
  inherited Destroy;
end;

procedure TO32Collection.DoOnItemSelected(Index : Integer);
begin
  if Assigned(FOnItemSelected) then
    FOnItemSelected(Self, Index);
end;

function TO32Collection.GetCount : Integer;
begin
  Result := inherited Count;
end;

function TO32Collection.GetEditorCaption : string;
begin
  Result := 'Editing ' + ClassName;
  if Assigned(FOnGetEditorCaption) then
    FOnGetEditorCaption(Result);
end;

function TO32Collection.Add : TO32CollectionItem;
begin
  Result := TO32CollectionItem(inherited Add);
  if ItemEditor <> nil then
    SendMessage(ItemEditor.Handle, OM_PROPCHANGE, 0, 0);
end;

function TO32Collection.GetItem(Index : Integer) : TO32CollectionItem;
begin
  Result := TO32CollectionItem(inherited GetItem(Index));
end;

function TO32Collection.GetOwner: TPersistent;
begin
  result := FOwner;
end;

procedure TO32Collection.SetItem(Index : Integer; Value : TO32CollectionItem);
begin
  inherited SetItem(Index, Value);
end;

function TO32Collection.ItemByName(const Name : string) : TO32CollectionItem;
var
  i : Integer;
begin
  for i := 0 to pred(Count) do
    if Item[i].Name = Name then begin
      Result := Item[i];
      exit;
    end;
  Result := nil;
end;

procedure TO32Collection.Loaded;
begin
  InLoaded := True;
  try
    Changed;
  finally
    InLoaded := False;
  end;
  IsLoaded := True;
end;

function TO32Collection.ParentForm : TForm;
var
  Temp : TObject;
begin
  Temp := GetOwner;
  while (Temp <> nil) and not (Temp is TForm) do
    Temp := TComponent(Temp).Owner;
  Result := TForm(Temp);
end;

{End - TO32Collection }

{===== TOvcCollectionStreamer ========================================}
function TOvcCollectionStreamer.CollectionFromType(Component : TComponent) : TOvcCollection;
var
  I : Integer;
begin
  for I := 0 to pred(FCollectionList.Count) do
    if Component is TOvcCollection(FCollectionList[I]).ItemClass then begin
      Result := TOvcCollection(FCollectionList[I]);
      exit;
    end;
  raise Exception.Create(GetOrphStr(SCCollectionNotFound));
end;

constructor TOvcCollectionStreamer.Create(AOwner : TComponent);
begin
  inherited Create;

  FOwner := AOwner;
  FCollectionList := TList.Create;
end;

destructor TOvcCollectionStreamer.Destroy;
begin
  FCollectionList.Free;
  FCollectionList := nil;

  inherited Destroy;
end;

procedure TOvcCollectionStreamer.GetChildren(Proc: TGetChildProc; Root : TComponent);
var
  I,J: Integer;
begin
  for I := 0 to pred(FCollectionList.Count) do
    with TOvcCollection(FCollectionList[I]) do
      if Stored then
        for J := 0 to Count - 1 do
          Proc(Item[J]);
end;

procedure TOvcCollectionStreamer.Loaded;
var
  I : Integer;
begin
  for I := 0 to pred(FCollectionList.Count) do
    TOvcCollection(FCollectionList[I]).Loaded;
end;

function DefaultController : TOvcController;
begin
  if FDefaultController = nil then
    FDefaultController := TOvcController.Create(nil);
  Result := FDefaultController;
end;

{ TOvcPopupWindow }

constructor TOvcPopupWindow.Create(AOwner: TComponent);
begin
  inherited;
  FBorderStyle := bsSingle;
end;

procedure TOvcPopupWindow.CreateParams(var Params: TCreateParams);
begin
  inherited;
  with Params Do
  begin
    Style := WS_POPUP;
    if FBorderStyle = bsSingle then
    begin
      if CheckWin32Version(5, 1) then
        WindowClass.Style := WindowClass.Style or CS_DROPSHADOW;

        Style := Style + WS_POPUP;
    end;

    WindowClass.Style := WindowClass.Style or CS_SAVEBITS;
    if NewStyleControls then
      ExStyle := WS_EX_TOOLWINDOW;
    AddBiDiModeExStyle(ExStyle);
  end;
end;

procedure TOvcPopupWindow.Deactivate;
begin
  inherited;
  Close;
end;

procedure TOvcPopupWindow.DoClose(var Action: TCloseAction);
begin
  Action := FCloseAction;
  inherited DoClose(Action);
end;

procedure TOvcPopupWindow.InitializeNewForm;
begin
  inherited;
  BorderStyle := bsNone;
  Position := poDesigned;
  Color := clWindow;
  FCloseAction := caFree;
end;

function TOvcPopupWindow.IsShortCut(var Message: TWMKey): Boolean;
begin
  Result := False;
  if KeyboardStateToShiftState = [] then
    if Message.CharCode = VK_ESCAPE then
    begin
      FCancelled := True;
      Result := True;
      Close;
    end;
  if not Result then
    result := inherited IsShortCut(Message);
end;

procedure TOvcPopupWindow.Popup(P: TPoint);
begin
  Left := P.X;
  Top := P.Y;
  if Owner is TControl then
    PopupParent := GetParentForm(TControl(Owner));
  Show;
end;

procedure TOvcPopupWindow.SetBorderStyle(const Value: TBorderStyle);
begin
  FBorderStyle := Value;
end;

procedure TOvcPopupWindow.SetCloseAction(const Value: TCloseAction);
begin
  FCloseAction := Value;
end;

procedure TOvcPopupWindow.WMActivate(var Message: TWMActivate);
begin
  if Message.Active <> WA_INACTIVE then
  begin
    FPrevActiveWindow := Message.ActiveWindow;
    SendMessage(FPrevActiveWindow, WM_NCACTIVATE, WPARAM(True), 0);
  end;
end;

procedure TOvcPopupWindow.WMActivateApp(var Message: TWMActivateApp);
begin
  if not Message.Active then
  begin
    SendMessage(FPrevActiveWindow, WM_NCACTIVATE, WPARAM(False), 0);
    Close;
  end;
end;


initialization
  {register the attached label class}
  if Classes.GetClass(TOvcAttachedLabel.ClassName) = nil then
    Classes.RegisterClass(TOvcAttachedLabel);
finalization
  FDefaultController.Free;
  FDefaultController := nil;
end.
