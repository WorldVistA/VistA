unit fGMV_RoomSelector;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TfrmRoomSelector = class(TForm)
    Panel1: TPanel;
    pnlCanvas: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    gbRooms: TGroupBox;
    ed: TEdit;
    procedure cbClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmRoomSelector: TfrmRoomSelector;

function getWardRooms(aWard,aList: String):String;

implementation

uses uGMV_Engine, uGMV_Common;

{$R *.dfm}
function getWardRooms(aWard,aList: String):String;
var
  rs : TfrmRoomSelector;
  RetList : TStrings;
  iWidth, iCol, iRow,
  iTop,iLeft,iDeltaV, iDeltaH: Integer;
  i: integer;
  cb: TCheckBox;

begin
  Result := '';
  if aWard = '' then
    ShowMessage('Ward is not defined...');
  if aWard = '' then
    exit;
  if not Assigned(frmRoomSelector) then
    Application.CreateForm(TfrmRoomSelector,frmRoomSelector);
  if not assigned(frmRoomSelector) then Exit;
  rs := frmRoomSelector;

  rs.gbRooms.Caption := 'Ward "'+aWard+'"';

  RetList := getRoomBedByWard(aWard);
  iWidth := 0;
  for i := 0 to RetList.Count - 1 do
    if iWidth < Length(RetList[i]) then
      iWidth := Length(RetList[i]);

  iDeltaH := iWidth * 6 + 24;
  iDeltaV := 24;

  iTop := 24;
  iLeft := 16;

  iCol := 1;
  iRow := 8;

  for i := 1 to RetList.Count do
    begin
      cb := TCheckBox.Create(rs);
      cb.Name := 'cb_' + IntToStr(i);
      cb.Parent := rs.gbRooms;
      cb.Font.Style := [];
      cb.Top := iTop;
      cb.Left := iLeft;
      cb.Caption := piece(RetList[i-1],'^',2);
      cb.Tag := StrToInt(piece(RetList[i-1],'^',1));

      cb.Checked := (pos(' '+cb.Caption+',',aList) > 0) or
        (pos(' '+cb.Caption,aList)+Length(cb.Caption)-1=Length(aList));
      if i mod iRow = 0 then
        begin
          iTop := 24;
          inc(iLeft,iDeltaH);
          inc(iCol);
        end
      else
        inc(iTop,iDeltaV);
      cb.OnClick := rs.cbClick;
      cb.Show;
    end;

  rs.Width := iCol * iDeltaH + 100;

  RetList.Free;

  if rs.ShowModal = mrOK then
    Result := rs.ed.Text;

  FreeAndNil(frmRoomSelector);
end;


procedure TfrmRoomSelector.cbClick(Sender: TObject);
var
  i: Integer;

begin
  ed.Text := '';
  for i := 0 to gbRooms.ControlCount - 1 do
    if gbRooms.Controls[i] is TCheckBox then
      if TCheckBox(gbRooms.Controls[i]).Checked then
        ed.Text := ed.Text + ' '+TCheckBox(gbRooms.Controls[i]).Caption + ',';
end;

end.
