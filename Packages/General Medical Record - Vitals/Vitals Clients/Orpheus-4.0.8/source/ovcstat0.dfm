object OvcfrmPropsDlg: TOvcfrmPropsDlg
  Left = 323
  Top = 207
  ActiveControl = ComponentsList
  BorderStyle = bsSingle
  Caption = 'Property Storage'
  ClientHeight = 312
  ClientWidth = 434
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -12
  Font.Name = 'Default'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object UpBtn: TOvcSpeedButton
    Left = 404
    Top = 169
    Width = 25
    Height = 25
    AutoRepeat = True
    Flat = False
    Glyph.Data = {
      DE000000424DDE0000000000000076000000280000000D0000000D0000000100
      0400000000006800000000000000000000001000000010000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3000333333333333300033330000033330003333066603333000333306660333
      3000333306660333300030000666000030003306666666033000333066666033
      3000333306660333300033333060333330003333330333333000333333333333
      3000}
    GrayedInactive = True
    Layout = blGlyphTop
    Margin = -1
    NumGlyphs = 1
    RepeatDelay = 500
    RepeatInterval = 100
    Spacing = 1
    Style = bsAutoDetect
    Transparent = False
    WordWrap = False
    ParentShowHint = False
    ShowHint = True
    OnClick = UpBtnClick
  end
  object DownBtn: TOvcSpeedButton
    Left = 403
    Top = 245
    Width = 25
    Height = 25
    AutoRepeat = True
    Flat = False
    Glyph.Data = {
      DE000000424DDE0000000000000076000000280000000D0000000D0000000100
      0400000000006800000000000000000000001000000010000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3000333333333333300033333303333330003333306033333000333306660333
      3000333066666033300033066666660330003000066600003000333306660333
      3000333306660333300033330666033330003333000003333000333333333333
      3000}
    GrayedInactive = True
    Layout = blGlyphTop
    Margin = -1
    NumGlyphs = 1
    RepeatDelay = 500
    RepeatInterval = 100
    Spacing = 1
    Style = bsAutoDetect
    Transparent = False
    WordWrap = False
    ParentShowHint = False
    ShowHint = True
    OnClick = DownBtnClick
  end
  object lblClassName: TLabel
    Left = 75
    Top = 115
    Width = 57
    Height = 13
    Caption = 'Class name:'
  end
  object TLabel
    Left = 4
    Top = 115
    Width = 60
    Height = 13
    Caption = 'Class name: '
  end
  object lblPropType: TLabel
    Left = 297
    Top = 115
    Width = 59
    Height = 13
    Caption = 'Propery type'
  end
  object TLabel
    Left = 220
    Top = 115
    Width = 65
    Height = 13
    Caption = 'Property type:'
  end
  object ComponentsListLabel1: TOvcAttachedLabel
    Left = 4
    Top = 3
    Width = 197
    Height = 13
    AutoSize = False
    Caption = '&Components'
    FocusControl = ComponentsList
    Control = ComponentsList
  end
  object PropertiesListLabel1: TOvcAttachedLabel
    Left = 191
    Top = 3
    Width = 207
    Height = 13
    AutoSize = False
    Caption = '&Properties'
    FocusControl = PropertiesList
    Control = PropertiesList
  end
  object StoredListLabel1: TOvcAttachedLabel
    Left = 4
    Top = 155
    Width = 125
    Height = 13
    AutoSize = False
    Caption = '&Stored properties'
    FocusControl = StoredList
    Control = StoredList
  end
  object AddButton: TButton
    Left = 264
    Top = 134
    Width = 129
    Height = 25
    Caption = '&Add'
    ParentShowHint = False
    ShowHint = False
    TabOrder = 2
    OnClick = AddButtonClick
  end
  object DeleteButton: TButton
    Left = 89
    Top = 283
    Width = 77
    Height = 25
    Caption = '&Delete'
    ParentShowHint = False
    ShowHint = False
    TabOrder = 5
    OnClick = DeleteButtonClick
  end
  object StoredList: TOvcListBox
    Left = 4
    Top = 168
    Width = 389
    Height = 107
    DragMode = dmAutomatic
    HorizontalScroll = True
    ItemHeight = 13
    LabelInfo.OffsetX = 0
    LabelInfo.OffsetY = 0
    LabelInfo.Visible = True
    TabOrder = 3
    OnClick = StoredListClick
    OnDragDrop = StoredListDragDrop
    OnDragOver = StoredListDragOver
    OnKeyPress = StoredListKeyPress
  end
  object PropertiesList: TOvcListBox
    Left = 191
    Top = 16
    Width = 239
    Height = 93
    HorizontalScroll = True
    ItemHeight = 13
    LabelInfo.OffsetX = 0
    LabelInfo.OffsetY = 0
    LabelInfo.Visible = True
    MultiSelect = True
    Sorted = True
    TabOrder = 1
    OnClick = ListClick
    OnDblClick = PropertiesListDblClick
  end
  object ComponentsList: TOvcListBox
    Left = 4
    Top = 16
    Width = 181
    Height = 93
    HorizontalScroll = True
    ItemHeight = 13
    LabelInfo.OffsetX = 0
    LabelInfo.OffsetY = 0
    LabelInfo.Visible = True
    Sorted = True
    TabOrder = 0
    OnClick = ListClick
  end
  object ClearButton: TButton
    Left = 5
    Top = 283
    Width = 77
    Height = 25
    Caption = 'Cl&ear'
    TabOrder = 4
    OnClick = ClearButtonClick
  end
  object OkBtn: TButton
    Left = 272
    Top = 283
    Width = 77
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 6
  end
  object CancelBtn: TButton
    Left = 354
    Top = 283
    Width = 77
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 7
  end
end
