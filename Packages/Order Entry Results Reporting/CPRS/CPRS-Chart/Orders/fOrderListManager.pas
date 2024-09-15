unit fOrderListManager;
{ Allows processing order list}
{------------------------------------------------------------------------------
Update History
    2016-05-17: NSR#20110719 (Order Flag Recommendations)
-------------------------------------------------------------------------------}
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, fAutoSz, Vcl.StdCtrls, Vcl.ExtCtrls,
  VA508AccessibilityManager, Vcl.ComCtrls, fOrderFlagEditor, uOrderFlag, rOrders,
  ORFn, Vcl.ImgList, uConst, System.Actions, Vcl.ActnList, Vcl.Menus,
  iOrderFlagPropertiesEditorIntf, Vcl.Buttons, VA508ImageListLabeler, ORCtrls, fBase508Form,
  iResizableFormIntf, System.ImageList, u508button;

type
  TProcessor = function(anItem: TObject): String of object;

  TfrmListManager = class(TfrmBase508Form, iResizableForm)
    pnlTop: TPanel;
    pnlBottom: TPanel;
    pnlCanvas: TPanel;
    pnlCanvasPlate: TPanel;
    pnlList: TPanel;
    splList: TSplitter;
    pnlDetails: TPanel;
    pnlListStatus: TPanel;
    pnlDetailsCanvas: TPanel;
    pnlListCanvas: TPanel;
    pnlCancel: TPanel;
    btnCancel: u508button.TButton;
    lvItems: TListView;
    mmListStatus: TMemo;
    ilStatus: TImageList;
    pnlLegend: TPanel;
    alMain: TActionList;
    acLegend: TAction;
    acRemoveProcessed: TAction;
    acShowStatus: TAction;
    popList: TPopupMenu;
    Legend1: TMenuItem;
    ShowStatus1: TMenuItem;
    N1: TMenuItem;
    RemoveProcessed1: TMenuItem;
    acDebug: TAction;
    Debug1: TMenuItem;
    Button1: u508button.TButton;
    Button2: u508button.TButton;
    pnlFlagAdd: TPanel;
    Button3: u508button.TButton;
    acShowList: TAction;
    ShowItemList1: TMenuItem;
    pnlFlagComment: TPanel;
    pnlFlagRemove: TPanel;
    acReuseParameters1: TMenuItem;
    lvLegend: TListView;
    VA508StatusImgLst: TVA508ImageListLabeler;
    Panel1: TPanel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    alEditorActions: TActionList;
    acFlagRemove: TAction;
    acFlagComment: TAction;
    acFlagSet: TAction;
    alDebug: TActionList;
    acFont8: TAction;
    acFont10: TAction;
    acFont12: TAction;
    acFont14: TAction;
    acFont18: TAction;
    N2: TMenuItem;
    FontSize81: TMenuItem;
    FontSize101: TMenuItem;
    FontSize121: TMenuItem;
    FontSize141: TMenuItem;
    FontSize181: TMenuItem;
    acModeAdd: TAction;
    EditModeAdd1: TMenuItem;
    acModeEdit: TAction;
    acModeRemove: TAction;
    EditModeUpdate1: TMenuItem;
    ModeRemove1: TMenuItem;
    N3: TMenuItem;
    pnlOption: TPanel;
    cbReuseProperties: TCheckBox;
    acReUseProperties: TAction;
    cbRemoveProcessed: TCheckBox;
    lblWarning: TLabel;
    stxtRequired: TStaticText;
    Timer1: TTimer;
    btnFlagRecipients: u508button.TButton;
    procedure lvItemsResize(Sender: TObject);
    procedure lvItemsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure acLegendExecute(Sender: TObject);
    procedure acRemoveProcessedExecute(Sender: TObject);
    procedure acShowStatusExecute(Sender: TObject);
    procedure acDebugExecute(Sender: TObject);
    procedure acFlagSetExecute(Sender: TObject);
    procedure acFlagRemoveExecute(Sender: TObject);
    procedure acFlagCommentExecute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure acShowListExecute(Sender: TObject);
    procedure cbReusePropertiesClick(Sender: TObject);
    procedure lvLegendResize(Sender: TObject);
    procedure pnlCanvasResize(Sender: TObject);
    procedure acFont8Execute(Sender: TObject);
    procedure acModeAddExecute(Sender: TObject);
    procedure lvItemsClick(Sender: TObject);
    procedure acReUsePropertiesExecute(Sender: TObject);
    procedure btnFlagRecipientsClick(Sender: TObject);
  private
    { Private declarations }
    bIgnore: Boolean;
    ItemEditor: TForm;
    PropertiesEditor: IOrderFlagPropertiesEditor;

    procedure InitItemList(aList: TStrings);
    procedure UMORDFLAGSTATUS(var Message: TMessage); message UM_ORDFLAGSTATUS;

    function OrderFlagSet(anItem: TObject): String;
    function OrderFlagRemove(anItem: TObject): String;
    function OrderFlagComment(anItem: TObject): String;

    procedure SelectListItem(anItem: TListItem);
    procedure RemoveItemByStatus(aStatus: Integer);

    procedure setActionMode(aMode: TActionMode);
    function getActionMode: TActionMode;
    procedure PerformAction(aPerformer: TProcessor);

    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;

//    procedure setStateIndex(anItem:TListItem;anObject:TObject);

  protected
    // procedure Loaded;override;
  public
    { Public declarations }
    MasterForm: TForm;
    property ActionMode: TActionMode read getActionMode write setActionMode;
    procedure ResizeToFont(aSize: Integer);
  end;

function ProcessOrderList(aList: TStrings; aCaption, aComment: String;
  aMode: TActionMode; aMaster: TForm): Integer;

implementation

{$R *.dfm}

uses fOptions, uFormUtils, Math, fOrders, System.UITypes, VAUtils,
UResponsiveGUI;

function ProcessOrderList(aList: TStrings; aCaption, aComment: String;
  aMode: TActionMode; aMaster: TForm): Integer;
var
  frmListManager: TfrmListManager;
  FlagList: TStringList;
begin
  Result := -1;
  if aList.Count < 1 then
    exit;
  FlagList := nil;
  frmListManager := TfrmListManager.Create(Application);
  try
    FlagList := TStringList.Create(True);
{$IFDEF DEBUG}
    frmListManager.acDebug.Visible := True;
{$ELSE}
    frmListManager.acDebug.Visible := False;
{$ENDIF}
    frmListManager.pnlDetailsCanvas.ParentColor := True;
    frmListManager.stxtRequired.Visible := not ScreenReaderActive;
    frmListManager.ItemEditor := TfrmOrderFlag.createParented
      (frmListManager, frmListManager.pnlDetailsCanvas);
    if assigned(frmListManager.ItemEditor) then
      begin
        frmListManager.PropertiesEditor :=
          TfrmOrderFlag(frmListManager.ItemEditor);
        getOrderFlagInfoList(aList, FlagList);
        frmListManager.InitItemList(FlagList);
        frmListManager.SelectListItem(frmListManager.lvItems.Items[0]);
        frmListManager.Caption := aCaption;
        frmListManager.pnlTop.Caption := '  ' + aComment;
//        frmListManager.pnlTop.Visible := False; <-- to have space for Add Recipients btn
        frmListManager.ActionMode := aMode;
        frmListManager.acShowListExecute(nil);
        frmListManager.MasterForm := aMaster;

    //    frmListManager.cbReuseProperties.Visible := frmListManager.lvItems.Items.Count>1;
    //    frmListManager.pnlOption.Caption := '  Required fields are marked with '+PrefixRequired;

        frmListManager.ResizeToFont(Application.MainForm.Font.Size);
        Result := frmListManager.ShowModal;
      end
    else
      ShowMessage('Error creating Order Flag Editor');
  finally
    FlagList.Free;
    frmListManager.Free;
  end;
end;

/// /////////////////////////////////////////////////////////////////////////////

function TfrmListManager._AddRef: Integer;
begin
  Result := -1;
end;

function TfrmListManager._Release: Integer;
begin
  Result := -1;
end;

procedure TfrmListManager.acDebugExecute(Sender: TObject);
// set visibility of the debug components
begin
  inherited;
{$IFDEF DEBUG}

  acDebug.Checked := not acDebug.Checked;
  acReuseProperties.Enabled := True;
  acRemoveProcessed.Enabled := True;

  cbReuseProperties.Visible := acDebug.Checked;
  cbRemoveProcessed.Visible := acDebug.Checked;

  FontSize81.Visible := acDebug.Checked;
  FontSize101.Visible := acDebug.Checked;
  FontSize121.Visible := acDebug.Checked;
  FontSize141.Visible := acDebug.Checked;
  FontSize181.Visible := acDebug.Checked;

  N2.Visible := acDebug.Checked;
  N3.Visible := acDebug.Checked;

  ModeRemove1.Visible := acDebug.Checked;
  EditModeAdd1.Visible := acDebug.Checked;
  EditModeUpdate1.Visible := acDebug.Checked;

  if assigned(PropertiesEditor) then
    PropertiesEditor.setDebugView(acDebug.Checked);
{$ENDIF}
end;

procedure TfrmListManager.acFlagCommentExecute(Sender: TObject);
begin
  inherited;
  PerformAction(OrderFlagComment);
end;

procedure TfrmListManager.acFlagRemoveExecute(Sender: TObject);
begin
  inherited;
  PerformAction(OrderFlagRemove);
end;

procedure TfrmListManager.acFlagSetExecute(Sender: TObject);
var
  NoErrors: boolean;
begin
  inherited;
  NoErrors := True;
  if Assigned(ItemEditor) and (ItemEditor is TfrmOrderFlag) then
    NoErrors := TfrmOrderFlag(ItemEditor).CheckFlag;
  if NoErrors then PerformAction(OrderFlagSet);
end;

procedure TfrmListManager.acLegendExecute(Sender: TObject);
begin
  inherited;
  acLegend.Checked := not acLegend.Checked;
  pnlLegend.Visible := acLegend.Checked;
end;

procedure TfrmListManager.acModeAddExecute(Sender: TObject);
// actions allow change the form appearance - debug only
begin
  inherited;
  case TAction(Sender).Tag of
  0:ActionMode := amAdd;
  1:ActionMode := amEdit;
  2:ActionMode := amRemove;
  end;
end;

procedure TfrmListManager.acShowListExecute(Sender: TObject);
begin
  inherited;
  acShowList.Checked := not acShowList.Checked;
  if acShowList.Checked then
  begin
    pnlList.Visible := True;
    splList.Align := alLeft;
    splList.Visible := True;
  end
  else
  begin
    pnlList.Visible := False;
    splList.Align := alRight;
    splList.Visible := False;
  end;
//  cbRemoveProcessed.Visible := acShowList.Checked;

  Legend1.Visible := acShowList.Checked;
  ShowStatus1.Visible := acShowList.Checked;
  N1.Visible := acShowList.Checked;

  N2.Visible := acDebug.Checked;
  N3.Visible := acDebug.Checked;
  EditModeAdd1.Visible := acDebug.Checked;
  EditModeUpdate1.Visible := acDebug.Checked;
  ModeRemove1.Visible := acDebug.Checked;
  FontSize81.Visible := acDebug.Checked;
  FontSize101.Visible := acDebug.Checked;
  FontSize121.Visible := acDebug.Checked;
  FontSize141.Visible := acDebug.Checked;
  FontSize181.Visible := acDebug.Checked;
end;

procedure TfrmListManager.acShowStatusExecute(Sender: TObject);
begin
  inherited;
  acShowStatus.Checked := not acShowStatus.Checked;
  pnlListStatus.Visible := acShowStatus.Checked;
end;

procedure TfrmListManager.btnFlagRecipientsClick(Sender: TObject);
begin
  inherited;
  if assigned(ItemEditor) and (ItemEditor is TfrmOrderFlag) then
    TfrmOrderFlag(ItemEditor).acRecipientSelect.Execute;
end;

procedure TfrmListManager.acFont8Execute(Sender: TObject);
var
  i: Integer;
begin
  inherited;
  i := TAction(Sender).Tag;
  if i< 8 then
    i := 8;
  Self.Font.Size := i;
  ResizeToFont(Self.Font.Size);
end;

procedure TfrmListManager.RemoveItemByStatus(aStatus: Integer);
var
  i: Integer;
begin
  inherited;
  i := 0;
  while i < lvItems.Items.Count do
  begin
    if assigned(lvItems.Items[i].SubItems.Objects[0]) and
      (lvItems.Items[i].SubItems.Objects[0] is TOrderFlag) and
      (TOrderFlag(lvItems.Items[i].SubItems.Objects[0]).OFStatus = aStatus) then
      lvItems.Items.Delete(i)
    else
      inc(i);
  end;
end;

procedure TfrmListManager.acRemoveProcessedExecute(Sender: TObject);
begin
  inherited;
  acRemoveProcessed.Checked := not acRemoveProcessed.Checked;
  if acRemoveProcessed.Checked then
    RemoveItemByStatus(stOFProcessed);
  cbRemoveProcessed.Checked := acRemoveProcessed.Checked;
end;

procedure TfrmListManager.acReUsePropertiesExecute(Sender: TObject);
var
  i: Integer;
begin
  inherited;
  acReUseProperties.Checked := not acReUseProperties.Checked;
  for i := 0 to lvItems.Items.Count - 1 do
    lvItems.Items[i].Selected := acReUseProperties.Checked;
  if lvItems.Items.Count > 0 then
    lvItems.Selected := lvItems.Items[0];

  cbReuseProperties.Checked := acReUseProperties.Checked;
end;

procedure TfrmListManager.cbReusePropertiesClick(Sender: TObject);
var
  i: Integer;
begin
  inherited;
  for i := 0 to lvItems.Items.Count - 1 do
    lvItems.Items[i].Selected := cbReuseProperties.Checked;
  if lvItems.Items.Count > 0 then
    lvItems.Selected := lvItems.Items[0];
end;

procedure TfrmListManager.PerformAction(aPerformer: TProcessor);
var
  i,iError: Integer;
  s, sMsg: String;
  iSelected: Integer;

  function ProcessItem(anItemIndex: Integer): String;
  var
    anObject: TObject;
  begin
    anObject := lvItems.Items[anItemIndex].SubItems.Objects[0];
    if assigned(aPerformer) then
    begin
      Result := aPerformer(anObject);
      if pos(ssSuccess + '^', Result) = 1 then
        Result := ''
      else
        Result := 'Error: ' + piece(Result, U, 2) + CRLF;
    end
    else
      Result := 'Action executor was not assigned' + CRLF;
  end;

  function ConfirmAction: Boolean;
  // confirm all list items should be assigned the same properties
  var
    s: String;
  begin
    Result := True;
    if lvItems.Items.Count > 1 then
    begin
      s := 'All ' + IntToStr(lvItems.Items.Count) +
        ' orders will be assigned the same flag properties:' + CRLF + CRLF +
        TfrmOrderFlag(ItemEditor).getVisibleFieldNames  + CRLF +
        'Press OK to continue or Cancel to abort';
      Result := InfoBox(s, 'Confirm', MB_OKCANCEL or MB_ICONWARNING) = IDOK;
    end;
  end;

begin
  inherited;

  if cbReuseProperties.Checked and (not ConfirmAction) then
    exit;

  sMsg := '';
  iSelected := -1;
  i := 0;
  iError := 0;
  while i < lvItems.Items.Count do
    if lvItems.Items[i].Selected then
    begin
      s := ProcessItem(i);
      if s <> '' then
        sMsg := sMsg + s + CRLF;

      if (pos('ERROR', uppercase(s)) > 0) or (pos(ssError+U,s)=1) then
        begin
          inc(i);
          inc(iError);
        end
      else
      begin
        if assigned(MasterForm) then
          SendMessage(MasterForm.Handle, UM_ORDDESELECT, 0,
            TOrderFlag(lvItems.Items[i].SubItems.Objects[0]).Tag);
        if cbRemoveProcessed.Checked then
          lvItems.Items.Delete(i)
        else
          begin
            lvItems.Items[i].Selected := false;
            inc(i);
          end;
      end;
      iSelected := i;
      if not cbReuseProperties.Checked then
        break;
    end
    else
      inc(i);

  // RTC 798386
  if sMsg <> '' then
    MessageDlg('Processing results:' + CRLF + CRLF + sMsg, mtInformation, [mbOK], 0);

  if (lvItems.Items.Count < 1) or (iError = 0) then
    ModalResult := mrOK
  else
    begin
      iSelected := min(iSelected, lvItems.Items.Count - 1);
      if iSelected > -1 then
        lvItems.Selected := lvItems.Items[iSelected];
      lvItems.Invalidate;
    end;
end;

procedure TfrmListManager.pnlCanvasResize(Sender: TObject);
begin
  inherited;
  pnlList.Constraints.MaxWidth := pnlCanvas.Width div 3;
  pnlList.Constraints.MinWidth := pnlCanvas.Width div 5;
end;

procedure TfrmListManager.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = VK_ESCAPE then
    ModalResult := mrCancel;
end;
{
procedure TfrmListManager.setStateIndex(anItem:TListItem;anObject:TObject);
var
  ItemObject: TOrderFlag;
begin
  if anObject is TOrderFlag then
    begin
      ItemObject := TOrderFlag(anObject);

    end;
end;
}
procedure TfrmListManager.SelectListItem(anItem: TListItem);
var
  ItemObject: TOrderFlag;

  procedure setActionsByItemObject;
  begin
    if not assigned(ItemObject) then
      exit;

    acFlagSet.Enabled := (ItemObject.OFSetStatus <> ofssSet) and
      assigned(PropertiesEditor) and PropertiesEditor.IsValidArray
      ([prpReason]);
    acFlagRemove.Enabled := (ItemObject.OFSetStatus = ofssSet) and
      assigned(PropertiesEditor) and PropertiesEditor.IsValidArray
      ([prpComment]);
    acFlagComment.Enabled := (ItemObject.OFSetStatus = ofssSet) and
      assigned(PropertiesEditor) and PropertiesEditor.IsValidArray
      ([prpComment]);
  end;

  procedure setActionsBySelectedObjects;
  begin
    acFlagSet.Enabled := assigned(PropertiesEditor) and
      PropertiesEditor.IsValidArray([prpReason]);
    acFlagRemove.Enabled := assigned(PropertiesEditor) and
      PropertiesEditor.IsValidArray([prpComment]);
    acFlagComment.Enabled := assigned(PropertiesEditor) and
      PropertiesEditor.IsValidArray([prpComment]);
  end;

begin
  if not assigned(anItem) then
    exit;
  lblWarning.Visible := lvItems.SelCount > 1;
  if lvItems.SelCount > 1 then
  begin
    if assigned(PropertiesEditor) then
      PropertiesEditor.setGUIByMultipleObjects(lvItems);
    mmListStatus.Clear;
    setActionsBySelectedObjects;
  end
  else
  begin
    ItemObject := TOrderFlag(anItem.SubItems.Objects[0]);
    if assigned(PropertiesEditor) then
      PropertiesEditor.setGUIByObject(ItemObject);
    setActionsByItemObject;
    anItem.StateIndex := ItemObject.OFStatus;
    mmListStatus.Text := ItemObject.OFStatusInfo;
    mmListStatus.Hint := ItemObject.OFStatusInfo;
    pnlListStatus.Hint := ItemObject.OFStatusInfo;
    lvItems.Invalidate;
    TResponsiveGUI.ProcessMessages;
  end;
//  if assigned(ItemEditor) then
//    SendMessage(ItemEditor.Handle,UM_ORDINIT,0,0);
end;

procedure TfrmListManager.lvItemsSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  inherited;
  SelectListItem(Item);
end;

procedure TfrmListManager.lvItemsClick(Sender: TObject);
begin
  inherited;
  SelectListItem(lvItems.Selected);
end;

procedure TfrmListManager.lvItemsResize(Sender: TObject);
begin
  inherited;
  lvItems.Columns[0].Width := lvItems.Width - 1;
end;

procedure TfrmListManager.lvLegendResize(Sender: TObject);
begin
  inherited;
  if lvLegend.Columns.Count > 1 then
    lvLegend.Columns[1].Width := lvLegend.Width - lvLegend.Columns[0].Width - 1;
end;

procedure TfrmListManager.InitItemList(aList: TStrings);
var
  s: String;
  i: Integer;
  FlagInfo: TOrderFlag;
  li: TListItem;

begin
  lvItems.Clear;
  if not assigned(aList) then
  begin
{$IFDEF DEBUG}
    ShowMessage('Blank List is not a good assignment');
{$ENDIF}
  end
  else
  begin
    bIgnore := True;
    for i := 0 to aList.Count - 1 do
    begin
      FlagInfo := TOrderFlag(aList.Objects[i]);
      if assigned(FlagInfo) then
      begin
        s := aList[i];
        li := lvItems.Items.Add;
        li.Selected := True;
        li.StateIndex := FlagInfo.OFStatus;
        li.Caption := s;
        li.SubItems.AddObject(s, FlagInfo);
      end;
    end;
    bIgnore := False;
    if lvItems.Items.Count > 0 then
      lvItems.ItemIndex := 0;
  end;
end;

procedure TfrmListManager.UMORDFLAGSTATUS(var Message: TMessage);

  procedure setActionsBySelectedObjects;
  begin
    acFlagSet.Enabled := assigned(PropertiesEditor) and
      PropertiesEditor.IsValidArray([prpReason]);
    acFlagRemove.Enabled := assigned(PropertiesEditor) and
      PropertiesEditor.IsValidArray([prpComment]);
    acFlagComment.Enabled := assigned(PropertiesEditor) and
      PropertiesEditor.IsValidArray([prpComment]);
  end;

  procedure UpdateStateIndexes(anIndex:Integer);
  var
    i: integer;
  begin
    lvItems.Items.BeginUpdate;
    for i := 0 to lvItems.Items.Count - 1 do
      lvItems.Items[i].StateIndex := anIndex;
    lvItems.Items.EndUpdate;
  end;

begin
  updateStateIndexes(Message.WParamLo);
  if assigned(lvItems.ItemFocused) then
    setActionsBySelectedObjects;
//    SelectListItem(lvItems.ItemFocused);
end;

function TfrmListManager.getActionMode: TActionMode;
begin
  Result := amUnknown;
  if assigned(ItemEditor) then
    Result := TfrmOrderFlag(ItemEditor).ActionMode;
end;

procedure TfrmListManager.setActionMode(aMode: TActionMode);

begin
  if assigned(ItemEditor) then
    TfrmOrderFlag(ItemEditor).ActionMode := aMode;
  pnlFlagAdd.Visible := aMode = amAdd;
  pnlFlagRemove.Visible := aMode = amRemove;
  pnlFlagComment.Visible := aMode = amEdit;
  btnFlagRecipients.Visible := aMode = amEdit;
  acModeAdd.Checked := aMode = amAdd;
  acModeEdit.Checked := aMode = amEdit;
  acModeRemove.Checked := aMode = amRemove;
  case aMode of
    amAdd:
      begin
//        Caption := 'Set Order Flag';
        Caption := 'Flag Order';
        Height := 640;
      end;
    amEdit:
      begin
//        Caption := 'Update Order Flag';
        Caption := 'Comment Order Flag';
      end;
    amRemove:
      begin
//        Caption := 'Remove Order Flag';
        Caption := 'Unflag Order';
        Height := 510;
      end;
  end;
end;

procedure TfrmListManager.ResizeToFont(aSize: Integer);
var
  iLineHeight:Integer;
  RForm: IResizableForm;

  procedure adjustPanelWidth(aPanel: TPanel; aCaption: String);
  var
    iWidth: Integer;
  begin
    iWidth := Self.Canvas.TextWidth(aCaption) + 2 * btnLeftMargin + 2 * iGap;
    if iWidth < btnMinWidth then
      iWidth := btnMinWidth;

    aPanel.Width := iWidth + igButtonLeft * 2;
  end;

  procedure adjustActionPanelWidth(aPanel: TPanel; anAction: TAction = nil);
  var
    iWidth: Integer;
  begin
    if anAction = nil then
      iWidth := btnMinWidth
    else
      iWidth := Self.Canvas.TextWidth(anAction.Caption) + 2 * btnLeftMargin;
    if iWidth < btnMinWidth then
      iWidth := btnMinWidth;

    aPanel.Width := iWidth + igButtonLeft * 2;
  end;

  procedure adjustActionPanelHeight(aPanel: TPanel; anAction: TAction = nil);
  var
    iHeight: Integer;
  const
    pnlMinHeight = 37;
  begin
    iHeight := iLineHeight;

    iHeight := iHeight + iGapHeader * 2;
    if iHeight < btnMinHeight then
      iHeight := btnMinHeight;
    aPanel.Height := iHeight + igButtonTop * 2;

    if aPanel.Height < pnlMinHeight then
      aPanel.Height := pnlMinHeight;
  end;

  procedure adjustCBWidth(aCheckBox: TCheckBox);
  begin
    aCheckBox.Width := Self.Canvas.TextWidth(aCheckBox.Caption) + 24;
    aCheckBox.Height := Self.Canvas.TextHeight(aCheckBox.Caption) + 8;
  end;

  procedure setMenu(aSize:Integer);
  begin
    acFont8.Checked := aSize = 8;
    acFont10.Checked := aSize = 10;
    acFont12.Checked := aSize = 12;
    acFont14.Checked := aSize = 14;
    acFont18.Checked := aSize = 18;
  end;

begin
  iLineHeight := Self.Canvas.TextHeight('TEXT');
  pnlOption.Height := iLineHeight + 8;

  Self.Font.Size := aSize;
  setMenu(aSize);

  TResponsiveGUI.ProcessMessages;
  adjustActionPanelHeight(pnlBottom);
  adjustPanelWidth(pnlCancel, 'Cancel');

  adjustActionPanelWidth(pnlFlagAdd, acFlagSet);
  adjustActionPanelWidth(pnlFlagRemove, acFlagRemove);
  adjustActionPanelWidth(pnlFlagComment, acFlagComment);

  adjustCBWidth(cbReuseProperties);
  adjustCBWidth(cbRemoveProcessed);

//  pnlListOption.Height := iLineHeight * 2 + 8;
//  Width := cbReuseProperties.Width + pnlCancel.Width + 16;
  Width := lblWarning.Width + pnlCancel.Width + 16;

  if pnlFlagAdd.Visible then
    Width := Width + pnlFlagAdd.Width;
  if pnlFlagRemove.Visible then
    Width := Width + pnlFlagRemove.Width;
  if pnlFlagComment.Visible then
    Width := Width + pnlFlagComment.Width;

  if Width < self.Canvas.TextWidth(pnlTop.Caption) + 16 then
    Width := self.Canvas.TextWidth(pnlTop.Caption) + 16;

  if assigned(PropertiesEditor) then
    if supports(ItemEditor, IResizableForm, RForm) then
      RForm.ResizeToFont(aSize)
end;

function TfrmListManager.OrderFlagSet(anItem: TObject): String;
begin
  if anItem is TOrderFlag then
    Result := TOrderFlag(anItem).FlagInfoSave
  else
    Result := '1^Invalid object';
end;

function TfrmListManager.OrderFlagRemove(anItem: TObject): String;
begin
  if anItem is TOrderFlag then
    Result := TOrderFlag(anItem).FlagInfoRemove
  else
    Result := '1^Invalid object';
end;

function TfrmListManager.OrderFlagComment(anItem: TObject): String;
begin
  if anItem is TOrderFlag then
    Result := TOrderFlag(anItem).FlagInfoUpdate
  else
    Result := '1^Invalid object';
end;

end.
