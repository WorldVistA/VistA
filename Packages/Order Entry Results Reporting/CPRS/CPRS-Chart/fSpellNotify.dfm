inherited frmSpellNotify: TfrmSpellNotify
  Left = 0
  Top = 0
  Cursor = crHourGlass
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Spell Check Running'
  ClientHeight = 74
  ClientWidth = 355
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = Refocus
  OnClick = Refocus
  OnCreate = FormCreate
  OnDblClick = Refocus
  OnMouseDown = FormMouseDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlWord: TPanel
    Left = 0
    Top = 0
    Width = 356
    Height = 71
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 352
    ExplicitHeight = 70
  end
  object pnlLabels: TPanel
    Left = 0
    Top = 0
    Width = 356
    Height = 71
    Align = alClient
    TabOrder = 1
    ExplicitWidth = 352
    ExplicitHeight = 70
    object lblMain: TLabel
      Left = 1
      Top = 1
      Width = 354
      Height = 50
    Align = alClient
    Alignment = taCenter
    Caption = 'Spell Check Running'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    Layout = tlCenter
    OnClick = Refocus
    OnDblClick = Refocus
    ExplicitWidth = 243
    ExplicitHeight = 29
  end
  object lblOptions: TLabel
    Left = 0
    Top = 55
    Width = 355
    Height = 19
    Align = alBottom
    Alignment = taCenter
    Caption = '(Set Options using Grammar Check)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ExplicitTop = 58
    ExplicitWidth = 256
    end
  end
  object tmrMain: TTimer
    OnTimer = Refocus
    Left = 312
    Top = 8
  end
end
