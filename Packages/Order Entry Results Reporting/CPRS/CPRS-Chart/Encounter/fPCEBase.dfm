inherited frmPCEBase: TfrmPCEBase
  Left = 194
  Top = 170
  Caption = 'Basic Page'
  ClientHeight = 400
  ClientWidth = 624
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    624
    400)
  PixelsPerInch = 96
  TextHeight = 13
  object btnOK: TBitBtn [0]
    Left = 467
    Top = 376
    Width = 75
    Height = 21
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    ModalResult = 1
    NumGlyphs = 2
    TabOrder = 0
    OnClick = btnOKClick
  end
  object btnCancel: TBitBtn [1]
    Left = 547
    Top = 376
    Width = 75
    Height = 21
    Anchors = [akRight, akBottom]
    Caption = '&Cancel'
    ModalResult = 2
    NumGlyphs = 2
    TabOrder = 1
    OnClick = btnCancelClick
    OnMouseDown = btnCancelMouseDown
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = frmPCEBase'
        'Status = stsDefault'))
  end
end
