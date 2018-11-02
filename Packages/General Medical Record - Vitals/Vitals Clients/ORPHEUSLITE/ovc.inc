{*********************************************************}
{*                     OVC.INC                           *}
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

{Conditional defines that affect compilation}

{$Q-} {Overflow Checking}
{$R-} {Range-Checking}
{$S-} {Stack-Overflow Checking}
{$V-} {Var-String Checking}
{$T-} {No type-checked pointers}
{$X+} {Extended syntax}
{$P-} {No open string parameters}
{$B-} {Incomplete Boolean evaluation}
{$J+} {Writable constants}
{$H+} {Huge strings}

{General define indicating use under C++ Builder}
{$IFDEF VER93}
  {$DEFINE CBuilder}
{$ENDIF}
{$IFDEF VER110}
  {$DEFINE CBuilder}
  {$ObjExportAll On}
{$ENDIF}
{$IFDEF VER125}
  {$DEFINE CBuilder}
  {$ObjExportAll On}
{$ENDIF}
{$IFDEF VER130}
  {$IFDEF BCB}
    {$DEFINE CBuilder}
    {$ObjExportAll On}
  {$ENDIF}
{$ENDIF}
{$IFDEF VER140}                                                       {!!.04}
  {$IFDEF BCB}                                                        {!!.04}
    {$DEFINE CBuilder}                                                {!!.04}
    {$ObjExportAll On}                                                {!!.04}
  {$ENDIF}                                                            {!!.04}
{$ENDIF}                                                              {!!.04}

{$IFNDEF VER80}       {Delphi 1.0}
 {$DEFINE VERSION2}   {Delphi 2.0 and BCB 1 or higher}
{$ENDIF}

{$IFDEF VERSION2}
 {$IFNDEF VER90}      {Delphi 2.0}
  {$IFNDEF VER93}     {BCB 1.0}
   {$DEFINE VERSION3} {Delphi 3.0 or BCB 3.0}
  {$ENDIF}
 {$ENDIF}
{$ENDIF}

{$IFDEF VERSION3}
 {$IFNDEF VER100}     {Delphi 3}
  {$IFNDEF VER110}    {BCB 3}
   {$DEFINE VERSION4} {Delphi 4.0 or higher}
  {$ENDIF}
 {$ENDIF}
{$ENDIF}

{$IFDEF VERSION4}
 {$IFNDEF VER120}     {Delphi 4}
  {$IFNDEF VER125}    {BCB 4}
   {$DEFINE VERSION5} {Delphi 5.0 or higher}
  {$ENDIF}
 {$ENDIF}
{$ENDIF}

{$IFDEF VERSION5}
 {$IFNDEF VER130}     {Delphi 5}
  {$IFNDEF VER135}    {BCB 5}
   {$DEFINE VERSION6} {Delphi 6.0 or higher}
  {$ENDIF}
 {$ENDIF}
{$ENDIF}

{$IFDEF VERSION6}
 {$IFNDEF VER140}     {Delphi 6}
  {$IFNDEF VER145}    {BCB 6}
   {$DEFINE VERSION7} {Delphi 7.0 or higher}
  {$ENDIF}
 {$ENDIF}
{$ENDIF}

{$IFDEF VERSION2}
 {$IFNDEF VERSION3}
  {$DEFINE VERSION2ONLY}
 {$ENDIF}
{$ENDIF}

{$IFDEF VERSION3}
 {$IFNDEF VERSION4}
  {$DEFINE VERSION3ONLY}
 {$ENDIF}
{$ENDIF}

{$IFDEF Win32}
  {$A+} {Word Align Data}
{$ELSE}
  {$A-} {Byte Align Data}
{$ENDIF}

{$IFDEF VERSION6}
  {$WARN SYMBOL_PLATFORM OFF}
  {$IFDEF VERSION7}
    {$B- Incomplete boolean evaluation}
    {$H+ Long string support}
    {$J+ Writeable typed constants}
    {$P- No open string parameters}
    {$T- No type-checked pointers}
    {$V- No var string checking}
    {$X+ Extended syntax}
    {$Z1 Enumerations are word sized}
    {$WARN UNIT_PLATFORM OFF}
    {$WARN UNSAFE_CODE OFF}
    {$WARN UNSAFE_TYPE OFF}
    {$WARN UNSAFE_CAST OFF}
    {$WARN UNIT_DEPRECATED OFF}
  {$ENDIF}
{$ENDIF}
{ This define turns off all platform warnings in Delphi 6.  Delphi 6 }
{ is cross-platform compatible with Kylix and all of Orpheus' Win32  }
{ only stuff causes the compiler to throw a truckload of platform    }
{ warnings when rebuilding packages.                                 }

{.$DEFINE ZeroDateAsNull}
{This define enables special handling for a zero date. If defined,   }
{assigning 0 to a date field is treated the same as assigning the    }
{constant "BadDate" (see manual) using the AsDateTime property.      }
{Otherwise, 0 is treated as a valid date. (32-bit only)              }
