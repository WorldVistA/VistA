{*********************************************************}
{*                    OVCBTNHD0.PAS 4.06                 *}
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

unit ovcbtnh0;
  {-component editor for the button header}

interface

uses
  DesignIntf, DesignEditors, Forms, SysUtils, OvcData, OvcBase, OvcBtnHd, OvcColE0;

type
  TOvcButtonHeaderEditor = class(TComponentEditor)
    procedure ExecuteVerb(Index : Integer);
      override;
    function GetVerb(Index : Integer) : string;
      override;
    function GetVerbCount : Integer;
      override;
  end;


implementation


{*** TOvcComponentStateEditor ***}

procedure TOvcButtonHeaderEditor.ExecuteVerb(Index : Integer);
begin
  if Index = 0 then
    ShowCollectionEditor(Designer,
                         (Component as TOvcButtonHeader).Sections,
                         IsInInLined);
end;

function TOvcButtonHeaderEditor.GetVerb(Index : Integer) : string;
begin
  Result := 'Edit Sections...';
end;

function TOvcButtonHeaderEditor.GetVerbCount : Integer;
begin
  Result := 1;
end;


end.
