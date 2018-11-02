{*********************************************************}
{*                  O32RXNGN.PAS 4.06                    *}
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

{The following is a modified version of a Regex engine, which was originally
 written for Algorithms Alfresco. It is copyright(c)2001 by Julian M. Bucknall
 and is used here with permission.}

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

{Notes: these classes parse regular expressions that follow this grammar:

        <anchorexpr> ::= <expr> |
                         '^' <expr> |
                         <expr> '$' |
                         '^' <expr> '$'
        <expr> ::= <term> |
                   <term> '|' <expr>                 - alternation
        <term> ::= <factor> |
                   <factor><term>                    - concatenation
        <factor> ::= <atom> |
                     <atom> '?' |                    - zero or one
                     <atom> '*' |                    - zero or more
                     <atom> '+'                      - one or more
        <atom> ::= <char> |
                   '.' |                             - any char
                   '(' <expr> ') |                   - parentheses
                   '[' <charclass> ']' |             - normal class
                   '[^' <charclass> ']'              - negated class
        <charclass> ::= <charrange> |
                        <charrange><charclass>
        <charrange> ::= <ccchar> |
                        <ccchar> '-' <ccchar>
        <char> ::= <any character except metacharacters> |
                   '\' <any character at all>
        <ccchar> ::= <any character except '-' and ']'> |
                     '\' <any character at all>

        This means that parentheses have maximum precedence, followed
        by square brackets, followed by the closure operators,
        followed by concatenation, finally followed by alternation.}

unit o32rxngn;
  {Orpheus Regex Engine}

interface

uses
  Classes, SysUtils, O32IntDeq, O32IntLst, o32WideCharSet;

type
  PO32CharSet = ^TO32CharSet;
  TO32CharSet = TWideCharSet; // set of Ansichar;

  TO32NFAMatchType = ( {types of matching performed...}
     mtNone,           {..no match (an epsilon no-cost move)}
     mtAnyChar,        {..any character}
     mtChar,           {..a particular character}
     mtClass,          {..a character class}
     mtNegClass,       {..a negated character class}
     mtTerminal,       {..the final state--no matching}
     mtUnused);        {..an unused state--no matching}

  TO32RegexError = (   {error codes for invalid regex strings}
     recNone,          {..no error}
     recSuddenEnd,     {..unexpected end of string}
     recMetaChar,      {..read metacharacter, but needed normal char}
     recNoCloseParen,  {..expected close paren, but not there}
     recExtraChars);   {..extra characters at the end of the Regex string}

  TO32UpcaseChar = function (aCh : char) : char;

  {- Regex Engine Class}
  TO32RegexEngine = class
    protected {private}
      FAnchorEnd   : boolean;
      FAnchorStart : boolean;
      FErrorCode   : TO32RegexError;
      FIgnoreCase  : boolean;
      FPosn        : PChar;
      FRegexStr    : string;
      FStartState  : integer;
      FTable       : TList;
      FUpcase      : TO32UpcaseChar;
      FLogging     : Boolean;
      Log          : System.Text;
      FLogFile     : string;

      procedure SetLogFile(const Value: String);

      procedure rcSetIgnoreCase(aValue : boolean);
      procedure rcSetRegexStr(const aRegexStr : string);
      procedure rcSetUpcase(aValue : TO32UpcaseChar);
      procedure rcSetLogging(const aValue : Boolean);

      procedure rcClear;
      procedure rcLevel1Optimize;
      procedure rcLevel2Optimize;
      function rcMatchSubString(const S   : string;
                                StartPosn : integer) : boolean;
      function rcAddState(aMatchType : TO32NFAMatchType;
                          aChar      : char;
                          aCharClass : PO32CharSet;
                          aNextState1: integer;
                          aNextState2: integer) : integer;
      function rcSetState(aState     : integer;
                          aNextState1: integer;
                          aNextState2: integer) : integer;

      function rcParseAnchorExpr : integer;
      function rcParseAtom : integer;
      function rcParseCCChar : char;
      function rcParseChar : integer;
      function rcParseCharClass(aClass : PO32CharSet) : boolean;
      function rcParseCharRange(aClass : PO32CharSet) : boolean;
      function rcParseExpr : integer;
      function rcParseFactor : integer;
      function rcParseTerm : integer;

      procedure rcWalkNoCostTree(aList  : TO32IntList;
                                 aState : integer);
      procedure rcDumpTable;

    public
      constructor Create(const aRegexStr : string);
      destructor Destroy; override;

      function Parse(var aErrorPos : integer;
                     var aErrorCode: TO32RegexError) : boolean;
      function MatchString(const S : string) : integer;

      property IgnoreCase : boolean
                  read FIgnoreCase write rcSetIgnoreCase;
      property RegexString : string
                  read FRegexStr write rcSetRegexStr;
      property Upcase : TO32UpcaseChar
                  read FUpcase write rcSetUpcase;
      property Logging : Boolean
                  read FLogging write rcSetLogging;
      property LogFile : String read FLogFile write SetLogFile;
  end;

implementation

uses
  OVCStr;

const
  MetaCharacters: set of AnsiChar =
    ['?', '*', '+', '-', '.', '|', '(', ')', '[', ']', '^', '$'];

  {handy constants}
  UnusedState = -1;
  NewFinalState = -2;
  CreateNewState = -3;
  ErrorState = -4;
  MustScan = -5;

type
  PO32NFAState = ^TO32NFAState;
  TO32NFAState = record
    sdNextState1: integer;
    sdNextState2: integer;
    sdNextList  : TO32IntList;
    sdClass     : PO32CharSet;
    sdMatchType : TO32NFAMatchType;
    sdChar      : char;
  end;

{===TO32RegexEngine=================================================}
constructor TO32RegexEngine.Create(const aRegexStr : string);
begin
  inherited Create;
  FRegexStr := aRegexStr;
  FIgnoreCase := true;
  FUpcase := System.Upcase;
  FTable := TList.Create;
  FTable.Capacity := 64;
  FLogging := false;
end;
{--------}
destructor TO32RegexEngine.Destroy;
begin
  if (FTable <> nil) then begin
    rcClear;
    FTable.Free;
  end;
  inherited Destroy;
end;
{--------}
procedure TO32RegexEngine.rcSetLogging(const aValue : Boolean);
begin
  FLogging := aValue;
end;
{--------}
procedure TO32RegexEngine.SetLogFile(const Value: String);
begin
  FLogFile := Value;
end;
{--------}
function TO32RegexEngine.MatchString(const S : string) : integer;
var
  i : integer;
  ErrorPos  : integer;
  ErrorCode : TO32RegexError;
begin
  {if the regex string hasn't been parsed yet, do so}
  if (FTable.Count = 0) then begin
    if not Parse(ErrorPos, ErrorCode) then begin
      raise Exception.Create(
         Format('The regex was invalid at position %d', [ErrorPos]));
    end;
  end;
  {now try and see if the string matches (empty strings don't)}
  Result := 0;
  if (S <> '') then
    {if the regex specified a start anchor, then we only need to check
     the string starting at the first position}
    if FAnchorStart then begin
      if rcMatchSubString(S, 1) then
        Result := 1;
    end
    {otherwise we try and match the string at every position and
     return at the first success}
    else begin
      for i := 1 to length(S) do
        if rcMatchSubString(S, i) then begin
          Result := i;
          Break;
        end;
    end;
end;
{--------}
function TO32RegexEngine.Parse(var aErrorPos : integer;
                                var aErrorCode: TO32RegexError)
                                                            : boolean;
  procedure WriteError(aErrorPos : integer;
                       aErrorCode: TO32RegexError);
  begin
    writeln(Log, '***parse error found at ', aErrorPos);
    case aErrorCode of
      recNone         : writeln(Log, '-->no error');
      recSuddenEnd    : writeln(Log, '-->unexpected end of regex');
      recMetaChar     : writeln(Log, '-->found metacharacter in wrong place');
      recNoCloseParen : writeln(Log, '-->missing close paren');
      recExtraChars   : writeln(Log, '-->extra chars after valid regex');
    end;
    writeln(Log, '"', FRegexStr, '"');
    writeln(Log, '^':succ(aErrorPos));
  end;
begin
  result := false;
  if FLogging then begin
    if FLogFile = '' then FLogFile := 'Parse.log';
    System.Assign(Log, FLogFile);
    System.Rewrite(Log);
  end;

  try
    if FLogging then writeln(Log, 'Parsing regex: "', FRegexStr, '"');

    {clear the current transition table}
    rcClear;
    {empty regex strings are not allowed}
    if (FRegexStr = '') then begin
      aErrorPos := 1;
      aErrorCode := recSuddenEnd;

      if FLogging then WriteError(aErrorPos, aErrorCode);
      Exit;
    end;
    {parse the regex string}
    FPosn := PChar(FRegexStr);
    FStartState := rcParseAnchorExpr;

    {if an error occurred or we're not at the end of the regex string,
     clear the transition table, return false and the error position}
    if (FStartState = ErrorState) or (FPosn^ <> #0) then begin
      if (FStartState <> ErrorState) and (FPosn^ <> #0) then
        FErrorCode := recExtraChars;
      rcClear;
      aErrorPos := succ(FPosn - PChar(FRegexStr));
      aErrorCode := FErrorCode;

      if FLogging then WriteError(aErrorPos, aErrorCode);
    end
    {otherwise add a terminal state, optimize, return true}
    else begin
      rcAddState(mtTerminal, #0, nil, UnusedState, UnusedState);
      rcLevel1Optimize;
      rcLevel2Optimize;
      Result := true;
      aErrorPos := 0;
      aErrorCode := recNone;

      if FLogging then rcDumpTable;
    end;
  finally
    if FLogging then System.Close(Log);
  end;
end;
{--------}
function TO32RegexEngine.rcAddState(aMatchType : TO32NFAMatchType;
                                     aChar      : char;
                                     aCharClass : PO32CharSet;
                                     aNextState1: integer;
                                     aNextState2: integer) : integer;
var
  StateData : PO32NFAState;
begin
  {create the new state record}
  StateData := AllocMem(sizeof(TO32NFAState));
  {set up the fields in the state record}
  if (aNextState1 = NewFinalState) then
    StateData^.sdNextState1 := succ(FTable.Count)
  else
    StateData^.sdNextState1 := aNextState1;
  StateData^.sdNextState2 := aNextState2;
  StateData^.sdMatchType := aMatchType;
  if (aMatchType = mtChar) then
    StateData^.sdChar := aChar
  else if (aMatchType = mtClass) or (aMatchType = mtNegClass) then
    StateData^.sdClass := aCharClass;
  {add the new state}
  Result := FTable.Count;
  FTable.Add(StateData);
end;
{--------}
procedure TO32RegexEngine.rcClear;
var
  i : integer;
  StateData : PO32NFAState;
begin
  {free all items in the state transition table}
  for i := 0 to pred(FTable.Count) do begin
    StateData := PO32NFAState(FTable.List[i]);
    if (StateData <> nil) then begin
      with StateData^ do begin
        if (sdMatchType = mtClass) or
           (sdMatchType = mtNegClass) then
          if (sdClass <> nil) then
            FreeMem(StateData^.sdClass);
        sdNextList.Free;
      end;
      Dispose(StateData);
    end;
  end;
  {clear the state transition table}
  FTable.Clear;
  FTable.Capacity := 64;
  FAnchorStart := false;
  FAnchorEnd := false;
end;
{--------}
procedure TO32RegexEngine.rcDumpTable;
var
  i, j : integer;
begin
  writeln(Log);
  if (FTable.Count = 0) then
    writeln(Log, 'No transition table to dump!')
  else begin
    writeln(Log, 'Transition table dump for "', FRegexStr, '"');
    if FAnchorStart then
      writeln(Log, 'anchored at start of string');
    if FAnchorEnd then
      writeln(Log, 'anchored at end of string');
    writeln(Log, 'start state: ', FStartState:3);
    for i := 0 to pred(FTable.Count) do begin
      write(Log, i:3);
      with PO32NFAState(FTable[i])^ do begin
        case sdMatchType of
          mtNone    : write(Log, '  no match');
          mtAnyChar : write(Log, '  any char');
          mtChar    : write(Log, '    char:', sdChar);
          mtClass   : write(Log, '     class');
          mtNegClass: write(Log, ' neg class');
          mtTerminal: write(Log, '*******END');
          mtUnused  : write(Log, '        --');
        else
          write(Log, ' **error**');
        end;
        if (sdNextList <> nil) then begin
          write(Log, ' next:');
          for j := 0 to pred(sdNextList.Count) do
            write(Log, ' ', sdNextList[j]);
        end
        else begin
          if (sdMatchType <> mtTerminal) and
             (sdMatchType <> mtUnused) then begin
            write(Log, ' next1: ', sdNextState1:3);
            if (sdNextState2 <> UnusedState) then
              write(Log, ' next2: ', sdNextState2:3);
          end;
        end;
      end;
      writeln(Log);
    end;
  end;
end;
{--------}
procedure TO32RegexEngine.rcLevel1Optimize;
var
  i : integer;
  Walker : PO32NFAState;
begin
  {level 1 optimization removes all states that have only a single
   no-cost move to another state}

  {cycle through all the state records, except for the last one}
  for i := 0 to (FTable.Count - 2) do begin
    {get this state}
    with PO32NFAState(FTable.List[i])^ do begin
      {walk the chain pointed to by the first next state, unlinking
       the states that are simple single no-cost moves}
      Walker := PO32NFAState(FTable.List[sdNextState1]);
      while (Walker^.sdMatchType = mtNone) and
            (Walker^.sdNextState2 = UnusedState) do begin
        sdNextState1 := Walker^.sdNextState1;
        Walker := PO32NFAState(FTable.List[sdNextState1]);
      end;
      {walk the chain pointed to by the first next state, unlinking
       the states that are simple single no-cost moves}
      if (sdNextState2 <> UnusedState) then begin
        Walker := PO32NFAState(FTable.List[sdNextState2]);
        while (Walker^.sdMatchType = mtNone) and
              (Walker^.sdNextState2 = UnusedState) do begin
          sdNextState2 := Walker^.sdNextState1;
          Walker := PO32NFAState(FTable.List[sdNextState2]);
        end;
      end;
    end;
  end;
end;
{--------}
procedure TO32RegexEngine.rcLevel2Optimize;
var
  i : integer;
begin
  {level 2 optimization removes all no-cost moves, except for those
   from the start state, if that is a no-cost move state}

  {cycle through all the state records, except for the last one}
  for i := 0 to (FTable.Count - 2) do begin
    {get this state}
    with PO32NFAState(FTable.List[i])^ do begin
      {if it's not a no-cost move state or it's the start state...}
      if (sdMatchType <> mtNone) or (i = FStartState) then begin
        {create the state list}
        sdNextList := TO32IntList.Create;
        {walk the chain pointed to by the first next state, adding
         the non-no-cost states to the list}
        rcWalkNoCostTree(sdNextList, sdNextState1);
        {if this is the start state, and it's a no-cost move state
         walk the chain pointed to by the second next state, adding
         the non-no-cost states to the list}
        if (sdMatchType = mtNone) then
          rcWalkNoCostTree(sdNextList, sdNextState2);
      end;
    end;
  end;

  {cycle through all the state records, except for the last one,
   marking unused ones--not strictly necessary but good for debugging}
  for i := 0 to (FTable.Count - 2) do begin
    if (i <> FStartState) then
      with PO32NFAState(FTable.List[i])^ do begin
        if (sdMatchType = mtNone) then
          sdMatchType := mtUnused;
      end;
  end;
end;
{--------}
function TO32RegexEngine.rcMatchSubString(const S   : string;
                                           StartPosn : integer)
                                                            : boolean;
var
  i      : integer;
  Ch     : char;
  State  : integer;
  Deque  : TO32IntDeque;
  StrInx : integer;
begin
  {assume we fail to match}
  Result := false;
  {create the deque}
  Deque := TO32IntDeque.Create(64);
  try
    {enqueue the special value to start scanning}
    Deque.Enqueue(MustScan);
    {enqueue the first state}
    Deque.Enqueue(FStartState);
    {prepare the string index}
    StrInx := StartPosn - 1;
    Ch := #0; //just to fool the engine
    {loop until the deque is empty or we run out of string}
    while (StrInx <= length(S)) and not Deque.IsEmpty do begin
      {pop the top state from the deque}
      State := Deque.Pop;
      {process the "must scan" state first}
      if (State = MustScan) then begin
        {if the deque is empty at this point, we might as well give up
         since there are no states left to process new characters}
        if not Deque.IsEmpty then begin
          {if we haven't run out of string, get the character, and
           enqueue the "must scan" state again}
          inc(StrInx);
          if (StrInx <= length(S)) then begin
            if IgnoreCase then
              Ch := Upcase(S[StrInx])
            else
              Ch := S[StrInx];
            Deque.Enqueue(MustScan);
          end;
        end;
      end
      {otherwise, process the state}
      else with PO32NFAState(FTable.List[State])^ do begin
        case sdMatchType of
          mtNone :
            begin
              if (State <> FStartState) then
                Assert(false, 'no-cost states shouldn''t be seen');
              for i := 0 to pred(sdNextList.Count) do
                Deque.Push(sdNextList[i]);
            end;
          mtAnyChar :
            begin
              {for a match of any character, enqueue the next states}
              for i := 0 to pred(sdNextList.Count) do
                Deque.Enqueue(sdNextList[i]);
            end;
          mtChar :
            begin
              {for a match of a character, enqueue the next states}
              if (Ch = sdChar) then
                for i := 0 to pred(sdNextList.Count) do
                  Deque.Enqueue(sdNextList[i]);
            end;
          mtClass :
            begin
              {for a match within a class, enqueue the next states}
              if (Ch in sdClass^) then
                for i := 0 to pred(sdNextList.Count) do
                  Deque.Enqueue(sdNextList[i]);
            end;
          mtNegClass :
            begin
              {for a match not within a class, enqueue the next states}
              if not (Ch in sdClass^) then
                for i := 0 to pred(sdNextList.Count) do
                  Deque.Enqueue(sdNextList[i]);
            end;
          mtTerminal :
            begin
              {for a terminal state, the string successfully matched
               if the regex had no end anchor, or we're at the end
               of the string}
              if (not FAnchorEnd) or (StrInx > length(S)) then begin
                Result := true;
                Exit;
              end;
            end;
          mtUnused :
            begin
              Assert(false, 'unused state ' + IntToStr(State)
                + ' shouldn''t be seen');
            end;
        end;
      end;
    end;
    {if we reach this point we've either exhausted the deque or we've
     run out of string; if the former, the substring did not match
     since there are no more states. If the latter, we need to check
     the states left on the deque to see if one is the terminating
     state; if so the string matched the regular expression defined by
     the transition table}
    while not Deque.IsEmpty do begin
      State := Deque.Pop;
      with PO32NFAState(FTable.List[State])^ do begin
        case sdMatchType of
          mtTerminal :
            begin
              {for a terminal state, the string successfully matched
               if the regex had no end anchor, or we're at the end
               of the string}
              if (not FAnchorEnd) or (StrInx > length(S)) then begin
                Result := true;
                Exit;
              end;
            end;
        end;{case}
      end;
    end;
  finally
    Deque.Free;
  end;
end;
{--------}
function TO32RegexEngine.rcParseAnchorExpr : integer;
begin
  {check for an initial '^'}
  if (FPosn^ = '^') then begin
    FAnchorStart := true;
    inc(FPosn);

    if FLogging then writeln(Log, 'parsed start anchor');

  end;

  {parse an expression}
  Result := rcParseExpr;

  {if we were successful, check for the final '$'}
  if (Result <> ErrorState) then begin
    if (FPosn^ = '$') then begin
      FAnchorEnd := true;
      inc(FPosn);

      if FLogging then writeln(Log, 'parsed end anchor');
    end;
  end;
end;
{--------}
function TO32RegexEngine.rcParseAtom : integer;
var
  MatchType : TO32NFAMatchType;
  CharClass : PO32CharSet;
begin
  case FPosn^ of
    '(' :
      begin
        {move past the open parenthesis}
        inc(FPosn);

        if FLogging then writeln(Log, 'parsed open paren');

        {parse a complete regex between the parentheses}
        Result := rcParseExpr;
        if (Result = ErrorState) then
          Exit;
        {if the current character is not a close parenthesis,
         there's an error}
        if (FPosn^ <> ')') then begin
          FErrorCode := recNoCloseParen;
          Result := ErrorState;
          Exit;
        end;
        {move past the close parenthesis}
        inc(FPosn);

        if FLogging then writeln(Log, 'parsed close paren');
      end;
    '[' :
      begin
        {move past the open square bracket}
        inc(FPosn);

        if Logging then
          writeln(Log, 'parsed open square bracket (start of class)');

        {if the first character in the class is a '^' then the
         class if negated, otherwise it's a normal one}
        if (FPosn^ = '^') then begin
          inc(FPosn);
          MatchType := mtNegClass;

          if FLogging then writeln(Log, 'it is a negated class');
        end
        else begin
          MatchType := mtClass;

          if FLogging then writeln(Log, 'it is a normal class');
        end;
        {allocate the class character set and parse the character
         class; this will return either with an error, or when the
         closing square bracket is encountered}
        New(CharClass);
        CharClass^ := [];
        if not rcParseCharClass(CharClass) then begin
          Dispose(CharClass);
          Result := ErrorState;
          Exit;
        end;
        {move past the closing square bracket}
        Assert(FPosn^ = ']',
               'the rcParseCharClass terminated without finding a "]"');
        inc(FPosn);

        if Logging then
          writeln(Log, 'parsed close square bracket (end of class)');

        {add a new state for the character class}
        Result := rcAddState(MatchType, #0, CharClass,
                             NewFinalState, UnusedState);
      end;
    '.' :
      begin
        {move past the period metacharacter}
        inc(FPosn);

        if FLogging then writeln(Log, 'parsed anychar operator "."');

        {add a new state for the 'any character' token}
        Result := rcAddState(mtAnyChar, #0, nil,
                             NewFinalState, UnusedState);
      end;
  else
    {otherwise parse a single character}
    Result := rcParseChar;
  end;{case}
end;
{--------}
function TO32RegexEngine.rcParseCCChar : char;
begin
  {if we hit the end of the string, it's an error}
  if (FPosn^ = #0) then begin
    FErrorCode := recSuddenEnd;
    Result := #0;
    Exit;
  end;
  {if the current char is a metacharacter (at least in terms of a
   character class), it's an error}
  if CharInSet(FPosn^, [']', '-']) then begin
    FErrorCode := recMetaChar;
    Result := #0;
    Exit;
  end;
  {otherwise return the character and advance past it}
  if (FPosn^ = '\') then
    {..it's an escaped character: get the next character instead}
    inc(FPosn);
  Result := FPosn^;
  inc(FPosn);

  if FLogging then writeln(Log, 'parsed charclass char: "', Result, '"');

end;
{--------}
function TO32RegexEngine.rcParseChar : integer;
var
  Ch : char;
begin
  {if we hit the end of the string, it's an error}
  if (FPosn^ = #0) then begin
    Result := ErrorState;
    FErrorCode := recSuddenEnd;
    Exit;
  end;
  {if the current char is one of the metacharacters, it's an error}
  if CharInSet(FPosn^, MetaCharacters) then begin
    Result := ErrorState;
    FErrorCode := recMetaChar;
    Exit;
  end;
  {otherwise add a state for the character}
  {..if it's an escaped character: get the next character instead}
  if (FPosn^ = '\') then
    inc(FPosn);
  if IgnoreCase then
    Ch := Upcase(FPosn^)
  else
    Ch := FPosn^;
  Result := rcAddState(mtChar, Ch, nil, NewFinalState, UnusedState);
  inc(FPosn);

  if FLogging then writeln(Log, 'parsed char: "', Ch, '"');
end;
{--------}
function TO32RegexEngine.rcParseCharClass(aClass : PO32CharSet) : boolean;
begin
  {assume we can't parse a character class properly}
  Result := false;
  {parse a character range; if we can't there was an error and the
   caller will take care of it}
  if not rcParseCharRange(aClass) then
    Exit;
  {if the current character was not the right bracket, parse another
   character class (note: we're removing the tail recursion here)}
  while (FPosn^ <> ']') do begin
    if not rcParseCharRange(aClass) then
      Exit;
  end;
  {if we reach here we were successful}
  Result := true;
end;
{--------}
function TO32RegexEngine.rcParseCharRange(aClass : PO32CharSet) : boolean;
var
  StartChar : char;
  EndChar   : char;
  Ch        : char;
begin
  {assume we can't parse a character range properly}
  Result := false;
  {parse a single character; if it's null there was an error}
  StartChar := rcParseCCChar;
  if (StartChar = #0) then
    Exit;
  {if the current character is not a dash, the range consisted of a
   single character}
  if (FPosn^ <> '-') then begin
    if IgnoreCase then
      Include(aClass^, Upcase(StartChar))
    else
      Include(aClass^, StartChar)
  end
  {otherwise it's a real range, so get the character at the end of the
   range; if that's null, there was an error}
  else begin

    if FLogging then writeln(Log, '-range to-');

    inc(FPosn); {move past the '-'}
    EndChar := rcParseCCChar;
    if (EndChar = #0) then
      Exit;
    {build the range as a character set}
    if (StartChar > EndChar) then begin
      Ch := StartChar;
      StartChar := EndChar;
      EndChar := Ch;
    end;
    for Ch := StartChar to EndChar do begin
      Include(aClass^, Ch);
      if IgnoreCase then
        Include(aClass^, Upcase(Ch));
    end;
  end;
  {if we reach here we were successful}
  Result := true;
end;
{--------}
function TO32RegexEngine.rcParseExpr : integer;
var
  StartState1 : integer;
  StartState2 : integer;
  EndState1   : integer;
  OverallStartState : integer;
begin
  {assume the worst}
  Result := ErrorState;
  {parse an initial term}
  StartState1 := rcParseTerm;
  if (StartState1 = ErrorState) then
    Exit;
  {if the current character is *not* a pipe character, no alternation
   is present so return the start state of the initial term as our
   start state}
  if (FPosn^ <> '|') then
    Result := StartState1
  {otherwise, we need to parse another expr and join the two together
   in the transition table}
  else begin

    if FLogging then writeln(Log, 'OR (alternation)');

    {advance past the pipe}
    inc(FPosn);
    {the initial term's end state does not exist yet (although there
     is a state in the term that points to it), so create it}
    EndState1 := rcAddState(mtNone, #0, nil, UnusedState, UnusedState);
    {for the OR construction we need a new initial state: it will
     point to the initial term and the second just-about-to-be-parsed
     expr}
    OverallStartState := rcAddState(mtNone, #0, nil,
                                    UnusedState, UnusedState);
    {parse another expr}
    StartState2 := rcParseExpr;
    if (StartState2 = ErrorState) then
      Exit;
    {alter the state state for the overall expr so that the second
     link points to the start of the second expr}
    Result := rcSetState(OverallStartState, StartState1, StartState2);
    {now set the end state for the initial term to point to the final
     end state for the second expr and the overall expr}
    rcSetState(EndState1, FTable.Count, UnusedState);
  end;
end;
{--------}
function TO32RegexEngine.rcParseFactor : integer;
var
  StartStateAtom : integer;
  EndStateAtom   : integer;
begin
  {assume the worst}
  Result := ErrorState;
  {first parse an atom}
  StartStateAtom := rcParseAtom;
  if (StartStateAtom = ErrorState) then
    Exit;
  {check for a closure operator}
  case FPosn^ of
    '?' : begin
            if FLogging then writeln(Log, 'zero or one closure');

            {move past the ? operator}
            inc(FPosn);
            {the atom's end state doesn't exist yet, so create one}
            EndStateAtom := rcAddState(mtNone, #0, nil,
                                       UnusedState, UnusedState);
            {create a new start state for the overall regex}
            Result := rcAddState(mtNone, #0, nil,
                                 StartStateAtom, EndStateAtom);
            {make sure the new end state points to the next unused
             state}
            rcSetState(EndStateAtom, FTable.Count, UnusedState);
          end;
    '*' : begin
            if FLogging then writeln(Log, 'zero or more closure');

            {move past the * operator}
            inc(FPosn);
            {the atom's end state doesn't exist yet, so create one;
             it'll be the start of the overall regex subexpression}
            Result := rcAddState(mtNone, #0, nil,
                                 NewFinalState, StartStateAtom);
          end;
    '+' : begin
            if FLogging then writeln(Log, 'one or more closure');

            {move past the + operator}
            inc(FPosn);
            {the atom's end state doesn't exist yet, so create one}
            rcAddState(mtNone, #0, nil, NewFinalState, StartStateAtom);
            {the start of the overall regex subexpression will be the
             atom's start state}
            Result := StartStateAtom;
          end;
  else
    Result := StartStateAtom;
  end;{case}
end;
{--------}
function TO32RegexEngine.rcParseTerm : integer;
var
  StartState2 : integer;
  EndState1   : integer;
begin
  {parse an initial factor, the state number returned will also be our
   return state number}
  Result := rcParseFactor;
  if (Result = ErrorState) then
    Exit;
  {Note: we have to "break the grammar" here. We've parsed a regular
         subexpression and we're possibly following on with another
         regular subexpression. There's no nice operator to key off
         for concatenation: we just have to know that for
         concatenating two subexpressions, the current character will
         be
           - an open parenthesis
           - an open square bracket
           - an any char operator
           - a character that's not a metacharacter
         i.e., the three possibilities for the start of an "atom" in
         our grammar}
  if (FPosn^ = '(') or
     (FPosn^ = '[') or
     (FPosn^ = '.') or
     ((FPosn^ <> #0) and not CharInSet(FPosn^, MetaCharacters)) then begin
    if FLogging then writeln(Log, 'concatenation');

    {the initial factor's end state does not exist yet (although there
     is a state in the term that points to it), so create it}
    EndState1 := rcAddState(mtNone, #0, nil, UnusedState, UnusedState);
    {parse another term}
    StartState2 := rcParseTerm;
    if (StartState2 = ErrorState) then begin
      Result := ErrorState;
      Exit;
    end;
    {join the first factor to the second term}
    rcSetState(EndState1, StartState2, UnusedState);
  end;
end;
{--------}
procedure TO32RegexEngine.rcSetIgnoreCase(aValue : boolean);
begin
  if (aValue <> FIgnoreCase) then begin
    rcClear;
    FIgnoreCase := aValue;
  end;
end;
{--------}
procedure TO32RegexEngine.rcSetRegexStr(const aRegexStr : string);
begin
  if (aRegexStr <> FRegexStr) then begin
    rcClear;
    FRegexStr := aRegexStr;
  end;
end;
{--------}
function TO32RegexEngine.rcSetState(aState     : integer;
                                     aNextState1: integer;
                                     aNextState2: integer) : integer;
var
  StateData : PO32NFAState;
begin
  Assert((0 <= aState) and (aState < FTable.Count),
         'trying to change an invalid state');

  {get the state record and change the transition information}
  StateData := PO32NFAState(FTable.List[aState]);
  StateData^.sdNextState1 := aNextState1;
  StateData^.sdNextState2 := aNextState2;
  Result := aState;
end;
{--------}
procedure TO32RegexEngine.rcSetUpcase(aValue : TO32UpcaseChar);
begin
  if not Assigned(aValue) then
    FUpcase := System.Upcase
  else
    FUpcase := aValue;
end;
{--------}
procedure TO32RegexEngine.rcWalkNoCostTree(aList  : TO32IntList;
                                             aState : integer);
begin
  {look at this state's record...}
  with PO32NFAState(FTable.List[aState])^ do begin
    {if it's a no-cost state, recursively walk the
     first, then the second chain}
    if (sdMatchType = mtNone) then begin
      rcWalkNoCostTree(aList, sdNextState1);
      rcWalkNoCostTree(aList, sdNextState2);
    end
    {otherwise, add it to the list}
    else
      aList.Add(aState);
  end;
end;
{----}

end.
