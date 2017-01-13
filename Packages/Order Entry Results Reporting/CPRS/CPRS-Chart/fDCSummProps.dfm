inherited frmDCSummProperties: TfrmDCSummProperties
  Left = 298
  Top = 186
  BorderIcons = []
  Caption = 'Discharge Summary Properties'
  ClientHeight = 493
  ClientWidth = 525
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  ExplicitWidth = 541
  ExplicitHeight = 531
  PixelsPerInch = 96
  TextHeight = 13
  object bvlConsult: TBevel [0]
    Tag = 1
    Left = 6
    Top = 119
    Width = 483
    Height = 2
  end
  object lblNewTitle: TLabel [1]
    Left = 7
    Top = 15
    Width = 120
    Height = 13
    Alignment = taRightJustify
    Caption = 'Discharge Summary Title:'
  end
  object lblDateTime: TLabel [2]
    Left = 28
    Top = 141
    Width = 99
    Height = 13
    Alignment = taRightJustify
    Caption = 'Dictation Date/Time:'
  end
  object lblAuthor: TLabel [3]
    Left = 51
    Top = 167
    Width = 76
    Height = 13
    Alignment = taRightJustify
    Caption = 'Author/Dictator:'
  end
  object lblCosigner: TLabel [4]
    Left = 31
    Top = 194
    Width = 96
    Height = 13
    Alignment = taRightJustify
    Caption = 'Attending Physician:'
  end
  object cboNewTitle: TORComboBox [5]
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
    Text = ''
    OnChange = cboNewTitleChange
    OnDblClick = cboNewTitleDblClick
    OnDropDownClose = cboNewTitleDropDownClose
    OnEnter = cboNewTitleEnter
    OnExit = cboNewTitleExit
    OnMouseClick = cboNewTitleMouseClick
    OnNeedData = cboNewTitleNeedData
    CharsNeedMatch = 1
  end
  object calSumm: TORDateBox [6]
    Left = 148
    Top = 138
    Width = 140
    Height = 21
    TabOrder = 1
    DateOnly = False
    RequireTime = False
    Caption = 'Dictation Date/Time:'
  end
  object cboAttending: TORComboBox [7]
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
    Text = ''
    OnExit = cboAttendingExit
    OnNeedData = cboAttendingNeedData
    CharsNeedMatch = 1
  end
  object cmdOK: TButton [8]
    Left = 411
    Top = 165
    Width = 72
    Height = 21
    Caption = 'OK'
    Default = True
    TabOrder = 6
    OnClick = cmdOKClick
  end
  object cmdCancel: TButton [9]
    Left = 411
    Top = 190
    Width = 72
    Height = 21
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 7
    OnClick = cmdCancelClick
  end
  object cboAuthor: TORComboBox [10]
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
    Text = ''
    OnEnter = cboAuthorEnter
    OnExit = cboAuthorExit
    OnMouseClick = cboAuthorMouseClick
    OnNeedData = cboAuthorNeedData
    CharsNeedMatch = 1
  end
  object pnlTranscription: TPanel [11]
    Left = 0
    Top = 218
    Width = 530
    Height = 65
    Anchors = [akLeft, akTop, akRight]
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 4
    Visible = False
    ExplicitWidth = 511
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
      Text = ''
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
      Text = ''
      CharsNeedMatch = 1
    end
  end
  object pnlAdmission: TPanel [12]
    Left = 0
    Top = 281
    Width = 525
    Height = 212
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 5
    Visible = False
    ExplicitWidth = 506
    ExplicitHeight = 192
    object lblDCSumm1: TStaticText
      Tag = 1
      AlignWithMargins = True
      Left = 103
      Top = 3
      Width = 419
      Height = 17
      Margins.Left = 103
      Margins.Bottom = 0
      Align = alTop
      Caption = 'This discharge summary must be associated with an admission.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      ExplicitWidth = 400
    end
    object lblDCSumm2: TStaticText
      Tag = 1
      AlignWithMargins = True
      Left = 150
      Top = 20
      Width = 372
      Height = 17
      Margins.Left = 150
      Margins.Top = 0
      Align = alTop
      Caption = 'Select one of the following or press cancel.'
      TabOrder = 1
      ExplicitWidth = 353
    end
    object lstAdmissions: TCaptionListView
      AlignWithMargins = True
      Left = 8
      Top = 43
      Width = 509
      Height = 166
      Margins.Left = 8
      Margins.Right = 8
      Align = alClient
      Columns = <
        item
          Caption = 'Location'
          Width = 30
        end
        item
          Caption = 'Admission Date '
          Tag = 1
          Width = 120
        end
        item
          Caption = 'Type '
          Tag = 2
          Width = 60
        end
        item
          Caption = 'Discharge Summary Status '
          Tag = 3
          Width = 67
        end>
      HideSelection = False
      HoverTime = 0
      IconOptions.WrapText = False
      ReadOnly = True
      RowSelect = True
      ParentShowHint = False
      ShowWorkAreas = True
      ShowHint = True
      TabOrder = 2
      ViewStyle = vsReport
      OnSelectItem = lstAdmissionsSelectItem
      AutoSize = False
      Caption = 'Associated Admission'
      Pieces = '3,5,4,9'
      ExplicitWidth = 490
      ExplicitHeight = 146
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 8
    Top = 8
    Data = (
      (
        'Component = frmDCSummProperties'
        'Status = stsDefault')
      (
        'Component = cboNewTitle'
        'Status = stsDefault')
      (
        'Component = calSumm'
        'Text = Dictation Date/Time. Press the enter key to access.'
        'Status = stsOK')
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
        'Component = cboAuthor'
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
        'Component = pnlAdmission'
        'Status = stsDefault')
      (
        'Component = lblDCSumm1'
        'Status = stsDefault')
      (
        'Component = lblDCSumm2'
        'Status = stsDefault')
      (
        'Component = lstAdmissions'
        'Status = stsDefault'))
  end
end
