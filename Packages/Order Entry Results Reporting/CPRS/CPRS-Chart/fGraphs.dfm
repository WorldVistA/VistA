inherited frmGraphs: TfrmGraphs
  Left = 265
  Top = 279
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'CPRS Graphing - CPRSpatient,One'
  ClientHeight = 394
  ClientWidth = 583
  PopupMenu = mnuPopGraphStuff
  Position = poDesigned
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  ExplicitWidth = 583
  ExplicitHeight = 394
  PixelsPerInch = 96
  TextHeight = 16
  object pnlHeader: TPanel [0]
    Left = 0
    Top = 0
    Width = 583
    Height = 21
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object pnlTemp: TPanel
      Left = 410
      Top = 0
      Width = 72
      Height = 17
      TabOrder = 1
      Visible = False
    end
    object pnlInfo: TORAutoPanel
      Left = 0
      Top = 0
      Width = 583
      Height = 21
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Select multiple items using Ctrl-click or Shift-click.'
      Color = clCream
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object chartBase: TChart
      Left = 144
      Top = -2
      Width = 103
      Height = 16
      AllowPanning = pmNone
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
      DefaultCanvas = 'TGDIPlusCanvas'
      ColorPaletteIndex = 13
    end
  end
  object pnlFooter: TPanel [1]
    Left = 0
    Top = 366
    Width = 583
    Height = 28
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object lblDateRange: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 76
      Height = 22
      Align = alLeft
      Caption = 'Date Range:'
      ExplicitHeight = 16
    end
    object btnClose: TButton
      AlignWithMargins = True
      Left = 511
      Top = 3
      Width = 69
      Height = 22
      Align = alRight
      Caption = 'Close'
      TabOrder = 4
      OnClick = btnCloseClick
    end
    object btnChangeSettings: TButton
      AlignWithMargins = True
      Left = 421
      Top = 3
      Width = 84
      Height = 22
      Align = alRight
      Caption = 'Settings...'
      TabOrder = 3
      OnClick = btnChangeSettingsClick
    end
    object cboDateRange: TORComboBox
      AlignWithMargins = True
      Left = 85
      Top = 3
      Width = 119
      Height = 24
      Style = orcsDropDown
      Align = alLeft
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
      Left = 207
      Top = 0
      Width = 84
      Height = 28
      Align = alLeft
      Caption = 'Split Views'
      TabOrder = 1
      OnClick = chkDualViewsClick
    end
    object btnGraphSelections: TButton
      AlignWithMargins = True
      Left = 304
      Top = 3
      Width = 111
      Height = 22
      Align = alRight
      Caption = 'Select/Define...'
      TabOrder = 2
      OnClick = btnGraphSelectionsClick
    end
  end
  object pnlMain: TPanel [2]
    Left = 0
    Top = 21
    Width = 583
    Height = 345
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object splGraphs: TSplitter
      Left = 0
      Top = 245
      Width = 583
      Height = 3
      Cursor = crVSplit
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
      Width = 583
      Height = 245
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object splItemsTop: TSplitter
        Left = 146
        Top = 0
        Width = 2
        Height = 245
        AutoSnap = False
        Beveled = True
        MinSize = 15
        OnMoved = splItemsTopMoved
      end
      object pnlItemsTop: TPanel
        Left = 0
        Top = 0
        Width = 146
        Height = 245
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 0
        object pnlItemsTopInfo: TPanel
          Left = 0
          Top = 0
          Width = 146
          Height = 22
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          DesignSize = (
            146
            22)
          object bvlBottomLeft: TBevel
            Left = 0
            Top = 0
            Width = 2
            Height = 22
            Align = alLeft
          end
          object bvlBottomRight: TBevel
            Left = 144
            Top = 0
            Width = 2
            Height = 22
            Align = alRight
            Visible = False
          end
          object chkItemsTop: TCheckBox
            Left = 8
            Top = 2
            Width = 134
            Height = 20
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
          Top = 22
          Width = 146
          Height = 223
          ActivePage = tsTopItems
          Align = alClient
          TabOrder = 1
          object tsTopItems: TTabSheet
            Caption = 'Items'
            object lvwItemsTop: TListView
              Left = 0
              Top = 0
              Width = 138
              Height = 192
              Align = alClient
              BevelInner = bvNone
              BevelOuter = bvNone
              Columns = <
                item
                  Caption = 'Item'
                  Width = 98
                end
                item
                  Caption = 'Type'
                  Width = 59
                end
                item
                  Caption = 'View'
                  Width = 39
                end
                item
                  Caption = 'Classification'
                end
                item
                  Caption = 'Remote Location'
                  Width = 148
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
            Caption = 'Views'
            ImageIndex = 1
            object splViewsTop: TSplitter
              Left = 0
              Top = 190
              Width = 138
              Height = 2
              Cursor = crVSplit
              Align = alBottom
              OnMoved = splViewsTopMoved
              ExplicitTop = 196
              ExplicitWidth = 139
            end
            object lstViewsTop: TORListBox
              Left = 0
              Top = 0
              Width = 138
              Height = 190
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
              Top = 192
              Width = 138
              Height = 0
              Align = alBottom
              Color = clCream
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
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
              Zoom = 100
            end
          end
          object tsTopCustom: TTabSheet
            Caption = 'Custom'
            ImageIndex = 2
          end
        end
      end
      object pnlTopRightPad: TPanel
        Tag = 50
        Left = 568
        Top = 0
        Width = 15
        Height = 245
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 1
      end
      object pnlScrollTopBase: TPanel
        Left = 148
        Top = 0
        Width = 419
        Height = 245
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 2
        OnResize = pnlScrollTopBaseResize
        object pnlBlankTop: TPanel
          Left = 0
          Top = 0
          Width = 419
          Height = 216
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 2
          Visible = False
        end
        object scrlTop: TScrollBox
          Tag = 5
          Left = 0
          Top = 0
          Width = 419
          Height = 216
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
          Top = 216
          Width = 419
          Height = 29
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 1
          object chartDatelineTop: TChart
            Left = 20
            Top = 0
            Width = 399
            Height = 29
            AllowPanning = pmNone
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
            LeftAxis.LabelsFormat.Visible = False
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
            RightAxis.LabelsFormat.Visible = False
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
            DefaultCanvas = 'TGDIPlusCanvas'
            ColorPaletteIndex = 13
            object serDatelineTop: TGanttSeries
              Legend.Visible = False
              SeriesColor = clRed
              ShowInLegend = False
              OnGetMarkText = serDatelineTopGetMarkText
              ClickableLine = False
              Pointer.Brush.Gradient.EndColor = 10708548
              Pointer.Gradient.EndColor = 10708548
              Pointer.InflateMargins = False
              Pointer.Style = psRectangle
              XValues.Name = 'Start'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
              Callout.Style = psRightTriangle
              Callout.Arrow.Visible = False
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
            Width = 20
            Height = 29
            Align = alLeft
            BevelOuter = bvNone
            TabOrder = 1
          end
        end
      end
      object memTop: TMemo
        Left = 567
        Top = 0
        Width = 1
        Height = 245
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
      Top = 248
      Width = 583
      Height = 97
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object splItemsBottom: TSplitter
        Left = 146
        Top = 0
        Width = 2
        Height = 97
        AutoSnap = False
        Beveled = True
        MinSize = 15
        OnMoved = splItemsBottomMoved
      end
      object pnlItemsBottom: TPanel
        Left = 0
        Top = 0
        Width = 146
        Height = 97
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 0
        object pnlItemsBottomInfo: TPanel
          Left = 0
          Top = 0
          Width = 146
          Height = 22
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object bvlTopLeft: TBevel
            Left = 0
            Top = 0
            Width = 2
            Height = 22
            Align = alLeft
          end
          object bvlTopRight: TBevel
            Left = 144
            Top = 0
            Width = 2
            Height = 22
            Align = alRight
            Visible = False
          end
          object chkItemsBottom: TCheckBox
            Left = 8
            Top = 2
            Width = 134
            Height = 20
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
          Top = 22
          Width = 146
          Height = 75
          ActivePage = tsBottomItems
          Align = alClient
          TabOrder = 1
          object tsBottomItems: TTabSheet
            Caption = 'Items'
            object lvwItemsBottom: TListView
              Left = 0
              Top = 0
              Width = 138
              Height = 44
              Align = alClient
              BevelInner = bvNone
              BevelOuter = bvNone
              Columns = <
                item
                  Caption = 'Item'
                  Width = 98
                end
                item
                  Caption = 'Type'
                  Width = 59
                end
                item
                  Caption = 'View'
                  Width = 39
                end
                item
                  Caption = 'Classification'
                end
                item
                  Caption = 'Remote Location'
                  Width = 148
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
            Caption = 'Views'
            ImageIndex = 1
            object splViewsBottom: TSplitter
              Left = 0
              Top = 42
              Width = 138
              Height = 2
              Cursor = crVSplit
              Align = alBottom
              OnMoved = splViewsTopMoved
              ExplicitTop = 48
              ExplicitWidth = 139
            end
            object lstViewsBottom: TORListBox
              Left = 0
              Top = 0
              Width = 138
              Height = 42
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
              Top = 44
              Width = 138
              Height = 0
              Align = alBottom
              Color = clCream
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
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
              Zoom = 100
            end
          end
          object tsBottomCustom: TTabSheet
            Caption = 'Custom'
            ImageIndex = 2
          end
        end
      end
      object pnlBottomRightPad: TPanel
        Tag = 50
        Left = 568
        Top = 0
        Width = 15
        Height = 97
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 1
      end
      object pnlScrollBottomBase: TPanel
        Left = 148
        Top = 0
        Width = 419
        Height = 97
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 2
        object pnlBlankBottom: TPanel
          Left = 0
          Top = 0
          Width = 419
          Height = 67
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 2
          Visible = False
        end
        object pnlDatelineBottom: TPanel
          Left = 0
          Top = 67
          Width = 419
          Height = 30
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 1
          object chartDatelineBottom: TChart
            Left = 20
            Top = 0
            Width = 399
            Height = 30
            AllowPanning = pmNone
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
            LeftAxis.LabelsFormat.Visible = False
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
            RightAxis.LabelsFormat.Visible = False
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
            DefaultCanvas = 'TGDIPlusCanvas'
            ColorPaletteIndex = 13
            object serDatelineBottom: TGanttSeries
              Legend.Visible = False
              Marks.Emboss.Color = 8553090
              Marks.Shadow.Color = 8750469
              SeriesColor = clRed
              ShowInLegend = False
              OnGetMarkText = serDatelineTopGetMarkText
              ClickableLine = False
              Pointer.Brush.Gradient.EndColor = 11842740
              Pointer.Gradient.EndColor = 11842740
              Pointer.InflateMargins = True
              Pointer.Style = psRectangle
              XValues.Name = 'Start'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
              Callout.Style = psRightTriangle
              Callout.Arrow.Visible = False
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
            Width = 20
            Height = 30
            Align = alLeft
            BevelOuter = bvNone
            TabOrder = 1
          end
        end
        object scrlBottom: TScrollBox
          Tag = 5
          Left = 0
          Top = 0
          Width = 419
          Height = 67
          Align = alClient
          BevelInner = bvNone
          BorderStyle = bsNone
          Color = clBtnFace
          ParentColor = False
          TabOrder = 0
        end
      end
      object memBottom: TMemo
        Left = 567
        Top = 0
        Width = 1
        Height = 97
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
    Left = 232
    Top = 80
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
    Left = 262
    Top = 80
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
    Left = 291
    Top = 80
  end
  object dlgDate: TORDateTimeDlg
    FMDateTime = 3040806.000000000000000000
    DateOnly = True
    RequireTime = False
    Left = 320
    Top = 80
  end
  object timHintPause: TTimer
    Enabled = False
    Interval = 100
    OnTimer = timHintPauseTimer
    Left = 349
    Top = 80
  end
end
