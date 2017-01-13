inherited frmODVitals: TfrmODVitals
  Left = 721
  Top = 363
  Caption = 'Vital Measurement Order'
  PixelsPerInch = 96
  TextHeight = 13
  object lblMeasurement: TLabel [0]
    Left = 6
    Top = 8
    Width = 64
    Height = 13
    Caption = 'Measurement'
  end
  object lblSchedule: TLabel [1]
    Left = 144
    Top = 8
    Width = 45
    Height = 13
    Caption = 'Schedule'
  end
  object lblStart: TLabel [2]
    Left = 282
    Top = 8
    Width = 22
    Height = 13
    Caption = 'Start'
  end
  object lblStop: TLabel [3]
    Left = 282
    Top = 50
    Width = 22
    Height = 13
    Caption = 'Stop'
  end
  object lblComment: TLabel [4]
    Left = 6
    Top = 151
    Width = 103
    Height = 13
    Caption = 'Additional Instructions'
  end
  object txtComment: TCaptionEdit [5]
    Left = 6
    Top = 165
    Width = 391
    Height = 21
    TabOrder = 10
    OnChange = ControlChange
    Caption = 'Additional Instructions'
  end
  object cboMeasurement: TORComboBox [9]
    Left = 6
    Top = 21
    Width = 130
    Height = 122
    Style = orcsSimple
    AutoSelect = True
    Caption = 'Measurement'
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 13
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = False
    LongList = False
    LookupPiece = 0
    MaxLength = 0
    Pieces = '2'
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 4
    Text = ''
    OnChange = ControlChange
    CharsNeedMatch = 1
  end
  object cboSchedule: TORComboBox [10]
    Left = 144
    Top = 21
    Width = 130
    Height = 122
    Style = orcsSimple
    AutoSelect = True
    Caption = 'Schedule'
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 13
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = False
    LongList = False
    LookupPiece = 0
    MaxLength = 0
    Pieces = '2'
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 5
    Text = ''
    OnChange = ControlChange
    CharsNeedMatch = 1
  end
  object calStart: TORDateBox [11]
    Left = 282
    Top = 21
    Width = 115
    Height = 21
    TabOrder = 6
    Text = 'Now'
    OnChange = ControlChange
    DateOnly = False
    RequireTime = False
    Caption = 'Start Date'
  end
  object calStop: TORDateBox [12]
    Left = 282
    Top = 64
    Width = 115
    Height = 21
    TabOrder = 7
    OnChange = ControlChange
    DateOnly = False
    RequireTime = False
    Caption = 'Stop Date'
  end
  object grpCallHO: TGroupBox [13]
    Left = 407
    Top = 9
    Width = 107
    Height = 164
    TabOrder = 8
    Visible = False
    object lblBPsys: TLabel
      Left = 8
      Top = 21
      Width = 38
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'BPsys <'
    end
    object lblBPdia: TLabel
      Left = 8
      Top = 50
      Width = 38
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'BPdia >'
    end
    object lblPulseLT: TLabel
      Left = 8
      Top = 79
      Width = 38
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Pulse <'
    end
    object lblPulseGT: TLabel
      Left = 8
      Top = 108
      Width = 38
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Pulse >'
    end
    object lblTemp: TLabel
      Left = 8
      Top = 137
      Width = 38
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Temp >'
    end
    object txtBPsys: TCaptionEdit
      Left = 50
      Top = 18
      Width = 32
      Height = 21
      TabOrder = 0
      Text = '100'
      Caption = 'BPsys <'
    end
    object txtBPDia: TCaptionEdit
      Left = 50
      Top = 47
      Width = 32
      Height = 21
      TabOrder = 1
      Text = '120'
      Caption = 'BPdia >'
    end
    object txtPulseLT: TCaptionEdit
      Left = 50
      Top = 76
      Width = 32
      Height = 21
      TabOrder = 2
      Text = '60'
      Caption = 'Pulse <'
    end
    object txtPulGT: TCaptionEdit
      Left = 50
      Top = 105
      Width = 32
      Height = 21
      TabOrder = 3
      Text = '120'
      Caption = 'Pulse >'
    end
    object txtTemp: TCaptionEdit
      Left = 50
      Top = 134
      Width = 32
      Height = 21
      TabOrder = 4
      Text = '101'
      Caption = 'Temp >'
    end
    object spnBPsys: TUpDown
      Left = 82
      Top = 18
      Width = 15
      Height = 21
      Associate = txtBPsys
      Max = 300
      Position = 100
      TabOrder = 5
    end
    object spnBPdia: TUpDown
      Left = 82
      Top = 47
      Width = 15
      Height = 21
      Associate = txtBPDia
      Max = 300
      Position = 120
      TabOrder = 6
    end
    object spnPulseLT: TUpDown
      Left = 82
      Top = 76
      Width = 15
      Height = 21
      Associate = txtPulseLT
      Max = 500
      Position = 60
      TabOrder = 7
    end
    object spnPulseGT: TUpDown
      Left = 82
      Top = 105
      Width = 15
      Height = 21
      Associate = txtPulGT
      Max = 300
      Position = 120
      TabOrder = 8
    end
    object spnTemp: TUpDown
      Left = 82
      Top = 134
      Width = 15
      Height = 21
      Associate = txtTemp
      Max = 120
      Position = 101
      TabOrder = 9
    end
  end
  object chkCallHO: TCheckBox [14]
    Left = 414
    Top = 8
    Width = 73
    Height = 17
    Caption = 'Call HO on'
    TabOrder = 9
    Visible = False
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = txtComment'
        'Status = stsDefault')
      (
        'Component = cboMeasurement'
        'Status = stsDefault')
      (
        'Component = cboSchedule'
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
        'Component = grpCallHO'
        'Status = stsDefault')
      (
        'Component = txtBPsys'
        'Status = stsDefault')
      (
        'Component = txtBPDia'
        'Status = stsDefault')
      (
        'Component = txtPulseLT'
        'Status = stsDefault')
      (
        'Component = txtPulGT'
        'Status = stsDefault')
      (
        'Component = txtTemp'
        'Status = stsDefault')
      (
        'Component = spnBPsys'
        'Status = stsDefault')
      (
        'Component = spnBPdia'
        'Status = stsDefault')
      (
        'Component = spnPulseLT'
        'Status = stsDefault')
      (
        'Component = spnPulseGT'
        'Status = stsDefault')
      (
        'Component = spnTemp'
        'Status = stsDefault')
      (
        'Component = chkCallHO'
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
        'Component = frmODVitals'
        'Status = stsDefault'))
  end
end
