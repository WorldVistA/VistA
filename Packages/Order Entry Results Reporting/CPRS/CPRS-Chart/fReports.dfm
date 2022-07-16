inherited frmReports: TfrmReports
  Left = 356
  Top = 69
  HelpContext = 9000
  Caption = 'Reports Page'
  ClientHeight = 784
  ClientWidth = 1111
  HelpFile = 'qnoback'
  OnDestroy = FormDestroy
  ExplicitWidth = 1129
  ExplicitHeight = 829
  PixelsPerInch = 120
  TextHeight = 16
  inherited shpPageBottom: TShape
    Top = 771
    Width = 1111
    Height = 13
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    ExplicitTop = 771
    ExplicitWidth = 1111
    ExplicitHeight = 13
  end
  inherited sptHorz: TSplitter
    Left = 149
    Height = 771
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    OnMoved = sptHorzMoved
    ExplicitLeft = 149
    ExplicitHeight = 771
  end
  inherited pnlLeft: TPanel
    Width = 149
    Height = 771
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Constraints.MinWidth = 46
    ExplicitWidth = 149
    ExplicitHeight = 771
    object Splitter1: TSplitter
      Left = 0
      Top = 325
      Width = 149
      Height = 6
      Cursor = crVSplit
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alBottom
      Color = clBtnFace
      ParentColor = False
      OnCanResize = Splitter1CanResize
    end
    object pnlLefTop: TPanel
      Left = 0
      Top = 0
      Width = 149
      Height = 325
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      BevelOuter = bvNone
      Constraints.MinWidth = 38
      TabOrder = 0
      object lblTypes: TOROffsetLabel
        Left = 0
        Top = 0
        Width = 149
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        Caption = 'Available Reports'
        HorzOffset = 3
        Transparent = True
        VertOffset = 6
        WordWrap = False
      end
      object tvReports: TORTreeView
        Left = 0
        Top = 24
        Width = 149
        Height = 301
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        HideSelection = False
        Indent = 18
        ReadOnly = True
        TabOrder = 0
        OnClick = tvReportsClick
        OnCollapsing = tvReportsCollapsing
        OnExpanding = tvReportsExpanding
        OnKeyDown = tvReportsKeyDown
        Caption = 'Available Reports'
        NodePiece = 0
      end
    end
    object pnlLeftBottom: TPanel
      Left = 0
      Top = 456
      Width = 149
      Height = 315
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alBottom
      Anchors = [akLeft, akTop, akRight, akBottom]
      BevelOuter = bvNone
      TabOrder = 1
      Visible = False
      object lblQualifier: TOROffsetLabel
        Left = 0
        Top = 0
        Width = 149
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        HorzOffset = 3
        Transparent = True
        VertOffset = 4
        WordWrap = False
      end
      object lblHeaders: TLabel
        Left = 0
        Top = 16
        Width = 149
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        Caption = 'Headings'
        Transparent = True
        Visible = False
        ExplicitWidth = 59
      end
      object lstHeaders: TORListBox
        Left = 0
        Top = 32
        Width = 149
        Height = 283
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Visible = False
        OnClick = lstHeadersClick
        Caption = 'Headings'
        ItemTipColor = clWindow
        LongList = False
        Pieces = '2'
      end
      object lstQualifier: TORListBox
        Left = 0
        Top = 32
        Width = 149
        Height = 283
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Style = lbOwnerDrawFixed
        Align = alClient
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = lstQualifierClick
        OnDrawItem = lstQualifierDrawItem
        Caption = ''
        ItemTipColor = clWindow
        LongList = False
        Pieces = '2,3'
        TabPositions = '10'
      end
      object pnlViews: TORAutoPanel
        Left = 0
        Top = 32
        Width = 149
        Height = 283
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 3
        Visible = False
        object pnlTopViews: TPanel
          Left = 0
          Top = 0
          Width = 149
          Height = 100
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          DesignSize = (
            149
            100)
          object lblDateRange: TLabel
            Left = 0
            Top = 79
            Width = 73
            Height = 16
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Anchors = [akLeft, akTop, akRight]
            Caption = 'Date Range'
          end
          object chkDualViews: TCheckBox
            Left = 0
            Top = 0
            Width = 151
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Anchors = [akLeft, akTop, akRight]
            Caption = 'Split Views'
            TabOrder = 0
            OnClick = chkDualViewsClick
          end
          object btnGraphSelections: TORAlignButton
            Left = 0
            Top = 25
            Width = 149
            Height = 26
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Anchors = [akLeft, akTop, akRight]
            Caption = 'Select/Define...'
            TabOrder = 1
            OnClick = btnGraphSelectionsClick
          end
          object btnChangeView: TORAlignButton
            Left = 0
            Top = 51
            Width = 149
            Height = 27
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Anchors = [akLeft, akTop, akRight]
            Caption = 'Settings...'
            TabOrder = 2
            OnClick = btnChangeViewClick
          end
        end
        object lstDateRange: TORListBox
          Left = 0
          Top = 100
          Width = 149
          Height = 183
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = lstDateRangeClick
          Caption = ''
          ItemTipColor = clWindow
          LongList = False
          Pieces = '2'
          TabPositions = '10'
        end
      end
    end
    object pnlProcedures: TPanel
      Left = 0
      Top = 331
      Width = 149
      Height = 125
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 2
      Visible = False
      object lblProcedures: TOROffsetLabel
        Left = 0
        Top = 0
        Width = 149
        Height = 19
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        Caption = 'Radiology Procedures'
        Color = clBtnFace
        HorzOffset = 2
        ParentColor = False
        Transparent = False
        VertOffset = 2
        WordWrap = False
      end
      object tvProcedures: TORTreeView
        Left = 0
        Top = 19
        Width = 149
        Height = 106
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        HideSelection = False
        Indent = 19
        ReadOnly = True
        TabOrder = 0
        OnChange = tvProceduresChange
        OnClick = tvProceduresClick
        OnCollapsing = tvProceduresCollapsing
        OnExpanding = tvProceduresExpanding
        OnKeyDown = tvProceduresKeyDown
        Caption = 'tvProcedures'
        NodePiece = 0
      end
    end
  end
  inherited pnlRight: TPanel
    Left = 154
    Width = 957
    Height = 771
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Constraints.MinWidth = 38
    ExplicitLeft = 154
    ExplicitWidth = 957
    ExplicitHeight = 771
    object sptHorzRight: TSplitter
      Left = 0
      Top = 226
      Width = 957
      Height = 4
      Cursor = crVSplit
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      Visible = False
      ExplicitWidth = 958
    end
    object sptHorzRightTop: TSplitter
      Left = 0
      Top = 110
      Width = 957
      Height = 4
      Cursor = crVSplit
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      Visible = False
      ExplicitWidth = 958
    end
    object pnlRightTop: TPanel
      Left = 0
      Top = 0
      Width = 957
      Height = 110
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object lblProcTypeMsg: TOROffsetLabel
        Left = 0
        Top = 0
        Width = 957
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        HorzOffset = 3
        Transparent = False
        VertOffset = 2
        WordWrap = False
        ExplicitWidth = 958
      end
      object TabControl1: TTabControl
        Left = 0
        Top = 88
        Width = 957
        Height = 22
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alBottom
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        HotTrack = True
        ParentFont = False
        Style = tsButtons
        TabHeight = 18
        TabOrder = 0
        TabStop = False
        Visible = False
        OnChange = TabControl1Change
      end
      object pnlTopRtLabel: TPanel
        Left = 0
        Top = 21
        Width = 957
        Height = 32
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        TabOrder = 1
        object lblTitle: TOROffsetLabel
          Left = 9
          Top = 1
          Width = 759
          Height = 30
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alClient
          Color = clCream
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          HorzOffset = 3
          ParentColor = False
          ParentFont = False
          Transparent = False
          VertOffset = 2
          WordWrap = False
          ExplicitHeight = 29
        end
        object chkMaxFreq: TCheckBox
          Left = 828
          Top = 1
          Width = 121
          Height = 30
          Hint = 'Remove Max/Site limit (shown for programmers only)'
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alRight
          Caption = 'Max/Site OFF'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          Visible = False
          OnClick = chkMaxFreqClick
        end
        object btnClear: TButton
          Left = 768
          Top = 1
          Width = 60
          Height = 30
          Hint = 'Clear default settings and reload (only shown for programmers)'
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alRight
          Caption = 'Clear'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          Visible = False
          OnClick = btnClearClick
        end
        object btnAppearRt: TButton
          Left = 949
          Top = 1
          Width = 7
          Height = 30
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alRight
          Caption = '      '
          Enabled = False
          TabOrder = 2
          OnClick = btnAppearRtClick
        end
        object btnAppearLt: TButton
          Left = 1
          Top = 1
          Width = 8
          Height = 30
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alLeft
          Caption = '      '
          Enabled = False
          TabOrder = 3
        end
      end
      object pnlRightTopHeaderMid: TPanel
        Left = 0
        Top = 53
        Width = 957
        Height = 35
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        TabOrder = 2
        Visible = False
        object pnlRightTopHeaderMidUpper: TPanel
          Left = 1
          Top = 1
          Width = 955
          Height = 33
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alClient
          Color = clInfoBk
          TabOrder = 0
          object grpDateRange: TGroupBox
            Left = 1
            Top = 1
            Width = 953
            Height = 31
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Align = alClient
            Color = clCream
            ParentColor = False
            TabOrder = 0
            object rdo1Week: TRadioButton
              Tag = 2
              AlignWithMargins = True
              Left = 216
              Top = 4
              Width = 73
              Height = 26
              Margins.Left = 6
              Margins.Top = 1
              Margins.Right = 6
              Margins.Bottom = 1
              Caption = '1 Week'
              TabOrder = 2
              OnClick = rdo1WeekClick
            end
            object rdo1Month: TRadioButton
              Tag = 3
              AlignWithMargins = True
              Left = 296
              Top = 4
              Width = 82
              Height = 26
              Margins.Left = 6
              Margins.Top = 1
              Margins.Right = 6
              Margins.Bottom = 1
              Caption = '1 Month'
              TabOrder = 3
              OnClick = rdo1MonthClick
            end
            object rdo6Month: TRadioButton
              Tag = 4
              AlignWithMargins = True
              Left = 385
              Top = 4
              Width = 81
              Height = 26
              Margins.Left = 6
              Margins.Top = 1
              Margins.Right = 6
              Margins.Bottom = 1
              Caption = '6 Months'
              TabOrder = 4
              OnClick = rdo6MonthClick
            end
            object rdo1Year: TRadioButton
              Tag = 5
              AlignWithMargins = True
              Left = 474
              Top = 4
              Width = 62
              Height = 26
              Margins.Left = 6
              Margins.Top = 1
              Margins.Right = 6
              Margins.Bottom = 1
              Caption = '1 Year'
              TabOrder = 5
              OnClick = rdo1YearClick
            end
            object rdo2Year: TRadioButton
              Tag = 6
              AlignWithMargins = True
              Left = 544
              Top = 4
              Width = 76
              Height = 26
              Margins.Left = 6
              Margins.Top = 1
              Margins.Right = 6
              Margins.Bottom = 1
              Caption = '2 Years'
              TabOrder = 6
              OnClick = rdo2YearClick
            end
            object rdoAllResults: TRadioButton
              Tag = 7
              AlignWithMargins = True
              Left = 626
              Top = 4
              Width = 94
              Height = 26
              Margins.Left = 6
              Margins.Top = 1
              Margins.Right = 6
              Margins.Bottom = 1
              Caption = 'All Results'
              TabOrder = 7
              OnClick = rdoAllResultsClick
            end
            object rdoToday: TRadioButton
              Tag = 1
              AlignWithMargins = True
              Left = 140
              Top = 4
              Width = 69
              Height = 26
              Margins.Left = 6
              Margins.Top = 1
              Margins.Right = 6
              Margins.Bottom = 1
              Caption = 'Today'
              TabOrder = 1
              OnClick = rdoTodayClick
            end
            object rdoDateRange: TRadioButton
              AlignWithMargins = True
              Left = 13
              Top = 4
              Width = 120
              Height = 26
              Margins.Left = 6
              Margins.Top = 1
              Margins.Right = 6
              Margins.Bottom = 1
              Caption = 'Date Range...'
              Checked = True
              TabOrder = 0
              TabStop = True
              OnMouseUp = rdoDateRangeMouseUp
            end
          end
        end
      end
    end
    object pnlRightBottom: TPanel
      Left = 0
      Top = 230
      Width = 957
      Height = 541
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      TabOrder = 2
      object WebBrowser: TWebBrowser
        Left = 1
        Top = 39
        Width = 955
        Height = 342
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabStop = False
        Align = alClient
        TabOrder = 1
        OnDocumentComplete = WebBrowserDocumentComplete
        ExplicitHeight = 343
        ControlData = {
          4C000000F64E0000471C00000000000000000000000000000000000000000000
          000000004C000000000000000000000001000000E0D057007335CF11AE690800
          2B2E126208000000000000004C0000000114020000000000C000000000000046
          8000000000000000000000000000000000000000000000000000000000000000
          00000000000000000100000000000000000000000000000000000000}
      end
      object Memo1: TMemo
        Left = 1
        Top = 1
        Width = 955
        Height = 38
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabStop = False
        Align = alTop
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
        Visible = False
        WantTabs = True
        OnKeyUp = Memo1KeyUp
      end
      object memText: TRichEdit
        Left = 1
        Top = 381
        Width = 955
        Height = 159
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alBottom
        Color = clCream
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Courier New'
        Font.Style = []
        Constraints.MinHeight = 25
        ParentFont = False
        PlainText = True
        PopupMenu = PopupMenu1
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 2
        Visible = False
        WantReturns = False
        WordWrap = False
        Zoom = 100
      end
    end
    object pnlRightMiddle: TPanel
      Left = 0
      Top = 114
      Width = 957
      Height = 112
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      Constraints.MaxHeight = 875
      Constraints.MinHeight = 63
      TabOrder = 1
      Visible = False
      object lvReports: TCaptionListView
        Left = 1
        Top = 1
        Width = 955
        Height = 110
        Hint = 'To sort, click on column headers|'
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        Columns = <>
        Constraints.MinHeight = 63
        HideSelection = False
        MultiSelect = True
        ReadOnly = True
        RowSelect = True
        ParentShowHint = False
        PopupMenu = PopupMenu2
        ShowHint = True
        TabOrder = 0
        ViewStyle = vsReport
        OnColumnClick = lvReportsColumnClick
        OnCompare = lvReportsCompare
        OnKeyUp = lvReportsKeyUp
        OnSelectItem = lvReportsSelectItem
        AutoSize = False
        HideTinyColumns = True
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlLefTop'
        'Status = stsDefault')
      (
        'Component = tvReports'
        'Status = stsDefault')
      (
        'Component = pnlLeftBottom'
        'Status = stsDefault')
      (
        'Component = lstHeaders'
        'Status = stsDefault')
      (
        'Component = lstQualifier'
        'Status = stsDefault')
      (
        'Component = pnlViews'
        'Status = stsDefault')
      (
        'Component = pnlTopViews'
        'Status = stsDefault')
      (
        'Component = chkDualViews'
        'Status = stsDefault')
      (
        'Component = btnGraphSelections'
        'Status = stsDefault')
      (
        'Component = btnChangeView'
        'Status = stsDefault')
      (
        'Component = lstDateRange'
        'Status = stsDefault')
      (
        'Component = pnlProcedures'
        'Status = stsDefault')
      (
        'Component = tvProcedures'
        'Status = stsDefault')
      (
        'Component = pnlRightTop'
        'Status = stsDefault')
      (
        'Component = TabControl1'
        'Status = stsDefault')
      (
        'Component = pnlRightBottom'
        'Status = stsDefault')
      (
        'Component = WebBrowser'
        'Status = stsDefault')
      (
        'Component = Memo1'
        'Status = stsDefault')
      (
        'Component = memText'
        'Status = stsDefault')
      (
        'Component = pnlRightMiddle'
        'Status = stsDefault')
      (
        'Component = lvReports'
        'Status = stsDefault')
      (
        'Component = pnlLeft'
        'Status = stsDefault')
      (
        'Component = pnlRight'
        'Status = stsDefault')
      (
        'Component = frmReports'
        'Status = stsDefault')
      (
        'Component = pnlTopRtLabel'
        'Status = stsDefault')
      (
        'Component = chkMaxFreq'
        'Status = stsDefault')
      (
        'Component = pnlRightTopHeaderMid'
        'Status = stsDefault')
      (
        'Component = pnlRightTopHeaderMidUpper'
        'Status = stsDefault')
      (
        'Component = grpDateRange'
        'Status = stsDefault')
      (
        'Component = rdo1Week'
        'Status = stsDefault')
      (
        'Component = rdo1Month'
        'Status = stsDefault')
      (
        'Component = rdo6Month'
        'Status = stsDefault')
      (
        'Component = rdo1Year'
        'Status = stsDefault')
      (
        'Component = rdo2Year'
        'Status = stsDefault')
      (
        'Component = rdoAllResults'
        'Status = stsDefault')
      (
        'Component = rdoToday'
        'Status = stsDefault')
      (
        'Component = rdoDateRange'
        'Status = stsDefault')
      (
        'Component = btnClear'
        'Status = stsDefault')
      (
        'Component = btnAppearRt'
        'Status = stsDefault')
      (
        'Component = btnAppearLt'
        'Status = stsDefault'))
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 229
    Top = 176
    object Print2: TMenuItem
      Caption = 'Print'
      ShortCut = 16464
      OnClick = Print2Click
    end
    object Copy2: TMenuItem
      Caption = 'Copy'
      ShortCut = 16451
      OnClick = Copy2Click
    end
    object SelectAll2: TMenuItem
      Caption = 'Select All'
      ShortCut = 16449
      OnClick = SelectAll2Click
    end
    object GotoTop1: TMenuItem
      Caption = 'Go to Top'
      OnClick = GotoTop1Click
    end
    object GotoBottom1: TMenuItem
      Caption = 'Go to Bottom'
      OnClick = GotoBottom1Click
    end
    object FreezeText1: TMenuItem
      Caption = 'Freeze Text'
      Enabled = False
      OnClick = FreezeText1Click
    end
    object UnFreezeText1: TMenuItem
      Caption = 'Un-Freeze Text'
      Enabled = False
      OnClick = UnFreezeText1Click
    end
  end
  object calApptRng: TORDateRangeDlg
    DateOnly = False
    Instruction = 'Enter a date range -'
    LabelStart = 'Begin Date'
    LabelStop = 'End Date'
    RequireTime = False
    Format = 'mmm d,yy@hh:nn'
    Left = 325
    Top = 176
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = Timer1Timer
    Left = 389
    Top = 176
  end
  object PopupMenu2: TPopupMenu
    Left = 267
    Top = 174
    object Print1: TMenuItem
      Caption = 'Print'
      ShortCut = 16464
      OnClick = Print1Click
    end
    object Copy1: TMenuItem
      Caption = 'Copy Data From Table'
      ShortCut = 16451
      OnClick = Copy1Click
    end
    object SelectAll1: TMenuItem
      Caption = 'Select All From Table'
      ShortCut = 16449
      OnClick = SelectAll1Click
    end
  end
  object imgLblImages: TVA508ImageListLabeler
    Components = <
      item
        Component = lvReports
      end>
    Labels = <>
    RemoteLabeler = dmodShared.imgLblImages
    Left = 40
    Top = 200
  end
  object CPReports: TCopyEditMonitor
    CopyMonitor = frmFrame.CPAppMon
    OnCopyToMonitor = CopyToMonitor
    RelatedPackage = '8925'
    TrackOnlyEdits = <
      item
        TrackObject = memText
      end>
    Left = 184
    Top = 176
  end
end
