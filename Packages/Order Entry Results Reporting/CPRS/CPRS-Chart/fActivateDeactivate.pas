unit fActivateDeactivate;

interface

uses
  Windows, Messages, SysUtils, StrUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fAutoSz, StdCtrls, ExtCtrls, ORCtrls,ORFn, rCore, uCore, oRNet, Math, fOrders, ORClasses, rOrders,
  fMeds, rMeds, VA508AccessibilityManager;

type
  TfrmActivateDeactive = class(TfrmAutoSz)
    TActivate: TButton;
    TDeactive: TButton;
    Memo1: TMemo;
    TCancel: TButton;
    procedure TActivateClick(Sender: TObject);
    procedure TDeactiveClick(Sender: TObject);
    procedure TCancelClick(Sender: TObject);
  private
    { Private declarations }
    procedure GetOriginalOrders(OrderID: TStringList; var OriginalOrder: TORStringList);
    procedure DCOriginalOrder(OrderID: string);
    procedure BuildForm(Str1: String);
    function PromptForm(Text: String): String;
  public
     { Public declarations }

    procedure fActivateDeactive(OrderID: TStringList); overload;
    procedure fActivateDeactive(OrderID: TStringList; AList: TListBox); overload;
  end;

var
  frmActivateDeactive: TfrmActivateDeactive;
  Act: Boolean;
  Deact: Boolean;
  CancelProcess: Boolean;

implementation

{$R *.dfm}

{ TfrmActivateDeactive }

procedure TfrmActivateDeactive.BuildForm(Str1: String);
var
 str: string;
begin
  with frmActivateDeactive do
     begin
        str := 'This order is in a pending status.  If this pending order is discontinued, the original order will still be active.';
        str := str + CRLF + CRLF + str1;
        str := str + CRLF + CRLF + 'Click:';
        str := str + CRLF + '     "DC BOTH" to discontinue both orders ';
        str := str + CRLF + '     "DC Pending Order" to discontinue only the pending order and return the original order back to an active status ';
        str := str + CRLF + '     "Cancel - No Action Taken" to stop the discontinue process ';
        Memo1.ReadOnly := False;
        Memo1.Text := str;
        Memo1.ReadOnly := True;
     end;
    ResizeAnchoredFormToFont(frmActivateDeactive);
    frmActivateDeactive.ShowModal;
    frmActivateDeactive.Release;
    frmActivateDeactive := nil;
end;

procedure TfrmActivateDeactive.fActivateDeactive(OrderID: TStringList);
var
i,Pos: integer;
tmpArr: TORStringList;
ActDeact: string;
AnOrder: TOrder;
begin
  //called from order tab
  tmpArr := TORStringList.Create;
  try
    GetOriginalOrders(OrderID, tmpArr);
    with fOrders.frmOrders.lstOrders do for i := 0 to items.Count-1 do if Selected[i] then
      begin
        AnOrder := TOrder(Items.Objects[i]);
        Pos := tmpArr.IndexOfPiece(AnOrder.ID,U,1);
        if Pos > -1 then
          begin
            ActDeact := PromptForm(AnOrder.Text);
            if ActDeact = 'D' then AnOrder.DCOriginalOrder := True;
            if ActDeact = 'A' then AnOrder.DCOriginalOrder := False;
            if ActDeact = 'C' then Selected[i] := False;
          end;
      end;
  finally
    tmpArr.Free;
  end;
end;

procedure TfrmActivateDeactive.fActivateDeactive(OrderID: TStringList; AList: TListBox);
var
i,Pos: integer;
tmpArr: TORStringList;
ActDeact: String;
AMed: TMedListRec;
AnOrder: TOrder;
begin
  //called from Med tab
  AnOrder := nil;
  tmpArr := TORStringList.Create;
  try
    GetOriginalOrders(OrderID,tmpArr);
    AnOrder := TOrder.Create;
      with AList do for i := 0 to items.Count-1 do if Selected[i] then
        begin
          AMed := TMedListRec(Items.Objects[i]);
          if AMed = nil then Continue;
          Pos := tmpArr.IndexOfPiece(AMed.OrderID,U,1);
          if Pos > -1 then
            begin
              ActDeact := PromptForm(Alist.Items.Strings[i]);
              if ActDeact = 'D' then
                begin
                  AnOrder.free;
                  AnOrder := GetOrderByIFN(Piece(tmpArr.Strings[Pos],U,1));
                  DCOriginalOrder(AnOrder.ID);
                  //AnOrder.DCOriginalOrder := True;
                end;
              if ActDeact = 'A' then AnOrder.DCOriginalOrder := False;
              if ActDeact = 'C' then Selected[i] := False;
            end;
        end;
  finally
    if assigned(AnOrder) then AnOrder.free;
    tmpArr.Free;
  end;
end;

procedure TfrmActivateDeactive.GetOriginalOrders(OrderID: TStringList; var OriginalOrder: TORStringList);
var
i: integer;
  aTmpList: TStringList;
begin
  aTmpList := TStringList.Create;
  try
    CallVistA('ORWDX1 DCREN', [OrderID], aTmpList);
    for i := 0 to aTmpList.Count-1 do
      OriginalOrder.Add(aTmpList[i]);
  finally
    FreeAndNil(aTmpList);
  end;
end;

function TfrmActivateDeactive.PromptForm(Text: String): String;
begin
  frmActivateDeactive := TfrmActivateDeactive.create(Application);
  BuildForm(Text);
  if Deact = True then Result := 'D';
  if Act = True then Result := 'A';
  if CancelProcess = True then Result := 'C';
end;

procedure TfrmActivateDeactive.TActivateClick(Sender: TObject);
begin
  inherited;
   Act := True;
   Deact := False;
   CancelProcess := False;
   frmActivateDeactive.Close;
end;

procedure TfrmActivateDeactive.TDeactiveClick(Sender: TObject);
begin
  inherited;
   Act := False;
   Deact := True;
   CancelProcess := False;
   frmActivateDeactive.Close;
end;

procedure TfrmActivateDeactive.TCancelClick(Sender: TObject);
begin
  inherited;
  Act := False;
  Deact := False;
  CancelProcess := True;
  frmActivateDeactive.Close;
end;

procedure TfrmActivateDeactive.DCOriginalOrder(OrderID: string);
begin
  CallVistA('ORWDX1 DCORIG', [OrderID]);
end;

end.
