unit mCoverSheetDisplayPanel_CPRS_Labs;
{
  ================================================================================
  *
  *       Application:  Demo
  *       Developer:    dan.petit@domain.ext
  *       Site:         Salt Lake City ISC
  *       Date:         2015-12-21
  *
  *       Description:  Lab result panel for CPRS Coversheet.
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
  TfraCoverSheetDisplayPanel_CPRS_Labs = class(TfraCoverSheetDisplayPanel_CPRS)
  private
    { Private declarations }
  protected
    { Overridded events - TfraCoverSheetDisplayPanel_CPRS }
    procedure OnAddItems(aList: TStrings); override;
    procedure OnGetDetail(aRec: TDelimitedString; aResult: TStrings); override;
  public
    constructor Create(aOwner: TComponent); override;
  end;

var
  fraCoverSheetDisplayPanel_CPRS_Labs: TfraCoverSheetDisplayPanel_CPRS_Labs;

implementation

uses
  uCore,
  ORFn,
  ORNet;

{$R *.dfm}

{ TfraCoverSheetDisplayPanel_CPRS_Labs }

constructor TfraCoverSheetDisplayPanel_CPRS_Labs.Create(aOwner: TComponent);
begin
  inherited;
  AddColumn(0, 'Lab Test');
  AddColumn(1, 'Date/Time');
  CollapseColumns;
end;

procedure TfraCoverSheetDisplayPanel_CPRS_Labs.OnGetDetail(aRec: TDelimitedString; aResult: TStrings);
var
  aID: string;
begin
  aID := aRec.GetPiece(1);

  if aID = '' then
    Exit;

  if Copy(aRec.GetPiece(1), 1, 2) = '0;' then
    Exit;

  if StrToFloatDef(Copy(aID, 1, Pos(';', aID) - 1), -1) < 1 then
    Exit;

  CallVistA(CPRSParams.DetailRPC, [Patient.DFN, aRec.GetPieceAsInteger(1), aRec.GetPiece(1)], aResult);
end;

procedure TfraCoverSheetDisplayPanel_CPRS_Labs.OnAddItems(aList: TStrings);
var
  aRec: TDelimitedString;
  aStr: string;
begin
  lvData.Items.BeginUpdate;
  try
    for aStr in aList do
    begin
      aRec := TDelimitedString.Create(aStr);
      try
        if lvData.Items.Count = 0 then { Executes before any item is added }
          if aRec.GetPieceEquals(1, 0) and (aList.Count = 1) then
          begin
            CollapseColumns;
            lvData.Items.Add.Caption := aRec.GetPiece(2);
            Break;
          end
          else if aRec.GetPieceIsNull(1) and (aList.Count = 1) then
            CollapseColumns
          else
            ExpandColumns;

        with lvData.Items.Add do
        begin
          Caption := MixedCase(aRec.GetPiece(2));
          if aRec.GetPieceIsNotNull(1) then
          begin
            SubItems.Add(FormatDateTime(DT_FORMAT,
              aRec.GetPieceAsTDateTime(3)));
            Data := aRec;
            aRec := nil;
          end;
        end;
      finally
        if assigned(aRec) then
          aRec.Free;
      end;
    end;
  finally
    lvData.Items.EndUpdate;
  end;
end;

end.
