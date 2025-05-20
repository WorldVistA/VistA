unit oCoverSheet;
{
  ================================================================================
  *
  *       Application:  CPRS - Coversheet controller object
  *       Developer:    dan.petit@domain.ext
  *       Site:         Salt Lake City ISC
  *       Date:         2015-12-04
  *
  *       Description:  Primary (Singleton) Coversheet Controller
  *
  *       Notes:
  *
  ================================================================================
}

interface

uses
  Dialogs,
  System.Classes,
  System.SysUtils,
  System.Generics.Collections,
  System.Types,
  System.StrUtils,
  Vcl.Controls,
  Vcl.ExtCtrls,
  Vcl.Graphics,
  iGridPanelIntf,
  iCoverSheetIntf;

type
  TCoverSheet = class(TInterfacedObject, ICoverSheet, ICPRS508, ICPRSTab)
  private
    fUniqueID: string;
    fIPAddress: string;
    fParamList: ICoverSheetParamList;
    fControls: TObjectList<TControl>;
    fCoverSheetRows: array of IGridPanelDisplay;
    fFontSize: integer;
    fScreenReaderActive: boolean;
    fGridSettings: ICoverSheetGrid;

    { External event pointers }
    fOnRefreshCWAD: TNotifyEvent;
    fOnRefreshReminders: TNotifyEvent;

    { External RefreshCWAD event support }
    function getOnRefreshCWAD: TNotifyEvent;
    procedure setOnRefreshCWAD(const aValue: TNotifyEvent);
    procedure fRefreshCWAD(Sender: TObject);

    { External RefreshReminders event support }
    function getOnRefreshReminders: TNotifyEvent;
    procedure setOnRefreshReminders(const aValue: TNotifyEvent);
    procedure fRefreshReminders(Sender: TObject);

    function getParams: ICoverSheetParamList;
    function getUniqueID: string;
    function getIPAddress: string;
    function getIsFinishedLoading: boolean;
    function getPanelCount: integer;
  protected
    { ICPRS508 }
    procedure OnFocusFirstControl(Sender: TObject); virtual;
    procedure OnSetFontSize(Sender: TObject; aNewSize: integer); virtual;
    procedure OnSetScreenReaderStatus(Sender: TObject; aActive: boolean); virtual;

    { ICPRSTab }
    procedure OnClearPtData(Sender: TObject); virtual;
    procedure OnDisplayPage(Sender: TObject; aCallingContext: integer); virtual;
    procedure OnLoaded(Sender: TObject); virtual;

    { ICoverSheet }
    procedure OnDisplay(Sender: TObject; aGridPanel: TGridPanel); virtual; final;
    procedure OnExpandAllPanels(Sender: TObject); virtual; final;
    procedure OnInitCoverSheet(Sender: TObject); virtual; final;
    procedure OnRefreshPanel(Sender: TObject; aPanelID: integer); virtual; final;
    procedure OnSwitchToPatient(Sender: TObject; aDFN: string); virtual;
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  oCoverSheetGrid,
  oCoverSheetParam_CPRS,
  oCoverSheetParam_CPRS_ActiveMeds,
  oCoverSheetParam_CPRS_Allergies,
  oCoverSheetParam_CPRS_Appts,
  oCoverSheetParam_CPRS_Immunizations,
  oCoverSheetParam_CPRS_Labs,
  oCoverSheetParam_CPRS_Postings,
  oCoverSheetParam_CPRS_ProblemList,
  oCoverSheetParam_CPRS_Reminders,
  oCoverSheetParam_CPRS_Vitals,
  oCoverSheetParam_CPRS_WH,
  oCoverSheetParam_WidgetClock,
  oCoverSheetParam_Web,
  oCoverSheetParamList,
  ORFn,
  ORNet;

{ TCoverSheet }

constructor TCoverSheet.Create;
begin
  inherited Create;
  TCoverSheetParamList.Create.GetInterface(ICoverSheetParamList, fParamList);
  fControls := TObjectList<TControl>.Create;
  fControls.OwnsObjects := False;
  fUniqueID := NewGUID;
  fIPAddress := DottedIPStr;
  fOnRefreshCWAD := fRefreshCWAD;
  fFontSize := 8;
  fScreenReaderActive := False;
  SetLength(fCoverSheetRows, 0);
  TCoverSheetGrid.Create.GetInterface(ICoverSheetGrid, fGridSettings);
end;

destructor TCoverSheet.Destroy;
begin
  fParamList := nil;
  fControls.Clear;
  FreeAndNil(fControls);
  SetLength(fCoverSheetRows, 0);
  inherited;
end;

procedure TCoverSheet.OnClearPtData(Sender: TObject);
var
  aControl: TControl;
  aCPRSTab: ICoverSheetDisplayPanel;
begin
  for aControl in fControls do
    if Supports(aControl, ICoverSheetDisplayPanel, aCPRSTab) then
      aCPRSTab.OnClearPtData(Sender);
end;

procedure TCoverSheet.OnDisplayPage(Sender: TObject; aCallingContext: integer);
begin
  //
end;

procedure TCoverSheet.OnLoaded(Sender: TObject);
begin
  //
end;

procedure TCoverSheet.OnDisplay(Sender: TObject; aGridPanel: TGridPanel);
var
  aParam: ICoverSheetParam;
  aDisplayPanel: ICoverSheetDisplayPanel;
  aGridPanelFrame: IGridPanelFrame;
  aCPRS508: ICPRS508;
  aControl: TControl;
  aIndex: integer;
  aGridPanelRow: TGridPanel;
  aCol: integer;
  aRow: integer;
begin
  try
    fGridSettings.PanelCount := fParamList.Count;

    aGridPanel.Visible := False;
    aGridPanel.Align := alNone;

    { NOTE: Actual controls are free'd aGridPanel.ControlCollection.Clear }
    fControls.Clear;
    aGridPanel.ControlCollection.Clear;
    aGridPanel.RowCollection.Clear;
    aGridPanel.ColumnCollection.Clear;

    { Make sure we have ONLY 1 column }
    aGridPanel.ColumnCollection.Add;

    { Make sure we have enough rows }
    while aGridPanel.RowCollection.Count < fGridSettings.RowCount do
      aGridPanel.RowCollection.Add;

    { Build the rows as plain TGridPanels but store their interfaces in fCoverSheetRows }
    SetLength(fCoverSheetRows, aGridPanel.RowCollection.Count);
    for aIndex := 0 to aGridPanel.RowCollection.Count - 1 do
      begin
        { Get new TGridPanel for the row in aIndex }
        NewGridPanel(aGridPanel, 1, 1, aGridPanelRow);
        aGridPanelRow.Name := Format('%s_Row_%d', [aGridPanelRow.ClassName, aIndex]);
        aGridPanelRow.Parent := aGridPanel;

        { Add this TGridPanel the main Grid at Col 0, Row aIndex }
        aGridPanel.ControlCollection.AddControl(aGridPanelRow, 0, aIndex);

        { Create new IGridPanelDisplay for this TGridPanel Row and place it in fCoverSheetRows }
        NewGridPanelDisplay(aGridPanelRow, fCoverSheetRows[aIndex]);
      end;

    { Finally, we can start building and placing the frames into the fCoverSheetRows[] panels }
    for aIndex := 0 to fParamList.Count - 1 do
      begin
        aParam := fParamList.ParamByIndex[aIndex];
        aParam.DisplayRow := fGridSettings.PanelRow[aIndex];
        aParam.DisplayColumn := fGridSettings.PanelColumn[aIndex];

        aControl := aParam.NewCoverSheetControl(aGridPanel);
        fControls.Add(aControl);

        { Set up the frame as an IGridPanelFrame }
        if aControl.GetInterface(IGridPanelFrame, aGridPanelFrame) then
          begin
            aGridPanelFrame.Title := aParam.Title;
            aGridPanelFrame.AllowCollapse := gpcColumn;
            aGridPanelFrame.AllowRefresh := True;
          end;

        { Assign the parameter to the frame }
        if Supports(aControl, ICoverSheetDisplayPanel, aDisplayPanel) then
          aDisplayPanel.Params := aParam;

        { Hook up the 508 'stuff' }
        if Supports(aControl, ICPRS508, aCPRS508) then
          begin
            aCPRS508.OnSetFontSize(Self, fFontSize);
            aCPRS508.OnSetScreenReaderStatus(Self, fScreenReaderActive);
          end;

        { Make sure we have enough columns in this row (we are now using IGridPanelDisplay) }
        while (fCoverSheetRows[aParam.DisplayRow].ColumnCount - 1) < aParam.DisplayColumn do
          fCoverSheetRows[aParam.DisplayRow].AddColumn;

        { Finally add the control }
        fCoverSheetRows[aParam.DisplayRow].AddControl(aControl, aParam.DisplayColumn, 0, alClient);
      end;

    { We have a complete set of frames in the Main TGridPanel and it's rows!!! Align some stuff }
    try
      aGridPanel.RowCollection.BeginUpdate;
      for aRow := 0 to aGridPanel.RowCollection.Count - 1 do
        begin
          aGridPanel.RowCollection[aRow].SizeStyle := ssPercent;
          aGridPanel.RowCollection[aRow].Value := (100 / aGridPanel.RowCollection.Count);
          for aCol := 0 to fCoverSheetRows[aRow].ColumnCount - 1 do
            begin
              fCoverSheetRows[aRow].ColumnStyle[aCol] := ssPercent;
              fCoverSheetRows[aRow].ColumnValue[aCol] := (100 / fCoverSheetRows[aRow].ColumnCount);
            end;
          fCoverSheetRows[aRow].AlignGrid;
        end;
    finally
      aGridPanel.RowCollection.EndUpdate;
    end;

    aGridPanel.Align := alClient;
    aGridPanel.Show;
    aGridPanel.Repaint;
  except
    on e: Exception do
      raise ECoverSheetException.CreateFmt('ECoverSheetException: Error: %s', [e.Message]);
  end;
end;

procedure TCoverSheet.OnExpandAllPanels(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to High(fCoverSheetRows) do
    fCoverSheetRows[i].ExpandAllControls;
end;

function TCoverSheet.getIsFinishedLoading: boolean;
var
  aControl: TControl;
  aCoverSheetDisplayPanel: ICoverSheetDisplayPanel;
  aList: TStringList;
begin
  Result := True;
  aList := TStringList.Create;
  try
    for aControl in fControls do
      if Supports(aControl, ICoverSheetDisplayPanel, aCoverSheetDisplayPanel) then
        if not aCoverSheetDisplayPanel.IsFinishedLoading then
          begin
            aList.Add(aCoverSheetDisplayPanel.Title + ' not finished');
            Result := False;
          end
        else
          aList.Add(aCoverSheetDisplayPanel.Title + ' finished');
  finally
    FreeAndNil(aList);
  end;
end;

procedure TCoverSheet.OnFocusFirstControl(Sender: TObject);
var
  aCPRS508: ICPRS508;
begin
  if fControls.Count > 0 then
    if Supports(fControls[0], ICPRS508, aCPRS508) then
      aCPRS508.OnFocusFirstControl(Sender);
end;

function TCoverSheet.getOnRefreshCWAD: TNotifyEvent;
begin
  Result := fOnRefreshCWAD;
end;

function TCoverSheet.getOnRefreshReminders: TNotifyEvent;
begin
  Result := fOnRefreshReminders;
end;

procedure TCoverSheet.setOnRefreshCWAD(const aValue: TNotifyEvent);
begin
  if Assigned(aValue) then
    fOnRefreshCWAD := aValue
  else
    fOnRefreshCWAD := fRefreshCWAD;
end;

procedure TCoverSheet.setOnRefreshReminders(const aValue: TNotifyEvent);
begin
  if Assigned(aValue) then
    fOnRefreshReminders := aValue
  else
    fOnRefreshReminders := fRefreshReminders;
end;

procedure TCoverSheet.fRefreshCWAD(Sender: TObject);
begin
  // this is only here in case the method is set nil. See the assesor methods
end;

procedure TCoverSheet.fRefreshReminders(Sender: TObject);
begin
  // this is only here in case the method is set nil. See the assesor methods
end;

procedure TCoverSheet.OnRefreshPanel(Sender: TObject; aPanelID: integer);
var
  aControl: TControl;
  aCoverSheetDisplayPanel: ICoverSheetDisplayPanel;
begin
  for aControl in fControls do
    if Supports(aControl, ICoverSheetDisplayPanel, aCoverSheetDisplayPanel) then
      if aCoverSheetDisplayPanel.Params.ID = aPanelID then
        aCoverSheetDisplayPanel.OnRefreshDisplay(Self);
end;

procedure TCoverSheet.OnSetFontSize(Sender: TObject; aNewSize: integer);
var
  aControl: TControl;
  aCPRS508: ICPRS508;
begin
  fFontSize := aNewSize;
  for aControl in fControls do
    if Supports(aControl, ICPRS508, aCPRS508) then
      aCPRS508.OnSetFontSize(Self, fFontSize);
end;

procedure TCoverSheet.OnSetScreenReaderStatus(Sender: TObject; aActive: boolean);
var
  aControl: TControl;
  aCPRS508: ICPRS508;
begin
  fScreenReaderActive := aActive;
  for aControl in fControls do
    if Supports(aControl, ICPRS508, aCPRS508) then
      aCPRS508.OnSetScreenReaderStatus(Self, fScreenReaderActive);
end;

procedure TCoverSheet.OnSwitchToPatient(Sender: TObject; aDFN: string);
var
  aDisplayPanel: ICoverSheetDisplayPanel;
  aControl: TControl;
  aParam: ICoverSheetParam;
  aParam_CPRS: ICoverSheetParam_CPRS;
  aForeground: string;
begin
  try
    // Call the background job starter and get those that are run in aForeground
    if aDFN <> '' then
      begin
        CallVistA('ORWCV START', [aDFN, CoverSheet.IPAddress, CoverSheet.UniqueID], aForeground);

        for aParam in fParamList do
          if Supports(aParam, ICoverSheetParam_CPRS, aParam_CPRS) then
            begin
              aParam_CPRS.LoadInBackground := Pos(IntToStr(aParam_CPRS.ID), aForeground) = 0;
              aParam_CPRS.OnNewPatient(Self);
            end;

        for aControl in fControls do
          if Supports(aControl, ICoverSheetDisplayPanel, aDisplayPanel) then
            aDisplayPanel.OnBeginUpdate(Self);

        for aControl in fControls do
          if Supports(aControl, ICoverSheetDisplayPanel, aDisplayPanel) then
            aDisplayPanel.OnRefreshDisplay(Self);

        for aControl in fControls do
          if Supports(aControl, ICoverSheetDisplayPanel, aDisplayPanel) then
            aDisplayPanel.OnEndUpdate(Self);
      end
    else { DFN passed in as blank, clear the coversheet }
      for aControl in fControls do
        if Supports(aControl, ICoverSheetDisplayPanel, aDisplayPanel) then
          aDisplayPanel.OnClearPtData(Self);
  except
    on e: Exception do
      raise ECoverSheetSwitchPtFail.Create(e.Message);
  end;

  OnExpandAllPanels(Self);
end;

function TCoverSheet.getIPAddress: string;
begin
  Result := fIPAddress;
end;

function TCoverSheet.getPanelCount: integer;
begin
  if Assigned(fGridSettings) then
    Result := fGridSettings.PanelCount
  else
    Result := 0;
end;

function TCoverSheet.getParams: ICoverSheetParamList;
begin
  fParamList.QueryInterface(ICoverSheetParamList, Result);
end;

function TCoverSheet.getUniqueID: string;
begin
  Result := fUniqueID;
end;

procedure TCoverSheet.OnInitCoverSheet(Sender: TObject);
var
  aReturn: TStringList;
  aInitStr: string;
  aParam: ICoverSheetParam;
begin
  aReturn := TStringList.Create;
  CoverSheet.Params.Clear;

  { Push in the CPRS style params }
  try
    try
      CallVistA('ORWCV1 COVERSHEET LIST', [], aReturn);
      // Proof of concepts!
      // aReturn.Insert(0, '1001^My Web Browser^http://www.domain^1');
      // aReturn.Insert(0, '1001^My Web Page');
      // aReturn.Insert(0, '1000^Clock');

      for aInitStr in aReturn do
        begin
          case StrToIntDef(Copy(aInitStr, 1, Pos('^', aInitStr) - 1), 0) of
            CV_CPRS_PROB: TCoverSheetParam_CPRS_ProblemList.Create(aInitStr).GetInterface(ICoverSheetParam, aParam);
            CV_CPRS_POST: TCoverSheetParam_CPRS_Postings.Create(aInitStr).GetInterface(ICoverSheetParam, aParam);
            CV_CPRS_ALLG: TCoverSheetParam_CPRS_Allergies.Create(aInitStr).GetInterface(ICoverSheetParam, aParam);
            CV_CPRS_MEDS: TCoverSheetParam_CPRS_ActiveMeds.Create(aInitStr).GetInterface(ICoverSheetParam, aParam);
            CV_CPRS_RMND: TCoverSheetParam_CPRS_Reminders.Create(aInitStr).GetInterface(ICoverSheetParam, aParam);
            CV_CPRS_LABS: TCoverSheetParam_CPRS_Labs.Create(aInitStr).GetInterface(ICoverSheetParam, aParam);
            CV_CPRS_VITL: TCoverSheetParam_CPRS_Vitals.Create(aInitStr).GetInterface(ICoverSheetParam, aParam);
            CV_CPRS_VSIT: TCoverSheetParam_CPRS_Appts.Create(aInitStr).GetInterface(ICoverSheetParam, aParam);
            CV_CPRS_IMMU: TCoverSheetParam_CPRS_Immunizations.Create(aInitStr).GetInterface(ICoverSheetParam, aParam);
            CV_CPRS_WVHT: TCoverSheetParam_CPRS_WH.Create(aInitStr).GetInterface(ICoverSheetParam, aParam);
            CV_WDGT_CLOCK: TCoverSheetParam_WidgetClock.Create(aInitStr).GetInterface(ICoverSheetParam, aParam);
            CV_WDGT_MINIBROWSER: TCoverSheetParam_Web.Create(aInitStr).GetInterface(ICoverSheetParam, aParam);
          else
            aParam := nil;
          end;

          if aParam <> nil then
            CoverSheet.Params.Add(aParam);
        end;
    except
      on e: Exception do
        raise ECoverSheetInitFail.Create(e.Message);
    end;
  finally
    FreeAndNil(aReturn);
  end;
end;

end.
