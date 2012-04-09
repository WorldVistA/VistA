inherited frmDCSummProperties: TfrmDCSummProperties
  Left = 298
  Top = 186
  BorderIcons = []
  Caption = 'Discharge Summary Properties'
  ClientHeight = 437
  ClientWidth = 498
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  ExplicitWidth = 506
  ExplicitHeight = 471
  PixelsPerInch = 96
  TextHeight = 13
  object bvlConsult: TBevel [0]
    Tag = 1
    Left = 6
    Top = 119
    Width = 483
    Height = 2
  end
  object pnlFields: TORAutoPanel [1]
    Left = 0
    Top = 0
    Width = 498
    Height = 218
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblNewTitle: TLabel
      Left = 7
      Top = 15
      Width = 120
      Height = 13
      Alignment = taRightJustify
      Caption = 'Discharge Summary Title:'
    end
    object lblDateTime: TLabel
      Left = 28
      Top = 141
      Width = 99
      Height = 13
      Alignment = taRightJustify
      Caption = 'Dictation Date/Time:'
    end
    object lblAuthor: TLabel
      Left = 51
      Top = 167
      Width = 76
      Height = 13
      Alignment = taRightJustify
      Caption = 'Author/Dictator:'
    end
    object lblCosigner: TLabel
      Left = 31
      Top = 194
      Width = 96
      Height = 13
      Alignment = taRightJustify
      Caption = 'Attending Physician:'
    end
    object cboNewTitle: TORComboBox
      Left = 148
      Top = 11
      Width = 347
      Height = 118
      Style = orcsSimple
      AutoSelect = True
      Caption = 'Discharge Summary Title:'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = True
      LongList = True
      LookupPiece = 0
      MaxLength = 0
      ParentShowHint = False
      Pieces = '2'
      ShowHint = True
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 0
      OnChange = cboNewTitleChange
      OnDblClick = cboNewTitleDblClick
      OnDropDownClose = cboNewTitleDropDownClose
      OnEnter = cboNewTitleEnter
      OnExit = cboNewTitleExit
      OnMouseClick = cboNewTitleMouseClick
      OnNeedData = cboNewTitleNeedData
      CharsNeedMatch = 1
    end
    object calSumm: TORDateBox
      Left = 148
      Top = 138
      Width = 140
      Height = 21
      TabOrder = 1
      DateOnly = False
      RequireTime = False
      Caption = 'Dictation Date/Time:'
    end
    object cboAuthor: TORComboBox
      Left = 148
      Top = 164
      Width = 239
      Height = 21
      Style = orcsDropDown
      AutoSelect = True
      Caption = 'Author/Dictator:'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = False
      LongList = True
      LookupPiece = 2
      MaxLength = 0
      ParentShowHint = False
      Pieces = '2,3'
      ShowHint = True
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 2
      OnEnter = cboAuthorEnter
      OnExit = cboAuthorExit
      OnMouseClick = cboAuthorMouseClick
      OnNeedData = cboAuthorNeedData
      CharsNeedMatch = 1
    end
    object cboAttending: TORComboBox
      Left = 148
      Top = 191
      Width = 239
      Height = 21
      Style = orcsDropDown
      AutoSelect = True
      Caption = 'Attending Physician:'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = False
      LongList = True
      LookupPiece = 2
      MaxLength = 0
      ParentShowHint = False
      Pieces = '2,3'
      ShowHint = True
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 3
      OnExit = cboAttendingExit
      OnNeedData = cboAttendingNeedData
      CharsNeedMatch = 1
    end
    object cmdOK: TButton
      Left = 411
      Top = 165
      Width = 72
      Height = 21
      Caption = 'OK'
      Default = True
      TabOrder = 4
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      Left = 411
      Top = 190
      Width = 72
      Height = 21
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 5
      OnClick = cmdCancelClick
    end
  end
  object pnlTranscription: TORAutoPanel [2]
    Left = 0
    Top = 218
    Width = 498
    Height = 63
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    Visible = False
    object lblTranscriptionist: TLabel
      Left = 53
      Top = 13
      Width = 71
      Height = 13
      Alignment = taRightJustify
      Caption = 'Transcriptionist'
    end
    object lblUrgency: TLabel
      Left = 84
      Top = 38
      Width = 40
      Height = 13
      Alignment = taRightJustify
      Caption = 'Urgency'
    end
    object cboTranscriptionist: TORComboBox
      Left = 148
      Top = 7
      Width = 239
      Height = 21
      Style = orcsDropDown
      AutoSelect = True
      Caption = 'Transcriptionist'
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
      ShowHint = True
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 0
      OnNeedData = cboAuthorNeedData
      CharsNeedMatch = 1
    end
    object cboUrgency: TORComboBox
      Left = 148
      Top = 37
      Width = 121
      Height = 21
      Style = orcsDropDown
      AutoSelect = True
      Caption = 'Urgency'
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
      TabOrder = 1
      CharsNeedMatch = 1
    end
  end
  object pnlAdmissions: TORAutoPanel [3]
    Left = 0
    Top = 327
    Width = 498
    Height = 110
    Align = alClient
    AutoSize = True
    BevelOuter = bvNone
    TabOrder = 2
    Visible = False
    object lstAdmissions: TORListBox
      Left = 0
      Top = 0
      Width = 498
      Height = 110
      Align = alClient
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Caption = 'Associated Admission'
      ItemTipColor = clWindow
      LongList = False
      Pieces = '3,5,4,9'
      TabPositions = '20'
      OnChange = lstAdmissionsChange
    end
  end
  object pnlLabels: TORAutoPanel [4]
    Left = 0
    Top = 281
    Width = 498
    Height = 46
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    TabOrder = 3
    Visible = False
    DesignSize = (
      498
      46)
    object lblLocation: TLabel
      Left = 1
      Top = 33
      Width = 41
      Height = 13
      Caption = 'Location'
    end
    object lblDate: TLabel
      Left = 133
      Top = 33
      Width = 73
      Height = 13
      Caption = 'Admission Date'
    end
    object lblType: TLabel
      Left = 249
      Top = 33
      Width = 24
      Height = 13
      Caption = 'Type'
    end
    object lblSummStatus: TLabel
      Left = 336
      Top = 33
      Width = 127
      Height = 13
      Caption = 'Discharge Summary Status'
    end
    object lblDCSumm1: TStaticText
      Tag = 1
      Left = 81
      Top = 0
      Width = 300
      Height = 17
      Anchors = []
      Caption = 'This discharge summary must be associated with an admission.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object lblDCSumm2: TStaticText
      Tag = 1
      Left = 120
      Top = 14
      Width = 207
      Height = 17
      Anchors = []
      Caption = 'Select one of the following or press cancel.'
      TabOrder = 1
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlFields'
        'Status = stsDefault')
      (
        'Component = cboNewTitle'
        'Status = stsDefault')
      (
        'Component = calSumm'
        'Status = stsDefault')
      (
        'Component = cboAuthor'
        'Status = stsDefault')
      (
        'Component = cboAttending'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = pnlTranscription'
        'Status = stsDefault')
      (
        'Component = cboTranscriptionist'
        'Status = stsDefault')
      (
        'Component = cboUrgency'
        'Status = stsDefault')
      (
        'Component = pnlAdmissions'
        'Status = stsDefault')
      (
        'Component = lstAdmissions'
        'Status = stsDefault')
      (
        'Component = pnlLabels'
        'Status = stsDefault')
      (
        'Component = lblDCSumm1'
        'Status = stsDefault')
      (
        'Component = lblDCSumm2'
        'Status = stsDefault')
      (
        'Component = frmDCSummProperties'
        'Status = stsDefault'))
  end
end
