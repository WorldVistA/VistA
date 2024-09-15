inherited frmEncounterFrame: TfrmEncounterFrame
  Left = 290
  Top = 108
  Caption = 'Encounter Frame'
  ClientHeight = 424
  ClientWidth = 632
  FormStyle = fsMDIForm
  Position = poMainFormCenter
  OnCanResize = FormCanResize
  OnCloseQuery = FormCloseQuery
  OnResize = FormResize
  ExplicitWidth = 650
  ExplicitHeight = 469
  TextHeight = 13
  object Bevel1: TBevel [0]
    Left = 0
    Top = 0
    Width = 632
    Height = 2
    Align = alTop
  end
  object StatusBar1: TStatusBar [1]
    Left = 0
    Top = 424
    Width = 632
    Height = 0
    Panels = <>
  end
  object pnlPage: TPanel [2]
    Left = 0
    Top = 24
    Width = 632
    Height = 400
    Align = alClient
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object TabControl: TTabControl [3]
    Left = 0
    Top = 2
    Width = 632
    Height = 22
    Align = alTop
    TabOrder = 2
    OnChange = TabControlChange
    OnChanging = TabControlChanging
    OnEnter = TabControlEnter
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = StatusBar1'
        'Status = stsDefault')
      (
        'Component = pnlPage'
        'Status = stsDefault')
      (
        'Component = TabControl'
        'Status = stsDefault')
      (
        'Component = frmEncounterFrame'
        'Status = stsDefault'))
  end
end
