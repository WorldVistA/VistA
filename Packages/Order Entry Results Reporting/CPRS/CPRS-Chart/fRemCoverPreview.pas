unit fRemCoverPreview;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, fBase508Form, VA508AccessibilityManager,
  ORExtensions;

type
  TfrmRemCoverPreview = class(TfrmBase508Form)
    pnlBtns: TPanel;
    btnOK: TButton;
    lvMain: ORExtensions.TListView;
    procedure FormCreate(Sender: TObject);
    procedure lvMainColumnClick(Sender: TObject; Column: TListColumn);
    procedure lvMainCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
  private
    FSortCol: integer;
    FSortUp: boolean;
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TfrmRemCoverPreview.FormCreate(Sender: TObject);
begin
  FSortCol := 2;
  FSortUp := TRUE;
end;

procedure TfrmRemCoverPreview.lvMainColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  if FSortCol <> Column.Tag then
    FSortCol := Column.Tag
  else
    FSortUp := not FSortUp;
  lvMain.CustomSort(nil, 0);
end;

procedure TfrmRemCoverPreview.lvMainCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
var
  i: integer;
  odr: array[1..2] of integer;
  s1, s2: string;

begin
  case FSortCol of
    1: begin
         odr[1] := 1;
         odr[2] := 2;
       end;

    2: begin
         odr[1] := 2;
         odr[2] := 1;
       end;
  end;
  Compare := 0;
  for i := 1 to 2 do
  begin
    case odr[i] of
      1:   begin
             s1 := Item1.Caption;
             s2 := Item2.Caption;
           end;

      2:   begin
             s1 := Item1.SubItems[1];
             s2 := Item2.SubItems[1];
           end;
    end;
    Compare := CompareText(s1, s2);
    if Compare <> 0 then break;
  end;
  if not FSortUp then
    Compare := -Compare;
end;

end.
