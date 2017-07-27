{ ******************************************************************************

    ___  __  ____  _  _      _    ____   __   ____  ____  ____
   / __)/  \(  _ \( \/ )    / )  (  _ \ / _\ / ___)(_  _)(  __)
  ( (__(  O )) __/ )  /    / /    ) __//    \\___ \  )(   ) _)
   \___)\__/(__)  (__/    (_/    (__)  \_/\_/(____/ (__) (____)


  Edit Monitor Control unit

  Components:

  TCopyEditMonitor = This control hooks into the desired tCustomEdit
  and monitors the WMCopy and WMPaste messages.

  Functions:

  Register = Registers the control


  { ****************************************************************************** }

unit U_CPTEditMonitor;

interface

uses
  System.Classes, U_CPTAppMonitor, U_CPTExtended, Winapi.Windows, Vcl.ComCtrls,
  U_CptUtils, U_CPTCommon, System.SysUtils,
  Vcl.StdCtrls, Winapi.Messages, ClipBrd, Vcl.Dialogs, System.UITypes,
  Vcl.Forms, Vcl.Controls, System.IniFiles;

type
  /// <summary><para>Non visual control that hooks into a control and monitors copy/paste. Sends data back to <see cref="U_CPTAppMonitor|TCopyApplicationMonitor" /> </para></summary>
  TCopyEditMonitor = class(TComponent)
  private

    FReadyForLoadTransfer: Boolean;

    /// <summary><para>External event to fire when copying</para><para><b>Type: </b><c><see cref="CopyMonitor|TAllowMonitorEvent" /></c></para></summary>
    FCopyToMonitor: TAllowMonitorEvent;

    /// <summary><para>The current document IEN</para><para><b>Type: </b><c>Int64</c></para></summary>
    fItemIEN: Int64;
    /// <summary><para>External event to fire when loading</para><para><b>Type: </b><c><see cref="CopyMonitor|TLoadEvent" /></c></para></summary>
    FLoadPastedText: TLoadEvent;
    /// <summary><para>Stop Watch for metric information</para><para><b>Type: </b><c><see cref="CopyMonitor|TStopWatch" /></c></para></summary>
    fStopWatch: TStopWatch;
    /// <summary><para>External event to fire when pasting</para><para><b>Type: </b><c><see cref="CopyMonitor|TAllowMonitorEvent" /></c></para></summary>
    FPasteToMonitor: TAllowMonitorEvent;
    /// <summary><para>Package related to this monitor</para><para><b>Type: </b><c>string</c></para>
    /// <para><b>Example:</b> if copied from a note (TIU package) this would be <example>8925</example></para></summary>
    FRelatedPackage: string;
    /// <summary><para>External save of recalculated percentage event</para><para><b>Type: </b><c><see cref="CopyMonitor|TRecalculateEvent" /></c></para></summary>
    FRecalPer: TRecalculateEvent;
    /// <summary><para>External event to fire when saving</para><para><b>Type: </b><c><see cref="CopyMonitor|TSaveEvent" /></c></para></summary>
    FSaveTheMonitor: TSaveEvent;
    /// <summary><para>Array of object to monitor</para>
    /// <para><b>Type: </b><c>TCustomEdit</c></para>
    /// <para><b>Note:</b>This is used in addition to FMonitor <example></example></para>
    /// </summary>
    FTrackOnlyObjects: TTrackOnlyCollection;
    /// <summary><para>Call used to determine if visual panel should show. Should only be called from <c><see cref="CopyMonitor|TCopyPasteDetails" /></c></para><para><b>Type: </b><c><see cref="CopyMonitor|TVisualMessage" /></c></para></summary>
    FVisualMessage: TVisualMessage;

    /// <summary><para>Setter for Application monitor</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <param name="value">Application monitor to use<para><b>Type: </b><c><see cref="CopyMonitor|TCopyApplicationMonitor" /></c></para></param>
    procedure SetCopyMonitor(Value: TCopyApplicationMonitor);
    /// <summary>Sets the ItemIEN</summary>
    /// <param name="NewItemIEN">New IEN to set to<para><b>Type: </b><c>Int64</c></para></param>
    procedure SetItemIEN(NewItemIEN: Int64);
    /// <summary><para>Setter for the track items</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <param name="Value">Value<para><b>Type: </b><c>TTrackOnlyCollection</c></para></param>
    procedure SetOurCollection(const Value: TTrackOnlyCollection);

  public
    /// <summary><para>"Overall" component that this should report to</para>
    /// <para><b>Type: </b><c><see cref="CopyMonitor|TCopyApplicationMonitor" /></c></para></summary>
    FCopyMonitor: TCopyApplicationMonitor;
    /// <summary><para>Holds all records of pasted text for the specific document</para>
    /// <para><b>Type: </b><c>Array of <see cref="CopyMonitor|TPasteText" /></c></para></summary>
    PasteText: TPasteArray;
    /// <summary>Clears the <see cref="CopyMonitor|TCopyEditMonitor.PasteText" /></summary>
    procedure ClearPasteArray();
    /// <summary><para>Calls <see cref="CopyMonitor|TCopyApplicationMonitor.ClearCopyPasteClipboard" /></para><para><b>Type: </b><c>Integer</c></para></summary>
    procedure ClearTheMonitor();
    /// <summary><para>Event triggered when data is copied from the monitoring object</para></summary>
    /// <param name="Sender">Object that is making the call<para><b>Type: </b><c>TObject</c></para></param>
    /// <param name="AllowMonitor">Flag indicates if this is excluded or not<para><b>Type: </b><c>Boolean</c></para></param>
    /// <param name="Msg">The message to process<para><b>Type: </b><c>TMessage</c></para></param>
    function CopyToMonitor(Sender: TObject; AllowMonitor: Boolean;
      Msg: uint): Boolean;

    /// <summary>constructor</summary>
    constructor Create(AOwner: TComponent); override;
    /// <summary>Destructor</summary>
    destructor Destroy; override;
    /// <summary><para>The current document's IEN</para><para><b>Type: </b><c>Integer</c></para></summary>
    property ItemIEN: Int64 read fItemIEN write SetItemIEN;
    /// <summary><para>Event to fire when loading the pasted text</para><para><b>Type: </b><c>TLoadEvent</c></para></summary>
    Property LoadPastedText: TLoadEvent read FLoadPastedText
      write FLoadPastedText;
    /// <summary><para>Loads the identifiable text for a given entry (ignore leading and trailing spaces)</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <param name="TheRich">The richedit we want to search in<para><b>Type: </b><c>TRichEdit</c></para></param>
    /// <param name="SearchText">The text we want to find<para><b>Type: </b><c>TStringList</c></para></param>
    /// <param name="HighRec">The higlight record the results fill into<para><b>Type: </b><c> <see cref="CopyMonitor|THighlightRecordArray" /></c></para></param>
    /// <returns><para><b>If we were able to identify the text or not</b><c>Boolean</c></para> - </returns>
    function LoadIdentLines(TheRich: TRichEdit; SearchText: TStringList;
      var HighRec: THighlightRecordArray): Boolean;
    /// <summary><para>Add all available objects to the track items</para><para><b>Type: </b><c>Integer</c></para></summary>
    Procedure MonitorAllAvailable();
    /// <summary><para>Event triggered when data is pasted into the monitoring object</para></summary>
    /// <param name="Sender">Object that is making the call<para><b>Type: </b><c>TObject</c></para></param>
    /// <param name="AllowMonitor">Flag indicates if this is excluded or not<para><b>Type: </b><c>Boolean</c></para></param>
    /// <param name="AllowMonitor">Information about the clipboard source<para><b>Type: </b><c>tClipInfo</c></para></param>
    procedure PasteToMonitor(Sender: TObject; PasteObj: TObject;
      AllowMonitor: Boolean; ClipInfo: tClipInfo);
    /// <summary><para>Save the Monitor for the current document</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <param name="ItemID">Document's IEN<para><b>Type: </b><c>Integer</c></para></param>
    procedure SaveTheMonitor(Sender: TObject; ItemID: Int64);
    Function StartStopWatch(): Boolean;
    Function StopStopWatch(): Boolean;
    property StopWatch: TStopWatch read fStopWatch write fStopWatch;
    /// <summary><para>transfer data between TcopyEditMonitors</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <param name="Dest">Dest<para><b>Type: </b><c>TCopyEditMonitor</c></para></param>
    procedure TransferData(Dest: TCopyEditMonitor);
    procedure TransferPasteText(Dest: TCopyEditMonitor);
    /// <summary><para>Visual message to fire when comming from PasteDetails</para><para><b>Type: </b><c>TVisualMessage</c></para></summary>
    Property VisualMessage: TVisualMessage read FVisualMessage
      write FVisualMessage;

    Property ReadyForLoadTransfer: Boolean read FReadyForLoadTransfer
      write FReadyForLoadTransfer;
  published
    /// <summary><para>The "Parent" component that monitors the application</para><para><b>Type: </b><c><see cref="CopyMonitor|TCopyApplicationMonitor" /></c></para></summary>
    property CopyMonitor: TCopyApplicationMonitor read FCopyMonitor
      write SetCopyMonitor;
    /// <summary><para>Event to fire when copying</para><para><b>Type: </b><c><see cref="CopyMonitor|TAllowMonitorEvent" /></c></para></summary>
    property OnCopyToMonitor: TAllowMonitorEvent read FCopyToMonitor
      write FCopyToMonitor;
    /// <summary><para>Event to fire when loading</para><para><b>Type: </b><c><see cref="CopyMonitor|TSaveEvent" /></c></para></summary>
    property OnLoadPastedText: TLoadEvent read FLoadPastedText
      write FLoadPastedText;
    /// <summary><para>Event to fire when pasting</para><para><b>Type: </b><c><see cref="CopyMonitor|TAllowMonitorEvent" /></c></para></summary>
    property OnPasteToMonitor: TAllowMonitorEvent read FPasteToMonitor
      write FPasteToMonitor;
    /// <summary><para>Event to fire when saving</para><para><b>Type: </b><c><see cref="CopyMonitor|TSaveEvent" /></c></para></summary>
    property OnSaveTheMonitor: TSaveEvent read FSaveTheMonitor
      write FSaveTheMonitor;
    /// <summary>Call to recalculate the percentage </summary>
    property RecalculatePercentage: TRecalculateEvent read FRecalPer
      write FRecalPer;
    /// <summary><para>Package this object's monitor is related to</para><para><b>Type: </b><c><see cref="CopyMonitor|TCopyEditMonitor.FRelatedPackage" /></c></para></summary>
    property RelatedPackage: string read FRelatedPackage write FRelatedPackage;
    /// <summary><para>Collection of tracked items</para><para><b>Type: </b><c>Integer</c></para></summary>
    property TrackOnlyEdits: TTrackOnlyCollection read FTrackOnlyObjects
      write SetOurCollection;
  end;

procedure Register;

Const
  Hide_Panel = $1002;
  ShowHighlight = $1003;
  Show_Panel = $1000;
  ShowAndSelect_Panel = $1001;

implementation

Uses
  U_CPTPasteDetails;

procedure Register;
begin
  RegisterComponents('Copy/Paste', [TCopyEditMonitor]);
end;

{$REGION 'CopyEditMonitor'}

Function TCopyEditMonitor.CopyToMonitor(Sender: TObject; AllowMonitor: Boolean;
  Msg: uint): Boolean;
begin
  Result := false;
  if not Assigned(FCopyMonitor) then
    Exit;
  if not FCopyMonitor.Enabled then
    Exit;
  inherited;
  if Assigned(FCopyToMonitor) then
  begin
    StartStopWatch;
    try
      FCopyToMonitor(Self, AllowMonitor);
    finally
      If StopStopWatch then
        FCopyMonitor.LogText('METRIC', 'Allow Copy RPC: ' + fStopWatch.Elapsed);
    end;
  end;

  // Set the return
  Result := AllowMonitor;

  if AllowMonitor then
  begin
    CopyMonitor.CopyToCopyPasteClipboard(Trim(TCustomEdit(Sender).SelText),
      RelatedPackage, ItemIEN);
    if (Msg = WM_CUT) then
      TCustomEdit(Sender).SelText := '';
  end;
end;

procedure TCopyEditMonitor.PasteToMonitor(Sender: TObject; PasteObj: TObject;
  AllowMonitor: Boolean; ClipInfo: tClipInfo);
const
  Max_Retry = 3;
  Hlp_Msg = 'System Error: %s' + #13#10 +
    'There was a problem accessing the clipboard please try again.' + #13#10 +
    #13#10 + 'The following application has a lock on the clipboard:' + #13#10 +
    'App Title: %s' + #13#10 + 'App Name: %s' + #13#10 + #13#10 +
    'If this problem persists please close %s and then try again. If you are still experiencing issues please contact your local CPRS help desk.';
Var
  PasteDetails: String;
  dwSize: DWORD;
  gMem: HGLOBAL;
  lp: Pointer;
  I, RetryCnt: Integer;
  ProcessPaste, TryPst: Boolean;
  CompareText: TStringList;
  PstStr, TmpStr: String;
  ClpLckInfo: tClipInfo;
  Tag: string;

begin
  if not Assigned(FCopyMonitor) then
    Exit;
  if not FCopyMonitor.Enabled then
    Exit;
{$WARN SYMBOL_PLATFORM OFF}
  inherited;
  if Assigned(FPasteToMonitor) then
  begin
    StartStopWatch;
    try
      FPasteToMonitor(Self, AllowMonitor);
    finally
      If StopStopWatch then
        FCopyMonitor.LogText('METRIC', 'Allow Paste RPC: ' +
          fStopWatch.Elapsed);
    end;
  end;

  PasteDetails := '';
  RetryCnt := 1;
  ProcessPaste := false;
  TryPst := true;

  // Grab our data from the clipboard, Try Three times
  while TryPst do
  begin
    while (RetryCnt <= Max_Retry) and TryPst do
    begin
      Try
        // Get the clipboard text
        PstStr := Clipboard.AsText;

        // Get the details from the clipboard
        if Clipboard.HasFormat(Self.CopyMonitor.CFCopyPaste) then
        begin
          gMem := Clipboard.GetAsHandle(Self.CopyMonitor.CFCopyPaste);
          try
            Win32Check(gMem <> 0);
            lp := GlobalLock(gMem);
            Win32Check(lp <> nil);
            dwSize := GlobalSize(gMem);
            if dwSize <> 0 then
            begin
              SetString(PasteDetails, PAnsiChar(lp), dwSize - 1);
            end;
          finally
            GlobalUnlock(gMem);
          end;
        end;

        // Check for plain text
        if Clipboard.HasFormat(CF_TEXT) then
        begin
          CompareText := TStringList.Create;
          try
            CompareText.Text := Trim(PstStr);
            for I := Low(FCopyMonitor.CPRSClipBoard)
              to High(FCopyMonitor.CPRSClipBoard) do
            begin
              if Assigned(FCopyMonitor.CPRSClipBoard[I].CopiedText) then
              begin
                If AnsiSameText
                  (Trim(FCopyMonitor.CPRSClipBoard[I].CopiedText.Text),
                  Trim(CompareText.Text)) then
                begin
                  if (FCopyMonitor.CPRSClipBoard[I].CopiedFromIEN <> ItemIEN) then
                    ProcessPaste := true;
                end;
              end;
            end;

            if not ProcessPaste then
              if (FCopyMonitor.WordCount(CompareText.Text) >=
                FCopyMonitor.NumberOfWords) then
                ProcessPaste := true;

          finally
            CompareText.Free;
          end;
        end;
        TryPst := false;
      Except
        Inc(RetryCnt);
        Sleep(100);
        If RetryCnt > Max_Retry then
          ClpLckInfo := FCopyMonitor.GetClipSource(true);
      End;
    end;

    // If our retry count is greater than the max we were unable to grab the paste
    if RetryCnt > Max_Retry then
    begin
      TmpStr := Format(Hlp_Msg, [SysErrorMessage(GetLastError),
        ClpLckInfo.AppTitle, ClpLckInfo.AppName, ClpLckInfo.AppName]);
      if TaskMessageDlg('Clipboard Locked', TmpStr, mtError,
        [mbRetry, mbCancel], -1) = mrRetry then
      begin
        // reset the loop variables
        RetryCnt := 1;
        TryPst := true;
      end
      else
        Exit;
    end;

  end;

  Tag := '';
  TCustomEdit(PasteObj).SelText := PstStr;

  if AllowMonitor and ProcessPaste then
  begin
    FCopyMonitor.LogText('PASTE', 'Data pasted to IEN(' +
      IntToStr(ItemIEN) + ')');

    if Trim(PasteDetails) <> '' then
      FCopyMonitor.LogText('PASTE', 'Cross session clipboard found');

    SetLength(FCopyMonitor.FCopyPasteThread,
      Length(FCopyMonitor.FCopyPasteThread) + 1);
    FCopyMonitor.FCopyPasteThread[High(FCopyMonitor.FCopyPasteThread)] :=
      TCopyPasteThread.Create(Trim(PstStr), PasteDetails, ItemIEN, FCopyMonitor,
      Sender, ClipInfo);
{$WARN SYMBOL_DEPRECATED OFF}
    FCopyMonitor.FCopyPasteThread[High(FCopyMonitor.FCopyPasteThread)].Start;
{$WARN SYMBOL_DEPRECATED ON}
    SetLength(PasteText, Length(PasteText) + 1);
    PasteText[High(PasteText)].DateTimeOfPaste :=
      FloatToStr(DateTimeToFMDateTime(Now));
    PasteText[High(PasteText)].Status := PasteNew;
    PasteText[High(PasteText)].PasteDBID := -1;
    PasteText[High(PasteText)].PasteNoteIEN := ItemIEN;
    PasteText[High(PasteText)].PastedText := TStringList.Create;
    PasteText[High(PasteText)].PastedText.Text := Trim(PstStr);
    PasteText[High(PasteText)].IdentFired := false;

    if Assigned(FVisualMessage) then
    begin
      if not FCopyMonitor.DisplayPaste then
        FVisualMessage(Self, Hide_Panel, [true])
      else
        FVisualMessage(Self, ShowHighlight, [true]);
    end;

  end;

{$WARN SYMBOL_PLATFORM ON}
end;

procedure TCopyEditMonitor.ClearTheMonitor();
begin
  if not Assigned(FCopyMonitor) then
    Exit;
  if not FCopyMonitor.Enabled then
    Exit;
  CopyMonitor.ClearCopyPasteClipboard;
end;

procedure TCopyEditMonitor.SetItemIEN(NewItemIEN: Int64);
begin
  if not Assigned(FCopyMonitor) then
    Exit;
  if not FCopyMonitor.Enabled then
    Exit;
  fItemIEN := NewItemIEN;
  // do not show the pannel if there is no note loaded
  if Assigned(FVisualMessage) then
    FVisualMessage(Self, Hide_Panel, [(fItemIEN < 1)]);
end;

procedure TCopyEditMonitor.SaveTheMonitor(Sender: TObject; ItemID: Int64);
var
  SaveList, ReturnList: TStringList;
  I, x, LoopCnt, ClipIdx, ReturnCursor: Integer;
  CanContinue: Boolean;
  tmp: Double;
  TmpStr: String;
begin
  if not Assigned(FCopyMonitor) then
    Exit;
  if not FCopyMonitor.Enabled then
    Exit;

  SaveList := TStringList.Create;
  ReturnList := TStringList.Create;
  try
    inherited;

    CanContinue := false;
    ReturnCursor := Screen.Cursor;
    Screen.Cursor := crHourGlass;
    StatusText('Waiting for Copy/Paste threads');
    try
      while not CanContinue do
      begin
        CanContinue := true;
        for I := Low(FCopyMonitor.FCopyPasteThread)
          to High(FCopyMonitor.FCopyPasteThread) do
        begin
          if FCopyMonitor.FCopyPasteThread[I].TheadOwner = ItemID then
          begin
            FCopyMonitor.LogText('SAVE', 'Thread still exist, can not save');
            CanContinue := false;
            Break;
          end;
        end;
      end;
    finally
      StatusText('');
      Screen.Cursor := ReturnCursor;
    end;

    StatusText('Bundling Copy/Paste for save');
    try
      ItemIEN := ItemID;

      FCopyMonitor.LogText('SAVE', 'Saving paste data for IEN(' +
        IntToStr(ItemID) + ')');

      // get information about new paste
      CopyMonitor.SaveCopyPasteClipboard(Self, SaveList);

      // check for modified entries
      if Sender is TCopyPasteDetails then
        TCopyPasteDetails(Sender).CheckForModifiedPaste(SaveList);

      if Assigned(FSaveTheMonitor) then
      begin
        StartStopWatch;
        try
          FSaveTheMonitor(Self, SaveList, ReturnList);
        finally
          If StopStopWatch then
            FCopyMonitor.LogText('METRIC',
              'Save RPC: ' + FCopyMonitor.StopWatch.Elapsed);
        end;
      end;

      // Pre fill the paste recs so the text is visible
      if Sender is TCopyPasteDetails then
      begin
        if ReturnList.Count > 0 then
        begin
          // Need to gather the paste rec index for the update
          ClipIdx := -1;

          LoopCnt := StrToIntDef(SaveList.Values['TotalToSave'], 0);
          for I := 1 to LoopCnt do
          begin
            for x := high(CopyMonitor.CPRSClipBoard)
              downto low(CopyMonitor.CPRSClipBoard) do
            begin
              if CopyMonitor.CPRSClipBoard[x].SaveItemID = I then
              begin
                ClipIdx := x;
                Break;
              end;
            end;

            if ClipIdx > -1 then
            begin
              for x := Low(PasteText) to High(PasteText) do
              begin
                tmp := StrToFloatDef(PasteText[x].DateTimeOfPaste, 0) -
                  StrToFloatDef(CopyMonitor.CPRSClipBoard[ClipIdx]
                  .DateTimeOfPaste, 0);
                if (PasteText[x].Status = PasteNew) and ((tmp * 1) < 1000) and
                  (AnsiCompareText(CopyMonitor.CPRSClipBoard[ClipIdx]
                  .CopiedText.Text, PasteText[x].PastedText.Text) = 0) then
                begin
                  SaveList.Add(IntToStr(I) + ',ARRYIDX=' + IntToStr(x));
                  Break;
                end;
              end;
            end;
          end;

          // Take the return and update our "list" for the preload
          for I := 0 to ReturnList.Count - 1 do
          BEGIN
            TmpStr := Piece(ReturnList.Strings[I], '=', 2);
            SetPiece(TmpStr, '^', 8, SaveList.Values[IntToStr(I + 1) + ',-1']);
            SaveList.Values[Piece(ReturnList.Strings[I], '=', 1) + ',0']
              := TmpStr;
          END;

          { DONE : Preload the paste records for this note. This way when the load gets called right away we do not need to re-run this }

          // Since the preload is happening we need to filter the richedit so it matches the best to the load

          // Call the preload since we may not need to try to "Load" since we just ran
          TCopyPasteDetails(Sender).PreLoadPasteRecs(SaveList);

          FReadyForLoadTransfer := true;
        end;
      end;

      // Old code to run the recalculate (no longer needed)
      { if ReturnList.Count > 1 then
        begin
        // there was an error so dont recalculate
        if StrToIntDef(ReturnList[0], 0) > 1 then
        begin

        FCopyMonitor.LogText('SAVE', 'Recalculating percentage for IEN(' +
        IntToStr(ItemID) + ')');
        // Recaulculate the after save percentage
        SaveList.Clear;
        if Sender is TCopyPasteDetails then
        CopyMonitor.RecalPercentage(ReturnList, SaveList,
        TCopyPasteDetails(Sender).EditMonitor.PasteText);

        if Assigned(FRecalPer) then
        begin
        StartStopWatch;
        try
        FRecalPer(Self, SaveList);
        finally
        If StopStopWatch then
        CopyMonitor.LogText('METRIC',
        'Recal RPC: ' + CopyMonitor.StopWatch.Elapsed);
        end;
        end;
        end;
        end; }

      // we are done so clear
      CopyMonitor.ClearCopyPasteClipboard();

    finally
      StatusText('');
    end;
  finally
    ReturnList.Free;
    SaveList.Free;
  end;
end;

constructor TCopyEditMonitor.Create(AOwner: TComponent);
var
  I: Integer;
begin
  inherited Create(AOwner);
  FVisualMessage := nil;
  FTrackOnlyObjects := TTrackOnlyCollection.Create(Self);
  SetLength(PasteText, 0);

  if not(csDesigning in ComponentState) then
  begin
    for I := 1 to ParamCount do
    begin
      if UpperCase(ParamStr(I)) = 'CPLOG' then
      begin
        fStopWatch := TStopWatch.Create(Self, true);
        Break;
      end
      else if UpperCase(ParamStr(I)) = 'CPLOGDEBUG' then
      begin
        fStopWatch := TStopWatch.Create(Self, true);
        Break;
      end;
    end;
  end;
end;

destructor TCopyEditMonitor.Destroy;
var
  I: Integer;
begin
  for I := 0 to TrackOnlyEdits.Count - 1 do
  begin
    with TrackOnlyEdits.GetItem(I) do
    begin
      if not(csDesigning in ComponentState) then
        TrackObject.WindowProc := TrackObjectOrigWndProc;
      TrackObject := nil;
    end;
  end;
  ClearPasteArray;

  if Assigned(fStopWatch) then
    fStopWatch.Free;
  FTrackOnlyObjects.Free;
  inherited;
end;

procedure TCopyEditMonitor.ClearPasteArray();
Var
  I, x: Integer;
begin

  for I := high(PasteText) downto Low(PasteText) do
  begin
    for x := Low(PasteText[I].GroupItems) to High(PasteText[I].GroupItems) do
      PasteText[I].GroupItems[x].GroupText.Free;
    SetLength(PasteText[I].GroupItems, 0);

    SetLength(PasteText[I].HiglightLines, 0);
    PasteText[I].PastedText.Free;

  end;
  SetLength(PasteText, 0);
end;

procedure TCopyEditMonitor.SetOurCollection(const Value: TTrackOnlyCollection);
begin
  FTrackOnlyObjects.Assign(Value);
end;

Procedure TCopyEditMonitor.MonitorAllAvailable();
var
  list: TList;
  I, idx: Integer;
  Control: TWinControl;
  Item: TTrackOnlyItem;

  function OwnerCheck(Component: TComponent): Boolean;
  var
    root: TComponent;
  begin
    Result := false;
    root := Component;
    while Assigned(root) do
    begin
      if root = owner then
      begin
        Result := true;
        Exit;
      end;
      root := root.owner;
    end;
  end;

  procedure Update(Component: TWinControl);
  var
    I: Integer;
  begin
    if (((not Assigned(Component.Parent)) or (csAcceptsControls
      in Component.Parent.ControlStyle)) and (Component is TCustomEdit)) then
      list.Add(Component);
    for I := 0 to Component.ControlCount - 1 do
    begin
      if Component.Controls[I] is TWinControl then
      begin
        Control := TWinControl(Component.Controls[I]);
        if (not Assigned(Control.owner)) or OwnerCheck(Control) then
          Update(Control);
      end;
    end;
  end;

begin
  if not Assigned(FCopyMonitor) then
    Exit;
  if not FCopyMonitor.Enabled then
    Exit;
  FCopyMonitor.LogText('DYNAMIC', 'Monitor All Available');
  list := TList.Create;
  try
    // Load our list with the components
    if (owner is TWinControl) and
      ([csLoading, csDesignInstance] * owner.ComponentState = []) then
      Update(TWinControl(owner));

    // Filter out items that exist
    for I := FTrackOnlyObjects.Count - 1 downto 0 do
    begin
      Item := FTrackOnlyObjects[I];

      if Assigned(Item.TrackObject) then
      begin
        idx := list.IndexOf(Item.TrackObject);
        if idx < 0 then
          Item.Free
        else
          list.delete(idx);
      end
      else
        Item.Free;
    end;
    // Item := nil;
    for I := 0 to list.Count - 1 do
    begin
      Item := FTrackOnlyObjects.Add;
      Item.TrackObject := TCustomEdit(list[I]);
    end;

  finally
    list.Free;
  end;
end;

procedure TCopyEditMonitor.TransferPasteText(Dest: TCopyEditMonitor);
var
  I: Integer;
begin
  if not Assigned(FCopyMonitor) then
    Exit;
  if not FCopyMonitor.Enabled then
    Exit;
  FCopyMonitor.LogText('DYNAMIC', 'Transfer Data');

  Dest.ClearPasteArray;

  for I := Low(PasteText) to High(PasteText) do
  begin
    SetLength(Dest.PasteText, Length(Dest.PasteText) + 1);
    Dest.PasteText[High(Dest.PasteText)].Assign(PasteText[I]);
  end;

  if Assigned(Dest.VisualMessage) then
  begin
    if not Dest.CopyMonitor.DisplayPaste then
      Dest.VisualMessage(Dest, Hide_Panel, [true])
    else
      Dest.VisualMessage(Dest, Show_Panel, [true]);
  end;
end;

procedure TCopyEditMonitor.TransferData(Dest: TCopyEditMonitor);
Var
  I: Integer;
begin
  if not Assigned(FCopyMonitor) then
    Exit;
  if not FCopyMonitor.Enabled then
    Exit;
  FCopyMonitor.LogText('DYNAMIC', 'Transfer Data');

  // First move all IENs over
  for I := Low(CopyMonitor.CPRSClipBoard) to High(CopyMonitor.CPRSClipBoard) do
  begin
    if CopyMonitor.CPRSClipBoard[I].PasteToIEN = Self.ItemIEN then
    begin
      CopyMonitor.CPRSClipBoard[I].PasteToIEN := Dest.ItemIEN;
    end;
  end;

  // Now move the paste text over
  for I := Low(PasteText) to High(PasteText) do
  begin
    SetLength(Dest.PasteText, Length(Dest.PasteText) + 1);
    Dest.PasteText[High(Dest.PasteText)].DateTimeOfPaste :=
      PasteText[I].DateTimeOfPaste;
    Dest.PasteText[High(Dest.PasteText)].Status := PasteText[I].Status;
    Dest.PasteText[High(Dest.PasteText)].PasteDBID := -1;
    Dest.PasteText[High(Dest.PasteText)].PasteNoteIEN := Dest.ItemIEN;
    Dest.PasteText[High(Dest.PasteText)].PastedText := TStringList.Create;
    Dest.PasteText[High(Dest.PasteText)].PastedText.Text :=
      PasteText[I].PastedText.Text;
    Dest.PasteText[High(Dest.PasteText)].IdentFired := false;
  end;

  if Assigned(Dest.VisualMessage) then
  begin
    if not Dest.CopyMonitor.DisplayPaste then
      Dest.VisualMessage(Dest, Hide_Panel, [true])
    else
      Dest.VisualMessage(Dest, Show_Panel, [true]);
  end;

end;

Function TCopyEditMonitor.StartStopWatch(): Boolean;
begin
  Result := Assigned(fStopWatch);
  if Result then
    fStopWatch.Start;
end;

Function TCopyEditMonitor.StopStopWatch(): Boolean;
begin
  Result := Assigned(fStopWatch);
  if Result then
    fStopWatch.Stop;
end;

// Use this to search and ignore spaces and lines less than 3 words
function TCopyEditMonitor.LoadIdentLines(TheRich: TRichEdit;
  SearchText: TStringList; var HighRec: THighlightRecordArray): Boolean;
var
  I, LastSrchPos: Integer;
  cloneArray: Boolean;
  TempHighlightArray: array of tHighlightRecord;
  HashSearch: THashedStringList;
begin
  { if not Assigned(FCopyMonitor) then
    Exit;
    if not FCopyMonitor.Enabled then
    Exit; }
  Result := false;
  if Assigned(FCopyMonitor) and FCopyMonitor.Enabled then
  begin
    // First look for the entire text
    Result := (TheRich.FindText(StringReplace(Trim(SearchText.Text), #10, '',
      [rfReplaceAll]), 0, Length(TheRich.Text), []) > -1);
    if Result then
    begin
      SetLength(HighRec, Length(HighRec) + 1);
      with HighRec[high(HighRec)] do
      begin
        LineToHighlight := StringReplace(Trim(SearchText.Text), #10, '',
          [rfReplaceAll]);
        AboveWrdCnt := true;
      end;
    end
    else
    begin
      // Next look for the broken up text
      SetLength(TempHighlightArray, 0);
      cloneArray := false;
      LastSrchPos := 0;
      // Move list into has for faster search
      HashSearch := THashedStringList.Create;
      try
        HashSearch.Assign(SearchText);
        for I := 0 to HashSearch.Count - 1 do
        begin
          if StringReplace(Trim(HashSearch[I]), #10, '', [rfReplaceAll]) = ''
          then
            Continue;
          SetLength(TempHighlightArray, Length(TempHighlightArray) + 1);
          with TempHighlightArray[High(TempHighlightArray)] do
          begin
            LineToHighlight := StringReplace(Trim(HashSearch[I]), #10, '',
              [rfReplaceAll]);

            if CopyMonitor.WordCount(LineToHighlight) > 2 then
            begin
              AboveWrdCnt := true;
              LastSrchPos := TheRich.FindText(LineToHighlight, LastSrchPos,
                Length(TheRich.Text), []);

              if LastSrchPos = -1 then
              begin
                // If one line greater than 2 words doesnt match the whole thing doesnt
                cloneArray := false;
                Break;
              end
              else
                cloneArray := true;
            end
            else
              AboveWrdCnt := false;
          end;
        end;
      finally
        HashSearch.Free;
      end;

      // Add to highlight array (meaning we can show these)
      if cloneArray then
      begin
        for I := Low(TempHighlightArray) to High(TempHighlightArray) do
        begin
          SetLength(HighRec, Length(HighRec) + 1);
          HighRec[high(HighRec)].LineToHighlight := TempHighlightArray[I]
            .LineToHighlight;
          HighRec[high(HighRec)].AboveWrdCnt := TempHighlightArray[I]
            .AboveWrdCnt;
        end;
      end;
      SetLength(TempHighlightArray, 0);
      Result := cloneArray;
    end;
  end;
end;

procedure TCopyEditMonitor.SetCopyMonitor(Value: TCopyApplicationMonitor);
var
  ObjToUse: TCopyPasteDetails;
begin
  if FCopyMonitor <> Value then
  begin
    FCopyMonitor := Value;
    if owner is TCopyPasteDetails then
    begin
      ObjToUse := owner as TCopyPasteDetails;

      if not(csDesigning in ComponentState) then
      begin
        if ObjToUse.SyncSizes then
        begin
          with FCopyMonitor do
          begin
            SetLength(fSyncSizeList, Length(fSyncSizeList) + 1);
            fSyncSizeList[High(fSyncSizeList)] := TCopyPasteDetails(ObjToUse);
          end;
        end;
      end;
    end;
  end;
end;

{$ENDREGION}

end.
