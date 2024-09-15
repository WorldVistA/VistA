unit uSpell;
// Word settings need to be restored to origional settings!
{$O-}

{$DEFINE CPRS}
{$UNDEF CPRS}

interface

uses
  WinAPI.Windows,
  Messages,
  SysUtils,
  Classes,
  Controls,
  Forms,
  ComObj,
  StdCtrls,
  ComCtrls,
  rCore,
  ORFn,
  Word2000,
  Variants,
  clipbrd,
  ActiveX,
  Contnrs,
  PSAPI,
  ExtCtrls;

type
  TSpellCheckAvailable = record
    Evaluated: boolean;
    Available: boolean;
  end;

function  SpellCheckInProgress: Boolean;
procedure KillSpellCheck;
function  SpellCheckAvailable: Boolean;
procedure SpellCheckForControl(AnEditControl: TCustomMemo);
procedure GrammarCheckForControl(AnEditControl: TCustomMemo);

// Do Not Call these routines - internal use only
procedure InternalSpellCheck(SpellCheck: boolean; EditControl: TCustomMemo; DisplayPanel: TPanel);
procedure RefocusSpellCheckWindow;

const
  SpellCheckerSettingName = 'SpellCheckerSettings';

var
  SpellCheckerSettings: string = '';


implementation

uses VAUtils, fSpellNotify, uInit, UResponsiveGUI;

const
  TX_ERROR_TITLE        = 'Error';
  TX_ERROR_INTRO        = 'An error has occured.';
  TX_TRY_AGAIN          = 'Would you like to try again?';
  TX_WINDOW_TITLE       = 'CPRS-Chart Spell Checking #';
  TX_NO_SPELL_CHECK     = 'Spell checking is unavailable.';
  TX_NO_GRAMMAR_CHECK   = 'Grammar checking is unavailable.';
  TX_SPELL_COMPLETE     = 'The spelling check is complete.';
  TX_GRAMMAR_COMPLETE   = 'The grammar check is complete.';
  TX_SPELL_ABORT        = 'The spelling check terminated abnormally.';
  TX_GRAMMAR_ABORT      = 'The grammar check terminated abnormally.';
  TX_SPELL_CANCELLED    = 'Spelling check was cancelled before completion.';
  TX_GRAMMAR_CANCELLED  = 'Grammar check was cancelled before completion.';
  TX_NO_DETAILS         = 'No further details are available.';
  TX_NO_CORRECTIONS     = 'Corrections have NOT been applied.';
  CRLF                  = #13#10;
//  TABOO_STARTING_CHARS  = '!"#$%&()*+,./:;<=>?@[\]^_`{|}';
  VALID_STARTING_CHARS  = '''-0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

type
  TMSWordThread = class(TThread)
  private
    FBeforeLines: TStringList;
    FAfterLines: TStringList;
    FWordSettings: TList;
    FEditControl: TCustomMemo;
    FShowingMessage: boolean;
//    FEmptyVar: OleVariant;
    FFalseVar: OleVariant;
//    FTrueVar: OleVariant;
    FNullStr: OleVariant;
    FWord: WordApplication;
    FDoc: WordDocument;
    FWordVersion: single;
    FDialog: OleVariant;
    FDocDlg: OleVariant;
    FText: string;
    FSpellCheck: boolean;

    FCanceled: boolean;
    FTitle: string;
    FDocWindowHandle: HWnd;
    FOldFormChange: TNotifyEvent;
    FOldOnActivate: TNotifyEvent;
    FError: Exception;
    FErrorText1: string;
    FErrorText2: string;
    FAllowErrorRetry: boolean;
    FRetryResult: TShow508MessageResult;
    FResultMessage: string;
    FSpellChecking: boolean;
    FLock: TRTLCriticalSection;
    fDisplayPanel: TPanel;
    procedure OnFormChange(Sender: TObject);
    procedure OnAppActivate(Sender: TObject);
    procedure OnThreadTerminate(Sender: TObject);
    procedure FindDocumentWindow;
    procedure EmbedDocumentWindow;
    procedure TransferText;
    function RunWithErrorTrap(AMethod: TThreadMethod;
      SpellCheckErrorMessage, GrammarCheckErrorMessage, AdditionalErrorMessage: string;
      AllowRetry: boolean): boolean;
    procedure WordError;
    procedure StartWord;
    procedure CreateDocument;
    procedure DoCheck;
    procedure ConfigWord;
    procedure ConfigDoc;
    procedure GetDialogs;
    procedure SaveUserSettings;
    procedure LoadUserSettings;
    procedure ExitWord;
    procedure ReportResults;
    procedure SaveWordSettings;
    procedure RestoreWordSettings;
    function UserSetting(Index: integer): boolean;
    procedure ThreadLock;
    procedure ThreadUnlock;
  protected
    constructor CreateThread(SpellCheck: boolean; AEditControl: TCustomMemo);
    procedure Execute; override;
  public
    procedure RefocusSpellCheckDialog;
    property Text: string read FText;
    property Canceled: boolean read FCanceled;
  end;

var
  MSWordThread: TMSWordThread = nil;

function ControlHasText(SpellCheck: boolean; AnEditControl: TCustomMemo): boolean;
var
  i: integer;
begin
  Result := FALSE;
  if not assigned(AnEditControl) then
    ShowMsg('Spell Check programming error')
  else
  begin
    for i := 0 to AnEditControl.Lines.Count - 1 do
    begin
      if trim(AnEditControl.Lines[i]) <> '' then
      begin
        Result := TRUE;
        break;
      end;
    end;
    if not Result then
    begin
      if SpellCheck then
        ShowMsg(TX_SPELL_COMPLETE)
      else
        ShowMsg(TX_GRAMMAR_COMPLETE)
    end;
  end;
end;

function SpellCheckInProgress: boolean;
begin
  Result := assigned(MSWordThread);
end;

var
  uSpellCheckAvailable: TSpellCheckAvailable;

procedure KillSpellCheck;
var
  checking: boolean;
  WordHandle: HWnd;
  ProcessID: DWORD;
  ProcessHandle: THandle;

begin
  if assigned(MSWordThread) then
  begin
    with MSWordThread do
    begin
      ThreadLock;
      try
        checking := FSpellChecking;
        WordHandle := FDocWindowHandle;
        Terminate;
      finally
        ThreadUnlock;
      end;
      try
        if checking then
        begin
          GetWindowThreadProcessId(WordHandle, ProcessID);
          ProcessHandle := OpenProcess(PROCESS_TERMINATE, False, ProcessID);
          try
            TerminateProcess(ProcessHandle, 0);
          finally
            CloseHandle(ProcessHandle);
          end;
        end;
        if assigned(MSWordThread) then
        begin
          WaitFor;
        end;
      except
      end;
    end;
  end;
end;


{ Spell Checking using Visual Basic for Applications script }

function SpellCheckAvailable: Boolean;
//const
//  WORD_VBA_CLSID = 'CLSID\{000209FF-0000-0000-C000-000000000046}';
begin
// CHANGED FOR PT. SAFETY ISSUE RELEASE 19.16, PATCH OR*3*155 - ADDED NEXT 2 LINES:
  //result := false;
  //exit;
//  Reenabled in version 21.1, via parameter setting  (RV)
//  Result := (GetUserParam('ORWOR SPELL CHECK ENABLED?') = '1');
  with uSpellCheckAvailable do        // only want to call this once per session!!!  v23.10+
    begin
      if not Evaluated then
        begin
          Available := (GetUserParam('ORWOR SPELL CHECK ENABLED?') = '1');
          Evaluated := True;
        end;
      Result := Available;
    end;
end;

procedure DoSpellCheck(SpellCheck: boolean; AnEditControl: TCustomMemo);
var
  frmSpellNotify: TfrmSpellNotify;

begin
  if assigned(MSWordThread) then exit;
  if ControlHasText(SpellCheck, AnEditControl) then
  begin
    frmSpellNotify := TfrmSpellNotify.Create(Application);
    try
      SuspendTimeout;
      try
        frmSpellNotify.SpellCheck := SpellCheck;
        frmSpellNotify.EditControl := AnEditControl;
        frmSpellNotify.ShowModal;
      finally
        ResumeTimeout;
      end;
    finally
      frmSpellNotify.Free;
    end;
  end;
end;

procedure InternalSpellCheck(SpellCheck: boolean; EditControl: TCustomMemo; DisplayPanel: TPanel);
begin
  MSWordThread := TMSWordThread.CreateThread(SpellCheck, EditControl);
  MSWordThread.fDisplayPanel := DisplayPanel;
  while Assigned(MSWordThread) do
    TResponsiveGUI.Sleep(50);
end;

procedure RefocusSpellCheckWindow;
begin
  if assigned(MSWordThread) then
    MSWordThread.RefocusSpellCheckDialog;
end;

procedure SpellCheckForControl(AnEditControl: TCustomMemo);
begin
  DoSpellCheck(True, AnEditControl);
end;

procedure GrammarCheckForControl(AnEditControl: TCustomMemo);
begin
  DoSpellCheck(False, AnEditControl);
end;
{ TMSWordThread }

const
  RETRY_MAX = 3;

  usCheckSpellingAsYouType          = 1;
  usCheckGrammarAsYouType           = 2;
  usIgnoreInternetAndFileAddresses  = 3;
  usIgnoreMixedDigits               = 4;
  usIgnoreUppercase                 = 5;
  usCheckGrammarWithSpelling        = 6;
  usShowReadabilityStatistics       = 7;
  usSuggestFromMainDictionaryOnly   = 8;
  usSuggestSpellingCorrections      = 9;
  usHideSpellingErrors              = 10;
  usHideGrammarErrors               = 11;

  sTrueCode   = 'T';
  sFalseCode  = 'F';

    // AFAYT = AutoFormatAsYouType
  wsAFAYTApplyBorders             = 0;
  wsAFAYTApplyBulletedLists       = 1;
  wsAFAYTApplyFirstIndents        = 2;
  wsAFAYTApplyHeadings            = 3;
  wsAFAYTApplyNumberedLists       = 4;
  wsAFAYTApplyTables              = 5;
  wsAFAYTAutoLetterWizard         = 6;
  wsAFAYTDefineStyles             = 7;
  wsAFAYTFormatListItemBeginning  = 8;
  wsAFAYTInsertClosings           = 9;
  wsAFAYTReplaceQuotes            = 10;
  wsAFAYTReplaceFractions         = 11;
  wsAFAYTReplaceHyperlinks        = 12;
  wsAFAYTReplaceOrdinals          = 13;
  wsAFAYTReplacePlainTextEmphasis = 14;
  wsAFAYTReplaceSymbols           = 15;
  wsAutoFormatReplaceQuotes       = 16;
  wsTabIndentKey                  = 17;
  wsWindowState                   = 18;
  wsSaveInterval                  = 19;
  wsTrackRevisions                = 20;
  wsShowRevisions                 = 21;
  wsShowSummary                   = 22; // not used for Word 2010

procedure TMSWordThread.Execute;
var
  ok: boolean;

  procedure DockAndHideWord;
  begin
    Synchronize(EmbedDocumentWindow);
  end;

  procedure EnableAppActivation;
  begin
    FWord.Caption := FTitle;
    Synchronize(FindDocumentWindow);
  end;

  procedure Run(AMethod: TThreadMethod; force: boolean = false);
  begin
    if terminated then exit;
    if ok or force then
    begin
      ok := RunWithErrorTrap(AMethod, TX_SPELL_ABORT, TX_GRAMMAR_ABORT, '', FALSE);
    end;
  end;

  procedure BuildResultMessage;
  begin
    FResultMessage := '';
    if FCanceled then
    begin
      if FSpellCheck then
        FResultMessage := TX_SPELL_CANCELLED
      else
        FResultMessage := TX_GRAMMAR_CANCELLED;
      FResultMessage := FResultMessage + CRLF + TX_NO_CORRECTIONS;
    end
    else
    begin
      if FSpellCheck then
        FResultMessage := TX_SPELL_COMPLETE
      else
        FResultMessage := TX_GRAMMAR_COMPLETE;
    end;
  end;

  procedure SetStatus(value, force: boolean);
  begin
    if ok or force then
    begin
      ThreadLock;
      FSpellChecking := value;
      ThreadUnlock;
    end;
  end;

begin
  CoInitialize(nil);
  ok := true;
  try
    if RunWithErrorTrap(StartWord, TX_NO_SPELL_CHECK, TX_NO_GRAMMAR_CHECK, TX_TRY_AGAIN, TRUE) then
    begin
      try
        if RunWithErrorTrap(CreateDocument, TX_SPELL_ABORT, TX_GRAMMAR_ABORT, '', FALSE) then
        begin
          try
            EnableAppActivation;
            DockAndHideWord;
            Run(SaveWordSettings);
            Run(ConfigWord);
            Run(ConfigDoc);
            Run(GetDialogs);
            Run(LoadUserSettings);
            SetStatus(True, False);
            Run(DoCheck);
            SetStatus(False, True);
            Run(SaveUserSettings);
            Run(RestoreWordSettings);
            Run(ExitWord, True);
            if ok and (not terminated) then
            begin
              Synchronize(TransferText);
              BuildResultMessage;
              Synchronize(ReportResults);
            end;
          finally
            FDoc := nil;
          end;
        end;
      finally
        FWord := nil;
      end;
    end;
  finally
    CoUninitialize;
  end;
end;

procedure TMSWordThread.ExitWord;
var
  Save: OleVariant;
  Doc: OleVariant;

begin
  VarClear(FDialog);
  VarClear(FDocDlg);
  VariantInit(Save);
  VariantInit(Doc);
  try
    Save := wdDoNotSaveChanges;
    Doc := wdWordDocument;
    FWord.Quit(Save, Doc, FFalseVar);
  finally
    VarClear(Save);
    VarClear(Doc);
  end;
end;

var
  WindowTitle: string;
  WindowHandle: HWnd;

function FindDocWindow(Handle: HWND; Info: Pointer): BOOL; stdcall;
var
  title: string;
begin
  title := GetWindowTitle(Handle);
  if title = WindowTitle then
  begin
    WindowHandle := Handle;
    Result := FALSE;
  end
  else
    Result := True;
end;

procedure TMSWordThread.EmbedDocumentWindow;
begin

  // create not visible
  SetWindowLong(FDocWindowHandle, GWL_STYLE, not WS_VISIBLE);

  // Ensure this does not show up on the task bar
  SetWindowLong(FDocWindowHandle, GWL_EXSTYLE, WS_EX_NOACTIVATE);

  // Dock the window
  if assigned(fDisplayPanel) then
    WinAPI.Windows.SetParent(FDocWindowHandle, fDisplayPanel.Handle);

  // Show the window
  ShowWindow(FDocWindowHandle, SW_SHOW);
end;

procedure TMSWordThread.FindDocumentWindow;
begin
  WindowTitle := FTitle;
  WindowHandle := 0;
  EnumWindows(@FindDocWindow, 0);
  FDocWindowHandle := WindowHandle;
end;

procedure TMSWordThread.GetDialogs;
//var
//  DispParams: TDispParams;
//  OleArgs: array of OleVariant;
//  ExcepInfo: TExcepInfo;
//  Status: integer;
begin
//  SetLength(OleArgs, 1);
//  VariantInit(OleArgs[0]);
//  try
    VariantInit(FDialog);
    FDialog := FWord.Dialogs.Item(wdDialogToolsOptionsSpellingAndGrammar);
    VariantInit(FDocDlg);
    FDocDlg := FWord.ActiveDocument;
(*    OleArgs[0] := wdDialogToolsOptionsSpellingAndGrammar;
    DispParams.rgvarg := @OleArgs[0];
    DispParams.cArgs := 1;
    DispParams.rgdispidNamedArgs := nil;
    DispParams.cNamedArgs := 0;
//    FDialog := FWord.Dialogs.Item(wdDialogToolsOptionsSpellingAndGrammar);
    // dispid 0 is the Item method
    Status := FWord.Dialogs.Invoke(0, GUID_NULL, LOCALE_USER_DEFAULT,
        DISPATCH_METHOD or DISPATCH_PROPERTYGET, DispParams, @FDialog, @ExcepInfo, nil);
    if Status <> S_OK then
      DispatchInvokeError(Status, ExcepInfo);
    VariantInit(FDocDlg);
    DispParams.rgvarg := nil;
    DispParams.cArgs := 0;
    Status := FWord.Invoke(3, GUID_NULL, LOCALE_USER_DEFAULT,
        DISPATCH_METHOD or DISPATCH_PROPERTYGET, DispParams, @FDocDlg, @ExcepInfo, nil);
    if Status <> S_OK then
      DispatchInvokeError(Status, ExcepInfo);
  finally
    VarClear(OleArgs[0]);
    SetLength(OleArgs, 0);
  end;                                       *)
end;

procedure TMSWordThread.LoadUserSettings;
begin
  // load FUserSettings from server

  // these are default values
  (*
9  AlwaysSuggest,
8  SuggestFromMainDictOnly,
5  IgnoreAllCaps,
4  IgnoreMixedDigits,
  ResetIgnoreAll,
  Type, CustomDict1, CustomDict2, CustomDict3, CustomDict4, CustomDict5, CustomDict6,
  CustomDict7, CustomDict8, CustomDict9, CustomDict10,
1  AutomaticSpellChecking,
3  FilenamesEmailAliases,
  UserDict1,
2  AutomaticGrammarChecking,
6??  ForegroundGrammar,
7  ShowStatistics,
  Options, RecheckDocument, IgnoreAuxFind, IgnoreMissDictSearch,
10  HideGrammarErrors,
  CheckSpelling, GrLidUI, SpLidUI,
  DictLang1, DictLang2, DictLang3,
  DictLang4, DictLang5, DictLang6, DictLang7, DictLang8, DictLang9, DictLang10,
11  HideSpellingErrors,
  HebSpellStart, InitialAlefHamza, FinalYaa, GermanPostReformSpell,
  AraSpeller, ProcessCompoundNoun
  *)
//  FDialog.
  ThreadLock;
  try
    FDialog.AutomaticSpellChecking   := UserSetting(usCheckSpellingAsYouType);
    FDialog.AutomaticGrammarChecking := UserSetting(usCheckGrammarAsYouType);
    FDialog.FilenamesEmailAliases    := UserSetting(usIgnoreInternetAndFileAddresses);
    FDialog.IgnoreMixedDigits        := UserSetting(usIgnoreMixedDigits);
    FDialog.ForegroundGrammar        := UserSetting(usCheckGrammarWithSpelling);
    FDialog.ShowStatistics           := UserSetting(usShowReadabilityStatistics);
    FDialog.SuggestFromMainDictOnly  := UserSetting(usSuggestFromMainDictionaryOnly);
    FDialog.IgnoreAllCaps            := UserSetting(usIgnoreUppercase);
    FDialog.AlwaysSuggest            := UserSetting(usSuggestSpellingCorrections);
    FDialog.HideSpellingErrors       := UserSetting(usHideSpellingErrors);
    FDialog.HideGrammarErrors        := UserSetting(usHideGrammarErrors);
    FDialog.Execute;
  finally
    ThreadUnlock;
  end;

   // need list of custom dictionaries - default to CUSTOM.DIC (or query Word for it!!!)
//  FWord.CustomDictionaries

end;

procedure TMSWordThread.OnAppActivate(Sender: TObject);
begin
  if assigned(FOldOnActivate) then
    FOldOnActivate(Sender);
  RefocusSpellCheckDialog;
end;

procedure TMSWordThread.OnFormChange(Sender: TObject);
begin
  if assigned(FOldFormChange) then
    FOldFormChange(Sender);
  RefocusSpellCheckDialog;
end;

procedure TMSWordThread.OnThreadTerminate(Sender: TObject);
begin
  Application.OnActivate := FOldOnActivate;
  Screen.OnActiveFormChange := FOldFormChange;
//  VarClear(FEmptyVar);
  VarClear(FFalseVar);
//  VarClear(FTrueVar);
  FWordSettings.Free;
  FBeforeLines.Free;
  FAfterLines.Free;
  DeleteCriticalSection(FLock);
  Screen.Cursor := crDefault;
  MSWordThread := nil;
end;

procedure TMSWordThread.RefocusSpellCheckDialog;
begin
  TResponsiveGUI.ProcessMessages;
  if Application.Active and (not FShowingMessage) and (FDocWindowHandle <> 0) then
  begin
    SetForegroundWindow(FDocWindowHandle);
    SetFocus(FDocWindowHandle);
  end;
end;

procedure TMSWordThread.ReportResults;
var
  icon: TShow508MessageIcon;
begin
  if not FCanceled then
    icon := smiInfo
  else
    icon := smiWarning;
  FShowingMessage := True;
  try
    ShowMsg(FResultMessage, icon, smbOK);
  finally
    FShowingMessage := False;
  end;
end;

procedure TMSWordThread.RestoreWordSettings;

  function Load(Index: integer): integer;
  begin
    if FWordSettings.Count > Index then
      Result := Integer(FWordSettings[Index])
    else
      Result := 0
  end;

begin
  FWord.Options.AutoFormatAsYouTypeApplyBorders             := boolean(Load(wsAFAYTApplyBorders));
  FWord.Options.AutoFormatAsYouTypeApplyBulletedLists       := boolean(Load(wsAFAYTApplyBulletedLists));
  FWord.Options.AutoFormatAsYouTypeApplyFirstIndents        := boolean(Load(wsAFAYTApplyFirstIndents));
  FWord.Options.AutoFormatAsYouTypeApplyHeadings            := boolean(Load(wsAFAYTApplyHeadings));
  FWord.Options.AutoFormatAsYouTypeApplyNumberedLists       := boolean(Load(wsAFAYTApplyNumberedLists));
  FWord.Options.AutoFormatAsYouTypeApplyTables              := boolean(Load(wsAFAYTApplyTables));
  FWord.Options.AutoFormatAsYouTypeAutoLetterWizard         := boolean(Load(wsAFAYTAutoLetterWizard));
  FWord.Options.AutoFormatAsYouTypeDefineStyles             := boolean(Load(wsAFAYTDefineStyles));
  FWord.Options.AutoFormatAsYouTypeFormatListItemBeginning  := boolean(Load(wsAFAYTFormatListItemBeginning));
  FWord.Options.AutoFormatAsYouTypeInsertClosings           := boolean(Load(wsAFAYTInsertClosings));
  FWord.Options.AutoFormatAsYouTypeReplaceQuotes            := boolean(Load(wsAFAYTReplaceQuotes));
  FWord.Options.AutoFormatAsYouTypeReplaceFractions         := boolean(Load(wsAFAYTReplaceFractions));
  FWord.Options.AutoFormatAsYouTypeReplaceHyperlinks        := boolean(Load(wsAFAYTReplaceHyperlinks));
  FWord.Options.AutoFormatAsYouTypeReplaceOrdinals          := boolean(Load(wsAFAYTReplaceOrdinals));
  FWord.Options.AutoFormatAsYouTypeReplacePlainTextEmphasis := boolean(Load(wsAFAYTReplacePlainTextEmphasis));
  FWord.Options.AutoFormatAsYouTypeReplaceSymbols           := boolean(Load(wsAFAYTReplaceSymbols));
  FWord.Options.AutoFormatReplaceQuotes                     := boolean(Load(wsAutoFormatReplaceQuotes));
  FWord.Options.TabIndentKey                                := boolean(Load(wsTabIndentKey));
  FWord.WindowState                                         := Load(wsWindowState);
  FWord.Options.SaveInterval                                := Load(wsSaveInterval);
  FDoc.TrackRevisions                                       := boolean(Load(wsTrackRevisions));
  FDoc.ShowRevisions                                        := boolean(Load(wsShowRevisions));
  if (FWordVersion < 13) then                               // altered for Word 2010
    FDoc.ShowSummary                                        := boolean(Load(wsShowSummary));
end;

function TMSWordThread.RunWithErrorTrap(AMethod: TThreadMethod;
  SpellCheckErrorMessage, GrammarCheckErrorMessage,
  AdditionalErrorMessage: string; AllowRetry: boolean): boolean;
var
  RetryCount: integer;
  Done: boolean;
begin
  RetryCount := 0;
  Result := TRUE;
  repeat
    Done := TRUE;
    try
      AMethod;
    except
      on E: Exception do
      begin
        if not terminated then
        begin
          inc(RetryCount);
          Done := FALSE;
          if RetryCount >= RETRY_MAX then
          begin
            FError := E;
            FAllowErrorRetry := AllowRetry;
            if FSpellCheck then
              FErrorText1 := SpellCheckErrorMessage
            else
              FErrorText1 := GrammarCheckErrorMessage;
            FErrorText2 := AdditionalErrorMessage;
            Synchronize(WordError);
            if AllowRetry and (FRetryResult = smrRetry) then
              RetryCount := 0
            else
            begin
              Result := FALSE;
              Done := TRUE;
            end;
          end;
        end;
      end;
    end;
  until Done;
end;

procedure TMSWordThread.DoCheck;
begin
  FDoc.Content.Text := FText;
  FDoc.Content.SpellingChecked := False;
  FDoc.Content.GrammarChecked := False;
  if FSpellCheck then
  begin
    FDocDlg.Content.CheckSpelling;
//      FDoc.CheckSpelling(FNullStr, FEmptyVar, FEmptyVar, {Ignore, Suggest, }FNullStr, FNullStr,
//                         FNullStr, FNullStr, FNullStr, FNullStr, FNullStr, FNullStr, FNullStr);
//    FSucceeded := FDoc.Content.SpellingChecked;
    FText := FDoc.Content.Text;
  end
  else
  begin
    FDoc.Content.CheckGrammar;
//    FSucceeded := FDoc.Content.GrammarChecked;
    FText := FDoc.Content.Text;
  end;
  FCanceled := (FText = '');
end;

procedure TMSWordThread.SaveUserSettings;

  procedure SaveSetting(Value: boolean; Index: integer);
  begin
    while length(SpellCheckerSettings) < Index do
      SpellCheckerSettings := SpellCheckerSettings + ' ';
    if Value then
      SpellCheckerSettings[Index] := sTrueCode
    else
      SpellCheckerSettings[Index] := sFalseCode;
  end;
begin
  ThreadLock;
  try
    SpellCheckerSettings := '';
    FDialog.Update;
    SaveSetting(FDialog.AutomaticSpellChecking,    usCheckSpellingAsYouType);
    SaveSetting(FDialog.AutomaticGrammarChecking,  usCheckGrammarAsYouType);
    SaveSetting(FDialog.FilenamesEmailAliases,     usIgnoreInternetAndFileAddresses);
    SaveSetting(FDialog.IgnoreMixedDigits,         usIgnoreMixedDigits);
    SaveSetting(FDialog.IgnoreAllCaps,             usIgnoreUppercase);
    SaveSetting(FDialog.ForegroundGrammar,         usCheckGrammarWithSpelling);
    SaveSetting(FDialog.ShowStatistics,            usShowReadabilityStatistics);
    SaveSetting(FDialog.SuggestFromMainDictOnly,   usSuggestFromMainDictionaryOnly);
    SaveSetting(FDialog.AlwaysSuggest,             usSuggestSpellingCorrections);
    SaveSetting(FDialog.HideSpellingErrors,        usHideSpellingErrors);
    SaveSetting(FDialog.HideGrammarErrors,         usHideGrammarErrors);
  finally
    ThreadUnlock;
  end;
     (*
9  AlwaysSuggest,
8  SuggestFromMainDictOnly,
5  IgnoreAllCaps,
4  IgnoreMixedDigits,
  ResetIgnoreAll,
  Type, CustomDict1, CustomDict2, CustomDict3, CustomDict4, CustomDict5, CustomDict6,
  CustomDict7, CustomDict8, CustomDict9, CustomDict10,
1  AutomaticSpellChecking,
3  FilenamesEmailAliases,
  UserDict1,
2  AutomaticGrammarChecking,
6??  ForegroundGrammar,
7  ShowStatistics,
  Options, RecheckDocument, IgnoreAuxFind, IgnoreMissDictSearch,
10  HideGrammarErrors,
  CheckSpelling, GrLidUI, SpLidUI,
  DictLang1, DictLang2, DictLang3,
  DictLang4, DictLang5, DictLang6, DictLang7, DictLang8, DictLang9, DictLang10,
11  HideSpellingErrors,
  HebSpellStart, InitialAlefHamza, FinalYaa, GermanPostReformSpell,
  AraSpeller, ProcessCompoundNoun
  *)
end;

procedure TMSWordThread.SaveWordSettings;

  procedure Save(Value, Index: integer);
  begin
    while FWordSettings.Count <= Index do
      FWordSettings.Add(nil);
    FWordSettings[Index] := Pointer(Value);
  end;

begin
  Save(Ord(FWord.Options.AutoFormatAsYouTypeApplyBorders)             , wsAFAYTApplyBorders);
  Save(Ord(FWord.Options.AutoFormatAsYouTypeApplyBulletedLists)       , wsAFAYTApplyBulletedLists);
  Save(Ord(FWord.Options.AutoFormatAsYouTypeApplyFirstIndents)        , wsAFAYTApplyFirstIndents);
  Save(Ord(FWord.Options.AutoFormatAsYouTypeApplyHeadings)            , wsAFAYTApplyHeadings);
  Save(Ord(FWord.Options.AutoFormatAsYouTypeApplyNumberedLists)       , wsAFAYTApplyNumberedLists);
  Save(Ord(FWord.Options.AutoFormatAsYouTypeApplyTables)              , wsAFAYTApplyTables);
  Save(Ord(FWord.Options.AutoFormatAsYouTypeAutoLetterWizard)         , wsAFAYTAutoLetterWizard);
  Save(Ord(FWord.Options.AutoFormatAsYouTypeDefineStyles)             , wsAFAYTDefineStyles);
  Save(Ord(FWord.Options.AutoFormatAsYouTypeFormatListItemBeginning)  , wsAFAYTFormatListItemBeginning);
  Save(Ord(FWord.Options.AutoFormatAsYouTypeInsertClosings)           , wsAFAYTInsertClosings);
  Save(Ord(FWord.Options.AutoFormatAsYouTypeReplaceQuotes)            , wsAFAYTReplaceQuotes);
  Save(Ord(FWord.Options.AutoFormatAsYouTypeReplaceFractions)         , wsAFAYTReplaceFractions);
  Save(Ord(FWord.Options.AutoFormatAsYouTypeReplaceHyperlinks)        , wsAFAYTReplaceHyperlinks);
  Save(Ord(FWord.Options.AutoFormatAsYouTypeReplaceOrdinals)          , wsAFAYTReplaceOrdinals);
  Save(Ord(FWord.Options.AutoFormatAsYouTypeReplacePlainTextEmphasis) , wsAFAYTReplacePlainTextEmphasis);
  Save(Ord(FWord.Options.AutoFormatAsYouTypeReplaceSymbols)           , wsAFAYTReplaceSymbols);
  Save(Ord(FWord.Options.AutoFormatReplaceQuotes)                     , wsAutoFormatReplaceQuotes);
  Save(Ord(FWord.Options.TabIndentKey)                                , wsTabIndentKey);
  Save(Ord(FWord.WindowState)                                         , wsWindowState);
  Save(Ord(FWord.Options.SaveInterval)                                , wsSaveInterval);
  Save(Ord(FDoc.TrackRevisions)                                       , wsTrackRevisions);
  Save(Ord(FDoc.ShowRevisions)                                        , wsShowRevisions);
  if (FWordVersion < 13) then                                         // altered for Word 2010
    Save(Ord(FDoc.ShowSummary)                                        , wsShowSummary);
end;

procedure TMSWordThread.StartWord;
begin
  FWord := CoWordApplication.Create;
  FWordVersion := StrToFloatDef(FWord.Version, 0.0);
end;

procedure TMSWordThread.ThreadLock;
begin
  EnterCriticalSection(FLock);
end;

procedure TMSWordThread.ThreadUnlock;
begin
  LeaveCriticalSection(FLock);
end;

procedure TMSWordThread.TransferText;
var
  i: integer;
  Lines: TStringList;
begin
  if (not FCanceled) then
  begin
    Lines := TStringList.Create;
    try
      Lines.Text := FText;
      // For some unknown reason spell check adds garbage lines to text
      while (Lines.Count > 0) and (trim(Lines[Lines.Count-1]) = '') do
        Lines.Delete(Lines.Count-1);
      for i := 0 to FBeforeLines.Count-1 do
        Lines.Insert(i, FBeforeLines[i]);
      for i := 0 to FAfterLines.Count-1 do
        Lines.Add(FAfterLines[i]);
      FEditControl.Lines.Text :=  Lines.Text;
  //    FastAssign(Lines, FEditControl.Lines);
    finally
      Lines.Free;
    end;
  end;
end;

function TMSWordThread.UserSetting(Index: integer): boolean;
begin
  if SpellCheckerSettings = '' then
  begin
    case Index of
      usCheckSpellingAsYouType:         Result := True;
      usCheckGrammarAsYouType:          Result := False;
      usIgnoreInternetAndFileAddresses: Result := True;
      usIgnoreMixedDigits:              Result := True;
      usIgnoreUppercase:                Result := True;
      usCheckGrammarWithSpelling:       Result := False;
      usShowReadabilityStatistics:      Result := False;
      usSuggestFromMainDictionaryOnly:  Result := False;
      usSuggestSpellingCorrections:     Result := True;
      usHideSpellingErrors:             Result := False;
      usHideGrammarErrors:              Result := True;
      else                              Result := False;
    end;
  end
  else
    Result := copy(SpellCheckerSettings,Index,1) = sTrueCode;
end;

procedure TMSWordThread.ConfigDoc;
begin
  FDoc.TrackRevisions        := False;
  FDoc.ShowRevisions         := False;
  if (FWordVersion < 13) then            // altered for Word 2010
    FDoc.ShowSummary         := False;
  FWord.Height               := 1000;
  FWord.Width                := 1000;
  FWord.Top                  := -2000;
  FWord.Left                 := -2000;
end;

procedure TMSWordThread.ConfigWord;
begin
// save all old values to FWord, restore when done.
  FWord.Options.AutoFormatAsYouTypeApplyBorders             := False;
  FWord.Options.AutoFormatAsYouTypeApplyBulletedLists       := False;
  FWord.Options.AutoFormatAsYouTypeApplyFirstIndents        := False;
  FWord.Options.AutoFormatAsYouTypeApplyHeadings            := False;
  FWord.Options.AutoFormatAsYouTypeApplyNumberedLists       := False;
  FWord.Options.AutoFormatAsYouTypeApplyTables              := False;
  FWord.Options.AutoFormatAsYouTypeAutoLetterWizard         := False;
  FWord.Options.AutoFormatAsYouTypeDefineStyles             := False;
  FWord.Options.AutoFormatAsYouTypeFormatListItemBeginning  := False;
  FWord.Options.AutoFormatAsYouTypeInsertClosings           := False;
  FWord.Options.AutoFormatAsYouTypeReplaceQuotes            := False;
  FWord.Options.AutoFormatAsYouTypeReplaceFractions         := False;
  FWord.Options.AutoFormatAsYouTypeReplaceHyperlinks        := False;
  FWord.Options.AutoFormatAsYouTypeReplaceOrdinals          := False;
  FWord.Options.AutoFormatAsYouTypeReplacePlainTextEmphasis := False;
  FWord.Options.AutoFormatAsYouTypeReplaceSymbols           := False;
  FWord.Options.AutoFormatReplaceQuotes                     := False;
  FWord.Options.TabIndentKey                                := False;
  FWord.WindowState                                         := wdWindowStateNormal;
  FWord.Options.SaveInterval                                := 0;
  FWord.ResetIgnoreAll;
end;

procedure TMSWordThread.CreateDocument;
var
  DocType: OleVariant;
begin
  VariantInit(DocType);
  try
    DocType := wdNewBlankDocument;
    FDoc := FWord.Documents.Add(FNullStr, FFalseVar, DocType, FFalseVar);
    FDoc.Activate;
  finally
    VarClear(DocType);
  end;
end;

constructor TMSWordThread.CreateThread(SpellCheck: boolean; AEditControl: TCustomMemo);

  function WordDocTitle: string;
  var
    Guid: TGUID;
  begin
    if ActiveX.Succeeded(CreateGUID(Guid)) then
      Result := GUIDToString(Guid)
    else
      Result := '';
    Result := TX_WINDOW_TITLE + IntToStr(Application.Handle) + '/' + Result;
  end;

  function BeforeLineInvalid(Line: string): boolean;
  var
    i: integer;
  begin
    Result := (trim(Line) = '');
    if not Result then
    begin
      for I := 1 to length(Line) do
        if pos(Line[i], VALID_STARTING_CHARS) > 0 then exit;
      Result := True;
    end;
  end;

  procedure GetTextFromComponent;
  var
    Lines: TStrings;
  begin
    Lines := TStringList.Create;
    try
      Lines.Text := AEditControl.Lines.Text;
     // FastAssign(AEditControl.Lines, Lines);

      while (Lines.Count > 0) and (trim(Lines[Lines.Count-1]) = '') do
      begin
        FAfterLines.Insert(0, Lines[Lines.Count-1]);
        Lines.Delete(Lines.Count-1);
      end;

      while (Lines.Count > 0) and (BeforeLineInvalid(Lines[0])) do
      begin
        FBeforeLines.Add(Lines[0]);
        Lines.Delete(0);
      end;

      FText := Lines.Text;
    finally
      Lines.Free;
    end;
  end;

begin
  inherited Create(TRUE);
  Screen.Cursor := crHourGlass;
  InitializeCriticalSection(FLock);
  FBeforeLines := TStringList.Create;
  FAfterLines := TStringList.Create;
  FWordSettings := TList.Create;
  FSpellChecking := False;
  FEditControl := AEditControl;
//  VariantInit(FEmptyVar);
  VariantInit(FFalseVar);
//  VariantInit(FTrueVar);
  VariantInit(FNullStr);
//  TVarData(FEmptyVar).VType := VT_EMPTY;
  TVarData(FFalseVar).VType := VT_BOOL;
//  TVarData(FTrueVar).VType := VT_BOOL;
  TVarData(FNullStr).VType := VT_BSTR;
//  FEmptyVar := 0;
  FFalseVar := 0;
//  FTrueVar := -1;
  FNullStr := '';
  FDocWindowHandle := 0;
  FSpellCheck := SpellCheck;

  GetTextFromComponent;

  FCanceled := FALSE;
  FTitle := WordDocTitle;
  FreeOnTerminate := True;
  OnTerminate := OnThreadTerminate;
  FOldOnActivate := Application.OnActivate;
  Application.OnActivate := OnAppActivate;
  FOldFormChange := Screen.OnActiveFormChange;
  Screen.OnActiveFormChange := OnFormChange;
{$WARN SYMBOL_DEPRECATED OFF}
  Resume;
{$WARN SYMBOL_DEPRECATED ON}
end;

procedure TMSWordThread.WordError;
var
  btn: TShow508MessageButton;
  msg: string;

  procedure Append(txt: string);
  begin
    if txt <> '' then
      msg := msg + CRLF + txt;
  end;

begin
  if FAllowErrorRetry then
    btn := smbRetryCancel
  else
    btn := smbOK;
  msg := TX_ERROR_INTRO;
  Append(FErrorText1);
  if FError.Message <> '' then
    Append(FError.Message)
  else
    Append(TX_NO_DETAILS);
  Append(FErrorText2);
  FShowingMessage := True;
  try
    FRetryResult := ShowMsg(Msg, TX_ERROR_TITLE, smiError, btn);
  finally
    FShowingMessage := False;
  end;
end;

initialization

finalization
  KillSpellCheck;

end.
