inherited frmRenewOrders: TfrmRenewOrders
  Left = 434
  Top = 232
  HorzScrollBar.Tracking = True
  HorzScrollBar.Visible = True
  VertScrollBar.Tracking = True
  Caption = 'Renew Orders'
  ClientHeight = 416
  ClientWidth = 592
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  ExplicitWidth = 600
  ExplicitHeight = 443
  PixelsPerInch = 96
  TextHeight = 13
  object hdrOrders: THeaderControl [0]
    Left = 0
    Top = 0
    Width = 592
    Height = 17
    Constraints.MinHeight = 17
    Sections = <
      item
        AutoSize = True
        ImageIndex = -1
        Text = 'Order to be Renewed'
        Width = 296
      end
      item
        AutoSize = True
        ImageIndex = -1
        Text = 'Start/Stop Time'
        Width = 296
      end>
    OnSectionResize = hdrOrdersSectionResize
  end
  object pnlBottom: TPanel [1]
    Left = 0
    Top = 393
    Width = 592
    Height = 23
    Align = alBottom
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoSize = True
    TabOrder = 2
    DesignSize = (
      592
      23)
    object cmdCancel: TButton
      Left = 512
      Top = 1
      Width = 72
      Height = 21
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancel'
      Constraints.MinHeight = 21
      TabOrder = 2
      OnClick = cmdCancelClick
    end
    object cmdOK: TButton
      Left = 424
      Top = 1
      Width = 72
      Height = 21
      Anchors = [akTop, akRight]
      Caption = 'OK'
      Constraints.MinHeight = 21
      Default = True
      TabOrder = 1
      OnClick = cmdOKClick
    end
    object cmdChange: TButton
      Left = 8
      Top = 1
      Width = 145
      Height = 21
      Caption = 'Change...'
      Constraints.MinHeight = 21
      Enabled = False
      TabOrder = 0
      OnClick = cmdChangeClick
    end
  end
  object lstOrders: TCaptionListBox [2]
    Left = 0
    Top = 17
    Width = 592
    Height = 376
    Style = lbOwnerDrawVariable
    Align = alClient
    Anchors = []
    Color = clCream
    Ctl3D = True
    ExtendedSelect = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 24
    ParentCtl3D = False
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnClick = lstOrdersClick
    OnDrawItem = lstOrdersDrawItem
    OnMeasureItem = lstOrdersMeasureItem
    HintOnItem = True
    ExplicitTop = 12
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = hdrOrders'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdChange'
        'Status = stsDefault')
      (
        'Component = lstOrders'
        'Status = stsDefault')
      (
        'Component = frmRenewOrders'
        'Status = stsDefault'))
  end
end
