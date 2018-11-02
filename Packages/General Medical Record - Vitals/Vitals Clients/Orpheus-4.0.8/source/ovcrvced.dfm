object RVCmpEd: TRVCmpEd
  Left = 383
  Top = 273
  ActiveControl = cbxName
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'Browse/Edit/Define View definitions'
  ClientHeight = 385
  ClientWidth = 480
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Default'
  Font.Style = []
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object TOvcAttachedLabel
    Left = 2
    Top = 77
    Width = 96
    Height = 13
    AutoSize = False
    Caption = '&Title'
    FocusControl = edtViewTitle
    Transparent = False
    Control = edtViewTitle
  end
  object OvcComboBox1Label1: TOvcAttachedLabel
    Left = 4
    Top = 26
    Width = 109
    Height = 13
    AutoSize = False
    Caption = '&View'
    FocusControl = cbxName
    Transparent = False
    Control = cbxName
  end
  object Bevel1: TBevel
    Left = 0
    Top = 72
    Width = 473
    Height = 9
    Shape = bsTopLine
  end
  object edtViewTitle: TOvcSimpleField
    Left = 2
    Top = 93
    Width = 470
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
    LabelInfo.OffsetX = 0
    LabelInfo.OffsetY = -3
    LabelInfo.Visible = True
    MaxLength = 255
    PictureMask = 'X'
    TabOrder = 7
  end
  object GroupBox1: TGroupBox
    Left = 2
    Top = 119
    Width = 192
    Height = 260
    Caption = ' Available Fields '
    TabOrder = 8
    object Label1: TLabel
      Left = 8
      Top = 20
      Width = 69
      Height = 13
      Caption = 'Sortable Fields'
      Transparent = False
    end
    object Label2: TLabel
      Left = 8
      Top = 138
      Width = 92
      Height = 13
      Caption = 'Non-Sortable Fields'
      Transparent = False
    end
    object SListBox: TOvcListBox
      Left = 8
      Top = 36
      Width = 180
      Height = 100
      DragMode = dmAutomatic
      HorizontalScroll = True
      ItemHeight = 13
      MultiSelect = True
      TabOrder = 0
      OnClick = SListBoxClick
    end
    object NSListBox: TOvcListBox
      Left = 8
      Top = 152
      Width = 180
      Height = 100
      DragMode = dmAutomatic
      HorizontalScroll = True
      ItemHeight = 13
      MultiSelect = True
      TabOrder = 1
      OnClick = NSListBoxClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 284
    Top = 119
    Width = 192
    Height = 260
    Caption = ' View Columns '
    TabOrder = 15
    object Label3: TLabel
      Left = 8
      Top = 20
      Width = 84
      Height = 13
      Caption = 'Grouped Columns'
      Transparent = False
    end
    object Label4: TLabel
      Left = 8
      Top = 138
      Width = 107
      Height = 13
      Caption = 'Non-Grouped Columns'
      Transparent = False
    end
    object GListBox: TOvcListBox
      Left = 8
      Top = 36
      Width = 180
      Height = 100
      HorizontalScroll = True
      ItemHeight = 13
      MultiSelect = True
      TabOrder = 0
      OnClick = GListBoxClick
      OnDragDrop = GListBoxDragDrop
      OnDragOver = GListBoxDragOver
    end
    object NGListBox: TOvcListBox
      Left = 8
      Top = 152
      Width = 180
      Height = 100
      HorizontalScroll = True
      ItemHeight = 13
      MultiSelect = True
      TabOrder = 1
      OnClick = NGListBoxClick
      OnDragDrop = NGListBoxDragDrop
      OnDragOver = NGListBoxDragOver
    end
  end
  object btnAddG: TBitBtn
    Left = 201
    Top = 218
    Width = 75
    Height = 25
    Caption = '&Add'
    Enabled = False
    TabOrder = 11
    OnClick = btnAddGClick
    Glyph.Data = {
      DE000000424DDE0000000000000076000000280000000D0000000D0000000100
      0400000000006800000000000000000000001000000010000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3000333333033333300033333300333330003333330603333000330000066033
      3000330666666603300033066666666030003306666666033000330000066033
      3000333333060333300033333300333330003333330333333000333333333333
      3000}
    Layout = blGlyphRight
  end
  object btnAdd: TBitBtn
    Left = 201
    Top = 276
    Width = 75
    Height = 25
    Caption = 'A&dd'
    Enabled = False
    TabOrder = 13
    OnClick = btnAddClick
    Glyph.Data = {
      DE000000424DDE0000000000000076000000280000000D0000000D0000000100
      0400000000006800000000000000000000001000000010000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3000333333033333300033333300333330003333330603333000330000066033
      3000330666666603300033066666666030003306666666033000330000066033
      3000333333060333300033333300333330003333330333333000333333333333
      3000}
    Layout = blGlyphRight
  end
  object btnRemove: TBitBtn
    Left = 201
    Top = 248
    Width = 75
    Height = 24
    Caption = '&Remove'
    Enabled = False
    TabOrder = 12
    OnClick = btnRemoveClick
    NumGlyphs = 2
  end
  object btnUp: TBitBtn
    Left = 201
    Top = 126
    Width = 75
    Height = 25
    Caption = '&Up'
    Enabled = False
    TabOrder = 9
    OnClick = btnUpClick
    Glyph.Data = {
      DE000000424DDE0000000000000076000000280000000D0000000D0000000100
      0400000000006800000000000000000000001000000010000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3000333333333333300033330000033330003333066603333000333306660333
      3000333306660333300030000666000030003306666666033000333066666033
      3000333306660333300033333060333330003333330333333000333333333333
      3000}
    Layout = blGlyphRight
  end
  object btnDown: TBitBtn
    Left = 201
    Top = 155
    Width = 75
    Height = 25
    Caption = 'D&own'
    Enabled = False
    TabOrder = 10
    OnClick = btnDownClick
    Glyph.Data = {
      DE000000424DDE0000000000000076000000280000000D0000000D0000000100
      0400000000006800000000000000000000001000000010000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3000333333333333300033333303333330003333306033333000333306660333
      3000333066666033300033066666660330003000066600003000333306660333
      3000333306660333300033330666033330003333000003333000333333333333
      3000}
    Layout = blGlyphRight
  end
  object btnProp: TBitBtn
    Left = 201
    Top = 354
    Width = 75
    Height = 25
    Caption = '&Properties...'
    TabOrder = 14
    OnClick = btnPropClick
  end
  object btnOk: TBitBtn
    Left = 397
    Top = 8
    Width = 75
    Height = 25
    Caption = '&OK'
    TabOrder = 3
    OnClick = btnOkClick
  end
  object btnCancel: TBitBtn
    Left = 397
    Top = 40
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 6
  end
  object cbxName: TComboBox
    Left = 4
    Top = 43
    Width = 229
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnClick = cbxNameClick
  end
  object btnNew: TButton
    Left = 237
    Top = 8
    Width = 75
    Height = 25
    Caption = '&New'
    TabOrder = 1
    OnClick = btnNewClick
  end
  object btnClone: TButton
    Left = 317
    Top = 8
    Width = 75
    Height = 25
    Caption = '&Clone'
    TabOrder = 2
    OnClick = btnCloneClick
  end
  object btnEdit: TButton
    Left = 237
    Top = 40
    Width = 75
    Height = 25
    Caption = '&Edit'
    TabOrder = 4
    OnClick = btnEditClick
  end
  object btnDelete: TButton
    Left = 320
    Top = 40
    Width = 72
    Height = 25
    Caption = 'De&lete'
    TabOrder = 5
    OnClick = btnDeleteClick
  end
end
