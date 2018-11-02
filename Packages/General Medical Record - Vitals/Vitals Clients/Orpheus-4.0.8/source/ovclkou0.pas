{*********************************************************}
{*                  OVCLKOU0.PAS 4.06                    *}
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

unit ovclkou0;
  {-component editor for the LookoutBars}

interface

uses
  DesignIntf, DesignEditors, Forms, SysUtils, OvcData, OvcBase, OvcLkOut, OvcLkOu1,
  OvcColE0;

type
  TOvcLookoutBarEditor = class(TComponentEditor)
    procedure ExecuteVerb(Index : Integer);
      override;
    function GetVerb(Index : Integer) : string;
      override;
    function GetVerbCount : Integer;
      override;
  end;

  {
  TO32LookoutBarEditor = class(TComponentEditor)
    procedure ExecuteVerb(Index : Integer);
      override;
    function GetVerb(Index : Integer) : string;
      override;
    function GetVerbCount : Integer;
      override;
  end;
  }


implementation


{*** TOvcLookoutBarEditor ***}

procedure TOvcLookoutBarEditor.ExecuteVerb(Index : Integer);
begin
  case Index of
    0 : ShowCollectionEditor(Designer,
                            (Component as TOvcLookOutBar).FolderCollection,
                            IsInInLined);
    1 : EditLookOut(Designer, (Component as TOvcLookOutBar));
  end;
end;

function TOvcLookoutBarEditor.GetVerb(Index : Integer) : string;
begin
  case Index of
    0 : Result := 'Edit Folders...';
    1 : Result := 'Layout Tool...';
  end;
end;

function TOvcLookoutBarEditor.GetVerbCount : Integer;
begin
  Result := 2;
end;

end.
