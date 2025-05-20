unit mCoverSheetDisplayPanel_CPRS_Vitals;
{
  ================================================================================
  *
  *       Application:  CPRS - CoverSheet
  *       Developer:    dan.petit@domain.ext
  *       Site:         Salt Lake City ISC
  *       Date:         2015-12-21
  *
  *       Description:  Vitals display panel for CPRS Coversheet.
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
  TfraCoverSheetDisplayPanel_CPRS_Vitals = class(TfraCoverSheetDisplayPanel_CPRS)
  private
    fSeparator: TMenuItem;
    fUpdateVitals: TMenuItem;
  protected
    { Inherited events - TfraGridPanel }
    procedure OnPopupMenu(Sender: TObject); override;
    procedure OnPopupMenuInit(Sender: TObject); override;
    procedure OnPopupMenuFree(Sender: TObject); override;

    { Inherited events - TfraCoverSheetDisplayPanel_CPRS }
    procedure OnAddItems(aList: TStrings); override;
    procedure OnGetDetail(aRec: TDelimitedString; aDetail: TStrings); override;
    procedure OnShowDetail(aText: TStrings; aTitle: string = ''; aPrintable: boolean = false); override;

    { Introduced Events }
    procedure OnUpdateVitals(Sender: TObject); virtual;
  public
    constructor Create(aOwner: TComponent); override;
  end;

var
  fraCoverSheetDisplayPanel_CPRS_Vitals: TfraCoverSheetDisplayPanel_CPRS_Vitals;

implementation

{$R *.dfm}


uses
  ORFn,
  ORNet,
  rMisc,
  uCore,
  uVitals, uConst, uWriteAccess;

{ TfraCoverSheetDisplayPanel_CPRS_Vitals }

constructor TfraCoverSheetDisplayPanel_CPRS_Vitals.Create(aOwner: TComponent);
begin
  inherited;
  AddColumn(0, 'Vital');
  AddColumn(1, 'Value');
  AddColumn(2, 'Date Taken');
  AddColumn(3, 'Quals');
  CollapseColumns;
end;

procedure TfraCoverSheetDisplayPanel_CPRS_Vitals.OnPopupMenu(Sender: TObject);
begin
  inherited;
  if not WriteAccess(waVitals) then
    exit;
  fUpdateVitals.Enabled := True;
end;

procedure TfraCoverSheetDisplayPanel_CPRS_Vitals.OnPopupMenuFree(Sender: TObject);
begin
  if not WriteAccess(waVitals) then
    exit;
  FreeAndNil(fSeparator);
  FreeAndNil(fUpdateVitals);

  inherited;
end;

procedure TfraCoverSheetDisplayPanel_CPRS_Vitals.OnPopupMenuInit(Sender: TObject);
begin
  inherited;
  if not WriteAccess(waVitals) then
    exit;
  fSeparator := NewLine;
  fUpdateVitals := NewItem('Update Vitals ...', 0, False, True, OnUpdateVitals, 0, 'pmnVitals_UpdateVitals');

  pmn.Items.Add(fSeparator);
  pmn.Items.Add(fUpdateVitals);
end;

procedure TfraCoverSheetDisplayPanel_CPRS_Vitals.OnShowDetail(aText: TStrings;  aTitle: string; aPrintable: boolean);
begin
  // Tricking the UI to go to Vitals Lite when single clicked
  OnUpdateVitals(lvData);
end;

procedure TfraCoverSheetDisplayPanel_CPRS_Vitals.OnUpdateVitals(Sender: TObject);
var
  aVitalsAbbv: string;
  aChangesMade: Boolean;
begin
  if not WriteAccess(waVitals, True) then
    exit;
  lvData.Enabled := false;
  try
  if lvData.Selected <> nil then
    aVitalsAbbv := lvData.Selected.Caption
  else
    aVitalsAbbv := '';

  ViewPatientVitals(RPCBrokerV, Patient, Encounter, aVitalsAbbv, aChangesMade);

  if aChangesMade then
  begin
    CoverSheet.OnRefreshPanel(Self, CV_CPRS_VITL);
    CoverSheet.OnRefreshPanel(Self, CV_CPRS_RMND);
  end;

  finally
    lvData.Enabled := True;
  end;

end;

procedure TfraCoverSheetDisplayPanel_CPRS_Vitals.OnAddItems(aList: TStrings);
var
  aRec: TDelimitedString;
  aData, aQual, aStr: string;
begin
  if aList.Count = 0 then
    aList.Add('^No Vitals Found.');

  try
    lvData.Items.BeginUpdate;
    for aStr in aList do
      begin
        aRec := TDelimitedString.Create(aStr);

        if lvData.Items.Count = 0 then
          if aRec.GetPieceIsNull(1) and (aList.Count = 1) then
            begin
              CollapseColumns;
              exit;
            end;

        with lvData.Items.Add do
          begin
            //Vital
            Caption := aRec.GetPiece(2);
            // Value (Conversion Value)
            SubItems.Add(aRec.GetPiece(5) + ' '+ aRec.GetPiece(6));
            //Date Time
            SubItems.Add(FormatDateTime(DT_FORMAT, aRec.GetPieceAsTDateTime(4)));


//            SubItems.Add(aRec.GetPiece(7));
            aData := aRec.GetPiece(7);
            aQual := aRec.GetPiece(8); // e.g. for POX details are in piece 8
            if Trim(aQual) <> '' then
              aData := aData + ' ' + aQual;
            //Quals
            SubItems.Add(aData);

            Data := aRec;
          end;
      end;
    ExpandColumns;

  finally
    lvData.Items.EndUpdate;
  end;
end;

procedure TfraCoverSheetDisplayPanel_CPRS_Vitals.OnGetDetail(aRec: TDelimitedString; aDetail: TStrings);
var
  aDateTime: TDateTime;
begin
  aDateTime := FMDateTimeToDateTime(aRec.GetPieceAsDouble(4));
  aDetail.Clear;
  aDetail.Add(Format('%s %s', ['Vital ..........', aRec.GetPieceAsString(2)]));
  aDetail.Add(Format('%s %s', ['Date/Time ......', FormatDateTime('MMM DD, YYYY@hh:mm', aDateTime)]));
  aDetail.Add(Format('%s %s', ['Value ..........', aRec.GetPieceAsString(5)]));
  aDetail.Add(Format('%s %s', ['Conv. Value ....', aRec.GetPieceAsString(6)]));
  aDetail.Add(Format('%s %s', ['Qualifiers .....', aRec.GetPieceAsString(7)]));
end;

end.
