///////////////////////////////////////////////////////////////////////////////
// Name: fPCEBase.pas, fPCEBase.dfm
// Created: Jan 1999
// By: Robert Bott
// Location: ISL
// Description: Parent form for all PCE tabs.  This form will hold methods that
// are universal for a PCE tabs.  These forms will be child forms to
// fEncounterFrame.
////////////////////////////////////////////////////////////////////////////////

unit fPCEBase;

interface

uses
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.Buttons,
  Vcl.Controls,
  Vcl.ExtCtrls,
  System.Classes,
  Winapi.Messages,
  VA508AccessibilityManager,
  uConst,
  fAutoSz;

type
  TfrmPCEBase = class(TfrmAutoSz)
    pnlBottomAncestor: TPanel;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    pnlMainAncestor: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject); virtual;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCancelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    FDisplayCount: Integer; // number of times page displayed
    FPatientCount: Integer; // number of times page displayed for given pt
    FCallingContext: Integer;
  protected
    FClosing: Boolean;
    FSectionTabs: array [0 .. 2] of Integer;
    FSectionTabCount: Integer;
    FTabName: string;
    function ActiveCtrl: TWinControl;
    function SectionString: string;
    procedure DoEnter; override;
    procedure Loaded; override;
  public
    constructor CreateLinked(AParent: TWinControl; AVisible: Boolean);
    procedure DisplayPage; virtual;
    procedure SetFontSize(NewFontSize: Integer); virtual;
    procedure AllowTabChange(var AllowChange: Boolean); virtual;
    property CallingContext: Integer read FCallingContext;
    procedure FocusFirstControl;
  end;

implementation

{$R *.DFM}

uses
  System.Math,
  System.SysUtils,
  ORCtrls,
  VA508AccessibilityRouter,
  fEncounterFrame,
  uPCE;

procedure TfrmPCEBase.FormCreate(Sender: TObject);
// Description: Initialize counters to zero
begin
  FDisplayCount := 0;
  FPatientCount := 0;
end;

procedure TfrmPCEBase.Loaded;
// Description: make the form borderless to allow it to be a child window
begin
  inherited Loaded;
  Visible := False;
  Position := poDefault;
  BorderIcons := [];
  BorderStyle := bsNone;
  HandleNeeded;
  SetBounds(0, 0, Width, Height);
end;

procedure TfrmPCEBase.DisplayPage;
// Description: cause the page to be displayed and update the display counters
begin
  BringToFront;
  Inc(FDisplayCount);
  Inc(FPatientCount);
  FCallingContext := frmEncounterFrame.ChangeSource;
  if (FCallingContext = CC_CLICK) and (FPatientCount = 1) then
      FCallingContext := CC_INIT_PATIENT;
end;

procedure TfrmPCEBase.SetFontSize(NewFontSize: Integer);
// Description: Assign the new font size.
begin
  Font.Size := NewFontSize;
end;

procedure TfrmPCEBase.AllowTabChange(var AllowChange: Boolean);
begin
  // Do nothing;
end;

procedure TfrmPCEBase.btnCancelClick(Sender: TObject);
// Description: Indicate to the frame that cancel was pressed, and close the frame.
begin
  inherited;
  ClearPostValidateMag(Self);
  frmEncounterFrame.Abort := False;
  frmEncounterFrame.Cancel := True;
  frmEncounterFrame.Close;
end;

procedure TfrmPCEBase.btnCancelMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Button = mbLeft then ClearPostValidateMag(Self);
end;

procedure TfrmPCEBase.btnOKClick(Sender: TObject);
// Description: Indicate to the frame that it should close and save data.
begin
  frmEncounterFrame.Abort := False;
  frmEncounterFrame.Close;
end;

procedure TfrmPCEBase.FormClose(Sender: TObject; var Action: TCloseAction);
// Description: Free the memory held by the form.
begin
  inherited;
  Action := caFree; // destroy the forms when closed
  FClosing := True;
end;

constructor TfrmPCEBase.CreateLinked(AParent: TWinControl;
  AVisible: Boolean);
begin
  inherited Create(nil);
  Parent := AParent;
  Align := alClient;
  Visible := AVisible;
  AParent.Constraints.MinWidth := Max(AParent.Constraints.MinWidth,
    Constraints.MinWidth);
  AParent.Constraints.MinHeight := Max(AParent.Constraints.MinHeight,
    Constraints.MinHeight);
end;

function TfrmPCEBase.ActiveCtrl: TWinControl;
begin
  Result := GetParentForm(Self).ActiveControl;
  if (Result is TORComboEdit) then Result := TWinControl(Result.Owner);
end;

function TfrmPCEBase.SectionString: string;
var
  V, I: Integer;
begin
  Result := '';
  if FSectionTabCount = 0 then exit;
  V := 0;
  for I := 0 to FSectionTabCount - 1 do
  begin
    if (Result <> '') then Result := Result + ',';
    Result := Result + IntToStr(FSectionTabs[I]);
    V := FSectionTabs[I];
  end;
  for I := 1 to 20 do
  begin
    if (V < 0) then Dec(V, 32)
    else Inc(V, 32);
    if Result <> '' then Result := Result + ',';
    Result := Result + IntToStr(V);
  end;
end;

procedure TfrmPCEBase.DoEnter;
begin
  inherited;
  frmEncounterFrame.SelectTab(FTabName);
end;

procedure TfrmPCEBase.FocusFirstControl;
begin
  //  SetFocus;
  FindNextControl(Self, True, True, False).SetFocus;
end;

initialization

SpecifyFormIsNotADialog(TfrmPCEBase);

end.
