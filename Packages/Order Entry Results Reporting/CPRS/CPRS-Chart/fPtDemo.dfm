inherited frmPtDemo: TfrmPtDemo
  Left = 248
  Top = 283
  BorderIcons = [biSystemMenu]
  Caption = 'Patient Inquiry'
  ClientHeight = 271
  ClientWidth = 580
  Position = poScreenCenter
  ExplicitWidth = 592
  ExplicitWidth = 596
  ExplicitHeight = 309
  PixelsPerInch = 96
  TextHeight = 13
  object lblFontTest: TLabel [0]
    Left = 264
    Top = 148
    Width = 77
    Height = 14
    Caption = 'lblFontTest'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object memPtDemo: TRichEdit [1]
    Left = 0
    Top = 0
    Width = 580
    Height = 240
    Align = alClient
    Color = clCream
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123ABCDEFGHIJKLMNOPQRSTUVWXYZ0123abcd' +
        'efghijklmnopqrs')
    ParentFont = False
    ParentShowHint = False
    PlainText = True
    ReadOnly = True
    ScrollBars = ssBoth
    ShowHint = True
    TabOrder = 0
    WantReturns = False
    WordWrap = False
    OnMouseMove = memPtDemoMouseMove
    ExplicitWidth = 576
    ExplicitTop = 31
    ExplicitHeight = 209
  end
  object pnlTop: TPanel [2]
    Left = 0
    Top = 240
    Width = 580
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 1
    object cmdNewPt: TButton
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 121
      Height = 25
      Align = alLeft
      Caption = 'Select New Patient'
      TabOrder = 0
      OnClick = cmdNewPtClick
    end
    object cmdClose: TButton
      AlignWithMargins = True
      Left = 505
      Top = 3
      Width = 72
      Height = 25
      Align = alRight
      Cancel = True
      Caption = 'Close'
      Default = True
      TabOrder = 1
      OnClick = cmdCloseClick
    end
    object cmdPrint: TButton
      AlignWithMargins = True
      Left = 424
      Top = 3
      Width = 75
      Height = 25
      Align = alRight
      Caption = 'Print'
      TabOrder = 2
      OnClick = cmdPrintClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = memPtDemo'
        'Status = stsDefault')
      (
        'Component = frmPtDemo'
        'Status = stsDefault')
      (
        'Component = pnlTop'
        'Status = stsDefault')
      (
        'Component = cmdNewPt'
        'Status = stsDefault')
      (
        'Component = cmdClose'
        'Status = stsDefault')
      (
        'Component = cmdPrint'
        'Status = stsDefault'))
  end
  object dlgPrintReport: TPrintDialog
    Left = 25
    Top = 61
  end
  object CPPtDemo: TCopyEditMonitor
    CopyMonitor = frmFrame.CPAppMon
    OnCopyToMonitor = CopyToMonitor
    RelatedPackage = '8925'
    TrackOnlyEdits = <
      item
        TrackObject = memPtDemo
      end>
    Left = 24
    Top = 122
  end
end
