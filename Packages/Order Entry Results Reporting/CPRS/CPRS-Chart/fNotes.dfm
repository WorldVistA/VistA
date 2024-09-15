inherited frmNotes: TfrmNotes
  Left = 0
  Caption = 'frmNotes'
  ClientHeight = 710
  ClientWidth = 1111
  DockSite = True
  Menu = mnuNotes
  Position = poDesigned
  ExplicitWidth = 1127
  ExplicitHeight = 769
  PixelsPerInch = 120
  TextHeight = 13
  inherited shpPageBottom: TShape
    Top = 705
    Width = 1111
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    ExplicitTop = 704
    ExplicitWidth = 1111
  end
  object splHorz: TSplitter [1]
    Left = 201
    Top = 0
    Width = 4
    Height = 705
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Color = clBtnFace
    ParentColor = False
    OnCanResize = splHorzCanResize
    ExplicitHeight = 704
  end
  object pnlLeft: TPanel [2]
    Left = 0
    Top = 0
    Width = 188
    Height = 564
    Align = alLeft
    BevelOuter = bvNone
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 0
    OnExit = pnlLeftExit
    object cmdNewNote: TORAlignButton
      Left = 0
      Top = 679
      Width = 201
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Action = acNewNote
      Align = alBottom
      Caption = 'New Note'
      TabOrder = 1
      OnExit = cmdNewNoteExit
    end
    object cmdPCE: TORAlignButton
      Left = 0
      Top = 651
      Width = 201
      Height = 28
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Action = acPCE
      Align = alBottom
      Caption = 'Encounter'
      TabOrder = 2
      OnExit = cmdPCEExit
    end
    object pnlLeftTop: TPanel
      Left = 0
      Top = 23
      Width = 201
      Height = 628
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      BevelOuter = bvNone
      Color = clWindow
      DoubleBuffered = True
      ParentBackground = False
      ParentDoubleBuffered = False
      TabOrder = 0
      object splDrawers: TSplitter
        Left = 0
        Top = 596
        Width = 201
        Height = 2
        Cursor = crVSplit
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alBottom
        Color = clBtnFace
        ParentColor = False
        OnCanResize = splDrawersCanResize
        ExplicitTop = 598
      end
      object tvNotes: TORTreeView
        Left = 0
        Top = 0
        Width = 201
        Height = 596
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        Constraints.MinHeight = 63
        Constraints.MinWidth = 38
        HideSelection = False
        Images = dmodShared.imgNotes
        Indent = 19
        PopupMenu = popNoteList
        ReadOnly = True
        StateImages = dmodShared.imgImages
        TabOrder = 1
        OnChange = tvNotesChange
        OnCollapsed = tvNotesCollapsed
        OnCompare = tvNotesCompare
        OnDblClick = tvNotesDblClick
        OnDragDrop = tvNotesDragDrop
        OnDragOver = tvNotesDragOver
        OnExit = tvNotesExit
        OnExpanded = tvNotesExpanded
        OnKeyDown = tvNotesKeyDown
        OnStartDrag = tvNotesStartDrag
        Caption = ''
        NodePiece = 0
        ShortNodeCaptions = True
      end
      object pnlDrawers: TPanel
        Left = 0
        Top = 598
        Width = 201
        Height = 30
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alBottom
        BevelOuter = bvNone
        ParentBackground = False
        TabOrder = 2
        Visible = False
        OnResize = pnlDrawersResize
        ExplicitTop = 89
        inline frmDrawers: TfraDrawers
          Left = 0
          Top = 0
          Width = 201
          Height = 30
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alClient
          Constraints.MinWidth = 188
          Color = clBtnFace
          ParentBackground = False
          ParentColor = False
          TabOrder = 0
          OnExit = frmDrawersExit
          OnResize = frmDrawersResize
          ExplicitWidth = 201
          ExplicitHeight = 30
          inherited pnlTemplate: TPanel
            Width = 201
            Height = 131
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ExplicitWidth = 201
            ExplicitHeight = 131
            inherited pnlTemplates: TPanel
              Top = 28
              Width = 201
              Height = 103
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              TabOrder = 1
              ExplicitTop = 28
              ExplicitWidth = 201
              ExplicitHeight = 103
              inherited tvTemplates: TORTreeView
                Top = 51
                Width = 201
                Height = 52
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                ExplicitTop = 51
                ExplicitWidth = 201
                ExplicitHeight = 52
              end
              inherited pnlTemplateSearch: TPanel
                Width = 201
                Height = 51
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                ExplicitWidth = 201
                ExplicitHeight = 51
                DesignSize = (
                  201
                  51)
                inherited edtSearch: TCaptionEdit
                  Width = 133
                  Margins.Left = 4
                  Margins.Top = 4
                  Margins.Right = 4
                  Margins.Bottom = 4
                  TabOrder = 1
                  ExplicitWidth = 133
                end
                inherited btnFind: TORAlignButton
                  Left = 133
                  Width = 68
                  Height = 27
                  Margins.Left = 4
                  Margins.Top = 4
                  Margins.Right = 4
                  Margins.Bottom = 4
                  ExplicitLeft = 133
                  ExplicitWidth = 68
                  ExplicitHeight = 27
                end
                inherited cbWholeWords: TCheckBox
                  Left = 113
                  Top = 30
                  Width = 136
                  Height = 21
                  Margins.Left = 4
                  Margins.Top = 4
                  Margins.Right = 4
                  Margins.Bottom = 4
                  TabOrder = 4
                  ExplicitLeft = 113
                  ExplicitTop = 30
                  ExplicitWidth = 136
                  ExplicitHeight = 21
                end
                inherited cbMatchCase: TCheckBox
                  Left = 5
                  Top = 30
                  Width = 100
                  Height = 21
                  Margins.Left = 4
                  Margins.Top = 4
                  Margins.Right = 4
                  Margins.Bottom = 4
                  TabOrder = 3
                  ExplicitLeft = 5
                  ExplicitTop = 30
                  ExplicitWidth = 100
                  ExplicitHeight = 21
                end
              end
            end
            inherited btnTemplate: TBitBtn
              Top = 0
              Width = 201
              Height = 28
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              TabOrder = 0
              ExplicitTop = 0
              ExplicitWidth = 201
              ExplicitHeight = 28
            end
          end
          inherited pnlEncounter: TPanel
            Top = 131
            Width = 201
            Height = 102
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ExplicitTop = 131
            ExplicitWidth = 201
            ExplicitHeight = 102
            inherited btnEncounter: TBitBtn
              Width = 201
              Height = 28
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitWidth = 201
              ExplicitHeight = 28
            end
            inherited pnlEncounters: TPanel
              Top = 31
              Width = 201
              Height = 71
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitTop = 31
              ExplicitWidth = 201
              ExplicitHeight = 71
              inherited lbEncounter: TORListBox
                Width = 201
                Height = 71
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                ExplicitWidth = 201
                ExplicitHeight = 71
              end
            end
          end
          inherited pnlReminder: TPanel
            Top = 233
            Width = 201
            Height = 101
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ExplicitTop = 233
            ExplicitWidth = 201
            ExplicitHeight = 101
            inherited btnReminder: TBitBtn
              Width = 201
              Height = 28
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitWidth = 201
              ExplicitHeight = 28
            end
            inherited pnlReminders: TPanel
              Top = 30
              Width = 201
              Height = 71
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitTop = 30
              ExplicitWidth = 201
              ExplicitHeight = 71
              inherited tvReminders: TORTreeView
                Width = 201
                Height = 71
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                TabOrder = 1
                ExplicitWidth = 201
                ExplicitHeight = 71
              end
            end
          end
          inherited pnlOrder: TPanel
            Top = 334
            Width = 201
            Height = 114
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ExplicitTop = 334
            ExplicitWidth = 201
            ExplicitHeight = 114
            inherited btnOrder: TBitBtn
              Width = 201
              Height = 28
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitWidth = 201
              ExplicitHeight = 28
            end
            inherited pnlOrders: TPanel
              Top = 30
              Width = 201
              Height = 84
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitTop = 30
              ExplicitWidth = 201
              ExplicitHeight = 84
              inherited lbOrders: TORListBox
                Width = 201
                Height = 84
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                ExplicitWidth = 201
                ExplicitHeight = 84
              end
            end
          end
        end
      end
      object lstNotes: TORListBox
        Left = 25
        Top = 8
        Width = 80
        Height = 22
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
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
        Caption = ''
        ItemTipColor = clWindow
        LongList = False
        Pieces = '2,3'
        TabPositions = '10'
      end
    end
    object stNotes: TVA508StaticText
      Name = 'stNotes'
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 182
      Height = 12
      Align = alTop
      Alignment = taLeftJustify
      AutoSize = True
      BevelOuter = bvNone
      Caption = 'Last 100 Notes'
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 3
      VerticalAlignment = taAlignBottom
      ShowAccelChar = True
      WordWrap = False
      LabelAlignment = taLeftJustify
      LabelLayout = tlTop
    end
  end
  object pnlReminder: TPanel [3]
    Left = 1316
    Top = 295
    Width = 34
    Height = 48
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    BevelOuter = bvNone
    TabOrder = 2
    Visible = False
  end
  object PnlRight: TPanel [4]
    Left = 205
    Top = 0
    Width = 906
    Height = 705
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    OnExit = PnlRightExit
    object pnlNote: TPanel
      Left = 0
      Top = 0
      Width = 906
      Height = 705
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      OnExit = pnlNoteExit
      object splList: TSplitter
        Left = 0
        Top = 142
        Width = 906
        Height = 5
        Cursor = crVSplit
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        Color = clBtnFace
        ParentColor = False
        ExplicitTop = 150
      end
      object spDetails: TSplitter
        Left = 0
        Top = 435
        Width = 906
        Height = 5
        Cursor = crVSplit
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alBottom
        AutoSnap = False
        Color = clBtnFace
        ParentColor = False
        Visible = False
        ExplicitTop = 434
      end
      object splmemPCRead: TSplitter
        Left = 0
        Top = 565
        Width = 906
        Height = 5
        Cursor = crVSplit
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alBottom
        AutoSnap = False
        Color = clBtnFace
        ParentColor = False
        OnMoved = splmemPCEMoved
        ExplicitTop = 564
      end
      object memNote: TRichEdit
        Left = 0
        Top = 147
        Width = 906
        Height = 288
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        Color = clCream
        Ctl3D = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = 'Courier New'
        Font.Style = []
        Constraints.MinHeight = 38
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
        Zoom = 100
      end
      object stTitle: TVA508StaticText
        Name = 'stTitle'
        Left = 0
        Top = 0
        Width = 906
        Height = 15
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        Alignment = taLeftJustify
        Caption = 'No Progress Notes Found'
        TabOrder = 0
        VerticalAlignment = taAlignBottom
        ShowAccelChar = True
        ExplicitWidth = 124
      end
      object lvNotes: TCaptionListView
        Left = 0
        Top = 15
        Width = 906
        Height = 127
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        Columns = <
          item
            Caption = 'Date'
            Width = 125
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
            MinWidth = 12
          end
          item
            Caption = 'fmdate'
            Width = 0
          end
          item
            Caption = 'TIUDA'
            Width = 0
          end>
        Constraints.MinHeight = 63
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
        OnDblClick = lvNotesDblClick
        OnKeyDown = lvNotesKeyDown
        OnSelectItem = lvNotesSelectItem
        AutoSize = False
        Caption = 'No Progress Notes Found'
        HideTinyColumns = True
      end
      object CPMemNote: TCopyPasteDetails
        Left = 0
        Top = 440
        Width = 906
        Height = 125
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alBottom
        BevelInner = bvRaised
        BorderStyle = bsSingle
        Caption = 'CPMemNote'
        Constraints.MinHeight = 32
        ShowCaption = False
        TabOrder = 3
        Visible = False
        CopyMonitor = frmFrame.CPAppMon
        CollapseBtn.Left = 878
        CollapseBtn.Top = 0
        CollapseBtn.Width = 20
        CollapseBtn.Height = 20
        CollapseBtn.Margins.Left = 4
        CollapseBtn.Margins.Top = 4
        CollapseBtn.Margins.Right = 4
        CollapseBtn.Margins.Bottom = 4
        CollapseBtn.Align = alRight
        CollapseBtn.Caption = #218
        CollapseBtn.Font.Charset = DEFAULT_CHARSET
        CollapseBtn.Font.Color = clWindowText
        CollapseBtn.Font.Height = -14
        CollapseBtn.Font.Name = 'Wingdings'
        CollapseBtn.Font.Style = []
        CollapseBtn.ParentFont = False
        CollapseBtn.TabOrder = 0
        CollapseBtn.TabStop = False
        EditMonitor.CopyMonitor = frmFrame.CPAppMon
        EditMonitor.OnLoadPastedText = LoadPastedText
        EditMonitor.RelatedPackage = '8925'
        EditMonitor.TrackOnlyEdits = <>
        InfoMessage.AlignWithMargins = True
        InfoMessage.Left = 4
        InfoMessage.Top = 4
        InfoMessage.Width = 765
        InfoMessage.Height = 72
        InfoMessage.Margins.Left = 4
        InfoMessage.Margins.Top = 4
        InfoMessage.Margins.Right = 4
        InfoMessage.Margins.Bottom = 4
        InfoMessage.Align = alClient
        InfoMessage.Font.Charset = ANSI_CHARSET
        InfoMessage.Font.Color = clWindowText
        InfoMessage.Font.Height = -14
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
        InfoSelector.Left = 4
        InfoSelector.Top = 4
        InfoSelector.Width = 109
        InfoSelector.Height = 72
        InfoSelector.Margins.Left = 4
        InfoSelector.Margins.Top = 4
        InfoSelector.Margins.Right = 4
        InfoSelector.Margins.Bottom = 4
        InfoSelector.Style = lbOwnerDrawFixed
        InfoSelector.Align = alClient
        InfoSelector.ItemHeight = 13
        InfoSelector.TabOrder = 0
        OnHide = CPHide
        OnShow = CPShow
        SyncSizes = True
        VisualEdit = memNote
        SaveFindAfter = 0
      end
      object memPCERead: TRichEdit
        Left = 0
        Top = 570
        Width = 906
        Height = 135
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alBottom
        Color = clCream
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Constraints.MinHeight = 25
        Lines.Strings = (
          '<No encounter information entered>')
        ParentFont = False
        PlainText = True
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 4
        Zoom = 100
        OnExit = memPCEReadExit
      end
    end
    object pnlWrite: TPanel
      Left = 0
      Top = 0
      Width = 906
      Height = 705
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      Visible = False
      OnResize = pnlWriteResize
      object spEditDetails: TSplitter
        Left = 0
        Top = 435
        Width = 906
        Height = 5
        Cursor = crVSplit
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alBottom
        AutoSnap = False
        Color = clBtnFace
        ParentColor = False
        Visible = False
        OnMoved = splmemPCEMoved
        ExplicitTop = 434
      end
      object splmemPCEWrite: TSplitter
        Left = 0
        Top = 565
        Width = 906
        Height = 5
        Cursor = crVSplit
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alBottom
        AutoSnap = False
        Color = clBtnFace
        ParentColor = False
        ExplicitTop = 564
      end
      object memNewNote: TRichEdit
        Left = 0
        Top = 121
        Width = 906
        Height = 314
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = 'Courier New'
        Font.Style = []
        Constraints.MinHeight = 38
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
        OnKeyPress = memNewNoteKeyPress
        OnKeyUp = memNewNoteKeyUp
      end
      object CPMemNewNote: TCopyPasteDetails
        Left = 0
        Top = 440
        Width = 906
        Height = 125
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alBottom
        BevelInner = bvRaised
        BorderStyle = bsSingle
        Constraints.MinHeight = 32
        ParentShowHint = False
        ShowCaption = False
        ShowHint = True
        TabOrder = 2
        Visible = False
        CopyMonitor = frmFrame.CPAppMon
        CollapseBtn.Left = 878
        CollapseBtn.Top = 0
        CollapseBtn.Width = 20
        CollapseBtn.Height = 20
        CollapseBtn.Margins.Left = 4
        CollapseBtn.Margins.Top = 4
        CollapseBtn.Margins.Right = 4
        CollapseBtn.Margins.Bottom = 4
        CollapseBtn.Align = alRight
        CollapseBtn.Caption = #218
        CollapseBtn.Font.Charset = DEFAULT_CHARSET
        CollapseBtn.Font.Color = clWindowText
        CollapseBtn.Font.Height = -14
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
        InfoMessage.Left = 4
        InfoMessage.Top = 4
        InfoMessage.Width = 765
        InfoMessage.Height = 72
        InfoMessage.Margins.Left = 4
        InfoMessage.Margins.Top = 4
        InfoMessage.Margins.Right = 4
        InfoMessage.Margins.Bottom = 4
        InfoMessage.Align = alClient
        InfoMessage.Font.Charset = ANSI_CHARSET
        InfoMessage.Font.Color = clWindowText
        InfoMessage.Font.Height = -14
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
        InfoSelector.Left = 4
        InfoSelector.Top = 4
        InfoSelector.Width = 109
        InfoSelector.Height = 72
        InfoSelector.Margins.Left = 4
        InfoSelector.Margins.Top = 4
        InfoSelector.Margins.Right = 4
        InfoSelector.Margins.Bottom = 4
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
      object memPCEWrite: TRichEdit
        Left = 0
        Top = 570
        Width = 906
        Height = 135
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alBottom
        Color = clCream
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Constraints.MinHeight = 25
        Lines.Strings = (
          '<No encounter information entered>')
        ParentFont = False
        PlainText = True
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 3
        Zoom = 100
        OnExit = memPCEWriteExit
      end
      object grdPnl: TGridPanel
        Left = 0
        Top = 0
        Width = 906
        Height = 121
        Align = alTop
        BevelOuter = bvNone
        ColumnCollection = <
          item
            SizeStyle = ssAbsolute
            Value = 60.000000000000000000
          end
          item
            Value = 40.000000000000000000
          end
          item
            Value = 25.000000000000000000
          end
          item
            Value = 35.000000000000000000
          end
          item
            SizeStyle = ssAbsolute
            Value = 100.000000000000000000
          end>
        ControlCollection = <
          item
            Column = 0
            ColumnSpan = 3
            Control = lblNewTitle
            Row = 0
          end
          item
            Column = 3
            Control = stAuthor
            Row = 0
          end
          item
            Column = 0
            ColumnSpan = 2
            Control = lblVisit
            Row = 1
          end
          item
            Column = 2
            Control = stRefDate
            Row = 1
          end
          item
            Column = 3
            Control = stCosigner
            Row = 1
          end
          item
            Column = 4
            Control = cmdChange
            Row = 1
          end
          item
            Column = 0
            Control = lblSubject
            Row = 2
          end
          item
            Column = 1
            ColumnSpan = 4
            Control = txtSubject
            Row = 2
          end>
        DoubleBuffered = True
        ParentDoubleBuffered = False
        RowCollection = <
          item
            Value = 33.504898391225250000
          end
          item
            Value = 33.329632444888350000
          end
          item
            Value = 33.165469163886410000
          end>
        TabOrder = 0
        OnResize = grdPnlResize
        object lblNewTitle: TStaticText
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 119
          Height = 17
          Hint = 'Press "Change..." to select a different title.'
          Align = alClient
          Caption = ' General Medicine Note '
          Color = clCream
          ParentColor = False
          ParentShowHint = False
          ShowAccelChar = False
          ShowHint = True
          TabOrder = 0
          Transparent = False
        end
        object stAuthor: TStaticText
          AlignWithMargins = True
          Left = 547
          Top = 3
          Width = 255
          Height = 34
          Hint = 'Press "Change..." to select a different author.'
          Align = alClient
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Winchester,Charles Emerson III'
          Color = clBtnFace
          ParentColor = False
          ParentShowHint = False
          ShowAccelChar = False
          ShowHint = True
          TabOrder = 1
          Transparent = False
        end
        object lblVisit: TStaticText
          AlignWithMargins = True
          Left = 3
          Top = 43
          Width = 204
          Height = 17
          Align = alClient
          Caption = 'Vst: 10/20/99 Pulmonary Clinic, Dr. Welby'
          Color = clBtnFace
          ParentColor = False
          ShowAccelChar = False
          TabOrder = 2
          Transparent = False
        end
        object stRefDate: TStaticText
          AlignWithMargins = True
          Left = 361
          Top = 43
          Width = 180
          Height = 34
          Hint = 'Press "Change..." to change date/time of note.'
          Align = alClient
          Alignment = taCenter
          AutoSize = False
          Caption = 'stRefDate'
          ParentShowHint = False
          ShowAccelChar = False
          ShowHint = True
          TabOrder = 3
        end
        object stCosigner: TStaticText
          AlignWithMargins = True
          Left = 547
          Top = 43
          Width = 255
          Height = 34
          Hint = 'Press "Change..." to select a different cosigner.'
          Align = alClient
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Expected Cosigner: Winchester,Charles Emerson III'
          Color = clBtnFace
          ParentColor = False
          ParentShowHint = False
          ShowAccelChar = False
          ShowHint = True
          TabOrder = 4
          Transparent = False
        end
        object cmdChange: TButton
          AlignWithMargins = True
          Left = 808
          Top = 43
          Width = 94
          Height = 34
          Action = acChange
          Align = alClient
          Caption = 'Change ...'
          Constraints.MaxHeight = 71
          TabOrder = 5
          OnExit = cmdChangeExit
        end
        object lblSubject: TStaticText
          Left = 0
          Top = 80
          Width = 43
          Height = 17
          Align = alTop
          Caption = 'Subject:'
          TabOrder = 6
        end
        object txtSubject: TCaptionEdit
          AlignWithMargins = True
          Left = 63
          Top = 83
          Width = 839
          Height = 21
          Hint = 'Subject is limited to a maximum of 80 characters.'
          Align = alTop
          MaxLength = 80
          ParentShowHint = False
          ShowHint = True
          TabOrder = 7
          Text = 'txtSubject'
          Caption = #1
        end
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
        'Text = Note Editor'
        'Status = stsOK')
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
        'Status = stsDefault')
      (
        'Component = CPMemNote'
        'Status = stsDefault')
      (
        'Component = CPMemNewNote'
        'Status = stsDefault')
      (
        'Component = memPCERead'
        'Status = stsDefault')
      (
        'Component = memPCEWrite'
        'Status = stsDefault')
      (
        'Component = grdPnl'
        'Status = stsDefault')
      (
        'Component = lblNewTitle'
        'Status = stsDefault')
      (
        'Component = stAuthor'
        'Status = stsDefault')
      (
        'Component = lblVisit'
        'Status = stsDefault')
      (
        'Component = stRefDate'
        'Status = stsDefault')
      (
        'Component = stCosigner'
        'Status = stsDefault')
      (
        'Component = cmdChange'
        'Text = Change Note Properties'
        'Status = stsOK')
      (
        'Component = lblSubject'
        'Status = stsDefault')
      (
        'Component = txtSubject'
        'Text = Note Subject'
        'Status = stsOK'))
  end
  object fldAccessReminders: TVA508ComponentAccessibility
    Component = frmDrawers.btnReminder
    OnStateQuery = fldAccessRemindersStateQuery
    OnInstructionsQuery = fldAccessRemindersInstructionsQuery
    ComponentName = 'Drawer'
    Left = 24
    Top = 64
  end
  object imgLblReminders: TVA508ImageListLabeler
    Components = <
      item
        Component = frmDrawers.tvReminders
      end>
    Labels = <>
    RemoteLabeler = dmodShared.imgLblReminders
    Left = 112
    Top = 64
  end
  object imgLblTemplates: TVA508ImageListLabeler
    Components = <
      item
        Component = frmDrawers.tvTemplates
      end>
    Labels = <>
    RemoteLabeler = dmodShared.imgLblHealthFactorLabels
    Left = 112
    Top = 128
  end
  object fldAccessTemplates: TVA508ComponentAccessibility
    Component = frmDrawers.btnTemplate
    OnStateQuery = fldAccessTemplatesStateQuery
    OnInstructionsQuery = fldAccessTemplatesInstructionsQuery
    ComponentName = 'Drawer'
    Left = 24
    Top = 120
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
    Left = 24
    Top = 251
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
    Left = 24
    Top = 323
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
      Enabled = False
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
      OnUpdate = acNewSharedUpdate
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
  end
end
