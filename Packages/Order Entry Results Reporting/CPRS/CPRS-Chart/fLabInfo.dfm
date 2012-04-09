inherited frmLabInfo: TfrmLabInfo
  Left = 276
  Top = 256
  Caption = 'Lab Test Description'
  ClientHeight = 277
  ClientWidth = 583
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitWidth = 320
  ExplicitHeight = 240
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel [0]
    Left = 0
    Top = 244
    Width = 583
    Height = 33
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      583
      33)
    object btnOK: TButton
      Left = 487
      Top = 5
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Close'
      TabOrder = 0
      OnClick = btnOKClick
    end
  end
  object memInfo: TCaptionMemo [1]
    Left = 160
    Top = 0
    Width = 423
    Height = 244
    Hint = 'Laboratory Test Descriptions'
    Align = alClient
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
    Caption = 'Laboratory Test Descriptions'
    ExplicitTop = -1
  end
  object cboTests: TORComboBox [2]
    Left = 0
    Top = 0
    Width = 160
    Height = 244
    Hint = 'Select a test to view information'
    Style = orcsSimple
    Align = alLeft
    AutoSelect = True
    Caption = 'Lab Tests'
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 13
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = False
    LongList = True
    LookupPiece = 0
    MaxLength = 0
    ParentShowHint = False
    Pieces = '2'
    ShowHint = True
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 0
    OnClick = cboTestsClick
    OnNeedData = cboTestsNeedData
    CharsNeedMatch = 1
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = memInfo'
        'Status = stsDefault')
      (
        'Component = cboTests'
        'Status = stsDefault')
      (
        'Component = frmLabInfo'
        'Status = stsDefault'))
  end
end
