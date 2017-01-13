inherited frmGraphs: TfrmGraphs
  Left = 265
  Top = 279
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'CPRS Graphing - CPRSpatient,One'
  ClientHeight = 492
  ClientWidth = 729
  PopupMenu = mnuPopGraphStuff
  Position = poDesigned
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  ExplicitWidth = 729
  ExplicitHeight = 492
  PixelsPerInch = 120
  TextHeight = 16
  object pnlHeader: TPanel [0]
    Left = 0
    Top = 0
    Width = 729
    Height = 26
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object pnlTemp: TPanel
      Left = 512
      Top = 0
      Width = 90
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      TabOrder = 1
      Visible = False
    end
    object pnlInfo: TORAutoPanel
      Left = 0
      Top = 0
      Width = 729
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Select multiple items using Ctrl-click or Shift-click.'
      Color = clCream
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object chartBase: TChart
      Left = 180
      Top = -2
      Width = 129
      Height = 20
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AllowPanning = pmNone
      BackWall.Brush.Color = clWhite
      BackWall.Brush.Style = bsClear
      Gradient.EndColor = clPurple
      Gradient.Visible = True
      Legend.Alignment = laTop
      Legend.LegendStyle = lsSeries
      Legend.ResizeChart = False
      Title.Text.Strings = (
        'fsdfs dfs fsd')
      Title.Visible = False
      OnClickLegend = chartBaseClickLegend
      OnClickSeries = chartBaseClickSeries
      OnUndoZoom = ChartOnUndoZoom
      OnZoom = ChartOnZoom
      BottomAxis.Automatic = False
      BottomAxis.AutomaticMaximum = False
      BottomAxis.AutomaticMinimum = False
      BottomAxis.Increment = 0.000694444444444444
      BottomAxis.Maximum = 25.000000000000000000
      BottomAxis.Visible = False
      TopAxis.LabelsOnAxis = False
      View3D = False
      Zoom.Allow = False
      Zoom.Pen.Color = clFuchsia
      Color = clRed
      TabOrder = 0
      Visible = False
      OnDblClick = mnuPopGraphDetailsClick
      OnMouseDown = chartBaseMouseDown
      OnMouseUp = chartBaseMouseUp
      ColorPaletteIndex = 13
    end
  end
  object pnlFooter: TPanel [1]
    Left = 0
    Top = 457
    Width = 729
    Height = 35
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object lblDateRange: TLabel
      Left = 4
      Top = 10
      Width = 76
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Date Range:'
    end
    object btnClose: TButton
      Left = 628
      Top = 5
      Width = 86
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Close'
      TabOrder = 4
      OnClick = btnCloseClick
    end
    object btnChangeSettings: TButton
      Left = 468
      Top = 5
      Width = 104
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Settings...'
      TabOrder = 3
      OnClick = btnChangeSettingsClick
    end
    object cboDateRange: TORComboBox
      Left = 86
      Top = 7
      Width = 149
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Style = orcsDropDown
      AutoSelect = True
      Caption = ''
      Color = clWindow
      DropDownCount = 9
      Items.Strings = (
        'S^Date Range...'
        '1^Today'
        '2^One Week'
        '3^One Month'
        '4^Six Months'
        '5^One Year'
        '6^Two Years'
        '7^All Results')
      ItemHeight = 16
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = False
      LongList = False
      LookupPiece = 0
      MaxLength = 0
      Pieces = '2'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 0
      TabStop = True
      Text = ''
      OnChange = cboDateRangeChange
      OnDropDown = cboDateRangeDropDown
      OnExit = cboDateRangeExit
      CharsNeedMatch = 1
    end
    object chkDualViews: TCheckBox
      Left = 242
      Top = 9
      Width = 105
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Split Views'
      TabOrder = 1
      OnClick = chkDualViewsClick
    end
    object btnGraphSelections: TButton
      Left = 354
      Top = 5
      Width = 105
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Select/Define...'
      TabOrder = 2
      OnClick = btnGraphSelectionsClick
    end
  end
  object pnlMain: TPanel [2]
    Left = 0
    Top = 26
    Width = 729
    Height = 431
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object splGraphs: TSplitter
      Left = 0
      Top = 306
      Width = 729
      Height = 4
      Cursor = crVSplit
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alBottom
      Beveled = True
      Color = clBtnShadow
      ParentColor = False
      OnMoved = splGraphsMoved
    end
    object pnlTop: TPanel
      Tag = 1
      Left = 0
      Top = 0
      Width = 729
      Height = 306
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object splItemsTop: TSplitter
        Left = 182
        Top = 0
        Height = 306
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSnap = False
        Beveled = True
        MinSize = 15
        OnMoved = splItemsTopMoved
      end
      object pnlItemsTop: TPanel
        Left = 0
        Top = 0
        Width = 182
        Height = 306
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 0
        object pnlItemsTopInfo: TPanel
          Left = 0
          Top = 0
          Width = 182
          Height = 27
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          DesignSize = (
            182
            27)
          object bvlBottomLeft: TBevel
            Left = 0
            Top = 0
            Width = 2
            Height = 27
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Align = alLeft
          end
          object bvlBottomRight: TBevel
            Left = 180
            Top = 0
            Width = 2
            Height = 27
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Align = alRight
            Visible = False
          end
          object chkItemsTop: TCheckBox
            Left = 49
            Top = 2
            Width = 129
            Height = 25
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Alignment = taLeftJustify
            Anchors = [akTop, akRight]
            Caption = 'Individual Graphs'
            Checked = True
            State = cbChecked
            TabOrder = 0
            OnClick = chkItemsTopClick
          end
        end
        object pcTop: TPageControl
          Left = 0
          Top = 27
          Width = 182
          Height = 279
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          ActivePage = tsTopItems
          Align = alClient
          TabOrder = 1
          object tsTopItems: TTabSheet
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Items'
            object lvwItemsTop: TListView
              Left = 0
              Top = 0
              Width = 174
              Height = 248
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Align = alClient
              BevelInner = bvNone
              BevelOuter = bvNone
              Columns = <
                item
                  Caption = 'Item'
                  Width = 123
                end
                item
                  Caption = 'Type'
                  Width = 74
                end
                item
                  Caption = 'View'
                  Width = 49
                end
                item
                  Caption = 'Classification'
                  Width = 62
                end
                item
                  Caption = 'Remote Location'
                  Width = 185
                end>
              HideSelection = False
              MultiSelect = True
              ReadOnly = True
              RowSelect = True
              ParentShowHint = False
              ShowHint = False
              TabOrder = 0
              ViewStyle = vsReport
              OnChange = lvwItemsTopChange
              OnClick = lvwItemsTopClick
              OnColumnClick = lvwItemsTopColumnClick
              OnCompare = lvwItemsTopCompare
              OnEnter = lvwItemsTopEnter
              OnKeyDown = lvwItemsTopKeyDown
            end
          end
          object tsTopViews: TTabSheet
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Views'
            ImageIndex = 1
            object splViewsTop: TSplitter
              Left = 0
              Top = 246
              Width = 174
              Height = 1
              Cursor = crVSplit
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Align = alBottom
              OnMoved = splViewsTopMoved
              ExplicitTop = 239
              ExplicitWidth = 172
            end
            object lstViewsTop: TORListBox
              Left = 0
              Top = 0
              Width = 174
              Height = 246
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Align = alClient
              ParentShowHint = False
              ShowHint = False
              TabOrder = 0
              OnEnter = lstViewsTopEnter
              OnMouseDown = lstViewsTopMouseDown
              Caption = ''
              ItemTipColor = clWindow
              LongList = False
              Pieces = '2'
              OnChange = lstViewsTopChange
            end
            object memViewsTop: TRichEdit
              Left = 0
              Top = 247
              Width = 174
              Height = 1
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
              Lines.Strings = (
                'View Definition')
              ParentFont = False
              PlainText = True
              ReadOnly = True
              ScrollBars = ssBoth
              TabOrder = 1
              WantReturns = False
              WordWrap = False
            end
          end
          object tsTopCustom: TTabSheet
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Custom'
            ImageIndex = 2
          end
        end
      end
      object pnlTopRightPad: TPanel
        Tag = 50
        Left = 710
        Top = 0
        Width = 19
        Height = 306
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 1
      end
      object pnlScrollTopBase: TPanel
        Left = 185
        Top = 0
        Width = 524
        Height = 306
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 2
        OnResize = pnlScrollTopBaseResize
        object pnlBlankTop: TPanel
          Left = 0
          Top = 0
          Width = 524
          Height = 270
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 2
          Visible = False
        end
        object scrlTop: TScrollBox
          Tag = 5
          Left = 0
          Top = 0
          Width = 524
          Height = 270
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alClient
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = bsNone
          Color = clBtnFace
          ParentColor = False
          TabOrder = 0
        end
        object pnlDatelineTop: TPanel
          Left = 0
          Top = 270
          Width = 524
          Height = 36
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 1
          object chartDatelineTop: TChart
            Left = 25
            Top = 0
            Width = 499
            Height = 36
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AllowPanning = pmNone
            BackWall.Brush.Color = clWhite
            BackWall.Brush.Style = bsClear
            BackWall.Pen.Visible = False
            Gradient.EndColor = clWhite
            Gradient.StartColor = 8421631
            Legend.Alignment = laBottom
            Legend.Color = clCream
            Legend.LegendStyle = lsSeries
            Legend.Shadow.HorizSize = 1
            Legend.Shadow.VertSize = 1
            Legend.Visible = False
            Title.Text.Strings = (
              '')
            Title.Visible = False
            OnClickLegend = chartBaseClickLegend
            OnClickSeries = chartBaseClickSeries
            OnUndoZoom = ChartOnUndoZoom
            OnZoom = ChartOnZoom
            BottomAxis.Automatic = False
            BottomAxis.AutomaticMaximum = False
            BottomAxis.AutomaticMinimum = False
            BottomAxis.DateTimeFormat = 'M/d/yyyy'
            BottomAxis.Increment = 0.000694444444444444
            BottomAxis.Maximum = 25.000000000000000000
            Frame.Visible = False
            LeftAxis.Automatic = False
            LeftAxis.AutomaticMaximum = False
            LeftAxis.AutomaticMinimum = False
            LeftAxis.Axis.Visible = False
            LeftAxis.Grid.Visible = False
            LeftAxis.Labels = False
            LeftAxis.LabelsOnAxis = False
            LeftAxis.Maximum = 9.000000000000000000
            LeftAxis.MinorGrid.Visible = True
            LeftAxis.RoundFirstLabel = False
            LeftAxis.Title.Caption = ' '
            LeftAxis.Visible = False
            RightAxis.Automatic = False
            RightAxis.AutomaticMaximum = False
            RightAxis.AutomaticMinimum = False
            RightAxis.Axis.Visible = False
            RightAxis.Labels = False
            RightAxis.LabelsOnAxis = False
            RightAxis.RoundFirstLabel = False
            RightAxis.Visible = False
            TopAxis.LabelsOnAxis = False
            View3D = False
            View3DWalls = False
            Zoom.Pen.Color = clFuchsia
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 0
            OnDblClick = mnuPopGraphDetailsClick
            OnMouseDown = chartBaseMouseDown
            OnMouseUp = chartBaseMouseUp
            ColorPaletteIndex = 13
            object serDatelineTop: TGanttSeries
              Marks.Arrow.Visible = True
              Marks.Callout.Brush.Color = clBlack
              Marks.Callout.Arrow.Visible = True
              Marks.Visible = False
              SeriesColor = clRed
              ShowInLegend = False
              OnGetMarkText = serDatelineTopGetMarkText
              ClickableLine = False
              Pointer.Brush.Gradient.EndColor = 919731
              Pointer.Gradient.EndColor = 919731
              Pointer.InflateMargins = False
              Pointer.Style = psRectangle
              Pointer.Visible = True
              XValues.Name = 'Start'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
              StartValues.Name = 'Start'
              StartValues.Order = loAscending
              EndValues.Name = 'End'
              EndValues.Order = loNone
              NextTask.Name = 'NextTask'
              NextTask.Order = loNone
            end
          end
          object pnlDatelineTopSpacer: TORAutoPanel
            Left = 0
            Top = 0
            Width = 25
            Height = 36
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Align = alLeft
            BevelOuter = bvNone
            TabOrder = 1
          end
        end
      end
      object memTop: TMemo
        Left = 709
        Top = 0
        Width = 1
        Height = 306
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alRight
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Color = clBtnFace
        Lines.Strings = (
          'm'
          'e'
          'm'
          'T'
          'o'
          'p')
        TabOrder = 3
        Visible = False
        OnEnter = memTopEnter
        OnExit = memTopExit
        OnKeyDown = memTopKeyDown
      end
    end
    object pnlBottom: TPanel
      Tag = 1
      Left = 0
      Top = 310
      Width = 729
      Height = 121
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object splItemsBottom: TSplitter
        Left = 182
        Top = 0
        Height = 121
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSnap = False
        Beveled = True
        MinSize = 15
        OnMoved = splItemsBottomMoved
      end
      object pnlItemsBottom: TPanel
        Left = 0
        Top = 0
        Width = 182
        Height = 121
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 0
        object pnlItemsBottomInfo: TPanel
          Left = 0
          Top = 0
          Width = 182
          Height = 27
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object bvlTopLeft: TBevel
            Left = 0
            Top = 0
            Width = 2
            Height = 27
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Align = alLeft
          end
          object bvlTopRight: TBevel
            Left = 180
            Top = 0
            Width = 2
            Height = 27
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Align = alRight
            Visible = False
          end
          object chkItemsBottom: TCheckBox
            Left = 48
            Top = 2
            Width = 129
            Height = 25
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Alignment = taLeftJustify
            Caption = 'Individual Graphs'
            Checked = True
            State = cbChecked
            TabOrder = 0
            OnClick = chkItemsBottomClick
            OnEnter = chkItemsBottomEnter
          end
        end
        object pcBottom: TPageControl
          Left = 0
          Top = 27
          Width = 182
          Height = 94
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          ActivePage = tsBottomItems
          Align = alClient
          TabOrder = 1
          object tsBottomItems: TTabSheet
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Items'
            object lvwItemsBottom: TListView
              Left = 0
              Top = 0
              Width = 174
              Height = 63
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Align = alClient
              BevelInner = bvNone
              BevelOuter = bvNone
              Columns = <
                item
                  Caption = 'Item'
                  Width = 123
                end
                item
                  Caption = 'Type'
                  Width = 74
                end
                item
                  Caption = 'View'
                  Width = 49
                end
                item
                  Caption = 'Classification'
                  Width = 62
                end
                item
                  Caption = 'Remote Location'
                  Width = 185
                end>
              HideSelection = False
              MultiSelect = True
              ReadOnly = True
              RowSelect = True
              ParentShowHint = False
              ShowHint = False
              TabOrder = 0
              ViewStyle = vsReport
              OnChange = lvwItemsBottomChange
              OnClick = lvwItemsBottomClick
              OnColumnClick = lvwItemsBottomColumnClick
              OnCompare = lvwItemsBottomCompare
              OnEnter = lvwItemsBottomEnter
              OnKeyDown = lvwItemsTopKeyDown
            end
          end
          object tsBottomViews: TTabSheet
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Views'
            ImageIndex = 1
            object splViewsBottom: TSplitter
              Left = 0
              Top = 60
              Width = 174
              Height = 2
              Cursor = crVSplit
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Align = alBottom
              OnMoved = splViewsTopMoved
              ExplicitTop = 52
              ExplicitWidth = 172
            end
            object lstViewsBottom: TORListBox
              Left = 0
              Top = 0
              Width = 174
              Height = 60
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Align = alClient
              ParentShowHint = False
              ShowHint = False
              TabOrder = 0
              OnEnter = lstViewsBottomEnter
              Caption = ''
              ItemTipColor = clWindow
              LongList = False
              Pieces = '2'
              OnChange = lstViewsBottomChange
            end
            object memViewsBottom: TRichEdit
              Left = 0
              Top = 62
              Width = 174
              Height = 1
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
              Lines.Strings = (
                'View Definition')
              ParentFont = False
              PlainText = True
              ReadOnly = True
              ScrollBars = ssBoth
              TabOrder = 1
              WantReturns = False
              WordWrap = False
            end
          end
          object tsBottomCustom: TTabSheet
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Custom'
            ImageIndex = 2
          end
        end
      end
      object pnlBottomRightPad: TPanel
        Tag = 50
        Left = 710
        Top = 0
        Width = 19
        Height = 121
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 1
      end
      object pnlScrollBottomBase: TPanel
        Left = 185
        Top = 0
        Width = 524
        Height = 121
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 2
        object pnlBlankBottom: TPanel
          Left = 0
          Top = 0
          Width = 524
          Height = 84
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 2
          Visible = False
        end
        object pnlDatelineBottom: TPanel
          Left = 0
          Top = 84
          Width = 524
          Height = 37
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 1
          object chartDatelineBottom: TChart
            Left = 25
            Top = 0
            Width = 499
            Height = 37
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AllowPanning = pmNone
            BackWall.Brush.Color = clWhite
            BackWall.Brush.Style = bsClear
            BackWall.Pen.Visible = False
            Gradient.EndColor = clGradientActiveCaption
            Legend.Alignment = laBottom
            Legend.Color = clCream
            Legend.LegendStyle = lsSeries
            Legend.Shadow.HorizSize = 1
            Legend.Shadow.VertSize = 1
            Legend.Visible = False
            Title.Text.Strings = (
              '')
            Title.Visible = False
            OnClickLegend = chartBaseClickLegend
            OnClickSeries = chartBaseClickSeries
            OnUndoZoom = ChartOnUndoZoom
            OnZoom = ChartOnZoom
            BottomAxis.Automatic = False
            BottomAxis.AutomaticMaximum = False
            BottomAxis.AutomaticMinimum = False
            BottomAxis.DateTimeFormat = 'M/d/yyyy'
            BottomAxis.Increment = 0.000694444444444444
            BottomAxis.Maximum = 25.000000000000000000
            Frame.Visible = False
            LeftAxis.Automatic = False
            LeftAxis.AutomaticMaximum = False
            LeftAxis.AutomaticMinimum = False
            LeftAxis.Axis.Visible = False
            LeftAxis.Grid.Visible = False
            LeftAxis.Labels = False
            LeftAxis.LabelsOnAxis = False
            LeftAxis.Maximum = 9.000000000000000000
            LeftAxis.MinorGrid.Visible = True
            LeftAxis.RoundFirstLabel = False
            LeftAxis.Title.Caption = ' '
            RightAxis.Automatic = False
            RightAxis.AutomaticMaximum = False
            RightAxis.AutomaticMinimum = False
            RightAxis.Axis.Visible = False
            RightAxis.Labels = False
            RightAxis.LabelsOnAxis = False
            RightAxis.RoundFirstLabel = False
            RightAxis.Visible = False
            TopAxis.LabelsOnAxis = False
            View3D = False
            View3DWalls = False
            Zoom.Pen.Color = clFuchsia
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 0
            OnDblClick = mnuPopGraphDetailsClick
            OnMouseDown = chartBaseMouseDown
            OnMouseUp = chartBaseMouseUp
            ColorPaletteIndex = 13
            object serDatelineBottom: TGanttSeries
              Marks.Arrow.Visible = True
              Marks.Callout.Brush.Color = clBlack
              Marks.Callout.Arrow.Visible = True
              Marks.Emboss.Color = 8553090
              Marks.Shadow.Color = 8750469
              Marks.Visible = False
              SeriesColor = clRed
              ShowInLegend = False
              OnGetMarkText = serDatelineTopGetMarkText
              ClickableLine = False
              Pointer.Brush.Gradient.EndColor = 10708548
              Pointer.Gradient.EndColor = 10708548
              Pointer.InflateMargins = True
              Pointer.Style = psRectangle
              Pointer.Visible = True
              XValues.Name = 'Start'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
              StartValues.Name = 'Start'
              StartValues.Order = loAscending
              EndValues.Name = 'End'
              EndValues.Order = loNone
              NextTask.Name = 'NextTask'
              NextTask.Order = loNone
            end
          end
          object pnlDatelineBottomSpacer: TORAutoPanel
            Left = 0
            Top = 0
            Width = 25
            Height = 37
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Align = alLeft
            BevelOuter = bvNone
            TabOrder = 1
          end
        end
        object scrlBottom: TScrollBox
          Tag = 5
          Left = 0
          Top = 0
          Width = 524
          Height = 84
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alClient
          BevelInner = bvNone
          BorderStyle = bsNone
          Color = clBtnFace
          ParentColor = False
          TabOrder = 0
        end
      end
      object memBottom: TMemo
        Left = 709
        Top = 0
        Width = 1
        Height = 121
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alRight
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Color = clBtnFace
        Lines.Strings = (
          'm'
          'e'
          'm'
          'T'
          'o'
          'p')
        TabOrder = 3
        Visible = False
        OnEnter = memBottomEnter
        OnExit = memBottomExit
        OnKeyDown = memBottomKeyDown
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlHeader'
        'Status = stsDefault')
      (
        'Component = pnlTemp'
        'Status = stsDefault')
      (
        'Component = pnlInfo'
        'Status = stsDefault')
      (
        'Component = chartBase'
        'Status = stsDefault')
      (
        'Component = pnlFooter'
        'Status = stsDefault')
      (
        'Component = btnClose'
        'Status = stsDefault')
      (
        'Component = btnChangeSettings'
        'Status = stsDefault')
      (
        'Component = cboDateRange'
        'Label = lblDateRange'
        'Status = stsOK')
      (
        'Component = chkDualViews'
        'Status = stsDefault')
      (
        'Component = btnGraphSelections'
        'Status = stsDefault')
      (
        'Component = pnlMain'
        'Status = stsDefault')
      (
        'Component = pnlTop'
        'Status = stsDefault')
      (
        'Component = pnlItemsTop'
        'Status = stsDefault')
      (
        'Component = pnlItemsTopInfo'
        'Status = stsDefault')
      (
        'Component = chkItemsTop'
        'Status = stsDefault')
      (
        'Component = pnlTopRightPad'
        'Status = stsDefault')
      (
        'Component = pnlScrollTopBase'
        'Status = stsDefault')
      (
        'Component = pnlBlankTop'
        'Status = stsDefault')
      (
        'Component = scrlTop'
        'Status = stsDefault')
      (
        'Component = pnlDatelineTop'
        'Status = stsDefault')
      (
        'Component = chartDatelineTop'
        'Status = stsDefault')
      (
        'Component = pnlDatelineTopSpacer'
        'Status = stsDefault')
      (
        'Component = memTop'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = pnlItemsBottom'
        'Status = stsDefault')
      (
        'Component = pnlItemsBottomInfo'
        'Status = stsDefault')
      (
        'Component = chkItemsBottom'
        'Status = stsDefault')
      (
        'Component = pnlBottomRightPad'
        'Status = stsDefault')
      (
        'Component = pnlScrollBottomBase'
        'Status = stsDefault')
      (
        'Component = pnlBlankBottom'
        'Status = stsDefault')
      (
        'Component = pnlDatelineBottom'
        'Status = stsDefault')
      (
        'Component = chartDatelineBottom'
        'Status = stsDefault')
      (
        'Component = pnlDatelineBottomSpacer'
        'Status = stsDefault')
      (
        'Component = scrlBottom'
        'Status = stsDefault')
      (
        'Component = memBottom'
        'Status = stsDefault')
      (
        'Component = frmGraphs'
        'Status = stsDefault')
      (
        'Component = pcTop'
        'Status = stsDefault')
      (
        'Component = tsTopItems'
        'Status = stsDefault')
      (
        'Component = tsTopViews'
        'Status = stsDefault')
      (
        'Component = tsTopCustom'
        'Status = stsDefault')
      (
        'Component = lvwItemsTop'
        'Status = stsDefault')
      (
        'Component = pcBottom'
        'Status = stsDefault')
      (
        'Component = tsBottomItems'
        'Status = stsDefault')
      (
        'Component = tsBottomViews'
        'Status = stsDefault')
      (
        'Component = tsBottomCustom'
        'Status = stsDefault')
      (
        'Component = lvwItemsBottom'
        'Status = stsDefault')
      (
        'Component = lstViewsTop'
        'Status = stsDefault')
      (
        'Component = lstViewsBottom'
        'Status = stsDefault')
      (
        'Component = memViewsTop'
        'Status = stsDefault')
      (
        'Component = memViewsBottom'
        'Status = stsDefault'))
  end
  object mnuPopGraphStuff: TPopupMenu
    OnPopup = mnuPopGraphStuffPopup
    Left = 30
    object mnuPopGraphDetails: TMenuItem
      Caption = 'Details...'
      Enabled = False
      OnClick = mnuPopGraphDetailsClick
    end
    object mnuPopGraphValueMarks: TMenuItem
      Caption = 'Values...'
      Enabled = False
      OnClick = mnuPopGraphValueMarksClick
    end
    object mnuPopGraphViewDefinition: TMenuItem
      Caption = 'View Definition...'
      OnClick = mnuPopGraphViewDefinitionClick
    end
    object mnuPopGraphDefineViews: TMenuItem
      Caption = 'Select/Define...'
      OnClick = btnGraphSelectionsClick
    end
    object mnuPopGraphChangeViews: TMenuItem
      Caption = 'Settings...'
      OnClick = btnChangeSettingsClick
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object mnuPopGraphReset: TMenuItem
      Caption = 'Reset Display'
      ShortCut = 45
      OnClick = mnuPopGraphResetClick
    end
    object mnuPopGraphZoomBack: TMenuItem
      Caption = 'Zoom Back'
      Enabled = False
      ShortCut = 46
      OnClick = mnuPopGraphZoomBackClick
    end
    object mnuPopGraphSplit: TMenuItem
      Caption = 'Split Numerics/Events'
      OnClick = mnuPopGraphSplitClick
    end
    object mnuPopGraphSwap: TMenuItem
      Caption = 'Swap'
      OnClick = mnuPopGraphSwapClick
    end
    object mnuPopGraphIsolate: TMenuItem
      Caption = 'Move'
      Enabled = False
      OnClick = mnuPopGraphIsolateClick
    end
    object mnuPopGraphRemove: TMenuItem
      Caption = 'Remove'
      Enabled = False
      OnClick = mnuPopGraphRemoveClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mnuPopGraphStayOnTop: TMenuItem
      Caption = 'Stay on Top'
      OnClick = mnuPopGraphStayOnTopClick
    end
    object mnuPopGraphDualViews: TMenuItem
      Caption = 'Dual Views'
      Visible = False
      OnClick = mnuPopGraphDualViewsClick
    end
    object mnuPopGraphSeparate1: TMenuItem
      Caption = 'Individual Graphs'
      Visible = False
      OnClick = mnuPopGraphSeparate1Click
    end
    object mnuPopGraph3D: TMenuItem
      Caption = '3D'
      OnClick = mnuPopGraph3DClick
    end
    object mnuPopGraphLegend: TMenuItem
      Caption = 'Legend'
      Visible = False
      OnClick = mnuPopGraphLegendClick
    end
    object mnuPopGraphValues: TMenuItem
      Caption = 'Values'
      OnClick = mnuPopGraphValuesClick
    end
    object mnuPopGraphFixed: TMenuItem
      Caption = 'Fixed Date Range'
      Visible = False
      OnClick = mnuPopGraphFixedClick
    end
    object mnuPopGraphVertical: TMenuItem
      Caption = 'Vertical Zoom'
      OnClick = mnuPopGraphVerticalClick
    end
    object mnuPopGraphHorizontal: TMenuItem
      Caption = 'Horizontal Zoom'
      Visible = False
      OnClick = mnuPopGraphHorizontalClick
    end
    object mnuPopGraphLines: TMenuItem
      Caption = 'Lines'
      Visible = False
      OnClick = mnuPopGraphLinesClick
    end
    object mnuPopGraphDates: TMenuItem
      Caption = 'Dates'
      Visible = False
      OnClick = mnuPopGraphDatesClick
    end
    object mnuPopGraphSort: TMenuItem
      Caption = 'Sort by Type'
      Visible = False
      OnClick = mnuPopGraphSortClick
    end
    object mnuPopGraphClear: TMenuItem
      Caption = 'Clear Background'
      Visible = False
      OnClick = mnuPopGraphClearClick
    end
    object mnuPopGraphGradient: TMenuItem
      Caption = 'Gradient'
      Visible = False
      OnClick = mnuPopGraphGradientClick
    end
    object mnuPopGraphHints: TMenuItem
      Caption = 'Hints'
      Visible = False
    end
    object mnuPopGraphMergeLabs: TMenuItem
      Caption = 'Merge Labs'
      OnClick = mnuPopGraphMergeLabsClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object mnuPopGraphCopy: TMenuItem
      Caption = 'Copy'
      ShortCut = 16451
      OnClick = mnuPopGraphPrintClick
    end
    object mnuPopGraphExport: TMenuItem
      Caption = 'Export Data...'
      OnClick = mnuPopGraphExportClick
    end
    object mnuPopGraphPrint: TMenuItem
      Caption = 'Print...'
      OnClick = mnuPopGraphPrintClick
    end
    object N3: TMenuItem
      Caption = '-'
      Visible = False
    end
    object mnutest: TMenuItem
      Caption = 'testing'
      Enabled = False
      Visible = False
    end
    object mnuFunctions1: TMenuItem
      Caption = 'Functions'
      Enabled = False
      Visible = False
      object mnuInverseValues: TMenuItem
        Caption = 'Inverse Values'
      end
      object mnuStandardDeviations: TMenuItem
        Caption = 'Standard Deviations'
      end
    end
    object mnuCustom: TMenuItem
      Caption = 'Custom'
      Enabled = False
      Visible = False
      OnClick = mnuCustomClick
    end
    object mnuMHasNumeric1: TMenuItem
      Caption = 'MH as Numeric'
      Enabled = False
      Visible = False
      OnClick = mnuMHasNumeric1Click
    end
    object mnuGraphData: TMenuItem
      Caption = 'Show Graph Data...'
      Enabled = False
      Visible = False
      OnClick = mnuGraphDataClick
    end
    object mnuPopGraphToday: TMenuItem
      Caption = 'Reset Today...'
      Enabled = False
      Visible = False
      OnClick = mnuPopGraphTodayClick
    end
    object mnuTestCount: TMenuItem
      Caption = 'test count'
      Enabled = False
      Visible = False
    end
  end
  object calDateRange: TORDateRangeDlg
    DateOnly = False
    Instruction = 'Enter a date range -'
    LabelStart = 'Begin Date'
    LabelStop = 'End Date'
    RequireTime = False
    Format = 'mmm d,yy@hh:nn'
    Left = 59
  end
  object dlgDate: TORDateTimeDlg
    FMDateTime = 3040806.000000000000000000
    DateOnly = True
    RequireTime = False
    Left = 88
  end
  object timHintPause: TTimer
    Enabled = False
    Interval = 100
    OnTimer = timHintPauseTimer
    Left = 117
  end
end
