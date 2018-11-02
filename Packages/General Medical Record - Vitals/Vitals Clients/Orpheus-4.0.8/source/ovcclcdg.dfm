object OvcfrmCalculatorDlg: TOvcfrmCalculatorDlg
  Left = 413
  Top = 232
  Caption = 'Calculator Dialog'
  ClientHeight = 172
  ClientWidth = 252
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Default'
  Font.Style = []
  OldCreateOrder = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object TPanel
    Left = 0
    Top = 141
    Width = 252
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 152
    ExplicitWidth = 260
    object btnHelp: TButton
      Left = 4
      Top = 4
      Width = 75
      Height = 25
      Caption = 'Help'
      TabOrder = 0
    end
    object TPanel
      Left = 95
      Top = 0
      Width = 165
      Height = 31
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      object btnOK: TButton
        Left = 6
        Top = 4
        Width = 75
        Height = 25
        Caption = 'OK'
        Default = True
        ModalResult = 1
        TabOrder = 0
      end
      object btnCancel: TButton
        Left = 88
        Top = 4
        Width = 75
        Height = 25
        Cancel = True
        Caption = 'Cancel'
        ModalResult = 2
        TabOrder = 1
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 252
    Height = 141
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 260
    ExplicitHeight = 152
    object OvcCalculator1: TOvcCalculator
      Left = 1
      Top = 1
      Width = 258
      Height = 150
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Default'
      Font.Style = [fsBold]
      TapeFont.Charset = DEFAULT_CHARSET
      TapeFont.Color = clWindowText
      TapeFont.Height = -13
      TapeFont.Name = 'Courier New'
      TapeFont.Style = [fsBold]
      Colors.ColorScheme = cscalcCustom
      Colors.DisabledMemoryButtons = clGray
      Colors.Display = clWindow
      Colors.DisplayTextColor = clWindowText
      Colors.EditButtons = clMaroon
      Colors.FunctionButtons = clNavy
      Colors.MemoryButtons = clRed
      Colors.NumberButtons = clBlue
      Colors.OperatorButtons = clRed
      Decimals = 2
      TapeHeight = 46
      ParentFont = False
      TabOrder = 0
    end
  end
end
