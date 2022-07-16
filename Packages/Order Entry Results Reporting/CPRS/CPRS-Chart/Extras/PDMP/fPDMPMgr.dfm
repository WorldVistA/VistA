object frmPDMP: TfrmPDMP
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'PDMP'
  ClientHeight = 65
  ClientWidth = 99
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -19
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 23
  object pnlPdmp: TPanel
    Left = 0
    Top = 0
    Width = 99
    Height = 65
    Align = alClient
    BevelWidth = 2
    Caption = 'Requested...'
    ParentBackground = False
    ShowCaption = False
    TabOrder = 0
    object bbCancel: TBitBtn
      Left = 2
      Top = 2
      Width = 95
      Height = 61
      Action = acCancel
      Align = alClient
      Caption = 'PDMP Cancel'
      Layout = blGlyphTop
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      Visible = False
      WordWrap = True
    end
    object bbResults: TBitBtn
      Left = 2
      Top = 2
      Width = 95
      Height = 61
      Action = acResults
      Align = alClient
      Caption = 'PDMP Results'
      Layout = blGlyphTop
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      WordWrap = True
    end
    object bbStart: TBitBtn
      Left = 2
      Top = 2
      Width = 95
      Height = 61
      Action = acPDMPRequest
      Align = alClient
      Caption = 'PDMP Query'
      Layout = blGlyphTop
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Visible = False
      WordWrap = True
    end
  end
  object alPdmp: TActionList
    Left = 64
    Top = 8
    object acResults: TAction
      Caption = 'PDMP Results'
      Hint = 'Show PDMP Results'
      ImageIndex = 0
      Visible = False
      OnExecute = acResultsExecute
    end
    object acPDMPRequest: TAction
      Caption = 'PDMP Query'
      Hint = 'Request PDMP data'
      ImageIndex = 0
      OnExecute = acPDMPRequestExecute
    end
    object acCancel: TAction
      Caption = 'PDMP Cancel'
      Hint = 'Cancel PDMP request'
      ImageIndex = 1
      OnExecute = acCancelExecute
    end
  end
end
