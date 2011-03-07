inherited frmLabs: TfrmLabs
  Left = 628
  Top = 237
  HelpContext = 8000
  Caption = 'Laboratory Results Page'
  ClientHeight = 701
  HelpFile = 'qnoback'
  OnDestroy = FormDestroy
  ExplicitWidth = 648
  ExplicitHeight = 735
  PixelsPerInch = 96
  TextHeight = 13
  inherited shpPageBottom: TShape
    Top = 696
    ExplicitTop = 355
  end
  inherited sptHorz: TSplitter
    Height = 696
    ExplicitHeight = 355
  end
  object Label1: TLabel [2]
    Left = 144
    Top = 88
    Width = 3
    Height = 13
    Visible = False
  end
  object Label2: TLabel [3]
    Left = 128
    Top = 88
    Width = 3
    Height = 13
    Visible = False
  end
  inherited pnlLeft: TPanel
    Height = 696
    ExplicitHeight = 696
    object Splitter1: TSplitter
      Left = 0
      Top = 436
      Width = 97
      Height = 10
      Cursor = crVSplit
      Align = alBottom
      Color = clBtnFace
      ParentColor = False
      OnCanResize = Splitter1CanResize
      ExplicitLeft = -1
      ExplicitTop = 263
    end
    object pnlLefTop: TPanel
      Left = 0
      Top = 0
      Width = 97
      Height = 436
      Align = alClient
      BevelOuter = bvNone
      Constraints.MinWidth = 30
      TabOrder = 0
      object lblReports: TOROffsetLabel
        Left = 0
        Top = 0
        Width = 97
        Height = 19
        Align = alTop
        Caption = 'Lab Results'
        HorzOffset = 2
        Transparent = False
        VertOffset = 6
        WordWrap = False
        ExplicitLeft = -41
        ExplicitTop = 54
      end
      object tvReports: TORTreeView
        Left = 0
        Top = 19
        Width = 97
        Height = 417
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
      Top = 446
      Width = 97
      Height = 250
      Align = alBottom
      TabOrder = 1
      object lblQualifier: TOROffsetLabel
        Left = 1
        Top = 1
        Width = 95
        Height = 21
        Align = alTop
        HorzOffset = 3
        Transparent = True
        VertOffset = 4
        Visible = False
        WordWrap = False
        ExplicitWidth = 98
      end
      object lblHeaders: TOROffsetLabel
        Left = 1
        Top = 120
        Width = 95
        Height = 17
        Align = alTop
        HorzOffset = 2
        Transparent = False
        VertOffset = 2
        WordWrap = False
        ExplicitTop = 185
        ExplicitWidth = 97
      end
      object lblDates: TOROffsetLabel
        Left = 1
        Top = 105
        Width = 95
        Height = 15
        Align = alTop
        Caption = 'Date Range'
        HorzOffset = 2
        Transparent = False
        VertOffset = 2
        WordWrap = False
        ExplicitLeft = 0
        ExplicitTop = 69
      end
      object lstQualifier: TORListBox
        Left = 1
        Top = 137
        Width = 95
        Height = 112
        Align = alClient
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Visible = False
        OnClick = lstQualifierClick
        ItemTipColor = clWindow
        LongList = False
        Pieces = '2,3'
        TabPositions = '10'
      end
      object lstHeaders: TORListBox
        Left = 1
        Top = 55
        Width = 95
        Height = 50
        Align = alTop
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        Visible = False
        OnClick = lstHeadersClick
        Caption = 'Headings'
        ItemTipColor = clWindow
        LongList = False
        Pieces = '2'
      end
      object lstDates: TORListBox
        Left = 1
        Top = 137
        Width = 95
        Height = 112
        Align = alClient
        ItemHeight = 13
        Items.Strings = (
          'S^Date Range...'
          '1^Today'
          '8^One Week'
          '31^One Month'
          '183^Six Months'
          '366^One Year'
          '732^Two Year'
          '50000^All Results')
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        Visible = False
        OnClick = lstDatesClick
        Caption = 'Date Range'
        ItemTipColor = clWindow
        LongList = False
        Pieces = '2'
      end
      object pnlOtherTests: TORAutoPanel
        Left = 1
        Top = 22
        Width = 95
        Height = 33
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 5
        object bvlOtherTests: TBevel
          Left = 3
          Top = 31
          Width = 90
          Height = 2
        end
        object cmdOtherTests: TButton
          Left = 11
          Top = 4
          Width = 75
          Height = 25
          Caption = 'Other Tests'
          TabOrder = 0
          OnClick = cmdOtherTestsClick
        end
      end
    end
  end
  inherited pnlRight: TPanel
    Height = 696
    OnResize = pnlRightResize
    ExplicitHeight = 696
    object sptHorzRight: TSplitter
      Left = 0
      Top = 296
      Width = 539
      Height = 4
      Cursor = crVSplit
      Align = alTop
      Visible = False
      OnCanResize = sptHorzRightCanResize
      ExplicitTop = 288
    end
    object pnlRightBottom: TPanel
      Left = 0
      Top = 300
      Width = 539
      Height = 376
      Align = alClient
      TabOrder = 0
      object Memo1: TMemo
        Left = 1
        Top = 1
        Width = 537
        Height = 19
        Align = alTop
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        Lines.Strings = (
          '')
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
        Visible = False
        WantTabs = True
        WordWrap = False
        OnKeyUp = Memo1KeyUp
      end
      object memLab: TRichEdit
        Left = 1
        Top = 20
        Width = 537
        Height = 355
        Align = alClient
        Color = clCream
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        PopupMenu = PopupMenu3
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 1
        Visible = False
        WantReturns = False
        WordWrap = False
      end
    end
    object pnlRightTop: TPanel
      Left = 0
      Top = 45
      Width = 539
      Height = 251
      Align = alTop
      TabOrder = 1
      object bvlHeader: TBevel
        Left = 1
        Top = 61
        Width = 537
        Height = 1
        Align = alTop
        ExplicitLeft = -8
        ExplicitTop = 72
        ExplicitWidth = 539
      end
      object pnlHeader: TORAutoPanel
        Left = 1
        Top = 1
        Width = 537
        Height = 60
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object lblDateFloat: TLabel
          Left = 396
          Top = 4
          Width = 56
          Height = 13
          Caption = 'lblDateFloat'
          Visible = False
        end
        object pnlWorksheet: TORAutoPanel
          Left = 0
          Top = 0
          Width = 537
          Height = 60
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          object chkValues: TCheckBox
            Left = 404
            Top = 39
            Width = 93
            Height = 17
            Caption = 'Values'
            Enabled = False
            TabOrder = 5
            OnClick = chkValuesClick
          end
          object chk3D: TCheckBox
            Left = 329
            Top = 39
            Width = 56
            Height = 17
            Caption = '3D'
            Enabled = False
            TabOrder = 4
            OnClick = chk3DClick
          end
          object ragHorV: TRadioGroup
            Left = 12
            Top = 0
            Width = 213
            Height = 36
            Caption = 'Table Format '
            Columns = 2
            ItemIndex = 0
            Items.Strings = (
              '&Horizontal'
              '&Vertical')
            TabOrder = 0
            OnClick = ragHorVClick
          end
          object chkAbnormals: TCheckBox
            Left = 12
            Top = 39
            Width = 221
            Height = 17
            Caption = 'Abnormal Results Only'
            TabOrder = 2
            OnClick = ragHorVClick
          end
          object ragCorG: TRadioGroup
            Left = 252
            Top = 0
            Width = 213
            Height = 36
            Caption = 'Other Formats '
            Columns = 2
            ItemIndex = 0
            Items.Strings = (
              '&Comments'
              '&Graph')
            TabOrder = 1
            OnClick = ragCorGClick
          end
          object chkZoom: TCheckBox
            Left = 253
            Top = 39
            Width = 68
            Height = 17
            Caption = 'Zoom'
            Enabled = False
            TabOrder = 3
            OnClick = chkZoomClick
          end
        end
        object pnlGraph: TORAutoPanel
          Left = 0
          Top = 0
          Width = 537
          Height = 60
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 2
          object lblGraphInfo: TLabel
            Left = 0
            Top = 47
            Width = 537
            Height = 13
            Align = alBottom
            Caption = 
              'To Zoom, hold down the mouse button while dragging an area to be' +
              ' enlarged.'
            ExplicitWidth = 367
          end
          object chkGraph3D: TCheckBox
            Left = 162
            Top = 13
            Width = 61
            Height = 17
            Caption = '3D'
            TabOrder = 1
            OnClick = chkGraph3DClick
          end
          object chkGraphValues: TCheckBox
            Left = 276
            Top = 13
            Width = 101
            Height = 17
            Caption = 'Values'
            TabOrder = 2
            OnClick = chkGraphValuesClick
          end
          object chkGraphZoom: TCheckBox
            Left = 48
            Top = 13
            Width = 97
            Height = 17
            Caption = 'Zoom'
            TabOrder = 0
            OnClick = chkGraphZoomClick
          end
        end
        object pnlButtons: TORAutoPanel
          Left = 0
          Top = 0
          Width = 537
          Height = 60
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          object lblMostRecent: TLabel
            Left = 361
            Top = 16
            Width = 129
            Height = 13
            Caption = 'Most Recent Lab Data'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblSample: TLabel
            Left = 1
            Top = 42
            Width = 64
            Height = 13
            Caption = 'Specimen: '
            Color = clWindow
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentColor = False
            ParentFont = False
          end
          object lblDate: TVA508StaticText
            Name = 'lblDate'
            Left = 150
            Top = 2
            Width = 7
            Height = 15
            Alignment = taCenter
            AutoSize = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
            Visible = False
            OnEnter = lblDateEnter
            ShowAccelChar = True
          end
          object cmdNext: TButton
            Left = 191
            Top = 10
            Width = 82
            Height = 25
            Caption = 'Next >'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBtnText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 3
            OnClick = cmdNextClick
          end
          object cmdPrev: TButton
            Left = 87
            Top = 10
            Width = 82
            Height = 25
            Caption = '< Previous'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBtnText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 2
            OnClick = cmdPrevClick
          end
          object cmdRecent: TButton
            Left = 279
            Top = 10
            Width = 76
            Height = 25
            Caption = 'Newest >>'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBtnText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 4
            OnClick = cmdRecentClick
          end
          object cmdOld: TButton
            Left = 5
            Top = 10
            Width = 76
            Height = 25
            Caption = '<< Oldest'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBtnText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
            OnClick = cmdOldClick
          end
        end
      end
      object grdLab: TCaptionStringGrid
        Left = 1
        Top = 62
        Width = 537
        Height = 33
        Align = alTop
        Color = clCream
        DefaultRowHeight = 15
        RowCount = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing]
        ParentFont = False
        TabOrder = 1
        Visible = False
        OnTopLeftChanged = grdLabTopLeftChanged
        Caption = 'Laboratory Results'
        RowHeights = (
          15
          15)
      end
      object pnlChart: TPanel
        Left = 1
        Top = 95
        Width = 537
        Height = 85
        Align = alTop
        BevelOuter = bvNone
        Caption = 'no results to graph'
        TabOrder = 2
        Visible = False
        object lblGraph: TLabel
          Left = 0
          Top = 72
          Width = 370
          Height = 13
          Alignment = taCenter
          Caption = 
            'Results may be available, but cannot be graphed. Please try an a' +
            'lternate view.'
        end
        object lstTestGraph: TORListBox
          Left = 0
          Top = 0
          Width = 97
          Height = 85
          Align = alLeft
          ItemHeight = 13
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = lstTestGraphClick
          Caption = 'Tests Graphed'
          ItemTipColor = clWindow
          LongList = False
          Pieces = '2'
        end
        object chtChart: TChart
          Left = 97
          Top = 0
          Width = 440
          Height = 85
          AllowPanning = pmNone
          AllowZoom = False
          BackWall.Brush.Color = clWhite
          BackWall.Brush.Style = bsClear
          Title.Text.Strings = (
            'test name')
          Title.Visible = False
          OnClickLegend = chtChartClickLegend
          OnClickSeries = chtChartClickSeries
          OnUndoZoom = chtChartUndoZoom
          LeftAxis.Title.Caption = 'units'
          Legend.Alignment = laTop
          Legend.Inverted = True
          Legend.ShadowSize = 2
          View3D = False
          Align = alClient
          BevelOuter = bvNone
          Color = clSilver
          PopupMenu = popChart
          TabOrder = 1
          OnMouseDown = chtChartMouseDown
          object serHigh: TLineSeries
            Marks.ArrowLength = 8
            Marks.Visible = False
            SeriesColor = clRed
            Title = 'Ref High'
            LinePen.Style = psDash
            Pointer.InflateMargins = True
            Pointer.Style = psRectangle
            Pointer.Visible = False
            XValues.DateTime = True
            XValues.Name = 'X'
            XValues.Multiplier = 1.000000000000000000
            XValues.Order = loAscending
            YValues.DateTime = False
            YValues.Name = 'Y'
            YValues.Multiplier = 1.000000000000000000
            YValues.Order = loNone
          end
          object serLow: TLineSeries
            Marks.ArrowLength = 8
            Marks.Visible = False
            SeriesColor = clRed
            Title = 'Ref Low'
            LinePen.Style = psDash
            Pointer.InflateMargins = True
            Pointer.Style = psRectangle
            Pointer.Visible = False
            XValues.DateTime = False
            XValues.Name = 'X'
            XValues.Multiplier = 1.000000000000000000
            XValues.Order = loAscending
            YValues.DateTime = False
            YValues.Name = 'Y'
            YValues.Multiplier = 1.000000000000000000
            YValues.Order = loNone
          end
          object serTest: TLineSeries
            Marks.ArrowLength = 8
            Marks.Visible = False
            SeriesColor = clBlue
            Title = 'Lab Test'
            Pointer.InflateMargins = True
            Pointer.Style = psCircle
            Pointer.Visible = True
            XValues.DateTime = True
            XValues.Name = 'X'
            XValues.Multiplier = 1.000000000000000000
            XValues.Order = loAscending
            YValues.DateTime = False
            YValues.Name = 'Y'
            YValues.Multiplier = 1.000000000000000000
            YValues.Order = loNone
          end
        end
      end
      object lvReports: TCaptionListView
        Left = 1
        Top = 180
        Width = 537
        Height = 70
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
        TabOrder = 3
        ViewStyle = vsReport
        OnColumnClick = lvReportsColumnClick
        OnCompare = lvReportsCompare
        OnKeyUp = lvReportsKeyUp
        OnSelectItem = lvReportsSelectItem
      end
    end
    object pnlRightTopHeader: TPanel
      Left = 0
      Top = 0
      Width = 539
      Height = 45
      Align = alTop
      TabOrder = 2
      object pnlRightTopHeaderTop: TPanel
        Left = 1
        Top = 1
        Width = 537
        Height = 21
        Align = alTop
        TabOrder = 0
        object lblHeading: TOROffsetLabel
          Left = 137
          Top = 1
          Width = 302
          Height = 19
          Align = alClient
          HorzOffset = 2
          Transparent = False
          VertOffset = 6
          WordWrap = False
          ExplicitWidth = 304
          ExplicitHeight = 25
        end
        object lblTitle: TOROffsetLabel
          Left = 1
          Top = 1
          Width = 136
          Height = 19
          Align = alLeft
          HorzOffset = 3
          Transparent = True
          VertOffset = 6
          WordWrap = False
          ExplicitLeft = 12
          ExplicitTop = 19
        end
        object chkMaxFreq: TCheckBox
          Left = 439
          Top = 1
          Width = 97
          Height = 19
          Align = alRight
          Caption = 'Max/Site OFF'
          TabOrder = 0
          Visible = False
          OnClick = chkMaxFreqClick
        end
      end
      object TabControl1: TTabControl
        Left = 1
        Top = 22
        Width = 537
        Height = 22
        Align = alClient
        HotTrack = True
        Style = tsButtons
        TabHeight = 16
        TabOrder = 1
        Visible = False
        OnChange = TabControl1Change
      end
    end
    object pnlFooter: TORAutoPanel
      Left = 0
      Top = 676
      Width = 539
      Height = 20
      Align = alBottom
      TabOrder = 3
      object lblSpecimen: TLabel
        Left = 4
        Top = 28
        Width = 57
        Height = 13
        Caption = 'lblSpecimen'
        Visible = False
      end
      object lblSingleTest: TLabel
        Left = 88
        Top = 28
        Width = 60
        Height = 13
        Caption = 'lblSingleTest'
        Visible = False
      end
      object lblFooter: TOROffsetLabel
        Left = 1
        Top = 1
        Width = 537
        Height = 25
        Align = alTop
        Caption = 
          '  KEY: "L" = Abnormal Low, "H" = Abnormal High, "*" = Critical V' +
          'alue'
        HorzOffset = 2
        Transparent = False
        VertOffset = 2
        WordWrap = False
        ExplicitTop = 6
        ExplicitWidth = 535
      end
      object lstTests: TORListBox
        Left = 1
        Top = 26
        Width = 537
        Height = 17
        Align = alTop
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Visible = False
        ItemTipColor = clWindow
        LongList = False
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlLeft'
        'Status = stsDefault')
      (
        'Component = pnlRight'
        'Status = stsDefault')
      (
        'Component = frmLabs'
        'Status = stsDefault')
      (
        'Component = pnlRightBottom'
        'Status = stsDefault')
      (
        'Component = Memo1'
        'Status = stsDefault')
      (
        'Component = memLab'
        'Status = stsDefault')
      (
        'Component = pnlRightTop'
        'Status = stsDefault')
      (
        'Component = pnlHeader'
        'Status = stsDefault')
      (
        'Component = pnlWorksheet'
        'Status = stsDefault')
      (
        'Component = chkValues'
        'Status = stsDefault')
      (
        'Component = chk3D'
        'Status = stsDefault')
      (
        'Component = ragHorV'
        'Status = stsDefault')
      (
        'Component = chkAbnormals'
        'Status = stsDefault')
      (
        'Component = ragCorG'
        'Status = stsDefault')
      (
        'Component = chkZoom'
        'Status = stsDefault')
      (
        'Component = pnlGraph'
        'Status = stsDefault')
      (
        'Component = chkGraph3D'
        'Status = stsDefault')
      (
        'Component = chkGraphValues'
        'Status = stsDefault')
      (
        'Component = chkGraphZoom'
        'Status = stsDefault')
      (
        'Component = pnlButtons'
        'Status = stsDefault')
      (
        'Component = lblDate'
        'Text = Date Collected'
        'Status = stsOK')
      (
        'Component = cmdNext'
        'Text = Next'
        'Status = stsOK')
      (
        'Component = cmdPrev'
        'Text = Previous'
        'Status = stsOK')
      (
        'Component = cmdRecent'
        'Text = Newest'
        'Status = stsOK')
      (
        'Component = cmdOld'
        'Text = Oldest'
        'Status = stsOK')
      (
        'Component = grdLab'
        'Status = stsDefault')
      (
        'Component = pnlChart'
        'Status = stsDefault')
      (
        'Component = lstTestGraph'
        'Status = stsDefault')
      (
        'Component = chtChart'
        'Status = stsDefault')
      (
        'Component = pnlRightTopHeader'
        'Status = stsDefault')
      (
        'Component = pnlFooter'
        'Status = stsDefault')
      (
        'Component = lstTests'
        'Status = stsDefault')
      (
        'Component = lvReports'
        'Status = stsDefault')
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
        'Component = lstQualifier'
        'Status = stsDefault')
      (
        'Component = lstHeaders'
        'Status = stsDefault')
      (
        'Component = lstDates'
        'Status = stsDefault')
      (
        'Component = pnlOtherTests'
        'Status = stsDefault')
      (
        'Component = cmdOtherTests'
        'Status = stsDefault')
      (
        'Component = pnlRightTopHeaderTop'
        'Status = stsDefault')
      (
        'Component = chkMaxFreq'
        'Status = stsDefault')
      (
        'Component = TabControl1'
        'Status = stsDefault'))
  end
  object popChart: TPopupMenu
    OnPopup = popChartPopup
    Left = 37
    Top = 277
    object popValues: TMenuItem
      Caption = 'Values'
      OnClick = popValuesClick
    end
    object pop3D: TMenuItem
      Caption = '3D'
      OnClick = pop3DClick
    end
    object popZoom: TMenuItem
      Caption = 'Zoom Enabled'
      OnClick = popZoomClick
    end
    object popZoomBack: TMenuItem
      Caption = 'Zoom Back'
      OnClick = popZoomBackClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object popCopy: TMenuItem
      Caption = 'Copy'
      OnClick = popCopyClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object popDetails: TMenuItem
      Caption = 'Details'
      OnClick = popDetailsClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object popPrint: TMenuItem
      Caption = 'Print'
      OnClick = popPrintClick
    end
  end
  object calLabRange: TORDateRangeDlg
    DateOnly = True
    Instruction = 'Enter a date range -'
    LabelStart = 'Begin Date'
    LabelStop = 'End Date'
    RequireTime = False
    Format = 'mmm d,yy'
    Left = 66
    Top = 280
  end
  object dlgWinPrint: TPrintDialog
    Left = 610
    Top = 23
  end
  object Timer1: TTimer
    Interval = 100
    OnTimer = Timer1Timer
    Left = 605
    Top = 69
  end
  object PopupMenu2: TPopupMenu
    Left = 603
    Top = 158
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
  object PopupMenu3: TPopupMenu
    OnPopup = PopupMenu3Popup
    Left = 597
    Top = 344
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
    object GoToTop1: TMenuItem
      Caption = 'Go to Top'
      OnClick = GotoTop1Click
    end
    object GoToBottom1: TMenuItem
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
      OnClick = UnfreezeText1Click
    end
  end
end
