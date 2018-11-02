object RVCmpEd2: TRVCmpEd2
  Left = 427
  Top = 247
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'View Properties'
  ClientHeight = 400
  ClientWidth = 375
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Default'
  Font.Style = []
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 4
    Top = 8
    Width = 285
    Height = 172
    Caption = ' Global view properties '
    TabOrder = 0
    object TOvcAttachedLabel
      Left = 156
      Top = 57
      Width = 50
      Height = 13
      Caption = 'Filter &index'
      FocusControl = edtFilterIndex
      Transparent = False
    end
    object TOvcAttachedLabel
      Left = 156
      Top = 94
      Width = 19
      Height = 13
      Caption = 'Tag'
      Transparent = False
    end
    object Label4: TLabel
      Left = 157
      Top = 19
      Width = 75
      Height = 13
      Caption = 'Filter expression'
      Transparent = False
    end
    object Label6: TLabel
      Left = 8
      Top = 130
      Width = 91
      Height = 13
      Caption = 'Default sort column'
      Transparent = False
    end
    object chkShowHeader: TCheckBox
      Left = 12
      Top = 20
      Width = 97
      Height = 17
      Caption = 'Show &header'
      TabOrder = 0
    end
    object chkShowFooter: TCheckBox
      Left = 12
      Top = 41
      Width = 97
      Height = 17
      Caption = 'Show &footer'
      TabOrder = 1
    end
    object chkShowGroupTotals: TCheckBox
      Left = 12
      Top = 62
      Width = 125
      Height = 17
      Caption = 'Show &group totals'
      TabOrder = 2
    end
    object edtFilterIndex: TOvcNumericField
      Left = 156
      Top = 72
      Width = 61
      Height = 21
      Cursor = crIBeam
      DataType = nftInteger
      CaretOvr.Shape = csBlock
      EFColors.Disabled.BackColor = clWindow
      EFColors.Disabled.TextColor = clGrayText
      EFColors.Error.BackColor = clRed
      EFColors.Error.TextColor = clBlack
      EFColors.Highlight.BackColor = clHighlight
      EFColors.Highlight.TextColor = clHighlightText
      LabelInfo.OffsetX = 0
      LabelInfo.OffsetY = -2
      LabelInfo.Visible = True
      PictureMask = 'iiiiii'
      TabOrder = 6
      RangeHigh = {FF7F0000000000000000}
      RangeLow = {FFFFFFFF000000000000}
    end
    object edtTag: TOvcNumericField
      Left = 156
      Top = 108
      Width = 61
      Height = 21
      Cursor = crIBeam
      DataType = nftInteger
      CaretOvr.Shape = csBlock
      EFColors.Disabled.BackColor = clWindow
      EFColors.Disabled.TextColor = clGrayText
      EFColors.Error.BackColor = clRed
      EFColors.Error.TextColor = clBlack
      EFColors.Highlight.BackColor = clHighlight
      EFColors.Highlight.TextColor = clHighlightText
      LabelInfo.OffsetX = 0
      LabelInfo.OffsetY = -1
      LabelInfo.Visible = True
      PictureMask = 'iiiiii'
      TabOrder = 7
      RangeHigh = {FF7F0000000000000000}
      RangeLow = {0080FFFF000000000000}
    end
    object chkShowGroupCounts: TCheckBox
      Left = 12
      Top = 85
      Width = 125
      Height = 17
      Caption = 'Show group &counts'
      TabOrder = 3
    end
    object chkDescending: TCheckBox
      Left = 120
      Top = 146
      Width = 97
      Height = 17
      Caption = 'D&escending'
      TabOrder = 8
    end
    object chkHidden: TCheckBox
      Left = 12
      Top = 106
      Width = 97
      Height = 17
      Caption = 'Hidden'
      TabOrder = 4
    end
    object edtFilterExp: TEdit
      Left = 156
      Top = 33
      Width = 121
      Height = 21
      TabOrder = 5
    end
    object cbxDefaultSort: TComboBox
      Left = 8
      Top = 144
      Width = 97
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 9
    end
  end
  object GroupBox2: TGroupBox
    Left = 4
    Top = 184
    Width = 365
    Height = 209
    Caption = ' Column properties '
    TabOrder = 1
    object Label1: TLabel
      Left = 13
      Top = 20
      Width = 40
      Height = 13
      Caption = 'Co&lumns'
      FocusControl = ListBox1
      Transparent = False
    end
    object TOvcAttachedLabel
      Left = 292
      Top = 61
      Width = 28
      Height = 13
      Caption = '&Width'
      FocusControl = edtWidth
      Transparent = False
    end
    object TOvcAttachedLabel
      Left = 292
      Top = 101
      Width = 49
      Height = 13
      Caption = '&Print width'
      FocusControl = edtPrintWidth
      Transparent = False
    end
    object Label2: TLabel
      Left = 293
      Top = 138
      Width = 57
      Height = 13
      Caption = '(in 1/1440")'
      Transparent = False
    end
    object TOvcAttachedLabel
      Left = 292
      Top = 17
      Width = 19
      Height = 13
      Caption = 'T&ag'
      FocusControl = edtColTag
      Transparent = False
    end
    object Label3: TLabel
      Left = 165
      Top = 125
      Width = 62
      Height = 13
      Caption = 'Sort direction'
      Transparent = False
    end
    object Label5: TLabel
      Left = 166
      Top = 162
      Width = 102
      Height = 13
      Caption = 'Aggregate expression'
      Transparent = False
    end
    object ListBox1: TListBox
      Left = 12
      Top = 36
      Width = 133
      Height = 157
      ItemHeight = 13
      MultiSelect = True
      TabOrder = 0
      OnClick = ListBox1Click
    end
    object chkTotals: TCheckBox
      Left = 164
      Top = 34
      Width = 97
      Height = 17
      Caption = 'Compute &totals'
      TabOrder = 2
      OnClick = chkTotalsClick
    end
    object ChkOwnerDraw: TCheckBox
      Left = 164
      Top = 52
      Width = 97
      Height = 17
      Caption = '&Owner draw'
      TabOrder = 3
      OnClick = ChkOwnerDrawClick
    end
    object edtWidth: TOvcNumericField
      Left = 292
      Top = 76
      Width = 41
      Height = 21
      Cursor = crIBeam
      DataType = nftInteger
      CaretOvr.Shape = csBlock
      EFColors.Disabled.BackColor = clWindow
      EFColors.Disabled.TextColor = clGrayText
      EFColors.Error.BackColor = clRed
      EFColors.Error.TextColor = clBlack
      EFColors.Highlight.BackColor = clHighlight
      EFColors.Highlight.TextColor = clHighlightText
      LabelInfo.OffsetX = 0
      LabelInfo.OffsetY = -2
      LabelInfo.Visible = True
      PictureMask = 'iiiiii'
      TabOrder = 10
      Uninitialized = True
      OnChange = edtWidthChange
      RangeHigh = {FF7F0000000000000000}
      RangeLow = {00000000000000000000}
    end
    object edtPrintWidth: TOvcNumericField
      Left = 292
      Top = 116
      Width = 41
      Height = 21
      Cursor = crIBeam
      DataType = nftInteger
      CaretOvr.Shape = csBlock
      EFColors.Disabled.BackColor = clWindow
      EFColors.Disabled.TextColor = clGrayText
      EFColors.Error.BackColor = clRed
      EFColors.Error.TextColor = clBlack
      EFColors.Highlight.BackColor = clHighlight
      EFColors.Highlight.TextColor = clHighlightText
      LabelInfo.OffsetX = 0
      LabelInfo.OffsetY = -2
      LabelInfo.Visible = True
      PictureMask = 'iiiiii'
      TabOrder = 11
      Uninitialized = True
      OnChange = edtPrintWidthChange
      RangeHigh = {FF7F0000000000000000}
      RangeLow = {00000000000000000000}
    end
    object chkGroupBy: TCheckBox
      Left = 164
      Top = 14
      Width = 97
      Height = 17
      Caption = 'Group by'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -11
      Font.Name = 'Default'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object edtColTag: TOvcNumericField
      Left = 292
      Top = 32
      Width = 41
      Height = 21
      Cursor = crIBeam
      DataType = nftInteger
      CaretOvr.Shape = csBlock
      EFColors.Disabled.BackColor = clWindow
      EFColors.Disabled.TextColor = clGrayText
      EFColors.Error.BackColor = clRed
      EFColors.Error.TextColor = clBlack
      EFColors.Highlight.BackColor = clHighlight
      EFColors.Highlight.TextColor = clHighlightText
      LabelInfo.OffsetX = 0
      LabelInfo.OffsetY = -2
      LabelInfo.Visible = True
      PictureMask = 'iiiiii'
      TabOrder = 9
      Uninitialized = True
      OnChange = edtColTagChange
      RangeHigh = {FF7F0000000000000000}
      RangeLow = {00000000000000000000}
    end
    object chkShowHint: TCheckBox
      Left = 164
      Top = 70
      Width = 97
      Height = 17
      Caption = 'Show h&int'
      TabOrder = 4
      OnClick = chkShowHintClick
    end
    object chkAllowResize: TCheckBox
      Left = 164
      Top = 89
      Width = 97
      Height = 17
      Caption = 'Allow resize'
      TabOrder = 5
      OnClick = chkAllowResizeClick
    end
    object chkVisible: TCheckBox
      Left = 164
      Top = 108
      Width = 97
      Height = 17
      Caption = 'Visible'
      TabOrder = 6
      OnClick = chkVisibleClick
    end
    object cbxSortDir: TComboBox
      Left = 164
      Top = 138
      Width = 97
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 7
      OnChange = cbxSortDirChange
      Items.Strings = (
        'First ascending'
        'First descending'
        'Always ascending'
        'Always descending')
    end
    object edtAgg: TEdit
      Left = 164
      Top = 176
      Width = 185
      Height = 21
      TabOrder = 8
      OnExit = edtAggExit
    end
  end
  object btnOk: TBitBtn
    Left = 297
    Top = 15
    Width = 75
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 2
  end
  object btnCancel: TBitBtn
    Left = 297
    Top = 43
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
