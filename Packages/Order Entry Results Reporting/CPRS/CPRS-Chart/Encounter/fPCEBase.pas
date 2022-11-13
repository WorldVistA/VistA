{///////////////////////////////////////////////////////////////////////////////
//Name: fPCEBase.pas, fPCEBase.dfm
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description: Parent form for all PCE tabs.  This form will hold methods that are
// universal for a PCE tabs.  These forms will be child forms to fEncounterFrame.
////////////////////////////////////////////////////////////////////////////////}

unit fPCEBase;

{$OPTIMIZATION OFF}                              // REMOVE AFTER UNIT IS DEBUGGED

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls, uConst,
  StdCtrls, fAutoSz, Buttons, ORCtrls, ORFn, uPCE, ORDtTm, Checklst,
  ComCtrls, VA508AccessibilityManager, fBase508Form;

type
  TfrmPCEBase = class(TfrmAutoSz)
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject); virtual;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCancelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    FDisplayCount: Integer;                      // number of times page displayed
    FPatientCount: Integer;                      // number of times page displayed for given pt
    FCallingContext: Integer;
//    function GetInitPage: Boolean;
//    function GetInitPatient: Boolean;
//    function GetPatientViewed: Boolean;
    procedure UMResizePage(var Message: TMessage); message UM_RESIZEPAGE;
  protected
    FClosing: boolean;
    FSectionTabs: array[0..2] of Integer;
    FSectionTabCount: integer;
    FTabName: string;
//    procedure CreateParams(var Params: TCreateParams); override;
    function ActiveCtrl: TWinControl;
    function SectionString: string;
    procedure DoEnter; override;
  public
    constructor CreateLinked(AParent: TWinControl);
    procedure Loaded; override;
//    function AllowContextChange: Boolean; virtual;
//    procedure ClearPtData; virtual;
    procedure DisplayPage; virtual;
//    procedure NotifyOrder(OrderAction: Integer; AnOrder: TOrder); virtual;  //*no ordering will be done*//
//    procedure RequestPrint; virtual;
    procedure SetFontSize(NewFontSize: Integer); virtual;
    procedure AllowTabChange(var AllowChange: boolean); virtual;

    property CallingContext: Integer read FCallingContext;
//    property InitPage: Boolean read GetInitPage;
//    property InitPatient: Boolean read GetInitPatient;
//    property PatientViewed: Boolean read GetPatientViewed;
    procedure FocusFirstControl;
  end;

var
  frmPCEBase: TfrmPCEBase;

implementation

{$R *.DFM}

uses
  fEncounterFrame, VA508AccessibilityRouter, VAUtils;


{///////////////////////////////////////////////////////////////////////////////
//Name: procedure TfrmPCEBase.FormCreate(Sender: TObject);
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description: Initialize counters to zero
///////////////////////////////////////////////////////////////////////////////}
procedure TfrmPCEBase.FormCreate(Sender: TObject);
begin
  FDisplayCount := 0;
  FPatientCount := 0;
end;

{///////////////////////////////////////////////////////////////////////////////
//Name: procedure TfrmPCEBase.CreateParams(var Params: TCreateParams);
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description: turn the form into a child window
///////////////////////////////////////////////////////////////////////////////}
(*procedure TfrmPCEBase.CreateParams(var Params: TCreateParams);
{ turn the form into a child window }
begin
  inherited CreateParams(Params);
  with Params do
  begin
    if Owner is TPanel
      then WndParent := TPanel(Owner).Handle
    else if owner is TForm then
      WndParent := (Owner as TForm).Handle;
    Style := WS_CHILD or WS_CLIPSIBLINGS;
    X := 0; Y := 0;
  end;
end;
 *)
{///////////////////////////////////////////////////////////////////////////////
//Name: procedure TfrmPCEBase.Loaded;
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description: make the form borderless to allow it to be a child window
///////////////////////////////////////////////////////////////////////////////}
procedure TfrmPCEBase.Loaded;
begin
  inherited Loaded;
  Visible := False;
  Position := poDefault;
  BorderIcons := [];
  BorderStyle := bsNone;
  HandleNeeded;
  SetBounds(0, 0, Width, Height);
end;

{///////////////////////////////////////////////////////////////////////////////
//Name: function TfrmPCEBase.AllowContextChange: Boolean;
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description:
///////////////////////////////////////////////////////////////////////////////}
(*function TfrmPCEBase.AllowContextChange: Boolean;
begin
  Result := True;
end;

{///////////////////////////////////////////////////////////////////////////////
//Name: procedure TfrmPCEBase.ClearPtData;
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description: clear all patient related data on a page
///////////////////////////////////////////////////////////////////////////////}
procedure TfrmPCEBase.ClearPtData;
begin
  FPatientCount := 0;
end;
*)
{///////////////////////////////////////////////////////////////////////////////
//Name: procedure TfrmPCEBase.DisplayPage;
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description: cause the page to be displayed and update the display counters
///////////////////////////////////////////////////////////////////////////////}
procedure TfrmPCEBase.DisplayPage;
begin
  BringToFront;
//  FocusControl(ActiveCtrl);
  //SetFocus;
  Inc(FDisplayCount);
  Inc(FPatientCount);
  FCallingContext := frmEncounterFrame.ChangeSource;
  if (FCallingContext = CC_CLICK) and (FPatientCount = 1)
    then FCallingContext := CC_INIT_PATIENT;
end;
(*
{///////////////////////////////////////////////////////////////////////////////
//Name: procedure TfrmPCEBase.RequestPrint;
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description: For posible future use when printing is supported.
///////////////////////////////////////////////////////////////////////////////}
procedure TfrmPCEBase.RequestPrint;
begin
  //
end;
*)

{///////////////////////////////////////////////////////////////////////////////
//Name: procedure TfrmPCEBase.SetFontSize(NewFontSize: Integer);
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description: Assign the new font size.
///////////////////////////////////////////////////////////////////////////////}
procedure TfrmPCEBase.SetFontSize(NewFontSize: Integer);
begin
  Font.Size := NewFontSize;
end;
(*
{///////////////////////////////////////////////////////////////////////////////
//Name: function TfrmPCEBase.GetInitPage: Boolean;
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description: if the count is one, this is the first time the page is being displayed.
///////////////////////////////////////////////////////////////////////////////}
function TfrmPCEBase.GetInitPage: Boolean;
begin
  Result := FDisplayCount = 1;
end;

{///////////////////////////////////////////////////////////////////////////////
//Name: function TfrmPCEBase.GetInitPatient: Boolean;
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description: if the count is one, this is the first time the page is being
// displayed for a given patient
///////////////////////////////////////////////////////////////////////////////}
function TfrmPCEBase.GetInitPatient: Boolean;
begin
  Result := FPatientCount = 1;
end;

{///////////////////////////////////////////////////////////////////////////////
//Name: function TfrmPCEBase.GetPatientViewed: Boolean;
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description: returns false if the tab has never been clicked for this patient
///////////////////////////////////////////////////////////////////////////////}
function TfrmPCEBase.GetPatientViewed: Boolean;
begin
  Result := FPatientCount > 0;
end;
*)
(*
procedure RepaintControl(AControl: TControl);
var
  i: Integer;
begin
  AControl.Invalidate;
  AControl.Update;
  if AControl is TWinControl then with TWinControl(AControl) do
    for i := 0 to ControlCount - 1 do RepaintControl(Controls[i]);
end;
*)

{///////////////////////////////////////////////////////////////////////////////
//Name: procedure TfrmPCEBase.UMResizePage(var Message: TMessage);
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description: Redraw the controls on the form when it is resized.
///////////////////////////////////////////////////////////////////////////////}
procedure TfrmPCEBase.UMResizePage(var Message: TMessage);
var
  i: Integer;
begin
  for i := 0 to ComponentCount - 1 do
    if Components[i] is TControl then with TControl(Components[i]) do Invalidate;
  Update;
end;

{///////////////////////////////////////////////////////////////////////////////
//Name: procedure TfrmPCEBase.btnCancelClick(Sender: TObject);
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description: Indicate to the frame that cancel was pressed, and close the frame.
///////////////////////////////////////////////////////////////////////////////}
procedure TfrmPCEBase.btnCancelClick(Sender: TObject);
begin
  inherited;
  ClearPostValidateMag(Self);
  frmencounterframe.Abort := FALSE;
  frmEncounterFrame.Cancel := true;
  frmencounterframe.Close;
end;

procedure TfrmPCEBase.btnCancelMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Button = mbLeft then
    ClearPostValidateMag(Self);
end;

{///////////////////////////////////////////////////////////////////////////////
//Name: procedure TfrmPCEBase.btnCancelClick(Sender: TObject);
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description: Indicate to the frame that it should close and save data.
///////////////////////////////////////////////////////////////////////////////}
procedure TfrmPCEBase.btnOKClick(Sender: TObject);
begin
  frmencounterframe.Abort := FALSE;
  frmencounterframe.Close;
end;


{///////////////////////////////////////////////////////////////////////////////
//Name: procedure TfrmPCEBase.FormClose(Sender: TObject; var Action: TCloseAction);
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description: Free the memory held by the form.
///////////////////////////////////////////////////////////////////////////////}
procedure TfrmPCEBase.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  action := caFree;    //destroy the forms when closed
  FClosing := TRUE;
end;

{///////////////////////////////////////////////////////////////////////////////
//Name: procedure TfrmPCEBase.CheckListDrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
//  State: TOwnerDrawState);
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description: Populate the checklist
///////////////////////////////////////////////////////////////////////////////}
procedure TfrmPCEBase.AllowTabChange(var AllowChange: boolean);
begin
end;

constructor TfrmPCEBase.CreateLinked(AParent: TWinControl);
begin
  inherited Create(GetParentForm(AParent));
  Parent := AParent;
  Align := alClient;
  Show;
// Do NOT remove this Hide statement - it compensates for bugs in the VCL
// where adding multiple client-aligned forms to the same parent shrank each
// form, cascading to the point where forms became very tiny - which caused
// exceptions in some of the FormResize events.  While you would think this
// was normal behavior it didn't happen in Delphi XE8, and when it started
// happening in Delphi 10.3 it couldn't be turned off with DisableAlign on the
// parent form.  Hiding each form after creation was the only work-around.
  Hide;
end;

function TfrmPCEBase.ActiveCtrl: TWinControl;
begin
  Result := GetParentForm(Self).ActiveControl;
  if(Result is TORComboEdit) then
    Result := TWinControl(Result.Owner);
end;

function TfrmPCEBase.SectionString: string;
var
  v, i: integer;

begin
  Result := '';
  if FSectionTabCount = 0 then exit;
  v := 0;
  for i := 0 to FSectionTabCount-1 do
  begin
    if(Result <> '') then
      Result := Result + ',';
    Result := Result + IntToStr(FSectionTabs[i]);
    v := FSectionTabs[i];
  end;
  for i := 1 to 20 do
  begin
    if(v<0) then
      dec(v,32)
    else
      inc(v,32);
    if Result <> '' then Result := Result + ',';
    Result := Result + inttostr(v);
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
  FindNextControl(self, True, True, False).SetFocus;
end;

initialization
  SpecifyFormIsNotADialog(TfrmPCEBase);


end.
