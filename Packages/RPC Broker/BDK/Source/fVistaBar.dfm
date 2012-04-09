object frmVistABar: TfrmVistABar
  Left = 200
  Top = 200
  BorderIcons = [biSystemMenu]
  BorderStyle = bsNone
  ClientHeight = 213
  ClientWidth = 104
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  WindowState = wsMinimized
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pmnSysTray: TPopupMenu
    Left = 24
    Top = 32
    object About1: TMenuItem
      Caption = '&About'
      OnClick = About1Click
    end
  end
end
