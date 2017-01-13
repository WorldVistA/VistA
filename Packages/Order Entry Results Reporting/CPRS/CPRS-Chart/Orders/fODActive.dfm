inherited frmODActive: TfrmODActive
  Left = 267
  Top = 216
  Caption = 'Copy active orders for selected event'
  ClientHeight = 389
  ClientWidth = 663
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitWidth = 320
  ExplicitHeight = 240
  PixelsPerInch = 120
  TextHeight = 16
  object lblCaption: TLabel [0]
    Left = 0
    Top = 0
    Width = 663
    Height = 36
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    AutoSize = False
    Caption = '  Highlight orders to be copied to delayed release event'
    Layout = tlCenter
    WordWrap = True
  end
  object pnlClient: TPanel [1]
    Left = 0
    Top = 36
    Width = 663
    Height = 353
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    BevelOuter = bvNone
    Locked = True
    TabOrder = 0
    DesignSize = (
      663
      353)
    object btnOK: TButton
      Left = 475
      Top = 332
      Width = 70
      Height = 25
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 564
      Top = 332
      Width = 70
      Height = 25
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akRight, akBottom]
      Caption = 'Cancel'
      TabOrder = 3
      OnClick = btnCancelClick
    end
    object lstActiveOrders: TCaptionListBox
      Left = 0
      Top = 26
      Width = 663
      Height = 298
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Style = lbOwnerDrawVariable
      Align = alTop
      Anchors = [akLeft, akTop, akRight, akBottom]
      MultiSelect = True
      TabOrder = 1
      OnDblClick = btnOKClick
      OnDrawItem = lstActiveOrdersDrawItem
      OnMeasureItem = lstActiveOrdersMeasureItem
      Caption = '  Copy selected active orders to the release event'
    end
    object hdControl: THeaderControl
      Left = 0
      Top = 0
      Width = 663
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Sections = <
        item
          ImageIndex = -1
          MinWidth = 50
          Text = 'Service'
          Width = 100
        end
        item
          ImageIndex = -1
          MinWidth = 200
          Text = 'Orders'
          Width = 280
        end
        item
          ImageIndex = -1
          MinWidth = 50
          Text = 'Start / Stop'
          Width = 112
        end
        item
          ImageIndex = -1
          MinWidth = 50
          Text = 'Status'
          Width = 80
        end>
      OnSectionResize = hdControlSectionResize
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlClient'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = lstActiveOrders'
        'Status = stsDefault')
      (
        'Component = hdControl'
        'Status = stsDefault')
      (
        'Component = frmODActive'
        'Status = stsDefault'))
  end
end
