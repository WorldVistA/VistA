unit fODLabOthCollSamp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ORCtrls, StdCtrls, ORFn, fBase508Form, VA508AccessibilityManager;

type
  TfrmODLabOthCollSamp = class(TfrmBase508Form)
    pnlBase: TORAutoPanel;
    cboOtherCollSamp: TORComboBox;
    cmdOK: TButton;
    cmdCancel: TButton;
    procedure cmdCancelClick(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure cboOtherCollSampDblClick(Sender: TObject);
  private
    FOtherCollSamp: string;
  end;

function SelectOtherCollSample(FontSize: Integer; Skip: integer; CollSampList: TList): string ;

implementation

{$R *.DFM}

uses fODLab, rODLab;

const
  TX_NOCOLLSAMP_TEXT = 'Select a collection sample or press Cancel.';
  TX_NOCOLLSAMP_CAP = 'Missing Collection Sample';

function SelectOtherCollSample(FontSize: Integer; Skip: integer; CollSampList: TList): string ;
{ displays collection sample select form for lab and returns a record of the selection }
var
  frmODLabOthCollSamp: TfrmODLabOthCollSamp;
  W, H, i: Integer;
  x: string;
begin
  frmODLabOthCollSamp := TfrmODLabOthCollSamp.Create(Application);
  try
    with frmODLabOthCollSamp do
    begin
      Font.Size := FontSize;
      W := ClientWidth;
      H := ClientHeight;
      ResizeToFont(FontSize, W, H);
      ClientWidth  := W; pnlBase.Width  := W;
      ClientHeight := H; pnlBase.Height := H;
      with CollSampList do for i := Skip to Count-1 do with TCollSamp(Items[i]) do
        begin
          x := IntToStr(CollSampID) + '^' + CollSampName;
          if Length(TubeColor) <> 0 then x := x + ' (' + TubeColor + ')';
          cboOtherCollSamp.Items.Add(x) ;
        end;
      ShowModal;
      Result := FOtherCollSamp;
    end;
  finally
    frmODLabOthCollSamp.Release;
  end;
end;

procedure TfrmODLabOthCollSamp.cmdCancelClick(Sender: TObject);
begin
  FOtherCollSamp := '-1'  ;
  Close;
end;

procedure TfrmODLabOthCollSamp.cmdOKClick(Sender: TObject);
begin
  if cboOtherCollSamp.ItemIEN = 0 then
   begin
    InfoBox(TX_NOCOLLSAMP_TEXT, TX_NOCOLLSAMP_CAP, MB_OK or MB_ICONWARNING);
    Exit;
   end;
  if cboOtherCollSamp.ItemIEN > 0 then
     FOtherCollSamp := cboOtherCollSamp.Items[cboOtherCollSamp.ItemIndex]
  else
     FOtherCollSamp := '-1'  ;
  Close;
end;

procedure TfrmODLabOthCollSamp.cboOtherCollSampDblClick(Sender: TObject);
begin
  cmdOKClick(Self);
end;

end.
