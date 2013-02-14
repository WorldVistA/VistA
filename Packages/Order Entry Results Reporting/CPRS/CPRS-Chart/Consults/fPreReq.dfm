inherited frmPrerequisites: TfrmPrerequisites
  Left = 337
  Top = 219
  BorderIcons = [biSystemMenu]
  Caption = 'frmPrerequisites'
  ClientHeight = 319
  ClientWidth = 367
  Font.Charset = ANSI_CHARSET
  OldCreateOrder = True
  Position = poScreenCenter
  OnActivate = OnActivate
  OnClose = FormClose
  OnCreate = FormCreate
  ExplicitWidth = 375
  ExplicitHeight = 346
  PixelsPerInch = 96
  TextHeight = 13
  object lblFontTest: TLabel [0]
    Left = 148
    Top = 208
    Width = 77
    Height = 14
    Caption = 'lblFontTest'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
  end
  object memReport: TRichEdit [1]
    Left = 0
    Top = 33
    Width = 367
    Height = 286
    Align = alClient
    Color = clCream
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      'memReport')
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
    WantReturns = False
    WordWrap = False
  end
  object pnlButton: TPanel [2]
    Left = 0
    Top = 0
    Width = 367
    Height = 33
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      367
      33)
    object cmdContinue: TButton
      Left = 207
      Top = 6
      Width = 75
      Height = 21
      Anchors = [akTop, akRight]
      Caption = 'Continue'
      TabOrder = 0
      OnClick = cmdContinueClick
    end
    object cmdCancel: TButton
      Left = 290
      Top = 6
      Width = 75
      Height = 21
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancel Order'
      TabOrder = 1
      OnClick = cmdCancelClick
    end
  end
  object cmdPrint: TButton [3]
    Left = 2
    Top = 6
    Width = 75
    Height = 21
    Caption = 'Print'
    TabOrder = 1
    OnClick = cmdPrintClick
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
        'Component = cmdContinue'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = cmdPrint'
        'Status = stsDefault')
      (
        'Component = frmPrerequisites'
        'Status = stsDefault'))
  end
  object dlgPrintReport: TPrintDialog
    Left = 113
    Top = 3
  end
end
