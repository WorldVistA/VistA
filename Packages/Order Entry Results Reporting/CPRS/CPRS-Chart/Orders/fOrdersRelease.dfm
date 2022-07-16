inherited frmReleaseOrders: TfrmReleaseOrders
  Left = 318
  Top = 186
  Caption = 'Release Orders to Service(s)'
  ClientHeight = 422
  Position = poScreenCenter
  ExplicitHeight = 461
  PixelsPerInch = 120
  TextHeight = 13
  object Panel1: TPanel [0]
    Left = 0
    Top = 0
    Width = 427
    Height = 364
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel1'
    Constraints.MinHeight = 320
    TabOrder = 0
    OnResize = Panel1Resize
    DesignSize = (
      427
      364)
    object Label1: TLabel
      Left = 0
      Top = 0
      Width = 427
      Height = 13
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      Caption = 'The following orders will be released -'
      ExplicitWidth = 176
    end
    object lstOrders: TCaptionListBox
      Left = 1
      Top = 20
      Width = 523
      Height = 338
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
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
    Top = 364
    Width = 427
    Height = 58
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    TabOrder = 1
    object grpRelease: TGroupBox
      Left = 10
      Top = 4
      Width = 296
      Height = 50
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Nature of Orders'
      TabOrder = 0
      object radVerbal: TRadioButton
        Left = 10
        Top = 20
        Width = 65
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = '&Verbal'
        TabOrder = 0
      end
      object radPhone: TRadioButton
        Left = 98
        Top = 20
        Width = 95
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = '&Telephone'
        TabOrder = 1
      end
      object radPolicy: TRadioButton
        Left = 207
        Top = 20
        Width = 60
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = '&Policy'
        TabOrder = 2
      end
    end
    object cmdOK: TButton
      Left = 329
      Top = 23
      Width = 88
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'OK'
      Default = True
      TabOrder = 1
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      Left = 427
      Top = 23
      Width = 89
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
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
