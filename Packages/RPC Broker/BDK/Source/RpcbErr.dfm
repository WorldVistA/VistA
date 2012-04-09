object frmRpcbError: TfrmRpcbError
  Left = 187
  Top = 278
  BorderStyle = bsDialog
  Caption = 'Error!'
  ClientHeight = 227
  ClientWidth = 393
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = [fsBold]
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 377
    Height = 177
  end
  object Label1: TLabel
    Left = 72
    Top = 24
    Width = 41
    Height = 13
    Alignment = taRightJustify
    Caption = 'Action:'
  end
  object Symbol: TImage
    Left = 16
    Top = 16
    Width = 41
    Height = 41
  end
  object Label2: TLabel
    Left = 79
    Top = 48
    Width = 34
    Height = 13
    Alignment = taRightJustify
    Caption = 'Code:'
  end
  object Label3: TLabel
    Left = 16
    Top = 80
    Width = 55
    Height = 13
    Caption = 'Message:'
  end
  object lblAction: TLabel
    Left = 120
    Top = 24
    Width = 5
    Height = 13
  end
  object lblCode: TLabel
    Left = 120
    Top = 48
    Width = 5
    Height = 13
  end
  object lblMessage: TLabel
    Left = 80
    Top = 80
    Width = 289
    Height = 97
    AutoSize = False
  end
  object BitBtn1: TBitBtn
    Left = 200
    Top = 200
    Width = 81
    Height = 27
    TabOrder = 0
    Kind = bkOK
  end
  object BitBtn3: TBitBtn
    Left = 304
    Top = 200
    Width = 81
    Height = 27
    TabOrder = 1
    Kind = bkHelp
  end
end
