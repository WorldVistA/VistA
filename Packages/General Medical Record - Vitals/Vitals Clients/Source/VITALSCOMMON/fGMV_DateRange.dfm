object frmGMV_DateRange: TfrmGMV_DateRange
  Left = 517
  Top = 293
  Caption = 'Date Range Selection'
  ClientHeight = 71
  ClientWidth = 315
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 222
    Top = 0
    Width = 93
    Height = 71
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitLeft = 230
    ExplicitHeight = 82
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 93
      Height = 6
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
    end
    object btnOK: TButton
      Left = 8
      Top = 14
      Width = 75
      Height = 25
      Caption = '&OK'
      TabOrder = 1
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 8
      Top = 46
      Width = 75
      Height = 25
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 2
    end
  end
  object Panel5: TPanel
    Left = 0
    Top = 0
    Width = 222
    Height = 71
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitWidth = 230
    ExplicitHeight = 82
    object GroupBox1: TGroupBox
      Left = 0
      Top = 0
      Width = 222
      Height = 71
      Align = alClient
      TabOrder = 0
      ExplicitWidth = 230
      ExplicitHeight = 82
      object lblFrom: TLabel
        Left = 16
        Top = 20
        Width = 73
        Height = 13
        Caption = '&Start with Date:'
        FocusControl = dtpFrom
      end
      object lblTo: TLabel
        Left = 16
        Top = 52
        Width = 55
        Height = 13
        Caption = '&Go to Date:'
        FocusControl = dtpTo
      end
      object dtpFrom: TDateTimePicker
        Left = 104
        Top = 16
        Width = 105
        Height = 21
        Date = 37302.494292777800000000
        Time = 37302.494292777800000000
        Color = clInfoBk
        TabOrder = 0
        OnEnter = dtpFromEnter
        OnExit = dtpFromExit
      end
      object dtpTo: TDateTimePicker
        Left = 104
        Top = 48
        Width = 105
        Height = 21
        Date = 37302.494456319400000000
        Time = 37302.494456319400000000
        TabOrder = 1
        OnEnter = dtpToEnter
        OnExit = dtpToExit
      end
    end
  end
end
