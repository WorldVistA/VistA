inherited frmOMSet: TfrmOMSet
  Left = 209
  Top = 191
  BorderIcons = []
  Caption = 'Selected Orders'
  ClientHeight = 202
  ClientWidth = 116
  FormStyle = fsStayOnTop
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 132
  DesignSize = (
    116
    202)
  PixelsPerInch = 96
  TextHeight = 13
  object lstSet: TCheckListBox [0]
    Left = 0
    Top = 0
    Width = 104
    Height = 165
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = clBtnFace
    Enabled = False
    ItemHeight = 13
    TabOrder = 0
  end
  object cmdInterupt: TButton [1]
    Left = 4
    Top = 172
    Width = 96
    Height = 26
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
