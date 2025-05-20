unit mCoverSheetDisplayPanel_CPRS_Allergies;
{
  ================================================================================
  *
  *       Application:  CPRS - Coversheet
  *       Developer:    dan.petit@domain.ext
  *       Site:         Salt Lake City ISC
  *       Date:         2015-12-21
  *
  *       Description:  Display panel for Allergies.
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
  System.UITypes,
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
  oDelimitedString;

type
  TfraCoverSheetDisplayPanel_CPRS_Allergies = class(TfraCoverSheetDisplayPanel_CPRS)
  private
    { Private declarations }
    fSeparator: TMenuItem;
    fEnterNewAllergy: TMenuItem;
    fMarkSelectedAsEnteredInError: TMenuItem;
    fMarkPtAsNKA: TMenuItem;
    procedure pmnEnterNewAllergy(Sender: TObject);
    procedure pmnMarkSelectedAsEnteredInError(Sender: TObject);
    procedure pmnMarkPtAsNKA(Sender: TObject);
  protected
    { Overridden events - TfraGridPanel }
    procedure OnPopupMenu(Sender: TObject); override;
    procedure OnPopupMenuInit(Sender: TObject); override;
    procedure OnPopupMenuFree(Sender: TObject); override;

    { Overridden events - TfraCoverSheetDisplayPanel_CPRS }
    procedure OnAddItems(aList: TStrings); override;
    procedure OnGetDetail(aRec: TDelimitedString; aResult: TStrings); override;
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  fraCoverSheetDisplayPanel_CPRS_Allergies: TfraCoverSheetDisplayPanel_CPRS_Allergies;

implementation

{ TfraCoverSheetDisplayPanel_CPRS_Allergies }

uses
  uCore,
  rODAllergy,
  fAllgyAR,
  ORFn,
  ORNet, uWriteAccess;

const
  NO_ASSESSMENT = 'No Allergy Assessment';

{$R *.dfm}


constructor TfraCoverSheetDisplayPanel_CPRS_Allergies.Create(aOwner: TComponent);
begin
  inherited;
  AddColumn(0, 'Agent');
  AddColumn(1, 'Severity');
  AddColumn(2, 'Signs/Symptoms');
  CollapseColumns;
end;

destructor TfraCoverSheetDisplayPanel_CPRS_Allergies.Destroy;
begin

  inherited;
end;

procedure TfraCoverSheetDisplayPanel_CPRS_Allergies.pmnEnterNewAllergy(Sender: TObject);
begin
  if EnterEditAllergy(0, True, False) then
    begin
      CoverSheet.OnRefreshPanel(Self, CV_CPRS_ALLG);
      CoverSheet.OnRefreshPanel(Self, CV_CPRS_POST);
      CoverSheet.OnRefreshCWAD(Self);
    end;
end;

procedure TfraCoverSheetDisplayPanel_CPRS_Allergies.pmnMarkPtAsNKA(Sender: TObject);
begin
  if EnterNKAForPatient then
    begin
      CoverSheet.OnRefreshPanel(Self, CV_CPRS_ALLG);
      CoverSheet.OnRefreshPanel(Self, CV_CPRS_POST);
      CoverSheet.OnRefreshCWAD(Self);
    end;
end;

procedure TfraCoverSheetDisplayPanel_CPRS_Allergies.pmnMarkSelectedAsEnteredInError(Sender: TObject);
begin
  if lvData.Selected <> nil then
    if lvData.Selected.Data <> nil then
      with TDelimitedString(lvData.Selected.Data) do
        if GetPieceAsInteger(1) > 0 then
          if EnterEditAllergy(GetPieceAsInteger(1), False, True) then
            begin
              CoverSheet.OnRefreshPanel(Self, CV_CPRS_ALLG);
              CoverSheet.OnRefreshPanel(Self, CV_CPRS_POST);
              CoverSheet.OnRefreshCWAD(Sender);
            end;
end;

procedure TfraCoverSheetDisplayPanel_CPRS_Allergies.OnAddItems(aList: TStrings);
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
          if aRec.GetPieceIsNull(1) then
            CollapseColumns
          else
            ExpandColumns;

        with lvData.Items.Add do
          begin
            Caption := MixedCase(aRec.GetPiece(2));
            SubItems.Add(MixedCase(aRec.GetPiece(3)));
            SubItems.Add(MixedCase(aRec.GetPiece(4)));
            Data := aRec;
          end;
      end;
  finally
    lvData.Items.EndUpdate;
  end;
end;

procedure TfraCoverSheetDisplayPanel_CPRS_Allergies.OnGetDetail(aRec: TDelimitedString; aResult: TStrings);
begin
  CallVistA(CPRSParams.DetailRPC, [Patient.DFN, aRec.GetPiece(1)], aResult);
end;

procedure TfraCoverSheetDisplayPanel_CPRS_Allergies.OnPopupMenu(Sender: TObject);
var
  aRec: TDelimitedString;
  aMsg: string;
begin
  inherited;
  if not WriteAccess(waAllergies) then exit;
  fEnterNewAllergy.Enabled := True;
  fMarkSelectedAsEnteredInError.Enabled := False;
  fMarkPtAsNKA.Enabled := False;

  { Edge case for Mark as NKA and nothing selected and no assessment }
  if lvData.Items.Count = 1 then
    if lvData.Items[0].Data <> nil then
      begin
        aRec := TDelimitedString(lvData.Items[0].Data);
        fMarkPtAsNKA.Enabled := aRec.GetPieceEquals(2, NO_ASSESSMENT);
      end;

  if lvData.Selected <> nil then
    if lvData.Selected.Data <> nil then
      begin
        aRec := TDelimitedString(lvData.Selected.Data);
        if aRec.GetPieceIsNotNull(1) and IsARTClinicalUser(aMsg) then
          begin
            fMarkSelectedAsEnteredInError.Enabled := True;
          end
        else if lvData.Selected.Index = 0 then
          fMarkPtAsNKA.Enabled := aRec.GetPieceEquals(2, NO_ASSESSMENT);
      end;
end;

procedure TfraCoverSheetDisplayPanel_CPRS_Allergies.OnPopupMenuFree(Sender: TObject);
begin
  if not WriteAccess(waAllergies) then exit;
  FreeAndNil(fSeparator);
  FreeAndNil(fEnterNewAllergy);
  FreeAndNil(fMarkSelectedAsEnteredInError);
  FreeAndNil(fMarkPtAsNKA);

  inherited;
end;

procedure TfraCoverSheetDisplayPanel_CPRS_Allergies.OnPopupMenuInit
  (Sender: TObject);
begin
  inherited;
  if not WriteAccess(waAllergies) then exit;
  fSeparator := NewLine;
  fEnterNewAllergy := NewItem('Enter New Allergy/Adverse Reaction...', 0, False,
    False, pmnEnterNewAllergy, 0, 'pmnEnterNewAllergy');
  fMarkSelectedAsEnteredInError :=
    NewItem('Mark Selected Allergy as Entered in Error ...', 0, False, False,
    pmnMarkSelectedAsEnteredInError, 0,
    'pmnMarkSelectedAllergyAsEnteredInError');
  fMarkPtAsNKA :=
    NewItem('Mark Patient As Having "No Known Allergies" (NKA) ...', 0, False,
    False, pmnMarkPtAsNKA, 0, 'pmnPtAsNKA');

  pmn.Items.Add(fSeparator);
  pmn.Items.Add(fEnterNewAllergy);
  pmn.Items.Add(fMarkSelectedAsEnteredInError);
  pmn.Items.Add(fMarkPtAsNKA);
end;

end.
