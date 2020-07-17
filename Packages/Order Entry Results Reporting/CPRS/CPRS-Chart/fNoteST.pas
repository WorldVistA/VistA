unit fNoteST;
{
Text Search CQ: HDS00002856
This Unit Contains the Dialog Used to Capture the Text that will be
searched for in the current notes view.
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ORCtrls, StdCtrls, ORFn, uTIU, fAutoSz, VA508AccessibilityManager;

type
  TfrmNotesSearchText = class(TfrmAutoSz)
    lblSearchInfo: TLabel;
    edtSearchText: TEdit;
    lblAuthor: TLabel;
    cmdOK: TButton;
    cmdCancel: TButton;
    procedure cmdCancelClick(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    FChanged: Boolean;
    FSearchString: string;
  end;

  TSearchContext = record
    Changed: Boolean;
    SearchString: string;
  end;

procedure SelectSearchText(FontSize: Integer; var SearchText: String; var SearchContext: TSearchContext; FormCaption: String = 'List Signed Notes by Author');

implementation

{$R *.DFM}

uses rTIU, rCore, uCore, rMisc, VAUtils;

const
  TX_SEARCH_TEXT = 'Select a search string or press Cancel.';
  TX_SEARCH_CAP = 'Missing search string';

procedure SelectSearchText(FontSize: Integer; var SearchText: String; var SearchContext: TSearchContext; FormCaption: String = 'List Signed Notes by Author');
{ displays author select form for progress notes and returns a record of the selection }
var
  frmNotesSearchText: TfrmNotesSearchText;
  W, H: integer;
//  CurrentAuthor: Int64;
begin
  frmNotesSearchText := TfrmNotesSearchText.Create(Application);
  try
    frmNotesSearchText.Caption := FormCaption;
    with frmNotesSearchText do
    begin
      edtSearchText.Text:=SearchText;
      Font.Size := FontSize;
      W := ClientWidth;
      H := ClientHeight;
      ResizeToFont(FontSize, W, H);
//      ClientWidth  := W; pnlBase.Width  := W;
//      ClientHeight := H; pnlBase.Height := W;
      FChanged := False;
      Show;
      edtSearchText.SetFocus;
      Hide;
      ShowModal;
      If edtSearchText.Text<>'' then
      with SearchContext do
      begin
        Changed := FChanged;
        SearchString := FSearchString;
      end; {with SearchContext}
    end; {with frmNotesSearchText}
  finally
    frmNotesSearchText.Release;
  end;
end;

procedure TfrmNotesSearchText.cmdCancelClick(Sender: TObject);
begin
  FChanged:=False;
  Close;
end;

procedure TfrmNotesSearchText.cmdOKClick(Sender: TObject);
begin
  if edtSearchText.Text = '' then
  begin
    InfoBox(TX_SEARCH_TEXT, TX_SEARCH_CAP, MB_OK or MB_ICONWARNING);
    Exit;
  end;
  FChanged := True;
  FSearchString := edtSearchText.Text;
  Close;
end;

procedure TfrmNotesSearchText.FormShow(Sender: TObject);
begin
  SetFormPosition(Self);
end;

procedure TfrmNotesSearchText.FormDestroy(Sender: TObject);
begin
  SaveUserBounds(Self);
end;

procedure TfrmNotesSearchText.FormResize(Sender: TObject);
begin
  inherited;
  lblSearchInfo.Width := edtSearchText.Width;
end;

end.
