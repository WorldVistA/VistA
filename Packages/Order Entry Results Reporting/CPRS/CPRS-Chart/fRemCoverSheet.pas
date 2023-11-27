unit fRemCoverSheet;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ORCtrls, StdCtrls, ExtCtrls, ComCtrls, ImgList, mImgText, Buttons, ORClasses, fBase508Form,
  VA508AccessibilityManager, VA508ImageListLabeler, System.ImageList;

type
  TRemCoverDataLevel = (dlPackage, dlSystem, dlDivision, dlService, dlLocation, dlUserClass, dlUser);

  TfrmRemCoverSheet = class(TfrmBase508Form)
    pnlBottom: TORAutoPanel;
    pnlUser: TPanel;
    cbxUserLoc: TORComboBox;
    lblRemLoc: TLabel;
    pnlMiddle: TPanel;
    pnlRight: TPanel;
    mlgnCat: TfraImgText;
    mlgnRem: TfraImgText;
    mlgnAdd: TfraImgText;
    pnlCAC: TORAutoPanel;
    mlgnRemove: TfraImgText;
    mlgnLock: TfraImgText;
    imgMain: TImageList;
    sbUp: TBitBtn;
    sbDown: TBitBtn;
    btnAdd: TBitBtn;
    btnRemove: TBitBtn;
    btnLock: TBitBtn;
    pnlBtns: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    edtSeq: TCaptionEdit;
    udSeq: TUpDown;
    lblSeq: TLabel;
    btnApply: TButton;
    cbSystem: TORCheckBox;
    cbDivision: TORCheckBox;
    cbService: TORCheckBox;
    cbxService: TORComboBox;
    cbxDivision: TORComboBox;
    cbLocation: TORCheckBox;
    cbUserClass: TORCheckBox;
    cbUser: TORCheckBox;
    cbxUser: TORComboBox;
    cbxClass: TORComboBox;
    cbxLocation: TORComboBox;
    lblEdit: TLabel;
    pnlInfo: TPanel;
    pnlTree: TPanel;
    tvAll: TORTreeView;
    lblTree: TLabel;
    pnlCover: TPanel;
    lvCover: TCaptionListView;
    pblMoveBtns: TPanel;
    sbCopyRight: TBitBtn;
    sbCopyLeft: TBitBtn;
    splMain: TSplitter;
    btnView: TButton;
    lblLegend: TLabel;
    imgLblRemCoverSheet: TVA508ImageListLabeler;
    compAccessCopyRight: TVA508ComponentAccessibility;
    compAccessCopyLeft: TVA508ComponentAccessibility;
    pnlTopLeft: TPanel;
    lvView: TCaptionListView;
    lblView: TLabel;
    lblCAC: TVA508StaticText;
    VA508ImageListLabeler1: TVA508ImageListLabeler;
    caMoveDown: TVA508ComponentAccessibility;
    caMoveUP: TVA508ComponentAccessibility;
    grdPanel: TGridPanel;
    cbLegend: TCheckBox;
    procedure cbxLocationNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure cbxServiceNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure cbxUserNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure cbxClassNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure cbxDivisionChange(Sender: TObject);
    procedure cbxServiceChange(Sender: TObject);
    procedure cbxLocationChange(Sender: TObject);
    procedure cbxClassChange(Sender: TObject);
    procedure cbxUserChange(Sender: TObject);
    procedure cbxDropDownClose(Sender: TObject);
    procedure cbEditLevelClick(Sender: TObject);
    procedure tvAllExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure edtSeqChange(Sender: TObject);
    procedure tvAllExpanded(Sender: TObject; Node: TTreeNode);
    procedure tvAllChange(Sender: TObject; Node: TTreeNode);
    procedure lvCoverChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure btnAddClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure btnLockClick(Sender: TObject);
    procedure lvViewColumnClick(Sender: TObject; Column: TListColumn);
    procedure lvCoverColumnClick(Sender: TObject; Column: TListColumn);
    procedure lvViewCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure lvCoverCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure sbUpClick(Sender: TObject);
    procedure sbDownClick(Sender: TObject);
    procedure sbCopyRightClick(Sender: TObject);
//    procedure _udSeqChangingEx(Sender: TObject; var AllowChange: Boolean;
//      NewValue: Smallint; Direction: TUpDownDirection);
    procedure sbCopyLeftClick(Sender: TObject);
    procedure tvAllDblClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure lvCoverDblClick(Sender: TObject);
    procedure btnViewClick(Sender: TObject);
    procedure lvCoverKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtSeqKeyPress(Sender: TObject; var Key: Char);
    procedure cbxDivisionKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure compAccessCopyRightCaptionQuery(Sender: TObject;
      var Text: string);
    procedure compAccessCopyLeftCaptionQuery(Sender: TObject; var Text: string);
    procedure lvViewChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure lvViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure lvViewExit(Sender: TObject);
    procedure btnViewExit(Sender: TObject);
    procedure lblCACExit(Sender: TObject);
    procedure cbxUserLocExit(Sender: TObject);
    procedure cbSystemExit(Sender: TObject);
    procedure sbCopyRightExit(Sender: TObject);
    procedure btnOKExit(Sender: TObject);
    procedure caMoveDownCaptionQuery(Sender: TObject; var Text: string);
    procedure caMoveUPCaptionQuery(Sender: TObject; var Text: string);
    procedure cbLegendClick(Sender: TObject);
    procedure udSeqChangingEx(Sender: TObject; var AllowChange: Boolean;
      NewValue: Integer; Direction: TUpDownDirection);
    procedure cbxUserEnter(Sender: TObject);
    procedure cbxUserExit(Sender: TObject);
    procedure cbxUserMouseClick(Sender: TObject);
  private
    FData: TORStringList;     // DataCode IEN ^ Modified Flag  Object=TStringList
    FUserInfo: TORStringList; // C^User Class, D^Division
    FUser: Int64;
    FUserMode: boolean;
    FInitialized: boolean;
    FCurDiv: double;
    FCurSer:Integer;
    FCurLoc: Integer;
    FCurClass: Integer;
    FCurUser: Int64;
    FDivisions: TORStringList;
    FServices: TORStringList;
    FLocations: TORStringList;
    FClasses: TORStringList;
    FUsers: TORStringList;
    FMasterList: TORStringList;
    FUpdatePending: TORCheckBox;
    FCatInfo: TORStringList;
    FEditingLevel: TRemCoverDataLevel;
    FEditingIEN: double;
    FUpdating: boolean;
    FTopSortTag: integer;
    FTopSortUp: boolean;
    FBottomSortTag: integer;
    FBottomSortUp: boolean;
    FDataSaved: boolean;
    FUpdatingView: boolean;
    FInternalExpansion: boolean;
    FSavePause: integer;
    FSelection: boolean;
    fOldFocusChanged: TNotifyEvent;
    FChanging: Boolean;
    procedure ActiveControlChanged(Sender: TObject);
    procedure SetButtonHints;
    procedure GetUserInfo(AUser: Int64);
    function GetCurrent(IEN: double; Level: TRemCoverDataLevel; Show: boolean;
                        Add: boolean = FALSE): TORStringList;
    procedure UpdateView;
    procedure SetupItem(Item: TListItem; const Data: string); overload;
    procedure SetupItem(Item: TListItem; const Data: string;
                        Level: TRemCoverDataLevel; IEN: double); overload;
    function GetExternalName(Level: TRemCoverDataLevel; IEN: double): string;
    procedure UpdateMasterListView;
    procedure UpdateButtons;
    function GetCatInfo(CatIEN: string): TORStringList;
    procedure MarkListAsChanged;
    function GetIndex(List: TORStringList; Item: TListItem): integer;
    procedure ChangeStatus(Code: string);
    procedure SetSeq(Item: TListItem; const Value: string);
    function ListHasData(Seq: string; SubIdx: integer): boolean;
    procedure SaveData(FromApply: boolean);
    function RPad(Str: String): String;
    function GetCoverSheetLvlData(ALevel, AClass: string): TStrings;
    procedure LockButtonUpdate(data, FNAME, hint: string);
  public
     procedure Init(AsUser: boolean);
  end;

procedure EditCoverSheetReminderList(AsUser: boolean);

implementation

uses rCore, uCore, uPCE, rProbs, rTIU, ORFn, rReminders, uReminders,
  fRemCoverPreview, VAUtils, VA508AccessibilityRouter, uORLists, uSimilarNames,
  uWriteAccess;

{$R *.DFM}
{$R sremcvr}

const
  DataCode: array[TRemCoverDataLevel] of string[1] =
      { dlPackage   } ('P',
      { dlSystem    }  'S',
      { dlDivision  }  'D',
      { dlService   }  'R',
      { dlLocation  }  'L',
      { dlUserClass }  'C',
      { dlUser      }  'U');

  DataName: array[TRemCoverDataLevel] of string =
      { dlPackage   } ('Package',
      { dlSystem    }  'System',
      { dlDivision  }  'Division',
      { dlService   }  'Service',
      { dlLocation  }  'Location',
      { dlUserClass }  'User Class',
      { dlUser      }  'User');

  InternalName: array[TRemCoverDataLevel] of string =
      { dlPackage   } ('PKG',
      { dlSystem    }  'SYS',
      { dlDivision  }  'DIV',
      { dlService   }  'SRV',
      { dlLocation  }  'LOC',
      { dlUserClass }  'CLASS',
      { dlUser      }  'USR');


  UserClassCode = 'C';
  DivisionCode = 'D';
  ServiceCode = 'S';

  CVLockCode   = 'L';
  CVAddCode    = 'N';
  CVRemoveCode = 'R';
  CVCatCode    = 'C';
  CVRemCode    = 'R';

  DummyNode = '^@Dummy Node@^';
  IdxSeq  = 0;
  IdxLvl  = 1;
  IdxType = 2;
  IdxTIEN = 3;
  IdxLvl2 = 4;
  IdxAdd  = 5;
  IdxIEN  = 6;

  UnlockHint = 'Unlock a Reminder, reverting it''s status back to Added';
  LockHint = 'Lock a Reminder to prevent it''s removal from a lower'
        + CRLF + 'level Coversheet display.  For example, if you lock'
        + CRLF + 'a Reminder at the Service level, then that Reminder'
        + CRLF + 'can not be removed from the coversheet display at'
        + CRLF + 'the Location, User Class, or User levels.';
  AddLockHint = 'Add and Lock a Reminder to prevent it''s removal from a lower'
        + CRLF + 'level Coversheet display.  For example, if you lock'
        + CRLF + 'a Reminder at the Service level, then that Reminder'
        + CRLF + 'can not be removed from the coversheet display at'
        + CRLF + 'the Location, User Class, or User levels.';

procedure EditCoverSheetReminderList(AsUser: boolean);
var
  frmRemCoverSheet: TfrmRemCoverSheet;

begin
  frmRemCoverSheet := TfrmRemCoverSheet.Create(Application);
  try
    frmRemCoverSheet.Init(AsUser);
    frmRemCoverSheet.ShowModal;
    if frmRemCoverSheet.FDataSaved then
      ResetReminderLoad;
  finally
    frmRemCoverSheet.Free;
  end;
end;

{ TfrmRemCoverSheet }

procedure TfrmRemCoverSheet.Init(AsUser: boolean);
const
  RemClsCode = ' NVL';
  RemClsText:array[1..4] of string = ('','National','VISN','Local');

var
  LocCombo: TORComboBox;
  i, idx: integer;
  tmp, tmp2, tmp3: string;
  Node: TORTreeNode;
  aList: TStrings;

begin
  FTopSortTag := 3;
  FTopSortUp  := TRUE;
  FBottomSortTag := 2;
  FBottomSortUp := TRUE;
  FEditingLevel := dlPackage;

  ResizeAnchoredFormToFont(self);
  pnlBtns.Top := pnlBottom.Top + pnlBottom.Height;

  FCatInfo := TORStringList.Create;
  FData := TORStringList.Create;
  FUserInfo := TORStringList.Create;
  FDivisions := TORStringList.Create;
  FServices := TORStringList.Create;
  FLocations := TORStringList.Create;
  FClasses := TORStringList.Create;
  FUsers := TORStringList.Create;
  FMasterList := TORStringList.Create;
  aList := TStringList.Create;
  try
    GetAllRemindersAndCategories(aList);
    FastAssign(aList, FMasterList);
  finally
     FreeAndNil(aList);
  end;

  for i := 0 to FMasterList.Count-1 do
  begin
    tmp := FMasterList[i];
    tmp2 := piece(tmp,U,4);
    if tmp2 = piece(tmp,U,3) then
      tmp2 := '';
    tmp3 := piece(tmp,U,5);
    if tmp3 = '' then tmp3 := ' ';
    idx := pos(tmp3,RemClsCode);
    if idx > 0 then
      tmp3 := RemClsText[idx]
    else
      tmp3 := '';
    if tmp3 <> '' then
    begin
      if tmp2 <> '' then
        tmp2 := tmp2 + ' - ';
      tmp2 := tmp2 + tmp3;
    end;
    if tmp2 <> '' then
      tmp2 := ' (' + tmp2 + ')';
    tmp := Piece(tmp,U,1) + Pieces(tmp,U,2,3) + tmp2 + U + tmp2;
    FMasterList[i] := tmp;
  end;

  FUserMode := AsUser;
  FCurUser := User.DUZ;
  GetUserInfo(User.DUZ);
  FCurLoc := Encounter.Location;
  idx := FUserInfo.IndexOfPiece(DivisionCode);
  if idx >= 0 then
    FCurDiv := StrToIntDef(Piece(FUserInfo[idx],U,2),0)
  else
    FCurDiv := 0;
  idx := FUserInfo.IndexOfPiece(ServiceCode);
  if idx >= 0 then
    FCurSer := StrToIntDef(Piece(FUserInfo[idx],U,2),0)
  else
    FCurSer := User.Service;
  cbxUser.InitLongList(User.Name);
  cbxUser.SelectByIEN(FCurUser);
  GetPCECodes(FDivisions, TAG_HISTLOC);
  FDivisions.Delete(0);
  FCurClass := 0;
  if AsUser then
  begin
    pnlCAC.Visible := FALSE;
    LocCombo := cbxUserLoc;
    btnLock.Visible := FALSE;
  end
  else
  begin
    pnlUser.Visible := FALSE;
    LocCombo := cbxLocation;
    //cbxDivision.Items.Assign(FDivisions);
    FastAssign(Fdivisions, cbxDivision.Items);
    cbxDivision.SelectByID(FloatToStr(FCurDiv));
//    cbxDivision.SelectByIEN(FCurDiv);
    cbxService.InitLongList(GetExternalName(dlService, FCurSer));
    cbxService.SelectByIEN(FCurSer);
    cbxClass.InitLongList('');
    if FCurClass <> 0 then
      cbxClass.SelectByIEN(FCurClass);
  end;
  LocCombo.InitLongList(Encounter.LocationName);
  LocCombo.SelectByIEN(FCurLoc);
  if AsUser then
    cbUser.Checked := TRUE;

  tvAll.Items.BeginUpdate;
  try
    for i := 0 to FMasterList.Count-1 do
    begin
      Node := TORTreeNode(tvAll.Items.Add(nil,''));
      Node.StringData := FMasterList[i];
      if copy(FMasterList[i],1,1) = CVCatCode then
      begin
        idx := 1;
        tvAll.Items.AddChild(Node, DummyNode);
      end
      else
        idx := 0;
      Node.ImageIndex := idx;
      Node.SelectedIndex := idx;
    end;
  finally
    tvAll.Items.EndUpdate;
  end;

  FInitialized := TRUE;
  UpdateView;
  UpdateButtons;
end;

procedure TfrmRemCoverSheet.lblCACExit(Sender: TObject);
begin
  inherited;
  //TDP - CQ#19733 Corrected tabbing issues
  if TabIsPressed() then
  begin
    if pnlUser.Visible then cbxUserLoc.SetFocus
    else cbSystem.SetFocus;
  end;
  if ShiftTabIsPressed() then btnView.SetFocus;
end;

procedure TfrmRemCoverSheet.cbxLocationNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
var
  sl: TStrings;
begin
  sl := TStringList.Create;
  try
    setSubSetOfLocations(sl, StartFrom, Direction);
    TORComboBox(Sender).ForDataUse(sl);
  finally
    sl.Free;
  end;
end;

procedure TfrmRemCoverSheet.cbxServiceNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
var
  sl: TSTrings;
begin
  sl := TSTringList.Create;
  try
    ServiceSearch(sl,StartFrom, Direction, TRUE);
    cbxService.ForDataUse(sl);
  finally
    sl.Free;
  end;
end;

procedure TfrmRemCoverSheet.cbxUserNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
begin
  setPersonList(cbxUser, StartFrom, Direction);
end;

procedure TfrmRemCoverSheet.cbxClassNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
var
  sl: TStrings;
begin
  sl := TStringList.Create;
  try
    setSubSetOfUserClasses(sl, StartFrom, Direction);
    cbxClass.ForDataUse(sl);
  finally
    sl.Free;
  end;
end;

procedure TfrmRemCoverSheet.FormDestroy(Sender: TObject);
begin
  Screen.OnActiveControlChange := fOldFocusChanged;
  FMasterList.Free;
  FUsers.Free;
  FClasses.Free;
  FLocations.Free;
  FServices.Free;
  FDivisions.Free;
  FUserInfo.Free;
  FData.KillObjects;
  FData.Free;
  FCatInfo.KillObjects;
  FCatInfo.Free;
  Application.HintHidePause := FSavePause  //Reset Hint pause to original setting
end;

procedure TfrmRemCoverSheet.GetUserInfo(AUser: Int64);
begin
  if FUser <> AUser then
  begin
    FUser := AUser;
    setUserDivClassInfo(FUserInfo,FUser);
  end;
end;

function TfrmRemCoverSheet.GetCurrent(IEN: double; Level: TRemCoverDataLevel;
                           Show: boolean; Add: boolean = FALSE): TORStringList;
var
  lvl, cls, sIEN: string;
  tmpSL: TORStringList;
  i, idx: integer;

begin
  idx := FData.IndexOfPiece(String(DataCode[Level]) + floatToStr(IEN));
  if idx < 0 then
  begin
    if (IEN = 0) and (not (Level in [dlPackage, dlSystem])) then
    begin
      Result := nil;
      exit;
    end;
    cls := '';
    sIEN := floatToStr(IEN);
    lvl := InternalName[Level];
    case Level of
      dlDivision, dlService, dlLocation, dlUser:
        lvl := lvl + '.`' + sIEN;
      dlUserClass:
        cls := sIEN;
    end;
    if (lvl <> '') then
    begin
      tmpSL := TORStringList.Create;
      try
        FastAssign(GetCoverSheetLvlData(lvl, cls),  tmpSL);
        if (not Add) and (tmpSL.Count = 0) then
          FreeAndNil(tmpSL);
        idx := FData.AddObject(String(DataCode[Level]) + floatToStr(IEN), tmpSL);
      except
        tmpSL.Free;
        raise;
      end;
    end;
  end;
  if idx >= 0 then
  begin
    tmpSL := TORStringList(FData.Objects[idx]);
    if Add and (not assigned(tmpSL)) then
    begin
      tmpSL := TORStringList.Create;
      FData.Objects[idx] := tmpSL;
    end;
  end
  else
    tmpSL := nil;
  if Show and assigned(tmpSL) then
  begin
    for i := 0 to tmpSL.Count-1 do
      SetupItem(lvView.Items.Add, tmpSL[i], Level, IEN);
  end;
  Result := tmpSL;
end;

procedure TfrmRemCoverSheet.UpdateView;
var
  idx: integer;

begin
  if FInitialized and (not FUpdatingView) then
  begin
    lvView.Items.BeginUpdate;
    try
      lvView.Items.Clear;
      GetCurrent(0, dlPackage, TRUE);
      GetCurrent(0, dlSystem, TRUE);
      GetCurrent(FCurDiv, dlDivision, TRUE);
      GetCurrent(FCurSer, dlService, TRUE);
      GetCurrent(FCurLoc, dlLocation, TRUE);
      if FCurClass > 0 then
        GetCurrent(FCurClass, dlUserClass, TRUE)
      else
      begin
        idx := -1;
        repeat
          idx := FUserInfo.IndexOfPiece(UserClassCode,U,1,idx);
          if idx >= 0 then
            GetCurrent(StrToIntDef(Piece(FUserInfo[idx],U,2),0), dlUserClass, TRUE)
        until(idx < 0);
      end;
      GetCurrent(FCurUser, dlUser, TRUE);
    finally
      lvView.Items.EndUpdate;
    end;
  end;
end;

procedure TfrmRemCoverSheet.compAccessCopyLeftCaptionQuery(Sender: TObject;
  var Text: string);
begin
  Text := 'Remove Reminder from ' + DataName[FEditingLevel] + ' Level Reminders List';
end;

procedure TfrmRemCoverSheet.compAccessCopyRightCaptionQuery(
  Sender: TObject; var Text: string);
begin
  Text := 'Copy Reminder into ' + DataName[FEditingLevel] + ' Level Reminders List';
end;

procedure TfrmRemCoverSheet.SetupItem(Item: TListItem; const Data: string);
var
  AddCode, RemCode, rIEN, Seq: string;

begin
  Seq := Piece(Data,U,1);
  rIEN := Piece(Data,U,2);
  Item.Caption := Piece(Data,U,3);
  AddCode := copy(rIEN,1,1);
  RemCode := copy(rIEN,2,1);
  delete(rIEN,1,1);
  if AddCode = CVLockCode then
    Item.StateIndex := 5
  else
  if AddCode = CVRemoveCode then
    Item.StateIndex := 4
  else
  if AddCode = CVAddCode then
    Item.StateIndex := 3;
  if RemCode = CVCatCode then
    Item.ImageIndex := 1
  else
  if RemCode = CVRemCode then
    Item.ImageIndex := 0
  else
    Item.ImageIndex := -1;
  Item.SubItems.Clear;
  Item.SubItems.Add(Seq);     // IdxSeq  = 0
  Item.SubItems.Add('');      // IdxLvl  = 1
  Item.SubItems.Add('');      // IdxType = 2
  Item.SubItems.Add('');      // IdxTIEN = 3
  Item.SubItems.Add('');      // IdxLvl2 = 4
  Item.SubItems.Add(AddCode); // IdxAdd  = 5
  Item.SubItems.Add(rIEN);    // IdxIEN  = 6
end;

procedure TfrmRemCoverSheet.SetupItem(Item: TListItem; const Data: string;
                         Level: TRemCoverDataLevel; IEN: double);
begin
  SetupItem(Item, Data);
  Item.SubItems[IdxLvl]  := DataName[Level];
  Item.SubItems[IdxType] := GetExternalName(Level, IEN);
  Item.SubItems[IdxTIEN] := FloatToStr(IEN);
  Item.SubItems[IdxLvl2] := IntToStr(ord(Level));
end;

function TfrmRemCoverSheet.GetExternalName(Level: TRemCoverDataLevel; IEN: double): string;

  function GetNameFromList(List: TORStringList; IEN, FileNum: Double): string;
  var
    idx: integer;

  begin
    idx := List.IndexOfPiece(FloatToStr(IEN));
    if idx < 0 then
      idx := List.Add(floatToStr(IEN) + U + ExternalName(FloatToStr(IEN), FileNum));
      Result := piece(List[idx],U,2);
  end;

begin
  case Level of
    dlDivision:  Result := GetNameFromList(FDivisions, IEN, 4);
    dlService:   Result := GetNameFromList(FServices, IEN, 49);
    dlLocation:  Result := GetNameFromList(FLocations, IEN, 44);
    dlUserClass: Result := GetNameFromList(FClasses, IEN, 8930);
    dlUser:      Result := GetNameFromList(FUsers, IEN, 200);
    else         Result := '';
  end;
end;

procedure TfrmRemCoverSheet.cbxDivisionChange(Sender: TObject);
var
tmp: string;
begin
 if cbxDivision.itemindex < 0 then
  exit;
  tmp := Piece(cbxDivision.items.Strings[cbxDivision.itemindex], u, 1);
  FCurDiv := StrToFloatDef(tmp,0);
  If FCurDiv < 1  then   //No value in Division combobox
  begin
    sbCopyLeft.Enabled := false;
    sbCopyRight.Enabled := false;
    FSelection := false;
  end
  else
    FSelection := true;
  FUpdatePending := cbDivision;
  if not cbxDivision.DroppedDown then
    cbxDropDownClose(nil);
end;

procedure TfrmRemCoverSheet.cbxServiceChange(Sender: TObject);
begin
  FCurSer := cbxService.ItemIEN;
  If FCurSer < 1  then   //No value in Service combobox
  begin
    sbCopyLeft.Enabled := false;
    sbCopyRight.Enabled := false;
    FSelection := false;
  end
  else
    FSelection := true;
  FUpdatePending := cbService;
  if not cbxService.DroppedDown then
    cbxDropDownClose(nil);
end;

procedure TfrmRemCoverSheet.cbxLocationChange(Sender: TObject);
begin
  FCurLoc := TORComboBox(Sender).ItemIEN;
  If FCurLoc < 1  then   //No value in Location combobox
  begin
    sbCopyLeft.Enabled := false;
    sbCopyRight.Enabled := false;
    FSelection := false;
  end
  else
    FSelection := true;
  FUpdatePending := cbLocation;
  if not TORComboBox(Sender).DroppedDown then
    cbxDropDownClose(nil);
end;

procedure TfrmRemCoverSheet.cbxClassChange(Sender: TObject);
begin
  FCurClass := cbxClass.ItemIEN;
  If FCurClass < 1  then   //No value in User Class combobox
  begin
    sbCopyLeft.Enabled := false;
    sbCopyRight.Enabled := false;
    FSelection := false;
  end
  else
    FSelection := true;
  FUpdatePending := cbUserClass;
  if not cbxClass.DroppedDown then
    cbxDropDownClose(nil);
end;

procedure TfrmRemCoverSheet.cbxUserChange(Sender: TObject);
var
  NewVal, idx: integer;
  ErrMsg: String;
begin
  if FChanging then
    Exit;

  if not CheckForSimilarName(cbxUser, ErrMsg, sPr) then
  begin
    ShowMsgOn(ErrMsg <> '', ErrMsg, 'Provider Selection');
    exit;
  end;

  FCurUser := cbxUser.ItemIEN;
  If FCurUser < 1  then   //No value in User combobox
  begin
    sbCopyLeft.Enabled := false;
    sbCopyRight.Enabled := false;
    FSelection := false;
  end
  else
    FSelection := true;
  GetUserInfo(FCurUser);
  idx := FUserInfo.IndexOfPiece(DivisionCode);
  if idx >= 0 then
  begin
    NewVal := StrToIntDef(Piece(FUserInfo[idx],U,2),0);
    if NewVal <> FCurDiv then
    begin
      FCurDiv := NewVal;
      cbxDivision.InitLongList(GetExternalName(dlDivision, NewVal));
      cbxDivision.SelectByIEN(NewVal);
    end;
  end;
  idx := FUserInfo.IndexOfPiece(ServiceCode);
  if idx >= 0 then
  begin
    NewVal := StrToIntDef(Piece(FUserInfo[idx],U,2),0);
    if NewVal <> FCurSer then
    begin
      FCurSer := NewVal;
      cbxService.InitLongList(GetExternalName(dlService, NewVal));
      cbxService.SelectByIEN(NewVal);
    end;
  end;
  FCurClass := 0;
  cbxClass.ItemIndex := -1;
  FUpdatePending := cbUser;
  if not cbxUser.DroppedDown then
    cbxDropDownClose(nil);
end;

procedure TfrmRemCoverSheet.cbxUserEnter(Sender: TObject);
begin
  inherited;
  FChanging := true;
end;

procedure TfrmRemCoverSheet.cbxUserExit(Sender: TObject);
begin
  inherited;
  if FChanging then
  begin
    FChanging := False;
    cbxUserChange(sender);
  end;
end;

procedure TfrmRemCoverSheet.cbxUserLocExit(Sender: TObject);
begin
  inherited;
  //TDP - CQ#19733 Corrected tabbing issues
  if ShiftTabIsPressed() then
  begin
    if ScreenReaderSystemActive then lblCAC.SetFocus
    else btnView.SetFocus;
  end;
end;

procedure TfrmRemCoverSheet.cbxUserMouseClick(Sender: TObject);
begin
  inherited;
  if FChanging then
  begin
    FChanging := False;
    cbxUserChange(sender);
  end;
end;

procedure TfrmRemCoverSheet.cbxDropDownClose(Sender: TObject);
begin
  if assigned(FUpdatePending) then
  begin
    UpdateView;
    if FInitialized and (not FUserMode) then
    begin
      if FUpdatePending.Checked then
        cbEditLevelClick(FUpdatePending)
      else
        FUpdatePending.Checked := TRUE;
    end;
    FUpdatePending := nil;
  end;
end;

procedure TfrmRemCoverSheet.caMoveDownCaptionQuery(Sender: TObject;
  var Text: string);
begin
  inherited;
  Text := 'Move item down list';
end;

procedure TfrmRemCoverSheet.caMoveUPCaptionQuery(Sender: TObject;
  var Text: string);
begin
  inherited;
  Text := 'Move item up list';
end;

procedure TfrmRemCoverSheet.cbEditLevelClick(Sender: TObject);
var
  cb: TORCheckBox;
  tmp: string;

begin
  cb := TORCheckBox(Sender);
  if cb.Checked then
  begin
    FEditingLevel := TRemCoverDataLevel(cb.Tag);
    if FEditingLevel <> dlUserClass then
    begin
      FCurClass := 0;
      cbxClass.ItemIndex := -1;
    end;
    case FEditingLevel of
      dlDivision:  FEditingIEN := FCurDiv;
      dlService:   FEditingIEN := FCurSer;
      dlLocation:  FEditingIEN := FCurLoc;
      dlUserClass: FEditingIEN := FCurClass;
      dlUser:      FEditingIEN := FCurUser;
      else         FEditingIEN := 0;
    end;
    if FEditingIEN = 0 then
    begin
      tmp := ' ';
      IF FEditingLevel = dlSystem then
        FSelection := true
      else
      begin
        sbCopyLeft.Enabled := false;
        sbCopyRight.Enabled := false;
        FSelection := false;
      end;
    end
    else
    begin
      tmp := ': ';
      FSelection := true;
    end;
    lblEdit.Caption := '  Editing Cover Sheet Reminders for ' + DataName[FEditingLevel] +
                        tmp + GetExternalName(FEditingLevel, FEditingIEN);
    lvCover.Columns[0].Caption := DataName[FEditingLevel] + ' Level Reminders';

    SetButtonHints;   {Setup hints for Lock, Add, Remove buttons based on
                       Parameter Level}
    UpdateView;
    UpdateMasterListView;
  end
  else
  begin
    FSelection := false;
    sbCopyLeft.Enabled := false;
    sbCopyRight.Enabled := false;
    FEditingLevel := dlPackage;
    FEditingIEN := 0;
    lblEdit.Caption := '';
    lvCover.Items.BeginUpdate;
    try
      lvCover.Items.Clear;
    finally
      lvCover.Items.EndUpdate;
    end;
  end;

end;

procedure TfrmRemCoverSheet.cbSystemExit(Sender: TObject);
begin
  inherited;
  //TDP - CQ#19733 Corrected tabbing issues
  if ShiftTabIsPressed() then
  begin
    if ScreenReaderSystemActive then lblCAC.SetFocus
    else btnView.SetFocus;
  end;
end;

procedure TfrmRemCoverSheet.UpdateMasterListView;
var
  i: integer;
  tmpSL: TStringList;
  itm: TListItem;

begin
  lvCover.Items.BeginUpdate;
  try
    lvCover.Items.Clear;
    if FEditingLevel <> dlPackage then
    begin
      tmpSL := GetCurrent(FEditingIEN, FEditingLevel, FALSE);
      if assigned(tmpSL) then
      begin
        for i := 0 to tmpSL.Count-1 do
        begin
          itm := lvCover.Items.Add;
          SetupItem(itm, tmpSL[i]);
        end;
      end;
    end;
  finally
    lvCover.Items.EndUpdate;
  end;
  UpdateButtons;
end;

procedure TfrmRemCoverSheet.UpdateButtons;
var
  FocusOK, ok: boolean;
  i, idx: integer;
  Current, Lowest, Highest: integer;
  tmp: string;
  tmpSL: TORstringlist;
  doDownButton, doUpButton: boolean;

begin
  lvCover.Enabled := (FEditingLevel <> dlPackage);
  ok := assigned(tvAll.Selected) and (FEditingLevel <> dlPackage) and FSelection
    and WriteAccess(waReminderEditor);
  sbCopyRight.Enabled := ok;

  ok := assigned(lvCover.Selected) and (FEditingLevel <> dlPackage) and FSelection and
    WriteAccess(waReminderEditor);
  sbCopyLeft.Enabled := ok;

  ok := assigned(lvCover.Selected) and WriteAccess(waReminderEditor);
  lblSeq.Enabled := ok;
  edtSeq.Enabled := ok;

  FUpdating := TRUE;
  try
    udSeq.Enabled := ok;
    if ok then
      udSeq.Position := StrToIntDef(lvCover.Selected.SubItems[IdxSeq],1)
    else
      udSeq.Position := 1;
  finally
    FUpdating := FALSE;
  end;

  FocusOK := lvCover.Focused or sbUp.Focused or sbDown.Focused or edtSeq.Focused or
             udSeq.Focused or btnAdd.Focused or btnRemove.Focused or btnLock.Focused or
             btnOK.Focused; // add btnOK so you can shift-tab backwards into list
  btnAdd.Enabled := ok and FocusOK;
  btnRemove.Enabled := ok and (FEditingLevel <> dlSystem) and FocusOK;
  btnLock.Enabled := ok and (FEditingLevel <> dlUser) and FocusOK;
  if ok then
  begin
    tmpSL := GetCurrent(FEditingIEN, FEditingLevel, FALSE);
    if assigned(tmpSL) then
    begin
      Idx := GetIndex(tmpSL, lvCover.Selected);
      if Idx >= 0 then
      begin
        tmp := tmpSL[idx];
        tmp := piece(tmp,u,2);
        tmp := copy(tmp,1,1);
        if tmp = 'L' then
        begin
          LockButtonUpdate('Unlock', 'BMP_UNLOCK', UnlockHint);
        end;
        if tmp = 'N' then
        begin
          LockButtonUpdate('Lock', 'BMP_LOCK', LockHint);
        end;
        if tmp = 'R' then
        begin
          LockButtonUpdate('Add && Lock', 'BMP_LOCK', AddLockHint);
        end;
      end;
    end;
    ok :=(lvCover.Items.Count > 1);
  end;
  Lowest := 99999;
  Highest := -1;
  if ok then
  begin
    for i := 0 to lvCover.Items.Count-1 do
    begin
      Current := StrToIntDef(lvCover.Items[i].SubItems[IdxSeq], 0);
      if Lowest > Current then
        Lowest := Current;
      if Highest < Current then
        Highest := Current;
    end;
    Current := StrToIntDef(lvCover.Selected.SubItems[IdxSeq], 0);
  end
  else
    Current := 0;
  doDownButton := (sbUp.Focused and (Current = Lowest));
  doUpButton := (sbDown.Focused and (Current = Highest));
  sbUp.Enabled := ok and (Current > Lowest);
  sbDown.Enabled := ok and (Current < Highest);
  if doDownButton and sbDown.enabled then sbDown.SetFocus;
  if doUpButton and sbUp.enabled then sbUp.SetFocus;
end;

procedure TfrmRemCoverSheet.tvAllExpanding(Sender: TObject;
  Node: TTreeNode; var AllowExpansion: Boolean);
var
  List: TORStringList;
  i, idx: integer;
  CNode: TORTreeNode;

begin
  if Node.GetFirstChild.Text = DummyNode then
  begin
    Node.DeleteChildren;
    List := GetCatInfo(copy(piece(TORTreeNode(Node).StringData,U,1),2,99));
    if assigned(List) then
    begin
      for i := 0 to List.Count-1 do
      begin
        CNode := TORTreeNode(tvAll.Items.AddChild(Node,''));
        CNode.StringData := List[i];
        if copy(List[i],1,1) = CVCatCode then
        begin
          idx := 1;
          tvAll.Items.AddChild(CNode, DummyNode);
        end
        else
          idx := 0;
        CNode.ImageIndex := idx;
        CNode.SelectedIndex := idx;
      end;
    end;
  end;
  if FInternalExpansion then
    AllowExpansion := FALSE
  else
    AllowExpansion := Node.HasChildren;
end;

function TfrmRemCoverSheet.GetCatInfo(CatIEN: string): TORStringList;
var
  i, j, idx: integer;
  tmp: string;
  tmpSL: TStrings;

begin
  idx := FCatInfo.IndexOf(CatIEN);
  if idx < 0 then
  begin
    Result := TORStringList.Create;
    tmpSL := TStringList.Create;
    try
      if GetCategoryItems(StrToIntDef(CatIEN,0), tmpSL) = 0 then exit;
      for i := 0 to tmpSL.Count-1 do
      begin
        tmp := copy(tmpSL[i],1,1);
        if tmp = CVCatCode then
          idx := 3
        else
          idx := 4;
        tmp := tmp + Piece(tmpSL[i],U,2) + U + Piece(tmpSL[i],U,idx);
        j := FMasterList.IndexOfPiece(piece(tmp,U,1));
        if j >= 0 then
          tmp := tmp + piece(FMasterList[j],U,3);
        Result.Add(tmp);
      end;
      FCatInfo.AddObject(CatIEN, Result);
      FreeAndNil(tmpSL);
    except
      Result.Free;
      FreeAndNil(tmpSl);
      raise;
    end;
  end
  else
    Result := TORStringList(FCatInfo.Objects[idx]);
end;

procedure TfrmRemCoverSheet.MarkListAsChanged;
var
  tmp: string;
  idx: integer;

begin
  idx := FData.IndexOfPiece(String(DataCode[FEditingLevel]) + FloatToStr(FEditingIEN));
  if (idx >= 0) and WriteAccess(waReminderEditor) then
  begin
    tmp := FData[idx];
    SetPiece(Tmp,U,2,BoolChar[TRUE]);
    FData[idx] := tmp;
    btnApply.Enabled := TRUE;
    UpdateView;
  end;
end;

procedure TfrmRemCoverSheet.edtSeqChange(Sender: TObject);
begin
  if FUpdating or (not FInitialized) then exit;
  if FBottomSortTag <> 2 then
  begin
    FBottomSortTag := 2;
    lvCover.CustomSort(nil, 0);
  end;
  SetSeq(lvCover.Selected, IntToStr(udSeq.Position));
  lvCover.CustomSort(nil, 0);
  UpdateButtons;
end;

procedure TfrmRemCoverSheet.tvAllExpanded(Sender: TObject;
  Node: TTreeNode);
var
  idx: integer;

begin
  if Node.Expanded then
    idx := 2
  else
    idx := 1;
  Node.ImageIndex := idx;
  Node.SelectedIndex := idx;
end;

procedure TfrmRemCoverSheet.tvAllChange(Sender: TObject; Node: TTreeNode);
begin
  UpdateButtons;
end;

procedure TfrmRemCoverSheet.lvCoverChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  UpdateButtons;
end;

function TfrmRemCoverSheet.GetIndex(List: TORStringList;
  Item: TListItem): integer;
var
  IEN: string;

begin
  if assigned(Item) and assigned(List) then
  begin
    IEN := Item.SubItems[IdxAdd] + Item.SubItems[IdxIEN];
    Result := List.IndexOfPiece(IEN,U,2);
  end
  else
    Result := -1;
end;

procedure TfrmRemCoverSheet.ChangeStatus(Code: string);
var
  tmpSL: TORStringList;
  Idx: integer;
  tmp,p: string;

begin
  tmpSL := GetCurrent(FEditingIEN, FEditingLevel, FALSE);
  if assigned(tmpSL) then
  begin
    Idx := GetIndex(tmpSL, lvCover.Selected);
    if Idx >= 0 then
    begin
      tmp := tmpSL[idx];
      p := Piece(tmp,U,2);
      SetPiece(tmp,U,2,Code + copy(p,2,MaxInt));
      tmpSL[idx] := tmp;
      MarkListAsChanged;
      SetupItem(lvCover.Selected, tmp);
      tmp := piece(tmp,u,2);
      tmp := copy(tmp,1,1);
      if tmp = 'L' then
      begin
        LockButtonUpdate('Unlock', 'BMP_UNLOCK', UnlockHint);
      end;
      if tmp = 'N' then
      begin
        LockButtonUpdate('Lock', 'BMP_LOCK', LockHint);
      end;
      if tmp = 'R' then
      begin
        LockButtonUpdate('Add && Lock', 'BMP_LOCK', AddLockHint);
      end;
    end;
  end;
end;

procedure TfrmRemCoverSheet.cbLegendClick(Sender: TObject);
begin
  grdPanel.Visible := cbLegend.Checked;
end;

procedure TfrmRemCoverSheet.btnAddClick(Sender: TObject);
begin
  ChangeStatus(CVAddCode);
end;

procedure TfrmRemCoverSheet.btnRemoveClick(Sender: TObject);
begin
  ChangeStatus(CVRemoveCode);
end;

procedure TfrmRemCoverSheet.btnLockClick(Sender: TObject);
begin
  ChangeStatus(CVLockCode);
end;

procedure TfrmRemCoverSheet.lvViewColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  if FTopSortTag = Column.Tag then
    FTopSortUp := not FTopSortUp
  else
    FTopSortTag := Column.Tag;
  lvView.CustomSort(nil, 0);
end;

type
  TSortData = (sdRem, sdSeq, sdLvl, sdOther);

procedure TfrmRemCoverSheet.lvCoverColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  if FBottomSortTag = Column.Tag then
    FBottomSortUp := not FBottomSortUp
  else
    FBottomSortTag := Column.Tag;
  lvCover.CustomSort(nil, 0);
end;

procedure TfrmRemCoverSheet.lvViewCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
var
  i: integer;
  odr: array[1..4] of TSortData;
  s1, s2: string;

begin
  odr[1] := TSortData(FTopSortTag-1);
  case FTopSortTag of
    1: begin
         odr[2] := sdSeq;
         odr[3] := sdLvl;
         odr[4] := sdOther;
       end;

    2: begin
         odr[2] := sdLvl;
         odr[3] := sdOther;
         odr[4] := sdRem;
       end;

    3: begin
         odr[2] := sdOther;
         odr[3] := sdSeq;
         odr[4] := sdRem;
       end;

    4: begin
         odr[2] := sdLvl;
         odr[3] := sdSeq;
         odr[4] := sdRem;
       end;
  end;
  Compare := 0;
  for i := 1 to 4 do
  begin
    case odr[i] of
      sdRem:   begin
                 s1 := Item1.Caption;
                 s2 := Item2.Caption;
               end;

      sdSeq:   begin
                 s1 := RPad(Item1.SubItems[IdxSeq]);
                 s2 := RPad(Item2.SubItems[IdxSeq]);
               end;

      sdLvl:   begin
                 s1 := Item1.SubItems[IdxLvl2];
                 s2 := Item2.SubItems[IdxLvl2];
               end;

      sdOther: begin
                 s1 := Item1.SubItems[IdxType];
                 s2 := Item2.SubItems[IdxType];
               end;

    end;
    Compare := CompareText(s1, s2);
    if Compare <> 0 then break;
  end;
  if not FTopSortUp then
    Compare := -Compare;
end;

procedure TfrmRemCoverSheet.lvViewExit(Sender: TObject);
begin
  inherited;
  //TDP - CQ#19733 Corrected tabbing issues
  if TabIsPressed() then btnView.SetFocus;
end;

procedure TfrmRemCoverSheet.lvCoverCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
var
  i: integer;
  odr: array[1..2] of TSortData;
  s1, s2: string;

begin
  case FBottomSortTag of
    1: begin
         odr[1] := sdRem;
         odr[2] := sdSeq;
       end;

    2: begin
         odr[1] := sdSeq;
         odr[2] := sdRem;
       end;
  end;
  Compare := 0;
  for i := 1 to 2 do
  begin
    case odr[i] of
      sdRem:   begin
                 s1 := Item1.Caption;
                 s2 := Item2.Caption;
               end;

      sdSeq:   begin
                 s1 := RPad(Item1.SubItems[IdxSeq]);
                 s2 := RPad(Item2.SubItems[IdxSeq]);
               end;
    end;
    Compare := CompareText(s1, s2);
    if Compare <> 0 then break;
  end;
  if not FBottomSortUp then
    Compare := -Compare;
end;

procedure TfrmRemCoverSheet.sbUpClick(Sender: TObject);
var
  NextItem: TListItem;
  Seq1, Seq2: string;

begin
  if assigned(lvCover.Selected) then
  begin
    if FBottomSortTag <> 2 then
    begin
      FBottomSortTag := 2;
      lvCover.CustomSort(nil, 0);
    end;
    if lvCover.Selected.Index > 0 then
    begin
      NextItem := lvCover.Items[lvCover.Selected.Index - 1];
      Seq1 := NextItem.SubItems[IdxSeq];
      Seq2 := lvCover.Selected.SubItems[IdxSeq];
      SetSeq(NextItem, Seq2);
      SetSeq(lvCover.Selected, Seq1);
      lvCover.CustomSort(nil, 0);
      If ScreenReaderSystemActive then
        GetScreenReader.Speak('Reminder Moved up in Sequence');
      UpdateButtons;
    end;
  end;
end;

procedure TfrmRemCoverSheet.sbDownClick(Sender: TObject);
var
  NextItem: TListItem;
  Seq1, Seq2: string;

begin
  if assigned(lvCover.Selected) then
  begin
    if FBottomSortTag <> 2 then
    begin
      FBottomSortTag := 2;
      lvCover.CustomSort(nil, 0);
    end;
    if lvCover.Selected.Index < (lvCover.Items.Count-1) then
    begin
      NextItem := lvCover.Items[lvCover.Selected.Index + 1];
      Seq1 := NextItem.SubItems[IdxSeq];
      Seq2 := lvCover.Selected.SubItems[IdxSeq];
      SetSeq(NextItem, Seq2);
      SetSeq(lvCover.Selected, Seq1);
      lvCover.CustomSort(nil, 0);
      If ScreenReaderSystemActive then
        GetScreenReader.Speak('Reminder Moved down in Sequence');
      UpdateButtons;
    end;
  end;
end;

procedure TfrmRemCoverSheet.SetSeq(Item: TListItem; const Value: string);
var
  tmpSL: TORStringList;
  Idx: integer;
  tmp: string;

begin
  tmpSL := GetCurrent(FEditingIEN, FEditingLevel, FALSE);
  if assigned(tmpSL) then
  begin
    Idx := GetIndex(tmpSL, Item);
    if Idx >= 0 then
    begin
      tmp := tmpSL[idx];
      if(Piece(Tmp,U,1) <> Value) then
      begin
        SetPiece(tmp,U,1,Value);
        tmpSL[idx] := tmp;
        MarkListAsChanged;
        SetupItem(Item, tmp);
      end;
    end;
  end;
end;

procedure TfrmRemCoverSheet.sbCopyRightClick(Sender: TObject);
var
  i: integer;
  Seq, Cur, Idx: integer;
  tmpSL: TORStringList;
  IEN: string;

begin
  if assigned(tvAll.Selected) then
  begin
    IEN := Piece(TORTreeNode(tvAll.Selected).StringData, U, 1);
    if ListHasData(IEN, IdxIEN) then
    begin
      ShowMsg('List already contains this Reminder');
      exit;
    end;
    if lvCover.Items.Count = 0 then
      Seq := 10
    else
    begin
      Seq := 0;
      for i := 0 to lvCover.Items.Count-1 do
      begin
        Cur := StrToIntDef(lvCover.Items[i].SubItems[IdxSeq], 0);
        if Seq < Cur then
          Seq := Cur;
      end;
      inc(Seq,10);
      if Seq > 999 then
      begin
        Seq := 999;
        while (Seq > 0) and ListHasData(IntToStr(Seq), IdxSeq) do dec(Seq);
      end;
    end;
    if Seq > 0 then
    begin
      tmpSL := GetCurrent(FEditingIEN, FEditingLevel, FALSE, TRUE);
      Idx := tmpSL.IndexOfPiece(IEN,U,2);
      if Idx < 0 then
      begin
        tmpSL.Add(IntToStr(Seq) + U + CVAddCode + TORTreeNode(tvAll.Selected).StringData);
        MarkListAsChanged;
        UpdateMasterListView;
        for i := 0 to lvCover.Items.Count-1 do
          if IEN = lvCover.Items[i].SubItems[IdxIEN] then
          begin
            lvCover.Selected := lvCover.Items[i];
            break;
          end;
      end;
      if ScreenReaderSystemActive then
        GetScreenReader.Speak(Piece(TORTreeNode(tvAll.Selected).StringData, U, 2) + 'added to ' + DataName[FEditingLevel] + ' level reminders list');
    end;
  end;
end;

procedure TfrmRemCoverSheet.sbCopyRightExit(Sender: TObject);
begin
  inherited;
  //TDP - CQ#19733 On Tab from sbCopyRight, go to btnOK if no data in lvCover
  if TabIsPressed() then
  begin
    if not ScreenReaderSystemActive then
    begin
      if lvCover.Items.Count = 0 then btnOK.SetFocus;
    end;
  end;
end;

function TfrmRemCoverSheet.ListHasData(Seq: string; SubIdx: integer): boolean;
var
  i: integer;

begin
  Result := FALSE;
  for i := 0 to lvCover.Items.Count-1 do
    if Seq = lvCover.Items[i].SubItems[SubIdx] then
    begin
      Result := TRUE;
      break;
    end;
end;

procedure TfrmRemCoverSheet.udSeqChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: Integer; Direction: TUpDownDirection);
{
  begin
  inherited;

end;procedure TfrmRemCoverSheet._udSeqChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: Smallint;
  Direction: TUpDownDirection);
}
begin
  if FUpdating or (not FInitialized) then exit;
  if ListHasData(IntToStr(NewValue), IdxSeq) then
  begin
    AllowChange := FALSE;
    case Direction of
      updUp:   udSeq.Position := NewValue + 1;
      updDown: udSeq.Position := NewValue - 1;
    end;
  end;
end;

procedure TfrmRemCoverSheet.sbCopyLeftClick(Sender: TObject);
var
  idx, Index, i: integer;
  tmpSL: TORStringList;
  strSelect: String;

begin
  if assigned(lvCover.Selected) then
  begin
    tmpSL := GetCurrent(FEditingIEN, FEditingLevel, FALSE);
    if assigned(tmpSL) then
    begin
      Idx := GetIndex(tmpSL, lvCover.Selected);
      Index := lvCover.Selected.Index;
      if Idx >= 0 then
      begin
        strSelect := lvCover.Selected.Caption;
        tmpSL.Delete(Idx);
        MarkListAsChanged;
        UpdateMasterListView;
        if lvCover.Items.Count > 0 then
        begin
          if Index > 0 then
            dec(Index);
          for i := 0 to lvCover.Items.Count-1 do
            if lvCover.Items[i].Index = Index then
            begin
              lvCover.Selected := lvCover.Items[i];
              break;
            end;
        end;
        if ScreenReaderSystemActive then
          GetScreenReader.Speak(strSelect + 'removed from ' + DataName[FEditingLevel] + ' level reminders list');
      end;
    end;
    if sbCopyLeft.Enabled and (not sbCopyLeft.Focused) then
      sbCopyLeft.SetFocus;
  end;
end;

procedure TfrmRemCoverSheet.tvAllDblClick(Sender: TObject);
begin
  if sbCopyRight.Enabled then
    sbCopyRight.Click;
end;

procedure TfrmRemCoverSheet.btnApplyClick(Sender: TObject);
begin
  SaveData(TRUE);
  btnApply.Enabled := FALSE;
end;

procedure TfrmRemCoverSheet.btnOKClick(Sender: TObject);
begin
  SaveData(FALSE);
end;

procedure TfrmRemCoverSheet.btnOKExit(Sender: TObject);
begin
  inherited;
  //TDP - CQ#19733 On ShiftTab from btnOK, go to sbCopyRight if no data in lvCover
  if ShiftTabIsPressed() then
  begin
    if not ScreenReaderSystemActive then
    begin
      if lvCover.Items.Count = 0 then sbCopyRight.SetFocus;
    end;
  end;
end;

procedure TfrmRemCoverSheet.SaveData(FromApply: boolean);
var
  i, j: integer;
  tmpSL: TORStringList;
  DeleteIt, DoRefresh: boolean;
  Level, lvl: TRemCoverDataLevel;
  ALevel, AClass, Code, IEN: string;

begin
  DoRefresh := FALSE;
  i := 0;
  while (i < FData.Count) do
  begin
    DeleteIt := FALSE;
    if(Piece(FData[i],U,2) = BoolChar[TRUE]) then
    begin
      tmpSL := TORStringList(FData.Objects[i]);
      if assigned(tmpSL) then
      begin
        Level := dlPackage;
        Code := copy(FData[i],1,1);
        for lvl := low(TRemCoverDataLevel) to high(TRemCoverDataLevel) do
        begin
          if String(DataCode[lvl]) = Code then
          begin
            Level := lvl;
            break;
          end;
        end;
        if Level <> dlPackage then
        begin
          IEN := copy(Piece(FData[i],U,1),2,MaxInt);
          ALevel := InternalName[Level];
          ACLass := '';
          case Level of
            dlDivision, dlService, dlLocation, dlUser:
              ALevel := ALevel + '.`' + IEN;
            dlUserClass:
              AClass := IEN;
          end;
          for j := 0 to tmpSL.Count-1 do
            tmpSL[j] := pieces(tmpSL[j],U,1,2);
          SetCoverSheetLevelData(ALevel, AClass, tmpSL);
          tmpSL.Free;
          DeleteIt := TRUE;
          FDataSaved := TRUE;
          DoRefresh := TRUE;
        end;
      end;
    end;
    if DeleteIt then
      FData.Delete(i)
    else
      inc(i);
  end;
  if FromApply and DoRefresh then
    UpdateMasterListView;
end;

procedure TfrmRemCoverSheet.lvCoverDblClick(Sender: TObject);
begin
  if sbCopyLeft.Enabled then
    sbCopyLeft.Click;
end;

procedure TfrmRemCoverSheet.lvViewChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  lvViewSelectItem(Sender, Item, FALSE);
end;

procedure TfrmRemCoverSheet.lvViewSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
var
  lvl: TRemCoverDataLevel;
  i: integer;
  ClsName, TIEN, IEN, lvlName: string;
  ok: boolean;

begin
  if assigned(lvView.Selected) and (not FUpdatingView) then
  begin
    FUpdatingView := TRUE;
    try
      lvl := TRemCoverDataLevel(StrToIntDef(lvView.Selected.SubItems[IdxLvl2],ord(dlUser)));
      IEN := lvView.Selected.SubItems[IdxIEN];
      lvlName := lvView.Selected.SubItems[IdxLvl];
      TIEN := lvView.Selected.SubItems[IdxTIEN];
      ClsName := lvView.Selected.SubItems[IdxType];
      ok := (lvl <> FEditingLevel);
      if(not ok) and (lvl = dlUserClass) then
        ok := (FEditingIEN <> StrToIntDef(TIEN,0));
      if (not FUserMode) and ok and (lvl <> dlPackage) then
      begin
        case lvl of
          dlSystem:    FUpdatePending := cbSystem;
          dlDivision:  FUpdatePending := cbDivision;
          dlService:   FUpdatePending := cbService;
          dlLocation:  FUpdatePending := cbLocation;
          dlUserClass: FUpdatePending := cbUserClass;
          dlUser:      FUpdatePending := cbUser;
        end;
        if lvl = dlUserClass then
        begin
          cbxClass.InitLongList(ClsName);
          cbxClass.SelectByID(TIEN);
          FCurClass := cbxClass.ItemIEN;
        end;
        cbxDropDownClose(nil);
      end;
      if (lvl = FEditingLevel) then
      begin
        for i := 0 to lvCover.Items.Count-1 do
          if IEN = lvCover.Items[i].SubItems[IdxIEN] then
          begin
            lvCover.Selected := lvCover.Items[i];
            break;
          end;
      end;
      for i := 0 to lvView.Items.Count-1 do
      begin
        if (IEN = lvView.Items[i].SubItems[IdxIEN]) and
           (lvlName = lvView.Items[i].SubItems[IdxLvl]) then
        begin
          lvView.Selected := lvView.Items[i];
          break;
        end;
      end;
    finally
      FUpdatingView := FALSE;
    end;
  end;
end;

function TfrmRemCoverSheet.RPad(Str: String): String;
begin
  Result := StringOfChar('0',7-length(Str)) + Str;
end;

procedure TfrmRemCoverSheet.btnViewClick(Sender: TObject);
var
  frmRemCoverPreview: TfrmRemCoverPreview;
  CurSortOrder: integer;
  CurSortDir: boolean;
  i, idx, SeqCnt: integer;
  Lvl, LastLvl, tmp, AddCode, IEN, Seq, SortID: string;
  RemList, LvlList: TORStringList; // IEN^Name^Seq^SortID^Locked
  ANode: TTreeNode;

  procedure GetAllChildren(PNode: TTreeNode; const ASeq, ASortID: string);
  var
    Node: TTreeNode;

  begin
    PNode.Expand(FALSE);
    Node := PNode.GetFirstChild;
    while assigned(Node) do
    begin
      tmp := TORTreeNode(Node).StringData;
      if copy(tmp,1,1) = CVCatCode then
        GetAllChildren(Node, ASeq, ASortID)
      else
      begin
        if RemList.IndexOfPiece(Piece(tmp,u,1)) < 0 then
        begin
          SetPiece(tmp,u,3,ASeq);
          inc(SeqCnt);
          SortID := copy(ASortID,1,7) + RPad(IntToStr(SeqCnt)) + copy(ASortID,15,MaxInt);
          SetPiece(tmp,u,4,SortID);
          RemList.Add(tmp);
        end;
      end;
      Node := Node.GetNextSibling;
    end;
  end;

begin
  Screen.OnActiveControlChange := fOldFocusChanged;
  try
    frmRemCoverPreview := TfrmRemCoverPreview.Create(Application);
    try
      CurSortOrder := FTopSortTag;
      CurSortDir := FTopSortUp;
      lvView.Items.BeginUpdate;
      try
        FTopSortTag := 3;
        FTopSortUp := TRUE;
        lvView.CustomSort(nil, 0);
        RemList := TORStringList.Create;
        try
          LvlList := TORStringList.Create;
          try
            LastLvl := '';
            for i := 0 to lvView.Items.Count-1 do
            begin
              Lvl := lvView.Items[i].SubItems[IdxLvl2];
              if LvL <> LastLvl then
              begin
                RemList.AddStrings(LvlList);
                LvlList.Clear;
                LastLvl := Lvl;
              end;
              IEN := lvView.Items[i].SubItems[IdxIEN];
              AddCode := lvView.Items[i].SubItems[IdxAdd];
              idx := RemList.IndexOfPiece(IEN);
              if AddCode = CVRemoveCode then
              begin
                if(idx >= 0) and (piece(RemList[idx],U,5) <> '1') then
                  RemList.Delete(idx);
              end
              else
              begin
                if idx < 0 then
                begin
                  Seq := lvView.Items[i].SubItems[IdxSeq];
                  SortID := RPad(Seq) + '0000000' + lvl + copy(lvView.Items[i].SubItems[IdxTIEN] + '0000000000',1,10);
                  tmp := IEN + U + lvView.Items[i].Caption + U + Seq + U + SortID;
                  if AddCode = CVLockCode then
                    tmp := tmp + U + '1';
                  RemList.Add(tmp);
                end
                else
                if (AddCode = CVLockCode) and (piece(RemList[idx],U,5) <> '1') then
                begin
                  tmp := RemList[idx];
                  SetPiece(tmp,U,5,'1');
                  RemList[idx] := tmp;
                end;
              end;
            end;
            RemList.AddStrings(LvlList);
            FTopSortTag := CurSortOrder;
            FTopSortUp := CurSortDir;
            lvView.CustomSort(nil, 0);

            LvlList.Clear;
            //LvlList.Assign(RemList);
            FastAssign(RemList, LvlList);
            RemList.Clear;
            FInternalExpansion := TRUE;
            try
              for i := 0 to LvlList.Count-1 do
              begin
                IEN := piece(LvlList[i],U,1);
                if (copy(LvlList[i],1,1) = CVCatCode) then
                begin
                  ANode := tvAll.Items.GetFirstNode;
                  while assigned(ANode) do
                  begin
                    if IEN = piece(TORTreeNode(ANode).StringData,U,1) then
                    begin
                      SeqCnt := 0;
                      GetAllChildren(ANode, Piece(LvlList[i], U, 3), Piece(LvlList[i], U, 4));
                      ANode := nil;
                    end
                    else
                      ANode := ANode.GetNextSibling;
                  end;
                end
                else
                if RemList.IndexOfPiece(IEN) < 0 then
                  RemList.Add(LvlList[i]);
              end;
            finally
              FInternalExpansion := FALSE;
            end;
          finally
            LvlList.Free;
          end;

          RemList.SortByPiece(4);
          for i := 0 to RemList.Count-1 do
          begin
            with frmRemCoverPreview.lvMain.Items.Add do
            begin
              tmp := RemList[i];
              Caption := Piece(tmp, U, 2);
              SubItems.Add(Piece(tmp, U, 3));
              SubItems.Add(Piece(tmp, U, 4));
            end;
          end;
        finally
          RemList.Free;
        end;
      finally
        lvView.Items.EndUpdate;
      end;
      frmRemCoverPreview.ShowModal;
    finally
      frmRemCoverPreview.Free;
    end;
  finally
    Screen.OnActiveControlChange := ActiveControlChanged;
  end;
end;

procedure TfrmRemCoverSheet.btnViewExit(Sender: TObject);
begin
  inherited;
  //TDP - CQ#19733 Corrected tabbing issues
  if TabIsPressed() then
  begin
    if ScreenReaderSystemActive then lblCAC.SetFocus
    else begin
      if pnlUser.Visible then cbxUserLoc.SetFocus
      else cbSystem.SetFocus;
    end;
  end;
  if ShiftTabIsPressed() then lvView.SetFocus;
end;

procedure TfrmRemCoverSheet.lvCoverKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_DELETE) and sbCopyLeft.Enabled then
    sbCopyLeft.Click;
end;

procedure TfrmRemCoverSheet.edtSeqKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key < '0') or (Key > '9') then
    Key := #0;
end;

procedure TfrmRemCoverSheet.cbxDivisionKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin

  FChanging := True;

  if Key = VK_LEFT then
    Key := VK_UP;
  if Key = VK_RIGHT then
    Key := VK_DOWN;
  if Key = VK_RETURN then
  begin
    FChanging := False;
    if TORComboBox(Sender).DroppedDown then
      TORComboBox(Sender).DroppedDown := FALSE;
  end;
end;

function TfrmRemCoverSheet.GetCoverSheetLvlData(ALevel,
  AClass: string): TStrings;
var
  IEN: string;
  i, j: integer;
begin
  Result := TStringList.Create;
  if GetCoverSheetLevelData(ALevel, AClass, result) > 0 then
  begin
    for i := 0 to Result.Count-1 do
      begin
        IEN := copy(piece(Result[i],U,2),2,MaxInt);
        j := FMasterList.IndexOfPiece(IEN);
        if j >= 0 then
          Result[i] := Result[i] + piece(FMasterList[j],U,3);
      end;
  end;
end;

procedure TfrmRemCoverSheet.SetButtonHints;
{This procedure sets the Lock, Add, and Remove button hints based on the
 selected parameter level}
begin
  if FEditingLevel = dlDivision then
  begin
    btnLock.hint := 'Adds Reminder to the Coversheet display and Locks the Reminder'
          + CRLF + 'so it can not be removed from the Coversheet display at any'
          + CRLF + 'of the lower levels (Service, Location, User Class, User).';
    btnRemove.hint := 'Removes Reminders from the Coversheet display.  Will not'
          + CRLF + 'remove Reminders which are locked at the System level.';
    btnAdd.hint := 'Adds Reminders to the Coversheet at the Division level and'
          + CRLF + 'below.  It also removes the lock from a Reminder locked at'
          + CRLF + 'the Division level while leaving the Reminder on the Coversheet.';
  end
  else if FEditingLevel = dlService then
  begin
    btnLock.hint := 'Adds Reminder to the Coversheet display and Locks the Reminder'
          + CRLF + 'so it can not be removed from the Coversheet display at any of'
          + CRLF + 'the lower levels (Location, User Class, User).';
    btnRemove.hint := 'Removes Reminders from the Coversheet display.  Will not'
          + CRLF + 'remove Reminders which are locked at the Division level or higher.';
    btnAdd.hint := 'Adds Reminders to the Coversheet at the Service level and'
          + CRLF + 'below.  It also removes the lock from a Reminder locked at the'
          + CRLF + 'Service level while leaving the Reminder on the Coversheet.';
  end
  else if FEditingLevel = dlLocation then
  begin
    btnLock.hint := 'Adds Reminder to the Coversheet display and Locks the Reminder'
          + CRLF + 'so it can not be removed from the Coversheet display at any of'
          + CRLF + 'the lower levels (User Class, User).';
    btnRemove.hint := 'Removes Reminders from the Coversheet display.  Will not'
          + CRLF + 'remove Reminders which are locked at the Service level or higher.';
    btnAdd.hint := 'Adds Reminders to the Coversheet at the Location level and'
          + CRLF + 'below.  It also removes the lock from a Reminder locked at the'
          + CRLF + 'Location level while leaving the Reminder on the Coversheet.';
  end
  else if FEditingLevel = dlUserClass then
  begin
    btnLock.hint := 'Adds Reminder to the Coversheet display and Locks the Reminder so'
          + CRLF + 'it can not be removed from the Coversheet display at the User level.';
    btnRemove.hint := 'Removes Reminders from the Coversheet display.  Will not remove'
          + CRLF + 'Reminders which are locked at the Location level or higher.';
    btnAdd.hint := 'Adds Reminders to the Coversheet at the User Class level and'
          + CRLF + 'below.  It also removes the lock from a Reminder locked at the'
          + CRLF + 'User Class level while leaving the Reminder on the Coversheet.';
  end
  else if FEditingLevel = dlUser then
  begin
    btnRemove.hint := 'Removes Reminders from the Coversheet display.  Will not'
          + CRLF + 'remove Reminders which are locked at the User Class level'
          + CRLF + 'or higher.';
    btnAdd.hint := 'Adds Reminders to the Coversheet at the User level.';
  end
  else
  begin
    btnLock.hint := 'Adds Reminder to the Coversheet display and Locks the Reminder'
          + CRLF + 'so it can not be removed from the Coversheet display at any of'
          + CRLF + 'the lower levels (Division, Service, Location, User Class, User).';
    btnRemove.hint := 'Removes Reminders from the Coversheet display.';
    btnAdd.hint := 'Adds Reminders to the Coversheet at the System level and'
          + CRLF + 'below.  It also removes the lock from a Reminder locked at the'
          + CRLF + 'System level while leaving the Reminder on the Coversheet.';
  end;
end;

procedure TfrmRemCoverSheet.FormCreate(Sender: TObject);
begin
  FSavePause := Application.HintHidePause;   //Save Hint Pause setting
  Application.HintHidePause := 20000;   //Reset Hint Pause to 20 seconds
  mlgnLock.hint := 'Lock a Reminder to prevent it''s removal from a lower'
          + CRLF + 'level  Coversheet display.  For example, if you lock'
          + CRLF + 'a Reminder at the Service level, then that Reminder'
          + CRLF + 'can not be removed from the coversheet display at'
          + CRLF + 'the Location, User Class, or User levels.';
  fOldFocusChanged := Screen.OnActiveControlChange;
  Screen.OnActiveControlChange := ActiveControlChanged;
  if not WriteAccess(waReminderEditor) then
  begin
    btnOK.Enabled := false;
    btnApply.Enabled := false;
  end;
end;

procedure TfrmRemCoverSheet.ActiveControlChanged(Sender: TObject);
begin
  if assigned(fOldFocusChanged) then fOldFocusChanged(Sender);
  UpdateButtons;
end;

procedure TfrmRemCoverSheet.LockButtonUpdate(Data, FNAME, Hint: string);
begin
  btnLock.Caption := Data;
  btnLock.Glyph.LoadFromResourceName(hinstance, FNAME);
  if btnLock.Hint <> Hint then btnLock.Hint := Hint;
  if FNAME = 'BMP_LOCK' then btnLock.OnClick := btnLockClick
  else
    btnLock.OnClick := btnAddClick;
end;

end.
