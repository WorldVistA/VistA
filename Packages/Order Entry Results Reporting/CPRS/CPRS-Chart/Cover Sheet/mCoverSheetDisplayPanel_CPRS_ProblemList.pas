unit mCoverSheetDisplayPanel_CPRS_ProblemList;
{
  ================================================================================
  *
  *       Application:  Demo
  *       Developer:    dan.petit@domain.ext
  *       Site:         Salt Lake City ISC
  *       Date:         2015-12-21
  *
  *       Description:  Problem List display panel for CPRS Coversheet.
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
  iCoverSheetIntf,
  mCoverSheetDisplayPanel_CPRS,
  oDelimitedString;

type
  TfraCoverSheetDisplayPanel_CPRS_ProblemList = class(TfraCoverSheetDisplayPanel_CPRS)
  private
    { Private declarations }
  protected
    { Overridden events - TfraCoverSheetDisplayPanel_CPRS }
    procedure OnGetDetail(aRec: TDelimitedString; aResult: TStrings); override;
  public
    constructor Create(aOwner: TComponent); override;
  end;

var
  fraCoverSheetDisplayPanel_CPRS_ProblemList: TfraCoverSheetDisplayPanel_CPRS_ProblemList;

implementation

{$R *.dfm}

{ TfraCoverSheetDisplayPanel_CPRS_ProblemList }

uses
  ORFn;

const
  TX_INACTIVE_ICDCODE = 'The ICD-9-CM code for this problem is inactive.' + CRLF + CRLF +
    'Please correct this code using the ''Problems'' tab.';
  TC_INACTIVE_ICDCODE = 'Inactive ICD-9-CM code';
  TX_INACTIVE_10DCODE = 'The ICD-10-CM code for this problem is inactive.' + CRLF + CRLF +
    'Please correct this code using the ''Problems'' tab.';
  TC_INACTIVE_10DCODE = 'Inactive ICD-10-CM code';
  TX_INACTIVE_SCTCODE = 'The SNOMED CT code for this problem is inactive.' + CRLF + CRLF +
    'Please correct this code using the ''Problems'' tab.';
  TC_INACTIVE_SCTCODE = 'Inactive SNOMED CT code';

constructor TfraCoverSheetDisplayPanel_CPRS_ProblemList.Create(aOwner: TComponent);
begin
  inherited;
  AddColumn(0, 'Problem List');
  CollapseColumns;
end;

procedure TfraCoverSheetDisplayPanel_CPRS_ProblemList.OnGetDetail(aRec: TDelimitedString; aResult: TStrings);
begin
  if aRec.GetPieceEquals(13, '#') then
    if aRec.GetPieceEquals(16, '10D') then
      InfoBox(TX_INACTIVE_10DCODE, TC_INACTIVE_10DCODE, MB_ICONWARNING or MB_OK)
    else
      InfoBox(TX_INACTIVE_ICDCODE, TC_INACTIVE_ICDCODE, MB_ICONWARNING or MB_OK)
  else if aRec.GetPieceEquals(13, '$') then
    InfoBox(TX_INACTIVE_SCTCODE, TC_INACTIVE_SCTCODE, MB_ICONWARNING or MB_OK);

  inherited;
end;

end.
