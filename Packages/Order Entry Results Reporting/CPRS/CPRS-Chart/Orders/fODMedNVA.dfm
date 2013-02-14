inherited frmODMedNVA: TfrmODMedNVA
  Left = 203
  Top = 183
  Width = 632
  Height = 542
  Caption = 'Document Herbal/OTC/Non-VA Medications'
  Constraints.MinHeight = 365
  ExplicitWidth = 632
  ExplicitHeight = 542
  PixelsPerInch = 96
  TextHeight = 13
  inherited memOrder: TCaptionMemo
    Left = 0
    Top = 467
    Width = 525
    Anchors = [akLeft, akRight, akBottom]
    Constraints.MinWidth = 25
    TabOrder = 4
    ExplicitLeft = 0
    ExplicitTop = 467
    ExplicitWidth = 525
  end
  object pnlMeds: TPanel [1]
    Left = 6
    Top = 34
    Width = 593
    Height = 421
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    Caption = 'pnlMeds'
    TabOrder = 1
    object sptSelect: TSplitter
      Left = 0
      Top = 133
      Width = 593
      Height = 4
      Cursor = crVSplit
      Align = alTop
    end
    object lstQuick: TCaptionListView
      Left = 0
      Top = 0
      Width = 593
      Height = 133
      Align = alTop
      BevelInner = bvLowered
      BevelOuter = bvSpace
      Columns = <
        item
          Width = 420
        end>
      ColumnClick = False
      Constraints.MaxHeight = 165
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
      Caption = 'Quick Orders'
    end
    object lstAll: TCaptionListView
      Left = 0
      Top = 137
      Width = 593
      Height = 284
      Align = alClient
      Columns = <
        item
          Width = 420
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
      Caption = 'All Medication orders'
    end
  end
  object txtMed: TEdit [2]
    Left = 5
    Top = 12
    Width = 596
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
  object pnlFields: TPanel [3]
    Left = 3
    Top = 43
    Width = 624
    Height = 423
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    Enabled = False
    TabOrder = 2
    Visible = False
    object pnlTop: TPanel
      Left = 0
      Top = 0
      Width = 624
      Height = 259
      Align = alClient
      Constraints.MinHeight = 80
      Constraints.MinWidth = 30
      TabOrder = 0
      DesignSize = (
        624
        259)
      object lblRoute: TLabel
        Left = 349
        Top = 23
        Width = 29
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'Route'
        Visible = False
      end
      object lblSchedule: TLabel
        Left = 467
        Top = 23
        Width = 45
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'Schedule'
        Visible = False
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
        TabOrder = 4
        Tabs.Strings = (
          'Dosage')
        TabIndex = 0
        TabStop = False
        TabWidth = 86
        OnChange = tabDoseChange
      end
      object cboDosage: TORComboBox
        Left = 8
        Top = 36
        Width = 383
        Height = 217
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
        TabOrder = 1
        OnChange = cboDosageChange
        OnClick = cboDosageClick
        OnExit = cboDosageExit
        OnKeyUp = cboDosageKeyUp
        CharsNeedMatch = 1
      end
      object cboRoute: TORComboBox
        Left = 355
        Top = 36
        Width = 114
        Height = 218
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
        TabOrder = 2
        OnChange = cboRouteChange
        OnClick = ControlChange
        OnKeyUp = cboRouteKeyUp
        CharsNeedMatch = 1
      end
      object cboSchedule: TORComboBox
        Left = 467
        Top = 37
        Width = 157
        Height = 218
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
        TabOrder = 3
        OnChange = cboScheduleChange
        OnClick = cboScheduleClick
        OnKeyUp = cboScheduleKeyUp
        CharsNeedMatch = 1
      end
      object chkPRN: TCheckBox
        Left = 582
        Top = 39
        Width = 42
        Height = 17
        Anchors = [akTop, akRight]
        Caption = 'PRN'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 5
        OnClick = chkPRNClick
      end
    end
    object pnlBottom: TPanel
      Left = 0
      Top = 259
      Width = 624
      Height = 164
      Align = alBottom
      TabOrder = 1
      DesignSize = (
        624
        164)
      object lblComment: TLabel
        Left = 4
        Top = 5
        Width = 52
        Height = 16
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Comments:'
      end
      object Label1: TLabel
        Left = 5
        Top = 47
        Width = 108
        Height = 13
        Caption = 'Statement/Explanation'
      end
      object Label2: TLabel
        Left = 10
        Top = 145
        Width = 51
        Height = 13
        Caption = 'Start Date:'
      end
      object Image1: TImage
        Left = 25
        Top = 17
        Width = 31
        Height = 31
      end
      object memComment: TCaptionMemo
        Left = 64
        Top = 2
        Width = 559
        Height = 44
        Align = alCustom
        Anchors = [akLeft, akTop, akRight]
        ScrollBars = ssVertical
        TabOrder = 2
        OnChange = ControlChange
        Caption = 'Comments'
      end
      object lblAdminTime: TStaticText
        Left = 267
        Top = 105
        Width = 4
        Height = 4
        TabOrder = 0
        Visible = False
      end
      object calStart: TORDateBox
        Left = 64
        Top = 141
        Width = 145
        Height = 21
        Anchors = [akLeft, akTop, akBottom]
        TabOrder = 5
        Text = 'Today'
        OnChange = ControlChange
        DateOnly = True
        RequireTime = False
        Caption = 'Effective Date'
      end
      object lbStatements: TORListBox
        Left = 7
        Top = 59
        Width = 603
        Height = 81
        Style = lbOwnerDrawFixed
        Anchors = [akLeft, akTop, akRight]
        ExtendedSelect = False
        ItemHeight = 16
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        ItemTipColor = clWindow
        LongList = False
        CheckBoxes = True
        OnClickCheck = lbStatementsClickCheck
      end
      object memDrugMsg: TMemo
        Left = 63
        Top = 15
        Width = 533
        Height = 31
        Anchors = [akLeft, akRight, akBottom]
        Color = clCream
        Lines.Strings = (
          '')
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 6
        Visible = False
      end
    end
  end
  object btnSelect: TButton [4]
    Left = 539
    Top = 469
    Width = 72
    Height = 21
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    Enabled = False
    TabOrder = 5
    OnClick = btnSelectClick
  end
  inherited cmdAccept: TButton
    Left = 540
    Top = 469
    Width = 69
    Anchors = [akRight, akBottom]
    TabOrder = 6
    Visible = False
    ExplicitLeft = 540
    ExplicitTop = 469
    ExplicitWidth = 69
  end
  inherited cmdQuit: TButton
    Left = 546
    Top = 495
    Width = 49
    Anchors = [akRight, akBottom]
    TabOrder = 7
    ExplicitLeft = 546
    ExplicitTop = 495
    ExplicitWidth = 49
  end
  inherited pnlMessage: TPanel
    Top = 240
    ExplicitTop = 240
  end
  inherited amgrMain: TVA508AccessibilityManager
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
        'Status = stsDefault'))
  end
  object dlgStart: TORDateTimeDlg
    FMDateTime = 3001101.000000000000000000
    DateOnly = False
    RequireTime = True
    Left = 500
    Top = 201
  end
  object timCheckChanges: TTimer
    Enabled = False
    Interval = 500
    Left = 501
    Top = 233
  end
end
