unit fxBroker;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DateUtils, ORNet, ORFn, rMisc, ComCtrls, Buttons, ExtCtrls,
  ORCtrls, ORSystem, fBase508Form, VA508AccessibilityManager,
  Winapi.RichEdit, Vcl.Menus, fFrame, Vcl.ImgList, Vcl.ToolWin
 {$IFDEF VER240}{$ELSE}, System.ImageList{$ENDIF}
  ;

const
  UM_REFRESH_RPC = WM_APP + 1;

type
  TfrmBroker = class(TfrmBase508Form)
    pnlTop: TORAutoPanel;
    lblMaxCalls: TLabel;
    txtMaxCalls: TCaptionEdit;
    udMax: TUpDown;
    memData: TRichEdit;
    lblCallID: TStaticText;
    pnlMain: TPanel;
    PnlDebug: TPanel;
    SplDebug: TSplitter;
    PnlSearch: TPanel;
    lblSearch: TLabel;
    pnlSubSearch: TPanel;
    SearchTerm: TEdit;
    btnSearch: TButton;
    PnlDebugResults: TPanel;
    lblDebug: TLabel;
    ResultList: TListView;
    ScrollBox1: TScrollBox;
    DbugPageCtrl: TPageControl;
    SrchPage: TTabSheet;
    WatchPage: TTabSheet;
    WatchList: TListView;
    ToolBar1: TToolBar;
    c: TImageList;
    tlAddWatch: TToolButton;
    tlDelWatch: TToolButton;
    ToolButton1: TToolButton;
    tlClrWatch: TToolButton;
    ProgressBar1: TProgressBar;
    PopupMenu1: TPopupMenu;
    AlignLeft1: TMenuItem;
    AlignRight1: TMenuItem;
    AlignBottom1: TMenuItem;
    AlignTop1: TMenuItem;
    N1: TMenuItem;
    Undock1: TMenuItem;
    LivePage: TTabSheet;
    LiveList: TListView;
    ToolBar3: TToolBar;
    ToolButton2: TToolButton;
    ToolButton6: TToolButton;
    tlFlag: TToolButton;
    Panel1: TPanel;
    cmdNext: TBitBtn;
    cmdPrev: TBitBtn;
    btnRLT: TBitBtn;
    btnAdvTools: TBitBtn;
    procedure cmdPrevClick(Sender: TObject);
    procedure cmdNextClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnRLTClick(Sender: TObject);
    procedure LoadWatchList();
    procedure btnSearchClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SearchTermChange(Sender: TObject);
    procedure SearchTermKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnAdvToolsClick(Sender: TObject);
    procedure tlAddWatchClick(Sender: TObject);
    procedure tlDelWatchClick(Sender: TObject);
    procedure tlClrWatchClick(Sender: TObject);
    procedure FormStartDock(Sender: TObject; var DragObject: TDragDockObject);
    procedure FillLiveView(Inital: Boolean = False);
    procedure tlFlagClick(Sender: TObject);
    procedure LiveListAdvancedCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
      Stage: TCustomDrawStage; var DefaultDraw: Boolean);
    procedure ToolButton2Click(Sender: TObject);
    procedure AlignClick(Sender: TObject);
    procedure LiveListSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
  private
    { Private declarations }
    FRetained: Integer;
    FCurrent: Integer;
    LiveArray: Array of TRpcRecord;
    FlagIdent: Integer;
    procedure InitalizeCloneArray();
    procedure HighlightRichEdit(StartChar, EndChar: Integer;
      HighLightColor: TColor);
    procedure OnRefreshRPCRequest();
    procedure AlignBroker(AlignStyle: TAlign);
    procedure SyncList(index: Integer);
    procedure LoadSelected(LookupArray: Array of TRpcRecord;aList:TListView);
  public
    { Public declarations }

  end;



procedure ShowBroker;

var
  frmBroker: TfrmBroker;
  splLive: TSplitter;

implementation

{$R *.DFM}

procedure ShowBroker;
begin
  frmBroker := TfrmBroker.Create(Application);
  // try
  ResizeAnchoredFormToFont(frmBroker);
  with frmBroker do
  begin
    FRetained := RetainedRPCCount - 1;
    FCurrent := FRetained;
    LoadRPCData(memData.Lines, FCurrent);
    if (Length(fFrame.WatchArray) > 0) then
      LoadWatchList;
    memData.SelStart := 0;
    lblCallID.Caption := 'Last Call Minus: ' + IntToStr(FRetained - FCurrent);
    // ShowModal;
    Show;
  end;
  // finally
  // frmBroker.Release;
  // end;
end;

Procedure TfrmBroker.SyncList(index: Integer);
var
 I: Integer;
begin
 for i := Low(LiveArray) to High(LiveArray) do
 begin
   if LiveArray[i].UCallListIndex = Index then
   begin
     LiveList.ClearSelection;
     LiveList.Items[LiveArray[i].ResultListIndex].Selected := true;
     break;
   end;

 end;
end;

procedure TfrmBroker.cmdPrevClick(Sender: TObject);
begin
  FCurrent := HigherOf(FCurrent - 1, 0);
  memData.SelStart := 0;
  LoadRPCData(memData.Lines, FCurrent);
     lblCallID.Caption := 'Last Call Minus: ' + IntToStr(FRetained - FCurrent);
  if PnlDebug.Visible then
   SyncList(FCurrent)
  else begin
  //   LoadRPCData(memData.Lines, FCurrent);
  //   lblCallID.Caption := 'Last Call Minus: ' + IntToStr(FRetained - FCurrent);
   end;
end;

procedure TfrmBroker.cmdNextClick(Sender: TObject);
begin
  FCurrent := LowerOf(FCurrent + 1, FRetained);
  memData.SelStart := 0;
  LoadRPCData(memData.Lines, FCurrent);
     lblCallID.Caption := 'Last Call Minus: ' + IntToStr(FRetained - FCurrent);
  if PnlDebug.Visible then
   SyncList(FCurrent)
  else begin
   //
  end;
end;

procedure TfrmBroker.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SetRetainedRPCMax(StrToIntDef(txtMaxCalls.Text, 5));
  frmBroker.Release;
  FreeAndNil(splLive);
  SetAfterRPCEvent(nil);
end;

procedure TfrmBroker.FormResize(Sender: TObject);
begin
  Refresh;
end;

procedure TfrmBroker.FormStartDock(Sender: TObject;
  var DragObject: TDragDockObject);
begin
  inherited;
  DragObject := TDragDockObjectEx.Create(Self);
  DragObject.Brush.Color := clAqua; // this will display a red outline
end;

procedure TfrmBroker.FormCreate(Sender: TObject);
begin
  udMax.Position := GetRPCMax;
  Width := Width - PnlDebug.Width + SplDebug.Width;
  FlagIdent := -1;
end;

procedure TfrmBroker.FormDestroy(Sender: TObject);
Var
  I: Integer;
begin
  for I := Low(LiveArray) to High(LiveArray) do
    LiveArray[I].RPCText.Free;
  SetLength(LiveArray, 0);
end;

procedure TfrmBroker.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    Close;
  end;
end;

procedure TfrmBroker.HighlightRichEdit(StartChar, EndChar: Integer;
  HighLightColor: TColor);
var
  Format: CHARFORMAT2;
begin
  memData.SelStart := StartChar;
  memData.SelLength := EndChar;

  // Set the background color
  FillChar(Format, SizeOf(Format), 0);
  Format.cbSize := SizeOf(Format);
  Format.dwMask := CFM_BACKCOLOR;
  Format.crBackColor := HighLightColor;
  memData.Perform(EM_SETCHARFORMAT, SCF_SELECTION, Longint(@Format));
end;

procedure TfrmBroker.LiveListAdvancedCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  Stage: TCustomDrawStage; var DefaultDraw: Boolean);
begin
 if Item.Caption = '1' then
 begin
    sender.Canvas.Font.Color :=  clRed;
    sender.Canvas.brush.Color :=  clYellow;
    sender.Canvas.Font.Style := [fsbold];
  end else begin
   sender.Canvas.Font.Color :=  clWindowText;
   sender.Canvas.brush.Color :=  clWindow;
   sender.Canvas.Font.Style := [];
  end;
end;

procedure TfrmBroker.LiveListSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  inherited;
  if assigned(Item) and Selected then
    begin
      if Sender = WatchList then
        LoadSelected(fFrame.WatchArray,TListView(Sender))
      else
        LoadSelected(LiveArray,TListView(Sender));
    end;
end;

procedure TfrmBroker.LoadWatchList();
var
  I, ReturnCursor: Integer;
  ListItem: TListItem;
  found: Boolean;
begin
  ReturnCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    InitalizeCloneArray;
    if not PnlDebug.Visible then
    begin
      PnlDebug.Visible := true;
      Width := Width + PnlDebug.Width + SplDebug.Width;
      SplDebug.Visible := true;
    end;
    // Clear all
    WatchList.Clear;

    found := False;
    for I := Low(fFrame.WatchArray) to High(fFrame.WatchArray) do
    begin
      with fFrame.WatchArray[I] do
      begin
        ListItem := WatchList.Items.Add;
        ListItem.Caption := RpcName;
        ResultListIndex := ListItem.Index;
        if not found then
        begin
          WatchList.Column[0].Width := -1;
          found := true;
        end;
      end;
    end;
  finally
    Screen.Cursor := ReturnCursor;
  end;
end;

procedure TfrmBroker.AlignBroker(AlignStyle: TAlign);
begin
  Self.Align := AlignStyle;
  if AlignStyle <> alNone then
  begin
    Self.Parent := frmFrame;
    Self.Align := AlignStyle;

    // create the splitter
    If not assigned(splLive) then
    begin
      splLive := TSplitter.Create(frmFrame);
      splLive.Parent := frmFrame;
      splLive.Color := clMedGray;
    end;
    splLive.Align := AlignStyle;
    Self.BorderStyle := bsNone;

  end
  else
  begin
    Self.Parent := nil;
    FreeAndNil(splLive);
    PnlDebug.Align := alLeft;
    SplDebug.Align := alLeft;
    SplDebug.Left := Self.Width;
    pnlMain.Align := alClient;
    Self.BorderStyle := bsSizeable;
  end;

  if AlignStyle = alLeft then
  begin
    Self.Left := frmFrame.Left;
    splLive.Width := 5;
    splLive.Left := Self.Width;
    PnlDebug.Align := alTop;
    SplDebug.Align := alTop;
    SplDebug.Top := Self.Height;
    pnlMain.Align := alClient;

  end
  else if AlignStyle = alRight then
  begin
    Self.Left := frmFrame.Width;
    splLive.Width := 5;
    splLive.Left := Self.Left;
    PnlDebug.Align := alTop;
    SplDebug.Align := alTop;
    SplDebug.Top := Self.Height;
    pnlMain.Align := alClient;

  end
  else if AlignStyle = alBottom then
  begin
    Self.Top := frmFrame.Height;
    splLive.Height := 5;
    splLive.Left := Self.Top;
    PnlDebug.Align := alLeft;
    SplDebug.Align := alLeft;
    SplDebug.Left := Self.Width;
    pnlMain.Align := alClient;

  end
  else if AlignStyle = alTop then
  begin
    Self.Top := frmFrame.Top;
    splLive.Height := 5;
    splLive.Left := Self.Height;
    PnlDebug.Align := alLeft;
    SplDebug.Align := alLeft;
    SplDebug.Left := Self.Width;
    pnlMain.Align := alClient;

  end;
  Self.Repaint;
end;

procedure TfrmBroker.FillLiveView(Inital: Boolean = False);
var
  ListItem: TListItem;
  I, X, ResetMask, ResetMask2: Integer;

  procedure DeleteX(const Index: Cardinal);
  var
    ALength: Cardinal;
    Y: integer;
  begin
     ALength := Length(LiveArray);
    Assert(ALength > 0);
    Assert(Index < ALength);
    for Y := Index + 1 to ALength - 1 do
      LiveArray[Y - 1] := LiveArray[Y];
    SetLength(LiveArray, ALength - 1);

  end;

  function LockForUpdate(CtrlToLock: TWinControl): Integer;
  begin
    Result := CtrlToLock.Perform(EM_GETEVENTMASK, 0, 0);
    CtrlToLock.Perform(EM_SETEVENTMASK, 0, 0);
    CtrlToLock.Perform(WM_SETREDRAW, Ord(false), 0);
  end;

  procedure UnlockForUpdate(Var ReSetVar: Integer; CtrlToLock: TWinControl);
  begin
    CtrlToLock.Perform(WM_SETREDRAW, Ord(true), 0);
    InvalidateRect(CtrlToLock.Handle, NIL, true);
    CtrlToLock.Perform(EM_SETEVENTMASK, 0, ReSetVar);
  end;

begin
  // Update the RPC array for the adv tools
  ResetMask := LockForUpdate(LiveList);
  ResetMask2 := LockForUpdate(memData);
  try
  if Inital then
  begin
    InitalizeCloneArray;
    SetLength(LiveArray, 0);
    LiveList.Items.BeginUpdate;
    for I := 0 to RetainedRPCCount - 1 do
    begin
      SetLength(LiveArray, Length(LiveArray) + 1);
      with LiveArray[High(LiveArray)] do
      begin
        RPCText := TStringList.Create;
        try
          LoadRPCData(RPCText, I);
          if RPCText.Count > 0 then
            RpcName := RPCText[0]
          else
            RpcName := '';
          UCallListIndex := I;

          for X := 0 to RPCText.Count - 1 do
          begin
            if Pos('Run time:', RPCText[X]) > 0 then
            begin
              RPCRunTime := Copy(RPCText[X], Pos('Run time:', RPCText[X]),
                Length(RPCText[X]));
              break;
            end;
          end;
          LiveList.ClearSelection;
          ListItem := LiveList.Items.Add;
          ListItem.Caption := '';
          ListItem.SubItems.Add(RpcName);
          ResultListIndex := ListItem.Index;
          if (LiveList.Column[0].Width <> 0) or (LiveList.Column[1].Width <> -1) then
          begin
            LiveList.Column[0].Width := 0;
            LiveList.Column[1].Width := -1;
          end;
          ListItem.Selected := True;
          ListItem.MakeVisible(true);
          SearchIndex := -1;
          //See if it needs to be added to the search results
          if Trim(SearchTerm.Text) <> '' then
          begin
            if Pos(UpperCase(SearchTerm.Text), UpperCase(LiveArray[I].RPCText.Text)) > 0 then
            begin
              ListItem := ResultList.Items.Add;
              ListItem.Caption := RpcName;
              SearchIndex := ListItem.Index;
            end;
          end;
        except
          LiveArray[High(LiveArray)].RPCText.Free;
        end;
      end;
      LiveList.Items.EndUpdate;
    end;

  end
  else
  begin
    LiveList.Items.BeginUpdate;
    // need to add to the array
    if Length(LiveArray) = GetRPCMax then
    begin
      FreeAndNil(LiveArray[0].RPCText);
      //remove it from the search
      if LiveArray[0].SearchIndex <> -1 then
       LiveList.Items[LiveArray[0].SearchIndex].Delete;
      DeleteX(0);
      LiveList.Items[0].Delete;
      // reorder the numbers
      for I := Low(LiveArray) to High(LiveArray) do
      begin
        Dec(LiveArray[I].ResultListIndex);
        Dec(LiveArray[I].UCallListIndex);
      end;
    end;

    SetLength(LiveArray, Length(LiveArray) + 1);
    with LiveArray[High(LiveArray)] do
    begin
      RPCText := TStringList.Create;
      try
        LoadRPCData(RPCText, RetainedRPCCount - 1);
        if RPCText.Count > 0 then
          RpcName := RPCText[0]
        else
          RPCName := '';
        UCallListIndex := RetainedRPCCount - 1;

        for X := 0 to RPCText.Count - 1 do
        begin
          if Pos('Run time:', RPCText[X]) > 0 then
          begin
            RPCRunTime := Copy(RPCText[X], Pos('Run time:', RPCText[X]),
              Length(RPCText[X]));
            break;
          end;
        end;

        LiveList.ClearSelection;
        ListItem := LiveList.Items.Add;

        if (FlagIdent <> -1) and (FlagIdent <= UCallListIndex) then
        begin
         ListItem.Caption := '1';
        end else
         ListItem.Caption := '';

        if (FlagIdent <> -1) then
         FlagIdent := HigherOf(0, FlagIdent - 1);

        ListItem.SubItems.Add(RpcName);
        ResultListIndex := ListItem.Index;
        if (LiveList.Column[0].Width <> 0) or (LiveList.Column[1].Width <> -1) then
        begin
          LiveList.Column[0].Width := 0;
          LiveList.Column[1].Width := -1;
        end;
         ListItem.Selected := True;
        ListItem.MakeVisible(true);
        SearchIndex := -1;

        //See if it needs to be added to the search results
          if Trim(SearchTerm.Text) <> '' then
          begin
            if Pos(UpperCase(SearchTerm.Text), UpperCase(LiveArray[High(LiveArray)].RPCText.Text)) > 0 then
            begin
              ListItem := ResultList.Items.Add;
              ListItem.Caption := RpcName;
              SearchIndex := ListItem.Index;
            end;
          end;

      except
        LiveArray[High(LiveArray)].RPCText.Free;
      end;

      LiveList.Items.EndUpdate;
    end;
  end;

  memData.Lines.BeginUpdate;
  memData.Lines.Clear;
  memData.Lines.AddStrings(LiveArray[High(LiveArray)].RPCText);
  memData.Lines.EndUpdate;
  finally
   UnlockForUpdate(ResetMask2, memData);
   UnlockForUpdate(ResetMask, LiveList);
  end;
end;

procedure TfrmBroker.btnRLTClick(Sender: TObject);
var
  startTime, endTime: TDateTime;
  clientVer, serverVer, diffDisplay: string;
  theDiff: Integer;
const
  TX_OPTION = 'OR CPRS GUI CHART';
  disclaimer = 'NOTE: Strictly relative indicator:';
begin
  clientVer := clientVersion(Application.ExeName); // Obtain before starting.

  // Check time lapse between a standard RPC call:
  startTime := now;
  serverVer := serverVersion(TX_OPTION, clientVer);
  endTime := now;
  theDiff := milliSecondsBetween(endTime, startTime);
  diffDisplay := IntToStr(theDiff);

  // Show the results:
  infoBox('Lapsed time (milliseconds) = ' + diffDisplay + '.',
    disclaimer, MB_OK);
end;

procedure TfrmBroker.btnSearchClick(Sender: TObject);
var
  I, ReturnCursor: Integer;
  found: Boolean;
  ListItem: TListItem;
begin
  ReturnCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    // Clear all
    ResultList.Clear;
    found := False;
    for I := Low(LiveArray) to High(LiveArray) do
    begin
      LiveArray[I].SearchIndex := -1;
      if Pos(UpperCase(SearchTerm.Text), UpperCase(LiveArray[I].RPCText.Text)) > 0
      then
      begin
        ListItem := ResultList.Items.Add;
        ListItem.Caption := LiveArray[I].RpcName;
        LiveArray[I].SearchIndex := ListItem.Index;
        if not found then
        begin
          ResultList.Column[0].Width := -1;
          found := true;
        end;
      end;
    end;
    if not found then
      ShowMessage('no matches found');

  finally
    Screen.Cursor := ReturnCursor;
  end;
end;

procedure TfrmBroker.AlignClick(Sender: TObject);
begin
  inherited;
  With (Sender as TMenuItem) do begin
    if Tag = 1 then
     AlignBroker(alLeft)
    else if Tag = 2 then
      AlignBroker(alRight)
    else if Tag = 3 then
       AlignBroker(alBottom)
    else if Tag = 4 then
        AlignBroker(alTop)
    else if Tag = 5 then
       AlignBroker(alNone);
  end;
end;

procedure TfrmBroker.btnAdvToolsClick(Sender: TObject);
begin
  inherited;
  if not PnlDebug.Visible then
  begin
    Width := Width + PnlDebug.Width + SplDebug.Width;
    PnlDebug.Visible := true;
    SplDebug.Visible := true;
    SplDebug.Left := PnlDebug.Width + 10;
    InitalizeCloneArray;
    SetAfterRPCEvent(OnRefreshRPCRequest);
    FillLiveView(True);
  end;
end;

procedure TfrmBroker.SearchTermChange(Sender: TObject);
begin
  btnSearch.Enabled := (Trim(SearchTerm.Text) > '');
end;

procedure TfrmBroker.SearchTermKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // inherited;
  if (Key = VK_RETURN) then
    btnSearchClick(Self);
end;

procedure TfrmBroker.tlAddWatchClick(Sender: TObject);
var
  I, X: Integer;
  ListItem: TListItem;
begin
  inherited;
  // add the entry
  for I := Low(LiveArray) to High(LiveArray) do
  begin
    if LiveArray[I].UCallListIndex = (FCurrent) then
    begin
      // Clone the entry
      SetLength(fFrame.WatchArray, Length(fFrame.WatchArray) + 1);
      with fFrame.WatchArray[High(fFrame.WatchArray)] do
      begin
        RpcName := LiveArray[I].RpcName;
        UCallListIndex := LiveArray[I].UCallListIndex;
        RPCText := TStringList.Create;
        try
          RPCText.Assign(LiveArray[I].RPCText);

          for X := 0 to RPCText.Count - 1 do
          begin
            if Pos('Run time:', RPCText[X]) > 0 then
            begin
              RPCRunTime := Copy(RPCText[X], Pos('Run time:', RPCText[X]),
                Length(RPCText[X]));
              break;
            end;
          end;
        Except
          RPCText.Free;
        end;

        ListItem := WatchList.Items.Add;
        ListItem.Caption := RpcName;
        ResultListIndex := ListItem.Index;
      end;
      if (WatchList.Column[0].Width <> -1) then
      begin
        WatchList.Column[0].Width := -1;
      end;
      break;
    end;
  end;
end;

procedure TfrmBroker.tlClrWatchClick(Sender: TObject);
var
  I: Integer;
begin
  inherited;
  for I := Low(fFrame.WatchArray) to High(fFrame.WatchArray) do
    fFrame.WatchArray[I].RPCText.Free;
  SetLength(fFrame.WatchArray, 0);
  WatchList.Clear;
end;

procedure TfrmBroker.tlDelWatchClick(Sender: TObject);
var
  I: Integer;
  LS: TListItem;

  procedure DeleteX(const Index: Cardinal);
  var
    ALength: Cardinal;
    y: Integer;
  begin
    ALength := Length(fFrame.WatchArray);
    Assert(ALength > 0);
    Assert(Index < ALength);
    for Y := Index + 1 to ALength - 1 do
      fFrame.WatchArray[Y - 1] := fFrame.WatchArray[Y];
    SetLength(fFrame.WatchArray, ALength - 1);
  end;

begin
  inherited;
  LS := WatchList.Selected;
  // if there at least one item
  if Assigned(LS) then
  begin
    LS := WatchList.GetNextItem(LS, sdAll, [isSelected]);
    // if there are more than one
    while Assigned(LS) do
    begin
      for I := high(fFrame.WatchArray) downto low(fFrame.WatchArray) do
      begin
        if fFrame.WatchArray[I].ResultListIndex = LS.Index then
        begin
          fFrame.WatchArray[I].ResultListIndex := -1;
          fFrame.WatchArray[I].RPCText.Free;
          DeleteX(I);
          break;
        end;
      end;
      LS := WatchList.GetNextItem(LS, sdAll, [isSelected]);
    end;
  end;
  WatchList.DeleteSelected;
end;

procedure TfrmBroker.tlFlagClick(Sender: TObject);
begin
  // flag by date
  if tlFlag.Down then
    FlagIdent := FRetained
  else
    FlagIdent := -1;
end;

procedure TfrmBroker.ToolButton2Click(Sender: TObject);
begin
  inherited;
  AlignBroker(alNone);
end;

procedure TfrmBroker.InitalizeCloneArray();
begin
  if Length(LiveArray) = 0 then
  begin
    ResultList.Column[0].Width := -2;
    WatchList.Column[0].Width := -2;
    LiveList.Column[1].Width := -2;
  end;
end;

procedure TfrmBroker.LoadSelected(LookupArray: Array of TRpcRecord;aList:TListView);
  var
    I, SelCnt: Integer;
    SearchString, tmpStr: string;
    CharPos, CharPos2: Integer;
    OvTm: TTime;
    IHour, IMin, ISec, IMilli: Word;
    LS: TListItem;
    TheLstView: TListView;

  begin
    TheLstView := aList;
    memData.Clear;
    SelCnt := 0;
    OvTm := EncodeTime(0, 0, 0, 0);
    memData.Lines.BeginUpdate;
    ProgressBar1.Position := 0;
    ProgressBar1.Max := TheLstView.SelCount + 2;
    LS := TheLstView.Selected;
    // if there at least one item
    if Assigned(LS) then
    begin
      while Assigned(LS) do
      begin
        Inc(SelCnt);
        if SelCnt > 1 then
        begin
          memData.Lines.Add('');
          memData.Lines.Add('');
          memData.Lines.Add(StringOfChar('=', 80));
          memData.Lines.Add('');
          memData.Lines.Add('');
        end;
        for I := Low(LookupArray) to High(LookupArray) do

         if TheLstView = ResultList then
         begin
           if LS.Index = LookupArray[I].SearchIndex then
          begin
            memData.Lines.AddStrings(LookupArray[I].RPCText);
            if TheLstView <> WatchList then
              lblCallID.Caption := 'Last Call Minus: ' +
                IntToStr((RetainedRPCCount - LookupArray[I].UCallListIndex) - 1)
            else
              lblCallID.Caption := 'Watch List';

            FCurrent := LookupArray[I].UCallListIndex;

            IHour := StrToIntDef(Piece(LookupArray[I].RPCRunTime, ':', 2), 0);
            IMin := StrToIntDef(Piece(LookupArray[I].RPCRunTime, ':', 3), 0);
            tmpStr := Piece(LookupArray[I].RPCRunTime, ':', 4);
            ISec := StrToIntDef(Piece(tmpStr, '.', 1), 0);
            IMilli := StrToIntDef(Piece(tmpStr, '.', 2), 0);

            OvTm := IncHour(OvTm, IHour);
            OvTm := IncMinute(OvTm, IMin);
            OvTm := IncSecond(OvTm, ISec);
            OvTm := IncMilliSecond(OvTm, IMilli);

            break;
          end;
         end else begin

          if LS.Index = LookupArray[I].ResultListIndex then
          begin
            memData.Lines.AddStrings(LookupArray[I].RPCText);
            if TheLstView <> WatchList then
              lblCallID.Caption := 'Last Call Minus: ' +
                IntToStr((RetainedRPCCount - LookupArray[I].UCallListIndex) - 1)
            else
              lblCallID.Caption := 'Watch List';

            FCurrent := LookupArray[I].UCallListIndex;

            IHour := StrToIntDef(Piece(LookupArray[I].RPCRunTime, ':', 2), 0);
            IMin := StrToIntDef(Piece(LookupArray[I].RPCRunTime, ':', 3), 0);
            tmpStr := Piece(LookupArray[I].RPCRunTime, ':', 4);
            ISec := StrToIntDef(Piece(tmpStr, '.', 1), 0);
            IMilli := StrToIntDef(Piece(tmpStr, '.', 2), 0);

            OvTm := IncHour(OvTm, IHour);
            OvTm := IncMinute(OvTm, IMin);
            OvTm := IncSecond(OvTm, ISec);
            OvTm := IncMilliSecond(OvTm, IMilli);

            break;
          end;
         end;
        LS := TheLstView.GetNextItem(LS, sdAll, [isSelected]);
        ProgressBar1.Position := ProgressBar1.Position + 1;
      end;
    end;
    memData.SelStart := 0;

    // Grab the ran time to get an overall
    if SelCnt > 1 then
    begin
      DecodeTime(OvTm, IHour, IMin, ISec, IMilli);
      tmpStr := '';
      if IHour > 0 then
        tmpStr := tmpStr + IntToStr(IHour) + ' Hours';
      if IMin > 0 then
      begin
        if tmpStr <> '' then
          tmpStr := tmpStr + ' ';
        tmpStr := tmpStr + IntToStr(IMin) + ' Minutes';
      end;
      if ISec > 0 then
      begin
        if tmpStr <> '' then
          tmpStr := tmpStr + ' ';
        tmpStr := tmpStr + IntToStr(ISec) + ' Seconds';
      end;
      if IMilli > 0 then
      begin
        if tmpStr <> '' then
          tmpStr := tmpStr + ' ';
        tmpStr := tmpStr + IntToStr(IMilli) + ' Milliseconds';
      end;
      if tmpStr <> '' then
        tmpStr := 'Total run time of all selected RPCs: ' + tmpStr + CRLF + CRLF
          + StringOfChar('=', 80) + CRLF + CRLF;
      memData.Text := tmpStr + memData.Text;
      ProgressBar1.Position := ProgressBar1.Position + 1;
    end;

    if TheLstView = ResultList then
    begin
      SearchString := StringReplace(Trim(SearchTerm.Text), #10, '',
        [rfReplaceAll]);

      CharPos := 0;
      repeat
        // find the text and save the position
        CharPos2 := memData.FindText(SearchString, CharPos,
          Length(memData.Text), []);
        CharPos := CharPos2 + 1;
        if CharPos = 0 then
          break;

        HighlightRichEdit(CharPos2, Length(SearchString), clYellow);

      until CharPos = 0;
      ProgressBar1.Position := ProgressBar1.Position + 1;
    end;

    memData.Lines.EndUpdate;
    ProgressBar1.Position := 0;
  end;

procedure TfrmBroker.OnRefreshRPCRequest();
begin
 if Assigned(frmBroker) then
  frmBroker.FillLiveView;
end;

end.
