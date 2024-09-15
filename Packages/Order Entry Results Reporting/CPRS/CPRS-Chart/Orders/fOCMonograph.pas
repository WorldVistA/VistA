unit fOCMonograph;
{------------------------------------------------------------------------------
Update History

    2016-09-20: NSR#20101203 (Critical/Hight Order Check Display)
-------------------------------------------------------------------------------}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ORFn, ORCtrls, rOrders, VA508AccessibilityManager, ExtCtrls,
  fBase508Form;

type
  TfrmOCMonograph = class(TfrmBase508Form)
    monoCmbLst: TComboBox;
    monoMemo: TCaptionMemo;
    cmdOK: TButton;
    VA508StaticText1: TVA508StaticText;
    VA508StaticText2: TVA508StaticText;
    VA508ComponentAccessibility1: TVA508ComponentAccessibility;
    pnlBottom: TPanel;
    pnlTop: TPanel;
    pnlCanvas: TPanel;
    procedure DisplayMonograph;
    procedure monoCmbLstChange(Sender: TObject);
    procedure VA508ComponentAccessibility1CaptionQuery(Sender: TObject;
      var Text: string);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    mList: TStringList;  // AA: tmp reference on the list of monographs.
                         // Object itself is released in calling module
  public
    { Public declarations }
    procedure setupByMList(aList:TStringList);
  end;

procedure ShowMonographs(monoList: TStringList); overload;

implementation

{$R *.dfm}

procedure ShowMonographs(monoList: TStringList);
var
  frm: TfrmOCMonograph;
begin
  if monoList.Count > 0 then
  begin
    frm := TfrmOCMonograph.Create(Application);
    try
      ResizeFormToFont(frm);
      frm.setupByMList(monoList);
      frm.ShowModal;
    finally
      frm.Free;
    end;
  end;
end;

procedure TfrmOCMonograph.setupByMList(aList:TStringList);
var
  i: Integer;
begin
  if not Assigned(aList) then
    exit;
  if aList.Count < 1 then
    exit;

  mList := aList;

  for i := 0 to aList.Count - 1 do
    monoCmbLst.Items.Add(Piece(aList[i], U, 2));

  monoCmbLst.ItemIndex := 0;
  DisplayMonograph;
end;

procedure TfrmOCMonograph.DisplayMonograph;
var
  i: Integer;
  x: Integer;
  monograph: TStringList;
begin
  x := -1;
  monograph := TStringList.Create;
  monoMemo.Clear;
  try
    for i := 0 to mList.Count - 1 do
    begin
      if Piece(mList[i], '^', 2) = monoCmbLst.Items[monoCmbLst.ItemIndex] then
        x := StrToIntDef(Piece(mList[i], '^', 1),-1); // AA: re-enforcing conversion
    end;
    if (x > -1) then
    begin
      GetMonograph(monograph, x);
      monoMemo.Lines.Assign(monograph);
    end;
  finally
    monograph.Free; // AA. 20101203
  end;
end;

procedure TfrmOCMonograph.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;

procedure TfrmOCMonograph.monoCmbLstChange(Sender: TObject);
begin
  DisplayMonograph;
end;

procedure TfrmOCMonograph.VA508ComponentAccessibility1CaptionQuery(
  Sender: TObject; var Text: string);
begin
  Text := monoCmbLst.SelText;
end;

end.
