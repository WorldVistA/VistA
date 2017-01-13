inherited frmOnChartOrders: TfrmOnChartOrders
  Left = 292
  Top = 149
  Caption = 'Signature on Chart'
  ClientHeight = 420
  ClientWidth = 569
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitWidth = 470
  ExplicitHeight = 375
  PixelsPerInch = 120
  TextHeight = 16
  object Panel2: TPanel [0]
    Left = 0
    Top = 0
    Width = 569
    Height = 375
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    Constraints.MinHeight = 295
    TabOrder = 0
    OnResize = Panel2Resize
    object Label1: TLabel
      Left = 1
      Top = 1
      Width = 567
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      Caption = 
        'The following orders will be marked '#39'Signed on Chart'#39' and releas' +
        'ed -'
      Layout = tlBottom
      ExplicitWidth = 404
    end
    object lstOrders: TCaptionListBox
      Left = 1
      Top = 22
      Width = 566
      Height = 351
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
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
    Top = 375
    Width = 569
    Height = 45
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      569
      45)
    object cmdOK: TButton
      Left = 368
      Top = 11
      Width = 89
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      Default = True
      TabOrder = 0
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      Left = 466
      Top = 11
      Width = 89
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
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
