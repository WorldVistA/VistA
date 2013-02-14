{ **************************************************************
	Package: XWB - Kernel RPCBroker
	Date Created: Sept 18, 1997 (Version 1.1)
	Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
	Developers: Joel Ivey
	Description: Provides a RichEdit Component with ability
	             to recognize a URL within the RichEdit control.
	Current Release: Version 1.1 Patch 47 (Jun. 17, 2008))
*************************************************************** }
{: Unit XWBRich20
   Based on the article "Detect URLS in the RichEdit Control" by
   Elias J. Ongpoy in 'Delphi Developer Newsletter', May 2001
   which incorporates the functionality of the Microsoft Rich Edit
   Control 2.0 from RichEd20.DLL which incorporates the ability to
   recognize a URL within the RichEdit control.
}

unit XWBRich20;
interface
uses Messages, Windows, SysUtils, Classes, Controls, Forms,
  Menus, Graphics, StdCtrls, RichEdit, ToolWin, ImgList, ExtCtrls, ComCtrls;

type
  TXWBCustomRichEdit = class;

  TAttributeType = (atSelected, atDefaultText);
  TConsistentAttribute = (caBold, caColor, caFace, caItalic,
    caSize, caStrikeOut, caUnderline, caProtected);
  TConsistentAttributes = set of TConsistentAttribute;

  TXWBTextAttributes = class(TPersistent)
  private
    RichEdit: TXWBCustomRichEdit;
    FType: TAttributeType;
    procedure GetAttributes(var Format: TCharFormat);
    function GetCharset: TFontCharset;
    function GetColor: TColor;
    function GetConsistentAttributes: TConsistentAttributes;
    function GetHeight: Integer;
    function GetName: TFontName;
    function GetPitch: TFontPitch;
    function GetProtected: Boolean;
    function GetSize: Integer;
    function GetStyle: TFontStyles;
    procedure SetAttributes(var Format: TCharFormat);
    procedure SetCharset(Value: TFontCharset);
    procedure SetColor(Value: TColor);
    procedure SetHeight(Value: Integer);
    procedure SetName(Value: TFontName);
    procedure SetPitch(Value: TFontPitch);
    procedure SetProtected(Value: Boolean);
    procedure SetSize(Value: Integer);
    procedure SetStyle(Value: TFontStyles);
  protected
    procedure InitFormat(var Format: TCharFormat);
    procedure AssignTo(Dest: TPersistent); override;
  public
    constructor Create(AOwner: TXWBCustomRichEdit; AttributeType: TAttributeType);
    procedure Assign(Source: TPersistent); override;
    property Charset: TFontCharset read GetCharset write SetCharset;
    property Color: TColor read GetColor write SetColor;
    property ConsistentAttributes: TConsistentAttributes read GetConsistentAttributes;
    property Name: TFontName read GetName write SetName;
    property Pitch: TFontPitch read GetPitch write SetPitch;
    property Protected: Boolean read GetProtected write SetProtected;
    property Size: Integer read GetSize write SetSize;
    property Style: TFontStyles read GetStyle write SetStyle;
    property Height: Integer read GetHeight write SetHeight;
  end;

{ TParaAttributes }

  TNumberingStyle = (nsNone, nsBullet);

  TParaAttributes = class(TPersistent)
  private
    RichEdit: TXWBCustomRichEdit;
    procedure GetAttributes(var Paragraph: TParaFormat);
    function GetAlignment: TAlignment;
    function GetFirstIndent: Longint;
    function GetLeftIndent: Longint;
    function GetRightIndent: Longint;
    function GetNumbering: TNumberingStyle;
    function GetTab(Index: Byte): Longint;
    function GetTabCount: Integer;
    procedure InitPara(var Paragraph: TParaFormat);
    procedure SetAlignment(Value: TAlignment);
    procedure SetAttributes(var Paragraph: TParaFormat);
    procedure SetFirstIndent(Value: Longint);
    procedure SetLeftIndent(Value: Longint);
    procedure SetRightIndent(Value: Longint);
    procedure SetNumbering(Value: TNumberingStyle);
    procedure SetTab(Index: Byte; Value: Longint);
    procedure SetTabCount(Value: Integer);
  public
    constructor Create(AOwner: TXWBCustomRichEdit);
    procedure Assign(Source: TPersistent); override;
    property Alignment: TAlignment read GetAlignment write SetAlignment;
    property FirstIndent: Longint read GetFirstIndent write SetFirstIndent;
    property LeftIndent: Longint read GetLeftIndent write SetLeftIndent;
    property Numbering: TNumberingStyle read GetNumbering write SetNumbering;
    property RightIndent: Longint read GetRightIndent write SetRightIndent;
    property Tab[Index: Byte]: Longint read GetTab write SetTab;
    property TabCount: Integer read GetTabCount write SetTabCount;
  end;

{ TXWBCustomRichEdit }

  TRichEditResizeEvent = procedure(Sender: TObject; Rect: TRect) of object;
  TRichEditProtectChange = procedure(Sender: TObject;
    StartPos, EndPos: Integer; var AllowChange: Boolean) of object;
  TRichEditSaveClipboard = procedure(Sender: TObject;
    NumObjects, NumChars: Integer; var SaveClipboard: Boolean) of object;
  TSearchType = (stWholeWord, stMatchCase);
  TSearchTypes = set of TSearchType;

  TConversion = class(TObject)
  public
    function ConvertReadStream(Stream: TStream; Buffer: PChar; BufSize: Integer): Integer; virtual;
    function ConvertWriteStream(Stream: TStream; Buffer: PChar; BufSize: Integer): Integer; virtual;
  end;

  TConversionClass = class of TConversion;

  PConversionFormat = ^TConversionFormat;
  TConversionFormat = record
    ConversionClass: TConversionClass;
    Extension: string;
    Next: PConversionFormat;
  end;

  PRichEditStreamInfo = ^TRichEditStreamInfo;
  TRichEditStreamInfo = record
    Converter: TConversion;
    Stream: TStream;
  end;

  TXWBCustomRichEdit = class(TCustomMemo)
  private
    FHideScrollBars: Boolean;
    FSelAttributes: TXWBTextAttributes;
    FDefAttributes: TXWBTextAttributes;
    FParagraph: TParaAttributes;
    FOldParaAlignment: TAlignment;
    FScreenLogPixels: Integer;
    FRichEditStrings: TStrings;
    FMemStream: TMemoryStream;
    FOnSelChange: TNotifyEvent;

    FHideSelection: Boolean;
    FURLDetect: Boolean;      // for URL Detect Property

    FModified: Boolean;
    FDefaultConverter: TConversionClass;
    FOnResizeRequest: TRichEditResizeEvent;
    FOnProtectChange: TRichEditProtectChange;
    FOnSaveClipboard: TRichEditSaveClipboard;
    FPageRect: TRect;

    procedure CMBiDiModeChanged(var Message: TMessage); message CM_BIDIMODECHANGED;
    procedure CMColorChanged(var Message: TMessage); message CM_COLORCHANGED;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CNNotify(var Message: TWMNotify); message CN_NOTIFY;
    function GetPlainText: Boolean;
    function ProtectChange(StartPos, EndPos: Integer): Boolean;
    function SaveClipboard(NumObj, NumChars: Integer): Boolean;
    procedure SetHideScrollBars(Value: Boolean);
    procedure SetHideSelection(Value: Boolean);
    procedure SetURLDetect(Value: boolean);
    
    procedure SetPlainText(Value: Boolean);
    procedure SetRichEditStrings(Value: TStrings);
    procedure SetDefAttributes(Value: TXWBTextAttributes);
    procedure SetSelAttributes(Value: TXWBTextAttributes);
    procedure WMNCDestroy(var Message: TWMNCDestroy); message WM_NCDESTROY;
    procedure WMSetCursor(var Message: TWMSetCursor); message WM_SETCURSOR;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure WMSetFont(var Message: TWMSetFont); message WM_SETFONT;
    procedure WMRButtonUp(var Message: TWMRButtonUp); message WM_RBUTTONUP;

  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    procedure RequestSize(const Rect: TRect); virtual;
    procedure SelectionChange; dynamic;
    procedure DoSetMaxLength(Value: Integer); override;
    function GetCaretPos: TPoint; override;
    function GetSelLength: Integer; override;
    function GetSelStart: Integer; override;
    function GetSelText: string; override;
    procedure SetSelLength(Value: Integer); override;
    procedure SetSelStart(Value: Integer); override;
    property HideSelection: Boolean read FHideSelection write SetHideSelection default True;
    
// New Property - URL Detect
    property URLDetect : boolean read FURLDetect write SetURLDetect default FALSE;

    property HideScrollBars: Boolean read FHideScrollBars
      write SetHideScrollBars default True;
    property Lines: TStrings read FRichEditStrings write SetRichEditStrings;
    property OnSaveClipboard: TRichEditSaveClipboard read FOnSaveClipboard
      write FOnSaveClipboard;
    property OnSelectionChange: TNotifyEvent read FOnSelChange write FOnSelChange;
    property OnProtectChange: TRichEditProtectChange read FOnProtectChange
      write FOnProtectChange;
    property OnResizeRequest: TRichEditResizeEvent read FOnResizeRequest
      write FOnResizeRequest;
    property PlainText: Boolean read GetPlainText write SetPlainText default False;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear; override;
    function FindText(const SearchStr: string;
      StartPos, Length: Integer; Options: TSearchTypes): Integer;
    function GetSelTextBuf(Buffer: PChar; BufSize: Integer): Integer; override;
    procedure Print(const Caption: string); virtual;
    class procedure RegisterConversionFormat(const AExtension: string;
      AConversionClass: TConversionClass);
    property DefaultConverter: TConversionClass
      read FDefaultConverter write FDefaultConverter;
    property DefAttributes: TXWBTextAttributes read FDefAttributes write SetDefAttributes;
    property SelAttributes: TXWBTextAttributes read FSelAttributes write SetSelAttributes;
    property PageRect: TRect read FPageRect write FPageRect;
    property Paragraph: TParaAttributes read FParagraph;
  end;

  TXWBRichEdit = class(TXWBCustomRichEdit)
  published
    property Align;
    property Alignment;
    property Anchors;
    property BiDiMode;
    property BorderStyle;
    property BorderWidth;
    property Color;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property URLDetect;            // New URL Detect property
    property HideScrollBars;
    property ImeMode;
    property ImeName;
    property Constraints;
    property Lines;
    property MaxLength;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PlainText;
    property PopupMenu;
    property ReadOnly;
    property ScrollBars;
    property ShowHint;
    property TabOrder;
    property TabStop default True;

    property Visible;
    property WantTabs;
    property WantReturns;
    property WordWrap;
    property OnChange;
//    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnProtectChange;
    property OnResizeRequest;
    property OnSaveClipboard;
    property OnSelectionChange;
    property OnStartDock;
    property OnStartDrag;
  end;

implementation

uses Printers, Consts, ComStrs, ActnList, StdActns, ShellAPI;

type
  PFontHandles = ^TFontHandles;
  TFontHandles = record
    OurFont,
    StockFont: Integer;
  end;

  const
  SectionSizeArea = 8;
  RTFConversionFormat: TConversionFormat = (
    ConversionClass: TConversion;
    Extension: 'rtf';
    Next: nil);
  TextConversionFormat: TConversionFormat = (
    ConversionClass: TConversion;
    Extension: 'txt';
    Next: @RTFConversionFormat);

var
  ConversionFormatList: PConversionFormat = @TextConversionFormat;
  FRichEditModule: THandle;

{ TXWBTextAttributes }

constructor TXWBTextAttributes.Create(AOwner: TXWBCustomRichEdit;
  AttributeType: TAttributeType);
begin
  inherited Create;
  RichEdit := AOwner;
  FType := AttributeType;
end;

procedure TXWBTextAttributes.InitFormat(var Format: TCharFormat);
begin
  FillChar(Format, SizeOf(TCharFormat), 0);
  Format.cbSize := SizeOf(TCharFormat);
end;

function TXWBTextAttributes.GetConsistentAttributes: TConsistentAttributes;
var
  Format: TCharFormat;
begin
  Result := [];
  if RichEdit.HandleAllocated and (FType = atSelected) then
  begin
    InitFormat(Format);
    SendMessage(RichEdit.Handle, EM_GETCHARFORMAT,
      WPARAM(FType = atSelected), LPARAM(@Format));
    with Format do
    begin
      if (dwMask and CFM_BOLD) <> 0 then Include(Result, caBold);
      if (dwMask and CFM_COLOR) <> 0 then Include(Result, caColor);
      if (dwMask and CFM_FACE) <> 0 then Include(Result, caFace);
      if (dwMask and CFM_ITALIC) <> 0 then Include(Result, caItalic);
      if (dwMask and CFM_SIZE) <> 0 then Include(Result, caSize);
      if (dwMask and CFM_STRIKEOUT) <> 0 then Include(Result, caStrikeOut);
      if (dwMask and CFM_UNDERLINE) <> 0 then Include(Result, caUnderline);
      if (dwMask and CFM_PROTECTED) <> 0 then Include(Result, caProtected);
    end;
  end;
end;

procedure TXWBTextAttributes.GetAttributes(var Format: TCharFormat);
begin
  InitFormat(Format);
  if RichEdit.HandleAllocated then
    SendMessage(RichEdit.Handle, EM_GETCHARFORMAT,
      WPARAM(FType = atSelected), LPARAM(@Format));
end;

procedure TXWBTextAttributes.SetAttributes(var Format: TCharFormat);
var
  Flag: Longint;
begin
  if FType = atSelected then Flag := SCF_SELECTION
  else Flag := 0;
  if RichEdit.HandleAllocated then
    SendMessage(RichEdit.Handle, EM_SETCHARFORMAT, Flag, LPARAM(@Format))
end;

function TXWBTextAttributes.GetCharset: TFontCharset;
var
  Format: TCharFormat;
begin
  GetAttributes(Format);
  Result := Format.bCharset;
end;

procedure TXWBTextAttributes.SetCharset(Value: TFontCharset);
var
  Format: TCharFormat;
begin
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_CHARSET;
    bCharSet := Value;
  end;
  SetAttributes(Format);
end;

function TXWBTextAttributes.GetProtected: Boolean;
var
  Format: TCharFormat;
begin
  GetAttributes(Format);
  with Format do
    if (dwEffects and CFE_PROTECTED) <> 0 then
      Result := True else
      Result := False;
end;

procedure TXWBTextAttributes.SetProtected(Value: Boolean);
var
  Format: TCharFormat;
begin
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_PROTECTED;
    if Value then dwEffects := CFE_PROTECTED;
  end;
  SetAttributes(Format);
end;

function TXWBTextAttributes.GetColor: TColor;
var
  Format: TCharFormat;
begin
  GetAttributes(Format);
  with Format do
    if (dwEffects and CFE_AUTOCOLOR) <> 0 then
      Result := clWindowText else
      Result := crTextColor;
end;

procedure TXWBTextAttributes.SetColor(Value: TColor);
var
  Format: TCharFormat;
begin
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_COLOR;
    if Value = clWindowText then
      dwEffects := CFE_AUTOCOLOR else
      crTextColor := ColorToRGB(Value);
  end;
  SetAttributes(Format);
end;

function TXWBTextAttributes.GetName: TFontName;
var
  Format: TCharFormat;
begin
  GetAttributes(Format);
  Result := Format.szFaceName;
end;

procedure TXWBTextAttributes.SetName(Value: TFontName);
var
  Format: TCharFormat;
begin
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_FACE;
    StrPLCopy(szFaceName, Value, SizeOf(szFaceName));
  end;
  SetAttributes(Format);
end;

function TXWBTextAttributes.GetStyle: TFontStyles;
var
  Format: TCharFormat;
begin
  Result := [];
  GetAttributes(Format);
  with Format do
  begin
    if (dwEffects and CFE_BOLD) <> 0 then Include(Result, fsBold);
    if (dwEffects and CFE_ITALIC) <> 0 then Include(Result, fsItalic);
    if (dwEffects and CFE_UNDERLINE) <> 0 then Include(Result, fsUnderline);
    if (dwEffects and CFE_STRIKEOUT) <> 0 then Include(Result, fsStrikeOut);
  end;
end;

procedure TXWBTextAttributes.SetStyle(Value: TFontStyles);
var
  Format: TCharFormat;
begin
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_BOLD or CFM_ITALIC or CFM_UNDERLINE or CFM_STRIKEOUT;
    if fsBold in Value then dwEffects := dwEffects or CFE_BOLD;
    if fsItalic in Value then dwEffects := dwEffects or CFE_ITALIC;
    if fsUnderline in Value then dwEffects := dwEffects or CFE_UNDERLINE;
    if fsStrikeOut in Value then dwEffects := dwEffects or CFE_STRIKEOUT;
  end;

  SetAttributes(Format);
end;

function TXWBTextAttributes.GetSize: Integer;
var
  Format: TCharFormat;
begin
  GetAttributes(Format);
  Result := Format.yHeight div 20;
end;

procedure TXWBTextAttributes.SetSize(Value: Integer);
var
  Format: TCharFormat;
begin
  InitFormat(Format);
  with Format do
  begin
    dwMask := Integer(CFM_SIZE);
    yHeight := Value * 20;
  end;
  SetAttributes(Format);
end;

function TXWBTextAttributes.GetHeight: Integer;
begin
  Result := MulDiv(Size, RichEdit.FScreenLogPixels, 72);
end;

procedure TXWBTextAttributes.SetHeight(Value: Integer);
begin
  Size := MulDiv(Value, 72, RichEdit.FScreenLogPixels);
end;

function TXWBTextAttributes.GetPitch: TFontPitch;
var
  Format: TCharFormat;
begin
  GetAttributes(Format);
  case (Format.bPitchAndFamily and $03) of
    DEFAULT_PITCH: Result := fpDefault;
    VARIABLE_PITCH: Result := fpVariable;
    FIXED_PITCH: Result := fpFixed;
  else
    Result := fpDefault;
  end;
end;

procedure TXWBTextAttributes.SetPitch(Value: TFontPitch);
var
  Format: TCharFormat;
begin
  InitFormat(Format);
  with Format do
  begin
    case Value of
      fpVariable: Format.bPitchAndFamily := VARIABLE_PITCH;
      fpFixed: Format.bPitchAndFamily := FIXED_PITCH;
    else
      Format.bPitchAndFamily := DEFAULT_PITCH;
    end;
  end;
  SetAttributes(Format);
end;

procedure TXWBTextAttributes.Assign(Source: TPersistent);
begin
  if Source is TFont then
  begin
    Color := TFont(Source).Color;
    Name := TFont(Source).Name;
    Charset := TFont(Source).Charset;
    Style := TFont(Source).Style;
    Size := TFont(Source).Size;
    Pitch := TFont(Source).Pitch;
  end
  else if Source is TXWBTextAttributes then
  begin
    Color := TXWBTextAttributes(Source).Color;
    Name := TXWBTextAttributes(Source).Name;
    Charset := TXWBTextAttributes(Source).Charset;
    Style := TXWBTextAttributes(Source).Style;
    Pitch := TXWBTextAttributes(Source).Pitch;
  end
  else inherited Assign(Source);
end;

procedure TXWBTextAttributes.AssignTo(Dest: TPersistent);
begin
  if Dest is TFont then
  begin
    TFont(Dest).Color := Color;
    TFont(Dest).Name := Name;
    TFont(Dest).Charset := Charset;
    TFont(Dest).Style := Style;
    TFont(Dest).Size := Size;
    TFont(Dest).Pitch := Pitch;
  end
  else if Dest is TXWBTextAttributes then
  begin
    TXWBTextAttributes(Dest).Color := Color;
    TXWBTextAttributes(Dest).Name := Name;
    TXWBTextAttributes(Dest).Charset := Charset;
    TXWBTextAttributes(Dest).Style := Style;
    TXWBTextAttributes(Dest).Pitch := Pitch;
  end
  else inherited AssignTo(Dest);
end;

{ TParaAttributes }

constructor TParaAttributes.Create(AOwner: TXWBCustomRichEdit);
begin
  inherited Create;
  RichEdit := AOwner;
end;

procedure TParaAttributes.InitPara(var Paragraph: TParaFormat);
begin
  FillChar(Paragraph, SizeOf(TParaFormat), 0);
  Paragraph.cbSize := SizeOf(TParaFormat);
end;

procedure TParaAttributes.GetAttributes(var Paragraph: TParaFormat);
begin
  InitPara(Paragraph);
  if RichEdit.HandleAllocated then
    SendMessage(RichEdit.Handle, EM_GETPARAFORMAT, 0, LPARAM(@Paragraph));
end;

procedure TParaAttributes.SetAttributes(var Paragraph: TParaFormat);
begin
  RichEdit.HandleNeeded; { we REALLY need the handle for BiDi }
  if RichEdit.HandleAllocated then
  begin
    if RichEdit.UseRightToLeftAlignment then
      if Paragraph.wAlignment = PFA_LEFT then
        Paragraph.wAlignment := PFA_RIGHT
      else if Paragraph.wAlignment = PFA_RIGHT then
        Paragraph.wAlignment := PFA_LEFT;
    SendMessage(RichEdit.Handle, EM_SETPARAFORMAT, 0, LPARAM(@Paragraph));
  end;
end;

function TParaAttributes.GetAlignment: TAlignment;
var
  Paragraph: TParaFormat;
begin
  GetAttributes(Paragraph);
  Result := TAlignment(Paragraph.wAlignment - 1);
end;

procedure TParaAttributes.SetAlignment(Value: TAlignment);
var
  Paragraph: TParaFormat;
begin
  InitPara(Paragraph);
  with Paragraph do
  begin
    dwMask := PFM_ALIGNMENT;
    wAlignment := Ord(Value) + 1;
  end;
  SetAttributes(Paragraph);
end;

function TParaAttributes.GetNumbering: TNumberingStyle;
var
  Paragraph: TParaFormat;
begin
  GetAttributes(Paragraph);
  Result := TNumberingStyle(Paragraph.wNumbering);
end;

procedure TParaAttributes.SetNumbering(Value: TNumberingStyle);
var
  Paragraph: TParaFormat;
begin
  case Value of
    nsBullet: if LeftIndent < 10 then LeftIndent := 10;
    nsNone: LeftIndent := 0;
  end;
  InitPara(Paragraph);
  with Paragraph do
  begin
    dwMask := PFM_NUMBERING;
    wNumbering := Ord(Value);
  end;
  SetAttributes(Paragraph);
end;

function TParaAttributes.GetFirstIndent: Longint;
var
  Paragraph: TParaFormat;
begin
  GetAttributes(Paragraph);
  Result := Paragraph.dxStartIndent div 20
end;

procedure TParaAttributes.SetFirstIndent(Value: Longint);
var
  Paragraph: TParaFormat;
begin
  InitPara(Paragraph);
  with Paragraph do
  begin
    dwMask := PFM_STARTINDENT;
    dxStartIndent := Value * 20;
  end;
  SetAttributes(Paragraph);
end;

function TParaAttributes.GetLeftIndent: Longint;
var
  Paragraph: TParaFormat;
begin
  GetAttributes(Paragraph);
  Result := Paragraph.dxOffset div 20;
end;

procedure TParaAttributes.SetLeftIndent(Value: Longint);
var
  Paragraph: TParaFormat;
begin
  InitPara(Paragraph);
  with Paragraph do
  begin
    dwMask := PFM_OFFSET;
    dxOffset := Value * 20;
  end;
  SetAttributes(Paragraph);
end;

function TParaAttributes.GetRightIndent: Longint;
var
  Paragraph: TParaFormat;
begin
  GetAttributes(Paragraph);
  Result := Paragraph.dxRightIndent div 20;
end;

procedure TParaAttributes.SetRightIndent(Value: Longint);
var
  Paragraph: TParaFormat;
begin
  InitPara(Paragraph);
  with Paragraph do
  begin
    dwMask := PFM_RIGHTINDENT;
    dxRightIndent := Value * 20;
  end;
  SetAttributes(Paragraph);
end;

function TParaAttributes.GetTab(Index: Byte): Longint;
var
  Paragraph: TParaFormat;
begin
  GetAttributes(Paragraph);
  Result := Paragraph.rgxTabs[Index] div 20;
end;

procedure TParaAttributes.SetTab(Index: Byte; Value: Longint);
var
  Paragraph: TParaFormat;
begin
  GetAttributes(Paragraph);
  with Paragraph do
  begin
    rgxTabs[Index] := Value * 20;
    dwMask := PFM_TABSTOPS;
    if cTabCount < Index then cTabCount := Index;
    SetAttributes(Paragraph);
  end;
end;

function TParaAttributes.GetTabCount: Integer;
var
  Paragraph: TParaFormat;
begin
  GetAttributes(Paragraph);
  Result := Paragraph.cTabCount;
end;

procedure TParaAttributes.SetTabCount(Value: Integer);
var
  Paragraph: TParaFormat;
begin
  GetAttributes(Paragraph);
  with Paragraph do
  begin
    dwMask := PFM_TABSTOPS;
    cTabCount := Value;
    SetAttributes(Paragraph);
  end;
end;

procedure TParaAttributes.Assign(Source: TPersistent);
var
  I: Integer;
begin
  if Source is TParaAttributes then
  begin
    Alignment := TParaAttributes(Source).Alignment;
    FirstIndent := TParaAttributes(Source).FirstIndent;
    LeftIndent := TParaAttributes(Source).LeftIndent;
    RightIndent := TParaAttributes(Source).RightIndent;
    Numbering := TParaAttributes(Source).Numbering;
    for I := 0 to MAX_TAB_STOPS - 1 do
      Tab[I] := TParaAttributes(Source).Tab[I];
  end
  else inherited Assign(Source);
end;

{ TConversion }

function TConversion.ConvertReadStream(Stream: TStream; Buffer: PChar; BufSize: Integer): Integer;
begin
  Result := Stream.Read(Buffer^, BufSize);
end;

function TConversion.ConvertWriteStream(Stream: TStream; Buffer: PChar; BufSize: Integer): Integer;
begin
  Result := Stream.Write(Buffer^, BufSize);
end;

{ TRichEditStrings }

const
  ReadError = $0001;
  WriteError = $0002;
  NoError = $0000;

type
  TSelection = record
    StartPos, EndPos: Integer;
  end;

  TRichEditStrings = class(TStrings)
  private
    RichEdit: TXWBCustomRichEdit;
    FPlainText: Boolean;
    FConverter: TConversion;
    procedure EnableChange(const Value: Boolean);
  protected
    function Get(Index: Integer): string; override;
    function GetCount: Integer; override;
    procedure Put(Index: Integer; const S: string); override;
    procedure SetUpdateState(Updating: Boolean); override;
    procedure SetTextStr(const Value: string); override;
  public
    destructor Destroy; override;
    procedure Clear; override;
    procedure AddStrings(Strings: TStrings); override;
    procedure Delete(Index: Integer); override;
    procedure Insert(Index: Integer; const S: string); override;
    procedure LoadFromFile(const FileName: string); override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToFile(const FileName: string); override;
    procedure SaveToStream(Stream: TStream); override;
    property PlainText: Boolean read FPlainText write FPlainText;
  end;

destructor TRichEditStrings.Destroy;
begin
  FConverter.Free;
  inherited Destroy;
end;

procedure TRichEditStrings.AddStrings(Strings: TStrings);
var
  SelChange: TNotifyEvent;
begin
  SelChange := RichEdit.OnSelectionChange;
  RichEdit.OnSelectionChange := nil;
  try
    inherited AddStrings(Strings);
  finally
    RichEdit.OnSelectionChange := SelChange;
  end;
end;

function TRichEditStrings.GetCount: Integer;
begin
  Result := SendMessage(RichEdit.Handle, EM_GETLINECOUNT, 0, 0);
  if SendMessage(RichEdit.Handle, EM_LINELENGTH, SendMessage(RichEdit.Handle,
    EM_LINEINDEX, Result - 1, 0), 0) = 0 then Dec(Result);
end;

function TRichEditStrings.Get(Index: Integer): string;
var
  Text: array[0..4095] of Char;
  L: Integer;
begin
  Word((@Text)^) := SizeOf(Text);
  L := SendMessage(RichEdit.Handle, EM_GETLINE, Index, Longint(@Text));
  if (Text[L - 2] = #13) and (Text[L - 1] = #10) then Dec(L, 2);
  SetString(Result, Text, L);
end;

procedure TRichEditStrings.Put(Index: Integer; const S: string);
var
  Selection: TCharRange;
begin
  if Index >= 0 then
  begin
    Selection.cpMin := SendMessage(RichEdit.Handle, EM_LINEINDEX, Index, 0);
    if Selection.cpMin <> -1 then
    begin
      Selection.cpMax := Selection.cpMin +
        SendMessage(RichEdit.Handle, EM_LINELENGTH, Selection.cpMin, 0);
      SendMessage(RichEdit.Handle, EM_EXSETSEL, 0, Longint(@Selection));
      SendMessage(RichEdit.Handle, EM_REPLACESEL, 0, Longint(PChar(S)));
    end;
  end;
end;

procedure TRichEditStrings.Insert(Index: Integer; const S: string);
var
  L: Integer;
  Selection: TCharRange;
  Fmt: PChar;
  Str: string;
begin
  if Index >= 0 then
  begin
    Selection.cpMin := SendMessage(RichEdit.Handle, EM_LINEINDEX, Index, 0);
    if Selection.cpMin >= 0 then Fmt := '%s'#13#10
    else begin
      Selection.cpMin :=
        SendMessage(RichEdit.Handle, EM_LINEINDEX, Index - 1, 0);
      if Selection.cpMin < 0 then Exit;
      L := SendMessage(RichEdit.Handle, EM_LINELENGTH, Selection.cpMin, 0);
      if L = 0 then Exit;
      Inc(Selection.cpMin, L);
      Fmt := #13#10'%s';
    end;

    Selection.cpMax := Selection.cpMin;
    SendMessage(RichEdit.Handle, EM_EXSETSEL, 0, Longint(@Selection));

    Str := Format(Fmt, [S]);
    SendMessage(RichEdit.Handle, EM_REPLACESEL, 0, LongInt(PChar(Str)));
{
    if RichEdit.SelStart <> (Selection.cpMax + Length(Str)) then
      raise EOutOfResources.Create(sRichEditInsertError);
}
  end;
end;

procedure TRichEditStrings.Delete(Index: Integer);
const
  Empty: PChar = '';
var
  Selection: TCharRange;
begin
  if Index < 0 then Exit;
  Selection.cpMin := SendMessage(RichEdit.Handle, EM_LINEINDEX, Index, 0);
  if Selection.cpMin <> -1 then
  begin
    Selection.cpMax := SendMessage(RichEdit.Handle, EM_LINEINDEX, Index + 1, 0);
    if Selection.cpMax = -1 then
      Selection.cpMax := Selection.cpMin +
        SendMessage(RichEdit.Handle, EM_LINELENGTH, Selection.cpMin, 0);
    SendMessage(RichEdit.Handle, EM_EXSETSEL, 0, Longint(@Selection));
    SendMessage(RichEdit.Handle, EM_REPLACESEL, 0, Longint(Empty));
  end;
end;

procedure TRichEditStrings.Clear;
begin
  RichEdit.Clear;
end;

procedure TRichEditStrings.SetUpdateState(Updating: Boolean);
begin
  if RichEdit.Showing then
    SendMessage(RichEdit.Handle, WM_SETREDRAW, Ord(not Updating), 0);
  if not Updating then begin
    RichEdit.Refresh;
    RichEdit.Perform(CM_TEXTCHANGED, 0, 0);
  end;
end;

procedure TRichEditStrings.EnableChange(const Value: Boolean);
var
  EventMask: Longint;
begin
  with RichEdit do
  begin
    if Value then
      EventMask := SendMessage(Handle, EM_GETEVENTMASK, 0, 0) or ENM_CHANGE
    else
      EventMask := SendMessage(Handle, EM_GETEVENTMASK, 0, 0) and not ENM_CHANGE;
    SendMessage(Handle, EM_SETEVENTMASK, 0, EventMask);
  end;
end;

procedure TRichEditStrings.SetTextStr(const Value: string);
begin
  EnableChange(False);
  try
    inherited SetTextStr(Value);
  finally
    EnableChange(True);
  end;
end;

function AdjustLineBreaks(Dest, Source: PChar): Integer; assembler;
asm
        PUSH    ESI
        PUSH    EDI
        MOV     EDI,EAX
        MOV     ESI,EDX
        MOV     EDX,EAX
        CLD
@@1:    LODSB
@@2:    OR      AL,AL
        JE      @@4
        CMP     AL,0AH
        JE      @@3
        STOSB
        CMP     AL,0DH
        JNE     @@1
        MOV     AL,0AH
        STOSB
        LODSB
        CMP     AL,0AH
        JE      @@1
        JMP     @@2
@@3:    MOV     EAX,0A0DH
        STOSW
        JMP     @@1
@@4:    STOSB
        LEA     EAX,[EDI-1]
        SUB     EAX,EDX
        POP     EDI
        POP     ESI
end;

function StreamSave(dwCookie: Longint; pbBuff: PByte;
  cb: Longint; var pcb: Longint): Longint; stdcall;
var
  StreamInfo: PRichEditStreamInfo;
begin
  Result := NoError;
  StreamInfo := PRichEditStreamInfo(Pointer(dwCookie));
  try
    pcb := 0;
    if StreamInfo^.Converter <> nil then
      pcb := StreamInfo^.Converter.ConvertWriteStream(StreamInfo^.Stream, PChar(pbBuff), cb);
  except
    Result := WriteError;
  end;
end;

function StreamLoad(dwCookie: Longint; pbBuff: PByte;
  cb: Longint; var pcb: Longint): Longint; stdcall;
var
  Buffer, pBuff: PChar;
  StreamInfo: PRichEditStreamInfo;
begin
  Result := NoError;
  StreamInfo := PRichEditStreamInfo(Pointer(dwCookie));
  Buffer := StrAlloc(cb + 1);
  try
    cb := cb div 2;
    pcb := 0;
    pBuff := Buffer + cb;
    try
      if StreamInfo^.Converter <> nil then
        pcb := StreamInfo^.Converter.ConvertReadStream(StreamInfo^.Stream, pBuff, cb);
      if pcb > 0 then
      begin
        pBuff[pcb] := #0;
        if pBuff[pcb - 1] = #13 then pBuff[pcb - 1] := #0;
        pcb := AdjustLineBreaks(Buffer, pBuff);
        Move(Buffer^, pbBuff^, pcb);
      end;
    except
      Result := ReadError;
    end;
  finally
    StrDispose(Buffer);
  end;
end;

procedure TRichEditStrings.LoadFromStream(Stream: TStream);
var
  EditStream: TEditStream;
  Position: Longint;
  TextType: Longint;
  StreamInfo: TRichEditStreamInfo;
  Converter: TConversion;
begin
  StreamInfo.Stream := Stream;
  if FConverter <> nil then Converter := FConverter
  else Converter := RichEdit.DefaultConverter.Create;
  StreamInfo.Converter := Converter;
  try
    with EditStream do
    begin
      dwCookie := LongInt(Pointer(@StreamInfo));
      pfnCallBack := @StreamLoad;
      dwError := 0;
    end;
    Position := Stream.Position;

    if PlainText then TextType := SF_TEXT
    else TextType := SF_RTF;
    SendMessage(RichEdit.Handle, EM_STREAMIN, TextType, Longint(@EditStream));

    if (TextType = SF_RTF) and (EditStream.dwError <> 0) then
    begin
      Stream.Position := Position;
      if PlainText then TextType := SF_RTF
      else TextType := SF_TEXT;
      SendMessage(RichEdit.Handle, EM_STREAMIN, TextType, Longint(@EditStream));
      if EditStream.dwError <> 0 then
        raise EOutOfResources.Create(sRichEditLoadFail);
    end;

  finally
    if FConverter = nil then Converter.Free;
  end;
end;

procedure TRichEditStrings.SaveToStream(Stream: TStream);
var
  EditStream: TEditStream;
  TextType: Longint;
  StreamInfo: TRichEditStreamInfo;
  Converter: TConversion;
begin
  if FConverter <> nil then Converter := FConverter
  else Converter := RichEdit.DefaultConverter.Create;
  StreamInfo.Stream := Stream;
  StreamInfo.Converter := Converter;
  try
    with EditStream do
    begin
      dwCookie := LongInt(Pointer(@StreamInfo));
      pfnCallBack := @StreamSave;
      dwError := 0;
    end;
    if PlainText then TextType := SF_TEXT
    else TextType := SF_RTF;
    SendMessage(RichEdit.Handle, EM_STREAMOUT, TextType, Longint(@EditStream));
    if EditStream.dwError <> 0 then
      raise EOutOfResources.Create(sRichEditSaveFail);
  finally
    if FConverter = nil then Converter.Free;
  end;
end;

procedure TRichEditStrings.LoadFromFile(const FileName: string);
var
  Ext: string;
  Convert: PConversionFormat;
begin
  Ext := AnsiLowerCaseFileName(ExtractFileExt(Filename));
  System.Delete(Ext, 1, 1);
  Convert := ConversionFormatList;
  while Convert <> nil do
    with Convert^ do
      if Extension <> Ext then Convert := Next
      else Break;
  if Convert = nil then
    Convert := @TextConversionFormat;
  if FConverter = nil then FConverter := Convert^.ConversionClass.Create;
  try
    inherited LoadFromFile(FileName);
  except
    FConverter.Free;
    FConverter := nil;
    raise;
  end;
  RichEdit.DoSetMaxLength($7FFFFFF0);
end;

procedure TRichEditStrings.SaveToFile(const FileName: string);
var
  Ext: string;
  Convert: PConversionFormat;
begin
  Ext := AnsiLowerCaseFileName(ExtractFileExt(Filename));
  System.Delete(Ext, 1, 1);
  Convert := ConversionFormatList;
  while Convert <> nil do
    with Convert^ do
      if Extension <> Ext then Convert := Next
      else Break;
  if Convert = nil then
    Convert := @TextConversionFormat;
  if FConverter = nil then FConverter := Convert^.ConversionClass.Create;
  try
    inherited SaveToFile(FileName);
  except
    FConverter.Free;
    FConverter := nil;
    raise;
  end;
end;

{ TRichEdit }

constructor TXWBCustomRichEdit.Create(AOwner: TComponent);
var
  DC: HDC;
begin
  inherited Create(AOwner);
  FSelAttributes := TXWBTextAttributes.Create(Self, atSelected);
  FDefAttributes := TXWBTextAttributes.Create(Self, atDefaultText);
  FParagraph := TParaAttributes.Create(Self);
  FRichEditStrings := TRichEditStrings.Create;
  TRichEditStrings(FRichEditStrings).RichEdit := Self;
  TabStop := True;
  Width := 185;
  Height := 89;
  AutoSize := False;
  DoubleBuffered := False;
  FHideSelection := True;
  FURLDetect:= FALSE;
  HideScrollBars := True;

  DC := GetDC(0);
  FScreenLogPixels := GetDeviceCaps(DC, LOGPIXELSY);
  DefaultConverter := TConversion;
  ReleaseDC(0, DC);
  FOldParaAlignment := Alignment;
  Perform(CM_PARENTBIDIMODECHANGED, 0, 0);
end;

destructor TXWBCustomRichEdit.Destroy;
begin
  FSelAttributes.Free;
  FDefAttributes.Free;
  FParagraph.Free;
  FRichEditStrings.Free;
  FMemStream.Free;
  inherited Destroy;
end;

procedure TXWBCustomRichEdit.Clear;
begin
  inherited Clear;
  Modified := False;
end;

procedure TXWBCustomRichEdit.CreateParams(var Params: TCreateParams);
const
// Use version 2.0 of RichEdit, previously RICHED32.DLL
  RichEditModuleName = 'RICHED20.DLL';

  HideScrollBar : array[Boolean] of DWORD = (ES_DISABLENOSCROLL, 0);
  HideSelections: array[Boolean] of DWORD = (ES_NOHIDESEL, 0);

begin
  if FRichEditModule = 0 then
  begin
    FRichEditModule := LoadLibrary(RichEditModuleName);
    if FRichEditModule <= HINSTANCE_ERROR then FRichEditModule := 0;
  end;

  inherited CreateParams(Params);

// USE RICHEDIT_CLASSA use ANSI version not Unicode
  CreateSubClass(Params, RICHEDIT_CLASSA);

  with Params do
  begin
    Style := Style or HideScrollBar[HideScrollBars] or
      HideSelections[HideSelection];
    WindowClass.style := WindowClass.style and not (CS_HREDRAW or CS_VREDRAW);
  end;
end;

procedure TXWBCustomRichEdit.CreateWnd;
var
  Plain, DesignMode, WasModified: Boolean;

begin
  WasModified := inherited Modified;

  inherited CreateWnd;
  if (SysLocale.FarEast) and not (SysLocale.PriLangID = LANG_JAPANESE) then
    Font.Charset := GetDefFontCharSet;
  SendMessage(Handle, EM_SETEVENTMASK, 0,
    ENM_CHANGE or ENM_SELCHANGE or ENM_REQUESTRESIZE or
    ENM_PROTECTED or ENM_LINK);      // Added the ENM_LINK to receive EN_LINK message

  SendMessage(Handle, EM_AUTOURLDETECT, Ord(FURLDetect), 0); // Start the URL Detect

  SendMessage(Handle, EM_SETBKGNDCOLOR, 0, ColorToRGB(Color));
  if FMemStream <> nil then
  begin
    Plain := PlainText;
    FMemStream.ReadBuffer(DesignMode, sizeof(DesignMode));
    PlainText := DesignMode;
    try
      Lines.LoadFromStream(FMemStream);
      FMemStream.Free;
      FMemStream := nil;
    finally
      PlainText := Plain;
    end;
  end;

  Modified := WasModified;
end;

procedure TXWBCustomRichEdit.DestroyWnd;
var
  Plain, DesignMode: Boolean;
begin
  FModified := Modified;
  FMemStream := TMemoryStream.Create;
  Plain := PlainText;
  DesignMode := (csDesigning in ComponentState);
  PlainText := DesignMode;
  FMemStream.WriteBuffer(DesignMode, sizeof(DesignMode));
  try
    Lines.SaveToStream(FMemStream);
    FMemStream.Position := 0;
  finally
    PlainText := Plain;
  end;

  inherited DestroyWnd;
end;

procedure TXWBCustomRichEdit.WMNCDestroy(var Message: TWMNCDestroy);
begin
  inherited;
end;

procedure TXWBCustomRichEdit.WMSetFont(var Message: TWMSetFont);
begin
  FDefAttributes.Assign(Font);
end;

procedure TXWBCustomRichEdit.WMRButtonUp(var Message: TWMRButtonUp);
begin
  // RichEd20 does not pass the WM_RBUTTONUP message to defwndproc,
  // so we get no WM_CONTEXTMENU message.  Simulate message here.
  if Win32MajorVersion < 5 then
    Perform(WM_CONTEXTMENU, Handle, LParam(PointToSmallPoint(
      ClientToScreen(SmallPointToPoint(Message.Pos)))));
  inherited;
end;

procedure TXWBCustomRichEdit.CMFontChanged(var Message: TMessage);
begin
  FDefAttributes.Assign(Font);
end;

procedure TXWBCustomRichEdit.DoSetMaxLength(Value: Integer);
begin
  SendMessage(Handle, EM_EXLIMITTEXT, 0, Value);
end;

function TXWBCustomRichEdit.GetCaretPos;
var
  CharRange: TCharRange;
begin
  SendMessage(Handle, EM_EXGETSEL, 0, LongInt(@CharRange));
  Result.X := CharRange.cpMax;
  Result.Y := SendMessage(Handle, EM_EXLINEFROMCHAR, 0, Result.X);
  Result.X := Result.X - SendMessage(Handle, EM_LINEINDEX, -1, 0);
end;

function TXWBCustomRichEdit.GetSelLength: Integer;
var
  CharRange: TCharRange;
begin
  SendMessage(Handle, EM_EXGETSEL, 0, Longint(@CharRange));
  Result := CharRange.cpMax - CharRange.cpMin;
end;

function TXWBCustomRichEdit.GetSelStart: Integer;
var
  CharRange: TCharRange;
begin
  SendMessage(Handle, EM_EXGETSEL, 0, Longint(@CharRange));
  Result := CharRange.cpMin;
end;

function TXWBCustomRichEdit.GetSelTextBuf(Buffer: PChar; BufSize: Integer): Integer;
var
  S: string;
begin
  S := GetSelText;
  Result := Length(S);
  if BufSize < Length(S) then Result := BufSize;
  StrPLCopy(Buffer, S, Result);
end;

function TXWBCustomRichEdit.GetSelText: string;
var
  Length: Integer;
begin
  SetLength(Result, GetSelLength + 1);
  Length := SendMessage(Handle, EM_GETSELTEXT, 0, Longint(PChar(Result)));
  SetLength(Result, Length);
end;

procedure TXWBCustomRichEdit.CMBiDiModeChanged(var Message: TMessage);
var
  AParagraph: TParaFormat;
begin
  HandleNeeded; { we REALLY need the handle for BiDi }
  inherited;
  Paragraph.GetAttributes(AParagraph);
  AParagraph.dwMask := PFM_ALIGNMENT;
  AParagraph.wAlignment := Ord(Alignment) + 1;
  Paragraph.SetAttributes(AParagraph);
end;

procedure TXWBCustomRichEdit.SetHideScrollBars(Value: Boolean);
begin
  if HideScrollBars <> Value then
  begin
    FHideScrollBars := value;
    RecreateWnd;
  end;
end;

procedure TXWBCustomRichEdit.SetHideSelection(Value: Boolean);
begin
  if HideSelection <> Value then
  begin
    FHideSelection := Value;
    SendMessage(Handle, EM_HIDESELECTION, Ord(HideSelection), LongInt(True));
  end;
end;

procedure TXWBCustomRichEdit.SetURLDetect(Value: boolean);
begin
 if URLDetect <> Value then
  begin
   FURLDetect:= Value;
   RecreateWnd;
  end;
end;

procedure TXWBCustomRichEdit.SetSelAttributes(Value: TXWBTextAttributes);
begin
  SelAttributes.Assign(Value);
end;

procedure TXWBCustomRichEdit.SetSelLength(Value: Integer);
var
  CharRange: TCharRange;
begin
  SendMessage(Handle, EM_EXGETSEL, 0, Longint(@CharRange));
  CharRange.cpMax := CharRange.cpMin + Value;
  SendMessage(Handle, EM_EXSETSEL, 0, Longint(@CharRange));
  SendMessage(Handle, EM_SCROLLCARET, 0, 0);
end;

procedure TXWBCustomRichEdit.SetDefAttributes(Value: TXWBTextAttributes);
begin
  DefAttributes.Assign(Value);
end;

function TXWBCustomRichEdit.GetPlainText: Boolean;
begin
  Result := TRichEditStrings(Lines).PlainText;
end;

procedure TXWBCustomRichEdit.SetPlainText(Value: Boolean);
begin
  TRichEditStrings(Lines).PlainText := Value;
end;

procedure TXWBCustomRichEdit.CMColorChanged(var Message: TMessage);
begin
  inherited;
  SendMessage(Handle, EM_SETBKGNDCOLOR, 0, ColorToRGB(Color))
end;

procedure TXWBCustomRichEdit.SetRichEditStrings(Value: TStrings);
begin
  FRichEditStrings.Assign(Value);
end;

procedure TXWBCustomRichEdit.SetSelStart(Value: Integer);
var
  CharRange: TCharRange;
begin
  CharRange.cpMin := Value;
  CharRange.cpMax := Value;
  SendMessage(Handle, EM_EXSETSEL, 0, Longint(@CharRange));
end;

procedure TXWBCustomRichEdit.Print(const Caption: string);
var
  Range: TFormatRange;
  LastChar, MaxLen, LogX, LogY, OldMap: Integer;
  SaveRect: TRect;
begin
  FillChar(Range, SizeOf(TFormatRange), 0);
  with Printer, Range do
  begin
    Title := Caption;
    BeginDoc;
    hdc := Handle;
    hdcTarget := hdc;
    LogX := GetDeviceCaps(Handle, LOGPIXELSX);
    LogY := GetDeviceCaps(Handle, LOGPIXELSY);
    if IsRectEmpty(PageRect) then
    begin
      rc.right := PageWidth * 1440 div LogX;
      rc.bottom := PageHeight * 1440 div LogY;
    end
    else begin
      rc.left := PageRect.Left * 1440 div LogX;
      rc.top := PageRect.Top * 1440 div LogY;
      rc.right := PageRect.Right * 1440 div LogX;
      rc.bottom := PageRect.Bottom * 1440 div LogY;
    end;
    rcPage := rc;
    SaveRect := rc;
    LastChar := 0;
    MaxLen := GetTextLen;
    chrg.cpMax := -1;
    // ensure printer DC is in text map mode
    OldMap := SetMapMode(hdc, MM_TEXT);
    SendMessage(Self.Handle, EM_FORMATRANGE, 0, 0);    // flush buffer
    try
      repeat
        rc := SaveRect;
        chrg.cpMin := LastChar;
        LastChar := SendMessage(Self.Handle, EM_FORMATRANGE, 1, Longint(@Range));
        if (LastChar < MaxLen) and (LastChar <> -1) then NewPage;
      until (LastChar >= MaxLen) or (LastChar = -1);
      EndDoc;
    finally
      SendMessage(Self.Handle, EM_FORMATRANGE, 0, 0);  // flush buffer
      SetMapMode(hdc, OldMap);       // restore previous map mode
    end;
  end;
end;

var
  Painting: Boolean = False;

procedure TXWBCustomRichEdit.WMPaint(var Message: TWMPaint);
var
  R, R1: TRect;
begin
  if GetUpdateRect(Handle, R, True) then
  begin
    with ClientRect do R1 := Rect(Right - 3, Top, Right, Bottom);
    if IntersectRect(R, R, R1) then InvalidateRect(Handle, @R1, True);
  end;
  if Painting then
    Invalidate
  else begin
    Painting := True;
    try
      inherited;
    finally
      Painting := False;
    end;
  end;
end;

procedure TXWBCustomRichEdit.WMSetCursor(var Message: TWMSetCursor);
var
  P: TPoint;
begin
  inherited;
  if Message.Result = 0 then
  begin
    Message.Result := 1;
    GetCursorPos(P);
    with PointToSmallPoint(P) do
      case Perform(WM_NCHITTEST, 0, MakeLong(X, Y)) of
        HTVSCROLL,
        HTHSCROLL:
          Windows.SetCursor(Screen.Cursors[crArrow]);
        HTCLIENT:
          Windows.SetCursor(Screen.Cursors[crIBeam]);
      end;
  end;
end;

procedure TXWBCustomRichEdit.CNNotify(var Message: TWMNotify);
type
  PENLink = ^TENLink;

begin
  with Message do
    case NMHdr^.code of
      EN_SELCHANGE: SelectionChange;
      EN_REQUESTRESIZE: RequestSize(PReqSize(NMHdr)^.rc);
      EN_SAVECLIPBOARD:
        with PENSaveClipboard(NMHdr)^ do
          if not SaveClipboard(cObjectCount, cch) then Result := 1;
      EN_PROTECTED:
        with PENProtected(NMHdr)^.chrg do
          if not ProtectChange(cpMin, cpMax) then Result := 1;

// EN_LINK message being received to respond to it
      EN_LINK:
       begin
        Windows.SetCursor(Screen.Cursors[crHandPoint]);
        if PEnLink(NMHdr)^.msg = WM_LBUTTONDOWN then
          begin
// set the selection
            SendMessage(Handle, EM_EXSETSEL, 0, Longint(@PEnLink(NMHdr)^.chrg));
// send it to windows to open
            ShellExecute(handle, 'open', PChar(GetSelText), nil, nil, SW_SHOWNORMAL);
          end;
       end;
    end;
end;

function TXWBCustomRichEdit.SaveClipboard(NumObj, NumChars: Integer): Boolean;
begin
  Result := True;
  if Assigned(OnSaveClipboard) then OnSaveClipboard(Self, NumObj, NumChars, Result);
end;

function TXWBCustomRichEdit.ProtectChange(StartPos, EndPos: Integer): Boolean;
begin
  Result := False;
  if Assigned(OnProtectChange) then OnProtectChange(Self, StartPos, EndPos, Result);
end;

procedure TXWBCustomRichEdit.SelectionChange;
begin
  if Assigned(OnSelectionChange) then OnSelectionChange(Self);
end;

procedure TXWBCustomRichEdit.RequestSize(const Rect: TRect);
begin
  if Assigned(OnResizeRequest) then OnResizeRequest(Self, Rect);
end;

function TXWBCustomRichEdit.FindText(const SearchStr: string;
  StartPos, Length: Integer; Options: TSearchTypes): Integer;
var
  Find: TFindText;
  Flags: Integer;
begin
  with Find.chrg do
  begin
    cpMin := StartPos;
    cpMax := cpMin + Length;
  end;
  Flags := 0;
  if stWholeWord in Options then Flags := Flags or FT_WHOLEWORD;
  if stMatchCase in Options then Flags := Flags or FT_MATCHCASE;
  Find.lpstrText := PChar(SearchStr);
  Result := SendMessage(Handle, EM_FINDTEXT, Flags, LongInt(@Find));
end;

procedure AppendConversionFormat(const Ext: string; AClass: TConversionClass);
var
  NewRec: PConversionFormat;
begin
  New(NewRec);
  with NewRec^ do
  begin
    Extension := AnsiLowerCaseFileName(Ext);
    ConversionClass := AClass;
    Next := ConversionFormatList;
  end;
  ConversionFormatList := NewRec;
end;

class procedure TXWBCustomRichEdit.RegisterConversionFormat(const AExtension: string;
  AConversionClass: TConversionClass);
begin
  AppendConversionFormat(AExtension, AConversionClass);
end;

end.

