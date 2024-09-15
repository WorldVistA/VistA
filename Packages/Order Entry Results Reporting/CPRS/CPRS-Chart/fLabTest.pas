unit fLabTest;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ORCtrls, StdCtrls, ExtCtrls, ORNet, fBase508Form, VA508AccessibilityManager;

type
  TfrmLabTest = class(TfrmBase508Form)
    pnlLabTest: TORAutoPanel;
    cmdOK: TButton;
    cmdCancel: TButton;
    cboList: TORComboBox;
    cboSpecimen: TORComboBox;
    lblTest: TLabel;
    lblSpecimen: TLabel;
    lblSpecInfo: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure cboListNeedData(Sender: TObject; const StartFrom: string;
      Direction, InsertAt: Integer);
    procedure cboSpecimenNeedData(Sender: TObject; const StartFrom: string;
      Direction, InsertAt: Integer);
    procedure cmdOKClick(Sender: TObject);
    procedure cboListEnter(Sender: TObject);
    procedure cboListExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure SelectTest(FontSize: Integer);

implementation

uses fLabs, ORFn, rLabs, VAUtils;

{$R *.DFM}

procedure SelectTest(FontSize: Integer);
var
  frmLabTest: TfrmLabTest;
  W, H: integer;
begin
  frmLabTest := TfrmLabTest.Create(Application);
  try
    with frmLabTest do
    begin
      Font.Size := FontSize;
      W := ClientWidth;
      H := ClientHeight;
      ResizeToFont(FontSize, W, H);
      ClientWidth := W; pnlLabTest.Width := W;
      ClientHeight := H; pnlLabTest.Height := H;
      lblSpecInfo.Height := cboList.Height;
      lblSpecInfo.Width := pnlLabTest.Width - cboList.Left - cboList.Width -10;
      ShowModal;
    end;
  finally
    frmLabTest.Release;
  end;
end;

procedure TfrmLabTest.FormCreate(Sender: TObject);
var
  blood, urine, serum, plasma: string;
begin
  cboList.LockDrawing;
  try
    cboList.InitLongList('');
  finally
    cboList.UnlockDrawing;
  end;
  cboSpecimen.LockDrawing;
  try
    cboSpecimen.InitLongList('');
    SpecimenDefaults(blood, urine, serum, plasma);
    cboSpecimen.Items.Add('0^Any');
    cboSpecimen.Items.Add(serum + '^Serum');
    cboSpecimen.Items.Add(blood + '^Blood');
    cboSpecimen.Items.Add(plasma + '^Plasma');
    cboSpecimen.Items.Add(urine + '^Urine');
    cboSpecimen.Items.Add(LLS_LINE);
    cboSpecimen.Items.Add(LLS_SPACE);
    cboSpecimen.ItemIndex := 0;
  finally
    cboSpecimen.UnlockDrawing;
  end;
end;

procedure TfrmLabTest.cboListNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
var
  sl: TStrings;
begin
//  cboList.ForDataUse(AtomicTests(StartFrom, Direction));
  sl := TSTringList.Create;
  try
    setAtomicTests(sl,StartFrom, Direction);
    cboList.ForDataUse(sl);
  finally
    sl.Free;
  end;
end;

procedure TfrmLabTest.cboSpecimenNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
// begin
// cboSpecimen.ForDataUse(Specimens(StartFrom, Direction));
var
  sl: TStrings;
begin
  sl := TSTringList.Create;
  try
    setSpecimens(sl, StartFrom, Direction);
    cboSpecimen.ForDataUse(sl);

  finally
    sl.Free;
  end;
end;

procedure TfrmLabTest.cmdOKClick(Sender: TObject);
begin
  if cboList.ItemIndex = -1 then
    ShowMsg('No test was selected.')
  else
  begin
    frmLabs.lblSingleTest.Caption := cboList.Items[cboList.ItemIndex];
    frmLabs.lblSpecimen.Caption := cboSpecimen.Items[cboSpecimen.ItemIndex];
    Close;
  end;
end;

procedure TfrmLabTest.cboListEnter(Sender: TObject);
begin
  cmdOK.Default := true;
end;

procedure TfrmLabTest.cboListExit(Sender: TObject);
begin
  cmdOK.Default := false;
end;

end.
