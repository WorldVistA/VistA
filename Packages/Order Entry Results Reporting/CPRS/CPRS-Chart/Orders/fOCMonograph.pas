unit fOCMonograph;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ORFn, ORCtrls, rOrders, VA508AccessibilityManager, ExtCtrls;

type
  TfrmOCMonograph = class(TForm) 
    monoCmbLst: TComboBox;
    monoMemo: TCaptionMemo;
    cmdOK: TButton;
    VA508StaticText1: TVA508StaticText;
    VA508StaticText2: TVA508StaticText;
    VA508AccessibilityManager1: TVA508AccessibilityManager;
    VA508ComponentAccessibility1: TVA508ComponentAccessibility;
    procedure DisplayMonograph;
    procedure monoCmbLstChange(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure VA508ComponentAccessibility1CaptionQuery(Sender: TObject;
      var Text: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
  mList: TStringList;
procedure ShowMonographs(monoList: TStringList);

implementation

{$R *.dfm}

procedure ShowMonographs(monoList: TStringList);
var
  i: Integer;
  frmOCMonograph: TfrmOCMonograph;
begin
  if monoList.Count > 0 then
  begin
    mList := monoList;
    frmOCMonograph := TfrmOCMonograph.Create(Application);
    try
      for i := 0 to monoList.Count - 1 do
        begin
          frmOCMonograph.monoCmbLst.Items.Add(Piece(monoList[i], U, 2));
        end;

     //frmOCMonograph.monoMemo.Clear;
     frmOCMonograph.monoCmbLst.ItemIndex := 0;
     frmOCMonograph.DisplayMonograph;
     frmOCMonograph.ShowModal;
    finally
      frmOCMonograph.Free;
    end;
  end;
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
  for i := 0 to mList.Count - 1 do
  begin
    if Piece(mList[i],'^',2)=monoCmbLst.Items[monoCmbLst.ItemIndex] then x := StrtoInt(Piece(mList[i],'^',1));
  end;
  if (x > -1) then
  begin
    GetMonograph(monograph,x);
    for i := 0 to monograph.Count - 1 do
    begin
      monoMemo.Text := monoMemo.Text + monograph[i] + CRLF;
    end;

  end;
    
end;

procedure TfrmOCMonograph.cmdOKClick(Sender: TObject);
begin
  self.Close;
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
