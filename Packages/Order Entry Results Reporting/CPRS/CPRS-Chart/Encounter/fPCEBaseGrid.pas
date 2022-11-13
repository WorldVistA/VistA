unit fPCEBaseGrid;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fPCEBase, ComCtrls, StdCtrls, ORCtrls, ExtCtrls, Buttons, ORFn, uPCE,
  VA508AccessibilityManager;

type


  TfrmPCEBaseGrid = class(TfrmPCEBase)
    pnlGrid: TPanel;
    lstCaptionList: TCaptionListView;
    procedure lstCaptionListChanging(Sender: TObject; Item: TListItem;
      Change: TItemChange; var AllowChange: Boolean);
  private
    FSel: string;
    function GetGridIndex: integer;
    procedure SetGridIndex(const Value: integer);
  protected
    procedure UpdateControls; virtual;
    procedure SaveGridSelected;
    procedure RestoreGridSelected;
    procedure RemoveGridSelected(Index: integer);
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

  if(lstCaptionList.SelCount > 0) then
  begin
    for i := 0 to lstCaptionList.Items.Count-1 do
      if(lstCaptionList.Items[i].Selected) then
      begin
        Result := i;
        exit;
      end;
  end;
end;

procedure TfrmPCEBaseGrid.lstCaptionListChanging(Sender: TObject;
  Item: TListItem; Change: TItemChange; var AllowChange: Boolean);
begin
  inherited;
  AllowChange := ProcessPostedValidateMag(Self);
end;

procedure TfrmPCEBaseGrid.SetGridIndex(const Value: integer);
var
  i: integer;

begin
  for i := 0 to lstCaptionList.Items.Count-1 do
    lstCaptionList.Items[i].Selected := (i = Value);
  UpdateControls;
end;

procedure TfrmPCEBaseGrid.ClearGrid;
begin
  lstCaptionList.ClearSelection;
  UpdateControls;
end;

procedure TfrmPCEBaseGrid.UpdateControls;
begin
end;

procedure TfrmPCEBaseGrid.RemoveGridSelected(Index: integer);
begin
  Delete(FSel, Index + 1, 1);
end;

procedure TfrmPCEBaseGrid.RestoreGridSelected;
var
  i: integer;

begin
  for I := 0 to lstCaptionList.Items.Count - 1 do
   lstCaptionList.Items[i].Selected :=  (copy(FSel,i+1,1) = BOOLCHAR[TRUE]);
end;

procedure TfrmPCEBaseGrid.SaveGridSelected;
var
  i: integer;
begin
  FSel := '';
  for i := 0 to lstCaptionList.Items.Count-1 do
    FSel := FSel + BOOLCHAR[lstCaptionList.Items[i].Selected];
end;


initialization
  SpecifyFormIsNotADialog(TfrmPCEBaseGrid);

end.
