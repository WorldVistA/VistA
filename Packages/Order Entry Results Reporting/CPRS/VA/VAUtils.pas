{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}
{$WARN UNSAFE_TYPE OFF}

unit VAUtils;

{TODO  -oJeremy Merrill -cMessageHandlers : Change component list to use hex address for uComponentList
search instead of IndexOfObject, so that it used a binary search
on sorted text.}

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, StrUtils, Controls, VAClasses, Forms,
  SHFolder, ShlObj, PSAPI, ShellAPI, ComObj;

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

{ returns the Nth piece (PieceNum) of a string delimited by Delim }
function Piece(const S: string; Delim: char; PieceNum: Integer): string;
{ returns several contiguous pieces }
function Pieces(const S: string; Delim: char; FirstNum, LastNum: Integer): string;

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

function ExecuteAndWait(FileName: string; Parameters: String = ''): integer;

// when called inside a DLL, returns the fully qualified name of the DLL file
// must pass an address or a class or procedure that's been defined inside the DLL
function GetDLLFileName(Address: Pointer): string;

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


implementation

uses tlhelp32;

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

//type
//  TShow508MessageIcon = (smiNone, smiInfo, smiWarning, smiError, smiQuestion);
//  TShow508MessageButton = (smbOK, smbOKCancel, smbAbortRetryCancel, smbYesNoCancel,
//                           smbYesNo, smbRetryCancel);
//  TShow508MessageResult = (smrOK, srmCancel, smrAbort, smrRetry, smrIgnore, smrYes, smrNo);

function ShowMsg(const Msg, Caption: string; Icon: TShow508MessageIcon = smiNone;
                    Buttons: TShow508MessageButton = smbOK): TShow508MessageResult; overload;
var
  Flags, Answer: Longint;
  Title: string;
begin
  Flags := MB_TOPMOST;
  case Icon of
    smiInfo:      Flags := Flags OR MB_ICONINFORMATION;
    smiWarning:   Flags := Flags OR MB_ICONWARNING;
    smiError:     Flags := Flags OR MB_ICONERROR;
    smiQuestion:  Flags := Flags OR MB_ICONQUESTION;
  end;
  case Buttons of
    smbOK:                Flags := Flags OR MB_OK;
    smbOKCancel:          Flags := Flags OR MB_OKCANCEL;
    smbAbortRetryCancel:  Flags := Flags OR MB_ABORTRETRYIGNORE;
    smbYesNoCancel:       Flags := Flags OR MB_YESNOCANCEL;
    smbYesNo:             Flags := Flags OR MB_YESNO;
    smbRetryCancel:       Flags := Flags OR MB_RETRYCANCEL;
  end;
  Title := Caption;
  if Title = '' then
    Title := Application.Title;
  Answer := Application.MessageBox(PChar(Msg), PChar(Title), Flags);
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

function ScreenReaderActive: boolean;
var
 JawsParam: String;
begin
  Result := ProcessExists('jfw.exe');
  if not Result then
  begin
   {$Ifdef VER180}
     D2006FindCmdLineSwitch('SCREADER', JawsParam, True, [clstD2006ValueAppended]);
    {$Else}
      FindCmdLineSwitch('SCREADER', JawsParam, True, [clstValueAppended]);
    {$EndIf}
   if Trim(JawsParam) <> '' then
    Result := ProcessExists(Trim(JawsParam));
  end;
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

var
  CheckScreenReaderSupport: boolean = TRUE;
  uScreenReaderSupportEnabled: boolean = FALSE;

function ScreenReaderSupportEnabled: boolean;
begin
  if CheckScreenReaderSupport then
  begin
    uScreenReaderSupportEnabled := ScreenReaderActive;
    CheckScreenReaderSupport := FALSE;
  end;
  Result := uScreenReaderSupportEnabled;
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


initialization
  ScreenReaderSupportEnabled;

finalization
  CleanupMessageHandlerSystem;

{$WARN UNSAFE_TYPE ON}
{$WARN UNSAFE_CAST ON}
{$WARN UNSAFE_CODE ON}
end.

