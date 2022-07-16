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
    btnCloseCTB: TButton;
    procedure FormCreate(Sender: TObject);
    procedure wbInternetExplorerNavigateError(ASender: TObject;
      const pDisp: IDispatch; const URL, Frame, StatusCode: OleVariant;
      var Cancel: WordBool);
    procedure btnCloseCTBClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    fViewMode: String;
    procedure setViewMode(aMode:String);
  public
    { Public declarations }
    property ViewMode: String read fViewMode write setViewMode;
  end;


function dstReviewResult(aURL: String;aViewMode:String = ''): Integer;

implementation

{$R *.dfm}

uses uGN_RPCLog, oDST;

const
  URL_OK = 200;

//var
//  frmDSTView: TfrmDSTView;

function URLOK(aCode: Integer): Boolean;
begin
  Result := aCode = URL_OK;
end;

function dstReviewResult(aURL: String;aViewMode:String = ''): Integer;
var
  frm: TfrmDSTView;
begin
  Application.CreateForm(TfrmDSTView, frm);
  try
    frm.ViewMode := aViewMode;
    frm.wbInternetExplorer.Navigate(aURL);
    Result := frm.ShowModal;
  finally
    frm.Free;
  end;
end;

/// ////////////////////////////////////////////////////////////////////////////
procedure TfrmDSTView.setViewMode(aMode: string);
begin
  fViewMode := aMode;

exit;

// the rest of the procedure sets caption depending on the ViewMode

  Caption := '';

  if fViewMode = DST_DST  then
    caption := 'Decision Support Tool';
  if fViewMode = DST_CTB  then
    caption := 'Consult Toolbox';
  if fViewMode = DST_OTH  then
    caption := 'Toolbox';

end;

procedure TfrmDSTView.btnCloseCTBClick(Sender: TObject);
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
  adjustbtn(btnCloseCTB, True);
  // maximizing window size
  with Screen.WorkAreaRect do
    self.SetBounds(Left, Top, Right - Left, Bottom - Top);
end;

procedure TfrmDSTView.FormKeyPress(Sender: TObject; var Key: Char);
begin
  //Don't forget to set the Keypreview property
  //of the form to true!
  if (Key=#13) then begin
    Key := #0;
    Keybd_Event(VK_LCONTROL, 0, 0, 0); //Ctrl key down
    Keybd_Event(Ord('M'), MapVirtualKey(Ord('M'), 0),0, 0); // 'M' key down
    Keybd_Event(Ord('M'), MapVirtualKey(Ord('M'), 0), KEYEVENTF_KEYUP, 0); // 'M' Key up
    Keybd_Event(VK_LCONTROL, 0, KEYEVENTF_KEYUP,  0); // Ctrl key up
    Keybd_Event(VK_CANCEL, 0, 0, 0);
  end;
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
