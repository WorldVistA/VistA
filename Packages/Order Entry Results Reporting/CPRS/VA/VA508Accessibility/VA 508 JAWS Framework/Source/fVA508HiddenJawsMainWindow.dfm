object frmVA508HiddenJawsMainWindow: TfrmVA508HiddenJawsMainWindow
  Left = 0
  Top = 0
  Caption = 'Main Window'
  ClientHeight = 41
  ClientWidth = 156
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object ReloadTimer: TTimer
    Enabled = False
    Interval = 250
    OnTimer = ReloadTimerTimer
    Left = 8
    Top = 8
  end
  object CloseINIFilesTimer: TTimer
    Enabled = False
    OnTimer = CloseINIFilesTimerTimer
    Left = 64
    Top = 8
  end
end
