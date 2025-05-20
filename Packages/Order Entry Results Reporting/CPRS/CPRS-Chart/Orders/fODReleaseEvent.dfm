inherited frmOrdersReleaseEvent: TfrmOrdersReleaseEvent
  Left = 410
  Top = 145
  Caption = 'Release to Service'
  ClientHeight = 567
  ClientWidth = 598
  Constraints.MinHeight = 300
  Constraints.MinWidth = 350
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
    Top = 419
    Width = 478
    Height = 35
    Align = alBottom
    TabOrder = 1
    object pnlButtons: TPanel
      AlignWithMargins = True
      Left = 288
      Top = 3
      Width = 186
      Height = 29
      Margins.Top = 2
      Margins.Bottom = 2
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object btnOK: TButton
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 85
        Height = 23
        Align = alLeft
        Caption = 'OK'
        TabOrder = 0
        OnClick = btnOKClick
      end
      object btnCancel: TButton
        AlignWithMargins = True
        Left = 94
        Top = 3
        Width = 85
        Height = 23
        Align = alLeft
        Cancel = True
        Caption = 'Cancel'
        TabOrder = 1
        OnClick = btnCancelClick
      end
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
        'Status = stsDefault')
      (
        'Component = pnlButtons'
        'Status = stsDefault'))
  end
end
