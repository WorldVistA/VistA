inherited frmReports: TfrmReports
  AlignWithMargins = True
  Left = 356
  Top = 69
  HelpContext = 9000
  Margins.Left = 5
  Margins.Top = 5
  Margins.Right = 5
  Margins.Bottom = 5
  Caption = 'Reports Page'
  ClientHeight = 627
  ClientWidth = 889
  HelpFile = 'qnoback'
  ExplicitWidth = 905
  ExplicitHeight = 666
  PixelsPerInch = 96
  TextHeight = 13
  inherited shpPageBottom: TShape
    Top = 617
    Width = 889
    Height = 10
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    ExplicitTop = 617
    ExplicitWidth = 889
    ExplicitHeight = 10
  end
  inherited sptHorz: TSplitter
    Left = 119
    Height = 617
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    OnMoved = sptHorzMoved
    ExplicitLeft = 119
    ExplicitHeight = 617
  end
  inherited pnlLeft: TPanel
    Width = 119
    Height = 617
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Constraints.MinWidth = 37
    ExplicitWidth = 119
    ExplicitHeight = 617
    object Splitter1: TSplitter
      Left = 0
      Top = 260
      Width = 119
      Height = 5
      Cursor = crVSplit
      Align = alBottom
      Color = clBtnFace
      ParentColor = False
      OnCanResize = Splitter1CanResize
    end
    object pnlLefTop: TPanel
      Left = 0
      Top = 0
      Width = 119
      Height = 260
      Align = alClient
      BevelOuter = bvNone
      Constraints.MinWidth = 30
      TabOrder = 0
      object lblTypes: TOROffsetLabel
        Left = 0
        Top = 0
        Width = 119
        Height = 19
        Align = alTop
        Caption = 'Available Reports'
        HorzOffset = 3
        Transparent = True
        VertOffset = 6
        WordWrap = False
      end
      object tvReports: TORTreeView
        Left = 0
        Top = 19
        Width = 119
        Height = 241
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
      Top = 365
      Width = 119
      Height = 252
      Align = alBottom
      Anchors = [akLeft, akTop, akRight, akBottom]
      BevelOuter = bvNone
      TabOrder = 1
      Visible = False
      object lblQualifier: TOROffsetLabel
        Left = 0
        Top = 0
        Width = 119
        Height = 13
        Align = alTop
        HorzOffset = 3
        Transparent = True
        VertOffset = 4
        WordWrap = False
      end
      object lblHeaders: TLabel
        Left = 0
        Top = 13
        Width = 119
        Height = 13
        Align = alTop
        Caption = 'Headings'
        Transparent = True
        Visible = False
        ExplicitWidth = 45
      end
      object lstHeaders: TORListBox
        Left = 0
        Top = 26
        Width = 119
        Height = 226
        Align = alClient
        ItemHeight = 13
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
        Top = 26
        Width = 119
        Height = 226
        Style = lbOwnerDrawFixed
        Align = alClient
        ItemHeight = 13
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
        Top = 26
        Width = 119
        Height = 226
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 3
        Visible = False
        object pnlTopViews: TPanel
          Left = 0
          Top = 0
          Width = 119
          Height = 80
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          DesignSize = (
            119
            80)
          object lblDateRange: TLabel
            Left = 0
            Top = 63
            Width = 58
            Height = 13
            Anchors = [akLeft, akTop, akRight]
            Caption = 'Date Range'
          end
          object chkDualViews: TCheckBox
            Left = 0
            Top = 0
            Width = 121
            Height = 17
            Anchors = [akLeft, akTop, akRight]
            Caption = 'Split Views'
            TabOrder = 0
            OnClick = chkDualViewsClick
          end
          object btnGraphSelections: TORAlignButton
            Left = 0
            Top = 20
            Width = 119
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            Caption = 'Select/Define...'
            TabOrder = 1
            OnClick = btnGraphSelectionsClick
          end
          object btnChangeView: TORAlignButton
            Left = 0
            Top = 41
            Width = 119
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            Caption = 'Settings...'
            TabOrder = 2
            OnClick = btnChangeViewClick
          end
        end
        object lstDateRange: TORListBox
          Left = 0
          Top = 80
          Width = 119
          Height = 146
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ItemHeight = 13
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
      Top = 265
      Width = 119
      Height = 100
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 2
      Visible = False
      object lblProcedures: TOROffsetLabel
        Left = 0
        Top = 0
        Width = 119
        Height = 15
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
        Top = 15
        Width = 119
        Height = 85
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
    Left = 123
    Width = 766
    Height = 617
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Constraints.MinWidth = 30
    ExplicitLeft = 123
    ExplicitWidth = 766
    ExplicitHeight = 617
    object sptHorzRight: TSplitter
      Left = 0
      Top = 225
      Width = 766
      Height = 3
      Cursor = crVSplit
      Align = alTop
      Visible = False
      ExplicitTop = 218
    end
    object sptHorzRightTop: TSplitter
      Left = 0
      Top = 95
      Width = 766
      Height = 3
      Cursor = crVSplit
      Align = alTop
      Visible = False
      ExplicitTop = 88
    end
    object pnlRightTop: TPanel
      Left = 0
      Top = 0
      Width = 766
      Height = 95
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object lblProcTypeMsg: TOROffsetLabel
        Left = 0
        Top = 0
        Width = 766
        Height = 17
        Align = alTop
        HorzOffset = 3
        Transparent = False
        VertOffset = 2
        WordWrap = False
      end
      object TabControl1: TTabControl
        Left = 0
        Top = 77
        Width = 766
        Height = 18
        Align = alBottom
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
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
        Top = 17
        Width = 766
        Height = 32
        Align = alTop
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        object lblTitle: TOROffsetLabel
          Left = 4
          Top = 1
          Width = 613
          Height = 30
          Align = alClient
          Color = clCream
          HorzOffset = 3
          ParentColor = False
          Transparent = False
          VertOffset = 2
          WordWrap = False
          ExplicitLeft = 7
          ExplicitWidth = 3
          ExplicitHeight = 2
        end
        object chkMaxFreq: TCheckBox
          Left = 665
          Top = 1
          Width = 97
          Height = 30
          Hint = 'Remove Max/Site limit (shown for programmers only)'
          Align = alRight
          Caption = 'Max/Site OFF'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          Visible = False
          OnClick = chkMaxFreqClick
        end
        object btnClear: TButton
          Left = 617
          Top = 1
          Width = 48
          Height = 30
          Hint = 'Clear default settings and reload (only shown for programmers)'
          Align = alRight
          Caption = 'Clear'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          Visible = False
          OnClick = btnClearClick
        end
        object btnAppearRt: TButton
          Left = 762
          Top = 1
          Width = 3
          Height = 30
          Align = alRight
          Caption = '      '
          Enabled = False
          TabOrder = 2
          OnClick = btnAppearRtClick
        end
        object btnAppearLt: TButton
          Left = 1
          Top = 1
          Width = 3
          Height = 30
          Align = alLeft
          Caption = '      '
          Enabled = False
          TabOrder = 3
        end
      end
      object pnlRightTopHeaderMid: TPanel
        Left = 0
        Top = 49
        Width = 766
        Height = 28
        Align = alClient
        TabOrder = 2
        Visible = False
        object pnlRightTopHeaderMidUpper: TPanel
          Left = 1
          Top = 1
          Width = 764
          Height = 26
          Align = alClient
          Color = clInfoBk
          TabOrder = 0
          object grpDateRange: TGroupBox
            Left = 1
            Top = 1
            Width = 762
            Height = 24
            Align = alClient
            Color = clCream
            ParentColor = False
            TabOrder = 0
            object rdo1Week: TRadioButton
              Tag = 2
              AlignWithMargins = True
              Left = 173
              Top = 3
              Width = 58
              Height = 17
              Margins.Top = 1
              Margins.Bottom = 1
              Caption = '1 Week'
              TabOrder = 2
              OnClick = rdo1WeekClick
            end
            object rdo1Month: TRadioButton
              Tag = 3
              AlignWithMargins = True
              Left = 237
              Top = 3
              Width = 65
              Height = 17
              Margins.Top = 1
              Margins.Bottom = 1
              Caption = '1 Month'
              TabOrder = 3
              OnClick = rdo1MonthClick
            end
            object rdo6Month: TRadioButton
              Tag = 4
              AlignWithMargins = True
              Left = 308
              Top = 3
              Width = 65
              Height = 17
              Margins.Top = 1
              Margins.Bottom = 1
              Caption = '6 Months'
              TabOrder = 4
              OnClick = rdo6MonthClick
            end
            object rdo1Year: TRadioButton
              Tag = 5
              AlignWithMargins = True
              Left = 379
              Top = 3
              Width = 50
              Height = 17
              Margins.Top = 1
              Margins.Bottom = 1
              Caption = '1 Year'
              TabOrder = 5
              OnClick = rdo1YearClick
            end
            object rdo2Year: TRadioButton
              Tag = 6
              AlignWithMargins = True
              Left = 435
              Top = 3
              Width = 61
              Height = 17
              Margins.Top = 1
              Margins.Bottom = 1
              Caption = '2 Years'
              TabOrder = 6
              OnClick = rdo2YearClick
            end
            object rdoAllResults: TRadioButton
              Tag = 7
              AlignWithMargins = True
              Left = 501
              Top = 3
              Width = 75
              Height = 17
              Margins.Top = 1
              Margins.Bottom = 1
              Caption = 'All Results'
              TabOrder = 7
              OnClick = rdoAllResultsClick
            end
            object rdoToday: TRadioButton
              Tag = 1
              AlignWithMargins = True
              Left = 112
              Top = 3
              Width = 55
              Height = 17
              Margins.Top = 1
              Margins.Bottom = 1
              Caption = 'Today'
              TabOrder = 1
              OnClick = rdoTodayClick
            end
            object rdoDateRange: TRadioButton
              AlignWithMargins = True
              Left = 10
              Top = 3
              Width = 96
              Height = 17
              Margins.Top = 1
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
      Top = 228
      Width = 766
      Height = 389
      Align = alClient
      TabOrder = 2
      object WebBrowser: TWebBrowser
        Left = 1
        Top = 31
        Width = 764
        Height = 230
        TabStop = False
        Align = alClient
        TabOrder = 1
        SelectedEngine = EdgeIfAvailable
        OnDocumentComplete = WebBrowserDocumentComplete
        ExplicitWidth = 753
        ExplicitHeight = 234
        ControlData = {
          4C000000F64E0000C51700000000000000000000000000000000000000000000
          000000004C000000000000000000000001000000E0D057007335CF11AE690800
          2B2E126208000000000000004C0000000114020000000000C000000000000046
          8000000000000000000000000000000000000000000000000000000000000000
          00000000000000000100000000000000000000000000000000000000}
      end
      object Memo1: TMemo
        Left = 1
        Top = 1
        Width = 764
        Height = 30
        TabStop = False
        Align = alTop
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
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
        Top = 261
        Width = 764
        Height = 127
        Align = alBottom
        Color = clCream
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Courier New'
        Font.Style = []
        Constraints.MinHeight = 20
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
      Top = 98
      Width = 766
      Height = 127
      Align = alTop
      Constraints.MaxHeight = 700
      Constraints.MinHeight = 50
      TabOrder = 1
      Visible = False
      object lvReports: TCaptionListView
        Left = 1
        Top = 1
        Width = 764
        Height = 125
        Hint = 'To sort, click on column headers|'
        Align = alClient
        Columns = <>
        Constraints.MinHeight = 50
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
