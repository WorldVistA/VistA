unit fODDietAccess;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  fBase508Form, VA508AccessibilityManager, ORFn, VAUtils, rODDiet,
  Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmODDietAccess = class(TfrmBase508Form)
    lblMsg: TVA508StaticText;
  private
    FResult: TDietTab;
    procedure btnClick(Sender: TObject);
  public
    { Public declarations }
  end;

function AskForAccessibleTab(DlgParent: TComponent; Msg: string;
  TabInfo: TDietTabArray; ExcludeTabs: TDietTabs; AutoAcceptIfOnlyOne: Boolean)
  : TDietTab;

implementation

{$R *.dfm}

type
  THackVA508StaticText = class(TVA508StaticText);

const
  GAP = 5;

function AskForAccessibleTab(DlgParent: TComponent; Msg: string;
  TabInfo: TDietTabArray; ExcludeTabs: TDietTabs; AutoAcceptIfOnlyOne: Boolean)
  : TDietTab;
var
  frmODDietAccess: TfrmODDietAccess;
  Tab: TDietTab;
  y, btnHt, count: integer;
  r: TRect;
  btn: TButton;

  procedure DoAlign(Control: TControl);
  begin
    with Control do
    begin
      AlignWithMargins := True;
      Margins.Top := GAP;
      Margins.Bottom := GAP;
      Margins.Left := GAP * 2;
      Margins.Right := GAP * 2;
      Align := alTop;
    end;
  end;

  function CreateButton(ResultValue: TDietTab; Text: string): TButton;
  begin
    Result := TButton.Create(frmODDietAccess);
    Result.Parent := frmODDietAccess;
    Result.Caption := Text;
    Result.Tag := Ord(ResultValue);
    Result.Height := btnHt;
    Result.Top := y;
    Result.OnClick := frmODDietAccess.btnClick;
    DoAlign(Result);
    inc(y, Result.Height + GAP * 2);
  end;

begin
  btnHt := TextHeightByFont(MainFont.Handle, 'Ty') + GAP * 2;
  frmODDietAccess := TfrmODDietAccess.Create(DlgParent);
  try
    ResizeFormToFont(frmODDietAccess);
    with frmODDietAccess do
    begin
      THackVA508StaticText(lblMsg).StaticLabel.WordWrap := True;
      lblMsg.Caption := Msg + CRLF + CRLF +
        'If you would like to use a tab for which you do have write access, ' +
        ' select that tab now, or select None to exit.';
      DoAlign(lblMsg);
      r := lblMsg.BoundsRect;
      y := WrappedTextHeightByFont(Canvas, Font, lblMsg.Caption, r);
      lblMsg.Height := y;
      inc(y, GAP * 2);
      if ScreenReaderActive then
        lblMsg.TabStop := True;
      count := 0;
      btn := nil;
      for Tab := Low(TDietTab) to High(TDietTab) do
      begin
        if (Tab in ExcludeTabs) or (not TabInfo[Tab].Access.WriteAccess) or
          (not TabInfo[Tab].TabSheet.TabVisible) then
          continue;
        btn := CreateButton(Tab, TabInfo[Tab].TabSheet.Caption);
        inc(count);
      end;
      if AutoAcceptIfOnlyOne and (count = 1) then
      begin
        Result := TDietTab(btn.Tag);
        exit;
      end;
      with CreateButton(dtNone, 'None') do
      begin
        Cancel := True;
        if not ScreenReaderActive then
          TabOrder := 0;
      end;
      ClientHeight := y;
      Constraints.MinHeight := Height;
      Constraints.MinWidth := Width;
      FResult := dtNone;
      ShowModal;
      Result := FResult;
    end;
  finally
    frmODDietAccess.Free;
  end;
end;

procedure TfrmODDietAccess.btnClick(Sender: TObject);
begin
  FResult := TDietTab(TButton(Sender).Tag);
  ModalResult := mrOK;
end;

end.
