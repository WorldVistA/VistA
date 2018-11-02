{*********************************************************}
{*                   OVCMISC.PAS 4.06                    *}
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
{* Portions created by TurboPower Software Inc. are Copyright (C) 1995-2002   *}
{* TurboPower Software Inc. All Rights Reserved.                              *}
{*                                                                            *}
{* Contributor(s):                                                            *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

(*Changes)

  10/20/01- Hdc changed to TOvcHdc for BCB Compatibility
  10/20/01- HWnd changed to TOvcHWnd for BCB Compatibility
*)

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit ovcmisc;
  {-Miscellaneous functions and procedures}

interface

uses
  Windows, Buttons, Classes, Controls, ExtCtrls, Forms, Graphics, Messages,
  SysUtils, Consts, OvcData;

{ Hdc needs to be an Integer for BCB compatibility }
{$IFDEF CBuilder}
type
  TOvcHdc  = Integer;
  TOvcHWND = Cardinal;
{$ELSE}
type
  TOvcHdc  = HDC;
  TOvcHWND = HWND;
{$ENDIF}

function LoadBaseBitmap(lpBitmapName : PAnsiChar) : HBITMAP;
  {-load and return the handle to bitmap resource}
function LoadBaseCursor(lpCursorName : PAnsiChar) : HCURSOR;
  {-load and return the handle to cursor resource}
function CompStruct(const S1, S2; Size : Cardinal) : Integer;
  {-compare two fixed size structures}
function DefaultEpoch : Integer;
  {-return the current century}
function DrawButtonFrame(Canvas : TCanvas; const Client : TRect;
  IsDown, IsFlat : Boolean; Style : TButtonStyle) : TRect;
  {-produce a button similar to DrawFrameControl}
procedure FixRealPrim(P : PAnsiChar; DC : AnsiChar);
  {-get a PChar string representing a real ready for Val()}
function GetDisplayString(Canvas : TCanvas; const S : string;
  MinChars, MaxWidth : Integer) : string;
  {-given a string, a minimum number of chars to display, and a max width,
    find the string that can be displayed in that width - add ellipsis to
    the end if necessary and possible}
function GetLeftButton: Byte;
  {-return the mapped left button}

{ - HWnd changed to TOvcHWnd for BCB Compatibility }
function GetNextDlgItem(Ctrl : TOvcHWnd{hWnd}) : hWnd;

  {-get handle of next control in the same form}
procedure GetRGB(Clr : TColor; var IR, IG, IB : Byte);
  {-return component parts of the rgb value}
function GetShiftFlags : Byte;
  {-get current shift flags, the high order bit is set if the key is down}
function CreateRotatedFont(F : TFont; Angle : Integer) : hFont;
  {-create a rotated font based on the font object F}
function GetTopTextMargin(Font : TFont; BorderStyle : TBorderStyle;
         Height : Integer; Ctl3D : Boolean) : Integer;
  {-return the pixel top margin size}
function ExtractWord(N : Integer; const S : string; WordDelims : TCharSet) : string;
  {-return the Nth word from S}
function IsForegroundTask : Boolean;
  {-returns true if this task is currently in the foreground}
function TrimLeft(const S : string) : string;
  {-return a string with leading white space removed}
function TrimRight(const S : string) : string;
  {-return a string with trailing white space removed}
function QuotedStr(const S : string) : string;
  {-return a quoted string string with internal quotes escaped}
function WordCount(const S : string; const WordDelims : TCharSet) : Integer;
  {-return the word count given a set of word delimiters}
function WordPosition(const N : Integer; const S : string; const WordDelims : TCharSet) : Integer;
  {-return start position of N'th word in S}
function PtrDiff(const P1, P2) : Word;
  {-return the difference between P1 and P2}
procedure PtrInc(var P; Delta : Word);
  {-increase P by Delta}
procedure PtrDec(var P; Delta : Word);
  {-decrease P by Delta}
procedure FixTextBuffer(InBuf, OutBuf : PChar; OutSize : Integer);
  {-replace orphan linefeeds with cr/lf pairs}

{ - Hdc changed to TOvcHdc for BCB Compatibility }
procedure TransStretchBlt(DstDC: TOvcHdc{HDC}; DstX, DstY, DstW, DstH: Integer;
                           SrcDC: TOvcHdc{HDC}; SrcX, SrcY, SrcW, SrcH: Integer;
                           MaskDC: TOvcHdc{HDC};
                           MaskX, MaskY : Integer);
function MaxL(A, B : LongInt) : LongInt;
function MinL(A, B : LongInt) : LongInt;
function MinI(X, Y : Integer) : Integer;
  {-return the minimum of two integers}
function MaxI(X, Y : Integer) : Integer;
  {-return the maximum of two integers}

{function GenerateComponentName(PF : TCustomForm; const Root : string) : string;}
function GenerateComponentName(PF : TWinControl; const Root : string) : string;
  {-return a component name unique for this form}
function PartialCompare(const S1, S2 : string) : Boolean;
  {-compare minimum length of S1 and S2 strings}

function PathEllipsis(const S : string; MaxWidth : Integer) : string;
function CreateDisabledBitmap(FOriginal : TBitmap; OutlineColor : TColor) : TBitmap;
procedure CopyParentImage(Control : TControl; Dest : TCanvas);
procedure DrawTransparentBitmap(Dest : TCanvas; X, Y, W, H : Integer;
  Rect : TRect; Bitmap : TBitmap; TransparentColor : TColor);
function WidthOf(const R : TRect) : Integer;
  {returnd R.Right - R.Left}
function HeightOf(const R : TRect) : Integer;
  {returnd R.Bottom - R.Top}
procedure DebugOutput(const S : string);
  {use OutputDebugString()}

implementation

uses
  OvcBase, OvcStr;

function LoadBaseBitmap(lpBitmapName : PAnsiChar) : HBITMAP;
begin
  Result := LoadBitmap(FindClassHInstance(TOvcCustomControlEx), PWideChar(lpBitmapName));
end;

function LoadBaseCursor(lpCursorName : PAnsiChar) : HCURSOR;
begin
  Result := LoadCursor(FindClassHInstance(TOvcCustomControlEx), lpCursorName);
end;

function CompStruct(const S1, S2; Size : Cardinal) : Integer; register;
  {-compare two fixed size structures}
asm
  push    esi
  push    edi

  mov     esi, eax     {pointer to S1}
  mov     edi, edx     {pointer to S2}

  xor     eax, eax     {eax holds temporary result (Equal)}

  or      ecx, ecx     {size is already in ecx}
  jz      @@CSDone     {make sure size isn't zero}

  cld                  {go forward}
  repe    cmpsb        {compare until no match or ecx = 0}

  je      @@CSDone     {if equal, result is already in eax}
  inc     eax          {prepare for greater}
  ja      @@CSDone     {S1 greater? return +1}
  mov     eax, -1      {else S1 less, return -1}

@@CSDone:

  pop     edi
  pop     esi
end;

procedure FixRealPrim(P : PAnsiChar; DC : AnsiChar);
  {-Get a string representing a real ready for Val()}
var
  DotPos : Cardinal;
  EPos   : Cardinal;
  Len    : Word;
  Found  : Boolean;
  EFound : Boolean;
begin
  TrimAllSpacesPChar(P);

  Len := StrLen(P);
  if Len > 0 then begin
    if P[Len-1] = DC then begin
      Dec(Len);
      P[Len] := #0;
      TrimAllSpacesPChar(P);
    end;

    {Val doesn't accept alternate decimal point chars}
    Found := StrChPos(P, DC, DotPos);
    {replace with '.'}
    if Found and (DotPos > 0) then
      P[DotPos] := '.'
    else
      Found := StrChPos(P, pmDecimalPt, DotPos);

    if Found then begin
      {check for 'nnnn.'}
      if LongInt(DotPos) = Len-1 then begin
        P[Len] := '0';
        Inc(Len);
        P[Len] := #0;
      end;

      {check for '.nnnn'}
      if DotPos = 0 then begin
        StrChInsertPrim(P, '0', 0);
        Inc(Len);
        Inc(DotPos);
      end;

      {check for '-.nnnn'}
      if (Len > 1) and (P^ = '-') and (DotPos = 1) then begin
        StrChInsertPrim(P, '0', 1);
        Inc(DotPos);
      end;

    end;

    {fix up numbers with exponents}
    EFound := StrChPos(P, 'E', EPos);
    if EFound and (EPos > 0) then begin
      if not Found then begin
        StrChInsertPrim(P, '.', EPos);
        DotPos := EPos;
        Inc(EPos);
      end;
      if EPos-DotPos < 12 then
        StrStInsertPrim(P, '00000', EPos);
    end;

    {remove blanks before and after '.' }
    if Found then begin
      while (DotPos > 0) and (P[DotPos-1] = ' ') do begin
        StrStDeletePrim(P, DotPos-1, 1);
        Dec(DotPos);
      end;
      while P[DotPos+1] = ' ' do
        StrStDeletePrim(P, DotPos+1, 1);
    end;

  end else begin
    {empty string = '0'}
    P[0] := '0';
    P[1] := #0;
  end;
end;

function GetLeftButton: Byte;
const
  RLButton : array[Boolean] of Word = (VK_LBUTTON, VK_RBUTTON);
begin
  Result := RLButton[GetSystemMetrics(SM_SWAPBUTTON) <> 0];
end;

{ - HWnd changed to TOvcHWnd for BCB Compatibility }
function GetNextDlgItem(Ctrl : TOvcHWnd{hWnd}) : hWnd;
  {-Get handle of next control in the same form}
begin
  {asking for previous returns next}
  Result := GetNextWindow(Ctrl, GW_HWNDPREV);
  if Result = 0 then begin
    {asking for last returns first}
    Result := GetWindow(Ctrl, GW_HWNDLAST);
    if Result = 0 then
      Result := Ctrl;
  end;
end;

procedure GetRGB(Clr : TColor; var IR, IG, IB : Byte);
begin
  if (Clr < 0) then begin
    Clr := Clr + MaxLongInt + 1;
    Clr := GetSysColor(Clr);
  end;
  IR := GetRValue(Clr);
  IG := GetGValue(Clr);
  IB := GetBValue(Clr);
end;

function GetShiftFlags : Byte;
  {-get current shift flags, the high order bit is set if the key is down}
begin
  Result := (Ord(GetKeyState(VK_CONTROL) < 0) * ss_Ctrl) +
            (Ord(GetKeyState(VK_SHIFT ) < 0) * ss_Shift) +
            (Ord(GetKeyState(VK_ALT   ) < 0) * ss_Alt);
end;

function CreateRotatedFont(F : TFont; Angle : Integer) : hFont;
  {-create a rotated font based on the font object F}
var
  LF : TLogFont;
begin
  FillChar(LF, SizeOf(LF), #0);
  with LF do begin
    lfHeight           := F.Height;
    lfWidth            := 0;
    lfEscapement       := Angle*10;
    lfOrientation      := 0;
    if fsBold in F.Style then
      lfWeight         := FW_BOLD
    else
      lfWeight         := FW_NORMAL;
    lfItalic           := Byte(fsItalic in F.Style);
    lfUnderline        := Byte(fsUnderline in F.Style);
    lfStrikeOut        := Byte(fsStrikeOut in F.Style);
    lfCharSet          := DEFAULT_CHARSET;
    StrPCopy(lfFaceName, F.Name);
    lfQuality          := DEFAULT_QUALITY;
    {everything else as default}
    lfOutPrecision     := OUT_DEFAULT_PRECIS;
    lfClipPrecision    := CLIP_DEFAULT_PRECIS;
    case F.Pitch of
      fpVariable : lfPitchAndFamily := VARIABLE_PITCH;
      fpFixed    : lfPitchAndFamily := FIXED_PITCH;
    else
      lfPitchAndFamily := DEFAULT_PITCH;
    end;
  end;
  Result := CreateFontIndirect(LF);
end;

function GetTopTextMargin(Font : TFont; BorderStyle : TBorderStyle;
         Height : Integer; Ctl3D : Boolean) : Integer;
  {-return the pixel top margin size}
var
  I          : Integer;
  DC         : hDC;
  Metrics    : TTextMetric;
  SaveFont   : hFont;
  SysMetrics : TTextMetric;
begin
  DC := GetDC(0);
  try
    GetTextMetrics(DC, SysMetrics);
    SaveFont := SelectObject(DC, Font.Handle);
    GetTextMetrics(DC, Metrics);
    SelectObject(DC, SaveFont);
  finally
    ReleaseDC(0, DC);
  end;
  I := SysMetrics.tmHeight;
  if I > Metrics.tmHeight then
    I := Metrics.tmHeight;

  if NewStyleControls then begin
    if BorderStyle = bsNone then begin
      Result := 0;
      if I >= Height-2 then
        Result := (Height-I-2) div 2 - Ord(Odd(Height-I));
    end else if Ctl3D then begin
      Result := 1;
      if I >= Height-4 then
        Result := (Height-I-4) div 2 - 1;
    end else begin
      Result := 1;
      if I >= Height-4 then
        Result := (Height-I-4) div 2 - Ord(Odd(Height-I));
    end;
  end else begin
    Result := (Height-Metrics.tmHeight-1) div 2;
    if I > Height-2 then begin
      Dec(Result, 2);
      if BorderStyle = bsNone then
        Inc(Result, 1);
    end;
  end;
end;

function PtrDiff(const P1, P2) : Word;
  {-return the difference between P1 and P2}
begin
  {P1 and P2 are assumed to point within the same buffer}
  Result := PAnsiChar(P1) - PAnsiChar(P2);
end;

procedure PtrInc(var P; Delta : Word);
  {-increase P by Delta}
begin
  Inc(PAnsiChar(P), Delta);
end;

procedure PtrDec(var P; Delta : Word);
  {-increase P by Delta}
begin
  Dec(PAnsiChar(P), Delta);
end;

function MinI(X, Y : Integer) : Integer;
asm
  cmp  eax, edx
  jle  @@Exit
  mov  eax, edx
@@Exit:
end;

function MaxI(X, Y : Integer) : Integer;
asm
  cmp  eax, edx
  jge  @@Exit
  mov  eax, edx
@@Exit:
end;

function MaxL(A, B : LongInt) : LongInt;
begin
  if (A < B) then
    Result := B
  else
    Result := A;
end;

function MinL(A, B : LongInt) : LongInt;
begin
  if (A < B) then
    Result := A
  else
    Result := B;
end;

function TrimLeft(const S : string) : string;
var
  I, L : Integer;
begin
  L := Length(S);
  I := 1;
  while (I <= L) and (S[I] <= ' ') do
    Inc(I);
  Result := Copy(S, I, Length(S)-I+1);
end;

function TrimRight(const S : string) : string;
var
  I : Integer;
begin
  I := Length(S);
  while (I > 0) and (S[I] <= ' ') do
    Dec(I);
  Result := Copy(S, 1, I);
end;

function QuotedStr(const S: string): string;
var
  I : Integer;
begin
  Result := S;
  for I := Length(Result) downto 1 do
    if Result[I] = '''' then Insert('''', Result, I);
  Result := '''' + Result + '''';
end;

function WordCount(const S : string; const WordDelims : TCharSet) : Integer;
var
  SLen, I : Integer;
begin
  Result := 0;
  I := 1;
  SLen := Length(S);
  while I <= SLen do begin
    while (I <= SLen) and (S[I] in WordDelims) do
      Inc(I);
    if I <= SLen then
      Inc(Result);
    while (I <= SLen) and not(S[I] in WordDelims) do
      Inc(I);
  end;
end;

function ExtractWord(N : Integer; const S : string; WordDelims : TCharSet) : string;
var
  I   : Word;
  Len : Integer;
begin
  Len := 0;
  I := WordPosition(N, S, WordDelims);
  if I <> 0 then
    { find the end of the current word }
    while (I <= Length(S)) and not(S[I] in WordDelims) do begin
      { add the I'th character to result }
      Inc(Len);
      SetLength(Result, Len);
      Result[Len] := S[I];
      Inc(I);
    end;
  SetLength(Result, Len);
end;

function WordPosition(const N : Integer; const S : string; const WordDelims : TCharSet) : Integer;
var
  Count, I : Integer;
begin
  Count := 0;
  I := 1;
  Result := 0;
  while (I <= Length(S)) and (Count <> N) do begin
    {skip over delimiters}
    while (I <= Length(S)) and (S[I] in WordDelims) do
      Inc(I);
    {if we're not beyond end of S, we're at the start of a word}
    if I <= Length(S) then
      Inc(Count);
    {if not finished, find the end of the current word}
    if Count <> N then
      while (I <= Length(S)) and not (S[I] in WordDelims) do
        Inc(I)
    else
      Result := I;
  end;
end;

function DrawButtonFrame(Canvas : TCanvas; const Client : TRect;
  IsDown, IsFlat : Boolean; Style : TButtonStyle) : TRect;
var
  NewStyle : Boolean;
begin
  Result := Client;
  NewStyle := (Style = bsNew) or (NewStyleControls and (Style = bsAutoDetect));
  if IsDown then begin
    if NewStyle then begin
      Frame3D(Canvas, Result, clWindowFrame, clBtnHighlight, 1);
      if not IsFlat then
        Frame3D(Canvas, Result, clBtnShadow, clBtnFace, 1);
    end else begin
      if IsFlat then
        Frame3D(Canvas, Result, clWindowFrame, clBtnHighlight, 1)
      else begin
        Frame3D(Canvas, Result, clWindowFrame, clWindowFrame, 1);
        Canvas.Pen.Color := clBtnShadow;
        Canvas.PolyLine([Point(Result.Left, Result.Bottom - 1),
          Point(Result.Left, Result.Top), Point(Result.Right, Result.Top)]);
      end;
    end;
  end else begin
    if NewStyle then begin
      if IsFlat then
        Frame3D(Canvas, Result, clBtnHighlight, clBtnShadow, 1)
      else begin
        Frame3D(Canvas, Result, clBtnHighlight, clWindowFrame, 1);
        Frame3D(Canvas, Result, clBtnFace, clBtnShadow, 1);
      end;
    end else begin
      if IsFlat then
        Frame3D(Canvas, Result, clBtnHighlight, clWindowFrame, 1)
      else begin
        Frame3D(Canvas, Result, clWindowFrame, clWindowFrame, 1);
        Frame3D(Canvas, Result, clBtnHighlight, clBtnShadow, 1);
      end;
    end;
  end;
  InflateRect(Result, -1, -1);
end;

function GetDisplayString(Canvas : TCanvas; const S : string;
  MinChars, MaxWidth : Integer) : string;
var
  iDots, EllipsisWidth, Extent, Len, Width : Integer;
  ShowEllipsis : Boolean;
begin
  {be sure that the Canvas Font is set before entering this routine}
  EllipsisWidth := Canvas.TextWidth('...');
  Len := Length(S);
  Result := S;
  Extent := Canvas.TextWidth(Result);
  ShowEllipsis := False;
  Width := MaxWidth;
  while (Extent > Width) do begin
    ShowEllipsis := True;
    Width := MaxWidth - EllipsisWidth;
    if Len > MinChars then begin
      Delete(Result, Len, 1);
      dec(Len);
    end else
      break;
    Extent := Canvas.TextWidth(Result);
  end;
  if ShowEllipsis then begin
    Result := Result + '...';
    inc(Len, 3);
    Extent := Canvas.TextWidth(Result);
    iDots := 3;
    while (iDots > 0) and (Extent > MaxWidth) do begin
      Delete(Result, Len, 1);
      Dec(Len);
      Extent := Canvas.TextWidth(Result);
      Dec(iDots);
    end;
  end;
end;

type
  PCheckTaskInfo = ^TCheckTaskInfo;
  TCheckTaskInfo = packed record
    FocusWnd: HWnd;
    Found: Boolean;
  end;

{ - HWnd changed to TOvcHWnd for BCB Compatibility }
function CheckTaskWindow(Window: TOvcHWnd{HWnd};
  Data: Longint): WordBool; stdcall;
begin
  Result := True;
  if PCheckTaskInfo(Data)^.FocusWnd = Window then begin
    Result := False;
    PCheckTaskInfo(Data)^.Found := True;
  end;
end;

function IsForegroundTask : Boolean;
var
  Info : TCheckTaskInfo;
begin
  Info.FocusWnd := GetActiveWindow;
  Info.Found := False;
  EnumThreadWindows(GetCurrentThreadID, @CheckTaskWindow, Longint(@Info));
  Result := Info.Found;
end;

procedure FixTextBuffer(InBuf, OutBuf : PChar; OutSize : Integer);
var
  I, P : Integer;
begin
  P := 0;
  for I := 0 to StrLen(InBuf) do begin
    if (InBuf[I] = #10) and ((I = 0) or (InBuf[I-1] <> #13)) then begin
      OutBuf[P] := #13;
      Inc(P);
    end;
    OutBuf[P] := InBuf[I];
    {is outbuf full?}
    if P = OutSize-1 then begin
      {if so, terminate and exit}
      OutBuf[OutSize] := #0;
      Break;
    end;
    Inc(P);
  end;
end;

{ - Hdc changed to TOvcHdc for BCB Compatibility }
procedure TransStretchBlt(DstDC: TOvcHdc{HDC}; DstX, DstY, DstW, DstH: Integer;
                           SrcDC: TOvcHdc{HDC}; SrcX, SrcY, SrcW, SrcH: Integer;
                           MaskDC: TOvcHdc{HDC};
                           MaskX, MaskY : Integer);
var
  MemDC : HDC;
  MemBmp : HBITMAP;
  Save : THandle;
  crText, crBack : TColorRef;
  SystemPalette16, SavePal : HPALETTE;
begin
  SavePal := 0;
  MemDC := CreateCompatibleDC(0);
  try
    MemBmp := CreateCompatibleBitmap(SrcDC, SrcW, SrcH);
    Save := SelectObject(MemDC, MemBmp);
    SystemPalette16 := GetStockObject(DEFAULT_PALETTE);
    SavePal := SelectPalette(SrcDC, SystemPalette16, False);
    SelectPalette(SrcDC, SavePal, False);
    if SavePal <> 0 then
      SavePal := SelectPalette(MemDC, SavePal, True)
    else
      SavePal := SelectPalette(MemDC, SystemPalette16, True);
    RealizePalette(MemDC);

    StretchBlt(MemDC, 0, 0, SrcW, SrcH, MaskDC, MaskX, MaskY,
                SrcW, SrcH, SrcCopy);
    StretchBlt(MemDC, 0, 0, SrcW, SrcH, SrcDC, SrcX, SrcY, SrcW, SrcH,
                SrcErase);
    crText := SetTextColor(DstDC, $0);
    crBack := SetBkColor(DstDC, $FFFFFF);
    StretchBlt(DstDC, DstX, DstY, DstW, DstH, MaskDC, MaskX, MaskY,
                SrcW, SrcH, SrcAnd);
    StretchBlt(DstDC, DstX, DstY, DstW, DstH, MemDC, 0, 0,
                SrcW, SrcH, SrcInvert);
    SetTextColor(DstDC, crText);
    SetBkColor(DstDC, crBack);
    if Save <> 0 then
      SelectObject(MemDC, Save);
    DeleteObject(MemBmp);
  finally
    if SavePal <> 0 then
      SelectPalette(MemDC, SavePal, False);
    DeleteDC(MemDC);
  end;
end;

function DefaultEpoch : Integer;
var
  ThisYear  : Word;
  ThisMonth : Word;
  ThisDay   : Word;
begin
  DecodeDate(SysUtils.Date, ThisYear, ThisMonth, ThisDay);
  Result := (ThisYear div 100) * 100;
end;

{function GenerateComponentName(PF : TCustomForm; const Root : string) : string;}
function GenerateComponentName(PF : TWinControl; const Root : string) : string;
var
  I : Integer;
begin
  if not IsValidIdent(Root) then
    raise EComponentError.CreateFmt('''''%s'''' is not a valid component name',
      [Root]);
  I := 0;
  repeat
    Inc(I);
    Result := Root + IntToStr(I);
  until (PF.FindComponent(Result) = nil);
end;

function PartialCompare(const S1, S2 : string) : Boolean;
var
  L : Integer;
begin
  {and empty string matches nothing}
  Result := False;
  L := MinI(Length(S1), Length(S2));
  if L > 0 then
    Result := AnsiUpperCase(Copy(S1, 1, L)) = AnsiUpperCase(Copy(S2, 1, L));
end;

function PathEllipsis(const S : string; MaxWidth : Integer) : string;
  { PathEllipsis function. Trims a path down to the      }
  { specified number of pixels. For example,             }
  { 'd:\program files\my stuff\some long document.txt'   }
  { becomes 'd:\...\some long...' or a variation thereof }
  { depending on the value of MaxWidth.                  }
var
  R       : TRect;
  BM      : TBitmap;
  NCM     : TNonClientMetrics;
begin
  if MaxWidth = 0 then begin
    Result := S;
    Exit;
  end;
  NCM.cbSize := SizeOf(NCM);
  SystemParametersInfo(
    SPI_GETNONCLIENTMETRICS, NCM.cbSize, @NCM, 0);
  BM := TBitmap.Create;
  try
    BM.Canvas.Font.Handle := CreateFontIndirect(NCM.lfMenuFont);
    if BM.Canvas.TextWidth(S) < MaxWidth then begin
      Result := S;
      Exit;
    end;
    Result := ExtractFilePath(S);
    Delete(Result, Length(Result), 1);
    while BM.Canvas.TextWidth(Result + '\...\' + ExtractFileName(S)) > MaxWidth do begin
      { Start trimming the path, working backwards }
      Result := ExtractFilePath(Result);
      Delete(Result, Length(Result), 1);
      { Only drive letter left so break out of loop. }
      if Length(Result) = 2 then
        Break;
    end;
    { Add the filename back onto the modified path. }
    Result := Result + '\...\' + ExtractFileName(S);
    { Still too long? }
    if BM.Canvas.TextWidth(Result) > MaxWidth then begin
      R := Rect(0, 0, MaxWidth, 0);
      DrawText(BM.Canvas.Handle, PChar(Result), -1,
        R, DT_SINGLELINE or DT_END_ELLIPSIS or DT_MODIFYSTRING or DT_CALCRECT);
    end;
  finally
    BM.Free;
  end;
end;

function CreateDisabledBitmap(FOriginal : TBitmap; OutlineColor : TColor) : TBitmap;
  {-create TBitmap object with disabled glyph}
const
  ROP_DSPDxax = $00E20746;
var
  MonoBmp : TBitmap;
  IRect   : TRect;
begin
  IRect := Rect(0, 0, FOriginal.Width, FOriginal.Height);
  Result := TBitmap.Create;
  try
    Result.Width := FOriginal.Width;
    Result.Height := FOriginal.Height;
    MonoBmp := TBitmap.Create;
    try
      with MonoBmp do begin
        Assign(FOriginal);
        HandleType := bmDDB;
        Canvas.Brush.Color := OutlineColor;
        if Monochrome then begin
          Canvas.Font.Color := clWhite;
          Monochrome := False;
          Canvas.Brush.Color := clWhite;
        end;
        Monochrome := True;
      end;
      with Result.Canvas do begin
        Brush.Color := clBtnFace;
        FillRect(IRect);
        Brush.Color := clBtnHighlight;
        SetTextColor(Handle, clBlack);
        SetBkColor(Handle, clWhite);
        BitBlt(Handle, 1, 1, WidthOf(IRect), HeightOf(IRect),
          MonoBmp.Canvas.Handle, 0, 0, ROP_DSPDxax);
        Brush.Color := clBtnShadow;
        SetTextColor(Handle, clBlack);
        SetBkColor(Handle, clWhite);
        BitBlt(Handle, 0, 0, WidthOf(IRect), HeightOf(IRect),
          MonoBmp.Canvas.Handle, 0, 0, ROP_DSPDxax);
      end;
    finally
      MonoBmp.Free;
    end;
  except
    Result.Free;
    raise;
  end;
end;

type
  TParentControl = class(TWinControl);

procedure CopyParentImage(Control : TControl; Dest : TCanvas);
var
  I     : Integer;
  Count : Integer;
  X, Y  : Integer;
  OldDC : Integer;
  DC    : hDC;
  R     : TRect;
  SelfR : TRect;
  CtlR  : TRect;
begin
  if Control.Parent = nil then
    Exit;

  Count := Control.Parent.ControlCount;
  DC := Dest.Handle;
  SelfR := Bounds(Control.Left, Control.Top, Control.Width, Control.Height);
  X := -Control.Left; Y := -Control.Top;

  {copy parent control image}
  OldDC := SaveDC(DC);
  SetViewportOrgEx(DC, X, Y, nil);
  IntersectClipRect(DC, 0, 0, Control.Parent.ClientWidth, Control.Parent.ClientHeight);
  TParentControl(Control.Parent).PaintWindow(DC);
  RestoreDC(DC, OldDC);

  {copy images of graphic controls}
  for I := 0 to Count - 1 do begin
    if (Control.Parent.Controls[I] <> nil) and
      not (Control.Parent.Controls[I] is TWinControl) then begin
      if Control.Parent.Controls[I] = Control then
        Break;
      with Control.Parent.Controls[I] do begin
        CtlR := Bounds(Left, Top, Width, Height);
        if Bool(IntersectRect(R, SelfR, CtlR)) and Visible then begin
          OldDC := SaveDC(DC);
          SetViewportOrgEx(DC, Left + X, Top + Y, nil);
          IntersectClipRect(DC, 0, 0, Width, Height);
          Perform(WM_PAINT, DC, 0);
          RestoreDC(DC, OldDC);
        end;
      end;
    end;
  end;
end;

{ - Hdc changed to TOvcHdc for BCB Compatibility }
procedure DrawTransparentBitmapPrim(DC : TOvcHdc{HDC}; Bitmap : HBitmap;
  xStart, yStart, Width, Height : Integer; Rect : TRect;
  TransparentColor : TColorRef);
  {-draw transparent bitmap}
var
  BM          : Windows.TBitmap;
  cColor      : TColorRef;
  bmAndBack   : hBitmap;
  bmAndObject : hBitmap;
  bmAndMem    : hBitmap;
  bmSave      : hBitmap;
  bmBackOld   : hBitmap;
  bmObjectOld : hBitmap;
  bmMemOld    : hBitmap;
  bmSaveOld   : hBitmap;
  hdcMem      : hDC;
  hdcBack     : hDC;
  hdcObject   : hDC;
  hdcTemp     : hDC;
  hdcSave     : hDC;
  ptSize      : TPoint;
  ptRealSize  : TPoint;
  ptBitSize   : TPoint;
  ptOrigin    : TPoint;
begin
  hdcTemp := CreateCompatibleDC(DC);
  SelectObject(hdcTemp, Bitmap);
  GetObject(Bitmap, SizeOf(BM), @BM);
  ptRealSize.x := MinL(Rect.Right - Rect.Left, BM.bmWidth - Rect.Left);
  ptRealSize.y := MinL(Rect.Bottom - Rect.Top, BM.bmHeight - Rect.Top);
  DPtoLP(hdcTemp, ptRealSize, 1);
  ptOrigin.x := Rect.Left;
  ptOrigin.y := Rect.Top;

  {convert from device to logical points}
  DPtoLP(hdcTemp, ptOrigin, 1);
  {get width of bitmap}
  ptBitSize.x := BM.bmWidth;
  {get height of bitmap}
  ptBitSize.y := BM.bmHeight;
  DPtoLP(hdcTemp, ptBitSize, 1);

  if (ptRealSize.x = 0) or (ptRealSize.y = 0) then begin
    ptSize := ptBitSize;
    ptRealSize := ptSize;
  end else
    ptSize := ptRealSize;
  if (Width = 0) or (Height = 0) then begin
    Width := ptSize.x;
    Height := ptSize.y;
  end;

  {create DCs to hold temporary data}
  hdcBack   := CreateCompatibleDC(DC);
  hdcObject := CreateCompatibleDC(DC);
  hdcMem    := CreateCompatibleDC(DC);
  hdcSave   := CreateCompatibleDC(DC);
  {create a bitmap for each DC}
  {monochrome DC}
  bmAndBack   := CreateBitmap(ptSize.x, ptSize.y, 1, 1, nil);
  bmAndObject := CreateBitmap(ptSize.x, ptSize.y, 1, 1, nil);
  bmAndMem    := CreateCompatibleBitmap(DC, MaxL(ptSize.x, Width), MaxL(ptSize.y, Height));
  bmSave      := CreateCompatibleBitmap(DC, ptBitSize.x, ptBitSize.y);
  {select a bitmap object to store pixel data}
  bmBackOld   := SelectObject(hdcBack, bmAndBack);
  bmObjectOld := SelectObject(hdcObject, bmAndObject);
  bmMemOld    := SelectObject(hdcMem, bmAndMem);
  bmSaveOld   := SelectObject(hdcSave, bmSave);

  SetMapMode(hdcTemp, GetMapMode(DC));

  {save the bitmap sent here, it will be overwritten}
  BitBlt(hdcSave, 0, 0, ptBitSize.x, ptBitSize.y, hdcTemp, 0, 0, SRCCOPY);

  {set the background color of the source DC to the color,}
  {contained in the parts of the bitmap that should be transparent}
  cColor := SetBkColor(hdcTemp, TransparentColor);

  {create the object mask for the bitmap by performing a BitBlt()}
  {from the source bitmap to a monochrome bitmap}
  BitBlt(hdcObject, 0, 0, ptSize.x, ptSize.y, hdcTemp, ptOrigin.x, ptOrigin.y, SRCCOPY);

  {set the background color of the source DC back to the original color}
  SetBkColor(hdcTemp, cColor);

  {create the inverse of the object mask}
  BitBlt(hdcBack, 0, 0, ptSize.x, ptSize.y, hdcObject, 0, 0, NOTSRCCOPY);

  {copy the background of the main DC to the destination}
  BitBlt(hdcMem, 0, 0, Width, Height, DC, xStart, yStart, SRCCOPY);

  {mask out the places where the bitmap will be placed}
  StretchBlt(hdcMem, 0, 0, Width, Height, hdcObject, 0, 0, ptSize.x, ptSize.y, SRCAND);

  {mask out the transparent colored pixels on the bitmap}
  BitBlt(hdcTemp, ptOrigin.x, ptOrigin.y, ptSize.x, ptSize.y, hdcBack, 0, 0, SRCAND);

  {XOR the bitmap with the background on the destination DC}
  StretchBlt(hdcMem, 0, 0, Width, Height, hdcTemp, ptOrigin.x, ptOrigin.y, ptSize.x, ptSize.y, SRCPAINT);

  {copy the destination to the screen}
  BitBlt(DC, xStart, yStart, MaxL(ptRealSize.x, Width), MaxL(ptRealSize.y, Height), hdcMem, 0, 0, SRCCOPY);

  {place the original bitmap back into the bitmap sent}
  BitBlt(hdcTemp, 0, 0, ptBitSize.x, ptBitSize.y, hdcSave, 0, 0, SRCCOPY);

  {delete the memory bitmaps}
  DeleteObject(SelectObject(hdcBack, bmBackOld));
  DeleteObject(SelectObject(hdcObject, bmObjectOld));
  DeleteObject(SelectObject(hdcMem, bmMemOld));
  DeleteObject(SelectObject(hdcSave, bmSaveOld));

  {delete the memory DCs}
  DeleteDC(hdcMem);
  DeleteDC(hdcBack);
  DeleteDC(hdcObject);
  DeleteDC(hdcSave);
  DeleteDC(hdcTemp);
end;

procedure DrawTransparentBitmap(Dest : TCanvas; X, Y, W, H : Integer;
  Rect : TRect; Bitmap : TBitmap; TransparentColor : TColor);
var
  MemImage : TBitmap;
  R        : TRect;
begin
  MemImage := TBitmap.Create;
  try
    R := Bounds(0, 0, Bitmap.Width, Bitmap.Height);
    if TransparentColor = clNone then begin

      if (WidthOf(Rect) <> 0) and (HeightOf(Rect) <> 0) then
        R := Rect;
      MemImage.Width := WidthOf(R);
      MemImage.Height := HeightOf(R);
      MemImage.Canvas.CopyRect(Bounds(0, 0, MemImage.Width, MemImage.Height),
        Bitmap.Canvas, R);

      if (W = 0) or (H = 0) then
        Dest.Draw(X, Y, MemImage)
      else
        Dest.StretchDraw(Bounds(X, Y, W, H), MemImage);

    end else  begin
      MemImage.Width := WidthOf(R);
      MemImage.Height := HeightOf(R);
      MemImage.Canvas.CopyRect(R, Bitmap.Canvas, R);
      if TransparentColor = clDefault then
        TransparentColor := MemImage.Canvas.Pixels[0, MemImage.Height - 1];
      DrawTransparentBitmapPrim(Dest.Handle, MemImage.Handle, X, Y, W, H,
        Rect, ColorToRGB(TransparentColor and not $02000000));
    end;
  finally
    MemImage.Free;
  end;
end;


function WidthOf(const R : TRect) : Integer;
begin
  Result := R.Right - R.Left;
end;

function HeightOf(const R : TRect) : Integer;
begin
  Result := R.Bottom - R.Top;
end;

procedure DebugOutput(const S : string);
begin
  OutputDebugString(PChar(S));
  OutputDebugString(#13#10);
end;

end.
