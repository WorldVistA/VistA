inherited frmDbgServer: TfrmDbgServer
  Left = 206
  Top = 168
  Caption = 'Server Information'
  ClientHeight = 301
  ClientWidth = 500
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyUp = FormKeyUp
  ExplicitWidth = 508
  ExplicitHeight = 328
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 6
    Top = 6
    Width = 101
    Height = 13
    Caption = 'Current Symbol Table'
  end
  object memSymbols: TRichEdit [1]
    Left = 6
    Top = 20
    Width = 488
    Height = 248
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      'memSymbols')
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
    WantReturns = False
  end
  object RadioButton1: TRadioButton [2]
    Left = 8
    Top = 276
    Width = 125
    Height = 17
    Caption = 'Current Symbol Table'
    Checked = True
    TabOrder = 1
    TabStop = True
  end
  object RadioButton2: TRadioButton [3]
    Left = 156
    Top = 276
    Width = 105
    Height = 17
    Caption = 'Global Reference'
    TabOrder = 2
  end
  object Edit1: TEdit [4]
    Left = 264
    Top = 274
    Width = 229
    Height = 21
    Enabled = False
    TabOrder = 3
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = memSymbols'
        'Status = stsDefault')
      (
        'Component = RadioButton1'
        'Status = stsDefault')
      (
        'Component = RadioButton2'
        'Status = stsDefault')
      (
        'Component = Edit1'
        'Status = stsDefault')
      (
        'Component = frmDbgServer'
        'Status = stsDefault'))
  end
end
