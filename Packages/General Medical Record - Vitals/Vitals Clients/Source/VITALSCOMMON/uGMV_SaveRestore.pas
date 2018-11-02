unit uGMV_SaveRestore;

interface
uses SysUtils, Forms, Dialogs;

procedure SaveWindowSettings(Form: TForm);
procedure RestoreWindowSettings(var Form: TForm);

implementation

uses uGMV_Common, uGMV_Const
  , uGMV_Engine, system.UITypes;

procedure SaveWindowSettings(Form: TForm);
var
  WindowSetting: string;
  State: TWindowState;
  s: String;
begin
  State := Form.WindowState;
  Form.WindowState := wsNormal;
  Form.Visible := False;
  WindowSetting :=
    IntToStr(Screen.Width) + ';' +
    IntToStr(Screen.Height) + ';' +
    IntToStr(Form.Left) + ';' +
    IntToStr(Form.Top) + ';' +
    IntToStr(Form.Width) + ';' +
    IntToStr(Form.Height) + ';' +
    IntToStr(integer(State));
{
  CallRemoteProc(RPCBroker, RPC_USER, ['SETPAR', Form.ClassName + '^' + WindowSetting]);
  if Piece(RPCBroker.RemoteProcedure[0], '^', 1) = '-1' then
    MessageDlg(
      'Unable to set parameter ' + Form.ClassName + '.' + #13 +
      'Error Message: ' + Piece(RPCBroker.RemoteProcedure[0], '^', 2), mtError, [mbOK], 0);
}
  s := setUserSettings(Form.ClassName,WindowSetting);
  if Piece(s,'^', 1) = '-1' then
    MessageDlg('Unable to set parameter ' + Form.ClassName + '.' + #13 +
      'Error Message: ' + Piece(s, '^', 2), mtError, [mbOK], 0);
end;

procedure RestoreWindowSettings(var Form: TForm);
var
  WindowSetting: string;
begin
//  CallRemoteProc(RPCBroker, RPC_USER, ['GETPAR', Form.ClassName]);
//  WindowSetting := RPCBroker.Results[0];

  WindowSetting := getUserSettings(Form.ClassName);

  {Verify valid settings and same screen resolution}
  if (WindowSetting = '') or
    (StrToIntDef(Piece(WindowSetting, ';', 1), 0) <> Screen.Width) or
    (StrToIntDef(Piece(WindowSetting, ';', 2), 0) <> Screen.Height) then
    Form.Position := poScreenCenter
  else
    begin
      Form.Position := poDesigned;
      Form.Left := StrToIntDef(Piece(WindowSetting, ';', 3), Form.Left);
      Form.Top := StrToIntDef(Piece(WindowSetting, ';', 4), Form.Top);
      Form.Width := StrToIntDef(Piece(WindowSetting, ';', 5), Form.Width);
      Form.Height := StrToIntDef(Piece(WindowSetting, ';', 6), Form.Height);
      {Sanity checks to ensure form is completely visible}
      if ((Form.Left + Form.Width) > Screen.Width) and (Form.Width <= Screen.Width) then
        Form.Left := Screen.Width - Form.Width;
      if ((Form.Top + Form.Height) > Screen.Height) and (Form.Height < Screen.Height) then
        Form.Top := Screen.Height - Form.Height;
      try
        Form.WindowState := TWindowState(StrToIntDef(Piece(WindowSetting, ';', 7), 0));
      except
      end;
    end;
end;


end.
