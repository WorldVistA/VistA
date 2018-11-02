{*********************************************************}
{*                  OVCTGRES.PAS 4.06                    *}
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

unit ovctgres;
  {-Orpheus glyph resource manager}

interface

uses
  Windows, SysUtils, Classes, Graphics, OvcMisc;

type
  TOvcCellGlyphs = class(TPersistent)
    protected {private}

      FResource         : pointer;
      FActiveGlyphCount : Integer;
      FGlyphCount       : Integer;
      FOnCfgChanged     : TNotifyEvent;

    protected

      function GetBitMap : TBitMap;
      function GetIsDefault : boolean;
      procedure SetActiveGlyphCount(G : Integer);
      procedure SetBitMap(BM : TBitMap);
      procedure SetGlyphCount(G : Integer);
      procedure SetIsDefault(D : boolean);

      procedure CalcGlyphCount;
      function IsNotDefault : boolean;
      procedure DoCfgChanged;

    public {protected}

      property OnCfgChanged : TNotifyEvent
         read FOnCfgChanged write FOnCfgChanged;


    public
      constructor Create;
      destructor Destroy; override;

      procedure Assign(Source : TPersistent); override;

    published
      {Note: must be in this order--IsDefault, BitMap, GlyphCount, ActiveGlyphCount}
      property IsDefault : boolean
         read GetIsDefault write SetIsDefault
         stored true;

      property BitMap : TBitMap
         read GetBitMap write SetBitMap
         stored IsNotDefault;

      property GlyphCount : Integer
         read FGlyphCount write SetGlyphCount;

      property ActiveGlyphCount : Integer
         read FActiveGlyphCount write SetActiveGlyphCount;
  end;

implementation


type
  PCellGlyphResource = ^TCellGlyphResource;
  TCellGlyphResource = packed record
    BitMap : TBitMap;
    ResourceCount : Integer;
    Next : PCellGlyphResource;
  end;

  TGlyphResourceManager = class
    private
      FList : PCellGlyphResource;
      DefRes : PCellGlyphResource;
    protected
    public
      constructor Create;
      destructor Destroy; override;

      function AllocResource(BM : TBitMap) : PCellGlyphResource;
      procedure FreeResource(CBGR : PCellGlyphResource);
      function ReallocResource(ToCBGR, FromCBGR : PCellGlyphResource) : PCellGlyphResource;
      function DefaultResource : PCellGlyphResource;
  end;

var
  CBResMgr : TGlyphResourceManager;

function CreateNewResource : PCellGlyphResource;
  var
    Size : Integer;
  begin
    Size := sizeof(TCellGlyphResource);
    GetMem(Result, Size);
    FillChar(Result^, Size, 0);
    with Result^ do
      begin
        ResourceCount := 1;
      end;
  end;

procedure DestroyResource(ARes : PCellGlyphResource);
  begin
    FreeMem(ARes {, sizeof(TCellGlyphResource)});
  end;

{===TGlyphResourceManager=========================================}
constructor TGlyphResourceManager.Create;
  begin
    DefRes := CreateNewResource;
    with DefRes^ do
      begin
        BitMap := TBitMap.Create;
        BitMap.Handle := LoadBaseBitmap('ORTCCHECKGLYPHS');
      end;
    FList := DefRes;
  end;
{--------}
destructor TGlyphResourceManager.Destroy;
  var
    Temp : PCellGlyphResource;
  begin
    while Assigned(FList) do
      begin
        Temp := FList;
        FList := Temp^.Next;
        Temp^.BitMap.Free;
        DestroyResource(Temp);
      end;
  end;
{--------}
function TGlyphResourceManager.AllocResource(BM : TBitMap) : PCellGlyphResource;
  var
    NewRes : PCellGlyphResource;
  begin
    NewRes := CreateNewResource;
    with NewRes^ do
      begin
        BitMap := TBitMap.Create;
        BitMap.Assign(BM);
        Next := FList;
      end;
    FList := NewRes;
    Result := NewRes;
  end;
{--------}
procedure TGlyphResourceManager.FreeResource(CBGR : PCellGlyphResource);
  var
    Temp, Dad : PCellGlyphResource;
  begin
    Temp := FList;
    Dad := nil;
    while (Temp <> nil) do
      if (Temp = CBGR) then
        begin
          dec(Temp^.ResourceCount);
          if (Temp^.ResourceCount = 0) then
            begin
              with Temp^ do
                begin
                  if (Dad = nil) then
                       FList := Next
                  else Dad^.Next := Next;
                  BitMap.Free;
                end;
              DestroyResource(Temp);
            end;
          Temp := nil; {get out of loop}
        end
      else
        begin
          Dad := Temp;
          Temp := Temp^.Next;
        end;
  end;
{--------}
function TGlyphResourceManager.ReallocResource(ToCBGR, FromCBGR : PCellGlyphResource)
            : PCellGlyphResource;
  var
    Temp : PCellGlyphResource;
  begin
    FreeResource(FromCBGR);
    Temp := FList;
    while (Temp <> nil) do
      if (Temp = ToCBGR) then
        begin
          inc(Temp^.ResourceCount);
          Result := Temp;
          Exit;
        end
      else
        Temp := Temp^.Next;
    Result := DefaultResource;
  end;
{--------}
function TGlyphResourceManager.DefaultResource : PCellGlyphResource;
  begin
    inc(DefRes^.ResourceCount);
    Result := DefRes;
  end;
{====================================================================}

{===TOvcCellGlyphs==================================================}
constructor TOvcCellGlyphs.Create;
  begin
    FResource := CBResMgr.DefaultResource;
    CalcGlyphCount;
  end;
{--------}
destructor TOvcCellGlyphs.Destroy;
  begin
    CBResMgr.FreeResource(PCellGlyphResource(FResource));
  end;
{--------}
procedure TOvcCellGlyphs.Assign(Source : TPersistent);
  {Changes:
     09/2012, AB: Bugfix: Did not work with Source=nil (as 'Source is TOvcCellGlyphs'
              is False in this case. }
  begin
    if (Source is TOvcCellGlyphs) or (Source = nil) then begin
      if (Source = nil) then
        begin
          CBResMgr.FreeResource(PCellGlyphResource(FResource));
          FResource := CBResMgr.DefaultResource;
        end
      else if (FResource <> TOvcCellGlyphs(Source).FResource) then
        FResource :=
           CBResMgr.ReallocResource(PCellGlyphResource(TOvcCellGlyphs(Source).FResource),
                                    PCellGlyphResource(FResource));
      CalcGlyphCount;
      DoCfgChanged
    end else inherited Assign(Source);
  end;
{--------}
procedure TOvcCellGlyphs.CalcGlyphCount;
  var
    Temp : Integer;
  begin
    FGlyphCount := 1;
    FActiveGlyphCount := 1;
    with BitMap do
      begin
        if (Height > 0) then
          begin
            Temp := Width div Height;
            if ((Temp * Height) = Width) then
              begin
                FGlyphCount := Temp;
                FActiveGlyphCount := Temp;
              end;
          end;
      end;
  end;
{--------}
function TOvcCellGlyphs.GetBitMap : TBitMap;
  begin
    with PCellGlyphResource(FResource)^ do
      Result := Bitmap;
  end;
{--------}
function TOvcCellGlyphs.GetIsDefault : boolean;
  begin
    Result := FResource = pointer(CBResMgr.DefRes);
  end;
{--------}
function TOvcCellGlyphs.IsNotDefault : boolean;
  begin
    Result := not IsDefault;
  end;
{--------}
procedure TOvcCellGlyphs.DoCfgChanged;
  begin
    if Assigned(FOnCfgChanged) then
      FOnCfgChanged(Self);
  end;
{--------}
procedure TOvcCellGlyphs.SetActiveGlyphCount(G : Integer);
  begin
    if (G <> FActiveGlyphCount) and
       (1 <= G) and (G <= GlyphCount)then
      begin
        FActiveGlyphCount := G;
        DoCfgChanged;
      end;
  end;
{--------}
procedure TOvcCellGlyphs.SetBitMap(BM : TBitMap);
  begin
    CBResMgr.FreeResource(PCellGlyphResource(FResource));
    if (BM = nil) then
      FResource := CBResMgr.DefaultResource
    else
      FResource := CBResMgr.AllocResource(BM);
    CalcGlyphCount;
    DoCfgChanged;
  end;
{--------}
procedure TOvcCellGlyphs.SetGlyphCount(G : Integer);
  begin
    if (G <> FGlyphCount) then
      begin
        FGlyphCount := G;
        FActiveGlyphCount := G;
        DoCfgChanged;
      end;
  end;
{--------}
procedure TOvcCellGlyphs.SetIsDefault(D : boolean);
  begin
    if (D <> IsDefault) then
      begin
        if D then
          Assign(nil)
        else
          BitMap := BitMap; {note: this actually does do something!}
        CalcGlyphCount;
        DoCfgChanged;
      end;
  end;
{====================================================================}


procedure DestroyManager; far;
  begin
    CBResMgr.Free;
  end;


initialization
  CBResMgr := TGlyphResourceManager.Create;

finalization
  DestroyManager;
end.
