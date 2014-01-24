unit fCSRemaining;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ORCtrls, ExtCtrls, VA508AccessibilityManager, StrUtils,
  ORFn, uCore, rOrders;

type
  TfrmCSRemaining = class(TForm)
    lblCSRemaining: TVA508StaticText;
    lstCSRemaining: TCaptionListBox;
    cmdOK: TButton;
    VA508AccessibilityManager1: TVA508AccessibilityManager;
    VA508ComponentAccessibility1: TVA508ComponentAccessibility;
    procedure cmdOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


procedure CSRemaining(orders: TStrings; csorders: TStrings);

implementation


procedure CSRemaining(orders: TStrings; csorders: TStrings);
var
  ShownCurrentUserLabel, ShownOtherUsersLabel: boolean;
  Display: String;
  i,j: Integer;
  frmCSRemaining: TfrmCSRemaining;
  UnsignedOrders,HaveOrders,OthersCSOrders: TStrings;
  show: boolean;
begin
    ShownCurrentUserLabel := False;
    ShownOtherUsersLabel := False;
    OthersCSOrders  := TStringList.Create;
    HaveOrders  := TStringList.Create;
    UnsignedOrders := TStringList.Create;
    frmCSRemaining := TfrmCSRemaining.Create(Application);
    LoadUnsignedOrders(UnsignedOrders,HaveOrders);
    for i := 0 to Pred(UnsignedOrders.Count) do
    begin
      //if UnsignedOrders[i] is not in either orders or csorders then continue
      show := false;
      for j := 0 to orders.Count - 1 do
      begin
        if (not(orders.objects[j]=nil) and (Piece(unsignedOrders[i],u,1)=TChangeItem(orders.objects[j]).ID)) then show := true;
      end;
      for j := 0 to csorders.Count - 1 do
      begin
        if (not(csorders.objects[j]=nil) and (Piece(unsignedOrders[i],u,1)=TChangeItem(csorders.objects[j]).ID)) then show := true;
      end;

      if not(show) then continue;

      Display := TextForOrder(Piece(UnsignedOrders[i],U,1));
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
end;

{$R *.dfm}

procedure TfrmCSRemaining.cmdOKClick(Sender: TObject);
begin
  self.Close;
end;

end.
