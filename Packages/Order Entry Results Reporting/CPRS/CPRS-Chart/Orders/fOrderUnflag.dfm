inherited frmUnflagOrder: TfrmUnflagOrder
  Left = 365
  Top = 389
  Caption = 'Unflag Order'
  ClientHeight = 221
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitHeight = 259
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 8
    Top = 123
    Width = 96
    Height = 13
    Caption = 'Comment (Required)'
  end
  object txtComment: TCaptionEdit [1]
    Left = 8
    Top = 137
    Width = 411
    Height = 21
    MaxLength = 240
    TabOrder = 0
    Caption = 'Comment (optional)'
  end
  object cmdOK: TButton [2]
    Left = 232
    Top = 192
    Width = 107
    Height = 21
    Anchors = [akRight, akBottom]
    Caption = 'Submit Comment'
    Default = True
    TabOrder = 1
    OnClick = cmdOKClick
  end
  object cmdCancel: TButton [3]
    Left = 347
    Top = 192
    Width = 72
    Height = 21
    Anchors = [akRight, akBottom]
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
        'Text = Submit Unflagging Comment'
        'Status = stsOK')
      (
        'Component = cmdCancel'
        'Text = Cancel Unflagging Comment'
        'Status = stsOK')
      (
        'Component = memReason'
        'Text = Add an Unflagging Comment'
        'Status = stsOK')
      (
        'Component = memOrder'
        'Status = stsDefault')
      (
        'Component = frmUnflagOrder'
        'Status = stsDefault'))
  end
end
