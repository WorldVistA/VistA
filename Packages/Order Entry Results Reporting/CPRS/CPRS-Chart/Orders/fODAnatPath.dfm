inherited frmODAnatPath: TfrmODAnatPath
  Tag = 121
  Left = 245
  Top = 263
  Width = 800
  Height = 724
  ActiveControl = cbxAvailTest
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Anatomic Pathology Ordering'
  Constraints.MinHeight = 600
  Constraints.MinWidth = 800
  ExplicitWidth = 800
  ExplicitHeight = 724
  PixelsPerInch = 96
  TextHeight = 13
  object gpMain: TGridPanel [0]
    Left = 0
    Top = 0
    Width = 784
    Height = 685
    Align = alClient
    ColumnCollection = <
      item
        Value = 28.000000000000000000
      end
      item
        Value = 18.000000000000000000
      end
      item
        Value = 18.000000000000000000
      end
      item
        Value = 18.000000000000000000
      end
      item
        Value = 18.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        ColumnSpan = 5
        Control = pgctrlText
        Row = 13
      end
      item
        Column = 0
        Control = lvwSpecimen
        Row = 11
        RowSpan = 2
      end
      item
        Column = 1
        ColumnSpan = 4
        Control = pgctrlSpecimen
        Row = 11
      end
      item
        Column = 0
        ColumnSpan = 5
        Control = lblAvailTest
        Row = 0
      end
      item
        Column = 0
        Control = cbxAvailTest
        Row = 1
        RowSpan = 9
      end
      item
        Column = 1
        Control = lblUrgency
        Row = 1
      end
      item
        Column = 1
        Control = cbxUrgency
        Row = 2
      end
      item
        Column = 2
        Control = lblORDateBox
        Row = 1
      end
      item
        Column = 2
        Control = calCollTime
        Row = 2
      end
      item
        Column = 3
        Control = lblSubmittedBy
        Row = 1
      end
      item
        Column = 3
        Control = edtSubmittedBy
        Row = 2
      end
      item
        Column = 4
        Control = lblEmpry
        Row = 1
        RowSpan = 2
      end
      item
        Column = 1
        Control = lblCollectionType
        Row = 3
      end
      item
        Column = 1
        Control = cbxCollType
        Row = 4
      end
      item
        Column = 3
        Control = lblHowLong
        Row = 3
      end
      item
        Column = 3
        Control = edtDays
        Row = 4
      end
      item
        Column = 2
        Control = lblOften
        Row = 3
      end
      item
        Column = 2
        Control = cbxFrequency
        Row = 4
      end
      item
        Column = 4
        Control = lblSurgeon
        Row = 3
      end
      item
        Column = 4
        Control = cbxPtProvider
        Row = 4
      end
      item
        Column = 1
        ColumnSpan = 4
        Control = pnlAntiCoagulation
        Row = 5
      end
      item
        Column = 1
        ColumnSpan = 4
        Control = pnlDoseDraw
        Row = 6
      end
      item
        Column = 1
        ColumnSpan = 4
        Control = pnlOrderComment
        Row = 7
      end
      item
        Column = 1
        ColumnSpan = 4
        Control = pnlPeakTrough
        Row = 8
      end
      item
        Column = 1
        ColumnSpan = 4
        Control = pnlUrineVolume
        Row = 9
      end
      item
        Column = 0
        Control = pnlTabs
        Row = 10
      end
      item
        Column = 1
        ColumnSpan = 4
        Control = pnlTotal
        Row = 10
      end
      item
        Column = 1
        ColumnSpan = 4
        Control = pnlSpecMessage
        Row = 12
      end>
    RowCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 13.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 21.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 21.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 21.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 21.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 29.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 29.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 29.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 29.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 29.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 21.000000000000000000
      end
      item
        Value = 25.000000000000000000
      end
      item
        Value = 25.000000000000000000
      end
      item
        Value = 50.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 29.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 29.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 51.000000000000000000
      end>
    TabOrder = 5
    object pgctrlText: TPageControl
      Left = 1
      Top = 418
      Width = 782
      Height = 155
      Align = alClient
      TabOrder = 19
    end
    object lvwSpecimen: TListView
      Left = 1
      Top = 264
      Width = 218
      Height = 154
      Align = alClient
      Anchors = []
      Columns = <
        item
          Caption = '#'
          MinWidth = 30
          Width = 30
        end
        item
          AutoSize = True
          Caption = 'Specimen Description'
          MinWidth = 183
        end>
      ColumnClick = False
      DoubleBuffered = True
      GridLines = True
      ReadOnly = True
      RowSelect = True
      ParentDoubleBuffered = False
      TabOrder = 14
      ViewStyle = vsReport
      OnChange = lvwSpecimenChange
      OnClick = lvwSpecimenClick
      OnDblClick = lvwSpecimenDblClick
      OnKeyDown = lvwSpecimenKeyDown
    end
    object pgctrlSpecimen: TPageControl
      Left = 219
      Top = 264
      Width = 564
      Height = 77
      Align = alClient
      ParentShowHint = False
      ShowHint = False
      TabOrder = 16
      OnEnter = pgctrlSpecimenEnter
    end
    object lblAvailTest: TLabel
      Left = 1
      Top = 1
      Width = 782
      Height = 13
      Align = alClient
      Caption = '*Available Orders'
      OnClick = lblAvailTestClick
      ExplicitWidth = 81
    end
    object cbxAvailTest: TORComboBox
      AlignWithMargins = True
      Left = 1
      Top = 14
      Width = 215
      Height = 229
      Margins.Left = 0
      Margins.Top = 0
      Margins.Bottom = 0
      Style = orcsSimple
      Align = alClient
      AutoSelect = True
      Caption = 'Available Anatomic Pathology Orders'
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
      TabOrder = 0
      Text = ''
      OnChange = cbxAvailTestChange
      OnEnter = cbxAvailTestEnter
      OnExit = cbxAvailTestExit
      OnKeyDown = cbxAvailTestKeyDown
      OnMouseClick = cbxAvailTestClick
      CharsNeedMatch = 1
    end
    object lblUrgency: TLabel
      Tag = 2
      AlignWithMargins = True
      Left = 222
      Top = 17
      Width = 134
      Height = 15
      Align = alClient
      Caption = 'Urgency'
      Transparent = False
      Layout = tlBottom
      ExplicitWidth = 40
      ExplicitHeight = 13
    end
    object cbxUrgency: TORComboBox
      AlignWithMargins = True
      Left = 222
      Top = 35
      Width = 134
      Height = 21
      Margins.Top = 0
      Margins.Bottom = 0
      Style = orcsDropDown
      Align = alClient
      AutoSelect = False
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
      OnChange = cbxUrgencyChange
      OnExit = LegacyExit
      OnKeyDown = LegacyKeyDown
      OnKeyUp = LegacyKeyUp
      CharsNeedMatch = 1
    end
    object lblORDateBox: TLabel
      Tag = 3
      AlignWithMargins = True
      Left = 362
      Top = 17
      Width = 134
      Height = 15
      Align = alClient
      Caption = 'Collection Date/Time'
      Transparent = False
      Layout = tlBottom
      ExplicitWidth = 100
      ExplicitHeight = 13
    end
    object calCollTime: TORDateBox
      AlignWithMargins = True
      Left = 362
      Top = 35
      Width = 134
      Height = 21
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alClient
      CharCase = ecUpperCase
      TabOrder = 2
      OnExit = calCollTimeExit
      DateOnly = False
      RequireTime = False
      Caption = 'Collection Date Time'
      OnDateDialogClosed = calCollTimeDateDialogClosed
    end
    object lblSubmittedBy: TLabel
      Tag = 4
      AlignWithMargins = True
      Left = 502
      Top = 17
      Width = 134
      Height = 15
      Align = alClient
      Caption = 'Specimen Submitted By'
      Layout = tlBottom
      ExplicitWidth = 112
      ExplicitHeight = 13
    end
    object edtSubmittedBy: TEdit
      AlignWithMargins = True
      Left = 502
      Top = 35
      Width = 134
      Height = 21
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alClient
      TabOrder = 3
      OnExit = edtSubmittedbyExit
    end
    object lblEmpry: TLabel
      Left = 639
      Top = 14
      Width = 144
      Height = 42
      Align = alClient
      Alignment = taCenter
      Caption = 'Empty Space'
      Layout = tlCenter
      Visible = False
      ExplicitWidth = 63
      ExplicitHeight = 13
    end
    object lblCollectionType: TLabel
      Tag = 5
      AlignWithMargins = True
      Left = 222
      Top = 59
      Width = 134
      Height = 15
      Align = alClient
      Caption = 'Collection Type'
      Transparent = False
      Layout = tlBottom
      ExplicitWidth = 73
      ExplicitHeight = 13
    end
    object cbxCollType: TORComboBox
      AlignWithMargins = True
      Left = 222
      Top = 77
      Width = 134
      Height = 21
      Margins.Top = 0
      Margins.Bottom = 0
      Style = orcsDropDown
      Align = alClient
      AutoSelect = True
      Caption = 'Collection Type'
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
      TabOrder = 4
      Text = ''
      OnChange = cbxCollTypeChange
      OnExit = LegacyExit
      OnKeyDown = LegacyKeyDown
      OnKeyUp = LegacyKeyUp
      CharsNeedMatch = 1
    end
    object lblHowLong: TLabel
      Tag = 7
      AlignWithMargins = True
      Left = 502
      Top = 59
      Width = 134
      Height = 15
      Align = alClient
      Caption = 'How Long?'
      Enabled = False
      Layout = tlBottom
      ExplicitWidth = 55
      ExplicitHeight = 13
    end
    object edtDays: TEdit
      Tag = 7
      AlignWithMargins = True
      Left = 502
      Top = 77
      Width = 134
      Height = 21
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alClient
      Enabled = False
      TabOrder = 5
      OnChange = edtDaysChange
    end
    object lblOften: TLabel
      Tag = 6
      AlignWithMargins = True
      Left = 362
      Top = 59
      Width = 134
      Height = 15
      Align = alClient
      Caption = 'How Often?'
      Transparent = False
      Layout = tlBottom
      ExplicitWidth = 57
      ExplicitHeight = 13
    end
    object cbxFrequency: TORComboBox
      Tag = 6
      AlignWithMargins = True
      Left = 362
      Top = 77
      Width = 134
      Height = 21
      Margins.Top = 0
      Margins.Bottom = 0
      Style = orcsDropDown
      Align = alClient
      AutoSelect = True
      Caption = 'How Often'
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
      TabOrder = 6
      Text = ''
      OnChange = cbxFrequencyChange
      OnExit = LegacyExit
      OnKeyDown = LegacyKeyDown
      OnKeyUp = LegacyKeyUp
      CharsNeedMatch = 1
    end
    object lblSurgeon: TLabel
      Tag = 8
      AlignWithMargins = True
      Left = 642
      Top = 59
      Width = 138
      Height = 15
      Align = alClient
      Caption = 'Surgeon/Provider'
      Transparent = False
      Layout = tlBottom
      ExplicitWidth = 84
      ExplicitHeight = 13
    end
    object cbxPtProvider: TORComboBox
      AlignWithMargins = True
      Left = 642
      Top = 77
      Width = 138
      Height = 21
      Margins.Top = 0
      Margins.Bottom = 0
      Style = orcsDropDown
      Align = alClient
      AutoSelect = True
      Caption = 'Surgeon and or Provider'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = True
      LongList = True
      LookupPiece = 2
      MaxLength = 0
      Pieces = '2'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 7
      Text = ''
      OnChange = cbxPtProviderChange
      OnExit = LegacyExit
      OnKeyDown = LegacyKeyDown
      OnKeyUp = LegacyKeyUp
      OnNeedData = cbxPtProviderNeedData
      CharsNeedMatch = 1
    end
    object pnlAntiCoagulation: TPanel
      Left = 219
      Top = 98
      Width = 564
      Height = 29
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 8
      object lblAnticoag: TLabel
        Left = 0
        Top = 0
        Width = 212
        Height = 29
        Align = alLeft
        Caption = 'What kind of anticoagulant is the patient on?'
        Layout = tlCenter
        ExplicitHeight = 13
      end
      object edtAnticoag: TEdit
        AlignWithMargins = True
        Left = 215
        Top = 3
        Width = 343
        Height = 23
        Margins.Right = 6
        Align = alClient
        TabOrder = 0
        OnExit = ledtCommentAntiCoagulantExit
        ExplicitHeight = 21
      end
    end
    object pnlDoseDraw: TPanel
      Left = 219
      Top = 127
      Width = 564
      Height = 29
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 9
      object lblDose: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 110
        Height = 23
        Align = alLeft
        Caption = 'Enter the last dose time'
        Transparent = False
        Layout = tlCenter
        ExplicitHeight = 13
      end
      object lblDraw: TLabel
        AlignWithMargins = True
        Left = 265
        Top = 3
        Width = 73
        Height = 23
        Align = alLeft
        Caption = 'Enter draw time'
        Transparent = False
        Layout = tlCenter
        ExplicitHeight = 13
      end
      object calDoseTime: TORDateBox
        AlignWithMargins = True
        Left = 119
        Top = 4
        Width = 140
        Height = 21
        Margins.Top = 4
        Margins.Bottom = 4
        Align = alLeft
        TabOrder = 0
        OnChange = DoseDrawComment
        DateOnly = False
        RequireTime = False
        Caption = ''
      end
      object calDrawTime: TORDateBox
        AlignWithMargins = True
        Left = 344
        Top = 4
        Width = 140
        Height = 21
        Margins.Top = 4
        Margins.Bottom = 4
        Align = alLeft
        TabOrder = 1
        OnChange = DoseDrawComment
        DateOnly = False
        RequireTime = False
        Caption = ''
      end
    end
    object pnlOrderComment: TPanel
      Left = 219
      Top = 156
      Width = 564
      Height = 29
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 10
      object lblOrderComment: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 73
        Height = 23
        Align = alLeft
        Caption = 'Order Comment'
        Layout = tlCenter
        ExplicitHeight = 13
      end
      object edtOrderComment: TEdit
        AlignWithMargins = True
        Left = 82
        Top = 3
        Width = 476
        Height = 23
        Margins.Right = 6
        Align = alClient
        TabOrder = 0
        OnExit = ledtOrderCommentExit
        ExplicitHeight = 21
      end
    end
    object pnlPeakTrough: TPanel
      Left = 219
      Top = 185
      Width = 564
      Height = 29
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 11
      object lblPeakTrough: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 79
        Height = 23
        Margins.Right = 8
        Align = alLeft
        Caption = 'Sample drawn at'
        Transparent = False
        Layout = tlCenter
        ExplicitHeight = 13
      end
      object edtPeakComment: TEdit
        AlignWithMargins = True
        Left = 317
        Top = 4
        Width = 244
        Height = 21
        Margins.Top = 4
        Margins.Bottom = 4
        Align = alClient
        TabOrder = 4
        OnExit = edtPeakCommentExit
      end
      object rbPeak: TRadioButton
        AlignWithMargins = True
        Left = 93
        Top = 3
        Width = 45
        Height = 23
        Align = alLeft
        Caption = '&Peak'
        TabOrder = 0
        OnClick = rgrpCommentPeakTroughClick
      end
      object rbTrough: TRadioButton
        Left = 141
        Top = 0
        Width = 57
        Height = 29
        Align = alLeft
        Caption = '&Trough'
        TabOrder = 1
        OnClick = rgrpCommentPeakTroughClick
      end
      object rbMid: TRadioButton
        Left = 198
        Top = 0
        Width = 43
        Height = 29
        Align = alLeft
        Caption = '&Mid'
        TabOrder = 2
        OnClick = rgrpCommentPeakTroughClick
      end
      object rbUnknown: TRadioButton
        Left = 241
        Top = 0
        Width = 73
        Height = 29
        Align = alLeft
        Caption = '&Unknown'
        TabOrder = 3
        OnClick = rgrpCommentPeakTroughClick
      end
    end
    object pnlUrineVolume: TPanel
      Left = 219
      Top = 214
      Width = 564
      Height = 29
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 12
      object lblUrineVolume: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 106
        Height = 23
        Margins.Right = 150
        Align = alLeft
        Caption = 'Enter the urine volume'
        Transparent = False
        Layout = tlCenter
        ExplicitHeight = 13
      end
      object spnedtUrineVolume: TSpinEdit
        Left = 120
        Top = 3
        Width = 121
        Height = 22
        MaxValue = 0
        MinValue = 0
        TabOrder = 0
        Value = 0
        OnChange = CommentUrineVolumeChange
      end
      object rbtnUrineML: TRadioButton
        Left = 259
        Top = 0
        Width = 34
        Height = 29
        Align = alLeft
        Caption = 'ml'
        TabOrder = 1
        OnClick = CommentUrineVolumeChange
      end
      object rbtnUrineCC: TRadioButton
        Left = 293
        Top = 0
        Width = 34
        Height = 29
        Align = alLeft
        Caption = 'cc'
        TabOrder = 2
        OnClick = CommentUrineVolumeChange
      end
      object rbtnUrineOZ: TRadioButton
        Left = 327
        Top = 0
        Width = 34
        Height = 29
        Align = alLeft
        Caption = 'oz'
        TabOrder = 3
        OnClick = CommentUrineVolumeChange
      end
    end
    object pnlTabs: TPanel
      Left = 1
      Top = 243
      Width = 218
      Height = 21
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 13
      object cbxSpecimenSelect: TORComboBox
        Left = 0
        Top = 0
        Width = 224
        Height = 21
        Style = orcsDropDown
        AutoSelect = True
        Caption = 'Select a Specimen to add to the order.'
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
        TabOrder = 0
        Text = ''
        CheckEntireLine = True
        OnChange = cbxSpecimenChange
        OnEnter = cbxSpecimenSelectEnter
        OnExit = cbxSpecimenSelectExit
        OnKeyDown = cbxSpecimenSelectKeyDown
        OnMouseClick = cbxSpecimenSelectMouseClick
        CharsNeedMatch = 1
      end
      object pnlAddSingleSpecimen: TKeyClickPanel
        Left = 195
        Top = 0
        Width = 20
        Height = 21
        BevelKind = bkTile
        BevelOuter = bvNone
        Caption = '+'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        TabStop = True
        Visible = False
        OnClick = pnlAddSingleSpecimenClick
        OnEnter = pnlFocusEnter
        OnExit = pnlFocusExit
      end
    end
    object pnlTotal: TPanel
      AlignWithMargins = True
      Left = 222
      Top = 246
      Width = 555
      Height = 15
      Margins.Right = 6
      Align = alClient
      Alignment = taRightJustify
      BevelOuter = bvNone
      TabOrder = 15
      OnEnter = pnlFocusEnter
      OnExit = pnlFocusExit
    end
    object pnlSpecMessage: TPanel
      Left = 219
      Top = 341
      Width = 564
      Height = 77
      Align = alClient
      BevelOuter = bvNone
      Color = clWindow
      ParentBackground = False
      TabOrder = 17
      object lblSpecMessage: TLabel
        AlignWithMargins = True
        Left = 100
        Top = 3
        Width = 364
        Height = 71
        Margins.Left = 100
        Margins.Right = 100
        Align = alClient
        Alignment = taCenter
        AutoSize = False
        Caption = 
          'At least one specimen along with a specimen description is requi' +
          'red to process an order.'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        Layout = tlCenter
        WordWrap = True
        ExplicitLeft = 6
        ExplicitTop = 6
        ExplicitWidth = 558
        ExplicitHeight = 70
      end
    end
  end
  inherited memOrder: TCaptionMemo
    AlignWithMargins = True
    Left = 4
    Top = 629
    Width = 669
    Height = 58
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 1
    ExplicitLeft = 4
    ExplicitTop = 629
    ExplicitWidth = 669
    ExplicitHeight = 58
  end
  inherited cmdAccept: TButton
    AlignWithMargins = True
    Left = 685
    Top = 632
    Anchors = [akRight, akBottom]
    TabOrder = 2
    ExplicitLeft = 685
    ExplicitTop = 632
  end
  inherited cmdQuit: TButton
    AlignWithMargins = True
    Left = 732
    Top = 659
    Anchors = [akRight, akBottom]
    TabOrder = 3
    ExplicitLeft = 732
    ExplicitTop = 659
  end
  inherited pnlMessage: TPanel
    Left = 6
    Top = 631
    Width = 665
    Height = 51
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 0
    ExplicitLeft = 6
    ExplicitTop = 631
    ExplicitWidth = 665
    ExplicitHeight = 51
    inherited imgMessage: TImage
      Top = 7
      ExplicitTop = 7
    end
    inherited memMessage: TRichEdit
      AlignWithMargins = True
      Left = 44
      Top = 6
      Width = 611
      Height = 35
      Margins.Left = 42
      Align = alClient
      PopupMenu = mnuMessagePopup
      ExplicitLeft = 44
      ExplicitTop = 6
      ExplicitWidth = 611
      ExplicitHeight = 35
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 16
    Top = 40
    Data = (
      (
        'Component = cbxAvailTest'
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
        'Component = frmODAnatPath'
        'Status = stsDefault')
      (
        'Component = pnlTabs'
        'Status = stsDefault')
      (
        'Component = pgctrlSpecimen'
        'Status = stsDefault')
      (
        'Component = pgctrlText'
        'Status = stsDefault')
      (
        'Component = cbxUrgency'
        'Status = stsDefault')
      (
        'Component = calCollTime'
        'Status = stsDefault')
      (
        'Component = cbxCollType'
        'Status = stsDefault')
      (
        'Component = cbxFrequency'
        'Status = stsDefault')
      (
        'Component = cbxPtProvider'
        'Status = stsDefault')
      (
        'Component = pnlTotal'
        'Status = stsDefault')
      (
        'Component = pnlDoseDraw'
        'Status = stsDefault')
      (
        'Component = pnlAntiCoagulation'
        'Status = stsDefault')
      (
        'Component = pnlUrineVolume'
        'Status = stsDefault')
      (
        'Component = pnlPeakTrough'
        'Status = stsDefault')
      (
        'Component = pnlOrderComment'
        'Status = stsDefault')
      (
        'Component = spnedtUrineVolume'
        'Status = stsDefault')
      (
        'Component = calDoseTime'
        'Status = stsDefault')
      (
        'Component = calDrawTime'
        'Status = stsDefault')
      (
        'Component = cbxSpecimenSelect'
        'Status = stsDefault')
      (
        'Component = lvwSpecimen'
        'Status = stsDefault')
      (
        'Component = pnlAddSingleSpecimen'
        'Status = stsDefault')
      (
        'Component = edtPeakComment'
        'Status = stsDefault')
      (
        'Component = gpMain'
        'Status = stsDefault')
      (
        'Component = edtSubmittedBy'
        'Status = stsDefault')
      (
        'Component = edtDays'
        'Status = stsDefault')
      (
        'Component = rbPeak'
        'Status = stsDefault')
      (
        'Component = rbTrough'
        'Status = stsDefault')
      (
        'Component = rbMid'
        'Status = stsDefault')
      (
        'Component = rbUnknown'
        'Status = stsDefault')
      (
        'Component = pnlSpecMessage'
        'Status = stsDefault')
      (
        'Component = edtAnticoag'
        'Status = stsDefault')
      (
        'Component = edtOrderComment'
        'Status = stsDefault'))
  end
  object mnuMessagePopup: TPopupMenu
    Left = 734
    Top = 679
    object mnuViewinReportWindow: TMenuItem
      Caption = '&View in Report Window'
      OnClick = mnuViewinReportWindowClick
    end
  end
  object aPageNav: TActionList
    Left = 72
    Top = 96
    object aCtrlTab: TAction
      Caption = 'aCtrlTab'
      ShortCut = 16393
      OnExecute = aCtrlTabExecute
    end
    object aCtrlShiftTab: TAction
      Caption = 'aCtrlShiftTab'
      ShortCut = 24585
      OnExecute = aCtrlShiftTabExecute
    end
  end
  object VA508Urgency: TVA508ComponentAccessibility
    Tag = 2
    Component = cbxUrgency
    OnCaptionQuery = VA508CaptionQuery
    Left = 288
    Top = 8
  end
  object VA508CollectionDT: TVA508ComponentAccessibility
    Tag = 3
    Component = calCollTime
    OnCaptionQuery = VA508CaptionQuery
    Instructions = 'press the enter key to access'
    Left = 456
    Top = 8
  end
  object VA508Submitted: TVA508ComponentAccessibility
    Tag = 4
    Component = edtSubmittedBy
    OnCaptionQuery = VA508CaptionQuery
    Caption = 'Specimen Submitted By'
    Left = 622
    Top = 9
  end
  object VA508CollectionType: TVA508ComponentAccessibility
    Tag = 5
    Component = cbxCollType
    OnCaptionQuery = VA508CaptionQuery
    Left = 290
    Top = 61
  end
  object VA508Frequency: TVA508ComponentAccessibility
    Tag = 6
    Component = cbxFrequency
    OnCaptionQuery = VA508CaptionQuery
    Left = 460
    Top = 62
  end
  object VA508HowLong: TVA508ComponentAccessibility
    Tag = 7
    Component = edtDays
    OnCaptionQuery = VA508CaptionQuery
    Caption = 'How Long'
    Left = 596
    Top = 62
  end
  object VA508Orders: TVA508ComponentAccessibility
    Tag = 1
    Component = cbxAvailTest
    OnCaptionQuery = VA508CaptionQuery
    Instructions = 'To select an order use the arrow keys, then press enter'
    Left = 96
    Top = 16
  end
  object VA508Surgeon: TVA508ComponentAccessibility
    Tag = 8
    Component = cbxPtProvider
    OnCaptionQuery = VA508CaptionQuery
    OnValueQuery = VA508SurgeonValueQuery
    Left = 754
    Top = 57
  end
  object VA508OrderComment: TVA508ComponentAccessibility
    Tag = 9
    Component = edtOrderComment
    OnCaptionQuery = VA508CaptionQuery
    Caption = 'Order Comment'
    Left = 746
    Top = 157
  end
  object VA508SampleDrawn: TVA508ComponentAccessibility
    Tag = 10
    OnCaptionQuery = VA508CaptionQuery
    Left = 600
    Top = 397
  end
  object VA508UrineVolume: TVA508ComponentAccessibility
    Tag = 11
    Component = spnedtUrineVolume
    OnCaptionQuery = VA508CaptionQuery
    Left = 600
    Top = 213
  end
  object VA508Anticoagulant: TVA508ComponentAccessibility
    Tag = 12
    Component = edtAnticoag
    OnCaptionQuery = VA508CaptionQuery
    Left = 680
    Top = 93
  end
  object VA508DoseTime: TVA508ComponentAccessibility
    Tag = 13
    Component = calDoseTime
    OnCaptionQuery = VA508CaptionQuery
    Left = 419
    Top = 118
  end
  object VA508DrawTime: TVA508ComponentAccessibility
    Tag = 14
    Component = calDrawTime
    OnCaptionQuery = VA508CaptionQuery
    Left = 715
    Top = 126
  end
  object VA508PageControl: TVA508ComponentAccessibility
    Tag = 99
    Component = pgctrlText
    OnCaptionQuery = VA508GenericCaptionQuery
    OnInstructionsQuery = VA508PageControlInstructionsQuery
    Instructions = 'Use the left and right arrow keys to change tabs'
    Left = 32
    Top = 440
  end
  object VA508cbxSpecimenSelect: TVA508ComponentAccessibility
    Component = cbxSpecimenSelect
    OnInstructionsQuery = VA508cbxSpecimenSelectInstructionsQuery
    Instructions = '0'
    Left = 81
    Top = 235
  end
end
