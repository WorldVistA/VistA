unit fDefaultEvent;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ORCtrls, ExtCtrls, rOrders, ORFn, uCore, fBase508Form,
  VA508AccessibilityManager;

type
  TfrmDefaultEvent = class(TfrmBase508Form)
    pnlTop: TPanel;
    lblCaption: TLabel;
    cboEvents: TORComboBox;
    pnlBottom: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    OKPressed: boolean;
    FDefaultEvtName:    string;
    FPreDefaultEvtID:   string;
    FPreDefaultEvtName: string;
  public
    { Public declarations }
  end;

function ExcueteDefaultEvntSetting: string;

var
  frmDefaultEvent: TfrmDefaultEvent;

implementation

uses VAUtils;

{$R *.DFM}

function ExcueteDefaultEvntSetting: string;
var
  frmDefaultEvent: TfrmDefaultEvent;
begin
  frmDefaultEvent := TfrmDefaultEvent.Create(Application);
  try
    ResizeAnchoredFormToFont(frmDefaultEvent);
    frmDefaultEvent.ShowModal;
    Result := frmDefaultEvent.FDefaultEvtName;
  finally
    frmDefaultEvent.Free;
  end;
end;

procedure TfrmDefaultEvent.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmDefaultEvent.FormCreate(Sender: TObject);
var
  i : integer;
begin
  FPreDefaultEvtID    := '';
  FPreDefaultEvtName  := '';
  FDefaultEvtName     := '';
  FPreDefaultEvtID := GetDefaultEvt(IntToStr(User.DUZ));
  ListSpecialtiesED(#0,cboEvents.Items);
  with cboEvents do
  begin
    for i := 0 to Items.Count - 1 do
    begin
      if FPreDefaultEvtID = Piece(Items[i],'^',1) then
      begin
        ItemIndex := i;
        FPreDefaultEvtName := Piece(Items[i],'^',9);
        if Length(FPreDefaultEvtName)<1 then
          FPreDefaultEvtName := Piece(Items[i],'^',2);
        break;
      end;
    end;
  end;
  OKPressed := False;
end;

procedure TfrmDefaultEvent.btnOKClick(Sender: TObject);
const
  TXT_1 = 'Would you like to change the default event from "';
  TXT_2 = '" to "';
  TXT_3 = 'Would you like set your default event to "';
var
  errMsg: string;
begin
  if cboEvents.ItemIndex < 0 then
  begin
    ShowMsg('You have to select an event first!');
    Exit;
  end;
  if (Piece(cboEvents.Items[cboEvents.ItemIndex],'^',1) <> FPreDefaultEvtID) and ( Length(FPreDefaultEvtID)>0 )then
  begin
    if InfoBox(TXT_1 + FPreDefaultEvtName + TXT_2 + cboEvents.Text + '"?','Warning', MB_OKCANCEL or MB_ICONWARNING) = IDOK then
    begin
      errMsg := '';
      SetDefaultEvent(errMsg, Piece(cboEvents.Items[cboEvents.ItemIndex],'^',1));
      if length(errMsg)>0 then
        ShowMsg(errMsg)
      else
        ShowMsg('The default release event "' + cboEvents.Text + '" has been set successfully!');
      FDefaultEvtName := cboEvents.Text;
      OKPressed := True;
      Close;
    end;
  end
  else if (Piece(cboEvents.Items[cboEvents.ItemIndex],'^',1) <> FPreDefaultEvtID) and ( Length(FPreDefaultEvtID)=0 )then
  begin
    if InfoBox(TXT_3 + cboEvents.Text + '"?','Warning', MB_OKCANCEL or MB_ICONWARNING) = IDOK then
    begin
      errMsg := '';
      SetDefaultEvent(errMsg, Piece(cboEvents.Items[cboEvents.ItemIndex],'^',1));
      if length(errMsg)>0 then
        ShowMsg(errMsg)
      else
        ShowMsg('The default release event "' + cboEvents.Text + '" has been set successfully!');
     FDefaultEvtName := cboEvents.Text;
     OKPressed := True;
     Close;
    end;
  end;
end;

end.
