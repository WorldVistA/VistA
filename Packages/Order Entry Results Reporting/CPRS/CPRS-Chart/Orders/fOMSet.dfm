inherited frmOMSet: TfrmOMSet
  Left = 209
  Top = 191
  BorderIcons = []
  Caption = 'Selected Orders'
  ClientHeight = 249
  ClientWidth = 140
  FormStyle = fsStayOnTop
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 113
  ExplicitHeight = 229
  DesignSize = (
    140
    249)
  PixelsPerInch = 120
  TextHeight = 16
  object lstSet: TCheckListBox [0]
    Left = 0
    Top = 0
    Width = 128
    Height = 203
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = clBtnFace
    Enabled = False
    ItemHeight = 13
    TabOrder = 0
  end
  object cmdInterupt: TButton [1]
    Left = 5
    Top = 212
    Width = 118
    Height = 32
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'Stop Order Set'
    TabOrder = 1
    OnClick = cmdInteruptClick
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = lstSet'
        'Status = stsDefault')
      (
        'Component = cmdInterupt'
        'Status = stsDefault')
      (
        'Component = frmOMSet'
        'Status = stsDefault'))
  end
end
