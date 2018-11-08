unit fGMV_SupO2;
{
================================================================================
*
*       Application:  Vitals
*       Revision:     $Revision: 1 $  $Modtime: 1/24/08 4:16p $
*       Developer:    ddomain.user@domain.ext/doma.user@domain.ext
*       Site:         Hines OIFO
*
*       Description:  Accepts flow rate data for PO2 vital.
*
*       Notes:
*
================================================================================
*       $Archive: /Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_8/Source/VITALSDATAENTRY/fGMV_SupO2.pas $
*
* $History: fGMV_SupO2.pas $
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 8/12/09    Time: 8:29a
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_8/Source/VITALSDATAENTRY
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 3/09/09    Time: 3:39p
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_6/Source/VITALSDATAENTRY
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 1/13/09    Time: 1:26p
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_4/Source/VITALSDATAENTRY
 * 
 * *****************  Version 3  *****************
 * User: Zzzzzzandria Date: 2/01/08    Time: 7:39a
 * Updated in $/Vitals GUI 2007/Vitals/VITALSDATAENTRY
 * Vitals GUI 5.0.22.3
 * 
 * *****************  Version 2  *****************
 * User: Zzzzzzandria Date: 1/07/08    Time: 6:51p
 * Updated in $/Vitals GUI 2007/Vitals/VITALSDATAENTRY
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/14/07    Time: 10:29a
 * Created in $/Vitals GUI 2007/Vitals-5-0-18/VITALSDATAENTRY
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/16/06    Time: 5:43p
 * Created in $/Vitals/VITALS-5-0-18/VitalsDataEntry
 * GUI v. 5.0.18 updates the default vital type IENs with the local
 * values.
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/16/06    Time: 5:33p
 * Created in $/Vitals/Vitals-5-0-18/VITALS-5-0-18/VitalsDataEntry
 * 
 * *****************  Version 2  *****************
 * User: Zzzzzzandria Date: 7/22/05    Time: 3:51p
 * Updated in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, CCOW) - Delphi 6/VitalsDataEntry
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/24/05    Time: 3:35p
 * Created in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, No CCOW) - Delphi 6/VitalsDataEntry
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 4/16/04    Time: 4:20p
 * Created in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, CPRS, Delphi 7)/VITALSDATAENTRY
 * 
 * *****************  Version 2  *****************
 * User: Zzzzzzandria Date: 1/30/04    Time: 4:32p
 * Updated in $/VitalsLite/VitalsLiteDLL
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 1/15/04    Time: 3:06p
 * Created in $/VitalsLite/VitalsLiteDLL
 * Vitals Lite DLL
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 10/29/03   Time: 4:15p
 * Created in $/Vitals503/Vitals User
 * Version 5.0.3
 *
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/21/03    Time: 1:18p
 * Created in $/Vitals GUI Version 5.0/VitalsUserNoCCOW
 * Pre CCOW Version of Vitals User
 * 
 * *****************  Version 7  *****************
 * User: Zzzzzzandria Date: 4/17/03    Time: 5:02p
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * 
 * *****************  Version 6  *****************
 * User: Zzzzzzandria Date: 12/02/02   Time: 3:00p
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * Vitals Light updates
 * 
 * *****************  Version 5  *****************
 * User: Zzzzzzandria Date: 11/07/02   Time: 10:33a
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * Pulse Ox Changes
 * 
 * *****************  Version 4  *****************
 * User: Zzzzzzandria Date: 8/16/02    Time: 11:17a
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * v T30
 * 
 * *****************  Version 3  *****************
 * User: Zzzzzzandria Date: 7/25/02    Time: 2:51p
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 *
 * *****************  Version 2  *****************
 * User: Zzzzzzandria Date: 7/12/02    Time: 5:00p
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * GUI Version T28
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzpetitd Date: 4/04/02    Time: 12:08p
 * Created in $/Vitals GUI Version 5.0/Vitals User
 *
*
================================================================================
}
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
  ComCtrls,
  Buttons,
  ExtCtrls
  ,CheckLst
  ;

type
  TfrmGMV_SupO2 = class(TForm)
    pnlMain: TPanel;
    pnlBottom: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    Panel1: TPanel;
    lblFlow: TLabel;
    lblO2Con: TLabel;
    edtFlow: TEdit;
    edtO2Con: TEdit;
    udFlow: TUpDown;
    udO2: TUpDown;
    lblPercent: TLabel;
    lblLitMin: TLabel;
    Panel2: TPanel;
    pnlQual: TPanel;
    Panel5: TPanel;
    cbMethod: TComboBox;
    lblMethodValue: TLabel;
    procedure udFlowChangingEx(Sender: TObject; var AllowChange: Boolean;
      NewValue: integer; Direction: TUpDownDirection);
    procedure udO2ChangingEx(Sender: TObject; var AllowChange: Boolean;
      NewValue: integer; Direction: TUpDownDirection);
    procedure edtFlowKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtO2ConKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbMethodChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure edtFlowKeyPress(Sender: TObject; var Key: Char);
    procedure edtO2ConKeyPress(Sender: TObject; var Key: Char);
    procedure edtFlowChange(Sender: TObject);
    procedure edtFlowExit(Sender: TObject);
    procedure edtO2ConChange(Sender: TObject);
    procedure edtO2ConExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    QualVal:Integer;
  end;

function GetSupplementO2Data(var FlowRate: string; var Percentage: string; ctrl: TControl;sQual:String): Boolean;

implementation

uses uGMV_Common
, uGMV_Utils, uGMV_Engine, system.Types
  ;

{$R *.DFM}

function GetSupplementO2Data(var FlowRate: string; var Percentage: string; ctrl: TControl;sQual:String): Boolean;
var
  s:String;
  sType, sCategory: String;
  i: INteger;
  pt: TPoint;
  SL: TStringList;
begin
  Result := False;
  with TfrmGMV_SupO2.Create(Application) do
  try
    pt := Ctrl.Parent.ClientToScreen(Point(Ctrl.Left, Ctrl.Top));
    Left := pt.x;
    Top := pt.y + Ctrl.Height;

    edtFlow.Text := FlowRate;
    edtO2Con.Text := Percentage;

    sType := getVitalTypeIEN('PULSE OXIMETRY');
    sCategory := getVitalCategoryIEN('METHOD');
    SL := getQualifiers(sType,sCategory);
    if SL.Count > 1 then
      begin
        if pos('-None-',cbMethod.Text) = 0 then
          cbMethod.Items.Add('-None-'); //CQ Ticket #6942
        for i := 1 to SL.Count - 1 do
          begin
            s := SL[i];
            cbMethod.Items.AddObject(TitleCase(Piece(s,'^', 2)),
              Pointer(StrToIntDef(Piece(s,'^', 1), 0)));
          end;
      end;
    SL.Free;

    s := Piece(sQual,'[',2);
    if pos('  ',s)= 0 then
      s := Piece(s,']',1)
    else
      s := Piece(s,'  ',1);
    i := cbMethod.Items.IndexOf(s);
    if i >= 0 then
      begin
        cbMethod.ItemIndex := i;
        QualVal := integer(cbMethod.Items.Objects[i]);   //AAN 11/5/2002 initial value added;
      end;
    ActiveControl := edtFlow;
    ShowModal;
    if ModalResult = mrOk then
      begin
        FlowRate := edtFlow.Text;
//AAN 07/09/2002        Percentage := edtO2Con.text;
        Percentage := edtO2Con.text + '^'+IntToStr(QualVal)+'^'+cbMethod.Text;
        Result := True;
      end;
  finally
    free;
  end;
end;

procedure TfrmGMV_SupO2.udFlowChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Integer; Direction: TUpDownDirection);
var
  d: Double;
  Value: string;
begin
  Value := edtFlow.Text;
  if (Value = '') then
    VitalMath(Value, 0, 1, vfInit, 1)
  else
    begin
      case Direction of
        updUp: VitalMath(Value, 1, 10, vfAdd, 1);
        updDown: VitalMath(Value, 1, 10, vfSubtract, 1);
      end;
    end;
  try
    d := StrToFloat(Value);
    if d > 20.0 then Value := '20';
    if d < 0.5 then Value := '0.5';
  except
  end;
  edtFlow.Text := Value;
end;

procedure TfrmGMV_SupO2.udO2ChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: integer; Direction: TUpDownDirection);
var
  d: Double;
  Value: string;
begin
  Value := edtO2Con.Text;
  if (Value = '') then
    VitalMath(Value, 0, 80, vfInit, 0)
  else
    begin
      case Direction of
        updUp: VitalMath(Value, 1, 80, vfAdd, 0);
        updDown: VitalMath(Value, 1, 80, vfSubtract, 0);
      end;
    end;
  try
    d := StrToFloat(Value);
    if d > 100.0 then Value := '100';
    if d < 21.0 then Value := '21';
  except
  end;
  edtO2Con.Text := Value;
end;

procedure TfrmGMV_SupO2.edtFlowKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  tmp: boolean;
begin
  inherited;
  if (Key = VK_UP) then
    udFlowChangingEx(Sender, tmp, 0, updUp)
  else if (Key = VK_DOWN) then
    udFlowChangingEx(Sender, tmp, 0, updDown);
end;

procedure TfrmGMV_SupO2.edtO2ConKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  tmp: boolean;
begin
  inherited;
  if (Key = VK_UP) then
    udO2ChangingEx(Sender, tmp, 0, updUp)
  else if (Key = VK_DOWN) then
    udO2ChangingEx(Sender, tmp, 0, updDown);
end;

procedure TfrmGMV_SupO2.cbMethodChange(Sender: TObject);

  function getQualVal: Integer;
  begin
      try
        Result := integer(cbMethod.Items.Objects[cbMethod.ItemIndex]);
      except
        Result := -99;
      end;
  end;
  procedure setFields(anEnabled:Boolean);
  var
    _Color: TColor;
  begin
    if anEnabled then _Color := clWindowText
    else
      begin
        _Color := clGrayText;
        // there should be no values of concentration for Room Air
        edtFlow.Text := '';
        edtO2Con.Text := '';
      end;

    edtFlow.Enabled := anEnabled;
    edtO2Con.Enabled := anEnabled;
    udFlow.Enabled := anEnabled;
    udO2.Enabled := anEnabled;
    lblFlow.Font.Color := _Color;
    lblO2Con.Font.Color := _Color;
    lblLitMin.Font.Color := _Color;
    lblPercent.Font.Color := _Color;

    QualVal := getQualVal;
  end;

begin
  if (cbMethod.ItemIndex = 0)  // CQ Ticket # 6942 - Start
//    or (pos('ROOM AIR',uppercase(cbMethod.Text))>0)
  then
    setFields(False)
  else   // CQ Ticket # 6942 - end
    setFields(True);
end;

procedure TfrmGMV_SupO2.FormActivate(Sender: TObject);
begin
  if (Left + Width) > Forms.Screen.Width then
    Left := Forms.Screen.Width - Width;
  if (Top + Height) > Forms.Screen.Height then
    Top := Forms.Screen.Height - Height - pnlBottom.Height div 2;

  cbMethodChange(nil);// R141398 -- zzzzzzandria 060921 
end;

procedure TfrmGMV_SupO2.btnOKClick(Sender: TObject);
var
  s,ss: String;
  i: integer;
  f: double;
begin
  try
    i :=0;
    if edtO2Con.Text <> '' then
      i := StrToInt(edtO2Con.Text);
  except
    s :='Invalid value for O2 concentration entered: <'+
        String(edtO2Con.Text)+'>'+#13+
        'Valid values are integers from 21 to 100'+#13+#13+'Try again?';
    if Application.MessageBox(pChar(s),'Value Error', MB_OKCANCEL + MB_DEFBUTTON1) <> IDOK
    then
      ModalResult := mrCancel
    else
      begin
        activeControl := edtO2Con;
        ModalResult := mrNone;
      end;
    Exit;
  end;
  try
    f := 0;
    if edtFlow.Text <> '' then
      f := StrToFloat(edtFlow.Text);
  except
    s := 'Error value for the flow rate entered: <'+ edtFlow.Text+'>'+#13+
        'Valid values are from 0.5 to 20'+#13+#13+'Try again?';
    if Application.MessageBox(PChar(s),'Value Error', MB_OKCANCEL + MB_DEFBUTTON1) <> IDOK
    then
      ModalResult := mrCancel
    else
      begin
        activeControl := edtFlow;
        ModalResult := mrNone;
      end;
    Exit;
  end;

  if edtO2Con.Text <> '' then
    if (i<21) or (i>100) then s := 'O2 concentration value '+edtO2Con.Text+' is out of range'
    else s := '';
  if edtFlow.Text <> '' then
    if (f<0.5) or (f>20) then ss := 'Flow rate value '+edtFlow.Text+' is out of range (.5-20)'
    else ss := '';

  if (s+#13+ss)<>#13 then
    begin
      s := s+#13+ss+#13+'Try again?';
      if Application.MessageBox(PChar(s),'Range Error', MB_OKCANCEL + MB_DEFBUTTON1) <> IDOK
      then
        ModalResult := mrCancel
      else
        begin
          if (i<21) or (i>100) then ActiveControl := edtO2Con
          else ActiveControl := edtFlow;
          ModalResult := mrNone;
        end;
      Exit;
    end;

  ModalResult := mrOK;
end;

procedure TfrmGMV_SupO2.edtFlowKeyPress(Sender: TObject; var Key: Char);
begin
  if pos(Key,'-,`~!@#$%^&*()_+=|\/"''') > 0 then
    Key := #0;
  inherited;
end;

procedure TfrmGMV_SupO2.edtO2ConKeyPress(Sender: TObject; var Key: Char);
begin
  if pos(Key,'-,`~!@#$%^&*()_+=|\/"''') > 0 then
    Key := #0;
  inherited;
end;

procedure TfrmGMV_SupO2.edtFlowChange(Sender: TObject);
var
  d: Double;
begin
  try
    d := StrToFloat(edtFlow.Text);
    if d > 20.0 then
      begin
        ShowMessage('Flow rate value '+edtFlow.Text+' is out of range (.5-20)');
        edtFlow.SelStart := Length(edtFlow.Text)-1;
        edtFlow.SelLength := 1;
      end;
  except
  end;
end;

procedure TfrmGMV_SupO2.edtFlowExit(Sender: TObject);
var
  d: Double;
begin
  if edtFlow.Text = '' then Exit;
  try
    d := StrToFloat(edtFlow.Text);
    if (d > 20.0) or (d < 0.5) then
      begin
        ShowMessage('Flow rate value '+edtFlow.Text+' is out of range (.5-20)');
        edtFlow.SelStart := Length(edtFlow.Text)-1;
        edtFlow.SelLength := 1;
        ActiveControl := edtFlow;
      end;
  except
  end;
end;

procedure TfrmGMV_SupO2.edtO2ConChange(Sender: TObject);
var
  d: Double;
begin
  try
    d := StrToFloat(edtO2Con.Text);
    if d > 100.0 then
      begin
        ShowMessage('Flow rate value '+edtO2Con.Text+' is out of range (21-100)');
        edtO2Con.SelStart := Length(edtO2Con.Text)-1;
        edtO2Con.SelLength := 1;
      end;
  except
  end;
end;

procedure TfrmGMV_SupO2.edtO2ConExit(Sender: TObject);
var
  d: Double;
begin
  if edtO2Con.Text = '' then Exit;
  try
    d := StrToFloat(edtO2Con.Text);
    if (d > 100.0) or (d < 21.0) then
      begin
        ShowMessage('O2 concentration value '+edtO2Con.Text+' is out of range (21-100)');
        edtO2Con.SelStart := Length(edtO2Con.Text)-1;
        edtO2Con.SelLength := 1;
        ActiveControl := edtO2Con;
      end;
  except
  end;
end;

end.
