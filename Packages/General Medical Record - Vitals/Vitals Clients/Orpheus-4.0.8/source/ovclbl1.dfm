object frmSaveScheme: TfrmSaveScheme
  Left = 347
  Top = 298
  BorderStyle = bsDialog
  Caption = 'Save Style'
  ClientHeight = 85
  ClientWidth = 348
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Default'
  Font.Style = []
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 4
    Top = 8
    Width = 85
    Height = 13
    Caption = 'Save this style as:'
  end
  object SchemeNameEd: TEdit
    Left = 4
    Top = 24
    Width = 341
    Height = 21
    MaxLength = 255
    TabOrder = 0
  end
  object OkBtn: TButton
    Left = 192
    Top = 56
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object CancelBtn: TButton
    Left = 272
    Top = 56
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
