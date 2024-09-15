unit fMHTest;

{$DEFINE CCOWBROKER}

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  uPCE,
  StdCtrls,
  ExtCtrls,
  ORCtrls,
  ORFn,
  uConst,
  fBase508Form,
  uDlgComponents,
  VA508AccessibilityManager,
  uCore,
  orNet,
  TRPCB,
  StrUtils,
  rCore,
  VAUtils,
  System.UITypes;

type
  TfrmMHTest = class(TfrmBase508Form)
    sbMain: TScrollBox;
    pnlBottom: TPanel;
    btnCancel: TButton;
    btnOK: TButton;
    btnClear: TButton;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sbMainResize(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnClearClick(Sender: TObject);
  private
    FIDCount: integer;
    FAnswers: TStringList;
    FObjs: TList;
    FInfoText: string;
    FInfoLabel: TMentalHealthMemo;
    FBuilt: boolean;
    FBuildingControls: boolean;
    procedure BuildControls;
    function CurrentQ: integer;
    procedure GotoQ(x: integer);
  public
    MHTestComp: string;
    MHA3: boolean;
    class function CallMHDLL(TestName: string; Required: boolean;
      PCEData: TPCEData): String;
  end;

function PerformMHTest(InitialAnswers, TestName: string; QText: TStringList;
  Required: boolean; PCEData: TPCEData): string;
function SaveMHTest(TestName, Date, Loc: string): boolean;
procedure RemoveMHTest(TestName: string);
function CheckforMHDll: Boolean;

implementation

uses
  UMHDll,
  fFrame,
  rReminders,
  VA508AccessibilityRouter,
  uInit,
  rMisc,
  UResponsiveGUI;

{$R *.DFM}

const
  MaxQ = 100; // Max # of allowed answers for one question
  LineNumberTag = 1;
  ComboBoxTag = 2;
  BevelTag = 3;
  QuestionLabelTag = 4;
  CheckBoxTag = 10;

  NumberThreshhold = 5; // min # of questions on test before each has a line number
  Skipped = 'X';
  QGap = 4;
  Gap = 2;

var
  frmMHTest: TfrmMHTest;
  FFirstCtrl: TList;
  FYPos: TList;

type
  TMHQuestion = class(TObject)
  private
    FSeeAnswers: boolean;
    FAnswerText: string;
    FText: string;
    FAllowedAnswers: string;
    FAnswerIndex: integer;
    FAnswerCount: integer;
    FID: integer;
    FAnswer: string;
    FObjects: TList;
    //FLine: integer;
  protected
    procedure OnChange(Sender: TObject);
  public
    constructor Create;
    destructor Destroy; override;
    function Question: string;
    procedure BuildControls(var Y: integer; Wide: integer);
    property AllowedAnswers: string read FAllowedAnswers;
    property Answer: string read FAnswer;
    property AnswerCount: integer read FAnswerCount;
    property AnswerIndex: integer read FAnswerIndex;
    property AnswerText: string read FAnswerText;
    property SeeAnswers: boolean read FSeeAnswers;
    property ID: integer read FID;
    property Text: string read FText;
  end;

procedure ProcessMsg;
var
  SaveCursor: TCursor;
begin
  if(Screen.Cursor = crHourGlass) then
  begin
    SaveCursor := Screen.Cursor;
    Screen.Cursor := crDefault;
    try
      TResponsiveGUI.ProcessMessages;
    finally
      Screen.Cursor := SaveCursor;
    end;
  end
  else
    TResponsiveGUI.ProcessMessages;
end;

function PerformMHTest(InitialAnswers, TestName: string; QText: TStringList;
  Required: boolean; PCEData: TPCEData): string;
var
  str, scores, tempStr: string;
begin
  Result := InitialAnswers;
  str := TfrmMHTest.CallMHDLL(testName, Required, PCEData);
  if str <> '' then
  begin
    if Piece(str,U,1) = 'COMPLETE' then
    begin
      Scores := Piece(str, U, 4);
      if QText <> nil then
      begin
        tempStr := Piece(Str, U, 5);
        if Pos('GAF Score', tempStr) = 0 then tempStr := Copy(tempStr, 2, Length(tempStr));
        tempStr := AnsiReplaceStr(tempStr,'1156','Response not required due to responses to other questions.');
        tempStr := AnsiReplaceStr(tempStr,'*','~~');
        PiecesToList(tempStr,'~',QText);
      end;
      Result := 'New MH dll^COMPLETE^'+ Scores;
    end
    else if Piece(str,U,1) = 'INCOMPLETE' then
    begin
      Result := 'New MH dll^INCOMPLETE^';
    end
    else if (Piece(str,U,1) = 'CANCELLED') or (Piece(str, U, 1) = 'NOT STARTED') then
    begin
      Result := 'New MH dll^CANCELLED^';
    end;
    frmMHTest.Free;
    exit;
  end;
end;

procedure ResetBrokerContext;
begin
  if (RPCBrokerV.CurrentContext <> TX_OPTION) and
    (not RPCBrokerV.CreateContext(TX_OPTION)) then
      InfoBox('Error switching broker context', 'Error', MB_OK);
end;

procedure HandleDllStatusIssue;
begin
  case TMHDll.Status of
    TMHDll.TDllStatus.SetupError:
      TaskMessageDlg('VistA Parameter Not Set Up', TMHDll.StatusMessage,
        mtError, [mbOK], 0);
    TMHDll.TDllStatus.Missing:
      TaskMessageDlg('File Missing or Invalid', TMHDll.StatusMessage,
        mtError, [mbOK], 0);
    TMHDll.TDllStatus.VersionError:
      TaskMessageDlg('Incorrect Version Found', TMHDll.StatusMessage,
        mtError, [mbOK], 0);
    TMHDll.TDllStatus.FunctionMissing:
      TaskMessageDlg('Function Missing', TMHDll.StatusMessage, mtError,
        [mbOK], 0);
  else TaskMessageDlg('Unexpected Error', TMHDll.StatusMessage, mtError,
      [mbOK], 0);
  end;
end;

function SaveMHTest(TestName, Date, Loc: string): Boolean;
var
  Save: string;
begin
  SuspendTimeout;
  try
    Result := TMHDll.SaveInstrument(UpperCase(TestName), // InstrumentName
      Patient.DFN, // PatientDFN
      InttoStr(User.Duz), // OrderedByDUZ
      InttoStr(User.Duz), // AdministeredByDUZ
      Date, Loc + 'V', // LocationIEN
      Save);
    if not Result then HandleDllStatusIssue;
  finally
    try
      ResetBrokerContext;
    finally
      try
        TMHDll.UnloadDll;
      finally
        ResumeTimeout;
      end;
    end;
  end;
end;

procedure RemoveMHTest(TestName: string);
begin
  SuspendTimeout;
  try
    if not TMHDll.RemoveTempVistaFile(UpperCase(TestName), Patient.DFN) then
      HandleDllStatusIssue;
  finally
    try
      ResetBrokerContext;
    finally
      try
        TMHDll.UnloadDll;
      finally
        ResumeTimeout;
      end;
    end;
  end;
end;

function CheckforMHDll: Boolean;
begin
  Result := TMHDll.CheckForDll;
end;

procedure TfrmMHTest.FormCreate(Sender: TObject);
begin
  ResizeAnchoredFormToFont(self);
  FAnswers := TStringList.Create;
  FObjs := TList.Create;
  FFirstCtrl := TList.Create;
  FYPos := TList.Create;
end;

procedure TfrmMHTest.FormDestroy(Sender: TObject);
begin
  KillObj(@FFirstCtrl);
  KillObj(@FYPos);
  KillObj(@FObjs, TRUE);
  KillObj(@FAnswers);
end;

procedure TfrmMHTest.BuildControls;
var
  i, Wide, Y: integer;
  BoundsRect: TRect;
begin
  if (not FBuildingControls) then
  begin
    FBuildingControls := TRUE;
    try
      Wide := sbMain.Width - (Gap * 2) - ScrollBarWidth - 4;
      Y := gap - sbMain.VertScrollBar.Position;
      if MHA3 = False then
      begin
        if(not assigned(FInfoLabel)) then
        begin
          FInfoLabel := TMentalHealthMemo.Create(Self);
          FInfoLabel.Color := clBtnFace;
          FInfoLabel.BorderStyle := bsNone;
          FInfoLabel.ReadOnly := TRUE;
          FInfoLabel.TabStop := ScreenReaderSystemActive;
          FInfoLabel.Parent := sbMain;
          FInfoLabel.WordWrap := TRUE;
          FInfoLabel.Text := FInfoText;
          FInfoLabel.Left := Gap;
          UpdateColorsFor508Compliance(FInfoLabel);
        end;
        BoundsRect := FInfoLabel.BoundsRect;
        //Wide := sbMain.Width - (Gap * 2) - ScrollBarWidth - 4;
        //Y := gap - sbMain.VertScrollBar.Position;
        BoundsRect.Top := Y;
        BoundsRect.Right := BoundsRect.Left + Wide;
        WrappedTextHeightByFont(Canvas, FInfoLabel.Font, FInfoLabel.Text, BoundsRect);
        BoundsRect.Right := BoundsRect.Left + Wide;
        FInfoLabel.BoundsRect := BoundsRect;
        ProcessMsg;
        inc(Y, FInfoLabel.Height + QGap);
        for i := 0 to FObjs.Count-1 do
          TMHQuestion(FObjs[i]).BuildControls(Y, Wide);
      end else begin
        inc(Y, 1);
        for i := 0 to FObjs.Count-1 do TMHQuestion(FObjs[i]).BuildControls(Y, Wide);
      end;
    finally
      FBuildingControls := FALSE;
    end;
  end;
  amgrMain.RefreshComponents;
end;

class function TfrmMHTest.CallMHDLL(TestName: string; Required: Boolean;
  PCEData: TPCEData): string;
begin
  SuspendTimeout;
  try
    if not TMHDll.ShowInstrument(UpperCase(TestName), // InstrumentName
      Patient.DFN, // PatientDFN
      '', // OrderedByName
      InttoStr(User.Duz), // OrderedByDUZ
      User.Name, // AdministeredByName
      InttoStr(User.Duz), // AdministeredByDUZ
      ExternalName(PCEData.Location, 44), // Location
      InttoStr(PCEData.Location) + 'V', // LocationIEN
      Required, Result) then
    begin
      Result := '';
      HandleDllStatusIssue;
    end;
  finally
    try
      ResetBrokerContext;
    finally
      try
        TMHDll.UnloadDll;
      finally
        ResumeTimeout;
      end;
    end;
  end;
end;

function TfrmMHTest.CurrentQ: integer;
var
  i, j: integer;
  ctrl: TWinControl;
  MHQ: TMHQuestion;
begin
  Result := 0;
  ctrl := ActiveControl;
  if(not assigned(Ctrl)) then
    exit;
  for i := 0 to FObjs.Count-1 do
  begin
    MHQ := TMHQuestion(FObjs[i]);
    for j := 0 to MHQ.FObjects.Count-1 do
    begin
      if(Ctrl = MHQ.FObjects[j]) then
      begin
        Result := i;
        exit;
      end;
    end;
  end;
end;

procedure TfrmMHTest.GotoQ(x: integer);
begin
  if(ModalResult <> mrNone) then exit;
  if(x < 0) then x := 0;
  if(x >= FYPos.Count) then
  begin
    btnOK.Default := TRUE;
    btnOK.SetFocus;
  end else begin
    btnOK.Default := FALSE;
    sbMain.VertScrollBar.Position := Integer(FYPos[x]) - 2;
    TWinControl(FFirstCtrl[x]).SetFocus;
  end;
end;

procedure TfrmMHTest.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = VK_PRIOR then
  begin
    GotoQ(CurrentQ - 1);
    Key := 0;
  end else begin
    if (Key = VK_NEXT) or (Key = VK_RETURN) then
    begin
      GotoQ(CurrentQ + 1);
      Key := 0;
    end;
  end;
end;

{ TMHQuestion }

procedure TMHQuestion.BuildControls(var Y: integer; Wide: integer);
var
  RCombo: TComboBox;
  LNLbl, RLbl: TMentalHealthMemo;
  Bvl: TBevel;
  cb: TORCheckBox;
  ans, idx, DX, MaxDX, MaxDY: integer;
  Offset: integer;
  txt: string;
  QNum: integer;

  function GetCtrl(SubTag: integer): TControl;
  var
    i: integer;
  begin
    Result := nil;
    for i := 0 to FObjects.Count-1 do
    begin
      if(TControl(FObjects[i]).Tag = (FID + SubTag)) then
      begin
        Result := TControl(FObjects[i]);
        break;
      end;
    end;
  end;

  procedure AdjDY(Ht: integer);
  begin
    if(MaxDY < Ht) then
      MaxDY := Ht;
  end;

  procedure GetRLbl;
  var
    BoundsRect: TRect;
  begin
    if(FText <> '') then
    begin
      RLbl := TMentalHealthMemo(GetCtrl(QuestionLabelTag));
      if(not assigned(RLbl)) then
      begin
        RLbl := TMentalHealthMemo.Create(frmMHTest);
        RLbl.Color := clBtnFace;
        RLbl.BorderStyle := bsNone;
        RLbl.ReadOnly := TRUE;
        RLbl.TabStop := ScreenReaderSystemActive;
        RLbl.Parent := frmMHTest.sbMain;
        RLbl.Tag := FID + QuestionLabelTag;
        RLbl.WordWrap := TRUE;
        RLbl.Text := FText;
        FObjects.Add(RLbl);
        UpdateColorsFor508Compliance(RLbl);
      end;
      BoundsRect.Top := Y;
      BoundsRect.Left := Offset;
      BoundsRect.Right := Wide;
      WrappedTextHeightByFont(frmMHTest.Canvas, RLbl.Font, RLbl.Text, BoundsRect);
      BoundsRect.Right := Wide;
      RLbl.BoundsRect := BoundsRect;
      ProcessMsg;
    end
    else
      RLbl := nil;
  end;

begin
  QNum := (FID div MaxQ)-1;
  while(FFirstCtrl.Count <= QNum) do
    FFirstCtrl.Add(nil);
  while(FYPos.Count <= QNum) do
    FYPos.Add(nil);
  FYPos[QNum] := Pointer(Y);
  ans := pos(FAnswer, FAllowedAnswers) - 1;
  Offset := Gap;
  if(not assigned(FObjects)) then
    FObjects := TList.Create;
  MaxDY := 0;
  if(frmMHTest.FObjs.Count >= NumberThreshhold) then
  begin
    LNLbl := TMentalHealthMemo(GetCtrl(LineNumberTag));
    if(not assigned(LNLbl)) then
    begin
      LNLbl := TMentalHealthMemo.Create(frmMHTest);
      LNLbl.Color := clBtnFace;
      LNLbl.BorderStyle := bsNone;
      LNLbl.ReadOnly := TRUE;
      LNLbl.TabStop := ScreenReaderSystemActive;
      LNLbl.Parent := frmMHTest.sbMain;
      LNLbl.Tag := FID + LineNumberTag;
      LNLbl.Text := IntToStr(QNum+1) + '.';
      if ScreenReaderSystemActive then
        frmMHTest.amgrMain.AccessText[LNLbl] := 'Question';
      LNLbl.Width := TextWidthByFont(LNLbl.Font.Handle, LNLbl.Text);
      LNLbl.Height := TextHeightByFont(LNLbl.Font.Handle, LNLbl.Text);
      FObjects.Add(LNLbl);
      UpdateColorsFor508Compliance(LNLbl);
    end;
    LNLbl.Top := Y;
    LNLbl.Left := Offset;
    inc(Offset, MainFontSize * 4);
    AdjDY(LNLbl.Height);
  end;

  Bvl := TBevel(GetCtrl(BevelTag));
  if(not assigned(Bvl)) then
  begin
    Bvl := TBevel.Create(frmMHTest);
    Bvl.Parent := frmMHTest.sbMain;
    Bvl.Tag := FID + BevelTag;
    Bvl.Shape := bsFrame;
    FObjects.Add(Bvl);
    UpdateColorsFor508Compliance(Bvl);
  end;
  Bvl.Top := Y;
  Bvl.Left := Offset;
  Bvl.Width := Wide - Offset;
  inc(Offset, Gap * 2);
  inc(Y, Gap * 2);
  dec(Wide, Offset + (Gap * 2));

  GetRLbl;
  if(assigned(RLbl)) then
  begin
    MaxDY := RLbl.Height;
    inc(Y, MaxDY + Gap * 2);
  end;

  if(FSeeAnswers) then
  begin
    for idx := 0 to FAnswerCount-1 do
    begin
      cb := TORCheckBox(GetCtrl(CheckBoxTag + idx));
      if(not assigned(cb)) then
      begin
        cb := TORCheckBox.Create(frmMHTest);
        if(idx = 0) then
          FFirstCtrl[QNum] := cb;
        cb.Parent := frmMHTest.sbMain;
        cb.Tag := FID + CheckBoxTag + idx;
        cb.GroupIndex := FID;
        cb.WordWrap := TRUE;
        cb.AutoSize := TRUE;
        if(idx = ans) then
          cb.Checked := TRUE;
        cb.OnClick := OnChange;
        cb.Caption := Piece(frmMHTest.FAnswers[FAnswerIndex + idx], U, 2);
        FObjects.Add(cb);
        UpdateColorsFor508Compliance(cb);
      end;
      cb.Top := Y;
      cb.Left := Offset;
      cb.WordWrap := TRUE;
      cb.Width := Wide;
      cb.AutoAdjustSize;
      cb.WordWrap := (not cb.SingleLine);
      inc(Y, cb.Height + Gap);
    end;
  end else begin
    RCombo := TComboBox(GetCtrl(ComboBoxTag));
    if(not assigned(RCombo)) then
    begin
      RCombo := TComboBox.Create(frmMHTest);
      FFirstCtrl[QNum] := RCombo;
      RCombo.Parent := frmMHTest.sbMain;
      RCombo.Tag := FID + ComboBoxTag;
      FObjects.Add(RCombo);
      MaxDX := 0;
      for idx := 0 to FAnswerCount-1 do
      begin
        txt := Piece(frmMHTest.FAnswers[FAnswerIndex + idx], U, 2);
        RCombo.Items.Add(txt);
        DX := TextWidthByFont(frmMHTest.sbMain.Font.Handle, txt);
        if(MaxDX < DX) then
          MaxDX := DX;
      end;
      RCombo.ItemIndex := ans;
      RCombo.Width := MaxDX + 24;
      RCombo.OnChange := OnChange;
      UpdateColorsFor508Compliance(RCombo);
    end;
    RCombo.Top := Y;
    RCombo.Left := Offset;
    inc(Y, RCombo.Height + (Gap * 2));
  end;
  Bvl.Height := Y - Bvl.Top;
  inc(Y, QGap);
end;

constructor TMHQuestion.Create;
begin
  inherited;
  FSeeAnswers := TRUE;
  FAnswerText := '';
  FText := '';
  FAllowedAnswers := '';
  FAnswerIndex := frmMHTest.FAnswers.Count;
  FAnswerCount := 0;
  inc(frmMHTest.FIDCount, MaxQ);
  FID := frmMHTest.FIDCount;
  FAnswer := Skipped;
end;

destructor TMHQuestion.Destroy;
begin
  KillObj(@FObjects, TRUE);
  inherited;
end;

procedure TMHQuestion.OnChange(Sender: TObject);
var
  idx: integer;
  cb: TCheckBox;
  cbo: TComboBox;
begin
  if(Sender is TCheckBox) then
  begin
    cb := TCheckBox(Sender);
    if(cb.Checked) then
    begin
      idx := cb.Tag - CheckBoxTag + 1;
      idx := idx mod MaxQ;
      FAnswer := copy(FAllowedAnswers, idx, 1);
    end
    else
      FAnswer := Skipped;
  end else begin
    if(Sender is TComboBox) then
    begin
      cbo := TComboBox(Sender);
      idx := cbo.ItemIndex + 1;
      if(idx = 0) or (cbo.Text = '') then
        FAnswer := Skipped
      else
        FAnswer := copy(FAllowedAnswers, idx, 1);
    end;
  end;
end;

procedure TfrmMHTest.FormShow(Sender: TObject);
begin
  if(not FBuilt) then
  begin
    Screen.Cursor := crHourGlass;
    try
      BuildControls;
      FBuilt := TRUE;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TfrmMHTest.sbMainResize(Sender: TObject);
begin
  if(FBuilt) then
    BuildControls;
end;

function TMHQuestion.Question: string;
var
  idx: integer;
  echar: string;
begin
  Result := trim(FText);
  echar := copy(Result, length(Result), 1);
  if(echar <> ':') and (echar <> '?') then
  begin
    if(echar = '.') then
      delete(Result, length(result), 1);
    Result := Result + ':';
  end;
  if(FAnswer = Skipped) then
    Result := Result + ' Not rated'
  else
  begin
    idx := pos(FAnswer, FAllowedAnswers) + FAnswerIndex - 1;
    if(idx >= 0) and (idx < frmMHTest.FAnswers.Count) then
      Result := Result + ' ' + Piece(frmMHTest.FAnswers[idx],U,2);
  end;
end;

procedure TfrmMHTest.btnOKClick(Sender: TObject);
var
  i, XCnt, First: integer;
  msg, ans, TestStatus: string;
begin
  msg := '';
  ans := '';
  XCnt := 0;
  First := -1;
  TestStatus := '2';
  MHTestComp := '2';
  for i := 0 to FObjs.Count-1 do
  begin
    ans := ans + TMHQuestion(Fobjs[i]).FAnswer;
    if(TMHQuestion(FObjs[i]).FAnswer = Skipped) then
    begin
      if(First < 0) then First := i;
      inc(XCnt);
      if(msg <> '') then
        msg := msg + ', ';
      msg := msg + IntToStr(i+1);
    end;
  end;
  if(XCnt = FObjs.Count) then ModalResult := mrOK;
  TestStatus := VerifyMentalHealthTestComplete(Self.Caption, ans);
  if Piece(TestStatus,U,1) <> '2' then
  begin
    if Piece(TestStatus,U,1)='1' then
    begin
      ModalResult := mrOK;
      MHTestComp := '1';
      EXIT;
    end;
    if Piece(TestStatus,U,1)='0' then
    begin
      MHTestComp := '0';
      msg := Piece(TestStatus,u,2);
      msg := 'The following questions have not been answered:' + CRLF + CRLF + '    ' + msg;
      if (InfoBox(msg + CRLF + CRLF + 'Answer skipped questions?', 'Skipped Questions',
        MB_YESNO or MB_ICONQUESTION) = IDYES) then GotoQ(First)
      else
        ModalResult := mrOK;
        EXIT;
    end;
  end;
  if(XCnt = 0) then
    ModalResult := mrOK
  else
  begin
    if(XCnt = FObjs.Count) then
      ModalResult := mrOK
    else
    begin
      msg := 'The following questions have not been answered:' + CRLF + CRLF + '    ' + msg;
      if(InfoBox(msg + CRLF + CRLF + 'Answer skipped questions?', 'Skipped Questions',
         MB_YESNO or MB_ICONQUESTION) = IDYES) then
        GotoQ(First)
      else
        ModalResult := mrOK;
    end;
  end;
end;

procedure TfrmMHTest.btnClearClick(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to sbMain.ControlCount-1 do
  begin
    if(sbMain.Controls[i] is TCheckBox) then
      TCheckBox(sbMain.Controls[i]).Checked := FALSE
    else
    if(sbMain.Controls[i] is TComboBox) then
    begin
      with TComboBox(sbMain.Controls[i]) do
      begin
        ItemIndex := -1;
        OnChange(sbMain.Controls[i]);
      end;
    end;
  end;
end;

end.
