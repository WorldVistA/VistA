unit fNotesBP;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, StdCtrls, ExtCtrls, VA508AccessibilityManager;

type
  TfrmNotesBP = class(TfrmAutoSz)
    Label1: TStaticText;
    btnPanel: TPanel;
    cmdPreview: TButton;
    cmdClose: TButton;
    grpOptions: TGroupBox;
    radReplace: TRadioButton;
    radAppend: TRadioButton;
    radIgnore: TRadioButton;
    procedure cmdPreviewClick(Sender: TObject);
    procedure cmdCloseClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure grpOptionsEnter(Sender: TObject);
    procedure radIgnoreExit(Sender: TObject);
    procedure radAppendExit(Sender: TObject);
    procedure radReplaceExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FBPText: TStrings;
  public
    { Public declarations }
  end;

function QueryBoilerPlate(BPText: TStrings): Integer;

implementation

{$R *.DFM}

uses ORFn, fRptBox, VAUtils;

function QueryBoilerPlate(BPText: TStrings): Integer;
var
  frmNotesBP: TfrmNotesBP;
  radIndex: integer;
begin
  frmNotesBP := TfrmNotesBP.Create(Application);
  try
    ResizeFormToFont(TForm(frmNotesBP));
    with frmNotesBP do
    begin
//      Result := 0;
      FBPText := BPText;
      ShowModal;
      radIndex:= 0; //radIgnore.checked
      if radAppend.checked then radIndex := 1;
      if radReplace.checked then radIndex := 2;
      Result := radIndex;
    end;
  finally
    frmNotesBP.Release;
  end;
end;

procedure TfrmNotesBP.cmdPreviewClick(Sender: TObject);
begin
  inherited;
  ReportBox(FBPText, 'Boilerplate Text Preview', False);
end;

procedure TfrmNotesBP.cmdCloseClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TfrmNotesBP.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = VK_ESCAPE then begin
    Key := 0;
    radIgnore.Checked := true; //Ignore
    Close;
  end;
end;

procedure TfrmNotesBP.FormShow(Sender: TObject);
begin
  inherited;
  radIgnore.SetFocus;
end;

procedure TfrmNotesBP.grpOptionsEnter(Sender: TObject);
begin
  inherited;
  if TabisPressed then
  begin
    if radReplace.Checked then radReplace.SetFocus;
    if radAppend.Checked then radAppend.SetFocus;
    if radIgnore.Checked then radIgnore.SetFocus;
  end;
end;

procedure TfrmNotesBP.radAppendExit(Sender: TObject);
begin
  inherited;
  if ShiftTabisPressed then cmdClose.SetFocus;
end;

procedure TfrmNotesBP.radIgnoreExit(Sender: TObject);
begin
  inherited;
  if ShiftTabisPressed then cmdClose.SetFocus;
end;

procedure TfrmNotesBP.radReplaceExit(Sender: TObject);
begin
  inherited;
  if ShiftTabisPressed then cmdClose.SetFocus;
end;

end.
