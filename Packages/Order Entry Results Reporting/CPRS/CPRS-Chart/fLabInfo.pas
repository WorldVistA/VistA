unit fLabInfo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, fAutoSz, ORFn, ORCtrls, VA508AccessibilityManager;

type
  TfrmLabInfo = class(TfrmAutoSz)
    Panel1: TPanel;
    btnOK: TButton;
    memInfo: TCaptionMemo;
    cboTests: TORComboBox;
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cboTestsNeedData(Sender: TObject; const StartFrom: string;
      Direction, InsertAt: Integer);
    procedure cboTestsClick(Sender: TObject);
  private
    { Private declarations }
    OKPressed: Boolean;
  public
    { Public declarations }
  end;

var
  frmLabInfo: TfrmLabInfo;
  function ExecuteLabInfo: Boolean;

implementation

uses fLabs, rLabs;

{$R *.DFM}

function ExecuteLabInfo: Boolean;
var
  frmLabInfo: TfrmLabInfo;
begin
  Result := False;
  frmLabInfo := TfrmLabInfo.Create(Application);
  try
    ResizeFormToFont(TForm(frmLabInfo));
    frmLabInfo.ShowModal;
    if frmLabInfo.OKPressed then
      Result := True;
  finally
    frmLabInfo.Release;
  end;
end;

procedure TfrmLabInfo.btnOKClick(Sender: TObject);
begin
  OKPressed := true;
  Close;
end;

procedure TfrmLabInfo.FormCreate(Sender: TObject);

begin
  cboTests.LockDrawing;
  try
    cboTests.InitLongList('');
  finally
    cboTests.UnlockDrawing;
  end;
end;

procedure TfrmLabInfo.cboTestsNeedData(Sender: TObject; const StartFrom: string;
  Direction, InsertAt: Integer);
var
  sl: TSTrings;
begin
  sl := TStringList.Create;
  try
    setAllTests(sl, StartFrom, Direction);
    cboTests.ForDataUse(sl);
  finally
    sl.Free;
  end;
end;

procedure TfrmLabInfo.cboTestsClick(Sender: TObject);
begin
  inherited;
  setTestInfo(memInfo.Lines, cboTests.Items[cboTests.ItemIndex]);
end;

end.
