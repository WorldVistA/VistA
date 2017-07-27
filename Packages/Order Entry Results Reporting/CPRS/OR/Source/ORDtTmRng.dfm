object ORfrmDateRange: TORfrmDateRange
  Left = 103
  Top = 587
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Date Range'
  ClientHeight = 132
  ClientWidth = 274
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lblStart: TLabel
    Left = 8
    Top = 44
    Width = 52
    Height = 13
    Caption = 'Begin Date'
  end
  object lblStop: TLabel
    Left = 145
    Top = 44
    Width = 44
    Height = 13
    Caption = 'End Date'
  end
  object lblInstruct: TLabel
    Left = 8
    Top = 8
    Width = 258
    Height = 29
    AutoSize = False
    Caption = 'Select a date range -'
    WordWrap = True
  end
  object cmdOK: TButton
    Left = 114
    Top = 103
    Width = 72
    Height = 21
    Caption = 'OK'
    Default = True
    TabOrder = 0
    OnClick = cmdOKClick
  end
  object cmdCancel: TButton
    Left = 194
    Top = 103
    Width = 72
    Height = 21
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = cmdCancelClick
  end
  object VA508Man: TVA508AccessibilityManager
    Left = 16
    Top = 72
    Data = (
      (
        'Component = ORfrmDateRange'
        'Status = stsDefault'))
  end
end
