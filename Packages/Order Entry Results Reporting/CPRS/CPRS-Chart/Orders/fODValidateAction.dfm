inherited frmInvalidActionList: TfrmInvalidActionList
  Left = 445
  Top = 142
  Caption = 'Invalidated action orders'
  ClientHeight = 639
  ClientWidth = 647
  Position = poScreenCenter
  OnCreate = FormCreate
  OnResize = FormResize
  ExplicitWidth = 320
  ExplicitHeight = 240
  PixelsPerInch = 120
  TextHeight = 16
  object pnlTop: TPanel [0]
    Left = 0
    Top = 0
    Width = 647
    Height = 282
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 1
      Top = 1
      Width = 645
      Height = 30
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      AutoSize = False
      Caption = 'You can'#39't take this action on the following orders'
    end
    object lstActDeniedOrders: TCaptionListBox
      Left = 1
      Top = 64
      Width = 645
      Height = 217
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Style = lbOwnerDrawVariable
      Align = alClient
      TabOrder = 0
      OnDrawItem = lstActDeniedOrdersDrawItem
      OnMeasureItem = lstActDeniedOrdersMeasureItem
      Caption = 'You can'#39't take this action on the following orders'
    end
    object hdrAction: THeaderControl
      Left = 1
      Top = 31
      Width = 645
      Height = 33
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Sections = <
        item
          ImageIndex = -1
          MinWidth = 300
          Text = 'Order'
          Width = 350
        end
        item
          ImageIndex = -1
          MinWidth = 150
          Text = 'Reason'
          Width = 150
        end>
      OnSectionResize = hdrActionSectionResize
    end
  end
  object pnlBottom: TPanel [1]
    Left = 0
    Top = 282
    Width = 647
    Height = 306
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    TabOrder = 1
    object Label2: TLabel
      Left = 1
      Top = 1
      Width = 645
      Height = 49
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      AutoSize = False
      Caption = 'The following orders will be taken action:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
    end
    object lstValidOrders: TCaptionListBox
      Left = 1
      Top = 50
      Width = 645
      Height = 255
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Style = lbOwnerDrawVariable
      Align = alClient
      TabOrder = 0
      OnDrawItem = lstValidOrdersDrawItem
      OnMeasureItem = lstValidOrdersMeasureItem
      Caption = 'The following orders will be taken action'
    end
  end
  object Panel1: TPanel [2]
    Left = 0
    Top = 588
    Width = 647
    Height = 51
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    TabOrder = 2
    DesignSize = (
      647
      51)
    object btnOK: TButton
      Left = 542
      Top = 15
      Width = 92
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      TabOrder = 0
      OnClick = btnOKClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlTop'
        'Status = stsDefault')
      (
        'Component = lstActDeniedOrders'
        'Status = stsDefault')
      (
        'Component = hdrAction'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = lstValidOrders'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = frmInvalidActionList'
        'Status = stsDefault'))
  end
end
