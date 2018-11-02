unit TestOvcSpinner;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  TestFramework, ovcpf, ovcfsc, ovcsc, ovcbase, ovcef, ovcpb, ovcnf, ovcdate;

type
  TTestOvcSpinnerForm = class(TForm)
    OvcNumericField1: TOvcNumericField;
    OvcSpinner1: TOvcSpinner;
    OvcNumericField2: TOvcNumericField;
    OvcFlatSpinner1: TOvcFlatSpinner;
    OvcPictureField1: TOvcPictureField;
    OvcPictureField2: TOvcPictureField;
    OvcSpinner2: TOvcSpinner;
    OvcFlatSpinner2: TOvcFlatSpinner;
  end;

  TTestOvcSpinner = class(TTestCase)
  private
    FForm: TTestOvcSpinnerForm;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestOvcSpinner_Int;
    procedure TestOvcSpinner_Time;
    procedure TestOvcFlatSpinner_Int;
    procedure TestOvcFlatSpinner_Time;
  end;

var
  TestOvcSpinnerForm: TTestOvcSpinnerForm;

implementation

{$R *.dfm}

procedure TTestOvcSpinner.TestOvcSpinner_Int;
var
  P: TPoint;
begin
  FForm.OvcNumericField1.AsInteger := 42;
  { Click on the spinner's "up"-Button twice }
  P.X := 2;
  P.Y := 2;
  P := FForm.OvcSpinner1.Clienttoscreen(P);
  SetCursorPos(P.X,P.Y);
  FForm.OvcSpinner1.Perform(WM_LBUTTONDOWN,0,2*65536+2);
  FForm.OvcSpinner1.Perform(WM_LBUTTONUP,0,2*65536+2);
  SetCursorPos(P.X,P.Y);
  FForm.OvcSpinner1.Perform(WM_LBUTTONDOWN,0,2*65536+2);
  FForm.OvcSpinner1.Perform(WM_LBUTTONUP,0,2*65536+2);
  { Click on the spinner's "down"-Button once }
  P.X := 2;
  P.Y := FForm.OvcSpinner1.Height-2;
  P := FForm.OvcSpinner1.Clienttoscreen(P);
  SetCursorPos(P.X,P.Y);
  FForm.OvcSpinner1.Perform(WM_LBUTTONDOWN,0,2*65536+FForm.OvcSpinner1.Height-2);
  FForm.OvcSpinner1.Perform(WM_LBUTTONUP,0,2*65536+FForm.OvcSpinner1.Height-2);
  { 42 + 2 - 1 = 43 }
  CheckEquals(43, FForm.OvcNumericField1.AsInteger);
end;


procedure TTestOvcSpinner.TestOvcSpinner_Time;
var
  P: TPoint;
begin
  FForm.OvcPictureField1.AsStTime := OvcDate.HMStoStTime(23,59,00);
  { Go to the field's end an click on the spinner's "up"-Button twice }
  FForm.OvcPictureField1.MoveCaretToEnd;
  P.X := 2;
  P.Y := 2;
  P := FForm.OvcSpinner2.Clienttoscreen(P);
  SetCursorPos(P.X,P.Y);
  FForm.OvcSpinner2.Perform(WM_LBUTTONDOWN,0,2*65536+2);
  FForm.OvcSpinner2.Perform(WM_LBUTTONUP,0,2*65536+2);
  SetCursorPos(P.X,P.Y);
  FForm.OvcSpinner2.Perform(WM_LBUTTONDOWN,0,2*65536+2);
  FForm.OvcSpinner2.Perform(WM_LBUTTONUP,0,2*65536+2);
  { Go to the field's start an click on the spinner's "down"-Button twice }
  FForm.OvcPictureField1.MoveCaretToStart;
  P.X := 2;
  P.Y := FForm.OvcSpinner2.Height-2;
  P := FForm.OvcSpinner2.Clienttoscreen(P);
  SetCursorPos(P.X,P.Y);
  FForm.OvcSpinner2.Perform(WM_LBUTTONDOWN,0,2*65536+FForm.OvcSpinner2.Height-2);
  FForm.OvcSpinner2.Perform(WM_LBUTTONUP,0,2*65536+FForm.OvcSpinner2.Height-2);
  SetCursorPos(P.X,P.Y);
  FForm.OvcSpinner2.Perform(WM_LBUTTONDOWN,0,2*65536+FForm.OvcSpinner2.Height-2);
  FForm.OvcSpinner2.Perform(WM_LBUTTONUP,0,2*65536+FForm.OvcSpinner2.Height-2);
  { 23:59 + 2min = 00:01; 00:01 - 2 h = 22:01 }
  CheckEquals(OvcDate.HMStoStTime(22,1,0), FForm.OvcPictureField1.AsStTime);
end;


procedure TTestOvcSpinner.TestOvcFlatSpinner_Int;
var
  P: TPoint;
begin
  FForm.OvcNumericField2.AsInteger := -7;
  { Click on the spinner's "up"-Button once }
  P.X := 2;
  P.Y := 2;
  P := FForm.OvcFlatSpinner1.Clienttoscreen(P);
  SetCursorPos(P.X,P.Y);
  FForm.OvcFlatSpinner1.Perform(WM_LBUTTONDOWN,0,2*65536+2);
  FForm.OvcFlatSpinner1.Perform(WM_LBUTTONUP,0,2*65536+2);
  { Click on the spinner's "down"-Button twice }
  P.X := 2;
  P.Y := FForm.OvcFlatSpinner1.Height-2;
  P := FForm.OvcFlatSpinner1.Clienttoscreen(P);
  SetCursorPos(P.X,P.Y);
  FForm.OvcFlatSpinner1.Perform(WM_LBUTTONDOWN,0,2*65536+FForm.OvcFlatSpinner1.Height-2);
  FForm.OvcFlatSpinner1.Perform(WM_LBUTTONUP,0,2*65536+FForm.OvcFlatSpinner1.Height-2);
  SetCursorPos(P.X,P.Y);
  FForm.OvcFlatSpinner1.Perform(WM_LBUTTONDOWN,0,2*65536+FForm.OvcFlatSpinner1.Height-2);
  FForm.OvcFlatSpinner1.Perform(WM_LBUTTONUP,0,2*65536+FForm.OvcFlatSpinner1.Height-2);
  { -7 + 1 - 2 = -8 }
  CheckEquals(-8, FForm.OvcNumericField2.AsInteger);
end;


procedure TTestOvcSpinner.TestOvcFlatSpinner_Time;
var
  P: TPoint;
begin
  FForm.OvcPictureField2.AsStTime := OvcDate.HMStoStTime(00,0,00);
  { Go to the field's end an click on the spinner's "up"-Button twice }
  FForm.OvcPictureField2.MoveCaretToEnd;
  P.X := 2;
  P.Y := 2;
  P := FForm.OvcFlatSpinner2.Clienttoscreen(P);
  SetCursorPos(P.X,P.Y);
  FForm.OvcFlatSpinner2.Perform(WM_LBUTTONDOWN,0,2*65536+2);
  FForm.OvcFlatSpinner2.Perform(WM_LBUTTONUP,0,2*65536+2);
  SetCursorPos(P.X,P.Y);
  FForm.OvcFlatSpinner2.Perform(WM_LBUTTONDOWN,0,2*65536+2);
  FForm.OvcFlatSpinner2.Perform(WM_LBUTTONUP,0,2*65536+2);
  { Go to the field's start an click on the spinner's "down"-Button twice }
  FForm.OvcPictureField2.MoveCaretToStart;
  P.X := 2;
  P.Y := FForm.OvcFlatSpinner2.Height-2;
  P := FForm.OvcFlatSpinner2.Clienttoscreen(P);
  SetCursorPos(P.X,P.Y);
  FForm.OvcFlatSpinner2.Perform(WM_LBUTTONDOWN,0,2*65536+FForm.OvcFlatSpinner2.Height-2);
  FForm.OvcFlatSpinner2.Perform(WM_LBUTTONUP,0,2*65536+FForm.OvcFlatSpinner2.Height-2);
  SetCursorPos(P.X,P.Y);
  FForm.OvcFlatSpinner2.Perform(WM_LBUTTONDOWN,0,2*65536+FForm.OvcFlatSpinner2.Height-2);
  FForm.OvcFlatSpinner2.Perform(WM_LBUTTONUP,0,2*65536+FForm.OvcFlatSpinner2.Height-2);
  { 00:00 + 2min = 00:02; 00:02 - 2 h = 22:02 }
  CheckEquals(OvcDate.HMStoStTime(22,2,0), FForm.OvcPictureField2.AsStTime);
end;


procedure TTestOvcSpinner.SetUp;
begin
  inherited SetUp;
  FForm := TTestOvcSpinnerForm.Create(nil);
  with FForm do begin
    OvcNumericField1.AsInteger := 42;
    OvcNumericField2.AsInteger := 12345;
    OvcPictureField1.AsStTime  := OvcDate.HMStoStTime(13,10,0);
    OvcPictureField1.AsStTime  := OvcDate.HMStoStTime(23,59,59);
    Show;
  end;
  Application.ProcessMessages;
end;

procedure TTestOvcSpinner.TearDown;
begin
  FForm.Free;
  inherited TearDown;
end;

initialization
  RegisterTest(TTestOvcSpinner.Suite);

end.
