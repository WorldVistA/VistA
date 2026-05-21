inherited frmDCSummProperties: TfrmDCSummProperties
  AlignWithMargins = True
  Left = 298
  Top = 186
  BorderIcons = []
  Caption = 'Discharge Summary Properties'
  ClientHeight = 548
  ClientWidth = 703
  Constraints.MinHeight = 478
  Constraints.MinWidth = 491
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnResize = FormResize
  ExplicitWidth = 715
  ExplicitHeight = 586
  TextHeight = 13
  object pnlSummaryTitle: TGridPanel [0]
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 697
    Height = 330
    Align = alClient
    BevelOuter = bvNone
    Caption = 'pnlSummaryTitle'
    ColumnCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 128.000000000000000000
      end
      item
        Value = 50.000000000000000000
      end
      item
        Value = 50.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 104.000000000000000000
      end>
    Constraints.MinHeight = 300
    ControlCollection = <
      item
        Column = 3
        Control = cmdOK
        Row = 0
      end
      item
        Column = 3
        Control = cmdCancel
        Row = 1
        RowSpan = 4
      end
      item
        Column = 0
        Control = lblDateTime
        Row = 2
      end
      item
        Column = 0
        Control = lblAuthor
        Row = 3
      end
      item
        Column = 1
        ColumnSpan = 2
        Control = cboAuthor
        Row = 3
      end
      item
        Column = 0
        Control = lblAttending
        Row = 4
      end
      item
        Column = 1
        ColumnSpan = 2
        Control = cboAttending
        Row = 4
      end
      item
        Column = 1
        ColumnSpan = 2
        Control = cboNewTitle
        Row = 0
        RowSpan = 2
      end
      item
        Column = 0
        Control = lblNewTitle
        Row = 0
      end
      item
        Column = 1
        Control = calSumm
        Row = 2
      end
      item
        Column = 2
        Row = 1
      end>
    Locked = True
    RowCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 40.000000000000000000
      end
      item
        Value = 100.000000000000000000
      end
      item
        SizeStyle = ssAuto
        Value = 40.000000000000000000
      end
      item
        SizeStyle = ssAuto
        Value = 40.000000000000000000
      end
      item
        SizeStyle = ssAuto
        Value = 40.000000000000000000
      end>
    ShowCaption = False
    TabOrder = 0
    ExplicitLeft = -2
    ExplicitTop = 1
    object cmdOK: TButton
      AlignWithMargins = True
      Left = 596
      Top = 3
      Width = 98
      Height = 24
      Align = alTop
      Caption = '&OK'
      Constraints.MinHeight = 24
      ModalResult = 1
      TabOrder = 4
    end
    object cmdCancel: TButton
      AlignWithMargins = True
      Left = 596
      Top = 43
      Width = 98
      Height = 26
      Align = alTop
      Cancel = True
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 5
    end
    object lblDateTime: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 207
      Width = 122
      Height = 26
      Align = alTop
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Dictation Date/Time:'
      Layout = tlCenter
      ExplicitTop = 183
      ExplicitHeight = 13
    end
    object lblAuthor: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 239
      Width = 122
      Height = 23
      Align = alTop
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Author/Dictator:'
      Layout = tlCenter
      ExplicitTop = 223
      ExplicitHeight = 13
    end
    object cboAuthor: TORCheckComboBox
      AlignWithMargins = True
      Left = 131
      Top = 241
      Width = 459
      Height = 21
      Margins.Top = 5
      Margins.Bottom = 5
      Style = orcsDropDown
      Align = alTop
      AutoSelect = True
      Caption = 'Author'
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
      OnMouseClick = cboAuthorMouseClick
      OnNeedData = cboAuthorNeedData
      CharsNeedMatch = 1
      UniqueAutoComplete = True
      MainCheckBoxCaption = 'Include Non-VA Providers'
      MainCheckBoxVisible = True
      MainCheckBoxAlignment = calRight
      OnMainCheckboxClick = cboAuthorMainCheckboxClick
      DropdownStyle = ddsControl
      ExplicitTop = 212
      ExplicitWidth = 455
    end
    object lblAttending: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 270
      Width = 122
      Height = 24
      Align = alTop
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Attending Physician:'
      Layout = tlCenter
      ExplicitTop = 263
      ExplicitHeight = 13
    end
    object cboAttending: TORCheckComboBox
      AlignWithMargins = True
      Left = 131
      Top = 272
      Width = 459
      Height = 21
      Margins.Top = 5
      Margins.Bottom = 5
      Style = orcsDropDown
      Align = alTop
      AutoSelect = True
      Caption = 'Expected Cosigner:'
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
      OnNeedData = cboAttendingNeedData
      CharsNeedMatch = 1
      UniqueAutoComplete = True
      MainCheckBoxCaption = 'Include Non-VA Providers'
      MainCheckBoxVisible = True
      MainCheckBoxAlignment = calRight
      OnMainCheckboxClick = cboAttendingMainCheckboxClick
      DropdownStyle = ddsControl
      ExplicitTop = 252
      ExplicitWidth = 455
      ExplicitHeight = 30
    end
    object cboNewTitle: TORComboBox
      AlignWithMargins = True
      Left = 131
      Top = 3
      Width = 454
      Height = 198
      Margins.Right = 8
      Style = orcsSimple
      Align = alClient
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
      ExplicitWidth = 450
      ExplicitHeight = 161
    end
    object lblNewTitle: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 122
      Height = 13
      Align = alTop
      Alignment = taRightJustify
      Caption = 'Discharge Summary Title:'
      ExplicitLeft = 5
      ExplicitWidth = 120
    end
    object calSumm: TORDateBox
      AlignWithMargins = True
      Left = 131
      Top = 210
      Width = 226
      Height = 21
      Margins.Top = 6
      Margins.Bottom = 5
      Align = alTop
      AutoSize = False
      TabOrder = 1
      DateOnly = False
      RequireTime = False
      Caption = 'Dictation Date/Time:'
    end
  end
  object pnlTranscription: TPanel [1]
    Left = 0
    Top = 483
    Width = 703
    Height = 65
    Align = alBottom
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 1
    Visible = False
    ExplicitTop = 472
    ExplicitWidth = 699
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
      CharsNeedMatch = 1
    end
    object cboUrgency: TORComboBox
      Left = 148
      Top = 37
      Width = 140
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
  object pnlAdmission: TPanel [2]
    Left = 0
    Top = 304
    Width = 703
    Height = 179
    Margins.Top = 6
    Align = alBottom
    BevelOuter = bvNone
    Constraints.MinHeight = 179
    Constraints.MinWidth = 472
    ParentBackground = False
    TabOrder = 2
    Visible = False
    ExplicitTop = 293
    ExplicitWidth = 699
    object Bevel1: TBevel
      Tag = 1
      AlignWithMargins = True
      Left = 8
      Top = 3
      Width = 687
      Height = 2
      Margins.Left = 8
      Margins.Right = 8
      Align = alTop
      ExplicitLeft = 29
      ExplicitTop = 0
      ExplicitWidth = 614
    end
    object lstAdmissions: TCaptionListView
      AlignWithMargins = True
      Left = 8
      Top = 45
      Width = 687
      Height = 128
      Margins.Left = 8
      Margins.Right = 8
      Margins.Bottom = 6
      Align = alClient
      Columns = <
        item
          Caption = 'Location'
          Width = 64
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
          Width = 120
        end>
      HideSelection = False
      HoverTime = 0
      IconOptions.WrapText = False
      ReadOnly = True
      RowSelect = True
      ParentShowHint = False
      ShowWorkAreas = True
      ShowHint = True
      TabOrder = 0
      ViewStyle = vsReport
      OnSelectItem = lstAdmissionsSelectItem
      AutoSize = True
      Caption = 'Associated Admission'
      Pieces = '3,5,4,9'
      ExplicitWidth = 683
    end
    object lblDCSumm1: TStaticText
      Tag = 1
      Left = 0
      Top = 25
      Width = 703
      Height = 17
      Margins.Left = 103
      Margins.Top = 6
      Margins.Bottom = 0
      Align = alTop
      Alignment = taCenter
      Caption = 'This discharge summary must be associated with an admission.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      ExplicitWidth = 699
    end
    object lblDCSumm2: TStaticText
      Tag = 1
      Left = 0
      Top = 8
      Width = 703
      Height = 17
      Margins.Left = 150
      Margins.Top = 0
      Align = alTop
      Alignment = taCenter
      Caption = 'Select one of the following or press cancel.'
      TabOrder = 2
      ExplicitLeft = 3
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 40
    Top = 312
    Data = (
      (
        'Component = frmDCSummProperties'
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
        'Component = lstAdmissions'
        'Status = stsDefault'
        'Columns'
        ())
      (
        'Component = lblDCSumm1'
        'Status = stsDefault')
      (
        'Component = lblDCSumm2'
        'Status = stsDefault')
      (
        'Component = pnlSummaryTitle'
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
        'Component = cboAttending'
        'Status = stsDefault')
      (
        'Component = cboNewTitle'
        'Status = stsDefault')
      (
        'Component = calSumm'
        'Status = stsDefault'))
  end
end
