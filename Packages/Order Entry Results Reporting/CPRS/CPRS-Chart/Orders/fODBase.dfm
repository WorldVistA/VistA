inherited frmODBase: TfrmODBase
  Left = 277
  Top = 179
  Width = 592
  Height = 358
  HorzScrollBar.Range = 500
  HorzScrollBar.Tracking = True
  HorzScrollBar.Visible = True
  VertScrollBar.Range = 225
  VertScrollBar.Visible = True
  BorderIcons = [biSystemMenu]
  Caption = ''
  FormStyle = fsStayOnTop
  Scaled = False
  OnCloseQuery = FormCloseQuery
  OnKeyPress = FormKeyPress
  ExplicitWidth = 592
  ExplicitHeight = 358
  PixelsPerInch = 96
  TextHeight = 13
  object memOrder: TCaptionMemo [0]
    Left = 8
    Top = 243
    Width = 537
    Height = 60
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Color = clCream
    Ctl3D = True
    ParentCtl3D = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
    Caption = ''
  end
  object cmdAccept: TButton [1]
    Left = 442
    Top = 194
    Width = 86
    Height = 21
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Accept Order'
    TabOrder = 1
    OnClick = cmdAcceptClick
  end
  object cmdQuit: TButton [2]
    Left = 442
    Top = 221
    Width = 39
    Height = 21
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Cancel = True
    Caption = 'Quit'
    TabOrder = 2
    OnClick = cmdQuitClick
  end
  object pnlMessage: TPanel [3]
    Left = 24
    Top = 176
    Width = 381
    Height = 44
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    BevelInner = bvRaised
    BorderStyle = bsSingle
    TabOrder = 3
    Visible = False
    OnExit = pnlMessageExit
    OnMouseDown = pnlMessageMouseDown
    OnMouseMove = pnlMessageMouseMove
    object imgMessage: TImage
      Left = 4
      Top = 4
      Width = 32
      Height = 32
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      OnMouseUp = memMessageMouseUp
    end
    object memMessage: TRichEdit
      Left = 40
      Top = 4
      Width = 332
      Height = 32
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Color = clInfoBk
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
      WantReturns = False
      Zoom = 100
      OnMouseDown = pnlMessageMouseDown
      OnMouseMove = pnlMessageMouseMove
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = memOrder'
        'Status = stsDefault')
      (
        'Component = cmdAccept'
        'Status = stsDefault')
      (
        'Component = cmdQuit'
        'Status = stsDefault')
      (
        'Component = pnlMessage'
        'Status = stsDefault')
      (
        'Component = memMessage'
        'Status = stsDefault')
      (
        'Component = frmODBase'
        'Status = stsDefault'))
  end
  object tmrBringToFront: TTimer
    Enabled = False
    Interval = 500
    OnTimer = tmrBringToFrontTimer
    Left = 64
    Top = 64
  end
end
