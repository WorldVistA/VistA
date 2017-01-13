unit fRenewOutMed;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, StdCtrls, ComCtrls, ORFn, rOrders, Mask, ORCtrls, ExtCtrls, fBase508Form,
  VA508AccessibilityManager, VA508AccessibilityRouter, rODBase, rODMeds;

type
  TfrmRenewOutMed = class(TfrmBase508Form)
    memOrder: TCaptionMemo;
    pnlButtons: TPanel;
    cmdOK: TButton;
    cmdCancel: TButton;
    pnlMiddle: TPanel;
    cboPickup: TORComboBox;
    lblPickup: TLabel;
    txtRefills: TCaptionEdit;
    lblRefills: TLabel;
    VA508ComponentAccessibility1: TVA508ComponentAccessibility;
    procedure FormCreate(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure VA508ComponentAccessibility1StateQuery(Sender: TObject;
      var Text: string);
    procedure FormShow(Sender: TObject);
  private
    OKPressed: Boolean;
  end;

function ExecuteRenewOutMed(var Refills: Integer; var Comments, Pickup: string;
  AnOrder: TOrder): Boolean;

implementation

{$R *.DFM}

var
 MaxRefills: Integer;

const
  TX_ERR_REFILL = 'The number of refills must be in the range of 0 through ';
  TC_ERR_REFILL = 'Refills';

function ExecuteRenewOutMed(var Refills: Integer; var Comments, Pickup: string;
  AnOrder: TOrder): Boolean;
var
  frmRenewOutMed: TfrmRenewOutMed;
   DestList: TList;
  HasObject: Boolean;
  i: Integer;
  Drug, Days, OrID: string;
begin
  Result := False;
  DestList := TList.Create();
  try
    LoadResponses(DestList, 'X' + AnOrder.ID, HasObject);

    for I := 0 to DestList.Count - 1 do begin
      if TResponse(DestList.Items[i]).PromptID = 'DRUG' then Drug := TResponse(DestList.Items[i]).IValue
      else if TResponse(DestList.Items[i]).PromptID = 'SUPPLY' then Days := TResponse(DestList.Items[i]).IValue
      else if TResponse(DestList.Items[i]).PromptID = 'ORDERABLE' then OrID := TResponse(DestList.Items[i]).IValue;
    end;

    MaxRefills := CalcMaxRefills(Drug, StrToIntDef(Days, 0), StrToInt(OrID), AnOrder.EventName = 'D');

  frmRenewOutMed := TfrmRenewOutMed.Create(Application);
  try
    ResizeFormToFont(TForm(frmRenewOutMed));
    frmRenewOutMed.memOrder.SetTextBuf(PChar(AnOrder.Text));
    frmRenewOutMed.txtRefills.Text := IntToStr(Refills);
    frmRenewOutMed.cboPickup.SelectByID(Pickup);
    frmRenewOutMed.ShowModal;
    if frmRenewOutMed.OKPressed then
    begin
      Result := True;
      Refills := StrToIntDef(frmRenewOutMed.txtRefills.Text, Refills);
      Pickup := frmRenewOutMed.cboPickup.ItemID;
    end;
  finally
    frmRenewOutMed.Release;
    end;
  finally
    DestList.Free;
  end;
end;

procedure TfrmRenewOutMed.FormCreate(Sender: TObject);
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

procedure TfrmRenewOutMed.FormShow(Sender: TObject);
begin
  inherited;
  if ScreenReaderSystemActive then
  begin
    memOrder.TabStop := true;
    memOrder.SetFocus;
  end;
end;

procedure TfrmRenewOutMed.VA508ComponentAccessibility1StateQuery(
  Sender: TObject; var Text: string);
begin
  inherited;
  Text := memOrder.Text;
end;

procedure TfrmRenewOutMed.cmdOKClick(Sender: TObject);
var
  NumRefills: Integer;
begin
  inherited;
  NumRefills := StrToIntDef(txtRefills.Text, -1);
  if (NumRefills < 0) or (NumRefills > MaxRefills) then
  begin
    InfoBox(TX_ERR_REFILL + IntToStr(MaxRefills), TC_ERR_REFILL, MB_OK);
    Exit;
  end;
  OKPressed := True;
  Close;
end;

procedure TfrmRenewOutMed.cmdCancelClick(Sender: TObject);
begin
  inherited;
  Close;
end;

end.
