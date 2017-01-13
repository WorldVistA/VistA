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
program CPRSTesting;

{$APPTYPE CONSOLE}

uses
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Dialogs,
  StdCtrls,
  Buttons,
  TestFrameWork,
  GUITestRunner,
  TextTestRunner,
  ShareMem,
  Forms,
  WinHelpViewer,
  UnitTest in 'D:\Work\OSEHRA\VistA\Packages\Order Entry Results Reporting\CPRS\Testing\UnitTest.pas' {UnitTest},
  UTSignonCnf in 'D:\Work\OSEHRA\VistA\Packages\Order Entry Results Reporting\CPRS\Testing\Tests\UTSignonCnf.pas' {UTSignonCnf},
  UTXlfMime in 'D:\Work\OSEHRA\VistA\Packages\Order Entry Results Reporting\CPRS\Testing\Tests\UTXlfMime.pas' {UTXuDsigS},
  UTWcrypt2 in 'D:\Work\OSEHRA\VistA\Packages\Order Entry Results Reporting\CPRS\Testing\Tests\UTWcrypt2.pas' {UTXuDsigS},
  UTWinSCard in 'D:\Work\OSEHRA\VistA\Packages\Order Entry Results Reporting\CPRS\Testing\Tests\UTWinSCard.pas'{UTXuDsigS};

{$R 'D:\Work\OSEHRA\VistA\Packages\Order Entry Results Reporting\CPRS\Testing\CPRSTesting.tlb'}

{$R 'D:\Work\OSEHRA\VistA\Packages\Order Entry Results Reporting\CPRS\Testing\CPRSTesting.res'}

begin
    if IsConsole then
        if ParamCount > 0 then
            runTests(ParamStr(1))
        else
            TextTestRunner.RunRegisteredTests(rxbHaltOnFailures)
end.
