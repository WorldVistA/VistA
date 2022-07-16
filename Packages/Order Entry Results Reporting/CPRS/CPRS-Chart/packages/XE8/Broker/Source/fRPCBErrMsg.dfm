object frmErrMsg: TfrmErrMsg
  Left = 325
  Top = 293
  Anchors = [akTop]
  Caption = 'Error Encountered'
  ClientHeight = 126
  ClientWidth = 278
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -7
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  PixelsPerInch = 120
  TextHeight = 13
  object Button1: TButton
    Left = 78
    Top = 97
    Width = 110
    Height = 24
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object mmoErrorMessage: TMemo
    Left = 5
    Top = 10
    Width = 266
    Height = 83
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -7
    Font.Name = 'Fixedsys'
    Font.Style = []
    Lines.Strings = (
      '')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
  end
end
