inherited frmOptionsPatientSelection: TfrmOptionsPatientSelection
  Left = 345
  Top = 133
  HelpContext = 9060
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Patient Selection Defaults'
  ClientHeight = 501
  ClientWidth = 474
  HelpFile = 'CPRSWT.HLP'
  Position = poScreenCenter
  StyleElements = [seFont, seClient, seBorder]
  ExplicitWidth = 490
  ExplicitHeight = 540
  TextHeight = 13
  object lblClinicDays: TLabel [0]
    Left = 183
    Top = 237
    Width = 101
    Height = 13
    Caption = 'Clinic for day of week'
  end
  object lblMonday: TLabel [1]
    Left = 183
    Top = 268
    Width = 41
    Height = 13
    Caption = 'Monday:'
  end
  object lblTuesday: TLabel [2]
    Left = 183
    Top = 295
    Width = 44
    Height = 13
    Caption = 'Tuesday:'
  end
  object lblWednesday: TLabel [3]
    Left = 183
    Top = 322
    Width = 60
    Height = 13
    Caption = 'Wednesday:'
  end
  object lblThursday: TLabel [4]
    Left = 183
    Top = 349
    Width = 47
    Height = 13
    Caption = 'Thursday:'
  end
  object lblFriday: TLabel [5]
    Left = 183
    Top = 376
    Width = 31
    Height = 13
    Caption = 'Friday:'
  end
  object lblSaturday: TLabel [6]
    Left = 183
    Top = 403
    Width = 45
    Height = 13
    Caption = 'Saturday:'
  end
  object lblSunday: TLabel [7]
    Left = 183
    Top = 430
    Width = 39
    Height = 13
    Caption = 'Sunday:'
  end
  object lblVisitStart: TLabel [8]
    Left = 20
    Top = 402
    Width = 25
    Height = 13
    Alignment = taRightJustify
    Caption = 'Start:'
  end
  object lblVisitStop: TLabel [9]
    Left = 20
    Top = 429
    Width = 25
    Height = 13
    Alignment = taRightJustify
    Caption = 'Stop:'
  end
  object lblWard: TLabel [10]
    Left = 183
    Top = 186
    Width = 29
    Height = 13
    Caption = 'Ward:'
  end
  object lblTeam: TLabel [11]
    Left = 183
    Top = 157
    Width = 51
    Height = 13
    Caption = 'Team/List:'
  end
  object lblTreating: TLabel [12]
    Left = 183
    Top = 130
    Width = 88
    Height = 13
    Caption = 'Treating Specialty:'
  end
  object lblProvider: TLabel [13]
    Left = 183
    Top = 79
    Width = 79
    Height = 13
    Caption = 'Primary Provider:'
  end
  object lblPcmm: TLabel [14]
    Left = 183
    Top = 211
    Width = 65
    Height = 13
    Caption = 'PCMM Team:'
  end
  object Bevel1: TBevel [15]
    AlignWithMargins = True
    Left = 3
    Top = 60
    Width = 468
    Height = 8
    Align = alTop
    Shape = bsTopLine
    ExplicitTop = 63
    ExplicitWidth = 449
  end
  object lblVisitDateRange: TMemo [16]
    Left = 16
    Top = 354
    Width = 153
    Height = 44
    TabStop = False
    BorderStyle = bsNone
    Color = clBtnFace
    Lines.Strings = (
      'Display patients that have '
      'clinic appointments within '
      'this date range.')
    ReadOnly = True
    TabOrder = 2
  end
  object lblInfo: TMemo [17]
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 468
    Height = 51
    TabStop = False
    Align = alTop
    Alignment = taCenter
    BorderStyle = bsNone
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      'The values on the right will be defaults for selecting patients '
      'depending on the list source selected. '
      'Combination uses the criteria defined using Source Combinations.')
    ParentFont = False
    ReadOnly = True
    TabOrder = 20
  end
  object pnlBottom: TPanel [18]
    Left = 0
    Top = 469
    Width = 474
    Height = 32
    HelpContext = 9060
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 17
    object bvlBottom: TBevel
      Left = 0
      Top = 0
      Width = 474
      Height = 2
      Align = alTop
      ExplicitWidth = 414
    end
    object btnOK: TButton
      AlignWithMargins = True
      Left = 307
      Top = 5
      Width = 75
      Height = 24
      HelpContext = 9996
      Align = alRight
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      AlignWithMargins = True
      Left = 388
      Top = 5
      Width = 75
      Height = 24
      HelpContext = 9997
      Margins.Right = 11
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object cboProvider: TORCheckComboBox [19]
    Left = 307
    Top = 76
    Width = 156
    Height = 40
    HelpContext = 9063
    Style = orcsDropDown
    AutoSelect = False
    Caption = 'Primary Provider'
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 13
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = True
    LongList = True
    LookupPiece = 2
    MaxLength = 0
    Pieces = '2,3'
    Sorted = True
    SynonymChars = '<>'
    TabOrder = 5
    Text = ''
    FlatCheckBoxes = False
    OnExit = cboProviderExit
    OnKeyUp = cboProviderKeyUp
    OnNeedData = cboProviderNeedData
    CharsNeedMatch = 1
    MainCheckBoxCaption = 'Include Non-VA Providers'
    MainCheckBoxVisible = True
    MainCheckBoxAlignment = calBottom
    OnMainCheckboxClick = cboProviderMainCheckboxClick
    DropdownStyle = ddsControl
  end
  object cboTreating: TORComboBox [20]
    Left = 307
    Top = 127
    Width = 156
    Height = 21
    HelpContext = 9064
    Style = orcsDropDown
    AutoSelect = True
    Caption = 'Treating Specialty'
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
    Sorted = True
    SynonymChars = '<>'
    TabOrder = 6
    Text = ''
    FlatCheckBoxes = False
    OnExit = cboProviderExit
    OnKeyUp = cboProviderKeyUp
    CharsNeedMatch = 1
  end
  object cboTeam: TORComboBox [21]
    Left = 307
    Top = 154
    Width = 156
    Height = 21
    HelpContext = 9065
    Style = orcsDropDown
    AutoSelect = True
    Caption = 'Team/List'
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
    Sorted = True
    SynonymChars = '<>'
    TabOrder = 7
    Text = ''
    FlatCheckBoxes = False
    OnExit = cboProviderExit
    OnKeyUp = cboProviderKeyUp
    CharsNeedMatch = 1
  end
  object cboWard: TORComboBox [22]
    Left = 307
    Top = 181
    Width = 156
    Height = 21
    HelpContext = 9066
    Style = orcsDropDown
    AutoSelect = True
    Caption = 'Ward'
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
    Sorted = True
    SynonymChars = '<>'
    TabOrder = 8
    Text = ''
    FlatCheckBoxes = False
    OnExit = cboProviderExit
    OnKeyUp = cboProviderKeyUp
    CharsNeedMatch = 1
  end
  object cboMonday: TORComboBox [23]
    Left = 307
    Top = 264
    Width = 156
    Height = 21
    HelpContext = 9067
    Style = orcsDropDown
    AutoSelect = True
    Caption = 'Monday'
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
    Sorted = True
    SynonymChars = '<>'
    TabOrder = 10
    Text = ''
    FlatCheckBoxes = False
    OnExit = cboProviderExit
    OnKeyUp = cboProviderKeyUp
    OnNeedData = cboMondayNeedData
    CharsNeedMatch = 1
  end
  object cboTuesday: TORComboBox [24]
    Left = 307
    Top = 291
    Width = 156
    Height = 21
    HelpContext = 9067
    Style = orcsDropDown
    AutoSelect = True
    Caption = 'Tuesday'
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
    Sorted = True
    SynonymChars = '<>'
    TabOrder = 11
    Text = ''
    FlatCheckBoxes = False
    OnExit = cboProviderExit
    OnKeyUp = cboProviderKeyUp
    OnNeedData = cboMondayNeedData
    CharsNeedMatch = 1
  end
  object cboWednesday: TORComboBox [25]
    Left = 307
    Top = 318
    Width = 156
    Height = 21
    HelpContext = 9067
    Style = orcsDropDown
    AutoSelect = True
    Caption = 'Wednesday'
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
    Sorted = True
    SynonymChars = '<>'
    TabOrder = 12
    Text = ''
    FlatCheckBoxes = False
    OnExit = cboProviderExit
    OnKeyUp = cboProviderKeyUp
    OnNeedData = cboMondayNeedData
    CharsNeedMatch = 1
  end
  object cboThursday: TORComboBox [26]
    Left = 307
    Top = 345
    Width = 156
    Height = 21
    HelpContext = 9067
    Style = orcsDropDown
    AutoSelect = True
    Caption = 'Thursday'
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
    Sorted = True
    SynonymChars = '<>'
    TabOrder = 13
    Text = ''
    FlatCheckBoxes = False
    OnExit = cboProviderExit
    OnKeyUp = cboProviderKeyUp
    OnNeedData = cboMondayNeedData
    CharsNeedMatch = 1
  end
  object cboFriday: TORComboBox [27]
    Left = 307
    Top = 372
    Width = 156
    Height = 21
    HelpContext = 9067
    Style = orcsDropDown
    AutoSelect = True
    Caption = 'Friday'
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
    Sorted = True
    SynonymChars = '<>'
    TabOrder = 14
    Text = ''
    FlatCheckBoxes = False
    OnExit = cboProviderExit
    OnKeyUp = cboProviderKeyUp
    OnNeedData = cboMondayNeedData
    CharsNeedMatch = 1
  end
  object cboSaturday: TORComboBox [28]
    Left = 307
    Top = 399
    Width = 156
    Height = 21
    HelpContext = 9067
    Style = orcsDropDown
    AutoSelect = True
    Caption = 'Saturday'
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
    Sorted = True
    SynonymChars = '<>'
    TabOrder = 15
    Text = ''
    FlatCheckBoxes = False
    OnExit = cboProviderExit
    OnKeyUp = cboProviderKeyUp
    OnNeedData = cboMondayNeedData
    CharsNeedMatch = 1
  end
  object cboSunday: TORComboBox [29]
    Left = 307
    Top = 426
    Width = 156
    Height = 21
    HelpContext = 9067
    Style = orcsDropDown
    AutoSelect = True
    Caption = 'Sunday'
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
    Sorted = True
    SynonymChars = '<>'
    TabOrder = 16
    Text = ''
    FlatCheckBoxes = False
    OnExit = cboProviderExit
    OnKeyUp = cboProviderKeyUp
    OnNeedData = cboMondayNeedData
    CharsNeedMatch = 1
  end
  object txtVisitStart: TCaptionEdit [30]
    Tag = -180
    Left = 49
    Top = 399
    Width = 79
    Height = 21
    HelpContext = 9068
    TabOrder = 3
    Text = '0'
    OnExit = txtVisitStartExit
    OnKeyPress = txtVisitStartKeyPress
    OnKeyUp = txtVisitStartKeyUp
    Caption = 'Start'
  end
  object txtVisitStop: TCaptionEdit [31]
    Tag = 30
    Left = 48
    Top = 426
    Width = 79
    Height = 21
    HelpContext = 9069
    TabOrder = 4
    Text = '0'
    OnExit = txtVisitStopExit
    OnKeyPress = txtVisitStopKeyPress
    OnKeyUp = txtVisitStopKeyUp
    Caption = 'Stop'
  end
  object spnVisitStart: TUpDown [32]
    Tag = -180
    Left = 128
    Top = 399
    Width = 16
    Height = 21
    HelpContext = 9068
    Associate = txtVisitStart
    Min = -999
    Max = 999
    TabOrder = 18
    Thousands = False
    OnClick = spnVisitStartClick
  end
  object spnVisitStop: TUpDown [33]
    Tag = 30
    Left = 127
    Top = 426
    Width = 16
    Height = 21
    HelpContext = 9069
    Associate = txtVisitStop
    Min = -999
    Max = 999
    TabOrder = 19
    Thousands = False
    OnClick = spnVisitStopClick
  end
  object radListSource: TRadioGroup [34]
    Left = 16
    Top = 76
    Width = 145
    Height = 151
    HelpContext = 9061
    Caption = 'List Source '
    ItemIndex = 0
    Items.Strings = (
      'Primary &Provider'
      'Treating &Specialty'
      'Team/&List'
      '&Ward'
      '&Clinic'
      'PC&MM Team'
      'C&ombination')
    TabOrder = 0
    OnClick = radListSourceClick
  end
  object grpSortOrder: TGroupBox [35]
    Left = 16
    Top = 237
    Width = 145
    Height = 113
    HelpContext = 9062
    Caption = 'Sort Order '
    TabOrder = 1
    object radAlphabetical: TRadioButton
      Left = 8
      Top = 15
      Width = 113
      Height = 17
      HelpContext = 9062
      Caption = '&Alphabetical'
      TabOrder = 0
    end
    object radRoomBed: TRadioButton
      Left = 8
      Top = 34
      Width = 113
      Height = 17
      HelpContext = 9062
      Caption = '&Room/Bed'
      TabOrder = 1
    end
    object radAppointmentDate: TRadioButton
      Left = 8
      Top = 53
      Width = 113
      Height = 17
      HelpContext = 9062
      Caption = 'Appointment &Date'
      TabOrder = 2
    end
    object radTerminalDigit: TRadioButton
      Left = 8
      Top = 72
      Width = 113
      Height = 17
      HelpContext = 9062
      Caption = '&Terminal Digit'
      TabOrder = 3
    end
    object radSource: TRadioButton
      Left = 8
      Top = 91
      Width = 113
      Height = 17
      HelpContext = 9062
      Caption = 'So&urce'
      TabOrder = 4
    end
  end
  object cboPCMM: TORComboBox [36]
    Left = 307
    Top = 208
    Width = 156
    Height = 21
    HelpContext = 9065
    Style = orcsDropDown
    AutoSelect = True
    Caption = 'PCMM Team'
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
    Sorted = True
    SynonymChars = '<>'
    TabOrder = 9
    Text = ''
    FlatCheckBoxes = False
    OnExit = cboProviderExit
    OnKeyUp = cboProviderKeyUp
    CharsNeedMatch = 1
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 8
    Top = 8
    Data = (
      (
        'Component = lblVisitDateRange'
        'Status = stsDefault')
      (
        'Component = lblInfo'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = cboProvider'
        'Status = stsDefault')
      (
        'Component = cboTreating'
        'Status = stsDefault')
      (
        'Component = cboTeam'
        'Status = stsDefault')
      (
        'Component = cboWard'
        'Status = stsDefault')
      (
        'Component = cboMonday'
        'Status = stsDefault')
      (
        'Component = cboTuesday'
        'Status = stsDefault')
      (
        'Component = cboWednesday'
        'Status = stsDefault')
      (
        'Component = cboThursday'
        'Status = stsDefault')
      (
        'Component = cboFriday'
        'Status = stsDefault')
      (
        'Component = cboSaturday'
        'Status = stsDefault')
      (
        'Component = cboSunday'
        'Status = stsDefault')
      (
        'Component = txtVisitStart'
        'Status = stsDefault')
      (
        'Component = txtVisitStop'
        'Status = stsDefault')
      (
        'Component = spnVisitStart'
        'Status = stsDefault')
      (
        'Component = spnVisitStop'
        'Status = stsDefault')
      (
        'Component = radListSource'
        'Status = stsDefault')
      (
        'Component = grpSortOrder'
        'Status = stsDefault')
      (
        'Component = radAlphabetical'
        'Status = stsDefault')
      (
        'Component = radRoomBed'
        'Status = stsDefault')
      (
        'Component = radAppointmentDate'
        'Status = stsDefault')
      (
        'Component = radTerminalDigit'
        'Status = stsDefault')
      (
        'Component = radSource'
        'Status = stsDefault')
      (
        'Component = frmOptionsPatientSelection'
        'Status = stsDefault')
      (
        'Component = cboPCMM'
        'Status = stsDefault'))
  end
end
