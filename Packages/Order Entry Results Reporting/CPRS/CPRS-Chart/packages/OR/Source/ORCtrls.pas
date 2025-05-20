{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}
unit ORCtrls; // Oct 26, 1997 @ 10:00am

// To Do:  eliminate topindex itemtip on mousedown (seen when choosing clinic pts)

interface // --------------------------------------------------------------------------------

uses Windows, Messages, SysUtils, Classes, Graphics, Controls, StdCtrls, Forms,
  ComCtrls, Commctrl, Buttons, ExtCtrls, Grids, ImgList, Menus, CheckLst,
  Variants, VAClasses, typinfo, System.Math, OREventCache, ORCtrls.ORRichEdit;

const
  UM_SHOWTIP = (WM_USER + 9436); // message id to display item tip         **was 300
  UM_GOTFOCUS = (WM_USER + 9437); // message to post when combo gets focus  **was 301
  MAX_TABS = 40; // maximum number of tab stops or pieces
  LL_REVERSE = -1; // long list scrolling in reverse direction
  LL_POSITION = 0; // long list thumb moved
  LL_FORWARD = 1; // long list scrolling in forward direction
  LLS_LINE = '^____________________________________________________________________________';
  LLS_DASH = '^----------------------------------------------------------------------------';
  LLS_SPACE = '^ ';
  TINY_COLS_MAX_WIDTH = 2;

type
  IORBlackColorModeCompatible = interface(IInterface)
    ['{3554985C-F524-45FA-8C27-4CDD8357DB08}']
    procedure SetBlackColorMode(Value: boolean);
  end;

  TORComboBox = class; // forward declaration for FParentCombo

  TTranslator = function(MString: string): string of object;

  TORStrings = class(TStrings)
  private
    MList: TStringList;
    FPlainText: TStrings;
    FTranslator: TTranslator;
    FVerification: boolean;
    procedure Verify;
  protected
    function Get(index: integer): string; override;
    function GetCount: integer; override;
    function GetObject(index: integer): TObject; override;
    procedure Put(Index: Integer; const S: string); override;
    procedure PutObject(index: integer; Value: TObject); override;
    procedure SetUpdateState(Value: boolean); override;
  public
    function Add(const S: string): integer; override;
    constructor Create(PlainText: TStrings; Translator: TTranslator);
    destructor Destroy; override;
    procedure Clear; override;
    procedure Delete(index: integer); override;
    procedure Insert(Index: Integer; const S: string); override;
    function IndexOf(const S: string): Integer; override;
    property PlainText: TStrings read FPlainText;
    property Translator: TTranslator read FTranslator;
    property Verification: boolean read FVerification write FVerification;
  end;

  TORDirection = -1..1; // for compatibility, type is now integer
  TORNeedDataEvent = procedure(Sender: TObject; const StartFrom: string;
    Direction, InsertAt: Integer) of object;
  TORBeforeDrawEvent = procedure(Sender: TObject; Index: Integer; Rect: TRect;
    State: TOwnerDrawState) of object;
  TORItemNotifyEvent = procedure(Sender: TObject; Index: integer) of object;
  TORCheckComboTextEvent = procedure(Sender: TObject; NumChecked: integer; var Text: string) of object;
  TORSynonymCheckEvent = procedure(Sender: TObject; const Text: string;
    var IsSynonym: boolean) of object;

  PItemRec = ^TItemRec;
  TItemRec = record
    Reference: Variant; // variant value associated with item
    UserObject: TObject; // Objects[n] property of listbox item
    CheckedState: TCheckBoxState; // Used to indicate check box values
  end;

  THintRecords = record
    ObjectName: string;
    ObjectHint: string;
  end;

  TORListBox = class(TListBox, IVADynamicProperty, IORBlackColorModeCompatible)
  private
    FNonSelectedIndex: Integer; // Index of non selected focused index
    FFocusIndex: Integer; // item with focus when using navigation keys
    FLargeChange: Integer; // visible items less one
    FTipItem: Integer; // item currently displaying ItemTip
    FItemTipActive: Boolean; // used to delay appearance of the ItemTip
    FItemTipColor: TColor; // background color for ItemTip window
    FItemTipEnable: Boolean; // allows display of ItemTips over items
    FLastMouseX: Integer; // mouse X position on last MouseMove event
    FLastMouseY: Integer; // mouse Y position on last MouseMove event
    FLastItemIndex: Integer; // used for the OnChange event
    FFromSelf: Boolean; // true if listbox message sent from this unit
    FDelimiter: Char; // delimiter used by Pieces property
    FWhiteSpace: Char; // may be space or tab (between pieces)
    FTabPosInPixels: boolean; // determines if TabPosition is Pixels or Chars
    FTabPos: array[0..MAX_TABS] of Integer; // character based positions of tab stops
    FTabPix: array[0..MAX_TABS] of Integer; // pixel positions of tab stops
    FPieces: array[0..MAX_TABS] of Integer; // pieces that should be displayed for item
    FLongList: Boolean; // if true, enables special LongList properties
    FScrollBar: TScrollBar; // scrollbar used when in LongList mode
    FFirstLoad: Boolean; // true if NeedData has never been called
    FFromNeedData: Boolean; // true means items added to LongList part
    FDataAdded: Boolean; // true if items added during NeedData call
    FCurrentTop: Integer; // TopIndex, changes when inserting to LongList
    FWaterMark: Integer; // first LongList item after the short list
    FDirection: Integer; // direction of the current NeedData call
    FInsertAt: Integer; // insert point for the current NeedData call
    FParentCombo: TORComboBox; // used when listbox is part of dropdown combo
    FOnChange: TNotifyEvent; // event called when ItemIndex changes
    FOnNeedData: TORNeedDataEvent; // event called when LongList needs more items
    FHideSynonyms: boolean; // Hides Synonyms from the list
    FSynonymChars: string; // Chars a string must contain to be considered a synonym
    FOnSynonymCheck: TORSynonymCheckEvent; // Event that allows for custom synonym checking
    FCreatingItem: boolean; // Used by Synonyms to prevent errors when adding new items
    FCreatingText: string; // Used by Synonyms to prevent errors when adding new items
    FOnBeforeDraw: TORBeforeDrawEvent; // event called prior to drawing an item
    FRightClickSelect: boolean; // When true, a right click selects teh item
    FCheckBoxes: boolean; // When true, list box contains check boxes
    FFlatCheckBoxes: boolean; // When true, list box check boxes are flat
    FCheckEntireLine: boolean; // When checked, clicking anywhere on the line checks the checkbox
    FOnClickCheck: TORItemNotifyEvent; // Event notifying of checkbox change
    FDontClose: boolean; // Used to keep drop down open when checkboxes
    FItemsDestroyed: boolean; // Used to make sure items are not destroyed multiple times
    FAllowGrayed: boolean;
    FMItems: TORStrings; // Used to save corresponding M strings ("the pieces")
    FCaption: TStaticText; // Used to supply a title to IAccessible interface
    FCaseChanged: boolean; // If true, the names are stored in the database as all caps, but loaded and displayed in mixed-case
    FLookupPiece: integer; // If zero, list look-up comes from display string; if non-zero, indicates which piece of the item needs to be used for list lookup
    FIsPartOfComboBox: boolean;
    FBlackColorMode: boolean;
    FHideSelection: boolean;
    ItemRecList: TList; //Holds all allocated ItemRecs
    FFromSetFocusIndex: boolean; // used to prevent ScrollTo from calling NeedData when fron SetFocusIndex
    FUseExactSearch: boolean;
    FLastStartFrom: string;
    FLastDirection: Integer;
    FLastInsertAt: Integer;
    FLastEmptyStartFrom: string;
    FLastEmptyDirection: Integer;
    FLastEmptyInsertAt: Integer;
    FLastEmpty: boolean;
    FDetectLastEmpty: boolean;
    FKeepItemID: boolean;
    FLastItemID: string;
    FIsInLoadRecreateItems: Boolean;
    function SearchMsg: UINT;
    procedure AdjustScrollBar;
    procedure CreateScrollBar;
    procedure FreeScrollBar;
    function GetDisplayText(Index: Integer): string;
    function GetItemID: Variant;
    function GetItemIEN: Int64;
    function GetPieces: string;
    function GetReference(Index: Integer): Variant;
    function GetTabPositions: string;
    function GetStyle: TListBoxStyle;
    procedure NeedData(Direction: Integer; StartFrom: string);
    function PositionThumb: Integer;
    procedure ResetItems;
    procedure ScrollBarScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
    procedure ScrollTo(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
    function GetStringIndex(const AString: string): Integer;
    procedure SetCheckBoxes(const Value: boolean);
    procedure SetDelimiter(Value: Char);
    procedure SetFlatCheckBoxes(const Value: boolean);
    procedure SetFocusIndex(Value: Integer);
    procedure SetLongList(Value: Boolean);
    procedure SetPieces(const Value: string);
    procedure SetReference(Index: Integer; AReference: Variant);
    procedure SetTabPositions(const Value: string);
    procedure SetTabPosInPixels(const Value: boolean);
    procedure SetTabStops;
    procedure SetHideSynonyms(Value: boolean);
    procedure SetSynonymChars(Value: string);
    procedure SetStyle(Value: TListBoxStyle);
    function IsSynonym(const TestStr: string): boolean;
    function TextToShow(S: string): string;
    procedure LBGetText(var Message: TMessage); message LB_GETTEXT;
    procedure LBGetTextLen(var Message: TMessage); message LB_GETTEXTLEN;
    procedure LBGetItemData(var Message: TMessage); message LB_GETITEMDATA;
    procedure LBSetItemData(var Message: TMessage); message LB_SETITEMDATA;
    procedure LBAddString(var Message: TMessage); message LB_ADDSTRING;
    procedure LBInsertString(var Message: TMessage); message LB_INSERTSTRING;
    procedure LBDeleteString(var Message: TMessage); message LB_DELETESTRING;
    procedure LBResetContent(var Message: TMessage); message LB_RESETCONTENT;
    procedure LBSetCurSel(var Message: TMessage); message LB_SETCURSEL;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CNDrawItem(var Message: TWMDrawItem); message CN_DRAWITEM;
    procedure WMDestroy(var Message: TWMDestroy); message WM_DESTROY;
    procedure WMKeyDown(var Message: TWMKeyDown); message WM_KEYDOWN;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMLButtonUp(var Message: TWMLButtonUp); message WM_LBUTTONUP;
    procedure WMRButtonUp(var Message: TWMRButtonUp); message WM_RBUTTONUP;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure WMCancelMode(var Message: TMessage); message WM_CANCELMODE;
    procedure WMMove(var Message: TWMMove); message WM_MOVE;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
    procedure WMMouseWheel(var Message: TMessage); message WM_MOUSEWHEEL;
    procedure CMHintShow(var Message: TMessage); message CM_HINTSHOW;
    procedure UMShowTip(var Message: TMessage); message UM_SHOWTIP;
    function GetChecked(Index: Integer): Boolean;
    procedure SetChecked(Index: Integer; const Value: Boolean);
    function GetMultiSelect: boolean;
    function GetCheckedString: string;
    procedure SetCheckedString(const Value: string);
    function GetCheckedState(Index: Integer): TCheckBoxState;
    procedure SetCheckedState(Index: Integer; const Value: TCheckBoxState);
    function GetMItems: TStrings;
    procedure SetMItems(Value: TStrings);
    procedure SetCaption(const Value: string);
    function GetCaption: string;
  protected
    procedure SetMultiSelect(Value: boolean); override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    procedure Click; override;
    procedure DoChange; virtual;
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure DestroyItems;
    procedure Loaded; override;
    procedure ToggleCheckBox(idx: integer);
    procedure KeyPress(var Key: Char); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MeasureItem(Index: Integer; var Height: Integer); override;
    procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); override;
    function GetIndexFromY(YPos: integer): integer;
    procedure LoadRecreateItems(RecreateItems: TStrings); override;
    property isPartOfComboBox: boolean read FIsPartOfComboBox write FIsPartOfComboBox default False;
    property HideSynonyms: boolean read FHideSynonyms write SetHideSynonyms default FALSE;
    property SynonymChars: string read FSynonymChars write SetSynonymChars;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ClearTop;
    function AddReference(const S: string; AReference: Variant): Integer;
    procedure InsertReference(Index: Integer; const S: string; AReference: Variant);
    function IndexOfReference(AReference: Variant): Integer;
    procedure InsertSeparator;
    procedure ForDataUse(Strings: TStrings);
    procedure InitLongList(S: string);
    function GetIEN(AnIndex: Integer): Int64;
    function SelectByIEN(AnIEN: Int64): Integer;
    function SelectByID(const AnID: string): Integer;
    function SetExactByIEN(AnIEN: Int64; const AnItem: string): Integer;
    procedure Clear; override;
    property ItemID: Variant read GetItemID;
    property ItemIEN: Int64 read GetItemIEN;
    property FocusIndex: Integer read FFocusIndex write SetFocusIndex;
    property NonSelectedIndex: Integer read FNonSelectedIndex;
    property DisplayText[Index: Integer]: string read GetDisplayText;
    property References[Index: Integer]: Variant read GetReference write SetReference;
    property ShortCount: Integer read FWaterMark;
    property Checked[Index: Integer]: Boolean read GetChecked write SetChecked;
    property CheckedString: string read GetCheckedString write SetCheckedString;
    property CheckedState[Index: Integer]: TCheckBoxState read GetCheckedState write SetCheckedState;
    property MItems: TStrings read GetMItems write SetMItems;
    function VerifyUnique(SelectIndex: Integer; iText: string): integer;
    procedure SetBlackColorMode(Value: boolean);
    function SupportsDynamicProperty(PropertyID: integer): boolean;
    function GetDynamicProperty(PropertyID: integer): string;
    property HideSelection: boolean read FHideSelection write FHideSelection;
    function SelectString(const AString: string): Integer;
  published
    property AllowGrayed: boolean read FAllowGrayed write FAllowGrayed default FALSE;
    property Caption: string read GetCaption write SetCaption;
    property CaseChanged: boolean read FCaseChanged write FCaseChanged default TRUE;
    property Delimiter: Char read FDelimiter write SetDelimiter default '^';
    property ItemTipColor: TColor read FItemTipColor write FItemTipColor;
    property ItemTipEnable: Boolean read FItemTipEnable write FItemTipEnable default True;
    property LongList: Boolean read FLongList write SetLongList;
    property LookupPiece: integer read FLookupPiece write FLookupPiece default 0;
    property Pieces: string read GetPieces write SetPieces;
    property TabPosInPixels: boolean read FTabPosInPixels write SetTabPosInPixels default False; // MUST be before TabPositions!
    property TabPositions: string read GetTabPositions write SetTabPositions;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnNeedData: TORNeedDataEvent read FOnNeedData write FOnNeedData;
    property OnBeforeDraw: TORBeforeDrawEvent read FOnBeforeDraw write FOnBeforeDraw;
    property RightClickSelect: boolean read FRightClickSelect write FRightClickSelect default FALSE;
    property CheckBoxes: boolean read FCheckBoxes write SetCheckBoxes default FALSE;
    property Style: TListBoxStyle read GetStyle write SetStyle default lbStandard;
    property FlatCheckBoxes: boolean read FFlatCheckBoxes write SetFlatCheckBoxes default TRUE;
    property CheckEntireLine: boolean read FCheckEntireLine write FCheckEntireLine default FALSE;
    property OnClickCheck: TORItemNotifyEvent read FOnClickCheck write FOnClickCheck;
    property MultiSelect: boolean read GetMultiSelect write SetMultiSelect default FALSE;
    property Items: TStrings read GetMItems write SetMItems;
    property OnDrawItem;
  end;

  TORDropPanel = class(TPanel)
  private
    FButtons: boolean;
    procedure WMActivateApp(var Message: TMessage); message WM_ACTIVATEAPP;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Resize; override;
    procedure UpdateButtons;
    function GetButton(OKBtn: boolean): TSpeedButton;
    procedure ResetButtons;
    procedure BtnClicked(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TORComboStyle = (orcsDropDown, orcsSimple);

  TORComboPanelEdit = class(TPanel)
  private
    FFocused: boolean;
    FCanvas: TControlCanvas;
  protected
    procedure Paint; override;
  public
    destructor Destroy; override;
  end;

  TORComboEdit = class(TEdit)
  private
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  end;

  TORComboBox = class(TWinControl, IVADynamicProperty, IORBlackColorModeCompatible)
  private
    FItems: TStrings; // points to Items in FListBox
    FMItems: TStrings; // points to MItems in FListBox
    FListBox: TORListBox; // listbox control for the combobox
    FEditBox: TORComboEdit; // edit control for the combobox
    FEditPanel: TORComboPanelEdit; // Used to enable Multi-Select Combo Boxes
    FDropBtn: TBitBtn; // drop down button for dropdown combo
    FDropPanel: TORDropPanel; // panel for dropdown combo (parent=desktop)
    FDroppedDown: Boolean; // true if the list part is dropped down
    FStyle: TORComboStyle; // style is simple or dropdown for combo
    FDropDownCount: Integer; // number of items to display when list appears
    FFromSelf: Boolean; // prevents recursive calls to change event
    FFromDropBtn: Boolean; // determines when to capture mouse on drop
    FKeyTimerActive: Boolean; // true when timer running for OnKeyPause
    FKeyIsDown: Boolean; // true between KeyDown & KeyUp events
    FChangePending: Boolean;
    FListItemsOnly: Boolean;
    FLastFound: string;
    FLastInput: string; // last thing the user typed into the edit box
    FOnChange: TNotifyEvent; // maps to editbox change event
    FOnClick: TNotifyEvent; // maps to listbox click event
    FOnDblClick: TNotifyEvent; // maps to listbox double click event
    FOnDropDown: TNotifyEvent; // event called when listbox appears
    FOnDropDownClose: TNotifyEvent; // event called when listbox disappears
    FOnKeyDown: TKeyEvent; // maps to editbox keydown event
    FOnKeyPress: TKeyPressEvent; // maps to editbox keypress event
    FOnKeyUp: TKeyEvent; // maps to editbox keyup event
    FOnKeyPause: TNotifyEvent; // delayed change event when using keyboard
    FOnMouseClick: TNotifyEvent; // called when click event triggered by mouse
    FOnNeedData: TORNeedDataEvent; // called for longlist when more items needed
    FCheckedState: string; // Used to refresh checkboxes when combo box cancel is pressed
    FOnCheckedText: TORCheckComboTextEvent; // Used to modify the edit box display text when using checkboxes
    FCheckBoxEditColor: TColor; // Edit Box color for Check Box Combo List, when not in Focus
    FTemplateField: boolean;
    FCharsNeedMatch: integer; // how many text need to be matched for auto selection
    FUniqueAutoComplete: Boolean; // If true only perform autocomplete for unique list items.
    FBlackColorMode: boolean;
    FDropDownStatusChangedCount: integer; // prevents multiple calls to disabling hint window
    fRpcCall: String;
    FTimerInterval: integer;
    FData: TObject;
    FOwnsData: boolean;
    fOnDrawItem: TDrawItemEvent;
    FSetItemIndexOnChange: boolean;

    procedure setOnDrawItem(aValue: TDrawItemEvent);
    procedure EditOnExit(Sender: TObject);
    procedure DropDownStatusChanged(opened: boolean);
    procedure ClearDropDownStatus;
    function EditControl: TWinControl;
    procedure AdjustSizeOfSelf;
    procedure DropButtonDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
    procedure DropButtonUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
    procedure FwdClick(Sender: TObject);
    procedure FwdDblClick(Sender: TObject);
    procedure FwdKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FwdKeyPress(Sender: TObject; var Key: Char);
    procedure FwdKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FwdMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
    procedure FwdNeedData(Sender: TObject; const StartFrom: string;
      Direction, InsertAt: Integer);
    procedure SetNumForMatch(const NumberForMatch: integer);
    function GetAutoSelect: Boolean;
    function GetColor: TColor;
    function GetDelimiter: Char;
    function GetDisplayText(Index: Integer): string;
    function GetItemHeight: Integer;
    function GetItemID: Variant;
    function GetItemIEN: Int64;
    function GetItemIndex: Integer;
    function GetItemTipEnable: Boolean;
    function GetItemTipColor: TColor;
    function GetLongList: Boolean;
    function GetMaxLength: Integer;
    function GetPieces: string;
    function GetReference(Index: Integer): Variant;
    function GetSelLength: Integer;
    function GetSelStart: Integer;
    function GetSelText: string;
    function GetShortCount: Integer;
    function GetSorted: Boolean;
    function GetHideSynonyms: boolean;
    function GetSynonymChars: string;
    function GetTabPositions: string;
    function GetTabPosInPixels: boolean;
    function GetText: string;
    procedure SetAutoSelect(Value: Boolean);
    procedure SetColor(Value: TColor);
    procedure SetDelimiter(Value: Char);
    procedure SetDropDownCount(Value: Integer);
    procedure SetDroppedDown(Value: Boolean);
    procedure SetEditRect;
    procedure SetEditText(const Value: string);
    procedure SetItemIndex(Value: Integer);
    procedure SetItemHeight(Value: Integer);
    procedure SetItemTipEnable(Value: Boolean);
    procedure SetItemTipColor(Value: TColor);
    procedure SetLongList(Value: Boolean);
    procedure SetMaxLength(Value: Integer);
    procedure SetPieces(const Value: string);
    procedure SetReference(Index: Integer; AReference: Variant);
    procedure SetSelLength(Value: Integer);
    procedure SetSelStart(Value: Integer);
    procedure SetSelText(const Value: string);
    procedure SetSorted(Value: Boolean);
    procedure SetHideSynonyms(Value: boolean);
    procedure SetSynonymChars(Value: string);
    procedure SetStyle(Value: TORComboStyle);
    procedure SetTabPositions(const Value: string);
    procedure SetTabPosInPixels(const Value: boolean);
    procedure SetText(const Value: string);
    procedure SetItems(const Value: TStrings);
    procedure StartKeyTimer;
    procedure StopKeyTimer;
    procedure WMDestroy(var Message: TWMDestroy); message WM_DESTROY;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure WMMove(var Message: TWMMove); message WM_MOVE;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMTimer(var Message: TWMTimer); message WM_TIMER;
    procedure UMGotFocus(var Message: TMessage); message UM_GOTFOCUS;
    function GetCheckBoxes: boolean;
    function GetChecked(Index: Integer): Boolean;
    function GetCheckEntireLine: boolean;
    function GetFlatCheckBoxes: boolean;
    procedure SetCheckBoxes(const Value: boolean);
    procedure SetChecked(Index: Integer; const Value: Boolean);
    procedure SetCheckEntireLine(const Value: boolean);
    procedure SetFlatCheckBoxes(const Value: boolean);
    function GetCheckedString: string;
    procedure SetCheckedString(const Value: string);
    procedure SetCheckBoxEditColor(const Value: TColor);
    procedure SetListItemsOnly(const Value: Boolean);
    procedure SetOnCheckedText(const Value: TORCheckComboTextEvent);
    procedure SetTemplateField(const Value: boolean);
    function GetOnSynonymCheck: TORSynonymCheckEvent;
    procedure SetOnSynonymCheck(const Value: TORSynonymCheckEvent);
    function GetMItems: TStrings;
    procedure SetCaption(const Value: string);
    function GetCaption: string;
    function GetCaseChanged: boolean;
    procedure SetCaseChanged(const Value: boolean);
    function GetLookupPiece: integer;
    procedure SetLookupPiece(const Value: integer);
    procedure SetUniqueAutoComplete(const Value: Boolean);
    procedure LoadComboBoxImage;
    function GetTabStop: Boolean;
    procedure SetTabStop(const Value: Boolean);
  protected
    // RDD: The following two procedures have been made protected and virtual
    // so they can be overwritten in TIndicationsCombobox. These changes
    // need to be un-done (and made permanent in this object) in v33!
    procedure FwdChange(Sender: TObject); virtual;
    procedure FwdChangeDelayed; virtual;
    // These properties allow TIndicationsCombobox to access the private members
    // it needs;
    property FromSelf: Boolean read FFromSelf write FFromSelf;
    property ChangePending: Boolean read FChangePending write FChangePending;
    property ListBox: TORListBox read FListBox;
    property KeyIsDown: Boolean read FKeyIsDown;
    property EditBox: TORComboEdit read FEditBox;
    property LastInput: string read FLastInput write FLastInput;
    property LastFound: string read FLastFound write FLastFound;
  protected
    procedure DropPanelBtnPressed(OKBtn, AutoClose: boolean);
    function GetEditBoxText(Index: Integer): string;
    procedure CheckBoxSelected(Sender: TObject; Index: integer);
    procedure UpdateCheckEditBoxText;
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure Loaded; override;
    function GetEnabled: boolean; override;
    procedure SetEnabled(Value: boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function AddReference(const S: string; AReference: Variant): Integer;
    procedure Clear;
    procedure ClearTop;
    procedure ForDataUse(Strings: TStrings);
    procedure InitLongList(S: string);
    procedure InsertSeparator;
    procedure Invalidate; override;
    procedure SetTextAutoComplete(TextToMatch: string);
    function GetIEN(AnIndex: Integer): Int64;
    function SelectByIEN(AnIEN: Int64): Integer;
    function SelectByID(const AnID: string): Integer;
    function SetExactByIEN(AnIEN: Int64; const AnItem: string): Integer;
    function IndexOfReference(AReference: Variant): Integer;
    procedure InsertReference(Index: Integer; const S: string; AReference: Variant);
    procedure SelectAll;
    procedure SetBlackColorMode(Value: boolean);
    function SupportsDynamicProperty(PropertyID: integer): boolean;
    function GetDynamicProperty(PropertyID: integer): string;
    property DisplayText[Index: Integer]: string read GetDisplayText;
    property DroppedDown: Boolean read FDroppedDown write SetDroppedDown;
    property ItemID: Variant read GetItemID;
    property ItemIEN: Int64 read GetItemIEN;
    property ItemIndex: Integer read GetItemIndex write SetItemIndex;
    property References[Index: Integer]: Variant read GetReference write SetReference;
    property SelLength: Integer read GetSelLength write SetSelLength;
    property SelStart: Integer read GetSelStart write SetSelStart;
    property SelText: string read GetSelText write SetSelText;
    property ShortCount: Integer read GetShortCount;
    property Checked[Index: Integer]: Boolean read GetChecked write SetChecked;
    property CheckedString: string read GetCheckedString write SetCheckedString;
    property TemplateField: boolean read FTemplateField write SetTemplateField;
    property MItems: TStrings read GetMItems;
    property TimerInterval: integer read FTimerInterval write FTimerInterval;
    property Data: TObject read FData write FData;
    property OwnsData: boolean read FOwnsData write FOwnsData;
  published
    Property RpcCall :String read fRpcCall write fRpcCall;
    property Anchors;
    property CaseChanged: boolean read GetCaseChanged write SetCaseChanged default TRUE;
    property CheckBoxes: boolean read GetCheckBoxes write SetCheckBoxes default FALSE;
    property Style: TORComboStyle read FStyle write SetStyle;
    property Align;
    property AutoSelect: Boolean read GetAutoSelect write SetAutoSelect;
    property Caption: string read GetCaption write SetCaption;
    property Color: TColor read GetColor write SetColor;
    property Ctl3D;
    property Delimiter: Char read GetDelimiter write SetDelimiter default '^';
    property DropDownCount: Integer read FDropDownCount write SetDropDownCount;
    property Enabled;
    property Font;
    property Items: TStrings read FItems write SetItems;
    property ItemHeight: Integer read GetItemHeight write SetItemHeight;
    property ItemTipColor: TColor read GetItemTipColor write SetItemTipColor;
    property ItemTipEnable: Boolean read GetItemTipEnable write SetItemTipEnable;
    property ListItemsOnly: Boolean read FListItemsOnly write SetListItemsOnly;
    property LongList: Boolean read GetLongList write SetLongList;
    property LookupPiece: Integer read GetLookupPiece write SetLookupPiece;
    property MaxLength: Integer read GetMaxLength write SetMaxLength;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property Pieces: string read GetPieces write SetPieces;
    property PopupMenu;
    property ShowHint;
    property HideSynonyms: boolean read GetHideSynonyms write SetHideSynonyms default FALSE;
    property Sorted: Boolean read GetSorted write SetSorted;
    property SynonymChars: string read GetSynonymChars write SetSynonymChars;
    property TabPosInPixels: boolean read GetTabPosInPixels write SetTabPosInPixels default False; // MUST be before TabPositions!
    property TabPositions: string read GetTabPositions write SetTabPositions;
    property TabOrder;
    property TabStop: Boolean read GetTabStop write SetTabStop default False;
    property Text: string read GetText write SetText;
    property Visible;
    property FlatCheckBoxes: boolean read GetFlatCheckBoxes write SetFlatCheckBoxes default TRUE;
    property CheckEntireLine: boolean read GetCheckEntireLine write SetCheckEntireLine default FALSE;
    property CheckBoxEditColor: TColor read FCheckBoxEditColor write SetCheckBoxEditColor default clBtnFace;
    property OnCheckedText: TORCheckComboTextEvent read FOnCheckedText write SetOnCheckedText;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property OnDblClick: TNotifyEvent read FOnDblClick write FOnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDropDown: TNotifyEvent read FOnDropDown write FOnDropDown;
    property OnDropDownClose: TNotifyEvent read FOnDropDownClose write FOnDropDownClose;
    property OnEnter;
    property OnExit;
    property OnKeyDown: TKeyEvent read FOnKeyDown write FOnKeyDown;
    property OnKeyPress: TKeyPressEvent read FOnKeyPress write FOnKeyPress;
    property OnKeyUp: TKeyEvent read FOnKeyUp write FOnKeyUp;
    property OnKeyPause: TNotifyEvent read FOnKeyPause write FOnKeyPause;
    property OnMouseClick: TNotifyEvent read FOnMouseClick write FOnMouseClick;
    property OnNeedData: TORNeedDataEvent read FOnNeedData write FOnNeedData;
    property OnResize;
    property OnSynonymCheck: TORSynonymCheckEvent read GetOnSynonymCheck write SetOnSynonymCheck;
    property CharsNeedMatch: integer read FCharsNeedMatch write SetNumForMatch;
{UniqueAutoComplete Was added as a result of the following defects:
 7293 - PTM 85:  Backspace and Dosage:  Desired dosage does not populate if dosage is not in local dosage field
 7337 - PTM 160 Meds: #8 IMO - Simple - Change Order in which Error generated if "Enter" is hit instead of "OK"
 7278 - PTM 36 Meds: Select 40000 UNT/2ML and backspace to 4000 the dose selected remains 40000
 7284 - Inconsistencies of pulling in a dose from the Possible Dose File }
    property UniqueAutoComplete: Boolean read FUniqueAutoComplete write SetUniqueAutoComplete default False;
    property OnDrawItem: TDrawItemEvent read fOnDrawItem write setOnDrawItem;
    // set SetItemIndexOnChange to False to stop OnChange events when changing ItemIndex.
    property SetItemIndexOnChange: boolean read FSetItemIndexOnChange write FSetItemIndexOnChange default True;
  end;

  TORAutoPanel = class(TPanel)
  private
    FSizes: TList;
    procedure BuildSizes(Control: TWinControl);
    procedure DoResize(Control: TWinControl; var CurrentIndex: Integer);
  protected
    procedure Loaded; override;
    procedure Resize; override;
  public
    destructor Destroy; override;
  end;

  TOROffsetLabel = class(TGraphicControl) // see TCustomLabel in the VCL
  private
    FHorzOffset: Integer; // offset from left of label in pixels
    FVertOffset: Integer; // offset from top of label in pixels
    FWordWrap: Boolean; // true if word wrap should occur
    function GetTransparent: Boolean;
    procedure AdjustSizeOfSelf;
    procedure DoDrawText(var Rect: TRect; Flags: Word);
    procedure SetHorzOffset(Value: Integer);
    procedure SetVertOffset(Value: Integer);
    procedure SetTransparent(Value: Boolean);
    procedure SetWordWrap(Value: Boolean);
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Align;
    property Caption;
    property Color;
    property Enabled;
    property Font;
    property HorzOffset: Integer read FHorzOffset write SetHorzOffset;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Transparent: Boolean read GetTransparent write SetTransparent;
    property VertOffset: Integer read FVertOffset write SetVertOffset;
    property Visible;
    property WordWrap: Boolean read FWordWrap write SetWordWrap;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
  end;

  TORAlignButton = class(TButton)
  private
    FAlignment: TAlignment;
    FWordWrap: boolean;
    FLayout: TTextLayout;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure SetAlignment(const Value: TAlignment);
    procedure SetLayout(const Value: TTextLayout);
    procedure SetWordWrap(const Value: boolean);
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Align;
    property Alignment: TAlignment read FAlignment write SetAlignment default taCenter;
    property Layout: TTextLayout read FLayout write SetLayout default tlCenter;
    property WordWrap: boolean read FWordWrap write SetWordWrap default FALSE;
  end;

{  TORAlignBitBtn = class(TBitBtn)
  published
    property Align;
  end;}

  TORAlignSpeedButton = class(TSpeedButton)
  protected
    procedure Paint; override;
  public
    property Canvas;
  published
    property Align;
    property OnResize;
  end;

  TORAlignEdit = class(TEdit) //Depricated -- Use TCaptionEdit instead
  published
    property Align;
  end;

  TORDraggingEvent = procedure(Sender: TObject; Node: TTreeNode; var CanDrag: boolean) of object;


  TCaptionTreeView = class(TTreeView, IVADynamicProperty)
  private
    const
      CaptionTreeViewRecreateWndEvents: array of string = ['OnAddition',
        'OnChange', 'OnChanging', 'OnCollapsed', 'OnCollapsing', 'OnDeletion',
        'OnExpanded', 'OnExpanding'];
  private
    FEventCache: TOREventCache;
    procedure SetCaption(const Value: string);
    function GetCaption: string;
    procedure TVMDeleteItem(var Message: TMessage); message TVM_DELETEITEM;
    procedure TVMSelectItem(var Message: TMessage); message TVM_SELECTITEM;
    function GetEventCache: TOREventCache;
  protected
    FCaptionComponent: TStaticText;
    property EventCache: TOREventCache read GetEventCache;
    procedure CMSysColorChange(var Message: TMessage); message CM_SYSCOLORCHANGE;
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
  public
    destructor Destroy; Override;
    function SupportsDynamicProperty(PropertyID: integer): boolean;
    function GetDynamicProperty(PropertyID: integer): string;
  published
    property Align;
    property Caption: string read GetCaption write SetCaption;
  end;

  TORTreeView = class;

  TORTreeNode = class(TTreeNode)
  private
    FTag: integer;
    FStringData: string;
    FCaption: string;
    // NOTE: If you add more fields to TORTreeNode, you will need to update
    //       Read/WriteORNodeData to match.
    function GetParent: TORTreeNode;
    procedure SetCaption(const Value: string);
  protected
    function GetText: string;
    procedure SetText(const Value: string);
    procedure UpdateText(const Value: string; UpdateData: boolean = TRUE);
    function GetBold: boolean;
    procedure SetBold(const Value: boolean);
    procedure SetStringData(const Value: string);
    function GetORTreeView: TORTreeView;
    procedure WriteORNodeData(aStream: TStream);
    procedure ReadORNodeData(aStream: TStream);
  public
    procedure SetPiece(PieceNum: Integer; const NewPiece: string);
    procedure EnsureVisible;
    property Bold: boolean read GetBold write SetBold;
    property Tag: integer read FTag write FTag;
    property StringData: string read FStringData write SetStringData;
    property TreeView: TORTreeView read GetORTreeView;
    property Text: string read GetText write SetText;
    property Parent: TORTreeNode read GetParent;
    property Caption: string read FCaption write SetCaption;
  end;

  TNodeCaptioningEvent = procedure(Sender: TObject; var Caption: string) of object;

  TORTreeView = class(TCaptionTreeView)
  private
    const
      ORTreeViewRecreateWndEvents: array of string = ['OnNodeCaptioning'];
  private
    FRecreateStream: TMemoryStream;
    FOnDragging: TORDraggingEvent;
    FDelim: Char;
    FPiece: integer;
    FOnAddition: TTVExpandedEvent;
    FShortNodeCaptions: boolean;
    FOnNodeCaptioning: TNodeCaptioningEvent;
    procedure SetShortNodeCaptions(const Value: boolean);
  protected
    procedure CNNotify(var Message: TWMNotify); message CN_NOTIFY;
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    function CreateNode: TTreeNode; override;
    function GetHorzScrollPos: integer;
    procedure SetHorzScrollPos(Value: integer);
    function GetVertScrollPos: integer;
    procedure SetVertScrollPos(Value: integer);
    procedure SetNodeDelim(const Value: Char);
    procedure SetNodePiece(const Value: integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function FindPieceNode(Value: string;
      ParentDelim: Char = #0; StartNode: TTreeNode = nil): TORTreeNode; overload;
    function FindPieceNode(Value: string; APiece: integer;
      ParentDelim: Char = #0; StartNode: TTreeNode = nil): TORTreeNode; overload;
    procedure RenameNodes;
    function GetExpandedIDStr(APiece: integer; ParentDelim: char = #0): string;
    procedure SetExpandedIDStr(APiece: integer; const Value: string); overload;
    procedure SetExpandedIDStr(APiece: integer; ParentDelim: char;
      const Value: string); overload;
    function GetNodeID(Node: TORTreeNode; ParentDelim: Char = #0): string; overload;
    function GetNodeID(Node: TORTreeNode; APiece: integer; ParentDelim: Char = #0): string; overload;
  published
    property Caption;
    property NodeDelim: Char read FDelim write SetNodeDelim default '^';
    property NodePiece: integer read FPiece write SetNodePiece;
    property OnAddition: TTVExpandedEvent read FOnAddition write FOnAddition;
    property OnDragging: TORDraggingEvent read FOnDragging write FOnDragging;
    property HorzScrollPos: integer read GetHorzScrollPos write SetHorzScrollPos default 0;
    property VertScrollPos: integer read GetVertScrollPos write SetVertScrollPos default 0;
    property ShortNodeCaptions: boolean read FShortNodeCaptions write SetShortNodeCaptions default False;
    property OnNodeCaptioning: TNodeCaptioningEvent read FOnNodeCaptioning write FOnNodeCaptioning;
  end;

  TORCBImageIndexes = class(TComponent)
  private
    FImages: TCustomImageList;
    FImageChangeLink: TChangeLink;
    FCheckedEnabledIndex: integer;
    FGrayedEnabledIndex: integer;
    FUncheckedEnabledIndex: integer;
    FCheckedDisabledIndex: integer;
    FGrayedDisabledIndex: integer;
    FUncheckedDisabledIndex: integer;
  protected
    procedure SetCheckedDisabledIndex(const Value: integer);
    procedure SetCheckedEnabledIndex(const Value: integer);
    procedure SetGrayedDisabledIndex(const Value: integer);
    procedure SetGrayedEnabledIndex(const Value: integer);
    procedure SetUncheckedDisabledIndex(const Value: integer);
    procedure SetUncheckedEnabledIndex(const Value: integer);
    procedure ImageListChanged(Sender: TObject);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function IdxString: string;
    procedure SetIdxString(Value: string);
    procedure SetImages(const Value: TCustomImageList);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property CheckedEnabledIndex: integer read FCheckedEnabledIndex write SetCheckedEnabledIndex;
    property CheckedDisabledIndex: integer read FCheckedDisabledIndex write SetCheckedDisabledIndex;
    property GrayedEnabledIndex: integer read FGrayedEnabledIndex write SetGrayedEnabledIndex;
    property GrayedDisabledIndex: integer read FGrayedDisabledIndex write SetGrayedDisabledIndex;
    property UncheckedEnabledIndex: integer read FUncheckedEnabledIndex write SetUncheckedEnabledIndex;
    property UncheckedDisabledIndex: integer read FUncheckedDisabledIndex write SetUncheckedDisabledIndex;
  end;

  TGrayedStyle = (gsNormal, gsQuestionMark, gsBlueQuestionMark);

  TORCheckBox = class(TCheckBox, IORBlackColorModeCompatible)
  private
    FStringData: string;
    FCanvas: TCanvas;
    FGrayedToChecked: boolean;
    FCustomImagesOwned: boolean;
    FCustomImages: TORCBImageIndexes;
    FGrayedStyle: TGrayedStyle;
    FWordWrap: boolean;
    FAutoSize: boolean;
    FSingleLine: boolean;
    FSizable: boolean;
    FGroupIndex: integer;
    FAllowAllUnchecked: boolean;
    FRadioStyle: boolean;
    FAssociate: TControl;
    FFocusOnBox: boolean;
    FBlackColorMode: boolean;
    procedure SetFocusOnBox(value: boolean);
    procedure CNMeasureItem(var Message: TWMMeasureItem); message CN_MEASUREITEM;
    procedure CNDrawItem(var Message: TWMDrawItem); message CN_DRAWITEM;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure BMSetCheck(var Message: TMessage); message BM_SETCHECK;
    procedure BMGetCheck(var Message: TMessage); message BM_GETCHECK;
    procedure BMGetState(var Message: TMessage); message BM_GETSTATE;
    function GetImageList: TCustomImageList;
    function GetImageIndexes: string;
    procedure SetImageIndexes(const Value: string);
    procedure SetImageList(const Value: TCustomImageList);
    procedure SetWordWrap(const Value: boolean);
    function GetCaption: TCaption;
    procedure SetCaption(const Value: TCaption);
    procedure SyncAllowAllUnchecked;
    procedure SetAllowAllUnchecked(const Value: boolean);
    procedure SetGroupIndex(const Value: integer);
    procedure SetRadioStyle(const Value: boolean);
    procedure SetAssociate(const Value: TControl);
  protected
    procedure SetAutoSize(Value: boolean); override;
    procedure GetDrawData(CanvasHandle: HDC; var Bitmap: TBitmap;
      var FocRect, Rect: TRect;
      var DrawOptions: UINT;
      var TempBitMap: boolean);
    procedure DrawItem(const DrawItemStruct: TDrawItemStruct); dynamic;
    procedure Toggle; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure SetGrayedStyle(Value: TGrayedStyle);
    constructor ListViewCreate(AOwner: TComponent; ACustomImages: TORCBImageIndexes);
    procedure CreateCommon(AOwner: TComponent);
    property CustomImages: TORCBImageIndexes read FCustomImages;
    procedure SetParent(AParent: TWinControl); override;
    procedure UpdateAssociate;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AutoAdjustSize;
    procedure SetBlackColorMode(Value: boolean);
    property SingleLine: boolean read FSingleLine;
    property StringData: string read FStringData write FStringData;
  published
    property FocusOnBox: boolean read FFocusOnBox write SetFocusOnBox default false;
    property GrayedStyle: TGrayedStyle read FGrayedStyle write SetGrayedStyle default gsNormal;
    property GrayedToChecked: boolean read FGrayedToChecked write FGrayedToChecked default TRUE;
    property ImageIndexes: string read GetImageIndexes write SetImageIndexes;
    property ImageList: TCustomImageList read GetImageList write SetImageList;
    property WordWrap: boolean read FWordWrap write SetWordWrap default FALSE;
    property AutoSize: boolean read FAutoSize write SetAutoSize default FALSE;
    property Caption: TCaption read GetCaption write SetCaption;
    property AllowAllUnchecked: boolean read FAllowAllUnchecked write SetAllowAllUnchecked default TRUE;
    property GroupIndex: integer read FGroupIndex write SetGroupIndex default 0;
    property RadioStyle: boolean read FRadioStyle write SetRadioStyle default FALSE;
    property Associate: TControl read FAssociate write SetAssociate;
    property OnEnter;
    property OnExit;
  end;

  TORListView = class(TListView)
  private
  protected
    procedure WMNotify(var Message: TWMNotify); message WM_NOTIFY;
    procedure LVMSetColumn(var Message: TMessage); message LVM_SETCOLUMN;
    procedure LVMSetColumnWidth(var Message: TMessage); message LVM_SETCOLUMNWIDTH;
  end;

  { TORPopupMenu and  TORMenuItem are not available at design time, since they
    would offer little value there.  They are currently used for dynamic menu
    creation }
  TORPopupMenu = class(TPopupMenu)
  private
    FData: string;
  public
    property Data: string read FData write FData;
  end;

  TORMenuItem = class(TMenuItem)
  private
    FData: string;
  public
    property Data: string read FData write FData;
  end;

  (*
  TORCalendar = class(TCalendar)
  protected
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState); override;
  end;
  *)

  TKeyClickPanel = class(TPanel)
  private
    FOnPaint: TNotifyEvent;
    FCanvas: TControlCanvas;
    procedure CMFocusChanged(var Message: TCMFocusChanged); message CM_FOCUSCHANGED;
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure Paint; override;
  public
    destructor Destroy; override;
  published
    property OnPaint: TNotifyEvent read FOnPaint write FOnPaint;
  end;

  TKeyClickRadioGroup = class(TRadioGroup)
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure Click; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TOROnHintShow = Procedure(var HintText: String; var CanShow: Boolean) of object;

  TCaptionListBox = class(TListBox, IVADynamicProperty)
  private
    FHoverItemPos: integer;
    FRightClickSelect: boolean; // When true, a right click selects teh item
    FHintOnItem: boolean;
    FItemIndex: Integer;
    FOnChange: TNotifyEvent;
    FOnHintShow: TOROnHintShow;
    procedure SetCaption(const Value: string);
    function GetCaption: string;
    procedure WMRButtonUp(var Message: TWMRButtonUp); message WM_RBUTTONUP;
    procedure WMMouseMove(var Message: TWMMouseMove); message WM_MOUSEMOVE;
    procedure WMKeyDown(var Message: TWMKeyDown); message WM_KEYDOWN;
    procedure CNCommand(var AMessage: TWMCommand); message CN_COMMAND;
    procedure CMHintShow(var Message: TCMHintShow); message CM_HINTSHOW;
    procedure MoveFocusDown;
    procedure MoveFocusUp;
  protected
    FCaptionComponent: TStaticText;
    procedure Change; virtual;
    procedure DoEnter; override;
    procedure SetItemIndex(const Value: Integer); override;
  public
    function SupportsDynamicProperty(PropertyID: integer): boolean;
    function GetDynamicProperty(PropertyID: integer): string;
    constructor Create(AOwner: TComponent); override;
  published
    property RightClickSelect: boolean read FRightClickSelect write FRightClickSelect default FALSE;
    property Caption: string read GetCaption write SetCaption;
    //Make the ListBox's hint contain the contents of the listbox Item the mouse is currently over.
    property HintOnItem: boolean read FHintOnItem write FHintOnItem default FALSE;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnHintShow: TOROnHintShow read FOnHintShow write FOnHintShow;
  end;

  TCaptionCheckListBox = class(TCheckListBox, IVADynamicProperty)
  private
    procedure SetCaption(const Value: string);
    function GetCaption: string;
  protected
    FCaptionComponent: TStaticText;
  public
    function SupportsDynamicProperty(PropertyID: integer): boolean;
    function GetDynamicProperty(PropertyID: integer): string;
  published
    property Caption: string read GetCaption write SetCaption;
    Property CheckWidth: integer Read GetCheckWidth;
  end;

  TCaptionMemo = class(TMemo, IVADynamicProperty)
  private
    procedure SetCaption(const Value: string);
    function GetCaption: string;
  protected
    FCaptionComponent: TStaticText;
  public
    function SupportsDynamicProperty(PropertyID: integer): boolean;
    function GetDynamicProperty(PropertyID: integer): string;
  published
    property Caption: string read GetCaption write SetCaption;
  end;

  TDataEdit = class(TEdit)
  private
    FDataObject: TObject;
  public
    property DataObject: TObject read FDataObject write FDataObject;
  end;

  TCaptionEdit = class(TDataEdit, IVADynamicProperty)
  private
    procedure SetCaption(const Value: string);
    function GetCaption: string;
  protected
    FCaptionComponent: TStaticText;
  public
    function SupportsDynamicProperty(PropertyID: integer): boolean;
    function GetDynamicProperty(PropertyID: integer): string;
  published
    property Align;
    property Caption: string read GetCaption write SetCaption;
  end;

  TCaptionRichEdit = class(ORCtrls.ORRichEdit.TORRichEdit, IVADynamicProperty)
  private
  protected
    FCaption: string;
  public
    function SupportsDynamicProperty(PropertyID: integer): boolean;
    function GetDynamicProperty(PropertyID: integer): string;
  published
    property Align;
    property Caption: string read FCaption write FCaption;
  end;

  TCaptionComboBox = class(TComboBox, IVADynamicProperty)
  private
    procedure SetCaption(const Value: string);
    function GetCaption: string;
  protected
    FCaptionComponent: TStaticText;
  public
    function SupportsDynamicProperty(PropertyID: integer): boolean;
    function GetDynamicProperty(PropertyID: integer): string;
  published
    property Caption: string read GetCaption write SetCaption;
  end;

  TCaptionListItem  = class(ComCtrls.TListItem)
   Private
    fItemString: String;
    fObject: TObject;
   public
    property ItemString: String read fItemString write fItemString;
    property aObject: TObject read fObject write fObject;
  end;

   TCaptionListStringList = class(classes.TStringList)
   private
     fParentCLV: TObject;
   public
     procedure Assign(Source: TPersistent); override;
     constructor CreateWithParent(Parent: TObject);
  end;

  THeaderSortState = (hssNone, hssAscending, hssDescending);

  TCaptionListView = class(TListView, IVADynamicProperty)
  private
    FPieces: array[0..MAX_TABS] of Integer;
    FItemsStrings: TCaptionListStringList;
    FItemsStringsBackup: TStringList;
    FAutoSize: Boolean;
    FHideTinyColumns: Boolean;
    FTinyColumns: string;
    FColumnToSort: Integer;
    function GetPieces: string;
    function Get(Index: Integer): String;
    function GetObj(Index: Integer): TObject;
    function GetItemIEN: Int64;
    function GetIEN(AnIndex: Integer): Int64;
    function GetItemID: Variant;
    function GetItemsStrings: TCaptionListStringList;
    procedure SetPieces(const Value: string);
    Procedure SetFromStringList(AValue: TCaptionListStringList);
    procedure Put(Index: Integer; Item: String);
    procedure PutObj(Index: Integer; ItemObject: TObject);
    procedure WMSetFocus(var Message: TMessage); message WM_SETFOCUS;
    procedure WMNotify(var Message: TWMNotify); message WM_NOTIFY;
    procedure CreateItemClass(Sender: TCustomListView; var ItemClass: TListItemClass);
    function AddItemToList(aStr: string; aObject: TObject): TCaptionListItem;
    procedure SetHideTinyColumns(const Value: Boolean);
    procedure DoColumnSort(Column: TListColumn); virtual;
    function GetListHeaderSortState(Column: TListColumn): THeaderSortState;
    procedure SetListHeaderSortState(Column: TListColumn; Value: THeaderSortState);
    function GetListHeaderSortStateByIndex(ColumnIndex: Integer): THeaderSortState;
    procedure SetListHeaderSortStateByIndex(ColumnIndex: Integer; Value: THeaderSortState);
  protected
    procedure Loaded; override;
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    procedure ColClick(Column: TListColumn); override;
  public
    property ItemIEN: Int64 read GetItemIEN;
    property ItemID: Variant read GetItemID;
    property ItemsStrings: TCaptionListStringList read GetItemsStrings write SetFromStringList;
    property SortStateByColumn[Column: TListColumn]: THeaderSortState read GetListHeaderSortState write SetListHeaderSortState;
    property SortStateByIndex[ColumnIndex: Integer]: THeaderSortState read GetListHeaderSortStateByIndex write SetListHeaderSortStateByIndex;
    property SortColumn: integer read FColumnToSort;
    procedure ResetTinyColumns;
    function SupportsDynamicProperty(PropertyID: integer): boolean;
    function GetDynamicProperty(PropertyID: integer): string;
    function SelectByIEN(AnIEN: Int64): Integer;
    procedure AutoSizeColumns();
    property Strings[Index: Integer]: String read Get write Put; default;
    property Objects[Index: Integer]: TObject read GetObj write PutObj;
    Function Add(aStr: string): Integer; overload;
    Function Add(aStr: string; aObject: TObject): Integer; overload;
    function AddObject(aStr: string; aObject: TObject): Integer;
    procedure EditItem(Index: Integer; aStr: String);
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property AutoSize: Boolean read FAutoSize write FAutoSize;
    property Caption;
    property HideTinyColumns: Boolean read FHideTinyColumns write SetHideTinyColumns default False;
    property Pieces: string read GetPieces write SetPieces;
  end;

  TCaptionStringGrid = class(TStringGrid, IVADynamicProperty)
  private
    FJustToTab: boolean;
    FCaption: string;
  protected
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
  public
    procedure IndexToColRow(index: integer; var Col: integer; var Row: integer);
    function ColRowToIndex(Col: integer; Row: Integer): integer;
    function SupportsDynamicProperty(PropertyID: integer): boolean;
    function GetDynamicProperty(PropertyID: integer): string;
  published
    property Caption: string read FCaption write FCaption;
    property JustToTab: boolean read FJustToTab write FJustToTab default FALSE;
  end;

function AverageWidth(AFont: TFont): integer;
function AverageHeight(AFont: TFont): integer;

function FontWidthPixel(FontHandle: THandle): Integer;
function FontHeightPixel(FontHandle: THandle): Integer;
function ItemTipKeyHook(Code: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; StdCall;

{I may have messed up my Windows.pas file, but mine defines NotifyWinEvent without a stdcall.}
procedure GoodNotifyWinEvent(event: DWORD; hwnd: HWND; idObject, idChild: Longint); stdcall;

function CalcShortName(LongName: string; PrevLongName: string): string;

{Returns True if any one of 3 mouse buttons are down left, right, or middle}
function IsAMouseButtonDown: boolean;

implementation // ---------------------------------------------------------------------------

{$R ORCTRLS}

uses
  System.Generics.Defaults,
  System.Generics.Collections,
  System.Types, Vcl.ComStrs, VAUtils;

const
  ALPHA_DISTRIBUTION: array[0..100] of string = ('', ' ', 'ACE', 'ADG', 'ALA', 'AMI', 'ANA', 'ANT',
    'ARE', 'ASU', 'AZO', 'BCP', 'BIC', 'BOO', 'BST', 'CAF', 'CAR', 'CD6', 'CHE', 'CHO', 'CMC', 'CON', 'CPD',
    'CVI', 'DAA', 'DEF', 'DEP', 'DIA', 'DIH', 'DIP', 'DP ', 'EAR', 'EM ', 'EPI', 'ETH', 'F2G', 'FIB', 'FML',
    'FUM', 'GEL', 'GLU', 'GPQ', 'HAL', 'HEM', 'HIS', 'HUN', 'HYL', 'IDS', 'IND', 'INT', 'ISO', 'KEX', 'LAN',
    'LEV', 'LOY', 'MAG', 'MAX', 'MER', 'MET', 'MIC', 'MON', 'MUD', 'NAI', 'NEU', 'NIT', 'NUC', 'OMP', 'OTH',
    'P42', 'PAR', 'PEN', 'PHA', 'PHO', 'PLA', 'POL', 'PRA', 'PRO', 'PSE', 'PYR', 'RAN', 'REP', 'RIB', 'SAA',
    'SCL', 'SFL', 'SMO', 'SPO', 'STR', 'SUL', 'TAG', 'TET', 'THI', 'TOL', 'TRI', 'TRY', 'UNC', 'VAR', 'VIT',
    'WRO', 'ZYM', #127#127#127);

  CBO_CYMARGIN = 8; // vertical whitespace in the edit portion of combobox
  CBO_CXBTN = 13; // width of drop down button in combobox
  CBO_CXFRAME = 5; // offset to account for frame around the edit part of combobox

  NOREDRAW = 0; // suspend screen updates
  DOREDRAW = 1; // allow screen updates

  KEY_TIMER_DELAY = 500; // 500 ms delay after key up before OnKeyPause called
  KEY_TIMER_ID = 5800; // arbitrary, use high number in case TListBox uses timers

  { use high word to pass positioning flags since listbox is limited to 32767 items }
  //SFI_TOP = $80000000;         // top of listbox (decimal value: -2147483648)
  //SFI_END = $90000000;         // end of listbox (decimal value: -1879048192)
  SFI_TOP = -2147483646; // top of listbox (hex value: $80000001)
  SFI_END = -1879048192; // end of listbox (hex value: $90000000)

  CheckWidth = 15; // CheckBox Width space to reserve for TORListBox
  CheckComboBtnHeight = 21;
  MaxNeedDataLen = 64;

type
  TItemTip = class(TCustomControl)
  private
    FShowing: Boolean; // true when itemtip is visible
    FListBox: TORListBox; // current listbox displaying itemtips
    FListItem: integer;
    FPoint: TPoint;
    FSelected: boolean;
    FTabs: array[0..MAX_TABS] of Integer; // Holds the pixel offsets for tabs
    procedure GetTabSettings;
    procedure WMMouseWheel(var Message: TMessage); message WM_MOUSEWHEEL;
  protected
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Paint; override;
    procedure Hide;
    procedure UpdateText(CatchMouse: Boolean);
    procedure Show(AListBox: TORListBox; AnItem: Integer; APoint: TPoint; CatchMouse: Boolean);
  end;

  TSizeRatio = class // relative sizes and positions for resizing
  public
    CLeft: Extended;
    CTop: Extended;
    CWidth: Extended;
    CHeight: Extended;
    constructor Create(ALeft, ATop, AWidth, AHeight: Extended);
  end;

var
  uKeyHookHandle: HHOOK; // handle to capture key events & hide ItemTip window
  uItemTip: TItemTip; // ItemTip window
  uItemTipCount: Integer; // number of ItemTip clients
  uNewStyle: Boolean; // True if using Windows 95 interface
  HintArray: array of THintRecords;
{ General functions and procedures --------------------------------------------------------- }

function ClientWidthOfList(AListBox: TORListBox): Integer;
begin
  with AListBox do
  begin
    Result := Width;
    if BorderStyle = bsSingle then
    begin
      Dec(Result, 1);
      if Ctl3D then Dec(Result, 1);
    end;
  end;
  Dec(Result, GetSystemMetrics(SM_CXVSCROLL));
end;

function AverageWidth(AFont: TFont): integer;
var
  bmp: TBitmap;
begin
  bmp := TBitmap.Create;
  try
    bmp.Canvas.Font.Assign(AFont);
    Result := Trunc(bmp.Canvas.TextWidth('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz') / 52 ) + 1;
  finally
    bmp.Free;
  end;
end;

function AverageHeight(AFont: TFont): integer;
var
  bmp: TBitmap;
begin
  bmp := TBitmap.Create;
  try
    bmp.Canvas.Font.Assign(AFont);
    Result := bmp.Canvas.TextHeight('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz');
  finally
    bmp.Free;
  end;
end;

function FontWidthPixel(FontHandle: THandle): Integer;
{ return in pixels the average character width of the font passed in FontHandle }
var
  DC: HDC;
  SaveFont: HFont;
  Extent: TSize;
begin
  DC := GetDC(0);
  try
    SaveFont := SelectObject(DC, FontHandle);
    try
      GetTextExtentPoint32(DC, 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz', 52, Extent);
      //Find the average of the width then round up
      Result := Trunc(Extent.cx / 52 ) + 1;
    finally
      SelectObject(DC, SaveFont);
    end;
  finally
    ReleaseDC(0, DC);
  end;
end;

function FontHeightPixel(FontHandle: THandle): Integer;
{ return in pixels the height of the font passed in FontHandle }
var
  DC: HDC;
  SaveFont: HFont;
  FontMetrics: TTextMetric;
begin
  DC := GetDC(0);
  SaveFont := SelectObject(DC, FontHandle);
  GetTextMetrics(DC, FontMetrics);
  Result := FontMetrics.tmHeight;
  SelectObject(DC, SaveFont);
  ReleaseDC(0, DC);
end;

function HigherOf(i, j: Integer): Integer;
{ returns the greater of two integers }
begin
  Result := i;
  if j > i then Result := j;
end;

function LowerOf(i, j: Integer): Integer;
{ returns the lesser of two integers }
begin
  Result := i;
  if j < i then Result := j;
end;

function Piece(const S: string; Delim: char; PieceNum: Integer): string;
{ returns the Nth piece (PieceNum) of a string delimited by Delim }
var
  i: Integer;
  Strt, Next: PChar;
begin
  i := 1;
  Strt := PChar(S);
  Next := StrScan(Strt, Delim);
  while (i < PieceNum) and (Next <> nil) do
  begin
    Inc(i);
    Strt := Next + 1;
    Next := StrScan(Strt, Delim);
  end;
  if Next = nil then Next := StrEnd(Strt);
  if i < PieceNum then Result := '' else SetString(Result, Strt, Next - Strt);
end;

procedure SetPiece(var x: string; Delim: Char; PieceNum: Integer; const NewPiece: string);
{ sets the Nth piece (PieceNum) of a string to NewPiece, adding delimiters as necessary }
var
  i: Integer;
  Strt, Next: PChar;
begin
  i := 1;
  Strt := PChar(x);
  Next := StrScan(Strt, Delim);
  while (i < PieceNum) and (Next <> nil) do
  begin
    Inc(i);
    Strt := Next + 1;
    Next := StrScan(Strt, Delim);
  end;
  if Next = nil then Next := StrEnd(Strt);
  if i < PieceNum
    then x := x + StringOfChar(Delim, PieceNum - i) + NewPiece
  else x := Copy(x, 1, Strt - PChar(x)) + NewPiece + StrPas(Next);
end;

function IntArrayToString(const IntArray: array of Integer): string;
{ converts an array of integers to a comma delimited string, 0 element assumed to be count }
var
  i: Integer;
begin
  Result := '';
  for i := 1 to IntArray[0] do Result := Result + IntToStr(IntArray[i]) + ',';
  if Length(Result) > 0 then Delete(Result, Length(Result), 1);
end;

procedure StringToIntArray(AString: string; var IntArray: array of Integer; AllowNeg: boolean = FALSE);
{ converts a string to an array of positive integers, count is kept in 0 element }
var
  ANum: Integer;
  APiece: string;
begin
  FillChar(IntArray, SizeOf(IntArray), 0);
  repeat
    if Pos(',', AString) > 0 then
    begin
      APiece := Copy(AString, 1, Pos(',', AString) - 1);
      Delete(AString, 1, Pos(',', AString));
    end else
    begin
      APiece := AString;
      AString := EmptyStr;
    end;
    ANum := StrToIntDef(Trim(APiece), 0);
    if (ANum > 0) or (AllowNeg and (ANum < 0)) then
    begin
      Inc(IntArray[0]);
      IntArray[IntArray[0]] := ANum;
    end;
  until (Length(AString) = 0) or (IntArray[0] = High(IntArray));
end;

function StringBetween(const x, First, Last: string): Boolean;
{ returns true if x collates between the strings First and Last, not case sensitive }
begin
  Result := True;
  if (CompareText(x, First) < 0) or (CompareText(x, Last) > 0) then Result := False;
end;

{ ItemTip callback ------------------------------------------------------------------------- }

function ItemTipKeyHook(Code: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT;
{ callback used to hide the item tip window whenever a key is pressed }
begin
  if lParam shr 31 = 0 then uItemTip.Hide; // hide only on key down
  Result := CallNextHookEx(uKeyHookHandle, Code, wParam, lParam);
end;

{ TItemTip --------------------------------------------------------------------------------- }

procedure AddItemTipRef; // kcm
begin
  if uItemTipCount = 0 then uItemTip := TItemTip.Create(Application); // all listboxes share a single ItemTip window
  Inc(uItemTipCount);
end;

procedure RemoveItemTipRef; // kcm
begin
  Dec(uItemTipCount);
  if (uItemTipCount = 0) and (uItemTip <> nil) then uItemTip.Free;
end;

constructor TItemTip.Create(AOwner: TComponent);
{ the windows hook allows the item tip window to be hidden whenever a key is pressed }
begin
  inherited Create(AOwner);
  uKeyHookHandle := SetWindowsHookEx(WH_KEYBOARD, ItemTipKeyHook, 0, GetCurrentThreadID);
end;

destructor TItemTip.Destroy;
{ disconnects the windows hook (callback) for keyboard events }
begin
  UnhookWindowsHookEx(uKeyHookHandle);
  inherited Destroy;
  uItemTip := nil;
end;

procedure TItemTip.CreateParams(var Params: TCreateParams);
{ makes the window so that is can be viewed but not activated (can't get events) }
begin
  inherited CreateParams(Params);
  Params.Style := WS_POPUP or WS_DISABLED or WS_BORDER;
  if uNewStyle then Params.ExStyle := WS_EX_TOOLWINDOW;
  Params.ExStyle := Params.ExStyle or WS_EX_TOPMOST; // - test this!!
end;

procedure TItemTip.Paint;
{ displays the caption property for the window within the window }
var
  AString: string;
  y: integer;

begin
  AString := Caption;
  with Canvas do
  begin
    SetBkMode(Handle, TRANSPARENT);
    FillRect(ClientRect);
    y := ((ClientRect.Bottom - ClientRect.Top) - FontHeightPixel(Canvas.Font.Handle)) div 2;
    //TextOut(ClientRect.Left + 1, ClientRect.Top - 1, AString);
// WARNING - Do NOT change the X pos or the tab starting pos - this will cause a missmatch
// between the hint window and what the control displayes
    TabbedTextOut(Handle, 0, y, PChar(AString), Length(AString), MAX_TABS + 1, FTabs[0], 0);
  end;
end;

procedure TItemTip.Hide;
{ hides the tip window and makes sure the listbox isn't still capturing the mouse }
begin
  if FShowing then
  begin
    { The listbox should retain mousecapture if the left mouse button is still down or it
      is the dropdown list for a combobox.  Otherwise, click events don't get triggered. }
    with FListBox do if not (csLButtonDown in ControlState) and (FParentCombo = nil)
      then MouseCapture := False;
    ShowWindow(Handle, SW_HIDE);
    FShowing := False;
  end;
end;

procedure TItemTip.GetTabSettings;
var
  DX, X, i, count: integer;

begin
  Count := FListBox.FTabPix[0];
  FTabs[0] := 1; // Set first tab stop to location 1 for display purposes
  if (Count = 1) then
  begin
    DX := FListBox.FTabPix[1];
    X := (DX * 2) - 1;
  end
  else
  begin
    DX := FontWidthPixel(FListBox.Font.Handle) * 8; // windows tab default is 8 chars
    X := FListBox.FTabPix[Count];
    X := Trunc(X / DX) + 1;
    X := (X * DX) - 1; // get the next tab position after that which is specified
  end;
  for i := 1 to MAX_TABS do
  begin
    if (i <= Count) then
      FTabs[i] := FListBox.FTabPix[i] - 1
    else
    begin
      FTabs[i] := X;
      inc(X, DX);
    end;
  end;
end;

procedure TItemTip.UpdateText(CatchMouse: Boolean);
var
  AWidth, ListClientWidth, X: Integer;
  sr: TRect;

begin
  Cursor := FListBox.Cursor;
  Canvas.Font := FListBox.Font;
  if FSelected then
  begin
    Canvas.Brush.Color := clHighlight;
    Canvas.Font.Color := clHighlightText;
  end else // the item is not selected
  begin
    Canvas.Brush.Color := FListBox.ItemTipColor;
    Canvas.Font.Color := clWindowText;
  end;
  Caption := #9 + FListBox.DisplayText[FListItem];
  if Copy(Caption, 1, 2) = '__' then Caption := ' '; // so separators don't extend past window

  GetTabSettings;

  AWidth := LOWORD(GetTabbedTextExtent(Canvas.Handle, PChar(Caption), Length(Caption),
    MAX_TABS + 1, FTabs[0]));
  // inherent scrollbar may not always be visible in a long list
  if FListBox.LongList
    then ListClientWidth := ClientWidthOfList(FListBox)
  else ListClientWidth := FListBox.ClientWidth;
  X := FPoint.X;
  if (FListBox.FCheckBoxes) then
  begin
    dec(ListClientWidth, CheckWidth);
    inc(X, CheckWidth);
  end;
  if AWidth > ListClientWidth then
    Inc(AWidth, 4)
  else
    AWidth := ListClientWidth;
//  if SystemParametersInfo(SPI_GETWORKAREA, 0, @sr, 0) then
  if assigned(Screen.MonitorFromWindow(FListBox.Handle)) then
  begin
    sr := Screen.MonitorFromWindow(FListBox.Handle).WorkareaRect;
    if AWidth < (sr.Right - sr.Left) then
    begin
      if (X + AWidth) > sr.Right then
        X := sr.Right - AWidth;
    end
    else
      X := sr.Left;
  end;
  FShowing := True;
  if (GetCaptureControl = nil) and CatchMouse then FListBox.MouseCapture := True;
  SetWindowPos(Handle, HWND_TOP, X, FPoint.Y, AWidth, FListBox.ItemHeight,
    SWP_SHOWWINDOW or SWP_NOACTIVATE);
  Invalidate;
end;

procedure TItemTip.WMMouseWheel(var Message: TMessage);
begin
  Hide;
  if assigned(FListBox) then
    with Message do
      SendMessage(FListBox.Handle, Msg, WParam, LParam);
end;

procedure TItemTip.Show(AListBox: TORListBox; AnItem: Integer; APoint: TPoint;
  CatchMouse: Boolean);
{ sets the canvas properties and window size and text depending on the item in the listbox }
begin
  if not AListBox.Visible then Exit; // added to support DropDown lists
  FListBox := AListBox;
  FListItem := AnItem;
  FPoint := APoint;
  if FListItem > -1 then
   FSelected := (FListBox.Perform(LB_GETSEL, FListItem, 0) > 0)
  else
   FSelected := false;
  UpdateText(CatchMouse);
end;

type
  TORCBImgIdx = (iiUnchecked, iiChecked, iiGrayed, iiQMark, iiBlueQMark,
    iiDisUnchecked, iiDisChecked, iiDisGrayed, iiDisQMark,
    iiFlatUnChecked, iiFlatChecked, iiFlatGrayed,
    iiRadioUnchecked, iiRadioChecked, iiRadioDisUnchecked, iiRadioDisChecked);

const
  CheckBoxImageResNames: array[TORCBImgIdx] of PChar = (
    'ORCB_UNCHECKED', 'ORCB_CHECKED', 'ORCB_GRAYED', 'ORCB_QUESTIONMARK',
    'ORCB_BLUEQUESTIONMARK', 'ORCB_DISABLED_UNCHECKED', 'ORCB_DISABLED_CHECKED',
    'ORCB_DISABLED_GRAYED', 'ORCB_DISABLED_QUESTIONMARK',
    'ORLB_FLAT_UNCHECKED', 'ORLB_FLAT_CHECKED', 'ORLB_FLAT_GRAYED',
    'ORCB_RADIO_UNCHECKED', 'ORCB_RADIO_CHECKED',
    'ORCB_RADIO_DISABLED_UNCHECKED', 'ORCB_RADIO_DISABLED_CHECKED');

  BlackCheckBoxImageResNames: array[TORCBImgIdx] of PChar = (
    'BLACK_ORLB_FLAT_UNCHECKED', 'BLACK_ORLB_FLAT_CHECKED', 'BLACK_ORLB_FLAT_GRAYED',
    'BLACK_ORCB_QUESTIONMARK', 'BLACK_ORCB_BLUEQUESTIONMARK',
    'BLACK_ORCB_DISABLED_UNCHECKED', 'BLACK_ORCB_DISABLED_CHECKED',
    'BLACK_ORCB_DISABLED_GRAYED', 'BLACK_ORCB_DISABLED_QUESTIONMARK',
    'BLACK_ORLB_FLAT_UNCHECKED', 'BLACK_ORLB_FLAT_CHECKED', 'BLACK_ORLB_FLAT_GRAYED',
    'BLACK_ORCB_RADIO_UNCHECKED', 'BLACK_ORCB_RADIO_CHECKED',
    'BLACK_ORCB_RADIO_DISABLED_UNCHECKED', 'BLACK_ORCB_RADIO_DISABLED_CHECKED');

var
  ORCBImages: array[TORCBImgIdx, Boolean] of TBitMap;

function GetORCBBitmap(Idx: TORCBImgIdx; BlackMode: boolean): TBitmap;
var
  ResName: string;
begin
  if (not assigned(ORCBImages[Idx, BlackMode])) then
  begin
    ORCBImages[Idx, BlackMode] := TBitMap.Create;
    if BlackMode then
      ResName := BlackCheckBoxImageResNames[Idx]
    else
      ResName := CheckBoxImageResNames[Idx];
    ORCBImages[Idx, BlackMode].LoadFromResourceName(HInstance, ResName);
  end;
  Result := ORCBImages[Idx, BlackMode];
end;

procedure DestroyORCBBitmaps; far;
var
  i: TORCBImgIdx;
  mode: boolean;

begin
  for i := low(TORCBImgIdx) to high(TORCBImgIdx) do
  begin
    for Mode := false to true do
    begin
      if (assigned(ORCBImages[i, Mode])) then
        ORCBImages[i, Mode].Free;
    end;
  end;
end;

{ TORStrings }

function TORStrings.Add(const S: string): integer;
var
  RealVerification: Boolean;
begin
  RealVerification := Verification;
  Verification := False; //Disable verification while lists are not matched
  result := FPlainText.Add(Translator(S));
  Verification := RealVerification;
  MList.Insert(result, S); //Don't need to here because MList never gets custom handlers
end;

procedure TORStrings.Clear;
var
  RealVerification: Boolean;
begin
  Verify;
  MList.Clear;
  RealVerification := Verification;
  Verification := False;
  FPlainText.Clear;
  Verification := RealVerification;
end;

constructor TORStrings.Create(PlainText: TStrings; Translator: TTranslator);
begin
  inherited create;
  MList := TStringList.Create;
  FPlainText := PlainText;
  FTranslator := Translator;
  FVerification := False;
end;

procedure TORStrings.Delete(index: integer);
var
  RealVerification: Boolean;
begin
  Verify;
  MList.Delete(index);
  RealVerification := Verification;
  Verification := False;
  FPlainText.Delete(index);
  Verification := RealVerification;
end;

destructor TORStrings.Destroy;
begin
  MList.Free;
  inherited;
end;

function TORStrings.Get(index: integer): string;
begin
  Verify;
  result := MList[index];
end;

function TORStrings.GetCount: integer;
begin
  Verify;
  result := MList.Count;
end;

function TORStrings.GetObject(index: integer): TObject;
begin
  Verify;
  result := FPlainText.Objects[index];
end;

function TORStrings.IndexOf(const S: string): Integer;
begin
  Verify;
  Result := FPlainText.IndexOf(S);
end;

procedure TORStrings.Insert(Index: Integer; const S: string);
var
  RealVerification: Boolean;
begin
  Verify;
  MList.Insert(index, S);
  RealVerification := Verification;
  Verification := False;
  FPlainText.Insert(index, Translator(S));
  Verification := RealVerification;
end;


procedure TORStrings.Put(Index: Integer; const S: string);
var
  RealVerification: Boolean;
begin //If this method weren't overridden, the listbox would forget which item was selected.
  MList[Index] := S;
  RealVerification := Verification;
  Verification := False; //Disable verification while lists are not matched
  FPlainText[Index] := Translator(S);
  Verification := RealVerification;
end;

procedure TORStrings.PutObject(index: integer; Value: TObject);
begin
  FPlainText.Objects[index] := Value;
end;

procedure TORStrings.SetUpdateState(Value: boolean);
begin
  if Value then
    FPlainText.BeginUpdate
  else
    FPlainText.EndUpdate;
end;

procedure TORStrings.Verify;
var
  Errors: TStringList;
  i: integer;
  M: string;
  Plain: string;
  TotalCount: integer;
begin
  if Verification then begin
    if not Assigned(FPlainText) then
      raise Exception.Create('ORStrings is missing PlainText property.');
    if not Assigned(FTranslator) then
      raise Exception.Create('ORStrings is missing Translator property.');
    Errors := TStringList.Create;
    try
      TotalCount := MList.Count;
      if MList.Count <> PlainText.Count then begin
        Errors.Add('M string count:' + IntToStr(MList.Count));
        Errors.Add('Plain string count:' + IntToStr(PlainText.Count));
        if PlainText.Count > TotalCount then
          TotalCount := PlainText.Count;
      end;
      for i := 0 to TotalCount - 1 do begin
        if i >= MList.Count then
          Errors.Add('PlainText[' + IntToStr(i) + ']: ' + PlainText[i])
        else if i >= PlainText.Count then
          Errors.Add('ORStrings[' + IntToStr(i) + ']: ' + Translator(MList[i]))
        else begin
          M := Translator(MList[i]);
          Plain := PlainText[i];
          if M <> Plain then begin
            if UpperCase(M) = UpperCase(Plain) then //Listboxes don't always sort cases right, so we give them a little help here.
            begin
              PlainText[i] := M;
            end
            else
            begin
              Errors.Add('PlainText[' + IntToStr(i) + ']: ' + Plain);
              Errors.Add('ORStrings[' + IntToStr(i) + ']: ' + M);
            end;
          end;
        end;
      end;
      if Errors.Count > 0 then begin
        Errors.Insert(0, 'OR strings are out of sync with plain text strings :');
        raise Exception.Create(Errors.Text);
      end;
    finally
      Errors.Free;
    end;
  end;
end;

{ TORListBox ------------------------------------------------------------------------------- }

constructor TORListBox.Create(AOwner: TComponent);
{ sets initial values for fields used by added properties (ItemTip, Reference, Tab, LongList) }
begin
  inherited Create(AOwner);
  FUseExactSearch := False;
  AddItemTipRef; // kcm
  FTipItem := -1;
  FItemTipColor := clWindow;
  FItemTipEnable := True;
  FLastItemIndex := -1;
  FFromSelf := False;
  FDelimiter := '^';
  FWhiteSpace := ' ';
  FLongList := False;
  FFromNeedData := False;
  FFirstLoad := True;
  FCurrentTop := -1;
  FFocusIndex := -1;
  FNonSelectedIndex := -1;
  ShowHint := True;
  FHideSynonyms := FALSE;
  FSynonymChars := '<>';
  FTabPosInPixels := False;
  FRightClickSelect := FALSE;
  FCheckBoxes := FALSE;
  FFlatCheckBoxes := TRUE;
  FCaseChanged := TRUE;
  FLookupPiece := 0;
  FIsPartOfComboBox := False;
  FFromSetFocusIndex := False;
  //Holds all ItemRecs for memory cleanup
  ItemRecList := TList.Create;
  FDetectLastEmpty := False;
  FKeepItemID := False;
  FLastItemID := '';
end;

destructor TORListBox.Destroy;
{ ensures that the special records associated with each listbox item are disposed }
var
 I: integer;
begin
  FMItems.Free;
  if uItemTip <> nil then uItemTip.Hide;
  DestroyItems;
  RemoveItemTipRef; //kcm
  //Clean up itemrecs
  for I := 0 to ItemRecList.Count - 1 do
   if Assigned(ItemRecList[i]) then
    Dispose(ItemRecList[i]);
  ItemRecList.Free;
  inherited Destroy;
end;

procedure TORListBox.CreateParams(var Params: TCreateParams);
{ ensures that the listbox can support tab stops }
begin
  inherited CreateParams(Params);
  with Params do Style := Style or LBS_USETABSTOPS;
end;

procedure TORListBox.CreateWnd;
{ makes sure that actual (rather than 'intercepted') values are restored from FSaveItems
  (FSaveItems is part of TCustomListBox), necessary if window is recreated by property change
  also gets the first bolus of data in the case of a LongList }
var
  RealVerification: Boolean;
begin
  FFromSelf := True;
  RealVerification := True;
  if Assigned(FMItems) then
  begin
    RealVerification := FMItems.Verification;
    FMItems.Verification := False;
  end;
  inherited CreateWnd;
  if Assigned(FMItems) then
  begin
    FMItems.Verification := RealVerification;
    FMItems.Verify;
  end;
  FFromSelf := False;
  if FTabPos[0] > 0 then SetTabStops;
end;

procedure TORListBox.Loaded;
{ after the properties are loaded, get the first data bolus for a LongList }
begin
  inherited;
  if FLongList then FWaterMark := Items.Count;
  SetTabStops;
end;

procedure TORListBox.DestroyWnd;
{ makes sure that actual (rather than 'intercepted') values are saved to FSaveItems
  (FSaveItems is part of TCustomListBox), necessary if window is recreated by property change }
begin
  FFromSelf := True;
  inherited DestroyWnd;
  FFromSelf := False;
end;

function TORListBox.TextToShow(S: string): string;
{ returns the text that will be displayed based on the Pieces and TabPosition properties }
var
  i: Integer;
begin
  if FPieces[0] > 0 then
  begin
    Result := '';
    for i := 1 to FPieces[0] do
      Result := Result + Piece(S, FDelimiter, FPieces[i]) + FWhiteSpace;
    Result := TrimRight(Result);
  end
  else
  begin
    SetString(Result, PChar(S), Length(S));
  end;
end;

function TORListBox.IsSynonym(const TestStr: string): boolean;
var
  i, cnt, len: integer;

begin
  Result := FALSE;
  if ((FHideSynonyms) and (FSynonymChars <> '')) then
  begin
    len := length(FSynonymChars);
    cnt := 0;
    for i := 1 to len do
      if (pos(FSynonymChars[i], TestStr) > 0) then inc(cnt);
    if (cnt = len) then Result := TRUE;
    if assigned(FOnSynonymCheck) then
      FOnSynonymCheck(Self, TestStr, Result);
  end;
end;

function TORListBox.GetDisplayText(Index: Integer): string;
{ get the item string actually displayed by the listbox rather than what is in Items[n] }
var
  Len1, Len2: Integer;
  Buf: array of Char;

begin
  Result := '';
  Len2 := 0;
  FFromSelf := True;
  try
    Len1 := SendMessage(Handle, LB_GETTEXTLEN, Index, 0);
    if Len1 > 0 then
    begin
      SetLength(Buf, Len1 + 1);
      Len2 := SendMessage(Handle, LB_GETTEXT, Index, Integer(@Buf[0]));
    end;
  finally
    FFromSelf := False;
  end;
  if Len2 > 0 then
    SetString(Result, PChar(@Buf[0]), Len2);
  if Len1 > 0 then
    SetLength(Buf, 0);
end;

function TORListBox.GetDynamicProperty(PropertyID: integer): string;
begin
  if PropertyID = DynaPropAccesibilityCaption then
    Result := GetCaption
  else
    Result := '';
end;

// The following 7 message handling procedures essentially reimplement the TListBoxStrings
// object found in StdCtrls.  They do this by intercepting the messages sent by the
// TListBoxStrings object and modifying the contents of WParam, LParam, and Result.
// This allows TORListBox to use the ItemData pointer that is part of each listbox item
// to store its own information yet let the application still use the Objects property
// of standard Delphi listboxes.  It also makes it possible to implement the Pieces and
// TabPosition properties without forcing the listbox to be owner drawn.

procedure TORListBox.LBGetItemData(var Message: TMessage);
{ intercept LB_GETITEMDATA and repoint to UserObject rather than internal value in ItemData }
var
  ItemRec: PItemRec;
begin
  inherited;
  if not FFromSelf then with Message do
    begin
      ItemRec := PItemRec(Result);
      if (assigned(ItemRec)) and assigned(ItemRec^.UserObject) then
        Result := Integer(ItemRec^.UserObject)
      else
        Result := 0;
    end;
end;

procedure TORListBox.LBSetItemData(var Message: TMessage);
{ intercept LB_SETITEMDATA as save object in UserObject since ItemData is used interally }
var
  ItemRec: PItemRec;
begin
  if not FFromSelf then
    begin
      FFromSelf := True;
      ItemRec := PItemRec(SendMessage(Handle, LB_GETITEMDATA, Message.WParam, 0)); // WParam: list index
      FFromSelf := False;
      if (assigned(ItemRec)) then
        ItemRec^.UserObject := TObject(Message.LParam);
      Message.LParam := Integer(ItemRec);
      if assigned(uItemTip) and uItemTip.FShowing and (uItemTip.FListBox = Self)
        and (uItemTip.FListItem = Integer(Message.WParam)) then
        uItemTip.UpdateText(FALSE);
    end;
  inherited;
end;

procedure TORListBox.LBGetText(var Message: TMessage);
{ intercept LB_GETTEXT and repoint to full item string rather than what's visible in listbox }
var
  ItemRec: PItemRec;
  Text: string;
begin
  inherited;
  if (not FFromSelf) and (Message.Result <> LB_ERR) then with Message do
    begin
      FFromSelf := True;
      ItemRec := PItemRec(SendMessage(Handle, LB_GETITEMDATA, WParam, 0)); // WParam: list index
      FFromSelf := False;
      if (assigned(ItemRec)) then
      begin
        FFromSelf := True;
        Text := TListBox(self).Items[WParam];
        StrCopy(PChar(LParam), PChar(Text)); // LParam: points string buffer
        Result := Length(Text); // Result: length of string
        FFromSelf := False;
      end
      else
      begin
        StrPCopy(PChar(LParam), '');
        Result := 0;
      end;
    end;
end;

procedure TORListBox.LBGetTextLen(var Message: TMessage);
{ intercept LB_GETTEXTLEN and return true length of ItemRec^.FullText }
{ -- in response to HOU-0299-70576, Thanks to Stephen Kirby for this fix! }
var
  ItemRec: PItemRec;
begin
  inherited;
  if (not FFromSelf) and (Message.Result <> LB_ERR) then with Message do
    begin
      FFromSelf := True;
      ItemRec := PItemRec(SendMessage(Handle, LB_GETITEMDATA, WParam, 0));
      if (assigned(ItemRec)) then
        Result := Length(TListBox(self).Items[WParam]) // Result:length of string
      else
        Result := 0;
      FFromSelf := False;
    end;
end;

procedure TORListBox.LBAddString(var Message: TMessage);
{ intercept LB_ADDSTRING and save full string in separate record.  Then rebuild a string that
  has what's visible (based on Pieces, TabPosition properties) and substitute that in LParam }
var
  ItemRec: PItemRec;
  ItemPos: Integer;
begin
  if not FFromSelf then
  begin
    if FLongList then // -- special long list processing - begin
    begin
      if FFromNeedData then FDataAdded := True else with Message do
        begin
          WParam := FWaterMark;
          Result := Perform(LB_INSERTSTRING, WParam, LParam); // always insert into short list
          Exit;
        end;
    end; // -- special long list processing - end
    New(ItemRec);
    //Add to our ItemRec List
    ItemRecList.Add(ItemRec);

    with ItemRec^, Message do
    begin
      UserObject := nil;
      CheckedState := cbUnchecked;
      FCreatingText := PChar(LParam);
    end;
    FCreatingItem := TRUE;
    inherited;
    FCreatingItem := FALSE;
    // insert into list AFTER calling inherited in case the listbox is sorted
    DoChange;
    with Message do if Result <> LB_ERR then
      begin
        FFromSelf := True;
        SendMessage(Handle, LB_SETITEMDATA, Result, Integer(ItemRec)); // Result: new item index
        FFromSelf := False;
      end
      else begin
       ItemPos := ItemRecList.IndexOf(ItemRec);
       ItemRecList.Delete(ItemPos);
       Dispose(ItemRec);
      end;

  end
  else inherited;
end;

procedure TORListBox.LBInsertString(var Message: TMessage);
{ intercepts LB_INSERTSTRING, similar to LBAddString except for special long list processing }
var
  ItemRec: PItemRec;
  ItemPos: Integer;
begin
  if not FFromSelf then
  begin
    if FLongList then // -- special long list processing - begin
    begin
      if FFromNeedData then
      begin
        FDataAdded := True;
        Inc(FCurrentTop);
      end
      else with Message do
        begin
          if Integer(WParam) > FWaterMark then
          begin // make sure insert above watermark
            FMItems.MList.Move(WParam, FWaterMark);
            WParam := FWaterMark;
          end;
          Inc(FWaterMark);
        end;
    end; // -- special long list processing - end
    New(ItemRec);
    //Add to our ItemRec List
    ItemRecList.Add(ItemRec);

    with ItemRec^, Message do
    begin
      UserObject := nil;
      CheckedState := cbUnchecked;
      FCreatingText := PChar(LParam);
    end;
    FCreatingItem := TRUE;
    inherited;
    FCreatingItem := FALSE;
    DoChange;
    with Message do if Result <> LB_ERR then
      begin
        FFromSelf := True;
        SendMessage(Handle, LB_SETITEMDATA, Result, Integer(ItemRec)); // Result: new item index
        FFromSelf := False;
      end
      else begin
       ItemPos := ItemRecList.IndexOf(ItemRec);
       ItemRecList.Delete(ItemPos);
       Dispose(ItemRec);
      end;

  end
  else inherited;
end;

procedure TORListBox.LBDeleteString(var Message: TMessage);
{ intercept LB_DELETESTRING and dispose the record associated with the item being deleted }
var
  ItemRec: PItemRec;
  ItemPos: Integer;
begin
  with Message do
  begin
    FFromSelf := True;
    ItemRec := PItemRec(SendMessage(Handle, LB_GETITEMDATA, WParam, 0)); // WParam: list index
    FFromSelf := False;
    if (assigned(ItemRec)) then
    begin
      if FLongList and not FFromNeedData then
        Dec(FWaterMark);
      ItemPos := ItemRecList.IndexOf(ItemRec);
      ItemRecList.Delete(ItemPos);

      Dispose(ItemRec);
    end;
    if (not FKeepItemID) and (FLastItemID <> '') and (Integer(wParam) > -1) and
      (Integer(wParam) < Items.count) and (CompareText(FLastItemID, Items[wParam]) = 0) then
      FLastItemID := '';
  end;
  FFromSelf := True; // FFromSelf is set here because, under NT, LBResetContent is called
  inherited; // when deleting the last string from the listbox.  Since ItemRec is
  FFromSelf := False; // already disposed, it shouldn't be disposed again.
  DoChange;
end;

procedure TORListBox.LBResetContent(var Message: TMessage);
{ intercept LB_RESETCONTENT (list is being cleared) and dispose all records }
var
  ItemCount, i: Integer;
  ItemRec: PItemRec;
  ItemPos: Integer;
begin
  if not FFromSelf then
  begin
    ItemCount := Perform(LB_GETCOUNT, 0, 0);
    for i := 0 to ItemCount - 1 do
    begin
      FFromSelf := True;
      ItemRec := PItemRec(SendMessage(Handle, LB_GETITEMDATA, i, 0));
      FFromSelf := False;
      ItemPos := ItemRecList.IndexOf(ItemRec);
       ItemRecList.Delete(ItemPos);

      Dispose(ItemRec);
    end;
    Perform(LB_SETCOUNT, 0, 0);
  end;
  // This was causing pain for ResetItems when FWaterMark was being cleared for short lists
  // Only clear FWaterMark if we aren't recreating the items
  if FLongList and not FIsInLoadRecreateItems then
    FWaterMark := 0;
  inherited;
end;

procedure TORListBox.LBSetCurSel(var Message: TMessage);
{ call DoChange, which calls OnChange event whenever ItemIndex changes }
begin
  inherited;
  DoChange;
end;

procedure TORListBox.CMFontChanged(var Message: TMessage);
{ make sure itemtip and tabs respond to characteristics of the new font }
begin
  inherited;
  FLargeChange := (Height div ItemHeight) - 1;
  SetTabStops;
end;

procedure TORListBox.WMKeyDown(var Message: TWMKeyDown);
{ intercept the keydown messages so that the listbox can be navigated by using the arrow
  keys and shifting the focus rectangle rather than generating Click for each keypress }
var
  IsSelected: LongBool;
begin
  // DRM - INC0419622 - Force calculation of FLargeChange
  FLargeChange := (Height div ItemHeight) - 1;
  // DRM ---
  //if Message.CharCode in [VK_RETURN, VK_ESCAPE] then inherited;  // ignore other keys
  case Message.CharCode of
    VK_LBUTTON, VK_RETURN, VK_SPACE:
      begin
        if (FocusIndex < 0) and (CheckBoxes or MultiSelect) and (Count > 0) then // JNM - 508 compliance
          SetFocusIndex(0);
        if FocusIndex > -1 then
        begin
          if MultiSelect then
          begin
            IsSelected := LongBool(Perform(LB_GETSEL, FocusIndex, 0));
            Perform(LB_SETSEL, Longint(not IsSelected), FocusIndex);
          end
          else Perform(LB_SETCURSEL, FocusIndex, 0);
        // Send WM_COMMAND here because LBN_SELCHANGE not triggered by LB_SETSEL
        // and LBN_SELCHANGE is what eventually triggers the Click event.
        // The LBN_SELCHANGE documentation implies we should send the control id, which is
        // 32 bits long, in the high word of WPARAM (16 bits).  Since that won't work - we'll
        // try sending the item index instead.
        //PostMessage() not SendMessage() is Required here for checkboxes, SendMessage() doesn't
        //Allow the Checkbox state on the control to be updated
          if CheckBoxes then
            PostMessage(Parent.Handle, WM_COMMAND, MAKELONG(FocusIndex, LBN_SELCHANGE), LPARAM(Handle))
          else
            SendMessage(Parent.Handle, WM_COMMAND, MAKELONG(FocusIndex, LBN_SELCHANGE), LPARAM(Handle));
        end;
      end;
    VK_PRIOR: SetFocusIndex(FocusIndex - FLargeChange);
    VK_NEXT: SetFocusIndex(FocusIndex + FLargeChange);
    VK_END: SetFocusIndex(SFI_END);
    VK_HOME: SetFocusIndex(SFI_TOP);
    VK_LEFT, VK_UP: SetFocusIndex(FocusIndex - 1);
    VK_RIGHT, VK_DOWN: SetFocusIndex(FocusIndex + 1);
  else inherited;
  end;
  Message.Result := 0;
end;

procedure TORListBox.WMLButtonDown(var Message: TWMLButtonDown);
{ work around for a very ugly problem when the listbox is used with a dropdown combobox
  when the listbox is used this way (parent=desktop) the click events seem to be ignored }
var
  AnItem: Integer;
  ScrollRect, ListRect: TRect;
  ScreenPoint: TSmallPoint;
  TmpRect: TRect;
begin
  if FParentCombo <> nil then with Message do
    begin
      FDontClose := FALSE;
      ListRect := ClientRect; //+
      if FLongList then ListRect.Right := ListRect.Left + ClientWidthOfList(Self); //+
    // if the mouse was clicked in the client area set ItemIndex ourselves
      if PtInRect(ListRect, Point(XPos, YPos)) then //~
      begin
        AnItem := GetIndexFromY(YPos);
        if AnItem < Items.Count then ItemIndex := AnItem;
        FParentCombo.FwdClick(FParentCombo);
        FDontClose := TRUE;
      end;
    // if the mouse was clicked on the scrollbar, send a message to make the scrolling happen
    // this is done with WM_NCLBUTTONDOWN, which is ignored if mousecapture is on, so we have
    // to turn mousecapture off, then back on since it's needed to hide the listbox
      with ListRect do ScrollRect := Rect(Right + 1, Top, Self.Width - 2, Bottom); //~
      if {(Items.Count > (FLargeChange + 1)) and} PtInRect(ScrollRect, Point(XPos, YPos)) then //~
      begin
        if FLongList then // for long lists
        begin
          ScreenPoint := PointToSmallPoint(FScrollBar.ScreenToClient(
            Self.ClientToScreen(Point(XPos, YPos))));
          MouseCapture := False;
          SendMessage(FScrollBar.Handle, WM_LBUTTONDOWN, Message.Keys,
            MakeLParam(ScreenPoint.X, ScreenPoint.Y));
          MouseCapture := True;
        end else // for normal lists
        begin
          ScreenPoint := PointToSmallPoint(Self.ClientToScreen(Point(XPos, YPos)));
          MouseCapture := False;
          SendMessage(Self.Handle, WM_NCLBUTTONDOWN, HTVSCROLL,
            MakeLParam(ScreenPoint.X, ScreenPoint.Y));
          MouseCapture := True;
        end;
      end
      else
        if (FCheckBoxes) then
        begin
          TmpRect := ListRect;
          TmpRect.Top := TmpRect.Bottom;
          TmpRect.Right := TmpRect.Left + Width;
          inc(TmpRect.Bottom, CheckComboBtnHeight);
          if PtInRect(TmpRect, Point(XPos, YPos)) then
          begin
            inc(TmpRect.Left, (TmpRect.right - TmpRect.Left) div 2);
            FParentCombo.DropPanelBtnPressed(XPos <= TmpRect.Left, FALSE);
          end;
        end;
    end;
  inherited;
end;

procedure TORListBox.WMLButtonUp(var Message: TWMLButtonUp);
{ If the listbox is being used with a dropdown combo, hide the listbox whenever something is
  clicked.  The mouse is captured at this point - this isn't called if clicking scrollbar. }
begin
  if (FParentCombo <> nil) and ((not FDontClose) or (not FCheckBoxes)) then FParentCombo.DroppedDown := False;
  FDontClose := FALSE;
  inherited;
end;

procedure TORListBox.WMRButtonUp(var Message: TWMRButtonUp);
{ When the RightClickSelect property is true, this routine is used to select an item }
var
  AnItem: Integer;
  ListRect: TRect;

begin
  if (FRightClickSelect and (FParentCombo = nil)) then with Message do // List Boxes only, not Combo Boxes
    begin
      ListRect := ClientRect; //+
      if FLongList then ListRect.Right := ListRect.Left + ClientWidthOfList(Self); //+
    // if the mouse was clicked in the client area set ItemIndex ourselves
      if PtInRect(ListRect, Point(XPos, YPos)) then //~
      begin
        AnItem := GetIndexFromY(YPos);
        if AnItem >= Items.Count then AnItem := -1;
      end
      else
        AnItem := -1;
      ItemIndex := AnItem;
    end;
  inherited;
end;

procedure TORListBox.WMLButtonDblClk(var Message: TWMLButtonDblClk);
{ treat a doubleclick in the scroll region as if it were a single click - see WMLButtonDown }
var
  ScrollRect: TRect;
  ScreenPoint: TSmallPoint;
begin
  if FParentCombo <> nil then with Message do
    begin
      if (FCheckBoxes) then FDontClose := TRUE;
      // DRM - INC0419622 - Force calculation of FLargeChange
      FLargeChange := (Height div ItemHeight) - 1;
      // DRM ---
    // if the mouse was clicked on the scrollbar, send a message to make the scrolling happen
    // this is done with WM_NCLBUTTONDOWN, which is ignored if mousecapture is on, so we have
    // to turn mousecapture off, then back on since it's needed to hide the listbox
      with ClientRect do ScrollRect := Rect(Right + 1, Top, Self.Width - 2, Bottom);
      if (Items.Count > (FLargeChange + 1)) and PtInRect(ScrollRect, Point(XPos, YPos)) then
      begin
        if FLongList then // for long lists
        begin
          ScreenPoint := PointToSmallPoint(FScrollBar.ScreenToClient(
            Self.ClientToScreen(Point(XPos, YPos))));
          MouseCapture := False;
          SendMessage(FScrollBar.Handle, WM_LBUTTONDOWN, Message.Keys,
            MakeLParam(ScreenPoint.X, ScreenPoint.Y));
          MouseCapture := True;
        end else // for normal lists
        begin
          ScreenPoint := PointToSmallPoint(Self.ClientToScreen(Point(XPos, YPos)));
          MouseCapture := False;
          SendMessage(Self.Handle, WM_NCLBUTTONDOWN, HTVSCROLL,
            MakeLParam(ScreenPoint.X, ScreenPoint.Y));
          MouseCapture := True;
        end; {if FLongList}
      end; {if (Items.Count)}
    end; {if FParentCombo}
  inherited;
end;

procedure TORListBox.WMCancelMode(var Message: TMessage);
{ This message is sent when focus shifts to another window - need to hide the listbox at this
  point if it is being used with a dropdown combobox. }
begin
  uItemTip.Hide;
  if FParentCombo <> nil then FParentCombo.DroppedDown := False;
  inherited;
end;

procedure TORListBox.WMMove(var Message: TWMMove);
{ whenever in LongList mode we need to move the scrollbar along with the listbox }
begin
  inherited;
  if FScrollBar <> nil then AdjustScrollBar;
end;

procedure TORListBox.WMSize(var Message: TWMSize);
{ calculate the number of visible items in the listbox whenever it is resized
  if in LongList mode, size the scrollbar to match the listbox }
begin
  inherited;
  FLargeChange := (Message.Height div ItemHeight) - 1;
  if FScrollBar <> nil then AdjustScrollBar;
end;

procedure TORListBox.WMVScroll(var Message: TWMVScroll);
{ makes sure the itemtip is hidden whenever the listbox is scrolled }
// it would be better if this was done right away (before endscroll, but it seems to mess
// up mouse capture  (SaveCaptureControl, HideItemTip, RestoreCaptureControl?)
begin
  inherited;
  if Message.ScrollCode = SB_ENDSCROLL then uItemTip.Hide;
end;

procedure TORListBox.WMMouseWheel(var Message: TMessage);
{ makes sure the itemtip is hidden whenever the listbox is scrolled
  *SMT*
  This is added to keep consistent with other types of scrolling.
  we want to hide the ItemTip when the mouse wheel is scrolled.}

var
  idx, max, temp: integer;
  ScrollCode: TScrollCode;

begin
  if Message.wParam <> 0 then
  begin
    if assigned(uItemTip) then
      uItemTip.Hide;
    max := (abs(Integer(Message.wParam)) shr 16) div 40;
    if integer(Message.wParam) > 0 then
      ScrollCode := scLineUp
    else
      ScrollCode := scLineDown;
    temp := 50;
    FDetectLastEmpty := True;
    try
      for idx := 1 to max do
        ScrollTo(Self, ScrollCode, temp);
    finally
      FDetectLastEmpty := False;
    end;
  end
  else
    inherited;
end;

procedure TORListBox.CMHintShow(var Message: TMessage);
{ if ShowHint is used to delay showing tip, starts showing ItemTip when hint timer expires }
var
  APoint: TPoint;
begin
  inherited;
  FItemTipActive := True;
  GetCursorPos(APoint);
  APoint := ScreenToClient(APoint);
  MouseMove([], APoint.X, APoint.Y); // assume nothing in ShiftState for now
end;

procedure TORListBox.Click;
begin
  inherited Click;
  DoChange;
end;

procedure TORListBox.DoChange;
{ call the OnChange Event if ItemIndex is changed }
begin
  if ItemIndex <> FLastItemIndex then
  begin
    FLastItemIndex := ItemIndex;
    if FLongList then
    begin
      if (ItemIndex > -1) then
        FLastItemID := Items[ItemIndex]
      else if not FKeepItemID then
        FLastItemID := '';
    end;
    if (not isPartOfComboBox) and (ItemIndex <> -1) then
      SetFocusIndex(ItemIndex);
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TORListBox.DoEnter;
{ display the item tip window when the listbox gets keyboard focus - if itemtip enabled }
begin
  //if Items.Count > 0 then SetFocusIndex(TopIndex);  // this seems to cause problems
  //Fix For ClearQuest: HDS00001576
  //This fix has been commented out, becuase it causes problems
{  if (Items.Count > 0) and (Not IsAMouseButtonDown()) and (ItemIndex = -1) then
    SetFocusIndex(TopIndex);//ItemIndex := TopIndex; }
  // DRM - I6466595FY16/529127 - 2017/9/12 - Setting ItemIndex like this causes the listbox to scroll under the click.
  //if FHideSelection and (ItemIndex < 0) and (FFocusIndex >= 0) then
  //  ItemIndex := FFocusIndex;
  // DRM - I6466595FY16/529127 ---
  inherited DoEnter;
end;

procedure TORListBox.DoExit;
//var
//  SaveIndex: integer;
{ make sure item tip is hidden for this listbox when focus shifts to something else }
begin
  // DRM - I6466595FY16/529127 - 2017/9/12 - This isn't doing what you think it's doing.
  //if FHideSelection then
  //begin
  //  SaveIndex := ItemIndex;
  //  ItemIndex := -1;
  //  FFocusIndex := SaveIndex;
  //end;
  // DRM - I6466595FY16/529127 ---

  uItemTip.Hide;
  FItemTipActive := False;
  inherited DoExit;
end;

procedure TORListBox.DestroyItems;
var
  ItemCount, i, ItemPos: Integer;
  ItemRec: PItemRec;

begin
  if (not FItemsDestroyed) then
  begin
    ItemCount := Perform(LB_GETCOUNT, 0, 0);
    for i := 0 to ItemCount - 1 do
    begin
      FFromSelf := True;
      ItemRec := PItemRec(SendMessage(Handle, LB_GETITEMDATA, i, 0));
      FFromSelf := False;
      if Assigned(ItemRec) then
      begin
        ItemPos := ItemRecList.IndexOf(ItemRec);
        ItemRecList.Delete(ItemPos);
        Dispose(ItemRec);
      end;

    end;
    FItemsDestroyed := TRUE;

  end;
end;

procedure TORListBox.ToggleCheckBox(idx: integer);
var
  ItemRec: PItemRec;
  OldFromSelf: boolean;
  Rect: TRect;

begin
  if (not FCheckBoxes) or (idx < 0) or (idx >= Items.Count) then exit;
  OldFromSelf := FFromSelf;
  FFromSelf := True;
  ItemRec := PItemRec(SendMessage(Handle, LB_GETITEMDATA, idx, 0));
  FFromSelf := OldFromSelf;
  if (assigned(ItemRec)) then
  begin
    if (FAllowGrayed) then
    begin
      case ItemRec^.CheckedState of
        cbUnchecked: ItemRec^.CheckedState := cbGrayed;
        cbGrayed: ItemRec^.CheckedState := cbChecked;
        cbChecked: ItemRec^.CheckedState := cbUnchecked;
      end;
    end
    else
    begin
      if (ItemRec^.CheckedState = cbUnchecked) then
        ItemRec^.CheckedState := cbChecked
      else
        ItemRec^.CheckedState := cbUnChecked;
    end;
  end;
  Rect := ItemRect(Idx);
  InvalidateRect(Handle, @Rect, FALSE);
  if (assigned(FOnClickCheck)) then
    FOnClickCheck(Self, idx);
  if (assigned(FParentCombo)) then
    FParentCombo.UpdateCheckEditBoxText;
end;

procedure TORListBox.KeyPress(var Key: Char);
begin
  {inherited KeyPress is changing the ' ' into #0, had to move conditional before inherited.}
  if (Key = ' ') then begin
    ToggleCheckBox(ItemIndex);
    {The space bar causes the focus to jump to an item in the list that starts with
     a space. Disable that function.}
    Key := #0;
  end;
  inherited;
end;

procedure TORListBox.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
{ hide the item tip window whenever an item is clicked - ignored if itemtip not enabled}
var
  idx: integer;

begin
  uItemTip.Hide;
  inherited MouseDown(Button, Shift, X, Y);
  if (FCheckBoxes) and (X >= 0) and (X <= Width) and (Y >= 0) and (Y <= Height) then
  begin
    idx := GetIndexFromY(Y);
    if (idx >= 0) then
    begin
      if (FCheckEntireLine) then
        ToggleCheckBox(idx)
      else
        if (X < CheckWidth) then ToggleCheckBox(idx);
    end;
  end;
end;

// In Delphi 2006, hint windows will cause the TORComboBox drop down list to
// move behind a Stay on Top form.  Hints are also problematic with item tips in
// the drop down list, so we disable them when ever a drop down list is open,
// on all forms, not just stay on top forms.
procedure SetHintProperties(Restore: Boolean; MainForm: TComponent);
var
  i, x: integer;
  Component: TComponent;
  TmpName: string;

  // component name can be blank on dynamically created components
  function LookupName(AComponent: TComponent): string;
  begin
    Result := AComponent.Name;
    if Result = '' then
      Result := IntToHex(Integer(AComponent));
  end;

begin
  if not assigned(MainForm) then
    exit;

  if restore and (Length(HintArray) = 0) then
    exit;

   //Clear the array if we are not restoring it
  if not restore then
    SetLength(HintArray, 0);

  //Loop through all the components on the form
  for i := 0 to TForm(MainForm).ComponentCount - 1 do begin
    Component := TForm(MainForm).Components[i];
    if (Component is TControl) then begin
      TmpName := LookupName(Component);
      if not restore then begin
        //Increase our array and set our record
        SetLength(HintArray, Length(HintArray) + 1);
        HintArray[high(HintArray)].ObjectName := TmpName;
        HintArray[high(HintArray)].ObjectHint := GetStrProp(Component, 'Hint');
        //Now clear out the component's hint
        SetStrProp(Component, 'Hint', '');
      end else begin
        //Loop through the array and find this component's hint
        for x := Low(HintArray) to High(HintArray) do begin
          if TmpName = HintArray[x].ObjectName then begin
            //Once found reset the hint and break out of the loop
            SetStrProp(Component, 'Hint', HintArray[x].ObjectHint);
            break;
          end;
        end;
      end;
    end;
  end;

  //Now deal with the form itself
  TmpName := LookupName(MainForm);
  if not restore then begin
    //Increase our array and set our record
    SetLength(HintArray, Length(HintArray) + 1);
    HintArray[high(HintArray)].ObjectName := TmpName;
    HintArray[high(HintArray)].ObjectHint := TForm(MainForm).Hint;
    //Now clear out the Forms's hint
    TForm(MainForm).Hint := '';
  end else begin
      //Loop through the array and find this Forms's hint
    for x := Low(HintArray) to High(HintArray) do begin
      if TmpName = HintArray[x].ObjectName then begin
        //Once found reset the hint and break out of the loop
        TForm(MainForm).Hint := HintArray[x].ObjectHint;
        break;
      end;
    end;
    //Now clear the arrau since we are done using it
    SetLength(HintArray, 0);
  end;
end;

procedure TORListBox.MouseMove(Shift: TShiftState; X, Y: Integer);
{ hide and show the appropriate item tip window as the mouse moves through the listbox }
const
  CATCH_MOUSE = True;
var
  AnItem: Integer;
  TrueOffset: integer;
  TipPos: TPoint;
  ComponentForm: TCustomForm;
  TopFormHandle: HWND;

 function GetTopWindow: HWND;
 begin
  Result := GetLastActivePopup(Application.Handle);
  if (Result = Application.Handle) or not IsWindowVisible(Result) then
    if Assigned(Screen.ActiveCustomForm) then
       Result := Screen.ActiveCustomForm.Handle;
 end;

begin
  inherited MouseMove(Shift, X, Y);

  //If the drop down is visible and the hint hasn't been changed then clear the hint and save    the original hint
  if assigned(FParentCombo) then begin
    //agp change
    //if (FParentCombo.FDropPanel.Visible) and (TForm(self.Owner.Owner).Hint <> '') then begin
    if (FParentCombo.FDropPanel.Visible) and (Length(HintArray) = 0) then begin
      SetHintProperties(False, GetParentForm(Self));
    end;
  end;


  if (not FItemTipEnable) or (not Application.Active) then Exit;
  { Make sure mouse really moved before continuing.  For some reason, MouseMove gets called
    every time a navigation key is pressed. If FItemTipActive is true, mouse is pausing
    over the list.}
  if (not FItemTipActive) and (X = FLastMouseX) and (Y = FLastMouseY) then Exit;
  FLastMouseX := X;
  FLastMouseY := Y;

  //Issue with popup windows and wmclosemode not being called
  ComponentForm := GetParentForm(self);
  TopFormHandle := GetTopWindow;

  // when captured mouse moving outside listbox or form has open above above it
  if not (PtInRect(ClientRect, Point(X, Y))) or (TopFormHandle <> ComponentForm.Handle) then
  begin
//    If FParentCombo = nil then MouseCapture := False; - VISTAOR-23368
    uItemTip.Hide;
    FItemTipActive := False;
    FTipItem := -1;
    Exit;
  end;
  // borrow hint timer to delay first ItemTip
  if ShowHint and not FItemTipActive then Exit;
  // when mouse moving within listbox
  AnItem := GetIndexFromY(Y);
  TrueOffset := (Y div ItemHeight) + TopIndex;
  if AnItem <> FTipItem then
  begin
    if (AnItem < Items.Count) and ((TrueOffset - TopIndex + 1) * ItemHeight < Height) then
    begin
      TipPos := ClientToScreen(Point(0, (TrueOffset - TopIndex) * ItemHeight));
      uItemTip.Show(Self, AnItem, TipPos, CATCH_MOUSE);
      FTipItem := AnItem;
    end else
    begin
      uItemTip.Hide;
      FTipItem := -1;
    end;
  end;
end;

procedure TORListBox.MeasureItem(Index: Integer; var Height: Integer);
var
  Txt: string;

begin
  if (FHideSynonyms) and (fSynonymChars <> '') then
  begin
    if (FCreatingItem) then
      Txt := FCreatingText
    else
      Txt := Items[Index];
    if (IsSynonym(Txt)) then Height := 0;
  end;
  inherited MeasureItem(Index, Height);
end;

procedure TORListBox.WMDestroy(var Message: TWMDestroy);
begin
  if (assigned(Owner)) and (csDestroying in Owner.ComponentState) then
    DestroyItems;
  inherited;
end;

procedure TORListBox.CNDrawItem(var Message: TWMDrawItem);
begin
  if (FCheckBoxes) then
    with Message.DrawItemStruct^ do
      inc(rcItem.Left, CheckWidth);
  inherited;
end;

procedure TORListBox.DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  Flags: Longint;
  ItemRec: PItemRec;
  OldFromSelf: boolean;
  BMap: TBitMap;
  i, DY: integer;
  TmpR: TRect;
  Neg: boolean;
  ShowText: string;
begin
  // DRM - I6466595FY16/529127 - 2017/9/12 - if HideSelection, don't draw default highlight background.
  if FHideSelection and (odSelected in State) and not Focused then
  begin
    // override default highlighting
    Canvas.Brush.Color := clWindow;
    Canvas.Font.Color := clWindowText;
  end;
  // DRM - I6466595FY16/529127 ---
  if (assigned(FOnBeforeDraw)) then
    FOnBeforeDraw(Self, Index, Rect, State);
  if Assigned(OnDrawItem) then OnDrawItem(Self, Index, Rect, State)
  else
  begin
    Canvas.FillRect(Rect);
    if Index < Items.Count then
    begin
      Flags := DrawTextBiDiModeFlags(DT_SINGLELINE or DT_VCENTER);
      if not UseRightToLeftAlignment then
        Inc(Rect.Left, 2)
      else
        Dec(Rect.Right, 2);
      OldFromSelf := FFromSelf;
      FFromSelf := True;
      ItemRec := PItemRec(SendMessage(Handle, LB_GETITEMDATA, Index, 0)); // WParam: list index
      FFromSelf := OldFromSelf;

      //Set the NonSelectedIndex
      if (odFocused in State) and (not (odSelected in State)) then
       FNonSelectedIndex := Index;

      if (FCheckBoxes) then
      begin
        if (assigned(ItemRec)) then
        begin
          case ItemRec^.CheckedState of
            cbUnchecked:
              begin
                if (FFlatCheckBoxes) then
                  BMap := GetORCBBitmap(iiFlatUnChecked, FBlackColorMode)
                else
                  BMap := GetORCBBitmap(iiUnchecked, FBlackColorMode);
              end;
            cbChecked:
              begin
                if (FFlatCheckBoxes) then
                  BMap := GetORCBBitmap(iiFlatChecked, FBlackColorMode)
                else
                  BMap := GetORCBBitmap(iiChecked, FBlackColorMode);
              end;
          else // cbGrayed:
            begin
              if (FFlatCheckBoxes) then
                BMap := GetORCBBitmap(iiFlatGrayed, FBlackColorMode)
              else
                BMap := GetORCBBitmap(iiGrayed, FBlackColorMode);
            end;
          end;
        end
        else
        begin
          if (FFlatCheckBoxes) then
            BMap := GetORCBBitmap(iiFlatGrayed, FBlackColorMode)
          else
            BMap := GetORCBBitmap(iiGrayed, FBlackColorMode);
        end;
        TmpR := Rect;
        TmpR.Right := TmpR.Left;
        dec(TmpR.Left, CheckWidth + 1);
        DY := ((TmpR.Bottom - TmpR.Top) - BMap.Height) div 2;
        Canvas.Draw(TmpR.Left, TmpR.Top + DY, BMap);
      end;

      if (FTabPos[0] > 0) then
        Flags := (FTabPos[1] * 256) or Flags or DT_TABSTOP or DT_EXPANDTABS;

      ShowText := GetDisplayText(Index);
      if (Style <> lbStandard) and (FTabPos[0] > 0) then
      begin
        for i := 1 to FTabPix[0] do
        begin
          Neg := (FTabPix[i] < 0);
          if Neg then FTabPix[i] := -FTabPix[i];
          inc(FTabPix[i], Rect.Left - 1);
          if Neg then FTabPix[i] := -FTabPix[i];
        end;
        TabbedTextOut(Canvas.Handle, Rect.Left, Rect.Top + 1, PChar(ShowText), Length(ShowText),
          FTabPix[0], FTabPix[1], -1);
        for i := 1 to FTabPix[0] do
        begin
          Neg := (FTabPix[i] < 0);
          if Neg then FTabPix[i] := -FTabPix[i];
          dec(FTabPix[i], Rect.Left - 1);
          if Neg then FTabPix[i] := -FTabPix[i];
        end;
      end
      else
        DrawText(Canvas.Handle, PChar(ShowText), Length(ShowText), Rect, Flags);
    end;
  end;
end;

function TORListBox.GetIndexFromY(YPos: integer): integer;
begin
  if (FHideSynonyms) then
  begin
    Result := TopIndex - 1;
    repeat
      inc(Result);
      if (Perform(LB_GETITEMHEIGHT, Result, 0) > 0) then
        dec(YPos, ItemHeight);
    until ((YPos < 0) or (Result >= Items.Count));
  end
  else
    Result := (YPos div ItemHeight) + TopIndex;
end;

procedure TORListBox.LoadRecreateItems(RecreateItems: TStrings);
var
  AOldIsInLoadRecreateItems: Boolean;
begin
  AOldIsInLoadRecreateItems := FIsInLoadRecreateItems;
  FIsInLoadRecreateItems := True;
  try
    inherited;
  finally
    FIsInLoadRecreateItems := AOldIsInLoadRecreateItems;
  end;
end;

procedure TORListBox.SetFocusIndex(Value: Integer);
{ move the focus rectangle to an item and show the item tip window if enabled
  in the case of a LongList, scroll the list so that new items are loaded appropriately }
const
  CATCH_MOUSE = True;
  NO_CATCH_MOUSE = False;
var
  ScrollCount, ScrollPos, InitialTop, i: Integer;
begin
  // DRM - INC0419622 - Force calculation of FLargeChange
  FLargeChange := (Height div ItemHeight) - 1;
  // DRM ---
  if FLongList then // -- special long list processing - begin
  begin
    if (Value = SFI_TOP) or (Value = SFI_END) then // scroll to top or bottom
    begin
      if Value = SFI_TOP then ScrollPos := 0 else ScrollPos := 100;
      ScrollTo(Self, scPosition, ScrollPos); // ScrollTo is scrollbar event
      FScrollBar.Position := ScrollPos;
      if ScrollPos = 0 then Value := FFocusIndex else Value := FFocusIndex + FLargeChange;
    end else
    begin
      InitialTop := TopIndex;
      ScrollCount := Value - InitialTop;
      ScrollPos := 50; // arbitrary, can be anything from 1-99
      FFromSetFocusIndex := True;
      try
        if ScrollCount < 0 then // scroll backwards
        begin
          if ScrollCount = -FLargeChange then
            ScrollTo(Self, scPageUp, ScrollPos)
          else
            for i := 1 to Abs(ScrollCount) do
              ScrollTo(Self, scLineUp, ScrollPos);
          FScrollBar.Position := ScrollPos;
          Value := Value + (FCurrentTop - InitialTop);
        end;
        if ScrollCount > FLargeChange then // scroll forwards
        begin
          if ScrollCount = (FLargeChange * 2) then
            ScrollTo(Self, scPageDown, ScrollPos)
          else
            for i := FLargeChange + 1 to ScrollCount do
              ScrollTo(Self, scLineDown, ScrollPos);
          FScrollBar.Position := ScrollPos;
        end;
        if (FHideSynonyms) then
        begin
          while ((Perform(LB_GETITEMHEIGHT, Value, 0) = 0) and (Value >= 0) and (value < Items.Count)) do
          begin
            if (Value < FFocusIndex) then
              dec(Value)
            else
              inc(Value);
          end;
        end;
      finally
        FFromSetFocusIndex := False;
      end;
    end;
  end; // -- special long list processing - end
  if (Value = SFI_END) or (not (Value < Items.Count)) then Value := Items.Count - 1;
  if (Value = SFI_TOP) or (Value < 0) then Value := 0;
  FFocusIndex := Value;
  if Focused or (not FHideSelection) then
    ItemIndex := Value;
  if MultiSelect then Perform(LB_SETCARETINDEX, FFocusIndex, 0) // LPARAM=0, scrolls into view
  else
  begin
    // LB_SETCARETINDEX doesn't scroll with single select so we have to do it ourselves
    // ( a LongList should always come through here - it should never be MultiSelect )
    if FocusIndex < TopIndex
      then TopIndex := FocusIndex
    else if FocusIndex > (TopIndex + FLargeChange)
      then TopIndex := HigherOf(FocusIndex - FLargeChange, 0);
  end;
  // need to have a way to move the focus rectangle for single select listboxs w/o itemtips
  // if FItemTipEnable or not MultiSelect then ... Show: if not ItemTipEnable then AWidth := 0?
  //
  // can't show the item tip from keyboard input for dropdown combo without causing problems
  // with mouse capture, post the message to allow the selected attribute to be posted
  if FItemTipEnable {and (FParentCombo = nil)}
    then PostMessage(Self.Handle, UM_SHOWTIP, Value, 0);
end;

procedure TORListBox.UMShowTip(var Message: TMessage);
{ show item tip, Tip Position in parameters: wParam=X and lParam=Y }
const
  NO_CATCH_MOUSE = False;
var
  TipPos: TPoint;
  TrueOffset: integer;
  TmpIdx: integer;
begin
  // if listbox is dropdown combo but control is not focused -
  if (Parent is TORComboBox) and (FParentCombo <> nil) and (Screen.ActiveControl <> Parent)
    then Exit;
  // if listbox is dropdown combo and list is not dropped down -
  if (FParentCombo <> nil) and (FParentCombo.DroppedDown = False) then Exit;
  // if control is not focused -
  if (Screen.ActiveControl <> Self) and (Screen.ActiveControl <> Parent) then Exit;
  if (FHideSynonyms) then
  begin
    TrueOffset := TopIndex;
    TmpIdx := TopIndex;
    while ((TmpIdx < Integer(Message.wParam)) and (TmpIdx < Items.Count)) do
    begin
      if (Perform(LB_GETITEMHEIGHT, TmpIdx, 0) > 0) then
        inc(TrueOffset);
      inc(TmpIdx);
    end;
  end
  else
    TrueOffset := Message.wParam;
  TipPos := ClientToScreen(Point(0, (TrueOffset - TopIndex) * ItemHeight));
  //uItemTip.Show(Self, FFocusIndex, TipPos, NO_CATCH_MOUSE);
  uItemTip.Show(Self, FFocusIndex, TipPos, FParentCombo = nil); // if DropDown, no mousecapture
end;

function TORListBox.GetIEN(AnIndex: Integer): Int64;
{ return as an integer the first piece of the Item identified by AnIndex }
begin
  if (AnIndex < Items.Count) and (AnIndex > -1)
    then Result := StrToInt64Def(Piece(Items[AnIndex], FDelimiter, 1), 0)
  else Result := 0;
end;

function TORListBox.GetItemIEN: Int64;
{ return as an integer the first piece of the currently selected item }
begin
  Result := StrToInt64Def(GetItemID, 0);
end;

function TORListBox.SelectByIEN(AnIEN: Int64): Integer;
{ cause the item where the first piece = AnIEN to be selected (sets ItemIndex) }
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Items.Count - 1 do
    if GetIEN(i) = AnIEN then
    begin
      ItemIndex := i;
      Result := i;
      break;
    end;
end;

function TORListBox.SetExactByIEN(AnIEN: Int64; const AnItem: string): Integer;
{ finds an exact entry (matches IEN) in a list or a long list and returns ItemIndex }
var
  ItemFound: Boolean;
  i, ListEnd: Integer;
begin
  ItemFound := False;
  Result := -1;
  if FLongList then ListEnd := FWaterMark - 1 else ListEnd := Items.Count - 1;
  for i := 0 to ListEnd do if (GetIEN(i) = AnIEN) and (GetDisplayText(i) = AnItem) then
    begin
      ItemIndex := i;
      Result := i;
      ItemFound := True;
      break;
    end;
  if FLongList and not ItemFound then
  begin
    InitLongList(AnItem);
    Result := SelectByIEN(AnIEN);
    if (AnItem <> '') and (Result < 0) then
    begin
      FUseExactSearch := True;
      try
        InitLongList(AnItem);
      finally
        FUseExactSearch := False;
      end;
      Result := SelectByIEN(AnIEN);
    end;
  end;
end;

function TORListBox.GetItemID: Variant;
{ return as a variant the first piece of the currently selected item }
var
  TempData: string;

begin
  if ItemIndex > -1 then
    TempData := Items[ItemIndex]
  else if FLongList then
    TempData := FLastItemID
  else
    TempData := '';
  Result := Piece(TempData, FDelimiter, 1);
end;

function TORListBox.SearchMsg: UINT;
begin
  if FUseExactSearch then
    Result :=  LB_FINDSTRINGEXACT
  else
    Result := LB_FINDSTRING;
end;

function TORListBox.SelectByID(const AnID: string): Integer;
{ cause the item where the first piece = AnID to be selected (sets ItemIndex) }
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Items.Count - 1 do
    if Piece(Items[i], FDelimiter, 1) = AnID then
    begin
      ItemIndex := i;
      Result := i;
      break;
    end;
end;

function TORListBox.GetReference(Index: Integer): Variant;
{ retrieves a variant value that is associated with an item in a listbox }
var
  ItemRec: PItemRec;
begin
  if (Index < 0) or (Index >= Items.Count) then
    raise Exception.Create('List Index Out of Bounds');
  FFromSelf := True;
  ItemRec := PItemRec(SendMessage(Handle, LB_GETITEMDATA, Index, 0));
  FFromSelf := False;
  if (assigned(ItemRec)) then
    Result := ItemRec^.Reference
  else
    Result := Null;
end;

procedure TORListBox.SetReference(Index: Integer; AReference: Variant);
{ stores a variant value that is associated with an item in a listbox }
var
  ItemRec: PItemRec;
begin
  if (Index < 0) or (Index >= Items.Count) then
    raise Exception.Create('List Index Out of Bounds');
  FFromSelf := True;
  ItemRec := PItemRec(SendMessage(Handle, LB_GETITEMDATA, Index, 0));
  FFromSelf := False;
  if (assigned(ItemRec)) then
    ItemRec^.Reference := AReference;
end;

function TORListBox.AddReference(const S: string; AReference: Variant): Integer;
{ adds a string to a listbox, along with a variant value to be associated with the string }
begin
  Result := Items.Add(S);
  SetReference(Result, AReference);
end;

procedure TORListBox.InsertReference(Index: Integer; const S: string; AReference: Variant);
{ inserts a string at a position into a listbox, along with its associated variant value }
begin
  Items.Insert(Index, S);
  SetReference(Index, AReference);
end;

function TORListBox.IndexOfReference(AReference: Variant): Integer;
{ looks through the list of References (variants) and returns the index of the first match }
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Items.Count - 1 do
    if GetReference(i) = AReference then
    begin
      Result := i;
      Break;
    end;
end;

function TORListBox.GetTabPositions: string;
{ returns the character based tab stops that are currently set, if any }
begin
  if (FTabPosInPixels) then
    Result := IntArrayToString(FTabPix)
  else
    Result := IntArrayToString(FTabPos);
end;

procedure TORListBox.SetTabPositions(const Value: string);
// converts a string of character position tab stops to an array of integer &
// sets now tabs

  procedure SortArray(var AArray: array of Integer);
  // Sort an array created with StringToIntArray on absolute values from Low to
  // High. This code replaces the code that generated an error on wrong order.
  var
    I: Integer;
    BArray: array of Integer;
  begin
    if AArray[0] > High(AArray) then
      raise Exception.Create('Too many elements in AArray');

    // AArray[0] is real count. Copy only real AArray values to BArray
    SetLength(BArray, AArray[0]);
    for I := 0 to AArray[0] - 1 do BArray[I] := AArray[I + 1];

    // Sort BArray
    System.Generics.Collections.TArray.Sort<Integer>(BArray,
      TDelegatedComparer<Integer>.Construct(
      function(const Left, Right: Integer): Integer
      begin
        Result := TComparer<Integer>.Default.Compare(Abs(Left), Abs(Right));
        if Result = 0 then TComparer<Integer>.Default.Compare(Left, Right);
      end));

    // Remove duplicates from BArray (There was no Abs comparison for this in
    // the original code so I am assuming that is correct)
    for I := High(BArray) - 1 downto 1 do
      if BArray[I] = BArray[I - 1] then Delete(BArray, I, 1);

    // Copy BArray values back to AArray
    for I := 0 to High(BArray) do AArray[I + 1] := BArray[I];

    // Fill empty spaces in AArray (due to deletions) with zeroes
    for I := High(BArray) + 2 to AArray[0] do AArray[I] := 0;
  end;

var
  TabTmp: array[0..MAX_TABS] of Integer;
  i: Integer;
begin
  StringToIntArray(Value, TabTmp, TRUE);
  SortArray(TabTmp);
  if (FTabPosInPixels) then
  begin
    for i := 0 to TabTmp[0] do FTabPix[i] := TabTmp[i];
  end
  else
  begin
    for i := 0 to TabTmp[0] do FTabPos[i] := TabTmp[i];
  end;
  SetTabStops;
  if FTabPos[0] > 0 then FWhiteSpace := #9 else FWhiteSpace := ' ';
  ResetItems;
end;

procedure TORListBox.SetTabPosInPixels(const Value: boolean);
begin
  if (FTabPosInPixels <> Value) then
  begin
    FTabPosInPixels := Value;
    SetTabStops;
  end;
end;

procedure TORListBox.SetTabStops;
{ sets new tabs stops based on dialog units, FTabPix array also used by ItemTip }
var
  TabDlg: array[0..MAX_TABS] of Integer;
  i, AveWidth: Integer;
begin
  FillChar(TabDlg, SizeOf(TabDlg), 0);
  AveWidth := FontWidthPixel(Self.Font.Handle);
  if (FTabPosInPixels) then
  begin
    FillChar(FTabPos, SizeOf(FTabPos), 0);
    FTabPos[0] := FTabPix[0];
    for i := 1 to FTabPix[0] do
    begin
      FTabPos[i] := FTabPix[i] div AveWidth;
      TabDlg[i] := (FTabPix[i] * 4) div AveWidth;
    end;
  end
  else
  begin
    FillChar(FTabPix, SizeOf(FTabPix), 0);
    FTabPix[0] := FTabPos[0];
    for i := 1 to FTabPos[0] do
    begin
      // do dialog units first so that pixels gets the same rounding error
      TabDlg[i] := FTabPos[i] * 4; // 4 dialog units per character
      FTabPix[i] := (TabDlg[i] * AveWidth) div 4;
    end;
  end;
  TabDlg[0] := FTabPos[0];
  Perform(LB_SETTABSTOPS, TabDlg[0], Integer(@TabDlg[1]));
  Refresh;
end;

function TORListBox.SupportsDynamicProperty(PropertyID: integer): boolean;
begin
  Result := (PropertyID = DynaPropAccesibilityCaption);
end;

procedure TORListBox.SetHideSynonyms(Value: boolean);
var
  TmpIH: integer;

begin
  if (FHideSynonyms <> Value) then
  begin
    if ((Value) and (not FLongList)) then
      raise Exception.Create('Hide Synonyms only allowed on Long Lists');
    FHideSynonyms := Value;
    if (not FHideSynonyms) then
    begin
      Style := lbStandard;
    end
    else
    begin
      if (FSynonymChars = '') then
        FSynonymChars := '<>';
      TmpIH := ItemHeight;
      Style := lbOwnerDrawVariable;
      ItemHeight := TmpIH;
    end;
  end;
end;

procedure TORListBox.SetSynonymChars(Value: string);
begin
  if (FSynonymChars <> Value) then
  begin
    FSynonymChars := Value;
    if ((Value = '') and (FHideSynonyms)) then
      SetHideSynonyms(FALSE);
    if (FHideSynonyms) then
    begin
      SetHideSynonyms(FALSE);
      SetHideSynonyms(TRUE);
    end;
  end;
end;

function TORListBox.GetStyle: TListBoxStyle;
begin
  Result := inherited Style;
end;

procedure TORListBox.SetStyle(Value: TListBoxStyle);
begin
  if (Value <> lbOwnerDrawVariable) and (FHideSynonyms) then
    FHideSynonyms := FALSE;
  if (FCheckBoxes) and (Value = lbStandard) then
    FCheckBoxes := FALSE;
  inherited Style := Value;
end;

procedure TORListBox.SetDelimiter(Value: Char);
{ change the delimiter used in conjunction with the pieces property (default = '^') }
begin
  FDelimiter := Value;
  ResetItems;
end;

function TORListBox.GetPieces: string;
{ returns the pieces of an item currently selected for display }
begin
  Result := IntArrayToString(FPieces);
end;

procedure TORListBox.SetPieces(const Value: string);
{ converts a string of comma-delimited integers into an array of string pieces to display }
begin
  StringToIntArray(Value, FPieces);
  ResetItems;
end;

procedure TORListBox.ResetItems;
{ saves listbox objects then rebuilds listbox including references and user objects }
var
  SaveItems: TList;
  Strings: TStringList;
  i, Pos, ItemPos: Integer;
  ItemRec, ItemRec2: PItemRec;
  SaveListMode: Boolean;
  RealVerify: Boolean;
begin
  SaveListMode := False;
  Strings := nil;
  SaveItems := nil;
  RealVerify := TORStrings(Items).Verification;
  try
    TORStrings(Items).Verification := False;
    HandleNeeded; // ensures that Items is valid if in the middle of RecreateWnd
    SaveListMode := FLongList;
    Strings := TStringList.Create;
    SaveItems := TList.Create;
    FLongList := False; // so don't have to track WaterMark
    FFromSelf := True;
    for i := 0 to Items.Count - 1 do // put pointers to TItemRec in SaveItems
    begin
      ItemRec := PItemRec(SendMessage(Handle, LB_GETITEMDATA, i, 0));
      SaveItems.Add(ItemRec);
    end;
    Strings.Assign(Items);
    Items.Clear; // still FromSelf so don't dispose recs
    FFromSelf := False;
    for i := 0 to SaveItems.Count - 1 do // use saved ItemRecs to rebuild listbox
    begin
      ItemRec := SaveItems[i];
      if (assigned(ItemRec)) then
      begin
        Pos := Items.AddObject(Strings[i], ItemRec^.UserObject);
        // CQ 11491 - Changing TabPositions, etc. was wiping out check box status.
        FFromSelf := True;
        ItemRec2 := PItemRec(SendMessage(Handle, LB_GETITEMDATA, Pos, 0));
        FFromSelf := False;
        if (assigned(ItemRec2)) then
        begin
          ItemRec2^.Reference := ItemRec^.Reference;
          ItemRec2^.CheckedState := ItemRec^.CheckedState;
        end;
      end;
             ItemPos := ItemRecList.IndexOf(ItemRec);
       ItemRecList.Delete(ItemPos);
      Dispose(ItemRec);

    end;
  finally
    SaveItems.Free;
    Strings.Free;
    TORStrings(Items).Verification := RealVerify;
    FLongList := SaveListMode;
  end;
end;

procedure TORListBox.SetLongList(Value: Boolean);
{ changes the list box so that it runs in LongList mode (calls OnNeedData) }
begin
  if Value <> FLongList then
  begin
    if Value = True then
      CreateScrollBar
    else
    begin
      FreeScrollBar;
      if (FHideSynonyms) then
        SetHideSynonyms(FALSE);
    end;
  end;
end;

procedure TORListBox.AdjustScrollBar;
{ ensures that the scrollbar used for a long list is placed properly within the listbox }
var
  L, T, W, H, OffsetLT, OffsetWH: Integer;
begin
  if uNewStyle then begin OffsetLT := 2; OffsetWH := 4; end // Win95
  else begin OffsetLT := 0; OffsetWH := 0; end; // Win3.1
  W := GetSystemMetrics(SM_CXVSCROLL);
  L := Left + Width - W - OffsetLT;
  T := Top + OffsetLT;
  H := Height - OffsetWH;
  FScrollBar.SetBounds(L, T, W, H);
  FScrollBar.Invalidate;
end;

procedure TORListBox.CreateScrollBar;
{ a long list uses it's own scrollbar (mapped to APLHA_DISTRIBUTION, rather than the listbox's }
begin
  FLongList := True;
  if MultiSelect then MultiSelect := False; // LongLists do not support multiple selections
  FScrollBar := TScrollBar.Create(Self);
  FScrollBar.Kind := sbVertical;
  FScrollBar.TabStop := False;
  FScrollBar.ControlStyle := FScrollBar.ControlStyle - [csCaptureMouse];
  AdjustScrollBar;
  FScrollBar.OnScroll := ScrollBarScroll;
  if FParentCombo = nil
    then FScrollBar.Parent := Parent
  else FScrollBar.Parent := FParentCombo.FDropPanel;
  FLastItemID := '';
end;

procedure TORListBox.FreeScrollBar;
{ frees the scrollbar for a longlist (called when LongList property becomes false) }
begin
  FLongList := False;
  FScrollBar.Free; // don't call from destroy because scrollbar may already be free
  FScrollBar := nil;
  FLastItemID := '';
end;

procedure TORListBox.ForDataUse(Strings: TStrings);
{ adds or inserts items into a list box after determining the proper collating sequence }
var
  Ascend: Boolean;
  FirstItem, LastItem: string;
  i: Integer;
begin
  FLastEmpty := (Strings.Count = 0);
  if FLastEmpty then
  begin
    FLastEmptyStartFrom := FLastStartFrom;
    FLastEmptyDirection := FLastDirection;
    FLastEmptyInsertAt := FLastInsertAt;
    Exit;
  end;
  { To prevent the problem where the initial list item(s) are returned repeatedly because the
    DisplayText is longer than the subscript in a cross-reference, compare the last item
    returned with the first item in the long list.   If they are the same, assume the long
    list is already scrolled to the first item. }
  if (FDirection = LL_REVERSE) and (FWaterMark < Items.Count) and
    (CompareText(Strings[Strings.Count - 1], Items[FWaterMark]) = 0) then Exit;

  FirstItem := TextToShow(Strings[0]);
  LastItem := TextToShow(Strings[Strings.Count - 1]);
  Ascend := True;
  case FDirection of
    LL_REVERSE: if CompareText(FirstItem, LastItem) < 0 then Ascend := False;
    LL_FORWARD: if CompareText(FirstItem, LastItem) > 0 then Ascend := False;
  end;
  case Ascend of // should call AddObject & InsertObject instead?
    False: case FDirection of
        LL_REVERSE: for i := Strings.Count - 1 downto 0 do Items.Insert(FInsertAt, Strings[i]);
        LL_FORWARD: for i := Strings.Count - 1 downto 0 do Items.Add(Strings[i]);
      end;
    True: case FDirection of
        LL_REVERSE: for i := 0 to Strings.Count - 1 do Items.Insert(FInsertAt, Strings[i]);
        LL_FORWARD: for i := 0 to Strings.Count - 1 do Items.Add(Strings[i]);
      end;
  end;
  if FLongList and (ItemIndex < 0) and (FLastItemID <> '') then
  begin
    for i := 0 to Items.Count - 1 do
      if CompareText(Items[i], FLastItemID) = 0 then
      begin
        ItemIndex := i;
        break;
      end;
    if ItemIndex = -1 then
      FLastItemID := '';
  end;
end;

procedure TORListBox.InitLongList(S: string);
{ clears the listbox starting at FWaterMark and makes the initial NeedData call }
var
  index: integer;
begin
  if FLongList then
  begin
    FLastItemID := '';
    if LookUpPiece <> 0 then
    begin
      index := GetStringIndex(S);
      if index > -1 then
        S := Piece(Items[index], Delimiter, LookUpPiece);
    end;
    if CaseChanged then
      S := UpperCase(S);
    // decrement last char & concat '~' for $ORDER
    if Length(S) > 0 then S := Copy(S, 1, Length(S) - 1) + Pred(S[Length(S)]) + '~';
    NeedData(LL_POSITION, S);
    if S = '' then TopIndex := 0 else TopIndex := FWaterMark;
    FScrollBar.Position := PositionThumb;
  end;
end;

procedure TORListBox.InsertSeparator;
begin
  if FWaterMark > 0 then
  begin
    Items.Insert(FWaterMark, LLS_LINE);
    Items.Insert(FWaterMark, LLS_SPACE);
  end;
end;

procedure TORListBox.ClearTop;
{ clears a long listbox up to FWaterMark (doesn't clear long list) }
var
  i: Integer;
begin
  SendMessage(Handle, WM_SETREDRAW, NOREDRAW, 0);
  for i := FWaterMark - 1 downto 0 do Items.Delete(i);
  SendMessage(Handle, WM_SETREDRAW, DOREDRAW, 0);
  Invalidate;
end;

procedure TORListBox.NeedData(Direction: Integer; StartFrom: string);
{ called whenever the longlist needs more data inserted at a certain point into the listbox }
var
  CtrlPos, CharPos, index: Integer;
  DoCall: boolean;
  StrtFrom: string;

  procedure ClearLong;
  { clears a portion or all of the longlist to conserve the memory it occupies }
  var
    i: Integer;
  begin
    // DRM - INC0419622 - Force calculation of FLargeChange
    FLargeChange := (Height div ItemHeight) - 1;
    // DRM ---
    case FDirection of
      LL_REVERSE: for i := Items.Count - 1 downto
        HigherOf(FCurrentTop + FLargeChange, FWaterMark) do Items.Delete(i);
      LL_POSITION: for i := Items.Count - 1 downto FWaterMark do Items.Delete(i);
      LL_FORWARD: for i := FCurrentTop - 1 downto FWaterMark do Items.Delete(i);
    end;
  end;

begin {NeedData}
  if not FLongList then
    exit;
  FFromNeedData := True;
  FKeepItemID := True;
  try
    FFirstLoad := False;
    FDataAdded := False;
    FDirection := Direction;
    LockDrawing;
    if Items.Count > 1000 then ClearLong;
    case FDirection of
      LL_REVERSE: if FWaterMark < Items.Count then StartFrom := DisplayText[FWaterMark];
      LL_POSITION: begin
          ClearLong;
          if StartFrom = #127#127#127 then
          begin
            FDirection := LL_REVERSE;
            StartFrom := '';
          end
          else FDirection := LL_FORWARD;
        end;
      LL_FORWARD: if (FWaterMark < Items.Count) and (Items.Count > 0)
        then StartFrom := DisplayText[Items.Count - 1];
    end;
    if LookupPiece <> 0 then
    begin
      index := GetStringIndex(StartFrom);
      if index > -1 then
        StartFrom := Piece(Items[index], Delimiter, LookUpPiece);
    end;
    if CaseChanged then
      StartFrom := Uppercase(StartFrom);
    StartFrom := Copy(StartFrom, 1, 128); // limit length to 128 characters
    CtrlPos := 0; // make sure no ctrl characters
    for CharPos := 1 to Length(StartFrom) do if CharInSet(StartFrom[CharPos], [#0..#31]) then
      begin
        CtrlPos := CharPos;
        break;
      end;
    if CtrlPos > 0 then StartFrom := Copy(StartFrom, 1, CtrlPos - 1);
    if FDirection = LL_FORWARD then FInsertAt := Items.Count else FInsertAt := FWaterMark;
    StrtFrom := copy(StartFrom, 1, MaxNeedDataLen);
    DoCall := FLongList and Assigned(FOnNeedData);
    if DoCall and FDetectLastEmpty and FLastEmpty and
      (FLastEmptyStartFrom = StrtFrom) and (FLastEmptyDirection = FDirection) and
      (FLastEmptyInsertAt = FInsertAt) then
      DoCall := False;
    if DoCall then
    begin
      FLastEmpty := False;
      FLastStartFrom :=  StrtFrom;
      FLastDirection := FDirection;
      FLastInsertAt := FInsertAt;
      FOnNeedData(Self, FLastStartFrom, FLastDirection, FLastInsertAt);
    end;
    UnlockDrawing;
  finally
    FKeepItemID := False;
    FFromNeedData := False;
  end;
  Invalidate;
end;

function TORListBox.PositionThumb: Integer;
{ returns the proper thumb position for the TopIndex item relative to ALPHA_DISTRIBUTION }
var
  x: string;
begin
  Result := 1;
  x := DisplayText[TopIndex];
  if (FWaterMark > 0) and (TopIndex < FWaterMark)
    then Result := 0 // short list visible
  else while (CompareText(ALPHA_DISTRIBUTION[Result], x) < 0) and (Result < 100) do
      Inc(Result); // only long list visible
end;

procedure TORListBox.ScrollBarScroll(Sender: TObject; ScrollCode: TScrollCode;
  var ScrollPos: Integer);
begin
  FDetectLastEmpty := True;
  try
    ScrollTo(Sender, ScrollCode, ScrollPos);
  finally
    FDetectLastEmpty := False;
  end;
end;

procedure TORListBox.ScrollTo(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
{ event code for the longlist scrollbar, adjusts TopIndex & calls OnNeedData as necessary }
var
  Count, Goal, Dir: integer;
  Done: boolean;

  function CallNeedData(Backward: boolean): boolean;
  begin
    if not FLongList then
      Result := False
    else if Backward then
    begin
      if FFromSetFocusIndex then
        Result := ((FCurrentTop - 1) < FWaterMark)
      else
        Result := ((FCurrentTop - FLargeChange) < FWaterMark);
    end
    else
    begin
      if FFromSetFocusIndex then
        Result := ((FCurrentTop + FLargeChange) >= (Items.Count - 1))
      else
        Result := ((FCurrentTop + (FLargeChange * 2)) > (Items.Count - 1));
    end;
  end;

begin
  If Length(HintArray) > 0 then
    SetHintProperties(True, GetParentForm(Self));
  if assigned(uItemTip) then
    uItemTip.Hide;
  // DRM - INC0419622 - Force calculation of FLargeChange
  FLargeChange := (Height div ItemHeight) - 1;
  // DRM ---
  FCurrentTop := TopIndex;
  if (ScrollCode = scPosition) then
  begin
    if FLongList then
      NeedData(LL_POSITION, ALPHA_DISTRIBUTION[ScrollPos]);
    case ScrollPos of
      0: TopIndex := 0;
      1..99: TopIndex := FWaterMark;
      100: TopIndex := HigherOf(Items.Count - FLargeChange, 0);
    end;
    FFocusIndex := TopIndex;
  end
  else
    if (HideSynonyms) then
    begin
      Count := 0;
      case ScrollCode of
        scLineUp: begin Dir := -1; Goal := 1; end;
        scLineDown: begin Dir := 1; Goal := 1; end;
        scPageUp: begin Dir := -1; Goal := FLargeChange; end;
        scPageDown: begin Dir := 1; Goal := FLargeChange; end;
      else
        exit;
      end;
      repeat
        Done := FALSE;
        if (Dir > 0) then
        begin
          if CallNeedData(False) then
            NeedData(LL_FORWARD, '');
          if (FCurrentTop >= Items.Count - 1) then
          begin
            FCurrentTop := Items.Count - 1;
            Done := TRUE;
          end;
        end
        else
        begin
          if CallNeedData(True) then
            NeedData(LL_REVERSE, '');
          if (FCurrentTop <= 0) then
          begin
            FCurrentTop := 0;
            Done := TRUE;
          end;
        end;
        if (not Done) then
        begin
          FCurrentTop := FCurrentTop + Dir;
          if (Perform(LB_GETITEMHEIGHT, FCurrentTop, 0) > 0) then
          begin
            inc(Count);
            Done := (Count >= Goal);
          end;
        end;
      until Done;
      TopIndex := FCurrentTop;
    end
    else
    begin
      case ScrollCode of
        scLineUp: begin
            if CallNeedData(True) then
              NeedData(LL_REVERSE, '');
            TopIndex := HigherOf(FCurrentTop - 1, 0);
          end;
        scLineDown: begin
            if CallNeedData(False) then
              NeedData(LL_FORWARD, '');
            TopIndex := LowerOf(FCurrentTop + 1, Items.Count - 1);
          end;
        scPageUp: begin
            if CallNeedData(True) then
              NeedData(LL_REVERSE, '');
            TopIndex := HigherOf(FCurrentTop - FLargeChange, 0);
          end;
        scPageDown: begin
            if CallNeedData(False) then
              NeedData(LL_FORWARD, '');
            TopIndex := LowerOf(FCurrentTop + FLargeChange, Items.Count - 1);
          end;
      end;
    end;
  if (ScrollPos > 0) and (ScrollPos < 100) then ScrollPos := PositionThumb;
end;

function TORListBox.GetStringIndex(const AString: string): Integer;
{returns the index of the first string that partially matches AString}
var
  i: Integer;
begin
  Result := -1;
  if Length(AString) > 0 then {*KCM*}
  begin
    if not FLongList then // Normal List
    begin
      Result := SendMessage(Handle, SearchMsg, -1, Longint(PChar(AString)));
      if Result = LB_ERR then Result := -1;
    end else // Long List
    begin
      if FScrollBar.Position = 0 then for i := 0 to FWatermark - 1 do
        begin
          if CompareText(AString, Copy(DisplayText[i], 1, Length(AString))) = 0 then
          begin
            Result := i;
            break;
          end;
        end;
      if Result < 0 then
      begin
        Result := SendMessage(Handle, SearchMsg, FWaterMark - 1, Longint(PChar(AString)));
        if Result < FWaterMark then Result := -1;
      end; {if Result}
    end; {if not FLongList}
  end; {if Length(AString)}
end;

function TORListBox.SelectString(const AString: string): Integer;
{ causes the first string that partially matches AString to be selected & returns the index }
var
  x: string;
  i: Integer;
  index: integer;
begin
  Result := -1;
  if Length(AString) > 0 then {*KCM*}
  begin
    if not FLongList then // Normal List
    begin
      Result := SendMessage(Handle, SearchMsg, -1, Longint(PChar(AString)));
      if Result = LB_ERR then Result := -1;
      // use FFocusIndex instead of FocusIndex to reduce flashing
      FFocusIndex := Result;
    end else // Long List
    begin
      if FScrollBar.Position = 0 then for i := 0 to FWatermark - 1 do
        begin
          if CompareText(AString, Copy(DisplayText[i], 1, Length(AString))) = 0 then
          begin
            Result := i;
            break;
          end;
        end;
      if not StringBetween(AString, DisplayText[FWaterMark], DisplayText[Items.Count - 1]) then
      begin
        x := AString;
        if LookupPiece <> 0 then
        begin
          index := GetStringIndex(x);
          if index > -1 then
            x := Piece(Items[index], Delimiter, LookUpPiece);
        end;
        if CaseChanged then
          x := UpperCase(x);
        // decrement last char & concat '~' for $ORDER
        if Length(x) > 0 then x := Copy(x, 1, Length(x) - 1) + Pred(x[Length(x)]) + '~';
        NeedData(LL_POSITION, x);
      end;
      if Result < 0 then
      begin
        Result := SendMessage(Handle, SearchMsg, FWaterMark - 1, Longint(PChar(AString)));
        if Result < FWaterMark then Result := -1;
        if Result >= FWatermark then FocusIndex := Result;
        uItemTip.Hide;
      end; {if Result}
    end; {if not FLongList}
  end; {if Length(AString)}
  ItemIndex := Result;
  FFocusIndex := Result;
  if Result > -1 then TopIndex := Result; // will scroll item into view
  if FLongList then FScrollBar.Position := PositionThumb; // done after topindex set
end;

procedure TORListBox.SetCheckBoxes(const Value: boolean);
begin
  if (FCheckBoxes <> Value) then
  begin
    FCheckBoxes := Value;
    if (Value) then
    begin
      if (GetStyle = lbStandard) then
        SetStyle(lbOwnerDrawFixed);
      if (inherited MultiSelect) then
        SetMultiSelect(FALSE);
    end;
    invalidate;
  end;
end;

procedure TORListBox.SetFlatCheckBoxes(const Value: boolean);
begin
  if (FFlatCheckBoxes <> Value) then
  begin
    FFlatCheckBoxes := Value;
    invalidate;
  end;
end;

function TORListBox.GetChecked(Index: Integer): Boolean;
var
  ItemRec: PItemRec;

begin
  Result := False;
  if Index < 0 then exit;
  FFromSelf := True;
  ItemRec := PItemRec(SendMessage(Handle, LB_GETITEMDATA, Index, 0));
  FFromSelf := FALSE;
  if (assigned(ItemRec)) then
    Result := (ItemRec^.CheckedState = cbChecked)
  else
    Result := False;
end;

procedure TORListBox.SetChecked(Index: Integer; const Value: Boolean);
var
  ItemRec: PItemRec;
  Rect: TRect;

begin
  FFromSelf := True;
  ItemRec := PItemRec(SendMessage(Handle, LB_GETITEMDATA, Index, 0));
  FFromSelf := False;
  if (assigned(ItemRec)) and (Value <> (ItemRec^.CheckedState = cbChecked)) then
  begin
    if (Value) then
      ItemRec^.CheckedState := cbChecked
    else
      ItemRec^.CheckedState := cbUnChecked;
    Rect := ItemRect(Index);
    InvalidateRect(Handle, @Rect, FALSE);
    if (assigned(FOnClickCheck)) then
      FOnClickCheck(Self, Index);
  end;
end;

function TORListBox.GetCheckedState(Index: Integer): TCheckBoxState;
var
  ItemRec: PItemRec;

begin
  FFromSelf := True;
  ItemRec := PItemRec(SendMessage(Handle, LB_GETITEMDATA, Index, 0));
  FFromSelf := FALSE;
  if (assigned(ItemRec)) then
    Result := ItemRec^.CheckedState
  else
    Result := cbGrayed;
end;

procedure TORListBox.SetCheckedState(Index: Integer;
  const Value: TCheckBoxState);
var
  ItemRec: PItemRec;
  Rect: TRect;

begin
  FFromSelf := True;
  ItemRec := PItemRec(SendMessage(Handle, LB_GETITEMDATA, Index, 0));
  FFromSelf := False;
  if (assigned(ItemRec)) and (Value <> ItemRec^.CheckedState) then
  begin
    ItemRec^.CheckedState := Value;
    Rect := ItemRect(Index);
    InvalidateRect(Handle, @Rect, FALSE);
    if (assigned(FOnClickCheck)) then
      FOnClickCheck(Self, Index);
  end;
end;

function TORListBox.GetMultiSelect: boolean;
begin
  result := inherited MultiSelect;
end;

procedure TORListBox.SetMultiSelect(Value: boolean);
begin
  inherited SetMultiSelect(Value);
  if (Value) then SetCheckBoxes(FALSE);
end;

function TORListBox.GetCheckedString: string;
var
  i: integer;

begin
  Result := '';
  if (FCheckBoxes) then
  begin
    for i := 0 to Items.Count - 1 do
      Result := Result + Char(ord('0') + Ord(GetCheckedState(i)));
  end;
end;

procedure TORListBox.SetCheckedString(const Value: string);
var
  i: integer;

begin
  for i := 0 to Items.Count - 1 do
    SetCheckedState(i, TCheckBoxState(StrToIntDef(copy(Value, i + 1, 1), 0)));
end;

function TORListBox.GetMItems: TStrings;
begin
  if not Assigned(FMItems) then
    FMItems := TORStrings.Create(Tlistbox(Self).Items, TextToShow);
  result := FMItems;
end;

procedure TORListBox.SetMItems(Value: TStrings);
begin
  if not Assigned(FMItems) then
    FMItems := TORStrings.Create(Tlistbox(Self).Items, TextToShow);
  FMItems.Assign(Value);
end;

procedure TORListBox.Clear;
begin
  Items.Clear;
  if (not FKeepItemID) then
    FLastItemID := '';
  inherited;
end;

procedure TORListBox.SetBlackColorMode(Value: boolean);
begin
  FBlackColorMode := Value;
end;

procedure TORListBox.SetCaption(const Value: string);
begin
  if not Assigned(FCaption) then begin
    FCaption := TStaticText.Create(self);
    FCaption.AutoSize := False;
    FCaption.Height := 0;
    FCaption.Width := 0;
    FCaption.Visible := True;
    if Assigned(FParentCombo) then
      FCaption.Parent := FParentCombo
    else
      FCaption.Parent := Parent;
    FCaption.BringToFront;
  end;
  FCaption.Caption := Value;
end;

function TORListBox.GetCaption: string;
begin
  result := FCaption.Caption;
end;

{ TORDropPanel ----------------------------------------------------------------------------- }
const
  OKBtnTag = 1;
  CancelBtnTag = 2;

procedure TORDropPanel.BtnClicked(Sender: TObject);
begin
  (Owner as TORComboBox).DropPanelBtnPressed((Sender as TSpeedButton).Tag = OKBtnTag, TRUE);
end;

constructor TORDropPanel.Create(AOwner: TComponent);
{ Creates a panel the contains the listbox portion of a combobox when the combobox style is
  orcsDropDown.  This is necessary for the combobox to scroll the list properly.  The panel
  acts as the parent for the list, which recieves the scroll events.  If the panel is not
  used, the scroll events to the the Desktop and are not received by the application }
begin
  inherited Create(AOwner);
  BevelInner := bvNone;
  BevelOuter := bvNone;
  BorderStyle := bsNone;
  Caption := '';
  Ctl3D := False;
  Visible := False;
  UpdateButtons;
end;

procedure TORDropPanel.CreateParams(var Params: TCreateParams);
{ changes parent of panel to desktop so when list is dropped it can overlap other windows }
begin
  inherited CreateParams(Params);
  if not (csDesigning in ComponentState) then with Params do
    begin
      if uNewStyle then Params.ExStyle := Params.ExStyle or WS_EX_TOOLWINDOW;
      Params.ExStyle := Params.ExStyle or WS_EX_TOPMOST; // - incompatible with ItemTip
      WindowClass.Style := WindowClass.Style or CS_SAVEBITS;
      WndParent := GetDesktopWindow;
    end;
end;

function TORDropPanel.GetButton(OKBtn: boolean): TSpeedButton;
var
  i: integer;

begin
  Result := nil;
  if (FButtons) then
  begin
    for i := 0 to ControlCount - 1 do
      if (Controls[i] is TSpeedButton) then
      begin
        if ((OKBtn and ((Controls[i] as TSpeedButton).Tag = OKBtnTag)) or
          ((not OKBtn) and ((Controls[i] as TSpeedButton).Tag = CancelBtnTag))) then
        begin
          Result := TSpeedButton(Controls[i]);
          break;
        end;
      end;
  end;
end;

procedure TORDropPanel.ResetButtons;
var
  sb: TSpeedButton;

begin
  sb := GetButton(TRUE);
  if (assigned(sb)) then sb.Down := FALSE;
  sb := GetButton(FALSE);
  if (assigned(sb)) then sb.Down := FALSE;
end;

procedure TORDropPanel.Resize;
var
  half: integer;
  btn: TSpeedButton;

begin
  inherited;
  if (FButtons) then
  begin
    btn := GetButton(TRUE);
    if (assigned(btn)) then
    begin
      half := width div 2;
      btn.Left := 0;
      btn.Width := Half;
      btn.Top := Height - btn.Height;
      btn := GetButton(FALSE);
      btn.Left := Half;
      btn.Width := Width - Half;
      btn.Top := Height - btn.Height;
    end;
  end;
end;

procedure TORDropPanel.UpdateButtons;
var
  btn: TSpeedButton;
  cbo: TORComboBox;
  i: integer;

begin
  cbo := (Owner as TORComboBox);
  if (cbo.FListBox.FCheckBoxes) then
  begin
    if (not FButtons) then
    begin
      btn := TSpeedButton.Create(Self);
      btn.Parent := Self;
      btn.Caption := 'OK';
      btn.Height := CheckComboBtnHeight;
      btn.Tag := OKBtnTag;
      btn.AllowAllUp := TRUE;
      btn.GroupIndex := 1;
      btn.OnClick := BtnClicked;
      btn := TSpeedButton.Create(Self);
      btn.Parent := Self;
      btn.Caption := 'Cancel';
      btn.Height := CheckComboBtnHeight;
      btn.Tag := CancelBtnTag;
      btn.AllowAllUp := TRUE;
      btn.GroupIndex := 1;
      btn.OnClick := BtnClicked;
      FButtons := TRUE;
      Resize;
    end;
  end
  else
    if (FButtons) then
    begin
      for i := ControlCount - 1 downto 0 do
        if (Controls[i] is TButton) then
          Controls[i].Free;
      FButtons := FALSE;
      Resize;
    end;
end;

procedure TORDropPanel.WMActivateApp(var Message: TMessage);
{ causes drop down list to be hidden when another application is activated (i.e., Alt-Tab) }
begin
  if BOOL(Message.wParam) = False then with Owner as TORComboBox do DroppedDown := False;
end;

{ TORComboEdit ----------------------------------------------------------------------------- }
const
  ComboBoxImages: array[boolean] of string = ('BMP_CBODOWN_DISABLED', 'BMP_CBODOWN');
  BlackComboBoxImages: array[boolean] of string = ('BLACK_BMP_CBODOWN_DISABLED', 'BLACK_BMP_CBODOWN');

procedure TORComboEdit.CreateParams(var Params: TCreateParams);
{ sets a one line edit box to multiline style so the editing rectangle can be changed }
begin
  inherited CreateParams(Params);
// JM - removed multi-line - broke lookup when MaxLength is set, besides, it didn't really
// seem to have an effect on the editing rectangle anyway.
// agp change cause tab characters to show on meds and lab order dialogs
//  Params.Style := Params.Style {or ES_MULTILINE} or WS_CLIPCHILDREN;
    if TForm(self.Owner.Owner) <> nil then Params.Style := Params.Style or ES_MULTILINE or WS_CLIPCHILDREN
    else Params.Style := Params.Style {or ES_MULTILINE} or WS_CLIPCHILDREN;

end;

procedure TORComboEdit.WMKillFocus(var Message: TWMKillFocus);
begin
  inherited;
  with (Owner as TORComboBox) do
  begin
    if (FListBox.FCheckBoxes) and assigned(FEditPanel) and
      (Message.FocusedWnd <> FListBox.Handle) and
      ((not assigned(FDropBtn)) or (Message.FocusedWnd <> FDropBtn.Handle)) then
    begin
      FEditPanel.FFocused := FALSE;
      FEditPanel.Invalidate;
    end;
  end;
end;

procedure TORComboEdit.WMSetFocus(var Message: TWMSetFocus);
begin
  inherited;
  with (Owner as TORComboBox) do
  begin
    if FListBox.FCheckBoxes and assigned(FEditPanel) then
    begin
      HideCaret(Self.Handle);
      FEditPanel.FFocused := TRUE;
      FEditPanel.Invalidate;
    end;
  end;
end;

{ TORComboBox ------------------------------------------------------------------------------ }

constructor TORComboBox.Create(AOwner: TComponent);
{ create the editbox and listbox used for the combobox - the default style is Simple }
begin
  inherited Create(AOwner);
  Width := 121;
  Height := 97;
  FLastInput := '';
  FDropDownCount := 8;
  FStyle := orcsSimple;
  FCheckBoxEditColor := clBtnFace;
  FListBox := TORListBox.Create(Self);
  FListBox.isPartOfComboBox := True;
  FListBox.Parent := Self;
  FListBox.TabStop := False;
  FListBox.OnClick := FwdClick;
  FListBox.OnDblClick := FwdDblClick;
  FListBox.OnMouseUp := FwdMouseUp;
  FListBox.OnNeedData := FwdNeedData;
  FListBox.OnClickCheck := CheckBoxSelected;
  FListBox.IntegralHeight := true;
  FListBox.Visible := True;
  FItems := FListBox.Items;
  FMItems := FListBox.MItems;
  FEditBox := TORComboEdit.Create(Self);
  FEditBox.Parent := Self;
  FEditBox.OnChange := FwdChange;
  FEditBox.OnKeyDown := FwdKeyDown;
  FEditBox.OnKeyPress := FwdKeyPress;
  FEditBox.OnKeyUp := FwdKeyUp;
  FEditBox.OnExit := EditOnExit;
  FEditBox.Visible := True;
  fCharsNeedMatch := 1;
  TimerInterval := KEY_TIMER_DELAY;
  FOwnsData := True;
  FSetItemIndexOnChange := True;
end;

procedure TORComboBox.WMDestroy(var Message: TWMDestroy);
begin
  if (assigned(Owner)) and (csDestroying in Owner.ComponentState) then
    FListBox.DestroyItems;
  inherited;
end;

procedure TORComboBox.CMFontChanged(var Message: TMessage);
{ resize the edit portion of the combobox to match the font }
begin
  inherited;
  AdjustSizeOfSelf;
end;

procedure TORComboBox.WMMove(var Message: TWMMove);
{ for DropDown style, need to hide listbox whenever control moves (since listbox isn't child) }
begin
  inherited;
  DroppedDown := False;
end;

procedure TORComboBox.WMSize(var Message: TWMSize);
{ whenever control is resized, adjust the components (edit, list, button) within it }
begin
  inherited;
  AdjustSizeOfSelf;
end;

procedure TORComboBox.WMTimer(var Message: TWMTimer);
begin
  inherited;
  if (Message.TimerID = KEY_TIMER_ID) then
  begin
    StopKeyTimer;
    if FListBox.LongList and FChangePending then FwdChangeDelayed;
    if Assigned(FOnKeyPause) then FOnKeyPause(Self);
  end;
end;

function TORComboBox.EditControl: TWinControl;
begin
  if (assigned(FEditPanel)) then
    Result := FEditPanel
  else
    Result := FEditBox;
end;

procedure TORComboBox.AdjustSizeOfSelf;
{ adjusts the components of the combobox to fit within the control boundaries }
var
  FontHeight: Integer;
//  cboBtnX, cboBtnY: integer;
  cboYMargin: integer;

begin
  DroppedDown := False;
  FontHeight := FontHeightPixel(Self.Font.Handle);
  if FTemplateField then
  begin
    cboYMargin := 0;
//    cboBtnX := 1;
//    cboBtnY := 1;
  end
  else
  begin
    cboYMargin := CBO_CYMARGIN;
//    cboBtnX := CBO_CXFRAME;
//    cboBtnY := CBO_CXFRAME;
  end;
  Height := HigherOf(FontHeight + cboYMargin, Height); // must be at least as high as text
  EditControl.SetBounds(0, 0, Width, FontHeight + cboYMargin);
  if (assigned(FEditPanel)) then
    FEditBox.SetBounds(2, 3, FEditPanel.Width - 4, FEditPanel.Height - 5);

  if FStyle = orcsDropDown then
  begin
    Height := FontHeight + cboYMargin; // DropDown can only be text height
//    FDropBtn.SetBounds(EditControl.Width - CBO_CXBTN - cboBtnX, 0,
//      CBO_CXBTN, EditControl.Height - cboBtnY);
    FDropBtn.Width := FontHeightPixel(Self.Font.Handle) + 6;//same as TORDateBox
  end else
  begin
    FListBox.SetBounds(0, FontHeight + CBO_CYMARGIN,
      Width, Height - FontHeight - CBO_CYMARGIN);
  end;
  SetEditRect;
end;

procedure TORComboBox.DropButtonDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
{ display the listbox for a DropDown style combobox whenever the drop down button is pressed }
begin
  if (Button = mbLeft) then
  begin
    FFromDropBtn := True;
    DroppedDown := not FDroppedDown;
    FFromDropBtn := False;
  end;
end;

procedure TORComboBox.DropButtonUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
{ shift the focus back to the editbox so the focus rectangle doesn't clutter the button }
begin
  if FDroppedDown then FListBox.MouseCapture := True; // do here so 1st buttonup not captured
  if ShouldFocus(FEditBox) then
    FEditBox.SetFocus;
  If FDroppedDown then fDropPanel.BringToFront;
end;

procedure TORComboBox.DropDownStatusChanged(opened: boolean);
begin
  if not opened then
    SetHintProperties(True, GetParentForm(Self));
end;

procedure TORComboBox.ClearDropDownStatus;
begin
  FDropDownStatusChangedCount := 1;
  DropDownStatusChanged(FALSE);
end;

destructor TORComboBox.Destroy;
begin
  ClearDropDownStatus;
  if FOwnsData then
    FreeAndNil(FData);
  inherited;
end;

procedure TORComboBox.DoEnter;
{var
  key : word;}
{ select all the text in the editbox when recieve focus - done first so OnEnter can deselect }
begin
  //FEditBox.SelectAll;
  //Fix For ClearQuest: HDS00001576
  //This fix has been commented out, becuase it causes problems
{  with FListBox do
  if (Items.Count > 0) and (Not IsAMouseButtonDown()) and (ItemIndex = -1) then
  begin
    key := VK_UP;
    FwdKeyDown(Self,key,[]);
    //Calling keyUp after key down creates a better mimic of a Keystroke.
    FwdKeyUp(Self,key,[]);   //fixes clearquest: HDS00001418
  end;              }
  inherited DoEnter;
  PostMessage(Handle, UM_GOTFOCUS, 0, 0)
end;

procedure TORComboBox.UMGotFocus(var Message: TMessage);
begin
  if ShouldFocus(FEditBox) then
  begin
    FEditBox.SetFocus;
    if AutoSelect then FEditBox.SelectAll;
  end;
end;

procedure TORComboBox.DoExit;
{ make sure DropDown list is raised when losing focus }
begin
  DroppedDown := False;
  if FKeyTimerActive then
  begin
    StopKeyTimer;
    if FListBox.LongList and FChangePending then FwdChangeDelayed;
  end;
  inherited DoExit;
end;

procedure TORComboBox.LoadComboBoxImage;
var
  imageName: string;
begin
  if assigned(FDropBtn) then
  begin
    if FBlackColorMode then
      imageName := BlackComboBoxImages[inherited Enabled]
    else
      imageName := ComboBoxImages[inherited Enabled];
    FDropBtn.Glyph.LoadFromResourceName(hInstance, imageName);
  end;
end;

procedure TORComboBox.Loaded;
{ we need to call the loaded method for the listbox child (it's not called automatically) }
begin
  inherited Loaded;
  FListBox.Loaded;
end;

procedure TORComboBox.FwdChange(Sender: TObject);
{ allow timer to call FwdChangeDelayed if long list, otherwise call directly }
begin
  if FFromSelf then Exit;
  FChangePending := True;
  if FListBox.LongList and FKeyIsDown then Exit;
  FwdChangeDelayed;
end;

procedure TORComboBox.FwdChangeDelayed;
{ when user types in the editbox, find a partial match in the listbox & set into editbox }
var
  SelectIndex: Integer;
  x: string;
begin
  FChangePending := False;
  if (not FListItemsOnly) and (Length(FEditBox.Text) > 0) and (FEditBox.SelStart = 0) then Exit; // **KCM** test this!
  with FEditBox do x := Copy(Text, 1, SelStart);
  FLastInput := x;
  SelectIndex := -1;
  if Length(x) >= CharsNeedMatch then
    SelectIndex := FListBox.SelectString(x);
  if (Length(x) < CharsNeedMatch) and (FListBox.ItemIndex > -1) then
    SelectIndex := FListBox.SelectString(x);
  if UniqueAutoComplete then
    SelectIndex := FListBox.VerifyUnique(SelectIndex, x);
  if FListItemsOnly and (SelectIndex < 0) and (x <> '') then
  begin
    FFromSelf := True;
    x := FLastFound;
    SelectIndex := FListBox.SelectString(x);
    FEditBox.Text := GetEditBoxText(SelectIndex);
    if (not FListBox.FCheckBoxes) then
      SendMessage(FEditBox.Handle, EM_SETSEL, Length(FEditBox.Text), Length(x));
    FFromSelf := False;
    Exit; // OnChange not called in this case
  end;
  FFromSelf := True;
  if SelectIndex > -1 then
  begin
    FEditBox.Text := GetEditBoxText(SelectIndex);
    FLastFound := x;
    if (not FListBox.FCheckBoxes) then
      SendMessage(FEditBox.Handle, EM_SETSEL, Length(FEditBox.Text), Length(x));
  end else
  begin
    if (FListBox.CheckBoxes) then
      FEditBox.Text := GetEditBoxText(SelectIndex)
    else
      FEditBox.Text := x; // no match, so don't set FLastFound
    FEditBox.SelStart := Length(x);
  end;
  FFromSelf := False;
  if (not FListBox.FCheckBoxes) then
    if Assigned(FOnChange) then FOnChange(Self);
end;

(*
procedure TORComboBox.FwdChangeDelayed;
{ when user types in the editbox, find a partial match in the listbox & set into editbox }
var
  SelectIndex: Integer;
  x: string;
begin
  FChangePending := False;
  with FEditBox do x := Copy(Text, 1, SelStart);
  if x = FLastInput then Exit;  // this change event is just removing the selected text
  FLastInput := x;
  SelectIndex := FListBox.SelectString(x);
  FFromSelf := True;
  if SelectIndex > -1 then
  begin
    FEditBox.Text := GetEditBoxText(SelectIndex);
    if(not FListBox.FCheckBoxes) then
      SendMessage(FEditBox.Handle, EM_SETSEL, Length(FEditBox.Text), Length(x));
  end else
  begin
    FEditBox.Text := x;
    FEditBox.SelStart := Length(x);
  end;
  FFromSelf := False;
  if(not FListBox.FCheckBoxes) then
    if Assigned(FOnChange) then FOnChange(Self);
end;
*)

procedure TORComboBox.FwdClick(Sender: TObject);
{ places the text of the item that was selected from the listbox into the editbox }
begin
  if FListBox.ItemIndex > -1 then
  begin
    FFromSelf := True;
    FListBox.FFocusIndex := FListBox.ItemIndex; // FFocusIndex used so ItemTip doesn't flash
    FEditBox.Text := GetEditBoxText(FListBox.ItemIndex);
    FLastFound := FEditBox.Text;
    FFromSelf := False;
    // not sure why this must be posted (put at the back of the message queue), but for some
    // reason FEditBox.SelectAll selects successfully then deselects on exiting this procedure
    if (not FListBox.FCheckBoxes) then
      PostMessage(FEditBox.Handle, EM_SETSEL, 0, Length(FEditBox.Text));
    if ShouldFocus(FEditBox) then
      FEditBox.SetFocus;
  end;
  if Assigned(FOnClick) then FOnClick(Self);
  if (not FListBox.FCheckBoxes) then
    if Assigned(FOnChange) then FOnChange(Self); // click causes both click & change events
end;

procedure TORComboBox.FwdDblClick(Sender: TObject);
{ surfaces the double click event from the listbox so it is available as a combobox property }
begin
  if Assigned(FOnDblClick) then FOnDblClick(Self);
end;

procedure TORComboBox.FwdKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
{ passed selected navigation keys to listbox, applies special handling to backspace and F4 }
var
  i, iPos: Integer;
  x, AString: string;
begin
  // special case: when default action taken (RETURN) make sure FwdChangeDelayed is called first
  if (Key = VK_RETURN) and FListBox.LongList and FChangePending then FwdChangeDelayed;
  StopKeyTimer; // stop timer after control keys so in case an exit event is triggered
  if Assigned(FOnKeyDown) then FOnKeyDown(Self, Key, Shift);
  if Key in [VK_PRIOR, VK_NEXT, VK_UP, VK_DOWN] then // navigation
  begin
    if (FStyle = orcsDropDown) and not DroppedDown then DroppedDown := True;
    // handle special case of FocusIndex, WM_KEYDOWN will increment from -1 to 0
    if FListBox.ItemIndex = -1 then
    begin
      FListBox.FFocusIndex := -1;
      //Move to correct position when Unique AutoComplete is on.
      if UniqueAutoComplete then
      begin
        AString := Copy(FEditBox.Text, 1, SelStart);
        iPos := SendMessage(FListBox.Handle, FListBox.SearchMsg, -1, Longint(PChar(AString)));
        if iPos = LB_ERR then iPos := -1;
        if iPos > -1 then
        begin
          FListBox.FFocusIndex := iPos - 1;
          FListBox.ItemIndex := FListBox.FFocusIndex;
        end;
      end;
    end;
    FListBox.Perform(WM_KEYDOWN, Key, 1);
  end;
  if Key in [VK_LBUTTON, VK_RETURN, VK_PRIOR, VK_NEXT, VK_UP, VK_DOWN] then // select item
  begin
    FListBox.Perform(WM_KEYDOWN, VK_LBUTTON, 1);
    FFromSelf := True;
    if FListBox.ItemIndex > -1 then
    begin
      FEditBox.Text := GetEditBoxText(FListBox.ItemIndex);
      FLastFound := FEditBox.Text; //kcm
    end;
    FFromSelf := False;
  end;
  // tell parent about RETURN, ESCAPE so that the default action is taken
  if Key in [VK_RETURN, VK_ESCAPE, VK_TAB] then SendMessage(Parent.Handle, CN_KEYDOWN, Key, 0);
  if Key = VK_BACK then // backspace
  begin
    FFromSelf := True;
    x := FEditBox.Text;
    i := FEditBox.SelStart;
    Delete(x, i + 1, Length(x));
    if (FListBox.FCheckBoxes) then
      FEditBox.Text := GetEditBoxText(ItemIndex)
    else
      FEditBox.Text := x;
    FLastFound := x;
    FEditBox.SelStart := i;
    FFromSelf := False;
  end;
  if (FStyle = orcsDropDown) and (Key = VK_F4) then DroppedDown := not DroppedDown; // drop

  if (Key = VK_SPACE) and (FListBox.FCheckBoxes) and (FListBox.ItemIndex > -1) then
    FListBox.ToggleCheckBox(FListBox.ItemIndex);

  if (FStyle = orcsDropDown) and (FListBox.FCheckBoxes) then
  begin
    if Key = VK_RETURN then DropPanelBtnPressed(TRUE, TRUE);
    if Key = VK_ESCAPE then DropPanelBtnPressed(FALSE, TRUE);
  end;

  FKeyIsDown := True;
end;

procedure TORComboBox.FwdKeyPress(Sender: TObject; var Key: Char);
var
  KeyCode: integer;
{ prevents return from being used by editbox (otherwise sends a newline & text vanishes) }
begin
  KeyCode := ord(Key);
  if (KeyCode = VK_RETURN) and (Style = orcsDropDown) and DroppedDown then
  begin
    DroppedDown := FALSE;
    Key := #0;
  end
  else
  begin
    // may want to make the tab beep if tab key (#9) - can't tab until list raised
    if (KeyCode = VK_RETURN) or (KeyCode = VK_TAB) or (FListBox.FCheckBoxes and (KeyCode = VK_SPACE)) then
    begin
      Key := #0;
      Exit;
    end;
    if Assigned(FOnKeyPress) then FOnKeyPress(Self, Key);
  end;
end;

procedure TORComboBox.FwdKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
{ surfaces the key up event from the editbox so it is available as a combobox property }
begin
  FKeyIsDown := False;
  // tell parent about RETURN, ESCAPE so that the default action is taken
  if Key in [VK_RETURN, VK_ESCAPE, VK_TAB] then SendMessage(Parent.Handle, CN_KEYUP, Key, 0);
  if Assigned(FOnKeyUp) then FOnKeyUp(Self, Key, Shift);
  StartKeyTimer;
end;

procedure TORComboBox.FwdMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if Assigned(FOnMouseClick) then FOnMouseClick(Self);
end;

procedure TORComboBox.FwdNeedData(Sender: TObject; const StartFrom: string;
  Direction, InsertAt: Integer);
{ surfaces the need data event from the (long) listbox so it is available as a property }
begin
  if GetLongList and Assigned(FOnNeedData) then
    FOnNeedData(Self, copy(StartFrom, 1, MaxNeedDataLen), Direction, InsertAt);
end;

procedure TORComboBox.SetDropDownCount(Value: Integer);
{ when the listbox is dropped, it's sized according to Value (ItemHeight * DropDownCount) }
begin
  if Value > 0 then FDropDownCount := Value;
end;

procedure TORComboBox.SetDroppedDown(Value: Boolean);
{ for DropDown combo, display the listbox at the appropriate full screen coordinates }
const
  MIN_ITEMS = 3; // minimum visible items for long list
var
  ScreenPoint: TPoint;
  DropDownCnt: Integer;
  PnlHeight: integer;
begin
  if (Value = FDroppedDown) or (FStyle <> orcsDropDown) then Exit;
  FDroppedDown := Value;
  if FDroppedDown = True then
  begin
    FDropPanel.Visible := True; // This is where ItemHeight gets set to the correct value. Before this it is unreliable.
    if Assigned(FOnDropDown) then FOnDropDown(Self);
    if FListBox.LongList
      then DropDownCnt := HigherOf(FDropDownCount, MIN_ITEMS)
    else DropDownCnt := LowerOf(FDropDownCount, FListBox.Items.Count);
    FListBox.SetBounds(0, 0, Width, (FListBox.ItemHeight * DropDownCnt) + CBO_CXFRAME);
    // need to make this smart enough to drop the list UP when necessary ***
    ScreenPoint := Self.ClientToScreen(Point(0, EditControl.Height));

    PnlHeight := FListBox.Height;
    if (FListBox.FCheckBoxes) then
      inc(PnlHeight, CheckComboBtnHeight);
    FDropPanel.SetBounds(ScreenPoint.X, ScreenPoint.Y, FListBox.Width, PnlHeight);
    if (FListBox.FCheckBoxes) then
    begin
      FDropPanel.ResetButtons;
      FCheckedState := FListBox.GetCheckedString;
    end;
    DropDownStatusChanged(TRUE);
    FDropPanel.BringToFront;
    if FListBox.FScrollBar <> nil then FListBox.FScrollBar.BringToFront;
    if not FFromDropBtn then FListBox.MouseCapture := True; // otherwise ButtonUp captures
  end else
  begin
    if Assigned(FOnDropDownClose) then FOnDropDownClose(Self);
    FListBox.MouseCapture := False;
    uItemTip.Hide;
    FDropPanel.Hide;
    DropDownStatusChanged(FALSE);
    if (FListBox.FCheckBoxes) and (assigned(FOnChange)) and
      (FCheckedState <> FListBox.GetCheckedString) then
      FOnChange(Self);
  end;
end;

procedure TORComboBox.SetEditRect;
{ change the edit rectangle to not hide the dropdown button - taken from SPIN.PAS sample }
var
  Loc: TRect;
begin
  SendMessage(FEditBox.Handle, EM_GETRECT, 0, LongInt(@Loc));
//  Loc.Bottom := ClientHeight + 1; // +1 is workaround for windows paint bug
  if FStyle = orcsDropDown then
  begin
    Loc.Right := ClientWidth - FDropBtn.Width - CBO_CXFRAME; // edit up to button
    if (FTemplateField) then
      inc(Loc.Right, 3);
  end
  else
    Loc.Right := ClientWidth - CBO_CXFRAME; // edit in full edit box
  Loc.Top := 1;//0
  if (FTemplateField) then
    Loc.Left := 4 //2
  else
    Loc.Left := 4; //0;
  SendMessage(FEditBox.Handle, EM_SETRECTNP, 0, LongInt(@Loc));
end;

procedure TORComboBox.SetEditText(const Value: string);
{ allows the text to change when ItemIndex is changed without triggering a change event }
begin
  FFromSelf := True;
  FEditBox.Text := Value;
  FLastFound := FEditBox.Text;
  FFromSelf := False;
  PostMessage(FEditBox.Handle, EM_SETSEL, 0, Length(FEditBox.Text));
end;

procedure TORComboBox.SetItemIndex(Value: Integer);
var
  callChange: boolean;
{ set the ItemIndex in the listbox and update the editbox to show the DisplayText }
begin
  with FListBox do
  begin
    callChange := ItemIndex <> Value;
    ItemIndex := Value;
    { should Value = -1 be handled in the SetFocusIndex procedure itself? or should it be
      handled by the setting of the ItemIndex property? }
    if Value = -1 then FFocusIndex := -1 else FocusIndex := Value;
    if assigned(uItemTip) then
      uItemTip.Hide;
    if (FListBox.CheckBoxes) then
      SetEditText(GetEditBoxText(ItemIndex))
    else
    begin
      if ItemIndex > -1 then
        SetEditText(GetEditBoxText(ItemIndex))
      else
        SetEditText('');
    end;
  end;
  if callChange and FSetItemIndexOnChange and Assigned(FOnChange) then
    FOnChange(Self);
end;

function TORComboBox.SelectByIEN(AnIEN: Int64): Integer;
begin
  Result := FListBox.SelectByIEN(AnIEN);
  SetItemIndex(Result);
end;

function TORComboBox.SelectByID(const AnID: string): Integer;
begin
  Result := FListBox.SelectByID(AnID);
  SetItemIndex(Result);
end;

function TORComboBox.SetExactByIEN(AnIEN: Int64; const AnItem: string): Integer;
begin
  Result := FListBox.SetExactByIEN(AnIEN, AnItem);
  SetItemIndex(Result);
end;

procedure TORComboBox.SetStyle(Value: TORComboStyle);
{ Simple:   get rid of dropdown button & panel, make combobox parent of listbox
  DropDown: create dropdown button & panel, transfer listbox parent to dropdown panel
            this allows the dropped list to overlap other windows }
begin
  if Value <> FStyle then
  begin
    FStyle := Value;
    if FStyle = orcsSimple then
    begin
      if FDropBtn <> nil then FDropBtn.Free;
      if FDropPanel <> nil then
      begin
        ClearDropDownStatus;
        FDropPanel.Free;
      end;
      FDropBtn := nil;
      FDropPanel := nil;
      FListBox.FParentCombo := nil;
      FListBox.Parent := Self;
      if FListBox.FScrollBar <> nil then FListBox.FScrollBar.Parent := Self; // if long
      FListBox.Visible := True;
    end else
    begin
      FDropBtn := TBitBtn.Create(Self);
      if (assigned(FEditPanel) and (csDesigning in ComponentState)) then
        FEditPanel.ControlStyle := FEditPanel.ControlStyle + [csAcceptsControls];
      FDropBtn.Parent := FEditBox;
      fDropBtn.Align := alRight;
      fDropBtn.AlignWithMargins := False;
      if (assigned(FEditPanel) and (csDesigning in ComponentState)) then
        FEditPanel.ControlStyle := FEditPanel.ControlStyle - [csAcceptsControls];
      LoadComboBoxImage;
//      FDropBtn.Glyph.LoadFromResourceName(hInstance, ComboBoxImages[inherited Enabled]);
      FDropBtn.OnMouseDown := DropButtonDown;
      FDropBtn.OnMouseUp := DropButtonUp;
      FDropBtn.TabStop := False;
      FDropBtn.Visible := True;
      FDropBtn.BringToFront;
      if not (csDesigning in ComponentState) then
      begin
        FDropPanel := TORDropPanel.Create(Self);
        FDropPanel.Parent := Self; // parent is really the desktop - see CreateParams
        FListBox.FParentCombo := Self;
        FListBox.Parent := FDropPanel;
        ClearDropDownStatus;
        if FListBox.FScrollBar <> nil then FListBox.FScrollBar.Parent := FDropPanel; // if long
      end else
      begin
        FListBox.Visible := False;
      end;
      Height := EditControl.Height;
    end;
    AdjustSizeOfSelf;
  end;
end;

procedure TORComboBox.StartKeyTimer;
{ start (or restart) a timer (done on keyup to delay before calling OnKeyPause) }
var
  ATimerID: Integer;
begin
  if FListBox.LongList or Assigned(FOnKeyPause) then
  begin
    StopKeyTimer;
    ATimerID := SetTimer(Handle, KEY_TIMER_ID, FTimerInterval, nil);
    FKeyTimerActive := ATimerID > 0;
    // if can't get a timer, just call the OnKeyPause event immediately
    if not FKeyTimerActive then Perform(WM_TIMER, KEY_TIMER_ID, 0);
  end;
end;

procedure TORComboBox.StopKeyTimer;
{ stop the timer (done whenever a key is pressed or the combobox no longer has focus) }
begin
  if FKeyTimerActive then
  begin
    KillTimer(Handle, KEY_TIMER_ID);
    FKeyTimerActive := False;
  end;
end;

function TORComboBox.SupportsDynamicProperty(PropertyID: integer): boolean;
begin
  Result := (PropertyID = DynaPropAccesibilityCaption);
end;

// Since TORComboBox is composed of several controls (FEditBox, FListBox, FDropBtn), the
// following functions and procedures map public and published properties to their related
// subcomponents.

function TORComboBox.AddReference(const S: string; AReference: Variant): Integer;
begin
  Result := FListBox.AddReference(S, AReference);
end;

procedure TORComboBox.Clear;
begin
  FListBox.Clear;
  FEditBox.Clear;
end;

procedure TORComboBox.ClearTop;
begin
  FListBox.ClearTop;
end;

procedure TORComboBox.ForDataUse(Strings: TStrings);
begin
  FListBox.ForDataUse(Strings);
end;

procedure TORComboBox.InitLongList(S: string);
begin
  FListBox.InitLongList(S);
end;

function TORComboBox.IndexOfReference(AReference: Variant): Integer;
begin
  Result := FListBox.IndexOfReference(AReference);
end;

procedure TORComboBox.InsertReference(Index: Integer; const S: string; AReference: Variant);
begin
  FListBox.InsertReference(Index, S, AReference);
end;

procedure TORComboBox.InsertSeparator;
begin
  FListBox.InsertSeparator;
end;

procedure TORComboBox.Invalidate;
begin
  inherited;
  FEditBox.Invalidate;
  FListBox.Invalidate;
  if assigned(FEditPanel) then
    FEditPanel.Invalidate;
  if assigned(FDropBtn) then
    FDropBtn.Invalidate;
  if assigned(FDropPanel) then
    FDropPanel.Invalidate;
end;

function TORComboBox.GetAutoSelect: Boolean;
begin
  Result := FEditBox.AutoSelect;
end;

function TORComboBox.GetColor: TColor;
begin
  Result := FListBox.Color;
end;

function TORComboBox.GetDelimiter: Char;
begin
  Result := FListBox.Delimiter;
end;

function TORComboBox.GetDisplayText(Index: Integer): string;
begin
  Result := FListBox.DisplayText[Index];
end;

function TORComboBox.GetDynamicProperty(PropertyID: integer): string;
begin
  if PropertyID = DynaPropAccesibilityCaption then
    Result := GetCaption
  else
    Result := '';
end;

function TORComboBox.GetItemHeight: Integer;
begin
  Result := FListBox.ItemHeight;
end;

function TORComboBox.GetIEN(AnIndex: Integer): Int64;
begin
  Result := FListBox.GetIEN(AnIndex);
end;

function TORComboBox.GetItemID: Variant;
begin
  Result := FListBox.ItemID;
end;

function TORComboBox.GetItemIEN: Int64;
begin
  Result := FListBox.ItemIEN;
end;

function TORComboBox.GetItemIndex: Integer;
begin
  Result := FListBox.ItemIndex;
end;

function TORComboBox.GetItemTipEnable: Boolean;
begin
  Result := FListBox.ItemTipEnable;
end;

function TORComboBox.GetItemTipColor: TColor;
begin
  Result := FListBox.ItemTipColor;
end;

function TORComboBox.GetLongList: Boolean;
begin
  Result := FListBox.LongList;
end;

function TORComboBox.GetMaxLength: Integer;
begin
  Result := FEditBox.MaxLength;
end;

function TORComboBox.GetPieces: string;
begin
  Result := FListBox.Pieces;
end;

function TORComboBox.GetReference(Index: Integer): Variant;
begin
  Result := FListBox.References[Index];
end;

function TORComboBox.GetSelLength: Integer;
begin
  Result := FEditBox.SelLength;
end;

function TORComboBox.GetSelStart: Integer;
begin
  Result := FEditBox.SelStart;
end;

function TORComboBox.GetSelText: string;
begin
  Result := FEditBox.SelText;
end;

function TORComboBox.GetShortCount: Integer;
begin
  Result := FListBox.ShortCount;
end;

function TORComboBox.GetSorted: Boolean;
begin
  Result := FListBox.Sorted;
end;

function TORComboBox.GetHideSynonyms: boolean;
begin
  Result := FListBox.HideSynonyms;
end;

function TORComboBox.GetSynonymChars: string;
begin
  result := FListBox.SynonymChars;
end;

procedure TORComboBox.SetHideSynonyms(Value: boolean);
begin
  FListBox.HideSynonyms := Value;
end;

procedure TORComboBox.SetSynonymChars(Value: string);
begin
  FListBox.SynonymChars := Value;
end;

function TORComboBox.GetTabPositions: string;
begin
  Result := FListBox.TabPositions;
end;

function TORComboBox.GetTabStop: Boolean;
begin
  if csDesigning in ComponentState then
    Result := inherited TabStop
  else
    Result := False;
end;

function TORComboBox.GetTabPosInPixels: boolean;
begin
  Result := FListBox.TabPosInPixels;
end;

function TORComboBox.GetText: string;
begin
  Result := FEditBox.Text;
end;

procedure TORComboBox.SelectAll;
begin
  FEditBox.SelectAll;
end;

procedure TORComboBox.SetAutoSelect(Value: Boolean);
begin
  FEditBox.AutoSelect := Value;
end;

procedure TORComboBox.SetBlackColorMode(Value: boolean);
begin
  if FBlackColorMode <> Value then
  begin
    FBlackColorMode := Value;
    FListBox.SetBlackColorMode(Value);
    LoadComboBoxImage;
  end;
end;

procedure TORComboBox.SetColor(Value: TColor);
begin
  if (not FListBox.CheckBoxes) then
    FEditBox.Color := Value;
  FListBox.Color := Value;
end;

procedure TORComboBox.SetDelimiter(Value: Char);
begin
  FListBox.Delimiter := Value;
end;

procedure TORComboBox.SetItemHeight(Value: Integer);
begin
  FListBox.ItemHeight := Value;
end;

procedure TORComboBox.SetItemTipEnable(Value: Boolean);
begin
  FListBox.ItemTipEnable := Value;
end;

procedure TORComboBox.SetItemTipColor(Value: TColor);
begin
  FListBox.ItemTipColor := Value;
end;

procedure TORComboBox.SetLongList(Value: Boolean);
begin
  FListBox.LongList := Value;
end;

procedure TORComboBox.SetMaxLength(Value: Integer);
begin
  FEditBox.MaxLength := Value;
end;

procedure TORComboBox.SetPieces(const Value: string);
begin
  FListBox.Pieces := Value;
end;

procedure TORComboBox.SetReference(Index: Integer; AReference: Variant);
begin
  FListBox.References[Index] := AReference;
end;

procedure TORComboBox.SetSelLength(Value: Integer);
begin
  FEditBox.SelLength := Value;
end;

procedure TORComboBox.SetSelStart(Value: Integer);
begin
  FEditBox.SelStart := Value;
end;

procedure TORComboBox.SetSelText(const Value: string);
begin
  FEditBox.SelText := Value;
end;

procedure TORComboBox.SetSorted(Value: Boolean);
begin
  FListBox.Sorted := Value;
end;

procedure TORComboBox.SetTabPositions(const Value: string);
begin
  FListBox.TabPositions := Value;
end;

procedure TORComboBox.SetTabStop(const Value: Boolean);
begin
  if csDesigning in ComponentState then
    inherited TabStop := Value
  else
    inherited TabStop := False
end;

procedure TORComboBox.SetTabPosInPixels(const Value: boolean);
begin
  FListBox.TabPosInPixels := Value;
end;

procedure TORComboBox.SetText(const Value: string);
begin
  FEditBox.Text := Value; // kcm ???
end;

procedure TORComboBox.SetItems(const Value: TStrings);
begin
  FItems.Assign(Value);
end;

function TORComboBox.GetCheckBoxes: boolean;
begin
  Result := FListBox.FCheckBoxes;
end;

function TORComboBox.GetChecked(Index: Integer): Boolean;
begin
  Result := FListBox.GetChecked(Index);
end;

function TORComboBox.GetCheckEntireLine: boolean;
begin
  Result := FListBox.FCheckEntireLine;
end;

function TORComboBox.GetFlatCheckBoxes: boolean;
begin
  Result := FListBox.FFlatCheckBoxes;
end;

procedure TORComboBox.SetCheckBoxes(const Value: boolean);
begin
  if (FListBox.FCheckBoxes <> Value) then
  begin
    FListBox.SetCheckBoxes(Value);
    if (assigned(FDropPanel)) then
      FDropPanel.UpdateButtons;
    FEditBox.Visible := FALSE;
    try
      if (Value) then
      begin
        SetListItemsOnly(TRUE);
        SetAutoSelect(FALSE);
        FEditBox.Color := FCheckBoxEditColor;
        FEditBox.Text := GetEditBoxText(-1);
        FEditBox.BorderStyle := bsNone;
        FEditBox.align := alClient;

        FEditPanel := TORComboPanelEdit.Create(Self);
        FEditPanel.Parent := Self;
        FEditPanel.BevelOuter := bvNone;// bvRaised
        FEditPanel.BevelInner := bvNone;
        FEditPanel.BorderStyle := bsSingle;
        FEditPanel.Ctl3d := False;
        FEditPanel.BorderWidth := 1;

        FEditBox.Parent := FEditPanel;

        if (csDesigning in ComponentState) then
          FEditPanel.ControlStyle := FEditPanel.ControlStyle - [csAcceptsControls];
      end
      else
      begin
        FEditBox.Parent := Self;
        FEditBox.Color := FListBox.Color;
        FEditBox.BorderStyle := bsSingle;

        FEditPanel.Free;
        FEditPanel := nil;
      end;
    finally
      FEditBox.Visible := TRUE;
    end;
    AdjustSizeOfSelf;
  end;
end;

procedure TORComboBox.SetChecked(Index: Integer; const Value: Boolean);
begin
  FListBox.SetChecked(Index, Value);
  if (assigned(FDropPanel)) then
    FDropPanel.UpdateButtons;
  if (Value) then
    SetListItemsOnly(TRUE);
end;

procedure TORComboBox.SetCheckEntireLine(const Value: boolean);
begin
  FListBox.FCheckEntireLine := Value;
end;

procedure TORComboBox.SetFlatCheckBoxes(const Value: boolean);
begin
  FListBox.SetFlatCheckBoxes(Value);
end;

procedure TORComboBox.DropPanelBtnPressed(OKBtn, AutoClose: boolean);
var
  btn: TSpeedButton;

begin
  if (assigned(FDropPanel)) then
  begin
    btn := FDropPanel.GetButton(OKBtn);
    if (assigned(Btn)) then
      Btn.Down := TRUE;
  end;
  if (not OKBtn) then FListBox.SetCheckedString(FCheckedState);
  if (AutoClose) then
  begin
    FListBox.FDontClose := FALSE;
    DroppedDown := False;
  end;
  UpdateCheckEditBoxText;
end;

function TORComboBox.GetCheckedString: string;
begin
  Result := FListBox.GetCheckedString;
end;

procedure TORComboBox.SetCheckedString(const Value: string);
begin
  FListBox.SetCheckedString(Value);
end;

procedure TORComboBox.SetCheckBoxEditColor(const Value: TColor);
begin
  if (FCheckBoxEditColor <> Value) then
  begin
    FCheckBoxEditColor := Value;
    if (FListBox.FCheckBoxes) then
      FEditBox.Color := FCheckBoxEditColor;
  end;
end;

procedure TORComboBox.SetListItemsOnly(const Value: Boolean);
begin
  if (FListItemsOnly <> Value) then
  begin
    FListItemsOnly := Value;
    if (not Value) then
      SetCheckBoxes(FALSE);
  end;
end;

procedure TORComboBox.SetOnCheckedText(const Value: TORCheckComboTextEvent);
begin
  FOnCheckedText := Value;
  FEditBox.Text := GetEditBoxText(-1);
end;

procedure TORComboBox.SetTemplateField(const Value: boolean);
begin
  if (FTemplateField <> Value) then
  begin
    FTemplateField := Value;
    if (Value) then
    begin
      SetStyle(orcsDropDown);
      FEditBox.BorderStyle := bsNone
    end
    else
      FEditBox.BorderStyle := bsSingle;
    AdjustSizeOfSelf;
  end;
end;

function TORComboBox.GetOnSynonymCheck: TORSynonymCheckEvent;
begin
  Result := FListBox.FOnSynonymCheck;
end;

procedure TORComboBox.SetOnSynonymCheck(const Value: TORSynonymCheckEvent);
begin
  FListBox.FOnSynonymCheck := Value;
end;

function TORComboBox.GetEnabled: boolean;
begin
  Result := inherited GetEnabled;
end;

procedure TORComboBox.SetEnabled(Value: boolean);
begin
  if (inherited GetEnabled <> Value) then
  begin
    DroppedDown := FALSE;
    inherited SetEnabled(Value);
    if assigned(FDropBtn) then
      LoadComboBoxImage;
//      FDropBtn.Glyph.LoadFromResourceName(hInstance, ComboBoxImages[Value]);
  end;
end;

function TORComboBox.GetEditBoxText(Index: Integer): string;
var
  i, cnt: integer;

begin
  if (FListBox.FCheckBoxes) then
  begin
    Result := '';
    cnt := 0;
    for i := 0 to FListBox.Items.Count - 1 do
    begin
      if (FListBox.Checked[i]) then
      begin
        inc(cnt);
        if (Result <> '') then
          Result := Result + ', ';
        Result := Result + FListBox.GetDisplayText(i);
      end;
    end;
    if (assigned(FOnCheckedText)) then
      FOnCheckedText(FListBox, cnt, Result);
  end
  else
    Result := FListBox.GetDisplayText(Index);
end;

procedure TORComboBox.UpdateCheckEditBoxText;
begin
  if (FListBox.FCheckBoxes) then
  begin
    FFromSelf := TRUE;
    FEditBox.Text := GetEditBoxText(-1);
    FEditBox.SelLength := 0;
    FFromSelf := FALSE;
  end;
end;

procedure TORComboBox.CheckBoxSelected(Sender: TObject; Index: integer);
begin
  UpdateCheckEditBoxText;
  if (FStyle <> orcsDropDown) and (assigned(FOnChange)) then
    FOnChange(Self);
end;

function TORComboBox.GetMItems: TStrings;
begin
  result := FMItems;
end;

procedure TORComboBox.SetCaption(const Value: string);
begin
  FListBox.Caption := Value;
end;

function TORComboBox.GetCaption: string;
begin
  result := FListBox.Caption;
end;

function TORComboBox.GetCaseChanged: boolean;
begin
  result := FListBox.CaseChanged;
end;

procedure TORComboBox.SetCaseChanged(const Value: boolean);
begin
  FListBox.CaseChanged := Value;
end;

function TORComboBox.GetLookupPiece: integer;
begin
  result := FListBox.LookupPiece;
end;

procedure TORComboBox.SetLookupPiece(const Value: integer);
begin
  FListBox.LookupPiece := Value;
end;

procedure TORComboBox.setOnDrawItem(aValue: TDrawItemEvent);
begin
  fOnDrawItem := aValue;
  FListBox.Style := lbOwnerDrawFixed;
  FListBox.OnDrawItem := aValue;
end;

procedure TORComboBox.EditOnExit(Sender: TObject);
begin
  FListBox.Invalidate;
end;

{ TSizeRatio methods }

constructor TSizeRatio.Create(ALeft, ATop, AWidth, AHeight: Extended);
{ creates an object that records the initial relative size & position of a control }
begin
  CLeft := ALeft; CTop := ATop; CWidth := AWidth; CHeight := AHeight;
end;

{ TORAutoPanel ----------------------------------------------------------------------------- }

destructor TORAutoPanel.Destroy;
{ destroy objects used to record size and position information for controls }
var
  SizeRatio: TSizeRatio;
  i: Integer;
begin
  if FSizes <> nil then with FSizes do for i := 0 to Count - 1 do
      begin
        SizeRatio := Items[i];
        SizeRatio.Free;
      end;
  FSizes.Free;
  inherited Destroy;
end;

procedure TORAutoPanel.BuildSizes(Control: TWinControl);
var
  i, H, W: Integer;
  SizeRatio: TSizeRatio;
  Child: TControl;
begin
  H := ClientHeight;
  W := ClientWidth;
  if (H = 0) or (W = 0) then exit;
  for i := 0 to Control.ControlCount - 1 do
  begin
    Child := Control.Controls[i];
    with Child do
      SizeRatio := TSizeRatio.Create(Left / W, Top / H, Width / W, Height / H);
    FSizes.Add(SizeRatio); //FSizes is in tree traversal order.
    //TGroupBox is currently the only type of container that is having these
    //resize problems
    if Child is TGroupBox then
      BuildSizes(TWinControl(Child));
  end;
end;

procedure TORAutoPanel.Loaded;
{ record initial size & position info for resizing logic }
begin
  inherited Loaded;
  if csDesigning in ComponentState then Exit; // only want auto-resizing at run time
  FSizes := TList.Create;
  BuildSizes(Self);
end;

procedure TORAutoPanel.DoResize(Control: TWinControl; var CurrentIndex: Integer);
var
  i, H, W: Integer;
  SizeRatio: TSizeRatio;
  Child: TControl;
begin
  H := ClientHeight;
  W := ClientWidth;
  for i := 0 to Control.ControlCount - 1 do
  begin
    Child := Control.Controls[i];
    if CurrentIndex = FSizes.Count then break;
//      raise Exception.Create('Error while Sizing Auto-Size Panel');
    SizeRatio := FSizes[CurrentIndex];
    inc(CurrentIndex);
    with SizeRatio do begin
      if (Child is TLabel) or (Child is TStaticText) then
        Child.SetBounds(Round(CLeft * W), Round(CTop * H), Child.Width, Child.Height)
      else
        Child.SetBounds(Round(CLeft * W), Round(CTop * H), Round(CWidth * W), Round(CHeight * H));
    end;
    if Child is TGroupBox then
      DoResize(TwinControl(Child), CurrentIndex);
  end;
end;

procedure TORAutoPanel.Resize;
{ resize child controls using their design time proportions }
var
  i: Integer;
begin
  inherited Resize;
  if csDesigning in ComponentState then Exit; // only want auto-resizing at run time
  i := 0;
  DoResize(Self, i);
end;

{ TOROffsetLabel --------------------------------------------------------------------------- }

constructor TOROffsetLabel.Create(AOwner: TComponent);
{ create the label with the default of Transparent = False and Offset = 2}
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csOpaque];
  FHorzOffset := 2;
  FVertOffset := 2;
end;

procedure TOROffsetLabel.CMTextChanged(var Message: TMessage);
{ resize whenever the label caption changes }
begin
  inherited;
  AdjustSizeOfSelf;
end;

procedure TOROffsetLabel.CMFontChanged(var Message: TMessage);
{ resize whenever the label font changes }
begin
  inherited;
  AdjustSizeOfSelf;
end;

procedure TOROffsetLabel.AdjustSizeOfSelf;
{ using the current font, call DrawText to calculate the rectangle size for the label }
var
  DC: HDC;
  Flags: Word;
  ARect: TRect;
begin
  if not (csReading in ComponentState) then
  begin
    DC := GetDC(0);
    Canvas.Handle := DC;
    ARect := ClientRect;
    Flags := DT_EXPANDTABS or DT_CALCRECT;
    if FWordWrap then Flags := Flags or DT_WORDBREAK;
    DoDrawText(ARect, Flags); // returns size of text rect
    Canvas.Handle := 0;
    ReleaseDC(0, DC);
    // add alignment property later?
    SetBounds(Left, Top, ARect.Right + FHorzOffset, ARect.Bottom + FVertOffset); // add offsets
  end;
end;

procedure TOROffsetLabel.DoDrawText(var Rect: TRect; Flags: Word);
{ call drawtext to paint or calculate the size of the text in the caption property }
var
  Text: string;
begin
  Text := Caption;
  Canvas.Font := Font;
  if not Enabled then Canvas.Font.Color := clGrayText;
  DrawText(Canvas.Handle, PChar(Text), Length(Text), Rect, Flags);
end;

procedure TOROffsetLabel.Paint;
{ set the background characterictics, add the offsets, and paint the text }
var
  ARect: TRect;
  Flags: Word;
begin
  with Canvas do
  begin
    if not Transparent then
    begin
      Brush.Color := Self.Color;
      Brush.Style := bsSolid;
      FillRect(ClientRect);
    end;
    Brush.Style := bsClear;
    ARect := ClientRect;
    Inc(ARect.Left, FHorzOffset);
    Inc(ARect.Top, FVertOffset);
    Flags := DT_EXPANDTABS or DT_NOPREFIX or DT_LEFT;
    if FWordWrap then Flags := Flags or DT_WORDBREAK;
    DoDrawText(ARect, Flags);
  end;
end;

function TOROffsetLabel.GetTransparent: Boolean;
{ returns true if the control style is not opaque }
begin
  if csOpaque in ControlStyle then Result := False else Result := True;
end;

procedure TOROffsetLabel.SetTransparent(Value: Boolean);
{ if true, removes Opaque from the control style }
begin
  if Value <> Transparent then
  begin
    if Value
      then ControlStyle := ControlStyle - [csOpaque] // transparent = true
    else ControlStyle := ControlStyle + [csOpaque]; // transparent = false
    Invalidate;
  end;
end;

procedure TOROffsetLabel.SetVertOffset(Value: Integer);
{ adjusts the size of the label whenever the vertical offset of the label changes }
begin
  FVertOffset := Value;
  AdjustSizeOfSelf;
end;

procedure TOROffsetLabel.SetHorzOffset(Value: Integer);
{ adjusts the size of the label whenever the horizontal offset of the label changes }
begin
  FHorzOffset := Value;
  AdjustSizeOfSelf;
end;

procedure TOROffsetLabel.SetWordWrap(Value: Boolean);
{ adjusts the size of the label whenever the word wrap property changes }
begin
  if FWordWrap <> Value then
  begin
    FWordWrap := Value;
    AdjustSizeOfSelf;
  end;
end;

(*
{ TORCalendar }

procedure TORCalendar.DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState);
{ uses the Calendar that is part of Samples and highlights the current date }
var
  TheText: string;
  CurMonth, CurYear, CurDay: Word;
begin
  TheText := CellText[ACol, ARow];
  with ARect, Canvas do
  begin
    DecodeDate(Date, CurYear, CurMonth, CurDay);
    if (CurYear = Year) and (CurMonth = Month) and (IntToStr(CurDay) = TheText) then
    begin
      TheText := '[' + TheText + ']';
      Font.Style := [fsBold];
    end;
    TextRect(ARect, Left + (Right - Left - TextWidth(TheText)) div 2,
      Top + (Bottom - Top - TextHeight(TheText)) div 2, TheText);
  end;
end;
*)

{ TORAlignButton }

constructor TORAlignButton.Create(AOwner: TComponent);
begin
  inherited;
  FAlignment := taCenter;
  FLayout := tlCenter;
  FWordWrap := FALSE;
end;

procedure TORAlignButton.CreateParams(var Params: TCreateParams);
const
  ButtonAlignment: array[TAlignment] of DWORD = (BS_LEFT, BS_RIGHT, BS_CENTER);
  ButtonWordWrap: array[boolean] of DWORD = (0, BS_MULTILINE);
  ButtonLayout: array[TTextLayout] of DWORD = (BS_TOP, BS_VCENTER, BS_BOTTOM);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or ButtonAlignment[FAlignment] or
    ButtonLayout[FLayout] or
    ButtonWordWrap[FWordWrap];
end;

procedure TORAlignButton.SetAlignment(const Value: TAlignment);
begin
  if (FAlignment <> Value) then
  begin
    FAlignment := Value;
    RecreateWnd;
  end;
end;

procedure TORAlignButton.SetLayout(const Value: TTextLayout);
begin
  if (FLayout <> Value) then
  begin
    FLayout := Value;
    RecreateWnd;
  end;
end;

procedure TORAlignButton.SetWordWrap(const Value: boolean);
begin
  if (FWordWrap <> Value) then
  begin
    FWordWrap := Value;
    RecreateWnd;
  end;
end;

{ TORTreeNode }

procedure TORTreeNode.EnsureVisible;
var
  R: TRect;
  DY, LH: integer;

begin
  MakeVisible;
  R := DisplayRect(FALSE);
  if (R.Top < 0) then
    TreeView.TopItem := Self
  else
    if (R.Bottom > TreeView.ClientHeight) then
    begin
      DY := R.Bottom - TreeView.ClientHeight;
      LH := R.Bottom - R.Top + 1;
      DY := (DY div LH) + 1;
      GetORTreeView.SetVertScrollPos(GetORTreeView.GetVertScrollPos + DY);
    end;
end;

function TORTreeNode.GetBold: boolean;
var
  Item: TTVItem;
begin
  Result := False;
  with Item do
  begin
    mask := TVIF_STATE;
    hItem := ItemId;
    if TreeView_GetItem(Handle, Item) then
      Result := (state and TVIS_BOLD) <> 0;
  end;
end;

function TORTreeNode.GetORTreeView: TORTreeView;
begin
  Result := ((inherited TreeView) as TORTreeView);
end;

procedure TORTreeNode.WriteORNodeData(aStream: TStream);
var
  savedTextLen: integer;
  savedBold: boolean;
begin
  aStream.WriteBuffer(FTag, SizeOf(FTag));
  savedTextLen := Length(FStringData);
  aStream.WriteBuffer(savedTextLen, SizeOf(savedTextLen));
  if savedTextLen > 0 then
    aStream.WriteBuffer(FStringData[1], savedTextLen * SizeOf(WideChar));
  savedTextLen := Length(FCaption);
  aStream.WriteBuffer(savedTextLen, SizeOf(savedTextLen));
  if savedTextLen > 0 then
    aStream.WriteBuffer(FCaption[1], savedTextLen * SizeOf(WideChar));
  savedBold := Bold;
  aStream.WriteBuffer(savedBold, SizeOf(savedBold));
end;

procedure TORTreeNode.ReadORNodeData(aStream: TStream);
var
  savedTextLen: integer;
  savedBold: boolean;
begin
  aStream.ReadBuffer(FTag, SizeOf(FTag));
  aStream.ReadBuffer(savedTextLen, SizeOf(savedTextLen));
  if savedTextLen > 0 then
  begin
    SetLength(FStringData, savedTextLen);
    aStream.ReadBuffer(FStringData[1], savedTextLen * SizeOf(WideChar));
  end;
  aStream.ReadBuffer(savedTextLen, SizeOf(savedTextLen));
  if savedTextLen > 0 then
  begin
    SetLength(FCaption, savedTextLen);
    aStream.ReadBuffer(FCaption[1], savedTextLen * SizeOf(WideChar));
  end;
  aStream.ReadBuffer(savedBold, SizeOf(savedBold));
  Bold := savedBold;
end;

function TORTreeNode.GetParent: TORTreeNode;
begin
  Result := ((inherited Parent) as TORTreeNode);
end;

function TORTreeNode.GetText: string;
begin
  Result := inherited Text;
end;

procedure TORTreeNode.SetBold(const Value: boolean);
var
  Item: TTVItem;
  Template: DWORD;

begin
  if Value then Template := DWORD(-1)
  else Template := 0;
  with Item do
  begin
    mask := TVIF_STATE;
    hItem := ItemId;
    stateMask := TVIS_BOLD;
    state := stateMask and Template;
  end;
  TreeView_SetItem(Handle, Item);
end;

procedure TORTreeNode.SetPiece(PieceNum: Integer; const NewPiece: string);
begin
  with GetORTreeView do
  begin
    ORCtrls.SetPiece(FStringData, FDelim, PieceNum, NewPiece);
    if (PieceNum = FPiece) then
      Text := NewPiece;
  end;
end;

procedure TORTreeNode.SetStringData(const Value: string);
begin
  if (FStringData <> Value) then
  begin
    FStringData := Value;
    with GetORTreeView do
      if (FDelim <> #0) and (FPiece > 0) then
        inherited Text := Piece(FStringData, FDelim, FPiece);
  end;
  Caption := Text;
end;

procedure TORTreeNode.SetText(const Value: string);
begin
  UpdateText(Value, TRUE);
end;

procedure TORTreeNode.UpdateText(const Value: string; UpdateData: boolean);
begin
  inherited Text := Value;
  Caption := Text;
  if (UpdateData) then
    with GetORTreeView do
    begin
      if (FDelim <> #0) and (FPiece > 0) then
        ORCtrls.SetPiece(FStringData, FDelim, FPiece, Value);
    end;
end;

function CalcShortName(LongName: string; PrevLongName: string): string;
var
  WordBorder: integer;
  j: integer;
begin
  WordBorder := 1;
  for j := 1 to Length(LongName) do
  begin
    if (LongName[j] = ' ') or ((j > 1) and (LongName[j - 1] = ' ')) or
      ((j = Length(LongName)) and (j = Length(PrevLongName)) and (LongName[j] = PrevLongName[j])) then
      WordBorder := j;
    if (j > Length(PrevLongName)) or (LongName[j] <> PrevLongName[j]) then
      break;
  end;
  if WordBorder = 1 then
    result := LongName
  else if WordBorder = Length(LongName) then
    result := 'Same as above (' + LongName + ')'
  else
    result := Copy(LongName, WordBorder, Length(LongName)) + ' (' + Trim(Copy(LongName, 1, WordBorder - 1)) + ')';
end;

procedure TORTreeNode.SetCaption(const Value: string);
var
  TheCaption: string;
begin
  TheCaption := Value;
  with GetORTreeView do
  begin
    if assigned(OnNodeCaptioning) then
      OnNodeCaptioning(self, TheCaption);
    if ShortNodeCaptions and (Self.GetPrevSibling <> nil) then
      TheCaption := CalcShortName(TheCaption, Self.GetPrevSibling.Text);
  end;
  FCaption := TheCaption;
end;

{ TORTreeView }

procedure TORTreeView.CNNotify(var Message: TWMNotify);
var
  DNode: TTreeNode;
  DoInh: boolean;

begin
  DoInh := TRUE;
  if (assigned(FOnDragging)) then
  begin
    with Message do
    begin
      case NMHdr^.code of
        TVN_BEGINDRAG:
          begin
            with PNMTreeView(Message.NMHdr)^.ItemNew do
            begin
              if (state and TVIF_PARAM) <> 0 then DNode := Pointer(lParam)
              else DNode := Items.GetNode(hItem);
            end;
            FOnDragging(Self, DNode, DoInh);
            if (not DoInh) then
            begin
              Message.Result := 1;
              Selected := DNode;
            end;
          end;
      end;
    end;
  end;
  if (DoInh) then inherited;
end;

constructor TORTreeView.Create(AOwner: TComponent);
begin
  inherited;
  FDelim := '^';
end;

destructor TORTreeView.Destroy;
begin
  FreeAndNil(FRecreateStream);
  inherited;
end;

procedure TORTreeView.CreateWnd;
var
  node: TTreeNode;
  savedCount, nodeIndex: integer;
begin
  EventCache.SaveAndNilEvents(ORTreeViewRecreateWndEvents);
  try
    inherited;
    if FRecreateStream <> nil then
    begin
      Items.BeginUpdate;
      try
        try
          FRecreateStream.ReadBuffer(savedCount, SizeOf(savedCount));
          if (savedCount = Items.Count) then
          begin
            nodeIndex := 0;
            node := Items.GetFirstNode;
            while (nodeIndex < savedCount) and (node <> nil) do
            begin
              TORTreeNode(node).ReadORNodeData(FRecreateStream);
              Inc(nodeIndex);
              node := node.GetNext;
            end;
          end;
        finally
          FreeAndNil(FRecreateStream);
        end;
      finally
        Items.EndUpdate;
      end;
    end;
  finally
    EventCache.RestoreEvents;
  end;
end;

procedure TORTreeView.DestroyWnd;
var
  node: TTreeNode;
  savedCount: integer;
begin
  EventCache.SaveAndNilEvents(ORTreeViewRecreateWndEvents);
  try
    if CreateWndRestores and (Items.Count > 0) and (csRecreating in ControlState) then
    begin
      FRecreateStream := TMemoryStream.Create;
      try
        savedCount := Items.Count;
        FRecreateStream.WriteBuffer(savedCount, SizeOf(savedCount));
        node := Items.GetFirstNode;
        while node <> nil do
        begin
          TORTreeNode(node).WriteORNodeData(FRecreateStream);
          node := node.GetNext;
        end;
        FRecreateStream.Position := 0;
      except
        FreeAndNil(FRecreateStream);
        raise;
      end;
    end;
    inherited;
  finally
    EventCache.RestoreEvents;
  end;
end;

function TORTreeView.CreateNode: TTreeNode;
begin
  Result := TORTreeNode.Create(Items);
  if Assigned(OnAddition) then
    OnAddition(self, Result);
end;

function TORTreeView.FindPieceNode(Value: string;
  ParentDelim: Char = #0; StartNode: TTreeNode = nil): TORTreeNode;
begin
  Result := FindPieceNode(Value, FPiece, ParentDelim, StartNode);
end;

function TORTreeView.FindPieceNode(Value: string; APiece: integer;
  ParentDelim: Char = #0; StartNode: TTreeNode = nil): TORTreeNode;
var
  StartIdx, i: integer;
  Node: TORTreeNode;

begin
  if assigned(StartNode) then
    StartIdx := StartNode.AbsoluteIndex + 1
  else
    StartIdx := 0;
  Result := nil;
  for i := StartIdx to Items.Count - 1 do
  begin
    Node := (Items[i] as TORTreeNode);
    if (GetNodeID(Node, APiece, ParentDelim) = Value) then
    begin
      Result := Node;
      break;
    end;
  end;
end;

function TORTreeView.GetExpandedIDStr(APiece: integer; ParentDelim: char = #0): string;
var
  i: integer;

begin
  Result := '';
  for i := 0 to Items.Count - 1 do
  begin
    with (Items[i] as TORTreeNode) do
    begin
      if (Expanded) then
      begin
        if (Result <> '') then
          Result := Result + FDelim;
        Result := Result + GetNodeID(TORTreeNode(Items[i]), APiece, ParentDelim);
      end;
    end;
  end;
end;

procedure TORTreeView.SetExpandedIDStr(APiece: integer; const Value: string);
begin
  SetExpandedIDStr(APiece, #0, Value);
end;

procedure TORTreeView.SetExpandedIDStr(APiece: integer; ParentDelim: char;
  const Value: string);
var
  i: integer;
  Top, Sel: TTreeNode;
  Node: TORTreeNode;
  NList: string;
  Srch: string;

begin
  Items.BeginUpdate;
  try
    Top := TopItem;
    Sel := Selected;
    FullCollapse;
    Selected := Sel;
    NList := Value;
    repeat
      i := pos(FDelim, NList);
      if (i = 0) then i := length(NList) + 1;
      Srch := copy(NList, 1, i - 1);
      Node := FindPieceNode(Srch, APiece, ParentDelim);
      if (assigned(Node)) then
        Node.Expand(FALSE);
      Nlist := copy(NList, i + 1, MaxInt);
    until (NList = '');
    TopItem := Top;
    Selected := Sel;
  finally
    Items.EndUpdate;
  end;
end;

function TORTreeView.GetHorzScrollPos: integer;
begin
  Result := GetScrollPos(Handle, SB_HORZ);
end;

function TORTreeView.GetVertScrollPos: integer;
begin
  Result := GetScrollPos(Handle, SB_VERT);
end;

procedure TORTreeView.RenameNodes;
var
  i: integer;

begin
  if (FDelim <> #0) and (FPiece > 0) then
  begin
    for i := 0 to Items.Count - 1 do
      with (Items[i] as TORTreeNode) do
        UpdateText(Piece(FStringData, FDelim, FPiece), FALSE);
  end;
end;

procedure TORTreeView.SetNodeDelim(const Value: Char);
begin
  if (FDelim <> Value) then
  begin
    FDelim := Value;
    RenameNodes;
  end;
end;

procedure TORTreeView.SetHorzScrollPos(Value: integer);
begin
  if (Value < 0) then Value := 0;
  Perform(WM_HSCROLL, MakeWParam(SB_THUMBPOSITION, Value), 0);
end;

procedure TORTreeView.SetNodePiece(const Value: integer);
begin
  if (FPiece <> Value) then
  begin
    FPiece := Value;
    RenameNodes;
  end;
end;

procedure TORTreeView.SetVertScrollPos(Value: integer);
begin
  if (Value < 0) then Value := 0;
  Perform(WM_VSCROLL, MakeWParam(SB_THUMBPOSITION, Value), 0);
end;

function TORTreeView.GetNodeID(Node: TORTreeNode;
  ParentDelim: Char): string;
begin
  Result := GetNodeID(Node, FPiece, ParentDelim);
end;

function TORTreeView.GetNodeID(Node: TORTreeNode; APiece: integer;
  ParentDelim: Char): string;
begin
  if (assigned(Node)) then
  begin
    Result := Piece(Node.FStringData, FDelim, APiece);
    if ((ParentDelim <> #0) and (ParentDelim <> FDelim) and (assigned(Node.Parent))) then
      Result := Result + ParentDelim + GetNodeID(Node.Parent, APiece, ParentDelim);
  end
  else
    Result := '';
end;

procedure TORTreeView.SetShortNodeCaptions(const Value: boolean);
begin
  FShortNodeCaptions := Value;
  RenameNodes;
end;

{ TORCBImageIndexes }

constructor TORCBImageIndexes.Create(AOwner: TComponent);
begin
  inherited;
  FCheckedEnabledIndex := -1;
  FCheckedDisabledIndex := -1;
  FGrayedEnabledIndex := -1;
  FGrayedDisabledIndex := -1;
  FUncheckedEnabledIndex := -1;
  FUncheckedDisabledIndex := -1;
  FImageChangeLink := TChangeLink.Create;
  FImageChangeLink.OnChange := ImageListChanged;
end;

destructor TORCBImageIndexes.Destroy;
begin
  FImageChangeLink.Free;
  inherited;
end;

procedure TORCBImageIndexes.SetImages(const Value: TCustomImageList);
begin
  if FImages <> nil then FImages.UnRegisterChanges(FImageChangeLink);
  FImages := Value;
  if FImages <> nil then
  begin
    FImages.RegisterChanges(FImageChangeLink);
    FImages.FreeNotification(Self);
  end;
  ImageListChanged(Self);
end;

function TORCBImageIndexes.IdxString: string;
  function RStr(Value: integer): string;
  begin
    if (Value <> -1) then
      Result := IntToStr(Value)
    else
      Result := '';
    Result := Result + ',';
  end;

begin
  Result := RStr(FCheckedEnabledIndex) +
    RStr(FGrayedEnabledIndex) +
    RStr(FUncheckedEnabledIndex) +
    RStr(FCheckedDisabledIndex) +
    RStr(FGrayedDisabledIndex) +
    RStr(FUncheckedDisabledIndex);
  delete(Result, length(Result), 1);
  if (Result = ',,,,,') then Result := '';
end;

procedure TORCBImageIndexes.SetIdxString(Value: string);
var
  i, j, v: integer;
  Sub: string;

begin
  if (Value = '') then
  begin
    FCheckedEnabledIndex := -1;
    FGrayedEnabledIndex := -1;
    FUncheckedEnabledIndex := -1;
    FCheckedDisabledIndex := -1;
    FGrayedDisabledIndex := -1;
    FUncheckedDisabledIndex := -1;
  end
  else
  begin
    i := 0;
    Sub := Value;
    repeat
      j := pos(',', Sub);
      if (j = 0) then j := length(Sub) + 1;
      v := StrToIntDef(copy(Sub, 1, j - 1), -1);
      case i of
        0: FCheckedEnabledIndex := v;
        1: FGrayedEnabledIndex := v;
        2: FUncheckedEnabledIndex := v;
        3: FCheckedDisabledIndex := v;
        4: FGrayedDisabledIndex := v;
        5: FUncheckedDisabledIndex := v;
      end;
      inc(i);
      Sub := copy(Sub, j + 1, MaxInt);
    until (Sub = '');
  end;
end;

procedure TORCBImageIndexes.ImageListChanged(Sender: TObject);
begin
  if (Owner is TWinControl) then
    (Owner as TWinControl).Invalidate;
end;

procedure TORCBImageIndexes.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (AComponent = FImages) and (Operation = opRemove) then SetImages(nil);
end;

procedure TORCBImageIndexes.SetCheckedDisabledIndex(const Value: integer);
begin
  if (FCheckedDisabledIndex <> Value) then
  begin
    FCheckedDisabledIndex := Value;
    ImageListChanged(Self);
  end;
end;

procedure TORCBImageIndexes.SetCheckedEnabledIndex(const Value: integer);
begin
  if (FCheckedEnabledIndex <> Value) then
  begin
    FCheckedEnabledIndex := Value;
    ImageListChanged(Self);
  end;
end;

procedure TORCBImageIndexes.SetGrayedDisabledIndex(const Value: integer);
begin
  if (FGrayedDisabledIndex <> Value) then
  begin
    FGrayedDisabledIndex := Value;
    ImageListChanged(Self);
  end;
end;

procedure TORCBImageIndexes.SetGrayedEnabledIndex(const Value: integer);
begin
  if (FGrayedEnabledIndex <> Value) then
  begin
    FGrayedEnabledIndex := Value;
    ImageListChanged(Self);
  end;
end;

procedure TORCBImageIndexes.SetUncheckedDisabledIndex(const Value: integer);
begin
  if (FUncheckedDisabledIndex <> Value) then
  begin
    FUncheckedDisabledIndex := Value;
    ImageListChanged(Self);
  end;
end;

procedure TORCBImageIndexes.SetUncheckedEnabledIndex(const Value: integer);
begin
  if (FUncheckedEnabledIndex <> Value) then
  begin
    FUncheckedEnabledIndex := Value;
    ImageListChanged(Self);
  end;
end;

{ TORCheckBox }

constructor TORCheckBox.Create(AOwner: TComponent);
begin
  CreateCommon(AOwner);
  FCustomImages := TORCBImageIndexes.Create(Self);
  FCustomImagesOwned := TRUE;
  FAllowAllUnchecked := TRUE;
end;

constructor TORCheckBox.ListViewCreate(AOwner: TComponent; ACustomImages: TORCBImageIndexes);
begin
  CreateCommon(AOwner);
  FCustomImages := ACustomImages;
  FCustomImagesOwned := FALSE;
end;

procedure TORCheckBox.CreateCommon(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FGrayedToChecked := TRUE;
  FCanvas := TCanvas.Create;
end;

destructor TORCheckBox.Destroy;
begin
  if (FCustomImagesOwned) then FCustomImages.Free;
  FCanvas.Free;
  inherited;
end;


function TORCheckBox.GetImageIndexes: string;
begin
  Result := FCustomImages.IdxString;
end;

function TORCheckBox.GetImageList: TCustomImageList;
begin
  Result := FCustomImages.FImages;
end;

procedure TORCheckBox.SetImageIndexes(const Value: string);
begin
  FCustomImages.SetIdxString(Value);
end;

procedure TORCheckBox.SetImageList(const Value: TCustomImageList);
begin
  FCustomImages.SetImages(Value);
end;

procedure TORCheckBox.Toggle;
begin
  if (FGrayedToChecked) then
  begin
    case State of
      cbUnchecked:
        if AllowGrayed then State := cbGrayed else State := cbChecked;
      cbChecked: State := cbUnchecked;
      cbGrayed: State := cbChecked;
    end;
  end
  else
  begin
    case State of
      cbUnchecked: State := cbChecked;
      cbChecked: if AllowGrayed then State := cbGrayed else State := cbUnchecked;
      cbGrayed: State := cbUnchecked;
    end;
  end;
end;

procedure TORCheckBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := (Params.Style and (not BS_3STATE)) or BS_OWNERDRAW;
end;

procedure TORCheckBox.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TORCheckBox.CMFontChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TORCheckBox.CNDrawItem(var Message: TWMDrawItem);
begin
  DrawItem(Message.DrawItemStruct^);
end;

procedure TORCheckBox.CNMeasureItem(var Message: TWMMeasureItem);
begin
  with Message.MeasureItemStruct^ do
  begin
    itemWidth := Width;
    itemHeight := Height;
  end;
end;

procedure TORCheckBox.GetDrawData(CanvasHandle: HDC; var Bitmap: TBitmap;
  var FocRect, Rect: TRect;
  var DrawOptions: UINT;
  var TempBitMap: boolean);
var
  i, l, TxtHeight, TxtWidth, AWidth: Integer;
  ImgIdx: TORCBImgIdx;
  CustomImgIdx: integer;

begin
  BitMap := nil;
  TempBitMap := FALSE;
  DrawOptions := DT_LEFT;
  FSingleLine := TRUE;

  if (not (csDestroying in ComponentState)) then
  begin
    with FCustomImages do
    begin
      FCanvas.Handle := CanvasHandle;
      try
        Rect := ClientRect;
        with FCanvas do
        begin
          CustomImgIdx := -1;
          if (assigned(FImages)) then
          begin
            if (Enabled or (csDesigning in ComponentState)) then
            begin
              case State of
                cbChecked: CustomImgIdx := FCheckedEnabledIndex;
                cbUnChecked: CustomImgIdx := FUncheckedEnabledIndex;
                cbGrayed: CustomImgIdx := FGrayedEnabledIndex;
              end;
            end
            else
            begin
              case State of
                cbChecked: CustomImgIdx := FCheckedDisabledIndex;
                cbUnChecked: CustomImgIdx := FUncheckedDisabledIndex;
                cbGrayed: CustomImgIdx := FGrayedDisabledIndex;
              end;
            end;
            if ((CustomImgIdx < 0) or (CustomImgIdx >= FImages.Count)) then
              CustomImgIdx := -1;
          end;
          if (CustomImgIdx < 0) then
          begin
            ImgIdx := iiChecked;
            if (Enabled or (csDesigning in ComponentState)) then
            begin
              if (FRadioStyle) then
              begin
                if State = cbChecked then
                  ImgIdx := iiRadioChecked
                else
                  ImgIdx := iiRadioUnchecked;
              end
              else
              begin
                case State of
                  cbChecked: ImgIdx := iiChecked;
                  cbUnChecked: ImgIdx := iiUnchecked;
                  cbGrayed:
                    begin
                      case FGrayedStyle of
                        gsNormal: ImgIdx := iiGrayed;
                        gsQuestionMark: ImgIdx := iiQMark;
                        gsBlueQuestionMark: ImgIdx := iiBlueQMark;
                      end;
                    end;
                end;
              end;
            end
            else
            begin
              if (FRadioStyle) then
              begin
                if State = cbChecked then
                  ImgIdx := iiRadioDisChecked
                else
                  ImgIdx := iiRadioDisUnchecked;
              end
              else
              begin
                case State of
                  cbChecked: ImgIdx := iiDisChecked;
                  cbUnChecked: ImgIdx := iiDisUnchecked;
                  cbGrayed:
                    begin
                      if (FGrayedStyle = gsNormal) then
                        ImgIdx := iiDisGrayed
                      else
                        ImgIdx := iiDisQMark;
                    end;
                end;
              end;
            end;
            Bitmap := GetORCBBitmap(ImgIdx, FBlackColorMode);
          end
          else
          begin
            Bitmap := TBitmap.Create;
            FImages.GetBitmap(CustomImgIdx, Bitmap);
            TempBitMap := TRUE;
          end;
          Brush.Style := bsClear;
          Font := Self.Font;

          if Alignment = taLeftJustify then
            Rect.Left := 2
          else
            Rect.Left := Bitmap.Width + 5;

          if (FWordWrap) then
            DrawOptions := DrawOptions or DT_WORDBREAK
          else
            DrawOptions := DrawOptions or DT_VCENTER or DT_SINGLELINE;

          if (FWordWrap) then
          begin
            if Alignment = taLeftJustify then
              Rect.Right := Width - Bitmap.Width - 3
            else
              Rect.Right := Width;
            Rect.Top := 1;
            Rect.Bottom := Height + 1;
            dec(Rect.Right);
            FocRect := Rect;
            TxtHeight := DrawText(Handle, PChar(Caption), Length(Caption), FocRect,
              DrawOptions or DT_CALCRECT);
            if (TxtHeight = 1) then TxtHeight := TextHeight(Caption);
            FSingleLine := (TxtHeight = TextHeight(Caption));
            Rect.Bottom := Rect.Top + TxtHeight + 1;
            FocRect := Rect;
          end
          else
          begin
            TxtWidth := TextWidth(Caption);
            //Get rid of ampersands that turn into underlines
            i := 0;
            l := length(Caption);
            AWidth := TextWidth('&');
            while (i < l) do
            begin
              inc(i);
              // '&&' is an escape char that should display one '&' wide.
              // This next part preserves the first '&' but drops all the others
              if (Copy(Caption, i, 2) <> '&&') and (Copy(Caption, i, 1) = '&') then
                dec(TxtWidth, AWidth);
            end;
            Rect.Right := Rect.Left + TxtWidth;
            TxtHeight := TextHeight(Caption);
            if (TxtHeight < Bitmap.Height) then
              TxtHeight := Bitmap.Height;
            Rect.Top := ((((ClientHeight - TxtHeight) * 5) - 5) div 10);
            Rect.Bottom := Rect.Top + TxtHeight + 1;
            IntersectRect(FocRect, Rect, ClientRect);
          end;
        end;
      finally
        FCanvas.Handle := 0;
      end;
    end;
  end;
end;

procedure TORCheckBox.DrawItem(const DrawItemStruct: TDrawItemStruct);
var
  R, FocusRect, TempRect: TRect;
  Bitmap: TBitmap;
  OldColor: TColor;
  DrawOptions: UINT;
  TempBitMap: boolean;
  WorkStr: string;

begin
  if (not (csDestroying in ComponentState)) then
  begin
    GetDrawData(DrawItemStruct.hDC, Bitmap, FocusRect, R, DrawOptions, TempBitMap);
    try
      FCanvas.Handle := DrawItemStruct.hDC;
      try
        FCanvas.Brush.Color := Self.Color;
        FCanvas.Brush.Style := bsSolid;
(*        InflateRect(R, 1, 1);
        FCanvas.FillRect(R);
        InflateRect(R, -1, -1); *)
        fCanvas.FillRect(ClientRect);

        Brush.Style := bsClear;
        FCanvas.Font := Self.Font;

        if (Enabled or (csDesigning in ComponentState)) then
        begin
          WorkStr := Caption;
//          FCanvas.TextRect(FocusRect, WorkStr);
          DrawText(FCanvas.Handle, PWideChar(Caption), Length(Caption), FocusRect, DrawOptions);
        end else begin
          OldColor := Font.Color;
          try
            if Ctl3D then begin
              OffsetRect(FocusRect, 1, 1);
              FCanvas.Font.Color := clBtnHighlight;
              DrawText(FCanvas.Handle, PWideChar(Caption), Length(Caption), FocusRect, DrawOptions);
              OffsetRect(FocusRect, -1, -1);
            end;
            FCanvas.Font.Color := clGrayText;
            DrawText(FCanvas.Handle, PWideChar(Caption), Length(Caption), FocusRect, DrawOptions);
          finally
            FCanvas.Font.Color := OldColor;
          end;

          FCanvas.Brush.Color := Self.Color;
          FCanvas.Brush.Style := bsSolid;
        end;

        if ((DrawItemStruct.itemState and ODS_FOCUS) <> 0) then begin
          InflateRect(FocusRect, 1, 1);
          if (FFocusOnBox) then
            //TempRect := Rect(0, 0, CheckWidth - 1, CheckWidth - 1)
            TempRect := Rect(0, 0, CheckWidth + 2, CheckWidth + 5)
          else
            TempRect := FocusRect;
          //UnionRect(Temp2Rect,ClipRect,TempRect);
          //ClipRect := Temp2Rect;
          FCanvas.Pen.Color := clWindowFrame;
          FCanvas.Brush.Color := clBtnFace;
          FCanvas.DrawFocusRect(TempRect);
          InflateRect(FocusRect, -1, -1);
        end;

        if Alignment = taLeftJustify then
          R.Left := ClientWidth - Bitmap.Width
        else
          R.Left := 0;
        if (FWordWrap) then
          R.Top := FocusRect.Top
        else begin
          R.Top := ((ClientHeight - Bitmap.Height + 1) div 2) - 1;
          if R.Top < 0 then R.Top := 0
        end;
        FCanvas.Draw(R.Left, R.Top, Bitmap);
      finally
        FCanvas.Handle := 0;
      end;
    finally
      if (TempBitMap) then
        Bitmap.Free;
    end;
  end;
end;

procedure TORCheckBox.SetGrayedStyle(Value: TGrayedStyle);
begin
  if (FGrayedStyle <> Value) then
  begin
    FGrayedStyle := Value;
    if (State = cbGrayed) then Invalidate;
  end;
end;

procedure TORCheckBox.WMLButtonDblClk(var Message: TWMLButtonDblClk);
begin
  Perform(WM_LBUTTONDOWN, Message.Keys, Longint(Message.Pos));
end;

procedure TORCheckBox.WMSize(var Message: TWMSize);
begin
  inherited;
  if (FSizable) and (csDesigning in ComponentState) then
    AutoAdjustSize;
end;

procedure TORCheckBox.BMSETCHECK(var Message: TMessage);
var
  cnt, i: integer;
  cb: TORCheckBox;
  Chk: boolean;

begin
  Message.Result := 0;

  if (assigned(Parent) and (FGroupIndex <> 0)) then
  begin
    Chk := Checked;
    if (Chk or (not FAllowAllUnchecked)) then
    begin
      cnt := 0;
      for i := 0 to Parent.ControlCount - 1 do
      begin
        if (Parent.Controls[i] is TORCheckBox) then
        begin
          cb := TORCheckBox(Parent.Controls[i]);
          if (cb <> Self) then
          begin
            if (cb.Checked and (cb.FGroupIndex = FGroupIndex)) then
            begin
              if Chk then
                cb.Checked := FALSE
              else
                inc(cnt);
            end;
          end;
        end;
      end;
      if (not Chk) and (Cnt = 0) then
        Checked := TRUE;
    end;
  end;
  UpdateAssociate;
  Invalidate;
end;

procedure TORCheckBox.SetWordWrap(const Value: boolean);
begin
  if (FWordWrap <> Value) then
  begin
    FWordWrap := Value;
    AutoAdjustSize;
    invalidate;
  end;
end;

procedure TORCheckBox.SetAutoSize(Value: boolean);
begin
  if (FAutoSize <> Value) then
  begin
    FAutoSize := Value;
    AutoAdjustSize;
    invalidate;
  end;
end;

procedure TORCheckBox.SetBlackColorMode(Value: boolean);
begin
  if FBlackColorMode <> Value then
  begin
    FBlackColorMode := Value;
    Invalidate;
  end;
end;

procedure TORCheckBox.AutoAdjustSize;
var
  R, FocusRect: TRect;
  Bitmap: TBitmap;
  DrawOptions: UINT;
  TempBitMap: boolean;
  DC: HDC;
  SaveFont: HFont;

begin
  if (FAutoSize and (([csDestroying, csLoading] * ComponentState) = [])) then
  begin
    FSizable := TRUE;
    DC := GetDC(0);
    try
      SaveFont := SelectObject(DC, Font.Handle);
      try
        GetDrawData(DC, Bitmap, FocusRect, R, DrawOptions, TempBitMap);
      finally
        SelectObject(DC, SaveFont);
      end;
    finally
      ReleaseDC(0, DC);
    end;
    if (FocusRect.Left <> R.Left) or
      (FocusRect.Right <> R.Right) or
      (FocusRect.Top <> R.Top) or
      (FocusRect.Bottom <> R.Bottom) or
      (R.Right <> ClientRect.Right) or
      (R.Bottom <> ClientRect.Bottom) then
    begin
      FocusRect := R;
      if Alignment = taLeftJustify then
      begin
        dec(R.Left, 2);
        inc(R.Right, Bitmap.Width + 3);
      end
      else
        dec(R.Left, Bitmap.Width + 5);
      Width := R.Right - R.Left + 1;
      Height := R.Bottom - R.Top + 2;
    end;
  end;
end;

function TORCheckBox.GetCaption: TCaption;
begin
  Result := inherited Caption;
end;

procedure TORCheckBox.SetCaption(const Value: TCaption);
begin
  if (inherited Caption <> Value) then
  begin
    inherited Caption := Value;
    AutoAdjustSize;
    invalidate;
  end;
end;

procedure TORCheckBox.SetAllowAllUnchecked(const Value: boolean);
begin
  FAllowAllUnchecked := Value;
  SyncAllowAllUnchecked;
end;

procedure TORCheckBox.SetGroupIndex(const Value: integer);
begin
  FGroupIndex := Value;
  if (Value <> 0) and (csDesigning in ComponentState) and (not (csLoading in ComponentState)) then
    SetRadioStyle(TRUE);
  SyncAllowAllUnchecked;
end;

procedure TORCheckBox.SyncAllowAllUnchecked;
var
  i: integer;
  cb: TORCheckBox;

begin
  if (assigned(Parent) and (FGroupIndex <> 0)) then
  begin
    for i := 0 to Parent.ControlCount - 1 do
    begin
      if (Parent.Controls[i] is TORCheckBox) then
      begin
        cb := TORCheckBox(Parent.Controls[i]);
        if ((cb <> Self) and (cb.FGroupIndex = FGroupIndex)) then
          cb.FAllowAllUnchecked := FAllowAllUnchecked;
      end;
    end;
  end;
end;

procedure TORCheckBox.SetParent(AParent: TWinControl);
begin
  inherited;
  SyncAllowAllUnchecked;
end;

procedure TORCheckBox.SetRadioStyle(const Value: boolean);
begin
  FRadioStyle := Value;
  Invalidate;
end;

procedure TORCheckBox.SetAssociate(const Value: TControl);
begin
  if (FAssociate <> Value) then
  begin
    if (assigned(FAssociate)) then
      FAssociate.RemoveFreeNotification(Self);
    FAssociate := Value;
    if (assigned(FAssociate)) then
    begin
      FAssociate.FreeNotification(Self);
      UpdateAssociate;
    end;
  end;
end;

procedure TORCheckBox.UpdateAssociate;

  procedure EnableCtrl(Ctrl: TControl; DoCtrl: boolean);
  var
    i: integer;
    DoIt: boolean;

  begin
    if DoCtrl then
    begin
      try
        Ctrl.Enabled := Checked;
      except
      end;
    end;

    // added (csAcceptsControls in Ctrl.ControlStyle) below to prevent disabling of
    // child sub controls, like the TBitBtn in the TORComboBox.  If the combo box is
    // already disabled, we don't want to disable the button as well - when we do, we
    // lose the disabled glyph that is stored on that button for the combo box.

    if (Ctrl is TWinControl) and (csAcceptsControls in Ctrl.ControlStyle) then
    begin
      for i := 0 to TWinControl(Ctrl).ControlCount - 1 do
      begin
        if DoCtrl then
          DoIt := TRUE
        else
          DoIt := (TWinControl(Ctrl).Controls[i] is TWinControl);
        if DoIt then
          EnableCtrl(TWinControl(Ctrl).Controls[i], TRUE);
      end;
    end;
  end;

begin
  if (assigned(FAssociate)) then
    EnableCtrl(FAssociate, FALSE);
end;

procedure TORCheckBox.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (AComponent = FAssociate) and (Operation = opRemove) then
    FAssociate := nil;
end;

procedure TORCheckBox.SetFocusOnBox(value: boolean);
begin
  FFocusOnBox := value;
  invalidate;
end;

procedure TORCheckBox.BMGetCheck(var Message: TMessage);
begin
  {This Allows JAWS to report the state when tabbed into or using the read object
  keys (Ins+Tab)}
  {if Self.GrayedStyle = gsBlueQuestionMark then
    Message.Result := BST_INDETERMINATE
  else}
  if Self.Checked then
    Message.Result := BST_CHECKED
  else
    Message.Result := BST_UNCHECKED;
end;

procedure TORCheckBox.BMGetState(var Message: TMessage);
begin
  //This gives JAWS ability to read state when spacebar is pressed.
  //Commented out because JAWS reads states, but inversly. Working with freedom...
{  if Self.Checked then
    Message.Result := BST_CHECKED
  else
    Message.Result := BST_UNCHECKED;}
end;

{ TORListView }

procedure TORListView.WMNotify(var Message: TWMNotify);
begin
  inherited;
  with Message.NMHdr^ do
    case code of
      HDN_BEGINTRACK, HDN_TRACK, HDN_ENDTRACK:
        with PHDNotify(Pointer(Message.NMHdr))^, PItem^ do
          if (Mask and HDI_WIDTH) <> 0 then
          begin
            if (Column[Item].MinWidth > 0) and (cxy < Column[Item].MinWidth) then
              cxy := Column[Item].MinWidth;
            if (Column[Item].MaxWidth > 0) and (cxy > Column[Item].MaxWidth) then
              cxy := Column[Item].MaxWidth;
            Column[Item].Width := cxy;
          end;
    end;
end;

procedure TORListView.LVMSetColumn(var Message: TMessage);
var
  Changed: boolean;
  NewW, idx: integer;

begin
  Changed := FALSE;
  NewW := 0;
  idx := 0;
  with Message, TLVColumn(pointer(LParam)^) do
  begin
    if (cx < Column[WParam].MinWidth) then
    begin
      NewW := Column[WParam].MinWidth;
      Changed := TRUE;
      idx := WParam;
    end;
    if (cx > Column[WParam].MaxWidth) then
    begin
      NewW := Column[WParam].MaxWidth;
      Changed := TRUE;
      idx := WParam;
    end;
  end;
  inherited;
  if (Changed) then
    Column[idx].Width := NewW;
end;

procedure TORListView.LVMSetColumnWidth(var Message: TMessage);
var
  Changed: boolean;
  NewW, idx: integer;

begin
  Changed := FALSE;
  NewW := 0;
  idx := 0;
  with Message do
  begin
    if (LParam < Column[WParam].MinWidth) then
    begin
      LParam := Column[WParam].MinWidth;
      Changed := TRUE;
      NewW := LParam;
      idx := WParam;
    end;
    if (LParam > Column[WParam].MaxWidth) then
    begin
      LParam := Column[WParam].MaxWidth;
      Changed := TRUE;
      NewW := LParam;
      idx := WParam;
    end;
  end;
  inherited;
  if (Changed) then
    Column[idx].Width := NewW;
end;

{ TORComboPanelEdit }

destructor TORComboPanelEdit.Destroy;
begin
  if (assigned(FCanvas)) then
    FCanvas.Free;
  inherited;
end;

procedure TORComboPanelEdit.Paint;
var
  DC: HDC;
  R: TRect;

begin
  inherited;
  if (FFocused) then
  begin
    if (not assigned(FCanvas)) then
      FCanvas := TControlCanvas.Create;
    DC := GetWindowDC(Handle);
    try
      FCanvas.Handle := DC;
      R := ClientRect;
      InflateRect(R, -1, -1);
      FCanvas.DrawFocusRect(R);
    finally
      ReleaseDC(Handle, DC);
    end;
  end;
end;

{ TKeyClickPanel ----------------------------------------------------------------------------- }


procedure TKeyClickPanel.CMFocusChanged(var Message: TCMFocusChanged);
begin
  Invalidate;
end;

procedure TKeyClickPanel.KeyDown(var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_LBUTTON, VK_RETURN, VK_SPACE:
      Click;
  end;
end;

procedure TKeyClickPanel.Paint;
var
  Rect: TRect;
  DC: HDC;
begin
  inherited;
  if Focused then
  begin
    Rect := ClientRect;
    // Account for bevel
    AdjustClientRect(Rect);

    // Draw blue border
    Frame3D(Canvas, Rect, clHighlight, clHighlight, 2);

    // Draw focus border
    if (not assigned(FCanvas)) then
      FCanvas := TControlCanvas.Create;

    DC := GetDC(Handle);
    try
      FCanvas.Handle := DC;
      FCanvas.DrawFocusRect(Rect);
    finally
      ReleaseDC(Handle, DC);
    end;

  end;
  if assigned(FOnPaint) then
    FOnPaint(Self);
end;

destructor TKeyClickPanel.Destroy;
begin
  FreeAndNil(FCanvas);
  Inherited;
end;
{ TKeyClickRadioGroup }

procedure TKeyClickRadioGroup.Click;
begin
  inherited;
  TabStop := Enabled and Visible and (ItemIndex = -1);
end;

constructor TKeyClickRadioGroup.Create(AOwner: TComponent);
begin
  inherited;
  TabStop := Enabled and Visible and (ItemIndex = -1);
end;

procedure TKeyClickRadioGroup.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  case Key of
    VK_RETURN, VK_SPACE:
      if ItemIndex = -1 then begin
        ItemIndex := 0;
        Click;
        if (ControlCount > 0) and ShouldFocus(TWinControl(Controls[0])) then
          TWinControl(Controls[0]).SetFocus;
        Key := 0;
      end;
  end;
end;

{ TCaptionListBox }

Constructor TCaptionListBox.Create(AOwner: TComponent);
begin
 Inherited Create(AOwner);
 FItemIndex := -1;
end;

procedure TCaptionListBox.DoEnter;
begin
  inherited;
  if HintOnItem then
    FHoverItemPos := -1; //CQ: 7178 & 9911 - used as last item index for ListBox
end;

function TCaptionListBox.GetCaption: string;
begin
  if not Assigned(FCaptionComponent) then
    result := ''
  else
    result := FCaptionComponent.Caption;
end;

function TCaptionListBox.GetDynamicProperty(PropertyID: integer): string;
begin
  if PropertyID = DynaPropAccesibilityCaption then
    Result := GetCaption
  else
    Result := '';
end;


procedure TCaptionListBox.MoveFocusUp;
begin
  if ItemIndex > 0 then
    Perform(LB_SETCARETINDEX, ItemIndex - 1, 0);
end;

procedure TCaptionListBox.MoveFocusDown;
begin
  if ItemIndex < (Items.Count - 1) then
    Perform(LB_SETCARETINDEX, ItemIndex + 1, 0);
end;

procedure TCaptionListBox.SetCaption(const Value: string);
begin
  if not Assigned(FCaptionComponent) then begin
    FCaptionComponent := TStaticText.Create(self);
    FCaptionComponent.AutoSize := False;
    FCaptionComponent.Height := 0;
    FCaptionComponent.Width := 0;
    FCaptionComponent.Visible := True;
    FCaptionComponent.Parent := Parent;
    FCaptionComponent.BringToFront;
  end;
  FCaptionComponent.Caption := Value;
end;

function TCaptionListBox.SupportsDynamicProperty(PropertyID: integer): boolean;
begin
  Result := (PropertyID = DynaPropAccesibilityCaption);
end;

procedure TCaptionListBox.WMKeyDown(var Message: TWMKeyDown);
var
  IsSelected: LongBool;
begin
  if Boolean(Hi(GetKeyState(VK_CONTROL))) and MultiSelect then
    case Message.CharCode of
      VK_SPACE:
        begin
          IsSelected := LongBool(Perform(LB_GETSEL, ItemIndex, 0));
          Perform(LB_SETSEL, Longint(not IsSelected), ItemIndex);
        end;
      VK_LEFT, VK_UP: MoveFocusUp;
      VK_RIGHT, VK_DOWN: MoveFocusDown;
    else inherited;
    end
  else inherited;
end;

procedure TCaptionListBox.WMMouseMove(var Message: TWMMouseMove);
var
  i: integer;
begin
  inherited;
  //CQ: 7178 & 9911 - FHoverItemPos should be set to -1 in OnEnter
  //Make the TListBox's hint contain the contents of the listbox Item the mouse is currently over
  if HintOnItem then
  begin
    i := ItemAtPos(Point(Message.XPos, Message.YPos), true);
    if i <> FHoverItemPos then
      Application.CancelHint;
    if i = -1 then
      Hint := ''
    else
      Hint := Items[i];
    FHoverItemPos := i;
  end;
end;

procedure TCaptionListBox.WMRButtonUp(var Message: TWMRButtonUp);
{ When the RightClickSelect property is true, this routine is used to select an item }
var
  APoint: TPoint;
  i: integer;
begin
  if FRightClickSelect then with Message do
    begin
      APoint := Point(XPos, YPos);
    // if the mouse was clicked in the client area set ItemIndex...
      if PtInRect(ClientRect, APoint) then
      begin
        ItemIndex := ItemAtPos(APoint, True);
      // ...but not if its just going to deselect the current item
        if ItemIndex > -1 then
        begin
          Items.BeginUpdate;
          try
            if not Selected[ItemIndex] then
              for i := 0 to Items.Count - 1 do
                Selected[i] := False;
            Selected[ItemIndex] := True;
          finally
            Items.EndUpdate;
          end;
        end;
      end;
    end;
  inherited;
end;

procedure TCaptionListBox.SetItemIndex(const Value: Integer);
begin
  inherited;
  if FItemIndex <> ItemIndex then
  begin
    FItemIndex := ItemIndex;
    Change;
  end;
end;

procedure TCaptionListBox.CNCommand(var AMessage: TWMCommand);
begin
  inherited;
  if (AMessage.NotifyCode = LBN_SELCHANGE) and (FItemIndex <> ItemIndex) then
  begin
    FItemIndex := ItemIndex;
    Change;
  end;
end;

procedure TCaptionListBox.Change;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TCaptionListBox.CMHintShow(var Message: TCMHintShow);
var
 aHintText: String;
 aCanShow: Boolean;
begin
  if Message.HintInfo.HintControl=Self then
  begin
    aCanShow := true;
    aHintText := Hint;
    if Assigned(FOnHintShow) then
      FOnHintShow(aHintText, aCanShow);
    if aCanShow then
    begin
        Message.HintInfo.HintStr := aHintText;
        Message.HintInfo.ReshowTimeOut := 500;
        Message.HintInfo.HideTimeOut := 2500;
    end;
  end;
end;

{ TCaptionCheckListBox }

function TCaptionCheckListBox.GetCaption: string;
begin
  if not Assigned(FCaptionComponent) then
    result := ''
  else
    result := FCaptionComponent.Caption;
end;

function TCaptionCheckListBox.GetDynamicProperty(PropertyID: integer): string;
begin
  if PropertyID = DynaPropAccesibilityCaption then
    Result := GetCaption
  else
    Result := '';
end;

procedure TCaptionCheckListBox.SetCaption(const Value: string);
begin
  if not Assigned(FCaptionComponent) then begin
    FCaptionComponent := TStaticText.Create(self);
    FCaptionComponent.AutoSize := False;
    FCaptionComponent.Height := 0;
    FCaptionComponent.Width := 0;
    FCaptionComponent.Visible := True;
    FCaptionComponent.Parent := Parent;
    FCaptionComponent.BringToFront;
  end;
  FCaptionComponent.Caption := Value;
end;

function TCaptionCheckListBox.SupportsDynamicProperty(
  PropertyID: integer): boolean;
begin
  Result := (PropertyID = DynaPropAccesibilityCaption);
end;

{ TCaptionMemo }

function TCaptionMemo.GetCaption: string;
begin
  if not Assigned(FCaptionComponent) then
    result := ''
  else
    result := FCaptionComponent.Caption;
end;

function TCaptionMemo.GetDynamicProperty(PropertyID: integer): string;
begin
  if PropertyID = DynaPropAccesibilityCaption then
    Result := GetCaption
  else
    Result := '';
end;

procedure TCaptionMemo.SetCaption(const Value: string);
begin
  if not Assigned(FCaptionComponent) then begin
    FCaptionComponent := TStaticText.Create(self);
    FCaptionComponent.AutoSize := False;
    FCaptionComponent.Height := 0;
    FCaptionComponent.Width := 0;
    FCaptionComponent.Visible := True;
    FCaptionComponent.Parent := Parent;
    FCaptionComponent.BringToFront;
  end;
  FCaptionComponent.Caption := Value;
end;

function TCaptionMemo.SupportsDynamicProperty(PropertyID: integer): boolean;
begin
  Result := (PropertyID = DynaPropAccesibilityCaption);
end;

{ TCaptionEdit }

function TCaptionEdit.GetCaption: string;
begin
  if not Assigned(FCaptionComponent) then
    result := ''
  else
    result := FCaptionComponent.Caption;
end;

function TCaptionEdit.GetDynamicProperty(PropertyID: integer): string;
begin
  if PropertyID = DynaPropAccesibilityCaption then
    Result := GetCaption
  else
    Result := '';
end;

procedure TCaptionEdit.SetCaption(const Value: string);
begin
  if not Assigned(FCaptionComponent) then begin
    FCaptionComponent := TStaticText.Create(self);
    FCaptionComponent.AutoSize := False;
    FCaptionComponent.Height := 0;
    FCaptionComponent.Width := 0;
    FCaptionComponent.Visible := True;
    FCaptionComponent.Parent := Parent;
    FCaptionComponent.BringToFront;
  end;
  FCaptionComponent.Caption := Value;
end;

function TCaptionEdit.SupportsDynamicProperty(PropertyID: integer): boolean;
begin
  Result := (PropertyID = DynaPropAccesibilityCaption);
end;

{ TCaptionRichEdit }

function TCaptionRichEdit.GetDynamicProperty(PropertyID: integer): string;
begin
  if PropertyID = DynaPropAccesibilityCaption then
    Result := FCaption
  else
    Result := '';
end;


function TCaptionRichEdit.SupportsDynamicProperty(PropertyID: integer): boolean;
begin
  Result := (PropertyID = DynaPropAccesibilityCaption);
end;

{ TCaptionTreeView}

procedure TCaptionTreeView.CMSysColorChange(var Message: TMessage);
begin
  // Change colors here. "inherited" will cause a RecreateWnd.
  // And we don't want that.
  TreeView_SetBkColor(Handle, ColorToRGB(Color));
  TreeView_SetTextColor(Handle, ColorToRGB(Font.Color));
end;

procedure TCaptionTreeView.CreateWnd;
begin
  EventCache.SaveAndNilEvents(CaptionTreeViewRecreateWndEvents);
  try
    inherited;
  finally
    EventCache.RestoreEvents;
  end;
end;

destructor TCaptionTreeView.Destroy;
begin
  FreeAndNil(FEventCache);
  inherited;
end;

procedure TCaptionTreeView.DestroyWnd;
begin
  EventCache.SaveAndNilEvents(CaptionTreeViewRecreateWndEvents);
  try
    inherited;
  finally
    EventCache.RestoreEvents;
  end;
end;

function TCaptionTreeView.GetCaption: string;
begin
  result := inherited Caption;
end;

function TCaptionTreeView.GetDynamicProperty(PropertyID: integer): string;
begin
  if PropertyID = DynaPropAccesibilityCaption then
    Result := GetCaption
  else
    Result := '';
end;

function TCaptionTreeView.GetEventCache: TOREventCache;
begin
  if not Assigned(FEventCache) then
    FEventCache := TOREventCache.Create(Self);
  Result := FEventCache;
end;

procedure TCaptionTreeView.SetCaption(const Value: string);
begin
  if not Assigned(FCaptionComponent) then begin
    FCaptionComponent := TStaticText.Create(self);
    FCaptionComponent.AutoSize := False;
    FCaptionComponent.Height := 0;
    FCaptionComponent.Width := 0;
    FCaptionComponent.Visible := True;
    FCaptionComponent.Parent := Parent;
    FCaptionComponent.BringToFront;
  end;
  FCaptionComponent.Caption := Value;
  inherited Caption := Value;
end;

function TCaptionTreeView.SupportsDynamicProperty(PropertyID: integer): boolean;
begin
  Result := (PropertyID = DynaPropAccesibilityCaption);
end;

procedure TCaptionTreeView.TVMDeleteItem(var Message: TMessage);
begin
  // Users were getting an Access violation in COMCTL32.dll processing this message
  try
    inherited;
  except
  end;
end;

procedure TCaptionTreeView.TVMSelectItem(var Message: TMessage);
begin
  // Users were getting an Access violation in COMCTL32.dll processing this message
  try
    inherited;
  except
  end;
end;

{ TCaptionComboBox }

function TCaptionComboBox.GetCaption: string;
begin
  if not Assigned(FCaptionComponent) then
    result := ''
  else
    result := FCaptionComponent.Caption;
end;

function TCaptionComboBox.GetDynamicProperty(PropertyID: integer): string;
begin
  if PropertyID = DynaPropAccesibilityCaption then
    Result := GetCaption
  else
    Result := '';
end;

procedure TCaptionComboBox.SetCaption(const Value: string);
begin
  if not Assigned(FCaptionComponent) then begin
    FCaptionComponent := TStaticText.Create(self);
    FCaptionComponent.AutoSize := False;
    FCaptionComponent.Height := 0;
    FCaptionComponent.Width := 0;
    FCaptionComponent.Visible := True;
    FCaptionComponent.Parent := Parent;
    FCaptionComponent.BringToFront;
  end;
  FCaptionComponent.Caption := Value;
end;

function TCaptionComboBox.SupportsDynamicProperty(PropertyID: integer): boolean;
begin
  Result := (PropertyID = DynaPropAccesibilityCaption);
end;

{ TORAlignSpeedButton }

procedure TORAlignSpeedButton.Paint;
var
  Rect: TRect;
begin
  inherited;
  if (Parent <> nil) and (Parent is TKeyClickPanel) and TKeyClickPanel(Parent).Focused then
  begin
    Rect := ClientRect;
    InflateRect(Rect, -3, -3);
    Canvas.Brush.Color := Color;
    Canvas.DrawFocusRect(Rect);
  end;
end;

{ TCaptionStringGrid }

{I may have messed up my Windows.pas file, but mine defines NotifyWinEvent without a stdcall.}
procedure GoodNotifyWinEvent; external user32 name 'NotifyWinEvent';

function TCaptionStringGrid.ColRowToIndex(Col, Row: Integer): integer;
begin
  result := (ColCount - FixedCols) * (Row - FixedRows) +
    (Col - FixedCols) + 1;
end;

function TCaptionStringGrid.GetDynamicProperty(PropertyID: integer): string;
begin
  if PropertyID = DynaPropAccesibilityCaption then
    Result := FCaption
  else
    Result := '';
end;

procedure TCaptionStringGrid.IndexToColRow(index: integer; var Col,
  Row: integer);
begin
  Row := (index - 1) div (ColCount - FixedCols) + FixedRows;
  Col := (index - 1) mod (ColCount - FixedCols) + FixedCols;
end;

procedure TCaptionStringGrid.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited;
  {Look for all of the grid navigation keys}
  if (Key in [VK_LEFT, VK_RIGHT, VK_UP, VK_DOWN]) and (Shift = []) or
    (Key = VK_TAB) and (Shift <= [ssShift]) then
    GoodNotifyWinEvent(EVENT_OBJECT_FOCUS, Handle, integer(OBJID_CLIENT),
      ColRowToIndex(Col, Row));
end;


function TCaptionStringGrid.SupportsDynamicProperty(
  PropertyID: integer): boolean;
begin
  Result := (PropertyID = DynaPropAccesibilityCaption);
end;

function IsAMouseButtonDown: boolean;
begin
  if Boolean(Hi(GetKeyState(VK_MBUTTON))) or
    Boolean(Hi(GetKeyState(VK_LBUTTON))) or
    Boolean(Hi(GetKeyState(VK_RBUTTON))) then
    Result := true
  else
    Result := false;
end;

procedure TORComboBox.SetNumForMatch(const NumberForMatch: integer);
begin
  if NumberForMatch < 1 then
    FCharsNeedMatch := 1
  else if NumberForMatch > 15 then
    FCharsNeedMatch := 15
  else
    FCharsNeedMatch := NumberForMatch;
end;

procedure TORComboBox.SetUniqueAutoComplete(const Value: Boolean);
begin
  FUniqueAutoComplete := Value;
end;

function TORListBox.VerifyUnique(SelectIndex: Integer; iText: string): integer;
var
  i: integer;
  counter: integer;
begin
  Result := SelectIndex;
  if LongList then
  begin
      //Implemented for CQ: 10092, PSI-04-057
      //asume long lists are alphabetically ordered...
    if CompareText(iText, Copy(DisplayText[SelectIndex + 1], 1, Length(iText))) = 0 then
      Result := -1;
  end
  else //Not a LongList
  begin
    counter := 0;
    for i := 0 to Items.Count - 1 do
      if CompareText(iText, Copy(DisplayText[i], 1, Length(iText))) = 0 then
        Inc(counter);
    if counter > 1 then
      Result := -1;
  end;
  FFocusIndex := Result;
  ItemIndex := Result;
end;

//This procedure sets the Text property equal to the TextToMatch parameter, then calls
//FwdChangeDelayed which will perform an auto-completion on the text.

procedure TORComboBox.SetTextAutoComplete(TextToMatch: string);
begin
  Text := TextToMatch;
  SelStart := Length(Text);
  FwdChangeDelayed;
end;

{ TCaptionListView }

constructor TCaptionListView.Create(AOwner: TComponent);
begin
  Inherited;
  FAutoSize := False;
  self.OnCreateItemClass := CreateItemClass;
  FItemsStrings := TCaptionListStringList.CreateWithParent(self);
  FColumnToSort := 0;
end;

destructor TCaptionListView.Destroy;
begin
  Inherited;
  FItemsStrings.Free;
  FreeAndNil(FItemsStringsBackup);
end;

function TCaptionListView.AddItemToList(aStr: string; aObject: TObject): TCaptionListItem;
Var
 NewItem: TCaptionListItem;
 X: Integer;
begin
  NewItem := TCaptionListItem(Items.Add);
  NewItem.ItemString := aStr;
  if Assigned(aObject) then
   NewItem.aObject := aObject;
  for X := 1 to FPieces[0] do
  begin
   if X = 1 then
     NewItem.Caption := Piece(aStr, '^', FPieces[x])
   else
    NewItem.SubItems.Add(Piece(aStr, '^', FPieces[x]));
  end;
  result := NewItem;
  AutoSizeColumns;
end;

function TCaptionListView.Add(aStr: string): Integer;
begin
 Result := Add(aStr, nil);
end;


function TCaptionListView.AddObject(aStr: string; aObject: TObject): Integer;
var
 aItem: TCaptionListItem;
begin
 aItem := AddItemToList(aStr, aObject);
 Result := aItem.Index;
end;

function TCaptionListView.Add(aStr: string; aObject: TObject): Integer;
var
 aItem: TCaptionListItem;
begin
 aItem := AddItemToList(aStr, aObject);
 Result := aItem.Index;
end;

function TCaptionListView.GetDynamicProperty(PropertyID: integer): string;
begin
  if PropertyID = DynaPropAccesibilityCaption then
    Result := Caption
  else
    Result := '';
end;

function TCaptionListView.SupportsDynamicProperty(PropertyID: integer): boolean;
begin
  Result := (PropertyID = DynaPropAccesibilityCaption);
end;

function TCaptionListView.GetPieces: string;
{ returns the pieces of an item currently selected for display }
begin
  Result := IntArrayToString(FPieces);
end;

procedure TCaptionListView.Loaded;
begin
  inherited;
  ResetTinyColumns;
end;

procedure TCaptionListView.CreateWnd;
var
  i, max: integer;
begin
  inherited;
  if assigned(FItemsStringsBackup) then
  begin
    max := Items.Count;
    if max > FItemsStringsBackup.Count then
      max := FItemsStringsBackup.Count;
    for i := 0 to max - 1 do
      if Items[i] is TCaptionListItem then
      begin
        TCaptionListItem(Items[i]).ItemString := FItemsStringsBackup[i];
        TCaptionListItem(Items[i]).aObject := FItemsStringsBackup.Objects[i];
      end;
    FreeAndNil(FItemsStringsBackup);
  end;
end;

procedure TCaptionListView.DestroyWnd;
var
  i: integer;
begin
  if (csRecreating in ControlState) and (not OwnerData) then
  begin
    if not assigned(FItemsStringsBackup) then
      FItemsStringsBackup := TStringList.Create
    else
      FItemsStringsBackup.Clear;
    for i := 0 to Items.Count - 1 do
      if Items[i] is TCaptionListItem then
        with TCaptionListItem(Items[i]) do
          FItemsStringsBackup.AddObject(ItemString, aObject)
      else
        FItemsStringsBackup.AddObject('', nil);
  end;
  inherited;
end;

procedure TCaptionListView.SetPieces(const Value: string);
{ converts a string of comma-delimited integers into an array of string pieces to display }
begin
  StringToIntArray(Value, FPieces);
end;

//called when adding items
procedure TCaptionListView.AutoSizeColumns;
Var
 Z, MaxB, MaxH: integer;
begin
  //only auto size the columns if it is enabled (disabled by default)
  if not(FAutoSize) then exit;

 //Look at the header and the last added row
 for Z := 0 to Columns.Count - 1 do
 begin
  MaxH := Max(Columns[Z].Width, Canvas.TextWidth(Columns[Z].Caption));
  if Z = 0 then
    MaxB := Canvas.TextWidth(Items[Items.Count - 1].Caption)
  else
    MaxB := Canvas.TextWidth(Items[Items.Count - 1].SubItems.Strings[Z - 1]);

  Columns[Z].Width := Max(MaxH, MaxB) + 20;
  end;

end;

function TCaptionListView.GetItemIEN: Int64;
{ return as an integer the first piece of the currently selected item }
begin
  if assigned(Selected)
    then Result := StrToInt64Def(Piece(Strings[Selected.Index], '^', 1), 0)
  else Result := 0;
end;

function TCaptionListView.GetItemID: Variant;
{ return as a variant the first piece of the currently selected item }
begin
  if assigned(Selected) then Result := Piece(Strings[Selected.Index], '^', 1) else Result := '';
end;

procedure TCaptionListView.WMNotify(var Message: TWMNotify);
begin
  inherited;
  if FHideTinyColumns then
    with Message.NMHdr^, PHDNotify(Pointer(Message.NMHdr))^ do
      if (code = HDN_BEGINTRACK) and (pos('^' + Item.ToString + '^', FTinyColumns) > 0) then
        Message.Result := 1;
end;

procedure TCaptionListView.WMSetFocus(var Message: TMessage);
//var
// aRect: TRect;
 begin
 inherited;
 if Self.ItemIndex = -1 then
  ListView_SetItemState(Self.Handle, 0, LVIS_FOCUSED, LVIS_FOCUSED);
 RedrawWindow(Self.Handle, nil, 0, RDW_ERASE or RDW_INVALIDATE or RDW_UPDATENOW);
end;

procedure TCaptionListView.EditItem(Index: Integer; aStr: String);
Var
 NewItem: TCaptionListItem;
 X: Integer;
begin
  NewItem := TCaptionListItem(Items[Index]);
  NewItem.ItemString := aStr;
  for X := 1 to FPieces[0] do
  begin
   if X = 1 then
     NewItem.Caption := Piece(aStr, '^', FPieces[x])
   else
    NewItem.SubItems.Add(Piece(aStr, '^', FPieces[x]));
  end;
end;

function TCaptionListView.Get(Index: Integer): String;
begin
  if Cardinal(Index) < Cardinal(Items.Count) then
   Result := TCaptionListItem(Items[Index]).ItemString;
end;

procedure TCaptionListView.Put(Index: Integer; Item: String);
var
  TheItem: TCaptionListItem;
  X: Integer;
begin
  if (Index >= 0) and (Index < Items.Count) then
  begin
  TheItem := TCaptionListItem(Items[Index]);
  TheItem.ItemString := Item;
  for X := 1 to FPieces[0] do
  begin
   if X = 1 then
     TheItem.Caption := Piece(Item, '^', FPieces[x])
   else
    TheItem.SubItems.Strings[x-2] := Piece(Item, '^', FPieces[x]);
   // TheItem.SubItems.Add(Piece(Item, '^', FPieces[x]));
  end;

  end;
end;

function TCaptionListView.GetObj(Index: Integer): TObject;
begin
 Result := nil;
 if Cardinal(Index) < Cardinal(Items.Count) then
   Result := TCaptionListItem(Items[Index]).aObject;
end;

procedure TCaptionListView.PutObj(Index: Integer; ItemObject: TObject);
var
  TheItem: TCaptionListItem;
begin
  if (Index >= 0) and (Index < Items.Count) then
  begin
  TheItem := TCaptionListItem(Items[Index]);
  TheItem.aObject := ItemObject;
  end;
end;

procedure TCaptionListView.ResetTinyColumns;
var
  i: integer;

begin
  FTinyColumns := '^';
  if FHideTinyColumns then
  begin
    for i := 0 to Columns.Count-1 do
    begin
      if Columns[i].Width <= TINY_COLS_MAX_WIDTH then
        FTinyColumns := FTinyColumns + i.ToString + '^';
    end;
  end;
end;

procedure TCaptionListView.CreateItemClass(Sender: TCustomListView; var ItemClass: TListItemClass);
begin
 ItemClass := TCaptionListItem;
end;


function TCaptionListView.GetItemsStrings: TCaptionListStringList;
var
 I: Integer;
begin
  FItemsStrings.Clear;
  for i := 0 to Items.Count-1 do begin

   if Assigned(TCaptionListItem(Items[i]).aObject) then
     TStringList(FItemsStrings).AddObject(TCaptionListItem(Items[i]).ItemString, TCaptionListItem(Items[i]).aObject)
   else
     TStringList(FItemsStrings).Add(TCaptionListItem(Items[i]).ItemString);
  end;
  Result := FItemsStrings;
end;

Procedure TCaptionListView.SetFromStringList(AValue: TCaptionListStringList);
Var
 NewItem: TCaptionListItem;
 X, I: Integer;
begin
  Items.Clear;
  for i := 0 to AValue.Count - 1 do
  begin
    NewItem := TCaptionListItem(Items.Add);
    NewItem.ItemString := AValue.Strings[i];

    if Assigned(AValue.Objects[i]) then
      NewItem.aObject := aValue.Objects[i];

    for X := 1 to FPieces[0] do
    begin
     if X = 1 then
       NewItem.Caption := Piece(AValue.Strings[i], '^', FPieces[x])
     else
      NewItem.SubItems.Add(Piece(AValue.Strings[i], '^', FPieces[x]));
    end;
  end;

end;

procedure TCaptionListView.SetHideTinyColumns(const Value: Boolean);
begin
  FHideTinyColumns := Value;
  if not (csLoading in ComponentState) then
    ResetTinyColumns;
end;

function TCaptionListView.GetListHeaderSortStateByIndex(ColumnIndex: integer)
  : THeaderSortState;
var
  i: integer;
  Column: TListColumn;
begin
  Result := hssNone;
  for i := 0 to Self.Columns.Count - 1 do
  begin
    Column := Self.Columns.Items[i];
    if Column.index = ColumnIndex then
    begin
      Result := GetListHeaderSortState(Column);
      break;
    end;
  end;
end;

procedure TCaptionListView.SetListHeaderSortStateByIndex(ColumnIndex: Integer; Value: THeaderSortState);
var
  i: integer;
  Column: TListColumn;
begin
  for i := 0 to Self.Columns.Count - 1 do
  begin
    Column := Self.Columns.Items[i];
    if Column.index = ColumnIndex then
    begin
      SetListHeaderSortState(Column, Value);
      break;
    end;
  end;
end;

function TCaptionListView.GetListHeaderSortState(Column: TListColumn)
  : THeaderSortState;
var
  Header: hwnd;
  Item: THDItem;
begin
  Header := ListView_GetHeader(Self.Handle);
  ZeroMemory(@Item, SizeOf(Item));
  Item.mask := HDI_FORMAT;
  Header_GetItem(Header, Column.index, Item);

  // Get the current sort direction
  if Item.fmt and HDF_SORTUP <> 0 then
    Result := hssAscending
  else if Item.fmt and HDF_SORTDOWN <> 0 then
    Result := hssDescending
  else
    Result := hssNone;
end;

procedure TCaptionListView.SetListHeaderSortState(Column: TListColumn;
  Value: THeaderSortState);
var
  Header: hwnd;
  Item: THDItem;
begin
  Header := ListView_GetHeader(Self.Handle);
  ZeroMemory(@Item, SizeOf(Item));
  Item.mask := HDI_FORMAT;

  // Clear sort indicators
  Header_GetItem(Header, Column.index, Item);
  Item.fmt := Item.fmt and not(HDF_SORTUP or HDF_SORTDOWN);

  // Set the sort indicator
  case Value of
    hssAscending:
      Item.fmt := Item.fmt or HDF_SORTUP ;
    hssDescending:
      Item.fmt := Item.fmt or HDF_SORTDOWN;
    else
      Item.fmt := Item.fmt and not(HDF_SORTUP or HDF_SORTDOWN);
  end;
  Header_SetItem(Header, Column.index, Item);
end;

procedure TCaptionListView.ColClick(Column: TListColumn);
begin
  inherited;
  DoColumnSort(Column);
end;

procedure TCaptionListView.DoColumnSort(Column: TListColumn);
var
  i: integer;
  SortState: THeaderSortState;
begin
  if Assigned(Self.OnCompare) then
  begin
    // set the sort column and call the sort (which calls OnCompare)
    FColumnToSort := Column.index;
    Self.AlphaSort;

    // Update Column sort indicators
    for i := 0 to Self.Columns.count - 1 do
    begin
      if Self.Column[i] = Column then
      begin
        if GetListHeaderSortState(Column) <> hssAscending then
          SortState := hssAscending
        else
          SortState := hssDescending;
      end
      else
        SortState := hssNone;

      SetListHeaderSortState(Self.Column[i], SortState);
    end;
  end;
end;


function TCaptionListView.GetIEN(AnIndex: Integer): Int64;
{ return as an integer the first piece of the Item identified by AnIndex }
begin
  if (AnIndex < Items.Count) and (AnIndex > -1)
    then Result := StrToInt64Def(Piece(ItemsStrings[AnIndex], '^', 1), 0)
  else Result := 0;
end;

function TCaptionListView.SelectByIEN(AnIEN: Int64): Integer;
{ cause the item where the first piece = AnIEN to be selected (sets ItemIndex) }
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Items.Count - 1 do
    if GetIEN(i) = AnIEN then
    begin
      ItemIndex := i;
      Items[i].selected := true;
      Result := i;
      break;
    end;
end;

constructor TCaptionListStringList.CreateWithParent(Parent: TObject);
begin
 inherited Create;
 fParentCLV := Parent;
end;

procedure TCaptionListStringList.Assign(Source: TPersistent);
begin
  inherited;
  if fParentCLV is TCaptionListView then
   TCaptionListView(fParentCLV).SetFromStringList(TCaptionListStringList(Source));
end;

initialization
  //uItemTip := TItemTip.Create(Application);  // all listboxes share a single ItemTip window
  uItemTipCount := 0;
  uNewStyle := Lo(GetVersion) >= 4; // True = Win95 interface, otherwise old interface
  FillChar(ORCBImages, SizeOf(ORCBImages), 0);

finalization
  //uItemTip.Free;                           // don't seem to need this - called by Application
  DestroyORCBBitmaps;

{$WARN UNSAFE_CAST ON}
{$WARN UNSAFE_CODE ON}
end.
