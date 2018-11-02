{*********************************************************}
{*                    OVCUTILS.PAS 4.06                  *}
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
{*  Armin Biernaczyk: Bugfixes                                                *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

unit OvcUtils;
  { Miscellaneous Utilities }

interface

procedure StripCharSeq(CharSeq: string; var Str: string);
procedure StripCharFromEnd(Chr: Char; var Str: string);
procedure StripCharFromFront(Chr: Char; var Str: string);

implementation

procedure StripCharSeq(CharSeq: string; var Str: string);
  {-Strips specified character(s) from the string and returns the modified string }
begin
  while Pos(CharSeq, Str) > 0 do
    Delete(Str, Pos(CharSeq, Str), Length(CharSeq));
end;


procedure StripCharFromEnd(Chr: Char; var Str: string);
  {-Strips the specified character from the end of the string
   Changes:
     03/2011, AB: Bugfix: procedure failed if Str = Chr }
var
  l, i: Cardinal;
begin
  l := Length(Str);
  i := l;
  while (i>0) and (Str[i] = Chr) do
    Dec(i);
  if i<l then
    Delete(Str, i+1, l-i);
end;


procedure StripCharFromFront(Chr: Char; var Str: string);
  {-Strips the specified character from the beginning of the string
   Changes:
     03/2011, AB: Bugfix: procedure failed if Str = Chr }
var
  l, i: Cardinal;
begin
  l := Length(Str);
  i := 1;
  while (i<=l) and (Str[i] = Chr) do
    Inc(i);
  if i>1 then
    Delete(Str, 1, i-1);
end;


end.
