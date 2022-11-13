inherited frmRenewOrders: TfrmRenewOrders
  Left = 434
  Top = 232
  HorzScrollBar.Tracking = True
  HorzScrollBar.Visible = True
  VertScrollBar.Tracking = True
  Caption = 'Renew Orders'
  ClientHeight = 412
  ClientWidth = 613
  Position = poScreenCenter
  Scaled = False
  OnShow = nil
  ExplicitWidth = 631
  ExplicitHeight = 457
  PixelsPerInch = 120
  TextHeight = 16
  object hdrOrders: THeaderControl [0]
    Left = 0
    Top = 0
    Width = 613
    Height = 17
    Constraints.MinHeight = 17
    Sections = <
      item
        AutoSize = True
        ImageIndex = -1
        Text = 'Order to be Renewed'
        Width = 307
      end
      item
        AutoSize = True
        ImageIndex = -1
        Text = 'Start/Stop Time'
        Width = 306
      end>
    OnSectionResize = hdrOrdersSectionResize
  end
  object pnlBottom: TPanel [1]
    Left = 0
    Top = 365
    Width = 613
    Height = 47
    Align = alBottom
    TabOrder = 2
    DesignSize = (
      613
      47)
    object cmdCancel: TButton
      Left = 529
      Top = 9
      Width = 72
      Height = 29
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancel'
      Constraints.MinHeight = 21
      TabOrder = 0
      OnClick = cmdCancelClick
    end
    object cmdChange: TButton
      Left = 9
      Top = 9
      Width = 153
      Height = 29
      Caption = 'Change...'
      Constraints.MinHeight = 21
      Enabled = False
      TabOrder = 1
      OnClick = cmdChangeClick
    end
    object cmdOK: TButton
      Left = 438
      Top = 9
      Width = 72
      Height = 29
      Anchors = [akTop, akRight]
      Caption = 'OK'
      Constraints.MinHeight = 21
      Default = True
      TabOrder = 2
      OnClick = cmdOKClick
    end
  end
  object lstOrders: TCaptionListBox [2]
    Left = 0
    Top = 17
    Width = 613
    Height = 348
    Style = lbOwnerDrawVariable
    Align = alClient
    Color = clCream
    Ctl3D = True
    ParentCtl3D = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnClick = lstOrdersClick
    OnDrawItem = lstOrdersDrawItem
    OnMeasureItem = lstOrdersMeasureItem
    Caption = ''
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = hdrOrders'
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
        'Component = frmRenewOrders'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = lstOrders'
        'Status = stsDefault'))
  end
end
