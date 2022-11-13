inherited frmActivateDeactive: TfrmActivateDeactive
  Left = 293
  Top = 317
  BorderIcons = []
  Caption = 'Renew Order'
  ClientHeight = 185
  ClientWidth = 569
  OldCreateOrder = False
  ExplicitWidth = 587
  ExplicitHeight = 230
  DesignSize = (
    569
    185)
  PixelsPerInch = 96
  TextHeight = 16
  object TActivate: TButton [0]
    Left = 206
    Top = 157
    Width = 106
    Height = 25
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'DC Pending Order'
    TabOrder = 2
    OnClick = TActivateClick
  end
  object TDeactive: TButton [1]
    Left = 132
    Top = 157
    Width = 63
    Height = 25
    Caption = 'DC BOTH'
    TabOrder = 1
    OnClick = TDeactiveClick
  end
  object Memo1: TMemo [2]
    Left = 0
    Top = 0
    Width = 569
    Height = 145
    BorderStyle = bsNone
    Color = clBtnFace
    Lines.Strings = (
      'Memo1')
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object TCancel: TButton [3]
    Left = 324
    Top = 157
    Width = 137
    Height = 25
    Caption = 'Cancel-No Action Taken'
    TabOrder = 3
    OnClick = TCancelClick
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = TActivate'
        'Status = stsDefault')
      (
        'Component = TDeactive'
        'Status = stsDefault')
      (
        'Component = Memo1'
        'Status = stsDefault')
      (
        'Component = TCancel'
        'Status = stsDefault')
      (
        'Component = frmActivateDeactive'
        'Status = stsDefault'))
  end
end
