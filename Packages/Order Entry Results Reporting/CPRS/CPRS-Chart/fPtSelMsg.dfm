inherited frmPtSelMsg: TfrmPtSelMsg
  Left = 375
  Top = 421
  Caption = 'Patient Lookup Messages'
  ClientHeight = 147
  ClientWidth = 367
  FormStyle = fsStayOnTop
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 383
  ExplicitHeight = 185
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel [0]
    Left = 0
    Top = 0
    Width = 367
    Height = 115
    Align = alClient
    Color = clCream
    ParentBackground = False
    ShowCaption = False
    TabOrder = 0
    object memMessages: TRichEdit
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 359
      Height = 107
      Align = alClient
      BevelInner = bvNone
      BorderStyle = bsNone
      Ctl3D = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = True
      ParentCtl3D = False
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
      WantReturns = False
      Zoom = 100
    end
  end
  object pnlButtons: TPanel [1]
    Left = 0
    Top = 115
    Width = 367
    Height = 32
    Align = alBottom
    Alignment = taLeftJustify
    BevelOuter = bvNone
    TabOrder = 1
    object cmdClose: TButton
      AlignWithMargins = True
      Left = 304
      Top = 3
      Width = 60
      Height = 26
      Align = alRight
      Cancel = True
      Caption = 'Close'
      Default = True
      TabOrder = 0
      OnClick = cmdCloseClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = cmdClose'
        'Status = stsDefault')
      (
        'Component = memMessages'
        'Status = stsDefault')
      (
        'Component = frmPtSelMsg'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = pnlButtons'
        'Status = stsDefault'))
  end
  object timClose: TTimer
    OnTimer = timCloseTimer
    Left = 6
    Top = 54
  end
end
