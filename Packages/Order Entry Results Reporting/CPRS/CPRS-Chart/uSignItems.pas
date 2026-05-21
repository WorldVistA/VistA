unit uSignItems;

{ .$define debug }

interface

uses
  SysUtils,
  Windows,
  Classes,
  Graphics,
  Controls,
  ExtCtrls,
  StdCtrls,
  CheckLst,
  ORClasses,
  ORCtrls,
  Dialogs,
  UBAConst,
  fODBase,
  UBACore,
  Forms,
  System.Generics.Collections,
  VAShared.GenericStringList,
  uSpecialAuthorityEx,
  uSpecialAuthorityTypesEx,
  rSpecialAuthority,
  uComponentNexus;

type
  TSigItems = class;

  TCaptionCheckListBox = class(ORCtrls.TCaptionCheckListBox)
  private
    FRectWidth: Integer;
    FResizing: Boolean;
    FSigItems: TSigItems;
    function GetMinItemHeight: Integer;
  protected
    procedure DrawItem(Index: Integer; Rect: TRect;
      State: TOwnerDrawState); override;
    procedure Resize; override;
  public
    property MinItemHeight: Integer read GetMinItemHeight;
    property RectWidth: Integer read FRectWidth write FRectWidth;
    property SigItems: TSigItems read FSigItems write FSigItems;
  end;

  TSigItems = class(TComponent)
  private const
    btnGap: Integer = 0;
    btnGapAboveLB: Integer = 1;
    lbDX: Integer = -3;
    cbDX: Integer = -3;
    cbDY: Integer = -1;
    AllTxt = 'All';
  public const
    MinWidthDX = 35;
    btnMargin: Integer = 6;
  private type

    TSpecialAuthorityInfo = class
    strict private
      FComponentNexus: TComponentNexus;
      FDisabledFlag: Boolean;
      FOrderID: string;
      FListBox: uSignItems.TCaptionCheckListBox;
      FListBoxIndex: Integer;
      FRPCCalled: Boolean;
      FSpecialAuthorities: TSpecialAuthoritiesEx;
      FUpdated: Boolean;
      function CanEnable(Sender: TSpecialAuthoritiesEx): Boolean;
      procedure FreeNotification(Sender: TObject; AComponent: TComponent);
      function GetSpecialAuthorities: TSpecialAuthoritiesEx;
      procedure SetDisabledFlag(const Value: Boolean);
      procedure SetListBox(const Value: uSignItems.TCaptionCheckListBox);
      procedure SetSpecialAuthorities(const Value: TSpecialAuthoritiesEx);
    public
      constructor Create(AOrderID: string); reintroduce;
      destructor Destroy; override;
      function IsInvalidMatch(AListBox
        : uSignItems.TCaptionCheckListBox): Boolean;
      property DisabledFlag: Boolean read FDisabledFlag write SetDisabledFlag;
      property OrderID: string read FOrderID;
      property ListBox: uSignItems.TCaptionCheckListBox read FListBox
        write SetListBox;
      property ListBoxIndex: Integer read FListBoxIndex write FListBoxIndex;
      property RPCCalled: Boolean read FRPCCalled write FRPCCalled;
      property SpecialAuthorities: TSpecialAuthoritiesEx
        read GetSpecialAuthorities write SetSpecialAuthorities;
      property Updated: Boolean read FUpdated write FUpdated;
    end;

    TSpecialAuthorityButton = class(TButton)
    private
      FAllCheck: Boolean;
      FCode: string;
      FSigItems: TSigItems;
      procedure ResetAllCheck;
    public
      constructor Create(AOwner: TComponent; ASigItems: TSigItems;
        ACode: string); reintroduce;
      procedure Click; override;
      property AllCheck: Boolean read FAllCheck write FAllCheck;
      property Code: string read FCode;
    end;

    TSigItemCheckBox = class(TSpecialAuthorityCheckBox)
    private
      FSAInfo: TSpecialAuthorityInfo;
    protected
      procedure DoEnter; override;
    public
      constructor Create(AOwner: TComponent;
        ASpecialAuthority: TSpecialAuthorityEx; ASAInfo: TSpecialAuthorityInfo);
        reintroduce;
      property SAInfo: TSpecialAuthorityInfo read FSAInfo;
    end;

  public type
    TCombinedSpecialAuthority = class(TSpecialAuthorityEx)
    private
      FButton: TSpecialAuthorityButton;
      FItems: TObjectList<TSpecialAuthorityEx>;
    public
      constructor Create; override;
      destructor Destroy; override;
      procedure ClearExternalReferences; override;
      property Items: TObjectList<TSpecialAuthorityEx> read FItems;
    end;

    TCombinedSpecialAuthorities = class(TSpecialAuthoritiesEx)
    private
      FButton: TSpecialAuthorityButton;
      FVisibleCount: Integer;
    public
      procedure Clear(ClearVisible: Boolean = False); override;
      procedure Combine(AListBox: uSignItems.TCaptionCheckListBox;
        SpecialAuthoritiesList: TSpecialAuthoritiesStringList);
      property VisibleCount: Integer read FVisibleCount;
    end;

  private
    FBuilding: Boolean;
    FInfoItems: TStringList<TSpecialAuthorityInfo>;
    FCombinedSpecialAuthorities: TCombinedSpecialAuthorities;
    Flb: uSignItems.TCaptionCheckListBox;
    FBtnW, FBtnH, FBtnCount: Integer;
    FcbDX: Integer;
    FCellW: Integer;
    FXIdx: TList<Integer>;
    FX: TList<Integer>;
    FDefaultGrayedToChecked: Boolean;
    FDefaultGrayedToCheckedLoaded: Boolean;
    procedure CalcFX;
    function DefaultGrayedToChecked: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Add(AListBox: uSignItems.TCaptionCheckListBox; ItemType: Integer;
      const ID: string; AListBoxIndex: Integer);
    procedure Remove(ItemType: Integer; const ID: string);
    procedure ResetOrders;
    procedure Clear;
    procedure ClearCBSettings;
    function UpdateListBox(AListBox: uSignItems.TCaptionCheckListBox;
      AButtonPanel: TPanel): Boolean;
    procedure EnableSettings(AOrderID: string; Checked: Boolean);
    function OK2SaveSettings: Boolean;
    procedure SaveSettings;
    function BtnWidths: Integer;
    property CombinedSpecialAuthorities: TCombinedSpecialAuthorities
      read FCombinedSpecialAuthorities;
  end;

function SigItems: TSigItems;
function SigItemsCS: TSigItems;
function SigItemHeight: Integer;

const
  SIG_ITEM_VERTICAL_PAD = 2;

  TX_Order_Error =
    'All Special Authority, Service Connection and/or Rated Disabilities questions must be answered.';

implementation

uses
  ORFn,
  ORNet,
  ORNetIntf,
  uConst,
  TRPCB,
  rOrders,
  rPCE,
  UBAGlobals,
  uGlobalVar,
  uCore,
  VAUtils,
  rMisc,
  VAHelpers;

var
  uSingletonFlag: Boolean = False;
  uSigItems: TSigItems = nil; // BAPHII 1.3.1
  uSigItemsCS: TSigItems = nil;

function SigItems: TSigItems;
begin
  if not assigned(uSigItems) then
  begin
    uSingletonFlag := True;
    try
      uSigItems := TSigItems.Create(nil);
    finally
      uSingletonFlag := False;
    end;
  end;
  Result := uSigItems;
end;

function SigItemsCS: TSigItems;
begin
  if not assigned(uSigItemsCS) then
  begin
    uSingletonFlag := True;
    try
      uSigItemsCS := TSigItems.Create(nil);
    finally
      uSingletonFlag := False;
    end;
  end;
  Result := uSigItemsCS;
end;

function SigItemHeight: Integer;
begin
  Result := abs(BaseFont.height) + 2 + SIG_ITEM_VERTICAL_PAD;
end;

{ uSigItems.TCaptionCheckListBox }

procedure TCaptionCheckListBox.DrawItem(Index: Integer; Rect: TRect;
  State: TOwnerDrawState);
var
  OldRect: TRect;
  dy, topLine: Integer;
  DrawGrid: Boolean;
  CombinedSpecialAuthority: TSigItems.TCombinedSpecialAuthority;
  CheckBox: TSigItems.TSigItemCheckBox;
begin
  if (not assigned(FSigItems)) or (FSigItems.FXIdx.Count = 0) or
    (FSigItems.FXIdx[FSigItems.FXIdx.Count - 1] >= FSigItems.FX.Count) or
    (FSigItems.FCombinedSpecialAuthorities.VisibleCount = 0) then
    inherited
  else
  begin
    DrawGrid := (Index < Count);
    if DrawGrid and (Trim(Items[Index]) = '') and (Index = (Count - 1)) then
      DrawGrid := False;
    if DrawGrid then
      dec(Rect.Bottom);
    OldRect := Rect;

    Rect.Right := FSigItems.FX[FSigItems.FXIdx[0]] - TSigItems.btnMargin;

    inc(Rect.Bottom);
    inherited DrawItem(Index, Rect, State);
    dec(Rect.Bottom);

    if DrawGrid then
    begin
      Canvas.Pen.Color := Get508CompliantColor(clSilver);
      Canvas.MoveTo(Rect.Left, Rect.Bottom);
      Canvas.LineTo(OldRect.Right, Rect.Bottom);
    end;

    OldRect.Left := Rect.Right;

    // SA Column
    Canvas.FillRect(OldRect);
    dy := ((Rect.height - CheckBoxWidth) div 2) + TSigItems.cbDY;

    for var i := 0 to FSigItems.FCombinedSpecialAuthorities.Count - 1 do
    begin
      CombinedSpecialAuthority := FSigItems.FCombinedSpecialAuthorities[i]
        as TSigItems.TCombinedSpecialAuthority;
      for var j := 0 to CombinedSpecialAuthority.Items.Count - 1 do
      begin
        CheckBox := CombinedSpecialAuthority.Items[j].CheckBox[cbtBoth]
          as TSigItems.TSigItemCheckBox;
        if assigned(CheckBox) then
        begin
          if CheckBox.SAInfo.ListBoxIndex = Index then
          begin
            CheckBox.Invalidate;
            CheckBox.Top := Rect.Top + dy;
            CheckBox.Left := FSigItems.FX
              [CheckBox.SpecialAuthorityEx.SpecialAuthorityTypeEx.ID] +
              FSigItems.FcbDX;
          end
          else if CheckBox.SAInfo.ListBoxIndex < TopIndex then
          begin
            CheckBox.Invalidate;
            CheckBox.Top := -CheckBoxWidth;
          end;
        end;
      end;

      // Columns
      if DrawGrid then
      begin
        topLine := Rect.Top;
        if TopIndex = Index then
          dec(topLine);
        for var j := 0 to FSigItems.FXIdx.Count - 1 do
        begin
          Canvas.MoveTo(FSigItems.FX[FSigItems.FXIdx[j]] +
            TSigItems.lbDX, topLine);
          Canvas.LineTo(FSigItems.FX[FSigItems.FXIdx[j]] + TSigItems.lbDX,
            Rect.Bottom);
        end;
      end;
    end;
  end;
end;

function TCaptionCheckListBox.GetMinItemHeight: Integer;
begin
  Result := CheckBoxWidth + 3;
end;

procedure TCaptionCheckListBox.Resize;
begin
  if not FResizing then
  begin
    FResizing := True;
    try
      Parent.LockDrawing;
      try
        inherited;
        if assigned(FSigItems) then
        begin
          FSigItems.CalcFX;
          ForceItemHeightRecalc;
          Invalidate;
        end;
      finally
        Parent.UnlockDrawing;
      end;
    finally
      FResizing := False;
    end;
  end;
end;

function TSigItems.TSpecialAuthorityInfo.CanEnable
  (Sender: TSpecialAuthoritiesEx): Boolean;
begin
  if assigned(FListBox) and (FListBoxIndex >= 0) then
    Result := FListBox.Checked[FListBoxIndex]
  else
    Result := False;
end;

constructor TSigItems.TSpecialAuthorityInfo.Create(AOrderID: string);
begin
  inherited Create;
  FOrderID := AOrderID;
  FListBoxIndex := -1;
end;

{ TSigItems.TOrderData }

destructor TSigItems.TSpecialAuthorityInfo.Destroy;
var
  CSA: TCombinedSpecialAuthority;
begin
  if assigned(FSpecialAuthorities) and assigned(FListBox) and
    assigned(FListBox.SigItems) and
    assigned(FListBox.SigItems.FCombinedSpecialAuthorities) then
    for var i := 0 to FSpecialAuthorities.Count - 1 do
      for var j := 0 to FListBox.SigItems.FCombinedSpecialAuthorities.
        Count - 1 do
      begin
        CSA := FListBox.SigItems.FCombinedSpecialAuthorities[j]
          as TCombinedSpecialAuthority;
        for var k := CSA.FItems.Count - 1 downto 0 do
          if CSA.FItems[k] = FSpecialAuthorities[i] then
            CSA.FItems.Delete(k);
      end;

  FreeAndNil(FSpecialAuthorities);
  FreeAndNil(FComponentNexus);
  inherited;
end;

procedure TSigItems.TSpecialAuthorityInfo.FreeNotification(Sender: TObject;
  AComponent: TComponent);
begin
  if AComponent = FListBox then
  begin
    ListBox := nil;
    ListBoxIndex := -1;
  end;
end;

function TSigItems.TSpecialAuthorityInfo.IsInvalidMatch
  (AListBox: uSignItems.TCaptionCheckListBox): Boolean;
begin
  Result := (FListBox <> AListBox) or (ListBoxIndex < 0);
end;

function TSigItems.TSpecialAuthorityInfo.GetSpecialAuthorities
  : TSpecialAuthoritiesEx;
begin
  if not assigned(FSpecialAuthorities) then
    FSpecialAuthorities := TSpecialAuthoritiesEx.Create;
  Result := FSpecialAuthorities;
end;

procedure TSigItems.TSpecialAuthorityInfo.SetDisabledFlag(const Value: Boolean);
begin
  FDisabledFlag := Value;
  if assigned(FSpecialAuthorities) then
    for var i := 0 to FSpecialAuthorities.Count - 1 do
      FSpecialAuthorities[i].Enabled := not Value;
end;

procedure TSigItems.TSpecialAuthorityInfo.SetListBox
  (const Value: uSignItems.TCaptionCheckListBox);
begin
  if FListBox <> Value then
  begin
    if assigned(FListBox) and assigned(FComponentNexus) then
      FListBox.RemoveFreeNotification(FComponentNexus);
    FListBox := Value;
    if assigned(FListBox) then
    begin
      if not assigned(FComponentNexus) then
      begin
        FComponentNexus := TComponentNexus.Create(nil);
        FComponentNexus.OnFreeNotification := FreeNotification;
      end;
      FListBox.FreeNotification(FComponentNexus);
    end;
  end;
end;

procedure TSigItems.TSpecialAuthorityInfo.SetSpecialAuthorities
  (const Value: TSpecialAuthoritiesEx);
begin
  if FSpecialAuthorities <> Value then
  begin
    if assigned(FSpecialAuthorities) then
      FreeAndNil(FSpecialAuthorities);
    FSpecialAuthorities := Value;
    FSpecialAuthorities.OnCanEnableEvent := CanEnable;
    FSpecialAuthorities.ResetEnabled;
  end;
end;

{ TSigItems.TSpecialAuthorityButton }

procedure TSigItems.TSpecialAuthorityButton.Click;
var
  CombinedSpecialAuthority: TCombinedSpecialAuthority;
begin
  inherited;
  if (not assigned(FSigItems)) or FSigItems.FBuilding then
    Exit;
  ResetAllCheck;
  FAllCheck := not FAllCheck;
  for var i := 0 to FSigItems.FCombinedSpecialAuthorities.Count - 1 do
  begin
    CombinedSpecialAuthority := FSigItems.FCombinedSpecialAuthorities[i]
      as TCombinedSpecialAuthority;
    for var j := 0 to CombinedSpecialAuthority.FItems.Count - 1 do
      if (FCode = '') or (FCode = CombinedSpecialAuthority.FItems[j].Code) then
        if FAllCheck then
          CombinedSpecialAuthority.FItems[j].Value := savYes
        else
          CombinedSpecialAuthority.FItems[j].Value := savNo;
  end;
end;

constructor TSigItems.TSpecialAuthorityButton.Create(AOwner: TComponent;
  ASigItems: TSigItems; ACode: string);
begin
  inherited Create(AOwner);
  FSigItems := ASigItems;
  FCode := ACode;
  FAllCheck := not ASigItems.DefaultGrayedToChecked;
end;

procedure TSigItems.TSpecialAuthorityButton.ResetAllCheck;
var
  CombinedSpecialAuthority: TCombinedSpecialAuthority;
  First: Boolean;
  Value: TSpecialAuthorityValue;
begin
  First := True;
  Value := savUnanswered;
  for var i := 0 to FSigItems.FCombinedSpecialAuthorities.Count - 1 do
  begin
    CombinedSpecialAuthority := FSigItems.FCombinedSpecialAuthorities[i]
      as TCombinedSpecialAuthority;
    for var j := 0 to CombinedSpecialAuthority.FItems.Count - 1 do
      if (FCode = '') or (FCode = CombinedSpecialAuthority.FItems[j].Code) then
      begin
        if First then
        begin
          Value := CombinedSpecialAuthority.FItems[j].Value;
          First := False;
        end
        else if Value <> CombinedSpecialAuthority.FItems[j].Value then
          Exit;
      end;
  end;
  case Value of
    savUnanswered:
      FAllCheck := not FSigItems.DefaultGrayedToChecked;
    savNo:
      FAllCheck := False;
    savYes:
      FAllCheck := True;
  end;
end;

{ TSigItems.TSigItemCheckBox }

constructor TSigItems.TSigItemCheckBox.Create(AOwner: TComponent;
  ASpecialAuthority: TSpecialAuthorityEx; ASAInfo: TSpecialAuthorityInfo);
begin
  inherited Create(AOwner, ASpecialAuthority, cbtBoth, nil, nil);
  FSAInfo := ASAInfo;
  FocusOnBox := True;
end;

procedure TSigItems.TSigItemCheckBox.DoEnter;
begin
  inherited;
  if assigned(FSAInfo) and assigned(FSAInfo.ListBox) and
    (FSAInfo.ListBoxIndex >= 0) then
  begin
    if FSAInfo.ListBox.TopIndex > FSAInfo.ListBoxIndex then
      FSAInfo.ListBox.TopIndex := FSAInfo.ListBoxIndex
    else
    begin
      FSAInfo.ListBox.LockDrawing;
      try
        while (FSAInfo.ListBox.TopIndex <> FSAInfo.ListBoxIndex) and
          (not FSAInfo.ListBox.ClientRect.Contains
          (FSAInfo.ListBox.ItemRect(FSAInfo.ListBoxIndex))) do
          FSAInfo.ListBox.TopIndex := FSAInfo.ListBox.TopIndex + 1;
      finally
        FSAInfo.ListBox.UnlockDrawing;
      end;
    end;
  end;
end;

{ TSigItems.TCombinedSpecialAuthority }

procedure TSigItems.TCombinedSpecialAuthority.ClearExternalReferences;
begin
  inherited;
  FButton := nil;
end;

constructor TSigItems.TCombinedSpecialAuthority.Create;
begin
  inherited Create;
  FItems := TObjectList<TSpecialAuthorityEx>.Create(False);
end;

destructor TSigItems.TCombinedSpecialAuthority.Destroy;
begin
  FreeAndNil(FItems);
  inherited;
end;

{ TSigItems.TCombinedSpecialAuthorities }

procedure TSigItems.TCombinedSpecialAuthorities.Clear(ClearVisible: Boolean);
var
  CombinedSpecialAuthority: TCombinedSpecialAuthority;
begin
  inherited Clear(ClearVisible);
  FButton := nil;
  FVisibleCount := 0;
  for var i := 0 to Count - 1 do
  begin
    CombinedSpecialAuthority := Item[i] as TCombinedSpecialAuthority;
    CombinedSpecialAuthority.ClearExternalReferences;
    for var j := 0 to CombinedSpecialAuthority.FItems.Count - 1 do
      CombinedSpecialAuthority.FItems[j].ClearExternalReferences;
    CombinedSpecialAuthority.FItems.Clear;
  end;
end;

procedure TSigItems.TCombinedSpecialAuthorities.Combine
  (AListBox: uSignItems.TCaptionCheckListBox;
  SpecialAuthoritiesList: TSpecialAuthoritiesStringList);
var
  CombinedSpecialAuthority: TCombinedSpecialAuthority;
begin
  Clear(True);
  for var i := 0 to SpecialAuthoritiesList.Count - 1 do
    if assigned(SpecialAuthoritiesList.Objects[i]) then
    begin
      for var j := 0 to SpecialAuthoritiesList.Objects[i].Count - 1 do
        if SpecialAuthoritiesList.Objects[i][j].Visible then
        begin
          CombinedSpecialAuthority :=
            Item[SpecialAuthoritiesList.Objects[i][j].Code]
            as TCombinedSpecialAuthority;
          CombinedSpecialAuthority.Visible := True;
          CombinedSpecialAuthority.Items.Add
            (SpecialAuthoritiesList.Objects[i][j]);
        end;
    end;
  FVisibleCount := 0;
  for var i := 0 to Count - 1 do
    if Item[i].Visible then
      inc(FVisibleCount);
end;

{ TSigItems }

procedure TSigItems.Add(AListBox: uSignItems.TCaptionCheckListBox;
  ItemType: Integer; const ID: string; AListBoxIndex: Integer);
var
  idx: Integer;
begin
  if ItemType = CH_ORD then
  begin
    idx := FInfoItems.IndexOf(ID);
    if idx < 0 then
      idx := FInfoItems.AddObject(ID, TSpecialAuthorityInfo.Create(ID));
    FInfoItems.Objects[idx].ListBox := AListBox;
    FInfoItems.Objects[idx].ListBoxIndex := AListBoxIndex;
    FInfoItems.Objects[idx].DisabledFlag := False;
  end;
end;

procedure TSigItems.Clear;
begin
  FInfoItems.Clear;
  Flb := nil;
  FCombinedSpecialAuthorities.Clear(True);
  FXIdx.Clear;
  FX.Clear;
end;

procedure TSigItems.ClearCBSettings;
begin
  if assigned(Flb) then
  begin
    Flb.RectWidth := 0;
  end;
end;

constructor TSigItems.Create(AOwner: TComponent);
begin
  if not uSingletonFlag then
    raise Exception.Create('Only one instance of TSigItems allowed');
  inherited Create(AOwner);
  FInfoItems := TStringList<TSpecialAuthorityInfo>.Create;
  FCombinedSpecialAuthorities := TCombinedSpecialAuthorities.Create
    (TCombinedSpecialAuthority);
  FCombinedSpecialAuthorities.PackageLink := VISTA_PACKAGE;
  FXIdx := TList<Integer>.Create;
  FX := TList<Integer>.Create;
end;

function TSigItems.DefaultGrayedToChecked: Boolean;
begin
  if not FDefaultGrayedToCheckedLoaded then
  begin
    FDefaultGrayedToChecked := SystemParameters.AsTypeDef<Boolean>
      ('specialAuthority.orderUnansweredToValue', True);
    FDefaultGrayedToCheckedLoaded := True;
  end;
  Result := FDefaultGrayedToChecked;
end;

destructor TSigItems.Destroy;
begin
  FreeAndNil(FX);
  FreeAndNil(FXIdx);
  FreeAndNil(FCombinedSpecialAuthorities);
  FreeAndNil(FInfoItems);
  inherited;
end;

procedure TSigItems.Remove(ItemType: Integer; const ID: string);
var
  idx: Integer;
begin
  if ItemType = CH_ORD then
  begin
    idx := FInfoItems.IndexOf(ID);
    if idx >= 0 then
      FInfoItems.Delete(idx);
  end;
end;

// Resets ListBox positions, to avoid old data messing things up
procedure TSigItems.ResetOrders;
begin
  for var i := 0 to FInfoItems.Count - 1 do
  begin
    FInfoItems.Objects[i].ListBox := nil;
    FInfoItems.Objects[i].ListBoxIndex := -1;
  end;
end;

type
  TExposedListBox = class(TCustomListBox)
  public
    property OnResize;
  end;

function TSigItems.UpdateListBox(AListBox: uSignItems.TCaptionCheckListBox;
  AButtonPanel: TPanel): Boolean;
var
  ownr: TComponent;
  idx: Integer;
  Error: string;
  SAInfo: TSpecialAuthorityInfo;
  OSAList: TSpecialAuthoritiesStringList;

  procedure CreateSpecialAuthorityButton(ACode: string);
  var
    SAButton: TSpecialAuthorityButton;
    SAType: TSpecialAuthorityTypeEx;
  begin
    if assigned(FCombinedSpecialAuthorities[ACode]) and
      (FX[FCombinedSpecialAuthorities[ACode].SpecialAuthorityTypeEx.ID] = 0)
    then
      Exit;
    inc(FBtnCount);
    SAButton := TSpecialAuthorityButton.Create(ownr, Self, ACode);
    SAButton.Parent := AButtonPanel;
    SAButton.height := FBtnH;
    SAButton.Width := FBtnW;
    if ACode = '' then
    begin
      SAButton.Caption := AllTxt;
      SAButton.Left := FX[FXIdx[0]] - FCellW + btnGap;
      SAButton.Hint := 'Set All Related Entries';
      FCombinedSpecialAuthorities.FButton := SAButton;
    end
    else
    begin
      SAType := FCombinedSpecialAuthorities[ACode].SpecialAuthorityTypeEx;
      SAButton.Caption := SAType.abbreviation;
      SAButton.Left := FX[SAType.ID] + btnGap;
      SAButton.Hint := 'Set All ' + SAType.DisplayText;
      (FCombinedSpecialAuthorities[ACode] as TCombinedSpecialAuthority).FButton
        := SAButton;
    end;
    SAButton.Top := Flb.Top - FBtnH - btnGapAboveLB;
    SAButton.Anchors := [akTop, akRight];
    SAButton.ShowHint := True;
    UpdateColorsFor508Compliance(SAButton);
  end;

  procedure CreateSigItemCheckBox(ASpecialAuthority: TSpecialAuthorityEx;
    ASAInfo: TSpecialAuthorityInfo);
  var
    SICheckBox: TSigItemCheckBox;
  begin
    SICheckBox := TSigItemCheckBox.Create(ownr, ASpecialAuthority, ASAInfo);
    SICheckBox.Parent := Flb;
    SICheckBox.height := Flb.CheckBoxWidth + 2;
    SICheckBox.Width := Flb.CheckBoxWidth + 2;
    SICheckBox.AllowGrayed := False;
    SICheckBox.GrayedStyle := gsBlueQuestionMark;
    SICheckBox.GrayedToChecked := DefaultGrayedToChecked;
    SICheckBox.Left := FX[ASpecialAuthority.SpecialAuthorityTypeEx.ID] + FcbDX;
    SICheckBox.Top := -200;
    SICheckBox.Anchors := [akTop, akRight];
    SICheckBox.ShowHint := True;
    SICheckBox.Hint := ASpecialAuthority.SpecialAuthorityTypeEx.DisplayText;
    UpdateColorsFor508Compliance(SICheckBox);
    SICheckBox.Enabled := not ASAInfo.DisabledFlag;
    if assigned(Flb.Items.Objects[ASAInfo.ListBoxIndex]) then
      SICheckBox.Caption := FilteredString(Flb.Items[ASAInfo.ListBoxIndex] + ' '
        + SICheckBox.Hint);
  end;

begin
  Result := False;
  // Should not own objects
  OSAList := TSpecialAuthoritiesStringList.Create(False);
  try
    Flb := AListBox;
    Flb.SigItems := Self;
    Flb.Parent.LockDrawing;
    try
      FBuilding := True;
      try
        for var i := 0 to FInfoItems.Count - 1 do
        begin
          SAInfo := FInfoItems.Objects[i];
          if SAInfo.IsInvalidMatch(Flb) then
            continue;
          if not SAInfo.RPCCalled then
            OSAList.Add(SAInfo.OrderID);
        end;

        if OSAList.Count > 0 then
        begin
          CreateOrderSpecialAuthorities(OSAList, Error);
          try
            if Error <> '' then
            begin
              ShowMessage(Error);
              Exit;
            end;

            for var i := OSAList.Count - 1 downto 0 do
            begin
              idx := FInfoItems.IndexOf(OSAList[i]);
              if idx >= 0 then
              begin
                SAInfo := FInfoItems.Objects[idx];
                // Transfer ownership of objects in OSAList to SAInfo
                SAInfo.SpecialAuthorities := OSAList.Objects[i];
                SAInfo.RPCCalled := True;
                OSAList.Delete(i);
              end;
            end;
          finally
            // delete any unused objects
            OSAList.OwnsObjects := True;
            try
              OSAList.Clear;
            finally
              OSAList.OwnsObjects := False;
            end;
          end;
        end;

        for var i := 0 to FInfoItems.Count - 1 do
        begin
          SAInfo := FInfoItems.Objects[i];
          if SAInfo.IsInvalidMatch(Flb) then
            continue;
          if SAInfo.RPCCalled then
            OSAList.AddObject(SAInfo.OrderID, SAInfo.SpecialAuthorities);
        end;
        FCombinedSpecialAuthorities.Combine(Flb, OSAList);
        CalcFX;
        FBtnCount := 0;

        if FCombinedSpecialAuthorities.VisibleCount > 0 then
        begin
          Result := True;
          ownr := Flb.Owner;

          if FCombinedSpecialAuthorities.VisibleCount > 1 then
            CreateSpecialAuthorityButton('');

          for var i := 0 to FCombinedSpecialAuthorities.Count - 1 do
            if FCombinedSpecialAuthorities[i].Visible then
              CreateSpecialAuthorityButton(FCombinedSpecialAuthorities[i].Code);

          Flb.ControlStyle := Flb.ControlStyle + [csAcceptsControls];
          try
            for var i := 0 to FInfoItems.Count - 1 do
            begin
              SAInfo := FInfoItems.Objects[i];
              if SAInfo.IsInvalidMatch(Flb) or (not SAInfo.RPCCalled) then
                continue;
              if SAInfo.ListBoxIndex >= 0 then
                SAInfo.DisabledFlag := not Flb.Checked[SAInfo.ListBoxIndex];
              for var j := 0 to SAInfo.SpecialAuthorities.Count - 1 do
                if SAInfo.SpecialAuthorities[j].Visible then
                  CreateSigItemCheckBox(SAInfo.SpecialAuthorities[j], SAInfo);
            end;
          finally
            Flb.ControlStyle := Flb.ControlStyle - [csAcceptsControls];
          end;
        end;
      finally
        Flb.Parent.UnlockDrawing;
      end;
    finally
      FBuilding := False;
    end;
  finally
    OSAList.Free;
    if not Result then
      Flb.RectWidth := 0;
  end;
end;

function TSigItems.BtnWidths: Integer;
begin
  if FCombinedSpecialAuthorities.VisibleCount > 0 then
    Result := (FBtnW + (btnGap * 2) + 3) * FBtnCount
  else
    Result := 0;
end;

procedure TSigItems.CalcFX;
var
  w, x, LowestX: Integer;
  CombinedSpecialAuthority: TCombinedSpecialAuthority;
begin
  FBtnW := 0;
  FXIdx.Clear;
  FX.Clear;
  for var i := 0 to FCombinedSpecialAuthorities.Count - 1 do
  begin
    if FCombinedSpecialAuthorities[i].Visible then
    begin
      while FX.Count <= FCombinedSpecialAuthorities[i]
        .SpecialAuthorityTypeEx.ID do
        FX.Add(0);
      w := TextWidthByFont(MainFont.Handle, FCombinedSpecialAuthorities[i]
        .SpecialAuthorityTypeEx.abbreviation);
      if FBtnW < w then
        FBtnW := w;
    end;
  end;
  inc(FBtnW, btnMargin * 2);
  FCellW := FBtnW + (btnGap * 2) + 1;
  FBtnH := TextHeightByFont(MainFont.Handle, AllTxt) + btnMargin;
  FcbDX := ((FCellW - Flb.CheckBoxWidth) div 2) + cbDX;

  x := Flb.ClientWidth;
  LowestX := x;
  for var i := FCombinedSpecialAuthorities.Count - 1 downto 0 do
    if FCombinedSpecialAuthorities[i].Visible then
    begin
      dec(x, FCellW);
      FXIdx.Insert(0, FCombinedSpecialAuthorities[i].SpecialAuthorityTypeEx.ID);
      FX[FCombinedSpecialAuthorities[i].SpecialAuthorityTypeEx.ID] := x;
      LowestX := x;
    end;
  Flb.RectWidth := LowestX + lbDX - btnMargin;
  if assigned(FCombinedSpecialAuthorities.FButton) then
    FCombinedSpecialAuthorities.FButton.Left := FX[FXIdx[0]] - FCellW + btnGap;
  for var i := 0 to FCombinedSpecialAuthorities.Count - 1 do
  begin
    CombinedSpecialAuthority := FCombinedSpecialAuthorities[i]
      as TCombinedSpecialAuthority;
    if assigned(CombinedSpecialAuthority.FButton) then
      CombinedSpecialAuthority.FButton.Left :=
        FX[CombinedSpecialAuthority.SpecialAuthorityTypeEx.ID] + btnGap;
  end;
end;

procedure TSigItems.EnableSettings(AOrderID: string; Checked: Boolean);
var
  idx: Integer;
  SpecialAuthorities: TSpecialAuthoritiesEx;
begin
  idx := FInfoItems.IndexOf(AOrderID);
  if idx >= 0 then
  begin
    FInfoItems.Objects[idx].DisabledFlag := not Checked;
    SpecialAuthorities := FInfoItems.Objects[idx].SpecialAuthorities;
    for var i := 0 to SpecialAuthorities.Count - 1 do
      if SpecialAuthorities[i].Visible then
        SpecialAuthorities[i].Enabled := Checked;
    SpecialAuthorities.ResetEnabled;
  end;
end;

function TSigItems.OK2SaveSettings: Boolean;
var
  SpecialAuthorities: TSpecialAuthoritiesEx;
begin
  Result := True;
  for var i := 0 to FInfoItems.Count - 1 do
  begin
    if FInfoItems.Objects[i].IsInvalidMatch(Flb) or FInfoItems.Objects[i].DisabledFlag
    then
      continue;
    SpecialAuthorities := FInfoItems.Objects[i].SpecialAuthorities;
    for var j := 0 to SpecialAuthorities.Count - 1 do
      if SpecialAuthorities[j].Visible and SpecialAuthorities[j].Enabled and
        (SpecialAuthorities[j].Value = savUnanswered) then
        Exit(False);
  end;
end;

procedure TSigItems.SaveSettings;
var
  OrderList: TSpecialAuthoritiesStringList;
  Error: string;
begin
  OrderList := TSpecialAuthoritiesStringList.Create(False);
  try
    for var i := 0 to FInfoItems.Count - 1 do
      if (FInfoItems.Objects[i].ListBox <> nil) and
        (FInfoItems.Objects[i].ListBoxIndex >= 0) and FInfoItems.Objects[i]
        .ListBox.Checked[FInfoItems.Objects[i].ListBoxIndex] and
        (not FInfoItems.Objects[i].DisabledFlag) and
        assigned(FInfoItems.Objects[i].SpecialAuthorities) then
      begin
        OrderList.AddObject(FInfoItems[i],
          FInfoItems.Objects[i].SpecialAuthorities);
        FInfoItems.Objects[i].Updated := True;
      end;
    SaveOrderSpecialAuthorities(OrderList, Error);
  finally
    FreeAndNil(OrderList);
  end;

  for var i := FInfoItems.Count - 1 downto 0 do
    if FInfoItems.Objects[i].Updated then
      FInfoItems.Delete(i);
end;

initialization

finalization

if assigned(uSigItems) then
  FreeAndNil(uSigItems);
if assigned(uSigItemsCS) then
  FreeAndNil(uSigItemsCS);

end.
