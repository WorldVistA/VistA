inherited frmSignItem: TfrmSignItem
  Left = 320
  Top = 440
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Electronic Signature'
  ClientHeight = 124
  ClientWidth = 405
  OldCreateOrder = True
  Position = poScreenCenter
  ExplicitWidth = 411
  ExplicitHeight = 153
  PixelsPerInch = 96
  TextHeight = 13
  object lblESCode: TLabel [0]
    Left = 8
    Top = 81
    Width = 73
    Height = 13
    Caption = 'Signature Code'
  end
  object lblText: TMemo [1]
    Left = 8
    Top = 8
    Width = 389
    Height = 65
    BorderStyle = bsNone
    Color = clBtnFace
    Lines.Strings = (
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789')
    ReadOnly = True
    TabOrder = 1
  end
  object txtESCode: TCaptionEdit [2]
    Left = 8
    Top = 95
    Width = 141
    Height = 21
    PasswordChar = '*'
    TabOrder = 0
    Caption = 'Signature Code'
  end
  object cmdOK: TButton [3]
    Left = 239
    Top = 95
    Width = 72
    Height = 21
    Caption = 'OK'
    Default = True
    TabOrder = 2
    OnClick = cmdOKClick
  end
  object cmdCancel: TButton [4]
    Left = 325
    Top = 95
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
        'Component = lblText'
        'Status = stsDefault')
      (
        'Component = txtESCode'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = frmSignItem'
        'Status = stsDefault'))
  end
end
