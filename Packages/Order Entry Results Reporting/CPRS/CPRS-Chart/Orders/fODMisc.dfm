inherited frmODMisc: TfrmODMisc
  Left = 404
  Top = 453
  Caption = 'Patient Care Order'
  PixelsPerInch = 96
  TextHeight = 13
  object lblStart: TLabel [0]
    Left = 6
    Top = 100
    Width = 76
    Height = 13
    Caption = 'Start Date/Time'
  end
  object lblStop: TLabel [1]
    Left = 158
    Top = 100
    Width = 76
    Height = 13
    Caption = 'Stop Date/Time'
  end
  object lblCare: TLabel [2]
    Left = 6
    Top = 6
    Width = 58
    Height = 13
    Caption = 'Patient Care'
  end
  object lblComment: TLabel [3]
    Left = 6
    Top = 53
    Width = 54
    Height = 13
    Caption = 'Instructions'
  end
  inherited memOrder: TCaptionMemo
    TabStop = False
    TabOrder = 5
  end
  inherited cmdAccept: TButton
    TabOrder = 6
  end
  object cboCare: TORComboBox [6]
    Left = 8
    Top = 25
    Width = 292
    Height = 21
    Style = orcsDropDown
    AutoSelect = True
    Caption = 'Patient Care'
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 13
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = True
    LongList = True
    LookupPiece = 0
    MaxLength = 0
    Pieces = '2'
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 0
    Text = ''
    OnExit = ControlChange
    OnMouseClick = ControlChange
    OnNeedData = cboCareNeedData
    CharsNeedMatch = 1
  end
  object calStart: TORDateBox [7]
    Left = 6
    Top = 114
    Width = 140
    Height = 21
    TabOrder = 3
    Text = 'Now'
    OnChange = ControlChange
    DateOnly = False
    RequireTime = False
    Caption = 'Start Date/Time'
  end
  object calStop: TORDateBox [8]
    Left = 158
    Top = 114
    Width = 140
    Height = 21
    TabOrder = 4
    OnChange = ControlChange
    DateOnly = False
    RequireTime = False
    Caption = 'Stop Date/Time'
  end
  object txtComment: TCaptionEdit [9]
    Left = 6
    Top = 67
    Width = 508
    Height = 21
    TabOrder = 2
    OnChange = ControlChange
    Caption = 'Instructions'
  end
  inherited cmdQuit: TButton
    TabOrder = 7
  end
  inherited pnlMessage: TPanel
    TabOrder = 1
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = cboCare'
        'Status = stsDefault')
      (
        'Component = calStart'
        'Text = Start Date/Time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = calStop'
        'Text = Stop Date/Time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = txtComment'
        'Status = stsDefault')
      (
        'Component = memOrder'
        'Status = stsDefault')
      (
        'Component = cmdAccept'
        'Status = stsDefault')
      (
        'Component = cmdQuit'
        'Status = stsDefault')
      (
        'Component = pnlMessage'
        'Status = stsDefault')
      (
        'Component = memMessage'
        'Status = stsDefault')
      (
        'Component = frmODMisc'
        'Status = stsDefault'))
  end
end
