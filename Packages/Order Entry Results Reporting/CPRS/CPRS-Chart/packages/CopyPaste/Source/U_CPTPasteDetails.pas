{ ******************************************************************************

    ___  __  ____  _  _      _    ____   __   ____  ____  ____
   / __)/  \(  _ \( \/ )    / )  (  _ \ / _\ / ___)(_  _)(  __)
  ( (__(  O )) __/ )  /    / /    ) __//    \\___ \  )(   ) _)
   \___)\__/(__)  (__/    (_/    (__)  \_/\_/(____/ (__) (____)


  Paste Details Control unit

  Components:

  TCopyPasteDetails = This is the visual element that will display
  the details collected by TCopyEditMonitor into a TRichEdit.

  Functions:

  Register = Registers the control


  { ****************************************************************************** }

unit U_CPTPasteDetails;

interface

uses
  ORExtensions,
  U_CptUtils, U_CPTCommon, System.Classes, U_CPTEditMonitor, Vcl.ExtCtrls,
  U_CPTExtended, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.Graphics, Winapi.Messages, System.IniFiles, System.SysUtils,
  Winapi.Windows, Winapi.RichEdit,
  System.Generics.Collections, System.Math, Vcl.Forms, System.UITypes,
  Vcl.Controls, VA508AccessibilityRouter,
  Vcl.Clipbrd, Vcl.Dialogs, System.Generics.Defaults, System.StrUtils,
  U_CPTAppMonitor;

type
  TCopyPasteDetails = class(TPanel)
  private
    FCollapseBtn: TCollapseBtn;

    CPFoundRecs: TCPFoundRecArray;
    FSaveFindAfter: Integer;
    fTopPanel: TPanel;
    fRecStatus: TCPStatus;
    fRecStatusBtn: TButton;
    fRecStatBtnVisible: Boolean;
    fProgressBar: TProgressBar;
    FCopyMonitor: TCopyApplicationMonitor;
    fParentForm: TCustomForm;
    fDefaultSelectAll: Boolean;
    fEditMonitor: TCopyEditMonitor;
    FHide: TVisible;
    FInfoboxCollapsed: Boolean;
    FInfoMessage: ORExtensions.TRichEdit;
    FInfoSelector: TSelectorBox;
    FCPSplitter: TSplitter;
    FLastInfoboxHeight: Integer;
    FMonitorObject: ORExtensions.TRichEdit;
    FNewShowing: Boolean;
    fFromPaste: Boolean;
    FOurOrigWndProc: TWndMethod;
    FPasteCurPos: Integer;
    FShow: TVisible;
    FShowAllPaste: Boolean;
    FSuspendResize: Boolean;
    FSyncSizes: Boolean;

    FOnButtonToggle: TToggleEvent;
    FOnAnalyze: TSaveEvent;
    function CharLookup(LineNum: Integer; StartCheck: Boolean = False;
      EndCheck: Boolean = False): Boolean;
    procedure HighLightInfoPanel(Color: TColor; Style: TFontStyles;
      ShowHighlight: Boolean; PasteText: String;
      ClearPrevHighLight: Boolean = true);
    procedure InfoPanelResize(Sender: TObject);

    procedure LCSCompareStrings(DestRich: TRichEdit;
      OrigStr, ModStr: TStringList);
    procedure AuditClick(Sender: TObject);

    procedure pnlMessageExit(Sender: TObject);
    procedure OurWndProc(var Message: TMessage);
    procedure ReloadInfoPanel();
    procedure SetObjectToMonitor(ACopyObject: ORExtensions.TRichEdit);
    procedure ShowInfoPanel(Toggle: Boolean);
    Procedure VisualMesageCenter(Sender: TObject; const CPmsg: Cardinal;
      CPVars: Array of Variant; FromNewPaste: Boolean = false);

    procedure FindText(var FoundPOS: TCPFindTxtRecArray;
      PasteRec, NoteRec: TCPTextRec; MINLNGTH: Integer; NoteList: TStringList);
    function FindStartPos(NoteRec: TCPTextRec; SubSearchPos: Integer = -1;
      NoteLineFullTxt: string = ''): Integer;
    Procedure LoadBlankLines(NoteArray: TCpTextRecArray;
      StrtLn, StopLn: Integer);
    procedure FindMatchingLines(NoteArray, PasteArray: TCpTextRecArray;
      var ResultArray: TCPMatchingLinesArray);
    function FindMatchingSection(var DataArray: TCPMatchingLinesArray;
      NoteArray, PasteArray: TCpTextRecArray): Integer;
    procedure FindBufferZone(aPasteLineNum, aNoteLineNum: Integer;
      Var aStrBuff, aEndBuff: Integer; PasteList, OrigText: TStringList);
    function SPECIAL(FoundArray: TCPFoundRecArray;
      NoteLineNum: Integer): Boolean;
    procedure SetCopyMonitor(Value: TCopyApplicationMonitor);
    function GetCopyPasteEnabled: Boolean;
    function GetShowAllPaste: Boolean;
    procedure SetShowAllPaste(const Value: Boolean);
  public
    procedure CheckForModifiedPaste(var SaveList: TStringList);
    procedure CloseInfoPanel(Sender: TObject);
    procedure CPCOMPARE(const aPastedRec: TCprsClipboard;
      var OutList: TStringList; var FinalPercent: Double; var TimeTook: Int64);
    constructor Create(AOwner: TComponent); override;
    Property DefaultSelectAll: Boolean read fDefaultSelectAll
      write fDefaultSelectAll;
    destructor Destroy; override;
    procedure DoExit; override;
    property FInfoPanelVisible: Boolean write ShowInfoPanel;
    procedure lbSelectorClick(Sender: TObject);
    procedure LoadPasteText();

    procedure FillPasteArray(SourceData: THashedStringList;
      var UpdateRec: TPasteText);

    Procedure ManuallyShowNewHighlights();
    procedure PreLoadPasteRecs(LoadFrom: TStringList);

    procedure SaveTheMonitor(ItemID: Integer);
    property ShowAllPaste: Boolean read GetShowAllPaste write SetShowAllPaste;
    procedure Resize; override;
    property InfoBoxCollapsed: Boolean read FInfoboxCollapsed;

    property RecStatus: TCPStatus read fRecStatus write fRecStatus;
    Property RecStatBtnVisible: Boolean read fRecStatBtnVisible
      write fRecStatBtnVisible;
    property ParentForm: TCustomForm read fParentForm write fParentForm;
    property CopyPasteEnabled: Boolean read GetCopyPasteEnabled;
  published
    property CopyMonitor: TCopyApplicationMonitor read FCopyMonitor
      write SetCopyMonitor;
    property CollapseBtn: TCollapseBtn read FCollapseBtn;
    property EditMonitor: TCopyEditMonitor read fEditMonitor write fEditMonitor;
    property InfoMessage: ORExtensions.TRichEdit read FInfoMessage;
    property InfoSelector: TSelectorBox read FInfoSelector;
    property OnHide: TVisible read FHide write FHide;
    property OnShow: TVisible read FShow write FShow;
    property SyncSizes: Boolean read FSyncSizes write FSyncSizes;
    property VisualEdit: ORExtensions.TRichEdit read FMonitorObject
      write SetObjectToMonitor;
    property OnButtonToggle: TToggleEvent read FOnButtonToggle
      write FOnButtonToggle;
    property OnAnalyze: TSaveEvent read FOnAnalyze write FOnAnalyze;
    property SaveFindAfter: Integer read FSaveFindAfter write FSaveFindAfter;
  end;

procedure Register;

implementation

uses
  System.SyncObjs, VAUtils, UResponsiveGUI;

procedure Register;
begin
  RegisterComponents('Copy/Paste', [TCopyPasteDetails]);
end;

{$REGION 'TcpyPasteDetails'}

Procedure TCopyPasteDetails.ManuallyShowNewHighlights();
var
  NewEntries: Boolean;
  I: Integer;
begin
  with EditMonitor do
  begin
    if not Assigned(FCopyMonitor) then
      Exit;
    if not FCopyMonitor.Enabled then
      Exit;

    NewEntries := false;
    for I := Low(PasteText) to High(PasteText) do
    begin
      if not PasteText[i].IdentFired then
      begin
        NewEntries := true;
        break;
      end;
    end;

    if NewEntries then
    begin
      if Assigned(VisualMessage) then
      begin
        if not FCopyMonitor.DisplayPaste then
          VisualMessage(Self, Hide_Panel, [true])
        else
          VisualMessage(Self, ShowHighlight, [true, true]);
      end;
    end;
  end;
end;

procedure TCopyPasteDetails.VisualMesageCenter(Sender: TObject;
  const CPmsg: Cardinal; CPVars: Array of Variant; FromNewPaste: Boolean = false);
var
  SelectAll: Boolean;
begin
  if not Assigned(EditMonitor.CopyMonitor) then
    Exit;
  if not EditMonitor.CopyMonitor.Enabled then
    Exit;
  if Length(CPVars) < 1 then
    Exit;
  Try
    case CPmsg of
      Show_Panel:
        // CPVar[0] = Toggle to show panel
        ShowInfoPanel(Boolean(CPVars[0]));
      ShowAndSelect_Panel:
        Begin
          // CPVar[0] = Toggle to show panel
          // CPVar[1] = Select the all entries (if applicable)
          ShowInfoPanel(Boolean(CPVars[0]));
          if Boolean(CPVars[0]) then
          begin
            if FLastInfoboxHeight < Self.Constraints.MinHeight then
              FLastInfoboxHeight := Self.Constraints.MinHeight;
            if FInfoboxCollapsed then
            begin
              CloseInfoPanel(Self);
            end
            else
              Self.Height := FLastInfoboxHeight;

            // Autoselect the pasted text
            FInfoSelector.ItemIndex := 0;

            SelectAll := False;
            if Length(CPVars) > 1 then
              SelectAll := Boolean(CPVars[1]);

            if FInfoSelector.ItemIndex <> -1 then
            begin
              if (UpperCase(FInfoSelector.Items[FInfoSelector.ItemIndex])
                = 'ALL ENTRIES') and (not SelectAll) then
                FInfoSelector.ItemIndex := 1;
            end;

            lbSelectorClick(FInfoSelector);
            if FInfoSelector.CanFocus then
              FInfoSelector.SetFocus;
          end;
        End;
      Hide_Panel:
        // CPVar[0] = Toggle to show panel
        // CPVar[1] = Select the all entries (if applicable)
        If Boolean(CPVars[0]) then
          ShowInfoPanel(False);
      ShowHighlight:
        Begin
          // CPVar[0] = Toggle to show panel
          ShowInfoPanel(Boolean(CPVars[0]));
          if Boolean(CPVars[0]) then
          begin
            if FLastInfoboxHeight < Self.Constraints.MinHeight then
              FLastInfoboxHeight := Self.Constraints.MinHeight;
            if FInfoboxCollapsed then
            begin
              CloseInfoPanel(Self);
            end
            else
              Self.Height := FLastInfoboxHeight;

            // Autoselect the pasted text
            FInfoSelector.ItemIndex := 0;

            SelectAll := False;
            if Length(CPVars) > 1 then
              SelectAll := Boolean(CPVars[1]);
            if FInfoSelector.ItemIndex <> -1 then
            begin
              if (UpperCase(FInfoSelector.Items[FInfoSelector.ItemIndex])
                = 'ALL ENTRIES') and (not SelectAll) then
                FInfoSelector.ItemIndex := 1;
            end;

            FInfoSelector.SelectorColor := clLtGray;
            if not fDefaultSelectAll then
              FNewShowing := true;
            fFromPaste := FromNewPaste;
            lbSelectorClick(FInfoSelector);
            if FInfoSelector.CanFocus then
              FInfoSelector.SetFocus;
            fFromPaste := false;
          end;
        End;
    end;

  Except
    on E: Exception do
    begin
      raise Exception.Create('Exception class name = ' + E.ClassName + #13 +
        'Exception message = ' + E.Message);
    end;

  End;
end;

procedure TCopyPasteDetails.InfoPanelResize(Sender: TObject);
begin
  if not Assigned(EditMonitor) then
    Exit;
  if Assigned(EditMonitor.CopyMonitor) then
    if not EditMonitor.CopyMonitor.Enabled then
      Exit;
  if Self.Constraints.MinHeight <> (fTopPanel.Top + fTopPanel.Height + 10) then
    Self.Constraints.MinHeight := (fTopPanel.Top + fTopPanel.Height + 10);
  if FSuspendResize then
    Exit;
  if Self.Height > Self.Constraints.MinHeight then
  begin
    FCollapseBtn.Caption := 'Ú'; // up
    FInfoboxCollapsed := False;
  end;
  if Self.Height = Self.Constraints.MinHeight then
  begin
    FCollapseBtn.Caption := 'Ù'; // up
    FInfoboxCollapsed := true;
  end
  else
    FLastInfoboxHeight := Self.Height;
end;

Procedure TCopyPasteDetails.ReloadInfoPanel();
Var
  I: Integer;
begin
  if not Assigned(EditMonitor.CopyMonitor) then
    Exit;
  if not EditMonitor.CopyMonitor.Enabled then
    Exit;
  FInfoMessage.Text := '<-- Please select the desired paste date';
  With FInfoSelector, EditMonitor do
  begin
    TabOrder := FMonitorObject.TabOrder + 1;
    Clear;
    If Length(PasteText) > 1 then
      Items.Add('All Entries');
    for I := High(PasteText) downto Low(PasteText) do
    begin
      if PasteText[I].Status = PasteNew then
        PasteText[I].InfoPanelIndex := Items.Add('new')
      else if PasteText[I].VisibleOnList then
        PasteText[I].InfoPanelIndex :=
          Items.Add(FormatFMDateTime('mmm dd,yyyy hh:nn',
          StrToFloat(PasteText[I].DateTimeOfPaste)));
    end;
    FInfoMessage.TabOrder := FMonitorObject.TabOrder + 2;
  end;
end;

procedure TCopyPasteDetails.CloseInfoPanel(Sender: TObject);
begin
  if Assigned(EditMonitor.CopyMonitor) then
    if not EditMonitor.CopyMonitor.Enabled then
      Exit;
  if Self.Constraints.MinHeight <> (fTopPanel.Top + fTopPanel.Height + 10) then
    Self.Constraints.MinHeight := (fTopPanel.Top + fTopPanel.Height + 10);
  FSuspendResize := true;
  if FInfoboxCollapsed then
  begin
    if FLastInfoboxHeight > 0 then
      Self.Height := FLastInfoboxHeight
    else
      Self.Height := Self.Constraints.MinHeight;
    FCollapseBtn.Caption := 'Ú'; // down
  end
  else
  begin
    FLastInfoboxHeight := Self.Height;
    Self.Height := Self.Constraints.MinHeight;
    FCollapseBtn.Caption := 'Ù'; // up
  end;
  FInfoboxCollapsed := Not FInfoboxCollapsed;
  FSuspendResize := False;
  if Assigned(FOnButtonToggle) then
    FOnButtonToggle(Self, FInfoboxCollapsed);
end;

procedure TCopyPasteDetails.ShowInfoPanel(Toggle: Boolean);
begin
  if Assigned(EditMonitor.CopyMonitor) then
    if not EditMonitor.CopyMonitor.Enabled then
      Exit;
  Parent.LockDrawing;
  try
    if Toggle then
    begin
      Self.Visible := true;
      ReloadInfoPanel;
      if Assigned(FShow) then
        FShow(Self);
    end
    else
    begin
      if Assigned(Self) then
      begin
        Self.Visible := False;
        if Assigned(FHide) then
          FHide(Self);
      end;

    end;
  finally
    Parent.UnlockDrawing;
  end;
end;

procedure TCopyPasteDetails.pnlMessageExit(Sender: TObject);
VAr
  Format: CHARFORMAT2;
 // ResetMask: Integer;
  LastCurPos, LastCurSel, LastLineNum: Integer;
begin
  if Assigned(EditMonitor.CopyMonitor) then
    if not EditMonitor.CopyMonitor.Enabled then
      Exit;
  SuspendRichUndo(TRichEdit(FMonitorObject), true);
  try
  with EditMonitor do
  begin
    LastCurPos := TRichEdit(FMonitorObject).SelStart;
    LastCurSel := TRichEdit(FMonitorObject).SelLength;
    LastLineNum := TRichEdit(FMonitorObject).perform( EM_GETFIRSTVISIBLELINE, 0, 0 );
    TRichEdit(FMonitorObject).SelStart := 0;
    TRichEdit(FMonitorObject).SelLength :=
      Length(TRichEdit(FMonitorObject).Text);
    // Set the font
    TRichEdit(FMonitorObject).SelAttributes.Style := [];
    // Set the background color
    FillChar(Format, SizeOf(Format), 0);
    Format.cbSize := SizeOf(Format);
    Format.dwMask := CFM_BACKCOLOR;
    if TRichEdit(FMonitorObject).Color > 0 then
      Format.crBackColor := ColorToRGB(TRichEdit(FMonitorObject).Color)
    else
      Format.crBackColor := ColorToRGB(clwindow);

    TRichEdit(FMonitorObject).Perform(EM_SETCHARFORMAT, SCF_SELECTION,
      Longint(@Format));
    TRichEdit(FMonitorObject).SelLength := 0;

    if not TRichEdit(FMonitorObject).ReadOnly and TRichEdit(FMonitorObject).Enabled
    then
    begin
      if FNewShowing then
      begin
        TRichEdit(FMonitorObject).SelStart := LastCurPos;
        TRichEdit(FMonitorObject).SelLength := LastCurSel;
      end
      else
        TRichEdit(FMonitorObject).SelStart := FPasteCurPos;
      TRichEdit(FMonitorObject).perform( em_linescroll, 0,
           LastLineNum -
             TRichEdit(FMonitorObject).perform( EM_GETFIRSTVISIBLELINE, 0, 0 )
          );
    end;
  end;
  finally
    SuspendRichUndo(TRichEdit(FMonitorObject), false);
  end;
end;

procedure TCopyPasteDetails.lbSelectorClick(Sender: TObject);
var
  I, ii, iii, CharCnt, X, ReturnFSize, RtnCurPos, RtnLineNum: Integer;
  ResetMask: Integer;
  FirstClear: Boolean;
  Synamb, DisplayTxt: TStringList;
  RtnCursor: TCursor;
begin
  if Assigned(EditMonitor.CopyMonitor) then
    if not EditMonitor.CopyMonitor.Enabled then
      Exit;
  if TListBox(Sender).ItemIndex < 0 then
    Exit;

  RtnCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  ResetMask := TRichEdit(FMonitorObject).Perform(EM_GETEVENTMASK, 0, 0);
  RtnLineNum := 0;
  RtnCurPos := 0;
  FMonitorObject.Perform(EM_SETEVENTMASK, 0, 0);
  FMonitorObject.LockDrawing;
  try
    with EditMonitor do
    begin
      FInfoMessage.Clear;
      if not FMonitorObject.ReadOnly and fFromPaste then
      begin
         RtnLineNum := FMonitorObject.perform( EM_GETFIRSTVISIBLELINE, 0, 0 );
         RtnCurPos := FMonitorObject.SelStart;
      end;
      if UpperCase(TListBox(Sender).Items[TListBox(Sender).ItemIndex]) = 'ALL ENTRIES'
      then
      begin
        FInfoMessage.SelAttributes.Style := [fsBold, fsUnderline];
        ReturnFSize := FInfoMessage.SelAttributes.Size;
        FInfoMessage.SelAttributes.Size := ReturnFSize + 2;
        FInfoMessage.SelText := 'Paste Details'#13#10;
        FInfoMessage.SelAttributes.Size := ReturnFSize;
        FInfoMessage.SelAttributes.Style := [];
        FInfoMessage.SelText :=
          'Details are provided for individual entries.'#13#10;

        // now higlight all the items
        for I := Low(PasteText) to High(PasteText) do
        begin
          // Update highlight lines if its new (from transfer)
          if not(PasteText[I].IdentFired) then
          begin
            PasteText[I].VisibleOnNote := LoadIdentLines(FMonitorObject,
              PasteText[I].PastedText, PasteText[I].HiglightLines);
            PasteText[I].IdentFired := true;
          end;

          if PasteText[I].VisibleOnNote then
          begin
            if Length(PasteText[I].GroupItems) > 0 then
            begin
              // Loop through the groups
              for ii := High(PasteText[I].GroupItems)
                downto Low(PasteText[I].GroupItems) do
              begin
                if PasteText[I].GroupItems[ii].GroupParent then
                  Continue;
                // If the group is visible
                if PasteText[I].GroupItems[ii].VisibleOnNote then
                begin
                  // Loop through the highlights
                  for iii := Low(PasteText[I].GroupItems[ii].HiglightLines)
                    to High(PasteText[I].GroupItems[ii].HiglightLines) do
                  begin
                    // If above word count
                    if PasteText[I].GroupItems[ii].HiglightLines[iii].AboveWrdCnt
                    then
                    begin
                      HighLightInfoPanel(CopyMonitor.HighlightColor,
                        CopyMonitor.MatchStyle, CopyMonitor.MatchHighlight,
                        PasteText[I].GroupItems[ii].HiglightLines[iii]
                        .LineToHighlight, False);
                    end;
                  end;
                end;
              end;
            end
            else
            begin
              for ii := Low(PasteText[I].HiglightLines)
                to High(PasteText[I].HiglightLines) do
              begin
                if PasteText[I].HiglightLines[ii].AboveWrdCnt then
                begin
                  HighLightInfoPanel(CopyMonitor.HighlightColor,
                    CopyMonitor.MatchStyle, CopyMonitor.MatchHighlight,
                    PasteText[I].HiglightLines[ii].LineToHighlight, False);
                end;
              end;
            end;
          end;
        end;

        FInfoMessage.SelStart := 0;
      end
      else
      begin

        for I := Low(PasteText) to High(PasteText) do
        begin
          if PasteText[I].InfoPanelIndex = TListBox(Sender).ItemIndex then
          begin
            FInfoMessage.SelAttributes.Style := [fsBold, fsUnderline];
            ReturnFSize := FInfoMessage.SelAttributes.Size;
            FInfoMessage.SelAttributes.Size := ReturnFSize + 2;
            FInfoMessage.SelText := 'Source (from)'#13#10;
            FInfoMessage.SelAttributes.Size := ReturnFSize;

            if PasteText[I].Status = PasteNew then
            begin
              FInfoMessage.SelAttributes.Style := [];
              FInfoMessage.SelText :=
                'More details will be provided once saved'#13#10;
            end;

            if PasteText[I].DoNotFind then
            begin
              FInfoMessage.SelAttributes.Style := [fsBold];
              FInfoMessage.SelText :=
                'Paste exceeds GUI highlight limit and not highlight properly on in the GUI.'
                + ' This will still appear in the report'#13#10;
              FInfoMessage.SelAttributes.Style := [];
            end;

            if PasteText[I].DateTimeOfOriginalDoc <> '' then
            begin
              FInfoMessage.SelAttributes.Style := [fsBold];
              FInfoMessage.SelText := 'Document created on: ';
              FInfoMessage.SelAttributes.Style := [];
              FInfoMessage.SelText := FormatFMDateTime('mmm dd,yyyy hh:nn',
                StrToFloat(PasteText[I].DateTimeOfOriginalDoc)) + #13#10;
            end;

            if PasteText[I].CopiedFromLocation <> '' then
            begin
              if StrToIntDef(Piece(PasteText[I].CopiedFromLocation, ';', 1),
                -1) = -1 then
              begin
                CharCnt := 1;
                for iii := 1 to Length(PasteText[I].CopiedFromLocation) do
                  if PasteText[I].CopiedFromLocation[iii] = ';' then
                    Inc(CharCnt);
                FInfoMessage.SelAttributes.Style := [fsBold];
                FInfoMessage.SelText := 'Patient: ';
                FInfoMessage.SelAttributes.Style := [];
                FInfoMessage.SelText := Piece(PasteText[I].CopiedFromLocation,
                  ';', CharCnt) + #13#10;
              end
              else if PasteText[I].CopiedFromPatient <> '' then
              begin
                FInfoMessage.SelAttributes.Style := [fsBold];
                FInfoMessage.SelText := 'Patient: ';
                FInfoMessage.SelAttributes.Style := [];
                FInfoMessage.SelText :=
                  Piece(PasteText[I].CopiedFromPatient, ';', 2) + #13#10;
              end;
            end
            else if PasteText[I].CopiedFromPatient <> '' then
            begin
              FInfoMessage.SelAttributes.Style := [fsBold];
              FInfoMessage.SelText := 'Patient: ';
              FInfoMessage.SelAttributes.Style := [];
              FInfoMessage.SelText :=
                Piece(PasteText[I].CopiedFromPatient, ';', 2) + #13#10;
            end;

            if PasteText[I].CopiedFromDocument <> '' then
            begin
              FInfoMessage.SelAttributes.Style := [fsBold];
              FInfoMessage.SelText := 'Title: ';
              FInfoMessage.SelAttributes.Style := [];
              FInfoMessage.SelText := PasteText[I].CopiedFromDocument + #13#10;
            end;

            if Piece(PasteText[I].CopiedFromAuthor, ';', 2) <> '' then
            begin
              FInfoMessage.SelAttributes.Style := [fsBold];
              FInfoMessage.SelText := 'Author: ';
              FInfoMessage.SelAttributes.Style := [];
              FInfoMessage.SelText :=
                Piece(PasteText[I].CopiedFromAuthor, ';', 2) + #13#10;
            end;

            if PasteText[I].CopiedFromLocation <> '' then
            begin
              if StrToIntDef(Piece(PasteText[I].CopiedFromLocation, ';', 1), -1)
                <> -1 then
              begin
                FInfoMessage.SelAttributes.Style := [fsBold];
                FInfoMessage.SelText := 'ID: ';
                FInfoMessage.SelAttributes.Style := [];
                FInfoMessage.SelText :=
                  Piece(PasteText[I].CopiedFromLocation, ';', 1) + #13#10;
              end;
              if Piece(PasteText[I].CopiedFromLocation, ';', 2) <> '' then
              begin
                FInfoMessage.SelAttributes.Style := [fsBold];
                FInfoMessage.SelText := 'From: ';
                FInfoMessage.SelAttributes.Style := [];
                FInfoMessage.SelText :=
                  Piece(PasteText[I].CopiedFromLocation, ';', 2) + #13#10;
              end;
            end;

            if PasteText[I].CopiedFromApplication <> '' then
            begin
              FInfoMessage.SelAttributes.Style := [fsBold];
              FInfoMessage.SelText := 'Application: ';
              FInfoMessage.SelAttributes.Style := [];
              FInfoMessage.SelText := PasteText[I]
                .CopiedFromApplication + #13#10;
            end;

            FInfoMessage.SelAttributes.Style := [fsBold, fsUnderline];
            ReturnFSize := FInfoMessage.SelAttributes.Size;
            FInfoMessage.SelAttributes.Size := ReturnFSize + 2;
            FInfoMessage.SelText := #13#10'Pasted Info'#13#10;
            FInfoMessage.SelAttributes.Size := ReturnFSize;

            if PasteText[I].DateTimeOfPaste <> '' then
            begin
              FInfoMessage.SelAttributes.Style := [fsBold];
              FInfoMessage.SelText := 'Date: ';
              FInfoMessage.SelAttributes.Style := [];
              FInfoMessage.SelText := FormatFMDateTime('mmm dd,yyyy hh:nn',
                StrToFloat(PasteText[I].DateTimeOfPaste)) + #13#10;
            end;

            if Piece(PasteText[I].UserWhoPasted, ';', 2) <> '' then
            begin
              FInfoMessage.SelAttributes.Style := [fsBold];
              FInfoMessage.SelText := 'User: ';
              FInfoMessage.SelAttributes.Style := [];
              FInfoMessage.SelText := Piece(PasteText[I].UserWhoPasted, ';',
                2) + #13#10;
            end;

            if PasteText[I].PastedPercentage <> '' then
            begin
              FInfoMessage.SelAttributes.Style := [fsBold];
              FInfoMessage.SelText := 'Percentage: ';
              FInfoMessage.SelAttributes.Style := [];
              FInfoMessage.SelText := PasteText[I].PastedPercentage + #13#10;
            end;

            // Update highlight lines if its new (from transfer)
            if not(PasteText[I].IdentFired) then
            begin
              PasteText[I].VisibleOnNote := LoadIdentLines(FMonitorObject,
                PasteText[I].PastedText, PasteText[I].HiglightLines);
              PasteText[I].IdentFired := True;
            end;
            // check if we are not going to show some lines and add them to the list
            Synamb := TStringList.Create;
            try
              if Length(PasteText[I].GroupItems) > 0 then
              begin
                // loop through the paste text
                for ii := high(PasteText[I].GroupItems)
                  downto low(PasteText[I].GroupItems) do
                begin
                  if PasteText[I].GroupItems[ii].GroupParent then
                    Continue;
                  // If the group is visible
                  if PasteText[I].GroupItems[ii].VisibleOnNote then
                  begin
                    // loop through highlights
                    for iii := high(PasteText[I].GroupItems[ii].HiglightLines)
                      downto low(PasteText[I].GroupItems[ii].HiglightLines) do
                    begin
                      // if its above the word count
                      if not PasteText[I].GroupItems[ii].HiglightLines[iii].AboveWrdCnt
                      then
                        Synamb.Add(PasteText[I].GroupItems[ii].HiglightLines
                          [iii].LineToHighlight);
                    end;
                  end;
                end;
              end
              else
              begin
                for ii := high(PasteText[I].HiglightLines)
                  downto low(PasteText[I].HiglightLines) do
                begin
                  if not PasteText[I].HiglightLines[ii].AboveWrdCnt then
                    Synamb.Add(PasteText[I].HiglightLines[ii].LineToHighlight);
                end;
              end;

              if Synamb.Count > 0 then
              begin
                FInfoMessage.SelAttributes.Style := [fsBold];
                FInfoMessage.SelText :=
                  'During the save process, formatting changes occurred and tracking '
                  + 'of pasted text was interrupted.  Potentially pasted text may be found in the highlighted area.';
                FInfoMessage.SelAttributes.Style := [];
                for X := 0 to Synamb.Count - 2 do
                  FInfoMessage.Lines.Add(Synamb[X]);
                if Synamb.Count > 0 then
                  FInfoMessage.Lines.Add(Synamb[Synamb.Count - 1] + #13#10);
              end;
            finally
              FreeAndNil(Synamb);
            end;

            FirstClear := true;

            DisplayTxt := TStringList.Create;
            try
              if PasteText[I].VisibleOnNote then
              begin
                // if group
                if Length(PasteText[I].GroupItems) > 0 then
                begin
                  // loop through the paste text
                  for ii := high(PasteText[I].GroupItems)
                    downto low(PasteText[I].GroupItems) do
                  begin
                    if PasteText[I].GroupItems[ii].GroupParent then
                      Continue;
                    // If the group is visible
                    if PasteText[I].GroupItems[ii].VisibleOnNote then
                    begin
                      // loop through highlights
                      for iii := high(PasteText[I].GroupItems[ii].HiglightLines)
                        downto low(PasteText[I].GroupItems[ii].HiglightLines) do
                      begin
                        // if its above the word count
                        if PasteText[I].GroupItems[ii].HiglightLines[iii].AboveWrdCnt
                        then
                        begin
                          HighLightInfoPanel(CopyMonitor.HighlightColor,
                            CopyMonitor.MatchStyle, CopyMonitor.MatchHighlight,
                            PasteText[I].GroupItems[ii].HiglightLines[iii]
                            .LineToHighlight, FirstClear);
                          if FirstClear then
                            FirstClear := False;
                        end;
                        DisplayTxt.Add(PasteText[I].GroupItems[ii].HiglightLines
                          [iii].LineToHighlight);
                      end;
                    end;
                  end;
                end
                else
                begin
                  for ii := high(PasteText[I].HiglightLines)
                    downto low(PasteText[I].HiglightLines) do
                  begin
                    if PasteText[I].HiglightLines[ii].AboveWrdCnt then
                    begin
                      HighLightInfoPanel(CopyMonitor.HighlightColor,
                        CopyMonitor.MatchStyle, CopyMonitor.MatchHighlight,
                        PasteText[I].HiglightLines[ii].LineToHighlight,
                        FirstClear);
                      if FirstClear then
                        FirstClear := False;
                    end;
                    DisplayTxt.Add(PasteText[I].HiglightLines[ii]
                      .LineToHighlight);
                  end;
                end;
              end;

              if not(EditMonitor.CopyMonitor.LCSToggle) or
                (Length(PasteText[I].GroupItems) = 0) then
              begin

                FInfoMessage.SelAttributes.Style := [fsBold];
                if PasteText[I].VisibleOnNote then
                  FInfoMessage.SelText := 'Pasted Text: '
                else
                  FInfoMessage.SelText :=
                    'Pasted Text (Unable to identify on document): ';
                FInfoMessage.SelAttributes.Style := [];

                // If this is from the group then load the group parent
                if Length(PasteText[I].GroupItems) > 0 then
                begin
                  for ii := high(PasteText[I].GroupItems)
                    downto low(PasteText[I].GroupItems) do
                  begin
                    if PasteText[I].GroupItems[ii].GroupParent then
                    begin
                      for X := 0 to PasteText[I].GroupItems[ii]
                        .GroupText.Count - 1 do
                        FInfoMessage.Lines.Add
                          (PasteText[I].GroupItems[ii].GroupText[X]);
                      Break;
                    end;
                  end;
                end
                else
                begin
                  for X := 0 to PasteText[I].PastedText.Count - 1 do
                    FInfoMessage.Lines.Add(PasteText[I].PastedText[X]);
                end;
              end
              else if (EditMonitor.CopyMonitor.LCSToggle) and
                (Length(PasteText[I].GroupItems) > 0) then
              begin
                FInfoMessage.SelAttributes.Style := [fsBold];
                if PasteText[I].VisibleOnNote then
                  FInfoMessage.SelText := 'Pasted Text: '
                else
                  FInfoMessage.SelText :=
                    'Pasted Text (Unable to identify on document): ';
                FInfoMessage.SelAttributes.Style := [];

                // If this is from the group then load the group parent
                if Length(PasteText[I].GroupItems) > 0 then
                begin
                  for ii := high(PasteText[I].GroupItems)
                    downto low(PasteText[I].GroupItems) do
                  begin
                    if PasteText[I].GroupItems[ii].GroupParent then
                    begin
                      LCSCompareStrings(FInfoMessage,
                        PasteText[I].GroupItems[ii].GroupText, DisplayTxt);
                      Break;
                    end;
                  end;
                end
                else
                begin
                  for X := 0 to PasteText[I].PastedText.Count - 2 do
                    FInfoMessage.Lines.Add(PasteText[I].PastedText[X]);
                  if PasteText[I].PastedText.Count > 0 then
                    FInfoMessage.Lines.Add
                      (PasteText[I].PastedText[PasteText[I].PastedText.Count -
                      1] + #13#10);
                end;
              end;

            finally
              FreeAndNil(DisplayTxt);
            end;

            if not PasteText[I].VisibleOnNote then
              pnlMessageExit(Self);

            FInfoMessage.SelStart := 0;
            Break;
          end;

        end;
      end;
      if not FMonitorObject.ReadOnly and fFromPaste then
      begin
        FMonitorObject.SelStart := RtnCurPos;
        FMonitorObject.perform( em_linescroll, 0, RtnLineNum -
                        FMonitorObject.perform( EM_GETFIRSTVISIBLELINE, 0, 0 ));
      end;
    end;
  finally
    FMonitorObject.UnlockDrawing;
    FMonitorObject.Perform(EM_SETEVENTMASK, 0, ResetMask);
    Screen.Cursor := RtnCursor;
    TResponsiveGUI.ProcessMessages; // moved from HighLightInfoPanel
  end;
end;

procedure TCopyPasteDetails.LCSCompareStrings(DestRich: TRichEdit;
  OrigStr, ModStr: TStringList);
type
  TIntMultiArray = array of array of Integer;

  TDiff = record
    Character: char;
    CharStatus: char;
  end;
var
  LCSAlgAry: TIntMultiArray;
  RtnCursor, Len1, Len2, I: Integer;
  CharDiff, Diff: TDiff;
  FinalList: TList<TDiff>;
  aStr1, aStr2: WideString;
  FlipStringLst: TStringList;

  function FillLCSAlgAry(aValue1, aValue2: string): TIntMultiArray;
  var
    Len1, Len2, I, X: Integer;
  begin
    Len1 := Length(aValue1);
    Len2 := Length(aValue2);

    // We need one extra column and one extra row to be filled with zeroes
    SetLength(Result, Len1 + 1, Len2 + 1);

    // First column filled with zeros
    for I := 0 to Len1 do
      Result[I, 0] := 0;

    // First row filled with zeros
    for X := 0 to Len2 do
      Result[0, X] := 0;

    for I := 1 to Len1 do
    begin
      for X := 1 to Len2 do
      begin
        if aValue1[I] = aValue2[X] then
          Result[I, X] := Result[I - 1, X - 1] + 1
        else
          Result[I, X] := Max(Result[I, X - 1], Result[I - 1, X]);
      end;
    end;
  end;

begin
  RtnCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    SetLength(LCSAlgAry, 0);
    // mod goes in reverse
    FlipStringLst := TStringList.Create;
    try
      for I := ModStr.Count - 1 downto 0 do
        FlipStringLst.Add(ModStr[I]);

      aStr1 := StringReplace(OrigStr.Text, #10, '', [rfReplaceAll]);
      aStr2 := StringReplace(FlipStringLst.Text, #10, '', [rfReplaceAll]);

    Finally
      FlipStringLst.Free;
    end;

    Len1 := Length(aStr1);
    Len2 := Length(aStr2);

    if EditMonitor.CopyMonitor.LCSToggle and
      ((Len1 <= EditMonitor.CopyMonitor.LCSCharLimit) and
      (Len2 <= EditMonitor.CopyMonitor.LCSCharLimit)) then
    begin

      LCSAlgAry := FillLCSAlgAry(aStr1, aStr2);
      FinalList := TList<TDiff>.Create;
      try
        Len1 := Length(aStr1);
        Len2 := Length(aStr2);
        while (Len1 <> 0) or (Len2 <> 0) do
        begin
          if (Len1 > 0) and (Len2 > 0) and (aStr1[Len1] = aStr2[Len2]) then
          begin
            CharDiff.Character := aStr1[Len1];
            CharDiff.CharStatus := '=';
            FinalList.Add(CharDiff);
            Dec(Len1);
            Dec(Len2);
          end
          else if (Len2 > 0) and
            ((Len1 = 0) or (LCSAlgAry[Len1, Len2 - 1] >= LCSAlgAry[Len1 - 1,
            Len2])) then
          begin
            CharDiff.Character := aStr2[Len2];
            CharDiff.CharStatus := '+';
            FinalList.Add(CharDiff);
            Dec(Len2);
          end
          else if (Len1 > 0) and
            ((Len2 = 0) or (LCSAlgAry[Len1, Len2 - 1] < LCSAlgAry[Len1 - 1,
            Len2])) then
          begin
            CharDiff.Character := aStr1[Len1];
            CharDiff.CharStatus := '-';
            FinalList.Add(CharDiff);
            Dec(Len1);
          end;
        end;

        SetLength(LCSAlgAry, 0);

        // build the return
        for I := FinalList.Count - 1 downto 0 do
        begin
          Diff := FinalList.Items[I];
          { if Diff.CharStatus = '+' then
            begin
            DestRich.SelAttributes.Color := clBlue;
            DestRich.SelText := Diff.Character;
            end
            else }
          if Diff.CharStatus = '-' then
          begin
            FInfoMessage.SelAttributes.Style :=
              EditMonitor.CopyMonitor.LCSTextStyle;
            DestRich.SelAttributes.Color :=
              EditMonitor.CopyMonitor.LCSTextColor;
            DestRich.SelText := Diff.Character;
          end
          else
          begin
            FInfoMessage.SelAttributes.Style := [];
            DestRich.SelAttributes.Color := clDefault;
            DestRich.SelText := Diff.Character;
          end;
        end;
      finally
        FinalList.Free;
      end;
    end
    else
    begin

      for I := 0 to OrigStr.Count - 1 do
        DestRich.Lines.Add(OrigStr[I]);
    end;
  finally
    Screen.Cursor := RtnCursor;
  end;

end;

procedure TCopyPasteDetails.HighLightInfoPanel(Color: TColor;
  Style: TFontStyles; ShowHighlight: Boolean; PasteText: String;
  ClearPrevHighLight: Boolean = true);
var
  CharPos, CharPos2, endChars, ResetMask: Integer;
  SearchOpts: TSearchTypes;
  Format: CHARFORMAT2;
  SearchString: string;
  isSelectionHidden: Boolean;

  Procedure CenterPasteText(PasteLine: Integer);
  Var
    TopLine, VisibleLines, FirstLine: Integer;
  begin
    FirstLine := TRichEdit(FMonitorObject)
      .Perform(EM_GETFIRSTVISIBLELINE, 0, 0);
    VisibleLines := round(TRichEdit(FMonitorObject).ClientHeight /
      Abs(TRichEdit(FMonitorObject).font.Height));

    if VisibleLines <= 1 then
      TopLine := PasteLine
    else
      TopLine := Max(PasteLine - round((VisibleLines / 2)) + 1, 0);

    if FirstLine <> TopLine then
      TRichEdit(FMonitorObject).Perform(EM_LINESCROLL, 0, TopLine - FirstLine);

  end;

begin
  if not Assigned(EditMonitor.CopyMonitor) then
    Exit;
  if not EditMonitor.CopyMonitor.Enabled then
    Exit;
  ResetMask := TRichEdit(FMonitorObject).Perform(EM_GETEVENTMASK, 0, 0);
  FMonitorObject.Perform(EM_SETEVENTMASK, 0, 0);
  FMonitorObject.LockDrawing;
  try
    // Clear out the variables
    CharPos := 0;
    SearchOpts := [];
    endChars := Length(TRichEdit(FMonitorObject).Text);

    if ClearPrevHighLight then
      pnlMessageExit(Self);

    SuspendRichUndo(TRichEdit(FMonitorObject), true);
    try
      repeat
        SearchString := StringReplace((PasteText), #10, '', [rfReplaceAll]);

        // find the text and save the position
        CharPos2 := TRichEdit(FMonitorObject).FindText(SearchString, CharPos,
          endChars, SearchOpts);
        CharPos := CharPos2 + 1;
        if CharPos = 0 then
          Break;
        FPasteCurPos := CharPos2;
        // Select the word
        TRichEdit(FMonitorObject).SelStart := CharPos2;
        TRichEdit(FMonitorObject).SelLength := Length(SearchString);

        // Set the font
        TRichEdit(FMonitorObject).SelAttributes.Style := Style;

        if ShowHighlight then
        begin
          // Set the background color
          FillChar(Format, SizeOf(Format), 0);
          Format.cbSize := SizeOf(Format);
          Format.dwMask := CFM_BACKCOLOR;
          Format.crBackColor := ColorToRGB(Color);
          TRichEdit(FMonitorObject).Perform(EM_SETCHARFORMAT, SCF_SELECTION,
            Longint(@Format));
// This TResponsiveGUI.ProcessMessages was allowing a note change in the middle of
// lbSelectorClick, which clears out the PasteText, causing access violations
// because lbSelectorClick was still processing PasteText data.  Fix was to
// move TResponsiveGUI.ProcessMessages to the bottom of lbSelectorClick
//        TResponsiveGUI.ProcessMessages;
        end;

      until CharPos = 0;

      isSelectionHidden := TRichEdit(FMonitorObject).HideSelection;
      try
        TRichEdit(FMonitorObject).HideSelection := False;
        TRichEdit(FMonitorObject).SelLength := 1;
        // Scroll to caret
        CenterPasteText(TRichEdit(FMonitorObject).Perform(EM_LINEFROMCHAR,
          TRichEdit(FMonitorObject).SelStart, 0));

      finally
        TRichEdit(FMonitorObject).HideSelection := isSelectionHidden;
      end;
      TRichEdit(FMonitorObject).SelLength := 0;

      if FNewShowing then
        TRichEdit(FMonitorObject).SelStart := TRichEdit(FMonitorObject).SelStart
          + Length(SearchString);

    finally
     SuspendRichUndo(TRichEdit(FMonitorObject), false);
    end;

  finally
    FMonitorObject.UnlockDrawing;
    FMonitorObject.Perform(EM_SETEVENTMASK, 0, ResetMask);
  end;
end;

constructor TCopyPasteDetails.Create(AOwner: TComponent);
var
  fLeftPnl, fRightPnl { , MainPanel } : TPanel;
  aLbl: TLabel;
begin
  inherited;

  With Self do
  begin
    Caption := '';
    Height := 100;
    BevelInner := bvRaised;
    BorderStyle := bsSingle;
    TabStop := False;
    ShowCaption := False;
    Visible := true;
    ParentFont := true;
  end;

  fTopPanel := TPanel.Create(Self);
  With fTopPanel do
  begin
    Name := 'PasteInfoTopPanel';
    Parent := Self;
    ShowCaption := False;
    align := altop;
    BevelOuter := bvNone;
    // AutoSize := true;
    Height := 20;
    ParentFont := true;
  end;

  FCollapseBtn := TCollapseBtn.Create(Self);
  with FCollapseBtn do
  begin
    SetSubComponent(true);
    Name := 'PasteInfoCollapseBtn';
    Parent := fTopPanel;
    align := alRight;
    Width := 17;
    Caption := 'Ú';
    font.Name := 'Wingdings';
    TabStop := False;
    ParentFont := true;
  end;

  aLbl := TLabel.Create(Self);
  With aLbl do
  begin
    Name := 'PasteInfoLabel';
    Parent := fTopPanel;
    align := alClient;
    Caption := 'Pasted Data';
    font.Style := [fsBold];
    ParentFont := true;
    aLbl.AutoSize := true;
  end;

  Self.Constraints.MinHeight := fTopPanel.Height + 10;

  fLeftPnl := TPanel.Create(Self);
  With fLeftPnl do
  begin
    Name := 'CPLftPnl';
    Parent := Self;
    ShowCaption := False;
    align := alLeft;
    BevelOuter := bvNone;
    Width := 117;
    Height := 20;
    Constraints.MinWidth := 40
  end;

  fRightPnl := TPanel.Create(Self);
  With fRightPnl do
  begin
    Name := 'CPRghtPnl';
    Parent := Self;
    ShowCaption := False;
    align := alClient;
    BevelOuter := bvNone;
    Width := 117;
    Height := 20;
  end;

  FCPSplitter := TSplitter.Create(Self);
  With FCPSplitter do
  begin
    Name := 'splHorz';
    Parent := Self;
    Width := 8;
    Left := 120;
    align := alLeft;
    Height := Parent.Height;
    AutoSnap := true;
    ResizeStyle := rsPattern;
    Cursor := crHSplit;
    Visible := true;
  end;

  FInfoSelector := TSelectorBox.Create(Self);
  With FInfoSelector do
  begin
    SetSubComponent(true);
    Name := 'PasteInfo';
    Parent := fLeftPnl;
    // Width := 117;
    align := alLeft;
    ItemHeight := 13;
    TabStop := true;
    AlignWithMargins := true;
  end;

  if fRecStatBtnVisible then
  begin
    fRecStatusBtn := TButton.Create(Self);
    with fRecStatusBtn do
    begin
      SetSubComponent(true);
      Name := 'CPRecStatusBtn';
      Parent := fLeftPnl;
      if fRecStatus = AuditNA then
        Caption := 'Start Audit'
      else if fRecStatus = AuditProc then
        Caption := 'Audit in progress'
      else if fRecStatus = AuditCom then
        Caption := 'Audit Complete';

      Hint := 'Update the status of the audit';
      align := alBottom;
      TabStop := true;
      AlignWithMargins := true;
      OnClick := AuditClick;
      Visible := False;
      ShowHint := true;
    end;
  end;

  FInfoMessage := ORExtensions.TRichEdit.Create(Self);
  With FInfoMessage do
  begin
    SetSubComponent(true);
    Name := 'PasteInfoMessage';
    Parent := fRightPnl;
    align := alClient;
    AlignWithMargins := true;
    ReadOnly := true;
    ScrollBars := ssBoth;
    TabStop := true;
    WantReturns := False;
    WordWrap := False;
    Text := '<-- Please select the desired paste date';
  end;
  FInfoSelector.LinkedRichEdit := FInfoMessage;

  fProgressBar := TProgressBar.Create(Self);
  with fProgressBar do
  begin
    SetSubComponent(true);
    Name := 'CPProgress';
    Parent := Self;
    align := alBottom;
    Visible := False;
  end;

  fEditMonitor := TCopyEditMonitor.Create(Self);
  fEditMonitor.SetSubComponent(true);
  fEditMonitor.VisualMessage := VisualMesageCenter;
  FInfoboxCollapsed := False;
  fEditMonitor.Name := 'EditorMonitor';
  FShowAllPaste := False;
  FNewShowing := False;
  fDefaultSelectAll := False;
  fParentForm := GetParentForm(Self);
end;

destructor TCopyPasteDetails.Destroy;
begin

  if (Assigned(FMonitorObject) and Assigned(fEditMonitor)) then
  begin
    if not(csDesigning in ComponentState) then
      FMonitorObject.WindowProc := FOurOrigWndProc;
    FMonitorObject := nil;
  end;
  inherited;
end;

procedure TCopyPasteDetails.DoExit;
begin
  if Assigned(EditMonitor.CopyMonitor) then
    if not EditMonitor.CopyMonitor.Enabled then
      Exit;
  inherited;
  pnlMessageExit(Self);
end;

procedure TCopyPasteDetails.Resize;
begin
  inherited;

  InfoPanelResize(Self);
  if not Assigned(fParentForm) then
    fParentForm := GetParentForm(Self, False);

  if FSyncSizes then
    if Assigned(fEditMonitor.CopyMonitor) then
      fEditMonitor.CopyMonitor.SyncSizes(Self);
end;

procedure TCopyPasteDetails.SetObjectToMonitor(ACopyObject
  : ORExtensions.TRichEdit);
begin
  FMonitorObject := nil;

  if Assigned(ACopyObject) then
  begin
    // Point richedit to monitor
    FMonitorObject := ACopyObject;
    if not(csDesigning in ComponentState) then
    begin
      FOurOrigWndProc := FMonitorObject.WindowProc;
      FMonitorObject.WindowProc := OurWndProc;
    end;
  end;
end;

procedure TCopyPasteDetails.SetShowAllPaste(const Value: Boolean);
begin
  if not Assigned(EditMonitor.CopyMonitor) then
    Exit;
  EditMonitor.CopyMonitor.CriticalSection.Enter;
  try
    FShowAllPaste := Value;
  finally
    EditMonitor.CopyMonitor.CriticalSection.Leave;
  end;
end;

procedure TCopyPasteDetails.FillPasteArray(SourceData: THashedStringList;
  Var UpdateRec: TPasteText);
type
  fGroupByArray = record
    IEN: Integer;
    MainArrayLocation: Integer;
    UpdateRecord: TPasteText;
  end;
var
  TotalPasted, I, X, NumLines, SubCnt { , StrtSub } : Integer;
  GroupByArray: Array of fGroupByArray;
  PastedString: TStringList;
  PrntNode: string;
  RecToUse: TPasteText;
  RecFound, KeepGoing: Boolean;

  function AddToExisitingGroup(ParentIEN, ThisRecIEN: String;
    var StrToSearchFor: TStringList): Boolean;
  var
    I: Integer;
    GrpRecToUse: TPasteText;
  begin
    Result := true;
    RecFound := False;
    for I := Low(GroupByArray) to High(GroupByArray) do
    begin
      if GroupByArray[I].IEN = StrToIntDef(ParentIEN, 0) then
      begin
        KeepGoing := true;
        // If the parent was found then ignore the group
        // Make sure the orverall is not visible (spaces are now ignored)
        { if GroupByArray[I].MainArrayLocation = -3 then
          KeepGoing := not UpdateRec.VisibleOnNote
          else
          KeepGoing := not EditMonitor.PasteText[GroupByArray[I].MainArrayLocation].VisibleOnNote;
        }

        if not KeepGoing then
        begin
          // Set our flag
          Result := False;
          Break;
        end
        else
        begin

          if GroupByArray[I].MainArrayLocation = -3 then
          begin
            GrpRecToUse := UpdateRec;
            RecFound := true;
          end
          else
          begin
            if (GroupByArray[I].MainArrayLocation > -1) and
              (GroupByArray[I].MainArrayLocation < Length(EditMonitor.PasteText)) then
            begin
            GrpRecToUse := EditMonitor.PasteText
              [GroupByArray[I].MainArrayLocation];
              RecFound := true;
          end;
          end;
          if RecFound then with GrpRecToUse do
          begin
            // First time, we need to add the main text to the GroupText
            if Length(GroupItems) = 0 then
            begin
              SetLength(GroupItems, Length(GroupItems) + 1);
              GroupItems[High(GroupItems)].GroupParent := true;
              GroupItems[High(GroupItems)].GroupText := TStringList.Create;
              GroupItems[High(GroupItems)].GroupText.Assign(PastedText);
              GroupItems[High(GroupItems)].ItemIEN :=
                StrToIntDef(ParentIEN, -1);
              SetLength(GroupItems[High(GroupItems)].HiglightLines, 0);
              GroupItems[High(GroupItems)].VisibleOnNote :=
                EditMonitor.LoadIdentLines(FMonitorObject, PastedText,
                GroupItems[High(GroupItems)].HiglightLines);
              PastedText.Clear; // ????
            end;
            // Add this text to the GroupText
            SetLength(GroupItems, Length(GroupItems) + 1);
            GroupItems[High(GroupItems)].GroupParent := False;
            GroupItems[High(GroupItems)].GroupText := TStringList.Create;
            GroupItems[High(GroupItems)].GroupText.Assign(StrToSearchFor);
            GroupItems[High(GroupItems)].ItemIEN := StrToIntDef(ThisRecIEN, -1);
            SetLength(GroupItems[High(GroupItems)].HiglightLines, 0);
            GroupItems[High(GroupItems)].VisibleOnNote :=
              EditMonitor.LoadIdentLines(FMonitorObject, StrToSearchFor,
              GroupItems[High(GroupItems)].HiglightLines);
            // Add this text to the PastedText
            PastedText.AddStrings(StrToSearchFor);
            // PastedText.Add(Trim(StrToSearchFor.Text));
            // Set our flag
            Result := False;
            Break;

          end;

        end;
      end;
    end;
    if RecFound then
    begin
      if UpdateRec.PasteDBID <> -3 then
        RecToUse := GrpRecToUse
      else
        EditMonitor.PasteText[GroupByArray[I].MainArrayLocation] := GrpRecToUse;
    end;
  end;

begin
  TotalPasted := StrToIntDef(SourceData.Values['(0,0)'], -1);
  If TotalPasted > -1 then
    EditMonitor.CopyMonitor.LogText('LOAD', 'Found ' + IntToStr(TotalPasted) +
      ' existing paste');

  // clear the array by default
  SetLength(GroupByArray, 0);
  PastedString := TStringList.Create;
  try
    for I := 1 to TotalPasted do
    begin
      PrntNode := SourceData.Values['(' + IntToStr(I) + ',0)'];
      NumLines := StrToIntDef(Piece(PrntNode, '^', 8), -1);
      PastedString.BeginUpdate;
      PastedString.Clear;
      for X := 1 to NumLines do
        PastedString.Add(SourceData.Values['(' + IntToStr(I) + ',' +
          IntToStr(X) + ')']);
      PastedString.EndUpdate;

      if AddToExisitingGroup(Piece(PrntNode, '^', 12), Piece(PrntNode, '^', 11),
        PastedString) then
      begin
        EditMonitor.CopyMonitor.LogText('LOAD', 'New Entry Found');

        if UpdateRec.PasteDBID <> -3 then
          RecToUse := UpdateRec
        else
        begin
          SetLength(EditMonitor.PasteText, Length(EditMonitor.PasteText) + 1);
          RecToUse := EditMonitor.PasteText[High(EditMonitor.PasteText)];
        end;

        SetLength(RecToUse.GroupItems, 0);

        // Add this to our group
        SetLength(GroupByArray, Length(GroupByArray) + 1);
        // If there is a parent id but we didnt add from above then we know its parent is missing
        if StrToIntDef(Piece(PrntNode, '^', 12), -1) <> -1 then
          GroupByArray[High(GroupByArray)].IEN :=
            StrToIntDef(Piece(PrntNode, '^', 12), -1)
        else
          GroupByArray[High(GroupByArray)].IEN :=
            StrToIntDef(Piece(PrntNode, '^', 11), -1);

        if UpdateRec.PasteDBID <> -3 then
        begin
          GroupByArray[High(GroupByArray)].MainArrayLocation := -3;
          GroupByArray[High(GroupByArray)].UpdateRecord := UpdateRec;
        end
        else
          GroupByArray[High(GroupByArray)].MainArrayLocation :=
            High(EditMonitor.PasteText);

        with RecToUse do
        begin
          DateTimeOfPaste := Piece(PrntNode, '^', 1);
          UserWhoPasted := Piece(PrntNode, '^', 2);
          CopiedFromLocation := Piece(PrntNode, '^', 3);
          CopiedFromDocument := Piece(PrntNode, '^', 4);
          CopiedFromAuthor := Piece(PrntNode, '^', 5);
          CopiedFromPatient := Piece(PrntNode, '^', 6);
          PastedPercentage := Piece(PrntNode, '^', 7);
          CopiedFromApplication := Piece(PrntNode, '^', 9);
          PasteDBID := StrToIntDef(Piece(PrntNode, '^', 11), -1);
          DoNotFind := Piece(PrntNode, '^', 13) = '2';
          PasteNoteIEN := StrToIntDef(Piece(PrntNode, '^', 14), -1);
          Status := PasteNA;

          // If its a group then pastedstrings would not be found
          if Length(GroupItems) = 0 then
          begin
            IF Piece(PrntNode, '^', 12) = '+' then
              VisibleOnNote := False
            else
              VisibleOnNote := EditMonitor.LoadIdentLines(FMonitorObject,
                PastedString, RecToUse.HiglightLines);
          end
          else
          begin
            VisibleOnNote := False;
            for X := Low(GroupItems) to High(GroupItems) do
            begin
              if GroupItems[X].GroupParent then
                Continue;
              VisibleOnNote := GroupItems[X].VisibleOnNote;
              if not VisibleOnNote then
                Break;
            end;
          end;
          IdentFired := true;
          VisibleOnList := (FShowAllPaste) or VisibleOnNote or DoNotFind;

          DateTimeOfOriginalDoc := Piece(PrntNode, '^', 10);
          PastedText := TStringList.Create;
          PastedText.BeginUpdate;
          PastedText.Assign(PastedString);
          PastedText.EndUpdate;

          // check for original copy
          SubCnt := StrToIntDef(SourceData.Values['(' + IntToStr(I) +
            ',0,0)'], 0);
          if SubCnt > 0 then
          begin
            OriginalText := TStringList.Create;
            OriginalText.BeginUpdate;
            for X := 1 to SubCnt do
              // OriginalText.Add(Piece(CopiedText.Strings[X], '=', 2));
              OriginalText.Add(SourceData.Values['(' + IntToStr(I) + ',0,' +
                IntToStr(X) + ')']);
            OriginalText.EndUpdate;
          end;

        end;

        EditMonitor.CopyMonitor.LogText('LOAD', 'Text found in note [' +
          PrntNode + ']');

        if UpdateRec.PasteDBID <> -3 then
        begin
          UpdateRec := RecToUse;
          if Length(UpdateRec.GroupItems) > 0 then
            // Setup the main record
            UpdateRec.VisibleOnNote := False;
          for X := Low(UpdateRec.GroupItems) to High(UpdateRec.GroupItems) do
          begin
            if UpdateRec.GroupItems[X].GroupParent then
              Continue;
            UpdateRec.VisibleOnNote := UpdateRec.GroupItems[X].VisibleOnNote;
            if not UpdateRec.VisibleOnNote then
              Break;
          end;
          UpdateRec.VisibleOnList := (FShowAllPaste) or
            UpdateRec.VisibleOnNote or UpdateRec.DoNotFind;
        end
        else
          EditMonitor.PasteText[High(EditMonitor.PasteText)] := RecToUse;
      end
      else
      begin
        // Need to update our record if it was grouped
        if UpdateRec.PasteDBID <> -3 then
        begin
          UpdateRec := RecToUse;
          if Length(UpdateRec.GroupItems) > 0 then
            // Setup the main record
            UpdateRec.VisibleOnNote := False;
          for X := Low(UpdateRec.GroupItems) to High(UpdateRec.GroupItems) do
          begin
            if UpdateRec.GroupItems[X].GroupParent then
              Continue;
            UpdateRec.VisibleOnNote := UpdateRec.GroupItems[X].VisibleOnNote;
            if not UpdateRec.VisibleOnNote then
              Break;
          end;
          UpdateRec.VisibleOnList := (FShowAllPaste) or
            UpdateRec.VisibleOnNote or UpdateRec.DoNotFind;
        end;
      end;
    end;

  finally
    PastedString.Free;
  end;

  SetLength(GroupByArray, 0);
end;

procedure TCopyPasteDetails.LoadPasteText();

var
  CopiedText: THashedStringList;
  ProcessLoad, AnyItemsVisible, BlwWrdCnt, Preloaded: Boolean;
  ClonedRichEdit: TRichEdit;
  I, X, Z: Integer;
  Dummy: TPasteText;

  function UpdatePasteText(PasteText: TStringList): TStrings;
  begin
    ClonedRichEdit.Text := PasteText.Text;
    Result := ClonedRichEdit.Lines;
  end;

  procedure CopyRicheditProperties(Dest, Source: TRichEdit);
  var
    ms: TMemoryStream;
    OldName: string;
    Rect: TRect;
  begin
    OldName := Source.Name;
    Source.Name := ''; // needed to avoid Name collision
    try
      ms := TMemoryStream.Create;
      try
        ms.WriteComponent(Source);
        ms.Position := 0;
        ms.ReadComponent(Dest);
      finally
        ms.Free;
      end;
    finally
      Source.Name := OldName;
    end;
    Dest.Visible := False;
    Dest.Parent := Source.Parent;

    Source.Perform(EM_GETRECT, 0, Longint(@Rect));
    Dest.Perform(EM_SETRECT, 0, Longint(@Rect));
  end;

  procedure LoadPreviousNewPaste();
  var
    I: Integer;
  begin

    for I := Low(EditMonitor.CopyMonitor.CPRSClipBoard)
      to High(EditMonitor.CopyMonitor.CPRSClipBoard) do
    begin
      if (EditMonitor.CopyMonitor.CPRSClipBoard[I].SaveForDocument) and
        (EditMonitor.CopyMonitor.CPRSClipBoard[I].PasteToIEN = EditMonitor.
        ItemIEN) then
      begin
        SetLength(EditMonitor.PasteText, Length(EditMonitor.PasteText) + 1);
        with EditMonitor.PasteText[High(EditMonitor.PasteText)] do
        begin
          DateTimeOfPaste := FloatToStr(DateTimeToFMDateTime(Now));
          Status := PasteNew;
          PastedText := TStringList.Create;
          PastedText.Assign(EditMonitor.CopyMonitor.CPRSClipBoard[I]
            .CopiedText);
          VisibleOnNote := EditMonitor.LoadIdentLines(FMonitorObject,
            PastedText, HiglightLines);
          VisibleOnList := (FShowAllPaste) or VisibleOnNote or DoNotFind;
        end;
      end;
    end;

  end;

  procedure LoadFindText(var outPasteList: THashedStringList);
  var
    I, TotalPasted, AddCnt, X, NumLines, FndTotalCnt, FndLineNum, Z: Integer;
    FillList, PastedString, NewItems, OrigText: TStringList;
    FillHashed: THashedStringList;
    PrntNode, ChldNode: String;
    Tmp: TCprsClipboard;
    Perc: Double;
    TimeTook: Int64;
  begin
    TotalPasted := StrToIntDef(outPasteList.Values['(0,0)'], -1);
    If TotalPasted > -1 then
    begin
      PastedString := TStringList.Create;
      FillList := TStringList.Create;
      NewItems := TStringList.Create;
      FillHashed := THashedStringList.Create;
      try
        AddCnt := 0;
        for I := 1 to TotalPasted do
        begin
          FillList.Clear;
          PrntNode := outPasteList.Values['(' + IntToStr(I) + ',0)'];
          // this is not a parent and not 100%
          if (Trim(Piece(PrntNode, '^', 12)) = '') and
            ((Piece(PrntNode, '^', 7) <> '100') or
            (Piece(PrntNode, '^', 13) = '1') and
            (Piece(PrntNode, '^', 13) <> '2')) then
          begin
            // Grab the text and pass it into cpCompare
            NumLines := StrToIntDef(Piece(PrntNode, '^', 8), -1);
            PastedString.BeginUpdate;
            PastedString.Clear;
            for X := 1 to NumLines do
              PastedString.Add(outPasteList.Values['(' + IntToStr(I) + ',' +
                IntToStr(X) + ')']);

            // check for original copy
            NumLines :=
              StrToIntDef(outPasteList.Values['(' + IntToStr(I) + ',0,0)'], 0);
            if NumLines > 0 then
            begin
              OrigText := TStringList.Create;
              OrigText.BeginUpdate;
              for X := 1 to NumLines do
                // OriginalText.Add(Piece(CopiedText.Strings[X], '=', 2));
                OrigText.Add(outPasteList.Values['(' + IntToStr(I) + ',0,' +
                  IntToStr(X) + ')']);
              OrigText.EndUpdate;
            end;

            PastedString.EndUpdate;
            Tmp.CopiedText := PastedString;
            if Assigned(OrigText) then
              Tmp.OriginalText := OrigText;

            CPCOMPARE(Tmp, FillList, Perc, TimeTook);

            if Assigned(OrigText) then
            begin
              FreeAndNil(OrigText);
              Tmp.OriginalText := nil;
            end;

            if FillList.Count > 1 then
            begin
              FillHashed.Assign(FillList);
              // Update the zero node
              SetPiece(PrntNode, '^', 7, formatfloat('##.##', Perc));
              SetPiece(PrntNode, '^', 12, '+');
              outPasteList.Values['(' + IntToStr(I) + ',0)'] := PrntNode;
              FndTotalCnt := StrToIntDef(FillHashed.Values['(0)'], -1);
              // Loop through each return and format for the save
              for X := 1 to FndTotalCnt do
              begin
                // Inc the add counter
                Inc(AddCnt);

                FndLineNum :=
                  StrToIntDef(FillHashed.Values['(' + IntToStr(X) + ',0)'], -1);
                ChldNode := PrntNode;
                SetPiece(ChldNode, '^', 12, Piece(PrntNode, '^', 11));
                SetPiece(ChldNode, '^', 8, IntToStr(FndLineNum));
                NewItems.Add('(' + IntToStr(TotalPasted + AddCnt) + ',0)=' +
                  ChldNode);
                for Z := 1 to FndLineNum do
                begin
                  NewItems.Add('(' + IntToStr(TotalPasted + AddCnt) + ',' +
                    IntToStr(Z) + ')=' + FillHashed.Values['(' + IntToStr(X) +
                    ',' + IntToStr(Z) + ')']);
                end;

              end;
            end
            else if Perc = -3 then
            begin
              // Took to long so we need to indicate as such
              SetPiece(PrntNode, '^', 13, '2');
              outPasteList.Values['(' + IntToStr(I) + ',0)'] := PrntNode;
            end;

          end;
        end;
        if NewItems.Count > 1 then
        begin
          outPasteList.BeginUpdate;
          outPasteList.AddStrings(NewItems);
          outPasteList.Values['(0,0)'] := IntToStr(TotalPasted + AddCnt);
          outPasteList.EndUpdate;
        end;

      finally
        FillHashed.Free;
        NewItems.Free;
        FillList.Free;
        PastedString.Free;
      end;
    end;

  end;

begin
  if not Assigned(EditMonitor.CopyMonitor) then
    Exit;
  if not EditMonitor.CopyMonitor.Enabled then
    Exit;

  EditMonitor.CopyMonitor.LoadTheProperties;

  // Only display this information on a richedit
  If (FMonitorObject is TRichEdit) then
  begin
    CopiedText := THashedStringList.Create();
    try
      ProcessLoad := true;
      Preloaded := False;
      if Assigned(EditMonitor.LoadPastedText) then
      begin
        EditMonitor.StartStopWatch;
        try
          EditMonitor.LoadPastedText(Self, CopiedText, ProcessLoad, Preloaded);
        finally
          If EditMonitor.StopStopWatch then
            EditMonitor.CopyMonitor.LogText('METRIC',
              'Load Paste RPC: ' + EditMonitor.StopWatch.Elapsed);
        end;
      end;

      if (not EditMonitor.CopyMonitor.DisplayPaste) and (not ShowAllPaste) then
      begin
        if Assigned(EditMonitor.VisualMessage) then
          EditMonitor.VisualMessage(Self, Hide_Panel, [true]);
        Exit;
      end;

      AnyItemsVisible := False;
      if ProcessLoad then
      begin
        StatusText('Loading Copy/Paste tracking');
        try
          if not Preloaded then
          begin
            EditMonitor.ClearPasteArray;
            if CopiedText.Count > 0 then
            begin
              EditMonitor.StartStopWatch;
              TRY

                // This is just used to pass into the function. -3 is invlaid and tells the funtion to create the array
                Dummy.PasteDBID := -3;

                { DONE: Call Find text for any records that dont have "finds" }
                LoadFindText(CopiedText);

                // Call out to fill the Paste array
                FillPasteArray(CopiedText, Dummy);

                // load the paste that have not saved. this clears when a new document is created or saved
                // if Length(EditMonitor.PasteText) > 0 then
                // begin
                LoadPreviousNewPaste;

                EditMonitor.CopyMonitor.LogText('DEBUG', EditMonitor.PasteText);

                // end;
                // Final update for isvisible
              finally
                If EditMonitor.StopStopWatch then
                  EditMonitor.CopyMonitor.LogText('METRIC',
                    'Build Paste Internal: ' + EditMonitor.StopWatch.Elapsed);
              end;
            end;
          end;

          for I := Low(EditMonitor.PasteText) to High(EditMonitor.PasteText) do
          begin
            BlwWrdCnt := False;
            with EditMonitor.PasteText[I] do
            begin
              if Length(GroupItems) > 0 then
              begin
                // Setup the main record
                VisibleOnNote := False;
                for X := Low(GroupItems) to High(GroupItems) do
                begin
                  if GroupItems[X].GroupParent then
                    Continue;
                  VisibleOnNote := GroupItems[X].VisibleOnNote;

                  if VisibleOnNote then
                  begin
                    // Look to see if the whole text was found
                    for Z := Low(HiglightLines) to High(HiglightLines) do
                    begin
                      BlwWrdCnt := not HiglightLines[Z].AboveWrdCnt;
                      if BlwWrdCnt then
                        Break;
                    end;
                  end;

                  if (not VisibleOnNote) or BlwWrdCnt then
                    Break;

                end;
              end
              else
              begin
                // Look to see if the whole text was found
                for X := Low(HiglightLines) to High(HiglightLines) do
                begin
                  BlwWrdCnt := not HiglightLines[X].AboveWrdCnt;
                  if BlwWrdCnt then
                    Break;
                end;
              end;

              VisibleOnList := (FShowAllPaste) or VisibleOnNote or DoNotFind;

              if not AnyItemsVisible then
                AnyItemsVisible := VisibleOnList;
            end;
          end;

          if AnyItemsVisible then
          begin
            If ScreenReaderSystemActive then
              GetScreenReader.Speak('Pasted data exist');
          end;

          Self.Repaint;
        Finally
          StatusText('');
        end;
      end
      else
        EditMonitor.ClearPasteArray;

      if Assigned(EditMonitor.VisualMessage) then
      begin
        if fDefaultSelectAll then
          EditMonitor.VisualMessage(Self, ShowHighlight,
            [AnyItemsVisible, true])
        else
          EditMonitor.VisualMessage(Self, Show_Panel, [AnyItemsVisible]);
      end;
      fEditMonitor.ReadyForLoadTransfer := true;
    finally
      CopiedText.Free;
    end;
  end;
end;

procedure TCopyPasteDetails.PreLoadPasteRecs(LoadFrom: TStringList);
var
  TotalPaste, SubCnt, FndCnt, CurrCnt, ParentCnt, I, X, Y, PRIDX: Integer;
  OurHasLst, OutHash: THashedStringList;
  TheFillList: TStringList;
  TmpStr: String;
  RtnCursor: Integer;
begin
  RtnCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    OurHasLst := THashedStringList.Create;
    OutHash := THashedStringList.Create;
    TheFillList := TStringList.Create;
    try
      // Assign over to a hashed stringlist
      OurHasLst.Assign(LoadFrom);

      // Prefill the total (might change due to the find code)
      TotalPaste := StrToIntDef(OurHasLst.Values['TotalToSave'], -1);

      // Loop through all the paste
      for I := 1 to TotalPaste do
      begin
        TheFillList.Clear;
        CurrCnt := 1;

        // Grab all the "Paste" lines
        SubCnt := StrToIntDef(OurHasLst.Values[IntToStr(I) + ',-1'], -1);
        // Add the paste text
        for X := 0 to SubCnt do
          TheFillList.Add('(' + IntToStr(CurrCnt) + ',' + IntToStr(X) + ')=' +
            OurHasLst.Values[IntToStr(I) + ',' + IntToStr(X)]);

        { TODO -ochris Bell : RELOAD THE ORIGINAL IF SENT }
        // Add the original copy text
        SubCnt := StrToIntDef(Piece(OurHasLst.Values[IntToStr(I) + ',Copy,-1'],
          '^', 1), -1);
        for X := 1 to SubCnt do
          TheFillList.Add('(' + IntToStr(CurrCnt) + ',0,' + IntToStr(X) + ')=' +
            OurHasLst.Values[IntToStr(I) + ',Copy,' + IntToStr(X)]);

        // Grab the current as our parent so we know about it
        ParentCnt := I;

        // Look for the "Find" data
        FndCnt := StrToIntDef
          (Piece(OurHasLst.Values[IntToStr(ParentCnt) + ',Paste,-1'],
          '^', 1), 0);

        // If there are "children" then we need to add the "+" to the parent
        if FndCnt > 0 then
        begin
          TmpStr := TheFillList.Values['(' + IntToStr(CurrCnt) + ',0)'];
          SetPiece(TmpStr, '^', 12, '+');
          TheFillList.Values['(' + IntToStr(CurrCnt) + ',0)'] := TmpStr
        end;

        // add the find text as new sections with ID
        for X := 1 to FndCnt do
        begin
          Inc(CurrCnt);
          SubCnt := StrToIntDef(OurHasLst.Values[IntToStr(ParentCnt) + ',Paste,'
            + IntToStr(X) + ',-1'], 0);
          TmpStr := OurHasLst.Values[IntToStr(ParentCnt) + ',0'];
          SetPiece(TmpStr, '^', 12, Piece(TmpStr, '^', 11));
          SetPiece(TmpStr, '^', 8, IntToStr(SubCnt));
          TheFillList.Add('(' + IntToStr(CurrCnt) + ',0)=' + TmpStr);
          for Y := 1 to SubCnt do
            TheFillList.Add('(' + IntToStr(CurrCnt) + ',' + IntToStr(Y) + ')=' +
              OurHasLst.Values[IntToStr(ParentCnt) + ',Paste,' + IntToStr(X) +
              ',' + IntToStr(Y)]);

        end;
        TheFillList.Add('(0,0)=' + IntToStr(CurrCnt));

        PRIDX := StrToIntDef(OurHasLst.Values[IntToStr(I) + ',ARRYIDX'], -1);
        if (PRIDX > -1) and (PRIDX < Length(EditMonitor.PasteText)) then
        begin
          OutHash.Clear;
          OutHash.Assign(TheFillList);

          FillPasteArray(OutHash, EditMonitor.PasteText[PRIDX]);
        end;

      end;

      if Assigned(EditMonitor.VisualMessage) then
      begin
        if fDefaultSelectAll then
          EditMonitor.VisualMessage(Self, ShowHighlight, [true, true])
        else
          EditMonitor.VisualMessage(Self, Show_Panel, [true]);
      end;

    finally
      TheFillList.Free;
      OutHash.Free;
      OurHasLst.Free;
    end;
  finally
    Screen.Cursor := RtnCursor;
  end;
end;

procedure TCopyPasteDetails.OurWndProc(var Message: TMessage);
var
  ShiftState: TShiftState;
  FireMessage, Tracked: Boolean;
  CopiedText: string;

  procedure HideCurrentHighlight();
  begin
    if FNewShowing then
    begin
      pnlMessageExit(Self);
      FNewShowing := False;
    end;
  end;

  function PerformPaste(EditMonitorObj: TCopyEditMonitor;
    TheEdit: TCustomEdit): Boolean;
  var
    ClpInfo: tClipInfo;
  begin
    Result := False;
    HideCurrentHighlight;
    if Clipboard.HasFormat(CF_TEXT) then
    begin
      ClpInfo := EditMonitor.CopyMonitor.GetClipSource;
      if ClpInfo.AppName <> INVALID_APP_NAME then
        Result := EditMonitorObj.PasteToMonitor(Self, TheEdit, true, ClpInfo);
    end;
  end;

  function PerformCopyCut(EditMonitorObj: TCopyEditMonitor;
    TheEdit: TCustomEdit; CMsg: Cardinal; var Monitored: boolean): Boolean;
  begin
    HideCurrentHighlight;
    Monitored := true;
    Result := EditMonitorObj.CopyToMonitor(TheEdit, Monitored, CMsg);
  end;

  procedure AfterCopyCut(EditMonitorObj: TCopyEditMonitor; _CopiedText: string);
  begin
    EditMonitorObj.CopyMonitor.CopyToCopyPasteClipboard(_CopiedText,
      EditMonitorObj.RelatedPackage, EditMonitorObj.ItemIEN);
  end;

  Procedure UpdateFont(TheEdit: TCustomEdit);
  var
    RtnPos: Integer;
  begin
    if Self.Visible and (FInfoSelector.ItemIndex <> -1) then
    begin
      if TheEdit is TRichEdit then
      begin
        TRichEdit(TheEdit).Lines.BeginUpdate;
        try
          RtnPos := TheEdit.SelStart;
          TheEdit.SelStart := 0;
          TheEdit.SelLength := Length(TheEdit.Text);
          TRichEdit(TheEdit).SelAttributes.Size := TRichEdit(TheEdit).font.Size;
          TheEdit.Repaint;
          TheEdit.SelStart := RtnPos
        finally
          TRichEdit(TheEdit).Lines.EndUpdate;
        end;
      end;
    end;
  end;

begin
  CopiedText := '';
  FireMessage := true;
  if Assigned(EditMonitor.CopyMonitor) then
  begin
    if EditMonitor.CopyMonitor.Enabled then
    begin
      case Message.Msg of
        WM_PASTE:
          begin
            FireMessage := not PerformPaste(EditMonitor, FMonitorObject);
          end;
        WM_COPY:
          begin
            if FMonitorObject is TCustomEdit then
              CopiedText := TCustomEdit(FMonitorObject).SelText;
            FireMessage := PerformCopyCut(EditMonitor, FMonitorObject,
              Message.Msg, Tracked);
          end;
        WM_CUT:
          begin
            if FMonitorObject is TCustomEdit then
              CopiedText := TCustomEdit(FMonitorObject).SelText;
            FireMessage := PerformCopyCut(EditMonitor, FMonitorObject,
              Message.Msg, Tracked);
          end;
        WM_KEYDOWN:
          begin
           // if (FMonitorObject is TRichEdit) then
           // begin
              ShiftState := KeyDataToShiftState(Message.WParam);
              if (ssCtrl in ShiftState) then
              begin
                if (Message.WParam = Ord('V')) then
                begin
                  FireMessage := not PerformPaste(EditMonitor, FMonitorObject);
                end
                else if (Message.WParam = Ord('C')) then
                begin
                  if FMonitorObject is TCustomEdit then
                    CopiedText := TCustomEdit(FMonitorObject).SelText;
                  FireMessage := PerformCopyCut(EditMonitor, FMonitorObject,
                    Message.Msg, Tracked);
                end
                else if (Message.WParam = Ord('X')) then
                begin
                  if FMonitorObject is TCustomEdit then
                    CopiedText := TCustomEdit(FMonitorObject).SelText;
                  FireMessage := PerformCopyCut(EditMonitor, FMonitorObject,
                   WM_CUT, Tracked);// Message.Msg);
                end
                else if (Message.WParam = VK_INSERT) then
                begin
                  FireMessage := not PerformPaste(EditMonitor, FMonitorObject);
                end;
              end
              else if (ssShift in ShiftState) then
              begin
                if (Message.WParam = VK_INSERT) then
                begin
                  FireMessage := not PerformPaste(EditMonitor, FMonitorObject);
                end;
              end;

           // end;
            HideCurrentHighlight;
          end;
      end;
    end;
  end;
  if FireMessage and Assigned(FOurOrigWndProc) then
    FOurOrigWndProc(Message);

  case Message.Msg of
    CM_FONTCHANGED:
      begin
        UpdateFont(FMonitorObject);
      end;
    WM_KEYDOWN: begin
      if Tracked and (trim(CopiedText) <> '') then
      begin
        ShiftState := KeyDataToShiftState(Message.WParam);
        if (ssCtrl in ShiftState) then
        begin
          if (Message.WParam = Ord('C')) or (Message.WParam = Ord('X')) then
            AfterCopyCut(EditMonitor, CopiedText);
        end;
      end;
    end;
    WM_COPY or WM_CUT: begin
      if Tracked and (trim(CopiedText) <> '') then
       AfterCopyCut(EditMonitor, CopiedText);
    end;
  end;
end;

procedure TCopyPasteDetails.SaveTheMonitor(ItemID: Integer);
begin
  if ItemID <= 0 then
    Exit;
  if not Assigned(EditMonitor.CopyMonitor) then
    Exit;
  if not EditMonitor.CopyMonitor.Enabled then
    Exit;
  fEditMonitor.SaveTheMonitor(Self, ItemID);
end;

procedure TCopyPasteDetails.CheckForModifiedPaste(var SaveList: TStringList);
var
  I, X, SaveCnt: Integer;
  NeedsReSaved: Boolean;

  procedure FormatResult(InfoRecord: TPasteText; DBID: Integer;
    PasteText: TStringList);
  var
    X, Z, FndTotalCnt, FndLineNum: Integer;
    Tmp: TCprsClipboard;
    FillList: TStringList;
    FillHashed: THashedStringList;
    Perc: Double;
    TimeTook: Int64;
    PrntNode: String;
  begin
    FillList := TStringList.Create;
    FillHashed := THashedStringList.Create;
    try
      Inc(SaveCnt);

      SaveList.Add(IntToStr(SaveCnt) + ',0=' +
        IntToStr(EditMonitor.CopyMonitor.UserDuz) + '^' +
        InfoRecord.DateTimeOfPaste + '^' + IntToStr(EditMonitor.ItemIEN) + ';' +
        EditMonitor.RelatedPackage + '^' + Piece(InfoRecord.CopiedFromLocation,
        ';', 1) + ';' + Piece(InfoRecord.CopiedFromLocation, ';', 2) + '^' +
        InfoRecord.PastedPercentage + '^' + InfoRecord.CopiedFromApplication +
        '^' + IntToStr(DBID));

      // Line Count (w/out OUR line breaks for size - code below)

      BreakUpLongLines(SaveList, IntToStr(SaveCnt), PasteText,
        EditMonitor.CopyMonitor.BreakUpLimit);

      // Send in  the original text if needed
      If Assigned(InfoRecord.OriginalText) then
      begin
        SaveList.Add(IntToStr(SaveCnt) + ',Copy,-1=' +
          IntToStr(InfoRecord.OriginalText.Count));
        BreakUpLongLines(SaveList, IntToStr(SaveCnt) + ',COPY,0',
          InfoRecord.OriginalText, EditMonitor.CopyMonitor.BreakUpLimit);
      end;

      Tmp.CopiedText := PasteText;

      if Assigned(InfoRecord.OriginalText) then
        Tmp.OriginalText := InfoRecord.OriginalText;

      CPCOMPARE(Tmp, FillList, Perc, TimeTook);

      if ((Perc <> 100) and (Perc <> -3)) or
        ((Perc = 100) and (StrToIntDef(FillList.Values['(0)'], -1) > 1)) then
      begin
        FillHashed.Assign(FillList);
        // Get the total number of finds
        FndTotalCnt := StrToIntDef(FillHashed.Values['(0)'], -1);
        SaveList.Add(IntToStr(SaveCnt) + ',Paste,-1=' + IntToStr(FndTotalCnt) +
          '^' + IntToStr(TimeTook));

        PrntNode := SaveList.Values[IntToStr(SaveCnt) + ',0'];
        SetPiece(PrntNode, '^', 5, formatfloat('##.##', Perc));

        // If 100% then we need to force the find text
        if Perc = 100 then
          SetPiece(PrntNode, '^', 8, '1');

        SaveList.Values[IntToStr(SaveCnt) + ',0'] := PrntNode;
        // SaveList.Values[IntToStr(SaveCnt) +',0'] := SaveList.Values[IntToStr(SaveCnt) +',0'] +'^'+formatfloat('##.##', Perc);

        // Loop through each return and format for the save
        for X := 1 to FndTotalCnt do
        begin
          FndLineNum :=
            StrToIntDef(FillHashed.Values['(' + IntToStr(X) + ',0)'], -1);
          // Reuse
          FillList.Clear;
          for Z := 1 to FndLineNum do
          begin
            FillList.Add(FillHashed.Values['(' + IntToStr(X) + ',' +
              IntToStr(Z) + ')']);
            // SaveList.Add(IntToStr(SaveCnt) + ',Paste,'+IntToStr(x)+','+IntToStr(Z)+')=' +
            // FillHashed.Values['(' + IntToStr(X) + ',' + IntToStr(Z) + ')'] );
          end;
          BreakUpLongLines(SaveList, IntToStr(SaveCnt) + ',Paste,' +
            IntToStr(X), FillList, EditMonitor.CopyMonitor.BreakUpLimit);
        end;
      end
      else if (Perc = -3) then
      begin
        PrntNode := SaveList.Values[IntToStr(SaveCnt) + ',0'];
        SetPiece(PrntNode, '^', 8, '2');
        SaveList.Values[IntToStr(SaveCnt) + ',0'] := PrntNode;
      end;

    finally
      FillHashed.Free;
      FillList.Free;
    end;

  end;

  function IsTextVisible(HigRec: Array of tHighlightRecord): Boolean;
  var
    I, LastSrchPos: Integer;
    AllFound: Boolean;
  begin
    AllFound := true;
    // Check for highlight records
    LastSrchPos := 0;
    for I := Low(HigRec) to High(HigRec) do
    begin
      if EditMonitor.CopyMonitor.WordCount(HigRec[I].LineToHighlight) > 2 then
      begin
        LastSrchPos := TRichEdit(FMonitorObject)
          .FindText(HigRec[I].LineToHighlight, LastSrchPos,
          Length(TRichEdit(FMonitorObject).Text), []);

        if LastSrchPos = -1 then
        begin
          // If one line greater than 2 words doesnt match the whole thing doesnt
          AllFound := False;
          Break;
        end
        else
          AllFound := true;
      end;
    end;
    Result := AllFound;

  end;

begin
  { DONE -oChris Bell : Check if the formated text matches and if not then re-find }
  if not Assigned(EditMonitor.CopyMonitor) then
    Exit;
  if not EditMonitor.CopyMonitor.Enabled then
    Exit;
  // now check for modified text
  EditMonitor.StartStopWatch;
  try
    SaveCnt := StrToIntDef(SaveList.Values['TotalToSave'], -1);

    // Send back all paste because we can not determine the orignal text modifications.
    // Edit of an edit to text that was left off
    { for I := Low(fEditMonitor.PasteText) to High(fEditMonitor.PasteText) do
      begin

      // saftey net
      {  if fEditMonitor.PasteText[I].PasteDBID = -1 then
      Continue;

      // check the main record (could not have groups)
      //  FormatResult(fEditMonitor.PasteText[I],
      //    fEditMonitor.PasteText[I].PasteDBID,
      //    fEditMonitor.PasteText[I].PastedText);
      end; }

    for I := Low(fEditMonitor.PasteText) to High(fEditMonitor.PasteText) do
    begin
      NeedsReSaved := False;
      // saftey net
      if fEditMonitor.PasteText[I].PasteDBID = -1 then
        Continue;

      // Should only happen with addendums (parent/child paste display)
      if (fEditMonitor.PasteText[I].PasteNoteIEN <> fEditMonitor.ItemIEN) and
        (fEditMonitor.PasteText[I].PasteNoteIEN <> -1) then
        Continue;

      if Length(fEditMonitor.PasteText[I].GroupItems) > 0 then
      begin
        with fEditMonitor.PasteText[I] do
        begin
          // If group item then check each group else check main entry
          for X := Low(GroupItems) to High(GroupItems) do
          begin
            if GroupItems[X].GroupParent then
              Continue;
            // Check if the goup item still exist on the note (if it did at load)
            if GroupItems[X].VisibleOnNote then
            begin
              if not IsTextVisible(GroupItems[X].HiglightLines) then
              begin
                NeedsReSaved := true;
                Break;
              end;
              // FormatResult(fEditMonitor.PasteText[I], GroupItems[X].ItemIEN,
              // GroupItems[X].GroupText);
            end;
          end;
        end;
      end
      else
      begin

        // check the main record (could not have groups)
        if fEditMonitor.PasteText[I].VisibleOnNote then
          if not IsTextVisible(fEditMonitor.PasteText[I].HiglightLines) then
            NeedsReSaved := true;
        { FormatResult(fEditMonitor.PasteText[I],
          fEditMonitor.PasteText[I].PasteDBID,
          fEditMonitor.PasteText[I].PastedText); }
      end;

      if NeedsReSaved then
      begin
        fEditMonitor.PasteText[I].Status := PasteModify;

        FormatResult(fEditMonitor.PasteText[I],
          fEditMonitor.PasteText[I].PasteDBID,
          fEditMonitor.PasteText[I].PastedText);
        SaveList.Add(IntToStr(SaveCnt) + ',ARRYIDX=' + IntToStr(I));
      end;

    end;

    SaveList.Values['TotalToSave'] := IntToStr(SaveCnt);

    EditMonitor.CopyMonitor.LogText('SAVE', 'Edited Records ' +
      IntToStr(SaveCnt) + ' Items');
  finally
    If EditMonitor.StopStopWatch then
      EditMonitor.CopyMonitor.LogText('METRIC', 'Check modified build: ' +
        EditMonitor.StopWatch.Elapsed);
  end;
end;

procedure TCopyPasteDetails.AuditClick(Sender: TObject);
{ const
  WarnMsg = 'Warning this process may take some time to run. You will be analyzing %s record(s). By clicking ''OK'' you will have to wait for these record to process.';
  var
  WrnMsg, IEN2Use, Package2Use: String;
  LoopTotal, I: Integer;
  SndLst, RtnLst: TStringList;
  RtnHash: THashedStringList; }
begin
  if not Assigned(EditMonitor.CopyMonitor) then
    Exit;
  if not EditMonitor.CopyMonitor.Enabled then
    Exit;
  if not Assigned(FOnAnalyze) then
    Exit;

  if fRecStatus = AuditNA then
  begin
    ShowMessage('Putting audit in process mode');
    // Make RPC call here

    // Update the status
    fRecStatus := AuditProc;

    // Update the caption on the button
    fRecStatusBtn.Caption := 'Audit in progress'
  end
  else if fRecStatus = AuditProc then
  begin
    ShowMessage('Putting audit in complete mode');
    // Make RPC call here

    // Update the status
    fRecStatus := AuditProc;

    // Update the caption on the button
    fRecStatusBtn.Caption := 'Audit Complete';
  end
  else if fRecStatus = AuditCom then
  begin
    ShowMessage('Putting audit in NA mode');
    // Make RPC call here

    // Update the status
    fRecStatus := AuditProc;

    // Update the caption on the button
    fRecStatusBtn.Caption := 'Start Audit'
  end;

  { LoopTotal := 0;
    for I := Low(EditMonitor.PasteText) to High(EditMonitor.PasteText) do
    if not EditMonitor.PasteText[I].Analyzed then
    Inc(LoopTotal);

    if LoopTotal > 0 then
    begin
    WrnMsg := Format(WarnMsg, [IntToStr(LoopTotal)]);
    if MessageDlg(WrnMsg, mtWarning, [mbOK, mbCancel], -1) = mrOk then
    begin
    Screen.Cursor := crHourGlass;
    try
    // Loop through each item and process the info
    SndLst := TStringList.Create;
    try
    RtnLst := TStringList.Create;
    try

    fProgressBar.Position := 0;
    fProgressBar.Max := LoopTotal + 1;
    fProgressBar.Visible := true;
    Self.Repaint;
    for I := Low(EditMonitor.PasteText)
    to High(EditMonitor.PasteText) do
    begin
    if not EditMonitor.PasteText[I].Analyzed then
    begin
    // process this record
    // Call RPC
    SndLst.Clear;

    IEN2Use :=
    Piece(EditMonitor.PasteText[I].CopiedFromLocation, ';', 1);
    Package2Use :=
    Piece(EditMonitor.PasteText[I].CopiedFromLocation, ';', 2);

    SndLst.Add('1,0=' + IntToStr(EditMonitor.FCopyMonitor.UserDuz) +
    '^' + EditMonitor.PasteText[I].DateTimeOfPaste + '^' +
    IntToStr(EditMonitor.ItemIEN) + ';' +
    EditMonitor.RelatedPackage + '^' + IEN2Use + ';' + Package2Use
    + '^' + EditMonitor.PasteText[I].PastedPercentage + '^' +
    EditMonitor.FCopyMonitor.MonitoringPackage + '^' +
    EditMonitor.PasteText[I].CopiedFromApplication + '^' +
    IntToStr(EditMonitor.PasteText[I].PasteDBID));

    // Line Count (w/out OUR line breaks for size - code below)
    BreakUpLongLines(SndLst, '1',
    EditMonitor.PasteText[I].PastedText,
    EditMonitor.FCopyMonitor.BreakUpLimit);

    FOnAnalyze(Self, SndLst, RtnLst);

    // Update the record and run the ident code
    if RtnLst.Count > 1 then
    begin
    if RtnLst.Strings[0] <> '-1' then
    begin
    RtnHash := THashedStringList.Create;
    try
    RtnHash.Assign(RtnLst);
    FillPasteArray(RtnHash, EditMonitor.PasteText[I]);
    finally
    RtnHash.Free;
    end;
    end;
    end;

    // Update the progress bar
    fProgressBar.Position := fProgressBar.Position + 1;

    end;
    end;
    fProgressBar.Visible := false;
    fProgressBar.Position := 0;
    fAnalyzeBtn.Visible := false;
    lbSelectorClick(FInfoSelector);
    finally
    RtnLst.Free;
    end;
    finally
    SndLst.Free;
    end;
    finally
    Screen.Cursor := crDefault;
    end;

    end;
    end; }
end;

// START SAVE CODE HERE

function TCopyPasteDetails.CharLookup(LineNum: Integer;
  StartCheck: Boolean = False; EndCheck: Boolean = False): Boolean;
var
  I, tempLine, HighLoop, LowLoop: Integer;
  LoopBool, LineGapFnd: Boolean;
begin
  Result := False;

  if (Length(CPFoundRecs) <> 0) and (StartCheck or EndCheck) then
  begin
    tempLine := LineNum;
    LoopBool := False;
    LineGapFnd := False;
    HighLoop := -1;
    LowLoop := -1;

    // Lookup the High and Low
    for I := Low(CPFoundRecs) to High(CPFoundRecs) do
    begin
      if LowLoop = -1 then
        LowLoop := CPFoundRecs[I].NoteLine;
      if HighLoop = -1 then
        HighLoop := CPFoundRecs[I].NoteLine;

      if CPFoundRecs[I].NoteLine < LowLoop then
        LowLoop := CPFoundRecs[I].NoteLine;

      if CPFoundRecs[I].NoteLine > HighLoop then
        HighLoop := CPFoundRecs[I].NoteLine;
    end;

    // Look back for a gap of the end char
    if StartCheck then
    begin
      while (not LoopBool) and (not LineGapFnd) and (tempLine >= LowLoop) do
      begin
        Dec(tempLine);
        LineGapFnd := true;

        for I := High(CPFoundRecs) downto Low(CPFoundRecs) do
        begin
          if CPFoundRecs[I].NoteLine = tempLine then
          begin
            LineGapFnd := False;
            if CPFoundRecs[I].LineIndicator = nochr then
            begin
              Break;
            end
            else if ((CPFoundRecs[I].LineIndicator = endchr) or
              (CPFoundRecs[I].LineIndicator = allchr)) then
            begin
              LoopBool := true;
              Result := true;
              Break;
            end;
          end;
        end;
      end;
    end;

    if EndCheck then
    begin
      // nothing found so check forwards
      if not Result then
      begin
        // go to the next line by line looking for gap or endchar
        while (not LoopBool) and (not LineGapFnd) and (tempLine <= HighLoop) do
        begin
          Inc(tempLine);
          LineGapFnd := true;

          for I := low(CPFoundRecs) to high(CPFoundRecs) do
          begin
            if CPFoundRecs[I].NoteLine = tempLine then
            begin
              LineGapFnd := False;
              if CPFoundRecs[I].LineIndicator = nochr then
              begin
                Break;
              end
              else if ((CPFoundRecs[I].LineIndicator = allchr) or
                (CPFoundRecs[I].LineIndicator = begchar)) then
              begin
                LoopBool := true;
                Result := true;
                Break;
              end;
            end;
          end;
        end;
      end;
    end;

  end;
end;

// Load the blank lines between the buffer zone as "found"
Procedure TCopyPasteDetails.LoadBlankLines(NoteArray: TCpTextRecArray;
  StrtLn, StopLn: Integer);
var
  I, X: Integer;
  AddRec: Boolean;

  procedure DeleteArryRec(const Index: Cardinal);
  var
    ALength: Cardinal;
    X: Integer;
  begin
    ALength := Length(CPFoundRecs);
    for X := Index + 1 to ALength - 1 do
      CPFoundRecs[X - 1] := CPFoundRecs[X];
    SetLength(CPFoundRecs, ALength - 1);
  end;

begin
  // clear any old recs
  for I := High(CPFoundRecs) downto low(CPFoundRecs) do
  begin
    if ((CPFoundRecs[I].NoteLine < StrtLn) or (CPFoundRecs[I].NoteLine > StopLn)
      ) and (CPFoundRecs[I].LineIndicator = nochr) then
      DeleteArryRec(I);
  end;

  for I := Low(NoteArray) to High(NoteArray) do
  begin
    // If before the range do nothing
    if (NoteArray[I].LineNumber < StrtLn) then
      Continue;

    // If after the range then move to the next line
    If (NoteArray[I].LineNumber > StopLn) then
      Break;

    // No text on line add to found array
    if Trim(NoteArray[I].Text) = '' then
    begin
      AddRec := true;
      // Check if this has already been added before
      for X := Low(CPFoundRecs) to High(CPFoundRecs) do
      begin
        if (CPFoundRecs[X].NoteLine = NoteArray[I].LineNumber) and
          (CPFoundRecs[X].LineIndicator = nochr) then
        begin
          AddRec := False;
          Break;
        end;
      end;

      if AddRec then
      begin
        SetLength(CPFoundRecs, Length(CPFoundRecs) + 1);
        CPFoundRecs[high(CPFoundRecs)].Text := NoteArray[I].Text;
        CPFoundRecs[high(CPFoundRecs)].NoteLine := NoteArray[I].LineNumber;
        CPFoundRecs[high(CPFoundRecs)].PasteLine := -1;
        CPFoundRecs[high(CPFoundRecs)].LineIndicator := nochr;
        CPFoundRecs[high(CPFoundRecs)].StartChar := -1;
        NoteArray[I].Found := true;
      end;
    end;
  end;
end;

procedure TCopyPasteDetails.FindMatchingLines(NoteArray,
  PasteArray: TCpTextRecArray; var ResultArray: TCPMatchingLinesArray);
var
  I, J: Integer;
begin
  SetLength(ResultArray, 0);
  // Loop through pasted text lines
  for I := Low(PasteArray) to High(PasteArray) do
  begin
    if Trim(PasteArray[I].Text) = '' then
      Continue;

    // Loop through note text lines
    for J := Low(NoteArray) to High(NoteArray) do
    begin
      if Trim(NoteArray[J].Text) = '' then
        Continue;

      // If line are NOT the same then keep going
      if AnsiCompareText(PasteArray[I].Text, NoteArray[J].Text) <> 0 then
        Continue;

      // If line exist in both then add to our array
      SetLength(ResultArray, Length(ResultArray) + 1);
      ResultArray[high(ResultArray)].NoteLineNum := NoteArray[J].LineNumber;
      ResultArray[high(ResultArray)].PasteLineNum := PasteArray[I].LineNumber;
    end;
  end;
end;

{ -------------------------------------------------------------------------------
  Procedure:   FindMatchingSection
  DateTime:    2015.11.05
  Arguments:   var DataArray: TCPMatchingLinesArray
  Result:      integer
  Description: Identify largest section of most identical lines
  ------------------------------------------------------------------------------- }
function TCopyPasteDetails.FindMatchingSection(var DataArray
  : TCPMatchingLinesArray; NoteArray, PasteArray: TCpTextRecArray): Integer;
var
  // i, j, BEG, BEGi, CNT, DN, NLine, NUMSTMP, TMPBEG, TMPBEGi, TMPCNT: integer;
  I, MtchLnCnt, LastMtchLnCnt, FoundArryPos, LastPosA, LastPosB, X: Integer;
  LastP, LastN: Integer;
  Comp: IComparer<TCPMatchingLines>;

  function BlankLineFound(var OffSet: Integer; const LookupNum: Integer;
    NoteArray: TCpTextRecArray): Boolean;
  var
    X: Integer;
  begin
    Result := False;
    for X := OffSet + 1 to High(NoteArray) do
    begin
      if NoteArray[X].LineNumber = (LookupNum) then
        if Trim(NoteArray[X].Text) = '' then
        begin
          Result := true;
          OffSet := X;
          Break;
        end;
    end;
  end;

  Procedure FindMatchingSectionsCount(DataArray: TCPMatchingLinesArray;
    NoteArray, PasteArray: TCpTextRecArray;
    NoteLine, PasteLine, StartPos: Integer; var PosA, PosB, AResult: Integer);
  Var
    X: Integer;
    CallRecur, BlankFound: Boolean;
  begin
    CallRecur := False;

    BlankFound := BlankLineFound(PosA, NoteLine + 1, NoteArray);

    for X := StartPos to High(DataArray) do
    begin
      // If consecutive
      If ((DataArray[X].NoteLineNum = (NoteLine + 1)) and
        (DataArray[X].PasteLineNum = (PasteLine + 1))) or
        (BlankFound and (DataArray[X].PasteLineNum = (PasteLine + 1))) then
      begin
        CallRecur := true;
        StartPos := X + 1;
        Break;
      end;
    end;

    { for X := StartPos to High(DataArray) do
      begin
      If (DataArray[X].NoteLineNum = (NoteLine + 1)) and
      (DataArray[X].PasteLineNum = (PasteLine + 1)) then
      begin
      CallRecur := true;
      StartPos := X + 1;

      Break;
      end;
      end;

      if not CallRecur then
      begin
      BlankFound := False;
      for X := PosA + 1 to High(NoteArray) do
      begin
      if NoteArray[X].LineNumber = (NoteLine + 1) then
      if Trim(NoteArray[X].Text) = '' then
      begin
      BlankFound := true;
      PosA := X;
      Break;
      end;
      end;

      if BlankFound then
      begin
      for X := PosB + 1 to High(PasteArray) do
      begin
      if PasteArray[X].LineNumber = (PasteLine + 1) then
      begin
      //  if Trim(PasteArray[X].Text) = '' then
      //  begin
      CallRecur := true;
      PosB := X;
      Break;
      //  end;
      end;
      end;
      end;

      end; }

    if CallRecur then
    begin
      Inc(AResult);
      FindMatchingSectionsCount(DataArray, NoteArray, PasteArray, NoteLine + 1,
        PasteLine + 1, StartPos, PosA, PosB, AResult);
    end;

  end;

begin

  // Setup sort compaprer for generic Tarray
  Comp := TComparer<TCPMatchingLines>.Construct(
    function(const Left, Right: TCPMatchingLines): Integer
    begin
      Result := TComparer<Integer>.Default.Compare(Left.NoteLineNum,
        Right.NoteLineNum);
      if Result = 0 then
        Result := TComparer<Integer>.Default.Compare(Left.PasteLineNum,
          Right.PasteLineNum);
    end);

  // Sort the data array
  TArray.Sort<TCPMatchingLines>(DataArray, Comp);

  // Loop through the found perfect lines
  LastMtchLnCnt := -1;
  I := 0;
  FoundArryPos := -1;
  LastPosA := -1;
  LastPosB := -1;
  while I <= High(DataArray) do
  begin
    MtchLnCnt := 1;
    // Grab the current lookup numbers
    LastP := DataArray[I].PasteLineNum;
    LastN := DataArray[I].NoteLineNum;

    FindMatchingSectionsCount(DataArray, NoteArray, PasteArray, LastN, LastP, I,
      LastPosA, LastPosB, MtchLnCnt);

    if MtchLnCnt > LastMtchLnCnt then
    begin
      LastMtchLnCnt := MtchLnCnt;
      FoundArryPos := I;
    end;

    Inc(I, MtchLnCnt);
  end;

  // If we found something
  if FoundArryPos > -1 then
  begin
    LastPosA := 0;
    LastPosB := 0;

    for I := 0 to LastMtchLnCnt - 1 do
    begin
      for X := LastPosA to High(PasteArray) do
      begin
        if PasteArray[X].LineNumber = DataArray[FoundArryPos].PasteLineNum + I
        then
        begin
          LastPosA := X;
          PasteArray[X].Found := true;
          Break;
        end;
      end;

      for X := LastPosB to High(NoteArray) do
      begin
        if NoteArray[X].LineNumber = DataArray[FoundArryPos].NoteLineNum + I
        then
        begin
          LastPosB := X;
          NoteArray[X].Found := true;
          Break;
        end;
      end;

      if Trim(PasteArray[LastPosA].Text) <> '' then
      begin
        SetLength(CPFoundRecs, Length(CPFoundRecs) + 1);
        CPFoundRecs[high(CPFoundRecs)].Text := PasteArray[LastPosA].Text;
        CPFoundRecs[high(CPFoundRecs)].NoteLine := NoteArray[LastPosB]
          .LineNumber;
        CPFoundRecs[high(CPFoundRecs)].PasteLine := PasteArray[LastPosA]
          .LineNumber;
        CPFoundRecs[high(CPFoundRecs)].LineIndicator := allchr;
        CPFoundRecs[high(CPFoundRecs)].StartChar := 1;
      end;

    end;

  end;
  Result := FoundArryPos;
end;

{ -------------------------------------------------------------------------------
  Procedure:   FindBufferZone
  DateTime:    2015.12.09
  Arguments:   aPasteLineNum, aNoteLineNum: Integer; Var aStrBuff, aEndBuff: Integer
  Result:      None
  Description: Find the search area
  ------------------------------------------------------------------------------- }
procedure TCopyPasteDetails.FindBufferZone(aPasteLineNum, aNoteLineNum: Integer;
Var aStrBuff, aEndBuff: Integer; PasteList, OrigText: TStringList);
var
  LineAdj: Integer;
begin
  // Find the start line
  LineAdj := aPasteLineNum + ((aPasteLineNum) div 5) + 5;
  if (aNoteLineNum - LineAdj) > -1 then
    aStrBuff := aNoteLineNum - LineAdj;

  // Find the end line
  LineAdj := ((PasteList.Count - 1) - aPasteLineNum) +
    (((PasteList.Count - 1) - aPasteLineNum) div 5) + 5;
  if (aNoteLineNum + LineAdj) <= OrigText.Count - 1 then
    aEndBuff := aNoteLineNum + LineAdj;
end;

// Can text be found on the previosu line?
function TCopyPasteDetails.SPECIAL(FoundArray: TCPFoundRecArray;
NoteLineNum: Integer): Boolean;
// F is Found array/object (TCPFoundRec)
var
  TextFound, LineExist: Boolean;
  Y, LookupNum, HighLineNum, LowLineNum: Integer;
begin
  Result := False;

  if Length(FoundArray) > 0 then
  begin
    TextFound := False;
    LookupNum := NoteLineNum;
    HighLineNum := NoteLineNum + 1;
    LineExist := true; // assume the line exist
    // Look ahead line by line
    while (not TextFound) and (LookupNum < HighLineNum) and (LineExist) do
    begin
      Inc(LookupNum);
      LineExist := False; // default not found
      for Y := Low(FoundArray) to High(FoundArray) do
      begin
        if HighLineNum < FoundArray[Y].NoteLine then
          HighLineNum := FoundArray[Y].NoteLine;

        if FoundArray[Y].NoteLine = LookupNum then
        begin
          LineExist := true;
          if FoundArray[Y].LineIndicator = nochr then
            Continue;
          if (FoundArray[Y].StartChar = 1) then
          begin
            TextFound := true;
            Break;
          end;
        end;
      end;
    end;

    if (not TextFound) then
    begin
      LookupNum := NoteLineNum;
      LowLineNum := NoteLineNum - 1;
      LineExist := true; // assume the line exist
      // Look ahead line by line
      while (not TextFound) and (LookupNum > LowLineNum) and (LineExist) do
      begin
        Dec(LookupNum);
        LineExist := False; // default not found
        for Y := Low(FoundArray) to High(FoundArray) do
        begin
          if LowLineNum > FoundArray[Y].NoteLine then
            LowLineNum := FoundArray[Y].NoteLine;

          if FoundArray[Y].NoteLine = LookupNum then
          begin
            LineExist := true;
            if (FoundArray[Y].LineIndicator = allchr) or
              (FoundArray[Y].LineIndicator = endchr) then
            begin
              TextFound := true;
              Break;
            end;
          end;
        end;
      end;
    end;

    Result := TextFound;

  end;
end;

function TCopyPasteDetails.FindStartPos(NoteRec: TCPTextRec;
SubSearchPos: Integer = -1; NoteLineFullTxt: string = ''): Integer;
var
  SearchRegions: TStringList;
  I: Integer;
  CurBeg, PrevEnd: Integer;
begin
  SearchRegions := TStringList.Create;
  try
    for I := Low(CPFoundRecs) to High(CPFoundRecs) do
    begin
      if CPFoundRecs[I].NoteLine = NoteRec.LineNumber then
      begin
        if (CPFoundRecs[I].StartChar > 0) and
          (CPFoundRecs[I].EndChar < Length(NoteLineFullTxt)) then
          SearchRegions.Add(IntToStr(CPFoundRecs[I].StartChar) + '^' +
            IntToStr(CPFoundRecs[I].EndChar));
      end;
    end;
    if SearchRegions.Count > 0 then
    begin
      SearchRegions.Sort;

      if (SubSearchPos = -1) and (StrToIntDef(Piece(SearchRegions[0], '^', 1),
        0) > 1) then
        Result := 1
      else
      begin
        Result := StrToIntDef(Piece(SearchRegions[SearchRegions.Count - 1], '^',
          2), 0) + 1;
        for I := 1 to SearchRegions.Count - 1 do
        begin
          CurBeg := StrToIntDef(Piece(SearchRegions[I], '^', 1), 0);
          PrevEnd := StrToIntDef(Piece(SearchRegions[I - 1], '^', 2), 0);

          if SubSearchPos > -1 then
            if ((CurBeg < SubSearchPos) or (PrevEnd < SubSearchPos)) or
              ((SubSearchPos >= CurBeg) and (SubSearchPos <= PrevEnd)) then
              Continue;

          if CurBeg > PrevEnd + 1 then
          begin
            Result := PrevEnd + 1;
            Break;
          end;
        end;
      end;
    end
    else
      Result := 1; // nothing in the found array

    if Result > Length(NoteLineFullTxt) then
      Result := 0;
  finally
    SearchRegions.Free;
  end;
end;

{ -------------------------------------------------------------------------------
  Procedure:   FindText
  DateTime:    2015.12.09
  Arguments:   var FoundPOS: Array
  Result:      Integer
  Description: find matching text (exact or partial)
  ------------------------------------------------------------------------------- }
procedure TCopyPasteDetails.FindText(var FoundPOS: TCPFindTxtRecArray;
PasteRec, NoteRec: TCPTextRec; MINLNGTH: Integer; NoteList: TStringList);
var
  // PasteWrd = txt
  // PasteWordIdx = STRT
  // SearhWordIdx = CNT
  // LastWordIdx = FIN
  // PasteWrdCharCnt = TXTCNT
  // PasteLineStrtIdx = BSTRT
  // PasteLineEndIdx = BFIN
  // NoteLineStrtIndex = Pstrt
  // NoteLineEndIndex = PFin
  // PrevIdx = TSTRT
  // NoteLineFullTxt = PFLTXT
  // SearchStrtPos = MTCHSTRT
  // MatchedPos = Match  // Could be partial in note line
  // PastedPos = SMatch  // Could be partial in the paste line
  // MatchedFullPos = PFLMATCH  //Full line position in the note line
  // SrchTxtFound = GDMTCH
  // CanContinue = NOGOOD

  MatchedFullPos: Integer;
  SPCL: Boolean;
  X, I, LoopStart, LoopEnd, WrdCntPaste, WrdCntNote, SearhWordIdx, PasteWordIdx,
    LastWordIdx: Integer;
  MatchedPos, PastedPos, PrevIdx, SearchStrtPos: Integer;
  NoteLineStrtIndex, NoteLineEndIndex, PasteLineStrtIdx,
    PasteLineEndIdx: Integer;
  PasteWrd, NoteLineFullTxt: String;
  Fnd, SrchTxtFound, LoopContinue, StopFndTxt: Boolean;
  TmpBool: Boolean;
  TmpInt, TmpInt2: Integer;

begin
  SPCL := False;
  if MINLNGTH = 0 then
    SPCL := SPECIAL(CPFoundRecs, NoteRec.LineNumber);
  // F is Found array/object (TCPFoundRec)
  MatchedFullPos := -1;
  // Setup start and end for the loop
  LoopEnd := 1;
  WrdCntPaste := DelimCount(PasteRec.Text, ' ') + 1;
  WrdCntNote := DelimCount(NoteRec.Text, ' ') + 1;
  if WrdCntPaste < WrdCntNote then
    LoopStart := WrdCntPaste
  else
    LoopStart := WrdCntNote;

  // loop through from lowest word cnt to 1
  for SearhWordIdx := LoopStart downto LoopEnd do
  // Increment by -1, meaning high to low, quit on FNDTXT=1
  begin
    StopFndTxt := true;

    // Looping for each word and pull the word group
    for PasteWordIdx := 1 to WrdCntPaste do // quit FIN>SLSTSPC, quit FNDTXT=1
    begin
      // Find the last word index
      LastWordIdx := PasteWordIdx + SearhWordIdx - 1;
      if LastWordIdx > WrdCntPaste then
      begin
        StopFndTxt := False;
        Break;
      end;

      // grab the word(s) for the search
      PasteWrd := Pieces(PasteRec.Text, ' ', PasteWordIdx, LastWordIdx);
      // Grabs a range of pieces

      if Trim(PasteWrd) = '' then
        Continue;

      if (MINLNGTH <> 10) and (Length(PasteWrd) < MINLNGTH) then
        Continue;

      if (MINLNGTH <> 10) then
        StopFndTxt := False;

      if MINLNGTH < 20 then
      begin
        // Check for at least two words or this is special
        if DelimCount(Trim(PasteWrd), ' ') <= 1 then
          SPCL := true;
      end;

      // Find the word(s) position in the note line
      if MINLNGTH > 0 then
        MatchedPos := Pos(UpperCase(PasteWrd), UpperCase(NoteRec.Text))
      else
        MatchedPos := Pos(PasteWrd, NoteRec.Text);

      // ensure this is not the middle of some text
      if MatchedPos <> 0 then
      begin
        if MatchedPos > 1 then
        begin
          if NoteRec.Text[MatchedPos - 1] <> ' ' then
            MatchedPos := 0;
        end;

        if (MatchedPos + Length(PasteWrd) - 1) < Length(NoteRec.Text) then
        begin
          if NoteRec.Text[MatchedPos + Length(PasteWrd)] <> ' ' then
            MatchedPos := 0;
        end;
      end;

      if MatchedPos = 0 then
        Continue;

      // If not special and line only contains characters below then move to next
      if (not SPCL) then
      begin
        Fnd := False;
        for I := 1 to Length(PasteWrd) do
        begin
          if not CharInSet(PasteWrd[I], [' ', '!', '.', '?']) then
          begin
            Fnd := true;
            Break;
          end;
        end;
        if not Fnd then
          Continue;
      end;

      // Where does this paste word(s) lie on the pasted line
      if MINLNGTH > 0 then
        PastedPos := Pos(UpperCase(PasteWrd), UpperCase(PasteRec.Text))
      else
        PastedPos := Pos(PasteWrd, PasteRec.Text);

      // PSTRT := MATCH - LTXT;
      // PFIN := MATCH - 1;

      // if nothing found yet and less than 3 words then move to the next
      { if MinLngth < 10 then
        begin
        TmpBool := False;
        for I := Low(CPFoundRecs) to High(CPFoundRecs) do
        begin
        if CPFoundRecs[I].NoteLine = NoteRec.LineNumber then
        begin
        TmpBool := true;
        break;
        end;
        end;

        if (not TmpBool) and (DelimCount(Trim(PasteWrd), ' ') < 2) then
        continue;
        end; }
      if (MINLNGTH < 10) and (Length(CPFoundRecs) = 0) and
        (DelimCount(Trim(PasteWrd), ' ') < 2) then
        Continue;

      // Grab the first character position of the search words in the patsed line
      PasteLineStrtIdx := PastedPos;

      // Find the last character  position of the search words in the patsed line
      if LastWordIdx = WrdCntPaste then
        PasteLineEndIdx := Length(PasteRec.Text)
      else
        PasteLineEndIdx := PastedPos + Length(PasteWrd) - 1;

      // Grab the first character position of the search words in the NOTE line
      NoteLineStrtIndex := MatchedPos;

      // Find the last character  position of the search words in the NOTE line
      NoteLineEndIndex := MatchedPos + Length(PasteWrd) - 1;

      // find position of first non character match before found text
      PrevIdx := PasteLineStrtIdx;
      if (PasteLineStrtIdx > 1) and (NoteLineStrtIndex > 1) then
      begin
        while (PasteLineStrtIdx > 1) and (NoteLineStrtIndex > 1) do
        begin
          if Trim(Copy(NoteRec.Text, 1, NoteLineStrtIndex - 1)) = '' then
            Break;

          if NoteRec.Text[NoteLineStrtIndex - 1] <> PasteRec.Text
            [PasteLineStrtIdx - 1] then
            Break;

          Dec(NoteLineStrtIndex);
          Dec(PasteLineStrtIdx);
        end;
      end;

      // Tack on the start characters
      if PrevIdx <> PasteLineStrtIdx then
      begin
        MatchedPos := NoteLineStrtIndex;
        PastedPos := PasteLineStrtIdx;
        PasteWrd := Copy(PasteRec.Text, PasteLineStrtIdx,
          (PrevIdx - PasteLineStrtIdx)) + PasteWrd;
      end;

      // find position of last non character match after found text
      PrevIdx := PasteLineEndIdx;
      if (PasteLineEndIdx > 1) and (NoteLineEndIndex > 1) then
      begin
        while (PasteLineEndIdx < Length(PasteRec.Text)) and
          (NoteLineEndIndex < Length(NoteRec.Text)) do
        begin
          if Trim(Copy(NoteRec.Text, NoteLineEndIndex, Length(NoteRec.Text) + 1)
            ) = '' then
            Break;

          if NoteRec.Text[NoteLineEndIndex + 1] <> PasteRec.Text
            [PasteLineEndIdx + 1] then
            Break;

          Inc(NoteLineEndIndex);
          Inc(PasteLineEndIdx);
        end;
      end;

      if PrevIdx <> PasteLineEndIdx then
        PasteWrd := PasteWrd + Copy(PasteRec.Text, PrevIdx + 1,
          PasteLineEndIdx - (PrevIdx));

      if (MINLNGTH = 10) and (Length(Trim(PasteWrd)) < MINLNGTH) then
        Continue;

      if (MINLNGTH = 10) then
        StopFndTxt := False;

      // Add trailing spaces
      if (NoteLineEndIndex < Length(NoteRec.Text)) and
        (Trim(Copy(NoteRec.Text, NoteLineEndIndex + 1, Length(NoteRec.Text)))
        = '') then
      begin
        PasteWrd := PasteWrd + Copy(NoteRec.Text, NoteLineEndIndex + 1,
          Length(NoteRec.Text));
        // NoteLineEndIndex := Length(NoteRec.Text);
      end;

      // Add leading spaces
      if (NoteLineStrtIndex > 1) and
        (Trim(Copy(NoteRec.Text, 1, NoteLineStrtIndex - 1)) = '') then
      begin
        PasteWrd := Copy(NoteRec.Text, 1, NoteLineStrtIndex - 1) + PasteWrd;
        // NoteLineStrtIndex := 1;
        MatchedPos := 1;
      end;

      // Grab full text
      NoteLineFullTxt := NoteList.Strings[NoteRec.LineNumber - 1];

      // grab the start for the search
      SearchStrtPos := FindStartPos(NoteRec, -1, NoteLineFullTxt);
      if SearchStrtPos = 0 then
        Continue;

      SrchTxtFound := False;
      for I := 1 to 10 do
      begin
        // Need a Pos style function that lets me specify where to start in search in the string
        if MINLNGTH > 0 then
          MatchedFullPos := PosEx(UpperCase(PasteWrd),
            UpperCase(NoteLineFullTxt), SearchStrtPos);

        if MINLNGTH = 0 then
          MatchedFullPos := PosEx(PasteWrd, NoteLineFullTxt, SearchStrtPos);

        if MatchedFullPos <= 0 then
          Break;

        // Check is this exist already in the found array
        for X := Low(CPFoundRecs) to High(CPFoundRecs) do
        begin
          if CPFoundRecs[X].NoteLine = NoteRec.LineNumber then
          begin
            if ((MatchedFullPos >= CPFoundRecs[X].StartChar) and
              (MatchedFullPos <= CPFoundRecs[X].EndChar)) or
              (((MatchedFullPos + Length(PasteWrd) - 1) >= CPFoundRecs[X]
              .StartChar) and ((MatchedFullPos + Length(PasteWrd) - 1) <=
              CPFoundRecs[X].EndChar)) then
            begin
              SrchTxtFound := true;
              Break;
            end;
          end;
        end;

        if SrchTxtFound then
        begin
          SearchStrtPos := FindStartPos(NoteRec, MatchedFullPos,
            NoteLineFullTxt);
          if SearchStrtPos = 0 then
            Break;
        end
        else
          Break;
      end;

      if MatchedFullPos <= 0 then
        Continue;

      if SearchStrtPos = 0 then
        Continue;

      if SrchTxtFound then
        Continue;

      if SPCL then
      begin

        LoopContinue := not CharLookup(NoteRec.LineNumber, MatchedFullPos = 1,
          (MatchedFullPos + Length(PasteWrd) - 1) = Length(NoteLineFullTxt));

        if LoopContinue then
          Continue;

      end;

      SetLength(FoundPOS, Length(FoundPOS) + 1);
      FoundPOS[High(FoundPOS)].PosPartialLine := MatchedPos;
      FoundPOS[High(FoundPOS)].PosEntireLine := MatchedFullPos;
      FoundPOS[High(FoundPOS)].PosPastedLine := PastedPos;
      FoundPOS[High(FoundPOS)].NoteLine := NoteRec.LineNumber;
      FoundPOS[High(FoundPOS)].PastedText := PasteWrd;
      FoundPOS[High(FoundPOS)].PartialNoteText := NoteRec.Text;
      FoundPOS[High(FoundPOS)].FullNoteText := NoteList.Strings
        [NoteRec.LineNumber - 1];
      FoundPOS[High(FoundPOS)].InnerNoteLine := NoteRec.InnerLine;

      StopFndTxt := true;
      Break;
    end;

    // Leave method if text was found
    if StopFndTxt then
      Break;

  end;
end;

procedure TCopyPasteDetails.CPCOMPARE(const aPastedRec: TCprsClipboard;
var OutList: TStringList; var FinalPercent: Double; var TimeTook: Int64);
var
  Min, SrchStrtLine, SrchEndLine, X: Integer;
  ExactMatchPos: Integer;
  MatchLinesArray: TCPMatchingLinesArray;
  I, SNUMS, SLSTSPC, MINLNGTH: Integer;
  J, PNUMP, PSUB, PLST, PLSTSPC, EndFndFullPos, EndFndParPos, LstInnrNum,
    TmpInt, FoundPosInstance, DistanceNote, DistancePaste, LastNum,
    LastEnd: Integer;
  SDATA, PDATA, SFLTXT, PTXT, ParBegTxt, ParEndTxt, FullBegTxt, FullEndTxt,
    TmpStr, CPFText, OutText: string;
  BuffRan, BegTxtFnd, EndTxtFnd, LoopEscape, DoSort: Boolean;
  // PasteClone, NoteClone: TStringList;
  PasteRecArry: TCpTextRecArray;
  NoteRecArry: TCpTextRecArray;
  FoundPosArry: TCPFindTxtRecArray;
  Comp: IComparer<TCPFindTxtRec>;
  Comp2: IComparer<TCPFoundRec>;
  Comp3: IComparer<TCPTextRec>;
  FinalStrLst, Temp1, Temp2: TStringList;
  PasteList, NoteList: TStringList;
  PercList, TmpList: TStringList;
  FndSecTotal, RtnCursor: Integer;
  WatchCreated: Boolean;

  procedure CancelFind();
  begin
    OutList.Clear;
    FinalPercent := -3;
    TimeTook := -1;
  end;

begin
  { TODO : Compare Formated lines to find text - help with wrapping }
  { TODO : Time limit for the find }
  // debug
  RtnCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    // Assume we do not need to clean up the stop watch (this will already exist if debuging is on)

    WatchCreated := False;
    if not Assigned(EditMonitor.StopWatch) then
    begin
      EditMonitor.StopWatch := TStopWatch.Create(Self, true);
      WatchCreated := true;
    end;
    try
      EditMonitor.StartStopWatch;
      try
        // Clear what we have found.
        SetLength(CPFoundRecs, 0);

        PasteList := TStringList.Create;
        NoteList := TStringList.Create;
        try
          OutList.Clear;
          // remove leading ad trailing blank lines from paste

          TrimBlankLines(aPastedRec.CopiedText, PasteList);
          BreakUpLongListLines(PasteList, EditMonitor.CopyMonitor.BreakUpLimit);

          NoteList.Assign(FMonitorObject.Lines);

          for I := 0 to PasteList.Count - 1 do
          begin
            SetLength(PasteRecArry, Length(PasteRecArry) + 1);
            PasteRecArry[High(PasteRecArry)].Text := PasteList.Strings[I];
            PasteRecArry[High(PasteRecArry)].LineNumber := I + 1;
            PasteRecArry[High(PasteRecArry)].InnerLine := -1;
            PasteRecArry[High(PasteRecArry)].InnBeg := -1;
            PasteRecArry[High(PasteRecArry)].InnEnd := -1;
            PasteRecArry[High(PasteRecArry)].Found := False;
          end;

          for I := 0 to NoteList.Count - 1 do
          begin
            SetLength(NoteRecArry, Length(NoteRecArry) + 1);
            NoteRecArry[High(NoteRecArry)].Text := NoteList.Strings[I];
            NoteRecArry[High(NoteRecArry)].LineNumber := I + 1;
            NoteRecArry[High(NoteRecArry)].InnerLine := -1;
          end;

          FindMatchingLines(NoteRecArry, PasteRecArry, MatchLinesArray);

          // Find the most likely search section's start position
          SrchStrtLine := 0;
          SrchEndLine := NoteList.Count;
          BuffRan := False;
          ExactMatchPos := FindMatchingSection(MatchLinesArray, NoteRecArry,
            PasteRecArry);

          // find the start and end if we matched any lines
          if ExactMatchPos <> -1 then
          begin
            With MatchLinesArray[ExactMatchPos] do
              FindBufferZone(PasteLineNum, NoteLineNum, SrchStrtLine,
                SrchEndLine, aPastedRec.CopiedText, NoteList);
            BuffRan := true;
          end;

          // Pre load blank lines
          LoadBlankLines(NoteRecArry, SrchStrtLine, SrchEndLine);

          // Init variables
          MINLNGTH := 40;

          // And so the looping begins
          while MINLNGTH > -1 do
          begin

            // Check it we ran out of time
            if EditMonitor.StopWatch.ElapsedMilliseconds >=
              (EditMonitor.CopyMonitor.CompareCutOff * 1000) then
            begin
              CancelFind;
              Exit;
            end;

            for I := Low(PasteRecArry) to High(PasteRecArry) do
            begin
              // Check it we ran out of time
              if EditMonitor.StopWatch.ElapsedMilliseconds >=
                (EditMonitor.CopyMonitor.CompareCutOff * 1000) then
              begin
                CancelFind;
                Exit;
              end;

              if PasteRecArry[I].Found then
                Continue;

              if Trim(PasteRecArry[I].Text) = '' then
              begin
                // No need to check the blank text in the future checks
                PasteRecArry[I].Found := true;
                Continue;
              end;

              if CopyMonitor.WordCount(Trim(PasteRecArry[I].Text)) <= 2 then
              begin
                // No need to check less than 2 words
                PasteRecArry[I].Found := true;
                Continue;
              end;

              // Add continue if min text > than length
              if Length(PasteRecArry[I].Text) < MINLNGTH then
                Continue;

              // Check for this in the note text
              for J := Low(NoteRecArry) to High(NoteRecArry) do
              begin
                // Check it we ran out of time
                if EditMonitor.StopWatch.ElapsedMilliseconds >=
                  (EditMonitor.CopyMonitor.CompareCutOff * 1000) then
                begin
                  CancelFind;
                  Exit;
                end;

                // Skip any found note lines
                if NoteRecArry[J].Found then
                  Continue;

                // If before the range do nothing
                if (NoteRecArry[J].LineNumber < SrchStrtLine) then
                  Continue;

                // If after the range then move to the next line
                If (NoteRecArry[J].LineNumber > SrchEndLine) then
                  Continue;

                if MINLNGTH > 10 then
                begin
                  if PasteRecArry[I].InnBeg > -1 then
                  begin
                    if NoteRecArry[J].LineNumber > PasteRecArry[I].InnBeg then
                      Break;
                  end;

                  if PasteRecArry[I].InnEnd > -1 then
                  begin
                    if NoteRecArry[J].LineNumber < PasteRecArry[I].InnEnd then
                      Continue;
                  end;
                end;

                if not(Trim(NoteRecArry[J].Text) = '') then
                begin
                  if (AnsiCompareText(Trim(PasteRecArry[I].Text),
                    Trim(NoteRecArry[J].Text)) = 0) and
                    (NoteRecArry[J].InnerLine = -1) then
                  begin
                    SetLength(FoundPosArry, Length(FoundPosArry) + 1);
                    FoundPosArry[High(FoundPosArry)].PosPartialLine := 1;
                    FoundPosArry[High(FoundPosArry)].PosEntireLine := 1;
                    FoundPosArry[High(FoundPosArry)].PosPastedLine := 1;
                    FoundPosArry[High(FoundPosArry)].NoteLine :=
                      NoteRecArry[J].LineNumber;
                    FoundPosArry[High(FoundPosArry)].PastedText :=
                      NoteRecArry[J].Text;
                    FoundPosArry[High(FoundPosArry)].PartialNoteText :=
                      NoteRecArry[J].Text;
                    FoundPosArry[High(FoundPosArry)].FullNoteText :=
                      NoteList.Strings[NoteRecArry[J].LineNumber - 1];
                    FoundPosArry[High(FoundPosArry)].InnerNoteLine :=
                      NoteRecArry[J].InnerLine;
                  end
                  else
                    FindText(FoundPosArry, PasteRecArry[I], NoteRecArry[J],
                      MINLNGTH, NoteList);
                end;

              end;

              if Length(FoundPosArry) <> 0 then
              begin

                // Sort the found position array by text length
                Comp := TComparer<TCPFindTxtRec>.Construct(
                  function(const Left, Right: TCPFindTxtRec): Integer
                  begin
                    Result := TComparer<Integer>.
                      Default.Compare(Length(Right.PastedText),
                      Length(Left.PastedText));
                    if Result = 0 then
                      Result := TComparer<Integer>.
                        Default.Compare(Left.NoteLine, Right.NoteLine);
                  end);

                // Sort the data array
                TArray.Sort<TCPFindTxtRec>(FoundPosArry, Comp);

                // Default to the longest line
                FoundPosInstance := 0;
                LoopEscape := False;
                DistancePaste := -1;
                DistanceNote := -1;

                // Loop from longest line to shortest
                if Length(FoundPosArry) > 1 then
                begin
                  for J := Low(FoundPosArry) to High(FoundPosArry) do
                  begin
                    // Check to match closest previous lines
                    for X := Low(CPFoundRecs) to High(CPFoundRecs) do
                    begin

                      // If not at the end then
                      if J < High(FoundPosArry) then
                      begin
                        if Length(FoundPosArry[J].PastedText) <>
                          Length(FoundPosArry[J + 1].PastedText) then
                          LoopEscape := true;
                      end;

                      // Look for previous note line paste greater than current and paste prior to current
                      if (CPFoundRecs[X].NoteLine <= FoundPosArry[J].NoteLine)
                        and (CPFoundRecs[X].PasteLine <= PasteRecArry[I]
                        .LineNumber) then
                      begin

                        // Find the closest in distance and use it
                        if (((PasteRecArry[I].LineNumber - CPFoundRecs[X]
                          .PasteLine) <= DistancePaste) and
                          (FoundPosArry[J].NoteLine - CPFoundRecs[X].NoteLine <=
                          DistanceNote)) or
                          ((DistancePaste = -1) and (DistanceNote = -1)) then
                        begin
                          DistancePaste := PasteRecArry[I].LineNumber -
                            CPFoundRecs[X].PasteLine;
                          DistanceNote := FoundPosArry[J].NoteLine - CPFoundRecs
                            [X].NoteLine;
                          FoundPosInstance := J;
                        end;
                        if LoopEscape then
                          Break;

                      end;

                    end;

                    if LoopEscape then
                      Break;
                  end;
                end;

                ParBegTxt := '';
                ParEndTxt := '';

                // If not at the first character in FULL note line check for text before our find
                BegTxtFnd := False;
                if FoundPosArry[FoundPosInstance].PosEntireLine > 1 then
                begin
                  FullBegTxt :=
                    Copy(FoundPosArry[FoundPosInstance].FullNoteText, 1,
                    (FoundPosArry[FoundPosInstance].PosEntireLine - 1));
                  If Trim(FullBegTxt) <> '' then
                    BegTxtFnd := true;
                end;

                // If not at the first character in PARTIAL note line check for text before our find
                if FoundPosArry[FoundPosInstance].PosPartialLine > 1 then
                  ParBegTxt :=
                    Copy(FoundPosArry[FoundPosInstance].PartialNoteText, 1,
                    (FoundPosArry[FoundPosInstance].PosPartialLine - 1));

                // If not at the last character in FULL note line check for text after our find
                EndTxtFnd := False;
                EndFndFullPos := (FoundPosArry[FoundPosInstance].PosEntireLine +
                  Length(FoundPosArry[FoundPosInstance].PastedText));
                If (EndFndFullPos - 1) <
                  Length(FoundPosArry[FoundPosInstance].FullNoteText) then
                begin
                  FullEndTxt :=
                    Copy(FoundPosArry[FoundPosInstance].FullNoteText,
                    EndFndFullPos,
                    Length(FoundPosArry[FoundPosInstance].FullNoteText));
                  If Trim(FullEndTxt) <> '' then
                    EndTxtFnd := true;
                end;

                // If not at the last character in PARTIAL note line check for text after our find
                EndFndParPos := (FoundPosArry[FoundPosInstance].PosPartialLine +
                  Length(FoundPosArry[FoundPosInstance].PastedText));
                If (EndFndParPos - 1) <
                  Length(FoundPosArry[FoundPosInstance].PartialNoteText) then
                  ParEndTxt :=
                    Copy(FoundPosArry[FoundPosInstance].PartialNoteText,
                    EndFndParPos,
                    Length(FoundPosArry[FoundPosInstance].PartialNoteText));

                // Next two lines set a new found record.
                SetLength(CPFoundRecs, Length(CPFoundRecs) + 1);
                CPFoundRecs[High(CPFoundRecs)].Text :=
                  FoundPosArry[FoundPosInstance].PastedText;
                CPFoundRecs[High(CPFoundRecs)].NoteLine :=
                  FoundPosArry[FoundPosInstance].NoteLine;
                CPFoundRecs[High(CPFoundRecs)].PasteLine :=
                  PasteRecArry[I].LineNumber;
                CPFoundRecs[High(CPFoundRecs)].StartChar :=
                  FoundPosArry[FoundPosInstance].PosEntireLine;
                CPFoundRecs[High(CPFoundRecs)].EndChar :=
                  (FoundPosArry[FoundPosInstance].PosEntireLine +
                  Length(FoundPosArry[FoundPosInstance].PastedText)) - 1;

                // Need to figure out where the text was found
                PasteRecArry[I].Found := true;
                if (not BegTxtFnd) and (not EndTxtFnd) then
                  CPFoundRecs[High(CPFoundRecs)].LineIndicator := allchr
                else if (BegTxtFnd) and (not EndTxtFnd) then
                  CPFoundRecs[High(CPFoundRecs)].LineIndicator := endchr
                else if (not BegTxtFnd) and (EndTxtFnd) then
                  CPFoundRecs[High(CPFoundRecs)].LineIndicator := begchar
                else
                  CPFoundRecs[High(CPFoundRecs)].LineIndicator := nachar;

                // Grab end position for the paste
                TmpInt := FoundPosArry[FoundPosInstance].PosPastedLine +
                  Length(FoundPosArry[FoundPosInstance].PastedText);

                // Grab the greatest inner line number (we have either begining or ending text)
                LstInnrNum := -1;
                if (FoundPosArry[FoundPosInstance].PosPastedLine > 1) or
                  (TmpInt - 1 < Length(PasteRecArry[I].Text)) then
                begin
                  for X := Low(PasteRecArry) to High(PasteRecArry) do
                  begin
                    if PasteRecArry[X].LineNumber = PasteRecArry[I].LineNumber
                    then
                    begin
                      if PasteRecArry[X].InnerLine > LstInnrNum then
                        LstInnrNum := PasteRecArry[X].InnerLine;
                    end;
                  end;
                end;

                // Take the text from before the used/found Pasted Text and move to new record.
                if FoundPosArry[FoundPosInstance].PosPastedLine > 1 then
                begin
                  TmpStr := Copy(PasteRecArry[I].Text, 1,
                    (FoundPosArry[FoundPosInstance].PosPastedLine - 1));
                  If Trim(TmpStr) <> '' then
                  begin
                    // Add to the pasted array
                    SetLength(PasteRecArry, Length(PasteRecArry) + 1);
                    PasteRecArry[High(PasteRecArry)].Text := TmpStr;
                    PasteRecArry[High(PasteRecArry)].LineNumber :=
                      PasteRecArry[I].LineNumber;
                    PasteRecArry[High(PasteRecArry)].InnBeg :=
                      FoundPosArry[FoundPosInstance].NoteLine;
                    PasteRecArry[High(PasteRecArry)].InnEnd := -1;
                    Inc(LstInnrNum);
                    PasteRecArry[High(PasteRecArry)].InnerLine := LstInnrNum;
                    PasteRecArry[High(PasteRecArry)].Found := False;
                  end;
                end;

                // Take the text from after the used/found Pasted Text and move to new record.
                If TmpInt - 1 < Length(PasteRecArry[I].Text) then
                begin
                  TmpStr := Copy(PasteRecArry[I].Text, TmpInt,
                    Length(PasteRecArry[I].Text));
                  If Trim(TmpStr) <> '' then
                  begin
                    // Add to the pasted array
                    SetLength(PasteRecArry, Length(PasteRecArry) + 1);
                    PasteRecArry[High(PasteRecArry)].Text := TmpStr;
                    PasteRecArry[High(PasteRecArry)].LineNumber :=
                      PasteRecArry[I].LineNumber;
                    PasteRecArry[High(PasteRecArry)].InnEnd :=
                      FoundPosArry[FoundPosInstance].NoteLine;
                    PasteRecArry[High(PasteRecArry)].InnBeg := -1;
                    Inc(LstInnrNum);
                    PasteRecArry[High(PasteRecArry)].InnerLine := LstInnrNum;
                    PasteRecArry[High(PasteRecArry)].Found := False;
                  end;
                end;

                // Reset search area if not already set
                if not BuffRan then
                begin
                  FindBufferZone(PasteRecArry[I].LineNumber,
                    FoundPosArry[FoundPosInstance].NoteLine, SrchStrtLine,
                    SrchEndLine, PasteList, NoteList);
                  BuffRan := true;
                end;

                // Update the note line to mark it as found and Grab the greatest inner line
                // number (we have either begining or ending text)
                LstInnrNum := -1;
                for X := Low(NoteRecArry) to High(NoteRecArry) do
                begin
                  If (NoteRecArry[X].LineNumber = FoundPosArry[FoundPosInstance]
                    .NoteLine) then
                  begin
                    if (NoteRecArry[X].InnerLine = FoundPosArry
                      [FoundPosInstance].InnerNoteLine) then
                    begin
                      NoteRecArry[X].Found := true;
                      if (Trim(ParBegTxt) = '') and (Trim(ParEndTxt) = '') then
                        Break;
                    end;
                    if (Trim(ParBegTxt) <> '') or (Trim(ParEndTxt) <> '') then
                    begin
                      if NoteRecArry[X].InnerLine > LstInnrNum then
                        LstInnrNum := NoteRecArry[X].InnerLine;
                    end;
                  end;

                end;

                DoSort := False;

                // Take the Note text from before/after the found NOTE Text and move to new records.
                if Trim(ParBegTxt) <> '' then
                begin
                  // Add to the note array
                  SetLength(NoteRecArry, Length(NoteRecArry) + 1);
                  NoteRecArry[High(NoteRecArry)].Text := ParBegTxt;
                  NoteRecArry[High(NoteRecArry)].LineNumber :=
                    FoundPosArry[FoundPosInstance].NoteLine;
                  Inc(LstInnrNum);
                  NoteRecArry[High(NoteRecArry)].InnerLine := LstInnrNum;
                  NoteRecArry[High(NoteRecArry)].Found := False;
                  DoSort := true;
                end;

                // Take the text from after the used/found NOTE Text and move to new record.
                If Trim(ParEndTxt) <> '' then
                begin
                  // Add to the note array
                  SetLength(NoteRecArry, Length(NoteRecArry) + 1);
                  NoteRecArry[High(NoteRecArry)].Text := ParEndTxt;
                  NoteRecArry[High(NoteRecArry)].LineNumber :=
                    FoundPosArry[FoundPosInstance].NoteLine;
                  Inc(LstInnrNum);
                  NoteRecArry[High(NoteRecArry)].InnerLine := LstInnrNum;
                  NoteRecArry[High(NoteRecArry)].Found := False;
                  DoSort := true;
                end;

                if DoSort then
                begin
                  Comp3 := TComparer<TCPTextRec>.Construct(
                    function(const Left, Right: TCPTextRec): Integer
                    begin
                      Result := TComparer<Integer>.
                        Default.Compare(Left.LineNumber, Right.LineNumber);
                    end);

                  // Sort the data array
                  TArray.Sort<TCPTextRec>(NoteRecArry, Comp3);
                end;

                SetLength(FoundPosArry, 0);
              end;
            end;

            case MINLNGTH of
              40:
                MINLNGTH := 20;
              20:
                MINLNGTH := 10;
              10:
                MINLNGTH := 0;
              0:
                MINLNGTH := -1;
            end;

          end;

          FinalStrLst := TStringList.Create;
          try
            // Sort the found position array by text length
            Comp2 := TComparer<TCPFoundRec>.Construct(
              function(const Left, Right: TCPFoundRec): Integer
              begin
                Result := TComparer<Integer>.Default.Compare(Left.NoteLine,
                  Right.NoteLine);
                if Result = 0 then
                  Result := TComparer<Integer>.Default.Compare(Left.StartChar,
                    Right.StartChar);
              end);

            // Sort the data array
            TArray.Sort<TCPFoundRec>(CPFoundRecs, Comp2);

            { DONE -oChris Bell : looks like its not saving the last line when moving to the next See character split }
            PercList := TStringList.Create;
            TmpList := TStringList.Create;
            try
              FndSecTotal := 0;
              LastNum := -1;
              LastEnd := -2;
              for I := Low(CPFoundRecs) to High(CPFoundRecs) do
              begin
                if CPFoundRecs[I].NoteLine <> LastNum then
                begin
                  // If not the start add the last section
                  if LastNum <> -1 then
                  begin
                    PercList.Add(CPFText);

                    // Add to our out list
                    if CPFoundRecs[I].NoteLine <> (LastNum + 1) then
                    begin
                      // Add what we had
                      if TmpList.Count > 0 then
                      begin
                        Inc(FndSecTotal);
                        OutList.Add('(' + IntToStr(FndSecTotal) + ',0)=' +
                          IntToStr(TmpList.Count));
                        for X := 0 to TmpList.Count - 1 do
                          OutList.Add('(' + IntToStr(FndSecTotal) + ',' +
                            IntToStr(X + 1) + ')=' + TmpList.Strings[X]);
                        TmpList.Clear;
                      end;
                    end;

                  end;

                  // Grab the new line number
                  LastNum := CPFoundRecs[I].NoteLine;

                  // Start setting the text
                  CPFText := CPFoundRecs[I].Text;
                  LastEnd := CPFoundRecs[I].EndChar;

                  // Grab line for out list
                  TmpList.Add(CPFoundRecs[I].Text);
                end
                else
                begin
                  // If characters but up then just add them else add a space
                  if CPFoundRecs[I].StartChar = LastEnd + 1 then
                  begin
                    CPFText := CPFText + CPFoundRecs[I].Text;
                    TmpList[TmpList.Count - 1] := TmpList[TmpList.Count - 1] +
                      CPFoundRecs[I].Text;
                    // TmpList.Add(CPFoundRecs[I].Text);
                  end
                  else
                  begin
                    // PercList.Add(CPFText);
                    CPFText := CPFText + CPFoundRecs[I].Text;

                    // Add to our out list
                    Inc(FndSecTotal);
                    OutList.Add('(' + IntToStr(FndSecTotal) + ',0)=' +
                      IntToStr(TmpList.Count));
                    for X := 0 to TmpList.Count - 1 do
                      OutList.Add('(' + IntToStr(FndSecTotal) + ',' +
                        IntToStr(X + 1) + ')=' + TmpList.Strings[X]);
                    TmpList.Clear;

                    // CPFText := CPFoundRecs[i].Text;
                    TmpList.Add(CPFoundRecs[I].Text);
                  end;
                  LastEnd := CPFoundRecs[I].EndChar;
                end;

                // Add the last record
                if I = High(CPFoundRecs) then
                begin
                  PercList.Add(CPFText);

                  // Add to our out list
                  Inc(FndSecTotal);
                  OutList.Add('(' + IntToStr(FndSecTotal) + ',0)=' +
                    IntToStr(TmpList.Count));
                  for X := 0 to TmpList.Count - 1 do
                    OutList.Add('(' + IntToStr(FndSecTotal) + ',' +
                      IntToStr(X + 1) + ')=' + TmpList.Strings[X]);
                  TmpList.Clear;
                end;
              end;
              OutList.Add('(0)=' + IntToStr(FndSecTotal));

              { CPFText := '';
                for I := Low(CPFoundRecs) to High(CPFoundRecs) do
                begin
                CPFText := CPFText + CPFoundRecs[i].Text;
                if (CPFoundRecs[I].NoteLine = CPFoundRecs[I + 1].NoteLine) and ((CPFoundRecs[I].EndChar +1 ) = CPFoundRecs[I + 1].StartChar) then
                continue
                else
                PercList.Add(CPFText);
                CPFText := '';
                end; }

              TrimBlankLines(PercList, FinalStrLst);
              TmpList.Clear;
              TmpList.Assign(OutList);
              TrimBlankValueLines(TmpList, OutList);

              if Assigned(aPastedRec.OriginalText) then
                TmpList.Assign(aPastedRec.OriginalText)
              else
                TmpList.Assign(aPastedRec.CopiedText);

              BreakUpLongListLines(TmpList,
                EditMonitor.CopyMonitor.BreakUpLimit);

              { DONE : Compare copy text to stiched text - not paste to stich (OriginalText) }
              { DONE : If all text matched with out find text then just make 100 and dont run this }

              for I := 0 to TmpList.Count - 1 do
                TmpList[I] := Trim(TmpList[I]);

              for I := 0 to FinalStrLst.Count - 1 do
                FinalStrLst[I] := Trim(FinalStrLst[I]);

              if AnsiCompareText(TmpList.Text, FinalStrLst.Text) <> 0 then
              begin
                // Perform the Blank line removal and check
                { Temp1 := TStringList.Create;
                  Temp2 := TStringList.Create;
                  try
                  TrimBlankLines(FinalStrLst, Temp1, true);
                  TrimBlankLines(CompareLst, Temp2, true);
                  if AnsiCompareText(temp1.Text, temp2.Text) <> 0 then }
                if Length(FinalStrLst.Text) < fEditMonitor.CopyMonitor.PasteLimit
                then
                  FinalPercent := fEditMonitor.CopyMonitor.LevenshteinDistance
                    (TmpList.Text, FinalStrLst.Text, -1)
                else
                  FinalPercent := 100;
                { else
                  FinalPercent := -1;
                  finally
                  Temp2.Free;
                  temp1.Free;
                  end; }
              end
              else
                FinalPercent := 100;

            finally
              TmpList.Free;
              PercList.Free;
            end;
          finally
            FinalStrLst.Free;
          end;
        finally
          NoteList.Free;
          PasteList.Free;
        end;
      finally
        EditMonitor.StopStopWatch;
        TimeTook := EditMonitor.StopWatch.ElapsedMilliseconds;
      end;
    finally
      if WatchCreated then
      begin
        EditMonitor.StopWatch.Free;
        EditMonitor.StopWatch := nil;
      end;
    end;

  Finally
    Screen.Cursor := RtnCursor;
  end;
end;

procedure TCopyPasteDetails.SetCopyMonitor(Value: TCopyApplicationMonitor);
begin
  if FCopyMonitor <> Value then
  begin
    FCopyMonitor := Value;
    if Assigned(EditMonitor) then
      EditMonitor.CopyMonitor := FCopyMonitor;
  end;
end;

function TCopyPasteDetails.GetCopyPasteEnabled: Boolean;
begin
  Result := Assigned(FCopyMonitor) and FCopyMonitor.Enabled;
end;

function TCopyPasteDetails.GetShowAllPaste: Boolean;
begin
  Result := False;
  if not Assigned(EditMonitor.CopyMonitor) then
    Exit;
  EditMonitor.CopyMonitor.CriticalSection.Enter;
  try
    Result := FShowAllPaste;
  finally
    EditMonitor.CopyMonitor.CriticalSection.Leave;
  end;
end;

{$ENDREGION}

end.
