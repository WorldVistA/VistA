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
{* Roman Kassebaum                                                            *}
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

{$WARN SYMBOL_PLATFORM OFF}
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

{.$DEFINE ZeroDateAsNull}
{This define enables special handling for a zero date. If defined,   }
{assigning 0 to a date field is treated the same as assigning the    }
{constant "BadDate" (see manual) using the AsDateTime property.      }
{Otherwise, 0 is treated as a valid date. (32-bit only)              }
