inherited frmODMedNVA: TfrmODMedNVA
  Left = 203
  Top = 183
  Width = 776
  Height = 638
  Caption = 'Document Herbal/OTC/Non-VA Medications'
  Constraints.MinHeight = 449
  ExplicitWidth = 776
  ExplicitHeight = 638
  PixelsPerInch = 96
  TextHeight = 13
  inherited memOrder: TCaptionMemo
    Left = 0
    Top = 685
    Width = 790
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Anchors = [akLeft, akRight, akBottom]
    Constraints.MinWidth = 31
    TabOrder = 4
    ExplicitLeft = 0
    ExplicitTop = 685
    ExplicitWidth = 790
  end
  object pnlMeds: TPanel [1]
    Left = 7
    Top = 42
    Width = 742
    Height = 370
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    TabOrder = 1
    object sptSelect: TSplitter
      Left = 0
      Top = 164
      Width = 742
      Height = 5
      Cursor = crVSplit
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      ExplicitWidth = 730
    end
    object lstQuick: TCaptionListView
      Left = 0
      Top = 0
      Width = 742
      Height = 164
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      BevelInner = bvLowered
      BevelOuter = bvSpace
      Columns = <
        item
          Width = 517
        end>
      ColumnClick = False
      Constraints.MaxHeight = 203
      HideSelection = False
      HotTrack = True
      OwnerData = True
      ParentShowHint = False
      ShowColumnHeaders = False
      ShowHint = True
      TabOrder = 0
      TabStop = False
      ViewStyle = vsReport
      OnChange = lstChange
      OnClick = ListViewClick
      OnData = lstQuickData
      OnEditing = ListViewEditing
      OnEnter = ListViewEnter
      OnResize = ListViewResize
      AutoSize = False
      Caption = 'Quick Orders'
    end
    object lstAll: TCaptionListView
      Left = 0
      Top = 169
      Width = 742
      Height = 201
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      Columns = <
        item
          Width = 517
        end>
      ColumnClick = False
      HideSelection = False
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
      OnResize = ListViewResize
      AutoSize = False
      Caption = 'All Medication orders'
    end
  end
  object txtMed: TEdit [2]
    Left = 9
    Top = 9
    Width = 742
    Height = 21
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akLeft, akTop, akRight]
    AutoSelect = False
    TabOrder = 0
    Text = '(Type a medication name or select from the orders below)'
    OnChange = txtMedChange
    OnExit = txtMedExit
    OnKeyDown = txtMedKeyDown
    OnKeyUp = txtMedKeyUp
  end
  object pnlFields: TPanel [3]
    Left = 4
    Top = 42
    Width = 747
    Height = 451
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    Enabled = False
    TabOrder = 2
    Visible = False
    object pnlTop: TPanel
      Left = 0
      Top = 0
      Width = 747
      Height = 249
      Align = alClient
      Constraints.MinHeight = 80
      ParentBackground = False
      TabOrder = 0
      DesignSize = (
        747
        249)
      object lblRoute: TLabel
        Left = 353
        Top = 26
        Width = 29
        Height = 13
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akTop, akRight]
        Caption = 'Route'
        Visible = False
        ExplicitLeft = 389
      end
      object lblSchedule: TLabel
        Left = 544
        Top = 26
        Width = 45
        Height = 13
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akTop, akRight]
        Caption = 'Schedule'
        Visible = False
        ExplicitLeft = 580
      end
      object txtNSS: TLabel
        Left = 666
        Top = 22
        Width = 71
        Height = 13
        Anchors = [akTop, akRight]
        Caption = '(Day-Of-Week)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Visible = False
        WordWrap = True
        OnClick = txtNSSClick
        ExplicitLeft = 552
      end
      object grdDoses: TCaptionStringGrid
        Left = 5
        Top = 42
        Width = 741
        Height = 431
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akLeft, akTop, akRight, akBottom]
        ColCount = 7
        DefaultColWidth = 76
        DefaultRowHeight = 21
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goTabs]
        ScrollBars = ssVertical
        TabOrder = 5
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
        Width = 222
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Display Restrictions/Guidelines'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold, fsUnderline]
        ParentColor = False
        ParentFont = False
        ShowAccelChar = False
        TabOrder = 0
        TabStop = True
        Transparent = False
        Visible = False
        OnClick = lblGuidelineClick
      end
      object tabDose: TTabControl
        Left = 5
        Top = 22
        Width = 216
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
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
        Left = -2
        Top = 45
        Width = 347
        Height = 374
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
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
        TabOrder = 6
        Text = ''
        OnChange = cboDosageChange
        OnClick = cboDosageClick
        OnExit = cboDosageExit
        OnKeyUp = cboDosageKeyUp
        CharsNeedMatch = 1
      end
      object cboRoute: TORComboBox
        Left = 353
        Top = 44
        Width = 191
        Height = 374
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
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
        TabOrder = 7
        Text = ''
        OnChange = cboRouteChange
        OnClick = ControlChange
        OnKeyUp = cboRouteKeyUp
        CharsNeedMatch = 1
      end
      object cboSchedule: TORComboBox
        Left = 544
        Top = 44
        Width = 193
        Height = 374
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akTop, akRight, akBottom]
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
        Pieces = '1'
        Sorted = False
        SynonymChars = '<>'
        TabOrder = 9
        Text = ''
        OnChange = cboScheduleChange
        OnClick = cboScheduleClick
        OnKeyUp = cboScheduleKeyUp
        CharsNeedMatch = 1
      end
      object chkPRN: TCheckBox
        Left = 692
        Top = 46
        Width = 43
        Height = 18
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akTop, akRight]
        Caption = 'PRN'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 4
        OnClick = chkPRNClick
      end
      object btnXInsert: TButton
        Left = 577
        Top = 4
        Width = 78
        Height = 17
        Anchors = [akTop, akRight]
        Caption = 'Insert Row'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = btnXInsertClick
      end
      object btnXRemove: TButton
        Left = 662
        Top = 4
        Width = 79
        Height = 17
        Anchors = [akTop, akRight]
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
        TabOrder = 8
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
      TabOrder = 6
      Text = ''
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
      TabOrder = 2
      Text = ''
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
        OnEnter = txtXDurationEnter
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
      TabOrder = 3
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
        Text = ''
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
      Top = 249
      Width = 747
      Height = 202
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alBottom
      TabOrder = 1
      DesignSize = (
        747
        202)
      object lblComment: TLabel
        Left = 208
        Top = 6
        Width = 64
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Comments:'
      end
      object Label1: TLabel
        Left = 6
        Top = 58
        Width = 108
        Height = 13
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Statement/Explanation'
      end
      object Label2: TLabel
        Left = 12
        Top = 178
        Width = 51
        Height = 13
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Start Date:'
      end
      object Image1: TImage
        Left = 19
        Top = 21
        Width = 38
        Height = 38
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
      end
      object lblIndications: TLabel
        Left = 6
        Top = 6
        Width = 54
        Height = 16
        AutoSize = False
        Caption = 'Indication'
      end
      object memComment: TCaptionMemo
        Left = 280
        Top = 10
        Width = 461
        Height = 50
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alCustom
        Anchors = [akLeft, akTop, akRight]
        ScrollBars = ssVertical
        TabOrder = 3
        OnChange = ControlChange
        Caption = 'Comments'
      end
      object lblAdminSch: TMemo
        Left = 344
        Top = 120
        Width = 294
        Height = 15
        Anchors = [akLeft, akTop, akRight]
        Color = clCream
        ParentShowHint = False
        ReadOnly = True
        ScrollBars = ssVertical
        ShowHint = True
        TabOrder = 5
        Visible = False
      end
      object lblAdminTime: TStaticText
        Left = 329
        Top = 129
        Width = 4
        Height = 4
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabOrder = 0
        Visible = False
      end
      object calStart: TORDateBox
        Left = 79
        Top = 174
        Width = 178
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akLeft, akTop, akBottom]
        TabOrder = 6
        Text = 'Today'
        OnChange = ControlChange
        DateOnly = True
        RequireTime = False
        Caption = 'Effective Date'
      end
      object lbStatements: TORListBox
        Left = 12
        Top = 71
        Width = 729
        Height = 99
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Style = lbOwnerDrawFixed
        Anchors = [akLeft, akTop, akRight]
        ExtendedSelect = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        Caption = ''
        ItemTipColor = clWindow
        LongList = False
        CheckBoxes = True
        OnClickCheck = lbStatementsClickCheck
      end
      object memDrugMsg: TMemo
        Left = 91
        Top = 11
        Width = 641
        Height = 39
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akLeft, akRight, akBottom]
        Color = clCream
        Lines.Strings = (
          '')
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 7
        Visible = False
      end
      object cboIndication: TORComboBox
        Left = 6
        Top = 22
        Width = 205
        Height = 21
        Style = orcsDropDown
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
        MaxLength = 40
        Sorted = False
        SynonymChars = '<>'
        TabOrder = 1
        Text = ''
        OnChange = cboIndicationChange
        CharsNeedMatch = 1
      end
    end
    object cboXSequence: TORComboBox
      Left = 378
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
      TabOrder = 5
      Text = ''
      Visible = False
      OnChange = cboXSequenceChange
      OnEnter = cboXSequenceEnter
      OnExit = cboXSequenceExit
      OnKeyDown = memMessageKeyDown
      OnKeyUp = cboXSequenceKeyUp
      CharsNeedMatch = 1
    end
  end
  object btnSelect: TButton [4]
    Left = 807
    Top = 687
    Width = 89
    Height = 26
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    Enabled = False
    TabOrder = 5
    OnClick = btnSelectClick
  end
  inherited cmdAccept: TButton
    Left = 809
    Top = 687
    Width = 85
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Anchors = [akRight, akBottom]
    TabOrder = 6
    Visible = False
    ExplicitLeft = 809
    ExplicitTop = 687
    ExplicitWidth = 85
  end
  inherited cmdQuit: TButton
    Left = 816
    Top = 719
    Width = 60
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Anchors = [akRight, akBottom]
    TabOrder = 7
    ExplicitLeft = 816
    ExplicitTop = 719
    ExplicitWidth = 60
  end
  inherited pnlMessage: TPanel
    Left = 95
    Top = 300
    Width = 376
    Height = 40
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    ExplicitLeft = 95
    ExplicitTop = 300
    ExplicitWidth = 376
    ExplicitHeight = 40
    inherited imgMessage: TImage
      Left = 2
      Top = 2
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      ExplicitLeft = 2
      ExplicitTop = 2
    end
    inherited memMessage: TRichEdit
      Left = 37
      Top = 1
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      ExplicitLeft = 37
      ExplicitTop = 1
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 16
    Top = 556
    Data = (
      (
        'Component = pnlMeds'
        'Status = stsDefault')
      (
        'Component = lstQuick'
        'Status = stsDefault')
      (
        'Component = lstAll'
        'Status = stsDefault')
      (
        'Component = txtMed'
        'Text = Medication'
        'Status = stsOK')
      (
        'Component = pnlFields'
        'Status = stsDefault')
      (
        'Component = pnlTop'
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
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = memComment'
        'Status = stsDefault')
      (
        'Component = lblAdminTime'
        'Status = stsDefault')
      (
        'Component = calStart'
        'Status = stsDefault')
      (
        'Component = lbStatements'
        'Status = stsDefault')
      (
        'Component = memDrugMsg'
        'Status = stsDefault')
      (
        'Component = btnSelect'
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
        'Component = frmODMedNVA'
        'Status = stsDefault')
      (
        'Component = cboIndication'
        'Text = Indications for use'
        'Status = stsOK'))
  end
  object dlgStart: TORDateTimeDlg
    FMDateTime = 3001101.000000000000000000
    DateOnly = False
    RequireTime = True
    Left = 208
    Top = 553
  end
  object timCheckChanges: TTimer
    Enabled = False
    Interval = 500
    Left = 73
    Top = 557
  end
  object popDuration: TPopupMenu
    AutoHotkeys = maManual
    Left = 152
    Top = 553
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
