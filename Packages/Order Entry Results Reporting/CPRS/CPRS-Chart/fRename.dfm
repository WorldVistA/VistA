inherited frmRename: TfrmRename
  Left = 376
  Top = 317
  Caption = 'Rename'
  ClientHeight = 109
  ClientWidth = 316
  OnCreate = FormCreate
  ExplicitWidth = 324
  ExplicitHeight = 136
  PixelsPerInch = 96
  TextHeight = 13
  object lblRename: TLabel [0]
    Left = 8
    Top = 20
    Width = 63
    Height = 13
    Caption = 'Rename Item'
  end
  object txtName: TCaptionEdit [1]
    Left = 8
    Top = 34
    Width = 300
    Height = 21
    TabOrder = 0
    Caption = 'Rename Item'
  end
  object cmdOK: TButton [2]
    Left = 156
    Top = 80
    Width = 72
    Height = 21
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = cmdOKClick
  end
  object cmdCancel: TButton [3]
    Left = 236
    Top = 80
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
        'Component = txtName'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = frmRename'
        'Status = stsDefault'))
  end
end
