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
  Font.Charset = ANSI_CHARSET
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnResize = FormResize
  ExplicitWidth = 364
  ExplicitHeight = 357
  PixelsPerInch = 96
  TextHeight = 13
  object lblFontTest: TLabel [0]
    Left = 148
    Top = 208
    Width = 77
    Height = 15
    Caption = 'lblFontTest'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
  end
  object memReport: TRichEdit [1]
    Left = 0
    Top = 0
    Width = 348
    Height = 298
    Align = alClient
    Color = clCream
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
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
  end
  object pnlButton: TPanel [2]
    Left = 0
    Top = 298
    Width = 348
    Height = 21
    Align = alBottom
    Anchors = []
    AutoSize = True
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      348
      21)
    object cmdPrint: TButton
      Left = 189
      Top = 0
      Width = 75
      Height = 21
      Anchors = [akRight]
      Caption = 'Print'
      TabOrder = 0
      OnClick = cmdPrintClick
    end
    object cmdClose: TButton
      Left = 272
      Top = 0
      Width = 75
      Height = 21
      Anchors = [akRight]
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
    Left = 312
    Top = 136
    object mnuCopy: TMenuItem
      Caption = '&Copy'
      ShortCut = 16451
      OnClick = mnuCopyClick
    end
  end
end
