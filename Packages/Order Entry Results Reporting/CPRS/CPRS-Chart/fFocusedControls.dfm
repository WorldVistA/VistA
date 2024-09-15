inherited dlgFocusedControls: TdlgFocusedControls
  Left = 0
  Top = 0
  Caption = 'Focused Controls'
  ClientHeight = 348
  ClientWidth = 643
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object sbar: TStatusBar
    Left = 0
    Top = 329
    Width = 643
    Height = 19
    Panels = <>
  end
  object lv: TListView
    Left = 0
    Top = 0
    Width = 643
    Height = 329
    Align = alClient
    Color = clBtnFace
    Columns = <
      item
        Caption = '#'
      end
      item
        Caption = 'From'
        Width = 200
      end
      item
        Caption = 'To'
        Width = 200
      end
      item
        Caption = 'Direction'
        Width = 100
      end>
    Items.ItemData = {
      01530000000100000000000000FFFFFFFFFFFFFFFF0300000000000000013100
      094100200043006F006E00740072006F006C00094200200043006F006E007400
      72006F006C000746006F0072007700610072006400FFFFFFFFFFFF}
    TabOrder = 1
    ViewStyle = vsReport
    ExplicitTop = -6
  end
end
