{******************************************************************************}
{*                   TestOvcDlm.pas 4.08                                      *}
{******************************************************************************}

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
{* The Initial Developer of the Original Code is Armin Biernaczyk             *}
{*                                                                            *}
{* Contributor(s):                                                            *}
{*    Armin Biernaczyk                                                        *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

unit TestOvcDlm;

interface

uses
  TestFramework;

type
  TTestOvcDlm = class(TTestCase)
  published
    procedure TestOvcFastList;
  end;

implementation

uses
  OvcDlm, SysUtils, StrUtils;

{ ---------- Test for TOvcFastList }

const
  Data: array[0..30] of Integer =
    ( 1, 2, 3, 4, 5, 6, 7, 8, 9,10,
     11,12,13,14,15,16,17,18,19,20,
     21,22,23,24,25,26,27,28,29,30,31);

procedure TTestOvcDlm.TestOvcFastList;
var
  i, j: Integer;
  OvcFastList: TOvcFastList;
  P: PInteger;
begin
  OvcFastList := TOvcFastList.Create;
  { Ensure that Count=0 after creation }
  CheckEquals(0, OvcFastList.Count);

  { Add some data }
  for i := 0 to 5000 do begin
    P := @Data[i mod (High(Data)+1)];
    j := OvcFastList.Add(P);
    CheckEquals(P^, PInteger(OvcFastList.Items[j])^);
  end;
  CheckEquals(5001, OvcFastList.Count);

  { Delete some data }
  for i := 1 to 500 do
    OvcFastList.Delete(9*i);
  CheckEquals(4501, OvcFastList.Count);
  for i := 0 to 4500 do begin
    P := @Data[(i + (i div 9)) mod (High(Data)+1)];
    CheckEquals(P^, PInteger(OvcFastList.Items[i])^, Format('Test failed for index %d',[i]));
  end;

  { Test IndexOf }
  j := -1;
  P := @j;
  CheckEquals(-1, OvcFastList.IndexOf(P));
  OvcFastList.Items[1234] := P;
  CheckEquals(1234, OvcFastList.IndexOf(P));

  { Clear list }
  OvcFastList.Clear;
  CheckEquals(0, OvcFastList.Count);
end;

initialization
  RegisterTest(TTestOvcDlm.Suite);

end.

