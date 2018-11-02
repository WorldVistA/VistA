object OvcfrmSplashDlg: TOvcfrmSplashDlg
  Left = 445
  Top = 215
  BorderIcons = []
  BorderStyle = bsNone
  ClientHeight = 173
  ClientWidth = 210
  Color = clBtnFace
  Enabled = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Default'
  Font.Style = []
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object Image: TImage
    Left = 0
    Top = 0
    Width = 210
    Height = 173
    Align = alClient
  end
  object Timer: TTimer
    Enabled = False
    OnTimer = TimerTimer
    Left = 8
    Top = 8
  end
end
