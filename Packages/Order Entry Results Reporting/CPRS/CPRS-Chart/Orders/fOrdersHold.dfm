inherited frmHoldOrders: TfrmHoldOrders
  Left = 386
  Top = 413
  Caption = 'Hold Orders'
  ClientHeight = 243
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitWidth = 320
  ExplicitHeight = 270
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 8
    Top = 8
    Width = 206
    Height = 13
    Caption = 'The following orders will be placed on hold -'
  end
  object lstOrders: TCaptionListBox [1]
    Left = 8
    Top = 22
    Width = 411
    Height = 176
    Style = lbOwnerDrawVariable
    ItemHeight = 13
    TabOrder = 0
    OnDrawItem = lstOrdersDrawItem
    OnMeasureItem = lstOrdersMeasureItem
    Caption = 'The following orders will be placed on hold -'
  end
  object cmdOK: TButton [2]
    Left = 267
    Top = 214
    Width = 72
    Height = 21
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = cmdOKClick
  end
  object cmdCancel: TButton [3]
    Left = 347
    Top = 214
    Width = 72
    Height = 21
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = cmdCancelClick
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = lstOrders'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = frmHoldOrders'
        'Status = stsDefault'))
  end
end
