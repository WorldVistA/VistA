{*********************************************************}
{*                   OVCUSER.PAS 4.06                    *}
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

unit ovcuser;
  {-User data class}

interface

uses
  SysUtils,
  OvcData;

type
  {class for implementing user-defined mask and substitution characters}
  TOvcUserData = class(TObject)

  protected {private}
    FUserCharSets : TUserCharSets;
    FForceCase    : TForceCase;
    FSubstChars   : TSubstChars;

    {property methods}
    function GetForceCase(Index : TForceCaseRange) : TCaseChange;
      {-get the case changing behavior of the specified user mask character}
    function GetSubstChar(Index : TSubstCharRange) : Char;
      {-get the meaning of the specified substitution character}
    function GetUserCharSet(Index : TUserSetRange) : TCharSet;
      {-get the specified user-defined character set}
    procedure SetForceCase(Index : TForceCaseRange; CC : TCaseChange);
      {-set the case changing behavior of the specified user mask character}
    procedure SetSubstChar(Index : TSubstCharRange; SC : Char);
      {-set the meaning of the specified substitution character}
    procedure SetUserCharSet(Index : TUserSetRange; const US : TCharSet);
      {-set the specified user-defined character set}

  public
    constructor Create;


    property ForceCase[Index : TForceCaseRange] : TCaseChange
      read GetForceCase
      write SetForceCase;

    property SubstChars[Index : TSubstCharRange] : Char
      read GetSubstChar
      write SetSubstChar;

    property UserCharSet[Index : TUserSetRange] : TCharSet
      read GetUserCharSet
      write SetUserCharSet;
  end;

var
  {global default user data object}
  OvcUserData : TOvcUserData;


implementation


{*** TOvcUserData ***}

const
  DefUserCharSets : TUserCharSets = (
      {User1} [#1..#255], {User2} [#1..#255], {User3} [#1..#255],
      {User4} [#1..#255], {User5} [#1..#255], {User6} [#1..#255],
      {User7} [#1..#255], {User8} [#1..#255] );

  DefForceCase : TForceCase = (
      mcNoChange, mcNoChange, mcNoChange, mcNoChange,
      mcNoChange, mcNoChange, mcNoChange, mcNoChange);

  DefSubstChars : TSubstChars = (
      Subst1, Subst2, Subst3, Subst4, Subst5, Subst6, Subst7, Subst8);

constructor TOvcUserData.Create;
begin
  inherited Create;

  FUserCharSets := DefUserCharSets;
  FForceCase    := DefForceCase;
  FSubstChars   := DefSubstChars;
end;

function TOvcUserData.GetForceCase(Index : TForceCaseRange) : TCaseChange;
  {-get the case changing behavior of the specified user mask character}
begin
  case Index of
    pmUser1..pmUser8 : Result := FForceCase[Index];
  else
    Result := mcNoChange;
  end;
end;

function TOvcUserData.GetSubstChar(Index : TSubstCharRange) : Char;
  {-get the meaning of the specified substitution character}
begin
  case Index of
    Subst1..Subst8 : Result := FSubstChars[Index];
  else
    Result := #0;
  end;
end;

function TOvcUserData.GetUserCharSet(Index : TUserSetRange) : TCharSet;
  {-get the specified user-defined character set}
begin
  case Index of
    pmUser1..pmUser8 : Result := FUserCharSets[Index];
  end;
end;

procedure TOvcUserData.SetForceCase(Index : TForceCaseRange; CC : TCaseChange);
  {-set the case changing behavior of the specified user mask character}
begin
  case Index of
    pmUser1..pmUser8 : FForceCase[Index] := CC;
  end;
end;

procedure TOvcUserData.SetSubstChar(Index : TSubstCharRange; SC : Char);
  {-set the meaning of the specified substitution character}
begin
  case Index of
    Subst1..Subst8 : FSubstChars[Index] := SC;
  end;
end;

procedure TOvcUserData.SetUserCharSet(Index : TUserSetRange; const US : TCharSet);
  {-set the specified user-defined character set}
begin
  case Index of
    pmUser1..pmUser8 : FUserCharSets[Index] := US-[#0];
  end;
end;


{*** exit procedure ***}

procedure DestroyGlobalUserData; far;
begin
  OvcUserData.Free
end;


initialization
  {create instance of default user data class}
  OvcUserData := TOvcUserData.Create;

finalization
  DestroyGlobalUserData;
end.
