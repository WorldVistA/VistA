unit TestOvcTransfer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DateUtils,
  TestFramework, ovcbase, ovcrlbl, ovcnf, ovcpb, ovcpf, ovcef, ovcsf, StdCtrls,
  OvcDate, ovcxfer, ovcedit, ovceditu;


type
  {transfer buffer for the TestOvcTransferForm form}
  TTestOvcTransferFormTransferRec1 = packed record
    Edit1Text               : string;
    Label1Text              : string;
    Memo1Lines              : TStrings;
    CheckBox1Checked        : Boolean;
    RadioButton1Checked     : Boolean;
    ComboBox1Xfer           : TComboBoxTransfer;
    OvcSimpleField1Value    : string;
    OvcSimpleField2Value    : Integer;
    OvcSimpleField3Value    : Double;
    OvcSimpleField4Value    : Boolean;
    OvcSimpleField5Value    : Char;
    OvcPictureField1Value   : string;
    OvcPictureField2Value   : TStDate;
    OvcPictureField3Value   : TDateTime;
    OvcPictureField4Value   : Integer;
    OvcNumericField1Value   : Integer;
    OvcNumericField2Value   : Extended;
    OvcNumericField3Value   : ShortInt;
    OvcRotatedLabel1Text    : string;
    OvcEditor1Text          : string;
  end;

  TTestOvcTransferFormTransferRec2 = packed record
    Edit1Text               : array[0..30] of Char;
    Label1Text              : array[0..255] of Char;
    CheckBox1Checked        : Boolean;
    RadioButton1Checked     : Boolean;
    OvcSimpleField1Value    : array[0..25] of Char;
    OvcSimpleField2Value    : Integer;
    OvcSimpleField3Value    : Double;
    OvcSimpleField4Value    : Boolean;
    OvcSimpleField5Value    : Char;
    OvcPictureField1Value   : array[0..25] of Char;
    OvcPictureField2Value   : TStDate;
    OvcPictureField3Value   : TDateTime;
    OvcPictureField4Value   : Integer;
    OvcNumericField1Value   : Integer;
    OvcNumericField2Value   : Extended;
    OvcNumericField3Value   : ShortInt;
    OvcRotatedLabel1Text    : array[0..255] of Char;
    OvcEditor1Text          : array[0..255] of Char;
  end;

  TTestOvcTransferFormTransferRec3 = packed record
    Edit1Text               : string[30];
    Label1Text              : ShortString;
    CheckBox1Checked        : Boolean;
    RadioButton1Checked     : Boolean;
    OvcSimpleField1Value    : string[25];
    OvcSimpleField2Value    : Integer;
    OvcSimpleField3Value    : Double;
    OvcSimpleField4Value    : Boolean;
    OvcSimpleField5Value    : Char;
    OvcPictureField1Value   : string[25];
    OvcPictureField2Value   : TStDate;
    OvcPictureField3Value   : TDateTime;
    OvcPictureField4Value   : Integer;
    OvcNumericField1Value   : Integer;
    OvcNumericField2Value   : Extended;
    OvcNumericField3Value   : ShortInt;
    OvcRotatedLabel1Text    : ShortString;
    OvcEditor1Text          : ShortString;
  end;

  TTestOvcTransferForm = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Memo1: TMemo;
    CheckBox1: TCheckBox;
    RadioButton1: TRadioButton;
    ComboBox1: TComboBox;
    OvcSimpleField1: TOvcSimpleField;
    OvcSimpleField2: TOvcSimpleField;
    OvcSimpleField3: TOvcSimpleField;
    OvcSimpleField4: TOvcSimpleField;
    OvcPictureField1: TOvcPictureField;
    OvcPictureField2: TOvcPictureField;
    OvcPictureField3: TOvcPictureField;
    OvcPictureField4: TOvcPictureField;
    OvcNumericField1: TOvcNumericField;
    OvcNumericField2: TOvcNumericField;
    OvcNumericField3: TOvcNumericField;
    OvcRotatedLabel1: TOvcRotatedLabel;
    OvcTransfer1: TOvcTransfer;
    OvcSimpleField5: TOvcSimpleField;
    OvcEditor1: TOvcEditor;
  private
    procedure InitRec1(var Data : TTestOvcTransferFormTransferRec1);
    procedure InitRec2(var Data : TTestOvcTransferFormTransferRec2);
    procedure InitRec3(var Data : TTestOvcTransferFormTransferRec3);
 end;

  TTestOvcTransfer = class(TTestCase)
  private
    FForm: TTestOvcTransferForm;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestTransferToForm1;
    procedure TestTransferFromForm1;
    procedure TestTransferToForm2;
    procedure TestTransferFromForm2;
    procedure TestTransferToForm3;
    procedure TestTransferFromForm3;
  end;

var
  TestOvcTransferForm: TTestOvcTransferForm;

implementation

{$R *.dfm}


procedure TTestOvcTransferForm.InitRec1(var Data : TTestOvcTransferFormTransferRec1);
  {-initialize transfer buffer}
begin
  with Data do begin
    Edit1Text               := '';
    Label1Text              := '';
    Memo1Lines              := TStringList.Create;
    CheckBox1Checked        := False;
    RadioButton1Checked     := False;
    ComboBox1Xfer.Items     := TStringList.Create;
    ComboBox1Xfer.ItemIndex := 0;
    ComboBox1Xfer.Text      := '';
    OvcSimpleField1Value    := '';
    OvcSimpleField2Value    := 0;
    OvcSimpleField3Value    := 0;
    OvcSimpleField4Value    := False;
    OvcSimpleField5Value    := 'X';
    OvcPictureField1Value   := '';
    OvcPictureField2Value   := OvcDate.BadDate;
    OvcPictureField3Value   := 0;
    OvcPictureField4Value   := 0;
    OvcNumericField1Value   := 0;
    OvcNumericField2Value   := 0;
    OvcNumericField3Value   := 0;
    OvcRotatedLabel1Text    := '';
    OvcEditor1Text          := '';
  end; {with}
end;

procedure TTestOvcTransferForm.InitRec2(var Data : TTestOvcTransferFormTransferRec2);
  {-initialize transfer buffer}
begin
  with Data do begin
    Edit1Text               := '';
    Label1Text              := '';
    CheckBox1Checked        := False;
    RadioButton1Checked     := False;
    OvcSimpleField1Value    := '';
    OvcSimpleField2Value    := 0;
    OvcSimpleField3Value    := 0;
    OvcSimpleField4Value    := False;
    OvcSimpleField5Value    := 'Y';
    OvcPictureField1Value   := '';
    OvcPictureField2Value   := OvcDate.BadDate;
    OvcPictureField3Value   := 0;
    OvcPictureField4Value   := 0;
    OvcNumericField1Value   := 0;
    OvcNumericField2Value   := 0;
    OvcNumericField3Value   := 0;
    OvcRotatedLabel1Text    := '';
    OvcEditor1Text          := '';
  end; {with}
end;

procedure TTestOvcTransferForm.InitRec3(var Data : TTestOvcTransferFormTransferRec3);
  {-initialize transfer buffer}
begin
  with Data do begin
    Edit1Text               := '';
    Label1Text              := '';
    CheckBox1Checked        := False;
    RadioButton1Checked     := False;
    OvcSimpleField1Value    := '';
    OvcSimpleField2Value    := 0;
    OvcSimpleField3Value    := 0;
    OvcSimpleField4Value    := False;
    OvcSimpleField5Value    := 'Z';
    OvcPictureField1Value   := '';
    OvcPictureField2Value   := OvcDate.BadDate;
    OvcPictureField3Value   := 0;
    OvcPictureField4Value   := 0;
    OvcNumericField1Value   := 0;
    OvcNumericField2Value   := 0;
    OvcNumericField3Value   := 0;
    OvcRotatedLabel1Text    := '';
    OvcEditor1Text          := '';
  end; {with}
end;


procedure TTestOvcTransfer.SetUp;
begin
  inherited SetUp;
  FForm := TTestOvcTransferForm.Create(nil);
  FForm.Show;
  Application.ProcessMessages;
end;


procedure TTestOvcTransfer.TearDown;
begin
  FForm.Free;
  inherited TearDown;
end;


procedure TTestOvcTransfer.TestTransferToForm1;
var
  TR : TTestOvcTransferFormTransferRec1;
  OrTransfer1: TOvcTransfer;
begin
  FForm.InitRec1(TR);
  with TR do begin
    Edit1Text               := 'Edit1Text';
    Label1Text              := 'Label1Text';
    Memo1Lines.Text         := 'Line 1'#13#10'Line 2';
    CheckBox1Checked        := False;
    RadioButton1Checked     := True;
    ComboBox1Xfer.Items.Text := '1st item'#13#10'2ndt item'#13#10'3rd item';
    ComboBox1Xfer.Text      := 'ComboBox1Xfer.Text';
    OvcSimpleField1Value    := 'OvcSimpleField1Value';
    OvcSimpleField2Value    := 42;
    OvcSimpleField3Value    := 42;
    OvcSimpleField4Value    := False;
    OvcSimpleField5Value    := 'Ѻ';
    OvcPictureField1Value   := 'OvcPictureField1Value';
    OvcPictureField2Value   := OvcDate.DMYtoStDate(27,03,2011,0);
    OvcPictureField3Value   := EncodeDateTime(2011, 3, 27, 22, 27, 01, 0);
    OvcPictureField4Value   := 42;
    OvcNumericField1Value   := 43;
    OvcNumericField2Value   := 44;
    OvcNumericField3Value   := 45;
    OvcRotatedLabel1Text    := 'OvcRotatedLabel1Text';
    OvcEditor1Text          := 'Съешь ещё этих мягких'#13#10'французских булок, да выпей чаю';

  end;

  OrTransfer1 := TOvcTransfer.Create(nil);
  try
    OrTransfer1.TransferToForm([FForm.Edit1,
                                FForm.Label1,
                                FForm.Memo1,
                                FForm.CheckBox1,
                                FForm.RadioButton1,
                                FForm.ComboBox1,
                                FForm.OvcSimpleField1,
                                FForm.OvcSimpleField2,
                                FForm.OvcSimpleField3,
                                FForm.OvcSimpleField4,
                                FForm.OvcSimpleField5,
                                FForm.OvcPictureField1,
                                FForm.OvcPictureField2,
                                FForm.OvcPictureField3,
                                FForm.OvcPictureField4,
                                FForm.OvcNumericField1,
                                FForm.OvcNumericField2,
                                FForm.OvcNumericField3,
                                FForm.OvcRotatedLabel1,
                                FForm.OvcEditor1], TR);

    CheckEquals(TR.Edit1Text,                FForm.Edit1.Text,                  'Test failed for Edit1');
    CheckEquals(TR.Label1Text,               FForm.Label1.Caption,              'Test failed for Label1');
    CheckEquals(TR.Memo1Lines.Text,          FForm.Memo1.Lines.Text,            'Test failed for Memo1');
    CheckEquals(TR.CheckBox1Checked,         FForm.CheckBox1.Checked,           'Test failed for CheckBox1');
    CheckEquals(TR.RadioButton1Checked,      FForm.RadioButton1.Checked,        'Test failed for RadioButton1');
    CheckEquals(TR.ComboBox1Xfer.ItemIndex,  FForm.ComboBox1.ItemIndex,         'Test failed for ComboBox1.ItemIndex');
    CheckEquals(TR.ComboBox1Xfer.Text,       FForm.ComboBox1.Text,              'Test failed for ComboBox1.Text');
    CheckEquals(TR.ComboBox1Xfer.Items.Text, FForm.ComboBox1.Items.Text,        'Test failed for ComboBox1.Items.Text');
    CheckEquals(TR.OvcSimpleField1Value,     FForm.OvcSimpleField1.AsString,    'Test failed for OvcSimpleField1');
    CheckEquals(TR.OvcSimpleField2Value,     FForm.OvcSimpleField2.AsInteger,   'Test failed for OvcSimpleField2');
    CheckEquals(TR.OvcSimpleField3Value,     FForm.OvcSimpleField3.AsFloat,     'Test failed for OvcSimpleField3');
    CheckEquals(TR.OvcSimpleField4Value,     FForm.OvcSimpleField4.AsBoolean,   'Test failed for OvcSimpleField4');
    CheckEquals(TR.OvcSimpleField5Value,     FForm.OvcSimpleField5.AsString,    'Test failed for OvcSimpleField5');
    CheckEquals(TR.OvcPictureField1Value,    FForm.OvcPictureField1.AsString,   'Test failed for OvcPictureField1');
    CheckEquals(TR.OvcPictureField2Value,    FForm.OvcPictureField2.AsOvcDate,  'Test failed for OvcPictureField2');
    CheckEquals(TR.OvcPictureField3Value,    FForm.OvcPictureField3.AsDateTime, 'Test failed for OvcPictureField3');
    CheckEquals(TR.OvcPictureField4Value,    FForm.OvcPictureField4.AsInteger,  'Test failed for OvcPictureField4');
    CheckEquals(TR.OvcNumericField1Value,    FForm.OvcNumericField1.AsInteger,  'Test failed for OvcNumericField1');
    CheckEquals(TR.OvcNumericField2Value,    FForm.OvcNumericField2.AsExtended, 'Test failed for OvcNumericField2');
    CheckEquals(TR.OvcNumericField3Value,    FForm.OvcNumericField3.AsInteger,  'Test failed for OvcNumericField3');
    CheckEquals(TR.OvcRotatedLabel1Text,     FForm.OvcRotatedLabel1.Caption,    'Test failed for OvcRotatedLabel1');
    CheckEquals(TR.OvcEditor1Text,           FForm.OvcEditor1.Text,             'Test failed for OvcEditor1');
  finally
    OrTransfer1.Free;
  end;
end;


procedure TTestOvcTransfer.TestTransferFromForm1;
var
  TR : TTestOvcTransferFormTransferRec1;
  OrTransfer1: TOvcTransfer;
begin
  with FForm do begin
    Edit1.Text                  := 'Edit1Text';
    Label1.Caption              := 'Label1Text';
    Memo1.Lines.Text            := 'Line1'#13#10'Line2'#13#10;
    CheckBox1.Checked           := True;
    RadioButton1.Checked        := True;
    ComboBox1.Items.Text        := 'Item1'#13#10'Item2'#13#10'Item31';
    ComboBox1.ItemIndex         := 2;
    ComboBox1.Text              := 'ComboText';
    OvcSimpleField1.AsString    := 'OvcSimpleField1.AsString';
    OvcSimpleField2.AsInteger   := 12345;
    OvcSimpleField3.AsFloat     := 43.5;
    OvcSimpleField4.AsBoolean   := True;
    OvcSimpleField5.AsString    := 'Ѻ';
    OvcPictureField1.AsString   := 'OvcPictureField1.AsString';
    OvcPictureField2.AsOvcDate  := OvcDate.DMYtoStDate(14, 4, 1968, 0);
    OvcPictureField3.AsDateTime := EncodeDateTime(2011, 3, 27, 22, 27, 01, 0);
    OvcPictureField4.AsInteger  := 5432;
    OvcNumericField1.AsInteger  := 1000;
    OvcNumericField2.AsExtended := 31.25;
    OvcNumericField3.AsInteger  := -7;
    OvcRotatedLabel1.Caption    := 'OvcRotatedLabel1';
    OvcEditor1.Text             := 'Arepo sator'#13#10'tenet'#13#10'rotas opera';
  end;

  FForm.InitRec1(TR);
  OrTransfer1 := TOvcTransfer.Create(nil);
  try
    OrTransfer1.TransferFromForm([FForm.Edit1,
                                  FForm.Label1,
                                  FForm.Memo1,
                                  FForm.CheckBox1,
                                  FForm.RadioButton1,
                                  FForm.ComboBox1,
                                  FForm.OvcSimpleField1,
                                  FForm.OvcSimpleField2,
                                  FForm.OvcSimpleField3,
                                  FForm.OvcSimpleField4,
                                  FForm.OvcSimpleField5,
                                  FForm.OvcPictureField1,
                                  FForm.OvcPictureField2,
                                  FForm.OvcPictureField3,
                                  FForm.OvcPictureField4,
                                  FForm.OvcNumericField1,
                                  FForm.OvcNumericField2,
                                  FForm.OvcNumericField3,
                                  FForm.OvcRotatedLabel1,
                                  FForm.OvcEditor1], TR);

    CheckEquals(FForm.Edit1.Text,           TR.Edit1Text,                'Test failed for Edit1');
    CheckEquals(FForm.Label1.Caption,       TR.Label1Text,               'Test failed for Label1');
    CheckEquals(FForm.Memo1.Lines.Text,     TR.Memo1Lines.Text,          'Test failed for Memo1');
    CheckEquals(FForm.CheckBox1.Checked,    TR.CheckBox1Checked,         'Test failed for CheckBox1');
    CheckEquals(FForm.RadioButton1.Checked, TR.RadioButton1Checked,      'Test failed for RadioButton1');
    CheckEquals(FForm.ComboBox1.ItemIndex,  TR.ComboBox1Xfer.ItemIndex,  'Test failed for ComboBox1.ItemIndex');
    CheckEquals(FForm.ComboBox1.Text,       TR.ComboBox1Xfer.Text,       'Test failed for ComboBox1.Text');
    CheckEquals(FForm.ComboBox1.Items.Text, TR.ComboBox1Xfer.Items.Text, 'Test failed for ComboBox1.Items.Text');
    CheckEquals(FForm.OvcSimpleField1.AsString,    TR.OvcSimpleField1Value,  'Test failed for OvcSimpleField1');
    CheckEquals(FForm.OvcSimpleField2.AsInteger,   TR.OvcSimpleField2Value,  'Test failed for OvcSimpleField2');
    CheckEquals(FForm.OvcSimpleField3.AsFloat,     TR.OvcSimpleField3Value,  'Test failed for OvcSimpleField3');
    CheckEquals(FForm.OvcSimpleField4.AsBoolean,   TR.OvcSimpleField4Value,  'Test failed for OvcSimpleField4');
    CheckEquals(FForm.OvcSimpleField5.AsString,    TR.OvcSimpleField5Value,  'Test failed for OvcSimpleField5');
    CheckEquals(FForm.OvcPictureField1.AsString,   TR.OvcPictureField1Value, 'Test failed for OvcPictureField1');
    CheckEquals(FForm.OvcPictureField2.AsOvcDate,  TR.OvcPictureField2Value, 'Test failed for OvcPictureField2');
    CheckEquals(FForm.OvcPictureField3.AsDateTime, TR.OvcPictureField3Value, 'Test failed for OvcPictureField3');
    CheckEquals(FForm.OvcPictureField4.AsInteger,  TR.OvcPictureField4Value, 'Test failed for OvcPictureField4');
    CheckEquals(FForm.OvcNumericField1.AsInteger,  TR.OvcNumericField1Value, 'Test failed for OvcNumericField1');
    CheckEquals(FForm.OvcNumericField2.AsExtended, TR.OvcNumericField2Value, 'Test failed for OvcNumericField2');
    CheckEquals(FForm.OvcNumericField3.AsInteger,  TR.OvcNumericField3Value, 'Test failed for OvcNumericField3');
    CheckEquals(FForm.OvcRotatedLabel1.Caption,    TR.OvcRotatedLabel1Text,  'Test failed for OvcRotatedLabel1');
    CheckEquals(FForm.OvcEditor1.Text,             TR.OvcEditor1Text,        'Test failed for OvcEditor1');
  finally
    OrTransfer1.Free;
  end;
end;


procedure TTestOvcTransfer.TestTransferToForm2;
var
  TR : TTestOvcTransferFormTransferRec2;
  OrTransfer1: TOvcTransfer;
begin
  FForm.InitRec2(TR);
  with TR do begin
    Edit1Text               := 'Edit1Text';
    Label1Text              := 'Label1Text';
    CheckBox1Checked        := False;
    RadioButton1Checked     := True;
    OvcSimpleField1Value    := 'OvcSimpleField1Value';
    OvcSimpleField2Value    := 42;
    OvcSimpleField3Value    := 42;
    OvcSimpleField4Value    := False;
    OvcSimpleField5Value    := 'Ѻ';
    OvcPictureField1Value   := 'OvcPictureField1Value';
    OvcPictureField2Value   := OvcDate.DMYtoStDate(27,03,2011,0);
    OvcPictureField3Value   := EncodeDateTime(2011, 3, 27, 22, 27, 01, 0);
    OvcPictureField4Value   := 42;
    OvcNumericField1Value   := 43;
    OvcNumericField2Value   := 44;
    OvcNumericField3Value   := 45;
    OvcRotatedLabel1Text    := 'OvcRotatedLabel1Text';
    OvcEditor1Text          := 'The quick brown fox'#13#10'jumps over the lazy dog.';
  end;

  OrTransfer1 := TOvcTransfer.Create(nil);
  try
    OrTransfer1.TransferToFormZ([FForm.Edit1,
                                FForm.Label1,
                                FForm.CheckBox1,
                                FForm.RadioButton1,
                                FForm.OvcSimpleField1,
                                FForm.OvcSimpleField2,
                                FForm.OvcSimpleField3,
                                FForm.OvcSimpleField4,
                                FForm.OvcSimpleField5,
                                FForm.OvcPictureField1,
                                FForm.OvcPictureField2,
                                FForm.OvcPictureField3,
                                FForm.OvcPictureField4,
                                FForm.OvcNumericField1,
                                FForm.OvcNumericField2,
                                FForm.OvcNumericField3,
                                FForm.OvcRotatedLabel1,
                                FForm.OvcEditor1], TR);

    CheckEquals(TR.Edit1Text,                FForm.Edit1.Text,                  'Test failed for Edit1');
    CheckEquals(TR.Label1Text,               FForm.Label1.Caption,              'Test failed for Label1');
    CheckEquals(TR.CheckBox1Checked,         FForm.CheckBox1.Checked,           'Test failed for CheckBox1');
    CheckEquals(TR.RadioButton1Checked,      FForm.RadioButton1.Checked,        'Test failed for RadioButton1');
    CheckEquals(TR.OvcSimpleField1Value,     FForm.OvcSimpleField1.AsString,    'Test failed for OvcSimpleField1');
    CheckEquals(TR.OvcSimpleField2Value,     FForm.OvcSimpleField2.AsInteger,   'Test failed for OvcSimpleField2');
    CheckEquals(TR.OvcSimpleField3Value,     FForm.OvcSimpleField3.AsFloat,     'Test failed for OvcSimpleField3');
    CheckEquals(TR.OvcSimpleField4Value,     FForm.OvcSimpleField4.AsBoolean,   'Test failed for OvcSimpleField4');
    CheckEquals(TR.OvcSimpleField5Value,     FForm.OvcSimpleField5.AsString,    'Test failed for OvcSimpleField5');
    CheckEquals(TR.OvcPictureField1Value,    FForm.OvcPictureField1.AsString,   'Test failed for OvcPictureField1');
    CheckEquals(TR.OvcPictureField2Value,    FForm.OvcPictureField2.AsOvcDate,  'Test failed for OvcPictureField2');
    CheckEquals(TR.OvcPictureField3Value,    FForm.OvcPictureField3.AsDateTime, 'Test failed for OvcPictureField3');
    CheckEquals(TR.OvcPictureField4Value,    FForm.OvcPictureField4.AsInteger,  'Test failed for OvcPictureField4');
    CheckEquals(TR.OvcNumericField1Value,    FForm.OvcNumericField1.AsInteger,  'Test failed for OvcNumericField1');
    CheckEquals(TR.OvcNumericField2Value,    FForm.OvcNumericField2.AsExtended, 'Test failed for OvcNumericField2');
    CheckEquals(TR.OvcNumericField3Value,    FForm.OvcNumericField3.AsInteger,  'Test failed for OvcNumericField3');
    CheckEquals(TR.OvcRotatedLabel1Text,     FForm.OvcRotatedLabel1.Caption,    'Test failed for OvcRotatedLabel1');
    CheckEquals(TR.OvcEditor1Text,           FForm.OvcEditor1.Text,             'Test failed for OvcEditor1');
  finally
    OrTransfer1.Free;
  end;
end;


procedure TTestOvcTransfer.TestTransferFromForm2;
var
  TR : TTestOvcTransferFormTransferRec2;
  OrTransfer1: TOvcTransfer;
begin
  with FForm do begin
    Edit1.Text                  := 'Edit1Text';
    Label1.Caption              := 'Label1Text';
    Memo1.Lines.Text            := 'Line1'#13#10'Line2'#13#10;
    CheckBox1.Checked           := True;
    RadioButton1.Checked        := True;
    ComboBox1.Items.Text        := 'Item1'#13#10'Item2'#13#10'Item31';
    ComboBox1.ItemIndex         := 2;
    ComboBox1.Text              := 'ComboText';
    OvcSimpleField1.AsString    := 'OvcSimpleField1.AsString';
    OvcSimpleField2.AsInteger   := 12345;
    OvcSimpleField3.AsFloat     := 43.5;
    OvcSimpleField4.AsBoolean   := True;
    OvcSimpleField5.AsString    := 'Ѻ';
    OvcPictureField1.AsString   := 'OvcPictureField1.AsString';
    OvcPictureField2.AsOvcDate  := OvcDate.DMYtoStDate(14, 4, 1968, 0);
    OvcPictureField3.AsDateTime := EncodeDateTime(2011, 3, 27, 22, 27, 01, 0);
    OvcPictureField4.AsInteger  := 5432;
    OvcNumericField1.AsInteger  := 1000;
    OvcNumericField2.AsExtended := 31.25;
    OvcNumericField3.AsInteger  := -7;
    OvcRotatedLabel1.Caption    := 'OvcRotatedLabel1';
    OvcEditor1.Text             := 'Arepo sator'#13#10'tenet'#13#10'rotas opera';
  end;

  FForm.InitRec2(TR);
  OrTransfer1 := TOvcTransfer.Create(nil);
  try
    OrTransfer1.TransferFromFormZ([FForm.Edit1,
                                  FForm.Label1,
                                  FForm.CheckBox1,
                                  FForm.RadioButton1,
                                  FForm.OvcSimpleField1,
                                  FForm.OvcSimpleField2,
                                  FForm.OvcSimpleField3,
                                  FForm.OvcSimpleField4,
                                  FForm.OvcSimpleField5,
                                  FForm.OvcPictureField1,
                                  FForm.OvcPictureField2,
                                  FForm.OvcPictureField3,
                                  FForm.OvcPictureField4,
                                  FForm.OvcNumericField1,
                                  FForm.OvcNumericField2,
                                  FForm.OvcNumericField3,
                                  FForm.OvcRotatedLabel1,
                                  FForm.OvcEditor1], TR);

    CheckEquals(FForm.Edit1.Text,           TR.Edit1Text,                'Test failed for Edit1');
    CheckEquals(FForm.Label1.Caption,       TR.Label1Text,               'Test failed for Label1');
    CheckEquals(FForm.CheckBox1.Checked,    TR.CheckBox1Checked,         'Test failed for CheckBox1');
    CheckEquals(FForm.RadioButton1.Checked, TR.RadioButton1Checked,      'Test failed for RadioButton1');
    CheckEquals(FForm.OvcSimpleField1.AsString,    TR.OvcSimpleField1Value,  'Test failed for OvcSimpleField1');
    CheckEquals(FForm.OvcSimpleField2.AsInteger,   TR.OvcSimpleField2Value,  'Test failed for OvcSimpleField2');
    CheckEquals(FForm.OvcSimpleField3.AsFloat,     TR.OvcSimpleField3Value,  'Test failed for OvcSimpleField3');
    CheckEquals(FForm.OvcSimpleField4.AsBoolean,   TR.OvcSimpleField4Value,  'Test failed for OvcSimpleField4');
    CheckEquals(FForm.OvcSimpleField5.AsString,    TR.OvcSimpleField5Value,  'Test failed for OvcSimpleField5');
    CheckEquals(FForm.OvcPictureField1.AsString,   TR.OvcPictureField1Value, 'Test failed for OvcPictureField1');
    CheckEquals(FForm.OvcPictureField2.AsOvcDate,  TR.OvcPictureField2Value, 'Test failed for OvcPictureField2');
    CheckEquals(FForm.OvcPictureField3.AsDateTime, TR.OvcPictureField3Value, 'Test failed for OvcPictureField3');
    CheckEquals(FForm.OvcPictureField4.AsInteger,  TR.OvcPictureField4Value, 'Test failed for OvcPictureField4');
    CheckEquals(FForm.OvcNumericField1.AsInteger,  TR.OvcNumericField1Value, 'Test failed for OvcNumericField1');
    CheckEquals(FForm.OvcNumericField2.AsExtended, TR.OvcNumericField2Value, 'Test failed for OvcNumericField2');
    CheckEquals(FForm.OvcNumericField3.AsInteger,  TR.OvcNumericField3Value, 'Test failed for OvcNumericField3');
    CheckEquals(FForm.OvcRotatedLabel1.Caption,    TR.OvcRotatedLabel1Text,  'Test failed for OvcRotatedLabel1');
    CheckEquals(FForm.OvcEditor1.Text,             TR.OvcEditor1Text,        'Test failed for OvcEditor1');
  finally
    OrTransfer1.Free;
  end;
end;


procedure TTestOvcTransfer.TestTransferToForm3;
var
  TR : TTestOvcTransferFormTransferRec3;
  OrTransfer1: TOvcTransfer;
begin
  FForm.InitRec3(TR);
  with TR do begin
    Edit1Text               := 'Edit1Text';
    Label1Text              := 'Label1Text';
    CheckBox1Checked        := False;
    RadioButton1Checked     := True;
    OvcSimpleField1Value    := 'OvcSimpleField1Value';
    OvcSimpleField2Value    := 42;
    OvcSimpleField3Value    := 42;
    OvcSimpleField4Value    := False;
    OvcSimpleField5Value    := 'Ѻ';
    OvcPictureField1Value   := 'OvcPictureField1Value';
    OvcPictureField2Value   := OvcDate.DMYtoStDate(27,03,2011,0);
    OvcPictureField3Value   := EncodeDateTime(2011, 3, 27, 22, 27, 01, 0);
    OvcPictureField4Value   := 42;
    OvcNumericField1Value   := 43;
    OvcNumericField2Value   := 44;
    OvcNumericField3Value   := 45;
    OvcRotatedLabel1Text    := 'OvcRotatedLabel1Text';
    OvcEditor1Text          := 'The quick brown fox'#13#10'jumps over the lazy dog.';
  end;

  OrTransfer1 := TOvcTransfer.Create(nil);
  try
    OrTransfer1.TransferToFormS([FForm.Edit1,
                                FForm.Label1,
                                FForm.CheckBox1,
                                FForm.RadioButton1,
                                FForm.OvcSimpleField1,
                                FForm.OvcSimpleField2,
                                FForm.OvcSimpleField3,
                                FForm.OvcSimpleField4,
                                FForm.OvcSimpleField5,
                                FForm.OvcPictureField1,
                                FForm.OvcPictureField2,
                                FForm.OvcPictureField3,
                                FForm.OvcPictureField4,
                                FForm.OvcNumericField1,
                                FForm.OvcNumericField2,
                                FForm.OvcNumericField3,
                                FForm.OvcRotatedLabel1,
                                FForm.OvcEditor1], TR);

    CheckEquals(string(TR.Edit1Text),            FForm.Edit1.Text,                  'Test failed for Edit1');
    CheckEquals(string(TR.Label1Text),           FForm.Label1.Caption,              'Test failed for Label1');
    CheckEquals(TR.CheckBox1Checked,             FForm.CheckBox1.Checked,           'Test failed for CheckBox1');
    CheckEquals(TR.RadioButton1Checked,          FForm.RadioButton1.Checked,        'Test failed for RadioButton1');
    CheckEquals(string(TR.OvcSimpleField1Value), FForm.OvcSimpleField1.AsString,    'Test failed for OvcSimpleField1');
    CheckEquals(TR.OvcSimpleField2Value,         FForm.OvcSimpleField2.AsInteger,   'Test failed for OvcSimpleField2');
    CheckEquals(TR.OvcSimpleField3Value,         FForm.OvcSimpleField3.AsFloat,     'Test failed for OvcSimpleField3');
    CheckEquals(TR.OvcSimpleField4Value,         FForm.OvcSimpleField4.AsBoolean,   'Test failed for OvcSimpleField4');
    CheckEquals(TR.OvcSimpleField5Value,         FForm.OvcSimpleField5.AsString,    'Test failed for OvcSimpleField5');
    CheckEquals(string(TR.OvcPictureField1Value),FForm.OvcPictureField1.AsString,   'Test failed for OvcPictureField1');
    CheckEquals(TR.OvcPictureField2Value,        FForm.OvcPictureField2.AsOvcDate,  'Test failed for OvcPictureField2');
    CheckEquals(TR.OvcPictureField3Value,        FForm.OvcPictureField3.AsDateTime, 'Test failed for OvcPictureField3');
    CheckEquals(TR.OvcPictureField4Value,        FForm.OvcPictureField4.AsInteger,  'Test failed for OvcPictureField4');
    CheckEquals(TR.OvcNumericField1Value,        FForm.OvcNumericField1.AsInteger,  'Test failed for OvcNumericField1');
    CheckEquals(TR.OvcNumericField2Value,        FForm.OvcNumericField2.AsExtended, 'Test failed for OvcNumericField2');
    CheckEquals(TR.OvcNumericField3Value,        FForm.OvcNumericField3.AsInteger,  'Test failed for OvcNumericField3');
    CheckEquals(string(TR.OvcRotatedLabel1Text), FForm.OvcRotatedLabel1.Caption,    'Test failed for OvcRotatedLabel1');
    CheckEquals(string(TR.OvcEditor1Text),       FForm.OvcEditor1.Text,             'Test failed for OvcEditor1');
  finally
    OrTransfer1.Free;
  end;
end;


procedure TTestOvcTransfer.TestTransferFromForm3;
var
  TR : TTestOvcTransferFormTransferRec3;
  OrTransfer1: TOvcTransfer;
begin
  with FForm do begin
    Edit1.Text                  := 'Edit1Text';
    Label1.Caption              := 'Label1Text';
    Memo1.Lines.Text            := 'Line1'#13#10'Line2'#13#10;
    CheckBox1.Checked           := True;
    RadioButton1.Checked        := True;
    ComboBox1.Items.Text        := 'Item1'#13#10'Item2'#13#10'Item31';
    ComboBox1.ItemIndex         := 2;
    ComboBox1.Text              := 'ComboText';
    OvcSimpleField1.AsString    := 'OvcSimpleField1.AsString';
    OvcSimpleField2.AsInteger   := 12345;
    OvcSimpleField3.AsFloat     := 43.5;
    OvcSimpleField4.AsBoolean   := True;
    OvcSimpleField5.AsString    := 'Ѻ';
    OvcPictureField1.AsString   := 'OvcPictureField1.AsString';
    OvcPictureField2.AsOvcDate  := OvcDate.DMYtoStDate(14, 4, 1968, 0);
    OvcPictureField3.AsDateTime := EncodeDateTime(2011, 3, 27, 22, 27, 01, 0);
    OvcPictureField4.AsInteger  := 5432;
    OvcNumericField1.AsInteger  := 1000;
    OvcNumericField2.AsExtended := 31.25;
    OvcNumericField3.AsInteger  := -7;
    OvcRotatedLabel1.Caption    := 'OvcRotatedLabel1';
    OvcEditor1.Text             := 'Arepo sator'#13#10'tenet'#13#10'rotas opera';
  end;

  FForm.InitRec3(TR);
  OrTransfer1 := TOvcTransfer.Create(nil);
  try
    OrTransfer1.TransferFromFormS([FForm.Edit1,
                                  FForm.Label1,
                                  FForm.CheckBox1,
                                  FForm.RadioButton1,
                                  FForm.OvcSimpleField1,
                                  FForm.OvcSimpleField2,
                                  FForm.OvcSimpleField3,
                                  FForm.OvcSimpleField4,
                                  FForm.OvcSimpleField5,
                                  FForm.OvcPictureField1,
                                  FForm.OvcPictureField2,
                                  FForm.OvcPictureField3,
                                  FForm.OvcPictureField4,
                                  FForm.OvcNumericField1,
                                  FForm.OvcNumericField2,
                                  FForm.OvcNumericField3,
                                  FForm.OvcRotatedLabel1,
                                  FForm.OvcEditor1], TR);

    CheckEquals(FForm.Edit1.Text,           string(TR.Edit1Text),        'Test failed for Edit1');
    CheckEquals(FForm.Label1.Caption,       string(TR.Label1Text),       'Test failed for Label1');
    CheckEquals(FForm.CheckBox1.Checked,    TR.CheckBox1Checked,         'Test failed for CheckBox1');
    CheckEquals(FForm.RadioButton1.Checked, TR.RadioButton1Checked,      'Test failed for RadioButton1');
    CheckEquals(FForm.OvcSimpleField1.AsString,    string(TR.OvcSimpleField1Value),  'Test failed for OvcSimpleField1');
    CheckEquals(FForm.OvcSimpleField2.AsInteger,   TR.OvcSimpleField2Value,          'Test failed for OvcSimpleField2');
    CheckEquals(FForm.OvcSimpleField3.AsFloat,     TR.OvcSimpleField3Value,          'Test failed for OvcSimpleField3');
    CheckEquals(FForm.OvcSimpleField4.AsBoolean,   TR.OvcSimpleField4Value,          'Test failed for OvcSimpleField4');
    CheckEquals(FForm.OvcSimpleField5.AsString,    TR.OvcSimpleField5Value,          'Test failed for OvcSimpleField5');
    CheckEquals(FForm.OvcPictureField1.AsString,   string(TR.OvcPictureField1Value), 'Test failed for OvcPictureField1');
    CheckEquals(FForm.OvcPictureField2.AsOvcDate,  TR.OvcPictureField2Value,         'Test failed for OvcPictureField2');
    CheckEquals(FForm.OvcPictureField3.AsDateTime, TR.OvcPictureField3Value, 'Test failed for OvcPictureField3');
    CheckEquals(FForm.OvcPictureField4.AsInteger,  TR.OvcPictureField4Value,         'Test failed for OvcPictureField4');
    CheckEquals(FForm.OvcNumericField1.AsInteger,  TR.OvcNumericField1Value,         'Test failed for OvcNumericField1');
    CheckEquals(FForm.OvcNumericField2.AsExtended, TR.OvcNumericField2Value,         'Test failed for OvcNumericField2');
    CheckEquals(FForm.OvcNumericField3.AsInteger,  TR.OvcNumericField3Value,         'Test failed for OvcNumericField3');
    CheckEquals(FForm.OvcRotatedLabel1.Caption,    string(TR.OvcRotatedLabel1Text),  'Test failed for OvcRotatedLabel1');
    CheckEquals(FForm.OvcEditor1.Text,             string(TR.OvcEditor1Text),        'Test failed for OvcEditor1');
  finally
    OrTransfer1.Free;
  end;
end;


initialization
  RegisterTest(TTestOvcTransfer.Suite);
end.

