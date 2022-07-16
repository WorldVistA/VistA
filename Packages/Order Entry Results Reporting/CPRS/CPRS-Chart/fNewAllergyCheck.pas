unit fNewAllergyCheck;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,

System.Classes, Vcl.Graphics, fAutoSz,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ORCtrls, Vcl.StdCtrls, Vcl.ExtCtrls,
  VA508AccessibilityManager, Vcl.Buttons;

type
  TfrmNewAllergyCheck = class(TfrmAutoSz)
    Label4: TLabel;
    SendAlertBtn: TSpeedButton;
    AddBtn: TSpeedButton;
    RemoveBtn: TSpeedButton;
    Panel2: TPanel;
    Label2: TLabel;
    ActiveOrders: TLabel;
    Recipients: TORListBox;
    Label1: TLabel;
    SelRecip: TORListBox;
    Panel1: TPanel;
    OptRecip: TORComboBox;
    procedure SendAlertBtnClick(Sender: TObject);
    procedure OptRecipxxNeedData(Sender: TObject;
      const StartFrom: string; Direction, InsertAt: Integer);
    procedure OptRecipKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AddBtnClick(Sender: TObject);
    procedure RemoveBtnClick(Sender: TObject);
    procedure OptRecipMouseClick(Sender: TObject);
    procedure OptRecipNeedData(Sender: TObject; const StartFrom: string;
      Direction, InsertAt: Integer);
    procedure OptRecipDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure setByOrder(anOrder,aNewAllergy,tDFN:String; Cleanup:Boolean = true);
  end;

Function ExecuteNewAllergyCheck(aMatchingDrugs: TStringList; aNewAllergy: string): Boolean;



implementation

{$R *.dfm}

uses fARTAllgy, ORNet, uCore, rCore, ORfn, uORLists, uSimilarNames;

var
  OrderNo:string;
  MatchingProviders: TStringList;
  ReturnedRecipients: TStringList;


Function ExecuteNewAllergyCheck(aMatchingDrugs: TStringList;
  aNewAllergy: string): Boolean;
var
  frmNewAllergyCheck: TfrmNewAllergyCheck;
  I: Integer;
begin
  try
    frmNewAllergyCheck := TfrmNewAllergyCheck.Create(Application);
    try
      ResizeAnchoredFormToFont(frmNewAllergyCheck);
      for I := 0 to aMatchingDrugs.Count - 1 do
      begin
        frmNewAllergyCheck.setByOrder(aMatchingDrugs[I], aNewAllergy,
          Patient.DFN);
        frmNewAllergyCheck.ShowModal;
      end;
    finally
      frmNewAllergyCheck.Free;
    end;
    Result := true;
  Except
    On e: Exception do
    begin
      raise Exception.Create(e.Message);
    end;
  end;
end;

procedure TfrmNewAllergyCheck.setByOrder(anOrder,aNewAllergy,tDFN:String; Cleanup:Boolean = true);
var
  i:integer;
begin
  if Cleanup then
    Recipients.Items.Clear;
  ReturnedRecipients := TStringList.Create;
  try
    OptRecip.InitLongList('');

    MatchingProviders := TStringList.Create;
    Label2.Caption := ' The following ACTIVE Order contains ' + aNewAllergy;
    ActiveOrders.Caption := '   ' + Piece(anOrder,'^',3) + ' (Order# ' + Piece(anOrder,'^',1) + ')';

    OrderNo := Piece(anOrder,'^',1);
    i := Pos(';', OrderNo);
    if i > 0 then
      OrderNo := Copy(anOrder,1,i - 1);

    CallVistA('ORWDAL32 GETPROV',[OrderNo,tdfn],MatchingProviders);
    for i := 0 to MatchingProviders.Count - 1 do
      Recipients.Items.Add(Piece(MatchingProviders[i],'^',1) + ', - ' + Piece(MatchingProviders[i],'^',2));
  finally
    ReturnedRecipients.Free;
  end;
end;

procedure TfrmNewAllergyCheck.SendAlertBtnClick(Sender: TObject);
var i:integer;
begin
  for i := 0 to SelRecip.Count - 1 do
    MatchingProviders.Add(SelRecip.items[i]);
  try
//    sCallv('ORWDAL32 SENDALRT',[OrderNo, MatchingProviders]);
    CallVistA('ORWDAL32 SENDALRT',[OrderNo, MatchingProviders]);
  finally
    MatchingProviders.Free;
  end;
  Close;
end;

procedure TfrmNewAllergyCheck.OptRecipNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
begin
  inherited;
  uORLists.setPersonList(OptRecip ,StartFrom, Direction);
end;

procedure TfrmNewAllergyCheck.OptRecipDblClick(Sender: TObject);
begin
  inherited;
  AddBtn.Click;
end;

procedure TfrmNewAllergyCheck.OptRecipKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    OptRecipMouseClick(Self);
end;

procedure TfrmNewAllergyCheck.OptRecipMouseClick(Sender: TObject);
begin
  inherited;
  if (OptRecip.ItemIndex < 0) or (OptRecip.Text = '') or (OptRecip.ItemID = '') then
    Exit;
  if OptRecip.ItemIndex > -1 then
  with OptRecip do
    OptRecip.Items.Add(items[itemIndex]);
end;

procedure TfrmNewAllergyCheck.OptRecipxxNeedData(Sender: TObject;     // NJC - 1 090717
  const StartFrom: string; Direction, InsertAt: Integer);
var uCase:string;                        // NJC 090717
begin
  inherited;
  setProviderList(OptRecip, uCase, Direction);         // NJC 090717
end;

procedure TfrmNewAllergyCheck.AddBtnClick(Sender: TObject);
var i,y:integer;
aErrMsg: String;
begin
  if not CheckForSimilarName(OptRecip, aErrMsg, ltPerson, sPr) then
  begin
    ShowMsgOn(Trim(aErrMsg) <> '' , aErrMsg, 'Invalid Provider');
    exit;
  end;

  if OptRecip.itemindex <> -1 then
  begin
    for i := 0 to SelRecip.Count - 1 do
    begin
      if SelRecip.items[i] = OptRecip.items[OptRecip.itemindex] then
      begin
        for y := 0 to SelRecip.Count - 1 do
          SelRecip.Selected[y] := false;
        SelRecip.Selected[i] := true;
        Exit;
      end
      else
        MatchingProviders.Add(SelRecip.items[i]);
    end;
    SelRecip.Items.Add(OptRecip.items[OptRecip.itemindex]);
  end;
end;

procedure TfrmNewAllergyCheck.RemoveBtnClick(Sender: TObject);
begin
  if SelRecip.itemindex <> -1 then
  begin
    if SelRecip.itemindex <> -1 then
      SelRecip.items.Delete(SelRecip.itemindex);
  end;
end;


end.
