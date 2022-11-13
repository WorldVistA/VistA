unit fODLabOthSpec;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ORCtrls, StdCtrls, ORFn, fBase508Form, VA508AccessibilityManager;

type
  TfrmODLabOthSpec = class(TfrmBase508Form)
    pnlBase: TORAutoPanel;
    cboOtherSpec: TORComboBox;
    cmdOK: TButton;
    cmdCancel: TButton;
    procedure cmdCancelClick(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure cboOtherSpecDblClick(Sender: TObject);
    procedure cboOtherSpecNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
  private
    FOtherSpec: string;
  end;

function SelectOtherSpecimen(FontSize: Integer; SpecimenList: TStringList): string ;

implementation

{$R *.DFM}

uses fODLab, rODLab;

const
  TX_NOSPEC_TEXT = 'Select a specimen or press Cancel.';
  TX_NOSPEC_CAP = 'Missing Specimen';

function SelectOtherSpecimen(FontSize: Integer; SpecimenList: TStringList): string ;
{ displays collection sample select form for lab and returns a record of the selection }
var
  frmODLabOthSpec: TfrmODLabOthSpec;
  W, H: Integer;
begin
  frmODLabOthSpec := TfrmODLabOthSpec.Create(Application);
  try
    with frmODLabOthSpec do
    begin
      Font.Size := FontSize;
      W := ClientWidth;
      H := ClientHeight;
      ResizeToFont(FontSize, W, H);
      ClientWidth  := W; pnlBase.Width  := W;
      ClientHeight := H; pnlBase.Height := H;
      with cboOtherSpec do
        begin
          {FastAssign(SpecimenList, MItems);
          InsertSeparator; }
          InitLongList('');
        end;
      ShowModal;
      Result := FOtherSpec;
    end;
  finally
    frmODLabOthSpec.Release;
  end;
end;

procedure TfrmODLabOthSpec.cmdCancelClick(Sender: TObject);
begin
  FOtherSpec := '-1'  ;
  Close;
end;

procedure TfrmODLabOthSpec.cmdOKClick(Sender: TObject);
begin
  if cboOtherSpec.ItemIEN = 0 then
   begin
    InfoBox(TX_NOSPEC_TEXT, TX_NOSPEC_CAP, MB_OK or MB_ICONWARNING);
    Exit;
   end;
  if cboOtherSpec.ItemIEN > 0 then
     FOtherSpec := cboOtherSpec.Items[cboOtherSpec.ItemIndex]
  else
     FOtherSpec := '-1'  ;
  Close;
end;

procedure TfrmODLabOthSpec.cboOtherSpecDblClick(Sender: TObject);
begin
  cmdOKClick(Self);
end;

procedure TfrmODLabOthSpec.cboOtherSpecNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
var
  Dest: TStrings;
begin
  inherited;
  Dest := TStringList.Create;
  try
    setSubsetOfSpecimens(Dest, StartFrom, Direction);
    cboOtherSpec.ForDataUse(Dest);
  finally
    Dest.Free;
  end;
end;

end.
