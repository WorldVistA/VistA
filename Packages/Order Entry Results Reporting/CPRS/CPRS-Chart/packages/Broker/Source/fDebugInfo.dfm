object frmDebugInfo: TfrmDebugInfo
  Left = 255
  Top = 107
  Anchors = [akTop]
  Caption = 'RPCBroker Debug Info'
  ClientHeight = 144
  ClientWidth = 253
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -9
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lblDebugInfo: TLabel
    Left = 34
    Top = 13
    Width = 184
    Height = 82
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    AutoSize = False
  end
  object btnOK: TButton
    Left = 97
    Top = 114
    Width = 59
    Height = 19
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
end
