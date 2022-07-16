
unit U_Splash;
{$WARN SYMBOL_PLATFORM OFF}
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.StdCtrls,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Winapi.ShellAPI, VAUtils, JAWSImplementation, VA508AccessibilityConst;

type
  tStatus = (DS_RUN, DS_ERROR, DS_CHECK);
  TExecutEvent = function(ComponentCallBackProc: TComponentDataRequestProc): BOOL;

  tSplahThread = Class(TThread)
  private
    fOnExecute: TExecutEvent;
    fSplashDialog: TComponent;
    fComponentCallBackProc: TComponentDataRequestProc;
  protected
    procedure Execute; override;
  public
    constructor Create(aSplashCTRL: TComponent; ComponentCallBackProc: TComponentDataRequestProc);
    destructor Destroy; override;
    property OnExecute: TExecutEvent read fOnExecute write fOnExecute;
  End;

  TErrType = (Err_Sys, Err_Other);

  tErrorRec = Record
    Title: String;
    ErrorMessage: String;
    ErrType: TErrType;
  End;

  tSplashTaskDialog = class(TComponent)
  private
    fTaskDialog: TTaskDialog;
    fSplashThread: tSplahThread;
    fTaskText: String;
    fTaskTitle: String;
    fTaskExpand: string;
    fProgMax: Integer;
    fProgMoveBy: Integer;
    fThreadResult: BOOL;
    fErrorsExist: Boolean;
    fLogPath: String;
    fSysErrorShowing: Boolean;
    fErrorRecs: array of tErrorRec;
    fErrNum: Integer;
    fStopViewErr: Boolean;
    procedure SetTaskText(aValue: string);
    procedure SetTaskTitle(aValue: string);
    procedure SetTaskExpand(aValue: string);
    Procedure SetTaskMaxProg(aValue: Integer);
    procedure SyncTaskText;
    procedure SyncTaskTitle;
    procedure SyncTaskExpand;
    procedure SyncIncProg;
    procedure SyncMaxProg;
    procedure LogButtonClick(aSender: TObject; AModalResult: TModalResult; var CanClose: Boolean);
    procedure ShowErrorDialog;
    procedure ErrorDialogClick(aSender: TObject; AModalResult: TModalResult; var CanClose: Boolean);
    procedure ErrorDialogClose(sender: TObject);
    procedure SplashTaskDialogClose(sender: TObject);
    procedure BundleErrorMessages;
  public
    constructor Create(ExecuteEvent: TExecutEvent; ComponentCallBackProc: TComponentDataRequestProc; LogLink: Boolean = false);
    destructor Destroy;
    Procedure IncProg(ByCnt: Integer = 1);
    procedure ShowSystemError(aErrorText: string);
    procedure Show;
    property TaskText: string read fTaskText write SetTaskText;
    property TaskTitle: string read fTaskTitle write SetTaskTitle;
    property TaskExpand: string read fTaskExpand write SetTaskExpand;
    property TaskMaxProg: Integer read fProgMax write SetTaskMaxProg;
    property ReturnValue: BOOL read fThreadResult;
    property ErrorsExist: Boolean read fErrorsExist;
    property LogPath: string read fLogPath write fLogPath;
  end;

Const
  IMG_ERROR = 1;
  IMG_CHECK = 2;
  IMG_WAIT = 3;

  CAP_EXPAND = 'Technical information';
  CAP_FOOT = 'Errors Found';

  LINE_MAX = 15;

implementation

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
      CommandLinkHint := 'This will close the rest of the errors that were logged'
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
    FooterText := 'Error ' + IntToStr(fErrNum + 1) + ' of ' + IntToStr(High(fErrorRecs) + 1);

    OnButtonClicked := ErrorDialogClick;
    OnDialogDestroyed := ErrorDialogClose;
    SpeakText(PChar(Title + ', ' + Text));

    Execute;
  end;

end;

procedure tSplashTaskDialog.ErrorDialogClick(aSender: TObject; AModalResult: TModalResult; var CanClose: Boolean);
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

procedure tSplashTaskDialog.ErrorDialogClose(sender: TObject);
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

procedure tSplashTaskDialog.SplashTaskDialogClose(sender: TObject);
begin
  if fTaskDialog.ModalResult = mrAbort then
    Application.Terminate;
end;

procedure tSplashTaskDialog.LogButtonClick(aSender: TObject; AModalResult: TModalResult; var CanClose: Boolean);
begin
  CanClose := false;
  case AModalResult of
    mrNone:
      ShellExecute(Application.Handle, 'open', PChar(fLogPath), '', '', SW_NORMAL);
    mrIgnore:
      begin
        ShowErrorDialog;
      end;
    mrAbort:
      begin
        CanClose := true;
        fTaskDialog.ModalResult := mrAbort;
      end;
    mrYes:
      begin
        if fSysErrorShowing then
        begin
          fSysErrorShowing := false;
          fTaskDialog.MainIcon := tdiInformation;
          fTaskDialog.Buttons[2].Enabled := false;
          fSplashThread.start;
        end
        else
          CanClose := true;
      end;
  end;

end;

procedure tSplashTaskDialog.SetTaskText(aValue: string);
begin
  if Assigned(fTaskDialog) then
  begin
    fTaskText := aValue;
    SyncTaskText;
  end;
end;

procedure BreakUpLongListLines(var aList: TStringList; BreakLimit: Integer);
const
  BreakChars = [' ', '-'];
var
  I, Z, LastBreakPos: Integer;
  LineText: WideString;
  WithWraps: TStringList;
begin
  WithWraps := TStringList.Create;
  try
    for I := 0 to aList.Count - 1 do
    begin
      // break up long lines for the save
      if Length(aList[I]) > BreakLimit then
      begin
        // WithWraps.Add( WrapText(aList[I], #13#10,BreakChars, BreakLimit));

        // break this line up
        LineText := aList[I];

        // loop through and break up line at FBreakUpLimit
        while Length(LineText) > BreakLimit do
        begin
          LastBreakPos := BreakLimit;

          if not CharInSet(LineText[BreakLimit + 1], BreakChars) then
          begin
            for Z := BreakLimit downto 1 do
              if LineText[Z] = ' ' then
              begin
                LastBreakPos := Z;
                Break;
              end;
          end;

          WithWraps.Add(Copy(LineText, 1, LastBreakPos));
          LineText := Copy(LineText, LastBreakPos + 1, Length(LineText));

        end;
        // add any remainder
        if Length(LineText) > 0 then
        begin;
          WithWraps.Add(LineText);
        end;
      end
      else
      begin
        WithWraps.Add(aList[I]);
      end;

    end;
    aList.Assign(WithWraps);
  finally
    WithWraps.Free;
  end;

end;

procedure tSplashTaskDialog.SyncTaskText;
var
  tmp: tStringList;
  I, OriglineNum: Integer;
  OrigTxt: String;
begin
  tmp := tStringList.Create;
  try
    tmp.Text := StringReplace(StringReplace(fTaskText, #13, ' ', [rfReplaceAll]), #10, '', [rfReplaceAll]);
    BreakUpLongListLines(tmp, 75);

    OrigTxt := tmp.Text;

    if tmp.Count > LINE_MAX then
    begin
      for I := tmp.Count downto LINE_MAX - 1 do
        tmp.Delete(I);
    end else if tmp.Count < LINE_MAX then
    begin
      OriglineNum := tmp.Count;
      for I := LINE_MAX downto OriglineNum do
        tmp.Add('');
    end;

    fTaskDialog.Text := tmp.Text;
  finally
    tmp.Free;
  end;

  SpeakText(PWideChar(OrigTxt));
  Sleep(3000);
end;

procedure tSplashTaskDialog.SetTaskTitle(aValue: string);
begin
  if Assigned(fTaskDialog) then
  begin
    fTaskTitle := aValue;
    SyncTaskTitle;
  end;
end;

procedure tSplashTaskDialog.SyncTaskTitle;
begin
  fTaskDialog.Title := fTaskTitle;
  Application.ProcessMessages;
  SpeakText(PWideChar(fTaskTitle));

end;

procedure tSplashTaskDialog.SetTaskExpand(aValue: string);
begin
  if Assigned(fTaskDialog) then
  begin
    fTaskExpand := aValue;
    SyncTaskExpand;
  end;
end;

procedure tSplashTaskDialog.SyncTaskExpand;
begin
  if fTaskDialog.ExpandButtonCaption <> CAP_EXPAND then
    fTaskDialog.ExpandButtonCaption := CAP_EXPAND;
  fTaskDialog.ExpandedText := fTaskDialog.ExpandedText + #13#10 + fTaskExpand;
  if fTaskDialog.FooterText <> CAP_FOOT then
  begin
    fTaskDialog.FooterIcon := tdiError;
    fTaskDialog.FooterText := CAP_FOOT + ' Please see log';
  end;
  SetLength(fErrorRecs, Length(fErrorRecs) + 1);
  fErrorRecs[High(fErrorRecs)].Title := fTaskDialog.Title;
  fErrorRecs[High(fErrorRecs)].ErrorMessage := fTaskExpand;
  fErrorRecs[High(fErrorRecs)].ErrType := Err_Other;
  fErrorsExist := true;
end;

Procedure tSplashTaskDialog.SetTaskMaxProg(aValue: Integer);
begin
  fProgMax := aValue;
  // fSplashThread.Synchronize(fSplashThread, SyncMaxProg);
  // TThread.Synchronize(fSplashThread, SyncMaxProg);
  SyncMaxProg;
end;

procedure tSplashTaskDialog.SyncMaxProg;
begin
  fTaskDialog.ProgressBar.Max := fProgMax;
end;

Procedure tSplashTaskDialog.IncProg(ByCnt: Integer = 1);
begin
  fProgMoveBy := ByCnt;
  SyncIncProg;
  // TThread.Synchronize(fSplashThread, SyncIncProg);
end;

procedure tSplashTaskDialog.SyncIncProg;
begin
  fTaskDialog.ProgressBar.Position := fTaskDialog.ProgressBar.Position + fProgMoveBy;
end;

procedure tSplashTaskDialog.ShowSystemError(aErrorText: string);
begin
  fSysErrorShowing := true;

  fTaskDialog.MainIcon := tdiError;
  SetTaskText(aErrorText);
  fTaskDialog.Buttons[2].Default := true;
  fTaskDialog.Buttons[2].Enabled := true;
  fTaskDialog.Buttons[2].Default := true;
  SetLength(fErrorRecs, Length(fErrorRecs) + 1);
  fErrorRecs[High(fErrorRecs)].Title := fTaskDialog.Title;
  fErrorRecs[High(fErrorRecs)].ErrorMessage := aErrorText;
  fErrorRecs[High(fErrorRecs)].ErrType := Err_Sys;
  fSplashThread.Suspended := true;
end;

constructor tSplashTaskDialog.Create(ExecuteEvent: TExecutEvent; ComponentCallBackProc: TComponentDataRequestProc; LogLink: Boolean = false);
  function GetDLLName: string;
  var
    aName: array [0 .. MAX_PATH] of char;
  begin
    fillchar(aName, SizeOf(aName), #0);
    GetModuleFileName(HInstance, aName, MAX_PATH);
    Result := aName;
  end;

var
  DLLName, FileVersion: string;
begin
  inherited Create(nil);
  DLLName := GetDLLName;
  FileVersion := FileVersionValue(DLLName, FILE_VER_FILEVERSION);
  fErrorsExist := false;
  fTaskDialog := TTaskDialog.Create(self);
  fTaskDialog.Caption := 'VA 508 Jaws Framework - Version: ' + FileVersion;;
  fTaskDialog.Title := 'Jaws Framework';
  SetTaskText('Starting the jaws framework. Please wait ' + ExtractFileName(Application.ExeName) +' will open on it''s own if no errors were found.');
  fTaskDialog.MainIcon := tdiInformation;
  fTaskDialog.flags := [tfShowProgressBar];
  fTaskDialog.CommonButtons := [];

  if LogLink then
  begin

    with TTaskDialogButtonItem(fTaskDialog.Buttons.Add) do
    begin
      Caption := 'Log File';
      ModalResult := mrNone;
      Enabled := false;
    end;
    fTaskDialog.OnButtonClicked := LogButtonClick;

    fTaskDialog.FooterText := ' ';
  end;
  with TTaskDialogButtonItem(fTaskDialog.Buttons.Add) do
  begin
    Caption := 'Errors';
    ModalResult := mrIgnore;
    Enabled := false;
  end;
  with TTaskDialogButtonItem(fTaskDialog.Buttons.Add) do
  begin
    Caption := 'Continue';
    ModalResult := mrYes;
    Enabled := false;
    Default := true;
  end;
  fTaskDialog.OnDialogDestroyed := SplashTaskDialogClose;
  fSplashThread := tSplahThread.Create(self, ComponentCallBackProc);
  fSplashThread.OnExecute := ExecuteEvent;
  SetLength(fErrorRecs, 0);

  fErrNum := 0;
end;

Procedure tSplashTaskDialog.Show;
begin
  fSplashThread.Start;
  fTaskDialog.Execute;
  fThreadResult := fTaskDialog.Tag = 1;
  if fTaskDialog.ModalResult = mrAbort then
    Application.Terminate;
end;

destructor tSplashTaskDialog.Destroy;
begin
  FreeAndNil(fTaskDialog);
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
          fErrorRecs[High(fErrorRecs)].ErrorMessage := CloneArry[High(fErrorRecs)].ErrorMessage + CRLF + CloneArry[I].ErrorMessage;
      end;
    end;

  finally
    TitleList.Free;
  end;
end;

procedure tSplahThread.Execute;
begin
  if Assigned(fOnExecute) then
  begin
    Sleep(1000);
    if fOnExecute(fComponentCallBackProc) then
      tSplashTaskDialog(fSplashDialog).fTaskDialog.Tag := 1
    else
      tSplashTaskDialog(fSplashDialog).fTaskDialog.Tag := 0;
  end;
end;

constructor tSplahThread.Create(aSplashCTRL: TComponent; ComponentCallBackProc: TComponentDataRequestProc);
begin
  inherited Create(true);
  FreeOnTerminate := true;
  fOnExecute := nil;
  fSplashDialog := aSplashCTRL;
  fComponentCallBackProc := ComponentCallBackProc;
end;

destructor tSplahThread.Destroy;
begin
  if not tSplashTaskDialog(fSplashDialog).ErrorsExist then
    tSplashTaskDialog(fSplashDialog).fTaskDialog.Buttons[2].Click
  else
  begin
    tSplashTaskDialog(fSplashDialog).SetTaskTitle('General');
    tSplashTaskDialog(fSplashDialog).SetTaskText('Bundling errors');
    tSplashTaskDialog(fSplashDialog).BundleErrorMessages;
    tSplashTaskDialog(fSplashDialog).fTaskDialog.MainIcon := tdiError;
    tSplashTaskDialog(fSplashDialog).SetTaskTitle('Error Check');
    tSplashTaskDialog(fSplashDialog).SetTaskText('Errors where found while trying to process the Jaws scripts. ' + 'Press continue to ignore these errors and open ' + ExtractFileName(Application.ExeName) + '. The framework may not work correctly' + ' If you continue to experience this issue ' + CRLF
      + 'please contact your system administrator for assistance.');
          tSplashTaskDialog(fSplashDialog).fTaskDialog.Buttons[2].Default := true;
    tSplashTaskDialog(fSplashDialog).fTaskDialog.Buttons[0].Enabled := true;
    tSplashTaskDialog(fSplashDialog).fTaskDialog.Buttons[1].Enabled := true;
    tSplashTaskDialog(fSplashDialog).fTaskDialog.Buttons[2].Enabled := true;
    tSplashTaskDialog(fSplashDialog).fTaskDialog.Buttons[2].Default := true;
  end;
  inherited;
end;
{$WARN SYMBOL_PLATFORM ON}
end.

