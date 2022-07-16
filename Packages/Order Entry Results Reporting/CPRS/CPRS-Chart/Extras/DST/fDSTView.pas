unit fDSTView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, fBase508Form, VA508AccessibilityManager,
  uSizing, Vcl.OleCtrls, SHDocVw, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmDSTView = class(TfrmBase508Form)
    Panel1: TPanel;
    btnOK: TButton;
    wbInternetExplorer: TWebBrowser;
    btnCancel: TButton;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure wbInternetExplorerNavigateError(ASender: TObject;
      const pDisp: IDispatch; const URL, Frame, StatusCode: OleVariant;
      var Cancel: WordBool);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;



function dstReviewResult(aURL: String): Integer;

implementation

{$R *.dfm}

uses uGN_RPCLog;

const
  URL_OK = 200;

var
  frmDSTView: TfrmDSTView;

function URLOK(aCode: Integer): Boolean;
begin
  Result := aCode = URL_OK;
end;

function dstReviewResult(aURL: String): Integer;
var
  frm: TfrmDSTView;
begin
  Application.CreateForm(TfrmDSTView, frm);
  try
    frm.wbInternetExplorer.Navigate(aURL);
    Result := frm.ShowModal;
  finally
    frm.Free;
  end;
end;

/// ////////////////////////////////////////////////////////////////////////////

procedure TfrmDSTView.Button1Click(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TfrmDSTView.FormCreate(Sender: TObject);
begin
  inherited;
  Font.Size := Application.MainForm.Font.Size;
  adjustbtn(btnOK, True);
  adjustbtn(btnCancel, True);
  // maximizing window size
  with Screen.WorkAreaRect do
    self.SetBounds(Left, Top, Right - Left, Bottom - Top);
end;

procedure TfrmDSTView.wbInternetExplorerNavigateError(ASender: TObject;
  const pDisp: IDispatch; const URL, Frame, StatusCode: OleVariant;
  var Cancel: WordBool);
var
  b: Boolean;
  s: String;
  fPageErrorCode: Integer;
begin
  inherited;
  fPageErrorCode := StatusCode;
  b := URLOK(fPageErrorCode);
  if not b then
  begin
    s := 'URL: ' + URL + #13#10 + 'ERROR: "' + IntToStr(StatusCode) + '"' +
      #13#10 // + MsgByCode(fPageErrorCode)
      ;
    AddLogLine(s, 'DST NAVIGATE ERROR ' + IntToStr(StatusCode));
  end;
end;

end.
