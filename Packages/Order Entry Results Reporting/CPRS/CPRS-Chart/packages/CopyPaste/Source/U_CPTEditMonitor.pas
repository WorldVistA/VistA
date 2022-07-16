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
  Vcl.Forms, Vcl.Controls, System.IniFiles, System.SyncObjs;

type
  TCopyEditMonitor = class(TComponent)
  private
    FReadyForLoadTransfer: Boolean;
    FCopyToMonitor: TAllowMonitorEvent;
    fItemIEN: Int64;
    FLoadPastedText: TLoadEvent;
    fStopWatch: TStopWatch;
    FPasteToMonitor: TAllowMonitorEvent;
    FRelatedPackage: string;
    FRecalPer: TRecalculateEvent;
    FSaveTheMonitor: TSaveEvent;
    FTrackOnlyObjects: TTrackOnlyCollection;
    FVisualMessage: TVisualMessage;
    FCopyMonitor: TCopyApplicationMonitor;
    Function GetCopyMonitor: TCopyApplicationMonitor;
    procedure SetCopyMonitor(Value: TCopyApplicationMonitor);
    Function GetItemIEN: Int64;
    procedure SetItemIEN(NewItemIEN: Int64);
    procedure SetOurCollection(const Value: TTrackOnlyCollection);
    function GetReadyForLoadTransfer: Boolean;
    procedure SetReadyForLoadTransfer(const Value: Boolean);
    function GetRelatedPackage: string;
    procedure SetRelatedPackage(const Value: string);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    PasteText: TPasteArray;
    procedure ClearPasteArray();
    procedure ClearTheMonitor();
    function CopyToMonitor(Sender: TObject; var AllowMonitor: Boolean;
      Msg: uint): Boolean;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property ItemIEN: Int64 read GetItemIEN write SetItemIEN;
    Property LoadPastedText: TLoadEvent read FLoadPastedText
      write FLoadPastedText;
    function LoadIdentLines(TheRich: TRichEdit; SearchText: TStringList;
      var HighRec: THighlightRecordArray): Boolean;
    Procedure MonitorAllAvailable();
    function PasteToMonitor(Sender: TObject; PasteObj: TObject;
      AllowMonitor: Boolean; ClipInfo: tClipInfo): Boolean;
    procedure SaveTheMonitor(Sender: TObject; ItemID: Int64);
    Function StartStopWatch(): Boolean;
    Function StopStopWatch(): Boolean;
    Function IsTracked(aCustomEdit: TCustomEdit): boolean;
    property StopWatch: TStopWatch read fStopWatch write fStopWatch;
    procedure TransferData(Dest: TCopyEditMonitor);
    procedure TransferPasteText(Dest: TCopyEditMonitor);
    Property VisualMessage: TVisualMessage read FVisualMessage
      write FVisualMessage;

    Property ReadyForLoadTransfer: Boolean read GetReadyForLoadTransfer
      write SetReadyForLoadTransfer;
  published
    property CopyMonitor: TCopyApplicationMonitor read GetCopyMonitor
      write SetCopyMonitor;
    property OnCopyToMonitor: TAllowMonitorEvent read FCopyToMonitor
      write FCopyToMonitor;
    property OnLoadPastedText: TLoadEvent read FLoadPastedText
      write FLoadPastedText;
    property OnPasteToMonitor: TAllowMonitorEvent read FPasteToMonitor
      write FPasteToMonitor;
    property OnSaveTheMonitor: TSaveEvent read FSaveTheMonitor
      write FSaveTheMonitor;
    property RecalculatePercentage: TRecalculateEvent read FRecalPer
      write FRecalPer;
    property RelatedPackage: string read GetRelatedPackage
      write SetRelatedPackage;
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

Function TCopyEditMonitor.CopyToMonitor(Sender: TObject; var AllowMonitor: Boolean;
  Msg: uint): Boolean;
begin
  Result := true;
  if not Assigned(CopyMonitor) then
    Exit;
  if not CopyMonitor.Enabled then
    Exit;
  inherited;
  if Assigned(FCopyToMonitor) then
  begin
    StartStopWatch;
    try
      FCopyToMonitor(Self, AllowMonitor);
    finally
      If StopStopWatch then
        CopyMonitor.LogText('METRIC', 'Allow Copy RPC: ' + fStopWatch.Elapsed);
    end;
  end;
end;

function TCopyEditMonitor.PasteToMonitor(Sender: TObject; PasteObj: TObject;
  AllowMonitor: Boolean; ClipInfo: tClipInfo): Boolean;
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
  Result := False;
  if not Assigned(CopyMonitor) then
    Exit;
  if not CopyMonitor.Enabled then
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
        CopyMonitor.LogText('METRIC', 'Allow Paste RPC: ' + fStopWatch.Elapsed);
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
            for I := Low(CopyMonitor.CPRSClipBoard)
              to High(CopyMonitor.CPRSClipBoard) do
            begin
              if Assigned(CopyMonitor.CPRSClipBoard[I].CopiedText) then
              begin
                If AnsiSameText
                  (Trim(CopyMonitor.CPRSClipBoard[I].CopiedText.Text),
                  Trim(CompareText.Text)) then
                begin
                  if (CopyMonitor.CPRSClipBoard[I].CopiedFromIEN <> ItemIEN)
                  then
                    ProcessPaste := true;
                end;
              end;
            end;

            if not ProcessPaste then
              if (CopyMonitor.WordCount(CompareText.Text) >=
                CopyMonitor.NumberOfWords) then
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
          ClpLckInfo := CopyMonitor.GetClipSource(true);
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

  //Seltext does not add to the undo buffer
  TCustomEdit(PasteObj).Perform(EM_REPLACESEL, WParam(True), LongInt(PChar(PstStr)));
  Result := true; //do not fire the paste message since we just handled it

  if AllowMonitor and ProcessPaste then
  begin
    CopyMonitor.LogText('PASTE', 'Data pasted to IEN(' +
      IntToStr(ItemIEN) + ')');

    if Trim(PasteDetails) <> '' then
      CopyMonitor.LogText('PASTE', 'Cross session clipboard found');

    CopyMonitor.CriticalSection.Enter;
    try
      SetLength(CopyMonitor.FCopyPasteThread,
        Length(CopyMonitor.FCopyPasteThread) + 1);
      CopyMonitor.FCopyPasteThread[High(CopyMonitor.FCopyPasteThread)] :=
        TCopyPasteThread.Create(Trim(PstStr), PasteDetails, ItemIEN,
        CopyMonitor, Sender, ClipInfo);
{$WARN SYMBOL_DEPRECATED OFF}
      CopyMonitor.FCopyPasteThread[High(CopyMonitor.FCopyPasteThread)].Start;
{$WARN SYMBOL_DEPRECATED ON}
    finally
      CopyMonitor.CriticalSection.Leave;
    end;

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
      if not CopyMonitor.DisplayPaste then
        FVisualMessage(Self, Hide_Panel, [true])
      else
        FVisualMessage(Self, ShowHighlight, [true], true);
    end;

  end;

{$WARN SYMBOL_PLATFORM ON}
end;

procedure TCopyEditMonitor.ClearTheMonitor();
begin
  if not Assigned(CopyMonitor) then
    Exit;
  if not CopyMonitor.Enabled then
    Exit;
  CopyMonitor.ClearCopyPasteClipboard;
end;

procedure TCopyEditMonitor.SetItemIEN(NewItemIEN: Int64);
begin
  if not Assigned(CopyMonitor) then
    Exit;
  if not CopyMonitor.Enabled then
    Exit;
  CopyMonitor.CriticalSection.Enter;
  try
    fItemIEN := NewItemIEN;
    // do not show the pannel if there is no note loaded
    if Assigned(FVisualMessage) then
      FVisualMessage(Self, Hide_Panel, [(fItemIEN < 1)]);
  finally
    CopyMonitor.CriticalSection.Leave;
  end;
end;

Function TCopyEditMonitor.GetItemIEN: Int64;
begin
  Result := -1;
  if not Assigned(CopyMonitor) then
    Exit;

  CopyMonitor.CriticalSection.Enter;
  try
    Result := fItemIEN;
  finally
    CopyMonitor.CriticalSection.Leave;
  end;
end;

procedure TCopyEditMonitor.SaveTheMonitor(Sender: TObject; ItemID: Int64);
var
  SaveList, ReturnList: TStringList;
  I, x, LoopCnt, ClipIdx, ReturnCursor: Integer;
  CanContinue: Boolean;
  tmp: Double;
  TmpStr: String;
begin
  if not Assigned(CopyMonitor) then
    Exit;
  if not CopyMonitor.Enabled then
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
        CopyMonitor.CriticalSection.Enter;
        try
          for I := Low(CopyMonitor.FCopyPasteThread)
            to High(CopyMonitor.FCopyPasteThread) do
          begin
            if CopyMonitor.FCopyPasteThread[I].TheadOwner = ItemID then
            begin
              CopyMonitor.LogText('SAVE', 'Thread still exist, can not save');
              CanContinue := false;
              Break;
            end;
          end;
        Finally
          CopyMonitor.CriticalSection.Leave;
        end;
        if not CanContinue then
          Sleep(1);
      end;
    finally
      StatusText('');
      Screen.Cursor := ReturnCursor;
    end;

    StatusText('Bundling Copy/Paste for save');
    try
      ItemIEN := ItemID;

      CopyMonitor.LogText('SAVE', 'Saving paste data for IEN(' +
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
            CopyMonitor.LogText('METRIC', 'Save RPC: ' + StopWatch.Elapsed);
        end;
      end;

      // Pre fill the paste recs so the text is visible
      if Sender is TCopyPasteDetails then
      begin
        if CopyMonitor.DisplayPaste then
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
              SetPiece(TmpStr, '^', 8,
                SaveList.Values[IntToStr(I + 1) + ',-1']);
              SaveList.Values[Piece(ReturnList.Strings[I], '=', 1) + ',0']
                := TmpStr;
            END;

            { DONE : Preload the paste records for this note. This way when the load gets called right away we do not need to re-run this }

            // Since the preload is happening we need to filter the richedit so it matches the best to the load

            // Call the preload since we may not need to try to "Load" since we just ran
            TCopyPasteDetails(Sender).PreLoadPasteRecs(SaveList);

            ReadyForLoadTransfer := true;
          end;
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
  if not(csDesigning in ComponentState) then
  SetLength(PasteText, 0);


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

  if assigned(CopyMonitor) then
    CopyMonitor.RemoveFromMonitorList(self);

  FTrackOnlyObjects.Free;
  inherited;
end;

function TCopyEditMonitor.GetReadyForLoadTransfer: Boolean;
begin
  Result := false;
  if not Assigned(CopyMonitor) then
    Exit;

  CopyMonitor.CriticalSection.Enter;
  try
    Result := FReadyForLoadTransfer;
  finally
    CopyMonitor.CriticalSection.Leave;
  end;
end;

function TCopyEditMonitor.GetRelatedPackage: string;
begin
  Result := '';
  if (csDesigning in ComponentState)  or (csLoading in ComponentState) then
    Result := FRelatedPackage
  else
  begin
    if not Assigned(CopyMonitor) then
    Exit;
    CopyMonitor.CriticalSection.Enter;
    try
      Result := FRelatedPackage;
    finally
      CopyMonitor.CriticalSection.Leave;
    end;
  end;
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

procedure TCopyEditMonitor.SetReadyForLoadTransfer(const Value: Boolean);
begin
  if not Assigned(CopyMonitor) then
    Exit;

  CopyMonitor.CriticalSection.Enter;
  try
    FReadyForLoadTransfer := Value;
  finally
    CopyMonitor.CriticalSection.Leave;
  end;
end;

procedure TCopyEditMonitor.SetRelatedPackage(const Value: string);
begin
  if (csDesigning in ComponentState)  or (csLoading in ComponentState) then
    FRelatedPackage := Value
  else
  begin
      if not Assigned(CopyMonitor) then
    Exit;
    CopyMonitor.CriticalSection.Enter;
    try
      FRelatedPackage := Value;
    finally
      CopyMonitor.CriticalSection.Leave;
    end;
  end;
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
  if not Assigned(CopyMonitor) then
    Exit;
  if not CopyMonitor.Enabled then
    Exit;
  CopyMonitor.LogText('DYNAMIC', 'Monitor All Available');
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

procedure TCopyEditMonitor.Notification(AComponent: TComponent;
  Operation: TOperation);
var
  i: integer;

begin
  inherited;
  if Operation = opRemove then
    for i := 0 to FTrackOnlyObjects.Count - 1 do
      if FTrackOnlyObjects[i].TrackObject = AComponent then
      begin
        FTrackOnlyObjects.Delete(i);
        break;
      end;
end;

procedure TCopyEditMonitor.TransferPasteText(Dest: TCopyEditMonitor);
var
  I: Integer;
begin
  if not Assigned(CopyMonitor) then
    Exit;
  if not CopyMonitor.Enabled then
    Exit;
  CopyMonitor.LogText('DYNAMIC', 'Transfer Data');

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
  if not Assigned(CopyMonitor) then
    Exit;
  if not CopyMonitor.Enabled then
    Exit;
  CopyMonitor.LogText('DYNAMIC', 'Transfer Data');

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

  if Length(PasteText) > 0 then
  begin
    if Assigned(Dest.VisualMessage) then
    begin
      if not Dest.CopyMonitor.DisplayPaste then
        Dest.VisualMessage(Dest, Hide_Panel, [true])
      else
        Dest.VisualMessage(Dest, Show_Panel, [true]);
    end;
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

Function TCopyEditMonitor.IsTracked(aCustomEdit: TCustomEdit): boolean;
var
  TrackObj: TTrackOnlyItem;
  I: integer;
begin
  Result := false;
  if owner is TCopyPasteDetails then
  begin
    if assigned(TCopyPasteDetails(owner).VisualEdit) then
     Result := TCopyPasteDetails(owner).VisualEdit = aCustomEdit;
  end else
  begin
    for I := FTrackOnlyObjects.Count - 1 downto 0 do
    begin
      TrackObj := FTrackOnlyObjects[I];
      if TrackObj.TrackObject = aCustomEdit then
      begin
        result := true;
        break;
      end;
    end;
  end;
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
  Result := false;
  if Assigned(CopyMonitor) and CopyMonitor.Enabled then
  begin
    // First look for the entire text
    if CopyMonitor.WordCount(SearchText.Text) <= 2 then
    begin
      SetLength(HighRec, Length(HighRec) + 1);
      with HighRec[high(HighRec)] do
      begin
        LineToHighlight := StringReplace((SearchText.Text), #10, '',
          [rfReplaceAll]);
        AboveWrdCnt := false;
      end;
      Result := true;
      Exit;
    end;

    Result := (TheRich.FindText(StringReplace((SearchText.Text), #10, '',
      [rfReplaceAll]), 0, Length(TheRich.Text), []) > -1);
    if Result then
    begin
      SetLength(HighRec, Length(HighRec) + 1);
      with HighRec[high(HighRec)] do
      begin
        LineToHighlight := StringReplace((SearchText.Text), #10, '',
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
    //Switching compy monitors so remove the refence (if applicable)
    if assigned(CopyMonitor) then
      CopyMonitor.RemoveFromMonitorList(self);

    FCopyMonitor := Value;
    if not(csDesigning in ComponentState) then
     Value.AddEditMonitorToList(self);
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

Function TCopyEditMonitor.GetCopyMonitor: TCopyApplicationMonitor;
begin
  if (csDesigning in ComponentState)  or (csLoading in ComponentState) then
    Result := FCopyMonitor
  else
  begin
    Result := nil;
    if Assigned(FCopyMonitor) then
    begin
      FCopyMonitor.CriticalSection.Enter;
      try
        Result := FCopyMonitor;
      finally
        FCopyMonitor.CriticalSection.Leave;
      end;
    end;
  end;
end;

{$ENDREGION}

end.

