inherited frmChangeEventDisp: TfrmChangeEventDisp
  Left = 344
  Top = 230
  Caption = 'Change release event'
  ClientHeight = 417
  ClientWidth = 400
  OldCreateOrder = False
  Position = poDesktopCenter
  ExplicitWidth = 408
  ExplicitHeight = 444
  PixelsPerInch = 96
  TextHeight = 13
  object lblTop: TMemo [0]
    Left = 0
    Top = 0
    Width = 400
    Height = 37
    TabStop = False
    Align = alTop
    BorderStyle = bsNone
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 2
  end
  object pnlTop: TPanel [1]
    Left = 0
    Top = 37
    Width = 400
    Height = 339
    Align = alClient
    BorderStyle = bsSingle
    TabOrder = 0
    object lstCVOrders: TCaptionListBox
      Left = 1
      Top = 1
      Width = 394
      Height = 333
      Style = lbOwnerDrawVariable
      Align = alClient
      ItemHeight = 13
      TabOrder = 0
      OnDrawItem = lstCVOrdersDrawItem
      OnMeasureItem = lstCVOrdersMeasureItem
    end
  end
  object pnlBottom: TPanel [2]
    Left = 0
    Top = 376
    Width = 400
    Height = 41
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      400
      41)
    object cmdOK: TButton
      Left = 230
      Top = 12
      Width = 75
      Height = 21
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      TabOrder = 0
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      Left = 314
      Top = 12
      Width = 75
      Height = 21
      Anchors = [akRight, akBottom]
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = cmdCancelClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = lblTop'
        'Status = stsDefault')
      (
        'Component = pnlTop'
        'Status = stsDefault')
      (
        'Component = lstCVOrders'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = frmChangeEventDisp'
        'Status = stsDefault'))
  end
end
