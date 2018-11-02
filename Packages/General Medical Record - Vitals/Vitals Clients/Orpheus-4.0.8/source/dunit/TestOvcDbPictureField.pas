unit TestOvcDbPictureField;

interface

uses
  Testframework;

type
  TTestOvcDbPictureField = class(TTestCase)
  published
    procedure TestEmptyStringField;
    procedure TestStringField;
    procedure TestText;
  end;

implementation

uses
  DB, DBClient, Forms, ovcdbpf;

{ TTestOvcDbPictureField }

procedure TTestOvcDbPictureField.TestEmptyStringField;
var
  pForm: TForm;
  pDataSet: TClientDataSet;
  pDataSource: TDataSource;
  pField: TStringField;
  pPicture: TOvcDbPictureField;
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
    pField.AsString := '';
    pDataSet.Post;

    pPicture := TOvcDbPictureField.Create(pForm);
    pPicture.Parent := pForm;
    pPicture.DataSource := pDataSource;
    pPicture.DataField := pField.FieldName;

    CheckEquals(pPicture.Text, pField.AsString);

    pPicture.Text := '';
  finally
    pForm.Free;
  end;
end;

procedure TTestOvcDbPictureField.TestStringField;
var
  pForm: TForm;
  pDataSet: TClientDataSet;
  pDataSource: TDataSource;
  pField: TStringField;
  pPicture: TOvcDbPictureField;
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

    pPicture := TOvcDbPictureField.Create(pForm);
    pPicture.Parent := pForm;
    pPicture.DataSource := pDataSource;
    pPicture.DataField := pField.FieldName;

    CheckEquals(pPicture.Text, pField.AsString);

    pPicture.Text := '';
  finally
    pForm.Free;
  end;
end;

procedure TTestOvcDbPictureField.TestText;
var
  pForm: TForm;
  pPicture: TOvcDbPictureField;
begin
  pForm := TForm.CreateNew(nil);
  try
    pPicture := TOvcDbPictureField.Create(pForm);
    pPicture.Parent := pForm;
    pPicture.Text := 'Hallo World!';

    CheckEquals(pPicture.Text, 'Hallo World!');

    pPicture.Text := '';
  finally
    pForm.Free;
  end;
end;

initialization
  RegisterTest(TTestOvcDbPictureField.Suite);

end.

