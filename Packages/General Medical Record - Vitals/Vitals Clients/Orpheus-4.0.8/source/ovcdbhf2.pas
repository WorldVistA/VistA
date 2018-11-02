{*********************************************************}
{*                   OVCDBHF2.PAS 4.06                   *}
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

unit OvcDbHF2;
  {FlashFiler 2 database engine helper class}

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  OvcBase,
  Db,
  FFDb,
  OvcDbHLL;

type
  TOvcDbFF2EngineHelper = class(TOvcDbEngineHelperBase)
  

  protected {private}
    FSession : TffSession;
  protected
  public

    {===GENERAL SESSION-BASED METHODS===}
    procedure GetAliasNames(aList : TStrings); override;
      {-fill list with available alias names; assumes for default session}
    procedure GetAliasPath(const aAlias : string;
                             var aPath  : string); override;
      {-return the path for a given alias}
    procedure GetAliasDriverName(const aAlias  : string;
                                   var aDriver : string); override;
      {-return the driver name for a given alias - always returns
        'FlashFiler'}
    procedure GetTableNames(const aAlias : string;
                                  aList  : TStrings); override;
      {-fill list with available table names in the given alias.}


    {===GENERAL TABLE AND INDEX-BASED METHODS===}
    procedure FindNearestKey(aDataSet   : TDataSet;
                       const aKeyValues : array of const); override;
      {-position the dataset on the nearest record that matches the
        passed key}
    function GetIndexDefs(aDataSet : TDataSet) : TIndexDefs; override;
      {-return the index definitions for the given dataset}
    function GetIndexField(aDataSet    : TDataSet;
                           aFieldIndex : integer) : TField; override;
      {-return the TField object for the given field number in the
        current index.}
    function GetIndexFieldCount(aDataSet : TDataSet) : integer; override;
      {-return the number of fields in the key for the current index.}
    procedure GetIndexFieldNames(aDataSet         : TDataSet;
                             var aIndexFieldNames : string); override;
      {-return the field names for the current index for the given
        dataset}
    procedure GetIndexName(aDataSet   : TDataSet;
                       var aIndexName : string); override;
      {-return the name of the current index for the given dataset}
    function IsChildDataSet(aDataSet : TDataSet) : boolean; override;
      {-return whether the dataset is the detail part of a
        master/detail relationship (ie, the current index is 'locked'
        to the master dataset)}

    procedure SetIndexFieldNames(aDataSet         : TDataSet;
                           const aIndexFieldNames : string); override;
      {-set the current index to that containing the given fields for
        the given dataset}
    procedure SetIndexName(aDataSet   : TDataSet;
                     const aIndexName : string); override;
      {-set the current index to the given name for the given dataset}

  published
    property Session : TffSession read FSession write FSession;
      {-overridden session object for session-based methods}
  end;


implementation


{ DBHelpers require index information. This is, of course, not available
  for TffQuery }
{===TOvcDbFF2EngineHelper=============================================}
procedure TOvcDbFF2EngineHelper.FindNearestKey(aDataSet   : TDataSet;
                                        const aKeyValues : array of const);
begin
  (aDataSet as TffBaseTable).FindNearest(aKeyValues);
end;
{--------}
procedure TOvcDbFF2EngineHelper.GetAliasNames(aList : TStrings);
begin
  if Assigned(Session) then
    Session.GetAliasNames(aList)
  else
    GetDefaultFFSession.GetAliasNames(aList);
end;
{--------}
procedure TOvcDbFF2EngineHelper.GetAliasPath(const aAlias : string;
                                              var aPath  : string);
begin
  if Assigned(Session) then
    Session.GetAliasPath(aAlias, aPath)
  else
    GetDefaultFFSession.GetAliasPath(aAlias, aPath);
end;
{--------}
procedure TOvcDbFF2EngineHelper.GetAliasDriverName(const aAlias  : string;
                                                    var aDriver : string);
begin
  aDriver := 'FlashFiler 2';
end;
{--------}
procedure TOvcDbFF2EngineHelper.GetTableNames(const aAlias : string;
                                                   aList  : TStrings);
begin
  if Assigned(Session) then
    Session.GetTableNames(aAlias, '*.FF2', true, false, aList)
  else
    GetDefaultFFSession.GetTableNames(aAlias, '*.FF2', true, false, aList);
end;
{--------}
function TOvcDbFF2EngineHelper.GetIndexDefs(aDataSet : TDataSet) : TIndexDefs;
begin
  Result := (aDataSet as TffTable).IndexDefs;
end;
{--------}
function TOvcDbFF2EngineHelper.GetIndexField(aDataSet    : TDataSet;
                                            aFieldIndex : integer) : TField;
begin
  Result := (aDataSet as TffTable).IndexFields[aFieldIndex];
end;
{--------}
function TOvcDbFF2EngineHelper.GetIndexFieldCount(aDataSet : TDataSet) : integer;
begin
  Result := (aDataSet as TffTable).IndexFieldCount;
end;
{--------}
procedure TOvcDbFF2EngineHelper.GetIndexFieldNames(aDataSet         : TDataSet;
                                              var aIndexFieldNames : string);
begin
  aIndexFieldNames := (aDataSet as TffTable).IndexFieldNames;
end;
{--------}
procedure TOvcDbFF2EngineHelper.GetIndexName(aDataSet   : TDataSet;
                                        var aIndexName : string);
begin
  aIndexName := (aDataSet as TffTable).IndexName;
  if (aIndexName = '') then
    aIndexName := 'Seq. Access Index';
end;
{--------}
function TOvcDbFF2EngineHelper.IsChildDataSet(aDataSet : TDataSet) : boolean;
begin
  Result := (aDataSet as TffTable).MasterSource <> nil;
end;
{--------}
procedure TOvcDbFF2EngineHelper.SetIndexFieldNames(aDataSet         : TDataSet;
                                            const aIndexFieldNames : string);
begin
  (aDataSet as TffTable).IndexFieldNames := aIndexFieldNames;
end;
{--------}
procedure TOvcDbFF2EngineHelper.SetIndexName(aDataSet   : TDataSet;
                                      const aIndexName : string);
begin
  (aDataSet as TffTable).IndexName := aIndexName;
end;
{====================================================================}


end.
