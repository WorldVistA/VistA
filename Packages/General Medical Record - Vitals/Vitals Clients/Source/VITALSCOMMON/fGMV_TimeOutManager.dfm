object frmGMV_TimeOutManager: TfrmGMV_TimeOutManager
  Left = 357
  Top = 263
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  BorderWidth = 15
  Caption = 'Application Time Out Warning!'
  ClientHeight = 113
  ClientWidth = 253
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 64
    Width = 188
    Height = 13
    Caption = 'Seconds until application closes:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblSecondsLeft: TLabel
    Left = 208
    Top = 64
    Width = 15
    Height = 13
    Caption = '15'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblMessage: TLabel
    Left = 0
    Top = 0
    Width = 253
    Height = 57
    Align = alTop
    AutoSize = False
    Caption = 'lblMessage'
    WordWrap = True
  end
  object btnCancelTimeout: TButton
    Left = 80
    Top = 88
    Width = 73
    Height = 25
    Caption = 'Cancel'
    Default = True
    ModalResult = 2
    TabOrder = 0
  end
  object LastChanceTimer: TTimer
    OnTimer = LastChanceTimerTimer
    Top = 80
  end
end
