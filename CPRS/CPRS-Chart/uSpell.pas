unit uSpell;

{$O-}

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, ComObj, StdCtrls, ComCtrls,
  ORSystem, Word2000, ORFn, Variants, rCore, clipbrd;

type

  TSpellCheckAvailable = record
    Evaluated: boolean;
    Available: boolean;
  end;

function  SpellCheckAvailable: Boolean;
function  SpellCheckInProgress: Boolean;
procedure KillSpellCheck;
procedure SpellCheckForControl(AnEditControl: TCustomMemo);
procedure GrammarCheckForControl(AnEditControl: TCustomMemo);

implementation

const
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
  CR_LF                 = #13#10;
  SPELL_CHECK           = 'S';
  GRAMMAR_CHECK         = 'G';

var
  WindowList: TList;
  OldList, NewList: TList;
  MSWord: OleVariant;
  uSpellCheckAvailable: TSpellCheckAvailable;

function SpellCheckInProgress: boolean;
begin
  Result := not VarIsEmpty(MSWord);
end;

procedure KillSpellCheck;
begin
  if SpellCheckInProgress then
    begin
      MSWord.Quit(wdDoNotSaveChanges);
      VarClear(MSWord);
    end;
end;

function SpellCheckTitle: string;
begin
  Result := TX_WINDOW_TITLE + IntToStr(Application.Handle);
end;

function GetWindows(Handle: HWND; Info: Pointer): BOOL; stdcall;
begin
  Result := True;
  WindowList.Add(Pointer(Handle));
end;

procedure GetWindowList(List: TList);
begin
  WindowList := List;
  EnumWindows(@GetWindows, 0);
end;

procedure BringWordToFront(OldList, NewList: TList);
var
  i, NameLen: integer;
  WinName: array[0..160] of char;
  NewWinName: PChar;
  NewName: string;

begin
  NewName := SpellCheckTitle;
  NameLen := length(NewName);
  for i := 0 to NewList.Count-1 do
  begin
    if(OldList.IndexOf(NewList[i]) < 0) then
    begin
      GetWindowText(HWND(NewList[i]), WinName, sizeof(WinName) - 1);
      if Pos('CPRS', WinName) > 0 then
        NewWinName := PChar(Copy(WinName, Pos('CPRS', WinName), sizeof(WinName) - 1))
      else
        NewWinName := WinName;
      if StrLComp(NewWinName, pchar(NewName), NameLen)=0 then
      begin
        Application.ProcessMessages;
        SetForegroundWindow(HWND(NewList[i]));
        break;
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

procedure SpellAndGrammarCheckForControl(var AnotherEditControl: TCustomMemo; ACheck: Char);
var
  NoLFText, LFText: string;
  OneChar: char;
  ErrMsg: string;
  FinishedChecking: boolean;
  OldSaveInterval, i: integer;
  MsgText: string;
  FirstLineBlank: boolean;
  OldLine0: string;
begin
  if AnotherEditControl = nil then Exit;
  OldList := TList.Create;
  NewList := TList.Create;
  FinishedChecking := False;
  FirstLineBlank := False;
  NoLFText := '';
  OldLine0 := '';
  ClipBoard.Clear;
  try
    try
      GetWindowList(OldList);
      try
        Screen.Cursor := crHourGlass;
        MSWord := CreateOLEObject('Word.Application');
      except   // MSWord not available, so exit now
        Screen.Cursor := crDefault;
        case ACheck of
          SPELL_CHECK  :  MsgText := TX_NO_SPELL_CHECK;
          GRAMMAR_CHECK:  MsgText := TX_NO_GRAMMAR_CHECK;
          else            MsgText := ''
        end;
        Application.MessageBox(PChar(MsgText), PChar(Application.Title), MB_ICONWARNING);
        Exit;
      end;

      GetWindowList(NewList);
      try
        MSWord.Application.Caption := SpellCheckTitle;
        // Position Word off screen to avoid having document visible...
        MSWord.WindowState := 0;
        MSWord.Top := -3000;
        OldSaveInterval := MSWord.Application.Options.SaveInterval;
        MSWord.Application.Options.SaveInterval := 0;
        MSWord.Application.Options.AutoFormatReplaceQuotes := False;
        MSWord.Application.Options.AutoFormatAsYouTypeReplaceQuotes := False;
        MSWord.ResetIgnoreAll;

        MSWord.Documents.Add;                                              // FileNew
        MSWord.ActiveDocument.TrackRevisions := False;
        with AnotherEditControl do
          if (Lines.Count > 0) and (not ContainsVisibleChar(Lines[0])) then
            begin
              FirstLineBlank := True;  //MS bug when spell-checking document with blank first line  (RV - v22.6)
              OldLine0 := Lines[0];
              Lines.Delete(0);
            end;
        MSWord.ActiveDocument.Content.Text := (AnotherEditControl.Text);   // The Text property returns the plain, unformatted text of the selection or range.
                                                                           // When you set this property, the text of the range or selection is replaced.
        BringWordToFront(OldList, NewList);
        MSWord.ActiveDocument.Content.SpellingChecked := False;
        MSWord.ActiveDocument.Content.GrammarChecked := False;

        case ACheck of
          SPELL_CHECK  :  begin
                            MSWord.ActiveDocument.Content.CheckSpelling;                       // ToolsSpelling
                            FinishedChecking := MSWord.ActiveDocument.Content.SpellingChecked;
                          end;
          GRAMMAR_CHECK:  begin
                            MSWord.ActiveDocument.Content.CheckGrammar;                       // ToolsGrammar
                            FinishedChecking := MSWord.ActiveDocument.Content.GrammarChecked;
                          end;
        end;
        if FinishedChecking then    // not cancelled?
          NoLFText := MSWord.ActiveDocument.Content.Text                   // EditSelectAll
        else
          NoLFText := '';
      finally
        Screen.Cursor := crDefault;
        MSWord.Application.Options.SaveInterval := OldSaveInterval;
        case ACheck of
          SPELL_CHECK  :  FinishedChecking := MSWord.ActiveDocument.Content.SpellingChecked;
          GRAMMAR_CHECK:  FinishedChecking := MSWord.ActiveDocument.Content.GrammarChecked;   
        end;
        MSWord.Quit(wdDoNotSaveChanges);
        VarClear(MSWord);
      end;
    finally
      OldList.Free;
      NewList.Free;
    end;
  except
    on E: Exception do
      begin
        ErrMsg := E.Message;
        FinishedChecking := False;
      end;
  end;

  Screen.Cursor := crDefault;
  Application.BringToFront;
  if FinishedChecking then
    begin
      if (Length(NoLFText) > 0) then
        begin
          LFText := '';
          for i := 1 to Length(NoLFText) do
          begin
            OneChar := NoLFText[i];
            LFText := LFText + OneChar;
            if OneChar = #13 then LFText := LFText + #10;
          end;
          with AnotherEditControl do if Lines.Count > 0 then
            begin
              Text := LFText;
              if FirstLineBlank then Text := OldLine0 + Text;
            end;
          case ACheck of
            SPELL_CHECK  : MsgText := TX_SPELL_COMPLETE;
            GRAMMAR_CHECK: MsgText := TX_GRAMMAR_COMPLETE;
            else           MsgText := ''
          end;
          Application.MessageBox(PChar(MsgText), PChar(Application.Title), MB_ICONINFORMATION);
        end
      else
        begin
          case ACheck of
            SPELL_CHECK  : MsgText := TX_SPELL_CANCELLED;
            GRAMMAR_CHECK: MsgText := TX_GRAMMAR_CANCELLED;
            else           MsgText := ''
          end;
          Application.MessageBox(PChar(MsgText + CR_LF + CR_LF + TX_NO_CORRECTIONS), PChar(Application.Title), MB_ICONINFORMATION);
        end;
    end
  else   // error during spell or grammar check
    begin
      case ACheck of
        SPELL_CHECK  :  MsgText := TX_SPELL_ABORT;
        GRAMMAR_CHECK:  MsgText := TX_GRAMMAR_ABORT;
        else            MsgText := ''
      end;
      if ErrMsg = '' then ErrMsg := TX_NO_DETAILS;
      Application.MessageBox(PChar(MsgText + CR_LF + ErrMsg + CR_LF + CR_LF + TX_NO_CORRECTIONS), PChar(Application.Title), MB_ICONWARNING);
    end;
  SendMessage(TRichEdit(AnotherEditControl).Handle, WM_VSCROLL, SB_TOP, 0);
  AnotherEditControl.SetFocus;
end;

procedure SpellCheckForControl(AnEditControl: TCustomMemo);
begin
  if AnEditControl = nil then Exit;
  SpellAndGrammarCheckForControl(AnEditControl, SPELL_CHECK);
end;

procedure GrammarCheckForControl(AnEditControl: TCustomMemo);
begin
  if AnEditControl = nil then Exit;
  SpellAndGrammarCheckForControl(AnEditControl, GRAMMAR_CHECK);
end;


end.
