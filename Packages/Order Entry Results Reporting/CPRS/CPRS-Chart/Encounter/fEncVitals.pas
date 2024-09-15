unit fEncVitals;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fPCEBase, ORDtTm, StdCtrls, ORCtrls, ExtCtrls, Buttons, fAutoSz, ORFn,
  rvitals, ComCtrls, ORNet, uVitals, VAUtils, TRPCB, VA508AccessibilityManager;

type
  TfrmEncVitals = class(TfrmPCEBase)
    pnlBottom: TPanel;
    lvVitals: TCaptionListView;
    btnEnterVitals: TButton;
    btnOKkludge: TButton;
    btnCancelkludge: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnEnterVitalsClick(Sender: TObject); //vitals lite
  private
    procedure LoadVitalView(VitalsList : TStringList); //Vitals Lite
    procedure LoadVitalsList;
  public
  end;

var
  frmEncVitals: TfrmEncVitals;

implementation

{$R *.DFM}

uses UCore, rCore, rPCE, fPCELex, fPCEOther, fVitals,fVisit, fFrame, fEncnt,
     fEncounterFrame, uInit, VA508AccessibilityRouter, System.UITypes, rMisc,
     VAPieceHelper;

procedure TfrmEncVitals.FormCreate(Sender: TObject);
begin
  inherited;
  FTabName := CT_VitNm;
end;

procedure TfrmEncVitals.FormDestroy(Sender: TObject);
begin
  UnloadVitalsDLL;
  inherited;
end;

procedure TfrmEncVitals.FormShow(Sender: TObject);
var
 tmpRtnRec: TDllRtnRec;
begin
  inherited;
  {Visit is Assumed to Be selected when Opening Encounter Dialog}
  tmpRtnRec := LoadVitalsDLL;
  case tmpRtnRec.Return_Type of
    DLL_Success: LoadVitalsList;
    DLL_Missing: TaskMessageDlg('File Missing or Invalid', tmpRtnRec.Return_Message,mtError,[mbok],0);
    DLL_VersionErr: TaskMessageDlg('Incorrect Version Found', tmpRtnRec.Return_Message,mtError,[mbok],0);
  end;
  FormActivate(Sender);
end;

procedure TfrmEncVitals.LoadVitalView(VitalsList: TStringList);

  procedure CombineMetricandImperial(aVitalsList: TStringList);
  const
    MetricColHeader = 'Metric Value';
    ImperialColHeader = 'USS Value';
    NewColName = 'Value';
  var
    ImperialIdx, MetricIdx: Integer;
    aCprsStr: TPiece;
    aStr, MetricStr, ImperialStr: string;
    I: Integer;
    MetricFirst: Boolean;
  begin
    if aVitalsList.Count = 0 then
      exit;
    //Find the piece that contains the metric header and value
    aCprsStr := TPiece(aVitalsList.Strings[0]);
    MetricIdx := TPiece(aVitalsList.Strings[0]).IndexOfPiece(U, MetricColHeader);
    ImperialIdx := TPiece(aVitalsList.Strings[0]).IndexOfPiece(U, ImperialColHeader);
    MetricFirst := SystemParameters.AsTypeDef<string>('vitals.gmvMetricFirst', '0') = '1';
    for I := 0 to aVitalsList.Count - 1 do
    begin
      aStr := aVitalsList[i];
      if I > 0 then
      begin
        // merge and remove the values
        MetricStr := Piece(aStr, U, MetricIdx);
        if Trim(MetricStr) > '' then
        begin
          if MetricFirst then
          begin
            ImperialStr := Piece(aStr, U, ImperialIdx);
            SetPiece(aStr, U, ImperialIdx, '(' + ImperialStr + ')');
            SetPiece(aStr, U, ImperialIdx, TPiece(aStr).Pieces([MetricIdx, ImperialIdx], U, ' '));
          end else begin
            SetPiece(aStr, U, MetricIdx, '(' + MetricStr + ')');
            SetPiece(aStr, U, ImperialIdx, TPiece(aStr).Pieces([ImperialIdx, MetricIdx], U, ' '));
          end;
        end;
      end else
        SetPiece(aStr, U, ImperialIdx, NewColName);

      aCprsStr := TPiece(aStr);
      aCprsStr.DeletePiece(U, MetricIdx);
      aVitalsList[i] := string(aCprsStr);

    end;
  end;

var
  i : integer;
  curCol : TListColumn;
  curItem : TListItem;
  HeadingList,tmpList : TStringList;
begin
  HeadingList := TStringList.Create;
  tmpList := TStringList.Create;
  try
    lvVitals.ShowColumnHeaders := false;                //CQ: 10069 - the column display becomes squished.
    lvVitals.Items.Clear;
    lvVitals.Columns.Clear;
    CombineMetricandImperial(VitalsList);
    if VitalsList.Count > 0 then
      PiecesToList(VitalsList[0],U,HeadingList);
    for i := 0 to HeadingList.Count-1 do
    begin
      curCol := lvVitals.Columns.Add;
      curCol.Caption := HeadingList[i];
      curCol.AutoSize := true;
    end;
    for i := 1 to VitalsList.Count-1 do
    begin
      curItem := lvVitals.Items.Add;
      PiecesToList(VitalsList[i],U,tmpList);
      if tmpList.Count > 0 then
      begin
        curItem.Caption := tmpList[0];
        tmpList.Delete(0);
      end;
      curItem.SubItems.Assign(tmpList);
    end;
    lvVitals.ShowColumnHeaders := true;                 //CQ: 10069 - the column display becomes squished.
  finally
    HeadingList.Free;
    tmpList.Free;
  end;
end;

procedure TfrmEncVitals.btnEnterVitalsClick(Sender: TObject);
var
  Info: String;
begin
  inherited;

  Info := frmFrame.PatientInfoLabelCaption;

  if EnterPatientVitals(RPCBrokerV, Patient, uEncPCEData, Info) then
    LoadVitalsList;
end;

procedure TfrmEncVitals.LoadVitalsList;
var
  VitalsList : TStringList;
begin
  VitalsList := TStringList.Create;
  try
    if LatestVitalsList(RPCBrokerV, Patient, U, false, VitalsList) then
    begin
      if VitalsList.Count > 0 then
        LoadVitalView(VitalsList);
    end;
  finally
    VitalsList.Free;
  end;
end;

initialization
  SpecifyFormIsNotADialog(TfrmEncVitals);
end.
