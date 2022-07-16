unit oODAnatPath;

// Developer: Theodore Fontana
// 02/24/17

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  System.Generics.Collections, System.Types, Vcl.Forms, Vcl.Controls,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Graphics, Vcl.Themes,
  ORCtrls, ORDtTm;

const
  // Custom TRadioGroup
  SP_TOP           = 4;
  SP_HEIGHT        = 5;
  SP_LEFT          = 8;
  SP_RIGHT         = 10;
  SP_BUTTON_WIDTH  = 17;
  SP_BOTTOM        = 10;
  SP_MAX_WIDTH     = 155;

type
  // A value for an element can have an associated TAssociated Date/Edit and
  // trigger another Builder Element to be required.
  TBuilderClusterItem = class(TObject)
    Associated: TWinControl;          // TAssociated Date/Edit
    Value: string;
    Require: Boolean;                 // If True then Require Trigger
    Hide: Boolean;                    // If True then Hide Trigger
    Disable: Boolean;                 // If True then Disable Trigger
    Trigger: string;                  // IEN of Element
    OrderID: string;                  // Code of Order Prompt
    OrderValue: string;               // New value of Order Prompt (from OrderID)
  end;

  // An element has many values with the potential for an associated object and
  // an object to make required for each value.
  TBuilderClusterElement = class(TObject)
  private
    FList: TObjectList<TBuilderClusterItem>;
  public
    constructor Create;
    destructor Destroy; override;
    function GetItembyValue(sValue: string): TBuilderClusterItem;
  end;

  TBuilderLocation = (blNone,blSpecimen,blText);

  TOnValidation = procedure(Sender: TObject; var bValid: Boolean; sNewVal,sOldVal: string) of object;

  TAssociatedEdit = class(TEdit)
  private
    AssociatedWith: Integer;
  protected
    procedure KeyPress(var Key: Char); override;
  end;

  TAssociatedDate = class(TORDateBox)
  private
    AssociatedWith: Integer;
    procedure ButtonClick(Sender: TObject);
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBuilderElement = class;

  TBuilderCombo = class(TComboBox)
  private
    FElement: TBuilderElement;
    FPreviousIndex: Integer;
  protected
    procedure Change; override;
    procedure DropDown; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Build(const slValues: TStringList; sDefault: string);
    procedure Initalize;
    procedure Revert;
  end;

  TBuilderEdit = class(TEdit)
  private
    FElement: TBuilderElement;
    FPreviousText: string;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
  protected
    procedure KeyPress(var Key: Char); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Initalize;
    procedure Revert;
  end;

  TBuilderGroupBox = class(TCustomGroupBox)
  private
  protected
    procedure Paint; override;
  public
  end;

  TBuilderRadioGroup = class(TBuilderGroupBox)
  private
    FElement: TBuilderElement;
    FPreviousIndex: Integer;
    FButtons: TList;
    FItems: TStrings;
    FItemIndex: Integer;
    FColumns: Integer;
    FReading: Boolean;
    FUpdating: Boolean;
    FResize: Boolean;
    FWordWrap: Boolean;
    procedure ArrangeButtons;
    procedure ButtonClick(Sender: TObject);
    procedure ItemsChange(Sender: TObject);
    procedure SetButtonCount(iValue: Integer);
    procedure SetColumns(iValue: Integer);
    procedure SetItemIndex(iValue: Integer);
    procedure SetItems(slValue: TStrings);
    procedure SetWordWrap(bValue: Boolean);
    procedure UpdateButtons;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    function GetButtons(Index: Integer): TRadioButton;
  protected
    procedure CreateWnd; override;
    procedure Loaded; override;
    procedure ReadState(Reader: TReader); override;
    function fButtonWidth(iDefault,iIndex: Integer): Integer;
    function fLeft(iButtonWidth,iIndex: Integer): Integer;
    function fHewHeight(iCaption,iMaxWidth: Integer): Integer;
    function fButtonHeight(iIndex: Integer): Integer;
    function fTop(iIndex: Integer): Integer;
    function CanModify: Boolean; virtual;
    property Columns: Integer read FColumns write SetColumns default 1;
    property ItemIndex: Integer read FItemIndex write SetItemIndex default -1;
    property Items: TStrings read FItems write SetItems;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Build(const slValues: TStringList; sDefault: string);
    procedure FlipChildren(AllLevels: Boolean); override;
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    procedure Initalize;
    procedure Revert;
    procedure GoToNextControl(cal: TAssociatedDate);
    function ButtonCount: integer;
    property Buttons[Index: Integer]: TRadioButton read GetButtons;
    property WordWrap: Boolean read FWordWrap write SetWordWrap default True;
  end;

  TBuilderElement = class(TCustomPanel)
  private
    FClusterElement: TBuilderClusterElement;      // Collection of this BuilderElement's ClusterItems
    FContainer: TGroupBox;
    FbtnReset: TButton;
    FActive: Boolean;
    FValue: string;
    FValueEx: string;
    FIEN: string;
    FValidation: TOnValidation;
    FEdited: Boolean;
    FEditBox: TBuilderEdit;
    FComboBox: TBuilderCombo;
    FRadioGroup: TBuilderRadioGroup;
    procedure ResetClick(Sender: TObject);
    procedure ResetFocus(Sender: TObject);
    procedure SetActive(const bValue: Boolean);
    procedure SetRequired(const bValue: Boolean);
    procedure SetValue(const sValue: string);
    function GetValueEx: string;
    function GetControl: TControl;
    function GetRequired: Boolean;
  protected
    procedure ChangeOrderPrompt(BuildItem: TBuilderClusterItem);
    procedure AssociatedControls;
    procedure SetBuildItem(BuildItem: TBuilderClusterItem);
    procedure SetCaption(const sValue: string);
    procedure AssociatedItemToggle(BuildItem: TBuilderClusterItem; bValid: Boolean);
    procedure EditBox(sDefault: string);
    procedure ComboBox(sl: TStringList; sDefault: string);
    procedure RadioBox(sl: TStringList; sDefault: string);
    function IsTooLong(slList: TStringList): Boolean;
    function GetBuildElement(sIEN: string): TBuilderElement;
    function GetCaption: string;
    procedure Resize; override;
    property Control: TControl read GetControl;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BuilderResize(Sender: TObject);
    procedure Build(sVals,sDefault,sHide: string);
    procedure Initalize;
    procedure Revert;
    function Valid: Boolean;
    function OwnedBy: TBuilderLocation;
    function GetCaptionwoReq: string;
    property ClusterElement: TBuilderClusterElement read FClusterElement;
    property EditBoxRef: TBuilderEdit read FEditBox;
    property ComboBoxRef: TBuilderCombo read FComboBox;
    property RadioGroupRef: TBuilderRadioGroup read FRadioGroup;
    property Active: Boolean read FActive write SetActive;
    property Caption: string read GetCaption write SetCaption;
    property OnValidate: TOnValidation read FValidation write FValidation;
    property IEN: string read FIEN write FIEN;
    property Required: Boolean read GetRequired write SetRequired Default False;
    property Value: string read FValue write SetValue;
    property ValueEx: string read GetValueEx;
    property Edited: Boolean read FEdited write FEdited;
  end;

implementation

uses
  ORfn, VAUtils, fODAnatPath, mODAnatPathBuilder, mODAnatpathSpecimen,
  VA508AccessibilityRouter;

procedure AssociateDCreate(BuildItem: TBuilderClusterItem; sValue: string;
  slValues: TStringList; builderC: TBuilderCombo; I: Integer); overload;
var
  faDate: TAssociatedDate;
  sSpecial: string;
begin
  faDate := TAssociatedDate.Create(builderC);
  faDate.Parent := builderC;
  faDate.Caption := sValue;
  faDate.Enabled := False;
  faDate.ReadOnly := True;
  BuildItem.Associated := faDate;
  faDate.AssociatedWith := builderC.Items.Count - 1;

  sSpecial := Piece(Piece(slValues[I],';',2),'-',2);
  if (sSpecial = 'PD') or (sSpecial = 'FD') then
  begin
    faDate.Format := 'mmm dd,yyyy';
    faDate.DateOnly := True;
  end;
  if (sSpecial = 'PD') or (sSpecial = 'PDT') then
    faDate.DateRange.MaxDate := NOW;
  if (sSpecial = 'FD') or (sSpecial = 'FDT') then
    faDate.DateRange.MinDate := NOW;

  builderC.Width := builderC.Width - 105;
  faDate.Top := builderC.Top;
  faDate.Left := builderC.Left + builderC.Width + 5;
end;

procedure AssociateDCreate(BuildItem: TBuilderClusterItem; sValue: string;
  slValues: TStringList; builderR: TBuilderRadioGroup; I: Integer); overload;
var
  faDate: TAssociatedDate;
  sSpecial: string;
begin
  faDate := TAssociatedDate.Create(builderR);
  faDate.Parent := builderR;
  faDate.Caption := sValue;
  faDate.Enabled := False;
  faDate.ReadOnly := True;
  BuildItem.Associated := faDate;
  faDate.AssociatedWith := builderR.FItems.Count - 1;

  sSpecial := Piece(Piece(slValues[I],';',2),'-',2);
  if (sSpecial = 'PD') or (sSpecial = 'FD') then
  begin
    faDate.Format := 'mmm dd,yyyy';
    faDate.DateOnly := True;
  end;
  if (sSpecial = 'PD') or (sSpecial = 'PDT') then
    faDate.DateRange.MaxDate := NOW;
  if (sSpecial = 'FD') or (sSpecial = 'FDT') then
    faDate.DateRange.MinDate := NOW;

  faDate.Left := SP_LEFT + SP_BUTTON_WIDTH;
end;

procedure AssociateD(BuildItem: TBuilderClusterItem; sValue: string; slValues: TStringList;
  builderC: TBuilderCombo; builderR: TBuilderRadioGroup; I: Integer);
begin
  if BuilderC <> nil then
    AssociateDCreate(BuildItem, sValue, slValues, builderC, I)
  else
    AssociateDCreate(BuildItem, sValue, slValues, builderR, I);
end;

procedure AssociateECreate(BuildItem: TBuilderClusterItem; builderC: TBuilderCombo); overload;
var
  faEdit: TAssociatedEdit;
begin
  faEdit := TAssociatedEdit.Create(builderC);
  faEdit.Parent := builderC;
  faEdit.Enabled := False;
  faEdit.ReadOnly := False;
  BuildItem.Associated := faEdit;
  faEdit.AssociatedWith := builderC.Items.Count - 1;
  builderC.Width := builderC.Width - 105;
  faEdit.Top := builderC.Top;
  faEdit.Left := builderC.Left + builderC.Width + 5;
  faEdit.Width := 100;
end;

procedure AssociateECreate(BuildItem: TBuilderClusterItem; builderR: TBuilderRadioGroup); overload;
var
  faEdit: TAssociatedEdit;
begin
  faEdit := TAssociatedEdit.Create(builderR);
  faEdit.Parent := builderR;
  faEdit.Enabled := False;
  faEdit.ReadOnly := False;
  BuildItem.Associated := faEdit;
  faEdit.AssociatedWith := builderR.FItems.Count - 1;
  faEdit.Left := SP_LEFT + SP_BUTTON_WIDTH;
end;

procedure AssociateE(BuildItem: TBuilderClusterItem; builderC: TBuilderCombo; builderR: TBuilderRadioGroup);
begin
  if BuilderC <> nil then
    AssociateECreate(BuildItem, builderC)
  else
    AssociateECreate(BuildItem, builderR);
end;

procedure SetValue(sValue: string; var BuildItem: TBuilderClusterItem;
  builderC: TBuilderCombo; builderR: TBuilderRadioGroup);
begin
  BuildItem.Value := sValue;

  if BuilderC <> nil then
  begin
    BuilderC.Items.Add(sValue);
    BuilderC.FElement.FClusterElement.FList.Add(BuildItem);
  end
  else
  begin
    BuilderR.FItems.Add(sValue);
    BuilderR.FElement.FClusterElement.FList.Add(BuildItem);
  end;
end;

procedure Default(sValue,sDefault: string; builderC: TBuilderCombo); overload;
begin
  if sValue = sDefault then
  begin
    builderC.ItemIndex := builderC.Items.Count - 1;
    builderC.Change;
  end;
end;

procedure Default(sValue,sDefault: string; builderR: TBuilderRadioGroup); overload;
begin
  if sValue = sDefault then
  begin
    builderR.ItemIndex := builderR.FButtons.Count - 1;
    builderR.Buttons[builderR.ItemIndex].TabStop := True;
  end;
end;

procedure Defaulting(sValue,sDefault: string; builderC: TBuilderCombo;
  builderR: TBuilderRadioGroup);
begin
  if BuilderC <> nil then
    Default(sValue, sDefault, builderC)
  else
    Default(sValue, sDefault, builderR);
end;

procedure CommonBuild(wControl: TWinControl; slValues: TStringList; sDefault: string);
var
  I: Integer;
  sValue,sAssociate: string;
  BuildItem: TBuilderClusterItem;
  builderC: TBuilderCombo;
  builderR: TBuilderRadioGroup;

  // value ; code (D,E,"",OrderPromptID) ; # OR value
  //   EXAMPLE: (OrderPromptID)   OPURG  ; 1
  //     *When this value change the order prompt (Urgency) value to 1
  //   EXAMPLE: (Associated Date) D-PD   ;
  //     *When this value associate a Date Component that is Past Dates Only
  //   EXAMPLE: (Make Required)          ; #
  //     *When this value make the builder element with IEN equal to this number required
  //   EXAMPLE: (Hide)            #H     ; #
  //     *When this value hide the builder element with IEN equal to this number
  //   EXAMPLE: (Disable)         #D     ; #
  //     *When this value disable the builder element with IEN equal to this number

begin
  builderC := nil;
  builderR := nil;
  if wControl is TBuilderCombo then
    builderC := TBuilderCombo(wControl)
  else if wControl is TBuilderRadioGroup then
    builderR := TBuilderRadioGroup(wControl)
  else Exit;

  for I := 0 to slValues.Count - 1 do
  begin
    sValue := Piece(slValues[I],';',1);
    BuildItem := TBuilderClusterItem.Create;
    SetValue(sValue, BuildItem, BuilderC, BuilderR);

    sAssociate := Piece(Piece(slValues[I],';',2),'-',1);
    if sAssociate = 'D' then
      AssociateD(BuildItem, sValue, slValues, BuilderC, BuilderR, I)
    else if sAssociate = 'E' then
      AssociateE(BuildItem, BuilderC, BuilderR)
    else if sAssociate = '#H' then
    begin
      BuildItem.Hide := True;
      BuildItem.Trigger := Piece(slValues[I],';',3);
    end
    else if sAssociate = '#D' then
    begin
      BuildItem.Disable := True;
      BuildItem.Trigger := Piece(slValues[I],';',3);
    end
    else if sAssociate <> '' then
    begin
      BuildItem.OrderID := sAssociate;
      BuildItem.OrderValue := Piece(slValues[I],';',3);
    end
    else
      BuildItem.Trigger := Piece(slValues[I],';',3);

    Defaulting(sValue, sDefault, BuilderC, BuilderR);
  end;
end;

{$REGION 'TBuilderClusterElement'}

constructor TBuilderClusterElement.Create;
begin
  FList := TObjectList<TBuilderClusterItem>.Create(True);
end;

destructor TBuilderClusterElement.Destroy;
begin
  FList.Free;

  inherited;
end;

function TBuilderClusterElement.GetItembyValue(sValue: string): TBuilderClusterItem;
var
  I: Integer;
begin
  Result := nil;

  for I := 0 to FList.Count - 1 do
    if CompareText(FList[I].Value, sValue) = 0 then
    begin
      Result := FList[I];
      Break;
    end;
end;

{$ENDREGION}

{$REGION 'TBuilderElement'}

{ TResetButton }

// Private ---------------------------------------------------------------------

procedure TBuilderElement.ResetClick(Sender: TObject);
begin
  Initalize;
end;

procedure TBuilderElement.ResetFocus(Sender: TObject);
var
  txt: string;

begin
  if ScreenReaderSystemActive then
  begin
    if Required then
    begin
      txt := Caption;
      if (length(txt)>0) and (txt[1] = '*') then
        Delete(txt, 1, 1);
      GetScreenReader.Speak('Required field ' + txt + ' reset ');
    end
    else
      GetScreenReader.Speak(Caption + ' reset ');
  end;
end;

procedure TBuilderElement.Resize;

  procedure UpdateDateControls(Ctrl: TWinControl);
  var
    i: integer;
    child: TControl;
  begin
    for i := 0 to Ctrl.ControlCount - 1 do
    begin
      child := Ctrl.Controls[i];
      if child is TAssociatedDate then
        child.Width := Ctrl.Width - child.Left - 4;
      if child is TWinControl then
        UpdateDateControls(TWinControl(child));
    end;
  end;

begin
  inherited;
  UpdateDateControls(Self);
end;

procedure TBuilderElement.SetActive(const bValue: Boolean);
var
  I: Integer;
begin
  for I := 0 to FContainer.ControlCount - 1 do
    FContainer.Controls[I].Enabled := bValue;
  FbtnReset.Enabled := bValue;
end;

procedure TBuilderElement.SetRequired(const bValue: Boolean);
var
  sCaption: string;
begin
  sCaption := Caption;

  if sCaption <> '' then
  begin
    if bValue then
    begin
      if sCaption[1] <> '*' then
        Caption := '*' + sCaption;
    end
    else
    begin
      if sCaption[1] = '*' then
      begin
        Delete(sCaption, 1, 1);
        Caption := sCaption;
      end;
    end;
  end;
end;

procedure TBuilderElement.SetValue(const sValue: string);
var
  bValid: Boolean;
  sOldValue: string;
  BuildItem: TBuilderClusterItem;
begin
  FEdited := False;
  bValid := True;
  sOldValue := FValue;
  FValue := sValue;

  // Execute validation addon first
  if Assigned(OnValidate) then
  begin
    OnValidate(Control, bValid, sValue, sOldValue);
    if not bValid then
    begin
      Revert;
      Exit;
    end;
  end;

  BuildItem := FClusterElement.GetItembyValue(FValue);
  ChangeOrderPrompt(BuildItem);
  AssociatedControls;
  SetBuildItem(BuildItem);
end;

function TBuilderElement.GetValueEx: string;
var
  BuildItem: TBuilderClusterItem;
begin
  Result := '';

  BuildItem := FClusterElement.GetItembyValue(FValue);
  if Assigned(BuildItem) then
  begin
    if BuildItem.Associated is TAssociatedDate then
      Result := TAssociatedDate(BuildItem.Associated).Text
    else if BuildItem.Associated is TAssociatedEdit then
      Result := TAssociatedEdit(BuildItem.Associated).Text;
  end;
end;

function TBuilderElement.GetControl: TControl;
begin
  Result := nil;

  if FContainer.ControlCount > 0 then
    Result := FContainer.Controls[0];
end;

function TBuilderElement.GetRequired: Boolean;
var
  sCaption: string;
begin
  Result := False;

  sCaption := Caption;
  if sCaption <> '' then
    if sCaption[1] = '*' then
      Result := True;
end;

// Protected -------------------------------------------------------------------

procedure TBuilderElement.ChangeOrderPrompt(BuildItem: TBuilderClusterItem);
begin
  // Change the value of an Order Prompt (Legacy)
  // This is a one-way change, there is no change back
  if Assigned(BuildItem) then
    if ((BuildItem.OrderID <> '') and (BuildItem.OrderValue <> '')) then
      frmODAnatPath.ChangeOrderPromptValue(BuildItem.OrderID, BuildItem.OrderValue);
end;

procedure TBuilderElement.AssociatedControls;
var
  I: Integer;
  BuildElement: TBuilderElement;
begin
  // This list is a list of all of this element's values and the actions
  // associated to those values to all must be reviewed when the value changes
  for I := 0 to FClusterElement.FList.Count - 1 do
  begin
    // Enable/Disable an Associated Control
    AssociatedItemToggle(FClusterElement.FList[I], False);

    // Make Builder Elements Required/Unrequired or Disabled/Enabled
    if FClusterElement.FList[I].Trigger <> '' then
    begin
      BuildElement := GetBuildElement(FClusterElement.FList[I].Trigger);
      if BuildElement <> nil then
      begin
        BuildElement.Visible := True;
        BuildElement.Active := True;
        BuildElement.Required := False;
      end;
    end;
  end;
end;

procedure TBuilderElement.SetBuildItem(BuildItem: TBuilderClusterItem);
var
  BuildElement: TBuilderElement;
begin
  if Assigned(BuildItem) then
  begin
    AssociatedItemToggle(BuildItem, Valid);

    if BuildItem.Trigger <> '' then
    begin
      BuildElement := GetBuildElement(BuildItem.Trigger);
      if BuildElement <> nil then
      begin
        if BuildItem.Hide then
        begin
          BuildElement.Initalize;
          BuildElement.Visible := False;
        end
        else if BuildItem.Disable then
        begin
          BuildElement.Initalize;
          BuildElement.Active := False;
        end
        else
          BuildElement.Required := True;
      end;
    end;
  end;
end;

procedure TBuilderElement.SetCaption(const sValue: string);
var
  cControl: TControl;
begin
  if Assigned(FContainer) then
    FContainer.Caption := sValue;

  cControl := GetControl;
  if cControl <> nil then
    if cControl is TBuilderRadioGroup then
      TBuilderRadioGroup(cControl).Caption := sValue;
end;

procedure TBuilderElement.AssociatedItemToggle(BuildItem: TBuilderClusterItem; bValid: Boolean);
var
  faDate: TAssociatedDate;
  faEdit: TAssociatedEdit;
begin
  if not Assigned(BuildItem.Associated) then
    Exit;

  if BuildItem.Associated is TAssociatedDate then
  begin
    faDate := TAssociatedDate(BuildItem.Associated);
    if bValid then
      faDate.Enabled := True
    else
    begin
      faDate.Enabled := False;
      faDate.Text := '';
    end;
  end
  else if BuildItem.Associated is TAssociatedEdit then
  begin
    faEdit := TAssociatedEdit(BuildItem.Associated);
    if bValid then
      faEdit.Enabled := True
    else
    begin
      faEdit.Enabled := False;
      faEdit.Clear;
    end;
  end;
end;

procedure TBuilderElement.EditBox(sDefault: string);
var
  fEdit: TBuilderEdit;
begin
  fEdit := TBuilderEdit.Create(Self);
  FEditBox := fEdit;
  fEdit.Parent := FContainer;

  if OwnedBy <> blSpecimen then
    Height := 60;

  fEdit.Width := FContainer.Width - 20;
  fEdit.Top := (FContainer.Height div 2) - (fEdit.Height div 2) + 4;
  fEdit.Left := 10;

  // Defaulting
  if sDefault <> '' then
  begin
    fEdit.Text := sDefault;
//    fEdit.OnExit(fEdit);
  end;
end;

procedure TBuilderElement.ComboBox(sl: TStringList; sDefault: string);
var
  fCombo: TBuilderCombo;
begin
  fCombo := TBuilderCombo.Create(Self);
  FComboBox := fCombo;
  fCombo.Parent := FContainer;

  if OwnedBy <> blSpecimen then
    Height := 60;

  fCombo.Top := (FContainer.Height div 2) - (fCombo.Height div 2) + 4;
  fCombo.Left := 10;
  fCombo.Width := FContainer.Width - 20;

  // Adding Values + Defaulting
  fCombo.Build(sl, sDefault);
end;

procedure TBuilderElement.RadioBox(sl: TStringList; sDefault: string);
var
  fRadio: TBuilderRadioGroup;
begin
  fRadio := TBuilderRadioGroup.Create(Self);
  FRadioGroup := fRadio;
  fRadio.Parent := FContainer;
  fRadio.Caption := Caption;

  // Adding Values + Defaulting
  fRadio.Build(sl, sDefault);
end;

function TBuilderElement.IsTooLong(slList: TStringList): Boolean;
var
  I,iTotal: Integer;
  cBit: TBitmap;
begin
  Result := False;

  cBit := TBitmap.Create;
  try
    iTotal := 0;
    for I := 0 to slList.Count - 1 do
      iTotal := iTotal + cBit.Canvas.TextWidth(Piece(slList[I],';',1));

    if iTotal > FContainer.Width then
      Result := True;
  finally
    cBit.Free;
  end;
end;

function TBuilderElement.GetBuildElement(sIEN: string): TBuilderElement;
var
  I: Integer;
  mSpecimen: TfraAnatPathSpecimen;
  mPathBuilder: TfraAnatPathBuilder;
begin
  Result := nil;

  if Owner is TfraAnatPathSpecimen then
  begin
    mSpecimen := TfraAnatPathSpecimen(Owner);
    for I := 0 to mSpecimen.Elements.Count - 1 do
    begin
      Result := (mSpecimen.Elements.Objects[I] as TBuilderElement);
      if Result.IEN = sIEN then
        Break;
    end;
  end
  else if Owner is TfraAnatPathBuilder then
  begin
    mPathBuilder := TfraAnatPathBuilder(Owner);
    for I := 0 to mPathBuilder.Elements.Count - 1 do
      if mPathBuilder.Elements[I].IEN = sIEN then
      begin
        Result := mPathBuilder.Elements[I];
        Break;
      end;
  end;
end;

function TBuilderElement.GetCaption: string;
begin
  Result := '';

  if Assigned(FContainer) then
    Result := FContainer.Caption;
end;

// Public ----------------------------------------------------------------------

constructor TBuilderElement.Create(AOwner: TComponent);
begin
  inherited;

  BevelOuter := bvNone;
  BorderStyle := bsNone;
  OnResize := BuilderResize;

  FClusterElement := TBuilderClusterElement.Create;

  FContainer := TGroupBox.Create(Self);
  FContainer.Parent := Self;
  FContainer.Top := 5;
  FContainer.Left := 3;
  FContainer.Height := Height - 5;
  FContainer.Width := Width - 28;
  FContainer.align := alNone;
  FContainer.Anchors := [akLeft, akRight, akTop, akBottom];

  FbtnReset := TButton.Create(Self);
  FbtnReset.Parent := Self;
  FbtnReset.onClick := ResetClick;
  FbtnReset.OnEnter := ResetFocus;
  FbtnReset.Caption := 'X';
  FbtnReset.Width := 14;
  FbtnReset.Height := 15;
  FbtnReset.Top := (FContainer.Height div 2) - 5;
  FbtnReset.Left := FContainer.Left + FContainer.Width + 3;
  FbtnReset.Align := alCustom;
  FbtnReset.Anchors := [akRight];

  FActive := True;
  FValue := '';
  FValueEx := '';
end;

destructor TBuilderElement.Destroy;
begin
  FClusterElement.Free;
  inherited;
end;

procedure TBuilderElement.BuilderResize(Sender: TObject);
begin
  FbtnReset.Top := (FContainer.Height div 2) + 2;
  FbtnReset.Left := FContainer.Left + FContainer.Width + 3;
end;

procedure TBuilderElement.Build(sVals,sDefault,sHide: string);
var
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    sl.Delimiter := '|';
    sl.StrictDelimiter := True;
    sl.DelimitedText := sVals;

    if sl.Count = 0 then                                                        // EditBox
      EditBox(sDefault)
    else if (sl.Count > 3) or                                                   // ComboBox
            ((OwnedBy <> blText) and (IsTooLong(sl))) then
      ComboBox(sl, sDefault)
    else                                                                        // RadioGroup
      RadioBox(sl, sDefault);

    // Hiding
    if sHide = '1' then
      Visible := False;
  finally
    sl.Free;
  end;
end;

procedure TBuilderElement.Initalize;
begin
  FEdited := False;
  if Assigned(Control) then
  begin
    if Control is TBuilderCombo then
      TBuilderCombo(Control).Initalize
    else if Control is TBuilderEdit then
      TBuilderEdit(Control).Initalize
    else if Control is TBuilderRadioGroup then
      TBuilderRadioGroup(Control).Initalize;
  end;
end;

procedure TBuilderElement.Revert;
begin
  FEdited := False;
  if Assigned(Control) then
  begin
    if Control is TBuilderCombo then
      TBuilderCombo(Control).Revert
    else if Control is TBuilderEdit then
      TBuilderEdit(Control).Revert
    else if Control is TBuilderRadioGroup then
      TBuilderRadioGroup(Control).Revert;
  end;
end;

function TBuilderElement.Valid;
begin
  Result := True;

  if not Required then
    Exit;

  if FValue = '' then
    Result := False;
end;

function TBuilderElement.OwnedBy: TBuilderLocation;
begin
  if Assigned(Owner) then
  begin
    if Owner is TfraAnatPathSpecimen then
      Result := blSpecimen
    else if Owner is TfraAnatPathBuilder then
      Result := blText
    else
      Result := blNone;
  end
  else
    Result := blNone;
end;

function TBuilderElement.GetCaptionwoReq: string;
begin
  Result := Caption;

  if Result <> '' then
    if Result[1] = '*' then
      Delete(Result, 1, 1);
end;

{$ENDREGION}

{$REGION 'TBuilderCombo'}

// Protected -------------------------------------------------------------------

procedure TBuilderCombo.Change;
begin
  inherited;

  if (Assigned(FElement) and (FElement is TBuilderElement)) then
  begin
    FPreviousIndex := Items.IndexOf(FElement.Value);
    FElement.Value := Items[ItemIndex];
  end;
end;

procedure TBuilderCombo.DropDown;
var
  iLength,I: Integer;
begin
  inherited;

  iLength := Width;
  for I := 0 to Items.Count - 1 do
    if Canvas.TextWidth(Items[I]) > iLength then
      iLength := Canvas.TextWidth(Items[I]) + GetSystemMetrics(SM_CXVSCROLL);

  SendMessage(Handle, CB_SETDROPPEDWIDTH, (iLength + 7), 0);
end;

// Public ----------------------------------------------------------------------

constructor TBuilderCombo.Create(AOwner: TComponent);
begin
  inherited;

  FElement := (AOwner as TBuilderElement);

  Align := alNone;
  Anchors := [akLeft, akRight];
  Style := csDropDownList;
  FPreviousIndex := -1;
end;

procedure TBuilderCombo.Build(const slValues: TStringList; sDefault: string);
begin
  if FElement = nil then
    Exit;

  CommonBuild(Self, slValues, sDefault);
end;

procedure TBuilderCombo.Initalize;
begin
  ItemIndex := -1;
  FPreviousIndex := -1;
  FElement.Value := '';
end;

procedure TBuilderCombo.Revert;
begin
  ItemIndex := FPreviousIndex;
  FElement.FValue := Items[FPreviousIndex];
end;

{$ENDREGION}

{$REGION 'TBuilderEdit'}

// Private ---------------------------------------------------------------------

procedure TBuilderEdit.CMExit(var Message: TCMExit);
begin
  FPreviousText := Text;

  if (Assigned(FElement) and (FElement is TBuilderElement)) then
    FElement.Value := Text;
end;

// Protected -------------------------------------------------------------------

procedure TBuilderEdit.KeyPress(var Key: Char);
begin
  inherited;

  if Key = '^' then
    Key := #0;
end;

// Public ----------------------------------------------------------------------

constructor TBuilderEdit.Create(AOwner: TComponent);
begin
  inherited;

  FElement := (AOwner as TBuilderElement);

  Align := alNone;
  Anchors := [akLeft, akRight];
  FPreviousText := '';
end;

procedure TBuilderEdit.Initalize;
begin
  Clear;
  FPreviousText := '';
end;

procedure TBuilderEdit.Revert;
begin
  Text := FPreviousText;
  FElement.FValue := FPreviousText;
end;

{$ENDREGION}

{$REGION 'TCustomBuilderRadioGroup'}

{ TBuilderGroupBox }

procedure TBuilderGroupBox.Paint;
var
  OuterRect: TRect;
  Box: TThemedButton;
  Details: TThemedElementDetails;
begin
  Canvas.Font := Self.Font;
  OuterRect := ClientRect;
  OuterRect.Top := 0;

  if Enabled then
    Box := tbGroupBoxNormal
  else
    Box := tbGroupBoxDisabled;

  Details := StyleServices.GetElementDetails(Box);
  StyleServices.DrawElement(Handle, Details, OuterRect);
  SelectClipRgn(Handle, 0);
end;

{ TGroupButton }

type
  TGroupButton = class(TRadioButton)
  private
    FInClick: Boolean;
    procedure CNCommand(var Message: TWMCommand); message CN_COMMAND;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure CreateParams(var Params: TCreateParams); override;
  public
    constructor InternalCreate(RadioGroup: TBuilderRadioGroup);
    destructor Destroy; override;
  end;

constructor TGroupButton.InternalCreate(RadioGroup: TBuilderRadioGroup);
begin
  inherited Create(RadioGroup);

  RadioGroup.FButtons.Add(Self);
  Visible := False;
  Enabled := RadioGroup.Enabled;
  ParentShowHint := False;
  OnClick := RadioGroup.ButtonClick;
  Parent := RadioGroup;
end;

destructor TGroupButton.Destroy;
begin
  TBuilderRadioGroup(Owner).FButtons.Remove(Self);

  inherited;
end;

procedure TGroupButton.CNCommand(var Message: TWMCommand);
begin
  if not FInClick then
  begin
    FInClick := True;
    try
      if ((Message.NotifyCode = BN_CLICKED) or
          (Message.NotifyCode = BN_DOUBLECLICKED)) and
           TBuilderRadioGroup(Parent).CanModify then
        inherited;
    except
      Application.HandleException(Self);
    end;
    FInClick := False;
  end;
end;

procedure TGroupButton.WMSetFocus(var Message: TWMSetFocus);
var
  text: string;

begin
  inherited;

  if ScreenReaderSystemActive then
    if Owner <> nil then
      if Owner is TBuilderRadioGroup then
      begin
        Text := TBuilderRadioGroup(Owner).Caption;
        if (length(text) > 0) and (text[1] = '*') then
        begin
          Delete(text,1,1);
          Text := 'Required Field ' + Text;
        end;
        GetScreenReader.Speak(Text);
      end;
end;

procedure TGroupButton.KeyPress(var Key: Char);
begin
  inherited;

  TBuilderRadioGroup(Parent).KeyPress(Key);
  if (Key = #8) or (Key = ' ') then
    if not TBuilderRadioGroup(Parent).CanModify then
      Key := #0;
end;

procedure TGroupButton.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;

  TBuilderRadioGroup(Parent).KeyDown(Key, Shift);
end;

procedure TGroupButton.CreateParams(var Params: TCreateParams);
begin
  inherited;

  Params.WindowClass.style := Params.WindowClass.style and not (CS_HREDRAW or CS_VREDRAW);
end;

{ TBuilderRadioGroup }

// Private ---------------------------------------------------------------------

procedure TBuilderRadioGroup.ArrangeButtons;
var
  DeferHandle: THandle;
  I,ButtonTop,ButtonWidth,ButtonHeight,ALeft: Integer;
  gbtn: TGroupButton;

begin
  if (FButtons.Count <> 0) and not FReading then
  begin
    ButtonTop := SP_TOP;
    ButtonHeight := SP_BOTTOM;
    DeferHandle := BeginDeferWindowPos(FButtons.Count);
    try
      for I := 0 to FButtons.Count - 1 do
      begin
        gbtn := TGroupButton(FButtons[I]);
        gbtn.BiDiMode := Self.BiDiMode;

        ButtonTop := fTop(I);
        ButtonWidth := fButtonWidth(((Width - SP_RIGHT) div FColumns), I);
        ButtonHeight := fButtonHeight(I);

        ALeft := fLeft(ButtonWidth, I);
        if UseRightToLeftAlignment then
          ALeft := Self.ClientWidth - ALeft - ButtonWidth;

        DeferHandle := DeferWindowPos(DeferHandle, gbtn.Handle, 0, ALeft,
                                      ButtonTop, ButtonWidth, ButtonHeight,
                                      SWP_NOZORDER or SWP_NOACTIVATE);
        gbtn.Visible := True;
      end;
    finally
      EndDeferWindowPos(DeferHandle);
    end;

    FUpdating := True;
    if (FResize and (FColumns = 1) and (FButtons.Count > 1)) then
      FElement.Height := FElement.Height + ButtonTop + ButtonHeight;

    FUpdating := False;
  end;
end;

procedure TBuilderRadioGroup.ButtonClick(Sender: TObject);
begin
  if not FUpdating then
  begin
    FPreviousIndex := FItemIndex;
    FItemIndex := FButtons.IndexOf(Sender);
    Changed;
    Click;

    if FItemIndex <> -1 then
      FElement.Value := Buttons[FButtons.IndexOf(Sender)].Caption
    else
      FElement.Value := '';
  end;
end;

function TBuilderRadioGroup.ButtonCount: integer;
begin
  Result := FButtons.Count;
end;

procedure TBuilderRadioGroup.ItemsChange(Sender: TObject);
begin
  if not FReading then
  begin
    if FItemIndex >= FItems.Count then
      FItemIndex := FItems.Count - 1;
    UpdateButtons;
  end;
end;

procedure TBuilderRadioGroup.SetButtonCount(iValue: Integer);
begin
  while FButtons.Count < iValue do
    TGroupButton.InternalCreate(Self);
  while FButtons.Count > iValue do
    TGroupButton(FButtons.Last).Free;
end;

procedure TBuilderRadioGroup.SetColumns(iValue: Integer);
begin
  if iValue < 1 then
    iValue := 1;
  if iValue > 3 then
    iValue := 3;

  if FColumns <> iValue then
  begin
    FColumns := iValue;
    ArrangeButtons;
    Invalidate;
  end;
end;

procedure TBuilderRadioGroup.SetItemIndex(iValue: Integer);
begin
  if FReading then
    FItemIndex := iValue
  else
  begin
    HandleNeeded;
    if iValue < -1 then
      iValue := -1;
    if iValue >= FButtons.Count then
      iValue := FButtons.Count - 1;
    if FItemIndex <> iValue then
    begin
      if FItemIndex >= 0 then
        TGroupButton(FButtons[FItemIndex]).Checked := False;
      FItemIndex := iValue;
      if FItemIndex >= 0 then
        TGroupButton(FButtons[FItemIndex]).Checked := True;
    end;
  end;
end;

procedure TBuilderRadioGroup.SetItems(slValue: TStrings);
begin
  FItems.Assign(slValue);
end;

procedure TBuilderRadioGroup.SetWordWrap(bValue: Boolean);
begin
  if bValue <> FWordWrap then
  begin
    FWordWrap := bValue;
    UpdateButtons;
  end;
end;

procedure TBuilderRadioGroup.UpdateButtons;
var
  I: Integer;
begin
  SetButtonCount(FItems.Count);

  for I := 0 to FButtons.Count - 1 do
  begin
    TGroupButton(FButtons[I]).Caption := FItems[I];
    TGroupButton(FButtons[I]).WordWrap := FWordWrap;
  end;

  if FItemIndex >= 0 then
  begin
    FUpdating := True;
    TGroupButton(FButtons[FItemIndex]).Checked := True;
    FUpdating := False;
  end;

  ArrangeButtons;
  Invalidate;
end;

procedure TBuilderRadioGroup.CMEnabledChanged(var Message: TMessage);
var
  I: Integer;
begin
  inherited;

  for I := 0 to FButtons.Count - 1 do
    TGroupButton(FButtons[I]).Enabled := Enabled;
end;

procedure TBuilderRadioGroup.CMFontChanged(var Message: TMessage);
begin
  inherited;

  ArrangeButtons;
end;

procedure TBuilderRadioGroup.WMSize(var Message: TWMSize);
begin
  inherited;

  if not FUpdating then
    ArrangeButtons;
end;

function TBuilderRadioGroup.GetButtons(Index: Integer): TRadioButton;
begin
  Result := TRadioButton(FButtons[Index]);
end;

// Protected -------------------------------------------------------------------

procedure TBuilderRadioGroup.CreateWnd;
begin
  inherited;

  UpdateButtons;
end;

procedure TBuilderRadioGroup.Loaded;
begin
  inherited;

  ArrangeButtons;
end;

procedure TBuilderRadioGroup.ReadState(Reader: TReader);
begin
  FReading := True;

  inherited;

  FReading := False;
  if HandleAllocated then
    UpdateButtons;
end;

function TBuilderRadioGroup.fButtonWidth(iDefault,iIndex: Integer): Integer;
var
  gbtn: TGroupButton;

begin
  Result := iDefault;

  if FColumns = 1 then
    Exit;

  gbtn := TGroupButton(FButtons[iIndex]);
  gbtn.Width := SP_BUTTON_WIDTH + Canvas.TextWidth(gbtn.Caption);
  Result := gbtn.Width + SP_LEFT;
end;

function TBuilderRadioGroup.fLeft(iButtonWidth,iIndex: Integer): Integer;
var
  I: Integer;
begin
  Result := SP_LEFT;

  if (iIndex = 0) or (FColumns = 1) then
    Exit;

  for I := 0 to (iIndex - 1) do
    Result := Result + fButtonWidth(iButtonWidth, I);
end;

var
  uLastFontSize: Integer = 0;
  uButtonHeight: Integer;

function TBuilderRadioGroup.fHewHeight(iCaption,iMaxWidth: Integer): Integer;
begin
  Result := 0;
  if uLastFontSize <> Font.Size then
  begin
    uLastFontSize := Font.Size;
    uButtonHeight := TextHeightByFont(Font.Handle, 'Tg') + 4;//+ Font.Size - 1;
  end;
  repeat
    Result := Result + uButtonHeight;
    iCaption := iCaption - iMaxWidth;
  until iCaption < 1;
end;

function TBuilderRadioGroup.fButtonHeight(iIndex: Integer): Integer;
var
  gbtn: TGroupButton;
  cBit: TBitmap;
  iButtonWidth: Integer;
begin
  gbtn := TGroupButton(FButtons[iIndex]);
  cBit := TBitmap.Create;
  try
    iButtonWidth := SP_BUTTON_WIDTH + cBit.Canvas.TextWidth(gbtn.Caption);
    gbtn.Height := fHewHeight(iButtonWidth, SP_MAX_WIDTH);
  finally
    cBit.Free;
  end;
  Result := gbtn.Height;
end;

function TBuilderRadioGroup.fTop(iIndex: Integer): Integer;
var
  I: Integer;
  BuildItem: TBuilderClusterItem;
begin
  Result := SP_TOP;

  if (iIndex = 0) or (FColumns > 1) then
    Exit;

  for I := 0 to (iIndex - 1) do
  begin
    Result := Result + SP_HEIGHT + fButtonHeight(I);

    BuildItem := FElement.FClusterElement.GetItembyValue(Buttons[I].Caption);
    if Assigned(BuildItem) then
      if Assigned(BuildItem.Associated) then
      begin
        BuildItem.Associated.Top := Buttons[I].Top + Buttons[I].Height + SP_HEIGHT;
        Result := Result + SP_HEIGHT + BuildItem.Associated.Height;
      end;
  end;
end;

function TBuilderRadioGroup.CanModify: Boolean;
begin
  Result := True;
end;

// Public ----------------------------------------------------------------------

constructor TBuilderRadioGroup.Create(AOwner: TComponent);
begin
  inherited;

  ControlStyle := [csDoubleClicks, csParentBackground];
  Align := alClient;
  BevelOuter := bvNone;

  FElement := (AOwner as TBuilderElement);
  FPreviousIndex := -1;

  FButtons := TList.Create;
  FItems := TStringList.Create;
  TStringList(FItems).OnChange := ItemsChange;
  FItemIndex := -1;
  FColumns := 1;
  FWordWrap := True;
end;

destructor TBuilderRadioGroup.Destroy;
begin
  SetButtonCount(0);
  TStringList(FItems).OnChange := nil;
  FItems.Free;
  FButtons.Free;

  inherited;
end;

procedure TBuilderRadioGroup.Build(const slValues: TStringList; sDefault: string);
begin
  if FElement = nil then
    Exit;

  FUpdating := True;
  try
    try
      if FElement.OwnedBy = blSpecimen then
        Columns := slValues.Count
      else
        Columns := 1;

      CommonBuild(Self, slValues, sDefault);

      if sDefault = '' then
        if FButtons.Count > 0 then
          Buttons[0].TabStop := True;
    finally
      FUpdating := False;
      FResize := True;
      ArrangeButtons;
    end;
  finally
    FResize := False;
  end;
end;

procedure TBuilderRadioGroup.FlipChildren(AllLevels: Boolean);
begin
  { The radio buttons are flipped using BiDiMode }
end;

//[UIPermission(SecurityAction.LinkDemand, Window=UIPermissionWindow.AllWindows)]
procedure TBuilderRadioGroup.GetChildren(Proc: TGetChildProc; Root: TComponent);
begin
end;

procedure TBuilderRadioGroup.Initalize;
begin
  ItemIndex := -1;

  if FButtons.Count > 0 then
    Buttons[0].TabStop := True;

  FPreviousIndex := -1;
  FElement.Value := '';
end;

procedure TBuilderRadioGroup.Revert;
begin
  FUpdating := True;
  ItemIndex := FPreviousIndex;

  if FPreviousIndex <> - 1 then
    FElement.FValue := Items[FPreviousIndex]
  else
  begin
    FElement.FValue := '';
    if FButtons.Count > 0 then
      Buttons[0].TabStop := True;
  end;

  FUpdating := False;
end;

procedure TBuilderRadioGroup.GoToNextControl(cal: TAssociatedDate);
var
  I: Integer;
begin
  for I := 0 to FButtons.Count - 1 do
    if I = cal.AssociatedWith then
    begin
      if (I + 1) <= (FButtons.Count - 1) then
        Buttons[I + 1].SetFocus
      else if I <> 0 then
        Buttons[0].SetFocus;
      Break;
    end;
end;

{$ENDREGION}

{$REGION 'TAssociatedDate'}

// Private ---------------------------------------------------------------------

procedure TAssociatedDate.ButtonClick(Sender: TObject);
begin
  if not DateRange.IsBetweenMinAndMax(DateSelected) then
  begin
    ShowMsg('The Date/Time you have selected falls outside the allowable range. Please try again.');
    FMDateTime := 0;
    DateSelected := NOW;
    Text := '';
  end;
end;

procedure TAssociatedDate.WMSetFocus(var Message: TWMSetFocus);
begin
  inherited;

  if ScreenReaderSystemActive then
    GetScreenReader.Speak('Associated Date, press the enter key to access.');
end;

// Protected -------------------------------------------------------------------

procedure TAssociatedDate.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;

  if ((Parent is TBuilderRadioGroup) and (Parent <> nil) and
      (Key = VK_DOWN)) then
    if Parent is TBuilderRadioGroup then
      TBuilderRadioGroup(Parent).GoToNextControl(Self);
end;

// Public ----------------------------------------------------------------------

constructor TAssociatedDate.Create(AOwner: TComponent);
begin
  inherited;

  Format := 'mmm dd,yyyy@hh:nn';
  OnDateDialogClosed := ButtonClick;
  AssociatedWith := -1;
end;

{$ENDREGION}

{$REGION 'TAssociatedEdit'}

procedure TAssociatedEdit.KeyPress(var Key: Char);
begin
  inherited;

  if Key = '^' then
    Key := #0;
end;

{$ENDREGION}

end.
