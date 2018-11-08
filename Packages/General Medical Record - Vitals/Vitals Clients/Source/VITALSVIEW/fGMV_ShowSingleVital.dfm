object frmGMV_ShowSingleVital: TfrmGMV_ShowSingleVital
  Left = 460
  Top = 226
  BorderStyle = bsNone
  Caption = 'frmGMV_ShowSingleVital'
  ClientHeight = 169
  ClientWidth = 173
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnKeyDown = FormKeyDown
  OnMouseDown = FormMouseDown
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 173
    Height = 169
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Align = alClient
    BevelInner = bvLowered
    BorderWidth = 1
    TabOrder = 0
    object lblInstructionsToClose: TLabel
      Left = 3
      Top = 134
      Width = 167
      Height = 32
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Align = alBottom
      Alignment = taCenter
      AutoSize = False
      Caption = 'Press any key or click on this window to close.'
      Color = clInfoBk
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clInfoText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
      Layout = tlCenter
      WordWrap = True
      OnMouseDown = FormMouseDown
      ExplicitLeft = 2
      ExplicitTop = 135
      ExplicitWidth = 169
    end
    object memDisplay: TMemo
      Left = 3
      Top = 3
      Width = 167
      Height = 131
      Cursor = crArrow
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      TabStop = False
      Align = alClient
      BorderStyle = bsNone
      Lines.Strings = (
        'memDisplay')
      ReadOnly = True
      TabOrder = 0
      WantTabs = True
      OnKeyDown = FormKeyDown
      OnMouseDown = FormMouseDown
    end
  end
  object tmrSingleView: TTimer
    Enabled = False
    Interval = 15000
    OnTimer = tmrSingleViewTimer
    Left = 72
    Top = 64
  end
end
