unit fLkUpLocation;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, StdCtrls, ORCtrls, ORFn, VA508AccessibilityManager;

type
  TfrmLkUpLocation = class(TfrmAutoSz)
    lblInfo: TLabel;
    cboLocation: TORComboBox;
    lblLocation: TLabel;
    cmdOK: TButton;
    cmdCancel: TButton;
    procedure cmdCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure cboLocationNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
  private
    OKPressed: Boolean;
  end;

var
  LocType:   integer;


procedure LookupLocation(var IEN: Integer; var AName: string; const AType: integer; const HelpInfo: string);

implementation

{$R *.DFM}

uses rCore, uConst;

procedure LookupLocation(var IEN: Integer; var AName: string; const AType: integer; const HelpInfo: string);
var
  frmLkUpLocation: TfrmLkUpLocation;
begin
  LocType := AType;
  frmLkUpLocation := TfrmLkUpLocation.Create(Application);
  try
    ResizeFormToFont(TForm(frmLkUpLocation));
    frmLkUpLocation.lblInfo.Caption := HelpInfo;
    frmLkUpLocation.ShowModal;
    IEN := 0;
    AName := '';
    if frmLkUpLocation.OKPressed then
    begin
      IEN := frmLkUpLocation.cboLocation.ItemIEN;
      AName := frmLkUpLocation.cboLocation.Text;
    end;
  finally
    frmLkUpLocation.Release;
  end;
end;

procedure TfrmLkUpLocation.FormCreate(Sender: TObject);
begin
  inherited;
  OKPressed := False;
  cboLocation.InitLongList('');
end;

procedure TfrmLkUpLocation.cboLocationNeedData(Sender: TObject; const StartFrom: string;
  Direction, InsertAt: Integer);
var
  Dest: TStrings;
begin
  inherited;
    Dest := TStringList.Create;
    try
    case LocType of
      LOC_ALL:   setSubSetOfLocations(Dest,StartFrom, Direction);
      LOC_OUTP:  setSubSetOfClinics(Dest,StartFrom, Direction);
      LOC_INP:   setSubSetOfInpatientLocations(Dest,StartFrom, Direction);
    end;
      cboLocation.ForDataUse(Dest);
    finally
      Dest.Free;
    end;
end;

procedure TfrmLkUpLocation.cmdOKClick(Sender: TObject);
begin
  inherited;
  OKPressed := True;
  Close;
end;

procedure TfrmLkUpLocation.cmdCancelClick(Sender: TObject);
begin
  inherited;
  Close;
end;

end.
