{*********************************************************}
{*                   OVCDBHTT.PAS 4.06                   *}
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

unit OvcDBHTT;
  {Base Titan database engine helper class}

{Notes: Titan is a range of database engines by Reggatta Systems.
          http://www.reggatta.com/
        At the time of writing Titan comes in three flavors: Titan
        Access, Titan Btrieve and Titan SQLAnywhere. Each of these
        products use a set of base classes: the Titan Base Classes.
        Rather than write three different engine helpers we decided
        to write a single one that works with the base classes. In
        practice, all this means is that this database engine helper
        does not 'know' about any default Titan session, instead the
        session you are interested in using must be supplied via the
        TitanSession property of the engine helper component.
        If you are using more than one Titan product in the same app,
        our recommendation is to have an engine helper per product.}

interface

uses
  Windows, Messages, SysUtils, Classes, OvcBase, Db, BseMain, OvcDbHLL;

type
  TOvcDbTitanEngineHelper = class(TOvcDbEngineHelperBase)
  

  protected {private}
    FSession : TttSession;
  protected
  public

    {===GENERAL SESSION-BASED METHODS===}
    procedure GetAliasNames(aList : TStrings); override;
      {-fill list with available alias names; uses TitanSession
        property}
    procedure GetAliasPath(const aAlias : string;
                             var aPath  : string); override;
      {-return the path for a given alias; uses TitanSession property}
    procedure GetAliasDriverName(const aAlias  : string;
                                   var aDriver : string); override;
      {-return the driver name for a given alias; uses TitanSession
        property}
    procedure GetTableNames(const aAlias : string;
                                  aList  : TStrings); override;
      {-fill list with available table names in the given alias; uses
        TitanSession property}


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
    property TitanSession : TttSession read FSession write FSession;
      {-the default Titan session to use for all session-based
        methods}
  end;


implementation


{===TOvcDbTitanEngineHelper=============================================}
procedure TOvcDbTitanEngineHelper.FindNearestKey(aDataSet   : TDataSet;
                                           const aKeyValues : array of const);
begin
  (aDataSet as TttTable).FindNearest(aKeyValues);
end;
{--------}
procedure TOvcDbTitanEngineHelper.GetAliasNames(aList : TStrings);
begin
  if not Assigned(TitanSession) then
    aList.Clear
  else
    TitanSession.GetAliasNames(aList);
end;
{--------}
procedure TOvcDbTitanEngineHelper.GetAliasPath(const aAlias : string;
                                                 var aPath  : string);
begin
  if not Assigned(TitanSession) then
    aPath := ''
  else
    aPath := TitanSession.GetAliasDatabasePath(aAlias);
end;
{--------}
procedure TOvcDbTitanEngineHelper.GetAliasDriverName(const aAlias  : string;
                                                       var aDriver : string);
begin
  if not Assigned(TitanSession) then
    aDriver := ''
  else
    aDriver := TitanSession.GetAliasDriverName(aAlias);
end;
{--------}
procedure TOvcDbTitanEngineHelper.GetTableNames(const aAlias : string;
                                                      aList  : TStrings);
begin
  if (not Assigned(TitanSession)) or
     (aAlias = '') then
    aList.Clear
  else
    TitanSession.GetTableNames(aAlias, '*.*', true, false, aList);
end;
{--------}
function TOvcDbTitanEngineHelper.GetIndexDefs(aDataSet : TDataSet) : TIndexDefs;
begin
  Result := (aDataSet as TttTable).IndexDefs;
end;
{--------}
function TOvcDbTitanEngineHelper.GetIndexField(aDataSet    : TDataSet;
                                               aFieldIndex : integer) : TField;
begin
  Result := (aDataSet as TttTable).IndexFields[aFieldIndex];
end;
{--------}
function TOvcDbTitanEngineHelper.GetIndexFieldCount(aDataSet : TDataSet) : integer;
begin
  Result := (aDataSet as TttTable).IndexFieldCount;
end;
{--------}
procedure TOvcDbTitanEngineHelper.GetIndexFieldNames(aDataSet         : TDataSet;
                                                 var aIndexFieldNames : string);
begin
  aIndexFieldNames := (aDataSet as TttTable).IndexFieldNames;
end;
{--------}
procedure TOvcDbTitanEngineHelper.GetIndexName(aDataSet   : TDataSet;
                                           var aIndexName : string);
begin
  aIndexName := (aDataSet as TttTable).IndexName;
end;
{--------}
function TOvcDbTitanEngineHelper.IsChildDataSet(aDataSet : TDataSet) : boolean;
begin
  Result := (aDataSet as TttTable).MasterSource <> nil;
end;
{--------}
procedure TOvcDbTitanEngineHelper.SetIndexFieldNames(aDataSet         : TDataSet;
                                               const aIndexFieldNames : string);
begin
  (aDataSet as TttTable).IndexFieldNames := aIndexFieldNames;
end;
{--------}
procedure TOvcDbTitanEngineHelper.SetIndexName(aDataSet   : TDataSet;
                                         const aIndexName : string);
begin
  (aDataSet as TttTable).IndexName := aIndexName;
end;
{====================================================================}


end.
