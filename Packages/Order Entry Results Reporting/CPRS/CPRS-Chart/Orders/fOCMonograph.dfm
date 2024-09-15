inherited frmOCMonograph: TfrmOCMonograph
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Monographs for Order Checks'
  ClientHeight = 389
  ClientWidth = 539
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBottom: TPanel
    Left = 0
    Top = 348
    Width = 539
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      539
      41)
    object cmdOK: TButton
      Left = 456
      Top = 4
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
    end
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 539
    Height = 48
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object monoCmbLst: TComboBox
      Left = 8
      Top = 24
      Width = 225
      Height = 21
      TabOrder = 0
      Text = 'monoCmbLst'
      OnChange = monoCmbLstChange
    end
    object VA508StaticText1: TVA508StaticText
      Name = 'VA508StaticText1'
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 533
      Height = 15
      Align = alTop
      Alignment = taLeftJustify
      Caption = 'Choose a Monograph to view'
      TabOrder = 1
      ShowAccelChar = True
    end
  end
  object pnlCanvas: TPanel
    Left = 0
    Top = 48
    Width = 539
    Height = 300
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object VA508StaticText2: TVA508StaticText
      Name = 'VA508StaticText2'
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 533
      Height = 15
      Align = alTop
      Alignment = taLeftJustify
      Caption = 'Monograph Information'
      TabOrder = 0
      ShowAccelChar = True
    end
    object monoMemo: TCaptionMemo
      AlignWithMargins = True
      Left = 3
      Top = 24
      Width = 533
      Height = 273
      Align = alClient
      Lines.Strings = (
        'monoMemo')
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 1
      Caption = ''
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 408
    Top = 96
    Data = (
      (
        'Component = monoMemo'
        'Status = stsDefault')
      (
        'Component = monoCmbLst'
        'Status = stsDefault')
      (
        'Component = frmOCMonograph'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = pnlTop'
        'Status = stsDefault')
      (
        'Component = pnlCanvas'
        'Status = stsDefault'))
  end
  object VA508ComponentAccessibility1: TVA508ComponentAccessibility
    Component = monoCmbLst
    OnCaptionQuery = VA508ComponentAccessibility1CaptionQuery
    Left = 240
    Top = 96
  end
end
