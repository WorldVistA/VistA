//  HRBuffers v0.3.1 (03.Aug.2000)
//  Simple buffer classes
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
unit HRBuffers;

interface

uses
  Classes, SysUtils;

type
  {Base buffer.}
  THRBuffer=class(TObject)
    private
      FBuffer:PChar;
      FSize:LongInt;
      procedure SetSize(Value:LongInt);
      procedure CreateBuffer(const Size:LongInt);
      procedure ResizeBuffer(const Size:LongInt);
      procedure FreeBuffer;
    protected
      function GetItems(Index:LongInt):Char; virtual;
      procedure SetItems(Index:LongInt;Value:Char); virtual;
    public
      constructor Create; virtual;
      destructor Destroy; override;
      property Buffer:PChar read FBuffer;
      property Size:Longint read FSize write SetSize;
      property Items[Index:LongInt]:Char read GetItems write SetItems; default;
    end;

  {Base buffer with EOB.}
  THRBufferEOB=class(THRBuffer)
    private
    protected
      function GetEOB:Boolean; virtual;
    public
      property EOB:Boolean read GetEOB;
    end;


  {Buffer for holding a series of char.}
  THRBufferChar=class(THRBufferEOB)
    private
      FEOB:Boolean;
      FPosition:Longint;
    protected
      function GetEOB:Boolean; override;
      function GetItems(Index:LongInt):Char; override;
      procedure SetItems(Index:LongInt;Value:Char); override;
      function GetAsPChar:PChar;
      procedure SetAsPChar(Value:PChar);
      function GetAsString:string;
      procedure SetAsString(Value:string);
    public
      constructor Create; override;
      destructor Destroy; override;
      property Buffer;
      property Position:Longint read FPosition write FPosition;
      procedure Write(const Value:Char);
      function Read:Char;
      procedure WritePChar(const Str:PChar);
      procedure WriteString(const Str:String);
      property AsPChar:PChar read GetAsPChar write SetAsPChar;
      property AsString:string read GetAsString write SetAsString;
    end;


  {Buffer for reading from a stream.}
  THRBufferStream=class(THRBufferEOB)
    private
      FEOB:Boolean;
      FStream:TStream;
      FStreamSize:Longint;
      FFirstPosInBuffer:LongInt;
    protected
      function GetEOB:Boolean; override;
      function GetItems(Index:LongInt):Char; override;
      procedure SetItems(Index:LongInt;Value:Char); override;
      procedure SetStream(Value:TStream);
    public
      constructor Create; override;
      destructor Destroy; override;
      property Stream:TStream read FStream write SetStream;
    end;

  {A buffer containing a list of smaller buffers in one piece of contiguous memory.}
  THRBufferList=class(THRBuffer)
    private
      function GetItemPos(const Index:Integer):Integer;
      function GetCount:Integer;
      function GetItemSize(Index:Integer):Integer;
      procedure SetItemSize(Index:Integer;Value:Integer);
      function GetItemBuffer(Index:Integer):PChar;
    public
      constructor Create; override;
      destructor Destroy; override;
      procedure Add(const Index,ItemSize:Integer);
      procedure Delete(const Index:Integer);
      property Count:Integer read GetCount;
      property ItemSize[Index:Integer]:Integer read GetItemSize write SetItemSize;
      property ItemBuffer[Index:Integer]:PChar read GetItemBuffer;
    end;


implementation


{ T H R B u f f e r }

constructor THRBuffer.Create;
begin
FBuffer:=nil;
FSize:=0;
end;

destructor THRBuffer.Destroy;
begin
FreeBuffer;
inherited Destroy;
end;


procedure THRBuffer.SetSize(Value:LongInt);
begin
if FBuffer=nil
then
  CreateBuffer(Value)
else
  if Value>0
  then
    ResizeBuffer(Value)
  else
    FreeBuffer;
end;


function THRBuffer.GetItems(Index:LongInt):Char;
begin
Result:=#0;
end;


procedure THRBuffer.SetItems(Index:LongInt;Value:Char);
begin
end;


procedure THRBuffer.CreateBuffer(const Size:LongInt);
begin
if FBuffer=nil
then
  begin
  FSize:=Size;
  GetMem(FBuffer,FSize+1);
  {Null terminate end of buffer.}
  FBuffer[FSize]:=#0;
  end;
end;


procedure THRBuffer.ResizeBuffer(const Size:LongInt);
var
  New:PChar;
  MoveSize:LongInt;
begin
if FBuffer<>nil
then
  begin
  GetMem(New,Size+1);
  if FSize>Size then MoveSize:=Size else MoveSize:=FSize;
  Move(FBuffer[0],New[0],MoveSize);
  FreeMem(FBuffer,FSize+1);
  FBuffer:=New;
  FSize:=Size;
  FBuffer[FSize]:=#0;
  end;
end;


procedure THRBuffer.FreeBuffer;
begin
if FBuffer<>nil
then
  begin
  FreeMem(FBuffer,FSize+1);
  FBuffer:=nil;
  FSize:=0;
  end;
end;


{ T H R B u f f e r E O B }

function THRBufferEOB.GetEOB:Boolean;
begin
Result:=True;
end;


{ T H R B u f f e r C h a r }

constructor THRBufferChar.Create;
begin
inherited Create;
FEOB:=False;
end;


destructor THRBufferChar.Destroy;
begin
inherited Destroy;
end;


function THRBufferChar.GetEOB:Boolean;
begin
Result:=FEOB;
end;


function THRBufferChar.GetItems(Index:LongInt):Char;
begin
if Index<FSize
then
  begin
  Result:=FBuffer[Index];
  FEOB:=False;
  end
else
  begin
  Result:=#0;
  FEOB:=True;
  end;
end;


procedure THRBufferChar.SetItems(Index:LongInt;Value:Char);
begin
if Index<FSize
then
  begin
  FBuffer[Index]:=Value;
  FEOB:=False;
  end
else
  begin
  FEOB:=True;
  end;
end;


function THRBufferChar.Read:Char;
begin
if FPosition<FSize
then
  begin
  Result:=FBuffer[FPosition];
  Inc(FPosition);
  FEOB:=False;
  end
else
  begin
  Result:=#0;
  FEOB:=True;
  end;
end;


procedure THRBufferChar.Write(const Value:Char);
begin
if FPosition<FSize
then
  begin
  FBuffer[FPosition]:=Value;
  Inc(FPosition);
  FEOB:=False;
  end
else
  begin
  FEOB:=True;
  end;
end;


procedure THRBufferChar.WritePChar(const Str:PChar);
var
  i:Integer;
begin
for i:=0 to StrLen(Str)-1 do Write(Str[i]);
end;


procedure THRBufferChar.WriteString(const Str:String);
var
  i:Integer;
begin
for i:=1 to Length(Str) do Write(Str[i]);
end;


function THRBufferChar.GetAsPChar:PChar;
begin
Result:=FBuffer;
end;


procedure THRBufferChar.SetAsPChar(Value:PChar);
var
  L:Integer;
begin
L:=StrLen(Value);
if L<=FSize
then
  begin
  {Copies from value buffer to FBuffer.}
  StrMove(FBuffer,Value,L);
  FEOB:=False;
  end
else
  begin
  FEOB:=True;
  end;
end;


function THRBufferChar.GetAsString:string;
begin
Result:='';
end;


procedure THRBufferChar.SetAsString(Value:string);
begin
end;




{ T H R B u f f e r S t r e a m }


constructor THRBufferStream.Create;
begin
inherited Create;
FStream:=nil;
FFirstPosInBuffer:=-1;
end;


destructor THRBufferStream.Destroy;
begin
inherited Destroy;
end;


procedure THRBufferStream.SetStream(Value:TStream);
begin
if Value<>FStream
then
  begin
  FStream:=Value;
  FStreamSize:=FStream.Size;
  FFirstPosInBuffer:=-1;
  end;
end;


function THRBufferStream.GetEOB:Boolean;
begin
Result:=FEOB;
end;


function THRBufferStream.GetItems(Index:LongInt):Char;
begin
if Index<FStreamSize
then
  begin
  if (Index>=FFirstPosInBuffer+FSize) or
     (Index<FFirstPosInBuffer) or
     (FFirstPosInBuffer=-1)
  then
    begin
    {Read next block from stream into buffer.}
    FStream.Position:=Index;
    FStream.Read(FBuffer[0],FSize);
    FFirstPosInBuffer:=Index;
    end;
  {Read from buffer}
  Result:=FBuffer[Index-FFirstPosInBuffer];
  FEOB:=False;
  end
else
  begin
  {EOB}
  Result:=#0;
  FEOB:=True;
  end;
end;


procedure THRBufferStream.SetItems(Index:LongInt;Value:Char);
begin
end;


{ T H R B u f f e r L i s t }

type
  PHRInteger=^Integer;


constructor THRBufferList.Create;
begin
inherited Create;
{Set count to zero.}
Size:=SizeOf(Integer);
PHRInteger(Buffer)^:=0;
end;


destructor THRBufferList.Destroy;
begin
inherited Destroy;
end;


function THRBufferList.GetItemPos(const Index:Integer):Integer;
var
  PosIndex:Integer;
  Pos:Integer;
  PosItemSize:Integer;
begin
{Check for out of bounds index.}
Assert(Index<PHRInteger(Buffer)^,'Index out of bounds');
{Step past count.}
Pos:=SizeOf(Integer);
{Loop thought items.}
PosIndex:=0;
while PosIndex<Index do
  begin
  {Get item size.}
  PosItemSize:=PHRInteger(Buffer+Pos)^;
  {Step over item.}
  Pos:=Pos+SizeOf(Integer)+PosItemSize;
  Inc(PosIndex);
  end;
Result:=Pos;
end;


function THRBufferList.GetCount:Integer;
begin
Result:=PHRInteger(Buffer)^;
end;


function THRBufferList.GetItemSize(Index:Integer):Integer;
begin
Result:=PHRInteger(Buffer+GetItemPos(Index))^;
end;


procedure THRBufferList.SetItemSize(Index:Integer;Value:Integer);
var
  Pos:Integer;
  ItemSize:Integer;
  Diff:Integer;
  OldSize:Integer;
  S,D:PChar;
  C:Integer;
begin
Pos:=GetItemPos(Index);

{Calc diff is size.}
ItemSize:=PHRInteger(Buffer+Pos)^;
Diff:=Value-ItemSize;

{No change in size.}
if Diff=0 then Exit;

if Diff<0
then
  begin
  {Shrink buffer}
  {Move items > index down buffer.}
  S:=Buffer+Pos+SizeOf(Integer)+ItemSize;
  D:=S+Diff;
  C:=Size-(Pos+SizeOf(Integer)+ItemSize);
  Move(S[0],D[0],C);
  {Dec buffer size}
  Size:=Size+Diff;
  end
else
  begin
  {Grow buffer}
  OldSize:=Size;
  {Inc buffer size}
  Size:=Size+Diff;
  {Move items > index up buffer.}
  S:=Buffer+Pos+SizeOf(Integer)+ItemSize;
  D:=S+Diff;
  C:=OldSize-(Pos+SizeOf(Integer)+ItemSize);
  Move(S[0],D[0],C);
  end;

{Set items new size.}
PHRInteger(Buffer+Pos)^:=Value;
end;


function THRBufferList.GetItemBuffer(Index:Integer):PChar;
begin
Result:=Buffer+GetItemPos(Index)+SizeOf(Integer);
end;


procedure THRBufferList.Add(const Index,ItemSize:Integer);
var
  PosIndex:Integer;
  Pos:Integer;
  PosItemSize:Integer;
  OldSize:Integer;
  S,D:PChar;
  C:Integer;
begin
{Step past count.}
Pos:=SizeOf(Integer);

{Step thought list until up to index or end list.}
PosIndex:=0;
while (PosIndex<Index)and(PosIndex<=PHRInteger(Buffer)^-1) do
  begin
  {Get item size.}
  PosItemSize:=PHRInteger(Buffer+Pos)^;
  {Step over item.}
  Pos:=Pos+SizeOf(Integer)+PosItemSize;
  Inc(PosIndex);
  end;

{Pad list with empty items up to index.}
while (PosIndex<Index) do
  begin
  {Add item.}
  Size:=Size+SizeOf(Integer);
  {Set size of item to zero.}
  PHRInteger(Buffer+Pos)^:=0;
  {Inc count}
  Inc(PHRInteger(Buffer)^);
  {Step over item.}
  Pos:=Pos+SizeOf(Integer);
  Inc(PosIndex);
  end;

{Resize buffer to accomodate new item.}
OldSize:=Size;
Size:=Size+SizeOf(Integer)+ItemSize;

{Push any items > index up buffer.}
if PosIndex<=PHRInteger(Buffer)^-1
then
  begin
  S:=Buffer+Pos;
  D:=Buffer+Pos+SizeOf(Integer)+ItemSize;
  C:=OldSize-Pos;
  Move(S[0],D[0],C);
  end;

{Set size of item.}
PHRInteger(Buffer+Pos)^:=ItemSize;
{Inc count.}
Inc(PHRInteger(Buffer)^);
end;


procedure THRBufferList.Delete(const Index:Integer);
begin
// find index
// get size
// move everthing > index down by sizeof(Integer) + index[size]
// dec buffer size by sizeof(Integer) + index[size]
// dec count
end;


end.
