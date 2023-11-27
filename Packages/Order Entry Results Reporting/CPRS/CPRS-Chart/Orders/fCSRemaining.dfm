inherited frmCSRemaining: TfrmCSRemaining
  Left = 0
  Top = 0
  Caption = 'Unprocessed Controlled Substance Orders'
  ClientHeight = 261
  ClientWidth = 484
  Constraints.MinHeight = 300
  Constraints.MinWidth = 500
  Font.Name = 'Tahoma'
  ExplicitWidth = 500
  ExplicitHeight = 300
  PixelsPerInch = 96
  TextHeight = 13
  object lblCSRemaining: TVA508StaticText [0]
    Name = 'lblCSRemaining'
    AlignWithMargins = True
    Left = 8
    Top = 8
    Width = 468
    Height = 15
    Margins.Left = 8
    Margins.Top = 8
    Margins.Right = 8
    Margins.Bottom = 0
    Align = alTop
    Alignment = taLeftJustify
    AutoSize = True
    Caption = 'These controlled substance order(s) will not be processed:'
    TabOrder = 0
    ShowAccelChar = True
    ExplicitLeft = 3
  end
  object lstCSRemaining: TCaptionListBox [1]
    AlignWithMargins = True
    Left = 8
    Top = 31
    Width = 468
    Height = 189
    Margins.Left = 8
    Margins.Top = 8
    Margins.Right = 8
    Margins.Bottom = 8
    Align = alClient
    ItemHeight = 13
    TabOrder = 1
    Caption = ''
    ExplicitLeft = 3
    ExplicitHeight = 187
  end
  object pnlBottom: TPanel [2]
    Left = 0
    Top = 228
    Width = 484
    Height = 33
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    ExplicitLeft = 8
    ExplicitTop = 231
    object cmdOK: TButton
      AlignWithMargins = True
      Left = 380
      Top = 0
      Width = 96
      Height = 25
      Margins.Left = 8
      Margins.Top = 0
      Margins.Right = 8
      Margins.Bottom = 8
      Align = alRight
      Caption = 'OK'
      TabOrder = 0
      OnClick = cmdOKClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 16
    Top = 48
    Data = (
      (
        'Component = lblCSRemaining'
        'Status = stsDefault')
      (
        'Component = lstCSRemaining'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = frmCSRemaining'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault'))
  end
  object VA508ComponentAccessibility1: TVA508ComponentAccessibility
    Left = 56
    Top = 48
  end
end
