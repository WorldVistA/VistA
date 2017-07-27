object frmDebugInfo: TfrmDebugInfo
  Left = 255
  Top = 107
  Anchors = [akTop]
  Caption = 'RPCBroker Debug Info'
  ClientHeight = 180
  ClientWidth = 316
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  PixelsPerInch = 120
  TextHeight = 13
  object lblDebugInfo: TLabel
    Left = 43
    Top = 16
    Width = 230
    Height = 103
    AutoSize = False
  end
  object btnOK: TButton
    Left = 121
    Top = 142
    Width = 74
    Height = 24
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
end
