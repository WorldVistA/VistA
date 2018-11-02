{*********************************************************}
{*                  O32BGSTY.PAS 4.06                    *}
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

unit O32BGSty;
  {Orpheus Background classes and methods}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TBGImageStyle = (bgNone, bgNormal, bgCenter, bgStretch, bgTile);

  TO32BackgroundStyle = class(TPersistent)
  protected {private}
    FAlphaBlend: Byte; {Range 0 to 255}
    FColor: TColor;
    FEnabled: Boolean;
    FImage: TBitmap;
    FImageStyle: TBGImageStyle;
    procedure SetAlphaBlend(Value: Byte);
    procedure SetColor(NewColor: TColor);
    procedure SetEnabled(Value: Boolean);
    procedure SetImage(Image: TBitmap);
    procedure SetImageStyle(Style: TBGImageStyle);
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure PaintBG(Sender: TObject; Canvas: TCanvas; const Rct: TRect);
  published
    property AlphaBlend: Byte read FAlphaBlend write SetAlphaBlend;
    property Color: TColor read FColor write SetColor;
    property Enabled: Boolean read FEnabled write SetEnabled;
    property Image: TBitmap read FImage write SetImage;
    property ImageStyle: TBGImageStyle read FImageStyle write SetImageStyle;
  end;

implementation

end.
