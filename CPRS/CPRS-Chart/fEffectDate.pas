unit fEffectDate;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, Grids, Calendar, ORDtTmCal, StdCtrls, ORDtTm, ORFn,
  VA508AccessibilityManager;

type
  TfrmEffectDate = class(TfrmAutoSz)
    calEffective: TORDateBox;
    Label2: TLabel;
    Label3: TStaticText;
    Label4: TStaticText;
    cmdOK: TButton;
    cmdCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
  private
    OKPressed: Boolean;
  end;

function ObtainEffectiveDate(var ADate: TFMDateTime): Boolean;

implementation

{$R *.DFM}

function ObtainEffectiveDate(var ADate: TFMDateTime): Boolean;
var
  frmEffectDate: TfrmEffectDate;
begin
  Result := False;
  frmEffectDate := TfrmEffectDate.Create(Application);
  try
    ResizeFormToFont(TForm(frmEffectDate));
    if ADate <> 0 then frmEffectDate.calEffective.FMDateTime := ADate;
    frmEffectDate.ShowModal;
    if frmEffectDate.OKPressed then
    begin
      ADate  := frmEffectDate.calEffective.FMDateTime;
      Result := True;
    end;
  finally
    frmEffectDate.Release;
  end;
end;

procedure TfrmEffectDate.FormCreate(Sender: TObject);
begin
  inherited;
  OKPressed := False;
end;

procedure TfrmEffectDate.cmdOKClick(Sender: TObject);
begin
  inherited;
  OKPressed := True;
  Close;
end;

procedure TfrmEffectDate.cmdCancelClick(Sender: TObject);
begin
  inherited;
  Close;
end;

end.
