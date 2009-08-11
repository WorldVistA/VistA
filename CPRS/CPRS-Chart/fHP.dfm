inherited frmHP: TfrmHP
  Caption = 'History and Physical Exam Page'
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [1]
    Left = 0
    Top = 0
    Width = 640
    Height = 13
    Align = alTop
    Alignment = taCenter
    Caption = 'History and Physical Exam (inherit directly from fPage)'
    ExplicitWidth = 251
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = frmHP'
        'Status = stsDefault'))
  end
end
