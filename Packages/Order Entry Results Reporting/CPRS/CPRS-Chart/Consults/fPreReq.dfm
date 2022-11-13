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
  ExplicitWidth = 383
  ExplicitHeight = 357
  PixelsPerInch = 96
  TextHeight = 16
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
    TabOrder = 1
    WantReturns = False
    WordWrap = False
    Zoom = 100
  end
  object pnlButton: TPanel [2]
    Left = 0
    Top = 0
    Width = 367
    Height = 33
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitTop = -6
    object cmdContinue: TButton
      AlignWithMargins = True
      Left = 183
      Top = 3
      Width = 75
      Height = 27
      Align = alRight
      Caption = 'Continue'
      TabOrder = 1
      OnClick = cmdContinueClick
    end
    object cmdCancel: TButton
      AlignWithMargins = True
      Left = 264
      Top = 3
      Width = 100
      Height = 27
      Align = alRight
      Cancel = True
      Caption = 'Cancel Order'
      TabOrder = 2
      OnClick = cmdCancelClick
    end
    object cmdPrint: TButton
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 75
      Height = 27
      Align = alLeft
      Caption = 'Print'
      TabOrder = 0
      OnClick = cmdPrintClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 184
    Top = 48
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
    Left = 281
    Top = 51
  end
end
