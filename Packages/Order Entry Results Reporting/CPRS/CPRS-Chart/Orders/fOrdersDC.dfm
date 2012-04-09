inherited frmDCOrders: TfrmDCOrders
  Left = 316
  Top = 226
  Caption = 'Discontinue / Cancel Orders'
  ClientHeight = 289
  ClientWidth = 425
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitLeft = 316
  ExplicitTop = 226
  ExplicitWidth = 433
  ExplicitHeight = 323
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 0
    Top = 0
    Width = 425
    Height = 13
    Align = alTop
    Caption = 'The following orders will be discontinued -'
    WordWrap = True
    ExplicitWidth = 196
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 13
    Width = 425
    Height = 188
    Align = alClient
    TabOrder = 0
    object lstOrders: TCaptionListBox
      Left = 1
      Top = 1
      Width = 423
      Height = 186
      Style = lbOwnerDrawVariable
      Align = alClient
      ItemHeight = 13
      TabOrder = 0
      OnDrawItem = lstOrdersDrawItem
      OnMeasureItem = lstOrdersMeasureItem
      Caption = 'The following orders will be discontinued '
    end
  end
  object Panel2: TPanel [2]
    Left = 0
    Top = 201
    Width = 425
    Height = 88
    Align = alBottom
    Constraints.MinHeight = 88
    TabOrder = 1
    DesignSize = (
      425
      88)
    object lblReason: TLabel
      Left = 1
      Top = 1
      Width = 423
      Height = 13
      Align = alTop
      Caption = 'Reason for Discontinue (select one)'
      ExplicitWidth = 169
    end
    object lstReason: TORListBox
      Left = 3
      Top = 19
      Width = 218
      Height = 60
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Caption = 'Reason for Discontinue (select one)'
      ItemTipColor = clWindow
      LongList = False
      Pieces = '2'
    end
    object cmdOK: TButton
      Left = 267
      Top = 54
      Width = 72
      Height = 21
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      Default = True
      TabOrder = 2
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      Left = 347
      Top = 54
      Width = 72
      Height = 21
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 3
      OnClick = cmdCancelClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = lstOrders'
        'Status = stsDefault')
      (
        'Component = Panel2'
        'Status = stsDefault')
      (
        'Component = lstReason'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = frmDCOrders'
        'Status = stsDefault'))
  end
end
