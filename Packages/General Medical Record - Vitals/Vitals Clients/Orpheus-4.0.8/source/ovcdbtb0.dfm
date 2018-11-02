object OvcfrmDbColEditor: TOvcfrmDbColEditor
  Left = 288
  Top = 189
  ActiveControl = ctlColNumber
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Columns Editor'
  ClientHeight = 212
  ClientWidth = 459
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Default'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 459
    Height = 41
    Align = alTop
    Alignment = taLeftJustify
    BevelInner = bvLowered
    TabOrder = 0
    object btnPrev: TSpeedButton
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
        BBBBBBBBBBBBFFFFBBBBBBBBBBB00CC0BBBBBBBBBBBFFFFFBBBBBBBBBB00CCC0
        BBBBBBBBBBFFFFFFBBBBBBBBB00CCCC0BBBBBBBBBFFFFFFFBBBBBBBB00CCCCC0
        BBBBBBBBFFFFFFFFBBBBBBBF0CCCCCC0BBBBBBBFFFFFFFFFBBBBBBBF0CCCCCC0
        BBBBBBBFFFFFFFFFBBBBBBBBFCCCCCC0BBBBBBBBFFFFFFFFBBBBBBBBBFCCCCC0
        BBBBBBBBBFFFFFFFBBBBBBBBBBFCCCC0BBBBBBBBBBFFFFFFBBBBBBBBBBBFCCC0
        BBBBBBBBBBBFFFFFBBBBBBBBBBBBFFFFBBBBBBBBBBBBFFFFBBBBBBBBBBBBBBBB
        BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = btnPrevClick
    end
    object btnNext: TSpeedButton
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
      OnClick = btnNextClick
    end
    object btnFirst: TSpeedButton
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
      OnClick = btnFirstClick
    end
    object btnLast: TSpeedButton
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
        00BBBBBBFFBBBBBBFFBBBBBB000BBBBB00BBBBBBFFFBBBBBFFBBBBBB0C00BBBB
        00BBBBBBFFFFBBBBFFBBBBBB0CC00BBB00BBBBBBFFFFFBBBFFBBBBBB0CCC00BB
        00BBBBBBFFFFFFBBFFBBBBBB0CCCC00B00BBBBBBFFFFFFFBFFBBBBBB0CCCCCFB
        00BBBBBBFFFFFFFBFFBBBBBB0CCCCFBB00BBBBBBFFFFFFBBFFBBBBBB0CCCFBBB
        00BBBBBBFFFFFBBBFFBBBBBB0CCFBBBB00BBBBBBFFFFBBBBFFBBBBBB0CFBBBBB
        00BBBBBBFFFBBBBBFFBBBBBBFFBBBBBB00BBBBBBFFBBBBBBFFBBBBBBBBBBBBBB
        BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = btnLastClick
    end
    object Label1: TLabel
      Left = 272
      Top = 12
      Width = 105
      Height = 16
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Column &number'
      FocusControl = ctlColNumber
    end
    object ctlColNumber: TOvcSimpleField
      Left = 384
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
      PictureMask = '9'
      TabOrder = 0
      OnChange = ctlColNumberChange
      OnExit = ctlColNumberExit
      RangeHigh = {FF7F0000000000000000}
      RangeLow = {00000000000000000000}
    end
    object OvcSpinner2: TOvcSpinner
      Left = 433
      Top = 11
      Width = 16
      Height = 21
      Acceleration = 5
      AutoRepeat = True
      Delta = 1.000000000000000000
      DelayTime = 500
      FocusedControl = ctlColNumber
      ShowArrows = True
      Style = stNormalVertical
      WrapMode = True
    end
    object btnProperties: TBitBtn
      Left = 181
      Top = 8
      Width = 96
      Height = 25
      Hint = 
        'Set picture mask and decimal places property for entry field cel' +
        'ls'
      Caption = 'Cell Properties'
      Enabled = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = btnPropertiesClick
    end
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 48
    Width = 361
    Height = 161
    Caption = 'Column details'
    TabOrder = 1
    object Label2: TLabel
      Left = 8
      Top = 16
      Width = 57
      Height = 16
      AutoSize = False
      Caption = '&Cell'
      FocusControl = ctlCell
    end
    object Label3: TLabel
      Left = 8
      Top = 96
      Width = 57
      Height = 16
      AutoSize = False
      Caption = '&Width'
      FocusControl = ctlWidth
    end
    object TLabel
      Left = 232
      Top = 64
      Width = 45
      Height = 13
      Caption = 'Field type'
    end
    object TLabel
      Left = 104
      Top = 64
      Width = 51
      Height = 13
      Caption = 'Field name'
    end
    object TLabel
      Left = 104
      Top = 112
      Width = 46
      Height = 13
      Caption = 'Data type'
    end
    object TLabel
      Left = 232
      Top = 112
      Width = 44
      Height = 13
      Caption = 'Data size'
    end
    object ctlCell: TComboBox
      Left = 8
      Top = 32
      Width = 345
      Height = 21
      Style = csDropDownList
      DropDownCount = 16
      ItemHeight = 13
      TabOrder = 0
    end
    object ctlHidden: TCheckBox
      Left = 8
      Top = 72
      Width = 65
      Height = 17
      Caption = '&Hidden'
      TabOrder = 1
    end
    object ctlWidth: TOvcSimpleField
      Left = 8
      Top = 113
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
      PictureMask = '9'
      TabOrder = 2
      RangeHigh = {FF7F0000000000000000}
      RangeLow = {05000000000000000000}
    end
    object OvcSpinner1: TOvcSpinner
      Left = 57
      Top = 113
      Width = 16
      Height = 21
      Acceleration = 5
      AutoRepeat = True
      Delta = 1.000000000000000000
      DelayTime = 500
      FocusedControl = ctlWidth
      ShowArrows = True
      Style = stNormalVertical
      WrapMode = True
    end
    object edFieldType: TEdit
      Left = 232
      Top = 80
      Width = 121
      Height = 21
      ParentColor = True
      ReadOnly = True
      TabOrder = 5
    end
    object edDataType: TEdit
      Left = 104
      Top = 128
      Width = 121
      Height = 21
      ParentColor = True
      ReadOnly = True
      TabOrder = 6
    end
    object edFieldName: TEdit
      Left = 104
      Top = 80
      Width = 121
      Height = 21
      ParentColor = True
      ReadOnly = True
      TabOrder = 4
    end
    object edDataSize: TEdit
      Left = 232
      Top = 128
      Width = 121
      Height = 21
      ParentColor = True
      ReadOnly = True
      TabOrder = 7
    end
  end
  object btnApply: TButton
    Left = 376
    Top = 88
    Width = 75
    Height = 25
    Caption = 'Apply'
    Default = True
    TabOrder = 2
    OnClick = btnApplyClick
  end
  object btnClose: TButton
    Left = 376
    Top = 184
    Width = 75
    Height = 25
    Caption = 'Close'
    ModalResult = 1
    TabOrder = 3
    OnClick = btnCloseClick
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
    Left = 424
    Top = 48
  end
end
