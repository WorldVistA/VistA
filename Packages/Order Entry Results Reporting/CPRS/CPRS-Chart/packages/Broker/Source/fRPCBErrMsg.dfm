object frmErrMsg: TfrmErrMsg
  Left = 325
  Top = 293
  Anchors = [akTop]
  Caption = 'Error Encountered'
  ClientHeight = 101
  ClientWidth = 222
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -6
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 62
    Top = 78
    Width = 88
    Height = 19
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object mmoErrorMessage: TMemo
    Left = 4
    Top = 8
    Width = 213
    Height = 66
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -6
    Font.Name = 'Fixedsys'
    Font.Style = []
    Lines.Strings = (
      '')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
  end
end
