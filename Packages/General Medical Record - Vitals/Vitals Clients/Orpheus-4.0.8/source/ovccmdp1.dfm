object OvcfrmScanOrder: TOvcfrmScanOrder
  Left = 288
  Top = 172
  ActiveControl = lbCommands
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Change Scan Order'
  ClientHeight = 243
  ClientWidth = 256
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Default'
  Font.Style = []
  ShowHint = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 161
    Height = 225
  end
  object lbCommands: TListBox
    Left = 16
    Top = 48
    Width = 145
    Height = 177
    Hint = 'List of installed command tables'
    ItemHeight = 13
    TabOrder = 0
  end
  object btnUp: TBitBtn
    Left = 176
    Top = 49
    Width = 75
    Height = 25
    Hint = 'Move selected table up'
    TabOrder = 1
    OnClick = btnUpClick
    Glyph.Data = {
      F6000000424DF600000000000000760000002800000010000000100000000100
      0400000000008000000000000000000000001000000010000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      333333333333333333333333337777733333333334444473333333333CCCC473
      333333333CCCC473333333333CCCC473333333333CCCC473333333333CCCC477
      7333333CCCCCCCCC33333333CCCCCCC3333333333CCCCC333333333333CCC333
      33333333333C3333333333333333333333333333333333333333}
    Layout = blGlyphTop
  end
  object bntDown: TBitBtn
    Left = 176
    Top = 80
    Width = 75
    Height = 25
    Hint = 'Move selected table down'
    TabOrder = 2
    OnClick = bntDownClick
    Glyph.Data = {
      F6000000424DF600000000000000760000002800000010000000100000000100
      0400000000008000000000000000000000001000000010000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      333333333333733333333333333477333333333333CC4773333333333CCCC477
      33333333CCCCCC477333333CCCCCC444333333333CCCC473333333333CCCC473
      333333333CCCC473333333333CCCC473333333333CCCC473333333333CCCC433
      3333333333333333333333333333333333333333333333333333}
    Layout = blGlyphBottom
  end
  object btnOk: TBitBtn
    Left = 177
    Top = 178
    Width = 75
    Height = 25
    Hint = 'Accept changes and exit'
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
    NumGlyphs = 2
  end
  object pnlCmdTables: TPanel
    Left = 16
    Top = 16
    Width = 145
    Height = 25
    Caption = 'Command tables'
    TabOrder = 5
  end
  object btnCancel: TBitBtn
    Left = 177
    Top = 208
    Width = 75
    Height = 25
    Hint = 'Cancel changes and exit'
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
    NumGlyphs = 2
  end
end
