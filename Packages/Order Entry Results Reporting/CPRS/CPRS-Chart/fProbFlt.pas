unit fProbflt;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, SysUtils, ORCtrls, ExtCtrls, uProbs, uConst, Dialogs, fBase508Form,
  VA508AccessibilityManager;

type
  TfrmPlVuFilt = class(TfrmBase508Form)
    pnlBase: TORAutoPanel;
    SrcLabel: TLabel;
    DstLabel: TLabel;
    lblProvider: TLabel;
    Bevel1: TBevel;
    OROffsetLabel1: TOROffsetLabel;
    cmdAdd: TButton;
    cmdRemove: TButton;
    cmdRemoveAll: TButton;
    cmdOK: TBitBtn;
    cmdCancel: TBitBtn;
    lstDest: TORListBox;
    rgVu: TRadioGroup;
    cboProvider: TORComboBox;
    cmdDefaultView: TBitBtn;
    cboSource: TORComboBox;
    cmdSave: TButton;
    chkComments: TCheckBox;
    cboStatus: TORComboBox;
    procedure cmdAddClick(Sender: TObject);
    procedure cmdRemoveClick(Sender: TObject);
    procedure cmdRemoveAllClick(Sender: TObject);
    procedure SetButtons;
    procedure rgVuClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cmdDefaultViewClick(Sender: TObject);
    procedure cboProviderNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure cboSourceNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure lstDestClick(Sender: TObject);
    procedure cboSourceChange(Sender: TObject);
    procedure cboSourceEnter(Sender: TObject);
    procedure cboSourceExit(Sender: TObject);
    procedure cmdSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FContextString: string;
    FFilterString: string;
    FFilterChanged: boolean;
    function CreateContextString: string;
    function CreateFilterString: string;
    procedure GetClinicList;
    procedure GetServiceList;
    procedure GetLocationList;
  end;

var
  frmPlVuFilt: TfrmPlVuFilt;

procedure GetViewFilters(FontSize: Integer; var PLFilters: TPLFilters; var ContextString, FilterString: string; var FilterChanged: boolean);

implementation

{$R *.DFM}
uses
 ORFn, fProbs, rProbs, rCore, uORLists, uSimilarNames;

procedure GetViewFilters(FontSize: Integer; var PLFilters: TPLFilters; var ContextString, FilterString: string; var FilterChanged: boolean);
var
  frmPlVuFilt: TfrmPLVuFilt;
  W, H: Integer;
begin
  frmPlVuFilt := TfrmPLVuFilt.create(Application);
  try
    with frmPlVuFilt do
    begin
      Font.Size := FontSize;
      W := ClientWidth;
      H := ClientHeight;
      ResizeToFont(FontSize, W, H);
      ClientWidth  := W; pnlBase.Width  := W;
      ClientHeight := H; pnlBase.Height := H;
      FContextString := ContextString;
      ShowModal;
      FilterChanged := FFilterChanged;
      ContextString := FContextString;
      FilterString  := FFilterString;
    end; {with frmPlVuFilt}
  finally
    frmPlVuFilt.Release;
  end;
end;

procedure TfrmPlVuFilt.FormCreate(Sender: TObject);
begin
  FastAssign(frmProblems.lstView.Items, cboStatus.Items);
  cboStatus.SelectByID(PLUser.usViewAct);
end;

procedure TfrmPlVuFilt.FormShow(Sender: TObject);
begin
    if PLUser.usCurrentView = PL_OP_VIEW then
      rgVu.itemindex := 0
    else if PLUser.usCurrentView = PL_IP_VIEW then
      rgVu.itemindex := 1
    else
      rgVu.itemindex := -1;  //2;
    rgVuClick(Self);
    cboSource.ItemIndex := -1;
    if PlUser.usViewProv = '0^All' then
      begin
        cboProvider.InitLongList('');
        cboProvider.ItemIndex := 0;
      end
    else
      begin
        cboProvider.InitLongList(Piece(PLUser.usViewProv, U, 2));
        cboProvider.SelectByID(Piece(PLUser.usViewProv, U, 1));
      end;
    TSimilarNames.RegORComboBox(cboProvider);
    chkComments.Checked := (PLUser.usViewComments = '1');
end;

procedure TfrmPlVuFilt.cmdAddClick(Sender: TObject);
var
  textindex: integer;
begin
  textindex := lstDest.Items.Count;
  if cboSource.ItemIndex > -1 then
    if lstDest.SelectById(cboSource.ItemID) = -1 then
      lstDest.Items.Add(cboSource.Items[cboSource.ItemIndex]);
  lstDest.ItemIndex := textindex;
  SetButtons;
end;

procedure TfrmPlVuFilt.cmdRemoveClick(Sender: TObject);
var
  newindex: integer;
begin
  if lstDest.Items.Count > 0 then
  begin
    if lstDest.ItemIndex = (lstDest.Items.Count -1 ) then
      newindex := lstDest.ItemIndex - 1
    else
      newindex := lstDest.ItemIndex;
    lstDest.Items.Delete(lstDest.ItemIndex);
    if lstDest.Items.Count > 0 then lstDest.ItemIndex := newindex;
  end;
  SetButtons;
end;

procedure TfrmPlVuFilt.cmdRemoveAllClick(Sender: TObject);
begin
  lstDest.Clear;
  SetButtons;
end;

procedure TfrmPlVuFilt.SetButtons;
var
  SrcEmpty, DstEmpty: Boolean;
begin
  SrcEmpty := cboSource.Items.Count = 0;
  DstEmpty := lstDest.Items.Count = 0;
  cmdAdd.Enabled := (not SrcEmpty) and (cboSource.ItemIndex > -1) ;
  cmdRemove.Enabled := not DstEmpty;
  cmdRemoveAll.Enabled := not DstEmpty;
end;

procedure TfrmPlVuFilt.rgVuClick(Sender: TObject);
var
  aDest,
  AList: TStringList;
  i: Integer;
begin
  AList := TStringList.create;
  aDest := TStringList.create;
  try
    cboSource.Clear;
    lstDest.Clear;
    cboSource.Enabled := true;
    lstDest.Enabled := true;
    cboSource.color := clWindow;
    lstDest.color := clWindow;
    case rgVu.itemindex of
      0: { out patient view }
        begin
          GetClinicList;
          GetListForOP(AList, frmProblems.wgProbData);
          ClinicFilterList(aDest,AList);
          FastAssign(aDest, cboSource.Items);
          cboSource.InsertSeparator;
          cboSource.InitLongList('');
          for i := 0 to PLFilters.ClinicList.Count - 1 do
          begin
            cboSource.SelectByID(PLFilters.ClinicList[i]);
            cmdAddClick(Self);
          end;
        end;
      1: { in-patient View }
        begin
          GetServiceList;
          GetListForIP(AList, frmProblems.wgProbData);
          ServiceFilterList(aDest,AList);
          FastAssign(aDest, cboSource.Items);
          cboSource.InsertSeparator;
          cboSource.InitLongList('');
          for i := 0 to PLFilters.ServiceList.Count - 1 do
          begin
            cboSource.SelectByID(PLFilters.ServiceList[i]);
            cmdAddClick(Self);
          end;
        end;
    else { unfiltered view }
      GetLocationList;
    end;
    SetButtons;
  finally
    AList.Free;
    aDest.Free;
  end;
end;

procedure TfrmPlVuFilt.lstDestClick(Sender: TObject);
begin
  SetButtons ;
end;

procedure TfrmPlVuFilt.cboSourceChange(Sender: TObject);
begin
  SetButtons ;
end;

procedure TfrmPlVuFilt.cboSourceEnter(Sender: TObject);
begin
  cmdAdd.Default := true;
end;

procedure TfrmPlVuFilt.cboSourceExit(Sender: TObject);
begin
  cmdAdd.Default := false;
end;

procedure TfrmPlVuFilt.cmdCancelClick(Sender: TObject);
begin
  FFilterChanged := False;
  close;
end;

procedure TfrmPlVuFilt.cmdOKClick(Sender: TObject);
var
  Alist:TstringList;
  ErrMsg: string;

  procedure SetVu(vulist:TstringList; vu:string);
    var
      alist:TstringList;
    begin
      alist:=TStringList.create;
    try
      vuList.clear;
      if lstDest.Items.Count=0 then
        begin
          AList.Clear;
          AList.Add('0');
        end
      else
        FastAssign(lstDest.Items, alist); {conserve only selected items}
      LoadFilterList(Alist,VuList);
      PLUser.usCurrentView:=vu;
    finally
      alist.free;
    end;
  end;

begin {BODY of procedure}
  if not CheckForSimilarName(cboProvider, ErrMsg, sPr) then
  begin
    ShowMsgOn(ErrMsg <> '', ErrMsg, 'Problem List Fileter Error');
    cboProvider.SelectByIen(0);
    Exit;
  end;

  Alist:=TStringList.create;
  try
     PlFilters.ProviderList.clear;
     if (uppercase(cboProvider.text)='ALL') or (cboProvider.Text='') then
      begin
        Alist.clear;
        AList.Add('0');
        PLUser.usViewProv := '0^All';
        AList.Add('-1');
        LoadFilterList(Alist,PLFilters.ProviderList);
      end
     else
      begin
       AList.clear;
       Alist.add(IntToStr(cboProvider.ItemIEN));
       PLUser.usViewProv := cboProvider.Items[cboProvider.ItemIndex];
       LoadFilterList(Alist, PLFilters.ProviderList);
      end;
     case rgVu.itemindex of
      0: SetVu(PLFilters.clinicList, PL_OP_VIEW); {OP view}
      1: SetVu(PLFilters.ServiceList, PL_IP_VIEW); {IP view}
     else
         SetVu(PLFilters.clinicList, PL_UF_VIEW);
      end;
     //ShowFilterStatus(PLUser.usCurrentView);
     //PostMessage(frmProblems.Handle, UM_PLFILTER, 0, 0);
     FContextString := CreateContextString;
     FFilterString  := CreateFilterString;
     FFilterChanged := True;
     close;
  finally
     alist.free;
  end;
end;

procedure TfrmPlVuFilt.cmdDefaultViewClick(Sender: TObject);
{var
 Alist:TStringList;
 i: integer;
 tmpProv: Int64;}
begin
{  Alist:=TStringList.create;
  try
    lstDest.Clear;
    PlUser.usCurrentView:=PLUser.usDefaultView;
    tmpProv := StrToInt64Def(Piece(PLUser.usDefaultContext, ';', 5), 0);
    if tmpProv > 0 then
      PLUser.usViewProv := IntToStr(tmpProv) + ExternalName(tmpProv, 200);
    with cboStatus do
      begin
        for i := 0 to Items.Count - 1 do
          if Copy(Items[i], 1, 1) = Piece(PLUser.usDefaultContext, ';', 3) then
            ItemIndex := i;
      end;
    chkComments.Checked := (Piece(PLUser.usDefaultContext, ';', 4) = '1');
    PLFilters.ProviderList.Clear;
    PLFilters.ProviderList.Add(Piece(PLUser.usViewProv, U, 1));
    FastAssign(plUser.usClinList, PLFilters.ClinicList);
    FastAssign(plUser.usServList, PlFilters.ServiceList);
    cboProvider.InitLongList(Piece(PLUser.usViewProv, U, 2));
    cboProvider.SelectByID(Piece(PLUser.usViewProv, U, 1));
    //InitViewFilters(Alist);
  finally
    Alist.free;
  end;
  //FormShow(Self);
  FContextString := PLUser.usDefaultContext;
  FFilterChanged := True;
  Close;
  //ModalResult := mrOK ; }
end;

procedure TfrmPlVuFilt.GetClinicList;
begin
  PLFilters.ServiceList.clear;
  SrcLabel.caption:='Source Clinic(s)';
  DstLabel.caption:='Selected Clinic(s)';
  cboSource.Caption := 'Source Clinics';
  lstDest.Caption := 'Selected Clinic or Clinics';
  lstDest.Clear;
  SetButtons ;
end;

procedure TfrmPlVuFilt.GetServiceList;
begin
 PLFilters.ClinicList.clear;
 SrcLabel.caption:='Source Service(s)';
 DstLabel.caption:='Selected Service(s)';
 cboSource.Caption := 'Source Services';
 lstDest.Caption := 'Selected Service or Services';
 lstDest.Clear;
 SetButtons ;
end;

procedure TfrmPlVuFilt.GetLocationList;
begin
 cboSource.Clear;
 lstDest.Clear;
 PLFilters.ClinicList.clear;
 PLFilters.ServiceList.clear;
 SrcLabel.caption:='All Locations/Services';
 DstLabel.caption:='Selected Locations/Services';
 cboSource.Caption := 'All Locations/Services';
 lstDest.Caption := 'Selected Locations/Services';
 cboSource.color:=clBtnFace;
 cboSource.enabled:=false;
 lstDest.color:=clBtnFace;
 lstDest.enabled:=false;
end;

procedure TfrmPlVuFilt.cboProviderNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
var
  sl: TStrings;
begin
  sl := TStringList.create;
  try
    setSubSetOfActiveAndInactivePersons(cboProvider, sl, StartFrom, Direction);
    cboProvider.ForDataUse(sl);
  finally
    sl.Free;
  end;
  cboProvider.Items.insert(0, '0^All');
end;

procedure TfrmPlVuFilt.cboSourceNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
var
  sl:TSTrings;
begin
  sl := TSTringList.Create;
  try
 case rgVu.itemindex of
  0:  {out patient view} setClinicList(cboSource, StartFrom,Direction);
//  1:  {in-patient View}  cboSource.ForDataUse(ServiceSearch(StartFrom,Direction));
  1:  {in-patient View}
    begin
      ServiceSearch(sl,StartFrom,Direction);
      cboSource.ForDataUse(sl);
    end;
 else {unfiltered view}  GetLocationList;
 end;
  finally
    sl.Free;
  end;
end;

function TfrmPlVuFilt.CreateContextString: string;
var
  Status, Comments, Provider: string;
begin
  if cboStatus.ItemIndex > -1 then
    Status := cboStatus.ItemID
  else
    Status := 'A';
  Comments := BOOLCHAR[chkComments.Checked];
  if cboProvider.ItemIEN > 0 then Provider := cboProvider.ItemID else Provider := '';
  Result := ';;' + Status + ';' + Comments + ';' + Provider;
end;

function TfrmPlVuFilt.CreateFilterString: string;
var
  FilterString: string;
  i: integer;
begin
  case rgVu.ItemIndex of
    0:  FilterString := PL_OP_VIEW + '/';
    1:  FilterString := PL_IP_VIEW + '/';
  else  FilterString := '';
  end;
  if rgVu.ItemIndex <> -1 then
    for i := 0 to lstDest.Items.Count - 1 do
      if Piece(lstDest.Items[i], U, 1) <> '-1' then
        FilterString := FilterString + Piece(lstDest.Items[i], U, 1) + '/';
  Result := FilterString;
end;

procedure TfrmPlVuFilt.cmdSaveClick(Sender: TObject);
begin
  {FContextString := CreateContextString;
  FFilterString  := CreateFilterString;
  if InfoBox('Replace current defaults?','Confirmation', MB_YESNO or MB_ICONQUESTION) = IDYES then
    begin
      with PLUser do
        begin
          usDefaultContext := FContextString;
          usDefaultView    := Piece(FFilterString, '/', 1);
        end;
      SaveViewPreferences(FFilterString + U + FContextString);
    end;       }
end;

end.
