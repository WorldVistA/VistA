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

{
Date Created: 12/22/2014
Site Name: OSEHRA
Developer: Joseph Snyder (snyderj@osehra.org)
Description: Base64 encoding using EncdDecd Library
}
unit XlfMime;

interface

uses  Windows,StrUtils,SysUtils,Registry, Dialogs, Classes, Forms, Controls,
  StdCtrls,EncdDecd;
function MimeEncodedSize(dwlen:DWORD):DWORD;
procedure MimeEncode(var hashVal;dwLen: DWORD;var hashStr);
function MimeEncodeString(hashVal:string): string;
function MimeDecodeString(hashedStr: string):string;


implementation
  function MimeEncodedSize(dwlen:DWORD):DWORD;
  begin
    Result := (dwlen +2) div 3 * 4;
  end;

  {This procedure takes a pointer to an array of byte values,
  the length of that array, and a pointer to an output string

  It will turn the array byte values into a memory stream that will
  be supplied to the SOAP.EncdDecd.EnocdeStream function for encoding.

  The information is read from the OutStream and placed into the output
  pointer

  }
  procedure MimeEncode(var hashVal;dwLen: DWORD; var hashStr);
  const
    Map: array[0..63] of Char = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
      'abcdefghijklmnopqrstuvwxyz0123456789+/';
  var
    //Counter Variable
    i: DWORD;
    swap :AnsiString;
    pHashVal : pByte;
    pHashStr : pAnsiChar;
    instream,outstream: TMemoryStream;
  begin
    //Initialize streams and pointers

    InStream:= TMemoryStream.Create;
    OutStream:= TMemoryStream.Create;
    pHashVal := @hashVal;
    pHashStr := Addr(hashStr);

    { For each value in the hashVal, write it into the buffer of the stream
    * then increment the pointer to capture the next value.
    }
    for i := 0 to (dwLen-1) do
    begin
      InStream.WriteBuffer(pHashVal^,1);
      Inc(pHashVal);
    end;
    //Go to the beginning of the stream
    InStream.Seek(0,soFromBeginning);

    //Use the SOAP.EncdDecd to encode the value in the stream
    EncdDecd.EncodeStream(InStream,OutStream);

    //Go to the beginning of the output stream
    OutStream.Seek(0,soFromBeginning);

    //Set swap to the value of the contents of the output stream
    SetString(swap, PChar(OutStream.memory), OutStream.Size);

    // For each character in the swap string that isnt '\r' or '\n',
    //write it to a value in the output pointer,

    //EncodeStream puts a carriage return after ~75 characters, they shouldn't be
    //carried through
    for i := 1 to Length(swap) do
    begin
      if(not ((swap[i] = #10) or (swap[i] = #13))) then
      begin
        pHashStr^ := swap[i];
        inc(pHashStr)
      end;
    end;
    Instream.Free;
    OutStream.Free;
  end;

  function MimeEncodeString(hashVal: string): string;
  begin
    //When given a string, use the SOAP.EncdDecd library to
    //Encode the string directly
    Result := EncdDecd.EncodeString(hashVal);
  end;

  function MimeDecodeString(hashedStr : string) : string;
  begin
    //When given a string, use the SOAP.EncdDecd library to
    //Decode the string directly
    Result := EncdDecd.DecodeString(hashedStr);
  end;
end.
