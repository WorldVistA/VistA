inherited frmOnChartOrders: TfrmOnChartOrders
  Left = 292
  Top = 149
  Caption = 'Signature on Chart'
  ClientHeight = 341
  ClientWidth = 462
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitWidth = 470
  ExplicitHeight = 375
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel [0]
    Left = 0
    Top = 0
    Width = 462
    Height = 305
    Align = alClient
    Constraints.MinHeight = 240
    TabOrder = 0
    OnResize = Panel2Resize
    object Label1: TLabel
      Left = 1
      Top = 1
      Width = 460
      Height = 13
      Align = alTop
      Caption = 
        'The following orders will be marked '#39'Signed on Chart'#39' and releas' +
        'ed -'
      Layout = tlBottom
      ExplicitWidth = 318
    end
    object lstOrders: TCaptionListBox
      Left = 1
      Top = 18
      Width = 460
      Height = 285
      Style = lbOwnerDrawVariable
      Align = alCustom
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 13
      ScrollWidth = 450
      TabOrder = 0
      OnDrawItem = lstOrdersDrawItem
      OnMeasureItem = lstOrdersMeasureItem
      Caption = 
        'The following orders will be marked '#39'Signed on Chart'#39' and releas' +
        'ed '
    end
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 305
    Width = 462
    Height = 36
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      462
      36)
    object cmdOK: TButton
      Left = 299
      Top = 9
      Width = 72
      Height = 21
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      Default = True
      TabOrder = 0
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      Left = 379
      Top = 9
      Width = 72
      Height = 21
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = cmdCancelClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = Panel2'
        'Status = stsDefault')
      (
        'Component = lstOrders'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = frmOnChartOrders'
        'Status = stsDefault'))
  end
end
