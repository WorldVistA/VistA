unit fPCEBaseGrid;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fPCEBase, ComCtrls, StdCtrls, ORCtrls, ExtCtrls, Buttons, ORFn, uPCE,
  VA508AccessibilityManager;

type


  TfrmPCEBaseGrid = class(TfrmPCEBase)
    pnlGrid: TPanel;
    lstRenameMe: TCaptionListView;
  private
    FSel: string;
    function GetGridIndex: integer;
    procedure SetGridIndex(const Value: integer);
  protected
    procedure UpdateControls; virtual;
    procedure SaveGridSelected;
    procedure RestoreGridSelected;
  public
    procedure ClearGrid;
    property GridIndex: integer read GetGridIndex write SetGridIndex;
  end;

var
  frmPCEBaseGrid: TfrmPCEBaseGrid;

implementation

uses
  VA2006Utils, VA508AccessibilityRouter;

{$R *.DFM}

const
  JustificationGap = 5;


function TfrmPCEBaseGrid.GetGridIndex: integer;
var
  i: integer;

begin
  Result := -1;

  if(lstRenameMe.SelCount > 0) then
  begin
    for i := 0 to lstRenameMe.Items.Count-1 do
      if(lstRenameMe.Items[i].Selected) then
      begin
        Result := i;
        exit;
      end;
  end;
end;

procedure TfrmPCEBaseGrid.SetGridIndex(const Value: integer);
var
  i: integer;

begin
  for i := 0 to lstRenameMe.Items.Count-1 do
    lstRenameMe.Items[i].Selected := (i = Value);
  UpdateControls;
end;

procedure TfrmPCEBaseGrid.ClearGrid;
begin
  lstRenameMe.ClearSelection;
  UpdateControls;
end;

procedure TfrmPCEBaseGrid.UpdateControls;
begin
end;

procedure TfrmPCEBaseGrid.RestoreGridSelected;
var
  i: integer;

begin
  for I := 0 to lstRenameMe.Items.Count - 1 do
   lstRenameMe.Items[i].Selected :=  (copy(FSel,i+1,1) = BOOLCHAR[TRUE]);
end;

procedure TfrmPCEBaseGrid.SaveGridSelected;
var
  i: integer;
begin
  FSel := '';
  for i := 0 to lstRenameMe.Items.Count-1 do
    FSel := FSel + BOOLCHAR[lstRenameMe.Items[i].Selected];
end;


initialization
  SpecifyFormIsNotADialog(TfrmPCEBaseGrid);

end.
