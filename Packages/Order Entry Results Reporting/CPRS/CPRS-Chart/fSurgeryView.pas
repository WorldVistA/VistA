unit fSurgeryView;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ORFN,
  StdCtrls, ExtCtrls, ORCtrls, ComCtrls, ORDtTm, Spin, rSurgery, fBase508Form,
  VA508AccessibilityManager;

type
  TfrmSurgeryView = class(TfrmBase508Form)
    pnlBase: TORAutoPanel;
    lblBeginDate: TLabel;
    calBeginDate: TORDateBox;
    lblEndDate: TLabel;
    calEndDate: TORDateBox;
    cmdOK: TButton;
    cmdCancel: TButton;
    lblMaxDocs: TLabel;
    edMaxDocs: TCaptionEdit;
    grpTreeView: TGroupBox;
    lblGroupBy: TOROffsetLabel;
    cboGroupBy: TORComboBox;
    radTreeSort: TRadioGroup;
    cmdClear: TButton;
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure cmdClearClick(Sender: TObject);
  private
    FChanged: Boolean;
    FBeginDate: string;
    FFMBeginDate: TFMDateTime;
    FEndDate: string;
    FFMEndDate: TFMDateTime;
    FOpProc: string;
    FMaxDocs: integer;
    FGroupBy: string;
    FTreeAscending: Boolean;
    FCurrentContext: TSurgCaseContext;
  end;

function SelectSurgeryView(FontSize: Integer; ShowForm: Boolean; CurrentContext: TSurgCaseContext;
          var SurgeryContext: TSurgCaseContext): boolean ;

implementation

{$R *.DFM}

uses rCore, uCore;

const
   TX_DATE_ERR = 'Enter valid beginning and ending dates or press Cancel.';
   TX_DATE_ERR_CAP = 'Error in Date Range';

function SelectSurgeryView(FontSize: Integer; ShowForm: Boolean; CurrentContext: TSurgCaseContext;
          var SurgeryContext: TSurgCaseContext): boolean ;
var
  frmSurgeryView: TfrmSurgeryView;
  W, H: Integer;
begin
  frmSurgeryView := TfrmSurgeryView.Create(Application);
  try
    with frmSurgeryView do
    begin
      Font.Size := FontSize;
      W := ClientWidth;
      H := ClientHeight;
      ResizeToFont(FontSize, W, H);
      ClientWidth  := W; pnlBase.Width  := W;
      ClientHeight := H; pnlBase.Height := H;
      FChanged := False;
      FCurrentContext := CurrentContext;
      calBeginDate.Text := CurrentContext.BeginDate;
      calEndDate.Text   := CurrentContext.EndDate;
      if calEndDate.Text = '' then calEndDate.Text := 'TODAY';
      if CurrentContext.MaxDocs > 0 then
        edMaxDocs.Text :=  IntToStr(CurrentContext.MaxDocs)
      else
        edMaxDocs.Text := '';
      FMaxDocs := StrToIntDef(edMaxDocs.Text, 0);
      radTreeSort.ItemIndex := 0;
      cboGroupBy.SelectByID(CurrentContext.GroupBy);
      if ShowForm then ShowModal else cmdOKClick(frmSurgeryView);

      with SurgeryContext do
       begin
        Changed := FChanged;
        OpProc := FOpProc;
        BeginDate := FBeginDate;
        FMBeginDate := FFMBeginDate;
        EndDate := FEndDate;
        FMEndDate := FFMEndDate;
        MaxDocs := FMaxDocs;
        GroupBy := FGroupBy;
        TreeAscending := FTreeAscending;
        Result := Changed ;
      end;

    end; {with frmSurgeryView}
  finally
    frmSurgeryView.Release;
  end;
end;

procedure TfrmSurgeryView.cmdOKClick(Sender: TObject);
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
      FBeginDate := calBeginDate.Text;
      FFMBeginDate := bdate;
      FEndDate := calEndDate.Text;
      FFMEndDate := edate;
    end
  else
    begin
      InfoBox(TX_DATE_ERR, TX_DATE_ERR_CAP, MB_OK or MB_ICONWARNING);
      Exit;
    end;

  FTreeAscending := (radTreeSort.ItemIndex = 0);
  FMaxDocs := StrToIntDef(edMaxDocs.Text, 0);
  if cboGroupBy.ItemID <> '' then
    FGroupBy := cboGroupBy.ItemID
  else
    FGroupBy := '';
  FChanged := True;
  Close;
end;

procedure TfrmSurgeryView.cmdCancelClick(Sender: TObject);
begin
  FChanged := False;
  Close;
end;

procedure TfrmSurgeryView.cmdClearClick(Sender: TObject);
begin
  cboGroupBy.ItemIndex := -1;
  radTreeSort.ItemIndex := 0;
end;

end.
