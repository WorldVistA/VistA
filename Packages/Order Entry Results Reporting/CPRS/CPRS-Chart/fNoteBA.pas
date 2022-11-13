unit fNoteBA;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ORCtrls, StdCtrls, ORFn, uTIU, fBase508Form,
  VA508AccessibilityManager;

type
  TfrmNotesByAuthor = class(TfrmBase508Form)
    pnlBase: TORAutoPanel;
    lblAuthor: TLabel;
    radSort: TRadioGroup;
    cboAuthor: TORComboBox;
    cmdOK: TButton;
    cmdCancel: TButton;
    procedure cboAuthorNeedData(Sender: TObject; const StartFrom: string;
      Direction, InsertAt: Integer);
    procedure cmdCancelClick(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
  private
    FChanged: Boolean;
    FAuthor: Int64;
    FAuthorName: string;
    FAscending: Boolean;
  end;

  TAuthorContext = record
    Changed: Boolean;
    Author: Int64;
    AuthorName: string;
    Ascending: Boolean;
  end;

procedure SelectAuthor(FontSize: Integer; CurrentContext: TTIUContext; var AuthorContext: TAuthorContext);

implementation

{$R *.DFM}

uses rTIU, rCore, uCore, uSimilarNames;

const
  TX_AUTH_TEXT = 'Select a progress note author or press Cancel.';
  TX_AUTH_CAP = 'Missing Author';

procedure SelectAuthor(FontSize: Integer; CurrentContext: TTIUContext; var AuthorContext: TAuthorContext);
{ displays author select form for progress notes and returns a record of the selection }
var
  frmNotesByAuthor: TfrmNotesByAuthor;
  W, H: integer;
  CurrentAuthor: Int64;
begin
  frmNotesByAuthor := TfrmNotesByAuthor.Create(Application);
  try
    with frmNotesByAuthor do
    begin
      Font.Size := FontSize;
      W := ClientWidth;
      H := ClientHeight;
      ResizeToFont(FontSize, W, H);
      ClientWidth  := W; pnlBase.Width  := W;
      ClientHeight := H; pnlBase.Height := W;
      FChanged := False;
      CurrentAuthor := CurrentContext.Author;
      with cboAuthor do
        if CurrentAuthor > 0 then
          begin
            InitLongList(ExternalName(CurrentAuthor, 200));
            SelectByIEN(CurrentAuthor);
          end
        else
          begin
            InitLongList(User.Name);
            SelectByIEN(User.DUZ);
          end;
      TSimilarNames.RegORComboBox(cboAuthor);
      FAscending := CurrentContext.TreeAscending;
      with radSort do if FAscending then ItemIndex := 0 else ItemIndex := 1;
      ShowModal;
      with AuthorContext do
      begin
        Changed := FChanged;
        Author := FAuthor;
        AuthorName := FAuthorName;
        Ascending := FAscending;
      end; {with AuthorContext}
    end; {with frmNotesByAuthor}
  finally
    frmNotesByAuthor.Release;
  end;
end;

procedure TfrmNotesByAuthor.cboAuthorNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
var
  sl: TStrings;
begin
  sl := TSTringList.Create;
  try
    setSubSetOfActiveAndInactivePersons(cboAuthor, sl, StartFrom, Direction);
    cboAuthor.ForDataUse(sl);
  finally
    sl.Free;
  end;
end;

procedure TfrmNotesByAuthor.cmdCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmNotesByAuthor.cmdOKClick(Sender: TObject);
var
  ErrMsg: string;

begin
  if cboAuthor.ItemIEN = 0 then
  begin
    InfoBox(TX_AUTH_TEXT, TX_AUTH_CAP, MB_OK or MB_ICONWARNING);
    Exit;
  end;
  if not CheckForSimilarName(cboAuthor, ErrMsg, sPr) then
  begin
    ShowMsgOn(ErrMsg <> '', ErrMsg, 'List Note by Author Error');
    Exit;
  end;

  FChanged := True;
  FAuthor := cboAuthor.ItemIEN;
  FAuthorName := cboAuthor.DisplayText[cboAuthor.ItemIndex];
  FAscending := radSort.ItemIndex = 0;
  Close;
end;

end.
