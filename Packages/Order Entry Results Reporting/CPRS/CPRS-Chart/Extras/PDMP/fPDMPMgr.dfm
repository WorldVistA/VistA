object frmPDMP: TfrmPDMP
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'PDMP'
  ClientHeight = 65
  ClientWidth = 99
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -19
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 24
  object pnlPdmp: TPanel
    Left = 0
    Top = 0
    Width = 99
    Height = 65
    Align = alClient
    BevelWidth = 2
    Caption = 'Requested...'
    ParentBackground = False
    ParentColor = True
    ShowCaption = False
    TabOrder = 0
    object bbCancel: TButton
      Left = 1
      Top = 1
      Width = 97
      Height = 63
      Action = acCancel
      Align = alClient
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      Visible = False
      WordWrap = True
    end
    object bbResults: TButton
      Left = 1
      Top = 1
      Width = 97
      Height = 63
      Action = acResults
      Align = alClient
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      WordWrap = True
    end
    object bbStart: TButton
      Left = 1
      Top = 1
      Width = 97
      Height = 63
      Action = acPDMPRequest
      Align = alClient
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
