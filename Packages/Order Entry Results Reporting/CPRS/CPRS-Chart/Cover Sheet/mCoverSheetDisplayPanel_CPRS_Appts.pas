unit mCoverSheetDisplayPanel_CPRS_Appts;
{
  ================================================================================
  *
  *       Application:  CPRS - Coversheet
  *       Developer:    dan.petit@domain.ext
  *       Site:         Salt Lake City ISC
  *       Date:         2015-12-08
  *
  *       Description:  Customized display panel for appts/visits/admissions.
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
  oDelimitedString;

type
  TfraCoverSheetDisplayPanel_CPRS_Appts = class(TfraCoverSheetDisplayPanel_CPRS)
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
  fraCoverSheetDisplayPanel_CPRS_Appts: TfraCoverSheetDisplayPanel_CPRS_Appts;

implementation

uses
  uCore,
  ORFn,
  ORNet;

{$R *.dfm}

{ TfraCoverSheetDisplayPanel_CPRS_Appts }

constructor TfraCoverSheetDisplayPanel_CPRS_Appts.Create(aOwner: TComponent);
begin
  inherited;
  AddColumn(0, 'Date/Time');
  AddColumn(1, 'Location');
  AddColumn(2, 'Action Req');

  CollapseColumns;
end;

procedure TfraCoverSheetDisplayPanel_CPRS_Appts.OnAddItems(aList: TStrings);
var
  aRec: TDelimitedString;
  aStr: string;
begin
  if aList.Count = 0 then
    aList.Append('^No Visit Data.');

  try
    lvData.Items.BeginUpdate;

    with TDelimitedString.Create(aList[0]) do
      try
        if GetPieceIsNull(1) then
          begin
            CollapseColumns;
            lvData.Items.Add.Caption := 'No Visit Data.';
            Exit;
          end
        else
          ExpandColumns;
      finally
        Free;
      end;

    for aStr in aList do
      begin
        aRec := TDelimitedString.Create(aStr);

        with lvData.Items.Add do
          begin
            if aRec.GetPieceIsNull(1) then
              Caption := aRec.GetPiece(2)
            else
              Caption := FormatDateTime(DT_FORMAT, aRec.GetPieceAsTDateTime(2));
            SubItems.Add(MixedCase(aRec.GetPiece(3)));
            SubItems.Add(MixedCase(aRec.GetPiece(4)));
            Data := aRec;
          end;
      end;
  finally
    lvData.Items.EndUpdate;
  end;
end;

procedure TfraCoverSheetDisplayPanel_CPRS_Appts.OnGetDetail(aRec: TDelimitedString; aResult: TStrings);
begin
  CallVistA(CPRSParams.DetailRPC, [Patient.DFN, '', aRec.GetPiece(1)], aResult);
end;

end.
