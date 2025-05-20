unit mCoverSheetDisplayPanel_CPRS_Immunizations;
{
  ================================================================================
  *
  *       Application:  Demo
  *       Developer:    dan.petit@domain.ext
  *       Site:         Salt Lake City ISC
  *       Date:         2015-12-21
  *
  *       Description:  Coversheet panel for immunizations.
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
  System.Variants,
  System.Classes,
  System.ImageList,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.Menus,
  Vcl.ImgList,
  Vcl.ComCtrls,
  Vcl.StdCtrls,
  Vcl.Buttons,
  mCoverSheetDisplayPanel_CPRS,
  iCoverSheetIntf,
  fFrame;

type
  TfraCoverSheetDisplayPanel_CPRS_Immunizations = class(TfraCoverSheetDisplayPanel_CPRS)
  private
    { Private declarations }
    fEnterImmunization: TMenuItem;
    procedure pmnEnterNewImmunization(Sender: TObject);
  protected
    { Overidden events - TfraCoverSheetDisplayPanel_CPRS }
    procedure OnAddItems(aList: TStrings); override;
    procedure OnPopupMenu(Sender: TObject); override;
    procedure OnPopupMenuFree(Sender: TObject); override;
    procedure OnPopupMenuInit(Sender: TObject); override;
  public
    constructor Create(aOwner: TComponent); override;
  end;

var
  fraCoverSheetDisplayPanel_CPRS_Immunizations: TfraCoverSheetDisplayPanel_CPRS_Immunizations;

implementation

{$R *.dfm}


uses
  ORFn,
  oDelimitedString,
  uCore,
  fEncnt,
  fVimm,
  rVimm,
  fNotes,
  uPDMP, uConst, uWriteAccess;

{ TfraCoverSheetDisplayPanel_CPRS_Immunizations }

constructor TfraCoverSheetDisplayPanel_CPRS_Immunizations.Create(aOwner: TComponent);
begin
  inherited;
  AddColumn(0, 'Immunization');
  AddColumn(1, 'Reaction');
  AddColumn(2, 'Date/Time');
  CollapseColumns;
  fAllowDetailDisplay := False;
end;

procedure TfraCoverSheetDisplayPanel_CPRS_Immunizations.OnAddItems(aList: TStrings);
var
  aRec: TDelimitedString;
  aStr: string;
begin
  try
    lvData.Items.BeginUpdate;

    for aStr in aList do
      begin
        aRec := TDelimitedString.Create(aStr);

        if lvData.Items.Count = 0 then { Executes before any item is added }
          if aRec.GetPieceIsNull(1) and (aList.Count = 1) then
            CollapseColumns
          else
            ExpandColumns;

        with lvData.Items.Add do
          begin
            Caption := MixedCase(aRec.GetPiece(2));
            if aRec.GetPiece(1) <> '' then
              begin
                SubItems.Add(MixedCase(aRec.GetPiece(4)));
                SubItems.Add(aRec.GetPieceAsFMDateTimeStr(3));
              end;
            Data := aRec;
          end;
      end;
  finally
    lvData.Items.EndUpdate;
  end;
end;

procedure TfraCoverSheetDisplayPanel_CPRS_Immunizations.OnPopupMenu(
  Sender: TObject);
begin
  inherited;
  if not WriteAccess(waImmunization) then exit;
  fEnterImmunization.enabled := true;
end;

procedure TfraCoverSheetDisplayPanel_CPRS_Immunizations.OnPopupMenuFree(
  Sender: TObject);
begin
  inherited;
  if not WriteAccess(waImmunization) then exit;
  FreeAndNil(fEnterImmunization);
end;

procedure TfraCoverSheetDisplayPanel_CPRS_Immunizations.OnPopupMenuInit(
  Sender: TObject);
begin
  inherited;
  if not WriteAccess(waImmunization) then exit;
  fEnterImmunization := NewItem('Enter New Immunization ...', 0, False, False,
    pmnEnterNewImmunization, 0, 'pmnEnterNewImmunization');
  pmn.Items.Add(NewItem('-', 0, False, False, nil, 0, 'pmnImmunization_Separator'));
  pmn.Items.Add(fEnterImmunization);
end;

procedure TfraCoverSheetDisplayPanel_CPRS_Immunizations.pmnEnterNewImmunization(
  Sender: TObject);
var
resultList: TStringList;
noteStr: String;
Reason: string;

begin
  if assigned(frmNotes) then
    begin
      frmNotes.currentlyEditingRecord(Reason);
      if reason <> '' then
        begin
          ShowMessage(reason);
          exit;
        end;
    end;
  try
    if Encounter.NeedVisit then
      UpdateEncounter(0, 0, 0);
      frmFrame.DisplayEncounterText;
  finally

  end;
  resultList := TStringList.create;
  try
  uvimmInputs.noGrid := false;
  uvimmInputs.makeNote := true;
  uvimmInputs.collapseICE := false;
  uvimminputs.canSaveData := true;
  uvimmInputs.patientName := patient.Name;
  uvimmInputs.patientIEN := patient.DFN;
  uvimmInputs.userName := user.Name;
  uvimmInputs.userIEN := user.DUZ;
  uvimmInputs.encounterProviderName := encounter.ProviderName;
  uvimmInputs.encounterProviderIEN := encounter.Provider;
  uvimmInputs.encounterLocation := encounter.Location;
  uvimmInputs.encounterCategory := encounter.VisitCategory;
  uvimmInputs.dateEncounterDateTime := encounter.DateTime;
  uvimmInputs.visitString := encounter.VisitStr;
  uvimmInputs.startInEditMode := true;
//  uvimmInputs.isFromEncounter := false;
  uvimmInputs.isSkinTest := false;
  uVimmInputs.immunizationReading := false;
  uVimmInputs.selectionType := 'all';
  uVimmInputs.fromCover := true;

  if performVimm(resultList, true) then
    begin
      CoverSheet.OnRefreshPanel(Self, CV_CPRS_IMMU);
//      frmNotes.Refresh;
    end;
  clearInputs;
  if resultList.Count = 1 then
    begin
      noteStr := resultList.Strings[0];
      Changes.Add(CH_DOC, Piece(noteStr, U, 1), Piece(noteStr, U, 2), '', CH_SIGN_YES);
      PostMessage(Application.MainForm.Handle, UM_PDMP_NOTE_ID, 0, 0);
    end;
  finally
    FreeAndNil(resultList);
  end;
end;

end.
