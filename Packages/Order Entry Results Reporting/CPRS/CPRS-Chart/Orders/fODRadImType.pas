unit fODRadImType;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ORCtrls, ORfn, ExtCtrls, fBase508Form, VA508AccessibilityManager;

type
  TfrmODRadImType = class(TfrmBase508Form)
    cmdOK: TButton;
    cmdCancel: TButton;
    cboImType: TORComboBox;
    SrcLabel: TLabel;
    pnlBase: TORAutoPanel;
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure cboImTypeDblClick(Sender: TObject);
  private
    FImagingType: string  ;
    FChanged: Boolean;
  end;

procedure SelectImagingType(FontSize: Integer; var ImagingType: string) ;

implementation

{$R *.DFM}

uses rODRad, rCore, uCore;

const
  TX_RAD_TEXT = 'Select imaging type or press Cancel.';
  TX_RAD_CAP = 'No imaging type Selected';

procedure SelectImagingType(FontSize: Integer; var ImagingType: string) ;
{ displays imaging type selection form and returns a record of the selection }
var
  frmODRadImType: TfrmODRadImType;
  W, H: Integer;
begin
  frmODRadImType := TfrmODRadImType.Create(Application);
  try
    with frmODRadImType do
    begin
      Font.Size := FontSize;
      W := ClientWidth;
      H := ClientHeight;
      ResizeToFont(FontSize, W, H);
      ClientWidth  := W; pnlBase.Width  := W;
      ClientHeight := H; pnlBase.Height := H;
      FChanged := False;
      SubsetOfImagingTypes(cboImType.Items);
      if cboImType.Items.Count > 1 then
         ShowModal
      else if cboImType.Items.Count = 1 then
         FImagingType := cboImType.Items[0]
      else
         FImagingType := '';
      ImagingType:= FImagingType ;
    end; {with frmODRadImType}
  finally
    frmODRadImType.Release;
  end;
end;

procedure TfrmODRadImType.cmdCancelClick(Sender: TObject);
begin
  FImagingType := '-1';
  Close;
end;

procedure TfrmODRadImType.cmdOKClick(Sender: TObject);
begin
 with cboImType do
  begin
   if ItemIEN = 0 then
    begin
     InfoBox(TX_RAD_TEXT, TX_RAD_CAP, MB_OK or MB_ICONWARNING);
     FChanged := False ;
     FImagingType := '-1';
     Exit;
    end;
   FChanged := True;
   FImagingType := Items[ItemIndex];
   Close;
  end ;
end;

procedure TfrmODRadImType.cboImTypeDblClick(Sender: TObject);
begin
  cmdOKClick(Self);
end;

end.
