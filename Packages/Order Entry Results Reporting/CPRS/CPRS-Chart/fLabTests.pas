unit fLabTests;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ORCtrls, StdCtrls, ExtCtrls, fBase508Form, VA508AccessibilityManager;

type
  TfrmLabTests = class(TfrmBase508Form)
    pnlLabTests: TORAutoPanel;
    cmdOK: TButton;
    cmdCancel: TButton;
    lstList: TORListBox;
    cboTests: TORComboBox;
    cmdRemove: TButton;
    cmdClear: TButton;
    lblTests: TLabel;
    lblList: TLabel;
    cmdAdd: TButton;
    procedure FormCreate(Sender: TObject);
    procedure cboTestsNeedData(Sender: TObject; const StartFrom: string;
      Direction, InsertAt: Integer);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdClearClick(Sender: TObject);
    procedure cmdRemoveClick(Sender: TObject);
    procedure lstListClick(Sender: TObject);
    procedure cboTestsChange(Sender: TObject);
    procedure cboTestsEnter(Sender: TObject);
    procedure cboTestsExit(Sender: TObject);
    procedure cmdAddClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure SelectTests(FontSize: Integer);

implementation

uses fLabs, ORFn, rLabs, rMisc, VAUtils;

{$R *.DFM}

procedure SelectTests(FontSize: Integer);
var
  frmLabTests: TfrmLabTests;
  W, H: integer;
begin
  frmLabTests := TfrmLabTests.Create(Application);
  try
    with frmLabTests do
    begin
      Font.Size := FontSize;
      W := ClientWidth;
      H := ClientHeight;
      ResizeToFont(FontSize, W, H);
      ClientWidth := W; pnlLabTests.Width := W;
      ClientHeight := H; pnlLabTests.Height := H;
      SetFormPosition(frmLabTests);
      FastAssign(frmLabs.lstTests.Items, lstList.Items);
      if lstList.Items.Count > 0 then lstList.ItemIndex := 0;
      lstListClick(frmLabTests);
      ShowModal;
    end;
  finally
    frmLabTests.Release;
  end;
end;

procedure TfrmLabTests.FormCreate(Sender: TObject);
begin
  cboTests.LockDrawing;
  try
    cboTests.InitLongList('');
  finally
    cboTests.UnlockDrawing;
  end;
end;

procedure TfrmLabTests.cboTestsNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
// begin
// cboTests.ForDataUse(AllTests(StartFrom, Direction));
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

procedure TfrmLabTests.cmdOKClick(Sender: TObject);
begin
  if lstList.Items.Count = 0 then
    ShowMsg('No tests were selected.')
  else
  begin
    FastAssign(lstList.Items, frmLabs.lstTests.Items);
    Close;
  end;
end;

procedure TfrmLabTests.cmdClearClick(Sender: TObject);
begin
  lstList.Clear;
  lstListClick(self);
end;

procedure TfrmLabTests.cmdRemoveClick(Sender: TObject);
var
  newindex: integer;
begin
  if lstList.Items.Count > 0 then
  begin
    if lstList.ItemIndex = (lstList.Items.Count -1 ) then
      newindex := lstList.ItemIndex - 1
    else
      newindex := lstList.ItemIndex;
    lstList.Items.Delete(lstList.ItemIndex);
    if lstList.Items.Count > 0 then lstList.ItemIndex := newindex;
  end;
  lstListClick(self);
end;

procedure TfrmLabTests.lstListClick(Sender: TObject);
begin
  if lstList.Items.Count = 0 then
  begin
    cmdClear.Enabled := false;
    cmdRemove.Enabled := false;
  end
  else
  begin
    cmdClear.Enabled := true;
    cmdRemove.Enabled := true;
  end;
end;

procedure TfrmLabTests.cboTestsChange(Sender: TObject);
begin
  cmdAdd.Enabled := cboTests.ItemIndex > -1;
end;

procedure TfrmLabTests.cboTestsEnter(Sender: TObject);
begin
  cmdAdd.Default := true;
end;

procedure TfrmLabTests.cboTestsExit(Sender: TObject);
begin
  cmdAdd.Default := false;
end;

procedure TfrmLabTests.cmdAddClick(Sender: TObject);
var
  i, textindex: integer;
begin
  textindex := lstList.Items.Count;
  for i := 0 to lstList.Items.Count -1 do
    if lstList.Items[i] = cboTests.Items[cboTests.ItemIndex] then textindex := i;
  if textindex = lstList.Items.Count then lstList.Items.Add(cboTests.Items[cboTests.ItemIndex]);
  lstList.ItemIndex := textindex;
  lstListClick(self);
end;

procedure TfrmLabTests.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveUserBounds(Self);
end;

end.
