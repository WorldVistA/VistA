{*********************************************************}
{*                  OVCTCELL.PAS 4.06                    *}
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

unit ovctcell;
  {-Cell ancestor class; cell matrix class}

interface

uses
  Windows, SysUtils, Messages, Graphics, Classes, Controls,
  OvcTCmmn, OvcSpAry, OvcVer;

type
  TOvcBaseTableCell = class(TOvcTableCellAncestor)
    protected {private}
      

      {property fields - even size}
      FColor      : TColor;
      FFont       : TFont;
      FHint       : string;
      FMargin     : Integer;
      FReferences : Integer;
      FTable      : TOvcTableAncestor;
      FTextHiColor: TColor;
      {property fields - odd size}
      FAcceptActivationClick : boolean;
      FAccess     : TOvcTblAccess;
      FAdjust     : TOvcTblAdjust;
      FShowHint   : boolean;
      FTableColor : boolean;
      FTableFont  : boolean;
      FTextStyle  : TOvcTextStyle;
      Filler      : Byte;
      {property event fields}
      FOnClick     : TNotifyEvent;
      FOnDblClick  : TNotifyEvent;
      FOnDragDrop  : TDragDropEvent;
      FOnDragOver  : TDragOverEvent;
      FOnEndDrag   : TEndDragEvent;
      FOnEnter     : TNotifyEvent;
      FOnExit      : TNotifyEvent;
      FOnKeyDown   : TKeyEvent;
      FOnKeyPress  : TKeyPressEvent;
      FOnKeyUp     : TKeyEvent;
      FOnMouseDown : TMouseEvent;
      FOnMouseMove : TMouseMoveEvent;
      FOnMouseUp   : TMouseEvent;
      FOnOwnerDraw : TCellPaintNotifyEvent;


      tcBadColorValue  : boolean;
      tcBadFontValue   : boolean;
      tcNoConfigChange : boolean;

      {property methods}
      function GetAbout : string;
      procedure SetAbout(const Value : string);

    protected
      

      {property access}
      function GetColor : TColor;
      function GetCellEditor : TControl; virtual;
      function GetFont : TFont;

      procedure SetAccess(A : TOvcTblAccess);
      procedure SetAdjust(A : TOvcTblAdjust);
      procedure SetColor(C : TColor);
      procedure SetFont(F : TFont);
      procedure SetHint(const H : string);
      procedure SetMargin(M : Integer);
      procedure SetTable(T : TOvcTableAncestor);
      procedure SetTableColor(B : boolean);
      procedure SetTableFont(B : boolean);
      procedure SetTextHiColor(THC : TColor);
      procedure SetTextStyle(TS : TOvcTextStyle);

      {property storage}
      function IsColorStored : boolean;
      function IsFontStored : boolean;

      {miscellaneous}
      procedure tcChangeScale(M, D : integer); override;
      procedure tcFontHasChanged(Sender : TObject);
      procedure tcPaint(TableCanvas : TCanvas;
                  const CellRect    : TRect;
                        RowNum      : TRowNum;
                        ColNum      : TColNum;
                  const CellAttr    : TOvcCellAttributes;
                        Data        : pointer); virtual;
      procedure tcRetrieveTableColor;
      function tcRetrieveTableActiveCol : TColNum;
      function tcRetrieveTableActiveRow : TRowNum;
      procedure tcRetrieveTableFont;
      function tcRetrieveTableLockedCols : TColNum;
      function tcRetrieveTableLockedRows : TRowNum;


      {properties}
      property Color : TColor
         read GetColor write SetColor
         stored IsColorStored;

      property TextHiColor : TColor
         read FTextHiColor write SetTextHiColor;

      property Font : TFont
         read GetFont write SetFont
         stored IsFontStored;

      property Hint : string
         read FHint write SetHint;

      property Margin : Integer
         read FMargin write SetMargin;

      property ShowHint : boolean
         read FShowHint write FShowHint;

      property TableColor : boolean
         read FTableColor write SetTableColor;

      property TableFont : boolean
         read FTableFont write SetTableFont;

      property TextStyle : TOvcTextStyle
         read FTextStyle write SetTextStyle;

      {events}
      property OnClick : TNotifyEvent
         read FOnClick write FOnClick;

      property OnDblClick : TNotifyEvent
         read FOnDblClick write FOnDblClick;

      property OnDragDrop : TDragDropEvent
         read FOnDragDrop write FOnDragDrop;

      property OnDragOver : TDragOverEvent
         read FOnDragOver write FOnDragOver;

      property OnEndDrag : TEndDragEvent
         read FOnEndDrag write FOnEndDrag;

      property OnEnter : TNotifyEvent
         read FOnEnter write FOnEnter;

      property OnExit : TNotifyEvent
         read FOnExit write FOnExit;

      property OnKeyDown : TKeyEvent
         read FOnKeyDown write FOnKeyDown;

      property OnKeyPress : TKeyPressEvent
         read FOnKeyPress write FOnKeyPress;

      property OnKeyUp : TKeyEvent
         read FOnKeyUp write FOnKeyUp;

      property OnMouseDown : TMouseEvent
         read FOnMouseDown write FOnMouseDown;

      property OnMouseMove : TMouseMoveEvent
         read FOnMouseMove write FOnMouseMove;

      property OnMouseUp : TMouseEvent
         read FOnMouseUp write FOnMouseUp;

      property OnOwnerDraw : TCellPaintNotifyEvent
         read FOnOwnerDraw write FOnOwnerDraw;

    public {protected}
      

      {internal use only methods}
      procedure Notification(AComponent: TComponent; Operation: TOperation); override;
      procedure tcResetTableValues; override;

      {methods to support third-party components in the data-aware table}
      function SpecialCellSupported(Field : TObject) : Boolean;
        virtual;
      function SpecialCellDataSize : Integer;
        virtual;
      procedure SpecialCellDataTransfer(Field : TObject; Data : Pointer; Purpose : TOvcCellDataPurpose);
        virtual;


    public
      constructor Create(AOwner : TComponent); override;
      destructor Destroy; override;

      {reference counting}
      procedure IncRefs;
      procedure DecRefs;

      {Edit cell base methods to override}
      function  EditHandle : THandle; virtual;
      procedure EditHide; virtual;
      procedure EditMove(CellRect : TRect); virtual;

      {Editing base methods to override}
      function CanSaveEditedData(SaveValue : boolean) : boolean; virtual;
      function CanStopEditing(SaveValue : boolean) : boolean; {for Orpheus 1.0 compatibility}
      function FilterTableKey(var Msg : TWMKey) : TOvcTblKeyNeeds; virtual;

      procedure PostMessageToTable(Msg, wParam, lParam : Integer);

      procedure SendKeyToTable(var Msg : TWMKey);
      procedure SaveEditedData(Data : pointer); virtual;
      procedure StartEditing(RowNum : TRowNum; ColNum : TColNum;
                             CellRect : TRect;
                       const CellAttr : TOvcCellAttributes;
                             CellStyle: TOvcTblEditorStyle;
                             Data : pointer); virtual;
      procedure StopEditing(SaveValue : boolean;
                            Data : pointer); virtual;
      function TableWantsEnter : boolean;
      function TableWantsTab : boolean;

      {painting}

      function DoOwnerDraw(TableCanvas : TCanvas;
                     const CellRect    : TRect;
                           RowNum      : TRowNum;
                           ColNum      : TColNum;
                     const CellAttr    : TOvcCellAttributes;
                           Data        : pointer) : boolean; virtual;

      procedure Paint(TableCanvas : TCanvas;
                const CellRect    : TRect;
                      RowNum      : TRowNum;
                      ColNum      : TColNum;
                const CellAttr    : TOvcCellAttributes;
                      Data        : pointer);
      procedure ResolveAttributes(RowNum : TRowNum; ColNum : TColNum;
                                  var CellAttr : TOvcCellAttributes); virtual;

      {properties}
      property AcceptActivationClick : boolean
         read FAcceptActivationClick write FAcceptActivationClick;

      property Access : TOvcTblAccess
         read FAccess write SetAccess;

      property Adjust : TOvcTblAdjust
         read FAdjust write SetAdjust;

      property CellEditor : TControl
         read GetCellEditor;

      property References : Integer
         read FReferences;

      property Table : TOvcTableAncestor
         read FTable write SetTable;

    published
      property About : string
        read GetAbout write SetAbout stored False;
  end;

  TOvcTableCells = class
    protected {private}

      {property fields}
      FMatrix       : TOvcSparseArray;
      FOnCfgChanged : TNotifyEvent;
      FTable        : TOvcTableAncestor;

      {other fields}
      tcCellAttrCount : Integer; {count of non-blank cells}


    protected

      function GetAccess(RowNum : TRowNum; ColNum : TColNum) : TOvcTblAccess;
      function GetAdjust(RowNum : TRowNum; ColNum : TColNum) : TOvcTblAdjust;
      function GetCell(RowNum : TRowNum; ColNum : TColNum) : TOvcBaseTableCell;
      function GetColor(RowNum : TRowNum; ColNum : TColNum) : TColor;
      function GetFont(RowNum : TRowNum; ColNum : TColNum) : TFont;

      procedure SetAccess(RowNum : TRowNum; ColNum : TColNum; A : TOvcTblAccess);
      procedure SetAdjust(RowNum : TRowNum; ColNum : TColNum; A : TOvcTblAdjust);
      procedure SetCell(RowNum : TRowNum; ColNum : TColNum; BTC : TOvcBaseTableCell);
      procedure SetColor(RowNum : TRowNum; ColNum : TColNum; C : TColor);
      procedure SetFont(RowNum : TRowNum; ColNum : TColNum; F : TFont);


    public {protected}

      {internal use only methods}
      procedure tcNotifyCellDeletion(Cell : TOvcBaseTableCell);
      procedure tcDoCfgChanged;

      property OnCfgChanged : TNotifyEvent
         write FOnCfgChanged;
      property Table : TOvcTableAncestor
         read FTable write FTable;


    public
      constructor Create(ATable : TOvcTableAncestor);
      destructor Destroy; override;

      procedure DeleteCol(ColNum : TColNum);
      procedure DeleteRow(RowNum : TRowNum);
      procedure ExchangeCols(ColNum1, ColNum2 : TColNum);
      procedure ExchangeRows(RowNum1, RowNum2 : TRowNum);
      procedure InsertCol(ColNum : TColNum);
      procedure InsertRow(RowNum : TRowNum);

      procedure ResetCell(RowNum : TRowNum; ColNum : TColNum);
      procedure ResolveFullAttr(RowNum : TRowNum; ColNum : TColNum;
                                var SCA : TOvcSparseAttr);

      property Access [RowNum : TRowNum; ColNum : TColNum] : TOvcTblAccess
         read GetAccess write SetAccess;

      property Adjust [RowNum : TRowNum; ColNum : TColNum] : TOvcTblAdjust
         read GetAdjust write SetAdjust;

      property Cell [RowNum : TRowNum; ColNum : TColNum] : TOvcBaseTableCell
         read GetCell write SetCell;
         default;

      property Color [RowNum : TRowNum; ColNum : TColNum] : TColor
         read GetColor write SetColor;

      property Font [RowNum : TRowNum; ColNum : TColNum] : TFont
         read GetFont write SetFont;
  end;

implementation

{===TOvcCustomCell===================================================}
constructor TOvcBaseTableCell.Create(AOwner : TComponent);
  begin
    inherited Create(AOwner);

    FAccess := otxDefault;
    FAdjust := otaDefault;
    FColor := tbDefTableColor;
    FTextHiColor := clBtnHighlight;
    FFont := TFont.Create;
    FFont.OnChange := tcFontHasChanged;
    FTableColor := true;
    tcBadColorValue := true;
    FTableFont := true;
    tcBadFontValue := true;
    FMargin := tbDefMargin;
  end;
{--------}
destructor TOvcBaseTableCell.Destroy;
  begin
    Table := nil;
    FFont.Free;
    inherited Destroy;
  end;
{--------}

function  TOvcBaseTableCell.EditHandle : THandle;
begin
  {do nothing. just here to satisfy BCB}
  Result := 0;
end;

procedure TOvcBaseTableCell.EditHide;
begin
  {do nothing. just here to satisfy BCB}
end;

procedure TOvcBaseTableCell.EditMove(CellRect : TRect);
begin
  {do nothing. just here to satisfy BCB}
end;

function TOvcBaseTableCell.CanSaveEditedData(SaveValue : boolean) : boolean;
  begin
    Result := true;
  end;
{--------}
function TOvcBaseTableCell.CanStopEditing(SaveValue : boolean) : boolean;
  begin
    Result := CanSaveEditedData(SaveValue);
  end;
{--------}
procedure TOvcBaseTableCell.tcChangeScale(M, D : integer);
  begin
    if (M <> D) and (not TableFont) then
      FFont.Size := MulDiv(FFont.Size, M, D);
  end;
{--------}
procedure TOvcBaseTableCell.DecRefs;
  begin
    if (FReferences > 0) then
      begin
        dec(FReferences);
        if (FReferences = 0) then
          begin
            FTable.tbExcludeCell(Self);
            FTable := nil;
            FOnCfgChanged := nil;
          end;
      end;
  end;
{--------}
function TOvcBaseTableCell.DoOwnerDraw(TableCanvas : TCanvas;
                                 const CellRect    : TRect;
                                       RowNum      : TRowNum;
                                       ColNum      : TColNum;
                                 const CellAttr    : TOvcCellAttributes;
                                       Data        : pointer) : boolean;
  begin
    Result := false;
    if Assigned(FOnOwnerDraw) then
      FOnOwnerDraw(Self, TableCanvas, CellRect, RowNum, ColNum, CellAttr, Data, Result);
  end;
{--------}
function TOvcBaseTableCell.FilterTableKey(var Msg : TWMKey) : TOvcTblKeyNeeds;
  begin
    if not Assigned(FTable) then
      Result := otkDontCare
    else
      Result := FTable.FilterKey(Msg);
  end;
{--------}
procedure TOvcBaseTableCell.tcFontHasChanged(Sender : TObject);
  begin
    if not tcNoConfigChange then
      begin
        FTableFont := false;
        tcDoCfgChanged;
      end;
  end;
{--------}
function TOvcBaseTableCell.GetColor : TColor;
  begin
    if TableColor and tcBadColorValue then
      tcRetrieveTableColor;
    Result := FColor;
  end;
{--------}
function TOvcBaseTableCell.GetCellEditor : TControl;
  begin
    Result := nil;
  end;
{--------}
function TOvcBaseTableCell.GetFont : TFont;
  begin
    if TableFont and tcBadFontValue then
      begin
        tcNoConfigChange := true;
        tcRetrieveTableFont;
        tcNoConfigChange := false;
      end;
    Result := FFont;
  end;
{--------}
procedure TOvcBaseTableCell.IncRefs;
  begin
    if (FReferences = 0) and Assigned(FTable) then
      FTable.tbIncludeCell(Self);
    inc(FReferences);
  end;
{--------}
function TOvcBaseTableCell.IsColorStored : boolean;
  begin
    Result := not TableColor;
  end;
{--------}
function TOvcBaseTableCell.IsFontStored : boolean;
  begin
    Result := not TableFont;
  end;
{--------}
procedure TOvcBaseTableCell.Notification(AComponent: TComponent; Operation: TOperation);
  begin
    inherited Notification(AComponent, Operation);
    if (AComponent is TOvcTableAncestor) and
       (Operation = opRemove) and
       (TOvcTableAncestor(AComponent) = FTable) then
      begin
        FTable := nil;
        FOnCfgChanged := nil;
      end;
  end;
{--------}
procedure TOvcBaseTableCell.Paint(TableCanvas : TCanvas;
                            const CellRect    : TRect;
                                  RowNum      : TRowNum;
                                  ColNum      : TColNum;
                            const CellAttr    : TOvcCellAttributes;
                                  Data        : pointer);
  begin
    if not DoOwnerDraw(TableCanvas, CellRect, RowNum, ColNum, CellAttr, Data) then
      tcPaint(TableCanvas, CellRect, RowNum, ColNum, CellAttr, Data);
  end;
{--------}
procedure TOvcBaseTableCell.tcPaint(TableCanvas : TCanvas;
                              const CellRect    : TRect;
                                    RowNum      : TRowNum;
                                    ColNum      : TColNum;
                              const CellAttr    : TOvcCellAttributes;
                                    Data        : pointer);
  begin
    with TableCanvas do
      begin
        Brush.Color := CellAttr.caColor;
        FillRect(CellRect);
      end;
  end;
{--------}
procedure TOvcBaseTableCell.PostMessageToTable(Msg, wParam, lParam : Integer);
  begin
    if Assigned(FTable) and FTable.HandleAllocated  then
      PostMessage(FTable.Handle, Msg, wParam, lParam)
  end;
{--------}
procedure TOvcBaseTableCell.tcResetTableValues;
  begin
    if Assigned(FTable) then
      begin
        if TableFont then
          tcRetrieveTableFont;
        if TableColor then
          tcRetrieveTableColor;
      end;
  end;
{--------}
procedure TOvcBaseTableCell.ResolveAttributes(RowNum : TRowNum; ColNum : TColNum;
                                                var CellAttr : TOvcCellAttributes);
  begin
    with CellAttr do
      begin
        caAccess := Access;
        caAdjust := Adjust;
        caColor := Color;
        caFont.Assign(Font);
        caFontColor := Font.Color;
        caFontHiColor := TextHiColor;
        caTextStyle := TextStyle;
      end;
    if Assigned(FTable) then
      FTable.ResolveCellAttributes(RowNum, ColNum, CellAttr);
    with CellAttr do
      begin
        if (caAccess = otxDefault) then
          caAccess := tbDefAccess;
        if (caAdjust = otaDefault) then
          caAdjust := tbDefAdjust;
        if (caColor = clOvcTableDefault) then
          caColor := tbDefTableColor;
      end;
  end;
{--------}
procedure TOvcBaseTableCell.tcRetrieveTableColor;
  begin
    if Assigned(FTable) and FTable.HandleAllocated then
      begin
        FColor := SendMessage(FTable.Handle, ctim_QueryColor, 0, 0);
        tcBadColorValue := false;
      end
    else
      tcBadColorValue := true;
  end;
{--------}
function TOvcBaseTableCell.tcRetrieveTableActiveCol : TColNum;
  begin
    Result := 0;
    if Assigned(FTable) and FTable.HandleAllocated  then
      Result  := SendMessage(FTable.Handle, ctim_QueryActiveCol, 0, 0);
  end;
{--------}
function TOvcBaseTableCell.tcRetrieveTableActiveRow : TRowNum;
  begin
    Result := 0;
    if Assigned(FTable) and FTable.HandleAllocated then
      Result  := SendMessage(FTable.Handle, ctim_QueryActiveRow, 0, 0);
  end;
{--------}
procedure TOvcBaseTableCell.tcRetrieveTableFont;
  var
    TblFont : TFont;
  begin
    if Assigned(FTable) and FTable.HandleAllocated then
      begin
        TblFont := TFont(SendMessage(FTable.Handle, ctim_QueryFont, 0, 0));
        if Assigned(TblFont) then
          FFont.Assign(TblFont);
        tcBadFontValue := false;
        FTableFont := true;
      end
    else
      tcBadFontValue := true;
  end;
{--------}
function TOvcBaseTableCell.tcRetrieveTableLockedCols : TColNum;
  begin
    Result := 0;
    if Assigned(FTable) and FTable.HandleAllocated then
      Result  := SendMessage(FTable.Handle, ctim_QueryLockedCols, 0, 0);
  end;
{--------}
function TOvcBaseTableCell.tcRetrieveTableLockedRows : TRowNum;
  begin
    Result := 0;
    if Assigned(FTable) and FTable.HandleAllocated  then
      Result  := SendMessage(FTable.Handle, ctim_QueryLockedRows, 0, 0);
  end;
{--------}
procedure TOvcBaseTableCell.SendKeyToTable(var Msg : TWMKey);
  begin
    if Assigned(FTable) and FTable.HandleAllocated  then
      PostMessage(FTable.Handle, WM_KEYDOWN, Msg.CharCode, Msg.KeyData);
  end;
{--------}
procedure TOvcBaseTableCell.SetAccess(A : TOvcTblAccess);
  begin
    if (A <> FAccess) then
      begin
        FAccess := A;
        tcDoCfgChanged;
      end;
  end;
{--------}
procedure TOvcBaseTableCell.SetAdjust(A : TOvcTblAdjust);
  begin
    if (A <> FAdjust) then
      begin
        FAdjust := A;
        tcDoCfgChanged;
      end;
  end;
{--------}
procedure TOvcBaseTableCell.SetColor(C : TColor);
  begin
    if (C <> FColor) then
      begin
        FColor := C;
        FTableColor := false;
        tcBadColorValue := false;
        tcDoCfgChanged;
      end;
  end;
{--------}
procedure TOvcBaseTableCell.SetFont(F : TFont);
  begin
    FFont.Assign(F);
    tcBadFontValue := false;
    FTableFont := false;
    tcDoCfgChanged;
  end;
{--------}
procedure TOvcBaseTableCell.SetHint(const H : string);
  begin
    FHint := H;
  end;
{--------}
procedure TOvcBaseTableCell.SetMargin(M : Integer);
  begin
    if (M >= 0) and (M <> FMargin) then
      begin
        FMargin := M;
        tcDoCfgChanged;
      end;
  end;
{--------}
procedure TOvcBaseTableCell.SetTable(T : TOvcTableAncestor);
  begin
    if (T <> FTable) then
      if (not Assigned(T)) or (T is TOvcTableAncestor) then
        begin
          if Assigned(FTable) and FTable.HandleAllocated then
            SendMessage(FTable.Handle, ctim_RemoveCell, 0, NativeInt(Self));
          FTable := T;
          FOnCfgChanged := nil;
          FReferences := 0;
          tcResetTableValues;
        end;
  end;
{--------}
procedure TOvcBaseTableCell.SetTableColor(B : boolean);
  begin
    if (B <> FTableColor) then
      begin
        tcBadColorValue := false;
        FTableColor := B;
        if B then
          tcRetrieveTableColor;
        tcDoCfgChanged;
      end;
  end;
{--------}
procedure TOvcBaseTableCell.SetTableFont(B : boolean);
  begin
    if (B <> FTableFont) then
      begin
        tcBadFontValue := false;
        if B then
          tcRetrieveTableFont;
        FTableFont := B;
        tcDoCfgChanged;
      end;
  end;
{--------}
procedure TOvcBaseTableCell.SetTextHiColor(THC : TColor);
  begin
    if (THC <> FTextHiColor) then
      begin
        FTextHiColor := THC;
        tcDoCfgChanged;
      end;
  end;
{--------}
procedure TOvcBaseTableCell.SetTextStyle(TS : TOvcTextStyle);
  begin
    if (TS <> FTextStyle) then
      begin
        FTextStyle := TS;
        tcDoCfgChanged;
      end;
  end;
{--------}
procedure TOvcBaseTableCell.SaveEditedData(Data : pointer);
begin
  {do nothing. just here to satisfy BCB}
end;

procedure TOvcBaseTableCell.StartEditing(RowNum : TRowNum; ColNum : TColNum;
                       CellRect : TRect;
                 const CellAttr : TOvcCellAttributes;
                       CellStyle: TOvcTblEditorStyle;
                       Data : pointer);
begin
  {do nothing. just here to satisfy BCB}
end;

procedure TOvcBaseTableCell.StopEditing(SaveValue : boolean;
                      Data : pointer);
begin
  {do nothing. just here to satisfy BCB}
end;

function TOvcBaseTableCell.TableWantsEnter : boolean;
  var
    Typecast : record
      case boolean of
        false : (LI : Integer);
        true  : (TblOpts : TOvcTblOptionSet);
    end;
  begin
    Result := false;
    if Assigned(FTable) and FTable.HandleAllocated then
      begin
        Typecast.LI := SendMessage(FTable.Handle, ctim_QueryOptions, 0, 0);
        Result := otoEnterToArrow in Typecast.TblOpts;
      end;
  end;
{--------}
function TOvcBaseTableCell.TableWantsTab : boolean;
  var
    Typecast : record
      case boolean of
        false : (LI : Integer);
        true  : (TblOpts : TOvcTblOptionSet);
    end;
  begin
    Result := false;
    if Assigned(FTable) and FTable.HandleAllocated then
      begin
        Typecast.LI := SendMessage(FTable.Handle, ctim_QueryOptions, 0, 0);
        Result := otoTabToArrow in Typecast.TblOpts;
      end;
  end;

function TOvcBaseTableCell.GetAbout : string;
begin
  Result := OrVersionStr;
end;

procedure TOvcBaseTableCell.SetAbout(const Value : string);
begin
end;

{the following three methods should be implemented for descendant }
{cell components to allow them to be used by the data-aware table.}

function TOvcBaseTableCell.SpecialCellSupported(Field : TObject) : Boolean;
begin
  {return true if Field is a supported cell type for the data-aware table}
  Result := False;
end;

function TOvcBaseTableCell.SpecialCellDataSize : Integer;
begin
  {return the size of the buffer needed to save data for this field/cell type}
  Result := 0;
end;

procedure TOvcBaseTableCell.SpecialCellDataTransfer(
            Field : TObject; Data : Pointer; Purpose : TOvcCellDataPurpose);
begin
  {handle transfer of data to/from Field/Pointer}
  {as indicated by the value of Purpose:}
  {cdpForPaint ..for painting}
  {cdpForEdit  ..for editing}
  {cdpForSave  ..for saving edited data}
end;


{====================================================================}


{===CellAttribute helper routines====================================}
function CellAttributeIsBlank(CA : POvcSparseAttr) : boolean;
  begin
    Result := true;
    if Assigned(CA) then with CA^ do
      Result := (scaAccess = otxDefault) and
                (scaAdjust = otaDefault) and
                (scaColor = clOvcTableDefault) and
                (scaFont = nil) and
                (scaCell = nil);
  end;
{--------}
procedure DisposeCellAttribute(CA : POvcSparseAttr);
  begin
    if Assigned(CA) then with CA^ do
      begin
        scaFont.Free;
        if Assigned(scaCell) then
          TOvcBaseTableCell(scaCell).DecRefs;
        Dispose(CA);
      end;
  end;
{--------}
function GetCellAttribute(SA : TOvcSparseArray; RowNum : TRowNum; ColNum : TColNum) : POvcSparseAttr;
  var
    WorkSA : TOvcSparseArray;
  begin
    Result := nil;
    WorkSA := SA[RowNum];
    if Assigned(WorkSA) then
      Result := POvcSparseAttr(WorkSA[ColNum]);
  end;
{--------}
procedure InitCellAttribute(var SCA : TOvcSparseAttr);
  begin
    with SCA do
      begin
        scaAccess := otxDefault;
        scaAdjust := otaDefault;
        scaColor := clOvcTableDefault;
        scaFont := nil;
        scaCell := nil;
      end;
  end;
{--------}
function NewCellAttribute : POvcSparseAttr;
  begin
    New(Result);
    InitCellAttribute(Result^);
  end;
{--------}
function PutCellAttribute(SA : TOvcSparseArray; RowNum : TRowNum; ColNum : TColNum) : POvcSparseAttr;
  var
    WorkSA : TOvcSparseArray;
  begin
    Result := NewCellAttribute;
    WorkSA := SA[RowNum];
    if not Assigned(WorkSA) then
      begin
        WorkSA := TOvcSparseArray.Create;
        SA[RowNum] := WorkSA;
      end;
    WorkSA[ColNum] := Result;
  end;
{--------}
procedure ResetCellAttribute(SA : TOvcSparseArray; RowNum : TRowNum; ColNum : TColNum);
  var
    WorkSA : TOvcSparseArray;
  begin
    WorkSA := SA[RowNum];
    if Assigned(WorkSA) then
      WorkSA[ColNum] := nil;
  end;
{====================================================================}


{===SparseArray iterators============================================}
type
  PDelColRec = ^TDelColRec;
  TDelColRec = packed record
    dcrCellAttrCount : Integer;
    dcrColNum        : Integer;
  end;
  PExchColRec = ^TExchColRec;
  TExchColRec = packed record
    ecrColNum1 : Integer;
    ecrColNum2 : Integer;
  end;
{--------}
function DelCellAttribute(Index : Integer;
                          Item : pointer;
                          ExtraData : pointer) : boolean; far;
  var
    CA : POvcSparseAttr absolute Item;
  begin
    DisposeCellAttribute(CA);
    Result := true;
  end;
{--------}
function DelSparseArray(Index : Integer;
                        Item : pointer;
                        ExtraData : pointer) : boolean; far;
  var
    SL : TOvcSparseArray absolute Item;
  begin
    SL.ForAll(DelCellAttribute, false, ExtraData);
    SL.Destroy;
    Result := true;
  end;
{--------}
function DelCellMinor(Index : Integer;
                      Item : pointer;
                      ExtraData : pointer) : boolean; far;
  var
    CA : POvcSparseAttr absolute Item;
    Cell : TOvcBaseTableCell absolute ExtraData;
  begin
    if (CA^.scaCell = Cell) then
      begin
        Cell.DecRefs;
        CA^.scaCell := nil;
      end;
    Result := true;
  end;
{--------}
function DelCellMajor(Index : Integer;
                      Item : pointer;
                      ExtraData : pointer) : boolean; far;
  var
    SL : TOvcSparseArray absolute Item;
  begin
    SL.ForAll(DelCellMinor, false, ExtraData);
    Result := true;
  end;
{--------}
function DelCol(Index : Integer;
                Item : pointer;
                ExtraData : pointer) : boolean; far;
  var
    SL : TOvcSparseArray absolute Item;
    MyExtraData : PDelColRec absolute ExtraData;
    CA : POvcSparseAttr;
  begin
    CA := POvcSparseAttr(SL[MyExtraData^.dcrColNum]);
    if Assigned(CA) then
      begin
        dec(MyExtraData^.dcrCellAttrCount);
        DisposeCellAttribute(CA);
      end;
    SL.Delete(MyExtraData^.dcrColNum);
    Result := true;
  end;
{--------}
function ExchCols(Index : Integer;
                  Item : pointer;
                  ExtraData : pointer) : boolean; far;
  var
    SL : TOvcSparseArray absolute Item;
    MyExtraData : PExchColRec absolute ExtraData;
  begin
    with MyExtraData^ do
      SL.Exchange(ecrColNum1, ecrColNum2);
    Result := true;
  end;
{--------}
function InsCol(Index : Integer;
                Item : pointer;
                ExtraData : pointer) : boolean; far;
  var
    SL : TOvcSparseArray absolute Item;
    ColNum : Integer absolute ExtraData;
  begin
    SL.Insert(ColNum, nil);
    Result := true;
  end;
{====================================================================}


{===TOvcTableCells===================================================}
constructor TOvcTableCells.Create;
  begin
    inherited Create;
    FMatrix := TOvcSparseArray.Create;
  end;
{--------}
destructor TOvcTableCells.Destroy;
  var
    DummyPtr : pointer;
  begin
    DummyPtr := nil;
    FMatrix.ForAll(DelSparseArray, false, DummyPtr);
    FMatrix.Destroy;
    inherited Destroy;
  end;
{--------}
procedure TOvcTableCells.DeleteCol(ColNum : TColNum);
  var
    MyExtraData : TDelColRec;
  begin
    if (tcCellAttrCount > 0) then
      begin
        MyExtraData.dcrCellAttrCount := tcCellAttrCount;
        MyExtraData.dcrColNum := ColNum;
        FMatrix.ForAll(DelCol, false, @MyExtraData);
        tcCellAttrCount := MyExtraData.dcrCellAttrCount;
        tcDoCfgChanged;
      end;
  end;
{--------}
procedure TOvcTableCells.DeleteRow(RowNum : TRowNum);
  var
    WorkSA : TOvcSparseArray;
  begin
    if (tcCellAttrCount > 0) then
      begin
        WorkSA := FMatrix[RowNum];
        if Assigned(WorkSA) then
          begin
            dec(tcCellAttrCount, WorkSA.ActiveCount);
            WorkSA.ForAll(DelCellAttribute, false, nil);
          end;
        FMatrix.Delete(RowNum);
        tcDoCfgChanged;
      end;
  end;
{--------}
procedure TOvcTableCells.ExchangeCols(ColNum1, ColNum2 : TColNum);
  var
    MyExtraData : TExchColRec;
  begin
    if (tcCellAttrCount > 0) then
      begin
        MyExtraData.ecrColNum1 := ColNum1;
        MyExtraData.ecrColNum2 := ColNum2;
        FMatrix.ForAll(ExchCols, false, @MyExtraData);
        tcDoCfgChanged;
      end;
  end;
{--------}
procedure TOvcTableCells.ExchangeRows(RowNum1, RowNum2 : TRowNum);
  begin
    if (tcCellAttrCount > 0) then
      begin
        FMatrix.Exchange(RowNum1, RowNum2);
        tcDoCfgChanged;
      end;
  end;
{--------}
function TOvcTableCells.GetAccess(RowNum : TRowNum; ColNum : TColNum) : TOvcTblAccess;
  var
    CellAttr : POvcSparseAttr;
  begin
    Result := otxDefault;
    if (tcCellAttrCount > 0) then
      begin
        CellAttr := GetCellAttribute(FMatrix, RowNum, ColNum);
        if Assigned(CellAttr) then
          Result := CellAttr^.scaAccess;
      end;
  end;
{--------}
function TOvcTableCells.GetAdjust(RowNum : TRowNum; ColNum : TColNum) : TOvcTblAdjust;
  var
    CellAttr : POvcSparseAttr;
  begin
    Result := otaDefault;
    if (tcCellAttrCount > 0) then
      begin
        CellAttr := GetCellAttribute(FMatrix, RowNum, ColNum);
        if Assigned(CellAttr) then
          Result := CellAttr^.scaAdjust;
      end;
  end;
{--------}
function TOvcTableCells.GetCell(RowNum : TRowNum; ColNum : TColNum) : TOvcBaseTableCell;
  var
    CellAttr : POvcSparseAttr;
  begin
    Result := nil;
    if (tcCellAttrCount > 0) then
      begin
        CellAttr := GetCellAttribute(FMatrix, RowNum, ColNum);
        if Assigned(CellAttr) then
          Result := TOvcBaseTableCell(CellAttr^.scaCell);
      end;
  end;
{--------}
function TOvcTableCells.GetColor(RowNum : TRowNum; ColNum : TColNum) : TColor;
  var
    CellAttr : POvcSparseAttr;
  begin
    Result := clOvcTableDefault;
    if (tcCellAttrCount > 0) then
      begin
        CellAttr := GetCellAttribute(FMatrix, RowNum, ColNum);
        if Assigned(CellAttr) then
          Result := CellAttr^.scaColor;
      end;
  end;
{--------}
function TOvcTableCells.GetFont(RowNum : TRowNum; ColNum : TColNum) : TFont;
  var
    CellAttr : POvcSparseAttr;
  begin
    Result := nil;
    if (tcCellAttrCount > 0) then
      begin
        CellAttr := GetCellAttribute(FMatrix, RowNum, ColNum);
        if Assigned(CellAttr) then
          Result := CellAttr^.scaFont;
      end;
  end;
{--------}
procedure TOvcTableCells.InsertCol(ColNum : TColNum);
  var
    LI : Integer;
  begin
    if (tcCellAttrCount > 0) then
      begin
        LI := ColNum;
        FMatrix.ForAll(InsCol, false, pointer(LI));
        tcDoCfgChanged;
      end;
  end;
{--------}
procedure TOvcTableCells.InsertRow(RowNum : TRowNum);
  begin
    if (tcCellAttrCount > 0) then
      begin
        FMatrix.Insert(RowNum, nil);
        tcDoCfgChanged;
      end;
  end;
{--------}
procedure TOvcTableCells.tcNotifyCellDeletion(Cell : TOvcBaseTableCell);
  begin
    if (tcCellAttrCount > 0) then
      FMatrix.ForAll(DelCellMajor, false, Cell);
  end;
{--------}
procedure TOvcTableCells.ResolveFullAttr(RowNum : TRowNum; ColNum : TColNum;
                                         var SCA : TOvcSparseAttr);
  var
    CellAttr : POvcSparseAttr;
  begin
    if (tcCellAttrCount = 0) then
      InitCellAttribute(SCA)
    else
      begin
        CellAttr := GetCellAttribute(FMatrix, RowNum, ColNum);
        if Assigned(CellAttr) then
          SCA := CellAttr^
        else
          InitCellAttribute(SCA);
      end;
  end;
{--------}
procedure TOvcTableCells.tcDoCfgChanged;
  begin
    if Assigned(FOnCfgChanged) then FOnCfgChanged(Self);
  end;
{--------}
procedure TOvcTableCells.ResetCell(RowNum : TRowNum; ColNum : TColNum);
  var
    CellAttr : POvcSparseAttr;
  begin
    if (tcCellAttrCount > 0) then
      begin
        CellAttr := GetCellAttribute(FMatrix, RowNum, ColNum);
        if Assigned(CellAttr) then
          begin
            DisposeCellAttribute(CellAttr);
            ResetCellAttribute(FMatrix, RowNum, ColNum);
            dec(tcCellAttrCount);
            tcDoCfgChanged;
          end;
      end;
  end;
{--------}
procedure TOvcTableCells.SetAccess(RowNum : TRowNum; ColNum : TColNum; A : TOvcTblAccess);
  var
    CellAttr : POvcSparseAttr;
  begin
    if (tcCellAttrCount = 0) then
      CellAttr := nil
    else
      CellAttr := GetCellAttribute(FMatrix, RowNum, ColNum);
    if not Assigned(CellAttr) then
      begin
        CellAttr := PutCellAttribute(FMatrix, RowNum, ColNum);
        inc(tcCellAttrCount);
      end;
    CellAttr^.scaAccess := A;
    if CellAttributeIsBlank(CellAttr) then
      begin
        DisposeCellAttribute(CellAttr);
        ResetCellAttribute(FMatrix, RowNum, ColNum);
        dec(tcCellAttrCount);
      end;
    tcDoCfgChanged;
  end;
{--------}
procedure TOvcTableCells.SetAdjust(RowNum : TRowNum; ColNum : TColNum; A : TOvcTblAdjust);
  var
    CellAttr : POvcSparseAttr;
  begin
    if (tcCellAttrCount = 0) then
      CellAttr := nil
    else
      CellAttr := GetCellAttribute(FMatrix, RowNum, ColNum);
    if not Assigned(CellAttr) then
      begin
        CellAttr := PutCellAttribute(FMatrix, RowNum, ColNum);
        inc(tcCellAttrCount);
      end;
    CellAttr^.scaAdjust := A;
    if CellAttributeIsBlank(CellAttr) then
      begin
        DisposeCellAttribute(CellAttr);
        ResetCellAttribute(FMatrix, RowNum, ColNum);
        dec(tcCellAttrCount);
      end;
    tcDoCfgChanged;
  end;
{--------}
procedure TOvcTableCells.SetCell(RowNum : TRowNum; ColNum : TColNum; BTC : TOvcBaseTableCell);
  var
    CellAttr    : POvcSparseAttr;
    DoIt        : boolean;
  begin
    DoIt := false;
    if Assigned(BTC) then
      begin
        if (BTC.References = 0) or
           ((BTC.References > 0) and (BTC.Table = FTable)) then
          DoIt := true;
      end
    else
      DoIt := true;

    if DoIt then
      begin
        if (tcCellAttrCount = 0) then
          CellAttr := nil
        else
          CellAttr := GetCellAttribute(FMatrix, RowNum, ColNum);
        if not Assigned(CellAttr) then
          begin
            CellAttr := PutCellAttribute(FMatrix, RowNum, ColNum);
            inc(tcCellAttrCount);
          end;
        if Assigned(CellAttr^.scaCell) then
          TOvcBaseTableCell(CellAttr^.scaCell).DecRefs;
        if Assigned(BTC) then
          begin
            if (BTC.References = 0) then
              BTC.Table := FTable;
            BTC.IncRefs;
          end;
        CellAttr^.scaCell := BTC;
        if CellAttributeIsBlank(CellAttr) then
          begin
            DisposeCellAttribute(CellAttr);
            ResetCellAttribute(FMatrix, RowNum, ColNum);
            dec(tcCellAttrCount);
          end;
        tcDoCfgChanged;
      end;
  end;
{--------}
procedure TOvcTableCells.SetColor(RowNum : TRowNum; ColNum : TColNum; C : TColor);
  var
    CellAttr : POvcSparseAttr;
  begin
    if (tcCellAttrCount = 0) then
      CellAttr := nil
    else
      CellAttr := GetCellAttribute(FMatrix, RowNum, ColNum);
    if not Assigned(CellAttr) then
      begin
        CellAttr := PutCellAttribute(FMatrix, RowNum, ColNum);
        inc(tcCellAttrCount);
      end;
    CellAttr^.scaColor := C;
    if CellAttributeIsBlank(CellAttr) then
      begin
        DisposeCellAttribute(CellAttr);
        ResetCellAttribute(FMatrix, RowNum, ColNum);
        dec(tcCellAttrCount);
      end;
    tcDoCfgChanged;
  end;
{--------}
procedure TOvcTableCells.SetFont(RowNum : TRowNum; ColNum : TColNum; F : TFont);
  var
    CellAttr : POvcSparseAttr;
  begin
    if (tcCellAttrCount = 0) then
      CellAttr := nil
    else
      CellAttr := GetCellAttribute(FMatrix, RowNum, ColNum);
    if not Assigned(CellAttr) then
      begin
        CellAttr := PutCellAttribute(FMatrix, RowNum, ColNum);
        inc(tcCellAttrCount);
      end;
    with CellAttr^ do
      begin
        if not Assigned(F) then
          begin
            scaFont.Free;
            scaFont := nil;
          end
        else
          begin
            if not Assigned(scaFont) then
              scaFont := TFont.Create;
            scaFont.Assign(F);
          end;
      end;
    if CellAttributeIsBlank(CellAttr) then
      begin
        DisposeCellAttribute(CellAttr);
        ResetCellAttribute(FMatrix, RowNum, ColNum);
        dec(tcCellAttrCount);
      end;
    tcDoCfgChanged;
  end;
{====================================================================}

end.
