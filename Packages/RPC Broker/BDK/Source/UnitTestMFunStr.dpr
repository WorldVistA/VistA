program UnitTestMFunStr;

uses
  Forms,
  TestFramework,
  GuiTestRunner,
  uUnitTestMFunStr in 'uUnitTestMFunStr.pas';

{$R *.RES}

begin
  Application.Initialize;
  GuiTestRunner.RunRegisteredTests;
end.
