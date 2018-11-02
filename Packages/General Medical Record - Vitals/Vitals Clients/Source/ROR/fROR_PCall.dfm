object RPCErrorForm: TRPCErrorForm
  Left = 491
  Top = 309
  Anchors = []
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'RPC Error'
  ClientHeight = 333
  ClientWidth = 472
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  DesignSize = (
    472
    333)
  PixelsPerInch = 96
  TextHeight = 13
  object Msg: TMemo
    Left = 8
    Top = 8
    Width = 457
    Height = 286
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = clBtnFace
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object btnOk: TButton
    Left = 199
    Top = 302
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = btnOkClick
  end
end
