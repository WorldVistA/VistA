//---------------------------------------------------------------------------
// Copyright 2014 The Open Source Electronic Health Record Alliance
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//---------------------------------------------------------------------------
{$Optimization off}
unit UTWinSCard;
interface
uses UnitTest, TestFrameWork, WinSCard, SysUtils, Windows, Registry, Dialogs,
     Classes, Forms, Controls, StdCtrls, XuDsigConst;

implementation
type
UTWinSCardTests=class(TTestCase)
  private
  public
    procedure SetUp; override;
    procedure TearDown; override;

  published
    procedure TestSCardEstablishContext;
    procedure TestSCardListReaders;
    procedure TestSCardReleaseContext;
    procedure TestSCardConnectA;
    procedure TestSCardDisconnect;
    procedure TestSCardReconnect;
end;

procedure UTWinSCardTests.SetUp;
begin
end;

procedure UTWinSCardTests.TearDown;
begin
end;

procedure UTWinSCardTests.TestSCardEstablishContext;
var
  result: ULONG;
  outpointer:DWORD;
begin
  WriteLn(Output,'Start EstablishContext');
  result := WinSCard.SCardEstablishContext(SCARD_SCOPE_USER, nil,nil, @outpointer);
  if(not (result = 0)) then WriteLn(Output,'SCard Establish Context' + IntToStr(GetLastError()));
  CheckEquals(result,SCARD_S_SUCCESS,'SCard Establish Context failed') ;
  WriteLn(Output,'Stop EstablishContext');
end;


procedure UTWinSCardTests.TestSCardReleaseContext;
var
  result: ULONG;
  outpointer:DWORD;
begin
  WriteLn(Output,'Start ReleaseContext');
  result := WinSCard.SCardEstablishContext(SCARD_SCOPE_USER, nil,nil, @outpointer);
  result := WinSCard.SCardReleaseContext(outpointer);
  if(not (result = 0)) then WriteLn(Output,'SCard Establish Context' + IntToStr(GetLastError()));
  CheckEquals(result,SCARD_S_SUCCESS,'SCard Establish Context failed') ;
  WriteLn(Output,'Stop ReleaseContext');
end;


procedure UTWinSCardTests.TestSCardListReaders;
var
  result: integer;
  outpointer:DWORD;
  readerlength : integer;
  readerList : string;
begin
  WriteLn(Output,'Start ListReaders');
  result := WinSCard.SCardEstablishContext(
            SCARD_SCOPE_USER,
            nil,nil,
            @outpointer);
  result := WinSCard.SCardListReadersA(outpointer,nil,nil,readerlength);
  setLength(readerList,readerLength);
  result := WinSCard.SCardListReadersA(outpointer,nil,pChar(readerList),readerlength);
  if(not (result = 0)) then WriteLn(Output,'SCard Establish Context' + IntToStr(GetLastError()));
  CheckEquals(result,0,'SCard List Readers failed.   If result is 8010002E (2148532270):'+
                                      ' No SCard readers were found on the system');
  WinSCard.SCardReleaseContext(outpointer)   ;
  WriteLn(Output,'Stop ListReaders');
end;

procedure UTWinSCardTests.TestSCardConnectA;
var
  result: ULONG;
  outpointer:  sCardContext;
  scHandle: DWORD;
  ActiveProtocol:  longint;
  readerlength : integer;
  readerList,Str : string;
begin
  WriteLn(Output,'Start ConnectA');
  result := WinSCard.SCardEstablishContext(SCARD_SCOPE_USER, nil,nil, @outpointer);
  WinSCard.SCardListReadersA(outpointer,nil,nil,readerlength);
  setLength(readerList,readerLength);
  WinSCard.SCardListReadersA(outpointer,nil,pChar(readerList),readerlength);
  Str := StrPas(PChar(readerList));
  result := WinSCard.SCardConnectA(outpointer,
                                   pChar(Str),
                                   SCARD_SHARE_SHARED,
                                   SCARD_PROTOCOL_T1 or SCARD_PROTOCOL_T0,
                                   scHandle,
                                   @ActiveProtocol);

  CheckEquals(result,0,'SCardConnect a did not return success,2148532329 ' +
              'signifies that a card is not found in the ' + Str + ' reader.  ' +
              'All subsequent tests will return "6" due to the connection failing');
  WinSCard.SCardDisconnect(scHandle,SCARD_LEAVE_CARD);
  WinSCard.SCardReleaseContext(outpointer) ;
  WriteLn(Output,'Stop ConnectA');
end;

procedure UTWinSCardTests.TestSCardDisconnect;
var
  result: ULONG;
  outpointer:  sCardContext;
  scHandle: DWORD;
  ActiveProtocol:  longint;
  readerlength : integer;
  readerList,Str : string;
begin
  WriteLn(Output,'Start Disconnect');
  result := WinSCard.SCardEstablishContext(SCARD_SCOPE_USER, nil,nil, @outpointer);
  WinSCard.SCardListReadersA(outpointer,nil,nil,readerlength);
  setLength(readerList,readerLength);
  WinSCard.SCardListReadersA(outpointer,nil,pChar(readerList),readerlength);
  Str := StrPas(PChar(readerList));
  result := WinSCard.SCardConnectA(outpointer,
                                   pChar(Str),
                                   SCARD_SHARE_SHARED,
                                   SCARD_PROTOCOL_T1 or SCARD_PROTOCOL_T0,
                                   scHandle,
                                   @ActiveProtocol);
  result := WinSCard.SCardDisconnect(scHandle,SCARD_LEAVE_CARD);
  CheckEquals(result,0,'SCardDisconnect did not return success');
  WinSCard.SCardReleaseContext(outpointer);
  WriteLn(Output,'Stop Disconnect');
end;

procedure UTWinSCardTests.TestSCardReconnect;
var
  result: ULONG;
  outpointer:  sCardContext;
  scHandle: DWORD;
  ActiveProtocol:  longint;
  readerlength : integer;
  readerList,Str : string;
begin
  WriteLn(Output,'Start Reconnect');
  result := WinSCard.SCardEstablishContext(SCARD_SCOPE_USER, nil,nil, @outpointer);
  WinSCard.SCardListReadersA(outpointer,nil,nil,readerlength);
  setLength(readerList,readerLength);
  WinSCard.SCardListReadersA(outpointer,nil,pChar(readerList),readerlength);
  Str := StrPas(PChar(readerList));
  result := WinSCard.SCardConnectA(outpointer,
                                   pChar(Str),
                                   SCARD_SHARE_SHARED,
                                   SCARD_PROTOCOL_T1 or SCARD_PROTOCOL_T0,
                                   scHandle,
                                   @ActiveProtocol);

  result := WinSCard.SCardReconnect(scHandle,
                                    SCARD_SHARE_SHARED,
                                    SCARD_PROTOCOL_T1 or SCARD_PROTOCOL_T0,
                                    SCARD_RESET_CARD,
                                    ActiveProtocol);
  CheckEquals(result,0,'SCardReconnectA did not return success');
  WinSCard.SCardReleaseContext(outpointer);
  WinSCard.SCardDisconnect(scHandle,SCARD_LEAVE_CARD);
  WriteLn(Output,'Stop Reconnect');
end;

begin
  UnitTest.addSuite(UTWinSCardTests.Suite);
end.