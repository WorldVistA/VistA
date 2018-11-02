object OvcfrmProperties: TOvcfrmProperties
  Left = 301
  Top = 206
  BorderStyle = bsDialog
  Caption = 'Cell Properties'
  ClientHeight = 119
  ClientWidth = 343
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Default'
  Font.Style = []
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 31
    Top = 9
    Width = 62
    Height = 13
    Alignment = taRightJustify
    Caption = 'Picture Mask'
  end
  object Label2: TLabel
    Left = 18
    Top = 34
    Width = 73
    Height = 13
    Alignment = taRightJustify
    Caption = 'Decimal Places'
  end
  object edPictureMask: TOvcSimpleField
    Left = 112
    Top = 8
    Width = 225
    Height = 21
    Cursor = crIBeam
    DataType = sftString
    CaretOvr.Shape = csBlock
    ControlCharColor = clRed
    Controller = OvcController1
    DecimalPlaces = 0
    EFColors.Disabled.BackColor = clWindow
    EFColors.Disabled.TextColor = clGrayText
    EFColors.Error.BackColor = clRed
    EFColors.Error.TextColor = clBlack
    EFColors.Highlight.BackColor = clHighlight
    EFColors.Highlight.TextColor = clHighlightText
    PictureMask = 'X'
    TabOrder = 0
  end
  object edDecimalPlaces: TOvcSimpleField
    Left = 112
    Top = 32
    Width = 57
    Height = 21
    Cursor = crIBeam
    DataType = sftByte
    CaretOvr.Shape = csBlock
    ControlCharColor = clRed
    Controller = OvcController1
    DecimalPlaces = 0
    EFColors.Disabled.BackColor = clWindow
    EFColors.Disabled.TextColor = clGrayText
    EFColors.Error.BackColor = clRed
    EFColors.Error.TextColor = clBlack
    EFColors.Highlight.BackColor = clHighlight
    EFColors.Highlight.TextColor = clHighlightText
    MaxLength = 3
    PictureMask = '9'
    TabOrder = 1
    RangeHigh = {FF000000000000000000}
    RangeLow = {00000000000000000000}
  end
  object rgDateOrTime: TRadioGroup
    Left = 10
    Top = 56
    Width = 135
    Height = 57
    Caption = 'Date or Time'
    Enabled = False
    ItemIndex = 0
    Items.Strings = (
      'Edit date'
      'Edit time')
    TabOrder = 2
    OnClick = rgDateOrTimeClick
  end
  object Button1: TButton
    Left = 183
    Top = 88
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object Button2: TButton
    Left = 263
    Top = 88
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object OvcController1: TOvcController
    EntryCommands.TableList = (
      'Default'
      True
      ()
      'WordStar'
      False
      ()
      'Grid'
      False
      ())
    Epoch = 1900
    Left = 311
    Top = 50
  end
end
