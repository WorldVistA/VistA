inherited frmAnatPathPreview: TfrmAnatPathPreview
  Left = 0
  Top = 0
  Caption = 'Preview'
  ClientHeight = 574
  ClientWidth = 629
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lvwSpecimen: TListView
    Left = 0
    Top = 35
    Width = 629
    Height = 208
    Align = alTop
    Columns = <
      item
        Caption = '#'
        MinWidth = 30
        Width = 30
      end
      item
        Caption = 'Specimen'
        MinWidth = 100
        Width = 100
      end
      item
        Caption = 'Description'
        MinWidth = 200
        Width = 395
      end
      item
        Caption = 'Collection Sample'
        MinWidth = 100
        Width = 100
      end>
    GridLines = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
  end
  object memText: TCaptionMemo
    Left = 0
    Top = 243
    Width = 629
    Height = 298
    Align = alClient
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
    Caption = 'Order Comment and Word Processing Preview'
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 541
    Width = 629
    Height = 33
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    DesignSize = (
      629
      33)
    object btnAccept: TBitBtn
      Left = 408
      Top = 5
      Width = 136
      Height = 25
      Anchors = [akRight]
      Caption = '&Accept Order'
      Default = True
      ModalResult = 1
      NumGlyphs = 2
      TabOrder = 0
    end
    object btnBack: TBitBtn
      Left = 550
      Top = 5
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = '&Back'
      ModalResult = 2
      NumGlyphs = 2
      TabOrder = 1
      OnClick = btnBackClick
    end
  end
  object pnlSummary: TPanel
    Left = 0
    Top = 0
    Width = 629
    Height = 35
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 4
    TabStop = True
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 64
    Top = 96
    Data = (
      (
        'Component = frmAnatPathPreview'
        'Status = stsDefault')
      (
        'Component = lvwSpecimen'
        'Status = stsDefault')
      (
        'Component = memText'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = btnAccept'
        'Status = stsDefault')
      (
        'Component = btnBack'
        'Status = stsDefault')
      (
        'Component = pnlSummary'
        'Status = stsDefault'))
  end
end
