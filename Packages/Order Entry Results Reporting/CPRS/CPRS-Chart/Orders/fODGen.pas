unit fODGen;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fODBase, ComCtrls, ExtCtrls, StdCtrls, ORDtTm, ORCtrls, ORFn, rODBase, fBase508Form,
  VA508AccessibilityManager;

type
  TDialogCtrl = class
  public
    ID: string;
    DataType: Char;
    Required: Boolean;
    Preserve: Boolean;
    Prompt: TStaticText;
    Editor: TWinControl;
    IHidden: string;
    EHidden: string;
  end;

  TfrmODGen = class(TfrmODBase)
    sbxMain: TScrollBox;
    lblOrderSig: TLabel;
    VA508CompMemOrder: TVA508ComponentAccessibility;
    gpMain: TGridPanel;
    pnlButtons: TPanel;
    pnlGridMessage: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cmdAcceptClick(Sender: TObject);
    procedure VA508CompMemOrderStateQuery(Sender: TObject; var Text: string);
    procedure FormResize(Sender: TObject);
    procedure lblOrderSigClick(Sender: TObject);
  private
    fShowMessage: Boolean;
    FilterOut: boolean;
    TsID: string; //treating specialty id
    TSDomain: string;
    AttendID: string;
    AttendDomain: string;
    procedure ControlChange(Sender: TObject);
    procedure LookupNeedData(Sender: TObject; const StartFrom: string;
      Direction, InsertAt: Integer);
    procedure PlaceControls;
    procedure PlaceDateTime(DialogCtrl: TDialogCtrl; DialogItem: TDialogItem; CurrentItemNumber: Integer);
    procedure PlaceFreeText(DialogCtrl: TDialogCtrl; DialogItem: TDialogItem; CurrentItemNumber: Integer);
    procedure PlaceHidden(DialogCtrl: TDialogCtrl; DialogItem: TDialogItem);
    procedure PlaceNumeric(DialogCtrl: TDialogCtrl; DialogItem: TDialogItem; CurrentItemNumber: Integer);
    procedure PlaceSetOfCodes(DialogCtrl: TDialogCtrl; DialogItem: TDialogItem; CurrentItemNumber: Integer);
    procedure PlaceYesNo(DialogCtrl: TDialogCtrl; DialogItem: TDialogItem; CurrentItemNumber: Integer);
    procedure PlaceLookup(DialogCtrl: TDialogCtrl; DialogItem: TDialogItem; CurrentItemNumber: Integer);
    procedure PlaceMemo(DialogCtrl: TDialogCtrl; DialogItem: TDialogItem; CurrentItemNumber: Integer);
    procedure PlaceLabel(DialogCtrl: TDialogCtrl; DialogItem: TDialogItem);
    procedure TrimAllMemos;
    procedure SetComponentName(Editor: TWinControl; Index: Integer; DialogCtrl: TDialogCtrl);
    procedure setupControls;
    procedure UpdateVisualControls;
  protected
    FFormCloseCalled : Boolean;
    FCharHt: Integer;
    FCharWd: Integer;
    FDialogItemList: TList;
    FDialogCtrlList: TList;
    FEditorLeft: Integer;
    FEditorTop: Integer;
    FFirstCtrl: TWinControl;
    FLabelWd: Integer;
    procedure InitDialog; override;
    procedure SetDialogIEN(Value: Integer); override;
    procedure Validate(var AnErrMsg: string); override;
    procedure UpdateAccessibilityActions(var Actions: TAccessibilityActions); override;
    procedure ShowOrderMessage(Show: boolean); override;
  public
    procedure SetFontSize(FontSize: integer); override;
    procedure SetupDialog(OrderAction: Integer; const ID: string); override;
  end;

var
  frmODGen: TfrmODGen;

implementation

{$R *.DFM}

uses rCore, rOrders, uConst, VAUtils, uSizing, uOwnerWrapper, UResponsiveGUI;

const
  HT_FRAME  = 8;
  HT_LBLOFF = 3;
  HT_SPACE  = 6;
  WD_MARGIN = 6;
  TX_STOPSTART   = 'The stop date must be after the start date.';

procedure TfrmODGen.FormCreate(Sender: TObject);
var
  TheEvtType: string;
  IDs,TSstr, AttendStr: string;
begin
  FFormCloseCalled := false;
  inherited;
  FilterOut := True;
  if Self.EvtID < 1 then
    FilterOut := False;
  if Self.EvtID > 0 then
  begin
    TheEvtType := Piece(EventInfo1(IntToStr(Self.EvtId)), '^', 1);
    if (TheEvtType = 'A') or (TheEvtType = 'T') or (TheEvtType = 'M') or (TheEvtType = 'O') then
      FilterOut := False;
  end;
  FillerID := 'OR';                     // does 'on Display' order check **KCM**
  IDs := GetPromptIDs;
  TSstr := Piece(IDs,'~',1);
  TsDomain := Piece(TSstr,'^', 1);
  TsID := Piece(TSstr,'^', 2);
  AttendStr := Piece(IDs,'~',2);
  AttendDomain := Piece(AttendStr,'^',1);
  AttendID := Piece(AttendStr,'^',2);
  FDialogItemList := TList.Create;
  FDialogCtrlList := TList.Create;

  AutoSizeDisabled := true;
  setupControls;
  fShowMessage := False;
  ShowOrderMessage(fShowMessage);
end;

procedure TfrmODGen.FormResize(Sender: TObject);
begin
  inherited;
  lblOrderSig.Top := Height - gpMain.Height - lblOrderSig.Height;
end;

procedure TfrmODGen.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: Integer;
  DialogCtrl: TDialogCtrl;
begin
  with FDialogItemList do for i := 0 to Count - 1 do TDialogItem(Items[i]).Free;
  with FDialogCtrlList do for i := 0 to Count - 1 do
  begin
    DialogCtrl := TDialogCtrl(Items[i]);
    with DialogCtrl do
    begin
      if Prompt <> nil then Prompt.Free;
      if Editor <> nil then case DataType of
      'D': TORDateBox(Editor).Free;
      'F': TEdit(Editor).Free;
      'N': TEdit(Editor).Free;
      'P': TORComboBox(Editor).Free;
      'R': TORDateBox(Editor).Free;
      'S': TORComboBox(Editor).Free;
      'W': TMemo(Editor).Free;
      'Y': TORComboBox(Editor).Free;
      else Editor.Free;
      end;
      Free;
    end;
  end;
  FDialogItemList.Free;
  FDialogCtrlList.Free;
  FFormCloseCalled := true;
  inherited;
end;

procedure TfrmODGen.SetDialogIEN(Value: Integer);
{ Sets up a generic ordering dialog on the fly.  Called before SetupDialog. }
var
  DialogNames: TDialogNames;
begin
  inherited;
  StatusText('Loading Dialog Definition');
  IdentifyDialog(DialogNames, DialogIEN);
  Caption := DialogNames.Display;
  Responses.Dialog := DialogNames.BaseName;                      // loads formatting info
  LoadOrderPrompting(FDialogItemList, DialogNames.BaseIEN);      // loads prompting info
  PlaceControls;
  StatusText('');
end;

procedure TfrmODGen.SetupDialog(OrderAction: Integer; const ID: string);
var
  i: Integer;
  theEvtInfo: string;
  thePromptIen: integer;
  AResponse: TResponse;
  AnEvtResponse: TResponse;
begin
  inherited;
  if OrderAction in [ORDER_COPY, ORDER_EDIT, ORDER_QUICK] then with Responses do
  begin
    Changing := True;
    // for copy & edit, SetDialogIEN hasn't been called yet
    if (Length(ID) > 0) and (DialogIEN = 0) then SetDialogIEN(DialogForOrder(ID));
    with FDialogCtrlList do for i := 0 to Count -1 do with TDialogCtrl(Items[i]) do
    begin
      if (ID = 'EVENT') and ( Responses.EventIFN > 0 ) then
      begin
        thePromptIen := GetIENForPrompt(ID);
        if thePromptIen = 0 then
          thePromptIen := GetEventPromptID;
        AResponse := FindResponseByName('EVENT', 1);
        if AResponse <> nil then
        begin
          theEvtInfo := EventInfo1(AResponse.IValue);
          AResponse.EValue := Piece(theEvtInfo,'^',4);
        end;
        if AResponse = nil then
        begin
          AnEvtResponse := TResponse.Create;
          AnEvtResponse.PromptID  := 'EVENT';
          AnEvtResponse.PromptIEN := thePromptIen;
          AnEvtResponse.Instance  := 1;
          AnEvtResponse.IValue    := IntToStr(Responses.EventIFN);
          theEvtInfo := EventInfo1(AnEvtResponse.IValue);
          AnEvtResponse.EValue := Piece(theEvtInfo,'^',4);
          Responses.TheList.Add(AnEvtResponse);
        end;
      end;
      if Editor <> nil then SetControl(Editor, ID, 1);
      if DataType = 'H' then
      begin
        AResponse := FindResponseByName(ID, 1);
        if AResponse <> nil then
        begin
          IHidden := AResponse.IValue;
          EHidden := AResponse.EValue;
        end; {if AResponse}
      end; {if DataType}
    end; {with TDialogCtrl}
    Changing := False;
  end; {if OrderAction}
  UpdateColorsFor508Compliance(Self);
  ControlChange(Self);
  if (FFirstCtrl <> nil) and (FFirstCtrl.Enabled) then SetFocusedControl(FFirstCtrl);
end;

procedure TfrmODGen.UpdateAccessibilityActions(var Actions: TAccessibilityActions);
begin
  exclude(Actions, aaColorConversion);
end;

procedure TfrmODGen.InitDialog;
var
  i: Integer;
begin
  inherited; // inherited does a ClearControls (probably never called since always quick order)
  {NEED TO CLEAR CONTROLS HERE OR CHANGE ClearControls so can clear children of container}
  with FDialogCtrlList do for i := 0 to Count -1 do
    with TDialogCtrl(Items[i]) do if (Editor <> nil) and not Preserve then
    begin
      // treat the list & combo boxes differently so their lists aren't cleared
      if      (Editor is TListBox)    then TListBox(Editor).ItemIndex := -1
      else if (Editor is TComboBox)   then
      begin
        TComboBox(Editor).Text := '';
        TComboBox(Editor).ItemIndex := -1;
      end
      else if (Editor is TORComboBox) then
      begin
        TORComboBox(Editor).Text := '';
        TORComboBox(Editor).ItemIndex := -1;
      end
      else ClearControl(Editor);
    end;
  if FFirstCtrl <> nil then ActiveControl := FFirstCtrl;
end;

procedure TfrmODGen.lblOrderSigClick(Sender: TObject);
begin
  inherited;
{$IFDEF DEBUG}
//  fShowMessage := not fShowMessage;
//  ShowOrderMessage(fShowMessage);
{$ENDIF}
end;

procedure TfrmODGen.VA508CompMemOrderStateQuery(Sender: TObject;
  var Text: string);
begin
  inherited;
  Text := memOrder.Text;
end;

procedure TfrmODGen.Validate(var AnErrMsg: string);
var
  i: Integer;
  ALabel, AMsg: string;
  AResponse: TResponse;
  DialogCtrl: TDialogCtrl;
  StartDT, StopDT: TFMDateTime;

  procedure SetError(const x: string);
  begin
    if Length(AnErrMsg) > 0 then AnErrMsg := AnErrMsg + CRLF;
    AnErrMsg := AnErrMsg + x;
  end;

begin
  inherited;
  with FDialogCtrlList do for i := 0 to Count -1 do
  begin
    DialogCtrl := TDialogCtrl(Items[i]);
    with DialogCtrl do
    begin
      if Prompt <> nil then ALabel := Piece(Prompt.Caption, ':', 1) else ALabel := '<Unknown>';
      if Required then
      begin
        AResponse := Responses.FindResponseByName(ID, 1);
        if (AResponse = nil) or ((AResponse <> nil) and (Trim(AResponse.EValue) = ''))
          then SetError(ALabel + ' is required.');
      end;
      if ((DataType = 'D') or (DataType = 'R')) and (Editor <> nil) then
      begin
        TORDateBox(Editor).Validate(AMsg);
        if Length(AMsg) > 0 then SetError('For ' + ALabel + ':  ' + AMsg);
      end;
      if (DataType = 'N') then
      begin
        AResponse := Responses.FindResponseByName(ID, 1);
        if (AResponse <> nil) and (Length(AResponse.EValue) > 0) then with AResponse do
        begin
          ValidateNumericStr(EValue, Piece(TEdit(Editor).Hint, '|', 2), AMsg);
          if Length(AMsg) > 0 then SetError('For ' + ALabel + ':  ' + AMsg);
        end; {if AResponse}
      end; {if DataType}
    end; {with DialogCtrl}
  end; {with FDialogCtrlList}
  with Responses do
  begin
    AResponse := FindResponseByName('START', 1);
    if AResponse <> nil then StartDT := StrToFMDateTime(AResponse.EValue) else StartDT := 0;
    AResponse := FindResponseByName('STOP',  1);
    if AResponse <> nil then StopDT  := StrToFMDateTime(AResponse.EValue) else StopDT  := 0;
    if (StopDT > 0) and (StopDT <= StartDT) then SetError(TX_STOPSTART);
  end;
end;

procedure TfrmODGen.PlaceControls;
var
  i: Integer;
  DialogItem: TDialogItem;
  DialogCtrl: TDialogCtrl;
begin
  FCharHt := MainFontHeight;
  FCharWd := MainFontWidth;
  FEditorTop := HT_SPACE;
  FLabelWd := 0;
  with FDialogItemList do for i := 0 to Count - 1 do with TDialogItem(Items[i]) do
    if not Hidden then FLabelWd := HigherOf(FLabelWd, Canvas.TextWidth(Prompt));
  FEditorLeft := FLabelWd + (WD_MARGIN * 2);
  with FDialogItemList do for i := 0 to Count - 1 do
  begin
    DialogItem := TDialogItem(Items[i]);
    if FilterOut then
    begin
      if ( compareText(TsID,DialogItem.Id)=0 ) or ( compareText(TSDomain,DialogItem.Domain)=0) then
        Continue;
      if (Pos('primary',LowerCase(DialogItem.Prompt)) > 0) then
        Continue;
      if (compareText(AttendID,DialogItem.ID) = 0) or ( compareText(AttendDomain,DialogItem.Domain)=0 ) then
        Continue;
    end;
    DialogCtrl := TDialogCtrl.Create;
    DialogCtrl.ID       := DialogItem.ID;
    DialogCtrl.DataType := DialogItem.DataType;
    DialogCtrl.Required := DialogItem.Required;
    DialogCtrl.Preserve := Length(DialogItem.EDefault) > 0;
    case DialogItem.DataType of
    'D': PlaceDateTime(DialogCtrl, DialogItem, I);
    'F': PlaceFreeText(DialogCtrl, DialogItem, i);
    'H': PlaceHidden(DialogCtrl, DialogItem);
    'N': PlaceNumeric(DialogCtrl, DialogItem, i);
    'P': PlaceLookup(DialogCtrl, DialogItem, i);
    'R': PlaceDateTime(DialogCtrl, DialogItem, i);
    'S': PlaceSetOfCodes(DialogCtrl, DialogItem, i);
    'W': PlaceMemo(DialogCtrl, DialogItem, i);
    'Y': PlaceYesNo(DialogCtrl, DialogItem, i);
    end;
    FDialogCtrlList.Add(DialogCtrl);
    if (DialogCtrl.Editor <> nil) and (FFirstCtrl = nil) then FFirstCtrl := DialogCtrl.Editor;
  end;
end;

procedure TfrmODGen.PlaceDateTime(DialogCtrl: TDialogCtrl; DialogItem: TDialogItem; CurrentItemNumber: Integer);
var
  item: TVA508AccessibilityItem;
  id508: integer;
const
  NUM_CHAR = 22;
begin
  with DialogCtrl do
  begin
    Editor := TORDateBox.Create(Self);
    Editor.Parent := sbxMain;
    Editor.SetBounds(FEditorLeft, FEditorTop, NUM_CHAR * FCharWd, HT_FRAME * FCharHt);
    TORDateBox(Editor).DateOnly := Pos('T', DialogItem.Domain) = 0;
    with TORDateBox(Editor) do RequireTime := (not DateOnly) and (Pos('R', DialogItem.Domain) > 0); //v26.48 - RV  PSI-05-002
    SetComponentName(Editor, CurrentItemNumber, DialogCtrl);
  //  TORDateBox(Editor).Name := DialogCtrl.ID + IntToStr(CurrentItemNumber);
    TORDateBox(Editor).Text := DialogItem.EDefault;
    TORDateBox(Editor).Hint := DialogItem.HelpText;
    TORDateBox(Editor).Caption := DialogItem.Prompt;
    if Length(DialogItem.HelpText) > 0 then TORDateBox(Editor).ShowHint := True;
    TORDateBox(Editor).OnExit := ControlChange;
    PlaceLabel(DialogCtrl, DialogItem);
    FEditorTop := FEditorTop + HT_FRAME + FCharHt + HT_SPACE;

    amgrMain.AccessData.Add.component := Editor;
    item := amgrMain.AccessData.FindItem(Editor, False);
    id508:= item.INDEX;
    amgrMain.AccessData[id508].AccessText := TORDateBox(Editor).Caption + ' Press the enter key to access.';

 end;
end;

procedure TfrmODGen.PlaceFreeText(DialogCtrl: TDialogCtrl; DialogItem: TDialogItem; CurrentItemNumber: Integer);
begin
  with DialogCtrl do
  begin
    Editor := TCaptionEdit.Create(Self);
    Editor.Parent := sbxMain;
    Editor.SetBounds(FEditorLeft, FEditorTop,
                     sbxMain.Width - FEditorLeft - WD_MARGIN - GetSystemMetrics(SM_CXVSCROLL),
                     HT_FRAME * FCharHt);
    Editor.Anchors := Editor.Anchors + [akRight];
    TEdit(Editor).MaxLength := StrToIntDef(Piece(DialogItem.Domain, ':', 2), 0);
    SetComponentName(Editor, CurrentItemNumber, DialogCtrl);
  //  TCaptionEdit(Editor).Name := DialogCtrl.ID + IntToStr(CurrentItemNumber);
    TEdit(Editor).Text := DialogItem.EDefault;
    TEdit(Editor).Hint := DialogItem.HelpText;
    TCaptionEdit(Editor).Caption := DialogItem.Prompt;
    if Length(DialogItem.HelpText) > 0 then TEdit(Editor).ShowHint := True;
    TEdit(Editor).OnChange := ControlChange;
    PlaceLabel(DialogCtrl, DialogItem);
    FEditorTop := FEditorTop + HT_FRAME + FCharHt + HT_SPACE;
  end;
end;

procedure TfrmODGen.PlaceNumeric(DialogCtrl: TDialogCtrl; DialogItem: TDialogItem; CurrentItemNumber: Integer);
const
  NUM_CHAR = 16;
begin
  with DialogCtrl do
  begin
    Editor := TCaptionEdit.Create(Self);
    Editor.Parent := sbxMain;
    Editor.SetBounds(FEditorLeft, FEditorTop, NUM_CHAR * FCharWd, HT_FRAME * FCharHt);
    TEdit(Editor).MaxLength := NUM_CHAR;
    SetComponentName(Editor, CurrentItemNumber, DialogCtrl);
   // TCaptionEdit(Editor).Name := DialogCtrl.ID + IntToStr(CurrentItemNumber);
    TEdit(Editor).Text := DialogItem.EDefault;
    TEdit(Editor).Hint := DialogItem.HelpText + '|' + DialogItem.Domain;
    TCaptionEdit(Editor).Caption := DialogItem.Prompt;
    if Length(DialogItem.HelpText) > 0 then TEdit(Editor).ShowHint := True;
    TEdit(Editor).OnChange := ControlChange;
    PlaceLabel(DialogCtrl, DialogItem);
    FEditorTop := FEditorTop + HT_FRAME + FCharHt + HT_SPACE;
  end;
end;

procedure TfrmODGen.PlaceSetOfCodes(DialogCtrl: TDialogCtrl; DialogItem: TDialogItem; CurrentItemNumber: Integer);
const
  NUM_CHAR = 32;
var
  x, y: string;
begin
  with DialogCtrl do
  begin
    Editor := TORComboBox.Create(Self);
    Editor.Parent := sbxMain;
    TORComboBox(Editor).Style := orcsDropDown;
    TORComboBox(Editor).ListItemsOnly := True;
    TORComboBox(Editor).Pieces := '2';
    SetComponentName(Editor, CurrentItemNumber, DialogCtrl);
  //  TORComboBox(Editor).Name := DialogCtrl.ID + IntToStr(CurrentItemNumber);
    Editor.SetBounds(FEditorLeft, FEditorTop, NUM_CHAR * FCharWd, HT_FRAME * FCharHt);
    x := DialogItem.Domain;
    repeat
      y := Piece(x, ';', 1);
      Delete(x, 1, Length(y) + 1);
      y := Piece(y, ':', 1) + U + Piece(y, ':', 2);
      TORComboBox(Editor).Items.Add(y);
    until Length(x) = 0;
    TORComboBox(Editor).SelectByID(DialogItem.IDefault);
    //TORComboBox(Editor).Text := DialogItem.EDefault;
    TORComboBox(Editor).RpcCall := DialogItem.HelpText;
    if Length(DialogItem.HelpText) > 0 then TORComboBox(Editor).ShowHint := True;
    TORComboBox(Editor).OnChange := ControlChange;
    PlaceLabel(DialogCtrl, DialogItem);
    FEditorTop := FEditorTop + HT_FRAME + FCharHt + HT_SPACE;
  end;
end;

procedure TfrmODGen.PlaceYesNo(DialogCtrl: TDialogCtrl; DialogItem: TDialogItem; CurrentItemNumber: Integer);
const
  NUM_CHAR = 9;
begin
  with DialogCtrl do
  begin
    Editor := TORComboBox.Create(Self);
    Editor.Parent := sbxMain;
    TORComboBox(Editor).Style := orcsDropDown;
    TORComboBox(Editor).ListItemsOnly := True;
    TORComboBox(Editor).Pieces := '2';
    SetComponentName(Editor, CurrentItemNumber, DialogCtrl);
    //TORComboBox(Editor).Name := DialogCtrl.ID + IntToStr(CurrentItemNumber);
    Editor.SetBounds(FEditorLeft, FEditorTop, NUM_CHAR * FCharWd, HT_FRAME * FCharHt);
    TORComboBox(Editor).Items.Add('0^No');
    TORComboBox(Editor).Items.Add('1^Yes');
    TORComboBox(Editor).SelectByID(DialogItem.IDefault);
    //TORComboBox(Editor).Text := DialogItem.EDefault;
    TORComboBox(Editor).RpcCall := DialogItem.HelpText;
    if Length(DialogItem.HelpText) > 0 then TORComboBox(Editor).ShowHint := True;
    TORComboBox(Editor).OnChange := ControlChange;
    PlaceLabel(DialogCtrl, DialogItem);
    FEditorTop := FEditorTop + HT_FRAME + FCharHt + HT_SPACE;
  end;
end;

procedure TfrmODGen.PlaceLookup(DialogCtrl: TDialogCtrl; DialogItem: TDialogItem; CurrentItemNumber: Integer);
const
  NUM_CHAR = 32;
var
  idx,defidx,evtChars: integer;
  GblRef, XRef: string;
  TopTSList: TStringList;
begin
  with DialogCtrl do
  begin
    GblRef := DialogItem.Domain;
    if CharInSet(CharAt(GblRef, 1), ['0'..'9','.']) then
      GblRef := GlobalRefForFile(Piece(GblRef, ':', 1))
    else
      GblRef := Piece(GblRef, ':', 1);
    if CharAt(GblRef, 1) <> U then GblRef := U + GblRef;
    if Length(DialogItem.CrossRef) > 0 then XRef := DialogItem.CrossRef else XRef := 'B';
    XRef := GblRef + '"' + XRef + '")';
    Editor := TORComboBox.Create(Self);
    Editor.Parent := sbxMain;
    TORComboBox(Editor).Style := orcsDropDown;
    TORComboBox(Editor).ListItemsOnly := True;
    TORComboBox(Editor).Pieces := '2';
    TORComboBox(Editor).LongList := True;
     SetComponentName(Editor, CurrentItemNumber, DialogCtrl);
   // TORComboBox(Editor).Name := DialogCtrl.ID + IntToStr(CurrentItemNumber);
    // 2nd bar piece of hint is not visible, hide xref, global ref, & screen code in tab pieces
    TORComboBox(Editor).RpcCall := DialogItem.HelpText + '|' + XRef + #9 + GblRef + #9 +
                                DialogItem.ScreenRef;
    if ( compareText(TsID,DialogItem.Id)=0 ) or (compareText(TSDomain,DialogItem.Domain)=0)then
    begin
      TopTSList := TStringList.Create;
      DialogItem.IDefault := Piece(GetDefaultTSForEvt(Self.EvtID),'^',1);
      GetTSListForEvt(TStrings(TopTSList),Self.EvtID);
      if TopTSList.Count > 0 then
      begin
        if Length(DialogItem.IDefault)>0 then
        begin
          defidx := -1;
          for idx := 0 to topTSList.Count - 1 do
            if Piece(TopTSList[idx],'^',1)= DialogItem.IDefault then
            begin
              defidx := idx;
              break;
            end;
          if defidx >= 0 then
            topTSList.Move(defidx,0);
        end;
        with TORComboBox(Editor) do
        begin
          FastAddStrings(TStrings(TopTSList), TORComboBox(Editor).Items);
          LongList := false;
        end;
      end else
        TORComboBox(Editor).OnNeedData := LookupNeedData;
      if Length(DialogItem.IDefault)<1 then
        DialogItem.IDefault := '0';
    end else
      TORComboBox(Editor).OnNeedData := LookupNeedData;
    Editor.SetBounds(FEditorLeft, FEditorTop, NUM_CHAR * FCharWd, HT_FRAME * FCharHt);
    TORComboBox(Editor).InitLongList(DialogItem.EDefault);
    TORComboBox(Editor).SelectByID(DialogItem.IDefault);
    if Length(DialogItem.HelpText) > 0 then TORComboBox(Editor).ShowHint := True;
    TORComboBox(Editor).OnChange := ControlChange;
    if ( AnsiCompareText(ID,'EVENT')=0 ) and (Self.EvtID>0)then
    begin
       evtChars := length(Responses.EventName);
       if evtChars > NUM_CHAR then
          Editor.SetBounds(FEditorLeft, FEditorTop, (evtChars + 6) * FCharWd, HT_FRAME * FCharHt);
       TORComboBox(Editor).Enabled := False;
    end;
    PlaceLabel(DialogCtrl, DialogItem);
    FEditorTop := FEditorTop + HT_FRAME + FCharHt + HT_SPACE;
  end;
end;

procedure TfrmODGen.LookupNeedData(Sender: TObject; const StartFrom: string;
  Direction, InsertAt: Integer);
var
  sl: TStrings;
  XRef, GblRef, ScreenRef: string;
begin
  inherited;
  XRef := Piece(TORComboBox(Sender).RpcCall, '|', 2);
  GblRef := Piece(XRef, #9, 2);
  ScreenRef := Piece(XRef, #9, 3);
  XRef := Piece(XRef, #9, 1);

  // TORComboBox(Sender).ForDataUse(SubsetOfEntries(StartFrom, Direction, XRef, GblRef, ScreenRef));
  sl := TStringList.Create;
  try
    setSubsetOfEntries(sl, StartFrom, Direction, XRef, GblRef, ScreenRef);
    TORComboBox(Sender).ForDataUse(sl);
  finally
    sl.Free;
  end;
end;

procedure TfrmODGen.PlaceMemo(DialogCtrl: TDialogCtrl; DialogItem: TDialogItem; CurrentItemNumber: Integer);
const
  NUM_LINES = 3;
begin
  with DialogCtrl do
  begin
    Editor := TCaptionMemo.Create(Self);
    Editor.Parent := sbxMain;
    Editor.SetBounds(FEditorLeft, FEditorTop,
                     sbxMain.Width - FEditorLeft - WD_MARGIN - GetSystemMetrics(SM_CXVSCROLL),
                     (FCharHt * NUM_LINES) + HT_FRAME);
    SetComponentName(Editor, CurrentItemNumber, DialogCtrl);
   // TCaptionMemo(Editor).Name := DialogCtrl.ID + IntToStr(CurrentItemNumber);
    TMemo(Editor).Text := DialogItem.EDefault;
    TMemo(Editor).Hint := DialogItem.HelpText;
    TCaptionMemo(Editor).Caption := DialogItem.Prompt;
    if Length(DialogItem.HelpText) > 0 then TMemo(Editor).ShowHint := True;
    TMemo(Editor).ScrollBars := ssVertical;
    TMemo(Editor).OnChange := ControlChange;
    PlaceLabel(DialogCtrl, DialogItem);
    FEditorTop := FEditorTop + HT_FRAME + (FCharHt * 3) + HT_SPACE;
  end;
end;

procedure TfrmODGen.PlaceHidden(DialogCtrl: TDialogCtrl; DialogItem: TDialogItem);
begin
  DialogCtrl.IHidden := DialogItem.IDefault;
  DialogCtrl.EHidden := DialogItem.EDefault;
end;

procedure TfrmODGen.PlaceLabel(DialogCtrl: TDialogCtrl; DialogItem: TDialogItem);
var
  ht: integer;
begin
  with DialogCtrl do
  begin
    Prompt := TStaticText.Create(Self);
    Prompt.Parent := sbxMain;
    Prompt.Caption := DialogItem.Prompt;
    ht := Prompt.Height;   // CQ#15849
    if ht < FCharHt then
      ht := FCharHt;
    Prompt.AutoSize := False;
    Prompt.SetBounds(WD_MARGIN, FEditorTop + HT_LBLOFF, FLabelWd, ht);
    Prompt.Alignment := taRightJustify;
    Prompt.Visible := True;
  end;
end;

procedure TfrmODGen.TrimAllMemos;
var
  i : integer;
  Memo : TMemo;
begin
  if FFormCloseCalled then Exit; //it is possible for TrimAllMemos to get called after FormClose
  if Not Assigned(FDialogCtrlList) then Exit;
  for i := 0 to FDialogCtrlList.Count - 1 do
    if TDialogCtrl(FDialogCtrlList.Items[i]).Editor is TMemo then begin
      Memo := TMemo(TDialogCtrl(FDialogCtrlList.Items[i]).Editor);
      Memo.Lines.Text := Trim(Memo.Lines.Text);
    end;
end;

procedure TfrmODGen.cmdAcceptClick(Sender: TObject);
var
  ReleasePending: boolean;
  Msg: TMsg;
begin
  LockOwnerWrapper(Self);
  try
    inherited;
    // if the order dialog has ASK FOR ANOTHER ORDER set to YES, the form
    // will need to stick around
    // this is verified in the inherited cmdAcceptClick by calling AskAnotherOrder(..)
    // so if we're not *already* releasing, don't force the issue
    ReleasePending := PeekMessage(Msg, Handle, CM_RELEASE, CM_RELEASE, PM_REMOVE);
    TrimAllMemos;
    TResponsiveGUI.ProcessMessages;
    if ReleasePending then
      Release;
  finally
    UnlockOwnerWrapper(Self);
  end;
end;

procedure TfrmODGen.ControlChange(Sender: TObject);
var
  i: Integer;
begin
  inherited;
  if Changing then Exit;
  with FDialogCtrlList do for i := 0 to Count - 1 do with TDialogCtrl(Items[i]) do
  begin
    case DataType of
    'D': Responses.Update(ID, 1, FloatToStr(TORDateBox(Editor).FMDateTime),
                                 TORDateBox(Editor).Text);
    'F': Responses.Update(ID, 1, TEdit(Editor).Text, TEdit(Editor).Text);
    'H': Responses.Update(ID, 1, IHidden, EHidden);
    'N': Responses.Update(ID, 1, TEdit(Editor).Text, TEdit(Editor).Text);
    'P': Responses.Update(ID, 1, TORComboBox(Editor).ItemID, TORComboBox(Editor).Text);
    'R': Responses.Update(ID, 1, TORDateBox(Editor).Text, TORDateBox(Editor).Text);
    'S': Responses.Update(ID, 1, TORComboBox(Editor).ItemID, TORComboBox(Editor).Text);
    'W': Responses.Update(ID, 1, TX_WPTYPE, TMemo(Editor).Text);
    'Y': Responses.Update(ID, 1, TORComboBox(Editor).ItemID, TORComboBox(Editor).Text);
    end;
  end;
  memOrder.Text := Responses.OrderText;
end;

procedure TfrmODGen.SetComponentName(Editor: TWinControl; Index: Integer; DialogCtrl: TDialogCtrl);
Var
 I: Integer;
 SaveName: String;
begin
 //strip all non alphanumeric characters to create the save name
 SaveName := '';
 //Check for blank id
 if DialogCtrl.ID = '' then DialogCtrl.ID := 'EMPTY';

 for i := 1 to length(DialogCtrl.ID) do begin
   if CharInSet(DialogCtrl.ID[i], ['A'..'Z']) or
      CharInSet(DialogCtrl.ID[i], ['a'..'z']) or
      CharInSet(DialogCtrl.ID[i], ['0'..'9']) then
    SaveName := SaveName + DialogCtrl.ID[i];
 end;
 SaveName := SaveName + '_' + IntToStr(Index);

 //extra backup - make sure that the component name doesn't already exist
 //Now set up the component name
 try
  Editor.Name := SaveName;
 except
  Editor.Name := SaveName + '_' + IntToStr(Index);
 end;
end;

procedure TfrmODGen.ShowOrderMessage(Show: boolean);
begin
  fShowMessage := Show;

  pnlGridMessage.Visible := Show;
  memMessage.TabStop := Show;
  if Show then
    pnlGridMessage.Top := Height - pnlGridMessage.Height;

  lblOrderSig.Top := gpMain.Top - lblOrderSig.Height;

  pnlMessage.BringToFront;
  pnlMessage.Visible := True;

  Invalidate;
end;

procedure TfrmODGen.SetupControls;
begin
  // Move inherited controls onto the TGridPanel
  gpMain.ControlCollection.BeginUpdate;
  try
    gpMain.ControlCollection.AddControl(memOrder, 0, 0);
    memOrder.Parent := gpMain;
    memOrder.Align := alClient;
    memOrder.AlignWithMargins := True;

    gpMain.ControlCollection.AddControl(pnlButtons, 1, 0);
    pnlButtons.Parent := gpMain;
    pnlButtons.Align := alClient;

    cmdAccept.Parent := pnlButtons;
    cmdAccept.Align := alTop;
    cmdAccept.AlignWithMargins := True;
    cmdQuit.Parent := pnlButtons;
    cmdQuit.Align := alTop;
    cmdQuit.AlignWithMargins := True;
  finally
    gpMain.ControlCollection.EndUpdate;
  end;

  UpdateVisualControls;

  pnlGridMessage.Margins.Right := round(gpMain.ColumnCollection[1].Value);

  pnlMessage.Parent := pnlGridMessage;
  pnlMessage.Align := alClient;
  pnlMessage.AlignWithMargins := True;

end;

procedure TfrmODGen.UpdateVisualControls;
var
  i: Integer;
begin
  gpMain.ControlCollection.BeginUpdate;
  i := (getMainFormTextHeight + 10) * 4 + 8;
  if gpMain.RowCollection[0].Value < i then
  begin
    gpMain.Height := i;
    gpMain.RowCollection[0].Value := i;
  end;
  constraints.MinHeight := i * 4;

  pnlGridMessage.Height := gpMain.Height;

  i := getMainFormTextWidth('Accept Order') + 24;
  if gpMain.ColumnCollection[1].Value < i then
    gpMain.ColumnCollection[1].Value := i;

  constraints.MinWidth := i * 8;
  gpMain.ControlCollection.EndUpdate;
end;

procedure TfrmODGen.SetFontSize(FontSize: Integer);

begin
  Font.Size := FontSize;
  memMessage.DefAttributes.Size := FontSize;
  UpdateVisualControls;
end;

end.
