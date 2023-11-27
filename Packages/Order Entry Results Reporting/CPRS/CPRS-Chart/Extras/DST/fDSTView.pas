unit fDSTView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, fBase508Form, VA508AccessibilityManager,
  uSizing, Vcl.OleCtrls, SHDocVw, Vcl.StdCtrls, Vcl.ExtCtrls, WebView2,
  Winapi.ActiveX, Vcl.Edge;

type
  TBrowserComponent = (bcEdge, bcWeb);

  TfrmDSTView = class(TfrmBase508Form)
    Panel1: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    btnCloseCTB: TButton;
    wbEdgeBrowser: TEdgeBrowser;
    webBrowser: TWebBrowser;
    procedure FormCreate(Sender: TObject);
    procedure wbInternetExplorerNavigateError(ASender: TObject;
      const pDisp: IDispatch; const URL, Frame, StatusCode: OleVariant;
      var Cancel: WordBool);
    procedure btnCloseCTBClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure webBrowserDocumentComplete(ASender: TObject;
      const pDisp: IDispatch; const URL: OleVariant);
    procedure webBrowserEnter(Sender: TObject);
    procedure webBrowserNavigateComplete2(ASender: TObject;
      const pDisp: IDispatch; const URL: OleVariant);
    procedure webBrowserShowScriptError(ASender: TObject; const AErrorLine,
      AErrorCharacter, AErrorMessage, AErrorCode, AErrorUrl: OleVariant;
      var AOut: OleVariant; var AHandled: Boolean);
    procedure wbEdgeBrowserNavigationCompleted(Sender: TCustomEdgeBrowser;
      IsSuccess: Boolean; WebErrorStatus: TOleEnum);
  private
    { Private declarations }
    fSelectedBrowser: TBrowserComponent;
    fBrowserHWnd: HWND;
    fBEngine: TWebBrowser.TSelectedEngine;
    fURL, fViewMode: String;
    procedure setViewMode(aMode: String);
    procedure setBEngine(aValue: TWebBrowser.TSelectedEngine);
    procedure setSelectedBrowser(aValue: TBrowserComponent);

    procedure setURL(aValue: string);
  public
    { Public declarations }
//    MainOne: TWinControl;
    property ViewMode: String read fViewMode write setViewMode;
    property BEngine: TWebBrowser.TSelectedEngine read fBEngine write setBEngine;
    property SelectedBrowser: TBrowserComponent read fSelectedBrowser write setSelectedBrowser;
    property URL: String read fURL write setURL;

    procedure FocusDoc;
  end;

var
  CTB_Mode: String;

function dstReviewResult(aURL: String; aViewMode: String = ''): Integer;

implementation

{$R *.dfm}

uses uGN_RPCLog, oDST, ORExtensions, uPaPI, MSHTML;

const
  URL_OK = 200;

const
  CTB_Modes_Str = 'EDGE|WEBIE|WEBEDGE|WEBEDGEIFAVAILABLE|';
                // 1    6     12      20

function dstReviewResult(aURL: String; aViewMode: String = ''): Integer;
begin
  var frm := TfrmDSTView.Create(Application);
  try
    frm.ViewMode := aViewMode;
    frm.URL := aURL;
    Result := frm.ShowModal;
  finally
    frm.Free;
  end;
end;

/// ////////////////////////////////////////////////////////////////////////////
procedure TfrmDSTView.FocusDoc;
var
  Doc: IHTMLDocument4;
begin
  if Assigned(WebBrowser.Document) then begin
    try
      Doc := WebBrowser.Document as IHTMLDocument4;
      Doc.focus;
    except
//      on E:EOLEError do begin
        // ... do something about OLE problem
//      end;
      on E:EIntfCastError do begin
        // ... do something about cast error
      end;
    end;
  end;
end;

procedure TfrmDSTView.setBEngine(aValue: TWebBrowser.TSelectedEngine);
begin
  fBEngine := aValue;
  WebBrowser.SelectedEngine := aValue;
end;

procedure TfrmDSTView.setViewMode(aMode: string);
begin
  fViewMode := aMode;
{$IFDEF DEBUG}
  Caption := '';
  if fViewMode = DST_DST then
    Caption := 'Decision Support Tool';
  if fViewMode = DST_CTB then
    Caption := 'Consult Toolbox';
  if fViewMode = DST_OTH then
    Caption := 'Toolbox';
{$ENDIF}
end;

function SetEnvVarValue(const VarName, VarValue: string): Integer;
begin
  // Simply call API function
  if SetEnvironmentVariable(PChar(VarName), PChar(VarValue)) then
    Result := 0
  else
    Result := GetLastError;
end;

procedure TfrmDSTView.setSelectedBrowser(aValue: TBrowserComponent);
var
  sValue: String;
begin
  fSelectedBrowser := aValue;

  if SelectedBrowser = bcWeb then
    begin
      webBrowser.Visible := True;
      wbEdgeBrowser.Visible := False;
      wbEdgeBrowser.SendToBack;
      webBrowser.Align := alClient;
      SetUserDataFolder(webBrowser);
    end
  else
    begin
      webBrowser.Visible := False;
      webBrowser.SendToBack;
      wbEdgeBrowser.Align := alClient;
//      sValue := getUserDataFolder;
//      SetEnvVarValue('WEBVIEW2_USER_DATA_FOLDER',sValue);

      wbEdgeBrowser.UserDataFolder := sValue;
      wbEdgeBrowser.Visible := True;
//      SetUserDataFolder(nil);
    end;
end;

procedure TfrmDSTView.btnCloseCTBClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TfrmDSTView.FormCreate(Sender: TObject);
begin
  inherited;

  var i := pos(Uppercase(CTB_Mode) + '|', CTB_Modes_Str);

  if i = 1 then
    begin
      SelectedBrowser := bcEdge;
    end
  else
    begin
      case i of
        6:  BEngine := IEOnly;
        12: BEngine := EdgeOnly;
        20: BEngine := EdgeIfAvailable;
      else
        BEngine := EdgeIfAvailable;
      end;
      SelectedBrowser := bcWeb;
    end;

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
  // Don't forget to set the Keypreview property
  // of the form to true!
  if (Key = #13) then
  begin
    Key := #0;
    Keybd_Event(VK_LCONTROL, 0, 0, 0); // Ctrl key down
    Keybd_Event(Ord('M'), MapVirtualKey(Ord('M'), 0), 0, 0); // 'M' key down
    Keybd_Event(Ord('M'), MapVirtualKey(Ord('M'), 0), KEYEVENTF_KEYUP, 0);
    // 'M' Key up
    Keybd_Event(VK_LCONTROL, 0, KEYEVENTF_KEYUP, 0); // Ctrl key up
    Keybd_Event(VK_CANCEL, 0, 0, 0);
  end;
end;

procedure TfrmDSTView.wbEdgeBrowserNavigationCompleted(
  Sender: TCustomEdgeBrowser; IsSuccess: Boolean; WebErrorStatus: TOleEnum);
begin
  inherited;
  wbEdgeBrowser.setFocus;
end;

procedure TfrmDSTView.wbInternetExplorerNavigateError(ASender: TObject;
  const pDisp: IDispatch; const URL, Frame, StatusCode: OleVariant;
  var Cancel: WordBool);
var
  s: String;
begin
//  inherited;
  if statusCode <> URL_OK then
  begin
    s := 'URL: ' + URL + #13#10 + 'ERROR: "' + IntToStr(StatusCode) + '"'
      + #13#10 // + MsgByCode(fPageErrorCode)
      ;
    AddLogLine(s, 'DST NAVIGATE ERROR ' + IntToStr(StatusCode));
  end;
end;

procedure TfrmDSTView.webBrowserDocumentComplete(ASender: TObject;
  const pDisp: IDispatch; const URL: OleVariant);
begin
  var Win: IOleWindow;
  if Supports(pDisp, IOleWindow, Win) then // IEOnly
    Win.GetWindow(FBrowserHWnd);
  FocusDoc;
end;

procedure TfrmDSTView.webBrowserEnter(Sender: TObject);
begin
  FocusDoc;
end;

procedure TfrmDSTView.webBrowserNavigateComplete2(ASender: TObject;
  const pDisp: IDispatch; const URL: OleVariant);
begin
  FocusDoc;
end;

procedure TfrmDSTView.webBrowserShowScriptError(ASender: TObject;
  const AErrorLine, AErrorCharacter, AErrorMessage, AErrorCode,
  AErrorUrl: OleVariant; var AOut: OleVariant; var AHandled: Boolean);
begin
  AHandled := True;
end;

procedure TfrmDSTView.setURL(aValue: string);
begin
  fURL := aValue;

  if SelectedBrowser = bcEdge then
  begin
    wbEdgeBrowser.UserDataFolder := getUserDataFolder;
    wbEdgeBrowser.Navigate(fURL);
//    Color := clMoneyGreen;
  end
  else
  begin
    webBrowser.Navigate(fURL);
    Color := clSkyBlue;
  end;
end;

initialization

//CTB_Mode := GetOptionValue('CTBMODE');
//if CTB_Mode = '' then
  CTB_Mode := 'EDGE';
  SetEnvVarValue('WEBVIEW2_USER_DATA_FOLDER', getUserDataFolder);

end.
