unit mCoverSheetDisplayPanel_CPRS_Immunizations;
{
  ================================================================================
  *
  *       Application:  Demo
  *       Developer:    doma.user@domain.ext
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
  iCoverSheetIntf;

type
  TfraCoverSheetDisplayPanel_CPRS_Immunizations = class(TfraCoverSheetDisplayPanel_CPRS)
  private
    { Private declarations }
  protected
    { Overidden events - TfraCoverSheetDisplayPanel_CPRS }
    procedure OnAddItems(aList: TStrings); override;
  public
    constructor Create(aOwner: TComponent); override;
  end;

var
  fraCoverSheetDisplayPanel_CPRS_Immunizations: TfraCoverSheetDisplayPanel_CPRS_Immunizations;

implementation

{$R *.dfm}


uses
  ORFn,
  oDelimitedString;

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

end.
