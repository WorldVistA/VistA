unit fGraphData;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ORFn, fBase508Form, VA508AccessibilityManager;

type
  TfrmGraphData = class(TfrmBase508Form)
    btnData: TButton;
    btnRefresh: TButton;
    btnTesting: TButton;
    lblCurrent: TLabel;
    lblInfo: TLabel;
    lblInfoCurrent: TLabel;
    lblInfoPersonal: TLabel;
    lblInfoPublic: TLabel;
    lblPersonal: TLabel;
    lblPublic: TLabel;
    memTesting: TMemo;
    pnlData: TPanel;
    pnlInfo: TPanel;

    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);

    procedure btnDataClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnTestingClick(Sender: TObject);
  private
    procedure ClearMemos;
    procedure FillMemos;
    procedure MakeMemos(aName: string; aList: TStrings; aTag, left, top, width, height: integer);
  public
    procedure ClearGtsl;
    procedure ClearPtData;
    procedure FreeGtsl;
    procedure MakeGtsl;
    procedure MakeUserSettings;
    procedure MakeGraphActivity;

    function AllowContextChange(var WhyNot: string): Boolean;
  end;

var
  frmGraphData: TfrmGraphData;
  GtslData: TStringList;
  GtslItems: TStringList;
  GtslTypes: TStringList;
  GtslAllTypes: TStringList;
  GtslAllViews: TStringList;
  GtslTestSpec: TStringList;
  GtslDrugClass: TStringList;
  GtslViews: TStringList;
  GtslCheck: TStringList;
  GtslNonNum: TStringList;
  GtslNonNumDates: TStringList;
  GtslScratchSwap: TStringList;
  GtslScratchTemp: TStringList;
  GtslScratchLab: TStringList;
  GtslSpec1: TStringList;
  GtslSpec2: TStringList;
  GtslSpec3: TStringList;
  GtslSpec4: TStringList;
  GtslMultiSpec: TStringList;
  GtslTempCheck: TStringList;
  GtslTemp: TStringList;
  GtslSelCopyTop: TStringList;
  GtslSelCopyBottom: TStringList;
  GtslZoomHistoryFloat: TStringList;
  GtslZoomHistoryReport: TStringList;
  GtslSelPrevTopFloat: TStringList;
  GtslSelPrevTopReport: TStringList;
  GtslSelPrevBottomFloat: TStringList;
  GtslSelPrevBottomReport: TStringList;
  GtslViewPersonal: TStringList;
  GtslViewPublic: TStringList;
  GtslLabGroup: TStringList;

  //procedure GraphDataForm;      // perhaps use this to create only when displayed??

  procedure GraphDataOnUser;
  procedure GraphDataOnPatient(var allitems, alldata: boolean);

  function GetATestGroup(aDest:TSTrings; testgroup: Integer; userx: int64): Integer;

  function GetCurrentSetting: string;
  function GetGraphProfiles(profiles, permission: string; ext: integer; userx: int64; aDest: TStrings): Integer;

  function GetGraphStatus: string;
  function GetOldDFN: string;
  function GetPersonalSetting: string;
  function GetPublicSetting: string;
  function GraphPublicEditor: boolean;
  function GraphTurboOn: boolean;

  procedure SetCurrentSetting(aString: string);
  procedure SetGraphStatus(aString: string);
  procedure SetOldDFN(aString: string);
  procedure SetPersonalSetting(aString: string);
  procedure SetPublicSetting(aString: string);

implementation

{$R *.dfm}

uses
  uCore, rGraphs, uGraphs;

var
  FGraphActivity: TGraphActivity;

{procedure GraphDataForm;            // not used - perhaps with separate object for data
var
  frmGraphData: TfrmGraphData;
begin
  frmGraphData := TfrmGraphData.Create(Application);
  try
    with frmGraphData do
    begin
      ResizeAnchoredFormToFont(frmGraphData);
      ShowModal;
    end;
  finally
    frmGraphData.Release;
  end;
end;}

procedure TfrmGraphData.FormCreate(Sender: TObject);
begin                                      // called from fFrame after user signon
  if GtslData <> nil then
    exit;                                  // only create one time
  MakeGraphActivity;
  MakeUserSettings;
  MakeGtsl;
end;

procedure TfrmGraphData.MakeGraphActivity;
begin
  FGraphActivity := TGraphActivity.Create;
  with FGraphActivity do
  begin
    CurrentSetting := '';
    OldDFN := '';
    PublicSetting := '';
    PersonalSetting := '';
    PublicEditor := false;
    Status := '';
    //TurboOn := true;
    //Cache := true;
    TurboOn := false;   //*v29* turbo turned off
    Cache := false;     //*v29* cache turned off
  end;
end;

procedure TfrmGraphData.MakeUserSettings;
var
  setting, turbo: string;
  aList: TStrings;
begin
  aList := TStringList.Create;
  try
    rpcGetGraphSettings(aList);
    if aList.Count > 0 then
    begin
      setting := aList[0];
      FGraphActivity.PublicSetting := aList[1];
      FGraphActivity.Cache := not(Piece(aList[2], '^', 1) = '-1');
      if length(setting) > 0 then
      begin // maxselectmax - system max selection limit
        SetPiece(setting, '|', 8, Piece(FGraphActivity.PublicSetting, '|', 8));
        turbo := Piece(FGraphActivity.PublicSetting, '|', 6);
        if (turbo = '0') or (not FGraphActivity.Cache) then
        // deactivate users if public turbo (6th piece) is off
        begin
          SetPiece(setting, '|', 6, '0');
          FGraphActivity.TurboOn := false;
        end
        else
          FGraphActivity.TurboOn := true;
        FGraphActivity.PersonalSetting := setting;
      end
      else
        FGraphActivity.PersonalSetting := FGraphActivity.PublicSetting;
      FGraphActivity.CurrentSetting := FGraphActivity.PersonalSetting;
      FGraphActivity.PublicEditor := rpcPublicEdit;
      // use this as PublicEdit permission for user
    end;
  finally
    FreeAndNil(aList);
  end;
end;

procedure GraphDataOnUser;
var                                        // called from fFrame after this form is created
  i: integer;                              // gets static info
  dfntype, listline: string;
begin
  if GtslData = nil then
    exit;                                  // do not setup if graphing is off
  rpcGetTypes(GtslAllTypes,'0', false);
  for i := 0 to GtslAllTypes.Count - 1 do  // uppercase all filetypes
  begin
    listline := GtslAllTypes[i];
    dfntype := UpperCase(Piece(listline, '^', 1));
    SetPiece(listline, '^', 1, dfntype);
    GtslAllTypes[i] := listline;
  end;
  rpcGetTestSpec(GtslTestSpec);
  GtslAllViews.Clear;
  rpcGetViews(GtslAllViews, VIEW_PUBLIC, 0);
  rpcGetViews(GtslAllViews, VIEW_PERSONAL, User.DUZ);
  rpcGetViews(GtslAllViews, VIEW_LABS, User.DUZ);
end;

procedure TfrmGraphData.ClearPtData;
var                                        // called when patient is selected
  faststatus, oldDFN: string;
begin
  inherited;
  if FGraphActivity.CurrentSetting = '' then
    exit;                                  // if graphing is turned off, don't process
  ClearMemos;
  ClearGtsl;
  pnlData.Hint := '';
  oldDFN := FGraphActivity.OldDFN;         // cleanup any previous patient cache
  rpcGetTypes(GtslTypes, Patient.DFN, false);
  faststatus := rpcFastTask(Patient.DFN, oldDFN);
  FGraphActivity.Cache := (faststatus = '1');
  FGraphActivity.OldDFN := Patient.DFN;
end;

procedure GraphDataOnPatient(var allitems, alldata: boolean);
begin
                                           // need to call this when patient is selected
end;

function TfrmGraphData.AllowContextChange(var WhyNot: string): Boolean;
begin
  Result := true;                          // perhaps add logic in the future
end;

//----------------------------- Gtsl* are tstringlists used to hold data - global in scope

procedure TfrmGraphData.MakeGtsl;
begin
  GtslData := TStringList.Create;
  GtslItems := TStringList.Create;
  GtslTypes := TStringList.Create;
  GtslAllTypes := TStringList.Create;
  GtslAllViews := TStringList.Create;
  GtslTestSpec := TStringList.Create;
  GtslDrugClass := TStringList.Create;
  GtslViews := TStringList.Create;
  GtslCheck := TStringList.Create;
  GtslNonNum := TStringList.Create;
  GtslNonNumDates := TStringList.Create;
  GtslScratchSwap := TStringList.Create;
  GtslScratchTemp := TStringList.Create;
  GtslScratchLab := TStringList.Create;
  GtslSpec1 := TStringList.Create;
  GtslSpec2 := TStringList.Create;
  GtslSpec3 := TStringList.Create;
  GtslSpec4 := TStringList.Create;
  GtslMultiSpec := TStringList.Create;
  GtslTempCheck := TStringList.Create;
  GtslTemp := TStringList.Create;
  GtslSelCopyTop := TStringList.Create;
  GtslSelCopyBottom := TStringList.Create;
  GtslZoomHistoryFloat := TStringList.Create;
  GtslZoomHistoryReport := TStringList.Create;
  GtslSelPrevTopFloat := TStringList.Create;
  GtslSelPrevTopReport := TStringList.Create;
  GtslSelPrevBottomFloat := TStringList.Create;
  GtslSelPrevBottomReport := TStringList.Create;
  GtslViewPersonal := TStringList.Create;
  GtslViewPublic := TStringList.Create;
  GtslLabGroup := TStringList.Create;
end;

procedure TfrmGraphData.ClearGtsl;
begin
  if GtslData = nil then exit;
  //GtslAllTypes.Clear;            // these types are not patient specific
  //GtslTestSpec.Clear;
  //GtslAllViews.Clear;
  GtslData.Clear;
  GtslItems.Clear;
  GtslTypes.Clear;
  GtslDrugClass.Clear;
  GtslViews.Clear;
  GtslCheck.Clear;
  GtslNonNum.Clear;
  GtslNonNumDates.Clear;
  GtslScratchSwap.Clear;
  GtslScratchTemp.Clear;
  GtslScratchLab.Clear;
  GtslSpec1.Clear;
  GtslSpec2.Clear;
  GtslSpec3.Clear;
  GtslSpec4.Clear;
  GtslMultiSpec.Clear;
  GtslTempCheck.Clear;
  GtslTemp.Clear;
  GtslSelCopyTop.Clear;
  GtslSelCopyBottom.Clear;
  GtslZoomHistoryFloat.Clear;
  GtslZoomHistoryReport.Clear;
  GtslSelPrevTopFloat.Clear;
  GtslSelPrevTopReport.Clear;
  GtslSelPrevBottomFloat.Clear;
  GtslSelPrevBottomReport.Clear;
  GtslViewPersonal.Clear;
  GtslViewPublic.Clear;
  GtslLabGroup.Clear;
end;

procedure TfrmGraphData.FreeGtsl;
begin
  FreeAndNil(GtslData);
  FreeAndNil(GtslItems);
  FreeAndNil(GtslTypes);
  FreeAndNil(GtslAllTypes);
  FreeAndNil(GtslAllViews);
  FreeAndNil(GtslTestSpec);
  FreeAndNil(GtslDrugClass);
  FreeAndNil(GtslNonNum);
  FreeAndNil(GtslNonNumDates);
  FreeAndNil(GtslScratchSwap);
  FreeAndNil(GtslScratchTemp);
  FreeAndNil(GtslScratchLab);
  FreeAndNil(GtslSpec1);
  FreeAndNil(GtslSpec2);
  FreeAndNil(GtslSpec3);
  FreeAndNil(GtslSpec4);
  FreeAndNil(GtslMultiSpec);
  FreeAndNil(GtslTempCheck);
  FreeAndNil(GtslSelCopyTop);
  FreeAndNil(GtslSelCopyBottom);
  FreeAndNil(GtslZoomHistoryFloat);
  FreeAndNil(GtslZoomHistoryReport);
  FreeAndNil(GtslSelPrevTopFloat);
  FreeAndNil(GtslSelPrevTopReport);
  FreeAndNil(GtslSelPrevBottomFloat);
  FreeAndNil(GtslSelPrevBottomReport);
  FreeAndNil(GtslViewPersonal);
  FreeAndNil(GtslViewPublic);
  FreeAndNil(GtslLabGroup);
  FreeAndNil(GtslCheck);
  FreeAndNil(GtslTemp);
  FreeAndNil(GtslViews);
end;

//----------------------------- displays when testing

procedure TfrmGraphData.btnDataClick(Sender: TObject);
var
  height, left, top, width: integer;
begin
  height := pnlData.Height div 8;
  height := height - lblInfo.Height;
  top := lblInfo.Height;
  left := 1;
  width := pnlData.Width - 2;
  MakeMemos('GtslData', GtslData, 1, left, top, width, height);
  top := top + height + lblInfo.Height;
  MakeMemos('GtslItems', GtslItems, 2, left, top, width, height);
  top := top + height + lblInfo.Height;
  MakeMemos('GtslTypes', GtslTypes, 3, left, top, width, height);
  width := width div 6;
  top := top + height + lblInfo.Height;
  left := 1;
  MakeMemos('GtslAllTypes', GtslAllTypes, 4, left, top, width, height);
  left := left + width;
  MakeMemos('GtslTestSpec', GtslTestSpec, 5, left, top, width, height);
  left := left + width;
  MakeMemos('GtslDrugClass', GtslDrugClass, 6, left, top, width, height);
  left := left + width;
  MakeMemos('GtslViews', GtslViews, 7, left, top, width, height);
  left := left + width;
  MakeMemos('GtslCheck', GtslCheck, 8, left, top, width, height);
  left := left + width;
  MakeMemos('GtslNonNum', GtslNonNum, 9, left, top, width, height);
  top := top + height + lblInfo.Height;
  left := 1;
  MakeMemos('GtslNonNumDates', GtslNonNumDates, 10, left, top, width, height);
  left := left + width;
  MakeMemos('GtslScratchSwap', GtslScratchSwap, 11, left, top, width, height);
  left := left + width;
  MakeMemos('GtslScratchTemp', GtslScratchTemp, 12, left, top, width, height);
  left := left + width;
  MakeMemos('GtslScratchLab', GtslScratchLab, 13, left, top, width, height);
  left := left + width;
  MakeMemos('GtslSpec1', GtslSpec1, 14, left, top, width, height);
  left := left + width;
  MakeMemos('GtslSpec2', GtslSpec2, 15, left, top, width, height);
  top := top + height + lblInfo.Height;
  left := 1;
  MakeMemos('GtslSpec3', GtslSpec3, 16, left, top, width, height);
  left := left + width;
  MakeMemos('GtslSpec4', GtslSpec4, 17, left, top, width, height);
  left := left + width;
  MakeMemos('GtslMultiSpec', GtslMultiSpec, 18, left, top, width, height);
  left := left + width;
  MakeMemos('GtslTempCheck', GtslTempCheck, 19, left, top, width, height);
  left := left + width;
  MakeMemos('GtslTemp', GtslTemp, 20, left, top, width, height);
  left := left + width;
  MakeMemos('GtslSelCopyTop', GtslSelCopyTop, 21, left, top, width, height);
  top := top + height + lblInfo.Height;
  left := 1;
  MakeMemos('GtslSelCopyBottom', GtslSelCopyBottom, 22, left, top, width, height);
  left := left + width;
  MakeMemos('GtslZoomHistoryFloat', GtslZoomHistoryFloat, 23, left, top, width, height);
  left := left + width;
  MakeMemos('GtslZoomHistoryReport', GtslZoomHistoryReport, 24, left, top, width, height);
  left := left + width;
  MakeMemos('GtslSelPrevTopFloat', GtslSelPrevTopFloat, 25, left, top, width, height);
  left := left + width;
  MakeMemos('GtslSelPrevTopReport', GtslSelPrevTopReport, 26, left, top, width, height);
  left := left + width;
  MakeMemos('GtslSelPrevBottomFloat', GtslSelPrevBottomFloat, 27, left, top, width, height);
  top := top + height + lblInfo.Height;
  left := 1;
  MakeMemos('GtslSelPrevBottomReport', GtslSelPrevBottomReport, 28, left, top, width, height);
  left := left + width;
  MakeMemos('GtslViewPersonal', GtslViewPersonal, 29, left, top, width, height);
  left := left + width;
  MakeMemos('GtslViewPublic', GtslViewPublic, 30, left, top, width, height);
  left := left + width;
  MakeMemos('GtslLabGroup', GtslLabGroup, 31, left, top, width, height);
  left := left + width;
  MakeMemos('GtslAllViews', GtslAllViews, 32, left, top, width, height);
  btnData.Enabled := false;
  btnRefresh.Enabled := true;
  lblCurrent.Caption := FGraphActivity.CurrentSetting;
  lblPersonal.Caption := FGraphActivity.PersonalSetting;
  lblPublic.Caption := FGraphActivity.PublicSetting;
end;

procedure TfrmGraphData.btnRefreshClick(Sender: TObject);
begin
  frmGraphData.WindowState := wsMaximized;
  ClearMemos;
  FillMemos;
end;

procedure TfrmGraphData.btnTestingClick(Sender: TObject);
begin
//  FastAssign(rpcTesting, memTesting.Lines);
  rpcTesting(memTesting.Lines);
end;

procedure TfrmGraphData.MakeMemos(aName: string; aList: TStrings; aTag, left, top, width, height: integer);
var
  aMemo: TMemo;
  aLabel: TLabel;
begin
  aMemo := TMemo.Create(self);
  aMemo.Parent := pnlData;
  aMemo.Name := 'mem' + aName;
  aMemo.Tag := aTag;
  aMemo.Left := left; aMemo.Top := top; aMemo.Width := width; aMemo.Height := height;
  aMemo.ScrollBars := ssVertical;
  aMemo.WordWrap := false;
  FastAssign(aList, aMemo.Lines);
  aLabel := TLabel.Create(self);
  aLabel.Parent := pnlData;
  aLabel.Caption := aName + ' (' + inttostr(aList.Count) + ')';
  aLabel.Left := left; aLabel.Top := top - lblInfo.Height; aLabel.Width := width; aLabel.Height := lblInfo.height;
end;

procedure TfrmGraphData.ClearMemos;
var
  i: integer;
  ChildControl: TControl;
begin
  for i := 0 to pnlData.ControlCount - 1 do
  begin
    ChildControl := pnlData.Controls[i];
    if ChildControl is TMemo then
      (ChildControl as TMemo).Clear;
  end;
end;

procedure TfrmGraphData.FillMemos;
var
  i: integer;
  aMemo: TMemo;
  ChildControl: TControl;
begin
  for i := 0 to pnlData.ControlCount - 1 do
  begin
    ChildControl := pnlData.Controls[i];
    if ChildControl is TMemo then
    begin
      aMemo := (ChildControl as TMemo);
      case aMemo.Tag of
       1: FastAssign(GtslData, aMemo.Lines);
       2: FastAssign(GtslItems, aMemo.Lines);
       3: FastAssign(GtslTypes, aMemo.Lines);
       4: FastAssign(GtslAllTypes, aMemo.Lines);
       5: FastAssign(GtslTestSpec, aMemo.Lines);
       6: FastAssign(GtslDrugClass, aMemo.Lines);
       7: FastAssign(GtslViews, aMemo.Lines);
       8: FastAssign(GtslCheck, aMemo.Lines);
       9: FastAssign(GtslNonNum, aMemo.Lines);
      10: FastAssign(GtslNonNumDates, aMemo.Lines);
      11: FastAssign(GtslScratchSwap, aMemo.Lines);
      12: FastAssign(GtslScratchTemp, aMemo.Lines);
      13: FastAssign(GtslScratchLab, aMemo.Lines);
      14: FastAssign(GtslSpec1, aMemo.Lines);
      15: FastAssign(GtslSpec2, aMemo.Lines);
      16: FastAssign(GtslSpec3, aMemo.Lines);
      17: FastAssign(GtslSpec4, aMemo.Lines);
      18: FastAssign(GtslMultiSpec, aMemo.Lines);
      19: FastAssign(GtslTempCheck, aMemo.Lines);
      20: FastAssign(GtslTemp, aMemo.Lines);
      21: FastAssign(GtslSelCopyTop, aMemo.Lines);
      22: FastAssign(GtslSelCopyBottom, aMemo.Lines);
      23: FastAssign(GtslZoomHistoryFloat, aMemo.Lines);
      24: FastAssign(GtslZoomHistoryReport, aMemo.Lines);
      25: FastAssign(GtslSelPrevTopFloat, aMemo.Lines);
      26: FastAssign(GtslSelPrevTopReport, aMemo.Lines);
      27: FastAssign(GtslSelPrevBottomFloat, aMemo.Lines);
      28: FastAssign(GtslSelPrevBottomReport, aMemo.Lines);
      29: FastAssign(GtslViewPersonal, aMemo.Lines);
      30: FastAssign(GtslViewPublic, aMemo.Lines);
      31: FastAssign(GtslLabGroup, aMemo.Lines);
      32: FastAssign(GtslAllViews, aMemo.Lines);
      end;
    end;
  end;
end;

//---------------------------------------------------

function GetCurrentSetting: string;
begin
  Result := FGraphActivity.CurrentSetting;
end;

//function GetGraphProfiles(profiles, permission: string; ext: integer; userx: int64): TStrings;
function GetGraphProfiles(profiles, permission: string; ext: integer; userx: int64; aDest: TStrings): Integer;
var      // temporary fix - converting definitions in GtslAllViews to rpc format
  allviews, fulltext: boolean;
  i: integer;
  aitem, aline, aname, atype, avc, avnum, avtype, bigline, partsnum, vtype: string;
  //auser: string;
begin
  if (userx > 0) and (userx <> User.DUZ) then
//    Result := rpcGetGraphProfiles(profiles, permission, ext, userx)
    rpcGetGraphProfiles(aDest, profiles, permission, ext, userx)
  else
  begin
    profiles := UpperCase(profiles);
    if permission = '1' then vtype := '-2'
    else vtype := '-1';
    allviews := (profiles = '1');
    fulltext := (ext = 1);
    partsnum := '0';
    bigline := '';
    GtslScratchTemp.Clear;
    for i := 0 to GtslAllViews.Count - 1 do
    begin
      aline  := GtslAllViews[i];
      avtype := Piece(aline, '^', 1);
      avc    := Piece(aline, '^', 2);
      avnum  := Piece(aline, '^', 3);
      aname  := UpperCase(Piece(aline, '^', 4));
      atype  := UpperCase(Piece(aline, '^', 5));
      aitem  := Piece(aline, '^', 6);
      //auser  := Piece(aline, '^', 7);
      if partsnum <> '0' then
      begin                                                 //AddLine(ext, aname, atype, aitem);
        if (avc = 'C') and (partsnum = avnum) then
        begin
          if ext <> 1 then
          begin
             if aitem = '0' then bigline := bigline + '0~' + atype + '~|'
             else bigline := bigline + atype + '~' + aitem  + '~|'
          end
          else
          begin
             if aitem = '0' then
               GtslScratchTemp.Add('0^' + atype + '^' + aname)
             else
               GtslScratchTemp.Add(atype + '^' + aitem  + '^' + aname)
          end;
        end
        else
        begin
          if length(bigline) > 0 then
            GtslScratchTemp.Add(bigline);
          break;
        end;
      end
      else
      if avtype = vtype then
      begin
        if allviews and (avc = 'V') then
        begin
          GtslScratchTemp.Add(aname);
        end
        else if (avc = 'V') and (aname = profiles) then
          partsnum := avnum;
      end;
    end;
    if allviews or fulltext then
      MixedCaseList(GtslScratchTemp);
    aDest.Assign(GtslScratchTemp);
  end;
  Result := aDest.Count;
end;

//function GetATestGroup(testgroup: Integer; userx: int64): TSTrings ;
function GetATestGroup(aDest:TSTrings; testgroup: Integer; userx: int64): Integer;
var      // temporary fix - converting definitions in GtslAllViews to rpc format
  i: integer;
  aitem, aline, aname, avc, avnum, avtype, partsnum: string;
  //atype, auser: string;
begin
  if (userx > 0) and (userx <> User.DUZ) then
    begin
//    Result := rpcATestGroup(testgroup, userx)
      rpcATestGroup(aDest, testgroup, userx)
    end
  else
  begin
    partsnum := '0';
    GtslScratchTemp.Clear;
    for i := 0 to GtslAllViews.Count - 1 do
    begin
      aline  := GtslAllViews[i];
      avtype := Piece(aline, '^', 1);
      avc    := Piece(aline, '^', 2);
      avnum  := Piece(aline, '^', 3);
      aname  := Piece(aline, '^', 4);
      //atype  := UpperCase(Piece(aline, '^', 5));
      aitem  := Piece(aline, '^', 6);
      //auser  := Piece(aline, '^', 7);
      if avtype = VIEW_LABS then
      begin
        if (avc = 'V') and (partsnum <> '0') then
          break;
        if (avc = 'C') and (partsnum = avnum) then
          GtslScratchTemp.Add(aitem  + '^' + aname)
        else if (avc = 'V')
            and (testgroup = strtointdef(Piece(aname, ')', 1), BIG_NUMBER)) then
              partsnum := avnum;
      end;
    end;
    //MixedCaseList(GtslScratchTemp);
    aDest.Assign(GtslScratchTemp);
  end;
  Result := aDest.Count;
end;

function GetGraphStatus: string;
begin
  Result := FGraphActivity.Status;
end;

function GetOldDFN: string;
begin
  Result := FGraphActivity.OldDFN;
end;

function GetPersonalSetting: string;
begin
  Result := FGraphActivity.PersonalSetting;
end;

function GetPublicSetting: string;
begin
  Result := FGraphActivity.PublicSetting;
end;

function GraphPublicEditor: boolean;
begin
  Result := FGraphActivity.PublicEditor;
end;

function GraphTurboOn: boolean;
begin
  Result := (FGraphActivity.TurboOn and FGraphActivity.Cache);
end;

procedure SetCurrentSetting(aString: string);
begin
  FGraphActivity.CurrentSetting := aString;
end;

procedure SetGraphStatus(aString: string);
begin
  FGraphActivity.Status := aString;
end;

procedure SetOldDFN(aString: string);
begin
  FGraphActivity.OldDFN := aString;
end;

procedure SetPersonalSetting(aString: string);
begin
  FGraphActivity.PersonalSetting := aString;
end;

procedure SetPublicSetting(aString: string);
begin
  FGraphActivity.PublicSetting := aString;
end;
//---------------------------------------------------

procedure TfrmGraphData.FormClose(Sender: TObject; var Action: TCloseAction);
var
  faststatus: string;
begin
  if FGraphActivity.Cache then
  begin
    faststatus := rpcFastTask('0', Patient.DFN);           // cleanup patient cache
    if faststatus = '-1' then
      FGraphActivity.Cache := false;
  end;
end;

procedure TfrmGraphData.FormDestroy(Sender: TObject);
begin
  FreeGtsl;
end;

initialization

finalization;

  if assigned(FGraphActivity) then
    FreeAndNil(FGraphActivity);

end.
