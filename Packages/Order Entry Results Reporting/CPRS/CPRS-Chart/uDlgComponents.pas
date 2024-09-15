unit uDlgComponents;

interface

uses
  ORExtensions,
  SysUtils, Windows, Messages, Classes, Controls, StdCtrls, ComCtrls, ExtCtrls, uReminders,
  TypInfo, StrUtils, ORCtrls, ORDtTm, Forms, Graphics, Dialogs, RTLConsts, Buttons,
  VA508AccessibilityManager;

type
  ICPRSDialogComponent = interface(IInterface)
  ['{C4DBA10A-2A8D-4F71-AE20-5BA350D48551}']
    function Component: TControl;
    function GetBeforeText: string;
    procedure SetBeforeText(Value: string);
    function GetAfterText: string;
    procedure SetAfterText(value: string);
    function GetRequiredField: boolean;
    procedure SetRequiredField(Value: boolean);
    function AccessText: string;
    function GetSRBreak: boolean;
    procedure SetSRBreak(Value: boolean);
    property BeforeText: string read GetBeforeText write SetBeforeText;
    property AfterText: string read GetAfterText write SetAfterText;
    property SRBreak: boolean read GetSRBreak write SetSRBreak;
    property RequiredField: boolean read GetRequiredField write SetRequiredField;
  end;

  TCPRSDialogComponent = class(TInterfacedObject, ICPRSDialogComponent)
  private
    FRequiredField: boolean;
    FComponent: TControl;
    FBeforeText: string;
    FAfterText: string;
    FSRBreak: boolean;
    FComponentName: string;
    FFollowOnCaption: string;
  public
    constructor Create(AComponent: TControl; AComponentName: string;
                       FollowOnCaption: string = '');
    function Component: TControl;
    function GetBeforeText: string;
    procedure SetBeforeText(Value: string);
    function GetAfterText: string;
    procedure SetAfterText(value: string);
    function GetRequiredField: boolean;
    procedure SetRequiredField(Value: boolean);
    function AccessText: string;
    function GetSRBreak: boolean;
    procedure SetSRBreak(Value: boolean);
    property BeforeText: string read GetBeforeText write SetBeforeText;
    property AfterText: string read GetAfterText write SetAfterText;
    property SRBreak: boolean read GetSRBreak write SetSRBreak;
    property RequiredField: boolean read GetRequiredField write SetRequiredField;
  end;

  TCPRSDialogStaticLabel = class(TVA508StaticText);

  TCPRSDialogParentCheckBox = class(TORCheckBox)
  private
    FAccessText: string;
  public
    property AccessText: string read FAccessText write FAccessText;
  end;

  TCPRSDialogFieldEdit = class(TDataEdit, ICPRSDialogComponent)
  private
    FCPRSDialogData: ICPRSDialogComponent;
    FAssociateLabel: TLabel;
    FUCUMCaption: string;
    FPrompt: TRemPrompt;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property CPRSDialogData: ICPRSDialogComponent read FCPRSDialogData implements ICPRSDialogComponent;
    property AssociateLabel: TLabel read FAssociateLabel write FAssociateLabel;
    property UCUMCaption: string read FUCUMCaption write FUCUMCaption;
    property Prompt: TRemPrompt read FPrompt write FPrompt;
  end;

  TCPRSDialogComboBox = class(TORComboBox, ICPRSDialogComponent)
  private
    FCPRSDialogData: ICPRSDialogComponent;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property CPRSDialogData: ICPRSDialogComponent read FCPRSDialogData implements ICPRSDialogComponent;
  end;

  TCPRSDialogCheckBox = class(TORCheckBox, ICPRSDialogComponent)
  private
    FCPRSDialogData: ICPRSDialogComponent;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property CPRSDialogData: ICPRSDialogComponent read FCPRSDialogData implements ICPRSDialogComponent;
  end;

  TCPRSDialogButton = class(TButton, ICPRSDialogComponent)
  private
    FCPRSDialogData: ICPRSDialogComponent;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property CPRSDialogData: ICPRSDialogComponent read FCPRSDialogData implements ICPRSDialogComponent;
  end;

  TCPRSDialogYearEdit = class(TORYearEdit);

  TCPRSDialogDateCombo = class(TORDateCombo, ICPRSDialogComponent)
  private
    FCPRSDialogInfo: ICPRSDialogComponent;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property CPRSDialogData: ICPRSDialogComponent read FCPRSDialogInfo implements ICPRSDialogComponent;
  end;

  TCPRSDialogDateBox = class(TORDateBox, ICPRSDialogComponent)
  private
    FCPRSDialogInfo: ICPRSDialogComponent;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property CPRSDialogData: ICPRSDialogComponent read FCPRSDialogInfo implements ICPRSDialogComponent;
  end;

  TCPRSNumberField = class(TEdit);

  TCPRSDialogNumber = class(TPanel, ICPRSDialogComponent)
  private
    FCPRSDialogInfo: ICPRSDialogComponent;
    FEdit: TCPRSNumberField;
    FUpDown: TUpDown;
  public
    constructor CreatePanel(AOwner: TComponent);
    destructor Destroy; override;
    property CPRSDialogData: ICPRSDialogComponent read FCPRSDialogInfo implements ICPRSDialogComponent;
    property Edit: TCPRSNumberField read FEdit;
    property UpDown: TUpDown read FUpDown;
  end;

  TCPRSTemplateFieldLabel = class(TCPRSDialogStaticLabel)
  private
    FExclude: boolean;
  public
    property Exclude: boolean read FExclude write FExclude;
  end;

  TCPRSDialogHyperlinkLabel = class(TCPRSTemplateFieldLabel, ICPRSDialogComponent)
  private
    FURL: string;
    FCPRSDialogInfo: ICPRSDialogComponent;
  protected
    procedure Clicked(Sender: TObject);
    procedure KeyPressed(Sender: TObject; var Key: Char);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init(Addr: string);
    property CPRSDialogData: ICPRSDialogComponent read FCPRSDialogInfo implements ICPRSDialogComponent;
  end;

  TCPRSDialogRichEdit = class(ORExtensions.TRichEdit, ICPRSDialogComponent)
  private
    FCPRSDialogData: ICPRSDialogComponent;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property CPRSDialogData: ICPRSDialogComponent read FCPRSDialogData implements ICPRSDialogComponent;
  end;

{This is the panel associated with child items in template and reminders dialogs}
  TDlgFieldPanel = class(TPanel)
  private
    FOnDestroy: TNotifyEvent;
    FCanvas: TControlCanvas;    {used to draw focus rect}
    FCurrentPos: TPoint;
    FChildren: TInterfaceList;
    function GetFocus: boolean;
    procedure SetTheFocus(const Value: boolean);
  protected                     {used to draw focus rect}
    procedure Paint; override;  {used to draw focus rect}
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CanFocus: Boolean; override;
    function GetFirstComponent: ICPRSDialogComponent;
    function GetNextComponent: ICPRSDialogComponent;
    property OnDestroy: TNotifyEvent read FOnDestroy write FOnDestroy;
    property Focus: boolean read GetFocus write SetTheFocus; {to draw focus rect}
    property OnKeyPress;        {to click the checkbox when spacebar is pressed}
  end;

  TVitalComboBox = class;

  TVitalEdit = class(TEdit, ICPRSDialogComponent)
  private
    FLinkedCombo: TVitalComboBox;
    FCPRSDialogInfo: ICPRSDialogComponent;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property CPRSDialogData: ICPRSDialogComponent read FCPRSDialogInfo implements ICPRSDialogComponent;
    property LinkedCombo: TVitalComboBox read FLinkedCombo write FLinkedCombo;
  end;

  TVitalComboBox = class(TComboBox, ICPRSDialogComponent)
  private
    FLinkedEdit: TVitalEdit;
    FCPRSDialogInfo: ICPRSDialogComponent;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SelectByID(Value: string);
    property LinkedEdit: TVitalEdit read FLinkedEdit write FLinkedEdit;
    property CPRSDialogData: ICPRSDialogComponent read FCPRSDialogInfo implements ICPRSDialogComponent;
  end;

  TMentalHealthMemo = class(TMemo);

procedure ScreenReaderSystem_CurrentCheckBox(CheckBox: TCPRSDialogParentCheckBox);
procedure ScreenReaderSystem_CurrentLabel(lbl: TCPRSDialogStaticLabel);
procedure ScreenReaderSystem_CurrentComponent(component: ICPRSDialogComponent);
procedure ScreenReaderSystem_AddText(text: string);
procedure ScreenReaderSystem_Continue;
procedure ScreenReaderSystem_Stop;
procedure ScreenReaderSystem_Clear;
//function ScreenReaderSystem_GetPendingText: string;

const
// Screen Reader will stop reading in a TDlgFieldPanel at all classes except these:
  ReminderScreenReaderReadThroughClasses: array[1..3] of TClass =
    (TUpDown, TLabel, TVitalComboBox);

implementation

uses System.UITypes, System.Types, uCore, ORClasses, ORFn, VA508AccessibilityRouter, uTemplateFields, VAUtils;

var
  SRCheckBox: TCPRSDialogParentCheckBox = nil;
  SRLabel: TCPRSDialogStaticLabel = nil;
  SRComp: ICPRSDialogComponent = nil;
  SRText: string = '';
  SRContinuePending: boolean = FALSE;

procedure UpdatePending;
begin
  if SRContinuePending then
  begin
    if assigned(SRComp) then
    begin
      SRComp.AfterText := SRText;
      SRText := '';
      if assigned(SRLabel) then
      begin
        SRLabel.TabStop := FALSE;
        SRLabel := nil;
      end;
    end;
    SRComp := nil;
    SRContinuePending := FALSE;
  end;
end;

procedure UpdateCheckBox;
begin
  if assigned(SRCheckBox) then
  begin
    SRCheckBox.AccessText := SRText;
    SRText := '';
    if assigned(SRLabel) then
      SRLabel.TabStop := false;
    SRLabel := nil;
    SRCheckBox := nil;
  end;
end;

procedure ScreenReaderSystem_CurrentCheckBox(CheckBox: TCPRSDialogParentCheckBox);
begin
  ScreenReaderSystem_Stop;
  SRCheckBox := CheckBox;
end;

procedure ScreenReaderSystem_CurrentLabel(lbl: TCPRSDialogStaticLabel);
begin
  if assigned(SRLabel) then
    ScreenReaderSystem_Stop;
  SRLabel := lbl;
end;

procedure ScreenReaderSystem_CurrentComponent(component: ICPRSDialogComponent);
begin
  UpdateCheckBox;
  UpdatePending;
  if component.RequiredField then
  begin
    if SRText <> '' then
      SRText := SRText + ' ';
    SRText := SRText + 'required field';
  end;
  if (SRText <> '') and (component.Component is TCPRSDialogCheckBox) then
    ScreenReaderSystem_Stop;
  SRComp := component;
  if SRText = '' then
    SRComp.BeforeText := ' '
  else
    SRComp.BeforeText := SRText;
  SRText := '';
  if assigned(SRLabel) then
  begin
    SRLabel.TabStop := FALSE;
    SRLabel := nil;
  end;
end;

procedure ScreenReaderSystem_AddText(text: string);
begin
  if RightStr(Text,1) = '*' then
    delete(text, length(text),1);
  if Text <> '' then
  begin
    if SRText <> '' then
      SRText := SRText + ' ';
    SRText := SRText + text;
  end;
end;

procedure ScreenReaderSystem_Continue;
begin
  if assigned(SRComp) then
    SRContinuePending := TRUE
  else
    SRContinuePending := FALSE;
end;

procedure ScreenReaderSystem_Stop;
begin
  UpdateCheckBox;
  UpdatePending;
  ScreenReaderSystem_Clear;
end;

procedure ScreenReaderSystem_Clear;
begin
  SRCheckBox := nil;
  if assigned(SRLabel) and (trim(SRLabel.Caption) = '') then
    SRLabel.TabStop := false;
  SRLabel := nil;
  SRComp := nil;
  SRText := '';
  SRContinuePending := FALSE;
end;

function ScreenReaderSystem_GetPendingText: string;
begin
  Result := SRText;
  SRText := '';
end;

function GetDialogControlText(Control: TControl): string;
var
  Len: Integer;
begin
  if Control is TButton then
    Result := TButton(Control).Caption
  else
  begin
    Len := Control.GetTextLen;
    SetString(Result, PChar(nil), Len);
    if Len <> 0 then Control.GetTextBuf(Pointer(Result), Len + 1);
  end;
end;

constructor TDlgFieldPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FChildren := TInterfaceList.Create;
end;

destructor TDlgFieldPanel.Destroy;
begin
  if(assigned(FOnDestroy)) then
    FOnDestroy(Self);
  FreeAndNil(FChildren);
  inherited;
end;

function TDlgFieldPanel.CanFocus: Boolean;
begin
  if csDestroying in ComponentState then
    Result := False
  else
    Result := inherited CanFocus;
end;

function TDlgFieldPanel.GetFirstComponent: ICPRSDialogComponent;
begin
  FCurrentPos := Point(-1,-1);
  Result := GetNextComponent;
end;

function TDlgFieldPanel.GetFocus: boolean;
begin
  result := Focused;
end;


function TDlgFieldPanel.GetNextComponent: ICPRSDialogComponent;
var
  Comp: ICPRSDialogComponent;
  Control: TControl;
  i: integer;
  MinLeft, MinTop, MinXGap, MinYGap, gap: Integer;
  ok: boolean;

begin
  MinLeft := FCurrentPos.x;
  MinTop := FCurrentPos.Y;
  MinXGap := MaxInt;
  MinYGap := MaxInt;
  Result := nil;
  for I := 0 to FChildren.Count - 1 do
  begin
    Comp := ICPRSDialogComponent(FChildren[i]);
    try
      Control := Comp.Component;
      if assigned(Control) then
      begin
        ok := (Control.Top > MinTop);
        if (not ok) and (Control.Top = MinTop) and (Control.Left > MinLeft) then
          ok := TRUE;
        if ok then
        begin
          ok := FALSE;
          gap := Control.Top - MinTop;
          if gap < MinYGap then
          begin
            MinYGap := gap;
            MinXGap := Control.Left;
            ok := true;
          end
          else
          if (MinYGap = gap) and (Control.Left < MinXGap) then
          begin
            MinXGap := Control.Left;
            ok := TRUE;
          end;
          if ok then
          begin
            Result := Comp;
          end;
        end;
      end;
    finally
      Comp := nil;
    end;
  end;
  if assigned(Result) then
  begin
    FCurrentPos.x := Result.Component.Left;
    FCurrentPos.Y := Result.Component.Top;
  end;
end;
  
procedure TDlgFieldPanel.Paint;
var
  DC: HDC;
  R: TRect;

begin
  inherited;
  if(Focused) then
  begin
    if(not assigned(FCanvas)) then
      FCanvas := TControlCanvas.Create;
    DC := GetWindowDC(Handle);
    try
      FCanvas.Handle := DC;
      R := ClientRect;
      InflateRect(R, -1, -1);
      FCanvas.DrawFocusRect(R);
    finally
      ReleaseDC(Handle, DC);
    end;
  end;
end;

procedure TDlgFieldPanel.SetTheFocus(const Value: boolean);
begin
  if Value and ShouldFocus(Self) then
    SetFocus;
end;

{ TVitalComboBox }

constructor TVitalComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCPRSDialogInfo := TCPRSDialogComponent.Create(Self, 'Edit Combo');
end;

destructor TVitalComboBox.Destroy;
begin
  FCPRSDialogInfo := nil;
  inherited;
end;

procedure TVitalComboBox.SelectByID(Value: string);
var
  i: integer;

begin
  for i := 0 to Items.Count-1 do
    if(Value = Items[i]) then
    begin
      ItemIndex := i;
      break;
    end;
end;

{ TCPRSTemplateFieldEdit }

constructor TCPRSDialogFieldEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCPRSDialogData := TCPRSDialogComponent.Create(Self, 'Edit');
end;

destructor TCPRSDialogFieldEdit.Destroy;
begin
  FCPRSDialogData := nil;
  inherited;
end;

{ TCPRSTemplateFieldComboBox }

constructor TCPRSDialogComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCPRSDialogData := TCPRSDialogComponent.Create(Self, 'Edit Combo');
end;

destructor TCPRSDialogComboBox.Destroy;
begin
  FCPRSDialogData := nil;
  inherited;
end;

{ TCPRSTemplateFieldCheckBox }

constructor TCPRSDialogCheckBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCPRSDialogData := TCPRSDialogComponent.Create(Self, 'Check Box');
end;

destructor TCPRSDialogCheckBox.Destroy;
begin
  FCPRSDialogData := nil;
  inherited;
end;

{ TCPRSDialogButton }

constructor TCPRSDialogButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCPRSDialogData := TCPRSDialogComponent.Create(Self, 'Button');
end;

destructor TCPRSDialogButton.Destroy;
begin
  FCPRSDialogData := nil;
  inherited;
end;

{ TCPRSTemplateFieldDateCombo }

constructor TCPRSDialogDateCombo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ORYearEditClass :=  TCPRSDialogYearEdit;
  FCPRSDialogInfo := TCPRSDialogComponent.Create(Self, 'Date Fields','Year');
end;

destructor TCPRSDialogDateCombo.Destroy;
begin
  FCPRSDialogInfo := nil;
  inherited;
end;

{ TCPRSTemplateFieldDateBox }

constructor TCPRSDialogDateBox.Create(AOwner: TComponent);
//var
//  i: integer;
//  btn: TORDateButton;

begin
  inherited Create(AOwner);
{  for i := 0 to ControlCount - 1 do
  begin
    if Controls[i] is TORDateButton then
    begin
      btn := TORDateButton(Controls[i]);
      if ScreenReaderSystemActive then
        btn.TabStop := TRUE;
      break;
    end;
  end;}
  FCPRSDialogInfo := TCPRSDialogComponent.Create(Self, 'Date Edit', 'Date');
end;

destructor TCPRSDialogDateBox.Destroy;
begin
  FCPRSDialogInfo := nil;
  inherited;
end;

{ TCPRSTemplateFieldNumber }

constructor TCPRSDialogNumber.CreatePanel(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEdit := TCPRSNumberField.Create(Self);
  FEdit.Parent := Self;
  FEdit.BorderStyle := bsNone;
  FEdit.Top := 0;
  FEdit.Left := 0;
  FEdit.AutoSelect := True;
  FUpDown := TUpDown.Create(Self);
  FUpDown.Parent := Self;
  FUpDown.Associate := FEdit;
  FUpDown.Thousands := FALSE;
  FEdit.Tag := Integer(FUpDown);
  FCPRSDialogInfo := TCPRSDialogComponent.Create(Self, 'Numeric Edit', 'Numeric');
end;

destructor TCPRSDialogNumber.Destroy;
begin
  FCPRSDialogInfo := nil;
  inherited;
end;

{ TCPRSTemplateWebLabel }

procedure TCPRSDialogHyperlinkLabel.Clicked(Sender: TObject);
begin
  GotoWebPage(FURL);
end;

type
  TFontFriend = class(TFont);

constructor TCPRSDialogHyperlinkLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCPRSDialogInfo := TCPRSDialogComponent.Create(Self, 'Hyper Link', 'Hyper Link');
  OnKeyPress := KeyPressed;
end;

destructor TCPRSDialogHyperlinkLabel.Destroy;
begin
  FCPRSDialogInfo := nil;
  inherited;
end;

procedure TCPRSDialogHyperlinkLabel.Init(Addr: string);
begin
  FURL := Addr;
  OnClick := Clicked;
  StaticLabel.OnClick := Clicked;
  Font.Assign(TORExposedControl(Parent).Font);
  Font.Color := Get508CompliantColor(clBlue);
  Font.Style := Font.Style + [fsUnderline];
  TFontFriend(Font).Changed; //  AdjustBounds; // make sure we have the right width
  AutoSize := FALSE;
  Height := Height + 1; // Courier New doesn't support underline unless it's higher
  Cursor := crHandPoint;
end;

procedure TCPRSDialogHyperlinkLabel.KeyPressed(Sender: TObject;
  var Key: Char);
begin
  if ord(Key) = VK_SPACE then
    Clicked(Self);  
end;

{ TCPRSTemplateFieldRichEdit }

constructor TCPRSDialogRichEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCPRSDialogData := TCPRSDialogComponent.Create(Self, 'Edit');
end;

destructor TCPRSDialogRichEdit.Destroy;
begin
  FCPRSDialogData := nil;
  inherited;
end;

{ TCPRSDialogData }

function TCPRSDialogComponent.Component: TControl;
begin
  Result := FComponent;
end;

constructor TCPRSDialogComponent.Create(AComponent: TControl; AComponentName: string;
        FollowOnCaption: string = '');
begin
  inherited Create;
  FComponent := AComponent;
  FSRBreak := TRUE;
  FComponentName := AComponentName;
  FFollowOnCaption := FollowOnCaption;
  FRequiredField := FALSE;
end;

function TCPRSDialogComponent.AccessText: string;
begin
  if FAfterText = '' then
    Result := FBeforeText
  else if FBeforeText = '' then
  begin
    if FAfterText <> '' then    
      Result := FComponentName + ', ' + FAfterText + ','
    else
      Result := '';
  end
  else
    Result := FBeforeText + ', ' + FComponentName + ', ' + FAfterText + ',';
  if FFollowOnCaption <> '' then
  begin
    if Result <> '' then
      Result := Result + ' ';
    Result := Result + ' ' + FFollowOnCaption;
  end;
end;

function TCPRSDialogComponent.GetAfterText: string;
begin
  Result := FAfterText;
end;

function TCPRSDialogComponent.GetBeforeText: string;
begin
  Result := FBeforeText;
end;

function TCPRSDialogComponent.GetRequiredField: boolean;
begin
  Result := FRequiredField;
end;

function TCPRSDialogComponent.GetSRBreak: boolean;
begin
  Result := FSRBreak;
end;

procedure TCPRSDialogComponent.SetAfterText(value: string);
begin
  FAfterText := Value;
end;

procedure TCPRSDialogComponent.SetBeforeText(Value: string);
begin
  FBeforeText := Value;
end;

procedure TCPRSDialogComponent.SetRequiredField(Value: boolean);
begin
  FRequiredField := Value;
end;

procedure TCPRSDialogComponent.SetSRBreak(Value: boolean);
begin
  FSRBreak := Value;
end;

{ TVitalEdit }

constructor TVitalEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCPRSDialogInfo := TCPRSDialogComponent.Create(Self, 'Vital Edit','Vital');
end;

destructor TVitalEdit.Destroy;
begin
  FCPRSDialogInfo := nil;
  inherited;
end;

initialization

finalization
  ScreenReaderSystem_Clear;

end.
