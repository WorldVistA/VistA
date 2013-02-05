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
unit UTSignonCnf;
interface
uses UnitTest, TestFrameWork, SgnonCnf;

implementation
type
UTSignonCnfTests=class(TTestCase)
  private
    OSEHRATest: TSignonValues;
  public
  procedure SetUp; override;
  procedure TearDown; override;

  published
    procedure TestSignOnPropertyClear;
  end;

procedure UTSignonCnfTests.SetUp;
begin
  OSEHRATest := TSignonValues.Create();
 end;

procedure UTSignonCnfTests.TearDown;
begin
  OSEHRATest :=nil;
end;

procedure UTSignonCnfTests.TestSignOnPropertyClear;
begin
  OSEHRATest.Height := 5;
  CheckEquals(5,OSEHRATest.Height,'Initial Set didn''t work');
  OSEHRATest.Clear;
  CheckEquals(0,OSEHRATest.Height,'Test of SgnonCnf Function Clear has failed');
end;

begin
UnitTest.addSuite(UTSignonCnfTests.Suite);
end.