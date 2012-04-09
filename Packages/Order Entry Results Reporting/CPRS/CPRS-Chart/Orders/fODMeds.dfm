inherited frmODMeds: TfrmODMeds
  Left = 321
  Top = 183
  Width = 584
  Height = 578
  AutoScroll = True
  Caption = 'Medication Order'
  Constraints.MinHeight = 325
  Constraints.MinWidth = 452
  OnShow = FormShow
  ExplicitWidth = 584
  ExplicitHeight = 578
  DesignSize = (
    576
    544)
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMeds: TPanel [0]
    Left = 6
    Top = 34
    Width = 580
    Height = 476
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    TabOrder = 1
    object sptSelect: TSplitter
      Left = 0
      Top = 133
      Width = 580
      Height = 4
      Cursor = crVSplit
      Align = alTop
    end
    object lstQuick: TCaptionListView
      Left = 0
      Top = 0
      Width = 580
      Height = 133
      Align = alTop
      BevelInner = bvLowered
      BevelOuter = bvSpace
      Columns = <
        item
          Width = 420
        end>
      ColumnClick = False
      HideSelection = False
      HotTrack = True
      HoverTime = 2147483647
      OwnerData = True
      ParentShowHint = False
      ShowColumnHeaders = False
      ShowHint = True
      TabOrder = 0
      ViewStyle = vsReport
      OnChange = lstChange
      OnClick = ListViewClick
      OnData = lstQuickData
      OnDataHint = lstQuickDataHint
      OnEditing = ListViewEditing
      OnEnter = ListViewEnter
      OnKeyUp = ListViewKeyUp
      OnResize = ListViewResize
      Caption = 'Quick Orders'
    end
    object lstAll: TCaptionListView
      Left = 0
      Top = 137
      Width = 580
      Height = 339
      Align = alClient
      BevelInner = bvLowered
      BevelOuter = bvNone
      Columns = <
        item
          Width = 420
        end>
      ColumnClick = False
      HideSelection = False
      HotTrack = True
      HoverTime = 2147483647
      OwnerData = True
      ParentShowHint = False
      ShowColumnHeaders = False
      ShowHint = True
      TabOrder = 1
      ViewStyle = vsReport
      OnChange = lstChange
      OnClick = ListViewClick
      OnData = lstAllData
      OnDataHint = lstAllDataHint
      OnEditing = ListViewEditing
      OnEnter = ListViewEnter
      OnKeyUp = ListViewKeyUp
      OnResize = ListViewResize
      Caption = 'All Medication orders'
    end
  end
  inherited memOrder: TCaptionMemo
    Tag = 13
    Top = 511
    Width = 502
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 4
    ExplicitTop = 511
    ExplicitWidth = 502
  end
  object txtMed: TEdit [2]
    Left = 6
    Top = 12
    Width = 580
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    AutoSelect = False
    TabOrder = 0
    Text = '(Type a medication name or select from the orders below)'
    OnChange = txtMedChange
    OnExit = txtMedExit
    OnKeyDown = txtMedKeyDown
    OnKeyUp = txtMedKeyUp
  end
  object btnSelect: TButton [3]
    Left = 515
    Top = 511
    Width = 72
    Height = 21
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    Enabled = False
    TabOrder = 5
    OnClick = btnSelectClick
  end
  object pnlFields: TPanel [4]
    Left = 6
    Top = 44
    Width = 580
    Height = 465
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    Enabled = False
    TabOrder = 2
    Visible = False
    OnResize = pnlFieldsResize
    object pnlTop: TPanel
      Left = 0
      Top = 0
      Width = 580
      Height = 192
      Align = alClient
      Constraints.MinHeight = 80
      TabOrder = 3
      DesignSize = (
        580
        192)
      object lblRoute: TLabel
        Left = 280
        Top = 23
        Width = 29
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'Route'
        Visible = False
      end
      object lblSchedule: TLabel
        Left = 394
        Top = 22
        Width = 45
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'Schedule'
        Visible = False
        WordWrap = True
      end
      object txtNSS: TLabel
        Left = 442
        Top = 22
        Width = 71
        Height = 13
        Anchors = [akTop, akRight]
        Caption = '(Day-Of-Week)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Visible = False
        WordWrap = True
        OnClick = txtNSSClick
      end
      object grdDoses: TCaptionStringGrid
        Left = 0
        Top = 36
        Width = 580
        Height = 151
        Anchors = [akLeft, akTop, akRight, akBottom]
        ColCount = 7
        DefaultColWidth = 76
        DefaultRowHeight = 21
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goTabs]
        ScrollBars = ssVertical
        TabOrder = 8
        OnDrawCell = grdDosesDrawCell
        OnEnter = grdDosesEnter
        OnExit = grdDosesExit
        OnKeyDown = grdDosesKeyDown
        OnKeyPress = grdDosesKeyPress
        OnMouseDown = grdDosesMouseDown
        OnMouseUp = grdDosesMouseUp
        Caption = 'Complex Dosage'
        JustToTab = True
        ColWidths = (
          76
          76
          76
          76
          76
          76
          76)
      end
      object lblGuideline: TStaticText
        Left = 0
        Top = 1
        Width = 181
        Height = 17
        Caption = 'Display Restrictions/Guidelines'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold, fsUnderline]
        ParentColor = False
        ParentFont = False
        ShowAccelChar = False
        TabOrder = 0
        TabStop = True
        Visible = False
        OnClick = lblGuidelineClick
      end
      object tabDose: TTabControl
        Left = 1
        Top = 19
        Width = 175
        Height = 17
        TabOrder = 3
        Tabs.Strings = (
          'Dosage'
          'Complex')
        TabIndex = 0
        TabStop = False
        TabWidth = 86
        OnChange = tabDoseChange
      end
      object cboDosage: TORComboBox
        Left = 1
        Top = 36
        Width = 279
        Height = 150
        Anchors = [akLeft, akTop, akRight, akBottom]
        Style = orcsSimple
        AutoSelect = True
        Caption = 'Dosage'
        Color = clWindow
        DropDownCount = 8
        ItemHeight = 13
        ItemTipColor = clWindow
        ItemTipEnable = True
        ListItemsOnly = False
        LongList = False
        LookupPiece = 0
        MaxLength = 0
        Pieces = '5,3,6'
        Sorted = False
        SynonymChars = '<>'
        TabPositions = '27,32'
        TabOrder = 4
        OnChange = cboDosageChange
        OnClick = cboDosageClick
        OnExit = cboDosageExit
        OnKeyUp = cboDosageKeyUp
        CharsNeedMatch = 1
        UniqueAutoComplete = True
      end
      object cboRoute: TORComboBox
        Left = 280
        Top = 36
        Width = 113
        Height = 151
        Anchors = [akTop, akRight, akBottom]
        Style = orcsSimple
        AutoSelect = True
        Caption = 'Route'
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
        Pieces = '2'
        ShowHint = True
        Sorted = False
        SynonymChars = '<>'
        TabOrder = 5
        OnChange = cboRouteChange
        OnClick = ControlChange
        OnExit = cboRouteExit
        OnKeyUp = cboRouteKeyUp
        CharsNeedMatch = 1
        UniqueAutoComplete = True
      end
      object cboSchedule: TORComboBox
        Left = 394
        Top = 36
        Width = 178
        Height = 151
        Anchors = [akTop, akRight, akBottom]
        Style = orcsSimple
        AutoSelect = False
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
        Pieces = '1'
        Sorted = True
        SynonymChars = '<>'
        TabOrder = 6
        OnChange = cboScheduleChange
        OnClick = cboScheduleClick
        OnEnter = cboScheduleEnter
        OnExit = cboScheduleExit
        OnKeyUp = cboScheduleKeyUp
        CharsNeedMatch = 1
        UniqueAutoComplete = True
      end
      object chkPRN: TCheckBox
        Left = 530
        Top = 37
        Width = 42
        Height = 18
        Anchors = [akTop, akRight]
        Caption = 'PRN'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 7
        OnClick = chkPRNClick
      end
      object btnXInsert: TButton
        Left = 403
        Top = 3
        Width = 79
        Height = 17
        Caption = 'Insert Row'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = btnXInsertClick
      end
      object btnXRemove: TButton
        Left = 488
        Top = 3
        Width = 79
        Height = 17
        Caption = 'Remove Row'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = btnXRemoveClick
      end
      object pnlXAdminTime: TPanel
        Left = 432
        Top = 149
        Width = 65
        Height = 17
        Caption = 'pnlXAdminTime'
        TabOrder = 9
        Visible = False
        OnClick = pnlXAdminTimeClick
      end
    end
    object cboXDosage: TORComboBox
      Left = 49
      Top = 122
      Width = 72
      Height = 21
      Style = orcsDropDown
      AutoSelect = False
      Caption = 'Dosage'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = False
      LongList = False
      LookupPiece = 0
      MaxLength = 0
      Pieces = '5'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 0
      Visible = False
      OnChange = cboXDosageChange
      OnClick = cboXDosageClick
      OnEnter = cboXDosageEnter
      OnExit = cboXDosageExit
      OnKeyDown = memMessageKeyDown
      OnKeyUp = cboXDosageKeyUp
      CharsNeedMatch = 1
      UniqueAutoComplete = True
    end
    object cboXRoute: TORComboBox
      Left = 122
      Top = 122
      Width = 72
      Height = 21
      Style = orcsDropDown
      AutoSelect = False
      Caption = 'Route'
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
      TabOrder = 1
      Visible = False
      OnChange = cboXRouteChange
      OnClick = cboXRouteClick
      OnEnter = cboXRouteEnter
      OnExit = cboXRouteExit
      OnKeyDown = memMessageKeyDown
      CharsNeedMatch = 1
      UniqueAutoComplete = True
    end
    object pnlXDuration: TPanel
      Left = 300
      Top = 122
      Width = 72
      Height = 21
      BevelOuter = bvNone
      TabOrder = 4
      Visible = False
      OnEnter = pnlXDurationEnter
      OnExit = pnlXDurationExit
      DesignSize = (
        72
        21)
      object pnlXDurationButton: TKeyClickPanel
        Left = 39
        Top = 1
        Width = 33
        Height = 19
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = 'Duration'
        TabOrder = 2
        TabStop = True
        OnClick = btnXDurationClick
        OnEnter = pnlXDurationButtonEnter
        object btnXDuration: TSpeedButton
          Left = 0
          Top = 0
          Width = 33
          Height = 19
          Caption = 'days'
          Flat = True
          Glyph.Data = {
            AE000000424DAE0000000000000076000000280000000E000000070000000100
            0400000000003800000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
            330033333333333333003330333333733300330003333F87330030000033FFFF
            F30033333333333333003333333333333300}
          Layout = blGlyphRight
          NumGlyphs = 2
          Spacing = 0
          Transparent = False
          OnClick = btnXDurationClick
        end
      end
      object txtXDuration: TCaptionEdit
        Left = 0
        Top = 0
        Width = 25
        Height = 21
        Anchors = [akLeft, akTop, akBottom]
        TabOrder = 0
        Text = '0'
        OnChange = txtXDurationChange
        OnKeyDown = memMessageKeyDown
        Caption = 'Duration'
      end
      object spnXDuration: TUpDown
        Left = 25
        Top = 0
        Width = 15
        Height = 21
        Anchors = [akLeft, akTop, akBottom]
        Associate = txtXDuration
        Max = 999
        TabOrder = 1
      end
    end
    object pnlXSchedule: TPanel
      Left = 195
      Top = 122
      Width = 106
      Height = 21
      BevelOuter = bvNone
      TabOrder = 2
      Visible = False
      OnEnter = pnlXScheduleEnter
      OnExit = pnlXScheduleExit
      DesignSize = (
        106
        21)
      object cboXSchedule: TORComboBox
        Left = 0
        Top = 0
        Width = 63
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        Style = orcsDropDown
        AutoSelect = False
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
        Pieces = '1'
        Sorted = False
        SynonymChars = '<>'
        TabOrder = 0
        TabStop = True
        OnChange = cboXScheduleChange
        OnClick = cboXScheduleClick
        OnEnter = cboXScheduleEnter
        OnExit = cboXScheduleExit
        OnKeyDown = memMessageKeyDown
        OnKeyUp = cboXScheduleKeyUp
        CharsNeedMatch = 1
        UniqueAutoComplete = True
      end
      object chkXPRN: TCheckBox
        Left = 63
        Top = 4
        Width = 42
        Height = 11
        Anchors = [akTop, akRight]
        Caption = 'PRN'
        TabOrder = 1
        OnClick = chkXPRNClick
        OnKeyDown = memMessageKeyDown
      end
    end
    object pnlBottom: TPanel
      Left = 0
      Top = 192
      Width = 580
      Height = 273
      Align = alBottom
      TabOrder = 5
      DesignSize = (
        580
        273)
      object lblComment: TLabel
        Left = 4
        Top = 5
        Width = 52
        Height = 16
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Comments:'
      end
      object lblDays: TLabel
        Left = 4
        Top = 65
        Width = 59
        Height = 13
        Caption = 'Days Supply'
      end
      object lblQuantity: TLabel
        Left = 81
        Top = 65
        Width = 39
        Height = 13
        Caption = 'Quantity'
        ParentShowHint = False
        ShowHint = True
      end
      object lblRefills: TLabel
        Left = 140
        Top = 65
        Width = 28
        Height = 13
        Caption = 'Refills'
      end
      object lblPriority: TLabel
        Left = 503
        Top = 61
        Width = 31
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'Priority'
      end
      object Image1: TImage
        Left = 5
        Top = 221
        Width = 31
        Height = 31
        Anchors = [akLeft, akBottom]
        Visible = False
        ExplicitTop = 177
      end
      object chkDoseNow: TCheckBox
        Left = 3
        Top = 104
        Width = 247
        Height = 21
        Caption = 'Give additional dose now'
        TabOrder = 8
        OnClick = chkDoseNowClick
      end
      object memComment: TCaptionMemo
        Left = 57
        Top = 2
        Width = 513
        Height = 43
        Anchors = [akLeft, akTop, akRight]
        ScrollBars = ssVertical
        TabOrder = 0
        OnChange = ControlChange
        OnClick = memCommentClick
        Caption = 'Comments'
      end
      object lblQtyMsg: TStaticText
        Left = 4
        Top = 47
        Width = 206
        Height = 17
        Caption = '>> Quantity Dispensed: Multiples of 100 <<'
        TabOrder = 13
      end
      object txtSupply: TCaptionEdit
        Left = 2
        Top = 78
        Width = 60
        Height = 21
        AutoSize = False
        TabOrder = 1
        Text = '0'
        OnChange = txtSupplyChange
        OnClick = txtSupplyClick
        Caption = 'Days Supply'
      end
      object spnSupply: TUpDown
        Left = 62
        Top = 78
        Width = 15
        Height = 21
        Associate = txtSupply
        TabOrder = 2
      end
      object txtQuantity: TCaptionEdit
        Left = 80
        Top = 78
        Width = 40
        Height = 21
        AutoSize = False
        TabOrder = 3
        Text = '0'
        OnChange = txtQuantityChange
        OnClick = txtQuantityClick
        Caption = 'Quantity'
      end
      object spnQuantity: TUpDown
        Left = 120
        Top = 78
        Width = 16
        Height = 21
        Associate = txtQuantity
        Max = 32766
        TabOrder = 4
      end
      object txtRefills: TCaptionEdit
        Left = 140
        Top = 78
        Width = 30
        Height = 21
        AutoSize = False
        TabOrder = 5
        Text = '0'
        OnChange = txtRefillsChange
        OnClick = txtRefillsClick
        Caption = 'Refills'
      end
      object spnRefills: TUpDown
        Left = 170
        Top = 78
        Width = 15
        Height = 21
        Associate = txtRefills
        Max = 11
        TabOrder = 6
      end
      object grpPickup: TGroupBox
        Left = 188
        Top = 66
        Width = 172
        Height = 36
        Caption = 'Pick Up'
        TabOrder = 7
        object radPickWindow: TRadioButton
          Left = 105
          Top = 14
          Width = 58
          Height = 17
          Caption = '&Window'
          TabOrder = 2
          OnClick = ControlChange
        end
        object radPickMail: TRadioButton
          Left = 58
          Top = 14
          Width = 38
          Height = 17
          Caption = '&Mail'
          TabOrder = 1
          OnClick = ControlChange
        end
        object radPickClinic: TRadioButton
          Left = 7
          Top = 14
          Width = 44
          Height = 17
          Caption = '&Clinic'
          TabOrder = 0
          OnClick = ControlChange
        end
      end
      object cboPriority: TORComboBox
        Left = 502
        Top = 76
        Width = 72
        Height = 21
        Anchors = [akTop, akRight]
        Style = orcsDropDown
        AutoSelect = True
        Caption = 'Priority'
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
        TabOrder = 9
        OnChange = ControlChange
        OnKeyUp = cboPriorityKeyUp
        CharsNeedMatch = 1
      end
      object stcPI: TStaticText
        Left = 2
        Top = 123
        Width = 89
        Height = 17
        Caption = 'Patient Instruction'
        TabOrder = 17
        Visible = False
      end
      object chkPtInstruct: TCheckBox
        Left = 4
        Top = 137
        Width = 14
        Height = 21
        Color = clBtnFace
        ParentColor = False
        TabOrder = 18
        Visible = False
        OnClick = chkPtInstructClick
      end
      object memPI: TMemo
        Left = 23
        Top = 139
        Width = 547
        Height = 35
        TabStop = False
        Anchors = [akLeft, akTop, akRight]
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 19
        Visible = False
        OnClick = memPIClick
        OnKeyDown = memPIKeyDown
      end
      object memDrugMsg: TMemo
        Left = 37
        Top = 220
        Width = 533
        Height = 51
        Anchors = [akLeft, akRight, akBottom]
        Color = clCream
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 20
        Visible = False
      end
      object lblAdminSch: TMemo
        Left = 344
        Top = 120
        Width = 68
        Height = 15
        Anchors = [akLeft, akTop, akRight]
        Color = clCream
        ParentShowHint = False
        ReadOnly = True
        ScrollBars = ssVertical
        ShowHint = True
        TabOrder = 10
        Visible = False
      end
      object lblAdminTime: TVA508StaticText
        Name = 'lblAdminTime'
        Left = 164
        Top = 116
        Width = 64
        Height = 15
        Alignment = taLeftJustify
        Caption = 'lblAdminTime'
        TabOrder = 11
        TabStop = True
        ShowAccelChar = True
      end
    end
    object cboXSequence: TORComboBox
      Left = 438
      Top = 122
      Width = 64
      Height = 21
      Style = orcsDropDown
      AutoSelect = True
      Caption = 'Sequence'
      Color = clWindow
      DropDownCount = 8
      Items.Strings = (
        'and'
        'then')
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = False
      LongList = False
      LookupPiece = 0
      MaxLength = 0
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 6
      Visible = False
      OnChange = cboXSequenceChange
      OnEnter = cboXSequenceEnter
      OnExit = cboXSequenceExit
      OnKeyDown = memMessageKeyDown
      OnKeyUp = cboXSequenceKeyUp
      CharsNeedMatch = 1
    end
  end
  inherited cmdAccept: TButton
    Left = 514
    Top = 511
    Anchors = [akRight, akBottom]
    TabOrder = 6
    TabStop = False
    Visible = False
    ExplicitLeft = 514
    ExplicitTop = 511
  end
  inherited cmdQuit: TButton
    Left = 514
    Top = 536
    Width = 51
    Anchors = [akRight, akBottom]
    TabOrder = 7
    ExplicitLeft = 514
    ExplicitTop = 536
    ExplicitWidth = 51
  end
  inherited pnlMessage: TPanel
    Left = 31
    Top = 200
    OnEnter = pnlMessageEnter
    ExplicitLeft = 31
    ExplicitTop = 200
    inherited imgMessage: TImage
      Left = 2
      ExplicitLeft = 2
    end
    inherited memMessage: TRichEdit
      OnKeyDown = memMessageKeyDown
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlMeds'
        'Status = stsDefault')
      (
        'Component = lstQuick'
        'Text = Quick Orders'
        'Status = stsOK')
      (
        'Component = lstAll'
        'Text = Medications'
        'Status = stsOK')
      (
        'Component = txtMed'
        'Text = Medication'
        'Status = stsOK')
      (
        'Component = btnSelect'
        'Status = stsDefault')
      (
        'Component = pnlFields'
        'Status = stsDefault')
      (
        'Component = pnlTop'
        'Status = stsDefault')
      (
        'Component = grdDoses'
        'Status = stsDefault')
      (
        'Component = lblGuideline'
        'Status = stsDefault')
      (
        'Component = tabDose'
        'Status = stsDefault')
      (
        'Component = cboDosage'
        'Status = stsDefault')
      (
        'Component = cboRoute'
        'Status = stsDefault')
      (
        'Component = cboSchedule'
        'Status = stsDefault')
      (
        'Component = chkPRN'
        'Status = stsDefault')
      (
        'Component = btnXInsert'
        'Status = stsDefault')
      (
        'Component = btnXRemove'
        'Status = stsDefault')
      (
        'Component = pnlXAdminTime'
        'Status = stsDefault')
      (
        'Component = cboXDosage'
        'Status = stsDefault')
      (
        'Component = cboXRoute'
        'Status = stsDefault')
      (
        'Component = pnlXDuration'
        'Status = stsDefault')
      (
        'Component = pnlXDurationButton'
        'Status = stsDefault')
      (
        'Component = txtXDuration'
        'Status = stsDefault')
      (
        'Component = spnXDuration'
        'Status = stsDefault')
      (
        'Component = pnlXSchedule'
        'Status = stsDefault')
      (
        'Component = cboXSchedule'
        'Status = stsDefault')
      (
        'Component = chkXPRN'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = chkDoseNow'
        'Status = stsDefault')
      (
        'Component = memComment'
        'Status = stsDefault')
      (
        'Component = lblQtyMsg'
        'Status = stsDefault')
      (
        'Component = txtSupply'
        'Status = stsDefault')
      (
        'Component = spnSupply'
        'Status = stsDefault')
      (
        'Component = txtQuantity'
        'Status = stsDefault')
      (
        'Component = spnQuantity'
        'Status = stsDefault')
      (
        'Component = txtRefills'
        'Status = stsDefault')
      (
        'Component = spnRefills'
        'Status = stsDefault')
      (
        'Component = grpPickup'
        'Status = stsDefault')
      (
        'Component = radPickWindow'
        'Status = stsDefault')
      (
        'Component = radPickMail'
        'Status = stsDefault')
      (
        'Component = radPickClinic'
        'Status = stsDefault')
      (
        'Component = cboPriority'
        'Status = stsDefault')
      (
        'Component = stcPI'
        'Status = stsDefault')
      (
        'Component = chkPtInstruct'
        'Status = stsDefault')
      (
        'Component = memPI'
        'Status = stsDefault')
      (
        'Component = memDrugMsg'
        'Status = stsDefault')
      (
        'Component = memOrder'
        'Text = Order Sig'
        'Status = stsOK')
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
        'Component = frmODMeds'
        'Status = stsDefault')
      (
        'Component = cboXSequence'
        'Status = stsDefault')
      (
        'Component = lblAdminSch'
        'Text = Admin Schedule.'
        'Status = stsOK')
      (
        'Component = lblAdminTime'
        'Status = stsDefault'))
  end
  object dlgStart: TORDateTimeDlg
    FMDateTime = 3001101.000000000000000000
    DateOnly = False
    RequireTime = True
    Left = 444
    Top = 336
  end
  object timCheckChanges: TTimer
    Enabled = False
    Interval = 500
    OnTimer = timCheckChangesTimer
    Left = 477
    Top = 336
  end
  object popDuration: TPopupMenu
    AutoHotkeys = maManual
    Left = 380
    Top = 145
    object popBlank: TMenuItem
      Caption = '(no selection)'
      OnClick = popDurationClick
    end
    object months1: TMenuItem
      Tag = 5
      Caption = 'months'
      OnClick = popDurationClick
    end
    object weeks1: TMenuItem
      Tag = 4
      Caption = 'weeks'
      OnClick = popDurationClick
    end
    object popDays: TMenuItem
      Tag = 3
      Caption = 'days'
      OnClick = popDurationClick
    end
    object hours1: TMenuItem
      Tag = 2
      Caption = 'hours'
      OnClick = popDurationClick
    end
    object minutes1: TMenuItem
      Tag = 1
      Caption = 'minutes'
      OnClick = popDurationClick
    end
  end
end
