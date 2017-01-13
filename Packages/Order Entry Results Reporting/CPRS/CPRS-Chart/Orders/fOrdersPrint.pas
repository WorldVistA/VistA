unit fOrdersPrint;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ORCtrls, ORfn, ExtCtrls, rOrders, fFrame, fBase508Form,
  VA508AccessibilityManager;

type
  TfrmOrdersPrint = class(TfrmBase508Form)
    ckChartCopy: TCheckBox;
    ckLabels: TCheckBox;
    ckRequisitions: TCheckBox;
    ckWorkCopy: TCheckBox;
    lstChartDevice: TORListBox;
    lstLabelDevice: TORListBox;
    lstReqDevice: TORListBox;
    lstWorkDevice: TORListBox;
    cmdChart: TORAlignButton;
    cmdLabels: TORAlignButton;
    cmdReqs: TORAlignButton;
    cmdWork: TORAlignButton;
    cmdOK: TORAlignButton;
    cmdCancel: TORAlignButton;
    pnlBase: TORAutoPanel;
    lblDevice: TLabel;
    lblPartOne: TMemo;
    lblPart2: TMemo;
    procedure SetupControls(PrintParams: TPrintParams);
    procedure cmdChartClick(Sender: TObject);
    procedure cmdLabelsClick(Sender: TObject);
    procedure cmdReqsClick(Sender: TObject);
    procedure cmdWorkClick(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure ckChartCopyClick(Sender: TObject);
    procedure ckLabelsClick(Sender: TObject);
    procedure ckRequisitionsClick(Sender: TObject);
    procedure ckWorkCopyClick(Sender: TObject);
    procedure DeviceListClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FPrintIt: boolean;
    FSelectAll: boolean;
    FDevices: string;
    FNature: char;
    procedure SetupPrompting(CheckBox: TCheckBox; DeviceList: TORListBox; ChangeButton: TORAlignButton;
              PromptParam: char; DeviceParam: string);
  end;

var
  frmOrdersPrint: TfrmOrdersPrint;
  PrintParams: TPrintParams;
  AnyPrompts: boolean;
  ResultList: TStringList;

const
  NO_WIN_PRINT = False;

procedure SetupOrdersPrint(OrderList: TStringList; var DeviceInfo: string; Nature: Char; SelectAll: Boolean; var PrintIt: Boolean;
                           PrintTitle: string = ''; PrintLoc: Integer = 0);

implementation

{$R *.DFM}

uses
  fDeviceSelect, uCore, ORNet, fOrders, System.UITypes;

procedure SetupOrdersPrint(OrderList: TStringList; var DeviceInfo: string; Nature: Char; SelectAll: Boolean; var PrintIt: Boolean;
                           PrintTitle: string = ''; PrintLoc: Integer = 0);
{displays device and copy selection form for printing orders, and returns a record of the selections}
var
  frmOrdersPrint: TfrmOrdersPrint;
begin
  frmOrdersPrint := TfrmOrdersPrint.Create(Application);
  if PrintTitle <> '' then frmOrdersPrint.Caption := 'Print Orders for ' + PrintTitle;
  try
    frmFrame.CCOWBusy := True;
    ResizeFormToFont(TForm(frmOrdersPrint));
    with frmOrdersPrint do
    begin
      FSelectAll := SelectAll;
      FPrintIt := False;
      FNature := Nature;
      if Nature = #0 then
        begin
          cmdCancel.Caption := 'Cancel Print';
          lblPart2.Text := 'Greyed out items are not available.';
        end;
      OrderPrintDeviceInfo(OrderList, PrintParams, Nature, PrintLoc);
      SetupControls(PrintParams);
      if (PrintParams.AnyPrompts) {or FSelectAll} then ShowModal;
      DeviceInfo := FDevices;
      PrintIt := FPrintIt;
    end;
  finally
    frmFrame.CCOWBusy := False;
    frmOrdersPrint.Release;
  end;
end;

procedure TfrmOrdersPrint.SetupControls(PrintParams: TPrintParams);
begin
  with PrintParams do
    begin
      SetupPrompting(ckChartCopy   , lstChartDevice, cmdChart , PromptForChartCopy   , ChartCopyDevice);
      SetupPrompting(ckLabels      , lstLabelDevice, cmdLabels, PromptForLabels      , LabelDevice);
      SetupPrompting(ckRequisitions, lstReqDevice,   cmdReqs  , PromptForRequisitions, RequisitionDevice);
      SetupPrompting(ckWorkCopy    , lstWorkDevice,  cmdWork  , PromptForWorkCopy    , WorkCopyDevice);
      FDevices := lstChartDevice.ItemID + U +
                  lstLabelDevice.ItemID + U +
                  lstReqDevice.ItemID   + U +
                  lstWorkDevice.ItemID;
      FPrintIt := not (FDevices = '^^^');
    end;
end;

procedure TfrmOrdersPrint.SetupPrompting(CheckBox: TCheckBox; DeviceList: TORListBox; ChangeButton: TORAlignButton;
                                         PromptParam: char; DeviceParam: string);
{        0 - no prompts - copy is automatically generated.
             checkbox checked   and disabled,   device defaulted and button disabled
         1 - prompt for copy and ask which printer should be used.
             checkbox unchecked and enabled,    device defaulted and button enabled
         2 - prompt for copy and automatically print to the
             printer defined in the XXXXX COPY PRINT DEVICE field.
             checkbox unchecked and enabled,    device defaulted and button disabled
         * - don't print.
             checkbox unchecked and disabled,   device empty     and button disabled
}
begin
    case PromptParam of
      '0', #0: begin
                 CheckBox.Checked := DeviceParam <> '';
                 CheckBox.Enabled := False;
                 DeviceList.Clear;
                 if DeviceParam <> '' then
                   begin
                     DeviceList.Items.Add(DeviceParam);
                     DeviceList.Font.Color := clGrayText;
                     DeviceList.ItemIndex := 0;
                     CheckBox.Font.Style := CheckBox.Font.Style + [fsBold];
                     CheckBox.Font.Color := clInfoText;
                     CheckBox.Color := clInfoBk;
                   end
                 else
                   begin
                     CheckBox.State   := cbUnchecked;
                     CheckBox.Enabled := False;
                   end;
                 ChangeButton.Enabled := False;
               end;
      '1': begin
             CheckBox.State   := cbUnchecked;
             CheckBox.Enabled := True;
             DeviceList.Clear;
             if DeviceParam <> '' then DeviceList.Items.Add(DeviceParam);
             ChangeButton.Enabled := False;
           end;
      '2': begin
             CheckBox.State   := cbUnchecked;
             CheckBox.Enabled := True;
             DeviceList.Clear;
             if DeviceParam <> '' then
               DeviceList.Items.Add(DeviceParam)
             else
               begin
                 CheckBox.State   := cbUnchecked;
                 CheckBox.Enabled := False;
               end;
             ChangeButton.Enabled := False;
           end;
      '*': begin
             CheckBox.State   := cbUnchecked;
             CheckBox.Enabled := False;
             DeviceList.Clear;
             ChangeButton.Enabled := False;
           end;
    end;
end;

procedure TfrmOrdersPrint.cmdChartClick(Sender: TObject);
var
  x: string;
begin
  x := SelectDevice(Self, Encounter.Location, NO_WIN_PRINT,'');
  if x <> '' then with lstChartDevice do
    begin
      Clear;
      Items.Add(x);
    end;
end;

procedure TfrmOrdersPrint.cmdLabelsClick(Sender: TObject);
var
  x: string;
begin
  x := SelectDevice(Self, Encounter.Location, NO_WIN_PRINT,'');
  if x <> '' then with lstLabelDevice do
    begin
      Clear;
      Items.Add(x);
    end;
end;

procedure TfrmOrdersPrint.cmdReqsClick(Sender: TObject);
var
  x: string;
begin
  x := SelectDevice(Self, Encounter.Location, NO_WIN_PRINT,'');
  if x <> '' then with lstReqDevice do
    begin
      Clear;
      Items.Add(x);
    end;
end;

procedure TfrmOrdersPrint.cmdWorkClick(Sender: TObject);
var
  x: string;
begin
  x := SelectDevice(Self, Encounter.Location, NO_WIN_PRINT,'');
  if x <> '' then with lstWorkDevice do
    begin
      Clear;
      Items.Add(x);
    end;
end;

procedure TfrmOrdersPrint.cmdOKClick(Sender: TObject);
const
  TX_NO_SELECTION     = 'No copies were selected for printing.  Check a copy type, or Cancel.';
  TX_NO_SELECTION_CAP = 'Nothing Selected!';
begin
  if not ckChartCopy.Checked    then lstChartDevice.ItemIndex := -1 else lstChartDevice.ItemIndex := 0;
  if not ckLabels.Checked       then lstLabelDevice.ItemIndex := -1 else lstLabelDevice.ItemIndex := 0;
  if not ckRequisitions.Checked then lstReqDevice.ItemIndex   := -1 else lstReqDevice.ItemIndex   := 0;
  if not ckWorkCopy.Checked     then lstWorkDevice.ItemIndex  := -1 else lstWorkDevice.ItemIndex  := 0;
  FDevices := Piece(lstChartDevice.ItemID, ';', 1) + U +
              Piece(lstLabelDevice.ItemID, ';', 1) + U +
              Piece(lstReqDevice.ItemID, ';', 1)   + U +
              Piece(lstWorkDevice.ItemID, ';', 1);
  if FDevices = '^^^' then
    begin
      FPrintIt := False;
      InfoBox(TX_NO_SELECTION, TX_NO_SELECTION_CAP, MB_OK)
    end
  else
    begin
      FPrintIt := True;
      Close;
    end;
end;

procedure TfrmOrdersPrint.cmdCancelClick(Sender: TObject);
//  Force autoprint of 'don't prompt' items, regardless of continue/cancel selection.
begin
  if FNature = #0 then FDevices := '^^^'
  else with PrintParams do
    begin
      if (PromptForChartCopy = '0') or (PromptForChartCopy = #0) then
        begin
          if not ckChartCopy.Checked then lstChartDevice.ItemIndex := -1
          else lstChartDevice.ItemIndex := 0;
        end
      else lstChartDevice.ItemIndex := -1;

      if (PromptForLabels = '0') or (PromptForLabels = #0) then
        begin
          if not ckLabels.Checked then lstLabelDevice.ItemIndex := -1
          else lstLabelDevice.ItemIndex := 0;
        end
      else lstLabelDevice.ItemIndex := -1;

      if (PromptForRequisitions = '0') or (PromptForRequisitions = #0) then
        begin
          if not ckRequisitions.Checked then lstReqDevice.ItemIndex   := -1
          else lstReqDevice.ItemIndex   := 0;
        end
      else lstReqDevice.ItemIndex   := -1;

      if (PromptForWorkCopy = '0') or (PromptForWorkCopy = #0) then
        begin
          if not ckWorkCopy.Checked then lstWorkDevice.ItemIndex  := -1
          else lstWorkDevice.ItemIndex  := 0;
        end
      else lstWorkDevice.ItemIndex  := -1;

      FDevices := Piece(lstChartDevice.ItemID, ';', 1) + U +
                  Piece(lstLabelDevice.ItemID, ';', 1) + U +
                  Piece(lstReqDevice.ItemID, ';', 1)   + U +
                  Piece(lstWorkDevice.ItemID, ';', 1);
    end;

  FPrintIt := (FDevices <> '^^^');
  Close;
end;

procedure TfrmOrdersPrint.ckChartCopyClick(Sender: TObject);
begin
  cmdChart.Enabled := (ckChartCopy.Checked) and (PrintParams.PromptForChartCopy <> '2');
end;

procedure TfrmOrdersPrint.ckLabelsClick(Sender: TObject);
begin
  cmdLabels.Enabled := (ckLabels.Checked) and (PrintParams.PromptForLabels <> '2');
end;

procedure TfrmOrdersPrint.ckRequisitionsClick(Sender: TObject);
begin
  cmdReqs.Enabled := (ckRequisitions.Checked) and (PrintParams.PromptForRequisitions <> '2');
end;

procedure TfrmOrdersPrint.ckWorkCopyClick(Sender: TObject);
begin
  cmdWork.Enabled := (ckWorkCopy.Checked) and (PrintParams.PromptForWorkCopy <> '2');
end;

procedure TfrmOrdersPrint.DeviceListClick(Sender: TObject);
begin
  TORListBox(Sender).ItemIndex := -1;
end;

procedure TfrmOrdersPrint.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    Close;
  end;
end;

end.

