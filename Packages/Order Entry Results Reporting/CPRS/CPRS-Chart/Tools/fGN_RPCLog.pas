unit fGN_RPCLog;

interface

uses
  ORExtensions,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DateUtils, ORNet, ORFn, System.UITypes,
{$IFNDEF STANDALONE} // not RPC log viewer application
  rMisc,
{$ENDIF}
  ComCtrls, Buttons, ExtCtrls, fBase508Form,
  ORCtrls, ORSystem, VA508AccessibilityManager, VAUtils,
  Winapi.RichEdit, Vcl.Menus, Vcl.ImgList, Vcl.ToolWin, System.ImageList,
  System.Actions, Vcl.ActnList, Vcl.StdActns, Vcl.Tabs, Vcl.DockTabSet,
  System.Generics.Collections, uGN_RPCLog, RPCList;

type

  /// <summary>Used for tracking actions and search results</summary>
  TLogAction = class(TObject)
  private
    FSearchResults: Boolean;
    FActionType: TLog_ActionType;
    FRPC: TRPC;
    function GetActionType: TLog_ActionType;
    procedure SetActionType(const Value: TLog_ActionType);
    function GetSearchResults: Boolean;
    procedure SetSearchResults(const Value: Boolean);
    function GetRPC: TRPC;
    procedure SetRPC(const Value: TRPC);
  public
    property ActionType: TLog_ActionType read GetActionType write SetActionType default LACT_NIL;
    property SearchResults: Boolean read GetSearchResults write SetSearchResults;
    property RPC: TRPC read GetRPC write SetRPC;
  end;

  /// <summary>Holds list of actions for a log entry</summary>
  TLogActionList = Class(TObject)
  private
    FList: TObjectList<TLogAction>;
    function GetActions(const RPC: TRPC): TLogAction;
    procedure SetActions(const RPC: TRPC; const Value: TLogAction);
    function GetCount: Integer;
    function GetItems(Index: Integer): TLogAction;
  Public
    constructor Create;
    destructor Destroy; override;
    /// <summary>Add action object to list</summary>
    /// <param name="ActionType">Action being added</param>
    /// <param name="RPC">RPC object to this action
    /// <returns>Action object that was added</returns>
    function Add(ActionType: TLog_ActionType; RPC: TRPC): TLogAction;
    /// <summary>Removes and action object from list</summary>
    /// <param name="RPC">RPC object to this action
    procedure Remove(RPC: TRPC);
    /// <summary>Action object from list by Index</summary>
    property Items[Index: Integer]: TLogAction read GetItems;
    /// <summary>Action object from list by TRPC</summary>
    property Actions[const RPC: TRPC]: TLogAction read GetActions write SetActions;
    property Count: Integer read GetCount;
  End;

  TRPCLog = Class(TObject)
  private
    FLogActionList: TLogActionList;
    FRPCList: TRPCList;
    function GetRPCList: TRPCList;
    function GetLogActionList: TLogActionList;
  public
    constructor Create;
    destructor Destroy; override;
    /// <summary>holds actions</summary>
    property LogActionList: TLogActionList read GetLogActionList;
    /// <summary>hold RPCs</summary>
    property RPCList: TRPCList read GetRPCList;
  End;

  TfrmRPCLog = class(TfrmBase508Form)
    c: TImageList;
    alLog: TActionList;
    ilWindow: TImageList;
    alWindow: TActionList;
    acAdvTools: TAction;
    acRealTime: TAction;
    acPrev: TAction;
    acNext: TAction;
    acAlignLeft: TAction;
    acAlignRight: TAction;
    acUndock: TAction;
    acFlag: TAction;
    bvlTop: TBevel;
    acClose: TAction;
    acSearch: TAction;
    acTestTime: TAction;
    acOneNext: TAction;
    acOnePrev: TAction;
    EditCopy1: TEditCopy;
    Panel3: TPanel;
    Panel4: TPanel;
    ToolBar5: TToolBar;
    ToolButton3: TToolButton;
    ToolBar6: TToolBar;
    lvRPCLog: TListView;
    MainMenu: TMainMenu;
    MenuItem3: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    Close2: TMenuItem;
    File1: TMenuItem;
    N5: TMenuItem;
    Edit1: TMenuItem;
    Copy1: TMenuItem;
    Panel1: TPanel;
    Flag2: TMenuItem;
    Label2: TLabel;
    edTarget: TComboBox;
    pnlMain: TPanel;
    memData: ORExtensions.TRichEdit;
    pnlTools: TPanel;
    lblCallID: TStaticText;
    pnlMainToolbar: TPanel;
    Label1: TLabel;
    ToolBar4: TToolBar;
    ToolButton21: TToolButton;
    ToolButton22: TToolButton;
    ToolButton23: TToolButton;
    cmbMaxCalls: TComboBox;
    splDebug: TSplitter;
    sb: TStatusBar;
    ToolButton2: TToolButton;
    ToolButton4: TToolButton;
    acSelectAll: TAction;
    ToolButton5: TToolButton;
    SelectAll2: TMenuItem;
    FileSave: TFileSaveAs;
    ToolButton1: TToolButton;
    acSymbolTable: TAction;
    ToolButton6: TToolButton;
    SymbolTable1: TMenuItem;
    acSaveOnExit: TAction;
    FileOpen1: TFileOpen;
    Open1: TMenuItem;
    N1: TMenuItem;
    FileExit1: TFileExit;
    FileSaveAll: TFileSaveAs;
    SaveAllAs1: TMenuItem;
    Options1: TMenuItem;
    SaveLogOnExit1: TMenuItem;
    acTrackForms: TAction;
    rackForms1: TMenuItem;
    ToolButton7: TToolButton;
    acClearLog: TAction;
    Clear1: TMenuItem;
    ToolButton8: TToolButton;
    acAddWatch: TAction;
    ToolButton9: TToolButton;
    acToTheLeft: TAction;
    acNoAlign: TAction;
    ToolBar1: TToolBar;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    acToTheRight: TAction;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    N2: TMenuItem;
    AlignLeft1: TMenuItem;
    AlignRight1: TMenuItem;
    NoAlignment1: TMenuItem;
    ckbWrap: TCheckBox;
    acWordWrap: TAction;
    N3: TMenuItem;
    WordWrap1: TMenuItem;
    ckbJSON: TCheckBox;
    acFormatJSON: TAction;
    procedure cmdPrevClick(Sender: TObject);
    procedure cmdNextClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnRLTClick(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SearchTermKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormStartDock(Sender: TObject; var DragObject: TDragDockObject);
    procedure sbFlagClick(Sender: TObject);
    procedure LiveListAdvancedCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
      var DefaultDraw: Boolean);
    procedure acCloseExecute(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure acOnePrevExecute(Sender: TObject);
    procedure acOneNextExecute(Sender: TObject);
    procedure acTestTimeExecute(Sender: TObject);
    procedure acSearchExecute(Sender: TObject);
    procedure EditCopy1Execute(Sender: TObject);
    procedure lvRPCLogSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure cmbMaxCallsSelect(Sender: TObject);
    procedure edTargetSelect(Sender: TObject);
    procedure pnlToolsDblClick(Sender: TObject);
    procedure lvRPCLogChange(Sender: TObject; Item: TListItem; Change: TItemChange);
    procedure FormShow(Sender: TObject);
    procedure acSelectAllExecute(Sender: TObject);
    procedure lvRPCLogResize(Sender: TObject);
    procedure FileSaveAccept(Sender: TObject);
    procedure FileSaveBeforeExecute(Sender: TObject);
    procedure lvRPCLogDblClick(Sender: TObject);
    procedure acSymbolTableExecute(Sender: TObject);
    procedure acSaveOnExitExecute(Sender: TObject);
    procedure FileOpen1Accept(Sender: TObject);
    procedure FileSaveAllAccept(Sender: TObject);
    procedure acTrackFormsExecute(Sender: TObject);
    procedure acClearLogExecute(Sender: TObject);
    procedure acToTheLeftExecute(Sender: TObject);
    procedure acNoAlignExecute(Sender: TObject);
    procedure acToTheRightExecute(Sender: TObject);
    procedure acWordWrapExecute(Sender: TObject);
    procedure lvRPCLogData(Sender: TObject; Item: TListItem);
    procedure acFormatJSONExecute(Sender: TObject);
    procedure FileSaveAllBeforeExecute(Sender: TObject);
  private
    { Private declarations }
    FLogList: TRPCLog;
    procedure HighlightRichEdit(StartChar, EndChar: Integer; HighLightColor: TColor; Flag: Integer = SCF_SELECTION);
    procedure OnDeleteCallList(const Value: TRPC);
    procedure OnAddCallList(const Value: TRPC);
    procedure RealTime;
    procedure doSearch;
    procedure PaintEditByTarget(aSearchTarget: String; aColor: TColor = clYellow);
    procedure setLogLength(aCount: Integer);
    procedure setActionStatus;
    procedure doSaveAs(aFileName: String; CurrentOnly: Boolean = true);
    procedure doLoadFromFile(aFileName: String);
    procedure AddFlag(aFlag: String; aComment: String = '');
    procedure SearchTarget(aTarget: String);
    procedure PositionReport;
    procedure AlignBroker(AlignStyle: TAlign);
    Procedure ClearSearchResults;
    procedure ClearHighlight;
    procedure RefreshRPCListView;
    procedure SavePre(Save: TFileSaveAs);
    procedure SavePost(Save: TFileSaveAs);
    procedure ClearSelection;
  protected
    procedure CreateParams(var Params: TCreateParams) ; override;
  public
    { Public declarations }
    procedure doPrev;
    procedure doNext;
    procedure SaveAll;
    procedure setFontSize(aSize: Integer);
    procedure AddNonRPCtoList(const Action: TLog_ActionType; const aRPC: TRPC; AutoSelectEntry: Boolean = True); overload;
    procedure AddNonRPCtoList(const Action: TLog_ActionType; Const Caption, RanAt, Duration: String; Data: TstringList = nil; AutoSelectEntry: Boolean = True);  overload;
  end;

var
  frmRPCLog: TfrmRPCLog;

implementation

uses
  Clipbrd,
  VAPieceHelper,
  REST.Json,
  System.JSON.Types,
  System.JSON.Writers,
  System.JSON.Builders,
  System.JSON,
  VAShared.UTStringsHelper;
{$R *.DFM}

Const
  EXPORT_BEGIN = '<<< EXPORT';
  EXPORT_END = '>>>';

function FormatJSON(Json: String): String;
var
  tmpJson: TJsonValue;
begin
  tmpJson := TJsonObject.ParseJSONValue(Json);
{$WARN SYMBOL_DEPRECATED OFF}
  if tmpJson <> nil then
    Result := TJson.Format(tmpJson)
  else
    Result := '';
{$WARN SYMBOL_DEPRECATED ON}
  FreeAndNil(tmpJson);
end;

function BuildOutput(aSource: TstringList; bJSON: Boolean): String;
var
  old: TCursor;
  slHeader: TstringList;
  slParameters: TstringList;
  slResult: TstringList;

  procedure setHeader(const SL: TStrings);
  begin
    while (SL.Count > 0) and (pos('Params', SL[0]) <> 1) do
    begin
      slHeader.Add(SL[0]);
      SL.Delete(0);
    end;

    if (SL.Count > 0) and (pos('Params', SL[0]) = 1) then
      SL.Delete(0);
  end;

  procedure setParams(const SL: TStrings);
  begin
    while (SL.Count > 0) and (pos('Results', SL[0]) <> 1) do
    begin
      slParameters.Add(SL[0]);
      SL.Delete(0);
    end;

    if (SL.Count > 0) and (pos('Results', SL[0]) = 1) then
      SL.Delete(0);

    slParameters.Insert(0, ORNET_PARAMS);
  end;

  function FormatParams(aSource: TstringList): String;
  begin
    Result := '';
    var
      ss: String;
    for var S in aSource do
    begin
      if pos('literal' + #9, S) = 1 then
      begin
        ss := trim(piece(S, #9, 2));
        ss := FormatJSON(ss);
        if ss <> '' then
          Result := Result + CRLF + 'literal' + CRLF + ss
        else
          Result := Result + CRLF + {'literal' + CRLF +} S;
      end
      else
        Result := Result + CRLF + S;
    end;
  end;

  procedure setResult(const SL: TStrings);
  begin
    var
    S := trim(SL.Text);
    S := FormatJSON(S);
    if S = '' then
      S := SL.Text;

    SL.Text := S;
    SL.Insert(0, ORNET_RESULT);

    slResult.Assign(SL);
  end;

begin
  Result := aSource.Text;
  if bJSON and (pos('{', aSource.Text) > 0) then
  begin
    old := Screen.Cursor;

    var
    SL := TstringList.Create;
    slHeader := TstringList.Create;
    slParameters := TstringList.Create;
    slResult := TstringList.Create;

    try
      SL.Assign(aSource);

      setHeader(SL);
      setParams(SL);
      setResult(SL);

      Result := slHeader.Text + FormatParams(slParameters) + slResult.Text;

    finally
      SL.Free;
      slHeader.Free;
      slParameters.Free;
      slResult.Free;
      Screen.Cursor := old;
    end;
  end;
end;

procedure TfrmRPCLog.cmdPrevClick(Sender: TObject);
begin
  doPrev;
end;

procedure TfrmRPCLog.doNext;
begin
  if lvRPCLog.Items.Count = 0 then
    Exit;
  if lvRPCLog.ItemIndex > 0 then
    lvRPCLog.ItemIndex := lvRPCLog.ItemIndex - 1;
  if lvRPCLog.ItemIndex >= 0 then
    lvRPCLog.Selected := lvRPCLog.Items[lvRPCLog.ItemIndex];

  //Ensure item is visible
  lvRPCLog.Items[lvRPCLog.ItemIndex].MakeVisible(false);

  lvRPCLog.Repaint;
  setActionStatus;
end;

procedure TfrmRPCLog.cmbMaxCallsSelect(Sender: TObject);
begin
  inherited;
  setLogLength(StrToIntDef(cmbMaxCalls.Text, ORNet.GetRPCMax));
end;

procedure TfrmRPCLog.cmdNextClick(Sender: TObject);
begin
  doNext;
end;

procedure TfrmRPCLog.doPrev;
begin
  if lvRPCLog.ItemIndex < lvRPCLog.Items.Count - 1 then
    lvRPCLog.ItemIndex := lvRPCLog.ItemIndex + 1;

  if lvRPCLog.ItemIndex <= lvRPCLog.Items.Count - 1 then
    lvRPCLog.Selected := lvRPCLog.Items[lvRPCLog.ItemIndex];

  //Ensure item is visible
  lvRPCLog.Items[lvRPCLog.ItemIndex].MakeVisible(false);

  lvRPCLog.Repaint;
  setActionStatus;
end;

procedure TfrmRPCLog.cmdOKClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TfrmRPCLog.FileOpen1Accept(Sender: TObject);
begin
  doLoadFromFile(FileOpen1.Dialog.FileName);
end;

procedure TfrmRPCLog.SavePre(Save: TFileSaveAs);
var
  LookupIndex: Integer;
  aRPC: TRPC;
  S: String;
begin
  if not Assigned(Save) then
    Exit;
  try
    Save.Dialog.DefaultExt := 'json';
    if Save = FileSave then
    begin
      LookupIndex := (FLogList.RPCList.Count - 1) - lvRPCLog.ItemIndex;
      aRPC := FLogList.RPCList.Items[LookupIndex];
      S := FormatDateTime('YYYY_MM_DD_HHNNSSS_', Now) + aRPC.Name; 
    end else
      S := FormatDateTime('YYYY_MM_DD_HHNNSSS_', Now) + 'RPCLog';

    Save.Dialog.FileName := S;
  except
    on e: Exception do
      Raise exception.Create('Error saving RPC(s). Error was ' + e.message);
  end;
end;

procedure TfrmRPCLog.SavePost(Save: TFileSaveAs);
begin
  doSaveAs(Save.Dialog.FileName, (Save = FileSave));
end;

procedure TfrmRPCLog.FileSaveAccept(Sender: TObject);
begin
  inherited;
  SavePost(FileSave);
end;

procedure TfrmRPCLog.FileSaveBeforeExecute(Sender: TObject);
begin
  inherited;
  SavePre(FileSave);
end;

procedure TfrmRPCLog.FileSaveAllAccept(Sender: TObject);
begin
  inherited;
  SavePost(FileSaveAll);
end;

procedure TfrmRPCLog.FileSaveAllBeforeExecute(Sender: TObject);
begin
  inherited;
  SavePre(FileSaveAll);
end;

procedure TfrmRPCLog.FormClose(Sender: TObject; var Action: TCloseAction);
var
  SizeStr: string;
begin
  // Save size settings
  SaveUserBounds(self);
  SizeStr := IntToStr(Panel3.width) + ',0,0,0';
  SizeHolder.SetSize(self.Name + '.' + Panel3.Name, SizeStr);
  Hide;
end;

procedure TfrmRPCLog.FormResize(Sender: TObject);
begin
  Refresh;
end;

procedure TfrmRPCLog.FormShow(Sender: TObject);
begin
  inherited;
  lvRPCLog.SetFocus;
  setFontSize(Application.MainForm.Font.Size);
end;

procedure TfrmRPCLog.setFontSize(aSize: Integer);
begin
  Font.Size := aSize;
  memData.Font.Size := aSize;
end;

procedure TfrmRPCLog.FormStartDock(Sender: TObject; var DragObject: TDragDockObject);
begin
  inherited;
  DragObject := TDragDockObjectEx.Create(self);
  DragObject.Brush.Color := clAqua; // this will display a red outline
end;

procedure TfrmRPCLog.FormCreate(Sender: TObject);
var
  PanelWidth: string;
  SrcList: TRPCList;
begin
  // Get form and panel size settingd
  SetFormPosition(self);
  PanelWidth := SizeHolder.GetSize(self.Name + '.' + Panel3.Name);
  Panel3.width := StrToIntDef(TPiece(PanelWidth).Piece(1, ','), Panel3.width);

  // Create RPCList
  FLogList := TRPCLog.Create;

  // Set events for the ORNET.UCallList
  SrcList := ORNet.TRPCMethods.RPCList;
  SrcList.OnAdd := OnAddCallList;
  SrcList.OnDelete := OnDeleteCallList;

  // Clone from UCallList
  FLogList.RPCList.AddRPCs(ORNet.TRPCMethods.RPCList);

  // Update the ListView
  RefreshRPCListView;

  // Set the combo box for MAX RPCs
  cmbMaxCalls.Text := IntToStr(ORNet.GetRPCMax);
  cmbMaxCalls.SelStart := 0;
  cmbMaxCalls.SelLength := 0;

  // Update menu items
  FileSave.Visible := RPCLog_SaveAvailable;
  FileSave.Enabled := RPCLog_SaveAvailable and (lvRPCLog.ItemIndex <> -1);
  FileSaveAll.Visible := RPCLog_SaveAvailable;
  SaveLogOnExit1.Visible := RPCLog_SaveAvailable;
  FileOpen1.Visible := RPCLog_SaveAvailable;

{$IFDEF STANDALONE}
  FileOpen1.Visible := true;
  acTestTime.Visible := False;
  acSymbolTable.Visible := False;
{$ENDIF}
  Constraints.MinWidth := Screen.width div 6;
  acTrackForms.Checked := RPCLog_TrackForms;
end;

procedure TfrmRPCLog.FormDestroy(Sender: TObject);
begin
  // remove the ORNet callback
  FLogList.RPCList.OnAdd := nil;
  FLogList.RPCList.OnDelete := nil;
end;

procedure TfrmRPCLog.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    Close;
  end
  else if (Key = VK_F1) and (ssCtrl in Shift) then
  begin
    Key := 0;
    Application.MainForm.SetFocus;
  end;
end;

procedure TfrmRPCLog.HighlightRichEdit(StartChar, EndChar: Integer; HighLightColor: TColor; Flag: Integer = SCF_SELECTION);
var
  Format: CHARFORMAT2;
begin
  memData.LockDrawing;
  try
    memData.SelStart := StartChar;
    memData.SelLength := EndChar;
    // Set the background color
    FillChar(Format, SizeOf(Format), 0);
    Format.cbSize := SizeOf(Format);
    Format.dwMask := CFM_BACKCOLOR;
    Format.crBackColor := HighLightColor;
    memData.Perform(EM_SETCHARFORMAT, Flag, Longint(@Format));
  finally
    memData.UnlockDrawing;
  end;
end;

procedure TfrmRPCLog.LiveListAdvancedCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
  var DefaultDraw: Boolean);
var
  LookupIndex: Integer;
  aRPC: TRPC;
  aLogAction: TLogAction;
begin
  Sender.Canvas.Font.Color := clWindowText;
  Sender.Canvas.Brush.Color := clCream; // clWindow;
  Sender.Canvas.Font.Style := [];

  // Find the RPC for the index
  LookupIndex := (FLogList.RPCList.Count - 1) - Item.Index;
  aRPC := FLogList.RPCList.Items[LookupIndex];
  If assigned(aRPC) then
  begin
    // Find the action object linked to the RPC
    aLogAction := FLogList.LogActionList.Actions[aRPC];
    if assigned(aLogAction) then
    begin
      // Highlight the search results
      if aLogAction.SearchResults then
      begin
        Sender.Canvas.Font.Color := RPCLog_clTarget;
        Sender.Canvas.Brush.Color := RPCLog_bgclTarget;
        Sender.Canvas.Font.Style := [];
      end
      else
      begin
        // Action highlighting
        case aLogAction.ActionType of
          LACT_NIL:
            ;
          LACT_FLAG, LACT_SYSINFO, LACT_ACTIVATE, LACT_DEACTIVATE, LACT_CREATE, LACT_SHOW, LACT_HIDE, LACT_CLOSE, LACT_DESTROY:
            begin
              Sender.Canvas.Font.Color := RPCLog_clFlag;
              Sender.Canvas.Brush.Color := clCream;
              Sender.Canvas.Font.Style := [];
            end;
          LACT_EXPORT:
            begin
              Sender.Canvas.Font.Color := RPCLog_clImport;
              Sender.Canvas.Brush.Color := clCream;
              Sender.Canvas.Font.Style := [];
            end;
        end;
      end;
    end;
  end;
end;

procedure TfrmRPCLog.lvRPCLogChange(Sender: TObject; Item: TListItem; Change: TItemChange);
begin
  inherited;
  PositionReport;
end;

procedure TfrmRPCLog.PositionReport;
var
  RPCTotal: string;
begin
  if assigned(lvRPCLog) then
  begin
    if lvRPCLog.Items.Count <> ORNet.GetRPCMax then
      RPCTotal := Format(' ( %s RPCs ) ', [IntToStr(ORNet.GetRPCMax)]);

    sb.SimpleText := Format('Total records: %d%s  Current record: %d', [lvRPCLog.Items.Count, RPCTotal, lvRPCLog.ItemIndex + 1]);
  end;
end;

procedure TfrmRPCLog.lvRPCLogData(Sender: TObject; Item: TListItem);
var
  LookupIndex: Integer;
  aRPC: RPCList.TRPC;
begin
  // Get the RPC item for this index

  LookupIndex := (FLogList.RPCList.Count - 1) - Item.Index;
  aRPC := (FLogList.RPCList.Items[LookupIndex] as TRPC);
  if assigned(aRPC) then
  begin
    // Update the visual columns
    Item.Caption := aRPC.Name;
    Item.SubItems.Add(aRPC.Duration);
    Item.SubItems.Add(aRPC.RanAt);
  end;
end;

procedure TfrmRPCLog.lvRPCLogDblClick(Sender: TObject);
begin
  inherited;
  if lvRPCLog.ItemIndex >= 0 then
  begin
    edTarget.Text := trim(lvRPCLog.Items[lvRPCLog.ItemIndex].Caption);
    SearchTarget(edTarget.Text);
  end;
end;

procedure TfrmRPCLog.lvRPCLogResize(Sender: TObject);
var
  lv: TListView;
const
  _ScrollBar = 26;
begin
  inherited;
  lv := TListView(Sender);
  case lv.Columns.Count of
    0:
      Exit;
    1:
      lv.Columns.Items[0].width := lv.width - _ScrollBar;
    2:
      lv.Columns.Items[1].width := lv.width - _ScrollBar;
  end;
  // should be calculated by metrix
end;

procedure TfrmRPCLog.lvRPCLogSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
var
  lv: TListView;
  LookupIndex: Integer;
begin
  inherited;

  lv := TListView(Sender);
  FileSave.Enabled := (LV.Visible) and RPCLog_SaveAvailable and (lv.ItemIndex <> -1);
  if not lv.Visible then
    Exit;

  If not assigned(Item) then
    Exit;

  // Get the RPC object for this item and add the text to the display
  LookupIndex := (FLogList.RPCList.Count - 1) - Item.Index;
  If assigned(FLogList.RPCList.Items[LookupIndex]) then
  begin
    memData.Lines.Text := BuildOutput(FLogList.RPCList.Items[LookupIndex].List, acFormatJSON.Checked)
  end;

  if edTarget.Text <> '' then
    PaintEditByTarget(edTarget.Text);

  if lv.ItemIndex < 0 then
    lblCallID.Visible := False
  else
  begin
    lblCallID.Visible := true;
    if lv.ItemIndex = 0 then
      lblCallID.Caption := 'Last Record'
    else
      lblCallID.Caption := 'Last Record minus ' + IntToStr(lv.ItemIndex);
  end;
  SendMessage(memData.Handle, WM_VSCROLL, SB_TOP, 0);
  setActionStatus;
end;

procedure TfrmRPCLog.acFormatJSONExecute(Sender: TObject);
var
  LookupIndex: Integer;
begin
  inherited;
  acFormatJSON.Checked := not acFormatJSON.Checked;
  LookupIndex := (FLogList.RPCList.Count - 1) - lvRPCLog.Selected.Index;
  If assigned(FLogList.RPCList.Items[LookupIndex]) then
  begin
    memData.Lines.Text := BuildOutput(FLogList.RPCList.Items[LookupIndex].List, acFormatJSON.Checked)
  end;
end;

procedure TfrmRPCLog.acClearLogExecute(Sender: TObject);
begin
  if MessageDlg('Erase Log?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    FLogList.RPCList.Clear;
    AddFlag('Log Erased by User Request');
    lvRPCLog.ItemIndex := 0;
  end;
end;

procedure TfrmRPCLog.acCloseExecute(Sender: TObject);
begin
  inherited;
  Close
end;

procedure TfrmRPCLog.acOneNextExecute(Sender: TObject);
begin
  inherited;
  doNext;
end;

procedure TfrmRPCLog.acOnePrevExecute(Sender: TObject);
begin
  inherited;
  doPrev;
end;

procedure TfrmRPCLog.acSaveOnExitExecute(Sender: TObject);
begin
  inherited;
  RPCLog_SaveOnExit := not RPCLog_SaveOnExit;
  acSaveOnExit.Checked := RPCLog_SaveOnExit;
end;

procedure TfrmRPCLog.acSearchExecute(Sender: TObject);
begin
  inherited;
  doSearch;
end;

procedure TfrmRPCLog.acSelectAllExecute(Sender: TObject);
begin
  inherited;
  try
    if memData.CanFocus then
      memData.SetFocus;
    memData.SelectAll;
  except
  end;
end;

procedure TfrmRPCLog.acSymbolTableExecute(Sender: TObject);
{$IFDEF STANDALONE}
begin
{$ELSE}
var
  sl: TstringList;
begin
  inherited;
  sl := TstringList.Create;
  ListSymbolTable(sl);
  AddNonRPCtoList(LACT_SYSINFO, 'Symbol Table', '', '', sl, False);

  sl := TstringList.Create;
  if GetAllEnvVars(sl) > 0 then
    AddNonRPCtoList(LACT_SYSINFO, 'Environment variables', '', '', sl)
  else
    sl.Free;

{$ENDIF}
end;

procedure TfrmRPCLog.acTestTimeExecute(Sender: TObject);
begin
  inherited;
  RealTime;
end;

procedure TfrmRPCLog.acNoAlignExecute(Sender: TObject);
begin
  AlignBroker(alNone);
end;

procedure TfrmRPCLog.acToTheLeftExecute(Sender: TObject);
begin
  AlignBroker(alLeft);
end;

procedure TfrmRPCLog.acToTheRightExecute(Sender: TObject);
begin
  AlignBroker(alRight);
end;

procedure TfrmRPCLog.acTrackFormsExecute(Sender: TObject);
begin
  RPCLog_TrackForms := not RPCLog_TrackForms;
  acTrackForms.Checked := RPCLog_TrackForms;
end;

procedure TfrmRPCLog.acWordWrapExecute(Sender: TObject);
begin
  acWordWrap.Checked := not acWordWrap.Checked;
  memData.WordWrap := acWordWrap.Checked;
  if acWordWrap.Checked then
    memData.ScrollBars := ssVertical
  else
    memData.ScrollBars := ssBoth;
end;

procedure TfrmRPCLog.btnRLTClick(Sender: TObject);
begin
  RealTime;
end;

procedure TfrmRPCLog.RealTime;
{$IFDEF STANDALONE}
begin
{$ELSE}
var
  startTime, endTime: TDateTime;
  clientVer, serverVer, diffDisplay: string;
  theDiff: Integer;
  S: String;
  sl: TstringList;
const
  TX_OPTION = 'OR CPRS GUI CHART';
  disclaimer = 'NOTE: Strictly relative indicator';
begin
  clientVer := clientVersion(Application.ExeName); // Obtain before starting.
  // Check time lapse between a standard RPC call:
  startTime := Now;
  serverVer := serverVersion(TX_OPTION, clientVer);
  endTime := Now;
  theDiff := milliSecondsBetween(endTime, startTime);
  diffDisplay := IntToStr(theDiff);

  // Show the results:
  S := 'Lapsed time (milliseconds) = ' + diffDisplay + '.';
  // infoBox(S, disclaimer, MB_OK);

  sl := TstringList.Create;
  sl.Add(S);
  sl.Add(disclaimer);
  AddNonRPCtoList(LACT_SYSINFO, 'Real Time', '', '', sl);
{$ENDIF}
end;

procedure TfrmRPCLog.btnSearchClick(Sender: TObject);
begin
  doSearch;
end;

procedure TfrmRPCLog.ClearHighlight;
var
  Format: CHARFORMAT2;
begin
  memData.LockDrawing;
  try
    memData.SelStart := 0;
    memData.SelLength := Length(memData.Text);
    memData.SelAttributes.Style := [];

    // Set the background color
    FillChar(Format, SizeOf(Format), 0);
    Format.cbSize := SizeOf(Format);
    Format.dwMask := CFM_BACKCOLOR;
    Format.crBackColor := ColorToRGB(clwindow);

    memData.Perform(EM_SETCHARFORMAT, SCF_SELECTION, Longint(@Format));
    memData.SelLength := 0;
  finally
    memData.UnlockDrawing;
  end;

end;

procedure TfrmRPCLog.ClearSearchResults;
var
  aLogAction: TLogAction;
begin
  // Reset Search results
  for var i := 0 to FLogList.LogActionList.Count - 1 do
  begin
    aLogAction := FLogList.LogActionList.Items[i];
    aLogAction.SearchResults := False;
  end;

  // Clear richedit highlighting
  ClearHighlight;
end;

procedure TfrmRPCLog.doSearch;
begin
  lvRPCLog.Repaint;
end;

procedure TfrmRPCLog.EditCopy1Execute(Sender: TObject);
begin
  inherited;
  memData.CopyToClipboard;
end;

procedure TfrmRPCLog.edTargetSelect(Sender: TObject);
begin
  inherited;
  SearchTarget(edTarget.Text);
end;

procedure TfrmRPCLog.SearchTermKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
  begin
    SearchTarget(edTarget.Text);
    Key := 0;
  end;
end;

procedure TfrmRPCLog.SearchTarget(aTarget: string);
var
  ReturnCursor: Integer;
  aRPC: TRPC;
  aLogAction: TLogAction;
begin
  begin
    ClearSearchResults;

    ReturnCursor := Screen.Cursor;
    Screen.Cursor := crHourGlass;
    try
      // Look for the search text as a substring in the object list
      for var i := 0 to FLogList.RPCList.Count - 1 do
      begin
        // Get the RPC object
        aRPC := FLogList.RPCList.Items[i];
        If assigned(aRPC) then
        begin
          // found the text withing the RPC object text
          if aRPC.List.IndexOfSubString(edTarget.Text) > -1 then
          begin
            // Update the action item (create and add if not exit)
            aLogAction := FLogList.LogActionList.Actions[aRPC];
            if assigned(aLogAction) then
              aLogAction.SearchResults := true
            else
            begin
              aLogAction := FLogList.LogActionList.Add(LACT_NIL, aRPC);
              aLogAction.SearchResults := true;
            end;
          end;
        end;
      end;
    finally
      Screen.Cursor := ReturnCursor;
    end;

    btnSearchClick(self);
    lvRPCLog.Repaint;

    if aTarget <> '' then
      if edTarget.Items.IndexOf(aTarget) < 0 then
        edTarget.Items.Add(aTarget);

    if edTarget.Text <> '' then
      PaintEditByTarget(edTarget.Text);
  end;
end;

procedure TfrmRPCLog.sbFlagClick(Sender: TObject);
begin
  AddFlag(RPCLog_Flag);
end;

procedure TfrmRPCLog.AddFlag(aFlag: String; aComment: String = '');
var
  sl: TstringList;
begin
  // flag by date
  sl := TstringList.Create;
  sl.Add(FormatDateTime('yyyy/mm/dd hh:nn:ss.zzz', Now));
  sl.Add(aComment);
  AddNonRPCtoList(LACT_FLAG, aFlag, '', '', sl)
end;

procedure TfrmRPCLog.AddNonRPCtoList(const Action: TLog_ActionType; const aRPC: TRPC; AutoSelectEntry: Boolean = True);
begin
  aRPC.Owner := FLogList;
  FLogList.RPCList.Add(aRPC);

  // add to log action list
  FLogList.LogActionList.Add(Action, aRPC);

  RefreshRPCListView;

  if AutoSelectEntry then
    lvRPCLog.ItemIndex := 0;
end;

procedure TfrmRPCLog.AddNonRPCtoList(const Action: TLog_ActionType; Const Caption, RanAt, Duration: String; Data: TstringList = nil; AutoSelectEntry: Boolean = True);
var
  aRPC: TRPC;

begin
  // add to RPC list
  aRPC := TRPC.Create(nil);
  aRPC.Assign(Data);
  aRPC.Name := Caption;
  aRPC.RanAt := RanAt;
  aRPC.Duration := Duration;
  AddNonRPCtoList(Action, aRPC, AutoSelectEntry) ;
end;

procedure TfrmRPCLog.OnAddCallList(const Value: TRPC);
begin
  if assigned(frmRPCLog) then
  begin
    FLogList.RPCList.Add(Value);
    RefreshRPCListView;
  end;
end;

procedure TfrmRPCLog.OnDeleteCallList(const Value: TRPC);
var
  aRPC: RPCList.TRPC;
begin
  if assigned(frmRPCLog) then
  begin
    // remove from Action list
    FLogList.LogActionList.Remove(Value);

    // remove from RPC list
    FLogList.RPCList.Remove(Value);

    // remove custom log entry if first (inverted list)
    aRPC := (FLogList.RPCList.Items[0] as RPCList.TRPC);
    if aRPC.Owner = FLogList then
      FLogList.RPCList.Remove(aRPC);

    RefreshRPCListView;
  end;
end;

procedure TfrmRPCLog.PaintEditByTarget(aSearchTarget: String; aColor: TColor = clYellow);
var
  CharPos, CharPos2: Integer;
begin
  CharPos := 0;
  repeat
    // find the text and save the position
    CharPos2 := memData.FindText(aSearchTarget, CharPos, Length(memData.Text), []);
    CharPos := CharPos2 + 1;
    if CharPos = 0 then
      break;

    HighlightRichEdit(CharPos2, Length(aSearchTarget), aColor);

  until CharPos = 0;
end;

procedure TfrmRPCLog.pnlToolsDblClick(Sender: TObject);
begin
  inherited;
  HighlightRichEdit(1, Length(memData.Text), clWhite);
end;

procedure TfrmRPCLog.setLogLength(aCount: Integer);
begin
  if aCount < ORNet.GetRPCMax then
  begin
    if infoBox('The new size is less than the current number of records in the Log' + CRLF + 'Extra records will be discarded' + CRLF + CRLF +
      'Press "OK" to continue or "Cancel" to keep the current size', 'Confirmation required', MB_OKCANCEL) <> IDOK then
      Exit
  end;

  SetRetainedRPCMax(aCount);
  RefreshRPCListView;
  setActionStatus;
end;

procedure TfrmRPCLog.ClearSelection;
begin
  lvRPCLog.ItemIndex := -1;
  if memData.Lines.Count > 0 then
    memData.Clear;
  if FileSave.Visible then
    FileSave.Enabled := false;      
end;

procedure TfrmRPCLog.RefreshRPCListView;
begin
  lvRPCLog.Items.BeginUpdate;
  try
    lvRPCLog.Items.Count := FLogList.RPCList.Count;
    lvRPCLog.Invalidate;
    PositionReport;

    // force reselection
    if lvRPCLog.ItemIndex <> -1 then
      ClearSelection;
      
  finally
    lvRPCLog.Items.EndUpdate;
  end;
end;

procedure TfrmRPCLog.setActionStatus;
begin
  if not assigned(lvRPCLog) then
    Exit;
  acOnePrev.Enabled := (lvRPCLog.ItemIndex < FLogList.RPCList.Count - 1);
  acOneNext.Enabled := (lvRPCLog.ItemIndex > 0);
  acClearLog.Enabled := (FLogList.RPCList.Count > 0);
end;

procedure TfrmRPCLog.doSaveAs(aFileName: string; CurrentOnly: Boolean = true);
const
  Header = '%s %s^%s^%s %s';
var
  ReturnCursor, LookupIndex: Integer;
  SaveSL: TstringList;
  aRPC: TRPC;
  aJSONObject: TJSONObject;
begin
  ReturnCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  SaveSL := TstringList.Create;
  try
    If CurrentOnly then
    begin
      LookupIndex := (FLogList.RPCList.Count - 1) - lvRPCLog.ItemIndex;
      aRPC := FLogList.RPCList.Items[LookupIndex];
      aRPC.ToJSON(aJSONObject);
    end
    else
      FLogList.RPCList.ToJson(aJSONObject);

    SaveSl.Add(aJSONObject.Format);
    SaveSL.SaveToFile(aFileName);
  finally
    FreeAndNil(SaveSL);
    Screen.Cursor := ReturnCursor
  end;
end;

procedure TfrmRPCLog.SaveAll;
begin
  if acSaveOnExit.Checked then
    doSaveAs(RPCLogDefaultFileName, False);
end;

procedure TfrmRPCLog.doLoadFromFile(aFileName: String);

  procedure AddRPCToList(aJSONObject: TJsonObject; Header: String);
  var
    aRPC: TRPC;
  begin
    if not Assigned(aJSONObject) then
      Exit;
    try
      aRPC := TRPC.Create(nil);
      aRPC.LoadFromJsonObject(aJSONObject);
      aRPC.Insert(0, Header);
      AddNonRPCtoList(LACT_EXPORT, aRPC, False);
    except
      on e: Exception do
       Raise Exception.create('Unable to import RPC. Error was ' + e.Message);
    end;
  end;

const
  RPCHeader = 'IMPORT on %s from %s';
var
  ReturnCursor: Integer;
  ImportRPCString: String;
  SL: TstringList;
  JSONObject: TJsonObject;
  RPCArray: TJsonArray;
begin
  ReturnCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  SL := nil;
  try
    SL := TstringList.Create;
    SL.Sorted := false;
    SL.LoadFromFile(aFileName);

    if SL.Count > 0 then
    begin
      // Grab file header
      ImportRPCString := Format(RPCHeader,
        [FormatDateTime('yyyy/mm/dd hh:nn:ss.zzz', Now), aFileName]);
      ImportRPCString := StringOfChar('=', 10) + ' ' + ImportRPCString + ' ' +
        StringOfChar('=', 10);

      JSONObject := TJsonObject.ParseJSONValue(SL.Text) as TJsonObject;
      try
        lvRPCLog.Items.BeginUpdate;
        try
          if JSONObject.TryGetValue<TJsonArray>('RPCS', RPCArray) then
          begin
            for var i := 0 to RPCArray.Count - 1 do
              AddRPCToList(RPCArray.Items[i] as TJsonObject, ImportRPCString);
          end
          else
            AddRPCToList(JSONObject, ImportRPCString);

          RefreshRPCListView;
        finally
          lvRPCLog.Items.EndUpdate;
        end;
      finally
        JSONObject.Free;
      end;
    end;

  finally
    FreeAndNil(SL);
    Screen.Cursor := ReturnCursor;
  end;

end;

procedure TfrmRPCLog.AlignBroker(AlignStyle: TAlign);
var
  frm: TForm;
  iLog: Integer;
  R: TRect;

const
  RpcLogPart = 3;

begin
  frm := Application.MainForm;
  R := frm.Monitor.WorkareaRect;

  iLog := R.width div RpcLogPart;

  frm.Top := R.Top;
  frm.Height := R.Bottom - R.Top;
  frm.width := R.width - iLog;

  Height := frm.Height;
  Top := R.Top;

  width := iLog;

  case AlignStyle of
    alNone, alTop, alBottom, alClient, alCustom:
      ;

    alLeft:
      begin
        frm.Left := frm.Monitor.Left + iLog;
        Left := frm.Monitor.Left;

      end;
    alRight:
      begin
        frm.Left := frm.Monitor.Left;
        Left := frm.Monitor.Left + frm.width;
      end;

  end;
end;

procedure TfrmRPCLog.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := 0;
end;

{ TRPC }

function TLogAction.GetActionType: TLog_ActionType;
begin
  Exit(FActionType);
end;

function TLogAction.GetRPC: TRPC;
begin
  Exit(FRPC);
end;

function TLogAction.GetSearchResults: Boolean;
begin
  Exit(FSearchResults);
end;

procedure TLogAction.SetActionType(const Value: TLog_ActionType);
begin
  FActionType := Value;
end;

procedure TLogAction.SetRPC(const Value: TRPC);
begin
  FRPC := Value;
end;

procedure TLogAction.SetSearchResults(const Value: Boolean);
begin
  FSearchResults := Value;
end;

{ TRPCLog }

constructor TRPCLog.Create;
begin
  inherited;
  FRPCList := TRPCList.Create(False, nil);
  FLogActionList := TLogActionList.Create;
end;

destructor TRPCLog.Destroy;
begin
  FreeAndNil(FLogActionList);
  FreeAndNil(FRPCList);
  inherited;
end;

function TRPCLog.GetLogActionList: TLogActionList;
begin
  Exit(FLogActionList);
end;

function TRPCLog.GetRPCList: TRPCList;
begin
  Exit(FRPCList);
end;

{ TActionList }

function TLogActionList.Add(ActionType: TLog_ActionType; RPC: TRPC): TLogAction;
var
  aActionItem: TLogAction;
  RtnIndex: Integer;
begin
  aActionItem := TLogAction.Create;
  aActionItem.ActionType := ActionType;
  aActionItem.RPC := RPC;

  RtnIndex := FList.Add(aActionItem);
  Exit(FList[RtnIndex]);
end;

constructor TLogActionList.Create;
begin
  Inherited;
  FList := TObjectList<TLogAction>.Create;
end;

procedure TLogActionList.Remove(RPC: TRPC);
var
  aActionItem: TLogAction;
begin
  aActionItem := Actions[RPC];
  If assigned(aActionItem) then
    FList.Remove(aActionItem);
end;

destructor TLogActionList.Destroy;
begin
  FreeAndNil(FList);
  inherited;
end;

function TLogActionList.GetActions(const RPC: TRPC): TLogAction;
begin
  For var i := 0 to FList.Count - 1 do
  begin
    If FList[i].RPC = RPC then
      Exit(FList[i])
  end;
  Exit(nil);
end;

function TLogActionList.GetCount: Integer;
begin
  If assigned(FList) then
    Exit(FList.Count)
  else
    Exit(0);
end;

function TLogActionList.GetItems(Index: Integer): TLogAction;
begin
  Exit(FList.Items[Index]);
end;

procedure TLogActionList.SetActions(const RPC: TRPC; const Value: TLogAction);
begin
  For var i := 0 to FList.Count - 1 do
  begin
    If FList[i].RPC = RPC then
      FList[i] := Value;
  end;
end;

end.
