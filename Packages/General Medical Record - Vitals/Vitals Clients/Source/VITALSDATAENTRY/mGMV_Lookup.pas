unit mGMV_Lookup;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  Buttons,
  MFunStr,
  ExtCtrls;

type
  TfraGMV_Lookup = class(TFrame)
    tmrLookup: TTimer;
    cbxValues: TComboBox;
    edtValue: TComboBox;
    procedure FrameEnter(Sender: TObject);
    procedure FrameExit(Sender: TObject);
    procedure tmrLookupTimer(Sender: TObject);
    procedure cbxValuesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbxValuesClick(Sender: TObject);
    procedure edtValueKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbxValuesExit(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    procedure edtValueExit(Sender: TObject);
    procedure edtValueChange(Sender: TObject);
  private
    FIEN: string;
    FDDNumber: string;
    FChanged: Boolean;
    FPreviousValue: string;
    procedure Lookup(DD: string; var SelectedIEN: string);
    procedure SetTextValue;
    procedure SetDDNumber(const Value: string);
    procedure SetIEN(const Value: string);
    function GetIENS: string;
    { Private declarations }
  public
    ReportWidth:String;
    procedure InitFrame(ADDNumber: string; AIEN: string = '');
  published
    property DDNumber: string read FDDNumber write SetDDNumber;
    property IEN: string read FIEN write SetIEN;
    property IENS: string read GetIENS;
    { Public declarations }
  end;

type
  TLookupRecord = class(TObject)
  private
    FValue: string;
    FIEN: string;
    FDD: string;
  public
    constructor CreateFromRPCString(RPCString: string);
    constructor CreateFromRPCString2(RPCString: string);
 // published
    property DD: string
      read FDD write FDD;
    property IEN: string
      read FIEN write FIEN;
    property Value: string
      read FValue write FValue;
  end;

implementation

uses
  uGMV_Const
//,  u_Common
  , uGMV_Engine
  , system.UITypes;

{$R *.DFM}

{ TfraGMV_Lookup }

//procedure TfraGMV_Lookup.InitFrame(ABroker: TRPCBroker; ADDNumber: string; AIEN: string = '');
procedure TfraGMV_Lookup.InitFrame(ADDNumber: string; AIEN: string = '');
begin
//  FBroker := ABroker;
  FDDNumber := ADDNumber;
  IEN := AIEN;
  SetTextValue;
  ReportWidth := '80';//AAN 07/10/2002
end;

procedure TfraGMV_Lookup.SetTextValue;
begin
  cbxValues.Visible := False;
  if (FIEN <> '') and (FDDNumber <> '') then
    begin
//      CallRemoteProc(FBroker, RPC_MANAGER, ['GETDATA', FDDNumber + '^' + IENS + '^.01'], nil,[], nil);
//      edtValue.Text := FBroker.Results[0];
//      edtValue.Text := getFileField(FDDNumber,IENS,'.01');
      edtValue.Text := getFileField(FDDNumber,'.01',IENS); // zzzzzzandria 050210
      FChanged := False;
      FPreviousValue := edtValue.Text;
    end
  else
    edtValue.Text := '';
end;

procedure TfraGMV_Lookup.Lookup(DD: string; var SelectedIEN: string);
var
  tmpList: TStringList;
  i: integer;
begin
  try
//    CallRemoteProc(Broker, RPC_MANAGER, ['LOOKUP', FDDNumber + '^' + edtValue.Text], nil,[], tmpList);
    tmpList := getLookupEntries(FDDNumber,edtValue.Text);

    if tmpList.Count < 1 then
      begin
        MessageDlg('No entries found matching ''' + edtValue.Text + '''.', mtInformation, [mbok], 0);
        SetTextValue;
        edtValue.SetFocus;
        edtValue.SelectAll;

        FreeAndNil(tmpList);
        Exit;
      end;
    if Piece(tmpList[0], '^', 1) = '-1' then
      begin
        MessageDlg(Piece(tmpList[0], '^', 2), mtError, [mbok], 0);
        SetTextValue;
        edtValue.SelectAll;
        edtValue.SetFocus;
      end
    else if Piece(tmpList[0], '^', 1) = '0' then
      begin
        MessageDlg('No entries found matching ''' + edtValue.Text + '''.', mtInformation, [mbok], 0);
        SetTextValue;
        edtValue.SetFocus;
        edtValue.SelectAll;
      end
    else if Piece(tmpList[0], '^', 1) = '1' then
      begin
        edtValue.Text := Piece(tmpList[1], '^', 2);
        FPreviousValue := edtValue.Text;
        FChanged := False;
        FIEN := Piece(Piece(tmpList[1], '^', 1), ';', 2);
        edtValue.SetFocus;
        edtValue.SelectAll;
      end
    else
      begin
        tmpList.Delete(0); {Contains the header count record}
        for i := 0 to tmpList.Count - 1 do
          begin
            tmpList.Objects[i] := TLookupRecord.CreateFromRPCString(tmpList[i]);
//            tmpList.Objects[i] := TLookupRecord.CreateFromRPCString2(tmpList[i]);
            tmpList[i] := Piece(tmpList[i], '^', 2);
          end;
        cbxValues.Items.Assign(tmpList);
        cbxValues.Top := edtValue.Top;
        cbxValues.Left := edtValue.Left;
        cbxValues.Width := edtValue.Width;
        cbxValues.DroppedDown := True;
        cbxValues.Visible := True;
        cbxValues.ItemIndex := 0;
        cbxValues.SetFocus;
      end;
  finally
    FreeAndNil(tmpList);
  end;
end;

procedure TfraGMV_Lookup.SetDDNumber(const Value: string);
begin
  FDDNumber := Value;
end;

procedure TfraGMV_Lookup.SetIEN(const Value: string);
begin
  FIEN := Value;
end;

function TfraGMV_Lookup.GetIENS: string;
begin
  Result := FIEN + ',';
end;

procedure TfraGMV_Lookup.FrameEnter(Sender: TObject);
begin
  tmrLookup.Enabled := False;
  FChanged := False;
  edtValue.SetFocus;
end;

procedure TfraGMV_Lookup.FrameExit(Sender: TObject);
begin
  tmrLookup.Enabled := False;
end;

procedure TfraGMV_Lookup.tmrLookupTimer(Sender: TObject);
begin
  tmrLookup.Enabled := False;
  if edtValue.Text <> '' then
    Lookup(FDDNumber, FIEN)
  else
    FIEN := '';
end;

procedure TfraGMV_Lookup.cbxValuesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_DOWN) and (cbxValues.ItemIndex < (cbxValues.Items.Count - 1)) then
    cbxValues.ItemIndex := cbxValues.ItemIndex + 1;
  if (Key = VK_UP) and (cbxValues.ItemIndex > 0) then
    cbxValues.ItemIndex := cbxValues.ItemIndex - 1;
  if (Key = VK_RETURN) and (cbxValues.ItemIndex > -1) then
    cbxValuesClick(Sender);
  if (Key = VK_ESCAPE) then
    begin
      SetTextValue;
      edtValue.SetFocus;
      edtValue.SelectAll;
    end;
  Key := 0;
end;

procedure TfraGMV_Lookup.cbxValuesClick(Sender: TObject);
begin
  tmrLookup.Enabled := False;
  if cbxValues.ItemIndex > -1 then
    begin
      edtValue.Text := cbxValues.Items[cbxValues.ItemIndex];
      FIEN := TLookupRecord(cbxValues.Items.Objects[cbxValues.ItemIndex]).IEN;
      GetParentForm(self).Perform(CM_UPDATELOOKUP,0,0);
    end
  else
    SetTextValue;
  cbxValues.Items.Clear;
  cbxValues.Visible := False;
  FPreviousValue := edtValue.Text;
  FChanged := False;
end;

procedure TfraGMV_Lookup.edtValueKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  tmrLookup.Enabled := False;
  if (((Key = VK_DOWN) and (ssAlt in Shift)) or (Key = VK_RETURN)) and ((edtValue.Text <> '') and FChanged) then
    begin
      Key := 0;
      tmrLookupTimer(Sender);
    end;
  FChanged := (FPreviousValue <> edtValue.Text);
  tmrLookup.Enabled := FChanged;
end;

procedure TfraGMV_Lookup.cbxValuesExit(Sender: TObject);
begin
  cbxValues.Visible := False;
  edtValue.SetFocus;
end;

procedure TfraGMV_Lookup.FrameResize(Sender: TObject);
begin
  edtValue.Top := 0;
  edtValue.Left := 0;
  edtValue.Width := Width;
end;

procedure TfraGMV_Lookup.edtValueExit(Sender: TObject);
begin
  tmrLookup.Enabled := False;
  if FChanged then
    tmrLookupTimer(Sender);
  GetParentForm(self).Perform(CM_UPDATELOOKUP,0,0);
end;

procedure TfraGMV_Lookup.edtValueChange(Sender: TObject);
begin
  GetParentForm(self).Perform(CM_UPDATELOOKUP,0,0);
end;

{ TLookupRecord }

constructor TLookupRecord.CreateFromRPCString(RPCString: string);
begin
  inherited Create;
  FDD := Piece(RPCString, ';', 1);
  IEN := Piece(Piece(RPCString, ';', 2), '^', 1);
  FValue := Piece(RPCString, '^', 2);
end;

constructor TLookupRecord.CreateFromRPCString2(RPCString: string);
begin
  inherited Create;
  IEN := Piece(RPCString, '^', 1);
  FValue := Piece(RPCString, '^', 2);
end;

end.

