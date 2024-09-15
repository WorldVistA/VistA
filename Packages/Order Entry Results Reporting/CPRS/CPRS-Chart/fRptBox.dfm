inherited frmReportBox: TfrmReportBox
  Left = 512
  Top = 214
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Anchors = []
  BorderIcons = [biSystemMenu]
  Caption = 'frmReportBox'
  ClientHeight = 319
  ClientWidth = 348
  Constraints.MinHeight = 200
  Constraints.MinWidth = 350
  DoubleBuffered = True
  Font.Charset = ANSI_CHARSET
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnResize = FormResize
  OldCreateOrder = True
  ExplicitHeight = 346
  PixelsPerInch = 96
  TextHeight = 16
  object memReport: TRichEdit [0]
    Left = 0
    Top = 0
    Width = 348
    Height = 287
    Align = alClient
    Color = clCream
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    HideScrollBars = False
    Lines.Strings = (
      'memReport')
    ParentFont = False
    PlainText = True
    PopupMenu = pmnu
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
    WantReturns = False
    WordWrap = False
    Zoom = 100
  end
  object pnlButton: TPanel [1]
    Left = 0
    Top = 287
    Width = 348
    Height = 32
    Align = alBottom
    Anchors = []
    BevelOuter = bvNone
    TabOrder = 1
    object cmdPrint: TButton
      AlignWithMargins = True
      Left = 189
      Top = 3
      Width = 75
      Height = 26
      Align = alRight
      Caption = 'Print'
      TabOrder = 0
      OnClick = cmdPrintClick
    end
    object cmdClose: TButton
      AlignWithMargins = True
      Left = 270
      Top = 3
      Width = 75
      Height = 26
      Align = alRight
      Cancel = True
      Caption = 'Close'
      Default = True
      TabOrder = 1
      OnClick = cmdCloseClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = memReport'
        'Status = stsDefault')
      (
        'Component = pnlButton'
        'Status = stsDefault')
      (
        'Component = cmdPrint'
        'Status = stsDefault')
      (
        'Component = cmdClose'
        'Status = stsDefault')
      (
        'Component = frmReportBox'
        'Status = stsDefault'))
  end
  object dlgPrintReport: TPrintDialog
    Left = 318
    Top = 41
  end
  object pmnu: TPopupMenu
    AutoPopup = False
    Left = 216
    Top = 24
    object mnuCopy: TMenuItem
      Caption = '&Copy'
      ShortCut = 16451
      OnClick = mnuCopyClick
    end
  end
  object CPRptBox: TCopyEditMonitor
    CopyMonitor = frmFrame.CPAppMon
    OnCopyToMonitor = CPRptBoxCopyToMonitor
    TrackOnlyEdits = <
      item
        TrackObject = memReport
      end>
    Left = 312
    Top = 96
  end
end
