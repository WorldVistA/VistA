object frmVA508JawsDispatcherHiddenWindow: TfrmVA508JawsDispatcherHiddenWindow
  Left = 0
  Top = 0
  Caption = 'Dispatcher'
  ClientHeight = 47
  ClientWidth = 139
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object tmrMain: TTimer
    Interval = 30000
    OnTimer = tmrMainTimer
    Left = 8
    Top = 8
  end
end
