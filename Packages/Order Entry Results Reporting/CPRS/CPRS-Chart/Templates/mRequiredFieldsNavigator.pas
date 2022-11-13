unit mRequiredFieldsNavigator;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.ExtCtrls, uTemplateFields, TypInfo, ORFn, ORNet, StrUtils,
  ORCtrls, ORDtTm, Vcl.Menus, System.Actions,
  Vcl.ActnList, Data.DB, Datasnap.DBClient;

type
  TRequiredFieldsFrame = class(TFrame)
    gpButtons: TGridPanel;
    btnPrev: TButton;
    btnNext: TButton;
    btnFirst: TButton;
    btnLast: TButton;
    stxtTotalRequired: TStaticText;
    PopupMenu1: TPopupMenu;
    T1: TMenuItem;
    B1: TMenuItem;
    L1: TMenuItem;
    R1: TMenuItem;
    pnlLmargin: TPanel;
    pnlRMargin: TPanel;
    ActionList1: TActionList;
    acFirst: TAction;
    acPrev: TAction;
    acNext: TAction;
    acLast: TAction;
    procedure T1Click(Sender: TObject);
    procedure acFirstExecute(Sender: TObject);
    procedure acLastExecute(Sender: TObject);
    procedure acPrevExecute(Sender: TObject);
    procedure acNextExecute(Sender: TObject);
    procedure dsControlsDataChange(Sender: TObject; Field: TField);
  private
    { Private declarations }
    fFocusedControl: TWinControl;
    fRequiredTotal: Integer;
    procedure setRequiredTotal(aValue: Integer);
    procedure setFocusedControl(aControl: TWinControl);

    procedure setRowColumn(aRow, aColumn: Integer; aControlItem: TControlItem);
    procedure setV(aHeight, aWidth: Integer);
    procedure setH(aHeight, aWidth: Integer);

    procedure setButtonStatus;

  public
    { Public declarations }
    szButtonX: Integer;
    szButtonY: Integer;
    szMarginH: Integer;
    szMarginV: Integer;

    property RequiredTotal: Integer read fRequiredTotal write setRequiredTotal;
    property FocusedControl: TWinControl read fFocusedControl
      write setFocusedControl;

    procedure setAlign(anAlign: TAlign); overload;
    procedure setAlign(anAlign: Integer); overload;
    procedure adjustButtonSize(aSize: Integer);

  end;

procedure adjustButtonSizeToFont(aSize: Integer; var X, Y, HGap, VGap: Integer);

implementation

{$R *.dfm}

uses
  VAUtils, uDlgComponents, mTemplateFieldButton, rMisc, fOptionsTIUTemplates,
  dRequiredFields;

procedure adjustButtonSizeToFont(aSize: Integer; var X, Y, HGap, VGap: Integer);
begin
  HGap := 8;
  case aSize of
    8, 9:
      begin
        X := 75;
        Y := 24;
        VGap := 8;
      end;
    10, 11:
      begin
        X := 85;
        Y := 26;
        VGap := 10;
      end;
    12, 13:
      begin
        X := 95;
        Y := 32;
        VGap := 12;
      end;
    14, 15, 16, 17:
      begin
        X := 120;
        Y := 38;
        VGap := 16;
      end;
    18:
      begin
        X := 150;
        Y := 42;
        VGap := 20;
      end;
  else
    begin
      X := 105;
      Y := 44;
    end;
  end;
end;

/// ////////////////////////////////////////////////////////////////////////////

procedure TRequiredFieldsFrame.adjustButtonSize(aSize: Integer);
begin
  adjustButtonSizeToFont(aSize, szButtonX, szButtonY, szMarginH, szMarginV);
  setAlign(ReqHighlightAlign);
end;

procedure TRequiredFieldsFrame.dsControlsDataChange(Sender: TObject;
  Field: TField);
begin

end;

/// /////////////////////////////////////////////////////////////////////////////

procedure TRequiredFieldsFrame.setRequiredTotal(aValue: Integer);
var
  s: string;
begin
  fRequiredTotal := aValue;
  s := 'All Required Fields have Values';
  if aValue <> 0 then
    s := 'Total Number of Required Fields without Values: ' +
      Format('%d', [aValue]);

  stxtTotalRequired.Caption := s;
  setButtonStatus;
end;

/// /////////////////////////////////////////////////////////////////////////////

procedure TRequiredFieldsFrame.setButtonStatus;
begin
  case fRequiredTotal of
    0:
      begin
        btnFirst.Enabled := False;
        btnLast.Enabled := False;
        btnPrev.Enabled := False;
        btnNext.Enabled := False;
      end;
    1:
      begin
        btnFirst.Enabled := True;
        btnLast.Enabled := False;
        btnPrev.Enabled := False;
        btnNext.Enabled := False;
      end;
  else
    begin
      btnFirst.Enabled := True;
      btnLast.Enabled := True;
      btnPrev.Enabled := True;
      btnNext.Enabled := True;
    end;
  end;
end;

procedure TRequiredFieldsFrame.setFocusedControl(aControl: TWinControl);
begin
  fFocusedControl := aControl;
  dmRF.cdsControls.Locate('CTRL_OBJ', VarArrayOf([Integer(aControl)]), []);
end;

// alignment of the frame //////////////////////////////////////////////////////
procedure TRequiredFieldsFrame.T1Click(Sender: TObject);
begin
  if Sender = T1 then
    setAlign(alTop)
  else if Sender = B1 then
    setAlign(alBottom)
  else if Sender = L1 then
    setAlign(alLeft)
  else if Sender = R1 then
    setAlign(alRight)
end;

procedure TRequiredFieldsFrame.setRowColumn(aRow, aColumn: Integer;
  aControlItem: TControlItem);
begin
  aControlItem.Column := aColumn;
  aControlItem.Row := aRow;
  aControlItem.RowSpan := 1;
  aControlItem.ColumnSpan := 1;
end;

procedure TRequiredFieldsFrame.setV(aHeight, aWidth: Integer);
var
  i: Integer;
  Ctrl: TControlItem;
  ci: TCellItem;

begin
  ci := gpButtons.RowCollection[0];
  ci.SizeStyle := ssAbsolute;
  ci.Value := 4.0;
  for i := 1 to 4 do
  begin
    ci := gpButtons.RowCollection[i];
    ci.SizeStyle := ssAbsolute;
    ci.Value := aHeight;
  end;
  ci := gpButtons.RowCollection[5];
  ci.SizeStyle := ssPercent;
  ci.Value := 100.0;

  ci := gpButtons.ColumnCollection[0];
  ci.SizeStyle := ssPercent;
  ci.Value := 100.0;
  for i := 1 to 4 do
  begin
    ci := gpButtons.ColumnCollection[i];
    ci.SizeStyle := ssAbsolute;
    ci.Value := 0.0;
  end;

  for i := 0 to gpButtons.ControlCollection.Count - 1 do
  begin
    Ctrl := gpButtons.ControlCollection[i];
    if Ctrl.Control = btnFirst then
      setRowColumn(1, 0, Ctrl)
    else if Ctrl.Control = btnPrev then
      setRowColumn(2, 0, Ctrl)
    else if Ctrl.Control = btnNext then
      setRowColumn(3, 0, Ctrl)
    else if Ctrl.Control = btnLast then
      setRowColumn(4, 0, Ctrl)
    else if Ctrl.Control = stxtTotalRequired then
      setRowColumn(5, 0, Ctrl)
  end;
end;

procedure TRequiredFieldsFrame.setH(aHeight, aWidth: Integer);
var
  i: Integer;
  ci: TCellItem;
  Ctrl: TControlItem;
begin
  ci := gpButtons.RowCollection[0];
  ci.SizeStyle := ssAbsolute;
  ci.Value := aHeight;

  for i := 1 to 5 do
  begin
    ci := gpButtons.RowCollection[i];
    ci.SizeStyle := ssAbsolute;
    ci.Value := 0.0;
  end;

  ci := gpButtons.ColumnCollection[0];
  ci.SizeStyle := ssPercent;
  ci.Value := 100.0;
  for i := 1 to 4 do
  begin
    ci := gpButtons.ColumnCollection[i];
    ci.SizeStyle := ssAbsolute;
    ci.Value := aWidth;
  end;

  for i := 0 to gpButtons.ControlCollection.Count - 1 do
  begin
    Ctrl := gpButtons.ControlCollection[i];
    if Ctrl.Control = stxtTotalRequired then
      setRowColumn(0, 0, Ctrl)
    else if Ctrl.Control = btnFirst then
      setRowColumn(0, 1, Ctrl)
    else if Ctrl.Control = btnPrev then
      setRowColumn(0, 2, Ctrl)
    else if Ctrl.Control = btnNext then
      setRowColumn(0, 3, Ctrl)
    else if Ctrl.Control = btnLast then
      setRowColumn(0, 4, Ctrl)
  end;
end;

procedure TRequiredFieldsFrame.setAlign(anAlign: TAlign);
begin
  case anAlign of
    alNone:
      ;
    alTop:
      begin
        if parent.align = alTop then
          exit
        else if align = alBottom then
          align := alTop
        else
        begin
          setH(szButtonY, szButtonX);
          align := alTop;
          Height := szButtonY;
        end;
        CurrentPosition := 0;
      end;
    alLeft:
      begin
        if align = alLeft then
          exit
        else if align = alRight then
          align := alLeft
        else
        begin
          setV(szButtonY, szButtonX);
          align := alLeft;
          Width := pnlLmargin.Width + pnlLmargin.Width + szButtonX;
        end;
        CurrentPosition := 1;
      end;
    alRight:
      begin
        if align = alRight then
          exit
        else if align = alLeft then
          align := alRight
        else
        begin
          setV(szButtonY, szButtonX);
          align := alRight;
          Width := pnlLmargin.Width + pnlLmargin.Width + szButtonX;
        end;
        CurrentPosition := 2;
      end;
    alBottom:
      begin
        if align = alBottom then
          exit
        else if align = alTop then
          align := alBottom
        else
        begin
          setH(szButtonY, szButtonX);
          align := alBottom;
          Height := szButtonY;
        end;
        CurrentPosition := 3;
      end;
    alClient:
      ;
    alCustom:
      ;
  end;
  invalidate;
end;

procedure TRequiredFieldsFrame.setAlign(anAlign: Integer);
begin
  case anAlign of
    0:
      setAlign(alTop);
    1:
      setAlign(alLeft);
    2:
      setAlign(alRight);
    3:
      setAlign(alBottom);
  end;
end;

/// /////////////////////////////////////////////////////////////////////////

procedure TRequiredFieldsFrame.acFirstExecute(Sender: TObject);
var
  Ctrl: TWinControl;
begin
  Ctrl := dmRF.getControlFirstRequiredField;
  if Ctrl <> nil then
    Ctrl.SetFocus;
end;

procedure TRequiredFieldsFrame.acLastExecute(Sender: TObject);
var
  Ctrl: TWinControl;
begin
  Ctrl := dmRF.getControlLastRequiredField;
  if Ctrl <> nil then
    Ctrl.SetFocus;
end;

procedure TRequiredFieldsFrame.acNextExecute(Sender: TObject);
var
  Ctrl: TWinControl;
begin
  Ctrl := dmRF.getControlNextRequiredField(FocusedControl);
  if Ctrl <> nil then
    Ctrl.SetFocus
  else
    acLast.Execute;
end;

procedure TRequiredFieldsFrame.acPrevExecute(Sender: TObject);
var
  Ctrl: TWinControl;
begin
  Ctrl := dmRF.getControlPrevRequiredField(FocusedControl);
  if Ctrl <> nil then
    Ctrl.SetFocus
  else
    acFirst.Execute;
end;

end.
