object TO32FrmValidatorExpression: TTO32FrmValidatorExpression
  Left = 345
  Top = 258
  ActiveControl = edMask
  BorderStyle = bsSingle
  Caption = 'Expression'
  ClientHeight = 217
  ClientWidth = 494
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Default'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 250
    Top = 73
    Width = 237
    Height = 107
  end
  object lblMask: TLabel
    Left = 254
    Top = 78
    Width = 229
    Height = 97
    AutoSize = False
    WordWrap = True
  end
  object lblMaskEdit: TLabel
    Left = 7
    Top = 2
    Width = 51
    Height = 13
    Caption = '&Expression'
  end
  object lblMaskDescription: TLabel
    Left = 251
    Top = 50
    Width = 89
    Height = 13
    Caption = 'Sample description'
  end
  object lblMaskList: TLabel
    Left = 7
    Top = 50
    Width = 35
    Height = 13
    Caption = '&Sample'
  end
  object btnOK: TBitBtn
    Left = 331
    Top = 188
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
    NumGlyphs = 2
  end
  object btnCancel: TBitBtn
    Left = 412
    Top = 188
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
    NumGlyphs = 2
  end
  object lbMask: TListBox
    Left = 6
    Top = 73
    Width = 238
    Height = 107
    ExtendedSelect = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Pitch = fpFixed
    Font.Style = []
    ItemHeight = 15
    ParentFont = False
    TabOrder = 1
    OnClick = lbMaskClick
  end
  object edMask: TEdit
    Left = 6
    Top = 22
    Width = 481
    Height = 23
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Pitch = fpFixed
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
end
