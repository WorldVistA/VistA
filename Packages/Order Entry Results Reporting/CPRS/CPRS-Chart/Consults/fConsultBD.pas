unit fConsultBD;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ORFN,
  StdCtrls, ExtCtrls, ORCtrls, ORDtTm, uConsults, fBase508Form,
  VA508AccessibilityManager;

type
  TfrmConsultsByDate = class(TfrmBase508Form)
    pnlBase: TORAutoPanel;
    lblBeginDate: TLabel;
    calBeginDate: TORDateBox;
    lblEndDate: TLabel;
    calEndDate: TORDateBox;
    radSort: TRadioGroup;
    cmdOK: TButton;
    cmdCancel: TButton;
    Panel1: TPanel;
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure calBeginDateKeyPress(Sender: TObject; var Key: Char);
    procedure calEndDateKeyPress(Sender: TObject; var Key: Char);
  private
    FChanged: Boolean;
    FBeginDate: string;
    FEndDate: string;
    FAscending: Boolean;
  end;

  TConsultDateRange = record
    Changed: Boolean;
    BeginDate: string;
    EndDate: string;
    Ascending: Boolean;
  end;

function SelectConsultDateRange(FontSize: Integer; CurrentContext: TSelectContext; var ConsultDateRange: TConsultDateRange): boolean;

implementation

{$R *.DFM}

uses rCore, rConsults;

const
   TX_DATE_ERR = 'Enter valid beginning and ending dates or press Cancel.';
   TX_DATE_ERR_CAP = 'Error in Date Range';

function SelectConsultDateRange(FontSize: Integer; CurrentContext: TSelectContext; var ConsultDateRange: TConsultDateRange): boolean;
{ displays date range select form for progress Consults and returns a record of the selection }
var
  frmConsultsByDate: TfrmConsultsByDate;
  W, H: Integer;
  CurrentBegin, CurrentEnd: string;
begin
  frmConsultsByDate := TfrmConsultsByDate.Create(Application);
  try
    with frmConsultsByDate do
    begin
      Font.Size := FontSize;
      W := ClientWidth;
      H := ClientHeight;
      ResizeToFont(FontSize, W, H);
      ClientWidth  := W; pnlBase.Width  := W;
      ClientHeight := H; pnlBase.Height := H;
      FChanged := False;
      with radSort do {if SortConsultsAscending then ItemIndex := 0 else} ItemIndex := 1;
      CurrentBegin := CurrentContext.BeginDate;
      CurrentEnd := CurrentContext.EndDate;
      if CurrentBegin <> '' then
        calBeginDate.Text := CurrentBegin;
      if CurrentEnd <> '' then
        calEndDate.Text := CurrentEnd;
      if calEndDate.Text = '' then calEndDate.Text := 'TODAY';
      ShowModal;
      with ConsultDateRange do
      begin
        Changed := FChanged;
        BeginDate := FBeginDate;
        EndDate := FEndDate;
        Ascending := FAscending;
        Result := Changed ;
      end; {with ConsultDateRange}
    end; {with frmConsultsByDate}
  finally
    frmConsultsByDate.Release;
  end;
end;

procedure TfrmConsultsByDate.cmdOKClick(Sender: TObject);
var
  bdate, edate: TFMDateTime;
begin
  bdate := StrToFMDateTime(calBeginDate.Text);
  edate   := StrToFMDateTime(calEndDate.Text);
  if ((bdate > 0) and (edate > 0)) and (bdate <= edate) then
  begin
    FChanged := True;
    FBeginDate := calBeginDate.Text;
    FEndDate := calEndDate.Text;
    FAscending := radSort.ItemIndex = 0;
    Close;
  end else
  begin
    InfoBox(TX_DATE_ERR, TX_DATE_ERR_CAP, MB_OK or MB_ICONWARNING);
    Exit;
  end;
end;

procedure TfrmConsultsByDate.cmdCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmConsultsByDate.calBeginDateKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (Key = #13) then cmdOKClick(Self);
end;

procedure TfrmConsultsByDate.calEndDateKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (Key = #13) then cmdOKClick(Self);
end;

end.
