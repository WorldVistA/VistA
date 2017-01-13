inherited frmOrdersReleaseEvent: TfrmOrdersReleaseEvent
  Left = 410
  Top = 145
  Caption = 'Release to Service'
  ClientHeight = 567
  ClientWidth = 598
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 494
  ExplicitHeight = 495
  PixelsPerInch = 120
  TextHeight = 16
  object lblRelease: TLabel [0]
    Left = 0
    Top = 0
    Width = 598
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    Layout = tlCenter
    WordWrap = True
    ExplicitWidth = 3
  end
  object pnlMiddle: TPanel [1]
    Left = 0
    Top = 16
    Width = 598
    Height = 508
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    TabOrder = 0
    object cklstOrders: TCaptionCheckListBox
      Left = 1
      Top = 1
      Width = 596
      Height = 506
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      ParentShowHint = False
      ShowHint = True
      Style = lbOwnerDrawVariable
      TabOrder = 0
      OnDrawItem = cklstOrdersDrawItem
      OnMeasureItem = cklstOrdersMeasureItem
      OnMouseMove = cklstOrdersMouseMove
      Caption = ''
    end
  end
  object pnlBottom: TPanel [2]
    Left = 0
    Top = 524
    Width = 598
    Height = 43
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      598
      43)
    object btnOK: TButton
      Left = 399
      Top = 10
      Width = 85
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akTop, akRight, akBottom]
      Caption = 'OK'
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 497
      Top = 10
      Width = 85
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akTop, akRight, akBottom]
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlMiddle'
        'Status = stsDefault')
      (
        'Component = cklstOrders'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = frmOrdersReleaseEvent'
        'Status = stsDefault'))
  end
end
