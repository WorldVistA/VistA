inherited frmPtCWAD: TfrmPtCWAD
  Left = 245
  Top = 268
  BorderIcons = [biSystemMenu]
  Caption = 'Patient Postings'
  ClientHeight = 288
  ClientWidth = 508
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyUp = FormKeyUp
  ExplicitWidth = 524
  ExplicitHeight = 326
  PixelsPerInch = 96
  TextHeight = 13
  object lblNotes: TOROffsetLabel [0]
    Left = 0
    Top = 129
    Width = 508
    Height = 24
    Align = alTop
    Caption = 'Crisis Notes, Warning Notes, Directives'
    HorzOffset = 2
    Transparent = False
    VertOffset = 6
    WordWrap = False
    ExplicitLeft = 80
    ExplicitTop = 265
    ExplicitWidth = 435
  end
  object lstNotes: TORListBox [1]
    Left = 0
    Top = 153
    Width = 508
    Height = 108
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
  object pnlBottom: TPanel [2]
    Left = 0
    Top = 261
    Width = 508
    Height = 27
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    DesignSize = (
      508
      27)
    object btnClose: TButton
      Left = 432
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
  object lstAllergies: TCaptionListView [3]
    Left = 0
    Top = 0
    Width = 508
    Height = 129
    Margins.Left = 8
    Margins.Right = 8
    Align = alTop
    Columns = <
      item
        Caption = 'Allergies'
        Width = 180
      end
      item
        Caption = 'Severity'
        Tag = 1
        Width = 100
      end
      item
        Caption = 'Signs / Symptoms'
        Tag = 2
        Width = 160
      end>
    HideSelection = False
    HoverTime = 0
    IconOptions.WrapText = False
    ReadOnly = True
    RowSelect = True
    ParentShowHint = False
    ShowWorkAreas = True
    ShowHint = True
    TabOrder = 0
    ViewStyle = vsReport
    OnClick = lstAllergiesClick
    OnKeyDown = lstAllergiesKeyDown
    Caption = 'Allergies'
    Pieces = '2,3,4'
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
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
        'Status = stsDefault')
      (
        'Component = lstAllergies'
        'Status = stsDefault'))
  end
end
