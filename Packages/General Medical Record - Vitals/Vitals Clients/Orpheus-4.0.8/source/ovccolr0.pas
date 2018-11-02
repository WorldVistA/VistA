{*********************************************************}
{*                  OVCCOLOR0.PAS 4.06                   *}
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
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit ovccolr0;
  {-enhanced color property editor}

interface

uses
  Windows, Classes, Controls,
  DesignIntf, DesignEditors, VCLEditors,
  Graphics, Forms, SysUtils, OvcData;

type
  TOvcColorProperty = class(TColorProperty)
  public
    function GetValue: string;
      override;
    procedure GetValues(Proc: TGetStrProc);
      override;
    procedure SetValue(const Value: string);
      override;
  end;

implementation

type
  TColorEntry = packed record
    Value : TColor;
    Name  : PChar;
  end;

const
  Colors : array[0..2] of TColorEntry = (
    (Value : clCream;       Name : 'clCream'),
    (Value : clMoneyGreen;  Name : 'clMoneyGreen'),
    (Value : clSkyBlue;     Name : 'clSkyBlue'));

function OrColorToString(Color : TColor) : string;
var
  I : Integer;
begin
  if not ColorToIdent(Color, Result) then begin
    for I := Low(Colors) to High(Colors) do
      if Colors[I].Value = Color then begin

        Result := StrPas(Colors[I].Name);
        Exit;
      end;
    FmtStr(Result, '$%.8x', [Color]);
  end;
end;



function OrStringToColor(S : string) : TColor;
var
  I    : Integer;
  Text : string;
begin
  Text := S;
  for I := Low(Colors) to High(Colors) do
    if CompareText(Colors[I].Name, Text) = 0 then begin
      Result := Colors[I].Value;
      Exit;
    end;
  Result := StringToColor(S);
end;


procedure OrGetColorValues(Proc : TGetStrProc);
var
  I : Integer;
begin
  GetColorValues(Proc);
  for I := Low(Colors) to High(Colors) do

    Proc(StrPas(Colors[I].Name));
end;



{*** TOvcColorProperty ***}

function TOvcColorProperty.GetValue : string;
begin
  Result := OrColorToString(TColor(GetOrdValue));
end;

procedure TOvcColorProperty.GetValues(Proc : TGetStrProc);
begin
  OrGetColorValues(Proc);
end;

procedure TOvcColorProperty.SetValue(const Value : string);
begin
  SetOrdValue(OrStringToColor(Value));
end;


end.
