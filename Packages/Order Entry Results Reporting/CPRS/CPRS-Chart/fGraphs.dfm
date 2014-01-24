inherited frmGraphs: TfrmGraphs
  Left = 265
  Top = 279
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'CPRS Graphing - CPRSpatient,One'
  ClientHeight = 400
  ClientWidth = 592
  PopupMenu = mnuPopGraphStuff
  Position = poDesigned
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  ExplicitWidth = 592
  ExplicitHeight = 400
  PixelsPerInch = 96
  TextHeight = 13
  object pnlHeader: TPanel [0]
    Left = 0
    Top = 0
    Width = 592
    Height = 21
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object pnlTemp: TPanel
      Left = 416
      Top = 0
      Width = 73
      Height = 17
      TabOrder = 1
      Visible = False
    end
    object pnlInfo: TORAutoPanel
      Left = 0
      Top = 0
      Width = 592
      Height = 21
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Select multiple items using Ctrl-click or Shift-click.'
      Color = clCream
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object chartBase: TChart
      Left = 146
      Top = -2
      Width = 105
      Height = 17
      AllowPanning = pmNone
      AllowZoom = False
      BackWall.Brush.Color = clWhite
      BackWall.Brush.Style = bsClear
      Gradient.EndColor = clPurple
      Gradient.Visible = True
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
      Legend.Alignment = laTop
      Legend.LegendStyle = lsSeries
      Legend.ResizeChart = False
      TopAxis.LabelsOnAxis = False
      View3D = False
      Color = clRed
      TabOrder = 0
      Visible = False
      OnDblClick = mnuPopGraphDetailsClick
      OnMouseDown = chartBaseMouseDown
      OnMouseUp = chartBaseMouseUp
    end
  end
  object pnlFooter: TPanel [1]
    Left = 0
    Top = 371
    Width = 592
    Height = 29
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object lblDateRange: TLabel
      Left = 3
      Top = 8
      Width = 61
      Height = 13
      Caption = 'Date Range:'
    end
    object btnClose: TButton
      Left = 510
      Top = 4
      Width = 70
      Height = 21
      Caption = 'Close'
      TabOrder = 4
      OnClick = btnCloseClick
    end
    object btnChangeSettings: TButton
      Left = 380
      Top = 4
      Width = 85
      Height = 21
      Caption = 'Settings...'
      TabOrder = 3
      OnClick = btnChangeSettingsClick
    end
    object cboDateRange: TORComboBox
      Left = 70
      Top = 6
      Width = 121
      Height = 21
      Style = orcsDropDown
      AutoSelect = True
      Color = clWindow
      DropDownCount = 9
      Items.Strings = (
        'S^Date Range...'
        '1^Today'
        '2^One Week'
        '3^Two Weeks'
        '4^One Month'
        '5^Six Months'
        '6^One Year'
        '7^Two Years'
        '8^All Results')
      ItemHeight = 13
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
      OnChange = cboDateRangeChange
      OnDropDown = cboDateRangeDropDown
      CharsNeedMatch = 1
    end
    object chkDualViews: TCheckBox
      Left = 197
      Top = 7
      Width = 85
      Height = 17
      Caption = 'Split Views'
      TabOrder = 1
      OnClick = chkDualViewsClick
    end
    object btnGraphSelections: TButton
      Left = 288
      Top = 4
      Width = 85
      Height = 21
      Caption = 'Select/Define...'
      TabOrder = 2
      OnClick = btnGraphSelectionsClick
    end
  end
  object pnlMain: TPanel [2]
    Left = 0
    Top = 21
    Width = 592
    Height = 350
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object splGraphs: TSplitter
      Left = 0
      Top = 249
      Width = 592
      Height = 3
      Cursor = crVSplit
      Align = alBottom
      Beveled = True
      Color = clBtnShadow
      ParentColor = False
      OnMoved = splGraphsMoved
      ExplicitTop = 261
    end
    object pnlTop: TPanel
      Tag = 1
      Left = 0
      Top = 0
      Width = 592
      Height = 249
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object splItemsTop: TSplitter
        Left = 148
        Top = 0
        Width = 2
        Height = 249
        AutoSnap = False
        Beveled = True
        MinSize = 15
        OnMoved = splItemsTopMoved
        ExplicitHeight = 261
      end
      object pnlItemsTop: TPanel
        Left = 0
        Top = 0
        Width = 148
        Height = 249
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 0
        object pnlItemsTopInfo: TPanel
          Left = 0
          Top = 0
          Width = 148
          Height = 22
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          DesignSize = (
            148
            22)
          object bvlBottomLeft: TBevel
            Left = 0
            Top = 0
            Width = 2
            Height = 22
            Align = alLeft
            ExplicitHeight = 25
          end
          object bvlBottomRight: TBevel
            Left = 146
            Top = 0
            Width = 2
            Height = 22
            Align = alRight
            Visible = False
            ExplicitHeight = 25
          end
          object chkItemsTop: TCheckBox
            Left = 40
            Top = 2
            Width = 105
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
          Width = 148
          Height = 227
          ActivePage = tsTopItems
          Align = alClient
          TabOrder = 1
          object tsTopItems: TTabSheet
            Caption = 'Items'
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitWidth = 0
            ExplicitHeight = 0
            object lvwItemsTop: TListView
              Left = 0
              Top = 0
              Width = 140
              Height = 199
              Align = alClient
              BevelInner = bvNone
              BevelOuter = bvNone
              Columns = <
                item
                  Caption = 'Item'
                  Width = 100
                end
                item
                  Caption = 'Type'
                  Width = 60
                end
                item
                  Caption = 'View'
                  Width = 40
                end
                item
                  Caption = 'Classification'
                end
                item
                  Caption = 'Remote Location'
                  Width = 150
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
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitWidth = 0
            ExplicitHeight = 0
            object splViewsTop: TSplitter
              Left = 0
              Top = 196
              Width = 140
              Height = 2
              Cursor = crVSplit
              Align = alBottom
              OnMoved = splViewsTopMoved
              ExplicitTop = 149
            end
            object lstViewsTop: TORListBox
              Left = 0
              Top = 0
              Width = 140
              Height = 196
              Align = alClient
              ItemHeight = 13
              ParentShowHint = False
              ShowHint = False
              TabOrder = 0
              OnEnter = lstViewsTopEnter
              OnMouseDown = lstViewsTopMouseDown
              ItemTipColor = clWindow
              LongList = False
              Pieces = '2'
              OnChange = lstViewsTopChange
            end
            object memViewsTop: TRichEdit
              Left = 0
              Top = 198
              Width = 140
              Height = 1
              Align = alBottom
              Color = clCream
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
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
            Caption = 'Custom'
            ImageIndex = 2
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitWidth = 0
            ExplicitHeight = 0
          end
        end
      end
      object pnlTopRightPad: TPanel
        Tag = 50
        Left = 577
        Top = 0
        Width = 15
        Height = 249
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 1
      end
      object pnlScrollTopBase: TPanel
        Left = 150
        Top = 0
        Width = 426
        Height = 249
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 2
        OnResize = pnlScrollTopBaseResize
        object pnlBlankTop: TPanel
          Left = 0
          Top = 0
          Width = 426
          Height = 219
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 2
          Visible = False
        end
        object scrlTop: TScrollBox
          Tag = 5
          Left = 0
          Top = 0
          Width = 426
          Height = 219
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
          Top = 219
          Width = 426
          Height = 30
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 1
          object chartDatelineTop: TChart
            Left = 20
            Top = 0
            Width = 406
            Height = 30
            AllowPanning = pmNone
            BackWall.Brush.Color = clWhite
            BackWall.Brush.Style = bsClear
            BackWall.Pen.Visible = False
            Gradient.EndColor = clWhite
            Gradient.StartColor = 8421631
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
            Legend.Alignment = laBottom
            Legend.Color = clCream
            Legend.LegendStyle = lsSeries
            Legend.ShadowSize = 1
            Legend.Visible = False
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
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 0
            OnDblClick = mnuPopGraphDetailsClick
            OnMouseDown = chartBaseMouseDown
            OnMouseUp = chartBaseMouseUp
            object serDatelineTop: TGanttSeries
              ColorEachPoint = True
              Marks.ArrowLength = 0
              Marks.Visible = False
              SeriesColor = clRed
              ShowInLegend = False
              OnGetMarkText = serDatelineTopGetMarkText
              Pointer.InflateMargins = False
              Pointer.Style = psRectangle
              Pointer.Visible = True
              XValues.DateTime = True
              XValues.Name = 'Start'
              XValues.Multiplier = 1.000000000000000000
              XValues.Order = loAscending
              YValues.DateTime = False
              YValues.Name = 'Y'
              YValues.Multiplier = 1.000000000000000000
              YValues.Order = loNone
              StartValues.DateTime = True
              StartValues.Name = 'Start'
              StartValues.Multiplier = 1.000000000000000000
              StartValues.Order = loAscending
              EndValues.DateTime = True
              EndValues.Name = 'End'
              EndValues.Multiplier = 1.000000000000000000
              EndValues.Order = loNone
              NextTask.DateTime = False
              NextTask.Name = 'NextTask'
              NextTask.Multiplier = 1.000000000000000000
              NextTask.Order = loNone
            end
          end
          object pnlDatelineTopSpacer: TORAutoPanel
            Left = 0
            Top = 0
            Width = 20
            Height = 30
            Align = alLeft
            BevelOuter = bvNone
            TabOrder = 1
          end
        end
      end
      object memTop: TMemo
        Left = 576
        Top = 0
        Width = 1
        Height = 249
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
      Top = 252
      Width = 592
      Height = 98
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object splItemsBottom: TSplitter
        Left = 148
        Top = 0
        Width = 2
        Height = 98
        AutoSnap = False
        Beveled = True
        MinSize = 15
        OnMoved = splItemsBottomMoved
      end
      object pnlItemsBottom: TPanel
        Left = 0
        Top = 0
        Width = 148
        Height = 98
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 0
        object pnlItemsBottomInfo: TPanel
          Left = 0
          Top = 0
          Width = 148
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
            ExplicitHeight = 25
          end
          object bvlTopRight: TBevel
            Left = 146
            Top = 0
            Width = 2
            Height = 22
            Align = alRight
            Visible = False
            ExplicitHeight = 25
          end
          object chkItemsBottom: TCheckBox
            Left = 39
            Top = 2
            Width = 105
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
          Width = 148
          Height = 76
          ActivePage = tsBottomItems
          Align = alClient
          TabOrder = 1
          object tsBottomItems: TTabSheet
            Caption = 'Items'
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitWidth = 0
            ExplicitHeight = 0
            object lvwItemsBottom: TListView
              Left = 0
              Top = 0
              Width = 140
              Height = 48
              Align = alClient
              BevelInner = bvNone
              BevelOuter = bvNone
              Columns = <
                item
                  Caption = 'Item'
                  Width = 100
                end
                item
                  Caption = 'Type'
                  Width = 60
                end
                item
                  Caption = 'View'
                  Width = 40
                end
                item
                  Caption = 'Classification'
                end
                item
                  Caption = 'Remote Location'
                  Width = 150
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
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitWidth = 0
            ExplicitHeight = 0
            object splViewsBottom: TSplitter
              Left = 0
              Top = 45
              Width = 140
              Height = 2
              Cursor = crVSplit
              Align = alBottom
              OnMoved = splViewsTopMoved
              ExplicitTop = 25
            end
            object lstViewsBottom: TORListBox
              Left = 0
              Top = 0
              Width = 140
              Height = 45
              Align = alClient
              ItemHeight = 13
              ParentShowHint = False
              ShowHint = False
              TabOrder = 0
              OnEnter = lstViewsBottomEnter
              ItemTipColor = clWindow
              LongList = False
              Pieces = '2'
              OnChange = lstViewsBottomChange
            end
            object memViewsBottom: TRichEdit
              Left = 0
              Top = 47
              Width = 140
              Height = 1
              Align = alBottom
              Color = clCream
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
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
            Caption = 'Custom'
            ImageIndex = 2
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitWidth = 0
            ExplicitHeight = 0
          end
        end
      end
      object pnlBottomRightPad: TPanel
        Tag = 50
        Left = 577
        Top = 0
        Width = 15
        Height = 98
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 1
      end
      object pnlScrollBottomBase: TPanel
        Left = 150
        Top = 0
        Width = 426
        Height = 98
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 2
        object pnlBlankBottom: TPanel
          Left = 0
          Top = 0
          Width = 426
          Height = 68
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 2
          Visible = False
        end
        object pnlDatelineBottom: TPanel
          Left = 0
          Top = 68
          Width = 426
          Height = 30
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 1
          object chartDatelineBottom: TChart
            Left = 20
            Top = 0
            Width = 406
            Height = 30
            AllowPanning = pmNone
            BackWall.Brush.Color = clWhite
            BackWall.Brush.Style = bsClear
            BackWall.Pen.Visible = False
            Gradient.EndColor = clGradientActiveCaption
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
            Legend.Alignment = laBottom
            Legend.Color = clCream
            Legend.LegendStyle = lsSeries
            Legend.ShadowSize = 1
            Legend.Visible = False
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
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 0
            OnDblClick = mnuPopGraphDetailsClick
            OnMouseDown = chartBaseMouseDown
            OnMouseUp = chartBaseMouseUp
            object serDatelineBottom: TGanttSeries
              ColorEachPoint = True
              Marks.ArrowLength = 0
              Marks.Visible = False
              SeriesColor = clRed
              ShowInLegend = False
              OnGetMarkText = serDatelineTopGetMarkText
              Pointer.InflateMargins = True
              Pointer.Style = psRectangle
              Pointer.Visible = True
              XValues.DateTime = True
              XValues.Name = 'Start'
              XValues.Multiplier = 1.000000000000000000
              XValues.Order = loAscending
              YValues.DateTime = False
              YValues.Name = 'Y'
              YValues.Multiplier = 1.000000000000000000
              YValues.Order = loNone
              StartValues.DateTime = True
              StartValues.Name = 'Start'
              StartValues.Multiplier = 1.000000000000000000
              StartValues.Order = loAscending
              EndValues.DateTime = True
              EndValues.Name = 'End'
              EndValues.Multiplier = 1.000000000000000000
              EndValues.Order = loNone
              NextTask.DateTime = False
              NextTask.Name = 'NextTask'
              NextTask.Multiplier = 1.000000000000000000
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
          Width = 426
          Height = 68
          Align = alClient
          BevelInner = bvNone
          BorderStyle = bsNone
          Color = clBtnFace
          ParentColor = False
          TabOrder = 0
        end
      end
      object memBottom: TMemo
        Left = 576
        Top = 0
        Width = 1
        Height = 98
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
    object mnuTest: TMenuItem
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
