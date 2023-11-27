inherited frmConsults: TfrmConsults
  Left = 402
  Top = 80
  HelpContext = 6000
  Caption = 'Consults Page'
  ClientHeight = 421
  ClientWidth = 715
  Menu = mnuConsults
  ExplicitWidth = 731
  ExplicitHeight = 480
  PixelsPerInch = 96
  TextHeight = 13
  inherited shpPageBottom: TShape
    Top = 416
    Width = 715
    ExplicitTop = 416
    ExplicitWidth = 715
  end
  inherited sptHorz: TSplitter
    Left = 83
    Width = 2
    Height = 416
    OnCanResize = sptHorzCanResize
    ExplicitLeft = 83
    ExplicitWidth = 2
    ExplicitHeight = 416
  end
  inherited pnlRight: TPanel [2]
    Left = 85
    Width = 630
    Height = 416
    OnExit = pnlRightExit
    OnResize = pnlRightResize
    ExplicitLeft = 85
    ExplicitWidth = 630
    ExplicitHeight = 416
    object sptVert: TSplitter
      Left = 0
      Top = 350
      Width = 630
      Height = 4
      Cursor = crVSplit
      Align = alBottom
      AutoSnap = False
    end
    object memPCEShow: TRichEdit
      Left = 0
      Top = 354
      Width = 630
      Height = 62
      Align = alBottom
      Color = clCream
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      WantReturns = False
      Zoom = 100
    end
    object pnlResults: TPanel
      Left = 0
      Top = 0
      Width = 630
      Height = 350
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      OnResize = pnlResultsResize
      object spEditDetails: TSplitter
        Left = 0
        Top = 246
        Width = 630
        Height = 4
        Cursor = crVSplit
        Align = alBottom
        AutoSnap = False
        Visible = False
        ExplicitLeft = 4
        ExplicitTop = 217
      end
      object memResults: TRichEdit
        Left = 0
        Top = 67
        Width = 630
        Height = 179
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        PopupMenu = popNoteMemo
        ScrollBars = ssVertical
        TabOrder = 1
        WantTabs = True
        Zoom = 100
        OnChange = memResultChange
        OnKeyDown = memResultsKeyDown
      end
      object pnlFields: TPanel
        Left = 0
        Top = 0
        Width = 630
        Height = 67
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        OnResize = pnlFieldsResize
        DesignSize = (
          630
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
          TabOrder = 1
        end
        object lblAuthor: TStaticText
          Left = 402
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
          TabOrder = 2
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
          Left = 307
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
          TabOrder = 8
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
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          ParentShowHint = False
          ShowAccelChar = False
          ShowHint = True
          TabOrder = 0
        end
        object cmdChange: TButton
          Left = 556
          Top = 6
          Width = 58
          Height = 21
          Anchors = [akTop, akRight]
          Caption = 'Change...'
          TabOrder = 3
          OnClick = cmdChangeClick
        end
        object txtSubject: TCaptionEdit
          Left = 48
          Top = 40
          Width = 566
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
      object CPMemResults: TCopyPasteDetails
        Left = 0
        Top = 250
        Width = 630
        Height = 100
        Align = alBottom
        BevelInner = bvRaised
        BorderStyle = bsSingle
        Constraints.MinHeight = 32
        ShowCaption = False
        TabOrder = 2
        Visible = False
        CopyMonitor = frmFrame.CPAppMon
        CollapseBtn.Left = 605
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
        InfoMessage.Width = 491
        InfoMessage.Height = 49
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
        InfoSelector.Height = 49
        InfoSelector.Style = lbOwnerDrawFixed
        InfoSelector.Align = alClient
        InfoSelector.ItemHeight = 13
        InfoSelector.TabOrder = 0
        OnHide = CPHide
        OnShow = CPShow
        SyncSizes = True
        VisualEdit = memResults
        SaveFindAfter = 0
      end
    end
    object pnlRead: TPanel
      Left = 0
      Top = 0
      Width = 630
      Height = 350
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object lblTitle: TOROffsetLabel
        Left = 0
        Top = 0
        Width = 630
        Height = 19
        Align = alTop
        Caption = 'Details of Selected Consult'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        HorzOffset = 2
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        Transparent = False
        VertOffset = 6
        WordWrap = False
      end
      object spReadDetails: TSplitter
        Left = 0
        Top = 246
        Width = 630
        Height = 4
        Cursor = crVSplit
        Align = alBottom
        AutoSnap = False
        Visible = False
        ExplicitLeft = 4
        ExplicitTop = 240
      end
      object memConsult: TRichEdit
        Left = 0
        Top = 19
        Width = 630
        Height = 227
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
        TabOrder = 0
        WantReturns = False
        WordWrap = False
        Zoom = 100
      end
      object CPMemConsult: TCopyPasteDetails
        Left = 0
        Top = 250
        Width = 630
        Height = 100
        Align = alBottom
        BevelInner = bvRaised
        BorderStyle = bsSingle
        Caption = 'CPMemConsult'
        Constraints.MinHeight = 32
        ShowCaption = False
        TabOrder = 1
        Visible = False
        CopyMonitor = frmFrame.CPAppMon
        CollapseBtn.Left = 605
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
        EditMonitor.OnSaveTheMonitor = SaveTheMonitor
        EditMonitor.RelatedPackage = '8925'
        EditMonitor.TrackOnlyEdits = <>
        InfoMessage.AlignWithMargins = True
        InfoMessage.Left = 3
        InfoMessage.Top = 3
        InfoMessage.Width = 491
        InfoMessage.Height = 49
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
        InfoSelector.Height = 49
        InfoSelector.Style = lbOwnerDrawFixed
        InfoSelector.Align = alClient
        InfoSelector.ItemHeight = 13
        InfoSelector.TabOrder = 0
        OnHide = CPHide
        OnShow = CPShow
        SyncSizes = True
        VisualEdit = memConsult
        SaveFindAfter = 0
      end
    end
  end
  inherited pnlLeft: TPanel [3]
    Width = 83
    Height = 416
    OnExit = pnlLeftExit
    OnResize = pnlLeftResize
    ExplicitWidth = 83
    ExplicitHeight = 416
    object splConsults: TSplitter
      Left = 0
      Top = 161
      Width = 83
      Height = 3
      Cursor = crVSplit
      Align = alTop
    end
    object pnlAction: TPanel
      Left = 0
      Top = 164
      Width = 83
      Height = 231
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object splDrawers: TSplitter
        Left = 0
        Top = 228
        Width = 83
        Height = 3
        Cursor = crVSplit
        Align = alBottom
      end
      object cmdNewConsult: TORAlignButton
        Left = 0
        Top = 21
        Width = 83
        Height = 21
        Align = alTop
        Caption = 'New Consult'
        Constraints.MinHeight = 21
        Default = True
        TabOrder = 1
        OnClick = cmdNewConsultClick
        OnExit = cmdNewConsultExit
      end
      object cmdNewProc: TORAlignButton
        Left = 0
        Top = 42
        Width = 83
        Height = 21
        Align = alTop
        Caption = 'New Procedure'
        Constraints.MinHeight = 21
        TabOrder = 2
        OnClick = cmdNewProcClick
      end
      object cmdEditResubmit: TORAlignButton
        Left = 0
        Top = 0
        Width = 83
        Height = 21
        Align = alTop
        Caption = 'Edit/Resubmit'
        Constraints.MinHeight = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        Visible = False
        OnClick = cmdEditResubmitClick
        OnExit = cmdEditResubmitExit
      end
      object lstNotes: TORListBox
        Left = 0
        Top = 63
        Width = 83
        Height = 24
        Style = lbOwnerDrawFixed
        ItemHeight = 13
        ParentShowHint = False
        PopupMenu = popNoteMemo
        ShowHint = True
        TabOrder = 6
        Visible = False
        OnClick = lstNotesClick
        Caption = ''
        ItemTipColor = clWindow
        LongList = False
        Pieces = '2,3'
        TabPositions = '10'
      end
      object tvCsltNotes: TORTreeView
        Left = 0
        Top = 63
        Width = 83
        Height = 165
        Align = alClient
        Constraints.MinWidth = 30
        HideSelection = False
        Images = dmodShared.imgNotes
        Indent = 19
        PopupMenu = popNoteList
        ReadOnly = True
        StateImages = dmodShared.imgImages
        TabOrder = 3
        OnChange = tvCsltNotesChange
        OnClick = tvCsltNotesClick
        OnCollapsed = tvCsltNotesCollapsed
        OnDragDrop = tvCsltNotesDragDrop
        OnDragOver = tvCsltNotesDragOver
        OnExpanded = tvCsltNotesExpanded
        OnStartDrag = tvCsltNotesStartDrag
        Caption = 'Consult Notes'
        NodePiece = 0
      end
    end
    object cmdPCE: TORAlignButton
      Left = 0
      Top = 395
      Width = 83
      Height = 21
      Align = alBottom
      Caption = 'Encounter'
      Enabled = False
      TabOrder = 2
      Visible = False
      OnClick = cmdPCEClick
    end
    object pnlConsultList: TPanel
      Left = 0
      Top = 0
      Width = 83
      Height = 161
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object lblConsults: TOROffsetLabel
        Left = 0
        Top = 0
        Width = 83
        Height = 19
        Align = alTop
        Caption = 'Consults'
        HorzOffset = 2
        Transparent = True
        VertOffset = 6
        WordWrap = False
      end
      object lstConsults: TORListBox
        Left = 0
        Top = 19
        Width = 83
        Height = 142
        Align = alClient
        Ctl3D = True
        ItemHeight = 13
        ParentCtl3D = False
        ParentShowHint = False
        PopupMenu = popConsultList
        ShowHint = True
        TabOrder = 1
        Visible = False
        OnClick = lstConsultsClick
        Caption = ''
        ItemTipColor = clWindow
        LongList = False
        Pieces = '2,3,4,5'
        TabPositions = '10,15,42'
      end
      object tvConsults: TORTreeView
        Left = 0
        Top = 19
        Width = 83
        Height = 142
        Align = alClient
        HideSelection = False
        Images = dmodShared.imgConsults
        Indent = 19
        PopupMenu = popNoteList
        ReadOnly = True
        TabOrder = 3
        OnClick = tvConsultsClick
        OnCollapsed = tvConsultsCollapsed
        OnExit = tvConsultsExit
        OnExpanded = tvConsultsExpanded
        OnKeyUp = tvConsultsKeyUp
        Caption = 'Consults'
        NodePiece = 0
        ShortNodeCaptions = True
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlRead'
        'Status = stsDefault')
      (
        'Component = memConsult'
        'Status = stsDefault')
      (
        'Component = memPCEShow'
        'Status = stsDefault')
      (
        'Component = pnlResults'
        'Status = stsDefault')
      (
        'Component = memResults'
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
        'Component = pnlAction'
        'Status = stsDefault')
      (
        'Component = cmdNewConsult'
        'Status = stsDefault')
      (
        'Component = cmdNewProc'
        'Status = stsDefault')
      (
        'Component = cmdEditResubmit'
        'Status = stsDefault')
      (
        'Component = lstNotes'
        'Status = stsDefault')
      (
        'Component = tvCsltNotes'
        'Status = stsDefault')
      (
        'Component = cmdPCE'
        'Status = stsDefault')
      (
        'Component = pnlConsultList'
        'Status = stsDefault')
      (
        'Component = lstConsults'
        'Status = stsDefault')
      (
        'Component = tvConsults'
        'Status = stsDefault')
      (
        'Component = pnlLeft'
        'Status = stsDefault')
      (
        'Component = pnlRight'
        'Status = stsDefault')
      (
        'Component = frmConsults'
        'Status = stsDefault')
      (
        'Component = CPMemConsult'
        'Status = stsDefault')
      (
        'Component = CPMemResults'
        'Status = stsDefault'))
  end
  object popNoteMemo: TPopupMenu
    OnPopup = popNoteMemoPopup
    Left = 589
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
      Caption = 'Re&format Paragraph'
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
      Caption = '&Find in Selected Note/Consult'
      OnClick = popNoteMemoFindClick
    end
    object popNoteMemoReplace: TMenuItem
      Caption = '&Replace Text'
      OnClick = popNoteMemoReplaceClick
    end
    object N14: TMenuItem
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
    object N5: TMenuItem
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
      OnClick = mnuActSignatureListClick
    end
    object popNoteMemoDelete: TMenuItem
      Caption = '&Delete Note...'
      OnClick = mnuActNoteDeleteClick
    end
    object popNoteMemoEdit: TMenuItem
      Caption = '&Edit Note...'
      OnClick = mnuActNoteEditClick
    end
    object popNoteMemoAddend: TMenuItem
      Caption = '&Make Addendum...'
      OnClick = mnuActMakeAddendumClick
    end
    object popNoteMemoSave: TMenuItem
      Caption = 'S&ave without Signature'
      OnClick = mnuActSignatureSaveClick
    end
    object popNoteMemoSign: TMenuItem
      Caption = '&Sign Note Now...'
      OnClick = mnuActSignatureSignClick
    end
    object popNoteMemoAddlSign: TMenuItem
      Caption = '&Identify Additional Signers'
      OnClick = popNoteMemoAddlSignClick
    end
    object N7: TMenuItem
      Caption = '-'
    end
    object popNoteMemoPrint: TMenuItem
      Caption = 'P&rint Note'
      OnClick = popNoteMemoPrintClick
    end
    object N15: TMenuItem
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
  object popConsultList: TPopupMenu
    Left = 523
    Top = 308
    object popConsultAll: TMenuItem
      Tag = 1
      Caption = '&All Consults'
      OnClick = mnuViewClick
    end
    object popConsultStatus: TMenuItem
      Tag = 2
      Caption = 'Consults by Stat&us'
      OnClick = mnuViewClick
    end
    object popConsultService: TMenuItem
      Tag = 4
      Caption = 'Consults by &Service'
      OnClick = mnuViewClick
    end
    object popConsultDates: TMenuItem
      Tag = 5
      Caption = 'Consults by Date &Range'
      OnClick = mnuViewClick
    end
    object popConsultCustom: TMenuItem
      Tag = 6
      Caption = '&Custom View..'
      OnClick = mnuViewClick
    end
  end
  object mnuConsults: TMainMenu
    Left = 461
    Top = 305
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
        Caption = '&All Consults'
        OnClick = mnuViewClick
      end
      object mnuViewByStatus: TMenuItem
        Tag = 2
        Caption = 'Consults by Stat&us'
        OnClick = mnuViewClick
      end
      object mnuViewByService: TMenuItem
        Tag = 4
        Caption = 'Consults by &Service'
        OnClick = mnuViewClick
      end
      object mnuViewByDate: TMenuItem
        Tag = 5
        Caption = 'Consults by Date &Range'
        OnClick = mnuViewClick
      end
      object mnuViewCustom: TMenuItem
        Tag = 6
        Caption = 'Custo&m View'
        OnClick = mnuViewClick
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object mnuViewSaveAsDefault: TMenuItem
        Caption = 'Sa&ve as Default View'
        OnClick = mnuViewSaveAsDefaultClick
      end
      object mnuViewReturntoDefault: TMenuItem
        Caption = 'Return to De&fault View'
        OnClick = mnuViewReturntoDefaultClick
      end
      object N13: TMenuItem
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
        Caption = '&New...'
        Hint = 'Add consults or procedures'
        object mnuActNewConsultRequest: TMenuItem
          Tag = 1
          Caption = '&Consult...'
          Hint = 'Creates a new consult'
          OnClick = mnuActNewConsultRequestClick
        end
        object mnuActNewProcedure: TMenuItem
          Tag = 9
          Caption = '&Procedure...'
          Hint = 'Creates a new procedure'
          OnClick = mnuActNewProcedureClick
        end
      end
      object Z2: TMenuItem
        Caption = '-'
      end
      object mnuActConsultRequest: TMenuItem
        Caption = '&Consult Tracking...'
        Hint = 'Actions related to the selected consult'
        object mnuActReceive: TMenuItem
          Tag = 1
          Caption = '&Receive'
          OnClick = mnuActConsultClick
        end
        object mnuActSchedule: TMenuItem
          Tag = 10
          Caption = 'Schedu&le'
          OnClick = mnuActConsultClick
        end
        object mnuActDeny: TMenuItem
          Tag = 2
          Caption = '&Cancel (Deny)'
          OnClick = mnuActConsultClick
        end
        object mnuActEditResubmit: TMenuItem
          Caption = '&Edit/Resubmit'
          OnClick = mnuActEditResubmitClick
        end
        object mnuActDiscontinue: TMenuItem
          Tag = 3
          Caption = '&Discontinue'
          OnClick = mnuActConsultClick
        end
        object mnuActForward: TMenuItem
          Tag = 4
          Caption = '&Forward'
          OnClick = mnuActConsultClick
        end
        object mnuActAddComment: TMenuItem
          Tag = 5
          Caption = '&Add Comment'
          OnClick = mnuActConsultClick
        end
        object mnuActSigFindings: TMenuItem
          Tag = 8
          Caption = '&Significant Findings'
          OnClick = mnuActConsultClick
        end
        object mnuActAdminComplete: TMenuItem
          Tag = 9
          Caption = 'Ad&ministrative Complete'
          OnClick = mnuActConsultClick
        end
        object N3: TMenuItem
          Caption = '-'
        end
        object mnuActDisplayDetails: TMenuItem
          Caption = 'Display De&tails'
          OnClick = mnuActDisplayDetailsClick
        end
        object mnuActDisplayResults: TMenuItem
          Caption = 'Display Res&ults'
          OnClick = mnuActDisplayResultsClick
        end
        object mnuActDisplaySF513: TMenuItem
          Caption = 'Display SF &513'
          OnClick = mnuActDisplaySF513Click
        end
        object mnuActPrintSF513: TMenuItem
          Caption = '&Print SF 513'
          OnClick = mnuActPrintSF513Click
        end
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object mnuActConsultResults: TMenuItem
        Caption = 'Consult &Results...'
        object mnuActComplete: TMenuItem
          Tag = 6
          Caption = 'Complete/&Update Results...'
          ShortCut = 24661
          OnClick = mnuActCompleteClick
        end
        object mnuActMakeAddendum: TMenuItem
          Tag = 7
          Caption = '&Make Addendum...'
          Hint = 'Makes an addendum for the currently selected consult'
          ShortCut = 24653
          OnClick = mnuActMakeAddendumClick
        end
        object mnuActAddIDEntry: TMenuItem
          Caption = 'Add Ne&w Entry to Interdisciplinary Note'
          OnClick = mnuActAddIDEntryClick
        end
        object mnuActAttachtoIDParent: TMenuItem
          Caption = 'Attach to Interdisciplinary Note'
          OnClick = mnuActAttachtoIDParentClick
        end
        object mnuActDetachFromIDParent: TMenuItem
          Caption = 'Detac&h from Interdisciplinary Note'
          OnClick = mnuActDetachFromIDParentClick
        end
        object N12: TMenuItem
          Caption = '-'
        end
        object mnuActAttachMed: TMenuItem
          Caption = 'A&ttach Medicine Results'
          OnClick = mnuActAttachMedClick
        end
        object mnuActRemoveMed: TMenuItem
          Caption = 'Remo&ve Medicine Results'
          OnClick = mnuActRemoveMedClick
        end
        object N9: TMenuItem
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
        object N2: TMenuItem
          Caption = '-'
        end
        object mnuActSignatureList: TMenuItem
          Caption = 'Add to Signature &List'
          Hint = 
            'Adds the currently displayed consult to list of things to be sig' +
            'ned'
          OnClick = mnuActSignatureListClick
        end
        object mnuActNoteDelete: TMenuItem
          Caption = '&Delete Note...'
          ShortCut = 24644
          OnClick = mnuActNoteDeleteClick
        end
        object mnuActNoteEdit: TMenuItem
          Caption = '&Edit Note...'
          ShortCut = 24645
          OnClick = mnuActNoteEditClick
        end
        object mnuActSignatureSave: TMenuItem
          Caption = 'S&ave Without Signature'
          Hint = 'Saves the consult that is being edited'
          ShortCut = 24641
          OnClick = mnuActSignatureSaveClick
        end
        object mnuActSignatureSign: TMenuItem
          Caption = 'Si&gn Note Now...'
          ShortCut = 24647
          OnClick = mnuActSignatureSignClick
        end
        object mnuActIdentifyAddlSigners: TMenuItem
          Caption = '&Identify Additional Signers'
          OnClick = mnuActIdentifyAddlSignersClick
        end
        object N8: TMenuItem
          Caption = '-'
        end
        object mnuActNotePrint: TMenuItem
          Caption = 'P&rint Note'
          OnClick = mnuActNotePrintClick
        end
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
      object N6: TMenuItem
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
      object N10: TMenuItem
        Caption = '-'
      end
      object mnuEditDialgFields: TMenuItem
        Caption = 'Edit Template &Fields'
        OnClick = mnuEditDialgFieldsClick
      end
    end
  end
  object timAutoSave: TTimer
    Enabled = False
    Interval = 300000
    OnTimer = timAutoSaveTimer
    Left = 602
    Top = 110
  end
  object popNoteList: TPopupMenu
    OnPopup = popNoteListPopup
    Left = 395
    Top = 307
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
    object N11: TMenuItem
      Caption = '-'
    end
    object popNoteListAddIDEntry: TMenuItem
      Caption = 'Add Ne&w Entry to Interdisciplinary Note'
      OnClick = mnuActAddIDEntryClick
    end
    object popNoteListAttachtoIDParent: TMenuItem
      Caption = 'Attach to Interdisciplinary Note'
      OnClick = mnuActAttachtoIDParentClick
    end
    object popNoteListDetachFromIDParent: TMenuItem
      Caption = 'Detac&h from Interdisciplinary Note'
      OnClick = mnuActDetachFromIDParentClick
    end
  end
  object dlgFindText: TFindDialog
    Options = [frDown, frHideUpDown]
    OnFind = dlgFindTextFind
    Left = 628
    Top = 303
  end
  object dlgReplaceText: TReplaceDialog
    OnFind = dlgReplaceTextFind
    OnReplace = dlgReplaceTextReplace
    Left = 665
    Top = 303
  end
  object imgLblNotes: TVA508ImageListLabeler
    Components = <
      item
        Component = tvCsltNotes
      end>
    Labels = <>
    RemoteLabeler = dmodShared.imgLblNotes
    Left = 16
    Top = 48
  end
  object imgLblImages: TVA508ImageListLabeler
    Components = <
      item
        Component = tvCsltNotes
      end>
    Labels = <>
    RemoteLabeler = dmodShared.imgLblImages
    Left = 8
    Top = 88
  end
  object imgLblConsults: TVA508ImageListLabeler
    Components = <
      item
        Component = tvConsults
      end>
    Labels = <>
    RemoteLabeler = dmodShared.imgLblConsults
    Left = 56
    Top = 96
  end
end
