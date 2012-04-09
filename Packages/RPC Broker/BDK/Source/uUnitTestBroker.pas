{ **************************************************************
	Package: XWB - Kernel RPCBroker
	Date Created: Sept 18, 1997 (Version 1.1)
	Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
	Developers: Joel Ivey
	Description: Unit tests for RPCBroker functionality - requires
	             dUnit to run unit tests.
	Current Release: Version 1.1 Patch 47 (Jun. 17, 2008))
*************************************************************** }

unit uUnitTestBroker;

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

  TTestSgnoncnf = class(TTestCase)
  private
    FSignonConfiguration: TSignonConfiguration;
    FRegValues: TStringList;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestReadRegistry;
    procedure TestShowModal1;
    procedure TestShowModal2;
  end;

  TTestMFunStr = class(TTestCase)
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

implementation

uses
  XWBut1, Dialogs, MFunStr, LoginFrm;

var
  Str: String;
  Val: String;


procedure TTestSgnoncnf.SetUp;
begin
{   setup as would be done in loginfrm.pas }

  FSignonConfiguration := TSignonConfiguration.Create;
{
 //  if any data currently in registry then save it
  FRegValues := TStringList.Create;
  ReadRegValues(HKCU,'Software\Vista\Signon',FRegValues);
  // Now delete current data
  DeleteRegData(HKCU,'Software\Vista\Signon');

  // Test for reading without registry data
  FOriginalValues := TSignonValues.Create;
}
  with SignonDefaults do
  begin
    Position := '0';
    Size := '0';
    IntroFont := 'Courier New^11';
    IntroFontStyles := 'B';
    TextColor := clWindowText;
    BackColor := clWindow;
  end;    // with FSignonConfiguration.SignonDefaults
  frmSignon := TfrmSignon.Create(Application);
end;

procedure TTestSgnoncnf.TearDown;
begin
  FSignonConfiguration.Free;
  frmSignon.Free;
end;

procedure TTestSgnoncnf.TestReadRegistry;
begin
  FSignonConfiguration.ReadRegistrySettings;
  with InitialValues do
  begin
    Check(Position = '0', 'ReadRegistry Error in Position value-'+Position);
    Check(Size = '0', 'ReadRegistry Error in Size value-'+Size);
    Check(IntroFont = 'Courier New^11', 'ReadRegistry Error in IntroFont-'+IntroFont);
    Check(IntroFontStyles = 'B', 'ReadRegistry Error in IntroFontStyles value-'+IntroFontStyles);
    Check(BackColor = clWindow, 'ReadRegistry Error in BackColor = '+IntToStr(BackColor));
    Check(TextColor = clWindowText, 'ReadRegistry Error in TextColor = '+IntToStr(TextColor));
  end;    // with
end;

procedure TTestSgnoncnf.TestShowModal1;
begin
  ShowMessage('Click on Default Button');
  InitialValues.TextColor := clWindow;
  FSignonConfiguration.ShowModal;
  with InitialValues do
  begin
    Check(TextColor = clWindowText, 'TestShowModal bad TextColor on restore');
  end;    // with
end;

procedure TTestSgnoncnf.TestShowModal2;
begin
  ShowMessage('Click on ''Select New'' Background Color then select OK (Standard) on next form Then click OK on Main Form');
  InitialValues.TextColor := clWindowText;
  FSignonConfiguration.ShowModal;
  with InitialValues do
  begin
    Check(BackColor = clWindow, 'TestShowModal bad TextColor on restore');
  end;    // with
end;

procedure TTestMFunStr.TestPiece1;
begin
  Val := Piece(Str,'^');
  Check(Val = 'Piece1','Failed Piece not specified');
end;

procedure TTestMFunStr.Setup;
begin
  Str := 'Piece1^Piece2^Piece3';
end;

procedure TTestMFunStr.TestPiece2;
begin
  Val := Piece(Str,'^',2);
  Check(Val = 'Piece2', 'Failed Piece specified as 2');
end;

procedure TTestMFunStr.TestPiece3;
begin
  Val := Piece(Str,'^',3);
  Check(Val = 'Piece3', 'Failed Piece specifed as 3');
end;

procedure TTestMFunStr.TestPiece4;
begin
  Val := Piece(Str,'^',4);
  Check(Val = '','Failed piece specifed as 4');
end;

procedure TTestMFunStr.TestPiece5;
begin
  Val := Piece(Str,'^',1,2);
  Check(Val = 'Piece1^Piece2','Failed Piece 1,2');
end;

procedure TTestMFunStr.TestPiece6;
begin
  Val := Piece(Str,'^',2,3);
  Check(Val = 'Piece2^Piece3','Failed Piece 2,3');
end;

procedure TTestMFunStr.TestPiece7;
begin
  Val := Piece(Str,'^',2,4);
  Check(Val = 'Piece2^Piece3', 'Failed on Piece 2,4');
end;

procedure TTestMFunStr.TestPiece8;
begin
  Val := Piece(Str,'^',3,5);
  Check(Val = 'Piece3','Failed on Piece 3,5');
end;

procedure TTestMFunStr.TestPiece9;
begin
  Val := Piece(Str,'^',4,6);
  Check(Val = '','Failed on Piece 4,6');
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
  TestFramework.RegisterTest('ReadRegistry',TTestSgnoncnf.Suite);
  TestFramework.RegisterTest('Test Piece',TTestMFunStr.Suite);
// or
//    TestFramework.RegisterTest('SimpleTest',UnitTests);
end.
