{*********************************************************}
{*                  OVCTBCLR.PAS 4.06                    *}
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

unit ovctbclr;
  {-Orpheus table colors}

interface

uses
  Graphics, Classes;

type
  TOvcTableColors = class(TPersistent)
    protected {private}

      FLocked              : TColor;
      FLockedText          : TColor;
      FActiveFocused       : TColor;
      FActiveFocusedText   : TColor;
      FActiveUnfocused     : TColor;
      FActiveUnfocusedText : TColor;
      FEditing             : TColor;
      FEditingText         : TColor;
      FSelected            : TColor;
      FSelectedText        : TColor;

      FOnCfgChanged        : TNotifyEvent;


    protected

      procedure SetLocked(C : TColor);
      procedure SetLockedText(C : TColor);
      procedure SetActiveFocused(C : TColor);
      procedure SetActiveFocusedText(C : TColor);
      procedure SetActiveUnfocused(C : TColor);
      procedure SetActiveUnfocusedText(C : TColor);
      procedure SetEditing(C : TColor);
      procedure SetEditingText(C : TColor);
      procedure SetSelected(C : TColor);
      procedure SetSelectedText(C : TColor);

      procedure DoCfgChanged;


    public {protected}

      property OnCfgChanged : TNotifyEvent
         read FOnCfgChanged write FOnCfgChanged;


    public
      constructor Create;
      procedure Assign(Source : TPersistent); override;

    published
      {properties}
      property ActiveFocused : TColor
         read FActiveFocused write SetActiveFocused
           default clHighlight;

      property ActiveFocusedText : TColor
         read FActiveFocusedText write SetActiveFocusedText
           default clHighlightText;

      property ActiveUnfocused : TColor
         read FActiveUnfocused write SetActiveUnfocused
           default clHighlight;

      property ActiveUnfocusedText : TColor
         read FActiveUnfocusedText write SetActiveUnfocusedText
           default clHighlightText;

      property Locked : TColor
         read FLocked write SetLocked
           default clBtnFace;

      property LockedText : TColor
         read FLockedText write SetLockedText
           default clWindowText;

      property Editing : TColor
         read FEditing write SetEditing
           default clBtnFace;

      property EditingText : TColor
         read FEditingText write SetEditingText
           default clWindowText;

      property Selected : TColor
         read FSelected write SetSelected
           default clHighlight;

      property SelectedText : TColor
         read FSelectedText write SetSelectedText
           default clHighlightText;
    end;

implementation


{===TOvcTableColors==================================================}
constructor TOvcTableColors.Create;
  begin
    FLocked := clBtnFace;
    FLockedText := clWindowText;
    FActiveFocused := clHighlight;
    FActiveFocusedText := clHighlightText;
    FActiveUnfocused := clHighlight;
    FActiveUnfocusedText := clHighlightText;
    FEditing := clBtnFace;
    FEditingText := clWindowText;
    FSelected := clHighlight;
    FSelectedText := clHighlightText;
  end;
{--------}
procedure TOvcTableColors.Assign(Source : TPersistent);
  begin
    if (Source is TOvcTableColors) then
      begin
        FLocked := TOvcTableColors(Source).Locked;
        FLockedText := TOvcTableColors(Source).LockedText;
        FActiveFocused := TOvcTableColors(Source).ActiveFocused;
        FActiveFocusedText := TOvcTableColors(Source).ActiveFocusedText;
        FActiveUnfocused := TOvcTableColors(Source).ActiveUnfocused;
        FActiveUnfocusedText := TOvcTableColors(Source).ActiveUnfocusedText;
        FEditing := TOvcTableColors(Source).Editing;
        FEditingText := TOvcTableColors(Source).EditingText;
        FSelected := TOvcTableColors(Source).Selected;
        FSelectedText := TOvcTableColors(Source).SelectedText;
        DoCfgChanged;
      end;
  end;
{--------}
procedure TOvcTableColors.DoCfgChanged;
  begin
    if Assigned(FOnCfgChanged) then
      FOnCfgChanged(Self);
  end;
{--------}
procedure TOvcTableColors.SetActiveFocused(C : TColor);
  begin
    if (C <> FActiveFocused) then
      begin
        FActiveFocused := C;
        DoCfgChanged;
      end;
  end;
{--------}
procedure TOvcTableColors.SetActiveFocusedText(C : TColor);
  begin
    if (C <> FActiveFocusedText) then
      begin
        FActiveFocusedText := C;
        DoCfgChanged;
      end;
  end;
{--------}
procedure TOvcTableColors.SetActiveUnfocused(C : TColor);
  begin
    if (C <> FActiveUnfocused) then
      begin
        FActiveUnfocused := C;
        DoCfgChanged;
      end;
  end;
{--------}
procedure TOvcTableColors.SetActiveUnfocusedText(C : TColor);
  begin
    if (C <> FActiveUnfocusedText) then
      begin
        FActiveUnfocusedText := C;
        DoCfgChanged;
      end;
  end;
{--------}
procedure TOvcTableColors.SetEditing(C : TColor);
  begin
    if (C <> FEditing) then
      begin
        FEditing := C;
        DoCfgChanged;
      end;
  end;
{--------}
procedure TOvcTableColors.SetEditingText(C : TColor);
  begin
    if (C <> FEditingText) then
      begin
        FEditingText := C;
        DoCfgChanged;
      end;
  end;
{--------}
procedure TOvcTableColors.SetLocked(C : TColor);
  begin
    if (C <> FLocked) then
      begin
        FLocked := C;
        DoCfgChanged;
      end;
  end;
{--------}
procedure TOvcTableColors.SetLockedText(C : TColor);
  begin
    if (C <> FLockedText) then
      begin
        FLockedText := C;
        DoCfgChanged;
      end;
  end;
{--------}
procedure TOvcTableColors.SetSelected(C : TColor);
  begin
    if (C <> FSelected) then
      begin
        FSelected := C;
        DoCfgChanged;
      end;
  end;
{--------}
procedure TOvcTableColors.SetSelectedText(C : TColor);
  begin
    if (C <> FSelectedText) then
      begin
        FSelectedText := C;
        DoCfgChanged;
      end;
  end;
{====================================================================}

end.
