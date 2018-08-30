inherited frmVerifyOrders: TfrmVerifyOrders
  Left = 341
  Top = 182
  Caption = 'Verify Orders'
  ClientHeight = 334
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitWidth = 320
  ExplicitHeight = 367
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel [0]
    Left = 0
    Top = 0
    Width = 427
    Height = 289
    Align = alClient
    Constraints.MinHeight = 256
    TabOrder = 1
    OnResize = Panel1Resize
    ExplicitWidth = 421
    DesignSize = (
      427
      289)
    object lblVerify: TLabel
      Left = 1
      Top = 1
      Width = 425
      Height = 13
      Align = alTop
      Caption = 'The following orders will be marked as verified -'
      ExplicitWidth = 222
    end
    object lstOrders: TCaptionListBox
      Left = 4
      Top = 16
      Width = 413
      Height = 270
      Style = lbOwnerDrawVariable
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 13
      ScrollWidth = 409
      TabOrder = 0
      OnDrawItem = lstOrdersDrawItem
      OnMeasureItem = lstOrdersMeasureItem
      Caption = 'The following orders will be released from hold '
    end
  end
  object Panel2: TPanel [1]
    Left = 0
    Top = 289
    Width = 427
    Height = 45
    Align = alBottom
    TabOrder = 0
    ExplicitWidth = 421
    object lblESCode: TLabel
      Left = 8
      Top = 4
      Width = 123
      Height = 13
      Caption = 'Electronic Signature Code'
    end
    object txtESCode: TCaptionEdit
      Left = 8
      Top = 20
      Width = 134
      Height = 21
      PasswordChar = '*'
      TabOrder = 0
      Caption = 'Electronic Signature Code'
    end
    object cmdOK: TButton
      Left = 263
      Top = 20
      Width = 71
      Height = 20
      Caption = 'OK'
      Default = True
      TabOrder = 2
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      Left = 342
      Top = 20
      Width = 71
      Height = 20
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
        'Component = txtESCode'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = frmVerifyOrders'
        'Status = stsDefault'))
  end
end
