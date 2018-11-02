object OvcfrmSimpleMask: TOvcfrmSimpleMask
  Left = 359
  Top = 192
  ActiveControl = cbxMaskCharacter
  BorderStyle = bsSingle
  Caption = 'Simple Mask'
  ClientHeight = 166
  ClientWidth = 323
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Default'
  Font.Style = []
  OldCreateOrder = True
  ShowHint = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblPictureChars: TLabel
    Left = 9
    Top = 2
    Width = 80
    Height = 13
    Caption = '&Mask Characters'
  end
  object btnOk: TBitBtn
    Left = 242
    Top = 102
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    DoubleBuffered = True
    ModalResult = 1
    NumGlyphs = 2
    ParentDoubleBuffered = False
    TabOrder = 1
  end
  object btnCancel: TBitBtn
    Left = 242
    Top = 134
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    DoubleBuffered = True
    ModalResult = 2
    NumGlyphs = 2
    ParentDoubleBuffered = False
    TabOrder = 2
  end
  object cbxMaskCharacter: TComboBox
    Left = 9
    Top = 19
    Width = 224
    Height = 23
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Pitch = fpFixed
    Font.Style = []
    MaxLength = 1
    ParentFont = False
    TabOrder = 0
    OnChange = cbxMaskCharacterChange
  end
end
