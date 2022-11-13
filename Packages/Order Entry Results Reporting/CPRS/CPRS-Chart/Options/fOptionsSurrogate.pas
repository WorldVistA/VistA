unit fOptionsSurrogate;
{
  Surrogate Management Functionality within CPRS Graphical User Interface (GUI)
  (Request #20071216)
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ORCtrls, ORDtTmRng, ORFn, ExtCtrls, fBase508Form,
  VA508AccessibilityManager, Vcl.ComCtrls, Vcl.Menus;

type
  TIDItem = class(TCollectionItem)
  private
  public
    IDString: String;
    Caption, PublicName: String;
    Comments: String;
    dateFrom, dateUntil: TDateTime;
    function strFrom: String;
    function strUntil: String;
    class function DateToRawStr(ADate: TDateTime): string;
    class function DateToStr(ADate: TDateTime; Format: string = ''): string;
    function toRawString: String;
    procedure setListItem(anItem: TListItem);
    function getInfo: String;
    function getInfoDebug: String;
    function IsOpen: Boolean;
  end;

  TfrmOptionsSurrogate = class(TfrmBase508Form)
    clvSurrogates: TCaptionListView;
    pnlParams: TPanel;
    pnlSurrogateTools: TPanel;
    pnlUpdateIndicator: TPanel;
    stxtChanged: TVA508StaticText;
    pnlInfo: TPanel;
    pnlToolBar: TPanel;
    btnSurrEdit: TButton;
    btnRemove: TButton;
    cbUseDefaultDates: TCheckBox;
    edDefaultPeriod: TEdit;
    pnlDebug: TPanel;
    txtRemove: TVA508StaticText;
    txtDefaultPeriod: TVA508StaticText;
    txtSurrEdit: TVA508StaticText;
    lblDefaultPeriod: TLabel;
    lblInfo: TLabel;
    procedure btnRemoveClick(Sender: TObject);
    procedure clvSurrogatesCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure clvSurrogatesCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure clvSurrogatesChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure btnSurrEditClick(Sender: TObject);
    procedure clvSurrogatesDblClick(Sender: TObject);
    procedure clvSurrogatesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure clvSurrogatesMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbUseDefaultDatesClick(Sender: TObject);
    procedure edDefaultPeriodKeyPress(Sender: TObject; var Key: Char);
    procedure edDefaultPeriodChange(Sender: TObject);
    procedure edDefaultPeriodExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    fIDCollection: TCollection;
    fRawParams, fRawServerData: String;
    fOrigParams: String;
    fIgnore, fSurrogateUpdated: Boolean;
    FOnChange: TNotifyEvent;
    procedure LoadServerData;
    procedure LoadListViewByStringList(aList: TStringList);
    procedure setRangeInfo;
    procedure clearRanges;
    procedure FixEndDates;
    procedure mergeItems;
    procedure reNumItems;
    procedure ParseServerRecord(aValue: String;
      var sData, sName, sFrom, sUntil: String);
    function IsOpen(anItem: Integer): Boolean;
    function ListViewToRaw: String;
    procedure setSurrogateUpdated(aValue: Boolean);
    procedure setByCurrentItem;
    function ServerDeleteAll: String;
    function ServerSaveAll: String;
    function getItemID(anItem: Integer): String;
    Procedure CheckSurrogateUpdated;
    procedure Init508;
    procedure Update508;
  public
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property SurrogateUpdated: Boolean read fSurrogateUpdated
      write setSurrogateUpdated;
    function ApplyChanges: Boolean;
    function CanChangeTabs: Boolean;
    procedure UpdateWithServerData;
    procedure RefreshList;
    procedure RefreshParams;
  end;

function StrDateToDate(aDate: String): TDateTime;

const
  fmtListDateTime = 'mm/dd/yyyy@hh:nn'; // date/time format used in the table
  fmtListDateTimeSec = 'mm/dd/yyyy@hh:nn:ss';

implementation

uses rOptions, uOptions, rCore, fSurrogateEdit, System.UITypes, fOptions,
  uConst, ORDtTm, System.Math,
  VAUtils, UCaptionListView508Manager,
  System.DateUtils;

{$R *.DFM}

const
  csNeverLoaded = '......';

  ciOpen = '...'; // indicator of the period available for assignment
  ciUnknownName = 'Dbl-click here to add surrogate';
  // SDS V32 Defect 101 4/4/2017
  ciActive = 'Active'; // indicator of currently active surrogate

  // maxSurrPeriod = 365.25 * 4; // max assignment period is four years // VISTAOR-24006
  dtGap = 0.0; // required gap between surrogate assignments
  msgSurrogateRemove = 'Remove Surrogate?';
  msgSurrogateChangesSinceLastLoad =
    'Surrogate settings were changed since the last request' + CRLF +
    'Please review the current settings prior to saving the updates';

  MAX_PERIOD = 30;
  DEFAULT_PERIOD = 7;
  NO_DEFAULT_INPUT = '0';
  DEFAULT_INPUT = '1';

  /// /////////////////////////////////////////////////////////////////////////////

function StrDateToDate(aDate: String): TDateTime;
var
  dtDate, dtTime: Real;
  sDate, sTime: String;
begin
  if Trim(aDate) = '' then begin
    Result := 0;
  end else begin
    // expected format: 'mm/dd/yyyy@hh:nn';  Sample user edit: 04/17/2017@2100
    sDate := piece(aDate, '@', 1);
    sTime := piece(aDate, '@', 2);
    dtDate := strToDate(sDate);
    dtTime := strToTime(sTime);
    Result := dtDate + dtTime;
  end;
end;

/// /////////////////////////////////////////////////////////////////////////////
function newTIDItem(aCollection: TCollection;
  anID, aCaption, aName, aComment: String; aFrom, aUntil: TDateTime): TIDItem;
begin
  Result := TIDItem.Create(aCollection);
  Result.IDString := anID;
  Result.Caption := aCaption;
  Result.PublicName := aName;
  Result.Comments := aComment;
  Result.dateFrom := aFrom;
  Result.dateUntil := aUntil;
end;

/// /////////////////////////////////////////////////////////////////////////////
class function TIDItem.DateToRawStr(ADate: TDateTime): string;
begin
  if ADate <= 0 then Result := ''
  else Result := FloatToStr(DateTimeToFMDateTime(ADate));
end;

class function TIDItem.DateToStr(ADate: TDateTime; Format: string = ''): string;
begin
  if Format = '' then Format := fmtListDateTime;
  if ADate <= 0 then Result := ''
  else Result := FormatDateTime(Format, ADate);
end;

function TIDItem.toRawString: String;
begin
  Result := IDString + U + DateToRawStr(dateFrom) + U + DateToRawStr(dateUntil);
end;

function TIDItem.getInfo: String;
begin
  Result := PublicName + '  ' + DateToStr(dateFrom) +
    ' .. ' + DateToStr(dateUntil);
end;

function TIDItem.getInfoDebug: String;
begin
  Result := IDString + '  ' + Caption + '  ' + PublicName + '  ' +
    DateToStr(dateFrom, fmtListDateTimeSec) + ' .. ' +
    DateToStr(dateUntil, fmtListDateTimeSec) + '  ' + Comments;
end;

function TIDItem.strFrom: String;
begin
  Result := DateToStr(dateFrom);
end;

function TIDItem.strUntil: String;
begin
  Result := DateToStr(dateUntil);
end;

function TIDItem.IsOpen: Boolean;
// Is the IDItem a surrogate (False) or an open period (True)
begin
  Result := PublicName = ciUnknownName;
end;

procedure TIDItem.setListItem(anItem: TListItem);
begin
  if Assigned(anItem) then
  begin
    while anItem.SubItems.Count < 4 do
      anItem.SubItems.Add('');
    anItem.Caption := Caption;
    anItem.SubItems[0] := PublicName;
    anItem.SubItems[1] := DateToStr(dateFrom);
    anItem.SubItems[2] := DateToStr(dateUntil);
    anItem.SubItems[3] := Comments;
    anItem.Data := Self;
  end;
end;

/// /////////////////////////////////////////////////////////////////////////////
procedure TfrmOptionsSurrogate.FormCreate(Sender: TObject);
begin
  inherited;
  fIDCollection := TCollection.Create(TIDItem);
//  pnlDebug.Visible := True;
  fRawServerData := csNeverLoaded;
  fRawParams := csNeverLoaded;

  UpdateWithServerData;
  Init508;
end;

procedure TfrmOptionsSurrogate.FormDestroy(Sender: TObject);
begin
  fIDCollection.Free;
  inherited;
end;

procedure TfrmOptionsSurrogate.FormShow(Sender: TObject);
begin
  inherited;
  Update508;
end;

procedure TfrmOptionsSurrogate.RefreshList;
begin
  clearRanges;
  FixEndDates;
  setRangeInfo;
  mergeItems;
  reNumItems;
  if clvSurrogates.Items.Count = 1 then
    clvSurrogates.ItemIndex := 0;
  setByCurrentItem;
end;

procedure TfrmOptionsSurrogate.RefreshParams;
begin
  cbUseDefaultDates.Checked := piece(fRawParams, '^', 1) = DEFAULT_INPUT;
  edDefaultPeriod.Text := piece(fRawParams, '^', 2); // This triggers edDefaultPeriodChange, which sets fRawParams
  CheckSurrogateUpdated;
  Update508;
end;

procedure TfrmOptionsSurrogate.UpdateWithServerData;
begin
  LoadServerData;
  RefreshList;

  rpcGetSurrogateParams(fRawParams);
  fOrigParams := fRawParams;
  RefreshParams;
end;

function TfrmOptionsSurrogate.CanChangeTabs : Boolean;
begin
  Result := True;
  if cbUseDefaultDates.Checked then
  begin
    if edDefaultPeriod.Text = '' then
    begin
      if edDefaultPeriod.Enabled then
        edDefaultPeriod.SetFocus;
      Result := False;
      Exit;
    end else begin
      if SurrogateUpdated then Exit;
    end;
  end;
end;

procedure TfrmOptionsSurrogate.Init508;
begin
  stxtChanged.TabStop := ScreenReaderActive;
  if ScreenReaderActive then
  begin
    TCaptionListView508Manager.Create(amgrMain, clvSurrogates);
  end;
  Update508;
end;

procedure TfrmOptionsSurrogate.Update508;
begin
  txtSurrEdit.Visible := ScreenReaderActive and (not btnSurrEdit.Enabled);
  txtRemove.Visible := ScreenReaderActive and (not btnRemove.Enabled);
  txtDefaultPeriod.Visible := ScreenReaderActive and (not edDefaultPeriod.Enabled);
end;

function TfrmOptionsSurrogate.IsOpen(anItem: Integer): Boolean;
begin
  if assigned(clvSurrogates.Items[anItem].Data) then
    Result := TIDItem(clvSurrogates.Items[anItem].Data)
      .PublicName = ciUnknownName
  else
    Result := True;
end;

procedure TfrmOptionsSurrogate.btnSurrEditClick(Sender: TObject);
var
  srvNow, AStopDate: TDateTime;
  IDItemNext, IDItemPrev, IDItem: TIDItem;
  i, iPeriod: LongInt;
  IsLastRecord: Boolean;
  sDataOld, sData, sSurrogate, sStart, sStop, sMin, sMax: String;
begin
  inherited;
  if not cbUseDefaultDates.Checked then begin
    defaultSurrPeriod := 7; // Startup value
  end else begin
    iPeriod := StrToIntDef(edDefaultPeriod.Text, 0);
    if (iPeriod < 1) or (iPeriod > 30) then
    begin
      defaultSurrPeriod := 7; // Startup value
      InfoBox('Incorrect value for default Period: ' + CRLF + CRLF + Char(VK_Tab)
        + '"' + edDefaultPeriod.Text + '"' + CRLF + CRLF +
          'Enter an integer value between 1 and 30 and try again ', 'Error',
        MB_ICONERROR or MB_OK);
        Exit;
    end else begin
      defaultSurrPeriod := iPeriod;
    end;
  end;

  if clvSurrogates.Items.Count < 1 then begin
    raise Exception.Create('Surrogates list should not be blank... ');
  end else begin
    IDItemPrev := nil;
    IDItemNext := nil;
    sSurrogate := '';

    I := clvSurrogates.ItemIndex;
    if I < 0 then begin
      if (clvSurrogates.Items.Count > 0) then begin
        I := 0; // Select the first record
      end else begin
        raise Exception.Create('clvSurrogates.Items.Count = 0'); // a situation that should not happen
      end;
    end;
    IsLastRecord := I = clvSurrogates.Items.Count - 1;

    IDItem := TIDItem(clvSurrogates.Items[I].Data);
    if not assigned(IDItem) then raise Exception.Create('No item to process...');

    if (IDItem.dateFrom < Now) and (IDItem.dateUntil < Now) and (IDItem.dateUntil > 0) then
    begin
      MessageDlg('The surrogate period you are trying to edit is in the past'#13#10+
        'Please select another period.',
        mtInformation, [mbOK], 0);
      Exit;
    end;

    if I > 0 then IDItemPrev := TIDItem(clvSurrogates.Items[I - 1].Data);
    if not IsLastRecord then IDItemNext := TIDItem(clvSurrogates.Items[I + 1].Data);

    if Assigned(IDItemPrev) and (IDItemPrev.IsOpen or (IDItemPrev.dateUntil <= 0)) then begin
      sMin := IDItemPrev.strFrom; // Minimum selectable date of the surrogate
    end else begin
      sMin := IDItem.strFrom;
    end;
    srvNow := FMDateTimeToDateTime(ServerFMNow);
    if StrDateToDate(sMin) < srvNow then sMin := TIDItem.DateToStr(srvNow);

    if not IDItem.IsOpen then begin
      sStart := TIDItem.DateToStr(Max(StrDateToDate(sMin), StrDateToDate(IDItem.strFrom))); // Start Date of the surrogate
      sStop := IDItem.strUntil; // Stop Date of the surrogate
      sSurrogate := IDItem.PublicName;
    end else begin
      sStart := '';
      sStop := '';
    end;

    if Assigned(IDItemNext) and IDItemNext.IsOpen then
    begin
      sMax := IDItemNext.strUntil
    end else begin
      sMax := IDItem.strUntil;
    end;

    sData := getItemID(I);
    sDataOld := sData;

    if editSurrogate(sSurrogate, sStart, sStop, sMin, sMax, sData, IsLastRecord,
      cbUseDefaultDates.Checked) = mrOK then
    begin
{$IFDEF DEBUG}
      ShowMessage('Edit Surrogate Results: ' + CRLF + CRLF + 'Name: ' +
        sSurrogate + '(' + sData + ')' + CRLF + 'Start: ' + sStart + CRLF +
        'Stop: ' + sStop + CRLF);
{$ENDIF}

      if sStop = '' then AStopDate := 0 else AStopDate := StrDateToDate(sStop);
      if sDataOld <> sData then
      begin
        IDItem := newTIDItem(fIDCollection, sData, '', sSurrogate, '',
          StrDateToDate(sStart), AStopDate);
      end
      else
      begin
        IDItem.IDString := sData;
        IDItem.PublicName := sSurrogate;
        IDItem.dateFrom := StrDateToDate(sStart);
        IDItem.dateUntil := AStopDate;
      end;

      IDItem.setListItem(clvSurrogates.Items[i]);

      RefreshList;
      CheckSurrogateUpdated;
    end;
  end;
end;

procedure TfrmOptionsSurrogate.btnRemoveClick(Sender: TObject);
var
  i: Integer;
  sMsg: String;
begin
  i := clvSurrogates.ItemIndex;
  if i < 0 then
    exit;
  if not assigned(clvSurrogates.Items[clvSurrogates.ItemIndex].Data) then
    ShowMessage('Item should have object assigned!')
  else
  begin
    sMsg := TIDItem(clvSurrogates.Items[clvSurrogates.ItemIndex].Data).getInfo;

    if MessageDlg(msgSurrogateRemove + CRLF + CRLF + sMsg, mtConfirmation,
      [mbOK, mbCancel], 0) <> mrOK then
      exit;

    clvSurrogates.Items.BeginUpdate;
    clvSurrogates.Items.Delete(i);
    clearRanges;
    setRangeInfo;
    reNumItems;
    clvSurrogates.Items.EndUpdate;
    CheckSurrogateUpdated;
    setByCurrentItem;
  end;
end;

procedure TfrmOptionsSurrogate.cbUseDefaultDatesClick(Sender: TObject);
Const
  BOOLSTR: Array[False..True] of String = ('0', '1');
begin
  inherited;
  edDefaultPeriod.Enabled := cbUseDefaultDates.Checked;
  lblDefaultPeriod.Enabled := edDefaultPeriod.Enabled;
  SetPiece(fRawParams, U, 1, BOOLSTR[cbUseDefaultDates.Checked]);
  CheckSurrogateUpdated;
  Update508;
end;

procedure TfrmOptionsSurrogate.clearRanges;
var
  I: Integer;
begin
  // Traversing in reverse because otherwise we would skip items when deleting!
  for I := clvSurrogates.Items.Count-1 downto 0 do
    if IsOpen(I) then clvSurrogates.Items.Delete(I);
end;

procedure TfrmOptionsSurrogate.FixEndDates;
// Any items without an enddate need to get the startdate of the next item as
// the end date of the previous item. When this gets called the empty ranges
// have just been removed with clearRanges.
var
  I: integer;
  AIDItem, ANextIDItem: TIDItem;
begin
  for I := clvSurrogates.Items.Count-2 downto 0 do begin // don't fix the last item
    if not Assigned(clvSurrogates.Items[I].Data) then
      raise Exception.Create('Data not Assigned');
    AIDItem := TIDItem(clvSurrogates.Items[I].Data);
    if AIDItem.dateUntil <= 0 then begin
      // We found one we need to fix
      if not Assigned(clvSurrogates.Items[I+1].Data) then
        raise Exception.Create('Data of next item not Assigned');
      ANextIDItem := TIDItem(clvSurrogates.Items[I+1].Data);
      AIDItem.dateUntil := ANextIDItem.dateFrom; // fixed it!
      AIDItem.setListItem(clvSurrogates.Items[I]); // update the listitem on screen
    end;
  end;
end;

procedure TfrmOptionsSurrogate.reNumItems;
var
  n, i: Integer;
begin
  i := 0;
  n := 1;
  while i < clvSurrogates.Items.Count do
  begin
    if IsOpen(i) then
      clvSurrogates.Items[i].Caption := ciOpen
    else
    begin
      clvSurrogates.Items[i].Caption := intToStr(n);
      if (n = 1) and (i = 0) then
        clvSurrogates.Items[i].SubItems[3] := ciActive;
      inc(n);
    end;
    inc(i);
  end;
end;

procedure TfrmOptionsSurrogate.mergeItems;
var
  i: Integer;
  IDItem, IDPrev: TIDItem;
begin
  if clvSurrogates.Items.Count < 1 then
    exit;
  i := 1;
  IDPrev := TIDItem(clvSurrogates.Items[0].Data);
  while i < clvSurrogates.Items.Count do
  begin
    IDItem := TIDItem(clvSurrogates.Items[i].Data);
    if IDItem.IDString = IDPrev.IDString then
    begin
      IDPrev.dateUntil := IDItem.dateUntil;
      IDPrev.setListItem(clvSurrogates.Items[i - 1]);
      clvSurrogates.Items.Delete(i);
    end
    else
    begin
      IDPrev := IDItem;
      inc(i);
    end;
  end;
end;

procedure TfrmOptionsSurrogate.clvSurrogatesChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
begin
  if fIgnore then
    exit;
  inherited;
  if (Sender as TListView).ItemIndex = -1 then
    btnSurrEdit.Enabled := (Sender as TListView).Items.Count > 0
  else
  begin
    fIgnore := True;
    btnSurrEdit.Enabled := True;
    setByCurrentItem;
    fIgnore := False;
  end;
  Update508;
end;

procedure TfrmOptionsSurrogate.clvSurrogatesCompare(Sender: TObject;
  Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
var
  dt1, dt2: TDateTime;
begin
  inherited;
  dt1 := 0.0;
  dt2 := 0.0;
  if assigned(Item1.Data) then
    dt1 := TIDItem(Item1.Data).dateFrom;
  if assigned(Item2.Data) then
    dt2 := TIDItem(Item2.Data).dateFrom;

  Compare := 0;
  if dt1 < dt2 then
    Compare := -1
  else if dt2 < dt1 then
    Compare := 1;
end;

procedure TfrmOptionsSurrogate.clvSurrogatesCustomDrawItem
  (Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin
  inherited;
  if Item.Caption = ciOpen then
    Sender.Canvas.Font.Color := cl3dDkShadow // clHighlight
  else
    Sender.Canvas.Font.Color := clWindowText; // clDkGray
end;

procedure TfrmOptionsSurrogate.clvSurrogatesDblClick(Sender: TObject);
begin
  inherited;
  btnSurrEditClick(nil);
end;

procedure TfrmOptionsSurrogate.clvSurrogatesKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_INSERT then
  begin
    if ssCtrl in Shift then
    begin
      btnSurrEditClick(nil);
      Key := 0;
    end;
  end
  else if Key = VK_DELETE then
  begin
    if ssCtrl in Shift then
    begin
      btnRemoveClick(nil);
      Key := 0;
    end;
  end;

  inherited;
end;

procedure TfrmOptionsSurrogate.clvSurrogatesMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  begin
  inherited;
  if ssCtrl in Shift then
    btnRemoveClick(nil);
end;

procedure TfrmOptionsSurrogate.edDefaultPeriodChange(Sender: TObject);

  function ValidPeriod: Boolean;
  var
    I: Integer;
  begin
    Result := edDefaultPeriod.Text = '';
    if not Result then begin
      I := StrToIntDef(edDefaultPeriod.Text, -1);
      Result := (1 <= I) and (I <= MAX_PERIOD);
    end;
  end;

begin
  inherited;
  if not ValidPeriod then
  begin
    Beep;
    if edDefaultPeriod.Enabled then edDefaultPeriod.SetFocus;
  end;

  if edDefaultPeriod.Text <> '' then
  begin
    fRawParams := Piece(fRawParams, '^', 1) + '^' + edDefaultPeriod.Text;
  end else begin
    fRawParams := Piece(fRawParams, '^', 1);
  end;
  CheckSurrogateUpdated;
end;

procedure TfrmOptionsSurrogate.edDefaultPeriodExit(Sender: TObject);
begin
  inherited;
  if cbUseDefaultDates.Checked then
  begin
    if edDefaultPeriod.Text = '' then
    begin
      if edDefaultPeriod.Enabled then
      begin
        rpcGetSurrogateParams(fRawParams);
      end;
    end;
  end;
end;

procedure TfrmOptionsSurrogate.edDefaultPeriodKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if Key = Char(VK_RETURN) then
    Key := #0; // Don't want the deault to be ignited
  if not CharInSet(Key,[#8, '0' .. '9']) then // #8 - VK_BACK
  begin
    Key := #0;
    beep;
  end;
end;

procedure TfrmOptionsSurrogate.setRangeInfo;

  function TruncToMinute(ADate: TDateTime): TDateTime;
  // Discard any seconds and miliseconds from the passed in TDateTime
  begin
    Result := RecodeTime(ADate, HourOf(ADate), MinuteOf(ADate), 0, 0);
  end;

var
  IDItem: TIDItem;
  AListItem: TListItem;
  i: Integer;
  dtLimit,
  dtNow, dtFrom, dtUntil, dtMax: TDateTime;
begin
  inherited;
  dtNow := TruncToMinute(FMDateTimeToDateTime(ServerFMNow));
  dtLimit := 0;
  dtMax := dtNow;
  dtUntil := dtNow;

  fIgnore := True;
  i := 0;
  while i < clvSurrogates.Items.Count do
  begin
    if assigned(clvSurrogates.Items[i].Data) then
    begin
      IDItem := TIDItem(clvSurrogates.Items[i].Data);
      dtFrom := TruncToMinute(IDItem.dateFrom);
      dtUntil := TruncToMinute(IDItem.dateUntil);
    end else begin
{$IFDEF DEBUG}
      MessageDlg('DEBUG: No Object assigned to the record <' + intToStr(i) + '>!', mtError, [mbOK], 0);
{$ENDIF}
      continue;
    end;

    if (dtUntil > 0) and (dtUntil < dtNow) then
    begin
      inc(i);
      continue; // ignore ranges ended in the past
    end;

    if dtFrom < dtNow then
    begin
      dtMax := dtUntil;
      inc(i);
      continue;
    end;

    if IsOpen(i) then
    // no open records are expected while setting open ranges
    begin
{$IFDEF DEBUG}
      MessageDlg('DEBUG: No Open records expected at this time! (record: ' +
        intToStr(i) + ')', mtError, [mbOK], 0);
{$ENDIF}
      inc(i);
      continue;
    end;

    if (dtFrom - dtMax > 2 * dtGap) then
    begin
      AListItem := clvSurrogates.Items.Insert(i);
      IDItem := newTIDItem(fIDCollection, '', ciOpen, ciUnknownName, '', dtMax + dtGap, dtFrom - dtGap);
      IDItem.setListItem(AListItem);
      dtMax := dtUntil;
      inc(i, 2);
    end else begin
      dtMax := dtUntil;
      inc(i);
    end;
  end;

//  if dtLimit - dtUntil >= dtGap then
//  begin
  AListItem := clvSurrogates.Items.Insert(i);
  IDItem := newTIDItem(fIDCollection, '', ciOpen, ciUnknownName, '', dtUntil + dtGap, dtLimit);
  IDItem.setListItem(AListItem);
//  end;
  fIgnore := False;
end;

procedure TfrmOptionsSurrogate.LoadListViewByStringList(aList: TStringList);
var
  IDItem: TIDItem;
  i: Integer;
  sData, sName, sFrom, sUntil: String;
  li: TListItem;
begin
  if not assigned(aList) then
    Exit;
  for i := 0 to aList.Count - 1 do
  begin
    ParseServerRecord(aList[i], sData, sName, sFrom, sUntil);

    if IsFMDateTime(sFrom) and ((sUntil = '') or IsFMDateTime(sUntil)) then
    // v32 Issue Tracker #57?
    begin
      li := clvSurrogates.Items.Add;
      if sUntil <> '' then begin
        IDItem := newTIDItem(fIDCollection, sData, '', sName, '',
          FMDateTimeToDateTime(StrToFloat(sFrom)),
          FMDateTimeToDateTime(StrToFloat(sUntil)));
      end else begin
        IDItem := newTIDItem(fIDCollection, sData, '', sName, '',
          FMDateTimeToDateTime(StrToFloat(sFrom)), 0);
      end;
      IDItem.setListItem(li);
    end
    else
      MessageDlg('Incorrect or missing date/time for surrogate ' + sName + CRLF
        + CRLF + 'From date: ' + sFrom + CRLF + 'Until date: ' + sUntil + CRLF +
        CRLF + 'Record won''t be included in the Surrogates list', mtError,
        [mbOK], 0);
  end;
end;

procedure TfrmOptionsSurrogate.LoadServerData;
var
  ts: TStringList;
begin
  inherited;
  fIDCollection.Clear;
  clvSurrogates.Clear;
  ts := TStringList.Create;
  rpcGetSurrogateInfoList(ts);
  try
    if ts.Count > 1 then
    begin
      ts.Delete(0);
      fRawServerData := ts.Text;
      LoadListViewByStringList(ts);
    end;
  finally
    ts.Free;
  end;
  fRawServerData := ListViewToRaw;
  CheckSurrogateUpdated;
end;

procedure TfrmOptionsSurrogate.setSurrogateUpdated(aValue: Boolean);
begin
  fSurrogateUpdated := aValue;
  stxtChanged.Visible := fSurrogateUpdated;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TfrmOptionsSurrogate.setByCurrentItem;
var
  ind: Integer;
  IDItem: TIDItem;
begin
  ind := clvSurrogates.ItemIndex;
  if ind < 0 then
  begin
    btnRemove.Enabled := False;
    btnSurrEdit.Enabled := False;
  end
  else
  begin
    btnSurrEdit.Enabled := True;
    IDItem := TIDItem(clvSurrogates.Items[clvSurrogates.ItemIndex].Data);
    if assigned(IDItem) then
    begin
      btnRemove.Enabled := not IDItem.IsOpen;
      if btnRemove.Enabled then
        btnSurrEdit.Caption := '&Edit Surrogate'
      else
        btnSurrEdit.Caption := '&Add Surrogate';

      if (ind = 0) then
        if IDItem.IsOpen then
          IDItem.Comments := ''
        else
          IDItem.Comments := ciActive;
    end
    else
      ShowMessage('Item should be assigned!...');
  end;
  Update508;
end;

function TfrmOptionsSurrogate.ListViewToRaw: String;
var
  s: String;
  IDItem: TIDItem;
  SL: TStringList;
  i: Integer;
begin
  SL := TStringList.Create;
  for i := 0 to clvSurrogates.Items.Count - 1 do
  begin
    if assigned(TIDItem(clvSurrogates.Items[i].Data)) then
    begin
      IDItem := TIDItem(clvSurrogates.Items[i].Data);
      if IDItem.IsOpen then
        continue;
      s := IDItem.toRawString;
      SL.Add(s);
    end
{$IFDEF DEBUG}
    else
      ShowMessage('DEBUG: All Records should have an object assigned!');
{$ENDIF}
  end;
  Result := SL.Text;
  SL.Free;
end;

function TfrmOptionsSurrogate.ServerDeleteAll: String;
var
  s, sMsg: String;
  bOK: Boolean;
  SL: TStringList;
begin
  SL := TStringList.Create;
  SL.Text := fRawServerData;
  while SL.Count > 0 do
  begin
    s := SL[0];
    try
      s := pieces(s, U, 1, 2) + U + '0'; // To delete, add a '0' as the third piece
      rpcSetSurrogateInfo(s, bOK, sMsg);
    except
      On E: Exception do
      begin
        sMsg := E.Message;
        bOK := False;
      end;
    end;
    if not bOK then
    begin
      MessageDlg('Error deleting surrogate(s):' + CRLF + CRLF + sMsg, mtError,
        [mbOK], 0);
      Result := Result + sMsg + CRLF;
    end;
    SL.Delete(0);
  end;
  SL.Free;
end;

function TfrmOptionsSurrogate.ServerSaveAll: String;
var
  sMsg: String;
  bOK: Boolean;
  SL: TStringList;
begin
  Result := '';
  SL := TStringList.Create;
  SL.Text := ListViewToRaw;
  while SL.Count > 0 do
  begin
    rpcSetSurrogateInfo(SL[0], bOK, sMsg);
    if not bOK then
    begin
      // MessageDlg('Error saving surrogate(s):' + CRLF + CRLF + sMsg, mtError,
      // [mbOK], 0);
      Result := Result + sMsg + CRLF;
    end;
    SL.Delete(0);
  end;
  SL.Free;

end;

function TfrmOptionsSurrogate.ApplyChanges: Boolean;

  function getRawList: String;
  var
    i: Integer;
    lst: TStringList;
  begin
    Result := '';
    lst := TStringList.Create;
    rpcGetSurrogateInfoList(lst);
    try
      if lst.Count > 1 then
      begin
        for i := 1 to lst.Count - 1 do
          Result := Result + piece(lst[i], U, 1) + U + piece(lst[i], U, 3) + U +
            piece(lst[i], U, 4) + CRLF;
      end;
    finally
      lst.Free;
    end;
  end;

var
  sMsg, sRaw: String;
begin
  // check if params were changed since the last load
  rpcGetSurrogateParams(sRaw);
  if sRaw <> fRawParams then rpcSetSurrogateParams(fRawParams);
  if fRawServerData = csNeverLoaded then // fixing defect 331720
  begin
    Result := True;
    Exit;
  end;

  // check if the surrogates settings were updated since the last load
  sRaw := getRawList;
  if fRawServerData <> sRaw then
  begin
    MessageDlg(msgSurrogateChangesSinceLastLoad
{$IFDEF DEBUG}
      + CRLF + CRLF + 'DEBUG. Server before: ' + CRLF + fRawServerData + CRLF + CRLF +
      'Server Now   : ' + CRLF + sRaw
{$ENDIF}
      , mtWarning, [mbOK], 0);
    Result := False;
  end else begin
    Result := not SurrogateUpdated;
    if Result then Exit; // no need to save changes (or update the table)
    sMsg := ServerDeleteAll;
    if sMsg = '' then sMsg := ServerSaveAll;
    Result := sMsg = '';
    if Result then
    begin
      UpdateWithServerData; // only update if changes saved (VISTAOR-25134)
      SurrogateUpdated := False;
    end else begin
      MessageDlg('Error applying surrogate changes' + CRLF + CRLF +
        sMsg, mtError, [mbOK], 0);
      FRawServerData := getRawList;
      SurrogateUpdated := ListViewToRaw <> FRawServerData;
    end;
  end;
end;

procedure TfrmOptionsSurrogate.ParseServerRecord(aValue: String;
  var sData, sName, sFrom, sUntil: String);
begin
  sData := piece(aValue, U, 1);
  sName := piece(aValue, U, 2);
  sFrom := piece(aValue, U, 3);
  sUntil := piece(aValue, U, 4);
end;

function TfrmOptionsSurrogate.getItemID(anItem: Integer): String;
begin
  if assigned(clvSurrogates.Items[anItem].Data) then
    Result := TIDItem(clvSurrogates.Items[anItem].Data).IDString
  else
    Result := '';
end;

Procedure TfrmOptionsSurrogate.CheckSurrogateUpdated;
var
  RawUseDef, OrigUseDef: string;
  RawDefPeriod, OrigDefPeriod: string;
begin
  if (fRawParams = csNeverLoaded) then begin
    RawUseDef := '';
    RawDefPeriod := '';
    OrigUseDef := '';
    OrigDefPeriod := '';
  end else begin
    RawUseDef := Trim(Piece(fRawParams, '^', 1));
    if RawUseDef = NO_DEFAULT_INPUT then RawDefPeriod := ''
    else RawDefPeriod := Trim(Piece(fRawParams, '^', 2));
    if RawDefPeriod = '' then RawUseDef := NO_DEFAULT_INPUT;

    OrigUseDef := Trim(Piece(fOrigParams, '^', 1));
    if OrigUseDef = NO_DEFAULT_INPUT then OrigDefPeriod := ''
    else OrigDefPeriod := Trim(Piece(fRawParams, '^', 2));
    if OrigDefPeriod = '' then OrigUseDef := NO_DEFAULT_INPUT;
  end;

  SurrogateUpdated :=
    (RawUseDef <> OrigUseDef) or
    (RawDefPeriod <> OrigDefPeriod) or
    (
      (fRawServerData <> csNeverLoaded) and
      (fRawServerData <> ListViewToRaw)
    );
end;

end.
