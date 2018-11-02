object O32frmLkOutEd: TO32frmLkOutEd
  Left = 490
  Top = 289
  Width = 426
  Height = 323
  Caption = 'LookOut Bar Layout Tool'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Default'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object pnlItems: TPanel
    Left = 217
    Top = 0
    Width = 201
    Height = 189
    Align = alClient
    TabOrder = 1
    object lbItems: TListBox
      Left = 1
      Top = 22
      Width = 167
      Height = 166
      Style = lbOwnerDrawVariable
      Align = alClient
      ItemHeight = 13
      TabOrder = 0
      OnClick = lbItemsClick
      OnDrawItem = lbItemsDrawItem
      OnMeasureItem = lbItemsMeasureItem
    end
    object Panel1: TPanel
      Left = 168
      Top = 22
      Width = 32
      Height = 166
      Align = alRight
      TabOrder = 1
      object btnItemAdd: TOvcSpeedButton
        Left = 4
        Top = 7
        Width = 25
        Height = 25
        Hint = 'Add Item'
        Glyph.Data = {
          DE000000424DDE0000000000000076000000280000000D0000000D0000000100
          0400000000006800000000000000000000001000000010000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          3000333300000333300033330AAA0333300033330AAA0333300030000AAA0000
          300030AAAAAAAAA0300030AAAAAAAAA0300030AAAAAAAAA0300030000AAA0000
          300033330AAA0333300033330AAA033330003333000003333000333333333333
          3000}
        OnClick = btnItemAddClick
      end
      object btnItemDelete: TOvcSpeedButton
        Left = 4
        Top = 39
        Width = 25
        Height = 25
        Hint = 'Remove item'
        Glyph.Data = {
          DE000000424DDE0000000000000076000000280000000D0000000D0000000100
          0400000000006800000000000000000000001000000010000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          3000333333333333300033333333333330003333333333333000300000000000
          3000309999999990300030999999999030003099999999903000300000000000
          3000333333333333300033333333333330003333333333333000333333333333
          3000}
        OnClick = btnItemDeleteClick
      end
      object btnItemUp: TOvcSpeedButton
        Left = 4
        Top = 72
        Width = 25
        Height = 25
        Hint = 'Move item up'
        AutoRepeat = True
        Glyph.Data = {
          DE000000424DDE0000000000000076000000280000000D0000000D0000000100
          0400000000006800000000000000000000001000000010000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          3000333333333333300033330000033330003333066603333000333306660333
          3000333306660333300030000666000030003306666666033000333066666033
          3000333306660333300033333060333330003333330333333000333333333333
          3000}
        OnClick = btnItemUpClick
      end
      object btnItemDown: TOvcSpeedButton
        Left = 4
        Top = 104
        Width = 25
        Height = 25
        Hint = 'Move item down'
        AutoRepeat = True
        Glyph.Data = {
          DE000000424DDE0000000000000076000000280000000D0000000D0000000100
          0400000000006800000000000000000000001000000010000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          3000333333333333300033333303333330003333306033333000333306660333
          3000333066666033300033066666660330003000066600003000333306660333
          3000333306660333300033330666033330003333000003333000333333333333
          3000}
        OnClick = btnItemDownClick
      end
    end
    object Panel4: TPanel
      Left = 1
      Top = 1
      Width = 199
      Height = 21
      Align = alTop
      TabOrder = 2
      object Label2: TLabel
        Left = 4
        Top = 4
        Width = 56
        Height = 13
        Caption = '&Items/Icons'
        FocusControl = lbItems
      end
    end
  end
  object pnlFolders: TPanel
    Left = 0
    Top = 0
    Width = 217
    Height = 189
    Align = alLeft
    TabOrder = 0
    object lbFolders: TListBox
      Left = 1
      Top = 22
      Width = 183
      Height = 166
      Align = alClient
      ItemHeight = 13
      TabOrder = 0
      OnClick = lbFoldersClick
    end
    object Panel6: TPanel
      Left = 1
      Top = 1
      Width = 215
      Height = 21
      Align = alTop
      TabOrder = 2
      object Label1: TLabel
        Left = 4
        Top = 4
        Width = 34
        Height = 13
        Caption = '&Folders'
        FocusControl = lbFolders
      end
    end
    object Panel5: TPanel
      Left = 184
      Top = 22
      Width = 32
      Height = 166
      Align = alRight
      TabOrder = 1
      object btnFolderAdd: TOvcSpeedButton
        Left = 4
        Top = 7
        Width = 25
        Height = 25
        Hint = 'Add Item'
        Glyph.Data = {
          DE000000424DDE0000000000000076000000280000000D0000000D0000000100
          0400000000006800000000000000000000001000000010000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          3000333300000333300033330AAA0333300033330AAA0333300030000AAA0000
          300030AAAAAAAAA0300030AAAAAAAAA0300030AAAAAAAAA0300030000AAA0000
          300033330AAA0333300033330AAA033330003333000003333000333333333333
          3000}
        OnClick = btnFolderAddClick
      end
      object btnFolderDelete: TOvcSpeedButton
        Left = 4
        Top = 39
        Width = 25
        Height = 25
        Hint = 'Remove item'
        Glyph.Data = {
          DE000000424DDE0000000000000076000000280000000D0000000D0000000100
          0400000000006800000000000000000000001000000010000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          3000333333333333300033333333333330003333333333333000300000000000
          3000309999999990300030999999999030003099999999903000300000000000
          3000333333333333300033333333333330003333333333333000333333333333
          3000}
        OnClick = btnFolderDeleteClick
      end
      object btnFolderUp: TOvcSpeedButton
        Left = 4
        Top = 72
        Width = 25
        Height = 25
        Hint = 'Move item up'
        AutoRepeat = True
        Glyph.Data = {
          DE000000424DDE0000000000000076000000280000000D0000000D0000000100
          0400000000006800000000000000000000001000000010000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          3000333333333333300033330000033330003333066603333000333306660333
          3000333306660333300030000666000030003306666666033000333066666033
          3000333306660333300033333060333330003333330333333000333333333333
          3000}
        OnClick = btnFolderUpClick
      end
      object btnFolderDown: TOvcSpeedButton
        Left = 4
        Top = 104
        Width = 25
        Height = 25
        Hint = 'Move item down'
        AutoRepeat = True
        Glyph.Data = {
          DE000000424DDE0000000000000076000000280000000D0000000D0000000100
          0400000000006800000000000000000000001000000010000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          3000333333333333300033333303333330003333306033333000333306660333
          3000333066666033300033066666660330003000066600003000333306660333
          3000333306660333300033330666033330003333000003333000333333333333
          3000}
        OnClick = btnFolderDownClick
      end
    end
  end
  object pnlImages: TPanel
    Left = 0
    Top = 189
    Width = 418
    Height = 100
    Align = alBottom
    TabOrder = 2
    object Panel8: TPanel
      Left = 1
      Top = 1
      Width = 416
      Height = 25
      Align = alTop
      TabOrder = 0
      object Label3: TLabel
        Left = 8
        Top = 8
        Width = 80
        Height = 13
        Caption = 'Available I&mages'
      end
    end
    object lbImages: TListBox
      Left = 1
      Top = 26
      Width = 416
      Height = 73
      Style = lbOwnerDrawFixed
      Align = alClient
      Columns = 10
      ItemHeight = 16
      TabOrder = 1
      OnClick = lbImagesClick
      OnDrawItem = lbImagesDrawItem
    end
  end
end
