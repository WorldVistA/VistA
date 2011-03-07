{ **************************************************************
	Package: XWB - Kernel RPCBroker
	Date Created: Sept 18, 1997 (Version 1.1)
	Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
	Developers: Joel Ivey
	Description: Unit testing MFunStr code - requires dUnit for
	             unit testing.
	Current Release: Version 1.1 Patch 47 (Jun. 17, 2008))
*************************************************************** }

unit uUniTTestMFunStr;

interface

uses
  TestFramework, Sgnoncnf, Classes, Graphics, SysUtils, Forms;

type
  TTestType = class(TTestCase)
  private
  // any private fields needed for processing
  protected
  // procedure SetUp; override;
  // procedure TearDown; override;
  published
  // procedure TestName1;
  // procedure TestName2;
  end;

  TTestMFunStr1 = class(TTestCase)
  private
  protected
    procedure Setup; override;
  public
  published
    procedure TestPiece1;
    procedure TestPiece2;
    procedure TestPiece3;
    procedure TestPiece4;
    procedure TestPiece5;
    procedure TestPiece6;
    procedure TestPiece7;
    procedure TestPiece8;
    procedure TestPiece9;
  end;

  TTestMFunStr2 = class(TTestCase)
  protected
    procedure Setup; override;
  published
    procedure TestTran1;
    procedure TestTran2;
    procedure TestTran3;
    procedure TestTran4;
  end;

implementation

uses
  MFunStr_1;

var
  Str: String;
  Val: String;

procedure TTestMFunStr1.TestPiece1;
begin
  Val := Piece(Str,'^');
  Check(Val = 'Piece1','Failed Piece not specified');
end;

procedure TTestMFunStr1.Setup;
begin
  Str := 'Piece1^Piece2^Piece3';
end;

procedure TTestMFunStr1.TestPiece2;
begin
  Val := Piece(Str,'^',2);
  Check(Val = 'Piece2', 'Failed Piece specified as 2');
end;

procedure TTestMFunStr1.TestPiece3;
begin
  Val := Piece(Str,'^',3);
  Check(Val = 'Piece3', 'Failed Piece specifed as 3');
end;

procedure TTestMFunStr1.TestPiece4;
begin
  Val := Piece(Str,'^',4);
  Check(Val = '','Failed piece specifed as 4');
end;

procedure TTestMFunStr1.TestPiece5;
begin
  Val := Piece(Str,'^',1,2);
  Check(Val = 'Piece1^Piece2','Failed Piece 1,2');
end;

procedure TTestMFunStr1.TestPiece6;
begin
  Val := Piece(Str,'^',2,3);
  Check(Val = 'Piece2^Piece3','Failed Piece 2,3');
end;

procedure TTestMFunStr1.TestPiece7;
begin
  Val := Piece(Str,'^',2,4);
  Check(Val = 'Piece2^Piece3', 'Failed on Piece 2,4');
end;

procedure TTestMFunStr1.TestPiece8;
begin
  Val := Piece(Str,'^',3,5);
  Check(Val = 'Piece3','Failed on Piece 3,5');
end;

procedure TTestMFunStr1.TestPiece9;
begin
  Val := Piece(Str,'^',4,6);
  Check(Val = '','Failed on Piece 4,6');
end;

procedure TTestMFunStr2.Setup;
begin
  Str := 'ABCDEFGHABCDE';
end;

procedure TTestMFunStr2.TestTran1;
begin
  Val := Translate(Str,'ABCDEFGH','abcdefgh');
  Check(Val = 'abcdefghabcde','Failed upper to lower case');
end;

procedure TTestMFunStr2.TestTran2;
begin
  Val := Translate(Str,'ABCD','abcde');
  Check(Val = 'abcdEFGHabcdE', 'Failed Partial');
end;

procedure TTestMFunStr2.TestTran3;
begin
  Val := Translate(Str,'ABCDEABC','abcdefgh');
  Check(Val = 'abcdeFGHabcde', 'Failed repeat chars');
end;

procedure TTestMFunStr2.TestTran4;
begin
  Val := Translate(Str,'ABCDEFGH','abcdeabc');
  Check(Val = 'abcdeabcabcde', 'Failed in assignment');
end;

{  // used with second method of registering tests
function UnitTests: ITestSuite;
var
  ATestSuite: TTestSuite;
begin
  ATestSuite := TTestSuite.create('Some trivial tests');
// add each test suite to be tested
  ATestSuite.addSuite(TTestType.Suite);
//  ATestSuite.addSuite(TTestStringlist.Suite);
  Result := ATestSuite;
end;
}


{
procedure TTestType.TestName1;
begin
// Check( Boolean true for success, String comment for failed test)
  Check(1+1=2,'Comment on Failure')
end;
}

initialization
// one entry per testclass
  TestFramework.RegisterTest('Test Piece',TTestMFunStr1.Suite);
  TestFramework.RegisterTest('Test Translate',TTestMFunStr2.Suite);
// or
//    TestFramework.RegisterTest('SimpleTest',UnitTests);
end.
