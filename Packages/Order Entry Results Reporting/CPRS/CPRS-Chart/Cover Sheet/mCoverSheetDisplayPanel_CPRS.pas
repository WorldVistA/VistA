unit mCoverSheetDisplayPanel_CPRS;
{
  ================================================================================
  *
  *       Application:  CPRS - CoverSheet
  *       Developer:    dan.petit@domain.ext
  *       Site:         Salt Lake City ISC
  *       Date:         2015-12-04
  *
  *       Description:  Inherited from TfraCoverSheetDisplayPanel. This display
  *                     panel provides the minimum functionality for displaying
  *                     CPRS data in the CoverSheet.
  *
  *       Notes:        This frame is an ancestor object and heavily inherited from.
  *                     ABSOLUTELY NO CHANGES SHOULD BE MADE WITHOUT FIRST
  *                     CONFERRING WITH THE CPRS DEVELOPMENT TEAM ABOUT POSSIBLE
  *                     RAMIFICATIONS WITH DESCENDANT FRAMES.
  *
  ================================================================================
}

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.UITypes,
  System.ImageList,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Menus,
  Vcl.ImgList,
  Vcl.StdCtrls,
  Vcl.Buttons,
  Vcl.ExtCtrls,
  Vcl.ComCtrls,
  mCoverSheetDisplayPanel,
  iCoverSheetIntf,
  iGridPanelIntf,
  oDelimitedString,
  mGridPanelFrame,
  VA508AccessibilityManager,
  u508Extensions,
  ORExtensions;

type
  TfraCoverSheetDisplayPanel_CPRS = class(TfraCoverSheetDisplayPanel, ICoverSheetDisplayPanel)
    tmr: TTimer;
    lvData: ORExtensions.TListView;
    procedure lvDataEnter(Sender: TObject);
    procedure lvDataExit(Sender: TObject);
    procedure lvDataMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure lvDataSelectItem(Sender: TObject; Item: TListItem; Selected: boolean);
    procedure tmrTimer(Sender: TObject);
    procedure lvDataKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure lvDataDeletion(Sender: TObject; Item: TListItem);
  private
    FInTmrTimer: boolean; // Is the Tmr TTimer currently executing?
    procedure DisplayItemDetail(Sender: TObject; aItem: TListItem; Button: TMouseButton);
  protected
    fBackgroundLoading: boolean;
    fBackgroundLoadTry: integer;
    fFinished: boolean;
    fColumns: TStringList;
    fLastItemIndex: integer;
    fAllowDetailDisplay: boolean;
    f508Manager: TVA508AccessibilityManager;
    fLV508Manager: Tlv508Manager;

    { Overridden events - TfraGridPanelFrame }
    procedure OnSetFontSize(Sender: TObject; aNewSize: integer); override;
    procedure OnPopupMenu(Sender: TObject); override;
    procedure OnPopupMenuInit(Sender: TObject); override;
    procedure OnRefreshDisplay(Sender: TObject); override; final;
    procedure OnLoadError(Sender: TObject; E: Exception); override; final;
    procedure OnShowError(Sender: TObject); override; final;

    { Overridden events - TfraCoverSheetDisplayPanel }
    procedure OnBeginUpdate(Sender: TObject); override;
    procedure OnClearPtData(Sender: TObject); override;
    procedure OnEndUpdate(Sender: TObject); override;

    { Overridden methods - TfraCoverSheetDisplayPanel }
    function getIsFinishedLoading: boolean; override;

    { Introduced events }
    procedure OnStartBackgroundLoad(Sender: TObject); virtual;
    procedure OnCompleteBackgroundLoad(Sender: TObject); virtual;
    procedure OnAddItems(aList: TStrings); virtual;
    procedure OnGetDetail(aRec: TDelimitedString; aResult: TStrings); virtual;
    procedure OnShowDetail(aText: TStrings; aTitle: string = ''; aPrintable: boolean = false); virtual;

    { Introduced methods }
    function AddColumn(aIndex: integer; aCaption: string): integer; virtual; final;
    procedure ClearListView(aListView: TListView); virtual;
    function CollapseColumns: integer; virtual; final;
    function ExpandColumns: integer; virtual; final;
    function ListViewItemIEN: integer; virtual;
    function ListViewItemRec: TDelimitedString; virtual;
    function CPRSParams: ICoverSheetParam_CPRS; virtual; final;

    procedure SetListViewColumn(aIndex: integer; aCaption: string; aAutoSize: boolean; aWidth: integer); virtual;
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  fraCoverSheetDisplayPanel_CPRS: TfraCoverSheetDisplayPanel_CPRS;

  UPDATING_WAIT_TIME: integer = 3000; // milliseconds

implementation

{$R *.dfm}

{ fraCoverSheetDisplayPanel_CPRS }

uses
  uCore,
  uConst,
  fRptBox,
  DateUtils,
  ORFn,
  ORNet,
  VAUtils,
  UResponsiveGUI;

const
  UPDATING_FOREGROUND = 'Updating ...';
  UPDATING_BACKGROUND = 'Loading in Background ...';
  UPDATING_FAILURE    = 'Update failed.';
  UPDATING_ATTEMPTS   = 100;  // Max try to get data from background job

constructor TfraCoverSheetDisplayPanel_CPRS.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  FInTmrTimer := False;
  with lvData do
    begin
      ShowColumnHeaders := false;
      ViewStyle := vsReport;
      readonly := True;
      RowSelect := True;
      Columns.Add.AutoSize := True;
    end;

  fColumns := TStringList.Create;
  fLastItemIndex := -1;
  fAllowDetailDisplay := True;

  tmr.Interval := UPDATING_WAIT_TIME;
  tmr.Enabled := false;
end;

destructor TfraCoverSheetDisplayPanel_CPRS.Destroy;
begin
  ClearListView(lvData);
  FreeAndNil(fColumns);
  inherited;
end;

procedure TfraCoverSheetDisplayPanel_CPRS.ClearListView(aListView: TListView);
begin
  if f508Manager = nil then
  begin
    f508Manager := FindControl508Manager(Self);
    if f508Manager <> nil then
    begin
      fLV508Manager := Tlv508Manager.Create;
      f508Manager.ComponentManager[lvData] := fLV508Manager;
      // f508Manager now owns fLV508Manager, don't delete
      f508Manager.UseDefault[lvData] := False;
    end;
  end;
  aListView.Items.BeginUpdate;
  try
    aListView.Items.Clear;
  finally
    aListView.Items.EndUpdate;
  end;
end;

procedure TfraCoverSheetDisplayPanel_CPRS.OnClearPtData(Sender: TObject);
begin
  ClearListView(lvData);
end;

procedure TfraCoverSheetDisplayPanel_CPRS.OnCompleteBackgroundLoad(Sender: TObject);
begin
  // virtual method for child frames;
end;

function TfraCoverSheetDisplayPanel_CPRS.CollapseColumns: integer;
begin
  try
    lvData.Columns.BeginUpdate;
    lvData.Columns.Clear;
    if fColumns.Count = 0 then
      with lvData.Columns.Add do
        begin
          Caption := '';
          AutoSize := True;
          Width := lvData.ClientWidth;
          lvData.ShowColumnHeaders := false;
        end
    else
      with lvData.Columns.Add do
        begin
          Caption := fColumns[0];
          AutoSize := True;
          Width := lvData.ClientWidth;
          lvData.ShowColumnHeaders := True;
        end;

  finally
    lvData.Columns.EndUpdate;
  end;

  Result := lvData.Columns.Count;
end;

function TfraCoverSheetDisplayPanel_CPRS.CPRSParams: ICoverSheetParam_CPRS;
begin
  // Supports(fParam, ICoverSheetParam_CPRS, Result);
  getParam.QueryInterface(ICoverSheetParam_CPRS, Result);
end;

function TfraCoverSheetDisplayPanel_CPRS.AddColumn(aIndex: integer; aCaption: string): integer;
begin
  while fColumns.Count < (aIndex + 1) do
    fColumns.Add('');
  fColumns[aIndex] := aCaption;
  Result := fColumns.Count;
end;

procedure TfraCoverSheetDisplayPanel_CPRS.OnAddItems(aList: TStrings);
var
  aRec: TDelimitedString;
  aStr: string;
begin
  if aList.Count = 0 then
    aList.Add('^No data found.^');

  for aStr in aList do
    with lvData.Items.Add do
      begin
        aRec := TDelimitedString.Create(aStr);
        Caption := aRec.GetPiece(2);
        Data := aRec;
      end;
end;

procedure TfraCoverSheetDisplayPanel_CPRS.OnBeginUpdate(Sender: TObject);
begin
  ClearListView(lvData);
  CollapseColumns;

  if CPRSParams.HighlightText then
    begin
      lvData.Font.Color := clHighlight;
      lvData.Font.Style := [fsBold];
    end;

  with lvData.Items.Add do
    if CPRSParams.LoadInBackground then
      Caption := UPDATING_BACKGROUND
    else
      Caption := UPDATING_FOREGROUND;

  TResponsiveGUI.ProcessMessages;
  fFinished := false;
end;

procedure TfraCoverSheetDisplayPanel_CPRS.OnEndUpdate(Sender: TObject);
begin
  fFinished := True;
end;

function TfraCoverSheetDisplayPanel_CPRS.ExpandColumns: integer;
var
  aStr: string;
begin
  try
    lvData.Columns.BeginUpdate;
    lvData.Columns.Clear;
    if fColumns.Count = 0 then
      with lvData.Columns.Add do
      begin
        Caption := '';
        AutoSize := True;
        Width := lvData.ClientWidth;
        lvData.ShowColumnHeaders := false;
      end
    else
    begin
      for aStr in fColumns do
        with lvData.Columns.Add do
        begin
          Caption := aStr;
          // AutoSize := True;
          // Width := lvData.ClientWidth div fColumns.Count;
          Width := -2; // lvData.ClientWidth div fColumns.Count;
          // lvData.ShowColumnHeaders := True;
        end;
      lvData.ShowColumnHeaders := True;
    end;

  finally
    lvData.Columns.EndUpdate;
  end;
  Result := lvData.Columns.Count;
end;

function TfraCoverSheetDisplayPanel_CPRS.getIsFinishedLoading: boolean;
begin
  Result := fFinished and (not tmr.Enabled)
end;

procedure TfraCoverSheetDisplayPanel_CPRS.OnGetDetail(aRec: TDelimitedString; aResult: TStrings);
begin
  try
    CallVistA(CPRSParams.DetailRPC, [Patient.DFN, aRec.GetPiece(1)], aResult);
  except
    on E: Exception do
      ShowMessage('Default Detail Failed. ' + E.Message);
  end;
end;

procedure TfraCoverSheetDisplayPanel_CPRS.OnLoadError(Sender: TObject; E: Exception);
begin
  inherited;
  ClearListView(lvData);
//  lvData.Items.Clear;
  with lvData.Items.Add do
    Caption := '** Error Loading Data **';
  lvData.Enabled := True;
  lvData.Hint := getLoadErrorMessage;
  lvData.ShowHint := True;
end;

function TfraCoverSheetDisplayPanel_CPRS.ListViewItemIEN: integer;
begin
  if lvData.Selected <> nil then
    if lvData.Selected.Data <> nil then
      Result := TDelimitedString(lvData.Selected.Data).GetPieceAsInteger(1)
    else
      Result := -1
  else
    Result := -1;
end;

function TfraCoverSheetDisplayPanel_CPRS.ListViewItemRec: TDelimitedString;
begin
  if lvData.Selected <> nil then
    if lvData.Selected.Data <> nil then
      Result := TDelimitedString(lvData.Selected.Data)
    else
      Result := nil
  else
    Result := nil;
end;

procedure TfraCoverSheetDisplayPanel_CPRS.lvDataDeletion(Sender: TObject;
  Item: TListItem);
begin
  TObject(Item.Data).free;
  inherited;
end;

procedure TfraCoverSheetDisplayPanel_CPRS.lvDataEnter(Sender: TObject);
begin
  if (fLastItemIndex > -1) and (lvData.Items.Count > fLastItemIndex) then
    begin
      lvData.Items[fLastItemIndex].Selected := True;
      lvData.Items[fLastItemIndex].Focused := True;
    end
  else if lvData.Items.Count > 0 then
    begin
      lvData.Items[0].Selected := True;
      lvData.Items[0].Focused := True;
    end;
end;

procedure TfraCoverSheetDisplayPanel_CPRS.lvDataExit(Sender: TObject);
begin
  lvData.Selected := nil;
end;

procedure TfraCoverSheetDisplayPanel_CPRS.lvDataKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) or (Key = VK_SPACE) then
    begin
      DisplayItemDetail(Sender, lvData.Selected, mbLeft);
    end
  else
    inherited;

end;

procedure TfraCoverSheetDisplayPanel_CPRS.DisplayItemDetail(Sender: TObject; aItem: TListItem; Button: TMouseButton);
var
  aDetail: TStringList;
  aParam: ICoverSheetParam_CPRS;
  aTitle: string;
begin
  if aItem <> nil then
    begin
      fLastItemIndex := aItem.Index;
      if (Button = mbLeft) and (aItem.Data <> nil) then
        if TDelimitedString(aItem.Data).GetPiece(1) <> '' then
          try
            // Get the detail text
            aDetail := TStringList.Create;
            OnGetDetail(TDelimitedString(aItem.Data), aDetail);

            // Get the title
            aTitle := getTitle + ' Item Detail: ' + aItem.Caption;

            // Check to see if it's printable
            if getParam.QueryInterface(ICoverSheetParam_CPRS, aParam) = 0 then
              OnShowDetail(aDetail, aTitle, aParam.AllowDetailPrint)
            else
              OnShowDetail(aDetail, aTitle);
          finally
            FreeAndNil(aDetail);
          end;
    end
  else
    lvDataEnter(Sender);
end;

procedure TfraCoverSheetDisplayPanel_CPRS.lvDataMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  aItem: TListItem;
begin
  if fAllowDetailDisplay then
    begin
      aItem := lvData.GetItemAt(X, Y);
      DisplayItemDetail(Sender, aItem, Button);
    end;
end;

procedure TfraCoverSheetDisplayPanel_CPRS.lvDataSelectItem(Sender: TObject; Item: TListItem; Selected: boolean);
begin
  if Selected then
    fLastItemIndex := Item.Index;
end;

procedure TfraCoverSheetDisplayPanel_CPRS.OnPopupMenu(Sender: TObject);
begin
  inherited;
  pmnRefresh.Enabled := (Patient.DFN <> '');
end;

procedure TfraCoverSheetDisplayPanel_CPRS.OnPopupMenuInit(Sender: TObject);
begin
  inherited;
  pmnRefresh.Visible := True;
  pmnRefresh.Enabled := True;
end;

procedure TfraCoverSheetDisplayPanel_CPRS.OnRefreshDisplay(Sender: TObject);
var
  aRet: TStringList;
  aRPC: string;
begin
  inherited;

  ClearListView(lvData);

  if Patient.DFN = '' then
    begin
      lvData.Items.Add.Caption := 'No Patient Selected.';
      lvData.Repaint;
      Exit;
    end;

  if not CPRSParams.IsApplicable then
    begin
      with lvData.Items.Add do
        begin
          Caption := 'Not Applicable.';
          Data := NewDelimitedString('-1^Not Applicable', '^');
        end;
      lvData.Repaint;
      Exit;
    end;

  if CPRSParams.LoadInBackground then
    begin
      OnStartBackgroundLoad(Self);
      fBackgroundLoadTry := 0;
      fBackgroundLoading := True;
      tmr.Enabled := True;                  // Start up the timer!
      CPRSParams.LoadInBackground := false; // Only loads background when the coversheet says so.
      TResponsiveGUI.ProcessMessages;
      Exit;
    end;

  try
    try
      ClearLoadError;

      OnBeginUpdate(Sender);

      aRet := TStringList.Create;
      aRPC := CPRSParams.MainRPC;

      { todo - move these calls into a GetList method that can then be overridden by the inheritors }
      // GetList(aRet); Every inheritor will have the params and access to Patient.DFN

      if CPRSParams.Param1 <> '' then
        CallVistA(aRPC, [Patient.DFN, CPRSParams.Param1], aRet)
      else
        CallVistA(aRPC, [Patient.DFN], aRet);

      if CPRSParams.Invert then
        InvertStringList(aRet);

      ClearListView(lvData); // Must be re-cleared to flush anything from the OnBeginUpdate messages.
      OnAddItems(aRet);
    except
      on E: Exception do
        OnLoadError(Self, E);
    end;
  finally
    OnEndUpdate(Sender);
    FreeAndNil(aRet);
  end;
end;

procedure TfraCoverSheetDisplayPanel_CPRS.OnSetFontSize(Sender: TObject; aNewSize: integer);
begin
  inherited;
  lvData.Font.Size := aNewSize;
  onRefreshDisplay(self);
end;

procedure TfraCoverSheetDisplayPanel_CPRS.SetListViewColumn(aIndex: integer; aCaption: string; aAutoSize: boolean; aWidth: integer);
begin
  while lvData.Columns.Count < (aIndex + 1) do
    lvData.Columns.Add;

  lvData.ShowColumnHeaders := True;

  with lvData.Columns[aIndex] do
    begin
      Caption := aCaption;
      AutoSize := aAutoSize;
      Width := aWidth;
    end;
  lvData.ColumnClick := false; // This is a default on setup. If setting up a sort, enable it.
end;

procedure TfraCoverSheetDisplayPanel_CPRS.OnShowDetail(aText: TStrings; aTitle: string = ''; aPrintable: boolean = false);
begin
  if aTitle = '' then
    aTitle := getTitle + ' Item Detail: ' + lvData.Selected.Caption;
  ReportBox(aText, aTitle, aPrintable);
end;

procedure TfraCoverSheetDisplayPanel_CPRS.OnShowError(Sender: TObject);
begin
  ShowMessage('CPRS does this by itself with a copy to clipboard option' + #13 + getLoadErrorMessage);
end;

procedure TfraCoverSheetDisplayPanel_CPRS.OnStartBackgroundLoad(Sender: TObject);
begin
  ClearListView(lvData);
  lvData.Items.Add.Caption := UPDATING_BACKGROUND;
  TResponsiveGUI.ProcessMessages;
end;

procedure TfraCoverSheetDisplayPanel_CPRS.tmrTimer(Sender: TObject);
var
  aLst: TStringList;
  aParam: ICoverSheetParam_CPRS;
  i: integer;
begin
  if not FInTmrTimer then
  begin
    FInTmrTimer := True; // Ensure to ignore timer firing during execution of timer firing
    try
      tmr.Interval := UPDATING_WAIT_TIME;
      tmr.Enabled := fBackgroundLoading;

      // if try = 0 then it just hit from getting set to fire, give server a free loop
      if fBackgroundLoadTry = 0 then
      begin
        ClearListView(lvData);
        lvData.Items.Add.Caption := UPDATING_BACKGROUND;
        inc(fBackgroundLoadTry);
        TResponsiveGUI.ProcessMessages;
        Exit;
      end;

      ClearListView(lvData);

      if not tmr.Enabled then
      begin
        lvData.Items.Add.Caption := 'Exit, timer not enabled';
        Exit;
      end;

      if getParam.QueryInterface(ICoverSheetParam_CPRS, aParam) <> 0 then
      begin
        lvData.Items.Add.Caption := 'Invalid param set for display.';
        tmr.Enabled := false;
        Exit;
      end
      else if aParam.PollingID = '' then
      begin
        lvData.Items.Add.Caption := 'Invalid PollingID in param set.';
        tmr.Enabled := false;
        Exit;
      end;

      // Do the call here and determine if we can load anything
      try
        aLst := TStringList.Create;
        CallVistA('ORWCV POLL', [Patient.DFN, CoverSheet.IPAddress, CoverSheet.UniqueID, aParam.PollingID], aLst);
        if aLst.Count > 0 then
        begin
          for i := aLst.Count - 1 downto 0 do
          begin
            if Copy(aLst[i], 1, 1) = '~' then
              aLst.Delete(i)
            else if Copy(aLst[i], 1, 1) = 'i' then
              aLst[i] := Copy(aLst[i], 2, Length(aLst[i]));
          end;

          ClearListView(lvData);

          if CPRSParams.Invert then
            InvertStringList(aLst);

          OnAddItems(aLst);
          tmr.Enabled := false;
          OnCompleteBackgroundLoad(Self);
          Exit;
        end;
      finally
        FreeAndNil(aLst);
      end;

      inc(fBackgroundLoadTry);
      fBackgroundLoading := (fBackgroundLoadTry <= UPDATING_ATTEMPTS);

      if fBackgroundLoading then
        lvData.Items.Add.Caption := Format(UPDATING_BACKGROUND + '%s', [Copy('..........', 1, fBackgroundLoadTry)])
      else
      begin
        tmr.Enabled := false;
        lvData.Items.Add.Caption := UPDATING_FAILURE;
      end;

      TResponsiveGUI.ProcessMessages;
    finally
      if tmr.Enabled then tmr.OnTimer := tmr.OnTimer; // setting OnTimer calls UpdateTimer, which resets the timer to not fire again for UPDATING_WAIT_TIME
      FInTmrTimer := False;
    end;
  end;
end;

end.
