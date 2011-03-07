inherited frmOCAccept: TfrmOCAccept
  Left = 305
  Top = 257
  BorderIcons = []
  Caption = 'Order Checking'
  ClientHeight = 186
  ClientWidth = 622
  Constraints.MinHeight = 200
  Constraints.MinWidth = 600
  Position = poScreenCenter
  ExplicitWidth = 630
  ExplicitHeight = 220
  PixelsPerInch = 96
  TextHeight = 13
  object memChecks: TRichEdit [0]
    Left = 0
    Top = 0
    Width = 622
    Height = 153
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
    WantReturns = False
  end
  object pnlBottom: TPanel [1]
    Left = 0
    Top = 153
    Width = 622
    Height = 33
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object cmdAccept: TButton
      Left = 148
      Top = 6
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
      OnClick = cmdCancelClick
    end
    object Button1: TButton
      Left = 384
      Top = 6
      Width = 145
      Height = 21
      Caption = 'Drug Interaction Monograph'
      Enabled = False
      TabOrder = 2
      OnClick = Button1Click
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
        'Status = stsDefault')
      (
        'Component = Button1'
        'Status = stsDefault'))
  end
end
