object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 191
  ClientWidth = 249
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object OvcEditor: TOvcEditor
    Left = 8
    Top = 6
    Width = 227
    Height = 78
    CaretOvr.Shape = csBlock
    FixedFont.Color = clWindowText
    FixedFont.Name = 'Courier New'
    FixedFont.Size = 10
    FixedFont.Style = []
    HideSelection = False
    HighlightColors.BackColor = clHighlight
    HighlightColors.TextColor = clHighlightText
    LeftMargin = 15
    MarginOptions.Right.LinePosition = 5
    MarginOptions.Left.LinePosition = 15
    RightMargin = 5
    TabOrder = 0
  end
  object OvcTextFileEditor: TOvcTextFileEditor
    Left = 8
    Top = 90
    Width = 227
    Height = 93
    AutoIndent = False
    CaretOvr.Shape = csBlock
    FixedFont.Color = clWindowText
    FixedFont.Name = 'Courier New'
    FixedFont.Size = 10
    FixedFont.Style = []
    HighlightColors.BackColor = clHighlight
    HighlightColors.TextColor = clHighlightText
    LeftMargin = 15
    MarginOptions.Right.LinePosition = 5
    MarginOptions.Left.LinePosition = 15
    RightMargin = 5
    TabOrder = 1
  end
end
