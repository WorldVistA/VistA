unit VAUtils;

{TODO  -oJeremy Merrill -cMessageHandlers : Change component list to use hex address for uComponentList
search instead of IndexOfObject, so that it used a binary search
on sorted text.}

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, StrUtils, Controls, VAClasses, Forms,
  SHFolder, ShlObj, PSAPI, ShellAPI, ComObj, vcl.Dialogs, vcl.StdCtrls, vcl.ExtCtrls;
type
  /// <summary>array of string</summary>
  TStringarray = array of string;

procedure ShowMessage(const Text: string);

/// <summary>Dialog with no default button and possible with button captions</summary>
/// <param name="Text">[<see cref="system|String"/>] - Message dialog main text</param>
/// <param name="Caption">[<see cref="system|String"/>] - Message dialog caption text</param>
/// <param name="DlgType">[<see cref="Vcl.Dialogs|TMsgDlgType"/>] - Type of message dialog</param>
/// <param name="Buttons">[<see cref="Vcl.Dialogs|TMsgDlgBtn"/>] - Buttons display on the message dialog</param>
/// <param name="ButtonCaptions">[<see cref="VAUtils|TStringarray"/>] - Overwrite captions of the buttons</param>
/// <returns>[<see cref="system|Integer"/>] - Integer value for <see cref="vcl.controls|TModalResult"/></returns>
function InfoDlg(const Text, Caption: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; ButtonCaptions: TStringarray = nil)
  : Integer; overload;

/// <summary>Dialog with a default button and possible with button captions</summary>
/// <param name="Text">[<see cref="system|String"/>] - Message dialog main text</param>
/// <param name="Caption">[<see cref="system|String"/>] - Message dialog caption text</param>
/// <param name="DlgType">[<see cref="Vcl.Dialogs|TMsgDlgType"/>] - Type of message dialog</param>
/// <param name="Buttons">[<see cref="Vcl.Dialogs|TMsgDlgBtn"/>] - Buttons display on the message dialog</param>
/// <param name="DefaultButton">[<see cref="Vcl.Dialogs|TMsgDlgBtn"/>] - Default button</param>
/// <param name="ButtonCaptions">[<see cref="VAUtils|TStringarray"/>] - Overwrite captions of the buttons</param>
/// <returns>[<see cref="system|Integer"/>] - Integer value for <see cref="vcl.controls|TModalResult"/></returns>
function InfoDlg(const Text, Caption: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; DefaultButton: TMsgDlgBtn;
  ButtonCaptions: TStringarray = nil): Integer; overload;

/// <summary>Dialog with a check box and no default button</summary>
/// <param name="Text">[<see cref="system|String"/>] - Message dialog main text</param>
/// <param name="Caption">[<see cref="system|String"/>] - Message dialog caption text</param>
/// <param name="DlgType">[<see cref="Vcl.Dialogs|TMsgDlgType"/>] - Type of message dialog</param>
/// <param name="Buttons">[<see cref="Vcl.Dialogs|TMsgDlgBtn"/>] - Buttons display on the message dialog</param>
/// <param name="CheckBoxVisible">[<see cref="system|Boolean"/>] - Display the checkbox</param>
/// <param name="CheckBoxCaption">[<see cref="system|String"/>] - Caption for the checkbox</param>
/// <param name="CheckboxOnClick">[<see cref="system.classes|TNotifyEvent"/>] - OnClick event for the checkbox</param>
/// <param name="CheckboxChecked">[<see cref="system|Boolean"/>] - <b>OUT PARMATER</b> Checkbox checked state</param>
/// <returns>[<see cref="system|Integer"/>] - Integer value for <see cref="vcl.controls|TModalResult"/></returns>
function InfoDlgWithCheckbox(const Text, Caption: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons;
  CheckBoxVisible: Boolean; CheckBoxCaption: string;
  CheckboxOnClick: TNotifyEvent; out CheckboxChecked: Boolean): Integer;
  overload;

/// <summary>Dialog with a check box and no default button and possible with button captions</summary>
/// <param name="Text">[<see cref="system|String"/>] - Message dialog main text</param>
/// <param name="Caption">[<see cref="system|String"/>] - Message dialog caption text</param>
/// <param name="DlgType">[<see cref="Vcl.Dialogs|TMsgDlgType"/>] - Type of message dialog</param>
/// <param name="Buttons">[<see cref="Vcl.Dialogs|TMsgDlgBtn"/>] - Buttons display on the message dialog</param>
/// <param name="ButtonCaptions">[<see cref="VAUtils|TStringarray"/>] - Overwrite captions of the buttons</param>
/// <param name="CheckBoxVisible">[<see cref="system|Boolean"/>] - Display the checkbox</param>
/// <param name="CheckBoxCaption">[<see cref="system|String"/>] - Caption for the checkbox</param>
/// <param name="CheckboxOnClick">[<see cref="system.classes|TNotifyEvent"/>] - OnClick event for the checkbox</param>
/// <param name="CheckboxChecked">[<see cref="system|Boolean"/>] - <b>OUT PARMATER</b> Checkbox checked state</param>
/// <returns>[<see cref="system|Integer"/>] - Integer value for <see cref="vcl.controls|TModalResult"/></returns>
function InfoDlgWithCheckbox(const Text, Caption: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; ButtonCaptions: TStringarray;
  CheckBoxVisible: Boolean; CheckBoxCaption: string;
  CheckboxOnClick: TNotifyEvent; out CheckboxChecked: Boolean): Integer;
  overload;

/// <summary>Dialog with a check box and with a default button and possible with button captions</summary>
/// <param name="Text">[<see cref="system|String"/>] - Message dialog main text</param>
/// <param name="Caption">[<see cref="system|String"/>] - Message dialog caption text</param>
/// <param name="DlgType">[<see cref="Vcl.Dialogs|TMsgDlgType"/>] - Type of message dialog</param>
/// <param name="Buttons">[<see cref="Vcl.Dialogs|TMsgDlgBtn"/>] - Buttons display on the message dialog</param>
/// <param name="DefaultButton">[<see cref="Vcl.Dialogs|TMsgDlgBtn"/>] - Default button</param>
/// <param name="ButtonCaptions">[<see cref="VAUtils|TStringarray"/>] - Overwrite captions of the buttons</param>
/// <param name="CheckBoxVisible">[<see cref="system|Boolean"/>] - Display the checkbox</param>
/// <param name="CheckBoxCaption">[<see cref="system|String"/>] - Caption for the checkbox</param>
/// <param name="CheckboxOnClick">[<see cref="system.classes|TNotifyEvent"/>] - OnClick event for the checkbox</param>
/// <param name="CheckboxChecked">[<see cref="system|Boolean"/>] - <b>OUT PARMATER</b> Checkbox checked state</param>
/// <returns>[<see cref="system|Integer"/>] - Integer value for <see cref="vcl.controls|TModalResult"/></returns>
function InfoDlgWithCheckbox(const Text, Caption: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; DefaultButton: TMsgDlgBtn;
  ButtonCaptions: TStringarray; CheckBoxVisible: Boolean;
  CheckBoxCaption: string; CheckboxOnClick: TNotifyEvent;
  out CheckboxChecked: Boolean): Integer; overload;


type
  TShow508MessageIcon = (smiNone, smiInfo, smiWarning, smiError, smiQuestion);
  TShow508MessageButton = (smbOK, smbOKCancel, smbAbortRetryCancel, smbYesNoCancel,
                           smbYesNo, smbRetryCancel);
  TShow508MessageResult = (smrOK, srmCancel, smrAbort, smrRetry, smrIgnore, smrYes, smrNo);

function ShowMsg(const Msg, Caption: string; Icon: TShow508MessageIcon = smiNone;
                    Buttons: TShow508MessageButton = smbOK): TShow508MessageResult; overload;

function ShowMsg(const Msg: string; Icon: TShow508MessageIcon = smiNone;
                    Buttons: TShow508MessageButton = smbOK): TShow508MessageResult; overload;

const
  SHARE_DIR = '\VISTA\Common Files\';
  JAWS_EXENAME = 'jfw.exe';
  JAWS_FORCED = 'FORCEJAWS';
  JAWS_CL_EXE_SW = 'SCREADER';

{ returns the Nth piece (PieceNum) of a string delimited by Delim }
function Piece(const S: string; Delim: char; PieceNum: Integer): string;
{ returns several contiguous pieces }
function Pieces(const S: string; Delim: char; FirstNum, LastNum: Integer): string; overload;

function Pieces(const S: string; PieceNumbers: array of Integer; PieceDelim, ReturnDelim: Char): string; overload;

// Same as FreeAndNil, but for TString objects only
// Frees any objects in the TStrings Objects list as well the TStrings object
procedure FreeAndNilTStringsAndObjects(var Strings);

// Returns true if a screen reader programm is running
function OldScreenReaderActive: boolean;
function ScreenReaderActive: boolean;

// Special Coding for Screen Readers only enabled if screen reader was
// running when the application first started up
function ScreenReaderSupportEnabled: boolean;

// Returns C:\...\subPath\File format based on maxSize and Canvas font setting
function GetFileWithShortenedPath(FileName: String; MaxSize: integer; Canvas: TCanvas): string;

const
  HexChars: array[0..255] of string =
    ('00','01','02','03','04','05','06','07','08','09','0A','0B','0C','0D','0E','0F',
     '10','11','12','13','14','15','16','17','18','19','1A','1B','1C','1D','1E','1F',
     '20','21','22','23','24','25','26','27','28','29','2A','2B','2C','2D','2E','2F',
     '30','31','32','33','34','35','36','37','38','39','3A','3B','3C','3D','3E','3F',
     '40','41','42','43','44','45','46','47','48','49','4A','4B','4C','4D','4E','4F',
     '50','51','52','53','54','55','56','57','58','59','5A','5B','5C','5D','5E','5F',
     '60','61','62','63','64','65','66','67','68','69','6A','6B','6C','6D','6E','6F',
     '70','71','72','73','74','75','76','77','78','79','7A','7B','7C','7D','7E','7F',
     '80','81','82','83','84','85','86','87','88','89','8A','8B','8C','8D','8E','8F',
     '90','91','92','93','94','95','96','97','98','99','9A','9B','9C','9D','9E','9F',
     'A0','A1','A2','A3','A4','A5','A6','A7','A8','A9','AA','AB','AC','AD','AE','AF',
     'B0','B1','B2','B3','B4','B5','B6','B7','B8','B9','BA','BB','BC','BD','BE','BF',
     'C0','C1','C2','C3','C4','C5','C6','C7','C8','C9','CA','CB','CC','CD','CE','CF',
     'D0','D1','D2','D3','D4','D5','D6','D7','D8','D9','DA','DB','DC','DD','DE','DF',
     'E0','E1','E2','E3','E4','E5','E6','E7','E8','E9','EA','EB','EC','ED','EE','EF',
     'F0','F1','F2','F3','F4','F5','F6','F7','F8','F9','FA','FB','FC','FD','FE','FF');

  DigitTable = '0123456789ABCDEF';

  BinChars: array[0..15] of string =
     ('0000', // 0
      '0001', // 1
      '0010', // 2
      '0011', // 3
      '0100', // 4
      '0101', // 5
      '0110', // 6
      '0111', // 7
      '1000', // 8
      '1001', // 9
      '1010', // 10
      '1011', // 11
      '1100', // 12
      '1101', // 13
      '1110', // 14
      '1111');// 15

type
  TFastIntHexRec = record
    case integer of
      1: (lw: longword);
      2: (b1, b2, b3, b4: byte);
  end;

  TFastWordHexRec = record
    case integer of
      1: (w: word);
      2: (b1, b2: byte);
  end;

// returns an 8 digit hex number
function FastIntToHex(Value: LongWord): String;

// returns an 4 digit hex number
function FastWordToHex(Value: Word): String;

// takes only a 2 digit value - 1 byte - from above table
function FastHexToByte(HexString: string): byte;

// takes only an 8 digit value - 4 bytes
function FastHexToInt(HexString: string): LongWord;

// converts am upper case hex string of any length to binary
function FastHexToBinary(HexString: string): string;

{ returns a cyclic redundancy check for a string }
function CRCForString(AString: string): DWORD;

// If the string parameter does not end with a back slash, one is appended to the end
// typically used for file path processing
function AppendBackSlash(var txt: string): string;

// returns special folder path on the current machine - such as Program Files etc
// the parameter is a CSIDL windows constant
function GetSpecialFolderPath(SpecialFolderCSIDL: integer): String;

// returns Program Files path on current machine
function GetProgramFilesPath: String;

// returns Program Files path on the drive where the currently running application
// resides, if it is a different drive than the one that contains the current
// machine's Program Files directory.  This is typically used for networked drives.
function GetAlternateProgramFilesPath: String;

// Get the Window title (Caption) of a window, given only it's handle
function GetWindowTitle(Handle: HWND): String;

// Get the Window class name string, given only it's window handle
function GetWindowClassName(Handle: HWND): String;

// Add or Remove a message handler to manage custom messages for an existing TWinControl
type
// TVAWinProcMessageEvent is used for raw windows messages not intercepted by the controls
(*
// doesn't work when the component's parent is changed, or anything else causes the
   handle to be recreated.
  TVAWinProcMessageEvent = function(hWnd: HWND; Msg: UINT;
            wParam: WPARAM; lParam: LPARAM; var Handled: boolean): LRESULT of object;
*)

// TVAMessageEvent is used for windows messages that are intercepted by controls and are
//    converted to TMessage records - messages not intercepted in this manner should be
//    caught by TVAWinProcMessageEvent.  Note that this is a different event structure
//    than the TMessageEvent used by TApplication, this uses TMessage rather than TMsg.
  TVAMessageEvent = procedure (var Msg: TMessage; var Handled: Boolean) of object;

//procedure AddMessageHandler(Control: TWinControl; MessageHandler: TVAWinProcMessageEvent); overload;
procedure AddMessageHandler(Control: TWinControl; MessageHandler: TVAMessageEvent); overload;

//procedure RemoveMessageHandler(Control: TWinControl; MessageHandler: TVAWinProcMessageEvent); overload;
procedure RemoveMessageHandler(Control: TWinControl; MessageHandler: TVAMessageEvent); overload;

// removes all message handlers, both TVAWinProcMessageEvent and TVAMessageEvent types
procedure RemoveAllMessageHandlers(Control: TWinControl);

function MessageHandlerCount(Control: TWinControl): integer;

function GetInstanceCount(ApplicationNameAndPath: string): integer; overload;
function GetInstanceCount: integer; overload;

function AnotherInstanceRunning: boolean;

procedure VersionStringSplit(const VerStr: string; var Val1: integer); overload;
procedure VersionStringSplit(const VerStr: string; var Val1, Val2: integer); overload;
procedure VersionStringSplit(const VerStr: string; var Val1, Val2, Val3: integer); overload;
procedure VersionStringSplit(const VerStr: string; var Val1, Val2, Val3, Val4: integer); overload;

function ExecuteAndWait(FileName: string; Parameters: String = ''): integer; overload;
function ExecuteAndWait(FileName: string; var ReturnMsg: string; Parameters: String = ''): integer; overload;
function RunSilentCmd(const CommanLine: string; const ParameterLine: string; out ReturnMessage: String): boolean;

// when called inside a DLL, returns the fully qualified name of the DLL file
// must pass an address or a class or procedure that's been defined inside the DLL
function GetDLLFileName(Address: Pointer): string;

// Use the Pluralize functions to easily generate words and sentences that
//   change plurality based on a count or quantity.
function Pluralize(Count: Integer; const Singular: string; const Plural: string; const Args: array of const): string; overload;
function Pluralize(Count: Integer; const Singular: string; const Args: array of const): string; overload;
function Pluralize(Count: Integer; const Singular: string; const Plural: string = ''): string; overload;

const
  { values that can be passed to FileVersionValue }
  FILE_VER_COMPANYNAME      = 'CompanyName';
  FILE_VER_FILEDESCRIPTION  = 'FileDescription';
  FILE_VER_FILEVERSION      = 'FileVersion';
  FILE_VER_INTERNALNAME     = 'InternalName';
  FILE_VER_LEGALCOPYRIGHT   = 'LegalCopyright';
  FILE_VER_ORIGINALFILENAME = 'OriginalFilename';
  FILE_VER_PRODUCTNAME      = 'ProductName';
  FILE_VER_PRODUCTVERSION   = 'ProductVersion';
  FILE_VER_COMMENTS         = 'Comments';

function FileVersionValue(const AFileName, AValueName: string): string;

// compares up to 4 pieces of a numeric version, returns true if CheckVersion is >= OriginalVersion
// allows for . and , delimited version numbers
function VersionOK(OriginalVersion, CheckVersion: string): boolean;

{================================================================================================}
{  WidthInPixels - Function designed to give the width of the passed string in pixels using the  }
{                  passed font.  Designed to be used when a canvas may not be available.         }
{------------------------------------------------------------------------------------------------}
{  AFont - Font the passed string will be using                                                  }
{  Value - string being evaluated for pixel width                                                }
{================================================================================================}
function WidthInPixels(AFont: TFont; Value: string): integer;

{===============================================================================================}
{  HeightInPixels - Function designed to give the maximum height of the passed font in pixels.  }
{                   Designed to be used when a canvas may not be available.                     }
{-----------------------------------------------------------------------------------------------}
{  AFont - Font to be evaluated for maximum pixel height                                        }
{===============================================================================================}
function HeightInPixels(AFont: TFont): integer;


type
  TD2006CmdLineSwitchType = (clstD2006ValueNextParam, clstD2006ValueAppended);
  TD2006CmdLineSwitchTypes = set of TD2006CmdLineSwitchType;

{ This version is used to return values.
  Switch values may be specified in the following ways on the command line:
    -p Value                - clstValueNextParam
    -pValue or -p:Value     - clstValueAppended

  Pass the SwitchTypes parameter to exclude either of these switch types.
  Switch may be 1 or more characters in length. }
function D2006FindCmdLineSwitch(const Switch: string; var Value: string; IgnoreCase: Boolean = True;
  const SwitchTypes: TD2006CmdLineSwitchTypes = [clstD2006ValueNextParam, clstD2006ValueAppended]): Boolean;

type
 TStringsHelper = class helper for TStrings
  public
    //Return unedited raw text from TStrings
    function RawText: String;
  end;

//Count the number of times a given sub string occurs within a string. Optional max character count
function CountStringOccurrences(const aSubStr, aStr: String; aCutOff: Integer = -1): integer;

function ShouldFocus(Control: TWinControl): boolean;

/// <summary>Changes a rectangle's coordinates so that it fits inside the work area
///    of the current monitor.  The width and height of the rectangle is preserved
///    unless it is larger than the work area width or height.  If the rectangle
///    displays completely or partially outside the work area, it will be repositioned
///    as needed.</summary>
/// <param name="Rect">[<see cref="system.types|TRect"/>]  The rectangle to modify.</param>
/// <param name="WinControl (optional)">[<see cref=" vcl.controls|TWinControl"/>]
///    If a WinControl is passed, the work area used is determined by calling
///    Screen.MonitorFromWindow(WinControl.Handle).WorkAreaRect.  If no WinControl is
///    passed, the work area is determined by calling Screen.WorkAreaRect.</param>
procedure ForceRectInsideWorkArea(var Rect: TRect; WinControl: TWinControl = nil);

implementation

uses tlhelp32, VAPieceHelper, System.Generics.Collections;

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

function Pieces(const S: string; Delim: char; FirstNum, LastNum: Integer): string;
{ returns several contiguous pieces }
var
  PieceNum: Integer;
begin
  Result := '';
  for PieceNum := FirstNum to LastNum do Result := Result + Piece(S, Delim, PieceNum) + Delim;
  if Length(Result) > 0 then Delete(Result, Length(Result), 1);
end;

function Pieces(const S: string; PieceNumbers: array of Integer; PieceDelim, ReturnDelim: Char): string;
Var
  PieceStr: TPiece;
begin
  PieceStr := TPiece(S);
  Result := PieceStr.Pieces(PieceNumbers, PieceDelim, ReturnDelim);
end;

procedure ShowMessage(const Text: string);
begin
  InfoDlg(Text, Application.Title, mtCustom, [mbOK], mbOK);
end;

type
  TStaticText4ScreenReader = class(TStaticText)
  private
    FTimer: TTimer;
    FDefaultButton, FFirstButton: TButton;
    FFocusOnDefault: boolean;
    procedure OnLblTimer(Sender: TObject);
    procedure OnLblEnter(Sender: TObject);
    procedure OnLblKeyPress(Sender: TObject; var Key: Char);
  public
    constructor Create(AOwner: TComponent); override;
  end;

{ TStaticText4ScreenReader }

constructor TStaticText4ScreenReader.Create(AOwner: TComponent);
var
  cc: integer;
begin
  inherited Create(AOwner);
  FTimer := TTimer.Create(Self);
  FTimer.Interval := 500;
  fTimer.Enabled := False;
  FTimer.OnTimer := OnLblTimer;
  OnEnter := OnLblEnter;
  OnKeyPress := OnLblKeyPress;
  FFocusOnDefault := True;
  if (AOwner is TForm) and ((AOwner as TForm).ActiveControl is TButton) then
  begin
    FDefaultButton := (AOwner as TForm).ActiveControl as TButton;
    FDefaultButton.Default := False;
    for cc := 0 to FDefaultButton.Parent.ControlCount - 1 do
      if (FDefaultButton.Parent.Controls[cc] is TButton) then
      begin
        FFirstButton := (FDefaultButton.Parent.Controls[cc] as TButton);
        break;
      end;
  end;
end;

procedure TStaticText4ScreenReader.OnLblTimer(Sender: TObject);
begin
  FTimer.Enabled := False;
  if FFocusOnDefault then
  begin
    if ShouldFocus(FDefaultButton) then
      FDefaultButton.SetFocus;
    FFocusOnDefault := False;
  end
  else
  begin
    if ShouldFocus(FFirstButton) then
      FFirstButton.SetFocus
    else if ShouldFocus(FDefaultButton) then
      FDefaultButton.SetFocus;
  end;
end;

procedure TStaticText4ScreenReader.OnLblEnter(Sender: TObject);
begin
  FTimer.Enabled := True;
end;

procedure TStaticText4ScreenReader.OnLblKeyPress(Sender: TObject;
  var Key: Char);
begin
  if CharInSet(Key, [#13, ' ']) and Assigned(FDefaultButton) then
    FDefaultButton.Click;
end;

function InfoDlgInternal(const Text, Caption: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; DefaultButton: Integer;
  ButtonCaptions: TStringarray; CheckBoxVisible: Boolean;
  CheckBoxCaption: string; CheckboxOnClick: TNotifyEvent; out CheckBoxChecked: Boolean): Integer; forward;

// no default with button captions
function InfoDlg(const Text, Caption: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; ButtonCaptions: TStringarray = nil): Integer;
var
  ADummy: Boolean;
begin
  Result := InfoDlgInternal(Text, Caption, DlgType, Buttons, -1, ButtonCaptions,
    False, '', nil, ADummy);
end;

// Deafult with button captions
function InfoDlg(const Text, Caption: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; DefaultButton: TMsgDlgBtn;
  ButtonCaptions: TStringarray = nil): Integer;
var
  ADummy: Boolean;
begin
  Result := InfoDlgInternal(Text, Caption, DlgType, Buttons,
    Integer(DefaultButton), ButtonCaptions, False, '', nil, ADummy);
end;

function InfoDlgWithCheckbox(const Text, Caption: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons;
  CheckBoxVisible: Boolean; CheckBoxCaption: string;
  CheckboxOnClick: TNotifyEvent; out CheckboxChecked: Boolean): Integer;
  overload;
begin
  Result := InfoDlgInternal(Text, Caption, DlgType, Buttons, -1, [],
    CheckBoxVisible, CheckBoxCaption, CheckboxOnClick, CheckboxChecked);
end;

// no default with button captions and checkbox
function InfoDlgWithCheckbox(const Text, Caption: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; ButtonCaptions: TStringarray;
  CheckBoxVisible: Boolean; CheckBoxCaption: string; CheckboxOnClick: TNotifyEvent;
  out CheckboxChecked: Boolean): Integer; overload;
begin
  Result := InfoDlgInternal(Text, Caption, DlgType, Buttons, -1, ButtonCaptions,
    CheckBoxVisible, CheckBoxCaption, CheckboxOnClick, CheckboxChecked);
end;

// Deafult with button captions and checkbox
function InfoDlgWithCheckbox(const Text, Caption: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; DefaultButton: TMsgDlgBtn;
  ButtonCaptions: TStringarray; CheckBoxVisible: Boolean;
  CheckBoxCaption: string; CheckboxOnClick: TNotifyEvent;
  out CheckboxChecked: Boolean): Integer; overload;
begin
  Result := InfoDlgInternal(Text, Caption, DlgType, Buttons,
    Integer(DefaultButton), ButtonCaptions, CheckBoxVisible, CheckBoxCaption,
    CheckboxOnClick, CheckboxChecked);
end;

function InfoDlgInternal(const Text, Caption: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; DefaultButton: Integer;
  ButtonCaptions: TStringarray; CheckBoxVisible: Boolean;
  CheckBoxCaption: string; CheckboxOnClick: TNotifyEvent; out CheckBoxChecked: Boolean): Integer;
var
  OldSize: Integer;
  Dlg: TForm;
  Dx, Idx, X1, X2, I, ButtonIdx, checkTop: Integer;
  Ctrl: TControl;
  Lbl: TStaticText4ScreenReader;
  WorkArea: TRect;
  Dlgbutton: Tbutton;
  DlgCheckBox: TCheckBox;

  procedure InfoDlgMouseWheel(Self, Sender: TObject; Shift: TShiftState;
    WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  begin
    with TScrollBox(Sender).VertScrollBar do
      Position := Position - WheelDelta;
    Handled := True;
  end;

  procedure AddScrollBoxIfNeeded;
  var
    Idx, BtnTop, BtnBottom, Gap: Integer;
    BoxWidth, NeededWidth: Integer;
    MessageLabel: TLabel;
    Box: TScrollBox;
    Evnt: TMouseWheelEvent;

  begin
    if Dlg.Height > WorkArea.Height then
    begin
      BtnBottom := 0;
      MessageLabel := nil;
      for Idx := 0 to Dlg.ControlCount - 1 do
      begin
        Ctrl := Dlg.Controls[Idx];
        if (Ctrl is TButton) and ((Ctrl.Top + Ctrl.Height) > BtnBottom) then
          BtnBottom := Ctrl.Top + Ctrl.Height
        else if (not Assigned(MessageLabel)) and (Ctrl is TLabel) then
          MessageLabel := TLabel(Ctrl);
      end;
      if Assigned(MessageLabel) and (BtnBottom > 0) then
      begin
        for Idx := 0 to Dlg.ControlCount - 1 do
          if (Dlg.Controls[Idx] is TButton) then
            Dlg.Controls[Idx].Anchors := [AkLeft, AkBottom];
        Gap := Dlg.ClientHeight - BtnBottom;
        Dlg.Height := Workarea.Height - (Gap * 2);
        Dlg.Top := Workarea.Top + Gap;
        BoxWidth := Dlg.ClientWidth - Gap - MessageLabel.Left;
        NeededWidth := MessageLabel.Width + GetSystemMetrics(SM_CXVSCROLL) +
          Dlg.Font.Size;
        Dx := 0;
        if NeededWidth > BoxWidth then
        begin
          Dx := NeededWidth - BoxWidth;
          Dlg.Width := Dlg.Width + Dx;
          Inc(BoxWidth, Dx);
          Dx := Dx div 2;
          Dlg.Left := Dlg.Left - Dx;
        end;
        BtnTop := Dlg.Height;
        for Idx := 0 to Dlg.ControlCount - 1 do
        begin
          Ctrl := Dlg.Controls[Idx];
          if (Ctrl is TButton) then
          begin
            Ctrl.Left := Ctrl.Left + Dx;
            if Ctrl.Top < BtnTop then
              BtnTop := Ctrl.Top;
          end;
        end;
        Box := TScrollBox.Create(Dlg);
        Box.Parent := Dlg;
        Box.Left := MessageLabel.Left;
        Box.Width := BoxWidth;
        Box.Top := Gap;
        Box.Height := BtnTop - (Gap * 2);
        Box.VertScrollBar.Tracking := True;
        Box.VertScrollBar.Style := SsHotTrack;
        Box.BorderStyle := BsNone;
        TMethod(Evnt).Code := @InfoDlgMouseWheel;;
        TMethod(Evnt).Data := Box;
        Box.OnMouseWheel := Evnt;
        MessageLabel.Parent := Box;
        MessageLabel.Top := 0;
        MessageLabel.Left := 0;
      end;
    end;
  end;

begin
  if Assigned(Screen.ActiveCustomForm) then
    WorkArea := Screen.ActiveCustomForm.Monitor.WorkareaRect
  else
    WorkArea := Screen.WorkAreaRect;
  OldSize := Screen.MessageFont.Size;
  try
    if Assigned(Application.MainForm) then
      Screen.MessageFont.Size := Application.MainForm.Font.Size;
    if DefaultButton = -1 then
      Dlg := CreateMessageDialog(Text, DlgType, Buttons)
    else
      Dlg := CreateMessageDialog(Text, DlgType, Buttons,
        TMsgDlgBtn(DefaultButton));
    try
      dlg.DefaultMonitor := dmDesktop;
      Dlg.Caption := Caption;
      Dx := Workarea.Width div 4;
      if Dlg.Width < Dx then
      begin
        Dlg.Width := Dx;
        X1 := Dlg.ClientWidth;
        X2 := 0;
        checkTop := 0;

        for Idx := 0 to Dlg.ControlCount - 1 do
        begin
          Ctrl := Dlg.Controls[Idx];
          if Ctrl is TButton then
          begin
            if Ctrl.Left < X1 then
              X1 := Ctrl.Left;
            if (Ctrl.Left + Ctrl.Width) > X2 then
              X2 := Ctrl.Left + Ctrl.Width;
          If (Ctrl.Top + Ctrl.Height) > checkTop then
            checkTop := Ctrl.Top + Ctrl.Height;
          end;
        end;
        Dx := Dlg.ClientWidth - X2 + X1;
        Dx := (Dx div 2) - X1;
        if Dx > 0 then
        begin
          for Idx := 0 to Dlg.ControlCount - 1 do
          begin
            Ctrl := Dlg.Controls[Idx];
            if Ctrl is TButton then
              Ctrl.Left := Ctrl.Left + Dx;
          end;
        end;
      end;

      Dx := (Workarea.Width - Dlg.Width) div 2;
      Dlg.Left := Workarea.Left + Dx;
      If CheckBoxVisible then
      begin
        checkTop := 0;
        for Idx := 0 to Dlg.ControlCount - 1 do
        begin
          Ctrl := Dlg.Controls[Idx];
          if Ctrl is TButton then
          begin
            If (Ctrl.Top + Ctrl.Height) > checkTop then
              checkTop := Ctrl.Top + Ctrl.Height;
          end;
        end;
        DlgCheckBox := TCheckBox.Create(Dlg);
        DlgCheckBox.Parent := Dlg;
        DlgCheckBox.Caption := CheckBoxCaption;
        DlgCheckBox.Width := dlg.Canvas.TextWidth(CheckBoxCaption) + 20;
        Dlg.Height := Dlg.Height + dlg.Canvas.TextHeight(CheckBoxCaption) + 10;
        DlgCheckBox.top := checkTop + 5;
        DlgCheckBox.Left := 50;
        DlgCheckBox.OnClick := CheckboxOnClick;
      end else
        DlgCheckBox := nil;

      AddScrollBoxIfNeeded;
      dx := (workarea.Height - dlg.Height) div 2;
      dlg.Top := workArea.Top + dx;

      // Update button Captions
      if Length(ButtonCaptions) > 0 then
      begin
        ButtonIdx := 0;
        for I := 0 to Dlg.ComponentCount - 1 do
        begin
          if (Dlg.Components[I] is TButton) then
          begin
            Dlgbutton := TButton(Dlg.Components[I]);
            if ButtonIdx <= high(ButtonCaptions) then
              Dlgbutton.Caption := ButtonCaptions[ButtonIdx];
            Inc(ButtonIdx);
          end;
        end;
      end;

      if ScreenReaderActive then
      begin
        Dlg.Caption := Dlg.Caption + ' Dialog';
        Lbl := TStaticText4ScreenReader.Create(Dlg);
        Lbl.Parent := Dlg;
        Lbl.Top := -1000;
        Lbl.Left := 0;
        Lbl.Caption := Text;
        Lbl.TabStop := True;
        Lbl.TabOrder := 99; // tab order *after* any buttons
        Dlg.SetFocusedControl(Lbl);
      end;

      Result := Dlg.ShowModal;
      CheckBoxChecked := assigned(DlgCheckBox) and DlgCheckBox.Checked;
    finally
      Dlg.Free;
    end;
  finally
    Screen.MessageFont.Size := OldSize;
  end;
end;

function ShowMsg(const Msg, Caption: string; Icon: TShow508MessageIcon = smiNone;
                    Buttons: TShow508MessageButton = smbOK): TShow508MessageResult; overload;
var
  Title: string;
  DlgType: TMsgDlgType;
  aButtons: TMsgDlgButtons;
  Answer: integer;

begin
  case Icon of
    smiInfo:      DlgType := mtInformation;
    smiWarning:   DlgType := mtWarning;
    smiError:     DlgType := mtError;
    smiQuestion:  DlgType := mtConfirmation;
    else          DlgType := mtCustom;
  end;

  case Buttons of
    smbOK:                aButtons := [mbOK];
    smbOKCancel:          aButtons := [mbOK, mbCancel];
    smbAbortRetryCancel:  aButtons := [mbAbort, mbRetry, mbCancel];
    smbYesNoCancel:       aButtons := [mbYes, mbNo, mbCancel];
    smbYesNo:             aButtons := [mbYes, mbNo];
    smbRetryCancel:       aButtons := [mbRetry, mbCancel];
    else                  aButtons := [mbOK];
  end;
  Title := Caption;
  if Title = '' then
    Title := Application.Title;
  Answer := InfoDlg(Msg, Title, DlgType, aButtons);

  case Answer of
    IDCANCEL: Result := srmCancel;
    IDABORT:  Result := smrAbort;
    IDRETRY:  Result := smrRetry;
    IDIGNORE: Result := smrIgnore;
    IDYES:    Result := smrYes;
    IDNO:     Result := smrNo;
    else      Result := smrOK; // IDOK
  end;
end;

function ShowMsg(const Msg: string; Icon: TShow508MessageIcon = smiNone;
                    Buttons: TShow508MessageButton = smbOK): TShow508MessageResult;
var
  Caption: string;
begin
  Caption := '';
  case Icon of
    smiWarning:   Caption := ' Warning';
    smiError:     Caption := ' Error';
    smiQuestion:  Caption := ' Inquiry';
    smiInfo:      Caption := ' Information';
  end;
  Caption := Application.Title + Caption;
  Result := ShowMsg(Msg, Caption, Icon, Buttons);
end;

procedure FreeAndNilTStringsAndObjects(var Strings);
var
  i: integer;
  list: TStrings;
begin
  list := TStrings(Strings);
  for I := 0 to List.Count - 1 do
    if assigned(list.Objects[i]) then
      list.Objects[i].Free;
  FreeAndNil(list);
  TStrings(Strings) := nil;
end;

function ProcessExists(exeFileName: string): Boolean;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  Result := False;
  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
      UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) =
      UpperCase(ExeFileName))) then
    begin
      Result := True;
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

{
TODO - This function will need to be retired in CPRS 32, and we'll need to migrate
everyone over to ScreenReaderSystemActive() instead.
}

var
  CheckScreenReaderSupport: boolean = TRUE;
  uScreenReaderSupportEnabled: boolean = FALSE;


function ScreenReaderActive: boolean;
var
 JawsParam: String;
begin
  result := uScreenReaderSupportEnabled;

  if not CheckScreenReaderSupport then
    exit;
  {
  We want to fall out of this a quickly as possible so we're not spending a lot
  of time looking for a process that probably won't exist.
  }

  CheckScreenReaderSupport := false; // we only want to do this check once.

  uScreenReaderSupportEnabled := FindCmdLineSwitch(JAWS_FORCED,true);
  if uScreenReaderSupportEnabled then
  begin
    result := uScreenReaderSupportEnabled;
    exit;
  end;


  uScreenReaderSupportEnabled := ProcessExists(JAWS_EXENAME);
  if uScreenReaderSupportEnabled then
  begin
    result := uScreenReaderSupportEnabled;
    exit;
  end;

  FindCmdLineSwitch(JAWS_CL_EXE_SW, JawsParam, True, [clstValueAppended]);
  JawsParam := trim(JawsParam);

   if JawsParam <> '' then
     uScreenReaderSupportEnabled := ProcessExists(JawsParam);
   result := uScreenReaderSupportEnabled;
end;

function OldScreenReaderActive: boolean;
var
  ListStateOn : longbool;
  Success: longbool;
begin
  //Determine if a screen reader is currently being used.
  Success := SystemParametersInfo(SPI_GETSCREENREADER, 0, @ListStateOn,0);
  Result := (Success and ListStateOn);
end;

function ScreenReaderSupportEnabled: boolean;
begin
  result := ScreenReaderActive;
end;

const
  DOTS = '...';
  DOTS_LEN = Length(DOTS) + 2;

// Returns C:\...\subPath\File format based on maxSize and Canvas font setting
function GetFileWithShortenedPath(FileName: String; MaxSize: integer; Canvas: TCanvas): string;
var
  len, count, p, first, last: integer;

begin
  Result := FileName;
  count := 0;
  p := 0;
  first := 0;
  last := 0;

  repeat
    p := PosEx('\', Result, p+1);
    if p > 0 then inc(count);
    if first = 0 then
    begin
      first := p;
      last := p+1;
    end;
  until p = 0;

  repeat
    len := Canvas.TextWidth(Result);
    if (len > MaxSize) and (count > 0) then
    begin
      if count > 1 then
      begin
        p := last;
        while(Result[p] <> '\') do inc(p);
        Result := copy(Result,1,first) + DOTS + copy(Result,p,MaxInt);
        last := first + DOTS_LEN;
      end
      else
        Result := copy(Result, last, MaxInt);
      dec(count);
    end;
  until (len <= MaxSize) or (count < 1);
end;

// returns an 8 digit hex number
function FastIntToHex(Value: LongWord): String;
var
  v: TFastIntHexRec;
begin
  v.lw:= Value;
  Result := HexChars[v.b4] + HexChars[v.b3] + HexChars[v.b2] + HexChars[v.b1];
end;

// returns an 4 digit hex number
function FastWordToHex(Value: Word): String;
var
  v: TFastWordHexRec;
begin
  v.w:= Value;
  Result := HexChars[v.b2] + HexChars[v.b1];
end;

const
  b1Mult = 1;
  b2Mult = b1Mult * 16;
  b3Mult = b2Mult * 16;
  b4Mult = b3Mult * 16;
  b5Mult = b4Mult * 16;
  b6Mult = b5Mult * 16;
  b7Mult = b6Mult * 16;
  b8Mult = b7Mult * 16;

// takes only a 2 digit value - 1 byte - from above table
function FastHexToByte(HexString: string): byte;
begin
  Result := ((pos(HexString[2], DigitTable) - 1) * b1Mult) +
            ((pos(HexString[1], DigitTable) - 1) * b2Mult);
end;

// takes only an 8 digit value - 4 bytes
function FastHexToInt(HexString: string): LongWord;
begin
  Result := ((pos(HexString[8], DigitTable) - 1) * b1Mult) +
            ((pos(HexString[7], DigitTable) - 1) * b2Mult) +
            ((pos(HexString[6], DigitTable) - 1) * b3Mult) +
            ((pos(HexString[5], DigitTable) - 1) * b4Mult) +
            ((pos(HexString[4], DigitTable) - 1) * b5Mult) +
            ((pos(HexString[3], DigitTable) - 1) * b6Mult) +
            ((pos(HexString[2], DigitTable) - 1) * b7Mult) +
            ((pos(HexString[1], DigitTable) - 1) * b8Mult);
end;

// converts a hex string to binary
function FastHexToBinary(HexString: string): string;
var
  i, len, val: integer;
  chr: string;
begin
  len := length(HexString);
  Result := '';
  for I := 1 to len do
  begin
    chr := HexString[i];
    val := pos(chr, DigitTable);
    if val > 0 then
      Result := Result + BinChars[val-1]
  end;
end;

const
{ copied from ORFn - table for calculating CRC values }
  CRC32_TABLE: array[0..255] of DWORD =
    ($0,       $77073096, $EE0E612C, $990951BA, $76DC419,  $706AF48F, $E963A535, $9E6495A3,
    $EDB8832,  $79DCB8A4, $E0D5E91E, $97D2D988, $9B64C2B,  $7EB17CBD, $E7B82D07, $90BF1D91,
    $1DB71064, $6AB020F2, $F3B97148, $84BE41DE, $1ADAD47D, $6DDDE4EB, $F4D4B551, $83D385C7,
    $136C9856, $646BA8C0, $FD62F97A, $8A65C9EC, $14015C4F, $63066CD9, $FA0F3D63, $8D080DF5,
    $3B6E20C8, $4C69105E, $D56041E4, $A2677172, $3C03E4D1, $4B04D447, $D20D85FD, $A50AB56B,
    $35B5A8FA, $42B2986C, $DBBBC9D6, $ACBCF940, $32D86CE3, $45DF5C75, $DCD60DCF, $ABD13D59,
    $26D930AC, $51DE003A, $C8D75180, $BFD06116, $21B4F4B5, $56B3C423, $CFBA9599, $B8BDA50F,
    $2802B89E, $5F058808, $C60CD9B2, $B10BE924, $2F6F7C87, $58684C11, $C1611DAB, $B6662D3D,
    $76DC4190, $1DB7106,  $98D220BC, $EFD5102A, $71B18589, $6B6B51F,  $9FBFE4A5, $E8B8D433,
    $7807C9A2, $F00F934,  $9609A88E, $E10E9818, $7F6A0DBB, $86D3D2D,  $91646C97, $E6635C01,
    $6B6B51F4, $1C6C6162, $856530D8, $F262004E, $6C0695ED, $1B01A57B, $8208F4C1, $F50FC457,
    $65B0D9C6, $12B7E950, $8BBEB8EA, $FCB9887C, $62DD1DDF, $15DA2D49, $8CD37CF3, $FBD44C65,
    $4DB26158, $3AB551CE, $A3BC0074, $D4BB30E2, $4ADFA541, $3DD895D7, $A4D1C46D, $D3D6F4FB,
    $4369E96A, $346ED9FC, $AD678846, $DA60B8D0, $44042D73, $33031DE5, $AA0A4C5F, $DD0D7CC9,
    $5005713C, $270241AA, $BE0B1010, $C90C2086, $5768B525, $206F85B3, $B966D409, $CE61E49F,
    $5EDEF90E, $29D9C998, $B0D09822, $C7D7A8B4, $59B33D17, $2EB40D81, $B7BD5C3B, $C0BA6CAD,
    $EDB88320, $9ABFB3B6, $3B6E20C,  $74B1D29A, $EAD54739, $9DD277AF, $4DB2615,  $73DC1683,
    $E3630B12, $94643B84, $D6D6A3E,  $7A6A5AA8, $E40ECF0B, $9309FF9D, $A00AE27,  $7D079EB1,
    $F00F9344, $8708A3D2, $1E01F268, $6906C2FE, $F762575D, $806567CB, $196C3671, $6E6B06E7,
    $FED41B76, $89D32BE0, $10DA7A5A, $67DD4ACC, $F9B9DF6F, $8EBEEFF9, $17B7BE43, $60B08ED5,
    $D6D6A3E8, $A1D1937E, $38D8C2C4, $4FDFF252, $D1BB67F1, $A6BC5767, $3FB506DD, $48B2364B,
    $D80D2BDA, $AF0A1B4C, $36034AF6, $41047A60, $DF60EFC3, $A867DF55, $316E8EEF, $4669BE79,
    $CB61B38C, $BC66831A, $256FD2A0, $5268E236, $CC0C7795, $BB0B4703, $220216B9, $5505262F,
    $C5BA3BBE, $B2BD0B28, $2BB45A92, $5CB36A04, $C2D7FFA7, $B5D0CF31, $2CD99E8B, $5BDEAE1D,
    $9B64C2B0, $EC63F226, $756AA39C, $26D930A,  $9C0906A9, $EB0E363F, $72076785, $5005713,
    $95BF4A82, $E2B87A14, $7BB12BAE, $CB61B38,  $92D28E9B, $E5D5BE0D, $7CDCEFB7, $BDBDF21,
    $86D3D2D4, $F1D4E242, $68DDB3F8, $1FDA836E, $81BE16CD, $F6B9265B, $6FB077E1, $18B74777,
    $88085AE6, $FF0F6A70, $66063BCA, $11010B5C, $8F659EFF, $F862AE69, $616BFFD3, $166CCF45,
    $A00AE278, $D70DD2EE, $4E048354, $3903B3C2, $A7672661, $D06016F7, $4969474D, $3E6E77DB,
    $AED16A4A, $D9D65ADC, $40DF0B66, $37D83BF0, $A9BCAE53, $DEBB9EC5, $47B2CF7F, $30B5FFE9,
    $BDBDF21C, $CABAC28A, $53B39330, $24B4A3A6, $BAD03605, $CDD70693, $54DE5729, $23D967BF,
    $B3667A2E, $C4614AB8, $5D681B02, $2A6F2B94, $B40BBE37, $C30C8EA1, $5A05DF1B, $2D02EF8D);

{ returns a cyclic redundancy check for a string }
function CRCForString(AString: string): DWORD;
var
  i: Integer;
begin
  Result:=$FFFFFFFF;
  for i := 1 to Length(AString) do
    Result:=((Result shr 8) and $00FFFFFF) xor
      CRC32_TABLE[(Result xor Ord(AString[i])) and $000000FF];
end;

function AppendBackSlash(var txt: string): string;
begin
  if RightStr(txt,1) <> '\' then
    txt := txt + '\';
  Result := txt;
end;

// returns special folder path on the current machine - such as Program Files etc
// the parameter is a CSIDL windows constant
function GetSpecialFolderPath(SpecialFolderCSIDL: integer): String;
var
  Path: array[0..Max_Path] of Char;
begin
  Path := '';
  SHGetSpecialFolderPath(0, Path, SpecialFolderCSIDL, false);
  Result := Path;
  AppendBackSlash(Result);
end;

// returns Program Files path on current machine
function GetProgramFilesPath: String;
begin
  Result := GetSpecialFolderPath(CSIDL_PROGRAM_FILES);
end;

// returns Program Files path on the drive where the currently running application
// resides, if it is a different drive than the one that contains the current
// machine's Program Files directory.  This is typically used for networked drives.
// Note that tnis only works if the mapping to the network is at the root drive
function GetAlternateProgramFilesPath: String;
var
  Dir, Dir2: string;

begin
  Dir := GetProgramFilesPath;
  Dir2 := ExtractFileDrive(Application.ExeName);
  AppendBackSlash(Dir2);
  Dir2 := Dir2 + 'Program Files\';
  If (UpperCase(Dir) = UpperCase(Dir2)) then
    Result := ''
  else
    Result := Dir2;
end;

// Get the Window title (Caption) of a window, given only it's handle
function GetWindowTitle(Handle: HWND): String;
begin
  SetLength(Result, 240);
  SetLength(Result, GetWindowText(Handle, PChar(Result), Length(Result)));
end;

function GetWindowClassName(Handle: HWND): String;
begin
  SetLength(Result, 240);
  SetLength(Result, GetClassName(Handle, PChar(Result), Length(Result)));
end;

type
(*
  TVACustomWinProcInterceptor = class
  private
    FOldWinProc: Pointer;
    FHexHandle: string;
    FComponent: TWinControl;
    procedure Initialize;
  protected
    constructor Create(Component: TWinControl); virtual;
    function NewWindowProc(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; virtual;
//    property OldWindowProc: Pointer read FOldWinProc;
//    property Component: TWinControl read FComponent;
  public
    destructor Destroy; override;
  end;
*)
(*
  TVAWinProcMessageHandler = class(TVACustomWinProcInterceptor)
  private
    FMessageHandlerList: TVAMethodList;
    function DoMessageHandlers(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM; var MessageHandled: boolean): LRESULT;
  protected
    constructor Create(Component: TWinControl); override;
    function NewWindowProc(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; override;
  public
    destructor Destroy; override;
    function HandlerCount: integer;
    procedure AddMessageHandler(event: TVAWinProcMessageEvent);
    procedure RemoveMessageHandler(event: TVAWinProcMessageEvent);
  end;
*)

  TVACustomMessageEventInterceptor = class
  private
    FOldWndMethod: TWndMethod;
    FComponent: TWinControl;
  protected
    constructor Create(Component: TWinControl); virtual;
    procedure NewMessageHandler(var Message: TMessage); virtual;
//    property OldWndMethod: TWndMethod read FOldWndMethod;
//    property Component: TWinControl read FComponent;
  public
    destructor Destroy; override;
  end;

  TVAMessageEventHandler = class(TVACustomMessageEventInterceptor)
  private
    FMessageHandlerList: TVAMethodList;
    procedure DoMessageHandlers(var Message: TMessage; var MessageHandled: boolean);
  protected
    constructor Create(Component: TWinControl); override;
    procedure NewMessageHandler(var Message: TMessage); override;
  public
    destructor Destroy; override;
    function HandlerCount: integer;
    procedure AddMessageHandler(event: TVAMessageEvent);
    procedure RemoveMessageHandler(event: TVAMessageEvent);
  end;

(*
  TVAWinProcAccessClass = class(TWinControl)
  public
    property DefWndProc;
  end;
*)

  TVAWinProcMonitor = class(TComponent)
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    procedure RemoveFromList(AComponent: TComponent);
  end;


var
//  uWinProcMessageHandlers: TStringList = nil;
  uEventMessageHandlers: TStringList = nil;
  uHandlePointers: TStringlist = nil;
  uWinProcMonitor: TVAWinProcMonitor = nil;
  uMessageHandlerSystemRunning: boolean = FALSE;

procedure InitializeMessageHandlerSystem;
begin
  if not uMessageHandlerSystemRunning then
  begin
//    uWinProcMessageHandlers := TStringList.Create;
//    uWinProcMessageHandlers.Sorted := TRUE;
//    uWinProcMessageHandlers.Duplicates := dupAccept;
    uEventMessageHandlers := TStringList.Create;
    uEventMessageHandlers.Sorted := TRUE;
    uEventMessageHandlers.Duplicates := dupAccept;
    uHandlePointers := TStringList.Create;
    uHandlePointers.Sorted := TRUE;  // allows for faster binary searching
    uHandlePointers.Duplicates := dupAccept;
    uWinProcMonitor := TVAWinProcMonitor.Create(nil);
    uMessageHandlerSystemRunning := TRUE;
  end;
end;

procedure CleanupMessageHandlerSystem;

  procedure Clear(var list: TStringList; FreeObjects: boolean = false);
  var
    i: integer;
  begin
    if assigned(list) then
    begin
      if FreeObjects then
      begin
        for I := 0 to list.Count - 1 do
          list.Objects[i].Free;
      end;
      FreeAndNil(list);
    end;
  end;

begin
//  Clear(uWinProcMessageHandlers, TRUE);
  Clear(uEventMessageHandlers, TRUE);
  Clear(uHandlePointers);
  if assigned(uWinProcMonitor) then
    FreeAndNil(uWinProcMonitor);
  uMessageHandlerSystemRunning := FALSE;
end;

(*
procedure AddMessageHandler(Control: TWinControl; MessageHandler: TVAWinProcMessageEvent);
var
  HexID: string;
  idx: integer;
  Handler: TVAWinProcMessageHandler;

begin
  InitializeMessageHandlerSystem;
  HexID := FastIntToHex(LongWord(Control));
  idx := uWinProcMessageHandlers.IndexOf(HexID);
  if idx < 0 then
  begin
    Handler := TVAWinProcMessageHandler.Create(Control);
    uWinProcMessageHandlers.AddObject(HexID, Handler);
  end
  else
    Handler := TVAWinProcMessageHandler(uWinProcMessageHandlers.Objects[idx]);
  Handler.AddMessageHandler(MessageHandler);
end;
*)

procedure AddMessageHandler(Control: TWinControl; MessageHandler: TVAMessageEvent);
var
  HexID: string;
  idx: integer;
  Handler: TVAMessageEventHandler;

begin
  InitializeMessageHandlerSystem;
  HexID := FastIntToHex(LongWord(Control));
  idx := uEventMessageHandlers.IndexOf(HexID);
  if idx < 0 then
  begin
    Handler := TVAMessageEventHandler.Create(Control);
    uEventMessageHandlers.AddObject(HexID, Handler);
  end
  else
    Handler := TVAMessageEventHandler(uEventMessageHandlers.Objects[idx]);
  Handler.AddMessageHandler(MessageHandler);
end;

(*
procedure RemoveMessageHandler(Control: TWinControl;
                            MessageHandler: TVAWinProcMessageEvent);
var
  HexID: string;
  idx: integer;
  Handler: TVAWinProcMessageHandler;

begin
  if not uMessageHandlerSystemRunning then exit;
  HexID := FastIntToHex(LongWord(Control));
  idx := uWinProcMessageHandlers.IndexOf(HexID);
  if idx >= 0 then
  begin
    Handler := TVAWinProcMessageHandler(uWinProcMessageHandlers.Objects[idx]);
    Handler.RemoveMessageHandler(MessageHandler);
    if Handler.HandlerCount = 0 then
    begin
      Handler.Free;
      uWinProcMessageHandlers.Delete(idx);
    end;
  end;
end;
*)

procedure RemoveMessageHandler(Control: TWinControl; MessageHandler: TVAMessageEvent);
var
  HexID: string;
  idx: integer;
  Handler: TVAMessageEventHandler;

begin
  if not uMessageHandlerSystemRunning then exit;
  HexID := FastIntToHex(LongWord(Control));
  idx := uEventMessageHandlers.IndexOf(HexID);
  if idx >= 0 then
  begin
    Handler := TVAMessageEventHandler(uEventMessageHandlers.Objects[idx]);
    Handler.RemoveMessageHandler(MessageHandler);
    if Handler.HandlerCount = 0 then
    begin
      Handler.Free;
      uEventMessageHandlers.Delete(idx);
    end;
  end;
end;

procedure RemoveAllMessageHandlers(Control: TWinControl);
var
  HexID: string;
  idx: integer;
//  Handler: TVAWinProcMessageHandler;
  EventHandler: TVAMessageEventHandler;

begin
  if not uMessageHandlerSystemRunning then exit;
  HexID := FastIntToHex(LongWord(Control));

  (*
  idx := uWinProcMessageHandlers.IndexOf(HexID);

  if idx >= 0 then
  begin
    Handler := TVAWinProcMessageHandler(uWinProcMessageHandlers.Objects[idx]);
    Handler.Free;
    uWinProcMessageHandlers.Delete(idx);
  end;
  *)

  idx := uEventMessageHandlers.IndexOf(HexID);
  if idx >= 0 then
  begin
    EventHandler := TVAMessageEventHandler(uEventMessageHandlers.Objects[idx]);
    EventHandler.Free;
    uEventMessageHandlers.Delete(idx);
  end;

  Control.RemoveFreeNotification(uWinProcMonitor);
end;

function MessageHandlerCount(Control: TWinControl): integer;
var
  HexID: string;
  idx: integer;
//  Handler: TVAWinProcMessageHandler;
  EventHandler: TVAMessageEventHandler;

begin
  Result := 0;
  if not uMessageHandlerSystemRunning then exit;

  HexID := FastIntToHex(LongWord(Control));

(*  idx := uWinProcMessageHandlers.IndexOf(HexID);

  if idx >= 0 then
  begin
    Handler := TVAWinProcMessageHandler(uWinProcMessageHandlers.Objects[idx]);
    result := Handler.HandlerCount;
  end;
*)

  idx := uEventMessageHandlers.IndexOf(HexID);
  if idx >= 0 then
  begin
    EventHandler := TVAMessageEventHandler(uEventMessageHandlers.Objects[idx]);
    inc(Result, EventHandler.HandlerCount);
  end;
end;

 { TVACustomWinProc }

(*
constructor TVACustomWinProcInterceptor.Create(Component: TWinControl);
begin
  if not Assigned(Component) then
    raise EInvalidPointer.Create('Component parameter unassigned');
  FComponent := Component;
  Initialize;
end;

destructor TVACustomWinProcInterceptor.Destroy;
var
  idx: integer;
begin
  if Assigned(FComponent) then
  begin
    try
      TVAWinProcAccessClass(FComponent).DefWndProc := FOldWinProc;
    except // just in case FComponent has been destroyed
    end;
  end;
  idx := uHandlePointers.IndexOf(FHexHandle);
  if idx >= 0 then
    uHandlePointers.Delete(idx);
  inherited;
end;

function TVACustomWinProcInterceptor.NewWindowProc(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT;
begin
{
  if (Msg = SOME_MESSAGE) then
  begin
    ...
    Result := S_OK;
  end
  else
}
  Result := CallWindowProc(FOldWinProc, hWnd, Msg, WParam, LParam);
end;


function BaseWindowProc(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
var
  idx: integer;

begin
  idx := uHandlePointers.IndexOf(FastIntToHex(hWnd)); // does binary search on sorted string list
  if idx >= 0 then
    Result := TVACustomWinProcInterceptor(uHandlePointers.Objects[idx]).NewWindowProc(hWnd, Msg, wParam, lParam)
  else
    Result := 0; // should never happen
end;

procedure TVACustomWinProcInterceptor.Initialize;
var
  idx: integer;
begin
  InitializeMessageHandlerSystem;
  FComponent.HandleNeeded;
  FHexHandle := FastIntToHex(FComponent.Handle);
  idx := uHandlePointers.IndexOf(FHexHandle);
  if idx < 0 then
    uHandlePointers.AddObject(FHexHandle, Self)
  else
    uHandlePointers.Objects[idx] := Self;
  FComponent.FreeNotification(uWinProcMonitor);
  FOldWinProc := TVAWinProcAccessClass(FComponent).DefWndProc;
  TVAWinProcAccessClass(FComponent).DefWndProc := @BaseWindowProc;
end;
*)

{ TVAWinProcMonitor }


// assumes object is responsible for deleting instance of TVACustomWinProc
procedure TVAWinProcMonitor.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent is TWinControl) then
    RemoveFromList(AComponent);
end;

procedure TVAWinProcMonitor.RemoveFromList(AComponent: TComponent);
begin
  if AComponent is TWinControl then
    RemoveAllMessageHandlers(TWinControl(AComponent));
end;


{ TVACustomMessageEventInterceptor }

constructor TVACustomMessageEventInterceptor.Create(Component: TWinControl);
begin
  if not Assigned(Component) then
    raise EInvalidPointer.Create('Component parameter unassigned');
  FComponent := Component;
  FComponent.FreeNotification(uWinProcMonitor);
  FOldWndMethod := FComponent.WindowProc;
  FComponent.WindowProc := NewMessageHandler;
end;

destructor TVACustomMessageEventInterceptor.Destroy;
begin
  FComponent.WindowProc := FOldWndMethod;
  inherited;
end;

procedure TVACustomMessageEventInterceptor.NewMessageHandler(
  var Message: TMessage);
begin
  FOldWndMethod(Message);
end;

{ TVAWinProcNotifier }

(*
procedure TVAWinProcMessageHandler.AddMessageHandler(event: TVAWinProcMessageEvent);
begin
  FMessageHandlerList.Add(TMethod(event));
end;

constructor TVAWinProcMessageHandler.Create(Component: TWinControl);
begin
  FMessageHandlerList := TVAMethodList.Create;
  inherited Create(Component);
end;

destructor TVAWinProcMessageHandler.Destroy;
begin
  inherited;
  FMessageHandlerList.Free;
end;

function TVAWinProcMessageHandler.DoMessageHandlers(hWnd: HWND; Msg: UINT;
          wParam: WPARAM; lParam: LPARAM; var MessageHandled: boolean): LRESULT;
var
  Method: TMethod;
  i: integer;
begin
  MessageHandled := FALSE;
  Result := 0;
  for i := 0 to FMessageHandlerList.Count - 1 do
  begin
    Method := FMessageHandlerList[i];
    Result := TVAWinProcMessageEvent(Method)(hWnd, Msg, wParam, lParam, MessageHandled);
    if MessageHandled then
      break;
  end;
end;

function TVAWinProcMessageHandler.HandlerCount: integer;
begin
  Result := FMessageHandlerList.Count;
end;

function TVAWinProcMessageHandler.NewWindowProc(hWnd: HWND; Msg: UINT; wParam: WPARAM;
  lParam: LPARAM): LRESULT;
var
  MessageHandled: boolean;

begin
  Result := DoMessageHandlers(hWnd, Msg, wParam, lParam, MessageHandled);
  if not MessageHandled then
    Result := CallWindowProc(FOldWinProc, hWnd, Msg, WParam, LParam);
end;

procedure TVAWinProcMessageHandler.RemoveMessageHandler(event: TVAWinProcMessageEvent);
begin
  FMessageHandlerList.Remove(TMethod(event));
end;
*)

{ TVAMessageEventHandler }

procedure TVAMessageEventHandler.AddMessageHandler(event: TVAMessageEvent);
begin
  FMessageHandlerList.Add(TMethod(event));
end;

constructor TVAMessageEventHandler.Create(Component: TWinControl);
begin
  FMessageHandlerList := TVAMethodList.Create;
  inherited Create(Component);
end;

destructor TVAMessageEventHandler.Destroy;
begin
  inherited;
  FMessageHandlerList.Free;
end;

procedure TVAMessageEventHandler.DoMessageHandlers(var Message: TMessage;
    var MessageHandled: boolean);
var
  Method: TMethod;
  i: integer;

begin
  MessageHandled := FALSE;
  for i := 0 to FMessageHandlerList.Count - 1 do
  begin
    Method := FMessageHandlerList[i];
    TVAMessageEvent(Method)(Message, MessageHandled);
    if MessageHandled then
      break;
  end;
end;

function TVAMessageEventHandler.HandlerCount: integer;
begin
  Result := FMessageHandlerList.Count;
end;

procedure TVAMessageEventHandler.NewMessageHandler(var Message: TMessage);
var
  MessageHandled: boolean;

begin
  DoMessageHandlers(Message, MessageHandled);
  if not MessageHandled then
    FOldWndMethod(Message);
end;

procedure TVAMessageEventHandler.RemoveMessageHandler(event: TVAMessageEvent);
begin
  FMessageHandlerList.Remove(TMethod(event));
end;



type
  TDataArray = record
  private
    FCapacity: integer;
    procedure SetCapacity(Value: integer);
  public
    Data: array of DWORD;
    Count: integer;
    procedure Clear;
    function Size: integer;
    property Capacity: integer read FCapacity write SetCapacity;
  end;

{ TDataArray }

procedure TDataArray.Clear;
begin
  SetCapacity(0);
  SetCapacity(128);
end;

procedure TDataArray.SetCapacity(Value: integer);
begin
  if FCapacity <> Value then
  begin
    FCapacity := Value;
    SetLength(Data, Value);
    if Count >= Value then
      Count := Value - 1;
  end;
end;


function TDataArray.Size: integer;
begin
  Result := FCapacity * SizeOf(DWORD);
end;

var
  PIDList: TDataArray;
  ModuleHandles: TDataArray;

function GetInstanceCount(ApplicationNameAndPath: string): integer; overload;
var
  i, j: DWORD;
  name: string;
  process: THandle;
  Output: DWORD;
  current: string;
  ok: BOOL;
  done: boolean;

  function ListTooSmall(var Data: TDataArray): boolean;
  var
    ReturnCount: integer;
  begin
    Data.Count := 0;
    ReturnCount := Output div SizeOf(DWORD);
    Result := (ReturnCount >= Data.Capacity);
    if Result then
      Data.Capacity := Data.Capacity * 2
    else
      Data.Count := ReturnCount;
  end;

begin
  Result := 0;
  current := UpperCase(ApplicationNameAndPath);
  PIDList.Clear;
  repeat
    done := TRUE;
    ok := EnumProcesses(pointer(PIDList.Data), PIDList.Size, Output);
    if ok and ListTooSmall(PIDList) then
      done := FALSE;
  until done or (not ok);
  if ok then
  begin
    for I := 0 to PIDList.Count - 1 do
    begin
      Process := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, FALSE, PIDList.Data[i]);
      if Process <> 0 then
      begin
        try
          ModuleHandles.Clear;
          repeat
            done := TRUE;
            ok := EnumProcessModules(Process, Pointer(ModuleHandles.Data), ModuleHandles.Size, Output);
            if ok and ListTooSmall(ModuleHandles) then
              done := FALSE;
          until done or (not ok);
          if ok then
          begin
            for j := 0 to ModuleHandles.Count - 1 do
            begin
              SetLength(name, MAX_PATH*2);
              SetLength(name, GetModuleFileNameEx(Process, ModuleHandles.Data[j], PChar(name), MAX_PATH*2));
              name := UpperCase(name);
              if name = current then
              begin
                inc(Result);
                break;
              end;
            end;
          end;
        finally
          CloseHandle(Process);
        end;
      end;
    end;
  end;
  PIDList.SetCapacity(0);
  ModuleHandles.SetCapacity(0);
end;


function GetInstanceCount: integer;
begin
  Result := GetInstanceCount(ParamStr(0));
end;

function AnotherInstanceRunning: boolean;
begin
  Result := (GetInstanceCount > 1);
end;

procedure VersionStringSplit(const VerStr: string; var Val1: integer);
var
  dummy2, dummy3, dummy4: integer;
begin
  VersionStringSplit(VerStr, Val1, dummy2, dummy3, dummy4);
end;

procedure VersionStringSplit(const VerStr: string; var Val1, Val2: integer);
var
  dummy3, dummy4: integer;
begin
  VersionStringSplit(VerStr, Val1, Val2, dummy3, dummy4);
end;

procedure VersionStringSplit(const VerStr: string; var Val1, Val2, Val3: integer);
var
  dummy4: integer;
begin
  VersionStringSplit(VerStr, Val1, Val2, Val3, dummy4);
end;

procedure VersionStringSplit(const VerStr: string; var Val1, Val2, Val3, Val4: integer);
var
  temp: string;

  function GetNum: integer;
  var
    idx: integer;

  begin
    idx := pos('.', temp);
    if idx < 1 then
      idx := Length(temp) + 1;
    Result := StrToIntDef(copy(temp, 1, idx-1), 0);
    delete(temp, 1, idx);
  end;

begin
  temp := VerStr;
  Val1 := GetNum;
  Val2 := GetNum;
  Val3 := GetNum;
  Val4 := GetNum;
end;

const
  FILE_VER_PREFIX = '\StringFileInfo\';
//  FILE_VER_COMMENTS         = '\StringFileInfo\040904E4\Comments';

function FileVersionValue(const AFileName, AValueName: string): string;
type
  TValBuf = array[0..255] of Char;
  PValBuf = ^TValBuf;

var
  VerSize, ValSize, AHandle: DWORD;
  VerBuf: Pointer;
  ValBuf: PValBuf;
  Output, Query: string;
  POutput: PChar;
begin
  Result := '';
  VerSize:=GetFileVersionInfoSize(PChar(AFileName), AHandle);
  if VerSize > 0 then
  begin
    GetMem(VerBuf, VerSize);
    try
      GetFileVersionInfo(PChar(AFileName), AHandle, VerSize, VerBuf);
      VerQueryValue(VerBuf, PChar('\VarFileInfo\Translation'), Pointer(ValBuf), ValSize);
      Query := FILE_VER_PREFIX + IntToHex(LoWord(PLongInt(ValBuf)^),4)+
                               IntToHex(HiWord(PLongInt(ValBuf)^),4)+
                               '\'+AValueName;
      VerQueryValue(VerBuf, PChar(Query), Pointer(ValBuf), ValSize);
      SetString(Output, ValBuf^, ValSize);
      POutput := PChar(Output);
      Result := POutput;
    finally
      FreeMem(VerBuf);
    end;
  end;
end;

// compares up to 4 pieces of a numeric version, returns true if CheckVersion is >= OriginalVersion
// allows for . and , delimited version numbers
function VersionOK(OriginalVersion, CheckVersion: string): boolean;
var
  v1, v2, v3, v4, r1, r2, r3, r4: Integer;

  function GetV(var Version: string): integer;
  var
    idx: integer;
    delim: string;
  begin
    if pos('.', Version) > 0 then
      delim := '.'
    else
      delim := ',';
    idx := pos(delim, version);
    if idx < 1 then
      idx := length(Version) + 1;
    Result := StrToIntDef(copy(version, 1, idx-1), 0);
    delete(version, 1, idx);
  end;

  procedure parse(const v: string; var p1, p2, p3, p4: integer);
  var
    version: string;
  begin
    version := v;
    p1 := GetV(version);
    p2 := GetV(version);
    p3 := GetV(version);
    p4 := GetV(version);
  end;

begin
  parse(OriginalVersion, r1, r2, r3, r4);
  parse(CheckVersion, v1, v2, v3, v4);
  Result := FALSE;
  if v1 > r1 then
    Result := TRUE
  else if v1 = r1 then
  begin
    if v2 > r2 then
      Result := TRUE
    else if v2 = r2 then
    begin
      if v3 > r3 then
        Result := TRUE
      else if v3 = r3 then
      begin
        if v4 >= r4 then
          Result := TRUE
      end;
    end;
  end;
end;

function ExecuteAndWait(FileName: string; Parameters: String = ''): integer;
var
  exec, shell: OleVariant;
  line: string;

begin
  if copy(FileName,1,1) <> '"' then
    line := '"' + FileName + '"'
  else
    line := FileName;
  if Parameters <> '' then
    line := line + ' ' + Parameters;
  shell := CreateOleObject('WScript.Shell');
  try
   exec := shell.Exec(line);
    try
      While exec.status = 0 do
        Sleep(100);
     // ShowMsg(exec.StdOut);
      Result := Exec.ExitCode;
    finally
      VarClear(exec);
    end;
  finally
    VarClear(shell);
  end;
end;

function ExecuteAndWait(FileName: string; var ReturnMsg: string; Parameters: String = ''): integer;
var
  exec, shell: OleVariant;
  line: string;

begin
  if copy(FileName,1,1) <> '"' then
    line := '"' + FileName + '"'
  else
    line := FileName;
  if Parameters <> '' then
    line := line + ' ' + Parameters;
  shell := CreateOleObject('WScript.Shell');
  try
   exec := shell.Exec(line);
    try
      While exec.status = 0 do
        Sleep(100);
       // Get the application's StdOut stream
       ReturnMsg := exec.StdOut.ReadAll;

      Result := Exec.ExitCode;
    finally
      VarClear(exec);
    end;
  finally
    VarClear(shell);
  end;
end;

{
function ExecuteAndWait(FileName: string; Parameters: String = ''): DWORD;
var
  SEI:TShellExecuteInfo;
begin
  FillChar(SEI,SizeOf(SEI),0);
  with SEI do begin
    cbSize:=SizeOf(SEI);
    lpVerb:='open';
    lpFile:=PAnsiChar(FileName);
    lpDirectory := PAnsiChar(ExtractFileDir(FileName));
    if Parameters <> '' then
      lpParameters := PAnsiChar(Parameters);
    nShow:=SW_SHOW;
    fMask:=SEE_MASK_NOCLOSEPROCESS;
  end;
  ShellExecuteEx(@SEI);
  WaitForSingleObject(SEI.hProcess, INFINITE);
  if not GetExitCodeProcess(SEI.hProcess, Result) then
    Result := 0;
  CloseHandle(SEI.hProcess);
end;
 }

function RunSilentCmd(const CommanLine: string; const ParameterLine: string; out ReturnMessage: String): boolean;
var
  SecAttr: TSecurityAttributes;
  StrtUpInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  StdOutPipeRead, StdOutPipeWrite: THandle;
  Buffer: array[0..255] of AnsiChar;
  BytesRead: Cardinal;
  FileOK: Boolean;
  fCmndLne, fParamLn: string;
begin
  ReturnMessage := '';
  if Pos('"', CommanLine) <> 1 then
    fCmndLne := AnsiQuotedStr(CommanLine, '"')
  else
   fCmndLne := CommanLine;
  UniqueString(fCmndLne);

  if Pos('"', ParameterLine) <> 1 then
    fParamLn := AnsiQuotedStr(ParameterLine, '"')
  else
   fParamLn := ParameterLine;
  UniqueString(fParamLn);

  //Init Security
  SecAttr.nLength := SizeOf(SecAttr);
  SecAttr.lpSecurityDescriptor := nil;
  SecAttr.bInheritHandle := True;

  CreatePipe(StdOutPipeRead, StdOutPipeWrite, @SecAttr, 0);
  try
    FillChar(StrtUpInfo, SizeOf(StrtUpInfo), 0);
    StrtUpInfo.cb := SizeOf(StrtUpInfo);
    StrtUpInfo.dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
    StrtUpInfo.wShowWindow := SW_HIDE;
    StrtUpInfo.hStdInput := GetStdHandle(STD_INPUT_HANDLE);
    StrtUpInfo.hStdOutput := StdOutPipeWrite;
    StrtUpInfo.hStdError := StdOutPipeWrite;

    ZeroMemory(@ProcessInfo, SizeOf(TProcessInformation));

    Result := CreateProcessW(nil, PWideChar(fCmndLne + ' ' + fParamLn), nil, nil, True, 0, nil, nil, StrtUpInfo, ProcessInfo);
    CloseHandle(StdOutPipeWrite);
    if Result then
    begin
      try
        repeat
          FileOK := ReadFile(StdOutPipeRead, Buffer, 255, BytesRead, nil);
          if BytesRead > 0 then
          begin
            Buffer[BytesRead] := #0;
            ReturnMessage := ReturnMessage + String(Buffer);
          end;
        until not FileOK or (BytesRead = 0);
        WaitForSingleObject(ProcessInfo.hProcess, INFINITE);
      finally
        CloseHandle(ProcessInfo.hThread);
        CloseHandle(ProcessInfo.hProcess);
      end;
    end else begin
     ReturnMessage := 'CreateProcess failed with error "' + SysErrorMessage(GetLastError) + '".';
    end;
  finally
    CloseHandle(StdOutPipeRead);
  end;
end;


// when called inside a DLL, returns the fully qualified name of the DLL file
// must pass an address or a class or procedure that's been defined inside the DLL
function GetDLLFileName(Address: Pointer): string;
var
  ProcessHandle: THandle;
  Output: DWORD;
  i, max: integer;
  ModuleHandles: array[0..1023] of HMODULE;
  info: _MODULEINFO;
  pinfo: LPMODULEINFO;
  adr: Int64;

begin
  Result := '';
  ProcessHandle := GetCurrentProcess;
  if EnumProcessModules(ProcessHandle, @ModuleHandles, sizeof(ModuleHandles), output) then
  begin
    adr := Int64(Address);
    max := (output div sizeof(HMODULE))-1;
    pinfo := @info;
    for i := 0 to max do
    begin
      if GetModuleInformation(ProcessHandle, ModuleHandles[i], pinfo, sizeof(_MODULEINFO)) then
      begin
        if (adr > Int64(info.lpBaseOfDll)) and (adr < (Int64(info.lpBaseOfDll) + info.SizeOfImage)) then
        begin
          SetLength(Result, MAX_PATH);
          SetLength(Result, GetModuleFileName(ModuleHandles[i], PChar(Result), Length(Result)));
          break;
        end;
      end;
    end;
  end;
end;

{ WidthInPixels }
function WidthInPixels(AFont:TFont; Value: string): integer;
var
  DC: HDC;          // working drawing context
  SaveFont: HFont;  // current font
  Extent: TSize;    // stores size of text sent to context
begin
  DC := GetDC(0);                                                         // get the drawing context of main window
  try
    SaveFont := SelectObject(DC, AFont.Handle);                           // save the current font and replace with passed font
    try
    {$Ifdef VER180}
     GetTextExtentPoint32(DC, PAnsiChar(Value), length(Value), Extent);  // evaluate text in context
    {$Else}
       GetTextExtentPoint32(DC, PWideChar(Value), length(Value), Extent);  // evaluate text in context
    {$EndIf}
      Result := Extent.cx + 1;                                            // grab the width
    finally
      SelectObject(DC, SaveFont);                                         // restore the current font
    end;
  finally
    ReleaseDC(0, DC);                                                     // release the drawing context
  end;
end;

{ HeightInPixels }
function HeightInPixels(AFont: TFont): integer;
var
  DC: HDC;                  // working drawing context
  SaveFont: HFont;          // current font
  FontMetrics: TTextMetric; // metric to contain information about passed font
begin
  DC := GetDC(0);                               // get the drawing context
  try
    SaveFont := SelectObject(DC, AFont.Handle); // save current font and replace with passed one
    try
      GetTextMetrics(DC, FontMetrics);          // get the metrics on the passed font
      Result := FontMetrics.tmHeight;           // return the height metric
    finally
      SelectObject(DC, SaveFont);               // restore current font
    end;
  finally
    ReleaseDC(0, DC);                           // release the drawing context
  end;
end;


//Add functionality from XE3
function D2006FindCmdLineSwitch(const Switch: string; var Value: string; IgnoreCase: Boolean = True;
  const SwitchTypes: TD2006CmdLineSwitchTypes = [clstD2006ValueNextParam, clstD2006ValueAppended]): Boolean;
type
  TCompareProc = function(const S1, S2: string): Boolean;
var
  Param: string;
  I, ValueOfs,
  SwitchLen, ParamLen: Integer;
  SameSwitch: TCompareProc;
begin
  Result := False;
  Value := '';
  if IgnoreCase then
    SameSwitch := SameText else
    SameSwitch := SameStr;
  SwitchLen := Length(Switch);

  for I := 1 to ParamCount do
  begin
    Param := ParamStr(I);

//    if (Param[1] in SwitchChars) and  SameSwitch(System.Copy(Param, 2, SwitchLen), Switch) then
    if CharInSet(Param[1], SwitchChars) and  SameSwitch(System.Copy(Param, 2, SwitchLen), Switch) then
    begin
      ParamLen := Length(Param);
      // Look for an appended value if the param is longer than the switch
      if (ParamLen > SwitchLen + 1) then
      begin
        // If not looking for appended value switches then this is not a matching switch
        if not (clstD2006ValueAppended in SwitchTypes) then
          Continue;
        ValueOfs := SwitchLen + 1;
        if Param[ValueOfs + 1] = ':' then
          Inc(ValueOfs);
        Value := System.Copy(Param, ValueOfs + 1, MaxInt);
      end
      // If the next param is not a switch, then treat it as the value
      else if (clstD2006ValueNextParam in SwitchTypes) and (I < ParamCount) and
              not CharInSet(ParamStr(I+1)[1], SwitchChars) then
//              not (ParamStr(I+1)[1] in SwitchChars) then

        Value := ParamStr(I+1);
      Result := True;
      Break;
    end;
  end;
end;

function CountStringOccurrences(const aSubStr, aStr: String; aCutOff: Integer = -1): integer;
var
  Offset: integer;

begin
  result := 0;
  offset := PosEx(aSubStr, aStr, 1);
  while offset > 0 do
  begin
    if (aCutOff > -1) and (offset > aCutOff) then
      exit;
    inc(result);
    offset := PosEx(aSubStr, aStr, offset + length(aSubStr));
  end;
end;

//Return text from the Lines with out non existent EOL markers
function TStringsHelper.RawText: String;

//Mirror of Load from base class except output is string
Function Load(Stream: TStream; Encoding: TEncoding): String;
var
  Size: Integer;
  Buffer: TBytes;
begin
  BeginUpdate;
  try
    Size := Stream.Size - Stream.Position;
    SetLength(Buffer, Size);
    Stream.Read(Buffer, 0, Size);
    Size := TEncoding.GetBufferEncoding(Buffer, Encoding, DefaultEncoding);
    SetEncoding(Encoding); // Keep Encoding in case the stream is saved
    result := Encoding.GetString(Buffer, Size, Length(Buffer) - Size);
  finally
    EndUpdate;
  end;
end;

var
  Stream: TStream;
begin
  Stream := TMemoryStream.Create;
  try
    SaveToStream(Stream, Encoding);
    Stream.Position := 0;
    Result := Load(Stream, Encoding);
  finally
    Stream.Free;
  end;
end;

function Pluralize(Count: Integer; const Singular: string; const Plural: string;
  const Args: array of const): string; overload;
// This function returns singular or plural of a word or phrase based on the
//   value of count.
// Count is the number you want to pluralize for
// Singular is the expression to be used when count = 1
// Plural is the expression to be used when count <> 1 (also for 0!)
//   If Plural is an empty string, Singular + s is returned.
// Args are the arguments to be used if Singular and/or Plural are format
//   strings. See the Delphi Help on Format. If no Args are submitted ([]),
//   the function will try to format with the integer Count as the only
//   argument.
// Example of use:
//   ShowMessage(Pluralize(AOrderCount, 'Order %0:d %2:s knife',
//     'Order %0:d %1:s knives', [AOrderCount, 'new', 'old']));
var
  S: string;
begin
  case Count of
    1: S := Singular;
  else
    begin
      if Plural = '' then
        S := Singular + 's'
      else
        S := Plural;
    end;
  end;
  if Length(Args) = 0 then
    Result := Format(S, [Count])
  else
    Result := Format(S, Args);
end;

function Pluralize(Count: Integer; const Singular: string;
  const Args: array of const): string; overload;
// See Pluralize above for a description of the function and parameters
// Example of use:
//   ShowMessage(Pluralize(AOrderCount, 'Order %0:d %1:s utensil',
//     [AOrderCount, 'new']));
begin
  Result := Pluralize(Count, Singular, '', Args);
end;

function Pluralize(Count: Integer; const Singular: string;
  const Plural: string = ''): string; overload;
// See Pluralize above for a description of the function and parameters
// Examples of use:
//   ShowMessage(Pluralize(AOrderCount, 'Order %0:d utensil'));
//   ShowMessage(Pluralize(AOrderCount, 'Order %0:d knife',
//     'Order %0:d knives'));
begin
  Result := Pluralize(Count, Singular, Plural, []);
end;

function ShouldFocus(Control: TWinControl): boolean;
var
  Form: TCustomForm;

begin
  Result := False;
  if assigned(Control) and (not(csDestroying in Control.ComponentState)) then
  begin
    Form := GetParentForm(Control);
    if assigned(Form) then
    begin
      // (Form.Active and (not Form.Visible)) can happen when SetForegroundWindow
      // is called before Show or ShowModal
      if (fsCreating in Form.FormState) or (csLoading in Form.ComponentState) or
        (csLoading in Control.ComponentState) or (Form.Active and (not Form.Visible)) or
        ((not Form.Visible) and Form.ClassNameIs('TMessageForm')) then
        Result := True
      else if Form.Enabled and Form.Visible and
        (not(csDestroying in Form.ComponentState)) then
        Result := Control.CanFocus;
    end;
  end;
end;

procedure ForceRectInsideWorkArea(var Rect: TRect; WinControl: TWinControl = nil);
var
  Frame: TRect;
begin
  if assigned(WinControl) then
    Frame := Screen.MonitorFromWindow(WinControl.Handle).WorkAreaRect
  else
    Frame := Screen.WorkAreaRect;
  // Vertical version:
  // Align bottom (preserving height) if needed
  if Rect.Bottom > Frame.Bottom then
  begin
    Rect.Top := Rect.Top + Frame.Bottom - Rect.Bottom;
    Rect.Bottom := Frame.Bottom;
  end;
  // Then align top (preserving height) if needed
  if Rect.Top < Frame.Top then
  begin
    Rect.Bottom := Rect.Bottom + Frame.Top - Rect.Top;
    Rect.Top := Frame.Top;
  end;
  // Now shrink (preserving top) if needed
  if Rect.Bottom > Frame.Bottom then
    Rect.Bottom := Frame.Bottom;
  if Rect.Top < Frame.Top then
    Rect.Top := Frame.Top;
  // Horizontal version:
  if Rect.Right > Frame.Right then
  begin
    Rect.Left := Rect.Left + Frame.Right - Rect.Right;
    Rect.Right := Frame.Right;
  end;
  if Rect.Left < Frame.Left then
  begin
    Rect.Right := Rect.Right + Frame.Left - Rect.Left;
    Rect.Left := Frame.Left;
  end;
  if Rect.Right > Frame.Right then
    Rect.Right := Frame.Right;
  if Rect.Left < Frame.Left then
    Rect.Left := Frame.Left;
end;

initialization
  ScreenReaderSupportEnabled;
finalization
  CleanupMessageHandlerSystem;
end.
