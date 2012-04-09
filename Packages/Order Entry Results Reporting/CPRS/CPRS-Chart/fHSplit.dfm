inherited frmHSplit: TfrmHSplit
  Left = 344
  Top = 228
  Caption = 'Basic Splitter Page'
  PixelsPerInch = 96
  TextHeight = 13
  object sptHorz: TSplitter [1]
    Left = 97
    Top = 0
    Width = 4
    Height = 356
  end
  object pnlLeft: TPanel [2]
    Left = 0
    Top = 0
    Width = 97
    Height = 356
    Align = alLeft
    BevelOuter = bvNone
    Constraints.MinWidth = 30
    TabOrder = 0
  end
  object pnlRight: TPanel [3]
    Left = 101
    Top = 0
    Width = 539
    Height = 356
    Align = alClient
    BevelOuter = bvNone
    Constraints.MinWidth = 24
    TabOrder = 1
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlLeft'
        'Status = stsDefault')
      (
        'Component = pnlRight'
        'Status = stsDefault')
      (
        'Component = frmHSplit'
        'Status = stsDefault'))
  end
end
