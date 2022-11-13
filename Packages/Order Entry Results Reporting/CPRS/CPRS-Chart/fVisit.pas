unit fVisit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ORCtrls, ORDtTm, ORFn, StdCtrls, rCore, uCore, fBase508Form,
  VA508AccessibilityManager;

type
  TfrmVisit = class(TfrmBase508Form)
    pnlBase: TORAutoPanel;
    lblInstruct: TStaticText;
    radAppt: TRadioButton;
    radAdmit: TRadioButton;
    radNewVisit: TRadioButton;
    lstVisit: TORListBox;
    lblSelect: TLabel;
    pnlVisit: TORAutoPanel;
    cboLocation: TORComboBox;
    timVisitDate: TORDateBox;
    lblVisitDate: TLabel;
    cmdOK: TButton;
    cmdCancel: TButton;
    grpCategory: TGroupBox;
    ckbHistorical: TCheckBox;
    procedure radSelectorClick(Sender: TObject);
    procedure cboLocationNeedData(Sender: TObject; const StartFrom: string;
      Direction, InsertAt: Integer);
    procedure cmdCancelClick(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FChanged: Boolean;
    FDateTime: TFMDateTime;
    FLocation: Integer;
    FLocationName: string;
    FVisitCategory: Char;
    FStandAlone: Boolean;
  public
    { Public declarations }
  end;

(*
procedure SelectVisit(FontSize: Integer; var VisitUpdate: TVisitUpdate);
procedure UpdateVisit(FontSize: Integer);
*)

implementation

{$R *.DFM}

uses
  rOptions;

const
  TAG_SEL_CLINIC = 1;
  TAG_SEL_ADMIT  = 2;
  TAG_SEL_NEW    = 3;

type
  TVisitUpdate = record
    Changed: Boolean;
    DateTime: TFMDateTime;
    Location: Integer;
    LocationName: string;
    VisitCategory: Char;
    StandAlone: Boolean;
  end;

(*
procedure UpdateVisit(FontSize: Integer);
{ displays visit selection form and directly updates the visit in Encounter }
var
  VisitUpdate: TVisitUpdate;
begin
  SelectVisit(FontSize, VisitUpdate);
  if VisitUpdate.Changed then
  begin
    Encounter.Location  := VisitUpdate.Location;
    Encounter.DateTime  := VisitUpdate.DateTime;
    Encounter.VisitCategory := VisitUpdate.VisitCategory;
    Encounter.StandAlone := VisitUpdate.StandAlone;
  end;
end;

procedure SelectVisit(FontSize: Integer; var VisitUpdate: TVisitUpdate);
{ displays visit selection form and returns a record of the updated information }
var
  frmVisit: TfrmVisit;
  W, H: Integer;
begin
  frmVisit := TfrmVisit.Create(Application);
  try
    with frmVisit do
    begin
      Font.Size := FontSize;
      lblInstruct.Font.Size := FontSize;
      W := ClientWidth;
      H := ClientHeight;
      ResizeToFont(FontSize, W, H);
      ClientWidth  := W; pnlBase.Width  := W;
      ClientHeight := H; pnlBase.Height := W;
      frmVisit.ShowModal;
      with VisitUpdate do
      begin
        Changed := FChanged;
        DateTime := FDateTime;
        Location := FLocation;
        LocationName := FLocationName;
        VisitCategory := FVisitCategory;
        StandAlone := FStandAlone;
      end; {with VisitRec}
    end; {with frmVisit}
  finally
    frmVisit.Release;
  end;
end;
*)

procedure TfrmVisit.FormCreate(Sender: TObject);
{ initialize private fields and display appropriate visit selection controls }
begin
  FChanged := False;
  radSelectorClick(radAppt);
  if lstVisit.Items.Count = 0 then
  begin
    radNewVisit.Checked := True;
    radSelectorClick(radNewVisit);
  end;
end;

procedure TfrmVisit.radSelectorClick(Sender: TObject);
{ change visit data entry according to the radiobutton selected (appts, admissions, new visit }
var
  i: Integer;
  ADateFrom, ADateThru: TDateTime;
  BDateFrom, BDateThru: Integer;
begin
  if not TRadioButton(Sender).Checked then Exit;
  lstVisit.Clear;
  lblVisitDate.Hide;
  case TRadioButton(Sender).Tag of
    TAG_SEL_CLINIC: begin
                      lblSelect.Caption := 'Clinic Appointments';
                      rpcGetRangeForEncs(BDateFrom, BDateThru, False); // Get user's current date range settings.
                      ADateFrom := (FMDateTimeToDateTime(FMToday) - BDateFrom);
                      ADateThru := (FMDateTimeToDateTime(FMToday) + BDateThru);
                      ADateFrom := DateTimeToFMDateTime(ADateFrom);
                      ADateThru:= DateTimeToFMDateTime(ADateThru) + 0.2359;
                      ListApptAll(lstVisit.Items, Patient.DFN, ADateFrom, ADateThru);
                      pnlVisit.Hide;
                      lstVisit.Show;
                    end;
    TAG_SEL_ADMIT:  begin
                      lblSelect.Caption := 'Hospital Admissions';
                      ListAdmitAll(lstVisit.Items, Patient.DFN);
                      pnlVisit.Hide;
                      lstVisit.Show;
                    end;
    TAG_SEL_NEW:    begin
                      lblSelect.Caption := 'Visit Location';
                      with cboLocation do
                      begin
                        InitLongList(Encounter.LocationName);
                        for i := 0 to Items.Count - 1 do
                          if StrToIntDef(Piece(Items[i], U, 1),0) = Encounter.Location then
                          begin
                            ItemIndex := i;
                            break;
                          end;
                      end;
                      lstVisit.Hide;
                      lblVisitDate.Show;
                      pnlVisit.Show;
                    end;
  end;
  lstVisit.Caption := lblSelect.Caption;
end;

procedure TfrmVisit.cboLocationNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
{ callback for location combobox to list active locations }
var
  sl: TStrings;
begin
  sl := TStringList.Create;
  try
    setSubSetOfClinics(sl, StartFrom, Direction);
    cboLocation.ForDataUse(sl);
  finally
    sl.Free;
  end;
end;

procedure TfrmVisit.cmdOKClick(Sender: TObject);
{ gather and validate visit information }
const
  VST_CAPTION  = 'Unable to Select Visit';
  VST_LOCATION = 'A visit LOCATION has not been selected.';
  VST_DATETIME = 'A valid date/time has not been entered.';
  VST_NOTIME   = 'A valid time has not been entered.';
  VST_SELECT   = 'An appointment/hospitalization has not been entered';
begin
  FStandAlone := False;
  if radNewVisit.Checked then
  begin
    if cboLocation.ItemIndex < 0 then
    begin
      InfoBox(VST_LOCATION, VST_CAPTION, MB_OK);
      Exit;
    end;
    FDateTime := StrToFMDateTime(timVisitDate.Text);
    if not (FDateTime > 0) then
    begin
      InfoBox(VST_DATETIME, VST_CAPTION, MB_OK);
      Exit;
    end;
    if(pos('.',FloatToStr(FDateTime))=0) then
    begin
      InfoBox(VST_NOTIME, VST_CAPTION, MB_OK);
      Exit;
    end;
    with cboLocation do
    begin
      FLocation := ItemIEN;
      FLocationName := DisplayText[ItemIndex];
    end;

    //Changed 12/30/97 ISL/RAB
    if ckbHistorical.state = cbchecked then FVisitCategory := 'E'
    else FVisitCategory := 'A';

    FChanged := True;

    //ISL/RAB  1/15/98  The following line has been changed so procedures will
    //         not be required for historical visits.
    if (FVisitCategory = 'A') then FStandAlone := True;
  end else
  begin
    if lstVisit.ItemIndex < 0 then
    begin
      InfoBox(VST_SELECT, VST_CAPTION, MB_OK);
      Exit;
    end;
    with lstVisit do
    begin
      FDateTime := MakeFMDateTime(ItemID);
      FLocation := StrToIntDef(Piece(Items[ItemIndex], U, 2), 0);
      FLocationName := Piece(Items[ItemIndex], U, 3);
      if(radAdmit.Checked) then
        FVisitCategory := 'H'
      else
        FVisitCategory := 'A';
      FChanged := True;
    end;
  end;
  Close;
end;

procedure TfrmVisit.cmdCancelClick(Sender: TObject);
{ cancel form - no change to visit information }
begin
  FChanged := False;
  Close;
end;

end.
