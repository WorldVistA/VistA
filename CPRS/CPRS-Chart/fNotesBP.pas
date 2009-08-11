unit fNotesBP;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, StdCtrls, ExtCtrls, VA508AccessibilityManager;

type
  TfrmNotesBP = class(TfrmAutoSz)
    Label1: TStaticText;
    radOptions: TRadioGroup;
    btnPanel: TPanel;
    cmdPreview: TButton;
    cmdClose: TButton;
    procedure cmdPreviewClick(Sender: TObject);
    procedure cmdCloseClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FBPText: TStrings;
  public
    { Public declarations }
  end;

function QueryBoilerPlate(BPText: TStrings): Integer;

implementation

{$R *.DFM}

uses ORFn, fRptBox;

function QueryBoilerPlate(BPText: TStrings): Integer;
var
  frmNotesBP: TfrmNotesBP;
begin
  frmNotesBP := TfrmNotesBP.Create(Application);
  try
    ResizeFormToFont(TForm(frmNotesBP));
    with frmNotesBP do
    begin
      FBPText := BPText;
      ShowModal;
      Result := radOptions.ItemIndex;
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
    radOptions.ItemIndex := 0; //Ignore
    Close;
  end;
end;

end.
