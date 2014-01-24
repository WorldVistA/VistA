object frmCSRemaining: TfrmCSRemaining
  Left = 0
  Top = 0
  Caption = 'Unprocessed Controlled Substance Orders'
  ClientHeight = 366
  ClientWidth = 592
  Color = clBtnFace
  Constraints.MinHeight = 400
  Constraints.MinWidth = 600
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    592
    366)
  PixelsPerInch = 96
  TextHeight = 13
  object lblCSRemaining: TVA508StaticText
    Name = 'lblCSRemaining'
    Left = 8
    Top = 8
    Width = 282
    Height = 15
    Alignment = taLeftJustify
    Caption = 'These controlled substance order(s) will not be processed:'
    TabOrder = 0
    ShowAccelChar = True
  end
  object lstCSRemaining: TCaptionListBox
    Left = 8
    Top = 29
    Width = 576
    Height = 285
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 1
    ExplicitWidth = 611
    ExplicitHeight = 268
  end
  object cmdOK: TButton
    Left = 509
    Top = 333
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    TabOrder = 2
    OnClick = cmdOKClick
    ExplicitLeft = 544
    ExplicitTop = 316
  end
  object VA508AccessibilityManager1: TVA508AccessibilityManager
    Left = 24
    Top = 328
    Data = ()
  end
  object VA508ComponentAccessibility1: TVA508ComponentAccessibility
    Left = 72
    Top = 328
  end
end
