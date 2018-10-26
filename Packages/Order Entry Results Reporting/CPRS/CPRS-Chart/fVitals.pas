{Modifications
Date: 4/1/98 RAB/ISL
Description: Added procedure SelectVital(FontSize:integer; idx: integer)
    To be able to pass the row index into the form.  This will enable the vital
    entry form to open the apropriate line on this form (If this screen is opened
    by the vital entry screen)

Date: 4/9/98 RAB/ISL
Descriotion:  Added button and click event to call vital entry screen.

Date: 4/9/98 RAB/ISL
Descriotion:  if Idx passed into procedure SelectVital is '99' then the botton to
  call the vital entry screen will be disabled.

Date: 4/23/98
By: Robert Bott
Description: Set position of form to poScreenCenter.
Date: 4/23/98
By: Robert Bott
Description: Forced an update after returning from vital entry form.

//Modifed: 6/23/98
//By: Robert Bott
//Location: ISL
//Description of Mod:
//  Moved code that verifies valid provider and visit from fvit into fVitals.
//   now found in procedure TfrmVitals.btnEnterVitalsClick(Sender: TObject);
//   formerly in procedure TfrmVit.FormActivate(Sender: TObject);

}

unit fVitals;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ORCtrls, TeEngine, Series, TeeProcs, Chart, ExtCtrls, Grids,Buttons,
  ORNet, ORFn, uConst, Menus, ORDtTmRng, fBase508Form, ComCtrls, uVitals, VAUtils,
  VA508AccessibilityManager;

type
  TfrmVitals = class(TfrmBase508Form)
    pnlTop: TPanel;
    chtChart: TChart;
    serTest: TLineSeries;
    pnlLeft: TORAutoPanel;
    lstDates: TORListBox;
    pnlBottom: TPanel;
    grdVitals: TCaptionStringGrid;
    pnlButtons: TPanel;
    lstVitals: TCaptionListBox;
    serTestX: TLineSeries;
    serTime: TPointSeries;
    lblNoResults: TStaticText;
    serTestY: TLineSeries;
    pnlLeftClient: TORAutoPanel;
    chkValues: TCheckBox;
    chk3D: TCheckBox;
    chkZoom: TCheckBox;
    pnlEnterVitals: TPanel;
    btnEnterVitals: TButton;
    popChart: TPopupMenu;
    popValues: TMenuItem;
    pop3D: TMenuItem;
    popZoom: TMenuItem;
    popZoomBack: TMenuItem;
    N1: TMenuItem;
    popCopy: TMenuItem;
    N2: TMenuItem;
    popDetails: TMenuItem;
    calVitalsRange: TORDateRangeDlg;
    N3: TMenuItem;
    popPrint: TMenuItem;
    dlgWinPrint: TPrintDialog;
    procedure lstDatesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lstVitalsClick(Sender: TObject);
    procedure grdVitalsSelectCell(Sender: TObject; Col, Row: Integer;
      var CanSelect: Boolean);
    procedure chkZoomClick(Sender: TObject);
    procedure chk3DClick(Sender: TObject);
    procedure chkValuesClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure pnlEnterVitalsResize(Sender: TObject);
    procedure btnEnterVitalsClick(Sender: TObject);
    procedure chtChartUndoZoom(Sender: TObject);
    procedure popValuesClick(Sender: TObject);
    procedure pop3DClick(Sender: TObject);
    procedure popZoomClick(Sender: TObject);
    procedure popZoomBackClick(Sender: TObject);
    procedure popCopyClick(Sender: TObject);
    procedure popDetailsClick(Sender: TObject);
    procedure chtChartClickSeries(Sender: TCustomChart;
      Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure chtChartMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure chtChartClickLegend(Sender: TCustomChart;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure popChartPopup(Sender: TObject);
    procedure popPrintClick(Sender: TObject);
    procedure BeginEndDates(var ADate1, ADate2: TFMDateTime; var ADaysBack: integer);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    procedure VGrid(griddata: TStrings);
    procedure WorksheetChart(test: string; aitems: TStrings);
    procedure GetStartStop(var start, stop: string; aitems: TStrings);
  public
    { Public declarations }
    function FMToDateTime(FMDateTime: string): TDateTime;
  end;


var
  frmVitals: TfrmVitals;
  tmpGrid: TStringList;
  uDate1, uDate2: Tdatetime;

procedure SelectVital(FontSize:integer; idx: integer);
procedure SelectVitals(VitalType: String);
function VitalsGrid(const patient: string; date1, date2: TFMDateTime; restrictdates: integer; tests: TStrings): TStrings;  //*DFN*
function VitalsMemo(const patient: string; date1, date2: TFMDateTime; tests: TStrings): TStrings;  //*DFN*

implementation

uses fCover, uCore, rCore, fVit, fFrame, fEncnt, fVisit, fRptBox, rReports, uInit,
     System.UITypes;

const
  ZOOM_PERCENT = 99;        // padding for inflating margins

{$R *.DFM}


procedure SelectVital(FontSize:integer; idx: integer);
var
  frmVitals: TfrmVitals;
begin
  frmVitals := TfrmVitals.Create(Application);
  try
    ResizeAnchoredFormToFont(frmVitals);
    with frmVitals do
    begin
      if idx <= lstvitals.items.count then lstVitals.ItemIndex := idx
      else lstVitals.ItemIndex := 0;

      if idx = 99 then
        btnEnterVitals.enabled := False;
      ShowModal;
    end;

  finally
    frmVitals.Release;
  end;
end;

function getVitalsStartDate : String;
begin
  result := '';
  if Patient.Inpatient then
    result := FormatDateTime('mm/dd/yy',Now - 7)
  else
    result := FormatDateTime('mm/dd/yy',IncMonth(Now,-6));
end;

procedure SelectVitals(VitalType: String);
var
  VLPtVitals : TGMV_VitalsViewForm;
  //GMV_FName: String;
  GMV_FName: AnsiString; // Modified for GetProcAddrecc compliance (drp/5-22-2013@0941)

begin
 { Availble Forms:
  GMV_FName :='GMV_VitalsEnterDLG';
  GMV_FName :='GMV_VitalsEnterForm';
  GMV_FName :='GMV_VitalsViewForm';
  GMV_FName :='GMV_VitalsViewDLG';
  }
  GMV_FName :='GMV_VitalsViewDLG';
  LoadVitalsDLL;
  // UpdateTimeOutInterval(5000);
  if VitalsDLLHandle <> 0 then
    begin
     @VLPtVitals := GetProcAddress(VitalsDLLHandle,PAnsiChar(GMV_FName));
     if assigned(VLPtVitals) then
       VLPtVitals(RPCBrokerV,
                  Patient.DFN,
                  IntToStr(Encounter.Location),
                  getVitalsStartDate(),
                  FormatDateTime('mm/dd/yy',Now),
                  GMV_APP_SIGNATURE,
                  GMV_CONTEXT,
                  GMV_CONTEXT,
                  Patient.Name,
                  frmFrame.lblPtSSN.Caption + '    ' + frmFrame.lblPtAge.Caption,
                  Encounter.LocationName + U + VitalType)
     else
       MessageDLG('Can''t find function "'+string(GMV_FName)+'".',mtError,[mbok],0);
    end
  else
    MessageDLG('Can''t find library '+VitalsDLLName+'.',mtError,[mbok],0);
  @VLPtVitals := nil;
  UnloadVitalsDLL;
end;

(*
procedure SelectVitals(FontSize: Integer);
var
  frmVitals: TfrmVitals;
  firstchar: string;
  i: integer;
begin
  frmVitals := TfrmVitals.Create(Application);
  try
    ResizeAnchoredFormToFont(frmVitals);
    with frmVitals do
    begin
      with frmCover do
        for i := ComponentCount - 1 downto 0 do
          begin
            if Components[i] is TORListBox then
              begin
                case Components[i].Tag of
                  70:
                  if (Components[i] as TORListBox).ItemIndex > -1 then
                    begin
                      // changed to look at 2 chars so pain & pulse not confused {*KCM*}
                      firstchar := UpperCase(Copy(Piece((Components[i] as TORListBox).Items[(Components[i] as TORListBox).ItemIndex], '^', 2), 1, 2));
                      if firstchar = 'T' then
                        lstVitals.ItemIndex := 0
                      else if firstchar = 'P' then
                        lstVitals.ItemIndex := 1
                      else if firstchar = 'R' then
                        lstVitals.ItemIndex := 2
                      else if firstchar = 'BP' then
                        lstVitals.ItemIndex := 3
                      else if firstchar = 'HT' then
                        lstVitals.ItemIndex := 4
                      else if firstchar = 'WT' then
                        lstVitals.ItemIndex := 5
                      else if firstchar = 'PN' then
                        lstVitals.ItemIndex := 6;
                    end
                    else
                    begin
                      firstchar := '';
                      lstVitals.ItemIndex := 0;
                    end;
                end;
              end;
          end;
      ShowModal;
    end;
  finally
    frmVitals.Release;
  end;
end;
  *)
procedure TfrmVitals.VGrid(griddata: TStrings);
var
  testcnt, datecnt, datacnt, linecnt, x, y, i: integer;
begin
  testcnt := strtoint(Piece(griddata[0], '^', 1));
  datecnt := strtoint(Piece(griddata[0], '^', 2));
  datacnt := strtoint(Piece(griddata[0], '^', 3));
  linecnt := testcnt + datecnt + datacnt;
  with grdVitals do
  begin
    if datecnt = 0 then ColCount := 1 else ColCount := datecnt;
    if testcnt = 0 then RowCount := 2 else RowCount := testcnt + 1;
    DefaultColWidth := 80;
    FixedCols := 0;
    FixedRows := 1;
    for y := 0 to RowCount - 1 do
      for x := 0 to ColCount - 1 do
        Cells[x, y] := '';
    if datecnt = 0 then
    begin
      Cells[1, 0] := 'no results';
      for x := 1 to RowCount - 1 do
        Cells[x, 1] := '';
    end;
    for i := testcnt + 1 to testcnt + datecnt do
    begin
      Cells[i - testcnt - 1, 0] := FormatFMDateTime('c',MakeFMDateTime(Piece(griddata[i], '^', 2)));
    end;
    for i := testcnt + datecnt + 1 to linecnt do
    begin
      x := strtoint(Piece(griddata[i], '^', 1));
      y := strtoint(Piece(griddata[i], '^', 2));
      Cells[x - 1, y]  := Piece(griddata[i], '^', 3);
    end;
  end;
end;

function VitalsGrid(const patient: string; date1, date2: TFMDateTime; restrictdates: integer; tests: TStrings): TStrings;  //*DFN*
begin
  CallV('GMV ORQQVI1 GRID', [patient, date1, date2, restrictdates, tests]);
  Result := RPCBrokerV.Results;
end;

function VitalsMemo(const patient: string; date1, date2: TFMDateTime; tests: TStrings): TStrings;  //*DFN*
begin
  CallV('GMV ORQQVI1 DETAIL', [patient, date1, date2, 0, tests]);
  Result := RPCBrokerV.Results;
end;

procedure TfrmVitals.lstDatesClick(Sender: TObject);
var
  daysback, vindex: integer;
  date1, date2: TFMDateTime;
  today: TDateTime;
begin
  if (lstDates.ItemID = 'S') then
  begin
    with calVitalsRange do
    begin
      if Execute then
      begin
        lstDates.ItemIndex := lstDates.Items.Add(RelativeStart + ';' +
          RelativeStop + U + TextOfStart + ' to ' + TextOfStop);
      end
      else
        lstDates.ItemIndex := -1;
    end;
  end;
  today := FMToDateTime(floattostr(FMToday));
  if lstDates.ItemIEN > 0 then
  begin
    daysback := lstDates.ItemIEN;
    date1 := FMToday + 0.2359;
    If daysback = 1 then
      date2 := DateTimeToFMDateTime(today)
    Else
      date2 := DateTimeToFMDateTime(today - daysback);
  end
  else
    BeginEndDates(date1,date2,daysback);
  //date1 := date1 + 0.2359;
  FastAssign(VitalsGrid(Patient.DFN, date1, date2, 0, lstVitals.Items), tmpGrid);
  vindex := lstVitals.ItemIndex;
  VGrid(tmpGrid);
  lstVitals.ItemIndex := vindex;
  lstVitalsClick(self);
  chtChart.BottomAxis.Automatic := true;    //***********
  chkZoom.Checked := false;
  chtChart.UndoZoom;
  if lstVitals.ItemIndex > -1 then
  begin
    WorksheetChart(inttostr(lstVitals.ItemIndex + 1), tmpGrid);
    if (serTest.Count > 1) and not chkZoom.Checked then
    begin
      chtChart.UndoZoom;
      chtChart.ZoomPercent(ZOOM_PERCENT);
    end;
  end;
end;

procedure TfrmVitals.FormCreate(Sender: TObject);
begin
  tmpGrid := TStringList.Create;
  if Patient.Inpatient then lstDates.ItemIndex := 1 else lstDates.ItemIndex := 4;
  SerTest.GetHorizAxis.ExactDateTime := true;
  SerTest.GetHorizAxis.Increment := DateTimeStep[dtOneMinute];
end;

procedure TfrmVitals.FormDestroy(Sender: TObject);
begin
  tmpGrid.free;
end;

function TfrmVitals.FMToDateTime(FMDateTime: string): TDateTime;
var
  x, Year: string;
begin
  { Note: TDateTime cannot store month only or year only dates }
  x := FMDateTime + '0000000';
  if Length(x) > 12 then x := Copy(x, 1, 12);
  if StrToInt(Copy(x, 9, 4)) > 2359 then x := Copy(x,1,7) + '.2359';
  Year := IntToStr(17 + StrToInt(Copy(x,1,1))) + Copy(x,2,2);
  x := Copy(x,4,2) + '/' + Copy(x,6,2) + '/' + Year + ' ' + Copy(x,9,2) + ':' + Copy(x,11,2);
  Result := StrToDateTime(x);
end;

procedure TfrmVitals.lstVitalsClick(Sender: TObject);
begin
  with grdVitals do
  begin
    Row := lstVitals.ItemIndex + 1;
    Col := grdVitals.ColCount - 1;
  end;
end;

procedure TfrmVitals.WorksheetChart(test: string; aitems: TStrings);

function OkFloatValue(value: string): boolean;
var
  i, j: integer;
  first, second: string;
begin
  Result := false;
  i := strtointdef(value, -99999);
  if i <> -99999 then Result := true
  else if pos(Pieces(value, '.', 2, 3), '.') > 0 then Result := false
  else
  begin
    first := Piece(value, '.', 1);
    second := Piece(value, '.', 2);
    if length(second) > 0 then
    begin
      i := strtointdef(first, -99999);
      j := strtointdef(second, -99999);
      if (i <> -99999) and (j <> -99999) then Result := true;
    end
    else
    begin
      i :=strtointdef(first, -99999);
      if i <> -99999 then Result := true;
    end;
  end;
end;

var
  datevalue, oldstart, oldend: TDateTime;
  labvalue, labvalue1, labvalue2, labvalue3: double;
  i, numtest, numcol, numvalues, valuecount: integer;
  high, start, stop, value, value1, value2, value3, testcheck, units, testname, testnum, testorder: string;
begin


  valuecount := 0;
  testnum := Piece(test, '^', 1);
  testname := lstVitals.Items[strtoint(testnum) - 1];
  numtest := strtoint(Piece(aitems[0], '^', 1));
  numcol := strtoint(Piece(aitems[0], '^', 2));
  numvalues := strtoint(Piece(aitems[0], '^', 3));
  if numvalues = 0 then
    chtChart.Visible := false
  else
  begin
    chtChart.Visible := true;
    serTest.Clear;  serTestX.Clear;  serTime.Clear;
    if numtest > 0 then
    begin
      for i := 1 to numtest do
        if testnum = Piece(aitems[i], '^', 1) then
        begin
          testorder := inttostr(i);
          break;
        end;
      GetStartStop(start, stop, aitems);
      chtChart.Legend.Color := grdVitals.Color;
      chtChart.Title.Font.Size := MainFontSize;
      chtChart.LeftAxis.Title.Caption := units;
      serTest.Title := Piece(test, '^', 2);
      testcheck := testorder;
      high := '0';
      if testname = 'Blood Pressure' then
      begin
        serTestY.Active := false;
        for i := numtest + numcol + 1 to numtest + numcol + numvalues do
          if Piece(aitems[i], '^', 2) = testcheck then
          begin
            serTestX.Active := true;
            serTestX.Marks.Visible := chkValues.Checked;
            serTestY.Marks.Visible := chkValues.Checked;
            value := Piece(aitems[i], '^', 3);
            value1 := Piece(value, '/', 1);
            value2 := Piece(value, '/', 2);
            value3 := Piece(value, '/', 3);
            if OkFloatValue(value1) and OKFloatValue(value2) then
            begin
              high := value1;
              labvalue1 := strtofloat(value1);
              labvalue2 := strtofloat(value2);
              datevalue := FMToDateTime(Piece(aitems[numtest + strtoint(Piece(aitems[i], '^', 1))], '^', 2));
              serTest.AddXY(datevalue, labvalue1, '', clTeeColor);
              serTestX.AddXY(datevalue, labvalue2, '', clTeeColor);
              inc(valuecount);
              if OKFloatValue(value3) then
              begin
                labvalue3 := strtofloat(value3);
                serTestY.AddXY(datevalue, labvalue3, '', clTeeColor);
                serTestY.Active := true;
              end;
            end;
          end;
        serTest.Title := 'Systolic';
        serTestX.Title := 'Diastolic';
      end    // blood pressure
      else
      begin
        for i := numtest + numcol + 1 to numtest + numcol + numvalues do
          if Piece(aitems[i], '^', 2) = testcheck then
          begin
            serTestX.Active := false;
            serTestY.Active := false;
            value := Piece(aitems[i], '^', 3);
            if OkFloatValue(value) then
            begin
              high := value;
              labvalue := strtofloat(value);
              datevalue := FMToDateTime(Piece(aitems[numtest + strtoint(Piece(aitems[i], '^', 1))], '^', 2));
              serTest.AddXY(datevalue, labvalue, '', clTeeColor);
              inc(valuecount);
            end;
          end;
        serTest.Title := lstVitals.Items[lstVitals.ItemIndex];
      end;   // not blood pressure
      serTime.AddXY(FMToDateTime(start), strtofloat(high), '',clTeeColor);
      serTime.AddXY(FMToDateTime(stop), strtofloat(high), '',clTeeColor);
    end;   // numtest > 0
    if chkZoom.Checked and chtChart.Visible then
    begin
      oldstart := chtChart.BottomAxis.Minimum;
      oldend := chtChart.BottomAxis.Maximum;
      chtChart.UndoZoom;
      chtChart.BottomAxis.Automatic := false;
      chtChart.BottomAxis.Minimum := oldstart;
      chtChart.BottomAxis.Maximum := oldend;
    end
    else
    begin
      chtChart.BottomAxis.Automatic := true;
    end;
    if valuecount = 0 then chtChart.Visible := false;
  end;  // numvalues not 0
end;

procedure TfrmVitals.GetStartStop(var start, stop: string; aitems: TStrings);
var
  numtest, numcol: integer;
begin
  numtest := strtoint(Piece(aitems[0], '^', 1));
  numcol := strtoint(Piece(aitems[0], '^', 2));
  start := Piece(aitems[numtest + 1], '^', 2);
  stop := Piece(aitems[numtest + numcol], '^', 2);
end;

procedure TfrmVitals.grdVitalsSelectCell(Sender: TObject; Col,
  Row: Integer; var CanSelect: Boolean);
begin
  lstVitals.ItemIndex := Row - 1;
  if lstVitals.ItemIndex > -1 then
  begin
    WorksheetChart(inttostr(lstVitals.ItemIndex + 1), tmpGrid);
    if (serTest.Count > 1) and not chkZoom.Checked then
    begin
      chtChart.UndoZoom;
      chtChart.ZoomPercent(ZOOM_PERCENT);
    end;
  end;
end;

procedure TfrmVitals.chkZoomClick(Sender: TObject);
begin
  chtChart.AllowZoom := chkZoom.Checked;
  chtChart.AnimatedZoom := chkZoom.Checked;
  if not chkZoom.Checked then
  begin
    chtChart.UndoZoom;
    if serTest.Count > 1 then chtChart.ZoomPercent(ZOOM_PERCENT);
  end;
end;

procedure TfrmVitals.chk3DClick(Sender: TObject);
begin
  chtChart.View3D := chk3D.Checked;
end;

procedure TfrmVitals.chkValuesClick(Sender: TObject);
begin
  serTest.Marks.Visible := chkValues.Checked;
  if serTestX.Active then serTestX.Marks.Visible := chkValues.Checked;
  if serTestY.Active then serTestY.Marks.Visible := chkValues.Checked;
end;

procedure TfrmVitals.FormShow(Sender: TObject);
begin
  lstDatesClick(self);
end;




procedure TfrmVitals.pnlEnterVitalsResize(Sender: TObject);
begin
  btnEnterVitals.top := pnlEnterVitals.top;
  btnEnterVitals.left := pnlEnterVitals.left;
  btnEnterVitals.height := pnlEnterVitals.height;
  btnEnterVitals.width := pnlEnterVitals.width;
end;

procedure TfrmVitals.btnEnterVitalsClick(Sender: TObject);
begin
  If Encounter.location > 0.0 then //if it has been assigned.
    uVitalLocation := Encounter.Location
  else
    begin
      //assign location
      if Encounter.NeedVisit then
      begin
        UpdateVisit(Font.Size);
        frmFrame.DisplayEncounterText;
      end;
      if Encounter.NeedVisit and (not frmFrame.CCOWDrivedChange) then 
      begin
        InfoBox(TX_NEED_VISIT, TX_NO_VISIT, MB_OK or MB_ICONWARNING);
        exit;                                  {RAB 6/23/98}
      end
      else
        uVitalLocation := Encounter.Location;
    end;

  if (not encounter.needvisit) then
    try
      Application.CreateForm(TfrmVit, frmVit);
      frmvit.showmodal;
      //refresh vital info
      lstDatesClick(self);
    finally
      frmvit.release;
    end;
end;

procedure TfrmVitals.chtChartUndoZoom(Sender: TObject);
begin
  chtChart.BottomAxis.Automatic := true;
end;

procedure TfrmVitals.popValuesClick(Sender: TObject);
begin
  chkValues.Checked := not chkValues.Checked;
  chkValuesClick(self);
end;

procedure TfrmVitals.pop3DClick(Sender: TObject);
begin
  chk3D.Checked := not chk3D.Checked;
  chk3DClick(self);
end;

procedure TfrmVitals.popZoomClick(Sender: TObject);
begin
  chkZoom.Checked := not chkZoom.Checked;
  chkZoomClick(self);
end;

procedure TfrmVitals.popZoomBackClick(Sender: TObject);
begin
  chtChart.UndoZoom;
end;

procedure TfrmVitals.popCopyClick(Sender: TObject);
begin
  chtChart.CopyToClipboardBitmap;
end;

procedure TfrmVitals.popDetailsClick(Sender: TObject);
var
  tmpList: TStringList;
  date1, date2: TFMDateTime;
  strdate1, strdate2: string;
begin
  inherited;
  Screen.Cursor := crHourGlass;
  if chtChart.Tag > 0 then
  begin
    strdate1 := FormatDateTime('mm/dd/yyyy', uDate1);
    strdate2 := FormatDateTime('mm/dd/yyyy', uDate2);
    uDate1 := StrToDateTime(strdate1);
    uDate2 := StrToDateTime(strdate2);
    date1 := DateTimeToFMDateTime(uDate1 + 1);
    date2 := DateTimeToFMDateTime(uDate2);
    StatusText('Retrieving data for ' + FormatDateTime('dddd, mmmm d, yyyy', uDate2) + '...');
    ReportBox(VitalsMemo(Patient.DFN, date1, date2, lstVitals.Items), 'Vitals on ' + Patient.Name + ' for ' + FormatDateTime('dddd, mmmm d, yyyy', uDate2), True);
  end
  else
  begin
    date1 := DateTimeToFMDateTime(chtChart.BottomAxis.Maximum);
    date2 := DateTimeToFMDateTime(chtChart.BottomAxis.Minimum);
    tmpList := TStringList.Create;
    try
      tmpList.Add(lstVitals.Items[lstVitals.ItemIndex]);
      if serTest.Title = 'Systolic' then
        StatusText('Retrieving data for Blood Pressure...')
      else
        StatusText('Retrieving data for ' + serTest.Title + '...');
      ReportBox(VitalsMemo(Patient.DFN, date1, date2, tmpList), serTest.Title + ' results on ' + Patient.Name, True);
    finally
      tmpList.Free;
    end;
  end;
  Screen.Cursor := crDefault;
  StatusText('');
end;

procedure TfrmVitals.chtChartClickSeries(Sender: TCustomChart;
  Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    uDate1 := Series.XValue[ValueIndex];
    uDate2 := uDate1;
    chtChart.Hint := 'Details - Vitals for ' + FormatDateTime('dddd, mmmm d, yyyy', Series.XValue[ValueIndex]) + '...';
    chtChart.Tag := ValueIndex + 1;
  if Button <> mbRight then  popDetailsClick(self);
end;

procedure TfrmVitals.chtChartMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  chtChart.Hint := '';
  chtChart.Tag := 0;
end;

procedure TfrmVitals.chtChartClickLegend(Sender: TCustomChart;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if serTest.Title = 'Systolic' then
    chtChart.Hint := 'Details - for Blood Pressure...'
  else
    chtChart.Hint := 'Details - for ' + serTest.Title + '...';
  chtChart.Tag := 0;
  if Button <> mbRight then  popDetailsClick(self);
end;

procedure TfrmVitals.popChartPopup(Sender: TObject);
begin
  popValues.Checked := chkValues.Checked;
  pop3D.Checked := chk3D.Checked;
  popZoom.Checked := chkZoom.Checked;
  popZoomBack.Enabled := popZoom.Checked and not chtChart.BottomAxis.Automatic;;
  if chtChart.Hint <> '' then
  begin
    popDetails.Caption := chtChart.Hint;
    popDetails.Enabled := true;
  end
  else
  begin
    popDetails.Caption := 'Details...';
    popDetails.Enabled := false;
  end;
end;

procedure TfrmVitals.popPrintClick(Sender: TObject);
var
  GraphTitle: string;
begin
  GraphTitle := lstVitals.Items[lstVitals.ItemIndex] +
                ' - ' +
                lstDates.DisplayText[lstDates.ItemIndex];
  if dlgWinPrint.Execute then PrintGraph(chtChart, GraphTitle);
end;

procedure TfrmVitals.BeginEndDates(var ADate1, ADate2: TFMDateTime; var ADaysBack: integer);
var
  datetemp: TFMDateTime;
  today, datetime1, datetime2: TDateTime;
  relativedate: string;
begin
  today := FMToDateTime(floattostr(FMToday));
  relativedate := Piece(lstDates.ItemID, ';', 1);
  relativedate := Piece(relativedate, '-', 2);
  ADaysBack := strtointdef(relativedate, 0);
  ADate1 := DateTimeToFMDateTime(today - ADaysBack);
  relativedate := Piece(lstDates.ItemID, ';', 2);
  if StrToIntDef(Piece(relativedate, '+', 2), 0) > 0 then
    begin
      relativedate := Piece(relativedate, '+', 2);
      ADaysBack := strtointdef(relativedate, 0);
      ADate2 := DateTimeToFMDateTime(today + ADaysBack + 1);
    end
  else
    begin
      relativedate := Piece(relativedate, '-', 2);
      ADaysBack := strtointdef(relativedate, 0);
      ADate2 := DateTimeToFMDateTime(today - ADaysBack);
    end;
  datetime1 := FMDateTimeToDateTime(ADate1);
  datetime2 := FMDateTimeToDateTime(ADate2);
  if datetime1 < datetime2 then                 // reorder dates, if needed
    begin
      datetemp := ADate1;
      ADate1 := ADate2;
      ADate2 := datetemp
    end;
  ADate1 := ADate1 + 0.2359;
end;

procedure TfrmVitals.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    Close;
  end;  
end;

end.
