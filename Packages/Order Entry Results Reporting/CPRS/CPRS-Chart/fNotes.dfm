inherited frmNotes: TfrmNotes
  Left = 0
  Caption = 'frmNotes'
  ClientHeight = 673
  ClientWidth = 1085
  DockSite = True
  Menu = mnuNotes
  Position = poDesigned
  OnDestroy = FormDestroy
  OnShow = FormShow
  ExplicitTop = -18
  ExplicitWidth = 1101
  ExplicitHeight = 731
  PixelsPerInch = 96
  TextHeight = 13
  inherited shpPageBottom: TShape
    Top = 668
    Width = 1085
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    ExplicitTop = 668
    ExplicitWidth = 1085
  end
  object splHorz: TSplitter [1]
    Left = 161
    Top = 0
    Height = 668
    Color = clBtnFace
    ParentColor = False
    OnCanResize = splHorzCanResize
    ExplicitLeft = 185
    ExplicitTop = -7
    ExplicitHeight = 663
  end
  object pnlLeft: TPanel [2]
    Left = 0
    Top = 0
    Width = 161
    Height = 668
    Align = alLeft
    BevelOuter = bvNone
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 1
    object cmdNewNote: TORAlignButton
      Left = 0
      Top = 647
      Width = 161
      Height = 21
      Action = acNewNote
      Align = alBottom
      Caption = 'New Note'
      TabOrder = 2
      ExplicitLeft = -3
      ExplicitTop = 653
    end
    object cmdPCE: TORAlignButton
      Left = 0
      Top = 626
      Width = 161
      Height = 21
      Action = acPCE
      Align = alBottom
      Caption = 'Encounter'
      TabOrder = 3
      ExplicitTop = 647
    end
    object pnlLeftTop: TPanel
      Left = 0
      Top = 15
      Width = 161
      Height = 611
      Align = alClient
      BevelOuter = bvNone
      Color = clWindow
      DoubleBuffered = True
      ParentBackground = False
      ParentDoubleBuffered = False
      TabOrder = 1
      object splDrawers: TSplitter
        Left = 0
        Top = 585
        Width = 161
        Height = 3
        Cursor = crVSplit
        Align = alBottom
        Color = clBtnFace
        ParentColor = False
        OnCanResize = splDrawersCanResize
        ExplicitTop = 598
        ExplicitWidth = 335
      end
      object tvNotes: TORTreeView
        Left = 0
        Top = 0
        Width = 161
        Height = 585
        Align = alClient
        Constraints.MinHeight = 50
        Constraints.MinWidth = 30
        HideSelection = False
        Images = dmodShared.imgNotes
        Indent = 19
        PopupMenu = popNoteList
        ReadOnly = True
        StateImages = dmodShared.imgImages
        TabOrder = 0
        OnChange = tvNotesChange
        OnCollapsed = tvNotesCollapsed
        OnDragDrop = tvNotesDragDrop
        OnDragOver = tvNotesDragOver
        OnExpanded = tvNotesExpanded
        OnStartDrag = tvNotesStartDrag
        Caption = ''
        NodePiece = 0
        ShortNodeCaptions = True
      end
      object pnlDrawers: TPanel
        Left = 0
        Top = 588
        Width = 161
        Height = 23
        Align = alBottom
        BevelOuter = bvNone
        ParentBackground = False
        TabOrder = 1
        Visible = False
        OnResize = pnlDrawersResize
        inline frmDrawers: TfraDrawers
          Left = 0
          Top = 0
          Width = 161
          Height = 23
          Align = alClient
          Constraints.MinWidth = 150
          Color = clBtnFace
          ParentBackground = False
          ParentColor = False
          TabOrder = 0
          TabStop = True
          OnResize = frmDrawersResize
          ExplicitWidth = 161
          ExplicitHeight = 23
          inherited pnlTemplate: TPanel
            Width = 161
            ExplicitWidth = 161
            inherited pnlTemplates: TPanel
              Width = 161
              TabOrder = 1
              ExplicitWidth = 161
              inherited tvTemplates: TORTreeView
                Width = 161
                ExplicitWidth = 161
              end
              inherited pnlTemplateSearch: TPanel
                Width = 161
                ExplicitWidth = 161
                DesignSize = (
                  161
                  41)
                inherited edtSearch: TCaptionEdit
                  Width = 106
                  TabOrder = 1
                  ExplicitWidth = 106
                end
                inherited btnFind: TORAlignButton
                  Left = 106
                  ExplicitLeft = 106
                end
                inherited cbWholeWords: TCheckBox
                  Left = 90
                  Top = 24
                  TabOrder = 4
                  ExplicitLeft = 90
                  ExplicitTop = 24
                end
                inherited cbMatchCase: TCheckBox
                  Top = 24
                  TabOrder = 3
                  ExplicitTop = 24
                end
              end
            end
            inherited btnTemplate: TBitBtn
              Top = 0
              Width = 161
              TabOrder = 0
              ExplicitTop = 0
              ExplicitWidth = 161
            end
          end
          inherited pnlEncounter: TPanel
            Width = 161
            ExplicitWidth = 161
            inherited btnEncounter: TBitBtn
              Width = 161
              ExplicitWidth = 161
            end
            inherited pnlEncounters: TPanel
              Width = 161
              ExplicitWidth = 161
              inherited lbEncounter: TORListBox
                Width = 161
                ExplicitWidth = 161
              end
            end
          end
          inherited pnlReminder: TPanel
            Width = 161
            ExplicitWidth = 161
            inherited btnReminder: TBitBtn
              Width = 161
              ExplicitWidth = 161
            end
            inherited pnlReminders: TPanel
              Width = 161
              ExplicitWidth = 161
              inherited tvReminders: TORTreeView
                Width = 161
                TabOrder = 1
                ExplicitWidth = 161
              end
            end
          end
          inherited pnlOrder: TPanel
            Width = 161
            ExplicitWidth = 161
            inherited btnOrder: TBitBtn
              Width = 161
              ExplicitWidth = 161
            end
            inherited pnlOrders: TPanel
              Width = 161
              ExplicitWidth = 161
              inherited lbOrders: TORListBox
                Width = 161
                ExplicitWidth = 161
              end
            end
          end
        end
      end
      object lstNotes: TORListBox
        Left = 20
        Top = 6
        Width = 64
        Height = 18
        TabStop = False
        Ctl3D = True
        ItemHeight = 13
        ParentCtl3D = False
        ParentShowHint = False
        PopupMenu = popNoteList
        ShowHint = True
        TabOrder = 2
        Visible = False
        OnClick = lstNotesClick
        Caption = ''
        ItemTipColor = clWindow
        LongList = False
        Pieces = '2,3'
        TabPositions = '10'
      end
    end
    object stNotes: TVA508StaticText
      Name = 'stNotes'
      Left = 0
      Top = 0
      Width = 161
      Height = 15
      Align = alTop
      Alignment = taLeftJustify
      AutoSize = True
      Caption = 'Last 100 Notes'
      TabOrder = 0
      VerticalAlignment = taAlignBottom
      ShowAccelChar = True
    end
  end
  object pnlReminder: TPanel [3]
    Left = 1053
    Top = 236
    Width = 27
    Height = 38
    BevelOuter = bvNone
    TabOrder = 0
    Visible = False
  end
  object PnlRight: TPanel [4]
    Left = 164
    Top = 0
    Width = 921
    Height = 668
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object splVert: TSplitter
      Left = 0
      Top = 557
      Width = 921
      Height = 3
      Cursor = crVSplit
      Align = alBottom
      Color = clBtnFace
      ParentColor = False
      ExplicitTop = 0
      ExplicitWidth = 924
    end
    object memPCEShow: TRichEdit
      Left = 0
      Top = 560
      Width = 921
      Height = 108
      Align = alBottom
      Color = clCream
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Lines.Strings = (
        '<No encounter information entered>')
      ParentFont = False
      PlainText = True
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 2
    end
    object pnlWrite: TPanel
      Left = 0
      Top = 0
      Width = 921
      Height = 557
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      Visible = False
      OnResize = pnlWriteResize
      object memNewNote: TRichEdit
        Left = 0
        Top = 67
        Width = 921
        Height = 490
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        MaxLength = 2147483645
        ParentFont = False
        PlainText = True
        PopupMenu = popNoteMemo
        ScrollBars = ssVertical
        TabOrder = 1
        WantTabs = True
        OnKeyDown = memNewNoteKeyDown
        OnKeyPress = memNewNoteKeyPress
        OnKeyUp = memNewNoteKeyUp
      end
      object pnlFields: TPanel
        Left = 0
        Top = 0
        Width = 921
        Height = 67
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        DesignSize = (
          921
          67)
        object bvlNewTitle: TBevel
          AlignWithMargins = True
          Left = 6
          Top = -2
          Width = 117
          Height = 17
        end
        object lblNewTitle: TStaticText
          AlignWithMargins = True
          Left = 6
          Top = -2
          Width = 119
          Height = 17
          Hint = 'Press "Change..." to select a different title.'
          Caption = ' General Medicine Note '
          Color = clCream
          ParentColor = False
          ParentShowHint = False
          ShowAccelChar = False
          ShowHint = True
          TabOrder = 1
          Transparent = False
        end
        object stRefDate: TStaticText
          AlignWithMargins = True
          Left = 0
          Top = 21
          Width = 919
          Height = 17
          Hint = 'Press "Change..." to change date/time of note.'
          Alignment = taCenter
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          ParentShowHint = False
          ShowAccelChar = False
          ShowHint = True
          TabOrder = 2
        end
        object stAuthor: TStaticText
          AlignWithMargins = True
          Left = 675
          Top = 6
          Width = 169
          Height = 17
          Hint = 'Press "Change..." to select a different author.'
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          AutoSize = False
          Caption = 'Winchester,Charles Emerson III'
          Color = clBtnFace
          ParentColor = False
          ParentShowHint = False
          ShowAccelChar = False
          ShowHint = True
          TabOrder = 0
          Transparent = False
        end
        object lblVisit: TStaticText
          AlignWithMargins = True
          Left = 6
          Top = 21
          Width = 204
          Height = 17
          Caption = 'Vst: 10/20/99 Pulmonary Clinic, Dr. Welby'
          Color = clBtnFace
          ParentColor = False
          ShowAccelChar = False
          TabOrder = 4
          Transparent = False
        end
        object stCosigner: TStaticText
          AlignWithMargins = True
          Left = 568
          Top = 22
          Width = 276
          Height = 16
          Hint = 'Press "Change..." to select a different cosigner.'
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          AutoSize = False
          Caption = 'Expected Cosigner: Winchester,Charles Emerson III'
          Color = clBtnFace
          ParentColor = False
          ParentShowHint = False
          ShowAccelChar = False
          ShowHint = True
          TabOrder = 5
          Transparent = False
        end
        object lblSubject: TStaticText
          Left = 6
          Top = 43
          Width = 43
          Height = 17
          Caption = 'Subject:'
          TabOrder = 8
        end
        object cmdChange: TButton
          AlignWithMargins = True
          Left = 855
          Top = 8
          Width = 58
          Height = 27
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Action = acChange
          Anchors = [akTop, akRight]
          Constraints.MaxHeight = 57
          TabOrder = 3
        end
        object txtSubject: TCaptionEdit
          Left = 48
          Top = 40
          Width = 1306
          Height = 21
          Hint = 'Subject is limited to a maximum of 80 characters.'
          Anchors = [akLeft, akTop, akRight]
          MaxLength = 80
          ParentShowHint = False
          ShowHint = True
          TabOrder = 6
          Text = 'txtSubject'
          Caption = 'Subject'
        end
      end
    end
    object pnlNote: TPanel
      Left = 0
      Top = 0
      Width = 921
      Height = 557
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object splList: TSplitter
        Left = 0
        Top = 118
        Width = 921
        Height = 3
        Cursor = crVSplit
        Align = alTop
        Color = clBtnFace
        ParentColor = False
        ExplicitWidth = 924
      end
      object memNote: TRichEdit
        Left = 0
        Top = 121
        Width = 921
        Height = 436
        Align = alClient
        Color = clCream
        Ctl3D = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        Lines.Strings = (
          
            'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRUSTVWXYZabcdefghijkl' +
            'mnopqrstuvwxyz12')
        ParentCtl3D = False
        ParentFont = False
        PlainText = True
        PopupMenu = popNoteMemo
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 2
        WordWrap = False
      end
      object stTitle: TVA508StaticText
        Name = 'stTitle'
        Left = 0
        Top = 0
        Width = 921
        Height = 15
        Align = alTop
        Alignment = taLeftJustify
        Caption = 'No Progress Notes Found'
        TabOrder = 0
        VerticalAlignment = taAlignBottom
        ShowAccelChar = True
      end
      object lvNotes: TCaptionListView
        Left = 0
        Top = 15
        Width = 921
        Height = 103
        Align = alTop
        Columns = <
          item
            Caption = 'Date'
            Width = 100
          end
          item
            AutoSize = True
            Caption = 'Title'
          end
          item
            AutoSize = True
            Caption = 'Subject'
          end
          item
            AutoSize = True
            Caption = 'Author'
          end
          item
            AutoSize = True
            Caption = 'Location'
          end
          item
            Caption = 'fmdate'
            Width = 0
          end
          item
            Caption = 'TIUDA'
            Width = 0
          end>
        Constraints.MinHeight = 50
        HideSelection = False
        ReadOnly = True
        RowSelect = True
        SmallImages = dmodShared.imgNotes
        StateImages = dmodShared.imgImages
        TabOrder = 1
        ViewStyle = vsReport
        Visible = False
        OnColumnClick = lvNotesColumnClick
        OnCompare = lvNotesCompare
        OnSelectItem = lvNotesSelectItem
        AutoSize = False
        Caption = 'No Progress Notes Found'
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 24
    Top = 184
    Data = (
      (
        'Component = frmNotes'
        'Status = stsDefault')
      (
        'Component = pnlReminder'
        'Status = stsDefault')
      (
        'Component = stNotes'
        'Status = stsDefault')
      (
        'Component = pnlWrite'
        'Status = stsDefault')
      (
        'Component = memNewNote'
        'Status = stsDefault')
      (
        'Component = pnlFields'
        'Status = stsDefault')
      (
        'Component = stRefDate'
        'Status = stsDefault')
      (
        'Component = stAuthor'
        'Status = stsDefault')
      (
        'Component = lblVisit'
        'Status = stsDefault')
      (
        'Component = stCosigner'
        'Status = stsDefault')
      (
        'Component = lblSubject'
        'Status = stsDefault')
      (
        'Component = lblNewTitle'
        'Status = stsDefault')
      (
        'Component = cmdChange'
        'Status = stsDefault')
      (
        'Component = txtSubject'
        'Status = stsDefault')
      (
        'Component = stTitle'
        'Status = stsDefault')
      (
        'Component = tvNotes'
        'Status = stsDefault')
      (
        'Component = cmdNewNote'
        'Status = stsDefault')
      (
        'Component = cmdPCE'
        'Status = stsDefault')
      (
        'Component = lvNotes'
        'Status = stsDefault')
      (
        'Component = memPCEShow'
        'Status = stsDefault')
      (
        'Component = lstNotes'
        'Status = stsDefault')
      (
        'Component = pnlLeft'
        'Status = stsDefault')
      (
        'Component = pnlDrawers'
        'Status = stsDefault')
      (
        'Component = frmDrawers'
        'Status = stsDefault')
      (
        'Component = frmDrawers.pnlTemplate'
        'Status = stsDefault')
      (
        'Component = frmDrawers.pnlTemplates'
        'Status = stsDefault')
      (
        'Component = frmDrawers.tvTemplates'
        'Status = stsDefault')
      (
        'Component = frmDrawers.pnlTemplateSearch'
        'Status = stsDefault')
      (
        'Component = frmDrawers.edtSearch'
        'Status = stsDefault')
      (
        'Component = frmDrawers.btnFind'
        'Status = stsDefault')
      (
        'Component = frmDrawers.cbWholeWords'
        'Status = stsDefault')
      (
        'Component = frmDrawers.cbMatchCase'
        'Status = stsDefault')
      (
        'Component = frmDrawers.btnTemplate'
        'Status = stsDefault')
      (
        'Component = frmDrawers.pnlEncounter'
        'Status = stsDefault')
      (
        'Component = frmDrawers.btnEncounter'
        'Status = stsDefault')
      (
        'Component = frmDrawers.pnlEncounters'
        'Status = stsDefault')
      (
        'Component = frmDrawers.lbEncounter'
        'Status = stsDefault')
      (
        'Component = frmDrawers.pnlReminder'
        'Status = stsDefault')
      (
        'Component = frmDrawers.btnReminder'
        'Status = stsDefault')
      (
        'Component = frmDrawers.pnlReminders'
        'Status = stsDefault')
      (
        'Component = frmDrawers.tvReminders'
        'Status = stsDefault')
      (
        'Component = frmDrawers.pnlOrder'
        'Status = stsDefault')
      (
        'Component = frmDrawers.btnOrder'
        'Status = stsDefault')
      (
        'Component = frmDrawers.pnlOrders'
        'Status = stsDefault')
      (
        'Component = frmDrawers.lbOrders'
        'Status = stsDefault')
      (
        'Component = pnlNote'
        'Status = stsDefault')
      (
        'Component = memNote'
        'Status = stsDefault')
      (
        'Component = pnlLeftTop'
        'Status = stsDefault')
      (
        'Component = PnlRight'
        'Status = stsDefault'))
  end
  object fldAccessReminders: TVA508ComponentAccessibility
    Component = frmDrawers.btnTemplate
    ComponentName = 'Drawer'
    Left = 72
    Top = 64
  end
  object imgLblReminders: TVA508ImageListLabeler
    Components = <
      item
      end>
    Labels = <>
    RemoteLabeler = dmodShared.imgLblReminders
    Left = 104
    Top = 64
  end
  object imgLblTemplates: TVA508ImageListLabeler
    Components = <
      item
      end>
    Labels = <>
    RemoteLabeler = dmodShared.imgLblHealthFactorLabels
    Left = 104
    Top = 96
  end
  object fldAccessTemplates: TVA508ComponentAccessibility
    Component = cmdPCE
    ComponentName = 'Drawer'
    Left = 72
    Top = 96
  end
  object imgLblNotes: TVA508ImageListLabeler
    Components = <
      item
      end
      item
      end>
    Labels = <>
    RemoteLabeler = dmodShared.imgLblNotes
    Left = 104
    Top = 139
  end
  object imgLblImages: TVA508ImageListLabeler
    Components = <
      item
      end
      item
      end>
    Labels = <>
    RemoteLabeler = dmodShared.imgLblImages
    Left = 104
    Top = 163
  end
  object mnuNotes: TMainMenu
    Left = 465
    Top = 624
    object mnuView: TMenuItem
      Caption = '&View'
      GroupIndex = 3
      object mnuViewChart: TMenuItem
        Caption = 'Chart &Tab'
        object mnuChartCover: TMenuItem
          Tag = 1
          Caption = 'Cover &Sheet'
          ShortCut = 16467
          OnClick = mnuChartTabClick
        end
        object mnuChartProbs: TMenuItem
          Tag = 2
          Caption = '&Problem List'
          ShortCut = 16464
          OnClick = mnuChartTabClick
        end
        object mnuChartMeds: TMenuItem
          Tag = 3
          Caption = '&Medications'
          ShortCut = 16461
          OnClick = mnuChartTabClick
        end
        object mnuChartOrders: TMenuItem
          Tag = 4
          Caption = '&Orders'
          ShortCut = 16463
          OnClick = mnuChartTabClick
        end
        object mnuChartNotes: TMenuItem
          Tag = 6
          Caption = 'Progress &Notes'
          ShortCut = 16462
          OnClick = mnuChartTabClick
        end
        object mnuChartCslts: TMenuItem
          Tag = 7
          Caption = 'Consul&ts'
          ShortCut = 16468
          OnClick = mnuChartTabClick
        end
        object mnuChartSurgery: TMenuItem
          Tag = 11
          Caption = 'S&urgery'
          ShortCut = 16469
          OnClick = mnuChartTabClick
        end
        object mnuChartDCSumm: TMenuItem
          Tag = 8
          Caption = '&Discharge Summaries'
          ShortCut = 16452
          OnClick = mnuChartTabClick
        end
        object mnuChartLabs: TMenuItem
          Tag = 9
          Caption = '&Laboratory'
          ShortCut = 16460
          OnClick = mnuChartTabClick
        end
        object mnuChartReports: TMenuItem
          Tag = 10
          Caption = '&Reports'
          ShortCut = 16466
          OnClick = mnuChartTabClick
        end
      end
      object mnuViewInformation: TMenuItem
        Caption = 'Information'
        object mnuViewDemo: TMenuItem
          Tag = 1
          Action = acViewDemo
        end
        object mnuViewVisits: TMenuItem
          Tag = 2
          Action = acViewVisits
        end
        object mnuViewPrimaryCare: TMenuItem
          Tag = 3
          Action = acViewPrimaryCare
        end
        object mnuViewMyHealtheVet: TMenuItem
          Tag = 4
          Action = acViewHealthEVet
        end
        object mnuInsurance: TMenuItem
          Tag = 5
          Action = acViewInsurance
        end
        object mnuViewFlags: TMenuItem
          Tag = 6
          Action = acViewFlags
        end
        object mnuViewRemoteData: TMenuItem
          Tag = 7
          Action = acViewRemote
        end
        object mnuViewReminders: TMenuItem
          Tag = 8
          Action = acViewReminders
        end
        object mnuViewPostings: TMenuItem
          Tag = 9
          Action = acViewPostings
        end
      end
      object Z3: TMenuItem
        Caption = '-'
      end
      object mnuViewAll: TMenuItem
        Tag = 1
        Action = acSignedAll
      end
      object mnuViewByAuthor: TMenuItem
        Tag = 4
        Action = acSignedByAuthor
      end
      object mnuViewByDate: TMenuItem
        Tag = 5
        Action = acSignedDate
      end
      object mnuViewUncosigned: TMenuItem
        Tag = 3
        Action = acUncosigned
      end
      object mnuViewUnsigned: TMenuItem
        Tag = 2
        Action = acUnsigned
      end
      object mnuViewCustom: TMenuItem
        Tag = 6
        Action = acCustomView
      end
      object mnuSearchForText: TMenuItem
        Tag = 7
        Action = acSearchWithin
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object mnuViewSaveAsDefault: TMenuItem
        Action = acViewSaveDefault
      end
      object mnuReturntoDefault: TMenuItem
        Action = acViewReturnDefault
      end
      object Z1: TMenuItem
        Caption = '-'
      end
      object mnuViewDetail: TMenuItem
        Action = acViewDetails
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object mnuIconLegend: TMenuItem
        Action = acIconLegend
      end
    end
    object mnuAct: TMenuItem
      Caption = '&Action'
      GroupIndex = 4
      object mnuActNew: TMenuItem
        Action = acNewNote
      end
      object mnuActAddend: TMenuItem
        Action = acAddendum
        ShortCut = 24653
      end
      object mnuActAddIDEntry: TMenuItem
        Action = acAddNewEntryIDN
      end
      object mnuActAttachtoIDParent: TMenuItem
        Action = acAttachIDN
      end
      object mnuActDetachFromIDParent: TMenuItem
        Action = acDetachIDN
      end
      object mnuEncounter: TMenuItem
        Action = acPCE
        Caption = 'Encounte&r'
        ShortCut = 24658
      end
      object Z4: TMenuItem
        Caption = '-'
      end
      object mnuActChange: TMenuItem
        Action = acChangeTitle
      end
      object mnuActLoadBoiler: TMenuItem
        Action = acReloadBoiler
      end
      object Z2: TMenuItem
        Caption = '-'
      end
      object mnuActSignList: TMenuItem
        Action = acAddSignList
      end
      object mnuActDelete: TMenuItem
        Action = acDeleteNote
        ShortCut = 24644
      end
      object mnuActEdit: TMenuItem
        Action = acEditNote
        ShortCut = 24645
      end
      object mnuActSave: TMenuItem
        Action = acSaveNoSig
        ShortCut = 24641
      end
      object mnuActSign: TMenuItem
        Action = acSign
        ShortCut = 24647
      end
      object mnuActIdentifyAddlSigners: TMenuItem
        Action = acIDAddlSign
      end
    end
    object mnuOptions: TMenuItem
      Caption = '&Options'
      GroupIndex = 4
      object mnuEditTemplates: TMenuItem
        Action = acEditTemplate
      end
      object mnuNewTemplate: TMenuItem
        Action = acNewTemplate
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object mnuEditSharedTemplates: TMenuItem
        Action = acEditShared
      end
      object mnuNewSharedTemplate: TMenuItem
        Action = acNewShared
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object mnuEditDialgFields: TMenuItem
        Action = acEditDialogFields
      end
    end
  end
  object timAutoSave: TTimer
    Enabled = False
    Interval = 300000
    OnTimer = timAutoSaveTimer
    Left = 1040
    Top = 627
  end
  object dlgReplaceText: TReplaceDialog
    OnFind = dlgReplaceTextFind
    OnReplace = dlgReplaceTextReplace
    Left = 229
    Top = 624
  end
  object dlgFindText: TFindDialog
    Options = [frDown, frHideUpDown]
    OnFind = dlgFindTextFind
    Left = 308
    Top = 624
  end
  object popNoteList: TPopupMenu
    OnPopup = popNoteListPopup
    Left = 540
    Top = 625
    object popNoteListAll: TMenuItem
      Tag = 1
      Action = acSignedAll
    end
    object popNoteListByAuthor: TMenuItem
      Tag = 4
      Action = acSignedByAuthor
    end
    object popNoteListByDate: TMenuItem
      Tag = 5
      Action = acSignedDate
    end
    object popNoteListUncosigned: TMenuItem
      Tag = 3
      Action = acUncosigned
    end
    object popNoteListUnsigned: TMenuItem
      Tag = 2
      Action = acUnsigned
    end
    object popNoteListCustom: TMenuItem
      Tag = 6
      Action = acCustomView
    end
    object popSearchForText: TMenuItem
      Tag = 7
      Action = acSearchWithin
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object popNoteListExpandSelected: TMenuItem
      Caption = '&Expand Selected'
      OnClick = popNoteListExpandSelectedClick
    end
    object popNoteListExpandAll: TMenuItem
      Caption = 'E&xpand All'
      OnClick = popNoteListExpandAllClick
    end
    object popNoteListCollapseSelected: TMenuItem
      Caption = 'C&ollapse Selected'
      OnClick = popNoteListCollapseSelectedClick
    end
    object popNoteListCollapseAll: TMenuItem
      Caption = 'Co&llapse All'
      OnClick = popNoteListCollapseAllClick
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object popNoteListAddIDEntry: TMenuItem
      Action = acAddNewEntryIDN
    end
    object popNoteListAttachtoIDParent: TMenuItem
      Action = acAttachIDN
    end
    object popNoteListDetachFromIDParent: TMenuItem
      Action = acDetachIDN
    end
  end
  object popNoteMemo: TPopupMenu
    OnPopup = popNoteMemoPopup
    Left = 620
    Top = 624
    object popNoteMemoCut: TMenuItem
      Caption = 'Cu&t'
      ShortCut = 16472
      OnClick = popNoteMemoCutClick
    end
    object popNoteMemoCopy: TMenuItem
      Caption = '&Copy'
      ShortCut = 16451
      OnClick = popNoteMemoCopyClick
    end
    object popNoteMemoPaste: TMenuItem
      Caption = '&Paste'
      ShortCut = 16470
      OnClick = popNoteMemoPasteClick
    end
    object popNoteMemoPaste2: TMenuItem
      Caption = 'Paste2'
      ShortCut = 8237
      Visible = False
      OnClick = popNoteMemoPasteClick
    end
    object popNoteMemoReformat: TMenuItem
      Caption = 'Reformat Paragraph'
      ShortCut = 24658
      OnClick = popNoteMemoReformatClick
    end
    object popNoteMemoSaveContinue: TMenuItem
      Caption = 'Save && Continue Editing'
      ShortCut = 24659
      Visible = False
      OnClick = popNoteMemoSaveContinueClick
    end
    object Z11: TMenuItem
      Caption = '-'
    end
    object popNoteMemoFind: TMenuItem
      Caption = '&Find in Selected Note'
      OnClick = popNoteMemoFindClick
    end
    object popNoteMemoReplace: TMenuItem
      Caption = '&Replace Text'
      OnClick = popNoteMemoReplaceClick
    end
    object N7: TMenuItem
      Caption = '-'
    end
    object popNoteMemoGrammar: TMenuItem
      Caption = 'Check &Grammar'
      OnClick = popNoteMemoGrammarClick
    end
    object popNoteMemoSpell: TMenuItem
      Caption = 'C&heck Spelling'
      OnClick = popNoteMemoSpellClick
    end
    object Z12: TMenuItem
      Caption = '-'
    end
    object popNoteMemoTemplate: TMenuItem
      Caption = 'Copy into New &Template'
      OnClick = popNoteMemoTemplateClick
    end
    object Z10: TMenuItem
      Caption = '-'
    end
    object popNoteMemoSignList: TMenuItem
      Action = acAddSignList
    end
    object popNoteMemoDelete: TMenuItem
      Action = acDeleteNote
    end
    object popNoteMemoEdit: TMenuItem
      Action = acEditNote
    end
    object popNoteMemoAddend: TMenuItem
      Action = acAddendum
    end
    object popNoteMemoSave: TMenuItem
      Action = acSaveNoSig
    end
    object popNoteMemoSign: TMenuItem
      Action = acSign
    end
    object popNoteMemoAddlSign: TMenuItem
      Action = acIDAddlSign
    end
    object N8: TMenuItem
      Caption = '-'
    end
    object popNoteMemoPreview: TMenuItem
      Caption = 'Previe&w/Print Template'
      ShortCut = 16471
      OnClick = popNoteMemoPreviewClick
    end
    object popNoteMemoInsTemplate: TMenuItem
      Caption = '&Insert Template'
      ShortCut = 16429
      OnClick = popNoteMemoInsTemplateClick
    end
    object popNoteMemoEncounter: TMenuItem
      Action = acPCE
      ShortCut = 16453
    end
    object popNoteMemoViewCslt: TMenuItem
      Caption = 'View Consult Details'
      ShortCut = 24661
      OnClick = popNoteMemoViewCsltClick
    end
  end
  object ActionList: TActionList
    Left = 816
    Top = 624
    object acNewNote: TAction
      Category = 'Buttons'
      Caption = '&New Progress Note...'
      Hint = 'Creates a new progress note'
      ShortCut = 24654
      OnExecute = acNewNoteExecute
      OnUpdate = acNewNoteUpdate
    end
    object acPCE: TAction
      Category = 'Buttons'
      Caption = 'Edit Encounter Information'
      OnExecute = acPCEExecute
    end
    object acAddendum: TAction
      Category = 'Action'
      Caption = '&Make Addendum...'
      Hint = 'Makes an addendum for the currently selected note'
      OnExecute = acAddendumExecute
    end
    object acAddNewEntryIDN: TAction
      Category = 'Action'
      Caption = 'Add Ne&w Entry to Interdisciplinary Note'
      OnExecute = acAddNewEntryIDNExecute
    end
    object acAttachIDN: TAction
      Category = 'Action'
      Caption = 'A&ttach to Interdisciplinary Note'
      OnExecute = acAttachIDNExecute
    end
    object acDetachIDN: TAction
      Category = 'Action'
      Caption = 'Detac&h from Interdisciplinary Note'
      OnExecute = acDetachIDNExecute
    end
    object acChangeTitle: TAction
      Category = 'Action'
      Caption = '&Change Title...'
      ShortCut = 24643
      OnExecute = acChangeTitleExecute
    end
    object acReloadBoiler: TAction
      Category = 'Action'
      Caption = 'Reload &Boilerplate Text'
      OnExecute = acReloadBoilerExecute
    end
    object acAddSignList: TAction
      Category = 'Action'
      Caption = 'Add to Signature &List'
      Hint = 'Adds the currently displayed note to list of things to be signed'
      OnExecute = acAddSignListExecute
    end
    object acDeleteNote: TAction
      Category = 'Action'
      Caption = '&Delete Progress Note...'
      OnExecute = acDeleteNoteExecute
    end
    object acEditNote: TAction
      Category = 'Action'
      Caption = '&Edit Progress Note...'
      OnExecute = acEditNoteExecute
    end
    object acSaveNoSig: TAction
      Category = 'Action'
      Caption = 'S&ave without Signature'
      Hint = 'Saves the note that is being edited'
      OnExecute = acSaveNoSigExecute
    end
    object acSign: TAction
      Category = 'Action'
      Caption = 'Si&gn Note Now...'
      OnExecute = acSignExecute
    end
    object acIDAddlSign: TAction
      Category = 'Action'
      Caption = '&Identify Additional Signers'
      OnExecute = acIDAddlSignExecute
    end
    object acViewDemo: TAction
      Tag = 1
      Category = 'Information'
      Caption = 'De&mographics...'
      OnExecute = acViewInfoExecute
      OnUpdate = acViewDemoUpdate
    end
    object acViewVisits: TAction
      Tag = 2
      Category = 'Information'
      Caption = 'Visits/Pr&ovider...'
      OnExecute = acViewInfoExecute
      OnUpdate = acViewVisitsUpdate
    end
    object acViewPrimaryCare: TAction
      Tag = 3
      Category = 'Information'
      Caption = 'Primary &Care...'
      OnExecute = acViewInfoExecute
      OnUpdate = acViewPrimaryCareUpdate
    end
    object acViewHealthEVet: TAction
      Tag = 4
      Category = 'Information'
      Caption = 'My Healthe&Vet...'
      OnExecute = acViewInfoExecute
      OnUpdate = acViewHealthEVetUpdate
    end
    object acViewInsurance: TAction
      Tag = 5
      Category = 'Information'
      Caption = '&Insurance...'
      OnExecute = acViewInfoExecute
      OnUpdate = acViewInsuranceUpdate
    end
    object acViewFlags: TAction
      Tag = 6
      Category = 'Information'
      Caption = '&Flags...'
      OnExecute = acViewInfoExecute
      OnUpdate = acViewFlagsUpdate
    end
    object acViewRemote: TAction
      Tag = 7
      Category = 'Information'
      Caption = 'Remote &Data...'
      OnExecute = acViewInfoExecute
      OnUpdate = acViewRemoteUpdate
    end
    object acViewReminders: TAction
      Tag = 8
      Category = 'Information'
      Caption = '&Reminders...'
      OnExecute = acViewInfoExecute
      OnUpdate = acViewRemindersUpdate
    end
    object acViewPostings: TAction
      Tag = 9
      Category = 'Information'
      Caption = '&Postings...'
      OnExecute = acViewInfoExecute
      OnUpdate = acViewPostingsUpdate
    end
    object acSignedAll: TAction
      Tag = 1
      Category = 'View'
      Caption = '&Signed Notes (All)'
      OnExecute = acSignedExecute
    end
    object acSignedByAuthor: TAction
      Tag = 4
      Category = 'View'
      Caption = 'Signed Notes by &Author'
      OnExecute = acSignedExecute
    end
    object acSignedDate: TAction
      Tag = 5
      Category = 'View'
      Caption = 'Signed Notes by Date &Range'
      OnExecute = acSignedExecute
    end
    object acUncosigned: TAction
      Tag = 3
      Category = 'View'
      Caption = 'Un&cosigned Notes'
      OnExecute = acSignedExecute
    end
    object acUnsigned: TAction
      Tag = 2
      Category = 'View'
      Caption = '&Unsigned Notes'
      OnExecute = acSignedExecute
    end
    object acCustomView: TAction
      Tag = 6
      Category = 'View'
      Caption = 'Custo&m View'
      OnExecute = acSignedExecute
    end
    object acSearchWithin: TAction
      Tag = 7
      Category = 'View'
      Caption = 'Search for Te&xt (Within Current View)'
      OnExecute = acSignedExecute
    end
    object acViewSaveDefault: TAction
      Category = 'View'
      Caption = 'Sa&ve as Default View'
      OnExecute = acViewSaveDefaultExecute
    end
    object acViewReturnDefault: TAction
      Category = 'View'
      Caption = 'Return to De&fault View'
      OnExecute = acViewReturnDefaultExecute
    end
    object acViewDetails: TAction
      Category = 'View'
      Caption = '&Details'
      OnExecute = acViewDetailsExecute
    end
    object acIconLegend: TAction
      Category = 'View'
      Caption = 'Icon Legend'
      OnExecute = acIconLegendExecute
    end
    object acEditTemplate: TAction
      Category = 'Options'
      Caption = 'Edit &Templates...'
      OnExecute = acEditTemplateExecute
      OnUpdate = acEditTemplateUpdate
    end
    object acNewTemplate: TAction
      Category = 'Options'
      Caption = 'Create &New Template...'
      OnExecute = acNewTemplateExecute
      OnUpdate = acNewTemplateUpdate
    end
    object acEditShared: TAction
      Category = 'Options'
      Caption = 'Edit &Shared Templates...'
      OnExecute = acEditSharedExecute
      OnUpdate = acEditSharedUpdate
    end
    object acNewShared: TAction
      Category = 'Options'
      Caption = '&Create New Shared Template...'
      OnExecute = acNewSharedExecute
    end
    object acEditDialogFields: TAction
      Category = 'Options'
      Caption = 'Edit Template &Fields'
      OnExecute = acEditDialogFieldsExecute
      OnUpdate = acEditDialogFieldsUpdate
    end
    object acChange: TAction
      Category = 'Buttons'
      Caption = 'Change...'
      OnExecute = acChangeExecute
      OnUpdate = acChangeUpdate
    end
    object acTemplateHook: TAction
      Category = 'Buttons'
      Caption = 'Templates'
    end
  end
end
