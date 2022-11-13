unit fOptionsReportsCustom;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Spin, ORCtrls, fOptions, ComCtrls, ORFn, ORNet, Grids, uConst,
  ORDtTm, rCore, fBase508Form, VA508AccessibilityManager;

type
  TfrmOptionsReportsCustom = class(TfrmBase508Form)
    Panel1: TPanel;
    Bevel3: TBevel;
    btnApply: TButton;
    btnCancel: TButton;
    Panel2: TPanel;
    grdReport: TCaptionStringGrid;
    edtMax: TCaptionEdit;
    odbStop: TORDateBox;
    odbStart: TORDateBox;
    odbTool: TORDateBox;
    btnOK: TButton;
    Panel3: TPanel;
    edtSearch: TCaptionEdit;
    Label1: TLabel;
    function ValFor(ACol, ARow: Integer): string;
    procedure FormCreate(Sender: TObject);
    procedure grdReportMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure grdReportKeyPress(Sender: TObject; var Key: Char);
    procedure grdReportDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure UMDelayEvent(var Message: TMessage); Message UM_DELAYEVENT;
    procedure edtMaxExit(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure odbStartExit(Sender: TObject);
    procedure odbStopExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure odbStartKeyPress(Sender: TObject; var Key: Char);
    procedure odbStopKeyPress(Sender: TObject; var Key: Char);
    procedure edtMaxKeyPress(Sender: TObject; var Key: Char);
    procedure btnOKClick(Sender: TObject);
    procedure edtSearchChange(Sender: TObject);
    procedure edtSearchKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure grdReportKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    //startDate,endDate,
    maxOcurs,signal: integer;
    rptList: TStringList;
    fDropColumn: Integer;
    sDate,eDate: string;
    procedure ShowEditor(ACol, ARow: Integer; AChar: Char);
  public
    { Public declarations }
  end;
var
  frmOptionsReportsCustom: TfrmOptionsReportsCustom;
  const
    Col_StartDate = 1;
    Col_StopDate  = 2;
    Col_Max       = 3;
    TAB           = #9;
procedure DialogOptionsHSCustom(topvalue, leftvalue, fontsize: integer; var actiontype: Integer);

implementation

uses rOptions, uOptions, fReports, fLabs, uCore, VAUtils;

{$R *.DFM}

procedure TfrmOptionsReportsCustom.UMDelayEvent(var Message: TMessage);
{ after focusing events are completed for a combobox, set the key the user typed }
begin
  case Message.LParam of
  Col_StartDate:
    begin
      odbStart.Visible := True;
      odbStart.Text := Chr(Message.WParam);
    end;
  COL_StopDate :
    begin
      odbStop.Visible := True;
      odbStop.Text := Chr(Message.WParam);
    end;
  COL_Max      :
    begin
      edtMax.Visible := True;
      edtMax.Text := Chr(Message.WParam);
    end;
  end;
end;

procedure DialogOptionsHSCustom(topvalue, leftvalue, fontsize: integer; var actiontype: Integer);
var
  frmOptionsReportsCustom: TfrmOptionsReportsCustom;
begin
  frmOptionsReportsCustom := TfrmOptionsReportsCustom.Create(Application);
  actiontype := 0;
  try
    with frmOptionsReportsCustom do
    begin
      if (topvalue < 0) or (leftvalue < 0) then
        Position := poScreenCenter
      else
      begin
        Position := poDesigned;
        Top := topvalue;
        Left := leftvalue;
      end;
      ResizeAnchoredFormToFont(frmOptionsReportsCustom);
      // grdReport draws on the canvas which is a different font than the control;
      // Default drawing set to true duplicated the text in each selected cell
      grdReport.Canvas.Font := Label1.Font;
      grdReport.DefaultRowHeight := 24;
      ShowModal;
      actiontype := btnApply.Tag;
    end;
  finally
    frmOptionsReportsCustom.Release;
  end;
end;

procedure TfrmOptionsReportsCustom.FormCreate(Sender: TObject);
begin
  inherited;
  rptList := TStringList.Create;
end;

procedure TfrmOptionsReportsCustom.FormDestroy(Sender: TObject);
begin
  inherited;
  rptList.Free;
end;

procedure TfrmOptionsReportsCustom.ShowEditor(ACol, ARow: Integer; AChar: Char);

    procedure PlaceControl(AControl: TWinControl);
    var
        ARect: TRect;
    begin
        with AControl do
        begin
            ARect := grdReport.CellRect(ACol, ARow);
            SetBounds(ARect.Left + grdReport.Left + 2, ARect.Top + grdReport.Top + 2,
                ARect.Right - ARect.Left - 1 , ARect.Bottom-ARect.Top -1 );
            Visible := True;
            Tag := ARow;
            BringToFront;
            Show;
            SetFocus;
        end;
    end;
    procedure Synch(AEdit: TEdit; const edtText: string);
    begin
        AEdit.Text := edtText;
        AEdit.SelectAll;
    end;
begin
  inherited;
  if ARow = 0 then Exit;  //header row
  with grdReport do if (ARow = Pred(RowCount)) and (ACol > 4 ) then Exit;
  case ACol of
  Col_StartDate: begin
    if (ARow > 0 ) then
      begin
        PlaceControl(odbStart);
        Synch(odbStart,ValFor(Col_StartDate,ARow));
        if AChar <> #0 then PostMessage(Handle, UM_DELAYEVENT, Ord(AChar), COL_StartDate);
      end;
    end;
  Col_StopDate: begin
    if (ARow > 0 ) then
      begin
        PlaceControl(odbStop);
        Synch(odbStop, ValFor(Col_StopDate,ARow));
        if AChar <> #0 then PostMessage(Handle, UM_DELAYEVENT, Ord(AChar), COL_StopDate);
      end;
    end;
  Col_Max: begin
    if (ARow > 0 ) and (StrToInt(ValFor(Col_Max,ARow)) > 0) then
      begin
        PlaceControl(edtMax);
        Synch(edtMax, ValFor(Col_Max,ARow));
        fDropColumn := Col_Max;
        if AChar <> #0 then PostMessage(Handle, UM_DELAYEVENT, Ord(AChar), COL_Max);
      end;
    end;
  end;
end;

function TfrmOptionsReportsCustom.ValFor(ACol, ARow: Integer): string;
begin
   Result := grdReport.Cells[ACol, ARow];
end;

procedure TfrmOptionsReportsCustom.grdReportKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if grdReport.Col = 1 then
    sDate := grdReport.Cells[grdReport.Col,grdReport.Row];
  if grdReport.Col = 2 then
    eDate := grdReport.Cells[grdReport.Col,grdReport.Row];
  if (grdReport.Col = 3) and (grdReport.Cells[grdReport.Col, grdReport.Row]='') then
      Exit else if Length(grdReport.Cells[3, grdReport.Row]) > 0 then maxOcurs := StrToInt( grdReport.Cells[3,grdReport.Row]);
  if Key = #13 then ShowEditor(grdReport.Col, grdReport.Row, #0);
  if Key = #9 then
    begin
      odbStart.Visible := False;
      odbStop.Visible := False;
      edtMax.Visible := False;
      ShowEditor(grdReport.Col, grdReport.Row, #0);
    end;
  if CharInSet(Key, [#32..#127]) then ShowEditor(grdReport.Col, grdReport.Row, Key);
 signal := 0;
end;

procedure TfrmOptionsReportsCustom.grdReportMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ACol,ARow: integer;
begin
  inherited;
  if (not User.ToolsRptEdit) then // For users with Reports settings edit parameter not set.
  begin
    abort;
    exit;
  end;
  grdReport.MouseToCell(X,Y,ACol,ARow);
  if (ARow < 1) or (ACol < 1) then
    begin
      odbStop.Visible := False;
      odbStart.Visible := False;
      edtMax.Visible := False;
      Exit;
    end;
  if ACol = 1 then
    begin
      odbStop.Visible := False;
      edtMax.Visible := False;
      sDate := grdReport.Cells[1,ARow];
      ShowEditor(ACol, ARow, #0);
    end;
  if ACol = 2 then
    begin
      odbStart.Visible := False;
      edtMax.Visible := False;
      eDate := grdReport.Cells[2,ARow];
      ShowEditor(ACol, ARow, #0);
    end;
  if (ACol = 3) and (grdReport.Cells[ACol,ARow]='') then
    begin
      odbStart.Visible := False;
      odbStop.Visible := False;
      Exit;
    end
  else if (ACol = 3) and (strtoint(grdReport.Cells[ACol,ARow])>0) then
    begin
      odbStart.Visible := False;
      odbStop.Visible := False;
      maxOcurs := strtoint(grdReport.Cells[ACol,ARow]);
      ShowEditor(ACol, ARow, #0);
    end
  else
    begin
      grdReport.Col := 0;
      grdReport.Row := ARow;
    end;
  signal := 0;
end;

procedure TfrmOptionsReportsCustom.grdReportDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
 inherited;
 grdReport.Canvas.TextRect(Rect, Rect.Left+2, Rect.Top+2,
    Piece(grdReport.Cells[ACol, ARow], TAB, 1));

end;

procedure TfrmOptionsReportsCustom.edtMaxExit(Sender: TObject);
var
  newValue: String;
  code, I: integer;
begin
  if edtMax.Modified then
    begin
      newValue := edtMax.Text;
      if length(newValue) = 0 then
        begin
          InfoBox('Invalid value of max occurences', 'Warning', MB_OK or MB_ICONWARNING);
          edtMax.Text := IntToStr(maxOcurs);
          edtMax.SetFocus;
          edtMax.SelectAll;
        end;
      if length(newValue) > 0 then
        begin
          Val(newValue, I, code);
          if I = 0 then begin end; //added to keep compiler from generating a hint
          if code <> 0 then
             begin
              InfoBox('Invalid value of max occurences', 'Warning', MB_OK or MB_ICONWARNING);
              edtMax.Text := IntToStr(maxOcurs);
              edtMax.SetFocus;
              edtMax.SelectAll;
             end;
          if code = 0 then
            begin
              if strtoint(edtMax.Text) <= 0 then
              begin
                InfoBox('the value of max should be greater than 0', 'Warning', MB_OK or MB_ICONWARNING);
                edtMax.Text := intToStr(maxOcurs);
                edtMax.SetFocus;
                edtMax.SelectAll;
                exit;
              end;
              grdReport.Cells[Col_Max, edtMax.Tag] := edtMax.Text;
              if compareStr(Piece(Piece(grdReport.Cells[0,edtMax.Tag],TAB,2),'^',2),'M')=0 then
              begin
                 edtMax.Visible := False;
                 btnApply.Enabled := True;
                 Exit;
              end;
              grdReport.Cells[0,edtMax.Tag] := grdReport.Cells[0,edtMax.Tag] + '^M';
              edtMax.Visible := False;
              btnApply.Enabled := True;
            end;
        end;
    end;
end;

procedure TfrmOptionsReportsCustom.btnApplyClick(Sender: TObject);
var
  valueStartdate, valueStopdate,valueMax, rpt, values,name: string;
  i: integer;
begin
   for i := 1 to grdReport.RowCount do
      begin
          if CompareStr(Piece(Piece( grdReport.Cells[0,i],TAB,2),'^',2),'M')=0 then
          begin
             rpt := Piece(Piece( grdReport.Cells[0,i],TAB,2),'^',1);
             name := Piece( grdReport.Cells[0,i],TAB,1);
             odbTool.Text := grdReport.Cells[1,i];
             valueStartDate := odbTool.RelativeTime;
             odbTool.Text := grdReport.Cells[2,i];
             valueStopDate := odbTool.RelativeTime;
             valueMax := grdReport.Cells[3,i];
             if Length(valueMax)<1 then
                valueMax := '7';
             values := valueStartdate + ';' + valueStopDate + ';' + valueMax;
{             if CompareStr(name,'Imaging (local only)')=0 then // imaging report id is hard coded to be 10000
               values := valueStartdate + ';' + valueStopDate + ';;;' + valueMax
             else}
             rpcSetIndividualReportSetting(rpt, values);
          end;
      end;
   btnApply.Enabled := False;
   odbStart.Visible := False;
   odbStop.Visible := False;
   edtMax.Visible := False;
   frmReports.LoadTreeView;
   frmLabs.LoadTreeView;
   with frmReports.tvReports do
     begin
       if Items.Count > 0 then
         Selected := Items.GetFirstNode;
       frmReports.tvReportsClick(Selected);
     end;
   with frmLabs.tvReports do
     begin
       if Items.Count > 0 then
         Selected := Items.GetFirstNode;
       frmReports.tvReportsClick(Selected);
     end;
end;

procedure TfrmOptionsReportsCustom.btnCancelClick(Sender: TObject);
begin
  rptList.Clear;
  Close;
end;


procedure TfrmOptionsReportsCustom.odbStartExit(Sender: TObject);
const
  TX_BAD_START   = 'The start date is not valid.';
  TX_STOPSTART   = 'The start date must not be after the stop date.';
var
  x,ErrMsg,datestart,datestop: String;
begin
    if odbStart.text = '' then
    begin
      InfoBox(TX_BAD_START, 'Warning', MB_OK or MB_ICONWARNING);
      odbStart.Visible := True;
      odbStart.Text := sDate;
      odbStart.Setfocus;
      odbStart.SelectAll;
      exit;
    end;
    if odbStart.Text = sDate then
      exit;
    ErrMsg := '';
    odbStart.Validate(x);
    if Length(x) > 0 then
      begin
        ErrMsg := TX_BAD_START;
        InfoBox(TX_BAD_START, 'Warning', MB_OK or MB_ICONWARNING);
        odbStart.Visible := True;
        odbStart.Text := sDate;
        odbStart.Setfocus;
        odbStart.SelectAll;
        exit;
      end;
    datestart := odbStart.RelativeTime;
    datestop := MakeRelativeDateTime(
          StrToFMDateTime(grdReport.Cells[Col_StopDate,odbStart.Tag])
       );
    delete(datestart,1,1);
    delete(datestop,1,1);
    if StrToIntDef(datestart,0)> StrToIntDef(datestop,0) then
    begin
      InfoBox(TX_STOPSTART, 'Warning', MB_OK or MB_ICONWARNING);
      odbStart.Text := grdReport.Cells[Col_StopDate,odbStart.Tag];
      odbStart.SetFocus;
      odbStart.SelectAll;
      exit;
    end;
    grdReport.Cells[Col_StartDate, odbStart.Tag] := DateToStr(FMDateTimeToDateTime(odbStart.FMDateTime));
    odbStart.Visible := False;
    btnApply.Enabled := True;
    if compareStr(Piece(Piece(grdReport.Cells[0,odbStart.Tag],TAB,2),'^',2),'M')=0 then
        Exit;
    grdReport.Cells[0,odbStart.Tag] := grdReport.Cells[0,odbStart.Tag] + '^M';
end;

procedure TfrmOptionsReportsCustom.odbStopExit(Sender: TObject);
const
  TX_BAD_STOP    = 'The stop date is not valid.';
  TX_BAD_ORDER   = 'The stop date must not be earlier than start date.';
var
  x, ErrMsg,datestart,datestop: string;
begin
    if odbStop.text = '' then
    begin
      InfoBox(TX_BAD_STOP, 'Warning', MB_OK or MB_ICONWARNING);
      odbStop.Visible := True;
      odbStop.Text := eDate;
      odbStop.Setfocus;
      odbStop.SelectAll;
      exit;
    end;

   if odbStop.Text = eDate then
      exit;

    ErrMsg := '';
    odbStop.Validate(x);
    if Length(x) > 0 then
      begin
        ErrMsg := TX_BAD_STOP;
        InfoBox(TX_BAD_STOP, 'Warning', MB_OK or MB_ICONWARNING);
        odbStop.Visible := True;
        odbStop.Text := eDate;
        odbStop.Setfocus;
        odbStop.SelectAll;
        exit;
      end;

    datestart := MakeRelativeDateTime(
          StrToFMDateTime(grdReport.Cells[Col_StartDate,odbStop.Tag])
       );
    datestop := odbStop.RelativeTime;
    delete(datestart,1,1);
    delete(datestop,1,1);
    if StrToIntDef(datestart,0)> StrToIntDef(datestop,0) then
    begin
      InfoBox(TX_BAD_ORDER, 'Warning', MB_OK or MB_ICONWARNING);
      odbStop.Text := grdReport.Cells[Col_StartDate,odbStop.Tag];
      odbStop.SetFocus;
      odbStop.SelectAll;
      exit;
    end;
    grdReport.Cells[Col_StopDate, odbStop.Tag] := DateToStr(FMDateTimeToDateTime(odbStop.FMDateTime));
    odbStop.Visible := False;
    btnApply.Enabled := True;
    if compareStr(Piece(Piece(grdReport.Cells[0,odbStop.Tag],TAB,2),'^',2),'M')=0 then
       Exit;
    grdReport.Cells[0,odbStop.Tag] := grdReport.Cells[0,odbStop.Tag] + '^M';
end;


procedure TfrmOptionsReportsCustom.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Close;
  rptList.Clear;
end;

procedure TfrmOptionsReportsCustom.odbStartKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    odbStart.Visible := False;
    Perform(WM_NextDlgCtl, 0, 0);
    exit;
  end;
end;

procedure TfrmOptionsReportsCustom.odbStopKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    odbStop.Visible := False;
    Perform(WM_NextDlgCtl, 0, 0);
    exit;
  end;
end;

procedure TfrmOptionsReportsCustom.edtMaxKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    edtMax.Visible := False;
    Perform(WM_NextDlgCtl, 0, 0);
    exit;
  end;
end;

procedure TfrmOptionsReportsCustom.btnOKClick(Sender: TObject);
begin
  if btnApply.Enabled then
    btnApplyClick(self);
  Close;
end;

procedure TfrmOptionsReportsCustom.edtSearchChange(Sender: TObject);
var
  i: integer;
  needle,hay: String;
  selRect: TGridRect;

begin
  if (edtSearch.Modified) and (signal=0) then
    begin
      needle := UpperCase(edtSearch.text);
      if length(needle)=0 then
        begin
          selRect.Left := 0;
          selRect.Top := 1;
          selRect.Right := 0;
          selRect.Bottom := 1;
          grdReport.Selection := selRect;
          grdReport.TopRow := 1;
          exit;
        end;
      for i := 1 to grdReport.RowCount do
        begin
          hay := Piece(UpperCase(grdReport.Cells[0,i]),TAB,1);
          hay := Copy(hay,0,length(needle));
          if Pos(needle, hay) > 0 then
            begin
              selRect.Left := 0;
              selRect.Top := i;
              selRect.Right := 0;
              selRect.Bottom := i;
              grdReport.Selection := selRect;
              grdReport.TopRow := i;
              exit;
            end;
        end;
    end;
  if (edtSearch.Modified) and (signal=1) then
    begin
      signal := 0;
    end;
  Exit;
end;

procedure TfrmOptionsReportsCustom.edtSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    Perform(WM_NextDlgCtl, 0, 0);
    edtSearch.Text := '';
    exit;
  end;
end;

procedure TfrmOptionsReportsCustom.FormShow(Sender: TObject);
var
    i,rowNum: integer;
    startOff,stopOff: string;
    today: TFMDateTime;
begin
    today := FMToday;
    signal := 0;

    if CallVistA('ORWTPD GETSETS',[nil],rptList) then
      MixedCaseList(rptList);

    SortByPiece(rptList,'^',2);
    rowNum := rptList.Count;
    grdReport.RowCount := rowNum + 1;
    grdReport.Cells[0,0] := 'Report Name';
    grdReport.Cells[1,0] := 'Start Date';
    grdReport.Cells[2,0] := 'Stop Date';
    grdReport.Cells[3 ,0] := 'Max';

    for i := 1 to grdReport.RowCount-1 do
    begin
      grdReport.Cells[0,i] := Piece(rptList[i-1],'^',2)+ TAB + Piece(rptList[i-1],'^',1);
      startOff := Piece(Piece(rptList[i-1],'^',3),';',1);
      stopOff := Piece(Piece(rptList[i-1],'^',3),';',2);
      delete(startOff,1,1);
      delete(stopOff,1,1);
      grdReport.Cells[1,i] := DateToStr(FMDateTimeToDateTime(FMDateTimeOffsetBy(today, StrToIntDef(startOff,0))));
      grdReport.Cells[2,i] := DateToStr(FMDateTimeToDateTime(FMDateTimeOffsetBy(today, StrToIntDef(stopOff,0))));
      grdReport.Cells[3,i] := Piece(Piece(rptList[i-1],'^',3),';',3);
    end;
    if not edtSearch.Focused then
      edtSearch.SetFocus;
    btnCancel.Caption := 'Cancel';
    if (not User.ToolsRptEdit) then // For users with Reports settings edit parameter not set.
      begin
        grdReport.onKeyPress := nil;
        grdReport.onMouseDown := nil;
        odbStart.readOnly := true;
        odbStart.onExit := nil;
        odbStart.onKeyPress := nil;
        odbStop.readOnly := true;
        odbStop.onExit := nil;
        odbStop.onKeyPress := nil;
        edtMax.readOnly := true;
        odbTool.readOnly := true;
        btnOK.visible := false;
        btnApply.visible := false;
        btnCancel.Caption := 'Close';
      end;
end;

procedure TfrmOptionsReportsCustom.grdReportKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_TAB) then
  begin
    if ssShift in Shift then
    begin
      EdtSearch.SetFocus;
      Key := 0;
    end
    else if ssCtrl	in Shift then
    begin
      if User.ToolsRptEdit then
        btnApply.SetFocus
      else
        btnCancel.SetFocus;
      Key := 0;
    end;
  end;
  if Key = VK_ESCAPE then begin
    EdtSearch.SetFocus;
    Key := 0;
  end;
end;

end.

