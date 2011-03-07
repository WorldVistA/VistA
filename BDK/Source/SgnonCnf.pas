{ **************************************************************
	Package: XWB - Kernel RPCBroker
	Date Created: Sept 18, 1997 (Version 1.1)
	Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
	Developers: Danila Manapsal, Don Craven, Joel Ivey
	Description: Signon Form Configuration Dialog.
	Current Release: Version 1.1 Patch 47 (Jun. 17, 2008))
*************************************************************** }

{**************************************************
1.1P31 - Modified to store signon configuration under
         the HKCU key - this permits users on NT2000
         machines who have USER access to set their
         configuration.  Also, makes configuration specific
         to users on machines which might be shared.

         Also make it so that configuration is only written
         to the registry when the user indicates that it
         should be saved (previously the default values
         were written into the registry as well as applied
         to the window if data was not in the registry).
         The default values previously stored in the registry
         would override any changes in the signon window
         design via coding.  To overcome this, if the user
         does not have saved configuration data, the window
         generated on opening will be used as the default, and
         the default data written into the registry as defaults.
         This will permit the user to restore to the current
         window defaults if desired, but will not overwrite
         changes released for the window in later patches.
************************************************************}

unit Sgnoncnf;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, Dialogs, SysUtils, MFunStr, XWBut1;

type
  TSignonValues = class(TObject)
  private
    FHeight: Integer;
    FWidth: Integer;
    FTextColor: LongInt;
    FPosition: String;
    FSize: String;
    FIntroFont: String;
    FIntroFontStyles: String;
    FBackColor: LongInt;
    FFont: TFont;
    FFontStyles: TFontStyles;
    FTop: Integer;
    FLeft: Integer;
    procedure SetSize(const Value: String);
    procedure SetPosition(const Value: String);
    procedure SetIntroFont(const Value: String);
    procedure SetIntroFontStyles(const Value: String);
    procedure SetFont(Value: TFont);
    procedure SetTextColor(Value: LongInt);
  public
    procedure Clear; virtual;
    constructor Create;
    destructor Destroy; override;
    procedure SetEqual(EqualToValue: TSignonValues);
    property Height: Integer read FHeight write FHeight;
    property Width: Integer read FWidth write FWidth;
    property TextColor: LongInt read FTextColor write SetTextColor;
    property Position: String read FPosition write SetPosition;
    property Size: String read FSize write SetSize;
    property IntroFont: String read FIntroFont write SetIntroFont;
    property IntroFontStyles: String read FIntroFontStyles write SetIntroFontStyles;
    property BackColor: LongInt read FBackColor write FBackColor;
    property Font: TFont read FFont write SetFont;
    property FontStyles: TFontStyles read FFontStyles write FFontStyles;
    property Top: Integer read FTop write FTop;
    property Left: Integer read FLeft write FLeft;
  end;

  TSignonConfiguration = class;

{
   This class is the form shown for configuration of the signon form
}
  TfrmSignonConfig = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    HelpBtn: TBitBtn;
    Bevel1: TBevel;
    rgrWindowPosition: TRadioGroup;
    rgrWindowSize: TRadioGroup;
    FontDialog1: TFontDialog;
    GroupBox1: TGroupBox;
    Button1: TButton;
    btnDefaults: TBitBtn;
    rgrIntroBackClr: TRadioGroup;
    ColorDialog1: TColorDialog;
    procedure Button1Click(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rgrIntroBackClrClick(Sender: TObject);
  private
    { Private declarations }
    FController: TSignonConfiguration;
  public
    property Controller: TSignonConfiguration read FController write FController;
    { Public declarations }
  end;

{
     This class handles the processing for signon configuration
}
  TSignonConfiguration = class(TObject)
  private
    OrigHelp: String;
    FIntroBackColor: LongInt;
    FIntroFontValue: String;
    FIntroFontStyles: String;
    FIntroTextColor: LongInt;
    FPosition: String;
    FSize: String;
  protected
    procedure ResetToDefaults; virtual;
    procedure UserClickedOK; virtual;
    procedure IntroBackColor; virtual;
    procedure FontDialog; virtual;
    procedure UpdateWindow;
  public
    function ShowModal: Integer; virtual;
    procedure ReadRegistrySettings;
    constructor Create;
  end;

function StoreFontStyle(Values: TFontStyles): string;
function RestoreFontStyles(Value: String): TFontStyles;


var
  frmSignonConfig: TfrmSignonConfig;
  strPosition, strSize: string;
  InitialValues: TSignonValues;
  SignonDefaults: TSignonValues;
  IsSharedBroker: Boolean;

{
const
  DfltWidth: integer = 794; // 631; // 611;  // 608;
  DfltHeight: integer = 591;  // 467; // 300;
  DfltIntroClr: longint = clWindow;
  DfltPosition: string = '0';
  DfltSize: string = '0';
  DfltIntroFont: string = '';  //  'Fixedsys^8'; // 'Courier New^8';
  DfltIntroFontStyle: TFontStyles = [fsBold];
  DfltBackClr: integer = 0;
  p:string = '[';
}

implementation

{$R *.DFM}

uses LoginFrm, fSgnonDlg, Trpcb;

procedure TfrmSignonConfig.Button1Click(Sender: TObject);
begin
//  FontDialog1.Execute;
  Controller.FontDialog;
end;

procedure TfrmSignonConfig.OKBtnClick(Sender: TObject);
begin

end;

{-------------- TSignonConfiguration.ReadRegistrySettings --------------
Read Signon related settings from the Registry.  Substitute defaults
for missing values.
------------------------------------------------------------------}
procedure TSignonConfiguration.ReadRegistrySettings;
var
  strFontStyle: String;
  strFontColor: String;
  strFontSettings: String;
begin
  { Test handling of Defaults }
//  ShowMessage
  InitialValues.SetEqual(SignonDefaults);
  InitialValues.Position := '0';
  InitialValues.Size := '0';
  InitialValues.BackColor := clWindow;
  InitialValues.TextColor := clWindowText;

  {%%%%%%% Sign-on Window Position %%%%%%%}
  strPosition := ReadRegDataDefault(HKCU, REG_SIGNON, 'SignonPos','');
  if strPosition <> '' then
    InitialValues.Position := strPosition;

  {%%%%%%% Sign-on Window Size %%%%%%%}
  strSize := ReadRegDataDefault(HKCU, REG_SIGNON, 'SignonSiz', '');
  if strSize <> '' then
    InitialValues.Size := strSize;

  {%%%%%%% Intro Text Background Color %%%%%%%}
  if ReadRegDataDefault(HKCU, REG_SIGNON, 'IntroBackClr', '') <> '' then
    InitialValues.BackColor := StrToInt(ReadRegDataDefault(HKCU, REG_SIGNON, 'IntroBackClr', ''));

  {%%%%%%% Intro Text Font %%%%%%%}
  strFontSettings := ReadRegDataDefault(HKCU, REG_SIGNON, 'IntroTextFont', '');
  if strFontSettings <> '' then
  begin
    InitialValues.IntroFont := strFontSettings;
    InitialValues.Font.Name := Piece(strFontSettings,U,1);
    InitialValues.Font.Size := StrToInt(Piece(strFontSettings,U,2));
  end;
  
  {%%%%%%% Intro Text Color %%%%%%%}
  strFontColor := ReadRegDataDefault(HKCU, REG_SIGNON, 'IntroTextClr', '');
  if strFontColor <> '' then
  begin
    InitialValues.TextColor := StrToInt(strFontColor);
    InitialValues.Font.Color := InitialValues.TextColor;
  end;

  {%%%%%%% Intro Text Font Styles %%%%%%%}
  strFontStyle := ReadRegDataDefault(HKCU, REG_SIGNON, 'IntroTextStyle', '');
  if strFontStyle <> '' then
  begin
    InitialValues.IntroFontStyles := strFontStyle;
    InitialValues.Font.Style := RestoreFontStyles(strFontStyle)
  end;
end;


function StoreFontStyle(Values: TFontStyles): String;
begin
  Result := '';
  if fsBold in Values then
    Result := Result + 'B';
  if FsItalic in Values then
    Result := Result + 'I';
  if fsUnderline in Values then
    Result := Result + 'U';
  if fsStrikeout in Values then
    Result := Result + 'S';
end;

procedure TfrmSignonConfig.FormShow(Sender: TObject);
begin
  //
end;

function RestoreFontStyles(Value: String): TFontStyles;
begin
  Result := [];
  if pos('B',Value) > 0 then
    Result := Result + [fsBold];
  if pos('I',Value) > 0 then
    Result := Result + [fsItalic];
  if pos('U',Value) > 0 then
    Result := Result + [fsUnderline];
  if pos('S',Value) > 0 then
    Result := Result + [fsStrikeout];
end;

procedure TfrmSignonConfig.rgrIntroBackClrClick(Sender: TObject);
begin
  Controller.IntroBackColor;
end;

function TSignonConfiguration.ShowModal: Integer;
var
  ModalValue: Integer;
begin
  ReadRegistrySettings;
  if frmSignonConfig = nil then
    frmSignonConfig := TfrmSignonConfig.Create(Application);
  frmSignonConfig.Controller := Self;
  OrigHelp := Application.HelpFile;             // Save original helpfile.
  try
    Application.HelpFile := ReadRegData(HKLM, REG_BROKER, 'BrokerDr') +
                           '\clagent.hlp';      // Identify ConnectTo helpfile.
    with frmSignonConfig do
    begin
      // set selections for entry to form
      rgrIntroBackClr.ItemIndex := 0;   // Current Background
      rgrWindowPosition.ItemIndex := StrToInt(Piece(InitialValues.Position,U,1));
      rgrWindowSize.ItemIndex := StrToInt(Piece(InitialValues.Size,U,1));
         // initialize font values to current settings
      FIntroFontValue := InitialValues.IntroFont;
      FIntroTextColor := InitialValues.TextColor;
      FIntroFontStyles := InitialValues.IntroFontStyles;

      ShowApplicationAndFocusOK(Application);
      ModalValue := frmSignonConfig.ShowModal;
      if ModalValue = mrOK then  // establish changes for user
      begin
        UserClickedOK
      end
      else if ModalValue = mrIgnore then  // restore default values
        ResetToDefaults;
    end;    // with SignonForm
    Result := ModalValue;
  finally
    frmSignonConfig.Free;   // Release;  jli 041104
    Application.HelpFile := OrigHelp;  // Restore helpfile.
  end;
end;

{
 called if user changes selection for Background Color
   selection 0 is to current value
   selection 1 is to select new color
}
procedure TSignonConfiguration.IntroBackColor;
var
  frmSignonDialog: TfrmSignonDialog;
  OldHandle: THandle;
begin
  OldHandle := GetForegroundWindow;
  if frmSignonConfig.rgrIntroBackClr.ItemIndex = 1 then
  begin
    frmSignonDialog := TfrmSignonDialog.Create(Application);
//    ShowApplicationAndFocusOK(Application);
      SetForegroundWindow(frmSignonDialog.Handle);
    if frmSignonDialog.ShowModal = mrOK then
      FIntroBackColor := clWindow
    else
    begin
      ShowApplicationAndFocusOK(Application);
      if IsSharedBroker then
        frmSignonConfig.WindowState := wsMinimized;
      if frmSignonConfig.ColorDialog1.Execute then
        FIntroBackColor := frmSignonConfig.ColorDialog1.Color;
      frmSignonConfig.WindowState := wsNormal;
    end;
  end
  else
    FIntroBackColor := InitialValues.BackColor;
  SetForegroundWindow(OldHandle);
end;

{ called if user selects to change font for signon form }
procedure TSignonConfiguration.FontDialog;
var
  frmSignonDialog: TfrmSignonDialog;
  OldHandle: THandle;
  FFontValue: TFont;
begin
  FFontValue := TFont.Create;
  OldHandle := GetForegroundWindow;
  try
    FFontValue.Name := InitialValues.Font.Name;
    FFontValue.Size := InitialValues.Font.Size;
    FFontValue.Style := InitialValues.Font.Style;
    FFontValue.Color := InitialValues.Font.Color;
    frmSignonDialog := TfrmSignonDialog.Create(Application);
    frmSignonDialog.Label1.Caption := 'Do you want to use the Default Font face and size?';
  //  ShowApplicationAndFocusOK(Application);

    SetForegroundWindow(frmSignonDialog.Handle);
    if frmSignonDialog.ShowModal = mrOK then
      FFontValue := SignonDefaults.Font
    else
    begin
      // initialize font to current values
      frmSignonConfig.FontDialog1.Font.Color := InitialValues.Font.Color;
      frmSignonConfig.FontDialog1.Font.Name := InitialValues.Font.Name;
      frmSignonConfig.FontDialog1.Font.Size := InitialValues.Font.Size;
      frmSignonConfig.FontDialog1.Font.Style := InitialValues.Font.Style;
      ShowApplicationAndFocusOK(Application);
      if IsSharedBroker then
        frmSignonConfig.WindowState := wsMinimized;
      if frmSignonConfig.FontDialog1.Execute then
        FFontValue := frmSignonConfig.FontDialog1.Font;
      frmSignonConfig.WindowState := wsNormal;
    end;
    FIntroFontValue := FFontValue.Name + U + IntToStr(FFontValue.Size);
    FIntroFontStyles := StoreFontStyle(FFontValue.Style);
    FIntroTextColor := FFontValue.Color;
  finally
    FFontValue.Free;
    SetForegroundWindow(OldHandle);
  end;
end;

procedure TSignonConfiguration.ResetToDefaults;
begin
  if MessageDlg('Are you sure you want to reset all settings to their defaults?',
                mtWarning, [mbNo, mbYes], 0) = mrYes then
  begin
       // P31 remove setting of default values into registry -
       //     remove entries from registry and use default window in app
    DeleteRegData(HKCU, REG_SIGNON, 'SignonPos');
    DeleteRegData(HKCU, REG_SIGNON, 'SignonSiz');
    DeleteRegData(HKCU, REG_SIGNON, 'IntroBackClr');
    DeleteRegData(HKCU, REG_SIGNON, 'IntroTextClr');
    DeleteRegData(HKCU, REG_SIGNON, 'IntroTextFont');
    DeleteRegData(HKCU, REG_SIGNON, 'IntroTextStyle');
    strPosition := '0';
    strSize := '0';
    // Restore values to Defaults at Signon
    InitialValues.SetEqual(SignonDefaults);

    UpdateWindow;
  end;
end;

procedure TSignonConfiguration.UserClickedOK;
var
  JPosition: Integer;
  JSize: Integer;
begin
  JPosition := frmSignonConfig.rgrWindowPosition.ItemIndex;
  JSize := frmSignonConfig.rgrWindowSize.ItemIndex;

  if JPosition = 0 then
    FPosition := '0'
  else
    FPosition := IntToStr(JPosition)+U+IntToStr(frmSignon.Top)+U+IntToStr(frmSignon.Left);
  strPosition := FPosition;

  if JSize = 0 then
    FSize := '0'
  else
    FSize := IntToStr(JSize)+U+IntToStr(frmSignon.Width)+U+IntToStr(frmSignon.Height);
  strSize := FSize;

  if FIntroBackColor <> InitialValues.BackColor then
  begin
    InitialValues.BackColor := FIntroBackColor;
    if InitialValues.BackColor <> SignonDefaults.BackColor then
      WriteRegData(HKCU, REG_SIGNON, 'IntroBackClr',IntToStr(FIntroBackColor))
    else
      DeleteRegData(HKCU, REG_SIGNON, 'IntroBackClr');
  end;

  if FIntroTextColor <> InitialValues.TextColor then
  begin
    InitialValues.TextColor := FIntroTextColor;
    if InitialValues.BackColor <> SignonDefaults.BackColor then
      WriteRegData(HKCU, REG_SIGNON, 'IntroTextClr',IntToStr(FIntroTextColor))
    else
      DeleteRegData(HKCU, REG_SIGNON, 'IntroTextClr');
  end;

  if FIntroFontValue <> InitialValues.IntroFont then
  begin
    InitialValues.IntroFont := FIntrofontValue;
    if InitialValues.IntroFont <> SignonDefaults.IntroFont then
      WriteRegData(HKCU, REG_SIGNON, 'IntroTextFont',FIntroFontValue)
    else
      DeleteRegData(HKCU, REG_SIGNON, 'IntroTextFont');
  end;

  if FIntroFontStyles <> InitialValues.IntroFontStyles then
  begin
    InitialValues.IntroFontStyles := FIntrofontStyles;
    if InitialValues.IntroFontStyles <> SignonDefaults.IntroFontStyles then
      WriteRegData(HKCU, REG_SIGNON, 'IntroTextStyle',FIntroFontStyles)
    else
      DeleteRegData(HKCU, REG_SIGNON, 'IntroTextStyle');
  end;

  if FPosition <> InitialValues.Position then
  begin
    InitialValues.Position := FPosition;
     if InitialValues.Position <> SignonDefaults.Position then
      WriteRegData(HKCU, REG_SIGNON, 'SignonPos',FPosition)
    else
      DeleteRegData(HKCU, REG_SIGNON, 'SignonPos');
  end;

  if FSize <> InitialValues.Size then
  begin
    InitialValues.Size := FSize;
    if InitialValues.Size <> SignonDefaults.Size then
      WriteRegData(HKCU, REG_SIGNON, 'SignonSiz',FSize)
    else
      DeleteRegData(HKCU, REG_SIGNON, 'SignonSiz');
  end;

  UpdateWindow;
end;

constructor TSignonConfiguration.Create;
begin
  inherited;
  if SignonDefaults = nil then
    SignonDefaults := TSignonValues.Create;
  if InitialValues = nil then
    InitialValues := TSignonValues.Create;

end;

procedure TSignonConfiguration.UpdateWindow;
begin
  // TODO -cMM: default body inserted
    frmSignon.IntroText.Color := InitialValues.BackColor;
    frmSignon.IntroText.Font.Name := InitialValues.Font.Name;
    frmSignon.IntroText.Font.Size := InitialValues.Font.Size;
    frmSignon.IntroText.Font.Style := InitialValues.Font.Style;
    frmSignon.IntroText.Font.Color := InitialValues.Font.Color;
    frmSignon.Left := SignonDefaults.Left;
    frmSignon.Top := SignonDefaults.Top;
    frmSignon.Width := SignonDefaults.Width;
    frmSignon.Height := SignonDefaults.Height;
end;

procedure TSignonValues.Clear;
begin
    FHeight := 0;
    FWidth := 0;
    FTextColor := clWindowText;
    FPosition := '';
    FSize := '';
    FIntroFont := '';
    FIntroFontStyles := '';
    FBackColor := clWindow;
    FFont.Name := 'Courier New' ;
    FFont.Size := 11;
    FFont.Style := [];
end;

constructor TSignonValues.Create;
begin
  inherited;
  FFont := TFont.Create;
end;

destructor TSignonValues.Destroy;
begin
  FFont.Free;
  inherited;
end;

procedure TSignonValues.SetSize(const Value: String);
begin
  FSize := Value;
  if Value <> '0' then
  begin
    FWidth := StrToInt(Piece(Value,U,2));
    FHeight := StrToInt(Piece(Value,U,3));
  end;
end;

procedure TSignonValues.SetPosition(const Value: String);
begin
  FPosition := Value;
  if Value <> '0' then
  begin
    FTop := StrToInt(Piece(Value,U,2));
    FLeft := StrToInt(Piece(Value,U,3));
  end;
end;

procedure TSignonValues.SetIntroFont(const Value: String);
begin
  FIntroFont := Value;
  FFont.Name := Piece(Value,U,1);
  FFont.Size := StrToInt(Piece(Value,U,2));
end;

procedure TSignonValues.SetIntroFontStyles(const Value: String);
begin
  FIntroFontStyles := Value;
  if Value <> '' then
    FFont.Style := RestoreFontStyles(Value)
  else
    FFont.Style := [];
end;

procedure TSignonValues.SetEqual(EqualToValue: TSignonValues);
begin
  BackColor := EqualToValue.BackColor;
  Font.Name := EqualToValue.Font.Name;
  Font.Size := EqualToValue.Font.Size;
  FontStyles := EqualToValue.FontStyles;
  Height := EqualToValue.Height;
  IntroFont := EqualToValue.IntroFont;
  IntroFontStyles := EqualToValue.IntroFontStyles;
  Left := EqualToValue.Left;
  Position := EqualToValue.Position;
  Size := EqualToValue.Size;
  TextColor := EqualToValue.TextColor;
  Top := EqualToValue.Top;
  Width := EqualToValue.Width;
end;

procedure TSignonValues.SetFont(Value: TFont);
begin
  FFont := Value;
  FIntroFont := Value.Name+U+IntToStr(Value.Size);
  FIntroFontStyles := StoreFontStyle(FFont.Style)
end;

procedure TSignonValues.SetTextColor(Value: LongInt);
begin
  FTextColor := Value;
  FFont.Color := Value;
end;

end.
