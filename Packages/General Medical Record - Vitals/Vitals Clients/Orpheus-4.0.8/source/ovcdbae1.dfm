object OvcfrmDbAeSimpleMask: TOvcfrmDbAeSimpleMask
  Left = 353
  Top = 160
  ActiveControl = cbxMaskCharacter
  BorderStyle = bsDialog
  Caption = 'Simple Mask'
  ClientHeight = 162
  ClientWidth = 324
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Default'
  Font.Style = []
  Position = poScreenCenter
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
  object cbxMaskCharacter: TComboBox
    Left = 9
    Top = 19
    Width = 224
    Height = 23
    DropDownCount = 16
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Pitch = fpFixed
    Font.Style = []
    ItemHeight = 15
    MaxLength = 1
    ParentFont = False
    TabOrder = 0
    OnChange = cbxMaskCharacterChange
  end
  object Button1: TButton
    Left = 245
    Top = 99
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 245
    Top = 131
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
