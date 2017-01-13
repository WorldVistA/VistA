//  HRParser v1.0.1 (25.Sep.2000)
//  Simple and fast parser classes.
//  by Colin A Ridgewell
//  
//  Copyright (C) 1999,2000 Hayden-R Ltd
//  http://www.haydenr.com
//  
//  This program is free software; you can redistribute it and/or modify it
//  under the terms of the GNU General Public License as published by the
//  Free Software Foundation; either version 2 of the License, or (at your
//  option) any later version.
//
//  This program is distributed in the hope that it will be useful, but
//  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
//  or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
//  more details.
//
//  You should have received a copy of the GNU General Public License along
//  with this program (gnu_license.htm); if not, write to the
//
//  Free Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
//  
//  To contact us via e-mail use the following addresses...
//  
//  bug@haydenr.u-net.com       - to report a bug
//  support@haydenr.u-net.com   - for general support
//  wishlist@haydenr.u-net.com  - add new requirement to wish list
//  
unit HRParser;

interface

uses
  Classes, SysUtils, HRBuffers;

type
  THRTokenType = Byte;

const
  HR_PARSER_STREAM_BUFFER_SIZE = 2048; {bytes}
  HR_PARSER_TOKEN_BUFFER_SIZE = 1024; {bytes}

  {THRParser tokens}
  HR_TOKEN_NIL = 0;
  HR_TOKEN_EOF = 1;
  HR_TOKEN_CHAR = 2;

  {THRParserText tokens}
  HR_TOKEN_TEXT_SPACE = 3;
  HR_TOKEN_TEXT_SYMBOL = 4;
  HR_TOKEN_TEXT_INTEGER = 5;
  HR_TOKEN_TEXT_FLOAT = 6;

type
  THRToken = record
    Token: PChar;
    TokenType: THRTokenType;
    SourcePos: Longint;
    Line: Longint;
    LinePos: Integer;
    end;

  THRParser = class( TObject )
  private
    function GetSource: TStream;
    procedure SetSource(Value: TStream);
    procedure SetSourcePos(Value: LongInt);
  protected
    FSourceBuf: THRBufferStream;
    FSourcePos: LongInt;
    FLine: Longint;
    FLineStartSourcePos: Longint;
    FTokenBuf: THRBufferChar;
    FToken: THRToken;
    procedure IncLine;
    procedure SkipToSourcePos(const Pos: Longint);
    procedure SkipBlanks;
    procedure GetNextToken; virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    property Source: TStream read GetSource write SetSource;
    property SourcePos: Longint read FSourcePos write SetSourcePos;
    property Token: THRToken read FToken;
    function NextToken: THRToken;
  end;

  THRParserText = class( THRParser )
  private
  protected
    procedure GetNextToken; override;
  public
    constructor Create; override;
    destructor Destroy; override;
  end;

implementation


{ T H R P a r s e r }

constructor THRParser.Create;
begin
  FSourceBuf := THRBufferStream.Create;
  FSourceBuf.Size := HR_PARSER_STREAM_BUFFER_SIZE;
  FTokenBuf := THRBufferChar.Create;
  FTokenBuf.Size := HR_PARSER_TOKEN_BUFFER_SIZE;
  FSourcePos := 0;
end;


destructor THRParser.Destroy;
begin
  FTokenBuf.Free;
  FTokenBuf := nil;
  FSourceBuf.Free;
  FSourceBuf := nil;
  inherited Destroy;
end;


function THRParser.GetSource: TStream;
begin
  Result := FSourceBuf.Stream;
end;


procedure THRParser.SetSource(Value: TStream);
begin
  FSourceBuf.Stream := Value;
end;


procedure THRParser.SetSourcePos(Value: LongInt);
begin
  SkipToSourcePos( Value );
end;


procedure THRParser.IncLine;
begin
 Inc( FLine );
 FLineStartSourcePos := FSourcePos;
end;


procedure THRParser.SkipToSourcePos(const Pos: Longint);
begin
  FSourcePos := 0;
  FLine := 0;
  FLineStartSourcePos := 0;
  FSourceBuf[ FSourcePos ];
  while not FSourceBuf.EOB and ( FSourcePos < Pos ) do
  begin
    if FSourceBuf[ FSourcePos ] = #10 then IncLine;
    Inc( FSourcePos );
    FSourceBuf[ FSourcePos ];
  end;
end;


procedure THRParser.SkipBlanks;
begin
  FSourceBuf[ FSourcePos ];
  while not FSourceBuf.EOB do
  begin
    case FSourceBuf[ FSourcePos ] of
      #32..#255 : Exit;
      #10 : IncLine;
    end;
    Inc( FSourcePos );
    FSourceBuf[ FSourcePos ];
  end;
end;


procedure THRParser.GetNextToken;
begin
  FSourceBuf[ FSourcePos ];
  if not FSourceBuf.EOB then
  begin
    {single char}
    FTokenBuf.Write( FSourceBuf[ FSourcePos ] );
    Inc( FSourcePos );
    FToken.TokenType := HR_TOKEN_CHAR;
  end
  else
  begin
    {end of buffer}
    FToken.TokenType := HR_TOKEN_EOF;
  end;
end;



function THRParser.NextToken: THRToken;
begin
  FTokenBuf.Position := 0;

  SkipBlanks;

  {store start pos of token}
  with FToken do
  begin
    SourcePos := FSourcePos;
    Line := FLine;
    LinePos := FSourcePos - FLineStartSourcePos;
  end;

  GetNextToken;

  FTokenBuf.Write( #0 ); {null terminate.}
  FToken.Token := FTokenBuf.Buffer;
  Result := FToken;
end;


{ T H R P a r s e r T e x t }

constructor THRParserText.Create;
begin
  inherited Create;
end;


destructor THRParserText.Destroy;
begin
  inherited Destroy;
end;


procedure THRParserText.GetNextToken;
begin
  repeat

    {spaces}
    if FSourceBuf[ FSourcePos ] = ' ' then
    begin
      FTokenBuf.Write( FSourceBuf[ FSourcePos ] );
      Inc( FSourcePos );
      while FSourceBuf[ FSourcePos ] = ' ' do
      begin
        FTokenBuf.Write( FSourceBuf[ FSourcePos ] );
        Inc( FSourcePos );
      end;
      FToken.TokenType := HR_TOKEN_TEXT_SPACE;
      Break;{out of repeat}
    end;

    {symbols}
    if CharInSet(FSourceBuf[ FSourcePos ], [ 'A'..'Z', 'a'..'z', '_' ]) then
    begin
      FTokenBuf.Write( FSourceBuf[ FSourcePos ] );
      Inc( FSourcePos );
      while True do
      begin
        case FSourceBuf[ FSourcePos ] of

          'A'..'Z', 'a'..'z', '0'..'9', '_' :
          begin
            FTokenBuf.Write( FSourceBuf[ FSourcePos ] );
            Inc( FSourcePos );
          end;

          '''' :
          begin{apostrophies}
            if CharInSet(FSourceBuf[ FSourcePos + 1 ], [ 'A'..'Z', 'a'..'z', '0'..'9', '_' ]) then
            begin
              FTokenBuf.Write( FSourceBuf[ FSourcePos ] );
              Inc( FSourcePos );
            end
            else
              Break;
          end;

          '-' :
          begin{hyphenated words}
            if CharInSet(FSourceBuf[ FSourcePos + 1 ], [ 'A'..'Z', 'a'..'z', '0'..'9', '_' ]) then
            begin
              FTokenBuf.Write( FSourceBuf[ FSourcePos ] );
              Inc( FSourcePos );
            end
            else
              Break;
          end;

          else
            Break;
        end;{case}
      end;
      FToken.TokenType := HR_TOKEN_TEXT_SYMBOL;
      Break;{out of repeat}
    end;

    {numbers}
    if CharInSet(FSourceBuf[ FSourcePos ], [ '0'..'9' ]) or
       ( ( FSourceBuf[ FSourcePos ] = '-' ) and CharInSet(FSourceBuf[ FSourcePos + 1 ], [ '.', '0'..'9' ] )) then
    begin

      {integer numbers}
      FTokenBuf.Write( FSourceBuf[ FSourcePos ] );
      Inc( FSourcePos );
      while CharInSet(FSourceBuf[ FSourcePos ], [ '0'..'9' ]) do
      begin
        FTokenBuf.Write( FSourceBuf[ FSourcePos ] );
        Inc( FSourcePos );
        FToken.TokenType := HR_TOKEN_TEXT_INTEGER;
      end;

      {floating point numbers}
      while CharInSet(FSourceBuf[ FSourcePos ], [ '0'..'9', 'e', 'E', '+', '-' ]) or
            ( ( FSourceBuf[ FSourcePos ] = '.') and ( FSourceBuf[ FSourcePos + 1 ] <> '.' ) ) do
      begin
        FTokenBuf.Write( FSourceBuf[ FSourcePos ] );
        Inc( FSourcePos );
        FToken.TokenType := HR_TOKEN_TEXT_FLOAT;
      end;

      Break;{out of repeat}
    end;

    inherited GetNextToken;
    {Break;}{out of repeat}

  until( True );
end;


end.

