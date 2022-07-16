object XWBSSOiFrm: TXWBSSOiFrm
  Left = 0
  Top = 0
  Caption = 'Authenticate User'
  ClientHeight = 133
  ClientWidth = 292
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 97
    Height = 16
    Caption = 'Please Wait...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object WebBrowser1: TWebBrowser
    Left = 8
    Top = 48
    Width = 276
    Height = 77
    TabOrder = 0
    OnBeforeNavigate2 = WebBrowser1BeforeNavigate2
    OnNavigateComplete2 = WebBrowser1NavigateComplete2
    OnDocumentComplete = WebBrowser1DocumentComplete
    OnNavigateError = WebBrowser1NavigateError
    ControlData = {
      4C000000871C0000F50700000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
end
