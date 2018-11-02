object IGridCmpEd: TIGridCmpEd
  Left = 326
  Top = 248
  ActiveControl = FloatValue
  BorderStyle = bsToolWindow
  Caption = 'InspectorGrid Add, Edit, Delete Items'
  ClientHeight = 390
  ClientWidth = 463
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Default'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 176
    Top = 60
    Width = 39
    Height = 13
    Caption = 'Caption:'
  end
  object Bevel1: TBevel
    Left = 176
    Top = 104
    Width = 281
    Height = 41
  end
  object TypeLbl: TLabel
    Left = 184
    Top = 112
    Width = 91
    Height = 22
    Caption = 'Item Type'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object SetPanel: TPanel
    Left = 176
    Top = 152
    Width = 281
    Height = 233
    TabOrder = 11
    object Label8: TLabel
      Left = 8
      Top = 8
      Width = 64
      Height = 13
      Caption = 'Set Contents:'
    end
    object SetDisplayText: TLabel
      Left = 8
      Top = 21
      Width = 257
      Height = 41
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Default'
      Font.Style = []
      ParentFont = False
      Transparent = True
      WordWrap = True
    end
    object SetListBox: TCheckListBox
      Left = 7
      Top = 84
      Width = 138
      Height = 142
      OnClickCheck = SetListBoxClickCheck
      ItemHeight = 13
      TabOrder = 0
      OnKeyDown = SetListBoxKeyDown
    end
    object SetItem: TEdit
      Left = 7
      Top = 64
      Width = 138
      Height = 21
      TabOrder = 1
      OnKeyPress = SetItemKeyPress
    end
  end
  object ParentPanel: TPanel
    Left = 176
    Top = 152
    Width = 281
    Height = 233
    TabOrder = 5
    object ParentChildCount: TLabel
      Left = 96
      Top = 56
      Width = 6
      Height = 13
      Caption = '0'
    end
    object ParentVisibleChildren: TLabel
      Left = 96
      Top = 72
      Width = 6
      Height = 13
      Caption = '0'
    end
    object ParentHiddenChildren: TLabel
      Left = 96
      Top = 88
      Width = 6
      Height = 13
      Caption = '0'
    end
    object Label3: TLabel
      Left = 32
      Top = 56
      Width = 57
      Height = 13
      Caption = 'Child Count:'
    end
    object Label4: TLabel
      Left = 15
      Top = 72
      Width = 74
      Height = 13
      Caption = 'Visible Children:'
    end
    object Label5: TLabel
      Left = 11
      Top = 88
      Width = 78
      Height = 13
      Caption = 'Hidden Children:'
    end
    object Label6: TLabel
      Left = 16
      Top = 8
      Width = 65
      Height = 13
      Caption = 'Object Name:'
    end
    object ParentDisplayTextEdit: TEdit
      Left = 16
      Top = 24
      Width = 241
      Height = 21
      TabOrder = 0
      OnChange = SetChange
    end
  end
  object ListPanel: TPanel
    Left = 176
    Top = 152
    Width = 281
    Height = 233
    TabOrder = 10
    object Label9: TLabel
      Left = 16
      Top = 8
      Width = 61
      Height = 13
      Caption = 'Display Text:'
    end
    object ListItems: TComboBox
      Left = 15
      Top = 24
      Width = 138
      Height = 198
      Style = csSimple
      ItemHeight = 13
      TabOrder = 0
      OnChange = SetChange
      OnKeyDown = ListItemsKeyDown
    end
  end
  object StringPanel: TPanel
    Left = 176
    Top = 152
    Width = 281
    Height = 233
    TabOrder = 4
    object Label10: TLabel
      Left = 16
      Top = 8
      Width = 61
      Height = 13
      Caption = 'Display Text:'
    end
    object StringDisplayText: TEdit
      Left = 16
      Top = 24
      Width = 241
      Height = 21
      TabOrder = 0
      Text = 'Edit1'
      OnChange = SetChange
    end
  end
  object IntegerPanel: TPanel
    Left = 176
    Top = 152
    Width = 281
    Height = 233
    TabOrder = 6
    object Label11: TLabel
      Left = 16
      Top = 8
      Width = 66
      Height = 13
      Caption = 'Integer Value:'
    end
    object IntegerValue: TOvcSimpleField
      Left = 16
      Top = 24
      Width = 241
      Height = 21
      Cursor = crIBeam
      DataType = sftInteger
      CaretOvr.Shape = csBlock
      ControlCharColor = clRed
      DecimalPlaces = 0
      EFColors.Disabled.BackColor = clWindow
      EFColors.Disabled.TextColor = clGrayText
      EFColors.Error.BackColor = clRed
      EFColors.Error.TextColor = clBlack
      EFColors.Highlight.BackColor = clHighlight
      EFColors.Highlight.TextColor = clHighlightText
      MaxLength = 6
      Options = [efoCaretToEnd]
      PictureMask = 'i'
      TabOrder = 0
      OnChange = SetChange
      RangeHigh = {FF7F0000000000000000}
      RangeLow = {0080FFFF000000000000}
    end
  end
  object ColorPanel: TPanel
    Left = 176
    Top = 152
    Width = 281
    Height = 233
    TabOrder = 8
    object Label15: TLabel
      Left = 16
      Top = 8
      Width = 64
      Height = 13
      Caption = 'Display Color:'
    end
    object ColorCombo: TOvcColorComboBox
      Left = 16
      Top = 24
      Width = 241
      Height = 22
      ItemHeight = 12
      TabOrder = 0
      Text = 'Black'
    end
  end
  object FontPanel: TPanel
    Left = 176
    Top = 152
    Width = 281
    Height = 233
    TabOrder = 9
    object Label17: TLabel
      Left = 16
      Top = 8
      Width = 69
      Height = 13
      Caption = 'Selected Font:'
    end
    object FontCombo: TOvcFontComboBox
      Left = 16
      Top = 24
      Width = 241
      Height = 22
      ItemHeight = 12
      TabOrder = 0
    end
  end
  object LogicalPanel: TPanel
    Left = 176
    Top = 152
    Width = 281
    Height = 233
    TabOrder = 12
    object Label16: TLabel
      Left = 16
      Top = 8
      Width = 72
      Height = 13
      Caption = 'Boolean Value:'
    end
    object LogicalValue: TComboBox
      Left = 16
      Top = 24
      Width = 241
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      OnChange = SetChange
      Items.Strings = (
        'True'
        'False')
    end
  end
  object DatePanel: TPanel
    Left = 176
    Top = 152
    Width = 281
    Height = 233
    TabOrder = 13
    object Label14: TLabel
      Left = 16
      Top = 8
      Width = 63
      Height = 13
      Caption = 'Display Date:'
    end
    object DatePicker: TDateTimePicker
      Left = 16
      Top = 24
      Width = 241
      Height = 21
      Date = 37089.037992210700000000
      Time = 37089.037992210700000000
      TabOrder = 0
      OnChange = SetChange
    end
  end
  object CurrencyPanel: TPanel
    Left = 176
    Top = 152
    Width = 281
    Height = 233
    TabOrder = 14
    object Label13: TLabel
      Left = 16
      Top = 8
      Width = 75
      Height = 13
      Caption = 'Currency Value:'
    end
    object CurrencyEdit: TOvcSimpleField
      Left = 16
      Top = 24
      Width = 241
      Height = 21
      Cursor = crIBeam
      DataType = sftString
      CaretOvr.Shape = csBlock
      ControlCharColor = clRed
      DecimalPlaces = 0
      EFColors.Disabled.BackColor = clWindow
      EFColors.Disabled.TextColor = clGrayText
      EFColors.Error.BackColor = clRed
      EFColors.Error.TextColor = clBlack
      EFColors.Highlight.BackColor = clHighlight
      EFColors.Highlight.TextColor = clHighlightText
      PictureMask = 'X'
      TabOrder = 0
      OnChange = SetChange
    end
  end
  object FloatPanel: TPanel
    Left = 176
    Top = 152
    Width = 281
    Height = 233
    TabOrder = 7
    object Label12: TLabel
      Left = 16
      Top = 8
      Width = 97
      Height = 13
      Caption = 'Floating Point Value:'
    end
    object FloatValue: TOvcSimpleField
      Left = 16
      Top = 24
      Width = 241
      Height = 21
      Cursor = crIBeam
      DataType = sftReal
      CaretOvr.Shape = csBlock
      ControlCharColor = clRed
      DecimalPlaces = 0
      EFColors.Disabled.BackColor = clWindow
      EFColors.Disabled.TextColor = clGrayText
      EFColors.Error.BackColor = clRed
      EFColors.Error.TextColor = clBlack
      EFColors.Highlight.BackColor = clHighlight
      EFColors.Highlight.TextColor = clHighlightText
      MaxLength = 14
      Options = [efoCaretToEnd]
      PictureMask = '#'
      TabOrder = 0
      OnChange = SetChange
      RangeHigh = {C0FF8F1EC4BCD6420000}
      RangeLow = {00FE3FE59C30A2C20000}
    end
  end
  object TreeView1: TTreeView
    Left = 0
    Top = 0
    Width = 161
    Height = 390
    Align = alLeft
    Indent = 19
    PopupMenu = PopupMenu
    TabOrder = 0
    OnChange = TreeView1Change
    OnKeyDown = TreeView1KeyDown
    OnKeyPress = TreeView1KeyPress
  end
  object O32FlexButton1: TO32FlexButton
    Left = 176
    Top = 8
    Width = 171
    Height = 33
    Caption = 'Create New Parent Item'
    TabOrder = 1
    OnClick = O32FlexButton1Click
    ActiveItem = 0
    ItemCollection = <
      item
        About = 'v4.05'
        Caption = 'Create New Parent Item'
        BtnLayout = blGlyphLeft
      end
      item
        About = 'v4.05'
        Caption = 'Create New Set Item'
        BtnLayout = blGlyphLeft
      end
      item
        About = 'v4.05'
        Caption = 'Create New List Item'
        BtnLayout = blGlyphLeft
      end
      item
        About = 'v4.05'
        Caption = 'Create New String Item'
        BtnLayout = blGlyphLeft
      end
      item
        About = 'v4.05'
        Caption = 'Create New Integer Item'
        BtnLayout = blGlyphLeft
      end
      item
        About = 'v4.05'
        Caption = 'Create New Floating Point Item'
        BtnLayout = blGlyphLeft
      end
      item
        About = 'v4.05'
        Caption = 'Create New Currency Item'
        BtnLayout = blGlyphLeft
      end
      item
        About = 'v4.05'
        Caption = 'Create New Date Item'
        BtnLayout = blGlyphLeft
      end
      item
        About = 'v4.05'
        Caption = 'Create New Color Item'
        BtnLayout = blGlyphLeft
      end
      item
        About = 'v4.05'
        Caption = 'Create New Boolean Item'
        BtnLayout = blGlyphLeft
      end
      item
        About = 'v4.05'
        Caption = 'Create New Font Item'
        BtnLayout = blGlyphLeft
      end>
    WheelSelection = True
    MenuColor = clBtnFace
    PopWidth = 170
  end
  object OkButton: TButton
    Left = 352
    Top = 8
    Width = 105
    Height = 33
    Caption = 'OK'
    TabOrder = 2
    OnClick = OkButtonClick
  end
  object CaptionEdit: TEdit
    Left = 176
    Top = 76
    Width = 145
    Height = 21
    TabOrder = 3
    OnChange = SetChange
  end
  object ItemVisible: TCheckBox
    Left = 391
    Top = 115
    Width = 58
    Height = 17
    Caption = 'Visible'
    TabOrder = 15
    OnClick = SetChange
  end
  object ImageBox: TGroupBox
    Left = 328
    Top = 51
    Width = 129
    Height = 46
    Caption = 'Image'
    TabOrder = 16
    object Image1: TImage
      Left = 6
      Top = 20
      Width = 41
      Height = 22
    end
    object ClearImageBtn: TSpeedButton
      Left = 82
      Top = 16
      Width = 41
      Height = 25
      Caption = 'Clear'
      OnClick = ClearImageBtnClick
    end
    object OvcSpinner1: TOvcSpinner
      Left = 56
      Top = 16
      Width = 16
      Height = 25
      AutoRepeat = True
      Delta = 1.000000000000000000
      OnClick = OvcSpinner1Click
    end
  end
  object PopupMenu: TPopupMenu
    Left = 8
    Top = 8
    object Delete1: TMenuItem
      Caption = 'Delete'
      OnClick = Delete1Click
    end
  end
end
