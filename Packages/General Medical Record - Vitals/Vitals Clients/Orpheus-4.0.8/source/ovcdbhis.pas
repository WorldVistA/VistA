{*********************************************************}
{*                   OVCDBHIS.PAS 4.06                   *}
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

unit OvcDbHIs;
  {DBISAM database engine helper class}

{Notes: DBISAM is a database engine by Extended Systems.
          http://www.elevatesoft.com/
        DBISAM does not support aliases, hence all alias name support
        is defaulted to the ancestor.}

interface

uses
  Windows, Messages, SysUtils, Classes, OvcBase, Db, DBISAMTb, OvcDbHLL;

type
  TOvcDbDBISAMEngineHelper = class(TOvcDbEngineHelperBase)
  protected {private}
  public
    {===GENERAL TABLE AND INDEX-BASED METHODS===}
    {-position the dataset on the nearest record that matches the passed    }
    { key                                                                   }
    procedure FindNearestKey(aDataSet   : TDataSet;
                       const aKeyValues : array of const); override;
    {-return the index definitions for the given dataset}
    function GetIndexDefs(aDataSet : TDataSet) : TIndexDefs; override;
    {-return the TField object for the given field number in the current    }
    { index.                                                                }
    function GetIndexField(aDataSet    : TDataSet;
                           aFieldIndex : integer) : TField; override;
    {-return the number of fields in the key for the current index.         }
    function GetIndexFieldCount(aDataSet : TDataSet) : integer; override;
    {-return the field names for the current index for the given dataset    }
    procedure GetIndexFieldNames(aDataSet         : TDataSet;
                             var aIndexFieldNames : string); override;
    {-return the name of the current index for the given dataset            }
    procedure GetIndexName(aDataSet   : TDataSet;
                       var aIndexName : string); override;
    {-return whether the dataset is the detail part of a master/detail      }
    { relationship (ie, the current index is 'locked' to the master dataset)}
    function IsChildDataSet(aDataSet : TDataSet) : boolean; override;
    {-set the current index to that containing the given fields for         }
    { the given dataset                                                     }
    procedure SetIndexFieldNames(aDataSet         : TDataSet;
                           const aIndexFieldNames : string); override;
    {-set the current index to the given name for the given dataset         }
    procedure SetIndexName(aDataSet   : TDataSet;
                     const aIndexName : string); override;


  end;

implementation

{===TOvcDbDBISAMEngineHelper=========================================}
procedure TOvcDbDBISAMEngineHelper.FindNearestKey(aDataSet   : TDataSet;
                                            const aKeyValues : array of const);
begin
  (aDataSet as TDBISAMTable).FindNearest(aKeyValues);
end;
{=====}

function TOvcDbDBISAMEngineHelper.GetIndexDefs(aDataSet : TDataSet) : TIndexDefs;
begin
  Result := (aDataSet as TDBISAMTable).IndexDefs;
end;
{=====}

function TOvcDbDBISAMEngineHelper.GetIndexField(aDataSet    : TDataSet;
                                                aFieldIndex : integer) : TField;
begin
  Result := (aDataSet as TDBISAMTable).IndexFields[aFieldIndex];
end;
{=====}

function TOvcDbDBISAMEngineHelper.GetIndexFieldCount(aDataSet : TDataSet) : integer;
begin
  Result := (aDataSet as TDBISAMTable).IndexFieldCount;
end;
{=====}

procedure TOvcDbDBISAMEngineHelper.GetIndexFieldNames(aDataSet         : TDataSet;
                                                  var aIndexFieldNames : string);
begin
  aIndexFieldNames := (aDataSet as TDBISAMTable).IndexFieldNames;
end;
{=====}

procedure TOvcDbDBISAMEngineHelper.GetIndexName(aDataSet   : TDataSet;
                                            var aIndexName : string);
begin
  aIndexName := (aDataSet as TDBISAMTable).IndexName;
end;
{=====}

function TOvcDbDBISAMEngineHelper.IsChildDataSet(aDataSet : TDataSet) : boolean;
begin
  Result := (aDataSet as TDBISAMTable).MasterSource <> nil;
end;
{=====}

procedure TOvcDbDBISAMEngineHelper.SetIndexFieldNames(aDataSet         : TDataSet;
                                                const aIndexFieldNames : string);
begin
  (aDataSet as TDBISAMTable).IndexFieldNames := aIndexFieldNames;
end;
{=====}

procedure TOvcDbDBISAMEngineHelper.SetIndexName(aDataSet   : TDataSet;
                                          const aIndexName : string);
begin
  (aDataSet as TDBISAMTable).IndexName := aIndexName;
end;

end.
