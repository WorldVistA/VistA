inherited frmODChild: TfrmODChild
  Left = 433
  Top = 271
  Caption = 'Associated Complex Orders'
  ClientHeight = 524
  ClientWidth = 620
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  ExplicitWidth = 512
  ExplicitHeight = 453
  PixelsPerInch = 120
  TextHeight = 16
  object lblWarning: TLabel [0]
    Left = 0
    Top = 0
    Width = 620
    Height = 73
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    AutoSize = False
    Caption = 
      'You have requested to discontinue a medication order which was e' +
      'ntered as part of a complex order. The following are the orders ' +
      'associated with the same complex order. Do you want to dicsconti' +
      'nue all of these orders?'
    WordWrap = True
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 73
    Width = 620
    Height = 401
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 3
    BorderStyle = bsSingle
    TabOrder = 0
    object lstODComplex: TListBox
      Left = 4
      Top = 4
      Width = 608
      Height = 389
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Style = lbOwnerDrawVariable
      Align = alClient
      TabOrder = 0
      OnDrawItem = lstODComplexDrawItem
      OnMeasureItem = lstODComplexMeasureItem
    end
  end
  object Panel2: TPanel [2]
    Left = 0
    Top = 474
    Width = 620
    Height = 50
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      620
      50)
    object btnOK: TButton
      Left = 409
      Top = 15
      Width = 92
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 512
      Top = 15
      Width = 92
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akRight, akBottom]
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = lstODComplex'
        'Status = stsDefault')
      (
        'Component = Panel2'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = frmODChild'
        'Status = stsDefault'))
  end
end
