unit fxBroker;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DateUtils, ORNet, ORFn, rMisc, ComCtrls, Buttons, ExtCtrls,
  ORCtrls, ORSystem, fBase508Form, VA508AccessibilityManager,
  Winapi.RichEdit;

type
  TRpcRecord = record
    RpcName: String;
    UCallListIndex: Integer;
    ResultListIndex: Integer;
    RPCText: TStringList;
  end;

  TLogActions = (ShowFlag, ShowSearch);

  TfrmBroker = class(TfrmBase508Form)
    pnlTop: TORAutoPanel;
    lblMaxCalls: TLabel;
    txtMaxCalls: TCaptionEdit;
    cmdPrev: TBitBtn;
    cmdNext: TBitBtn;
    udMax: TUpDown;
    memData: TRichEdit;
    lblCallID: TStaticText;
    cmdSearch: TBitBtn;
    btnFlag: TBitBtn;
    btnRLT: TBitBtn;
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
    procedure cmdPrevClick(Sender: TObject);
    procedure cmdNextClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnRLTClick(Sender: TObject);
    procedure cmdSearchClick(Sender: TObject);
    procedure btnFlagClick(Sender: TObject);
    function FindPriorFlag: Integer;
    procedure btnSearchClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ResultListSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure SearchTermChange(Sender: TObject);
    procedure SearchTermKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    FRetained: Integer;
    FCurrent: Integer;
    fFlagRPC: Integer;
    fFlagDateTime: TDateTime;
    RPCArray: Array of TRpcRecord;
    RPCLogAction: TLogActions;
    procedure CloneRPCList();
    procedure InitalizeCloneArray();
    procedure HighlightRichEdit(StartChar, EndChar: Integer; HighLightColor: TColor);
  public
    { Public declarations }

  end;

procedure ShowBroker;

implementation

const
 Flaghint = 'Mark any additional RPCs as flaged';

{$R *.DFM}

procedure ShowBroker;
var
  frmBroker: TfrmBroker;
begin
  frmBroker := TfrmBroker.Create(Application);
  try
    ResizeAnchoredFormToFont(frmBroker);
    with frmBroker do
    begin
      FRetained := RetainedRPCCount - 1;
      FCurrent := FRetained;
      LoadRPCData(memData.Lines, FCurrent);
      fFlagRPC := FindPriorFlag;
      memData.SelStart := 0;
      lblCallID.Caption := 'Last Call Minus: ' + IntToStr(FRetained - FCurrent);
      ShowModal;
    end;
  finally
    frmBroker.Release;
  end;
end;

procedure TfrmBroker.cmdPrevClick(Sender: TObject);
begin
  FCurrent := HigherOf(FCurrent - 1, 0);
  LoadRPCData(memData.Lines, FCurrent);
  memData.SelStart := 0;
  lblCallID.Caption := 'Last Call Minus: ' + IntToStr(FRetained - FCurrent);
end;

procedure TfrmBroker.cmdNextClick(Sender: TObject);
begin
  FCurrent := LowerOf(FCurrent + 1, FRetained);
  LoadRPCData(memData.Lines, FCurrent);
  memData.SelStart := 0;
  lblCallID.Caption := 'Last Call Minus: ' + IntToStr(FRetained - FCurrent);
end;

procedure TfrmBroker.cmdSearchClick(Sender: TObject);
begin
  if not PnlDebug.Visible then
   Width := Width + PnlDebug.Width + SplDebug.Width;

  PnlDebug.Visible := true;
  lblDebug.Caption := 'Search Results';
  SplDebug.Visible := true;
  SplDebug.Left := PnlDebug.Width + 10;
  RPCLogAction := ShowSearch;
  PnlSearch.Visible := true;
  SearchTerm.SetFocus;
  InitalizeCloneArray;
end;

procedure TfrmBroker.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SetRetainedRPCMax(StrToIntDef(txtMaxCalls.Text, 5))
end;

procedure TfrmBroker.FormResize(Sender: TObject);
begin
  Refresh;
end;

procedure TfrmBroker.FormCreate(Sender: TObject);
begin
  udMax.Position := GetRPCMax;
  Width := Width - PnlDebug.Width + SplDebug.Width;
end;

procedure TfrmBroker.FormDestroy(Sender: TObject);
Var
 I: integer;
begin
 for I := Low(RPCArray) to High(RPCArray) do
    RPCArray[I].RPCText.Free;
  SetLength(RPCArray, 0);
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

procedure TfrmBroker.btnFlagClick(Sender: TObject);
Var
  LastText: TStringList;
  LastRPCText: String;
  i: Integer;
begin
  // flag by date
  if btnFlag.Tag = 1 then
  begin
   if fFlagRPC > -1 then
     SetRPCFlaged('');
   btnFlag.Tag := 0;
   btnFlag.Caption := 'Flag';
  end else begin
  LastText := TStringList.Create;
  try
    LoadRPCData(LastText, FRetained);
    for i := 0 to 2 do
      LastRPCText := LastRPCText + LastText.Strings[i] + #13#10;
    SetRPCFlaged(LastRPCText);
    fFlagDateTime := Now;
    btnFlag.Caption := 'Flag (set)';
   // btnFlag.Hint := Flaghint + ' (after ' + FormatDateTime('hh:nn:ss.z a/p', fFlagDateTime) +')';
  finally
    LastText.Free;
  end;
  end;

end;

procedure TfrmBroker.HighlightRichEdit(StartChar, EndChar: Integer; HighLightColor: TColor);
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

function TfrmBroker.FindPriorFlag: Integer;
var
  i, ReturnCursor: Integer;
  StrToCheck, Temp: string;
  TextToCheck: TStringList;
  Found: Boolean;
  ListItem: TListItem;
begin
  Result := -1;
  StrToCheck := GetRPCFlaged;
  if StrToCheck <> '' then
  begin
    TextToCheck := TStringList.Create;
    try
      for i := FRetained downto 0 do
      begin
        LoadRPCData(TextToCheck, i);
        if Pos(StrToCheck, TextToCheck.Text) > 0 then
        begin
          Result := i;
          break;
        end;
      end;
    finally
      TextToCheck.Free;
    end;

    if Result = -1 then
      SetRPCFlaged('')
    else
    begin
      Temp := Copy(StrToCheck, Pos('Ran at:', StrToCheck) + 7, Length(StrToCheck));
      Temp := Trim(copy(Temp, 1, Pos(#10, Temp)));
      btnFlag.Caption := 'Flag (set)';
      btnFlag.Tag := 1;
    //  btnFlag.Hint := Flaghint + ' (after ' + Temp +')';

      InitalizeCloneArray;
      RPCLogAction := ShowFlag;
      lblDebug.Caption := 'RPCs ran after ' + Temp;
      ReturnCursor := Screen.Cursor;
      Screen.Cursor := crHourGlass;
      try
       PnlDebug.Visible := true;
       Width := Width + PnlDebug.Width + SplDebug.Width;
       SplDebug.Visible := true;
       PnlSearch.Visible := false;
       // Clear all
       ResultList.Clear;

       Found := false;
       for I := Low(RPCArray) to High(RPCArray) do
       begin

        RPCArray[I].ResultListIndex := -1;

        if I < Result then Continue;
        ListItem := ResultList.Items.Add;
        ListItem.Caption :=
          IntToStr((RPCArray[I].UCallListIndex - RetainedRPCCount) + 1);

        ListItem.SubItems.Add(RPCArray[I].RpcName);
        RPCArray[I].ResultListIndex := ListItem.Index;
        if not Found then
        begin
          ResultList.Column[1].Width := -1;
          Found := True;
        end;

      end;
    finally
    Screen.Cursor := ReturnCursor;
  end;
    end;
  end;
end;

procedure TfrmBroker.btnRLTClick(Sender: TObject);
var
  startTime, endTime: tDateTime;
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
  Found: Boolean;
  ListItem: TListItem;
begin
  ReturnCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    // Clear all
    ResultList.Clear;
    Found := false;
    for I := Low(RPCArray) to High(RPCArray) do
    begin
      RPCArray[I].ResultListIndex := -1;
      if Pos(UpperCase(SearchTerm.Text), UpperCase(RPCArray[I].RPCText.Text)) > 0
      then
      begin
        ListItem := ResultList.Items.Add;
        ListItem.Caption :=
          IntToStr((RPCArray[I].UCallListIndex - RetainedRPCCount) + 1);

        ListItem.SubItems.Add(RPCArray[I].RpcName);
        RPCArray[I].ResultListIndex := ListItem.Index;
        if not Found then
        begin
          ResultList.Column[1].Width := -1;
          Found := True;
        end;
      end;
    end;
    if not Found then
      ShowMessage('no matches found');

  finally
    Screen.Cursor := ReturnCursor;
  end;
end;

procedure TfrmBroker.SearchTermChange(Sender: TObject);
begin
  btnSearch.Enabled := (Trim(SearchTerm.Text) > '');
end;

procedure TfrmBroker.SearchTermKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
//  inherited;
 if (Key = VK_RETURN) then
  btnSearchClick(Self);
end;

procedure TfrmBroker.CloneRPCList();
Var
  I: Integer;
begin
  for I := 0 to RetainedRPCCount - 1 do
  begin
    SetLength(RPCArray, Length(RPCArray) + 1);
    RPCArray[High(RPCArray)].RPCText := TStringList.Create;
    try
      LoadRPCData(RPCArray[High(RPCArray)].RPCText, I);
      RPCArray[High(RPCArray)].RpcName := RPCArray[High(RPCArray)].RPCText[0];
      RPCArray[High(RPCArray)].UCallListIndex := I;
    except
      RPCArray[High(RPCArray)].RPCText.Free;
    end;
  end;

end;

procedure TfrmBroker.InitalizeCloneArray();
begin
  if Length(RPCArray) = 0 then
  begin
  CloneRPCList;
  ResultList.Column[0].Width := -2;
  ResultList.Column[1].Width := -2;
  end;
end;

procedure TfrmBroker.ResultListSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
Var
  I: Integer;
  SearchString: string;
  CharPos, CharPos2: Integer;
begin
  if Selected then
  begin
    for I := Low(RPCArray) to High(RPCArray) do
      if ResultList.Selected.Index = RPCArray[I].ResultListIndex then
      begin
        LoadRPCData(memData.Lines, RPCArray[I].UCallListIndex);
        memData.SelStart := 0;
        lblCallID.Caption := 'Last Call Minus: ' +
          IntToStr((RetainedRPCCount - RPCArray[I].UCallListIndex) - 1);
        FCurrent := RPCArray[I].UCallListIndex;
        break;
      end;

    if RPCLogAction = ShowSearch then
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
    end;
    if RPCLogAction = ShowFlag then
    begin
      HighlightRichEdit(0, Length(memData.Lines[0]), clYellow);
    end;
  end;
end;

end.
