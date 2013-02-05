//---------------------------------------------------------------------------
// Copyright 2012 The Open Source Electronic Health Record Agent
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
unit UnitTest;

interface
uses  WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, Dialogs, SysUtils, MFunStr, XWBut1,
  TestFrameWork,
  TextTestRunner;

 var
    index: System.Integer;
    namearray: Array of string;
    suitearray: Array of ITestSuite;
    testfound: bool;


procedure addSuite(suite: ITestSuite);
procedure runTests(name:  string);

implementation
  procedure addSuite(suite: ITestSuite);
  begin
    TestFrameWork.RegisterTest(suite);
    namearray[index] := suite.Name;
    suitearray[index] := suite;
    index := index+1;
  end;
  procedure runTests(name: string);
  var
     i : integer;
  begin
    testfound := false;
    for i := 0 to index-1 do
      if namearray[i] = name then
      begin
         TextTestRunner.RunTest(suitearray[i],rxbHaltOnFailures);
         testfound := true;
      end;
  if Not testfound then
    begin
    WriteLn(Output, 'No registered tests match the supplied name: '+ name);
    end;
  end;

begin
index:=0;
SetLength(namearray,20);
SetLength(suitearray,20);
end.
