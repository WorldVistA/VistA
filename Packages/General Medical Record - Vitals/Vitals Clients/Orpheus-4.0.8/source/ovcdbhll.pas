{*********************************************************}
{*                   OVCDBHLL.PAS 4.06                   *}
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

unit ovcdbhll;
  {database engine helper ancestor class}

{Notes: From Delphi 3 onwards, third party database engines work by
        creating a TDataSet descendant component. No longer do they
        have to replace the BDE access unit with their own, and hence
        multiple database engines can be used in the same application.

        Data-aware controls will work with these descendants providing
        that the controls assume that their DataSource's DataSet
        property refers to TDataSet descendant instead of assuming
        that it is always a TTable or a TQuery (or at least a
        TBDEDataSet).

        The first problem arises in that TDataSet has no real
        knowledge of indexes: the VCL assumes that the records in the
        dataset are sequential and have no ordering. Hence, if a data
        aware control needs to manipulate indexes (eg, switch from one
        to another) or set ranges then they are suddenly forced to
        assume at least a TBDEDataSet object as their data source's
        DataSet.

        The next problem is that Orpheus provides convenient combo
        boxes for listing aliases and tables. This type of
        functionality resides outside the realm of TDataSet and its
        descendants. The VCL/BDE implements this with TSession and
        there is *no* convenient ancestor class that third-party
        database engines can use. Hence they all use a different
        way of returning this information.

        This is not good for a third-party library like Orpheus: we
        would like it to work with *any* third-party database engine,
        for example, our FlashFiler product.

        Our extra support for third-party database engines uses a
        database engine helper component. This component has a
        well-defined interface through an ancestor class for providing
        this extra functionality and information.

        This source file defines the ancestor class. We also provide
        descendant for the BDE and FlashFiler in separate source files
        and packages. We therefore do not have to ship FlashFiler with
        Orpheus, and you do not have to ship the BDE with your
        application. Furthermore, by this separation, we ensure that
        your application does not include code it does not need to.

        We also provide helper routines that expect an instance of
        this class or a descendant. For Delphi 1 and 2 these routines
        perform the standard BDE actions even when passed a nil
        object.

        To get Orpheus to work with a new database engine, all that
        needs to be done is to create a separate engine helper
        descendant component, write the accessor methods, and link it
        to those Orpheus controls that require a database engine
        helper.

        The engine helper class provides the following functionality as
        virtual methods:
          - getting alias names
          - getting the path for an alias
          - getting the driver name for an alias
          - getting the table names within an alias
          - getting the index information for a table
          - getting the current index name for a table
          - switching a table to a given index name

        The ancestor class provides reasonable defaults for these
        methods and hence descendant components only have to override
        those methods they can implement. The comments in the code
        below define the default behaviour of these methods.

        }

interface

uses
  Windows, Messages, SysUtils, Classes, OvcBase, Db;

type
  TOvcDbEngineHelperBase = class(TComponent)
  

  protected {private}
  protected
  public

    {===GENERAL SESSION-BASED METHODS===}
    procedure GetAliasNames(aList : TStrings); virtual;
      {-fill list with available alias names; assumes 'default'
        session is to be used (however that may be defined for a given
        database engine)
        Ancestor clears the list}
    procedure GetAliasPath(const aAlias : string;
                             var aPath  : string); virtual;
      {-return the path for a given alias
        Ancestor sets aPath to empty string}
    procedure GetAliasDriverName(const aAlias  : string;
                                   var aDriver : string); virtual;
      {-return the driver name for a given alias
        Ancestor sets aDriver to empty string}
    procedure GetTableNames(const aAlias : string;
                                  aList  : TStrings); virtual;
      {-fill list with available table names in the given alias
        Ancestor clears the list}



    {===GENERAL TABLE AND INDEX-BASED METHODS===}
    procedure FindNearestKey(aDataSet   : TDataSet;
                       const aKeyValues : array of const); virtual;
      {-position the dataset on the nearest record that matches the
        passed key (normally: use the dataset's equivalent of TTable's
        FindNearest method)
        Ancestor does nothing - no exception is raised either}
    function GetIndexDefs(aDataSet : TDataSet) : TIndexDefs; virtual;
      {-return the index definitions for the given dataset
        Ancestor returns nil}
    function GetIndexField(aDataSet    : TDataSet;
                           aFieldIndex : integer) : TField; virtual;
      {-return the TField object for the given field number in the
        current index.
        Ancestor returns nil}
    function GetIndexFieldCount(aDataSet : TDataSet) : integer; virtual;
      {-return the number of fields in the key for the current index.
        Ancestor returns zero}
    procedure GetIndexFieldNames(aDataSet         : TDataSet;
                             var aIndexFieldNames : string); virtual;
      {-return the field names for the current index for the given
        dataset
        Ancestor set aIndexFieldNames to empty string}
    procedure GetIndexName(aDataSet   : TDataSet;
                       var aIndexName : string); virtual;
      {-return the name of the current index for the given dataset
        Ancestor set aIndexName to empty string}
    function IsChildDataSet(aDataSet : TDataSet) : boolean; virtual;
      {-return whether the dataset is the detail part of a
        master/detail relationship (ie, the current index is 'locked'
        to the master dataset)
        Ancestor returns false}

    procedure SetIndexFieldNames(aDataSet         : TDataSet;
                           const aIndexFieldNames : string); virtual;
      {-set the current index to that containing the given fields for
        the given dataset
        Ancestor does nothing}
    procedure SetIndexName(aDataSet   : TDataSet;
                     const aIndexName : string); virtual;
      {-set the current index to the given name for the given dataset
        Ancestor does nothing}
  end;

{---Helper routines---}
procedure OvcFindNearestKey(aHelper    : TOvcDbEngineHelperBase;
                            aDataSet   : TDataSet;
                      const aKeyValues : array of const);
  {-Position the dataset on the nearest record that matches the passed
    key.
    In Delphi 1 and 2, the aHelper parameter is nil, and the standard
    BDE operations are performed}

procedure OvcGetAliasDriverName(aHelper : TOvcDbEngineHelperBase;
                          const aAlias  : string;
                            var aDriver : string);
  {-Return the driver name for a given alias using the passed engine
    helper.
    In Delphi 1 and 2, the aHelper parameter is nil, and the standard
    BDE operations are performed}

procedure OvcGetAliasNames(aHelper : TOvcDbEngineHelperBase;
                           aList   : TStrings);
  {-Fill list with available alias names using the passed engine
    helper.
    In Delphi 1 and 2, the aHelper parameter is nil, and the standard
    BDE operations are performed}

procedure OvcGetAliasPath(aHelper : TOvcDbEngineHelperBase;
                    const aAlias  : string;
                      var aPath   : string);
  {-Return the path for a given alias using the passed engine helper.
    In Delphi 1 and 2, the aHelper parameter is nil, and the standard
    BDE operations are performed}

function OvcGetIndexDefs(aHelper  : TOvcDbEngineHelperBase;
                         aDataSet : TDataSet) : TIndexDefs;
  {-return the index definitions for the given dataset using the
    passed engine helper.
    In Delphi 1 and 2, the aHelper parameter is nil, and the standard
    BDE operations are performed}

function OvcGetIndexField(aHelper     : TOvcDbEngineHelperBase;
                          aDataSet    : TDataSet;
                          aFieldIndex : integer) : TField;
  {-return the TField object for the given field number in the current
    index.
    In Delphi 1 and 2, the aHelper parameter is nil, and the standard
    BDE operations are performed}

function OvcGetIndexFieldCount(aHelper  : TOvcDbEngineHelperBase;
                               aDataSet : TDataSet) : integer;
  {-return the number of fields in the key for the current index.
    In Delphi 1 and 2, the aHelper parameter is nil, and the standard
    BDE operations are performed}

procedure OvcGetIndexFieldNames(aHelper          : TOvcDbEngineHelperBase;
                                aDataSet         : TDataSet;
                            var aIndexFieldNames : string);
  {-return the field names for the current index for the given
    dataset
    In Delphi 1 and 2, the aHelper parameter is nil, and the standard
    BDE operations are performed}

procedure OvcGetIndexName(aHelper    : TOvcDbEngineHelperBase;
                          aDataSet   : TDataSet;
                      var aIndexName : string);
  {-return the name of the current index for the given dataset
    In Delphi 1 and 2, the aHelper parameter is nil, and the standard
    BDE operations are performed}

procedure OvcGetTableNames(aHelper : TOvcDbEngineHelperBase;
                     const aAlias  : string;
                           aList   : TStrings);
  {-Fill list with available table names in the given alias using the
    passed engine helper.
    In Delphi 1 and 2, the aHelper parameter is nil, and the standard
    BDE operations are performed}

function OvcIsChildDataSet(aHelper  : TOvcDbEngineHelperBase;
                           aDataSet : TDataSet) : boolean;
  {-return whether the dataset is the detail part of a
    master/detail relationship (ie, the current index is 'locked'
    to the master dataset
    In Delphi 1 and 2, the aHelper parameter is nil, and the standard
    BDE operations are performed}

procedure OvcSetIndexFieldNames(aHelper          : TOvcDbEngineHelperBase;
                                aDataSet         : TDataSet;
                          const aIndexFieldNames : string);
  {-set the current index to that containing the given fields for
    the given dataset
    In Delphi 1 and 2, the aHelper parameter is nil, and the standard
    BDE operations are performed}

procedure OvcSetIndexName(aHelper    : TOvcDbEngineHelperBase;
                          aDataSet   : TDataSet;
                    const aIndexName : string);
  {-set the current index to the given name for the given dataset
    In Delphi 1 and 2, the aHelper parameter is nil, and the standard
    BDE operations are performed}

implementation

{===TOvcDbEngineHelperBase===========================================}
procedure TOvcDbEngineHelperBase.FindNearestKey(aDataSet   : TDataSet;
                                          const aKeyValues : array of const);
begin
  {do nothing}
end;
{--------}
procedure TOvcDbEngineHelperBase.GetAliasNames(aList : TStrings);
begin
  aList.BeginUpdate;
  try
    aList.Clear;
  finally
    aList.EndUpdate;
  end;
end;
{--------}
procedure TOvcDbEngineHelperBase.GetAliasPath(const aAlias : string;
                                                var aPath  : string);
begin
  aPath := '';
end;
{--------}
procedure TOvcDbEngineHelperBase.GetAliasDriverName(const aAlias  : string;
                                                      var aDriver : string);
begin
  aDriver := '';
end;
{--------}
procedure TOvcDbEngineHelperBase.GetTableNames(const aAlias : string;
                                                     aList  : TStrings);
begin
  aList.BeginUpdate;
  try
    aList.Clear;
  finally
    aList.EndUpdate;
  end;
end;
{--------}
function TOvcDbEngineHelperBase.GetIndexDefs(aDataSet : TDataSet) : TIndexDefs;
begin
  Result := nil;
end;
{--------}
function TOvcDbEngineHelperBase.GetIndexField(aDataSet    : TDataSet;
                                              aFieldIndex : integer) : TField;
begin
  Result := nil;
end;
{--------}
function TOvcDbEngineHelperBase.GetIndexFieldCount(aDataSet : TDataSet) : integer;
begin
  Result := 0;
end;
{--------}
procedure TOvcDbEngineHelperBase.GetIndexFieldNames(
                              aDataSet         : TDataSet;
                          var aIndexFieldNames : string);
begin
  aIndexFieldNames := '';
end;
{--------}
procedure TOvcDbEngineHelperBase.GetIndexName(
                               aDataSet   : TDataSet;
                           var aIndexName : string);
begin
  aIndexName := '';
end;
{--------}
function TOvcDbEngineHelperBase.IsChildDataSet(aDataSet : TDataSet) : boolean;
begin
  Result := false;
end;
{--------}
procedure TOvcDbEngineHelperBase.SetIndexFieldNames(
                                  aDataSet         : TDataSet;
                            const aIndexFieldNames : string);
begin
  {do nothing}
end;
{--------}
procedure TOvcDbEngineHelperBase.SetIndexName(aDataSet   : TDataSet;
                                        const aIndexName : string);
begin
  {do nothing}
end;
{====================================================================}


{===Helper routines==================================================}
procedure OvcFindNearestKey(aHelper    : TOvcDbEngineHelperBase;
                            aDataSet   : TDataSet;
                      const aKeyValues : array of const);
begin
  if (aHelper <> nil) then
    aHelper.FindNearestKey(aDataSet, aKeyValues);
end;
{--------}
procedure OvcGetAliasDriverName(aHelper : TOvcDbEngineHelperBase;
                          const aAlias  : string;
                            var aDriver : string);
begin
  if (aHelper <> nil) then
    aHelper.GetAliasDriverName(aAlias, aDriver)
  else
    aDriver := '';
end;
{--------}
procedure OvcGetAliasNames(aHelper : TOvcDbEngineHelperBase;
                           aList   : TStrings);
begin
  if (aHelper <> nil) then
    aHelper.GetAliasNames(aList)
  else begin
    aList.BeginUpdate;
    try
      aList.Clear;
    finally
      aList.EndUpdate;
    end;
  end;
end;
{--------}
procedure OvcGetAliasPath(aHelper : TOvcDbEngineHelperBase;
                    const aAlias  : string;
                      var aPath   : string);
begin
  if (aHelper <> nil) then
    aHelper.GetAliasPath(aAlias, aPath)
  else
    aPath := '';
end;
{--------}
function OvcGetIndexDefs(aHelper  : TOvcDbEngineHelperBase;
                         aDataSet : TDataSet) : TIndexDefs;
begin
  if (aHelper <> nil) then
    Result := aHelper.GetIndexDefs(aDataSet)
  else
    Result := nil;
end;
{--------}
function OvcGetIndexField(aHelper     : TOvcDbEngineHelperBase;
                          aDataSet    : TDataSet;
                          aFieldIndex : integer) : TField;
begin
  if (aHelper <> nil) then
    Result := aHelper.GetIndexField(aDataSet, aFieldIndex)
  else
    Result := nil;
end;
{--------}
function OvcGetIndexFieldCount(aHelper  : TOvcDbEngineHelperBase;
                               aDataSet : TDataSet) : integer;
begin
  if (aHelper <> nil) then
    Result := aHelper.GetIndexFieldCount(aDataSet)
  else
    Result := 0;
end;
{--------}
procedure OvcGetIndexFieldNames(aHelper          : TOvcDbEngineHelperBase;
                                aDataSet         : TDataSet;
                            var aIndexFieldNames : string);
begin
  if (aHelper <> nil) then
    aHelper.GetIndexFieldNames(aDataSet, aIndexFieldNames)
  else
    aIndexFieldNames := '';
end;
{--------}
procedure OvcGetIndexName(aHelper    : TOvcDbEngineHelperBase;
                          aDataSet   : TDataSet;
                      var aIndexName : string);
begin
  if (aHelper <> nil) then
    aHelper.GetIndexName(aDataSet, aIndexName)
  else
    aIndexName := '';
end;
{--------}
function OvcIsChildDataSet(aHelper  : TOvcDbEngineHelperBase;
                           aDataSet : TDataSet) : boolean;
begin
  if (aHelper <> nil) then
    Result := aHelper.IsChildDataSet(aDataSet)
  else
    Result := false;
end;
{--------}
procedure OvcSetIndexFieldNames(aHelper          : TOvcDbEngineHelperBase;
                                aDataSet         : TDataSet;
                          const aIndexFieldNames : string);
begin
  if (aHelper <> nil) then
    aHelper.SetIndexFieldNames(aDataSet, aIndexFieldNames);
end;
{--------}
procedure OvcSetIndexName(aHelper    : TOvcDbEngineHelperBase;
                          aDataSet   : TDataSet;
                    const aIndexName : string);
begin
  if (aHelper <> nil) then
    aHelper.SetIndexName(aDataSet, aIndexName);
end;
{--------}
procedure OvcGetTableNames(aHelper : TOvcDbEngineHelperBase;
                     const aAlias  : string;
                           aList   : TStrings);
begin
  if (aHelper <> nil) then
    aHelper.GetTableNames(aAlias, aList)
  else begin
    aList.BeginUpdate;
    try
      aList.Clear;
    finally
      aList.EndUpdate;
    end;
  end;
end;
{====================================================================}

end.
