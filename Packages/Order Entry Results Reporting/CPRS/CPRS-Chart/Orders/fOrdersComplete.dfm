inherited frmCompleteOrders: TfrmCompleteOrders
  Left = 327
  Top = 169
  Caption = 'Complete Orders'
  ClientHeight = 257
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitWidth = 320
  ExplicitHeight = 284
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 8
    Top = 8
    Width = 231
    Height = 13
    Caption = 'The following orders will be marked as complete -'
  end
  object lblESCode: TLabel [1]
    Left = 8
    Top = 214
    Width = 123
    Height = 13
    Caption = 'Electronic Signature Code'
  end
  object lstOrders: TCaptionListBox [2]
    Left = 8
    Top = 22
    Width = 411
    Height = 176
    ItemHeight = 13
    TabOrder = 3
    Caption = 'The following orders will be marked as complete -'
  end
  object cmdOK: TButton [3]
    Left = 267
    Top = 228
    Width = 72
    Height = 21
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = cmdOKClick
  end
  object cmdCancel: TButton [4]
    Left = 347
    Top = 228
    Width = 72
    Height = 21
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = cmdCancelClick
  end
  object txtESCode: TCaptionEdit [5]
    Left = 8
    Top = 228
    Width = 137
    Height = 21
    PasswordChar = '*'
    TabOrder = 0
    Caption = 'Electronic Signature Code'
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
        'Component = txtESCode'
        'Status = stsDefault')
      (
        'Component = frmCompleteOrders'
        'Status = stsDefault'))
  end
end
