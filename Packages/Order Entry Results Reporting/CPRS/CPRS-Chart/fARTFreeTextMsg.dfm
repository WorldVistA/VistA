inherited frmARTFreeTextMsg: TfrmARTFreeTextMsg
  Left = 426
  Top = 266
  Caption = 'Enter Optional Comments'
  ClientHeight = 332
  ClientWidth = 386
  Constraints.MinHeight = 180
  Constraints.MinWidth = 394
  Position = poMainFormCenter
  ExplicitWidth = 394
  ExplicitHeight = 359
  PixelsPerInch = 96
  TextHeight = 16
  object pnlText: TORAutoPanel [0]
    Left = 0
    Top = 0
    Width = 386
    Height = 133
    Align = alTop
    BevelOuter = bvNone
    Constraints.MinHeight = 133
    TabOrder = 0
    ExplicitTop = -6
    object lblText: TLabel
      Left = 17
      Top = 7
      Width = 3
      Height = 16
    end
    object lblComments: TOROffsetLabel
      AlignWithMargins = True
      Left = 3
      Top = 115
      Width = 380
      Height = 15
      Align = alBottom
      Caption = 'Comments (optional):'
      HorzOffset = 2
      Transparent = False
      VertOffset = 2
      WordWrap = False
      ExplicitLeft = 2
      ExplicitTop = 118
      ExplicitWidth = 100
    end
  end
  object pnlButton: TORAutoPanel [1]
    Left = 0
    Top = 300
    Width = 386
    Height = 32
    Align = alBottom
    BevelOuter = bvNone
    Constraints.MinHeight = 32
    TabOrder = 2
    ExplicitTop = 294
    object cmdContinue: TButton
      Left = 155
      Top = 7
      Width = 75
      Height = 21
      Caption = '&Continue'
      Constraints.MinHeight = 21
      TabOrder = 0
      OnClick = cmdContinueClick
    end
  end
  object memFreeText: TCaptionRichEdit [2]
    Left = 0
    Top = 133
    Width = 386
    Height = 167
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    PlainText = True
    TabOrder = 1
    Zoom = 100
    Caption = 'Additional comments:'
    ExplicitHeight = 161
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlText'
        'Status = stsDefault')
      (
        'Component = pnlButton'
        'Status = stsDefault')
      (
        'Component = cmdContinue'
        'Status = stsDefault')
      (
        'Component = memFreeText'
        'Status = stsDefault')
      (
        'Component = frmARTFreeTextMsg'
        'Status = stsDefault'))
  end
end
