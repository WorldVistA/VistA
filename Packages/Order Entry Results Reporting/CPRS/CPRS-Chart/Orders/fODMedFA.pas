unit fODMedFA;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, StdCtrls, ORCtrls, ORFn, VA508AccessibilityManager;

type
  TfrmODMedFA = class(TfrmAutoSz)
    Label1: TLabel;
    lstFormAlt: TORListBox;
    Label2: TStaticText;
    cmdYes: TButton;
    cmdNo: TButton;
    procedure lstFormAltClick(Sender: TObject);
    procedure cmdYesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cmdNoClick(Sender: TObject);
  private
    { Private declarations }
    FSelected: string;
  public
    { Public declarations }
  end;

procedure SelectFormularyAlt(AnIEN: Integer; var ADrug, AnOI: Integer;
  var ADrugName, AnOIName: string; PSType: Char);

implementation

{$R *.DFM}

uses rODBase;

const
  TX_NO_FORM_ALT = 'This drug is not in the formulary!' + CRLF +
                   'There are no formulary alternatives entered for this item.' + CRLF +
                   'Please consult with your pharmacy before ordering this item.';
  TC_NO_FORM_ALT = 'No Formulary Alternatives';

procedure SelectFormularyAlt(AnIEN: Integer; var ADrug, AnOI: Integer;
  var ADrugName, AnOIName: string; PSType: Char);
var
  frmODMedFA: TfrmODMedFA;
  FormAltList: TStringList;
begin
  ADrug := 0;
  AnOI  := 0;
  ADrugName := '';
  AnOIName  := '';
  FormAltList := TStringList.Create;
  try
    LoadFormularyAlt(FormAltList, AnIEN, PSType);
    if FormAltList.Count > 0 then
    begin
      frmODMedFA := TfrmODMedFA.Create(Application);
      try
        ResizeFormToFont(TForm(frmODMedFA));
        with frmODMedFA do
        begin
          FastAssign(FormAltList, lstFormAlt.Items);
          ShowModal;
          if Length(FSelected) > 0 then
          begin
            ADrug := StrToIntDef(Piece(FSelected, U, 1), 0);
            AnOI  := StrToIntDef(Piece(FSelected, U, 4), 0);
            ADrugName := Piece(FSelected, U, 2);
            AnOIName  := Piece(FSelected, U, 5);
          end;
        end;
      finally
        frmODMedFA.Release;
      end; {frmODMedFA}
    end
    else InfoBox(TX_NO_FORM_ALT, TC_NO_FORM_ALT, MB_OK);
  finally
    FormAltList.Free;
  end; {FormAltList}
end;

procedure TfrmODMedFA.FormCreate(Sender: TObject);
begin
  inherited;
  FSelected := '';
end;

procedure TfrmODMedFA.lstFormAltClick(Sender: TObject);
begin
  inherited;
  if lstFormAlt.ItemIndex > -1 then cmdYes.Enabled := True;
end;

procedure TfrmODMedFA.cmdYesClick(Sender: TObject);
begin
  inherited;
  with lstFormAlt do if ItemIndex > -1 then FSelected := Items[ItemIndex];
  Close;
end;

procedure TfrmODMedFA.cmdNoClick(Sender: TObject);
begin
  inherited;
  Close;
end;

end.
