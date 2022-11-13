inherited frmSearchStop: TfrmSearchStop
  Left = 477
  Top = 351
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Scanning Notes....'
  ClientHeight = 95
  ClientWidth = 163
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  ExplicitWidth = 169
  ExplicitHeight = 123
  PixelsPerInch = 96
  TextHeight = 16
  object btnSearchStop: TButton [0]
    Left = 45
    Top = 64
    Width = 73
    Height = 25
    Caption = 'Stop Scan'
    TabOrder = 1
    OnClick = btnSearchStopClick
  end
  object lblSearchStatus: TStaticText [1]
    Left = 8
    Top = 32
    Width = 98
    Height = 20
    Caption = 'lblSearchStatus'
    TabOrder = 0
    TabStop = True
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 88
    Top = 8
    Data = (
      (
        'Component = btnSearchStop'
        'Status = stsDefault')
      (
        'Component = lblSearchStatus'
        'Status = stsDefault')
      (
        'Component = frmSearchStop'
        'Status = stsDefault'))
  end
end
