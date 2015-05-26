//---------------------------------------------------------------------------
// Copyright 2014 The Open Source Electronic Health Record Alliance
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

unit WinSCard;

{
Date Created: 12/22/2014
Site Name: OSEHRA
Developer: Joseph Snyder (snyderj@osehra.org)
Description: Function signatures for Windows Smart Card connections
}

interface

uses  Windows;

const
  // All SCard functions are found in the Winscard dynamic link library
  WinSCardDLL = 'Winscard.dll';
 //  http://pyscard.sourceforge.net/epydoc/smartcard.scard.scard-module.html
  SCARD_LEAVE_CARD = 0;
  SCARD_RESET_CARD = 1;
  SCARD_UNPOWER_CARD = 2;
  SCARD_EJECT_CARD = 3;

  SCARD_SCOPE_USER = 0;
  SCARD_SCOPE_TERMINAL = 1;
  SCARD_SCOPE_SYSTEM = 2;

  SCARD_SHARE_SHARED = 2;
  SCARD_SHARE_EXCLUSIVE = 1;
  SCARD_SHARE_DIRECT = 3;

  CARD_STATE_UNAWARE = 0;
  SCARD_STATE_IGNORE = 1;
  SCARD_STATE_CHANGED = 2;
  SCARD_STATE_UNKNOWN = 4;
  SCARD_STATE_UNAVAILABLE = 8;
  SCARD_STATE_EMPTY = 16;
  SCARD_STATE_PRESENT = 32;
  SCARD_STATE_ATRMATCH = 64;
  SCARD_STATE_EXCLUSIVE = 128;
  SCARD_STATE_INUSE = 256;
  SCARD_STATE_MUTE = 512;

  SCARD_PROTOCOL_UNDEFINED = 0;
  SCARD_PROTOCOL_T0 = 1;
  SCARD_PROTOCOL_T1 = 2;
  SCARD_PROTOCOL_RAW = 65536;
  SCARD_S_SUCCESS=0;
  SCARD_AUTOALLOCATE=DWORD(-1);

type

  SCARDCONTEXT = DWORD;
  function SCardReleaseContext(hContext: ULONG):DWORD; stdcall;
  function SCardDisconnect(hContext:DWORD; dwDisposition: DWORD):DWORD; stdcall;
  function SCardReconnect(hContext: DWORD;dwshareMode:DWORD;dwPrefProtocol: DWORD; dwInitialization:DWORD;var pdwActiveProtocol:LongInt):DWORD; stdcall;
  function SCardEstablishContext(dwScope:DWORD;pvReserved1:pointer;pvReserved2:pointer;phContext:pointer):DWORD; stdcall;
  function SCardListReadersA(hContext: SCARDCONTEXT;mszGroups:pointer;mszReaders:pointer;var pcchReaders: integer):DWORD; stdcall;
  function SCardConnectA(hContext: SCARDCONTEXT;szReader:pointer;dwShareMode:DWORD;dwPreferredProtocols:DWORD;var hCardContext;pdwActiveProtocol:pointer):DWORD; stdcall;

implementation

  function SCardReleaseContext(hContext: ULONG):DWORD; external WinSCardDLL name 'SCardReleaseContext';
  function SCardDisconnect(hContext:DWORD; dwDisposition: DWORD):DWORD; external WinSCardDLL name 'SCardDisconnect';
  function SCardReconnect(hContext: DWORD;dwShareMode:DWORD;dwPrefProtocol: DWORD; dwInitialization:DWORD;var pdwActiveProtocol:LongInt):DWORD; external WinSCardDLL name 'SCardReconnect';
  function SCardEstablishContext(dwScope:DWORD;pvReserved1:pointer;pvReserved2:pointer;phContext:pointer):DWORD; external WinSCardDLL name 'SCardEstablishContext';
  function SCardListReadersA(hContext: SCARDCONTEXT;mszGroups:pointer;mszReaders:pointer;var pcchReaders:integer):DWORD; external WinSCardDLL name 'SCardListReadersA';
  function SCardConnectA(hContext: SCARDCONTEXT;szReader:pointer;dwShareMode:DWORD;dwPreferredProtocols:DWORD;var hCardContext;pdwActiveProtocol:pointer):DWORD; external WinSCardDLL name 'SCardConnectA';


end.