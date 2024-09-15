inherited frmReleaseOrders: TfrmReleaseOrders
  Left = 318
  Top = 186
  Caption = 'Release Orders to Service(s)'
  ClientHeight = 343
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitWidth = 443
  ExplicitHeight = 381
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel [0]
    Left = 0
    Top = 0
    Width = 427
    Height = 296
    Align = alClient
    BevelOuter = bvNone
    Constraints.MinHeight = 260
    TabOrder = 0
    OnResize = Panel1Resize
    DesignSize = (
      427
      296)
    object Label1: TLabel
      Left = 0
      Top = 0
      Width = 427
      Height = 13
      Align = alTop
      Caption = 'The following orders will be released -'
      ExplicitWidth = 176
    end
    object lstOrders: TCaptionListBox
      Left = 1
      Top = 16
      Width = 425
      Height = 275
      Style = lbOwnerDrawVariable
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 13
      ScrollWidth = 415
      TabOrder = 0
      OnDrawItem = lstOrdersDrawItem
      OnMeasureItem = lstOrdersMeasureItem
      Caption = 'The following orders will be released '
    end
  end
  object Panel2: TPanel [1]
    Left = 0
    Top = 296
    Width = 427
    Height = 47
    Align = alBottom
    TabOrder = 1
    object grpRelease: TGroupBox
      Left = 8
      Top = 3
      Width = 241
      Height = 41
      Caption = 'Nature of Orders'
      TabOrder = 0
      object radVerbal: TRadioButton
        Left = 8
        Top = 16
        Width = 53
        Height = 17
        Caption = '&Verbal'
        TabOrder = 0
      end
      object radPhone: TRadioButton
        Left = 80
        Top = 16
        Width = 77
        Height = 17
        Caption = '&Telephone'
        TabOrder = 1
      end
      object radPolicy: TRadioButton
        Left = 168
        Top = 16
        Width = 49
        Height = 17
        Caption = '&Policy'
        TabOrder = 2
      end
    end
    object cmdOK: TButton
      Left = 267
      Top = 19
      Width = 72
      Height = 21
      Caption = 'OK'
      Default = True
      TabOrder = 1
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      Left = 347
      Top = 19
      Width = 72
      Height = 21
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 2
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
        'Component = grpRelease'
        'Status = stsDefault')
      (
        'Component = radVerbal'
        'Status = stsDefault')
      (
        'Component = radPhone'
        'Status = stsDefault')
      (
        'Component = radPolicy'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = frmReleaseOrders'
        'Status = stsDefault'))
  end
end
