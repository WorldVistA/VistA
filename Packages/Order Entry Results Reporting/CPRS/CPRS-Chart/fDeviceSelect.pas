unit fDeviceSelect;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, fAutoSz, ORCtrls, ORNet, Mask, ExtCtrls, VA508AccessibilityManager;

type
  TfrmDeviceSelect = class(TfrmAutoSz)
    grpDevice: TGroupBox;
    cboDevice: TORComboBox;
    pnlBottom: TPanel;
    cmdOK: TButton;
    cmdCancel: TButton;
    chkDefault: TCheckBox;
    pnlGBBottom: TPanel;
    lblMargin: TLabel;
    txtRightMargin: TMaskEdit;
    lblLength: TLabel;
    txtPageLength: TMaskEdit;
    procedure cboDeviceChange(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure cboDeviceNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    FWinPrint: Boolean;
  end;

var
  frmDeviceSelect: TfrmDeviceSelect;
  ADevice: string;

function SelectDevice(Sender: TObject; ALocation: integer; AllowWindowsPrinter: boolean; ACaption: String): string ;

implementation

{$R *.DFM}

uses ORFn, rCore, uCore, rReports, Printers, fFrame, rMisc;

const
  TX_NODEVICE = 'A device must be selected to print, or press ''Cancel'' to not print.';
  TX_NODEVICE_CAP = 'Device Not Selected';
  TX_ERR_CAP = 'Print Error';

function SelectDevice(Sender: TObject; ALocation: integer; AllowWindowsPrinter: boolean; ACaption: String): string ;
{ displays a form that prompts for a device}
var
  frmDeviceSelect: TfrmDeviceSelect;
  DefPrt: string;
begin
  frmDeviceSelect := TfrmDeviceSelect.Create(Application);
  try
    with frmDeviceSelect do
      begin
        FWinPrint := AllowWindowsPrinter;
        with cboDevice do
          begin
            if (FWinPrint) and (Printer.Printers.Count > 0) then
              begin
                Items.Add('WIN;Windows Printer^Windows Printer');
                Items.Add('^--------------------VistA Printers----------------------');
              end;
          end;

            DefPrt := User.CurrentPrinter;
            if DefPrt = '' then DefPrt := GetDefaultPrinter(User.Duz, Encounter.Location);
            if DefPrt <> '' then
              begin
                if (not FWinPrint) then
                  begin
                    if (DefPrt <> 'WIN;Windows Printer') then
                      begin
                        cboDevice.InitLongList(Piece(DefPrt, ';', 2));
                        cboDevice.SelectByID(DefPrt);
                      end
                    else
                      cboDevice.InitLongList('');
                  end
                else if FWinprint then
                  begin
                    cboDevice.InitLongList(Piece(DefPrt, ';', 2));
                    cboDevice.SelectByID(DefPrt);
                  end;
                  end
              else
              begin
                cboDevice.InitLongList('');
              end;
           if ACaption<>'' then frmDeviceSelect.Caption:=ACaption;
         
        ShowModal;
        Result := ADevice;
        //Result := Piece(ADevice, ';', 1) + U + Piece(ADevice, U, 2);
      end;
  finally
    frmDeviceSelect.Release;
  end;
end;

procedure TfrmDeviceSelect.cboDeviceChange(Sender: TObject);
begin
inherited;
  with cboDevice do if ItemIndex > -1 then
  begin
    txtRightMargin.Text := Piece(Items[ItemIndex], '^', 4);
    txtPageLength.Text := Piece(Items[ItemIndex], '^', 5);
  end;
end;

procedure TfrmDeviceSelect.cmdOKClick(Sender: TObject);
begin
  inherited;
  if (cboDevice.ItemID = '') or (cboDevice.ItemIndex < 0) then
  begin
    InfoBox(TX_NODEVICE, TX_NODEVICE_CAP, MB_OK);
    Exit;
  end;
  ADevice := cboDevice.Items[cboDevice.ItemIndex];
  if chkDefault.Checked then begin
   SaveDefaultPrinter(Piece(cboDevice.ItemID, ';', 1));
   User.CurrentPrinter := cboDevice.ItemID;
  end;
  Close;
end;

procedure TfrmDeviceSelect.cmdCancelClick(Sender: TObject);
begin
  inherited;
  ADevice := User.CurrentPrinter;
  Close;
end;

procedure TfrmDeviceSelect.cboDeviceNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
var
  sl: TSTrings;
begin
  inherited;
  sl := TStringList.Create;
  try
    setSubsetOfDevices(sl,StartFrom, Direction);
    cboDevice.ForDataUse(sl);
  finally
    sl.Free;
  end;
end;

procedure TfrmDeviceSelect.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  SaveUserBounds(Self);
end;

procedure TfrmDeviceSelect.FormCreate(Sender: TObject);
begin
  inherited;
  ResizeFormToFont(Self);
  SetFormPosition(Self);
end;

end.
