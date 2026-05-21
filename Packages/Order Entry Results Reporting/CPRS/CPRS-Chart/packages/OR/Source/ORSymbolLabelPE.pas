unit ORSymbolLabelPE;

interface

uses
  Winapi.Windows,
  System.Classes,
  System.SysUtils,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  Vcl.Mask,
  Vcl.ExtCtrls,
  Vcl.Buttons,
  Vcl.Controls,
  Vcl.Dialogs,
  Vcl.Graphics,
  ORSymbolLabel;

type
  TfrmORSymbolLabelPE = class(TForm)
    splMain: TSplitter;
    pnlRight: TPanel;
    gpButtons: TGridPanel;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    gpMain: TGridPanel;
    lblForegroundValue: TLabel;
    lblForegroundColor: TLabel;
    edtForegroundValue: TEdit;
    btnForegroundValueKeep: TButton;
    btnForegroundNext: TButton;
    btnForegroundPrev: TButton;
    lblGap1: TLabel;
    lblGap2: TLabel;
    lblBackgroundValue: TLabel;
    lblBackgroundColor: TLabel;
    edtBackgroundValue: TEdit;
    btnBackgroundValueKeep: TButton;
    btnBackgroundNext: TButton;
    btnBackgroundPrev: TButton;
    lblGap3: TLabel;
    clrForeground: TColorBox;
    clrBackground: TColorBox;
    lblForegroundName: TLabel;
    edtForegroundName: TEdit;
    lblBackgroundName: TLabel;
    edtBackgroundName: TEdit;
    lblForeground: TLabel;
    lblBackground: TLabel;
    btnForegroundNameKeep: TButton;
    btnBackgroundNameKeep: TButton;
    lblGap4: TLabel;
    lblGap5: TLabel;
    btnForegroundClear: TButton;
    btnBackgroundClear: TButton;
    gpTop: TGridPanel;
    symMain: TORSymbolLabel;
    pnlLeft: TPanel;
    lv: TListView;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure lvDblClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure edtKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnKeepClick(Sender: TObject);
    procedure clrChange(Sender: TObject);
    procedure btnEnter(Sender: TObject);
    procedure ctrlEnter(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
  private type
    TWorkingOn = (woNone, woForeground, woBackground);
  private
    FCurrentIndex: Integer;
    FInternal: Boolean;
    FSymbols: TStringList;
    FWorkingOn: TWorkingOn;
    procedure DoSearch(Sender: TObject; Forward: Boolean);
  public
    procedure UpdateCtrls; virtual;
  end;

implementation

{$R *.dfm}

uses
  ORFn;

var
  SymbolLabelPEPosition: TRect;

type
  TORSymbolData = record
    Name: string;
    Value: Word;
  end;

const
  ORSymbolTable: array [0 .. 1646] of TORSymbolData = ((Name: 'None';
    Value: $0020), (Name: '!'; Value: $0021), (Name: '"'; Value: $0022),
    (Name: '#'; Value: $0023), (Name: '$'; Value: $0024), (Name: '%';
    Value: $0025), (Name: '&'; Value: $0026), (Name: ''''; Value: $0027),
    (Name: '('; Value: $0028), (Name: ')'; Value: $0029), (Name: '*';
    Value: $002A), (Name: '+'; Value: $002B), (Name: ','; Value: $002C),
    (Name: '-'; Value: $002D), (Name: '.'; Value: $002E), (Name: '/';
    Value: $002F), (Name: '0'; Value: $0030), (Name: '1'; Value: $0031),
    (Name: '2'; Value: $0032), (Name: '3'; Value: $0033), (Name: '4';
    Value: $0034), (Name: '5'; Value: $0035), (Name: '6'; Value: $0036),
    (Name: '7'; Value: $0037), (Name: '8'; Value: $0038), (Name: '9';
    Value: $0039), (Name: ':'; Value: $003A), (Name: ';'; Value: $003B),
    (Name: '<'; Value: $003C), (Name: '='; Value: $003D), (Name: '>';
    Value: $003E), (Name: '?'; Value: $003F), (Name: '@'; Value: $0040),
    (Name: 'A'; Value: $0041), (Name: 'B'; Value: $0042), (Name: 'C';
    Value: $0043), (Name: 'D'; Value: $0044), (Name: 'E'; Value: $0045),
    (Name: 'F'; Value: $0046), (Name: 'G'; Value: $0047), (Name: 'H';
    Value: $0048), (Name: 'I'; Value: $0049), (Name: 'J'; Value: $004A),
    (Name: 'K'; Value: $004B), (Name: 'L'; Value: $004C), (Name: 'M';
    Value: $004D), (Name: 'N'; Value: $004E), (Name: 'O'; Value: $004F),
    (Name: 'P'; Value: $0050), (Name: 'Q'; Value: $0051), (Name: 'R';
    Value: $0052), (Name: 'S'; Value: $0053), (Name: 'T'; Value: $0054),
    (Name: 'U'; Value: $0055), (Name: 'V'; Value: $0056), (Name: 'W';
    Value: $0057), (Name: 'X'; Value: $0058), (Name: 'Y'; Value: $0059),
    (Name: 'Z'; Value: $005A), (Name: '['; Value: $005B), (Name: '\';
    Value: $005C), (Name: ']'; Value: $005D), (Name: '^'; Value: $005E),
    (Name: '_'; Value: $005F), (Name: '`'; Value: $0060), (Name: 'a';
    Value: $0061), (Name: 'b'; Value: $0062), (Name: 'c'; Value: $0063),
    (Name: 'd'; Value: $0064), (Name: 'e'; Value: $0065), (Name: 'f';
    Value: $0066), (Name: 'g'; Value: $0067), (Name: 'h'; Value: $0068),
    (Name: 'i'; Value: $0069), (Name: 'j'; Value: $006A), (Name: 'k';
    Value: $006B), (Name: 'l'; Value: $006C), (Name: 'm'; Value: $006D),
    (Name: 'n'; Value: $006E), (Name: 'o'; Value: $006F), (Name: 'p';
    Value: $0070), (Name: 'q'; Value: $0071), (Name: 'r'; Value: $0072),
    (Name: 's'; Value: $0073), (Name: 't'; Value: $0074), (Name: 'u';
    Value: $0075), (Name: 'v'; Value: $0076), (Name: 'w'; Value: $0077),
    (Name: 'x'; Value: $0078), (Name: 'y'; Value: $0079), (Name: 'z';
    Value: $007A), (Name: '{'; Value: $007B), (Name: '|'; Value: $007C),
    (Name: '}'; Value: $007D), (Name: '~'; Value: $007E), (Name: 'Accept';
    Value: $E8FB), (Name: 'AcceptMedium'; Value: $F78C), (Name: 'Accident';
    Value: $E81F), (Name: 'AccidentSolid'; Value: $EA8E), (Name: 'AccountBox';
    Value: $E187), (Name: 'AccountCancel'; Value: $E1E0),
    (Name: 'AccountDetailsOutline'; Value: $E136), (Name: 'AccountFrameOutline';
    Value: $E156), (Name: 'AccountMultiple'; Value: $E125),
    (Name: 'AccountOutline'; Value: $E13D), (Name: 'AccountPlus'; Value: $E1E2),
    (Name: 'Accounts'; Value: $E910), (Name: 'AccountStatus'; Value: $E181),
    (Name: 'ActionCenter'; Value: $E91C), (Name: 'ActionCenterAsterisk';
    Value: $EA21), (Name: 'ActionCenterMirrored'; Value: $ED0D),
    (Name: 'ActionCenterNotification'; Value: $E7E7),
    (Name: 'ActionCenterNotificationMirrored'; Value: $ED0C),
    (Name: 'ActionCenterQuiet'; Value: $EE79),
    (Name: 'ActionCenterQuietNotification'; Value: $EE7A), (Name: 'Add';
    Value: $E710), (Name: 'AddBold'; Value: $F8AA), (Name: 'AddFriend';
    Value: $E8FA), (Name: 'AddNewLine'; Value: $F7B7), (Name: 'AddNewLineFill';
    Value: $F7B8), (Name: 'AddRemoteDevice'; Value: $E836),
    (Name: 'AddSurfaceHub'; Value: $ECC4), (Name: 'AddTo'; Value: $ECC8),
    (Name: 'AdjustHologram'; Value: $EBD2), (Name: 'Admin'; Value: $E7EF),
    (Name: 'Airplane'; Value: $E709), (Name: 'AirplaneSolid'; Value: $EB4C),
    (Name: 'Album'; Value: $E142), (Name: 'AlignCenter'; Value: $E8E3),
    (Name: 'AlignLeft'; Value: $E8E4), (Name: 'AlignRight'; Value: $E8E2),
    (Name: 'AllApps'; Value: $E71D), (Name: 'AllAppsMirrored'; Value: $EA40),
    (Name: 'Annotation'; Value: $E924), (Name: 'AppIconDefault'; Value: $ECAA),
    (Name: 'ApplicationGuard'; Value: $F0EF), (Name: 'Apps'; Value: $ED35),
    (Name: 'AreaChart'; Value: $E9D2), (Name: 'Arrow'; Value: $E1D1),
    (Name: 'ArrowDown'; Value: $E1FD), (Name: 'ArrowDown8'; Value: $F0AE),
    (Name: 'ArrowLeft'; Value: $E0A6), (Name: 'ArrowLeft8'; Value: $F0B0),
    (Name: 'ArrowRight'; Value: $E0AD), (Name: 'ArrowRight8'; Value: $F0AF),
    (Name: 'ArrowUp'; Value: $E110), (Name: 'ArrowUp8'; Value: $F0AD),
    (Name: 'AspectRatio'; Value: $E799), (Name: 'Asterisk'; Value: $EA38),
    (Name: 'AsteriskBadge12'; Value: $EDAD), (Name: 'Attach'; Value: $E723),
    (Name: 'AttachCamera'; Value: $E8A2), (Name: 'Audio'; Value: $E8D6),
    (Name: 'Back'; Value: $E72B), (Name: 'BackgroundToggle'; Value: $EF1F),
    (Name: 'BackMirrored'; Value: $F0D2), (Name: 'BackSolidBold'; Value: $F8AC),
    (Name: 'BackSpaceQWERTY'; Value: $E750), (Name: 'BackSpaceQWERTYLg';
    Value: $EB96), (Name: 'BackSpaceQWERTYMd'; Value: $E926),
    (Name: 'BackSpaceQWERTYSm'; Value: $E925), (Name: 'BackToWindow';
    Value: $E73F), (Name: 'Badge'; Value: $EC1B), (Name: 'Bag'; Value: $E14D),
    (Name: 'BandBattery0'; Value: $ECB9), (Name: 'BandBattery1'; Value: $ECBA),
    (Name: 'BandBattery2'; Value: $ECBB), (Name: 'BandBattery3'; Value: $ECBC),
    (Name: 'BandBattery4'; Value: $ECBD), (Name: 'BandBattery5'; Value: $ECBE),
    (Name: 'BandBattery6'; Value: $ECBF), (Name: 'Bank'; Value: $E825),
    (Name: 'BarcodeScanner'; Value: $EC5A), (Name: 'Battery0'; Value: $E850),
    (Name: 'Battery1'; Value: $E851), (Name: 'Battery10'; Value: $E83F),
    (Name: 'Battery2'; Value: $E852), (Name: 'Battery3'; Value: $E853),
    (Name: 'Battery4'; Value: $E854), (Name: 'Battery5'; Value: $E855),
    (Name: 'Battery6'; Value: $E856), (Name: 'Battery7'; Value: $E857),
    (Name: 'Battery8'; Value: $E858), (Name: 'Battery9'; Value: $E859),
    (Name: 'BatteryCharging0'; Value: $E85A), (Name: 'BatteryCharging1';
    Value: $E85B), (Name: 'BatteryCharging10'; Value: $EA93),
    (Name: 'BatteryCharging2'; Value: $E85C), (Name: 'BatteryCharging3';
    Value: $E85D), (Name: 'BatteryCharging4'; Value: $E85E),
    (Name: 'BatteryCharging5'; Value: $E85F), (Name: 'BatteryCharging6';
    Value: $E860), (Name: 'BatteryCharging7'; Value: $E861),
    (Name: 'BatteryCharging8'; Value: $E862), (Name: 'BatteryCharging9';
    Value: $E83E), (Name: 'BatterySaver0'; Value: $E863),
    (Name: 'BatterySaver1'; Value: $E864), (Name: 'BatterySaver10';
    Value: $EA95), (Name: 'BatterySaver2'; Value: $E865),
    (Name: 'BatterySaver3'; Value: $E866), (Name: 'BatterySaver4';
    Value: $E867), (Name: 'BatterySaver5'; Value: $E868),
    (Name: 'BatterySaver6'; Value: $E869), (Name: 'BatterySaver7';
    Value: $E86A), (Name: 'BatterySaver8'; Value: $E86B),
    (Name: 'BatterySaver9'; Value: $EA94), (Name: 'BatteryUnknown';
    Value: $E996), (Name: 'Beta'; Value: $EA24), (Name: 'BidiLtr';
    Value: $E9AA), (Name: 'BidiRtl'; Value: $E9AB), (Name: 'BlockContact';
    Value: $E8F8), (Name: 'Blocked2'; Value: $ECE4), (Name: 'BlueLight';
    Value: $F08C), (Name: 'Bluetooth'; Value: $E702), (Name: 'BodyCam';
    Value: $EC80), (Name: 'Bold'; Value: $E8DD), (Name: 'Bookmarks';
    Value: $E8A4), (Name: 'BookmarksMirrored'; Value: $EA41), (Name: 'BoxSmall';
    Value: $E004), (Name: 'Brightness'; Value: $E706), (Name: 'Broom';
    Value: $EA99), (Name: 'BrowsePhotos'; Value: $E7C5), (Name: 'BrushSize';
    Value: $EDA8), (Name: 'Bug'; Value: $EBE8), (Name: 'BuildingEnergy';
    Value: $EC0B), (Name: 'BulletedList'; Value: $E8FD),
    (Name: 'BulletedListMirrored'; Value: $EA42), (Name: 'Bullseye';
    Value: $F272), (Name: 'BumperLeft'; Value: $F10C), (Name: 'BumperRight';
    Value: $F10D), (Name: 'Bus'; Value: $E806), (Name: 'BusSolid';
    Value: $EB47), (Name: 'ButtonA'; Value: $F093), (Name: 'ButtonB';
    Value: $F094), (Name: 'ButtonMenu'; Value: $EDE3), (Name: 'ButtonView2';
    Value: $EECA), (Name: 'ButtonX'; Value: $F096), (Name: 'ButtonY';
    Value: $F095), (Name: 'Cafe'; Value: $EC32), (Name: 'Calculator';
    Value: $E8EF), (Name: 'CalculatorAddition'; Value: $E948),
    (Name: 'CalculatorBackspace'; Value: $E94F), (Name: 'CalculatorDivide';
    Value: $E94A), (Name: 'CalculatorEqualTo'; Value: $E94E),
    (Name: 'CalculatorMultiply'; Value: $E947), (Name: 'CalculatorNegate';
    Value: $E94D), (Name: 'CalculatorPercentage'; Value: $E94C),
    (Name: 'CalculatorSquareroot'; Value: $E94B), (Name: 'CalculatorSubtract';
    Value: $E949), (Name: 'Calendar'; Value: $E163), (Name: 'Calendar';
    Value: $E787), (Name: 'CalendarDay'; Value: $E184), (Name: 'CalendarDay2';
    Value: $E8BF), (Name: 'CalendarMirrored'; Value: $ED28),
    (Name: 'CalendarRepeat'; Value: $E161), (Name: 'CalendarReply';
    Value: $E8F5), (Name: 'CalendarSolid'; Value: $EA89), (Name: 'CalendarWeek';
    Value: $E8C0), (Name: 'CallControl'; Value: $E80B), (Name: 'CallForwarding';
    Value: $E7F2), (Name: 'CallForwardingMirrored'; Value: $EA97),
    (Name: 'CallForwardInternational'; Value: $E87A),
    (Name: 'CallForwardInternationalMirrored'; Value: $EA43),
    (Name: 'CallForwardRoaming'; Value: $E87B),
    (Name: 'CallForwardRoamingMirrored'; Value: $EA44),
    (Name: 'CalligraphyFill'; Value: $F0C7), (Name: 'CalligraphyPen';
    Value: $EDFB), (Name: 'Calories'; Value: $ECAD), (Name: 'Camera';
    Value: $E722), (Name: 'CameraClicker'; Value: $E12D), (Name: 'CameraSwitch';
    Value: $E124), (Name: 'Cancel'; Value: $E25B), (Name: 'Cancel2';
    Value: $E711), (Name: 'CancelMedium'; Value: $F78A), (Name: 'Caption';
    Value: $E8BA), (Name: 'Car'; Value: $E804),
    (Name: 'CaretBottomRightSolidCenter8'; Value: $F169),
    (Name: 'CaretDownSolid8'; Value: $EDDC), (Name: 'CaretLeftSolid8';
    Value: $EDD9), (Name: 'CaretRight8'; Value: $EDD6),
    (Name: 'CaretRightSolid8'; Value: $EDDA), (Name: 'CaretUpSolid8';
    Value: $EDDB), (Name: 'CashDrawer'; Value: $EC59), (Name: 'CC';
    Value: $E7F0), (Name: 'CellPhone'; Value: $E8EA), (Name: 'Certificate';
    Value: $EB95), (Name: 'CharacterAppearance'; Value: $F17F),
    (Name: 'Characters'; Value: $E8C1), (Name: 'ChatBubbles'; Value: $E8F2),
    (Name: 'Check'; Value: $E001), (Name: 'Checkbox'; Value: $E739),
    (Name: 'Checkbox14'; Value: $F16B), (Name: 'CheckboxBlank'; Value: $E002),
    (Name: 'CheckboxBlankOutline'; Value: $E003), (Name: 'CheckboxCheck';
    Value: $E005), (Name: 'CheckboxComposite'; Value: $E73A),
    (Name: 'CheckboxComposite14'; Value: $F16C),
    (Name: 'CheckboxCompositeReversed'; Value: $E73D), (Name: 'CheckboxFill';
    Value: $E73B), (Name: 'CheckboxIndeterminate'; Value: $E73C),
    (Name: 'CheckboxIndeterminateCombo'; Value: $F16E),
    (Name: 'CheckboxIndeterminateCombo14'; Value: $F16D),
    (Name: 'CheckboxOutlineCheck'; Value: $E0A2), (Name: 'CheckList';
    Value: $E9D5), (Name: 'ChecklistMirrored'; Value: $F0B5),
    (Name: 'CheckMark'; Value: $E73E), (Name: 'CheveronLeft20'; Value: $F743),
    (Name: 'CheveronLeft32'; Value: $F744), (Name: 'CheveronRight20';
    Value: $F745), (Name: 'CheveronRight32'; Value: $F746),
    (Name: 'ChevronDown'; Value: $E70D), (Name: 'ChevronDownMed'; Value: $E972),
    (Name: 'ChevronDownSmall'; Value: $E96E), (Name: 'ChevronLeft';
    Value: $E76B), (Name: 'ChevronLeftMed'; Value: $E973),
    (Name: 'ChevronLeftSmall'; Value: $E96F), (Name: 'ChevronRight';
    Value: $E76C), (Name: 'ChevronRightMed'; Value: $E974),
    (Name: 'ChevronRightSmall'; Value: $E970), (Name: 'ChevronUp';
    Value: $E70E), (Name: 'ChevronUpMed'; Value: $E971),
    (Name: 'ChevronUpSmall'; Value: $E96D), (Name: 'ChineseBoPoMoFo';
    Value: $E989), (Name: 'ChineseChangjie'; Value: $E981),
    (Name: 'ChinesePinyin'; Value: $E98A), (Name: 'ChinesePunctuation';
    Value: $F111), (Name: 'ChineseQuick'; Value: $E984),
    (Name: 'ChipCardCreditCardReader'; Value: $EF40), (Name: 'ChromeAnnotate';
    Value: $E931), (Name: 'ChromeAnnotateContrast'; Value: $F0F9),
    (Name: 'ChromeBack'; Value: $E830), (Name: 'ChromeBackContrast';
    Value: $F0D5), (Name: 'ChromeBackContrastMirrored'; Value: $F0D6),
    (Name: 'ChromeBackMirrored'; Value: $EA47), (Name: 'ChromeBackToWindow';
    Value: $E92C), (Name: 'ChromeBackToWindowContrast'; Value: $F0D7),
    (Name: 'ChromeClose'; Value: $E8BB), (Name: 'ChromeCloseContrast';
    Value: $EF2C), (Name: 'ChromeFullScreen'; Value: $E92D),
    (Name: 'ChromeFullScreenContrast'; Value: $F0D8), (Name: 'ChromeMaximize';
    Value: $E922), (Name: 'ChromeMaximizeContrast'; Value: $EF2E),
    (Name: 'ChromeMinimize'; Value: $E921), (Name: 'ChromeMinimizeContrast';
    Value: $EF2D), (Name: 'ChromeRestore'; Value: $E923),
    (Name: 'ChromeRestoreContrast'; Value: $EF2F), (Name: 'ChromeSwitch';
    Value: $F1CB), (Name: 'ChromeSwitchContast'; Value: $F1CC),
    (Name: 'CHTLanguageBar'; Value: $F69E), (Name: 'CircleFill'; Value: $EA3B),
    (Name: 'CircleFillBadge12'; Value: $EDB0), (Name: 'CircleRing';
    Value: $EA3A), (Name: 'CircleRingBadge12'; Value: $EDAF),
    (Name: 'CircleShapeSolid'; Value: $F63C), (Name: 'CityNext'; Value: $EC06),
    (Name: 'CityNext2'; Value: $EC07), (Name: 'Clear'; Value: $E894),
    (Name: 'ClearAllInk'; Value: $ED62), (Name: 'ClearAllInkMirrored';
    Value: $EF19), (Name: 'ClearSelection'; Value: $E8E6),
    (Name: 'ClearSelectionMirrored'; Value: $EA48), (Name: 'Click';
    Value: $E8B0), (Name: 'ClickedOutLoudSolidBold'; Value: $F8B3),
    (Name: 'ClickSolid'; Value: $F8AF), (Name: 'ClipboardList'; Value: $F0E3),
    (Name: 'ClipboardListMirrored'; Value: $F0E4), (Name: 'ClippingTool';
    Value: $F406), (Name: 'Clock'; Value: $E121), (Name: 'Close'; Value: $E106),
    (Name: 'CloseCaption'; Value: $E190), (Name: 'ClosePane'; Value: $E89F),
    (Name: 'ClosePaneMirrored'; Value: $EA49), (Name: 'Cloud'; Value: $E753),
    (Name: 'CloudPrinter'; Value: $EDA6), (Name: 'CloudSearch'; Value: $EDE4),
    (Name: 'Code'; Value: $E943), (Name: 'CollapseContent'; Value: $F165),
    (Name: 'CollapseContentSingle'; Value: $F166), (Name: 'CollateLandscape';
    Value: $F57B), (Name: 'CollateLandscapeSeparated'; Value: $F5AC),
    (Name: 'CollatePortrait'; Value: $F57C), (Name: 'CollatePortraitSeparated';
    Value: $F57D), (Name: 'Color'; Value: $E790), (Name: 'ColorOff';
    Value: $F570), (Name: 'ColorSolid'; Value: $F354), (Name: 'CommaKey';
    Value: $E9AD), (Name: 'CommandPrompt'; Value: $E756), (Name: 'Comment';
    Value: $E90A), (Name: 'Communications'; Value: $E95A),
    (Name: 'CompanionApp'; Value: $EC64), (Name: 'CompanionDeviceFramework';
    Value: $ED5D), (Name: 'Compare'; Value: $E11E), (Name: 'Completed';
    Value: $E930), (Name: 'CompletedSolid'; Value: $EC61), (Name: 'Component';
    Value: $E950), (Name: 'ComposeMode'; Value: $F6A9), (Name: 'Computer';
    Value: $E211), (Name: 'Connect'; Value: $E703), (Name: 'ConnectApp';
    Value: $ED5C), (Name: 'Connected'; Value: $F0B9), (Name: 'Construction';
    Value: $E822), (Name: 'ConstructionCone'; Value: $E98F),
    (Name: 'ConstructionSolid'; Value: $EA8D), (Name: 'Contact'; Value: $E77B),
    (Name: 'Contact'; Value: $E12A), (Name: 'Contact2'; Value: $E8D4),
    (Name: 'ContactInfo'; Value: $E779), (Name: 'ContactInfoMirrored';
    Value: $EA4A), (Name: 'ContactPresence'; Value: $E8CF),
    (Name: 'ContactSend'; Value: $E1D7), (Name: 'ContactSolid'; Value: $EA8C),
    (Name: 'Copy'; Value: $E8C8), (Name: 'CopyTo'; Value: $F413),
    (Name: 'Courthouse'; Value: $EC08), (Name: 'Crop'; Value: $E123),
    (Name: 'Crop'; Value: $E7A8), (Name: 'CtrlSpatialLeft'; Value: $F3E7),
    (Name: 'CtrlSpatialRight'; Value: $F11B), (Name: 'Cursor'; Value: $E1E3),
    (Name: 'Cut'; Value: $E8C6), (Name: 'DashKey'; Value: $E9AE),
    (Name: 'DataSense'; Value: $E791), (Name: 'DataSenseBar'; Value: $E7A5),
    (Name: 'DateTime'; Value: $EC92), (Name: 'DateTimeMirrored'; Value: $EE93),
    (Name: 'DefaultAPN'; Value: $F080), (Name: 'DefenderApp'; Value: $E83D),
    (Name: 'DefenderBadge12'; Value: $F0FB), (Name: 'Delete'; Value: $E74D),
    (Name: 'DeleteLines'; Value: $F7AF), (Name: 'DeleteLinesFill';
    Value: $F7B0), (Name: 'DeleteWord'; Value: $F7AD), (Name: 'DeleteWordFill';
    Value: $F7AE), (Name: 'DeliveryOptimization'; Value: $F785),
    (Name: 'Design'; Value: $EB3C), (Name: 'DetachablePC'; Value: $F103),
    (Name: 'DeveloperTools'; Value: $EC7A), (Name: 'DeviceDiscovery';
    Value: $EBDE), (Name: 'DeviceLaptopNoPic'; Value: $E7F8),
    (Name: 'DeviceLaptopPic'; Value: $E7F7), (Name: 'DeviceMonitorLeftPic';
    Value: $E7FA), (Name: 'DeviceMonitorNoPic'; Value: $E7FB),
    (Name: 'DeviceMonitorRightPic'; Value: $E7F9), (Name: 'Devices';
    Value: $E772), (Name: 'Devices2'; Value: $E975), (Name: 'Devices3';
    Value: $EA6C), (Name: 'Devices4'; Value: $EB66), (Name: 'DevUpdate';
    Value: $ECC5), (Name: 'Diagnostic'; Value: $E9D9), (Name: 'Dial1';
    Value: $F146), (Name: 'Dial10'; Value: $F14F), (Name: 'Dial11';
    Value: $F150), (Name: 'Dial12'; Value: $F151), (Name: 'Dial13';
    Value: $F152), (Name: 'Dial14'; Value: $F153), (Name: 'Dial15';
    Value: $F154), (Name: 'Dial16'; Value: $F155), (Name: 'Dial2';
    Value: $F147), (Name: 'Dial3'; Value: $F148), (Name: 'Dial4'; Value: $F149),
    (Name: 'Dial5'; Value: $F14A), (Name: 'Dial6'; Value: $F14B),
    (Name: 'Dial7'; Value: $F14C), (Name: 'Dial8'; Value: $F14D),
    (Name: 'Dial9'; Value: $F14E), (Name: 'Dialpad'; Value: $E75F),
    (Name: 'DialShape1'; Value: $F156), (Name: 'DialShape2'; Value: $F157),
    (Name: 'DialShape3'; Value: $F158), (Name: 'DialShape4'; Value: $F159),
    (Name: 'DialUp'; Value: $E83C), (Name: 'Diamond'; Value: $E18A),
    (Name: 'Dictionary'; Value: $E82D), (Name: 'DictionaryAdd'; Value: $E82E),
    (Name: 'DictionaryCloud'; Value: $EBC3), (Name: 'DirectAccess';
    Value: $E83B), (Name: 'Directions'; Value: $E8F0), (Name: 'DisableUpdates';
    Value: $E8D8), (Name: 'DisconnectDisplay'; Value: $EA14),
    (Name: 'DisconnectDrive'; Value: $E8CD), (Name: 'Disk'; Value: $E105),
    (Name: 'DiskDownload'; Value: $E159), (Name: 'DiskEdit'; Value: $E28F),
    (Name: 'Dislike'; Value: $E8E0), (Name: 'DMC'; Value: $E951), (Name: 'Dock';
    Value: $E952), (Name: 'DockBottom'; Value: $E90E), (Name: 'DockLeft';
    Value: $E90C), (Name: 'DockLeftMirrored'; Value: $EA4C), (Name: 'DockRight';
    Value: $E90D), (Name: 'DockRightMirrored'; Value: $EA4B), (Name: 'Document';
    Value: $E8A5), (Name: 'DotsHorizontal'; Value: $E10C),
    (Name: 'DoubleLandscape'; Value: $F615), (Name: 'DoublePinyin';
    Value: $F085), (Name: 'DoublePortrait'; Value: $F614), (Name: 'Down';
    Value: $E74B), (Name: 'Download'; Value: $E118), (Name: 'Download2';
    Value: $E896), (Name: 'DownloadMap'; Value: $E826), (Name: 'DownShiftKey';
    Value: $E84A), (Name: 'Dpad'; Value: $F10E), (Name: 'Draw'; Value: $EC87),
    (Name: 'DrawSolid'; Value: $EC88), (Name: 'DrivingMode'; Value: $E7EC),
    (Name: 'Drop'; Value: $EB42), (Name: 'DullSound'; Value: $E911),
    (Name: 'DullSoundKey'; Value: $E9AF), (Name: 'DuplexLandscapeOneSided';
    Value: $F57E), (Name: 'DuplexLandscapeOneSidedMirrored'; Value: $F57F),
    (Name: 'DuplexLandscapeTwoSidedLongEdge'; Value: $F580),
    (Name: 'DuplexLandscapeTwoSidedLongEdgeMirrored'; Value: $F581),
    (Name: 'DuplexLandscapeTwoSidedShortEdge'; Value: $F582),
    (Name: 'DuplexLandscapeTwoSidedShortEdgeMirrored'; Value: $F583),
    (Name: 'DuplexPortraitOneSided'; Value: $F584),
    (Name: 'DuplexPortraitOneSidedMirrored'; Value: $F585),
    (Name: 'DuplexPortraitTwoSidedLongEdge'; Value: $F586),
    (Name: 'DuplexPortraitTwoSidedLongEdgeMirrored'; Value: $F587),
    (Name: 'DuplexPortraitTwoSidedShortEdge'; Value: $F588),
    (Name: 'DuplexPortraitTwoSidedShortEdgeMirrored'; Value: $F589),
    (Name: 'DynamicLock'; Value: $F439), (Name: 'Ear'; Value: $F270),
    (Name: 'Earbud'; Value: $F4C0), (Name: 'EaseOfAccess'; Value: $E07F),
    (Name: 'EaseOfAccess'; Value: $E776), (Name: 'Edit'; Value: $E104),
    (Name: 'Edit2'; Value: $E70F), (Name: 'EditMirrored'; Value: $EB7E),
    (Name: 'Education'; Value: $E7BE), (Name: 'EducationIcon'; Value: $F7BB),
    (Name: 'Eject'; Value: $F847), (Name: 'Email'; Value: $E119),
    (Name: 'EmailAddress'; Value: $E168), (Name: 'EmailForward'; Value: $E120),
    (Name: 'EmailForwardRtl'; Value: $E1A8), (Name: 'EmailOpened';
    Value: $E166), (Name: 'EmailReply'; Value: $E172), (Name: 'EmailReplyAll';
    Value: $E165), (Name: 'EmailReplyAllRtl'; Value: $E1F2),
    (Name: 'EmailReplyRtl'; Value: $E1AF), (Name: 'EMI'; Value: $E731),
    (Name: 'Emoji'; Value: $E170), (Name: 'Emoji2'; Value: $E76E),
    (Name: 'Emoji2'; Value: $E899), (Name: 'EmojiGrin'; Value: $E11D),
    (Name: 'EmojiSwatch'; Value: $ED5B), (Name: 'EmojiTabCelebrationObjects';
    Value: $ED55), (Name: 'EmojiTabFavorites'; Value: $ED5A),
    (Name: 'EmojiTabFoodPlants'; Value: $ED56), (Name: 'EmojiTabMoreSymbols';
    Value: $F6BA), (Name: 'EmojiTabPeople'; Value: $ED53),
    (Name: 'EmojiTabSmilesAnimals'; Value: $ED54), (Name: 'EmojiTabSymbols';
    Value: $ED58), (Name: 'EmojiTabTextSmiles'; Value: $ED59),
    (Name: 'EmojiTabTransitPlaces'; Value: $ED57), (Name: 'EndPoint';
    Value: $E81B), (Name: 'EndPointSolid'; Value: $EB4B),
    (Name: 'EnglishPunctuation'; Value: $F110), (Name: 'Equalizer';
    Value: $E9E9), (Name: 'EraseTool'; Value: $E75C), (Name: 'EraseToolFill';
    Value: $E82B), (Name: 'EraseToolFill2'; Value: $E82C), (Name: 'Error';
    Value: $E783), (Name: 'ErrorBadge'; Value: $EA39), (Name: 'ErrorBadge12';
    Value: $EDAE), (Name: 'eSIM'; Value: $F61B), (Name: 'eSIMBusy';
    Value: $F61E), (Name: 'eSIMLocked'; Value: $F61D), (Name: 'eSIMNoProfile';
    Value: $F61C), (Name: 'Ethernet'; Value: $E839), (Name: 'EthernetError';
    Value: $EB55), (Name: 'EthernetWarning'; Value: $EB56),
    (Name: 'Exclamation'; Value: $E171), (Name: 'ExpandTile'; Value: $E976),
    (Name: 'ExpandTileMirrored'; Value: $EA4E), (Name: 'ExploitProtection';
    Value: $F8A6), (Name: 'ExploitProtectionSettings'; Value: $F259),
    (Name: 'ExploreContent'; Value: $ECCD), (Name: 'ExploreContentSingle';
    Value: $F164), (Name: 'Export'; Value: $EDE1), (Name: 'ExportMirrored';
    Value: $EDE2), (Name: 'ExpressiveInputEntry'; Value: $F6B8),
    (Name: 'Eyedropper'; Value: $EF3C), (Name: 'EyeGaze'; Value: $F19D),
    (Name: 'Family'; Value: $EBDA), (Name: 'FastForward'; Value: $EB9D),
    (Name: 'Favicon'; Value: $E737), (Name: 'Favicon2'; Value: $EC6C),
    (Name: 'FavoriteList'; Value: $E728), (Name: 'FavoriteStar'; Value: $E734),
    (Name: 'FavoriteStarFill'; Value: $E735), (Name: 'Feedback'; Value: $ED15),
    (Name: 'FeedbackApp'; Value: $E939), (Name: 'Ferry'; Value: $E7E3),
    (Name: 'FerrySolid'; Value: $EB48), (Name: 'File'; Value: $E132),
    (Name: 'FileExplorer'; Value: $EC50), (Name: 'FileExplorerApp';
    Value: $EC51), (Name: 'FileHiddenOutline'; Value: $E295),
    (Name: 'FileMultiple'; Value: $E16F), (Name: 'FileOutline'; Value: $E160),
    (Name: 'Filter'; Value: $E16E), (Name: 'Filter2'; Value: $E71C),
    (Name: 'FingerInking'; Value: $ED5F), (Name: 'Fingerprint'; Value: $E928),
    (Name: 'FitPage'; Value: $E9A6), (Name: 'Flag'; Value: $E7C1),
    (Name: 'Flashlight'; Value: $E754), (Name: 'FlickDown'; Value: $E935),
    (Name: 'FlickLeft'; Value: $E937), (Name: 'FlickRight'; Value: $E938),
    (Name: 'FlickUp'; Value: $E936), (Name: 'Flow'; Value: $EF90),
    (Name: 'Folder'; Value: $E188), (Name: 'Folder2'; Value: $E8B7),
    (Name: 'FolderFill'; Value: $E8D5), (Name: 'FolderHorizontal';
    Value: $F12B), (Name: 'FolderMove'; Value: $E19C), (Name: 'FolderOpen';
    Value: $E838), (Name: 'FolderPlus'; Value: $E1DA), (Name: 'FolderRefresh';
    Value: $E1DF), (Name: 'FolderRefreshCancel'; Value: $E1DD),
    (Name: 'FolderSelect'; Value: $F89A), (Name: 'FolderUp'; Value: $E197),
    (Name: 'Font'; Value: $E8D2), (Name: 'FontColor'; Value: $E8D3),
    (Name: 'FontDecrease'; Value: $E8E7), (Name: 'FontIncrease'; Value: $E8E8),
    (Name: 'FontSize'; Value: $E8E9), (Name: 'FormatBlockLeftDecrease';
    Value: $E290), (Name: 'FormatBlockLeftIndent'; Value: $E291),
    (Name: 'FormatBlockRightDecrease'; Value: $E297),
    (Name: 'FormatBlockRightIncrease'; Value: $E298), (Name: 'FormatBold';
    Value: $E19B), (Name: 'FormatFontSize'; Value: $E1C8),
    (Name: 'FormatFontSizeDecrease'; Value: $E1C6),
    (Name: 'FormatFontSizeIncrease'; Value: $E1C7), (Name: 'FormatTextCenter';
    Value: $E1A1), (Name: 'FormatTextLeft'; Value: $E1A2),
    (Name: 'FormatTextRight'; Value: $E1A0), (Name: 'FormatUnderline';
    Value: $E19A), (Name: 'Forward'; Value: $E72A), (Name: 'ForwardCall';
    Value: $EAC2), (Name: 'ForwardMirrored'; Value: $F0D3), (Name: 'ForwardSm';
    Value: $E9AC), (Name: 'ForwardSolidBold'; Value: $F8AD), (Name: 'FourBars';
    Value: $E908), (Name: 'FreeFormClipping'; Value: $F408), (Name: 'Frigid';
    Value: $E9CA), (Name: 'Full20'; Value: $F741), (Name: 'FullAlpha';
    Value: $E97F), (Name: 'FullCircleMask'; Value: $E91F),
    (Name: 'FullHiragana'; Value: $E986), (Name: 'FullKatakana'; Value: $E987),
    (Name: 'FullScreen'; Value: $E740), (Name: 'FuzzyReading'; Value: $F5EF),
    (Name: 'Game'; Value: $E7FC), (Name: 'GameConsole'; Value: $E967),
    (Name: 'GenericScan'; Value: $EE6F), (Name: 'GIF'; Value: $F4A9),
    (Name: 'GiftboxOpen'; Value: $F133), (Name: 'GlobalNavigationButton';
    Value: $E700), (Name: 'Globe'; Value: $E774), (Name: 'Globe2';
    Value: $F49A), (Name: 'Go'; Value: $E8AD), (Name: 'GoMirrored';
    Value: $EA4F), (Name: 'GoToMessage'; Value: $F716), (Name: 'GoToStart';
    Value: $E8FC), (Name: 'GotoToday'; Value: $E8D1), (Name: 'Gps';
    Value: $E1D2), (Name: 'GridView'; Value: $F0E2),
    (Name: 'GripperBarHorizontal'; Value: $E76F), (Name: 'GripperBarVertical';
    Value: $E784), (Name: 'GripperResize'; Value: $E788),
    (Name: 'GripperResizeMirrored'; Value: $EA50), (Name: 'GripperTool';
    Value: $E75E), (Name: 'Groceries'; Value: $EC09), (Name: 'Group';
    Value: $E902), (Name: 'GroupList'; Value: $F168), (Name: 'GuestUser';
    Value: $EE57), (Name: 'HalfAlpha'; Value: $E97E), (Name: 'HalfDullSound';
    Value: $E9B0), (Name: 'HalfKatakana'; Value: $E988), (Name: 'HalfStarLeft';
    Value: $E7C6), (Name: 'HalfStarRight'; Value: $E7C7), (Name: 'Handwriting';
    Value: $E929), (Name: 'Handwriting20'; Value: $F742), (Name: 'HangUp';
    Value: $E778), (Name: 'HardDrive'; Value: $EDA2), (Name: 'HeadlessDevice';
    Value: $F191), (Name: 'Headphone'; Value: $E7F6), (Name: 'Headphone0';
    Value: $ED30), (Name: 'Headphone1'; Value: $ED31), (Name: 'Headphone2';
    Value: $ED32), (Name: 'Headphone3'; Value: $ED33), (Name: 'Headset';
    Value: $E95B), (Name: 'Health'; Value: $E95E), (Name: 'Heart';
    Value: $EB51), (Name: 'HeartBroken'; Value: $EA92), (Name: 'HeartFill';
    Value: $EB52), (Name: 'Help'; Value: $E11B), (Name: 'Help2'; Value: $E897),
    (Name: 'HelpMirrored'; Value: $EA51), (Name: 'HideBcc'; Value: $E8C5),
    (Name: 'Highlight'; Value: $E7E6), (Name: 'HighlightFill'; Value: $E891),
    (Name: 'HighlightFill2'; Value: $E82A), (Name: 'History'; Value: $E81C),
    (Name: 'HMD'; Value: $F119), (Name: 'HolePunchLandscapeBottom';
    Value: $F597), (Name: 'HolePunchLandscapeLeft'; Value: $F594),
    (Name: 'HolePunchLandscapeRight'; Value: $F595),
    (Name: 'HolePunchLandscapeTop'; Value: $F596), (Name: 'HolePunchOff';
    Value: $F58F), (Name: 'HolePunchPortraitBottom'; Value: $F593),
    (Name: 'HolePunchPortraitLeft'; Value: $F590),
    (Name: 'HolePunchPortraitRight'; Value: $F591),
    (Name: 'HolePunchPortraitTop'; Value: $F592), (Name: 'HoloLensSelected';
    Value: $F4BF), (Name: 'Home'; Value: $E80F), (Name: 'HomeGroup';
    Value: $EC26), (Name: 'HomeOutline'; Value: $E10F), (Name: 'HomeSolid';
    Value: $EA8A), (Name: 'HomeTree'; Value: $E1C3), (Name: 'HorizontalTabKey';
    Value: $E7FD), (Name: 'HWPInsert'; Value: $F461), (Name: 'HWPJoin';
    Value: $F460), (Name: 'HWPNewLine'; Value: $F465), (Name: 'HWPOverwrite';
    Value: $F466), (Name: 'HWPScratchOut'; Value: $F463), (Name: 'HWPSplit';
    Value: $F464), (Name: 'HWPStrikeThrough'; Value: $F462), (Name: 'IBeam';
    Value: $E933), (Name: 'IBeamOutline'; Value: $E934),
    (Name: 'idebarRightExpand'; Value: $E127), (Name: 'ImageExport';
    Value: $EE71), (Name: 'Import'; Value: $E8B5), (Name: 'ImportAll';
    Value: $E8B6), (Name: 'ImportAllMirrored'; Value: $EA53),
    (Name: 'Important'; Value: $E8C9), (Name: 'ImportantBadge12'; Value: $EDB1),
    (Name: 'ImportMirrored'; Value: $EA52), (Name: 'IncidentTriangle';
    Value: $E814), (Name: 'IncomingCall'; Value: $E77E), (Name: 'Info';
    Value: $E946), (Name: 'Info2'; Value: $EA1F), (Name: 'InfoSolid';
    Value: $F167), (Name: 'InkingCaret'; Value: $ED65),
    (Name: 'InkingColorFill'; Value: $ED67), (Name: 'InkingColorOutline';
    Value: $ED66), (Name: 'InkingTool'; Value: $E76D), (Name: 'InkingToolFill';
    Value: $E88F), (Name: 'InkingToolFill2'; Value: $E829), (Name: 'InPrivate';
    Value: $E727), (Name: 'Input'; Value: $E961), (Name: 'InputMarker';
    Value: $E193), (Name: 'InsiderHubApp'; Value: $EC24), (Name: 'InstertWords';
    Value: $F7B1), (Name: 'InstertWordsFill'; Value: $F7B2),
    (Name: 'InteractiveDashboard'; Value: $F404), (Name: 'InternetSharing';
    Value: $E704), (Name: 'IOT'; Value: $F22C), (Name: 'Italic'; Value: $E8DB),
    (Name: 'Japanese'; Value: $E985), (Name: 'JoinWords'; Value: $F7B3),
    (Name: 'JoinWordsFill'; Value: $F7B4), (Name: 'JpnRomanji'; Value: $E87C),
    (Name: 'JpnRomanjiLock'; Value: $E87D), (Name: 'JpnRomanjiShift';
    Value: $E87E), (Name: 'JpnRomanjiShiftLock'; Value: $E87F), (Name: 'Key';
    Value: $E192), (Name: 'Key12On'; Value: $E980), (Name: 'Keyboard';
    Value: $E087), (Name: 'Keyboard12Key'; Value: $F261),
    (Name: 'KeyboardBrightness'; Value: $ED39), (Name: 'KeyboardClassic';
    Value: $E765), (Name: 'KeyboardDismiss'; Value: $E92F),
    (Name: 'KeyboardDock'; Value: $F26B), (Name: 'KeyboardFull'; Value: $EC31),
    (Name: 'KeyboardLeftAligned'; Value: $F20C), (Name: 'KeyboardLeftDock';
    Value: $F26D), (Name: 'KeyboardLeftHanded'; Value: $E763),
    (Name: 'KeyboardLowerBrightness'; Value: $ED3A), (Name: 'KeyboardNarrow';
    Value: $F260), (Name: 'KeyboardOneHanded'; Value: $ED4C),
    (Name: 'KeyboardRightAligned'; Value: $F20D), (Name: 'KeyboardRightDock';
    Value: $F26E), (Name: 'KeyboardRightHanded'; Value: $E764),
    (Name: 'KeyboardSettings'; Value: $F210), (Name: 'Keyboardsettings20';
    Value: $F73D), (Name: 'KeyboardShortcut'; Value: $EDA7),
    (Name: 'KeyboardSplit'; Value: $E08F), (Name: 'KeyboardSplit2';
    Value: $E766), (Name: 'KeyboardStandard'; Value: $E92E),
    (Name: 'KeyboardUndock'; Value: $F26C), (Name: 'Kiosk'; Value: $F712),
    (Name: 'KnowledgeArticle'; Value: $F000), (Name: 'Korean'; Value: $E97D),
    (Name: 'Label'; Value: $E932), (Name: 'LandscapeOrientation'; Value: $EF6B),
    (Name: 'LandscapeOrientationMirrored'; Value: $F56F), (Name: 'LangJPN';
    Value: $E7DE), (Name: 'LanguageChs'; Value: $E88D), (Name: 'LanguageCht';
    Value: $E88C), (Name: 'LanguageJpn'; Value: $EC45), (Name: 'LanguageKor';
    Value: $E88B), (Name: 'LaptopSecure'; Value: $F552),
    (Name: 'LaptopSelected'; Value: $EC76), (Name: 'LaptopTablet';
    Value: $E212), (Name: 'LargeErase'; Value: $F12A), (Name: 'Leaf';
    Value: $E8BE), (Name: 'LeaveChat'; Value: $E89B),
    (Name: 'LeaveChatMirrored'; Value: $EA54), (Name: 'LEDLight'; Value: $E781),
    (Name: 'LeftArrowKeyTime0'; Value: $EC52), (Name: 'LeftDoubleQuote';
    Value: $E9B2), (Name: 'LeftQuote'; Value: $E848), (Name: 'LeftStick';
    Value: $F108), (Name: 'Lexicon'; Value: $F180), (Name: 'Library';
    Value: $E8F1), (Name: 'Light'; Value: $E793), (Name: 'Lightbulb';
    Value: $EA80), (Name: 'LightningBolt'; Value: $E945), (Name: 'Like';
    Value: $E8E1), (Name: 'LikeDislike'; Value: $E8DF), (Name: 'LineDisplay';
    Value: $EF3D), (Name: 'LineHorizontal'; Value: $E0B8), (Name: 'Link';
    Value: $E71B), (Name: 'List'; Value: $E292), (Name: 'List2'; Value: $EA37),
    (Name: 'ListBlock'; Value: $E15C), (Name: 'ListCollapse'; Value: $E16A),
    (Name: 'ListExpand'; Value: $E169), (Name: 'ListMirrored'; Value: $EA55),
    (Name: 'ListRtl'; Value: $E175), (Name: 'ListSelect'; Value: $E179),
    (Name: 'ListSelectRtl'; Value: $E1EC), (Name: 'ListSelectUp'; Value: $E17D),
    (Name: 'ListSelectUpRtl'; Value: $E1ED), (Name: 'LocaleLanguage';
    Value: $F2B7), (Name: 'Location'; Value: $E81D), (Name: 'Lock';
    Value: $E72E), (Name: 'LockFeedback'; Value: $EBDB),
    (Name: 'LockscreenDesktop'; Value: $EE3F), (Name: 'LockScreenGlance';
    Value: $EE65), (Name: 'LowerBrightness'; Value: $EC8A), (Name: 'Magnify';
    Value: $E1A3), (Name: 'MagnifyMinus'; Value: $E1A4), (Name: 'MagnifyPlus';
    Value: $E12E), (Name: 'MagStripeReader'; Value: $EC5C), (Name: 'Mail';
    Value: $E715), (Name: 'MailBadge12'; Value: $EDB3), (Name: 'MailFill';
    Value: $E8A8), (Name: 'MailForward'; Value: $E89C),
    (Name: 'MailForwardMirrored'; Value: $EA56), (Name: 'MailReply';
    Value: $E8CA), (Name: 'MailReplyAll'; Value: $E8C2),
    (Name: 'MailReplyAllMirrored'; Value: $EA58), (Name: 'MailReplyMirrored';
    Value: $EA57), (Name: 'Manage'; Value: $E912), (Name: 'MapCompassBottom';
    Value: $E813), (Name: 'MapCompassTop'; Value: $E812),
    (Name: 'MapDirections'; Value: $E816), (Name: 'MapDrive'; Value: $E8CE),
    (Name: 'MapLayers'; Value: $E81E), (Name: 'MapLocation'; Value: $E1C4),
    (Name: 'MapPin'; Value: $E139), (Name: 'MapPin2'; Value: $E7B7),
    (Name: 'MapPin2'; Value: $E707), (Name: 'Marker'; Value: $ED64),
    (Name: 'Market'; Value: $EAFC), (Name: 'Marquee'; Value: $EF20),
    (Name: 'Media'; Value: $EA69), (Name: 'MediaNext'; Value: $E101),
    (Name: 'MediaPause'; Value: $E103), (Name: 'MediaPlay'; Value: $E102),
    (Name: 'MediaPrevious'; Value: $E100), (Name: 'MediaProcessing';
    Value: $E25C), (Name: 'MediaRepeat'; Value: $E1CA),
    (Name: 'MediaStorageTower'; Value: $E965), (Name: 'Megaphone';
    Value: $E789), (Name: 'Memo'; Value: $E77C), (Name: 'MergeCall';
    Value: $EA3C), (Name: 'Message'; Value: $E8BD), (Name: 'MessageQuote';
    Value: $E134), (Name: 'MessageVideo'; Value: $E13B), (Name: 'MicClipping';
    Value: $EC72), (Name: 'MicError'; Value: $EC56), (Name: 'MicOff';
    Value: $EC54), (Name: 'MicOff2'; Value: $F781), (Name: 'MicOn';
    Value: $EC71), (Name: 'Microphone'; Value: $E720),
    (Name: 'MicrophoneListening'; Value: $F12E), (Name: 'MicrophoneSolidBold';
    Value: $F8B1), (Name: 'MicSleep'; Value: $EC55),
    (Name: 'MiniContract2Mirrored'; Value: $EE49), (Name: 'MiniExpand2Mirrored';
    Value: $EE47), (Name: 'Minus'; Value: $E108), (Name: 'MiracastLogoLarge';
    Value: $EC16), (Name: 'MiracastLogoSmall'; Value: $EC15),
    (Name: 'MixedMediaBadge'; Value: $EA0D), (Name: 'MixVolumes'; Value: $F4C3),
    (Name: 'MobActionCenter'; Value: $EC42), (Name: 'MobAirplane';
    Value: $EC40), (Name: 'MobBattery0'; Value: $EBA0), (Name: 'MobBattery1';
    Value: $EBA1), (Name: 'MobBattery10'; Value: $EBAA), (Name: 'MobBattery2';
    Value: $EBA2), (Name: 'MobBattery3'; Value: $EBA3), (Name: 'MobBattery4';
    Value: $EBA4), (Name: 'MobBattery5'; Value: $EBA5), (Name: 'MobBattery6';
    Value: $EBA6), (Name: 'MobBattery7'; Value: $EBA7), (Name: 'MobBattery8';
    Value: $EBA8), (Name: 'MobBattery9'; Value: $EBA9),
    (Name: 'MobBatteryCharging0'; Value: $EBAB), (Name: 'MobBatteryCharging1';
    Value: $EBAC), (Name: 'MobBatteryCharging10'; Value: $EBB5),
    (Name: 'MobBatteryCharging2'; Value: $EBAD), (Name: 'MobBatteryCharging3';
    Value: $EBAE), (Name: 'MobBatteryCharging4'; Value: $EBAF),
    (Name: 'MobBatteryCharging5'; Value: $EBB0), (Name: 'MobBatteryCharging6';
    Value: $EBB1), (Name: 'MobBatteryCharging7'; Value: $EBB2),
    (Name: 'MobBatteryCharging8'; Value: $EBB3), (Name: 'MobBatteryCharging9';
    Value: $EBB4), (Name: 'MobBatterySaver0'; Value: $EBB6),
    (Name: 'MobBatterySaver1'; Value: $EBB7), (Name: 'MobBatterySaver10';
    Value: $EBC0), (Name: 'MobBatterySaver2'; Value: $EBB8),
    (Name: 'MobBatterySaver3'; Value: $EBB9), (Name: 'MobBatterySaver4';
    Value: $EBBA), (Name: 'MobBatterySaver5'; Value: $EBBB),
    (Name: 'MobBatterySaver6'; Value: $EBBC), (Name: 'MobBatterySaver7';
    Value: $EBBD), (Name: 'MobBatterySaver8'; Value: $EBBE),
    (Name: 'MobBatterySaver9'; Value: $EBBF), (Name: 'MobBatteryUnknown';
    Value: $EC02), (Name: 'MobBluetooth'; Value: $EC41),
    (Name: 'MobCallForwarding'; Value: $EC7E),
    (Name: 'MobCallForwardingMirrored'; Value: $EC7F), (Name: 'MobDrivingMode';
    Value: $EC47), (Name: 'MobeSIM'; Value: $ED2A), (Name: 'MobeSIMBusy';
    Value: $ED2D), (Name: 'MobeSIMLocked'; Value: $ED2C),
    (Name: 'MobeSIMNoProfile'; Value: $ED2B), (Name: 'MobileLocked';
    Value: $EC20), (Name: 'MobileSelected'; Value: $EC75),
    (Name: 'MobileTablet'; Value: $E8CC), (Name: 'MobLocation'; Value: $EC43),
    (Name: 'MobQuietHours'; Value: $EC46), (Name: 'MobSignal1'; Value: $EC37),
    (Name: 'MobSignal2'; Value: $EC38), (Name: 'MobSignal3'; Value: $EC39),
    (Name: 'MobSignal4'; Value: $EC3A), (Name: 'MobSignal5'; Value: $EC3B),
    (Name: 'MobSIMError'; Value: $F5AB), (Name: 'MobSIMLock'; Value: $E875),
    (Name: 'MobSIMMissing'; Value: $E876), (Name: 'MobWifi1'; Value: $EC3C),
    (Name: 'MobWifi2'; Value: $EC3D), (Name: 'MobWifi3'; Value: $EC3E),
    (Name: 'MobWifi4'; Value: $EC3F), (Name: 'MobWifiHotspot'; Value: $EC44),
    (Name: 'MobWifiWarning1'; Value: $F473), (Name: 'MobWifiWarning2';
    Value: $F474), (Name: 'MobWifiWarning3'; Value: $F475),
    (Name: 'MobWifiWarning4'; Value: $F476), (Name: 'More'; Value: $E712),
    (Name: 'Mouse'; Value: $E962), (Name: 'MoveToFolder'; Value: $E8DE),
    (Name: 'Movies'; Value: $E8B2), (Name: 'MultimediaDMP'; Value: $ED47),
    (Name: 'MultimediaDMS'; Value: $E953), (Name: 'MultimediaDVR';
    Value: $E954), (Name: 'MultimediaPMP'; Value: $E955), (Name: 'MultiSelect';
    Value: $E762), (Name: 'MultiSelectMirrored'; Value: $EA98), (Name: 'Music';
    Value: $E189), (Name: 'MusicAlbum'; Value: $E93C), (Name: 'MusicInfo';
    Value: $E90B), (Name: 'MusicNote'; Value: $EC4F), (Name: 'MusicSharing';
    Value: $F623), (Name: 'MusicSharingOff'; Value: $F624), (Name: 'Mute';
    Value: $E74F), (Name: 'MyNetwork'; Value: $EC27), (Name: 'Narrator';
    Value: $ED4D), (Name: 'NarratorApp'; Value: $F83B),
    (Name: 'NarratorForward'; Value: $EDA9), (Name: 'NarratorForwardMirrored';
    Value: $EDAA), (Name: 'NearbySharing'; Value: $F3E2), (Name: 'Network';
    Value: $E17B), (Name: 'Network2'; Value: $E968), (Name: 'NetworkAdapter';
    Value: $EDA3), (Name: 'NetworkConnected'; Value: $F385),
    (Name: 'NetworkConnectedCheckmark'; Value: $F386), (Name: 'NetworkiClose';
    Value: $E17A), (Name: 'NetworkOffline'; Value: $F384),
    (Name: 'NetworkPhysical'; Value: $F211), (Name: 'NetworkPrinter';
    Value: $EDA5), (Name: 'NetworkSharing'; Value: $F193),
    (Name: 'NetworkTower'; Value: $EC05), (Name: 'NewFolder'; Value: $E8F4),
    (Name: 'NewWindow'; Value: $E78B), (Name: 'Next'; Value: $E893),
    (Name: 'NoiseCancelation'; Value: $F61F), (Name: 'NoiseCancelationOff';
    Value: $F620), (Name: 'NUIFace'; Value: $EB68),
    (Name: 'NUIFPContinueSlideAction'; Value: $EB85),
    (Name: 'NUIFPContinueSlideHand'; Value: $EB84), (Name: 'NUIFPPressAction';
    Value: $EB8B), (Name: 'NUIFPPressHand'; Value: $EB8A),
    (Name: 'NUIFPPressRepeatAction'; Value: $EB8D),
    (Name: 'NUIFPPressRepeatHand'; Value: $EB8C), (Name: 'NUIFPRollLeftAction';
    Value: $EB89), (Name: 'NUIFPRollLeftHand'; Value: $EB88),
    (Name: 'NUIFPRollRightHand'; Value: $EB86),
    (Name: 'NUIFPRollRightHandAction'; Value: $EB87),
    (Name: 'NUIFPStartSlideAction'; Value: $EB83), (Name: 'NUIFPStartSlideHand';
    Value: $EB82), (Name: 'NUIIris'; Value: $EB67), (Name: 'OEM'; Value: $E74C),
    (Name: 'OneBar'; Value: $E905), (Name: 'OneHandedLeft20'; Value: $F73F),
    (Name: 'OneHandedRight20'; Value: $F73E), (Name: 'OpenFile'; Value: $E8E5),
    (Name: 'OpenFolderHorizontal'; Value: $ED25), (Name: 'OpenInApp';
    Value: $E17C), (Name: 'OpenInNewWindow'; Value: $E8A7), (Name: 'OpenLocal';
    Value: $E8DA), (Name: 'OpenPane'; Value: $E8A0), (Name: 'OpenPaneMirrored';
    Value: $EA5B), (Name: 'OpenWith'; Value: $E7AC), (Name: 'OpenWithMirrored';
    Value: $EA5C), (Name: 'Orientation'; Value: $E8B4), (Name: 'OtherUser';
    Value: $E7EE), (Name: 'Outline'; Value: $E12F),
    (Name: 'OutlineHalfStarLeft'; Value: $F0E7), (Name: 'OutlineHalfStarRight';
    Value: $F0E8), (Name: 'OutlineQuarterStarLeft'; Value: $F0E5),
    (Name: 'OutlineQuarterStarRight'; Value: $F0E6),
    (Name: 'OutlineStarLeftHalf'; Value: $F0F7), (Name: 'OutlineStarRightHalf';
    Value: $F0F8), (Name: 'OutlineThreeQuarterStarLeft'; Value: $F0E9),
    (Name: 'OutlineThreeQuarterStarRight'; Value: $F0EA),
    (Name: 'OverwriteWords'; Value: $F7B5), (Name: 'OverwriteWordsFill';
    Value: $F7B6), (Name: 'OverwriteWordsFillKorean'; Value: $F7BA),
    (Name: 'OverwriteWordsKorean'; Value: $F7B9), (Name: 'Package';
    Value: $E7B8), (Name: 'Page'; Value: $E7C3), (Name: 'PageLeft';
    Value: $E760), (Name: 'PageMarginLandscapeModerate'; Value: $F579),
    (Name: 'PageMarginLandscapeNarrow'; Value: $F577),
    (Name: 'PageMarginLandscapeNormal'; Value: $F578),
    (Name: 'PageMarginLandscapeWide'; Value: $F57A),
    (Name: 'PageMarginPortraitModerate'; Value: $F575),
    (Name: 'PageMarginPortraitNarrow'; Value: $F573),
    (Name: 'PageMarginPortraitNormal'; Value: $F574),
    (Name: 'PageMarginPortraitWide'; Value: $F576), (Name: 'PageMirrored';
    Value: $F56E), (Name: 'PageRight'; Value: $E761), (Name: 'PageSolid';
    Value: $E729), (Name: 'PaginationDotOutline10'; Value: $F126),
    (Name: 'PaginationDotSolid10'; Value: $F127), (Name: 'Palette';
    Value: $E2B1), (Name: 'PanelBottom'; Value: $E147), (Name: 'PanelLeft';
    Value: $E145), (Name: 'PanelRight'; Value: $E146), (Name: 'PanMode';
    Value: $ECE9), (Name: 'ParkingLocation'; Value: $E811),
    (Name: 'ParkingLocationMirrored'; Value: $EA5E),
    (Name: 'ParkingLocationSolid'; Value: $EA8B), (Name: 'PartyLeader';
    Value: $ECA7), (Name: 'PassiveAuthentication'; Value: $F32A),
    (Name: 'PasswordKeyHide'; Value: $E9A9), (Name: 'PasswordKeyShow';
    Value: $E9A8), (Name: 'Paste'; Value: $E77F), (Name: 'Pause'; Value: $E769),
    (Name: 'PauseBadge12'; Value: $EDB4), (Name: 'PauseBold'; Value: $F8AE),
    (Name: 'PaymentCard'; Value: $E8C7), (Name: 'PC1'; Value: $E977),
    (Name: 'PDF'; Value: $EA90), (Name: 'Pencil'; Value: $ED63),
    (Name: 'PencilFill'; Value: $F0C6), (Name: 'PenPalette'; Value: $EE56),
    (Name: 'PenPaletteMirrored'; Value: $EF16), (Name: 'PenTips'; Value: $F45E),
    (Name: 'PenTipsMirrored'; Value: $F45F), (Name: 'PenWorkspace';
    Value: $EDC6), (Name: 'PenWorkspaceMirrored'; Value: $EF15),
    (Name: 'People'; Value: $E716), (Name: 'PeriodKey'; Value: $E843),
    (Name: 'Permissions'; Value: $E8D7), (Name: 'PersonalFolder'; Value: $EC25),
    (Name: 'Personalize'; Value: $E771), (Name: 'Phone'; Value: $E717),
    (Name: 'PhoneBook'; Value: $E780), (Name: 'PhoneBook'; Value: $E1D4),
    (Name: 'PhoneHangup'; Value: $E137), (Name: 'Photo'; Value: $E91B),
    (Name: 'Photo2'; Value: $EB9F), (Name: 'Picture'; Value: $E8B9),
    (Name: 'PieSingle'; Value: $EB05), (Name: 'Pin'; Value: $E718),
    (Name: 'PinFill'; Value: $E841), (Name: 'PinLeft'; Value: $E141),
    (Name: 'Pinned'; Value: $E840), (Name: 'PinnedFill'; Value: $E842),
    (Name: 'PINPad'; Value: $EF3E), (Name: 'PinyinIMELogo'; Value: $EDE5),
    (Name: 'PLAP'; Value: $EC19), (Name: 'Play'; Value: $E768), (Name: 'Play36';
    Value: $EE4A), (Name: 'PlaybackRate1x'; Value: $EC57),
    (Name: 'PlaybackRateOther'; Value: $EC58), (Name: 'PlayBadge12';
    Value: $EDB5), (Name: 'PlayerSettings'; Value: $EF58), (Name: 'PlaySolid';
    Value: $F5B0), (Name: 'Plus'; Value: $E109), (Name: 'PointErase';
    Value: $ED61), (Name: 'PointEraseMirrored'; Value: $EF18),
    (Name: 'PointerHand'; Value: $F271), (Name: 'PoliceCar'; Value: $EC81),
    (Name: 'PostUpdate'; Value: $E8F3), (Name: 'PowerButton'; Value: $E7E8),
    (Name: 'PowerButtonUpdate'; Value: $F83D), (Name: 'PPSFourLandscape';
    Value: $F58D), (Name: 'PPSFourPortrait'; Value: $F58E),
    (Name: 'PPSOneLandscape'; Value: $F58A), (Name: 'PPSOnePortrait';
    Value: $F5AD), (Name: 'PPSTwoLandscape'; Value: $F58B),
    (Name: 'PPSTwoPortrait'; Value: $F58C), (Name: 'PresenceChicklet';
    Value: $E978), (Name: 'PresenceChickletVideo'; Value: $E979),
    (Name: 'Preview'; Value: $E8FF), (Name: 'PreviewLink'; Value: $E8A1),
    (Name: 'Previous'; Value: $E892), (Name: 'Print'; Value: $E749),
    (Name: 'PrintAllPages'; Value: $F571), (Name: 'PrintCustomRange';
    Value: $F572), (Name: 'PrintDefault'; Value: $F56D), (Name: 'Printer';
    Value: $E2F6), (Name: 'Printer3D'; Value: $E2F7), (Name: 'Printer3D2';
    Value: $E914), (Name: 'PrintfaxPrinterFile'; Value: $E956),
    (Name: 'Priority'; Value: $E8D0), (Name: 'PrivateCall'; Value: $EA3D),
    (Name: 'Process'; Value: $E9F3), (Name: 'Processing'; Value: $E9F5),
    (Name: 'ProductivityMode'; Value: $F71E), (Name: 'ProgressRingDots';
    Value: $F16A), (Name: 'Project'; Value: $EBC6), (Name: 'Projector';
    Value: $E95D), (Name: 'ProtectedDocument'; Value: $E8A6),
    (Name: 'Protractor'; Value: $F0B4), (Name: 'ProvisioningPackage';
    Value: $E835), (Name: 'PuncKey'; Value: $E844), (Name: 'PuncKey0';
    Value: $E84C), (Name: 'PuncKey1'; Value: $E9B4), (Name: 'PuncKey2';
    Value: $E9B5), (Name: 'PuncKey3'; Value: $E9B6), (Name: 'PuncKey4';
    Value: $E9B7), (Name: 'PuncKey5'; Value: $E9B8), (Name: 'PuncKey6';
    Value: $E9B9), (Name: 'PuncKey7'; Value: $E9BB), (Name: 'PuncKey8';
    Value: $E9BC), (Name: 'PuncKey9'; Value: $E9BA), (Name: 'PuncKeyLeftBottom';
    Value: $E84D), (Name: 'PuncKeyRightBottom'; Value: $E9B3), (Name: 'Puzzle';
    Value: $EA86), (Name: 'QRCode'; Value: $ED14), (Name: 'QuarentinedItems';
    Value: $F0B2), (Name: 'QuarentinedItemsMirrored'; Value: $F0B3),
    (Name: 'QuarterStarLeft'; Value: $F0CA), (Name: 'QuarterStarRight';
    Value: $F0CB), (Name: 'QuickNote'; Value: $E70B), (Name: 'QuietHours';
    Value: $E708), (Name: 'QuietHoursBadge12'; Value: $F0CE),
    (Name: 'QWERTYOff'; Value: $E983), (Name: 'QWERTYOn'; Value: $E982),
    (Name: 'Radar'; Value: $EB44), (Name: 'RadioBtnOff'; Value: $ECCA),
    (Name: 'RadioBtnOn'; Value: $ECCB), (Name: 'RadioBullet'; Value: $E915),
    (Name: 'RadioBullet2'; Value: $ECCC), (Name: 'Read'; Value: $E8C3),
    (Name: 'ReadingList'; Value: $E7BC), (Name: 'ReadingMode'; Value: $E736),
    (Name: 'ReceiptPrinter'; Value: $EC5B), (Name: 'Recent'; Value: $E823),
    (Name: 'Record'; Value: $E7C8), (Name: 'Record2'; Value: $EA3F),
    (Name: 'RectangularClipping'; Value: $F407), (Name: 'RedEye'; Value: $E7B3),
    (Name: 'Redo'; Value: $E7A6), (Name: 'Redo'; Value: $E10D),
    (Name: 'Refresh'; Value: $E117), (Name: 'Refresh2'; Value: $E72C),
    (Name: 'Relationship'; Value: $F003), (Name: 'RememberedDevice';
    Value: $E70C), (Name: 'Reminder'; Value: $EB50), (Name: 'ReminderFill';
    Value: $EB4F), (Name: 'Remote'; Value: $E8AF), (Name: 'Remove';
    Value: $E738), (Name: 'RemoveFrom'; Value: $ECC9), (Name: 'Rename';
    Value: $E8AC), (Name: 'Repair'; Value: $E90F), (Name: 'Repeat';
    Value: $E1CD), (Name: 'RepeatAll'; Value: $E8EE), (Name: 'RepeatOff';
    Value: $F5E7), (Name: 'RepeatOnce'; Value: $E1CC), (Name: 'RepeatOne';
    Value: $E8ED), (Name: 'Replay'; Value: $EF3B), (Name: 'Reply';
    Value: $E97A), (Name: 'ReplyMirrored'; Value: $EE35),
    (Name: 'ReportDocument'; Value: $E9F9), (Name: 'ReportHacked';
    Value: $E730), (Name: 'ResetDevice'; Value: $ED10), (Name: 'ResetDrive';
    Value: $EBC4), (Name: 'Reshare'; Value: $E8EB), (Name: 'ResizeMouseLarge';
    Value: $E747), (Name: 'ResizeMouseMedium'; Value: $E744),
    (Name: 'ResizeMouseMediumMirrored'; Value: $EA5F),
    (Name: 'ResizeMouseSmall'; Value: $E743), (Name: 'ResizeMouseSmallMirrored';
    Value: $EA60), (Name: 'ResizeMouseTall'; Value: $E746),
    (Name: 'ResizeMouseTallMirrored'; Value: $EA61), (Name: 'ResizeMouseWide';
    Value: $E745), (Name: 'ResizeTouchLarger'; Value: $E741),
    (Name: 'ResizeTouchNarrower'; Value: $E7EA),
    (Name: 'ResizeTouchNarrowerMirrored'; Value: $EA62),
    (Name: 'ResizeTouchShorter'; Value: $E7EB), (Name: 'ResizeTouchSmaller';
    Value: $E742), (Name: 'RestartUpdate'; Value: $F83E), (Name: 'ReturnKey';
    Value: $E751), (Name: 'ReturnKeyLg'; Value: $EB97), (Name: 'ReturnKeySm';
    Value: $E966), (Name: 'ReturnToCall'; Value: $F71A),
    (Name: 'ReturnToWindow'; Value: $E944), (Name: 'RevealPasswordMedium';
    Value: $F78D), (Name: 'RevToggleKey'; Value: $E845), (Name: 'Rewind';
    Value: $EB9E), (Name: 'RightArrowKeyTime0'; Value: $EBE7),
    (Name: 'RightArrowKeyTime1'; Value: $E846), (Name: 'RightArrowKeyTime2';
    Value: $E847), (Name: 'RightArrowKeyTime3'; Value: $E84E),
    (Name: 'RightArrowKeyTime4'; Value: $E84F), (Name: 'RightDoubleQuote';
    Value: $E9B1), (Name: 'RightQuote'; Value: $E849), (Name: 'RightStick';
    Value: $F109), (Name: 'Ringer'; Value: $EA8F), (Name: 'RingerBadge12';
    Value: $EDAC), (Name: 'RingerSilent'; Value: $E7ED),
    (Name: 'RoamingDomestic'; Value: $E879), (Name: 'RoamingInternational';
    Value: $E878), (Name: 'Robot'; Value: $E99A), (Name: 'Rotate';
    Value: $E7AD), (Name: 'RotateCamera'; Value: $E89E), (Name: 'RotateLeft';
    Value: $E14F), (Name: 'RotateMapLeft'; Value: $E80D),
    (Name: 'RotateMapRight'; Value: $E80C), (Name: 'RotationLock';
    Value: $E755), (Name: 'RTTLogo'; Value: $F714), (Name: 'Ruler';
    Value: $ED5E), (Name: 'Safe'; Value: $F540), (Name: 'Save'; Value: $E74E),
    (Name: 'SaveAs'; Value: $E792), (Name: 'SaveCopy'; Value: $EA35),
    (Name: 'SaveLocal'; Value: $E78C), (Name: 'Scan'; Value: $E8FE),
    (Name: 'ScreenTime'; Value: $F182), (Name: 'ScrollMode'; Value: $ECE7),
    (Name: 'ScrollUpDown'; Value: $EC8F), (Name: 'SDCard'; Value: $E7F1),
    (Name: 'Search'; Value: $E094), (Name: 'Search2'; Value: $E721),
    (Name: 'SearchAndApps'; Value: $E773), (Name: 'SearchMedium'; Value: $F78B),
    (Name: 'SectionRedo'; Value: $E1F4), (Name: 'SectionUndo'; Value: $E1C5),
    (Name: 'SecurityAlert'; Value: $E1DE), (Name: 'SelectAll'; Value: $E8B3),
    (Name: 'Send'; Value: $E724), (Name: 'SendFill'; Value: $E725),
    (Name: 'SendFillMirrored'; Value: $EA64), (Name: 'SendMirrored';
    Value: $EA63), (Name: 'Sensor'; Value: $E957), (Name: 'Set'; Value: $F5ED),
    (Name: 'SetHistoryStatus'; Value: $F738), (Name: 'SetHistoryStatus2';
    Value: $F739), (Name: 'SetlockScreen'; Value: $E7B5), (Name: 'SetSolid';
    Value: $F5EE), (Name: 'SetTile'; Value: $E97B), (Name: 'Setting';
    Value: $E713), (Name: 'SettingsBattery'; Value: $EE63),
    (Name: 'SettingsDisplaySound'; Value: $E7F3), (Name: 'SettingsSolid';
    Value: $F8B0), (Name: 'Share'; Value: $E72D), (Name: 'ShareBroadband';
    Value: $E83A), (Name: 'Shield'; Value: $EA18), (Name: 'Shop'; Value: $E719),
    (Name: 'ShoppingCart'; Value: $E7BF), (Name: 'ShowBcc'; Value: $E8C4),
    (Name: 'ShowResults'; Value: $E8BC), (Name: 'ShowResultsMirrored';
    Value: $EA65), (Name: 'Shuffle'; Value: $E14B), (Name: 'Shuffle';
    Value: $E8B1), (Name: 'SidebarLeftCollapse'; Value: $E1BF),
    (Name: 'SidebarLeftExpand'; Value: $E1C0), (Name: 'SidebarRightCollapse';
    Value: $E126), (Name: 'SignalBars1'; Value: $E86C), (Name: 'SignalBars2';
    Value: $E86D), (Name: 'SignalBars3'; Value: $E86E), (Name: 'SignalBars4';
    Value: $E86F), (Name: 'SignalBars5'; Value: $E870), (Name: 'SignalError';
    Value: $ED2E), (Name: 'SignalNotConnected'; Value: $E871),
    (Name: 'SignalRoaming'; Value: $EC1E), (Name: 'SignatureCapture';
    Value: $EF3F), (Name: 'SignOut'; Value: $F3B1), (Name: 'SIMError';
    Value: $F618), (Name: 'SIMLock'; Value: $F61A), (Name: 'SIMMissing';
    Value: $F619), (Name: 'SingleLandscape'; Value: $F617),
    (Name: 'SinglePortrait'; Value: $F616), (Name: 'SIPMove'; Value: $E759),
    (Name: 'SIPRedock'; Value: $E75B), (Name: 'SIPUndock'; Value: $E75A),
    (Name: 'SkipBack10'; Value: $ED3C), (Name: 'SkipForward30'; Value: $ED3D),
    (Name: 'SlashForward'; Value: $E199), (Name: 'SliderThumb'; Value: $EC13),
    (Name: 'Slideshow'; Value: $E786), (Name: 'SlowMotionOn'; Value: $EA79),
    (Name: 'SmallErase'; Value: $F129), (Name: 'Smartcard'; Value: $E963),
    (Name: 'SmartcardVirtual'; Value: $E964), (Name: 'SmartScreen';
    Value: $F8A5), (Name: 'Sort'; Value: $E8CB), (Name: 'Sound'; Value: $E15D),
    (Name: 'SoundCancel'; Value: $E198), (Name: 'SpatialVolume0'; Value: $F0EB),
    (Name: 'SpatialVolume1'; Value: $F0EC), (Name: 'SpatialVolume2';
    Value: $F0ED), (Name: 'SpatialVolume3'; Value: $F0EE), (Name: 'Speakers';
    Value: $E7F5), (Name: 'SpecialEffectSize'; Value: $F4A5), (Name: 'Speech';
    Value: $EFA9), (Name: 'SpeechSolidBold'; Value: $F8B2), (Name: 'SpeedHigh';
    Value: $EC4A), (Name: 'SpeedMedium'; Value: $EC49), (Name: 'SpeedOff';
    Value: $EC48), (Name: 'Spelling'; Value: $F87B), (Name: 'SpellingChinese';
    Value: $F87E), (Name: 'SpellingKorean'; Value: $F87C),
    (Name: 'SpellingSerbian'; Value: $F87D), (Name: 'Split20'; Value: $F740),
    (Name: 'StaplingLandscapeBookBinding'; Value: $F5A9),
    (Name: 'StaplingLandscapeBottomLeft'; Value: $F5A3),
    (Name: 'StaplingLandscapeBottomRight'; Value: $F5A4),
    (Name: 'StaplingLandscapeTopLeft'; Value: $F5A1),
    (Name: 'StaplingLandscapeTopRight'; Value: $F5A2),
    (Name: 'StaplingLandscapeTwoBottom'; Value: $F5A8),
    (Name: 'StaplingLandscapeTwoLeft'; Value: $F5A5),
    (Name: 'StaplingLandscapeTwoRight'; Value: $F5A6),
    (Name: 'StaplingLandscapeTwoTop'; Value: $F5A7), (Name: 'StaplingOff';
    Value: $F598), (Name: 'StaplingPortraitBookBinding'; Value: $F5A0),
    (Name: 'StaplingPortraitBottomLeft'; Value: $F5AE),
    (Name: 'StaplingPortraitBottomRight'; Value: $F59B),
    (Name: 'StaplingPortraitTopLeft'; Value: $F599),
    (Name: 'StaplingPortraitTopRight'; Value: $F59A),
    (Name: 'StaplingPortraitTwoBottom'; Value: $F59F),
    (Name: 'StaplingPortraitTwoLeft'; Value: $F59C),
    (Name: 'StaplingPortraitTwoRight'; Value: $F59D),
    (Name: 'StaplingPortraitTwoTop'; Value: $F59E), (Name: 'Star';
    Value: $E1CF), (Name: 'StarCancel'; Value: $E195), (Name: 'StarOutline';
    Value: $E1CE), (Name: 'StartPoint'; Value: $E819), (Name: 'StartPointSolid';
    Value: $EB49), (Name: 'StartPresenting'; Value: $F71C),
    (Name: 'StatusCheckmark'; Value: $F1D8), (Name: 'StatusCheckmark7';
    Value: $F0B7), (Name: 'StatusCheckmarkLeft'; Value: $F1D9),
    (Name: 'StatusCircle'; Value: $EA81), (Name: 'StatusCircle7'; Value: $F0B6),
    (Name: 'StatusCircleBlock'; Value: $F140), (Name: 'StatusCircleBlock2';
    Value: $F141), (Name: 'StatusCircleCheckmark'; Value: $F13E),
    (Name: 'StatusCircleErrorX'; Value: $F13D),
    (Name: 'StatusCircleExclamation'; Value: $F13C), (Name: 'StatusCircleInfo';
    Value: $F13F), (Name: 'StatusCircleInner'; Value: $F137),
    (Name: 'StatusCircleLeft'; Value: $EBFD), (Name: 'StatusCircleOuter';
    Value: $F136), (Name: 'StatusCircleQuestionMark'; Value: $F142),
    (Name: 'StatusCircleRing'; Value: $F138), (Name: 'StatusCircleSync';
    Value: $F143), (Name: 'StatusConnecting1'; Value: $EB57),
    (Name: 'StatusConnecting2'; Value: $EB58), (Name: 'StatusDataTransfer';
    Value: $E880), (Name: 'StatusDataTransferRoaming'; Value: $F5AA),
    (Name: 'StatusDataTransferVPN'; Value: $E881), (Name: 'StatusDualSIM1';
    Value: $E884), (Name: 'StatusDualSIM1VPN'; Value: $E885),
    (Name: 'StatusDualSIM2'; Value: $E882), (Name: 'StatusDualSIM2VPN';
    Value: $E883), (Name: 'StatusError'; Value: $EA83),
    (Name: 'StatusErrorCircle7'; Value: $F0B8), (Name: 'StatusErrorFull';
    Value: $EB90), (Name: 'StatusErrorLeft'; Value: $EBFF),
    (Name: 'StatusExclamationCircle7'; Value: $F12F), (Name: 'StatusInfo';
    Value: $F3CC), (Name: 'StatusInfoLeft'; Value: $F3CD),
    (Name: 'StatusPause7'; Value: $F175), (Name: 'StatusSecured'; Value: $F809),
    (Name: 'StatusSGLTE'; Value: $E886), (Name: 'StatusSGLTECell';
    Value: $E887), (Name: 'StatusSGLTEDataVPN'; Value: $E888),
    (Name: 'StatusTriangle'; Value: $EA82), (Name: 'StatusTriangleExclamation';
    Value: $F13B), (Name: 'StatusTriangleInner'; Value: $F13A),
    (Name: 'StatusTriangleLeft'; Value: $EBFE), (Name: 'StatusTriangleOuter';
    Value: $F139), (Name: 'StatusUnsecure'; Value: $EB59), (Name: 'StatusVPN';
    Value: $E889), (Name: 'StatusWarning'; Value: $EA84),
    (Name: 'StatusWarningLeft'; Value: $EC00), (Name: 'Sticker2'; Value: $F4AA),
    (Name: 'StockDown'; Value: $EB0F), (Name: 'StockUp'; Value: $EB11),
    (Name: 'Stop'; Value: $E71A), (Name: 'StopPoint'; Value: $E81A),
    (Name: 'StopPointSolid'; Value: $EB4A), (Name: 'StopPresenting';
    Value: $F71D), (Name: 'Stopwatch'; Value: $E916),
    (Name: 'StorageNetworkWireless'; Value: $E969), (Name: 'StorageOptical';
    Value: $E958), (Name: 'StorageTape'; Value: $E96A), (Name: 'Streaming';
    Value: $E93E), (Name: 'StreamingEnterprise'; Value: $ED2F), (Name: 'Street';
    Value: $E913), (Name: 'StreetsideSplitExpand'; Value: $E803),
    (Name: 'StreetsideSplitMinimize'; Value: $E802), (Name: 'Strikethrough';
    Value: $EDE0), (Name: 'StrokeErase'; Value: $ED60), (Name: 'StrokeErase2';
    Value: $F128), (Name: 'StrokeEraseMirrored'; Value: $EF17),
    (Name: 'SubscriptionAdd'; Value: $ED0E), (Name: 'SubscriptionAddMirrored';
    Value: $ED11), (Name: 'Subtitles'; Value: $ED1E), (Name: 'SubtitlesAudio';
    Value: $ED1F), (Name: 'SubtractBold'; Value: $F8AB), (Name: 'SurfaceHub';
    Value: $E8AE), (Name: 'SurfaceHubSelected'; Value: $F4BE),
    (Name: 'Sustainable'; Value: $EC0A), (Name: 'Swipe'; Value: $E927),
    (Name: 'SwipeRevealArt'; Value: $EC6D), (Name: 'Switch'; Value: $E8AB),
    (Name: 'SwitchApps'; Value: $E8F9), (Name: 'SwitchUser'; Value: $E748),
    (Name: 'Sync'; Value: $E895), (Name: 'SyncBadge12'; Value: $EDAB),
    (Name: 'SyncError'; Value: $EA6A), (Name: 'SyncFolder'; Value: $E8F7),
    (Name: 'System'; Value: $E770), (Name: 'Tablet'; Value: $E70A),
    (Name: 'TabletMode'; Value: $EBFC), (Name: 'TabletSelected'; Value: $EC74),
    (Name: 'Tag'; Value: $E8EC), (Name: 'TapAndSend'; Value: $E9A1),
    (Name: 'TaskbarPhone'; Value: $EE64), (Name: 'TaskView'; Value: $E7C4),
    (Name: 'TaskViewExpanded'; Value: $EB91), (Name: 'TaskViewSettings';
    Value: $EE40), (Name: 'ThisPC'; Value: $EC4E), (Name: 'ThoughtBubble';
    Value: $EA91), (Name: 'ThreeBars'; Value: $E907),
    (Name: 'ThreeQuarterStarLeft'; Value: $F0CC),
    (Name: 'ThreeQuarterStarRight'; Value: $F0CD), (Name: 'Thumbs';
    Value: $E19D), (Name: 'ThumbsDown'; Value: $E19E), (Name: 'ThumbsUp';
    Value: $E19F), (Name: 'Tiles'; Value: $ECA5), (Name: 'TiltDown';
    Value: $E80A), (Name: 'TiltUp'; Value: $E809), (Name: 'TimeLanguage';
    Value: $E775), (Name: 'ToggleBorder'; Value: $EC12), (Name: 'ToggleFilled';
    Value: $EC11), (Name: 'ToggleLeft'; Value: $F19E), (Name: 'ToggleRight';
    Value: $F19F), (Name: 'ToggleThumb'; Value: $EC14), (Name: 'TollSolid';
    Value: $F161), (Name: 'ToolTip'; Value: $E82F), (Name: 'Touch';
    Value: $E815), (Name: 'Touchpad'; Value: $EFA5), (Name: 'TouchPointer';
    Value: $E7C9), (Name: 'Touchscreen'; Value: $EDA4), (Name: 'Trackers';
    Value: $EADF), (Name: 'TrackersMirrored'; Value: $EE92),
    (Name: 'TrafficCongestionSolid'; Value: $F163), (Name: 'TrafficLight';
    Value: $EF31), (Name: 'Train'; Value: $E7C0), (Name: 'TrainSolid';
    Value: $EB4D), (Name: 'Translate'; Value: $E164), (Name: 'TreeFolderFolder';
    Value: $ED41), (Name: 'TreeFolderFolderFill'; Value: $ED42),
    (Name: 'TreeFolderFolderOpen'; Value: $ED43),
    (Name: 'TreeFolderFolderOpenFill'; Value: $ED44), (Name: 'TriggerLeft';
    Value: $F10A), (Name: 'TriggerRight'; Value: $F10B), (Name: 'Trim';
    Value: $E78A), (Name: 'TVMonitor'; Value: $E7F4),
    (Name: 'TVMonitorSelected'; Value: $EC77), (Name: 'TwoBars'; Value: $E906),
    (Name: 'TwoPage'; Value: $E89A), (Name: 'Type'; Value: $E97C),
    (Name: 'Underline'; Value: $E8DC), (Name: 'UnderscoreSpace'; Value: $E75D),
    (Name: 'Undo'; Value: $E10E), (Name: 'Undo'; Value: $E7A7),
    (Name: 'Unfavorite'; Value: $E8D9), (Name: 'Unit'; Value: $ECC6),
    (Name: 'Unknown'; Value: $E9CE), (Name: 'UnknownMirrored'; Value: $F22E),
    (Name: 'Unlock'; Value: $E785), (Name: 'Unlock'; Value: $E1F7),
    (Name: 'Unpin'; Value: $E77A), (Name: 'UnsyncFolder'; Value: $E8F6),
    (Name: 'Up'; Value: $E74A), (Name: 'UpArrowShiftKey'; Value: $E752),
    (Name: 'UpdateRestore'; Value: $E777), (Name: 'UpdateStatusDot';
    Value: $F83F), (Name: 'Upload'; Value: $E11C), (Name: 'Upload2';
    Value: $E898), (Name: 'UpShiftKey'; Value: $E84B), (Name: 'USB';
    Value: $E88E), (Name: 'USBSafeConnect'; Value: $ECF3), (Name: 'UserAPN';
    Value: $F081), (Name: 'VerticalBattery0'; Value: $F5F2),
    (Name: 'VerticalBattery1'; Value: $F5F3), (Name: 'VerticalBattery10';
    Value: $F5FC), (Name: 'VerticalBattery2'; Value: $F5F4),
    (Name: 'VerticalBattery3'; Value: $F5F5), (Name: 'VerticalBattery4';
    Value: $F5F6), (Name: 'VerticalBattery5'; Value: $F5F7),
    (Name: 'VerticalBattery6'; Value: $F5F8), (Name: 'VerticalBattery7';
    Value: $F5F9), (Name: 'VerticalBattery8'; Value: $F5FA),
    (Name: 'VerticalBattery9'; Value: $F5FB), (Name: 'VerticalBatteryCharging0';
    Value: $F5FD), (Name: 'VerticalBatteryCharging1'; Value: $F5FE),
    (Name: 'VerticalBatteryCharging10'; Value: $F607),
    (Name: 'VerticalBatteryCharging2'; Value: $F5FF),
    (Name: 'VerticalBatteryCharging3'; Value: $F600),
    (Name: 'VerticalBatteryCharging4'; Value: $F601),
    (Name: 'VerticalBatteryCharging5'; Value: $F602),
    (Name: 'VerticalBatteryCharging6'; Value: $F603),
    (Name: 'VerticalBatteryCharging7'; Value: $F604),
    (Name: 'VerticalBatteryCharging8'; Value: $F605),
    (Name: 'VerticalBatteryCharging9'; Value: $F606),
    (Name: 'VerticalBatteryUnknown'; Value: $F608), (Name: 'Vibrate';
    Value: $E877), (Name: 'Video'; Value: $E25D), (Name: 'Video2';
    Value: $E714), (Name: 'Video360'; Value: $F131), (Name: 'VideoCapture';
    Value: $F7EE), (Name: 'VideoChat'; Value: $E8AA), (Name: 'VideoOutline';
    Value: $E116), (Name: 'VideoSolid'; Value: $EA0C), (Name: 'View';
    Value: $E890), (Name: 'ViewAll'; Value: $E8A9), (Name: 'ViewDashboard';
    Value: $F246), (Name: 'VirtualMachineGroup'; Value: $EEA3),
    (Name: 'VoiceCall'; Value: $F715), (Name: 'Voicemail'; Value: $E1D5),
    (Name: 'Volume'; Value: $E767), (Name: 'Volume0'; Value: $E992),
    (Name: 'Volume1'; Value: $E993), (Name: 'Volume2'; Value: $E994),
    (Name: 'Volume3'; Value: $E995), (Name: 'VolumeBars'; Value: $EBC5),
    (Name: 'VPN'; Value: $E705), (Name: 'Walk'; Value: $E805),
    (Name: 'WalkSolid'; Value: $E726), (Name: 'Warning'; Value: $E7BA),
    (Name: 'Webcam'; Value: $E8B8), (Name: 'Webcam2'; Value: $E960),
    (Name: 'WebSearch'; Value: $F6FA), (Name: 'Website'; Value: $EB41),
    (Name: 'Wheel'; Value: $EE94), (Name: 'Wifi'; Value: $E701), (Name: 'Wifi1';
    Value: $E872), (Name: 'Wifi2'; Value: $E873), (Name: 'Wifi3'; Value: $E874),
    (Name: 'WifiAttentionOverlay'; Value: $E998), (Name: 'WifiCall0';
    Value: $EBD5), (Name: 'WifiCall1'; Value: $EBD6), (Name: 'WifiCall2';
    Value: $EBD7), (Name: 'WifiCall20'; Value: $F658), (Name: 'WifiCall21';
    Value: $F659), (Name: 'WifiCall22'; Value: $F65A), (Name: 'WifiCall23';
    Value: $F65B), (Name: 'WifiCall24'; Value: $F65C), (Name: 'WifiCall3';
    Value: $EBD8), (Name: 'WifiCall4'; Value: $EBD9), (Name: 'WifiCallBars';
    Value: $EBD4), (Name: 'WifiCallBars2'; Value: $F657), (Name: 'WifiError0';
    Value: $EB5A), (Name: 'WifiError1'; Value: $EB5B), (Name: 'WifiError2';
    Value: $EB5C), (Name: 'WifiError3'; Value: $EB5D), (Name: 'WifiError4';
    Value: $EB5E), (Name: 'WifiEthernet'; Value: $EE77), (Name: 'WifiHotspot';
    Value: $E88A), (Name: 'WifiOutline0'; Value: $E1E5), (Name: 'WifiOutline1';
    Value: $E1E6), (Name: 'WifiOutline2'; Value: $E1E7), (Name: 'WifiOutline3';
    Value: $E1E8), (Name: 'WifiOutline4'; Value: $E1E9), (Name: 'WifiWarning0';
    Value: $EB5F), (Name: 'WifiWarning1'; Value: $EB60), (Name: 'WifiWarning2';
    Value: $EB61), (Name: 'WifiWarning3'; Value: $EB62), (Name: 'WifiWarning4';
    Value: $EB63), (Name: 'WindDirection'; Value: $EBE6),
    (Name: 'WindowCollapse'; Value: $E1D8), (Name: 'WindowExpand';
    Value: $E1D9), (Name: 'WindowsInsider'; Value: $F1AD),
    (Name: 'WindowSnipping'; Value: $F7ED), (Name: 'Wire'; Value: $E95F),
    (Name: 'WiredUSB'; Value: $ECF0), (Name: 'WirelessUSB'; Value: $ECF1),
    (Name: 'Work'; Value: $E821), (Name: 'WorkSolid'; Value: $EB4E),
    (Name: 'World'; Value: $E909), (Name: 'WorldWire'; Value: $E12B),
    (Name: 'Wrench'; Value: $E15E), (Name: 'XboxOneConsole'; Value: $E990),
    (Name: 'ZeroBars'; Value: $E904), (Name: 'Zoom'; Value: $E71E),
    (Name: 'ZoomIn'; Value: $E8A3), (Name: 'ZoomMode'; Value: $ECE8),
    (Name: 'ZoomOut'; Value: $E71F));

procedure TfrmORSymbolLabelPE.btnNextClick(Sender: TObject);
begin
  DoSearch(Sender, True);
end;

procedure TfrmORSymbolLabelPE.ctrlEnter(Sender: TObject);
begin
  if Sender is TControl then
    case TControl(Sender).Tag of
      0, 1:
        begin
          FWorkingOn := woForeground;
          lblForeground.Font.Style := [fsBold];
          lblBackground.Font.Style := [];
        end;
      2, 3:
        begin
          FWorkingOn := woBackground;
          lblForeground.Font.Style := [];
          lblBackground.Font.Style := [fsBold];
        end;
      9999:
        ; // Do Nothing
    else
      FWorkingOn := woNone;
      lblForeground.Font.Style := [];
      lblBackground.Font.Style := [];
    end;
end;

procedure TfrmORSymbolLabelPE.btnClearClick(Sender: TObject);
begin
  if Sender is TButton then
  begin
    case TButton(Sender).Tag of
      1:
        symMain.Symbol.ForegroundValue := ORSymbolTable[0].Value;
      3:
        symMain.Symbol.BackgroundValue := ORSymbolTable[0].Value;
    end;
    UpdateCtrls;
  end;
end;

procedure TfrmORSymbolLabelPE.btnEnter(Sender: TObject);
begin
  FWorkingOn := woNone;
end;

procedure TfrmORSymbolLabelPE.btnPrevClick(Sender: TObject);
begin
  DoSearch(Sender, False);
end;

procedure TfrmORSymbolLabelPE.clrChange(Sender: TObject);
var
  clr: TColorBox;
begin
  if Sender is TColorBox then
  begin
    clr := TColorBox(Sender);
    if clr.Tag = 2 then
      symMain.Symbol.BackgroundColor := clr.Selected
    else
      symMain.Symbol.ForegroundColor := clr.Selected;
    UpdateCtrls;
  end;
end;

procedure TfrmORSymbolLabelPE.btnKeepClick(Sender: TObject);
var
  ATag, Value: Integer;
begin
  if (Sender is TControl) then
    ATag := TControl(Sender).Tag
  else
    Exit;
  if Assigned(lv.Selected) then
  begin
    case ATag of
      0, 1:
        symMain.Symbol.ForegroundValue := ORSymbolTable
          [lv.Selected.Index].Value;
      2, 3:
        symMain.Symbol.BackgroundValue := ORSymbolTable
          [lv.Selected.Index].Value;
    end;
  end
  else
  begin
    case ATag of
      0:
        Value := StrToIntDef(edtForegroundValue.Text, -1);
      2:
        Value := StrToIntDef(edtBackgroundValue.Text, -1);
    else
      Value := -1;
    end;
    if (Value > 0) and (Value <= MaxWord) then
    begin
      case ATag of
        0:
          symMain.Symbol.ForegroundValue := Value;
        2:
          symMain.Symbol.BackgroundValue := Value;
      end;
    end
    else
      ShowMessage(Format('Value must be between 0 and %d.', [MaxWord]));
  end;
  UpdateCtrls;
end;

procedure TfrmORSymbolLabelPE.DoSearch(Sender: TObject; Forward: Boolean);
var
  Found, Search: Boolean;
  idx, Start, Value, ATag: Integer;
  UCName: string;
begin
  if (Sender is TControl) then
    ATag := TControl(Sender).Tag
  else
    Exit;
  UCName := '';
  Value := -1;
  Search := False;
  case ATag of
    0:
      begin
        Value := StrToIntDef(edtForegroundValue.Text, -1);
        Search := (Value > 0);
      end;
    1:
      begin
        UCName := UpperCase(edtForegroundName.Text);
        Search := (UCName <> '');
      end;
    2:
      begin
        Value := StrToIntDef(edtBackgroundValue.Text, -1);
        Search := (Value > 0);
      end;
    3:
      begin
        UCName := UpperCase(edtBackgroundName.Text);
        Search := (UCName <> '');
      end;
  end;
  if Search then
  begin
    Start := FCurrentIndex;
    idx := Start;
    repeat
      if Forward then
      begin
        inc(idx);
        if idx >= FSymbols.Count then
        begin
          idx := 0;
          if Start < 0 then
            Start := 0;
        end;
      end
      else
      begin
        dec(idx);
        if idx < 0 then
        begin
          if Start < 0 then
          begin
            idx := 0;
            Start := 0;
          end
          else
            idx := FSymbols.Count - 1;
        end;
      end;
      if Value > 0 then
        Found := (Value = Integer(FSymbols.Objects[idx]))
      else
        Found := (pos(UCName, FSymbols[idx]) > 0);
    until Found or (idx = Start);
  end
  else
  begin
    idx := 0;
    Found := True;
  end;
  if Found then
  begin
    FCurrentIndex := idx;
    lv.Items[idx].MakeVisible(False);
    lv.Items[idx].Selected := True;
    FInternal := True;
    try
      case ATag of
        0:
          edtForegroundName.Text := ORSymbolTable[idx].Name;
        2:
          edtBackgroundName.Text := ORSymbolTable[idx].Name;
      end;
    finally
      FInternal := False;
    end;
  end
  else
  begin
    lv.Selected := nil;
    if Value > 0 then
    begin
      case ATag of
        0:
          edtForegroundName.Text := '';
        2:
          edtBackgroundName.Text := '';
      end;
    end;
  end;
end;

procedure TfrmORSymbolLabelPE.edtKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  ATag, idx: Integer;
  Keep: Boolean;
begin
  if Key = VK_RETURN then
  begin
    if (lv.Selected <> nil) then
    begin
      if Sender is TEdit then
        ATag := TEdit(Sender).Tag
      else
        Exit;
      case ATag of
        0:
          Keep := (ORSymbolTable[lv.Selected.Index].Value = StrToIntDef
            (edtForegroundValue.Text, -1));
        2:
          Keep := (ORSymbolTable[lv.Selected.Index].Value = StrToIntDef
            (edtBackgroundValue.Text, -1));
      else
        Keep := False;
      end;
      if Keep then
      begin
        btnKeepClick(Sender);
        Exit;
      end;
    end;
    if Shift = [] then
      btnNextClick(Sender)
    else
      btnPrevClick(Sender);
  end
  else if lv.Selected <> nil then
  begin
    if Key = VK_UP then
    begin
      idx := lv.Selected.Index;
      dec(idx);
      if idx < 0 then
        idx := High(ORSymbolTable);
      lv.Items[idx].MakeVisible(False);
      lv.Items[idx].Selected := True;
    end
    else if Key = VK_DOWN then
    begin
      idx := lv.Selected.Index;
      inc(idx);
      if idx > High(ORSymbolTable) then
        idx := 0;
      lv.Items[idx].MakeVisible(False);
      lv.Items[idx].Selected := True;
    end;
  end;
end;

procedure TfrmORSymbolLabelPE.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  btnOK.Default := False;
  lv.LockDrawing;
  try
    FSymbols := TStringList.Create;
    for i := 0 to High(ORSymbolTable) do
    begin
      FSymbols.AddObject(UpperCase(ORSymbolTable[i].Name),
        TObject(ORSymbolTable[i].Value));
      with lv.Items.Add do
      begin
        Caption := Char(ORSymbolTable[i].Value);
        SubItems.Add(ORSymbolTable[i].Value.ToString);
        SubItems.Add(ORSymbolTable[i].Name);
      end;
    end;
  finally
    lv.UnlockDrawing;
  end;
  if SymbolLabelPEPosition.Width > 0 then
    BoundsRect := SymbolLabelPEPosition;
end;

procedure TfrmORSymbolLabelPE.FormDestroy(Sender: TObject);
begin
  FSymbols.Free;
end;

procedure TfrmORSymbolLabelPE.FormResize(Sender: TObject);
begin
  SymbolLabelPEPosition := BoundsRect;
end;

procedure TfrmORSymbolLabelPE.lvDblClick(Sender: TObject);
begin
  if Assigned(lv.Selected) then
  begin
    if FWorkingOn = woForeground then
      symMain.Symbol.ForegroundValue := ORSymbolTable[lv.Selected.Index].Value
    else if FWorkingOn = woBackground then
      symMain.Symbol.BackgroundValue := ORSymbolTable[lv.Selected.Index].Value;
    UpdateCtrls;
  end;
end;

procedure TfrmORSymbolLabelPE.UpdateCtrls;
var
  i, Count: Integer;
begin
  if FInternal then
    Exit;
  FInternal := True;
  try
    edtForegroundValue.Text := symMain.Symbol.ForegroundValue.ToString;
    clrForeground.Selected := symMain.Symbol.ForegroundColor;
    edtBackgroundValue.Text := symMain.Symbol.BackgroundValue.ToString;
    clrBackground.Selected := symMain.Symbol.BackgroundColor;
    Count := 0;
    for i := 0 to High(ORSymbolTable) do
    begin
      if ORSymbolTable[i].Value = symMain.Symbol.ForegroundValue then
      begin
        edtForegroundName.Text := ORSymbolTable[i].Name;
        inc(Count);
      end;
      if ORSymbolTable[i].Value = symMain.Symbol.BackgroundValue then
      begin
        edtBackgroundName.Text := ORSymbolTable[i].Name;
        inc(Count);
      end;
      if Count > 1 then
        break;
    end;
  finally
    FInternal := False;
  end;
end;

end.
