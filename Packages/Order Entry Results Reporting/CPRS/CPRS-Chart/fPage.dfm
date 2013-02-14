inherited frmPage: TfrmPage
  Left = 13
  Top = 236
  Caption = 'Basic Page'
  ClientHeight = 361
  ClientWidth = 640
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object shpPageBottom: TShape [0]
    Left = 0
    Top = 356
    Width = 640
    Height = 5
    Align = alBottom
    Brush.Color = clBtnFace
    Pen.Style = psClear
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = frmPage'
        'Status = stsDefault'))
  end
end
