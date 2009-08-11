inherited frmOCAccept: TfrmOCAccept
  Left = 305
  Top = 257
  BorderIcons = []
  Caption = 'Order Checking'
  ClientHeight = 169
  ClientWidth = 472
  Position = poScreenCenter
  ExplicitLeft = 305
  ExplicitTop = 257
  ExplicitWidth = 480
  ExplicitHeight = 203
  PixelsPerInch = 96
  TextHeight = 13
  object memChecks: TRichEdit [0]
    Left = 0
    Top = 0
    Width = 472
    Height = 136
    Align = alClient
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
    WantReturns = False
  end
  object pnlBottom: TPanel [1]
    Left = 0
    Top = 136
    Width = 472
    Height = 33
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object cmdAccept: TButton
      Left = 148
      Top = 7
      Width = 80
      Height = 21
      Caption = 'Accept Order'
      Default = True
      ModalResult = 6
      TabOrder = 0
    end
    object cmdCancel: TButton
      Left = 244
      Top = 7
      Width = 80
      Height = 21
      Cancel = True
      Caption = 'Cancel Order'
      ModalResult = 7
      TabOrder = 1
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = memChecks'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = cmdAccept'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = frmOCAccept'
        'Status = stsDefault'))
  end
end
