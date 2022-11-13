inherited frmRefillOrders: TfrmRefillOrders
  Left = 181
  Top = 267
  Caption = 'Refill Orders'
  ClientHeight = 289
  Position = poDesigned
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  ExplicitWidth = 443
  ExplicitHeight = 327
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBottom: TPanel [0]
    Left = 0
    Top = 221
    Width = 427
    Height = 68
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitTop = 205
    object cmdOK: TButton
      Left = 234
      Top = 40
      Width = 72
      Height = 21
      Caption = 'OK'
      Default = True
      TabOrder = 0
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      Left = 314
      Top = 40
      Width = 72
      Height = 21
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = cmdCancelClick
    end
    object grbPickUp: TGroupBox
      Left = 42
      Top = 5
      Width = 136
      Height = 60
      Caption = ' Pick Up '
      TabOrder = 2
      object radWindow: TRadioButton
        Left = 12
        Top = 17
        Width = 113
        Height = 17
        Caption = 'at &Window'
        Checked = True
        TabOrder = 0
        TabStop = True
      end
      object radMail: TRadioButton
        Left = 12
        Top = 36
        Width = 113
        Height = 17
        Caption = 'by &Mail'
        TabOrder = 1
      end
    end
  end
  object pnlClient: TPanel [1]
    Left = 0
    Top = 0
    Width = 427
    Height = 221
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitHeight = 200
    object lblOrders: TLabel
      Left = 0
      Top = 0
      Width = 427
      Height = 13
      Align = alTop
      Caption = 'Request refills for the following orders -'
      ExplicitWidth = 181
    end
    object lstOrders: TCaptionListBox
      Left = 0
      Top = 13
      Width = 427
      Height = 208
      Style = lbOwnerDrawVariable
      Align = alClient
      ItemHeight = 13
      TabOrder = 0
      OnDrawItem = lstOrdersDrawItem
      OnMeasureItem = lstOrdersMeasureItem
      Caption = 'Request refills for the following orders '
      ExplicitHeight = 187
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
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
        'Component = grbPickUp'
        'Status = stsDefault')
      (
        'Component = radWindow'
        'Status = stsDefault')
      (
        'Component = radMail'
        'Status = stsDefault')
      (
        'Component = pnlClient'
        'Status = stsDefault')
      (
        'Component = lstOrders'
        'Status = stsDefault')
      (
        'Component = frmRefillOrders'
        'Status = stsDefault'))
  end
end
