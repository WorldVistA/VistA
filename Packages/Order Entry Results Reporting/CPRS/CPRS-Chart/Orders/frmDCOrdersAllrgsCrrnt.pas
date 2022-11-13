unit frmDCOrdersAllrgsCrrnt;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, fBase508Form,
  fAutoSz, StdCtrls, ORFn, ORCtrls, ExtCtrls, ORNet, VA508AccessibilityManager, rMisc;

type
  TfrmDCOrdersAllrgsCrrnt = class(TfrmBase508Form)
    lblAllergies: TLabel;
    Panel1: TPanel;
    lstAlleries: TCaptionListBox;
    Panel2: TPanel;
    cmdYes: TButton;
    cmdNo: TButton;
    mnoVerifyAllrgyDisc: TMemo;
    lblVerifyAllrgyDisc: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure lstAlleriesDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lstAlleriesMeasureItem(Control: TWinControl; Index: Integer;
      var AHeight: Integer);
  private
    function MeasureColumnHeight(TheOrderText: string; Index: Integer):integer;
  public
    existingPatientAllergiesStrLst: TStringList;
  end;

function IsAllergyARRegistrationNeeded: Boolean;
function ExecuteDCAllgryOrders: Integer;

implementation

{$R *.DFM}

////NSR20080226 Ty - added fArtAllgy to uses.
uses rOrders, uCore, uConst, fOrders, fAllgyAR{fArtAllgy},rCover, fOptionsSurrogate;

function ExecuteDCAllgryOrders: Integer; // Boolean;
var
  frmDCOrdersAllrgsCrrnt: TfrmDCOrdersAllrgsCrrnt;
begin
  frmDCOrdersAllrgsCrrnt := TfrmDCOrdersAllrgsCrrnt.Create(Application);
  try
    Result := frmDCOrdersAllrgsCrrnt.ShowModal;
  finally
    frmDCOrdersAllrgsCrrnt.Free;
  end;
end;

function IsAllergyARRegistrationNeeded: Boolean;
begin
  Result := ExecuteDCAllgryOrders = mrYes;
end;

procedure TfrmDCOrdersAllrgsCrrnt.FormCreate(Sender: TObject);
var
  existingPatientAllergiesStrLst: TStringList;
  I: Integer;
  AllergiesStrLst: TStringList;
  AllergyStr, Temp: String;
const
  NO_KNOWN_ALLERGIES = 'No Known Allergies';
begin
  inherited;
  existingPatientAllergiesStrLst := nil;
  AllergiesStrLst := nil;
  try
    existingPatientAllergiesStrLst := TStringList.Create;
    AllergiesStrLst := TStringList.Create;
    // Used as a place hold or parsing drug name
    ListAllergies(existingPatientAllergiesStrLst);
    lstAlleries.Sorted := true;
    for I := 0 to existingPatientAllergiesStrLst.count - 1 do
    begin
      if (Piece(existingPatientAllergiesStrLst.Strings[0], U, 1) = '') and
        (Piece(existingPatientAllergiesStrLst.Strings[0], U, 2) <>
        NO_KNOWN_ALLERGIES) then
      begin
        lstAlleries.items.add(NO_KNOWN_ALLERGIES);
      end
      else
      begin
        // if POS('^',existingPatientAllergiesStrLst.Strings[i]) > 0 then
        // frmOptionsSurrogate.SplitAString('^',existingPatientAllergiesStrLst.Strings[i],AllergiesStrLst);

        // ************** CODE WAS MODIFIED 05/05/2015 by KCH for NSR #20080226  **************************/
        Temp := Trim(Piece(existingPatientAllergiesStrLst.Strings[I], '^', 3));
        if Temp <> '' then
          Temp := '  [SEVERITY:' + Temp + ']';
        Temp := Temp + '  ';

        AllergyStr := Piece(existingPatientAllergiesStrLst.Strings[I], '^', 2) +
          Temp + Piece(existingPatientAllergiesStrLst.Strings[I], '^', 4);

        lstAlleries.items.add(AllergyStr);
      end;
    end;
  finally
    existingPatientAllergiesStrLst.Free;
    AllergiesStrLst.Free;
  end;
end;

procedure TfrmDCOrdersAllrgsCrrnt.lstAlleriesDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  x: string;
  ARect: TRect;
begin
  inherited;
  x := '';
  ARect := Rect;
  with lstAlleries do
  begin
   if Index < Items.Count then
    begin
      x := Items[Index];
      DrawText(Canvas.handle, PChar(x), Length(x), ARect, DT_LEFT or DT_NOPREFIX or DT_WORDBREAK);
    end;
  end;
end;

procedure TfrmDCOrdersAllrgsCrrnt.lstAlleriesMeasureItem(Control: TWinControl;
  Index: Integer; var AHeight: Integer);
var
  x:string;
begin
  inherited;
  with lstAlleries do if Index < Items.Count then
  begin
    x := Items[index];
    AHeight := MeasureColumnHeight(x, Index);
  end;
end;

function TfrmDCOrdersAllrgsCrrnt.MeasureColumnHeight(TheOrderText: string;
  Index: Integer): integer;
var
  ARect: TRect;
begin
  ARect.Left := 0;
  ARect.Top := 0;
  ARect.Bottom := 0;
  ARect.Right := lstAlleries.Width - 6;
  Result := WrappedTextHeightByFont(lstAlleries.Canvas,lstAlleries.Font,TheOrderText,ARect);
end;

end.
