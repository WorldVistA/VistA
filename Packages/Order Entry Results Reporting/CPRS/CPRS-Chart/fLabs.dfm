inherited frmLabs: TfrmLabs
  Left = 628
  Top = 237
  HelpContext = 8000
  Caption = 'Laboratory Results Page'
  ClientHeight = 713
  ClientWidth = 713
  HelpFile = 'qnoback'
  ExplicitWidth = 729
  ExplicitHeight = 752
  TextHeight = 13
  inherited shpPageBottom: TShape
    Top = 708
    Width = 713
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    ExplicitTop = 708
    ExplicitWidth = 713
  end
  inherited sptHorz: TSplitter
    Height = 708
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    ExplicitHeight = 708
  end
  object Label1: TLabel [2]
    Left = 144
    Top = 88
    Width = 3
    Height = 13
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Visible = False
  end
  object Label2: TLabel [3]
    Left = 128
    Top = 88
    Width = 3
    Height = 13
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Visible = False
  end
  object Label4: TLabel [4]
    Left = 360
    Top = 88
    Width = 3
    Height = 13
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
  end
  object Label5: TLabel [5]
    Left = 248
    Top = 88
    Width = 3
    Height = 13
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
  end
  object Label3: TLabel [6]
    Left = 248
    Top = 80
    Width = 3
    Height = 13
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
  end
  inherited pnlLeft: TPanel
    Height = 708
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Constraints.MinWidth = 37
    ExplicitHeight = 708
    object splLeft: TSplitter
      Left = 0
      Top = 338
      Width = 97
      Height = 5
      Cursor = crVSplit
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      Color = clBtnFace
      ParentColor = False
      OnCanResize = splLeftCanResize
      OnMoved = splLeftMoved
      ExplicitTop = 0
    end
    object pnlLefTop: TPanel
      Left = 0
      Top = 0
      Width = 97
      Height = 338
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      BevelOuter = bvNone
      Constraints.MinWidth = 30
      TabOrder = 0
      object lblReports: TOROffsetLabel
        Left = 0
        Top = 0
        Width = 97
        Height = 19
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        Caption = 'Lab Results'
        HorzOffset = 2
        Transparent = False
        VertOffset = 6
        WordWrap = False
        ExplicitLeft = 6
        ExplicitTop = 6
      end
      object tvReports: TORTreeView
        Left = 0
        Top = 19
        Width = 97
        Height = 319
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
      Top = 343
      Width = 97
      Height = 365
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      TabOrder = 1
      object splLeftLower: TSplitter
        Left = 1
        Top = 77
        Width = 95
        Height = 3
        Cursor = crVSplit
        Align = alTop
        OnMoved = splLeftLowerMoved
      end
      object pnlLeftBotUpper: TPanel
        Left = 1
        Top = 1
        Width = 95
        Height = 76
        Align = alTop
        TabOrder = 0
        object lblHeaders: TOROffsetLabel
          Left = 1
          Top = 34
          Width = 93
          Height = 17
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alTop
          HorzOffset = 2
          Transparent = False
          VertOffset = 2
          WordWrap = False
          ExplicitLeft = 12
          ExplicitTop = 24
        end
        object pnlOtherTests: TORAutoPanel
          Left = 1
          Top = 1
          Width = 93
          Height = 33
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object bvlOtherTests: TBevel
            Left = 3
            Top = 31
            Width = 90
            Height = 2
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
          end
          object cmdOtherTests: TButton
            Left = 11
            Top = 4
            Width = 75
            Height = 25
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Other Tests'
            TabOrder = 0
            OnClick = cmdOtherTestsClick
          end
        end
        object lstHeaders: TORListBox
          Left = 1
          Top = 51
          Width = 93
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alClient
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
      end
      object pnlLeftBotLower: TPanel
        Left = 1
        Top = 80
        Width = 95
        Height = 284
        Align = alClient
        TabOrder = 1
        object lblDates: TOROffsetLabel
          Left = 1
          Top = 1
          Width = 93
          Height = 15
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alTop
          Caption = 'Date Range'
          HorzOffset = 2
          Transparent = False
          VertOffset = 2
          WordWrap = False
          ExplicitTop = 26
          ExplicitWidth = 77
        end
        object lblQualifier: TOROffsetLabel
          Left = 1
          Top = 16
          Width = 93
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alTop
          HorzOffset = 3
          Transparent = True
          VertOffset = 4
          Visible = False
          WordWrap = False
          ExplicitLeft = 9
          ExplicitTop = 9
          ExplicitWidth = 77
        end
        object lstDates: TORListBox
          Left = 1
          Top = 37
          Width = 93
          Height = 246
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
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
          TabOrder = 0
          OnClick = lstDatesClick
          Caption = 'Date Range'
          ItemTipColor = clWindow
          LongList = False
          Pieces = '2'
        end
        object lstQualifier: TORListBox
          Left = 1
          Top = 37
          Width = 93
          Height = 246
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alClient
          ItemHeight = 13
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          OnClick = lstQualifierClick
          Caption = ''
          ItemTipColor = clWindow
          LongList = False
          Pieces = '2,3'
          TabPositions = '10'
        end
      end
    end
  end
  inherited pnlRight: TPanel
    Width = 612
    Height = 708
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Constraints.MinWidth = 30
    OnResize = pnlRightResize
    ExplicitWidth = 612
    ExplicitHeight = 708
    object sptHorzRight: TSplitter
      Left = 0
      Top = 325
      Width = 612
      Height = 4
      Cursor = crVSplit
      Align = alTop
      Visible = False
      OnMoved = sptHorzRightMoved
      ExplicitTop = 314
      ExplicitWidth = 613
    end
    object sptHorzRightTop: TSplitter
      Left = 0
      Top = 77
      Width = 612
      Height = 4
      Cursor = crVSplit
      Align = alTop
      Visible = False
      ExplicitTop = 72
      ExplicitWidth = 613
    end
    object pnlRightBottom: TPanel
      Left = 0
      Top = 329
      Width = 612
      Height = 359
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      TabOrder = 2
      object Memo1: TMemo
        Left = 1
        Top = 1
        Width = 610
        Height = 19
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
        Visible = False
        WantTabs = True
        WordWrap = False
        OnEnter = Memo1Enter
        OnKeyUp = Memo1KeyUp
      end
      object memLab: TRichEdit
        Left = 1
        Top = 20
        Width = 610
        Height = 338
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        Color = clCream
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
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
        Zoom = 100
        OnEnter = memLabEnter
      end
      object WebBrowser: TWebBrowser
        Left = 1
        Top = 20
        Width = 610
        Height = 338
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabStop = False
        Align = alClient
        TabOrder = 2
        SelectedEngine = EdgeIfAvailable
        OnDocumentComplete = WebBrowserDocumentComplete
        ExplicitHeight = 344
        ControlData = {
          4C0000000C3F0000EF2200000000000000000000000000000000000000000000
          000000004C000000000000000000000001000000E0D057007335CF11AE690800
          2B2E126208000000000000004C0000000114020000000000C000000000000046
          8000000000000000000000000000000000000000000000000000000000000000
          00000000000000000100000000000000000000000000000000000000}
      end
    end
    object pnlRightTop: TPanel
      Left = 0
      Top = 81
      Width = 612
      Height = 244
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      TabOrder = 1
      object bvlHeader: TBevel
        Left = 1
        Top = 61
        Width = 610
        Height = 1
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        ExplicitWidth = 611
      end
      object pnlHeader: TORAutoPanel
        Left = 1
        Top = 1
        Width = 610
        Height = 60
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object lblDateFloat: TLabel
          Left = 396
          Top = 4
          Width = 56
          Height = 13
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Visible = False
        end
        object pnlWorksheet: TORAutoPanel
          Left = 0
          Top = 0
          Width = 610
          Height = 60
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          object chkValues: TCheckBox
            Left = 404
            Top = 39
            Width = 93
            Height = 17
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
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
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
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
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
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
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Abnormal Results Only'
            TabOrder = 2
            OnClick = ragHorVClick
          end
          object ragCorG: TRadioGroup
            Left = 252
            Top = 0
            Width = 213
            Height = 36
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
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
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Zoom'
            Enabled = False
            TabOrder = 3
            OnClick = chkZoomClick
          end
        end
        object pnlGraph: TORAutoPanel
          Left = 0
          Top = 0
          Width = 610
          Height = 60
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 2
          object lblGraphInfo: TLabel
            Left = 0
            Top = 47
            Width = 367
            Height = 13
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Align = alBottom
            Caption = 
              'To Zoom, hold down the mouse button while dragging an area to be' +
              ' enlarged.'
          end
          object chkGraph3D: TCheckBox
            Left = 162
            Top = 13
            Width = 61
            Height = 17
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = '3D'
            TabOrder = 1
            OnClick = chkGraph3DClick
          end
          object chkGraphValues: TCheckBox
            Left = 276
            Top = 13
            Width = 101
            Height = 17
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Values'
            TabOrder = 2
            OnClick = chkGraphValuesClick
          end
          object chkGraphZoom: TCheckBox
            Left = 48
            Top = 13
            Width = 97
            Height = 17
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Zoom'
            TabOrder = 0
            OnClick = chkGraphZoomClick
          end
        end
        object pnlButtons: TORAutoPanel
          Left = 0
          Top = 0
          Width = 610
          Height = 60
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          OnEnter = pnlButtonsEnter
          object lblMostRecent: TLabel
            Left = 361
            Top = 16
            Width = 129
            Height = 13
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Most Recent Lab Data'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblSample: TLabel
            Left = 1
            Top = 41
            Width = 64
            Height = 13
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Specimen: '
            Color = clCream
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
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
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Alignment = taCenter
            AutoSize = True
            Caption = ''
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
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
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = '&Next >'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBtnText
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 3
            OnClick = cmdNextClick
            OnMouseDown = cmdNextMouseDown
          end
          object cmdPrev: TButton
            Left = 87
            Top = 10
            Width = 82
            Height = 25
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = '< &Previous'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBtnText
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 2
            OnClick = cmdPrevClick
            OnMouseDown = cmdPrevMouseDown
          end
          object cmdRecent: TButton
            Left = 279
            Top = 10
            Width = 76
            Height = 25
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Ne&west >>'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBtnText
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 4
            OnClick = cmdRecentClick
            OnMouseDown = cmdRecentMouseDown
          end
          object cmdOld: TButton
            Left = 5
            Top = 10
            Width = 76
            Height = 25
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = '<< &Oldest'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBtnText
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
            OnClick = cmdOldClick
            OnMouseDown = cmdOldMouseDown
          end
        end
      end
      object grdLab: TCaptionStringGrid
        Left = 1
        Top = 62
        Width = 610
        Height = 33
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        Color = clCream
        DefaultRowHeight = 15
        DrawingStyle = gdsClassic
        RowCount = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing]
        ParentFont = False
        TabOrder = 1
        Visible = False
        OnClick = grdLabClick
        OnExit = grdLabExit
        OnMouseDown = grdLabMouseDown
        OnMouseUp = grdLabMouseUp
        OnMouseWheelDown = grdLabMouseWheelDown
        OnTopLeftChanged = grdLabTopLeftChanged
        Caption = 'Laboratory Results'
        RowHeights = (
          15
          15)
      end
      object pnlChart: TPanel
        Left = 1
        Top = 95
        Width = 610
        Height = 85
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
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
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Alignment = taCenter
          Caption = 
            'Results may be available, but cannot be graphed. Please try an a' +
            'lternate view.'
        end
        object lstTestGraph: TORListBox
          Left = 0
          Top = 0
          Width = 130
          Height = 85
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
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
          Left = 130
          Top = 0
          Width = 480
          Height = 85
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          AllowPanning = pmNone
          BackWall.Brush.Style = bsClear
          Legend.Alignment = laTop
          Legend.Inverted = True
          Title.Text.Strings = (
            'test name')
          Title.Visible = False
          OnClickLegend = chtChartClickLegend
          OnClickSeries = chtChartClickSeries
          OnUndoZoom = chtChartUndoZoom
          LeftAxis.Title.Caption = 'units'
          View3D = False
          Zoom.Allow = False
          Align = alClient
          BevelOuter = bvNone
          PopupMenu = popChart
          TabOrder = 1
          OnMouseDown = chtChartMouseDown
          DefaultCanvas = 'TGDIPlusCanvas'
          ColorPaletteIndex = 13
          object serHigh: TLineSeries
            SeriesColor = clRed
            Title = 'Ref High'
            Brush.BackColor = clDefault
            LinePen.Style = psDash
            Pointer.Brush.Gradient.EndColor = clRed
            Pointer.Gradient.EndColor = clRed
            Pointer.InflateMargins = True
            Pointer.Style = psRectangle
            XValues.DateTime = True
            XValues.Name = 'X'
            XValues.Order = loAscending
            YValues.Name = 'Y'
            YValues.Order = loNone
          end
          object serLow: TLineSeries
            SeriesColor = clRed
            Title = 'Ref Low'
            Brush.BackColor = clDefault
            LinePen.Style = psDash
            Pointer.Brush.Gradient.EndColor = clRed
            Pointer.Gradient.EndColor = clRed
            Pointer.InflateMargins = True
            Pointer.Style = psRectangle
            XValues.DateTime = True
            XValues.Name = 'X'
            XValues.Order = loAscending
            YValues.Name = 'Y'
            YValues.Order = loNone
          end
          object serTest: TLineSeries
            SeriesColor = clBlue
            Title = 'Lab Test'
            Brush.BackColor = clDefault
            Pointer.Brush.Gradient.EndColor = clBlue
            Pointer.Gradient.EndColor = clBlue
            Pointer.InflateMargins = True
            Pointer.Style = psCircle
            Pointer.Visible = True
            XValues.DateTime = True
            XValues.Name = 'X'
            XValues.Order = loAscending
            YValues.Name = 'Y'
            YValues.Order = loNone
          end
        end
      end
      object lvReports: TCaptionListView
        Left = 1
        Top = 180
        Width = 610
        Height = 63
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
        TabOrder = 3
        ViewStyle = vsReport
        OnColumnClick = lvReportsColumnClick
        OnCompare = lvReportsCompare
        OnKeyUp = lvReportsKeyUp
        OnSelectItem = lvReportsSelectItem
        AutoSize = False
        HideTinyColumns = True
      end
    end
    object pnlRightTopHeader: TPanel
      Left = 0
      Top = 0
      Width = 612
      Height = 77
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object pnlRightTopHeaderTop: TPanel
        Left = 0
        Top = 0
        Width = 612
        Height = 32
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object lblHeading: TOROffsetLabel
          Left = 7
          Top = 1
          Width = 456
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
          Font.Style = []
          HorzOffset = 2
          ParentColor = False
          ParentFont = False
          Transparent = False
          VertOffset = 6
          WordWrap = False
          ExplicitLeft = 10
          ExplicitWidth = 2
          ExplicitHeight = 6
        end
        object lblTitle: TOROffsetLabel
          Left = 4
          Top = 1
          Width = 3
          Height = 30
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alLeft
          Color = clCream
          HorzOffset = 3
          ParentColor = False
          Transparent = False
          VertOffset = 6
          WordWrap = False
          ExplicitLeft = 7
          ExplicitHeight = 6
        end
        object chkMaxFreq: TCheckBox
          Left = 511
          Top = 1
          Width = 97
          Height = 30
          Hint = 'Remove Max/Site limit (shown for programmers only)'
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alRight
          Caption = 'Max/Site OFF'
          Color = clBtnFace
          ParentColor = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          Visible = False
          OnClick = chkMaxFreqClick
        end
        object btnClear: TButton
          Left = 463
          Top = 1
          Width = 48
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
          TabOrder = 2
          Visible = False
          OnClick = btnClearClick
        end
        object btnAppearRt: TButton
          Left = 608
          Top = 1
          Width = 3
          Height = 30
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alRight
          Caption = '      '
          Enabled = False
          TabOrder = 3
          OnClick = btnAppearRtClick
          OnEnter = btnAppearRtEnter
        end
        object btnAppearLt: TButton
          Left = 1
          Top = 1
          Width = 3
          Height = 30
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alLeft
          Caption = '      '
          Enabled = False
          TabOrder = 0
          OnClick = btnAppearRtClick
        end
      end
      object TabControl1: TTabControl
        Left = 0
        Top = 63
        Width = 612
        Height = 14
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
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
        TabOrder = 1
        Visible = False
        OnChange = TabControl1Change
      end
      object pnlRightTopHeaderMid: TPanel
        Left = 0
        Top = 32
        Width = 612
        Height = 31
        Align = alClient
        AutoSize = True
        TabOrder = 2
        Visible = False
        object pnlRightTopHeaderMidUpper: TPanel
          Left = 1
          Top = 1
          Width = 610
          Height = 29
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
            Width = 608
            Height = 27
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
              Margins.Left = 4
              Margins.Top = 1
              Margins.Right = 4
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
              Margins.Left = 4
              Margins.Top = 1
              Margins.Right = 4
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
              Margins.Left = 4
              Margins.Top = 1
              Margins.Right = 4
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
              Margins.Left = 4
              Margins.Top = 1
              Margins.Right = 4
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
              Margins.Left = 4
              Margins.Top = 1
              Margins.Right = 4
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
              Margins.Left = 4
              Margins.Top = 1
              Margins.Right = 4
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
              Margins.Left = 4
              Margins.Top = 1
              Margins.Right = 4
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
              Margins.Left = 4
              Margins.Top = 1
              Margins.Right = 4
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
    object pnlFooter: TORAutoPanel
      Left = 0
      Top = 688
      Width = 612
      Height = 20
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alBottom
      TabOrder = 3
      object lblSpecimen: TLabel
        Left = 4
        Top = 28
        Width = 57
        Height = 13
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'lblSpecimen'
        Visible = False
      end
      object lblSingleTest: TLabel
        Left = 88
        Top = 28
        Width = 60
        Height = 13
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'lblSingleTest'
        Visible = False
      end
      object lblFooter: TOROffsetLabel
        Left = 1
        Top = 16
        Width = 610
        Height = 26
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        Caption = 
          '  KEY: "L" = Abnormal Low, "H" = Abnormal High, "*" = Critical V' +
          'alue'
        HorzOffset = 2
        Transparent = False
        VertOffset = 2
        WordWrap = False
        ExplicitTop = 15
        ExplicitWidth = 611
      end
      object lstTests: TORListBox
        Left = 1
        Top = 42
        Width = 610
        Height = 18
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Visible = False
        Caption = ''
        ItemTipColor = clWindow
        LongList = False
      end
      object lbl508Footer: TVA508StaticText
        Name = 'lbl508Footer'
        Left = 1
        Top = 1
        Width = 610
        Height = 15
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        Alignment = taLeftJustify
        Caption = 
          '  KEY: "L" = Abnormal Low, "H" = Abnormal High, "*" = Critical V' +
          'alue'
        Enabled = False
        TabOrder = 1
        TabStop = True
        Visible = False
        ShowAccelChar = True
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
        
          'Text = lblTitle + "," + lblMostRecent + ", Specimen: " + lblSpec' +
          'imen'
        'Status = stsOK')
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
        'Component = pnlRightTopHeaderTop'
        'Status = stsDefault')
      (
        'Component = chkMaxFreq'
        'Text = Developer option - Max occurrence'
        'Status = stsOK')
      (
        'Component = TabControl1'
        'Status = stsDefault')
      (
        'Component = WebBrowser'
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
        'Text = Developer button - Reload reports'
        'Status = stsOK')
      (
        'Component = btnAppearRt'
        'Text = Developer Options'
        'Status = stsOK')
      (
        'Component = btnAppearLt'
        'Text = Developer Options'
        'Status = stsOK')
      (
        'Component = lbl508Footer'
        'Status = stsDefault')
      (
        'Component = pnlLeftBotUpper'
        'Status = stsDefault')
      (
        'Component = pnlOtherTests'
        'Status = stsDefault')
      (
        'Component = cmdOtherTests'
        'Status = stsDefault')
      (
        'Component = lstHeaders'
        'Status = stsDefault')
      (
        'Component = pnlLeftBotLower'
        'Status = stsDefault')
      (
        'Component = lstDates'
        'Status = stsDefault')
      (
        'Component = lstQualifier'
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
    Left = 674
    Top = 39
  end
  object Timer1: TTimer
    Interval = 3000
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
end
