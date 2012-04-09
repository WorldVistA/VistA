inherited frmPtCWAD: TfrmPtCWAD
  Left = 245
  Top = 268
  BorderIcons = [biSystemMenu]
  Caption = 'Patient Postings'
  ClientHeight = 275
  ClientWidth = 435
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyUp = FormKeyUp
  ExplicitWidth = 443
  ExplicitHeight = 302
  PixelsPerInch = 96
  TextHeight = 13
  object lblNotes: TOROffsetLabel [0]
    Left = 0
    Top = 127
    Width = 435
    Height = 24
    Align = alTop
    Caption = 'Crisis Notes, Warning Notes, Directives'
    HorzOffset = 2
    Transparent = False
    VertOffset = 6
    WordWrap = False
  end
  object lblAllergies: TOROffsetLabel [1]
    Left = 0
    Top = 0
    Width = 435
    Height = 21
    Align = alTop
    Caption = 
      'Allergies                                               Severity' +
      '                 Signs / Symptoms'
    HorzOffset = 2
    Transparent = False
    VertOffset = 6
    WordWrap = False
  end
  object lstAllergies: TORListBox [2]
    Left = 0
    Top = 21
    Width = 435
    Height = 106
    Align = alTop
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnClick = lstAllergiesClick
    Caption = 'Allergies'
    ItemTipColor = clWindow
    LongList = False
    Pieces = '2,3,4'
    TabPositions = '30,45'
  end
  object lstNotes: TORListBox [3]
    Left = 0
    Top = 151
    Width = 435
    Height = 97
    Align = alClient
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnClick = lstNotesClick
    Caption = 'Crisis Notes, Warning Notes, Directives'
    ItemTipColor = clWindow
    LongList = False
    Pieces = '2,3'
    TabPositions = '20'
  end
  object pnlBottom: TPanel [4]
    Left = 0
    Top = 248
    Width = 435
    Height = 27
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 4
    DesignSize = (
      435
      27)
    object btnClose: TButton
      Left = 359
      Top = 4
      Width = 75
      Height = 21
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Close'
      TabOrder = 0
      OnClick = btnCloseClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = lstAllergies'
        'Status = stsDefault')
      (
        'Component = lstNotes'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = btnClose'
        'Status = stsDefault')
      (
        'Component = frmPtCWAD'
        'Status = stsDefault'))
  end
end
