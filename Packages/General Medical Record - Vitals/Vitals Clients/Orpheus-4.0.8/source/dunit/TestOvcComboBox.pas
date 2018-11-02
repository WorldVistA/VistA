unit TestOvcComboBox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TestFramework, StdCtrls, ovccmbx, ovcdrcbx;

type
  TTfrmTestOvcComboBox = class(TForm)
    OvcComboBox1: TOvcComboBox;
    OvcDirectoryComboBox1: TOvcDirectoryComboBox;
  end;

  TTestOvcComboBox = class(TTestCase)
  private
    FForm: TTfrmTestOvcComboBox;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  public
    procedure TestOvcDirectoryComboBox_Size;
  published
    procedure TestOvcComboBox_WheelDown;
  end;

implementation

{$R *.dfm}

type
  TPOvcComboBox = class(TOvcComboBox);

{ Special test for the "WheelDown"-Bug in TOvcComboBox:
  Select an item from the list, then try to use the mousewheel to change the
  selection: moving down the list does not work until you have moved up at least
  once.
  TOvcComboBox.AddItemToMRUList was the source of this bug(let) }
procedure TTestOvcComboBox.TestOvcComboBox_WheelDown;
begin
  FForm.OvcComboBox1.ItemIndex := 4;
  TPOvcComboBox(FForm.OvcComboBox1).AddItemToMRUList(4);
  { Now try to move down the list using the mousewheel }
  FForm.OvcComboBox1.Perform(WM_MOUSEWHEEL, NativeUInt(-2*WHEEL_DELTA*65536), 0);
  CheckEquals(6, FForm.OvcComboBox1.ListIndex);
  { Try to move up the list using the mousewheel }
  FForm.OvcComboBox1.Perform(WM_MOUSEWHEEL, 1*WHEEL_DELTA*65536, 0);
  CheckEquals(5, FForm.OvcComboBox1.ListIndex);
end;


{ Special test for the "Size"-Bug in TOvcDirectoryComboBox:
  The height of the control was not set properly if a font was chosen that leads to
  an ItemHeight of 16. }

procedure TTestOvcComboBox.TestOvcDirectoryComboBox_Size;
begin
  CheckEquals(27, FForm.OvcDirectoryComboBox1.Height);
end;


{ TTestOvcComboBox }

procedure TTestOvcComboBox.SetUp;
begin
  inherited SetUp;
  FForm := TTfrmTestOvcComboBox.Create(nil);
  FForm.Show;
  Application.ProcessMessages;
end;

procedure TTestOvcComboBox.TearDown;
begin
  FForm.Free;
  inherited TearDown;
end;

initialization
  RegisterTest(TTestOvcComboBox.Suite);

end.

