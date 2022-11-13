inherited frmODActive: TfrmODActive
  Left = 267
  Top = 216
  Caption = 'Copy active orders for selected event'
  ClientHeight = 307
  ClientWidth = 584
  OldCreateOrder = False
  Position = poScreenCenter
  ExplicitWidth = 600
  ExplicitHeight = 345
  PixelsPerInch = 96
  TextHeight = 16
  object lblCaption: TLabel [0]
    Left = 0
    Top = 0
    Width = 584
    Height = 29
    Align = alTop
    AutoSize = False
    Caption = '  Highlight orders to be copied to delayed release event'
    Layout = tlCenter
    WordWrap = True
    ExplicitWidth = 530
  end
  object pnlClient: TPanel [1]
    Left = 0
    Top = 29
    Width = 584
    Height = 278
    Align = alClient
    BevelOuter = bvNone
    Locked = True
    TabOrder = 0
    DesignSize = (
      584
      278)
    object btnOK: TButton
      Left = 458
      Top = 255
      Width = 56
      Height = 20
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 520
      Top = 255
      Width = 56
      Height = 20
      Anchors = [akRight, akBottom]
      Caption = 'Cancel'
      TabOrder = 3
      OnClick = btnCancelClick
    end
    object lstActiveOrders: TCaptionListBox
      Left = 0
      Top = 21
      Width = 584
      Height = 228
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
      Width = 584
      Height = 21
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
    Left = 24
    Top = 8
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
