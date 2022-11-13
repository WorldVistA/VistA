inherited frmMHTest: TfrmMHTest
  Left = 217
  Top = 156
  BorderIcons = [biSystemMenu]
  Caption = 'frmMHTest'
  ClientHeight = 433
  ClientWidth = 500
  Position = poScreenCenter
  ExplicitWidth = 516
  ExplicitHeight = 472
  PixelsPerInch = 96
  TextHeight = 13
  object sbMain: TScrollBox [0]
    Left = 0
    Top = 0
    Width = 500
    Height = 408
    HorzScrollBar.Visible = False
    VertScrollBar.Tracking = True
    Align = alClient
    TabOrder = 0
    OnResize = sbMainResize
  end
  object pnlBottom: TPanel [1]
    Left = 0
    Top = 408
    Width = 500
    Height = 25
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      500
      25)
    object btnCancel: TButton
      Left = 425
      Top = 3
      Width = 75
      Height = 21
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 2
    end
    object btnOK: TButton
      Left = 347
      Top = 3
      Width = 75
      Height = 21
      Anchors = [akTop, akRight]
      Caption = '&OK'
      TabOrder = 1
      OnClick = btnOKClick
    end
    object btnClear: TButton
      Left = 0
      Top = 3
      Width = 75
      Height = 21
      Caption = 'Clear'
      TabOrder = 0
      OnClick = btnClearClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = sbMain'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnClear'
        'Status = stsDefault')
      (
        'Component = frmMHTest'
        'Status = stsDefault'))
  end
end
