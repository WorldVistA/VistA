unit fNoteCslt;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, StdCtrls, ORCtrls, ORFn, VA508AccessibilityManager;

type
  TfrmNoteConsult = class(TfrmAutoSz)
    Label1: TStaticText;
    Label2: TStaticText;
    lstRequests: TORListBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    cmdOK: TButton;
    cmdCancel: TButton;
    Label6: TLabel;
    Label7: TLabel;
    procedure cmdCancelClick(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure lstRequestsClick(Sender: TObject);
  private
    { Private declarations }
    FSelectedRequest: Integer;
  public
    { Public declarations }
  end;

function SelectConsult: Integer;

implementation

{$R *.DFM}

uses rTIU;

const
  TX_NO_REQUEST = 'There are no consult requests available for this patient.' + CRLF +
                   'Another progress note title must be selected.';
  TX_NO_REQUEST_CAP = 'No Consult Requests';

function SelectConsult: Integer;
var
  frmNoteConsult: TfrmNoteConsult;
  AConsultList: TStringList;
begin
  Result := 0;
  frmNoteConsult := TfrmNoteConsult.Create(Application);
  AConsultList := TStringList.Create;
  try
    ListConsultRequests(AConsultList);
    if AConsultList.Count > 0 then
    begin
      ResizeFormToFont(TForm(frmNoteConsult));
      FastAssign(AConsultList, frmNoteConsult.lstRequests.Items);
      frmNoteConsult.ShowModal;
      Result := frmNoteConsult.FSelectedRequest;
    end
    else InfoBox(TX_NO_REQUEST, TX_NO_REQUEST_CAP, MB_OK);
  finally
    frmNoteConsult.Release;
    AConsultList.Free;
  end;
end;

procedure TfrmNoteConsult.lstRequestsClick(Sender: TObject);
begin
  inherited;
  if lstRequests.ItemIEN > 0 then cmdOK.Enabled := True else cmdOK.Enabled := False;
end;

procedure TfrmNoteConsult.cmdOKClick(Sender: TObject);
begin
  inherited;
  FSelectedRequest := lstRequests.ItemIEN;
  Close;
end;

procedure TfrmNoteConsult.cmdCancelClick(Sender: TObject);
begin
  inherited;
  FSelectedRequest := 0;
  Close;
end;

end.
