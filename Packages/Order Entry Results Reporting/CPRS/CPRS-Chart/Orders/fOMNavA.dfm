inherited frmOMNavA: TfrmOMNavA
  Left = 212
  Top = 354
  BorderIcons = []
  Caption = 'Order Menu'
  ClientHeight = 348
  ClientWidth = 604
  OldCreateOrder = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  ExplicitWidth = 622
  ExplicitHeight = 393
  PixelsPerInch = 120
  TextHeight = 16
  object pnlTool: TPanel [0]
    Left = 0
    Top = 0
    Width = 604
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    BevelOuter = bvLowered
    Caption = 'Menu or Dialog Name'
    Color = clHighlight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlightText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 1
    OnMouseDown = pnlToolMouseDown
    OnMouseMove = pnlToolMouseMove
    OnMouseUp = pnlToolMouseUp
    object cmdDone: TORAlignButton
      Left = 540
      Top = 1
      Width = 63
      Height = 22
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alRight
      Caption = 'Done'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBtnText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = cmdDoneClick
    end
    object cmdPrev: TBitBtn
      Left = 0
      Top = 1
      Width = 25
      Height = 22
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Back'
      Enabled = False
      Glyph.Data = {
        06010000424D06010000000000007600000028000000180000000C0000000100
        0400000000009000000000000000000000001000000010000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333377333
        3333333773333333337C7333333333777333333337CC73333333377373333333
        7CCC73333333773373333337CCCC7333333773337333337CCCCC733333373333
        733333CCCCCC7333337333337333333CCCCC73333337333373333333CCCC7333
        33337333733333333CCC7333333337337333333333CC73333333337373333333
        333C3333333333373333}
      Layout = blGlyphTop
      Margin = 0
      NumGlyphs = 2
      Spacing = 80
      TabOrder = 1
      OnClick = cmdPrevClick
    end
    object cmdNext: TBitBtn
      Left = 25
      Top = 1
      Width = 26
      Height = 22
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Forward'
      Enabled = False
      Glyph.Data = {
        06010000424D06010000000000007600000028000000180000000C0000000100
        0400000000009000000000000000000000001000000010000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333733333333
        333733333333333C73333333333773333333333CC7333333333777333333333C
        CC733333333737733333333CCCC73333333733773333333CCCCC733333373337
        7333333CCCCCC333333733337333333CCCCC3333333733373333333CCCC33333
        333733733333333CCC333333333737333333333CC3333333333773333333333C
        33333333333733333333}
      Layout = blGlyphTop
      Margin = 0
      NumGlyphs = 2
      Spacing = 80
      TabOrder = 2
      OnClick = cmdNextClick
    end
  end
  object grdMenu: TCaptionStringGrid [1]
    Left = 0
    Top = 24
    Width = 604
    Height = 324
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    BorderStyle = bsNone
    Color = clBtnFace
    ColCount = 3
    DefaultColWidth = 160
    DefaultRowHeight = 15
    DefaultDrawing = False
    DrawingStyle = gdsClassic
    FixedCols = 0
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine]
    ScrollBars = ssVertical
    TabOrder = 0
    OnDrawCell = grdMenuDrawCell
    OnKeyDown = grdMenuKeyDown
    OnKeyUp = grdMenuKeyUp
    OnMouseDown = grdMenuMouseDown
    OnMouseMove = grdMenuMouseMove
    OnMouseUp = grdMenuMouseUp
    Caption = 'Menu or Dialog Name'
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 8
    Top = 40
    Data = (
      (
        'Component = pnlTool'
        'Status = stsDefault')
      (
        'Component = cmdDone'
        'Status = stsDefault')
      (
        'Component = cmdPrev'
        'Status = stsDefault')
      (
        'Component = cmdNext'
        'Status = stsDefault')
      (
        'Component = grdMenu'
        'Status = stsDefault')
      (
        'Component = frmOMNavA'
        'Status = stsDefault'))
  end
  object accEventsGrdMenu: TVA508ComponentAccessibility
    Component = grdMenu
    OnCaptionQuery = accEventsGrdMenuCaptionQuery
    OnValueQuery = accEventsGrdMenuValueQuery
    Left = 40
    Top = 40
  end
end
