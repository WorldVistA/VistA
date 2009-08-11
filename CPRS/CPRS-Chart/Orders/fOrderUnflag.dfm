inherited frmUnflagOrder: TfrmUnflagOrder
  Left = 365
  Top = 389
  Caption = 'Unflag Order'
  ClientHeight = 203
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitWidth = 320
  ExplicitHeight = 230
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 8
    Top = 123
    Width = 90
    Height = 13
    Caption = 'Comment (optional)'
  end
  object txtComment: TCaptionEdit [1]
    Left = 8
    Top = 137
    Width = 411
    Height = 21
    MaxLength = 80
    TabOrder = 0
    Caption = 'Comment (optional)'
  end
  object cmdOK: TButton [2]
    Left = 267
    Top = 174
    Width = 72
    Height = 21
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = cmdOKClick
  end
  object cmdCancel: TButton [3]
    Left = 347
    Top = 174
    Width = 72
    Height = 21
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = cmdCancelClick
  end
  object memReason: TMemo [4]
    Left = 8
    Top = 80
    Width = 411
    Height = 35
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 4
    WantReturns = False
  end
  object memOrder: TMemo [5]
    Left = 8
    Top = 8
    Width = 411
    Height = 56
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 3
    WantReturns = False
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = txtComment'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = memReason'
        'Status = stsDefault')
      (
        'Component = memOrder'
        'Status = stsDefault')
      (
        'Component = frmUnflagOrder'
        'Status = stsDefault'))
  end
end
