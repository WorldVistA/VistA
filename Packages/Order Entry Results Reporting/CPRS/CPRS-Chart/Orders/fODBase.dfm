inherited frmODBase: TfrmODBase
  Left = 277
  Top = 179
  Width = 687
  Height = 379
  HorzScrollBar.Range = 625
  HorzScrollBar.Tracking = True
  HorzScrollBar.Visible = True
  VertScrollBar.Range = 281
  VertScrollBar.Visible = True
  BorderIcons = [biSystemMenu]
  Caption = ''
  FormStyle = fsStayOnTop
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  ExplicitWidth = 687
  ExplicitHeight = 379
  PixelsPerInch = 120
  TextHeight = 16
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
    Left = 553
    Top = 243
    Width = 90
    Height = 26
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Accept Order'
    TabOrder = 1
    OnClick = cmdAcceptClick
  end
  object cmdQuit: TButton [2]
    Left = 553
    Top = 276
    Width = 48
    Height = 27
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
    Left = 30
    Top = 220
    Width = 476
    Height = 55
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
      Left = 5
      Top = 5
      Width = 40
      Height = 40
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      OnMouseUp = memMessageMouseUp
    end
    object memMessage: TRichEdit
      Left = 50
      Top = 5
      Width = 415
      Height = 40
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Color = clInfoBk
      Font.Charset = ANSI_CHARSET
      Font.Color = clInfoText
      Font.Height = -15
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
