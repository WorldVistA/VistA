unit fCoverSheet;
{
  ================================================================================
  *
  *       Application:  CPRS - Coversheet
  *       Developer:    dan.petit@domain.ext
  *       Site:         Salt Lake City ISC
  *       Date:         2015-12-21
  *
  *       Description:  Main form for other coversheet components.
  *
  *       Notes:
  *
  ================================================================================
}

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.UITypes,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  VA508AccessibilityRouter,
  iCoverSheetIntf,
  fBase508Form;

type
  TfrmCoverSheet = class(TfrmBase508Form, ICPRSTab)
    gpMain: TGridPanel;
  private
    fDisplayCount: Integer;
    fPatientCount: Integer;
    fCallingContext: Integer;

    { Prevents auto free when RefCount = 0 needed for interfaces}
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  protected
    { ICPRSTab }
    procedure OnClearPtData(Sender: TObject); virtual;
    procedure OnDisplayPage(Sender: TObject; aCallingContext: Integer); virtual;
    procedure OnLoaded(Sender: TObject); virtual;

    { ICPRS508 }
    procedure OnFocusFirstControl(Sender: TObject); virtual;
    procedure OnSetFontSize(Sender: TObject; aNewSize: Integer); virtual;
    procedure OnSetScreenReaderStatus(Sender: TObject; aActive: boolean);

    procedure DestroyWindowHandle; override;
  public
    { Public declarations }
    constructor Create(aOwner: TComponent); override;
  end;

var
  frmCoverSheet: TfrmCoverSheet;

implementation

uses
  uConst,
  uCore,
  VAUtils, uPCE;

{$R *.dfm}

{ TfrmCoverSheet }

constructor TfrmCoverSheet.Create(aOwner: TComponent);
begin
  inherited;
  fPatientCount := 0;
  fDisplayCount := 0;
  fCallingContext := 0;
end;

procedure TfrmCoverSheet.OnFocusFirstControl(Sender: TObject);
var
  aCPRS508: ICPRS508;
begin
  if Visible then
    if Supports(CoverSheet, ICPRS508, aCPRS508) then
      aCPRS508.OnFocusFirstControl(Sender);
end;

procedure TfrmCoverSheet.OnLoaded(Sender: TObject);
begin
  inherited Loaded;
  Visible := False;
  Position := poDefault;
  BorderIcons := [];
  BorderStyle := bsNone;
  HandleNeeded;
  SetBounds(0, 0, Width, Height);
end;

procedure TfrmCoverSheet.OnSetFontSize(Sender: TObject; aNewSize: Integer);
begin
  Font.Size := aNewSize;
end;

procedure TfrmCoverSheet.OnSetScreenReaderStatus(Sender: TObject; aActive: boolean);
begin
  // Nothing to do here, ICoverSheet is an entry point.
end;

procedure TfrmCoverSheet.DestroyWindowHandle;
begin
  CoverSheet.OnClearPtData(Self);
  inherited;
end;

procedure TfrmCoverSheet.OnClearPtData(Sender: TObject);
begin
  CoverSheet.OnClearPtData(Sender);
  fPatientCount := 0;
end;

procedure TfrmCoverSheet.OnDisplayPage(Sender: TObject; aCallingContext: Integer);
{ cause the page to be displayed and update the display counters }
begin
  CurrentTabPCEObject := nil;
  BringToFront;

  Inc(fDisplayCount);
  Inc(fPatientCount);

  if (aCallingContext = CC_CLICK) and (fPatientCount = 1) then
    fCallingContext := CC_INIT_PATIENT
  else
    fCallingContext := aCallingContext;

  if fDisplayCount = 1 then
    begin
      CoverSheet.OnInitCoverSheet(Self);
      CoverSheet.OnDisplay(Self, gpMain);
    end;

  if fPatientCount = 1 then
    CoverSheet.OnSwitchToPatient(Self, Patient.DFN);

  if ActiveControl <> nil then
    FocusControl(ActiveControl)
  else
    OnFocusFirstControl(Sender);
end;

function TfrmCoverSheet._AddRef: Integer;
begin
  Result := -1;
end;

function TfrmCoverSheet._Release: Integer;
begin
  Result := -1;
end;

initialization

SpecifyFormIsNotADialog(TfrmCoverSheet);

end.
