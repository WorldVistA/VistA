unit mEvntDelay;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ORCtrls, ORDtTm, uCore, ORFn, ExtCtrls,UConst;

type
  TfraEvntDelayList = class(TFrame)
    pnlDate: TPanel;
    pnlList: TPanel;
    mlstEvents: TORListBox;
    edtSearch: TCaptionEdit;
    lblEffective: TLabel;
    orDateBox: TORDateBox;
    lblEvntDelayList: TLabel;
    procedure edtSearchChange(Sender: TObject);
    procedure mlstEventsChange(Sender: TObject);
    procedure mlstEventsClick(Sender: TObject);
    procedure mlstEventsKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FEvntLimit:       Char;
    FUserDefaultEvent:integer;
    FDefaultEvent:    integer;
    FMatchedCancel:   Boolean;
    FDisableWarning:  Boolean;
    FIsForCpXfer:     Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    procedure ResetProperty;
    procedure DisplayEvntDelayList;
    procedure CheckMatch;
    property EvntLimit:        Char     read FEvntLimit         write FEvntLimit;
    property UserDefaultEvent: integer  read FUserDefaultEvent  write FUserDefaultEvent;
    property DefaultEvent    : integer  read FDefaultEvent      write FDefaultEvent;
    property MatchedCancel   : Boolean  read FMatchedCancel     write FMatchedCancel;
    property DisableWarning  : Boolean  read FDisableWarning    write FDisableWarning;
    property IsForCpXfer     : Boolean  read FIsForCpXfer       write FIsForCpXfer;
  end;

implementation

{$R *.DFM}

uses
  rOrders, fOrders, fOrdersTS, fMedCopy, fOrdersCopy, VA508AccessibilityRouter;

{ TfraEvntDelayList }
const
  TX_MCHEVT1  = ' is already assigned to ';
  TX_MCHEVT2  = #13 + 'Do you still want to write delayed orders?';
  TX_MCHEVT3  = #13#13 + 'If you continue to write delayed orders to this event,'
    + 'they will not release until the patient moves away from and returns to this ward and treating specialty.'
    + #13#13 + 'If you want these orders to be activated at signature, '
    + 'then please write them under the ACTIVE view (and not as delayed orders).';
  TX_XISTEVT1 = 'Delayed orders already exist for event Delayed ';
  TX_XISTEVT2 = #13 + 'Do you want to view those orders?';

constructor TfraEvntDelayList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  TabStop := FALSE;
  FDisableWarning   := False;
  FMatchedCancel    := False;
  FIsForCpXfer      := False;
  FEvntLimit        := #0;
  FUserDefaultEvent := 0;
  FDefaultEvent     := 0;
end;

procedure TfraEvntDelayList.DisplayEvntDelayList;
var
  i: integer;
  tempStr: string;
  defaultEvtType: Char;
  NoUserDefault: boolean;
const
  LINE = '^^^^^^^^________________________________________________________________________________________';

begin
  inherited;
  mlstEvents.Items.Clear;
  mlstEvents.InitLongList('');
  NoUserDefault := False;
  defaultEvtType := #0;

  if Patient.Inpatient then
    ListSpecialtiesED(EvntLimit,mlstEvents.Items)
  else
    ListSpecialtiesED('A',mlstEvents.Items);
  if mlstEvents.Items.Count < 1 then
    Exit;
  mlstEvents.ItemIndex := -1;
  if not Patient.Inpatient then
  begin
    if UserDefaultEvent > 0 then
      defaultEvtType := CharAt(EventInfo1(IntToStr(UserDefaultEvent)),1);
      if CharInSet(defaultEvtType, ['T','D']) then
        NoUserDefault := True;
  end;
  if (UserDefaultEvent > 0) and (not NoUserDefault) then
  begin
    for i := 0 to mlstEvents.Items.Count - 1 do
    begin
      if Piece(mlstEvents.Items[i],'^',1)=IntToStr(UserDefaultEvent) then
      begin
        tempStr := mlstEvents.Items[i];
        Break;
      end;
    end;
  end;
  if Length(tempStr)>0 then
  begin
    DisableWarning := True;
    mlstEvents.Items.Insert(0,tempStr);
    mlstEvents.Items.Insert(1,LINE);
    mlstEvents.Items.Insert(2,LLS_SPACE);
    mlstEvents.ItemIndex := 0;
    edtSearch.Text := mlstEvents.DisplayText[0];
    tempStr := '';
    DisableWarning := False;
  end;

  if (DefaultEvent > 0) and (mlstEvents.ItemIndex<0) then
  begin
    for i := 0 to mlstEvents.items.Count - 1 do
    begin
      if Piece(mlstEvents.items[i],'^',1)=IntToStr(DefaultEvent) then
      begin
        tempStr := mlstEvents.Items[i];
        Break;
      end;
    end;
  end;
  if Length(tempStr)>0 then
  begin
    mlstEvents.Items.Insert(0,tempStr);
    mlstEvents.Items.Insert(1,LINE);
    mlstEvents.Items.Insert(2,LLS_SPACE);
    mlstEvents.ItemIndex := 0;
    edtSearch.Text := mlstEvents.DisplayText[0];
    tempStr := '';
  end;
end;

procedure TfraEvntDelayList.ResetProperty;
begin
  FEvntLimit        := #0;
  FUserDefaultEvent := 0;
  FDefaultEvent     := 0;
  FMatchedCancel    := False;
  FDisableWarning   := False;
  FIsForCpXfer      := False;
end;

procedure TfraEvntDelayList.CheckMatch;
var
  AnEvtID, ATsName: string;
begin
  if mlstEvents.ItemIndex < 0 then Exit;
  FMatchedCancel := False;
  AnEvtID   := Piece(mlstEvents.Items[mlstEvents.ItemIndex],'^',1);
  if isMatchedEvent(Patient.DFN,AnEvtID,ATsName) and (not DisableWarning) then
  begin
    if InfoBox(Patient.Name + TX_MCHEVT1 + ATsName + ' on ' + Encounter.LocationName + TX_MCHEVT2,
      'Warning', MB_OKCANCEL or MB_ICONWARNING) = IDCANCEL then
    begin
      FMatchedCancel := True;
      frmOrders.lstSheets.ItemIndex := 0;
      frmOrders.lstSheetsClick(Self);
    end;
  end;
end;

procedure TfraEvntDelayList.edtSearchChange(Sender: TObject);
var
  i: integer;
  needle,hay: String;
begin
  if Length(edtSearch.Text)<1 then Exit;
  if (edtSearch.Modified) then
    begin
      needle := UpperCase(edtSearch.text);
      if length(needle)=0 then exit;
      for i := 0 to mlstEvents.Items.Count - 1 do
        begin
          hay := UpperCase(mlstEvents.DisplayText[i]);
          hay := Copy(hay,0,length(needle));
          if Pos(needle, hay) > 0 then
            begin
              mlstEvents.ItemIndex := i;
              mlstEvents.TopIndex := i;
              edtSearch.Text := mlstEvents.DisplayText[mlstEvents.itemindex];
              edtSearch.SelStart := length(needle);
              edtSearch.SelLength := length(edtSearch.Text);
              exit;
            end;
        end;
    end;
end;

procedure TfraEvntDelayList.mlstEventsChange(Sender: TObject);
var
  i,idx : integer;
  AnEvtID, AnEvtType, APtEvtID: string;
  AnEvtName,ATsName: string;
begin
  inherited;
  if mlstEvents.ItemIndex >= 0 then
  begin
    AnEvtID   := Piece(mlstEvents.Items[mlstEvents.ItemIndex],'^',1);
    AnEvtType := Piece(mlstEvents.Items[mlstEvents.ItemIndex],'^',3);
    idx := mlstEvents.ItemIndex;
  end else
  begin
    AnEvtID   := '';
    AnEvtType := '';
    idx := -1;
  end;
  if AnEvtType = 'D' then
  begin
    pnlDate.Visible := True;
    lblEffective.Left := 1;
    orDateBox.Left := 1;
    orDateBox.Hint  := orDateBox.Text;
  end else
    pnlDate.Visible := False;
  if mlstEvents.ItemIndex >= 0 then
    AnEvtName := Piece(mlstEvents.Items[mlstEvents.ItemIndex],'^',9)
  else
    AnEvtName := '';
  if isExistedEvent(Patient.DFN, AnEvtID, APtEvtID) then
  begin
    if IsForCpXfer then
      DisableWarning := True;
    for i := 0 to frmOrders.lstSheets.Items.Count - 1 do
    begin
      if Piece(frmOrders.lstSheets.Items[i],'^',1)=APtEvtID then
      begin
        frmOrders.lstSheets.ItemIndex := i;
        frmOrders.ClickLstSheet;
      end;
    end;
    IsForCpXfer := False;
  end;
  if (StrToIntDef(AnEvtID,0)>0) and (isMatchedEvent(Patient.DFN,AnEvtID,ATsName))
     and (not DisableWarning) then
  begin
    if InfoBox(Patient.Name + TX_MCHEVT1 + ATsName + ' on ' + Encounter.LocationName + TX_MCHEVT2 + TX_MCHEVT3,
      'Warning', MB_OKCANCEL or MB_ICONWARNING) = IDCANCEL then
   begin
     FMatchedCancel := True;
     frmOrders.lstSheets.ItemIndex := 0;
     frmOrders.lstSheetsClick(Self);
   end else
   begin
      if Screen.ActiveForm.Name = 'frmOrdersTS' then
        SendMessage(frmOrdersTS.Handle, UM_STILLDELAY, 0, 0);
      if Screen.ActiveForm.Name = 'frmMedCopy' then
        SendMessage(frmMedCopy.Handle, UM_STILLDELAY, 0, 0);
      if Screen.ActiveForm.Name = 'frmCopyOrders' then
        SendMessage(frmCopyOrders.Handle, UM_STILLDELAY, 0, 0);
   end;
  end;
  mlstEvents.ItemIndex := idx;
end;

procedure TfraEvntDelayList.mlstEventsClick(Sender: TObject);
begin
  edtSearch.Text := mlstEvents.DisplayText[mlstEvents.ItemIndex];
end;

procedure TfraEvntDelayList.mlstEventsKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (mlstEvents.ItemIndex <> mlstEvents.FocusIndex) and (mlstEvents.FocusIndex > -1)  then
  begin
    if (Key = VK_UP) and ( ( mlstEvents.ItemIndex - mlstEvents.FocusIndex) > 1) and (mlstEvents.ItemIndex > 0) then
      mlstEvents.ItemIndex := mlstEvents.ItemIndex - 1;
    if (Key = VK_DOWN) and (mlstEvents.FocusIndex < mlstEvents.ItemIndex) then
      mlstEvents.ItemIndex := mlstEvents.ItemIndex + 1
    else
      mlstEvents.ItemIndex := mlstEvents.FocusIndex;
    edtSearch.text := mlstEvents.DisplayText[mlstEvents.ItemIndex];
    mlstEvents.TopIndex := mlstEvents.ItemIndex;
  end;
end;

procedure TfraEvntDelayList.edtSearchKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  x : string;
  i : integer;
begin
  if Key in [VK_PRIOR, VK_NEXT, VK_UP, VK_DOWN] then
  begin
    edtSearch.SelectAll;
    Key := 0;
  end
  else if Key = VK_BACK then
  begin
    x := edtSearch.Text;
    i := edtSearch.SelStart;
    if i > 1 then Delete(x, i + 1, Length(x)) else x := '';
    edtSearch.Text := x;
    if i > 1 then edtSearch.SelStart := i;
  end
end;

initialization
  SpecifyFormIsNotADialog(TfraEvntDelayList);

end.
