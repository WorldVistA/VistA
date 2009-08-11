inherited frmPLLex: TfrmPLLex
  Left = 239
  Top = 88
  Caption = 'Problem List  Lexicon Search'
  ClientHeight = 274
  ClientWidth = 425
  Constraints.MinHeight = 200
  Constraints.MinWidth = 433
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    425
    274)
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
    Left = 230
    Top = 215
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
    Left = 322
    Top = 215
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
  object Panel1: TPanel [3]
    Left = 0
    Top = 245
    Width = 425
    Height = 29
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 5
    DesignSize = (
      425
      29)
    object Bevel1: TBevel
      Left = 4
      Top = 4
      Width = 417
      Height = 21
      Anchors = [akLeft, akTop, akRight]
    end
    object lblstatus: TLabel
      Left = 16
      Top = 8
      Width = 3
      Height = 13
    end
  end
  object ebLex: TCaptionEdit [4]
    Left = 12
    Top = 27
    Width = 321
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
    Width = 401
    Height = 143
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
    Left = 340
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
        'Component = Panel1'
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
