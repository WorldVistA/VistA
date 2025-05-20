unit mCoverSheetDisplayPanel_CPRS_ActiveMeds;
{
  ================================================================================
  *
  *       Application:  CPRS
  *       Developer:    dan.petit@domain.ext
  *       Site:         Salt Lake City ISC
  *       Date:         2015-12-04
  *
  *       Description:  Inherited frame for custom handling of the Active Meds.
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
  oDelimitedString,
  iCoverSheetIntf;

type
  TfraCoverSheetDisplayPanel_CPRS_ActiveMeds = class(TfraCoverSheetDisplayPanel_CPRS)
  private
    { Private declarations }
  protected
    { Overridden events - TfraCoverSheetDisplayPanel_CPRS }
    procedure OnAddItems(aList: TStrings); override;
    procedure OnGetDetail(aRec: TDelimitedString; aResult: TStrings); override;
  public
    constructor Create(aOwner: TComponent); override;
    { Public declarations }
  end;

var
  fraCoverSheetDisplayPanel_CPRS_ActiveMeds: TfraCoverSheetDisplayPanel_CPRS_ActiveMeds;

implementation

uses
  rMeds,
  uCore,
  ORFn,
  ORNet;

{$R *.dfm}

{ TfraCoverSheetDisplayPanel_CPRS_ActiveMeds }

constructor TfraCoverSheetDisplayPanel_CPRS_ActiveMeds.Create(aOwner: TComponent);
begin
  inherited;
  AddColumn(0, 'Medication');
  AddColumn(1, 'Status');
  CollapseColumns;
end;

procedure TfraCoverSheetDisplayPanel_CPRS_ActiveMeds.OnAddItems(aList: TStrings);
var
  aRec: TDelimitedString;
  aStr: string;
  aActiveMeds: TStringList;
begin
  lvData.Items.BeginUpdate;
  try
    ClearListView(lvData);
 //   lvData.Items.Clear;

    aActiveMeds := TStringList.Create;
    try
      ExtractActiveMeds(aActiveMeds, aList);

      for aStr in aActiveMeds do
        begin
          aRec := TDelimitedString.Create(aStr);

          if lvData.Items.Count = 0 then
            if aRec.GetPieceEquals(1, '0') and (aList.Count = 1) then
              CollapseColumns
            else
              ExpandColumns;

          with lvData.Items.Add do
            begin
              Caption := MixedCase(aRec.GetPiece(2));
              SubItems.Add(MixedCase(aRec.GetPiece(4)));
              Data := aRec;
            end;
        end;
    finally
      FreeAndNil(aActiveMeds);
    end;
  finally
    lvData.Items.EndUpdate;
  end;
end;

procedure TfraCoverSheetDisplayPanel_CPRS_ActiveMeds.OnGetDetail(aRec: TDelimitedString; aResult: TStrings);
begin
  CallVistA(CPRSParams.DetailRPC, [Patient.DFN, aRec.GetPiece(1)], aResult);
end;

end.
