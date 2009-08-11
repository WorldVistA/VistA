unit fNoteBD;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ORFN,
  StdCtrls, ExtCtrls, ORCtrls, ORDtTm, uTIU, fBase508Form,
  VA508AccessibilityManager;

type
  TfrmNotesByDate = class(TfrmBase508Form)
    pnlBase: TORAutoPanel;
    lblBeginDate: TLabel;
    calBeginDate: TORDateBox;
    lblEndDate: TLabel;
    calEndDate: TORDateBox;
    radSort: TRadioGroup;
    cmdOK: TButton;
    cmdCancel: TButton;
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure calBeginDateKeyPress(Sender: TObject; var Key: Char);
    procedure calEndDateKeyPress(Sender: TObject; var Key: Char);
  private
    FChanged: Boolean;
    FBeginDate: string;
    FFMBeginDate: TFMDateTime;
    FEndDate: string;
    FFMEndDate: TFMDateTime;
    FAscending: Boolean;
  end;

  TNoteDateRange = record
    Changed: Boolean;
    BeginDate: string;
    FMBeginDate: TFMDateTime;
    EndDate: string;
    FMEndDate: TFMDateTime;
    Ascending: Boolean;
  end;

procedure SelectNoteDateRange(FontSize: Integer; CurrentContext: TTIUContext; var NoteDateRange: TNoteDateRange);

implementation

{$R *.DFM}

uses rCore, rTIU;

const
  TX_DATE_ERR = 'Enter valid beginning and ending dates or press Cancel.';
  TX_DATE_ERR_CAP = 'Error in Date Range';

procedure SelectNoteDateRange(FontSize: Integer; CurrentContext: TTIUContext; var NoteDateRange: TNoteDateRange);
{ displays date range select form for progress notes and returns a record of the selection }
var
  frmNotesByDate: TfrmNotesByDate;
  W, H: Integer;
begin
  frmNotesByDate := TfrmNotesByDate.Create(Application);
  try
    with frmNotesByDate do
    begin
      Font.Size := FontSize;
      W := ClientWidth;
      H := ClientHeight;
      ResizeToFont(FontSize, W, H);
      ClientWidth  := W; pnlBase.Width  := W;
      ClientHeight := H; pnlBase.Height := W;
      FChanged := False;
      calBeginDate.Text := CurrentContext.BeginDate;
      calEndDate.Text   := CurrentContext.EndDate;
      if calEndDate.Text = '' then calEndDate.Text := 'TODAY';
      FAscending := CurrentContext.TreeAscending;
      with radSort do if FAscending then ItemIndex := 0 else ItemIndex := 1;
      ShowModal;
      with NoteDateRange do
      begin
        Changed := FChanged;
        BeginDate := FBeginDate;
        FMBeginDate := FFMBeginDate;
        EndDate := FEndDate;
        FMEndDate := FFMEndDate;
        Ascending := FAscending;
      end; {with NoteDateRange}
    end; {with frmNotesByDate}
  finally
    frmNotesByDate.Release;
  end;
end;

procedure TfrmNotesByDate.cmdOKClick(Sender: TObject);
var
  bdate, edate: TFMDateTime;
begin
  if calBeginDate.Text <> '' then
     bdate := StrToFMDateTime(calBeginDate.Text)
  else
     bdate := 0 ;

  if calEndDate.Text <> '' then
     edate   := StrToFMDateTime(calEndDate.Text)
  else
     edate := 0 ;

  if (bdate <= edate) then
    begin
      FChanged := True;
      FBeginDate := calBeginDate.Text;
      FFMBeginDate := bdate;
      FEndDate := calEndDate.Text;
      FFMEndDate := edate;
      FAscending := radSort.ItemIndex = 0;
    end
  else
    begin
      InfoBox(TX_DATE_ERR, TX_DATE_ERR_CAP, MB_OK or MB_ICONWARNING);
      Exit;
    end;
  Close;
end;

procedure TfrmNotesByDate.cmdCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmNotesByDate.calBeginDateKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (Key = #13) then cmdOKClick(Self);
end;

procedure TfrmNotesByDate.calEndDateKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (Key = #13) then cmdOKClick(Self);
end;

end.
