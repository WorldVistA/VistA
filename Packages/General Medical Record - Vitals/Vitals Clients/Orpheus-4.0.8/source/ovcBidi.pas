{*********************************************************}
{*                    OVCBORDR.PAS 4.06                  *}
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
{* The initial code is developed by Sebastian Zierer                          *}
{*                                                                            *}
{* Contributor(s):                                                            *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

unit ovcBidi;

interface

uses
  Windows, Controls;

const
  WS_EX_RIGHT           =  $00001000;
  WS_EX_LEFT            =  $00000000;
  WS_EX_RTLREADING      =  $00002000;
  WS_EX_LTRREADING      =  $00000000;
  WS_EX_LEFTSCROLLBAR   =  $00004000;
  WS_EX_RIGHTSCROLLBAR  =  $00000000;

function SetProcessDefaultLayout(dwDefaultLayout: DWORD): BOOL; stdcall;
function GetProcessDefaultLayout(out pdwDefaultLayout: DWORD): BOOL; stdcall;

const
  LAYOUT_RTL                         = $00000001; // Right to left
  LAYOUT_BTT                         = $00000002; // Bottom to top
  LAYOUT_VBH                         = $00000004; // Vertical before horizontal
  LAYOUT_ORIENTATIONMASK             = (LAYOUT_RTL or LAYOUT_BTT or LAYOUT_VBH);
  LAYOUT_BITMAPORIENTATIONPRESERVED  = $00000008;

  NOMIRRORBITMAP      = DWORD($80000000);

function SetLayout(dc: HDC; dwLayout: DWORD): DWORD; stdcall; // Win2k+
function GetLayout(dc: hdc): DWORD; stdcall;

// function GetParentWinControl(Control: TControl): TWinControl;

function IsBidi: Boolean;

implementation

uses
  SysUtils, Math;

function GetProcessDefaultLayout(out pdwDefaultLayout: DWORD): BOOL; stdcall; external 'user32.dll';
function SetProcessDefaultLayout(dwDefaultLayout: DWORD): BOOL; stdcall; external 'user32.dll';

function SetLayout(dc: HDC; dwLayout: DWORD): DWORD; stdcall; external 'gdi32.dll';
function GetLayout(dc: hdc): DWORD; stdcall; external 'gdi32.dll';

function GetParentWinControl(Control: TControl): TWinControl;
begin
  while (not (Control is TWinControl)) and (Control.Parent <> nil) do
    Control := Control.Parent;
  if Control is TWinControl then
    Result := TWinControl(Control) else
    Result := nil;
end;

{procedure MoveWindowOrg(DC: HDC; DX, DY: Integer);
var
  P: TPoint;
begin
  GetWindowOrgEx(DC, P);
  SetWindowOrgEx(DC, P.X - DX, P.Y - DY, nil);
end;

function GetWindowBoundsRTL(Control: TGraphicControl): TRect;
var
  C: TWinControl;
  R: TRect;
begin
  FillChar(Result, SizeOf(Result), 0);
  C := GetParentWinControl(Control);

  if C = nil then
    Exit;

//  R := C.ClientToScreen()
//  MapWindowPoints(0, C.Handle, R2, SizeOf(TRect) div SizeOf(TPoint));

end; }

function IsBidi: Boolean;
// returns true if system is right-to-left
var
  LocaleSig: TLocaleSignature;
  Len: Integer;
  Buf: TBytes;
begin
  Result := False;

  Len := GetLocaleInfo(LOCALE_USER_DEFAULT, LOCALE_FONTSIGNATURE, nil, 0);
  if Len = 0 then
    Exit;
  SetLength(Buf, Len * SizeOf(Char)); // returned size is in TChars!
  Len := GetLocaleInfo(LOCALE_USER_DEFAULT, LOCALE_FONTSIGNATURE, PChar(Buf), Length(Buf));

  Move(PByte(Buf)^, LocaleSig, Min(Len, SizeOf(LocaleSig)));

  Result := LocaleSig.lsUsb[3] and $08000000 <> 0;
end;

end.
