{* http://www.mozilla.org/MPL/                                                *}
{*                                                                            *}
{* Software distributed under the License is distributed on an "AS IS" basis, *}
{* WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License   *}
{* for the specific language governing rights and limitations under the       *}
{* License.                                                                   *}
{*                                                                            *}
{* The Original Code is TurboPower Orpheus                                    *}
{*                                                                            *}
{* The Initial Developer of the Original Code is Roman Kassebaum              *}
{*                                                                            *}
{*                                                                            *}
{* Contributor(s):                                                            *}
{*    Roman Kassebaum                                                         *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}
unit TestOVCPlb;

interface

uses
  TestFramework;

type
  TTestOVCPlb = class(TTestCase)
  published
    procedure TestAsString;
    procedure TestClear;
  end;

implementation

uses
  OvcPlb;

{ TTestOVCPlb }

procedure TTestOVCPlb.TestAsString;
const
  cSomeString = 'blabla';
  cMask       = 'XXXXXX'; //Same Length as cSomeString
var
  pLabel: TOvcPictureLabel;
begin
  pLabel := TOvcPictureLabel.Create(nil);
  try
    pLabel.PictureMask := cMask;
    pLabel.AsString := cSomeString;
    CheckEquals(pLabel.Caption, cSomeString);
  finally
    pLabel.Free;
  end;
end;

procedure TTestOVCPlb.TestClear;
const
  cSomeString = 'blabla';
var
  pLabel: TOvcPictureLabel;
  bExcept: Boolean;
begin
  pLabel := TOvcPictureLabel.Create(nil);
  try
    pLabel.AsString := cSomeString;
    pLabel.Clear;
    try
      //This now raises an access violation
      bExcept := False;
      pLabel.AsBoolean := True;
    except
      bExcept := True;
    end;
    CheckFalse(bExcept);
  finally
    pLabel.Free;
  end;
end;

initialization
  RegisterTest(TTestOVCPlb.Suite);

end.
