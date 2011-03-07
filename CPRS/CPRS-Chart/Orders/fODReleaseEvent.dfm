inherited frmOrdersReleaseEvent: TfrmOrdersReleaseEvent
  Left = 410
  Top = 145
  Caption = 'Release to Service'
  ClientHeight = 461
  ClientWidth = 486
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 494
  ExplicitHeight = 495
  PixelsPerInch = 96
  TextHeight = 13
  object lblRelease: TLabel [0]
    Left = 0
    Top = 0
    Width = 486
    Height = 13
    Align = alTop
    Layout = tlCenter
    WordWrap = True
    ExplicitWidth = 3
  end
  object pnlMiddle: TPanel [1]
    Left = 0
    Top = 13
    Width = 486
    Height = 413
    Align = alClient
    TabOrder = 0
    object cklstOrders: TCaptionCheckListBox
      Left = 1
      Top = 1
      Width = 484
      Height = 411
      Align = alClient
      ItemHeight = 16
      ParentShowHint = False
      ShowHint = True
      Style = lbOwnerDrawVariable
      TabOrder = 0
      OnDrawItem = cklstOrdersDrawItem
      OnMeasureItem = cklstOrdersMeasureItem
      OnMouseMove = cklstOrdersMouseMove
    end
  end
  object pnlBottom: TPanel [2]
    Left = 0
    Top = 426
    Width = 486
    Height = 35
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      486
      35)
    object btnOK: TButton
      Left = 324
      Top = 8
      Width = 69
      Height = 20
      Anchors = [akTop, akRight, akBottom]
      Caption = 'OK'
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 404
      Top = 8
      Width = 69
      Height = 20
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
