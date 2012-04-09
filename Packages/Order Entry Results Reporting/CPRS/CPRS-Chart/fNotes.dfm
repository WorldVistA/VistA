inherited frmNotes: TfrmNotes
  Left = 402
  Top = 171
  HelpContext = 5000
  Caption = 'Progress Notes Page'
  ClientHeight = 413
  ClientWidth = 679
  HelpFile = 'overvw'
  Menu = mnuNotes
  OnDestroy = FormDestroy
  OnHide = FormHide
  OnShow = FormShow
  ExplicitLeft = 402
  ExplicitTop = 171
  ExplicitWidth = 687
  ExplicitHeight = 471
  PixelsPerInch = 96
  TextHeight = 13
  inherited shpPageBottom: TShape
    Top = 408
    Width = 679
    ExplicitTop = 408
    ExplicitWidth = 679
  end
  inherited sptHorz: TSplitter
    Left = 64
    Height = 408
    OnCanResize = sptHorzCanResize
    ExplicitLeft = 64
    ExplicitHeight = 408
  end
  inherited pnlLeft: TPanel
    Width = 64
    Height = 408
    Constraints.MinWidth = 37
    ExplicitWidth = 64
    ExplicitHeight = 408
    object lblNotes: TOROffsetLabel
      Left = 0
      Top = 0
      Width = 64
      Height = 19
      Align = alTop
      Caption = 'Last 100 Notes'
      HorzOffset = 2
      ParentShowHint = False
      ShowHint = True
      Transparent = True
      VertOffset = 6
      WordWrap = False
    end
    object lblSpace1: TLabel
      Left = 0
      Top = 363
      Width = 64
      Height = 3
      Align = alBottom
      AutoSize = False
      Caption = ' '
    end
    object cmdNewNote: TORAlignButton
      Left = 0
      Top = 366
      Width = 64
      Height = 21
      Align = alBottom
      Caption = 'New Note'
      TabOrder = 1
      OnClick = cmdNewNoteClick
      OnExit = cmdNewNoteExit
    end
    object cmdPCE: TORAlignButton
      Left = 0
      Top = 387
      Width = 64
      Height = 21
      Align = alBottom
      Caption = 'Encounter'
      TabOrder = 2
      Visible = False
      OnClick = cmdPCEClick
      OnExit = cmdPCEExit
    end
    object pnlDrawers: TPanel
      Left = 0
      Top = 19
      Width = 64
      Height = 344
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object splDrawers: TSplitter
        Left = 0
        Top = 341
        Width = 64
        Height = 3
        Cursor = crVSplit
        Align = alBottom
        ExplicitTop = 342
      end
      object lstNotes: TORListBox
        Left = 0
        Top = 0
        Width = 64
        Height = 18
        TabStop = False
        Ctl3D = True
        ItemHeight = 13
        ParentCtl3D = False
        ParentShowHint = False
        PopupMenu = popNoteList
        ShowHint = True
        TabOrder = 0
        Visible = False
        OnClick = lstNotesClick
        ItemTipColor = clWindow
        LongList = False
        Pieces = '2,3'
        TabPositions = '10'
      end
      object tvNotes: TORTreeView
        Left = 0
        Top = 0
        Width = 64
        Height = 341
        Align = alClient
        Constraints.MinWidth = 30
        HideSelection = False
        Images = dmodShared.imgNotes
        Indent = 19
        PopupMenu = popNoteList
        ReadOnly = True
        StateImages = dmodShared.imgImages
        TabOrder = 1
        OnChange = tvNotesChange
        OnClick = tvNotesClick
        OnCollapsed = tvNotesCollapsed
        OnDragDrop = tvNotesDragDrop
        OnDragOver = tvNotesDragOver
        OnExit = tvNotesExit
        OnExpanded = tvNotesExpanded
        OnStartDrag = tvNotesStartDrag
        Caption = 'Last 100 Notes'
        NodePiece = 0
        ShortNodeCaptions = True
        ExplicitHeight = 342
      end
    end
  end
  inherited pnlRight: TPanel
    Left = 68
    Width = 611
    Height = 408
    Constraints.MinWidth = 30
    ExplicitLeft = 68
    ExplicitWidth = 611
    ExplicitHeight = 408
    object sptVert: TSplitter
      Left = 0
      Top = 359
      Width = 611
      Height = 4
      Cursor = crVSplit
      Align = alBottom
    end
    object memPCEShow: TRichEdit
      Left = 0
      Top = 363
      Width = 611
      Height = 45
      Align = alBottom
      Color = clCream
      Lines.Strings = (
        '<No encounter information entered>')
      PlainText = True
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 2
      OnExit = memPCEShowExit
    end
    object pnlWrite: TPanel
      Left = 0
      Top = 0
      Width = 611
      Height = 359
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      Visible = False
      OnResize = pnlWriteResize
      object memNewNote: TRichEdit
        Left = 0
        Top = 67
        Width = 611
        Height = 292
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        MaxLength = 2147483645
        ParentFont = False
        PlainText = True
        PopupMenu = popNoteMemo
        ScrollBars = ssBoth
        TabOrder = 1
        WantTabs = True
        OnChange = memNewNoteChange
        OnKeyDown = memNewNoteKeyDown
        OnKeyPress = memNewNoteKeyPress
        OnKeyUp = memNewNoteKeyUp
      end
      object pnlFields: TPanel
        Left = 0
        Top = 0
        Width = 611
        Height = 67
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        OnResize = pnlFieldsResize
        DesignSize = (
          611
          67)
        object bvlNewTitle: TBevel
          Left = 5
          Top = 5
          Width = 117
          Height = 15
        end
        object lblRefDate: TStaticText
          Left = 237
          Top = 6
          Width = 101
          Height = 17
          Hint = 'Press "Change..." to change date/time of note.'
          Alignment = taCenter
          Caption = 'Oct 20,1999@15:30'
          ParentShowHint = False
          ShowAccelChar = False
          ShowHint = True
          TabOrder = 2
        end
        object lblAuthor: TStaticText
          Left = 393
          Top = 6
          Width = 152
          Height = 17
          Hint = 'Press "Change..." to select a different author.'
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          Caption = 'Winchester,Charles Emerson III'
          ParentShowHint = False
          ShowAccelChar = False
          ShowHint = True
          TabOrder = 3
        end
        object lblVisit: TStaticText
          Left = 6
          Top = 21
          Width = 204
          Height = 17
          Caption = 'Vst: 10/20/99 Pulmonary Clinic, Dr. Welby'
          ShowAccelChar = False
          TabOrder = 4
        end
        object lblCosigner: TStaticText
          Left = 298
          Top = 21
          Width = 243
          Height = 13
          Hint = 'Press "Change..." to select a different cosigner.'
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          AutoSize = False
          Caption = 'Expected Cosigner: Winchester,Charles Emerson III'
          ParentShowHint = False
          ShowAccelChar = False
          ShowHint = True
          TabOrder = 5
        end
        object lblSubject: TStaticText
          Left = 6
          Top = 43
          Width = 43
          Height = 17
          Caption = 'Subject:'
          TabOrder = 6
        end
        object lblNewTitle: TStaticText
          Left = 6
          Top = 6
          Width = 119
          Height = 17
          Hint = 'Press "Change..." to select a different title.'
          Caption = ' General Medicine Note '
          Color = clCream
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          ParentShowHint = False
          ShowAccelChar = False
          ShowHint = True
          TabOrder = 7
        end
        object cmdChange: TButton
          Left = 547
          Top = 6
          Width = 58
          Height = 21
          Caption = 'Change...'
          TabOrder = 0
          OnClick = cmdChangeClick
          OnExit = cmdChangeExit
        end
        object txtSubject: TCaptionEdit
          Left = 48
          Top = 40
          Width = 557
          Height = 21
          Hint = 'Subject is limited to a maximum of 80 characters.'
          Anchors = [akLeft, akTop, akRight]
          MaxLength = 80
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          Text = 'txtSubject'
          Caption = 'Subject'
        end
      end
    end
    object pnlRead: TPanel
      Left = 0
      Top = 0
      Width = 611
      Height = 359
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      OnExit = pnlReadExit
      object lblTitle: TOROffsetLabel
        Left = 0
        Top = 0
        Width = 611
        Height = 19
        Align = alTop
        Caption = 'No Progress Notes Found'
        HorzOffset = 2
        Transparent = False
        VertOffset = 6
        WordWrap = False
      end
      object sptList: TSplitter
        Left = 0
        Top = 113
        Width = 611
        Height = 3
        Cursor = crVSplit
        Align = alTop
      end
      object memNote: TRichEdit
        Left = 0
        Top = 116
        Width = 611
        Height = 243
        Align = alClient
        Color = clCream
        Ctl3D = True
        Font.Charset = DEFAULT_CHARSET
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
        TabOrder = 1
        WordWrap = False
      end
      object lvNotes: TCaptionListView
        Left = 0
        Top = 19
        Width = 611
        Height = 94
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
        TabOrder = 0
        ViewStyle = vsReport
        Visible = False
        OnColumnClick = lvNotesColumnClick
        OnCompare = lvNotesCompare
        OnResize = lvNotesResize
        OnSelectItem = lvNotesSelectItem
        Caption = 'No Progress Notes Found'
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
        'Component = tvNotes'
        'Status = stsDefault')
      (
        'Component = memPCEShow'
        'Text = Encounter Information'
        'Status = stsOK')
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
        'Component = lblRefDate'
        'Status = stsDefault')
      (
        'Component = lblAuthor'
        'Status = stsDefault')
      (
        'Component = lblVisit'
        'Status = stsDefault')
      (
        'Component = lblCosigner'
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
        'Component = pnlRead'
        'Status = stsDefault')
      (
        'Component = memNote'
        'Status = stsDefault')
      (
        'Component = lvNotes'
        'Status = stsDefault')
      (
        'Component = pnlLeft'
        'Status = stsDefault')
      (
        'Component = pnlRight'
        'Status = stsDefault')
      (
        'Component = frmNotes'
        'Status = stsDefault'))
  end
  object mnuNotes: TMainMenu
    Left = 601
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
        Tag = 1
        Caption = '&Signed Notes (All)'
        OnClick = mnuViewClick
      end
      object mnuViewByAuthor: TMenuItem
        Tag = 4
        Caption = 'Signed Notes by &Author'
        OnClick = mnuViewClick
      end
      object mnuViewByDate: TMenuItem
        Tag = 5
        Caption = 'Signed Notes by Date &Range'
        OnClick = mnuViewClick
      end
      object mnuViewUncosigned: TMenuItem
        Tag = 3
        Caption = 'Un&cosigned Notes'
        OnClick = mnuViewClick
      end
      object mnuViewUnsigned: TMenuItem
        Tag = 2
        Caption = '&Unsigned Notes'
        OnClick = mnuViewClick
      end
      object mnuViewCustom: TMenuItem
        Tag = 6
        Caption = 'Custo&m View'
        OnClick = mnuViewClick
      end
      object mnuSearchForText: TMenuItem
        Tag = 7
        Caption = 'Search for Te&xt (Within Current View)'
        OnClick = mnuViewClick
      end
      object N1: TMenuItem
        Caption = '-'
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
      end
      object mnuViewDetail: TMenuItem
        Caption = '&Details'
        OnClick = mnuViewDetailClick
      end
      object N6: TMenuItem
        Caption = '-'
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
        Caption = '&New Progress Note...'
        Hint = 'Creates a new progress note'
        ShortCut = 24654
        OnClick = mnuActNewClick
      end
      object mnuActAddend: TMenuItem
        Caption = '&Make Addendum...'
        Hint = 'Makes an addendum for the currently selected note'
        ShortCut = 24653
        OnClick = mnuActAddendClick
      end
      object mnuActAddIDEntry: TMenuItem
        Caption = 'Add Ne&w Entry to Interdisciplinary Note'
        OnClick = mnuActAddIDEntryClick
      end
      object mnuActAttachtoIDParent: TMenuItem
        Caption = 'A&ttach to Interdisciplinary Note'
        OnClick = mnuActAttachtoIDParentClick
      end
      object mnuActDetachFromIDParent: TMenuItem
        Caption = 'Detac&h from Interdisciplinary Note'
        OnClick = mnuActDetachFromIDParentClick
      end
      object mnuEncounter: TMenuItem
        Caption = 'Encounte&r'
        ShortCut = 24658
        OnClick = cmdPCEClick
      end
      object Z4: TMenuItem
        Caption = '-'
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
      end
      object mnuActSignList: TMenuItem
        Caption = 'Add to Signature &List'
        Hint = 'Adds the currently displayed note to list of things to be signed'
        OnClick = mnuActSignListClick
      end
      object mnuActDelete: TMenuItem
        Caption = '&Delete Progress Note...'
        ShortCut = 24644
        OnClick = mnuActDeleteClick
      end
      object mnuActEdit: TMenuItem
        Caption = '&Edit Progress Note...'
        ShortCut = 24645
        OnClick = mnuActEditClick
      end
      object mnuActSave: TMenuItem
        Caption = 'S&ave without Signature'
        Hint = 'Saves the note that is being edited'
        ShortCut = 24641
        OnClick = mnuActSaveClick
      end
      object mnuActSign: TMenuItem
        Caption = 'Si&gn Note Now...'
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
        OnClick = mnuEditTemplatesClick
      end
      object mnuNewTemplate: TMenuItem
        Caption = 'Create &New Template...'
        OnClick = mnuNewTemplateClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object mnuEditSharedTemplates: TMenuItem
        Caption = 'Edit &Shared Templates...'
        OnClick = mnuEditSharedTemplatesClick
      end
      object mnuNewSharedTemplate: TMenuItem
        Caption = '&Create New Shared Template...'
        OnClick = mnuNewSharedTemplateClick
      end
      object N3: TMenuItem
        Caption = '-'
        OnClick = cmdChangeClick
      end
      object mnuEditDialgFields: TMenuItem
        Caption = 'Edit Template &Fields'
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
      Caption = '&Find in Selected Note'
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
      Caption = '&Delete Progress Note...'
      OnClick = mnuActDeleteClick
    end
    object popNoteMemoEdit: TMenuItem
      Caption = '&Edit Progress Note...'
      OnClick = mnuActEditClick
    end
    object popNoteMemoAddend: TMenuItem
      Caption = '&Make Addendum...'
      OnClick = mnuActAddendClick
    end
    object popNoteMemoSave: TMenuItem
      Caption = 'S&ave without Signature'
      OnClick = mnuActSaveClick
    end
    object popNoteMemoSign: TMenuItem
      Caption = '&Sign Note Now...'
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
    object popNoteMemoViewCslt: TMenuItem
      Caption = 'View Consult Details'
      ShortCut = 24661
      OnClick = popNoteMemoViewCsltClick
    end
  end
  object popNoteList: TPopupMenu
    OnPopup = popNoteListPopup
    Left = 500
    Top = 305
    object popNoteListAll: TMenuItem
      Tag = 1
      Caption = '&Signed Notes (All)'
      OnClick = mnuViewClick
    end
    object popNoteListByAuthor: TMenuItem
      Tag = 4
      Caption = 'Signed Notes by &Author'
      OnClick = mnuViewClick
    end
    object popNoteListByDate: TMenuItem
      Tag = 5
      Caption = 'Signed Notes by Date &Range'
      OnClick = mnuViewClick
    end
    object popNoteListUncosigned: TMenuItem
      Tag = 3
      Caption = 'Un&cosigned Notes'
      OnClick = mnuViewClick
    end
    object popNoteListUnsigned: TMenuItem
      Tag = 2
      Caption = '&Unsigned Notes'
      OnClick = mnuViewClick
    end
    object popNoteListCustom: TMenuItem
      Tag = 6
      Caption = 'Cus&tom View'
      OnClick = mnuViewClick
    end
    object popSearchForText: TMenuItem
      Tag = 7
      Caption = 'Search for Te&xt (Within Current View)'
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
      Caption = 'Add Ne&w Entry to Interdisciplinary Note'
      OnClick = mnuActAddIDEntryClick
    end
    object popNoteListAttachtoIDParent: TMenuItem
      Caption = 'A&ttach to Interdisciplinary Note'
      OnClick = mnuActAttachtoIDParentClick
    end
    object popNoteListDetachFromIDParent: TMenuItem
      Caption = 'Detac&h from Interdisciplinary Note'
      OnClick = mnuActDetachFromIDParentClick
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
  object imgLblNotes: TVA508ImageListLabeler
    Components = <
      item
        Component = lvNotes
      end
      item
        Component = tvNotes
      end>
    Labels = <>
    RemoteLabeler = dmodShared.imgLblNotes
    Left = 16
    Top = 195
  end
  object imgLblImages: TVA508ImageListLabeler
    Components = <
      item
        Component = lvNotes
      end
      item
        Component = tvNotes
      end>
    Labels = <>
    RemoteLabeler = dmodShared.imgLblImages
    Left = 16
    Top = 235
  end
end
