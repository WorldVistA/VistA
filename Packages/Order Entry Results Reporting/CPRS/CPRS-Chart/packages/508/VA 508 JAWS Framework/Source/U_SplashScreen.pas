unit U_SplashScreen;
{$WARN SYMBOL_PLATFORM OFF}
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Winapi.ShellAPI, VAUtils,
  JAWSImplementation, VA508AccessibilityConst, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ImgList, Vcl.Imaging.pngimage, Vcl.AppEvnts,
  System.ImageList;

type

  TStaticText = class(Vcl.StdCtrls.TStaticText)
  private
    FFocused: Boolean;
  protected
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
  end;

  TButton = class(Vcl.StdCtrls.TButton)
  private
    f508Label: TStaticText;
    procedure CMEnabledChanged(var Msg: TMessage); message CM_ENABLEDCHANGED;
  public
    destructor Destroy; override;
  end;

  tStatus = (DS_RUN, DS_ERROR, DS_CHECK);
  TExecutEvent = function(ComponentCallBackProc
    : TComponentDataRequestProc): BOOL;

  tSplahThread = Class(TThread)
  private
    fOnExecute: TExecutEvent;
    fSplashDialog: TComponent;
    fComponentCallBackProc: TComponentDataRequestProc;
  protected
    procedure Execute; override;
  public
    constructor Create(aSplashCTRL: TComponent;
      ComponentCallBackProc: TComponentDataRequestProc);
    destructor Destroy; override;
    property OnExecute: TExecutEvent read fOnExecute write fOnExecute;
  End;

  TErrType = (Err_Sys, Err_Other);

  tErrorRec = Record
    Title: String;
    ErrorMessage: String;
    ErrType: TErrType;
  End;

  TSplashScrn = class(TForm)
    pnlButtons: TPanel;
    btnContinue: TButton;
    ImageList2: TImageList;
    btnErrors: TButton;
    btnLog: TButton;
    Panel2: TPanel;
    pnlRight: TPanel;
    ProgressBar1: TProgressBar;
    pnlLeft: TPanel;
    imgFoot: TImage;
    imgError: TImage;
    imgInfo: TImage;
    pnlLog: TPanel;
    StaticText1: TStaticText;
    pnlForce: TPanel;
    lblForce: TStaticText;
    lblFoot: TStaticText;
    lblTitle: TStaticText;
    lblMessage: TStaticText;
    ApplicationEvents1: TApplicationEvents;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
  private
    { Private declarations }
    fInit: Boolean;
    fOrigCaption: String;
    fRunTime: TDateTime;
    fDoneRunning: Boolean;
  public
    { Public declarations }
  end;

  tSplashTaskDialog = class(TComponent)
  private
    // fTaskDialog: TTaskDialog;
    fSplashScreen: TSplashScrn;
    fSplashThread: tSplahThread;
    fTaskText: String;
    fTaskTitle: String;
    fTaskError: String;
    fProgMax: Integer;
    fProgMoveBy: Integer;
    fThreadResult: BOOL;
    fErrorsExist: Boolean;
    fMainImageID: Integer;
    fLogPath: String;
    fSysErrorShowing: Boolean;
    fErrorRecs: array of tErrorRec;
    fErrNum: Integer;
    fStopViewErr: Boolean;
    rtnCurson: Integer;
    fDoThread: Boolean;
    fShowSplash: Boolean;
    fExecuteEvent: TExecutEvent;
    fComponentCallBackProc: TComponentDataRequestProc;
    procedure SetTaskText(aValue: string);
    procedure SetTaskTitle(aValue: string);
    procedure SetTaskError(aValue: string);
    Procedure SetTaskMaxProg(aValue: Integer);
    Procedure SetMainImageId(aValue: Integer);
    procedure SyncTaskText;
    procedure SyncTaskTitle;
    procedure SyncTaskEError;
    procedure SyncIncProg;
    procedure SyncMaxProg;
    procedure ShowErrorDialog;
    procedure ErrorDialogClick(aSender: TObject; AModalResult: TModalResult;
      var CanClose: Boolean);
    procedure ErrorDialogClose(Sender: TObject);
    procedure SplashTaskDialogClose(Sender: TObject);
    procedure BundleErrorMessages;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    property ImageID: Integer read fMainImageID write SetMainImageId;
  public
    constructor Create(AOwner: TComponent); overload; override;
    constructor Create(ExecuteEvent: TExecutEvent;
      ComponentCallBackProc: TComponentDataRequestProc;
      LogLink: Boolean = false; ForceUPD: Integer = -1;
      DoThread: Boolean = true; ShowSplash: Boolean = true); reintroduce; overload;
    destructor Destroy; override;
    Procedure IncProg(ByCnt: Integer = 1);
    procedure ShowSystemError(aErrorText: string);
    procedure Show;
    property TaskText: string read fTaskText write SetTaskText;
    property TaskTitle: string read fTaskTitle write SetTaskTitle;
    property TaskError: string write SetTaskError;
    property TaskMaxProg: Integer read fProgMax write SetTaskMaxProg;
    property ReturnValue: BOOL read fThreadResult;
    property ErrorsExist: Boolean read fErrorsExist;
    property LogPath: string read fLogPath write fLogPath;
  end;

Const
  CAP_FOOT = 'Errors Found';

  LINE_MAX = 15;

implementation

{$R *.dfm}
{$REGION 'tSplashTaskDialog'}

procedure tSplashTaskDialog.ShowErrorDialog;
begin
  // Create the error dialog
  with TTaskDialog.Create(self) do
  begin
    Caption := 'Error Log Viewer';
    Title := fErrorRecs[fErrNum].Title;
    Text := fErrorRecs[fErrNum].ErrorMessage;
    MainIcon := tdiError;
    flags := [];
    CommonButtons := [];
    with TTaskDialogButtonItem(Buttons.Add) do
    begin
      Caption := 'Stop Viewing';
      ModalResult := mrAbort;
      Enabled := true;
      CommandLinkHint :=
        'This will close the rest of the errors that were logged'
    end;
    with TTaskDialogButtonItem(Buttons.Add) do
    begin
      Caption := 'Previous';
      ModalResult := mrYes;
      Enabled := fErrNum > Low(fErrorRecs);
      CommandLinkHint := 'View the previous error in the log';
      if fErrNum = high(fErrorRecs) then
        default := true;
    end;

    with TTaskDialogButtonItem(Buttons.Add) do
    begin
      Caption := 'Next';
      ModalResult := mrNo;
      Enabled := fErrNum < high(fErrorRecs);
      default := Enabled;

      CommandLinkHint := 'View the next error in the log';
    end;
    FooterIcon := tdiInformation;
    FooterText := 'Error ' + IntToStr(fErrNum + 1) + ' of ' +
      IntToStr(High(fErrorRecs) + 1);

    OnButtonClicked := ErrorDialogClick;
    OnDialogDestroyed := ErrorDialogClose;
    // SpeakText(PChar(Title + ', ' + Text));

    Execute;
  end;

end;

procedure tSplashTaskDialog.ErrorDialogClick(aSender: TObject;
  AModalResult: TModalResult; var CanClose: Boolean);
begin
  CanClose := true;
  case AModalResult of
    mrAbort:
      fStopViewErr := true;
    mrYes:
      Dec(fErrNum);
    mrNo:
      Inc(fErrNum);
  end;
end;

procedure tSplashTaskDialog.ErrorDialogClose(Sender: TObject);
begin
  if not fStopViewErr then
  begin
    if (fErrNum >= low(fErrorRecs)) and (fErrNum <= high(fErrorRecs)) then
    begin
      ShowErrorDialog;
    end;
  end
  else
    fStopViewErr := false;
end;

procedure tSplashTaskDialog.SplashTaskDialogClose(Sender: TObject);
begin
  inherited;
  // if fTaskDialog.ModalResult = mrAbort then
  // Application.Terminate;
end;

procedure tSplashTaskDialog.SetTaskText(aValue: string);
begin
  if Assigned(fSplashScreen) then
  begin
    fTaskText := aValue;
    if Assigned(fSplashThread) then
      fSplashThread.Synchronize(SyncTaskText)
    else
      SyncTaskText;
  end;
end;

procedure tSplashTaskDialog.SyncTaskText;
begin
  if Assigned(fSplashScreen) then
  begin
    fSplashScreen.lblMessage.Caption := fTaskText;
    SpeakText(PWideChar(fTaskText));
  end;
end;

procedure tSplashTaskDialog.SetTaskTitle(aValue: string);
begin
  if Assigned(fSplashScreen) then
  begin
    fTaskTitle := aValue;
    if Assigned(fSplashThread) then
      fSplashThread.Synchronize(SyncTaskTitle)
    else
      SyncTaskTitle;
  end;
end;

procedure tSplashTaskDialog.SyncTaskTitle;
begin
  if Assigned(fSplashScreen) then
  begin
    fSplashScreen.lblTitle.Caption := fTaskTitle;
    SpeakText(PWideChar(fTaskTitle));
  end;
end;

procedure tSplashTaskDialog.SetTaskError(aValue: string);
begin
    fTaskError := aValue;
    if Assigned(fSplashThread) then
      fSplashThread.Synchronize(SyncTaskEError)
    else
      SyncTaskEError;
end;

procedure tSplashTaskDialog.SyncTaskEError;
begin
  if assigned(fSplashScreen) then
  begin
    if not fSplashScreen.imgFoot.Visible then
    begin
      fSplashScreen.imgFoot.Visible := true;
      fSplashScreen.lblFoot.Visible := true;
      SpeakText(PWideChar(fSplashScreen.lblFoot.Caption));
    end;
  end;
  SetLength(fErrorRecs, Length(fErrorRecs) + 1);
  fErrorRecs[High(fErrorRecs)].Title := fTaskTitle;
  fErrorRecs[High(fErrorRecs)].ErrorMessage := fTaskError;
  fErrorRecs[High(fErrorRecs)].ErrType := Err_Other;
  fErrorsExist := true;
end;

Procedure tSplashTaskDialog.SetTaskMaxProg(aValue: Integer);
begin
  fProgMax := aValue;
  if Assigned(fSplashThread) then
    fSplashThread.Synchronize(SyncMaxProg)
  else
    SyncMaxProg;
end;

procedure tSplashTaskDialog.SyncMaxProg;
begin
  if Assigned(fSplashScreen) then
  begin
    fSplashScreen.ProgressBar1.Max := fProgMax;
  end;
end;

Procedure tSplashTaskDialog.IncProg(ByCnt: Integer = 1);
begin
  fProgMoveBy := ByCnt;
  if Assigned(fSplashThread) then
    fSplashThread.Synchronize(SyncIncProg)
  else
    SyncIncProg;
end;

procedure tSplashTaskDialog.SyncIncProg;
begin
  if Assigned(fSplashScreen) then
  begin
    fSplashScreen.ProgressBar1.Position := fSplashScreen.ProgressBar1.Position +
      fProgMoveBy;
  end;
end;

procedure tSplashTaskDialog.ShowSystemError(aErrorText: string);
begin
  fSysErrorShowing := true;

  SetTaskText(aErrorText);
  // sync with generic
  fSplashThread.Synchronize(
    procedure
    begin
      ImageID := 0;
      if fShowSplash then
      begin
        fSplashScreen.btnContinue.Enabled := true;
        fSplashScreen.btnContinue.SetFocus;
      end;
      Screen.Cursor := rtnCurson;
    end);

  SetLength(fErrorRecs, Length(fErrorRecs) + 1);
  fErrorRecs[High(fErrorRecs)].Title := fTaskTitle;
  fErrorRecs[High(fErrorRecs)].ErrorMessage := aErrorText;
  fErrorRecs[High(fErrorRecs)].ErrType := Err_Sys;

  fSplashThread.Suspended := true;

end;

Procedure tSplashTaskDialog.SetMainImageId(aValue: Integer);
begin
  if Assigned(fSplashScreen) then
  begin
    fMainImageID := aValue;
    case aValue of
      0:
        begin
          fSplashScreen.imgError.Visible := true;
          fSplashScreen.imgInfo.Visible := false;
        end;
      1:
        begin
          fSplashScreen.imgError.Visible := false;
          fSplashScreen.imgInfo.Visible := true;
        end;
    end;
  end;
end;


constructor tSplashTaskDialog.Create(AOwner: TComponent);
begin
  raise Exception.Create('Invalid create');
end;

constructor tSplashTaskDialog.Create(ExecuteEvent: TExecutEvent;
ComponentCallBackProc: TComponentDataRequestProc; LogLink: Boolean = false;
ForceUPD: Integer = -1; DoThread: Boolean = true; ShowSplash: Boolean = true);
  function GetDLLName: string;
  begin
    Result := system.SysUtils.GetModuleName(HInstance);
  end;

  Procedure StartProcessing(aDoThread: Boolean);
  begin
    if not aDoThread then
    begin
      fComponentCallBackProc := ComponentCallBackProc;
      fExecuteEvent := ExecuteEvent;
    end
    else
    begin
      fSplashThread := tSplahThread.Create(self, ComponentCallBackProc);
      fSplashThread.OnExecute := ExecuteEvent;
    end;
  end;

var
  DLLName, FileVersion: string;
begin
  inherited Create(nil);
  rtnCurson := Screen.Cursor;
  DLLName := GetDLLName;
  FileVersion := FileVersionValue(DLLName, FILE_VER_FILEVERSION);
  fErrorsExist := false;
  // **************************
  fDoThread := DoThread;
  fShowSplash := ShowSplash;
  // **************************

  if ShowSplash then
  begin
    fSplashScreen := TSplashScrn.Create(self);
    try
      fSplashScreen.Caption := 'VA 508 Jaws Framework - Version: ' +
        FileVersion;
      fSplashScreen.fOrigCaption := fSplashScreen.Caption;
      SetTaskTitle('Jaws Framework');
      SetTaskText('Starting the jaws framework. Please wait ' +
        ExtractFileName(Application.ExeName) +
        ' will open on it''s own if no errors were found.');
      ImageID := 1;

      fSplashScreen.btnLog.Enabled := LogLink;
      fSplashScreen.pnlLog.Visible := LogLink;
      if ForceUPD <> -1 then
      begin
        fSplashScreen.pnlForce.Visible := true;
        if ForceUPD = 0 then
          fSplashScreen.lblForce.Caption := 'Force update all versions'
        else
          fSplashScreen.lblForce.Caption := 'Force update version ' +
            IntToStr(ForceUPD);
      end;
      fSplashScreen.OnDestroy := SplashTaskDialogClose;
      fSplashScreen.OnCloseQuery := FormCloseQuery;

      StartProcessing(fDoThread);

      SetLength(fErrorRecs, 0);

      fErrNum := 0;
    except
      fSplashScreen.Free;
    end;
  end
  else
    StartProcessing(fDoThread);
end;

Procedure tSplashTaskDialog.Show;
begin
  if fShowSplash then
  begin
    if not fDoThread then
    begin
      fSplashScreen.Show;
      Application.ProcessMessages;
      sleep(2000);
      fThreadResult := fExecuteEvent(fComponentCallBackProc);

      if not ErrorsExist then
      begin
        fSplashScreen.btnContinue.Click;
        // SpeakText(PChar('Please wait, opening ' + ExtractFileName(Application.ExeName)));
      end
      else
      begin
        SetTaskTitle('General');
        SetTaskText('Bundling errors');
        BundleErrorMessages;
        ImageID := 0;
        SetTaskTitle('Error Check');
        SetTaskText
          ('Potential errors where found while trying to process the Jaws scripts. '
          + 'Press continue to ignore these errors and open ' +
          ExtractFileName(Application.ExeName) +
          '. Please note that the framework may not work correctly. ' + CRLF +
          'If you continue to experience this issue please contact your local system administrator for assistance.');

        fSplashScreen.btnErrors.Enabled := true;
        fSplashScreen.btnLog.Enabled := true;
        fSplashScreen.btnContinue.ImageIndex := 2;
        fSplashScreen.btnContinue.Enabled := true;
        fSplashScreen.btnContinue.SetFocus;
        Screen.Cursor := rtnCurson;
        fSplashScreen.hide;
        fSplashScreen.ShowModal;
      end;
      fSplashScreen.fDoneRunning := true;

    end
    else
    begin
      fSplashThread.Start;
      fSplashScreen.ShowModal;
      fThreadResult := fThreadResult;
      // if fTaskDialog.ModalResult = mrAbort then
      // Application.Terminate;
    end;
  end
  else
  begin
    fThreadResult := fExecuteEvent(fComponentCallBackProc);
    if ErrorsExist then
    begin
      BundleErrorMessages;
      ShowErrorDialog;
    end;
  end;

end;

destructor tSplashTaskDialog.Destroy;
begin
  if Assigned(fSplashScreen) then
    FreeAndNil(fSplashScreen);
  SetLength(fErrorRecs, 0);
  inherited;
end;

procedure tSplashTaskDialog.BundleErrorMessages;
var
  I, X: Integer;
  CloneArry: array of tErrorRec;
  TitleList: tStringList;
begin
  SetLength(CloneArry, 0);
  TitleList := tStringList.Create;
  try
    TitleList.Sorted := true;
    TitleList.Duplicates := dupIgnore;
    for I := Low(fErrorRecs) to High(fErrorRecs) do
    begin
      SetLength(CloneArry, Length(CloneArry) + 1);
      CloneArry[High(CloneArry)].Title := fErrorRecs[I].Title;
      CloneArry[High(CloneArry)].ErrorMessage := fErrorRecs[I].ErrorMessage;
      CloneArry[High(CloneArry)].ErrType := fErrorRecs[I].ErrType;
      // system errors always display un bundled
      if fErrorRecs[I].ErrType <> Err_Sys then
        TitleList.Add(fErrorRecs[I].Title);
    end;

    SetLength(fErrorRecs, 0);
    // gather the system level errors
    for I := Low(CloneArry) to High(CloneArry) do
    begin
      if CloneArry[I].ErrType = Err_Sys then
      begin
        SetLength(fErrorRecs, Length(fErrorRecs) + 1);
        fErrorRecs[High(fErrorRecs)].Title := CloneArry[I].Title;
        fErrorRecs[High(fErrorRecs)].ErrorMessage := CloneArry[I].ErrorMessage;
        fErrorRecs[High(fErrorRecs)].ErrType := CloneArry[I].ErrType;
      end;
    end;

    // Loop through our unique enteries and bundle them
    for X := 0 to TitleList.Count - 1 do
    begin
      SetLength(fErrorRecs, Length(fErrorRecs) + 1);
      fErrorRecs[High(fErrorRecs)].Title := TitleList[X];
      fErrorRecs[High(fErrorRecs)].ErrType := Err_Other;
      for I := Low(CloneArry) to High(CloneArry) do
      begin
        if CloneArry[I].Title = TitleList[X] then
          fErrorRecs[High(fErrorRecs)].ErrorMessage :=
            CloneArry[High(fErrorRecs)].ErrorMessage + CRLF + CloneArry[I]
            .ErrorMessage;
      end;
    end;

  finally
    TitleList.Free;
  end;
end;

procedure tSplashTaskDialog.FormCloseQuery(Sender: TObject;
var CanClose: Boolean);
begin
  CanClose := false;
  case TSplashScrn(Sender).ModalResult of
    mrNo:
      ShellExecute(Application.Handle, 'open', PChar(fLogPath), '', '',
        SW_NORMAL);
    mrIgnore:
      begin
        ShowErrorDialog;
      end;
    mrYes:
      begin
        if fSysErrorShowing then
        begin
          fSysErrorShowing := false;
          // no need to sync since thread is not running here
          ImageID := 1;
          fSplashScreen.btnContinue.Enabled := false;
          Screen.Cursor := crHourGlass;
          fSplashThread.Start;
        end
        else
          CanClose := true;
      end;
  end;
end;
{$ENDREGION}
{$REGION 'tSplahThread'}

procedure tSplahThread.Execute;
begin
  if Assigned(fOnExecute) then
  begin
    // Sleep(1000);
    tSplashTaskDialog(fSplashDialog).fThreadResult :=
      fOnExecute(fComponentCallBackProc);
  end;
end;

constructor tSplahThread.Create(aSplashCTRL: TComponent;
ComponentCallBackProc: TComponentDataRequestProc);
begin
  inherited Create(true);
  FreeOnTerminate := true;
  fOnExecute := nil;
  fSplashDialog := aSplashCTRL;
  fComponentCallBackProc := ComponentCallBackProc;
end;

destructor tSplahThread.Destroy;
begin
  // generic sync
  Synchronize(
    procedure
    begin
      if tSplashTaskDialog(fSplashDialog).fShowSplash then
      begin
        if not tSplashTaskDialog(fSplashDialog).ErrorsExist then
        begin
          tSplashTaskDialog(fSplashDialog).fSplashScreen.btnContinue.Click;
          // SpeakText(PChar('Please wait, opening ' + ExtractFileName(Application.ExeName)));
        end
        else
        begin
          tSplashTaskDialog(fSplashDialog).SetTaskTitle('General');
          tSplashTaskDialog(fSplashDialog).SetTaskText('Bundling errors');
          tSplashTaskDialog(fSplashDialog).BundleErrorMessages;
          tSplashTaskDialog(fSplashDialog).ImageID := 0;
          tSplashTaskDialog(fSplashDialog).SetTaskTitle('Error Check');
          tSplashTaskDialog(fSplashDialog)
            .SetTaskText
            ('Potential errors where found while trying to process the Jaws scripts. '
            + 'Press continue to ignore these errors and open ' +
            ExtractFileName(Application.ExeName) +
            '. Please note that the framework may not work correctly. ' + CRLF +
            'If you continue to experience this issue please contact your local system administrator for assistance.');

          tSplashTaskDialog(fSplashDialog)
            .fSplashScreen.btnErrors.Enabled := true;
          tSplashTaskDialog(fSplashDialog).fSplashScreen.btnLog.Enabled := true;
          tSplashTaskDialog(fSplashDialog)
            .fSplashScreen.btnContinue.ImageIndex := 2;
          tSplashTaskDialog(fSplashDialog)
            .fSplashScreen.btnContinue.Enabled := true;
          tSplashTaskDialog(fSplashDialog).fSplashScreen.btnContinue.SetFocus;
          Screen.Cursor := tSplashTaskDialog(fSplashDialog).rtnCurson;
        end;
        tSplashTaskDialog(fSplashDialog).fSplashScreen.fDoneRunning := true;
      end
      else
      begin
        tSplashTaskDialog(fSplashDialog).BundleErrorMessages;
        tSplashTaskDialog(fSplashDialog).ShowErrorDialog;
      end;
    end);
  inherited;
end;
{$ENDREGION}
{$REGION 'TSplashScrn'}

procedure TSplashScrn.ApplicationEvents1Idle(Sender: TObject;
var Done: Boolean);
begin
  // Hack since the thread does not want to fire unless a message is being sent to the form
  CheckSynchronize;
  if not fDoneRunning then
  begin
    // self.caption := fOrigCaption + ' - RunTime: '+ formatdatetime('nn:ss:zz', fRunTime - now());
    self.Caption := self.Caption + ' ';
  end;
end;

procedure TSplashScrn.FormCreate(Sender: TObject);
begin
  SetWindowLong(Handle, GWL_EXSTYLE, WS_EX_APPWINDOW);
  Application.Icon.LoadFromResourceName(HInstance, 'AppIcon1');
  fInit := true;
  fDoneRunning := false;
end;

procedure TSplashScrn.FormShow(Sender: TObject);
begin
  if fInit then
  begin
    Screen.Cursor := crHourGlass;
    fInit := false;
    fRunTime := Now;
  end;
end;
{$ENDREGION}
{$REGION 'TStaticText'}

procedure TStaticText.WMSetFocus(var Message: TWMSetFocus);
begin
  FFocused := true;
  Invalidate;
  inherited;
end;

procedure TStaticText.WMKillFocus(var Message: TWMKillFocus);
begin
  FFocused := false;
  Invalidate;
  inherited;
end;

procedure TStaticText.WMPaint(var Message: TWMPaint);
var
  DC: HDC;
  R: TRect;
begin
  inherited;
  if FFocused then
  begin
    DC := GetDC(Handle);
    GetClipBox(DC, R);
    DrawFocusRect(DC, R);
    ReleaseDC(Handle, DC);
  end;
end;
{$ENDREGION}
{$REGION 'TButton'}

procedure TButton.CMEnabledChanged(var Msg: TMessage);
begin
  inherited;
  if not self.Enabled and self.Visible then
  begin
    f508Label := TStaticText.Create(self);
    f508Label.Parent := self.Parent;
    f508Label.SendToBack;
    f508Label.TabStop := true;
    f508Label.TabOrder := self.TabOrder;
    f508Label.Caption := ' ' + self.Caption;
    f508Label.Top := self.Top - 2;
    f508Label.Left := self.Left - 2;
    f508Label.Width := self.Width + 5;
    f508Label.Height := self.Height + 5;
  end
  else
  begin
    if Assigned(f508Label) then
      FreeAndNil(f508Label);
  end;
end;

destructor TButton.Destroy;
begin
  if Assigned(f508Label) then
    FreeAndNil(f508Label);
  Inherited;
end;
{$ENDREGION}

{$WARN SYMBOL_PLATFORM ON}
end.

