{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
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
{*    Sebastian Zierer (Upgraded to Unicode)                                  *}
{*    Roman Kassebaum                                                         *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

{*********************************************************}
{*                  OVCOUTLN.PAS 4.06                    *}
{*********************************************************}

unit ovcoutln;

interface

uses
  Windows, Classes, Controls, Forms, Graphics, Messages, SysUtils, OvcBase, OvcMisc,
  OvcVLB, OvcDlm, StdCtrls, UITypes;

const
  ChildIndent = 17;
type
  TOvcOlNodeStyle = (osPlain, osRadio, osCheck);
  TOvcOlNodeMode  = (omPreload, omDynamicLoad, omDynamic);

  TOvcCustomOutline = class;
  TOvcOutlineNode = class;

  TOvcOlActiveChangeEvent =
    procedure(Sender : TOvcCustomOutline; OldNode, NewNode : TOvcOutlineNode)
      of object;

  TOvcOlCompareNodesEvent =
    procedure(Sender : TOvcCustomOutline; Key : Integer;
      Node1, Node2 : TOvcOutlineNode; var Result : Integer) of object;

  TOvcOlDrawTextEvent =
    procedure(Sender : TOvcCustomOutline; Canvas : TCanvas;
      Node: TOvcOutlineNode; const Text : string; Rect : TRect;
      var DefaultDrawing : Boolean) of object;

  TOvcOlDrawCheckEvent =
    procedure(Sender : TOvcCustomOutline; Canvas : TCanvas;
      Node: TOvcOutlineNode; Rect : TRect;
      Style : TOvcOlNodeStyle; Checked : Boolean;
      var DefaultDrawing : Boolean) of object;

  TOvcOlNodeEvent =
    procedure(Sender : TOvcCustomOutline; Node : TOvcOutlineNode) of object;

  TOvcOutlineNodes = class;

  TOvcOutlineNode = class(TPersistent)
  

  protected
    FAddIndex : Integer;
    FButtonRect : TRect;
    FExpanded : Boolean;
    FData: Pointer;
    FOutline: TOvcCustomOutline;
    FFChildren : TOvcOutlineNodes;
    FChecked : Boolean;
    FImageIndex: Integer;
    FMode : TOvcOlNodeMode;
    FOwner: TOvcOutlineNodes;
    FParent : TOvcOutlineNode;
    FRadioRect : TRect;
    FStyle : TOvcOlNodeStyle;
    FText: string;
    FTextRect : TRect;
    FTruncated : Boolean;
    ExpandEventCalled : Boolean;
    Seq: Integer;
    function GetCount: Integer;
    function GetHasChildren: Boolean;
    function GetHasParent: Boolean;
    function GetNode(Index: Integer): TOvcOutlineNode;
    function GetLevel: Integer;
    function GetLineCount: Integer;
    function GetVisible : Boolean;
    procedure MakeChildrenVisible;
    procedure SetChecked(Value : Boolean);
    procedure SetData(const Value: Pointer);
    procedure SetExpanded(const Value: Boolean);
    procedure SetImageIndex(const Value: Integer);
    procedure SetParent(Value : TOvcOutlineNode);
    procedure SetStyle(Value : TOvcOlNodeStyle);
    procedure SetText(const Value: string);
    procedure SetVisible(const Value: Boolean);
    property TextRect : TRect read FTextRect write FTextRect;
    property Truncated : Boolean read FTruncated write FTruncated;
    property ButtonRect : TRect read FButtonRect write FButtonRect;
    property RadioRect : TRect read FRadioRect write FRadioRect;
    property LineCount : Integer read GetLineCount;
    function GetChildren: TOvcOutlineNodes;
    procedure PushChildIndex;
    procedure PopChildIndex;
    function FirstChild: TOvcOutlineNode;
    function NextChild: TOvcOutlineNode;
    function LastChild: TOvcOutlineNode;
  public
    procedure Assign(Source: TPersistent); override;
    constructor Create(AOutline: TOvcCustomOutline; AOwner: TOvcOutlineNodes;
      AParent : TOvcOutlineNode; const Data : Pointer);
    destructor Destroy; override;
    function Index : Integer;
    function IsFirstSibling: Boolean;
    function IsLastSibling: Boolean;
    function IsSibling(Value : TOvcOutlineNode): Boolean;
    property Owner: TOvcOutlineNodes read FOwner;

    property AddIndex : Integer read FAddIndex;
    property Checked : Boolean read FChecked write SetChecked;
    procedure Collapse(Recurse: Boolean);
    property Count: Integer read GetCount;
    property Data: Pointer read FData write SetData;
    procedure DeleteChildren;
    procedure Expand(Recurse: Boolean);
    property Expanded: Boolean read FExpanded write SetExpanded;
    property HasChildren: Boolean read GetHasChildren;
    property HasParent : Boolean read GetHasParent;
    property ImageIndex : Integer read FImageIndex write SetImageIndex
                   default -1;
    procedure Invalidate;
    property Node[Index: Integer]: TOvcOutlineNode read GetNode; default;
    property Level: Integer read GetLevel;
    property Mode : TOvcOlNodeMode read FMode write FMode
      default omPreload;
    property Outline: TOvcCustomOutline read FOutline;
    property Parent: TOvcOutlineNode read FParent write SetParent;
    property Style : TOvcOlNodeStyle read FStyle write SetStyle;
    property Text: string read FText write SetText;
    property Visible : Boolean read GetVisible write SetVisible;
  end;

  TOvcOutlineNodeList = class
  protected
    List: TOvcSortedList;
    function GetNode(Index: Integer): TOvcOutlineNode;
    function GetCurrentKey: Integer;
    procedure SetCurrentKey(const Value: Integer);
  public
    constructor Create(NumKeys : Integer; CompareFunc : TOvcMultiCompareFunc);
    destructor Destroy; override;
    function First(var Node: TOvcOutlineNode): Boolean;
    function Next(var Node: TOvcOutlineNode): Boolean;
    function Last(var Node: TOvcOutlineNode): Boolean;
    function Count: Integer;
    procedure Add(NewNode: TOvcOutlineNode);
    procedure Delete(Node: TOvcOutlineNode);
    function Empty: Boolean;
    function FirstItem: TOvcOutlineNode;
    function NextItem: TOvcOutlineNode;
    function LastItem: TOvcOutlineNode;
    property CurrentKey: Integer read GetCurrentKey write SetCurrentKey;
    procedure Clear;
    property Node[Index: Integer]: TOvcOutlineNode read GetNode;
    function GGEQ(SearchNode: TOvcOutlineNode): TOvcOutlineNode;
    function GLEQ(SearchNode: TOvcOutlineNode): TOvcOutlineNode;
    procedure PushIndex;
    procedure PopIndex;
  end;

  TOvcOutlineNodes = class(TPersistent)

  protected
    FOwner: TOvcCustomOutline;
    FParent : TOvcOutlineNode;
    procedure DefineProperties(Filer: TFiler); override;
    function GetCount: Integer;
    function GetNode(Index: Integer): TOvcOutlineNode;
    function GetLineCount: Integer;
    property LineCount : Integer read GetLineCount;
    function FirstChild: TOvcOutlineNode;
    function LastChild: TOvcOutlineNode;
    procedure PushChildIndex;
    procedure PopChildIndex;
    function NextChild: TOvcOutlineNode;
  public
    procedure Assign(Source: TPersistent); override;

    function Add(const S: string): TOvcOutlineNode;
    function AddButtonChild(Node: TOvcOutlineNode; const S: string;
                   InitStyle : TOvcOlNodeStyle; InitChecked : Boolean): TOvcOutlineNode;
    function AddButtonChildObject(Node: TOvcOutlineNode; const S: string;
                   Ptr: Pointer; InitStyle : TOvcOlNodeStyle; InitChecked : Boolean)
                   : TOvcOutlineNode;
    function AddChild(Node: TOvcOutlineNode; const S: string): TOvcOutlineNode;
    function AddChildEx(Node: TOvcOutlineNode; const S: string;
                   InitImageIndex : Integer; InitMode : TOvcOlNodeMode): TOvcOutlineNode;
    function AddChildObject(Node: TOvcOutlineNode; const S: string;
                   Ptr: Pointer): TOvcOutlineNode;
    function AddChildObjectEx(Node: TOvcOutlineNode; const S: string;
                   Ptr: Pointer; InitImageIndex : Integer; InitMode : TOvcOlNodeMode):
                   TOvcOutlineNode;
    function AddEx(const S: string; InitImageIndex : Integer; InitMode : TOvcOlNodeMode)
                   : TOvcOutlineNode;
    function AddObject(const S: string;
                   Ptr: Pointer): TOvcOutlineNode;
    function AddObjectEx(const S: string;
                   Ptr: Pointer; InitImageIndex : Integer; InitMode : TOvcOlNodeMode):
                   TOvcOutlineNode;
    procedure Clear;
    property Count: Integer read GetCount;
    constructor Create(AOwner: TOvcCustomOutline; AParent : TOvcOutlineNode);
    destructor Destroy; override;
    property Node[Index: Integer]: TOvcOutlineNode read GetNode;
                   default;
    property Owner: TOvcCustomOutline read FOwner;
  end;


  TOvcCustomOutline = class(TOvcCustomVirtualListBox)
  protected
    FActiveNode     : TOvcOutlineNode;
    FCurrentKey     : Integer;
    FHideSelection  : Boolean;
    FKeys           : Integer;
    FOnActiveChange : TOvcOlActiveChangeEvent;
    FOnCompareNodes : TOvcOlCompareNodesEvent;
    FOnDrawText     : TOvcOlDrawTextEvent;
    FOnDrawCheck    : TOvcOlDrawCheckEvent;
    FOnDynamicLoad  : TOvcOlNodeEvent;
    FOnExpand       : TOvcOlNodeEvent;
    FOnCollapse     : TOvcOlNodeEvent;
    FOnNodeClick    : TOvcOlNodeEvent;
    FOnNodeDestroy  : TOvcOlNodeEvent;
    FNodes          : TOvcOutlineNodes;
    FShowLines      : Boolean;
    FShowButtons    : Boolean;
    FImages         : TImageList;
    FShowImages     : Boolean;
    FTextSort       : Boolean;
    IsSimulated     : Boolean;
    {HintShownHere   : Boolean;}
    {HintWindow      : THintWindow;}
    {HintX           : Integer;}
    {HintY           : Integer;}
    LineCanvas      : TBitmap;
    {FHoverTimer     : Integer;}
    NodeCache       : TOvcLiteCache;
    FAbsNodes       : TOvcOutlineNodeList;
    FNodeIndex      : TOvcOutlineNodeList;
    AddIndex        : Integer;
    FDelayNotify    : Boolean;
    Clearing        : Boolean;
    UpdateScrollWidthPending : Boolean;
    FCacheSize: Integer;
    procedure SetCacheSize(const Value: Integer);
    function FirstChild: TOvcOutlineNode;
    function NextChild: TOvcOutlineNode;
    function LastChild: TOvcOutlineNode;
    procedure PopChildIndex;
    procedure PushChildIndex;
    procedure SetTextSort(const Value: Boolean);
    procedure SetCurrentKey(const Value: Integer);
    procedure SetKeys(const Value: Integer);
    procedure CMHintShow(var Message: TMessage); message CM_HINTSHOW;
    procedure Click; override;
    procedure DblClick; override;
    function CalcMaxWidth: Integer;
    function CompareNodesGlobal(Key : Integer; I1,I2 : Pointer) : Integer;
    function CompareNodesLocal(Key : Integer; I1,I2 : Pointer) : Integer;
    procedure DoActiveChange(OldNode, NewNode: TOvcOutlineNode); virtual;
    function DoDrawCheck(Canvas : TCanvas; Node: TOvcOutlineNode;
              Rect : TRect; Style : TOvcOlNodeStyle; Checked : Boolean) : Boolean; virtual;
    function DoDrawText(Canvas : TCanvas; Node: TOvcOutlineNode;
             const Text : String; Rect : TRect) : Boolean; virtual;
    procedure DoDynamicLoad(Node : TOvcOutlineNode); virtual;
    procedure DoExpandCollapse(Node : TOvcOutlineNode; Expanding : Boolean); dynamic;
    procedure DoNodeDestroy(Node : TOvcOutlineNode); virtual;
    function DoOnIsSelected(Index : Integer) : Boolean; override;
    procedure DoOnSelect(Index : Integer; Selected : Boolean); override;
    procedure DoNodeClick(Node: TOvcOutlineNode);
    function GetIsGroup(Index: Integer): Boolean;
    function GetAbsNodes : Integer;
    function GetAbsNode(Index : Integer): TOvcOutlineNode;
    function GetNode(Index: Integer): TOvcOutlineNode;
    {procedure HideHint;}
    {procedure HoverTimerEvent(Sender : TObject; Handle : Integer;
                         Interval : Cardinal; ElapsedTime : Integer);}
    property IsGroup[Index : Integer] : Boolean read GetIsGroup;
    procedure SetNodes(const Value: TOvcOutlineNodes);
    procedure KeyPress(var Key: Char); override;
    function Lines : Integer;
    {procedure Loaded; override;}
    function IndexFromNode(CurNode : TOvcOutlineNode) : Integer;
    procedure Notification(AComponent: TComponent; Operation: TOperation);
                   override;
    procedure Paint; override;
    function PointToIndex(Y: Integer): Integer;
    procedure SetActiveNode(const Value: TOvcOutlineNode);
    procedure SetHideSelection(const Value : Boolean);
    procedure SetImages(const Value: TImageList);
    procedure SetScrollBars(const Value : TScrollStyle); override;
    procedure SetShowButtons(const Value: Boolean);
    procedure SetShowImages(const Value: Boolean);
    procedure SetShowLines(const Value: Boolean);
    procedure SimulatedClick; override;
    procedure UpdateActiveNode;
    procedure UpdateScrollWidth;
    procedure UpdateLines;
    procedure vlbDrawFocusRect(Canvas : TCanvas; const Rect : TRect);
    procedure WMLButtonDown(var Msg : TWMLButtonDown); message WM_LBUTTONDOWN;
    {procedure WMMouseMove(var Msg : TWMMouseMove); message WM_MOUSEMOVE;}
    procedure WMSetFocus(var Msg : TWMSetFocus);
      message WM_SETFOCUS;
    procedure WMKeyDown(var Msg : TWMKeyDown);
      message WM_KEYDOWN;
    procedure WMKillFocus(var Msg : TWmKillFocus);
      message WM_KILLFOCUS;
    function NotAutoRowHeight: Boolean;

  public

    property AbsNodes : Integer read GetAbsNodes;
    property AbsNode[Index : Integer] : TOvcOutlineNode read GetAbsNode;
    property ActiveNode : TOvcOutlineNode read FActiveNode write SetActiveNode;
    procedure BeginUpdate; override;
    property CacheSize: Integer read FCacheSize write SetCacheSize default 4096;
    procedure Clear;
    procedure CollapseAll;
    property CurrentKey : Integer read FCurrentKey write SetCurrentKey;
    procedure EndUpdate; override;
    procedure ExpandAll;
    function FindNode(const Text : string) : TOvcOutlineNode;
    property HideSelection : Boolean read FHideSelection write SetHideSelection;
    property Keys : Integer read FKeys write SetKeys default 1;
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    property Images : TImageList read FImages write SetImages;
    property Nodes: TOvcOutlineNodes read FNodes write SetNodes;
    property Node[Index: Integer]: TOvcOutlineNode read GetNode;
    procedure LoadFromFile(const FileName : string);
    procedure LoadFromStream(Stream : TStream);
    procedure LoadFromText(const FileName : string; Encoding: TEncoding = nil);
    procedure SaveAsText(const FileName : string); overload;
    procedure SaveAsText(const FileName: string; Encoding: TEncoding); overload;
    procedure SaveToFile(const FileName : string);
    procedure SaveToStream(Stream : TStream);
    procedure SetBounds(ALeft, ATop, AWidth, AHeight : Integer);
      override;
    property ShowButtons : Boolean
                   read FShowButtons write SetShowButtons default True;
    property ShowImages : Boolean
                   read FShowImages write SetShowImages default True;
    property ShowLines : Boolean
                   read FShowLines write SetShowLines default True;
    property TextSort: Boolean
                   read FTextSort write SetTextSort default False;

    property OnActiveChange : TOvcOlActiveChangeEvent
                   read FOnActiveChange write FOnActiveChange;
    property OnCollapse : TOvcOlNodeEvent
                   read FOnCollapse write FOnCollapse;
    property OnCompareNodes : TOvcOlCompareNodesEvent
                   read FOnCompareNodes write FOnCompareNodes;
    property OnDrawCheck : TOvcOlDrawCheckEvent
                   read FOnDrawCheck write FOnDrawCheck;
    property OnDrawText : TOvcOlDrawTextEvent
                   read FOnDrawText write FOnDrawText;
    property OnDynamicLoad : TOvcOlNodeEvent
                   read FOnDynamicLoad write FOnDynamicLoad;
    property OnExpand : TOvcOlNodeEvent
                   read FOnExpand write FOnExpand;
    property OnNodeClick : TOvcOlNodeEvent
                   read FOnNodeClick write FOnNodeClick;
    property OnNodeDestroy : TOvcOlNodeEvent
                   read FOnNodeDestroy write FOnNodeDestroy;
  end;

  TOvcOutline = class(TOvcCustomOutline)
  published
    property Anchors;
    property Constraints;
    property DragKind;
    property AfterEnter;
    property AfterExit;
    property Align;
    property AutoRowHeight;
    property BorderStyle;
    property CacheSize;
    property Color;
    property Controller;
    property Ctl3D;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection default False;
    property Images;
    property IntegralHeight;
    property Nodes;
    property Keys;
    property ParentColor default False;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint default False;
    property PopupMenu;
    property RowHeight stored NotAutoRowHeight;
    property ScrollBars;
    property SelectColor;
    property ShowButtons;
    property ShowHint default True;
    property ShowImages;
    property ShowLines;
    property SmoothScroll;
    property TabOrder;
    property TabStop default True;
    property TextSort;
    property Visible;

    property OnActiveChange;
    property OnClick;
    property OnCollapse;
    property OnCompareNodes;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawCheck;
    property OnDrawText;
    property OnDynamicLoad;
    property OnEnter;
    property OnExpand;
    property OnExit;
    property OnNodeClick;
    property OnNodeDestroy;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
  end;



implementation

uses
  Types, WideStrUtils;

var
  BrushBitmap : TBitmap;

{ TOvcOutlineNode }

procedure TOvcOutlineNode.Assign(Source: TPersistent);
var
  SourceNode : TOvcOutlineNode absolute Source;
begin
  if Source is TOvcOutlineNode then begin
    Text := SourceNode.Text;
    Style := SourceNode.Style;
    ImageIndex := SourceNode.ImageIndex;
    Checked := SourceNode.Checked;
    Mode := SourceNode.Mode;
    Expanded := SourceNode.Expanded;
    if SourceNode.HasChildren then
      GetChildren.Assign(SourceNode.GetChildren)
    else
      if HasChildren then
        GetChildren.Free;
  end else
    inherited Assign(Source);
end;

function TOvcOutlineNode.FirstChild: TOvcOutlineNode;
var
  TmpNode : TOvcOutlineNode;
begin
  TmpNode := TOvcOutlineNode.Create(Outline, nil, nil, nil);
  try
    TmpNode.FParent := Self;
    Result := Outline.FNodeIndex.GGEQ(TmpNode);
    if Result <> nil then
      if Result.Parent <> Self then
        Result := nil;
  finally
    TmpNode.Free;
  end;
end;

function TOvcOutlineNode.LastChild: TOvcOutlineNode;
var
  TmpNode : TOvcOutlineNode;
begin
  TmpNode := TOvcOutlineNode.Create(Outline, nil, nil, nil);
  try
    TmpNode.FParent := Self;
    TmpNode.Seq := 1;
    Result := Outline.FNodeIndex.GLEQ(TmpNode);
    if Result <> nil then
      if Result.Parent <> Self then
        Result := nil;
  finally
    TmpNode.Free;
  end;
end;

function TOvcOutlineNode.NextChild: TOvcOutlineNode;
begin
  Result := Outline.FNodeIndex.NextItem;
  if Result <> nil then
    if Result.Parent <> Self then
      Result := nil;
end;

procedure TOvcOutlineNode.PopChildIndex;
begin
  Outline.FNodeIndex.PopIndex;
end;

procedure TOvcOutlineNode.PushChildIndex;
begin
  Outline.FNodeIndex.PushIndex;
end;

procedure TOvcOutlineNode.Collapse(Recurse: Boolean);
var
  Node: TOvcOutlineNode;
begin
  if Recurse then begin
    PushChildIndex;
    Node := FirstChild;
    while Node <> nil do begin
      Node.Collapse(True);
      Node := NextChild;
    end;
    PopChildIndex;
  end;
  Expanded := False;
end;

function TOvcOutlineNode.GetChildren;
begin
  if FFChildren = nil then
   FFChildren := TOvcOutlineNodes.Create(Owner.Owner, Self);
  Result := FFChildren;
end;

constructor TOvcOutlineNode.Create(AOutline: TOvcCustomOutline; AOwner: TOvcOutlineNodes;
  AParent : TOvcOutlineNode; const Data : Pointer);
var
  F : TWinControl;
  {$IFOPT C+}
  x: Integer;
  {$ENDIF}
begin
  inherited Create;
  FOutline := AOutline;
  FOwner := AOwner;
  FParent := AParent;
  FData := Data;
  if AOwner = nil then exit;
  if Outline <> nil then begin
    FAddIndex := Outline.AddIndex;
    inc(Outline.AddIndex);
  end;
  FImageIndex := -1;
  FExpanded := False;
  if (csDesigning in Outline.ComponentState)
  and not (csLoading in Outline.ComponentState) then
    if Outline.Owner <> nil then begin
      F := GetImmediateParentForm(Outline);
      if F <> nil then
        if (F is TCustomForm) then
          TForm(F).Designer.Modified
    end;
  Outline.NodeCache.Clear;
  {$IFOPT C+}
  x := Outline.FAbsNodes.Count;
  {$ENDIF}
  Outline.FAbsNodes.Add(Self);
  Outline.FNodeIndex.Add(Self);
  {$IFOPT C+}
  Assert(Outline.FAbsNodes.Count = x + 1);
  {$ENDIF}
  Assert(FOwner <> nil);
end;

procedure TOvcOutlineNode.DeleteChildren;
begin
  Outline.BeginUpdate;
  FFChildren.Free;
  FFChildren := nil;
  Outline.EndUpdate;
end;

destructor TOvcOutlineNode.Destroy;
{$IFOPT C+}
var
  x: Integer;
{$ENDIF}
begin
  if FOwner = nil then begin
    FFChildren.Free;
    FFChildren := nil;
    inherited Destroy;
    exit;
  end;
  Outline.BeginUpdate;
  try
    if Outline.ActiveNode = Self then
      Outline.ActiveNode := nil;
    FFChildren.Free;
    Outline.UpdateLines;
    {$IFOPT C+}
    x := Outline.FAbsNodes.Count;
    {$ENDIF}
    Outline.FAbsNodes.Delete(Self);
    Outline.FNodeIndex.Delete(Self);
    {$IFOPT C+}
    Assert(Outline.FAbsNodes.Count = x - 1);
    {$ENDIF}
    Outline.DoNodeDestroy(Self);
    inherited Destroy;
    Outline.NodeCache.Clear;
    Outline.UpdateScrollWidth;
  finally
    Outline.EndUpdate;
  end;
end;

procedure TOvcOutlineNode.Expand(Recurse: Boolean);
var
  Node: TOvcOutlineNode;
begin
  if (Parent <> nil) and not Parent.Visible then
    Parent.Expand(False);
  Expanded := True;
  if Recurse then begin
    PushChildIndex;
    Node := FirstChild;
    while Node <> nil do begin
      Node.Expand(True);
      Node := NextChild;
    end;
    PopChildIndex;
  end;
end;

function TOvcOutlineNode.GetCount: Integer;
begin
  if HasChildren then
    Result := FFChildren.Count
  else
    Result := 0;
end;

function TOvcOutlineNode.GetHasChildren: Boolean;
begin
  Outline.FNodeIndex.PushIndex;
  Result := FirstChild <> nil;
  Outline.FNodeIndex.PopIndex;
end;

function TOvcOutlineNode.GetHasParent: Boolean;
begin
  Result := FParent <> nil;
end;

function TOvcOutlineNode.GetNode(Index: Integer): TOvcOutlineNode;
begin
  PushChildIndex;
  Result := FirstChild;
  while Result <> nil do begin
    dec(Index);
    if Index < 0 then
      break;
    Result := NextChild;
  end;
  PopChildIndex;
end;

function TOvcOutlineNode.GetLevel: Integer;
var
  P : TOvcOutlineNode;
begin
  Result := 0;
  P := Parent;
  while P <> nil do begin
    inc(Result);
    P := P.Parent;
  end;
end;

function TOvcOutlineNode.GetLineCount: Integer;
begin
  Result := 1;
  if Expanded and HasChildren then
    inc(Result, FFChildren.LineCount);
end;

function TOvcOutlineNode.IsSibling(Value: TOvcOutlineNode): Boolean;
begin
  Result := Parent = Value.Parent;
end;

function TOvcOutlineNode.IsFirstSibling: Boolean;
begin
  if Parent = nil then begin
    Outline.FAbsNodes.PushIndex;
    Result := Outline.FAbsNodes.FirstItem = Self;
    Outline.FAbsNodes.PopIndex;
  end else begin
    Parent.PushChildIndex;
    Result := Parent.FirstChild = Self;
    Parent.PopChildIndex;
  end;
end;

function TOvcOutlineNode.IsLastSibling: Boolean;
begin
  Assert(Self <> nil);
  Assert(Owner <> nil);
  if Parent = nil then
    Result := Outline.FNodes.LastChild = Self
  else
    Result := Parent.LastChild = Self;
end;

procedure TOvcOutlineNode.SetChecked(Value: Boolean);
var
  Node: TOvcOutlineNode;
begin
  if Value <> FChecked then begin
    FChecked := Value;
    Invalidate;
    if Style = osRadio then begin
      Parent.PushChildIndex;
      if FChecked then begin
        Node := Parent.FirstChild;
        while Node <> nil do begin
          if (Node <> Self)
          and (Node.Style = osRadio) then begin
            Node.FChecked := False;
            Outline.InvalidateItem(Node.Index);
          end;
          Node := Parent.NextChild;
        end;
      end else begin
        Node := Parent.FirstChild;
        while Node <> nil do begin
          if Node.Style = osRadio then begin
            Node.FChecked := False;
            Outline.InvalidateItem(Node.Index);
          end;
          Node := Parent.NextChild;
        end;
      end;
      Parent.PopChildIndex;
    end;
    Outline.DoNodeClick(Self);
  end;
end;

procedure TOvcOutlineNode.SetData(const Value: Pointer);
begin
  FData := Value;
end;

procedure TOvcOutlineNode.MakeChildrenVisible;
var
  GIX, DBX, BX, DTX : Integer;
begin
  GIX := Outline.IndexFromNode(Self);
  if GIX >= 0 then begin
    if Expanded and HasChildren then
      DBX := GIX + FFChildren.Count
    else
      DBX := GIX;
    BX := Outline.TopIndex + Outline.lRows - 1;
    if DBX > BX then begin
      DTX := Outline.TopIndex + (DBX - BX);
      if (DTX > GIX) or (DTX < 0) then
        DTX := GIX;
      Outline.TopIndex := DTX;
    end;
  end;
end;

procedure TOvcOutlineNode.SetExpanded(const Value: Boolean);
begin
  if Value <> FExpanded then begin
    if Value then begin
      if (Mode <> omPreload) and not ExpandEventCalled then begin
        Outline.DoDynamicLoad(Self);
        ExpandEventCalled := True;
      end;
    end else
    if Mode = omDynamic then begin
      DeleteChildren;
      ExpandEventCalled := False;
    end;
    if Parent <> nil then
      Parent.SetExpanded(True);
    FExpanded := Value;
    Outline.NodeCache.Clear;
    Outline.UpdateLines;
    if Outline.lUpdating = 0 then
      MakeChildrenVisible;
    Outline.DoExpandCollapse(Self, Value);
    Outline.UpdateScrollWidth;
  end;
end;

procedure TOvcOutlineNode.SetText(const Value: string);
var
  SaveActive : TOvcOutlineNode;
begin
  if Owner = nil then begin
    FText := Value;
    exit;
  end;
  if Value <> FText then begin
    if Outline.TextSort or (Outline.Keys > 1) then begin
      SaveActive := Outline.ActiveNode;
      Outline.FAbsNodes.Delete(Self);
      Outline.FNodeIndex.Delete(Self);
    end else
      SaveActive := nil;
    FText := Value;
    if Outline.TextSort or (Outline.Keys > 1) then begin
      Outline.FAbsNodes.Add(Self);
      Outline.FNodeIndex.Add(Self);
      Outline.ActiveNode := SaveActive;
    end;
    Outline.NodeCache.Clear;
    if Outline.lUpdating = 0 then
      Outline.Invalidate;
    Outline.UpdateScrollWidth;
  end;
end;

function TOvcOutlineNode.Index: Integer;
begin
  Result := Outline.IndexFromNode(Self);
end;

procedure TOvcOutlineNode.Invalidate;
begin
  if Outline.lUpdating > 0 then exit;
  if Outline.HandleAllocated then
    Outline.InvalidateItem(Index);
end;

procedure TOvcOutlineNode.SetParent(Value : TOvcOutlineNode);
begin
  if Value <> FParent then begin
    Outline.ActiveNode := nil;
    Outline.BeginUpdate;
    try
      Outline.FNodeIndex.Delete(Self);
      if FOwner <> nil then begin
        FOwner := Outline.FNodes;
        FParent := FOwner.FParent;
      end;
      if Value <> nil then begin
        if not (Value is TOvcOutlineNode) then
          raise Exception.Create('Invalid parent node passed to SetParent');
        FParent := Value;
        FOwner := FParent.GetChildren;
      end;
      Outline.FNodeIndex.Add(Self);
      Outline.UpdateLines;
      Outline.NodeCache.Clear;
    finally
      Outline.EndUpdate;
    end;
  end;
end;

procedure TOvcOutlineNode.SetStyle(Value: TOvcOlNodeStyle);
begin
  if Value <> FStyle then begin
    if (Value = osRadio) and (Parent = nil) then
      raise Exception.Create('Only child nodes can have the radio button style');
    FStyle := Value;
    if FStyle <> osPlain then
      FChecked := False;
    Invalidate;
  end;
end;

procedure TOvcOutlineNode.SetImageIndex(const Value: Integer);
begin
  if Value <> FImageIndex then begin
    FImageIndex := Value;
    Invalidate;
  end;
end;

procedure TOvcOutlineNode.SetVisible(const Value: Boolean);
begin
  if not Visible then
    Parent.Expand(False);
end;

function TOvcOutlineNode.GetVisible: Boolean;
begin
  Result := (Parent = nil) or (Parent.Visible and Parent.Expanded);
end;

{ TOvcOutlineNodes }

function TOvcOutlineNodes.Add(const S: string): TOvcOutlineNode;
begin
  Result := TOvcOutlineNode.Create(Owner, Self, FParent, nil);
  Result.Text := S;
  Owner.UpdateLines;
end;

function TOvcOutlineNodes.AddButtonChild(Node: TOvcOutlineNode;
  const S: string; InitStyle: TOvcOlNodeStyle;
  InitChecked: Boolean): TOvcOutlineNode;
begin
  Result := AddChild(Node, S);
  Result.Style := InitStyle;
  Result.Checked := InitChecked;
end;

function TOvcOutlineNodes.AddButtonChildObject(Node: TOvcOutlineNode;
  const S: string; Ptr: Pointer; InitStyle: TOvcOlNodeStyle;
  InitChecked: Boolean): TOvcOutlineNode;
begin
  Result := AddChildObject(Node, S, Ptr);
  Result.Style := InitStyle;
  Result.Checked := InitChecked;
end;

function TOvcOutlineNodes.AddChild(Node: TOvcOutlineNode;
  const S: string): TOvcOutlineNode;
begin
  if Node = nil then
    Result := Add(S)
  else
    Result := Node.GetChildren.Add(s);
end;

function TOvcOutlineNodes.AddChildEx(Node: TOvcOutlineNode;
  const S: string; InitImageIndex: Integer;
  InitMode: TOvcOlNodeMode): TOvcOutlineNode;
begin
  Result := AddChild(Node, S);
  Result.ImageIndex := InitImageIndex;
  Result.Mode := InitMode;
end;

function TOvcOutlineNodes.AddChildObject(Node: TOvcOutlineNode;
  const S: string; Ptr: Pointer): TOvcOutlineNode;
begin
  if Node = nil then
    Result := AddObject(S, Ptr)
  else begin
    Result := Node.GetChildren.AddObject(s, Ptr);
  end;
end;

function TOvcOutlineNodes.AddChildObjectEx(Node: TOvcOutlineNode;
  const S: string; Ptr: Pointer; InitImageIndex: Integer;
  InitMode: TOvcOlNodeMode): TOvcOutlineNode;
begin
  Result := AddChildObject(Node, S, Ptr);
  Result.ImageIndex := InitImageIndex;
  Result.Mode := InitMode;
end;

function TOvcOutlineNodes.AddEx(const S: string; InitImageIndex: Integer;
  InitMode: TOvcOlNodeMode): TOvcOutlineNode;
begin
  Result := Add(S);
  Result.ImageIndex := InitImageIndex;
  Result.Mode := InitMode;
end;

function TOvcOutlineNodes.AddObject(const S: string;
  Ptr: Pointer): TOvcOutlineNode;
begin
  Result := TOvcOutlineNode.Create(Owner, Self, FParent, Ptr);
  Result.Text := S;
  Owner.UpdateLines;
end;

function TOvcOutlineNodes.AddObjectEx(const S: string; Ptr: Pointer;
  InitImageIndex: Integer; InitMode: TOvcOlNodeMode): TOvcOutlineNode;
begin
  Result := AddObject(S, Ptr);
  Result.ImageIndex := InitImageIndex;
  Result.Mode := InitMode;
end;

procedure TOvcOutlineNodes.Assign(Source: TPersistent);
var
  SourceNodes : TOvcOutlineNodes absolute Source;
  Node: TOvcOutlineNode;
begin
  if Source is TOvcOutlineNodes then begin
    Clear;
    if SourceNodes.FParent <> nil then begin
      SourceNodes.FParent.PushChildIndex;
      Node := SourceNodes.FParent.FirstChild;
      while Node <> nil do begin
        TOvcOutlineNode.Create(Owner, Self, FParent, Node.Data).Assign(Node);
        Node := SourceNodes.FParent.NextChild;
      end;
      SourceNodes.FParent.PopChildIndex;
    end else begin
      SourceNodes.Owner.PushChildIndex;
      Node := SourceNodes.Owner.FirstChild;
      while Node <> nil do begin
        TOvcOutlineNode.Create(Owner, Self, FParent, Node.Data).Assign(Node);
        Node := SourceNodes.Owner.NextChild;
      end;
      SourceNodes.Owner.PopChildIndex;
    end;

    Owner.UpdateLines;
  end else
    inherited Assign(Source);
end;

procedure TOvcOutlineNodes.Clear;
var
  N: TOvcOutlineNode;
begin
  if FParent = nil then begin
    N := FOwner.FAbsNodes.FirstItem;
    while N <> nil do begin
      N.Free;
      N := FOwner.FAbsNodes.FirstItem;
    end;
  end else begin
    N := FParent.LastChild;
    while N <> nil do begin
      N.Free;
      N := FParent.LastChild;
    end;
  end;
end;

constructor TOvcOutlineNodes.Create(AOwner: TOvcCustomOutline;
  AParent : TOvcOutlineNode);
begin
  inherited Create;
  FOwner := AOwner;
  FParent := AParent;
end;

procedure TOvcOutlineNodes.DefineProperties(Filer: TFiler);
begin
  Filer.DefineBinaryProperty('Data', FOwner.LoadFromStream, FOwner.SaveToStream,
    FirstChild <> nil);
end;

destructor TOvcOutlineNodes.Destroy;
begin
  if not FOwner.Clearing then
    Clear;
  inherited Destroy;
end;

function TOvcOutlineNodes.FirstChild: TOvcOutlineNode;
begin
  if FParent <> nil then
    Result := FParent.FirstChild
  else begin
    Assert(FOwner <> nil);
    Result := FOwner.FirstChild;
  end;
end;

function TOvcOutlineNodes.NextChild: TOvcOutlineNode;
begin
  if FParent <> nil then
    Result := FParent.NextChild
  else begin
    Assert(FOwner <> nil);
    Result := FOwner.NextChild;
  end;
end;

{ new}
function TOvcOutlineNodes.LastChild: TOvcOutlineNode;
begin
  if FParent <> nil then
    Result := FParent.LastChild
  else begin
    Assert(FOwner <> nil);
    Result := FOwner.LastChild;
  end;
end;

procedure TOvcOutlineNodes.PopChildIndex;
begin
  Assert(FOwner <> nil);
  FOwner.PopChildIndex;
end;

procedure TOvcOutlineNodes.PushChildIndex;
begin
  Assert(FOwner <> nil);
  FOwner.PushChildIndex;
end;

function TOvcOutlineNodes.GetCount: Integer;
begin
  Result := 0;
  PushChildIndex;
  if FirstChild <> nil then
    repeat
      inc(Result);
    until NextChild = nil;
  PopChildIndex;
end;

function TOvcOutlineNodes.GetLineCount: Integer;
var
  Node: TOvcOutlineNode;
begin
  Result := 0;
  PushChildIndex;
  Node := FirstChild;
  while Node <> nil do begin
    inc(Result, Node.LineCount);
    Node := NextChild;
  end;
  PopChildIndex;
end;

function TOvcOutlineNodes.GetNode(
  Index: Integer): TOvcOutlineNode;
begin
  PushChildIndex;
  Result := FirstChild;
  repeat
    dec(Index);
    if Index < 0 then
      break;
    Result := NextChild;
  until Result = nil;
  if Result = nil then
    raise Exception.Create('Invalid node index');
  PopChildIndex;
end;

{ TOvcCustomOutline }

procedure TOvcCustomOutline.BeginUpdate;
begin
  inherited BeginUpdate;
end;

procedure TOvcCustomOutline.DoActiveChange(OldNode,
  NewNode: TOvcOutlineNode);
begin
  if not FDelayNotify
  and assigned(FOnActiveChange) then
    FOnActiveChange(Self, OldNode, NewNode);
  FActiveNode := NewNode;
end;

function TOvcCustomOutline.DoOnIsSelected(Index: Integer): Boolean;
begin
  if csDesigning in ComponentState then
    Result := False
  else
    Result := (Focused or not HideSelection) and (Index = FItemIndex);
end;

procedure TOvcCustomOutline.SimulatedClick;
begin
  IsSimulated := True;
  inherited SimulatedClick;
  IsSimulated := False;
end;

function TOvcCustomOutline.PointToIndex(Y : Integer) : Integer;
begin
  Result := -1;
  if (Y >= 0) and (Y < ClientHeight) then begin
    {convert to an index}
    Result := TopIndex+(Y div RowHeight);
    if ClientHeight mod RowHeight > 0 then
      if Result > TopIndex-1+lRows then
        Result := TopIndex-1+lRows;
  end;
end;

procedure TOvcCustomOutline.Click;
var
  Index : Integer;
  Pt    : TPoint;
begin
  if not IsSimulated then
    if (NumItems <> 0) then begin
      GetCursorPos(Pt);
      Pt := ScreenToClient(Pt);
      Index := PointToIndex(Pt.Y);
      if IsValidIndex(Index) then
        if IsGroup[Index] and PtInRect(Node[Index].ButtonRect, Pt) then begin
          Node[Index].Expanded :=
            not Node[Index].Expanded;
          exit;
        end else
        case Node[Index].Style of
        osPlain :;
        osRadio :
          with Node[Index] do
            if PtInRect(RadioRect, Pt) then begin
              Checked := True;
              exit;
            end;
        osCheck :
          with Node[Index] do
            if PtInRect(RadioRect, Pt) then begin
              Checked := not Checked;
              exit;
            end;
        end;
    end;
  inherited Click;
end;

procedure TOvcCustomOutline.Clear;
var
  Node: TOvcOutlineNode;
  NotifyDestroy: Boolean;
begin
  BeginUpdate;
  try
    Clearing := True;
    NotifyDestroy := assigned(FOnNodeDestroy);
    Node := FAbsNodes.FirstItem;
    while Node <> nil do begin
      Node.FOwner := nil; //prevent the node from messing with global lists
      if NotifyDestroy then
        FOnNodeDestroy(Self, Node);
      Node.Free;
      Node := FAbsNodes.NextItem;
    end;
    FAbsNodes.Clear;
    FNodeIndex.Clear;
    if HandleAllocated then
      NumItems := 0;
  finally
    Clearing := False;
    EndUpdate;
  end;
end;

procedure TOvcCustomOutline.CollapseAll;
var
  Node: TOvcOutlineNode;
begin
  BeginUpdate;
  try
    PushChildIndex;
    Node := FirstChild;
    if Node <> nil then
      repeat
        Node.Collapse(True);
        Node := NextChild;
      until Node = nil;
    PopChildIndex;
    TopIndex := 0;
  finally
    EndUpdate;
  end;
end;

function PComp(P1, P2: Pointer): Integer; register;
asm
  sub eax, edx
end;

function IComp(P1, P2: Integer): Integer; register;
asm
  sub eax, edx
end;

function TOvcCustomOutline.CompareNodesGlobal(Key: Integer; I1,
  I2: Pointer): Integer;
begin
  Result := 0;

  if I1 = I2 then
    exit;

  Assert(TObject(I1) is TOvcOutlineNode);
  Assert(TObject(I2) is TOvcOutlineNode);

  if Key = 0 then
    if TextSort then
      Result := AnsiCompareText(TOvcOutlineNode(I1).Text, TOvcOutlineNode(I2).Text)
    else
      Result := IComp(TOvcOutlineNode(I1).AddIndex, TOvcOutlineNode(I2).AddIndex)
  else
    FOnCompareNodes(Self, Key, I1, I2, Result);

end;

function TOvcCustomOutline.CompareNodesLocal(Key: Integer; I1,
  I2: Pointer): Integer;
begin
  Result := 0;

  if I1 = I2 then
    exit;

  Assert(TObject(I1) is TOvcOutlineNode);
  Assert(TObject(I2) is TOvcOutlineNode);

  Result := PComp(TOvcOutlineNode(I1).Parent, TOvcOutlineNode(I2).Parent); //SZ FIXME (when using 4GB Flag)

  if Result = 0 then begin

    Result := IComp(TOvcOutlineNode(I1).Seq, TOvcOutlineNode(I2).Seq);

    if Result = 0 then
      if Key = 0 then
        if TextSort then
          Result := AnsiCompareText(TOvcOutlineNode(I1).Text, TOvcOutlineNode(I2).Text)
        else
          Result := IComp(TOvcOutlineNode(I1).AddIndex, TOvcOutlineNode(I2).AddIndex)
      else
        FOnCompareNodes(Self, Key, I1, I2, Result);
  end;

end;

{ new}
function TOvcCustomOutline.NotAutoRowHeight: Boolean;
begin
  Result := not AutoRowHeight;
end;

constructor TOvcCustomOutline.Create(AOwner : TComponent);
{Create report view component}
begin
  inherited Create(AOwner);
  {FHoverTimer := -1;}
  FKeys := 1;
  lVMargin := 3;
  ControlStyle := ControlStyle + [csOpaque];
  Width := 100;
  Height := 100;
  AutoRowHeight := True;
  NumItems := 0;
  FShowButtons := True;
  FShowImages := True;
  FShowLines := True;
  FNodes := TOvcOutlineNodes.Create(Self, nil);
  {HintWindow := HintWindowClass.Create(Self);}
  {HintWindow.Color := Application.HintColor; }
  FCacheSize := 4096;
  NodeCache := TOvcLiteCache.Create(sizeof(Integer), 4096);
  FAbsNodes := TOvcOutlineNodeList.Create(Keys, CompareNodesGlobal);
  FAbsNodes.CurrentKey := CurrentKey;
  FNodeIndex := TOvcOutlineNodeList.Create(Keys, CompareNodesLocal);
  FNodeIndex.CurrentKey := CurrentKey;
  ShowHint := True;
end;

destructor TOvcCustomOutline.Destroy;
{Destroy report view component}
begin
  Clear;
  FOnActiveChange := nil;
  {HintShownHere := True;}
  {if FHoverTimer <> -1 then begin}
    {if FController <> nil then }
      {FController.TimerPool.Remove(FHoverTimer);}
    {FHoverTimer := -1;}
  {end;}
  {HintWindow.Free;}
  FNodes.Free;
  LineCanvas.Free;
  NodeCache.Free;
  FAbsNodes.Free;
  FNodeIndex.Free;
  inherited Destroy;
end;

procedure TOvcCustomOutline.DblClick;
begin
  if ActiveNode <> nil then
    ActiveNode.Expanded := not ActiveNode.Expanded;
  inherited DblClick;
end;

procedure TOvcCustomOutline.DoOnSelect(Index: Integer; Selected: Boolean);
var
  NewActive : TOvcOutlineNode;
begin
  inherited DoOnSelect(Index, Selected);
  if (Index <> -1) and Selected then
    NewActive := Node[Index]
  else
    NewActive := nil;
  if NewActive <> FActiveNode then
    DoActiveChange(FActiveNode, NewActive);
end;

function TOvcCustomOutline.DoDrawCheck(Canvas : TCanvas; Node: TOvcOutlineNode;
   Rect : TRect; Style : TOvcOlNodeStyle; Checked : Boolean) : Boolean;
var
  DefaultDrawing : boolean;
begin
  DefaultDrawing := True;
  if Assigned(FOnDrawCheck) then
    FOnDrawCheck(Self, Canvas, Node, Rect, Style, Checked, DefaultDrawing);
  Result := not DefaultDrawing;
end;

function TOvcCustomOutline.DoDrawText(Canvas: TCanvas;
  Node: TOvcOutlineNode; const Text: string; Rect: TRect): Boolean;
var
  DefaultDrawing : boolean;
begin
  DefaultDrawing := True;
  if Assigned(FOnDrawText) then
    FOnDrawText(Self, Canvas, Node, Text, Rect, DefaultDrawing);
  Result := not DefaultDrawing;
end;

procedure TOvcCustomOutline.DoDynamicLoad(Node: TOvcOutlineNode);
begin
  if assigned(FOnDynamicLoad) then
    FOnDynamicLoad(Self, Node);
end;

procedure TOvcCustomOutline.DoExpandCollapse(Node : TOvcOutlineNode; Expanding : Boolean);
begin
  if Expanding then
    if assigned(FOnExpand) then
      FOnExpand(Self, Node)
    else
  else
    if assigned(FOnCollapse) then
      FOnCollapse(Self, Node);
end;

procedure TOvcCustomOutline.DoNodeClick(Node: TOvcOutlineNode);
begin
  if assigned(FOnNodeClick) then
    FOnNodeClick(Self, Node);
end;

procedure TOvcCustomOutline.DoNodeDestroy(Node: TOvcOutlineNode);
begin
  if assigned(FOnNodeDestroy) then
    FOnNodeDestroy(Self, Node);
end;

procedure TOvcCustomOutline.EndUpdate;
begin
  inherited EndUpdate;
  if lUpdating = 0 then begin
    UpdateLines;
    if UpdateScrollWidthPending then
      UpdateScrollWidth;
  end;
end;

procedure TOvcCustomOutline.ExpandAll;
var
  Node: TOvcOutlineNode;
begin
  BeginUpdate;
  try
    PushChildIndex;
    Node := FirstChild;
    if Node <> nil then
      repeat
        Node.Expand(True);
        Node := NextChild;
      until Node = nil;
    PopChildIndex;
  finally
    EndUpdate;
  end;
end;

function TOvcCustomOutline.GetNode(Index: Integer): TOvcOutlineNode;
var
  c : Integer;

  procedure LocateNode(Nodes : TOvcOutlineNodes);
  var
    Node: TOvcOutlineNode;
  begin
    if c > Index then exit;
    Nodes.PushChildIndex;
    Node := Nodes.FirstChild;
    if Node <> nil then
      repeat
        inc(c);
        if c = Index then begin
          Result := Node;
          break;
        end;
        if Node.Expanded and Node.HasChildren then
          LocateNode(Node.GetChildren);
        if c > Index then
          break;
        Node := Nodes.NextChild;
      until Node = nil;
    Nodes.PopChildIndex;
  end;

begin
  if not NodeCache.GetValue(Pointer(Index), Result) then begin
    c := -1;
    Result := nil;
    LocateNode(Nodes);
    NodeCache.AddValue(Pointer(Index), Result);
  end;
end;

function TOvcCustomOutline.GetAbsNodes : Integer;
begin
  Result := FAbsNodes.Count;
end;

function TOvcCustomOutline.GetAbsNode(Index : Integer): TOvcOutlineNode;
begin
  Result := FAbsNodes.Node[Index];
end;

(* !!.02
procedure TOvcCustomOutline.HideHint;
begin
  if (HintWindow <> nil) and HintWindow.HandleAllocated and
    IsWindowVisible(HintWindow.Handle) then begin
      ShowWindow(HintWindow.Handle, SW_HIDE);
      Update;
    end;
end;
*)

function TOvcCustomOutline.IndexFromNode(CurNode : TOvcOutlineNode) : Integer;
var
  c : Integer;

  procedure LocateNode(Nodes : TOvcOutlineNodes);
  var
    Node: TOvcOutlineNode;
  begin
    PushChildIndex;
    Node := Nodes.FirstChild;
    if Node <> nil then
      repeat
        inc(c);
        if Node = CurNode then begin
          Result := c;
          break;
        end;
        if Node.Expanded and Node.HasChildren then
          LocateNode(Node.GetChildren);
        Node := Nodes.NextChild;
      until Node = nil;
    PopChildIndex;
  end;

begin
  c := -1;
  Result := -1;
  LocateNode(Nodes);
end;

procedure TOvcCustomOutline.KeyPress(var Key: Char);
var
  SaveIdx : Integer;
begin
  case Key of
  ' ','+','-',#13 :
    if ItemIndex <> -1 then begin
      if IsGroup[ItemIndex] then begin
        SaveIdx := ItemIndex;
        case Key of
        ' ',#13 :
          Node[ItemIndex].Expanded :=
            not Node[ItemIndex].Expanded;
        '+' :
          Node[ItemIndex].Expanded := True;
        '-' :
          Node[ItemIndex].Expanded := False;
        end;
        Key := #0;
        ItemIndex := SaveIdx;
      end else
        if (Key = ' ') then
          case Node[ItemIndex].Style of
          osRadio :
            begin
              Node[ItemIndex].Checked := True;
              Key := #0;
            end;
          osCheck :
            begin
              with Node[ItemIndex] do
                Checked := not Checked;
              Key := #0;
            end;
          end;
    end;
  end;
  inherited KeyPress(Key);
end;

procedure TOvcCustomOutline.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
end;

procedure TOvcCustomOutline.LoadFromText(const FileName: string; Encoding: TEncoding = nil);
var
  S : TStreamReader;
  Ln : String;
  CurLevel : Integer;

  procedure NextLine;
  begin
    CurLevel := 0;
    Ln := '';
    if not S.EndOfStream then
    begin
      Ln := S.ReadLine;
      while Copy(Ln, 1, 1) = #9 do
      begin
        Delete(Ln, 1, 1);
        Inc(CurLevel);
      end;
    end;
  end;

  procedure LoadLevel(Parent : TOvcOutlineNode; S : TStreamReader; Level : Integer);
  var
    NewNode : TOvcOutlineNode;
  begin
    NewNode := nil;
    repeat
      if Ln = '' then
        NextLine;
      if Ln = '' then
        exit;
      if CurLevel < Level then
        exit
      else if CurLevel > Level then begin
        LoadLevel(NewNode, S, Level + 1);
        if (CurLevel < Level) then
          exit;
      end else begin
        NewNode := Nodes.AddChild(Parent, Ln);
        Ln := '';
      end;
    until false;
  end;

begin
  if Encoding = nil then
    Encoding := TEncoding.UTF8;
  S := TStreamReader.Create(FileName, Encoding, True);
  try
    Clear;
    BeginUpdate;
    try
      LoadLevel(nil, S, 0);
    finally
      EndUpdate;
    end;
  finally
    S.Free;
  end;
end;

{ new}
function TOvcCustomOutline.CalcMaxWidth: Integer;
{paint listbox's entire invalid area}
var
  I    : Integer;

  function CalcItemWidth(N : Integer; Row : Integer): Integer;
    {-Draw item N at Row}
  var
    CurNode : TOvcOutlineNode;
  begin
    Result := 0;
    if N = -1 then exit;
    CurNode := Node[N];
    if CurNode = nil then
      exit;

    if ShowLines then
      inc(Result, CurNode.Level * ChildIndent);

    inc(Result, 2);

    if ShowButtons or ShowLines then
      inc(Result, ChildIndent);

    case CurNode.Style of
    osPlain : ;
    osRadio,
    osCheck :
      inc(Result, ChildIndent);
    end;

    if ShowImages
    and (Images <> nil)
    and (CurNode.ImageIndex <> -1) then
      inc(Result, Images.Width + 2);

    inc(Result, Canvas.TextWidth(CurNode.Text));
  end;

begin
  Canvas.Font := Font;

  Result := 0;

  for I := 1 to MinI(lRows, NumItems) do
    Result := MaxI(Result, CalcItemWidth(FTopIndex+Pred(I), I));

end;

procedure TOvcCustomOutline.Paint;
{paint listbox's entire invalid area}
var
  I    : Integer;
  CR   : TRect;
  IR   : TRect;
  Clip : TRect;
  Last : Integer;

  procedure InternalDrawItem(N : Integer; Row : Integer);
    {-Draw item N at Row}
  var
    FGColor : TColor;
    BGColor : TColor;
    i, CRWidth, CRHeight, L : Integer;
    BR, R, R2   : TRect;
    BlitR: TRect;
    S : string;
    P : PChar;
    CurNode, It : TOvcOutlineNode;
    BD    : Integer;
  begin
    if N = -1 then exit;
    CurNode := Node[N];
    if CurNode = nil then
      exit;
    {get bounding rectangle}
    CR.Top := Pred(Row)*FRowHeight;
    CR.Bottom := CR.Top+FRowHeight;
    {do we have anything to paint}
    if Bool(IntersectRect(IR, Clip, CR)) then begin

      if (ScrollBars in [ssHorizontal, ssBoth]) then
        CRWidth := MaxI(Columns + ClientWidth, CR.Right - CR.Left + 1)
      else
        CRWidth := CR.Right - CR.Left + 1;
      CRHeight := CR.Bottom - CR.Top + 1;

      if (LineCanvas <> nil) and ((LineCanvas.Width <> CRWidth)
      or (LineCanvas.Height <> CRHeight)) then begin
        LineCanvas.Free;
        LineCanvas := nil;
      end;
      if LineCanvas = nil then begin
        LineCanvas            := TBitMap.Create;
        LineCanvas.Width      := CRWidth;
        LineCanvas.Height     := CRHeight;
        LineCanvas.Canvas.Font := Self.Font;
        {we will erase our own background}
        SetBkMode(LineCanvas.Canvas.Handle, TRANSPARENT);
      end;

      {actual drawing}
      LineCanvas.Canvas.Brush.Color := Color;
      LineCanvas.Canvas.Font.Color := Font.Color;

      R := CR;
      if (ScrollBars in [ssHorizontal, ssBoth]) then
        R.Right := R.Left + CRWidth - 1;

      R.Top := 0;
      {R.Bottom := R.Top + (CR.Bottom - CR.Top);}
      R.Bottom := FRowHeight; {same thing}

      LineCanvas.Canvas.FillRect(R);

      BlitR := R;

      {get colors}
      if DoOnIsSelected(N) and (Row <= lRows) then begin
        BGColor := FSelectColor.BackColor;
        FGColor := FSelectColor.TextColor;
      end else begin
        BGColor := Color;
        FGColor := Font.Color;
        DoOnGetItemColor(N, FGColor, BGColor);
      end;

      {assign colors to our canvas}
      LineCanvas.Canvas.Brush.Color := BGColor;
      LineCanvas.Canvas.Font.Color := FGColor;

      BD := (R.Bottom - R.Top - 4) div 2;

      if ShowLines then begin
        LineCanvas.Canvas.Brush.Bitmap := BrushBitmap;
        It := CurNode;
        for i := CurNode.Level - 1 downto 0 do begin
          It := It.Parent;
          R.Left := i * ChildIndent;
          {BR.Left := R.Left + 2;}
          {BR.Right := BR.Left + BD;}
          if not It.IsLastSibling then
            PatBlt(LineCanvas.Canvas.Handle, R.Left + 2 + BD - 1, 0, 1,
              R.Bottom, PATCOPY);
        end;
      end;

      R.Left := CurNode.Level * ChildIndent;

      BR.Left := R.Left + 2;
      BR.Top := R.Top + 2;
      BR.Bottom := R.Bottom - 2;
      BD := (BR.Bottom - BR.Top);
      BR.Right := BR.Left + BD;
      BD := BD div 2;

      if ShowLines then begin
        if CurNode.IsLastSibling then
          if N <> 0 then
            PatBlt(LineCanvas.Canvas.Handle, R.Left + 2 + BD - 1, 0, 1,
              R.Bottom div 2, PATCOPY)
          else
        else
          if N = 0 then
            PatBlt(LineCanvas.Canvas.Handle, R.Left + 2 + BD - 1,
              R.Bottom div 2, 1, R.Bottom div 2, PATCOPY)
          else
            PatBlt(LineCanvas.Canvas.Handle, R.Left + 2 + BD - 1, 0, 1,
              R.Bottom, PATCOPY);
        PatBlt(LineCanvas.Canvas.Handle, R.Left + 2 + BD - 1,
          R.Bottom div 2 - 1, 2 * ChildIndent div 3, 1, PATCOPY);
      end;

      CurNode.ButtonRect := Rect(0, 0, 0, 0);

      LineCanvas.Canvas.Brush.Bitmap := nil; //SZ clear brush bitmap, otherwise paint problem when OvcOutLine1.Color = clWhite (brush image fills entire rectangle)

      if ShowButtons and (CurNode.HasChildren or ((CurNode.Mode <> omPreload)
        and not CurNode.ExpandEventCalled)) then begin
        {draw button}
        LineCanvas.Canvas.Pen.Color := clBtnFace;
        LineCanvas.Canvas.Brush.Color := Color;
        LineCanvas.Canvas.Rectangle(
          BR.Left + BD - 5,
          BR.Top + BD - 5,
          BR.Left + BD + 4,
          BR.Top + BD + 4);
        CurNode.ButtonRect := Rect(
          BR.Left + BD - 5,
          CR.Top + BR.Top + BD - 5,
          BR.Left + BD + 4,
          CR.Top + BR.Top + BD + 4);
        LineCanvas.Canvas.Pen.Color := clBtnText;
        LineCanvas.Canvas.MoveTo(BR.Left + BD - 3,BR.Top + BD - 1);
        LineCanvas.Canvas.LineTo(BR.Left + BD + 2,BR.Top + BD - 1);
        if not CurNode.Expanded then begin
          LineCanvas.Canvas.MoveTo(BR.Left + BD - 1,BR.Top + BD - 3);
          LineCanvas.Canvas.LineTo(BR.Left + BD - 1,BR.Top + BD + 2);
        end;
        if lhDelta <> 0 then begin
          R2 := CurNode.ButtonRect;
          OffsetRect(R2, -lhDelta, 0);
          CurNode.ButtonRect := R2;
        end;
      end;

      if ShowButtons or ShowLines then
        {inc(R.Left, 5 * ChildIndent div 4);}
        inc(R.Left, ChildIndent);

      case CurNode.Style of
      osPlain : ;
      osRadio :
        begin
          CurNode.RadioRect :=
            Rect(
              R.Left + BD - 5,
              CR.Top + R.Top + BD - 5,
              R.Left + BD + 7,
              CR.Top + R.Top + BD + 7
            );
          if not DoDrawCheck(LineCanvas.Canvas, CurNode, CurNode.RadioRect, CurNode.Style, CurNode.Checked) then begin
            LineCanvas.Canvas.Brush.Color := Color;
            LineCanvas.Canvas.Ellipse(
              R.Left + BD - 5,
              R.Top + BD - 5,
              R.Left + BD + 7,
              R.Top + BD + 7);
            if CurNode.Checked then
              LineCanvas.Canvas.Brush.Color := clBlack;
            LineCanvas.Canvas.Ellipse(
              R.Left + BD - 3,
              R.Top + BD - 3,
              R.Left + BD + 5,
              R.Top + BD + 5);
          end;
          inc(R.Left, ChildIndent);
        end;
      osCheck :
        begin
          CurNode.RadioRect :=
            Rect(
              R.Left + BD - 5,
              CR.Top + R.Top + BD - 5,
              R.Left + BD + 7,
              CR.Top + R.Top + BD + 7
            );
          if not DoDrawCheck(LineCanvas.Canvas, CurNode, CurNode.RadioRect, CurNode.Style, CurNode.Checked) then begin
            LineCanvas.Canvas.Brush.Color := Color;
            LineCanvas.Canvas.Rectangle(
              R.Left + BD - 5,
              R.Top + BD - 5,
              R.Left + BD + 7,
              R.Top + BD + 7);
            if CurNode.Checked then begin
              LineCanvas.Canvas.MoveTo(R.Left + BD - 5, R.Top + BD - 5);
              LineCanvas.Canvas.LineTo(R.Left + BD + 7, R.Top + BD + 7);
              LineCanvas.Canvas.MoveTo(R.Left + BD + 6, R.Top + BD - 5);
              LineCanvas.Canvas.LineTo(R.Left + BD - 6, R.Top + BD + 7);
            end;
          end;
          inc(R.Left, ChildIndent);
        end;
      end;

      if ShowImages
      and (Images <> nil)
      and (CurNode.ImageIndex <> -1) then begin
        Images.Draw(LineCanvas.Canvas, R.Left,
          (R.Bottom - Images.Height) div 2, CurNode.ImageIndex);
        {inc(R.Left, 5 * Images.Width div 4);}
        inc(R.Left, Images.Width + 2);
      end;

      if (CurNode.Text <> '') then
        S := GetDisplayString(Canvas,{' ' + }CurNode.Text + ' ',1,CR.Right - R.Left + lhDelta)
      else
        S := '  ';
      CurNode.Truncated := S <> {' ' + }CurNode.Text + ' ';
      LineCanvas.Canvas.Brush.Color := BGColor;
      LineCanvas.Canvas.Font.Assign(Font);
      LineCanvas.Canvas.Font.Color := FGColor;
      if not DoDrawText(LineCanvas.Canvas, CurNode, S, R) then begin
        P := pChar(S);
        L := length(S);
        DrawText(LineCanvas.Canvas.Handle, P, L, R,
          DT_LEFT or DT_BOTTOM or DT_SINGLELINE or DT_NOPREFIX);
        if N = lFocusedIndex then begin
          R2 := R;
          DrawText(LineCanvas.Canvas.Handle, P, L, R2,
            DT_LEFT or DT_BOTTOM or DT_SINGLELINE or DT_NOPREFIX or DT_CALCRECT);
          inc(R2.Top, 2);
          vlbDrawFocusRect(LineCanvas.Canvas, R2);
        end;
      end;
      {end of actual drawing}

      Canvas.CopyMode := cmSrcCopy;
      OffsetRect(BlitR, lhDelta, 0);
      BlitR.Right := BlitR.Left + (CR.Right - CR.Left);
      Canvas.CopyRect(CR, LineCanvas.Canvas, BlitR);
      OffsetRect(R, -lhDelta, CR.Top);
      CurNode.TextRect := R;
    end;
  end;

  procedure DrawEmptyFocus;
  begin
    if Focused then begin
      CR.Top := 0;
      CR.Bottom := FRowHeight;
      Canvas.DrawFocusRect(CR);
    end;
  end;

begin
  if lUpdating > 0 then
    Exit;

  {HideHint;}

  Canvas.Font := Font;

  {we will erase our own background}
  SetBkMode(Canvas.Handle, TRANSPARENT);

  {get the client rectangle}
  CR := ClientRect;

  {get the clipping region}
  GetClipBox(Canvas.Handle, Clip);

  {calculate last visible item}
  Last := lRows;
  if Last > NumItems then
    Last := NumItems;

  {display each row}
  for I := 1 to Last do
    InternalDrawItem(FTopIndex+Pred(I), I);

  {paint any blank area below last item}
  CR.Top := FRowHeight * (Last);
  if CR.Top < ClientHeight then begin
    CR.Bottom := ClientHeight;
    {clear the area}
    Canvas.Brush.Color := Color;
    Canvas.FillRect(CR);
  end;

  if (NumItems = 0) then
    DrawEmptyFocus;

end;

procedure TOvcCustomOutline.SaveAsText(const FileName: string);

  procedure WriteNode(S : TStream; Level : Integer; ParentNode : TOvcOutlineNode);
  const
    Tab: AnsiChar = #9;
    CrLf: array[0..1] of AnsiChar = #13#10;
  var
    i : Integer;
    Node: TOvcOutlineNode;
  begin
    for i := 0 to Level - 1 do
      S.Write(Tab, 1);
    S.Write(PAnsiChar(AnsiString(ParentNode.Text))^, length(ParentNode.Text));
    S.Write(CrLf, 2);
    if ParentNode.HasChildren then begin
      ParentNode.PushChildIndex;
      Node := ParentNode.FirstChild;
      if Node <> nil then
        repeat
          WriteNode(S, Level + 1, Node);
          Node := ParentNode.NextChild;
        until Node = nil;
      ParentNode.PopChildIndex;
    end;
  end;

var
  S : TStream;
  Node: TOvcOutlineNode;
begin
  S := TFileStream.Create(FileName, fmCreate);
  try
    PushChildIndex;
    Node := FirstChild;
    if Node <> nil then
      repeat
        WriteNode(S, 0, Node);
        Node := NextChild;
      until Node = nil;
    PopChildIndex;
  finally
    S.Free;
  end;
end;

procedure TOvcCustomOutline.SetShowLines(const Value: Boolean);
begin
  if Value <> FShowLines then begin
    FShowLines := Value;
    Invalidate;
  end;
end;

procedure TOvcCustomOutline.SetShowButtons(const Value: Boolean);
begin
  if Value <> FShowButtons then begin
    FShowButtons := Value;
    Invalidate;
  end;
end;

procedure TOvcCustomOutline.SetHideSelection(const Value : Boolean);
begin
  if Value <> FHideSelection then begin
    FHideSelection := Value;
    Invalidate;
  end;
end;

procedure TOvcCustomOutline.SetImages(const Value: TImageList);
begin
  if Value <> FImages then begin
    FImages := Value;
    Invalidate;
  end;
end;

function TOvcCustomOutline.FindNode(const Text : string) : TOvcOutlineNode;
var
  TmpNode : TOvcOutlineNode;
  SaveKey : Integer;
begin
  TmpNode := TOvcOutlineNode.Create(Self, nil, nil, nil);
  SaveKey := CurrentKey;
  try
    TmpNode.Text := Text;
    CurrentKey := 0;
    Result := FAbsNodes.GGEQ(TmpNode);
  finally
    TmpNode.Free;
    CurrentKey := SaveKey;
  end;
end;

function TOvcCustomOutline.GetIsGroup(Index: Integer): Boolean;
begin
  if IsValidIndex(Index) then
    with Node[Index] do
      Result := HasChildren or ((Mode <> omPreload) and not ExpandEventCalled)
  else
    Result := False;
end;

(* !!.02 no longer used
procedure TOvcCustomOutline.HoverTimerEvent(Sender : TObject; Handle : Integer;
                         Interval : Cardinal; ElapsedTime : Integer);
{display/hide hint with truncated text}
var
  S : string;
  Tw, Th, Index : Integer;
  Sc : TPoint;
begin
  if HintShownHere
  or not HandleAllocated
  or not HasParent
  or not Parent.Visible
  or (lUpdating > 0)
  or (csDestroying in ComponentState) then exit;
  if (FController.TimerPool.ElapsedTime[FHoverTimer] > 100) then begin
    if not IsWindowVisible(HintWindow.Handle) then begin
      Index := PointToIndex(HintY);
      if (Index <> -1)
      and IsValidIndex(Index)
      and (Node[Index].Truncated)
      and (PtInRect(Node[Index].TextRect, Point(HintX, HintY))) then begin
        S := Node[Index].Text;
        Tw := HintWindow.Canvas.TextWidth(S);
        Th := HintWindow.Canvas.TextHeight(S);
        Sc := ClientToScreen(Point(HintX,HintY));
        HintWindow.ActivateHint(Rect(Sc.X - Tw div 2 - 4, Sc.Y - Th - 10,
          Sc.X + Tw div 2 + 4, Sc.Y - 8), S);
      end;
    end;
    if (ElapsedTime > 3000) and IsWindowVisible(HintWindow.Handle) then begin
      HideHint;
      HintShownHere := True;
    end;
  end;
end;
*)

function TOvcCustomOutline.Lines: Integer;
begin
  Result := Nodes.LineCount;
end;

procedure TOvcCustomOutline.SetNodes(const Value: TOvcOutlineNodes);
begin
  FNodes.Assign(Value);
end;

procedure TOvcCustomOutline.UpdateLines;
begin
  if csDestroying in ComponentState then
    exit;
  if lUpdating > 0 then
    exit;
  NumItems := Lines;
  Invalidate;
  UpdateActiveNode;
end;

(* !!.02
procedure TOvcCustomOutline.Loaded;
begin
  inherited Loaded;
  FHoverTimer := Controller.TimerPool.Add(HoverTimerEvent, 250);
  HintShownHere := True;
end;
*)

procedure TOvcCustomOutline.LoadFromFile(const FileName: string);
var
  S : TFileStream;
begin
  S := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    LoadFromStream(S);
  finally
    S.Free;
  end;
end;

procedure TOvcCustomOutline.LoadFromStream(Stream: TStream);

  procedure LoadLevel(Stream : TStream; Parent : TOvcOutlineNode); forward;

  procedure ReadNode(Stream : TStream; Parent : TOvcOutlineNode);
  var
    I : Integer;
    NewNode : TOvcOutlineNode;
    S: RawByteString;
  begin
    Stream.Read(I, sizeof(I));
    SetLength(S, I);
    Stream.Read(PAnsiChar(S)^, I);

    if HasUTF8BOM(S) then
    begin
      Delete(S, 1, Length(sUTF8BOMString));
      SetCodePage(S, 65001, False);
    end
    else
      SetCodePage(S, GetACP, False);

    NewNode := Nodes.AddChild(Parent, string(S));
    Stream.Read(I, sizeof(I));
    NewNode.ImageIndex := I;
    Stream.Read(I, sizeof(I));
    NewNode.Style := TOvcOlNodeStyle(I);
    Stream.Read(I, sizeof(I));
    NewNode.Checked := I <> 0;
    Stream.Read(I, sizeof(I));
    NewNode.Mode := TOvcOlNodeMode(I);
    LoadLevel(Stream, NewNode);
  end;

  procedure LoadLevel(Stream : TStream; Parent : TOvcOutlineNode);
  var
    NodeCount : Integer;
    i : Integer;
  begin
    Stream.Read(NodeCount, sizeof(NodeCount));
    for i := 0 to pred(NodeCount) do
      ReadNode(Stream, Parent);
  end;

begin
  Clear;
  LoadLevel(Stream, nil);
end;

procedure TOvcCustomOutline.SaveAsText(const FileName: string;
  Encoding: TEncoding);

  procedure WriteNode(S : TStreamWriter; Level : Integer; ParentNode : TOvcOutlineNode);
  const
    Tab: Char = #9;
  var
    i : Integer;
    Node: TOvcOutlineNode;
  begin
    for i := 0 to Level - 1 do
      S.Write(Tab);
    S.Write(ParentNode.Text);
    S.WriteLine;
    if ParentNode.HasChildren then begin
      ParentNode.PushChildIndex;
      Node := ParentNode.FirstChild;
      if Node <> nil then
        repeat
          WriteNode(S, Level + 1, Node);
          Node := ParentNode.NextChild;
        until Node = nil;
      ParentNode.PopChildIndex;
    end;
  end;

var
  S : TStreamWriter;
  Node: TOvcOutlineNode;
begin
  S := TStreamWriter.Create(FileName, False, Encoding);
  try
    PushChildIndex;
    Node := FirstChild;
    if Node <> nil then
      repeat
        WriteNode(S, 0, Node);
        Node := NextChild;
      until Node = nil;
    PopChildIndex;
  finally
    S.Free;
  end;
end;

procedure TOvcCustomOutline.SaveToFile(const FileName: string);
var
  S : TFileStream;
begin
  S := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(S);
  finally
    S.Free;
  end;
end;

procedure TOvcCustomOutline.SaveToStream(Stream: TStream);

  procedure WriteNode(S : TStream; Level : Integer; ParentNode : TOvcOutlineNode);
  var
    I : Integer;
    Node: TOvcOutlineNode;
    Txt: UTF8String;
  begin
    Txt := UTF8String(ParentNode.Text);
    I := Length(Txt);
    if HasExtendCharacter(Txt) then
    begin
      Inc(I, 3);
      Stream.Write(I, sizeof(i));
      Stream.Write(sUTF8BOMString[1], Length(sUTF8BOMString));
      Stream.Write(PAnsiChar(Txt)^, I - Length(sUTF8BOMString));
    end
    else
    begin
      Stream.Write(I, sizeof(i));
      Stream.Write(PAnsiChar(Txt)^, I);
    end;

    I := ParentNode.ImageIndex;
    Stream.Write(I, sizeof(I));
    I := ord(ParentNode.Style);
    Stream.Write(I, sizeof(I));
    I := ord(ParentNode.Checked);
    Stream.Write(I, sizeof(I));
    I := ord(ParentNode.Mode);
    Stream.Write(I, sizeof(I));
    if ParentNode.HasChildren then
      I := ParentNode.FFChildren.Count
    else
      I := 0;
    Stream.Write(I, sizeof(I));

    if ParentNode.HasChildren then begin
      ParentNode.PushChildIndex;
      Node := ParentNode.FirstChild;
      if Node <> nil then
        repeat
          WriteNode(S, Level + 1, Node);
          Node := ParentNode.NextChild;
        until Node = nil;
      ParentNode.PopChildIndex;
    end;
  end;

var
  i : Integer;
  Node: TOvcOutlineNode;
begin
  i := Nodes.Count;
  Stream.Write(i, sizeof(i));
  PushChildIndex;
  Node := FirstChild;
  if Node <> nil then
    repeat
      WriteNode(Stream, 0, Node);
      Node := NextChild;
    until Node = nil;
  PopChildIndex;
end;

procedure TOvcCustomOutline.SetActiveNode(const Value: TOvcOutlineNode);
begin
  if Value = FActiveNode then exit;
  if FActiveNode <> nil then
    FActiveNode.Invalidate;
  DoActiveChange(FActiveNode, Value);
  if FActiveNode <> nil then begin
    FActiveNode.Visible := True;
    Update;
    ItemIndex := FActiveNode.Index;
    FActiveNode.Invalidate;
  end;
end;

procedure TOvcCustomOutline.SetCurrentKey(const Value: Integer);
begin
  if Value <> FCurrentKey then begin
    if (Value < 0) or (Value >= Keys) then
      raise Exception.Create('Key value out of range');
    if (Value > 0) and not assigned(FOnCompareNodes) then
      raise Exception.Create('OnCompareNodes not assigned');
    FCurrentKey := Value;
    FAbsNodes.CurrentKey := Value;
    FNodeIndex.CurrentKey := Value;
    NodeCache.Clear;
    UpdateLines;
  end;
end;

procedure TOvcCustomOutline.SetKeys(const Value: Integer);
begin
  if Value <> FKeys then begin
    if not FAbsNodes.Empty {Nodes.FNodesy.Empty {Nodes.Count <> 0} then
      raise Exception.Create(
        'Number of keys cannot be changed while an outline contains data');
    if Value < 1 then
      raise Exception.Create('Number of keys cannot be lower than one');
    if Value > dlmMaxKeys then
      raise Exception.CreateFmt('Number of keys cannot greater than %d',[dlmMaxKeys]);
    FNodes.Free;
    FKeys := Value;
    FNodes := TOvcOutlineNodes.Create(Self, nil);
    FAbsNodes.Free;
    FNodeIndex.Free;
    FAbsNodes := TOvcOutlineNodeList.Create(Keys, CompareNodesGlobal);
    FAbsNodes.CurrentKey := CurrentKey;
    FNodeIndex := TOvcOutlineNodeList.Create(Keys, CompareNodesLocal);
    FNodeIndex.CurrentKey := CurrentKey;
  end;
end;

procedure TOvcCustomOutline.SetShowImages(const Value: Boolean);
begin
  if Value <> FShowImages then begin
    FShowImages := Value;
    Invalidate;
  end;
end;

procedure TOvcCustomOutline.UpdateActiveNode;
begin
  if (FActiveNode <> nil) and FActiveNode.Visible then
    ItemIndex := FActiveNode.Index
  else begin
    ItemIndex := -1;
    if not (csDestroying in ComponentState) then
      DoActiveChange(FActiveNode, nil);
  end;
end;

procedure TOvcCustomOutline.vlbDrawFocusRect(Canvas : TCanvas; const Rect : TRect);
  {-draw the focus rectangle}
begin
  if Focused then
    Canvas.DrawFocusRect(Rect);
end;

procedure TOvcCustomOutline.WMLButtonDown(var Msg : TWMLButtonDown);
var
  Index : Integer;
  Pt    : TPoint;
  InitActive : TOvcOutlineNode;
begin
  InitActive := ActiveNode;
  FDelayNotify := True;
  try
    if (NumItems <> 0) then begin
      GetCursorPos(Pt);
      Pt := ScreenToClient(Pt);
      Index := PointToIndex(Pt.Y);
      if Index <> -1 then begin
        if IsGroup[Index] and PtInRect(Node[Index].ButtonRect, Pt) then begin
          MousePassThru := True;
          inherited;
          MousePassThru := False;
          exit;
        end;
      end;
    end;
    inherited;
  finally
    if ActiveNode <> InitActive then begin
      if (Assigned(FOnActiveChange)) then
        FOnActiveChange(Self, InitActive, ActiveNode);
    end;
    FDelayNotify := False;
  end;
end;

(* !!.02
procedure TOvcCustomOutline.WMMouseMove(var Msg : TWMMouseMove);
begin
  inherited;
  if FHoverTimer <> -1 then
    FController.TimerPool.ResetElapsedTime(FHoverTimer);
  if (HintX <> Msg.XPos) and (HintY <> Msg.YPos) then begin
    if IsWindowVisible(HintWindow.Handle) then
      HideHint;
    HintShownHere := False;
  end;
  HintX := Msg.XPos;
  HintY := Msg.YPos;
end;
*)

procedure TOvcCustomOutline.WMSetFocus(var Msg : TWMSetFocus);
begin
  inherited;
  Invalidate;
end;

procedure TOvcCustomOutline.WMKillFocus(var Msg : TWmKillFocus);
begin
  inherited;
  Invalidate;
end;

procedure TOvcCustomOutline.WMKeyDown(var Msg: TWMKeyDown);
var
  InitActive : TOvcOutlineNode;
begin
  InitActive := ActiveNode;
  FDelayNotify := True;
  try
    inherited;
  finally
    if ActiveNode <> InitActive then begin
      if (Assigned(FOnActiveChange)) then
        FOnActiveChange(Self, InitActive, ActiveNode);
    end;
    FDelayNotify := False;
  end;
end;

function TOvcCustomOutline.FirstChild: TOvcOutlineNode;
var
  TmpNode : TOvcOutlineNode;
begin
  TmpNode := TOvcOutlineNode.Create(Self, nil, nil, nil);
  try
    TmpNode.FParent := nil;
    Result := FNodeIndex.GGEQ(TmpNode);
    if Result <> nil then
      if Result.Parent <> nil then
        Result := nil;
  finally
    TmpNode.Free;
  end;
end;

{ new}
function TOvcCustomOutline.LastChild: TOvcOutlineNode;
var
  TmpNode : TOvcOutlineNode;
begin
  TmpNode := TOvcOutlineNode.Create(Self, nil, nil, nil);
  try
    TmpNode.FParent := nil;
    TmpNode.Seq := 1;
    Result := FNodeIndex.GLEQ(TmpNode);
    if Result <> nil then
      if Result.Parent <> nil then
        Result := nil;
  finally
    TmpNode.Free;
  end;
end;

function TOvcCustomOutline.NextChild: TOvcOutlineNode;
begin
  Result := FNodeIndex.NextItem;
  if Result <> nil then
    if Result.Parent <> nil then
      Result := nil;
end;

procedure TOvcCustomOutline.PopChildIndex;
begin
  FNodeIndex.PopIndex;
end;

procedure TOvcCustomOutline.PushChildIndex;
begin
  FNodeIndex.PushIndex;
end;

procedure TOvcCustomOutline.SetTextSort(const Value: Boolean);
begin
  if Value <> FTextSort then begin
    FTextSort := Value;
  end;
end;


procedure TOvcCustomOutline.UpdateScrollWidth;
begin
  if (ScrollBars in [ssHorizontal, ssBoth]) then
    if lUpdating > 0 then
      UpdateScrollWidthPending := True
    else begin
      Columns := MaxI(0, CalcMaxWidth - ClientWidth);
      if Columns = 0 then
        lhDelta := 0;
      UpdateScrollWidthPending := False;
    end;
end;

procedure TOvcCustomOutline.SetScrollBars(const Value: TScrollStyle);
begin
  inherited;
  UpdateScrollWidth;
end;

procedure TOvcCustomOutline.SetBounds(ALeft, ATop, AWidth,
  AHeight: Integer);
begin
  inherited;
  UpdateScrollWidth;
end;

{ new}
procedure TOvcCustomOutline.CMHintShow(var Message: TMessage);
var
  Index: Integer;
  Pt: TPoint;
begin
  with TCMHintShow(Message) do begin
    Index := PointToIndex(HintInfo.CursorPos.y);
    if (Index <> -1)
    and IsValidIndex(Index)
    and (Node[Index].Truncated)
    and (PtInRect(Node[Index].TextRect, Point(HintInfo.CursorPos.x, HintInfo.CursorPos.y))) then begin
      TCMHintShow(Message).HintInfo.HintStr := Node[Index].Text;
      Pt := ClientToScreen(Node[Index].TextRect.TopLeft);
      TCMHintShow(Message).HintInfo.HintPos := Pt;
    end;
  end;

end;

{ new}
procedure TOvcCustomOutline.SetCacheSize(const Value: Integer);
begin
  if Value <> FCacheSize then begin
    FCacheSize := Value;
    NodeCache.Free;
    NodeCache := TOvcLiteCache.Create(sizeof(Integer), Value);
  end;
end;

{ TOvcOutlineNodeList }

procedure TOvcOutlineNodeList.Add(NewNode: TOvcOutlineNode);
begin
  Assert(TObject(NewNode) is TOvcOutlineNode);
  List.Add(NewNode);
end;

procedure TOvcOutlineNodeList.Clear;
begin
  List.Clear;
end;

function TOvcOutlineNodeList.Count: Integer;
begin
  Result := List.Count;
end;

constructor TOvcOutlineNodeList.Create;
begin
  List := TOvcSortedList.Create(NumKeys, CompareFunc);
end;

procedure TOvcOutlineNodeList.Delete(Node: TOvcOutlineNode);
begin
  Assert(TObject(Node) is TOvcOutlineNode);
  List.Delete(Node);
end;

destructor TOvcOutlineNodeList.Destroy;
begin
  List.Free;
  inherited;
end;

function TOvcOutlineNodeList.Empty: Boolean;
begin
  Result := List.Empty;
end;

function TOvcOutlineNodeList.First(var Node: TOvcOutlineNode): Boolean;
begin
  Result := List.First(Pointer(Node));
  if Result then
    Assert(TObject(Node) is TOvcOutlineNode);
end;

function TOvcOutlineNodeList.FirstItem: TOvcOutlineNode;
begin
  Pointer(Result) := List.FirstItem;
  if Result <> nil then
    Assert(TObject(Result) is TOvcOutlineNode);
end;

function TOvcOutlineNodeList.GetCurrentKey: Integer;
begin
  Result := List.CurrentKey;
end;

function TOvcOutlineNodeList.GetNode(Index: Integer): TOvcOutlineNode;
begin
  if First(Result) then
    repeat
      dec(Index);
      if Index < 0 then
        exit;
    until not Next(Result);
  raise Exception.Create('Invalid node index');
end;

function TOvcOutlineNodeList.GGEQ(
  SearchNode: TOvcOutlineNode): TOvcOutlineNode;
begin
  if not List.GGEQ(SearchNode, Pointer(Result)) then
    Result := nil
  else
    Assert(TObject(Result) is TOvcOutlineNode);
end;

function TOvcOutlineNodeList.GLEQ(
  SearchNode: TOvcOutlineNode): TOvcOutlineNode;
begin
  if not List.GLEQ(SearchNode, Pointer(Result)) then
    Result := nil
  else
    Assert(TObject(Result) is TOvcOutlineNode);
end;

function TOvcOutlineNodeList.Last(var Node: TOvcOutlineNode): Boolean;
begin
  Node := List.LastItem;
  Result := Node <> nil;
  Assert(not Result or (TObject(Node) is TOvcOutlineNode));
end;

function TOvcOutlineNodeList.LastItem: TOvcOutlineNode;
begin
  Result := List.LastItem;
  Assert((Result = nil) or (TObject(Result) is TOvcOutlineNode));
end;

function TOvcOutlineNodeList.Next(var Node: TOvcOutlineNode): Boolean;
begin
  Result := List.Next(Pointer(Node));
  Assert(not Result or (TObject(Node) is TOvcOutlineNode));
end;

function TOvcOutlineNodeList.NextItem: TOvcOutlineNode;
begin
  if not List.Next(Pointer(Result)) then
    Result := nil;
  Assert((Result = nil) or (TObject(Result) is TOvcOutlineNode));
end;

procedure TOvcOutlineNodeList.PopIndex;
begin
  List.PopIndex;
end;

procedure TOvcOutlineNodeList.PushIndex;
begin
  List.PushIndex;
end;

procedure TOvcOutlineNodeList.SetCurrentKey(const Value: Integer);
begin
  List.CurrentKey := Value;
end;

{ global stuff }

procedure LoadResources;
begin
  BrushBitmap := TBitmap.Create;
  BrushBitmap.Handle := LoadBaseBitmap('OROLBRUSH');
end;

procedure FreeResources; far;
{Release allocated global resources.}
begin
  BrushBitmap.Free;
end;

initialization
  LoadResources;

finalization
  FreeResources;
end.
