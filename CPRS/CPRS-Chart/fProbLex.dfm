inherited frmPLLex: TfrmPLLex
  Left = 239
  Top = 88
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Problem List  Lexicon Search'
  ClientHeight = 276
  ClientWidth = 427
  Constraints.MinHeight = 200
  Constraints.MinWidth = 433
  OldCreateOrder = True
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  ExplicitWidth = 433
  ExplicitHeight = 308
  DesignSize = (
    427
    276)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 12
    Top = 7
    Width = 101
    Height = 13
    Caption = 'Enter Term to Search'
  end
  object bbCan: TBitBtn [1]
    Left = 232
    Top = 217
    Width = 89
    Height = 21
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    Constraints.MaxHeight = 21
    Constraints.MaxWidth = 89
    TabOrder = 3
    OnClick = bbCanClick
    NumGlyphs = 2
  end
  object bbOK: TBitBtn [2]
    Left = 324
    Top = 217
    Width = 89
    Height = 21
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Constraints.MaxHeight = 21
    Constraints.MaxWidth = 89
    TabOrder = 4
    OnClick = bbOKClick
    NumGlyphs = 2
  end
  object pnlStatus: TPanel [3]
    Left = 0
    Top = 247
    Width = 427
    Height = 29
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 5
    DesignSize = (
      427
      29)
    object Bevel1: TBevel
      Left = 4
      Top = 4
      Width = 419
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      ExplicitWidth = 417
    end
    object lblstatus: TVA508StaticText
      Name = 'lblstatus'
      Left = 16
      Top = 8
      Width = 3
      Height = 13
      Alignment = taLeftJustify
      TabOrder = 0
      ShowAccelChar = True
    end
  end
  object ebLex: TCaptionEdit [4]
    Left = 12
    Top = 27
    Width = 323
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    Constraints.MaxHeight = 21
    TabOrder = 0
    OnKeyPress = ebLexKeyPress
    Caption = 'Enter Term to Search'
  end
  object lbLex: TORListBox [5]
    Left = 12
    Top = 63
    Width = 403
    Height = 145
    Anchors = [akLeft, akTop, akRight, akBottom]
    ExtendedSelect = False
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnClick = lbLexClick
    Caption = 'Problem List'
    ItemTipColor = clWindow
    LongList = False
    Pieces = '2'
  end
  object bbSearch: TBitBtn [6]
    Left = 342
    Top = 27
    Width = 73
    Height = 21
    Anchors = [akTop, akRight]
    Caption = '&Search'
    Constraints.MaxHeight = 21
    Constraints.MaxWidth = 73
    TabOrder = 1
    OnClick = bbSearchClick
    NumGlyphs = 2
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = bbCan'
        'Status = stsDefault')
      (
        'Component = bbOK'
        'Status = stsDefault')
      (
        'Component = pnlStatus'
        'Status = stsDefault')
      (
        'Component = ebLex'
        'Status = stsDefault')
      (
        'Component = lbLex'
        'Status = stsDefault')
      (
        'Component = bbSearch'
        'Status = stsDefault')
      (
        'Component = frmPLLex'
        'Status = stsDefault'))
  end
end
