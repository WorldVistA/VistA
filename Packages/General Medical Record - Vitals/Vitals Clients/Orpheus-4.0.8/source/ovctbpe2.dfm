object OvcfrmColEditor: TOvcfrmColEditor
  Left = 353
  Top = 207
  ActiveControl = ctlColNumber
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Columns Editor'
  ClientHeight = 190
  ClientWidth = 386
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Default'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 386
    Height = 41
    Align = alTop
    Alignment = taLeftJustify
    BevelInner = bvLowered
    TabOrder = 0
    object SpeedButton1: TSpeedButton
      Left = 8
      Top = 8
      Width = 25
      Height = 25
      Hint = 'Previous column'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00BBBBBBBBBBBB
        BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB0000
        BBBBBBBBBBBB777BBBBBBBBBBBB00CC0BBBBBBBBBBB7777BBBBBBBBBBB00CCC0
        BBBBBBBBBB77777BBBBBBBBBB00CCCC0BBBBBBBBB777777BBBBBBBBB00CCCCC0
        BBBBBBBB7777777BBBBBBBBF0CCCCCC0BBBBBBB77777777BBBBBBBBF0CCCCCC0
        BBBBBBB77777777BBBBBBBBBFCCCCCC0BBBBBBBB7777777BBBBBBBBBBFCCCCC0
        BBBBBBBBB777777BBBBBBBBBBBFCCCC0BBBBBBBBBB77777BBBBBBBBBBBBFCCC0
        BBBBBBBBBBB7777BBBBBBBBBBBBBFFFFBBBBBBBBBBBB777BBBBBBBBBBBBBBBBB
        BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 32
      Top = 8
      Width = 25
      Height = 25
      Hint = 'Next column'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00BBBBBBBBBBBB
        BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBF000BBBBB
        BBBBBBBFFFFBBBBBBBBBBBBF0000BBBBBBBBBBBFFFFFBBBBBBBBBBBFCCC00BBB
        BBBBBBBFFFFFFBBBBBBBBBBFCCCC00BBBBBBBBBFFFFFFFBBBBBBBBBFCCCCC00B
        BBBBBBBFFFFFFFFBBBBBBBBFCCCCCC00BBBBBBBFFFFFFFFFBBBBBBBFCCCCCC0F
        BBBBBBBFFFFFFFFFBBBBBBBFCCCCCCFBBBBBBBBFFFFFFFFBBBBBBBBFCCCCCFBB
        BBBBBBBFFFFFFFBBBBBBBBBFCCCCFBBBBBBBBBBFFFFFFBBBBBBBBBBFCCCFBBBB
        BBBBBBBFFFFFBBBBBBBBBBBFFFFBBBBBBBBBBBBFFFFBBBBBBBBBBBBBBBBBBBBB
        BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton2Click
    end
    object SpeedButton3: TSpeedButton
      Left = 72
      Top = 8
      Width = 25
      Height = 25
      Hint = 'First column'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00BBBBBBBBBBBB
        BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB00BBBBBB00
        BBBBBBFFBBBBBBFFBBBBBB00BBBBB000BBBBBBFFBBBBBFFFBBBBBB00BBBB00C0
        BBBBBBFFBBBBFFFFBBBBBB00BBB00CC0BBBBBBFFBBBFFFFFBBBBBB00BB00CCC0
        BBBBBBFFBBFFFFFFBBBBBB00B00CCCC0BBBBBBFFBFFFFFFFBBBBBB00BFCCCCC0
        BBBBBBFFBFFFFFFFBBBBBB00BBFCCCC0BBBBBBFFBBFFFFFFBBBBBB00BBBFCCC0
        BBBBBBFFBBBFFFFFBBBBBB00BBBBFCC0BBBBBBFFBBBBFFFFBBBBBB00BBBBBFC0
        BBBBBBFFBBBBBFFFBBBBBB00BBBBBBFFBBBBBBFFBBBBBBFFBBBBBBBBBBBBBBBB
        BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton3Click
    end
    object SpeedButton4: TSpeedButton
      Left = 96
      Top = 8
      Width = 25
      Height = 25
      Hint = 'Last column'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00BBBBBBBBBBBB
        BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB00BBBBBB
        00BBBBBB77BBBBBB77BBBBBB000BBBBB00BBBBBB777BBBBB77BBBBBB0C00BBBB
        00BBBBBB7777BBBB77BBBBBB0CC00BBB00BBBBBB77777BBB77BBBBBB0CCC00BB
        00BBBBBB777777BB77BBBBBB0CCCC00B00BBBBBB7777777B77BBBBBB0CCCCCFB
        00BBBBBB7777777B77BBBBBB0CCCCFBB00BBBBBB777777BB77BBBBBB0CCCFBBB
        00BBBBBB77777BBB77BBBBBB0CCFBBBB00BBBBBB7777BBBB77BBBBBB0CFBBBBB
        00BBBBBB777BBBBB77BBBBBBFFBBBBBB00BBBBBB77BBBBBB77BBBBBBBBBBBBBB
        BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton4Click
    end
    object SpeedButton5: TSpeedButton
      Left = 136
      Top = 8
      Width = 25
      Height = 25
      Hint = 'Insert column'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00BBBBBBBBBBBB
        BBBBBBBBBBBBBBBBBBBBBBBBBBF000BBBBBBBBBBBBF777BBBBBBBBBBBBFCC0BB
        BBBBBBBBBBFBB7BBBBBBBBBBBBFCC0BBBBBBBBBBBBFBB7BBBBBBBBBBBBFCC0BB
        BBBBBBBBBBFBB7BBBBBBBBBBBBFCC0BBBBBBBBBBBBFBB7BBBBBBB000000CC000
        000BB777777BB777777BBFCCCCCCCCCCCC0BBFBBBBBBBBBBBB7BBFCCCCCCCCCC
        CC0BBFBBBBBBBBBBBB7BBFFFFFFCC0FFFFFBBFFFFFFBB7FFFFFBBBBBBBFCC0BB
        BBBBBBBBBBFBB7BBBBBBBBBBBBFCC0BBBBBBBBBBBBFBB7BBBBBBBBBBBBFCC0BB
        BBBBBBBBBBFBB7BBBBBBBBBBBBFCC0BBBBBBBBBBBBFBB7BBBBBBBBBBBBFFF0BB
        BBBBBBBBBBFFF7BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton5Click
    end
    object SpeedButton6: TSpeedButton
      Left = 160
      Top = 8
      Width = 25
      Height = 25
      Hint = 'Delete column'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00BBBBBBBBBBBB
        BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
        BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
        BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB00000000000
        000BB77777777777777BBFCCCCCCCCCCCC0BBFBBBBBBBBBBBB7BBFCCCCCCCCCC
        CC0BBFBBBBBBBBBBBB7BBFFFFFFFFFFFFFFBBFFFFFFFFFFFFFFBBBBBBBBBBBBB
        BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
        BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
        BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton6Click
    end
    object Label1: TLabel
      Left = 200
      Top = 12
      Width = 105
      Height = 16
      AutoSize = False
      Caption = 'Column &number'
      FocusControl = ctlColNumber
    end
    object ctlColNumber: TOvcSimpleField
      Left = 312
      Top = 11
      Width = 49
      Height = 21
      Cursor = crIBeam
      DataType = sftInteger
      CaretOvr.Shape = csBlock
      ControlCharColor = clRed
      Controller = DefaultController
      DecimalPlaces = 0
      EFColors.Disabled.BackColor = clWindow
      EFColors.Disabled.TextColor = clGrayText
      EFColors.Error.BackColor = clRed
      EFColors.Error.TextColor = clBlack
      EFColors.Highlight.BackColor = clHighlight
      EFColors.Highlight.TextColor = clHighlightText
      MaxLength = 5
      Options = [efoCaretToEnd]
      PictureMask = '9'
      TabOrder = 0
      OnChange = ctlColNumberChange
      OnExit = ctlColNumberExit
      RangeHigh = {FF7F0000000000000000}
      RangeLow = {00000000000000000000}
    end
    object OvcSpinner2: TOvcSpinner
      Left = 361
      Top = 11
      Width = 16
      Height = 21
      AutoRepeat = True
      Delta = 1.000000000000000000
      FocusedControl = ctlColNumber
    end
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 48
    Width = 273
    Height = 137
    Caption = 'Column details'
    TabOrder = 1
    object Label2: TLabel
      Left = 8
      Top = 20
      Width = 75
      Height = 16
      AutoSize = False
      Caption = 'De&fault Cell'
      FocusControl = ctlDefaultCell
    end
    object Label3: TLabel
      Left = 8
      Top = 108
      Width = 75
      Height = 16
      AutoSize = False
      Caption = '&Width'
      FocusControl = ctlWidth
    end
    object Label4: TLabel
      Left = 8
      Top = 72
      Width = 33
      Height = 13
      Caption = '&Hidden'
      FocusControl = ctlHidden
    end
    object Label5: TLabel
      Left = 152
      Top = 72
      Width = 76
      Height = 13
      Caption = '&Show Right Line'
      FocusControl = ctlShowRightLine
    end
    object ctlDefaultCell: TComboBox
      Left = 8
      Top = 40
      Width = 257
      Height = 21
      Style = csDropDownList
      DropDownCount = 16
      ItemHeight = 13
      TabOrder = 0
    end
    object ctlHidden: TCheckBox
      Left = 96
      Top = 72
      Width = 17
      Height = 17
      TabOrder = 1
    end
    object ctlShowRightLine: TCheckBox
      Left = 240
      Top = 72
      Width = 17
      Height = 17
      TabOrder = 3
    end
    object ctlWidth: TOvcSimpleField
      Left = 96
      Top = 106
      Width = 49
      Height = 21
      Cursor = crIBeam
      DataType = sftInteger
      CaretOvr.Shape = csBlock
      ControlCharColor = clRed
      Controller = DefaultController
      DecimalPlaces = 0
      EFColors.Disabled.BackColor = clWindow
      EFColors.Disabled.TextColor = clGrayText
      EFColors.Error.BackColor = clRed
      EFColors.Error.TextColor = clBlack
      EFColors.Highlight.BackColor = clHighlight
      EFColors.Highlight.TextColor = clHighlightText
      MaxLength = 5
      Options = [efoCaretToEnd]
      PictureMask = '9'
      TabOrder = 2
      RangeHigh = {FF7F0000000000000000}
      RangeLow = {05000000000000000000}
    end
    object OvcSpinner1: TOvcSpinner
      Left = 145
      Top = 106
      Width = 16
      Height = 21
      AutoRepeat = True
      Delta = 1.000000000000000000
      FocusedControl = ctlWidth
    end
  end
  object DoneButton: TBitBtn
    Left = 304
    Top = 160
    Width = 75
    Height = 25
    Caption = '&Done'
    ModalResult = 1
    TabOrder = 3
    OnClick = DoneButtonClick
    NumGlyphs = 2
  end
  object ApplyButton: TBitBtn
    Left = 304
    Top = 56
    Width = 75
    Height = 25
    Caption = '&Apply'
    Default = True
    TabOrder = 2
    OnClick = ApplyButtonClick
    NumGlyphs = 2
  end
  object DefaultController: TOvcController
    EntryCommands.TableList = (
      'Default'
      True
      ()
      'WordStar'
      False
      ()
      'Grid'
      False
      ())
    Epoch = 1900
    Left = 336
    Top = 104
  end
end
