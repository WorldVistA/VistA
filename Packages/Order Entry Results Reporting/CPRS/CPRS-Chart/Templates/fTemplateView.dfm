inherited frmTemplateView: TfrmTemplateView
  Left = 257
  Top = 105
  Caption = 'View Template'
  ClientHeight = 343
  ClientWidth = 568
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 576
  ExplicitHeight = 370
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBottom: TPanel [0]
    Left = 0
    Top = 313
    Width = 568
    Height = 30
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      568
      30)
    object btnClose: TButton
      Left = 492
      Top = 6
      Width = 75
      Height = 21
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Close'
      Default = True
      TabOrder = 2
      OnClick = btnCloseClick
    end
    object cbStayOnTop: TCheckBox
      Left = 0
      Top = 8
      Width = 77
      Height = 17
      Caption = 'Stay on Top'
      TabOrder = 0
      OnClick = cbStayOnTopClick
    end
    object btnPrint: TButton
      Left = 412
      Top = 6
      Width = 75
      Height = 21
      Anchors = [akTop, akRight]
      Caption = 'Print'
      TabOrder = 1
      OnClick = btnPrintClick
    end
  end
  object reMain: TRichEdit [1]
    Left = 0
    Top = 0
    Width = 568
    Height = 313
    Align = alClient
    Color = clCream
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    HideSelection = False
    ParentFont = False
    PopupMenu = popView
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
    WantReturns = False
    WordWrap = False
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = btnClose'
        'Status = stsDefault')
      (
        'Component = cbStayOnTop'
        'Status = stsDefault')
      (
        'Component = btnPrint'
        'Status = stsDefault')
      (
        'Component = reMain'
        'Status = stsDefault')
      (
        'Component = frmTemplateView'
        'Status = stsDefault'))
  end
  object popView: TPopupMenu
    OnPopup = popViewPopup
    Left = 24
    Top = 24
    object Copy1: TMenuItem
      Caption = '&Copy'
      ShortCut = 16451
      OnClick = Copy1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object SelectAll1: TMenuItem
      Caption = 'Select &All'
      ShortCut = 16449
      OnClick = SelectAll1Click
    end
  end
end
