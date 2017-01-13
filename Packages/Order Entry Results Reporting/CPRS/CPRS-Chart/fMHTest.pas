unit fMHTest;

{$DEFINE CCOWBROKER}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ORCtrls, ORFn, uConst, fBase508Form, uDlgComponents,
  VA508AccessibilityManager, uCore, orNet, TRPCB, StrUtils, rCore, VAUtils
  ;

type
TShowProc = procedure(
   RPCBrokerV: TRPCBroker;
  InstrumentName,
  PatientDFN,
  OrderedBy,
  OrderedByDUZ,
  AdministeredBy,
  AdministeredByDUZ,
  Location,
  LocationIEN: string;
  Required: boolean;
  var ProgressNote: string); stdcall;

TSaveProc = procedure(
   RPCBrokerV: TRPCBroker;
  InstrumentName,
  PatientDFN,
  OrderedByDUZ,
  AdministeredByDUZ,
  AdminDate,
  LocationIEN: string;
  var Status: string); stdcall;

TRemoveTempVistaFile = procedure(
   RPCBrokerV: TRPCBroker;
  InstrumentName,
  PatientDFN: string); stdcall;

TCloseProc = procedure;

TUsedMHDll = record
  Checked: boolean;
  Display: boolean;
end;

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
    //FMaxLines: integer;
    FBuildingControls: boolean;
    procedure BuildControls;
    {function Answers: string;
    procedure GetQText(QText: TStringList);
    function LoadTest(InitialAnswers, TestName: string): boolean; }
    function CurrentQ: integer;
    procedure GotoQ(x: integer);
  public
  MHTestComp: string;
  MHA3: boolean;
  function CallMHDLL(TestName: string; Required: boolean): String;
  end;

function PerformMHTest(InitialAnswers, TestName: string; QText: TStringList; Required: boolean): string;
function SaveMHTest(TestName, Date, Loc: string): boolean;
procedure RemoveMHTest(TestName: string);
function CheckforMHDll: boolean;
procedure CloseMHDLL;

var
  MHDLLHandle: THandle = 0;

implementation

uses rMisc, fFrame,rReminders, VA508AccessibilityRouter;

{$R *.DFM}

const
  MaxQ    = 100; // Max # of allowed answers for one question
  LineNumberTag = 1;
  ComboBoxTag = 2;
  BevelTag = 3;
  QuestionLabelTag = 4;
  CheckBoxTag = 10;

  NumberThreshhold = 5; // min # of questions on test before each has a line number
  Skipped = 'X';
  QGap = 4;
  Gap = 2;

  ShowProc                    : TShowProc = nil;
  SaveProc                    : TSaveProc = nil;
  RemoveTempVistaFile         : TRemoveTempVistaFile = nil;
  CloseProc                   : TCloseProc = nil;
  SHARE_DIR = '\VISTA\Common Files\';
var
  frmMHTest: TfrmMHTest;
  FFirstCtrl: TList;
  FYPos: TList;
  //UsedMHDll: TUsedMHDll; comment out to clear compiler hint after commenting out code in CheckforMHDll /WAT

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

const
 DLL_PARAM = 'The YS MHA_A DLL NAME parameter is not setup on this system. Please contact your IRM';
 // MHDLLName = 'YS_MHA_A_XE3.DLL';
  //MHDLLAUXName = 'YS_MHA_AUX.DLL';
var
 MHDLLName: string;

procedure LoadMHDLL;
//var
//  MHPath: string;

begin
  if MHDLLHandle = 0 then begin
    MHDLLName := GetUserParam('YS MHA_A DLL NAME');
    if Trim(MHDLLName) = '' then begin
      ShowMessage(DLL_PARAM);
 //    exit;
    end else begin
      MHDLLHandle := LoadDll(MHDLLName);
    end;
//    MHPath := GetProgramFilesPath + SHARE_DIR + MHDLLName;
//    MHDLLHandle := LoadLibrary(PChar(MHPath));
  end;
end;

procedure UnloadMHDLL;
begin
  if MHDLLHandle <> 0 then
  begin
    FreeLibrary(MHDLLHandle);
    MHDLLHandle := 0;
  end;
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
      Application.ProcessMessages;
    finally
      Screen.Cursor := SaveCursor;
    end;
  end
  else
    Application.ProcessMessages;
end;

function PerformMHTest(InitialAnswers, TestName: string; QText: TStringList; Required: boolean): string;
var
str,scores, tempStr: string;
begin
  Result := InitialAnswers;
  str := frmMHTest.CallMHDLL(testName, Required);
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
{  frmMHTest := TfrmMHTest.Create(Application);
  try
    frmMHTest.Caption := TestName;
    if(frmMHTest.LoadTest(InitialAnswers, TestName)) then
    begin
      if(frmMHTest.ShowModal = mrOK) then
      begin
        Result := frmMHTest.Answers;
        if(assigned(QText)) then
        begin
          QText.Clear;
          if(Result <> '') then
            frmMHTest.GetQText(QText);
        end;
      end;
    end;
      if frmMHTest.MHTestComp = '' then frmMHTest.MHTestComp := '0';
      Result := Result + U + frmMHTest.MHTestComp;
      if Result = U then Result := '';
  finally
    frmMHTest.Free;
  end; }
end;

function SaveMHTest(TestName, date, Loc: string): boolean;
var
  save: string;
begin
  LoadMHDLL;
  Result := true;
  if MHDLLHandle = 0 then
    begin
      InfoBox(MHDLLName + ' not available', 'Error', MB_OK);
      Exit;
    end
  else
    begin
      try
        @SaveProc := GetProcAddress(MHDLLHandle, 'SaveInstrument');

        if @SaveProc = nil then
          begin
          // function not found.. misspelled?
            infoBox('Save Instrument Function not found within ' + MHDLLName + '.', 'Error', MB_OK);
            Exit;
          end;

        if Assigned(SaveProc) then
         begin
          try
            SaveProc(RPCBrokerV,
            UpperCase(TestName), //InstrumentName
            Patient.DFN, //PatientDFN
            InttoStr(User.duz), //OrderedByDUZ
            InttoStr(User.duz), //AdministeredByDUZ
            date,
            Loc + 'V', //LocationIEN
            save);
          finally
            if RPCBrokerV.CurrentContext <> 'OR CPRS GUI CHART' then
               begin
                 if RPCBrokerV.CreateContext('OR CPRS GUI CHART') = false then
                    infoBox('Error switching broker context','Error', MB_OK);
               end;
          end;  {inner try..finally}
         end;
      finally
        UnloadMHDLL;
      end; {try..finally}
  end;
end;

procedure RemoveMHTest(TestName: string);
begin
  LoadMHDLL;
  if MHDLLHandle = 0 then
    begin
      InfoBox(MHDLLName + ' not available', 'Error', MB_OK);
      Exit;
    end
  else
    begin
      try
        @RemoveTempVistaFile := GetProcAddress(MHDLLHandle, 'RemoveTempVistaFile');

        if @RemoveTempVistaFile = nil then
          begin
          // function not found.. misspelled?
            InfoBox('Remove Temp File function not found within ' + MHDLLName + '.', 'Error', MB_OK);
            Exit;
          end;

        if Assigned(RemoveTempVistaFile) then
         begin
          try
            RemoveTempVistaFile(RPCBrokerV,
            UpperCase(TestName), //InstrumentName
            Patient.DFN);
          finally
            if RPCBrokerV.CurrentContext <> 'OR CPRS GUI CHART' then
               begin
                 if RPCBrokerV.CreateContext('OR CPRS GUI CHART') = false then
                    infoBox('Error switching broker context','Error', MB_OK);
               end;
          end;  {inner try..finally}
         end;
      finally
        UnloadMHDLL;
      end; {try..finally}
  end;
end;

function CheckforMHDll: boolean;
begin
  Result := True;
    {if (UsedMHDll.Checked = True) and (UsedMHDll.Display = False) then Exit
  else if UsedMHDll.Checked = false then
    begin
      UsedMHDll.Display := UsedMHDllRPC;
      UsedMHDll.Checked := True;
      if UsedMHDll.Display = false then
        begin
          Result := False;
          exit;
        end;
    end;  }
  if MHDLLHandle = 0 then // if not 0 the DLL already loaded - result = true
  begin
    LoadMHDLL;
    if MHDLLHandle = 0 then
      Result := false
    else
      UnloadMHDLL;
  end;
end;

procedure CloseMHDLL;
begin
  if MHDLLHandle = 0 then Exit;
  try
    @CloseProc := GetProcAddress(MHDLLHandle, 'CloseDLL');
    if Assigned(CloseProc) then
    begin
      CloseProc;
    end;
  finally
    UnloadMHDLL;
  end; {try..finally}
end;

{ TfrmMHTest }

{function TfrmMHTest.Answers: string;
var
  i, XCnt: integer;
  ans: string;

begin
  Result := '';
  XCnt := 0;
  for i := 0 to FObjs.Count-1 do
  begin
    ans := TMHQuestion(FObjs[i]).FAnswer;
    if(ans = Skipped) then
      inc(XCnt);
    Result := Result + ans;
  end;
  if(XCnt = FObjs.Count) then
    Result := '';
end;
}
{function TfrmMHTest.LoadTest(InitialAnswers, TestName: string): boolean;
var
  TstData: TStringList;
  lNum, i, idx: integer;
  Line, LastLine, Inp, Code: string;
  Txt, Spec, p, Spidx, tmp: string;
  RSpec, First, TCodes: boolean;
  QObj: TMHQuestion;

  procedure ParseText;
  var
    i, tlen: integer;

  begin
    Code := '';
    i := 1;
    tlen := length(Txt);
    while(i <= tlen) do
    begin
      while(i <= tlen) and (Txt[i] = ' ') do inc(i);
      if(i > tlen) then
      begin
        Txt := '';
        exit;
      end;
      if(i > 1) then
      begin
        delete(Txt,1,i-1);
        i := 1;
      end;
      if(Spec = 'I') then exit;
      tlen := length(Txt);
      if(tlen < 3) then exit;
      Code := copy(Txt,i,1);
      if(pos(Code, (UpperCaseLetters + LowerCaseLetters + Digits)) = 0) then
      begin
        Code := '';
        exit;
      end;
      inc(i);
      while(i <= tlen) and (Txt[i] = ' ') do inc(i);
      if(Txt[i] in ['.','=']) then
      begin
        if(pos(Code, QObj.FAllowedAnswers) > 0) then
        begin
          inc(i);
          while(i <= tlen) and (Txt[i] = ' ') do inc(i);
          if(i <= tlen) then
            delete(Txt,1,i-1)
          else
            Code := '';
          exit;
        end
        else
        begin
          Code := '';
          exit;
        end;
      end
      else
      begin
        Code := '';
        exit;
      end;
    end;
  end;

  procedure AddTxt2Str(var X: string);
  begin
    if(Txt <> '') then
    begin
      if(X <> '') then
      begin
        X := X + ' ';
        if(copy(Txt, length(Txt), 1) = '.') then
          X := X + ' ';
      end;
      X := X + Txt;
    end;
  end;

begin
  Result := TRUE;
  TstData := TStringList.Create;
  try
    FastAssign(LoadMentalHealthTest(TestName), TstData);
    if TstData.Strings[0] = '1' then MHA3 := True
    else MHA3 := False;
    Screen.Cursor := crHourGlass;
    try
      TstData.Add('99999;X;0');
      idx := 1;
      FMaxLines := 0;
      FInfoText := '';
      LastLine := U;
      First := TRUE;
      RSpec := FALSE;
      TCodes := FALSE;
      QObj := nil;
      while (idx < TstData.Count) do
      begin
        Inp := TstData[idx];
        if(pos('[ERROR]', Inp) > 0) then
        begin
          Result := FALSE;
          break;
        end;
        p := Piece(Inp, U, 1);
        Line := Piece(p, ';', 1);
        Spec := Piece(p, ';', 2);
        SpIdx := Piece(p, ';', 3);
        if(LastLine <> Line) then
        begin
          LastLine := Line;
          if(First) then
            First := FALSE
          else
          begin
            if(not RSpec) then
            begin
              Result := FALSE;
              break;
            end;
          end;
          if(Spec = 'X') then break;
          lNum := StrToIntDef(Line, 0);
          if(lNum <= 0) then
          begin
            Result := FALSE;
            break;
          end;
          RSpec := FALSE;
          TCodes := FALSE;
          QObj := TMHQuestion(FObjs[FObjs.Add(TMHQuestion.Create)]);
          QObj.FLine := lNum;
          if(FMaxLines < lNum) then
            FMaxLines := lNum;
        end;
        Txt := Piece(Inp, U, 2);
        ParseText;
        if(Txt <> '') then
        begin
          if(Spec = 'I') then
          begin
           if MHA3 = True then AddTxt2Str(QObj.FText)
           else
           AddTxt2Str(FInfoText);;
          end
          else
          if(Spec = 'R') then
          begin
            RSpec := TRUE;
            if(spIdx = '0') then
              QObj.FAllowedAnswers := Txt
            else
            if(Code = '') then
              QObj.FAnswerText := Txt
            else
            begin
              QObj.FSeeAnswers := FALSE;
              FAnswers.Add(Code + U + Txt);
              inc(QObj.FAnswerCount);
            end;
          end
          else
          if(Spec = 'T') then
          begin
            if(Code = '') then
            begin
              if(TCodes) then
              begin
                tmp := FAnswers[FAnswers.Count-1];
                AddTxt2Str(tmp);
                FAnswers[FAnswers.Count-1] := tmp;
              end
              else
                AddTxt2Str(QObj.FText);
            end
            else
            begin
              TCodes := TRUE;
              FAnswers.Add(Code + U + Txt);
              inc(QObj.FAnswerCount);
            end;
          end;
        end;
        inc(idx);
      end;
    finally
      Screen.Cursor := crDefault;
    end;
  finally
    TstData.Free;
  end;
  if(not Result) then
    InfoBox('Error encountered loading ' + TestName, 'Error', MB_OK)
  else
  begin
    for i := 0 to FObjs.Count-1 do
    begin
      with TMHQuestion(FObjs[i]) do
      begin
        tmp := copy(InitialAnswers,i+1,1);
        if(tmp <> '') then
          FAnswer := tmp;
      end;
    end;
  end;
end;
}
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
  if(not FBuildingControls) then
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
     end
     else
       begin
         inc(Y, 1);
         for i := 0 to FObjs.Count-1 do TMHQuestion(FObjs[i]).BuildControls(Y, Wide);
       end;
    finally
      FBuildingControls := FALSE;
    end;
  end;
  amgrMain.RefreshComponents;
end;

{procedure TfrmMHTest.GetQText(QText: TStringList);
var
  i, lx: integer;

begin
  if(FObjs.Count > 99) then
    lx := 5
  else
  if(FObjs.Count > 9) then
    lx := 4
  else
    lx := 3;
  for i := 0 to FObjs.Count-1 do
    QText.Add(copy(IntToStr(i+1) + '.      ', 1, lx) + TMHQuestion(FObjs[i]).Question);
end;
}
function TfrmMHTest.CallMHDLL(TestName: string; Required: boolean): String;
var                               
  ProgressNote : string;
begin
  ProgressNote := '';
 { if (UsedMHDll.Checked = True) and (UsedMHDll.Display = False) then Exit
  else if UsedMHDll.Checked = false then
    begin
      UsedMHDll.Display := UsedMHDllRPC;
      UsedMHDll.Checked := True;
      if UsedMHDll.Display = false then exit;
    end; }
  LoadMHDLL;
  Result := '';
  if MHDLLHandle = 0 then
    begin
      InfoBox('Mental Health DLL not found.' + CRLF +
                  CRLF + 'Contact IRM to install the ' + MHDLLName +  ' file on this machine.', 'Warning', MB_OK);
      //InfoBox(MHDLLName + ' not available.' + CRLF +
      //                    'CPRS will continue processing the MH test using the previous format.' +
      //            CRLF + CRLF + 'Contact IRM to install the ' + MHDLLName +
      //                          ' file on this machine.', 'Warning', MB_OK);
      Exit;
    end
  else
    begin
      try
        @ShowProc := GetProcAddress(MHDLLHandle, 'ShowInstrument');

        if @ShowProc = nil then
          begin
          // function not found.. misspelled?
            InfoBox('Function ShowInstrument not found within ' + MHDLLName +
                    ' not available', 'Error', MB_OK);
            Exit;
          end;

        if Assigned(ShowProc) then
           begin
             Result := '';
             try
               ShowProc(RPCBrokerV,
               UpperCase(TestName), //InstrumentName
               Patient.DFN, //PatientDFN
               '', //OrderedByName
               InttoStr(User.duz), //OrderedByDUZ
               User.Name, //AdministeredByName
               InttoStr(User.duz), //AdministeredByDUZ
               Encounter.LocationName, //Location
               InttoStr(Encounter.Location) + 'V', //LocationIEN
               Required,
               ProgressNote);
               Result := ProgressNote;
           finally
//           if RPCBrokerV.CurrentContext <> 'OR CPRS GUI CHART' then
               begin
                 if RPCBrokerV.CreateContext('OR CPRS GUI CHART') = false then
                    infoBox('Error switching broker context','Error', MB_OK);
                end;
               end; {inner try ..finally}
            end;
      finally
        UnloadMHDLL;
      end; {try..finally}
      //Result := ProgressNote;
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
  end
  else
  begin
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
  end
  else
  if (Key = VK_NEXT) or (Key = VK_RETURN) then
  begin
    GotoQ(CurrentQ + 1);
    Key := 0;
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
  end
  else
  begin
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
  end
  else
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
          if(InfoBox(msg + CRLF + CRLF + 'Answer skipped questions?', 'Skipped Questions',
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
