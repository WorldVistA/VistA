{*********************************************************}
{*                   OVCCOCO.PAS 4.08                    *}
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
{*   Armin Biernaczyk                                                         *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

{$I OVC.INC}

{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CAST OFF}

unit ovccoco;
{Base components for Coco/R for Delphi grammars for use with version 1.1}

interface

uses
  Classes;

const
  setsize = 16; { sets are stored in 16 bits }

  { Standard Error Types }
  etSyntax = 0;
  etSymantic = 1;

  chCR = #13;
  chLF = #10;
  chEOL = chCR + chLF;  { End of line characters for Microsoft Windows }
  chLineSeparator = chCR;

type
  TCocoError = class(TObject)
  private
    FErrorCode : integer;
    FCol : integer;
    FLine : integer;
    FData : string;
    FErrorType : integer;
  public
    property ErrorType : integer read FErrorType write FErrorType;
    property ErrorCode : integer read FErrorCode write FErrorCode;
    property Line : integer read FLine write FLine;
    property Col : integer read FCol write FCol;
    property Data : string read FData write FData;
  end; {TCocoError}

  TCommentItem = class(TObject)
  private
    fComment: string;
    fLine: integer;
    fColumn: integer;
  public
    property Comment : string read fComment write fComment;
    property Line : integer read fLine write fLine;
    property Column : integer read fColumn write fColumn;
  end; {TCommentItem}

  TCommentList = class(TObject)
  private
    fList : TList;

    function FixComment(const S : string) : string;
    function GetComments(Idx: integer): string;
    procedure SetComments(Idx: integer; const Value: string);
    function GetCount: integer;
    function GetText: string;
    function GetColumn(Idx: integer): integer;
    function GetLine(Idx: integer): integer;
    procedure SetColumn(Idx: integer; const Value: integer);
    procedure SetLine(Idx: integer; const Value: integer);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure Add(const S : string; const aLine : integer; const aColumn : integer);
    property Comments[Idx : integer] : string read GetComments write SetComments; default;
    property Line[Idx : integer] : integer read GetLine write SetLine;
    property Column[Idx : integer] : integer read GetColumn write SetColumn;
    property Count : integer read GetCount;
    property Text : string read GetText;
  end; {TCommentList}

  TSymbolPosition = class(TObject)
  private
    fLine : integer;
    fCol : integer;
    fLen : integer;
    fPos : integer;
  public
    procedure Clear;

    property Line : integer read fLine write fLine; {line of symbol}
    property Col : integer read fCol write fCol; {column of symbol}
    property Len : integer read fLen write fLen; {length of symbol}
    property Pos : integer read fPos write fPos; {file position of symbol}
  end; {TSymbolPosition}

  TGenListType = (glNever, glAlways, glOnError);

  TBitSet = set of 0..15;
  PStartTable = ^TStartTable;
  TStartTable = array[0..255] of integer;
  TCharSet = set of AnsiChar;

  TAfterGenListEvent = procedure(Sender : TObject;
    var PrintErrorCount : boolean) of object;
  TCommentEvent = procedure(Sender : TObject; CommentList : TCommentList) of object;
  TCustomErrorEvent = function(Sender : TObject; const ErrorCode : Integer;
    const Data : string) : string of object;
  TErrorEvent = procedure(Sender : TObject; Error : TCocoError) of object;
  TErrorProc = procedure(ErrorCode : integer; Symbol : TSymbolPosition;
    const Data : string; ErrorType : integer) of object;
  TFailureEvent = procedure(Sender : TObject; NumErrors : integer) of object;
  TGetCH = function(pos : Integer) : char of object;
  TStatusUpdateProc = procedure(Sender : TObject; Status : string;
    LineNum : integer) of object;

  TCocoRScanner = class(TObject)
  private
    FbpCurrToken : integer; {position of current token)}
    FBufferPosition : integer; {current position in buf }
    FContextLen : integer; {length of appendix (CONTEXT phrase)}
    FCurrentCh : TGetCH; {procedural variable to get current input character}
    FCurrentSymbol : TSymbolPosition; {position of the current symbol in the source stream}
    FCurrInputCh : char; {current input character}
    FCurrLine : integer; {current input line (may be higher than line)}
    FLastInputCh : char; {the last input character that was read}
    FNextSymbol : TSymbolPosition; {position of the next symbol in the source stream}
    FNumEOLInComment : integer; {number of _EOLs in a comment}
    FOnStatusUpdate : TStatusUpdateProc;
    FScannerError : TErrorProc;
    FSourceLen : integer; {source file size}
    FSrcStream : TMemoryStream; {source memory stream}
    FStartOfLine : integer;

    function GetNStr(Symbol : TSymbolPosition; ChProc : TGetCh) : string;
  protected
    FStartState : TStartTable; {start state for every character}

    function CapChAt(pos : Integer) : char;
    procedure Get(var sym : integer); virtual; abstract;
    procedure NextCh; virtual; abstract;

    function GetStartState : PStartTable;
    procedure SetStartState(aStartTable : PStartTable);

    property bpCurrToken : integer read fbpCurrToken write fbpCurrToken;
    property BufferPosition : integer read fBufferPosition write fBufferPosition;
    property ContextLen : integer read fContextLen write fContextLen;
    property CurrentCh : TGetCh read fCurrentCh write fCurrentCh;
    property CurrentSymbol : TSymbolPosition read fCurrentSymbol write fCurrentSymbol;
    property CurrInputCh : char read fCurrInputCh write fCurrInputCh;
    property CurrLine : integer read fCurrLine write fCurrLine;
    property LastInputCh : char read fLastInputCh write fLastInputCh;
    property NextSymbol : TSymbolPosition read fNextSymbol write fNextSymbol;
    property NumEOLInComment : integer read fNumEOLInComment write fNumEOLInComment;
    property OnStatusUpdate : TStatusUpdateProc read FOnStatusUpdate write FOnStatusUpdate;
    property ScannerError : TErrorProc read FScannerError write FScannerError;
    property SourceLen : integer read fSourceLen write fSourceLen;
    property SrcStream : TMemoryStream read fSrcStream write fSrcStream;
    property StartOfLine : integer read fStartOfLine write fStartOfLine;
    property StartState : PStartTable read GetStartState write SetStartState;
  public
    constructor Create;
    destructor Destroy; override;

    function CharAt(pos : Integer) : char;
    function GetName(Symbol : TSymbolPosition) : string; // Retrieves name of symbol of length len at position pos in source file
    function GetString(Symbol : TSymbolPosition) : string; // Retrieves exact string of max length len from position pos in source file
    procedure _Reset;
  end; {TCocoRScanner}

  TCocoRGrammar = class(TComponent)
  private
    FAfterGenList : TAfterGenListEvent;
    FAfterParse : TNotifyEvent;
    FBeforeGenList : TNotifyEvent;
    FBeforeParse : TNotifyEvent;
    fClearSourceStream : boolean;
    FErrDist : integer; // number of symbols recognized since last error
    FErrorList : TList;
    fGenListWhen : TGenListType;
    FListStream : TMemoryStream;
    FOnCustomError : TCustomErrorEvent;
    FOnError : TErrorEvent;
    FOnFailure : TFailureEvent;
    FOnStatusUpdate : TStatusUpdateProc;
    FOnSuccess : TNotifyEvent;
    FScanner : TCocoRScanner;
    FSourceFileName : string;
    fExtra : integer;

    function GetSourceStream : TMemoryStream;
    function GetSuccessful : boolean;
    procedure SetOnStatusUpdate(const Value : TStatusUpdateProc);
    procedure SetSourceStream(const Value : TMemoryStream);
    function GetLineCount: integer;
    function GetCharacterCount: integer;
  protected
    fCurrentInputSymbol : integer; // current input symbol

    procedure ClearErrors;
    procedure Expect(n : integer);
    procedure GenerateListing;
    procedure Get; virtual; abstract;
    procedure PrintErr(const line : string; ErrorCode, col : integer;
      const Data : string);
    procedure StoreError(nr : integer; Symbol : TSymbolPosition;
      const Data : string; ErrorType : integer);

    property ClearSourceStream : boolean read fClearSourceStream write fClearSourceStream default true;
    property CurrentInputSymbol : integer read fCurrentInputSymbol write fCurrentInputSymbol;
    property ErrDist : integer read fErrDist write fErrDist; // number of symbols recognized since last error
    property Extra : integer read fExtra write fExtra;
    property GenListWhen : TGenListType read fGenListWhen write fGenListWhen default glOnError;
    property ListStream : TMemoryStream read FListStream write FListStream;
    property SourceFileName : string read FSourceFileName write FSourceFileName;
    property Successful : boolean read GetSuccessful;

    {Events}
    property AfterParse : TNotifyEvent read fAfterParse write fAfterParse;
    property AfterGenList : TAfterGenListEvent read fAfterGenList write fAfterGenList;
    property BeforeGenList : TNotifyEvent read fBeforeGenList write fBeforeGenList;
    property BeforeParse : TNotifyEvent read fBeforeParse write fBeforeParse;
    property OnCustomError : TCustomErrorEvent read FOnCustomError write FOnCustomError;
    property OnFailure : TFailureEvent read FOnFailure write FOnFailure;
    property OnStatusUpdate : TStatusUpdateProc read FOnStatusUpdate write SetOnStatusUpdate;
    property OnSuccess : TNotifyEvent read FOnSuccess write FOnSuccess;
  public
    function ErrorStr(const ErrorCode : integer; const Data : string) : string; virtual; abstract;
    property ErrorList : TList read FErrorList write FErrorList;
    property SourceStream : TMemoryStream read GetSourceStream write SetSourceStream;
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;

    procedure GetLine(var pos : Integer; var line : string;
      var eof : boolean);
    function LexName : string;
    function LexString : string;
    function LookAheadName : string;
    function LookAheadString : string;
    procedure _StreamLine(s : string);
    procedure _StreamLn(const s : string);
    procedure SemError(const errNo : integer; const Data : string);
    procedure SynError(const errNo : integer);

    property Scanner : TCocoRScanner read fScanner write fScanner;
    property LineCount : integer read GetLineCount;
    property CharacterCount : integer read GetCharacterCount;
    property OnError : TErrorEvent read fOnError write fOnError;
  end; {TCocoRGrammar}

const
  _EF = #0;
  _TAB = #09;
  _CR = #13;
  _LF = #10;
  _EL = _CR;
  _EOF = #26; {MS-DOS eof}
  LineEnds : TCharSet = [_CR, _LF, _EF];
  { not only for errors but also for not finished states of scanner analysis }
  minErrDist = 2; { minimal distance (good tokens) between two errors }

function PadL(S : string; ch : char; L : integer) : string;

implementation

uses
  SysUtils, ovcStr;

function PadL(S : string; ch : char; L : integer) : string;
var
  i : integer;
begin
  for i := 1 to L - (Length(s)) do
    s := ch + s;
  Result := s;
end; {PadL}

{ TSymbolPosition }

procedure TSymbolPosition.Clear;
begin
  Len := 0;
  Pos := 0;
  Line := 0;
  Col := 0;
end; { Clear }

constructor TCocoRScanner.Create;
begin
  inherited;
  fSrcStream := TMemoryStream.Create;
  CurrentSymbol := TSymbolPosition.Create;
  NextSymbol := TSymbolPosition.Create;
end; {Create}

destructor TCocoRScanner.Destroy;
begin
  fSrcStream.Free;
  fSrcStream := NIL;
  CurrentSymbol.Free;
  CurrentSymbol := NIL;
  NextSymbol.Free;
  NextSymbol := NIL;
  inherited;
end; {Destroy}

function TCocoRScanner.CapChAt(pos : Integer) : char;
begin
  Result := UpCase(CharAt(pos));
end; {CapCharAt}

function TCocoRScanner.CharAt(pos : Integer) : char;
var
  ch : char;
begin
  if pos >= SourceLen then begin
    Result := _EF;
    exit;
  end;
  SrcStream.Seek(pos, soFromBeginning);
  SrcStream.ReadBuffer(Ch, SizeOf(Char));
  if ch <> _EOF then
    Result := ch
  else
    Result := _EF
end; {CharAt}

function TCocoRScanner.GetNStr(Symbol : TSymbolPosition; ChProc : TGetCh) : string;
var
  i : integer;
  p : Integer;
begin
  if Symbol.Len > 255 then
    Symbol.Len := 255;
  SetLength(Result, Symbol.Len);
  p := Symbol.Pos;
  i := 1;
  while i <= Symbol.Len do begin
    Result[i] := ChProc(p);
    inc(i);
    inc(p, SizeOf(Char))
  end;
end; {GetNStr}


function TCocoRScanner.GetName(Symbol : TSymbolPosition) : string;
begin
  Result := GetNStr(Symbol, CurrentCh);
end; {GetName}


function TCocoRScanner.GetStartState : PStartTable;
begin
  Result := @fStartState;
end; {GetStartState}


procedure TCocoRScanner.SetStartState(aStartTable : PStartTable);
begin
  fStartState := aStartTable^;
end; {SetStartState}


function TCocoRScanner.GetString(Symbol : TSymbolPosition) : string;
begin
  Result := GetNStr(Symbol, CharAt);
end; {GetString}


procedure TCocoRScanner._Reset;
var
  len : Integer;
begin
  { Make sure that the stream has the _EF character at the end. }
  CurrInputCh := _EF;
  SrcStream.Seek(0, soFromEnd);
  SrcStream.WriteBuffer(CurrInputCh, SizeOf(Char));
  SrcStream.Seek(0, soFromBeginning);

  LastInputCh := _EF;
  len := SrcStream.Size;
  SourceLen := len;
  CurrLine := 1;
  StartOfLine := -2;
  BufferPosition := -SizeOf(Char);
  CurrentSymbol.Clear;
  NextSymbol.Clear;
  NumEOLInComment := 0;
  ContextLen := 0;
  NextCh;
end; {_Reset}

{ TCocoRGrammar }

procedure TCocoRGrammar.ClearErrors;
var
  i : integer;
begin
  for i := 0 to fErrorList.Count - 1 do
    TCocoError(fErrorList[i]).Free;
  fErrorList.Clear;
end; {ClearErrors}

constructor TCocoRGrammar.Create(AOwner : TComponent);
begin
  inherited;
  FGenListWhen := glOnError;
  fClearSourceStream := true;
  fListStream := TMemoryStream.Create;
  fErrorList := TList.Create;
end; {Create}

destructor TCocoRGrammar.Destroy;
begin
  fListStream.Clear;
  fListStream.Free;
  ClearErrors;
  fErrorList.Free;
  inherited;
end; {Destroy}

procedure TCocoRGrammar.Expect(n : integer);
begin
  if CurrentInputSymbol = n then
    Get
  else
    SynError(n);
end; {Expect}

procedure TCocoRGrammar.GenerateListing;
  { Generate a source listing with error messages }
var
  i : integer;
  eof : boolean;
  lnr, errC : integer;
  srcPos : Integer;
  line : string;
  PrintErrorCount : boolean;
begin
  if Assigned(BeforeGenList) then
    BeforeGenList(Self);
  srcPos := 0;
  GetLine(srcPos, line, eof);
  lnr := 1;
  errC := 0;
  while not eof do
  begin
    _StreamLine(PadL(IntToStr(lnr), ' ', 5) + '  ' + line);
    for i := 0 to ErrorList.Count - 1 do
    begin
      if TCocoError(ErrorList[i]).Line = lnr then
      begin
        PrintErr(line, TCocoError(ErrorList[i]).ErrorCode,
          TCocoError(ErrorList[i]).Col,
          TCocoError(ErrorList[i]).Data);
        inc(errC);
      end;
    end;
    GetLine(srcPos, line, eof);
    inc(lnr);
  end;
  // Now take care of the last line.
  for i := 0 to ErrorList.Count - 1 do
  begin
    if TCocoError(ErrorList[i]).Line = lnr then
    begin
      PrintErr(line, TCocoError(ErrorList[i]).ErrorCode,
        TCocoError(ErrorList[i]).Col,
        TCocoError(ErrorList[i]).Data);
      inc(errC);
    end;
  end;
  PrintErrorCount := true;
  if Assigned(AfterGenList) then
    AfterGenList(Self, PrintErrorCount);
  if PrintErrorCount then
  begin
    _StreamLine('');
    _StreamLn(PadL(IntToStr(errC), ' ', 5) + ' error');
    if errC <> 1 then
      _StreamLine('s');
  end;
end; {GenerateListing}

procedure TCocoRGrammar.GetLine(var pos: Integer; var line: string; var eof: boolean);
  { Read a source line. Return empty line if eof }
var
  ch : char;
  i : integer;
begin
  i := 1;
  eof := false;
  ch := Scanner.CharAt(pos);
  inc(pos, SizeOf(Char));
  while not CharInSet(ch, LineEnds) do
  begin
    SetLength(line, length(Line) + 1);
    line[i] := ch;
    inc(i);
    ch := Scanner.CharAt(pos);
    inc(pos, SizeOf(Char));
  end;
  SetLength(line, i - 1);
  eof := (i = 1) and (ch = _EF);
  if ch = _CR then
  begin { check for MsDos end of lines }
    ch := Scanner.CharAt(pos);
    if ch = _LF then
    begin
      inc(pos);
      Extra := 0;
    end;
  end;
end; {GetLine}

function TCocoRGrammar.GetSourceStream : TMemoryStream;
begin
  Result := Scanner.SrcStream;
end; {GetSourceStream}

function TCocoRGrammar.GetSuccessful : boolean;
begin
  Result := ErrorList.Count = 0;
end; {GetSuccessful}

function TCocoRGrammar.LexName : string;
begin
  Result := Scanner.GetName(Scanner.CurrentSymbol)
end; {LexName}

function TCocoRGrammar.LexString : string;
begin
  Result := Scanner.GetString(Scanner.CurrentSymbol)
end; {LexString}

function TCocoRGrammar.LookAheadName : string;
begin
  Result := Scanner.GetName(Scanner.NextSymbol)
end; {LookAheadName}

function TCocoRGrammar.LookAheadString : string;
begin
  Result := Scanner.GetString(Scanner.NextSymbol)
end; {LookAheadString}

procedure TCocoRGrammar.PrintErr(const line : string; ErrorCode : integer; col : integer; const Data : string);
  { Print an error message }

  procedure DrawErrorPointer;
  var
    i : integer;
  begin
    _StreamLn('*****  ');
    i := 0;
    while i < col + Extra - 2 do
    begin
      if ((length(Line) > 0) and (length(Line) < i)) and (line[i] = _TAB) then
        _StreamLn(_TAB)
      else
        _StreamLn(' ');
      inc(i)
    end;
    _StreamLn('^ ')
  end; {DrawErrorPointer}

begin {PrintErr}
  DrawErrorPointer;
  _StreamLn(ErrorStr(ErrorCode, Data));
  _StreamLine('')
end; {PrintErr}

procedure TCocoRGrammar.SemError(const errNo : integer; const Data : string);
begin
  if errDist >= minErrDist then
    Scanner.ScannerError(errNo, Scanner.CurrentSymbol, Data, etSymantic);
  errDist := 0;
end; {SemError}

procedure TCocoRGrammar._StreamLn(const s : string);
begin
  if length(s) > 0 then
    ListStream.WriteBuffer(s[1], length(s) * SizeOf(Char));
end; {_StreamLn}

procedure TCocoRGrammar._StreamLine(s : string);
begin
  s := s + chEOL;
  _StreamLn(s);
end; {_StreamLine}

procedure TCocoRGrammar.SynError(const errNo : integer);
begin
  if errDist >= minErrDist then
    Scanner.ScannerError(errNo, Scanner.NextSymbol, '', etSyntax);
  errDist := 0;
end; {SynError}

procedure TCocoRGrammar.SetOnStatusUpdate(const Value : TStatusUpdateProc);
begin
  FOnStatusUpdate := Value;
  Scanner.OnStatusUpdate := Value;
end; {SetOnStatusUpdate}

procedure TCocoRGrammar.SetSourceStream(const Value : TMemoryStream);
begin
  Scanner.SrcStream := Value;
end; {SetSourceStream}

procedure TCocoRGrammar.StoreError(nr : integer; Symbol : TSymbolPosition;
  const Data : string; ErrorType : integer);
  { Store an error message for later printing }
var
  Error : TCocoError;
begin
  Error := TCocoError.Create;
  Error.ErrorCode := nr;
  if Assigned(Symbol) then
  begin
    Error.Line := Symbol.Line;
    Error.Col := Symbol.Col;
  end
  else
  begin
    Error.Line := 0;
    Error.Col := 0;
  end;
  Error.Data := Data;
  Error.ErrorType := ErrorType;
  ErrorList.Add(Error);
  if Assigned(OnError) then
    OnError(self, Error);
end; {StoreError}

function TCocoRGrammar.GetLineCount: integer;
begin
  Result := Scanner.CurrLine;
end; {GetLineCount}

function TCocoRGrammar.GetCharacterCount: integer;
begin
  Result := Scanner.BufferPosition;
end; {GetCharacterCount}

{ TCommentList }

procedure TCommentList.Add(const S : string; const aLine : integer;
    const aColumn : integer);
var
  CommentItem : TCommentItem;
begin
  CommentItem := TCommentItem.Create;
  try
    CommentItem.Comment := FixComment(S);
    CommentItem.Line := aLine;
    CommentItem.Column := aColumn;
    fList.Add(CommentItem);
  except
    CommentItem.Free;
  end;
end; {Add}

procedure TCommentList.Clear;
var
  i : integer;
begin
  for i := 0 to fList.Count - 1 do
    TCommentItem(fList[i]).Free;
  fList.Clear;
end; {Clear}

constructor TCommentList.Create;
begin
  fList := TList.Create;
end; {Create}

destructor TCommentList.Destroy;
begin
  Clear;
  if Assigned(fList) then
  begin
    fList.Free;
    fList := NIL;
  end;
  inherited;
end; {Destroy}

function TCommentList.FixComment(const S: string): string;
begin
  Result := S;
  while (length(Result) > 0) AND (Result[length(Result)] < #32) do
    Delete(Result,Length(Result),1);
end; {FixComment}

function TCommentList.GetColumn(Idx: integer): integer;
begin
  Result := TCommentItem(fList[Idx]).Column;
end; {GetColumn}

function TCommentList.GetComments(Idx: integer): string;
begin
  Result := TCommentItem(fList[Idx]).Comment;
end; {GetComments}

function TCommentList.GetCount: integer;
begin
  Result := fList.Count;
end; {GetCount}

function TCommentList.GetLine(Idx: integer): integer;
begin
  Result := TCommentItem(fList[Idx]).Line;
end; {GetLine}

function TCommentList.GetText: string;
var
  i : integer;
begin
  Result := '';
  for i := 0 to Count - 1 do
  begin
    Result := Result + Comments[i];
    if i < Count - 1 then
      Result := Result + chEOL;
  end;
end; {GetText}

procedure TCommentList.SetColumn(Idx: integer; const Value: integer);
begin
  TCommentItem(fList[Idx]).Column := Value;
end; {SetColumn}

procedure TCommentList.SetComments(Idx: integer; const Value: string);
begin
  TCommentItem(fList[Idx]).Comment := Value;
end; {SetComments}

procedure TCommentList.SetLine(Idx: integer; const Value: integer);
begin
  TCommentItem(fList[Idx]).Line := Value;
end; {SetLine}

end.

