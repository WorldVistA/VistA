inherited frmODAllergy: TfrmODAllergy
  Tag = 105
  Left = 13
  Top = 106
  Height = 339
  HorzScrollBar.Range = 520
  VertScrollBar.Range = 312
  Caption = 'Enter Allergy Information'
  ExplicitHeight = 339
  PixelsPerInch = 96
  TextHeight = 13
  object btnAgent: TSpeedButton [0]
    Left = 175
    Top = 61
    Width = 19
    Height = 19
    Caption = '...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = btnAgentClick
  end
  object lblReactionType: TOROffsetLabel [1]
    Left = 7
    Top = 81
    Width = 188
    Height = 15
    Caption = 'Type of Reaction:'
    HorzOffset = 2
    Transparent = False
    VertOffset = 2
    WordWrap = False
  end
  object lblAgent: TOROffsetLabel [2]
    Left = 7
    Top = 44
    Width = 188
    Height = 15
    Caption = 'Causative agent:'
    HorzOffset = 2
    Transparent = False
    VertOffset = 2
    WordWrap = False
  end
  object lblSymptoms: TOROffsetLabel [3]
    Left = 7
    Top = 125
    Width = 134
    Height = 15
    Caption = 'Signs/Symptoms'
    HorzOffset = 2
    Transparent = False
    VertOffset = 2
    WordWrap = False
  end
  object lblSelectedSymptoms: TOROffsetLabel [4]
    Left = 147
    Top = 125
    Width = 119
    Height = 15
    Caption = 'Selected Symptoms'
    HorzOffset = 2
    Transparent = False
    VertOffset = 2
    WordWrap = False
  end
  object lblComments: TOROffsetLabel [5]
    Left = 281
    Top = 125
    Width = 226
    Height = 15
    Caption = 'Comments'
    HorzOffset = 2
    Transparent = False
    VertOffset = 2
    WordWrap = False
  end
  object lblOriginator: TOROffsetLabel [6]
    Left = 209
    Top = 6
    Width = 45
    Height = 15
    Caption = 'Observer'
    HorzOffset = 2
    Transparent = False
    VertOffset = 2
    WordWrap = False
  end
  object Bevel1: TBevel [7]
    Left = 2
    Top = 125
    Width = 273
    Height = 125
  end
  object lblObservedDate: TOROffsetLabel [8]
    Left = 366
    Top = 46
    Width = 140
    Height = 15
    Caption = 'Reaction Date/Time'
    HorzOffset = 2
    Transparent = False
    VertOffset = 2
    WordWrap = False
  end
  object lblSeverity: TOROffsetLabel [9]
    Left = 365
    Top = 82
    Width = 141
    Height = 15
    Caption = 'Severity'
    HorzOffset = 2
    Transparent = False
    VertOffset = 2
    WordWrap = False
  end
  object lstAllergy: TORListBox [10]
    Left = 8
    Top = 61
    Width = 166
    Height = 21
    Color = clBtnFace
    ExtendedSelect = False
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnClick = lstAllergyClick
    Caption = 'Causative agent'
    ItemTipColor = clWindow
    LongList = False
    Pieces = '2'
    OnChange = ControlChange
  end
  inherited memOrder: TCaptionMemo
    Left = 5
    Top = 256
    TabOrder = 16
    ExplicitLeft = 5
    ExplicitTop = 256
  end
  inherited cmdAccept: TButton
    Left = 441
    Top = 256
    Caption = 'Accept'
    TabOrder = 13
    ExplicitLeft = 441
    ExplicitTop = 256
  end
  inherited cmdQuit: TButton
    Left = 441
    Top = 283
    TabOrder = 14
    ExplicitLeft = 441
    ExplicitTop = 283
  end
  inherited pnlMessage: TPanel
    Left = 20
    Top = 253
    TabOrder = 15
    ExplicitLeft = 20
    ExplicitTop = 253
    inherited memMessage: TRichEdit
      Left = 41
      ExplicitLeft = 41
    end
  end
  object cboReactionType: TORComboBox [15]
    Left = 7
    Top = 96
    Width = 190
    Height = 21
    Style = orcsDropDown
    AutoSelect = True
    Caption = 'Type of Reaction'
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 13
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = True
    LongList = False
    LookupPiece = 0
    MaxLength = 0
    Pieces = '2'
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 3
    OnChange = ControlChange
    CharsNeedMatch = 1
  end
  object grpObsHist: TRadioGroup [16]
    Left = 364
    Top = 11
    Width = 147
    Height = 30
    Columns = 2
    Ctl3D = True
    Items.Strings = (
      '&Observed'
      '&Historical')
    ParentCtl3D = False
    TabOrder = 9
    OnClick = grpObsHistClick
  end
  object memComments: TRichEdit [17]
    Left = 282
    Top = 142
    Width = 229
    Height = 104
    TabOrder = 12
    WantTabs = True
    OnExit = memCommentsExit
    OnKeyUp = memCommentsKeyUp
  end
  object lstSelectedSymptoms: TORListBox [18]
    Left = 147
    Top = 143
    Width = 122
    Height = 75
    ExtendedSelect = False
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    Caption = 'Selected Symptoms'
    ItemTipColor = clWindow
    LongList = False
    Pieces = '2,4'
    OnChange = ControlChange
  end
  object ckNoKnownAllergies: TCheckBox [19]
    Left = 8
    Top = 18
    Width = 119
    Height = 17
    Caption = 'No Known Allergies'
    TabOrder = 0
    OnClick = ckNoKnownAllergiesClick
  end
  object cboOriginator: TORComboBox [20]
    Left = 210
    Top = 22
    Width = 139
    Height = 96
    Anchors = [akLeft, akTop, akRight]
    Style = orcsSimple
    AutoSelect = True
    Caption = 'Observer'
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 13
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = True
    LongList = True
    LookupPiece = 2
    MaxLength = 0
    ParentShowHint = False
    Pieces = '2,3'
    ShowHint = False
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 8
    OnChange = ControlChange
    OnNeedData = cboOriginatorNeedData
    CharsNeedMatch = 1
  end
  object cboSymptoms: TORComboBox [21]
    Left = 7
    Top = 143
    Width = 135
    Height = 103
    Style = orcsSimple
    AutoSelect = True
    Caption = 'Signs/Symptoms'
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
    TabOrder = 4
    OnKeyDown = cboSymptomsKeyDown
    OnMouseClick = cboSymptomsMouseClick
    OnNeedData = cboSymptomsNeedData
    CharsNeedMatch = 1
  end
  object btnCurrent: TButton [22]
    Left = 137
    Top = 14
    Width = 56
    Height = 21
    Caption = 'Current'
    TabOrder = 1
    OnClick = btnCurrentClick
  end
  object calObservedDate: TORDateBox [23]
    Left = 365
    Top = 62
    Width = 145
    Height = 21
    TabOrder = 10
    OnChange = ControlChange
    DateOnly = False
    RequireTime = False
    Caption = 'Reaction Date/Time'
  end
  object cboSeverity: TORComboBox [24]
    Left = 365
    Top = 97
    Width = 144
    Height = 21
    Style = orcsDropDown
    AutoSelect = True
    Caption = 'Severity'
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 13
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = True
    LongList = False
    LookupPiece = 0
    MaxLength = 0
    Pieces = '2'
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 11
    OnChange = ControlChange
    CharsNeedMatch = 1
  end
  object btnRemove: TButton [25]
    Left = 210
    Top = 224
    Width = 57
    Height = 21
    Caption = 'Remove'
    TabOrder = 7
    OnClick = btnRemoveClick
  end
  object btnDateTime: TButton [26]
    Left = 147
    Top = 224
    Width = 62
    Height = 21
    Caption = 'Date/Time'
    TabOrder = 6
    OnClick = btnDateTimeClick
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = lstAllergy'
        'Status = stsDefault')
      (
        'Component = cboReactionType'
        'Status = stsDefault')
      (
        'Component = grpObsHist'
        'Status = stsDefault')
      (
        'Component = memComments'
        'Status = stsDefault')
      (
        'Component = lstSelectedSymptoms'
        'Status = stsDefault')
      (
        'Component = ckNoKnownAllergies'
        'Status = stsDefault')
      (
        'Component = cboOriginator'
        'Status = stsDefault')
      (
        'Component = cboSymptoms'
        'Status = stsDefault')
      (
        'Component = btnCurrent'
        'Status = stsDefault')
      (
        'Component = calObservedDate'
        'Status = stsDefault')
      (
        'Component = cboSeverity'
        'Status = stsDefault')
      (
        'Component = btnRemove'
        'Status = stsDefault')
      (
        'Component = btnDateTime'
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
        'Component = frmODAllergy'
        'Status = stsDefault'))
  end
  object dlgReactionDateTime: TORDateTimeDlg
    FMDateTime = 2981202.000000000000000000
    DateOnly = False
    RequireTime = False
    Left = 242
    Top = 10
  end
end
