unit fPCEOther;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, ORFn, ORCtrls, StdCtrls, VA508AccessibilityManager;

type
  TfrmPCEOther = class(TfrmAutoSz)
    cmdCancel: TButton;
    cmdOK: TButton;
    cboOther: TORComboBox;
    procedure cmdOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure cboOtherDblClick(Sender: TObject);
    procedure cboOtherChange(Sender: TObject);
  private
    fOtherApp: Integer;
    FCode:   string;
    procedure SetApp(OtherApp: Integer);
  public
    { Public declarations }
  end;


procedure OtherLookup(var Code: string; OtherApp: Integer);

implementation

{$R *.DFM}

uses rPCE, fEncounterFrame;

procedure OtherLookup(var Code: string; OtherApp: Integer);
var
  frmPCEOther: TfrmPCEOther;
begin
  frmPCEOther := TfrmPCEOther.Create(Application);
  try
    ResizeFormToFont(TForm(frmPCEOther));
    frmPCEOther.SetApp(OtherApp);
    frmPCEOther.ShowModal;
    Code := frmPCEOther.FCode;
  finally
    frmPCEOther.Free;
  end;
end;

procedure TfrmPCEOther.SetApp(OtherApp: Integer);
begin
  fOtherApp := OtherApp;
  case OtherApp of
    PCE_IMM: Caption := 'Other Immunizations';
    PCE_SK:  Caption := 'Other Skin Tests';
    PCE_PED: Caption := 'Other Education Topics';
//    PCE_HF:  Caption := 'Other Health Factors';
    PCE_XAM: Caption := 'Other Examinations';

  end;
  cboOther.Caption := Caption;
  LoadcboOther(cboOther.Items, uEncPCEData.Location, OtherApp);
end;


procedure TfrmPCEOther.cmdOKClick(Sender: TObject);
begin
  inherited;
  with cboOther do
  begin
    if ItemIndex = -1 then Exit;
    FCode := CboOther.Items[ItemIndex];
//
    Close;
  end;
end;

procedure TfrmPCEOther.FormCreate(Sender: TObject);
begin
  inherited;
  FCode := '';
end;


procedure TfrmPCEOther.cmdCancelClick(Sender: TObject);
begin
  inherited;
  fCode := '';
  close();
end;

procedure TfrmPCEOther.cboOtherDblClick(Sender: TObject);
begin
  inherited;
  cmdOKClick(Sender);
end;

procedure TfrmPCEOther.cboOtherChange(Sender: TObject);
begin
  inherited;
  cmdOK.Enabled := (cboOther.ItemIndex >= 0);
end;

end.
