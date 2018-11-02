unit TestOvcDbSimpleField;

interface

uses
  Testframework;

type
  TTestOvcDbSimpleField = class(TTestCase)
  published
    procedure TestStringField;
    procedure TestText;
  end;

implementation

uses
  DB, DBClient, Forms, ovcdbsf;

{ TTestOvcDbSimpleField }

procedure TTestOvcDbSimpleField.TestStringField;
var
  pForm: TForm;
  pDataSet: TClientDataSet;
  pDataSource: TDataSource;
  pField: TStringField;
  pSimple: TOvcDbSimpleField;
begin
  pForm := TForm.CreateNew(nil);
  try
    pDataSet := TClientDataSet.Create(pForm);

    pDataSource := TDataSource.Create(pForm);
    pDataSource.DataSet := pDataSet;

    pField := TStringField.Create(pForm);
    pField.FieldName := pField.ClassName;
    pField.DataSet := pDataSet;

    pDataSet.CreateDataSet;
    pDataSet.Append;
    pField.AsString := 'Wert1';
    pDataSet.Post;

    pSimple := TOvcDbSimpleField.Create(pForm);
    pSimple.Parent := pForm;
    pSimple.DataSource := pDataSource;
    pSimple.DataField := pField.FieldName;

    CheckEquals(pSimple.Text, pField.AsString);

    pSimple.Text := '';
  finally
    pForm.Free;
  end;
end;

procedure TTestOvcDbSimpleField.TestText;
var
  pForm: TForm;
  pSimple: TOvcDbSimpleField;
begin
  pForm := TForm.CreateNew(nil);
  try
    pSimple := TOvcDbSimpleField.Create(pForm);
    pSimple.Parent := pForm;
    pSimple.Text := 'Hallo World!';

    CheckEquals(pSimple.Text, 'Hallo World!');

    pSimple.Text := '';
  finally
    pForm.Free;
  end;
end;

initialization
  RegisterTest(TTestOvcDbSimpleField.Suite);

end.

