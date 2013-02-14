inherited frmODQuick: TfrmODQuick
  Left = 371
  Top = 203
  Caption = 'frmODQuick'
  ClientHeight = 263
  ClientWidth = 296
  ExplicitWidth = 304
  ExplicitHeight = 290
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 8
    Top = 8
    Width = 261
    Height = 13
    Caption = 'Enter the name that should be used for this quick order.'
  end
  object Label2: TLabel [1]
    Left = 8
    Top = 61
    Width = 136
    Height = 13
    Caption = 'Meds, Inpatient Common List'
  end
  object SpeedButton1: TSpeedButton [2]
    Left = 263
    Top = 108
    Width = 25
    Height = 25
    Glyph.Data = {
      F6000000424DF600000000000000760000002800000010000000100000000100
      0400000000008000000000000000000000001000000010000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      33333333333333333333333333333333333333333CCCCC33333333333CCCCC33
      333333333CCCCC33333333333CCCCC33333333333CCCCC33333333333CCCCC33
      3333333CCCCCCCCC33333333CCCCCCC3333333333CCCCC333333333333CCC333
      33333333333C3333333333333333333333333333333333333333}
  end
  object SpeedButton2: TSpeedButton [3]
    Left = 263
    Top = 144
    Width = 25
    Height = 25
    Glyph.Data = {
      F6000000424DF600000000000000760000002800000010000000100000000100
      0400000000008000000000000000000000001000000010000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333333333333333333333333C33333333333333CCC333
      333333333CCCCC3333333333CCCCCCC33333333CCCCCCCCC333333333CCCCC33
      333333333CCCCC33333333333CCCCC33333333333CCCCC33333333333CCCCC33
      333333333CCCCC33333333333333333333333333333333333333}
  end
  object Bevel1: TBevel [4]
    Left = 8
    Top = 224
    Width = 280
    Height = 2
  end
  object Bevel2: TBevel [5]
    Left = 8
    Top = 51
    Width = 280
    Height = 2
  end
  object Edit1: TCaptionEdit [6]
    Left = 8
    Top = 22
    Width = 280
    Height = 21
    TabOrder = 0
    Caption = 'Enter the name that should be used for this quick order.'
  end
  object ORListBox1: TORListBox [7]
    Left = 8
    Top = 75
    Width = 245
    Height = 141
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    ItemTipColor = clWindow
    LongList = False
  end
  object Button1: TButton [8]
    Left = 136
    Top = 234
    Width = 72
    Height = 21
    Caption = 'OK'
    TabOrder = 2
  end
  object Button2: TButton [9]
    Left = 216
    Top = 234
    Width = 72
    Height = 21
    Caption = 'Cancel'
    TabOrder = 3
  end
  object BitBtn1: TBitBtn [10]
    Left = 263
    Top = 191
    Width = 25
    Height = 25
    TabOrder = 4
    Kind = bkAbort
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = Edit1'
        'Status = stsDefault')
      (
        'Component = ORListBox1'
        'Status = stsDefault')
      (
        'Component = Button1'
        'Status = stsDefault')
      (
        'Component = Button2'
        'Status = stsDefault')
      (
        'Component = BitBtn1'
        'Status = stsDefault')
      (
        'Component = frmODQuick'
        'Status = stsDefault'))
  end
end
