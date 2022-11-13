inherited frmParkOrders: TfrmParkOrders
  Left = 0
  Top = 0
  Caption = 'Park Orders'
  ClientHeight = 243
  Font.Name = 'Tahoma'
  OldCreateOrder = False
  Position = poScreenCenter
  ExplicitHeight = 270
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 8
    Top = 8
    Width = 172
    Height = 13
    Caption = 'The following orders will be parked -'
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
    TabOrder = 2
    OnClick = cmdOKClick
  end
  object cmdCancel: TButton [3]
    Left = 347
    Top = 214
    Width = 72
    Height = 21
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 3
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
        'Component = frmParkOrders'
        'Status = stsDefault'))
  end
end
