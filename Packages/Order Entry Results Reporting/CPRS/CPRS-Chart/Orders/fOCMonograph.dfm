object frmOCMonograph: TfrmOCMonograph
  Left = 0
  Top = 0
  Caption = 'Monographs for Order Checks'
  ClientHeight = 516
  ClientWidth = 539
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    539
    516)
  PixelsPerInch = 96
  TextHeight = 13
  object monoCmbLst: TComboBox
    Left = 8
    Top = 24
    Width = 225
    Height = 21
    ItemHeight = 13
    TabOrder = 1
    Text = 'monoCmbLst'
    OnChange = monoCmbLstChange
  end
  object monoMemo: TCaptionMemo
    Left = 8
    Top = 72
    Width = 523
    Height = 401
    Anchors = [akLeft, akTop, akRight, akBottom]
    Lines.Strings = (
      'monoMemo')
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object cmdOK: TButton
    Left = 432
    Top = 483
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    TabOrder = 4
    OnClick = cmdOKClick
  end
  object VA508StaticText1: TVA508StaticText
    Name = 'VA508StaticText1'
    Left = 8
    Top = 0
    Width = 142
    Height = 15
    Alignment = taLeftJustify
    Caption = 'Choose a Monograph to view'
    TabOrder = 0
    ShowAccelChar = True
  end
  object VA508StaticText2: TVA508StaticText
    Name = 'VA508StaticText2'
    Left = 8
    Top = 51
    Width = 115
    Height = 15
    Alignment = taLeftJustify
    Caption = 'Monograph Information'
    TabOrder = 2
    ShowAccelChar = True
  end
  object VA508AccessibilityManager1: TVA508AccessibilityManager
    Left = 352
    Top = 16
    Data = (
      (
        'Component = monoMemo'
        'Status = stsDefault')
      (
        'Component = monoCmbLst'
        'Status = stsDefault')
      (
        'Component = frmOCMonograph'
        'Status = stsDefault'))
  end
  object VA508ComponentAccessibility1: TVA508ComponentAccessibility
    Component = monoCmbLst
    OnCaptionQuery = VA508ComponentAccessibility1CaptionQuery
    Left = 256
    Top = 16
  end
end
