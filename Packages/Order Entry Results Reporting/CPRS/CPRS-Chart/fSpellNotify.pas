unit fSpellNotify;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, uConst, ExtCtrls, fBase508Form, VA508AccessibilityManager;

type
  TfrmSpellNotify = class(TfrmBase508Form)
    lblMain: TLabel;
    tmrMain: TTimer;
    lblOptions: TLabel;
    pnlWord: TPanel;
    pnlLabels: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Refocus(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    FSpellCheck: boolean;
    FEditControl: TCustomMemo;
    FFirst: boolean;
    procedure WMMove(var Message: TWMMove); message WM_MOVE;    
    procedure UMDoSpellCheck(var Message: TMessage); message UM_MISC;
  public
    property SpellCheck: boolean read FSpellCheck write FSpellCheck;
    property EditControl: TCustomMemo read FEditControl write FEditControl;
  end;

implementation

uses uSpell, ORFn;

{$R *.dfm}

procedure TfrmSpellNotify.Refocus(Sender: TObject);
begin
  RefocusSpellCheckWindow;
end;

procedure TfrmSpellNotify.FormCreate(Sender: TObject);
begin
  FFirst := True;
end;

procedure TfrmSpellNotify.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  RefocusSpellCheckWindow;
end;

procedure TfrmSpellNotify.FormShow(Sender: TObject);
begin
  if FFirst then
  begin
    FFirst := False;
    if not SpellCheck then
    begin
      lblMain.Caption := 'Grammar Check Running';
      lblOptions.Visible := false;
    end;
    PostMessage(Handle, UM_MISC, 0, 0);
  end;
  RefocusSpellCheckWindow;
end;

procedure TfrmSpellNotify.UMDoSpellCheck(var Message: TMessage);
begin
  InternalSpellCheck(SpellCheck, EditControl, pnlWord);
  ModalResult := mrOK;
end;

procedure TfrmSpellNotify.WMMove(var Message: TWMMove);
begin
  inherited;
  RefocusSpellCheckWindow;
end;

end.
