{* http://www.mozilla.org/MPL/                                                *}
{*                                                                            *}
{* Software distributed under the License is distributed on an "AS IS" basis, *}
{* WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License   *}
{* for the specific language governing rights and limitations under the       *}
{* License.                                                                   *}
{*                                                                            *}
{* The Original Code is TurboPower Orpheus                                    *}
{*                                                                            *}
{* Contributor(s):                                                            *}
{*    Armin Biernaczyk                                                        *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

unit TestOvcFields;

interface

uses
  TestFramework,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ovcbase, ovceditu, ovcedit, ovceditp, ovceditn, StdCtrls, ovcnf, ovcpb,
  ovcpf, ovcef, ovcsf;

type
  TTestOvcFieldsForm = class(TForm)
    OvcSimpleField1: TOvcSimpleField;
    OvcPictureField1: TOvcPictureField;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    OvcSimpleField2: TOvcSimpleField;
    OvcPictureField2: TOvcPictureField;
    OvcNumericField2: TOvcNumericField;
    OvcNumericField1: TOvcNumericField;
  end;

  TTestOvcFields = class(TTestCase)
  private
    FForm: TTestOvcFieldsForm;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestOvcSF_RangeLo;
    procedure TestOvcPF_RangeLo;
    procedure TestOvcNF_RangeLo;
    procedure TestOvc_AsSingle;
    procedure TestOvc_AsFloat;
    procedure TestOvc_AsExtended;
  end;

implementation

{$R *.dfm}

procedure TTestOvcFields.TestOvcSF_RangeLo;
type
  TData = record
    RangeHiRes, RangeLoRes: string;
  end;
const
  cSomeData : array[TSimpleDataType] of TData =
    ((RangeHiRes: '';           RangeLoRes: '';),              //   sftString
     (RangeHiRes: '#32';        RangeLoRes: '#32';),           //   sftChar
     (RangeHiRes: '';           RangeLoRes: '';),              //   sftBoolean
     (RangeHiRes: '';           RangeLoRes: '';),              //   sftYesNo
     (RangeHiRes: '2147483647'; RangeLoRes: '-2147483648';),   //   sftLongInt
     (RangeHiRes: '65535';      RangeLoRes: '0';),             //   sftWord
     (RangeHiRes: '32767';      RangeLoRes: '-32768';),        //   sftInteger
     (RangeHiRes: '255';        RangeLoRes: '0';),             //   sftByte
     (RangeHiRes: '127';        RangeLoRes: '-128';),          //   sftShortInt
     (RangeHiRes: '1,7E+38';    RangeLoRes: '-1,7E+38';),      //   sftReal
{$IFDEF WIN64}
     (RangeHiRes: '1,7E+308';   RangeLoRes: '-1,7E+308';),     //   sftExtended
{$ELSE}
     (RangeHiRes: '1,1E+4932';  RangeLoRes: '-1,1E+4932';),    //   sftExtended
{$ENDIF}
     (RangeHiRes: '1,7E+308';   RangeLoRes: '-1,7E+308';),     //   sftDouble
     (RangeHiRes: '3,4E+38';    RangeLoRes: '-3,4E+38';),      //   sftSingle
     (RangeHiRes: '9,2E+18';    RangeLoRes: '-9,2E+18';));     //   sftComp
var
  i: TSimpleDataType;
  res: string;
begin
  FForm.OvcSimpleField1.IntlSupport.DecimalChar := ',';
  for i := Low(cSomeData) to High(cSomeData) do begin
    FForm.OvcSimpleField1.Datatype := i;
    res := FForm.OvcSimpleField1.RangeHi;
    CheckEqualsString(cSomeData[i].RangeHiRes, res);
    res := FForm.OvcSimpleField1.RangeLo;
    CheckEqualsString(cSomeData[i].RangeLoRes, res);
  end;
end;


procedure TTestOvcFields.TestOvcPF_RangeLo;
type
  TData = record
    RangeHiRes, RangeLoRes: string;
  end;
const
  cSomeData : array[pftString..pftComp] of TData =
    ((RangeHiRes: '';           RangeLoRes: '';),              //   pftString
     (RangeHiRes: '#32';        RangeLoRes: '#32';),           //   pftChar
     (RangeHiRes: '';           RangeLoRes: '';),              //   pftBoolean
     (RangeHiRes: '';           RangeLoRes: '';),              //   pftYesNo
     (RangeHiRes: '2147483647'; RangeLoRes: '-2147483648';),   //   pftLongInt
     (RangeHiRes: '65535';      RangeLoRes: '0';),             //   pftWord
     (RangeHiRes: '32767';      RangeLoRes: '-32768';),        //   pftInteger
     (RangeHiRes: '255';        RangeLoRes: '0';),             //   pftByte
     (RangeHiRes: '127';        RangeLoRes: '-128';),          //   pftShortInt
     (RangeHiRes: '1,7E+38';    RangeLoRes: '-1,7E+38';),      //   pftReal
{$IFDEF WIN64}
     (RangeHiRes: '1,7E+308';   RangeLoRes: '-1,7E+308';),     //   pftExtended
{$ELSE}
     (RangeHiRes: '1,1E+4932';  RangeLoRes: '-1,1E+4932';),    //   pftExtended
{$ENDIF}
     (RangeHiRes: '1,7E+308';   RangeLoRes: '-1,7E+308';),     //   pftDouble
     (RangeHiRes: '3,4E+38';    RangeLoRes: '-3,4E+38';),      //   pftSingle
     (RangeHiRes: '9,2E+18';    RangeLoRes: '-9,2E+18';));     //   pftComp
var
  i: TPictureDataType;
  res: string;
begin
  FForm.OvcPictureField1.IntlSupport.DecimalChar := ',';
  for i := Low(cSomeData) to High(cSomeData) do begin
    FForm.OvcPictureField1.Datatype := i;
    res := FForm.OvcPictureField1.RangeHi;
    CheckEqualsString(cSomeData[i].RangeHiRes, res);
    res := FForm.OvcPictureField1.RangeLo;
    CheckEqualsString(cSomeData[i].RangeLoRes, res);
  end;
end;


procedure TTestOvcFields.TestOvcNF_RangeLo;
type
  TData = record
    RangeHiRes, RangeLoRes: string;
  end;
const
  cSomeData : array[TNumericDataType] of TData =
    ((RangeHiRes: '2147483647'; RangeLoRes: '-2147483648';),   //   nftLongInt
     (RangeHiRes: '65535';      RangeLoRes: '0';),             //   nftWord
     (RangeHiRes: '32767';      RangeLoRes: '-32768';),        //   nftInteger
     (RangeHiRes: '255';        RangeLoRes: '0';),             //   nftByte
     (RangeHiRes: '127';        RangeLoRes: '-128';),          //   nftShortInt
     (RangeHiRes: '1,7E+38';    RangeLoRes: '-1,7E+38';),      //   nftReal
{$IFDEF WIN64}
     (RangeHiRes: '1,7E+308';   RangeLoRes: '-1,7E+308';),     //   nftExtended
{$ELSE}
     (RangeHiRes: '1,1E+4932';  RangeLoRes: '-1,1E+4932';),    //   nftExtended
{$ENDIF}
     (RangeHiRes: '1,7E+308';   RangeLoRes: '-1,7E+308';),     //   nftDouble
     (RangeHiRes: '3,4E+38';    RangeLoRes: '-3,4E+38';),      //   nftSingle
     (RangeHiRes: '9,2E+18';    RangeLoRes: '-9,2E+18';));     //   nftComp
var
  i: TNumericDataType;
  res: string;
begin
  FForm.OvcNumericField1.IntlSupport.DecimalChar := ',';
  for i := Low(cSomeData) to High(cSomeData) do begin
    FForm.OvcNumericField1.Datatype := i;
    res := FForm.OvcNumericField1.RangeHi;
    CheckEqualsString(cSomeData[i].RangeHiRes, res);
    res := FForm.OvcNumericField1.RangeLo;
    CheckEqualsString(cSomeData[i].RangeLoRes, res);
  end;
end;


procedure TTestOvcFields.TestOvc_AsSingle;
type
  TData = record
    value: Single;
    dp: Byte;
    res1, res2, res3: string;
  end;
const
  cSomeData : array[0..10] of TData =
    ((value: 0;         dp: 4; res1: '0';         res2: '0';          res3: '0,00';),
     (value: 10;        dp: 3; res1: '10';        res2: '10';         res3: '10,00';),
     (value: -42;       dp: 2; res1: '-42';       res2: '-42';        res3: '-42,00';),
     (value: 1.333333;  dp: 4; res1: '1,3333';    res2: '1,3333';     res3: '1,33';),
     (value: -12.5555;  dp: 2; res1: '-12,56';    res2: '-12,56';     res3: '-12,56';),
     (value: 0.0567;    dp: 4; res1: '0,0567';    res2: '0,0567';     res3: '0,06';),
     (value: -0.0123;   dp: 3; res1: '-0,012';    res2: '-0,012';     res3: '-0,01';),
     (value: 0.0001;    dp: 3; res1: '0';         res2: '0';          res3: '0,00';),
     (value: -0.0002;   dp: 3; res1: '-0';        res2: '-0';         res3: '-0,00';),
     (value: 1.234E20;  dp: 6; res1: '1,234E+20'; res2: '';           res3: '';),
     (value: -5.555E20; dp: 2; res1: '-5,56E+20'; res2: '';           res3: '';));
var
  res: string;
  i: Integer;
begin
  FForm.OvcSimpleField2.IntlSupport.DecimalChar := ',';
  FForm.OvcPictureField2.IntlSupport.DecimalChar := ',';
  FForm.OvcNumericField2.IntlSupport.DecimalChar := ',';
  FForm.OvcSimpleField2.DataType := sftSingle;
  FForm.OvcPictureField2.DataType := pftSingle;
  FForm.OvcNumericField2.DataType := nftSingle;
  FForm.OvcNumericField2.PictureMask := '#######.##';
  for i := 0 to High(cSomeData) do begin
    { test TOvcSimpleField }
    FForm.OvcSimpleField2.DecimalPlaces := cSomeData[i].dp;
    FForm.OvcSimpleField2.AsFloat := cSomeData[i].value;
    res := FForm.OvcSimpleField2.Text;
    CheckEqualsString(cSomeData[i].res1, res,
      Format('TOvcSimpleField.AsFloat (sftSingle) failed for test #%d', [i]));
    { test TOvcPictureField }
    if cSomeData[i].res2<>'' then begin
      FForm.OvcPictureField2.DecimalPlaces := cSomeData[i].dp;
      FForm.OvcPictureField2.AsFloat := cSomeData[i].value;
      res := Trim(FForm.OvcPictureField2.Text);
      CheckEqualsString(cSomeData[i].res2, res,
        Format('TOvcPictureField.AsFloat (pftSingle) failed for test #%d', [i]));
    end;
    { test TOvcNumericField }
    if cSomeData[i].res3<>'' then begin
      FForm.OvcNumericField2.DecimalPlaces := cSomeData[i].dp;
      FForm.OvcNumericField2.AsFloat := cSomeData[i].value;
      res := Trim(FForm.OvcNumericField2.Text);
      CheckEqualsString(cSomeData[i].res3, res,
        Format('TOvcNumericField.AsFloat (nftSingle) failed for test #%d', [i]));
    end;
  end;
end;


procedure TTestOvcFields.TestOvc_AsFloat;
type
  TData = record
    value: Double;
    dp: Byte;
    res1, res2, res3: string;
  end;
const
  cSomeData : array[0..12] of TData =
    ((value: 0;         dp: 6; res1: '0';           res2: '0';          res3: '0,00'),
     (value: 10;        dp: 3; res1: '10';          res2: '10';         res3: '10,00';),
     (value: -42;       dp: 2; res1: '-42';         res2: '-42';        res3: '-42,00';),
     (value: 1.333333;  dp: 4; res1: '1,3333';      res2: '1,3333';     res3: '1,33';),
     (value: -12.5555;  dp: 2; res1: '-12,56';      res2: '-12,56';     res3: '-12,56';),
     (value: 0.0567;    dp: 4; res1: '0,0567';      res2: '0,0567';     res3: '0,06';),
     (value: -0.0123;   dp: 3; res1: '-0,012';      res2: '-0,012';     res3: '-0,01';),
     (value: 0.0001;    dp: 3; res1: '0';           res2: '0';          res3: '0,00';),
     (value: -0.0002;   dp: 3; res1: '-0';          res2: '-0';         res3: '-0,00';),
     (value: 1.234E20;  dp: 6; res1: '1,234E+20';   res2: '';           res3: '';),
     (value: -5.555E20; dp: 2; res1: '-5,56E+20';   res2: '';           res3: '';),
     (value: 1.234E200; dp: 6; res1: '1,234E+200';  res2: '';           res3: '';),
     (value: -1.234E200;dp: 3; res1: '-1,234E+200'; res2: '';           res3: '';));
var
  res: string;
  i: Integer;
begin
  FForm.OvcSimpleField2.IntlSupport.DecimalChar := ',';
  FForm.OvcPictureField2.IntlSupport.DecimalChar := ',';
  FForm.OvcNumericField2.IntlSupport.DecimalChar := ',';
  FForm.OvcSimpleField2.DataType := sftDouble;
  FForm.OvcPictureField2.DataType := pftDouble;
  FForm.OvcNumericField2.DataType := nftDouble;
  FForm.OvcNumericField2.PictureMask := '#######.##';
  for i := 0 to High(cSomeData) do begin
    { test TOvcSimpleField }
    FForm.OvcSimpleField2.DecimalPlaces := cSomeData[i].dp;
    FForm.OvcSimpleField2.AsFloat := cSomeData[i].value;
    res := FForm.OvcSimpleField2.Text;
    CheckEqualsString(cSomeData[i].res1, res,
      Format('TOvcSimpleField.AsFloat (sftDouble) failed for test #%d', [i]));
    { test TOvcPictureField }
    if cSomeData[i].res2<>'' then begin
      FForm.OvcPictureField2.DecimalPlaces := cSomeData[i].dp;
      FForm.OvcPictureField2.AsFloat := cSomeData[i].value;
      res := Trim(FForm.OvcPictureField2.Text);
      CheckEqualsString(cSomeData[i].res2, res,
        Format('TOvcPictureField.AsFloat (pftDouble) failed for test #%d', [i]));
    end;
    { test TOvcNumericField }
    if cSomeData[i].res3<>'' then begin
      FForm.OvcNumericField2.DecimalPlaces := cSomeData[i].dp;
      FForm.OvcNumericField2.AsFloat := cSomeData[i].value;
      res := Trim(FForm.OvcNumericField2.Text);
      CheckEqualsString(cSomeData[i].res3, res,
        Format('TOvcNumericField.AsFloat (nftDouble) failed for test #%d', [i]));
    end;
  end;
end;


procedure TTestOvcFields.TestOvc_AsExtended;
type
  TData = record
    value: Extended;
    dp: Byte;
    res1, res2, res3: string;
  end;
const
  cSomeData : array[0..14] of TData =
    ((value: 0;            dp: 6; res1: '0';            res2: '0';          res3: '0,00';),
     (value: 10;           dp: 3; res1: '10';           res2: '10';         res3: '10,00';),
     (value: -42;          dp: 2; res1: '-42';          res2: '-42';        res3: '-42,00';),
     (value: 1.333333;     dp: 4; res1: '1,3333';       res2: '1,3333';     res3: '1,33';),
     (value: -12.5555;     dp: 2; res1: '-12,56';       res2: '-12,56';     res3: '-12,56';),
     (value: 0.0567;       dp: 4; res1: '0,0567';       res2: '0,0567';     res3: '0,06';),
     (value: -0.0123;      dp: 3; res1: '-0,012';       res2: '-0,012';     res3: '-0,01';),
     (value: 0.0001;       dp: 3; res1: '0';            res2: '0';          res3: '0,00';),
     (value: -0.0002;      dp: 3; res1: '-0';           res2: '-0';         res3: '-0,00';),
     (value: 1.234E20;     dp: 6; res1: '1,234E+20';    res2: '';           res3: '';),
     (value: -5.555E20;    dp: 2; res1: '-5,56E+20';    res2: '';           res3: '';),
     (value: 1.234E200;    dp: 6; res1: '1,234E+200';   res2: '';           res3: '';),
     (value: -1.234E200;   dp: 3; res1: '-1,234E+200';  res2: '';           res3: '';),
{$IFDEF WIN64}
     (value: 1.7777E300;   dp: 3; res1: '1,778E+300';   res2: '';           res3: '';),
     (value: -1.7777E300;  dp: 3; res1: '-1,778E+300';  res2: '';           res3: '';));
{$ELSE}
     (value: 1.7777E4000;  dp: 3; res1: '1,778E+4000';  res2: '';           res3: '';),
     (value: -1.7777E4000; dp: 3; res1: '-1,778E+4000'; res2: '';           res3: '';));
{$ENDIF}
var
  res: string;
  i: Integer;
begin
  FForm.OvcSimpleField2.IntlSupport.DecimalChar := ',';
  FForm.OvcPictureField2.IntlSupport.DecimalChar := ',';
  FForm.OvcNumericField2.IntlSupport.DecimalChar := ',';
  FForm.OvcSimpleField2.DataType := sftExtended;
  FForm.OvcPictureField2.DataType := pftExtended;
  FForm.OvcNumericField2.DataType := nftExtended;
  FForm.OvcNumericField2.PictureMask := '#######.##';
  for i := 0 to High(cSomeData) do begin
    { test TOvcSimpleField }
    FForm.OvcSimpleField2.DecimalPlaces := cSomeData[i].dp;
    FForm.OvcSimpleField2.AsExtended := cSomeData[i].value;
    res := FForm.OvcSimpleField2.Text;
    CheckEqualsString(cSomeData[i].res1, res,
      Format('TOvcSimpleField.AsExtended (sftExtended) failed for test #%d', [i]));
    { test TOvcPictureField }
    if cSomeData[i].res2<>'' then begin
      FForm.OvcPictureField2.DecimalPlaces := cSomeData[i].dp;
      FForm.OvcPictureField2.AsExtended := cSomeData[i].value;
      res := Trim(FForm.OvcPictureField2.Text);
      CheckEqualsString(cSomeData[i].res2, res,
        Format('TOvcPictureField.AsExtended (pftExtended) failed for test #%d', [i]));
    end;
    { test TOvcNumericField }
    if cSomeData[i].res3<>'' then begin
      FForm.OvcNumericField2.DecimalPlaces := cSomeData[i].dp;
      FForm.OvcNumericField2.AsExtended := cSomeData[i].value;
      res := Trim(FForm.OvcNumericField2.Text);
      CheckEqualsString(cSomeData[i].res3, res,
        Format('TOvcNumericField.AsExtended (nftExtended) failed for test #%d', [i]));
    end;
  end;
end;



procedure TTestOvcFields.SetUp;
begin
  inherited SetUp;
  FForm := TTestOvcFieldsForm.Create(nil);
  Application.ProcessMessages;
end;


procedure TTestOvcFields.TearDown;
begin
  FForm.Free;
  inherited TearDown;
end;

initialization
  RegisterTest(TTestOvcFields.Suite);
end.
