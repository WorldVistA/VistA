unit fGraphOthers;

interface

uses
  ORExtensions,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ORCtrls, ExtCtrls, ORFn, uGraphs, rCore, uCore,
  fBase508Form, VA508AccessibilityManager;

type
  TfrmGraphOthers = class(TfrmBase508Form)
    pnlMain: TORAutoPanel;
    lblOthers: TLabel;
    cboOthers: TORComboBox;
    lstViews: TORListBox;
    memReport: ORExtensions.TRichEdit;
    pnlBottom: TPanel;
    lblViews: TLabel;
    lblInfo: TLabel;
    lblDefinitions: TLabel;
    btnClose: TButton;
    btnCopy: TButton;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    procedure cboOthersNeedData(Sender: TObject; const StartFrom: string;
      Direction, InsertAt: Integer);
    procedure FormShow(Sender: TObject);
    procedure cboOthersClick(Sender: TObject);
    procedure lstViewsClick(Sender: TObject);
  private
    procedure AddTests(tests: TStrings);
  public
    { Public declarations }
  end;

var
  frmGraphOthers: TfrmGraphOthers;

  procedure DialogGraphOthers(size: integer);

implementation

{$R *.dfm}

uses
  rGraphs, fGraphData, rLabs;

procedure DialogGraphOthers(size: integer);
var
  aList: TStrings;
  frmGraphOthers: TfrmGraphOthers;
begin
  aList := TStringList.Create;
  frmGraphOthers := TfrmGraphOthers.Create(Application);
  try
    with frmGraphOthers do
    begin
      ResizeAnchoredFormToFont(frmGraphOthers);
      ShowModal;
    end;
  finally
    frmGraphOthers.Release;
    aList.Free;
  end;
end;

procedure TfrmGraphOthers.cboOthersClick(Sender: TObject);
begin
//  FastAssign(TestGroups(cboOthers.ItemIEN), lstViews.Items);
  setTestGroups(lstViews.Items,cboOthers.ItemIEN);
end;

procedure TfrmGraphOthers.cboOthersNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
// begin
// cboOthers.ForDataUse(SubSetOfPersons(StartFrom, Direction));
// cboOthers.ForDataUse(Users(StartFrom, Direction));
var
  sl: TStrings;
begin
  sl := TStringList.Create;
  try
    setUsers(sl, StartFrom, Direction);
    cboOthers.ForDataUse(sl);
  finally
    sl.Free;
  end;
end;

procedure TfrmGraphOthers.FormShow(Sender: TObject);
begin
  cboOthers.InitLongList(User.Name);
  cboOthers.SelectByIEN(User.DUZ);
  cboOthersClick(self);
end;

procedure TfrmGraphOthers.lstViewsClick(Sender: TObject);
var
  sl: TStrings;
begin
  // AddTests(ATestGroup(lstViews.ItemIEN, cboOthers.ItemIEN));
  sl := TStringList.Create;
  try
    setATestGroup(sl, lstViews.ItemIEN, cboOthers.ItemIEN);
    AddTests(sl);
  finally
    sl.Free;
  end;
end;

procedure TfrmGraphOthers.AddTests(tests: TStrings);
var
  i, j: integer;
  ok: boolean;
begin
  for i := 0 to tests.Count - 1 do
  begin
    ok := true;
    for j := 0 to memReport.Lines.Count - 1 do
      if memReport.Lines[j] = tests[i] then
      begin
        ok := false;
      end;
    if ok then
    begin
      memReport.Lines.Add(tests[i]);
    end;
  end;
end;

end.
