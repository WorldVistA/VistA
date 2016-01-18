program UnitTestBroker;

uses
  Forms,
  TestFramework,
  GuiTestRunner,
  uUnitTestBroker in 'uUnitTestBroker.pas';

{$R *.RES}

begin
  Application.Initialize;
  GuiTestRunner.RunRegisteredTests;
end.
