unit fGMV_SelectColor;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ComCtrls,
  ImgList,
  StdCtrls,
  ExtCtrls, System.ImageList;

type
  TfrmGMV_SelectColor = class(TForm)
    ilColors: TImageList;
    Panel1: TPanel;
    lvColors: TListView;
    procedure FormCreate(Sender: TObject);
    procedure lvColorsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure lvColorsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lvColorsDblClick(Sender: TObject);
  private
    FSelectedColor: Integer;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmGMV_SelectColor: TfrmGMV_SelectColor;
  ilSelectColors: TImageList;

function SelectColor(Ctrl: TControl; var iColor: Integer): Boolean;

implementation

uses uGMV_Const, system.Types;

{$R *.DFM}

function SelectColor(Ctrl: TControl; var iColor: Integer): Boolean;
var
  pt: TPoint;
begin
  Result := False;
  if not Assigned(frmGMV_SelectColor) then
    Application.CreateForm(TfrmGMV_SelectColor, frmGMV_SelectColor);

  with frmGMV_SelectColor do
    begin
      pt := Ctrl.Parent.ClientToScreen(Point(Ctrl.Left, Ctrl.Top));
      Left := pt.x;
      Top := pt.y + Ctrl.Height;
      FSelectedColor := iColor;
      if (iColor > -1) and (iColor < lvColors.Items.Count) then
        begin
          lvColors.Items[iColor].Selected := True;
          lvColors.Selected := lvColors.Items[iColor];
        end;
      ShowModal;
      if ModalResult = mrOk then
        begin
          iColor := FSelectedColor;
          Result := True;
        end;
    end;
end;

procedure TfrmGMV_SelectColor.FormCreate(Sender: TObject);
var
  i: integer;
begin
  lvColors.SmallImages := ilColors;
  for i := 0 to ilColors.Count - 1 do
    with lvColors.Items.Add do
      begin
        Caption := DISPLAYNAMES[i];
        ImageIndex := i;
      end;
end;

procedure TfrmGMV_SelectColor.lvColorsSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  FSelectedColor := Item.ImageIndex;
end;

procedure TfrmGMV_SelectColor.lvColorsKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    ModalResult := mrCancel;
  if Key = VK_RETURN then
    ModalResult := mrOk;
end;

procedure TfrmGMV_SelectColor.lvColorsDblClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

end.
