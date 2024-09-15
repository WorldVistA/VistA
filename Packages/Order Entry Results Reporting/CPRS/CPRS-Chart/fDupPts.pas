unit fDupPts;
{------------------------------------------------------------------------------
Update History

    2016-02-25: NSR#20110606 (Similar Provider/Cosigner names)
-------------------------------------------------------------------------------}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ORCtrls, ExtCtrls, OrFn, OrNet, fBase508Form,
  VA508AccessibilityManager, Vcl.ComCtrls
  , uSimilarNames
  ;

type
  TfrmDupPts = class(TfrmBase508Form)
    pnlDupPts: TPanel;
    pnlSelDupPt: TPanel;
    Panel1: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    lboSelPt: TCaptionListView;
    pnlHeader: TPanel;
    lblSelDupPts: TLabel;
    Panel2: TPanel;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure lboSelPtDblClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure lboSelPtCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
  private
    { Private declarations }
    fItemName: String;
    fExceptions: TStrings;
    function ValidateExceptions:Boolean;
  public
    { Public declarations }
    Constructor CreateSelector(ASelector:TSelector; aList:TStrings; anExceptions:TStrings = nil);
end;

implementation

{$R *.dfm}

uses
  rCore, uCore, System.UITypes;

constructor TfrmDupPts.CreateSelector(ASelector:TSelector; aList:TStrings; anExceptions:TStrings = nil);
const
  fmtCaptionWindow = 'Similar %ss';
  fmtCaptionList = '  Please select the correct %s:';
var
  I: integer;
  S: string;
  ANeedLocation: Boolean;
begin
  inherited Create(Application);
  fExceptions := anExceptions;

  case ASelector of
    sPr : fItemName := 'provider';
    sCo : fItemName := 'cosigner';
    sPt : fItemName := 'patient';
  end;
  pnlHeader.Caption := Format(fmtCaptionList,[fItemName]);
  lboSelPt.Caption := Format('Please select the correct %s', [fItemName]);
  fItemName := uppercase(copy(fItemName,1,1))+copy(fItemName,2,Length(fItemName));
  Caption := Format(fmtCaptionWindow,[fItemName]);

  if ASelector <> sPt then
  begin
    lboSelPt.Columns[1].Caption := 'Position';
    lboSelPt.Columns[1].Width := lboSelPt.Width - lboSelPt.Columns[0]
      .Width - 24;
    for I := lboSelPt.Columns.Count - 1 downto 2 do
      lboSelPt.Columns.Delete(I);
  end else begin
    ANeedLocation := False;
    for S in AList do
    begin
      ANeedLocation := Piece(S, U, 5) <> '';
      if ANeedLocation then
        Break;
    end;
    if ANeedLocation then
    begin
      lboSelPt.Pieces := '2,3,4,5,6,7,8';
    end else begin
      lboSelPt.Columns[4].Width := lboSelPt.Columns[3].Width +
        lboSelPt.Columns[4].Width;
      lboSelPt.Columns.Delete(3);
      lboSelPt.Pieces := '2,3,4,6,7,8';
    end;
  end;

  if Assigned(aList) then
    FastAssign(aList, lboSelPt.ItemsStrings);

  ResizeAnchoredFormToFont(self);
end;

procedure TfrmDupPts.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  inherited;
  if ModalResult <> mrCancel then
  begin
    CanClose := Length(lboSelPt.ItemID) > 0;
    if not CanClose then
      InfoBox(' A ' + fItemName + ' has not been selected', 'No '+fItemName + ' Selected', MB_OK or MB_ICONWARNING);
    if CanClose then
      CanClose := ValidateExceptions;
  end;
end;

procedure TfrmDupPts.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (key = VK_ESCAPE) then
    ModalResult := mrCancel;
end;

procedure TfrmDupPts.lboSelPtCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  sID:String;
begin
  inherited;
  if assigned(Item) then
    begin
      sID := lboSelPt.ItemsStrings[Item.Index];
      sID := Piece(sID,U,1)+ U;
      if assigned(fExceptions) and (pos(sID,fExceptions.Text)> 0) then
        lboSelPt.Canvas.Font.Color := clHighlight
      else
        lboSelPt.Canvas.Font.Color := clWindowText;
    end
end;

procedure TfrmDupPts.lboSelPtDblClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

function TfrmDupPts.ValidateExceptions: Boolean;
var
  i: Integer;
const
  msgRecordAlreadyAdded = 'This Record is already added to the Selection List'+CRLF+
          'Please select another Record or Cancel the selection';
begin
  Result := True;
  if not assigned(fExceptions) then
    exit;
  for i := 0 to fExceptions.Count -1 do
    if (Piece(fExceptions[i],U,1) = lboSelPt.ItemID) then
      begin
        Result := False;
        InfoBox(msgRecordAlreadyAdded,'Duplicate item detected', MB_OK or MB_ICONWARNING);
        break;
      end;
end;

end.
