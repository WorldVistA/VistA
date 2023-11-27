unit fTemplateImport;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Gauges, StdCtrls, ComCtrls, fBase508Form, VA508AccessibilityManager;

type
  TfrmTemplateImport = class(TfrmBase508Form)
    animImport: TAnimate;
    btnCancel: TButton;
    lblImporting: TStaticText;
    gaugeImport: TGauge;
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure StartImportMessage(AFileName: string; MaxCount: integer);
function UpdateImportMessage(CurrentCount: integer): boolean;
procedure StopImportMessage;

implementation

{$R *.DFM}

uses
  ORFn, UResponsiveGUI;

var
  frmTemplateImport: TfrmTemplateImport = nil;

procedure StartImportMessage(AFileName: string; MaxCount: integer);
begin
  if not assigned(frmTemplateImport) then
  begin
    frmTemplateImport := TfrmTemplateImport.Create(Application);
    ResizeAnchoredFormToFont(frmTemplateImport);
    with frmTemplateImport do
    begin
      lblImporting.Caption := lblImporting.Caption + AFileName;
      lblImporting.Hint := lblImporting.Caption;
      gaugeImport.MaxValue := MaxCount;
      Show;
      TResponsiveGUI.ProcessMessages(True);
    end;
  end;
end;

function UpdateImportMessage(CurrentCount: integer): boolean;
begin
  if assigned(frmTemplateImport) then
  begin
    Result := (not frmTemplateImport.btnCancel.Enabled);
    if not Result then
    begin
      frmTemplateImport.gaugeImport.Progress := CurrentCount;
      TResponsiveGUI.ProcessMessages(True);
    end;  
  end
  else
    Result := TRUE;
end;

procedure StopImportMessage;
begin
  if assigned(frmTemplateImport) then
    FreeAndNil(frmTemplateImport);
end;


procedure TfrmTemplateImport.btnCancelClick(Sender: TObject);
begin
  lblImporting.Caption := 'Canceling...';
  btnCancel.Enabled := FALSE;
  TResponsiveGUI.ProcessMessages(True);
end;

end.
