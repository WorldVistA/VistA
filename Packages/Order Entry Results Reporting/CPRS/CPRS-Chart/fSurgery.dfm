inherited frmSurgery: TfrmSurgery
  Left = 468
  Top = 224
  Align = alClient
  Caption = 'Surgery Page'
  ClientHeight = 492
  ClientWidth = 832
  HelpFile = 'overvw'
  Menu = mnuNotes
  ExplicitWidth = 850
  ExplicitHeight = 562
  PixelsPerInch = 96
  TextHeight = 16
  inherited shpPageBottom: TShape
    Top = 487
    Width = 832
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    ExplicitTop = 358
    ExplicitWidth = 712
  end
  inherited sptHorz: TSplitter
    Left = 64
    Height = 487
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    AutoSnap = False
    OnCanResize = sptHorzCanResize
    ExplicitLeft = 64
    ExplicitHeight = 358
  end
  inherited pnlLeft: TPanel
    Width = 64
    Height = 487
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Constraints.MinWidth = 37
    ExplicitWidth = 64
    ExplicitHeight = 487
    object lblCases: TOROffsetLabel
      Left = 0
      Top = 0
      Width = 64
      Height = 19
      Align = alTop
      Caption = 'Last 100 Surgery Cases'
      HorzOffset = 2
      ParentShowHint = False
      ShowHint = True
      Transparent = True
      VertOffset = 6
      WordWrap = False
    end
    object lblSpace1: TLabel
      Left = 0
      Top = 442
      Width = 64
      Height = 3
      Align = alBottom
      AutoSize = False
      Caption = ' '
      ExplicitTop = 313
    end
    object cmdNewNote: TORAlignButton
      Left = 0
      Top = 445
      Width = 64
      Height = 21
      Align = alBottom
      Caption = 'New Report'
      TabOrder = 1
      Visible = False
      OnClick = cmdNewNoteClick
    end
    object cmdPCE: TORAlignButton
      Left = 0
      Top = 466
      Width = 64
      Height = 21
      Align = alBottom
      Caption = 'Encounter'
      TabOrder = 2
      Visible = False
      OnClick = cmdPCEClick
    end
    object pnlDrawers: TPanel
      Left = 0
      Top = 19
      Width = 64
      Height = 423
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object splDrawers: TSplitter
        Left = 0
        Top = 420
        Width = 64
        Height = 3
        Cursor = crVSplit
        Align = alBottom
        ExplicitTop = 291
      end
      object lstNotes: TORListBox
        Left = 14
        Top = 289
        Width = 121
        Height = 97
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        Visible = False
        OnClick = lstNotesClick
        Caption = ''
        ItemTipColor = clWindow
        LongList = False
      end
      object tvSurgery: TORTreeView
        Left = 0
        Top = 0
        Width = 64
        Height = 420
        Align = alClient
        Constraints.MinWidth = 30
        DragMode = dmAutomatic
        HideSelection = False
        Images = dmodShared.imgSurgery
        Indent = 19
        PopupMenu = popNoteList
        ReadOnly = True
        StateImages = dmodShared.imgImages
        TabOrder = 0
        OnChange = tvSurgeryChange
        OnCollapsed = tvSurgeryCollapsed
        OnExpanded = tvSurgeryExpanded
        Caption = 'Last 100 Surgery Cases'
        NodePiece = 0
        ShortNodeCaptions = True
      end
    end
  end
  inherited pnlRight: TPanel
    Left = 68
    Width = 764
    Height = 487
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Constraints.MinWidth = 30
    OnResize = pnlRightResize
    ExplicitLeft = 68
    ExplicitWidth = 764
    ExplicitHeight = 487
    object sptVert: TSplitter
      Left = 0
      Top = 438
      Width = 764
      Height = 4
      Cursor = crVSplit
      Align = alBottom
      AutoSnap = False
      ExplicitTop = 309
      ExplicitWidth = 644
    end
    object memPCEShow: TRichEdit
      Left = 0
      Top = 442
      Width = 764
      Height = 45
      Align = alBottom
      Color = clCream
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Lines.Strings = (
        '<No encounter information entered>')
      ParentFont = False
      PlainText = True
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 2
      WantReturns = False
      Zoom = 100
    end
    object pnlWrite: TPanel
      Left = 0
      Top = 0
      Width = 764
      Height = 438
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      Visible = False
      OnResize = pnlWriteResize
      object spEditDetails: TSplitter
        Left = 0
        Top = 334
        Width = 764
        Height = 4
        Cursor = crVSplit
        Align = alBottom
        AutoSnap = False
        Visible = False
        ExplicitLeft = 24
        ExplicitTop = 298
      end
      object memNewNote: TRichEdit
        Left = 0
        Top = 67
        Width = 764
        Height = 267
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Courier New'
        Font.Style = []
        MaxLength = 2147483645
        ParentFont = False
        PlainText = True
        PopupMenu = popNoteMemo
        ScrollBars = ssVertical
        TabOrder = 1
        WantTabs = True
        Zoom = 100
        OnChange = memNewNoteChange
        OnKeyDown = memNewNoteKeyDown
      end
      object pnlFields: TPanel
        Left = 0
        Top = 0
        Width = 764
        Height = 67
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        DesignSize = (
          764
          67)

        object grdFields: TGridPanel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 758
          Height = 67
          Align = alTop
          ColumnCollection = <
            item
              Value = 8.816963525280565000
            end
            item
              Value = 30.352516052470630000
            end
            item
              Value = 9.796626139200630000
            end
            item
              Value = 9.796626139200630000
            end
            item
              Value = 30.352516052470630000
            end
            item
              Value = 10.884752091376920000
            end>
          ControlCollection = <
            item
              Column = 1
              ColumnSpan = 5
              Control = txtSubject
              Row = 2
            end
            item
              Column = 1
              Row = 2
            end
            item
              Column = 0
              Control = lblSubject
              Row = 2
            end
            item
              Column = 0
              ColumnSpan = 3
              Control = lblVisit
              Row = 1
            end
            item
              Column = 3
              ColumnSpan = 2
              Control = lblCosigner
              Row = 1
            end
            item
              Column = 4
              Control = lblAuthor
              Row = 0
            end
            item
              Column = 2
              ColumnSpan = 2
              Control = lblRefDate
              Row = 0
            end
            item
              Column = 5
              Control = cmdChange
              Row = 0
              RowSpan = 2
            end
            item
              Column = 0
              ColumnSpan = 2
              Control = pnlNewTitle
              Row = 0
            end>
          ExpandStyle = emFixedSize
          RowCollection = <
            item
              Value = 33.333333333333340000
            end
            item
              Value = 33.333333333333340000
            end
            item
              Value = 33.333333333333340000
            end>
          TabOrder = 0
          ExplicitLeft = 0
          ExplicitTop = 96
          ExplicitWidth = 764
          ExplicitHeight = 73
          DesignSize = (
            758
            67)
          object pnlNewTitle: TPanel
            Left = 1
            Top = 1
            Width = 296
            Height = 22
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 2
            ExplicitWidth = 185
            ExplicitHeight = 9
            object bvlNewTitle: TBevel
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 117
              Height = 15
            end
            object lblNewTitle: TLabel
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 290
              Height = 16
              Hint = 'Press "Change..." to select a different title.'
              Align = alClient
              Caption = ' General Medicine Note '
              Color = clCream
              ParentColor = False
              ParentShowHint = False
              ShowAccelChar = False
              ShowHint = True
              ExplicitLeft = 1
              ExplicitTop = 1
              ExplicitWidth = 115
              ExplicitHeight = 13
            end
          end
          object lblRefDate: TLabel
            AlignWithMargins = True
            Left = 300
            Top = 4
            Width = 142
            Height = 16
            Hint = 'Press "Change..." to change date/time of note.'
            Align = alClient
            Alignment = taCenter
            Caption = 'Oct 20,1999@15:30'
            ParentShowHint = False
            ShowAccelChar = False
            ShowHint = True
            ExplicitLeft = 237
            ExplicitTop = 6
            ExplicitWidth = 97
            ExplicitHeight = 13
          end
          object lblAuthor: TLabel
            AlignWithMargins = True
            Left = 448
            Top = 4
            Width = 224
            Height = 16
            Hint = 'Press "Change..." to select a different author.'
            Align = alClient
            Alignment = taRightJustify
            Caption = 'Winchester,Charles Emerson III'
            ParentShowHint = False
            ShowAccelChar = False
            ShowHint = True
            ExplicitLeft = 366
            ExplicitTop = 1
            ExplicitWidth = 319
            ExplicitHeight = 23
          end
          object lblVisit: TLabel
            AlignWithMargins = True
            Left = 4
            Top = 26
            Width = 364
            Height = 15
            Align = alClient
            Caption = 'Vst: 10/20/99 Pulmonary Clinic, Dr. Welby'
            ShowAccelChar = False
            ExplicitLeft = 2
            ExplicitTop = 25
            ExplicitWidth = 191
            ExplicitHeight = 13
          end
          object lblCosigner: TLabel
            AlignWithMargins = True
            Left = 374
            Top = 26
            Width = 298
            Height = 15
            Hint = 'Press "Change..." to select a different cosigner.'
            Align = alClient
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Expected Cosigner: Winchester,Charles Emerson III'
            ParentShowHint = False
            ShowAccelChar = False
            ShowHint = True
            ExplicitLeft = 354
            ExplicitTop = 25
            ExplicitWidth = 603
            ExplicitHeight = 23
          end
          object lblSubject: TLabel
            AlignWithMargins = True
            Left = 4
            Top = 47
            Width = 61
            Height = 16
            Align = alClient
            Caption = 'Subject:'
            Layout = tlCenter
            ExplicitLeft = 6
            ExplicitTop = 43
            ExplicitWidth = 39
            ExplicitHeight = 13
          end
          object cmdChange: TButton
            AlignWithMargins = True
            Left = 678
            Top = 12
            Width = 76
            Height = 21
            Margins.Top = 11
            Margins.Bottom = 11
            Align = alClient
            Caption = 'Change...'
            TabOrder = 0
            OnClick = cmdChangeClick
            ExplicitLeft = 6
            ExplicitTop = 16
            ExplicitWidth = 58
          end
          object txtSubject: TCaptionEdit
            Left = 68
            Top = 44
            Width = 689
            Height = 22
            Hint = 'Subject is limited to a maximum of 80 characters.'
            Align = alClient
            MaxLength = 80
            ParentShowHint = False
            ShowHint = True
            TabOrder = 3
            Text = 'txtSubject'
            Caption = 'Subject'
            ExplicitLeft = 46
            ExplicitTop = 48
            ExplicitWidth = 717
            ExplicitHeight = 21
          end
		end
      end
      object CPMemNewNote: TCopyPasteDetails
        Left = 0
        Top = 338
        Width = 764
        Height = 100
        Align = alBottom
        BevelInner = bvRaised
        BorderStyle = bsSingle
        Caption = 'CPMemNewNote'
        Constraints.MinHeight = 32
        ShowCaption = False
        TabOrder = 2
        Visible = False
        CopyMonitor = frmFrame.CPAppMon
        CollapseBtn.Left = 739
        CollapseBtn.Top = 0
        CollapseBtn.Width = 17
        CollapseBtn.Height = 20
        CollapseBtn.Align = alRight
        CollapseBtn.Caption = #218
        CollapseBtn.Font.Charset = DEFAULT_CHARSET
        CollapseBtn.Font.Color = clWindowText
        CollapseBtn.Font.Height = -11
        CollapseBtn.Font.Name = 'Wingdings'
        CollapseBtn.Font.Style = []
        CollapseBtn.ParentFont = False
        CollapseBtn.TabOrder = 0
        CollapseBtn.TabStop = False
        EditMonitor.CopyMonitor = frmFrame.CPAppMon
        EditMonitor.OnLoadPastedText = LoadPastedText
        EditMonitor.OnPasteToMonitor = PasteToMonitor
        EditMonitor.OnSaveTheMonitor = SaveTheMonitor
        EditMonitor.RelatedPackage = '8925'
        EditMonitor.TrackOnlyEdits = <>
        InfoMessage.AlignWithMargins = True
        InfoMessage.Left = 3
        InfoMessage.Top = 3
        InfoMessage.Width = 625
        InfoMessage.Height = 45
        InfoMessage.Align = alClient
        InfoMessage.Font.Charset = ANSI_CHARSET
        InfoMessage.Font.Color = clWindowText
        InfoMessage.Font.Height = -11
        InfoMessage.Font.Name = 'MS Sans Serif'
        InfoMessage.Font.Style = []
        InfoMessage.Lines.Strings = (
          '<-- Please select the desired paste date')
        InfoMessage.ParentFont = False
        InfoMessage.ReadOnly = True
        InfoMessage.ScrollBars = ssBoth
        InfoMessage.TabOrder = 0
        InfoMessage.WantReturns = False
        InfoMessage.WordWrap = False
        InfoMessage.Zoom = 100
        InfoSelector.AlignWithMargins = True
        InfoSelector.Left = 3
        InfoSelector.Top = 3
        InfoSelector.Width = 111
        InfoSelector.Height = 45
        InfoSelector.Style = lbOwnerDrawFixed
        InfoSelector.Align = alClient
        InfoSelector.ItemHeight = 13
        InfoSelector.TabOrder = 0
        OnHide = CPHide
        OnShow = CPShow
        SyncSizes = True
        VisualEdit = memNewNote
        SaveFindAfter = 0
      end
    end
    object pnlRead: TPanel
      Left = 0
      Top = 0
      Width = 764
      Height = 438
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object lblTitle: TOROffsetLabel
        Left = 0
        Top = 0
        Width = 764
        Height = 19
        Align = alTop
        Caption = 'No Surgery Cases Found'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        HorzOffset = 2
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        Transparent = False
        VertOffset = 6
        WordWrap = False
        ExplicitWidth = 120
      end
      object spDetails: TSplitter
        Left = 0
        Top = 334
        Width = 764
        Height = 4
        Cursor = crVSplit
        Align = alBottom
        AutoSnap = False
        ExplicitTop = 19
        ExplicitWidth = 644
      end
      object memSurgery: TRichEdit
        Left = 0
        Top = 19
        Width = 764
        Height = 315
        Align = alClient
        Color = clCream
        Ctl3D = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
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
        TabOrder = 0
        WantReturns = False
        WordWrap = False
        Zoom = 100
      end
      object CPMemSurgery: TCopyPasteDetails
        Left = 0
        Top = 338
        Width = 764
        Height = 100
        Align = alBottom
        BevelInner = bvRaised
        BorderStyle = bsSingle
        Caption = 'CPMemSurgery'
        Constraints.MinHeight = 32
        ShowCaption = False
        TabOrder = 1
        Visible = False
        CopyMonitor = frmFrame.CPAppMon
        CollapseBtn.Left = 739
        CollapseBtn.Top = 0
        CollapseBtn.Width = 17
        CollapseBtn.Height = 20
        CollapseBtn.Align = alRight
        CollapseBtn.Caption = #218
        CollapseBtn.Font.Charset = DEFAULT_CHARSET
        CollapseBtn.Font.Color = clWindowText
        CollapseBtn.Font.Height = -11
        CollapseBtn.Font.Name = 'Wingdings'
        CollapseBtn.Font.Style = []
        CollapseBtn.ParentFont = False
        CollapseBtn.TabOrder = 0
        CollapseBtn.TabStop = False
        EditMonitor.CopyMonitor = frmFrame.CPAppMon
        EditMonitor.OnCopyToMonitor = CopyToMonitor
        EditMonitor.OnLoadPastedText = LoadPastedText
        EditMonitor.RelatedPackage = '8925'
        EditMonitor.TrackOnlyEdits = <>
        InfoMessage.AlignWithMargins = True
        InfoMessage.Left = 3
        InfoMessage.Top = 3
        InfoMessage.Width = 625
        InfoMessage.Height = 45
        InfoMessage.Align = alClient
        InfoMessage.Font.Charset = ANSI_CHARSET
        InfoMessage.Font.Color = clWindowText
        InfoMessage.Font.Height = -11
        InfoMessage.Font.Name = 'MS Sans Serif'
        InfoMessage.Font.Style = []
        InfoMessage.Lines.Strings = (
          '<-- Please select the desired paste date')
        InfoMessage.ParentFont = False
        InfoMessage.ReadOnly = True
        InfoMessage.ScrollBars = ssBoth
        InfoMessage.TabOrder = 0
        InfoMessage.WantReturns = False
        InfoMessage.WordWrap = False
        InfoMessage.Zoom = 100
        InfoSelector.AlignWithMargins = True
        InfoSelector.Left = 3
        InfoSelector.Top = 3
        InfoSelector.Width = 111
        InfoSelector.Height = 45
        InfoSelector.Style = lbOwnerDrawFixed
        InfoSelector.Align = alClient
        InfoSelector.ItemHeight = 13
        InfoSelector.TabOrder = 0
        OnHide = CPHide
        OnShow = CPShow
        SyncSizes = True
        VisualEdit = memSurgery
        SaveFindAfter = 0
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = cmdNewNote'
        'Status = stsDefault')
      (
        'Component = cmdPCE'
        'Status = stsDefault')
      (
        'Component = pnlDrawers'
        'Status = stsDefault')
      (
        'Component = lstNotes'
        'Status = stsDefault')
      (
        'Component = tvSurgery'
        'Status = stsDefault')
      (
        'Component = pnlRead'
        'Status = stsDefault')
      (
        'Component = memSurgery'
        'Status = stsDefault')
      (
        'Component = memPCEShow'
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
        'Component = cmdChange'
        'Status = stsDefault')
      (
        'Component = txtSubject'
        'Status = stsDefault')
      (
        'Component = pnlLeft'
        'Status = stsDefault')
      (
        'Component = pnlRight'
        'Status = stsDefault')
      (
        'Component = frmSurgery'
        'Status = stsDefault')
      (
        'Component = CPMemSurgery'
        'Status = stsDefault')
      (
        'Component = CPMemNewNote'
        'Status = stsDefault')
      (
        'Component = grdFields'
        'Status = stsDefault')
      (
        'Component = pnlNewTitle'
        'Status = stsDefault'))
  end
  object mnuNotes: TMainMenu
    Left = 600
    Top = 304
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
        OnClick = mnuViewInformationClick
        object mnuViewDemo: TMenuItem
          Tag = 1
          Caption = 'De&mographics...'
          OnClick = ViewInfo
        end
        object mnuViewVisits: TMenuItem
          Tag = 2
          Caption = 'Visits/Pr&ovider...'
          OnClick = ViewInfo
        end
        object mnuViewPrimaryCare: TMenuItem
          Tag = 3
          Caption = 'Primary &Care...'
          OnClick = ViewInfo
        end
        object mnuViewMyHealtheVet: TMenuItem
          Tag = 4
          Caption = 'MyHealthe&Vet...'
          OnClick = ViewInfo
        end
        object mnuInsurance: TMenuItem
          Tag = 5
          Caption = '&Insurance...'
          OnClick = ViewInfo
        end
        object mnuViewFlags: TMenuItem
          Tag = 6
          Caption = '&Flags...'
          OnClick = ViewInfo
        end
        object mnuViewRemoteData: TMenuItem
          Tag = 7
          Caption = 'Remote &Data...'
          OnClick = ViewInfo
        end
        object mnuViewReminders: TMenuItem
          Tag = 8
          Caption = '&Reminders...'
          Enabled = False
          OnClick = ViewInfo
        end
        object mnuViewPostings: TMenuItem
          Tag = 9
          Caption = '&Postings...'
          OnClick = ViewInfo
        end
      end
      object Z3: TMenuItem
        Caption = '-'
      end
      object mnuViewAll: TMenuItem
        Tag = -1
        Caption = '&All Cases'
        OnClick = mnuViewClick
      end
      object mnuViewBySurgeon: TMenuItem
        Tag = -4
        Caption = 'Cases by &Surgeon'
        Enabled = False
        Visible = False
        OnClick = mnuViewClick
      end
      object mnuViewByDate: TMenuItem
        Tag = -5
        Caption = 'Cases by Date &Range'
        Enabled = False
        Visible = False
        OnClick = mnuViewClick
      end
      object mnuViewUncosigned: TMenuItem
        Tag = -3
        Caption = 'Un&cosigned Notes'
        Enabled = False
        Visible = False
        OnClick = mnuViewClick
      end
      object mnuViewUnsigned: TMenuItem
        Tag = -2
        Caption = '&Unsigned Notes'
        Enabled = False
        Visible = False
        OnClick = mnuViewClick
      end
      object mnuViewCustom: TMenuItem
        Tag = -6
        Caption = 'Custo&m View'
        OnClick = mnuViewClick
      end
      object N1: TMenuItem
        Caption = '-'
        Enabled = False
      end
      object mnuViewSaveAsDefault: TMenuItem
        Caption = 'Sa&ve as Default View'
        OnClick = mnuViewSaveAsDefaultClick
      end
      object ReturntoDefault1: TMenuItem
        Caption = 'Return to De&fault View'
        OnClick = mnuViewReturntoDefaultClick
      end
      object Z1: TMenuItem
        Caption = '-'
        Enabled = False
      end
      object mnuViewDetail: TMenuItem
        Caption = '&Details'
        OnClick = mnuViewDetailClick
      end
      object N6: TMenuItem
        Caption = '-'
        Enabled = False
      end
      object mnuIconLegend: TMenuItem
        Caption = 'Icon Legend'
        OnClick = mnuIconLegendClick
      end
    end
    object mnuAct: TMenuItem
      Caption = '&Action'
      GroupIndex = 4
      object mnuActNew: TMenuItem
        Caption = '&New Report'
        Hint = 'Creates a new operative summary'
        ShortCut = 24654
        Visible = False
        OnClick = mnuActNewClick
      end
      object mnuActAddend: TMenuItem
        Caption = '&Make Addendum...'
        Hint = 'Makes an addendum for the currently selected report'
        ShortCut = 24653
        OnClick = mnuActAddendClick
      end
      object mnuActAddIDEntry: TMenuItem
        Caption = 'Add Ne&w Entry to Interdisciplinary Note'
        Enabled = False
        Visible = False
      end
      object mnuActDetachFromIDParent: TMenuItem
        Caption = 'Detac&h from Interdisciplinary Note'
        Enabled = False
        Visible = False
      end
      object Z4: TMenuItem
        Caption = '-'
        Enabled = False
      end
      object mnuActChange: TMenuItem
        Caption = '&Change Title...'
        ShortCut = 24643
        OnClick = mnuActChangeClick
      end
      object mnuActLoadBoiler: TMenuItem
        Caption = 'Reload &Boilerplate Text'
        OnClick = mnuActLoadBoilerClick
      end
      object Z2: TMenuItem
        Caption = '-'
        Enabled = False
      end
      object mnuActSignList: TMenuItem
        Caption = 'Add to Signature &List'
        Hint = 
          'Adds the currently displayed report to list of things to be sign' +
          'ed'
        OnClick = mnuActSignListClick
      end
      object mnuActDelete: TMenuItem
        Caption = '&Delete Report'
        ShortCut = 24644
        OnClick = mnuActDeleteClick
      end
      object mnuActEdit: TMenuItem
        Caption = '&Edit Report...'
        ShortCut = 24645
        OnClick = mnuActEditClick
      end
      object mnuActSave: TMenuItem
        Caption = 'S&ave without Signature'
        Hint = 'Saves the report that is being edited'
        ShortCut = 24641
        OnClick = mnuActSaveClick
      end
      object mnuActSign: TMenuItem
        Caption = 'Si&gn Report Now...'
        ShortCut = 24647
        OnClick = mnuActSignClick
      end
      object mnuActIdentifyAddlSigners: TMenuItem
        Caption = '&Identify Additional Signers'
        OnClick = mnuActIdentifyAddlSignersClick
      end
    end
    object mnuOptions: TMenuItem
      Caption = '&Options'
      GroupIndex = 4
      OnClick = mnuOptionsClick
      object mnuEditTemplates: TMenuItem
        Caption = 'Edit &Templates...'
        Enabled = False
        OnClick = mnuEditTemplatesClick
      end
      object mnuNewTemplate: TMenuItem
        Caption = 'Create &New Template...'
        Enabled = False
        OnClick = mnuNewTemplateClick
      end
      object N2: TMenuItem
        Caption = '-'
        Enabled = False
      end
      object mnuEditSharedTemplates: TMenuItem
        Caption = 'Edit &Shared Templates...'
        Enabled = False
        OnClick = mnuEditSharedTemplatesClick
      end
      object mnuNewSharedTemplate: TMenuItem
        Caption = '&Create New Shared Template...'
        Enabled = False
        OnClick = mnuNewSharedTemplateClick
      end
      object N3: TMenuItem
        Caption = '-'
        Enabled = False
        OnClick = cmdChangeClick
      end
      object mnuEditDialgFields: TMenuItem
        Caption = 'Edit Template &Fields'
        Enabled = False
        OnClick = mnuEditDialgFieldsClick
      end
    end
  end
  object popNoteMemo: TPopupMenu
    OnPopup = popNoteMemoPopup
    Left = 540
    Top = 304
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
      Caption = '&Find in Selected Document'
      OnClick = popNoteMemoFindClick
    end
    object popNoteMemoReplace: TMenuItem
      Caption = '&Replace Text'
      OnClick = popNoteMemoReplaceClick
    end
    object N7: TMenuItem
      Caption = '-'
      OnClick = cmdChangeClick
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
      Caption = 'Add to Signature &List'
      OnClick = mnuActSignListClick
    end
    object popNoteMemoDelete: TMenuItem
      Caption = '&Delete Report'
      OnClick = mnuActDeleteClick
    end
    object popNoteMemoEdit: TMenuItem
      Caption = '&Edit Report'
      OnClick = mnuActEditClick
    end
    object popNoteMemoAddend: TMenuItem
      Caption = '&Make Addendum'
      OnClick = mnuActAddendClick
    end
    object popNoteMemoSave: TMenuItem
      Caption = 'S&ave without Signature'
      OnClick = mnuActSaveClick
    end
    object popNoteMemoSign: TMenuItem
      Caption = '&Sign Report Now'
      OnClick = mnuActSignClick
    end
    object popNoteMemoAddlSign: TMenuItem
      Caption = '&Identify Additional Signers'
      OnClick = popNoteMemoAddlSignClick
    end
    object N8: TMenuItem
      Caption = '-'
    end
    object popNoteMemoPreview: TMenuItem
      Caption = 'Previe&w/Print Current Template'
      ShortCut = 16471
      OnClick = popNoteMemoPreviewClick
    end
    object popNoteMemoInsTemplate: TMenuItem
      Caption = 'Insert Current Template'
      ShortCut = 16429
      OnClick = popNoteMemoInsTemplateClick
    end
    object popNoteMemoEncounter: TMenuItem
      Caption = 'Edit Encounter Information'
      ShortCut = 16453
      OnClick = cmdPCEClick
    end
  end
  object popNoteList: TPopupMenu
    OnPopup = popNoteListPopup
    Left = 500
    Top = 305
    object popNoteListAll: TMenuItem
      Tag = 1
      Caption = '&All cases'
      OnClick = mnuViewClick
    end
    object popNoteListBySurgeon: TMenuItem
      Tag = 4
      Caption = 'Cases by &Surgeon'
      Enabled = False
      Visible = False
      OnClick = mnuViewClick
    end
    object popNoteListByDate: TMenuItem
      Tag = 5
      Caption = 'Cases by Date &Range'
      Enabled = False
      OnClick = mnuViewClick
    end
    object popNoteListUncosigned: TMenuItem
      Tag = 3
      Caption = 'Un&cosigned Notes'
      Enabled = False
      Visible = False
      OnClick = mnuViewClick
    end
    object popNoteListUnsigned: TMenuItem
      Tag = 2
      Caption = '&Unsigned Notes'
      Enabled = False
      Visible = False
      OnClick = mnuViewClick
    end
    object popNoteListCustom: TMenuItem
      Tag = 6
      Caption = 'Cus&tom List'
      OnClick = mnuViewClick
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
      Caption = 'Add Ne&w Entry to ID Note'
      Enabled = False
    end
    object popNoteListDetachFromIDParent: TMenuItem
      Caption = 'Detac&h from ID Note'
      Enabled = False
    end
  end
  object timAutoSave: TTimer
    Enabled = False
    Interval = 300000
    OnTimer = timAutoSaveTimer
    Left = 592
    Top = 27
  end
  object dlgFindText: TFindDialog
    Options = [frDown, frHideUpDown]
    OnFind = dlgFindTextFind
    Left = 452
    Top = 312
  end
  object dlgReplaceText: TReplaceDialog
    OnFind = dlgReplaceTextFind
    OnReplace = dlgReplaceTextReplace
    Left = 413
    Top = 312
  end
  object imgLblImages: TVA508ImageListLabeler
    Components = <
      item
        Component = tvSurgery
      end>
    Labels = <>
    RemoteLabeler = dmodShared.imgLblImages
    Left = 16
    Top = 139
  end
  object imgLblSurgery: TVA508ImageListLabeler
    Components = <
      item
        Component = tvSurgery
      end>
    Labels = <>
    RemoteLabeler = dmodShared.imgLblSurgery
    Left = 24
    Top = 203
  end
end
