object XWBSSOiFrm: TXWBSSOiFrm
  Left = 0
  Top = 0
  Caption = 'Authenticate User'
  ClientHeight = 130
  ClientWidth = 308
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  WindowState = wsMinimized
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
  object tokenMemo: TMemo
    Left = 8
    Top = 40
    Width = 265
    Height = 81
    TabOrder = 0
  end
  object XmlDoc: TXMLDocument
    Left = 160
    Top = 8
    DOMVendorDesc = 'MSXML'
  end
  object httpRio2: THTTPRIO
    OnAfterExecute = httpRio2AfterExecute
    OnBeforeExecute = httpRio2BeforeExecute
    Converter.Options = [soSendMultiRefObj, soTryAllSchema, soRootRefNodesToBody, soCacheMimeResponse, soUTF8EncodeXML]
    Left = 208
    Top = 8
  end
end
