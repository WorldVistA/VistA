unit fODMedOIFA;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ORCtrls, ExtCtrls, fAutoSz, fBase508Form, VA508AccessibilityManager;

type
  TfrmODMedOIFA = class(TfrmBase508Form)
    Label1: TLabel;
    lstFormAlt: TORListBox;
    Label2: TStaticText;
    btnPanel: TPanel;
    cmdYes: TButton;
    cmdNo: TButton;
    procedure FormCreate(Sender: TObject);
    procedure cmdYesClick(Sender: TObject);
    procedure cmdNoClick(Sender: TObject);
    procedure lstFormAltClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FSelected: string;
  end;

procedure CheckFormularyOI(var AnIEN: Integer; var AName: string; ForInpatient: Boolean);
procedure CheckFormularyDose(DispDrug: Integer; var OI: Integer; var OIName: string;
  ForInpatient: Boolean);

implementation

{$R *.DFM}

uses ORFn, rODMeds, rMisc, System.UITypes;

procedure CheckFormularyOI(var AnIEN: Integer; var AName: string; ForInpatient: Boolean);

const
  TX_NO_FORM_ALT = 'This drug is not in the formulary!' + CRLF +
                   'There are no formulary alternatives entered for this item.' + CRLF +
                   'Please consult with your pharmacy before ordering this item.';
  TC_NO_FORM_ALT = 'No Formulary Alternatives';

var
  frmODMedOIFA: TfrmODMedOIFA;
  FormAltList: TStringList;
begin
  FormAltList := TStringList.Create;
  try
    LoadFormularyAltOI(FormAltList, AnIEN, ForInpatient);
    if FormAltList.Count > 0 then
    begin
      frmODMedOIFA := TfrmODMedOIFA.Create(Application);
      try
        ResizeFormToFont(TForm(frmODMedOIFA));
        with frmODMedOIFA do
        begin
          FastAssign(FormAltList, lstFormAlt.Items);
          ShowModal;
          if Length(FSelected) > 0 then
          begin
            AnIEN := StrToIntDef(Piece(FSelected, U, 1), 0);
            AName := Piece(FSelected, U, 2);
          end;
        end; {with frmODMedOIFA}
      finally
        frmODMedOIFA.Release;
      end; {frmODMedOIFA}
    end
    else messageDlg(TX_NO_FORM_ALT,mtWarning, [mbOK],0);
  finally
    FormAltList.Free;
  end; {FormAltList}
end;

procedure CheckFormularyDose(DispDrug: Integer; var OI: Integer; var OIName: string;
  ForInpatient: Boolean);
var
  frmODMedOIFA: TfrmODMedOIFA;
  FormAltList: TStringList;
begin
  FormAltList := TStringList.Create;
  try
    LoadFormularyAltDose(FormAltList, DispDrug, OI, ForInpatient);
    if FormAltList.Count > 0 then
    begin
      frmODMedOIFA := TfrmODMedOIFA.Create(Application);
      try
        ResizeFormToFont(TForm(frmODMedOIFA));
        with frmODMedOIFA do
        begin
          FastAssign(FormAltList, lstFormAlt.Items);
          ShowModal;
          if Length(FSelected) > 0 then
          begin
            OI     := StrToIntDef(Piece(FSelected, U, 1), 0);
            OIName := Piece(FSelected, U, 2);
          end;
        end; {with frmODMedOIFA}
      finally
        frmODMedOIFA.Release;
      end; {frmODMedOIFA}
    end; {if FormAltList}
  finally
    FormAltList.Free;
  end; {FormAltList}
end;

procedure TfrmODMedOIFA.FormCreate(Sender: TObject);
begin
  inherited;
  FSelected := '';
end;

procedure TfrmODMedOIFA.lstFormAltClick(Sender: TObject);
begin
  inherited;
  if lstFormAlt.ItemIndex > -1 then cmdYes.Enabled := True;
end;

procedure TfrmODMedOIFA.cmdYesClick(Sender: TObject);
begin
  inherited;
  with lstFormAlt do if ItemIndex > -1 then FSelected := Items[ItemIndex];
  Close;
end;

procedure TfrmODMedOIFA.cmdNoClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TfrmODMedOIFA.FormShow(Sender: TObject);
begin
  inherited;
  SetFormPosition(Self);
end;

procedure TfrmODMedOIFA.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  SaveUserBounds(Self);  
end;

end.
