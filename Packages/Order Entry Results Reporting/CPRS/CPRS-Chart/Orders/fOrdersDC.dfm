inherited frmDCOrders: TfrmDCOrders
  Left = 316
  Top = 226
  Caption = 'Discontinue / Cancel Orders'
  ClientHeight = 356
  ClientWidth = 523
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitWidth = 539
  ExplicitHeight = 394
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel [0]
    Left = 0
    Top = 0
    Width = 523
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    Caption = 'The following orders will be discontinued -'
    WordWrap = True
    ExplicitWidth = 247
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 16
    Width = 523
    Height = 184
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    TabOrder = 0
    ExplicitHeight = 231
    object lstOrders: TCaptionListBox
      Left = 1
      Top = 1
      Width = 521
      Height = 182
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Style = lbOwnerDrawVariable
      Align = alClient
      ItemHeight = 13
      TabOrder = 0
      OnDrawItem = lstOrdersDrawItem
      OnMeasureItem = lstOrdersMeasureItem
      Caption = 'The following orders will be discontinued '
      ExplicitHeight = 229
    end
  end
  object Panel2: TPanel [2]
    Left = 0
    Top = 200
    Width = 523
    Height = 156
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    Constraints.MinHeight = 108
    TabOrder = 1
    DesignSize = (
      523
      156)
    object lblReason: TLabel
      Left = 1
      Top = 1
      Width = 521
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      Caption = 'Reason for Discontinue (select one)'
      ExplicitWidth = 212
    end
    object lstReason: TORListBox
      Left = 1
      Top = 25
      Width = 268
      Height = 116
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      IntegralHeight = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Caption = 'Reason for Discontinue (select one)'
      ItemTipColor = clWindow
      LongList = False
      Pieces = '2'
    end
    object cmdOK: TButton
      Left = 329
      Top = 113
      Width = 88
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      Default = True
      TabOrder = 2
      OnClick = cmdOKClick
      ExplicitTop = 66
    end
    object cmdCancel: TButton
      Left = 427
      Top = 113
      Width = 89
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 3
      OnClick = cmdCancelClick
      ExplicitTop = 66
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = lstOrders'
        'Status = stsDefault')
      (
        'Component = Panel2'
        'Status = stsDefault')
      (
        'Component = lstReason'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = frmDCOrders'
        'Status = stsDefault'))
  end
end
