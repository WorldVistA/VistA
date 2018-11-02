{*********************************************************}
{*              ovctcedtHTMLText.PAS 4.08                *}
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
{*   Sebastian Zierer                                                         *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit ovctcedtHTMLText;

interface

{$IFDEF WIN32}

uses
  Windows, SysUtils, Messages, Classes, Controls, Forms, StdCtrls,
  ComCtrls,
  OvcBase, OvcTCmmn, OvcTCell, OvcTCStr, ovctcedtTextFormatBar,
  Graphics, ovctcedt, ovcRTF_IText, ovcRTF_Paint; { - for default color definition}

type
  TOvcCustomHtmlTextEditBase = class(TRichEdit)
  private
    FAllowedFontStyles: TFontStyles;
    function GetRichText: string;
    procedure SetRichText(const Value: string);
    function GetHTMLTextFrom(Doc: ITextDocument): string;
    function GetHTMLText: string;
    procedure SetHTMLText(const Value: string);
    procedure SetAllowedFontStyles(const Value: TFontStyles);
    function GetPlainText: string;
  protected
    procedure KeyPress(var Key: Char); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure PasteRichtextFromClipboard;
  public
    constructor Create(AOwner: TComponent); override;
    property RichText: string read GetRichText write SetRichText;
    property HTMLText: string read GetHTMLText write SetHTMLText;
    property PlainText: string read GetPlainText;
    class procedure FillIDocument(const Doc: ITextDocument; HtmlText: string; InsertAtCurPos: Boolean; AFont: TFont = nil);
    function GetIDoc: ITextDocument;
  published
    property AllowedFontStyles: TFontStyles read FAllowedFontStyles write SetAllowedFontStyles default [fsBold, fsItalic, fsUnderline];
  end;

  TOvcCustomHtmlMemo = class(TOvcCustomHtmlTextEditBase)
  private
    FFormatBar: TOvcTextFormatBar;
  protected
    procedure WMKillFocus(var Msg : TWMKillFocus); message WM_KILLFOCUS;
    procedure WMSetFocus(var Msg : TWMSetFocus); message WM_SETFOCUS;
  public
    destructor Destroy; override;
  end;

  TOvcHtmlMemo = class(TOvcCustomHtmlMemo)
  published
    property Align;
    property Alignment;
    property Anchors;
    property BevelEdges;
    property BevelInner;
    property BevelKind default bkNone;
    property BevelOuter;
    property BiDiMode;
    property BorderStyle;
    property CharCase;
    property Color;
    property Constraints;
    property Ctl3D;
    property DoubleBuffered;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property ImeMode;
    property ImeName;
    property Lines;
    property MaxLength;
    property OEMConvert;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentDoubleBuffered;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ScrollBars;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Touch;
    property Visible;
    property WantReturns;
    property WantTabs;
    property WordWrap;
    property StyleElements;
    property OnChange;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGesture;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseActivate;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  TOvcTCHtmlTextEdit = class(TOvcCustomHtmlTextEditBase)
  protected {private}
    FCell : TOvcBaseTableCell;
  private
  protected
    procedure WMChar(var Msg : TWMKey); message WM_CHAR;
    procedure WMGetDlgCode(var Msg : TMessage); message WM_GETDLGCODE;
    procedure WMKeyDown(var Msg : TWMKey); message WM_KEYDOWN;
    procedure WMKillFocus(var Msg : TWMKillFocus); message WM_KILLFOCUS;
    procedure WMSetFocus(var Msg : TWMSetFocus); message WM_SETFOCUS;

    property CellOwner : TOvcBaseTableCell
       read FCell write FCell;
  public
  end;

  TOvcTCCustomHTMLText = class(TOvcTCBaseString)
  private
    FAllowedFontStyles: TFontStyles;
    FFormatBar: TOvcTextFormatBar;
    procedure SetAllowedFontStyles(const Value: TFontStyles);
  protected {private}
    FEdit        : TOvcTCHtmlTextEdit;
    FMaxLength   : word;
    FWantReturns : boolean;
    FWantTabs    : boolean;

  protected
    function GetCellEditor : TControl; override;
    function GetModified : boolean;

    property MaxLength : word
       read FMaxLength write FMaxLength;

    property WantReturns : boolean
       read FWantReturns write FWantReturns;

    property WantTabs : boolean
       read FWantTabs write FWantTabs;

    procedure tcPaint(TableCanvas : TCanvas;
                const CellRect    : TRect;
                      RowNum      : TRowNum;
                      ColNum      : TColNum;
                const CellAttr    : TOvcCellAttributes;
                      Data        : pointer); override;

    procedure tcPaintStrZ(TblCanvas : TCanvas;
                    const CellRect  : TRect;
                    const CellAttr  : TOvcCellAttributes;
                          StZ       : string); override;

  public
    constructor Create(AOwner : TComponent); override;
    function CreateEditControl(AOwner : TComponent) : TOvcTCHtmlTextEdit; virtual;

    function  EditHandle : THandle; override;
    procedure EditHide; override;
    procedure EditMove(CellRect : TRect); override;
    procedure SaveEditedData(Data : pointer); override;
    procedure StartEditing(RowNum : TRowNum; ColNum : TColNum;
                           CellRect : TRect;
                     const CellAttr : TOvcCellAttributes;
                           CellStyle: TOvcTblEditorStyle;
                           Data : pointer); override;
    procedure StopEditing(SaveValue : boolean;
                          Data : pointer); override;

    property Modified : boolean
       read GetModified;
    property AllowedFontStyles: TFontStyles read FAllowedFontStyles write SetAllowedFontStyles default [fsBold, fsItalic, fsUnderline];
  end;

  TOvcTCHTMLText = class(TOvcTCCustomHTMLText)
    published
      {properties inherited from custom ancestor}
      property Access default otxDefault;
      property Adjust default otaDefault;
      property Color;
      property DataStringType;
//      property EllipsisMode;
//      property Font;
      property Hint;
//      property IgnoreCR;
      property Margin default 4;
      property MaxLength default 0;
      property ShowHint default False;
      property Table;
      property TableColor default True;
      property TableFont default True;
      property TextHiColor default clBtnHighlight;
//      property TextStyle default tsFlat;
      { 07/2011 AUCOS-HKK: Reimplemented 'ASCIIZStrings' for backward compatibility }
      property UseASCIIZStrings;
      property UseWordWrap default True;
//      property WantReturns default False;
//      property WantTabs default False;
      property AllowedFontStyles;

      {events inherited from custom ancestor}
      property OnChange;
      property OnClick;
      property OnDblClick;
      property OnDragDrop;
      property OnDragOver;
      property OnEndDrag;
      property OnEnter;
      property OnExit;
      property OnKeyDown;
      property OnKeyPress;
      property OnKeyUp;
      property OnMouseDown;
      property OnMouseMove;
      property OnMouseUp;
      property OnOwnerDraw;
  end;

function StyleΔToHTML(Old, New: TFontStyles): string;

{$ENDIF}

implementation

{$IFDEF WIN32}

uses
  Types, Variants, RichEdit, ovcRTF_RichOle, ActiveX, ClipBrd,
  StrUtils;

function StyleΔToHTML(Old, New: TFontStyles): string;
var
  Removed: TFontStyles;
  Added: TFontStyles;
begin
  Result := '';
  Removed := Old - New;
  Added := New - Old;
  if fsBold in Added then
    Result := Result + '<b>';
  if fsItalic in Added then
    Result := Result + '<i>';
  if fsUnderline in Added then
    Result := Result + '<u>';

  if fsBold in Removed then
    Result := Result + '</b>';
  if fsItalic in Removed then
    Result := Result + '</i>';
  if fsUnderline in Removed then
    Result := Result + '</u>';
end;

{ TOvcTCHtmlTextEdit }

function Char2Html(C: Char): string;
begin
  case C of
    '<': Result := '&lt;';
    '>': Result := '&gt;';
    '&': Result := '&amp;';
    else
      Result := C;
  end;
end;

procedure TOvcTCHtmlTextEdit.WMChar(var Msg : TWMKey);
  begin
    if (not CellOwner.TableWantsTab) or
       (Msg.CharCode <> 9) then
      inherited;
  end;
{--------}
procedure TOvcTCHtmlTextEdit.WMGetDlgCode(var Msg : TMessage);
  begin
    inherited;
    if CellOwner.TableWantsTab then
      Msg.Result := Msg.Result or DLGC_WANTTAB;
  end;
{--------}
procedure TOvcTCHtmlTextEdit.WMKeyDown(var Msg : TWMKey);
  procedure GetSelection(var S, E : word);
    type
      LH = packed record L, H : word; end;
    var
      GetSel : NativeInt;
    begin
      GetSel := SendMessage(Handle, EM_GETSEL, 0, 0);
      S := LH(GetSel).L;
      E := LH(GetSel).H;
    end;
  var
    GridReply : TOvcTblKeyNeeds;
    GridUsedIt : boolean;
    SStart, SEnd : word;
  begin
    GridUsedIt := false;
    GridReply := otkDontCare;
    if (CellOwner <> nil) then
      GridReply := CellOwner.FilterTableKey(Msg);
    case GridReply of
      otkMustHave :
        begin
          CellOwner.SendKeyToTable(Msg);
          GridUsedIt := true;
        end;
      otkWouldLike :
        case Msg.CharCode of
          VK_RETURN :
            if not WantReturns then
              begin
                CellOwner.SendKeyToTable(Msg);
                GridUsedIt := true;
              end;
          VK_LEFT :
            begin
              GetSelection(SStart, SEnd);
              if (SStart = SEnd) and (SStart = 0) then
                begin
                  CellOwner.SendKeyToTable(Msg);
                  GridUsedIt := true;
                end;
            end;
          VK_RIGHT :
            begin
              GetSelection(SStart, SEnd);
              if ((SStart = SEnd) or (SStart = 0)) and (SEnd = GetTextLen) then
                begin
                  CellOwner.SendKeyToTable(Msg);
                  GridUsedIt := true;
                end;
            end;
        end;
    end;{case}

    if not GridUsedIt then
      inherited;
  end;
{--------}
procedure TOvcTCHtmlTextEdit.WMKillFocus(var Msg : TWMKillFocus);
  begin
    inherited;
    CellOwner.PostMessageToTable(ctim_KillFocus, Msg.FocusedWnd, 0);
  end;
{--------}
procedure TOvcTCHtmlTextEdit.WMSetFocus(var Msg : TWMSetFocus);
  begin
    inherited;
    CellOwner.PostMessageToTable(ctim_SetFocus, Msg.FocusedWnd, 0);
    if CellOwner is TOvcTCCustomHTMLText then
      if Assigned(TOvcTCCustomHTMLText(CellOwner).FFormatBar) then
        TOvcTCCustomHTMLText(CellOwner).FFormatBar.UpdatePosition;
  end;

{ TOvcTCCustomHTMLText }

constructor TOvcTCCustomHTMLText.Create(AOwner : TComponent);
  begin
    inherited Create(AOwner);
    UseWordWrap := true;
    AllowedFontStyles := [fsBold, fsItalic, fsUnderline];
  end;
{--------}
function TOvcTCCustomHTMLText.CreateEditControl(AOwner : TComponent) : TOvcTCHtmlTextEdit;
  begin
    Result := TOvcTCHtmlTextEdit.Create(AOwner);
  end;
{--------}
function TOvcTCCustomHTMLText.EditHandle : THandle;
  begin
    if Assigned(FEdit) then
      Result := FEdit.Handle
    else
      Result := 0;
  end;
{--------}
procedure TOvcTCCustomHTMLText.EditHide;
  begin
    if Assigned(FEdit) then
      with FEdit do
        begin
          SetWindowPos(FEdit.Handle, HWND_TOP,
                       0, 0, 0, 0,
                       SWP_HIDEWINDOW or SWP_NOREDRAW or SWP_NOZORDER);
        end;
  end;
{--------}
procedure TOvcTCCustomHTMLText.EditMove(CellRect : TRect);
  begin
    if Assigned(FEdit) then
      begin
        with CellRect do
          SetWindowPos(FEdit.Handle, HWND_TOP,
                       Left, Top, Right-Left, Bottom-Top,
                       SWP_SHOWWINDOW or SWP_NOREDRAW or SWP_NOZORDER);
        InvalidateRect(FEdit.Handle, nil, false);
        UpdateWindow(FEdit.Handle);
      end;
  end;
{--------}
function TOvcTCCustomHTMLText.GetCellEditor : TControl;
  begin
    Result := FEdit;
  end;
{--------}
function TOvcTCCustomHTMLText.GetModified : boolean;
  begin
    if Assigned(FEdit) then
         Result := FEdit.Modified
    else Result := false;
  end ;
{--------}
procedure TOvcTCCustomHTMLText.StartEditing(RowNum : TRowNum; ColNum : TColNum;
                                           CellRect : TRect;
                                     const CellAttr : TOvcCellAttributes;
                                           CellStyle: TOvcTblEditorStyle;
                                           Data : pointer);
  begin
    FEdit := CreateEditControl(FTable);
    FFormatBar := TOvcTextFormatBar.Create(Self);
    FFormatBar.AllowedFontStyles := AllowedFontStyles;

    FFormatBar.PopupParent := GetParentForm(FTable);
    FFormatBar.AttachedControl := FEdit;
//    FFormatBar.UpdatePosition; // called when edit receives focus

    with FEdit do
      begin
        Parent := FTable;
        Font := CellAttr.caFont;    // the font must be set before setting FEdit.HTMLText, otherwise formatting will be lost on start editing
        Font.Color := CellAttr.caFontColor;
        if Data=nil then
          Text := ''
        else case FDataStringType of
          tstShortString: FEdit.HTMLText := string(POvcShortString(Data)^);
          tstPChar:       FEdit.HTMLText := PChar(Data);
          tstString:      FEdit.HTMLText := PChar(PString(Data)^); // SetTextBuf(PChar(PString(Data)^))
        end;
        Color := CellAttr.caColor;
        MaxLength := Self.MaxLength;
        WantReturns := Self.WantReturns;
        WantTabs := Self.WantTabs;
        Left := CellRect.Left;
        Top := CellRect.Top;
        Width := CellRect.Right - CellRect.Left;
        Height := CellRect.Bottom - CellRect.Top;
        Visible := true;
        TabStop := false;
        CellOwner := Self;
        Hint := Self.Hint;
        ShowHint := Self.ShowHint;
        BorderStyle := bsNone;
        Ctl3D := false;
        case CellStyle of
          tesBorder : BorderStyle := bsSingle;
          tes3D     : Ctl3D := true;
        end;{case}
        AllowedFontStyles := Self.AllowedFontStyles;

        OnChange := Self.OnChange;
        OnClick := Self.OnClick;
        OnDblClick := Self.OnDblClick;
        OnDragDrop := Self.OnDragDrop;
        OnDragOver := Self.OnDragOver;
        OnEndDrag := Self.OnEndDrag;
        OnEnter := Self.OnEnter;
        OnExit := Self.OnExit;
        OnKeyDown := Self.OnKeyDown;
        OnKeyPress := Self.OnKeyPress;
        OnKeyUp := Self.OnKeyUp;
        OnMouseDown := Self.OnMouseDown;
        OnMouseMove := Self.OnMouseMove;
        OnMouseUp := Self.OnMouseUp;
      end;
  end;
{--------}

procedure TOvcTCCustomHTMLText.StopEditing(SaveValue : boolean; Data : pointer);
  {-Changes:
    04/2011, AB: UseASCIIZStrings/UsePString replaced by DataStringType }
  begin
    try
      FreeAndNil(FFormatBar);
      if SaveValue and Assigned(FEdit) and Assigned(Data) then
        case FDataStringType of
          tstShortString: POvcShortString(Data)^ := ShortString(Copy(FEdit.HTMLText, 1, MaxLength));
          tstPChar:       StrPLCopy(PChar(Data), FEdit.HTMLText, MaxLength+1);
          tstString:      PString(Data)^ := FEdit.HTMLText;
        end;
    finally
      FEdit.Free;
      FEdit := nil;
    end;
  end;

procedure TOvcTCCustomHTMLText.tcPaint(TableCanvas: TCanvas;
  const CellRect: TRect; RowNum: TRowNum; ColNum: TColNum;
  const CellAttr: TOvcCellAttributes; Data: pointer);
var
  sBuffer: string;
  Painter: TOvcRTFPainter;
  TextRect: TRect;
  State: Integer;
  Doc: ITextDocument;
  Font: TFont;
begin
  {if the cell is invisible or the passed data is nil and we're not
   designing, all's done}
  if (CellAttr.caAccess = otxInvisible) or
     ((Data = nil) and not (csDesigning in ComponentState)) then
  begin
    inherited tcPaint(TableCanvas, CellRect, RowNum, ColNum, CellAttr, Data);    {blank out the cell}
    Exit;
  end;

  if Data = nil then
    sBuffer := Format('%d:%d', [RowNum, ColNum])
  else
    case FDataStringType of
      tstShortString: sBuffer := string(POvcShortString(Data)^);
      tstPChar:       sBuffer := string(PChar(Data));
      tstString:      sBuffer := PString(Data)^;
    end;

  Painter := TOvcRTFPainter.Create;
  try
    Doc := Painter.GetDoc;  // must store GetDoc in a temporary variable so it can be set to nil before Painter.Free
    CellAttr.caFont.Color := CellAttr.caFontColor;
    Font := TFont.Create;
    try
      Font.Assign(CellAttr.caFont);
      Font.Color := CellAttr.caFontColor;
      TOvcTCHtmlTextEdit.FillIDocument(Doc, sBuffer, False, Font);
    finally
      Font.Free;
    end;
    Doc := nil;

    inherited tcPaint(TableCanvas, CellRect, RowNum, ColNum, CellAttr, Data);    {blank out the cell - must be done after loading the document to avoid flicker }
    TextRect := CellRect;
    TextRect.Left := TextRect.Left + 1;
    TextRect.Right := TextRect.Right - 1;
    State := SaveDC(TableCanvas.Handle);
    Painter.Draw(TableCanvas, TextRect, True, True);
    RestoreDC(TableCanvas.Handle, State);
  finally
    Painter.Free;
  end;
end;

procedure TOvcTCCustomHTMLText.tcPaintStrZ(TblCanvas: TCanvas;
  const CellRect: TRect; const CellAttr: TOvcCellAttributes; StZ: string);
begin
  // do nothing
end;

procedure TOvcTCCustomHTMLText.SaveEditedData(Data : pointer);
begin
  {stub out abstract method so BCB doesn't see this as an abstract class}
end;


procedure TOvcTCCustomHTMLText.SetAllowedFontStyles(const Value: TFontStyles);
begin
  FAllowedFontStyles := Value - [fsStrikeOut];
end;

{ TOvcCustomHtmlTextEditBase }

constructor TOvcCustomHtmlTextEditBase.Create(AOwner: TComponent);
begin
  inherited;
  AllowedFontStyles := [fsBold, fsItalic, fsUnderline];
end;

class procedure TOvcCustomHtmlTextEditBase.FillIDocument(
  const Doc: ITextDocument; HtmlText: string; InsertAtCurPos: Boolean; AFont: TFont);
var
  SB: TStringBuilder;
  State: (normal, html, specialchar);
  I: Integer;
  CurHtml: string;
  CurFontStyles: TFontStyles;
  CurText: string;

  procedure HtmlToFontStyle(var FS: TFontStyles; Html: string);
  begin
    if AnsiSameText(Html, 'b') then
      FS := FS + [fsBold]
    else if AnsiSameText(Html, 'i') then
      FS := FS + [fsItalic]
    else if AnsiSameText(Html, 'u') then
      FS := FS + [fsUnderline]

    else if AnsiSameText(Html, '/b') then
      FS := FS - [fsBold]
    else if AnsiSameText(Html, '/i') then
      FS := FS - [fsItalic]
    else if AnsiSameText(Html, '/u') then
      FS := FS - [fsUnderline];
  end;

  function SpecialCharToText(Html: string): string;
  begin
    if Html = 'gt' then
      Result := '>'
    else if Html = 'lt' then
      Result := '<'
    else if Html = 'amp' then
      Result := '&';
  end;

  procedure AddToRichText(S: string);
  begin
    if S = '' then
      Exit;

    Doc.Selection.Text := S;
    if Assigned(AFont) then
    begin
      Doc.Selection.Font.Name := AFont.Name;
      Doc.Selection.Font.Size := AFont.Size;
      if (AFont.Color <> clOvcTableDefault) and (AFont.Color <> clDefault) then
        Doc.Selection.Font.ForeColor := ColorToRGB(AFont.Color);
    end;
    Doc.Selection.Font.Bold := -Ord(fsBold in CurFontStyles);
    Doc.Selection.Font.Italic := -Ord(fsItalic in CurFontStyles);
    if fsUnderline in CurFontStyles then
      Doc.Selection.Font.Underline := tomSingle
    else
      Doc.Selection.Font.Underline := tomNone;
    Doc.Selection.Move(tomCharacter, 1);
  end;

begin
  HtmlText := AnsiReplaceText(HtmlText, #13#10, #13);
  Doc.Freeze;
  try
    if not InsertAtCurPos then
      Doc.New;
    SB := TStringBuilder.Create;
    try
      state := normal;
      CurHtml := '';
      CurFontStyles := [];
      CurText := '';
      for I := 1 to Length(HTMLText) do
      begin
        if state = normal then
          case HTMLText[I] of
            '<': begin State := html; CurHtml := ''; AddToRichText(CurText); CurText := ''; end;
            '&': state := specialchar;
            else CurText := CurText + HTMLText[I]; // AddToRichText(HTMLText[I]);
          end
        else if state = html then
        begin
          case HTMLText[I] of
            '>': begin state := normal; HtmlToFontStyle(CurFontStyles, CurHtml); CurHtml := ''; end;
            else
              CurHtml := CurHtml + HTMLText[I];
          end;
        end
        else if State = specialchar then
        begin
          case HTMLText[I] of
            ';': begin state := normal; CurText := CurText + SpecialCharToText(CurHtml); {AddToRichText(SpecialCharToText(CurHtml));} CurHtml := ''; end;
            else
              CurHtml := CurHtml + HTMLText[I];
          end;
        end;
      end;
      AddToRichText(CurText);
    finally
      SB.Free;
    end;
  finally
    Doc.Unfreeze;
  end;
end;

function TOvcCustomHtmlTextEditBase.GetHTMLText: string;
var
  ole: IRichEditOle;
  Doc: ITextDocument;
begin
  SendMessage(Handle, EM_GETOLEINTERFACE, 0, LPARAM(@ole));
  Doc := ole as ITextDocument;

  Result := GetHTMLTextFrom(Doc);
end;

function TOvcCustomHtmlTextEditBase.GetHTMLTextFrom(Doc: ITextDocument): string;
var
  StringBuilder: TStringBuilder;
  OldStyle, NewStyle: TFontStyles;

  Range: ITextRange;
  start, eof, n: Integer;
  Font: ITextFont;
  tmp: string;
begin
  // Get total length
  Range := Doc.Range(0, 0);
  Range.Expand(tomStory);
  eof := Range.End_;

  OldStyle := [];
  NewStyle := [];

  StringBuilder := TStringBuilder.Create;
  try
    start := 0;
    while start < eof - 1 do
    begin
      Range := Doc.Range(start, start);
      n := Range.Expand(tomCharFormat);
      Font := Range.Font;
      NewStyle := [];
      if (Font.Bold <> 0) and (fsBold in AllowedFontStyles) then
        Include(NewStyle, fsBold);
      if (Font.Italic <> 0) and (fsItalic in AllowedFontStyles) then
        Include(NewStyle, fsItalic);
      if (Font.Underline <> 0) and (fsUnderline in AllowedFontStyles) then
        Include(NewStyle, fsUnderline);

      StringBuilder.Append(StyleΔToHTML(OldStyle, NewStyle));
      tmp := Range.Text;
      tmp := AnsiReplaceText(tmp, '&', '&amp;');
      tmp := AnsiReplaceText(tmp, '<', '&lt;');
      tmp := AnsiReplaceText(tmp, '>', '&gt;');
      tmp := AnsiReplaceStr(tmp, #10, '');
      tmp := AnsiReplaceStr(tmp, #13, #13#10);
      StringBuilder.Append(tmp);
      OldStyle := NewStyle;
      Start := Start + n;
    end;
    Result := TrimRight(StringBuilder.ToString) + StyleΔToHTML(OldStyle, []);  // trim off #12 at the end (and other superfluous spaces)
  finally
    StringBuilder.Free;
  end;
end;

function TOvcCustomHtmlTextEditBase.GetIDoc: ITextDocument;
var
  ole: IRichEditOle;
begin
  SendMessage(Handle, EM_GETOLEINTERFACE, 0, LPARAM(@ole));
  Result := ole as ITextDocument;
end;

function TOvcCustomHtmlTextEditBase.GetPlainText: string;
var
  StringBuilder: TStringBuilder;
  ole: IRichEditOle;
  Doc: ITextDocument;
  Range: ITextRange;
  start, eof, n: Integer;
  tmp: string;
begin
  SendMessage(Handle, EM_GETOLEINTERFACE, 0, LPARAM(@ole));
  Doc := ole as ITextDocument;

  // Get total length
  Range := Doc.Range(0, 0);
  Range.Expand(tomStory);
  eof := Range.End_;

  StringBuilder := TStringBuilder.Create;
  try
    start := 0;
    while start < eof - 1 do
    begin
      Range := Doc.Range(start, start);
      n := Range.Expand(tomCharFormat);

      tmp := Range.Text;
      StringBuilder.Append(tmp);
      Start := Start + n;
    end;
    Result := TrimRight(StringBuilder.ToString);  // trim off #12 at the end (and other superfluous spaces)
  finally
    StringBuilder.Free;
  end;
end;

function TOvcCustomHtmlTextEditBase.GetRichText: string;
var
  MS: TMemoryStream;
begin
  MS := TMemoryStream.Create;
  try
    Lines.SaveToStream(MS, TEncoding.Unicode);
    MS.Position := 0;
    SetString(Result, PAnsiChar(MS.Memory), MS.Size);
  finally
    MS.Free;
  end;
end;

procedure TOvcCustomHtmlTextEditBase.KeyDown(var Key: Word; Shift: TShiftState);
// disable some shortcuts
begin
  if Shift = [ssCtrl] then
  begin
    case Chr(Key) of
      'J', 'L', 'E', 'R': Key := 0;
      '0'..'9': Key := 0;
      'V':
        if not ReadOnly then
        begin
          PasteRichTextFromClipboard;
//          tmp := Null;
//          Doc := GetIDoc;
//          if Clipboard.AsText <> '' then
//          begin    // clear formatting
//            GetIDoc.Selection.Text := Clipboard.AsText;
//            Doc.Selection.Move(tomCharacter, 1);
//          end;
          Key := 0;
        end;
    end;

    case Key of
      VK_OEM_PLUS: Key := 0;
    end;
  end;
  if Shift = [ssCtrl, ssShift] then
  begin
    case Key of
      Ord('A')..Ord('Z'): Key := 0;
      VK_OEM_PLUS: Key := 0;
    end;
  end;
  inherited;
end;

procedure TOvcCustomHtmlTextEditBase.KeyPress(var Key: Char);
var
  Doc: ITextDocument;
  // can't use Delphi FontStyles here because that changes all text styles of the selected text
begin
  if not ReadOnly then
  begin
    case Key of
      #2 {'B'}:
        if fsBold in AllowedFontStyles then
        begin
          Doc := GetIDoc;
          Doc.Selection.Font.Bold := Integer(tomToggle);
          Key := #0;
        end;
  //    #5: Key := #0;
      #9 {'I'}:
        if fsItalic in AllowedFontStyles then
        begin
          Doc := GetIDoc;
          Doc.Selection.Font.Italic := Integer(tomToggle);
          Key := #0;
        end;
  //    #10, #12, #18: Key := #0;
      #21 {'U'}:
        if fsUnderline in AllowedFontStyles then
        begin
          Doc := GetIDoc;
          if Doc.Selection.Font.Underline <> tomNone then
            Doc.Selection.Font.Underline := tomNone
          else
            Doc.Selection.Font.Underline := tomSingle;
          Key := #0;
        end;
    end;
  end;
  inherited;
end;

procedure TOvcCustomHtmlTextEditBase.PasteRichtextFromClipboard;
var
  Doc: ITextDocument;
  tmp: OleVariant;
  Painter: TOvcRTFPainter;
  tmpHTML: string;
  TargetDoc: ITextDocument;
begin
  // Paste richtext to the RTF Painter object (so we have a rtf doc that does not need to be in a visible control on the screen)
  Painter := TOvcRTFPainter.Create;
  try
    Doc := Painter.GetDoc;
    tmp := Null;
    Doc.Selection.Paste(tmp, 0);
    // Get as html in order to clear formatting that is not allowed
    tmpHtml := GetHTMLTextFrom(Doc);

    // Paste text
    TargetDoc := GetIDoc;
//    TargetDoc.Undo(tomSuspend); //SZ: this disables undo entirely - not good; BeginEditCollection is not implemented
    FillIDocument(TargetDoc, tmpHTML, True, Font);
//    TargetDoc.Undo(tomResume);
  finally
    Painter.Free;
  end;
end;

procedure TOvcCustomHtmlTextEditBase.SetAllowedFontStyles(
  const Value: TFontStyles);
begin
  FAllowedFontStyles := Value - [fsStrikeOut]; // fsStrikeOut not supported yet
end;

procedure TOvcCustomHtmlTextEditBase.SetHTMLText(const Value: string);
var
  ole: IRichEditOle;
  Doc: ITextDocument;
  LReadOnly: Boolean;
begin
  LReadOnly := ReadOnly;
  ReadOnly := False;
  try
    SendMessage(Handle, EM_GETOLEINTERFACE, 0, LPARAM(@ole));
    Doc := ole as ITextDocument;

    Doc.Freeze;
    FillIDocument(Doc, Value, False, Font);
    SelStart := 0;
    SelectAll;
    Doc.Unfreeze;
  finally
    ReadOnly := LReadOnly;
  end;
end;

procedure TOvcCustomHtmlTextEditBase.SetRichText(const Value: string);
var
  MS: TMemoryStream;
  AnsiStr: AnsiString;
begin
  MS := TMemoryStream.Create;
  try
    AnsiStr := AnsiString(Value);

    MS.Write(Pointer(AnsiStr)^, Length(AnsiStr));
    MS.Position := 0;
    Lines.LoadFromStream(MS, TEncoding.Unicode);
  finally
    MS.Free;
  end;
end;

{ TOvcCustomHtmlMemo }

destructor TOvcCustomHtmlMemo.Destroy;
begin
  FreeAndNil(FFormatBar);
  inherited;
end;

procedure TOvcCustomHtmlMemo.WMKillFocus(var Msg: TWMKillFocus);
begin
  inherited;
  FreeAndNil(FFormatBar);
end;

procedure TOvcCustomHtmlMemo.WMSetFocus(var Msg: TWMSetFocus);
var
  Form: TCustomForm;
begin
  inherited;

  if ReadOnly then
    Exit;

  Form := GetParentForm(Self);
  if Form = nil then
    Exit;

  FFormatBar := TOvcTextFormatBar.Create(Self);
  FFormatBar.AllowedFontStyles := AllowedFontStyles;

  FFormatBar.PopupParent := Form;
  FFormatBar.AttachedControl := Self;
  FFormatBar.UpdatePosition;
end;

{$ENDIF}

end.
