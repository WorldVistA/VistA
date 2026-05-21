inherited frmEncounterFrame: TfrmEncounterFrame
  Left = 290
  Top = 108
  Caption = 'Encounter Frame'
  ClientHeight = 561
  ClientWidth = 784
  Constraints.MinHeight = 600
  Constraints.MinWidth = 800
  FormStyle = fsMDIForm
  Position = poMainFormCenter
  OnCanResize = FormCanResize
  OnCloseQuery = FormCloseQuery
  OnResize = FormResize
  OldCreateOrder = True
  ExplicitWidth = 800
  ExplicitHeight = 600
  TextHeight = 13
  object Bevel1: TBevel [0]
    Left = 0
    Top = 0
    Width = 784
    Height = 2
    Align = alTop
    ExplicitWidth = 632
  end
  object StatusBar1: TStatusBar [1]
    Left = 0
    Top = 561
    Width = 784
    Height = 0
    Panels = <>
  end
  object pnlPage: TPanel [2]
    Left = 0
    Top = 24
    Width = 784
    Height = 537
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
    Width = 784
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
