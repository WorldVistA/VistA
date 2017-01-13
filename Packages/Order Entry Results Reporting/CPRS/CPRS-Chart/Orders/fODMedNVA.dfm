inherited frmODMedNVA: TfrmODMedNVA
  Left = 203
  Top = 183
  Width = 632
  Height = 542
  Caption = 'Document Herbal/OTC/Non-VA Medications'
  Constraints.MinHeight = 449
  ExplicitWidth = 632
  ExplicitHeight = 542
  PixelsPerInch = 96
  TextHeight = 16
  inherited memOrder: TCaptionMemo
    Left = 0
    Top = 575
    Width = 646
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Anchors = [akLeft, akRight, akBottom]
    Constraints.MinWidth = 31
    TabOrder = 4
    ExplicitLeft = 0
    ExplicitTop = 575
    ExplicitWidth = 646
  end
  object pnlMeds: TPanel [1]
    Left = 7
    Top = 42
    Width = 730
    Height = 518
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    Caption = 'pnlMeds'
    TabOrder = 1
    object sptSelect: TSplitter
      Left = 0
      Top = 164
      Width = 730
      Height = 5
      Cursor = crVSplit
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
    end
    object lstQuick: TCaptionListView
      Left = 0
      Top = 0
      Width = 730
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
      Width = 730
      Height = 349
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
    Left = 6
    Top = 15
    Width = 734
    Height = 24
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
    Top = 53
    Width = 768
    Height = 521
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
      Width = 768
      Height = 319
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      Constraints.MinHeight = 98
      Constraints.MinWidth = 37
      TabOrder = 0
      DesignSize = (
        768
        319)
      object lblRoute: TLabel
        Left = 430
        Top = 28
        Width = 36
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akTop, akRight]
        Caption = 'Route'
        Visible = False
      end
      object lblSchedule: TLabel
        Left = 575
        Top = 28
        Width = 57
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akTop, akRight]
        Caption = 'Schedule'
        Visible = False
      end
      object lblGuideline: TStaticText
        Left = 0
        Top = 1
        Width = 224
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
        Left = 1
        Top = 23
        Width = 216
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabOrder = 4
        Tabs.Strings = (
          'Dosage')
        TabIndex = 0
        TabStop = False
        TabWidth = 86
        OnChange = tabDoseChange
      end
      object cboDosage: TORComboBox
        Left = 10
        Top = 44
        Width = 471
        Height = 267
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
        ItemHeight = 16
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
        Text = ''
        OnChange = cboDosageChange
        OnClick = cboDosageClick
        OnExit = cboDosageExit
        OnKeyUp = cboDosageKeyUp
        CharsNeedMatch = 1
      end
      object cboRoute: TORComboBox
        Left = 437
        Top = 44
        Width = 140
        Height = 269
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
        ItemHeight = 16
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
        Text = ''
        OnChange = cboRouteChange
        OnClick = ControlChange
        OnKeyUp = cboRouteKeyUp
        CharsNeedMatch = 1
      end
      object cboSchedule: TORComboBox
        Left = 575
        Top = 46
        Width = 193
        Height = 268
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
        ItemHeight = 16
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
        Text = ''
        OnChange = cboScheduleChange
        OnClick = cboScheduleClick
        OnKeyUp = cboScheduleKeyUp
        CharsNeedMatch = 1
      end
      object chkPRN: TCheckBox
        Left = 716
        Top = 48
        Width = 52
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
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
      Top = 319
      Width = 768
      Height = 202
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alBottom
      TabOrder = 1
      DesignSize = (
        768
        202)
      object lblComment: TLabel
        Left = 5
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
        Width = 136
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Statement/Explanation'
      end
      object Label2: TLabel
        Left = 12
        Top = 178
        Width = 62
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Start Date:'
      end
      object Image1: TImage
        Left = 31
        Top = 21
        Width = 38
        Height = 38
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
      end
      object memComment: TCaptionMemo
        Left = 79
        Top = 2
        Width = 688
        Height = 55
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alCustom
        Anchors = [akLeft, akTop, akRight]
        ScrollBars = ssVertical
        TabOrder = 2
        OnChange = ControlChange
        Caption = 'Comments'
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
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akLeft, akTop, akBottom]
        TabOrder = 5
        Text = 'Today'
        OnChange = ControlChange
        DateOnly = True
        RequireTime = False
        Caption = 'Effective Date'
      end
      object lbStatements: TORListBox
        Left = 9
        Top = 73
        Width = 742
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
        TabOrder = 3
        Caption = ''
        ItemTipColor = clWindow
        LongList = False
        CheckBoxes = True
        OnClickCheck = lbStatementsClickCheck
      end
      object memDrugMsg: TMemo
        Left = 78
        Top = 18
        Width = 656
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
        TabOrder = 6
        Visible = False
      end
    end
  end
  object btnSelect: TButton [4]
    Left = 663
    Top = 577
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
    Left = 665
    Top = 577
    Width = 85
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Anchors = [akRight, akBottom]
    TabOrder = 6
    Visible = False
    ExplicitLeft = 665
    ExplicitTop = 577
    ExplicitWidth = 85
  end
  inherited cmdQuit: TButton
    Left = 672
    Top = 609
    Width = 60
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Anchors = [akRight, akBottom]
    TabOrder = 7
    ExplicitLeft = 672
    ExplicitTop = 609
    ExplicitWidth = 60
  end
  inherited pnlMessage: TPanel
    Top = 295
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    ExplicitTop = 295
    inherited imgMessage: TImage
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
    end
    inherited memMessage: TRichEdit
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
    end
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
		'Text = Start Date/Time. Press the enter key to access.'
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
