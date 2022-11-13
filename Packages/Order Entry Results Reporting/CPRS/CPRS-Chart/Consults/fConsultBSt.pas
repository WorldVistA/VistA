unit fConsultBSt;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ORCtrls, StdCtrls, ORFn, uConsults, fBase508Form,
  VA508AccessibilityManager;

type
  TfrmConsultsByStatus = class(TfrmBase508Form)
    pnlBase: TORAutoPanel;
    lblStatus: TLabel;
    radSort: TRadioGroup;
    lstStatus: TORListBox;
    cmdOK: TButton;
    cmdCancel: TButton;
    Panel1: TPanel;
    procedure cmdCancelClick(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
  private
    FChanged: Boolean;
    FStatus: string;
    FStatusName: string;
    FAscending: Boolean;
  end;

  TStatusContext = record
    Changed: Boolean;
    Status: string;
    StatusName: string;
    Ascending: Boolean;
  end;

function SelectStatus(FontSize: Integer; CurrentContext: TSelectContext; var StatusContext: TStatusContext): boolean ;

implementation

{$R *.DFM}

uses rConsults, rCore, uCore;

const
  TX_STAT_TEXT = 'Select a consult status or press Cancel.';
  TX_STAT_CAP = 'Missing Status';

function SelectStatus(FontSize: Integer; CurrentContext: TSelectContext; var StatusContext: TStatusContext): boolean ;
{ displays Status select form for consults and returns a record of the selection }
var
  frmConsultsByStatus: TfrmConsultsByStatus;
  W, H, i, j: Integer;
  CurrentStatus: string;
begin
  frmConsultsByStatus := TfrmConsultsByStatus.Create(Application);
  try
    with frmConsultsByStatus do
    begin
      Font.Size := FontSize;
      W := ClientWidth;
      H := ClientHeight;
      ResizeToFont(FontSize, W, H);
      ClientWidth  := W; pnlBase.Width  := W;
      ClientHeight := H; pnlBase.Height := H;
      FChanged := False;
      with radSort do {if SortConsultsAscending then ItemIndex := 0 else} ItemIndex := 1;
      setSubSetOfStatus(lstStatus.Items);
      CurrentStatus := CurrentContext.Status;
      if CurrentStatus <> '' then with lstStatus do
        begin
          i := 1;
          while Piece(CurrentStatus, ',', i) <> '' do
            begin
              j := SelectByID(Piece(CurrentStatus, ',', i));
              if j > -1 then Selected[j] := True;
              Inc(i);
            end;
        end;
      ShowModal;
      with StatusContext do
      begin
        Changed := FChanged;
        Status := FStatus;
        StatusName := FStatusName;
        Ascending := FAscending;
        Result := Changed ;
      end; {with StatusContext}
    end; {with frmConsultsByStatus}
  finally
    frmConsultsByStatus.Release;
  end;
end;

procedure TfrmConsultsByStatus.cmdCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmConsultsByStatus.cmdOKClick(Sender: TObject);
var
  i: integer;
begin
  if lstStatus.SelCount = 0 then
   begin
    InfoBox(TX_STAT_TEXT, TX_STAT_CAP, MB_OK or MB_ICONWARNING);
    Exit;
   end;
  FChanged := True;
  with lstStatus do for i := 0 to Items.Count-1 do if Selected[i] then
    begin
      if Piece(Items[i], U, 1) <> '999' then
        FStatus := FStatus + Piece(Items[i], U, 1) + ','
      else
        FStatus := FStatus + Piece(Items[i],U,3) ;
      FStatusName := FStatusName + DisplayText[i] + ',' ;
    end;
  FStatus := Copy(FStatus, 1, Length(FStatus)-1);
  FStatusName := Copy(FStatusName, 1, Length(FStatusName)-1);
  FAscending  := radSort.ItemIndex = 0;
  Close;
end;

end.
