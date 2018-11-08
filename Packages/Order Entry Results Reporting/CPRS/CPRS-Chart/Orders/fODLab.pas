unit fODLab;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ORCtrls, ORfn, fODBase, ExtCtrls, ComCtrls, uConst,
  ORDtTm, Buttons, Menus, VA508AccessibilityManager, VA508AccessibilityRouter;

type
  TfrmODLab = class(TfrmODBase)
    lblAvailTests: TLabel;
    cboAvailTest: TORComboBox;
    lblCollTime: TLabel;
    cboFrequency: TORComboBox;
    lblTestName: TLabel;
    lblCollSamp: TLabel;
    cboCollSamp: TORComboBox;
    lblSpecimen: TLabel;
    cboSpecimen: TORComboBox;
    lblUrgency: TLabel;
    cboUrgency: TORComboBox;
    lblAddlComment: TLabel;
    txtAddlComment: TCaptionEdit;
    txtDays: TCaptionEdit;
    bvlTestName: TBevel;
    lblFrequency: TLabel;
    pnlHide: TORAutoPanel;
    pnlOrderComment: TORAutoPanel;
    lblOrderComment: TOROffsetLabel;
    pnlAntiCoagulation: TORAutoPanel;
    lblAntiCoagulant: TOROffsetLabel;
    txtAntiCoagulant: TCaptionEdit;
    pnlUrineVolume: TORAutoPanel;
    lblUrineVolume: TOROffsetLabel;
    txtUrineVolume: TCaptionEdit;
    pnlPeakTrough: TORAutoPanel;
    lblPeakTrough: TOROffsetLabel;
    grpPeakTrough: TRadioGroup;
    lblReqComment: TOROffsetLabel;
    pnlDoseDraw: TORAutoPanel;
    lblDose: TOROffsetLabel;
    lblDraw: TOROffsetLabel;
    txtDoseTime: TCaptionEdit;
    txtDrawTime: TCaptionEdit;
    txtOrderComment: TCaptionEdit;
    FLabCommonCombo: TORListBox;
    lblHowManyDays: TLabel;
    cboCollTime: TORComboBox;
    lblCollType: TLabel;
    pnlCollTimeButton: TKeyClickPanel;
    cboCollType: TORComboBox;
    calCollTime: TORDateBox;
    dlgLabCollTime: TORDateTimeDlg;
    txtImmedColl: TCaptionEdit;
    cmdImmedColl: TSpeedButton;
    MessagePopup: TPopupMenu;
    ViewinReportWindow1: TMenuItem;
    Frequencylbl508: TVA508StaticText;
    HowManyDayslbl508: TVA508StaticText;
    specimenlbl508: TVA508StaticText;
    CollSamplbl508: TVA508StaticText;
    procedure FormCreate(Sender: TObject);
    procedure ControlChange(Sender: TObject);
    procedure cboAvailTestNeedData(Sender: TObject;
              const StartFrom: string; Direction, InsertAt: Integer);
    procedure cboAvailTestSelect(Sender: TObject);
    procedure cboCollSampChange(Sender: TObject);
    procedure cboUrgencyChange(Sender: TObject);
    procedure cboSpecimenChange(Sender: TObject);
    procedure txtAddlCommentExit(Sender: TObject);
    procedure cboCollTimeChange(Sender: TObject);
    procedure cboFrequencyChange(Sender: TObject);
    procedure cboCollTypeChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure txtOrderCommentExit(Sender: TObject);
    procedure txtAntiCoagulantExit(Sender: TObject);
    procedure txtUrineVolumeExit(Sender: TObject);
    procedure grpPeakTroughClick(Sender: TObject);
    procedure txtDoseTimeExit(Sender: TObject);
    procedure txtDrawTimeExit(Sender: TObject);
    procedure DisableCommentPanels;
    procedure cboAvailTestExit(Sender: TObject);
    procedure cboCollSampKeyPause(Sender: TObject);
    procedure cboCollSampMouseClick(Sender: TObject);
    procedure cboCollTimeExit(Sender: TObject);
    procedure cboSpecimenMouseClick(Sender: TObject);
    procedure cboSpecimenKeyPause(Sender: TObject);
    procedure cmdImmedCollClick(Sender: TObject);
    procedure pnlCollTimeButtonEnter(Sender: TObject);
    procedure pnlCollTimeButtonExit(Sender: TObject);
    procedure ViewinReportWindow1Click(Sender: TObject);
  protected
    FCmtTypes: TStringList ;
    procedure InitDialog; override;
    procedure Validate(var AnErrMsg: string); override;
    function  ValidCollTime(UserEntry: string): string;
    procedure DoseDrawComment;
    procedure GetAllCollSamples(AComboBox: TORComboBox);
    procedure GetAllSpecimens(AComboBox: TORComboBox);
    procedure SetupCollTimes(CollType: string);
    procedure LoadCollType(AComboBox:TORComboBox);
   private
    FLastCollType: string;
    FLastCollTime: string;
    FLastLabCollTime: string;
    FLastLabID: string;
    FLastItemID: string;
    FEvtDelayLoc: integer;
    FEvtDivision: integer;
    procedure ReadServerVariables;
    procedure DisplayChangedOrders(ACollType: string);
    procedure setup508Label(text: string; lbl: TVA508StaticText; ctrl: TControl; lbl2: string);
  public
    procedure SetupDialog(OrderAction: Integer; const ID: string); override;
    procedure LoadRequiredComment(CmtType: integer);
    procedure DetermineCollectionDefaults(Responses: TResponses);
    property  EvtDelayLoc: integer   read FEvtDelayLoc   write FEvtDelayLoc;
    property  EvtDivision: integer   read FEvtDivision   write FEvtDivision;
  end;

  type
  TCollSamp = class(TObject)
    CollSampID: Integer;                  { IEN of CollSamp }
    CollSampName: string;                 { Name of CollSamp }
    SpecimenID: Integer;                  { IEN of default specimen }
    SpecimenName: string;                 { Name of the specimen }
    TubeColor: string;                    { TubeColor (text) }
    MinInterval: Integer;                 { Minimum days between orders }
    MaxPerDay: Integer;                   { Maximum orders per day }
    LabCanCollect: Boolean;               { True if lab can collect }
    SampReqComment: string;               { Name of required comment }
    WardComment: TStringList;             { CollSamp specific comment }
  end;

  TLabTest = class(TObject)
    TestID: Integer;                      { IEN of Lab Test }
    TestName: string;                     { Name of Lab Test }
    LabSubscript: string ;                { which section of Lab? }
    CollSamp: Integer;                    { index into CollSampList }
    Specimen: Integer;                    { IEN of specimen }
    Urgency: Integer;                     { IEN of urgency }
    Comment: TStringList;                 { text of comment }
    TestReqComment: string;               { Name of required comment }
    CurReqComment: string;                { name of required comment }
    CurWardComment: TStringList;          { WP of Ward Comment }
    UniqueCollSamp: Boolean;              { true if not prompt CollSamp }
    CollSampList: TList;                  { collection sample objects }
    CollSampCount: integer;               { count of original contents of CollSampList}
    SpecimenList: TStringList;            { Strings: IEN^Specimen Name }
    SpecListCount: integer;               { count of original contents of SpecimenList}
    UrgencyList: TStringList;             { Strings: IEN^Urgency Name }
    ForceUrgency: Boolean;                { true if not prompt Urgency }
    QuickOrderResponses: TResponses;      { if created as a result of a quick order selection}
    { functions & procedures }
    constructor Create(const LabTestIEN: string; Responses: TResponses);
    destructor Destroy; override ;
    function IndexOfCollSamp(CollSampIEN: Integer): Integer;
    procedure FillCollSampList(LoadData: TStringList; DfltCollSamp: Integer);
    procedure LoadAllSamples;
    procedure SetCollSampDflts;
    procedure ChangeCollSamp(CollSampIEN: Integer);
    procedure ChangeSpecimen(const SpecimenIEN: string);
    procedure ChangeUrgency(const UrgencyIEN: string);
    procedure ChangeComment(const CommentText: string);
    function  LabCanCollect: Boolean;
    procedure LoadCollSamp(AComboBox: TORComboBox);
    procedure LoadSpecimen(AComboBox: TORComboBox);
    procedure LoadUrgency(CollType: string; AComboBox:TORComboBox);
    function NameOfCollSamp: string;
    function NameOfSpecimen: string;
    function NameOfUrgency: string;
    function ObtainCollSamp: Boolean;
    function ObtainSpecimen: Boolean;
    function ObtainUrgency: Boolean;
    function ObtainComment: Boolean;
  end;

const
  CmtType: array[0..6] of string = ('ANTICOAGULATION','DOSE/DRAW TIMES','ORDER COMMENT',
                                    'ORDER COMMENT MODIFIED','TDM (PEAK-TROUGH)',
                                    'TRANSFUSION','URINE VOLUME');

implementation

{$R *.DFM}

uses rODBase, rODLab, uCore, rCore, fODLabOthCollSamp, fODLabOthSpec, fODLabImmedColl, fLabCollTimes,
 rOrders, uODBase, fRptBox, fFrame;


var
  uDfltUrgency: Integer;
  uDfltCollType: string;
  ALabTest: TLabTest;
  UserHasLRLABKey: boolean;
  LRFZX     : string;  //the default collection type  (LC,WC,SP,I)
  LRFSAMP   : string;  //the default sample           (ptr)
  LRFSPEC   : string;  //the default specimen         (ptr)
  LRFDATE   : string;  //the default collection time  (NOW,NEXT,AM,PM,T...)
  LRFURG    : string;  //the default urgency          (number)		TRY '2'
  LRFSCH    : string;  //the default schedule?        (ONE TIME, QD, ...)

const
  TX_NO_TEST          = 'A Lab Test must be specified.'    ;
  TX_NO_IMMED = 'Immediate collect is not available for this test/sample';
  TX_NO_IMMED_CAP = 'Invalid Collection Type';

{ base form procedures shared by all dialogs ------------------------------------------------ }

procedure TfrmODLab.FormCreate(Sender: TObject);
var
  i, n, HMD508: integer;
  AList: TStringList;
begin
  frmFrame.pnlVisit.Enabled := false;
  AutoSizeDisabled := True;
  inherited;
  AList := TStringList.Create;
  try
    LRFZX    := '';
    LRFSAMP  := '';
    LRFSPEC  := '';
    LRFDATE  := '';
    LRFURG   := '';
    LRFSCH   := '';
    FLastColltime := '';
    FLastLabCollTime := '';
    FLastItemID := '';
    uDfltCollType := '';
    FillerID := 'LR';
    FEvtDelayLoc := 0;
    FEvtDivision := 0;
    UserHasLRLABKey := User.HasKey('LRLAB');
    AllowQuickOrder := True;
    StatusText('Loading Dialog Definition');
    pnlHide.BringToFront;
    lblReqComment.Visible := False ;
    FCmtTypes := TStringList.Create;
    for i := 0 to 6 do FCmtTypes.Add(CmtType[i]) ;
    Responses.Dialog := 'LR OTHER LAB TESTS';        // loads formatting info
    StatusText('Loading Default Values');
    if Self.EvtID > 0 then
    begin
      EvtDelayLoc := StrToIntDef(GetEventLoc1(IntToStr(Self.EvtID)),0);
      EvtDivision := StrToIntDef(GetEventDiv1(IntToStr(Self.EvtID)),0);
      if EvtDelayLoc>0 then
        FastAssign(ODForLab(EvtDelayLoc, EvtDivision), AList)
      else
        FastAssign(ODForLab(Encounter.Location, EvtDivision), AList);
    end else
      FastAssign(ODForLab(Encounter.Location), AList); // ODForLab returns TStrings with defaults
    CtrlInits.LoadDefaults(AList);
    InitDialog;
    with CtrlInits do
    begin
      SetControl(cboCollType, 'Collection Types');
      uDfltCollType := ExtractDefault(AList, 'Collection Types');
      if uDfltCollType <> '' then
        cboCollType.SelectByID(uDfltCollType)
      else if OrderForInpatient then
        cboCollType.SelectByID('LC')
      else
        cboCollType.SelectByID('SP');
      SetupCollTimes(cboCollType.ItemID);
      StatusText('Initializing List of Tests');
      SetControl(cboAvailTest, 'ShortList');
      if cboAvailTest.Items.Count > 0 then cboAvailTest.InsertSeparator;
      cboAvailTest.InitLongList('');
      //TDP - CQ#19396 HMD508 added to guarantee 508 label did not change width
      HMD508 := HowManyDayslbl508.Width;
      SetControl(cboFrequency, 'Schedules');
      HowManydayslbl508.Width := HMD508;
      with cboFrequency do
        begin
          if ItemIndex < 0 then ItemIndex := Items.IndexOf('ONE TIME');
          if ItemIndex < 0 then ItemIndex := Items.IndexOf('ONCE');
        end;
      lblHowManyDays.Enabled := False;                 { have this call change event in case }
      txtDays.Enabled := False;                         { the default is not 'one time'?      }
      //TDP - CQ#19396 Following line does not appear to be needed
      //setup508Label(HowManyText, HowManyDayslbl508, txtDays, lblHowManyDays.Caption);
    end;
    if EvTDelayLoc>0 then
      n := MaxDays(EvtDelayLoc, 0)
    else
      n := MaxDays(Encounter.Location, 0);
    if n < 0 then with cboFrequency do
      begin
        ItemIndex := Items.IndexOf('ONE TIME');
        if ItemIndex = -1 then ItemIndex := Items.IndexOf('ONCE');
        Enabled := False;
        Font.Color := clGrayText;
        lblFrequency.Enabled := False;
        setup508Label(Text, Frequencylbl508, cboFrequency, lblFrequency.Caption);
      end;
    PreserveControl(cboAvailTest);
    PreserveControl(cboCollType);
    PreserveControl(cboCollTime);
    PreserveControl(calCollTime);
    PreserveControl(cboFrequency);
    PreserveControl(txtDays);
    StatusText('');
  finally
    AList.Free;
  end;
end;

{TDP - CQ#19396 Added to address 508 related changes. I modified slightly to
       change lbl.Caption and retain lbl.Width}
procedure TfrmODLab.setup508Label(text: string; lbl: TVA508StaticText; ctrl: TControl; lbl2: string);
var
Width: integer;
begin
  if ScreenReaderSystemActive and not ctrl.Enabled then begin
    lbl.Enabled := True;
    lbl.Visible := True;
    Width := lbl.Width;
    lbl.Caption := lbl2 +'. Read Only. Value is ' + Text;
    lbl.Width := Width;
  end else
    lbl.Visible := false;
end;

procedure TfrmODLab.InitDialog;
begin
  inherited;
  Changing := True;
  if ALabTest <> nil then
    begin
      ALabTest.Destroy;
      ALabTest := nil;
    end;
  with CtrlInits do
    begin
      SetControl(cboUrgency, 'Default Urgency') ;
      uDfltUrgency := StrToInt(Piece(cboUrgency.Items[0],U,1));
    end;
  lblTestName.Caption := '';
  DisableCommentPanels;
  cboAvailTest.SelectByID(FLastItemID);
  ActiveControl := cboAvailTest;
  cboAvailTest.ItemIndex := -1;
  StatusText('');
  Changing := False ;
end;

procedure TfrmODLab.SetupDialog(OrderAction: Integer; const ID: string);
var
  tmpResp: TResponse;
  i: integer;
begin
  inherited;
  ReadServerVariables;
  if LRFZX <> '' then
    begin
      cboCollType.SelectByID(LRFZX);
      if cboCollType.ItemIndex > -1 then SetupCollTimes(LRFZX);
    end;
  if (LRFSCH <> '') and (cboFrequency.Enabled) then
    begin
      cboFrequency.ItemIndex := cboFrequency.Items.IndexOf(LRFSCH);
      cboFrequencyChange(Self);
    end;
  if OrderAction in [ORDER_COPY, ORDER_EDIT, ORDER_QUICK] then with Responses, ALabTest do
   begin
      SetControl(cboAvailTest,       'ORDERABLE', 1);
      cboAvailTestSelect(Self);
      if ALabTest = nil then Exit;  // Causes access violation in FillCollSampleList
      Changing := True;
      SetControl(cboFrequency,       'SCHEDULE', 1);
      SetControl(txtDays,            'DAYS', 1);
      tmpResp := FindResponseByName('SAMPLE'  ,1);
      if (tmpResp <> nil) and (tmpResp.IValue <> '') then with cboCollSamp do
        begin
          SelectByID(tmpResp.IValue);
          if ItemIndex < 0 then
            begin
              LoadAllSamples;
              Items.Insert(0, tmpResp.IValue + U + tmpResp.EValue);
              ItemIndex := 0  ;
            end;
        end;
      cboCollSampChange(Self);
      DetermineCollectionDefaults(Responses);
      tmpResp := FindResponseByName('SPECIMEN'  ,1);
      if (tmpResp <> nil) and (tmpResp.IValue <> '') then with cboSpecimen do
        begin
          SelectByID(tmpResp.IValue);
          if ItemIndex < 0 then
            begin
              if ALabTest <> nil then
                ALabTest.SpecimenList.Add(tmpResp.IValue + U + tmpResp.EValue);
              Items.Insert(0, tmpResp.IValue + U + tmpResp.EValue);
              ItemIndex := 0  ;
            end;
        end
      else
        if (LRFSPEC <> '') then cboSpecimen.SelectByID(LRFSPEC);
      if ALabTest <> nil then Specimen := cboSpecimen.ItemIEN;
      if ALabTest <> nil then AlabTest.LoadUrgency(cboCollType.ItemID, cboUrgency);
      SetControl(cboUrgency,         'URGENCY', 1);
      if cboUrgency.ItemIEN = 0 then
        begin
          if StrToIntDef(LRFURG, 0) > 0 then
            cboUrgency.SelectByID(LRFURG)
          else if (ALabTest <> nil) and (Urgency = 0) and (cboUrgency.Items.Count = 1) then
            cboUrgency.ItemIndex := 0;
        end;
      if ALabTest <> nil then Urgency := cboUrgency.ItemIEN;
      i := 1 ;
      tmpResp := Responses.FindResponseByName('COMMENT',i);
      while tmpResp <> nil do
        begin
          Comment.Add(tmpResp.EValue);
          Inc(i);
          tmpResp := Responses.FindResponseByName('COMMENT',i);
        end ;
      with cboFrequency do
        if not Enabled then
          begin
            ItemIndex := Items.IndexOf('ONE TIME');
            if ItemIndex = -1 then ItemIndex := Items.IndexOf('ONCE');
          end;
      cboFrequencyChange(Self);
      Changing := False;
      ControlChange(Self);
   end;
end;

{ dialog specific event procedures follow here ---------------------------------------------- }

constructor TLabTest.Create(const LabTestIEN: string; Responses: TResponses);
var
  LoadData, OneSamp: TStringList;
  DfltCollSamp: Integer;
  x: string;
  tmpResp: TResponse;
begin
  LoadData := TStringList.Create;
  try
    LoadLabTestData(LoadData, LabTestIEN) ;
    with LoadData do
    begin
      QuickOrderResponses := Responses;
      TestID := StrToInt(LabTestIEN);
      TestName := Piece(ExtractDefault(LoadData, 'Test Name'),U,1);
      LabSubscript := Piece(ExtractDefault(LoadData, 'Item ID'),U,2);
      TestReqComment := ExtractDefault(LoadData, 'ReqCom');
      if Length(ExtractDefault(LoadData, 'Unique CollSamp')) > 0 then UniqueCollSamp := True;
      x := ExtractDefault(LoadData, 'Unique CollSamp');                            
      if Length(x) = 0 then x := ExtractDefault(LoadData, 'Lab CollSamp');
      if Length(x) = 0 then x := ExtractDefault(LoadData, 'Default CollSamp');
      if Length(x) = 0 then x := '-1';
      DfltCollSamp := StrToInt(x);
      SpecimenList := TStringList.Create;
      ExtractItems(SpecimenList, LoadData, 'Specimens');
      if LRFSPEC <> '' then SpecimenList.Add(GetOneSpecimen(StrToInt(LRFSPEC)));
      UrgencyList := TStringList.Create;
      if Length(ExtractDefault(LoadData, 'Default Urgency')) > 0 then  { forced urgency }
        begin
          ForceUrgency := True;
          UrgencyList.Add(ExtractDefault(LoadData, 'Default Urgency'));
          Urgency := StrToInt(Piece(ExtractDefault(LoadData, 'Default Urgency'), '^', 1));
          uDfltUrgency := Urgency;
        end
      else
        begin                 { list of urgencies }
          ExtractItems(UrgencyList, LoadData, 'Urgencies');
          if StrToIntDef(LRFURG, 0) > 0 then
            Urgency := StrToInt(LRFURG)
          else
            Urgency := uDfltUrgency;
        end;
      Comment := TStringList.Create ;
      CurWardComment := TStringList.Create;
      ExtractText(CurWardComment, LoadData, 'GenWardInstructions');
      CollSamp := 0;
      CollSampList := TList.Create;
      FillCollSampList(LoadData, DfltCollSamp);
      with QuickOrderResponses do tmpResp := FindResponseByName('SAMPLE'  ,1);
      if (LRFSAMP <> '') and (IndexOfCollSamp(StrToInt(LRFSAMP)) < 0) and
         (not UniqueCollSamp) and (tmpResp = nil) then
        begin
          OneSamp := TStringList.Create;
          try
            FastAssign(GetOneCollSamp(StrToInt(LRFSAMP)), OneSamp);
            FillCollSampList(OneSamp, CollSampList.Count);
          finally
            OneSamp.Free;
          end;
        end;
      if (not UniqueCollSamp) and (CollSampList.Count = 0) then LoadAllSamples;
      CollSampCount := CollSampList.Count;
    end;
  finally
    LoadData.Free;
  end;
  SetCollSampDflts;
end;

destructor TLabTest.Destroy;
var
  i: Integer;
begin
  if CollSampList <> nil then
    with CollSampList do for i := 0 to Count - 1 do
     with TCollSamp(Items[i]) do
      begin
        WardComment.Free;
        Free;
      end;
  CollSampList.Free;
  SpecimenList.Free;
  UrgencyList.Free;
  CurWardComment.Free;
  Comment.Free;
  inherited Destroy;
end;

function TLabTest.IndexOfCollSamp(CollSampIEN: Integer): Integer;
var
  i: Integer;
begin
  Result := -1;
  with CollSampList do for i := 0 to Count - 1 do with TCollSamp(Items[i]) do
    if CollSampIEN = CollSampID then
    begin
      Result := i;
      break;
    end;
end;

procedure TLabTest.LoadAllSamples;
var
  LoadList, SpecList: TStringList;
  i: Integer;
begin
  LoadList := TStringList.Create;
  SpecList := TStringList.Create;
  try
    LoadSamples(LoadList) ;
    FillCollSampList(LoadList, 0);
    ExtractItems(SpecList, LoadList, 'Specimens');
    with SpecList do for i := 0 to Count - 1 do
      if SpecimenList.IndexOf(Strings[i]) = -1 then SpecimenList.Add(Strings[i]);
  finally
    LoadList.Free;
    SpecList.Free;
  end;
end;

procedure TLabTest.FillCollSampList(LoadData: TStringList; DfltCollSamp: Integer);
{1  2        3         4       5         6          7         8          9               10   }
{n^IEN^CollSampName^SpecIEN^TubeTop^MinInterval^MaxPerDay^LabCollect^SampReqCommentIEN;name^SpecName}
var
  i, LastListItem, AnIndex: Integer;
  ACollSamp: TCollSamp;
  LabCollSamp: Integer;
begin
  i := -1;
  if CollSampList = nil then CollSampList := TList.Create;
  LastListItem := CollSampList.Count ;
  LabCollSamp := StrToIntDef(ExtractDefault(LoadData, 'Lab CollSamp'), 0);
  repeat Inc(i) until (i = LoadData.Count) or (LoadData[i] = '~CollSamp');
  Inc(i);
  if i < LoadData.Count then repeat
    if LoadData[i][1] = 'i' then
      begin
        ACollSamp := TCollSamp.Create;
        with ACollSamp do
          begin
            AnIndex         := StrToIntDef(Copy(Piece(LoadData[i], '^', 1), 2, 999), -1);
            CollSampID      := StrToInt(Piece(LoadData[i], '^', 2));
            CollSampName    := Piece(LoadData[i], '^', 3);
            SpecimenID      := StrToIntDef(Piece(LoadData[i], '^', 4), 0);
            SpecimenName    := Piece(LoadData[i], '^', 10);
            TubeColor       := Piece(LoadData[i], '^', 5);
            MinInterval     := StrToIntDef(Piece(LoadData[i], '^', 6), 0);
            MaxPerDay       := StrToIntDef(Piece(LoadData[i], '^', 7), 0);
            LabCanCollect   := AnIndex = LabCollSamp;
            SampReqComment  := Piece(LoadData[i], '^', 9);
            WardComment     := TStringList.Create;
            if CollSampID  = StrToIntDef(LRFSAMP, 0) then
              CollSamp := CollSampID
            else if AnIndex = DfltCollSamp then
              CollSamp := CollSampID;
          end; {with}
        LastListItem := CollSampList.Add(ACollSamp);
      end; {if}
    if (LoadData[i][1] = 't') then
      TCollSamp(CollSampList.Items[LastListItem]).WardComment.Add(Copy(LoadData[i], 2, 255));
    Inc(i);
  until (i = LoadData.Count) or (LoadData[i][1] = '~');
end;

procedure TLabTest.SetCollSampDflts;
var
  tmpResp: TResponse;
begin
  Specimen := 0;
  Comment.Clear;
  CurReqComment := TestReqComment;
  if CollSamp = 0 then Exit;
  with QuickOrderResponses do tmpResp := FindResponseByName('SPECIMEN'  ,1);
  if (LRFSPEC <> '') and (tmpResp = nil) then
    ChangeSpecimen(LRFSPEC)
  else with TCollSamp(CollSampList.Items[IndexOfCollSamp(CollSamp)]) do
    begin
      Specimen := SpecimenID;
      if SampReqcomment <> '' then CurReqComment := SampReqComment;
    end;
end;

procedure TLabTest.ChangeCollSamp(CollSampIEN: Integer);
begin
  CollSamp := CollSampIEN;
  SetCollSampDflts;
end;

procedure TLabTest.ChangeSpecimen(const SpecimenIEN: string);
begin
  Specimen := StrToIntDef(SpecimenIEN,0);
end;

procedure TLabTest.ChangeUrgency(const UrgencyIEN: string);
begin
  Urgency := StrToIntDef(UrgencyIEN,0);
end;

procedure TLabTest.ChangeComment(const CommentText: string);
begin
  Comment.Add(CommentText);
end;

function TLabTest.LabCanCollect: Boolean;
var
  i: Integer;
begin
  Result := False;
  i := IndexOfCollSamp(CollSamp);
  if i > -1 then with TCollSamp(CollSampList.Items[i]) do Result := LabCanCollect;
end;

procedure TLabTest.LoadCollSamp(AComboBox: TORComboBox);
{ loads the collection sample combo box, expects CollSamp to already be set to default }
var
  i: Integer;
  x: string;
begin
  AComboBox.Clear;
  with CollSampList do for i := 0 to Count - 1 do with TCollSamp(Items[i]) do
  begin
    x := IntToStr(CollSampID) + '^' + CollSampName;
    if Length(TubeColor) <> 0 then x := x + ' (' + TubeColor + ')';
    AComboBox.Items.Add(x);
    if CollSamp = CollSampID then AComboBox.ItemIndex := i;
  end;
  if ((ALabTest.LabSubscript = 'CH') and (not UserHasLRLABKey)) then
    begin
      // do not add 'Other'   (coded this way for clarity)
    end
  else
    with AComboBox do
      begin
        Items.Add('0^Other...');
        if ItemIndex < 0 then ItemIndex := Items.IndexOf('Other...');
      end;
end;

procedure TLabTest.LoadSpecimen(AComboBox: TORComboBox);
{ loads specimen combo box, if SpecimenList is empty, use 'E' xref on 61 ?? }
var
  i: Integer;
  tmpResp: TResponse;
begin
  AComboBox.Clear;
  if ObtainSpecimen then
    begin
      if SpecimenList.Count = 0 then LoadSpecimens(SpecimenList) ;
      FastAssign(SpecimenList, AComboBox.Items);
      AComboBox.Items.Add('0^Other...');
      with QuickOrderResponses do tmpResp := FindResponseByName('SPECIMEN'  ,1);
      if (LRFSPEC <> '') and (tmpResp = nil) then
        AComboBox.SelectByID(LRFSPEC)
      else if Specimen > 0 then
        AComboBox.SelectByIEN(Specimen)
      else
        AComboBox.ItemIndex := AComboBox.Items.IndexOf('Other...');
    end
  else
    begin
      i := IndexOfCollSamp(CollSamp);
      if i < CollSampList.Count then with TCollSamp(CollSampList.Items[i]) do
        begin
          AComboBox.Items.Add(IntToStr(SpecimenID) + '^' + SpecimenName);
          AComboBox.ItemIndex := 0;
        end;
      with QuickOrderResponses do tmpResp := FindResponseByName('SPECIMEN'  ,1);
      if (LRFSPEC <> '') and (tmpResp = nil) then
        begin
          AComboBox.Items.Add(GetOneSpecimen(StrToInt(LRFSPEC)));
          AComboBox.SelectByID(LRFSPEC);
        end;
    end;
  ChangeSpecimen(AComboBox.ItemID);
end;

procedure TfrmODLab.LoadCollType(AComboBox:TORComboBox);
var
  i: integer;
begin
  with CtrlInits, cboCollType do
    begin
      SetControl(cboCollType, 'Collection Types');
      if not ALabTest.LabCanCollect then
        begin
          i := SelectByID('LC');
          if i > -1 then Items.Delete(i);
          i := SelectByID('I');
          if i > -1 then Items.Delete(i);
        end ;
      if LRFZX <> '' then
        begin
          if (LRFZX = 'LC') or (LRFZX = 'I') then
            begin
              if ALabTest.LabCanCollect then
                cboCollType.SelectByID(LRFZX)
              else
                cboCollType.SelectByID('WC');
            end
          else
            cboCollType.SelectByID(LRFZX);
        end
      else if FLastCollType <> '' then
        begin
          if (FLastCollType = 'LC') or (FLastCollType = 'I') then
            begin
              if ALabTest.LabCanCollect then
                cboCollType.SelectByID(FLastCollType)
              else
                cboCollType.SelectByID('WC');
            end
          else
            cboCollType.SelectByID(FLastCollType);
        end
      else if uDfltCollType <> '' then
        begin
          if (uDfltCollType = 'LC') or (uDfltCollType = 'I') then
            begin
              if ALabTest.LabCanCollect then
                cboCollType.SelectByID(uDfltCollType)
              else
                cboCollType.SelectByID('WC');
            end
          else
            cboCollType.SelectByID(uDfltCollType);
        end
      else if OrderForInpatient then
        begin
          if ALabTest.LabCanCollect then
            cboCollType.SelectByID('LC')
          else
            SelectByID('WC');
        end
      else
        cboCollType.SelectByID('SP');
    end;
  SetupCollTimes(cboCollType.ItemID);
end;

procedure TLabTest.LoadUrgency(CollType: string; AComboBox:TORComboBox);
var
  i, PreviousSelectionIndex: integer;
  PreviousSelectionString: String;
begin
  with AComboBox do
    begin
    PreviousSelectionIndex := -1;
    PreviousSelectionString := SelText;

      Clear;
      for i := 0 to UrgencyList.Count - 1 do begin
         if (CollType = 'LC') and (Piece(UrgencyList[i], U, 3) = '') then
           Continue
         else
           Items.Add(UrgencyList[i]);
         if (PreviousSelectionString <> '') and (PreviousSelectionString = Piece(UrgencyList[i], U, 2)) then
           PreviousSelectionIndex := i;
      end;

      if (LRFURG <> '') and (ALabTest.ObtainUrgency) then
        SelectByID(LRFURG)
      else if PreviousSelectionIndex > -1 then
        ItemIndex := PreviousSelectionIndex
      else
        SelectByIEN(uDfltUrgency);
      Urgency := AComboBox.ItemIEN;
    end;
end;

function TLabTest.NameOfCollSamp: string;
var
  i: Integer;
begin
  Result := '';
  i := IndexOfCollSamp(CollSamp);
  if i > -1 then with TCollSamp(CollSampList.Items[i]) do Result := CollSampName;
end;

function TLabTest.NameOfSpecimen: string;
var
  i: Integer;
begin
  Result := '';
  if CollSamp > 0 then with TCollSamp(CollSampList[IndexOfCollSamp(CollSamp)]) do
    if (Specimen > 0) and (Specimen = SpecimenID) then Result := SpecimenName;
  if (Length(Result) = 0) and (Specimen > 0) then with SpecimenList do
    for i := 0 to Count - 1 do if Specimen = StrToInt(Piece(Strings[i], '^', 1)) then
    begin
      Result := Piece(Strings[i], '^', 2);
      break;
    end;
end;

function TLabTest.NameOfUrgency: string;
var
  i: Integer;
begin
  Result := '';
  with UrgencyList do for i := 0 to Count - 1 do
  begin
    if StrToInt(Piece(Strings[i], '^', 1)) = Urgency
      then Result := Piece(Strings[i], '^', 2);
    break;
  end;
end;

function TLabTest.ObtainCollSamp: Boolean;
begin
  Result := (not UniqueCollSamp);
end;

function TLabTest.ObtainSpecimen: Boolean;
var
  i: Integer;
begin
  Result := True;
  i := IndexOfCollSamp(CollSamp);
  if (i > -1) and (i < CollSampList.Count) then with TCollSamp(CollSampList.Items[i]) do
    if SpecimenID > 0 then Result := False;
end;

function TLabTest.ObtainUrgency: Boolean;
begin
  Result := not ForceUrgency;
end;

function TLabTest.ObtainComment: Boolean;
begin
  Result := Length(CurReqComment) > 0;
end;

{ end of TLabTest object }

procedure TfrmODLab.ControlChange(Sender: TObject);
var
  AResponse: TResponse;
  AVisitStr: string;
begin
  inherited;
  if Changing or (ALabTest = nil) then Exit;
  AResponse := Responses.FindResponseByName('VISITSTR', 1);
  if AResponse <> nil then
    AVisitStr := AResponse.EValue;
  Responses.Clear;
  with ALabTest do
  begin
    if TestID > 0 then Responses.Update('ORDERABLE', 1, IntToStr(TestID), TestName);
    if CollSamp > 0 then Responses.Update('SAMPLE', 1, IntToStr(CollSamp), NameOfCollSamp)
      else Responses.Update('SAMPLE', 1, '', '');
    if Specimen > 0 then Responses.Update('SPECIMEN', 1, IntToStr(Specimen), NameOfSpecimen)
      else Responses.Update('SPECIMEN', 1, '', '');
    if Urgency > 0 then Responses.Update('URGENCY', 1, IntToStr(Urgency), NameOfUrgency);
    if Length(Comment.Text) > 0 then Responses.Update('COMMENT', 1, TX_WPTYPE, Comment.Text);
    with cboCollType do if Length(ItemID) > 0 then
      begin
        Responses.Update('COLLECT', 1, ItemID, ItemID) ;
        FLastCollType := ItemID;
      end;
  end;
  if cboCollType.ItemID = 'LC' then
    begin
      with cboCollTime do
        if Length(ItemID) > 0 then
          begin
            Responses.Update('START', 1, Copy(ItemID, 2, 999), Copy(ItemID, 2, 999));
            FLastLabCollTime := ItemID + U + Text;
          end
        else if Length(Text) > 0 then
          begin
            Responses.Update('START', 1, ValidCollTime(Text), Text) ;
            FLastLabCollTime := ValidCollTime(Text);
          end;
    end
  else
    begin
      with calCollTime do
        if FMDateTime > 0 then
          begin
            Responses.Update('START', 1, ValidCollTime(Text), Text);
            FLastColltime := ValidCollTime(Text);
          end
        else
          begin
            Responses.Update('START', 1, '', '') ;
            FLastCollTime := '';
          end;
    end;
  with cboFrequency do if Length(ItemID) > 0
    then Responses.Update('SCHEDULE', 1, ItemID, Text);
  with txtDays do if Enabled then Responses.Update('DAYS', 1, Text, Text);
  { worry about stop date later }
  if AVisitStr <> '' then Responses.Update('VISITSTR', 1, AVisitStr, AVisitStr);
  memOrder.Text := Responses.OrderText;
end;

procedure TfrmODLab.Validate(var AnErrMsg: string);

  procedure SetError(const x: string);
  begin
    if Length(AnErrMsg) > 0 then AnErrMsg := AnErrMsg + CRLF;
    AnErrMsg := AnErrMsg + x;
  end;

var
  CmtType,DaysofFuturePast, y: integer;
  (*Hours, *)DayMax, (*Daily, *)NoOfTimes, (*DayFreq,*) Minutes: integer;
  d1, d2: TDateTime;
  Days, MsgTxt: Double;
  x: string;
  ACollType: string;
const
  TX_NO_TIME        = 'Collection Time is required.' ;
  TX_NO_TCOLLTYPE   = 'Collection Type is required.' ;
  TX_NO_TESTS       = 'A Lab Test or tests must be selected.' ;
  TX_BAD_TIME       = 'Collection times must be chosen from the drop down list or entered as valid' +
                      ' Fileman date/times (T@1700, T+1@0800, etc.).' ;
  TX_PAST_TIME      = 'Collection times in the past are not allowed.';
  TX_NO_DAYS        = 'A number of days must be entered for continuous orders.';
  TX_NO_TIMES       = 'A number of times must be entered for continuous orders.';
  TX_NO_STOP_DATE   = 'Could not calculate the stop date for the order.  Check "for n Days".';
  TX_TOO_MANY_DAYS  = 'Maximum number of days allowed is ';
  TX_TOO_MANY_TIMES = 'For this frequency, the maximum number of times allowed is:  X';
  //TX_NO_COMMENT     = 'A comment is required for this test and collection sample.';
  TX_NUMERIC_REQD   = 'A numeric value is required for urine volume.';
  TX_DOSEDRAW_REQD  = 'Both DOSE and DRAW times are required for this order.';
  TX_TDM_REQD       = 'A value for LEVEL is required for this order.';
  //TX_ANTICOAG_REQD  = 'You must specify an anticoagulant on this order.' ;
  TX_NO_COLLSAMPLE  = 'A collection sample MUST be specified.';
  TX_NO_SPECIMEN    = 'A specimen MUST be specified.';
  TX_NO_URGENCY     = 'An urgency MUST be specified.';
  TX_NO_FREQUENCY   = 'A collection frequency MUST be specified.';
  TX_NOT_LAB_COLL_TIME = ' is not a routine lab collection time.';
  TX_NO_ALPHA       = 'For continuous orders, enter a number of days, or an "X" followed by a number of times.';
  TX_BADTIME_CAP    = 'Invalid Immediate Collect Time';

begin
  inherited;
  { need to go thru list and make sure everything is filled in }
  with cboAvailTest do if ItemIEN <= 0 then SetError(TX_NO_TESTS);

  if ALabTest <> nil then
    if (cboCollType.ItemID = 'I') and (not ALabTest.LabCanCollect) then
      begin
        SetError(TX_NO_IMMED);
        cboCollType.ItemIndex := -1;
      end;

  if cboCollType.ItemID = '' then
    SetError(TX_NO_TCOLLTYPE)
  else if cboCollType.ItemID = 'LC' then
   begin
     if Length(cboCollTime.Text) = 0 then SetError(TX_NO_TIME);
     with cboCollTime do if (Length(Text) > 0) and (ItemIndex = -1) then
       begin
         if StrToFMDateTime(Text) < 0 then
           SetError(TX_BAD_TIME)
         else if StrToFMDateTime(Text) < FMNow then
           SetError(TX_PAST_TIME)
         else if OrderForInpatient then
           begin
             d1 := FMDateTimeToDateTime(Trunc(StrToFMDateTime(cboColltime.Text)));
             d2 := FMDateTimeToDateTime(FMToday);
             if EvtDelayLoc > 0 then
               DaysofFuturePast := LabCollectFutureDays(EvtDelayLoc,EvtDivision)
             else
               DaysofFuturePast := LabCollectFutureDays(Encounter.Location);
             if DaysofFuturePast = 0 then DaysofFuturePast := 7;
             if ((d1 - d2) > DaysofFuturePast) then
               SetError('A lab collection cannot be ordered more than '
                 + IntToStr(DaysofFuturePast) + ' days in advance');
           end
         else if EvtDelayLoc > 0 then
           begin
             if (not IsLabCollectTime(StrToFMDateTime(cboCollTime.Text), EvtDelayLoc)) then
               SetError(cboCollTime.Text + TX_NOT_LAB_COLL_TIME);
           end
         else if EvtDelayLoc <= 0 then
           begin
             if (not IsLabCollectTime(StrToFMDateTime(cboCollTime.Text), Encounter.Location)) then
               SetError(cboCollTime.Text + TX_NOT_LAB_COLL_TIME);
           end;
       end;
   end
  else
    begin
      if cboCollType.ItemID = 'I' then
        begin
          calCollTime.Text := txtImmedColl.Text;
          x := ValidImmCollTime(calCollTime.FMDateTime);
          if (Piece(x, U, 1) <> '1') then
            SetError(Piece(x, U, 2));
        end;

      with calColltime do
        begin
          if FMDateTime = 0 then SetError(TX_BAD_TIME)
          else
            begin
              // date only was entered
              if (FMDateTime - Trunc(FMDateTime) = 0) then
                begin
                  if (Trunc(FMDateTime) < FMToday) then SetError(TX_PAST_TIME);
                end
              // date/time was entered
              else
                begin
                  if (UpperCase(Text) <> 'NOW') and (FMDateTime < FMNow) then SetError(TX_PAST_TIME);
                end;
            end;
        end;
    end;

  with cboCollSamp  do
    if ItemIndex < 0 then
      SetError(TX_NO_COLLSAMPLE)
    else if (ItemIndex >= 0) and (ItemIEN = 0) then
      begin
        if ALabTest <> nil then
          GetAllCollSamples(cboCollSamp);
        if ItemIEN = 0 then SetError(TX_NO_COLLSAMPLE);
      end;

  with cboSpecimen  do
    if ItemIndex < 0 then
      SetError(TX_NO_SPECIMEN)
    else if (ItemIndex >= 0) and (ItemIEN = 0) then
      begin
        if (ALabTest <> nil) and (cboCollSamp.ItemIEN > 0) then
          GetAllSpecimens(cboSpecimen);
        if ItemIEN = 0 then SetError(TX_NO_SPECIMEN);
      end;

  If (ALabTest <> nil) and (ALabTest.Urgency <= 0) then begin
   with ALabTest do
    ChangeUrgency(cboUrgency.ItemID);
   ControlChange(Self);
  end;

  with cboUrgency   do if ItemIEN  <= 0 then SetError(TX_NO_URGENCY);
  with cboFrequency do if ItemIEN  <= 0 then SetError(TX_NO_FREQUENCY);

  if ALabTest <> nil then
    begin
      CmtType := FCmtTypes.IndexOf(ALabTest.CurReqComment) ;
      with ALabTest do
      case CmtType of
        0 : {ANTICOAGULATION}         {if (Pos('ANTICOAGULANT',Comment.Text)=0) then
                                     SetError(TX_ANTICOAG_REQD)};
        1 : {DOSE/DRAW TIMES}         if (Pos('Last dose:',Comment.Text)=0) or
                                      (Pos('draw time:',Comment.Text)=0) then
                                     SetError(TX_DOSEDRAW_REQD);
        2 : {ORDER COMMENT}           {if (Length(Comment.Text)=0) then
                                     SetError(TX_NO_COMMENT)};
        3 : {ORDER COMMENT MODIFIED}  {if (Length(Comment.Text)=0) then
                                     SetError(TX_NO_COMMENT)};
        4 : {TDM (PEAK-TROUGH}        if (Pos('Dose is expected',Comment.Text)=0) then
                                     SetError(TX_TDM_REQD);
        5 : {TRANSFUSION}             {if (Length(Comment.Text)=0) then
                                     SetError(TX_NO_COMMENT)};
        6 : {URINE VOLUME}            if (Length(Comment.Text)>0) and
                                   (ExtractInteger(Comment.Text)<=0) then
                                      Comment.Text := '?';
                                     {SetError(TX_NUMERIC_REQD);}
        {   else
              if (Length(CurReqComment)>0) and (Length(Comment.Text)=0) then
                SetError(TX_NO_COMMENT); }
      end;
    end;

  with txtDays do if Enabled then
    begin
      DayMax := 0;
      if (cboCollType.ItemID = 'LC') or (cboCollType.ItemID = 'I') then
      begin
        if EvtDelayLoc > 0 then
          DayMax := LabCollectFutureDays(EvtDelayLoc,EvtDivision)
        else
          DayMax := LabCollectFutureDays(Encounter.Location);
      end;
      if DayMax = 0 then
      begin
         if EvtDelayLoc > 0 then
           DayMax := MaxDays(EvtDelayLoc, cboFrequency.ItemIEN)
         else
           DayMax := MaxDays(Encounter.Location, cboFrequency.ItemIEN);
      end;
      x := Piece(cboFrequency.Items[cboFrequency.ItemIndex], U, 3);
      if (x = 'C') or (x = 'D') then
        begin
          Minutes := StrToIntDef(Piece(cboFrequency.Items[cboFrequency.ItemIndex], U, 4), 0);
          Days := Minutes / 1440;
          if (Days = 0) then Days := 1;
          if Pos('X', UpperCase(txtDays.Text)) > 0 then
            begin
              x := Trim(Copy(txtDays.Text, 1, Pos('X', UpperCase(txtDays.Text)) - 1)) +
                   Trim(Copy(txtDays.Text, Pos('X', UpperCase(txtDays.Text)) + 1, 99));
              NoOfTimes := ExtractInteger(x);
              Days := NoOfTimes * Days;                                      // # days requested
              if FloatToStr(NoOfTimes) <> x then
                SetError(TX_NO_ALPHA)
              else if NoOfTimes = 0 then
                SetError(TX_NO_TIMES)
              else if (Days > DayMax) then
                begin
                  MsgTxt := Minutes / 60;
                  x := ' hour';
                  if MsgTxt > 24 then
                    begin
                      MsgTxt := MsgTxt / 24;
                      x := ' day';
                    end;
                  if MsgTxt > 1 then x := x + 's';
                  y := 0;
                  if Minutes > 0 then y := (DayMax * 1440) div Minutes;
                  if y = 0 then y := 1;
                  //if y > 0 then
                    SetError(TX_TOO_MANY_TIMES + IntToStr(y) + CRLF +
                      '     (Every ' + FloatToStr(MsgTxt) + x + ' for a maximum of ' + IntToStr(DayMax) + ' days.)')
                  //else
                  //  Responses.Update('DAYS', 1, 'X1', 'X1');
                end
              else
                begin
                  x := 'X' + IntToStr(NoOfTimes);
                  Responses.Update('DAYS', 1, x, x);
                end;
            end
          else
            begin
              Days := ExtractInteger(txtDays.Text);
              if FloatToStr(Days) <> Trim(txtDays.Text) then
                SetError(TX_NO_ALPHA)
                //SetError(TX_NO_DAYS)    v18.6  (RV)
              else if (Days > DayMax) then
                SetError(TX_TOO_MANY_DAYS + IntToStr(DayMax))
              else
                Responses.Update('DAYS', 1, txtDays.Text, txtDays.Text);
            end;
        end;
    end;

  if (AnErrMsg <> '') or (Self.EvtID > 0) then exit;
    
  // add check and display for auto-change from LC to WC - v27.1 - CQ #10226
  ACollType := Responses.FindResponseByName('COLLECT', 1).EValue;
  if ((ACollType = 'LC') or (ACollType = 'I')) then DisplayChangedOrders(ACollType);
end;

procedure TfrmODLab.DisplayChangedOrders(ACollType: string);
var
  AStartDate, ASchedule, ADuration: string;
  ChangedOrdersList, AList: TStringlist;
  i, j, k: integer;
begin
  ChangedOrdersList := TStringList.Create;
  try
    AStartDate := Responses.FindResponseByName('START', 1).IValue;
    ASchedule  := Responses.FindResponseByName('SCHEDULE', 1).IValue;
    if txtDays.Enabled then ADuration := Responses.FindResponseByName('DAYS', 1).EValue else ADuration := '';
    CheckForChangeFromLCtoWCOnAccept(ChangedOrdersList, Encounter.Location, AStartDate, ACollType, ASchedule, ADuration);
    if ChangedOrdersList.Text <> '' then
    begin
      AList := TStringList.Create;
      try
        AList.Text := Responses.OrderText;
        with ChangedOrdersList do
        begin
          Insert(5, 'Order   :' + #9 + AList[0]);
          k := Length(ChangedOrdersList[5]);
          i := 0;
          if AList.Count > 1 then
            for j := 1 to AList.Count - 1 do
            begin
              Insert(5 + j, StringOfChar(' ', 9) + #9 + AList[j]);
              k := HigherOf(k, Length(ChangedOrdersList[5 + j]));
              i := j;
            end;
          Insert(5 + i + 1, StringOfChar('-', k + 4));
        end;
        ReportBox(ChangedOrdersList, 'Changed Orders', TRUE);
      finally
        AList.Free;
      end;
    end;
  finally
    ChangedOrdersList.Free;
  end;
end;

procedure TfrmODLab.cboAvailTestNeedData(Sender: TObject;
              const StartFrom: string; Direction, InsertAt: Integer);
begin
  cboAvailTest.ForDataUse(SubsetOfOrderItems(StartFrom, Direction, 'S.LAB', Responses.QuickOrder));
end;

procedure TfrmODLab.cboAvailTestExit(Sender: TObject);
begin
  inherited;
  if (Length(cboAvailTest.ItemID) = 0) or (cboAvailTest.ItemID = '0') then Exit;
  if cboAvailTest.ItemID = FLastLabID then Exit;
  cboAvailTestSelect(cboAvailTest);
  cboAvailTest.SetFocus;
  PostMessage(Handle, WM_NEXTDLGCTL, 0, 0);
end;

procedure TfrmODLab.cboAvailTestSelect(Sender: TObject);
var
  x: string;
  i: integer;
  tmpResp: TResponse;
begin
  with cboAvailTest do
    begin
      if (Length(ItemID) = 0) or (ItemID = '0') then Exit;
      FLastLabID := ItemID ;
      FLastItemID := ItemID;
      Changing := True;
      if Sender <> Self then
        Responses.Clear;       // Sender=Self when called from SetupDialog
      if CharAt(ItemID, 1) = 'Q' then
        with Responses do
          begin
            FLastItemID := ItemID;
            QuickOrder := ExtractInteger(ItemID);
            SetControl(cboAvailTest, 'ORDERABLE', 1);
            if (Length(ItemID) = 0) or (ItemID = '0') then Exit;
            FLastLabID := ItemID;
          end;
      ALabTest := TLabTest.Create(ItemID, Responses);
    end;
  with ALabTest do
  begin
    lblTestName.Caption := TestName;
    LoadCollSamp(cboCollSamp);
    cboCollSampChange(Self);
    LoadSpecimen(cboSpecimen);
    LoadUrgency(cboCollType.ItemID, cboUrgency);
    with Responses do if QuickOrder > 0 then
     begin
      StatusText('Initializing Quick Order');
      Changing := True;
      SetControl(cboAvailTest,       'ORDERABLE', 1);
      SetControl(cboFrequency,       'SCHEDULE', 1);
      SetControl(txtDays,            'DAYS', 1);
      tmpResp := FindResponseByName('SAMPLE'  ,1);
      if (tmpResp <> nil) and (tmpResp.IValue <> '') then with cboCollSamp do
        begin
          SelectByID(tmpResp.IValue);
          if ItemIndex < 0 then
            begin
              LoadAllSamples;
              Items.Insert(0, tmpResp.IValue + U + tmpResp.EValue);
              ItemIndex := 0  ;
            end;
        end
      else if LRFSAMP <> '' then
        cboCollSamp.SelectByID(LRFSAMP);
      if (cboCollSamp.ItemIndex < 0) and (cboCollSamp.Items.IndexOf('Other...') >= 0) then cboCollSamp.SelectByID('0');
      cboCollSampChange(Self);
      DetermineCollectionDefaults(Responses);
      LoadUrgency(cboCollType.ItemID, cboUrgency);
      SetControl(cboUrgency,         'URGENCY', 1);
      Urgency := cboUrgency.ItemIEN;
      if (Urgency = 0) and (cboUrgency.Items.Count = 1) then
        begin
          cboUrgency.ItemIndex := 0;
          Urgency := cboUrgency.ItemIEN;
        end;
      tmpResp := FindResponseByName('SPECIMEN'  ,1);
      if (tmpResp <> nil) and (tmpResp.IValue <> '') then with cboSpecimen do
        begin
          SelectByID(tmpResp.IValue);
          if ItemIndex < 0 then
            begin
              if ALabTest <> nil then
                ALabTest.SpecimenList.Add(tmpResp.IValue + U + tmpResp.EValue);
              Items.Insert(0, tmpResp.IValue + U + tmpResp.EValue);
              ItemIndex := 0  ;
            end;
        end
      else if LRFSPEC <> '' then
        cboSpecimen.SelectByID(LRFSPEC);
      if (cboSpecimen.ItemIndex < 0) and (cboSpecimen.Items.IndexOf('Other...') >= 0) then cboSpecimen.SelectByID('0');
      Specimen := cboSpecimen.ItemIEN;
      i := 1 ;
      tmpResp := Responses.FindResponseByName('COMMENT',i);
      while tmpResp <> nil do
        begin
          Comment.Add(tmpResp.EValue);
          Inc(i);
          tmpResp := Responses.FindResponseByName('COMMENT',i);
        end ;
      with cboFrequency do
        if not Enabled then
          begin
            ItemIndex := Items.IndexOf('ONE TIME');
            if ItemIndex = -1 then ItemIndex := Items.IndexOf('ONCE');
          end;
      cboFrequencyChange(Self);
     end;  //  Quick Order
    if ObtainCollSamp then
      begin
        lblCollSamp.Enabled := True;
        cboCollSamp.Enabled := True;
        //TDP - CQ#19396 Added cboCollSamp 508 changes
        setup508Label(cboCollSamp.Text, collsamplbl508, cboCollSamp, lblCollSamp.Caption);
      end
    else
      begin
        with ALabTest do
          with TCollSamp(CollSampList.Items[IndexOfCollSamp(CollSamp)]) do
            begin
              x := '' ;
              for i := 0 to WardComment.Count-1 do
                x := x + WardComment.strings[i]+#13#10 ;
              pnlMessage.TabOrder := cboAvailTest.TabOrder + 1;
              OrderMessage(x) ;
            end ;
        lblCollSamp.Enabled := False;
        cboCollSamp.Enabled := False;
        //TDP - CQ#19396 Added cboCollSamp 508 changes
        setup508Label(cboCollSamp.Text, collsamplbl508, cboCollSamp, lblCollSamp.Caption);
      end;
    if ObtainSpecimen then
    begin
      lblSpecimen.Enabled:= True;
      cboSpecimen.Enabled:= True;
      setup508Label(cboSpecimen.Text, specimenlbl508, cboSpecimen, lblSpecimen.Caption);
    end else
    begin
      lblSpecimen.Enabled:= False;
      cboSpecimen.Enabled:= False;
      setup508Label(cboSpecimen.Text, specimenlbl508, cboSpecimen, lblSpecimen.Caption);
    end;
    if ObtainUrgency then
    begin
      lblUrgency.Enabled := True;
      cboUrgency.Enabled := True;
    end else
    begin
      lblUrgency.Enabled := False;
      cboUrgency.Enabled := False;
    end;
    if ObtainComment then
      LoadRequiredComment(FCmtTypes.IndexOf(CurReqComment))
    else
      DisableCommentPanels;
    x := '' ;
    for i := 0 to CurWardComment.Count-1 do
      x := x + CurWardComment.strings[i]+#13#10 ;
    i :=  IndexOfCollSamp(CollSamp);
    if i > -1 then with TCollSamp(CollSampList.Items[IndexOfCollSamp(CollSamp)]) do
       for i := 0 to WardComment.Count-1 do
         x := x + WardComment.strings[i]+#13#10 ;
    pnlMessage.TabOrder := cboAvailTest.TabOrder + 1;
    OrderMessage(x) ;
   end; { with }
  StatusText('');
  Changing := False;
  if Sender <> Self then ControlChange(Self);
end;

procedure TfrmODLab.cboCollSampChange(Sender: TObject);
var
  i: integer;
  x: string;
begin
  if (ALabTest = nil) or (cboCollSamp.ItemIEN = 0) then exit;
  with ALabTest do
  begin
    ChangeCollSamp(cboCollSamp.ItemIEN);
    LoadSpecimen(cboSpecimen);
    LoadCollType(cbocollType);
    LoadUrgency(cboCollType.ItemID, cboUrgency);
    if ObtainSpecimen then
     begin
      lblSpecimen.Enabled:= True;
      cboSpecimen.Enabled:= True;
      setup508Label(cboSpecimen.Text, specimenlbl508, cboSpecimen, lblSpecimen.Caption);
     end else
     begin
      lblSpecimen.Enabled:= False;
      cboSpecimen.Enabled:= False;
      setup508Label(cboSpecimen.Text, specimenlbl508, cboSpecimen, lblSpecimen.Caption);
     end;
    if ObtainComment then
       LoadRequiredComment(FCmtTypes.IndexOf(CurReqComment))
    else
       DisableCommentPanels;
    if not Changing then with TCollSamp(CollSampList.Items[IndexOfCollSamp(CollSamp)]) do
      begin
          x := '' ;
          for i := 0 to WardComment.Count-1 do
            x := x + WardComment.strings[i]+#13#10 ;
          pnlMessage.TabOrder := cboCollSamp.TabOrder + 1;
          OrderMessage(x) ;
      end ;
  end;
  ControlChange(Self);
end;

procedure TfrmODLab.cboUrgencyChange(Sender: TObject);
begin
  if ALabTest = nil then exit;
  with ALabTest do
    ChangeUrgency(cboUrgency.ItemID);
  ControlChange(Self);
end;

procedure TfrmODLab.cboSpecimenChange(Sender: TObject);
begin
  if ALabTest = nil then exit;
  with cboSpecimen do if Text = 'Other...' then
    if (ItemIndex >= 0) and (ItemIEN = 0) then
      GetAllSpecimens(cboSpecimen);
  with ALabTest do
    ChangeSpecimen(cboSpecimen.ItemID);
  ControlChange(Self);
end;

procedure TfrmODLab.cboCollTimeChange(Sender: TObject);
var
  CollType: string;
const
  TX_BAD_TIME         = ' is not a routine lab collection time.' ;
  TX_BAD_TIME_CAP     = 'Invalid Time';
begin
  CollType := 'LC';
  with cboCollTime do if ItemID = 'LO' then
    begin
      ItemIndex := -1;
      Text := GetFutureLabTime(FMToday);
    end;
  //cboCollType.SelectByID(CollType);
  ControlChange(Self);
end;

procedure TfrmODLab.cboFrequencyChange(Sender: TObject);
var
  x, HowManyText: string;
const
  HINT_TEXT1 = 'Enter a number of days';
  HINT_TEXT2 = ', or an "X" followed by a number of times.';
begin
  with cboFrequency do if ItemIndex > -1 then x := Items[ItemIndex];
  with cboFrequency do
    if (ItemIndex > -1) and (Piece(Items[ItemIndex], U, 3) <> 'O') then
      begin
        lblHowManyDays.Enabled := True;
        if Piece(Items[ItemIndex], U, 3) = 'C' then
          txtDays.Hint := HINT_TEXT1 + HINT_TEXT2
        else
          txtDays.Hint := '';
        txtDays.Enabled := True;
        //TDP - txtDays 508 changes
        if txtDays.Text = '' then HowManyText := 'no value'
        else HowManyText := txtDays.Text;
        setup508Label(HowManyText, HowManyDayslbl508, txtDays, lblHowManyDays.Caption);
        txtDays.Showhint := True;
      end
    else
      begin
        txtDays.Text := '';
        lblHowManyDays.Enabled := False;
        txtDays.Enabled := False;
        //TDP - txtDays 508 changes
        HowManyText := 'no value';
        setup508Label(HowManyText, HowManyDayslbl508, txtDays, lblHowManyDays.Caption);
        txtDays.ShowHint := False;
      end;
  ControlChange(Self);
end;

procedure TfrmODLab.cboCollTypeChange(Sender: TObject);
begin
  if (ALabTest = nil) or Changing or (cboCollType.ItemID = '') then exit;
  if (cboCollType.ItemID = 'I') and (not ALabTest.LabCanCollect) then
    begin
      InfoBox(TX_NO_IMMED, TX_NO_IMMED_CAP, MB_OK or MB_ICONWARNING);
      cboCollType.ItemIndex := -1;
      Exit;
    end;
  SetupCollTimes(cboCollType.ItemID);
  ALabTest.LoadUrgency(cboCollType.ItemID, cboUrgency);
  ControlChange(Self);
end;

procedure TfrmODLab.SetupCollTimes(CollType: string);
var
  tmpImmTime, tmpTime: TFMDateTime;
  x, tmpORECALLType, tmpORECALLTime: string;
begin
  x := GetLastCollectionTime;
  tmpORECALLType := Piece(x, U, 1);
  tmpORECALLTime := Piece(x, U, 2);
  if CollType = 'SP' then
    begin
      cboColltime.Visible    := False;
      txtImmedColl.Visible   := False;
      pnlCollTimeButton.Visible   := False;
      pnlCollTimeButton.TabStop := False;
      calCollTime.Visible    := True;
      calColltime.Enabled    := True;
      if FLastCollTime <> '' then
        begin
          calCollTime.Text := ValidCollTime(FLastColltime);
          if IsFMDateTime(calCollTime.Text) then
            begin
              calCollTime.Text := FormatFMDateTime('dddddd@hh:nn', StrToFMDateTime(calColltime.Text));
              calColltime.FMDateTime := StrToFMDateTime(FLastCollTime);
            end;
        end
      else if tmpORECALLTime <> '' then
        begin
          calCollTime.Text := ValidCollTime(tmpORECALLTime);
          if IsFMDateTime(calCollTime.Text) then
            begin
              calCollTime.Text := FormatFMDateTime('dddddd@hh:nn', StrToFMDateTime(calColltime.Text));
              calColltime.FMDateTime := StrToFMDateTime(tmpORECALLTime);
            end;
        end
      else if LRFDATE <> '' then
        calCollTime.Text     := LRFDATE
      else
        calCollTime.Text     := 'TODAY';
    end
  else if CollType = 'WC' then
    begin
      cboColltime.Visible    := False;
      txtImmedColl.Visible   := False;
      pnlCollTimeButton.Visible   := False;
      pnlCollTimeButton.TabStop := False;
      calCollTime.Visible    := True;
      calColltime.Enabled    := True;
      if FLastCollTime <> '' then
        begin
          calCollTime.Text := ValidColltime(FLastColltime);
          if IsFMDateTime(calCollTime.Text) then
            begin
              calCollTime.Text := FormatFMDateTime('dddddd@hh:nn', StrToFMDateTime(calColltime.Text));
              calColltime.FMDateTime := StrToFMDateTime(FLastCollTime);
            end;
        end
      else if tmpORECALLTime <> '' then
        begin
          calCollTime.Text := ValidColltime(tmpORECALLTime);
          if IsFMDateTime(calCollTime.Text) then
            begin
              calCollTime.Text := FormatFMDateTime('dddddd@hh:nn', StrToFMDateTime(calColltime.Text));
              calColltime.FMDateTime := StrToFMDateTime(tmpORECALLTime);
            end;
        end
      else if LRFDATE <> '' then
        calCollTime.Text     := LRFDATE
      else
        calCollTime.Text     := 'NOW';
    end
  else if CollType = 'LC' then
    begin
      cboColltime.Visible    := True;
      calCollTime.Visible    := False;
      calColltime.Enabled    := False;
      txtImmedColl.Visible   := False;
      pnlCollTimeButton.Visible   := False;
      pnlCollTimeButton.TabStop := False;
      with CtrlInits do SetControl(cboCollTime, 'Lab Collection Times');
      if Pos(U, FLastLabCollTime) > 0 then
        cboColltime.SelectByID(Piece(FLastLabCollTime, U, 1))
      else if FLastLabCollTime <> '' then
        cboCollTime.Text     := FLastLabCollTime
      else if (tmpORECALLTime <> '') and (tmpORECALLType = 'LC') then
        cboCollTime.Text     := MakeRelativeDateTime(StrToFMDateTime(tmpORECALLTime))
      else if LRFDATE <> '' then
        cboCollTime.Text     := LRFDATE
      else
        cboCollTime.ItemIndex := 0;
    end
  else if CollType = 'I' then
    begin
      cboColltime.Visible    := False;
      calCollTime.Visible    := False;
      calColltime.Enabled    := False;
      txtImmedColl.Visible   := True;
      pnlCollTimeButton.Visible   := True;
      pnlCollTimeButton.TabStop := True;
      tmpImmTime := GetDefaultImmCollTime;
      tmpTime := 0;
      if (FLastColltime <> '') then
        tmpTime := StrToFMDateTime(FLastColltime)
      else if (tmpORECALLTime <> '') then
        tmpTime := StrToFMDateTime(tmpORECALLTime)
      else if LRFDATE <> '' then
        tmpTime := StrToFMDateTime(LRFDATE);

      if tmpTime > tmpImmTime then
        begin
          calCollTime.FMDateTime := tmpTime;
          txtImmedColl.Text      := FormatFMDateTime('dddddd@hh:nn', tmpTime);
        end
      else
        begin
          calCollTime.FMDateTime := GetDefaultImmCollTime;
          txtImmedColl.Text      := FormatFMDateTime('dddddd@hh:nn', calCollTime.FMDateTime);
        end;
    end;
end;

procedure TfrmODLab.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  if FCmtTypes <> nil then FCmtTypes.Free;
  frmFrame.pnlVisit.Enabled := true;
end;

procedure TfrmODLab.LoadRequiredComment(CmtType: integer);
begin
  DisableCommentPanels;
  pnlHide.SendToBack;
  lblReqComment.Visible := True ;
  case CmtType of
     0 : {ANTICOAGULATION}         pnlAntiCoagulation.Show ;
     1 : {DOSE/DRAW TIMES}         pnlDoseDraw.Show ;
     2 : {ORDER COMMENT}           pnlOrderComment.Show ;
     3 : {ORDER COMMENT MODIFIED}  pnlOrderComment.Show ; // DIFFERENT ???
     4 : {TDM (PEAK-TROUGH}        begin
                                     pnlPeakTrough.Show ;
                                     grpPeakTrough.ItemIndex := -1;
                                     txtAddlComment.Show;
                                     lblAddlComment.Show;
                                   end;
     5 : {TRANSFUSION}             pnlOrderComment.Show ;
     6 : {URINE VOLUME}            pnlUrineVolume.Show ;
   else
     pnlOrderComment.Show ;
   end;
end;

procedure TfrmODLab.txtOrderCommentExit(Sender: TObject);
begin
  inherited;
  if (not pnlOrderComment.Visible) or (ALabTest = nil) then exit;
  with ALabTest do
      if Length(txtOrderComment.Text)>0 then
       begin
        Comment.Clear;
        ChangeComment('~For Test: ' + TestName);
        ChangeComment('~' + txtOrderComment.Text) ;
       end
      else
        Comment.Clear;
  ControlChange(Self);
end;

procedure TfrmODLab.txtAntiCoagulantExit(Sender: TObject);
begin
  inherited;
  if (not pnlAntiCoagulation.Visible) or (ALabTest = nil) then exit;
  with ALabTest do
      if Length(txtAntiCoagulant.Text)>0 then
       begin
        Comment.Clear;
        ChangeComment('~For Test: ' + TestName);
        ChangeComment('~ANTICOAGULANT: ' + txtAntiCoagulant.Text);
       end
      else
        Comment.Clear;
  ControlChange(Self);
end;

procedure TfrmODLab.txtUrineVolumeExit(Sender: TObject);
begin
  inherited;
  if (not pnlUrineVolume.Visible) or (ALabTest = nil) then exit;
  with ALabTest do
   begin
    Comment.Clear;
    ChangeComment(txtUrineVolume.Text) ;
   end;
  ControlChange(Self);
end;

procedure TfrmODLab.grpPeakTroughClick(Sender: TObject);
begin
  inherited;
  if (not pnlPeakTrough.Visible) or (ALabTest = nil) then exit;
  with ALabTest,grpPeakTrough do
    if ItemIndex > -1 then
      begin
        Comment.Clear;
        ChangeComment('~For Test: ' + TestName);
        ChangeComment('~Dose is expected to be at ' + UpperCase(Items[ItemIndex]) + ' level.');
        ChangeComment(txtAddlComment.Text) ;
      end
    else
      Comment.Clear;
  ControlChange(Self);
end;

procedure TfrmODLab.txtDoseTimeExit(Sender: TObject);
begin
  inherited;
  if (not pnlDoseDraw.Visible) or (ALabTest = nil) then exit;
  with txtDoseTime do
    if Length(Text)>0 then
      Text := FormatFMDateTime('c', StrToFMDateTime(Text))
    else
      Text := 'UNKNOWN';
  DoseDrawComment;
  ControlChange(Self);
end;

procedure TfrmODLab.txtDrawTimeExit(Sender: TObject);
begin
  inherited;
  if (not pnlDoseDraw.Visible) or (ALabTest = nil) then exit;
  with txtDrawTime do
    if Length(Text)>0 then
      Text := FormatFMDateTime('c', StrToFMDateTime(Text))
    else
      Text := 'UNKNOWN';
  DoseDrawComment;
  ControlChange(Self);
end;

procedure TfrmODLab.DoseDrawComment;
begin
  if ALabTest = nil then exit;
  with ALabTest do
   begin
     Comment.Clear;
     ChangeComment('~For Test: ' + TestName);
     ChangeComment('~Last dose: ' + txtDoseTime.Text +
                   '   draw time: '+txtDrawTime.Text);
   end;
end;

procedure TfrmODLab.txtAddlCommentExit(Sender: TObject);
begin
  if (not pnlPeakTrough.Visible) or (ALabTest = nil) then exit;
  grpPeakTroughClick(Sender);
end;

procedure TfrmODLab.DisableCommentPanels;
begin
  pnlHide.BringToFront;
  lblReqComment.Visible := False;
  pnlAntiCoagulation.Visible := False;
  pnlOrderComment.Visible := False;
  pnlDoseDraw.Visible := False;
  pnlPeakTrough.Visible := False;
  pnlUrineVolume.Visible := False;
  lblAddlComment.Visible := False;
  txtAddlComment.Visible := False;
  //pnlTransfusion.Visible := False;
end;

procedure TfrmODLab.cboCollSampKeyPause(Sender: TObject);
begin
  inherited;
  if ALabTest = nil then exit;
  with cboCollSamp do
    if (ItemIndex >= 0) and (ItemIEN = 0) then GetAllCollSamples(cboCollSamp);
  if (cboCollSamp.ItemIEN = 0) then
    begin
      ALabTest.Specimen := 0;
      ALabTest.CollSamp := 0;
      cboCollSamp.ItemIndex := -1;
      cboSpecimen.ItemIndex := -1;
    end
  else
    ALabTest.LoadSpecimen(cboSpecimen);
  ControlChange(Self);
end;

procedure TfrmODLab.cboCollSampMouseClick(Sender: TObject);
begin
  inherited;
  if ALabTest = nil then exit;
  with cboCollSamp do
    begin
      if (ItemIndex >= 0) and (ItemIEN = 0) then
        GetAllCollSamples(cboCollSamp);
      if (ItemIEN = 0) then
        begin
          ALabTest.Specimen := 0;
          ALabTest.CollSamp := 0;
          ItemIndex := -1;
          cboSpecimen.ItemIndex := -1;
        end
      else
        ALabTest.LoadSpecimen(cboSpecimen);
    end;
  ControlChange(Self);
end;

function TfrmODLab.ValidCollTime(UserEntry: string): string;
var
  i: integer;
const
  FMDateResponses: array[0..3] of string = ('TODAY','NOW','NOON','MID');
begin
  Result := '';
  UserEntry := UpperCase(UserEntry);
  if StrToFMDateTime(UserEntry) < 0 then exit;
  if (UserEntry = 'T') or
     (UserEntry = 'N') or
     (Copy(UserEntry,1,2)='T+') or
     (Copy(UserEntry,1,2)='T@') or
     (Copy(UserEntry,1,2)='T-') or
     (Copy(UserEntry,1,2)='N+') then Result := UserEntry
  else
     for i := 0 to 3 do if Pos(FMDateResponses[i],UserEntry)>0 then Result := UserEntry ;
  if Result = '' then Result := FloatToStr(StrToFMDateTime(UserEntry));
end;

procedure TfrmODLab.cboCollTimeExit(Sender: TObject);
var
  ADateTime: TFMDateTime;
  CollType: string;
  isTrue: boolean;
const
  TX_BAD_TIME         = ' is not a routine lab collection time.' ;
  TX_BAD_TIME_CAP     = 'Invalid Time';
begin
  inherited;
  if (ALabTest = nil) or (cboColltime.Text = '') then Exit;
  Changing := True;
  CollType := 'LC';
  with cboCollTime do if (ItemIndex < 0) or (ITEMID = 'LO') then
    if ALabTest.LabCanCollect then
      begin
        ADateTime := StrToFMDateTime(cboCollTime.Text);
        if EvtDelayLoc > 0 then
          isTrue := IsLabCollectTime(ADateTime, EvtDelayLoc)
        else
          isTrue := IsLabCollectTime(ADateTime, Encounter.Location);
        if isTrue then
          begin
            calCollTime.Clear;
            cboCollTime.Visible := True;
            calCollTime.Visible := False;
            calCollTime.Enabled := False;
          end {if IsLabCollectTime}
        else
          begin
            InfoBox(cboCollTime.Text + TX_BAD_TIME, TX_BAD_TIME_CAP, MB_OK or MB_ICONWARNING) ;
            ItemIndex := -1;
            Text := GetFutureLabTime(ADateTime);
          end ;
      end {if (LabCanCollect...}
    else
     begin
       if OrderForInpatient then CollType := 'WC' else CollType := 'SP';
       calCollTime.Text := cboCollTime.Text;
       cboCollTime.Clear;
       cboCollTime.Visible := False;
       calCollTime.Visible := True;
       calCollTime.Enabled := True;
     end;
  cboCollType.SelectByID(CollType);
  Changing := False;                                           //v16.3  RV
  ControlChange(Self);                                         //v16.3  RV
  //Responses.Update('COLLECT', 1, CollType, CollType) ;       //v16.3  RV
  //memOrder.Text := Responses.OrderText;                      //v16.3  RV
end;

procedure TfrmODLab.cboSpecimenMouseClick(Sender: TObject);
begin
  inherited;
  if ALabTest = nil then exit;
  with cboSpecimen do
    begin
      if (ItemIndex >= 0) and (ItemIEN = 0) then
        GetAllSpecimens(cboSpecimen);
      if (ItemIEN = 0) then
        begin
          ALabTest.Specimen := 0;
          ItemIndex := -1;
        end;
    end;
  ControlChange(Self);
end;

procedure TfrmODLab.GetAllCollSamples(AComboBox: TORComboBox);
var
  OtherSamp: string;
begin
  with ALabTest, AComboBox do
    begin
      if ((CollSampList.Count + 1) <= AComboBox.Items.Count) then LoadAllSamples;
      OtherSamp := SelectOtherCollSample(Font.Size, CollSampCount, CollSampList);
      if OtherSamp = '-1' then exit;
      if SelectByID(Piece(OtherSamp, U, 1)) = -1 then
        if Items.Count > CollSampCount + 1 then
          Items[0] := OtherSamp
        else
          Items.Insert(0, OtherSamp) ;
      SelectByID(Piece(OtherSamp, U, 1));
      AComboBox.OnChange(Self);
      ActiveControl := cmdAccept;
    end;
end;

procedure TfrmODLab.GetAllSpecimens(AComboBox: TORComboBox);
var
  OtherSpec: string;
begin
  inherited;
  if ALabTest <> nil then
    with ALabTest, AComboBox do
      begin
        AComboBox.DroppedDown := False;
        OtherSpec := SelectOtherSpecimen(Font.Size, SpecimenList);
        if OtherSpec = '-1' then exit;
        if SelectByID(Piece(OtherSpec, U, 1)) = -1 then
          if Items.Count > SpecListCount + 1 then
            Items[0] := OtherSpec
          else
            Items.Insert(0, OtherSpec) ;
        SpecimenList.Add(OtherSpec);
        SelectByID(Piece(OtherSpec, U, 1));
        AComboBox.OnChange(Self);
      end;
end;

procedure TfrmODLab.cboSpecimenKeyPause(Sender: TObject);
begin
  inherited;
  if ALabTest = nil then exit;
  with cboSpecimen do
    if (ItemIndex >= 0) and (ItemIEN = 0) then
      GetAllSpecimens(cboSpecimen);
  if (cboSpecimen.ItemIEN = 0) then
    begin
      ALabTest.Specimen := 0;
      cboSpecimen.ItemIndex := -1;
    end ;
  ControlChange(Self);
end;

procedure TfrmODLab.cmdImmedCollClick(Sender: TObject);
var
  ImmedCollTime: string;
begin
  inherited;
  ImmedCollTime := SelectImmediateCollectTime(Font.Size, txtImmedColl.Text);
  if ImmedCollTime <> '-1' then
    begin
      txtImmedColl.Text := ImmedCollTime;
      calCollTime.FMDateTime := StrToFMDateTime(ImmedCollTime);
    end
  else
    begin
      txtImmedColl.Clear;
      calCollTime.Clear;
    end;
end;

procedure  TfrmODLab.ReadServerVariables;
begin
  LRFZX   := KeyVariable['LRFZX'];
  LRFSAMP := KeyVariable['LRFSAMP'];
  LRFSPEC := KeyVariable['LRFSPEC'];
  LRFDATE := KeyVariable['LRFDATE'];
  LRFURG  := KeyVariable['LRFURG'];
  LRFSCH  := KeyVariable['LRFSCH'];
end;

procedure TfrmODLab.DetermineCollectionDefaults(Responses: TResponses);
var
  RespCollect, RespStart: TResponse;
  //i: integer;
begin
  if ALabTest = nil then exit;
  calCollTime.Clear;
  cboCollTime.Clear;
  calCollTime.Enabled := True;
  lblCollTime.Enabled := True;
  cboColltime.Enabled := True;
  with Responses, ALabTest do
    begin
      RespCollect := FindResponseByName('COLLECT',1);
      RespStart   := FindResponseByName('START'  ,1);
      if (RespCollect <> nil) then with RespCollect do
        begin
          if IValue = 'LC' then
            begin
              if not LabCanCollect then
                begin
                 cboCollType.SelectByID('WC');
                 SetupCollTimes('WC');
                end
              else   //  if LabCanCollect
                begin
                 cboCollType.SelectByID('LC');
                 SetupCollTimes('LC');
                 CtrlInits.SetControl(cboCollTime, 'Lab Collection Times') ;
                 if RespStart <> nil then
                   begin
                     cboCollTime.SelectByID('L' + RespStart.IValue);
                     if cboCollTime.ItemIndex < 0 then
                       cboCollTime.Text := RespStart.IValue;
                   end;
                end;
            end
          else    //  if IValue <> 'LC'
            begin
              cboCollType.SelectByID(IValue) ;
              SetupCollTimes(IValue);
              if RespStart <> nil then
                begin
                  if ContainsAlpha(RespStart.IValue) then
                    calColltime.Text := RespStart.IValue
                  else
                    calColltime.FMDateTime := StrToFMDateTime(RespStart.IValue);
                end;
            end ;
          if IValue = 'I' then
            if not LabCanCollect then
              begin
               cboCollType.SelectByID('WC');
               SetupCollTimes('WC');
              end
            else
              begin
                calCollTime.Enabled := False;
                if RespStart <> nil then txtImmedColl.Text := RespStart.EValue;
              end;
        end
      else   // if (RespCollect = nil)
        LoadCollType(cbocollType);
    end;
end;
procedure TfrmODLab.pnlCollTimeButtonEnter(Sender: TObject);
begin
  inherited;
  (Sender as TPanel).BevelOuter := bvRaised;
end;

procedure TfrmODLab.pnlCollTimeButtonExit(Sender: TObject);
begin
  inherited;
  (Sender as TPanel).BevelOuter := bvNone;
end;

procedure TfrmODLab.ViewinReportWindow1Click(Sender: TObject);
begin
  inherited;
  ReportBox(memMessage.Lines, 'Lab Procedure', True);
end;

end.
