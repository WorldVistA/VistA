unit fPCEEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ORFn, uPCE, fBase508Form, VA508AccessibilityManager;

type
  TfrmPCEEdit = class(TfrmBase508Form)
    btnNew: TButton;
    btnNote: TButton;
    lblNew: TMemo;
    lblNote: TMemo;
    btnCancel: TButton;
    Label1: TStaticText;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function EditPCEData(NoteData: TPCEData): boolean;

implementation

uses uCore, rCore, fEncnt, fFrame, fEncounterFrame;

{$R *.DFM}

const
  TX_NEED_VISIT2 = 'A visit is required before entering encounter information.';
  TX_NOPCE_TXT1  = 'the encounter date is in the future.';
  TX_NOPCE_TXT2  = 'encounter entry has been disabled.';
  TX_NOPCE_TXT   = 'You can not edit encounter information because ';
  TX_NOPCE_HDR   = 'Can not edit encounter';

var
  uPCETemp: TPCEData;
  uPCETempOld: TPCEData;
  uPatient: string;

function EditPCEData(NoteData: TPCEData): boolean;   // Returns TRUE if NoteData is edited
var
  frmPCEEdit: TfrmPCEEdit;
  BtnTxt, NewTxt, txt: string;
  Ans: integer;

begin
  Result := FALSE;
  (* agp moved from FormCreate to addrss a problem with editing an encounter without a note displaying in CPRS*)
  if uPatient <> Patient.DFN then begin
    FreeAndNil(uPCETemp);
    FreeAndNil(uPCETempOld);
  end;
  uPatient := Patient.DFN;
  if (Encounter.VisitCategory = 'H') then
  begin
    if Assigned(NoteData) then
      Ans := mrNo
    else
    begin
      InfoBox('Can not edit admission encounter', 'Error', MB_OK or MB_ICONERROR);
      Ans := mrCancel;
    end;
  end
  else
  if not Assigned(NoteData) then
    Ans := mrYes
  else
  if (NoteData.VisitString = Encounter.VisitStr) then
    Ans := mrNo
  else
  begin
    frmPCEEdit := TfrmPCEEdit.Create(Application);
    try
      if Encounter.NeedVisit then
      begin
        NewTxt := 'Create New Encounter';
        BtnTxt := 'New Encounter';
      end
      else
      begin
        NewTxt := 'Edit Encounter for ' + Encounter.LocationName + ' on ' +
                  FormatFMDateTime('dddddd hh:nn', Encounter.DateTime);
        BtnTxt := 'Edit Current Encounter';
      end;
      frmPCEEdit.lblNew.Text := NewTxt;
      frmPCEEdit.btnNew.Caption := BtnTxt;
      frmPCEEdit.lblNote.Text := 'Edit Note Encounter for ' + ExternalName(NoteData.Location, 44) + ' on ' +
                  FormatFMDateTime('dddddd hh:nn', NoteData.VisitDateTime);
      ans := frmPCEEdit.ShowModal;
    finally
      frmPCEEdit.Free;
    end;
  end;
  if ans = mrYes then
  begin
    if Encounter.NeedVisit then
    begin
      UpdateVisit(8);
      frmFrame.DisplayEncounterText;
    end;
    if Encounter.NeedVisit then
    begin
      InfoBox(TX_NEED_VISIT2, TX_NO_VISIT, MB_OK or MB_ICONWARNING);
      Exit;
    end;
    if not assigned(uPCETemp) then
      uPCETemp := TPCEData.Create;
    if not CanEditPCE(uPCETemp) then
    begin
      if FutureEncounter(uPCETemp) then
        txt := TX_NOPCE_TXT1
      else
        txt := TX_NOPCE_TXT2;
      InfoBox(TX_NOPCE_TXT + txt, TX_NOPCE_HDR, MB_OK or MB_ICONWARNING);
      Exit;
    end;
    uPCETemp.PCEForNote(USE_CURRENT_VISITSTR, uPCETempOld);
    uPCETemp.UseEncounter := True;
    UpdatePCE(uPCETemp);
    if not assigned(uPCETempOld) then
      uPCETempOld := TPCEData.Create;
    uPCETemp.CopyPCEData(uPCETempOld);
  end
  else
  if ans = mrNo then
  begin
    UpdatePCE(NoteData);
    Result := TRUE;
  end;
end;

initialization
  uPCETemp := nil;
  uPCETempOld := nil;
  uPatient := '';

finalization
  FreeAndNil(uPCETemp);
  FreeAndNil(uPCETempOld);

end.
