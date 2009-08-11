inherited frmODChild: TfrmODChild
  Left = 433
  Top = 271
  Caption = 'Associated Complex Orders'
  ClientHeight = 426
  ClientWidth = 504
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  ExplicitWidth = 512
  ExplicitHeight = 453
  PixelsPerInch = 96
  TextHeight = 13
  object lblWarning: TLabel [0]
    Left = 0
    Top = 0
    Width = 504
    Height = 59
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
    Top = 59
    Width = 504
    Height = 326
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 3
    BorderStyle = bsSingle
    TabOrder = 0
    object lstODComplex: TListBox
      Left = 3
      Top = 3
      Width = 494
      Height = 316
      Style = lbOwnerDrawVariable
      Align = alClient
      ItemHeight = 16
      TabOrder = 0
      OnDrawItem = lstODComplexDrawItem
      OnMeasureItem = lstODComplexMeasureItem
    end
  end
  object Panel2: TPanel [2]
    Left = 0
    Top = 385
    Width = 504
    Height = 41
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      504
      41)
    object btnOK: TButton
      Left = 332
      Top = 12
      Width = 75
      Height = 21
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 416
      Top = 12
      Width = 75
      Height = 21
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
