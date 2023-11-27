inherited frmODDietAccess: TfrmODDietAccess
  Caption = 'No Write Access to Current Tab'
  ClientHeight = 218
  ClientWidth = 308
  ExplicitWidth = 324
  ExplicitHeight = 257
  PixelsPerInch = 96
  TextHeight = 13
  object lblMsg: TVA508StaticText [0]
    Name = 'lblMsg'
    Left = 0
    Top = 0
    Width = 308
    Height = 15
    Align = alTop
    Alignment = taLeftJustify
    Caption = 'lblMsg'
    TabOrder = 0
    ShowAccelChar = True
    ExplicitWidth = 184
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 16
    Top = 32
    Data = (
      (
        'Component = frmODDietAccess'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = lblMsg'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault'))
  end
end
