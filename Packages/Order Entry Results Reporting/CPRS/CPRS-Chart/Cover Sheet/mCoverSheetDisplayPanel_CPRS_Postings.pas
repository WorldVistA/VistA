unit mCoverSheetDisplayPanel_CPRS_Postings;
{
  ================================================================================
  *
  *       Application:  Demo
  *       Developer:    dan.petit@domain.ext
  *       Site:         Salt Lake City ISC
  *       Date:         2015-12-21
  *
  *       Description:  Panel for Postings Display on CPRS Coversheet.
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
  oDelimitedString;

type
  TfraCoverSheetDisplayPanel_CPRS_Postings = class(TfraCoverSheetDisplayPanel_CPRS)
  private
    { Private declarations }
  protected
    { Overridden events - TfraCoverSheetDisplayPanel_CPRS }
    procedure OnAddItems(aList: TStrings); override;
    procedure OnGetDetail(aRec: TDelimitedString; aResult: TStrings); override;
  public
    constructor Create(aOwner: TComponent); override;
  end;

var
  fraCoverSheetDisplayPanel_CPRS_Postings: TfraCoverSheetDisplayPanel_CPRS_Postings;

implementation

{$R *.dfm}

{ TfraCoverSheetDisplayPanel_CPRS_Postings }

uses
  uConst,
  uCore,
  ORFn,
  ORNet, iCoverSheetIntf;

constructor TfraCoverSheetDisplayPanel_CPRS_Postings.Create(aOwner: TComponent);
begin
  inherited;
  AddColumn(0, 'Posting');
  AddColumn(1, 'Date');
  CollapseColumns;
end;

procedure TfraCoverSheetDisplayPanel_CPRS_Postings.OnAddItems(aList: TStrings);
var
  aListItem: TListItem;
begin
  inherited;
  { Update the ALLERGIES item to have an identifier of 'A' if it exists }
  try
    lvData.Items.BeginUpdate;
    for aListItem in lvData.Items do
    begin
      if aListItem.Data <> nil then
        if TDelimitedString(aListItem.Data).GetPieceEquals(2, 'ALLERGIES') then
          TDelimitedString(aListItem.Data).SetPiece(1, 'A')
        else if (TDelimitedString(aListItem.Data).GetPiece(3) <> '') and
          (TDelimitedString(aListItem.Data).GetPieceAsDouble(3,0.0) > 0.0) then
          aListItem.SubItems.Add(FormatDateTime(DT_FORMAT,
              TDelimitedString(aListItem.Data).GetPieceAsTDateTime(3)));
    end;
    ExpandColumns;
  finally
    lvData.Items.EndUpdate;
  end;
end;

procedure TfraCoverSheetDisplayPanel_CPRS_Postings.OnGetDetail(aRec: TDelimitedString; aResult: TStrings);
begin

  if aRec.GetPieceEquals(1, 'A') then
    CallVistA('ORQQAL LIST REPORT', [Patient.DFN], aResult)
  else if aRec.GetPieceEquals(1, 'WH') then
    CallVistA('WVRPCOR POSTREP', [Patient.DFN, aRec.GetPiece(3)], aResult)
  else if aRec.GetPieceIsNotNull(1) then
    begin
      NotifyOtherApps(NAE_REPORT, 'TUI^' + aRec.GetPiece(1));
      CallVistA('TIU GET RECORD TEXT', [aRec.GetPiece(1)], aResult);
    end
  else
    aResult.Text := 'Invalid Detail Item';
end;

end.
