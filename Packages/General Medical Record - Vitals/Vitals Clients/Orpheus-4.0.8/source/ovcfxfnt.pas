{*********************************************************}
{*                  OVCFXFNT.PAS 4.06                    *}
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
{*   Sebastian Zierer                                                         *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit ovcfxfnt;
  {-Orpheus fixed font support}

interface

uses
  UITypes, Windows, Classes, SysUtils, Graphics, OvcExcpt;

var
  {List of names of the fixed fonts in the system}
  FixedFontNames : TStringList;

type
  {Orpheus fixed font class}
  TOvcFixedFont = class(TPersistent)
  

    protected
      FFont : TFont;                           {Actual font}
      FOnChange : TNotifyEvent;                {Font on change event handler}

      {property read routines}
      function GetColor : TColor;
      function GetName : string;
      function GetSize : integer;
      function GetStyle : TFontStyles;

      {property write routines}
      procedure SetColor(const C : TColor);
      procedure SetName(const S : string);
      procedure SetSize(const S : integer);
      procedure SetStyle(const FS : TFontStyles);

      {event handler}
      procedure DoOnChange;

    public
      constructor Create;
        {-Create a new fixed font object--name is first fixed font on system}
      destructor Destroy; override;
        {-Destroy the fixed font object}


      procedure Assign(F : TPersistent); override;
        {-Assign another fixed font's values to this one}

      property OnChange : TNotifyEvent
        {-On change handler}
         read FOnChange
         write FOnChange;

      property Font : TFont
        {-Font - read-only}
         read FFont;

    published
      property Color : TColor
        {-Color of the fixed font}
         read GetColor
         write SetColor;

      property Name : string
        {-Name of the fixed font}
         read GetName
         write SetName;

      property Size : integer
        {-Point size of the fixed font}
         read GetSize
         write SetSize;

      property Style : TFontStyles
        {-Style of the fixed font}
         read GetStyle
         write SetStyle;
  end;


procedure RefreshFixedFontNames;
  {-Refresh the list of fixed font names}


implementation


{===Helper routines==================================================}
function IsFixedFont(const S : string) : boolean;
  {-Return true if S is a fixed font name}
  var
    i : integer;
  begin
    Result := false;
    for i := 0 to pred(FixedFontNames.Count) do
      if (FixedFontNames[i] = S) then
        begin
          Result := true;
          Exit;
        end;
  end;
{--------}
procedure DoneOrFixedFonts; far;
  {-ExitProc to destroy the fixed font name list}
  begin
    FixedFontNames.Free;
  end;
{--------}
function EnumFixedFontsProc(var LogFont: TLogFont;
                            var TextMetric: TTextMetric;
                            FontType: Integer;
                            Data: Pointer): Integer; stdcall;
  {-Enumerator for EnumFontFamilies}
  begin
    if ((LogFont.lfPitchAndFamily and FIXED_PITCH) = FIXED_PITCH) then
      TStringList(Data).Add(StrPas(LogFont.lfFaceName));
    Result := 1;
  end;
{--------}
procedure InitOrFixedFonts;
  {-Unit initialization--create the fixed font list}
  begin
    FixedFontNames := TStringList.Create;
    RefreshFixedFontNames;
  end;
{--------}
procedure RefreshFixedFontNames;
  var
    DC : HDC;
  begin
    FixedFontNames.Clear;
    DC := GetDC(0);
    try
      EnumFontFamilies(DC, nil, @EnumFixedFontsProc, integer(FixedFontNames));
    finally
      ReleaseDC(0, DC);
    end;
  end;
{====================================================================}


{===TFixedFont=======================================================}
constructor TOvcFixedFont.Create;
  begin
    FFont := TFont.Create;
    FFont.Name := FixedFontNames[0];
  end;
{--------}
destructor TOvcFixedFont.Destroy;
  begin
    FFont.Free;
  end;
{--------}
procedure TOvcFixedFont.Assign(F : TPersistent);
var
  MyFont : TFont;
begin
  MyFont := TFont.Create;
  try
    if F is TOvcFixedFont then
      MyFont.Assign(TOvcFixedFont(F).Font)
    else if F is TFont then begin
      MyFont.Assign(F);
      if not IsFixedFont(MyFont.Name) then
        raise EInvalidFixedFont.Create;
    end else
      inherited Assign(F);
    if not IsFixedFont(MyFont.Name) then
      MyFont.Name := Name;
    FFont.Assign(MyFont);
    DoOnChange;
  finally
    MyFont.Free;
  end;{try..finally}
end;

procedure TOvcFixedFont.DoOnChange;
  begin
    if Assigned(FOnChange) then
      FOnChange(Self);
  end;

function TOvcFixedFont.GetColor : TColor;
  begin
    Result := FFont.Color;
  end;
{--------}
function TOvcFixedFont.GetName : string;
  begin
    Result := FFont.Name;
  end;
{--------}
function TOvcFixedFont.GetSize : integer;
  begin
    Result := FFont.Size;
  end;
{--------}
function TOvcFixedFont.GetStyle : TFontStyles;
  begin
    Result := FFont.Style;
  end;
{--------}
procedure TOvcFixedFont.SetColor(const C : TColor);
  begin
    FFont.Color := C;
    DoOnChange;
  end;
{--------}
procedure TOvcFixedFont.SetName(const S : string);
  begin
    if IsFixedFont(S) then
      begin
        FFont.Name := S;
        DoOnChange;
      end;
  end;
{--------}
procedure TOvcFixedFont.SetSize(const S : integer);
  begin
    FFont.Size := S;
    DoOnChange;
  end;
{--------}
procedure TOvcFixedFont.SetStyle(const FS : TFontStyles);
  begin
    FFont.Style := FS;
    DoOnChange;
  end;

initialization
  InitOrFixedFonts;

finalization
  DoneOrFixedFonts;
end.
