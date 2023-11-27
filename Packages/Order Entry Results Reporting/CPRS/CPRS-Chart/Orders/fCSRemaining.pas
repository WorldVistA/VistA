unit fCSRemaining;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ORCtrls, ExtCtrls, VA508AccessibilityManager, StrUtils,
  ORFn, uCore, rOrders, fBase508Form;

type
  TfrmCSRemaining = class(TfrmBase508Form)
    lblCSRemaining: TVA508StaticText;
    lstCSRemaining: TCaptionListBox;
    cmdOK: TButton;
    VA508ComponentAccessibility1: TVA508ComponentAccessibility;
    pnlBottom: TPanel;
    procedure cmdOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  tStringsHelper = class helper for TStrings
    function OrderExists(aOrderID: String): boolean;
  end;

procedure CSRemaining(orders: TStrings; csorders: TStrings);

implementation

uses
  fFrame;

procedure CSRemaining(orders: TStrings; csorders: TStrings);
var
  ShownCurrentUserLabel, ShownOtherUsersLabel: boolean;
  Display, OrderID: String;
  i: Integer;
  frmCSRemaining: TfrmCSRemaining;
  UnsignedOrders,HaveOrders,OthersCSOrders: TStrings;
begin
  if frmFrame.TimedOut then
    exit;
  ShownCurrentUserLabel := False;
  ShownOtherUsersLabel := False;
  OthersCSOrders  := TStringList.Create;
  HaveOrders  := TStringList.Create;
  UnsignedOrders := TStringList.Create;
  frmCSRemaining := TfrmCSRemaining.Create(Application);
  try
    ResizeFormToFont(frmCSRemaining);
    LoadUnsignedOrders(UnsignedOrders,HaveOrders);
    for i := 0 to Pred(UnsignedOrders.Count) do
    begin
      //if UnsignedOrders[i] is not in either orders or csorders then continue

      OrderID := Piece(unsignedOrders[i],u,1);
      if (not orders.OrderExists(OrderID)) and (not csorders.OrderExists(OrderID)) then
        continue;

      Display := TextForOrder(OrderID);
      if Piece(UnsignedOrders[i],U,6)='1' then
      begin
        if User.DUZ=StrToInt64Def(Piece(UnsignedOrders[i],U,2),0) then
        begin
          if ShownCurrentUserLabel=False then
          begin
            frmCSRemaining.lstCSRemaining.AddItem('My Unsigned Controlled Substance Orders',nil);
            ShownCurrentUserLabel:=True;
          end;
          frmCSRemaining.lstCSRemaining.AddItem('    '+AnsiReplaceText(Display,CRLF,' '),TObject(UnsignedOrders[i]));
        end
        else
          OthersCSOrders.Add(UnsignedOrders[i]);
      end;
    end;

    for i := 0 to Pred(OthersCSOrders.Count) do
    begin
      Display := TextForOrder(Piece(OthersCSOrders[i],U,1));
      if ShownOtherUsersLabel=False then
      begin
        frmCSRemaining.lstCSRemaining.AddItem(' ',nil);
        frmCSRemaining.lstCSRemaining.AddItem('Other User''s Unsigned Controlled Substance Orders',nil);
        ShownOtherUsersLabel := True;
      end;
      frmCSRemaining.lstCSRemaining.AddItem('    '+AnsiReplaceText(Display,CRLF,' '),TObject(OthersCSOrders[i]));
    end;

    if frmCSRemaining.lstCSRemaining.Count>0 then frmCSRemaining.ShowModal;

  finally
    FreeAndNil(OthersCSOrders);
    FreeAndNil(HaveOrders);
    FreeAndNil(UnsignedOrders);
    FreeAndNil(frmCSRemaining);
  end;
end;

{$R *.dfm}

procedure TfrmCSRemaining.cmdOKClick(Sender: TObject);
begin
  self.Close;
end;

function tStringsHelper.OrderExists(aOrderID: String): boolean;
var
  j: Integer;
  ObjID: String;
begin
  Result := False;
  for j := 0 to Count - 1 do
  begin
    if assigned(objects[j]) then
    begin
      if objects[j] is TChangeItem then
        ObjID := TChangeItem(objects[j]).ID;
      if objects[j] is TOrder then
        ObjID := TOrder(objects[j]).ID;

      if aOrderID = ObjID then
      begin
        Result := true;
        break;
      end;
    end;
  end;
end;

end.
