inherited frmODMedIn: TfrmODMedIn
  Left = 220
  Top = 416
  Caption = 'Inpatient Medication Order'
  PixelsPerInch = 96
  TextHeight = 13
  object lblMedication: TLabel [0]
    Left = 6
    Top = 4
    Width = 52
    Height = 13
    Caption = 'Medication'
  end
  object lblDosage: TLabel [1]
    Left = 224
    Top = 4
    Width = 37
    Height = 13
    Caption = 'Dosage'
  end
  object lblRoute: TLabel [2]
    Left = 364
    Top = 4
    Width = 29
    Height = 13
    Caption = 'Route'
  end
  object lblSchedule: TLabel [3]
    Left = 442
    Top = 4
    Width = 45
    Height = 13
    Caption = 'Schedule'
  end
  object Label5: TLabel [4]
    Left = 6
    Top = 45
    Width = 70
    Height = 13
    Caption = 'Dispense Drug'
  end
  object lblComments: TLabel [5]
    Left = 223
    Top = 114
    Width = 49
    Height = 13
    Caption = 'Comments'
  end
  object lblPriority: TLabel [6]
    Left = 442
    Top = 114
    Width = 31
    Height = 13
    Caption = 'Priority'
  end
  object Bevel1: TBevel [7]
    Left = 214
    Top = 0
    Width = 4
    Height = 186
  end
  object lblIndications: TLabel [8]
    Left = 6
    Top = 192
    Width = 54
    Height = 16
    AutoSize = False
    Caption = 'Indication'
  end
  object cboDispense: TORComboBox [9]
    Left = 6
    Top = 59
    Width = 202
    Height = 127
    Style = orcsSimple
    AutoSelect = True
    Caption = ''
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 13
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = False
    LongList = False
    LookupPiece = 0
    MaxLength = 0
    ParentShowHint = False
    Pieces = '2,4,3'
    ShowHint = True
    Sorted = False
    SynonymChars = '<>'
    TabPositions = '30,33'
    TabOrder = 2
    Text = ''
    OnChange = ControlChange
    OnExit = cboDispenseExit
    OnMouseClick = cboDispenseMouseClick
    CharsNeedMatch = 1
  end
  object cboMedication: TORComboBox [10]
    Left = 6
    Top = 21
    Width = 202
    Height = 167
    Style = orcsSimple
    AutoSelect = True
    Caption = ''
    Color = clWindow
    DropDownCount = 11
    ItemHeight = 13
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = False
    LongList = True
    LookupPiece = 0
    MaxLength = 0
    Pieces = '2'
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 1
    Text = ''
    OnChange = ControlChange
    OnExit = cboMedicationSelect
    OnMouseClick = cboMedicationSelect
    OnNeedData = cboMedicationNeedData
    CharsNeedMatch = 1
  end
  inherited memOrder: TCaptionMemo
    TabOrder = 10
  end
  object cboRoute: TORComboBox [12]
    Left = 364
    Top = 18
    Width = 72
    Height = 90
    Style = orcsSimple
    AutoSelect = True
    Caption = ''
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
  object cboSchedule: TORComboBox [13]
    Left = 442
    Top = 18
    Width = 72
    Height = 90
    Style = orcsSimple
    AutoSelect = True
    Caption = ''
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 13
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = False
    LongList = False
    LookupPiece = 0
    MaxLength = 0
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 5
    Text = ''
    OnChange = ControlChange
    CharsNeedMatch = 1
  end
  object memComments: TMemo [14]
    Left = 223
    Top = 128
    Width = 212
    Height = 58
    ScrollBars = ssVertical
    TabOrder = 6
    OnChange = ControlChange
  end
  object cboPriority: TORComboBox [15]
    Left = 442
    Top = 128
    Width = 72
    Height = 58
    Style = orcsSimple
    AutoSelect = True
    Caption = ''
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
    TabOrder = 7
    Text = ''
    OnChange = ControlChange
    CharsNeedMatch = 1
  end
  object txtDosage: TCaptionEdit [16]
    Left = 224
    Top = 18
    Width = 134
    Height = 21
    MaxLength = 20
    TabOrder = 3
    OnChange = ControlChange
    Caption = 'Dosage'
  end
  object cboMedAlt: TORComboBox [17]
    Left = 6
    Top = 18
    Width = 202
    Height = 21
    Style = orcsDropDown
    AutoSelect = True
    Caption = ''
    Color = clWindow
    DropDownCount = 11
    ItemHeight = 13
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = False
    LongList = True
    LookupPiece = 0
    MaxLength = 0
    Pieces = '2'
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 0
    Text = ''
    Visible = False
    OnChange = ControlChange
    OnExit = cboMedicationSelect
    OnMouseClick = cboMedicationSelect
    OnNeedData = cboMedicationNeedData
    CharsNeedMatch = 1
  end
  object cboIndication: TORComboBox [18]
    Left = 6
    Top = 207
    Width = 212
    Height = 21
    Style = orcsDropDown
    AutoSelect = False
    Caption = ''
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 13
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = True
    LongList = False
    LookupPiece = 0
    MaxLength = 0
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 14
    Text = ''
    CharsNeedMatch = 1
  end
  inherited cmdAccept: TButton
    Left = 435
    Top = 250
    TabOrder = 8
    ExplicitLeft = 435
    ExplicitTop = 250
  end
  inherited cmdQuit: TButton
    Left = 435
    Top = 277
    TabOrder = 9
    ExplicitLeft = 435
    ExplicitTop = 277
  end
  inherited pnlMessage: TPanel
    TabOrder = 11
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = cboDispense'
        'Status = stsDefault')
      (
        'Component = cboMedication'
        'Status = stsDefault')
      (
        'Component = cboRoute'
        'Status = stsDefault')
      (
        'Component = cboSchedule'
        'Status = stsDefault')
      (
        'Component = memComments'
        'Status = stsDefault')
      (
        'Component = cboPriority'
        'Status = stsDefault')
      (
        'Component = txtDosage'
        'Status = stsDefault')
      (
        'Component = cboMedAlt'
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
        'Component = frmODMedIn'
        'Status = stsDefault')
      (
        'Component = cboIndication'
        'Text = Indications for use'
        'Status = stsOK'))
  end
end
