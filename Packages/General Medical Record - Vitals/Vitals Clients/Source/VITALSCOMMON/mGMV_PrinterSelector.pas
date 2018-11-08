unit mGMV_PrinterSelector;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, StdCtrls;

type
  TfrGMV_PrinterSelector = class(TFrame)
    Panel1: TPanel;
    edTarget: TEdit;
    lvDevices: TListView;
    tmDevice: TTimer;
    gbDevice: TGroupBox;
    procedure tmDeviceTimer(Sender: TObject);
    procedure edTargetChange(Sender: TObject);
    procedure edTargetKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lvDevicesChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure gbDeviceEnter(Sender: TObject);
    procedure gbDeviceExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    DeviceIEN,
    DeviceName:String;
    procedure ClearSelection;
  end;

implementation

{$R *.dfm}
uses uGMV_User, uGMV_Engine, uGMV_Common
  , uGMV_Const
  ;
procedure TfrGMV_PrinterSelector.tmDeviceTimer(Sender: TObject);
var
  s: String;
  i: Integer;
  sl: TStringList;
  LI: TListItem;
const
  SearchDirection = 1;
  Margin = '80-132';

begin
  tmDevice.Enabled := False;

  SL := TStringList.Create;
  try
    s := getDeviceList(uppercase(edTarget.Text),Margin,SearchDirection);
    SL.Text := S;
    lvDevices.Items.Clear;
    if sl.Count <> 0 then
      begin
        lvDevices.Enabled := True;
        for i := 0 to SL.Count-1 do
          begin
            if piece(SL[i],'^',1) = '' then continue;
            LI := lvDevices.Items.Add;
            LI.Caption := piece(SL[i],'^',1);
            LI.SubItems.Add(piece(SL[i],'^',2));
            LI.SubItems.Add(piece(SL[i],'^',4));
            LI.SubItems.Add(piece(SL[i],'^',5));
            LI.SubItems.Add(piece(SL[i],'^',6));
          end;
        lvDevices.SetFocus;

        lvDevices.ItemIndex := 0;
        lvDevices.ItemFocused := lvDevices.Selected;
      end
     else
       lvDevices.Enabled := False;
  except
  end;
  SL.Free;

end;

procedure TfrGMV_PrinterSelector.edTargetChange(Sender: TObject);
begin
  tmDevice.Enabled := True;
  ClearSelection;
end;

procedure TfrGMV_PrinterSelector.ClearSelection;
begin
  DeviceIEN := '';
  DeviceName := '';
//  lblDevice.Caption := 'No device selected';
  GetParentForm(self).Perform(CM_UPDATELOOKUP,0,0);
end;

procedure TfrGMV_PrinterSelector.edTargetKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    tmDeviceTimer(nil);
end;

procedure TfrGMV_PrinterSelector.lvDevicesChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
begin
  if lvDevices.Selected = nil then
      ClearSelection
  else
      try
        DeviceIEN := lvDevices.Selected.Caption;
        DeviceName := lvDevices.Selected.SubItems[0];

//        lblDevice.Caption := lvDevices.Selected.SubItems[0]+'  '+
//          lvDevices.Selected.SubItems[1]+' ' +
//          lvDevices.selected.SubItems[2]+'x' + lvDevices.Selected.SubItems[3];

        GetParentForm(self).Perform(CM_UPDATELOOKUP,0,0);

      except
        ClearSelection;
      end;
end;

procedure TfrGMV_PrinterSelector.gbDeviceEnter(Sender: TObject);
begin
  gbDevice.Font.Style := [fsBold];
  lvDevices.Font.Style := [];
  edTarget.Font.Style := [];
end;

procedure TfrGMV_PrinterSelector.gbDeviceExit(Sender: TObject);
begin
  gbDevice.Font.Style := [];
end;

end.
