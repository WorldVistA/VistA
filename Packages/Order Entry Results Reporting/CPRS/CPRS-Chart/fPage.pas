unit fPage;

{$OPTIMIZATION OFF}                              // REMOVE AFTER UNIT IS DEBUGGED

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls, uConst,
  rOrders, fBase508Form, VA508AccessibilityManager;

type
  TfrmPage = class(TfrmBase508Form)
    shpPageBottom: TShape;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FDisplayCount: Integer;                      // number of times page displayed
    FPatientCount: Integer;                      // number of times page displayed for given pt
    FCallingContext: Integer;
    FOldEnter: TNotifyEvent;
    FPageID: integer;
    function GetInitPage: Boolean;
    function GetInitPatient: Boolean;
    function GetPatientViewed: Boolean;
  protected
    procedure Loaded; override;
    procedure frmPageEnter(Sender: TObject);
  public
    function AllowContextChange(var WhyNot: string): Boolean; virtual;
    procedure ClearPtData; virtual;
    procedure DisplayPage; virtual;
    procedure NotifyOrder(OrderAction: Integer; AnOrder: TOrder); virtual;
    procedure RequestPrint; virtual;
    procedure SetFontSize(NewFontSize: Integer); virtual;
    procedure FocusFirstControl;
    property CallingContext: Integer read FCallingContext;
    property InitPage: Boolean read GetInitPage;
    property InitPatient: Boolean read GetInitPatient;
    property PatientViewed: Boolean read GetPatientViewed;
    property PageID: integer read FPageID write FPageID default CT_UNKNOWN;
  end;

var
  frmPage: TfrmPage;

implementation

uses ORFn, fFrame, uInit, VA508AccessibilityRouter, VAUtils, uPCE;

{$R *.DFM}

procedure TfrmPage.FormCreate(Sender: TObject);
{ set counters to 0 }
begin
 // HelpFile := Application.HelpFile + '>' + HelpFile;
  FDisplayCount := 0;
  FPatientCount := 0;
  FOldEnter := OnEnter;
  OnEnter := frmPageEnter;
end;

procedure TfrmPage.Loaded;
{ make the form borderless to allow it to be a child window }
begin
  inherited Loaded;
  Visible := False;
  Position := poDefault;
  BorderIcons := [];
  BorderStyle := bsNone;
  HandleNeeded;
  SetBounds(0, 0, Width, Height);
end;

function TfrmPage.AllowContextChange(var WhyNot: string): Boolean;
begin
  Result := True;
end;

procedure TfrmPage.ClearPtData;
{ clear all patient related data on a page }
begin
  FPatientCount := 0;
end;

procedure TfrmPage.DisplayPage;
{ cause the page to be displayed and update the display counters }
begin
  CurrentTabPCEObject := nil;
  BringToFront;
  if ActiveControl <> nil then
    FocusControl(ActiveControl);
 //CQ12232 else
//CQ12232   FocusFirstControl;
  //SetFocus;
  Inc(FDisplayCount);
  Inc(FPatientCount);
  FCallingContext := frmFrame.ChangeSource;
  if (FCallingContext = CC_CLICK) and (FPatientCount = 1)
    then FCallingContext := CC_INIT_PATIENT;
end;

procedure TfrmPage.NotifyOrder(OrderAction: Integer; AnOrder: TOrder);
begin
end;

procedure TfrmPage.RequestPrint;
begin
end;

procedure TfrmPage.SetFontSize(NewFontSize: Integer);
begin
  ResizeAnchoredFormToFont( self );
  if Assigned(Parent) then begin
    Width := Parent.ClientWidth;
    Height := Parent.ClientHeight;
  end;
  Resize;
end;

function TfrmPage.GetInitPage: Boolean;
{ if the count is one, this is the first time the page is being displayed }
begin
  Result := FDisplayCount = 1;
end;

function TfrmPage.GetInitPatient: Boolean;
{ if the count is one, this is the first time the page is being displayed for a given patient }
begin
  Result := FPatientCount = 1;
end;

function TfrmPage.GetPatientViewed: Boolean;
{ returns false if the tab has never been clicked for this patient }
begin
  Result := FPatientCount > 0;
end;

procedure TfrmPage.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmPage.frmPageEnter(Sender: TObject);
begin
  if Assigned(frmFrame) then
    FrmFrame.tabPage.TabIndex := FrmFrame.PageIDToTab(PageID);
  if Assigned(FOldEnter) then
    FOldEnter(Sender);
end;

procedure TfrmPage.FocusFirstControl;
var
  NextControl: TWinControl;
begin
  if Assigned(frmFrame) and frmFrame.Enabled and frmFrame.Visible and not uInit.Timedout then begin
    NextControl := FindNextControl(nil, True, True, False);
    if NextControl <> nil then
      NextControl.SetFocus;
  end;
end;

initialization
  SpecifyFormIsNotADialog(TfrmPage);

end.
