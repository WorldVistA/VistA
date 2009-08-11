inherited frmOMProgress: TfrmOMProgress
  Left = 221
  Top = 542
  BorderIcons = []
  Caption = 'Order Set Progress'
  ClientHeight = 188
  ClientWidth = 159
  ExplicitWidth = 167
  ExplicitHeight = 215
  PixelsPerInch = 96
  TextHeight = 13
  object lstItems: TCheckListBox [0]
    Left = 0
    Top = 0
    Width = 159
    Height = 167
    Align = alClient
    Color = clCream
    ItemHeight = 13
    TabOrder = 0
  end
  object cmdStop: TORAlignButton [1]
    Left = 0
    Top = 167
    Width = 159
    Height = 21
    Align = alBottom
    Caption = 'Stop Order Set'
    TabOrder = 1
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = lstItems'
        'Status = stsDefault')
      (
        'Component = cmdStop'
        'Status = stsDefault')
      (
        'Component = frmOMProgress'
        'Status = stsDefault'))
  end
end
