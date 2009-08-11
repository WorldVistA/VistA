inherited frmUnholdOrders: TfrmUnholdOrders
  Left = 269
  Top = 192
  Caption = 'Release Orders from Hold'
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
    Width = 222
    Height = 13
    Caption = 'The following orders will be released from hold -'
  end
  object lstOrders: TCaptionListBox [1]
    Left = 8
    Top = 22
    Width = 411
    Height = 176
    ItemHeight = 13
    TabOrder = 0
    Caption = 'The following orders will be released from hold '
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
        'Component = frmUnholdOrders'
        'Status = stsDefault'))
  end
end
