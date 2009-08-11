inherited frmNoteIDParents: TfrmNoteIDParents
  Left = 387
  Top = 203
  Caption = 'Attach to Interdisciplinary Note'
  ClientHeight = 338
  ClientWidth = 446
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitWidth = 454
  ExplicitHeight = 365
  PixelsPerInch = 96
  TextHeight = 13
  object lblSelectParent: TLabel [0]
    Left = 5
    Top = 12
    Width = 123
    Height = 13
    Caption = 'Select a note to attach to:'
  end
  object cmdOK: TButton [1]
    Left = 147
    Top = 306
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 1
    OnClick = cmdOKClick
  end
  object cmdCancel: TButton [2]
    Left = 237
    Top = 306
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = cmdCancelClick
  end
  object lstIDParents: TORListBox [3]
    Left = 5
    Top = 31
    Width = 434
    Height = 267
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    TabWidth = 8
    Caption = 'Select a note to attach to:'
    ItemTipColor = clWindow
    LongList = False
    Pieces = '2'
    TabPositions = '30'
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = lstIDParents'
        'Status = stsDefault')
      (
        'Component = frmNoteIDParents'
        'Status = stsDefault'))
  end
end
