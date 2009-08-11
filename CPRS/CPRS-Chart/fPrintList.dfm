inherited frmPrintList: TfrmPrintList
  Left = 364
  Top = 191
  Caption = 'Print Selected Items'
  ClientHeight = 361
  ClientWidth = 455
  OnCreate = FormCreate
  ExplicitLeft = 364
  ExplicitTop = 191
  ExplicitWidth = 463
  ExplicitHeight = 388
  PixelsPerInch = 96
  TextHeight = 13
  object lblListName: TLabel [0]
    Left = 16
    Top = 8
    Width = 54
    Height = 13
    Caption = 'lblListName'
  end
  object lbIDParents: TORListBox [1]
    Left = 9
    Top = 22
    Width = 434
    Height = 267
    ItemHeight = 13
    MultiSelect = True
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    TabWidth = 8
    Caption = 'Select a list of notes for printing'
    ItemTipColor = clWindow
    LongList = False
    Pieces = '2'
    TabPositions = '30'
  end
  object cmdOK: TButton [2]
    Left = 131
    Top = 312
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 2
    OnClick = cmdOKClick
  end
  object cmdCancel: TButton [3]
    Left = 237
    Top = 312
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = cmdCancelClick
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = lbIDParents'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = frmPrintList'
        'Status = stsDefault'))
  end
end
