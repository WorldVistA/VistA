//  HRParserPas v1.0.1 (25.Sep.2000)
//  Fast Pascal source code parser.
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
unit HRParserPas;

interface

uses
  HRParser, SysUtils;

const
  {THRParserPas tokens.}
  HR_TOKEN_PAS_COMMENT_BRACE_OPEN =   7;  //e.g. {
  HR_TOKEN_PAS_COMMENT_BRACE =        8;  //e.g. { }
  HR_TOKEN_PAS_COMMENT_BRACKET_OPEN = 9;  //e.g. (*
  HR_TOKEN_PAS_COMMENT_BRACKET =      10; //e.g. (* *)
  HR_TOKEN_PAS_COMMENT_SLASH =        11; //e.g. //
  HR_TOKEN_PAS_STRING_OPEN =          12; //e.g. '
  HR_TOKEN_PAS_STRING =               13; //e.g. ' '
  HR_TOKEN_PAS_EMBEDDEDCHAR =         14; //e.g. #10
  HR_TOKEN_PAS_HEX =                  15; //e.g. $A3

  HR_TOKEN_PAS_DESC : Array[ 0..15 ] of PChar = (
    'nil',
    'eof',
    'char',
    'space',
    'symbol',
    'integer',
    'float',
    'comment brace open',
    'comment brace',
    'comment bracket open',
    'comment bracket',
    'comment slash',
    'string open',
    'string',
    'embbeded char',
    'hex');

type
  THRParserPas = class( THRParserText )
  private
  protected
    procedure GetNextToken; override;
  public
    constructor Create; override;
    destructor Destroy; override;
  end;


implementation


{ T H R P a r s e r P a s }

constructor THRParserPas.Create;
begin
  inherited Create;
end;


destructor THRParserPas.Destroy;
begin
  inherited Destroy;
end;


procedure THRParserPas.GetNextToken;
begin
  repeat

    {comments} { } // - can go across multiple lines
    if FSourceBuf[ FSourcePos ] = '{' then
    begin
      {move past open comment}
      Inc( FSourcePos );
      while True do
      begin
        case FSourceBuf[ FSourcePos ] of
          #0 :
          begin
            FToken.TokenType := HR_TOKEN_PAS_COMMENT_BRACE_OPEN;
            Break;{out of while}
          end;
          '}' :
          begin
            FToken.TokenType := HR_TOKEN_PAS_COMMENT_BRACE;
            {move past close comment}
            Inc( FSourcePos );
            Break;{out of while}
          end;
          else
          begin
            FTokenBuf.Write( FSourceBuf[ FSourcePos ] );
            if FSourceBuf[ FSourcePos ] = #10 then IncLine;
            Inc( FSourcePos );
          end;
        end;
      end;
      Break;{out of repeat}
    end;

    {comments} (* *) // - can go across multiple lines
    if ( FSourceBuf[ FSourcePos ] = '(' ) and ( FSourceBuf[ FSourcePos + 1 ] = '*' ) then
    begin
      {Move past open comment}
      Inc( FSourcePos, 2 );
      while True do
      begin
        if FSourceBuf[ FSourcePos ] = #0 then
        begin
          FToken.TokenType := HR_TOKEN_PAS_COMMENT_BRACKET_OPEN;
          Break;{out of while}
        end;
        if ( ( FSourceBuf[ FSourcePos ] = '*' ) and ( FSourceBuf[ FSourcePos + 1 ] = ')' ) ) then
        begin
          FToken.TokenType := HR_TOKEN_PAS_COMMENT_BRACKET;
          {move past close comment}
          Inc( FSourcePos, 2 );
          Break;{out of while}
        end;
        FTokenBuf.Write( FSourceBuf[ FSourcePos ] );
        if FSourceBuf[ FSourcePos ] = #10 then IncLine;
        Inc( FSourcePos );
      end;
      Break;{out of repeat}
    end;

    {comments} // - remainder of current line
    if ( FSourceBuf[ FSourcePos ] = '/' ) and ( FSourceBuf[ FSourcePos + 1 ] = '/' ) then
    begin
      {move past open comment}
      Inc( FSourcePos, 2 );
      FToken.TokenType := HR_TOKEN_PAS_COMMENT_SLASH;
      while FSourceBuf[ FSourcePos ] <> #13 do
      begin
        FTokenBuf.Write( FSourceBuf[ FSourcePos ] );
        if FSourceBuf[ FSourcePos ] = #10 then IncLine;
        Inc( FSourcePos );
      end;
      Break;{out of repeat}
    end;

    {quoted strings}
    if FSourceBuf[ FSourcePos ] = '''' then
    begin
      {Move past open quote}
      Inc( FSourcePos );
      while True do
      begin
        case FSourceBuf[ FSourcePos ] of
          #0, #10, #13 :
          begin
            FToken.TokenType := HR_TOKEN_PAS_STRING_OPEN;
            Break;{out of while}
          end;
          '''' :
          begin
            FToken.TokenType := HR_TOKEN_PAS_STRING;
            Break;{out of while}
          end;
          else
          begin
            FTokenBuf.Write( FSourceBuf[ FSourcePos ] );
            Inc( FSourcePos );
          end;
        end;
      end;
      {move past close quote}
      Inc( FSourcePos );
      Break;{out of repeat}
    end;

    {embedded ascii eg #13}
    if FSourceBuf[ FSourcePos ] = '#' then
    begin
      //FTokenBuf.Write(FSourceBuf[FSourcePos]);
      Inc( FSourcePos );
      while CharInSet(FSourceBuf[ FSourcePos ], [ '0'..'9' ]) do
      begin
        FTokenBuf.Write( FSourceBuf[ FSourcePos ] );
        Inc( FSourcePos );
      end;
      FToken.TokenType := HR_TOKEN_PAS_EMBEDDEDCHAR;
      Break;{out of repeat}
    end;

    {hex numbers}
    if FSourceBuf[ FSourcePos ] = '$' then
    begin
      //FTokenBuf.Write(FSourceBuf[FSourcePos]);
      Inc( FSourcePos );
      while CharInSet(FSourceBuf[ FSourcePos ], [ '0'..'9', 'A'..'F', 'a'..'f' ]) do
        begin
        FTokenBuf.Write( FSourceBuf[ FSourcePos ] );
        Inc( FSourcePos );
        end;
      FToken.TokenType := HR_TOKEN_PAS_HEX;
      Break;{out of repeat}
    end;

    inherited GetNextToken;
    {Break;}{out of repeat}

  until( True );
end;


end.
