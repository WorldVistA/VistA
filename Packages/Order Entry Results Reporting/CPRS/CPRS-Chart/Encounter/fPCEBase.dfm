inherited frmPCEBase: TfrmPCEBase
  Left = 194
  Top = 170
  Caption = 'Basic Page'
  ClientHeight = 399
  ClientWidth = 620
  Position = poMainFormCenter
  StyleElements = [seFont, seClient, seBorder]
  ExplicitWidth = 636
  ExplicitHeight = 438
  TextHeight = 13
  object pnlBottomAncestor: TPanel [0]
    Left = 0
    Top = 372
    Width = 620
    Height = 27
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnOK: TBitBtn
      AlignWithMargins = True
      Left = 461
      Top = 3
      Width = 75
      Height = 21
      Align = alRight
      Caption = 'OK'
      ModalResult = 1
      NumGlyphs = 2
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TBitBtn
      AlignWithMargins = True
      Left = 542
      Top = 3
      Width = 75
      Height = 21
      Align = alRight
      Caption = 'Cancel'
      ModalResult = 2
      NumGlyphs = 2
      TabOrder = 1
      OnClick = btnCancelClick
      OnMouseDown = btnCancelMouseDown
    end
  end
  object pnlMainAncestor: TPanel [1]
    Left = 0
    Top = 0
    Width = 620
    Height = 372
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 24
    Top = 16
    Data = (
      (
        'Component = frmPCEBase'
        'Status = stsDefault')
      (
        'Component = pnlBottomAncestor'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = pnlMainAncestor'
        'Status = stsDefault'))
  end
end
