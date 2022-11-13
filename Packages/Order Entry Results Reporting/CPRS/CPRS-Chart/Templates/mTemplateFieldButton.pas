unit mTemplateFieldButton;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, uDlgComponents, VA508AccessibilityManager;

type
  TfraTemplateFieldButton = class(TFrame, ICPRSDialogComponent)
    pnlBtn: TPanel;
    lblText: TLabel;
    pbFocus: TPaintBox;
    spRequired: TShape;
    procedure pnlBtnMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlBtnMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FrameEnter(Sender: TObject);
    procedure FrameExit(Sender: TObject);
    procedure pbFocusPaint(Sender: TObject);
  private
    FCPRSDialogData: ICPRSDialogComponent;
    FBtnDown: boolean;
    FItems: TStringList;
    FOnChange: TNotifyEvent;
    procedure ButtonKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ButtonKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    function GetButtonText: string;
    procedure SetButtonText(const Value: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property ButtonText: string read GetButtonText write SetButtonText;
    property Items: TStringList read FItems;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property CPRSDialogData: ICPRSDialogComponent read FCPRSDialogData implements ICPRSDialogComponent;
  end;

implementation

{$R *.DFM}

uses
  ORFn, VA508AccessibilityRouter, VAUtils;

procedure TfraTemplateFieldButton.pnlBtnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  txt: string;
  i, idx: integer;

begin
  if(not FBtnDown) then
  begin
    FBtnDown := TRUE;
    pnlBtn.BevelOuter := bvLowered;
    if(FItems.Count > 0) then
    begin
      txt := ButtonText;
      idx := FItems.Count-1;
      for i := 0 to FItems.Count-1 do
      begin
        if(txt = FItems[i]) then
        begin
          idx := i;
          break;
        end;
      end;
      inc(idx);
      if(idx >= FItems.Count) then
        idx := 0;
      ButtonText := FItems[idx];
      if ScreenReaderSystemActive then
      begin
        txt := FItems[idx];
        if Trim(txt) = '' then
          txt := 'blank';
        GetScreenReader.Speak(txt);
      end;
      if assigned(FOnChange) then
        FOnChange(Self);
    end;
    SetFocus;
  end;
end;

procedure TfraTemplateFieldButton.pnlBtnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if(FBtnDown) then
  begin
    FBtnDown := FALSE;
    pnlBtn.BevelOuter := bvRaised;
  end;
end;

type
  TWinControlFriend = class(TWinControl);
  
procedure TfraTemplateFieldButton.FrameEnter(Sender: TObject);
begin
  pbFocus.Invalidate;
end;

procedure TfraTemplateFieldButton.FrameExit(Sender: TObject);
begin
  pbFocus.Invalidate;
end;

constructor TfraTemplateFieldButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  TabStop := TRUE;
  FItems := TStringList.Create;
  OnKeyDown := ButtonKeyDown;
  OnKeyUp := ButtonKeyUp;
  Font.Size := MainFontSize;
  FCPRSDialogData := TCPRSDialogComponent.Create(Self, 'multi value button');
end;

procedure TfraTemplateFieldButton.ButtonKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_SPACE then
    pnlBtnMouseDown(Sender, mbLeft, [], 0, 0);
end;

procedure TfraTemplateFieldButton.ButtonKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  pnlBtnMouseUp(Sender, mbLeft, [], 0, 0);
end;

function TfraTemplateFieldButton.GetButtonText: string;
begin
  Result := lblText.Caption;
end;

procedure TfraTemplateFieldButton.SetButtonText(const Value: string);
var
  i: Integer;
const
  iGap = 4;
begin
  lblText.Caption := Value;
  i := lblText.Canvas.textWidth(Value);
  if width < i + iGap then
    width := i + iGap ;
end;

procedure TfraTemplateFieldButton.pbFocusPaint(Sender: TObject);
var
  R: TRect;
begin
  if(Focused) then
  begin
    R := Rect(1, 0, pnlBtn.Width - 3, pnlBtn.Height-2);
    pbFocus.Canvas.DrawFocusRect(R);
  end;
end;

destructor TfraTemplateFieldButton.Destroy;
begin
  FItems.Free;
  FCPRSDialogData := nil;
  inherited;
end;

initialization
  SpecifyFormIsNotADialog(TfraTemplateFieldButton);

end.
