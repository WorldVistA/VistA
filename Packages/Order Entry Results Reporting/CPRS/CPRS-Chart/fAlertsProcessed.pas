unit fAlertsProcessed;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, fBase508Form, VA508AccessibilityManager
  , ORFn
  , ORCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.ImgList,
  System.ImageList
  ;

type
  TfrmAlertsProcessed = class(TfrmBase508Form)
    Panel1: TPanel;
    lstvProcessedAlerts: TCaptionListView;
    ORAutoPanel2: TORAutoPanel;
    spbDebug: TSpeedButton;
    cmdMaxNumber: TButton;
    cmdDateRange: TButton;
    pnlRaw: TPanel;
    ImageList1: TImageList;
    pnlTop: TPanel;
    stxtDateRange: TVA508StaticText;
    pnlGroupBy: TPanel;
    cmbGroupBy: TComboBox;
    sTxtGroupBy: TVA508StaticText;
    btnRefresh: TButton;
    procedure lstvProcessedAlertsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure lstvProcessedAlertsClick(Sender: TObject);
    procedure lstvProcessedAlertsColumnClick(Sender: TObject;
      Column: TListColumn);
    procedure lstvProcessedAlertsCompare(Sender: TObject; Item1,
      Item2: TListItem; Data: Integer; var Compare: Integer);
    procedure lstvProcessedAlertsCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure lstvProcessedAlertsDblClick(Sender: TObject);
    procedure cmbGroupByChange(Sender: TObject);
    procedure cmdDateRangeClick(Sender: TObject);
    procedure cmdMaxNumberClick(Sender: TObject);
    procedure spbDebugClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lstvProcessedAlertsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lstvProcessedAlertsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnRefreshClick(Sender: TObject);
  private
    { Private declarations }
    FpaDescending: Boolean;
    FpaSortedColumn: Integer;
    FpaGroupedColumn: Integer;
    FpaFocusedGroup: Integer;
    FpaFocusedItem: Integer;
    FpaAlertsFound: Integer;
    FAlertsLoaded: boolean;

    procedure setAlertByServer;
    procedure setAlertGroupList;
    procedure paSetColumnHeaders;
    procedure SelectedItemGroupInfo(Item: TListItem);
    procedure GroupRecords(aColumn:Integer);
    procedure updateAlertInfo(ShowMore:Boolean=False);
    procedure toggleGroupStatus(aGroup:Integer);
  public
    { Public declarations }
    parentSelector: THandle;
    procedure LoadProcessedAlerts(Init: boolean = False);
    procedure setFontSize(aSize:Integer);
  end;

var
  frmAlertsProcessed: TfrmAlertsProcessed;

  // session values of the parameters
  FAlertMinDate:Integer;
  FStrtDate: TFMDateTime;
  FEndDate: TFMDateTIme;
  fMaxAlertNum: Integer;

function getProcessedAlertsList:TfrmAlertsProcessed;

implementation
{$R *.dfm}

uses
  Winapi.CommCtrl
  , VA508AccessibilityRouter
  , fOptionsProcessedAlerts
  , rOptions
  , fAlertRangeEdit
  , uCore, rCore
  , VAUtils
  , uConst
  , uFormUtils
  , UResponsiveGUI
  ;

function getProcessedAlertsList:TfrmAlertsProcessed;
begin
  if not assigned(frmAlertsProcessed) then
    frmAlertsProcessed := TfrmAlertsProcessed.Create(nil);

  Result := frmAlertsProcessed;
end;

////////////////////////////////////////////////////////////////////////////////

procedure TfrmAlertsProcessed.lstvProcessedAlertsClick(Sender: TObject);
var
  i: integer;
begin
  inherited;

  if lstvProcessedAlerts.GroupView then
    begin
      for i := 0 to lstvProcessedAlerts.Groups.Count - 1 do
        begin
          if lgsCollapsed in lstvProcessedAlerts.Groups[i].State then
            lstvProcessedAlerts.Groups[i].TitleImage := 1
          else
            lstvProcessedAlerts.Groups[i].TitleImage := 2
        end;
    end;
end;

procedure TfrmAlertsProcessed.lstvProcessedAlertsCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  if FpaSortedColumn = 0 then
    Compare := CompareText(Item1.Caption, Item2.Caption)
  else
  if FpaSortedColumn <> 0 then
    Compare := CompareText(Item1.SubItems[FpaSortedColumn-1], Item2.SubItems[FpaSortedColumn-1]);
  if FpaDescending then
    Compare := -Compare;
end;

procedure TfrmAlertsProcessed.lstvProcessedAlertsCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin
  inherited;
  if assigned(Item) and assigned(Item.Data) then
    lstvProcessedAlerts.Canvas.Font.Color := clHighlight
  else
    lstvProcessedAlerts.Canvas.Font.Color := clWindowText;
end;

procedure TfrmAlertsProcessed.lstvProcessedAlertsDblClick(Sender: TObject);
var
  iTag: Integer;
begin
  inherited;
  if lstvProcessedAlerts.ItemIndex < 0 then
    exit;
  if assigned(lstvProcessedAlerts.Items[lstvProcessedAlerts.ItemIndex].Data) then
    begin
      iTag := Integer(lstvProcessedAlerts.Items[lstvProcessedAlerts.ItemIndex].Data);
      SendMessage(parentSelector,UM_SELECTPATIENT,iTag,0);
    end
  else
    MessageBeep(0);
end;

procedure TfrmAlertsProcessed.lstvProcessedAlertsKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  aGroup: Integer;
begin
  inherited;
  if Key = VK_RETURN then
    if ssShift in Shift then
      begin
        if lstvProcessedAlerts.ItemIndex >=0 then
          begin
            aGroup := lstvProcessedAlerts.Items[lstvProcessedAlerts.ItemIndex].GroupID;
            toggleGroupStatus(aGroup);
          end;
      end
    else
      lstvProcessedAlertsDblClick(nil);
end;

procedure TfrmAlertsProcessed.toggleGroupStatus(aGroup:Integer);
begin
  if (aGroup <0) or (aGroup>=lstvProcessedAlerts.Groups.Count) then
    exit;

  if lgsCollapsed in lstvProcessedAlerts.Groups[aGroup].State then
    begin
      lstvProcessedAlerts.Groups[aGroup].State := lstvProcessedAlerts.Groups[aGroup].State - [lgsCollapsed];
      lstvProcessedAlerts.Groups[aGroup].TitleImage := 2;
    end
  else
    begin
      lstvProcessedAlerts.Groups[aGroup].TitleImage := 1;
      lstvProcessedAlerts.Groups[aGroup].State := lstvProcessedAlerts.Groups[aGroup].State + [lgsCollapsed];
    end;

end;

procedure TfrmAlertsProcessed.lstvProcessedAlertsMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  grp: Integer;
  pnt: TPoint;
(*
  procedure GroupInfo;
  var
    s: String;
    i,j: integer;
    rect: TRect;
  begin
    inherited;
    if not lstvProcessedAlerts.GroupView then
      exit;
    for i := 0 to lstvProcessedAlerts.Groups.Count - 1 do
      begin
        rect.Top := LVGGR_HEADER;
        j := SendMessage(lstvProcessedAlerts.Handle, LVM_GETGROUPRECT, i, DWORD(@rect));
        s := s +
          Format('Group: %d  %d %d %d %d (RC=%d)',[i,rect.Left, rect.Top, rect.Right, rect.Bottom, j])+ #13#10;
      end;
     ShowMessage(s);
  end;
*)
  function getGroupIDByPoint(aPoint:TPoint): Integer;
  var
    i: integer;
    rect: TRect;
  begin
    Result := -1;
    for i := 0 to lstvProcessedAlerts.Groups.Count - 1 do
      begin
        rect.Top := LVGGR_HEADER;
        SendMessage(lstvProcessedAlerts.Handle, LVM_GETGROUPRECT, i, DWORD(@rect));
        if not PtInRect(rect,aPoint) then
          continue;

        Result := i;
        break;
      end;
  end;

begin
  inherited;
  if lstvProcessedAlerts.GroupView then
    begin
      pnt.X := X;
      if pnt.X > width - 20 then
        exit; // no need to process right side indicator clicks
      pnt.Y := Y;
      grp := getGroupIDByPoint(pnt);
      toggleGroupStatus(grp);
    end;
end;

procedure TfrmAlertsProcessed.lstvProcessedAlertsColumnClick(Sender: TObject; Column: TListColumn);

  procedure UpdateHeader(aHandle:HWND; aColumn: Integer);
  var
    Header: HWND;
    Item: THDItem;
  begin
    Header := ListView_GetHeader(aHandle);
    ZeroMemory(@Item, SizeOf(Item));
    Item.Mask := HDI_FORMAT;

    ListViewClearSortIndicator(aHandle,FpaSortedColumn);

    if Column.Index <> FpaSortedColumn then
      begin
        FpaDescending := False;
        FpaSortedColumn := Column.Index;
      end
    else
      FpaDescending := not FpaDescending;

    // Get the new column
    Header_GetItem(Header, FpaSortedColumn, Item);
    Item.fmt := Item.fmt and not (HDF_SORTUP or HDF_SORTDOWN);//remove both flags

    if FpaDescending then
      Item.fmt := Item.fmt or HDF_SORTDOWN//include the sort descending flag
    else
      Item.fmt := Item.fmt or HDF_SORTUP;//include the sort ascending flag

    Header_SetItem(Header, FpaSortedColumn, Item);

    with TListView(Sender) do
      begin
        SortType := stText;
        Items.BeginUpdate;
        AlphaSort;
        Items.EndUpdate;
      end;
  end;

begin
  UpdateHeader(TListView(Sender).Handle,FpaSortedColumn);
end;

procedure TfrmAlertsProcessed.SelectedItemGroupInfo(Item: TListItem);
var
  msg: String;
  grp: TListGroup;
begin
  if (trim(cmbGroupBy.Text) <> 'No Groups') and ScreenReaderSystemActive then
  begin
    grp := lstvProcessedAlerts.Groups[Item.GroupID];
    if (Item.Index = FpaFocusedItem) and (grp.GroupID = FpaFocusedGroup) then
      exit;
    FpaFocusedItem := Item.Index;
    FpaFocusedGroup := grp.GroupID;
    msg := 'Selected Message Group is '+grp.Header+'';
    pnlRaw.Caption := msg;
    TResponsiveGUI.ProcessMessages;
    GetScreenReader.Speak(msg);
  end;
end;

procedure TfrmAlertsProcessed.spbDebugClick(Sender: TObject);
begin
  inherited;
  pnlRaw.Visible := not pnlRaw.Visible;
end;

procedure TfrmAlertsProcessed.btnRefreshClick(Sender: TObject);
begin
  inherited;
  LoadProcessedAlerts;
end;

procedure TfrmAlertsProcessed.cmbGroupByChange(Sender: TObject);
begin
  inherited;
  FpaGroupedColumn := cmbGroupBy.ItemIndex -1;
  GroupRecords(FpaGroupedColumn);
end;

procedure TfrmAlertsProcessed.lstvProcessedAlertsChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
//var
//  s: String;
begin
  inherited;

  SelectedItemGroupInfo(Item);
  // the code that creates item Data was commented out.
  // the result of this code is that clicking on a processed alert clears the
  // selected patient demographic info, but clicking on an alert on the
  // pending alerts does not do this.
  {
  if assigned(Item.Data) and (Change=ctState) then
    begin
     s := IntToStr(Integer(Item.Data));
      frmPtSelDemog.ShowDemog(s);
    end
  else
    frmPtSelDemog.ClearIDInfo;
  }

  TResponsiveGUI.ProcessMessages;

  if Item.SubItems.Count > 0 then
    pnlRaw.Caption := Item.SubItems[Item.SubItems.Count - 1]
  else
    pnlRaw.Caption := 'No data';
end;

procedure TfrmAlertsProcessed.cmdDateRangeClick(Sender: TObject);
var
  _min,_max,_Start, _Stop: String;
  _now_: TDateTime;
begin
  begin
    _now_ := FMDateTimeToDateTime(FMNow);
    _min := FormatDateTime(fAlertRangeEdit.fmtDateTime,_now_ - FAlertMinDate + 1);
    _max := FormatDateTime(fAlertRangeEdit.fmtDateTime,_now_);
    _start := FormatFMDateTime(fAlertRangeEdit.fmtDateTime,Trunc(FStrtDate));
    _stop :=  FormatFMDateTime(fAlertRangeEdit.fmtDateTime,Trunc(FEndDate)+ 0.235959);
    if editAlertRange(_Start,_stop,_min,_max, fAlertMinDate)= mrOK then
      begin
        FStrtDate := StrToFMDateTime(_Start);
        FEndDate := StrToFMDateTime(_Stop);
        FEndDate := Trunc(FEndDate) + 0.235959; // End of the day adjustment
        paLogDays := Trunc(StrDateToDate(_Stop)) - Trunc(StrDateToDate(_Start)) + 1;
        UpdateAlertInfo; // Update description of the processed alerts

        if ScreenReaderActive then
          GetScreenReader.Speak('Updated Date Range starts on '+
            FormatDateTime('mmm/dd/yyyy', FMDateTimeToDateTime(FStrtDate)) + ' ends on ' +
            FormatDateTime('mmm/dd/yyyy', FMDateTimeToDateTime(FEndDate))
          );
        LoadProcessedAlerts; // Load Processed alerts data from Server
      end;
  end;
end;
procedure TfrmAlertsProcessed.cmdMaxNumberClick(Sender: TObject);
var
  sValue: String;
begin
  inherited;
  sValue := IntToStr(fMaxAlertNum);
  if InputQuery('Processed Alerts Preferences','Enter Max # of alerts to review',sValue) then
    begin
      fMaxAlertNum := StrToIntDef(sValue,paLogRecordsMax);
      paLogRecordsMax := fMaxAlertNum;
      updateAlertInfo;
      LoadProcessedAlerts;
    end;
end;

procedure TfrmAlertsProcessed.FormCreate(Sender: TObject);
begin
  inherited;
  FpaSortedColumn := 0;
  FpaDescending := True;
  paSetColumnHeaders;
//  if FAlertMinDate = 0 then  // v32 Test Issue Tracker #37
  if ProcessedAlertsSessionInfo = '' then  // v32 Test Issue Tracker #37
    setAlertByServer; // Load Processed Alerts preferences
  setAlertGroupList; // Build list of possible groups
  UpdateAlertInfo; // Update Processed alert description
  FpaFocusedGroup := -1;
  FpaFocusedItem := -1;
{$IFDEF DEBUG}
{$ELSE}
  btnRefresh.Visible := False;
  spbDebug.Visible := False;
{$ENDIF}
end;

procedure TfrmAlertsProcessed.GroupRecords(aColumn:Integer);
var
  Group: TListGroup;
  sValue,sID: String;
  i: integer;
begin
  lstvProcessedAlerts.Groups.Clear;
  lstvProcessedAlerts.GroupView := false;
  if aColumn >= 0 then
    begin
      if FpaSortedColumn <> FpaGroupedColumn then // sort if needed
        begin
          for I := 0 to lstvProcessedAlerts.Columns.Count - 1 do
            ListViewClearSortIndicator(lstvProcessedAlerts.handle,i);
          FpaSortedColumn := FpaGroupedColumn;
          lstvProcessedAlertsColumnClick(lstvProcessedAlerts, lstvProcessedAlerts.Columns[FpaSortedColumn]);
        end;
      Group := nil;
      sValue := '\\';
      sID := '';
      for i := 0 to lstvProcessedAlerts.Items.Count - 1 do
        begin
          if FpaSortedColumn = 0 then
            sValue :=lstvProcessedAlerts.Items[i].Caption
          else
            sValue :=lstvProcessedAlerts.Items[i].SubItems[FpaSortedColumn-1];
          if sValue = '' then
            sValue := 'no value';
          if sValue <> sID then
            begin
              Group := lstvProcessedAlerts.Groups.Add;
              Group.State := [lgsNormal, lgsCollapsible] - [lgsHidden];
              Group.Header := Format('%s: %s',[cmbGroupBy.Text,sValue]);
              Group.HeaderAlign := taLeftJustify; //taCenter;
              Group.Footer := '';
              Group.FooterAlign := taLeftJustify;
              Group.TitleImage := 2;
              sID := sValue;
            end;
          if assigned(Group) then
            lstvProcessedAlerts.Items[i].GroupID := Group.GroupID;
        end;
      lstvProcessedAlerts.GroupView := true;

      if ScreenReaderSystemActive  then
      begin
        sValue := lstvProcessedAlerts.Columns[aColumn].Caption;
        GetScreenReader.Speak('Grouped by '+sValue+' column');
      end;
    end;
end;

procedure TfrmAlertsProcessed.LoadProcessedAlerts(Init: boolean = False);
var
  List: TStrings;
  bShowMore:Boolean;
  sStartDate,sEndDate,sValue,sProcessed : String;

const
  fmtDateTime = 'mm/dd/yyyy@hh:nn';

  procedure ProcessRecord(aText:String);
  var
//    ID,
    ind: Integer;
    anItem:TListItem;
    s:String;
{
Column #               Piece
0 - Info                1:    flag “I” – informational alert, blank(?) otherwise
1 - Patient             2:    Alert name - Patient.
2 - location            3:    Location (package name?)
3 - Urgency             4:    Urgency
4 - Alert Date/Time     5:    Alert Date Time
5 - Message             6:    Message Text
7 - Processed on        7:    ---- blank
8 - ?                   8:    Alert Information
9 - ?                   9:    ?
10 - ?                 10:
11 - ?                 11:
12 - ?                 12:
13 - ?                 13:
14 - First Displayed   14:
            NSR20081008 adds several pieces to the result string:

            15                Date/Time Alert First Displayed
            16                Date/Time Alert First Selected
            17                Date/Time Alert Processed
            18                Date/Time Alert Deleted
            19                Recipient Type
            20                Surrogate Name
            21                Acting as Surrogate For (Name)
6 - Forward By
            22                Alert Forwarded by/for << This is a new return for the forwarded by/for user.
}
  begin
    anItem := lstvProcessedAlerts.Items.Add;
    s := Piece(aText,U,1);
    if s <> 'Forwarded by: ' then
      begin
        anItem.Caption := Piece(aText, U, 1);
        for ind := 2 to DelimCount(aText, U) + 1 do
          begin
            sValue := Piece(aText, U, ind);
            case ind of
			        7: begin
                   sValue := Piece(aText, U, 22) // FH this will add << This is a new return for the forwarded by/for user.
                 end;
{
              8:begin
                  s := piece(piece(sValue,';',1),',',2);
                  ID := StrToIntDef(s,-1);
                  if ID > 0 then
                    anItem.Data := Pointer(ID); // Pt DFN if assigned to alert;
                  sValue := piece(sValue,';',3);
                  sValue := FormatFMDateTimeStr(fmtDateTime,sValue);
                end;
}
              8,9..16,18,19: continue; // comment if all pieces are needed.
              17: sValue := FormatFMDateTimeStr(fmtDateTime,sValue);
// uncomment if all pieces are needed. Also check paSetColumnHeaders below
//          15,16,17,18,19: sValue := FormatFMDateTimeStr(fmtDateTime,sValue);
              20: if sValue = '' then
                  sValue := User.Name;
            end;
            anItem.SubItems.Add(sValue);
          end;
      end
    else
      begin
        anItem.SubItems[5] := Piece(aText, U, 2);
        s := Piece(aText, U, 3);
        if Length(s) > 0 then
          anItem.SubItems[8] := 'Fwd Comment: ' + s;
      end;
  end;

var
  ACurrentCursor: TCursor;
begin
  if Init and FAlertsLoaded then
    exit;

  ACurrentCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    List := TStringList.Create;
    try
      List.Clear;
      // Load the list here
      sStartDate := FloatToStr(FStrtDate);
      sEndDate := FloatToStr(FEndDate);
      sProcessed := '1'; // if '0' the RPC returns ALL alerts including pending
      LoadProcessedNotifications(List, sStartDate, sEndDate,
        IntToStr(fMaxAlertNum + 1), sProcessed);

      FpaAlertsFound := List.Count;
      bShowMore := FpaAlertsFound > fMaxAlertNum;
      if bShowMore then
        FpaAlertsFound := fMaxAlertNum;
      updateAlertInfo(bShowMore);

      lstvProcessedAlerts.Items.BeginUpdate;
      try
        lstvProcessedAlerts.Items.Clear;
        lstvProcessedAlerts.GroupView := False;
        for var I := 0 to FpaAlertsFound - 1 do
          ProcessRecord(List[I]);
      finally
        lstvProcessedAlerts.Items.EndUpdate;
      end;

      if ScreenReaderActive then
        GetScreenReader.Speak(Format('Found %d Notifications',
          [FpaAlertsFound]));
    finally
      List.Free;
    end;
  finally
    Screen.Cursor := ACurrentCursor;
  end;

  FAlertsLoaded := True;
end;

procedure TfrmAlertsProcessed.updateAlertInfo(ShowMore:Boolean=False);
var
  msg:String;
const
{$IFDEF DEBUG}
  fmtAlertInfoDateTime = 'mm/dd/yyyy hh:nn:ss';
{$ELSE}
  fmtAlertInfoDateTime = 'mm/dd/yyyy';
{$ENDIF}
begin
  if ShowMore then
    msg := format('Last %d Notifications (More data available for selected period...)',[fMaxAlertNum])
  else
    msg := format('Found %d Notifications',[FpaAlertsFound]);

  stxtDateRange.Caption :=
    FormatDateTime(fmtAlertInfoDateTime, FMDateTimeToDateTime(FStrtDate)) + ' -- ' +
    FormatDateTime(fmtAlertInfoDateTime, FMDateTimeToDateTime(FEndDate))
    + '    ' + msg;
end;

procedure TfrmAlertsProcessed.paSetColumnHeaders;

  procedure newColumn(aCaption:String;aWidth:Integer);
  var
    lc: TListColumn;
  begin
    lc := TListColumn.Create(lstvProcessedAlerts.Columns);
    lc.Caption := aCaption;
    lc.Width := aWidth;
  end;

begin
  lstvProcessedAlerts.Columns.Clear;
  newColumn('Info',30);
  newColumn('Patient',120);
  newColumn('Location',60);
  newColumn('Urgency',67);
  newColumn('Alert Date/Time',110);
  newColumn('Message',300);
  newColumn('Forwarded By/When',60);
  newColumn('Processed On',110);
  // uncomment in case you need to see all pieces coming from the RPC
{
  newColumn('-?-',20);
  newColumn('-?-',20);
  newColumn('-?-',20);
  newColumn('-?-',20);
  newColumn('-?-',20);
  newColumn('-?-',20);

  newColumn('First Displayed',20);
  newColumn('First Selected',20);
  newColumn('Processed',20);
  newColumn('Deleted',20);
  newColumn('Type',120);
}
  newColumn('Processed By',120);//  newColumn('Surrogate Name',120);
  newColumn('Acting as Surrogate for',120);
end;

procedure TfrmAlertsProcessed.setAlertByServer;
var
  _now_: TDateTime;
begin
  _now_ := FMDateTimeToDateTime(FMNow);

  loadProcessedAlertsInfo;
  FpaAlertsFound := 0;
  FAlertMinDate := rpcGetDaysBeforeAlertPurge;
  fMaxAlertNum := paLogRecordsMax;
  fEndDate := DateTimeToFMDateTime(_now_);
  FEndDate := Trunc(FEndDate) + 0.235959; // End of the day adjustment
  fStrtDate := DateTimeToFMDateTime(_now_-paLogDays+1);// adding 1 to count today in
  fStrtDate := Trunc(fStrtDate); // Expecting day to start from 0.000000 time
end;

procedure TfrmAlertsProcessed.setAlertGroupList;
var
  i: integer;
begin
  FpaGroupedColumn := -1;
  cmbGroupBy.Items.Clear;
  cmbGroupBy.Items.Add('No Groups');
  pnlGroupBy.Width := pnlGroupBy.Width - 1;
  for i := 0 to lstvProcessedAlerts.Columns.Count - 1 do
    cmbGroupBy.Items.Add(lstvProcessedAlerts.Columns[i].Caption);
end;

procedure TfrmAlertsProcessed.setFontSize(aSize: Integer);
begin
  Font.Size := aSize;
end;

initialization

FAlertMinDate := 0;
FStrtDate := 0.0;
FEndDate := 0.0;

end.
