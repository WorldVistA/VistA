unit TestOvcFileViewer;

interface

uses
  TestFramework, ClipBrd, StrUtils,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ovcbase, ovcviewr;

type
  TOvcFileViewerForm = class(TForm)
    OvcFileViewer: TOvcFileViewer;
    procedure open(const FN:string);
  end;

  TTestOvcFileViewer = class(TTestCase)
  private
    FForm: TOvcFileViewerForm;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestActualColumn;
    procedure TestCopyToClipboard;
    procedure TestEffectiveColumn;
    procedure TestGetLine;
    procedure TestGetLineHex;
    procedure TestSearch;
    procedure TestGetLinePtr;
  end;

implementation

{$R *.dfm}

procedure TOvcFileViewerForm.open(const FN:string);
begin
  OvcFileViewer.FileName := ExtractFilePath(Application.ExeName) + FN;
  OvcFileViewer.IsOpen := True;
end;

{ TTestOvcFileViewer }

procedure TTestOvcFileViewer.TestActualColumn;
type
  TData = record
    Line: Integer;
    EffCol: Integer;
    res: Integer;
  end;
const
  cSomeData : array[0..14] of TData =
    ((Line: 0; EffCol: 10; res: 10),
     (Line: 1; EffCol: 10; res:  0),
     (Line: 5; EffCol:  0; res:  0),
     (Line: 5; EffCol:  1; res:  1),
     (Line: 5; EffCol:  2; res:  1),
     (Line: 5; EffCol:  3; res:  1),
     (Line: 5; EffCol:  4; res:  1),
     (Line: 5; EffCol:  5; res:  1),
     (Line: 5; EffCol:  6; res:  1),
     (Line: 5; EffCol:  7; res:  1),
     (Line: 5; EffCol:  8; res:  2),
     (Line: 5; EffCol:  9; res:  3),
     (Line: 5; EffCol: 15; res:  5),
     (Line: 5; EffCol: 20; res: 10),
     (Line: 5; EffCol: 25; res: 12));
var
  i, res: integer;
begin
  FForm.open('..\..\TestOvcFileViewer.txt');
  for i := 0 to High(cSomeData) do begin
    res := FForm.OvcFileViewer.ActualColumn(cSomeData[i].Line, cSomeData[i].EffCol);
    CheckTrue(res=cSomeData[i].res, Format('ActualColumn failed for test #%d',[i]));
  end;
end;


procedure TTestOvcFileViewer.TestCopyToClipboard;
type
  TData = record
    Line1, Line2: Integer;
    Col1, Col2: Integer;
    HexMode: Boolean;
    res: string;
  end;
const
  cSomeData : array[0..4] of TData =
    ((Line1: 0; Line2: 0; Col1: 0; Col2: 41; HexMode: False;
      res: 'This is a testfile for TestOvcFileViewer.'),
     (Line1: 0; Line2: 2; Col1: 40; Col2: 2; HexMode: False;
      res: '.'#13#10#13#10'As'),
     (Line1: 4; Line2: 5; Col1: 30; Col2: 0; HexMode: False;
      res: 'ab>-characters:'#13#10),
     (Line1: 5; Line2: 5; Col1: 3; Col2: 6; HexMode: False;
      res: '23'#9),
     (Line1: 1; Line2: 4; Col1: 0; Col2: 0; HexMode: True;
      res: '00000010  6C 65 20 66 6F 72 20 54 65 73 74 4F 76 63 46 69  le for TestOvcFi'#13#10+
           '00000020  6C 65 56 69 65 77 65 72 2E 0D 0A 0D 0A 41 73 20  leViewer.....As '#13#10+
           '00000030  74 68 65 20 76 69 65 77 65 72 20 63 61 6E 20 6F  the viewer can o'#13#10));
var
  i: integer;
  s: string;
begin
  FForm.open('..\..\TestOvcFileViewer.txt');
  for i := 0 to High(cSomeData) do begin
    FForm.OvcFileViewer.InHexMode := cSomeData[i].HexMode;
    FForm.OvcFileViewer.SetSelection
      (cSomeData[i].Line1, cSomeData[i].Col1, cSomeData[i].Line2, cSomeData[i].Col2, True);
    FForm.OvcFileViewer.CopyToClipboard;
    s := Clipboard.AsText;
    CheckTrue(s=cSomeData[i].res, Format('CopyToClipboard failed for test #%d',[i]));
  end;
end;


procedure TTestOvcFileViewer.TestEffectiveColumn;
type
  TData = record
    Line: Integer;
    ActCol: Integer;
    res: Integer;
  end;
const
  cSomeData : array[0..14] of TData =
    ((Line: 0; ActCol: 10; res: 10),
     (Line: 1; ActCol: 10; res:  0),
     (Line: 5; ActCol:  0; res:  0),
     (Line: 5; ActCol:  1; res:  1),
     (Line: 5; ActCol:  2; res:  8),
     (Line: 5; ActCol:  3; res:  9),
     (Line: 5; ActCol:  4; res: 10),
     (Line: 5; ActCol:  5; res: 11),
     (Line: 5; ActCol:  6; res: 16),
     (Line: 5; ActCol:  7; res: 17),
     (Line: 5; ActCol:  8; res: 18),
     (Line: 5; ActCol:  9; res: 19),
     (Line: 5; ActCol: 15; res: 28),
     (Line: 5; ActCol: 20; res: 35),
     (Line: 5; ActCol: 25; res: 41));
var
  i, res: integer;
begin
  FForm.open('..\..\TestOvcFileViewer.txt');
  for i := 0 to High(cSomeData) do begin
    res := FForm.OvcFileViewer.EffectiveColumn(cSomeData[i].Line, cSomeData[i].ActCol);
    CheckTrue(res=cSomeData[i].res, Format('EffectiveColumn failed for test #%d',[i]));
  end;
end;


procedure TTestOvcFileViewer.TestGetLine;
const
  cResults : array[0..5] of string =
    ('This is a testfile for TestOvcFileViewer.',
     '',
     'As the viewer can only handle ansi-files, this file should not be saved as UTF-8.',
     'Do not change this file unless you modify the tests in TestOvcFileViewer accordingly.',
     'The following line contains <tab>-characters:',
     '1       123     1234    12345   123456  1234567 12345678        1');
var
  i, j: integer;
  Dest: array[0..255] of Char;
  res: PChar;
begin
  FForm.open('..\..\TestOvcFileViewer.txt');
  for i := 0 to High(cResults) do begin
    for j := 0 to High(Dest) do
      Dest[j] := 'z';
    res := FForm.OvcFileViewer.GetLine(i, @Dest[0], High(Dest)+1);
    Checktrue((res=@Dest[0]) and (Dest[Length(cResults[i])+1]='z'),
              Format('GetLine failed for test #%d',[i]));
    CheckEqualsString(cResults[i], res,
              Format('GetLine failed for test #%d',[i]));
  end;
end;


procedure TTestOvcFileViewer.TestGetLineHex;
const
  cResults : array[0..5] of string =
    ('00000000  54 68 69 73 20 69 73 20 61 20 74 65 73 74 66 69  This is a testfi',
     '00000010  6C 65 20 66 6F 72 20 54 65 73 74 4F 76 63 46 69  le for TestOvcFi',
     '00000020  6C 65 56 69 65 77 65 72 2E 0D 0A 0D 0A 41 73 20  leViewer.....As ',
     '00000030  74 68 65 20 76 69 65 77 65 72 20 63 61 6E 20 6F  the viewer can o',
     '00000040  6E 6C 79 20 68 61 6E 64 6C 65 20 61 6E 73 69 2D  nly handle ansi-',
     '00000050  66 69 6C 65 73 2C 20 74 68 69 73 20 66 69 6C 65  files, this file');
var
  i, j: integer;
  Dest: array[0..255] of Char;
  res: PChar;
begin
  FForm.open('..\..\TestOvcFileViewer.txt');
  FForm.OvcFileViewer.InHexMode := True;
  for i := 0 to High(cResults) do begin
    for j := 0 to High(Dest) do
      Dest[j] := 'z';
    res := FForm.OvcFileViewer.GetLine(i, @Dest[0], High(Dest)+1);
    Checktrue((res=@Dest[0]) and (Dest[Length(cResults[i])+1]='z'),
              Format('GetLineHex failed for test #%d',[i]));
    CheckEqualsString(cResults[i], res,
              Format('GetLineHex failed for test #%d',[i]));
  end;
end;


procedure TTestOvcFileViewer.TestSearch;
type
  TData = record
    s: string;
    res: Boolean;
  end;
const
  cSomeData : array[0..3] of TData =
    ((s: 'Not Found';   res: False),
     (s: 'ansi-files';  res: True),
     (s: '123     123'; res: False),
     (s: '123'#9'123';  res: True));
var
  i: integer;
  res: Boolean;
  s: string;
begin
  FForm.open('..\..\TestOvcFileViewer.txt');
  for i := 0 to High(cSomeData) do begin
    FForm.OvcFileViewer.SetCaretPosition(0, 0);
    res := FForm.OvcFileViewer.Search(cSomeData[i].s, []);
    Checktrue(res=cSomeData[i].res, Format('Search failed for test #%d',[i]));
    if res then begin
      FForm.OvcFileViewer.CopyToClipboard;
      s := Clipboard.AsText;
      CheckEqualsString(cSomeData[i].s, s, Format('Search failed for test #%d',[i]));
    end;
  end;
end;


type
  TPOvcTextFileViewer = class(TOvcTextFileViewer);

procedure TTestOvcFileViewer.TestGetLinePtr;
type
  TData = record
    nr: Integer;
    s1, s2: string;
    len: Integer;
  end;
const
  cSomeData : array[0..6] of TData =
    ((nr:  0; s1: '01 ';  s2: ' x'; len: 254),
     (nr:  1; s1: '02 ';  s2: ' x'; len: 254),
     (nr: 10; s1: '11 ';  s2: ' x'; len: 254),
     (nr: 15; s1: '16 ';  s2: ' x'; len: 255),
     (nr: 16; s1: '17 ';  s2: ' x'; len: 254),
     (nr: 31; s1: '32 ';  s2: '90'; len: 270),
     (nr: 32; s1: '33 ';  s2: '10'; len: 42));
var
  i, len: integer;
  res: PChar;
begin
  FForm.open('..\..\TestOvcFileViewer2.txt');
  for i := 0 to High(cSomeData) do begin
    res := TPOvcTextFileViewer(FForm.OvcFileViewer).GetLinePtr(cSomeData[i].nr, len);
    CheckEquals(cSomeData[i].len, len, Format('GetLinePtr failed for line %d',[cSomeData[i].nr]));
    CheckTrue(AnsiStartsStr(cSomeData[i].s1,res),
              Format('GetLinePtr failed for line %d',[cSomeData[i].nr]));
    CheckTrue(AnsiEndsStr(cSomeData[i].s2,res),
              Format('GetLinePtr failed for line %d',[cSomeData[i].nr]));
  end;
  for i := High(cSomeData) downto 0 do begin
    res := TPOvcTextFileViewer(FForm.OvcFileViewer).GetLinePtr(cSomeData[i].nr, len);
    CheckEquals(cSomeData[i].len, len, Format('GetLinePtr failed for line %d',[cSomeData[i].nr]));
    CheckTrue(AnsiStartsStr(cSomeData[i].s1,res),
              Format('GetLinePtr failed for line %d',[cSomeData[i].nr]));
    CheckTrue(AnsiEndsStr(cSomeData[i].s2,res),
              Format('GetLinePtr failed for line %d',[cSomeData[i].nr]));
  end;
end;


procedure TTestOvcFileViewer.SetUp;
begin
  inherited SetUp;
  FForm := TOvcFileViewerForm.Create(nil);
  Application.ProcessMessages;
end;


procedure TTestOvcFileViewer.TearDown;
begin
  FForm.Free;
  inherited TearDown;
end;

initialization
  RegisterTest(TTestOvcFileViewer.Suite);
end.
