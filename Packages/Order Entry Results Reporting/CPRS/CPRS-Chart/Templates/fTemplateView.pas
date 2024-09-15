unit fTemplateView;

interface

uses
  ORExtensions,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, Menus, ORFn, fBase508Form,
  VA508AccessibilityManager;

type
  TfrmTemplateView = class(TfrmBase508Form)
    pnlBottom: TPanel;
    reMain: ORExtensions.TRichEdit;
    btnClose: TButton;
    cbStayOnTop: TCheckBox;
    popView: TPopupMenu;
    Copy1: TMenuItem;
    N1: TMenuItem;
    SelectAll1: TMenuItem;
    btnPrint: TButton;
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cbStayOnTopClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure popViewPopup(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure SelectAll1Click(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure AlignButtons();
    procedure FormCreate(Sender: TObject);
  private
  end;

procedure ShowTemplateData(Form: TForm; const Title, Text: string);

var
  frmTemplateView: TfrmTemplateView = nil;

implementation

uses fTemplateDialog, fRptBox, rMisc, UResponsiveGUI;

{$R *.DFM}

var
  LastStayOnTop: boolean = FALSE;

procedure ShowTemplateData(Form: TForm; const Title, Text: string);
var
  Cnt: integer;

begin
  if(not assigned(frmTemplateView)) then
    frmTemplateView := TfrmTemplateView.Create(Application);
  //Quick fix to work around glich in resize algorithm
  frmTemplateView.AlignButtons();
  frmTemplateView.reMain.Lines.Clear;
  frmTemplateView.Caption := 'Template: ' + Title;
  frmTemplateView.reMain.Lines.Text := Text;
  Cnt := frmTemplateView.reMain.Lines.Count;
  CheckBoilerplate4Fields(frmTemplateView.reMain.Lines, frmTemplateView.Caption, TRUE);
  if (Cnt > 0) and (frmTemplateView.reMain.Lines.Count = 0) then
    frmTemplateView.Close
  else
  begin
    frmTemplateView.cbStayOnTop.Checked := LastStayOnTop;
    frmTemplateView.ActiveControl := frmTemplateView.btnClose;
    frmTemplateView.Show;
    TResponsiveGUI.ProcessMessages;
    SendMessage(frmTemplateView.reMain.Handle, EM_LINESCROLL, 0, -1 * frmTemplateView.reMain.Lines.Count);
  end;
end;

procedure TfrmTemplateView.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmTemplateView.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveUserBounds(frmTemplateView);
  Action := caFree;
end;

procedure TfrmTemplateView.FormCreate(Sender: TObject);
begin
  inherited;
  ResizeAnchoredFormToFont(Self);
  SetFormPosition(Self);
end;

procedure TfrmTemplateView.cbStayOnTopClick(Sender: TObject);
begin
  if(cbStayOnTop.Checked) then
    FormStyle := fsStayOnTop
  else
    FormStyle := fsNormal;
  if(LastStayOnTop <> cbStayOnTop.Checked) then
    LastStayOnTop := cbStayOnTop.Checked;
end;

procedure TfrmTemplateView.FormDestroy(Sender: TObject);
begin
  frmTemplateView := nil;
end;

procedure TfrmTemplateView.popViewPopup(Sender: TObject);
begin
  Copy1.Enabled := (reMain.SelLength > 0);
  SelectAll1.Enabled := (reMain.Lines.Count > 0);
end;

procedure TfrmTemplateView.Copy1Click(Sender: TObject);
begin
  reMain.CopyToClipboard;
end;

procedure TfrmTemplateView.SelectAll1Click(Sender: TObject);
begin
  reMain.SelectAll;
end;

procedure TfrmTemplateView.btnPrintClick(Sender: TObject);
begin
  PrintStrings(Self, reMain.Lines, Caption, 'End of template');
end;

procedure TfrmTemplateView.AlignButtons;
Const
  BtnSpace = 8;
begin
  btnClose.Left := frmTemplateView.Width - btnClose.Width - BtnSpace;
  btnPrint.Left := btnClose.Left - BtnSpace - btnPrint.Width;
end;

end.
