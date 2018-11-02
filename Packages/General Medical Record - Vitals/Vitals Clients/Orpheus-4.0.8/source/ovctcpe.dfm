object OvcfrmTCRange: TOvcfrmTCRange
  Left = 586
  Top = 521
  BorderStyle = bsDialog
  Caption = 'Range Property Editor'
  ClientHeight = 165
  ClientWidth = 310
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'Default'
  Font.Style = []
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object TBevel
    Left = 5
    Top = 5
    Width = 300
    Height = 121
    Shape = bsFrame
    IsControl = True
  end
  object lblRange: TLabel
    Left = 19
    Top = 21
    Width = 142
    Height = 13
    Caption = 'Enter the desired range value:'
  end
  object TLabel
    Left = 19
    Top = 77
    Width = 271
    Height = 17
    AutoSize = False
    Caption = 'Allowable values are:'
  end
  object lblLower: TLabel
    Left = 19
    Top = 101
    Width = 39
    Height = 13
    Caption = 'lblLower'
  end
  object TLabel
    Left = 117
    Top = 101
    Width = 9
    Height = 13
    Caption = 'to'
  end
  object lblUpper: TLabel
    Left = 181
    Top = 101
    Width = 39
    Height = 13
    Caption = 'lblUpper'
  end
  object pfRange: TOvcPictureField
    Left = 19
    Top = 45
    Width = 273
    Height = 21
    Cursor = crIBeam
    HelpContext = 1
    DataType = pftString
    CaretOvr.Shape = csBlock
    Controller = DefaultController
    ControlCharColor = clRed
    DecimalPlaces = 0
    EFColors.Disabled.BackColor = clWindow
    EFColors.Disabled.TextColor = clGrayText
    EFColors.Error.BackColor = clRed
    EFColors.Error.TextColor = clBlack
    EFColors.Highlight.BackColor = clHighlight
    EFColors.Highlight.TextColor = clHighlightText
    Epoch = 1900
    InitDateTime = False
    PictureMask = 'XXXXXXXXXXXXXXX'
    TabOrder = 0
    Visible = False
  end
  object sfRange: TOvcSimpleField
    Left = 20
    Top = 45
    Width = 272
    Height = 21
    Cursor = crIBeam
    DataType = sftString
    CaretOvr.Shape = csBlock
    ControlCharColor = clRed
    Controller = DefaultController
    DecimalPlaces = 0
    EFColors.Disabled.BackColor = clWindow
    EFColors.Disabled.TextColor = clGrayText
    EFColors.Error.BackColor = clRed
    EFColors.Error.TextColor = clBlack
    EFColors.Highlight.BackColor = clHighlight
    EFColors.Highlight.TextColor = clHighlightText
    PictureMask = 'X'
    TabOrder = 1
    Visible = False
  end
  object btnOK: TBitBtn
    Left = 147
    Top = 134
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
    NumGlyphs = 2
  end
  object btnCancel: TBitBtn
    Left = 230
    Top = 134
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
    NumGlyphs = 2
  end
  object DefaultController: TOvcController
    EntryCommands.TableList = (
      'Default'
      True
      ())
    Epoch = 1900
    Left = 8
    Top = 135
  end
end
