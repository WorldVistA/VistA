unit fPCEBaseGrid;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fPCEBase, ComCtrls, StdCtrls, ORCtrls, ExtCtrls, Buttons, ORFn, uPCE,
  VA508AccessibilityManager;

type
  TfrmPCEBaseGrid = class(TfrmPCEBase)
    pnlGrid: TPanel;
    lbGrid: TORListBox;
    hcGrid: THeaderControl;
    procedure FormCreate(Sender: TObject);
    procedure hcGridSectionResize(HeaderControl: THeaderControl;
      Section: THeaderSection);
    procedure pnlGridResize(Sender: TObject);
  private
    FSel: string;
    FGridHeaderSyncing: boolean;
    function GetGridIndex: integer;
    procedure SetGridIndex(const Value: integer);
  protected
    FSectionGap: integer;
    procedure UpdateControls; virtual;
    procedure SaveGridSelected;
    procedure RestoreGridSelected;
  public
    procedure SyncGridHeader(FromHeader: boolean);
    procedure SyncGridData;
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

procedure TfrmPCEBaseGrid.FormCreate(Sender: TObject);
begin
  inherited;
  FixHeaderControlDelphi2006Bug(hcGrid);
  FSectionGap := 15;
  SyncGridHeader(TRUE);
end;

procedure TfrmPCEBaseGrid.SyncGridHeader(FromHeader: boolean);
var
  i, w, wd, wp, Gap: integer;
  txt: string;

begin
  if(not FGridHeaderSyncing) then
  begin
    Gap := JustificationGap;
    FGridHeaderSyncing := TRUE;
    try
      if(FromHeader) then
      begin
        txt := '';
        w := 0;
        for i := 0 to hcGrid.Sections.Count-2 do
        begin
          if(i > 0) then
            txt := txt + ',';
          inc(w,(hcGrid.Sections[i].Width div 2)*2);
          txt := txt + IntToStr(w + Gap);
          Gap := 0;
        end;
        lbGrid.TabPositions := txt;
      end
      else
      begin
        txt := lbGrid.TabPositions;
        wd := 0;
        for i := 0 to hcGrid.Sections.Count-2 do
        begin
          wp := StrToIntDef(Piece(txt,',',i+1),hcGrid.Sections[i].MinWidth);
          w := wp - wd;
          hcGrid.Sections[i].Width := w - Gap;
          Gap := 0;
          wd := wp;
        end;
      end;
      w := 0;
      for i := 0 to hcGrid.Sections.Count-2 do
        inc(w,hcGrid.Sections[i].Width);
      hcGrid.Sections[hcGrid.Sections.Count-1].Width := pnlGrid.Width - w;
    finally
      FGridHeaderSyncing := FALSE;
    end;
  end;
end;

procedure TfrmPCEBaseGrid.hcGridSectionResize(
  HeaderControl: THeaderControl; Section: THeaderSection);
begin
  inherited;
  SyncGridHeader(TRUE);
end;

procedure TfrmPCEBaseGrid.pnlGridResize(Sender: TObject);
begin
  inherited;
  SyncGridHeader(TRUE);
end;

procedure TfrmPCEBaseGrid.SyncGridData;
var
  tp, ltp, i, j, tlen: integer;
  max: array[0..9] of integer; // more than 10 header sections will cause this to explode
  tmp: string;

begin
  if(lbGrid.Items.Count > 0) then
  begin
    for j := 0 to hcGrid.Sections.Count-2 do max[j] := 0;
    for i := 0 to lbGrid.Items.Count-1 do
    begin
      tmp := lbGrid.Items[i];
      for j := 0 to hcGrid.Sections.Count-2 do
      begin
        tlen := Canvas.TextWidth(Piece(tmp,U,j+1)) + FSectionGap;
        if(max[j] < tlen) then
          max[j] := tlen;
      end;
    end;
    ltp := 0;
    tmp := lbGrid.TabPositions;
    for i := 0 to hcGrid.Sections.Count-2 do
    begin
      if(max[i] < hcGrid.Sections[i].MinWidth) then
        max[i] := hcGrid.Sections[i].MinWidth;
      tp := StrToIntDef(Piece(tmp,',',i+1),0);
      tlen := tp - ltp;
      ltp := tp;
      if(max[i] < tlen) then
        max[i] := tlen;
    end;
    for i := 1 to hcGrid.Sections.Count-2 do
      inc(max[i], max[i-1]);
    tmp := '';
    for i := 0 to hcGrid.Sections.Count-2 do
      tmp := tmp + ',' + inttostr(max[i]);
    delete(tmp,1,1);
    if(lbGrid.TabPositions <> tmp) then
    begin
      SaveGridSelected;
      lbGrid.TabPositions := tmp;
      RestoreGridSelected;
    end;
    SyncGridHeader(FALSE);
  end;
end;

function TfrmPCEBaseGrid.GetGridIndex: integer;
var
  i: integer;

begin
  Result := -1;
  if(lbGrid.SelCount > 0) then
  begin
    for i := 0 to lbGrid.Items.Count-1 do
      if(lbGrid.Selected[i]) then
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
  for i := 0 to lbGrid.Items.Count-1 do
    lbGrid.Selected[i] := (i = Value);
  UpdateControls;
end;

procedure TfrmPCEBaseGrid.ClearGrid;
var
  i: integer;

begin
  if lbGrid.SelCount > 0 then
  begin
    for i := 0 to lbGrid.Items.Count-1 do
      lbGrid.Selected[i] := FALSE;
  end;
  UpdateControls;
end;

procedure TfrmPCEBaseGrid.UpdateControls;
begin
end;

procedure TfrmPCEBaseGrid.RestoreGridSelected;
var
  i: integer;

begin
  for i := 0 to lbGrid.Items.Count-1 do
    lbGrid.Selected[i] := (copy(FSel,i+1,1) = BOOLCHAR[TRUE]);
end;

procedure TfrmPCEBaseGrid.SaveGridSelected;
var
  i: integer;
begin
  FSel := '';
  for i := 0 to lbGrid.Items.Count-1 do
    FSel := FSel + BOOLCHAR[lbGrid.Selected[i]];
end;

initialization
  SpecifyFormIsNotADialog(TfrmPCEBaseGrid);

end.
