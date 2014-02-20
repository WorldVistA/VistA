unit fODChangeUnreleasedRenew;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ORCtrls, fAutoSz, uOrders, ORFn, ORDtTm, rOrders,
  VA508AccessibilityManager, rODBase, rODMeds;

type
  TfrmODChangeUnreleasedRenew = class(TFrmAutoSz)
    memOrder: TCaptionMemo;
    Panel1: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    Panel2: TPanel;
    edtRefill: TCaptionEdit;
    lblRefill: TLabel;
    lblPickUp: TLabel;
    cboPickup: TORComboBox;
    Panel3: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    txtStart: TORDateBox;
    txtStop: TORDateBox;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    OKPressed: boolean;
    FCategory: integer;
  public
    { Public declarations }
  end;

procedure ExecuteChangeRenewedOrder(const AnID: string; var param1, param2: string; Category: integer; AnEvent: TOrderDelayEvent);

implementation

{$R *.dfm}
var
 MaxRefills: Integer;

const
  TX_ERR_REFILL = 'The number of refills must be in the range of 0 through ';
  TC_ERR_REFILL = 'Refills';
  TC_INVALID_DATE = 'Unable to interpret date/time entry.';
  TX_BAD_START   = 'The start date is not valid.';
  TX_BAD_STOP    = 'The stop date is not valid.';
  TX_STOPSTART   = 'The stop date must be after the start date.';

procedure ExecuteChangeRenewedOrder(const AnID: string; var param1, param2: string; Category: integer; AnEvent: TOrderDelayEvent);
var
  frmODChangeUnreleasedRenew: TfrmODChangeUnreleasedRenew;
  theText: string;
  tmpRefills: integer;
  DestList: TList;
  HasObject: Boolean;
  i: Integer;
  Drug, Days, OrID: string;
begin
  //Get needed information
  DestList := TList.Create();
  try
    LoadResponses(DestList, 'X' + AnID, HasObject);

    for I := 0 to DestList.Count - 1 do begin
      if TResponse(DestList.Items[i]).PromptID = 'DRUG' then Drug := TResponse(DestList.Items[i]).IValue
      else if TResponse(DestList.Items[i]).PromptID = 'SUPPLY' then Days := TResponse(DestList.Items[i]).IValue
      else if TResponse(DestList.Items[i]).PromptID = 'ORDERABLE' then OrID := TResponse(DestList.Items[i]).IValue;
    end;

    MaxRefills := CalcMaxRefills(Drug, StrToInt(Days), StrToInt(OrID), AnEvent.EventType = 'D');

  tmpRefills := 0;
  theText := Trim(RetrieveOrderText(AnID));
  if Pos('>> RENEW', UpperCase(theText)) = 1 then Delete(theText,1,length('>> RENEW'))
  else if Pos('RENEW',UpperCase(theText))= 1 then Delete(theText,1,length('RENEW'));
  frmODChangeUnreleasedRenew := TfrmODChangeUnreleasedRenew.Create(Application);
  try
    frmODChangeUnreleasedRenew.FCategory := Category;
    ResizeFormToFont(TForm(frmODChangeUnreleasedRenew));
    if Category = 0 then
    begin
      frmODChangeUnreleasedRenew.Panel3.Visible := False;
      tmpRefills := StrToIntDef(param1,0);
      frmODChangeUnreleasedRenew.edtRefill.Text := param1;
      frmODChangeUnreleasedRenew.cboPickup.SelectByID(param2);
      frmODChangeUnreleasedRenew.memOrder.SetTextBuf(PChar(theText));
    end
    else if Category = 1 then
    begin
      frmODChangeUnreleasedRenew.Panel2.Visible := false;
      frmODChangeUnreleasedRenew.txtStart.Text := param1;
      frmODChangeUnreleasedRenew.txtStop.Text  := param2;
      frmODChangeUnreleasedRenew.memOrder.SetTextBuf(PChar(theText));
    end;
    frmODChangeUnreleasedRenew.ShowModal;
    if frmODChangeUnreleasedRenew.OKPressed then
    begin
      if Category = 0 then
      begin
        tmpRefills := StrToIntDef(frmODChangeUnreleasedRenew.edtRefill.Text, tmpRefills);
        param1 := IntToStr(tmpRefills);
        param2 := frmODChangeUnreleasedRenew.cboPickup.ItemID;
      end
      else if Category = 1 then
      begin
        param1 := frmODChangeUnreleasedRenew.txtStart.Text;
        param2 := frmODChangeUnreleasedRenew.txtStop.Text;
      end;
    end;
  finally
    frmODChangeUnreleasedRenew.Release;
  end;
  finally
    DestList.Free;
  end;
end;

procedure TfrmODChangeUnreleasedRenew.FormCreate(Sender: TObject);
begin
  inherited;
  OKPressed := False;
  with cboPickup.Items do
  begin
    Add('W^at Window');
    Add('M^by Mail');
    Add('C^in Clinic');
  end;
end;

procedure TfrmODChangeUnreleasedRenew.btnCancelClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TfrmODChangeUnreleasedRenew.btnOKClick(Sender: TObject);
var
  NumRefills: Integer;
  x, ErrMsg: string;
begin
  inherited;
  if panel2.Visible then
  begin
    NumRefills := StrToIntDef(edtRefill.Text, -1);
    if (NumRefills < 0) or (NumRefills > MaxRefills) then
    begin
      InfoBox(TX_ERR_REFILL + IntToStr(MaxRefills), TC_ERR_REFILL, MB_OK);
      Exit;
    end;
  end
  else if panel3.Visible then
  begin
    ErrMsg := '';
    txtStart.Validate(x);
    if Length(x) > 0   then ErrMsg := ErrMsg + TX_BAD_START + CRLF;
    with txtStop do
    begin
      Validate(x);
      if Length(x) > 0 then ErrMsg := ErrMsg + TX_BAD_STOP + CRLF;
      if (Length(Text) > 0) and (FMDateTime <= txtStart.FMDateTime)
                       then ErrMsg := ErrMsg + TX_STOPSTART;
    end;
    if Length(ErrMsg) > 0 then
    begin
      InfoBox(ErrMsg, TC_INVALID_DATE, MB_OK);
      Exit;
    end;
  end;
  OKPressed := True;
  Close;
end;

end.
